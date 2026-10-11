%%%-------------------------------------------------------------------
%%% @author lianghaihui
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% 跨服秘境Boss - 跨服节点API的主要逻辑
%%% @end
%%% Created : 19. 11月 2022 15:37
%%%-------------------------------------------------------------------
-module(lib_great_demon).

-include("def_gen_server.hrl").
-include("kf_great_demon.hrl").
-include("boss.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("battle.hrl").
-include("drop.hrl").
-include("figure.hrl").
-include("domain.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("predefine.hrl").

%% API
-compile(export_all).

%% 开始分区
start_zone_change(State) ->
    #kf_great_demon_state{ boss_state_map = BossStateMap, role_map = RoleMap } = State,
    %% 首先清除场景内的怪物
    clear_all_scene_boss(BossStateMap),
    %% 清除场景内的玩家
    leave_scene_force(RoleMap),
    %% 同步分服状态到各个游戏节点
    mod_clusters_center:apply_to_all_node(mod_great_demon_local, start_zone_change, [], 100),
    #kf_great_demon_state{ is_grouping = ?IN_GROUPING }.

leave_scene_force(RoleMap) ->
    F = fun(_, Role, Acc) ->
        #kf_role_info{role_id = RoleId, server_id = ServerId} = Role,
        mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
            [RoleId, 0, 0, 0, 0, 0, true, [{collect_checker, undefined}]]),
        Acc
    end,
    maps:fold(F, 0, RoleMap).

%% 游戏节点连上跨服中心时同步数据到游戏节点
sync_server_data_to_game(ServerId, OpenTime, State) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    case util:check_open_day_2(4, OpenTime) andalso ZoneId > 0 of
        true ->
            #kf_great_demon_state{ boss_state_map = BossStateMap, is_grouping = IsGrouping } = State,
            case get_all_boss_state_by_zone(ZoneId, BossStateMap) of
                {ok, ZoneBossMap, NewAllZoneBossMap} ->
                    mod_clusters_center:apply_cast(ServerId, mod_great_demon_local, sync_kf_server_data, [ZoneBossMap, IsGrouping]),
                    State#kf_great_demon_state{ boss_state_map = NewAllZoneBossMap};
                _ ->
                    State
            end;
        _ -> State
    end.

%% 游戏节点请求玩法数据
game_req_server_data(ServerId, State) ->
    #kf_great_demon_state{
        is_grouping = IsGrouping, boss_state_map = AllZoneBossMap
    } = State,
    case State == ?IN_GROUPING of
        true ->
            mod_clusters_center:apply_cast(ServerId, mod_great_demon_local, sync_kf_server_data, [#{}, IsGrouping]),
            State;
        _ ->
            ZoneId = lib_clusters_center_api:get_zone(ServerId),
            case get_all_boss_state_by_zone(ZoneId, AllZoneBossMap) of
                {ok, ZoneBossMap, NewAllZoneBossMap} ->
                    Args = [ZoneBossMap, IsGrouping],
                    mod_clusters_center:apply_cast(ServerId, mod_great_demon_local, sync_kf_server_data, Args),
                    State#kf_great_demon_state{ boss_state_map = NewAllZoneBossMap};
                _ ->
                    State
            end
    end.

%% 怪物被击杀或采集怪被采集
great_demon_boss_be_kill(Args, State) ->
    [SceneId, PoolId, BossId, AttackServerId, Attacker, BelongWho, MonArgs, SceneObjectInfo, FirstAttr|_] = Args,
    #kf_great_demon_state{
        boss_state_map = AllZoneBossMap, role_map = RoleInfoMap
    } = State,
    ZoneId = lib_clusters_center_api:get_zone(AttackServerId),
    case maps:get(ZoneId, AllZoneBossMap, none) of
        none ->
            State;
        ZoneBossMap ->
            #great_demon_boss_info{mon_type = MonType } = data_kf_great_demon:get_great_demon_boss_cfg(BossId),
            case maps:get(BossId, ZoneBossMap, none) of
                none ->
                    State;
                #great_demon_boss_status{ boss_id = BossId } = BossInfo ->
                    #battle_return_atter{
                        id = AttrRoleId, name = AttrRoleName, server_name = ServerName
                    } = Attacker,
                    if
                        AttackServerId == 0 ->
                            ?ERR("AttrId:~p~n", [[AttrRoleId, BossId, SceneId, PoolId, MonType]]),
                            mod_player_create:get_serid_by_id(AttrRoleId);
                        true ->
                            AttackServerId
                    end,
                    DoKillArgs = [ZoneId, PoolId, MonType, BossId, MonArgs, BossInfo, ZoneBossMap,
                        Attacker, FirstAttr, RoleInfoMap, BelongWho, SceneObjectInfo],
                    {NewZoneBossMap, NewBoss} =
                        case MonType of
                            ?NORMAL_GREAT_DEMON ->
                                great_demon_boss_be_kill(DoKillArgs);
                            _ ->
                                collect_or_kill_special_boss(DoKillArgs)
                        end,
                    %% 击杀一个怪物, 随机计算特殊怪的生成的数量
                    TemState = State#kf_great_demon_state{ boss_state_map = maps:put(ZoneId, NewZoneBossMap, AllZoneBossMap)},
                    {NewState, AddBossList} = create_great_demon_special_boss(ZoneId, PoolId, BossId, NewZoneBossMap, TemState),
                    %% 通知怪物击杀事件等
                    BlRoleIds = [Bl#mon_atter.id || Bl <- BelongWho],
                    KillArgs = [?BOSS_TYPE_KF_GREAT_DEMON, BossId, NewBoss, AttrRoleId, AttrRoleName, ServerName, AddBossList, BlRoleIds],
                    mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_great_demon_local, sync_boss_kill_and_log, [KillArgs]),
                    NewState
            end
    end.

%% 通知倒计时
great_demon_boss_remind(ZoneId, BossId, State) ->
    #kf_great_demon_state{
        boss_state_map = AllZoneBossMap
    } = State,
    ZoneBossMap = maps:get(ZoneId, AllZoneBossMap, none),
    case ZoneBossMap of
        none ->
            State;
        _ ->
            case maps:get(BossId, ZoneBossMap, none) of
                none -> State;
                #great_demon_boss_status{ remind_ref = RemindRef } = BossStatus ->
                    util:cancel_timer(RemindRef),
                    %% 通知各个分区重生信息
                    mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_great_demon_local, great_demon_boss_remind, [BossId]),
                    NewBossStatus = BossStatus#great_demon_boss_status{ remind_ref = undefined },
                    NewZoneBossMap = maps:put(BossId, NewBossStatus, ZoneBossMap),
                    NewAllZoneBossMap = maps:put(ZoneId, NewZoneBossMap, AllZoneBossMap),
                    State#kf_great_demon_state{ boss_state_map = NewAllZoneBossMap }
            end
    end.


%% 玩家进入场景
enter(KfRoleInfo, BossType, BossId, Scene, X, Y, NeedOut, State) ->
    #kf_great_demon_state{
        role_map = RoleMap, scene_num = SceneZoneMap, is_grouping = IsGrouping
    } = State,
    #kf_role_info{
        role_id = RoleId, server_id = ServerId, node = Node
    } = KfRoleInfo,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    Result = if
                 IsGrouping == ?IN_GROUPING ->
                     {false, ?ERRCODE(err470_is_resetting)};
                 ZoneId == 0 ->
                     {false, ?ERRCODE(err470_no_zone)};
                 true -> true
             end,
    case Result of
        {false, ErrorCode} ->
            {ok, Bin} = pt_460:write(46003, [ErrorCode]),
            lib_clusters_center:send_to_uid(Node, RoleId, Bin),
            State;
        _ ->
            %% 分区里面的某个场景的人数
            SceneNum = maps:get({ZoneId, Scene}, SceneZoneMap, 0),
            case data_scene_other:get(Scene) of
                #ets_scene_other{room_max_people = MaxNum}  -> ok;
                _ -> MaxNum = 100
            end,
            if
                SceneNum >= MaxNum ->
                    {ok, Bin} = pt_470:write(46003, [?ERRCODE(err120_max_user)]),
                    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]),
                    State;
                true ->
                    PoolId = get_pool_id(ZoneId),
                    case maps:get({ZoneId, RoleId}, RoleMap, none) of
                        #kf_role_info{scene = OldScene} when OldScene == Scene ->
                            NewSceneNum = SceneNum;
                        _ ->
                            NewSceneNum = SceneNum + 1
                    end,
                    NewSceneZoneMap = maps:put({ZoneId, Scene}, NewSceneNum, SceneZoneMap),
                    NewKfRoleInfo = KfRoleInfo#kf_role_info{node = Node, scene = Scene},
                    NewRolesZoneMap = maps:put({ZoneId, RoleId}, NewKfRoleInfo, RoleMap),
                    %%
                    CheckerArgs = {lib_great_demon_local, check_collect_times, [RoleId, BossType, BossId]},
                    mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene,
                        [RoleId, Scene, PoolId, ZoneId, X, Y, NeedOut, [{group, 0}, {collect_checker, CheckerArgs}]]),
                    send_collect_boss_info(ZoneId, ServerId, RoleId, BossId, State),
                    State#kf_great_demon_state{
                        role_map = NewRolesZoneMap, scene_num = NewSceneZoneMap
                    }
            end
    end.

%% 发送场景内采集类的怪物信息给玩家
send_collect_boss_info(ZoneId, ServerId, RoleId, BossId, State) ->
    #kf_great_demon_state{
        boss_state_map = AllZoneBossMap
    } = State,
    case get_all_boss_state_by_zone(ZoneId, AllZoneBossMap) of
        {ok, ZoneBossMap, _NewAllZoneBossMap} ->
            Fun = fun(TemBossId, #great_demon_boss_status{ mon_type = MonType, xy = XyList}, AccList) ->
                case MonType of
                    ?NORMAL_TREASURE_CHEST ->
                        [{TemBossId, XyList} | AccList];
                    ?ADVANCED_TREASURE_CHEST ->
                        [{TemBossId, XyList} | AccList];
                    ?SPECIAL_GREAT_DEMON ->
                        [{TemBossId, XyList} | AccList];
                    _ ->
                        AccList
                end
            end,
            SendList = maps:fold(Fun, [], ZoneBossMap),
            {ok, Bin} = pt_460:write(46039, [SendList]),
            mod_clusters_center:apply_cast(ServerId, lib_great_demon_api, handle_enter_success, [RoleId, BossId, Bin]);
        _ ->
            ok
    end.

quit(Node, RoleId, Scene, ServerId, State) ->
    #kf_great_demon_state{
        role_map = RoleInfoMap, scene_num = SceneMap
    } = State,
    case lib_clusters_center_api:get_zone(ServerId) of
        0 ->
            NewRoleInfoMap = RoleInfoMap,
            NewSceneMap = SceneMap;
        ZoneId ->
            case maps:get({ZoneId, RoleId}, RoleInfoMap, none) of
                none ->
                    NewRoleInfoMap = RoleInfoMap,
                    NewSceneMap = SceneMap;
                #kf_role_info{ } ->
                    SceneNum = maps:get({ZoneId, Scene}, SceneMap, 0),
                    NewSceneNum = max(SceneNum - 1, 0),
                    NewRoleInfoMap = maps:remove({ZoneId, RoleId}, RoleInfoMap),
                    NewSceneMap = maps:put({ZoneId, Scene}, NewSceneNum, SceneMap)
            end
    end,
    mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene, [RoleId, 0, 0, 0, 0, 0, true,
        [{collect_checker, undefined}, {pk, {?PK_PEACE, true}}, {change_scene_hp_lim, 100}, {group, 0}]]),
    State#kf_great_demon_state{
        role_map = NewRoleInfoMap, scene_num = NewSceneMap
    }.

%% 清理玩家数据
exit_great_demon(RoleId, Scene, ServerId, State) ->
    #kf_great_demon_state{
        role_map = RoleInfoMap, scene_num = SceneMap
    } = State,
    case lib_clusters_center_api:get_zone(ServerId) of
        0 ->
            NewRoleInfoMap = RoleInfoMap,
            NewSceneMap = SceneMap;
        ZoneId ->
            case maps:get({ZoneId, RoleId}, RoleInfoMap, none) of
                none ->
                    NewRoleInfoMap = RoleInfoMap,
                    NewSceneMap = SceneMap;
                #kf_role_info{ } ->
                    SceneNum = maps:get({ZoneId, Scene}, SceneMap, 0),
                    NewSceneNum = max(SceneNum - 1, 0),
                    NewRoleInfoMap = maps:remove({ZoneId, RoleId}, RoleInfoMap),
                    NewSceneMap = maps:put({ZoneId, Scene}, NewSceneNum, SceneMap)
            end
    end,
    State#kf_great_demon_state{
        role_map = NewRoleInfoMap, scene_num = NewSceneMap
    }.

%%%===================================================================
%%% Internal functions
%%%===================================================================

get_pool_id(ZoneId) ->
    ZoneId rem 12 + 1.

%% 清除所有景内的怪物
clear_all_scene_boss(BossStateMap) ->
    SceneList = data_eudemons_land:get_eudemons_boss_type_scene(?BOSS_TYPE_KF_GREAT_DEMON),
    Fun = fun(ZoneId, BossMap, Acc) ->
        CancelFun = fun(_BossId, #great_demon_boss_status{remind_ref = RemindRef, reborn_ref = RebornRef}) ->
            util:cancel_timer(RemindRef),
            util:cancel_timer(RebornRef)
        end,
        maps:map(CancelFun, BossMap),
        PoolId = get_pool_id(ZoneId),
        [PoolId|lists:delete(PoolId, Acc)]
    end,
    PoolList = maps:fold(Fun, [], BossStateMap),
    [lib_scene:clear_scene(SceneId, PoolId) || SceneId <- SceneList, PoolId <- PoolList].

%% 获取区域的怪物信息(没有时则执行初始化)
get_all_boss_state_by_zone(ZoneId, BossStateMap) ->
    case maps:get(ZoneId, BossStateMap, none) of
        none ->
            %% 当前游戏节点对应的区还没有初始化怪物信息等
            ZoneBossMap = init_boss_and_scene(ZoneId),
            NewBossStateMap = maps:put(ZoneId, ZoneBossMap, BossStateMap),
            {ok, ZoneBossMap, NewBossStateMap};
        ZoneBossMap ->
            {ok, ZoneBossMap, BossStateMap}
    end.

%% 初始化某个区服的怪物和场景等
init_boss_and_scene(ZoneId) ->
    NowTime = utime:unixtime(),
    PoolId = get_pool_id(ZoneId),
    AllBossIds = data_kf_great_demon:get_all_great_demon_boss_id(),
    Fun = fun(BossId, TemBossMap) ->
        #great_demon_boss_info{
            boss_id = BossId, mon_type = MonType, scene = SceneId
        } = BossCfg = data_kf_great_demon:get_great_demon_boss_cfg(BossId),
        case MonType of
            ?NORMAL_TREASURE_CHEST ->
                BossInfo = do_pick_boss_reborn(ZoneId, PoolId, 0, BossCfg, [], NowTime);
            ?ADVANCED_TREASURE_CHEST ->
                BossInfo = do_pick_boss_reborn(ZoneId, PoolId, 0, BossCfg, [], NowTime);
            ?SPECIAL_GREAT_DEMON ->
                BossInfo = #great_demon_boss_status{ boss_id = BossId };
            _->
                lib_mon:clear_scene_mon_by_mids(SceneId, PoolId, ZoneId, 1, [BossId]),
                BossInfo = do_great_demon_boss_reborn(ZoneId, PoolId, NowTime, BossCfg, 0)
        end,
        TemBossMap#{ BossId => BossInfo}
    end,
    lists:foldl(Fun, #{}, AllBossIds).


great_demon_boss_reborn(ZoneId, MonType, BossId, State) ->
    #great_demon_boss_info{
        boss_id = BossId, mon_type = MonType, scene = SceneId
    } = BossCfg = data_kf_great_demon:get_great_demon_boss_cfg(BossId),
    #kf_great_demon_state{
        boss_state_map = AllZoneBossMap
    } = State,
    ZoneBossMap = maps:get(ZoneId, AllZoneBossMap, none),
    case ZoneBossMap of
        none ->
            State;
        _ ->
            case maps:get(BossId, ZoneBossMap, none) of
                none ->
                    State;
                #great_demon_boss_status{ }->
                    PoolId = get_pool_id(ZoneId),
                    lib_mon:clear_scene_mon_by_mids(SceneId, PoolId, ZoneId, 1, [BossId]),
                    BossInfo = do_great_demon_boss_reborn(ZoneId, PoolId, utime:unixtime(), BossCfg, 0),
                    NewZoneBossMap = maps:put(BossId, BossInfo, ZoneBossMap),
                    NewAllZoneBossMap = maps:put(ZoneId, NewZoneBossMap, AllZoneBossMap),
                    State#kf_great_demon_state{
                        boss_state_map = NewAllZoneBossMap
                    }
            end
    end.

%% boss初始化或重生
do_great_demon_boss_reborn(ZoneId, PoolId, NowTime, BossCfg, RebornTime)->
    #great_demon_boss_info{
        boss_id = BossId, mon_type = MonType, scene = SceneId, x = X, y = Y
    } = BossCfg,
    LessRebornTime = max(0, RebornTime - NowTime),
    if
        LessRebornTime > 0 ->
            %% 还没到复活时间,设置通知定时器与复活定时器
            RemindTime = max(1, LessRebornTime),
            case RemindTime > 0 andalso MonType =/= ?NORMAL_TREASURE_CHEST andalso MonType =/= ?ADVANCED_TREASURE_CHEST of
                true ->
                    RemindRef = erlang:send_after(RemindTime * 1000, self(), {'great_demon_boss_remind', ZoneId, BossId});
                _ ->
                    %% 宝箱类的怪物不通知
                    RemindRef = undefined
            end,
            RebornRef = erlang:send_after(LessRebornTime * 1000, self(),  {'great_demon_boss_reborn', ZoneId, MonType, BossId}),
            SyncBossInfo = #great_demon_boss_status{ boss_id = BossId, num = 1, reborn_time = RebornTime,
                remind_ref = RemindRef, reborn_ref = RebornRef};
        true ->
            lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, SceneId, PoolId, X, Y, 1, ZoneId, 1, []),
            %% 广播boss|采集怪物重生信息
            {ok, Bin} = pt_460:write(46008, [?BOSS_TYPE_KF_GREAT_DEMON, BossId]),
            lib_server_send:send_to_scene(SceneId, PoolId, ZoneId, Bin),
            SyncBossInfo = #great_demon_boss_status{boss_id = BossId, num = 1, mon_type = MonType}
    end,
    %% 同步信息到对应的分区
    mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_great_demon_local, sync_boss_reborn_list, [[SyncBossInfo]]),
    SyncBossInfo.

pick_boss_reborn(ZoneId, MonType, BossId, State) ->
    case MonType == ?NORMAL_TREASURE_CHEST orelse MonType == ?ADVANCED_TREASURE_CHEST of
        true ->
            BossCfg = data_kf_great_demon:get_great_demon_boss_cfg(BossId),
            #kf_great_demon_state{
                boss_state_map = AllZoneBossMap
            } = State,
            ZoneBossMap = maps:get(ZoneId, AllZoneBossMap, none),
            PoolId = get_pool_id(ZoneId),
            case maps:get(BossId, ZoneBossMap, none) of
                none ->
                    State;
                #great_demon_boss_status{ xy = XyList}->
                    PoolId = get_pool_id(ZoneId),
                    BossInfo = do_pick_boss_reborn(ZoneId, PoolId, 0, BossCfg, XyList, utime:unixtime()),
                    NewZoneBossMap = maps:put(BossId, BossInfo, ZoneBossMap),
                    NewAllZoneBossMap = maps:put(ZoneId, NewZoneBossMap, AllZoneBossMap),
                    State#kf_great_demon_state{
                        boss_state_map = NewAllZoneBossMap
                    }
            end;
        _ ->
            State
    end.

%% 怪物的生成
do_pick_boss_reborn(ZoneId, PoolId, RebornTime, BossCfg, XYList, NowSec) ->
    #great_demon_boss_info{
        boss_id = BossId, mon_type = MonType, scene = SceneId, num = Num, reborn_time = RebornTimeCfg, rand_xy = RandXYL
    } = BossCfg,
    LessRebornTime = max(0, RebornTime - NowSec),
    case LessRebornTime > 0 of
        true ->
            NewRebornTime = RebornTime,
            RefTime = LessRebornTime;
        false ->
            NewRebornTime = RebornTimeCfg + NowSec,
            RefTime = RebornTimeCfg
    end,
    NewRebornRef = erlang:send_after(RefTime * 1000, self(), {'pick_boss_reborn', ZoneId, MonType, BossId}),
    %% 去除已经存在的采集怪数量等
    CreateNum = max(0, Num - length(XYList)),
    case CreateNum > 0 of
        true ->
            NewRandXy = ulists:list_shuffle(RandXYL),
            LastRandXy = NewRandXy -- XYList,
            Fun = fun(_Seq, {TemXyList, PosList}) ->
                [{X1, Y1}|LessXyList] = TemXyList,
                lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, SceneId, PoolId, X1, Y1, 1, ZoneId, 1, []),
                {LessXyList, [{X1, Y1} | PosList]}
            end,
            {_, NewPosList} = lists:foldl(Fun, {LastRandXy, XYList}, lists:seq(1, CreateNum)),
            %% 广播boss|采集怪物重生信息
            {ok, Bin} = pt_460:write(46009, [?BOSS_TYPE_KF_GREAT_DEMON, BossId, NewRebornTime, Num]),
            %% 广播采集怪坐标信息
            {ok, Bin2} = pt_460:write(46036, [BossId, NewPosList]),
            lib_server_send:send_to_scene(SceneId, PoolId, ZoneId, Bin),
            lib_server_send:send_to_scene(SceneId, PoolId, ZoneId, Bin2),
            lib_mon:get_scene_mon(SceneId, PoolId, ZoneId, [#scene_object.config_id]),
            SyncBossInfo = #great_demon_boss_status{
                boss_id = BossId, reborn_time = NewRebornTime, xy = NewPosList,
                mon_type = MonType, reborn_ref = NewRebornRef
            };
        _ ->
            SyncBossInfo = #great_demon_boss_status{
                boss_id = BossId, reborn_time = NewRebornTime, xy = XYList,
                mon_type = MonType, reborn_ref = NewRebornRef
            }
    end,
    mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_great_demon_local, sync_boss_reborn_list, [[SyncBossInfo]]),
    SyncBossInfo.

%% 击杀普通的大妖
great_demon_boss_be_kill(Args) ->
    [ZoneId, PoolId, MonType, BossId, _MonArgs, BossInfo, ZoneBossMap,
        Attacker, _FirstAttr, RoleInfoMap, BelongWhos, SceneObjectInfo|_] = Args,
    #battle_return_atter{
        id = AttrRoleId, real_name = AttrRoleName
    } = Attacker,
    #great_demon_boss_status{
        boss_id = BossId, num = Num, reborn_ref = RebornRef, remind_ref = RemindRef
    } = BossInfo,
    #great_demon_boss_info{
        scene = SceneId, reborn_time = CfgRebornTime
    } = data_kf_great_demon:get_great_demon_boss_cfg(BossId),
    NowSec = utime:unixtime(),
    %% 更新各种定时器
    util:cancel_timer(RemindRef),
    util:cancel_timer(RebornRef),
    LastRebornTime = NowSec + CfgRebornTime,
    NewRebornRef = erlang:send_after(CfgRebornTime * 1000, self(), {'great_demon_boss_reborn', ZoneId, MonType, BossId}),
    
    RemindTime = max(0, CfgRebornTime - ?REMIND_TIME),
    case RemindTime =< 0 of
        true ->
            NewRemindRef = undefined;
        _ ->
            NewRemindRef = erlang:send_after(RemindTime * 100, self(), {'great_demon_boss_remind', ZoneId, BossId})
    end,
    %% 广播击杀BOSS的信息
    {ok, BinData} = pt_460:write(46009, [?BOSS_TYPE_KF_GREAT_DEMON, BossId, LastRebornTime, max(0, Num - 1)]),
    lib_server_send:send_to_scene(SceneId, PoolId, ZoneId, BinData),
    %% 记录击杀日志
    BeRoleIdL = [{RoleId, ServerId} || #mon_atter{id = RoleId, server_id = ServerId} <- BelongWhos],
    spawn(fun() ->
        lib_great_demon_sql:log_great_demon_boss_kf(ZoneId, BossId, AttrRoleId, AttrRoleName, BeRoleIdL, RoleInfoMap)
    end),
    %% 下发击杀怪物或者采集怪物后的各自事件
    KillEventFun = fun({BlRoleId, BlServerId}) ->
        mod_clusters_center:apply_cast(BlServerId, lib_great_demon_api, handle_boss_be_kill, [BlRoleId, MonType, BossId,
            SceneObjectInfo#scene_object.figure#figure.lv, 0])
    end,
    lists:foreach(KillEventFun, BeRoleIdL),
    NewBossInfo = BossInfo#great_demon_boss_status{
        reborn_time = LastRebornTime,
        reborn_ref = NewRebornRef,
        remind_ref = NewRemindRef
    },
    {maps:update(BossId, NewBossInfo, ZoneBossMap), NewBossInfo}.

%% 采集完成或者击杀特殊大妖
collect_or_kill_special_boss(Args) ->
    [ZoneId, PoolId, MonType, BossId, MonArgs, Boss, ZoneBossMap,
        Attacker, _FirstAttr, RoleInfoMap, BelongWhos, SceneObjectInfo|_] = Args,
    #battle_return_atter{id = AttrRoleId, real_name = AttrRoleName, server_id = AttrServerId} = Attacker,
    #great_demon_boss_status{ num = Num, xy = PosList, reborn_time = LessReBornTime } = Boss,
    #great_demon_boss_info{ scene = Scene} = data_kf_great_demon:get_great_demon_boss_cfg(BossId),
    #mon_args{ d_x = X, d_y = Y} = MonArgs,
    NewPosList = lists:delete({X, Y}, PosList),
    NewBoss = Boss#great_demon_boss_status{num = max(0, Num - 1), xy = NewPosList},
    {ok, Bin} = pt_460:write(46009, [?BOSS_TYPE_KF_GREAT_DEMON, BossId, LessReBornTime, max(0, Num - 1)]),
    {ok, Bin1} = pt_460:write(46036, [BossId, NewPosList]),
    lib_server_send:send_to_scene(Scene, PoolId, ZoneId, Bin),
    lib_server_send:send_to_scene(Scene, PoolId, ZoneId, Bin1),
    %% 记录击杀日志
    BeRoleIdL = [{RoleId, ServerId} || #mon_atter{id = RoleId, server_id = ServerId} <- BelongWhos],
    spawn(fun() -> lib_great_demon_sql:log_great_demon_boss_kf(ZoneId, BossId, AttrRoleId, AttrRoleName, BeRoleIdL, RoleInfoMap) end),
    %% 下发击杀怪物或者采集怪物后的各自事件
    mod_clusters_center:apply_cast(AttrServerId, lib_great_demon_api, handle_boss_be_kill, [AttrRoleId, MonType, BossId,
        SceneObjectInfo#scene_object.figure#figure.lv, 0]),
    {maps:update(BossId, NewBoss, ZoneBossMap), NewBoss}.

%% 生成毁灭之主等特殊怪
create_great_demon_special_boss(ZoneId, PoolId, BossId, ZoneBossMap, State) ->
    NowSec = utime:unixtime(),
    #kf_great_demon_state{domain_lock = DomainLock, boss_state_map = AllZoneBossMap} = State,
    case data_domain:get_domain_special_boss(BossId) of
        #domain_special_boss_cfg{sp_boss_weight = SpBossWeight} ->
            DomainLockTime = maps:get(ZoneId, DomainLock, 0),
            case DomainLockTime > NowSec of
                true -> % 不可以生成新的特殊怪
                    {State, []};
                false ->
                    SpBossByWeight = urand:rand_with_weight(SpBossWeight), % 按权重生成
                    case SpBossByWeight of
                        [] ->
                            {State, []};
                        _ ->
                            NewDomainLockTime =  NowSec + ?BOSS_TYPE_KV_BOSS_REVIVE_CD(?BOSS_TYPE_KF_GREAT_DEMON),  % 冷却时间
                            {NewZoneBossMap, AddBossList} =
                                do_create_great_demon_special_boss(ZoneId, PoolId, ZoneBossMap, SpBossByWeight, NewDomainLockTime),
                            NewAllZoneBossMap = maps:put(ZoneId, NewZoneBossMap, AllZoneBossMap),
                            NewDomainLock = maps:put(ZoneId, NewDomainLockTime, DomainLock),
                            NewState = State#kf_great_demon_state{boss_state_map = NewAllZoneBossMap, domain_lock = NewDomainLock},
                            {NewState, AddBossList}
                    end
            end;
        _ ->
            {State, []}
    end.

do_create_great_demon_special_boss(ZoneId, PoolId, ZoneBossMap, SpBossByWeight, NewDomainLock) ->
    BossType = ?BOSS_TYPE_KF_GREAT_DEMON,
    #boss_type{condition = Condition} = data_boss:get_boss_type(BossType),
    {_, EnterLv} = ulists:keyfind(lv, 1, Condition, {lv, 0}),
    % 传闻
    [BossIdSendTV | _] = SpBossByWeight,
    MonName = lib_mon:get_name_by_mon_id(BossIdSendTV),
    #great_demon_boss_info{scene = SceneSendTV} = data_kf_great_demon:get_great_demon_boss_cfg(BossIdSendTV),
    SceneSendTVName = lib_scene:get_scene_name(SceneSendTV),
    %% 发送小跨服传闻
    TvArgs = [{all_lv, EnterLv, 999}, ?MOD_BOSS, 18, [MonName, SceneSendTVName, SceneSendTV]],
    mod_zone_mgr:apply_cast_to_zone(1, ZoneId, lib_chat, send_TV, TvArgs),
    
    Fun = fun(BossIdTmp, {BossMapTmp, AddBossList}) ->
        #great_demon_boss_info{
            scene = Scene, num = Num, rand_xy = RandXy
        } = data_kf_great_demon:get_great_demon_boss_cfg(BossIdTmp),
        case maps:get(BossIdTmp, BossMapTmp, null) of
            null ->
                {BossMapTmp, AddBossList};
            #great_demon_boss_status{xy = BossXYList} ->
                CreateNum = max(0, Num - length(BossXYList)),
                case CreateNum > 0 of
                    false -> %% 已存在不生成
                        {BossMapTmp, AddBossList};
                    true ->
                        LastRandXy = RandXy -- BossXYList,
                        F = fun(_I, {XyList, PosList}) ->
                            [{X1, Y1} | LeftXyList] = XyList,
                            lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossIdTmp, Scene, PoolId, X1, Y1, 1, ZoneId, 1, []),
                            {LeftXyList, [{X1, Y1} | PosList]}
                        end,
                        {_, NewPosList} = lists:foldl(F, {LastRandXy, BossXYList}, lists:seq(1, CreateNum)),
                        %% 广播boss|采集怪物重生信息
                        {ok, Bin} = pt_460:write(46009, [BossType, BossIdTmp, NewDomainLock, Num]),
                        %% 广播采集怪坐标信息
                        {ok, Bin2} = pt_460:write(46036, [BossIdTmp, NewPosList]),
                        lib_server_send:send_to_scene(Scene, PoolId, ZoneId, Bin),
                        lib_server_send:send_to_scene(Scene, PoolId, ZoneId, Bin2),
                        lib_mon:get_scene_mon(Scene, PoolId, ZoneId, [#scene_object.config_id]),
                        BossStatus = #great_demon_boss_status{boss_id = BossIdTmp, xy = NewPosList, mon_type = ?SPECIAL_GREAT_DEMON, num = Num},
                        NewBossMapTmp = maps:put(BossIdTmp, BossStatus, BossMapTmp),
                        {NewBossMapTmp,  [BossStatus|AddBossList]}
                end
        end
    end,
    lists:foldl(Fun, {ZoneBossMap, []}, SpBossByWeight).

%% 玩家被击杀
player_die(AttackerInfo, DerInfo, Scene, X, Y, State) ->
    [_AUid, AttName, _AttLv, AtterSign, AttGuildId, AttServerId, AttServerNum, AttMaskId] = AttackerInfo,
    [DieId, DeadName, _DeadLv, DeadGuildId, ServerId, ServerNum, DeadMaskId] = DerInfo,
    #kf_great_demon_state{role_map = RoleMaps} = State,
    case lib_clusters_center_api:get_zone(ServerId) of
        0 ->
            State;
        ZoneId ->
            case maps:get({ZoneId, DieId}, RoleMaps, none) of
                none ->
                    State;
                #kf_role_info{bekill_count = BeKillTime} = RoleInfo ->
                    NowTime = utime:unixtime(),
                    %% 死亡复活时间buff
                    case data_boss:get_boss_type_kv(?BOSS_TYPE_PHANTOM, player_die_times) of
                        TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
                        _ -> TimeCfg = 300
                    end,
                    NewList = lib_boss_mod:get_real_die_time_list_2(BeKillTime, TimeCfg, NowTime),
                    NewRoleInfo = RoleInfo#kf_role_info{bekill_count = [NowTime|NewList]},
                    NewRoleMaps = maps:put({ZoneId, DieId}, NewRoleInfo, RoleMaps),
                    %% 公会击杀传闻s
                    case AtterSign == ?BATTLE_SIGN_PLAYER orelse AtterSign == ?BATTLE_SIGN_COMPANION of
                        true ->
                            BossTypeName = data_boss:get_boss_type_name(?BOSS_TYPE_KF_GREAT_DEMON),
                            case get_one_boss_info_by_scene(Scene) of
                                #great_demon_boss_info{boss_id = BossId, layers = Layer} when DeadGuildId > 0 andalso DeadMaskId == 0 ->
                                    NewAttName =
                                        case ServerNum =/= AttServerNum of
                                            true ->
                                                list_to_binary([lists:concat(["S", AttServerNum, "."]), AttName]);
                                            _ -> AttName
                                        end,
                                    LastAttName = lib_player:get_wrap_role_name(NewAttName, [AttMaskId]),
                                    mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV,
                                        [{guild, DeadGuildId}, ?MOD_BOSS, 14, [DeadName, util:make_sure_binary(BossTypeName),
                                            Layer, LastAttName, ?BOSS_TYPE_KF_GREAT_DEMON, BossId, Scene, X, Y]]);
                                _ ->
                                    skip
                            end,
                            case AttGuildId > 0 andalso AttMaskId == 0 of
                                true ->
                                    NewDeadName =
                                        case ServerNum =/= AttServerNum of
                                            true ->
                                                list_to_binary([lists:concat(["S", ServerNum, "."]), DeadName]);
                                            _ -> DeadName
                                        end,
                                    LastDeadName = lib_player:get_wrap_role_name(NewDeadName, [DeadMaskId]),
                                    mod_clusters_center:apply_cast(AttServerId,
                                        lib_chat, send_TV,
                                        [{guild, AttGuildId}, ?MOD_BOSS, 16, [AttName, util:make_sure_binary(BossTypeName), LastDeadName]]);
                                _ -> skip
                            end,
                            %% 通知被击杀的玩家，增加起疲劳值
                            mod_clusters_center:apply_cast(ServerId, mod_great_demon_local, player_die_add_tried, [DieId]);
                        _ ->
                            skip
                    end,
                    NewState = State#kf_great_demon_state{
                       role_map = NewRoleMaps
                    },
                    NewState
            end
    end.


%% 根据场景id，获取该场景下的一个bossid和层数
get_one_boss_info_by_scene(Scene) ->
    AllBossId = data_kf_great_demon:get_all_great_demon_boss_id(),
    get_one_boss_info_by_scene_do(AllBossId, Scene).

get_one_boss_info_by_scene_do([], _Scene) -> [];
get_one_boss_info_by_scene_do([BossId|AllBossId], Scene) ->
    case data_kf_great_demon:get_great_demon_boss_cfg(BossId) of
        #great_demon_boss_info{scene = Scene} = BossConfig ->
            BossConfig;
        _ ->
            get_one_boss_info_by_scene_do(AllBossId, Scene)
    end.

gm_create_special_boss(ServerId, Scene, State) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 ->
            State;
        ZoneId ->
            #kf_great_demon_state{ boss_state_map = AllZoneBossMap, domain_lock =  DomainLock } = State,
            case maps:get(ZoneId, AllZoneBossMap, none) of
                none ->
                    State;
                ZoneBossMap ->
                    AllBossIdByScene = data_kf_great_demon:get_great_boss_by_scene(Scene),
                    NowSec = utime:unixtime(),
                    case calc_boss_id(AllBossIdByScene) of
                        #domain_special_boss_cfg{sp_boss_weight = SpBossWeight} ->
                            SpBossByWeight = get_create_boss_id(SpBossWeight),
                            case SpBossByWeight of
                                [] ->
                                    State;
                                _ ->
                                    Pool = get_pool_id(ZoneId),
                                    {NewZoneBossMap, AddBossList} =
                                        do_create_great_demon_special_boss(ZoneId, Pool, ZoneBossMap, SpBossByWeight, NowSec),
                                    NewAllZoneBossMap = maps:put(ZoneId, NewZoneBossMap, AllZoneBossMap),
                                    NewDomainLock = maps:put(ZoneId, NowSec, DomainLock),
                                    AddBossList =/= [] andalso mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_great_demon_local, sync_boss_reborn_list, [AddBossList]),
                                    State#kf_great_demon_state{
                                        boss_state_map = NewAllZoneBossMap, domain_lock = NewDomainLock
                                    }
                            end;
                        _ ->
                            State
                    end
            end
            
    end.

calc_boss_id([BossId|BossList]) ->
    case data_domain:get_domain_special_boss(BossId) of
        #domain_special_boss_cfg{} = DomainBoss -> DomainBoss;
        _ -> calc_boss_id(BossList)
    end;
calc_boss_id(_) -> [].

get_create_boss_id([{_, BossIdList}|_]) when is_list(BossIdList) andalso BossIdList =/= [] ->
    BossIdList;
get_create_boss_id([_|T]) -> get_create_boss_id(T);
get_create_boss_id([]) -> [].

%% 秘籍 - 立即刷新采集怪
gm_reinit_cl_boss(ServerId, State) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 ->
            State;
        ZoneId ->
            #kf_great_demon_state{ boss_state_map = AllZoneBossMap } = State,
            case maps:get(ZoneId, AllZoneBossMap, none) of
                none ->
                    State;
                ZoneBossMap ->
                    AllBossIds = data_kf_great_demon:get_all_great_demon_boss_id(),
                    NowTime = utime:unixtime(),
                    PoolId = get_pool_id(ZoneId),
                    Fun = fun(BossId, AccMap) ->
                        case data_kf_great_demon:get_great_demon_boss_cfg(BossId) of
                            #great_demon_boss_info{ mon_type = ?NORMAL_TREASURE_CHEST } = BossCfg ->
                                #great_demon_boss_status{xy = XyList } = maps:get(BossId, AccMap, #great_demon_boss_status{}),
                                BossInfo = do_pick_boss_reborn(ZoneId, PoolId, 0, BossCfg, XyList, NowTime),
                                maps:put(BossId, BossInfo, AccMap);
                            #great_demon_boss_info{ mon_type = ?ADVANCED_TREASURE_CHEST } = BossCfg ->
                                #great_demon_boss_status{xy = XyList } = maps:get(BossId, AccMap, #great_demon_boss_status{}),
                                BossInfo = do_pick_boss_reborn(ZoneId, PoolId, 0, BossCfg, XyList, NowTime),
                                maps:put(BossId, BossInfo, AccMap);
                            _ ->
                                AccMap
                        end
                    end,
                    NewZoneBossMap = lists:foldl(Fun, ZoneBossMap, AllBossIds),
                    NewAllZoneBossMap = maps:put(ZoneId, NewZoneBossMap, AllZoneBossMap),
                    State#kf_great_demon_state{
                        boss_state_map = NewAllZoneBossMap
                    }
            end
    end.

gm_reinit_boss_be_kill(ServerId, Scene, State) ->
    case lib_clusters_center_api:get_zone(ServerId) of
        0 ->
            State;
        ZoneId ->
            #kf_great_demon_state{ boss_state_map = AllZoneBossMap } = State,
            case maps:get(ZoneId, AllZoneBossMap, none) of
                none ->
                    State;
                ZoneBossMap ->
                    AllBossIds = data_kf_great_demon:get_great_boss_by_scene(Scene),
                    PoolId = get_pool_id(ZoneId),
                    Fun = fun(BossId, {AccMap, AccList}) ->
                        case data_kf_great_demon:get_great_demon_boss_cfg(BossId) of
                            #great_demon_boss_info{ mon_type = ?NORMAL_GREAT_DEMON } = BossCfg ->
                                refresh_new_boss(ZoneId, PoolId, BossId, AccMap, BossCfg, AccList);
                            _ ->
                                {AccMap, AccList}
                        end
                    end,
                    {NewZoneBossMap, AddBossList} = lists:foldl(Fun, {ZoneBossMap, []}, AllBossIds),
                    AddBossList =/= [] andalso
                        mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_great_demon_local, sync_boss_reborn_list, [AddBossList]),
                    NewAllZoneBossMap = maps:put(ZoneId, NewZoneBossMap, AllZoneBossMap),
                    State#kf_great_demon_state{
                        boss_state_map = NewAllZoneBossMap
                    }
            end
    end.

refresh_new_boss(ZoneId, PoolId, BossId, BossMap, #great_demon_boss_info{scene = Scene, x = X, y = Y}, AccList) ->
    NowTime = utime:unixtime(),
    case maps:get(BossId, BossMap, false) of
        #great_demon_boss_status{remind_ref = RemindRef, reborn_ref = RebornRef} = OldBoss when is_reference(RebornRef) ->
            util:cancel_timer(RemindRef),
            util:cancel_timer(RebornRef),
            lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, PoolId, X, Y, 1, ZoneId, 1, []),
            NewBoss = OldBoss#great_demon_boss_status{remind_ref = undefined, reborn_time = NowTime, reborn_ref = undefined, num = 1},
            %% 广播boss|采集怪物重生信息
            {ok, Bin} = pt_460:write(46008, [?BOSS_TYPE_KF_GREAT_DEMON, BossId]),
            lib_server_send:send_to_scene(Scene, PoolId, ZoneId, Bin),
            {maps:put(BossId, NewBoss, BossMap), [NewBoss|AccList]};
        _ ->
            {BossMap, []}
    end.

%% 分区发生改变
zone_change(ServerId, _OldZone, NewZone, State) ->
    #kf_great_demon_state{ boss_state_map = BossStateMap, is_grouping = IsGrouping } = State,
    case get_all_boss_state_by_zone(NewZone, BossStateMap) of
        {ok, ZoneBossMap, NewAllZoneBossMap} ->
            %% 目前商定的分区后操作，
            mod_clusters_center:apply_cast(ServerId, mod_great_demon_local, zone_change, [ZoneBossMap, IsGrouping]),
            State#kf_great_demon_state{ boss_state_map = NewAllZoneBossMap};
        _ ->
            State
    end.