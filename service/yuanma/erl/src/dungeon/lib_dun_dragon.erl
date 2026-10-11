%% ---------------------------------------------------------------------------
%% @doc 龙纹试炼
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(lib_dun_dragon).
-compile(export_all).
-include("server.hrl").
-include("dungeon.hrl").
-include("def_module.hrl").
-include("common.hrl").
-include("team.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").

-export([
	%% 查看成就奖励领取情况
	send_stage_reward_info/2
	%% 领取试炼成就奖励（阶段奖励）
	, gain_stage_reward/3
	%% 获取波数通过记录
	, get_wave_pass_time/3
]).

-export([
	%% 获取总波数奖励
	get_dungeon_total_wave_award/5
]).

%% 获取副本进程开启参数
dunex_get_start_dun_args(State, #dungeon{id = _DunId}) ->
	#team{member = Mbs} = State,
	PowerList = [Power || #mb{power = Power} = M <- Mbs, lib_team:is_fake_mb(M)],
	F = fun(A, B) ->
		A >= B
		end,
	SortList = lists:sort(F, PowerList),
	[{dumy_power, SortList}].

%% ---------------------------------------------------------------------------
%% @doc 查看成就奖励领取情况
-spec send_stage_reward_info(Player, DunId) ->
	ok when
	Player :: #player_status{},
	DunId :: integer().
%% ---------------------------------------------------------------------------
send_stage_reward_info(Player, DunId) ->
	#player_status{dungeon = #status_dungeon{wave_map = WaveMap}} = Player,
	case maps:get(DunId, WaveMap, false) of
		#role_dungeon_wave{history_wave = HistoryWave, get_list = GetList} = Msg ->
%%            ?MYLOG("cym", "Msg ~p~n", [Msg]),
			skip;
		_ ->
			HistoryWave = 0, GetList = []
	end,
%%    ?MYLOG("cym", "HistoryWave ~p~n", [HistoryWave]),
	{ok, BinData} = pt_610:write(61051, [DunId, HistoryWave, GetList]),
	lib_server_send:send_to_sid(Player#player_status.sid, BinData),
	ok.

%% 领取试炼成就奖励（阶段奖励）
gain_stage_reward(Player, DunId, Wave) ->
	case check_gain_stage_reward(Player, DunId, Wave) of
		{false, ErrorCode} ->
			NewPlayer2 = Player;
		{true, DungeonWave, StageReward} ->
			ErrorCode = ?SUCCESS,
			#role_dungeon_wave{get_list = GetList} = DungeonWave,
			#player_status{id = RoleId, dungeon = StatusDun = #status_dungeon{wave_map = WaveMap}} = Player,
			NewDungeonWave = DungeonWave#role_dungeon_wave{get_list = [Wave | GetList]},
			lib_dungeon:db_role_dungeon_wave_replace(RoleId, NewDungeonWave),
			NewWaveMap = maps:put(DunId, NewDungeonWave, WaveMap),
			NewStatusDun = StatusDun#status_dungeon{wave_map = NewWaveMap},
			NewPlayer = Player#player_status{dungeon = NewStatusDun},
			?MYLOG("dundragon", "gain_stage_reward ~p~n", [{Wave, StageReward}]),
			{ok, NewPlayer2} = lib_dungeon:send_stage_reward(NewPlayer, DunId, [Wave], StageReward),
			lib_log_api:log_dungeon_dragon_awards(RoleId, DunId, Wave, StageReward)
	end,
	{ok, BinData} = pt_610:write(61054, [ErrorCode, DunId, Wave]),
	lib_server_send:send_to_sid(Player#player_status.sid, BinData),
	{ok, NewPlayer2}.

check_gain_stage_reward(Player, DunId, Wave) ->
	#player_status{dungeon = #status_dungeon{wave_map = WaveMap}} = Player,
	case data_dungeon:get(DunId) of
		#dungeon{type = ?DUNGEON_TYPE_DRAGON} ->
			IsDragonType = true;
		_ ->
			IsDragonType = false
	end,
	case data_dungeon_wave:get_wave_helper(DunId, Wave) of
		#dungeon_wave_helper{stage_reward = StageReward} ->
			skip;
		_ ->
			StageReward = []
	end,
	DungeonWave = maps:get(DunId, WaveMap, []),
	case {IsDragonType, StageReward, DungeonWave} of
		{false, _, _} ->
			{false, ?FAIL};
		{_, [], _} ->
			{false, ?FAIL};
		{_, _, []} ->
			{false, ?FAIL};
		{_, _, #role_dungeon_wave{history_wave = HistoryWave, get_list = GetList}} ->
			IsGet = lists:member(Wave, GetList),
			if
				Wave > HistoryWave ->
					{false, ?FAIL};
				IsGet ->
					{false, ?ERRCODE(err610_had_receive_reward)};
				true ->
					{true, DungeonWave, StageReward}
			end
	end.

%% ---------------------------------------------------------------------------
%% @doc 获取波数通过记录
-spec get_wave_pass_time(Player, DunId, Wave) ->
	Time when
	Player :: #player_status{},
	DunId :: integer(),
	Wave :: integer(),
	Time :: integer().
%% ---------------------------------------------------------------------------
get_wave_pass_time(Player, DunId, Wave) ->
	#player_status{dungeon = #status_dungeon{wave_map = WaveMap}} = Player,
	DungeonWave = maps:get(DunId, WaveMap, []),
	?MYLOG("dundragon", "DungeonWave ~p~n", [DungeonWave]),
	PassTimeList = ?IF(is_record(DungeonWave, role_dungeon_wave), DungeonWave#role_dungeon_wave.pass_time_list, []),
	case lists:keyfind(Wave, 1, PassTimeList) of
		{Wave, Time} ->
			Time;
		_ ->
			0
	end.

%% 奖励列表类型
-type object_list() :: [{ObjectType :: integer(), GoodsTypeId :: integer(), GoodsNum :: integer()}].
%% ---------------------------------------------------------------------------
%% @doc 获取总波数奖励 ,波数有首次通关奖励
-spec get_dungeon_total_wave_award(DunId, StartWave, FinishWave, HistoryWave, Count) ->
	AwardList when
	StartWave :: integer(),
	DunId :: integer(),
	FinishWave :: integer(),
	HistoryWave :: integer(),
	Count :: integer(),
	AwardList :: object_list().
%% ---------------------------------------------------------------------------
get_dungeon_total_wave_award(DunId, StartWave, FinishWave, HistoryWave, Count) ->
	WaveList = lists:seq(min(StartWave + 1, FinishWave), FinishWave),
	F = fun(Wave, AccList) ->
		case data_dungeon_wave:get_wave_helper(DunId, Wave) of
			#dungeon_wave_helper{reward = Reward, first_reward = FirstReward} ->
				RewardN = [{N1, N2, Num * Count} || {N1, N2, Num} <- Reward],
				if
					Wave > HistoryWave ->
						FirstReward ++ AccList ++ RewardN;
					true ->
						RewardN ++ AccList
				end;
			_ ->
				AccList
		end
	end,
	AwardList = lists:foldl(F, [], WaveList),
%%	?MYLOG("dundragon", "WaveList ~p  FinishWave ~p  HistoryWave ~p   AwardList ~p~n", [WaveList, FinishWave, HistoryWave, AwardList]),
	lib_goods_api:make_reward_unique(AwardList).


dunex_get_send_reward(
	#dungeon_state{dun_id = DunId, finish_wave_list = FinishWaveList, typical_data = DataMap} = State
	, #dungeon_role{history_wave = HistoryWave, help_type = ?HELP_TYPE_NO, id = RoleId, count = Count} = DungeonRole
) ->
	FinishWave = ?IF(FinishWaveList == [], 0, lists:max(FinishWaveList)),
	StartWave = maps:get(?DUN_STATE_SPECIAL_KEY_DRAGON_JUMP_WAVE, DataMap, 0),
	Reward = lib_dun_dragon:get_dungeon_total_wave_award(DunId, StartWave, FinishWave, HistoryWave, Count),
	%%处理首通
	case data_dungeon:get(DunId) of
		#dungeon{wave_num = WaveNum, count_deduct = CountDeduct} ->
			if
				FinishWave >= WaveNum - 1 ->
					SubModuleId = if CountDeduct =:= ?DUN_COUNT_DEDUCT_ENTER ->
						?MOD_DUNGEON_ENTER; true ->
						?MOD_DUNGEON_SUCCESS end,
					lib_dungeon_mod:apply_cast_to_local(State, DungeonRole, mod_counter, increment_offline,
						[RoleId, ?MOD_DUNGEON, SubModuleId, DunId]);
				true ->
					ok
			end;
		_ ->
			ok
	end,
	[{?REWARD_SOURCE_DUNGEON, Reward}];

dunex_get_send_reward(State, #dungeon_role{id = RoleId, node = Node, typical_data = TypicalData, help_type = ?HELP_TYPE_YES} = DunRole) ->
	#dungeon_state{dun_id = DunId, dun_type = DunType, result_type = ResultType, finish_wave_list = FinishWaveList} = State,
	FinishWave = ?IF(FinishWaveList == [], 0, lists:max(FinishWaveList)),
	%%处理首通
	case data_dungeon:get(DunId) of
		#dungeon{wave_num = WaveNum, count_deduct = CountDeduct} ->
			if
				FinishWave >= WaveNum - 1 ->
					SubModuleId = if CountDeduct =:= ?DUN_COUNT_DEDUCT_ENTER ->
						?MOD_DUNGEON_ENTER; true ->
						?MOD_DUNGEON_SUCCESS end,
					lib_dungeon_mod:apply_cast_to_local(State, DunRole, mod_counter, increment_offline,
						[RoleId, ?MOD_DUNGEON, SubModuleId, DunId]);
				true ->
					ok
			end;
		_ ->
			ok
	end,
	case ResultType of
		?DUN_IS_END_NO ->
			[];
		_ ->
			case data_dungeon_special:get(DunType, help_rewards) of
				{NumLimit, Rewards} ->
					HelpNum = maps:get(help_num, TypicalData, NumLimit),
%%                    ?MYLOG("cym", "~p ~n", [{NumLimit, HelpNum}]),
					LeftNum = NumLimit - HelpNum,
					if
						LeftNum > 0 ->
							CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
							unode:apply(Node, mod_daily, increment_offline, [RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP_AWARD, CountType]),
							[{?REWARD_SOURCE_DUNGEON, Rewards}];
						true ->
							[{?REWARD_SOURCE_DUNGEON, Rewards}]
					end;
				_ ->
					[]
			end
	end;
dunex_get_send_reward(_, _) -> [].

dunex_push_settlement(#dungeon_state{dun_type = _DunType, start_time = StartTime, result_time = _EndTime, finish_wave_list = FinishWaveList, result_type = ResType} = State,
	#dungeon_role{reward_map = RewardMap, history_wave = HistoryWave, count = Count} = DungeonRole) ->
	EndTime = ?IF(ResType == ?DUN_RESULT_TYPE_NO, utime:unixtime(), _EndTime),
	#dungeon_state{
		result_type = ResultType,
		dun_id = DunId,
		now_scene_id = SceneId,
		result_subtype = ResultSubtype
	} = State,
	Grade
		= if
		ResultType =/= ?DUN_RESULT_TYPE_SUCCESS ->
			0;
		true ->
			Score = lib_dungeon:calc_score(State, DungeonRole#dungeon_role.id),
			case data_dungeon_grade:get_dungeon_grade(DunId, Score) of
				#dungeon_grade{grade = Value} ->
					Value;
				_ ->
					0
			end
	end,
	RewardList = lib_dungeon:get_source_list(RewardMap),
	?MYLOG("dundragon", "RewardList ~p~n", [RewardList]),
	MultipleReward = maps:get(?REWARD_SOURCE_DUNGEON_MULTIPLE, RewardMap, []),
	FinishWave = ?IF(FinishWaveList == [], 0, lists:max(FinishWaveList)),
	%% 5 龙纹副本通关时间
	%% 6 龙纹副本防守波数
	%% 7 龙纹副本历史最高防守波数
	case MultipleReward of
		[] ->
			{ok, BinData} = pt_610:write(61003, [?SUCCESS, ResultSubtype, DunId, Grade, SceneId, RewardList,
				[], [{5, EndTime - StartTime}, {6, FinishWave}, {7, HistoryWave}], Count]);
		_ ->
			{ok, BinData} = pt_610:write(61003, [?SUCCESS, ResultSubtype, DunId, Grade, SceneId, RewardList,
				[{?DUNGEON_PUSH_SETTLE_MULTIPLE_REWARD, MultipleReward}], [{5, EndTime - StartTime}, {6, FinishWave}, {7, HistoryWave}], Count])
	end,
%%	?MYLOG("dundragon", " ~p ~p  ~p~n", [{5, EndTime - StartTime}, {6, FinishWave}, {7, HistoryWave}]),
	DungeonRole#dungeon_role.help_type =/= ?HELP_TYPE_ASSIST andalso
		lib_dungeon_mod:send_to_uid(DungeonRole#dungeon_role.node, DungeonRole#dungeon_role.id, BinData).

init_dungeon_role(#player_status{id = Id}, #dungeon{id = DunId, type = DunType}, #dungeon_role{help_type = ?HELP_TYPE_YES} = Role) ->
	CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
	HelpNum = mod_daily:get_count_offline(Id, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP_AWARD, CountType),
	Role#dungeon_role{typical_data = #{help_num => HelpNum}};

init_dungeon_role(_, _, Role) ->
	Role.


dunex_get_scene_args(#player_status{dungeon = #status_dungeon{help_type = HelpType}}) ->
	[{collect_checker, {lib_dun_dragon, collect_checker, {HelpType}}}].

dunex_get_quit_scene_args(#player_status{dungeon = #status_dungeon{help_type = _HelpType}}) ->
	[{collect_checker, undefined}].

collect_checker(_ModId, _ModCfgId, {HelpType}) ->
%%	?MYLOG("cym", "HelpType ~p~n", [HelpType]),
	case HelpType of
		?HELP_TYPE_YES ->
			{false, ?ERRCODE(err610_help_can_not_collect)};
		?HELP_TYPE_ASSIST ->
			{false, ?ERRCODE(err610_help_can_not_collect)};
		_ ->
			true
	end.

dunex_is_calc_result_before_finish() ->
	true.

repair_dun_wave() ->
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_dun_dragon, repair_dun_wave, []) || E <- OnlineRoles],
	ok.

repair_dun_wave(Ps) ->
	lib_dungeon:login(Ps).

%% -----------------------------------------------------------------
%% @desc     功能描述  获取进入龙纹副本的前一波野怪
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_enter_wave(RoleList, DunId, StartArg) ->
	PowerList = [Power || #dungeon_role{combat_power = Power} <- RoleList],
	F = fun(A, B) ->
		A >= B
	end,
	{_, DumyPowerList} = ulists:keyfind(dumy_power, 1, StartArg, {dumy_power, []}),
	SortList = lists:sort(F, PowerList ++ DumyPowerList),
	AVGPower = get_avg_power(SortList),
	MaxWave = get_dragon_dungeon_enter_wave(DunId, AVGPower),
	F2 = fun(#dungeon_role{history_wave = HistoryWawe}, Min) ->
		case HistoryWawe < Min of
			true -> HistoryWawe;
			_ -> Min
		end end,
	MinWave = lists:foldl(F2, 99999, RoleList),
	max(min(MaxWave, MinWave) - 9, 0).

%%龙纹的那个组队跳关的战力计算用这个：
%%如果是一个人，则按照：一个人的战力跳关
%%如果是两个人，则按照：战力第1*0.8+战力第2*0.2
%%如果是三个人，则按照：战力第1*0.4+战力第2*0.3+战力第3*0.2
get_avg_power([]) ->
	0;
get_avg_power([A]) ->
	erlang:round(A * 0.4);
get_avg_power([A, B]) ->
	erlang:round(A * 0.4 + B * 0.3);
get_avg_power([A, B, C | _]) ->
	erlang:round(A * 0.4 + B * 0.3 + C * 0.2).

%% -----------------------------------------------------------------
%% @desc     功能描述  处理玩家跳过波数的奖励
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle_wave_reward(RoleList, CurWave, DunId) ->
	{DrawList, Reward} =
		case data_dungeon:get_dragon_dungeon_reward(DunId, CurWave) of
			[] ->
				{[], []};
			V ->
				V
		end,
%%	Title = utext:get(6100006),
%%	Content = utext:get(6100007, [CurWave]),
	List = lib_dungeon_api:get_dungeon_grade_help(DrawList, Reward, []),
	NewList = [{GoodType, GoodId, Num} || {GoodType, GoodId, Num}<-List, Num > 0 andalso {GoodType, GoodId, Num} =/= {0, 0, 0}],  %%波数的掉落奖励
	[begin
		RoleReward = lib_dun_dragon:get_dungeon_total_wave_award(DunId, 0, CurWave, HistoryWave, Count),
		NewListN = [{N1, N2, Num * Count} || {N1, N2, Num} <- NewList],
		LastReward = RoleReward ++ NewListN,
		if
			LastReward == [] ->
				skip;
			true ->
				Produce = #produce{reward = LastReward, type = dun_dragon_jump_wave_reward},
				mod_clusters_center:apply_cast(Node,lib_goods_api, send_reward_with_mail, [RoleId, Produce]),
				{ok, Bin} = pt_610:write(61058, [CurWave, RoleReward ++ NewList]),
				lib_server_send:send_to_uid(Node, RoleId, Bin)
		end
	end
		|| #dungeon_role{node = Node, id = RoleId, history_wave = HistoryWave, help_type = Type, count = Count} <-RoleList, Type == 0].

%% -----------------------------------------------------------------
%% @desc     功能描述  获取跳关波数
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_dragon_dungeon_enter_wave(DunId, Power) ->
	List = data_dungeon:get_dragon_dungeon_enter_wave(DunId),
	get_dragon_dungeon_enter_wave2(lists:reverse(List), Power).
get_dragon_dungeon_enter_wave2([], _Power) ->
	1;
get_dragon_dungeon_enter_wave2([{Wave, NeedPower} | List], Power) ->
	if
		Power >= NeedPower ->
			Wave;
		true ->
			get_dragon_dungeon_enter_wave2(List, Power)
	end.