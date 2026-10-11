%%%-------------------------------------------------------------------
%%% @author lianghaihui
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 11月 2022 1:27
%%%-------------------------------------------------------------------
-module(lib_great_demon_local).

-include("scene.hrl").
-include("kf_great_demon.hrl").
-include("def_fun.hrl").
-include("server.hrl").
-include("common.hrl").
-include("boss.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("team.hrl").
-include("def_module.hrl").
-include("def_vip.hrl").
-include("domain.hrl").
-include("battle.hrl").
-include("guild.hrl").

%% API
-compile(export_all).


%% 玩家进入场景(未进行各种检测)
enter_check(Ps, BossId) ->
    BossOpen = great_demon_boss_open(),
    BossCfg = data_kf_great_demon:get_great_demon_boss_cfg(BossId),
    case BossCfg of
        [] ->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [?ERRCODE(err460_no_boss_cfg)]),
            {ok, Ps};
        #great_demon_boss_info{ scene = CfgScene } when CfgScene == Ps#player_status.scene ->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [?ERRCODE(err120_already_in_scene)]),
            {ok, Ps};
        _ when BossOpen == false ->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [?ERRCODE(err470_boss_not_open)]),
            {ok, Ps};
        _ ->
            case base_enter_check(BossCfg, Ps) of
                {true, Scene, X, Y, Cost} ->
                    CostType = lib_boss:get_boss_consume_type(?BOSS_TYPE_KF_GREAT_DEMON),
                    case lib_goods_api:cost_object_list(Ps, Cost, CostType, "") of
                        {true, NewPs} ->
                            #player_status{id = RoleId, figure = #figure{name = RoleName, lv = RoleLv}, team = #status_team{team_id = TeamId}} = NewPs,
                            #great_demon_boss_info{ layers = Layers } = BossCfg,
                            lib_log_api:log_enter_or_exit_boss(RoleId, RoleName, RoleLv, Layers, ?BOSS_TYPE_KF_GREAT_DEMON, BossId, 0, Cost, 0,
                                Ps#player_status.scene, Ps#player_status.x, Ps#player_status.y, TeamId),
                            ta_agent_fire:log_enter_or_exit_boss(Ps, RoleLv, Layers, BossId, ?BOSS_TYPE_KF_GREAT_DEMON, 0, 0,
                                Ps#player_status.scene, Ps#player_status.x, Ps#player_status.y, TeamId),
                            %% 通过大部分检测，发到本地进程进行最后的校验
                            NeedOut = lib_boss:is_in_outside_scene(Ps#player_status.scene),
                            %% 先异步到本地进程开启疲劳定时等操作
                            EnterRoleInfo = #kf_role_info{
                                role_id = RoleId, name = RoleName, server_id = config:get_server_id(),
                                plat_form = config:get_platform(), server_num = config:get_server_num(),
                                node = mod_disperse:get_clusters_node()
                            },
                            %% 通过了各种检测，最后有本地进程再进行怒气定时器的设置等
                            mod_great_demon_local:enter_scene_after_check(EnterRoleInfo, RoleId,
                                ?BOSS_TYPE_KF_GREAT_DEMON, BossId, Scene, X, Y, NeedOut),
                            {ok, NewPs};
                        {false, Code, NewPs} ->
                            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [Code]),
                            {ok, NewPs}
                    end;
                {false, ErrorCode} ->
                    lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [ErrorCode]),
                    {ok, Ps}
            end
    end.

base_enter_check(BossCfg, Ps) ->
    #great_demon_boss_info{
        condition = Condition, scene = Scene, x = X, y = Y
    } = BossCfg,
    #player_status{
        figure = #figure{vip = VipLv, vip_type = VipType}, id = RoleId
    } = Ps,
    #boss_type{
        count = BaseCount, cost = BaseCostList
    } = data_boss:get_boss_type(?BOSS_TYPE_KF_GREAT_DEMON),
    case check_condition([{team_check, 0}] ++ Condition, Ps) of
        true ->
            VipAddCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?VIP_BOSS_ENTER(?BOSS_TYPE_KF_GREAT_DEMON), VipType, VipLv),
            AllCount = BaseCount + VipAddCount,
            DailyCount = mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_BOSS_ENTER, ?BOSS_TYPE_KF_GREAT_DEMON),
            if
                AllCount - DailyCount =< 0 ->
                    {false, ?ERRCODE(err460_count_max)};
                true ->
                    {Type, GoodsId, Num} =
                        case lists:keyfind(DailyCount + 1, 1, BaseCostList) of
                            false ->
                                {_, [{Type1, GoodsId1, Num1}|_]} = lists:last(lists:keysort(1, BaseCostList)),
                                {Type1, GoodsId1, Num1};
                            {_, [{Type2, GoodsId2, Num2}|_]} ->
                                {Type2, GoodsId2, Num2}
                        end,
                    case data_goods:get_goods_buy_price(GoodsId) of
                        {0, 0} ->
                            {false, ?ERRCODE(err460_not_boss_buy)};
                        {_, Price} ->
                            {TX,TY} =
                                case data_scene:get(Scene) of
                                    #ets_scene{x = _TX, y = _TY} -> {_TX, _TY};
                                    _ -> {X,Y}
                                end,
                            %% 查询物品数量
                            [{_, GNum}|_] = lib_goods_do:goods_num([GoodsId]),
                            if
                                %% 物品足够
                                GNum >= Num ->
                                    {true, Scene, TX, TY, [{Type, GoodsId, Num}]};
                                true ->
                                    MoneyCost = [{?TYPE_BGOLD, 0, round(Price * (Num-GNum))}],
                                    case lib_goods_api:check_object_list(Ps, MoneyCost) of
                                        true ->
                                            if
                                                GNum  > 0 ->
                                                    {true, Scene, TX, TY, [{Type, GoodsId, GNum}|MoneyCost]};
                                                true ->
                                                    {true, Scene, TX, TY, MoneyCost}
                                            end;
                                        {false, ErrCode}->
                                            {false, ErrCode}
                                    end
                            end
                    end
            end;
        {false, ErrorCode} ->
            {false, ErrorCode}
    end.

check_condition([], _Ps) ->
    true;
check_condition([{lv, NeedLv}|Condition], Ps) ->
    #figure{lv = Lv} = Ps#player_status.figure,
    if
        Lv >= NeedLv -> check_condition(Condition, Ps);
        true -> {false, ?ERRCODE(err460_no_lv)}
    end;
check_condition([{team_check, _}|Condition], Ps) ->
    case Ps#player_status.team of
        #status_team{team_id = TeamId} when TeamId > 0 ->
            {false, ?ERRCODE(err470_in_team)};
        _ ->
            check_condition(Condition, Ps)
    end.

%% 玩家申请退出场景
quit_great_demon(Ps) ->
    #player_status{ scene = Scene, id = RoleId, server_id = ServerId, x = OldX, y = OldY } = Ps,
    case lib_boss:is_in_kf_great_demon_boss(Scene) of
        false ->
            {ok, BinData} = pt_460:write(46004, [?FAIL]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            case lib_scene:is_transferable_out(Ps) of
                {true, _} ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_great_demon_local:quit(Node, RoleId, Scene, ServerId, OldX, OldY);
                {false, Res} ->
                    lib_server_send:send_to_uid(RoleId, pt_460, 46004, [Res])
            end
    end.

%%
exit_great_demon(Ps) ->
    #player_status{id = RoleId, scene = Scene, server_id = ServerId} = Ps,
    mod_great_demon_local:exit_great_demon(RoleId, Scene, ServerId),
    ok.

% ===============================================

%% 模块基础检测
enter_before_mod_check(BossId, RoleId, State) ->
    #local_great_demon_state{
        boss_state_map = AllBossMap, is_grouping = IsGrouping
    } = State,
    case AllBossMap == #{} orelse IsGrouping == ?IN_GROUPING of
        true ->
            lib_server_send:send_to_uid(RoleId, pt_460, 46003, [?ERRCODE(err470_boss_not_open)]);
        _ ->
            lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, ?NOT_HAND_OFFLINE, ?MODULE, enter_check, [BossId])
    end.
    
%% 通过各种检测后
enter_scene_after_check(KfRoleInfo, RoleId, BossType, BossId, Scene, X, Y, NeedOut, State) ->
    #local_great_demon_state{
        role_info_map = RoleInfoMap, stay_scene_map = StayTimeMap
    } = State,
    %% 给进入的玩家增加进入次数
    mod_daily:increment(RoleId, ?MOD_BOSS, ?MOD_BOSS_ENTER, BossType),
    %% 设置进入场景后的定时器
    case maps:get(RoleId, RoleInfoMap, false) of
        false ->
            TriedRef = erlang:send_after(?ANGER_TIME * 1000, self(), {'tried_add', RoleId, BossId}),
            LocalRoleInfo = #local_role_info{
                role_id = RoleId, tried_ref = TriedRef, ref_type = 0
            };
        #local_role_info{tried_ref = TriedRef} = OldRoleInfo ->
            util:cancel_timer(TriedRef),
            NewTriedRef = erlang:send_after(?ANGER_TIME * 1000, self(), {'tried_add', RoleId, BossId}),
            LocalRoleInfo = OldRoleInfo#local_role_info{
                role_id = RoleId, tried_ref = NewTriedRef, ref_type = 0
            }
    end,
    NewInfoMap = maps:put(RoleId, LocalRoleInfo, RoleInfoMap),
    NewStayTimeMap = maps:put(RoleId, utime:unixtime(), StayTimeMap),
    mod_clusters_node:apply_cast(mod_great_demon, enter, [KfRoleInfo, BossType, BossId, Scene, X, Y, NeedOut]),
    State#local_great_demon_state{
        role_info_map = NewInfoMap, stay_scene_map = NewStayTimeMap
    }.


quit(Node, RoleId, Scene, ServerId, OldX, OldY, State) ->
    #local_great_demon_state{
        role_info_map = RoleInfoMap, stay_scene_map = StayTimeMap
    } = State,
    NowSec = utime:unixtime(),
    EnterTime = maps:get(RoleId, StayTimeMap, 0),
    StayTime = ?IF(EnterTime > 0, NowSec - EnterTime, 0),
    case maps:get(RoleId, RoleInfoMap, false) of
        false ->
            %% 通知跨服进程玩家退出场景
            mod_clusters_node:apply_cast(mod_great_demon, quit, [Node, RoleId, Scene, ServerId]),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log,
                [?BOSS_TYPE_KF_GREAT_DEMON, 1, Scene, OldX, OldY, StayTime]),
            State;
        #local_role_info{ tried_ref = TriedRef, tried = RoleTried } ->
            #boss_type{ max_anger = MaxTried } = data_boss:get_boss_type(?BOSS_TYPE_KF_GREAT_DEMON),
            if
                RoleTried >= MaxTried ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log,
                        [?BOSS_TYPE_KF_GREAT_DEMON, 2, Scene, OldX, OldY, StayTime]);
                true ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log,
                        [?BOSS_TYPE_KF_GREAT_DEMON, 1, Scene, OldX, OldY, StayTime])
            end,
            util:cancel_timer(TriedRef),
            NewRoleInfoMap = maps:remove(RoleId, RoleInfoMap),
            %% 通知跨服进程玩家退出场景
            mod_clusters_node:apply_cast(mod_great_demon, quit, [Node, RoleId, Scene, ServerId]),
            %% 更新玩家信息到进程中
            State#local_great_demon_state{
                role_info_map = NewRoleInfoMap, stay_scene_map = maps:remove(RoleId, StayTimeMap)
            }
    end.

%% 单纯清理玩家数据
exit_great_demon(RoleId, Scene, ServerId, State) ->
    #local_great_demon_state{
        role_info_map = RoleInfoMap, stay_scene_map = StayTimeMap
    } = State,
    case maps:get(RoleId, RoleInfoMap, false) of
        false ->
            NewRoleInfoMap = RoleInfoMap,
            NewStayTimeMap = StayTimeMap;
        #local_role_info{ tried_ref = TriedRef } ->
            util:cancel_timer(TriedRef),
            NewRoleInfoMap = maps:remove(RoleId, RoleInfoMap),
            NewStayTimeMap = maps:remove(RoleId, StayTimeMap),
            %% 通知跨服进程玩家退出场景
            mod_clusters_node:apply_cast(mod_great_demon, exit_great_demon, [RoleId, Scene, ServerId])
    end,
    State#local_great_demon_state{
        role_info_map =  NewRoleInfoMap, stay_scene_map = NewStayTimeMap
    }.

%% 同步怪物击杀、日志、特殊boss的生成
sync_boss_kill_and_log(Args, State) ->
    [?BOSS_TYPE_KF_GREAT_DEMON, BossId, NewBoss, AttrRoleId, AttrRoleName, ServerName, AddBossList, BlRoleIds|_] = Args,
    #local_great_demon_state{
        demon_kill = DeMonKill, boss_state_map = AllBossMap
    } = State,
    NowTime = utime:unixtime(),
    %% 首先更新怪物信息
    case maps:get(BossId, AllBossMap, none) of
        none ->
            NewAllBossMap = AllBossMap,
            NewDemonKill = DeMonKill;
        #great_demon_boss_status{ kill_log = KillLog } = BeKillBoss ->
            #great_demon_boss_status{
                num = NewNum, reborn_time = RebornTime, optional_data = NewOptionalData, mon_type = MonType
            } = NewBoss,
            NewKillLog = [{NowTime, ServerName, AttrRoleId, AttrRoleName}|KillLog],
            NewBeKillBoss =  BeKillBoss#great_demon_boss_status{
                num = NewNum, kill_log = NewKillLog, reborn_time = RebornTime, optional_data = NewOptionalData
            },
            NewAllBossMap = maps:update(BossId, NewBeKillBoss, AllBossMap),
            %% 更新个人击杀记录，用于计算阶段奖励
            case MonType == ?NORMAL_TREASURE_CHEST orelse MonType == ?ADVANCED_TREASURE_CHEST of
                true ->
                    NewDemonKill = DeMonKill;
                _ ->
                    NewDemonKill = update_great_demon_kill(DeMonKill, BlRoleIds)
            end
    end,
    Fun = fun(#great_demon_boss_status{ boss_id = TemBossId } = AddBoss, TemAllBossMap) ->
        maps:put(TemBossId, AddBoss, TemAllBossMap)
    end,
    LastAllBossMap = lists:foldl(Fun, NewAllBossMap, [NewBoss|AddBossList]),
    LastState = State#local_great_demon_state{
        demon_kill = NewDemonKill, boss_state_map = LastAllBossMap
    },
    send_demon_box_info(AttrRoleId, LastState),
    LastState.

%% 更新秘境boss 玩家的击杀数量
update_great_demon_kill(KillLog, BLWhos) ->
    F = fun(Id, DomainKillTmp) ->
        NewDomainBossKill =
            case lists:keyfind(Id, #kf_domain_boss_kill.role_id, DomainKillTmp) of
                #kf_domain_boss_kill{kill_num = KillNum} = DomainBossKill ->
                    DomainBossKill#kf_domain_boss_kill{kill_num = KillNum + 1};
                _ ->
                    #kf_domain_boss_kill{role_id = Id, kill_num = 1, get_list = []}
            end,
        lib_great_demon_sql:db_role_kf_domain_boss_kill_replace(NewDomainBossKill),
        %% spawn(fun() -> send_role_demon_kill(Id,NewDomainBossKill ) end),
        lists:keystore(Id, #kf_domain_boss_kill.role_id, DomainKillTmp, NewDomainBossKill)
    end,
    lists:foldl(F, KillLog, BLWhos).

%% 四点清理阶段奖励信息
daily_clear_demon_kill(State) ->
    #local_great_demon_state{ demon_kill = DemonKill } = State,
    send_demon_main_reward(DemonKill),
    lib_great_demon_sql:db_role_demon_boss_kill_truncate(),
    State#local_great_demon_state{demon_kill = [], drop_list = []}.

send_demon_main_reward([]) ->
    skip;
send_demon_main_reward(DemonKill) ->
    Fun = fun(#kf_domain_boss_kill{role_id = RoleID, kill_num = KillNumTmp, get_list = GetListTmp}) ->
        lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, ?MODULE, do_demon_main_reward, [KillNumTmp, GetListTmp]),
        timer:sleep(500)
    end,
    spawn(fun() -> lists:foreach(Fun, DemonKill) end).

do_demon_main_reward(#player_status{id = RoleId, figure = Figure} = Ps, KillNumTmp, GetListTmp) ->
    #figure{lv = Lv} = Figure,
    %% 可能需要的发的阶数
    AllDomainStage = data_domain:get_all_stage(),
    LeastStage = AllDomainStage -- GetListTmp,
    Fun = fun(StageTmp, RewardTmp) ->
        #domain_kill_reward_cfg{
            reward_list = RewardListTmp, kill_boss_num = KillBossNum
        } = data_domain:get_domain_stage_lv(StageTmp, Lv),
        case KillNumTmp >= KillBossNum of
            true -> RewardListTmp ++ RewardTmp;
            false -> RewardTmp
        end
    end,
    RewardList = lists:foldl(Fun, [], LeastStage),
    if
        RewardList =/= [] ->
            Title = utext:get(4600009), Content = utext:get(4600010),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList);
        true ->
            skip
    end,
    {ok, Ps}.

%% 获取阶段性奖励状态
send_demon_kill_reward_info(RoleId, State) ->
    #local_great_demon_state{ demon_kill = DemonKill } = State,
    {KillNum, GetList} =
        case lists:keyfind(RoleId, #kf_domain_boss_kill.role_id, DemonKill) of
            #kf_domain_boss_kill{kill_num = KillNumTmp, get_list = GetListTmp} ->
                {KillNumTmp, GetListTmp};
            _ ->
                {0, []}
        end,
    lib_server_send:send_to_uid(RoleId, pt_460, 46037, [KillNum, GetList]).

%% 领取阶段奖励
get_demon_kill_reward(RoleId, RoleLv, RewardId, State) ->
    #local_great_demon_state{
        demon_kill = DemonKill
    } = State,
    #domain_kill_reward_cfg{
        stage = Stage, kill_boss_num = KillBossNum, limit_down = LimitDown, limit_up = LimitUp, reward_list = RewardList
    } = data_domain:get_domain_kill_reward(RewardId),
    {ErrCode, NewState} =
        case RoleLv >= LimitDown andalso RoleLv =< LimitUp of
            true ->
                case lists:keyfind(RoleId, #kf_domain_boss_kill.role_id, DemonKill) of
                    #kf_domain_boss_kill{kill_num = KillNumTmp, get_list = GetListTmp} = DomainBossKill ->
                        case KillNumTmp >= KillBossNum of
                            true ->
                                case lists:member(Stage, GetListTmp) of
                                    true ->  % 已经领取阶段奖励
                                        {?ERRCODE(err460_domain_had_reward), State};
                                    false ->
                                        lib_goods_api:send_reward_by_id(RewardList, boss_domain, RoleId),
                                        NewGetListTmp = [Stage | GetListTmp],
                                        NewDomainBossKill = DomainBossKill#kf_domain_boss_kill{get_list = NewGetListTmp},
                                        NewDomainKill = lists:keystore(RoleId, #kf_domain_boss_kill.role_id, DemonKill, NewDomainBossKill),
                                        lib_great_demon_sql:db_role_kf_domain_boss_kill_replace(NewDomainBossKill),
                                        {?SUCCESS, State#local_great_demon_state{demon_kill = NewDomainKill}}
                                end;
                            false ->
                                {?ERRCODE(err460_domain_no_kill_num), State}
                        end;
                    _ ->
                        {?FAIL, State}
                end;
            false ->
                {?ERRCODE(err460_domain_no_lv), State}
        end,
    lib_server_send:send_to_uid(RoleId, pt_460, 46038, [RewardId, ErrCode]),
    NewState.

%% 发送宝箱等采集怪的信息
send_demon_box_info(RoleId, State) ->
    #local_great_demon_state{ boss_state_map = AllBossMap } = State,
    Fun = fun(BossId, #great_demon_boss_status{ mon_type = MonType, xy = XyList}, AccList) ->
        case MonType of
            ?NORMAL_TREASURE_CHEST ->
                [{BossId, XyList} | AccList];
            ?ADVANCED_TREASURE_CHEST ->
                [{BossId, XyList} | AccList];
            ?SPECIAL_GREAT_DEMON ->
                [{BossId, XyList} | AccList];
            _ ->
                AccList
        end
    end,
    SendList = maps:fold(Fun, [], AllBossMap),
    lib_server_send:send_to_uid(RoleId, pt_460, 46039, [SendList]).

%% 击杀怪物后，增加玩家疲劳值
update_role_tired_in_scene(BossId, RoleId, State) ->
    BossType = ?BOSS_TYPE_KF_GREAT_DEMON,
    #local_great_demon_state{
        role_info_map = RoleInfoMap
    } = State,
    #mon{anger = AddTired} = data_mon:get(BossId),
    #boss_type{
        max_anger = MaxTired
    } = data_boss:get_boss_type(BossType),
    
    case maps:get(RoleId, RoleInfoMap, false) of
        false ->
            lib_server_send:send_to_uid(RoleId, pt_460, 46005, [AddTired,  MaxTired]),
            TriedRef = erlang:send_after(?ANGER_TIME * 1000, self(), {'tried_add', RoleId, BossId}),
            RoleInfo = #local_role_info{ role_id = RoleId, tried = AddTired, tried_ref = TriedRef },
            LastRoleTiredMap = maps:put(RoleId, RoleInfo, RoleInfoMap);
        #local_role_info{ tried = RoleTried } when RoleTried >= MaxTired ->
            LastRoleTiredMap = RoleInfoMap;
        #local_role_info{ tried = RoleTried, tried_ref = TriedRef } = RoleInfo ->
            NewTried = RoleTried + AddTired,
            lib_server_send:send_to_uid(RoleId, pt_460, 46005, [min(MaxTired, NewTried), MaxTired]),
            case NewTried >= MaxTired of
                true ->
                    util:cancel_timer(TriedRef),
                    TriedDelayRef = erlang:send_after(?ANGER_DELAY_TIME * 1000, self(), {'tried_tick_out', RoleId, BossId}),
                    EndTime = utime:unixtime() + ?ANGER_DELAY_TIME,
                    NewRoleInfo = RoleInfo#local_role_info{
                        tried = MaxTired, ref_type = ?FORBIDDEN_OUT_DELAY, end_time = EndTime, tried_ref = TriedDelayRef},
                    lib_server_send:send_to_uid(RoleId, pt_460, 46006, [?FORBIDDEN_OUT_DELAY, ?ANGER_DELAY_TIME]),
                    LastRoleTiredMap = maps:put(RoleId, NewRoleInfo, RoleInfoMap);
                _ ->
                    NewRoleInfo = RoleInfo#local_role_info{tried = NewTried},
                    LastRoleTiredMap = maps:put(RoleId, NewRoleInfo, RoleInfoMap)
            end
    end,
    State#local_great_demon_state{ role_info_map = LastRoleTiredMap }.

%%
tried_tickout_delay(BossId, RoleId, State) ->
    BossType = ?BOSS_TYPE_KF_GREAT_DEMON,
    #local_great_demon_state{
        role_info_map = RoleInfoMap, stay_scene_map = StayTimeMap
    } = State,
    case maps:get(RoleId, RoleInfoMap, false) of
        false ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_great_demon_local,
                change_add_tired_out, [BossType, BossId, StayTimeMap]),
            State;
        #local_role_info{ tried_ref = TriedRef } = RoleInfo ->
            util:cancel_timer(TriedRef),
            TickOutRef = erlang:send_after(?ANGER_DELAY_TIME * 1000, self(), {'tried_tick_out', RoleId,  BossId}),
            EndTime = utime:unixtime() + ?ANGER_DELAY_TIME,
            NewRoleInfo = RoleInfo#local_role_info{ tried_ref = TickOutRef, end_time = EndTime, ref_type = ?FORBIDDEN_OUT_TIME},
            NewRoleTiredMap = maps:put(RoleId, NewRoleInfo, RoleInfoMap),
            lib_server_send:send_to_uid(RoleId, pt_460, 46006, [?FORBIDDEN_OUT_TIME, ?ANGER_DELAY_TIME]),
            State#local_great_demon_state{ role_info_map = NewRoleTiredMap }
    end.

%% 倒计时结束踢出玩家
tried_tick_out(RoleId, BossId, State) ->
    #local_great_demon_state{
        role_info_map = RoleInfoMap, stay_scene_map = StayTimeMap
    } = State,
    case maps:get(RoleId, RoleInfoMap,false) of
        false ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_great_demon_local,
                change_add_tired_out, [?BOSS_TYPE_KF_GREAT_DEMON, BossId, StayTimeMap]),
            State;
        #local_role_info{ tried_ref = TriedRef } ->
            util:cancel_timer(TriedRef),
            NewRoleTiredMap = maps:remove(RoleId, RoleInfoMap),
            lib_server_send:send_to_uid(RoleId, pt_460, 46006, [?FORBIDDEN_OUT_TIME, ?ANGER_DELAY_TIME]),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_great_demon_local,
                change_add_tired_out, [?BOSS_TYPE_KF_GREAT_DEMON, BossId, StayTimeMap]),
            State#local_great_demon_state{ role_info_map = NewRoleTiredMap }
    end.

%% 每分钟增加疲劳值
tried_add(RoleId, BossId, State) ->
    #local_great_demon_state{
        role_info_map = RoleInfoMap, stay_scene_map = StayTimeMap
    } = State,
    case maps:get(RoleId, RoleInfoMap, false) of
        false ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_great_demon_local,
                change_add_tired_out, [?BOSS_TYPE_KF_GREAT_DEMON, BossId, StayTimeMap]),
            State;
        #local_role_info{ tried_ref = TriedRef, tried = RoleTried } = RoleInfo ->
            util:cancel_timer(TriedRef),
            NewRoleTried = RoleTried + 1,
            #boss_type{ max_anger = MaxTried } = data_boss:get_boss_type(?BOSS_TYPE_KF_GREAT_DEMON),
            lib_server_send:send_to_uid(RoleId, pt_460, 46005, [NewRoleTried, MaxTried]),
            case NewRoleTried >= MaxTried of
                true ->
                    TriedDelayRef = erlang:send_after(?ANGER_DELAY_TIME * 1000, self(), {'tried_tick_out', RoleId, BossId}),
                    EndTime = utime:unixtime() + ?ANGER_DELAY_TIME,
                    NewRoleInfo = RoleInfo#local_role_info{
                        tried = MaxTried, ref_type = ?FORBIDDEN_OUT_DELAY, end_time = EndTime, tried_ref = TriedDelayRef},
                    lib_server_send:send_to_uid(RoleId, pt_460, 46006, [?FORBIDDEN_OUT_DELAY, ?ANGER_DELAY_TIME]),
                    LastRoleTiredMap = maps:put(RoleId, NewRoleInfo, RoleInfoMap);
                _ ->
                    NewTriedRef = erlang:send_after(?ANGER_TIME * 1000, self(), {'tried_add', RoleId, BossId}),
                    NewRoleInfo = RoleInfo#local_role_info{ tried = NewRoleTried, tried_ref = NewTriedRef },
                    LastRoleTiredMap = maps:put(RoleId, NewRoleInfo, RoleInfoMap)
            end,
            State#local_great_demon_state{ role_info_map = LastRoleTiredMap }
    end.

%% 检测玩家退出信息
change_add_tired_out(Ps, BossType, _BossId, StayTimeMap) ->
    #player_status{id = RoleId, scene = SceneId, x = OldX, y = OldY, server_id = ServerId} = Ps,
    AllScenes = data_kf_great_demon:get_all_great_demon_boss_scene(),
    case lists:member(SceneId,  AllScenes ) of
        false -> Ps;
        true ->
            StayTime = maps:get(RoleId, StayTimeMap, 0),
            case StayTime > 0 of
                true ->
                    lib_boss:add_exit_log(Ps, BossType, 2, SceneId, OldX, OldY, StayTime),
                    Node = mod_disperse:get_clusters_node(),
                    %% 通知跨服进程玩家退出场景
                    mod_clusters_node:apply_cast(mod_great_demon, quit, [Node, RoleId, SceneId, ServerId]);
                _ ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_great_demon, quit, [Node, RoleId, SceneId, ServerId]),
                    ?ERR("Error BossType:~p, SceneId:~p, StayTime: ~p", [BossType, SceneId, StayTime])
            end
    end.

%% 通知玩家怪物重生
great_demon_boss_remind(BossId, State) ->
    #local_great_demon_state{
        boss_state_map = AllBossMap
    } = State,
    case maps:get(BossId, AllBossMap, none) of
        none ->
            skip;
        #great_demon_boss_status{ remind_list = RemindList} ->
            spawn(fun() -> send_remind_msg_role(RemindList, ?BOSS_TYPE_KF_GREAT_DEMON, BossId) end)
    end.

%% 玩家关注/取关BOSS
remind_great_demon_boss(RoleId, BossId, OpType, IsAuto, State) ->
    BossType = ?BOSS_TYPE_KF_GREAT_DEMON,
    #local_great_demon_state{
        boss_state_map = AllBossMap
    } = State,
    case maps:get(BossId, AllBossMap, none) of
        none ->
            {ok, Bin} = pt_460:write(46007, [?ERRCODE(err460_no_boss_cfg), BossType, BossId, OpType, IsAuto]),
            lib_server_send:send_to_uid(RoleId, Bin),
            State;
        #great_demon_boss_status{ remind_list = RemindList} = BossStatus ->
            IsInRemind = lists:member(RoleId, RemindList),
            {Code, NewRemindList} =
                if
                    OpType == ?REMIND andalso IsInRemind ->
                        {?ERRCODE(err460_no_remind), RemindList};
                    OpType =/= ?REMIND andalso IsInRemind == false ->
                        {?ERRCODE(err460_no_unremind), RemindList};
                    OpType == ?REMIND -> %% replace
                        SQL = <<"replace into great_demon_boss_remind set role_id = ~p, boss_id = ~p">>,
                        db:execute(io_lib:format(SQL, [RoleId, BossId])),
                        {?SUCCESS, [RoleId | RemindList]};
                    true -> %% delete
                        SQL = <<"delete from great_demon_boss_remind where role_id = ~p and boss_id = ~p">>,
                        db:execute(io_lib:format(SQL, [RoleId, BossId])),
                        {?SUCCESS, lists:delete(RoleId, RemindList)}
                end,
            lib_server_send:send_to_uid(RoleId, pt_460, 46007, [Code, BossType, BossId, OpType, IsAuto]),
            NewBoss = BossStatus#great_demon_boss_status{ remind_list = NewRemindList },
            NewBossMap = maps:put(BossId, NewBoss, AllBossMap),
            State#local_great_demon_state{ boss_state_map = NewBossMap }
    end.

%% 发送提醒消息
send_remind_msg_role([], _BossType, _BossId) -> skip;
send_remind_msg_role([RoleId|RemindList], BossType, BossId)->
    lib_server_send:send_to_uid(RoleId, pt_470, 47006, [BossType, BossId]),
    send_remind_msg_role(RemindList, BossType, BossId).

%% 获取怪物信息
get_great_demon_boss_info(RoleId, LessCount, AllCount, State) ->
    #local_great_demon_state{
        boss_state_map = AllBossMap, is_grouping = IsGrouping, sync_flag = IsSync
    } = State,
    IsOpen = great_demon_boss_open(),
    ServerId = config:get_server_id(),
    if
        IsOpen == false -> skip;  %% 开服天数不够
        IsGrouping == ?IN_GROUPING -> skip;  %% 处于分区分区期间
        IsSync == ?SYNC_NO orelse AllBossMap == #{} -> %% 未从跨服同步数据
            case get('great_demon_boss_sync') of
                undefined ->
                    put('great_demon_boss_sync', 1),
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_great_demon, game_req_server_data, [ServerId, Node, ?FORCE_UP]);
                Count when Count < 20 ->
                    put('great_demon_boss_sync', Count+1);
                _ ->
                    erase('great_demon_boss_sync')
            end;
        true ->
            Fun = fun(BossId, #great_demon_boss_status{reborn_time = RebornTime, remind_list = RemindList, num = Num}, AccList ) ->
                IsRemind = ?IF(lists:member(RoleId, RemindList), 1, 0),
                [{BossId, Num, RebornTime, IsRemind, ?NO_AUTO_REMIND}|AccList]
            end,
            BossInfoList = maps:fold(Fun, [], AllBossMap),
            Args = [?BOSS_TYPE_KF_GREAT_DEMON, AllCount, LessCount, 0, 0, 0, 0, 0, 0, BossInfoList],
            {ok, BinData} = pt_460:write(46000, Args),
            lib_server_send:send_to_uid(RoleId, BinData)
    end.

great_demon_boss_open() ->
    case util:get_open_day() >= ?GREAT_DEMON_BOSS_OPEN_DAY of
        true -> true;
        _ -> false
    end.

%% 玩家真实登出游戏时，清理定时器等数据
logout_great_demon(RoleId, Scene, ServerId, OldX, OldY, State) ->
    #local_great_demon_state{
        role_info_map = RoleInfoMap, stay_scene_map = StayTimeMap
    } = State,
    NowSec = utime:unixtime(),
    EnterTime = maps:get(RoleId, StayTimeMap, 0),
    StayTime = ?IF(EnterTime > 0, NowSec - EnterTime, 0),
    case maps:get(RoleId, RoleInfoMap, false) of
        false ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log,
                [?BOSS_TYPE_KF_GREAT_DEMON, 1, Scene, OldX, OldY, StayTime]),
            State;
        #local_role_info{ tried_ref = TriedRef, tried = RoleTried } ->
            #boss_type{ max_anger = MaxTried } = data_boss:get_boss_type(?BOSS_TYPE_KF_GREAT_DEMON),
            if
                RoleTried >= MaxTried ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log,
                        [?BOSS_TYPE_KF_GREAT_DEMON, 2, Scene, OldX, OldY, StayTime]);
                true ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log,
                        [?BOSS_TYPE_KF_GREAT_DEMON, 1, Scene, OldX, OldY, StayTime])
            end,
            util:cancel_timer(TriedRef),
            NewRoleInfoMap = maps:remove(RoleId, RoleInfoMap),
            %% 通知跨服进程玩家退出场景
            mod_clusters_node:apply_cast(mod_great_demon, exit_great_demon, [RoleId, Scene, ServerId]),
            %% 更新玩家信息到进程中
            State#local_great_demon_state{
                role_info_map = NewRoleInfoMap, stay_scene_map = maps:remove(RoleId, StayTimeMap)
            }
    end.

check_collect_times(_MonId, MonCfgId, [_RoleId, _BossType, _BossId]) ->
    case data_kf_great_demon:get_great_demon_boss_cfg(MonCfgId) of
        #great_demon_boss_info{} ->
            true;
        _ ->
            {false, 7}
    end.

%% 获取玩家击杀怪物的日志
get_boss_kill_log(RoleId, _BossType, BossId, State) ->
    #local_great_demon_state{
        boss_state_map = AllBossMap
    } = State,
    case maps:get(BossId, AllBossMap, none) of
        none ->
            KillLog = [];
        #great_demon_boss_status{ kill_log = KillLog } ->
            ok
    end,
    lib_server_send:send_to_uid(RoleId, pt_460, 46001, [KillLog]).

%% 场景内玩家被击杀
player_die(Attacker, Status) ->
    #battle_return_atter{
        server_id = AttServerId, server_num = AttServerNum, id  = AUid,
        real_name = AttName, sign  = AtterSign, guild_id = AttGuildId, lv = AttLv, mask_id = AttMaskId
    } = Attacker,
    #player_status{
        id = DeadRoleId, scene = Scene, x = X, y = Y, server_id = ServerId, server_num = ServerNum,
        figure = #figure{name = DeadName, lv = DeadLv, mask_id = DeadMaskId},  guild = #status_guild{id = GuildId}
    } = Status,
    case lib_boss:is_in_kf_great_demon_boss(Scene) of
        false ->
            skip;
        _ ->
            AttackerInfo = [AUid, AttName, AttLv, AtterSign, AttGuildId, AttServerId, AttServerNum, AttMaskId],
            DerInfo = [DeadRoleId, DeadName, DeadLv, GuildId, ServerId, ServerNum, DeadMaskId],
            mod_clusters_node:apply_cast(mod_great_demon, player_die, [AttackerInfo, DerInfo, Scene, X, Y])
    end.

%% 被击杀的玩家增加疲劳值
player_die_add_tried(BeKillRoleId, State) ->
    BossType = ?BOSS_TYPE_KF_GREAT_DEMON ,
    #local_great_demon_state{
        role_info_map = RoleInfoMap, stay_scene_map = StayTimeMap
    } = State,
    case maps:get(BeKillRoleId, RoleInfoMap, none) of
        none ->
            lib_player:apply_cast(BeKillRoleId, ?APPLY_CAST_SAVE, lib_great_demon_local,
                change_add_tired_out, [BossType, 0, StayTimeMap]),
            State;
        #local_role_info{ tried = RoleTried, tried_ref = TriedRef }  = RoleInfo ->
            #boss_type{ max_anger = MaxTried } = data_boss:get_boss_type(BossType),
            if
                RoleTried == MaxTried ->
                    State; %% 怒气已满等待踢出
                true ->
                    case ?BOSS_TYPE_KV_BEKILL_ANGER_ADD(BossType) of
                        AddTried when is_integer(AddTried) -> AddTried;
                        _ -> AddTried = 0
                    end,
                    NewRoleTried = RoleTried + AddTried,
                    lib_server_send:send_to_uid(BeKillRoleId, pt_460, 46005, [min(NewRoleTried, MaxTried), MaxTried]),
                    if
                        NewRoleTried >= MaxTried ->
                            util:cancel_timer(TriedRef),
                            TriedDelayRef = erlang:send_after(?ANGER_DELAY_TIME * 1000, self(), {'tried_tick_out', BeKillRoleId, 0}),
                            EndTime = utime:unixtime() + ?ANGER_DELAY_TIME,
                            NewRoleInfo = RoleInfo#local_role_info{
                                tried = MaxTried, ref_type = ?FORBIDDEN_OUT_DELAY, end_time = EndTime, tried_ref = TriedDelayRef},
                            lib_server_send:send_to_uid(BeKillRoleId, pt_460, 46006, [?FORBIDDEN_OUT_DELAY, ?ANGER_DELAY_TIME]),
                            LastRoleTiredMap = maps:put(BeKillRoleId, NewRoleInfo, RoleInfoMap);
                        true ->
                            NewRoleInfo = RoleInfo#local_role_info{ tried = NewRoleTried},
                            LastRoleTiredMap = maps:put(BeKillRoleId, NewRoleInfo, RoleInfoMap)
                    end,
                    State#local_great_demon_state{ role_info_map = LastRoleTiredMap }
            end
    end.

%% 玩家重连场景
reconnect(PS, ?NORMAL_LOGIN) ->
    #player_status{scene = SceneId} = PS,
    case lib_boss:is_in_kf_great_demon_boss(SceneId) of
        true ->
            NewPS = lib_scene:change_default_scene(PS, [{group, 0}, {change_scene_hp_lim, 1}]),
            {ok, NewPS};
        false ->
            {next, PS}
    end;
reconnect(PS, ?RE_LOGIN) ->
    #player_status{scene = SceneId, id = RoleId} = PS,
    case lib_boss:is_in_kf_great_demon_boss(SceneId) of
        true ->
            mod_great_demon_local:reconnect(RoleId),
            {ok, PS};
        false ->
            {next, PS}
    end.

get_scene_default_xy(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{x = X, y = Y} ->
            {X, Y};
        _ ->
            {0, 0}
    end.

role_reconnect(RoleId, State) ->
    #local_great_demon_state{
        role_info_map = RoleInfoMap
    } = State,
    case maps:get(RoleId, RoleInfoMap, none) of
        none ->
            lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, lib_scene, change_default_scene, [[{group, 0}, {change_scene_hp_lim, 1}]]),
            State;
        #local_role_info{ tried_ref = TriedRef, tried = RoleTired } = RoleInfo ->
            #boss_type{ max_anger = MaxTried } = data_boss:get_boss_type(?BOSS_TYPE_KF_GREAT_DEMON),
            util:cancel_timer(TriedRef),
            if
                RoleTired >= MaxTried ->
                    lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE,
                        lib_scene, change_default_scene, [[{group, 0}, {change_scene_hp_lim, 1}]]),
                    NewRoleInfoMap = maps:remove(RoleId, RoleInfoMap);
                true ->
                    NewTriedRef = erlang:send_after(?ANGER_TIME * 1000, self(), {'tried_add', RoleId, 0}),
                    NewRoleInfo = RoleInfo#local_role_info{tried_ref = NewTriedRef },
                    NewRoleInfoMap = maps:put(RoleId, NewRoleInfo, RoleInfoMap),
                    %% 通知玩家进行重连
                    lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, ?MODULE, do_role_reconnect, [])
            end,
            State#local_great_demon_state{
                role_info_map = NewRoleInfoMap
            }
    end.

do_role_reconnect(PS) ->
    #player_status{scene = SceneId} = PS,
    case lib_boss:is_in_kf_great_demon_boss(SceneId) of
        true ->
            {X, Y} = get_scene_default_xy(SceneId),
            NewPS = PS#player_status{x = X, y = Y},
            lib_scene:change_relogin_scene(NewPS, [{change_scene_hp_lim, 1}]);
        false ->
            PS
    end.

%% 秘籍补发活动嗨点
%% StartTime - 开始时间点
%% EndTime - 执行秘籍的时间点
%%
gm_send_hi_point_email(FixType, StartTime, EndTime) ->
    if
        FixType > 0 ->
            spawn(fun() ->
                Sql = <<"select role_id, count(*) from log_enter_or_exit_boss where role_id = ~p and boss_type = 20 and stype = 0 and stime >= ~p and stime <= ~p group by role_id">>,
                case db:get_all(io_lib:format(Sql, [FixType, StartTime, EndTime])) of
                    [] ->
                        skip;
                    EnterList ->
                        %% select role_id, count(*) from log_hi_points where mod_id = 460 and sub_id = 1020 and time > 1670342400 and time <= 1670423850 group by role_id
                        HiSql = <<"select role_id, count(*) from log_hi_points where role_id = ~p and mod_id = 460 and sub_id = 1020 and time >= ~p and time <= ~p group by role_id">>,
                        HiPointList = db:get_all(io_lib:format(HiSql, [FixType, StartTime, EndTime])),
                        NewEnterList = [erlang:list_to_tuple(I)||I <- EnterList],
                        NewHiPointList = [erlang:list_to_tuple(I)||I <- HiPointList],
                        do_gm_send_hi_point_email(NewEnterList, NewHiPointList)
                end
            end);
        true ->
            %% select role_id, count(*) from log_enter_or_exit_boss where boss_type = 20 and stype = 0 and stime >= 1670342400 and stime <= 1670423850 group by role_id
            spawn(fun() ->
                Sql = <<"select role_id, count(*) from log_enter_or_exit_boss where boss_type = 20 and stype = 0 and stime >= ~p and stime <= ~p group by role_id">>,
                case db:get_all(io_lib:format(Sql, [StartTime, EndTime])) of
                    [] ->
                        skip;
                    EnterList ->
                        %% select role_id, count(*) from log_hi_points where mod_id = 460 and sub_id = 1020 and time > 1670342400 and time <= 1670423850 group by role_id
                        HiSql = <<"select role_id, count(*) from log_hi_points where mod_id = 460 and sub_id = 1020 and time >= ~p and time <= ~p group by role_id">>,
                        HiPointList = db:get_all(io_lib:format(HiSql, [StartTime, EndTime])),
                        NewEnterList = [erlang:list_to_tuple(I)||I <- EnterList],
                        NewHiPointList = [erlang:list_to_tuple(I)||I <- HiPointList],
                        do_gm_send_hi_point_email(NewEnterList, NewHiPointList)
                end
            end)
    end.

do_gm_send_hi_point_email(EnterList, HiPointList) ->
    ?INFO("EnterList:~p//Ho:~p", [EnterList, HiPointList]),
    EmailTitle = <<"12月7日秘境大妖嗨点异常补偿"/utf8>>,
    EmailContent = <<"尊敬的御灵师您好，由于秘境大妖进入次数触发任务进度异常，特为您补上相关嗨点值，请您查收，祝您游戏愉快"/utf8>>,
    Fun = fun({RoleId, EnterTimes}) ->
        %% 热更后嗨点修复加上正常进入操作的次数
        case lists:keyfind(RoleId, 1, HiPointList) of
            {RoleId, HiPointTimes} ->
                ok;
            false ->
                HiPointTimes = 0
        end,
        %% 需要补发的邮件次数
        NeedSendTimes = EnterTimes - HiPointTimes,
        case NeedSendTimes > 0 of
            true ->
                SendRewardList = [{0, 38350001, NeedSendTimes * 10}],
                mod_mail_queue:add(gm, [RoleId], EmailTitle, EmailContent, SendRewardList);
            _ ->
                skip
        end
    end,
    lists:foreach(Fun, EnterList).