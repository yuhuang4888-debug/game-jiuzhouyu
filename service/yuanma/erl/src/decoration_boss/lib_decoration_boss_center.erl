%% ---------------------------------------------------------------------------
%% @doc lib_decoration_boss_center.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-14
%% @deprecated 幻饰boss 跨服
%% ---------------------------------------------------------------------------
-module(lib_decoration_boss_center).
-compile(export_all).

-include("decoration_boss.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("clusters.hrl").
-include("drop.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("battle.hrl").
-include("def_fun.hrl").

%% 初始化
init() ->
    State = #decoration_boss_center{},
    StateAfRef = calc_sboss_ref(State),
    StateAfRef.

%% 定时器
calc_sboss_ref(#decoration_boss_center{sboss_ref = OldRef} = State) ->
    util:cancel_timer(OldRef),
    IsOpen = ?DECORATION_BOSS_KV_SBOSS_OPEN,
    if
        not IsOpen -> State#decoration_boss_center{sboss_ref = none};
        true ->
            TimeList = ?DECORATION_BOSS_KV_SBOSS_TIME,
            NowDate = utime:unixdate(),
            NowTime = utime:unixtime(),
            case calc_sboss_next_time(TimeList, NowDate, NowTime) of
                false ->
                    NextDate = utime:get_next_unixdate(),
                    case calc_sboss_next_time(TimeList, NextDate, NowTime) of
                        false -> State#decoration_boss_center{sboss_ref = none};
                        NextTime ->
                            RefTime = max(NextTime - NowTime + 1, 1)*1000,
                            SbossRef = util:send_after(OldRef, RefTime, self(), {'sboss_ref'}),
                            State#decoration_boss_center{sboss_ref = SbossRef}
                    end;
                NextTime ->
                    RefTime = max(NextTime - NowTime + 1, 1)*1000,
                    SbossRef = util:send_after(OldRef, RefTime, self(), {'sboss_ref'}),
                    State#decoration_boss_center{sboss_ref = SbossRef}
            end
    end.

%% 计算特殊boss刷新时间
%% @param BaseUnixDate 基准天的时间戳
%% @param Time 当前时间
calc_sboss_next_time([], _BaseUnixDate, _Time) -> false;
calc_sboss_next_time([{H,M}|T], BaseUnixDate, Time) ->
    BaseTime = BaseUnixDate + H*3600 + M*60,
    case BaseTime > Time of
        true -> BaseTime;
        false -> calc_sboss_next_time(T, BaseUnixDate, Time)
    end.

%% 同步数据
sync_server_data(State, ServerId, OpTime) ->
    % ?MYLOG("hjhboss", "sync_server_data ServerId:~p, OpTime:~p ~n", [ServerId, OpTime]),
    #decoration_boss_center{zone_map = ZoneMap} = State,
    IsCheckOpenDay = util:check_open_day_2(?DECORATION_BOSS_KV_OPEN_DAY, OpTime),
    if
        ServerId == 0 ->
            SyncCallbackParam = {ServerId, false},
            NewState = State;
        IsCheckOpenDay == false ->
            SyncCallbackParam = {ServerId, false},
            NewState = State;
        true ->
            ZoneId = get_zone_id(ServerId),
            if
                ZoneId == 0 ->
                    SyncCallbackParam = {ServerId, false},
                    NewState = State;
                true ->
                    NewZoneMap = check_and_create(ZoneMap, ZoneId),
                    NewState = State#decoration_boss_center{zone_map = NewZoneMap},
                    SyncCallbackParam = [NewState, ServerId, ZoneId],
                    {ok, NewState}
            end
    end,
    packet_to_local(init_sync_callback, SyncCallbackParam),
    {ok, NewState}.

%% 连接到跨服中心
center_connected(State, ServerId, MergeSerIds, OpTime) ->
    {ok, StateAfSync} = sync_server_data(State, ServerId, OpTime),
    #decoration_boss_center{role_map = RoleMap} = StateAfSync,
    % 移除玩家信息
    F = fun(RoleId, #decoration_boss_role{server_id = TmpServerId} = Role, TmpRoleMap) ->
        case lists:member(TmpServerId, MergeSerIds) of
            true -> 
                % ?MYLOG("hjhboss", "RoleId:~p ~n", [RoleId]),
                slient_remove_role(Role),
                maps:remove(RoleId, TmpRoleMap);
            false -> 
                TmpRoleMap
        end
    end,
    NewRoleMap = maps:fold(F, RoleMap, RoleMap),
    StateAfRole = StateAfSync#decoration_boss_center{role_map = NewRoleMap},
    {ok, StateAfRole}.

%% 检查和创建ZoneMap
check_and_create(ZoneMap, ZoneId) ->
    case maps:is_key(ZoneId, ZoneMap) of
        true -> ZoneMap;
        false ->
            Zone = create_zone(ZoneId),
            maps:put(ZoneId, Zone, ZoneMap)
    end.

%% 生成区域
create_zone(ZoneId) ->
    BossMap = lib_decoration_boss_util:init_boss_map(?CLS_TYPE_CENTER, ZoneId),
    Zone = #decoration_boss_zone{zone_id = ZoneId, boss_map = BossMap},
    SBIsOpen = ?DECORATION_BOSS_KV_SBOSS_OPEN,
    if
        SBIsOpen ->
            case db_decoration_boss_zone_select(ZoneId) of
                [KillCount, WorldLv, IsAlive = 1] ->
                    BossId = ?DECORATION_BOSS_KV_SBOSS_ID,
                    SceneId = ?DECORATION_BOSS_KV_SBOSS_SCENE,
                    {X, Y} = ?DECORATION_BOSS_KV_SBOSS_XY,
                    % 先清怪物
                    lib_mon:clear_scene_mon_by_mids(SceneId, ZoneId, BossId, 1, [BossId]),
                    lib_mon:async_create_mon(BossId, SceneId, ZoneId, X, Y, 1, BossId, 1, [{auto_lv, WorldLv}]),
                    Zone#decoration_boss_zone{sboss_id = BossId, sboss_scene_id = SceneId, kill_count = KillCount, is_alive = IsAlive};
                [KillCount, _WorldLv, IsAlive] ->
                    Zone#decoration_boss_zone{kill_count = KillCount, is_alive = IsAlive};
                [] ->
                    Zone
            end;
        true -> Zone
    end.

%% 初始化打包
packet_to_local(init_sync_callback, [State, ServerId, ZoneId]) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    case maps:get(ZoneId, ZoneMap, []) of
        [] -> skip;
        Zone ->
            #decoration_boss_zone{
                boss_map = BossMap, kill_log = KillLog, sboss_id = SBossId, sboss_scene_id = SBossSceneId,
                sboss_hurt_list = SBossHurtList, shp = SHp, shp_lim = SHpLim, kill_count = KillCount, is_alive = IsAlive,
                drop_log_list = DropLogList
            } = Zone,
            F = fun(_BossId, Boss) ->
                Boss#decoration_boss{hurt_list = [], leave_ref = none}
                end,
            SyncCBossMap = maps:map(F, BossMap),
            List = [SyncCBossMap, KillLog, SBossId, SBossSceneId, SBossHurtList, SHp, SHpLim, KillCount, IsAlive, DropLogList],
            mod_clusters_center:apply_cast(ServerId, mod_decoration_boss_local, init_sync_callback, List)
    end;
packet_to_local(init_sync_callback, {ServerId, false}) when ServerId =/= 0 ->
    mod_clusters_center:apply_cast(ServerId, mod_decoration_boss_local, init_sync_callback, [single_play]);
%% 打包数据到本地
packet_to_local(all, [State, ServerId, ZoneId]) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    case maps:get(ZoneId, ZoneMap, []) of
        [] -> skip;
        Zone ->
            #decoration_boss_zone{
                boss_map = BossMap, kill_log = KillLog, sboss_id = SBossId, sboss_scene_id = SBossSceneId,
                sboss_hurt_list = SBossHurtList, shp = SHp, shp_lim = SHpLim, kill_count = KillCount, is_alive = IsAlive,
                drop_log_list = DropLogList
                } = Zone,
            F = fun(_BossId, Boss) ->
                Boss#decoration_boss{hurt_list = [], leave_ref = none}
            end,
            SyncCBossMap = maps:map(F, BossMap),
            List = [SyncCBossMap, KillLog, SBossId, SBossSceneId, SBossHurtList, SHp, SHpLim, KillCount, IsAlive, DropLogList],
            mod_clusters_center:apply_cast(ServerId, mod_decoration_boss_local, sync_update, List)
    end;

%% 进入boss
packet_to_local(enter_boss, [RoleId, ServerId, BossId]) ->
    mod_clusters_center:apply_cast(ServerId, mod_decoration_boss_local, sync_update, [[{enter_boss, RoleId, ServerId, BossId}]]);

% 本地击杀boss
packet_to_local(local_kill_mon, [State, ZoneId]) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    case maps:get(ZoneId, ZoneMap, []) of
        [] -> skip;
        #decoration_boss_zone{kill_count = KillCount} ->
            apply_cast_to_zone(ZoneId, mod_decoration_boss_local, sync_update, [[{kill_count, KillCount}]])
    end;

% 击杀boss
packet_to_local(kill_mon, [State, ZoneId, Boss]) ->
    #decoration_boss{boss_id = BossId, reborn_time = RebornTime} = Boss,
    KillCount = get_kill_count(State, ZoneId),
    apply_cast_to_zone(ZoneId, mod_decoration_boss_local, sync_update, [[{kill_mon, BossId, RebornTime, KillCount}]]);

% 击杀特殊boss
packet_to_local(kill_sboss, [ZoneId]) ->
    apply_cast_to_zone(ZoneId, mod_decoration_boss_local, sync_update, [[{kill_sboss}]]);

% boss复活
packet_to_local(reborn_ref, [ZoneId, Boss]) ->
    #decoration_boss{boss_id = BossId} = Boss,
    apply_cast_to_zone(ZoneId, mod_decoration_boss_local, sync_update, [[{reborn_ref, BossId}]]);

% 特殊boss出生
packet_to_local(sboss_ref, [Zone]) ->
    #decoration_boss_zone{zone_id = ZoneId, sboss_id = SBossId, sboss_scene_id = SBossSceneId, kill_count = KillCount, is_alive = IsAlive} = Zone,
    apply_cast_to_zone(ZoneId, mod_decoration_boss_local, sync_update, [[{sboss_ref, SBossId, SBossSceneId, KillCount, IsAlive}]]);

% 增加掉落日志
packet_to_local(add_drop_log, [ZoneId, AddDropLogList]) ->
    apply_cast_to_zone(ZoneId, mod_decoration_boss_local, sync_update, [[{add_drop_log, AddDropLogList}]]);

% boss数量
packet_to_local(role_num, [ZoneId, BossId, Num]) ->
    apply_cast_to_zone(ZoneId, mod_decoration_boss_local, sync_update, [[{role_num, BossId, Num}]]);

%% 普通boss离开
packet_to_local(leave_ref, [ZoneId, BossId]) ->
    apply_cast_to_zone(ZoneId, mod_decoration_boss_local, sync_update, [[{leave_ref, BossId}]]);

%% 特殊boss离开
packet_to_local(sleave_ref, [ZoneId, SBossId]) ->
    apply_cast_to_zone(ZoneId, mod_decoration_boss_local, sync_update, [[{sleave_ref, SBossId}]]);

packet_to_local(_, _) ->
    skip.

get_zone_id(ServerId) ->
    lib_clusters_center_api:get_zone(ServerId).

apply_cast_to_zone(ZoneId, M, F, A) ->
    mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, M, F, A).

%% 检查进入
check_and_enter_boss(State, RoleId, ServerId, BossId, Type) ->
    case check_enter_boss(State, RoleId, ServerId, BossId, Type) of
        {false, ErrCode} -> 
            {ok, BinData} = pt_471:write(47102, [ErrCode, BossId, Type]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            NewState = State;
        {true, SceneId, ZoneId, Num, IsHadAssist} ->
            Args = [RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, enter_boss, [BossId, Type, ?CLS_TYPE_CENTER, SceneId, IsHadAssist]],
            mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
            NewState = set_role_num(State, ZoneId, BossId, Num)
    end,
    {ok, NewState}.

check_enter_boss(#decoration_boss_center{act_status = ?DECORATION_BOSS_ACT_STATUS_ALLOCATE}, _RoleId, _ServerId, _BossId, _Type) ->
    {false, ?ERRCODE(err471_act_status_zone_allocate)};
check_enter_boss(State, RoleId, ServerId, BossId, _Type) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    ZoneId = get_zone_id(ServerId),
    Zone = maps:get(ZoneId, ZoneMap, []),
    if
        ZoneId == 0 -> {false, ?ERRCODE(err471_no_zone)};
        Zone == [] -> {false, ?ERRCODE(err471_zone_allocate)};
        true ->
            #decoration_boss_zone{boss_map = BossMap} = Zone,
            % ?MYLOG("hjhboss", "GetBoss:~p, BossMap:~p ~n", [maps:get(BossId, BossMap, []), BossMap]),
            case maps:get(BossId, BossMap, []) of
                #decoration_boss{reborn_time = RebornTime} when RebornTime > 0 ->
                    {false, ?ERRCODE(err471_boss_die_not_to_enter)};
                #decoration_boss{cls_type = ?CLS_TYPE_CENTER, scene_id = SceneId, assist_list = AssistList} ->
                    case mod_scene_agent:apply_call(SceneId, ZoneId, lib_decoration_boss_util, check_and_enter_on_scene, [BossId]) of
                        Num when is_integer(Num) -> 
                            #base_decoration_boss{role_num = RoleNum} = data_decoration_boss:get_boss(BossId),
                            case Num >= RoleNum of
                                true -> {false, ?ERRCODE(err471_max_role_num)};
                                false -> {true, SceneId, ZoneId, Num, lists:keymember(RoleId, 1, AssistList)}
                            end;
                        _ ->
                            {false, ?ERRCODE(err471_max_role_num)}
                    end;
                _ ->
                    {false, ?ERRCODE(err471_no_boss_cfg)}
            end
    end.

%% 进入boss
enter_boss(State, Role) ->
    #decoration_boss_role{role_id = RoleId, boss_id = BossId, enter_type = EnterType, server_id = ServerId} = Role,
    case check_for_enter_boss(State, Role) of
        {false, ErrCode} -> 
            % 通知移除数据
            mod_clusters_center:apply_cast(ServerId, mod_decoration_boss_local, remove_role, [RoleId]),
            StateAfAdd = State;
        {true, ZoneId, Zone, BossMap, Boss} ->
            ErrCode = ?SUCCESS,
            slient_remove_role(State, RoleId),
            #decoration_boss_center{role_map = RoleMap} = State,
            NewRole = Role#decoration_boss_role{zone_id = ZoneId},
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
            NewState = State#decoration_boss_center{role_map = NewRoleMap},
            case EnterType == ?DECORATION_BOSS_ENTER_TYPE_ASSIST of
                true ->
                    #decoration_boss{assist_list = AssistList} = Boss,
                    NewAssistList = [{RoleId, ServerId}|lists:keydelete(RoleId, 1, AssistList)],
                    NewBoss = Boss#decoration_boss{assist_list = NewAssistList},
                    StateAfSave = save_boss_info(NewState, Zone, BossMap, NewBoss),
                    packet_to_local(enter_boss, [RoleId, ServerId, BossId]);
                false ->
                    StateAfSave = NewState
            end,
            StateAfAdd = add_role_num(StateAfSave, ZoneId, BossId, 1),
            % 传送场景
            #decoration_boss_role{scene_id = SceneId, x = X, y = Y} = NewRole,
            case EnterType == ?DECORATION_BOSS_ENTER_TYPE_NORMAL orelse EnterType == ?DECORATION_BOSS_ENTER_TYPE_GUILD_ASSIST of
                true -> EnterTypeKvL = [{is_hurt_mon, 1}];
                false -> EnterTypeKvL = [{is_hurt_mon, 0}]
            end,
            KeyValueList = [{change_scene_hp_lim, 0}, {action_lock, ?ERRCODE(err471_not_change_scene_on_decoration_boss)}|EnterTypeKvL],
            Args = [RoleId, SceneId, ZoneId, BossId, X, Y, true, KeyValueList],
            mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, Args)
    end,
    {ok, BinData} = pt_471:write(47102, [ErrCode, BossId, EnterType]),
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
    {ok, StateAfAdd}.

check_for_enter_boss(#decoration_boss_center{act_status = ?DECORATION_BOSS_ACT_STATUS_ALLOCATE}, _Role) ->
    {false, ?ERRCODE(err471_act_status_zone_allocate)};
check_for_enter_boss(State, Role) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    #decoration_boss_role{server_id = ServerId} = Role,
    ZoneId = get_zone_id(ServerId),
    Zone = maps:get(ZoneId, ZoneMap, []),
    if
        ZoneId == 0 -> {false, ?ERRCODE(err471_no_zone)};
        Zone == [] -> {false, ?ERRCODE(err471_zone_allocate)};
        true ->
            #decoration_boss_role{boss_id = BossId} = Role,
            #decoration_boss_zone{boss_map = BossMap} = Zone,
            case maps:get(BossId, BossMap, []) of
                #decoration_boss{} = Boss -> {true, ZoneId, Zone, BossMap, Boss};
                _ -> {false, ?ERRCODE(err471_no_boss_cfg)}
            end
    end.
    
%% 退出
quit(State, RoleId, _ServerId) ->
    slient_remove_role(State, RoleId),
    #decoration_boss_center{role_map = RoleMap} = State,
    NewRoleMap = maps:remove(RoleId, RoleMap),
    NewState = State#decoration_boss_center{role_map = NewRoleMap},
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{zone_id = ZoneId, boss_id = BossId} = Role ->
            deal_assist_status(Role),
            StateAfDel = del_role_num(NewState, ZoneId, BossId, 1);
        _ ->
            StateAfDel = NewState
    end,
    {ok, StateAfDel}.

%% 处理协助
%% 协助规则：1.帮助发起人击杀其他玩家后，协助完成，扣除次数，此时退出场景有协助奖励
%%          2.以协助状态进入场景，Boss死亡后在场景，协助完成，获取奖励，扣除次数
deal_assist_status(Role) ->
    case Role of
        #decoration_boss_role{
            enter_type = ?DECORATION_BOSS_ENTER_TYPE_ASSIST,
            success_assist = ?ASSISTED, role_id = RoleId,
            boss_id = BossId, server_id = ServerId
        } ->
            Args = [RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, send_boss_reward, [#mon_args{mid = BossId}, ?DECORATION_BOSS_ENTER_TYPE_ASSIST, 0, 0, 0]],
            mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args);
        _ -> skip
    end.

%% 玩家击杀其他玩家，若击杀者是协助者则完成协助
deal_assist_status2(Killer, RoleMap) ->
    #battle_return_atter{id = RoleId} = Killer,
    case maps:find(RoleId, RoleMap) of
        #decoration_boss_role{enter_type = ?DECORATION_BOSS_ENTER_TYPE_ASSIST, success_assist = ?ASSISTING} = Role ->
            maps:put(RoleId, Role#decoration_boss_role{success_assist = ?ASSISTED}, RoleMap);
        _ -> RoleMap
    end.

%% 检查进入
check_and_enter_sboss(State, RoleId, ServerId, EnterType) ->
    case check_enter_sboss(State, RoleId, ServerId) of
        {false, ErrCode} -> 
            {ok, BinData} = pt_471:write(47110, [ErrCode]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            NewState = State;
        {true, ZoneId, SBossId, SceneId, Num} ->
            Args = [RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, enter_sboss, [SBossId, SceneId, EnterType]],
            mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
            NewState = set_role_num(State, ZoneId, SBossId, Num)
    end,
    {ok, NewState}.

check_enter_sboss(#decoration_boss_center{act_status = ?DECORATION_BOSS_ACT_STATUS_ALLOCATE}, _RoleId, _ServerId) ->
    {false, ?ERRCODE(err471_act_status_zone_allocate)};
check_enter_sboss(State, _RoleId, ServerId) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    ZoneId = get_zone_id(ServerId),
    Zone = maps:get(ZoneId, ZoneMap, []),
    if
        ZoneId == 0 -> {false, ?ERRCODE(err471_no_zone)};
        Zone == [] -> {false, ?ERRCODE(err471_zone_allocate)};
        true ->
            % ?MYLOG("hjhboss", "GetBoss:~p, BossMap:~p ~n", [maps:get(BossId, BossMap, []), BossMap]),
            case Zone of
                #decoration_boss_zone{is_alive = 0} ->
                    {false, ?ERRCODE(err471_boss_die_not_to_enter)};
                #decoration_boss_zone{sboss_id = SBossId, sboss_scene_id = SceneId} ->
                    case mod_scene_agent:apply_call(SceneId, ZoneId, lib_decoration_boss_util, check_and_enter_on_scene, [SBossId]) of
                        Num when is_integer(Num) -> 
                            case Num >= ?DECORATION_BOSS_KV_SBOSS_ROLE_NUM of
                                true -> {false, ?ERRCODE(err471_max_role_num)};
                                false -> {true, ZoneId, SBossId, SceneId, Num}
                            end;
                        _ ->
                            {false, ?ERRCODE(err471_max_role_num)}
                    end;
                _ ->
                    {false, ?ERRCODE(err471_no_zone)}
            end
    end.

%% 进入特殊boss
enter_sboss(State, Role) ->
    #decoration_boss_role{role_id = RoleId, boss_id = BossId, enter_type = EnterType, server_id = ServerId} = Role,
    case check_for_enter_sboss(State, Role) of
        {false, ErrCode} -> 
            % 通知移除数据
            mod_clusters_center:apply_cast(ServerId, mod_decoration_boss_local, remove_role, [RoleId]),
            StateAfAdd = State;
        {true, ZoneId} ->
            ErrCode = ?SUCCESS,
            slient_remove_role(State, RoleId),
            #decoration_boss_center{role_map = RoleMap} = State,
            NewRole = Role#decoration_boss_role{zone_id = ZoneId},
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
            NewState = State#decoration_boss_center{role_map = NewRoleMap},
            StateAfAdd = add_role_num(NewState, ZoneId, BossId, 1),
            % 传送场景
            #decoration_boss_role{scene_id = SceneId, x = X, y = Y} = NewRole,
            KeyValueList = [{change_scene_hp_lim, 0}, {is_hurt_mon, 1}, {action_lock, ?ERRCODE(err471_not_change_scene_on_decoration_boss)}],
            Args = [RoleId, SceneId, ZoneId, BossId, X, Y, true, KeyValueList],
            mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, Args)
    end,
    {ok, BinData} = pt_471:write(47102, [ErrCode, BossId, EnterType]),
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
    {ok, StateAfAdd}.

check_for_enter_sboss(#decoration_boss_center{act_status = ?DECORATION_BOSS_ACT_STATUS_ALLOCATE}, _Role) ->
    {false, ?ERRCODE(err471_act_status_zone_allocate)};
check_for_enter_sboss(State, Role) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    #decoration_boss_role{server_id = ServerId} = Role,
    ZoneId = get_zone_id(ServerId),
    Zone = maps:get(ZoneId, ZoneMap, []),
    if
        ZoneId == 0 -> {false, ?ERRCODE(err471_no_zone)};
        Zone == [] -> {false, ?ERRCODE(err471_zone_allocate)};
        true -> {true, ZoneId}    
    end.

%% 设置人数
set_role_num(State, ZoneId, BossId, Num) ->
    case lib_decoration_boss_api:is_sboss_id(BossId) of
        true ->
            #decoration_boss_center{zone_map = ZoneMap} = State,
            case maps:get(ZoneId, ZoneMap, []) of
                [] -> State;
                #decoration_boss_zone{role_num = OldNum} = Zone ->
                    case OldNum =/= Num of
                        true -> packet_to_local(role_num, [ZoneId, BossId, Num]);
                        false -> skip
                    end,
                    NewZone = Zone#decoration_boss_zone{role_num = Num},
                    NewZoneMap = maps:put(ZoneId, NewZone, ZoneMap),
                    State#decoration_boss_center{zone_map = NewZoneMap}
            end;
        false ->
            case get_boss_info(State, ZoneId, BossId) of
                {true, #decoration_boss_zone{zone_id = ZoneId} = Zone, BossMap, #decoration_boss{role_num = OldNum} = Boss} ->
                    case OldNum =/= Num of
                        true -> packet_to_local(role_num, [ZoneId, BossId, Num]);
                        false -> skip
                    end,
                    NewBoss = Boss#decoration_boss{role_num = Num},
                    StateAfSave = save_boss_info(State, Zone, BossMap, NewBoss),
                    StateAfSave;
                _ ->
                    State
            end
    end.

%% 增加人数
add_role_num(State, ZoneId, BossId, Num) ->
    case lib_decoration_boss_api:is_sboss_id(BossId) of
        true ->
            #decoration_boss_center{zone_map = ZoneMap} = State,
            case maps:get(ZoneId, ZoneMap, []) of
                [] -> State;
                #decoration_boss_zone{role_num = OldNum} = Zone ->
                    NewNum = OldNum + Num,
                    case OldNum =/= NewNum of
                        true -> packet_to_local(role_num, [ZoneId, BossId, NewNum]);
                        false -> skip
                    end,
                    NewZone = Zone#decoration_boss_zone{role_num = NewNum},
                    NewZoneMap = maps:put(ZoneId, NewZone, ZoneMap),
                    State#decoration_boss_center{zone_map = NewZoneMap}
            end;
        false ->
            case get_boss_info(State, ZoneId, BossId) of
                {true, #decoration_boss_zone{zone_id = ZoneId} = Zone, BossMap, #decoration_boss{role_num = OldNum} = Boss} ->
                    NewNum = OldNum + Num,
                    case OldNum =/= NewNum of
                        true -> packet_to_local(role_num, [ZoneId, BossId, NewNum]);
                        false -> skip
                    end,
                    NewBoss = Boss#decoration_boss{role_num = NewNum},
                    StateAfSave = save_boss_info(State, Zone, BossMap, NewBoss),
                    StateAfSave;
                _R ->
                    State
            end
    end.

%% 减少人数
del_role_num(State, ZoneId, BossId, Num) ->
    case lib_decoration_boss_api:is_sboss_id(BossId) of
        true ->
            #decoration_boss_center{zone_map = ZoneMap} = State,
            case maps:get(ZoneId, ZoneMap, []) of
                [] -> State;
                #decoration_boss_zone{role_num = OldNum} = Zone ->
                    NewNum = max(OldNum - Num, 0),
                    case OldNum =/= NewNum of
                        true -> packet_to_local(role_num, [ZoneId, BossId, NewNum]);
                        false -> skip
                    end,
                    NewZone = Zone#decoration_boss_zone{role_num = NewNum},
                    NewZoneMap = maps:put(ZoneId, NewZone, ZoneMap),
                    State#decoration_boss_center{zone_map = NewZoneMap}
            end;
        false ->
            case get_boss_info(State, ZoneId, BossId) of
                {true, #decoration_boss_zone{zone_id = ZoneId} = Zone, BossMap, #decoration_boss{role_num = OldNum} = Boss} ->
                    NewNum = max(OldNum - Num, 0),
                    case OldNum =/= NewNum of
                        true -> packet_to_local(role_num, [ZoneId, BossId, NewNum]);
                        false -> skip
                    end,
                    NewBoss = Boss#decoration_boss{role_num = NewNum},
                    StateAfSave = save_boss_info(State, Zone, BossMap, NewBoss),
                    StateAfSave;
                _ ->
                    State
            end
    end.

%% 战斗信息
send_battle_info(State, RoleId, ServerId) ->
    #decoration_boss_center{role_map = RoleMap, zone_map = ZoneMap} = State,
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{zone_id = ZoneId, boss_id = BossId, die_ref = DieRef, enter_type = EnterType} ->
            case lib_decoration_boss_api:is_sboss_id(BossId) of
                true ->  
                    case maps:get(ZoneId, ZoneMap, []) of
                        #decoration_boss_zone{sleave_ref = LeaveRef} -> ok;
                        _ -> LeaveRef = none
                    end;
                false ->
                    case get_boss_info(State, ZoneId, BossId) of
                        {true, _Zone, _BossMap, #decoration_boss{leave_ref = LeaveRef}} -> ok;
                        _ -> LeaveRef = none
                    end
            end,
            case is_reference(LeaveRef) of
                true ->
                    case erlang:read_timer(LeaveRef) of
                        N when is_integer(N) -> QuitTime = utime:unixtime() + N div 1000;
                        _ -> QuitTime = 0
                    end;
                false ->
                    QuitTime = 0
            end,
            case is_reference(DieRef) of
                true ->
                    case erlang:read_timer(DieRef) of
                        DieN when is_integer(DieN) -> ReviveTime = utime:unixtime() + DieN div 1000;
                        _ -> ReviveTime = 0
                    end;
                false ->
                    ReviveTime = 0
            end,
            {ok, BinData} = pt_471:write(47114, [EnterType, QuitTime, ReviveTime]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            ok;
        _ ->
            ok
    end.

%% 击杀怪物
kill_mon(State, ZoneId, MonArgs, FirstAtter) ->
    #mon_args{mid = BossId} = MonArgs,
    case lib_decoration_boss_api:is_sboss_id(BossId) of
        true ->
            % ?MYLOG("hjhboss", "kill_mon ZoneId:~p BossId:~p ~n", [ZoneId, BossId]),
            #decoration_boss_center{zone_map = ZoneMap} = State,
            case maps:get(ZoneId, ZoneMap, []) of
                [] -> {ok, State};
                #decoration_boss_zone{} = Zone ->
                    % 发送特殊boss奖励
                    send_sboss_reward(Zone, MonArgs),
                    % 设置特殊boss数据
                    NewZone = Zone#decoration_boss_zone{is_alive = 0},
                    ZoneAfRef = calc_sleave_ref(NewZone),
                    NewZoneMap = maps:put(ZoneId, ZoneAfRef, ZoneMap),
                    NewState = State#decoration_boss_center{zone_map = NewZoneMap},
                    db_decoration_boss_zone_replace(ZoneId, 0, 0, 0),
                    packet_to_local(kill_sboss, [ZoneId]),
                    % 广播死亡
                    {ok, BinData} = pt_471:write(47117, [BossId, 0]),
                    apply_cast_to_zone(ZoneId, lib_server_send, send_to_all, [BinData]),
                    {ok, NewState}
            end;
        false ->
            case get_boss_info(State, ZoneId, BossId) of
                {true, #decoration_boss_zone{zone_id = ZoneId} = Zone, BossMap, Boss} ->
                    #base_decoration_boss{revive_time = ReviveTime} = data_decoration_boss:get_boss(BossId),
                    RebornTime = utime:unixtime() + ReviveTime,
                    NewBoss = Boss#decoration_boss{assist_list = [], reborn_time = RebornTime},
                    BossAfReborn = calc_boss_reborn_ref(ZoneId, NewBoss),
                    BossAfLeave = calc_boss_leave_ref(ZoneId, BossAfReborn),
                    % ?MYLOG("hjhboss", "kill_mon:~w ~n", [[BossId]]),
                    StateAfSave = save_boss_info(State, Zone, BossMap, BossAfLeave),
                    StateAfCountTmp = ?IF(?DECORATION_BOSS_KV_SBOSS_OPEN, add_kill_count(StateAfSave, ZoneId, 1), StateAfSave),
                    #decoration_boss_center{role_map = RoleMap} = StateAfCountTmp,
                    % 发送奖励
                    F = fun(_RoleId, Role, RoleList) ->
                        case Role of
                            #decoration_boss_role{boss_id = BossId, zone_id = ZoneId} -> [Role|RoleList];
                            _ -> RoleList
                        end
                    end,
                    RoleList = maps:fold(F, [], RoleMap),
                    AssitRoleList = send_boss_reward(RoleList, MonArgs, FirstAtter),
                    F2 = fun(#decoration_boss_role{role_id = RoleId} = RItem, GrandMap) -> maps:put(RoleId, RItem, GrandMap) end,
                    NewRoleMap = lists:foldl(F2, RoleMap, AssitRoleList),
                    StateAfCount = StateAfCountTmp#decoration_boss_center{role_map = NewRoleMap},
                    packet_to_local(kill_mon, [StateAfCount, ZoneId, NewBoss]),
                    % 广播死亡
                    {ok, BinData} = pt_471:write(47117, [BossId, RebornTime]),
                    apply_cast_to_zone(ZoneId, lib_server_send, send_to_all, [BinData]);
                _ ->
                    StateAfCount = State
            end,
            {ok, StateAfCount}
    end.

%% 计算怪物重生定时器
calc_boss_reborn_ref(_ZoneId, #decoration_boss{reborn_time = 0, reborn_ref = OldRef} = Boss) -> 
    util:cancel_timer(OldRef),
    Boss#decoration_boss{reborn_ref = none}; 
calc_boss_reborn_ref(ZoneId, Boss) ->
    #decoration_boss{boss_id = BossId, reborn_time = RebornTime, reborn_ref = OldRef} = Boss,
    RebornSpanTime = max(1, RebornTime - utime:unixtime()),
    RebornRef = util:send_after(OldRef, RebornSpanTime * 1000, self(), {'reborn_ref', ZoneId, BossId}),
    Boss#decoration_boss{reborn_ref = RebornRef}.

%% 离开定时器
calc_boss_leave_ref(ZoneId, #decoration_boss{boss_id = BossId, scene_id = SceneId, leave_ref = OldRef} = Boss) ->
    LeaveTime = max(1, ?DECORATION_BOSS_KV_QUIT_TIME),
    LeaveRef = util:send_after(OldRef, LeaveTime * 1000, self(), {'leave_ref', ZoneId, BossId}),
    {ok, BinData} = pt_471:write(47115, [utime:unixtime()+LeaveTime]),
    lib_server_send:send_to_scene(SceneId, ZoneId, BossId, BinData),
    ?PRINT("calc_boss_leave_ref :~p ~n", [utime:unixtime()+LeaveTime]),
    Boss#decoration_boss{leave_ref = LeaveRef}.

%% 特殊boss离开定时器
calc_sleave_ref(#decoration_boss_zone{zone_id = ZoneId, sboss_scene_id = SBossSceneId, sboss_id = SBossId, sleave_ref = OldRef} = Zone) ->
    LeaveTime = max(1, ?DECORATION_BOSS_KV_QUIT_TIME),
    SleaveRef = util:send_after(OldRef, LeaveTime * 1000, self(), {'sleave_ref', ZoneId}),
    {ok, BinData} = pt_471:write(47115, [utime:unixtime()+LeaveTime]),
    lib_server_send:send_to_scene(SBossSceneId, ZoneId, SBossId, BinData),
    ?PRINT("calc_boss_leave_ref :~p ~n", [utime:unixtime()+LeaveTime]),
    Zone#decoration_boss_zone{sleave_ref = SleaveRef}.

%% 发送boss奖励
send_sboss_reward(Zone, MonArgs) ->
    #decoration_boss_zone{zone_id = ZoneId, sboss_hurt_list = HurtList} = Zone,
    case HurtList of
        [#decoration_boss_hurt{role_id = RoleId, server_id = ServerId}] ->
            % ?MYLOG("hjhboss", "send_sboss_reward RoleId:~p ServerId:~p ~n", [RoleId, ServerId]),
            IsBelong = 1,
            mod_clusters_center:apply_cast(ServerId, lib_decoration_boss, send_sboss_reward, [RoleId, IsBelong, MonArgs]);
        [#decoration_boss_hurt{role_id = RoleId, server_id = ServerId}|LeftHurtL] ->
            {_Min, _Max, Num} = ?DECORATION_BOSS_KV_SBOSS_REWARD_NUM,
            % 根据排名获取权重列表
            F = fun(#decoration_boss_hurt{role_id = TmpRoleId, server_id = TmpServerId}, {Rank, List}) ->
                case get_weight(Rank) of
                    false -> {Rank+1, List};
                    Weight -> {Rank+1, [{Weight, {TmpRoleId, TmpServerId, Rank}}|List]}
                end
            end,
            {_, WeightL} = lists:foldl(F, {2, []}, LeftHurtL),
            % 包括第一名
            BelongList = urand:list_rand_by_weight(WeightL, Num) ++ [{RoleId, ServerId, 1}],
            [mod_clusters_center:apply_cast(TmpServerId, lib_decoration_boss, send_sboss_reward, [TmpRoleId, 1, MonArgs])
                ||{TmpRoleId, TmpServerId, _Rank}<-BelongList],
            % 剩余的参与奖
            JoinList = [{TmpRoleId, TmpServerId}||#decoration_boss_hurt{role_id = TmpRoleId, server_id = TmpServerId}<-LeftHurtL, 
                lists:keymember(TmpRoleId, 1, BelongList)==false],
            [mod_clusters_center:apply_cast(TmpServerId, lib_decoration_boss, send_sboss_reward, [TmpRoleId, 0, MonArgs])
                ||{TmpRoleId, TmpServerId}<-JoinList],
            % ?MYLOG("hjhboss", "send_sboss_reward BelongList:~p JoinList:~p ~n", [BelongList, JoinList]),
            log_decoration_sboss_hurt(ZoneId, HurtList, BelongList);
        _ ->
            skip
    end.

get_weight(Rank) ->
    RankWeightL = ?DECORATION_BOSS_KV_SBOSS_RANK_WEIGHT,
    do_get_weight(RankWeightL, Rank).

do_get_weight([], _Rank) -> 0;
do_get_weight([{Min, Max, Weight}|T], Rank) ->
    case Rank >= Min andalso Rank =< Max of
        true -> Weight;
        false -> do_get_weight(T, Rank)
    end.

%% 发送boss奖励
send_boss_reward(RoleList, MonArgs, FirstAtter) ->
    case FirstAtter of
        #mon_atter{id = FirstId, server_id = FirstServerId} -> ok;
        _ -> FirstId = 0, FirstServerId = 0
    end,
    F = fun(RoleItem, GrandRole) ->
        case RoleItem of
            #decoration_boss_role{success_assist = ?ASSISTED2, enter_type = ?DECORATION_BOSS_ENTER_TYPE_ASSIST} -> GrandRole;
            _ ->
                #decoration_boss_role{server_id = ServerId, role_id = RoleId, enter_type = EnterType, hurt = Hurt} = RoleItem,
                Args = [RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, send_boss_reward, [MonArgs, EnterType, FirstId, FirstServerId, Hurt]],
                mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
                case EnterType of
                    ?DECORATION_BOSS_ENTER_TYPE_NORMAL -> GrandRole;
                    _ -> [RoleItem#decoration_boss_role{success_assist = ?ASSISTED2}|GrandRole]
                end
        end
        end,
    AssistRoles = lists:foldl(F, [], RoleList),
    AssistRoles.

%% 获取boss信息
get_boss_info(State, ZoneId, BossId) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    case maps:get(ZoneId, ZoneMap, []) of
        #decoration_boss_zone{boss_map = BossMap} = Zone ->
            case maps:get(BossId, BossMap, []) of
                #decoration_boss{cls_type = ?CLS_TYPE_CENTER} = Boss -> {true, Zone, BossMap, Boss};
                _ -> false
            end;
        _ ->
            false
    end.

%% 保存boss信息
save_boss_info(State, Zone, BossMap, Boss) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    #decoration_boss{boss_id = BossId} = Boss,
    NewBossMap = maps:put(BossId, Boss, BossMap),
    #decoration_boss_zone{zone_id = ZoneId} = Zone,
    NewZone = Zone#decoration_boss_zone{boss_map = NewBossMap},
    NewZoneMap = maps:put(ZoneId, NewZone, ZoneMap),
    State#decoration_boss_center{zone_map = NewZoneMap}.

%% 本地击杀boss
local_kill_mon(State, ServerId, MonId) ->
    ZoneId = get_zone_id(ServerId),
    IsSboosId = lib_decoration_boss_api:is_sboss_id(MonId),
    if
        ZoneId == 0 -> {ok, State};
        IsSboosId -> {ok, State};
        true ->
            NewState = add_kill_count(State, ZoneId, 1),
            packet_to_local(local_kill_mon, [NewState, ZoneId]),
            {ok, NewState}
    end.
    
%% 增加击杀数量
add_kill_count(State, ZoneId, Count) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    case maps:get(ZoneId, ZoneMap, []) of
        #decoration_boss_zone{is_alive = 0, kill_count = KillCount} = Zone -> 
            NewKillCount = KillCount + Count,
            NewZone = Zone#decoration_boss_zone{kill_count = NewKillCount},
            NewZoneMap = maps:put(ZoneId, NewZone, ZoneMap),
            NewState = State#decoration_boss_center{zone_map = NewZoneMap},
            db_decoration_boss_zone_replace(ZoneId, NewKillCount, 0, 0),
            NewState;
        _ -> 
            State
    end.

%% 对怪物造成伤害
hurt_mon(State, ZoneId, BossId, BossHurt) ->
    #decoration_boss_center{zone_map = ZoneMap, role_map = RoleMap} = State,
    #decoration_boss_hurt{role_id = RoleId, hurt = Hurt} = BossHurt,
    % ?MYLOG("hjhboss", "ZoneId:~p BossId:~p, BossHurt:~p ~n", [ZoneId, BossId, BossHurt]),
    case lib_decoration_boss_api:is_sboss_id(BossId) of
        true ->
            case maps:get(ZoneId, ZoneMap, []) of
                #decoration_boss_zone{sboss_hurt_list = HurtList} = Zone ->
                    case lists:keyfind(RoleId, #decoration_boss_hurt.role_id, HurtList) of
                        false -> NewSbossHurt = BossHurt;
                        #decoration_boss_hurt{hurt = OldHurt} ->
                            NewSbossHurt = BossHurt#decoration_boss_hurt{hurt = OldHurt+Hurt}
                    end,
                    NewHurtList = lists:keystore(RoleId, #decoration_boss_hurt.role_id, HurtList, NewSbossHurt),
                    SortHurtList = sort_hurt_list(NewHurtList),
                    NewZone = Zone#decoration_boss_zone{sboss_hurt_list = SortHurtList},
                    send_role_sboss_hurt_info(Zone, NewSbossHurt),
                    % ?MYLOG("hjhboss1", "ZoneId:~p SortHurtList:~p ~n", [ZoneId, SortHurtList]),
                    NewZoneMap = maps:put(ZoneId, NewZone, ZoneMap);
                _ ->
                    NewZoneMap = ZoneMap
            end;
        false ->
            NewZoneMap = ZoneMap
    end,
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{hurt = OldRoleHurt} = Role -> 
            NewRole = Role#decoration_boss_role{hurt = Hurt + OldRoleHurt},
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap);
        _ ->
            NewRoleMap = RoleMap
    end,
    NewState = State#decoration_boss_center{zone_map = NewZoneMap, role_map = NewRoleMap},
    {ok, NewState}.

sort_hurt_list(HurtList) ->
    F = fun(#decoration_boss_hurt{hurt = HurtA, time = TimeA}, #decoration_boss_hurt{hurt = HurtB, time = TimeB}) ->
        if
            HurtA == HurtB -> TimeA < TimeB;
            true -> HurtA > HurtB
        end
    end,
    lists:sort(F, HurtList).

%% 发送玩家伤害
send_role_sboss_hurt_info(Zone, BossHurt) ->
    #decoration_boss_zone{zone_id = ZoneId, sboss_id = SBossId, sboss_scene_id = SBossSceneId} = Zone,
    #decoration_boss_hurt{
        role_id = RoleId, name = Name, server_id = ServerId, server_num = ServerNum, server_name = ServerName,
        hurt = Hurt
        } = BossHurt,
    {ok, BinData} = pt_471:write(47112, [RoleId, Name, ServerId, ServerNum, ServerName, Hurt]),
    lib_server_send:send_to_scene(SBossSceneId, ZoneId, SBossId, BinData),
    ok.

%% 特殊boss的个人伤害记录
send_role_sboss_hurt_info(#decoration_boss_center{act_status = ?DECORATION_BOSS_ACT_STATUS_ALLOCATE}, _RoleId, _ServerId) ->
    ok;
send_role_sboss_hurt_info(State, RoleId, ServerId) ->
    ZoneId = get_zone_id(ServerId),
    #decoration_boss_center{zone_map = ZoneMap} = State,
    case maps:get(ZoneId, ZoneMap, []) of
        #decoration_boss_zone{sboss_hurt_list = HurtList} ->
            F = fun(BossHurt) ->
                #decoration_boss_hurt{
                    role_id = TmpRoleId, name = Name, server_id = TmpServerId, server_num = ServerNum, server_name = ServerName,
                    hurt = Hurt
                } = BossHurt,
                {TmpRoleId, Name, TmpServerId, ServerNum, ServerName, Hurt}
            end,
            List = lists:map(F, HurtList),
            {ok, BinData} = pt_471:write(47109, [List]),
            % ?MYLOG("hjhboss1", "send_role_sboss_hurt_info List:~p ~n", [List]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]);
        _ ->
            skip
    end,
    ok.

%% 获得击杀数量
get_kill_count(State, ZoneId) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    case maps:get(ZoneId, ZoneMap, []) of
        #decoration_boss_zone{kill_count = KillCount} -> KillCount;
        _ -> 0
    end.

%% 增加掉落日志
add_drop_log(State, RoleId, ServerId, ServerNum, Name, BossId, GoodsInfoL) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    ZoneId = get_zone_id(ServerId),
    case maps:get(ZoneId, ZoneMap, []) of
        #decoration_boss_zone{drop_log_list = DropLogList} = Zone -> 
            NowTime = utime:unixtime(),
            AddDropLogList = [{RoleId, ServerId, ServerNum, Name, BossId, GoodsId, Num, Rating, Attr, NowTime}
                ||{GoodsId, Num, Rating, Attr}<-GoodsInfoL],
            NewDropLogList = lists:sublist(AddDropLogList++DropLogList, ?DECORATION_BOSS_KV_DROP_LOG_LEN),
            % ?MYLOG("hjhboss", "EVENT_GOODS_DROP NewDropLogList:~p ~n", [NewDropLogList]),
            NewZone = Zone#decoration_boss_zone{drop_log_list = NewDropLogList},
            NewZoneMap = maps:put(ZoneId, NewZone, ZoneMap),
            NewState = State#decoration_boss_center{zone_map = NewZoneMap},
            packet_to_local(add_drop_log, [ZoneId, AddDropLogList]),
            {ok, NewState};
        _ ->
            {ok, State}
    end.

%% boss复活
reborn_ref(State, ZoneId, BossId) ->
    % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [[ZoneId, BossId]]),
    case get_boss_info(State, ZoneId, BossId) of
        {true, #decoration_boss_zone{zone_id = ZoneId} = Zone, BossMap, Boss} ->
            #decoration_boss{reborn_ref = RebornRef} = Boss,
            util:cancel_timer(RebornRef),
            #base_decoration_boss{scene_id = SceneId, x = X, y = Y} = data_decoration_boss:get_boss(BossId),
            % 先清怪物
            lib_mon:clear_scene_mon_by_mids(SceneId, ZoneId, BossId, 1, [BossId]),
            % 广播复活
            {ok, BinData} = pt_471:write(47107, [BossId]),
            apply_cast_to_zone(ZoneId, lib_server_send, send_to_all, [BinData]),
            % 复活
            lib_mon:async_create_mon(BossId, SceneId, ZoneId, X, Y, 1, BossId, 1, []),
            NewBoss = Boss#decoration_boss{reborn_time = 0, reborn_ref = none},
            NewState = save_boss_info(State, Zone, BossMap, NewBoss),
            % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [[ZoneId, BossId]]),
            packet_to_local(reborn_ref, [ZoneId, NewBoss]),
            case data_mon:get(BossId) of
                #mon{name = BossName, lv = BossLv} -> 
                    apply_cast_to_zone(ZoneId, lib_chat, send_TV, [{all}, ?MOD_DECORATION_BOSS, 3, [BossLv, BossName, BossId]]);
                _ ->
                    skip
            end,
            {ok, NewState};
        _ ->
            % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [State]),
            {ok, State}
    end.

%% 离开定时器
leave_ref(State, ZoneId, BossId) ->
    #decoration_boss_center{role_map = RoleMap} = State,
    case get_boss_info(State, ZoneId, BossId) of
        {true, Zone, BossMap, Boss} ->
            #decoration_boss{leave_ref = LeaveRef} = Boss,
            F = fun(RoleId, #decoration_boss_role{server_id = ServerId, boss_id = TmpBossId, zone_id = TmpZoneId} = Role, TmpRoleMap) ->
                case BossId == TmpBossId andalso ZoneId == TmpZoneId of
                    true ->
                        % 通知本服移除数据
                        slient_remove_role(Role),
                        mod_clusters_center:apply_cast(ServerId, mod_decoration_boss_local, remove_role, [RoleId]),
                        % 离开
                        Args = [RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, leave_ref, [BossId]],
                        mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
                        maps:remove(RoleId, TmpRoleMap);
                    false ->
                        TmpRoleMap
                end
            end,
            NewRoleMap = maps:fold(F, RoleMap, RoleMap),
            % 清理boss
            util:cancel_timer(LeaveRef),
            StateAfBoss = save_boss_info(State, Zone, BossMap, Boss#decoration_boss{leave_ref = none, role_num = 0}),
            StateAfRole = StateAfBoss#decoration_boss_center{role_map = NewRoleMap},
            packet_to_local(leave_ref, [ZoneId, BossId]),
            % ?MYLOG("hjhboss", "leave_ref:~w ~n", [[BossId]]),
            {ok, StateAfRole};
        _ ->
            {ok, State}
    end.

%% 特殊boss刷新时间
sboss_ref(#decoration_boss_center{zone_map = ZoneMap} = State) ->
    % ?MYLOG("hjhboss", "sboss_ref ~n", []),
    F = fun(_ZoneId, Zone) -> do_sboss_ref(Zone) end,
    NewZoneMap = maps:map(F, ZoneMap),
    NewState = State#decoration_boss_center{zone_map = NewZoneMap},
    StateAfRef = calc_sboss_ref(NewState),
    {ok, StateAfRef}.

do_sboss_ref(Zone) ->
    #decoration_boss_zone{zone_id = ZoneId, kill_count = KillCount, is_alive = IsAlive} = Zone,
    NeedCount = ?DECORATION_BOSS_KV_SBOSS_KILL_COUNT,
    SBIsOpen = ?DECORATION_BOSS_KV_SBOSS_OPEN,
    % ?MYLOG("hjhboss", "do_sboss_ref ZoneId:~p KillCount:~p IsAlive:~p ~n", [ZoneId, KillCount, IsAlive]),
    if
        IsAlive == 0 andalso KillCount >= NeedCount andalso SBIsOpen ->
            WorldLv = lib_clusters_center_api:get_max_world_lv(ZoneId),
            db_decoration_boss_zone_replace(ZoneId, 0, WorldLv, 1),
            BossId = ?DECORATION_BOSS_KV_SBOSS_ID,
            SceneId = ?DECORATION_BOSS_KV_SBOSS_SCENE,
            {X, Y} = ?DECORATION_BOSS_KV_SBOSS_XY,
            % 先清怪物
            lib_mon:clear_scene_mon_by_mids(SceneId, ZoneId, BossId, 1, [BossId]),
            lib_mon:async_create_mon(BossId, SceneId, ZoneId, X, Y, 1, BossId, 1, [{auto_lv, WorldLv}]),
            NewZone = Zone#decoration_boss_zone{sboss_id = BossId, sboss_scene_id = SceneId, sboss_hurt_list = [], kill_count = 0, is_alive = 1},
            packet_to_local(sboss_ref, [NewZone]),
            % 广播复活
            {ok, BinData} = pt_471:write(47107, [BossId]),
            apply_cast_to_zone(ZoneId, lib_server_send, send_to_all, [BinData]),
            % 传闻
            apply_cast_to_zone(ZoneId, lib_chat, send_TV, [{all}, ?MOD_DECORATION_BOSS, 2, []]),
            NewZone;
        true ->
            Zone
    end.

%% 特殊boss离开
sleave_ref(State, ZoneId) ->
    % ?MYLOG("hjhboss", "sleave_ref ZoneId:~p ~n", [ZoneId]),
    #decoration_boss_center{zone_map = ZoneMap, role_map = RoleMap} = State,
    case maps:get(ZoneId, ZoneMap, []) of
        #decoration_boss_zone{sboss_id = SbossId, sleave_ref = SLeaveRef} = Zone ->
            F = fun(RoleId, #decoration_boss_role{server_id = ServerId, boss_id = TmpBossId, zone_id = TmpZoneId} = Role, TmpRoleMap) ->
                case lib_decoration_boss_api:is_sboss_id(TmpBossId) andalso TmpZoneId == ZoneId of
                    true ->
                        % 通知本服移除数据
                        slient_remove_role(Role),
                        mod_clusters_center:apply_cast(ServerId, mod_decoration_boss_local, remove_role, [RoleId]),
                        % 离开
                        Args = [RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, sleave_ref, []],
                        mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
                        maps:remove(RoleId, TmpRoleMap);
                    false ->
                        TmpRoleMap
                end
            end,
            NewRoleMap = maps:fold(F, RoleMap, RoleMap),
            % 清理boss
            util:cancel_timer(SLeaveRef),
            NewZone = Zone#decoration_boss_zone{sleave_ref = none, role_num = 0},
            NewZoneMap = maps:put(ZoneId, NewZone, ZoneMap),
            StateAfRole = State#decoration_boss_center{zone_map = NewZoneMap, role_map = NewRoleMap},
            % ?MYLOG("hjhboss", "sleave_ref ~n", []),
            packet_to_local(sleave_ref, [ZoneId, SbossId]),
            {ok, StateAfRole};
        _ ->
            {ok, State}
    end.

%% 玩家死亡
player_die(State, RoleId, ServerId) ->
    #decoration_boss_center{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{scene_id = SceneId, die_ref = OldRef} = Role ->
            % case lib_decoration_boss_api:is_sboss_scene(SceneId) of
            %     true ->
            %         DieTime = ?DECORATION_BOSS_KV_SBOSS_DIE_TIME,
            %         DieRef = util:send_after(OldRef, DieTime*1000, self(), {'die_ref', RoleId, ServerId, SceneId}),
            %         {ok, BinData} = pt_471:write(47116, [utime:unixtime()+DieTime]),
            %         mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            %         NewRole = Role#decoration_boss_role{die_ref = DieRef},
            %         NewRoleMap = maps:put(RoleId, NewRole, RoleMap);
            %     false ->
            %         NewRoleMap = RoleMap
            % end,
            case lib_decoration_boss_api:is_sboss_scene(SceneId) of
                true -> DieTime = ?DECORATION_BOSS_KV_SBOSS_DIE_TIME;
                false -> DieTime = ?DECORATION_BOSS_KV_BOSS_DIE_TIME
            end,
            DieRef = util:send_after(OldRef, DieTime*1000, self(), {'die_ref', RoleId, ServerId, SceneId}),
            {ok, BinData} = pt_471:write(47116, [utime:unixtime()+DieTime]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            NewRole = Role#decoration_boss_role{die_ref = DieRef},
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
%%            NewRoleMap1 = deal_assist_status2(Killer, NewRoleMap),
            NewState = State#decoration_boss_center{role_map = NewRoleMap},
            {ok, NewState};
        _ ->
            {ok, State}
    end.

%% 死亡定时器
die_ref(State, RoleId, ServerId, SceneId) ->
    #decoration_boss_center{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{scene_id = SceneId, zone_id = ZoneId, boss_id = BossId, die_ref = OldRef} = Role ->
            case lib_decoration_boss_api:is_sboss_scene(SceneId) of
                true ->
                    % 通知本服移除数据
                    slient_remove_role(Role),
                    mod_clusters_center:apply_cast(ServerId, mod_decoration_boss_local, remove_role, [RoleId]),
                    % 离开
                    Args = [RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, die_ref, []],
                    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
                    NewRoleMap = maps:remove(RoleId, RoleMap);
                false ->
                    util:cancel_timer(OldRef),
                    NewRole = Role#decoration_boss_role{die_ref = none},
                    Args = [RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, die_ref, []],
                    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
                    NewRoleMap = maps:put(RoleId, NewRole, RoleMap)
            end,
            NewState = State#decoration_boss_center{role_map = NewRoleMap},
            StateAfDel = del_role_num(NewState, ZoneId, BossId, 1),
            {ok, StateAfDel};
        _ ->
            {ok, State}
    end.

%% 复活
revive(State, RoleId, ServerId) ->
    #decoration_boss_center{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{scene_id = _SceneId, die_ref = OldRef, zone_id = ZoneId, boss_id = BossId} = Role ->
            % case lib_decoration_boss_api:is_sboss_scene(SceneId) of
            %     true ->
            %         util:cancel_timer(OldRef),
            %         NewRole = Role#decoration_boss_role{die_ref = none},
            %         {ok, BinData} = pt_471:write(47116, [0]),
            %         mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            %         NewRoleMap = maps:put(RoleId, NewRole, RoleMap);
            %     false ->
            %         NewRoleMap = RoleMap
            % end,
            util:cancel_timer(OldRef),
            NewRole = Role#decoration_boss_role{die_ref = none},
            {ok, BinData} = pt_471:write(47116, [0]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
            State1 = State#decoration_boss_center{role_map = NewRoleMap},
            NewState = add_role_num(State1, ZoneId, BossId, 1),
            {ok, NewState};
        _ ->
            {ok, State}
    end.

%% 静默移除玩家数据的操作,处理清理操作(不返回值)
slient_remove_role(State, RoleId) ->
    #decoration_boss_center{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, []) of
        [] -> skip;
        Role -> slient_remove_role(Role)
    end.

slient_remove_role(#decoration_boss_role{die_ref = OldDieRef}) ->
    util:cancel_timer(OldDieRef).

%% 区域开始重置
reset_start(State) ->
    % ?MYLOG("hjhboss", "reset_start ~n", []),
    mod_clusters_center:apply_to_all_node(mod_decoration_boss_local, reset_start, []),
    #decoration_boss_center{zone_map = ZoneMap, role_map = RoleMap} = State,
    spawn(fun() -> db_decoration_boss_zone_delete() end),
    F = fun(ZoneId, #decoration_boss_zone{boss_map = BossMap, sleave_ref = SleaveRef, sboss_scene_id = SBossSceneId, sboss_id = SbossId}, ZoneAcc) ->
        util:cancel_timer(SleaveRef),
        case SBossSceneId > 0 of
            true -> lib_scene:clear_scene_room(SBossSceneId, ZoneId, SbossId);
            false -> skip
        end,
        F2 = fun(BossId, #decoration_boss{scene_id = SceneId, leave_ref = LeaveRef, reborn_ref = RebornRef}, BossAcc) ->
            util:cancel_timer(LeaveRef),
            util:cancel_timer(RebornRef),
            lib_scene:clear_scene_room(SceneId, ZoneId, BossId),
            BossAcc
        end,
        maps:fold(F2, ok, BossMap),
        ZoneAcc
    end,
    maps:fold(F, ok, ZoneMap),
    F3 = fun(_RoleId, #decoration_boss_role{role_id = RoleId, server_id = ServerId} = Role, RoleAcc) -> 
        slient_remove_role(Role),
        Args = [RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, zone_reset_start, []],
        mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
        RoleAcc
    end,
    maps:fold(F3, ok, RoleMap),
    NewState = State#decoration_boss_center{act_status = ?DECORATION_BOSS_ACT_STATUS_ALLOCATE, zone_map = #{}, role_map = #{}},
    {ok, NewState}.

%% 区域结束重置
reset_end(State) ->
    % ?MYLOG("hjhboss", "reset_end ~n", []),
    mod_clusters_center:apply_to_all_node(mod_decoration_boss_local, reset_end, []),
    NewState = State#decoration_boss_center{act_status = ?DECORATION_BOSS_ACT_STATUS_OPEN},
    {ok, NewState}.

%% 幻饰特殊boss伤害
%% @param HurtList [#decoration_boss_hurt{},...]
%% @param BelongList [{RoleId, ServerId, RankNo},..]
log_decoration_sboss_hurt(ZoneId, HurtList, BelongList) ->
    F = fun(#decoration_boss_hurt{role_id = RoleId, name = Name, server_id = ServerId, hurt = Hurt}, RankNo) ->
        case lists:keymember(RoleId, 1, BelongList) of
            true -> IsBelong = 1;
            false -> IsBelong = 0
        end,
        lib_log_api:log_decoration_sboss_hurt(RoleId, Name, ServerId, ZoneId, Hurt, RankNo, IsBelong),
        RankNo + 1
    end,
    lists:foldl(F, 1, HurtList),
    ok.

%% 幻饰boss区域信息
db_decoration_boss_zone_select(ZoneId) ->
    Sql = io_lib:format(?sql_decoration_boss_zone_select, [ZoneId]),
    db:get_row(Sql).

db_decoration_boss_zone_replace(ZoneId, KillCount, WorldLv, IsAlive) ->
    Sql = io_lib:format(?sql_decoration_boss_zone_replace, [ZoneId, KillCount, WorldLv, IsAlive]),
    db:execute(Sql).

db_decoration_boss_zone_delete() ->
    Sql = io_lib:format(?sql_decoration_boss_zone_delete, []),
    db:execute(Sql).

%% 直接刷新特殊boss
gm_sboss_ref(#decoration_boss_center{zone_map = ZoneMap} = State) ->
    % ?MYLOG("hjhboss", "gm_sboss_ref ZoneMap:~p~n", [ZoneMap]),
    F = fun(_ZoneId, Zone) -> do_gm_sboss_ref(Zone) end,
    NewZoneMap = maps:map(F, ZoneMap),
    NewState = State#decoration_boss_center{zone_map = NewZoneMap},
    StateAfRef = calc_sboss_ref(NewState),
    {ok, StateAfRef}.

do_gm_sboss_ref(Zone) ->
    #decoration_boss_zone{zone_id = ZoneId, is_alive = IsAlive} = Zone,
    % ?MYLOG("hjhboss", "do_gm_sboss_ref ZoneId:~p IsAlive:~p ~n", [ZoneId, IsAlive]),
    if
        IsAlive == 0 ->
            WorldLv = lib_clusters_center_api:get_max_world_lv(ZoneId),
            db_decoration_boss_zone_replace(ZoneId, 0, WorldLv, 1),
            BossId = ?DECORATION_BOSS_KV_SBOSS_ID,
            SceneId = ?DECORATION_BOSS_KV_SBOSS_SCENE,
            {X, Y} = ?DECORATION_BOSS_KV_SBOSS_XY,
            % 先清怪物
            lib_mon:clear_scene_mon_by_mids(SceneId, ZoneId, BossId, 1, [BossId]),
            lib_mon:async_create_mon(BossId, SceneId, ZoneId, X, Y, 1, BossId, 1, [{auto_lv, WorldLv}]),
            NewZone = Zone#decoration_boss_zone{sboss_id = BossId, sboss_scene_id = SceneId, sboss_hurt_list = [], kill_count = 0, is_alive = 1},
            packet_to_local(sboss_ref, [NewZone]),
            % 广播复活
            {ok, BinData} = pt_471:write(47107, [BossId]),
            apply_cast_to_zone(ZoneId, lib_server_send, send_to_all, [BinData]),
            % 传闻
            apply_cast_to_zone(ZoneId, lib_chat, send_TV, [{all}, ?MOD_DECORATION_BOSS, 2, []]),
            NewZone;
        true ->
            Zone
    end.

%% 秘籍复活
%% boss复活
gm_reborn_ref(State) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    F = fun(ZoneId, Zone, ZoneState) ->
        #decoration_boss_zone{boss_map = BossMap} = Zone,
        F2 = fun(BossId, _Boss, BossState) ->
            % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [[ZoneId, BossId]]),
            case get_boss_info(BossState, ZoneId, BossId) of
                {true, #decoration_boss_zone{zone_id = ZoneId} = Zone, BossMap, 
                        #decoration_boss{reborn_time = RebornTime} = Boss} when RebornTime > 0 ->
                    #decoration_boss{reborn_ref = RebornRef} = Boss,
                    util:cancel_timer(RebornRef),
                    #base_decoration_boss{scene_id = SceneId, x = X, y = Y} = data_decoration_boss:get_boss(BossId),
                    % 先清怪物
                    lib_mon:clear_scene_mon_by_mids(SceneId, ZoneId, BossId, 1, [BossId]),
                    % 广播复活
                    {ok, BinData} = pt_471:write(47107, [BossId]),
                    apply_cast_to_zone(ZoneId, lib_server_send, send_to_all, [BinData]),
                    % 复活
                    lib_mon:async_create_mon(BossId, SceneId, ZoneId, X, Y, 1, BossId, 1, []),
                    NewBoss = Boss#decoration_boss{reborn_time = 0, reborn_ref = none},
                    NewBossState = save_boss_info(BossState, Zone, BossMap, NewBoss),
                    % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [[ZoneId, BossId]]),
                    packet_to_local(reborn_ref, [ZoneId, NewBoss]),
                    case data_mon:get(BossId) of
                        #mon{name = BossName, lv = BossLv} -> 
                            apply_cast_to_zone(ZoneId, lib_chat, send_TV, [{all}, ?MOD_DECORATION_BOSS, 3, [BossLv, BossName, BossId]]);
                        _ ->
                            skip
                    end,
                    NewBossState;
                _ ->
                    % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [State]),
                    BossState
            end
        end,
        maps:fold(F2, ZoneState, BossMap)
    end,
    NewState = maps:fold(F, State, ZoneMap),
    {ok, NewState}.

%% 秘籍修复复活
gm_fix_reborn(State) ->
    #decoration_boss_center{zone_map = ZoneMap} = State,
    F = fun(ZoneId, Zone, ZoneState) ->
        #decoration_boss_zone{boss_map = BossMap} = Zone,
        F2 = fun(BossId, _Boss, BossState) ->
            % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [[ZoneId, BossId]]),
            case get_boss_info(BossState, ZoneId, BossId) of
                {true, #decoration_boss_zone{zone_id = ZoneId} = Zone, BossMap, 
                        #decoration_boss{reborn_time = RebornTime} = Boss} when RebornTime == 0 ->
                    #base_decoration_boss{scene_id = SceneId, x = X, y = Y} = data_decoration_boss:get_boss(BossId),
                    % 怪物没有死亡,但是找不到怪物,复活它
                    case lib_mon:get_scene_mon_by_mids(SceneId, ZoneId, BossId, [BossId], [#scene_object.id, #scene_object.aid]) of 
                        [[_AutoId, Aid]] -> ok; _ -> Aid = 0
                    end,
                    %?PRINT("SceneId:~p, ZoneId:~p, BossId :~p, Aid:~p~n", [SceneId, ZoneId, BossId, Aid]),
                    case misc:is_process_alive(Aid) of
                        false ->
                            #decoration_boss{reborn_ref = RebornRef} = Boss,
                            util:cancel_timer(RebornRef),
                            % 先清怪物
                            lib_mon:clear_scene_mon_by_mids(SceneId, ZoneId, BossId, 1, [BossId]),
                            % 广播复活
                            {ok, BinData} = pt_471:write(47107, [BossId]),
                            apply_cast_to_zone(ZoneId, lib_server_send, send_to_all, [BinData]),
                            % 复活
                            lib_mon:async_create_mon(BossId, SceneId, ZoneId, X, Y, 1, BossId, 1, []),
                            NewBoss = Boss#decoration_boss{reborn_time = 0, reborn_ref = none},
                            NewBossState = save_boss_info(BossState, Zone, BossMap, NewBoss),
                            % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [[ZoneId, BossId]]),
                            packet_to_local(reborn_ref, [ZoneId, NewBoss]),
                            case data_mon:get(BossId) of
                                #mon{name = BossName, lv = BossLv} -> 
                                    apply_cast_to_zone(ZoneId, lib_chat, send_TV, [{all}, ?MOD_DECORATION_BOSS, 3, [BossLv, BossName, BossId]]);
                                _ ->
                                    skip
                            end,
                            NewBossState;
                        _E ->
                            BossState
                    end;
                _ ->
                    % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [State]),
                    BossState
            end
        end,
        maps:fold(F2, ZoneState, BossMap)
    end,
    NewState = maps:fold(F, State, ZoneMap),
    {ok, NewState}.

set_enter_type(State, RoleId, EnterType) ->
    #decoration_boss_center{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of 
        #decoration_boss_role{enter_type = OEnterType, server_id = ServerId} = Role when EnterType =/= OEnterType ->
            NewRole = Role#decoration_boss_role{enter_type = EnterType},
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
            NewState = State#decoration_boss_center{role_map = NewRoleMap},
            send_battle_info(NewState, RoleId, ServerId),
            {ok, NewState};
        _ ->
            {ok, State}
    end.