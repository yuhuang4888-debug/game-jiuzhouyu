%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 18 Dec 2017 by root <root@localhost.localdomain>

-module(lib_drop).
-include("common.hrl").
-include("predefine.hrl").
-include("drop.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("scene.hrl").
-include("figure.hrl").
-include("team.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("attr.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("eudemons_land.hrl").
-include("custom_act.hrl").
-include("def_event.hrl").
-include("guild.hrl").
-include("language.hrl").
-include("battle.hrl").
-include("rec_event.hrl").
-include("boss.hrl").

-compile(export_all).

%% 组装结构
make_record(drop_ratio, [RatioId, Count, IsHit]) ->
    #drop_ratio{ratio_id = RatioId, count = Count, is_hit = IsHit}.

%% ================================= 跨服掉落过程 =================================
cluster_mon_drop(Minfo, MonArgs, Atter, AtterSign, BLWho, FirstAttr) ->
    #scene_object{scene = ObjectScene, mon = Mon} = Minfo,
    #battle_return_atter{
        node = KillerNode, id = KillId, team_id = TeamId, server_id = KillerServerId, world_lv = WorldLv, 
        server_name = ServerName, lv = _KillerLv, camp_id = Camp
        } = Atter,
    #mon_args{hurt_list = Klist} = MonArgs,
    case data_scene:get(ObjectScene) of
        #ets_scene{type = ?SCENE_TYPE_KF_TEMPLE} ->
            % lib_player:apply_cast(KillerNode, KillId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_goods_drop, mon_drop, [Minfo, Klist, FirstAttr]);
            lib_goods_drop:mon_drop(KillerNode, KillId, Minfo, Klist, FirstAttr);
        #ets_scene{type = ?SCENE_TYPE_EUDEMONS_BOSS} -> %% 圣兽领检查是否可掉落后再进行掉落处理
            skip;
        % 幻饰boss不掉落
        #ets_scene{type = ?SCENE_TYPE_DECORATION_BOSS} ->
            skip;
        #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON ->
            AllocList = data_drop:get_rule_list(Mon#scene_mon.mid),
            if
                AtterSign == ?BATTLE_SIGN_DUMMY andalso TeamId > 0 ->
                    [mod_team:cast_to_team(TeamId, {'alloc_drop', MonArgs, ?ALLOC_EQUAL, Klist}) || ?ALLOC_EQUAL <- AllocList];
                AtterSign == ?BATTLE_SIGN_PLAYER ->
                    if
                        TeamId > 0 ->
                            [mod_team:cast_to_team(TeamId, {'alloc_drop', MonArgs, ?ALLOC_EQUAL, Klist}) || ?ALLOC_EQUAL <- AllocList];
                        true ->
                            ok
                    end,
                    cluster_mon_drop_do(Minfo, MonArgs, Atter, BLWho, Klist, FirstAttr, [Alloc|| Alloc <- AllocList, Alloc =/= ?ALLOC_EQUAL]);
                true ->
                    cluster_mon_drop_do(Minfo, MonArgs, Atter, BLWho, Klist, FirstAttr, AllocList)
            end;
        #ets_scene{type = SceneType} when SceneType == ?SCENE_TYPE_DRAGON_LANGUAGE_BOSS ->
            AllocList = data_drop:get_rule_list(Mon#scene_mon.mid),
            TeamClsType = lib_team:get_team_cls_type(TeamId),
            MonAttr = #mon_atter{id = KillId, node = KillerNode, server_id = KillerServerId, world_lv = WorldLv, server_name = ServerName, camp_id = Camp},
            if
                AtterSign == ?BATTLE_SIGN_PLAYER ->
                    if
                        TeamId > 0 andalso TeamClsType == ?NODE_CENTER ->
                            [mod_team:cast_to_team(TeamId, {'alloc_drop', MonArgs, ?ALLOC_EQUAL, Klist}) || ?ALLOC_EQUAL <- AllocList];
                        true ->
                            [#mon_atter{id = BlRoleId, node = BlNode}|_] = ?IF(BLWho == [], [MonAttr], BLWho),
                            % lib_player:apply_cast(BlNode, BlRoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_goods_drop, mon_drop, [Minfo, Klist, FirstAttr])
                            lib_goods_drop:mon_drop(BlNode, BlRoleId, Minfo, Klist, FirstAttr)
                    end;
                true ->
                    skip
            end;
        #ets_scene{type = SceneType} when SceneType == ?SCENE_TYPE_SEACRAFT_DAILY ->
            if
                AtterSign == ?BATTLE_SIGN_PLAYER ->
                    lib_goods_drop:mon_drop(KillerNode, KillId, Minfo, Klist, FirstAttr);
                true ->
                    skip
            end;
        _ ->
            cluster_mon_drop_do(Minfo, MonArgs, Atter, BLWho, Klist, FirstAttr, data_drop:get_rule_list(Mon#scene_mon.mid))
    end.

cluster_mon_drop_do(Minfo, MonArgs, Atter, BLWho, FirstAttr) ->
    #mon_args{mid = MId, hurt_list = Klist} = MonArgs,
    AllocList = data_drop:get_rule_list(MId),
    cluster_mon_drop_do(Minfo, MonArgs, Atter, BLWho, Klist, FirstAttr, AllocList).

cluster_mon_drop_do(Minfo, MonArgs, Atter, BLWho, Klist, FirstAttr, AllocList) ->
    [
        alloc_drop(Minfo, MonArgs, Alloc, Atter#battle_return_atter.id, Atter#battle_return_atter.lv, BLWho, FirstAttr, Klist)
        || Alloc <- AllocList
    ].

%% 判断掉落类型
alloc_drop(Minfo, _MonArgs, ?ALLOC_HURT_EQUAL, _KillId, _KillerLv, _BLWhos, FirstAttr, Klist) ->
    lib_goods_drop:alloc_hurt_equal(Minfo, Klist, FirstAttr);
alloc_drop(_Minfo, MonArgs, Alloc, KillId, KillerLv, BLWhos, _FirstAttr, Klist) ->
    BLLen = length(BLWhos),
    if
        BLLen =< 0 -> %% 没有归属就击杀者为掉落判断
            E = #mon_atter{id = KillId},
            RoleArgs = make_drop_method_args(#mon_atter{id = KillId, att_lv = KillerLv}),
            handle_drop_list(MonArgs, Alloc, RoleArgs, [E], Klist);
        BLLen == 1 ->
            [P|_ ] = BLWhos,
            RoleArgs = make_drop_method_args(P),
            handle_drop_list(MonArgs, Alloc, RoleArgs, BLWhos, Klist);
        true ->
            [P|_ ] = BLWhos,
            RoleArgs = make_drop_method_args(P),
            handle_drop_list(MonArgs, Alloc, RoleArgs, BLWhos, Klist)
    end.

make_drop_method_args(MonAtter) ->
    #mon_atter{
        id = RoleId, att_lv = RoleLv, team_id = TeamId, server_id = ServerId,
        camp_id = CampId, world_lv = WorldLv, mod_level = ModLv, guild_id = GuildId,
        halo_privilege = HaloPrivilege, career = Career
    } = MonAtter,
    #method_role_drop_args{
        role_id = RoleId, role_lv = RoleLv, team_id = TeamId, server_id = ServerId,
        camp_id = CampId, world_lv = WorldLv, mod_level = ModLv, guild_id = GuildId,
        halo_privilege = HaloPrivilege, career = Career
    }.

%% 是否同场景
is_same_scene(ObjectScene, ObjectPoolId, ObjectCopyId, Mb) ->
    #mb{scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId} = Mb,
    Scene==ObjectScene andalso ScenePoolId == ObjectPoolId andalso CopyId == ObjectCopyId.

%% 计算掉落物品
calc_drop_goods(DropRule, Career) when DropRule#ets_drop_rule.bltype == ?DROP_HURT_SINGLE ->
    do_calc_drop_goods(DropRule, Career);
calc_drop_goods(DropRule, _Career) ->
    do_calc_drop_goods(DropRule, 0).

do_calc_drop_goods(DropRule, Career) ->
    [StableGoods, TaskGoods, RandGoods, GiftGoods] = lib_goods_drop:get_drop_goods_list(DropRule#ets_drop_rule.drop_list, Career),
    DropNumList = lib_goods_drop:get_drop_num_list(DropRule),
    % 随机和礼包一起计算
    DropGoods = lib_goods_drop:drop_goods_list(RandGoods++GiftGoods, DropNumList),
    % GfitDropGoods = lib_goods_drop:drop_goods_list(GiftGoods, DropNumList),
    % {StableGoods ++ DropGoods ++ GfitDropGoods, TaskGoods}.
    {StableGoods ++ DropGoods, TaskGoods}.

%% 计算活动额外掉落
calc_cluster_act_drop_goods(MonArgs)->
    ActIds = [?CUSTOM_ACT_TYPE_CLS_FES_DROP],
    case lib_custom_act_api:get_custom_act_open_info_by_actids(ActIds) of
        [] -> {[], []};
        OpenActInfos -> %% 开启所有掉落活动
            NowTime = utime:unixtime(),
            % #mon_args{boss = MonType, lv = MonLv} = MonArgs,
            lib_goods_drop:calc_all_act_mon_drop(OpenActInfos, NowTime, MonArgs, [], [])
    end.

% 根据伤害人数计算额外掉落
calc_additional_drop_rule(MonId, PList, DropRule) when is_list(PList) ->
    HurtNum = length([1||#mon_atter{assist_id=AssistId}<-PList, AssistId == 0]),
    calc_additional_drop_rule(MonId, HurtNum, DropRule);
calc_additional_drop_rule(MonId, HurtNum, DropRule) ->
    case data_drop_ratio:get_additional_drop_ratio(MonId, HurtNum) of
        Ratio when is_integer(Ratio) ->
            RatioCount = Ratio div ?RATIO_COEFFICIENT,
            CountAddRatio = Ratio rem ?RATIO_COEFFICIENT,
            #ets_drop_rule{drop_rule = DropRuleL} = DropRule,
            F2 = fun({DropId, Num}) ->
                ?IF(urand:rand(0, ?RATIO_COEFFICIENT) =< CountAddRatio, {DropId, RatioCount * Num + 1}, {DropId, RatioCount * Num})
            end,
            F = fun({L, R}) -> {lists:map(F2, L), R} end,
            NDropRuleL = lists:map(F, DropRuleL),
            DropRule#ets_drop_rule{drop_rule = NDropRuleL};
        _ ->
            DropRule
    end.

%% ================================= 跨服处理掉落物品列表 =================================
%% 处理掉落物品列表
handle_drop_list(MonArgs, Alloc, RoleArgs, PList, Klist) ->
    #mon_args{mid = Mid, lv = MonLv} = MonArgs,
    % DropLv = data_drop_m:get_drop_lv(Scene, MonLv, WorldLv),
    #method_role_drop_args{world_lv = WorldLv, role_lv = RoleLv, mod_level = ModLevel, career = Career} = RoleArgs,
    DropLv = data_drop_m:get_drop_lv(Mid, MonLv, WorldLv, RoleLv, ModLevel),
    % ?MYLOG("hjhdrop", "MonLv:~p WorldLv:~p DropLv:~p ~n", [MonLv, WorldLv, DropLv]),
    DropRule = data_drop:get_rule(Mid, Alloc, DropLv),
    NewDropRule = calc_additional_drop_rule(Mid, Klist, DropRule),
    {DropList, _TaskGoods} = calc_drop_goods(NewDropRule, Career),
    {ActDropList, _ActTaskGoods} = calc_cluster_act_drop_goods(MonArgs),
    handle_drop_list(MonArgs, NewDropRule, DropList++ActDropList, RoleArgs, PList, Klist).

%% 处理掉落物品列表算
handle_drop_list(MonArgs, DropRule, DropList, RoleArgs, PList, Klist) ->
    #mon_args{mid = Mid, scene = Scene, lv = MonLv} = MonArgs,
    #method_role_drop_args{world_lv = WorldLv, role_lv = RoleLv, mod_level = ModLevel, server_id = ServerId, role_id = RoleId} = RoleArgs,
    DropLv = data_drop_m:get_drop_lv(Mid, MonLv, WorldLv, RoleLv, ModLevel),
    IsOverLv = lib_goods_drop:check_all_hurtlist_lv(Scene, Mid, DropLv, PList),
    DropLen = length(DropList),
    if
        DropLen == 0 -> skip;
        PList =/= [] andalso IsOverLv == true -> skip;
        true ->
            ExpireTime = utime:unixtime() + ?DROP_ALIVE_TIME,
            %% 拿到限制的当前物品掉落的个人和全服限制数量
            {PersonLimits, SerLimits, DropedCoin, DefCoinLimitCount} = get_drop_goods_limit(ServerId, DropList),
            Args = {PersonLimits, SerLimits, DropedCoin, DefCoinLimitCount},
            %% {掉落金币数量, 玩家单个物品数量列表,全服掉落数量列表}
            {CoinNum, PersonL, SererL, CanDrops, DropedCoin} = do_handle_drop_goods_limit(DropList, Args),
            case CanDrops of
                [] -> skip;
                _ ->
                    #mon_args{scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId, x = Mx, y = My} = MonArgs,
                    Xys = lib_goods_drop:calc_goods_drop_xy(Scene, ScenePoolId, CopyId, Mx, My, length(CanDrops)),
                    %% 生成掉落包数据
                    DropArgs = [MonArgs, DropRule, ExpireTime, [], Xys, RoleArgs, PList, Klist, [], []],
                    [_, _, _, DropBin, _, _, _, _, DropBagList, DropWayBagList] = lists:foldl(fun handle_drop_item/2, DropArgs, CanDrops),
%%                    {DropBin, DropBagList} = handle_drop_item(CanDrops, MonArgs, DropRule, ExpireTime, [], Xys, RoleArgs, PList, Klist, []),
                    IsInKfSanctuaryScene = lib_sanctuary_cluster_util:is_in_sanctuary_scene(Scene),
                    PList1 =
                        case IsInKfSanctuaryScene of
                            true ->
                                HurtLimit = data_cluster_sanctuary:get_san_value(drop_reward_hurt_limit),
                                [TempMonAtter || #mon_atter{hurt = TempHurt} = TempMonAtter <- PList, TempHurt >= HurtLimit];
                            false ->
                                PList
                        end,
                    TranSportMsg = #drop_transport_msg{
                        alloc           = DropRule#ets_drop_rule.alloc,
                        mon_id          = MonArgs#mon_args.mid,
                        mon_x           = MonArgs#mon_args.x,
                        mon_y           = MonArgs#mon_args.y,
                        hurt_role_list  = [AttId || #mon_atter{id = AttId} <-MonArgs#mon_args.hurt_list],
                        bltype          = DropRule#ets_drop_rule.bltype,
                        belong_list     = [AttId1  || #mon_atter{id = AttId1} <- PList1],
                        drop_bag_list   = DropBagList
                    },
                    case lib_sanctuary:is_sanctuary_scene(Scene) orelse lib_territory_treasure:is_on_territory_treasure(Scene)
                        orelse lib_kf_sanctum:is_in_kf_sanctum(Scene) orelse IsInKfSanctuaryScene of
                        true ->
                            lib_goods_drop:handle_drop_bag_list_to_client(Scene, ScenePoolId, CopyId, TranSportMsg);
                        _ ->
                            skip
                    end,
                    DropWayBagList =/= [] andalso mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
                        [RoleId, ?APPLY_CAST_SAVE, lib_drop, send_drop_reward_way_bag, [DropWayBagList]]),
                    %% 先记录次数再发送掉落包
                    update_daily_drop_count(ServerId, CoinNum, PersonL, SererL, DropedCoin, PersonLimits, SerLimits),
                    send_drop(MonArgs, DropRule, DropBin, [])
            end
    end.

%% 统计掉落key
-define(DropKey(Type), {?MOD_GOODS, ?MOD_GOODS_DROP, Type}).

%% 获取掉落限制:分成全服掉落限制列表
get_drop_goods_limit(ServerId, DropList) ->
    F = fun(Drop, {CoinNum, MyGoods, SerGoods}) ->
        #ets_drop_goods{type = Type, drop_thing_type = DTType, goods_id = GoodsId, num = DNum, goods_list = GoodsList} = Drop,
        if
            Type == ?DROP_TYPE_GIFT_RAND -> get_drop_goods_limit_help(GoodsList, {CoinNum, MyGoods, SerGoods});
            true -> get_drop_goods_limit_help([{DTType, GoodsId, DNum}], {CoinNum, MyGoods, SerGoods})
        end
    end,
    %% 统计所有掉落的金币数量和物品数量
    {_TCoinNum, _TMyGoods, TSerGoods} = lists:foldl(F, {0, [], []}, DropList),
    PersonLimits = [],
    %% 全服掉落限制
    SerLimits = calc_all_server_drop_limit(ServerId, TSerGoods),
    %% {个人玩家已获得数量列表, 全副已经掉落的物品数量, 金币限制数量}
    {PersonLimits, SerLimits, 0, 0}.

get_drop_goods_limit_help([], {CoinNum, MyGoods, SerGoods}) -> {CoinNum, MyGoods, SerGoods};
get_drop_goods_limit_help([{DTType, GoodsId, DNum}|T], {CoinNum, MyGoods, SerGoods}) ->
    NResult = if
        DTType == ?TYPE_GOODS ->
            case data_drop_limit:get_goods_limit(DTType, GoodsId) of
                #base_drop_limit{limit_type = LimitType, limit_day = LimitDay}
                  when LimitType == ?DROP_LIMIT_ID_SERVER ->
                    case lists:keyfind(GoodsId, 1, SerGoods) of
                        {GoodsId, LimitDay, ODNum} ->
                            NewSerGoods = lists:keystore(GoodsId, 1, SerGoods, {GoodsId, LimitDay, DNum+ODNum}),
                            {CoinNum, MyGoods, NewSerGoods};
                        _ ->
                            {CoinNum, MyGoods, [{GoodsId, LimitDay, DNum}|SerGoods]}
                    end;
                _ ->
                    {CoinNum, MyGoods, SerGoods}
            end;
        DTType == ?TYPE_COIN -> {CoinNum+DNum, MyGoods, SerGoods};
        true -> {CoinNum, MyGoods, SerGoods}
    end,
    get_drop_goods_limit_help(T, NResult).

%% 计算跨服全服掉落限制
do_handle_drop_goods_limit(DropList, {PersonLimits, SerLimits, DropedCoin, CoinLimit}) ->
    F = fun(Drop, {CoinNum, PMarkL, SMarkL, CanDropL})->
        #ets_drop_goods{type = Type, drop_thing_type = DTType, goods_id = GoodsId, num = DNum, goods_list = GoodsList} = Drop,
        if
            Type == ?DROP_TYPE_GIFT_RAND -> do_handle_drop_goods_limit_help(GoodsList, Drop, CoinLimit, {CoinNum, PMarkL, SMarkL, CanDropL});
            true -> do_handle_drop_goods_limit_help([{DTType, GoodsId, DNum}], Drop, CoinLimit, {CoinNum, PMarkL, SMarkL, CanDropL})
        end
    end,
    {NewCoin, NewPL, NewSL, Drops} = lists:foldl(F, {DropedCoin, PersonLimits, SerLimits, []}, DropList),
    {NewCoin, NewPL, NewSL, Drops, DropedCoin}.

do_handle_drop_goods_limit_help([], _DropCfg, _CoinLimit, {CoinNum, PMarkL, SMarkL, CanDropL}) -> {CoinNum, PMarkL, SMarkL, CanDropL};
do_handle_drop_goods_limit_help([{DTType, GoodsId, DNum}|T], DropCfg, CoinLimit, {CoinNum, PMarkL, SMarkL, CanDropL}) ->
    Drop = DropCfg#ets_drop_goods{drop_thing_type = DTType, goods_id = GoodsId, num = DNum},
    NResult = if
        DTType == ?TYPE_GOODS ->
            case data_drop_limit:get_goods_limit(DTType, GoodsId) of
                #base_drop_limit{limit_type = LimitType, limit_day = LimitDay, limit_num = LimitNum} when LimitNum > 0  ->
                    case  LimitType of
                        ?DROP_LIMIT_ID_SERVER ->
                            {NewSMarkL, NewCanDropL} = update_drop_limit_count(LimitDay, LimitNum, SMarkL, Drop, CanDropL),
                            {CoinNum, PMarkL, NewSMarkL, NewCanDropL};
                        _ ->
                            {CoinNum, PMarkL, SMarkL, CanDropL}
                    end;
                _ ->
                    {CoinNum, PMarkL, SMarkL, [Drop|CanDropL]}
            end;
        DTType== ?TYPE_COIN ->
            if
                CoinLimit == 0 -> {CoinNum, PMarkL, SMarkL, [Drop|CanDropL]};
                CoinNum >= CoinLimit -> {CoinNum, PMarkL, SMarkL, CanDropL};
                true ->
                    {NCoinNum, NDrop} = ?IF(DNum + CoinNum < CoinLimit, {CoinNum + DNum, Drop},
                                            {CoinLimit, Drop#ets_drop_goods{num = CoinLimit - CoinNum}}),
                    {NCoinNum, PMarkL, SMarkL, [NDrop|CanDropL]}
            end;
        true ->
            {CoinNum, PMarkL, SMarkL, CanDropL}
    end,
    do_handle_drop_goods_limit_help(T, DropCfg, CoinLimit, NResult).

%% 更新全服上限数量
update_drop_limit_count(LimitDay, LimitNum, MarkL, Drop, CanDropL) ->
    #ets_drop_goods{goods_id = GoodsId, num = DNum} = Drop,
    case lists:keyfind(LimitDay, 1, MarkL) of
        false -> {MarkL, CanDropL};
        {_LimitDay, MarkDropedL} ->
            case lists:keyfind(?DropKey(GoodsId), 1, MarkDropedL) of
                false ->
                    NewMarkDropedL = lists:keystore(?DropKey(GoodsId), 1, MarkDropedL, {?DropKey(GoodsId), DNum}),
                    NewMarkL = lists:keystore(LimitDay, 1, MarkL, {LimitDay, NewMarkDropedL}),
                    {NewMarkL, [Drop|CanDropL]};
                {_Key, DropedCount} when DropedCount >= LimitNum -> {MarkL, CanDropL};
                {Key, DropedCount} ->
                    if
                        DropedCount+DNum >= LimitNum ->
                            NewMarkDropedL = lists:keystore(Key, 1, MarkDropedL, {Key, LimitNum}),
                            NewMarkL = lists:keystore(LimitDay, 1, MarkL, {LimitDay, NewMarkDropedL}),
                            NNUM = LimitNum - DropedCount,
                            {NewMarkL, [Drop#ets_drop_goods{num = NNUM}|CanDropL]};
                        true ->
                            NewMarkDropedL = lists:keystore(Key, 1, MarkDropedL, {Key, DropedCount+DNum}),
                            NewMarkL = lists:keystore(LimitDay, 1, MarkL, {LimitDay, NewMarkDropedL}),
                            {NewMarkL, [Drop|CanDropL]}
                    end
            end
    end.

%% 更新全服记录
update_daily_drop_count(ServerId, _CoinNum, _PersonL, ServerL, _DropedCoin, _PersonLimits, SerLimits) ->
    %% 全服
    FS = fun({LimitDay, SL}) ->
        NewSL = compare_bf_limits(LimitDay, SL, SerLimits),
        mod_drop_statistics:set_count({?DROP_LIMIT_ID_SERVER, ServerId, NewSL})
    end,
    [FS(X) || X <- ServerL].

%% 跨服打包掉落物品
%% PList 归属者的列表
%% Klist 所有玩家伤害的列表
handle_drop_item(DropGoods, [MonArgs, DropRule, ExpireTime, DropBin, Xys, RoleArgs, PList, Klist, DropBagList, DropWayBagList]) ->
    #ets_drop_goods{
        drop_thing_type = DTType, goods_id = GoodsTypeId, bind = Bind, drop_icon = DropIcon,
        num = GoodsNum, get_way = GetWay, notice = Notice, drop_leff = DropEff, drop_way = DefaultDropWay, show_tips = ShowTips} = DropGoods,
    #ets_drop_rule{alloc = Alloc, bltype = BLType, broad = Broad} = DropRule,
    #mon_args{
        mid = MonId, name = MonName, scene = Scene,
        scene_pool_id = ScenePoolId, copy_id = CopyId, x = Mx, y = My} = MonArgs,
    DropWay = lib_hero_halo:change_drop_way(RoleArgs, MonArgs, Alloc, BLType, DefaultDropWay),
    #method_role_drop_args{team_id = TeamId, role_id = RoleId, camp_id = Camp, server_id = RoleServerId, guild_id = GuildId} = RoleArgs,
    {DX, DY, LessXys} = ?IF(Xys == [], {Mx, My, []}, begin [{Dx, Dy}|LXys] = Xys, {Dx, Dy, LXys} end),
    PickTime = data_drop_m:get_pick_time(Scene, DTType, GoodsTypeId),
    GoodsDrop0 = #ets_drop{
        scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId,
        x = DX, y = DY, bltype = BLType, drop_thing_type = DTType, alloc = Alloc,
        goods_id = GoodsTypeId, num = GoodsNum, bind = Bind, drop_icon = DropIcon,
        get_way = GetWay, notice = Notice, broad = Broad, expire_time = ExpireTime,
        mon_id = MonId, mon_name = MonName, hurt_list = PList, drop_leff = DropEff, drop_way = DropWay,
        pick_time = PickTime, drop_x = DX, drop_y = DY, any_hurt_list = Klist,
        any_hurt_sum = sum_mon_attr_hurt(Klist), show_tips = ShowTips
    },
    if
        DropWay == ?DROP_WAY_BAG ->
            % if
            %     DTType == ?TYPE_COIN -> RW = [{?TYPE_COIN, 0, GoodsNum}];
            %     true -> RW = [{?TYPE_BIND_GOODS*Bind, GoodsTypeId, GoodsNum}]
            % end,
            % Produce = #produce{type = mon_drop, reward = RW, remark = "", show_tips = ShowTips},
            % mod_clusters_center:apply_cast(RoleServerId, lib_goods_api, send_reward_by_id, [Produce, RoleId]),
            % SeeRewardList = lib_goods_api:make_see_reward_list(RW, []),
            % Args = [RoleId, ?EVENT_DROP_CHOOSE, #{id => 0, see_reward => SeeRewardList, drop_way => ?DROP_WAY_BAG, goods => RW, up_goods_list => [], mon_id => MonId}],
            % mod_clusters_center:apply_cast(RoleServerId, lib_player_event, async_dispatch, Args),
            % mod_clusters_center:apply_cast(RoleServerId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_SAVE, lib_drop, send_drop_reward_way_bag, [GoodsDrop0]]),
            [MonArgs, DropRule, ExpireTime, DropBin, Xys, RoleArgs, PList, Klist, DropBagList, [GoodsDrop0|DropWayBagList]];
        true ->
            DropId  = mod_drop:get_drop_id(),
            GoodsDrop = GoodsDrop0#ets_drop{id = DropId},
            if
            %% 无归属物品直接掉落地上
                Alloc == ?ALLOC_BLONG andalso BLType == ?DROP_NO_ONE ->
                    PlayerId = 0, ServerId = 0, NewGoodsDrop = GoodsDrop;
            %% 队伍均等掉落，但是玩家有无队伍，掉落直接归属玩家
                Alloc == ?ALLOC_EQUAL ->
                    PlayerId = RoleId, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{player_id = RoleId, team_id = TeamId};
            %% 分配方式：伤害均等(只有对应的玩家能看到),都是玩家自身触发的
                Alloc == ?ALLOC_HURT_EQUAL ->
                    PlayerId = RoleId, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{player_id = RoleId};
                BLType == ?DROP_SERVER ->
                    PlayerId = 0, ServerId = RoleServerId, NewGoodsDrop = GoodsDrop#ets_drop{server_id = RoleServerId};
                BLType == ?DROP_GUILD ->
                    PlayerId = 0, ServerId = RoleServerId, NewGoodsDrop = GoodsDrop#ets_drop{guild_id = GuildId};
                BLType == ?DROP_CAMP ->
                    PlayerId = 0, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{camp_id = Camp};
                BLType == ?DROP_HURT_SINGLE ->
                    PlayerId = RoleId, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{player_id = RoleId};
            %% 队伍在线状态：第一击|最后一击|伤害最高
                TeamId > 0 ->
                    PlayerId = 0, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{team_id = TeamId};
            %% 个人玩家：第一击|最后一击|伤害最高
                true ->
                    PlayerId = RoleId, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{player_id = RoleId}
            end,
            #ets_drop{team_id = DropTeamId, camp_id = DropCamp, guild_id = DropGuildId} = NewGoodsDrop,
            Bin = lib_goods_drop:make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, PlayerId, ServerId, DropTeamId, DropCamp, DropGuildId, DX, DY,
                DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
            mod_drop:add_drop(NewGoodsDrop),
            BagMsg = #drop_bag_transport_msg{drop_id = DropId, x = DX, y = DY},
            [MonArgs, DropRule, ExpireTime, [Bin|DropBin], LessXys, RoleArgs, PList, Klist, [BagMsg | DropBagList], DropWayBagList]
    end.

handle_drop_item([], _MonArgs, _DropRule, _ExpireTime, DropBin, _Xys, _RoleArgs, _PList, _Klist, DropBagList) -> {DropBin, DropBagList};
handle_drop_item([DropGoods|T], MonArgs, DropRule, ExpireTime, DropBin, Xys, RoleArgs, PList, Klist, DropBagList) ->
    #ets_drop_goods{
        drop_thing_type = DTType, goods_id = GoodsTypeId, bind = Bind, drop_icon = DropIcon,
        num = GoodsNum, get_way = GetWay, notice = Notice, drop_leff = DropEff, drop_way = DropWay, show_tips = ShowTips} = DropGoods,
    #ets_drop_rule{alloc = Alloc, bltype = BLType, broad = Broad} = DropRule,
    #mon_args{
        mid = MonId, name = MonName, scene = Scene,
        scene_pool_id = ScenePoolId, copy_id = CopyId, x = Mx, y = My} = MonArgs,
    DropId  = mod_drop:get_drop_id(),
    {DX, DY, LessXys} = ?IF(Xys == [], {Mx, My, []}, begin [{Dx, Dy}|LXys] = Xys, {Dx, Dy, LXys} end),
    PickTime = data_drop_m:get_pick_time(Scene, DTType, GoodsTypeId),
    GoodsDrop = #ets_drop{
        id = DropId, scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId,
        x = DX, y = DY, bltype = BLType, drop_thing_type = DTType, alloc = Alloc,
        goods_id = GoodsTypeId, num = GoodsNum, bind = Bind, drop_icon = DropIcon,
        get_way = GetWay, notice = Notice, broad = Broad, expire_time = ExpireTime,
        mon_id = MonId, mon_name = MonName, hurt_list = PList, drop_leff = DropEff, drop_way = DropWay,
        pick_time = PickTime, drop_x = DX, drop_y = DY, any_hurt_list = Klist, 
        any_hurt_sum = sum_mon_attr_hurt(Klist), show_tips = ShowTips
        },
    #method_role_drop_args{team_id = TeamId, role_id = RoleId, camp_id = Camp, server_id = RoleServerId, guild_id = GuildId} = RoleArgs,
    if
        %% 无归属物品直接掉落地上
        Alloc == ?ALLOC_BLONG andalso BLType == ?DROP_NO_ONE -> 
            PlayerId = 0, ServerId = 0, NewGoodsDrop = GoodsDrop;
        %% 队伍均等掉落，但是玩家有无队伍，掉落直接归属玩家
        Alloc == ?ALLOC_EQUAL ->
            PlayerId = RoleId, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{player_id = RoleId, team_id = TeamId};
        %% 分配方式：伤害均等(只有对应的玩家能看到),都是玩家自身触发的
        Alloc == ?ALLOC_HURT_EQUAL ->
            PlayerId = RoleId, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{player_id = RoleId};
        BLType == ?DROP_SERVER ->
            PlayerId = 0, ServerId = RoleServerId, NewGoodsDrop = GoodsDrop#ets_drop{server_id = RoleServerId};
        BLType == ?DROP_GUILD ->
            PlayerId = 0, ServerId = RoleServerId, NewGoodsDrop = GoodsDrop#ets_drop{guild_id = GuildId};
        BLType == ?DROP_CAMP ->
            PlayerId = 0, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{camp_id = Camp};
        BLType == ?DROP_HURT_SINGLE ->
            PlayerId = RoleId, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{player_id = RoleId};
        %% 队伍在线状态：第一击|最后一击|伤害最高
        TeamId > 0 -> 
            PlayerId = 0, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{team_id = TeamId};
        %% 个人玩家：第一击|最后一击|伤害最高
        true -> 
            PlayerId = RoleId, ServerId = 0, NewGoodsDrop = GoodsDrop#ets_drop{player_id = RoleId}
    end,
    #ets_drop{team_id = DropTeamId, camp_id = DropCamp, guild_id = DropGuildId} = NewGoodsDrop,
    Bin = lib_goods_drop:make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, PlayerId, ServerId, DropTeamId, DropCamp, DropGuildId, DX, DY,
        DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
    mod_drop:add_drop(NewGoodsDrop),
    BagMsg = #drop_bag_transport_msg{drop_id = DropId, x = DX, y = DY},
    handle_drop_item(T, MonArgs, DropRule, ExpireTime, [Bin|DropBin], LessXys, RoleArgs, PList, Klist, [BagMsg | DropBagList]).

%% 广播掉落被拾取
send_drop_choose_notice(Node, RoleId, Name, DropInfo) ->
    {ok, BinData1} = pt_120:write(12021, [RoleId, DropInfo#ets_drop.id, Name]),
    lib_clusters_center:send_to_uid(Node, RoleId, BinData1),
    {ok, BinData2} = pt_120:write(12019, [DropInfo#ets_drop.id]),
    lib_server_send:send_to_scene(DropInfo#ets_drop.scene, DropInfo#ets_drop.scene_pool_id, DropInfo#ets_drop.copy_id, BinData2),
    ok.

%% 跨服广播掉落信息
send_drop(MonArgs, _DropRule, DropBin, _DropIdList) ->
    #mon_args{mid = MonId, scene = MScene, scene_pool_id = MSPId, copy_id = MCopyId,  x = X, y = Y, boss = MBoss} = MonArgs,
    {ok, BinData} = pt_120:write(12017, [MonId, ?DROP_ALIVE_TIME, MScene, DropBin, X, Y, MBoss]),
    lib_server_send:send_to_scene(MScene, MSPId, MCopyId, BinData).

%% 获取全服掉落限制，已经掉落的次数
calc_all_server_drop_limit(ServerId, TSerGoods)->
    Fun = fun({GoodsId, LimitDay, _Num}, Temp)->
        case lists:keyfind(LimitDay, 1, Temp) of
            false ->
                [{LimitDay, [{?MOD_GOODS, ?MOD_GOODS_DROP, GoodsId}]} | Temp];
            {_, GList} ->
                NewGList = [{?MOD_GOODS, ?MOD_GOODS_DROP, GoodsId}|GList],
                lists:keyreplace(LimitDay, 1, Temp, {LimitDay, NewGList})
        end
    end,
    Goods = lists:foldl(Fun, [], TSerGoods),
    %% 全局计算器获取全局掉落信息
    [{LimitDay, mod_drop_statistics:get_count({?DROP_LIMIT_ID_SERVER, ServerId, LimitDay, GoodsL})} || {LimitDay, GoodsL} <- Goods].

%% 过滤出不相同的次数
compare_bf_limits(LimitDay, L, Limits)->
    case lists:keyfind(LimitDay, 1, Limits) of
        false -> L;
        {_, OL} ->
            Fun = fun({Id, Count}=E, TL) ->
                case lists:keyfind(Id, 1, OL) of
                    {_, Count} -> TL;
                    _ -> [E|TL]
                end
            end,
            lists:foldl(Fun, [], L)
    end.

%% ================================= pickup drop =================================

%% 转成玩家的掉落参数
trans_to_ps_args(Ps, GameNodeType)->
    #player_status{
        id = RoleId, figure = Figure, scene = Scene, server_id = ServerId,
        scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y,
        boss_tired = BossTired, temple_boss_tired = TempleBossTired,
        battle_attr = BA, team = Team, eudemons_boss = EudemonsBoss,
        guild = #status_guild{id = GuildId}
        } = Ps,
    #figure{name = Name, lv = Lv, vip = Vip, vip_type = VipType} = Figure,
    CellNums = lib_goods_util:get_null_cell_num_list(Ps),
    SceneBossTired =
    case GameNodeType == ?NODE_GAME of
        true ->
            InWordBoss = lib_boss:is_in_world_boss(Scene),
            InTempBoss = lib_boss:is_in_temple_boss(Scene),
            % IsOutSideBoss = lib_boss:is_in_new_outside_boss(Scene),
            if
                InWordBoss -> #scene_boss_tired{boss_type = ?BOSS_TYPE_WORLD, tired = BossTired};
                InTempBoss -> #scene_boss_tired{boss_type = ?BOSS_TYPE_TEMPLE, tired = TempleBossTired};
                true ->  #scene_boss_tired{}
            end;
        _ ->
            #scene_boss_tired{boss_type = ?BOSS_TYPE_PHANTOM, tired = EudemonsBoss#eudemons_boss.eudemons_boss_tired}
    end,
    CampId = case lib_seacraft_daily:is_scene(Ps#player_status.scene) of
        true -> lib_seacraft_extra_api:get_camp_id(Ps);
        _ -> Ps#player_status.camp_id
    end,
    #ps_args{
        role_id = RoleId, name = Name, lv = Lv, cell_num = CellNums,
        scene = Scene, pool_id = PoolId, copy_id = CopyId, x = X, y = Y,
        hp = BA#battle_attr.hp, team_id = Team#status_team.team_id,
        vip = Vip, vip_type = VipType, scene_boss_tired = SceneBossTired,
        server_id = ServerId, camp_id = CampId, guild_id = GuildId}.

%% ================================= new drop =================================

%% 发送掉落给玩家
send_drop_reward(RoleId, DropArgs, DropReward, ProduceType) ->
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true -> gen_server:cast(Pid, {'send_drop_reward', DropArgs, DropReward, ProduceType});
        false -> ?ERR("role_pid no alive:~p~n", [[RoleId, DropReward, ProduceType, DropArgs]]),
                 skip
    end.

%% 玩家进程发送
send_drop_reward_helper(Ps, DropArgs, DropReward, ProduceType)->
    [DropId, Scene, MonId, Notice, GoodsId, ShowTips] = DropArgs,
    Produce0 = #produce{type = ProduceType, subtype = 0, remark = ""},
    IsFairyBoss = lib_boss:is_in_fairy_boss(Scene),
    IsForbdenBoss = lib_boss:is_in_forbdden_boss(Scene),
    if
        IsFairyBoss == true orelse IsForbdenBoss == true ->
            Produce = lib_boss_api:get_mail_title_content(Scene, Produce0),
            {NewPS, _SumReward, _SumUpGoodsL, USendReward} = do_send_drop_list_reward([{DropId, Scene, MonId, Notice, GoodsId, DropReward, ShowTips}], Ps, [], [], [], Produce),
            MailPS = lib_goods_api:send_reward(NewPS, Produce#produce{reward = USendReward});
        true ->
            {NewPS, _SumReward, _SumUpGoodsL, USendReward} = do_send_drop_list_reward([{DropId, Scene, MonId, Notice, GoodsId, DropReward, ShowTips}], Ps, [], [], [], Produce0),
            {ok, MailPS} = lib_goods_api:send_reward_with_mail(NewPS, Produce0#produce{reward = USendReward})
    end,
    MailPS.


%% 玩家掉落自动进背包（不走拾取）
send_drop_reward_way_bag(PS, GoodsDropList) ->
    #player_status{id = RoleId} = PS,
    F = fun(GoodsDrop, AccReward) ->
        #ets_drop{
            scene = Scene, drop_thing_type = DTType,
            goods_id = GoodsId, num = GoodsNum, bind = Bind,
            notice = Notice, mon_id = MonId, show_tips = ShowTips
        } = GoodsDrop,
        if
            DTType == ?TYPE_COIN -> DropReward = [{?TYPE_COIN, 0, GoodsNum}];
            true -> DropReward = [{?TYPE_BIND_GOODS*Bind, GoodsId, GoodsNum}]
        end,
        SeeRewardList = lib_goods_api:make_see_reward_list(DropReward, []),
        do_send_drop_list_reward_help_tv(PS, [], 0, Scene, MonId, Notice, GoodsId, DropReward),
        lib_goods_api:send_tv_tip(RoleId, ShowTips, DropReward),
        lib_player_event:async_dispatch(RoleId, ?EVENT_DROP_CHOOSE, #{id => 0, see_reward => SeeRewardList,
            drop_way => ?DROP_WAY_BAG, goods => DropReward, up_goods_list => [], mon_id => MonId,
            notice => Notice, goods_id => GoodsId
        }),
        DropReward ++ AccReward
    end,
    DropRewards = lists:foldl(F, [], GoodsDropList),
    Produce = #produce{type = mon_drop, reward = DropRewards, remark = ""},
    NewPS = lib_goods_api:send_reward(PS, Produce),
    NewPS.

%% 获取汇总的掉落包 : 用于结算等操作
send_drop_list_reward(RoleId, MonArgs, Alloc, DropArgsL, ProduceType) when is_integer(RoleId) ->
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true -> 
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, send_drop_list_reward, [MonArgs, Alloc, DropArgsL, ProduceType]);
        false -> 
            ?ERR("role_pid no alive:~p~n", [[RoleId, MonArgs, Alloc, DropArgsL, ProduceType]]),
            skip
    end;
send_drop_list_reward(#player_status{scene = Scene} = Ps, MonArgs, Alloc, DropArgsL, ProduceType) ->
    Produce0 = #produce{type = ProduceType, subtype = 0, remark = ""},
    IsFairyBoss = lib_boss:is_in_fairy_boss(Scene),
    IsForbdenBoss = lib_boss:is_in_forbdden_boss(Scene),
    if
        IsFairyBoss == true orelse IsForbdenBoss == true ->
            Produce = lib_boss_api:get_mail_title_content(Scene, Produce0),
            {NewPS, SumReward, SumUpGoodsL, USendReward} = do_send_drop_list_reward(DropArgsL, Ps, [], [], [], Produce),
            MailPS = lib_goods_api:send_reward(NewPS, Produce#produce{reward = USendReward, show_tips = ?SHOW_TIPS_3});
        true ->
            {NewPS, SumReward, SumUpGoodsL, USendReward} = do_send_drop_list_reward(DropArgsL, Ps, [], [], [], Produce0),
            {ok, MailPS} = lib_goods_api:send_reward_with_mail(NewPS, Produce0#produce{reward = USendReward, show_tips = ?SHOW_TIPS_0})
    end,
    Data = #callback_goods_drop{mon_args = MonArgs, alloc = Alloc, goods_list = SumReward, up_goods_list = SumUpGoodsL},
    {ok, LastPS} = lib_player_event:dispatch(MailPS, ?EVENT_GOODS_DROP, Data),
    {ok, LastPS}.

%% 客户端背包刷新频繁,优化成统一发送奖励
%% @param List [{DropId, Scene, MonId, Notice, GoodsId, DropReward}]
do_send_drop_list_reward([], Ps, SumReward, SumUpGoodsL, USendReward, _Produce) -> 
    {Ps, SumReward, SumUpGoodsL, USendReward};
do_send_drop_list_reward(List, Ps, _SumReward, _SumUpGoodsL, _USendReward, Produce0) ->
    F = fun({_DropId, _Scene, _MonId, _Notice, _GoodsId, DropReward, _ShowTips}, TmpList) -> DropReward ++ TmpList end,
    GoodsList = lists:foldl(F, [], List),
    UniqueGoodsList = lib_goods_api:make_reward_unique(GoodsList),
    CanGive = lib_goods_api:can_give_goods(Ps, UniqueGoodsList),
    % ?PRINT("UniqueGoodsList:~p CanGive:~p ~n", [UniqueGoodsList, CanGive]),
    % 提示
    ShowTipsF = fun({_DropId, _Scene, _MonId, _Notice, _GoodsId, DropReward, ShowTips}, TmpMap) -> 
        TmpList = maps:get(ShowTips, TmpMap, []),
        maps:put(ShowTips, DropReward ++ TmpList, TmpMap)
    end,
    GoodsMap = lists:foldl(ShowTipsF, #{}, List),
    if
        CanGive =/= true ->
            % 根据提示发送奖励
            ShowTipsF2 = fun(ShowTips, TmpGoodsList, Acc) ->
                TmpUniqueGoodsList = lib_goods_api:make_reward_unique(TmpGoodsList),
                lib_goods_api:send_tv_tip(Ps#player_status.id, ShowTips, TmpUniqueGoodsList),
                Acc
            end,
            maps:fold(ShowTipsF2, ok, GoodsMap),
            F2 = fun({DropId, _Scene, MonId, _Notice, _GoodsId, DropReward, _ShowTips}, TmpPS) ->
                SeeRewardList = lib_goods_api:make_see_reward_list(DropReward, []), 
                {ok, NewTmpPS} = lib_player_event:dispatch(TmpPS, ?EVENT_DROP_CHOOSE, #{goods => DropReward, id => DropId,
                    see_reward => SeeRewardList, up_goods_list => [], mon_id => MonId}),
                NewTmpPS
            end,
            NewPS = lists:foldl(F2, Ps, List),
            {NewPS, UniqueGoodsList, [], UniqueGoodsList};
        true ->
            % 根据提示分发奖励
            ShowTipsF2 = fun(ShowTips, TmpGoodsList, {TmpPS, TmpSumUpGoodsList}) ->
                TmpUniqueGoodsList = lib_goods_api:make_reward_unique(TmpGoodsList),
                TmpProduce = Produce0#produce{reward = TmpUniqueGoodsList, show_tips = ShowTips},
                {ok, _, NewTmpPS, TmpUpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(TmpPS, TmpProduce),
                {NewTmpPS, TmpUpGoodsList++TmpSumUpGoodsList}
            end,
            {NewPS, UpGoodsList} = maps:fold(ShowTipsF2, {Ps, []}, GoodsMap),
            F2 = fun(H, {TmpPS, TmpUpGoodsList}) -> do_send_drop_list_reward_help(TmpPS, TmpUpGoodsList, H) end,
            {NewPS1, NewUpGoodsList} = lists:foldl(F2, {NewPS, UpGoodsList}, List),
            {NewPS1, UniqueGoodsList, NewUpGoodsList, []}
    end.

do_send_drop_list_reward_help(Ps, UpGoodsList, {DropId, Scene, MonId, Notice, GoodsId, DropReward, _ShowTips}) ->
    ThisGoodsList = format_goods(DropReward, []),
    if
        Notice == [] orelse ThisGoodsList == [] ->
            SeeRewardList = lib_goods_api:make_see_reward_list(DropReward, []), 
            {ok, NewPS} = lib_player_event:dispatch(Ps, ?EVENT_DROP_CHOOSE, #{goods => DropReward, id => DropId,
                see_reward => SeeRewardList, up_goods_list => [], mon_id => MonId}),
            {NewPS, UpGoodsList};
        true ->
            case lists:keyfind(GoodsId, #goods.goods_id, UpGoodsList) of
                % [] -> Rating = 0, ExtraAttr = [], ThisUpGoodsList = [];
                #goods{other = #goods_other{rating = Rating, extra_attr = OExtraAttr}} ->
                    ExtraAttr = data_attr:unified_format_extra_attr(OExtraAttr, []),
                    ThisUpGoodsList = [];
                _ -> 
                    Rating = 0, ExtraAttr = [], ThisUpGoodsList = []
            end,
            NewUpGoodsList = lists:keydelete(GoodsId, #goods.goods_id, UpGoodsList),
            %% 传闻
            do_send_drop_list_reward_help_tv(Ps, ExtraAttr, Rating, Scene, MonId, Notice, GoodsId, DropReward),
            SeeRewardList = lib_goods_api:make_see_reward_list(DropReward, ThisUpGoodsList),
            {ok, NewPS} = lib_player_event:dispatch(Ps, ?EVENT_DROP_CHOOSE,
                #{goods => DropReward, id => DropId, rating => Rating, mon_id => MonId, up_goods_list => ThisUpGoodsList,
                    extra_attr => ExtraAttr, goods_id => GoodsId, notice => Notice, see_reward => SeeRewardList}),
            {NewPS, NewUpGoodsList}
    end.

do_send_drop_list_reward_help_tv(PS, ExtraAttr, Rating, Scene, MonId, Notice, GoodsId, DropReward) ->
    #player_status{id = RoleId, figure = Figure} = PS,
    #figure{name = Name} = Figure,
    InBoss = lib_boss:is_in_boss(Scene),
    InSanctuary = lib_sanctuary:is_sanctuary_scene(Scene),
    InEudemonsBoss = lib_eudemons_land:is_in_eudemons_boss(Scene),
    InTerritory = lib_territory_treasure:is_on_territory_treasure(Scene),
    IsActBoss = mod_act_boss:is_act_boss(MonId),
    %IsInKFsanc = lib_c_sanctuary:is_in_sanctuary_scene(Scene),
    IsInKFsanc = lib_sanctuary_cluster_util:is_in_sanctuary_scene(Scene),
    IsInDomain = lib_boss:is_in_domain_boss(Scene),
    IsInKfDomain = lib_boss:is_in_kf_great_demon_boss(Scene),
    if
        IsInDomain ->
            SceneName = lib_scene:get_scene_name(Scene),
            MonLv = lib_mon:get_lv_by_mon_id(MonId),
            MonName = lib_mon:get_name_by_mon_id(MonId),
            RoleName = lib_player:get_wrap_role_name(PS),
            case lists:keyfind(19, 2, Notice) of
                {ModuleId, Id}  ->
                    lib_chat:send_TV({all}, ModuleId, Id, [RoleName, RoleId, SceneName, MonLv, MonName, GoodsId, Rating, util:term_to_string(ExtraAttr)]);
                _ ->
                    skip
            end,
            case lists:keyfind(20, 2, Notice) of
                {ModuleId1, Id1}  ->
                    lib_chat:send_TV({all}, ModuleId1, Id1, [RoleName, RoleId, SceneName, MonName, GoodsId, Rating, util:term_to_string(ExtraAttr)]);
                _ ->
                    skip
            end;
        InBoss orelse InSanctuary orelse IsInKFsanc orelse InEudemonsBoss ->
            MonName = lib_mon:get_name_by_mon_id(MonId),
            SceneName = lib_scene:get_scene_name(Scene),
            RoleName = ?IF(InSanctuary, Name, lib_player:get_wrap_role_name(PS)),
            % 随机一个传闻
            case urand:list_rand(Notice) of
                {ModuleId, Id} -> lib_chat:send_TV({all}, ModuleId, Id, [RoleName, RoleId, SceneName, MonName, GoodsId, Rating, util:term_to_string(ExtraAttr)]);
                _ -> skip
            end;
    % BossType = lib_boss:get_boss_type_by_scene(Scene),
    % mod_boss:boss_add_drop_log(RoleId, Name, Scene, BossType, MonId, [GoodsId, Rating, ExtraAttr]);
        InTerritory ->
            List = data_territory_treasure:get_value(6),
            case lists:member(GoodsId, List) of
                true ->
                    case urand:list_rand(Notice) of
                        {ModuleId, Id} ->
                            lib_chat:send_TV({all}, ModuleId, Id, [Name, RoleId, GoodsId, Rating, util:term_to_string(ExtraAttr)]);
                        _ -> skip
                    end;
                _ -> skip
            end;
        IsActBoss ->
            MonName = lib_mon:get_name_by_mon_id(MonId),
            SceneName = lib_scene:get_scene_name(Scene),
            Args = [Name, RoleId, SceneName, MonName, GoodsId, Rating, util:term_to_string(ExtraAttr)],
            send_drop_tv(Notice, PS, Args);
        IsInKfDomain ->
            case lists:keyfind(19, 2, Notice) of
                {ModuleId, Id}  ->
                    SceneName = lib_scene:get_scene_name(Scene),
                    MonLv = lib_mon:get_lv_by_mon_id(MonId),
                    MonName = lib_mon:get_name_by_mon_id(MonId),
                    RoleName = lib_player:get_wrap_role_name(PS),
                    TvArgs = [{all}, ModuleId, Id, [RoleName, RoleId, SceneName, MonLv, MonName, GoodsId, Rating, util:term_to_string(ExtraAttr)]],
                    mod_clusters_node:apply_cast(mod_great_demon, send_tv_after_pick_drop, [config:get_server_id(), TvArgs]);
                _ ->
                    skip
            end;
        Notice =/= [] ->
            case data_scene:get(Scene) of
                _ ->
                    MonName = lib_mon:get_name_by_mon_id(MonId),
                    Args = [Name, MonName, util:pack_tv_goods(DropReward)],
                    send_drop_tv(Notice, PS, Args)
            end;
        true ->
            ok
    end.

% 拾取规则
% 1.只有手动拾取才检查血量
% 2.拾取时默认不检查对怪物的伤害
% 3.默认手动拾取都要走拾取时间
% 4.特殊的场景(服务端手撸配置)里，拾取都需要伤害占比。

%% 手动拾取的特殊检查
check_manual_drop_pickup(_DropDict, _DropId, PsArgs) ->
    if
        PsArgs#ps_args.hp =< 0 -> %% 死亡
            {false, ?ERRCODE(err150_drop_no_hp)};
        true ->
            {true, ?SUCCESS}
    end.

%% 自动拾取掉落检查
check_auto_drop_pickup(DropDict, DropId, PsArgs) ->
    check_drop_pickup(DropDict, DropId, PsArgs, ?DROP_PICK_TYPE_AUTO).

%% 掉落拾取检查(通用检查)
check_drop_pickup(DropDict, DropId, PsArgs) ->
    check_drop_pickup(DropDict, DropId, PsArgs, ?DROP_PICK_TYPE_NORMAL).

%% 掉落类型:目的是为了检查掉落是否能拾取,防止自动拾取的情况下刚好切场景导致场景不一致无法获取掉落
check_drop_pickup(DropDict, DropId, PsArgs, DropPickType) ->
    case dict:find(DropId, DropDict) of
        error ->
            % ?PRINT("DropId:~p ExpireTime:~p NowTime:~p ~n", [DropId, err150_no_drop, err150_no_drop]),
            {fail, ?ERRCODE(err150_no_drop)};
        {ok, DropInfo} ->
            NowTime = utime:unixtime(),
            #ets_drop{
                player_id = PlayerId, expire_time = ExpireTime,  mon_id = MonId,
                scene = Scene, copy_id = CopyId, team_id = TeamId, hurt_list = HurtList, guild_id = GuildId,
                bltype = BLType, server_id = ServerId, any_hurt_list = AnyHurtList, any_hurt_sum = AnyHurtSum, camp_id = Camp} = DropInfo,
            #mon{boss = BossType, lv = BossLv} = data_mon:get(MonId),
            {CheckHurtR, HurtErrCode} = check_pick_hurt_ratio(Scene, PsArgs#ps_args.role_id, AnyHurtList, AnyHurtSum),
            if
                ExpireTime < NowTime ->              %% 掉落包过期
                    % ?PRINT("ExpireTime:~p NowTime:~p ~n", [ExpireTime, NowTime]),
                    {fail, ?ERRCODE(err150_drop_timeout)};
                %% 不同场景(不是自动拾取才判断)
                Scene =/= PsArgs#ps_args.scene andalso DropPickType =/= ?DROP_PICK_TYPE_AUTO ->    
                    {fail, ?ERRCODE(err150_notin_drop_scene)};
                %% 不同房间(不是自动拾取才判断)
                CopyId =/= PsArgs#ps_args.copy_id andalso DropPickType =/= ?DROP_PICK_TYPE_AUTO -> 
                    {fail, ?ERRCODE(err150_not_drop_copyid)};
                % PsArgs#ps_args.hp =< 0 andalso not IsNoCheckHp -> %% 死亡
                %     {fail, ?ERRCODE(err150_drop_no_hp)};
                BLType == ?DROP_SERVER andalso ServerId > 0 andalso ServerId =/= PsArgs#ps_args.server_id ->
                    ?PRINT("ServerId:~p PsArgs#ps_args.server_id:~p ~n", [ServerId, PsArgs#ps_args.server_id]),
                    {fail, ?ERRCODE(err150_drop_server_diff)};
                BLType == ?DROP_GUILD andalso GuildId =/= PsArgs#ps_args.guild_id ->
                    ?PRINT("GuildId:~p PsArgs#ps_args.guild_id:~p ~n", [GuildId, PsArgs#ps_args.guild_id]),
                    {fail, ?ERRCODE(err150_drop_guild_diff)};
                BLType == ?DROP_CAMP andalso Camp > 0 andalso Camp =/= PsArgs#ps_args.camp_id ->
                    ?PRINT("ServerId:~p PsArgs#ps_args.server_id:~p ~n", [Camp, PsArgs#ps_args.camp_id]),
                    {fail, ?ERRCODE(err150_drop_camp_diff)};
                % 必须要有伤害
                CheckHurtR == false -> 
                    {fail, HurtErrCode};

                %% 服最高伤害(没有保护时间的,只有跨服场景有效)
                BLType == ?DROP_SERVER andalso ServerId == PsArgs#ps_args.server_id ->
                    case data_scene:get(Scene) of
                        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} ->
                            HurtLimit = data_cluster_sanctuary:get_san_value(drop_reward_hurt_limit),
                            case lists:keyfind(PsArgs#ps_args.role_id, #mon_atter.id, HurtList) of
                                #mon_atter{hurt = Hurt} when Hurt >= HurtLimit -> {ok, DropInfo};
                                _ -> {fail, {?ERRCODE(err150_drop_not_enough_hurt), [HurtLimit]}}
                            end;
                        _ ->
                            {ok, DropInfo}
                    end;

                %% 阵营最高伤害(没有保护时间的,只有跨服场景有效)
                BLType == ?DROP_CAMP andalso Camp == PsArgs#ps_args.camp_id ->
                    case data_scene:get(Scene) of
                        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} ->
                            HurtLimit = data_cluster_sanctuary:get_san_value(drop_reward_hurt_limit),
                            case lists:keyfind(PsArgs#ps_args.role_id, #mon_atter.id, HurtList) of
                                #mon_atter{hurt = Hurt} when Hurt >= HurtLimit -> {ok, DropInfo};
                                _ -> {fail, {?ERRCODE(err150_drop_not_enough_hurt), [HurtLimit]}}
                            end;
                        _ ->
                            {ok, DropInfo}
                    end;

                %% 不是归属者，在保护时间内拾取
                PlayerId > 0 andalso PlayerId =/= PsArgs#ps_args.role_id andalso (ExpireTime - NowTime) > ?DROP_SAVE_TIME ->
                    {fail, ?ERRCODE(err150_no_drop_per)};

                %% 不是同队伍，在保护时间内拾取
                TeamId > 0 andalso TeamId =/= PsArgs#ps_args.team_id andalso (ExpireTime - NowTime > ?DROP_SAVE_TIME) ->
                    %% 玩家退出队伍后，没有队伍，但是在伤害归属列表里面
                    case lists:keyfind(PsArgs#ps_args.role_id, #mon_atter.id, HurtList) of
                        false -> %% 没有伤害,不能拾取
                            {fail, ?ERRCODE(err150_no_drop_per)};
                        _ ->
                            % 只要有伤害就可以拾取
                            {ok, DropInfo}     
                            %% 判断是不是特殊boss掉落
                            % case ?IS_DROP_BOSS(BossType) of
                            %     true ->
                            %         {IsOverLv, ErrCode} = lib_goods_check:check_boss_lv(Scene, MonId, BossLv,  PsArgs#ps_args.lv),
                            %         % IsBossTired = mod_battle:check_boss_tired(Scene, MonId, PsArgs#ps_args.scene_boss_tired, PsArgs#ps_args.vip_type, PsArgs#ps_args.vip),
                            %         if
                            %             IsOverLv -> {fail, ErrCode};
                            %             % IsBossTired -> {fail, ?ERRCODE(err150_no_drop_boss_tired)};
                            %             true -> {ok, DropInfo}   %% 有伤害可以拾取掉落(队伍掉落包不会存在其他非队伍伤害的玩家)
                            %         end;
                            %     false ->
                            %         {ok, DropInfo}
                            % end
                    end;

                true -> %% 其他情况下
                    case ?IS_DROP_BOSS(BossType) of
                        true ->
                            {IsOverLv, ErrCode} = lib_goods_check:check_boss_lv(Scene, MonId, BossLv,  PsArgs#ps_args.lv),
                            % IsBossTired = mod_battle:check_boss_tired(Scene, MonId, PsArgs#ps_args.scene_boss_tired, PsArgs#ps_args.vip_type, PsArgs#ps_args.vip),
                            % HaveHurt = lists:keyfind(PsArgs#ps_args.role_id, #mon_atter.id, HurtList),
                            if
                                % 没有伤害也能拾取(所以在队伍里不能仅仅根据是否有伤害)
                                % 1.掉落是队伍归属的话,同队伍不计算怪物等级
                                % 2.掉落是玩家归属的话,同玩家不计算怪物等级
                                IsOverLv andalso (TeamId > 0 andalso TeamId == PsArgs#ps_args.team_id)==false andalso PlayerId =/= PsArgs#ps_args.role_id -> {fail, ErrCode};
                                % IsBossTired andalso HaveHurt == false -> {fail, ?ERRCODE(err150_no_drop_boss_tired)};
                                ExpireTime - NowTime < ?DROP_SAVE_TIME -> {ok, DropInfo}; %% 不在保护时间内，只要符合条件都能拾取
                                % HaveHurt == false -> {fail, ?ERRCODE(err150_no_hurt_drop)};
                                true -> {ok, DropInfo}
                            end;
                        false -> 
                            {ok, DropInfo}
                    end
            end
    end.

%% 计算是否能能拾取
check_pick_hurt_ratio(SceneId, RoleId, HurtL, HurtSum) ->
    Ratio = data_drop_m:get_pick_hurt_ratio(SceneId),
    % ?MYLOG("hjhdrop", "check_pick_hurt_ratio HurtL:~p HurtSum:~p Ratio:~p ~n", [HurtL, HurtSum, Ratio*100]),
    if
        Ratio == 0 -> {true, ?SUCCESS};
        true ->
            FixHurtSum = max(HurtSum, 1),
            case lists:keyfind(RoleId, #mon_atter.id, HurtL) of
                #mon_atter{hurt = Hurt} when Hurt/FixHurtSum >= Ratio -> {true, ?SUCCESS};
                _ -> {false, {?ERRCODE(err150_hurt_ratio), [util:term_to_string(Ratio*100)]}}
            end
    end.

%% 汇总伤害
sum_mon_attr_hurt(L) ->
    lists:sum([Hurt||#mon_atter{hurt = Hurt}<-L]).

%% 检查掉落物品数据
check_drop_pickup_info(DropInfo, PsArgs) ->
    #ets_drop{drop_thing_type = ThingType, goods_id = GoodsTypeId, bind = Bind, num = DropNum} = DropInfo,
    case ThingType of
        ?TYPE_COIN -> {ok, [{?TYPE_COIN, 0, DropNum}]};
        ?TYPE_GOODS ->
            case data_goods_type:get(GoodsTypeId) of
                #ets_goods_type{max_overlap = _MaxOverLap, bag_location = BagLocation}->
                    #ps_args{cell_num = CellNums} = PsArgs,
                    case lists:member(BagLocation, ?GOODS_LOC_BAG_TYPES) of 
                        false -> {fail, ?ERRCODE(err150_location_err)};
                        _ ->
                            case lists:keyfind(BagLocation, 1, CellNums) of
                                false -> %% 背包没有数量限制
                                    {ok, [{?TYPE_BIND_GOODS*Bind, GoodsTypeId, DropNum}]};
                                {_, _CellNum} ->
                                    %% 掉落目前都不判断数量限制,会直接发到背包中
                                    if
                                        true -> {ok, [{?TYPE_BIND_GOODS*Bind, GoodsTypeId, DropNum}]}
                                    end
                            end
                    end;
                _ -> 
                    ?MYLOG("droperror", "GoodsTypeId:~p DropInfo:~p ~n", [GoodsTypeId, DropInfo]),
                    {fail, ?ERRCODE(err150_no_goods_type)}
            end;
        _ -> {fail, ?FAIL}
    end.

%% 格式物品
format_goods([], Goods) -> Goods;
format_goods([{?TYPE_GOODS, GoodId, Num}|T], Goods)->
    format_goods(T, [{?TYPE_GOODS, GoodId, Num, ?UNBIND}|Goods]);
format_goods([{?TYPE_BIND_GOODS, GoodId, Num}|T], Goods)->
    format_goods(T, [{?TYPE_BIND_GOODS, GoodId, Num, ?BIND}|Goods]);
format_goods([_|T], Goods)-> format_goods(T, Goods).


send_drop_tv([], _Ps, _Args) -> ok;
send_drop_tv([{?MOD_BOSS, _Id}|T], Ps, Args) -> send_drop_tv(T, Ps, Args);
send_drop_tv([{?MOD_EUDEMONS_BOSS, _Id}|T], Ps, Args) -> send_drop_tv(T, Ps, Args);
send_drop_tv([{?MOD_DUNGEON, _Id}|T], Ps, Args) -> send_drop_tv(T, Ps, Args);
send_drop_tv([{ModuleId, Id}|T], Ps, Args) ->
    #player_status{guild = #status_guild{id = GuildId},
                   team  = #status_team{team_id = TeamId}} = Ps,
    case data_language:get(ModuleId, Id) of
        #language{subtype = 10} ->               %% 系统频道
            lib_chat:send_TV({all}, ModuleId, Id, Args);
        #language{subtype = 4} when GuildId>0 -> %% 公会频道
            lib_chat:send_TV({guild, GuildId}, ModuleId, Id, Args);
        #language{subtype = 5} when TeamId>0 ->  %% 队伍频道
            lib_chat:send_TV({team, TeamId}, ModuleId, Id, Args);
        _ -> skip
    end,
    send_drop_tv(T, Ps, Args);
send_drop_tv([_Unkown|T], PlayerStatus, Args) ->
    ?ERR("send_drop_tv error config:~p", [_Unkown]),
    send_drop_tv(T, PlayerStatus, Args).

%% -----------------------------------------------------------------
%% 掉落概率
%% -----------------------------------------------------------------

%% 加载掉落概率列表
load_drop_ratio_map(RoleId) ->
    List = db_drop_ratio_list_select(RoleId),
    F = fun(T, DropRatioMap) ->
       DropRatio = make_record(drop_ratio, T),
       maps:put(DropRatio#drop_ratio.ratio_id, DropRatio, DropRatioMap)
    end,
    lists:foldl(F, #{}, List).
    
%% 获得掉落概率列表
db_drop_ratio_list_select(RoleId) ->
    Sql = io_lib:format(?sql_role_drop_ratio_select, [RoleId]),
    db:get_all(Sql).

db_role_drop_ratio_replace_batch([]) -> ok;
db_role_drop_ratio_replace_batch(List) ->
    {Table, ValL} = ?sql_role_drop_ratio_replace_val,
    Sql = usql:replace(Table, ValL, List),
    db:execute(Sql).

%% 日志
log_role_drop_ratio([]) -> ok;
log_role_drop_ratio([[RoleId, RatioId, Count, IsHit]|T]) ->
    lib_log_api:log_role_drop_ratio(RoleId, RatioId, Count, IsHit),
    log_role_drop_ratio(T).
