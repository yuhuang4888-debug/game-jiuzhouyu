%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_guild_guard.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-11-14
%% @Description:    守卫公会特殊逻辑
%%-----------------------------------------------------------------------------

-module (lib_dungeon_guild_guard).
-include ("dungeon.hrl").
-include ("predefine.hrl").
-include ("figure.hrl").
-include ("scene.hrl").
-include ("attr.hrl").
-include ("common.hrl").
-include ("def_event.hrl").
-include ("rec_event.hrl").
-include ("def_module.hrl").
-include ("server.hrl").
-include ("goods.hrl").

%% 副本流程特殊处理接口
-export ([
    dunex_handle_kill_mon/4
    ,dunex_handle_quit_dungeon/2
    ,dunex_handle_enter_dungeon/2
    ,dunex_fin_change_scene/4
    %,push_settlement/2
    ,dunex_get_send_reward/2
    ,dunex_stop_dungeon_when_no_role/4
    ,dunex_handle_dungeon_result/1
    ,dunex_dungeon_destory/2
    ,dunex_mon_event_id_finish/2
    , dunex_handle_wave_subtype_refresh/3
    ,dunex_special_pp_handle/4
    % ,add_exp/3
    % ,send_panel_info/2
    ,get_dungeon_mon_dynamic/1
    ,dunex_get_exp_got/2
    ,dunex_is_calc_result_before_finish/0
    ]).

%% 外部接口
-export ([
    npc_hp_change_handler/4
    ,npc_born_handler/3
    ,create_dun/7
    ,clean_buff/2
    ,npc_die/2
    ,dunex_fin_change_scene/2
    ]).

-define(WVN_TYPE_COM, 1). %% 普通怪波数信息
-define(WVN_TYPE_SP, 2).  %% 突袭怪波数信息

%% 波数怪刷新
dunex_handle_wave_subtype_refresh(State, CommonEventId, WaveSubtype) ->
    BelongType = ?DUN_EVENT_BELONG_TYPE_MON,
    #dungeon_state{scene_pool_id = ScenePoolId, dun_id = DunId, common_event_map = CommonEventMap, typical_data = TypicalData} = State,
    CommonEvent = maps:get({BelongType, CommonEventId}, CommonEventMap),
    #dungeon_common_event{wave_type = WaveType, scene_id = SceneId, args = Args, wave_subtype_map = WaveSubtypeMap} = CommonEvent,
    %?PRINT("handle_wave_subtype_refresh##### ~p~n", [{WaveType, WaveSubtype, Args}]),
    #dungeon_wave_subtype{cycle_num = CycleNum} = maps:get(WaveSubtype, WaveSubtypeMap),
    CreateTimeList = lib_dungeon_mon_event:get_create_time_list(DunId, SceneId, WaveType, WaveSubtypeMap),
    case CreateTimeList == [] of
        true -> NextRefreshTime = 0;
        false ->
            NextRefreshTime = hd(CreateTimeList)
    end,
    case lists:keyfind(wvn, 1, Args) of 
        {wvn, _WaveNum} when WaveSubtype == 1 -> %% 先做特殊处理，子波类型大于1的不处理
            OldWvnInfo = maps:get(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, TypicalData, []),
            NewWvnInfo = lists:keystore(?WVN_TYPE_COM, 1, OldWvnInfo, {?WVN_TYPE_COM, [CommonEventId, WaveType, WaveSubtype, CycleNum, NextRefreshTime]}),
            NewTypicalData = maps:put(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, NewWvnInfo, TypicalData),
            NewState = State#dungeon_state{typical_data = NewTypicalData},
            SendList = get_broadcast_wvn_info(NewState),
            {ok, BinData} = pt_610:write(61035, [DunId, SendList]),
            lib_dungeon_mod:send_msg(State, BinData),
            ?PRINT("handle_wave_subtype_refresh##### ~p~n", [SendList]),
            NewState;
        _ -> %% 不是波数怪
            case lists:keyfind(sp_mon, 1, Args) of 
                {_, _} -> %% 突击怪， 发个传闻通知
                    lib_chat:send_TV({scene, SceneId, ScenePoolId, self()}, ?MOD_DUNGEON, 2, []),
                    OldWvnInfo = maps:get(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, TypicalData, []),
                    NewWvnInfo = lists:keystore(?WVN_TYPE_SP, 1, OldWvnInfo, {?WVN_TYPE_SP, [CommonEventId, WaveType, WaveSubtype, CycleNum, NextRefreshTime]}),
                    NewTypicalData = maps:put(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, NewWvnInfo, TypicalData),
                    NewState = State#dungeon_state{typical_data = NewTypicalData},
                    SendList = get_broadcast_wvn_info(NewState),
                    %?PRINT("handle_wave_subtype_refresh##### ~p~n", [SendList]),
                    {ok, BinData} = pt_610:write(61035, [DunId, SendList]),
                    lib_dungeon_mod:send_msg(NewState, BinData),
                    NewState;
                _ ->
                    State
            end     
    end.

%% 怪物事件触发
dunex_mon_event_id_finish(State, CommonEventId) ->
    BelongType = ?DUN_EVENT_BELONG_TYPE_MON,
    #dungeon_state{role_list = RoleList, dun_id = DunId, common_event_map = CommonEventMap, typical_data = TypicalData} = State,
    CommonEvent = maps:get({BelongType, CommonEventId}, CommonEventMap),
    #dungeon_common_event{wave_type = WaveType, scene_id = SceneId, args = Args, wave_subtype_map = WaveSubtypeMap} = CommonEvent,
    %% 获取最小的子波数
    WaveSubtype = lists:min(maps:keys(WaveSubtypeMap)),
    %?PRINT("mon_event_id_finish##### ~p~n", [{WaveType, WaveSubtype}]),
    #dungeon_wave_subtype{cycle_num = CycleNum} = maps:get(WaveSubtype, WaveSubtypeMap, #dungeon_wave_subtype{cycle_num = 0}),
    CreateTimeList = lib_dungeon_mon_event:get_create_time_list(DunId, SceneId, WaveType, WaveSubtypeMap),
    case CreateTimeList == [] of
        true -> NextRefreshTime = 0;
        false ->
            NextRefreshTime = hd(CreateTimeList)
    end,
    case lists:keyfind(wvn, 1, Args) of 
        {wvn, _WaveNum} ->
            OldWvnInfo = maps:get(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, TypicalData, []),
            NewWvnInfo = lists:keystore(?WVN_TYPE_COM, 1, OldWvnInfo, {?WVN_TYPE_COM, [CommonEventId, WaveType, WaveSubtype, CycleNum, NextRefreshTime]}),
            NewTypicalData = maps:put(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, NewWvnInfo, TypicalData),
            lib_achievement_api:guild_guard_event(RoleList, _WaveNum),
            NewState = State#dungeon_state{typical_data = NewTypicalData},
            SendList = get_broadcast_wvn_info(NewState),
            {ok, BinData} = pt_610:write(61035, [DunId, SendList]),
            lib_dungeon_mod:send_msg(NewState, BinData),
            ?PRINT("mon_event_id_finish##### ~p~n", [SendList]),
            NewState;
        _ -> %% 不是波数怪
            case lists:keyfind(sp_mon, 1, Args) of 
                {_, _} -> %% 突击怪
                    OldWvnInfo = maps:get(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, TypicalData, []),
                    NewWvnInfo = lists:keystore(?WVN_TYPE_SP, 1, OldWvnInfo, {?WVN_TYPE_SP, [CommonEventId, WaveType, WaveSubtype, CycleNum, NextRefreshTime]}),
                    NewTypicalData = maps:put(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, NewWvnInfo, TypicalData),
                    NewState = State#dungeon_state{typical_data = NewTypicalData},
                    SendList = get_broadcast_wvn_info(NewState),
                    {ok, BinData} = pt_610:write(61035, [DunId, SendList]),
                    lib_dungeon_mod:send_msg(NewState, BinData),
                    %?PRINT("mon_event_id_finish##### ~p~n", [SendList]),
                    NewState;
                _ ->
                    State
            end   
    end.

%% 怪物击杀
dunex_handle_kill_mon(State, Mid, _CreateKey, DieDatas) ->
    #dungeon_state{
        typical_data = TypicalData, dun_id = _DunId, now_scene_id = SceneId,
        scene_pool_id = ScenePoolId,
        role_list = RoleList
    } = State,
    CopyId = self(),
    AllMonDieCount = maps:get(?DUN_STATE_SPCIAL_KEY_DIE_MON_COUNT, TypicalData, 0) + 1,
    TmpTypicalData
    = case data_guild_guard:get_kv(1) of
        undefined ->
            {ok, BinData} = pt_610:write(61031, [AllMonDieCount]),
            mod_scene_agent:send_to_scene(SceneId, ScenePoolId, CopyId, BinData),
            TypicalData#{?DUN_STATE_SPCIAL_KEY_DIE_MON_COUNT => AllMonDieCount};
        NpcList ->
            case lists:keyfind(Mid, 1, NpcList) of
                {_, [BuffSkillId|_]} ->
                    DieCount = maps:get({?DUN_STATE_SPCIAL_KEY_MON_DIE, Mid}, TypicalData, 0) + 1,
                    NpcTypicalData = TypicalData#{{?DUN_STATE_SPCIAL_KEY_MON_DIE, Mid} => DieCount},
                    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, player_apply_cast, [CopyId, ?APPLY_CAST_STATUS, ?MODULE, npc_die, [BuffSkillId]]),
                    NpcTypicalData;
                _ ->
                    {ok, BinData} = pt_610:write(61031, [AllMonDieCount]),
                    mod_scene_agent:send_to_scene(SceneId, ScenePoolId, CopyId, BinData),
                    TypicalData#{?DUN_STATE_SPCIAL_KEY_DIE_MON_COUNT => AllMonDieCount}
            end
    end,
    NewTypicalData
    = case lists:keyfind(klist, 1, DieDatas) of
        {klist, KList} ->
            update_hurt_list(TmpTypicalData, KList, RoleList);
        _ ->
            TmpTypicalData    
    end,
    State#dungeon_state{typical_data = NewTypicalData}.

dunex_get_exp_got(State, [RoleId, Sid, LvBefore, ExpBefore, NewLv, NewExp]) ->
    #dungeon_state{dun_id = DunId, typical_data = TypicalData} = State,
    RoleExpMap = maps:get(?DUN_STATE_SPECIAL_KEY_ADD_EXP_LIST, TypicalData, #{}),
    [EnterLv, EnterExp, AccExp] = maps:get(RoleId, RoleExpMap, [LvBefore, ExpBefore, 0]),
    DvalueExp = lib_dungeon:calc_got_exp(NewLv, NewExp, EnterLv, EnterExp),
    NewAccExp = DvalueExp + AccExp,
    NewRoleExpMap = maps:put(RoleId, [NewLv, NewExp, NewAccExp], RoleExpMap),
    NewTypicalData = maps:put(?DUN_STATE_SPECIAL_KEY_ADD_EXP_LIST, NewRoleExpMap, TypicalData),
    {ok, BinData} = pt_610:write(61041, [DunId, NewAccExp]),
    %?PRINT("get_exp_got ~p~n", [NewAccExp]),
    lib_server_send:send_to_sid(Sid, BinData),
    State#dungeon_state{typical_data = NewTypicalData}.

%% 获取副本的动态属性加成
get_dungeon_mon_dynamic(State) ->
    #dungeon_state{common_event_map = CommonEventMap, typical_data = TypicalData} = State,
    case maps:get(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, TypicalData, []) of 
        [] -> NewChallengeGuard = 1;
        WvnList ->
            case lists:keyfind(?WVN_TYPE_COM, 1, WvnList) of 
                {_, [CommonEventId|_]} when CommonEventId > 0 ->
                    CommonEvent = maps:get({?DUN_EVENT_BELONG_TYPE_MON, CommonEventId}, CommonEventMap),
                    #dungeon_common_event{wave_type = _WaveType, args = Args} = CommonEvent,
                    {_, NewChallengeGuard} = ulists:keyfind(wvn, 1, Args, {wvn, 1});
                _ ->
                    NewChallengeGuard = 1
            end
    end,
    %?PRINT("get_dungeon_mon_dynamic ~p~n", [NewChallengeGuard]),
    DunR = math:pow(1.2, NewChallengeGuard),
    [{dun_r, DunR}].

%% 离开副本
dunex_handle_quit_dungeon(Player, #dungeon{id = _DunId}) ->
    case data_guild_guard:get_kv(1) of
        undefined ->
            Player;
        NpcList ->
            SkillIds = [BuffSkillId || {_, [BuffSkillId|_]} <- NpcList],
            lib_player_event:add_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, clean_buff, SkillIds),
            Player
    end.

%% 进入副本
dunex_handle_enter_dungeon(Player, _Dun) ->
    lib_task_api:guild_activity(Player#player_status.id, ?MOD_GUILD_ACT_GUARD),
    Player.

%% 获取奖励
dunex_get_send_reward(State, DungeonRole) ->
    #dungeon_state{dun_id = _DunId, typical_data = _TypicalData, result_type = _ResultType} = State,
    #dungeon_role{id = _RoleId, figure = #figure{lv = Lv}} = DungeonRole,
    NewChallengeGuard = get_guild_guard_current_challenge_gurad(State),
    BaseReward = data_guild_guard:get_guard_reward(NewChallengeGuard, Lv),
    %{TowerNum, ExRewardList0} = get_extra_rewards(DunId, TypicalData),
    ?PRINT("get_send_reward ====== BaseReward ~p~n", [BaseReward]),
    [{?REWARD_SOURCE_DUNGEON, BaseReward}].

dunex_is_calc_result_before_finish() -> false.

%% 副本结束(包含超时结束)
dunex_handle_dungeon_result(State) ->
    #dungeon_state{typical_data = TypicalData} = State,
    GuildId = maps:get(?DUN_STATE_SPCIAL_KEY_GUILD_ID, TypicalData, 0),
    NewChallengeGuard = get_guild_guard_current_challenge_gurad(State),
    ?PRINT("handle_dungeon_result ====== NewChallengeGuard ~p~n", [NewChallengeGuard]),
    log_guild_guard_dungeon(State, GuildId),
    mod_guild_guard:dungeon_finish([GuildId, NewChallengeGuard]).

%% 
dunex_dungeon_destory(State, _) ->
    #dungeon_state{typical_data = TypicalData} = State,
    GuildId = maps:get(?DUN_STATE_SPCIAL_KEY_GUILD_ID, TypicalData, 0),
    mod_guild_guard:dungeon_end(GuildId).

%% 进入副本(加在完场景)
dunex_fin_change_scene(State, RoleId, _X, _Y) ->
    #dungeon_state{dun_id = _DunId, role_list = RoleList, typical_data = TypicalData, result_type = ResultType} = State,
    case data_guild_guard:get_kv(1) of
        [_|_] = NpcList when ResultType =:= ?DUN_RESULT_TYPE_NO ->
            AvailableList = [SkillId || {NpcId, [SkillId|_]} <- NpcList, maps:is_key({?DUN_STATE_SPCIAL_KEY_MON_DIE, NpcId}, TypicalData) =:= false],
                lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, fin_change_scene, [AvailableList]),
            ok;
        _ ->
            ok
    end,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of 
        #dungeon_role{figure = #figure{lv = Lv}, data_before_enter = DataBfEnter} ->
            RoleExpMap = maps:get(?DUN_STATE_SPECIAL_KEY_ADD_EXP_LIST, TypicalData, #{}),
            [_, _, AccExp] = maps:get(RoleId, RoleExpMap, [0, 0, 0]),
            EnterLv = maps:get(lv_before, DataBfEnter, Lv),
            EnterExp = maps:get(exp_before, DataBfEnter, 0),
            %?PRINT("fin_change_scene ====== new ~p~n", [{EnterLv, EnterExp}]),
            NewRoleExpMap = maps:put(RoleId, [EnterLv, EnterExp, AccExp], RoleExpMap),
            NewTypicalData = maps:put(?DUN_STATE_SPECIAL_KEY_ADD_EXP_LIST, NewRoleExpMap, TypicalData),
            State#dungeon_state{typical_data = NewTypicalData};
        _ -> State
    end.

dunex_fin_change_scene(Player, List) ->
    F = fun
        (SkillId, PS) ->
            lib_goods_buff:add_skill_buff(PS, SkillId, 1)
    end,
    NewPlayer = lists:foldl(F, Player, List),
    %?PRINT("fin_change_scene ====== add buff ~p~n", [List]),
    {ok, NewPlayer}.

%% 战塔死亡，清buff
npc_die(Player, BuffSkillId) ->
    %?PRINT("npc_die ====== BuffSkillId ~p~n", [BuffSkillId]),
    lib_goods_buff:remove_skill_buff(Player, BuffSkillId).

clean_buff(Player, #event_callback{param = SkillIds}) ->
    %?PRINT("clean_buff ====== SkillIds ~p~n", [SkillIds]),
    lib_player_event:remove_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, clean_buff),
    NewPlayer = clear_buff_list(Player, SkillIds),
    {ok, NewPlayer}.

clear_buff_list(Player, [SkillId|T]) ->
    NewPlayer = lib_goods_buff:remove_skill_buff(Player, SkillId),
    clear_buff_list(NewPlayer, T);

clear_buff_list(Player, []) -> Player.
    
% push_settlement(_State, _DungeonRole) -> ok.
    % #dungeon_state{
    %     result_type = ResultType, 
    %     result_subtype = ResultSubType,
    %     now_scene_id = SceneId,
    %     dun_id = DunId} = State,
    % Score = lib_dungeon:calc_score(State, DungeonRole#dungeon_role.id),
    % Grade
    % = case data_dungeon_grade:get_dungeon_grade(DunId, Score) of
    %     #dungeon_grade{grade = Value} ->
    %         Value;
    %     _ ->
    %         0
    % end,
    % RewardList = lib_dungeon:calc_base_reward_list(DungeonRole),
    % case DungeonRole#dungeon_role.calc_reward_list of
    %     [_, {{extra, TowerNum}, ExRewardList}|_] ->
    %         ok;
    %     _ ->
    %         [_, {{extra, TowerNum}, ExRewardList}|_] = get_send_reward(State, DungeonRole)
    % end,
    % {ok, BinData} = pt_610:write(61099, [ResultType, ResultSubType, DunId, Grade, SceneId, RewardList, ExRewardList, TowerNum]),
    % lib_server_send:send_to_uid(DungeonRole#dungeon_role.id, BinData).

dunex_stop_dungeon_when_no_role(_, _, _, _) ->
    false.

get_start_args(GuildId, _DunId, Lv, _CombatPower, _EndTime, _ActiveNum, _ChallengeGuard) ->
    BornMFA = {?MODULE, npc_born_handler, []},
    HPMFA = {?MODULE, npc_hp_change_handler, 0},

    ListenMonIds1 = [MonId || {MonId, _X, _Y} <- data_guild_guard:get_kv(2)],
    ListenMonIds2 = [MonId || {MonId, _X, _Y} <- data_guild_guard:get_kv(3)],
    ListenMonIds = ListenMonIds1 ++ ListenMonIds2,
    TypicalData = [
        {?DUN_STATE_SPCIAL_KEY_REPLACE_MON, [{Mid, Mid, [{born_handler, BornMFA}, {hp_change_handler, HPMFA}]} || Mid <- ListenMonIds]},
        {?DUN_STATE_SPCIAL_KEY_GUILD_ID, GuildId},
        {?DUN_STATE_SPCIAL_KEY_WAVE_INFO, []}
    ],
    [{enter_lv, Lv}, {typical_data, TypicalData}, {scene_pool_id, GuildId rem 10}].

npc_hp_change_handler(Minfo, Hp, _Klist, LastUpdateTime) ->
    NowTime = utime:longunixtime(),
    if
        NowTime - LastUpdateTime >= 1900 orelse Hp =< 0 ->
            #scene_object{id = Id, config_id = Mid, copy_id = CopyId, battle_attr = #battle_attr{hp_lim = HpLim}} = Minfo,
            mod_dungeon:update_mon_hp(CopyId, Id, Mid, Hp, HpLim),
            {ok, NowTime};
        true ->
            skip
    end.

npc_born_handler(_, Minfo, _) ->
    #scene_object{id = Id, config_id = Mid, copy_id = CopyId, battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}} = Minfo,
    mod_dungeon:update_mon_hp(CopyId, Id, Mid, Hp, HpLim).

create_dun(GuildId, DunId, Lv, _CombatPower, EndTime, ActiveNum, ChallengeGuard) ->
    %?PRINT("create_dun ~p~n", [[DunId, Lv, _CombatPower, EndTime, ChallengeGuard]]),
    Args = get_start_args(GuildId, DunId, Lv, _CombatPower, EndTime, ActiveNum, ChallengeGuard),
    Pid = mod_dungeon:start(0, self(), DunId, [], Args),
    mod_dungeon:set_dungeon_start_wave_num(Pid, ChallengeGuard),
    lib_chat:send_TV({guild, GuildId}, ?MOD_GUILD_ACT, 8, []),
    {ok, Pid}.

get_guild_guard_current_challenge_gurad(State) ->
    #dungeon_state{common_event_map = CommonEventMap, typical_data = TypicalData, result_type = ResultType} = State,
    case maps:get(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, TypicalData, []) of 
        [] -> ChallengeGuard = 1;
        WvnList ->
            case lists:keyfind(?WVN_TYPE_COM, 1, WvnList) of 
                {_, [CommonEventId|_]} when CommonEventId > 0  ->
                    CommonEvent = maps:get({?DUN_EVENT_BELONG_TYPE_MON, CommonEventId}, CommonEventMap),
                    #dungeon_common_event{wave_type = _WaveType, args = Args} = CommonEvent,
                    {_, ChallengeGuard} = ulists:keyfind(wvn, 1, Args, {wvn, 1});
                _ ->
                    ChallengeGuard = 1
            end
    end,
    case ResultType == ?DUN_RESULT_TYPE_SUCCESS of 
        true -> NewChallengeGuard = ChallengeGuard;
        _ -> 
            NewChallengeGuard = max(1, ChallengeGuard - 1)
    end,
    NewChallengeGuard.

%% 更新伤害列表
update_hurt_list(TypicalData, KList, RoleList) ->
    HurtRank0 = maps:get(?DUN_STATE_SPCIAL_KEY_HURT_RANK, TypicalData, []),
    HurtRank = do_update_hurt_list(KList, RoleList, HurtRank0),
    TypicalData#{?DUN_STATE_SPCIAL_KEY_HURT_RANK => HurtRank}.

%% KList = [{Id, _Pid, _Node, _TeamId, Value}]
do_update_hurt_list([#mon_atter{id = Id, hurt = Value}|T], RoleList, Acc) ->
    case lists:keyfind(Id, 1, Acc) of
        {Id, Name, Value0} ->
            NewAcc = lists:keystore(Id, 1, Acc, {Id, Name, Value0 + Value}),
            do_update_hurt_list(T, RoleList, NewAcc);
        _ ->
            case lists:keyfind(Id, #dungeon_role.id, RoleList) of
                #dungeon_role{figure = #figure{name = Name}} ->
                    do_update_hurt_list(T, RoleList, [{Id, Name, Value}|Acc]);
                _ ->
                    do_update_hurt_list(T, RoleList, Acc)
            end
    end;

do_update_hurt_list([], _RoleList, HurtRank) ->
    lists:reverse(lists:keysort(3, HurtRank)).

dunex_special_pp_handle(State, Sid, 61035, []) ->
    #dungeon_state{dun_id = DunId, common_event_map = _CommonEventMap, typical_data = _TypicalData} = State,
    SendList = get_broadcast_wvn_info(State),
    %?PRINT("special_pp_handle ~p~n", [SendList]),
    {ok, BinData} = pt_610:write(61035, [DunId, SendList]),
    lib_server_send:send_to_sid(Sid, BinData);

dunex_special_pp_handle(_State, _, _, _) ->
    ok.

get_broadcast_wvn_info(State) ->
    BelongType = ?DUN_EVENT_BELONG_TYPE_MON,
    #dungeon_state{dun_id = DunId, common_event_map = CommonEventMap, typical_data = TypicalData} = State,
    WvnInfo = maps:get(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, TypicalData, []),
    F = fun({_, InfoList}, ReturnList) ->
        case InfoList of 
            [CommonEventId, WaveType, WaveSubtype, CycleNum, NextRefreshTime] ->
                CommonEvent = maps:get({BelongType, CommonEventId}, CommonEventMap),
                #dungeon_common_event{scene_id = SceneId, args = Args} = CommonEvent,
                ArgsString = util:term_to_string(Args),
                #dungeon_wave{cycle_num = MaxCycleNum} = data_dungeon_wave:get_wave(DunId, SceneId, WaveType, WaveSubtype),
                [{WaveType, ArgsString, WaveSubtype, CycleNum, MaxCycleNum, NextRefreshTime div 1000}|ReturnList];
            _ ->
               ReturnList 
        end
    end,
    lists:foldl(F, [], WvnInfo).

log_guild_guard_dungeon(State, GuildId) ->
    #dungeon_state{common_event_map = CommonEventMap, typical_data = TypicalData, result_type = ResultType} = State,
    case maps:get(?DUN_STATE_SPCIAL_KEY_WAVE_INFO, TypicalData, []) of 
        [] -> ChallengeGuard = 1, CycleNum = 1;
        WvnList ->
            case lists:keyfind(?WVN_TYPE_COM, 1, WvnList) of 
                {_, [CommonEventId, _WaveType, _WaveSubtype, CycleNum|_]} when CommonEventId > 0  ->
                    CommonEvent = maps:get({?DUN_EVENT_BELONG_TYPE_MON, CommonEventId}, CommonEventMap),
                    #dungeon_common_event{args = Args} = CommonEvent,
                    {_, ChallengeGuard} = ulists:keyfind(wvn, 1, Args, {wvn, 1});
                _ ->
                    ChallengeGuard = 1, CycleNum = 1
            end
    end,
    lib_log_api:log_guild_guard_dungeon(GuildId, ResultType, ChallengeGuard, CycleNum).

% calc_score(State, _RoleId) ->
%     #dungeon_state{typical_data = TypicalData} = State,
%     case data_guild_guard:get_kv(1) of
%         undefined -> 0;
%         NpcList ->
%             List = [NpcId ||{NpcId, _} <- NpcList, maps:is_key({?DUN_STATE_SPCIAL_KEY_MON_DIE, NpcId}, TypicalData) == false],
%             case length(List) of 
%                 3 -> 3;
%                 2 -> 2;
%                 1 -> 1;
%                 _ -> 0
%             end
%     end.

%% 加经验
% add_exp(State, RoleId, AddExp) ->
%     #dungeon_state{
%         typical_data = TypicalData
%     } = State,
%     RoleMap = maps:get(?DUN_STATE_SPECIAL_KEY_ADD_EXP_LIST, TypicalData, #{}),
%     Value = maps:get(RoleId, RoleMap, 0),
%     NewTypicalData = maps:put(?DUN_STATE_SPECIAL_KEY_ADD_EXP_LIST, maps:put(RoleId, Value+AddExp, RoleMap), TypicalData), 
%     NewState = State#dungeon_state{typical_data = NewTypicalData},
%     ?PRINT("add_exp##### ~p~n", [{Value, AddExp}]),
%     send_panel_info(NewState, RoleId),
%     NewState.

% %% 累积经验和击杀怪物数量信息
% send_panel_info(State, RoleId) ->
%     #dungeon_state{typical_data = TypicalData} = State,
%     AllMonDieCount = maps:get(?DUN_STATE_SPCIAL_KEY_DIE_MON_COUNT, TypicalData, 0),
%     RoleMap = maps:get(?DUN_STATE_SPECIAL_KEY_ADD_EXP_LIST, TypicalData, #{}),
%     Exp = maps:get(RoleId, RoleMap, 0),
%     {ok, BinData} = pt_610:write(61044, [AllMonDieCount, Exp]),
%     ?PRINT("send_panel_info ~p~n", [{AllMonDieCount, Exp}]),
%     lib_server_send:send_to_uid(RoleId, BinData),
%     ok.

% get_extra_rewards(_DunId, TypicalData) ->
%     case data_guild_guard:get_kv(1) of
%         undefined ->
%             TowerNum = 0,
%             ExRewardList = [];
%         NpcList ->
%             {ExRewardList0, TowerNum}
%             = lists:foldl(fun
%                 ({NpcId, [_, Rewards|_]}, {R, N} = Acc) ->
%                     case maps:is_key({?DUN_STATE_SPCIAL_KEY_MON_DIE, NpcId}, TypicalData) of
%                         false ->
%                             {Rewards ++ R, N+1};
%                         _ ->
%                             Acc
%                     end
%             end, {[], 0}, NpcList),
%             ExRewardList = lib_goods_api:make_reward_unique(ExRewardList0)
%     end,
%     {TowerNum, ExRewardList}.

% calc_advance_notice(State) ->
%     #dungeon_state{typical_data = TypicalData, dun_id = DunId, start_time = StartTime, level_start_time = LevelTime, common_event_map = CommonEventMap} = State,
%     case data_dungeon_special:get(DunId, special_wave_notice) of
%         undefined ->
%             Time = 0, LanguageId = 0;
%         ResList ->
%             BornEvents = maps:get(?DUN_STATE_SPCIAL_KEY_MON_BORN_TIME, TypicalData, []),
%             {Time, LanguageId} = calc_advance_notice(ResList, BornEvents, CommonEventMap, StartTime, LevelTime)
%     end,
%     {Time, LanguageId}.

% calc_advance_notice([{MonEventId, LanguageId}|T], BornEvents, CommonEventMap, StartTime, LevelTime) ->
%     case lists:keyfind(MonEventId, 1, BornEvents) of
%         false ->
%             case maps:find({?DUN_EVENT_BELONG_TYPE_MON, MonEventId}, CommonEventMap) of
%                 {ok, #dungeon_common_event{event_list = EventList}} ->
%                     case ulists:find(fun
%                         (#dungeon_event{type = Type}) ->
%                             case Type of
%                                 {dungeon_time, _} ->
%                                     true;
%                                 {level_time, _} ->
%                                     true;
%                                 _ ->
%                                     false
%                             end
%                     end, EventList) of
%                         {ok, #dungeon_event{type ={dungeon_time, DTime}}} ->
%                             {StartTime + DTime, LanguageId};
%                         {ok, #dungeon_event{type = {level_time, LTime}}} ->
%                             {LevelTime + LTime, LanguageId};
%                         _ ->
%                             calc_advance_notice(T, BornEvents, CommonEventMap, StartTime, LevelTime)
%                     end;
%                 _ ->
%                     calc_advance_notice(T, BornEvents, CommonEventMap, StartTime, LevelTime)
%             end;
%         _ ->
%             calc_advance_notice(T, BornEvents, CommonEventMap, StartTime, LevelTime)
%     end;

% calc_advance_notice([], _, _, _, _) -> {0, 0}.

