%% ---------------------------------------------------------------------------
%% @doc lib_week_dungeon.erl

%% @author  
%% @email  
%% @since  
%% @deprecated 周常副本
%% ---------------------------------------------------------------------------
-module(lib_week_dungeon).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("dungeon.hrl").
-include("hero_halo.hrl").
-include("common.hrl").
-include("team.hrl").
-include("scene.hrl").
-include("skill.hrl").
-include("week_dungeon.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("attr.hrl").
-include("drop.hrl").
-include("errcode.hrl").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 登陆
login(PS) ->
	#player_status{id = RoleId} = PS,
	case db_select_week_dun_score(RoleId) of 
		[] -> PS#player_status{weekdun_status = #weekdun_status{}};
		List ->
			DunScore = [{DunId, Score} || [DunId, Score] <- List],
			PS#player_status{weekdun_status = #weekdun_status{dun_score = DunScore}}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 获取进队伍参数
get_team_join_value(PS, ActivityId, SubTypeId) ->
	case data_team_ui:get(ActivityId, SubTypeId) of 
		#team_enlist_cfg{dun_id = DunId} ->
			#player_status{weekdun_status = WeekDunStatus} = PS,
			case WeekDunStatus of 
				#weekdun_status{dun_score = DunScore} ->
					WeekDunId = get_week_dun_id(DunId),
					case lists:keyfind(WeekDunId, 1, DunScore) of 
						{_, Score} -> Score;
						_ -> 0
					end;
				_ -> 0
			end;
		_ -> 0
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 进入副本检查
dunex_check_extra(PS, #dungeon{id = DunId} = _Dun, _Args) ->
	case is_team_dun(DunId) of 
		true ->
			WeekDunId = get_week_dun_id(DunId),
            #player_status{figure = #figure{name = Name}, weekdun_status = #weekdun_status{dun_score = DunScore}} = PS,
            case lists:keyfind(WeekDunId, 1, DunScore) of 
            	{_, _} -> true;
            	_ -> {false, {?ERRCODE(err508_single_dun_not_succ_by_other), [Name]}, ?ERRCODE(err508_single_dun_not_succ)}
            end;
        _ ->
        	true
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 副本结算
%% 副本通关
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = Data}) ->
	#player_status{id = RoleId, sid = Sid, help_type_setting = HMap} = PS,
    #callback_dungeon_succ{
    	dun_id = DunId, dun_type = DunType, help_type = HelpType, 
    	pass_time = PassTime, other = Other} = Data,
    case DunType == ?DUNGEON_TYPE_WEEK_DUNGEON of 
    	true ->
    		#week_dun_result{is_all_help = IsAllHelp} = Other,
    		%% 副本通关，先增加次数
    		mod_week:increment(RoleId, ?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_SUCC, DunId),
    		case HelpType == ?HELP_TYPE_YES andalso is_team_dun(DunId) andalso IsAllHelp == false of 
    			true ->
    				mod_week:increment(RoleId, ?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_HELP, DunId);
    			_ ->
    				skip
    		end,
    		{SuccRewardStateList, SendRewardList} = get_week_dungeon_succ_reward(?EVENT_DUNGEON_SUCCESS, DunId, RoleId, HelpType, Other),
    		{_IsKillBoss, RoleBossStateList} = get_week_dungeon_boss_info(PS, DunId, Other),
    		{ok, Bin} = pt_508:write(50805, [1, DunId, PassTime, SuccRewardStateList, RoleBossStateList]),
    		lib_server_send:send_to_sid(Sid, Bin),
    		PS1 = update_player_week_dungeon_score(PS, DunId, PassTime),
    		%% 先自己更新玩家助战状态(助战流程好像没自动更新)
    		NewHelpType = get_help_type(DunId, RoleId),
    		PS2 = PS1#player_status{help_type_setting = HMap#{DunId => NewHelpType}},
    		%?PRINT("DUNGEON_SUCCESS ## SuccRewardStateList:~w~n", [SuccRewardStateList]),
    		%?PRINT("DUNGEON_SUCCESS ## RoleBossStateList:~w~n", [RoleBossStateList]),
    		lib_log_api:log_week_dungeon_settlement(RoleId, DunId, 1, PassTime, HelpType, SuccRewardStateList, RoleBossStateList),
    		case SendRewardList == [] of 
    			true -> {ok, PS2};
    			_ ->
    				Produce = #produce{type = week_dungeon, reward = SendRewardList},
    				{ok, NewPS} = lib_goods_api:send_reward_with_mail(PS2, Produce),
    				{ok, NewPS}
    		end;
    	_ ->
    		{ok, PS}
    end;
%% 副本失败
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_FAIL, data = Data}) ->
	#player_status{id = RoleId, sid = Sid} = PS,
    #callback_dungeon_fail{
    	dun_id = DunId, dun_type = DunType, help_type = HelpType, 
    	pass_time = PassTime, other = Other} = Data,
    case DunType == ?DUNGEON_TYPE_WEEK_DUNGEON of 
    	true ->
    		{SuccRewardStateList, _SendRewardList} = get_week_dungeon_succ_reward(?EVENT_DUNGEON_FAIL, DunId, RoleId, HelpType, Other),
    		{IsKillBoss, RoleBossStateList} = get_week_dungeon_boss_info(PS, DunId, Other),
    		SettlementType = ?IF(IsKillBoss == true, 1, 2),
    		lib_log_api:log_week_dungeon_settlement(RoleId, DunId, SettlementType, PassTime, HelpType, SuccRewardStateList, RoleBossStateList),
    		?PRINT("DUNGEON_FAIL ## SuccRewardStateList:~w~n", [SuccRewardStateList]),
    		?PRINT("DUNGEON_FAIL ## RoleBossStateList:~w~n", [RoleBossStateList]),
    		{ok, Bin} = pt_508:write(50805, [SettlementType, DunId, PassTime, SuccRewardStateList, RoleBossStateList]),
    		lib_server_send:send_to_sid(Sid, Bin);
    	_ ->
    		skip
    end,
    {ok, PS};
%% 拾取掉落
handle_event(PS, #event_callback{type_id = ?EVENT_DROP_CHOOSE, data = Data}) when is_record(PS, player_status) ->
    #player_status{dungeon = StatusDungeon, weekdun_status = WeekDunStatus} = PS,
    case lib_dungeon:is_on_dungeon(PS) of
        true ->
            #status_dungeon{dun_id = DunId, dun_type = DunType} = StatusDungeon,
            MonId = maps:get(mon_id, Data, 0),
            BossIdList = data_week_dungeon:get_boss_id_list(DunId),
            case DunType == ?DUNGEON_TYPE_WEEK_DUNGEON andalso lists:member(MonId, BossIdList) of 
            	true ->
            		#weekdun_status{in_dungeon_data = InDunData} = WeekDunStatus,
            		#{goods := ObjectList} = Data,
					AccObjectList = maps:get({mon_drop, MonId}, InDunData, []),
					NewInDunData = maps:put({mon_drop, MonId}, ObjectList++AccObjectList, InDunData),
					NewWeekDunStatus = WeekDunStatus#weekdun_status{in_dungeon_data = NewInDunData},
					{ok, PS#player_status{weekdun_status = NewWeekDunStatus}};
            	_ ->
            		{ok, PS}
            end;
        false ->
            {ok, PS}
    end;
handle_event(PS, _) ->
	{ok, PS}.

get_week_dungeon_succ_reward(ResultType, DunId, RoleId, HelpType, Other) ->
	#week_dun_result{is_all_help = IsAllHelp} = Other,
	CountTypeList = [{?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_SUCC, DunId}, {?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_HELP, DunId}],
	DunCountList = mod_week:get_count(RoleId, CountTypeList),
	F = fun({{_, SubMod, _}, Count}, {List1, List2}) ->
		case SubMod of 
			?MOD_WDUNGEON_SUCC ->
				Type = 1,
				RewardList = ?IF(Count > 1, [], get_dun_succ_reward(DunId));
			?MOD_WDUNGEON_HELP ->
				Type = 2,
				HelpCountMax = get_help_count_max(DunId),
				RewardList = ?IF(IsAllHelp == false andalso HelpType == ?HELP_TYPE_YES andalso Count =< HelpCountMax, 
					get_dun_help_reward(DunId), [])
		end,
		case ResultType of
			?EVENT_DUNGEON_SUCCESS ->
				{[{Type, Count, RewardList}|List1], RewardList++List2};
			_ ->
				{[{Type, Count, []}|List1], List2}
		end
	end,
	lists:foldl(F, {[], []}, DunCountList).


get_week_dungeon_boss_info(PS, DunId, Other) ->
	#player_status{id = _RoleId, weekdun_status = _WeekDunStatus} = PS,
	%#weekdun_status{in_dungeon_data = InDunData} = WeekDunStatus,
	#week_dun_result{boss_map = BossMap, week_dun_role = _WeekDunRole} = Other,
	%#week_dun_role{boss_drop = BossDopList} = WeekDunRole,
	BossDieList = lists:filter(fun({_BossId, {BossDie, _KillCount}}) -> BossDie == 1 end, maps:to_list(BossMap)),
	% 是否有boss死亡
	IsKillBoss = length(BossDieList) > 0,
	% 获取boss的奖励状态和奖励列表
	% CountTypeList = [{?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_KILL_BOSS, BossId} ||{BossId, _} <- BossDieList],
	% BossKillCountList = mod_week:get_count(RoleId, CountTypeList),
%%	?PRINT("get_week_dungeon_boss_info ## BossDieList:~w~n", [BossDieList]),
	F = fun({BossId, {_BossDie, Count}}, List) ->
		%{_, RewardList} = ulists:keyfind(BossId, 1, BossDopList, {BossId, []}),
		RewardList = data_week_dungeon:get_boss_reward_view(DunId, BossId),
		RoleBossState = ?IF(Count > 0, 1, 0),
		NewRewardList = ?IF(Count > 0, [], RewardList),
		[{BossId, RoleBossState, NewRewardList}|List]
	end,
	RoleBossStateList = lists:foldl(F, [], BossDieList),
	{IsKillBoss, RoleBossStateList}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 更新玩家副本评分
update_player_week_dungeon_score(PS, DunId, PassTime) ->
	case is_single_dun(DunId) of 
		true ->
			#player_status{id = RoleId, weekdun_status = WeekDunStatus} = PS,
			#weekdun_status{dun_score = OldDunScore} = WeekDunStatus,
			WeekDunId = get_week_dun_id(DunId),
			NewScore = get_week_dun_score(DunId, PassTime),
			?PRINT("update_player_week_dungeon_score ## WeekDunId:~p~n", [{WeekDunId, NewScore}]),
			case lists:keyfind(WeekDunId, 1, OldDunScore) of
				{_, OldScore} when NewScore =< OldScore ->
					PS;
				_ ->
					db_replace_week_dun_score(RoleId, WeekDunId, NewScore),
					NewDunScore = lists:keystore(WeekDunId, 1, OldDunScore, {WeekDunId, NewScore}),
					PS#player_status{weekdun_status = WeekDunStatus#weekdun_status{dun_score = NewDunScore}}
			end;
		_ ->
			PS
	end.

send_player_week_dun_info(PS) ->
	#player_status{id = RoleId, sid = Sid, weekdun_status = #weekdun_status{dun_score = DunScore}} = PS,
	WeekDunIdList = data_week_dungeon:get_all_week_dun(),
	F = fun({WeekDunId, SingleDunId, TeamDunId}, List) ->
		{_, Score} = ulists:keyfind(WeekDunId, 1, DunScore, {WeekDunId, 0}),
		BossIdList1 = get_dun_boss_list(SingleDunId),
		BossIdList2 = get_dun_boss_list(TeamDunId),
		BossIdList = BossIdList1 ++ BossIdList2,
		CountTypeList = [
				{?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_SUCC, SingleDunId}, 
				{?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_SUCC, TeamDunId}, 
				{?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_HELP, TeamDunId}
			] ++ [{?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_KILL_BOSS, BossId} ||BossId <- BossIdList],
		CountList = mod_week:get_count(RoleId, CountTypeList),
		SingleSucc = case lists:keyfind({?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_SUCC, SingleDunId}, 1, CountList) of 
				{_, Count1} when Count1 >= 1 -> 1; _ -> 0
			end,
		TeamSucc = case lists:keyfind({?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_SUCC, TeamDunId}, 1, CountList) of 
				{_, Count2} when Count2 >= 1 -> 1; _ -> 0
			end,
		HelpTimes = case lists:keyfind({?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_HELP, TeamDunId}, 1, CountList) of 
				{_, Count3} -> Count3; _ -> 0
			end,
		BossStateList = [begin
				case lists:keyfind({?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_KILL_BOSS, BossId}, 1, CountList) of 
					{_, Count4} when Count4 > 0 -> {BossId, 1};
					_ -> {BossId, 0}
				end 
			end||BossId <- BossIdList],
		[{WeekDunId, Score, SingleSucc, TeamSucc, HelpTimes, BossStateList}|List]
	end,
	SendList = lists:foldl(F, [], WeekDunIdList),
%%	?PRINT("send_player_week_dun_info ## SendList:~p~n", [SendList]),
	{ok, Bin} = pt_508:write(50801, [SendList]),
	lib_server_send:send_to_sid(Sid, Bin).

%% 获取玩家的助战类型

get_help_type(Dun, RoleId) when is_record(Dun, dungeon) ->
	#dungeon{id = DunId} = Dun,
	get_help_type(DunId, RoleId);
get_help_type(DunId, RoleId) ->	
	case mod_week:get_count(RoleId, ?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_SUCC, DunId) of 
		0 -> ?HELP_TYPE_NO;
		_ -> ?HELP_TYPE_YES
	end.

%% 发送周榜奖励
send_week_dungeon_reward(RoleList) ->
	spawn(fun() -> send_week_dungeon_reward_do(RoleList, 1) end),
	ok.

send_week_dungeon_reward_do([], _Acc) -> ok;
send_week_dungeon_reward_do([{RoleId, DunId, Rank}|RoleList], Acc) ->
	case data_week_dungeon:get_rank_reward(DunId, Rank) of 
		[] -> send_week_dungeon_reward_do(RoleList, Acc);
		RewardList ->
			case Acc rem 30 == 0 of 
				true -> timer:sleep(200); _ -> skip 
			end, 
			DunName = get_week_dun_name(DunId),
			Title = utext:get(5080001),
			Content = utext:get(5080002, [util:make_sure_binary(DunName), Rank]),
			lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
			send_week_dungeon_reward_do(RoleList, Acc+1)
	end.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 副本的回调
%% 副本结束，刷新排行榜
dunex_handle_dungeon_result(State) ->
	#dungeon_state{dun_id = DunId, start_time = StartTime, result_type = ResultType} = State,
	IsTeamDun = is_team_dun(DunId),
	?PRINT("handle_dungeon_result ## IsTeamDun :~p~n", [{IsTeamDun, ResultType}]),
	case ResultType == ?DUN_RESULT_TYPE_SUCCESS andalso IsTeamDun of 
		true ->
			NowTime = utime:unixtime(),
			WDunRankRoleList = trans_to_week_dun_rank_role(State#dungeon_state.role_list),
			RoleIdList = [RoleId ||#week_dun_rank_role{role_id = RoleId} <- WDunRankRoleList],
			Key = lists:sort(RoleIdList),
			PassTime = NowTime-StartTime,
			?PRINT("handle_dungeon_result ## :~p~n", [{DunId, Key, PassTime}]),
			case util:is_cls() of 
				true ->	
					mod_week_dun_rank:refresh_rank(DunId, Key, PassTime, WDunRankRoleList);
				_ ->
					mod_clusters_node:apply_cast(mod_week_dun_rank, refresh_rank, [DunId, Key, PassTime, WDunRankRoleList])
			end,
			State;
		_ ->
			State
	end.

gm_refresh_week_dun_rank(PS, DunId, PassTime) ->
	#player_status{id = RoleId, server_id = ServerId, server_num = ServerNum, figure = #figure{name = RoleName}} = PS,
	WDunRankRoleList = [make_rank_role(RoleId, RoleName, ServerId, ServerNum)],
	RoleIdList = [PS#player_status.id],
	Key = lists:sort(RoleIdList),
	?PRINT("gm_refresh_week_dun_rank ## :~p~n", [{DunId, Key, PassTime}]),
	mod_clusters_node:apply_cast(mod_week_dun_rank, refresh_rank, [DunId, Key, PassTime, WDunRankRoleList]).

dunex_is_calc_result_before_finish() ->
	true.

%% 副本初始化参数
dunex_get_start_dun_args(Object, Dun) ->
	#dungeon{id = DungeonId} = Dun,
	MaxReviveCount = get_max_revive_count(DungeonId),
	WeekDunData = make_week_dungeon_data(Object, DungeonId),
	TypicalData = [
        {?DUN_STATE_SPECIAL_KEY_REVIVE_COUNT, [MaxReviveCount, MaxReviveCount]},
        {week_dungeon_data, WeekDunData}
    ],
    ?PRINT("get_start_dun_args ## TypicalData :~p~n", [TypicalData]),
    [{typical_data, TypicalData}].

%% 副本的独有参数：获取周常本中复活圣域次数
dunex_get_dungeon_special_info(State, RoleId) ->
	DeadInfo = get_dead_info(State, RoleId),
	LeftCount = get_revive_left_count_info(State),
	BossStateInfo = get_boss_state_info(State),
	LeftCount ++ BossStateInfo ++ DeadInfo.

get_dead_info(State, RoleId) ->
	#dungeon_state{role_list = RoleList} = State,
	case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of 
		#dungeon_role{dead_time = DeadTime} -> [{dead_time, DeadTime}];
		_ -> []
	end.

get_revive_left_count_info(State) ->
	LeftCount = dunex_get_revive_left_count(State),
	[{left_count, LeftCount}].

get_boss_state_info(State) ->
	#dungeon_state{typical_data = TypicalData} = State,
	case maps:get(week_dungeon_data, TypicalData, 0) of 
		#week_dungeon_data{boss_map = BossMap} ->
			BossStateList = maps:to_list(BossMap),
			[{boss_info, BossStateList}];
		_ ->
			[]
	end.

%% 进入副本的参数
dunex_get_scene_args(PS) ->
	#player_status{id = RoleId, dungeon = #status_dungeon{dun_id = DunId}} = PS,
	NewBossKillCountList = get_kill_boss_count(RoleId, DunId),
	?PRINT("get_scene_args ## NewBossKillCountList :~p~n", [NewBossKillCountList]),
	[{drop_rule_modifier, {lib_week_dungeon, modify_drop_rule, [RoleId, DunId, NewBossKillCountList]}}].

%% 离开副本参数
dunex_get_quit_scene_args(_PS) ->
	[{drop_rule_modifier, []}, {recalc_attr, 0}].

%% 
dunex_get_revive_info(_State, _RoleId) ->
	%% 周常副本不让玩家自动复活，要玩家自己选择复活
	{false, 0}.

%% 获取副本结算的其他信息
dunex_get_other_success_data(State, DungeonRole) ->
	get_week_dungeon_result_data(State, DungeonRole).

dunex_get_other_fail_data(State, DungeonRole) ->
	get_week_dungeon_result_data(State, DungeonRole).

get_week_dungeon_result_data(State, DungeonRole) ->
	#dungeon_state{typical_data = TypicalData, role_list = RoleList} = State,
	#dungeon_role{id = RoleId, typical_data = RoleTypicalData} = DungeonRole,
	case maps:get(week_dungeon_data, TypicalData, 0) of 
		#week_dungeon_data{role_list = WRoleList, boss_map = BossMap} ->
			IsAllHelp = ([1 ||#dungeon_role{help_type = HelpType} <- RoleList, HelpType == ?HELP_TYPE_NO] == []),
			case lists:keyfind(RoleId, #week_dun_role.role_id, WRoleList) of
				false -> WeekDunRole = #week_dun_role{role_id = RoleId};
				WeekDunRole -> skip
			end, 
			KillBossCount = maps:get(wdun_kill_boss_count, RoleTypicalData, []),
			F = fun(BossId, IsDead, NewMap) ->
				{_, KillCount} = ulists:keyfind(BossId, 1, KillBossCount, {BossId, 0}),
				maps:put(BossId, {IsDead, KillCount}, NewMap)
			end,
			NewBossMap = maps:fold(F, #{}, BossMap),
			?PRINT("get_week_dungeon_result_data :~p~n", [{NewBossMap, WeekDunRole}]),
			#week_dun_result{boss_map = NewBossMap, week_dun_role = WeekDunRole, is_all_help = IsAllHelp};
		_ ->
			#week_dun_result{}
	end.

%% 获取剩余复活次数
dunex_get_revive_left_count(State) ->
	#dungeon_state{typical_data = TypicalData} = State,
	case maps:get(?DUN_STATE_SPECIAL_KEY_REVIVE_COUNT, TypicalData, 0) of 
		[LeftCount, TotalCount] ->
			case TotalCount == 0 of 
				true -> 1;
				_ ->
					LeftCount
			end;
		_ -> 0
	end.

%% 能否复活
can_revive(State, _RoleId) ->
	#dungeon_state{typical_data = TypicalData} = State,
	case maps:get(?DUN_STATE_SPECIAL_KEY_REVIVE_COUNT, TypicalData, 0) of 
		[LeftCount, TotalCount] ->
			case TotalCount == 0 of 
				true -> true;
				_ ->
					case LeftCount > 0 of 
						true -> true;
						_ -> false
					end
			end;
		_ -> false
	end.

%% 复活成功
player_revive_done(State, RoleId) ->
	#dungeon_state{role_list = RoleList, typical_data = TypicalData} = State,
	case maps:get(?DUN_STATE_SPECIAL_KEY_REVIVE_COUNT, TypicalData, 0) of 
		[LeftCount, TotalCount] ->
			case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of 
				false -> State;
				DungeonRole ->
					NewLeftCount = max(0, LeftCount - 1),
					NewTypicalData = maps:put(?DUN_STATE_SPECIAL_KEY_REVIVE_COUNT, [NewLeftCount, TotalCount], TypicalData),
					NewDungeonRole = DungeonRole#dungeon_role{hp = DungeonRole#dungeon_role.hp_lim, dead_time = 0},
            		NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewDungeonRole),
					State#dungeon_state{role_list = NewRoleList, typical_data = NewTypicalData}
			end;
		_ -> State
	end.
%% 玩家复活
dunex_async_revive(State, RoleId, Node) ->
	?PRINT("week dungeon async_revive start ~n", []),
	case can_revive(State, RoleId) of 
		true->
			NewState = player_revive_done(State, RoleId),
			#dungeon_state{dun_id = DunId} = NewState,
			IsSingleDun = is_single_dun(DunId),
			IsTeamDun = is_team_dun(DunId),
			if
				IsSingleDun ->
					lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_revive, revive_without_check, [?REVIVE_ORIGIN, []]);
				IsTeamDun ->
					lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_revive, revive_without_check, [?REVIVE_ORIGIN, []]);
				true ->
					lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_revive, revive_without_check, [?REVIVE_ORIGIN, []])
			end,
			broadcast_dun_special_info(NewState, revive_count),
			NewState;
		_ ->
			State
	end.

%% 成功进入副本的后续处理
dunex_handle_enter_dungeon(PS, Dun) ->
	#player_status{id = RoleId, figure = #figure{career = Career}} = PS,
	#dungeon{id = DunId} = Dun,
	CountPS = lib_player:count_player_attribute(PS),
	%% 
	#player_status{battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}} = CountPS,
	{ok, BinData} = pt_120:write(12009, [RoleId, Hp, HpLim]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData),
	lib_player:send_attribute_change_notify(CountPS, ?NOTIFY_ATTR),
	%% 添加临时技能
	{ActiveSkillList, _} = get_week_dungeon_skill(DunId, Career),
	{ok, SkillPS} = lib_skill:add_tmp_skill_list(CountPS, ActiveSkillList),
	%% 重置副本数据
	PSDungeon = SkillPS#player_status{weekdun_status = PS#player_status.weekdun_status#weekdun_status{in_dungeon_data = #{}}},
	PSDungeon.

dunex_handle_quit_dungeon(PS, Dun) ->
	#player_status{figure = #figure{career = Career}, battle_attr = OldBA} = PS,
	#dungeon{id = DunId} = Dun,
	%% 手动移除buff
	PS1 = PS#player_status{battle_attr = OldBA#battle_attr{attr_buff_list = [], other_buff_list = []}},
	%% 移除临时技能
	{ActiveSkillList, _} = get_week_dungeon_skill(DunId, Career),
	{ok, SkillPS} = lib_skill:del_tmp_skill_list(PS1, ActiveSkillList),
	SkillPS.

%% 击杀boss
dunex_handle_kill_mon(State, Mid, _CreateKey, DieDatas) ->
	#dungeon_state{typical_data = TypicalData, role_list = RoleList} = State,
	case lists:keyfind(killer, 1, DieDatas) of 
		{_, _KillerId} ->
			case maps:get(week_dungeon_data, TypicalData, 0) of 
				#week_dungeon_data{boss_map = BossMap} = WeekDunData ->
					case maps:is_key(Mid, BossMap) of 
						true ->
							NewBossMap = maps:put(Mid, 1, BossMap),
							NewTypicalData = maps:put(week_dungeon_data, WeekDunData#week_dungeon_data{boss_map = NewBossMap}, TypicalData),
							increase_kill_boss_count(RoleList, Mid),
							?PRINT("handle_kill_mon :~p~n", [NewBossMap]),
							NewState = State#dungeon_state{typical_data = NewTypicalData},
							broadcast_dun_special_info(NewState, boss_info),
            				NewState;
						_ ->
							State
					end;
				_ ->
					State
			end;
		_ ->
			State
	end.

increase_kill_boss_count([], _Mid) -> ok;
increase_kill_boss_count([DungeonRole|RoleList], Mid) ->
	#dungeon_role{id = RoleId, node = Node, typical_data = TypicalData} = DungeonRole,
	KillBossCount = maps:get(wdun_kill_boss_count, TypicalData, []),
	case lists:keyfind(Mid, 1, KillBossCount) of 
		{Mid, KillCount} when KillCount > 0 -> %% 进入副本前已经有击杀次数，不增加次数，防止跨零点的情况
			?PRINT("increase_kill_boss_count KillCount:~p~n", [{Mid, KillCount}]),
			increase_kill_boss_count(RoleList, Mid);
		_ ->
			unode:apply(Node, mod_week, increment_offline, [RoleId, ?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_KILL_BOSS, Mid]),
			increase_kill_boss_count(RoleList, Mid)
	end.

pick_mon(State, DungeonRole, _Mid, SkillList) ->
	#dungeon_state{now_scene_id = SceneId, scene_pool_id = ScenePoolId} = State,
	#dungeon_role{id = RoleId} = DungeonRole,
	?PRINT("pick_mon : ~p~n", [{SceneId, _Mid, SkillList}]),
	case SkillList of 
		[{_SkillId, _}|_] ->
			[lib_skill_buff:clean_buff(SceneId, ScenePoolId, RoleId, SkillId) || {SkillId, _} <- SkillList],
			State;
		_ ->
			State
	end.

broadcast_dun_special_info(State, revive_count) ->
	#dungeon_state{dun_id = DunId, dun_type = DunType, role_list = RoleList} = State,
	Msg = get_revive_left_count_info(State),
	{ok, BinData} = pt_610:write(61088, [DunId, DunType, 2, util:term_to_string(Msg)]),
	?PRINT("broadcast_dun_special_info  : ~p~n", [Msg]),
	[lib_dungeon_mod:send_to_uid(Node, RoleId, BinData)||#dungeon_role{id = RoleId, node = Node} <- RoleList],
	ok;
broadcast_dun_special_info(State, boss_info) ->
	#dungeon_state{dun_id = DunId, dun_type = DunType, role_list = RoleList} = State,
	Msg = get_boss_state_info(State),
	{ok, BinData} = pt_610:write(61088, [DunId, DunType, 2, util:term_to_string(Msg)]),
	?PRINT("broadcast_dun_special_info  : ~p~n", [Msg]),
	[lib_dungeon_mod:send_to_uid(Node, RoleId, BinData)||#dungeon_role{id = RoleId, node = Node} <- RoleList],
	ok;
broadcast_dun_special_info(_State, _) ->
	ok.

%% 重新计算战力和属性
count_attr_in_week_dungeon(PS) ->
	?PRINT("count_attr_in_week_dungeon :~p~n", [start]),
	#player_status{
		figure = #figure{career = Career},
		battle_attr = OldBA,
		hightest_combat_power = HightCombatPower, dungeon = #status_dungeon{dun_id = DunId}
	} = PS,
	#battle_attr{hp = OldHp, hp_lim = OldHpLim, speed = OldSpeed, pk = OldPk, skill_effect = OldSkillEffect} = OldBA,
	{_, PassiveSkillList} = get_week_dungeon_skill(DunId, Career),
	SkillAttr = lib_skill:get_passive_skill_attr(PassiveSkillList),
	DunRoleAttrListTmpCfg = get_dun_role_attr(DunId),
	DunRoleAttrListTmp =
		case lib_hero_halo:check_halo(PS) of
			true ->
				#base_hero_halo{value = [{SkillId, SkillLv}|_]} = data_hero_halo:get_halo_cfg(?HALO_DUN_WEEK_BUFF),
				case data_skill:get_lv_data(SkillId, SkillLv) of
					#skill_lv{attr = Attr} ->
						F = fun
							    ({AttrId, _, ?RATIO_COEFFICIENT, _, Int, Float, _, _, _}, Acc) ->
								    case lists:keyfind(AttrId, 1, Acc) of
									    {_, V} ->
										    Value = round((1+Float) * V + Int),
										    lists:keystore(AttrId, 1, Acc, {AttrId, Value});
									    _ ->
										    [{AttrId, Int}|Acc]
								    end;
							    (_, Acc) -> Acc
						    end,
						lists:foldl(F, DunRoleAttrListTmpCfg, Attr);
					_ -> DunRoleAttrListTmpCfg
				end;
			_ -> DunRoleAttrListTmpCfg
		end,
	case is_team_dun(DunId) of 
		true ->
			#dungeon{recommend_power = RecommendPower} = data_dungeon:get(DunId),
			case HightCombatPower < RecommendPower of 
				true ->
					DunRoleAttrList = [{AttrType, round(AttrValue/2)} ||{AttrType, AttrValue} <- DunRoleAttrListTmp];
				_ ->
					DunRoleAttrList = DunRoleAttrListTmp
			end;
		_ ->
			DunRoleAttrList = DunRoleAttrListTmp
	end,
	AllAttrList = [DunRoleAttrList, SkillAttr],
    OAttrList = lib_player_attr:add_attr(list, AllAttrList),
	CombatPower = lib_player:calc_all_power(OAttrList),
	Result = HightCombatPower / CombatPower,
	PowerRatioList = data_week_dungeon:get_key(3),
	Ratio = get_hp_add_ratio(lists:reverse(lists:keysort(1, PowerRatioList)), Result),
	NewOriAttrList = [begin
		case AttrType of 
			?HP -> {AttrType, round(AttrValue*Ratio)};
			_ -> {AttrType, AttrValue}
		end
	end ||{AttrType, AttrValue} <- OAttrList],
	TotalAttr = lib_player_attr:to_attr_record(NewOriAttrList),
	% 汇总所有的第二属性
    OSecAttrMap = lib_sec_player_attr:to_attr_map(NewOriAttrList),
    % 增加人物对所有怪物伤害,pvp减免自身伤害,伙伴对怪物的伤害
    [MonHurtAdd, PVPHurtDelRatio, MateMonHurtAdd, AchivPvpHurtAdd] = lib_sec_player_attr:get_value_to_int(OSecAttrMap, 
        [?MON_HURT_ADD, ?PVP_HURT_DEL_RATIO, ?MATE_MON_HURT_ADD, ?ACHIV_PVP_HURT_ADD]),

    %% =================================  总的属性计算 =================================
    %% 人物技能被动+:速度增加,血量恢复,boss伤害加成,pvp|e伤害减免,怪物技能伤害加深,
    [SpeedR, HpResumeAdd, BossHurtR, PVPEDelR, PVESkillHurtR|_] = lib_player:get_other_attr(NewOriAttrList, ?SP_ATTR_LIST, []),

    NewSpeed = round(?SPEED_VALUE * (1+SpeedR/?RATIO_COEFFICIENT)),
	NewTotalAttr = TotalAttr#attr{speed = NewSpeed},
	_NewCombatPower = lib_player:calc_all_power(NewTotalAttr),
	#attr{hp = NewHp} = NewTotalAttr,
	%% 血量
	GapHp = NewHp - OldHpLim,
    RealHp = if
        GapHp < 0 -> NewHp;
        true -> min(OldHp+GapHp, NewHp)
    end,
    BattleSpeed = max(0, NewSpeed - 70),
	NewBA = #battle_attr{hp = RealHp, hp_lim = NewHp, speed = NewSpeed, battle_speed = BattleSpeed,
		attr = NewTotalAttr, pk = OldPk, skill_effect = OldSkillEffect, 
		hp_resume_time = 10, hp_resume_add = HpResumeAdd, boss_hurt_add = BossHurtR,
        pvpe_hurt_del = PVPEDelR, pve_skill_hurt_add = PVESkillHurtR, mon_hurt_add = MonHurtAdd, pvp_hurt_del_ratio = PVPHurtDelRatio,
        mate_mon_hurt_add = MateMonHurtAdd, achiv_pvp_hurt_add = AchivPvpHurtAdd
      },
    NewPS = PS#player_status{battle_attr = NewBA},
    case OldSpeed /= NewSpeed of
        false -> skip;
        true ->
            lib_scene:change_speed(NewPS#player_status.id, NewPS#player_status.scene, NewPS#player_status.scene_pool_id,
                NewPS#player_status.copy_id, NewPS#player_status.x, NewPS#player_status.y, NewBA#battle_attr.speed, ?BATTLE_SIGN_PLAYER)
    end,
    %?PRINT("count_attr_in_week_dungeon NewBA :~p~n", [NewBA]),
    NewPS.

modify_drop_rule(DropRule, MonArgs, [_RoleId, _DunId, BossKillCountList]) ->
	#mon_args{scene = Scene, mid = Mid} = MonArgs,
	case data_scene:get(Scene) of 
		#ets_scene{type = ?SCENE_TYPE_DUNGEON} ->
			?PRINT("modify_drop_rule in week dungeon ~n", []),
			case lists:keyfind(Mid, 1, BossKillCountList) of 
				{Mid, KillCount} ->
					?PRINT("modify_drop_rule KillCount : ~p ~n", [KillCount]),
					case KillCount == 0 of 
						true -> DropRule;
						_ ->
							DropRule#ets_drop_rule{drop_list = [], drop_rule = []}
					end;
				_ ->
					DropRule
			end;
		_ ->
			DropRule
	end.

get_skill_passive(PS) ->
	#player_status{dungeon = #status_dungeon{dun_id = DunId}, figure = #figure{career = Career}} = PS,
	{_, PassiveSkillList} = get_week_dungeon_skill(DunId, Career),
	%?PRINT("get_skill_passive:~p~n", [PassiveSkillList]),
	PassiveSkillList.

check_skill_has_learn(PS, SkillId) ->
	#player_status{dungeon = #status_dungeon{dun_id = DunId}, figure = #figure{career = Career}} = PS,
	{ActiveSkillList, _PassiveSkillList} = get_week_dungeon_skill(DunId, Career),
	case lists:keyfind(SkillId, 1, ActiveSkillList) of 
		{_, SkillLv} -> {true, SkillLv};
		_ -> false
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% data
get_max_revive_count(DunId) ->
	WeekDunId = get_week_dun_id(DunId),
	case data_week_dungeon:get_week_dungeon(WeekDunId) of 
		#base_week_dungeon{team_dun_id = DunId, revive_count = ReviveCount} -> ReviveCount;
		_ -> 0
	end.

get_dun_role_attr(DunId) ->
	WeekDunId = get_week_dun_id(DunId),
	case data_week_dungeon:get_week_dungeon(WeekDunId) of 
		#base_week_dungeon{dun_attr = DunRoleAttr} -> DunRoleAttr;
		_ -> []
	end.

get_dun_boss_list(DunId) ->
	data_week_dungeon:get_boss_id_list(DunId).

get_dun_succ_reward(DunId) ->
	WeekDunId = get_week_dun_id(DunId),
	case data_week_dungeon:get_week_dungeon(WeekDunId) of 
		#base_week_dungeon{single_dun_id = DunId, single_rewards = SingleRewards} -> 
			SingleRewards;
		#base_week_dungeon{team_dun_id = DunId, team_rewards = TeamRewards} -> 
			TeamRewards;	
		_ -> []
	end.

get_help_count_max(DunId) ->
	WeekDunId = get_week_dun_id(DunId),
	case data_week_dungeon:get_week_dungeon(WeekDunId) of 
		#base_week_dungeon{team_dun_id = DunId, help_count = HelpCountMax} -> 
			HelpCountMax;	
		_ -> 0
	end.

get_dun_help_reward(DunId) ->
	WeekDunId = get_week_dun_id(DunId),
	case data_week_dungeon:get_week_dungeon(WeekDunId) of 
		#base_week_dungeon{team_dun_id = DunId, help_reward = HelpReward} -> 
			HelpReward;	
		_ -> []
	end.

get_week_dun_score(DunId, PassTime) ->
	WeekDunId = get_week_dun_id(DunId),
	case data_week_dungeon:get_week_dungeon(WeekDunId) of 
		#base_week_dungeon{time_score = TimeScoreList} -> 
			case ulists:find(fun({_Score, Time1, Time2}) -> PassTime>=Time1 andalso PassTime=<Time2 end, TimeScoreList) of 
				{ok, {Score, _, _}} -> Score;
				_ -> 0
			end;
		_ -> 0
	end.

get_week_dungeon_skill(DunId, Career) ->
	WeekDunId = get_week_dun_id(DunId),
	case data_week_dungeon:get_week_dungeon(WeekDunId) of 
		#base_week_dungeon{active_skill = ActiveSkillList, passive_skill = PassiveSkillList} -> 
			{_, ActiveSkillList1} = ulists:keyfind(Career, 1, ActiveSkillList, {Career, []}),
			{_, PassiveSkillList1} = ulists:keyfind(Career, 1, PassiveSkillList, {Career, []}),
			{ActiveSkillList1, PassiveSkillList1};
		_ -> {[], []}
	end.

is_single_dun(DunId) ->
	WeekDunId = get_week_dun_id(DunId),
	case data_week_dungeon:get_week_dungeon(WeekDunId) of 
		#base_week_dungeon{single_dun_id = SingleDunId} when SingleDunId == DunId -> 
			true;
		_ -> false
	end.

is_team_dun(DunId) ->
	WeekDunId = get_week_dun_id(DunId),
	case data_week_dungeon:get_week_dungeon(WeekDunId) of 
		#base_week_dungeon{team_dun_id = TeamDunId} when TeamDunId == DunId -> 
			true;
		_ -> false
	end.

get_week_dun_name(DunId) ->
	WeekDunId = get_week_dun_id(DunId),
	case data_week_dungeon:get_week_dungeon(WeekDunId) of 
		#base_week_dungeon{dun_name = DunName} -> 
			DunName;
		_ -> ""
	end.

get_week_dun_id(DunId) ->
	case data_week_dungeon:get_week_dun_id_1(DunId) of 
		0 ->
			case data_week_dungeon:get_week_dun_id_2(DunId) of 
				0 ->
					data_week_dungeon:get_week_dun_id_3(DunId);
				Id ->
					Id
			end;
		Id ->
			Id
	end.

is_week_dun_boss(MonId) ->
	BossIdList = data_week_dungeon:get_all_boss_id_list(),
	case lists:member(MonId, BossIdList) of 
		true -> true;
		_ -> false
	end.

in_week_dungeon_scene(SceneId) ->
	DunIdList = data_dungeon:get_ids_by_type(?DUNGEON_TYPE_WEEK_DUNGEON),
	in_week_dungeon_scene(DunIdList, SceneId).

in_week_dungeon_scene([], _SceneId) -> false;
in_week_dungeon_scene([DunId|DunIdList], SceneId) ->
	case data_dungeon:get(DunId) of 
		#dungeon{scene_id = Scene, scene_list = SceneList} ->
			case lists:member(SceneId, [Scene|SceneList]) of 
				true -> true;
				_ ->
					in_week_dungeon_scene(DunIdList, SceneId)
			end;
		_ ->
			in_week_dungeon_scene(DunIdList, SceneId)
	end.

get_hp_add_ratio([], _Result) -> 1;
get_hp_add_ratio([{Value, Ratio}|PowerRatioList], Result) ->
	case Result >= Value of 
		true -> Ratio;
		_ -> get_hp_add_ratio(PowerRatioList, Result)
	end.

make_week_dungeon_data(Object, DungeonId) when is_record(Object, team) ->
	#team{member = Members} = Object,
	RoleList = [#week_dun_role{role_id = MB#mb.id} ||MB <- Members],
	BossList = get_dun_boss_list(DungeonId),
	BossMap = lists:foldl(fun(BossId, Map) -> maps:put(BossId, 0, Map) end, #{}, BossList),
	#week_dungeon_data{role_list = RoleList, boss_map = BossMap};

make_week_dungeon_data(Object, DungeonId) when is_record(Object, player_status) ->
	RoleList = [#week_dun_role{role_id = Object#player_status.id}],
	BossList = get_dun_boss_list(DungeonId),
	BossMap = lists:foldl(fun(BossId, Map) -> maps:put(BossId, 0, Map) end, #{}, BossList),
	#week_dungeon_data{role_list = RoleList, boss_map = BossMap};

make_week_dungeon_data(_Object, _DungeonId) ->
	#week_dungeon_data{}.

init_dungeon_role(Player, Dun, Role) ->
	#player_status{id = RoleId} = Player,
	#dungeon{id = DunId} = Dun,
	BossKillCountList = get_kill_boss_count(RoleId, DunId),
	?PRINT("init_dungeon_role BossKillCountList:~p~n", [BossKillCountList]),
	Role#dungeon_role{typical_data = #{wdun_kill_boss_count => BossKillCountList}}.

get_kill_boss_count(RoleId, DunId) ->
	BossIdList = get_dun_boss_list(DunId),
	CountTypeList = [{?MOD_WEEK_DUNGEON, ?MOD_WDUNGEON_KILL_BOSS, BossId} ||BossId <- BossIdList],
	BossKillCountList = mod_week:get_count(RoleId, CountTypeList),
	NewBossKillCountList = [{BossId, Count} ||{{_, _, BossId}, Count} <- BossKillCountList],
	NewBossKillCountList.

make_rank_role(RoleId, RoleName, ServerId, ServerNum) ->
	#week_dun_rank_role{role_id = RoleId, role_name = RoleName, server_id = ServerId, server_num = ServerNum}.

trans_to_week_dun_rank_role(DunRoleList) ->
	[make_rank_role(RoleId, RoleName, ServerId, ServerNum) 
		||#dungeon_role{id = RoleId, server_id = ServerId, server_num = ServerNum, figure = #figure{name = RoleName}} <- DunRoleList].

db_select_week_dun_score(RoleId) ->
	db:get_all(io_lib:format(<<"select dun_id, score from `week_dun_score` where role_id=~p">>, [RoleId])).

db_replace_week_dun_score(RoleId, DunId, NewScore) ->
	db:execute(io_lib:format(<<"replace into `week_dun_score` set role_id=~p, dun_id=~p, score=~p">>, [RoleId, DunId, NewScore])).

gm_send_boss_drop(Title, Content, StartTime, EndTime) ->
	Sql = io_lib:format(<<"select role_id, dun_id, boss_rewards from log_week_dungeon_settlement where time>=~p and time<~p">>, [StartTime, EndTime]),
	case db:get_all(Sql) of 
		[] -> ok;
		DbList ->
			F = fun([RoleId, DunId, BossStateInfo], Map) ->
				FI = fun({BossId, _, RewardList}, List) ->
					case length(RewardList) > 0 of 
						true ->
							RewardListView = data_week_dungeon:get_boss_reward_view(DunId, BossId),
							RewardListView ++ List;
						_ ->
							List
					end
				end,
				NewRewardList = lists:foldl(FI, [], util:bitstring_to_term(BossStateInfo)),
				OldList = maps:get(RoleId, Map, []),
				maps:put(RoleId, NewRewardList++OldList, Map)
			end,
			RewardMap = lists:foldl(F, #{}, DbList),
			%?PRINT("gm_send_boss_drop RewardMap:~p~n", [RewardMap]),
			F2 = fun(RoleId, SendRewardList, Acc) ->
				lib_mail_api:send_sys_mail([RoleId], Title, Content, SendRewardList),
				Acc
			end,
			maps:fold(F2, 1, RewardMap)
	end.
%% lib_week_dungeon:gm_static_product(0).
gm_static_product(StartTime) ->
	StaticList = gm_static_product_do(StartTime),
	F = fun({RoleId, RewardList}, List) ->
		F2 = fun({_, TypeId, Num}, List2) ->
			[TypeId, Num|List2]
		end,
		RewardStr1 = lists:foldl(F2, [], lib_goods_api:make_reward_unique(RewardList)),
		RewardStr = util:link_list(RewardStr1, "*"),
		Str = lists:concat([RoleId, "_", RewardStr]),
		List ++ Str ++ ","
	end,
	lists:foldl(F, "", StaticList).

gm_static_product_do(StartTime) ->
	DunId = 36101,
	Sql = io_lib:format(<<"select role_id, boss_rewards, time from log_week_dungeon_settlement where dun_id=~p and time>=~p">>, [DunId, StartTime]),
	case db:get_all(Sql) of 
		[] -> [];
		DbList ->
			F = fun([RoleId, BossStateInfoStr, Time], Map) ->
				BossStateInfo = util:bitstring_to_term(BossStateInfoStr),
				F2 = fun({BossId, _, RewardList}, Map2) ->
					case length(RewardList) > 0 of
						true ->
							OVar = maps:get({RoleId, DunId, BossId}, Map2, []),
							NewVar = update_count_list(OVar, Time, BossId, []),
							maps:put({RoleId, DunId, BossId}, NewVar, Map2);
						_ ->
							Map2
					end
				end,
				lists:foldl(F2, Map, BossStateInfo)
			end,
			RoleBossMap = lists:foldl(F, #{}, DbList),
			%?PRINT("gm_static_product RoleBossMap: ~p~n", [RoleBossMap]),
			FSet = fun({RoleId, _, BossId}, CountList, List) ->
				FSet2 = fun({_, Count}, List2) ->
					Count2 = Count - 1,
					case Count2 > 0 of 
						true ->
							RewardListView = data_week_dungeon:get_boss_reward_view(DunId, BossId),
							List2 ++ [{Var1, Var2, Var3*Count2} || {Var1, Var2, Var3} <- RewardListView];
						_ -> List2
					end
				end,
				RewardsList = lists:foldl(FSet2, [], CountList),
				case RewardsList == [] of 
					true -> List;
					_ ->
						{_, OldL} = ulists:keyfind(RoleId, 1, List, {RoleId, []}),
						lists:keystore(RoleId, 1, List, {RoleId, RewardsList++OldL})
				end
			end,
			StaticList = maps:fold(FSet, [], RoleBossMap),
			StaticList
	end.

update_count_list([], Time, _BossId, Return) -> [{Time, 1}|Return];
update_count_list([{Time1, Count1}|Left], Time, BossId, Return) ->
	case utime:is_same_week(Time1, Time) of 
		true -> 
			Return ++ [{Time1, Count1+1}|Left];
		_ ->
			update_count_list(Left, Time, BossId, [{Time1, Count1}|Return])
	end.
