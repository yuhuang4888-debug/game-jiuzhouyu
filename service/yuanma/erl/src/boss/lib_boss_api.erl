%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 25 Nov 2017 by root <root@localhost.localdomain>

-module(lib_boss_api).

-compile(export_all).

-include("server.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("drop.hrl").
-include("boss.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("def_module.hrl").
-include("battle.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("dungeon.hrl").
-include("predefine.hrl").
-include("guild.hrl").
-include("cluster_sanctuary.hrl").
-include("sanctuary.hrl").
-include("eudemons_land.hrl").
-include("team.hrl").

%% 伤害
be_hurted(Object, Pid, RoleId, Name, Hurt) ->
    #scene_object{scene = ObjectScene, mon = MonInfo, battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}} = Object,
    #scene_mon{mid = BossId} = MonInfo,
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{scene = ObjectScene, type = BossType} when
                BossType == ?BOSS_TYPE_OUTSIDE;
                BossType == ?BOSS_TYPE_ABYSS ->
            mod_boss:be_hurted(BossType, BossId, Hp, HpLim, RoleId, Hurt);
        #boss_cfg{scene = ObjectScene, type = BossType} when
                BossType == ?BOSS_TYPE_WORLD ->
            mod_boss:rank_damage(BossType, BossId, Pid, RoleId, Name, Hurt);
        _ ->
            skip
    end.

%% 抢夺归属
rob_mon_bl(EtsScene, RoleId, RobbedId, BossId) ->
    #ets_scene{id = ObjectScene} = EtsScene,
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{scene = ObjectScene, type = BossType} when BossType == ?BOSS_TYPE_OUTSIDE ->
            mod_boss:add_rob_count(BossType, BossId, RoleId),
            mod_boss:add_robbed_count(BossType, BossId, RobbedId);
        _ ->
            skip
    end.

get_boss_lv(BossId) ->
    case data_mon:get(BossId) of
        #mon{lv = Lv} -> Lv;
        _ -> Lv = 0
    end,
    Lv.

get_fairyboss_tired(RoleId)->
    case data_boss:get_boss_type(?BOSS_TYPE_FAIRYLAND) of
        #boss_type{boss_type = BossType} ->
            BossTired = mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_SUB_FAIRYLAND_BOSS, BossType);
        _ -> BossTired = skip
    end,
    BossTired.

get_new_outside_boss_maxtired(PS) -> %%获取当前疲劳值限制
    BossType = ?BOSS_TYPE_NEW_OUTSIDE,
    MaxVit = ?BOSS_TYPE_KV_MAX_VIT(BossType),
    #player_status{status_boss = StatusBoss, figure = #figure{vip = VipLv, vip_type = VipType}} = PS,
    #status_boss{boss_map = BossMap} = StatusBoss,
    #role_boss{vit = Vit} = maps:get(BossType, BossMap),
    VipAddMaxCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?NEW_OUTSIDE_BOSS_VIP_VALUE, VipType, VipLv),
    {MaxVit+VipAddMaxCount, Vit}.

%% 构造疲劳值map
make_boss_tired_map(PS) ->
    F = fun(BossType, Map) ->
        SceneBossTired = make_boss_tired_map(PS, BossType),
        maps:put(BossType, SceneBossTired, Map)
    end,
    lists:foldl(F, #{}, [?BOSS_TYPE_NEW_OUTSIDE, ?BOSS_TYPE_KF_SANCTUARY, ?BOSS_TYPE_SANCTUARY, ?BOSS_TYPE_PHANTOM]).

make_boss_tired_map(#player_status{id = _RoleId} = PS, BossType = ?BOSS_TYPE_NEW_OUTSIDE) ->
    {MaxVit, Vit} = get_new_outside_boss_maxtired(PS),
    #scene_boss_tired{boss_type = BossType, tired = Vit, max_tired = MaxVit};
make_boss_tired_map(#player_status{sanctuary_cluster = #status_sanctuary_cluster{anger = BossTired}}, BossType = ?BOSS_TYPE_KF_SANCTUARY) ->
    MaxTired = data_cluster_sanctuary_m:get_san_value(anger_limit),
    #scene_boss_tired{boss_type = BossType, tired = BossTired, max_tired = MaxTired};
make_boss_tired_map(#player_status{id = RoleId}, BossType = ?BOSS_TYPE_SANCTUARY) ->
    MaxTired =  case data_sanctuary:get_kv(fatigue_limit) of
        AngerLimit when is_integer(AngerLimit) -> AngerLimit;
        _ -> 100
    end,
    BossTired = mod_daily:get_count(RoleId, ?MOD_SANCTUARY, ?sanctuary_boss_tired_daily_id),
    #scene_boss_tired{boss_type = BossType, tired = BossTired, max_tired = MaxTired};
make_boss_tired_map(Ps, BossType = ?BOSS_TYPE_PHANTOM) ->
    #eudemons_boss_type{tired = OldTired} = data_eudemons_land:get_eudemons_boss_type(?BOSS_TYPE_EUDEMONS),
    NewMaxTired = OldTired + lib_eudemons_land:get_extra_times(Ps),
    BossTired = lib_eudemons_land:get_boss_tired(Ps#player_status.id),
    #scene_boss_tired{boss_type = BossType, tired = BossTired, max_tired = NewMaxTired};
make_boss_tired_map(_PS, BossType) ->
    #scene_boss_tired{boss_type = BossType}.

handle_event(#player_status{id = RoleId, last_task_id = LastTaskId, figure = #figure{lv = Lv}} = Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
    mod_boss:lv_up(RoleId, Lv),
    %% 野外boss特殊层数据初始化,未完成任务才会初始化
    LastTaskId =< ?SPECIAL_BOSS_TASK_ID
        andalso mod_special_boss:boss_init(RoleId, Lv, ?BOSS_TYPE_SPECIAL),
    mod_special_boss:boss_init(RoleId, Lv, ?BOSS_TYPE_PHANTOM_PER),
    mod_special_boss:boss_init(RoleId, Lv, ?BOSS_TYPE_WORLD_PER),
    %% 目前只有一个boss升级就不处理关注逻辑了
    % mod_special_boss:lv_up(RoleId, Lv),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_VIP, data = EventData}) ->
    #player_status{
        sid = Sid, id = RoleId, status_boss = #status_boss{boss_map = TmpMap} = OldStatusBoss
    } = Player,
    #callback_vip_change{old_vip_type = OldVipType, new_vip_type = VipType, old_vip_lv = OldVipLv, new_vip_lv = VipLv} = EventData,
    BossType = ?BOSS_TYPE_NEW_OUTSIDE,
    OldVipAddCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?NEW_OUTSIDE_BOSS_VIP_VALUE, OldVipType, OldVipLv),
    VipAddCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?NEW_OUTSIDE_BOSS_VIP_VALUE, VipType, VipLv),
    case maps:get(BossType, TmpMap, []) of
        #role_boss{vit = Vit, vit_add_today = VitAddToday, vit_can_back = VitCanBack, last_vit_time = LastVitTime} = TemRoleBoss ->
            NewVit = Vit + max(0, VipAddCount - OldVipAddCount),
            RoleBoss = TemRoleBoss#role_boss{vit = NewVit},
            lib_boss:db_role_boss_replace(RoleId, RoleBoss),
            NewBossMap = maps:put(BossType, RoleBoss, TmpMap),
            StatusBoss = OldStatusBoss#status_boss{boss_map = NewBossMap},
            NewPs = Player#player_status{status_boss = StatusBoss},
            SceneData = lib_boss_api:make_boss_tired_map(NewPs, BossType),
            mod_scene_agent:update(NewPs, [{scene_boss_tired, SceneData}]),
            CfgMaxVit = ?BOSS_TYPE_KV_MAX_VIT(BossType),
            MaxVit = CfgMaxVit+VipAddCount,
            {ok, BinData} = pt_460:write(46044, [NewVit, MaxVit, VitAddToday, VitCanBack, LastVitTime]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, NewPs};
        _ ->
            {ok, Player}
    end;

handle_event(Player, #event_callback{type_id = ?EVENT_GOODS_DROP, data = Data}) when is_record(Player, player_status) ->
%%    #player_status{id = RoleId, figure = #figure{name = Name}} = Player,
    #callback_goods_drop{mon_args = MonArgs, alloc = Alloc, goods_list = GoodsList, up_goods_list = UpGoodsL} = Data,
    #mon_args{scene = ObjectScene, mid = Mid} = MonArgs,
    IsInPhantomBoss = lib_boss:is_in_phantom_boss(ObjectScene),
    IsCommonDo = lib_boss:is_in_outside_boss(ObjectScene) orelse lib_boss:is_in_abyss_boss(ObjectScene)
        orelse lib_boss:is_in_fairy_boss(ObjectScene) orelse lib_boss:is_in_forbdden_boss(ObjectScene)
        orelse lib_boss:is_in_new_outside_boss(ObjectScene) orelse lib_boss:is_in_special_boss(ObjectScene),
%%    InBoss = lib_boss:is_in_boss(ObjectScene),
    SeeRewardL = lib_goods_api:make_see_reward_list(GoodsList, UpGoodsL),
%%    if
%%        InBoss ->
%%            BossType = lib_boss:get_boss_type_by_scene(ObjectScene),
%%            boss_add_drop_log(RoleId, Name, ObjectScene, BossType, Mid, SeeRewardL, UpGoodsL);
%%        true ->
%%            skip
%%    end,
    if
        IsInPhantomBoss ->
            if
                Alloc == ?ALLOC_SINGLE -> RewardType = 1;
                Alloc == ?ALLOC_SINGLE_2 -> RewardType = 2;
                true -> RewardType = 0
            end,
            {_IsReward, NewPlayer, FirstReward} = lib_boss:send_first_reward(Player, ObjectScene, Mid),
            {ok, BinData} = pt_460:write(46015, [RewardType, FirstReward++SeeRewardL]),
           lib_server_send:send_to_sid(Player#player_status.sid, BinData);
        IsCommonDo ->
            if
                Alloc == ?ALLOC_SINGLE -> RewardType = 1;
                Alloc == ?ALLOC_SINGLE_2 -> RewardType = 2;
                true -> RewardType = 0
            end,
            {_IsReward, NewPlayer, FirstReward} = lib_boss:send_first_reward(Player, ObjectScene, Mid),
            % ?PRINT("GoodsList:~p SeeRewardL:~p FirstReward:~p ~n", [GoodsList, SeeRewardL, FirstReward]),
            mod_boss:set_reward(Player#player_status.id, [{RewardType, ?REWARD_SOURCE_DROP, SeeRewardL}, {?REWARD_SOURCE_FIRST, FirstReward}]);
        true ->
            NewPlayer = Player
    end,
    {ok, NewPlayer};

handle_event(Player, #event_callback{type_id = ?EVENT_OTHERS_DROP, data = DataMap}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{name = _Name}, team = #status_team{team_id = TeamId}} = Player,
    DropList = maps:get(goods, DataMap, []),
    UpGoodsL = maps:get(up_goods_list, DataMap, []),
    ObjectScene = maps:get(scene, DataMap, Player#player_status.scene),
    _Alloc = maps:get(alloc, DataMap, 0),
    Mid = maps:get(mid, DataMap, 0),
    InBoss = lib_boss:is_in_boss(ObjectScene),
    SeeRewardL = lib_goods_api:make_see_reward_list(DropList, UpGoodsL),
    if
        InBoss ->
            BossType = lib_boss:get_boss_type_by_scene(ObjectScene),
            Name = lib_player:get_wrap_role_name(Player),
            boss_add_drop_log(RoleId, Name, ObjectScene, BossType, Mid, SeeRewardL, UpGoodsL, TeamId);
        true ->
            skip
    end,
    % 幻兽boss:玩家的数据不在进程中无法处理
    case lib_boss:is_in_outside_boss(ObjectScene) orelse lib_boss:is_in_abyss_boss(ObjectScene)
        orelse lib_boss:is_in_fairy_boss(ObjectScene) orelse lib_boss:is_in_new_outside_boss(ObjectScene)
        orelse lib_boss:is_in_forbdden_boss(ObjectScene) orelse lib_boss:is_in_special_boss(ObjectScene) of
        % orelse lib_boss:is_in_phantom_boss(ObjectScene) of
        true ->
            % SeeRewardL = lib_goods_api:make_see_reward_list(DropList, UpGoodsL),
            mod_boss:set_reward(Player#player_status.id, [{?REWARD_SOURCE_OTHER_DROP, SeeRewardL}]);
        false ->
            skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_TASK_DROP, data = Data}) when is_record(Player, player_status) ->
    #callback_task_drop{see_reward_list = SeeRewardL, scene_id = ObjectScene} = Data,
    % 幻兽boss:玩家的数据不在进程中无法处理
    case lib_boss:is_in_outside_boss(ObjectScene) orelse lib_boss:is_in_abyss_boss(ObjectScene)
        orelse lib_boss:is_in_fairy_boss(ObjectScene) orelse lib_boss:is_in_new_outside_boss(ObjectScene)
        orelse lib_boss:is_in_forbdden_boss(ObjectScene) orelse lib_boss:is_in_special_boss(ObjectScene) of
        % orelse lib_boss:is_in_phantom_boss(ObjectScene) of
        true -> mod_boss:set_reward(Player#player_status.id, [{?REWARD_SOURCE_TASK_DROP, SeeRewardL}]);
        false -> skip
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = Data}) when is_record(Player, player_status) ->
    #player_status{
        id = DieId, scene = SceneId, x = X, y = Y, online = Online, figure = #figure{name = DerName, mask_id = DerMaskId},
        guild = #status_guild{id = GuildId}, copy_id = CopyId
    }=Player,
    #{attersign := AtterSign, atter := Atter, hit := _HitList} = Data,
    #battle_return_atter{real_id = AtterId, real_name = AtterName, guild_id = AtterGuildId, mask_id = AttMaskId} = Atter,
    #ets_scene{type = Type} = data_scene:get(SceneId),
    % 被玩家打死有效
    if
        Type == ?SCENE_TYPE_OUTSIDE_BOSS;Type == ?SCENE_TYPE_NEW_OUTSIDE_BOSS;
        Type == ?SCENE_TYPE_ABYSS_BOSS; Type == ?SCENE_TYPE_SPECIAL_BOSS->
            case AtterSign == ?BATTLE_SIGN_PLAYER orelse Type == ?SCENE_TYPE_SPECIAL_BOSS orelse
            Type == ?SCENE_TYPE_NEW_OUTSIDE_BOSS of
                true -> mod_boss:player_die(SceneId, AtterSign, AtterId, AtterName, AtterGuildId, AttMaskId, DieId, GuildId, DerName, DerMaskId, X, Y);
                false -> skip
            end,
            if
                Type == ?SCENE_TYPE_ABYSS_BOSS andalso Online =/= 1 ->
                    mod_boss:quit(DieId, ?BOSS_TYPE_ABYSS, CopyId, SceneId, X, Y),
                    NewPs = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true,
                        [{group, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined},{change_scene_hp_lim, 100},{pk, {?PK_PEACE, true}}]);
                true ->
                    NewPs = Player
            end,
            {ok, NewPs};
        true ->
            {ok, Player}
    end;

handle_event(Player, #event_callback{type_id = ?EVENT_DROP_CHOOSE, data = Data}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, scene = SceneId, figure = #figure{name = _Name}, team = #status_team{team_id = TeamId}} = Player,
    #{goods := DropReward, see_reward := SeeRewardList, up_goods_list := UpGoodsList, mon_id := MonId} = Data,
    InBoss = lib_boss:is_in_boss(SceneId),
    [{_, GoodsTypeId, _}|_] = DropReward,
    IsRare = lists:member(GoodsTypeId, ?BOSS_TYPE_KV_LOG_GOODS_LIST(?BOSS_TYPE_GLOBAL)),
    if
        InBoss == true andalso IsRare == true ->
            BossType = lib_boss:get_boss_type_by_scene(SceneId),
            Name = lib_player:get_wrap_role_name(Player),
            boss_add_drop_log(RoleId, Name, SceneId, BossType, MonId, SeeRewardList, UpGoodsList, TeamId);
        true ->
            skip
    end,
    {ok, Player};

handle_event(Player, _EventCallback) ->
    {ok, Player}.

get_mail_title_content(Scene, Produce0) ->
    IsDomian = lib_boss:is_in_domain_boss(Scene),
    IsForbden = lib_boss:is_in_forbdden_boss(Scene),
    IsFairy = lib_boss:is_in_fairy_boss(Scene),
    if
        IsDomian == true ->
            Titles = utext:get(?FAIRYLAND_MAIL_TITLE),
            Contents = utext:get(?FAIRYLAND_MAIL_CONTENT),
            Produce = Produce0#produce{title = Titles, content = Contents};
        IsForbden == true ->
            Titles = utext:get(?FORBIDDEN_MAIL_TITLE),
            Contents = utext:get(?FORBIDDEN_MAIL_CONTENT),
            Produce = Produce0#produce{title = Titles, content = Contents};
        IsFairy == true ->
            Titles = utext:get(?FAIRYLAND_MAIL_TITLE),
            Contents = utext:get(?FAIRYLAND_MAIL_CONTENT),
            Produce = Produce0#produce{title = Titles, content = Contents};
        true ->
            Produce = Produce0
    end,
    Produce.

%% 根据副本类型获得boss类型
get_boss_type_by_dun_type(DunType) ->
    if
        DunType =:= ?DUNGEON_TYPE_VIP_PER_BOSS -> ?BOSS_TYPE_VIP_PERSONAL;
        DunType =:= ?DUNGEON_TYPE_PER_BOSS -> ?BOSS_TYPE_PERSONAL;
        true -> 0
    end.

%% boss掉落
boss_add_drop_log(RoleId, Name, Scene, BossType, MonId, SeeRewardL, UpGoodsL, TeamId) ->
    F = fun({_Type, GoodsTypeId, Num, Id}, L) ->
        case lists:keyfind(Id, #goods.id, UpGoodsL) of
            #goods{other = #goods_other{rating = Rating, extra_attr = OExtraAttr}} ->
                ExtraAttr = data_attr:unified_format_extra_attr(OExtraAttr, []);
            _ ->
                Rating = 0, ExtraAttr = []
        end,
        case GoodsTypeId > 0 of
            true -> [{GoodsTypeId, Num, Rating, ExtraAttr}|L];
            false -> L
        end
    end,
    GoodsInfoL = lists:reverse(lists:foldl(F, [], SeeRewardL)),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_kill_log, [BossType, SeeRewardL, MonId, TeamId]),
    mod_boss:boss_add_drop_log(RoleId, Name, Scene, BossType, MonId, GoodsInfoL),
    ok.

%% boss掉落
boss_add_drop_log(RoleId, Name, Scene, MonId, RewardL) ->
    InBoss = lib_boss:is_in_boss(Scene),
    if
        InBoss ->
            BossType = lib_boss:get_boss_type_by_scene(Scene),
            F = fun({_Type, GoodsTypeId, Num}, L) ->
                case GoodsTypeId > 0 of
                    true -> [{GoodsTypeId, Num, 0, []}|L];
                    false -> L
                end
            end,
            GoodsInfoL = lists:reverse(lists:foldl(F, [], RewardL)),
            mod_boss:boss_add_drop_log(RoleId, Name, Scene, BossType, MonId, GoodsInfoL);
        true ->
            skip
    end,
    ok.

get_boss_type_name(BossType) ->
    case data_boss:get_boss_type(BossType) of
        #boss_type{bossname = BossTypeName} -> BossTypeName;
        _ -> <<>>
    end.

get_boss_hurt_limit(SceneId, Mid, _PList) ->
    case lib_boss:is_in_all_boss(SceneId) of
        true ->
            case data_boss:get_boss_cfg(Mid) of
                #boss_cfg{hurt_limit = PerHurtLimit} ->
                    case data_mon:get(Mid) of
                        #mon{hp_lim = HpLim} -> skip;
                        _ -> HpLim = 0
                    end,
                    HurtLimit = erlang:round((PerHurtLimit / 100)*HpLim);
                _ ->
                    HurtLimit = 0
            end;
        _ ->
            HurtLimit = 0
    end,
    HurtLimit.

do_gm_close_act(Mod, SubMod) when Mod == ?MOD_BOSS ->
    if
        SubMod == 0 ->
            SceneList = data_boss:get_all_boss_scene();
        true ->
            SceneList = data_boss:get_boss_type_scene(SubMod)
    end,
    [begin
        TemBossType = lib_boss:get_boss_type_by_scene(SceneId),
        mod_scene_agent:apply_cast(SceneId, 0, lib_boss, clear_scene_palyer, [TemBossType])
    end|| SceneId <- SceneList];
do_gm_close_act(_Mod, _SubMod) -> skip.

%% 秘籍关闭所有boss
gm_close_all_boss(Status) ->
    lib_gm_stop:gm_change_act(?MOD_BOSS, 0, Status).

%% 秘籍关闭世界boss
gm_close_new_outside_boss(Status) ->
    close_boss_helper(?BOSS_TYPE_NEW_OUTSIDE, Status).

%% 秘籍关闭蛮荒boss
gm_close_forbidden_boss(Status) ->
    close_boss_helper(?BOSS_TYPE_FORBIDDEN, Status).

%% 秘籍关闭boss之家
gm_close_abyss_boss(Status) ->
    close_boss_helper(?BOSS_TYPE_ABYSS, Status).

%% 秘籍关闭秘境领域boss
gm_close_domain_boss(Status) ->
    close_boss_helper(?BOSS_TYPE_DOMAIN, Status).

close_boss_helper(BossType, Status) ->
    lib_gm_stop:gm_change_act(?MOD_BOSS, BossType, Status).

%% boss场景进入事件
enter_event(RoleId, Lv,BossType) ->
    case BossType of
        ?BOSS_TYPE_FORBIDDEN ->
            lib_temple_awaken_api:trigger_enter_ml(RoleId),
            lib_contract_challenge_api:enter_mh_scene(RoleId, BossType),
            lib_hi_point_api:hi_point_task_enter_mh(RoleId,Lv,BossType);
        ?BOSS_TYPE_DOMAIN ->
            lib_hi_point_api:hi_point_task_enter_mh(RoleId,Lv,BossType);
        ?BOSS_TYPE_KF_GREAT_DEMON ->
            lib_hi_point_api:hi_point_task_enter_mh(RoleId,Lv,BossType);
        _ ->
            skip
    end,
    CallbackData = #callback_boss_dungeon_enter{boss_type = BossType},
    lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_DUNGEON_ENTER, CallbackData).

%%============================================================================================================
%% 切后台处理逻辑
%%============================================================================================================
%% 取消复活定时器
cancel_timer_revive(Ps) -> Ps.
    % AfKfSanctuary = lib_c_sanctuary_api:cancel_timer_kf_sanctuary(Ps),
    % cancel_timer_boss(AfKfSanctuary).

%%% 玩家挂后台后切回游戏，取消复活定时器
cancel_timer_boss(Ps) ->
    #player_status{scene = SceneId, status_boss = StatusBoss} = Ps,
    InBoss = lib_boss:is_in_boss(SceneId),
    if
        InBoss andalso is_record(StatusBoss, status_boss) ->
            #status_boss{check_revive_ref = Oldref} = StatusBoss,
            util:cancel_timer(Oldref),
            NewStatusBoss = StatusBoss#status_boss{check_revive_ref = undefined};
        true ->
            NewStatusBoss = StatusBoss
    end,
    Ps#player_status{status_boss = NewStatusBoss}.

%% 定时复活
handle_revive_check_in_boss(Ps, Scene) ->
    #player_status{x = X1, y = Y1, id = RoleId, scene = SceneId, battle_attr = BA, status_boss = StatusBoss, copy_id = CopyId} = Ps,
    #battle_attr{hp = Hp} = BA,
    #ets_scene{x = X, y = Y} = data_scene:get(SceneId),
    #status_boss{boss_map = BossMap, check_revive_ref = Oldref} = StatusBoss,
    util:cancel_timer(Oldref),
    BossType = lib_boss:get_boss_type_by_scene(Scene),
    case maps:get(BossType, BossMap, []) of
        TemRoleBoss when is_record(TemRoleBoss, role_boss) ->
            #role_boss{die_time = DieTime, die_times = DieTimes} = TemRoleBoss;
        _ ->
            DieTime = 0, DieTimes = 0
    end,
    NewPs = if
        Hp > 0 -> Ps;       %% 已经复活不处理
        Scene =/= SceneId -> Ps; %% 不在场景不处理
        BossType == ?BOSS_TYPE_NEW_OUTSIDE; BossType == ?BOSS_TYPE_SPECIAL;
        BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
            {RebornTime, MinTimes} = lib_boss_mod:count_die_wait_time(DieTimes, DieTime),
            case data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE, revive_point_gost) of
                TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                _ -> TimeCfg2 = 20
            end,
            NowTime = utime:unixtime(),
            if
                {X1, Y1} == {X, Y} andalso NowTime < RebornTime ->
                    RebornRef = util:send_after([], max((RebornTime - NowTime+3) * 1000, 500), self(), %%下一次复活
                        {'mod', lib_boss_api, handle_revive_check_in_boss, [Scene]}),
                    Ps#player_status{status_boss = StatusBoss#status_boss{check_revive_ref = RebornRef}}; %% 搬运回尸体
                DieTimes > MinTimes andalso DieTime + TimeCfg2 < NowTime andalso NowTime < RebornTime -> %%不是自动复活时间，而是搬运幽灵时间
                    RebornRef = util:send_after([], max((RebornTime - NowTime+3) * 1000, 500), self(), %%下一次复活成尸体
                        {'mod', lib_boss_api, handle_revive_check_in_boss, [Scene]}),
                    {_, Player1} = lib_revive:revive(Ps, ?REVIVE_ASHES),
                    Player1#player_status{status_boss = StatusBoss#status_boss{check_revive_ref = RebornRef}};
                true -> %% 直接复活
                    {_, Player1} = lib_revive:revive(Ps, ?REVIVE_ORIGIN),
                    Player1
            end;
        BossType == ?BOSS_TYPE_FORBIDDEN orelse BossType == ?BOSS_TYPE_PERSONAL orelse BossType == ?BOSS_TYPE_DOMAIN
            orelse BossType == ?BOSS_TYPE_KF_GREAT_DEMON ->
            {_, Player1} = lib_revive:revive(Ps, ?REVIVE_WLDBOSS_POINT),
            Player1;
        BossType == ?BOSS_TYPE_ABYSS ->
            mod_boss:quit(RoleId, ?BOSS_TYPE_ABYSS, CopyId, Scene, X1, Y1),
            lib_scene:change_scene(Ps, 0, 0, 0, 0, 0, true,
                [{group, 0}, {change_scene_hp_lim, 100}, {change_scene_hp_lim, 100},{pk, {?PK_PEACE, true}}]);
        true ->
            Ps
    end,
    {ok, NewPs}.
%%============================================================================================================
%% 切后台处理逻辑
%%============================================================================================================