%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2012-1-6
%% Description: 物品掉落处理
%% --------------------------------------------------------
-module(lib_goods_drop).
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("drop.hrl").
-include("sql_goods.hrl").
-include("scene.hrl").
-include("vip.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("team.hrl").
-include("def_fun.hrl").
-include("daily.hrl").
-include("def_daily.hrl").
-include("def_module.hrl").
-include("reincarnation.hrl").
-include("attr.hrl").
-include("dungeon.hrl").
-include("custom_act.hrl").
-include("def_event.hrl").
-include("collect.hrl").
-include("buff.hrl").
-include("boss.hrl").
-include("guild.hrl").

-export([
        mon_drop/5,                 %% 怪物掉落
        mon_drop/4,                 %% 怪物掉落(一般不建议跨服直接调用,除非在玩家进程,需要先执行掉落,再执行其他逻辑)
        alloc_hurt_equal/3,         %% 伤害均等掉落
        send_drop/5,                %% 广播掉落信息
        send_drop_choose_notice/2,  %% 广播掉落被拾取
        make_a_goods_drop/2,        %% 直接生成一个可拾取的掉落包
        alloc_drop_in_team/4,       %% 队伍回调掉落分配
        get_task_mon/1,
        get_drop_num_list/1,
        drop_goods_list/2,
        handle_drop_list/6,
        drop_choose/2,
        calc_goods_drop_xy/6,
        calc_hurt_role_info/7
    ]).

-compile(export_all).

%% 掉落(跨服中心执行或者玩家id对应的服执行)
mon_drop(RoleNode, RoleId, SceneObject, PList, FirstAttr) ->
    % 掉落
    lib_player:apply_cast(RoleNode, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_goods_drop, mon_drop_help,
        [SceneObject, PList, FirstAttr, RoleId]),
    alloc_hurt_equal(RoleNode, RoleId, SceneObject, PList, FirstAttr),
    ok.

%% 掉落(一般不建议跨服直接调用,可以使用 lib_goods_drop:mod_drop/5 ,除非在玩家进程,需要先执行掉落,再执行其他逻辑)
%% @return #player_status{}
mon_drop(#player_status{id = MainRoleId} = Player, SceneObject, PList, FirstAttr) ->
    NewPlayer = mon_drop_help(Player, SceneObject, PList, FirstAttr, MainRoleId),
    alloc_hurt_equal(node(), MainRoleId, SceneObject, PList, FirstAttr),
    NewPlayer.

%% 伤害均等
alloc_hurt_equal(SceneObject, PList, FirstAttr) ->
    alloc_hurt_equal(none, 0, SceneObject, PList, FirstAttr).

%% 伤害均等(排除主玩家id)
alloc_hurt_equal(RoleNode, RoleId, SceneObject, PList, FirstAttr) ->
    % 是否有均等掉落
    #scene_object{mon = #scene_mon{mid = Mid}} = SceneObject,
    AllocList = data_drop:get_rule_list(Mid),
    case lists:member(?ALLOC_HURT_EQUAL, AllocList) of
        true ->
            case util:is_cls() of
                true ->
                    [lib_player:apply_cast(TmpNode, TmpRoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_goods_drop, mon_drop_help,
                        [SceneObject, PList, FirstAttr, RoleId]) || #mon_atter{id = TmpRoleId, node = TmpNode} <- PList, TmpRoleId =/= RoleId];
                false ->
                    F = fun(#mon_atter{node = TmpNode}) -> TmpNode == RoleNode orelse TmpNode == node() end,
                    {Satisfying, NotSatisfying} = lists:partition(F, PList),
                    [lib_player:apply_cast(TmpNode, TmpRoleId, ?APPLY_CAST_STATUS,  ?NOT_HAND_OFFLINE, lib_goods_drop, mon_drop_help,
                        [SceneObject, PList, FirstAttr, RoleId]) || #mon_atter{id = TmpRoleId, node = TmpNode} <- Satisfying, TmpRoleId =/= RoleId],
                    case NotSatisfying == [] of
                        true -> skip;
                        false -> mod_clusters_node:apply_cast(lib_goods_drop, alloc_hurt_equal_help, [RoleNode, RoleId, SceneObject, PList, FirstAttr])
                    end
            end;
        false ->
            skip
    end,
    ok.

%% 伤害均等(跨服):
alloc_hurt_equal_help(RoleNode, RoleId, SceneObject, PList, FirstAttr) ->
    % 获取不是跟主玩家id同一个节点的玩家列表
    F = fun(#mon_atter{node = TmpNode}) -> TmpNode == RoleNode end,
    {_Satisfying, NotSatisfying} = lists:partition(F, PList),
    [lib_player:apply_cast(TmpNode, TmpRoleId, ?APPLY_CAST_STATUS, lib_goods_drop, mon_drop_help, [SceneObject, PList, FirstAttr, RoleId])
        || #mon_atter{id = TmpRoleId, node = TmpNode} <- NotSatisfying, TmpRoleId =/= RoleId],
    ok.

%% 在击杀者进程判断掉落的执行
%% 怪物掉落
%% @param PList [#mon_atter{}] 伤害值列表
%% @param FirstAttr #mon_atter{} | [] 首次攻击者
%% @param MainRoleId 主掉落者
%% @return #player_status{}
mon_drop_help(Ps, SceneObject, PList, FirstAttr, MainRoleId) ->
    #player_status{id = RoleId} = Ps,
    #scene_object{
        id = MonAutoId, scene = ObjectScene, scene_pool_id = ObjectPoolId,
        copy_id = ObjectCopyId, x = X, y = Y, d_x = DX, d_y = DY, mon = Mon, figure = Figure} = SceneObject,
    MonArgs = #mon_args{
        id = MonAutoId, mid = Mon#scene_mon.mid, kind = Mon#scene_mon.kind, lv = Figure#figure.lv,
        ctime = Mon#scene_mon.ctime, boss = Mon#scene_mon.boss, mon_sys = Mon#scene_mon.mon_sys, scene = ObjectScene,
        hurt_list = PList,
        scene_pool_id = ObjectPoolId, copy_id = ObjectCopyId, x = X, y = Y, d_x = DX, d_y = DY, name = Figure#figure.name},
    % 特殊场景不走掉落
    IsOutsideBoss = lib_boss:is_in_outside_boss(ObjectScene),
    IsFairyBoss = lib_boss:is_in_fairy_boss(ObjectScene),
    IsDomainBoss = lib_boss:is_in_domain_boss(ObjectScene),
    DecoraBossStop = lib_decoration_boss_api:is_stop_drop(ObjectScene),
    if
        IsOutsideBoss orelse IsFairyBoss orelse IsDomainBoss orelse DecoraBossStop -> skip;
        true -> other_drop(Ps, MonArgs, PList, FirstAttr, Mon, MainRoleId)
    end,
    if
        IsOutsideBoss orelse IsFairyBoss orelse DecoraBossStop -> Ps;
        true ->
            % 任务掉落
            lib_task_drop:task_drop(Ps, MonArgs, PList, FirstAttr, MainRoleId),
            AllocList = data_drop:get_rule_list(Mon#scene_mon.mid),
            F = fun(Alloc, TmpPlayer) -> alloc_drop(TmpPlayer, MonArgs, Alloc, PList, FirstAttr) end,
            case RoleId == MainRoleId of
                true -> NewAllocList = AllocList;
                false -> NewAllocList = [Alloc|| Alloc <- AllocList, Alloc == ?ALLOC_HURT_EQUAL]
            end,
            lists:foldl(F, Ps, NewAllocList)
    end.

%% 判断掉落类型
%% @return #player_status{}
alloc_drop(Ps, MonArgs, Alloc, PList, FirstAttr) ->
    #player_status{id = RoleId, team = Team} = Ps,
    if
        Team#status_team.team_id =/= 0 andalso Alloc == ?ALLOC_EQUAL ->
            mod_team:cast_to_team(Team#status_team.team_id, {'alloc_drop', MonArgs, Alloc, PList}),
            Ps;
        Alloc == ?ALLOC_HURT_EQUAL ->
            #mon_args{scene = Scene, mid = Mid} = MonArgs,
            #mon{lv = BossLv} = data_mon:get(Mid),
            HurtLimit = lib_boss_api:get_boss_hurt_limit(Scene, Mid, PList),
            case lists:keyfind(RoleId, #mon_atter.id, PList) of
                #mon_atter{hurt = Hurt} = EqualAttr when Hurt > HurtLimit ->
                    case check_all_hurtlist_lv(Scene, Mid, BossLv, [EqualAttr]) of
                        true -> Ps;
                        false -> handle_drop_list(Ps, MonArgs, Alloc, 0, PList, PList)
                    end;
                _ ->
                    Ps
            end;
        true ->
            case data_drop:get_rule(MonArgs#mon_args.mid, Alloc, MonArgs#mon_args.lv) of
                [] -> ?ERR("alloc_drop ~p~n", [{MonArgs#mon_args.mid, Alloc, MonArgs#mon_args.lv, data_drop:get_rule(MonArgs#mon_args.mid, Alloc, MonArgs#mon_args.lv)}]);
                _ -> skip
            end,
            #ets_drop_rule{bltype = BLType} = data_drop:get_rule(MonArgs#mon_args.mid, Alloc, MonArgs#mon_args.lv),
            {DropRoleId, MaxTeamDropR, TeamHurts} = calc_hurt_role_info(MonArgs#mon_args.mid, MonArgs#mon_args.scene, BLType, RoleId, Team, PList, FirstAttr),
            case DropRoleId == RoleId of
                true -> handle_drop_list(Ps, MonArgs, Alloc, MaxTeamDropR, TeamHurts, PList);
                false ->
                    case lists:keyfind(DropRoleId, #mon_atter.id, [FirstAttr|PList]) of
                        #mon_atter{node = none} ->
                            lib_player:apply_cast(DropRoleId, ?APPLY_CAST_STATUS, lib_goods_drop, handle_drop_list, [MonArgs, Alloc, MaxTeamDropR, TeamHurts, PList]);
                        #mon_atter{node = DropNode} when DropNode =/= node() ->
                            Args = [DropNode, DropRoleId, ?APPLY_CAST_STATUS, lib_goods_drop, handle_drop_list, [MonArgs, Alloc, MaxTeamDropR, TeamHurts, PList]],
                            mod_clusters_node:apply_cast(lib_player, apply_cast, Args);
                        _ ->
                            lib_player:apply_cast(DropRoleId, ?APPLY_CAST_STATUS, lib_goods_drop, handle_drop_list, [MonArgs, Alloc, MaxTeamDropR, TeamHurts, PList])
                    end,
                    Ps
            end
    end.

%% NOTE:助战没有奖励
alloc_drop_in_team(State, MonArgs, Alloc, PList) ->
    #team{member = MemberList, dungeon = #team_dungeon{dun_id = DunId}} = State,
    #mon_args{
            mid           = Mid,
            lv            = MonLv,
            scene         = ObjectScene,
            scene_pool_id = ObjectPoolId,
            copy_id       = ObjectCopyId
        } = MonArgs,
    DropRule = data_drop:get_rule(Mid, Alloc, MonLv),
    ?IF(Alloc /= ?ALLOC_EQUAL orelse DropRule == [], skip,
        [
        lib_player:apply_cast(Node, Id, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_goods_drop, handle_team_drop_list, [DunId, MonArgs, Alloc, PList])
            || #mb{node = Node, id = Id} = Mb <- MemberList, is_same_scene(ObjectScene, ObjectPoolId, ObjectCopyId, Mb) andalso lib_team:is_fake_mb(Mb) =:= false
        ]
        ).

%% @return #player_status{}
handle_team_drop_list(#player_status{dungeon = #status_dungeon{dun_id = DunId, dun_type = DunType, help_type = HelpType}} = PS, DunId, MonArgs, Alloc, PList) ->
    % 不在副本中就直接掉落
    % 在副本中,助战等于0才能掉落
    % 周常本不管是否助战，都走一篇掉落，周常本那边控制了掉落次数了
    case DunId == 0 orelse HelpType == ?HELP_TYPE_NO orelse
        DunType == ?DUNGEON_TYPE_WEEK_DUNGEON
    of
        true ->
            lib_dungeon:send_count_drop(PS, MonArgs, Alloc),
            #player_status{team = Team} = PS,
            TP = calc_team_member(Team#status_team.team_id, PList),
            NewPs = handle_drop_list(PS, MonArgs, Alloc, 0, TP, PList),
            NewPs;
        _ ->
            PS
    end;

handle_team_drop_list(Ps, _DunId, _MonArgs, _Alloc, _PList) ->
    Ps.

%% 是否同场景
is_same_scene(ObjectScene, ObjectPoolId, ObjectCopyId, Mb) ->
    #mb{scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId} = Mb,
    Scene==ObjectScene andalso ScenePoolId == ObjectPoolId andalso CopyId == ObjectCopyId.

%% 是否在掉落范围
is_near_range(_Ps, _MonArgs, []) -> false;
is_near_range(PlayerStatus, MonArgs, DropRule) ->
    #player_status{scene = PScene, x = PX, y = PY} = PlayerStatus,
    #mon_args{scene = MScene, x = MX, y = MY} = MonArgs,
    if
        PScene =/= MScene -> false;
        true ->
            case DropRule#ets_drop_rule.drop_range of
                {0, 0} -> true;
                {Xpx, Ypx} -> abs(PX - MX) =<Xpx andalso abs(PY - MY) =<Ypx;
                _Unkown ->
                    ?ERR("unkown drop_range:~p~n", [_Unkown]),
                    false
            end
    end.

%% 计算真正掉落的玩家和玩家伤害列表和掉率
%% @param PList [#mon_attr{},...]
%% @return {DropRoleId(掉落者), MaxTeamDropR(队伍掉落加成系数), Hurts(伤害列表)}
calc_hurt_role_info(_MonId, SceneId, BlType, RoleId, _Team, PList, _FAtter) when
        (
            BlType == ?DROP_HURT orelse
            BlType == ?DROP_SERVER orelse
            BlType == ?DROP_CAMP orelse
            BlType == ?DROP_GUILD orelse
            BlType == ?DROP_ANY_HURT
            ) andalso
        PList =/= [] ->
    case calc_max_plist(_MonId, SceneId, BlType, PList) of
        [[E|_] = P, []] -> {E#mon_atter.id, 0, P};
        [[], [E|_] = TP] -> {E#mon_atter.id, 0, TP};
        _R -> {RoleId, 0, []}
    end;
calc_hurt_role_info(_MonId, _SceneId, ?DROP_FIRST_ATT, _RoleId, _Team, PList, FAtter) when FAtter =/= [] ->
    TP = calc_team_member(FAtter#mon_atter.team_id, PList),
    {FAtter#mon_atter.id, 0, TP};
calc_hurt_role_info(_MonId, _SceneId, ?DROP_LAST_ATT, RoleId, Team, PList, _FAtter) ->
    TP = calc_team_member(Team#status_team.team_id, PList),
    {RoleId, 0, TP};
calc_hurt_role_info(_MonId, _SceneId, _Type, RoleId, _Team, _PList, _FirstAttr) ->
    {RoleId, 0, []}.

%% 计算掉落物品
%% @return {StableGoods, TaskGoods, RandGoods, GiftGoods, DropGoods}
calc_drop_goods(Ps, OldDropRule, TeamDropR) ->
    SupVipDropRule = lib_supreme_vip_api:calc_drop_rule_for_drop_rule(Ps, OldDropRule),
    SeaDailyDropRule = lib_seacraft_daily:calc_drop_rule_for_drop_rule(Ps, SupVipDropRule),
    [StableGoods, TaskGoods, RandGoods, GiftGoods] = get_drop_goods_list_with_ps(Ps, SeaDailyDropRule#ets_drop_rule.drop_list),
    DropNumList = get_drop_num_list(SeaDailyDropRule),
    #ets_drop_rule{bltype = BLType} = SeaDailyDropRule,
    % 随机和礼包一起计算
    NewRandGoods = cherish_goods_add_drop_ratio(Ps, BLType, RandGoods ++ GiftGoods, TeamDropR),
    DoRandGoods = drop_goods_list(NewRandGoods, DropNumList),
    % NewGiftGoods = cherish_goods_add_drop_ratio(Ps, BLType, GiftGoods, TeamDropR),
    % DropGiftGoods = drop_goods_list(NewGiftGoods, DropNumList),
    % DropGiftGoods = [],
    {StableGoods, TaskGoods, RandGoods, GiftGoods, DoRandGoods}.

%% 计算活动额外掉落
calc_act_drop_goods(MonArgs)->
    %% 掉落活动可能多个主类
    ActIds = data_drop_mon:get_act_type_list(),
    case lib_custom_act_api:get_custom_act_open_info_by_actids(ActIds) of
        [] -> {[], []};
        OpenActInfos -> %% 开启所有掉落活动
            %% io:format("~p ~p OpenActInfos:~p~n", [?MODULE, ?LINE, OpenActInfos]),
            NowTime = utime:unixtime(),
            % #mon_args{boss = MonType, lv = MonLv} = MonArgs,
            calc_all_act_mon_drop(OpenActInfos, NowTime, MonArgs, [], [])
    end.

calc_all_act_mon_drop([], _NowTime, _MonArgs, TDropGoods, TTaskGoods) ->
    {TDropGoods, TTaskGoods};
calc_all_act_mon_drop(
        [#act_info{key = {ActId, SubId}, stime = STime}|OpenActInfos]
        , NowTime, MonArgs, TDropGoods, TTaskGoods) ->
    {TDropGoods1, TTaskGoods1} = case lib_custom_act_util:get_act_cfg_info(ActId, SubId) of
        [] -> {TDropGoods, TTaskGoods};
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(sp_gap_time, 1, Condition) of
                false -> CandDrop = true;
                {_, Day} -> CandDrop = ?IF(NowTime > STime + Day*?ONE_DAY_SECONDS, false, true)
            end,
            if
                CandDrop ->
                    #mon_args{mon_sys = MonSys, lv = MonLv} = MonArgs,
                    F = fun(TmpMonSys, {TmpDropGoods, TmpTaskGoods}) ->
                        case data_drop_mon:get_mon_drop_rule(ActId, SubId, TmpMonSys, MonLv) of
                            #base_mon_type_drop{drop_list = DropList, drop_rule = DropRule} ->
                                [StableGoods, TaskGoods, RandGoods, GiftGoods] = get_drop_goods_list(DropList),
                                DropNumList = find_ratio(DropRule, 0, urand:rand(1, ?RATIO_COEFFICIENT)),
                                % 随机和礼包一起计算
                                DropGoods = drop_goods_list(RandGoods ++ GiftGoods, DropNumList),
                                % GiftDropGoods = drop_goods_list(GiftGoods, DropNumList),
                                {TmpDropGoods ++ StableGoods ++ DropGoods, TmpTaskGoods ++ TaskGoods};
                            _ ->
                                {TmpDropGoods, TmpTaskGoods}
                        end
                    end,
                    R = lists:foldl(F, {TDropGoods, TTaskGoods}, [MonSys]),
                    R;
                true -> {TDropGoods, TTaskGoods}
            end
    end,
    calc_all_act_mon_drop(OpenActInfos, NowTime, MonArgs, TDropGoods1, TTaskGoods1);
calc_all_act_mon_drop([_|OpenActInfos], NowTime, MonArgs, TDropGoods, TTaskGoods) ->
    calc_all_act_mon_drop(OpenActInfos, NowTime, MonArgs, TDropGoods, TTaskGoods).

%% ================================= 处理掉落物品列表 =================================

%% 说明
%% drop_list 是php根据 #ets_drop_rule.drop_rule中的列表id 等于 ets_drop_goods配置中的#ets_drop_goods.list_id 来获得列表
%% (1)
%% drop_rule : [{[{列表id,数量},...],概率},...]
%% 列表中的概率总和=?RATIO_COEFFICIENT
%% 根据概率随机出一个[{列表id,数量},...]
%% (2)
%% drop_list : [#ets_drop_goods.id,...] 计算出所有的[#ets_drop_goods{},...]
%% 获得[固定奖励([#ets_drop_goods{},...]),任务奖励([#ets_drop_goods{},...]),随机奖励([#ets_drop_goods{},...])]
%% 用 drop_goods_list(RandGoods, DropNumList) 函数来计算出随机掉落物品 [#ets_drop_goods{},..]
%% [
%% @param RandGoods = 随机奖励([#ets_drop_goods{},...]
%% @param  DropNumList = 根据drop_rule算出的[{列表id,数量},...]
%% ]

%% 处理掉落物品列表
%% @param HurtList 归属列表 [#mon_atter{}]
%% @param PList 伤害列表 [#mon_atter{}]
%% @return #player_status{}
handle_drop_list(Ps, MonArgs, Alloc, TeamMaxDropR, HurtList, PList) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Ps,
    #mon_args{scene = Scene, mid = Mid, lv = MonLv} = MonArgs,
    #mon{lv = BossLv} = data_mon:get(Mid),
    % 计算世界等级
    case lists:keyfind(RoleId, #mon_atter.id, HurtList) of
        #mon_atter{world_lv = WorldLv, mod_level = ModLevel} -> ok;
        _ -> WorldLv = util:get_world_lv(), ModLevel = lib_scene:get_mod_level(Ps)
    end,
    DropLv = data_drop_m:get_drop_lv(Mid, MonLv, WorldLv, RoleLv, ModLevel),
    %% 注:mon_args里面的怪物等级是怪物创建时候的实际等级，会随世界等级变化，所以和配置里面的等级是不一样的
    DropRule = data_drop:get_rule(Mid, Alloc, DropLv),
    IsNear = is_near_range(Ps, MonArgs, DropRule),
    IsOverLv = check_all_hurtlist_lv(Scene, Mid, BossLv, HurtList),
    if
        IsNear == false orelse DropRule == [] -> Ps;
        HurtList =/= [] andalso IsOverLv == true -> Ps; %% 玩家自己击杀大于100级的boss不给掉落
        true ->
            #player_status{drop_rule_modifier = Modifier} = Ps,
            %% 公会Boss特殊处理掉落规则(已不用)
            % case mod_guild_boss:is_guild_boss(DunId, Mid) of
            %     true ->
            %         PassTime = utime:unixtime() - Ctime,
            %         Score = lib_dungeon:get_time_score(DunId, PassTime),
            %         GBossDropRule = data_guild_boss:get_rule(Mid, Score),
            %         NewDropRule = DropRule#ets_drop_rule{drop_rule = GBossDropRule};
            %     false ->
            case Modifier of
                {M, F, A} ->
                    NewDropRule0 = M:F(DropRule, MonArgs, A);
                _ ->
                    NewDropRule0 = DropRule
            end,
            % end,
            NewDropRule = lib_drop:calc_additional_drop_rule(Mid, HurtList, NewDropRule0),
            {StableGoods, TaskGoods, RandGoods, GiftGoods, DoRandGoods} = calc_drop_goods(Ps, NewDropRule, TeamMaxDropR),
            {ActDropList, ActTaskGoods} = ?IF(lists:member(Mid, ?SKIP_MON_DROP_RULE), {[], []}, calc_act_drop_goods(MonArgs)),
            NTaskGoods = TaskGoods ++ ActTaskGoods,
            MulDropList = calc_multiple_drops(Ps, MonArgs, StableGoods),
            NDropList = ActDropList ++ MulDropList ++ DoRandGoods,
            handle_item_task_event(Ps, NTaskGoods),
            NewPs = handle_drop_list(Ps, MonArgs, DropRule, NDropList, RandGoods++GiftGoods, IsNear, HurtList, PList),
            NewPs
    end.

%% 处理掉落物品列表算
%% @param DropList [#ets_drop_goods{}] 实际掉落
%% @param PreRandGoods [#ets_drop_goods{}] 随机掉落总列表
%% @return #player_status{}
handle_drop_list(Ps, _MonArgs, _DropRule, DropList, _PreRandGoods, IsNear, _HurtList, _PList) when
        DropList == [];
        IsNear == false ->
    Ps;
handle_drop_list(Ps, MonArgs, DropRule, DropList, PreRandGoods, _IsNear, HurtList, PList) ->
    % ?MYLOG("hjh", "handle_drop_list Alloc:~p DropList:~p ~n", [DropRule#ets_drop_rule.alloc, DropList]),
    %% 拿到限制的当前物品掉落的个人和全服限制数量
    {PersonLimits, SerLimits, DropedCoin, DefCoinLimitCount} = get_drop_goods_limit(Ps, DropList),
    Args = {PersonLimits, SerLimits, DropedCoin, DefCoinLimitCount},
    %% {掉落金币数量, 玩家单个物品数量列表,全服掉落数量列表}
    {CoinNum, PersonL, SererL, CanDrops, DropedCoin} = do_handle_drop_goods_limit(Ps, DropList, Args),
    % ?MYLOG("hjh", "handle_drop_list CanDrops:~p ~n", [CanDrops]),
    case CanDrops of
        [] -> Ps;
        _ ->
            NowTime = utime:unixtime(),
            ExpireTime = NowTime + ?DROP_ALIVE_TIME,
            #mon_args{scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId, x = Mx, y = My, d_x = BornX, d_y = BornY} = MonArgs,
            case lib_boss:is_in_new_outside_boss(Scene) orelse lib_boss:is_in_special_boss(Scene)
                    orelse lib_territory_treasure:is_on_territory_treasure(Scene)
                    orelse lib_boss:is_in_abyss_boss(Scene) of
                true -> DropX = BornX, DropY = BornY;
                false -> DropX = Mx, DropY = My
            end,
            case lib_territory_treasure:is_on_territory_treasure(Scene) of
                true ->
                    Xys = calc_goods_drop_xy_1(Scene, ScenePoolId, CopyId, DropX, DropY, length(CanDrops));
                false ->
                    Xys = calc_goods_drop_xy(Scene, ScenePoolId, CopyId, DropX, DropY, length(CanDrops))
            end,
            %% 记录特殊boss掉落
            #player_status{id = RoleId, team = #status_team{team_id = TeamId}} = Ps,
            log_boss_all_drop(NowTime, Scene, MonArgs, CanDrops, RoleId, HurtList, TeamId),
            % 存储掉落包
            NewPs = handle_drop_ratio_af_drop(Ps, PreRandGoods, CanDrops),
            %% 生成掉落包数据
            DropArgs = [NewPs, MonArgs, DropRule, ExpireTime, [], [], Xys, HurtList, PList, [], []],
            [_, _, _, _, DropBin, DropIds, _, _, _, DropBagTransportMsgList, DropWayBagList] = lists:foldl(fun handle_drop_item/2, DropArgs, CanDrops),
            TranSportMsg = #drop_transport_msg{
                alloc           = DropRule#ets_drop_rule.alloc,
                mon_id          = MonArgs#mon_args.mid,
                mon_x           = MonArgs#mon_args.x,
                mon_y           = MonArgs#mon_args.y,
                hurt_role_list  = [AttId || #mon_atter{id = AttId} <-MonArgs#mon_args.hurt_list],
                bltype          = DropRule#ets_drop_rule.bltype,
                belong_list     = [AttId1  || #mon_atter{id = AttId1} <- PList],
                drop_bag_list   = DropBagTransportMsgList
            },
            DropWayBagList =/= [] andalso lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_drop, send_drop_reward_way_bag, [DropWayBagList]),
            % ?MYLOG("hjh", "handle_drop_list DropBin:~p DropIds:~p ~n", [length(DropBin), DropIds]),
            handle_drop_bag_list_to_client(Scene, ScenePoolId, CopyId, TranSportMsg),
            %% 先记录次数再发送掉落包
            update_daily_drop_count(NewPs, CoinNum, PersonL, SererL, DropedCoin, PersonLimits, SerLimits),
            send_drop(NewPs, MonArgs, DropRule, DropBin, DropIds),
            NewPs
    end.

%% 掉落后,处理掉落概率
handle_drop_ratio_af_drop(Ps, PreRandGoods, CanDrops) ->
    #player_status{id = RoleId, drop_ratio_map = DropRatioMap} = Ps,
    RatioIdList = [RatioId||#ets_drop_goods{ratio_type = ?DROP_RATIO_TYPE_ADD, ratio_id = RatioId}<-PreRandGoods,
        RatioId > 0, lists:member(RatioId, data_drop_ratio:get_ratio_id_list())],
    HitIdList = [RatioId||#ets_drop_goods{ratio_type = ?DROP_RATIO_TYPE_ADD, ratio_id = RatioId}<-CanDrops,
        RatioId > 0, lists:member(RatioId, data_drop_ratio:get_ratio_id_list())],
    F = fun(RatioId, {Map, DbList}) ->
        #drop_ratio{count = Count, is_hit = IsHit} = DropRatio = maps:get(RatioId, Map, #drop_ratio{ratio_id = RatioId}),
        if
            IsHit == 1 -> {Map, DbList};
            true ->
                case lists:member(RatioId, HitIdList) of
                    true ->
                        NewIsHit = 1,
                        NewDropRatio = DropRatio#drop_ratio{is_hit = NewIsHit},
                        {maps:put(RatioId, NewDropRatio, Map), [[RoleId, RatioId, Count, NewIsHit]|DbList]};
                    false ->
                        NewCount = Count + 1,
                        NewDropRatio = DropRatio#drop_ratio{count = NewCount},
                        {maps:put(RatioId, NewDropRatio, Map), [[RoleId, RatioId, NewCount, IsHit]|DbList]}
                end
        end
    end,
    {NewDropRatioMap, DbList} = lists:foldl(F, {DropRatioMap, []}, RatioIdList),
    lib_drop:db_role_drop_ratio_replace_batch(DbList),
    lib_drop:log_role_drop_ratio(DbList),
    Ps#player_status{drop_ratio_map = NewDropRatioMap}.

%% 次数
-define(LIMIT_DAY_1, 1).
-define(LIMIT_DAY_7, 7).
%% 统计掉落key
-define(DropKey(Type), {?MOD_GOODS, ?MOD_GOODS_DROP, Type}).

%% 获取掉落限制:分成全服掉落,个人掉落限制列表
get_drop_goods_limit(Ps, DropList) ->
    F = fun(Drop, {CoinNum, MyGoods, SerGoods}) ->
        #ets_drop_goods{type=Type, drop_thing_type = DTType, goods_id = GoodsId, num = DNum, goods_list = GoodsList} = Drop,
        if
            Type == ?DROP_TYPE_GIFT_RAND -> get_drop_goods_limit_help(GoodsList, {CoinNum, MyGoods, SerGoods});
            true -> get_drop_goods_limit_help([{DTType, GoodsId, DNum}], {CoinNum, MyGoods, SerGoods})
        end
    end,
    %% 统计所有掉落的金币数量和物品数量
    {TCoinNum, TMyGoods, TSerGoods} = lists:foldl(F, {0, [], []}, DropList),
    %% 玩家掉落限制
    PersonLimits = calc_person_drop_limit(Ps, TCoinNum, TMyGoods),
    %% 全服掉落限制
    SerLimits = calc_all_server_drop_limit(TSerGoods),
    %% {个人玩家已获得数量列表, 全副已经掉落的物品数量, 金币限制数量}
    {PersonLimits, SerLimits, 0, 0}.

get_drop_goods_limit_help([], {CoinNum, MyGoods, SerGoods}) -> {CoinNum, MyGoods, SerGoods};
get_drop_goods_limit_help([{DTType, GoodsId, DNum}|T], {CoinNum, MyGoods, SerGoods}) ->
    NResult = if
        DTType == ?TYPE_GOODS orelse DTType == ?TYPE_BIND_GOODS ->
            case data_drop_limit:get_goods_limit(DTType, GoodsId) of
                #base_drop_limit{limit_type = LimitType, limit_day = LimitDay}
                  when LimitType == ?DROP_LIMIT_GOODID ->
                    case lists:keyfind(GoodsId, 1, MyGoods) of
                        {GoodsId, LimitDay, ODNum} ->
                            NewMyGoods = lists:keystore(GoodsId, 1, MyGoods, {GoodsId, LimitDay, DNum+ODNum}),
                            {CoinNum, NewMyGoods, SerGoods};
                        _ ->
                            {CoinNum, [{GoodsId, LimitDay, DNum}|MyGoods], SerGoods}
                    end;
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

%% 计算掉落限制
do_handle_drop_goods_limit(_Ps, DropList, {PersonLimits, SerLimits, DropedCoin, CoinLimit}) ->
    F = fun(Drop, {CoinNum, PMarkL, SMarkL, CanDropL})->
        #ets_drop_goods{type = Type, drop_thing_type = DTType, goods_id = GoodsId, num = DNum, goods_list = GoodsList} = Drop,
        if
            % 礼包的物品列表组装成 [#ets_drop_goods{},..]
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
        DTType == ?TYPE_GOODS orelse DTType == ?TYPE_BIND_GOODS  ->
            case data_drop_limit:get_goods_limit(DTType, GoodsId) of
                #base_drop_limit{limit_type = LimitType, limit_day = LimitDay, limit_num = LimitNum} when LimitNum > 0  ->
                    case LimitType of
                        ?DROP_LIMIT_GOODID -> %% 玩家按单个物品限制数量
                            {NewPMarkL, NewCanDropL} = update_drop_limit_count(LimitDay, LimitNum, PMarkL, Drop, CanDropL),
                            {CoinNum, NewPMarkL, SMarkL, NewCanDropL};

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

%% 更新上限数量
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

%% 更新玩家记录|全服记录
update_daily_drop_count(Ps, _CoinNum, PersonL, ServerL, _DropedCoin, PersonLimits, SerLimits) ->
    %% 玩家周一，周日
    RoleId = Ps#player_status.id,
    Fun = fun({?LIMIT_DAY_1, PL}) ->
                  NewPL = compare_bf_limits(?LIMIT_DAY_1, PL, PersonLimits),
                  mod_daily:set_count(RoleId, NewPL);
             ({?LIMIT_DAY_7, PL}) ->
                  NewPL = compare_bf_limits(?LIMIT_DAY_7, PL, PersonLimits),
                  mod_week:set_count(RoleId, NewPL);
             (_) -> skip
          end,
    [Fun(X) || X <- PersonL],
    %% 全服
    FS = fun({LimitDay, SL}) ->
                 NewSL = compare_bf_limits(LimitDay, SL, SerLimits),
                 mod_global_counter:set_count(NewSL)
         end,
    [FS(X) || X <- ServerL].

%% 打包掉落物品
%% 优化：采集直接走发物品流程，不走拾取掉落
handle_drop_item(DropGoods, [Ps, MonArgs, DropRule, ExpireTime, DropBin, DropIdList, Xys, HurtList, PList, DropBagTransportMsgList, DropWayBagList]) ->
    % ?MYLOG("hjh", "handle_drop_item DropGoods:~p ~n", [DropGoods]),
    #player_status{
        id = RoleId, sid = _Sid, online = OnLine, onhook = OnHook, figure = #figure{name = RoleName},
        copy_id = PlayerCopyId, team = #status_team{team_id = TeamId}, camp_id = _Camp,
        guild = #status_guild{id=GuildId}
    } = Ps,
    #ets_drop_goods{
        drop_thing_type = DTType, goods_id = GoodsTypeId, drop_icon = DropIcon, bind = Bind1,
        num = GoodsNum, get_way = GetWay, notice = Notice, drop_leff = DropEff, drop_way = DefaultDropWay, show_tips = ShowTips} = DropGoods,
    #ets_drop_rule{alloc = Alloc, bltype = BLType, broad = Broad} = DropRule,
    #mon_args{
        mid = MonId, name = MonName, scene = Scene, kind = Kind, boss = Boss,
        scene_pool_id = ScenePoolId, copy_id = CopyId, x = Mx, y = My, d_x = BornX, d_y = BornY} = MonArgs,
    {DX, DY, LessXys} = ?IF(Xys == [], {Mx, My, []}, begin [{Dx, Dy}|LXys] = Xys, {Dx, Dy, LXys} end),
    Bind = if Bind1 > 0 -> ?BIND; true -> ?UNBIND end,
    PickTime = data_drop_m:get_pick_time(Scene, DTType, GoodsTypeId),
    % 掉落中心点
    case lib_boss:is_in_new_outside_boss(Scene) orelse lib_boss:is_in_special_boss(Scene) of
        true -> DropX = BornX, DropY = BornY;
        false -> DropX = Mx, DropY = My
    end,
    DropWay = lib_hero_halo:change_drop_way(Ps, MonArgs, Alloc, BLType, DefaultDropWay),
    GoodsDrop = #ets_drop{
        scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId,
        x = DX, y = DY, bltype = BLType, drop_thing_type = DTType, alloc = Alloc,
        goods_id = GoodsTypeId, num = GoodsNum, bind = Bind, drop_icon = DropIcon,
        get_way = GetWay, notice = Notice, broad = Broad, expire_time = ExpireTime,
        mon_id = MonId, mon_name = MonName, hurt_list = HurtList, drop_leff = DropEff, drop_way = DropWay,
        any_hurt_list = PList, any_hurt_sum = lib_drop:sum_mon_attr_hurt(PList),
        pick_time = PickTime, drop_x = DropX, drop_y = DropY, show_tips = ShowTips,
        guild_id = GuildId
    },
    #ets_scene{type = SceneType} = data_scene:get(Scene),
    if
        %% 直接发掉落
        Alloc == ?ALLOC_SINGLE orelse Alloc == ?ALLOC_SINGLE_2 ->
            DropId = mod_drop:get_drop_id(),
            Bin = make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, RoleId, 0, 0, 0, 0, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
            NewGoodsDrop = GoodsDrop#ets_drop{id = DropId, player_id = RoleId},
            mod_drop:add_drop(NewGoodsDrop),
            [Ps, MonArgs, DropRule, ExpireTime, [Bin|DropBin], [DropId|DropIdList], LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList];
        % 直接进背包
        DropWay == ?DROP_WAY_BAG ->
            % lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_drop, send_drop_reward_way_bag, [GoodsDrop]),
            % if
            %     DTType == ?TYPE_COIN -> RW = [{?TYPE_COIN, 0, GoodsNum}];
            %     true -> RW = [{?TYPE_BIND_GOODS*Bind, GoodsTypeId, GoodsNum}]
            % end,
            % Produce = #produce{type = mon_drop, reward = RW, remark = "", show_tips = ShowTips},
            % lib_goods_api:send_reward_by_id(Produce, RoleId),
            % SeeRewardList = lib_goods_api:make_see_reward_list(RW, []),
            % lib_player_event:async_dispatch(RoleId, ?EVENT_DROP_CHOOSE, #{id => 0, see_reward => SeeRewardList, drop_way => ?DROP_WAY_BAG, goods => RW, up_goods_list => [], mon_id => MonId}),
            [Ps, MonArgs, DropRule, ExpireTime, DropBin, DropIdList, LessXys, HurtList, PList, DropBagTransportMsgList, [GoodsDrop|DropWayBagList]];
        % 模拟掉落自动进背包(本服)
        DropWay == ?DROP_WAY_BAG_SIMULATE ->
            DropId = mod_drop:get_drop_id(),
            Bin = make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, RoleId, 0, 0, 0, 0, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
            NewGoodsDrop = GoodsDrop#ets_drop{id = DropId, player_id = RoleId},
            mod_drop:add_drop(NewGoodsDrop),
            [Ps, MonArgs, DropRule, ExpireTime, [Bin|DropBin], [DropId|DropIdList], LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList];
        true ->
            case data_drop_limit:get_goods_limit(DTType, GoodsTypeId) of
                #base_drop_limit{limit_type = ?DROP_LIMIT_GOODID} -> %% 特殊物品直接发背包
                    RewardL = [{?TYPE_BIND_GOODS*Bind, GoodsTypeId, GoodsNum}],
                    Produce = #produce{type = mon_drop, reward = RewardL, remark = "", show_tips = ShowTips},
                    lib_goods_api:send_reward_by_id(Produce, RoleId),
                    %% boss 场景记录下掉落记录
                    lib_boss_api:boss_add_drop_log(RoleId, RoleName, Scene, MonId, RewardL),
                    [Ps, MonArgs, DropRule, ExpireTime, DropBin, DropIdList, LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList];
                _ ->
                    if
                        Kind == ?MON_KIND_COLLECT orelse Kind == ?MON_KIND_TASK_COLLECT -> %% 采集直接发背包
                            if
                                DTType == ?TYPE_COIN -> RW = [{?TYPE_COIN, 0, GoodsNum}];
                                true -> RW = [{?TYPE_BIND_GOODS*Bind, GoodsTypeId, GoodsNum}]
                            end,
                            lib_goods_api:send_reward_by_id(RW, mon_drop, RoleId),
                            [Ps, MonArgs, DropRule, ExpireTime, DropBin, DropIdList, LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList];

                        %% 无归属物品直接掉落地上
                        Alloc == ?ALLOC_BLONG andalso BLType == ?DROP_NO_ONE ->
                            DropId = mod_drop:get_drop_id(),
                            Bin = make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, 0, 0, 0, 0, 0, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
                            mod_drop:add_drop(GoodsDrop#ets_drop{id = DropId}),
                            BagMsg = #drop_bag_transport_msg{drop_id = DropId, x = DX, y = DY},
                            [Ps, MonArgs, DropRule, ExpireTime, [Bin|DropBin], DropIdList, LessXys, HurtList, PList, [BagMsg | DropBagTransportMsgList], DropWayBagList];

                        %% 分配方式：伤害均等
                        Alloc == ?ALLOC_HURT_EQUAL ->
                            DropId = mod_drop:get_drop_id(),
                            Bin = make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, RoleId, 0, 0, 0, 0, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
                            mod_drop:add_drop(GoodsDrop#ets_drop{id = DropId, player_id = RoleId}),
                            [Ps, MonArgs, DropRule, ExpireTime, [Bin|DropBin], DropIdList, LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList];

                        %% 离线挂机状态
                        Ps#player_status.online == ?ONLINE_OFF_ONHOOK ->
                            if
                                Boss == ?MON_NORMAL_OUSIDE andalso DTType == ?TYPE_COIN -> %% 直接发铜币
                                    lib_goods_api:send_reward_by_id([{?TYPE_COIN, 0, GoodsNum}], mon_drop, RoleId),
                                    [Ps, MonArgs, DropRule, ExpireTime, DropBin, DropIdList, LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList];
                                Boss == ?MON_NORMAL_OUSIDE ->
                                    case lib_onhook:check_auto_pickup_setting(OnLine, OnHook, GoodsTypeId) of
                                        false -> skip; %% 不要的物品,不掉落
                                        true -> %% 直接发物品,背包不足就不发了
                                            case lib_goods_api:can_give_goods(Ps, [{?TYPE_BIND_GOODS*Bind, GoodsTypeId, GoodsNum}]) of
                                                true ->
                                                    lib_goods_api:send_reward_by_id([{?TYPE_BIND_GOODS*Bind, GoodsTypeId, GoodsNum}], mon_drop, RoleId);
                                                _ -> %% 清理
                                                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_onhook, onhook_auto_devour_equips, [])
                                            end
                                    end,
                                    [Ps, MonArgs, DropRule, ExpireTime, DropBin, DropIdList, LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList];
                                true ->
                                    DropId  = mod_drop:get_drop_id(),
                                    Bin = make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, 0, 0, 0, 0, 0, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
                                    mod_drop:add_drop(GoodsDrop#ets_drop{id = DropId}),
                                    [Ps, MonArgs, DropRule, ExpireTime, [Bin|DropBin], DropIdList, LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList]
                            end;

                        %% 在线的情况下(队伍均等掉落，但是玩家有无队伍，掉落直接归属玩家)
                        Alloc == ?ALLOC_EQUAL ->
                            DropId = mod_drop:get_drop_id(),
                            Bin = make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, RoleId, 0, 0, 0, 0, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
                            NewGoodsDrop = GoodsDrop#ets_drop{id = DropId, player_id = RoleId, team_id = TeamId},
                            mod_drop:add_drop(NewGoodsDrop),
                            ?IF(lib_dungeon:is_on_dungeon(Ps), mod_dungeon:goods_drop(PlayerCopyId, RoleId, NewGoodsDrop), ok),
                            [Ps, MonArgs, DropRule, ExpireTime, [Bin|DropBin], DropIdList, LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList];

                        %% 野外挂机直接发掉落
                        SceneType == ?SCENE_TYPE_OUTSIDE andalso Boss == ?MON_NORMAL_OUSIDE ->
                            {NewDropBin, NewDropIdList} = case lib_onhook:check_auto_pickup_setting(OnLine, OnHook, GoodsTypeId) of
                                false -> {DropBin, DropIdList};
                                true ->
                                    DropId = mod_drop:get_drop_id(),
                                    Bin = make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, RoleId, 0, 0, 0, 0, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
                                    NewGoodsDrop = GoodsDrop#ets_drop{id = DropId, player_id = RoleId},
                                    mod_drop:add_drop(NewGoodsDrop),
                                    {[Bin|DropBin], [DropId|DropIdList]}
                            end,
                            [Ps, MonArgs, DropRule, ExpireTime, NewDropBin, NewDropIdList, LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList];

                        %% 个人掉落
                        BLType == ?DROP_HURT_SINGLE ->
                            DropId = mod_drop:get_drop_id(),
                            Bin = make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, RoleId, 0, 0, 0, 0, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
                            NewGoodsDrop = GoodsDrop#ets_drop{id = DropId, player_id = RoleId},
                            ?IF(lib_dungeon:is_on_dungeon(Ps) == false, ok, mod_dungeon:goods_drop(PlayerCopyId, RoleId, NewGoodsDrop)),
                            mod_drop:add_drop(NewGoodsDrop),
                            [Ps, MonArgs, DropRule, ExpireTime, [Bin|DropBin], DropIdList, LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList];

                        BLType == ?DROP_GUILD andalso GuildId > 0 ->
                            DropId = mod_drop:get_drop_id(),
                            Bin = make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, 0, 0, 0, 0, GuildId, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
                            NewGoodsDrop = GoodsDrop#ets_drop{id = DropId, guild_id = GuildId},
                            mod_drop:add_drop(NewGoodsDrop),
                            BagMsg = #drop_bag_transport_msg{drop_id = DropId, x = DX, y = DY},
                            [Ps, MonArgs, DropRule, ExpireTime, [Bin|DropBin], DropIdList, LessXys, HurtList, PList, [BagMsg | DropBagTransportMsgList], DropWayBagList];


                        TeamId > 0 -> %% 队伍在线状态：第一击|最后一击|伤害最高
                            DropId = mod_drop:get_drop_id(),
                            Bin = make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, 0, 0, TeamId, 0, 0, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
                            NewGoodsDrop = GoodsDrop#ets_drop{id = DropId, team_id = TeamId},
                            mod_drop:add_drop(NewGoodsDrop),
                            ?IF(lib_dungeon:is_on_dungeon(Ps), mod_dungeon:goods_drop(PlayerCopyId, RoleId, NewGoodsDrop), ok),
                            BagMsg = #drop_bag_transport_msg{drop_id = DropId, x = DX, y = DY},
                            [Ps, MonArgs, DropRule, ExpireTime, [Bin|DropBin], DropIdList, LessXys, HurtList, PList, [BagMsg | DropBagTransportMsgList], DropWayBagList];

                        true -> %% 个人玩家：第一击|最后一击|伤害最高
                            DropId = mod_drop:get_drop_id(),
                            Bin = make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, RoleId, 0, 0, 0, 0, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc),
                            NewGoodsDrop = GoodsDrop#ets_drop{id = DropId, player_id = RoleId},
                            ?IF(lib_dungeon:is_on_dungeon(Ps) == false, ok, mod_dungeon:goods_drop(PlayerCopyId, RoleId, NewGoodsDrop)),
                            mod_drop:add_drop(NewGoodsDrop),
                            [Ps, MonArgs, DropRule, ExpireTime, [Bin|DropBin], DropIdList, LessXys, HurtList, PList, DropBagTransportMsgList, DropWayBagList]
                    end
            end
    end.

%% 广播掉落被拾取
send_drop_choose_notice(Ps, DropInfo) ->
    {ok, BinData1} = pt_120:write(12021, [Ps#player_status.id, DropInfo#ets_drop.id, Ps#player_status.figure#figure.name]),
    lib_server_send:send_to_sid(Ps#player_status.sid, BinData1),
    lib_team:send_to_member(Ps#player_status.team#status_team.team_id, BinData1),
    {ok, BinData2} = pt_120:write(12019, [DropInfo#ets_drop.id]),
    lib_server_send:send_to_scene(Ps#player_status.scene, Ps#player_status.scene_pool_id, Ps#player_status.copy_id, BinData2),
    ok.

%% 广播掉落信息
send_drop(Ps, #mon_args{scene = MScene} = MonArgs, DropRule, DropBin, DropIdList) ->
    #ets_drop_rule{alloc = Alloc} = DropRule,
    if
        DropBin == [] -> skip;
        true ->
            #mon_args{
                mid = MonId, scene_pool_id = MSPId,
                copy_id = MCopyId,  x = X, y = Y, boss = MBoss
                } = MonArgs,
            {ok, BinData} = pt_120:write(12017, [MonId, ?DROP_ALIVE_TIME, MScene, DropBin, X, Y, MBoss]),
            Broad = DropRule#ets_drop_rule.broad,
            if
                Broad == ?BROAD_SCENE -> lib_server_send:send_to_scene(MScene, MSPId, MCopyId, BinData);
                Broad == ?BROAD_TEAM andalso Ps#player_status.team#status_team.team_id > 0 ->
                    lib_team:send_to_member(Ps#player_status.team#status_team.team_id, MScene, MSPId, MCopyId, BinData);
                true ->
                    lib_server_send:send_to_sid(Ps#player_status.sid, BinData)
            end
    end,
    if
        DropIdList == [] -> skip;
        true ->
            lib_player:apply_cast(Ps#player_status.id, ?APPLY_CAST_STATUS, lib_goods_drop, drop_list_choose, [MonArgs, Alloc, DropIdList])
    end.

%% 拣取地上掉落包的物品
drop_choose(PS, DropIds) ->
    if
        DropIds == [] -> {ok, PS};
        true -> %% 本服发送默认游戏节点掉落
            PsArgs = lib_drop:trans_to_ps_args(PS, ?NODE_GAME),
            Fun = fun(DropId) -> mod_drop:drop_pickup(none, DropId, PsArgs) end,
            [Fun(Id) || Id <- DropIds],
            {ok, PS}
    end.

%% 拣取地上掉落包的物品(同一时间处理)
drop_list_choose(PS, MonArgs, Alloc, DropIds) ->
    if
        DropIds == [] -> {ok, PS};
        true -> %% 本服发送默认游戏节点掉落
            PsArgs = lib_drop:trans_to_ps_args(PS, ?NODE_GAME),
            mod_drop:drop_list_pickup(none, DropIds, PsArgs, MonArgs, Alloc),
            {ok, PS}
    end.

%% 根据物品类型取任务怪ID
%% @spec get_task_mon(GoodsTypeId) -> mon_id | 0
get_task_mon(GoodsTypeId) ->
    data_drop:get_task_mon(GoodsTypeId).

%% 取掉落物品列表
%% 职业默认0
get_drop_goods_list(DropList) ->
    get_drop_goods_list(DropList, 0).

%% 取掉落物品列表
%% @param Career
get_drop_goods_list(DropList, Career) when is_integer(Career) ->
    get_drop_goods_list(DropList, #drop_args{career = Career});
get_drop_goods_list(DropList, DropArgs) ->
    {_,{Hour,_,_}} = calendar:local_time(),
    NowTime = utime:unixtime(),
    get_drop_goods_list(DropList, DropArgs, NowTime, Hour, [], [], [], []).

%% 取掉落物品列表
get_drop_goods_list_with_ps(Player, DropList) ->
    #player_status{figure = #figure{career = Career}, drop_ratio_map = DropRatioMap} = Player,
    get_drop_goods_list(DropList, #drop_args{career = Career, drop_ratio_map = DropRatioMap}).

get_drop_goods_list([], _DropArgs, _NowTime, _Hour, StableGoods, TaskGoods, RandGoods, GiftGoods) ->
    [StableGoods, TaskGoods, RandGoods, GiftGoods];
get_drop_goods_list([Id|DropList], DropArgs, NowTime, Hour, StableGoods, TaskGoods, RandGoods, GiftGoods) ->
    #drop_args{career = Career, drop_ratio_map = DropRatioMap} = DropArgs,
    [NStableGoods, NTaskGoods, NRandGoods, NGiftGoods] = case data_drop:get_goods(Id) of
        #ets_drop_goods{
                career = TmpCareer,
                time_start = TimeS, time_end = TimeEnd,
                hour_start = HStart, hour_end = HEnd, type = DropType
                } = Drop ->
            NewDrop = recalc_drop_goods_ratio(Drop, DropRatioMap),
            if
                (TimeS > 0 andalso TimeS > NowTime) orelse
                (TimeEnd > 0 andalso TimeEnd < NowTime) orelse
                (HStart > 0 andalso HStart > Hour) orelse
                (HEnd > 0 andalso HEnd < Hour) orelse
                (TmpCareer > 0 andalso TmpCareer =/= Career)->
                    [StableGoods, TaskGoods, RandGoods, GiftGoods];
                DropType =:= ?DROP_TYPE_FIXED ->
                    [[NewDrop|StableGoods], TaskGoods, RandGoods, GiftGoods];
                DropType =:= ?DROP_TYPE_TASK ->
                    [StableGoods, [NewDrop|TaskGoods], RandGoods, GiftGoods];
                DropType =:= ?DROP_TYPE_RAND ->
                    [StableGoods, TaskGoods, [NewDrop|RandGoods], GiftGoods];
                DropType =:= ?DROP_TYPE_GIFT_RAND ->
                    [StableGoods, TaskGoods, RandGoods, [NewDrop|GiftGoods]];
                true ->
                    [StableGoods, TaskGoods, RandGoods, GiftGoods]
            end;
        _ ->
            [StableGoods, TaskGoods, RandGoods, GiftGoods]
    end,
    get_drop_goods_list(DropList, DropArgs, NowTime, Hour, NStableGoods, NTaskGoods, NRandGoods, NGiftGoods).

recalc_drop_goods_ratio(Drop, DropRatioMap) ->
    #ets_drop_goods{ratio_type = RatioType, ratio = Ratio, ratio_id = RatioId} = Drop,
    NewRatio = if
        RatioType == ?DROP_RATIO_TYPE_NORMAL -> Ratio;
        RatioType == ?DROP_RATIO_TYPE_ADD ->
            #drop_ratio{count = Count, is_hit = IsHit} = maps:get(RatioId, DropRatioMap, #drop_ratio{}),
            AddRatio = ?IF(IsHit==0, data_drop_ratio:get_ratio(RatioId, Count+1), 0),
            Ratio + AddRatio;
        true ->
            Ratio
    end,
    Drop#ets_drop_goods{ratio = NewRatio}.

%% 取随机物品掉落数列表
get_drop_num_list(DropRule) ->
    find_ratio(DropRule#ets_drop_rule.drop_rule, 0, urand:rand(1, ?RATIO_COEFFICIENT)).

%% 查找匹配机率的值
find_ratio([], _, _) -> [];
find_ratio([{L,R}|_], S, Ra) when S < Ra andalso Ra =< (S + R) -> L;
find_ratio([{_,R}|T], S, Ra) -> find_ratio(T, (S + R), Ra).

%% 查找匹配机率的值
get_goods_ratio([], R) -> R;
get_goods_ratio([H|T], R) ->
    get_goods_ratio(T, H#ets_drop_goods.ratio + R).

%% DropNumList：掉落数列表
%% RandGoods：随机掉落物品
drop_goods_list(RandGoods, DropNumList) ->
    case DropNumList of
        [] -> [];
        _ -> lists:merge([drop_goods(RandGoods, N, DropNum) || {N, DropNum} <- DropNumList])
    end.

%% 根据单个掉落id：N， 获取相同掉落id：N的掉落物品
drop_goods(RandGoods, N, DropNum) ->
    if
        DropNum =< 0 -> [];
        true ->
            DropList = [GoodsDropR || GoodsDropR <- RandGoods, GoodsDropR#ets_drop_goods.list_id == N],
            case length(DropList) =:= 0 of
                true -> [];
                false -> %% 获取所有相同掉落id的总的概率
                    TotalRatio = get_goods_ratio(DropList, 0),
                    find_drop_goods(DropList, DropNum, TotalRatio, [])
            end
    end.

%% 统一个掉落id，随机多次掉落
find_drop_goods(DropList, DropNum, TotalRatio, Result) ->
    Rand = urand:rand(1, TotalRatio),
    %% 随机掉落id里面的物品，找到一个掉落
    case find_goods(DropList, 0, Rand) of
        [] -> Result;
        DropGoods ->
            case rand_item(DropGoods) of
                % 物品不存在过滤掉
                #ets_drop_goods{type=?DROP_TYPE_RAND, drop_thing_type=?TYPE_GOODS, goods_id=0} -> NewResult = Result;
                #ets_drop_goods{num=0} -> NewResult = Result;
                NewDropGoods -> NewResult = [NewDropGoods | Result]
            end,
            if  DropNum > 1 -> find_drop_goods(DropList, (DropNum - 1), TotalRatio, NewResult);
                true -> NewResult
            end
    end.

%% 随机物品数
%% 注意:为0则抛弃
rand_item(#ets_drop_goods{type = ?DROP_TYPE_GIFT_RAND, gift_weight_list = GiftWeightL} = DropGoods) ->
    Num = urand:rand(DropGoods#ets_drop_goods.min_num, DropGoods#ets_drop_goods.num),
    NGiftWeightL = urand:repeat_list_rand_by_weight(GiftWeightL, 1, Num),
    GoodsList = [Goods||{_W, Goods}<-NGiftWeightL],
    NewGoodsList = [{Type, GoodsTypeId, TmpNum}||{Type, GoodsTypeId, TmpNum}<-GoodsList, TmpNum=/=0],
    NewNum = ?IF(NewGoodsList == [], 0, Num),
    DropGoods#ets_drop_goods{goods_list=NewGoodsList, num=NewNum};
rand_item(DropGoods) ->
    Num = urand:rand(DropGoods#ets_drop_goods.min_num, DropGoods#ets_drop_goods.num),
    DropGoods#ets_drop_goods{num=Num}.

%% 查找匹配机率的值
find_goods([], _, _) -> [];
find_goods([H|_], S, Ra) when Ra > S andalso Ra =< (S + H#ets_drop_goods.ratio) -> H;
find_goods([H|T], S, Ra) -> find_goods(T, (S + H#ets_drop_goods.ratio), Ra).

%% 处理任务物品掉落
handle_item_task_event(_PS, []) -> skip;
handle_item_task_event(PS, TaskGoods) ->
    %% 概率会掉的物品
    Goods = get_task_goods(TaskGoods, []),
    %% 去到任务进程再过滤没有相应任务的物品
    mod_task:send_drop_goods(PS#player_status.tid, PS#player_status.id, Goods).

%% 掉落物品过滤
get_task_goods([], List) -> List;
get_task_goods([#ets_drop_goods{goods_id = GoodsId, ratio = Ratio, bind = Bind}|T], List) ->
    Rand = urand:rand(1, ?RATIO_COEFFICIENT),
    case Rand =< Ratio of
        true ->
            NewList = [{Bind*?TYPE_BIND_GOODS, GoodsId, 1} | List],
            get_task_goods(T, NewList);
        false ->
            get_task_goods(T, List)
    end.

%% task_goods_handle
filter_task_goods(RoleId, TaskGoods, Goods)->
    %% 判断物品是否有上限
    F = fun({Type, GoodsId, Num}, {TDayList, TList}) ->
        case lists:member(GoodsId, TaskGoods) of
            false -> {TDayList, TList};
            true ->
                case data_drop_limit:get_goods_limit(?TYPE_GOODS, GoodsId) of
                    #base_drop_limit{}-> {[{?MOD_GOODS, ?MOD_GOODS_DROP, GoodsId}|TDayList], TList};
                    _ -> {TDayList, [{Type, GoodsId, Num}|TList]}
                end
        end
    end,
    {DayLimitGoods, CanSendGoods} = lists:foldl(F, {[], []}, Goods),
    CanSendDayGoods = if
        DayLimitGoods =/= [] ->
            case catch mod_daily:get_count(RoleId, DayLimitGoods) of
                LimitCounts when is_list(LimitCounts)->
                    F1 = fun({{?MOD_GOODS, ?MOD_GOODS_DROP, GoodsId}, Count}, {DList, NDList}) ->
                        #base_drop_limit{limit_num = LimitNum} = data_drop_limit:get_goods_limit(?TYPE_GOODS, GoodsId),
                        case LimitNum > Count of
                            false -> {DList, NDList};
                            true ->
                                {Type, GoodsId, _Num} = lists:keyfind(GoodsId, 2, Goods),
                                {[{Type, GoodsId, 1}|DList], [{{?MOD_GOODS, ?MOD_GOODS_DROP, GoodsId}, Count+1}|NDList]}
                        end
                    end,
                    {SendDGoods, AddCounts} = lists:foldl(F1, {[], []}, LimitCounts),
                    mod_daily:set_count(RoleId, AddCounts),
                    SendDGoods;
                _ ->
                    []
          end;
        true ->
            []
    end,
    if
        CanSendDayGoods =/= [] andalso CanSendGoods =/= [] ->
            skip;
        true ->
            SendGoods = lists:append(CanSendDayGoods, CanSendGoods),
            lib_goods_api:send_reward_by_id(SendGoods, mon_drop, RoleId)
    end.

%% 制造一个掉落包掉落到场景
make_a_goods_drop(PlayerId, DropArgs) ->
    %% broadcast       是否广播 (?BROAD_NONE|?BROAD_TEAM|?BROAD_SCENE)
    %% drop_thing_type 掉落物品类型(?TYPE_GOODS|?TYPE_COIN)
    #{
       mon_id:=MonId, boss_type:=BossType,
       scene_id:=SceneId, scene_pool_id:=ScenePoolId, copy_id:=CopyId, x:=X, y:=Y,
       goods_id:=GoodsTypeId, goods_num:=GoodsNum,
       broadcast:=BroadCast, drop_thing_type:=DropThingType
     } = DropArgs,
    DropId = mod_drop:get_drop_id(),
    ExpireTime = utime:unixtime()+?DROP_ALIVE_TIME,
    DropIcon = "",
    DropEff = "",
    DropWay = ?DROP_WAY_BAG_SIMULATE,
    Alloc = ?ALLOC_BLONG,
    GoodsDrop = #ets_drop{
        id = DropId,
        player_id = PlayerId,
        team_id = 0,
        scene = SceneId,
        scene_pool_id=ScenePoolId,
        drop_thing_type = DropThingType,
        goods_id = GoodsTypeId,
        num = GoodsNum,
        bind = ?UNBIND,
        notice = [],
        broad = BroadCast,
        expire_time = ExpireTime,
        drop_icon = DropIcon,
        drop_leff = DropEff,
        alloc = Alloc
    },
    mod_drop:add_drop(GoodsDrop),
    DropBin = make_drop_item_bin(DropId, DropThingType, GoodsTypeId, GoodsNum, PlayerId, 0, 0, 0, 0, X, Y, DropEff, DropIcon, 0, ExpireTime, DropWay, Alloc),
    {ok, BinData} = pt_120:write(12017, [MonId, ?DROP_ALIVE_TIME, SceneId, [DropBin], X, Y, BossType]),
    case BroadCast>?BROAD_NONE of
        true  ->
            lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData);
        false ->
            lib_server_send:send_to_uid(PlayerId, BinData)
    end,
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_goods_drop, drop_choose, [[DropId]] ),
    ok.

%% 计算玩家个人1天和7天掉落限制
calc_person_drop_limit(#player_status{id = Id}, _TCoinNum, Goods)->
    Day1 = [{?MOD_GOODS, ?MOD_GOODS_DROP, GoodsId} || {GoodsId, LimitDay, _Num} <- Goods, LimitDay == ?LIMIT_DAY_1],
    Day7 = [{?MOD_GOODS, ?MOD_GOODS_DROP, GoodsId} || {GoodsId, LimitDay, _Num} <- Goods, LimitDay == ?LIMIT_DAY_7],
    [{?LIMIT_DAY_1, mod_daily:get_count(Id, Day1)}, {?LIMIT_DAY_7, mod_week:get_count(Id, Day7)}].

%% 获取全服掉落限制，已经掉落的次数
calc_all_server_drop_limit(TSerGoods)->
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
    [{LimitDay, mod_global_counter:get_count(GoodsL, [{global_diff_day, LimitDay}])} || {LimitDay, GoodsL} <- Goods].

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

%% 根据类型,统计队伍(服)和人最大伤害
%% @return [ []|[Player], []|[Player,...] ]
calc_max_plist(_MonId, SceneId, BlType, PList)->
    SerHurtLimit = get_hurt_limit(SceneId, _MonId, PList),
    Fun = fun(P, [TL, PL]) ->
        if
            BlType == ?DROP_SERVER ->
                case lists:keyfind(P#mon_atter.server_id, 1, TL) of
                    false ->
                        OP = ?IF(P#mon_atter.hurt>=SerHurtLimit, [P], []),
                        [[{P#mon_atter.server_id, P#mon_atter.hurt, OP}|TL], PL];
                    {ServerId, OV, OP} ->
                        NewOP = ?IF(P#mon_atter.hurt>=SerHurtLimit, [P|OP], OP),
                        E = {ServerId, P#mon_atter.hurt+OV, NewOP},
                        NewTL = lists:keystore(ServerId, 1, TL, E),
                        [NewTL, PL]
                end;
            BlType == ?DROP_CAMP ->
                case lists:keyfind(P#mon_atter.camp_id, 1, TL) of
                    false ->
                        OP = ?IF(P#mon_atter.hurt>=SerHurtLimit, [P], []),
                        [[{P#mon_atter.camp_id, P#mon_atter.hurt, OP}|TL], PL];
                    {Camp, OV, OP} ->
                        NewOP = ?IF(P#mon_atter.hurt>=SerHurtLimit, [P|OP], OP),
                        E = {Camp, P#mon_atter.hurt+OV, NewOP},
                        NewTL = lists:keystore(Camp, 1, TL, E),
                        [NewTL, PL]
                end;
            BlType == ?DROP_HURT_SINGLE -> [TL, [P|PL]];
            BlType == ?DROP_ANY_HURT ->
                AnyHurtKey = 0,
                case lists:keyfind(AnyHurtKey, 1, TL) of
                    false ->
                        OP = ?IF(P#mon_atter.hurt>=SerHurtLimit, [P], []),
                        [[{AnyHurtKey, P#mon_atter.hurt, OP}|TL], PL];
                    {AnyHurtKey, OV, OP} ->
                        NewOP = ?IF(P#mon_atter.hurt>=SerHurtLimit, [P|OP], OP),
                        E = {AnyHurtKey, P#mon_atter.hurt+OV, NewOP},
                        NewTL = lists:keystore(AnyHurtKey, 1, TL, E),
                        [NewTL, PL]
                end;
            BlType == ?DROP_GUILD ->
                case lists:keyfind(P#mon_atter.guild_id, 1, TL) of
                    false ->
                        OP = ?IF(P#mon_atter.hurt>=SerHurtLimit, [P], []),
                        [[{P#mon_atter.guild_id, P#mon_atter.hurt, OP}|TL], PL];
                    {GuildId, OV, OP} ->
                        NewOP = ?IF(P#mon_atter.hurt>=SerHurtLimit, [P|OP], OP),
                        E = {GuildId, P#mon_atter.hurt+OV, NewOP},
                        NewTL = lists:keystore(GuildId, 1, TL, E),
                        [NewTL, PL]
                end;
            P#mon_atter.team_id =< 0 -> [TL, [P|PL]];
            true ->
                case lists:keyfind(P#mon_atter.team_id, 1, TL) of
                    false -> [[{P#mon_atter.team_id, P#mon_atter.hurt, [P]}|TL], PL];
                    {TeamId, OV, OP} ->
                        E = {TeamId, P#mon_atter.hurt+OV, [P|OP]},
                        NewTL = lists:keystore(TeamId, 1, TL, E),
                        [NewTL, PL]
                end
        end
    end,
    % 统计队伍(服)列表,人最大伤害列表
    % TLists : [{TeamId|CampId,.., Hurt, [#mon_atter{}]}]
    [TLists, PLists] = lists:foldl(Fun, [[], []], PList),
    if
        TLists == [] andalso PLists == [] -> [[], []];
        TLists == [] ->
            [Player|_T] = lists:reverse(lists:keysort(#mon_atter.hurt, PLists)),
            [[Player], []];
        PLists =:= [] ->
            [{_TId, _TVal, TPL}|_GroupL] = lists:reverse(lists:keysort(2, TLists)),
            [[], lists:reverse(lists:keysort(#mon_atter.hurt, TPL))];
        true ->
            [{_TId, TVal, TPL}|_Team] = lists:reverse(lists:keysort(2, TLists)),
            [Player|_] = lists:reverse(lists:keysort(#mon_atter.hurt, PLists)),
            ?IF(TVal > Player#mon_atter.hurt, [[], lists:reverse(lists:keysort(#mon_atter.hurt, TPL))], [[Player], []])
    end.

%% 计算一起的队伍人数
calc_team_member(0, _PList)-> [];
calc_team_member(TeamId, PList)-> [P || P <- PList, TeamId == P#mon_atter.team_id, P#mon_atter.hurt =/= 0].

%% 珍惜道具添加概率
cherish_goods_add_drop_ratio(Ps, BLType, RandGoods, TeamDropR)->
    RoleDropR = lib_player:get_goods_drop_add_ratio(Ps),
    ModbuffAddR = lib_module_buff:get_equip_dungeon_drop_add(Ps),
    if
        TeamDropR =< 0 andalso RoleDropR =< 0 andalso ModbuffAddR =< 0 -> RandGoods;
        BLType == ?DROP_NO_ONE -> RandGoods;
        true ->
            DropAddR = ?IF(TeamDropR > 0, TeamDropR, RoleDropR),
            #player_status{scene = Scene, dungeon = _StatusDun} = Ps,
            %#status_dungeon{dun_id = _DunId, dun_type = DunType} = StatusDun,
            SceneType = lib_scene:get_scene_type(Scene),
            F = fun(#ets_drop_goods{type = Type, goods_id = GoodsTypeId, gift_weight_list = GiftWeightL, ratio = Ratio} = DropG, TL) ->
                if
                    Type == ?DROP_TYPE_GIFT_RAND ->
                        NewGiftWeightL = [begin
                            case TmpType == ?TYPE_GOODS of
                                true ->
                                    case data_goods_type:get(TmpGoodsTypeId) of
                                        #ets_goods_type{color = Color} when Color >= ?PURPLE ->
                                            if
                                                %% 橙2以上装备掉落率增加
                                                Color >= ?ORANGE andalso
                                                    (SceneType == ?SCENE_TYPE_ABYSS_BOSS orelse SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS) ->
                                                    {round(Weight*(1 + DropAddR + ModbuffAddR)), T};
                                                true ->
                                                    {round(Weight*(1 + DropAddR)), T}
                                            end;
                                        _ -> {Weight, T}
                                    end;
                                false ->
                                    {Weight, T}
                            end
                        end||{Weight, T={TmpType, TmpGoodsTypeId, _Num}}<-GiftWeightL],
                        [DropG#ets_drop_goods{gift_weight_list=NewGiftWeightL}|TL];
                    true ->
                        case data_goods_type:get(GoodsTypeId) of
                            #ets_goods_type{color = Color} when Color >= ?PURPLE ->
                                _EquipStar = lib_equip:get_equip_star(GoodsTypeId),
                                if
                                    %% 装备副本，橙2以上装备掉落率增加
                                    Color >= ?ORANGE andalso
                                        (SceneType == ?SCENE_TYPE_ABYSS_BOSS orelse SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS) ->
                                        [DropG#ets_drop_goods{ratio = round(Ratio*(1 + DropAddR + ModbuffAddR))} | TL];
                                    true ->
                                        [DropG#ets_drop_goods{ratio = round(Ratio*(1 + DropAddR))} | TL]
                                end;
                            _ ->
                                [DropG|TL]
                        end
                end
            end,
            lists:foldl(F, [], RandGoods)
    end.

calc_goods_drop_xy_1(_Scene, _ScenePoolId, _CopyId, Mx, My, 1) -> [{Mx, My}];
calc_goods_drop_xy_1(Scene, _ScenePoolId, _CopyId, Mx, My, DropNum)->
    %% 场景偏移量
    #ets_scene{ width=Width, height=Height} = data_scene:get(Scene),
    % 根据掉落坐标中心上下左右100像素随机
    StX = max(Mx - 200, 0),
    EtX = min(Mx + 200, Width),
    StY = max(My - 200, 0),
    EtY = min(My + 200, Height),
    F = fun(_No) ->
        X = urand:rand(StX, EtX),
        Y = urand:rand(StY, EtY),
        {X, Y}
    end,
    lists:map(F, lists:seq(1, DropNum)).

%% 计算掉落点
calc_goods_drop_xy(_Scene, _ScenePoolId, _CopyId, Mx, My, 1) -> [{Mx, My}];
calc_goods_drop_xy(Scene, _ScenePoolId, _CopyId, Mx, My, DropNum)->
    %% 场景偏移量
    #ets_scene{width=Width, height=Height} = data_scene:get(Scene),
    % 根据掉落坐标中心上下左右120像素随机
    StX = max(Mx - 240, 0),
    EtX = min(Mx + 240, Width),
    StY = max(My - 240, 0),
    EtY = min(My + 240, Height),
    F = fun(_No) ->
        X = urand:rand(StX, EtX),
        Y = urand:rand(StY, EtY),
        {X, Y}
    end,
    lists:map(F, lists:seq(1, DropNum)).
    % 规律的
    % P = 80,
    % N = DropNum*2,
    % M = util:ceil(math:sqrt(N)),
    % XCs = round(Mx - P * (M-1)/2),
    % YCs = round(My - P * (M-1)/2),
    % Fun = fun(I, XyL)->
    %     X = P * util:floor(I/M) + XCs,
    %     Y = P * (I rem M) + YCs,
    %     if
    %         X > Width orelse Y > Height -> {ok, XyL};
    %         X < 0 orelse Y < 0 -> {ok, XyL};
    %         true -> {ok, [{X, Y}| XyL]}
    %     end
    % end,
    % {ok, AllXy} = util:for(0, N, Fun, []),
    % RList = ulists:list_shuffle(AllXy),
    % % ClsType = config:get_cls_type(),
    % % if
    % %     ClsType == ?NODE_CENTER -> lists:sublist(RList, DropNum);
    % %     DropNum =< 20 -> lists:sublist(RList, DropNum);
    % %     true ->
    % %         %% case catch mod_scene_mark:filter_blocked(Scene, CopyId, ?SCENE_MASK_BLOCK, RList, DropNum) of
    % %         %%     {'EXIT', _R} ->
    % %         %%         ?ERR("filter_blocked_xy:~p~n", [_R]),
    % %         %%         lists:sublist(RList, DropNum);
    % %         %%     ReturnList ->
    % %         %%         ReturnList
    % %         %% end
    % %         lists:sublist(RList, DropNum)
    % % end.
    % lists:sublist(RList, DropNum).

drop_to_goodslist(#ets_drop{drop_thing_type = Type, goods_id = GoodsId, num = Num, bind = Bind}) ->
    case Type of
        ?TYPE_COIN -> [{?TYPE_COIN, ?GOODS_ID_COIN, Num}];
        ?TYPE_GOODS when Bind > 0 -> [{?TYPE_BIND_GOODS, GoodsId, Num}];
        ?TYPE_GOODS -> [{?TYPE_GOODS, GoodsId, Num}];
        _ -> []
    end.

%% 副本活动双倍
calc_multiple_drops(#player_status{scene = SceneId, dungeon = #status_dungeon{dun_id = DunId}, collect = #collect_status{drop_end_time = DropEndTime}} = Player,
        #mon_args{scene = SceneId}, DropList) when DunId > 0 andalso DropList =/= [] ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            CheckDungeonDrop = lib_dungeon_api:check_custom_act_drop_times(Player),
            N = case lib_dungeon_api:get_custom_act_drop_times(DunType) of
                N0 when N0 > 1, CheckDungeonDrop -> N0;
                _ ->
                    case lib_collect:get_custom_act_drop_times(DunType, DropEndTime) of
                        N0 when N0 > 1 -> N0;
                        _ -> 1
                    end
            end,
            Effect = lib_custom_act_liveness:get_server_effect_by_dun_type(Player, DunType),
            Multi = N + Effect,
            ulists:elem_multiply(DropList, Multi);
        _ ->
            DropList
    end;

calc_multiple_drops(_, _, DropList) -> DropList.

%% 计算玩家的掉落
check_all_hurtlist_lv(_Scene, _MonId, _BossLv, [])-> false;
check_all_hurtlist_lv(Scene, MonId, BossLv, HurtList)->
    do_check_all_hurtlist_lv(Scene, MonId, BossLv, HurtList).

do_check_all_hurtlist_lv(_Scene, _MonId, _BossLv, []) -> true;
do_check_all_hurtlist_lv(Scene, MonId, BossLv, [BL|HurtList])->
    case lib_goods_check:check_boss_lv(Scene, MonId, BossLv, BL#mon_atter.att_lv) of
        {false, _} -> false;
        {true, _} -> do_check_all_hurtlist_lv(Scene, MonId, BossLv, HurtList)
    end.

%% 记录特殊boss掉落
log_boss_all_drop(NowTime, SceneId, MonArgs, CanDrops, DropRoleId, BLs, TeamId)->
    #mon_args{mid = MonId, boss = Boss} = MonArgs,
    if
        Boss =/= ?MON_LOCAL_BOSS ->
            skip;
        true ->
            HurtLimit = lib_boss_api:get_boss_hurt_limit(SceneId, MonId, BLs),
            BLIds = [Id || #mon_atter{id = Id, hurt = Hurt} <- BLs, Hurt >= HurtLimit],
            F = fun(DGoods, List)->
                        #ets_drop_goods{goods_id = GoodsTypeId, num = GoodsNum, bind = Bind} = DGoods,
                        [{GoodsTypeId, GoodsNum, Bind}|List]
                end,
            GoodsList = lists:foldl(F, [], CanDrops),
            StrGoods = util:term_to_string(GoodsList),
            StrBLIds = util:term_to_string(BLIds),
            InBoss = lib_boss:is_in_all_boss(SceneId),
            if
                InBoss == true ->
                    BossType = lib_boss:get_boss_type_by_scene(SceneId);
                true ->
                    BossType = 0
            end,
            lib_log_api:log_boss_drop(SceneId, MonId, BossType, DropRoleId, StrBLIds, StrGoods, TeamId, NowTime)
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述  额外掉落处理
%% @param    参数      PS::#player_status{}
%%                     MonArgs::#mon_args{}
%%                     PList:: [#mon_atter{}]
%%                     FirstAttr::#mon_atter{}
%%                     Mon      ::#scene_mon{}
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
other_drop(Ps, MonArgs, PList, FirstAttr, _Mon, MainRoleId) ->
    #player_status{id = RoleId, team = Team} = Ps,
    #mon_args{lv = MonLv, scene = ObjectScene, mid = MonCfgId} = MonArgs,
    AllocList = data_drop_other:get_alloc_type(MonCfgId),
%%  ?MYLOG("cym",  "MonCfgId ~p AllocList ~p~n",  [MonCfgId, AllocList]),
    IsDoBossScene = lib_boss:is_in_forbdden_boss(ObjectScene),
    IsOnDungeon   = lib_dungeon:is_on_dungeon(Ps),
    if
        IsOnDungeon andalso AllocList == [] ->  %%副本空掉落，也要发事件，为了满足推送条件
            lib_player_event:async_dispatch(RoleId,  ?EVENT_OTHERS_DROP,
                #{goods => [], up_goods_list => [], id => 0, scene => ObjectScene, alloc => ?ALLOC_SINGLE, mid => MonCfgId});
        IsDoBossScene andalso AllocList == [] ->
            Alloc = ?ALLOC_SINGLE,
            case data_drop:get_rule(MonCfgId, Alloc, MonLv) of
                #ets_drop_rule{bltype = BLType} ->
                    {DropRoleId, _MaxTeamDropR, _TeamHurts} = calc_hurt_role_info(MonArgs#mon_args.mid, ObjectScene, BLType, RoleId, Team, PList, FirstAttr),
                    lib_player_event:async_dispatch(DropRoleId,  ?EVENT_OTHERS_DROP,
                        #{goods => [], up_goods_list => [], id => 0, scene => ObjectScene, alloc => Alloc, mid => MonCfgId});
                _ ->
                    skip
            end;
        true ->
            skip
    end,
    case RoleId == MainRoleId of
        true -> [alloc_other_drop(Ps, MonArgs, Alloc, PList, FirstAttr)|| Alloc <- AllocList];
        false -> [alloc_other_drop(Ps, MonArgs, Alloc, PList, FirstAttr)|| Alloc <- AllocList, Alloc == ?ALLOC_HURT_EQUAL]
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数      PS::#player_status{}
%%                     MonArgs::#mon_args{}
%%                     PList:: [#mon_atter{}]
%%                     FirstAttr::#mon_atter{}
%%                     Alloc      ::分配方式
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
alloc_other_drop(Ps, MonArgs, Alloc, PList, FirstAttr)  ->
    #player_status{id = RoleId, team = Team} = Ps,
    #mon_args{mid = MonCfgId, lv = MonLv, scene = SceneId} = MonArgs,
%%    ?MYLOG("cym",  "MonCfgId  ~p  Alloc ~p  MonLv ~p~n",  [MonCfgId,  Alloc , MonLv]),
    case data_drop_other:get_other_drop(MonCfgId, Alloc, MonLv) of
        #other_drop{belong_type = BLType} ->
            if
                Team#status_team.team_id =/= 0 andalso Alloc == ?ALLOC_EQUAL ->
                    skip;     %暂时没有队伍系统
                Alloc == ?ALLOC_HURT_EQUAL ->
                    HurtLimit = lib_boss_api:get_boss_hurt_limit(SceneId, MonCfgId, PList),
                    case lists:keyfind(RoleId, #mon_atter.id, PList) of
                        #mon_atter{hurt = Hurt} = EqualAttr when Hurt > HurtLimit ->
                            #mon{lv = BossLv} = data_mon:get(MonCfgId),
                            case check_all_hurtlist_lv(SceneId, MonCfgId, BossLv, [EqualAttr]) of
                                true -> skip;
                                false ->
                                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_goods_drop, handle_other_drop_list, [MonArgs, Alloc, 0, []])
                            end;
                        _ -> skip
                    end;
                Alloc == ?ALLOC_SINGLE  orelse  Alloc == ?ALLOC_SINGLE_2  ->
%%                    ?MYLOG("cym",  "Alloc ~p ~n",  [Alloc]),
                    {DropRoleId, MaxTeamDropR, TeamHurts} = calc_hurt_role_info(MonArgs#mon_args.mid, SceneId, BLType, RoleId, Team, PList, FirstAttr),
                    lib_player:apply_cast(DropRoleId, ?APPLY_CAST_STATUS, lib_goods_drop, handle_other_drop_list, [MonArgs, Alloc, MaxTeamDropR, TeamHurts]);
                true ->
                    skip
            end;
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述    处理额外掉落物品列表   空掉落也要派发事件，boss要满足额外掉落和物品掉落才会向客户端推送奖励
%% @param    参数       MonArgs::#mon_args{}
%%                      Alloc::分配方式
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle_other_drop_list(#player_status{figure = F, reincarnation = Reincarnation, id =  PlayerId,
    scene_pool_id = _ScenePoolId, copy_id = _CopyId} = Ps, MonArgs, Alloc, _TeamMaxDropR, _HurtList) ->
    #mon_args{scene = Scene, mid = Mid, lv = MonLv, x = _Mx, y = _My} = MonArgs,
    %% 注:mon_args里面的怪物等级是怪物创建时候的实际等级，会随世界等级变化，所以和配置里面的等级是不一样的
    case data_drop_other:get_other_drop(Mid, Alloc, MonLv)  of
        #other_drop{role_lv = RoleLv, transmigration_lv = TranLv, drop_reward = NDropList} ->
            if
                RoleLv > F#figure.lv orelse TranLv > Reincarnation#reincarnation.turn ->  % 转生等级和玩家等级不满足
                    lib_player_event:async_dispatch(PlayerId, ?EVENT_OTHERS_DROP,
                        #{goods => [], up_goods_list => [], id => 0,  scene =>  Scene,  alloc => Alloc, mid => Mid}),
                    Ps;

                true ->
                    %%日志
%%                    ?MYLOG("cym", "NDropList List ~p ~n", [NDropList]),
                    % lib_log_api:log_role_other_drop(PlayerId, Mid, NDropList),
                    %%直接发送掉落奖励
%                    StartXys  = calc_goods_drop_xy(Scene, ScenePoolId, CopyId, Mx, My, length(NDropList)),
%                    F1 = fun({DTType, GoodId, GoodNum}, Xys) ->
%                        {DX, DY, LessXys} = ?IF(Xys == [], {Mx, My, []}, begin [{Dx, Dy}|LXys] = Xys, {Dx, Dy, LXys} end),
%                        DropId             = mod_drop:get_drop_id(),
%                        BDropEff = pt:write_string(""),
%                        BDropIcon = pt:write_string(""),
%                        ExpireTime = utime:unixtime() + ?DROP_ALIVE_TIME,
%                        Bin = <<DropId:64, DTType:8, GoodId:32, GoodNum:32, PlayerId:64, 0:16,
%                            DX:16, DY:16, BDropEff/binary, BDropIcon/binary, 0:32, ExpireTime:32>>,
%                        {ok, BinData} = pt_120:write(12017, [Mid, ?DROP_ALIVE_TIME, Scene, [Bin], Mx, My, 0]),
% %%                        ?MYLOG("cym", "drop List  ~p~n", [{DTType, GoodId, GoodNum, DX, DY}]),
%                        lib_server_send:send_to_uid(PlayerId, BinData),
%                        LessXys
%                        end,
%                    lists:foldl(F1, StartXys, NDropList),

                    BuffTimes = lib_goods_buff:get_goods_buff_value(Ps, ?BUFF_ZEN_SOUL), % 使用战魂卡增加的战魂倍数
                    % 日志记录，避免因为时间戳重复的原因，先汇总再记录日志
                    LogFun = fun({_Type, RewardId, Num}) ->
                                        case RewardId of
                                            ?GOODS_ID_ZEN_SOUL -> {_Type, RewardId, Num*(BuffTimes+1)};
                                            _ -> {_Type, RewardId, Num}
                                        end
                                    end,
                    LogDropList = lists:map(LogFun, NDropList),
                    lib_log_api:log_role_other_drop(PlayerId, Mid, LogDropList),

                    Fun = fun({_Type, RewardId, _Num} = DropReward, {LastPs, UpGoodsL}) ->
                            case RewardId of
                                ?GOODS_ID_ZEN_SOUL ->
                                    {ok, bag, NewPs, UpGoods} = send_buff_reward(LastPs, DropReward, [], BuffTimes),
                                    {NewPs, [UpGoods|UpGoodsL]};
                                _ -> {LastPs, UpGoodsL}
                            end
                    end,
                    {NewPs, BuffGoodsL} = lists:foldl(Fun, {Ps, []}, NDropList),
                    {ok, _, LastPs, NormGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(NewPs, #produce{reward = NDropList, type = other_drop, show_tips = ?SHOW_TIPS_1}),
                    UpGoodsList = [BuffGoodsL|NormGoodsList],
                    SeeReward = lib_goods_api:make_see_reward_list(NDropList, UpGoodsList),
                    lib_player_event:async_dispatch(PlayerId,  ?EVENT_OTHERS_DROP,
                        #{goods => NDropList, up_goods_list => UpGoodsList, id => 0, scene => Scene, alloc => Alloc, see_reward => SeeReward, mid => Mid}),
                    LastPs
            end;
        _ ->
            lib_player_event:async_dispatch(PlayerId,  ?EVENT_OTHERS_DROP,
                #{goods => [], up_goods_list => [], id => 0, scene => Scene, alloc => Alloc, mid => Mid}),
            Ps
    end.

handle_drop_bag_list_to_client(Scene, ScenePoolId, CopyId, TranSportMsg) ->
    mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_goods_drop, handle_drop_bag_list_to_client_in_scene, [CopyId, TranSportMsg]).

handle_drop_bag_list_to_client_in_scene(_CopyId, TranSportMsg) ->
    #drop_transport_msg{alloc = Alloc, bltype = BLType, mon_x = MonX, mon_y = MonY, belong_list = PList,
        hurt_role_list = RoleList, mon_id = MonId, drop_bag_list = BagList} = TranSportMsg,
    if
        Alloc == ?ALLOC_BLONG andalso BLType == ?DROP_NO_ONE andalso BagList =/= [] -> %% 暂时只是处理这种情况
            case data_mon:get(MonId) of
                #mon{warning_range = Range} ->
                    RightRoleList = get_right_role_list_with_waring(RoleList, Range, MonX, MonY),
                    %%分配掉落包
                    ResList = alloc_drop_bag_list(RightRoleList, BagList),
                    do_send_drop_id_list_to_client(maps:to_list(ResList));
                _ ->
                    skip
            end;
        Alloc == ?ALLOC_BLONG andalso (BLType == ?DROP_SERVER orelse BLType == ?DROP_GUILD orelse BLType == ?DROP_CAMP) andalso BagList =/= [] -> %% 暂时只是处理这种情况
            case data_mon:get(MonId) of
                #mon{warning_range = Range} ->
                    RightRoleList = get_right_role_list_with_waring(PList, Range, MonX, MonY),
                    %%分配掉落包
                    ResList = alloc_drop_bag_list(RightRoleList, BagList),
                    do_send_drop_id_list_to_client(maps:to_list(ResList));
                _ ->
                    skip
            end;
        Alloc == ?ALLOC_BLONG andalso BLType == ?DROP_HURT andalso BagList =/= [] -> %% 暂时只是处理这种情况
            case data_mon:get(MonId) of
                #mon{warning_range = Range} ->
                    RightRoleList = get_right_role_list_with_waring(PList, Range, MonX, MonY),
                    %%分配掉落包
                    ResList = alloc_drop_bag_list(RightRoleList, BagList),
                    do_send_drop_id_list_to_client(maps:to_list(ResList));
                _ ->
                    skip
            end;
        true ->
            ok
    end.
%% 返回  [{RoleId, Node, X, Y}]
get_right_role_list_with_waring(RoleList, Range, MonX, MonY) ->
    get_right_role_list_with_waring(RoleList, Range, MonX, MonY, []).

get_right_role_list_with_waring([], _Range, _MonX, _MonY, AccList) ->
    AccList;
get_right_role_list_with_waring([RoleId | RoleList], Range, MonX, MonY, AccList) ->
    case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{x = X, y = Y, node = Node} ->
            Length2 = (MonX - X) * (MonX - X) + (MonY - Y) * (MonY - Y),
            if
                Length2 =< Range * Range ->%% 在警戒范围内
                   get_right_role_list_with_waring(RoleList, Range, MonX, MonY, [{RoleId, Node, X, Y} | AccList]);
                true ->
                    get_right_role_list_with_waring(RoleList, Range, MonX, MonY, AccList)
            end;
        _ ->
            get_right_role_list_with_waring(RoleList, Range, MonX, MonY, AccList)
    end.

%%返回   Map {RoleId, Node} => [DropId]
alloc_drop_bag_list(RightRoleList, BagList) ->
    alloc_drop_bag_list(RightRoleList, BagList, #{}).

alloc_drop_bag_list(_RightRoleList, [], AccMap) ->
    AccMap;
alloc_drop_bag_list([], _, AccMap) ->  %%特殊情况，周围都没有玩家
    AccMap;
alloc_drop_bag_list([{RoleId, Node, RoleX, RoleY} | RightRoleList], BagList, AccMap) ->
    DropId = alloc_drop_bag_list_help(RoleId, RoleX, RoleY, BagList),  %%DropId  最近的掉落包
    OldDropList = maps:get({RoleId, Node}, AccMap, []),
    NewAccMap = maps:put({RoleId, Node}, OldDropList ++ [DropId], AccMap),  %%顺序放入结果列表
    NewBagList = lists:keydelete(DropId, #drop_bag_transport_msg.drop_id, BagList), %%删除掉落包
    alloc_drop_bag_list(RightRoleList ++ [{RoleId, Node, RoleX, RoleY}], NewBagList, NewAccMap).  %%放到最后面

%%取最近的掉落包
alloc_drop_bag_list_help(_RoleId, RoleX, RoleY, BagList) ->
    List = [#drop_bag_transport_msg{drop_id = DropId, x = X, y = Y, length2 = (RoleX - X) * (RoleX - X) + (RoleY - Y) * (RoleX - Y)} ||
        #drop_bag_transport_msg{drop_id = DropId, x = X, y = Y} <- BagList],
    SortFun = fun(A, B) ->
        A#drop_bag_transport_msg.length2 =< B#drop_bag_transport_msg.length2
    end,
    SortList = lists:sort(SortFun, List),
    #drop_bag_transport_msg{drop_id = ResId} = hd(SortList),  %%这里SortList不可能为空，前面有判断
    ResId.

do_send_drop_id_list_to_client([]) ->
    skip;
do_send_drop_id_list_to_client([{{RoleId, Node}, DropList} | List]) ->
    {ok, Bin} = pt_150:write(15088, [DropList]),
    lib_server_send:send_to_uid(Node, RoleId, Bin),
    do_send_drop_id_list_to_client(List).

get_hurt_limit(SceneId, Mid, PList) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} ->
            SerHurtLimit = data_cluster_sanctuary:get_san_value(drop_reward_hurt_limit);
        _ ->
            SerHurtLimit = lib_boss_api:get_boss_hurt_limit(SceneId, Mid, PList)
    end,
    SerHurtLimit.

%% 构造掉落协议 12017协议
make_drop_item_bin(DropId, DTType, GoodsTypeId, GoodsNum, RoleId, ServerId, TeamId, Camp, GuildId, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc) ->
    BDropEff = pt:write_string(DropEff),
    BDropIcon = pt:write_string(DropIcon),
    %?PRINT("[DropId, DTType, GoodsTypeId, GoodsNum, RoleId, ServerId, TeamId, Camp, GuildId, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc] ~n ~p ~n",
    %    [{DropId, DTType, GoodsTypeId, GoodsNum, RoleId, ServerId, TeamId, Camp, GuildId, DX, DY, DropEff, DropIcon, PickTime, ExpireTime, DropWay, Alloc}]),
    <<DropId:64, DTType:8, GoodsTypeId:32, GoodsNum:32, RoleId:64, ServerId:16, TeamId:64, Camp:16, GuildId:64, DX:16, DY:16, BDropEff/binary,
        BDropIcon/binary, PickTime:32, ExpireTime:32, DropWay:8, Alloc:8>>.

%% 战魂buff额外战魂奖励
send_buff_reward(LastPs, _DropReward, UpGoods, 0) -> {ok, bag, LastPs, UpGoods};
send_buff_reward(LastPs, DropReward, UpGoods, BuffTimes) ->
    {ok, bag, NewPs, GoodsL} = lib_goods_api:send_reward_with_mail_return_goods(LastPs, #produce{reward = [DropReward], type = other_drop, show_tips = ?SHOW_TIPS_5}),
    send_buff_reward(NewPs, DropReward, [GoodsL|UpGoods], BuffTimes-1).


%% 怪物掉落测试
gm_test_drop(MonId, Num) ->
    AllocList = data_drop:get_rule_list(MonId),
    case AllocList of
        [Type|_] ->
            Rule = #ets_drop_rule{drop_list = DropList} = data_drop:get_rule(MonId, Type, 150),
            List = gm_test_drop_core(DropList, Rule, Num),
            Reward = lib_goods_api:make_reward_unique(List),
            ?INFO("gm drop RandGoods ~p ~n", [Reward]),
            Reward;
        _ -> []
    end.

gm_test_drop2(MonId, ListId, Num) ->
    AllocList = data_drop:get_rule_list(MonId),
    case AllocList of
        [Type|_] ->
            Rule0 = #ets_drop_rule{drop_list = DropList0} = data_drop:get_rule(MonId, Type, 150),
            F_filter = fun(Id) ->
                case data_drop:get_goods(Id) of
                    #ets_drop_goods{list_id = ListId} -> true;
                    _ -> false
                end
            end,
            DropList = lists:filter(F_filter, DropList0),

            DropRuleL = Rule0#ets_drop_rule.drop_rule,
            F_filter2 = fun({L, _}) -> lists:keymember(ListId, 1, L) end,
            Rule = Rule0#ets_drop_rule{drop_rule = lists:filter(F_filter2, DropRuleL)},
            List = gm_test_drop_core(DropList, Rule, Num),
            Reward = lib_goods_api:make_reward_unique(List),
            ?INFO("gm drop RandGoods ~p ~n", [Reward]),
            Reward;
        _ -> []
    end.

gm_test_drop_core(DropList, Rule, Num) ->
    F = fun(_Index, Acc) ->
        [_StableGoods, _TaskGoods, RandGoods, GiftGoods] = get_drop_goods_list(DropList, #drop_args{career = 1, drop_ratio_map = #{}}),
        DropNumList = get_drop_num_list(Rule),
        DoRandGoods = drop_goods_list(RandGoods ++ GiftGoods, DropNumList),
        GoodsL =
            [begin
                 case Drop of
                     #ets_drop_goods{type = 0, drop_thing_type = Te, goods_id = Gid} ->
                         [{Te, Gid, 1}];
                     #ets_drop_goods{type = 3, goods_list = GoodsList} -> GoodsList;
                     _ -> []
                 end
             end||Drop<-DoRandGoods],
        lists:flatten(GoodsL) ++ Acc
        end,
    lists:foldl(F, [], lists:seq(1, Num)).

