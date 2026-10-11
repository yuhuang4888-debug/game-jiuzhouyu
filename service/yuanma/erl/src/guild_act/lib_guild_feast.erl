%%-----------------------------------------------------------------------------
%% @Module  :       lib_guild_feast
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-05
%% @Description:    公会晚宴
%%-----------------------------------------------------------------------------
-module(lib_guild_feast).

-include("guild_feast.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("def_goods.hrl").
-include("guild.hrl").
-include("drop.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("attr.hrl").
-include("errcode.hrl").
-include("mini_game.hrl").

%%-export([
%%	is_open/0
%%	, quest_calc_reward/1
%%	, send_to_all_fire_by_guild/2
%%	, reflush_fire_by_guild/1
%%	, get_fire_list_by_role_num/1
%%	, get_reward_by_type/1
%%	, get_next_time/1
%%	, refresh_rank/1
%%%%	, pack_gfeast_rank/2
%%	, act_close/1
%%%%	, count_exp_reward/1
%%	, count_donate_reward/1
%%	, is_gfeast_scene/1
%%	, send_point_reward/1
%%	, buy_dragon_spirit/4
%%	, send_gift/2
%%]).

-compile(export_all).

is_open() ->
	NowTime = utime:unixtime(),
	case get_next_time(NowTime) of
		{_, ?ACT_STATUS_OPEN, _, _} ->
			true;
		_ ->
			false
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述       %%获取一下状态信息
%% @param    参数           %%NowTime::integer  当前时间戳
%% @return   返回值           StatusName::atom 状态名称,
%%                           Status::integer  状态,
%%                           CountDownTime::integer  宴会剩余秒数,  整个宴会剩余秒数
%%                           NowTime + CountDownTime::integer  宴会结束时间戳;
%% @history  修改历史
%% -----------------------------------------------------------------
get_next_time(NowTime) ->
	NowWeek = utime:day_of_week(NowTime),   %%今天星期几
	Unixdate = utime:unixdate(NowTime),     %%当天0点时间戳
	OpTime = util:get_open_time(),          %%开服时间
	OpUnixdate = utime:unixdate(OpTime),    %%开服0点时间戳
	WeekL = data_guild_feast:get_cfg(open_week),  %%  开放周数
	TimeL = data_guild_feast:get_cfg(open_time),  %% 开放时间段
	OpdayLimit = data_guild_feast:get_cfg(opday_lim),  %%开服天数限制
	MergeDayLimit = data_guild_feast:get_cfg(merge_day_lim),  %%合服天数限制
	Duration = data_guild_feast:get_cfg(duration),  %%宴会持续时间
	ExitTime = data_guild_feast:get_cfg(exit_time),  %%退出倒计时
	Opday = (Unixdate - OpUnixdate) div 86400 + 1, %% 因为是0点检测一次,所以这里取的开服天数是以0点来算的
	MergeDay = util:get_merge_day(NowTime),        %%获得合服天数
	SpecialOpdayL = data_guild_feast:get_cfg(special_open_day),  %%合服第几天开启， 特殊天数
	InSpecialDay = lists:member(Opday, SpecialOpdayL),  %%今天是否是特殊天数
	OpOrMerLim = case util:is_merge_game() of           %%判断是否超出了限制
		             true ->
			             MergeDay < MergeDayLimit;
		             _ ->
			             Opday < OpdayLimit
	             end,
	if
		not InSpecialDay andalso OpOrMerLim ->    %%不是特殊天数，而且超出了限制
			%%                         限达到下一个0的所需的时间戳     下个0点时间戳
			{close, ?ACT_STATUS_CLOSE, Unixdate + 86401 - NowTime, Unixdate + 86401};
		true ->
			case InSpecialDay orelse lists:member(NowWeek, WeekL) of
				true ->
					{StatusName, Status, CountDownTime}
						= do_get_next_time(format_time(TimeL), Duration, ExitTime, NowTime - Unixdate),
%%					?DEBUG("CountTimes ~p~n", [CountDownTime]),
					{StatusName, Status, CountDownTime, NowTime + CountDownTime};
				false ->
					{close, ?ACT_STATUS_CLOSE, Unixdate + 86401 - NowTime, Unixdate + 86401}
			end
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述  获取状态
%% @param    参数      Duration::integer 宴会持续时间
%%                     ExitTime::integer 退出倒计时
%%                     NowDuration::integer 从0点到现在的秒数
%% @return   返回值    {状态名称(原子),  状态(integer), 剩余时间(秒数)}
%% @history  修改历史
%% -----------------------------------------------------------------
do_get_next_time([], _Duration, _ExitTime, NowDuration) ->
	{close, ?ACT_STATUS_CLOSE, 86400 - NowDuration + 1};    %%点的时候在计算一下
do_get_next_time([T | L], Duration, ExitTime, NowDuration) ->
	if
		NowDuration < T ->            %%还没有到时间
			{close, ?ACT_STATUS_CLOSE, T - NowDuration + 1};
		NowDuration >= T andalso NowDuration < T + Duration ->            %%活动正在开启
			{open, ?ACT_STATUS_OPEN, T + Duration - NowDuration};         %% 如果是开启活动的时候 T ==  NowDuration  ，所以剩余秒数 = Duration
		NowDuration >= T + Duration andalso NowDuration < T + Duration + ExitTime ->    %%退出中    ， 现在基本不会有这种状态了
			{close, ?ACT_STATUS_EXIT, T + Duration + ExitTime - NowDuration};
		true ->
			do_get_next_time(L, Duration, ExitTime, NowDuration)
	end.

format_time(TimeL) ->
	[H * 3600 + M * 60 + S || {H, M, S} <- TimeL].

refresh_rank(List) ->  %%针对的是
	F = fun(A, B) ->
		if
			A#gfeast_guild_rank_info.score == B#gfeast_guild_rank_info.score ->
				A#gfeast_guild_rank_info.utime < B#gfeast_guild_rank_info.utime;
			true ->
				A#gfeast_guild_rank_info.score > B#gfeast_guild_rank_info.score
		end
	    end,
	SortList = lists:sort(F, List),
	F1 = fun(T, {Ranking, Acc}) ->
		NewT = T#gfeast_guild_rank_info{rank_no = Ranking},
		{Ranking + 1, [NewT | Acc]}
	     end,
	{_, RankL} = lists:foldl(F1, {1, []}, SortList),
	lists:reverse(RankL).

%%refresh_rank(List) ->
%%	F = fun(A, B) ->
%%		if
%%			A#rank.score == B#rank.score ->
%%				A#rank.utime < B#rank.utime;
%%			true ->
%%				A#rank.score > B#rank.score
%%		end
%%	end,
%%	SortList = lists:sort(F, List),
%%	Len = data_guild_feast:get_cfg(rank_num),
%%	SubList = lists:sublist(SortList, Len),
%%	F1 = fun(T, {Ranking, Acc}) ->
%%		NewT = T#rank{rank_no = Ranking},
%%		{Ranking + 1, [NewT | Acc]}
%%	end,
%%	{_, RankL} = lists:foldl(F1, {1, []}, SubList),
%%	lists:reverse(RankL).

act_close(State) ->
	#status_gfeast{
		gfeast_guild = GFeastGuilds,
		quiz_ref = QuizRef,
		can_summon_ref = CanSummonRef,
		stage_ref = StageRef} = State,
	util:cancel_timer(QuizRef),
	util:cancel_timer(CanSummonRef),
	util:cancel_timer(StageRef),
%%
	%% 关闭所有的答题进程
	F = fun
		    (#gfeast_guild{pre_dragon_ref = PreDragonRef,
			    enter_dragon_ref = EnterDragonRef, dragon_time_out_ref = DragonTimeOutRef, quiz_pid = QuizPid}) ->
			    %%取消所有定时器
			    util:cancel_timer(PreDragonRef),
			    util:cancel_timer(EnterDragonRef),
			    case is_pid(QuizPid) of
					true ->
						gen_statem:stop(QuizPid);
					_ ->
						false
			    end,
			    util:cancel_timer(DragonTimeOutRef);
		    (_) ->
			    skip
	    end,
	lists:foreach(F, GFeastGuilds).
%%	NewGFeastGuildList = [ X#gfeast_guild{pre_dragon_ref = [], enter_dragon_ref = [], dragon_time_out_ref = []}|| X <- GFeastGuilds],
%%	State#status_gfeast{gfeast_guild = NewGFeastGuildList}.


count_donate_reward(_RoleLv) ->
	data_guild_feast:get_cfg(donate_plus).

%%get_gfeast_red_envelopes_id(RankNo) ->
%%	case RankNo of
%%		1 ->
%%			1;
%%		2 ->
%%			2;
%%		3 ->
%%			3;
%%		_ ->
%%			0
%%	end.

is_gfeast_scene(Scene) ->
	SceneId = data_guild_feast:get_cfg(scene_id),
	SceneId == Scene.

%% -----------------------------------------------------------------
%% @desc     功能描述 获取奖励
%% @param    参数     Type::integer 1：经验， 2：贡献
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_reward_by_type(Type) when Type == 1 ->
	List = data_guild_feast:get_cfg(gfeast_reward),
	if
		is_list(List) ->
			RewardList = [{TempType, SubType, Num} || {TempType, SubType, Num} <- List, TempType == ?TYPE_EXP];
		true ->
			RewardList = []
	end,
	RewardList;
get_reward_by_type(Type) when Type == 2 ->
	List = data_guild_feast:get_cfg(gfeast_reward),
	if
		is_list(List) ->
			RewardList = [{TempType, SubType, Num} || {TempType, SubType, Num} <- List, TempType == ?TYPE_GDONATE];
		true ->
			RewardList = []
	end,
	RewardList;
get_reward_by_type(_Type) ->
	[].


%% -----------------------------------------------------------------
%% @desc     功能描述  获得火苗列表
%% @param    参数     Num::integer 人数
%% @return   返回值   [{fire_id, color}]
%% @history  修改历史
%% -----------------------------------------------------------------
get_fire_list_by_role_num(_Num, _GuildId) when _Num =< 0 ->
	[];
get_fire_list_by_role_num(Num, GuildId) ->
	%%获得生成池
	case data_guild_feast:get_fire_pool(Num) of
		[] ->
			[];
		FirePool ->
			#guild_fire_pool{fire_num_pool = NumPool, blue_fire_pool = TempBlue, purple_fire_pool = TempPurple} = FirePool,
			%%数量抽奖
			{FireNum, _} = util:find_ratio(NumPool, 2),
			%%是否会生成蓝色火苗
			[{BlueRatio, BlueNumPool}] = TempBlue,
			[{PurpleRatio, PurpleNumPool}] = TempPurple,
			{IsBlue, _} = util:find_ratio([{true, BlueRatio}, {false, (100 - BlueRatio)}], 2),  %%是否有蓝色火苗
			{IsPurple, _} = util:find_ratio([{true, PurpleRatio}, {false, (100 - PurpleRatio)}], 2), %%是否有紫色火苗
			BlueNum =
				case IsBlue of
					true ->
						{V1, _} = util:find_ratio(BlueNumPool, 2),
						V1;
					false ->
						0
				end,
			PurperNum =
				case IsPurple of
					true ->
						{V2, _} = util:find_ratio(PurpleNumPool, 2),
						V2;
					false ->
						0
				end,
			WNum = FireNum - BlueNum - PurperNum,   %%白色火苗数量
			TempXYList = data_guild_feast:get_cfg(small_fire_coord),
			XYList = ulists:list_shuffle(TempXYList),   %%随机打乱顺序
			%%1是白色品质, 2是蓝色， 3是紫色
			{FireList1, XYList1} = get_fire_list_by_role_num([], WNum, ?white_fire, XYList, GuildId),  %%生成白色火苗
			{FireList2, XYList2} = get_fire_list_by_role_num(FireList1, BlueNum, ?blue_fire, XYList1, GuildId),  %%生成蓝色火苗
			{FireList3, _XYList3} = get_fire_list_by_role_num(FireList2, PurperNum, ?purple_fire, XYList2, GuildId),  %%生成紫色火苗
			?DEBUG("FireList:~p~n", [FireList3]),
			FireList3
	end.
%% -----------------------------------------------------------------
%% @desc     功能描述 生成火苗
%% @param    参数       List:list  结果列表
%%                      Num:最大id  StartNum:起始id
%%                      Color::integer   品质
%%                      XYList::[{x,y}]
%% @return   返回值      {[{fire_id, color}], XYlist}
%% @history  修改历史
%% -----------------------------------------------------------------
get_fire_list_by_role_num(List, Num, _Color, XYList, _GuildId) when Num == 0 ->
	{List, XYList};
get_fire_list_by_role_num(List, Num, Color, [{X, Y} | T], GuildId) ->
	ModCfgId = case Color of
		           ?white_fire ->  %%白色
			           data_guild_feast:get_cfg(white_fire_id);
		           ?blue_fire ->  %%蓝色
			           data_guild_feast:get_cfg(blue_fire_id);
		           ?purple_fire ->  %%紫色
			           data_guild_feast:get_cfg(purple_fire_id)
	           end,
	SceneId = data_guild_feast:get_cfg(scene_id),
	FireId = lib_mon:sync_create_mon(ModCfgId, SceneId, ?DEF_SCENE_PID, X, Y, 0, GuildId, 1, []),
	get_fire_list_by_role_num([{FireId, Color} | List], Num - 1, Color, T, GuildId).


%% -----------------------------------------------------------------
%% @desc     功能描述  刷新公会的火苗   获取人数->生成火苗列表->清空获得火苗玩家->发给每个用户->返回#gfest_guild{}
%% @param    参数      Guild::#gfeast_guild{}
%% @return   返回值    #gfeast_guild{}
%% @history  修改历史
%% -----------------------------------------------------------------
reflush_fire_by_guild(Guild) ->
	#gfeast_guild{role_list = RoleList, fire_wave = OldWave, guild_id = GuildId} = Guild,
	AllFire = data_guild_feast:get_cfg(fire_wave),
	if
		GuildId == 21474836489
			orelse GuildId == 21474836482
			orelse GuildId == 21474836484
			orelse GuildId == 21474836485
			orelse GuildId == 21474836491
			orelse GuildId == 21474836481 ->
			?INFO("OldWave ~p , AllFire ~p GuildId ~p~n", [OldWave, AllFire, GuildId]);
		true ->
			skip
	end,
	if
		OldWave >= AllFire ->
			Guild;
		true ->
			Num = erlang:length(RoleList),
			FireList = get_fire_list_by_role_num(Num, GuildId), %%火苗列表
			NowTiem = utime:unixtime(),
			AllWave = data_guild_feast:get_cfg(fire_wave),
			if
				GuildId == 21474836489
					orelse GuildId == 21474836482
					orelse GuildId == 21474836484
					orelse GuildId == 21474836485
					orelse GuildId == 21474836491
					orelse GuildId == 21474836481 ->
					?INFO("++++++++++send ~n", []);
				true ->
					skip
			end,
			NextTime =
				case OldWave + 1 >= AllWave of
					true ->
						0;
					_ ->
						NowTiem + data_guild_feast:get_cfg(fire_reflush_time)
				end,
			[lib_server_send:send_to_uid(RoleId, pt_402, 40256, [OldWave + 1, NextTime]) || RoleId <- RoleList], %%给每个用户发送信息
			Guild#gfeast_guild{fire_list = FireList, get_fire_list = [], fire_wave = OldWave + 1, next_fire_time = NextTime} %%清空获得火苗玩家
	end.



%% -----------------------------------------------------------------
%% @desc     功能描述   将火苗列表发送给同一个公会的人
%% @param    参数       FireList::list    [{fire_id, color}]
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
send_to_all_fire_by_guild(_FireList, Guild) ->
	#gfeast_guild{role_list = RoleList, fire_wave = Wave, next_fire_time = Time} = Guild,
	[lib_server_send:send_to_uid(RoleId, pt_402, 40256, [Wave, Time]) || RoleId <- RoleList].


%% -----------------------------------------------------------------
%% @desc     功能描述  清算奖励，发送奖励
%% @history  修改历史
%% -----------------------------------------------------------------
% quest_calc_reward(SortGuildList) ->
% 	[begin
% 		 mod_guild:apply_cast(lib_guild_feast, send_topic_reward_in_guild, [GuildId, Rank])
% 	 end ||
% 		#gfeast_guild_rank_info{guild_id = GuildId, rank_no = Rank} <- SortGuildList].

quest_calc_reward(GameType, #status_gfeast{guild_role_map = RoleMap, mini_game_rank = MiniGameRank}) ->
    MaxRank = data_guild_feast:get_max_rank(),
    case GameType of
        'quiz' ->
            F = fun({_, _, _, _, Rank}) -> Rank =< MaxRank end,
            RoleList = lib_guild_feast:sort_role_by_point(lists:flatten(maps:values(RoleMap))),
            RoleList1 = lists:filter(F, RoleList),
            lists:foreach(
            fun({RoleId, _, _, _, Rank}) ->
                lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_guild_feast, send_topic_reward_in_ps, [GameType, Rank])
            end,
            RoleList1);
        'note_crash' ->
            F = fun(#gfeast_rank_role{rank = Rank}) -> Rank =< MaxRank end,
            RewardRoles = lists:filter(F, MiniGameRank),
            F1 = fun(#gfeast_rank_role{role_id = RoleId, rank = Rank}) ->
                lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_guild_feast, send_topic_reward_in_ps, [GameType, Rank])
            end,
            lists:foreach(F1, RewardRoles)
    end.

%%	% ?DEBUG("cymfeast", "question  List ~p~n", [List]),
%%	NewList = [
%%		quest_calc_reward_helper(X, GuildId, No, Tid)
%%		|| X <- List],
%%%%	mod_guild_feast_mgr:send_dragon_point_by_guild(GuildId), %%发送龙魂信息
%%NewState = State#status_quiz{rank = 0, question_list = NewList}, %%重置rank
%%	NewState.


%% 排序，返回  [{GuildId, Name, Point, Time, Rank}] ,
sort_guild_by_point(GuildList) ->
	F = fun({_, _, PointA, TimeA}, {_, _, PointB, TimeB}) ->
		if
			PointA > PointB ->
				true;
			PointA < PointB ->
				false;
			true ->
				TimeA < TimeB
		end
	    end,
	SortGuildList = lists:sort(F, GuildList),
	sort_guild_point_set_rank(SortGuildList, 0, []).

sort_guild_point_set_rank([], _PreRank, AccList) ->
	lists:reverse(AccList);
sort_guild_point_set_rank([{GuildId, Name, Point, Time} | SortGuildList], PreRank, AccList) ->
	sort_guild_point_set_rank(SortGuildList, PreRank + 1, [{GuildId, Name, Point, Time, PreRank + 1} | AccList]).


%% 排序
%% @return [{RoleId, Name, Point, Time, Rank},...] | [{RoleId, Name, Point, Time, Rank, ServerId, ServerNum},...]
sort_role_by_point(RoleList) ->
	F = fun
    ({_, _, PointA, TimeA}, {_, _, PointB, TimeB}) ->
        (PointA > PointB) orelse (PointA == PointB andalso TimeA < TimeB);
    ({_, _, PointA, TimeA, _, _}, {_, _, PointB, TimeB, _, _}) ->
        (PointA > PointB) orelse (PointA == PointB andalso TimeA < TimeB)
	end,
	SortRoleList = lists:sort(F, RoleList),
	sort_role_point_set_rank(SortRoleList, 0, []).

sort_role_point_set_rank([], _PreRank, AccList) ->
	lists:reverse(AccList);
sort_role_point_set_rank([{RoleId, Name, Point, Time} | SortRoleList], PreRank, AccList) ->
	sort_role_point_set_rank(SortRoleList, PreRank + 1, [{RoleId, Name, Point, Time, PreRank + 1} | AccList]);
sort_role_point_set_rank([{RoleId, Name, Point, Time, SerId, SerNum} | SortRoleList], PreRank, AccList) ->
	sort_role_point_set_rank(SortRoleList, PreRank + 1, [{RoleId, Name, Point, Time, PreRank + 1, SerId, SerNum} | AccList]).

%% 将上面函数排序后的数据打包成40214的格式
pack_role_rank_info(RoleList, N) ->
    F = fun
        ({_, _, _, _, Rank}) -> Rank =< N;
        ({_, _, _, _, Rank, _, _}) -> Rank =< N
    end,
    RoleRankInfo = lists:filter(F, RoleList),
    F1 = fun
        ({_, RoleName, Point, _, Rank}) -> {0, 0, Rank, RoleName, Point};
        ({_, RoleName, Point, _, Rank, SerId, SerNum}) -> {SerId, SerNum, Rank, RoleName, Point}
    end,
    RoleRankInfo1 = lists:map(F1, RoleRankInfo),
    {ok, BinData} = pt_402:write(40214, [0, [], RoleRankInfo1]),
    BinData.

%% -----------------------------------------------------------------
%% @desc     功能描述  清算奖励   计算奖励 ->更新积分,龙魂->重设状态->返回
%% @param    参数      Msg::#question_msg{} No::第几题 Tid::题目id
%% @return   返回值    #question_msg{}
%% @history  修改历史
%% -----------------------------------------------------------------
quest_calc_reward_helper(Msg, GuildId, No, Tid) ->
%%	?DEBUG("Msg ~p  ~n", [Msg]),
	#question_msg{role_id = RoleId, role_name = RoleName, rank = Rank, combo = Combo} = Msg,
	NewMsg =
		case Rank of
			0 -> %%没答对,或者没答
				Msg#question_msg{status = 0};
			_ ->
				%%计算龙魂，答对一题5点龙魂 不计算龙魂了
				%%积分
				Point = data_guild_feast:get_question_point(Rank),
%%				?DEBUG("log1 ~n", []),
%%				DragonPoint = data_guild_feast:get_cfg(quiz_dragon_spirit),  不用发送龙魂了
				mod_guild_feast_mgr:right_answer(RoleId, RoleName, GuildId, Point, 0),
				GNonateReward = data_guild_feast:get_cfg(quiz_reward),
				%%combo奖励
				ComboReward =
					case data_guild_feast:get_combo_reward(Combo) of
						[] ->
							[];
						[V] ->
							V
					end,
%%				?MYLOG("cym", "ComboReward ~p", [ComboReward]),
				RewardList = GNonateReward ++ ComboReward,
				Produce = #produce{reward = RewardList, type = guild_feast_question},
				lib_log_api:log_role_guild_feast_quiz(RoleId, 1, Point, 0, Rank, RewardList, GuildId, No, Tid),
				lib_goods_api:send_reward_with_mail(RoleId, Produce),
				Msg#question_msg{rank = 0, status = 0}
		end,
	NewMsg.

%%%% -----------------------------------------------------------------
%%%% @desc     功能描述  积分榜发送奖励   旧版本 公会内的排行榜
%%%% @param    参数      Rank::#rank{}
%%%% @return   返回值    无
%%%% @history  修改历史
%%%% -----------------------------------------------------------------
%%send_point_reward(Rank) ->
%%	#rank{rank_no = RankNo, rold_id = RoleId} = Rank,
%%	case data_guild_feast:get_point_rank(RankNo) of
%%		[] ->
%%			ok;
%%		[RewardList] ->
%%			%%发送邮件
%%			?DEBUG("point reward ~p~n", [RewardList]),
%%			lib_mail_api:send_sys_mail([RoleId], "公会宴会", "恭喜您在公会宴会【答题】中积分排名第一，以下是您的奖励！", RewardList)
%%	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  积分榜发送奖励  本服的排行榜
%% @param    参数      Rank::#rank{}
%% @return   返回值    无
%% @history  修改历史
%% -----------------------------------------------------------------
send_point_reward(GameType, Rank) ->
	#gfeast_rank_info{rank_no = RankNo, role_id = RoleId, guild_id = GuildId} = Rank,
	case data_guild_feast:get_point_rank(GameType, RankNo) of
		[] ->
			ok;
		RewardList ->
			%%发送邮件
%%			?DEBUG("point reward ~p~n", [RewardList]),
			lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = RewardList, type = guild_quiz_rank_reward}),
			lib_log_api:log_role_guild_feast_quiz(RoleId, 2, 0, 0, RankNo, RewardList, GuildId, 0, 0)
%%			Content = io_lib:format("恭喜您在公会宴会【答题】中积分排名第~p，以下是您的奖励！", [RankNo]),
%%			lib_mail_api:send_sys_mail([RoleId], "公会宴会", Content, [])
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述 购买龙魂
%% @param    参数     RoleId::integer()  玩家id,
%%                    GuildId::integer() 公会id,
%%                    Num::integer() 龙魂数量，
%%                    Status::#player_status{}
%% @return   返回值    NewPs::#player_status{}
%% @history  修改历史
%% -----------------------------------------------------------------
buy_dragon_spirit(RoleId, GuildId, Num, Status) ->
	Cost =
		case data_guild_feast:get_cfg(dragon_spirit_cost) of
			[] ->
				[];
			0 ->
				[];
			[{Type, _, V}] ->
				[{Type, 0, V * Num}]
		end,
	case lib_goods_api:check_object_list(Status, Cost) of
		true ->
			case lib_goods_api:cost_object_list(Status, Cost, dragon_spirit, "dragon_spirit") of
				{true, NewPs} ->  %%消耗成功
					mod_guild_feast_mgr:add_dragon_spirit(GuildId, Num),  %% 增加龙魂
					NewPs;
				{false, Err, NewPs} ->  %% 失败，返回错误码
					{ok, Bin} = pt_402:write(40200, [Err]),
					lib_server_send:send_to_uid(RoleId, Bin),
					NewPs
			end;
		{false, Err} ->  %%失败，返回错误码
			{ok, Bin} = pt_402:write(40200, [Err]),
			lib_server_send:send_to_uid(RoleId, Bin),
			Status
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  发送礼包   用于cast gai
%% @param    参数      PS::player_status{}
%%                     GiftId::integer()  礼物id
%% @return   返回值    NewPS
%% @history  修改历史
%% -----------------------------------------------------------------
% send_gift(#player_status{sid = Sid, id = RoleId, guild = Guild} = PS, GiftId) ->
% 	#status_guild{id = GuildId} = Guild,
% 	case GiftId of
% 		-1 ->   %%找不到配置
% %%			RewardList = [],
% %%			?DEBUG("RewardList ~p~n", [RewardList]),
% %%			Produce = #produce{reward = RewardList, type = guild_feast_boss},
% %%			NewPs = lib_goods_api:send_reward(PS, Produce),
% 			mod_guild_feast_mgr:exit_scene(RoleId, GuildId),
% 			{ok, Bin} = pt_402:write(40200, ?MISSING_CONFIG),  %%通知客户端
% 			lib_server_send:send_to_sid(Sid, Bin),
% 			PS;
% 		_ ->
% 			RewardList = [{?TYPE_GOODS, GiftId, 1}],
% %%			Produce = #produce{reward = RewardList, type = guild_feast_boss},
% %%			NewPs = lib_goods_api:send_reward(PS, Produce),
% 			case lib_goods_do:give_more(RewardList) of
% 				{1, UpdateGoodsList, _RewardResult} ->
% 					[#goods{id = Id} | _T] = UpdateGoodsList,
% 					?DEBUG("giftkeyId ~p~n", [Id]),
% 					{ok, Bin} = pt_402:write(40262, [1, Id]),  %%通知客户端
% 					lib_server_send:send_to_sid(Sid, Bin);
% 				_ ->
% 					?DEBUG("giftkeyId ~n", []),
% 					{ok, Bin} = pt_402:write(40200, [?FAIL]),  %%通知客户端
% 					lib_server_send:send_to_sid(Sid, Bin)
% 			end,

% %%			mod_guild_feast_mgr:exit_scene(RoleId, GuildId),  %%不立刻离场
% 			PS
% 	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  返回新的Map
%% @param    参数    Map::#{roleId => Exp},  GuildList::#f
%% @return   返回值  NewMap
%% @history  修改历史
%% -----------------------------------------------------------------
get_new_exp_map(Map, GuildList, AddExp) ->
	%%获取全部roleList
	F = fun(#gfeast_guild{role_list = List} = _Guild, RoloList) ->
		List ++ RoloList
	    end,
	AllRoleList = lists:foldl(F, [], GuildList),  %%所有公会的人id
	F1 = fun(RoleId, AccMap) ->
		maps:put(RoleId, maps:get(RoleId, AccMap, 0) + AddExp, AccMap) %%如果是没有这个人物id，则初始化，有则在原来的基础上加经验
	     end,
	NewMap = lists:foldl(F1, Map, AllRoleList),
	NewMap.


%% -----------------------------------------------------------------
%% @desc     功能描述 生成篝火
%% @param    参数    State::status_gfeast{}
%% @return   返回值  NewState
%% @history  修改历史
%% -----------------------------------------------------------------
creat_fire(State) ->
	#status_gfeast{gfeast_guild = GuildList, fire_map = FireMap} = State,
	SceneId = data_guild_feast:get_cfg(scene_id),
	FireTypeId = data_guild_feast:get_cfg(fire_id),
	{X, Y} = data_guild_feast:get_cfg(fire_coord),
	F = fun(Guild, AccMap) ->
		#gfeast_guild{guild_id = GuildId} = Guild,
		FireId = lib_mon:sync_create_mon(FireTypeId, SceneId, ?DEF_SCENE_PID, X, Y, 0, GuildId, 1, []), %%怪物唯一id ,用怪物来作为火堆
		NewMap = maps:put(GuildId, FireId, AccMap),
		NewMap
	    end,
	NewFireMap = lists:foldl(F, FireMap, GuildList),
%%	?DEBUG("NewFireMap ~p~n", [NewFireMap]),
	State#status_gfeast{fire_map = NewFireMap}.


%% -----------------------------------------------------------------
%% @desc     功能描述  清理篝火
%% @param    参数      State::status_gfeast{}
%% @return   返回值    NewState
%% @history  修改历史
%% -----------------------------------------------------------------
clear_fire(#status_gfeast{fire_map = Map} = State) ->
	List = maps:values(Map),
	?DEBUG("clear fireList ~p~n", [List]),
	SceneId = data_guild_feast:get_cfg(scene_id),

	lib_mon:clear_scene_mon_by_ids(SceneId, ?DEF_SCENE_PID, 1, List),
	State#status_gfeast{fire_map = #{}}.


%%发送积分排行榜
send_quiz_rank(RoleId, GuildId, State) ->
	#status_gfeast{gfeast_guild_rank = GuildRankList, guild_role_map = RoleMap} = State,
	IsKf = is_kf(),
	case lists:keyfind(GuildId, #gfeast_guild_rank_info.guild_id, GuildRankList) of
		#gfeast_guild_rank_info{rank_list = PackRoleListLast} ->
			ok;
		_ ->
			PackRoleListLast = []
	end,
	if
		IsKf ->
			mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, send_quiz_rank, [config:get_server_id(), RoleId, GuildId, PackRoleListLast]);
		true ->
            RoleRankInfo = lib_guild_feast:sort_role_by_point(lists:flatten(maps:values(RoleMap))),
            BinData = lib_guild_feast:pack_role_rank_info(RoleRankInfo, 3),
            lib_server_send:send_to_uid(RoleId, BinData)
	end.

%%	%%我的排名
%%	LimitPoint = data_guild_feast:get_cfg(rank_point),  %%上榜积分限制
%%	{MyRank, Point} =
%%		case lists:keyfind(RoleId, #gfeast_rank_info.role_id, GFeastRank) of
%%			#gfeast_rank_info{rank_no = _MyNo, score = TempPoint} ->
%%				MyNo = case TempPoint >= LimitPoint of
%%					       true ->
%%						       _MyNo;
%%					       false ->
%%						       0
%%				       end,
%%				{MyNo, TempPoint};
%%			_ ->
%%				{0, 0}
%%		end,
%%	%%排行榜
%%	LimitPoint = data_guild_feast:get_cfg(rank_point),    %%上榜积分限制
%%	RankLength = data_guild_feast:get_cfg(rank_num),
%%	GFeastRank1 = lists:sublist(GFeastRank, RankLength),  %%
%%	PackList = [{RankNo, RoleName, Score} || #gfeast_rank_info{rank_no = RankNo, role_name = RoleName, score = Score} <- GFeastRank1,
%%		Score >= LimitPoint],
%%	?MYLOG("cym", "MyRank:~p,Point:~p  PackList ~p ~n", [MyRank, Point, PackList]),
%%	{ok, BinData} = pt_402:write(40214, [MyRank, Point, PackList]),
%%	lib_server_send:send_to_uid(RoleId, BinData).

send_quiz_rank_by_guild(GuildId, #status_gfeast{gfeast_guild = GuildList} = State) ->
	%%不在一个个公会
	RoleList2 = [RoleList1 || #gfeast_guild{role_list = RoleList1} <- GuildList],
	RoleList = lists:flatten(RoleList2),
	[send_quiz_rank(X, GuildId, State) || X <- RoleList].
%%	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
%%		false ->
%%			skip;
%%		#gfeast_guild{role_list = RoleList} ->
%%			[send_quiz_rank(X, GuildId, State) || X <- RoleList]
%%	end.

send_role_score_rank(RoleId, GuildId, State) ->
    #status_gfeast{mini_game_rank = MiniGameRank, guild_role_map = RoleMap} = State,
    GameType = get_game_type(),
    case is_kf() of
        true ->
            ServerId = config:get_server_id(),
            mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, send_role_score_rank, [ServerId, RoleId, GuildId, GameType]);
        false ->
            case GameType of
                'quiz' ->
                    RoleList = lib_guild_feast:sort_role_by_point(lists:flatten(maps:values(RoleMap))),
                    BinData = pack_role_score_rank(RoleId, RoleList);
                'note_crash' ->
                    #gfeast_rank_role{score = Score, rank = Rank} = ulists:keyfind(RoleId, #gfeast_rank_role.role_id, MiniGameRank, #gfeast_rank_role{}),
                    {ok, BinData} = pt_402:write(40220, [Rank, Score])
            end,
            lib_server_send:send_to_uid(RoleId, BinData)
    end.

pack_role_score_rank(_RoleId, []) ->
    {ok, BinData} = pt_402:write(40220, [0, 0]),
    BinData;
pack_role_score_rank(RoleId, RoleRankList) ->
    case size(hd(RoleRankList)) of
        5 -> % 本服
            {_, _, Score, _, Rank} = ulists:keyfind(RoleId, 1, RoleRankList, {0, 0, 0, 0, 0});
        _ -> % 跨服
            {_, _, Score, _, Rank, _, _} = ulists:keyfind(RoleId, 1, RoleRankList, {0, 0, 0, 0, 0, 0, 0})
    end,
    {ok, BinData} = pt_402:write(40220, [Rank, Score]),
    BinData.

%% -----------------------------------------------------------------
%% @desc     功能描述  检查是否可采集
%% @param    参数     MonId::integer() 怪物唯一id，   MonCfgId::integer()  怪物配置id
%% @return   返回值   {false, Code} |true
%% @history  修改历史
%% -----------------------------------------------------------------
collect_checker(ModId, ModCfgId, A) ->
	case ModCfgId == data_guild_boss:get_cfg(boss_drop_id) of
		true -> mod_guild_boss:collect_checker(ModId, ModCfgId, A);
		_ ->
			mod_guild_feast_mgr:collect_checker(ModId, ModCfgId, A)
	end.

collect_checker(_ModId, _ModCfgId, State, {RoleId, GuildId}) ->
	#status_gfeast{gfeast_guild = GuildList} = State,
%%	?DEBUG("log1 ~n", []),
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
		false ->
			?DEBUG("log1 ~n", []),
			{false, 4};
		Guild ->
			#gfeast_guild{get_fire_list = GetRoleList} = Guild,
			case lists:member(RoleId, GetRoleList) of
				true ->
%%					?DEBUG("log1 ~n", []),
					{false, 22};    %%已经采集过了，不能再次采集
				false ->
%%					?DEBUG("log1 ~n", []),
					true
			end
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  消除火苗
%% @param    参数     Guild::
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
disappear(Guild) ->
	#gfeast_guild{fire_list = FireList} = Guild,
	IdList = [Id || {Id, _} <- FireList],
	SceneId = data_guild_feast:get_cfg(scene_id),
	lib_mon:clear_scene_mon_by_ids(SceneId, ?DEF_SCENE_PID, 1, IdList),
	Guild#gfeast_guild{fire_list = []}.





send_quiz_TV_by_guild(_GuildId, QuizState, _GuildList) ->
	#status_quiz{type = QuizType, no1_name = No1Name, right_answer = ChooseAnswer, answer = Answer} = QuizState,
	SceneId = data_guild_feast:get_cfg(scene_id),
	case QuizType of
		1 -> %% 选择题传闻
			TempAnswer =
				case ChooseAnswer of
					1 ->
						"A." ++ Answer;
					2 ->
						"B." ++ Answer;
					3 ->
						"C." ++ Answer;
					4 ->
						"D." ++ Answer;
					_ ->
						Answer
				end,
			LastAnswer = ulists:list_to_bin(TempAnswer),
			case No1Name of
				undefine ->  %%没人答对
					lib_chat:send_TV({scene, SceneId, ?DEF_SCENE_PID}, ?MOD_GUILD_ACT, ?no_one_right_answer, [LastAnswer]);
				_ ->
					lib_chat:send_TV({scene, SceneId, ?DEF_SCENE_PID}, ?MOD_GUILD_ACT, ?first_right_answer, [LastAnswer, No1Name])
			end;
		2 -> %% 简答题传闻
			LastAnswer = ulists:list_to_bin(Answer),
			case No1Name of
				undefine ->  %%没人答对
					lib_chat:send_TV({scene, SceneId, ?DEF_SCENE_PID}, ?MOD_GUILD_ACT, ?no_one_right_answer, [LastAnswer]);
				_ ->
					lib_chat:send_TV({scene, SceneId, ?DEF_SCENE_PID}, ?MOD_GUILD_ACT, ?first_right_answer, [LastAnswer, No1Name])
			end
	end.
%%	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
%%		false ->
%%			skip;
%%		#gfeast_guild{role_list = RoloList} ->
%%			#status_quiz{type = QuizType, no1_name = No1Name, right_answer = ChooseAnswer, answer = Answer} = QuizState,
%%			case QuizType of
%%				1 -> %% 选择题传闻
%%					TempAnswer =
%%						case ChooseAnswer of
%%							1 ->
%%								"A." ++ Answer;
%%							2 ->
%%								"B." ++ Answer;
%%							3 ->
%%								"C." ++ Answer;
%%							4 ->
%%								"D." ++ Answer;
%%							_ ->
%%								Answer
%%						end,
%%					LastAnswer = ulists:list_to_bin(TempAnswer),
%%					case No1Name of
%%						undefine ->  %%没人答对
%%							[lib_chat:send_TV({player, RoldId}, ?MOD_GUILD_ACT, ?no_one_right_answer, [LastAnswer])
%%								|| RoldId <- RoloList];
%%						_ ->
%%							[lib_chat:send_TV({player, RoldId}, ?MOD_GUILD_ACT, ?first_right_answer, [LastAnswer, No1Name])
%%								|| RoldId <- RoloList]
%%					end;
%%				2 -> %% 简答题传闻
%%					LastAnswer = ulists:list_to_bin(Answer),
%%					case No1Name of
%%						undefine ->  %%没人答对
%%							[lib_chat:send_TV({player, RoldId}, ?MOD_GUILD_ACT, ?no_one_right_answer, [LastAnswer])
%%								|| RoldId <- RoloList];
%%						_ ->
%%							[lib_chat:send_TV({player, RoldId}, ?MOD_GUILD_ACT, ?first_right_answer, [LastAnswer, No1Name])
%%								|| RoldId <- RoloList]
%%					end
%%			end
%%	end.

%% -----------------------------------------------------------------
%% @desc     功能描述   搜集火苗
%% @param    参数
%% @return   返回值     state
%% @history  修改历史
%% -----------------------------------------------------------------
collect_fire(MonId, RoleId, #status_gfeast{gfeast_guild = GuildList} = State) ->
	F = fun(Guild, List) ->
		#gfeast_guild{fire_list = FireList, get_fire_list = GetFireList, guild_id = GuildId, fire_wave = FireWave} = Guild,
		case lists:keyfind(MonId, 1, FireList) of
			false ->  %%找不到
				List;
			_ -> %%就是这个公会里的火苗， 之前已经判断能不能采集了，这里直接采集就好
				%%更新火苗列表  就是删除火苗，获得火苗列表
				NewFireList = lists:keydelete(MonId, 1, FireList),
				%%获得火苗列表
				NewGetFrieList = [RoleId | GetFireList],   %%肯定是没有的，检查过了
				NewGuild = Guild#gfeast_guild{fire_list = NewFireList, get_fire_list = NewGetFrieList},
				NewGuildList = lists:keystore(GuildId, #gfeast_guild.guild_id, GuildList, NewGuild),
				%% 发送奖励, 生成奖励 -》发送奖励
				OpenDay = util:get_open_day(),
				{_, Color} = lists:keyfind(MonId, 1, FireList),   %%获得品质，且必然有，检查过了
				_RewardList = data_guild_feast:get_fire_reward(Color, OpenDay),
				case _RewardList of
					[] ->
						RewardList = [],
						?ERR("err_fire_cfg ~n", []),
						ok;
					_ ->
						?DEBUG("Reward ~pn", [_RewardList]),
						RewardList = get_right_reward(_RewardList),
%%						?MYLOG("cym", "RewardList ~p~n", [RewardList]),
						Produce = #produce{reward = RewardList, type = guild_feast_fire},
						lib_goods_api:send_reward_with_mail(RoleId, Produce)
				end,
%%					%% 通知所有玩家，火苗列表的刷新 这里用的是采集怪，不用通知，场景里会处理好
%%					?DEBUG("?NewGuild ~p~n", [NewGuild]),
%%					lib_guild_feast:send_to_all_fire_by_guild(NewFireList, NewGuild),
				%%通知奖励列表
				{ok, Bin1} = pt_402:write(40257, [RewardList]),
				lib_server_send:send_to_uid(RoleId, Bin1),
				%%增加龙魂
%%				DragonPoint = data_guild_feast:get_cfg(collect_fire_dragon_spirit),  %%不用增加龙魂了
				lib_log_api:log_role_guild_feast_fire(RoleId, Color, FireWave, RewardList, 0, GuildId),
%%				mod_guild_feast_mgr:add_dragon_spirit(GuildId, DragonPoint),
				NewGuildList
		end
	    end,
	LastGuildList = lists:foldl(F, GuildList, GuildList),
	NewState = State#status_gfeast{gfeast_guild = LastGuildList},
	NewState.

%% -----------------------------------------------------------------
%% @desc     功能描述  个人传闻
%% @param    参数      Stage::#status_quiz  答题状态信息
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
send_person_tv(State) ->
	#status_quiz{question_list = Qlist} = State,
	[begin
		 #question_msg{status = QuestionStatus, combo = Combo, rank = Rank, role_id = RoleId} = X,
		 case QuestionStatus of
			 0 -> %%没有回答，
				 skip;
			 1 -> %%回答了
				 case Combo of
					 0 ->  %%答错了
						 lib_chat:send_TV({player, RoleId}, ?MOD_GUILD_ACT, ?person_err_answer, []);
					 _ ->  %%答对了
						 Point = data_guild_feast:get_question_point(Rank),
						 lib_chat:send_TV({player, RoleId}, ?MOD_GUILD_ACT, ?person_right_answer, [Point])
				 end
		 end
	 end
		|| X <- Qlist].


%%获得题目有效时间
get_question_vaild_time(Type) ->
	case Type of
		1 ->    %%选择题
			data_guild_feast:get_cfg(topic_vaild_time);
		2 -> %%简答题
			data_guild_feast:get_cfg(short_topic_vaild_time)
	end.
get_end_time(0) -> 0;
get_end_time(_) ->
	[{H, M, S}] = data_guild_feast:get_cfg(open_time),
	Duration = data_guild_feast:get_cfg(duration),
	utime:unixdate() + H * 60 * 60 + M * 60 + S + Duration.


%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数   RewardList:: [{抽奖次数,奖池}]  奖池 = [{{goodType, GoodsId, Num}, W}]
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_right_reward(RewardList) ->
	get_right_reward(RewardList, []).

get_right_reward([], AccList) ->
	AccList;
get_right_reward([{DrawTimes, Pool} | T], AccList) ->
	_List = find_ratio_list(Pool, 2, DrawTimes),
	List = [R || {R, _W} <- _List],
	get_right_reward(T, List ++ AccList).



%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数   List::lists ,N::integer 权重坐标,   Times::抽奖次数
%% @return   返回值  [element].
%% @history  修改历史
%% -----------------------------------------------------------------
find_ratio_list(List, N, Times) ->
	%%?PRINT("--- ~p~n",[Times]),
	find_ratio_list(List, N, Times, []).

find_ratio_list(_List, _N, 0, Res) ->
	%%?PRINT("-- ~p~n",[0]),
	Res;
find_ratio_list(List, N, Times, Res) ->
	R = util:find_ratio(List, N),
	%%?PRINT("-- ~p~n",[Times]),
	find_ratio_list(List, N, Times - 1, [R | Res]).



send_dragon_reward(#player_status{sid = Sid, id = RoleId, guild = Guild, figure = F} = PS) ->
	#status_guild{id = GuildId} = Guild,
	_RewardList = data_guild_feast:get_dragon_gift(F#figure.lv), %%实际这里，改了了等级，不受开发天数影响
	case _RewardList of
		[] ->   %%找不到配置

			mod_guild_feast_mgr:exit_scene(RoleId, GuildId),
			{ok, Bin} = pt_402:write(40200, ?MISSING_CONFIG),  %%通知客户端
			lib_server_send:send_to_sid(Sid, Bin),
			PS;
		_ ->
			[TempList1, TempList2] = _RewardList,  %% 2是固定奖励
			RewardList = get_right_reward(TempList1) ++ TempList2,
			?MYLOG("cym", "RewardList ~p~n", [RewardList]),
			Produce = #produce{reward = RewardList, type = guild_feast_boss},
			lib_log_api:log_role_guild_feast_dragon(RoleId, RewardList, GuildId),
			lib_goods_api:send_reward_with_mail(RoleId, Produce), %%发送奖励
			{ok, Bin} = pt_402:write(40262, [1, RewardList]),     %%通知客户端
			lib_server_send:send_to_sid(Sid, Bin),
			PS
	end.


send_fire_reward(#player_status{figure = F, id = RoleId, scene = Scene} = Ps) ->
	RewardList = data_guild_feast:get_fire_exp_reward(F#figure.lv),
	FeastScene = data_guild_feast:get_cfg(scene_id),
	if
		RewardList == [] ->
			skip;
		FeastScene == Scene ->
			lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = RewardList, type = guild_feast, show_tips = ?SHOW_TIPS_3});
		true ->
			ok
	end,
	Ps.

get_init_guild() ->
	%%初始化所有公会
	GuildMap = mod_guild:get_all_guild(),
	TempList =
		case is_map(GuildMap) of
			true ->
				maps:values(GuildMap);
			false ->
				[]
		end,
	[#gfeast_guild{guild_id = GuildId, guild_name = GuildName} || #guild{id = GuildId, name = GuildName} <- TempList].

create_fire_by_guild(Guild) ->
	SceneId = data_guild_feast:get_cfg(scene_id),
	FireTypeId = data_guild_feast:get_cfg(fire_id),
	{X, Y} = data_guild_feast:get_cfg(fire_coord),
	#gfeast_guild{guild_id = GuildId} = Guild,
	FireId = lib_mon:sync_create_mon(FireTypeId, SceneId, ?DEF_SCENE_PID, X, Y, 0, GuildId, 1, []), %%怪物唯一id ,用怪物来作为火堆
	FireId.

get_summon_cost_by_type(Type) ->
	CostList = data_guild_feast:get_cfg(summon_cost),
	case lists:keyfind(Type, 1, CostList) of
		{Type, Cost} ->
			[{?TYPE_GOODS, Cost, 1}];
		false ->
			[]
	end.

%% 召唤巨龙逻辑
summon_dragon(RoleId, GuildId, Cost, Type, GuildList) ->
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
		#gfeast_guild{dragon_list = DragonList} = Guild ->
			MonId = get_dragon_id_by_type(Type),
			case DragonList of
				[] ->
					%%
					{ok, Bin} = pt_402:write(40263, [?SUCCESS]),
					lib_server_send:send_to_uid(RoleId, Bin),
					%%消耗
					lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_guild_feast, summon_cost, [Cost]),
					%%奖励
					SummonReward = get_summon_reward_by_type(Type),
					%%发送邮件
					Title = utext:get(4020001),
					Content = utext:get(4020002),
					lib_mail_api:send_sys_mail([RoleId], Title, Content, SummonReward),
%%					lib_goods_api:send_reward_with_mail(RoleId, #produce{show_tips = ?SHOW_TIPS_3, reward = SummonReward, type = summon_card_reward}),
					%%根据公会前30名的平均等级生成巨龙 err402_summon_dragon_yet
					mod_guild:summon_guild_feast_dragon(MonId, GuildId, RoleId),
					lib_achievement_api:async_event(RoleId, lib_achievement_api, guild_summon_dragon_event, 1),
					%%数据放入晚宴进程
					NewDragonList = [MonId | DragonList],
					NewGuild = Guild#gfeast_guild{dragon_list = NewDragonList, summon_card = Type},
					lists:keystore(GuildId, #gfeast_guild.guild_id, GuildList, NewGuild);
				_ -> %%已经召唤了boss
					pp_guild_act:send_error_code_by_role_id(RoleId, ?ERRCODE(err402_summon_dragon_yet)),
					GuildList
			end;
		_ ->
			GuildList
	end.

%%通过召唤类型来寻找id
get_dragon_id_by_type(Type) ->
	DragonList = data_guild_feast:get_cfg(dragon_id_list),
	case lists:keyfind(Type, 1, DragonList) of
		{Type, MonId} ->
			MonId;
		_ ->
			0
	end.

summon_cost(PS, Cost) ->
	case lib_goods_api:cost_object_list_with_check(PS, Cost, dragon_summon, "") of
		{false, ErrorCode, _} ->
			pp_guild_act:send_error_code(PS#player_status.sid, ErrorCode),
			PS;
		{true, NewPS} ->
			NewPS
	end.

do_summon_dragon(GuildId, Lv, MonId, RoleId) ->
	Scene = data_guild_feast:get_cfg(scene_id),
	{X, Y} = data_guild_feast:get_cfg(dragon_coord),
	lib_mon:async_create_mon(MonId, Scene, ?DEF_SCENE_PID, X, Y, 1, GuildId, 1, [{lv, Lv}, {auto_lv, Lv}, {mod_args, [{summon_role, RoleId}]}]).

%%巨龙被杀死
handle_dragon_be_kill(MonArgs, _AtterId, State, ModArgs) ->
	#status_gfeast{gfeast_guild = GuildList} = State,
	#mon_args{mid = MonCfgId, hurt_list = HurtList, copy_id = GuildId} = MonArgs,
	case lists:keyfind(GuildId, #gfeast_guild.guild_id, GuildList) of
		#gfeast_guild{dragon_list = DragonList, role_list = RoleList, guild_name = GuildName, summon_card = SummonCard} = Guild ->
			case lists:member(MonCfgId, DragonList) of
				true ->
					NewGuild = Guild#gfeast_guild{dragon_list = []},
					GuildList1 = lists:keystore(GuildId, #gfeast_guild.guild_id, GuildList, NewGuild),
					%%发送红包
					LastRoleList = get_right_role_list(RoleList, HurtList),
					send_guild_feast_red_envelope(Guild#gfeast_guild.guild_id, LastRoleList, MonCfgId, GuildName, get_summon_role(ModArgs), SummonCard),
					State#status_gfeast{gfeast_guild = GuildList1};
				false ->
					State
			end;
		_ ->
			State
	end.

send_guild_feast_red_envelope(Guild, LastRoleList, MonCfgId, GuildName, AtterId, SummonCard) ->
	%%获取红包额度
%%	?MYLOG("cymfeast", "Length ~p~n", [Length]),
	Length = length(LastRoleList),
	{Bgold, EnvelopesId} = get_red_envelope(Length, SummonCard),
	%% 发送红包 todo
	MonName =
		case data_mon:get(MonCfgId) of
			#mon{name = V} ->
				V;
			_ ->
				""
		end,
%%	?MYLOG("cymfeast", "~p~n", [{EnvelopesId, MonCfgId, MonName, Guild, GuildName, AtterId, Bgold, LastRoleList}]),
	lib_red_envelopes:give_gfeast_red_envelopes(EnvelopesId, MonCfgId, MonName, Guild, GuildName, AtterId, Bgold, LastRoleList),
	ok.

get_red_envelope(Length, SummonCard) ->
	DragonReward = data_guild_feast:get_cfg(dragon_id_reward),
	case lists:keyfind(SummonCard, 1, DragonReward) of
		{SummonCard, Num, RedId} ->
			{Num * Length, RedId};
		_ ->
			{0, 0}
	end.

handle_summon_card_after_ac_end() ->
	Sql1 = io_lib:format(?sql_clear_special_currency, [?GOODS_ID_SUMMON_CARD]),
	Sql2 = io_lib:format(?sql_clear_special_currency, [?GOODS_ID_MIDDLE_SUMMON_CARD]),
	Sql3 = io_lib:format(?sql_clear_special_currency, [?GOODS_ID_HIGH_SUMMON_CARD]),
	db:execute(Sql1),
	db:execute(Sql2),
	db:execute(Sql3),
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_guild_feast, handle_summon_card_after_ac_end, []) || E <- OnlineRoles],
	ok.

handle_summon_card_after_ac_end(PS) ->
	Card1 = lib_goods_api:get_currency(PS, ?GOODS_ID_SUMMON_CARD),
	Card2 = lib_goods_api:get_currency(PS, ?GOODS_ID_MIDDLE_SUMMON_CARD),
	Card3 = lib_goods_api:get_currency(PS, ?GOODS_ID_HIGH_SUMMON_CARD),
	Cost = [],
	Cost1 = ?IF(Card1 > 0, Cost ++ [{?TYPE_CURRENCY, ?GOODS_ID_SUMMON_CARD, Card1}], Cost),
	Cost2 = ?IF(Card2 > 0, Cost1 ++ [{?TYPE_CURRENCY, ?GOODS_ID_MIDDLE_SUMMON_CARD, Card2}], Cost1),
	Cost3 = ?IF(Card3 > 0, Cost2 ++ [{?TYPE_CURRENCY, ?GOODS_ID_MIDDLE_SUMMON_CARD, Card3}], Cost2),
	if
		Cost3 == [] ->
			PS;
		true ->
			case lib_goods_api:cost_object_list_with_check(PS, Cost3, sanctuary_clear_medal, "") of
				{true, NewPs} ->
					NewPs;
				{false, _Error, NewPs} ->
					NewPs
			end
	end.

%%获得两个列表的交集
get_right_role_list(RoleList, HurtList) ->
	HurtRoleList = [RoleId || #mon_atter{id = RoleId} <- HurtList],
	HurtRoleList -- (HurtRoleList -- RoleList).

get_summon_reward_by_type(Type) ->
	List = data_guild_feast:get_cfg(summon_reward),
	case lists:keyfind(Type, 1, List) of
		{Type, RewardList} ->
			RewardList;
		_ ->
			[]
	end.

get_summon_role(MonArgs) ->
	case lists:keyfind(summon_role, 1, MonArgs) of
		{summon_role, RoleId} ->
			RoleId;
		_ ->
			0
	end.


handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = _Data}) when is_record(Player, player_status) ->
	#player_status{scene = SceneId, player_die = PlayerDieInfo} = Player,
	OldModDieInfo = maps:get(?MOD_GUILD_ACT, PlayerDieInfo, []),
	case OldModDieInfo of
		[] ->
			OldRef = [],
			ModDieInfo = #mod_player_die{mod = ?MOD_GUILD_ACT, reborn_ref = undefined};
		_ ->
			#mod_player_die{reborn_ref = OldRef} = OldModDieInfo,
			ModDieInfo = OldModDieInfo
	end,
	case data_scene:get(SceneId) of
		#ets_scene{type = Type} when Type == ?SCENE_TYPE_GUILD_FEAST ->
			Ref = util:send_after(OldRef, ?reborn_time * 1000, self(), {'mod', lib_guild_feast, reborn, []}),
			NewModDieInfo = ModDieInfo#mod_player_die{mod = ?MOD_GUILD_ACT, reborn_ref = Ref},
			NewPlayerDieInfo = maps:put(?MOD_GUILD_ACT, NewModDieInfo, PlayerDieInfo),
%%			?MYLOG("cym", "EVENT_PLAYER_DIE ++++  ~p~n", [NewPlayerDieInfo]),
			{ok, Player#player_status{player_die = NewPlayerDieInfo}};
		_ ->
			{ok, Player}
	end;


handle_event(Player, #event_callback{type_id = ?EVENT_REVIVE, data = _Data}) when is_record(Player, player_status) ->
	#player_status{scene = SceneId, player_die = PlayerDieInfo} = Player,
	OldModDieInfo = maps:get(?MOD_GUILD_ACT, PlayerDieInfo, []),
%%	?MYLOG("cym", "EVENT_REVIVE ++++~n", []),
%%	?MYLOG("cym", "EVENT_REVIVE ++++  ~p~n", [PlayerDieInfo]),
	case OldModDieInfo of
		[] ->
			OldRef = [],
			ModDieInfo = #mod_player_die{mod = ?MOD_GUILD_ACT, reborn_ref = undefined};
		_ ->
			#mod_player_die{reborn_ref = OldRef} = OldModDieInfo,
			ModDieInfo = OldModDieInfo
	end,
	case data_scene:get(SceneId) of
		#ets_scene{type = Type} when Type == ?SCENE_TYPE_GUILD_FEAST ->
			util:cancel_timer(OldRef),
			NewModDieInfo = ModDieInfo#mod_player_die{reborn_ref = []},
			NewPlayerDieInfo = maps:put(?MOD_GUILD_ACT, NewModDieInfo, PlayerDieInfo),
			{ok, Player#player_status{player_die = NewPlayerDieInfo}};
		_ ->
			{ok, Player}
	end;


handle_event(Player, _EventCallback) ->
	{ok, Player}.



reborn(PS) ->
	#player_status{battle_attr = BA, scene = SceneId} = PS,
	#battle_attr{hp = Hp} = BA,
%%	?MYLOG("cym", "reborn ++++~n", []),
	if
		Hp > 0 ->
			PS;
		true ->
			case data_scene:get(SceneId) of
				#ets_scene{x = X, y = Y} ->
					NewPlayer = lib_scene:change_relogin_scene(PS#player_status{x = X, y = Y},
						[{group, 0}, {change_scene_hp_lim, 100}]),
					NewPlayer;
				_ ->
					PS
			end
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  判断是否购买了菜肴，
%%                    计数器中存的二进制 最后三位为  菜肴的购买状态
%%                    分别为 类型 3 2，1 的购买状态  如  001就是购买了菜肴1， 111就是购买了三种菜肴
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
is_buy_food(RoleId, Type) ->
	Status = mod_daily:get_count(RoleId, ?MOD_GUILD_ACT, 3),
	Res = round(math:pow(2, Type - 1)) band Status,  %%  如type  为2  则  求 2#010 与 Status 的位运算 与  的结果
	if
		Res > 0 ->  %% 如果是不为0则状态为 1
			true;
		true ->
			false
	end.


set_foods_status(RoleId, Type) ->
	Status = mod_daily:get_count(RoleId, ?MOD_GUILD_ACT, 3),
	Res = round(math:pow(2, Type - 1)) bor Status,  %%  如type  为2  则  求 2#010 与 Status 的位运算 或  的结果
	mod_daily:set_count(RoleId, ?MOD_GUILD_ACT, 3, Res),
	get_foods_pack_list(RoleId).

get_foods_pack_list(RoleId) ->
	Status = mod_daily:get_count(RoleId, ?MOD_GUILD_ACT, 3),
	%% 取第n的状态
	Res1 = 2#001 band Status,
	Res2 = 2#010 band Status bsr 1,
	Res3 = 2#100 band Status bsr 2,
	[{1, Res1}, {2, Res2}, {3, Res3}].

is_kf() ->
	NowDay = util:get_open_day(),
	DayLimit = data_guild_feast:get_cfg(open_kf_day_limit),
	if
		NowDay >= DayLimit ->
			true;
		true ->
			false
	end.


get_food_exp_ratio(PS) ->
	Ratio = mod_daily:get_count(PS#player_status.id, ?MOD_GUILD_ACT, 4),
%%	?PRINT("Ratio ~p~n", [Ratio]),
	ServerLv = util:get_world_lv(),
	ServerLvExpRatio = lib_player:calc_satisfy_world_exp_add(PS, ServerLv),
	(Ratio + ServerLvExpRatio )/ 100 + 1.
%%	FoodList = get_foods_pack_list(PS#player_status.id),
%%%%	?PRINT("FoodList ~p~n", [FoodList]),
%%	FoodBuffList = data_guild_feast:get_cfg(food_buff),
%%	F = fun({Type, Status}, AddRatio) ->
%%		if
%%			Status == 1 ->
%%				case lists:keyfind(Type, 1, FoodBuffList) of
%%					{_, Ratio} ->
%%						AddRatio + Ratio;
%%					_ ->
%%						AddRatio
%%				end;
%%			true ->
%%				AddRatio
%%		end
%%	    end,
%%	R = lists:foldl(F, 0, FoodList),
%%%%	?PRINT("R ~p~n", [R]),
%%	R / 100.


send_topic_reward_in_guild(Guild, Rank) ->
%%	?MYLOG("feast", "Guild ~p, Rank ~p~n", [Guild, Rank]),
	%% 发送传闻
	if
		Rank =< ?tv_rank_limit->
			lib_chat:send_TV({guild, Guild}, ?MOD_GUILD_ACT, 28, [Rank]);
		true ->
			lib_chat:send_TV({guild, Guild}, ?MOD_GUILD_ACT, 29, [])
	end,
	RoleIds = lib_guild_data:get_all_role_in_guild(Guild),
	Reward = data_guild_feast:get_point_rank(Rank),
	if
		Reward == [] ->
			skip;
		true ->
			spawn(fun() ->
				[   begin
					    timer:sleep(200),
					    Pid = misc:get_player_process(RoleId),
					    case misc:is_process_alive(Pid) of
						    true ->
							    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS,
								    lib_guild_feast, send_topic_reward_in_ps, [Rank]);
						    _  ->
							    Title = utext:get(4020003, [lib_guild_feast:get_game_name('quiz')]),
							    Content = utext:get(4020004, [Rank]),
							    lib_mail_api:send_sys_mail([RoleId],  Title, Content, Reward)
					    end
				    end
					||RoleId <-RoleIds]
			      end)
	end.


send_topic_reward_in_ps(PS, GameType, Rank) ->
	#player_status{scene = Scene, id = RoleId} = PS,
    GameId = get_game_id(GameType),
	Reward = data_guild_feast:get_point_rank(GameId, Rank),
	case is_gfeast_scene(Scene) of
		true ->
			lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = guild_quiz_rank_reward}),
			{ok, Bin} = pt_402:write(40266, [Rank, Reward]),
			lib_server_send:send_to_uid(RoleId, Bin);
		_ ->
			Title = utext:get(4020003, [lib_guild_feast:get_game_name(GameType)]),
			Content = utext:get(4020004, [Rank]),
			lib_mail_api:send_sys_mail([RoleId],  Title, Content, Reward)
	end.


%% 发送40217给客户端
send_rank_to_client(GuildPointList, RoleMap, _RoleId, GuildId) ->
	IsKf =
		case lib_guild_feast:is_kf() of
			true ->
				1;
			_ ->
				0
		end,
	SortGuildList =
		if
			GuildPointList == [] ->
				[];
			true ->
				lib_guild_feast:sort_guild_by_point(GuildPointList) %% 返回  [{GuildId, Name, Point, Time, Rank}] ,
		end,
	PackGuildList = [{GuildId1, config:get_server_num(), Name1, Point1, Rank1} ||
		{GuildId1, Name1, Point1, _Time1, Rank1} <- SortGuildList],
	RoleList = maps:get(GuildId, RoleMap, []),
	SortRoleList =
		if
			RoleList == [] ->
				[];
			true ->
				lib_guild_feast:sort_role_by_point(RoleList)
		end,
	PackRoleList = [{Rank2, Name2, Point2} || {_RoleId2, Name2, Point2, _Time2, Rank2} <- SortRoleList],
	PackRoleListLast = lists:sublist(PackRoleList, 3),
	SceneId = data_guild_feast:get_cfg(scene_id),  %%场景id
	{ok, BinData} = pt_402:write(40214, [IsKf, PackGuildList, PackRoleListLast]),
	lib_server_send:send_to_scene(SceneId, ?DEF_SCENE_PID, BinData). %%给场景的所有玩家发送信息


%% 公会篝火当天是否开启
is_today_open() ->
%%	lib_activitycalen_api:get_today_act(402, 2)
	case lib_activitycalen_api:get_today_act(?MOD_GUILD_ACT, 2) of
		false ->
			false;
		_ ->
			true
	end.


send_buy_food_tv(_RoleId, RoleName, GuildId, Type, Cost) ->
	if
		Type == 1 -> %%  普通菜肴
			lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_ACT, 30, [RoleName]);
		Type == 2 -> %%  优质菜肴
			lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_ACT, 31, [RoleName]);
		Type == 3 -> %%  高级菜肴
			case Cost of
				[{_, _, Num}] ->
					ok;
				_ ->
					Num = 0
			end,
			lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_ACT, 32, [RoleName, Num]);
		true ->
			skip
	end.


%%gm 强制退出场景 特殊情况
force_quit_scene(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY) ->
	OnlineList = ets:tab2list(?ETS_ONLINE),
	IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_guild_feast, force_quit_scene, []) || RoleId <- IdList],
	mod_guild_feast_mgr:gm_close_without_kf();

force_quit_scene(_, _) ->
	skip.


force_quit_scene(PS) ->
	#player_status{scene = Scene, id = RoleId, guild = Guild} = PS,
	case is_gfeast_scene(Scene) of
		true ->
			mod_guild_feast_mgr:exit_scene(RoleId, Guild#status_guild.id),
			lib_scene:player_change_scene(RoleId, 0, 0, 0, true, [{action_free, ?ERRCODE(err402_can_not_change_scene_in_gfeast)}, {change_scene_hp_lim, 100}, {collect_checker, undefined}]);
		_ ->
			ok
	end,
	PS.

broadcast_food_status(_RoleIdList, 0) ->
	ok;
broadcast_food_status(RoleIdList, 1) ->
	[begin
		 timer:sleep(100),
		 PackList = lib_guild_feast:get_foods_pack_list(RoleId),
		 PackListNew = lists:keystore(3, 1, PackList, {3, 1}),
		 {ok, Bin} = pt_402:write(40265, [PackListNew]),
		 lib_server_send:send_to_uid(RoleId, Bin)
	 end
	 ||RoleId <- RoleIdList].

%% 获取今天轮换的小游戏(晚宴管理进程调用 mod_guild_feast_mgr)
%% @return quiz | note_crash
get_game_type() ->
    case get('game_type') of
        'quiz' -> 'quiz';
        'note_crash' -> 'note_crash';
        _ ->
            DayOfWeek = utime:day_of_week(),
            F = fun({_, WeekDays}) -> lists:member(DayOfWeek, WeekDays) end,
            case ulists:find(F, ?GAME_TYPE_CTRL) of
                {ok, {GameType, _}} -> GameType;
                _ -> GameType = quiz
            end,
            GameType
    end.

get_game_name(GameType) ->
    Key =
    case GameType of
        'quiz' -> 'quiz_game_name';
        'note_crash' -> 'note_crash_game_name';
        _ -> undefined
    end,
    data_guild_feast:get_cfg(Key).

get_game_id() ->
    case get_game_type() of
        'quiz' -> 0;
        'note_crash' -> 1;
        _ -> -1
    end.

get_game_id(GameType) ->
    case GameType of
        'quiz' -> 0;
        'note_crash' -> 1;
        _ -> -1
    end.

gm_feast_repair() ->
	Res = [case erlang:process_info(Pid, dictionary) of
		 {dictionary, List} ->
			 case lists:keyfind('$initial_call', 1, List) of
				 {_, {mod_guild_feast_quiz, _, _}} ->
					 {Pid, 1};
				 _ ->
					 {Pid, 0}
			 end;
		 _ ->
			 {Pid, 0}
	 end || Pid <- erlang:processes()],
	[gen_statem:stop(ResPid) ||{ResPid, T} <-Res, T == 1].

%% 组织宴会玩家相关信息
%% @return #gfeast_player{}

trans_ps_to_gfeast_player(PS) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = PS,
    #figure{
        lv = Lv,
        name = RoleName,
        picture = Pic,
        picture_ver = PicVer,
        guild_id = GuildId,
        guild_name = GuildName
    } = Figure,
    #gfeast_player{
        id 		= RoleId,
        lv		= Lv,
        name 	= RoleName,
        pic     = Pic,
        pic_ver	= PicVer,
        gid		= GuildId,
        gname	= GuildName
    }.

trans_mgp_to_gfeast_player(PlayerInfo) ->
    #mini_game_player{
        id 		= RoleId,
        lv		= Lv,
        name 	= RoleName,
        pic     = Pic,
        pic_ver	= PicVer,
        gid		= GuildId,
        gname	= GuildName
    } = PlayerInfo,
    #gfeast_player{
        id 		= RoleId,
        lv		= Lv,
        name 	= RoleName,
        pic     = Pic,
        pic_ver	= PicVer,
        gid		= GuildId,
        gname	= GuildName
    }.
