%%-----------------------------------------------------------------------------
%% @Module  :       mod_guild_war_battle
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-04
%% @Description:    公会争霸战斗模块
%%-----------------------------------------------------------------------------
-module(mod_guild_war_battle).

-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("def_goods.hrl").
-include("guild_war.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("attr.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

-export([start/1]).
-export([init/1, callback_mode/0, handle_event/4, terminate/3, code_change/4]).

-export([
    enter_scene/4
    , exit_scene/3
    , attack_mon/2
    , kill_mon/2
    , kill_player/2
    , send_battle_info/3
    ]).

start(Args) ->
    gen_statem:start(?MODULE, Args, []).

callback_mode()->
    handle_event_function.

init([Division, Round, RoomId, StartPkTime, Etime, GuildInfoMap]) ->
    %% 加载怪物
    ResourceMonMap = init_mon(),
    NowTime = utime:unixtime(),
    Ref = erlang:send_after(max(1, StartPkTime - NowTime) * 1000, self(), 'time_out'),
    StatusGWarBattle = #status_gwar_battle{
                            room_id = RoomId,
                            division = Division,
                            round = Round,
                            start_pk_time = StartPkTime,
                            etime = Etime,
                            ref = Ref,
                            guild_map = GuildInfoMap,
                            resource_mon_map = ResourceMonMap
                        },
    {ok, ready, StatusGWarBattle}.

enter_scene(Pid, GuildId, RoleId, StatusDominator) ->
    gen_statem:cast(Pid, {'enter_scene', GuildId, RoleId, StatusDominator}).

exit_scene(Pid, GuildId, RoleId) ->
    gen_statem:cast(Pid, {'exit_scene', GuildId, RoleId}).

attack_mon(Pid, Msg) ->
    gen_statem:cast(Pid, Msg).

kill_mon(Pid, Msg) ->
    gen_statem:cast(Pid, Msg).

kill_player(Pid, Msg) ->
    gen_statem:cast(Pid, Msg).

send_battle_info(Pid, GuildId, RoleId) ->
    gen_statem:cast(Pid, {'send_battle_info', GuildId, RoleId}).

handle_event(Type, Msg, StateName, State) ->
    case catch do_handle_event(Type, Msg, StateName, State) of
        {'EXIT', _R} ->
            ?ERR("handle_exit_error:~p~n", [[Type, Msg, StateName, _R]]),
            {keep_state, State};
        Reply -> Reply
    end.

do_handle_event(cast, {'enter_scene', GuildId, RoleId, StatusDominator}, _, State) ->
    #status_gwar_battle{
        etime = Etime,
        room_id = _RoomId,
        start_pk_time = StartPkTime,
        guild_map = GuildInfoMap
    } = State,
    case maps:get(GuildId, GuildInfoMap, false) of
        #gwar_guild_info{
            group_id = GroupId,
            role_num = RoleNum,
            role_map = RoleMap
        } = GuildInfo ->
            RoleNumLim = data_guild_war:get_cfg(role_num_lim),
            case RoleNum < RoleNumLim of
                true ->
                    SceneId = data_guild_war:get_cfg(scene_id),
                    case maps:get(RoleId, RoleMap, false) of
                        RoleInfo when is_record(RoleInfo, gwar_role_info) ->
                            IsNewJoin = false;
                        _ ->
                            IsNewJoin = true,
                            RoleInfo = #gwar_role_info{role_id = RoleId}
                    end,
                    case RoleInfo of
                        #gwar_role_info{
                            scene = OldSceneId
                        } when OldSceneId =/= SceneId ->
                            NewRoleNum = RoleNum + 1,
                            NewRoleMap = maps:put(RoleId, RoleInfo#gwar_role_info{scene = SceneId}, RoleMap),
                            PlusRatio = data_guild_war:get_cfg(timing_res_plus_ratio),
                            NewPlusRate = round(NewRoleNum * PlusRatio),
                            NewGuildInfo = GuildInfo#gwar_guild_info{role_num = NewRoleNum, role_map = NewRoleMap, plus_rate = NewPlusRate},
                            NewGuildInfoMap = maps:put(GuildId, NewGuildInfo, GuildInfoMap),
                            NewState = State#status_gwar_battle{guild_map = NewGuildInfoMap},
                            notify_client_update_info(GuildInfoMap, GuildId, [{1, NewRoleNum}, {3, NewPlusRate}]),
                            {BornX, BornY} = lib_guild_war:get_born_xy(GroupId),
                            Args = [
                                    {group, GroupId},
                                    {action_lock, ?ERRCODE(err402_can_not_change_scene_in_gwar)},
                                    {forbid_pk_etime, StartPkTime},
                                    {change_scene_hp_lim, 1}
                                    ],
                            lib_scene:player_change_scene(RoleId, SceneId, 0, self(), BornX, BornY, true, Args),
                            %% 日志
                            lib_log_api:log_guild_war_scene(RoleId, 1, []),
                            case IsNewJoin of
                                true ->
                                    % 事件触发
                                    CallbackData = #callback_join_act{type = ?MOD_GUILD_ACT, subtype = guild_war},
                                    lib_player_event:async_dispatch(RoleId, ?EVENT_JOIN_ACT, CallbackData),
                                    % %% 触发成就
                                    % lib_achievement_api:async_event(RoleId, lib_achievement_api, guild_war_join_event, 1),
                                    %% 触发任务
                                    lib_task_api:guild_activity(RoleId, ?MOD_GUILD_ACT_GWAR),
                                    %% 公会争霸运营活动
                                    mod_custom_act_gwar:update_join_list(RoleId);
                                _ -> skip
                            end,

                            %% 如果和主宰公会打需要附加士气鼓舞buff
                            #status_dominator{guild_id = DominatorGuildId, streak_times = StreakTimes} = StatusDominator,
                            GuildIds = maps:keys(GuildInfoMap),
                            F = fun(T) -> T =/= GuildId andalso T == DominatorGuildId andalso StreakTimes > 2 end,
                            NeedAddMoraleBuff = lists:any(F, GuildIds),
                            case NeedAddMoraleBuff of
                                true ->
                                    case data_guild_war:get_cfg(gwar_morale_buff) of
                                        BuffGTypeId when BuffGTypeId > 0 ->
                                            BuffEffectList = data_goods:get_effect_list(BuffGTypeId),
                                            case lists:keyfind(attr, 1, BuffEffectList) of
                                                {attr, AttrList} ->
                                                    RealAttrList = [{TAttrId, TAttrVal * StreakTimes}|| {TAttrId, TAttrVal} <- AttrList],
                                                    RealBuffEffectList = lists:keystore(attr, 1, BuffEffectList, {attr, RealAttrList}),
                                                    lib_goods_buff:add_goods_buff(RoleId, BuffGTypeId, 1, [{etime, Etime}, {effect_list, RealBuffEffectList}]);
                                                _ -> skip
                                            end;
                                        _ -> skip
                                    end;
                                false -> skip
                            end;
                        _ -> NewState = State
                    end;
                _ ->
                    lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_gwar_role_num_lim)),
                    NewState = State
            end;
        _ ->
            NewState = State
    end,
    {keep_state, NewState};

do_handle_event(cast, {'exit_scene', GuildId, RoleId}, _, State) ->
    #status_gwar_battle{guild_map = GuildInfoMap} = State,
    case maps:get(GuildId, GuildInfoMap, false) of
        #gwar_guild_info{
            role_num = RoleNum,
            role_map = RoleMap
        } = GuildInfo ->
            SceneId = data_guild_war:get_cfg(scene_id),
            case maps:get(RoleId, RoleMap, false) of
                #gwar_role_info{scene = SceneId} = RoleInfo ->
                    NewRoleNum = max(0, RoleNum - 1),
                    NewRoleMap = maps:put(RoleId, RoleInfo#gwar_role_info{scene = 0}, RoleMap),
                    PlusRatio = data_guild_war:get_cfg(timing_res_plus_ratio),
                    NewPlusRate = round(NewRoleNum * PlusRatio),
                    NewGuildInfo = GuildInfo#gwar_guild_info{role_num = NewRoleNum, role_map = NewRoleMap, plus_rate = NewPlusRate},
                    NewGuildInfoMap = maps:put(GuildId, NewGuildInfo, GuildInfoMap),
                    NewState = State#status_gwar_battle{guild_map = NewGuildInfoMap},
                    notify_client_update_info(GuildInfoMap, GuildId, [{1, NewRoleNum}, {3, NewPlusRate}]),
                    %% 日志
                    lib_log_api:log_guild_war_scene(RoleId, 2, []),
                    Args = [{action_free, ?ERRCODE(err402_can_not_change_scene_in_gwar)}, {forbid_pk_etime, 0}, {change_scene_hp_lim, 1}, {group, 0}],
                    lib_scene:player_change_scene(RoleId, 0, 0, 0, true, Args);
                _ ->
                    lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_no_in_act_scene)),
                    NewState = State
            end;
        _ ->
            NewState = State
    end,
    {keep_state, NewState};

do_handle_event(cast, {'attack_mon', SceneObject}, battle, State) ->
    #scene_object{
        aid = MonAid,
        mon = MonInfo,
        figure = MonFigure,
        battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}
    } = SceneObject,
    #scene_mon{create_key = {guild_war, CreateKeyId}} = MonInfo,
    #status_gwar_battle{guild_map = GuildInfoMap, resource_mon_map = ResourceMonMap} = State,
    case maps:get(CreateKeyId, ResourceMonMap, false) of
        #resource_mon_info{
            hp_ref = ORef,
            guild_id = GuildId
        } = ResMonInfo ->
            util:cancel_timer(ORef),
            %% 资源怪一定时间内未受到攻击自动回满血量
            Time = data_guild_war:get_cfg(mon_restore_af_without_be_attacked),
            NewRef = erlang:send_after(max(1, Time) * 1000, MonAid, {'change_attr', [{restore_hp}]}),
            NewMonInfo = ResMonInfo#resource_mon_info{hp_ref = NewRef},
            NewResourceMonMap = maps:put(CreateKeyId, NewMonInfo, ResourceMonMap),
            case Hp >= HpLim of
                true ->
                    lib_guild_war_mod:send_battle_tv({?TV_TYPE_RES_BE_ATTACKED, GuildId, GuildInfoMap, MonFigure#figure.name});
                false -> skip
            end;
        _ -> NewResourceMonMap = ResourceMonMap
    end,
    NewState = State#status_gwar_battle{resource_mon_map = NewResourceMonMap},
    {keep_state, NewState};

do_handle_event(cast, {'kill_mon', Attacker, SceneObject}, battle, State) ->
    #status_gwar_battle{guild_map = GuildInfoMap, resource_mon_map = ResourceMonMap} = State,
    #battle_return_atter{real_name = AttackerName, guild_id = AttackerGuildId} = Attacker,
    #scene_object{figure = Figure, scene = SceneId, copy_id = CopyId, x = X, y = Y, type = Type, mon = MonInfo} = SceneObject,
    #scene_mon{mid = Mid, create_key = {guild_war, CreateKeyId}} = MonInfo,
    case maps:get(AttackerGuildId, GuildInfoMap, false) of
        #gwar_guild_info{group_id = GroupId, resource_mon_num = ResMonNum} = GuildInfo ->
            case maps:get(CreateKeyId, ResourceMonMap, false) of
                #resource_mon_info{ref = ORef, hp_ref = OHpRef, guild_id = OwnershipGuildId} = ResMonInfo ->
                    util:cancel_timer(ORef),
                    util:cancel_timer(OHpRef),
                    ResPlusCd = data_guild_war:get_cfg(resources_point_plus_cd),
                    NewRef = erlang:send_after(ResPlusCd * 1000, self(), {'add_res_point', CreateKeyId}),
                    NewMonInfo = ResMonInfo#resource_mon_info{ref = NewRef, hp_ref = [], guild_id = AttackerGuildId},
                    NewResourceMonMap = maps:put(CreateKeyId, NewMonInfo, ResourceMonMap),
                    NewGuildInfo = GuildInfo#gwar_guild_info{resource_mon_num = ResMonNum + 1},
                    NewGuildInfoMap = maps:put(AttackerGuildId, NewGuildInfo, GuildInfoMap),
                    %% 如果这只资源怪有公会占领，原占领公会的资源怪数量要-1
                    case maps:get(OwnershipGuildId, NewGuildInfoMap, false) of
                        #gwar_guild_info{resource_mon_num = ResMonNum1} = OwnershipGuildInfo ->
                            NewOwnershipGuildInfo = OwnershipGuildInfo#gwar_guild_info{resource_mon_num = max(0, ResMonNum1 - 1)},
                            notify_client_update_info(NewGuildInfoMap, OwnershipGuildId, [{2, max(0, ResMonNum1 - 1)}]),
                            LastGuildInfoMap = maps:put(OwnershipGuildId, NewOwnershipGuildInfo, NewGuildInfoMap);
                        _ -> LastGuildInfoMap = NewGuildInfoMap
                    end,
                    notify_client_update_info(LastGuildInfoMap, AttackerGuildId, [{2, ResMonNum + 1}]),
                    NewState = State#status_gwar_battle{guild_map = LastGuildInfoMap, resource_mon_map = NewResourceMonMap},
                    lib_guild_war_mod:send_battle_tv({?TV_TYPE_OCCUPY, AttackerName, Figure#figure.name}),
                    SceneId = data_guild_war:get_cfg(scene_id),
                    Args = [{group, GroupId}, {create_key, {guild_war, CreateKeyId}}],
                    lib_mon:async_create_mon(Mid, SceneId, ?GWAR_SCENE_POOL_ID, X, Y, Type, CopyId, 1, Args);
                _ -> NewState = State
            end;
        _ -> NewState = State
    end,
    {keep_state, NewState};

do_handle_event(cast, {'kill_player', GuildId, RoleId, AttackerGuildId, AttackerId, AttackerName}, battle, State) ->
    #status_gwar_battle{guild_map = GuildInfoMap} = State,
    case maps:get(GuildId, GuildInfoMap, false) of
        #gwar_guild_info{role_map = RoleMap} = GuildInfo ->
            %% 被击杀玩家
            case maps:get(RoleId, RoleMap, false) of
                #gwar_role_info{die_num = DieNum} = RoleInfo ->
                    NewRoleInfo = RoleInfo#gwar_role_info{die_num = DieNum + 1, combo = 0},
                    NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap);
                _ -> NewRoleMap = RoleMap
            end,
            NewGuildInfo = GuildInfo#gwar_guild_info{role_map = NewRoleMap},
            NewGuildInfoMap = maps:put(GuildId, NewGuildInfo, GuildInfoMap);
        _ -> NewGuildInfoMap = GuildInfoMap
    end,
    put(reach_max_resource, 0),
    case maps:get(AttackerGuildId, NewGuildInfoMap, false) of
        #gwar_guild_info{resource = Resource, role_map = AttRoleMap} = AttGuildInfo ->
            %% 攻击者
            case maps:get(AttackerId, AttRoleMap, false) of
                #gwar_role_info{scene = Scene, combo = Combo} = AttRoleInfo when Scene > 0 ->
                    ResPlus = data_guild_war:get_cfg(resources_plus_by_kill_player),
                    MaxResource = data_guild_war:get_cfg(max_resource),
                    NewResource = min(Resource + ResPlus, MaxResource),
                    case NewResource >= MaxResource of
                        true ->
                            put(reach_max_resource, 1);
                        false -> skip
                    end,
                    NewCombo = Combo + 1,
                    lib_guild_war_mod:send_battle_tv({?TV_TYPE_COMBO, AttackerName, NewCombo}),
                    NewAttRoleInfo = AttRoleInfo#gwar_role_info{combo = NewCombo},
                    NewAttRoleMap = maps:put(AttackerId, NewAttRoleInfo, AttRoleMap);
                _ ->
                    NewResource = Resource,
                    NewAttRoleMap = AttRoleMap
            end,
            NewAttGuildInfo = AttGuildInfo#gwar_guild_info{resource = NewResource, role_map = NewAttRoleMap},
            LastGuildInfoMap = maps:put(AttackerGuildId, NewAttGuildInfo, NewGuildInfoMap);
        _ -> LastGuildInfoMap = NewGuildInfoMap
    end,
    NewState = State#status_gwar_battle{guild_map = LastGuildInfoMap},
    case erase(reach_max_resource) of
        1 ->
            battle_end(NewState),
            {stop, normal, NewState};
        _ ->
            {keep_state, NewState}
    end;

do_handle_event(cast, {'send_battle_info', _GuildId, RoleId}, _, State) ->
    #status_gwar_battle{start_pk_time = StartPkTime, guild_map = GuildInfoMap} = State,
    GuildInfoList = maps:values(GuildInfoMap),
    F = fun(T) ->
        #gwar_guild_info{
            guild_id = TGuildId,
            guild_name = _TGuildName,
            group_id = TGroupId,
            resource = TResource,
            resource_mon_num = TResMonNum,
            role_num = TRoleNum,
            plus_rate = TPlusRate
        } = T,
        {TGuildId, TGroupId, TRoleNum, TResource, TResMonNum, TPlusRate}
    end,
    List = [F(T) || T <- GuildInfoList, is_record(T, gwar_guild_info)],
    {ok, BinData} = pt_402:write(40247, [StartPkTime, List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {keep_state, State};

do_handle_event(info, {'timing_refresh'}, battle, State) ->
    #status_gwar_battle{res_ref = OResRef, guild_map = GuildInfoMap} = State,
    PlusRatio = data_guild_war:get_cfg(timing_res_plus_ratio),
    MaxResource = data_guild_war:get_cfg(max_resource),
    put(reach_max_resource, 0),
    F = fun(TGuildId, TGuild) ->
        #gwar_guild_info{guild_name = GuildName, resource = Resource, role_num = RoleNum} = TGuild,
        NewResource = min(MaxResource, Resource + RoleNum * PlusRatio),
        case NewResource =/= Resource of
            true ->
                case NewResource >= MaxResource of
                    true ->
                        put(reach_max_resource, 1);
                    false -> skip
                end,
                lib_guild_war_mod:send_battle_tv({?TV_TYPE_RESOURCE, GuildName, Resource, NewResource}),
                notify_client_update_info(GuildInfoMap, TGuildId, [{4, NewResource}]);
            false -> skip
        end,
        TGuild#gwar_guild_info{resource = NewResource}
    end,
    NewGuildInfoMap = maps:map(F, GuildInfoMap),
    ResRef = start_res_ref(OResRef),
    NewState = State#status_gwar_battle{res_ref = ResRef, guild_map = NewGuildInfoMap},
    case erase(reach_max_resource) of
        1 ->
            battle_end(NewState),
            {stop, normal, NewState};
        _ ->
            {keep_state, NewState}
    end;

do_handle_event(info, {'add_res_point', CreateKeyId}, battle, State) ->
    #status_gwar_battle{guild_map = GuildInfoMap, resource_mon_map = ResourceMonMap} = State,
    put(reach_max_resource, 0),
    case maps:get(CreateKeyId, ResourceMonMap, false) of
        #resource_mon_info{ref = ORef, guild_id = GuildId} = ResMonInfo ->
            case maps:get(GuildId, GuildInfoMap, false) of
                #gwar_guild_info{guild_name = GuildName, resource = Resource} = GuildInfo ->
                    ResPlus = data_guild_war:get_cfg(resources_plus_by_mon),
                    MaxResource = data_guild_war:get_cfg(max_resource),
                    NewResource = min(Resource + ResPlus, MaxResource),
                    case NewResource >= MaxResource of
                        true ->
                            put(reach_max_resource, 1);
                        false -> skip
                    end,
                    NewGuildInfo = GuildInfo#gwar_guild_info{resource = NewResource},
                    NewGuildInfoMap = maps:put(GuildId, NewGuildInfo, GuildInfoMap),
                    util:cancel_timer(ORef),
                    ResPlusCd = data_guild_war:get_cfg(resources_point_plus_cd),
                    NewRef = erlang:send_after(max(1, ResPlusCd) * 1000, self(), {'add_res_point', CreateKeyId}),
                    NewMonInfo = ResMonInfo#resource_mon_info{ref = NewRef},
                    NewResourceMonMap = maps:put(CreateKeyId, NewMonInfo, ResourceMonMap),
                    lib_guild_war_mod:send_battle_tv({?TV_TYPE_RESOURCE, GuildName, Resource, NewResource}),
                    notify_client_update_info(GuildInfoMap, GuildId, [{4, NewResource}]),
                    NewState = State#status_gwar_battle{guild_map = NewGuildInfoMap, resource_mon_map = NewResourceMonMap};
                _ -> NewState = State
            end;
        _ -> NewState = State
    end,
    case erase(reach_max_resource) of
        1 ->
            battle_end(NewState),
            {stop, normal, NewState};
        _ ->
            {keep_state, NewState}
    end;

do_handle_event(info, 'time_out', ready, State) ->
    #status_gwar_battle{ref = ORef, res_ref = OResRef, etime = Etime} = State,
    util:cancel_timer(ORef),
    CountDownTime = Etime - utime:unixtime(),
    %% 提前0.5s结算，让数据有时间同步到活动进程
    Ref = erlang:send_after(CountDownTime * 1000 - 500, self(), 'time_out'),
    ResRef = start_res_ref(OResRef),
    NewState = State#status_gwar_battle{ref = Ref, res_ref = ResRef},
    {next_state, battle, NewState};

do_handle_event(info, 'time_out', battle, State) ->
    battle_end(State),
    {stop, normal, State};

do_handle_event(_Type, _Msg, StateName, State) ->
    % ?ERR("no match :~p~n", [[_Type, _Msg, StateName]]),
    {next_state, StateName, State}.

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, Status, _Extra) ->
    {ok, StateName, Status}.

init_mon() ->
    SceneId = data_guild_war:get_cfg(scene_id),
    #ets_scene{mon = Mon} = Scene = data_scene:get(SceneId),
    do_init_mon(Mon, Scene, ?GWAR_SCENE_POOL_ID, self(), 0, #{}).

do_init_mon([[MonId, X, Y, Type, _Group] | T], #ets_scene{id = SceneId} = Scene, PoolId, CopyId, Broadcast, ResourceMonMap) ->
    case data_mon:get(MonId) of
        #mon{kind = Kind, lv = Lv} ->
            CreateKeyId = lib_guild_war:get_mon_create_key_id(),
            NewResourceMonMap = ResourceMonMap#{CreateKeyId => #resource_mon_info{id = CreateKeyId}},
            lib_mon:async_create_mon(MonId, SceneId, PoolId, X, Y, Type, CopyId, Broadcast, [{group, 0}, {create_key, {guild_war, CreateKeyId}}]),
            mod_scene_mon:insert(#ets_scene_mon{id = MonId, x = X, y = Y, scene = SceneId, kind = Kind, lv = Lv});
        _ ->
            NewResourceMonMap = ResourceMonMap
    end,
    do_init_mon(T, Scene, PoolId, CopyId, Broadcast, NewResourceMonMap);
do_init_mon([H|T], #ets_scene{id = SceneId} = Scene, PoolId, CopyId, Broadcast, ResourceMonMap) ->
    ?ERR("scene mon format error scene_id = ~p mon = ~p~n", [SceneId, H]),
    do_init_mon(T, Scene, PoolId, CopyId, Broadcast, ResourceMonMap);
do_init_mon([], _, _, _, _, ResourceMonMap) -> ResourceMonMap.

%% 开启定时器定时根据在场人数增加双方的资源值
start_res_ref(ORef) ->
    util:cancel_timer(ORef),
    Time = data_guild_war:get_cfg(timing_refresh),
    erlang:send_after(Time * 1000, self(), {'timing_refresh'}).

%% 通知客户端更新战斗面板信息
notify_client_update_info(GuildMap, UpdateGuildId, UpdateList) ->
    GuildList = maps:values(GuildMap),
    {ok, BinData} = pt_402:write(40248, [UpdateGuildId, UpdateList]),
    do_notify_client_update_info(GuildList, BinData).

do_notify_client_update_info([], _) -> ok;
do_notify_client_update_info([T|L], BinData) ->
    case T of
        #gwar_guild_info{role_map = RoleMap} ->
            RoleList = maps:values(RoleMap),
            do_notify_client_update_info_core(RoleList, BinData);
        _ -> skip
    end,
    do_notify_client_update_info(L, BinData).

do_notify_client_update_info_core([], _) -> ok;
do_notify_client_update_info_core([T|L], BinData) ->
    case T of
        #gwar_role_info{role_id = RoleId, scene = Scene} when Scene > 0 ->
            lib_server_send:send_to_uid(RoleId, BinData);
        _ -> skip
    end,
    do_notify_client_update_info_core(L, BinData).

%% 计算获胜者
count_winner(GuildList) ->
    F = fun(A, B) ->
        case A#gwar_guild_info.resource == B#gwar_guild_info.resource of
            true ->
                case A#gwar_guild_info.resource_mon_num == B#gwar_guild_info.resource_mon_num of
                    true ->
                        case A#gwar_guild_info.combat_power == B#gwar_guild_info.combat_power of
                            true ->
                                case A#gwar_guild_info.role_num == B#gwar_guild_info.role_num of
                                    true ->
                                        WinnerGroupId = urand:rand(?GROUP_RED, ?GROUP_BLUE),
                                        ?IF(WinnerGroupId == A#gwar_guild_info.group_id, true, false);
                                    false ->
                                        A#gwar_guild_info.role_num > B#gwar_guild_info.role_num
                                end;
                            false ->
                                A#gwar_guild_info.combat_power > B#gwar_guild_info.combat_power
                        end;
                    false ->
                        A#gwar_guild_info.resource_mon_num > B#gwar_guild_info.resource_mon_num
                end;
            false ->
                A#gwar_guild_info.resource > B#gwar_guild_info.resource
        end
    end,
    [Winner|_] = lists:sort(F, GuildList),
    Winner.

%% 发送胜利者奖励
send_winner_reward(Winner, Division, WorldLv, Round) ->
    #gwar_guild_info{role_map = RoleMap} = Winner,
    RoleList = maps:values(RoleMap),
    Exp = 0,
    Donate = 0,
    %% 此处修改了奖励逻辑要同时修改log_battle接口
    Reward = data_guild_war:get_battle_victory_reward(WorldLv, Division, Round),
    % LastReward = [{?TYPE_GDONATE, ?GOODS_ID_GDONATE, Donate}|Reward],
    do_send_reward(RoleList, 1, Exp, Donate, Reward, Reward).

do_send_reward([], _, _, _, _, _) -> ok;
do_send_reward([T|L], Result, Exp, Donate, Reward, LastReward) ->
    #gwar_role_info{role_id = RoleId, scene = SceneId} = T,

    case SceneId > 0 of
        true ->
            Produce = #produce{title = utext:get(245), content = utext:get(246), reward = LastReward, type = guild_war_reward, show_tips = 1},
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            %% 重置玩家相关数据并把玩家踢出场景
            Args = [{action_free, ?ERRCODE(err402_can_not_change_scene_in_gwar)}, {forbid_pk_etime, 0}, {change_scene_hp_lim, 1}, {group, 0}],
            lib_scene:player_change_scene(RoleId, 0, 0, 0, true, Args),

            %% 日志
            lib_log_api:log_guild_war_scene(RoleId, 3, LastReward),

            {ok, BinData} = pt_402:write(40249, [Result, Exp, Donate, Reward]),
            lib_server_send:send_to_uid(RoleId, BinData);
        false -> skip
    end,

    do_send_reward(L, Result, Exp, Donate, Reward, LastReward).

%% 发送失败者奖励
send_loser_reward(GuildList, Winner, Division, WorldLv, Round) ->
    Exp = 0,
    Donate = 0,
    Reward = data_guild_war:get_battle_failure_reward(WorldLv, Division, Round),
    % LastReward = [{?TYPE_GDONATE, ?GOODS_ID_GDONATE, Donate}|Reward],
    do_send_loser_reward(GuildList, Winner, Exp, Donate, Reward, Reward).

do_send_loser_reward([], _, _, _, _, _) -> ok;
do_send_loser_reward([T|L], Winner, Exp, Donate, Reward, LastReward) ->
    #gwar_guild_info{guild_id = WinnerId} = Winner,
    case T of
        #gwar_guild_info{guild_id = WinnerId} -> skip;
        #gwar_guild_info{role_map = RoleMap} ->
            RoleList = maps:values(RoleMap),
            spawn(fun() ->
                do_send_reward(RoleList, 2, Exp, Donate, Reward, LastReward)
            end)
    end,
    do_send_loser_reward(L, Winner, Exp, Donate, Reward, LastReward).

battle_end(State) ->
    #status_gwar_battle{
        ref = ORef,
        res_ref = ResRef,
        division = Division,
        round = Round,
        room_id = RoomId,
        guild_map = GuildMap,
        resource_mon_map = ResMonMap
    } = State,
    %% 取消定时器
    util:cancel_timer(ORef),
    util:cancel_timer(ResRef),
    ResMonList = maps:values(ResMonMap),
    F = fun(T) ->
        util:cancel_timer(T#resource_mon_info.ref),
        util:cancel_timer(T#resource_mon_info.hp_ref)
    end,
    lists:foreach(F, ResMonList),

    %% 移除怪物
    SceneId = data_guild_war:get_cfg(scene_id),
    lib_mon:clear_scene_mon(SceneId, ?GWAR_SCENE_POOL_ID, self(), 0),

    GuildList = maps:values(GuildMap),
    Winner = count_winner(GuildList),
    WorldLv = util:get_world_lv(),

    spawn(fun() -> log_battle(GuildList, Division, Round, Winner, WorldLv) end),

    send_winner_reward(Winner, Division, WorldLv, Round),
    send_loser_reward(GuildList, Winner, Division, WorldLv, Round),

    mod_guild_war:sync_battle_result(Division, RoomId, Winner#gwar_guild_info.guild_id).

log_battle([AGuild], Division, Round, _Winner, WorldLv) ->
    case AGuild of
        #gwar_guild_info{group_id = ?GROUP_RED} ->
            #gwar_guild_info{guild_id = RedGid, guild_name = RedGName} = AGuild,
            BlueGid = 0, BlueGName = <<>>;
        _ ->
            RedGid = 0, RedGName = <<>>,
            #gwar_guild_info{guild_id = BlueGid, guild_name = BlueGName} = AGuild
    end,
    WinnerGroup = AGuild#gwar_guild_info.group_id,
    WinnerReward = data_guild_war:get_battle_victory_reward(WorldLv, Division, Round),
    LoserReward = data_guild_war:get_battle_failure_reward(WorldLv, Division, Round),
    lib_log_api:log_guild_war_battle(RedGid, RedGName, BlueGid, BlueGName, Round, WinnerGroup, WinnerReward, LoserReward);
log_battle([AGuild, BGuild], Division, Round, Winner, WorldLv) ->
    %% 日志
    case AGuild of
        #gwar_guild_info{group_id = ?GROUP_RED} ->
            #gwar_guild_info{guild_id = RedGid, guild_name = RedGName} = AGuild,
            #gwar_guild_info{guild_id = BlueGid, guild_name = BlueGName} = BGuild;
        _ ->
            #gwar_guild_info{guild_id = RedGid, guild_name = RedGName} = BGuild,
            #gwar_guild_info{guild_id = BlueGid, guild_name = BlueGName} = AGuild
    end,
    WinnerGroup = ?IF(AGuild#gwar_guild_info.guild_id == Winner#gwar_guild_info.guild_id, AGuild#gwar_guild_info.group_id, BGuild#gwar_guild_info.group_id),
    WinnerReward = data_guild_war:get_battle_victory_reward(WorldLv, Division, Round),
    LoserReward = data_guild_war:get_battle_failure_reward(WorldLv, Division, Round),
    lib_log_api:log_guild_war_battle(RedGid, RedGName, BlueGid, BlueGName, Round, WinnerGroup, WinnerReward, LoserReward);
log_battle(_, _, _, _, _) -> skip.
