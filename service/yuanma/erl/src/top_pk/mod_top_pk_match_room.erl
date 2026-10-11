%%-----------------------------------------------------------------------------
%% @Module  :       mod_top_pk_match_room.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-06
%% @Description:    
%%-----------------------------------------------------------------------------

-module(mod_top_pk_match_room).

-include("common.hrl").
-include("top_pk.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("activitycalen.hrl").
-include("predefine.hrl").
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export([
	start_link/0
	, act_start/1
	, enter_match/3
	, cancel_match/2
	, create_battle/2
	, get_act_info/1
	, gm_start/1
	, send_to_all_act_info/0
]).

-record(state, {
	start_time = 0,
	end_time = 0,
	end_ref = undefined,
	match_ref = undefined,
	match_queue = []
}).


-define(SERVER, ?MODULE).
-define(MATCH_TIME_SPACE_MS, 5000).  %%匹配时间间隔
-define(MATCH_TIME, 25).
-define(MATCH_STEP, 2).
%% API
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

act_start(Args) ->
%%	?MYLOG("cym", "Start Args ~p~n", [Args]),
	gen_server:cast(?SERVER, {act_start, Args}).

enter_match(Node, RoleId, Args) ->
	gen_server:cast(?SERVER, {enter_match, Node, RoleId, Args}).

cancel_match(Node, RoleId) ->
	gen_server:cast(?SERVER, {cancel_match, Node, RoleId}).
%%弃用
create_battle(Role1, Role2) ->
	gen_server:cast(?SERVER, {create_battle, Role1, Role2}).

get_act_info(Sid) ->
	gen_server:cast(?SERVER, {get_act_info, Sid}).

send_to_all_act_info() ->
	gen_server:cast(?SERVER, {send_to_all_act_info}).

gm_start(Time) ->
	gen_server:cast(?SERVER, {gm_start, Time}).

%% private
init([]) ->
	case config:get_cls_type() of
		?NODE_GAME ->
			case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_TOPPK, 0) of
				{ok, ActId} ->
					State = init_act(ActId);
				_ ->
					% ?PRINT("init none~n", []),
					State = #state{}
			end,
			{ok, State};
		_ ->
			{ok, #state{}}
	end.

handle_call(Msg, From, State) ->
	case catch do_handle_call(Msg, From, State) of
		{'EXIT', Error} ->
			?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
			{reply, error, State};
		Return ->
			Return
	end.

handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		{'EXIT', Error} ->
			?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
			{noreply, State};
		Return ->
			Return
	end.

handle_info(Info, State) ->
	case catch do_handle_info(Info, State) of
		{'EXIT', Error} ->
			?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
			{noreply, State};
		Return ->
			Return
	end.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

terminate(_Reason, _State) ->
	?ERR("~p is terminate:~p", [?MODULE, _Reason]),
	ok.

do_handle_call(_Msg, _From, State) ->
	{reply, ok, State}.

do_handle_cast({get_act_info, Sid}, State) ->
	#state{start_time = StartTime, end_time = EndTime} = State,
	Now = utime:unixtime(),
	if
		StartTime =< Now andalso Now =< EndTime ->
			IsOpen = 1;
		true ->
			IsOpen = 0
	end,
%%	?MYLOG("cym", "IsOpen ~p, StartTime ~p, EndTime ~p~n", [IsOpen, StartTime, EndTime]),
	lib_server_send:send_to_sid(Sid, pt_281, 28107, [IsOpen, StartTime, EndTime]),
	{noreply, State};

do_handle_cast({send_to_all_act_info}, State) ->
	#state{start_time = StartTime, end_time = EndTime} = State,
	Now = utime:unixtime(),
	if
		StartTime =< Now andalso Now =< EndTime ->
			IsOpen = 1;
		true ->
			IsOpen = 0
	end,
%%	?MYLOG("cym", "IsOpen ~p, StartTime ~p, EndTime ~p~n", [IsOpen, StartTime, EndTime]),
	{ok, Bin} = pt_281:write(28107, [IsOpen, StartTime, EndTime]),
	lib_server_send:send_to_all(Bin),
	{noreply, State};

do_handle_cast({act_start, Args}, State) ->
	Now = utime:unixtime(),
	if
		State#state.start_time =< Now andalso Now =< State#state.end_time ->
			NewState = State;
		true ->
			clear_old_state(State),
			
			NewState = init_act(Args)
	end,
%%	?MYLOG("cym", "Start Args ~p~n", [Args]),
	{noreply, NewState};

do_handle_cast({enter_match, Node, RoleId, Args}, State) ->
	NowTime = utime:unixtime(),
	if
		State#state.start_time =< NowTime andalso NowTime < State#state.end_time ->
			#state{match_queue = MatchQueue, match_ref = MatchRef} = State,
			RoleKey = {Node, RoleId},
			case lists:keyfind(RoleKey, #match_info.role_key, MatchQueue) of
				false ->
					[GradeNum, Point, Platform, ServNum, RoleName, Power, RankLv] = Args,
					Info = #match_info{role_key = RoleKey, grade_num = GradeNum, point = Point,
						match_time = NowTime, match_step = 0, platform = Platform, serv_num = ServNum, name = RoleName, power = Power, rank_lv = RankLv},
					%%插入排序，从小到大
					{_, NewMatchQueue} = ulists:sorted_insert(fun queue_sort/2, Info, MatchQueue),
					?MYLOG("cym", "NewMatchList ~p~n", [NewMatchQueue]),
					NewState = State#state{match_queue = NewMatchQueue},
					%%设置锁，和失败事件
					player_apply_cast(Node, RoleId, lib_top_pk, set_player_match_start, [node()]),
					{ok, BinData} = pt_281:write(28110, [?SUCCESS]),
					send_msg(Node, RoleId, BinData),
					if
						is_reference(MatchRef) =:= false ->
							do_handle_info({timeout, MatchRef, match}, NewState); %%开始匹配
						true ->
							{noreply, NewState}
					end;
				_ ->
					player_apply_cast(Node, RoleId, lib_top_pk, set_player_match_start, [node()]),
					send_error(Node, RoleId, ?ERRCODE(err281_match_repeat)),
					{noreply, State}
			end;
		true ->
			?MYLOG("cym", "err157_act_not_open ~n", []),
			?MYLOG("cym", "State ~p ~n", [State]),
			%send_error(Node, RoleId, ?ERRCODE(err157_act_not_open)),
			{ok, BinData} = pt_281:write(28110, [?ERRCODE(err157_act_not_open)]),
			send_msg(Node, RoleId, BinData),
			{noreply, State}
	end;

do_handle_cast({cancel_match, Node, RoleId}, State) ->
	#state{match_queue = MatchQueue} = State,
	NewMatchQueue = lists:keydelete({Node, RoleId}, #match_info.role_key, MatchQueue),
	{ok, BinData} = pt_281:write(28114, [?SUCCESS]),
	send_msg(Node, RoleId, BinData),
	{noreply, State#state{match_queue = NewMatchQueue}};

do_handle_cast({create_battle, Role1, Role2}, State) ->
	lib_top_pk:create_battle(Role1, Role2),
	{noreply, State};

do_handle_cast({gm_start, Time}, State) ->
	Now = utime:unixtime(),
	if
		State#state.start_time =< Now andalso Now =< State#state.end_time ->
			NewState = State;
		true ->
			clear_old_state(State),
			NewState = start(Now, Now, Now + Time)
	end,
	{noreply, NewState};
do_handle_cast(_Msg, State) ->
	{noreply, State}.

do_handle_info({timeout, TimerRef, act_end}, #state{end_ref = TimerRef} = State) ->
	NewState = act_end(State),
	{noreply, NewState};

do_handle_info({timeout, TimerRef, match}, #state{match_ref = TimerRef, match_queue = OldMatchQueue} = State) ->
	case OldMatchQueue of
		[] ->
			{noreply, State#state{match_ref = undefined}};
		_ ->
			Ref = erlang:start_timer(?MATCH_TIME_SPACE_MS, self(), match),  %%开始匹配
			NewState = do_match(State),
			{noreply, NewState#state{match_ref = Ref}}
	end;

do_handle_info(_Msg, State) ->
	{noreply, State}.

init_act(ActId) ->
	Act = data_activitycalen:get_ac(?MOD_TOPPK, 0, ActId),
	#base_ac{time_region = TimeRegion} = Act,
	{_NowDay, {NowH, NowM, _}} = calendar:local_time(),
	Now = NowH * 60 + NowM,
	ZeroAclock = utime:unixdate(),
	NowTime = utime:unixtime(),
	case ulists:find(fun
		({{SH, SM}, {EH, EM}}) ->
			SH * 60 + SM =< Now andalso Now =< EH * 60 + EM
	end, TimeRegion) of
		{ok, {{SH, SM}, {EH, EM}}} ->
			StartTime = ZeroAclock + SH * 3600 + SM * 60,
			EndTime = ZeroAclock + EH * 3600 + EM * 60,
			start(NowTime, StartTime, EndTime);  %%满足时间条件则开始
		_ ->
			#state{}
	end.

act_end(State) ->
	lib_activitycalen_api:success_end_activity(?MOD_TOPPK),
	OpenLv = data_top_pk:get_kv(default, open_lv),
	{ok, BinData} = pt_281:write(28107, [0, 0, 0]),
	lib_server_send:send_to_all(all_lv, {OpenLv, 65535}, BinData),
	lib_chat:send_TV({all}, ?MOD_TOPPK, 2, []),
	clear_old_state(State).

clear_old_state(State) ->
	#state{match_ref = MatchRef, match_queue = TimeOutList} = State,
	util:cancel_timer(MatchRef),
	handle_timeout_list(TimeOutList),
	State#state{match_ref = undefined}.

queue_sort(#match_info{rank_lv = RankLvA, point = PointA},
	#match_info{rank_lv = RankLvB, point = PointB}) ->
	RankLvA < RankLvB orelse (RankLvA =:= RankLvB andalso PointA < PointB).

send_error(Node, RoleId, Code) ->
	{ErrInt, ErrArgs} = util:parse_error_code(Code),
	{ok, BinData} = pt_281:write(28100, [ErrInt, ErrArgs]),
	send_msg(Node, RoleId, BinData).

send_msg(Node, RoleId, BinData) ->
	if
		Node =:= node() ->
			lib_server_send:send_to_uid(RoleId, BinData);
		true ->
			rpc:cast(Node, lib_server_send, send_to_uid, [RoleId, BinData])
	end.

player_apply_cast(Node, RoleId, Mod, Fun, Args) ->
	if
		Node =:= node() ->
			lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, Mod, Fun, Args);
		true ->
			rpc:cast(Node, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, Mod, Fun, Args])
	end.

do_match(State) ->
	#state{match_queue = MatchQueue} = State,
	{Pairs, NewMatchQueue, TimeOutList} = calc_match(MatchQueue, [], [], []),
	?MYLOG("cym", "~p, ~p,~p ~n", [Pairs, NewMatchQueue, TimeOutList]),
	create_pairs(Pairs),
	handle_timeout_list(TimeOutList),
	State#state{match_queue = NewMatchQueue}.

%%a，第一步：先筛选全平台所有同段位玩家，该部分可匹配玩家（未进入战斗）数量 > 0，则进入第二步, 数量 = 0,则跳到f
%%b，第二步：在所有同段位玩家中，根据战力差距进行匹配，匹配最大时间为25s
%%c，第三步：活动开始后服务端每5s 进行一次全员筛选匹配，将双向条件满足的玩家送上车
%%	1）玩家第一次被检测，筛选战力差距5%以内对手，找不到则等待下一次检测
%%	2）玩家第二次被检测，筛选战力差距10%以内对手，找不到则等待下一次检测
%%	3）玩家第三次被检测，筛选战力差距25%以内对手，找不到则等待下一次检测
%%	4）玩家第四次被检测，筛选战力差距50%以内对手，找不到则等待下一次检测
%%	5）玩家第五次被检测，无视战力差距进行匹配
%%	6）玩家第五次被检测依旧找不到合适对手，直接匹配AI战斗
%%d，同战力对手则选择积分最靠近者，积分也相同则直接随机其一
%%e，匹配到合适对手则直接拉入战斗场景开始战斗，不用等到30s倒计时完毕
%%f，假如在第一步中平台同段位玩家 可匹配玩家人数 为0 ，则把段位范围扩大到相邻的上下段位，以此类推，都找不到一个人时，则直接匹配AI战斗

%% 特殊段位为青铜段位，在第一步中同段位找不到其他玩家，不扩大段位范围筛选，直接匹配AI战斗
calc_match([One | MatchQueue], Pairs, FailMatchQueue, TimeOutList) ->
	#match_info{match_step = StepOne} = One,
	Res = calc_match_help(One, MatchQueue),
	?MYLOG("cym", "Res ~p~n", [Res]),
	case Res of
		time_out -> %特殊情况，ai战斗， 或者第五次检查，找不到合适的对手战斗
			calc_match(MatchQueue, Pairs, FailMatchQueue, [One | TimeOutList]);
		fail ->    %匹配失败
			calc_match(MatchQueue, Pairs, [One#match_info{match_step = StepOne + 1} | FailMatchQueue], TimeOutList);
		{ok, {Pairs1, Pairs2}, NewMatchQueue} -> %%匹配成功
			calc_match(NewMatchQueue, [[Pairs1, Pairs2] | Pairs], FailMatchQueue, TimeOutList);
		Err ->
			?MYLOG("cym", "err ~p~n", [Err])
	end;
%%	if
%%		Step =< StepOne orelse Step =< StepTwo ->
%%			calc_match(MatchQueue, [[One, Two] | Pairs], FailMatchQueue, TimeOutList);
%%		true ->
%%			NowTime = utime:unixtime(),
%%			if
%%				NowTime - TimeOne > ?MATCH_TIME ->
%%					calc_match([Two | MatchQueue], Pairs, FailMatchQueue, [One | TimeOutList]);
%%				true ->
%%					calc_match([Two | MatchQueue], Pairs, [One#match_info{match_step = StepOne + ?MATCH_STEP} | FailMatchQueue], TimeOutList)
%%			end
%%	end;


calc_match([], Pairs, FailMatchQueue, TimeOutList) ->
	{Pairs, lists:reverse(FailMatchQueue), TimeOutList}.

create_pairs([[One, Two] | Pairs]) ->
	#match_info{role_key = {_Node1, _} = Key1, platform = Platform1, serv_num = ServNum1,
		name = RoleName1, grade_num = GradeNum1, rank_lv = RankLv1, point = Point1} = One,
	#match_info{role_key = {_Node2, _} = Key2, platform = Platform2, serv_num = ServNum2,
		name = RoleName2, grade_num = GradeNum2, rank_lv = RankLv2, point = Point2} = Two,
	lib_top_pk:create_battle({Key1, [Platform1, ServNum1, RoleName1, GradeNum1, RankLv1, Point1]},
		{Key2, [Platform2, ServNum2, RoleName2, GradeNum2, RankLv2, Point2]}),
	create_pairs(Pairs);

create_pairs([]) ->
	ok.

handle_timeout_list([One | TimeOutList]) ->
	#match_info{role_key = {Node, RoleId}} = One,
	%%假人竞技
	player_apply_cast(Node, RoleId, lib_top_pk, handle_match_timeout, [One]),
	handle_timeout_list(TimeOutList);

handle_timeout_list([]) ->
	ok.

start(NowTime, StartTime, EndTime) ->
	EndDelay = max(EndTime - NowTime, 1),
	EndRef = erlang:start_timer(EndDelay * 1000, self(), act_end),  %% 结束定时器
	case util:is_cls() of
		true ->
			mod_clusters_center:apply_to_all_node(lib_top_pk, act_start_succ, [StartTime, EndTime]);
		_ ->
			lib_activitycalen_api:success_start_activity(?MOD_TOPPK),
			lib_chat:send_TV({all}, ?MOD_TOPPK, 1, []),
			% ?PRINT("init_act ~p~n", [[StartTime, EndTime]]),
			OpenLv = data_top_pk:get_kv(default, open_lv),
			{ok, BinData} = pt_281:write(28107, [1, StartTime, EndTime]),
			lib_server_send:send_to_all(all_lv, {OpenLv, 65535}, BinData)
	end,
	#state{start_time = StartTime, end_time = EndTime, end_ref = EndRef}.

%% -----------------------------------------------------------------
%% @desc     功能描述   MatchQueue 寻找符合One的对手
%% @param    参数       One::#match_info{}, MatchQueue::[#match_info{}]
%% @return   返回值     time_out | {ok, {One, Two}, MatchQueue} | fail
%% @history  修改历史
%% -----------------------------------------------------------------
calc_match_help(#match_info{match_step = Step, grade_num = ?rank_iron}, _MatchQueue) when Step >= 1 -> %%黑铁段位找不到对手，直接ai
	time_out;
calc_match_help(One, MatchQueue) ->
	calc_match_help(One, [], MatchQueue).


calc_match_help(#match_info{grade_num = ?rank_iron}, _Acc, []) -> %%黑铁段位找不到对手，直接ai
	?MYLOG("cym", "++++++++++ time_out ~n", []),
	time_out;
calc_match_help(#match_info{match_step = Step}, _Acc, []) when Step >= 4 -> %%第五次匹配，找不到对手，ai
	?MYLOG("cym", "++++++++++ time_out ~n", []),
	time_out;
calc_match_help(_P1, _Acc, []) -> %%匹配失败
	?MYLOG("cym", "++++++++++ fail ~n", []),
	fail;
calc_match_help(P1, Acc, [H | MatchQueue]) ->
	?MYLOG("cym", "++++++++++ try to match ~n", []),
	#match_info{match_step = Step1, grade_num = Rank1, power = Power1} = P1,
	#match_info{match_step = Step2, grade_num = Rank2, power = Power2} = H,
	%%检查1的条件
	%%段位差距
	DiffRank = abs(Rank1 - Rank2),
	%%战力差距
	DiffPower1 = abs(Power1 - Power2) / Power1,
	DiffPower2 = abs(Power1 - Power2) / Power2,
	%%允许战力最大差距
	DiffPowerMax1 = get_diff_power_by_step(Step1 + 1),
	DiffPowerMax2 = get_diff_power_by_step(Step2 + 1),
	%%赛季一周后，不需要考虑战力，同段位就行
	IgnorePower = is_ignore_power(),
	if
	%%第一步的时候段位差距为0， 第二步段位差距为1，如此类推
		DiffRank > Step1 ->  %%单位差距天大，后面的列表差距更大，所以后面的列表不用比较
			fail;
		DiffRank =< Step2 andalso IgnorePower == true ->  %% %%满足2的段位差距，满足1的段位差距，且可以忽视战力
			{ok, {P1, H}, lists:reverse(Acc, MatchQueue)};
		DiffPower1 > DiffPowerMax1 -> %%战斗力差距太大, 计算下一个
			calc_match_help(P1, [H | Acc], MatchQueue);
		true ->  %%满足P1的战力，段位差距
			if
				DiffRank =< Step2 andalso DiffPower2 =< DiffPowerMax2 -> %%满足2的段位，战力差距
					{ok, {P1, H}, lists:reverse(Acc, MatchQueue)};
				true -> %%不满足2的差距
					calc_match_help(P1, [H | Acc], MatchQueue)
			end
	end.

%%通过步数来获得战力差距范围
get_diff_power_by_step(Step) ->
	case Step of
		1 ->
			0.05;
		2 ->
			0.1;
		3 ->
			0.25;
		4 ->
			0.5;
		_ ->
			16#FFFFFFFF
	end.

%% 是否可以忽略战力 ，赛季一周之后就可以忽视战力, 即每个月的8号之后就忽视战力
is_ignore_power() ->
	Day = utime:day_of_month(),
	if
		Day >= 8 ->
			true;
		true ->
			false
	end.






























