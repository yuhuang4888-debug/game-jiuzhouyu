%% ---------------------------------------------------------------------------
%% @doc lib_decoration_boss_local.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-14
%% @deprecated 幻饰boss 本地
%% ---------------------------------------------------------------------------
-module(lib_decoration_boss_local).
-compile(export_all).

-include("decoration_boss.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("drop.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("battle.hrl").
-include("server.hrl").

%% 初始化
init() ->
    BossMap = lib_decoration_boss_util:init_boss_map(?CLS_TYPE_GAME),
    ?PRINT("bOSSMAP:~p~n", [BossMap]),
    #decoration_boss_local{boss_map = BossMap, is_gm_stop = ?GM_OPEN_MOD}.

%% 同步数据
init_sync_callback(State, single_play) ->
    #decoration_boss_local{init_def = InitDef} = State,
    util:cancel_timer(InitDef),
    NewState = State#decoration_boss_local{is_init = ?IS_INIT, init_def = undefined},
    {ok, NewState};
init_sync_callback(State, List) ->
    #decoration_boss_local{boss_map = BossMap, init_def = InitDef} = State,
    [SyncCBossMap, KillLog, SBossId, SBossSceneId, SBossHurtList, SHp, SHpLim, KillCount, IsAlive, DropLogList] = List,
    NewBossMap = maps:merge(BossMap, SyncCBossMap),
    util:cancel_timer(InitDef),
    NewState = State#decoration_boss_local{
        boss_map = NewBossMap
        , kill_log = KillLog
        , sboss_id = SBossId
        , sboss_scene_id = SBossSceneId
        , sboss_hurt_list = SBossHurtList
        , shp = SHp
        , shp_lim = SHpLim
        , kill_count = KillCount
        , is_alive = IsAlive
        , drop_log_list = DropLogList
        , is_init = ?IS_INIT
        , init_def = undefined
    },
    % ?MYLOG("hjhboss", "sync_update CBossMap:~p, BossMap:~p, NewBossMap:~p ~n", [CBossMap, BossMap, NewBossMap]),
    {ok, NewState}.
sync_update(State, CBossMap, KillLog, SBossId, SBossSceneId, SBossHurtList, SHp, SHpLim, KillCount, IsAlive, DropLogList) ->
    #decoration_boss_local{boss_map = BossMap} = State,
    NewBossMap = maps:merge(BossMap, CBossMap),
    NewState = State#decoration_boss_local{
        boss_map = NewBossMap
        , kill_log = KillLog
        , sboss_id = SBossId
        , sboss_scene_id = SBossSceneId
        , sboss_hurt_list = SBossHurtList
        , shp = SHp
        , shp_lim = SHpLim
        , kill_count = KillCount
        , is_alive = IsAlive
        , drop_log_list = DropLogList
        },
    % ?MYLOG("hjhboss", "sync_update CBossMap:~p, BossMap:~p, NewBossMap:~p ~n", [CBossMap, BossMap, NewBossMap]),
    {ok, NewState}.

%% 同步数据
sync_update(State, KvList) ->
    NewState = do_sync_update(KvList, State),
    {ok, NewState}.

do_sync_update([], State) -> State;

do_sync_update([{enter_boss, RoleId, ServerId, BossId}|T], State) ->
    #decoration_boss_local{boss_map = BossMap} = State,
    case maps:get(BossId, BossMap, []) of
        [] -> NewBossMap = BossMap;
        #decoration_boss{assist_list = AssistList} = Boss ->
            NewBoss = Boss#decoration_boss{assist_list = [{RoleId, ServerId}|lists:keydelete(RoleId, 1, AssistList)]},
            NewBossMap = maps:put(BossId, NewBoss, BossMap)
    end,
    NewState = State#decoration_boss_local{boss_map = NewBossMap},
    do_sync_update(T, NewState);

%% 击杀数量
do_sync_update([{kill_count, KillCount}|T], State) ->
    NewState = State#decoration_boss_local{kill_count = KillCount},
    do_sync_update(T, NewState);

do_sync_update([{kill_mon, BossId, RebornTime, KillCount}|T], State) ->
    #decoration_boss_local{boss_map = BossMap} = State,
    case maps:get(BossId, BossMap, []) of
        [] -> NewBossMap = BossMap;
        Boss ->
            NewBoss = Boss#decoration_boss{assist_list = [], reborn_time = RebornTime},
            NewBossMap = maps:put(BossId, NewBoss, BossMap)
    end,
    NewState = State#decoration_boss_local{boss_map = NewBossMap, kill_count = KillCount},
    do_sync_update(T, NewState);

do_sync_update([{kill_sboss}|T], State) ->
    NewState = State#decoration_boss_local{is_alive = 0},
    do_sync_update(T, NewState);

% 普通boss复活
do_sync_update([{reborn_ref, BossId}|T], State) ->
    #decoration_boss_local{boss_map = BossMap} = State,
    case maps:get(BossId, BossMap, []) of
        [] -> NewBossMap = BossMap;
        Boss ->
            NewBoss = Boss#decoration_boss{reborn_time = 0},
            NewBossMap = maps:put(BossId, NewBoss, BossMap)
    end,
    NewState = State#decoration_boss_local{boss_map = NewBossMap},
    do_sync_update(T, NewState);

% 特殊boss复活
do_sync_update([{sboss_ref, SBossId, SBossSceneId, KillCount, IsAlive}|T], State) ->
    NewState = State#decoration_boss_local{sboss_id = SBossId, sboss_scene_id = SBossSceneId, kill_count = KillCount, is_alive = IsAlive},
    do_sync_update(T, NewState);

do_sync_update([{add_drop_log, AddDropLogList}|T], State) ->
    #decoration_boss_local{drop_log_list = DropLogList} = State,
    NewDropLogList = lists:sublist(AddDropLogList++DropLogList, ?DECORATION_BOSS_KV_DROP_LOG_LEN),
    NewState = State#decoration_boss_local{drop_log_list = NewDropLogList},
    do_sync_update(T, NewState);

do_sync_update([{act_status, ActStatus}|T], State) ->
    NewState = State#decoration_boss_local{act_status = ActStatus},
    do_sync_update(T, NewState);

do_sync_update([{role_num, BossId, Num}|T], State) ->
    NewState = set_role_num(State, BossId, Num),
    do_sync_update(T, NewState);

do_sync_update([{leave_ref, BossId}|T], State) ->
    NewState = set_role_num(State, BossId, 0),
    do_sync_update(T, NewState);

do_sync_update([{sleave_ref, SBossId}|T], State) ->
    NewState = set_role_num(State, SBossId, 0),
    do_sync_update(T, NewState);

do_sync_update([_|T], State) ->
    do_sync_update(T, State).

%% 运营关闭活动入口，踢出场景玩家
cheats_stop_act(State, Status) ->
    #decoration_boss_local{role_map = RoleMap} = State,
    ServerId = config:get_server_id(),
    maps:map(
        fun(_, Role) ->
            #decoration_boss_role{role_id = RoleId, server_id = RSId, die_ref = DieRef} = Role,
            util:cancel_timer(DieRef),
            case RSId of
                ServerId ->     %% 只处理本服玩家
                    KV = [{group, 0}, {is_hurt_mon, 1}, {action_free, ?ERRCODE(err471_not_change_scene_on_decoration_boss)}, {change_scene_hp_lim, 1}],
                    Args = [0, 0, 0, 0, 0, true, KV],
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_scene, change_scene, Args),
                    mod_decoration_boss_local:quit(RoleId, ServerId);
                _ -> skip
            end
        end,
        RoleMap),
    {ok, State#decoration_boss_local{is_gm_stop = Status}}.

%% 幻饰boss信息
send_info(State, RoleId, Count, AssistCount, BuyCount, AddCount, InBuff) ->
    #decoration_boss_local{act_status = ActStatus, boss_map = BossMap, kill_count = KillCount, is_alive = IsAlive, role_num = SRoleNum} = State,
    F = fun(BossId, Boss, List) ->
        #decoration_boss{reborn_time = RebornTime, role_num = RoleNum, assist_list = AssistList} = Boss,
        IsHadAssist = ?IF(lists:keymember(RoleId, 1, AssistList), 1, 0),
        [{BossId, RebornTime, RoleNum, IsHadAssist}|List]
    end,
    List = maps:fold(F, [], BossMap),
    {ok, BinData} = pt_471:write(47101, [ActStatus, Count, AssistCount, BuyCount, AddCount, InBuff, KillCount, IsAlive, SRoleNum, List]),
    lib_server_send:send_to_uid(RoleId, BinData),
%%    ?MYLOG("lzhboss", "[ActStatus, Count, AssistCount, BuyCount, AddCount, KillCount, IsAlive, SRoleNum, List]:~w ~n",
%%        [[ActStatus, Count, AssistCount, BuyCount, AddCount, KillCount, IsAlive, SRoleNum, List]]),
    ok.

%% 检查进入boss
check_and_enter_boss(State = #decoration_boss_local{is_gm_stop = ?GM_CLOSE_MOD}, RoleId, _ServerId, _BossId, _Type) ->
    {ok, BinData} = pt_471:write(47102, [?ERR_GM_STOP, _BossId, _Type]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};
check_and_enter_boss(State, RoleId, ServerId, BossId, Type) ->
    #decoration_boss_local{boss_map = BossMap} = State,
    case maps:get(BossId, BossMap, []) of
        #decoration_boss{reborn_time = RebornTime} when RebornTime > 0 ->
            {ok, BinData} = pt_471:write(47102, [?ERRCODE(err471_boss_die_not_to_enter), BossId, Type]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, State};
        #decoration_boss{cls_type = ?CLS_TYPE_GAME} = Boss ->
            % ?MYLOG("hjhboss", "[RoleId, ServerId, BossId, Type]:~w ~n", [[RoleId, ServerId, BossId, Type]]),
            check_and_enter_boss_local(State, RoleId, BossId, Type, Boss);
        #decoration_boss{cls_type = ?CLS_TYPE_CENTER} ->
            mod_decoration_boss_center:cast_center([{'check_and_enter_boss', RoleId, ServerId, BossId, Type}]),
            {ok, State};
        _ ->
            {ok, BinData} = pt_471:write(47102, [?ERRCODE(err471_no_boss_cfg), BossId, Type]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, State}
    end.

check_and_enter_boss_local(State, RoleId, BossId, Type, Boss) ->
    #decoration_boss{scene_id = SceneId, assist_list = AssistList} = Boss,
    case mod_scene_agent:apply_call(SceneId, 0, lib_decoration_boss_util, check_and_enter_on_scene, [BossId]) of
        Num when is_integer(Num) ->
            #base_decoration_boss{role_num = RoleNum} = data_decoration_boss:get_boss(BossId),
            case Num >= RoleNum of
                true ->
                    {ok, BinData} = pt_471:write(47102, [?ERRCODE(err471_max_role_num), BossId, Type]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                false ->
                    IsHadAssist = lists:keymember(RoleId, 1, AssistList),
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, enter_boss, [BossId, Type, ?CLS_TYPE_GAME, SceneId, IsHadAssist])
            end,
            NewState = set_role_num(State, BossId, Num),
            {ok, NewState};
        _ ->
            {ok, BinData} = pt_471:write(47102, [?ERRCODE(err471_max_role_num), BossId, Type]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, State}
    end.

%% 进入boss
enter_boss(State, Role) ->
    #decoration_boss_local{role_map = RoleMap} = State,
    #decoration_boss_role{role_id = RoleId, cls_type = ClsType} = Role,
    NewRoleMap = maps:put(RoleId, Role, RoleMap),
    NewState = State#decoration_boss_local{role_map = NewRoleMap},
    case ClsType == ?CLS_TYPE_GAME of
        true -> enter_boss_local(NewState, Role);
        false ->
            mod_decoration_boss_center:cast_center([{'enter_boss', Role}]),
            {ok, NewState}
    end.

enter_boss_local(State, Role) ->
    #decoration_boss_role{role_id = RoleId, server_id = ServerId, boss_id = BossId, scene_id = SceneId, x = X, y = Y, enter_type = EnterType} = Role,
    slient_remove_role(State, RoleId),
    case EnterType == ?DECORATION_BOSS_ENTER_TYPE_NORMAL orelse EnterType == ?DECORATION_BOSS_ENTER_TYPE_GUILD_ASSIST of
        true -> EnterTypeKvL = [{is_hurt_mon, 1}];
        false -> EnterTypeKvL = [{is_hurt_mon, 0}]
    end,
    KeyValueList = [{change_scene_hp_lim, 0}, {action_lock, ?ERRCODE(err471_not_change_scene_on_decoration_boss)}|EnterTypeKvL],
    lib_scene:player_change_scene(RoleId, SceneId, 0, BossId, X, Y, true, KeyValueList),
    NewState = add_role_num(State, BossId, 1),
    % 协助记录
    #decoration_boss_local{boss_map = BossMap} = NewState,
    case maps:get(BossId, BossMap, []) of
        #decoration_boss{assist_list = AssistList} = Boss when EnterType == ?DECORATION_BOSS_ENTER_TYPE_ASSIST ->
            NewAssisList = [{RoleId, ServerId}|lists:keydelete(RoleId, 1, AssistList)],
            NewBoss = Boss#decoration_boss{assist_list = NewAssisList},
            NewBossMap = maps:put(BossId, NewBoss, BossMap),
            AssistState = NewState#decoration_boss_local{boss_map = NewBossMap};
        _ ->
            AssistState = NewState
    end,
    % 成功进入
    {ok, BinData} = pt_471:write(47102, [?SUCCESS, BossId, EnterType]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, AssistState}.

%% 设置人数
set_role_num(State, BossId, Num) ->
    case lib_decoration_boss_api:is_sboss_id(BossId) of
        true ->
            State#decoration_boss_local{role_num = Num};
        false ->
            #decoration_boss_local{boss_map = BossMap} = State,
            case maps:get(BossId, BossMap, []) of
                #decoration_boss{} = Boss ->
                    NewBoss = Boss#decoration_boss{role_num = Num},
                    NewBossMap = maps:put(BossId, NewBoss, BossMap),
                    State#decoration_boss_local{boss_map = NewBossMap};
                _ ->
                    State
            end
    end.

%% 增加人数
add_role_num(State, BossId, Num) ->
    #decoration_boss_local{boss_map = BossMap} = State,
    case maps:get(BossId, BossMap, []) of
        #decoration_boss{role_num = OldNum} = Boss ->
            NewBoss = Boss#decoration_boss{role_num = OldNum+Num},
            NewBossMap = maps:put(BossId, NewBoss, BossMap),
            State#decoration_boss_local{boss_map = NewBossMap};
        _ ->
            State
    end.

%% 减少人数
del_role_num(State, BossId, Num) ->
    #decoration_boss_local{boss_map = BossMap} = State,
    case maps:get(BossId, BossMap, []) of
        #decoration_boss{role_num = OldNum} = Boss ->
            NewBoss = Boss#decoration_boss{role_num = max(OldNum-Num, 0)},
            NewBossMap = maps:put(BossId, NewBoss, BossMap),
            State#decoration_boss_local{boss_map = NewBossMap};
        _ ->
            State
    end.

%% 退出
quit(State, RoleId, ServerId) ->
    #decoration_boss_local{role_map = RoleMap} = State,
    slient_remove_role(State, RoleId),
    NewRoleMap = maps:remove(RoleId, RoleMap),
    NewState = State#decoration_boss_local{role_map = NewRoleMap},
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{cls_type = ?CLS_TYPE_CENTER} ->
            mod_decoration_boss_center:cast_center([{'quit', RoleId, ServerId}]),
            DelState = NewState;
        #decoration_boss_role{boss_id = BossId, cls_type = ?CLS_TYPE_GAME} = Role ->
            deal_assist_status(Role),
            DelState = del_role_num(NewState, BossId, 1);
        _ ->
            DelState = NewState
    end,
    {ok, DelState}.

%% 处理协助
%% 协助规则：1.帮助发起人击杀其他玩家后，协助完成，扣除次数，此时退出场景有协助奖励
%%          2.以协助状态进入场景，Boss死亡后在场景，协助完成，获取奖励，扣除次数
deal_assist_status(Role) ->
    case Role of
        #decoration_boss_role{
            enter_type = ?DECORATION_BOSS_ENTER_TYPE_ASSIST,
            success_assist = ?ASSISTED, role_id = RoleId,
            boss_id = BossId
        } ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, send_boss_reward, [#mon_args{mid = BossId}, ?DECORATION_BOSS_ENTER_TYPE_ASSIST, 0, 0, 0]);
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


%% 发送掉落日志
send_log_list(State, RoleId) ->
    #decoration_boss_local{drop_log_list = DropLogList} = State,
    % ?MYLOG("hjhboss", "send_log_list DropLogList:~p ~n", [DropLogList]),
    {ok, BinData} = pt_471:write(47108, [DropLogList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

%% 进入特殊boss
enter_sboss(State, Role) ->
    #decoration_boss_local{role_map = RoleMap} = State,
    #decoration_boss_role{role_id = RoleId} = Role,
    slient_remove_role(State, RoleId),
    NewRoleMap = maps:put(RoleId, Role, RoleMap),
    NewState = State#decoration_boss_local{role_map = NewRoleMap},
    mod_decoration_boss_center:cast_center([{'enter_sboss', Role}]),
    {ok, NewState}.

%% 战斗信息
send_battle_info(State, RoleId, ServerId) ->
    #decoration_boss_local{role_map = RoleMap, boss_map = BossMap} = State,
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{enter_type = EnterType, boss_id = BossId, cls_type = ?CLS_TYPE_GAME, die_ref = DieRef} ->
            case maps:get(BossId, BossMap, []) of
                #decoration_boss{leave_ref = LeaveRef} ->
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
                    % ?MYLOG("hjhboss", "send_battle_info QuitTime:~p, ReviveTime:~p ~n", [QuitTime, ReviveTime]),
                    {ok, BinData} = pt_471:write(47114, [EnterType, QuitTime, ReviveTime]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                _ ->
                    skip
            end;
        #decoration_boss_role{} ->
            mod_decoration_boss_center:cast_center([{'send_battle_info', RoleId, ServerId}]);
        _ ->
            skip
    end,
    ok.

%% 击杀怪物
kill_mon(State, #mon_args{mid = BossId} = MonArgs, FirstAtter) ->
    #decoration_boss_local{boss_map = BossMap, role_map = RoleMap} = State,
    case maps:get(BossId, BossMap, []) of
        #decoration_boss{cls_type = ?CLS_TYPE_GAME} = Boss ->
            #base_decoration_boss{revive_time = ReviveTime} = data_decoration_boss:get_boss(BossId),
            RebornTime = utime:unixtime() + ReviveTime,
            NewBoss = Boss#decoration_boss{assist_list = [], reborn_time = RebornTime},
            BossAfReborn = calc_boss_reborn_ref(NewBoss),
            BossAfLeave = calc_boss_leave_ref(BossAfReborn),
            NewBossMap = maps:put(BossId, BossAfLeave, BossMap),
            % ?MYLOG("hjhboss", "kill_mon:~w ~n", [[BossId]]),
            F = fun(_RoleId, Role, RoleList) ->
                case Role of
                    #decoration_boss_role{boss_id = BossId} -> [Role|RoleList];
                    _ -> RoleList
                end
            end,
            RoleList = maps:fold(F, [], RoleMap),
            AssitRoleList = send_boss_reward(RoleList, MonArgs, FirstAtter),
            F2 = fun(#decoration_boss_role{role_id = RoleId} = RItem, GrandMap) -> maps:put(RoleId, RItem, GrandMap) end,
            NewRoleMap = lists:foldl(F2, RoleMap, AssitRoleList),
            % 广播死亡
            {ok, BinData} = pt_471:write(47117, [BossId, RebornTime]),
            lib_server_send:send_to_all(BinData),
            NewState = State#decoration_boss_local{boss_map = NewBossMap, role_map = NewRoleMap};
        _ ->
            NewState = State
    end,
    {ok, NewState}.

%% 计算怪物重生定时器
calc_boss_reborn_ref(#decoration_boss{reborn_time = 0, reborn_ref = OldRef} = Boss) ->
    util:cancel_timer(OldRef),
    Boss#decoration_boss{reborn_ref = none};
calc_boss_reborn_ref(Boss) ->
    #decoration_boss{boss_id = BossId, reborn_time = RebornTime, reborn_ref = OldRef} = Boss,
    RebornSpanTime = max(1, RebornTime - utime:unixtime()),
    RebornRef = util:send_after(OldRef, RebornSpanTime * 1000, self(), {'reborn_ref', BossId}),
    Boss#decoration_boss{reborn_ref = RebornRef}.

%% 离开定时器
calc_boss_leave_ref(#decoration_boss{boss_id = BossId, scene_id = SceneId, leave_ref = OldRef} = Boss) ->
    LeaveTime = max(1, ?DECORATION_BOSS_KV_QUIT_TIME),
    LeaveRef = util:send_after(OldRef, LeaveTime * 1000, self(), {'leave_ref', BossId}),
    {ok, BinData} = pt_471:write(47115, [utime:unixtime()+LeaveTime]),
    lib_server_send:send_to_scene(SceneId, 0, BossId, BinData),
    ?PRINT("calc_boss_leave_ref :~p ~n", [utime:unixtime()+LeaveTime]),
    Boss#decoration_boss{leave_ref = LeaveRef}.

%% 发送boss奖励
send_boss_reward(RoleList, MonArgs, FirstAtter) ->
    case FirstAtter of
        #mon_atter{id = FirstId, server_id = ServerId} -> ok;
        _ -> FirstId = 0, ServerId = 0
    end,
    F = fun(RoleItem, GrandRole) ->
        case RoleItem of
            #decoration_boss_role{success_assist = ?ASSISTED2} -> GrandRole;
            _ ->
                #decoration_boss_role{role_id = RoleId, enter_type = EnterType, hurt = Hurt} = RoleItem,
                lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, send_boss_reward, [MonArgs, EnterType, FirstId, ServerId, Hurt]),
                case EnterType of
                    ?DECORATION_BOSS_ENTER_TYPE_NORMAL -> GrandRole;
                    _ -> [RoleItem#decoration_boss_role{success_assist = ?ASSISTED2}|GrandRole]
                end
        end
        end,
    AssistRoles = lists:foldl(F, [], RoleList),
    AssistRoles.

%% 对怪物造成伤害
hurt_mon(State, _BossId, BossHurt) ->
    #decoration_boss_local{role_map = RoleMap} = State,
    #decoration_boss_hurt{role_id = RoleId, hurt = Hurt} = BossHurt,
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{hurt = OldHurt} = Role ->
            NewRole = Role#decoration_boss_role{hurt = Hurt + OldHurt},
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
            NewState = State#decoration_boss_local{role_map = NewRoleMap},
            {ok, NewState};
        _ ->
            {ok, State}
    end.

%% boss复活
reborn_ref(State, BossId) ->
    #decoration_boss_local{boss_map = BossMap} = State,
    case maps:get(BossId, BossMap, []) of
        #decoration_boss{cls_type = ?CLS_TYPE_GAME} = Boss ->
            #decoration_boss{reborn_ref = RebornRef} = Boss,
            util:cancel_timer(RebornRef),
            #base_decoration_boss{scene_id = SceneId, x = X, y = Y} = data_decoration_boss:get_boss(BossId),
            % 先清怪物
            lib_mon:clear_scene_mon_by_mids(SceneId, 0, BossId, 1, [BossId]),
            % 广播复活
            {ok, BinData} = pt_471:write(47107, [BossId]),
            lib_server_send:send_to_all(BinData),
            % 复活
            lib_mon:async_create_mon(BossId, SceneId, 0, X, Y, 1, BossId, 1, []),
            NewBoss = Boss#decoration_boss{reborn_time = 0, reborn_ref = none},
            NewBossMap = maps:put(BossId, NewBoss, BossMap),
            NewState = State#decoration_boss_local{boss_map = NewBossMap},
            case data_mon:get(BossId) of
                #mon{name = BossName, lv = BossLv} ->
                    lib_chat:send_TV({all}, ?MOD_DECORATION_BOSS, 3, [BossLv, BossName, BossId]);
                _ ->
                    skip
            end,
            % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [[BossId]]),
            {ok, NewState};
        _ ->
            {ok, State}
    end.

%% 离开定时器
leave_ref(State, BossId) ->
    #decoration_boss_local{boss_map = BossMap, role_map = RoleMap} = State,
    case maps:get(BossId, BossMap, []) of
        #decoration_boss{cls_type = ?CLS_TYPE_GAME, leave_ref = LeaveRef} = Boss ->
            F = fun(RoleId, #decoration_boss_role{boss_id = TmpBossId} = Role, TmpRoleMap) ->
                case BossId == TmpBossId of
                    true ->
                        slient_remove_role(Role),
                        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, leave_ref, [BossId]),
                        maps:remove(RoleId, TmpRoleMap);
                    false ->
                        TmpRoleMap
                end
            end,
            NewRoleMap = maps:fold(F, RoleMap, RoleMap),
            util:cancel_timer(LeaveRef),
            NewBossMap = maps:put(BossId, Boss#decoration_boss{role_num = 0, leave_ref = none}, BossMap),
            NewState = State#decoration_boss_local{role_map = NewRoleMap, boss_map = NewBossMap},
            % ?MYLOG("hjhboss", "leave_ref:~w ~n", [[BossId]]),
            {ok, NewState};
        _ ->
            {ok, State}
    end.

%% 移除玩家信息
remove_role(State, RoleId) ->
    slient_remove_role(State, RoleId),
    #decoration_boss_local{role_map = RoleMap} = State,
    NewRoleMap = maps:remove(RoleId, RoleMap),
    NewState = State#decoration_boss_local{role_map = NewRoleMap},
    {ok, NewState}.

%% 玩家死亡
player_die(State, RoleId, ServerId) ->
    #decoration_boss_local{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{cls_type = ?CLS_TYPE_CENTER} ->
            mod_decoration_boss_center:cast_center([{'player_die', RoleId, ServerId}]),
            NewState = State;
        #decoration_boss_role{scene_id = SceneId, die_ref = OldRef} = Role ->
            DieTime = ?DECORATION_BOSS_KV_BOSS_DIE_TIME,
            DieRef = util:send_after(OldRef, DieTime*1000, self(), {'die_ref', RoleId, ServerId, SceneId}),
            {ok, BinData} = pt_471:write(47116, [utime:unixtime()+DieTime]),
            lib_server_send:send_to_uid(RoleId, BinData),
            NewRole = Role#decoration_boss_role{die_ref = DieRef},
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
%%            NewRoleMap1 = deal_assist_status2(Killer, NewRoleMap),
            NewState = State#decoration_boss_local{role_map = NewRoleMap};
        _ ->
            NewState = State
    end,
    {ok, NewState}.

%% 死亡定时器
die_ref(State, RoleId, _ServerId, SceneId) ->
    #decoration_boss_local{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{cls_type = ?CLS_TYPE_GAME, scene_id = SceneId, die_ref = OldRef} = Role ->
            % 死亡定时器
            util:cancel_timer(OldRef),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_decoration_boss, die_ref, []),
            NewRole = Role#decoration_boss_role{die_ref = none},
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
            NewState = State#decoration_boss_local{role_map = NewRoleMap},
            {ok, NewState};
        _ ->
            {ok, State}
    end.

%% 复活
revive(State, RoleId, ServerId) ->
    #decoration_boss_local{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, []) of
        #decoration_boss_role{cls_type = ?CLS_TYPE_CENTER} ->
            mod_decoration_boss_center:cast_center([{'revive', RoleId, ServerId}]),
            NewState = State;
        #decoration_boss_role{cls_type = ?CLS_TYPE_GAME, die_ref = OldRef} = Role ->
            util:cancel_timer(OldRef),
            NewRole = Role#decoration_boss_role{die_ref = none},
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
            NewState = State#decoration_boss_local{role_map = NewRoleMap};
        _ ->
            NewState = State
    end,
    {ok, NewState}.

%% 静默移除玩家数据的操作,处理清理操作(不返回值)
slient_remove_role(State, RoleId) ->
    #decoration_boss_local{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, []) of
        [] -> skip;
        Role -> slient_remove_role(Role)
    end.

slient_remove_role(#decoration_boss_role{die_ref = OldRef}) ->
    util:cancel_timer(OldRef).

%% 区域开始重置
reset_start(State) ->
    % ?MYLOG("hjhboss", "reset_start ~n", []),
    #decoration_boss_local{boss_map = BossMap, role_map = RoleMap} = State,
    F = fun(BossId, Boss, TmpBossMap) ->
        case Boss of
            #decoration_boss{cls_type = ?CLS_TYPE_GAME} = Boss ->
                maps:put(BossId, Boss, TmpBossMap);
            _ ->
                TmpBossMap
        end
    end,
    NewBossMap = maps:fold(F, #{}, BossMap),
    F2 = fun(RoleId, Role, TmpRoleMap) ->
        case Role of
            #decoration_boss_role{cls_type = ?CLS_TYPE_GAME} ->
                maps:put(RoleId, Role, TmpRoleMap);
            _ ->
                TmpRoleMap
        end
    end,
    NewRoleMap = maps:fold(F2, #{}, RoleMap),
    NewState = State#decoration_boss_local{
        act_status = ?DECORATION_BOSS_ACT_STATUS_ALLOCATE, boss_map = NewBossMap, sboss_id = 0, sboss_scene_id = 0,
        sboss_hurt_list = [], shp = 0, shp_lim = 0, is_alive = 0, drop_log_list = [], role_map = NewRoleMap
        },
    {ok, NewState}.

%% 区域结束重置
reset_end(State) ->
    % ?MYLOG("hjhboss", "reset_end ~n", []),
    NewState = State#decoration_boss_local{act_status = ?DECORATION_BOSS_ACT_STATUS_OPEN},
    % 再次请求数据
    mod_decoration_boss_local:ask_sync_update(),
    {ok, NewState}.

%% 秘籍复活
%% boss复活
gm_reborn_ref(State) ->
    #decoration_boss_local{boss_map = BossMap} = State,
    F = fun(BossId, Boss, TmpState) ->
        case Boss of
            #decoration_boss{cls_type = ?CLS_TYPE_GAME, reborn_time = RebornTime} = Boss when RebornTime > 0 ->
                #decoration_boss{reborn_ref = RebornRef} = Boss,
                util:cancel_timer(RebornRef),
                #base_decoration_boss{scene_id = SceneId, x = X, y = Y} = data_decoration_boss:get_boss(BossId),
                % 先清怪物
                lib_mon:clear_scene_mon_by_mids(SceneId, 0, BossId, 1, [BossId]),
                % 广播复活
                {ok, BinData} = pt_471:write(47107, [BossId]),
                lib_server_send:send_to_all(BinData),
                % 复活
                lib_mon:async_create_mon(BossId, SceneId, 0, X, Y, 1, BossId, 1, []),
                NewBoss = Boss#decoration_boss{reborn_time = 0, reborn_ref = none},
                NewBossMap = maps:put(BossId, NewBoss, BossMap),
                NewTmpState = TmpState#decoration_boss_local{boss_map = NewBossMap},
                % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [[BossId]]),
                case data_mon:get(BossId) of
                    #mon{name = BossName, lv = BossLv} ->
                        lib_chat:send_TV({all}, ?MOD_DECORATION_BOSS, 3, [BossLv, BossName, BossId]);
                    _ ->
                        skip
                end,
                NewTmpState;
            _ ->
                TmpState
        end
    end,
    NewState = maps:fold(F, State, BossMap),
    {ok, NewState}.

%% 秘籍复活
%% boss复活
gm_fix_reborn(State) ->
    #decoration_boss_local{boss_map = BossMap} = State,
    F = fun(BossId, Boss, TmpState) ->
        case Boss of
            #decoration_boss{cls_type = ?CLS_TYPE_GAME, reborn_time = RebornTime} = Boss when RebornTime == 0 ->
                #base_decoration_boss{scene_id = SceneId, x = X, y = Y} = data_decoration_boss:get_boss(BossId),
                ?PRINT("SceneId:~p, ZoneId:~p, BossId :~p ~n", [SceneId, 0, BossId]),
                % 怪物没有死亡,但是找不到怪物,复活它
                case lib_mon:get_scene_mon_by_mids(SceneId, 0, BossId, [BossId], #scene_object.id) of
                    [] ->
                        #decoration_boss{reborn_ref = RebornRef} = Boss,
                        util:cancel_timer(RebornRef),
                        % 先清怪物
                        lib_mon:clear_scene_mon_by_mids(SceneId, 0, BossId, 1, [BossId]),
                        % 广播复活
                        {ok, BinData} = pt_471:write(47107, [BossId]),
                        lib_server_send:send_to_all(BinData),
                        % 复活
                        lib_mon:async_create_mon(BossId, SceneId, 0, X, Y, 1, BossId, 1, []),
                        NewBoss = Boss#decoration_boss{reborn_time = 0, reborn_ref = none},
                        NewBossMap = maps:put(BossId, NewBoss, BossMap),
                        NewTmpState = TmpState#decoration_boss_local{boss_map = NewBossMap},
                        % ?MYLOG("hjhboss", "reborn_ref:~w ~n", [[BossId]]),
                        case data_mon:get(BossId) of
                            #mon{name = BossName, lv = BossLv} ->
                                lib_chat:send_TV({all}, ?MOD_DECORATION_BOSS, 3, [BossLv, BossName, BossId]);
                            _ ->
                                skip
                        end,
                        NewTmpState;
                    _ ->
                        TmpState
                end;
            _ ->
                TmpState
        end
    end,
    NewState = maps:fold(F, State, BossMap),
    {ok, NewState}.

set_enter_type(State, RoleId, EnterType) ->
    #decoration_boss_local{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #decoration_boss_role{enter_type = OEnterType, cls_type = ClsType, server_id = ServerId} = Role when EnterType =/= OEnterType ->
            NewRole = Role#decoration_boss_role{enter_type = EnterType},
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
            NewState = State#decoration_boss_local{role_map = NewRoleMap},
            case ClsType == ?CLS_TYPE_GAME of
                true -> send_battle_info(NewState, RoleId, ServerId);
                false ->
                    mod_decoration_boss_center:cast_center([{'set_enter_type', RoleId, EnterType}])
            end,
            {ok, NewState};
        _ ->
            {ok, State}
    end.
