%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 27 Oct 2017 by root <root@localhost.localdomain>

-module(pp_boss).

-export([handle/3]).

-export([
    before_check/2
]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("boss.hrl").
-include("errcode.hrl").
-include("vip.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("dungeon.hrl").
-include("def_vip.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").
-include("team.hrl").

%% boss列表信息
handle(46000, #player_status{figure = #figure{lv = RoleLv, vip = VipLv, vip_type = VipType}} = Ps, [BossType]) ->
    case data_boss:get_boss_type(BossType) of
        #boss_type{count = Count, module = _Module, daily_id = _DailyId, tired = MaxTired} ->
            #player_status{id = RoleId, sid = Sid, status_boss = StatusBoss, last_task_id = LastTaskId} = Ps,
            #status_boss{boss_map = BossMap} = StatusBoss,
            {LCount, AllCount, LTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes} = if
                BossType == ?BOSS_TYPE_WORLD ->
                    {0,0, max(0, MaxTired-mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_BOSS_TIRE, BossType)), MaxTired, 0, 0, 0, 0};
                BossType == ?BOSS_TYPE_VIP_PERSONAL -> %% 个人之家显示特殊处理
                    % VipAddCount = lib_vip:get_vip_privilege(VipLv, ?MOD_DUNGEON,
                    %         ?VIP_DUNGEON_ENTER_RIGHT_ID(?DUNGEON_TYPE_VIP_PER_BOSS)),
                    VipAddCount = lib_vip_api:get_vip_privilege(?MOD_DUNGEON, ?VIP_DUNGEON_ENTER_RIGHT_ID(?DUNGEON_TYPE_VIP_PER_BOSS), VipType, VipLv),
                    ACount = Count + VipAddCount,
                    {max(0, ACount-mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, ?DUNGEON_TYPE_VIP_PER_BOSS)), ACount, 0, 0, 0, 0, 0, 0} ;
                BossType == ?BOSS_TYPE_FORBIDDEN ->
                    VipAddCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?VIP_BOSS_ENTER(?BOSS_TYPE_FORBIDDEN), VipType, VipLv),
                   % ?PRINT("46000 vip VipAddCount:~p,Count:~p~n",[VipAddCount, Count]),
                    ACount = Count + VipAddCount,
                    {max(0, ACount-mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_BOSS_ENTER, BossType)), ACount, 0, 0, 0, 0, 0, 0};
                BossType == ?BOSS_TYPE_TEMPLE ->
                    % VipAddCount = lib_vip:get_vip_privilege(VipLv, ?MOD_BOSS, ?BOSS_TYPE_TEMPLE ),
                    VipAddCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?VIP_BOSS_ENTER(?BOSS_TYPE_TEMPLE), VipType, VipLv),
                    ACount = Count + VipAddCount,
                    % VipAddTired = lib_vip:get_vip_privilege(VipLv, ?MOD_BOSS, ?BOSS_TYPE_TEMPLE * 1000),
                    VipAddTired =  lib_vip_api:get_vip_privilege(?MOD_BOSS, ?VIP_BOSS_TIRE(?BOSS_TYPE_TEMPLE), VipType, VipLv),
                    ATired = MaxTired + VipAddTired,
                    {max(0, ACount - mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_BOSS_ENTER, BossType)), ACount,
                        max(0, ATired - mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_BOSS_TIRE, BossType)), ATired, 0, 0, 0, 0};
                BossType == ?BOSS_TYPE_OUTSIDE ->
                    #role_boss{vit = Vit0, last_vit_time = LastVitTime0} = maps:get(BossType, BossMap),
                    {0, 0, 0, 0, Vit0, LastVitTime0, 0, 0};
                BossType == ?BOSS_TYPE_FAIRYLAND ->
%%                    ?PRINT("Count : ~p,enter times:~p, BossType:~p~n",[Count, mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_SUB_FAIRYLAND_BOSS, BossType), BossType]),
                    {0, 0, max(0, mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_SUB_FAIRYLAND_BOSS, BossType)), MaxTired, 0, 0, 0, 0};
                BossType == ?BOSS_TYPE_PHANTOM ->
                    CollectTimes = mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_BOSS_COLLECT, BossType),
                    CollectTimesMax = lib_boss:get_boss_collect_times_max(BossType),
                    {0, 0, max(0, mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_BOSS_TIRE, BossType)), MaxTired, 0, 0, CollectTimes, CollectTimesMax};
                BossType == ?BOSS_TYPE_NEW_OUTSIDE orelse BossType == ?BOSS_TYPE_SPECIAL->
                    VipAddMaxCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?NEW_OUTSIDE_BOSS_VIP_VALUE, VipType, VipLv),
                    CfgMaxVit = ?BOSS_TYPE_KV_MAX_VIT(?BOSS_TYPE_NEW_OUTSIDE),
                    MaxVit = CfgMaxVit+VipAddMaxCount,
                    #role_boss{vit = Vit0, last_vit_time = LastVitTime0} = maps:get(?BOSS_TYPE_NEW_OUTSIDE, BossMap),
                    % ?PRINT("Vit0:~p, MaxVit:~p, {VipType, VipLv}:~p~n",[Vit0, MaxVit, {VipType, VipLv}]),
                    {0, 0, Vit0, MaxVit, 0, LastVitTime0, 0, 0};
                BossType == ?BOSS_TYPE_DOMAIN ->
                    VipAddCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?VIP_BOSS_ENTER(?BOSS_TYPE_DOMAIN), VipType, VipLv),
                    ACount = Count + VipAddCount,
                    {max(0, ACount-mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_BOSS_ENTER, BossType)), ACount, 0, 0, 0, 0, 0, 0};
                BossType == ?BOSS_TYPE_KF_GREAT_DEMON ->
                    %% 暂时使用本服boss的接口，先让流程跑起来
                    VipAddCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?VIP_BOSS_ENTER(?BOSS_TYPE_KF_GREAT_DEMON), VipType, VipLv),
                    ACount = Count + VipAddCount,
                    {max(0, ACount-mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_BOSS_ENTER, BossType)), ACount, 0, 0, 0, 0, 0, 0};
                true ->
                    {0, 0, 0, 0, 0, 0, 0, 0}
            end,
            if
                BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
                    mod_special_boss:get_boss_info(RoleId, RoleLv, Sid, LastTaskId, BossType, LCount, AllCount, LTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes);
                BossType == ?BOSS_TYPE_KF_GREAT_DEMON ->
                    mod_great_demon_local:get_great_demon_boss_info(RoleId, LCount, AllCount);
                true ->
                    mod_boss:get_boss_info(RoleId, Sid, BossType, LCount, AllCount, LTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes)
            end;
            _ ->
                skip
    end;

%% boss的击杀情况
handle(46001, Ps, [BossType, BossId]) ->
    case BossType of
        ?BOSS_TYPE_KF_GREAT_DEMON ->
            mod_great_demon_local:get_boss_kill_log(Ps#player_status.id, BossType, BossId);
        _ ->
            mod_boss:get_boss_kill_log(Ps#player_status.sid, BossType, BossId)
    end;

%% boss掉落的情况
handle(46002, Ps, []) ->
    mod_boss:get_boss_drop_log(Ps#player_status.sid);


handle(46003, Ps, [?BOSS_TYPE_FEAST, _]) ->
    lib_boss:enter_feast_boss(Ps);

%% 进入跨服秘境大妖
handle(46003, Ps, [?BOSS_TYPE_KF_GREAT_DEMON, BossId]) ->
    #player_status{ id = RoleId } = Ps,
    mod_great_demon_local:enter_before_mod_check(BossId, RoleId);

%% 进入boss场景 pt_46003_[3, 1251001]
handle(46003, Ps, [BossType, BossId]) ->
    case data_boss:get_boss_cfg(BossId) of
        [] -> lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [?ERRCODE(err460_no_boss_cfg)]);
        #boss_cfg{scene = ConfScene} when ConfScene == Ps#player_status.scene->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [?ERRCODE(err120_already_in_scene)]);
        _ ->
            case before_check(Ps, BossType) of
                {false, Code} ->
                    lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [Code]);
                _ ->
                    case check_enter_boss(Ps, BossType, BossId) of
                        {false, Code} ->
                            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [Code]);
                        {true, Scene, X, Y, Cost} ->
%%                            ?IF(BossType =:= ?BOSS_TYPE_FORBIDDEN,
%%                                mod_hi_point:success_end(Ps#player_status.id, ?MOD_BOSS, BossType), skip),
                            Type = lib_boss:get_boss_consume_type(BossType),
                            case lib_goods_api:cost_object_list(Ps, Cost, Type, "") of
                                {true, NewPs} ->
                                    #player_status{id = RoleId, figure = #figure{name = RoleName, lv = RoleLv}, team = #status_team{team_id = TeamId}} = NewPs,
                                    case data_boss:get_boss_cfg(BossId) of
                                        #boss_cfg{layers = Layers} ->Layers;
                                        _ -> Layers = 0
                                    end,
                                    NeedOut =lib_boss:is_in_outside_scene(Ps#player_status.scene),
                                    lib_log_api:log_enter_or_exit_boss(RoleId, RoleName, RoleLv, Layers, BossType, BossId, 0, Cost, 0,
                                            Ps#player_status.scene, Ps#player_status.x, Ps#player_status.y, TeamId),
                                    ta_agent_fire:log_enter_or_exit_boss(Ps, RoleLv, Layers, BossId, BossType, 0, 0, Ps#player_status.scene, Ps#player_status.x, Ps#player_status.y, TeamId),
                                    if
                                        BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
                                            mod_special_boss:enter(Ps#player_status.id, RoleLv, BossType, BossId, NeedOut),
                                            LastNewPS = NewPs;
                                        true ->
                                            AddAnger1 = lib_supreme_vip_api:get_anger_add(NewPs, BossType),
                                            AddAnger2 = lib_module_buff:get_boss_anger_add(NewPs, BossType),
                                            AddAnger = AddAnger1 + AddAnger2,
                                            mod_boss:enter(Ps#player_status.id, Ps#player_status.figure#figure.lv, Ps#player_status.weekly_card_status, BossType, BossId, AddAnger),
                                            LastNewPS = lib_scene:change_scene(NewPs, Scene, 0, 0, X, Y, NeedOut,  [{group, 0},
                                                {collect_checker, {lib_boss, check_collect_times, [Ps#player_status.id, BossType, BossId]}}])
                                    end,
                                    lib_guild_daily:enter_forbidden_boss(BossType, RoleId),
                                    mod_boss:handle_activitycalen_enter(LastNewPS#player_status.id,  BossType),
                                    lib_supreme_vip_api:enter_boss(RoleId, BossType, BossId),
                                    %% 我要变强
                                    StrongPs = lib_to_be_strong:update_data_boss(LastNewPS, BossType),
                                    {ok, StrongPs};
                                {false, Code, NewPs} ->
                                    lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [Code]),
                                    {ok, NewPs}
                            end
                    end
            end
    end;

%% 退出跨服秘境大妖
handle(46004, Ps, [?BOSS_TYPE_KF_GREAT_DEMON]) ->
    lib_great_demon_local:quit_great_demon(Ps);

%% 离开boss场景
handle(46004, Ps, [BossType]) ->
    #player_status{id = RoleId, sid = Sid, x = OldX, y = OldY, scene = Scene, copy_id = CopyId} = Ps,
    {IsOut, ErrCode} = lib_scene:is_transferable_out(Ps),
    IsBossScene = lib_boss:is_in_all_boss(Scene),
    if
        IsBossScene == false -> skip;
        IsOut == false andalso BossType =/= ?BOSS_TYPE_ABYSS ->
            {ok, BinData} = pt_460:write(46004, [ErrCode]),
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            if
                BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
                    mod_special_boss:exit(RoleId, BossType, Scene, OldX, OldY),
                    NewPs = lib_scene:change_scene(Ps, 0, 0, 0, 0, 0, true, [{group, 0},{change_scene_hp_lim, 100},{pk, {?PK_PEACE, true}}]);
                BossType == ?BOSS_TYPE_FEAST ->
                    mod_boss:quit(RoleId, BossType, CopyId, Scene, OldX, OldY),
                    NewPs = lib_scene:change_default_scene(Ps, [{group, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined},{change_scene_hp_lim, 100},{pk, {?PK_PEACE, true}}]);
                true ->
                    mod_boss:quit(RoleId, BossType, CopyId, Scene, OldX, OldY),
                    if
                        BossType == ?BOSS_TYPE_WORLD ->
                            {ok, NewPlayer} = lib_boss:quit_world_boss(Ps, ?INSPIRE_SKILL_ID);
                        true ->
                            NewPlayer = Ps
                    end,
                    NewPs = lib_scene:change_scene(NewPlayer, 0, 0, 0, 0, 0, true,
                        [{group, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined},{change_scene_hp_lim, 100},{pk, {?PK_PEACE, true}}])
            end,
            {ok, BinData} = pt_460:write(46004, [?SUCCESS]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, NewPs}
    end;

%% 蛮荒禁地BOSS怒气46005
handle(46005, Ps, _)->
    %% 检查场景在蛮荒禁地或上古神庙
    Scene = Ps#player_status.scene,
    IsInForbdden = lib_boss:is_in_forbdden_boss(Scene),
    IsInKfGreatDemon = lib_boss:is_in_kf_great_demon_boss(Scene),
    if
        IsInForbdden ->
            mod_boss:get_boss_anger(Ps#player_status.id);
        IsInKfGreatDemon ->
            mod_great_demon_local:get_boss_anger(Ps#player_status.id);
        true ->
            skip
    end;

%% 蛮荒禁地退出倒计时46006
handle(46006, Ps, _)->
    case lib_boss:is_in_forbdden_boss(Ps#player_status.scene) of
        false -> skip;
        _ -> mod_boss:get_boss_anger_time(Ps#player_status.id)
    end;

%% BOSS关注操作
handle(46007, Ps, [BossType, BossId, Remind, IsAuto]) ->
    if
        BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
            mod_special_boss:boss_remind_op(Ps#player_status.id, BossType, BossId, Remind); % 暂时没有自动关注的特殊处理
        BossType == ?BOSS_TYPE_KF_GREAT_DEMON ->
            mod_great_demon_local:remind_great_demon_boss(Ps#player_status.id, BossId, Remind, IsAuto);
        true ->
            mod_boss:boss_remind_op(Ps#player_status.id, BossType, BossId, Remind, IsAuto)
    end;



%% BOSS重生提醒46008

%% BOSS被击杀信息40009

%% BOSS场景小怪的列表
handle(46010, Ps, [BossType]) when BossType == ?BOSS_TYPE_FORBIDDEN->
    case lib_boss:is_in_forbdden_boss(Ps#player_status.scene) of
        false -> skip;
        _ ->
            case data_scene:get(Ps#player_status.scene) of
                #ets_scene{mon = Mons} -> MonIds = [{Mid, X, Y} || [Mid, X, Y, _, _] <- Mons];
                _ -> MonIds = []
            end,
            Args = [BossType, Ps#player_status.scene, MonIds],
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46010, Args)
    end;

%% BOSS 46011

%% 上古神庙随机怪坐标
handle(46012, Ps, [BossType, BossId]) ->
    mod_boss:temple_mon_rand_xy(Ps#player_status.sid, BossType, BossId);

%%世界boss图标显示
handle(46017, Ps, []) ->
    {ok, BinData} = pt_460:write(46017, [1]),
    lib_server_send:send_to_sid(Ps#player_status.sid, BinData);

%% 进入世界boss场景
handle(46018, Ps, [BossType, BossId]) ->
    IsOpenHour = lib_boss:is_open_hour(),
    % IsOpenHour = true,
    % ?PRINT("IsOpenHour:~p~n",[IsOpenHour]),
    Return = lib_boss:get_wldboss_status(),
    case lists:keyfind(BossId, 1, Return) of
        {BossId, Status} ->
            Status;
        _ ->
            Status = 0
    end,
    RewardL = case data_boss:get_reward_list(BossId,1,1) of
        [Reward] -> Reward;
        _ -> []
    end,
    % ?PRINT("Bossid:~p,Return:~p, Status:~p~n",[BossId,Return, Status]),
    case lib_goods_api:can_give_goods(Ps, RewardL) of
        true ->
            if
                Status == 1 andalso IsOpenHour == true ->
                    case data_boss:get_boss_cfg(BossId) of
                        [] -> lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46018, [?ERRCODE(err460_no_boss_cfg)]);
                        #boss_cfg{scene = ConfScene} when ConfScene == Ps#player_status.scene->
                            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46018, [?ERRCODE(err120_already_in_scene)]);
                        _ ->
                            case lib_player_check:check_list(Ps, [action_free, is_transferable]) of
                                {false, Code} ->
                                    lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46018, [Code]);
                                true->
                                    case check_enter_boss(Ps, BossType, BossId) of
                                        {false, Code} ->
                                            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46018, [Code]);
                                        {true, Scene, X, Y, _Cost} ->
                                            % mod_boss:enter(Ps#player_status.id, BossType, BossId),
                                            % ?PRINT("Scene:~p,X:~p,Y:~p",[Scene, X,Y]),
                                            #player_status{id = RoleId,
                                                figure = #figure{name = RoleName, lv = RoleLv},
                                                team = #status_team{team_id = TeamId}
                                            } = Ps,
                                            lib_log_api:log_enter_or_exit_boss(RoleId, RoleName, RoleLv, 0, BossType, BossId, 0, _Cost, 0,
                                                Ps#player_status.scene, Ps#player_status.x, Ps#player_status.y, TeamId),
                                            ta_agent_fire:log_enter_or_exit_boss(Ps, RoleLv, 0, BossId, BossType, 0, 0, Ps#player_status.scene, Ps#player_status.x, Ps#player_status.y, TeamId),
                                            NewPS = lib_scene:change_scene(Ps, Scene, 0, 0, X, Y, true, [{group, 0}]),
                                            NewPlayer = lib_activitycalen_api:role_success_end_activity(NewPS, ?MOD_BOSS, ?BOSS_TYPE_WORLD),
                                            mod_boss:get_inspire_count(Ps#player_status.id),
                                            mod_boss:add_inspire_buff(Ps#player_status.id,Ps#player_status.pid, Scene),
                                            handle(46022, NewPlayer, [BossType, BossId]),
                                            {ok, NewPlayer}
                                    end
                            end
                    end;
                Status == 0  ->
                    if
                        IsOpenHour == true ->
                            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46018, [?ERRCODE(err460_boss_die)]);
                        true ->
                            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46018, [?ERRCODE(err460_not_open)])
                    end;
                true ->
                    lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46018, [?ERRCODE(err460_not_open)])
            end;
        _ ->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46018, [?ERRCODE(err300_not_enough_cell)])
    end;
%% 世界boss内 鼓舞
handle(46020, Ps, [InspireType]) ->
    #player_status{id = RoleId, pid = Pid,figure = Figure} = Ps,
    BossId = lib_boss:get_bossid(Figure#figure.turn, Figure#figure.lv),
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{scene = Scene} ->
            if
                Ps#player_status.scene == Scene ->
                    mod_boss:inspire_self(RoleId, Pid, InspireType);
            true ->
                skip
            end;
        _ ->
            skip
    end;

%% 世界boss伤害排名
handle(46022, Ps, [BossType, BossId]) ->
    #player_status{pid = Pid, id = RoleId, figure = #figure{name = Name}} = Ps,
    mod_boss:rank_damage(BossType, BossId, Pid, RoleId, Name, 0),
    {ok, Ps};

%%获取世界boss状态
handle(46023, Ps, []) ->
    IsOpenHour = lib_boss:is_open_hour(),
    if
        IsOpenHour =/= true ->
            ShowWldBoss = lib_boss:get_wldBoss_need_show(),
            Fun = fun(BossId, Acc) ->
                [{BossId, 1}|Acc]
            end,
            Return = lists:foldl(Fun, [], ShowWldBoss);
        true ->
            Return = lib_boss:get_wldboss_status()
    end,
%%    ?PRINT("Return:~p IsOpenHour:~p~n",[Return,IsOpenHour]),
    lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46023, [Return]);

% handle(46024,Ps, [Layers]) ->
%     mod_boss:get_secret_boss_info(Layers, Ps#player_status.id);

handle(46031, PS, [BossId]) ->
    #player_status{id = RoleId} = PS,
    mod_boss:draw_data(BossId, RoleId),
    {ok, PS};

%% 秘境boss宝箱抽奖
handle(46032, PS, [BossId, Type]) ->
    NowTime = utime:unixtime(),
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = PS,
    MaxTimes = lib_boss:get_limit_times(),
    #fairyland_boss_data{times = CurTimes, role_id = BlRoleId, time = EndTime} = mod_boss:get_draw_data(BossId),
    if
        EndTime > NowTime andalso RoleId == BlRoleId andalso MaxTimes > CurTimes ->
            case data_boss:get_boss_draw_cost(CurTimes + 1) of
                [BgoldCost, GoldCost] when is_integer(BgoldCost) andalso is_integer(GoldCost) ->
                    CostList = if
                        Type == 1 ->
                            [{?TYPE_GOLD, 0, GoldCost}];
                        true ->
                            [{?TYPE_BGOLD, 0, BgoldCost}]
                    end,
                    case lib_goods_api:cost_object_list_with_check(PS, CostList, fairyland_boss_draw, "") of
                        {true, NewPS} ->
                            case data_boss:get_boss_extra_cfg(BossId) of
                                {[{PoolId, Num}|_], _Condition} ->
                                    {Pool, RewardL} = lib_boss:get_draw_pool(PoolId, Type, CurTimes + 1),
                                    CurNum = erlang:length(RewardL),
                                    if
                                        CurNum > Num ->
                                            NewRewardL = urand:get_rand_list(Num, RewardL);
                                        CurNum == Num ->
                                            NewRewardL = RewardL;
                                        CurNum < Num ->
                                            Fun = fun(_E, Acc) ->
                                                RewardCfg = urand:rand_with_weight(Pool),
                                                [RewardCfg|Acc]
                                            end,
                                            RewardL1 = lists:foldl(Fun, [], lists:seq(1, Num - CurNum)),
                                            NewRewardL = RewardL ++ RewardL1;
                                        true ->
                                            NewRewardL = []
                                    end,
                                    RealReward = lib_boss:handle_draw_reward(NewRewardL, RoleName),
                                    mod_boss:draw(BossId, CurTimes + 1, RoleId),
                                    Produce = #produce{reward = RealReward, type = fairyland_boss_draw, show_tips = ?SHOW_TIPS_0},
                                    NewPlayer = lib_goods_api:send_reward(NewPS, Produce),
                                    lib_log_api:log_fairyland_boss_draw(RoleId, RoleName, BossId, CurTimes + 1, RealReward, NowTime),
                                    lib_server_send:send_to_uid(RoleId, pt_460, 46032, [?SUCCESS, BossId, RealReward]);
                                _ ->
                                    NewPlayer = NewPS,
                                    lib_server_send:send_to_uid(RoleId, pt_460, 46032, [?ERRCODE(missing_config), BossId, []])
                            end,
                            {ok, NewPlayer};
                        {false, ErrCode, NewPS} ->
                            lib_server_send:send_to_uid(RoleId, pt_460, 46032, [ErrCode, BossId, []]),
                            {ok, NewPS}
                    end;
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_460, 46032, [?ERRCODE(missing_config), BossId, []])
            end;
        true ->
            if
                RoleId =/= BlRoleId ->
                    lib_server_send:send_to_uid(RoleId, pt_460, 46032, [?ERRCODE(not_blong_you), BossId, []]);
                CurTimes >= MaxTimes ->
                    lib_server_send:send_to_uid(RoleId, pt_460, 46032, [?ERRCODE(max_draw_times), BossId, []]);
                true ->
                    lib_server_send:send_to_uid(RoleId, pt_460, 46032, [?ERRCODE(time_out), BossId, []])
            end
    end;

handle(46034, PS, []) ->
    #player_status{id = RoleId, status_boss = #status_boss{boss_map = TmpMap} = OldStatusBoss} = PS,
    case data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE, player_die_times) of
        TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
        _ -> TimeCfg = 300
    end, %% 更新死亡debuff
    case data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE, revive_point_gost) of
        TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
        _ -> TimeCfg2 = 20
    end,
    case data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE, die_wait_time) of
        [{min_times, MinTimes},_,_]  -> skip;
        _ -> MinTimes = 0
    end,
    NowTime = utime:unixtime(),
    case maps:get(?BOSS_TYPE_NEW_OUTSIDE, TmpMap, []) of
        #role_boss{die_time = DieTime, die_times = DieTimes, next_enter_time = NextEnterTime} = Roleboss ->
            if
                DieTime+TimeCfg < NowTime ->
                    NewRoleBoss = Roleboss#role_boss{die_times = 0},
                    lib_boss:db_role_boss_replace(RoleId, NewRoleBoss);
                true ->
                    NewRoleBoss = Roleboss
            end,
            NewMap = maps:put(?BOSS_TYPE_NEW_OUTSIDE, NewRoleBoss, TmpMap),
            if
                DieTimes > MinTimes ->
                    lib_server_send:send_to_uid(RoleId, pt_460, 46034, [DieTimes, NextEnterTime, DieTime + TimeCfg, DieTime + TimeCfg2]);
                true ->
                    lib_server_send:send_to_uid(RoleId, pt_460, 46034, [DieTimes, NextEnterTime, DieTime + TimeCfg, 0])
            end;
        _ ->
            NewMap = TmpMap,
            lib_server_send:send_to_uid(RoleId, pt_460, 46034, [0, 0, 0, 0])
    end,
    {ok, PS#player_status{status_boss = OldStatusBoss#status_boss{boss_map = NewMap}}};

%% 获取秘境领域阶段奖励状态
handle(46037, Ps, []) ->
    %% mod_boss:get_domain_boss_reward(Ps#player_status.sid, Ps#player_status.id);
    mod_great_demon_local:send_demon_kill_reward_info(Ps#player_status.id);

%% 秘境领域阶段 领取奖励
handle(46038, #player_status{figure = #figure{ lv = RoleLv }, id = RoleId} = Ps, [RewardId]) ->
    %% mod_boss:take_domain_boss_reward(Ps#player_status.sid, Ps#player_status.id, Figure#figure.lv, RewardId);
    mod_great_demon_local:get_demon_kill_reward(RoleId, RoleLv, RewardId);

%% 进场景宝箱 和 特殊boss信息
handle(46039, Ps, []) ->
    %% mod_boss:send_domain_cl_boss(Ps#player_status.id);
    %% 暂时使用本服boss接口
    mod_great_demon_local:send_demon_box_info(Ps#player_status.id);

%% boss血量百分比显示
handle(46040, Status, []) ->
    #player_status{scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, sid=Sid} = Status,
    AllScene = data_hp_show:get_all_scene(),
    case lists:member(Scene, AllScene) of
        true ->
            mod_scene_agent:get_boss_hp_show(Scene, ScenePoolId, CopyId, Sid);
        _ ->
            {ok, BinData} = pt_460:write(46040, [[]]),
            lib_server_send:send_to_sid(Sid, BinData)
    end,
    {ok, Status};

%% 消耗复活
handle(46041, Status, [BossType, BossId]) ->
    #player_status{id = RoleId} = Status,
    mod_boss:cost_reborn(RoleId, BossType, BossId);

handle(46043, Status, [TemBossType]) when TemBossType == ?BOSS_TYPE_NEW_OUTSIDE orelse TemBossType == ?BOSS_TYPE_SPECIAL ->
    #player_status{
        id = RoleId, sid = Sid,
        figure = #figure{name = RoleName, vip = VipLv, vip_type = VipType},
        status_boss = OldStatusBoss
    } = Status,
    #status_boss{boss_map = TmpMap} = OldStatusBoss,
    BossType = ?BOSS_TYPE_NEW_OUTSIDE,
    case data_boss:get_boss_type(BossType) of
        #boss_type{} ->
            case maps:get(BossType, TmpMap, []) of
                #role_boss{vit = OldVit, last_vit_time = OldLastVitTime} = TemRoleBoss ->
                    #role_boss{vit = Vit, vit_add_today = VitAddToday, vit_can_back = VitCanBack, last_vit_time = LastVitTime} = RoleBoss = lib_boss:calc_vit(Status, BossType),
                    {ok, BinData} = pt_460:write(46043, []),
                    lib_server_send:send_to_sid(Sid, BinData),
                    ?PRINT("OldVit:~p OldLastVitTime:~p, Vit:~p~n",[OldVit, OldLastVitTime, Vit]),
                    VipAddMaxCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?NEW_OUTSIDE_BOSS_VIP_VALUE, VipType, VipLv),
                    CfgMaxVit = ?BOSS_TYPE_KV_MAX_VIT(BossType),
                    MaxVit = CfgMaxVit+VipAddMaxCount,
                    {ok, BinData1} = pt_460:write(46044, [Vit, MaxVit, VitAddToday, VitCanBack, LastVitTime]),
                    lib_server_send:send_to_sid(Sid, BinData1),
                    if
                        TemRoleBoss == RoleBoss ->
                            {ok, Status};
                        true ->
                            lib_boss:db_role_boss_replace(RoleId, RoleBoss),
                            NewBossMap = maps:put(BossType, RoleBoss, TmpMap),
                            StatusBoss = OldStatusBoss#status_boss{boss_map = NewBossMap},
                            NewPs = Status#player_status{status_boss = StatusBoss},
                            SceneData = lib_boss_api:make_boss_tired_map(NewPs, BossType),
                            mod_scene_agent:update(NewPs, [{scene_boss_tired, SceneData}]),

                            % ?PRINT("OldVit:~p, LastVitTime:~p~n",[OldVit, OldLastVitTime]),
                            % ?PRINT("Vit:~p, MaxVit:~p, LastVitTime:~p~n",[Vit,MaxVit,LastVitTime]),
                            AddVitTime = ?BOSS_TYPE_KV_ADD_VIT_TIME(BossType),
                            FixAddVitTime = lib_boss:vip_reduce_vit_time(Status, AddVitTime),
                            lib_log_api:log_boss_vit_change(RoleId, RoleName, OldVit, OldLastVitTime,
                                [], 0, Vit, LastVitTime, MaxVit, FixAddVitTime),
                            %% 更新协助boss状态
                            lib_guild_assist:update_bl_state(NewPs),
                            {ok, NewPs}
                    end;
                _ ->
                    {ok, Status}
            end;
        _ ->
            {ok, Status}
    end;

%% 体力值
handle(46044, Status, [BossType]) ->
    #player_status{
        sid = Sid,
        figure = #figure{vip = VipLv, vip_type = VipType},
        status_boss = #status_boss{boss_map = TmpMap}
    } = Status,
    case data_boss:get_boss_type(BossType) of
        #boss_type{} ->
            case maps:get(BossType, TmpMap, []) of
                #role_boss{vit = Vit, vit_add_today = VitAddToday, vit_can_back = VitCanBack, last_vit_time = LastVitTime} ->
                    VipAddMaxCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?NEW_OUTSIDE_BOSS_VIP_VALUE, VipType, VipLv),
                    CfgMaxVit = ?BOSS_TYPE_KV_MAX_VIT(BossType),
                    MaxVit = CfgMaxVit+VipAddMaxCount,
                    % ?PRINT("Vit:~p, MaxVit:~p, LastVitTime:~p~n",[Vit,MaxVit,LastVitTime]),
                    {ok, BinData} = pt_460:write(46044, [Vit, MaxVit, VitAddToday, VitCanBack, LastVitTime]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, Status};
                _ ->
                    {ok, Status}
            end;
        _ ->
            {ok, Status}
    end;

%% 找回boss体力
handle(46045, PS, [BossType, VitBackNum]) ->
    #player_status{sid = SId, status_boss = StatusBoss} = PS,
    #status_boss{boss_map = BossMap} = StatusBoss,
    RoleBoss = maps:get(BossType, BossMap),

    % 计算消耗
    F = fun({Type, Id, Num}) -> {Type, Id, Num * VitBackNum} end,
    BackVitCostOne = ?BOSS_TYPE_KF_BACK_VIT_COST(BossType),
    BackVitCost = lists:map(F, BackVitCostOne),

    % 检查
    CheckList = [
        {have_enough_back_vit, RoleBoss, VitBackNum}, {is_enough_money, PS, BackVitCost}
    ],
    case check_find_back_vit(CheckList) of
        true ->
            NewPS = lib_boss:find_back_vit(PS, BossType, VitBackNum, BackVitCost),
            lib_server_send:send_to_sid(SId, pt_460, 46045, [?SUCCESS]);
        {false, ErrCode} ->
            NewPS = PS,
            lib_server_send:send_to_sid(SId, pt_460, 46045, [ErrCode])
    end,
    {ok, NewPS};

handle(46046, Ps, [_BossType]) ->
    #player_status{ id = RoleId } = Ps,
    mod_great_demon_local:get_boss_drop_log(RoleId);

%% 默认匹配
handle(_Cmd, Ps, _Data) ->
   {ok, Ps}.


%% ================================= private fun =================================
before_check(Ps, BossType) ->
    List = [{gm_close, BossType}, {action_free}, {change_other_scene}],
    before_check_helper(Ps, List).

before_check_helper(Ps, [{gm_close, BossType}|T]) ->
    case lib_gm_stop:check_gm_close_act(?MOD_BOSS, 0) of
        true ->
            case lib_gm_stop:check_gm_close_act(?MOD_BOSS, BossType) of
                true -> before_check_helper(Ps, T);
                _ -> {false, ?ERR_GM_STOP}
            end;
        _ ->
            {false, ?ERR_GM_STOP}
    end;
before_check_helper(Ps, [{action_free}|T]) ->
    case lib_player_check:check_list(Ps, [action_free]) of
        {false, Code} ->
            {false, Code};
        _->
            before_check_helper(Ps, T)
    end;
before_check_helper(Ps, [{change_other_scene}|T]) ->
    case lib_boss:chang_other_mod_scene(Ps) of
        {false, Code} ->
            {false, Code};
        _->
            before_check_helper(Ps, T)
    end;
before_check_helper(_Ps, []) -> true.


%% 检查进入Boss场景
check_enter_boss(Ps, BossType, BossId) when BossType == ?BOSS_TYPE_OUTSIDE ->
    #player_status{figure = #figure{lv = Lv}} = Ps,
    BossTypeCfg = data_boss:get_boss_type(BossType),
    BossCfg = data_boss:get_boss_cfg(BossId),
    NeedLv = ?BOSS_TYPE_KV_LV_FOR_INIT_VIT(BossType),
    #role_boss{vit = CalcVit} = lib_boss:calc_vit(Ps, BossType),
    CostVit = ?BOSS_TYPE_KV_COST_VIT(BossType),
    CheckCost = lib_goods_api:check_object_list(Ps, ?BOSS_TYPE_KV_COST_TICKET(BossType)),
    if
        BossTypeCfg == [] -> {false, ?ERRCODE(err460_no_boss_type)};
        BossCfg == [] -> {false, ?ERRCODE(err460_no_boss_cfg)};
        % 必须是同一个类型
        BossCfg#boss_cfg.type =/= BossType -> {false, ?ERRCODE(err460_no_boss_cfg)};
        Lv < NeedLv -> {false, ?ERRCODE(err460_no_lv)};
        % 不够消耗以及体力不足
        CheckCost =/= true andalso CalcVit < CostVit -> {false, ?ERRCODE(err460_not_enough_vit_to_enter)};
        % TODO:装备背包最少空格
        true ->
            #boss_cfg{condition = Condition} = BossCfg,
            case check_condition(Condition, Ps) of
                true ->
                    #boss_cfg{scene = Scene, x = X, y = Y} = BossCfg,
                    case data_scene:get(Scene) of
                        #ets_scene{x = TX, y = TY} ->
                            {true, Scene, TX, TY, []};
                        _ ->
                            {true, Scene, X, Y, []}
                    end;
                {false, ErrCode} ->
                    {false, ErrCode}
            end
    end;
%% 检查进入Boss场景
check_enter_boss(Ps, BossType, BossId) when BossType == ?BOSS_TYPE_ABYSS ->
    #player_status{figure = #figure{lv = Lv}} = Ps,
    BossTypeCfg = data_boss:get_boss_type(BossType),
    BossCfg = data_boss:get_boss_cfg(BossId),
    if
        BossTypeCfg == [] -> {false, ?ERRCODE(err460_no_boss_type)};
        BossCfg == [] -> {false, ?ERRCODE(err460_no_boss_cfg)};
        % 必须是同一个类型
        BossCfg#boss_cfg.type =/= BossType -> {false, ?ERRCODE(err460_no_boss_cfg)};
        true ->
            #boss_cfg{condition = Condition, free_condition = FreeCondition, cost = Cost, scene = Scene, x = X, y = Y} = BossCfg,
            CheckCond = check_condition(Condition, Ps),
            CheckFreeCond = check_free_condition(FreeCondition, Ps),
            CheckCost = lib_goods_api:check_object_list(Ps, Cost),
            if
                CheckCond =/= true -> CheckCond;
                CheckCost =/= true andalso CheckFreeCond =/= true -> CheckCost;
                true ->
                    #boss_cfg{condition = Condition, scene = Scene, x = X, y = Y} = BossCfg,
                    case lists:keyfind(lv, 1, Condition) of
                        {lv,MinLv} ->
                            if
                                Lv >= MinLv ->
                                    case data_scene:get(Scene) of
                                        #ets_scene{type = SceneType, x = TX, y = TY} -> ?PRINT("SceneType:~p,Scene:~p~n",[SceneType,Scene]),ok;
                                        _ -> TX = X, TY = Y
                                    end,
                                    case CheckFreeCond of
                                        true -> {true, Scene, TX, TY, []};
                                        _ -> {true, Scene, TX, TY, Cost}
                                    end;
                                true ->
                                    {false, ?ERRCODE(err460_lv_not_enought_enter)}
                            end;
                        _ ->
                            {false, ?ERRCODE(err460_no_boss_cfg)}
                    end
            end
    end;
check_enter_boss(Ps, BossType, BossId) when BossType == ?BOSS_TYPE_WORLD ->
    OpenDay = util:get_open_day(),
    {_,_, [{Min,Max}]} = lib_boss:get_wldboss_cfg(),
    #player_status{figure = #figure{lv = _Lv, turn = Turn}} = Ps,
    BossTypeCfg = data_boss:get_boss_type(BossType),
    BossCfg = data_boss:get_boss_cfg(BossId),
    if
        OpenDay < Min orelse OpenDay > Max -> {false, ?ERRCODE(err460_not_in_server_openday_range)};
        BossTypeCfg == [] -> {false, ?ERRCODE(err460_no_boss_type)};
        BossCfg == [] -> {false, ?ERRCODE(err460_no_boss_cfg)};
        % 必须是同一个类型
        BossCfg#boss_cfg.type =/= BossType -> {false, ?ERRCODE(err460_no_boss_cfg)};
        true ->
            #boss_cfg{condition = Condition, scene = Scene, x = X, y = Y} = BossCfg,
            case lists:keyfind(turn, 1, Condition) of
                % [{lv,MinLv,MaxLv},{turn, MinT, MaxT}] ->
                {turn, MinT, MaxT} ->
                    % IsLvEnougth = (Lv >= MinLv andalso Lv =< MaxLv),
                    if
                        % IsLvEnougth andalso (Turn >= MinT andalso Turn =< MaxT) ->
                        Turn >= MinT andalso Turn =< MaxT ->
                            case data_scene:get(Scene) of
                                #ets_scene{x = TX, y = TY} -> ok;
                                _ -> TX = X, TY = Y
                            end,
                            {true, Scene, TX, TY, []};
                        % IsLvEnougth == false ->
                        %     {false, ?ERRCODE(err460_lv_not_enought_enter)};
                        true ->
                            {false, ?ERRCODE(err460_turn_not_enought_enter)}
                    end;
                _ ->
                    {false, ?ERRCODE(err460_no_boss_cfg)}
            end
    end;

check_enter_boss(Ps, BossType, BossId) when BossType == ?BOSS_TYPE_FORBIDDEN ->
    BossTypeCfg = data_boss:get_boss_type(BossType),
    BossCfg = data_boss:get_boss_cfg(BossId),
%%    EquipBagNum = lib_goods_api:get_cell_num(Ps, ?GOODS_LOC_BAG),
    if
%%        EquipBagNum < 10 ->   {false, ?ERRCODE(err460_not_enough_bag)};   % 普通装备加20个位置
        BossTypeCfg == [] -> {false, ?ERRCODE(err460_no_boss_type)};
        true ->
            #boss_type{cost = BossCost, condition = BossCondition, count = DefMaxCount, module = _Module, daily_id = _DailyId} = BossTypeCfg,
            MaxCount = get_vip_count_add(BossType, DefMaxCount, Ps),
            UsedCount = mod_daily:get_count(Ps#player_status.id, ?MOD_BOSS, ?MOD_BOSS_ENTER, BossType),
            if
                MaxCount /= 0 andalso MaxCount =< UsedCount ->
                    {false, ?ERRCODE(err460_count_max)};
                true  ->
                    check_boss_forbidden_condition(Ps, BossCost, BossCondition, BossCfg, UsedCount)
            end
    end;


check_enter_boss(Ps, BossType, BossId) when BossType == ?BOSS_TYPE_DOMAIN ->
    BossTypeCfg = data_boss:get_boss_type(BossType),
    BossCfg = data_boss:get_boss_cfg(BossId),
    if
        BossTypeCfg == [] -> {false, ?ERRCODE(err460_no_boss_type)};
        true ->
            #boss_type{cost = BossCost, condition = BossCondition, count = DefMaxCount, module = _Module, daily_id = _DailyId} = BossTypeCfg,
            MaxCount = get_vip_count_add(BossType, DefMaxCount, Ps),
            UsedCount = mod_daily:get_count(Ps#player_status.id, ?MOD_BOSS, ?MOD_BOSS_ENTER, BossType),
            if
                MaxCount /= 0 andalso MaxCount =< UsedCount ->
                    {false, ?ERRCODE(err460_count_max)};
                true  ->
                    check_boss_forbidden_condition(Ps, BossCost, BossCondition, BossCfg, UsedCount)
            end
    end;


check_enter_boss(Ps, BossType, BossId) when BossType == ?BOSS_TYPE_FAIRYLAND; BossType == ?BOSS_TYPE_NEW_OUTSIDE;
                                            BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER;
                                            BossType == ?BOSS_TYPE_WORLD_PER ->
    #player_status{figure = #figure{lv = Lv}} = Ps,
    BossTypeCfg = data_boss:get_boss_type(BossType),
    BossCfg = data_boss:get_boss_cfg(BossId),
    EquipBagCell = lib_goods_api:get_cell_num(Ps, ?GOODS_LOC_BAG),
    % CanEnter = check_enter_time(Ps, BossType),
    EquipCfg = get_bag_cell_cfg(BossType),
    if
        BossTypeCfg == [] -> {false, ?ERRCODE(err460_no_boss_type)};
        BossCfg == [] -> {false, ?ERRCODE(err460_no_boss_cfg)};
        EquipBagCell < EquipCfg, BossType /= ?BOSS_TYPE_PHANTOM_PER -> {false, ?ERRCODE(err460_not_enough_bag)};
        % 必须是同一个类型
        % CanEnter == false -> {false, ?ERRCODE(err460_debuff)};
        BossCfg#boss_cfg.type =/= BossType -> {false, ?ERRCODE(err460_no_boss_cfg)};
        true ->
            #boss_cfg{condition = Condition, scene = Scene, x = X, y = Y} = BossCfg,
            case Condition of
                [{lv,MinLv}] ->
                    if
                        Lv >= MinLv ->
                            case data_scene:get(Scene) of
                                #ets_scene{x = TX, y = TY} -> ok;
                                _ -> TX = X, TY = Y
                            end,
                            {true, Scene, TX, TY, []};
                        true ->
                            {false, ?ERRCODE(err460_lv_not_enought_enter)}
                    end;
                _ ->
                    {false, ?ERRCODE(err460_no_boss_cfg)}
            end
    end;

check_enter_boss(Ps, BossType, BossId) when
      BossType =/= ?BOSS_TYPE_VIP_PERSONAL andalso BossType =/= ?BOSS_TYPE_PERSONAL ->
    BossTypeCfg = data_boss:get_boss_type(BossType),
    BossCfg = data_boss:get_boss_cfg(BossId),
    if
        BossTypeCfg == [] -> {false, ?ERRCODE(err460_no_boss_type)};
        %% BossCfg == [] -> {false, ?ERRCODE(err460_no_boss_cfg)};
        true ->
            #boss_type{cost = BossCost, condition = BossCondition,
                       count = DefMaxCount, module = _Module, daily_id = _DailyId} = BossTypeCfg,
            MaxCount = get_vip_count_add(BossType, DefMaxCount, Ps),
            if
                BossType == ?BOSS_TYPE_FORBIDDEN orelse BossType == ?BOSS_TYPE_TEMPLE ->
                    UsedCount = mod_daily:get_count(Ps#player_status.id, ?MOD_BOSS, ?MOD_BOSS_ENTER, BossType);
                true ->
                    UsedCount = 0
            end,
            if
                MaxCount /= 0 andalso MaxCount =< UsedCount andalso
                    (BossType == ?BOSS_TYPE_FORBIDDEN orelse BossType == ?BOSS_TYPE_TEMPLE)->
                    {false, ?ERRCODE(err460_count_max)};
                BossType == ?BOSS_TYPE_HOME ->
                    check_boss_home_condition(Ps, BossCost, BossCondition, BossCfg);
                BossType == ?BOSS_TYPE_FORBIDDEN orelse BossType == ?BOSS_TYPE_TEMPLE ->
                    check_boss_forbidden_condition(Ps, BossCost, BossCondition, BossCfg, UsedCount);
                true ->
                    case check_condition(BossCondition, Ps) of
                        true ->
                            #boss_cfg{scene = Scene, x = X, y = Y} = BossCfg,
                            case data_scene:get(Scene) of
                                #ets_scene{x = TX, y = TY} ->
                                    {true, Scene, TX, TY, []};
                                _ ->
                                    {true, Scene, X, Y, []}
                            end;
                        {false, ErrCode} ->
                            {false, ErrCode}
                    end
            end
    end;

check_enter_boss(_Ps, _BossType, _BossId) ->
    {false, ?ERRCODE(err460_no_boss_type)}.

%% boss家园的检查
check_boss_home_condition(Ps, _BossCost, _BossCondition, BossCfg)->
    #boss_cfg{scene = Scene, x = X, y = Y, cost = Cost, condition = Condition} = BossCfg,
    %% 检查玩家的vip的等级
    case data_scene:get(Scene) of
        #ets_scene{x = TX, y = TY} -> ok;
        _ -> TX = X, TY = Y
    end,
    NoVipErrCode = ?ERRCODE(err460_no_vip),
    case check_condition(Condition, Ps) of
        true -> {true, Scene, TX, TY, []};
        {false, NoVipErrCode} ->
            #role_vip{vip_lv = VipLv} = Ps#player_status.vip,
            if
                VipLv < 4 ->
                    {false, ?ERRCODE(pt_450_vip_lower)};
                true ->
                    case lib_goods_api:check_object_list(Ps, Cost) of
                        true -> {true, Scene, TX, TY, Cost};
                        {false, ErrCode}-> {false, ErrCode}
                    end
            end;
        {false, ErrCode} -> {false, ErrCode}
    end.

%% 蛮荒禁地：检查玩家的等级,扣除整个类型的物品
check_boss_forbidden_condition(Ps, BossCost, _BossCondition, BossCfg, UsedCount)->
    #boss_cfg{scene = Scene, x = X, y = Y, condition = Condition} = BossCfg,
    case check_condition(Condition, Ps) of
        true ->
            if
                BossCost == [] -> {false, ?ERRCODE(err460_no_boss_cfg)};
                true ->
                    {Type, GoodsId, Num} =
                    case lists:keyfind(UsedCount+1, 1, BossCost) of
                        false ->
                            {_, [{Type1, GoodsId1, Num1}|_]} = lists:last(lists:keysort(1, BossCost)),
                            {Type1, GoodsId1, Num1};
                        {_, [{Type2, GoodsId2, Num2}|_]} ->
                            {Type2, GoodsId2, Num2}
                    end,
                    case data_goods:get_goods_buy_price(GoodsId) of
                        {0, 0} -> {false, ?ERRCODE(err460_not_boss_buy)};
                        {_, Price} ->
                            {TX,TY} =
                            case data_scene:get(Scene) of
                                #ets_scene{x = _TX, y = _TY} -> {_TX, _TY};
                                _ -> {X,Y}
                            end,
%%                          查询物品数量
                            [{_, GNum}|_] = lib_goods_do:goods_num([GoodsId]),
                            if
%%                              物品足够
                                GNum >= Num -> {true, Scene, TX, TY, [{Type, GoodsId, Num}]};
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
                                        {false, ErrCode}-> {false, ErrCode}
                                    end
                            end
                    end
            end;
        {false, ErrCode} ->
            {false, ErrCode}
    end.

check_condition([], _Ps) -> true;
check_condition([{vip, NeedVip}|Condition], Ps) ->
    #role_vip{vip_lv = VipLv} = Ps#player_status.vip,
    if
        VipLv >= NeedVip -> check_condition(Condition, Ps);
        true -> {false, ?ERRCODE(err460_no_vip)}%vip_no
    end;
check_condition([{vip_type, NeedVipType}|Condition], Ps) ->
    #role_vip{vip_type = VipType} = Ps#player_status.vip,
    if
        VipType >= NeedVipType -> check_free_condition(Condition, Ps);
        true -> {false, ?ERRCODE(err460_no_vip_type_to_free)}
    end;
check_condition([{lv, NeedLv}|Condition], Ps) ->
    #figure{lv = Lv} = Ps#player_status.figure,
    if
        Lv >= NeedLv -> check_condition(Condition, Ps);
        true -> {false, ?ERRCODE(err460_no_lv)}%lv_no
    end;
check_condition([{max_lv, MaxLv}|Condition], Ps) ->
    #figure{lv = Lv} = Ps#player_status.figure,
    if
        Lv =< MaxLv -> check_condition(Condition, Ps);
        true -> {false, ?ERRCODE(err460_max_lv)}%lv_no
    end.

check_free_condition([], _Ps) -> true;
check_free_condition([{vip, NeedVip}|Condition], Ps) ->
    #role_vip{vip_lv = VipLv} = Ps#player_status.vip,
    if
        VipLv >= NeedVip -> check_free_condition(Condition, Ps);
        true -> {false, ?ERRCODE(err460_no_vip_to_free)}
    end;
check_free_condition([{vip_type, NeedVipType}|Condition], Ps) ->
    #role_vip{vip_type = VipType} = Ps#player_status.vip,
    if
        VipType >= NeedVipType -> check_free_condition(Condition, Ps);
        true -> {false, ?ERRCODE(err460_no_vip_type_to_free)}
    end;
check_free_condition([{lv, NeedLv}|Condition], Ps) ->
    #figure{lv = Lv} = Ps#player_status.figure,
    if
        Lv >= NeedLv -> check_free_condition(Condition, Ps);
        true -> {false, ?ERRCODE(err460_no_lv_to_free)}
    end.

%% 体力找回检查
check_find_back_vit([ {have_enough_back_vit, RoleBoss, VitBackNum} | T ]) ->
    #role_boss{vit_can_back = VitCanBack} = RoleBoss,
    case VitBackNum > 0 andalso VitCanBack >= VitBackNum of
        true ->
            check_find_back_vit(T);
        false ->
            {false, ?FAIL}
    end;
check_find_back_vit([ {is_enough_money, PS, BackVitCost} | T ]) ->
    case lib_goods_api:check_object_list(PS, BackVitCost) of
        true ->
            check_find_back_vit(T);
        Error ->
            Error
    end;
check_find_back_vit(_) -> true.

%% 根据vip的等级增加蛮荒禁地或上古神庙的进入次数
get_vip_count_add(Type, DefMaxCount, #player_status{figure = #figure{vip = VipLv, vip_type = VipType}})->
    if
        Type == ?BOSS_TYPE_FORBIDDEN orelse Type == ?BOSS_TYPE_TEMPLE->
            DefMaxCount + lib_vip_api:get_vip_privilege(?MOD_BOSS, ?VIP_BOSS_ENTER(Type), VipType, VipLv);
        true -> DefMaxCount
    end.

get_bag_cell_cfg(BossType) ->
    if
        BossType == ?BOSS_TYPE_FAIRYLAND orelse BossType == ?BOSS_TYPE_NEW_OUTSIDE->
            case data_boss:get_boss_type_kv(BossType,equip_bag_cell_num) of
                ECfg when is_integer(ECfg) -> ECfg;
                _ -> ECfg = 0
            end,
            ECfg;
        true ->
            0
    end.

% check_enter_time(Ps, BossType) when BossType == ?BOSS_TYPE_NEW_OUTSIDE; BossType == ?BOSS_TYPE_SPECIAL ->
%     NowTime = utime:unixtime(),
%     #player_status{status_boss = #status_boss{boss_map = BossMap}} = Ps,
%     case maps:get(?BOSS_TYPE_NEW_OUTSIDE, BossMap) of
%         #role_boss{next_enter_time = NextEnterTime} ->
%             if
%                 NowTime >= NextEnterTime ->
%                     true;
%                 true ->
%                     false
%             end;
%         _ ->
%             true
%     end;
% check_enter_time(_Ps, _BossType) -> true.