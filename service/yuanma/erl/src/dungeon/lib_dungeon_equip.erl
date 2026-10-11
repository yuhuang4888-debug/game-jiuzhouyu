%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_equip.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-10-27
%% @Description:    装备副本特殊逻辑
%%-----------------------------------------------------------------------------
% typical_data
% #{
%      ?DUN_STATE_SPCIAL_KEY_MON_BORN_TIME => [{EventId, Time}],
%      ?DUN_STATE_SPCIAL_KEY_REPLACE_MON => [{MonId, MonId2}],
%      ?DUN_STATE_SPCIAL_KEY_EQUIP_SCORE => [{MonId, Attr}],
% }

-module (lib_dungeon_equip).
-include ("dungeon.hrl").
-include ("team.hrl").
-include ("def_module.hrl").
-include ("errcode.hrl").
-include ("common.hrl").
-include ("server.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-export ([
    relac_setting_list_for_pull/5
    ,dunex_handle_enter_dungeon_for_setting/5
    ,dunex_mon_event_id_kill_all_mon/2
    ,dunex_mon_event_id_finish/2
    ,dunex_get_send_reward/2
    ,dunex_calc_score/2
    ,dunex_get_time_score_step/1
    ,dunex_push_settlement/2
    ,dunex_buy_count_done/4
    ,init_dungeon_role/3
]).

%% 重新计算设置列表
relac_setting_list_for_pull(Player, DunId, ?HELP_TYPE_NO, _SettingList0, Count0) ->
    NewPlayer = lib_dungeon_setting:init_setting_list(Player, DunId),
    SettingL = lib_dungeon_setting:get_setting_list(NewPlayer, DunId),
    Dun = data_dungeon:get(DunId),
    #{count:=Count} = lib_dungeon_setting:make_setting_data_info(SettingL, Dun, #{count => Count0}),
    {SettingL, Count};
relac_setting_list_for_pull(_Player, _DunId, _HelpType, SettingList, _Count) ->
    {SettingList, 1}.

%% 进入场景的设置
dunex_handle_enter_dungeon_for_setting(Player, _Dun, _HelpType, SettingList, Count) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    mod_dungeon:update_dungeon_role(CopyId, RoleId, [{setting_list, SettingList}, {count, Count}]),
    Player.

dunex_mon_event_id_finish(State, MonEventId) ->
    #dungeon_state{dun_id = DunId, typical_data = TypicalData} = State,
    case data_dungeon_special:get(DunId, mon_all_die_result) of
        undefined ->
            State;
        ResList ->
            case lists:keyfind(MonEventId, 1, ResList) of
                false ->
                    send_time_step_to_all(State),
                    State;
                _ ->
                    MonBornTimeList = maps:get(?DUN_STATE_SPCIAL_KEY_MON_BORN_TIME, TypicalData, []),
                    NewBornTimeList = lists:keystore(MonEventId, 1, MonBornTimeList, {MonEventId, utime:unixtime()}),
                    NewState = State#dungeon_state{typical_data = TypicalData#{?DUN_STATE_SPCIAL_KEY_MON_BORN_TIME => NewBornTimeList}},
                    send_time_step_to_all(NewState),
                    NewState
            end
    end.

dunex_mon_event_id_kill_all_mon(State, #dungeon_common_event{id = MonEventId}) ->
    #dungeon_state{dun_id = DunId, typical_data = TypicalData} = State,
    case data_dungeon_special:get(DunId, mon_all_die_result) of
        undefined ->
            State;
        ResList ->
            MonBornTimeList = maps:get(?DUN_STATE_SPCIAL_KEY_MON_BORN_TIME, TypicalData, []),
            case lists:keyfind(MonEventId, 1, MonBornTimeList) of
                {MonEventId, BornTime} ->
                    NewBornTimeList = lists:delete({MonEventId, BornTime}, MonBornTimeList),
                    CostTime = utime:unixtime() - BornTime,
                    F = fun
                        ({Id, Time, _, _} = Item, {IsKeep, TimeoutList}) when Id == MonEventId ->
                            OneIsKeep = CostTime =< Time,
                            NIsKeep = IsKeep andalso OneIsKeep,
                            NTimeoutList = ?IF(OneIsKeep, TimeoutList, [Item|TimeoutList]),
                            {NIsKeep, NTimeoutList};
                        (_, {IsKeep, TimeoutList}) ->
                            {IsKeep, TimeoutList}
                    end,
                    {IsKeep, TimeoutList} = lists:foldl(F, {true, []}, ResList),
                    % 分数越高难度越小
                    case IsKeep of
                        true ->
                            State#dungeon_state{typical_data = TypicalData#{?DUN_STATE_SPCIAL_KEY_MON_BORN_TIME => NewBornTimeList} };     
                        false ->
                            Score = maps:get(?DUN_STATE_SPCIAL_KEY_EQUIP_SCORE, TypicalData, 1),
                            NewScore = Score + 1,
                            MonReplaceList = maps:get(?DUN_STATE_SPCIAL_KEY_REPLACE_MON, TypicalData, []),
                            case data_dungeon_special:get(DunId, score_replace_mon) of
                                undefined -> ScoreReplaceMonL = [];
                                CfgScoreReplaceMonL -> 
                                    case lists:keyfind(NewScore, 1, CfgScoreReplaceMonL) of
                                        false -> ScoreReplaceMonL = [];
                                        ScoreReplaceMon -> ScoreReplaceMonL = [ScoreReplaceMon]
                                    end
                            end,
                            NewMonReplaceList = replcae_mon_id(MonReplaceList, ScoreReplaceMonL++TimeoutList),
                            % ?MYLOG("hjhequip", "mon_event_id_kill_all_mon MonReplaceList:~p ScoreReplaceMonL:~p TimeoutList:~p NewMonReplaceList:~p NewScore:~p ~n", 
                            %     [MonReplaceList, ScoreReplaceMonL, TimeoutList, NewMonReplaceList, NewScore]),
                            State#dungeon_state{typical_data = TypicalData#{
                                ?DUN_STATE_SPCIAL_KEY_REPLACE_MON => NewMonReplaceList, 
                                ?DUN_STATE_SPCIAL_KEY_EQUIP_SCORE => NewScore,
                                ?DUN_STATE_SPCIAL_KEY_MON_BORN_TIME => NewBornTimeList
                            }}
                    end;
                _ ->
                    State
            end
    end.

% append_mon_attrs(MonAddAttrList, [{_, _, MonId, Attr}|T]) ->
%     NewAttrList
%     = case lists:keyfind(MonId, 1, MonAddAttrList) of
%         {MonId, TotalAttr} ->
%             lists:keystore(MonId, 1, MonAddAttrList, {MonId, lib_player_attr:list_add_to_attr(Attr, TotalAttr)});
%         _ ->
%             [{MonId, lib_player_attr:list_add_to_attr(Attr)}|MonAddAttrList]
%     end,
%     append_mon_attrs(NewAttrList, T);

% append_mon_attrs(MonAddAttrList, []) -> MonAddAttrList.

replcae_mon_id(List, [{_, MonId, MonId2}|T]) ->
    NewList = lists:keystore(MonId, 1, List, {MonId, MonId2}),
    replcae_mon_id(NewList, T);

replcae_mon_id(List, [{_, _, MonId, MonId2}|T]) ->
    NewList = lists:keystore(MonId, 1, List, {MonId, MonId2}),
    replcae_mon_id(NewList, T);

replcae_mon_id(List, []) -> List.

dunex_get_send_reward(#dungeon_state{result_type = ResultType}, _) when ResultType =/= ?DUN_RESULT_TYPE_SUCCESS ->
    [];

dunex_get_send_reward(State, #dungeon_role{help_type = ?HELP_TYPE_NO} = DungeonRole) ->
    #dungeon_state{typical_data = TypicalData, dun_id = DunId} = State,
    Score = maps:get(?DUN_STATE_SPCIAL_KEY_EQUIP_SCORE, TypicalData, 1),
    Reward = lib_dungeon_api:get_dungeon_grade(DungeonRole, DunId, Score),
    [{?REWARD_SOURCE_DUNGEON, Reward}];

dunex_get_send_reward(State, DunRole) ->
    #dungeon_role{id = RoleId, node = Node, typical_data = TypicalData} = DunRole,
    #dungeon_state{dun_id = DunId, dun_type = DunType} = State,
    case data_dungeon_special:get(DunId, help_rewards) of
        {NumLimit, Rewards} ->
            HelpNum = maps:get(help_num, TypicalData, NumLimit),
            LeftNum = NumLimit - HelpNum,
            if
                LeftNum > 0 ->
                    CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
                    unode:apply(Node, mod_daily, increment_offline, [RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP_AWARD, CountType]),
                    [{?REWARD_SOURCE_DUNGEON, Rewards}];
                true ->
                    []
            end;
        _ ->
            []
    end.

dunex_calc_score(State, _) ->
    #dungeon_state{typical_data = TypicalData} = State,
    Score = maps:get(?DUN_STATE_SPCIAL_KEY_EQUIP_SCORE, TypicalData, 1),
    Score.

dunex_get_time_score_step(State) ->
    #dungeon_state{typical_data = TypicalData, dun_id = DunId} = State,
    Score = maps:get(?DUN_STATE_SPCIAL_KEY_EQUIP_SCORE, TypicalData, 1),
    case data_dungeon_special:get(DunId, mon_all_die_result) of
        undefined ->
            ChangeTime = 0, NextScore = Score;
        ResList ->
            case maps:get(?DUN_STATE_SPCIAL_KEY_MON_BORN_TIME, TypicalData, []) of
                [] ->
                    ChangeTime = 0, NextScore = Score;
                MonBornTimeList ->
                    case get_first_born_event_id(MonBornTimeList, ResList, utime:unixtime()) of
                        {ok, ChangeTime} -> NextScore = Score + 1;
                        _ -> ChangeTime = 0, NextScore = Score
                    end
            end
    end,
    {Score, NextScore, ChangeTime}.

get_first_born_event_id([{EventId, BornTime}|T], ResList, Now) ->
    case [{Id, Time} || {Id, Time, _, _} <- ResList, Id == EventId] of
        [{EventId, Time}|_] -> {ok, BornTime + Time};
        _ -> get_first_born_event_id(T, ResList, Now)
    end;
get_first_born_event_id([], _, _) -> 0.

send_time_step_to_all(State) ->
    {Score, NextScore, ChangeTime} = dunex_get_time_score_step(State),
    #dungeon_state{role_list = RoleList} = State,
    {ok, BinData} = pt_610:write(61023, [Score, NextScore, ChangeTime]),
    [lib_server_send:send_to_uid(Node, RoleId, BinData) || #dungeon_role{id = RoleId, node = Node} <- RoleList].

dunex_push_settlement(State, DungeonRole) ->
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
            3
    end,
    #dungeon_role{count = Count, help_type = HelpType, reward_map = RewardMap} = DungeonRole,
    RewardList = lib_dungeon:calc_base_reward_list(DungeonRole),
    MultipleReward = maps:get(?REWARD_SOURCE_DUNGEON_MULTIPLE, RewardMap, []),
    % ?MYLOG("hjhequip", "push_settlement dungeon_state:~w RewardMap:~p Count:~p ~n", [RewardList, DungeonRole#dungeon_role.reward_map, Count]),
    {ok, BinData} = pt_610:write(61003, [ResultType, ResultSubtype, DunId, Grade, SceneId, RewardList, [{2, MultipleReward}], [{9, HelpType}], Count]),
    DungeonRole#dungeon_role.help_type =/= ?HELP_TYPE_ASSIST
        andalso lib_server_send:send_to_uid(DungeonRole#dungeon_role.node, DungeonRole#dungeon_role.id, BinData).

dunex_buy_count_done(Player, #dungeon{id = DunId}, _VipBuyCount, _Count) ->
    #player_status{help_type_setting = HMap, team = #status_team{team_id = TeamId}} = Player,
    case maps:find(DunId, HMap) of
        {ok, {default, ?HELP_TYPE_YES}} ->
            case lib_dungeon_team:get_default_help_type(Player, DunId) of
                ?HELP_TYPE_NO ->
                    NewPlayer = Player#player_status{help_type_setting = HMap#{DunId => {default, ?HELP_TYPE_NO}}},
                    mod_team:cast_to_team(TeamId, {'set_help_type', Player#player_status.id, DunId, ?HELP_TYPE_NO}),
                    {ok, NewPlayer};
                _ ->
                    ok
            end;
        _ ->
            ok
    end.

init_dungeon_role(#player_status{id = Id}, #dungeon{id = DunId, type = DunType}, #dungeon_role{help_type = ?HELP_TYPE_YES} = Role) ->
    CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
    HelpNum = mod_daily:get_count_offline(Id, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP_AWARD, CountType),
    Role#dungeon_role{typical_data = #{help_num => HelpNum}};

init_dungeon_role(_, _, Role) -> Role.