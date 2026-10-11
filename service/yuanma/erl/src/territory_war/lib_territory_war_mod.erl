
-module(lib_territory_war_mod).

-compile(export_all).
-include("territory_war.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("clusters.hrl").


%% 初始化
init_center(State, InfoList) ->
	{ServerMap, ServerMergeMap} = init_server_map(InfoList),
	NowTime = utime:unixtime(),
	DbGuildList = lib_territory_war_data:db_select_terri_guild(),
	DbHisGroupList = lib_territory_war_data:db_select_history_group(),
	DbHisWarList = lib_territory_war_data:db_select_history_warlist(),
	{GuildMap, ServerGuildMap} = init_guild_map(DbGuildList, #{}, #{}),
	NewServerMap = init_set_guild_to_server(ServerMap, ServerGuildMap),
	History = init_history(DbHisGroupList, DbHisWarList),
	NewState = State#terri_state{
		server_map = NewServerMap, guild_map = GuildMap,
		history = History, is_init = 1
	},
	%% 判断活动是否要开启
	{StartTime, ReadyTime} = lib_territory_war_data:get_territory_war_time(NowTime),
	case NowTime < ReadyTime of
		true ->
			case NowTime < utime:unixdate(NowTime) + 4 * ?ONE_HOUR_SECONDS of
				true -> %% 还没到分服的时间，不用处理活动开启，因为在4点重新分服会开启活动
					LastState = NewState;
				_ ->
					RefState = util:send_after([], max(ReadyTime - NowTime, 1)*1000, self(), {war_ready}),
					LastState = NewState#terri_state{war_state = ?WAR_STATE_PRE_READY, ready_time = ReadyTime, start_time = StartTime, end_time = 0, ref_state = RefState}
			end;
		_ -> %% 服务器起来时，已经过了活动开始时间，不开活动
			LastState = NewState
	end,
	sync_game_server_info(LastState, ServerMergeMap),
	LastState.

sync_game_server_info(State, ServerMergeMap) ->
	#terri_state{
		round = Round, war_state = WarState, ready_time = ReadyTime, start_time = StartTime, end_time = EndTime, server_map = ServerMap
	} = State,
	F = fun({ServerId, TerriServer}) ->
		MergeSerIds = maps:get(ServerId, ServerMergeMap, []),
		MergeServerIdList = [MergeSerId ||MergeSerId <- MergeSerIds, MergeSerId =/= ServerId andalso maps:get(MergeSerId, ServerMap, 0) =/= 0],
		F = fun(MergeSerId, List) ->
			case maps:get(MergeSerId, ServerMap, 0) of
				#terri_server{} = MergeTerriServer -> [MergeTerriServer|List];
				_ -> List
			end
		end,
		MergeServerList = lists:foldl(F, [], MergeServerIdList),
		mod_clusters_center:apply_cast(ServerId, mod_territory_war, sync_server_data_local, [Round, WarState, ReadyTime, StartTime, EndTime, TerriServer, MergeServerList])
	end,
	lists:foreach(F, maps:to_list(ServerMap)).



%% 初始化
init(State) ->
	case State#terri_state.is_cls of 
		1 ->
			%State;
			init_center(State);
		_ ->
			init_local(State)
	end.


init_center(State) ->
	NowTime = utime:unixtime(),
	DbServerList = lib_territory_war_data:db_select_terri_server(),
	DbGuildList = lib_territory_war_data:db_select_terri_guild(),
	DbHisGroupList = lib_territory_war_data:db_select_history_group(),
	DbHisWarList = lib_territory_war_data:db_select_history_warlist(),
	{ServerMap, AccGroup} = init_server_map(DbServerList, 0, #{}),
	{GuildMap, ServerGuildMap} = init_guild_map(DbGuildList, #{}, #{}),
	NewServerMap = init_set_guild_to_server(ServerMap, ServerGuildMap),
	History = init_history(DbHisGroupList, DbHisWarList),
	NewState = State#terri_state{
		acc_group = AccGroup, server_map = NewServerMap, guild_map = GuildMap, history = History
	},
	%% 判断活动是否要开启
	{StartTime, ReadyTime} = lib_territory_war_data:get_territory_war_time(NowTime),
	case DbServerList == [] of 
		true -> %% 第一次启动
			?PRINT("first_start first_start ~p~n", [first_start]),
			mod_zone_mgr:kf_terri_war_init();
		_ -> skip
	end,
	case NowTime < ReadyTime of 
		true ->
			case NowTime < utime:unixdate(NowTime) + 4 * ?ONE_HOUR_SECONDS of 
				true -> %% 还没到分服的时间，不用处理活动开启，因为在4点重新分服会开启活动
					NewState;
				_ ->
					RefState = util:send_after([], max(ReadyTime - NowTime, 1)*1000, self(), {war_ready}),
					?PRINT("init_center init_center ~p~n", [{ReadyTime, StartTime}]),
					NewState#terri_state{war_state = ?WAR_STATE_PRE_READY, ready_time = ReadyTime, start_time = StartTime, end_time = 0, ref_state = RefState}
			end;
		_ -> %% 服务器起来时，已经过了活动开始时间，不开活动
			NewState
	end.

init_local(State) ->
	DbServerList = lib_territory_war_data:db_select_local_terri_server(),
	DbGuildList = lib_territory_war_data:db_select_local_terri_guild(),
	DbHisGroupList = lib_territory_war_data:db_select_local_history_group(),
	DbHisWarList = lib_territory_war_data:db_select_local_history_warlist(),
	DbConsecutive = lib_territory_war_data:db_select_local_consecutive_win(),
	{ServerMap, AccGroup} = init_server_map(DbServerList, 0, #{}),
	{GuildMap, ServerGuildMap} = init_guild_map(DbGuildList, #{}, #{}),
	NewServerMap = init_set_guild_to_server(ServerMap, ServerGuildMap),
	History = init_history(DbHisGroupList, DbHisWarList),
	ConsecutiveWin = init_consecutive_win(DbConsecutive),
	%% 向跨服中心请求数据
	util:send_after([], (?SYNC_SERVER_DATA_TIME + 60)*1000, self(), {start_sync_server}),
	NewState = State#terri_state{
		acc_group = AccGroup, server_map = NewServerMap, guild_map = GuildMap, history = History, consecutive_win = ConsecutiveWin
	},
	%% 判断活动是否要开启
	NowTime = utime:unixtime(),
	{StartTime, ReadyTime} = lib_territory_war_data:get_territory_war_time_local(NowTime),
	case NowTime < ReadyTime of 
		true ->
			case NowTime < utime:unixdate(NowTime) + 4 * ?ONE_HOUR_SECONDS of 
				true -> %% 还没到分服的时间，不用处理活动开启，因为在4点会重新检查互动开启
					NewState;
				_ ->
					RefState = util:send_after([], max(ReadyTime - NowTime, 1)*1000, self(), {war_ready}),
					?PRINT("init_local init_local ~p~n", [{ReadyTime, StartTime}]),
					NewState#terri_state{war_state = ?WAR_STATE_PRE_READY, ready_time = ReadyTime, start_time = StartTime, end_time = 0, ref_state = RefState}
			end;
		_ -> %% 服务器起来时，已经过了活动开始时间，不开活动
			NewState
	end.

init_server_map(InfoList) ->
	F = fun({ZoneId, {Servers, GroupInfo}}, {AccServerMap, AccMergeMap}) ->
		#zone_group_info{group_mod_servers = GroupModServers} = GroupInfo,
		MapList =
			[begin
				 [begin
					  #zone_base{server_num = ServerNum, server_name = ServerName, world_lv = Wlv, time = OpenTime} =
						  ulists:keyfind(SerId, #zone_base.server_id, Servers, #zone_base{}),
					  TerriServer = lib_territory_war_data:make(terri_server, [SerId, ServerNum, ServerName, ZoneId, OpenTime, Wlv, Mod, GroupId]),
					  {SerId, TerriServer}
				  end||SerId<-ServerIds]
			 end||#zone_mod_group_data{group_id = GroupId, mod = Mod, server_ids = ServerIds}<-GroupModServers],
		Map = maps:from_list(lists:flatten(MapList)),
		NewAccServerMap = maps:merge(AccServerMap, Map),
		Map2 = maps:from_list([{SerId, MergeIds}||#zone_base{server_id = SerId, merge_ids = MergeIds}<-Servers]),
		NewAccMergeMap = maps:merge(AccMergeMap, Map2),
		{NewAccServerMap, NewAccMergeMap}
		end,
	{ServerMap, ServerMergeMap} = lists:foldl(F, {#{}, #{}}, InfoList),
	{ServerMap, ServerMergeMap}.

init_server_map([], GroupId, Map) -> {Map, GroupId};
init_server_map([[ServerId, ServerNum, ServerName, ZoneId, OpenTime, Wlv, Mode, Group]|DbServerList], GroupId, Map) ->
	TerriServer = lib_territory_war_data:make(terri_server, [ServerId, ServerNum, ServerName, ZoneId, OpenTime, Wlv, Mode, Group]),
	NewGroupId = ?IF(Group > GroupId, Group, GroupId),
	init_server_map(DbServerList, NewGroupId, maps:put(ServerId, TerriServer, Map)).

init_guild_map([], Map1, Map2) -> {Map1, Map2};
init_guild_map([[GuildId, GuildName, ServerId, ServerNum, ChooseTerritoryId, WinNum]|DbGuildList], Map1, Map2) ->
	TerriGuild = lib_territory_war_data:make(terri_guild, [GuildId, GuildName, ServerId, ServerNum, ChooseTerritoryId, WinNum]),
	NewMap1 = maps:put(GuildId, TerriGuild, Map1),
	L = maps:get(ServerId, Map2, []),
	init_guild_map(DbGuildList, NewMap1, maps:put(ServerId, [GuildId|L], Map2)).

init_set_guild_to_server(ServerMap, ServerGuildMap) ->
	F = fun(ServerId, GuildIdList, Map) ->
		case maps:get(ServerId, Map, 0) of 
			#terri_server{} = TerriServer ->
				maps:put(ServerId, TerriServer#terri_server{guild_list = GuildIdList}, Map);
			_ -> Map
		end
	end,
	maps:fold(F, ServerMap, ServerGuildMap).

init_history(DbHisGroupList, DbHisWarList) ->
	HisDateGroupMap = init_history_group(DbHisGroupList, #{}),
	HisDateWarMap = init_history_war(DbHisWarList, HisDateGroupMap),
	maps:to_list(HisDateWarMap).

init_history_group([], Map) ->
	Map;
init_history_group([[DateId, GroupId, WinnerServerId, WinnerGuild, WinNum, ServerListStr]|DbHisGroupList], Map) ->
	TerriGroup = lib_territory_war_data:make(terri_group, [GroupId, WinnerServerId, WinnerGuild, WinNum, util:bitstring_to_term(ServerListStr)]),
	GroupMap = maps:get(DateId, Map, #{}),
	NewMap = maps:put(DateId, maps:put(GroupId, TerriGroup, GroupMap), Map),
	init_history_group(DbHisGroupList, NewMap).

init_history_war([], Map) -> 
	Map;
init_history_war([Info|DbHisWarList], Map) -> 
	[DateId, GroupId, WarId, Round, TerritoryId, AGuildId, AServerId, 
		AServerNum, AGuildName, BGuildId, BServerId, BServerNum, BGuildName, Winner] = Info,
	TerriWar = lib_territory_war_data:make(terri_war, [GroupId, WarId, Round, TerritoryId, AGuildId, AServerId, AServerNum, AGuildName, BGuildId, BServerId, BServerNum, BGuildName, Winner]),
	GroupMap = maps:get(DateId, Map, #{}),
	case maps:get(GroupId, GroupMap, 0) of 
		#terri_group{war_list = WarList} = TerriGroup ->
			NewGroupMap = maps:put(GroupId, TerriGroup#terri_group{war_list = [TerriWar|WarList]}, GroupMap),
			init_history_war(DbHisWarList, maps:put(DateId, NewGroupMap, Map));
		_ ->
			init_history_war(DbHisWarList, Map)
	end.

init_consecutive_win([]) ->
	#consecutive_win{};
init_consecutive_win(DbConsecutive) ->
	ConsecutiveWin = lib_territory_war_data:make(consecutive_win, DbConsecutive),
	ConsecutiveWin.

%% 定时器初始化
% create_new_war_timer(State) ->
% 	#terri_state{ref_state = OldRefState, ref_stage = OldRefStage} = State,
% 	util:cancel_timer(OldRefState), util:cancel_timer(OldRefStage),
% 	NowTime = utime:unixtime(),
% 	{StartTime, ReadyTime} = lib_territory_war_data:get_territory_war_time(NowTime),
% 	case StartTime < NowTime of 
% 		false ->
% 			RefState = util:send_after([], max(ReadyTime - NowTime, 1)*1000, self(), {war_ready}),
% 			%% 同步活动状态到游戏服
% 			async_war_state([?WAR_STATE_PRE_READY, ReadyTime, StartTime, 0]),
% 			State#terri_state{war_state = ?WAR_STATE_PRE_READY, ready_time = ReadyTime, start_time = StartTime, end_time = 0, ref_state = RefState};
% 		_ ->
% 			State#terri_state{war_state = 0, start_time = 0, end_time = 0}
% 	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 进入准备状态
war_ready(State) ->
	#terri_state{
		is_cls = IsCls, ready_time = ReadyTime, start_time = StartTime, server_map = ServerMap, guild_map = GuildMap, ref_state = OldRefState
	} = State,
	NowTime = utime:unixtime(),
	EndTime = StartTime + data_territory_war:get_cfg(?TERRI_KEY_3),
	RefState = util:send_after(OldRefState, max(StartTime - NowTime, 1) * 1000, self(), {war_start}),
	State1 = State#terri_state{war_state = ?WAR_STATE_READY, end_time = EndTime, ref_state = RefState},
	case IsCls of 
		1 -> %% 跨服
			%% 创建战斗
			{NewAccWarId, GroupMap} = create_group_war(1, ServerMap, GuildMap),
			?PRINT("war_ready###111 GroupMap ~p~n", [GroupMap]),
			NewState = State1#terri_state{acc_war_id = NewAccWarId, group_map = GroupMap};
		_ ->
			?PRINT("war_ready#########22222 ~n", []),
			%%发传闻
            lib_chat:send_TV({all_guild}, ?MOD_TERRITORY_WAR, ?TERRI_WAR_LANGUAGE_1, []),
            %% 活动状态广播
            {ok, Bin} = pt_506:write(50600, [?WAR_STATE_READY, ReadyTime, StartTime, EndTime]),
            lib_server_send:send_to_all(Bin),
            case lib_territory_war_data:fight_in_local(State1) of 
                true ->
                    #terri_state{server_map = ServerMap, guild_map = GuildMap} = State1,
                    {NewAccWarId, GroupMap} = lib_territory_war_mod:create_group_war(1, ServerMap, GuildMap),
                    ?PRINT("war_ready###222 GroupMap ~p~n", [GroupMap]),
                    NewState = State1#terri_state{acc_war_id = NewAccWarId, group_map = GroupMap};
                _ ->
                    NewState = State1
            end
	end,
	NewState.

war_start(State) ->
	#terri_state{
		is_cls = IsCls, ready_time = ReadyTime, start_time = StartTime, end_time = EndTime, ref_state = OldRefState, guild_map = GuildMap
	} = State,
	NowTime = utime:unixtime(),
	RefState = util:send_after(OldRefState, max(EndTime + 5 - NowTime, 1) * 1000, self(), {war_end}),
	State1 = State#terri_state{war_state = ?WAR_STATE_START, ref_state = RefState},
	case IsCls of 
		1 ->
			?PRINT("war_start#########11111 ~n", []),
			NewState = start_round_fight(?WAR_ROUND_1, State1);
		_ ->
			?PRINT("war_start#########22222 ~n", []),
			{ok, Bin} = pt_506:write(50600, [?WAR_STATE_START, ReadyTime, StartTime, EndTime]),
            lib_server_send:send_to_all(Bin),
			lib_activitycalen_api:success_start_activity(?MOD_TERRITORY_WAR),
			mod_activity_onhook:act_enter(?MOD_TERRITORY_WAR, 0, maps:keys(GuildMap)),
			case lib_territory_war_data:fight_in_local(State1) of 
                true ->
                	?PRINT("war_start#########22222 ~n", []),
                    NewState = lib_territory_war_mod:start_round_fight(?WAR_ROUND_1, State1);
                _ ->
                    NewState = State1
            end
	end,
	NewState.


war_end(State) ->
	#terri_state{
		is_cls = IsCls
	} = State,
	State1 = State#terri_state{war_state = ?WAR_STATE_END, ready_time = 0, start_time = 0, end_time = 0},
	case IsCls of 
		1 ->
			%% 战场活动数据写入历史数据中
			?PRINT("war_end#########11111 ~n", []),
			util:send_after([], 30000, self(), {store_history}),
			NewState = State1;
		_ ->
			%% 非跨服时，活动结束已经将本服相关的历史数据协议，不需要延时写入
			?PRINT("war_end#########22222 ~n", []),
			%%关闭图标
    		lib_activitycalen_api:success_end_activity(?MOD_TERRITORY_WAR),
			NewState = State1
	end,
	NewState.

%% 结算当前轮次，准备进入下一轮
next_round(State, NextRoundStartTime) ->
	#terri_state{
		acc_war_id = AccWarId, is_cls = IsCls, round = Round, server_map = ServerMap, 
		guild_map = GuildMap, group_map = GroupMap, ref_stage = OldRefStage
	} = State,
	NowTime = utime:unixtime(),
	RefStage = util:send_after(OldRefStage, max(NextRoundStartTime - NowTime, 1)*1000, self(), {next_round_fight}),
	%% 超时结束还没进入战场结算的话，强制结算(随机胜者)，一般全部战场都已经结束了
	{NewAccWarId, NewGroupMap} = force_end_all_war(AccWarId, Round, GroupMap, ServerMap, GuildMap),
	%% 广播轮次的时间信息
	lib_territory_war:broadcast_round_time_info(IsCls, Round, NextRoundStartTime, 0),
	State#terri_state{acc_war_id = NewAccWarId, round_start_time = NextRoundStartTime, group_map = NewGroupMap, ref_stage = RefStage}.

next_round_fight(State) ->
	#terri_state{
		acc_war_id = AccWarId, round = Round,
		server_map = ServerMap, guild_map = GuildMap, group_map = GroupMap
	} = State,
	?PRINT("next_round_fight start round:~p~n", [Round]),
	case Round == ?WAR_ROUND_3 of 
		true ->
			%% 轮空处理
			{LastAccWarId, LastGroupMap} = handle_war_bye(AccWarId, Round, GroupMap, ServerMap, GuildMap), 
			State#terri_state{acc_war_id = LastAccWarId, group_map = LastGroupMap};
		_ ->
			NewRound = Round + 1,
			StateAfRound = start_round_fight(NewRound, State),
			StateAfRound
	end.

start_round_fight(Round, State) ->
	#terri_state{
		acc_war_id = AccWarId, is_cls = IsCls, server_map = ServerMap, 
		guild_map = GuildMap, group_map = GroupMap
	} = State,
	NowTime = utime:unixtime(),
	RoundDuration = lib_territory_war_data:get_round_duration(Round),
	RoundPrepareTime = lib_territory_war_data:get_round_prepare_time(),
	RoundGapTime = lib_territory_war_data:get_round_gap_time(),
	case Round == ?WAR_ROUND_3 of 
		true -> %% 最后一轮
			NextRoundStartTime = 0;
		_ -> 
			NextRoundStartTime = NowTime + RoundDuration + RoundGapTime
	end,
	RefStage = util:send_after([], (RoundDuration+RoundPrepareTime)*1000, self(), {next_round, NextRoundStartTime}),
	%% 轮空处理
	{NewAccWarId, NewGroupMap} = handle_war_bye(AccWarId, Round, GroupMap, ServerMap, GuildMap),
	%% 刷新每个组的当前轮次
	NewGroupMap1 = refresh_group_round(NewGroupMap),
	?PRINT("start_round_fight start round:~p~n", [{Round, NextRoundStartTime - NowTime}]),
	%% 开启战场
	FightEndTime = NowTime + RoundDuration,
	LastGroupMap = start_fight(Round, NewGroupMap1, ServerMap, GuildMap, NowTime, FightEndTime),
	%?PRINT("start_round_fight LastGroupMap :~p~n", [LastGroupMap]),
	%?MYLOG("lxl_war", "start_round_fight Round: ~p~n, LastGroupMap: ~p~n", [Round, LastGroupMap]),
	RoundEndTime = FightEndTime + RoundPrepareTime,
	%% 广播轮次的时间信息
	lib_territory_war:broadcast_round_time_info(IsCls, Round, NowTime, RoundEndTime),
	%% 轮次开启广播传闻
	case IsCls of 
		1 ->
			mod_clusters_center:apply_to_all_node(mod_territory_war, start_round_language, [Round, 1], 20);
		_ ->
			mod_territory_war:start_round_language(Round, 0)
	end,
	State#terri_state{acc_war_id = NewAccWarId, round = Round, round_start_time = NowTime, round_end_time = RoundEndTime, group_map = LastGroupMap, ref_stage = RefStage}.

war_fight_end(State, Group, WarId, Winner) ->
	?PRINT("war_fight_end : ~p~n", [{Group, WarId, Winner}]),
	#terri_state{
		acc_war_id = AccWarId, server_map = _ServerMap, 
		guild_map = GuildMap, group_map = GroupMap
	} = State,
	case maps:get(Group, GroupMap, 0) of 
		#terri_group{war_list = WarList} = TerriGroup ->
			case lists:keyfind(WarId, #terri_war.war_id, WarList) of 
				#terri_war{round = Round, winner = OldWinner} = TerriWar when OldWinner == 0 ->
					WarList1 = lists:keystore(WarId, #terri_war.war_id, WarList, TerriWar#terri_war{winner = Winner}),
					case Round == ?WAR_ROUND_3 of 
						true -> %% 最后一轮结束
							NewTerriGroup = check_emerge_winner_single(TerriGroup#terri_group{war_list = WarList1}, GuildMap),
							NewAccWarId = AccWarId;
						_ ->
							{NewAccWarId, LastWarList} = create_war_when_battle_end(AccWarId, Group, Round, Round+1, GuildMap, WarList1),
							NewTerriGroup = TerriGroup#terri_group{war_list = LastWarList}
					end,
					NewGroupMap = maps:put(Group, NewTerriGroup, GroupMap),
					State#terri_state{acc_war_id = NewAccWarId, group_map = NewGroupMap};
				_ ->
					State
			end;
		_ ->
			State
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 每天4点重新分服
sync_zone_group(State, InfoList) ->
	{NewServerMap, _} = init_server_map(InfoList),
	?PRINT("NewServerMap ~p ~n", [NewServerMap]),
	%% db 分组信息
	%% db删除旧的分服数据
	lib_territory_war_data:db_clear_territory_server(),
	lib_territory_war_data:db_clear_territory_guild(),
	lib_territory_war_data:db_batch_replace_terri_server(NewServerMap),
	%% 清除一些进程字典信息
	lib_territory_war_mod:clear_async_guild_info(),
	%% 向游戏服获取公会信息
	async_divide_server_info(NewServerMap, State#terri_state.start_time),
	%?MYLOG("lxl_war", "reset_territory NewServerMap : ~p~n", [NewServerMap]),
	State#terri_state{server_map = NewServerMap}.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 每天4点重新分服
reset_territory(State, AllZoneId) ->
	#terri_state{acc_group = AccGroup, start_time = StartTime, server_map = ServerMap} = State,
	%% 服务器分组
	{NewServerMap, NewAccGroup} = divide_terri_server(ServerMap, lists:sort(AllZoneId), AccGroup),
	%% db 分组信息
	%% db删除旧的分服数据
    lib_territory_war_data:db_clear_territory_server(),
    lib_territory_war_data:db_clear_territory_guild(),
	lib_territory_war_data:db_batch_replace_terri_server(NewServerMap),
	%% 清除一些进程字典信息
    lib_territory_war_mod:clear_async_guild_info(),
	%% 向游戏服获取公会信息
	async_divide_server_info(NewServerMap, StartTime),
	?PRINT("reset_territory NewServerMap ~p~n", [NewServerMap]),
	%?MYLOG("lxl_war", "reset_territory NewServerMap : ~p~n", [NewServerMap]),
	State#terri_state{acc_group = NewAccGroup, server_map = NewServerMap}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 游戏服连接跨服中心
center_connected(State, ServerInfo) ->
	#terri_state{
		round = Round, war_state = WarState, ready_time = ReadyTime, start_time = StartTime, end_time = EndTime, server_map = ServerMap
	} = State,
	[ServerId, MergeSerIds] = ServerInfo,
	?PRINT("sync_server_data start ServerId:~p~n", [ServerId]),
	%% 同步上一次活动记录到游戏服
	sync_history_data(State, ServerId),
	TerriServer = maps:get(ServerId, ServerMap, false),
	if
		TerriServer == false -> %% 不存在该服(可能是新服，不让该服开启活动)
			State;
		true -> %% 活动处于准备前，准备，开启状态
			MergeServerIdList = [MergeSerId ||MergeSerId <- MergeSerIds, MergeSerId =/= ServerId andalso maps:get(MergeSerId, ServerMap, 0) =/= 0],
			IsMerge = length(MergeServerIdList) > 0,
			F = fun(MergeSerId, List) ->
				case maps:get(MergeSerId, ServerMap, 0) of 
					#terri_server{} = MergeTerriServer -> [MergeTerriServer|List];
					_ -> List
				end
			end,
			MergeServerList = lists:foldl(F, [], MergeServerIdList),
			case IsMerge of 
				true -> %% 进行了合服
					if
						WarState == ?WAR_STATE_PRE_READY -> %% 准备前阶段，删除MergeServerList, 对主服重新进行分服后的初始化
							?PRINT("sync_server_data################## 2222  ~n", []),
							NewState = handle_merge_server(State, ServerId, MergeServerIdList);
						true -> %% 已经分好战场或者活动已经开始了, 正常不会走这分支，先不做处理
							NewState = State
					end;
				_ -> 
					?PRINT("sync_server_data################## 3333  ~n", []),
					NewState = State
			end,
			spawn(fun() ->
				NowTime = utime:unixtime(),
				SleepTime = ?IF(ReadyTime > NowTime, min(ReadyTime - NowTime - 3, ?SYNC_SERVER_DATA_TIME), ?SYNC_SERVER_DATA_TIME),
				timer:sleep(SleepTime*1000),
				mod_clusters_center:apply_cast(ServerId, mod_territory_war, sync_server_data_local, [Round, WarState, ReadyTime, StartTime, EndTime, TerriServer, MergeServerList])
			end),	
			NewState
	end.

handle_merge_server(State, ServerId, MergeServerIdList) ->
	#terri_state{
		start_time = _StartTime, server_map = ServerMap, guild_map = GuildMap
	} = State,
	OldMainTerriServer = maps:get(ServerId, ServerMap),
	%% 删除合服的公会信息
	F = fun(GuildId, #terri_guild{server_id = TServerId}, {Map, DelList}) ->
		?IF(TServerId == ServerId orelse lists:member(TServerId, MergeServerIdList),
			{maps:remove(GuildId, Map), [GuildId|DelList]}, {Map, DelList}
		)
	end,
	{NewGuildMap, DelGuildIdList} = maps:fold(F, {GuildMap, []}, GuildMap),
	%% 删除主服外的其他服的服务器信息
	NewServerMap = lists:foldl(fun(DelServerId, Map) -> maps:remove(DelServerId, Map) end, ServerMap, MergeServerIdList),
	%% 将主服的参赛公会列表置空
	NewMainTerriServer = OldMainTerriServer#terri_server{guild_list = []},
	LastServerMap = maps:put(ServerId, NewMainTerriServer, NewServerMap),
	lib_territory_war_data:db_delete_territory_server_by_ids(MergeServerIdList),
	lib_territory_war_data:db_delete_territory_guild_by_ids(DelGuildIdList),
	%% 对主服执行一次分服初始化
	State#terri_state{server_map = LastServerMap, guild_map = NewGuildMap}.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 从游戏服返回参赛公会列表
async_guild_to_center(State, ServerId, TerriGuildList) ->
	#terri_state{server_map = ServerMap, guild_map = GuildMap} = State,
	case maps:get(ServerId, ServerMap, 0) of 
		#terri_server{} = TerriServer ->
			NewGuildMap = lists:foldl(fun(TerriGuild, Map) ->
				maps:put(TerriGuild#terri_guild.guild_id, TerriGuild, Map)
			end, GuildMap, TerriGuildList),
			NewTerriServer = TerriServer#terri_server{guild_list = [TerriGuild#terri_guild.guild_id||TerriGuild <- TerriGuildList]},
			NewServerMap = maps:put(ServerId, NewTerriServer, ServerMap),
			lib_territory_war_data:db_replace_terri_guild_list(TerriGuildList),
			State#terri_state{server_map = NewServerMap, guild_map = NewGuildMap};
		_ ->
			State
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 创建战场和分组
create_group_war(AccWarId, ServerMap, GuildMap) ->
	{GroupMap, ServerGuild} = static_terri_group(ServerMap, GuildMap),
	{NewAccWarId, NewGroupMap} = create_group_war(AccWarId, GroupMap, ServerGuild, GuildMap),
	{NewAccWarId, NewGroupMap}.

create_group_war(AccWarId, GroupMap, ServerGuild, GuildMap) ->
	F = fun(Group, TerriGroup, {AccId, Map}) ->
		#terri_group{group_round = GroupRound, server_list = ServerList} = TerriGroup,
		GroupGuildIdList = lists:flatten([maps:get(ServerId, ServerGuild, []) ||ServerId <- ServerList]),
		GroupGuildIdListAf = calc_guild_battle_list(GroupRound, ulists:list_shuffle(GroupGuildIdList), GuildMap),
		{NewAccId, WarList} = create_war(AccId, GroupRound, Group, GuildMap, GroupGuildIdListAf, []),
		%NewWarList = allocate_territory_to_war(WarList, TerritoryIdList, []),
		NewTerriGroup = TerriGroup#terri_group{war_list = WarList},
		{NewAccId, maps:put(Group, NewTerriGroup, Map)}
	end,
	{NewAccWarId, NewGroupMap} = maps:fold(F, {AccWarId, GroupMap}, GroupMap),
	{NewAccWarId, NewGroupMap}.

create_war(AccWarId, _Round, _Group, _GuildMap, [], ReturnList) ->
	{AccWarId, lists:reverse(ReturnList)};
create_war(AccWarId, Round, Group, GuildMap, [{TerritoryId, _, GuildIdList}|GroupGuildIdList], ReturnList) ->
	NewAccWarId = AccWarId + 1,
	case GuildIdList of 
		[AGuildId, BGuildId] ->
			#terri_guild{server_id = AServerId, server_num = AServerNum, guild_name = AGuildName} = maps:get(AGuildId, GuildMap),
			#terri_guild{server_id = BServerId, server_num = BServerNum, guild_name = BGuildName} = maps:get(BGuildId, GuildMap),
			TerriWar = #terri_war{
				group = Group, war_id = NewAccWarId, round = Round, territory_id = TerritoryId,
				a_guild = AGuildId, a_server = AServerId, a_server_num = AServerNum, a_guild_name = AGuildName,
				b_guild = BGuildId, b_server = BServerId, b_server_num = BServerNum, b_guild_name = BGuildName
			},
			create_war(NewAccWarId, Round, Group, GuildMap, GroupGuildIdList, [TerriWar|ReturnList]);
		[AGuildId] ->
			#terri_guild{server_id = AServerId, server_num = AServerNum, guild_name = AGuildName} = maps:get(AGuildId, GuildMap),
			TerriWar = #terri_war{
				group = Group, war_id = NewAccWarId, round = Round, territory_id = TerritoryId,
				a_guild = AGuildId, a_server = AServerId, a_server_num = AServerNum, a_guild_name = AGuildName,
				winner = 0
			},
			create_war(NewAccWarId, Round, Group, GuildMap, GroupGuildIdList, [TerriWar|ReturnList]);
		_ ->
			create_war(AccWarId, Round, Group, GuildMap, GroupGuildIdList, ReturnList)
	end.

%% 统计分组信息，将同组的放在一起
static_terri_group(ServerMap, GuildMap) ->
	%% 统计同组服务器
	GroupMap = maps:fold(fun(ServerId, #terri_server{mode = ModeNum, group = Group}, Map) ->
		StartRound = lib_territory_war_data:get_start_round_by_mode(ModeNum),
		OR = maps:get(Group, Map, #terri_group{group_id = Group}), 
		maps:put(Group, OR#terri_group{mode_num = ModeNum, group_round = StartRound, server_list = [ServerId|OR#terri_group.server_list]}, Map)
	end, #{}, ServerMap),
    %% 统计同服务器的公会id
    ServerGuild = maps:fold(fun(GuildId, #terri_guild{server_id = ServerId}, Map) ->
    	OL = maps:get(ServerId, Map, []), maps:put(ServerId, [GuildId|OL], Map)
    end, #{}, GuildMap),
    {GroupMap, ServerGuild}.

calc_guild_battle_list(GroupRound, GroupGuildIdList, GuildMap) ->
	GuildIdListAlloc = lists:foldl(fun(GuildId, List) ->
		case maps:get(GuildId, GuildMap, 0) of 
			#terri_guild{choose_terri_id = ChooseTerriId} -> [{GuildId, ChooseTerriId}|List];
			_ -> List
		end
	end, [], GroupGuildIdList),
	calc_guild_battle_list(GroupRound, GuildIdListAlloc).

calc_guild_battle_list(GroupRound, GuildIdListAlloc) ->
	TerritoryIdList = data_territory_war:get_territory_id_list_by_round(GroupRound),
	{Satisfying, NotSatisfying} = lists:partition(fun({_, TerritoryId}) -> TerritoryId > 0 end, GuildIdListAlloc),
	{TerritoryGroupList, NotSatisfying1} = lists:foldl(fun(TerritoryId, {List, List1}) ->
		GuildList = [GuildId ||{GuildId, ChooseTerritoryId} <- Satisfying, ChooseTerritoryId == TerritoryId],
		GuildLen = length(GuildList),
		case GuildLen > 2 of 
			true ->
				{Head, Tail} = lists:split(2, GuildList),
				{[{TerritoryId, 2, Head}|List], List1 ++ [{TmpGuildId, 0}|| TmpGuildId <- Tail]};
			_ ->
				{[{TerritoryId, GuildLen, GuildList}|List], List1}
		end
	end, {[], []}, TerritoryIdList),
	SortTerritoryGroupList = lists:reverse(lists:keysort(2, TerritoryGroupList)),
	calc_guild_battle_list_do(NotSatisfying1++NotSatisfying, SortTerritoryGroupList).

calc_guild_battle_list_do([], TerritoryGroupList) -> 
	lists:keysort(1, TerritoryGroupList);
calc_guild_battle_list_do([{GuildId, _}|NotSatisfying], TerritoryGroupList) ->
	case [{TerritoryId, GuildLen, GuildList} ||{TerritoryId, GuildLen, GuildList} <- TerritoryGroupList, GuildLen < 2] of 
		[{TerritoryId1, GuildLen1, GuildList1}|_] ->
			NewTerritoryGroupList = lists:keystore(TerritoryId1, 1, TerritoryGroupList, {TerritoryId1, GuildLen1+1, [GuildId|GuildList1]}),
			calc_guild_battle_list_do(NotSatisfying, NewTerritoryGroupList);
		_ ->
			TerritoryGroupList
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  开启战场
start_fight(_Round, GroupMap, _ServerMap, _GuildMap, StartTime, EndTime) ->
	IsCls = ?IF(util:is_cls(), 1, 0),
	F = fun(_, TerriGroup) ->
		#terri_group{mode_num = ModeNum, group_round = GroupRound, war_list = WarList} = TerriGroup,
		NewWarList = start_fight_do(WarList, IsCls, ModeNum, GroupRound, StartTime, EndTime, []),
		TerriGroup#terri_group{war_list = NewWarList}
	end,
	maps:map(F, GroupMap).

start_fight_do([], _IsCls, _ModeNum, _Round, _StartTime, _EndTime, Return) -> lists:reverse(Return);
start_fight_do([TerriWar|WarList], IsCls, ModeNum, Round, StartTime, EndTime, Return) ->
	#terri_war{round = WRound, winner = Winner} = TerriWar,
	case WRound == Round andalso Winner == 0 of 
		true ->
			{ok, Pid} = mod_territory_war_fight:start([IsCls, TerriWar, ModeNum, StartTime, EndTime]),
			start_fight_do(WarList, IsCls, ModeNum, Round, StartTime, EndTime, [TerriWar#terri_war{fight_pid = Pid}|Return]);
		_ ->
			start_fight_do(WarList, IsCls, ModeNum, Round, StartTime, EndTime, [TerriWar|Return])
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 单个战场出现胜者，进行匹配下一场的公会
%% 轮空处理
handle_war_bye(AccWarId, ?WAR_ROUND_3, GroupMap, _ServerMap, GuildMap) ->
	NewGroupMap = check_emerge_winner(GroupMap, GuildMap),
	{AccWarId, NewGroupMap};
handle_war_bye(AccWarId, Round, GroupMap, ServerMap, GuildMap) ->
	NextRound = Round + 1,
	F = fun(Group, TerriGroup, {AccId, Map}) ->
		#terri_group{war_list = WarList} = TerriGroup,
		{NewAccId, NewWarList} = create_war_when_battle_end(AccId, Group, Round, NextRound, GuildMap, WarList),
		{NewAccId, maps:put(Group, TerriGroup#terri_group{war_list = NewWarList}, Map)}
	end,
	{NewAccWarId, NewGroupMap} = maps:fold(F, {AccWarId, GroupMap}, GroupMap),
	handle_war_bye(NewAccWarId, NextRound, NewGroupMap, ServerMap, GuildMap).

%% 刷新一次分组的轮次
refresh_group_round(GroupMap) ->
	F = fun(_Group, TerriGroup) ->
		#terri_group{winner_guild = WinnerGuild, war_list = WarList} = TerriGroup,
		case WinnerGuild > 0 of 
			true -> TerriGroup#terri_group{group_round = ?WAR_ROUND_3};
			_ ->
				RoundList = [WRound ||#terri_war{round = WRound, winner = Winner} <- WarList, Winner == 0],
				GroupRound = ?IF(RoundList == [], ?WAR_ROUND_3, lists:min(RoundList)),
				TerriGroup#terri_group{group_round = GroupRound}
		end
	end,
	maps:map(F, GroupMap).
	
%% 强制检查还没结算的战场
force_end_all_war(AccWarId, _Round, GroupMap, _ServerMap, GuildMap) ->
	F = fun(Group, TerriGroup, {AccId, Map}) ->
		#terri_group{group_round = GroupRound, war_list = WarList} = TerriGroup,
		NextRound = ?IF(GroupRound < ?WAR_ROUND_3 , GroupRound + 1, ?WAR_ROUND_3),
		UnSetList = [TerriWar ||#terri_war{round = WRound, winner = Winner} = TerriWar <- WarList, WRound == GroupRound, Winner == 0],
		case UnSetList == [] of 
			true -> %% 全部结算了，跳过
				{AccId, Map};
			_ -> %% 正常情况不应该有没结束的，随机取一个公会作为胜者
				F1 = fun(TerriWar, List) ->
					#terri_war{war_id = WarId, a_guild = AGuildId, b_guild = BGuildId} = TerriWar,
					Winner = ?IF(AGuildId > 0, AGuildId, BGuildId),
					lists:keystore(WarId, #terri_war.war_id, List, TerriWar#terri_war{winner = Winner})
				end,
				NewWarList = lists:foldl(F1, WarList, UnSetList),
				{NewAccId, LastWarList} = create_war_when_battle_end(AccId, Group, GroupRound, NextRound, GuildMap, NewWarList),
				{NewAccId, maps:put(Group, TerriGroup#terri_group{war_list = LastWarList}, Map)}
		end
	end,
	{NewAccWarId, NewGroupMap} = maps:fold(F, {AccWarId, GroupMap}, GroupMap),
	{NewAccWarId, NewGroupMap}.

%% 一有公会胜利，检查并创建晋级下一轮的战场
create_war_when_battle_end(AccWarId, Group, Round, NextRound, GuildMap, WarList) ->
	case is_round_all_end(Round - 1, WarList) of 
		true ->
			WarList1 = [TerriWar ||TerriWar <- WarList, TerriWar#terri_war.round == Round],
			ExistGuildList = lists:flatten([[TerriWar#terri_war.a_guild, TerriWar#terri_war.b_guild] ||TerriWar <- WarList, TerriWar#terri_war.round == NextRound]),
			NextRoundGuildIdList = find_next_round_guild(WarList1, ExistGuildList, []),
			case NextRoundGuildIdList == [] of 
				true -> {AccWarId, WarList};
				_ ->
					{NewAccId, NewWarList} = create_war(AccWarId, NextRound, Group, GuildMap, NextRoundGuildIdList, []),
					{NewAccId, WarList ++ NewWarList}
			end;
		_ -> %% 前一轮还未结束，先不算下一轮的晋级名单先
			{AccWarId, WarList}
	end.

find_next_round_guild([], _ExistGuildList, Return) -> lists:reverse(Return);
find_next_round_guild([#terri_war{territory_id = OldTerritoryId1, winner = Winner1}, #terri_war{territory_id = OldTerritoryId2, winner = Winner2}=TerriWar2|WarList], ExistGuildList, Return) ->
	TerritoryId1 = lib_territory_war_data:get_next_territory_id(OldTerritoryId1),
	TerritoryId2 = lib_territory_war_data:get_next_territory_id(OldTerritoryId2),
	case TerritoryId1 == TerritoryId2 of 
		true ->
			case Winner1 > 0 andalso Winner2 > 0 andalso lists:member(Winner1, ExistGuildList) == false andalso lists:member(Winner2, ExistGuildList) == false of 
				true ->
					find_next_round_guild(WarList, ExistGuildList, [{TerritoryId1, 2, [Winner1, Winner2]}|Return]);
				_ ->
					find_next_round_guild(WarList, ExistGuildList, Return)
			end;
		_ ->
			case Winner1 > 0 andalso lists:member(Winner1, ExistGuildList) == false of 
				true -> 
					find_next_round_guild([TerriWar2|WarList], ExistGuildList, [{TerritoryId1, 1, [Winner1]}|Return]);
				_ ->
					find_next_round_guild([TerriWar2|WarList], ExistGuildList, Return)
			end
	end;
find_next_round_guild([#terri_war{territory_id = OldTerritoryId, winner = Winner}], ExistGuildList, Return) ->
	case Winner > 0 andalso lists:member(Winner, ExistGuildList) == false of 
		true ->
			TerritoryId = lib_territory_war_data:get_next_territory_id(OldTerritoryId),
			find_next_round_guild([], ExistGuildList, [{TerritoryId, 1, [Winner]}|Return]);
		_ ->
			find_next_round_guild([], ExistGuildList, Return)
	end.

is_round_all_end(Round, _WarList) when Round < 1 -> true;
is_round_all_end(Round, WarList) ->
	NotEndList = [WarId ||#terri_war{war_id = WarId, round = WRound, winner = Winner} <- WarList, WRound == Round, Winner == 0],
	case NotEndList == [] of 
		true -> true;
		_ -> false
	end.

%%% 是否已经产出胜者
check_emerge_winner(GroupMap, GuildMap) ->
	F = fun(_Group, TerriGroup) ->
		check_emerge_winner_single(TerriGroup, GuildMap)
	end,
	maps:map(F, GroupMap).

check_emerge_winner_single(TerriGroup, GuildMap) ->
	#terri_group{group_id = Group, winner_guild = WinnerGuild, war_list = WarList} = TerriGroup,
	case WinnerGuild > 0 of 
		false -> 
			case [TerriWar ||#terri_war{round = Round, winner = Winner} = TerriWar <- WarList, Round == ?WAR_ROUND_3, Winner > 0] of 
				[TerriWarWin|_] ->
					#terri_war{a_guild = AGuildId, a_server = AServerId, b_server = BServerId, winner = Winner} = TerriWarWin,
					WinnerServerId = ?IF(Winner == AGuildId, AServerId, BServerId),
					mod_territory_war:handle_terri_war_winner(Group),
					#terri_guild{win_num = OldWinNum} = maps:get(Winner, GuildMap, #terri_guild{}),
					TerriGroup#terri_group{winner_server = WinnerServerId, winner_guild = Winner, win_num = OldWinNum+1};
				_ ->
					TerriGroup
			end;
		_ ->
			TerriGroup
	end.

handle_terri_war_winner(State, Group) ->
	?PRINT("handle_terri_war_winner Group :~p~n", [Group]),
	#terri_state{is_cls = IsCls, group_map = GroupMap, history = History} = State,
	case maps:get(Group, GroupMap, 0) of 
		#terri_group{} = TerriGroup ->
			DateId = lib_territory_war:get_date_id(),
			NewHistory = update_terri_war_history(History, DateId, TerriGroup),
			case IsCls of 
				1 ->
					%% 胜者数据同步到相关的游戏服中
					refresh_consecutive_win(DateId, TerriGroup);
				_ -> 
					mod_territory_war:refresh_consecutive_win_local(DateId, TerriGroup)
			end,
			NewState = State#terri_state{history = NewHistory};
		_ ->
			NewState = State
	end,
	NewState.

update_terri_war_history(History, DateId, TerriGroup) ->
	{_, OldHisGroupMap} = ulists:keyfind(DateId, 1, History, {DateId, #{}}),
	NewHisGroupMap = maps:put(TerriGroup#terri_group.group_id, TerriGroup, OldHisGroupMap),
	lists:keystore(DateId, 1, History, {DateId, NewHisGroupMap}).

refresh_consecutive_win(DateId, TerriGroup) ->
	#terri_group{server_list = ServerList} = TerriGroup,
	spawn(fun() -> refresh_consecutive_win_do(ServerList, DateId, TerriGroup) end),
	ok.

refresh_consecutive_win_do([], _DateId, _TerriGroup) -> ok;
refresh_consecutive_win_do([ServerId|ServerList], DateId, TerriGroup) ->
	timer:sleep(100),
	mod_clusters_center:apply_cast(ServerId, mod_territory_war, refresh_consecutive_win_local, [DateId, TerriGroup]),
	refresh_consecutive_win_do(ServerList, DateId, TerriGroup).

sync_history_data(State, ServerId) ->
	#terri_state{history = History} = State,
	case lists:reverse(lists:keysort(1, History)) of 
		[{DateId, HisGroupMap}|_] ->
			sync_history_data(DateId, maps:values(HisGroupMap), ServerId);
		_ -> ok
	end.

sync_history_data(_DateId, [], ServerId) -> ?PRINT("sync_history_data no server  ~n", []), ServerId;
sync_history_data(DateId, [TerriGroup|GroupList], ServerId) ->
	case lists:member(ServerId, TerriGroup#terri_group.server_list) of 
		true ->
			case length(TerriGroup#terri_group.server_list) > 1 of 
				true -> %% 多服模式
					mod_clusters_center:apply_cast(ServerId, mod_territory_war, sync_history_data_local, [DateId, TerriGroup]);
				_ -> %% 单服模式的历史记录不存在跨服中
					?PRINT("sync_history_data server is single  ~n", []),
					ok
			end;
		_ ->
			sync_history_data(DateId, GroupList, ServerId)
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
divide_terri_server(ServerMap, ZoneIdList, AccGroup) ->
	F = fun(ZoneId, {ServerMapTmp, AccGroupTmp}) ->
		divide_terri_server_do(ZoneId, ServerMapTmp, AccGroupTmp)
	end,
	{NewServerMap, NewAccGroup} = lists:foldl(F, {ServerMap, AccGroup}, ZoneIdList),
	{NewServerMap, NewAccGroup}.

%% 服务器分服
divide_terri_server_do(ZoneId, ServerMap, AccGroup) ->
	ZoneServerMap = maps:filter(fun(_ServerId, #terri_server{zone_id = ZoneId1}) -> ZoneId1 == ZoneId end, ServerMap),
	ZoneServerList = maps:values(ZoneServerMap),
	ZoneServerListAfSort = lists:keysort(#terri_server.open_time, ZoneServerList),
	%% 开服小于等于4天的都是单服模式
	% [MultiModeOpenDay, _, _] = data_territory_war:get_cfg(?TERRI_KEY_14),
	% FSplit = fun(#terri_server{open_time = OpenTime}) -> util:check_open_day_2(MultiModeOpenDay, OpenTime) == false end,
 %    {Satisfying, NotSatisfying} = lists:partition(FSplit, ZoneServerListAfSort),
	% SingelModeList = [{TerriServer, ?MODE_NUM_1} ||TerriServer <- Satisfying],
	ZoneServerListAfMode1 = [{TerriServer, ?MODE_NUM_1} ||TerriServer <- ZoneServerListAfSort],
	F = fun(CurModeNum, List) ->
		divide_server_mode(CurModeNum, List, [])
	end,
	ZoneServerListAfMode = lists:foldl(F, ZoneServerListAfMode1, [?MODE_NUM_2, ?MODE_NUM_4, ?MODE_NUM_8]),
	{NewServerMap, NewAccGroup} = divide_server_group(ZoneServerListAfMode, AccGroup, ServerMap),
	{NewServerMap, NewAccGroup}.
	
divide_server_mode(_, [], Return) ->
	Return;
divide_server_mode(CurModeNum, ZoneServerListAfMode, Return) ->
	%PreModeNum = lib_territory_war_data:get_pre_mode_num(CurModeNum),
	ModeWorldLv = lib_territory_war_data:get_mode_world_lv(CurModeNum),
	OpenDay = lib_territory_war_data:get_mode_open_day(CurModeNum),
	case length(ZoneServerListAfMode) >= CurModeNum of 
		true ->
			{Pre, Left} = lists:split(CurModeNum, ZoneServerListAfMode);
		_ ->
			Pre = ZoneServerListAfMode, Left = []
	end,
	%% 开服小于等于OpenDay的都是不会进入CurModeNum模式
	FSplit = fun({#terri_server{open_time = OpenTime}, _}) -> util:check_open_day_2(OpenDay, OpenTime) == true end,
    {Satisfying, NotSatisfying} = lists:partition(FSplit, Pre),
	WorldLvList = [Server#terri_server.world_lv ||{Server, _ServerModeNum} <- Satisfying],
	NextModeServerNum = length(WorldLvList),
	case NextModeServerNum > 0 andalso round(lists:sum(WorldLvList)/NextModeServerNum) >= ModeWorldLv of 
		true ->
			NewReturn = Return ++ [{Server, CurModeNum} ||{Server, _} <- Satisfying] ++ NotSatisfying,
			divide_server_mode(CurModeNum, Left, NewReturn);
		_ ->
			divide_server_mode(CurModeNum, Left, Return ++ Pre)
	end.

%% 服务器分组
divide_server_group(ZoneServerListAfMode, AccGroup, ServerMap) ->
	divide_server_group(ZoneServerListAfMode, AccGroup, ServerMap, 0, 0).

divide_server_group([], AccGroup, ServerMap, _OldMode, _Num) ->
	{ServerMap, AccGroup};
divide_server_group([{TerriServer, ModeNum}|ZoneServerListAfMode], AccGroup, ServerMap, OldMode, Num) ->
	case ModeNum =/= OldMode orelse ModeNum == ?MODE_NUM_1 orelse (Num + 1 > ModeNum) of 
		true ->	
			NewNum = 1,
			NewAccGroup = AccGroup + 1;
		_ -> 
			NewNum = Num + 1,
			NewAccGroup = AccGroup
	end,
	NewTerriServer = TerriServer#terri_server{mode = ModeNum, group = NewAccGroup},
	NewServerMap = maps:put(NewTerriServer#terri_server.server_id, NewTerriServer, ServerMap),
	divide_server_group(ZoneServerListAfMode, NewAccGroup, NewServerMap, ModeNum, NewNum).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 获取游戏服的公会信息
clear_async_guild_info() ->
	erase({terri_war, async_guild}).

async_divide_server_info(ServerMap, StartTime) ->
	case get({terri_war, async_guild}) of 
		{OldRef, Count} -> FirstTimes = false;
		_ -> OldRef = [], Count = 0, FirstTimes = true
	end,
	F = fun(_ServerId, #terri_server{mode = Mode, guild_list = GuildList}=TerriServer, List) ->
		%% 不是1服模式，公会列表为空；或者 是1服模式且第一次获取数据
		?IF(
			(Mode =/= ?MODE_NUM_1 andalso GuildList == []) orelse (Mode == ?MODE_NUM_1 andalso FirstTimes == true),
			[TerriServer|List], List
		)
	end,
	AsyncList = maps:fold(F, [], ServerMap),
	AsyncList =/= [] andalso spawn(fun() -> async_divide_server_info_do(AsyncList, StartTime, 1) end),
	case Count >= ?SYNC_GUILD_COUNT orelse AsyncList == [] of 
		true -> %% 已经获取所有的公会信息或者获取次数大于指定次数
			ok;
		_ ->
			Ref = util:send_after(OldRef, ?SYNC_GUILD_TIME * 1000, self(), {async_divide_server_info}),
			put({terri_war, async_guild}, {Ref, Count+1})
	end.

async_divide_server_info_do([], _StartTime, _Num) -> ok;
async_divide_server_info_do([TerriServer|AsyncList], StartTime, Num) ->
	case Num rem 20 == 0 of 
		true -> timer:sleep(200), ok;
		_ -> skip
	end,
	#terri_server{server_id = ServerId} = TerriServer,
	case lib_clusters_center:get_node(ServerId) of
        undefined -> 
        	NewNum = Num;
        Node -> 
        	NewNum = Num+1,
        	mod_clusters_center:apply_cast(Node, mod_territory_war, async_divide_server_info_local, [TerriServer])
    end,
	async_divide_server_info_do(AsyncList, StartTime, NewNum).

% sync_server_mode_to_server(ServerMap) ->
% 	spawn(fun() -> sync_server_mode_to_server_do(maps:values(ServerMap), 1) end),
% 	ok.

% sync_server_mode_to_server_do([], _Num) -> ok;
% sync_server_mode_to_server_do([TerriServer|AsyncList], Num) ->
% 	case Num rem 20 == 0 of 
% 		true -> timer:sleep(200), ok;
% 		_ -> skip
% 	end,
% 	#terri_server{server_id = ServerId} = TerriServer,
% 	case lib_clusters_center:get_node(ServerId) of
%         undefined -> 
%         	NewNum = Num;
%         Node -> 
%         	NewNum = Num+1,
%         	mod_clusters_center:apply_cast(Node, mod_territory_war, sync_server_mode_local, [TerriServer])
%     end,
% 	?PRINT("sync_server_mode_to_server_do end ~n", []),
% 	sync_server_mode_to_server_do(AsyncList, NewNum).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 获取游戏服的公会信息
% async_war_state(Msg) ->
% 	mod_clusters_center:apply_to_all_node(mod_territory_war, async_war_state_local, [Msg]),
% 	ok.

store_history(State) ->
	#terri_state{history = History} = State,
	DateId = lib_territory_war:get_date_id(),
	spawn(fun() -> reset_history_data_delay(DateId, History) end),
	NewHistory = [{Id, Data} ||{Id, Data} <- History, Id == DateId],
	State#terri_state{history = NewHistory}.

%%
reset_history_data_delay(DateId, History) ->
	case lists:keyfind(DateId, 1, History) of 
		{_, HisGroupMap} ->
			F = fun() ->
				lib_territory_war_data:truncate_history_data(),
				lib_territory_war_data:truncate_history_warlist(),
				lib_territory_war_data:insert_history_group_batch(DateId, HisGroupMap),
				ok
			end,
			case db:transaction(F) of 
				ok -> ok;
				_Err -> ?ERR("reset_history_data_delay _Err:~p~n", [_Err])
			end,
			%% 汇总warlist
			F1 = fun(Group, #terri_group{war_list = WarList}, List) ->
				List1 = [
					[DateId, Group, WarId, Round, TerritoryId, AGuildId, AServerId, AServerNum, util:fix_sql_str(AGuildName), BGuildId, BServerId, BServerNum, util:fix_sql_str(BGuildName), Winner]
					|| #terri_war{
							war_id=WarId, round=Round, territory_id=TerritoryId, a_guild=AGuildId, a_server=AServerId, a_server_num=AServerNum, a_guild_name=AGuildName,
							b_guild=BGuildId, b_server=BServerId, b_server_num=BServerNum, b_guild_name=BGuildName, winner=Winner
						} <- WarList
					],
				List1 ++ List
			end,
			DBList = maps:fold(F1, [], HisGroupMap),
			reset_history_war_list_delay(DBList);
		_ ->
			?INFO("reset_history_data_delay : ~p~n", [no_data]),
			ok
	end.

reset_history_war_list_delay([]) -> ok;
reset_history_war_list_delay(DBList) ->
	case length(DBList) >= 50 of 
		true ->
			{Head, Tail} = lists:split(50, DBList);
		_ -> Head = DBList, Tail = []
	end,
	lib_territory_war_data:insert_history_warlist_batch(Head),
	timer:sleep(200),
	reset_history_war_list_delay(Tail).










