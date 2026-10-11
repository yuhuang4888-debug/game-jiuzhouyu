%% ---------------------------------------------------------------------------
%% @doc lib_hi_point_api

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/10/16
%% @deprecated
%% ---------------------------------------------------------------------------
-module(lib_hi_point_api).

%% API
-compile([export_all]).
-include("common.hrl").
-include("server.hrl").
-include("hi_point.hrl").
-include("figure.hrl").
-include("mount.hrl").
-include("def_module.hrl").
-include("dragon.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("soul.hrl").
-include("def_fun.hrl").
-include("rec_baby.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("dungeon.hrl").
-include("scene.hrl").
-include("treasure_hunt.hrl").
-include("predefine.hrl").
-include("rec_recharge.hrl").
-include("def_recharge.hrl").

%% 聚魂（源力）镶嵌
hi_point_task_soul_set(GS, Ps) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Ps,
    Dict = GS#goods_status.dict,
    PosList = data_soul:get_soul_pos_list(),  % 获取所有聚魂位置
    F = fun(Pos, CNum) ->
        GoodInfo = lib_goods_util:get_goods_by_cell(Ps#player_status.id, ?GOODS_LOC_SOUL, Pos, Dict),
        case is_record(GoodInfo, goods) of
            true ->
                #goods{color = Color} = GoodInfo,
                ?IF(Color >=4, CNum + 1, CNum);
            false -> CNum
        end
        end,
    OrangeNum = lists:foldl(F, 0, PosList),
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_SOUL, ?SUB_ID, set, OrangeNum).

%% 聚魂（源力）升级
hi_point_task_soul_lv(GS, Ps) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Ps,
    Dict = GS#goods_status.dict,
    PosList = data_soul:get_soul_pos_list(),  % 获取所有聚魂位置
    F = fun(Pos, MaxLv) ->
        GoodInfo = lib_goods_util:get_goods_by_cell(Ps#player_status.id, ?GOODS_LOC_SOUL, Pos, Dict),
        case is_record(GoodInfo, goods) of
            true ->
                #goods{level = Lv} = GoodInfo,
                ?IF(Lv >=MaxLv, Lv, MaxLv);
            false -> MaxLv
        end
        end,
    MaxLv = lists:foldl(F, 0, PosList),
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_SOUL, ?SUB_ID, lv, MaxLv).

%% 龙纹升级
hi_point_task_dragon_lv(GS, PS) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = PS,
    Dict = GS#goods_status.dict,
    #status_dragon{pos_list = PosList} = PS#player_status.dragon,
    F = fun(#dragon_pos{pos = Pos}, MaxLv) ->
        GoodInfo = lib_goods_util:get_goods_by_cell(PS#player_status.id, ?GOODS_LOC_DRAGON_EQUIP, Pos, Dict),
        case is_record(GoodInfo, goods) of
            true ->
                #goods{color = Color, level = Lv} = GoodInfo,
                case Color >= 3 of %% 紫色以上
                    true ->  ?IF(MaxLv =< Lv, Lv, MaxLv);
                    false -> MaxLv
                end;
            false -> MaxLv
        end
        end,
    MaxLv = lists:foldl(F, 0, PosList),
%%    ?PRINT("MaxLv ~p ~n", [MaxLv]),
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DRAGON, ?SUB_ID, set, MaxLv).

%% 角色升级
hi_point_task_role_lv(RoleId, RoleLv) ->
    mod_hi_point:check_role_status(RoleId, RoleLv).

%% 充值
hi_point_task_recharge(RoleId, RoleLv, Num) ->
    mod_hi_point:complete_task(RoleId, RoleLv, ?RECHARG_MOD, ?SUB_ID, recharge, Num).

%% 坐骑宠物升阶
hi_point_task_stage(RoleId, RoleLv, SubId, StageStar) ->
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_MOUNT, SubId, stage, StageStar).

%% 宝宝养育升级升级
hi_point_task_baby_lv(PS) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}, status_baby = StatusBaby} = PS,
    Lv = StatusBaby#status_baby.raise_lv,
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_BABY, ?SUB_ID, lv, Lv).

%% 宝宝升阶
hi_point_task_baby_stage(RoleId, RoleLv) ->
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_BABY, ?SUB_ID, count, 1).

%% 夺宝
hi_point_treasure_hunt(RoleId, RoleLv, Type, Count) ->
    if
        Type == ?TREASURE_HUNT_TYPE_EUQIP -> %%装备夺宝 个人嗨点和定制嗨点都会触发
            mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_TREASURE_HUNT, Type, count, Count);
            % mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_TREASURE_HUNT, ?SUB_ID, single, Count);
        Type == ?TREASURE_HUNT_TYPE_PEAK -> %% 只触发定制嗨点
            mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_TREASURE_HUNT, ?SUB_ID, single, Count);
        Type == ?TREASURE_HUNT_TYPE_EXTREME ->
            mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_TREASURE_HUNT, ?SUB_ID, single, Count);
        Type == ?TREASURE_HUNT_TYPE_RUNE ->
            mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_TREASURE_HUNT, Type, count, Count);
        true -> skip
    end.

hi_point_task_mount_upgrade(RoleId, RoleLv, {NewStage, NewStar}, TypeId) ->
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_MOUNT, TypeId, stage, {NewStage, NewStar}).

%% 击杀boss（蛮荒，世界，boss之家）
hi_point_task_boss_kill(BLWhos, BossType) ->
    % ?PRINT("@@@BLWhos ~p ~n", [BLWhos]),
    [mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_BOSS, BossType, ?SINGLE, 1) || #mon_atter{id = RoleId, att_lv = RoleLv} <- BLWhos].

%% 进入蛮荒boss
hi_point_task_enter_mh(RoleId, RoleLv,BossType) ->
    SubId = get_enter_boss_sub_id(BossType),
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_BOSS, SubId, ?SINGLE, 1).

%% 击杀跨服Boss
hi_point_task_kill_kf_boss(RoleId, RoleLv, BossType) ->
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_BOSS, BossType, ?SINGLE, 1).

%% 进入/扫荡 副本
%%hi_point_task_dungeon(RoleId, RoleLv, DunType) ->
%%    hi_point_task_dungeon(RoleId, RoleLv, DunType, 1).
%%hi_point_task_dungeon(RoleId, RoleLv, DunType, Count) ->
%%    ?PRINT("@@@@@@dungeon ~p ~n~n", [Count]),
%%    if
%%        DunType == ?DUNGEON_TYPE_COIN ->
%%            mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DUNGEON, ?DUNGEON_TYPE_COIN, ?SINGLE, Count);
%%        DunType == ?DUNGEON_TYPE_PARTNER ->
%%            mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DUNGEON, ?DUNGEON_TYPE_PARTNER, ?SINGLE, Count);
%%        DunType == ?DUNGEON_TYPE_EXP_SINGLE ->
%%            mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DUNGEON, ?DUNGEON_TYPE_EXP_SINGLE, ?SINGLE, Count);
%%        DunType == ?DUNGEON_TYPE_COUPLE ->
%%            mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DUNGEON, ?DUNGEON_TYPE_COUPLE, ?SINGLE, Count);
%%        DunType == ?DUNGEON_TYPE_DRAGON ->
%%            mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DUNGEON, ?DUNGEON_TYPE_DRAGON, ?SINGLE, Count);
%%        DunType == ?DUNGEON_TYPE_VIP_PER_BOSS ->
%%            mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DUNGEON, ?DUNGEON_TYPE_VIP_PER_BOSS, ?SINGLE, Count);
%%        true ->
%%            skip
%%    end.

%% 升级
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{id = RoleId,
        figure = #figure{lv = RoleLv}} = Player,
    hi_point_task_login(RoleId, RoleLv),
    {ok, Player};

%% 充值
handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{recharge_product = Product, gold = Gold}}) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    IsTrigger = lib_recharge_api:is_trigger_recharge_act(Product),
    RealGold = lib_recharge_api:special_recharge_gold(Product, Gold),
    if
        IsTrigger, RealGold > 0 -> hi_point_task_recharge(RoleId, Lv, Gold);
        true -> skip
    end,
    {ok, Player};

%% 钻石消耗
handle_event(PS, #event_callback{type_id = ?EVENT_MONEY_CONSUME, data = Data})  ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PS,
    #callback_money_cost{consume_type = ConsumeType, money_type = MoneyType, cost = Cost} = Data,
    case lib_consume_data:is_consume_for_act(ConsumeType) of
        true ->
            case MoneyType =:= ?GOLD of
                true ->
                    mod_hi_point:complete_task(RoleId, Lv, ?COST_MOD, ?SUB_ID, cost, Cost);
                false -> skip
            end;
        _ -> skip
    end,
    {ok, PS};

%% 副本通关(暂时只有聚魂副本)
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = Data}) ->
   #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = PS,
   #callback_dungeon_succ{
       dun_id = _DunId, dun_type = DunType, count = Count} = Data,
   if
       DunType == ?DUNGEON_TYPE_SPRITE_MATERIAL ->
           mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DUNGEON, ?DUNGEON_TYPE_SPRITE_MATERIAL, ?SINGLE, Count);
       DunType == ?DUNGEON_TYPE_COIN ->
           mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DUNGEON, ?DUNGEON_TYPE_COIN, ?SINGLE, Count);
       DunType == ?DUNGEON_TYPE_EQUIP ->
           mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DUNGEON, ?DUNGEON_TYPE_EQUIP, ?SINGLE, Count);
       true ->
           skip
   end,
    {ok, PS};
%% 进入 副本
handle_event(Player, #event_callback{type_id = ?EVENT_DUNGEON_ENTER, data = #callback_dungeon_enter{dun_type = SubType, count = Count}}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    DungeonList = [?DUNGEON_TYPE_PARTNER, ?DUNGEON_TYPE_EXP_SINGLE, ?DUNGEON_TYPE_COUPLE, ?DUNGEON_TYPE_DRAGON, ?DUNGEON_TYPE_VIP_PER_BOSS],
    ?IF(lists:member(SubType, DungeonList),
        mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DUNGEON, SubType, ?SINGLE, Count),
        skip),
    {ok, Player}.

%% 扫荡副本
hi_point_task_sweep_dun(RoleId, RoleLv, DunType, Count) ->
    DungeonList = [?DUNGEON_TYPE_PARTNER_NEW], % 其它几种副本扫荡已由通关事件触发
    ?IF(lists:member(DunType, DungeonList),
        mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_DUNGEON, DunType, ?SINGLE, Count),
    skip).

%% 祈愿
hi_point_task_pray(RoleId, RoleLv) ->
    % 金币祈愿和钻石祈愿同一算 sub_id用默认的
%%    ?PRINT("@@@@@@pray ~n~n", []),
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_PRAY, ?SUB_ID, count, 1).

%% 日常任务
hi_point_task_daliy(Ps, Count) when is_record(Ps, player_status) ->
%%    ?PRINT("@@@@@@daliy ~n~n", []),
    #player_status{id = RoleId, figure = #figure{lv =RoleLv}} = Ps,
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_TASK, ?SUB_ID, ?SINGLE, Count);

%% 日常任务
hi_point_task_daliy(RoleId, RoleLv) ->
%%    ?PRINT("@@@@@@daliy ~n~n", []),
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_TASK, ?SUB_ID, ?SINGLE, 1).

%% 日常任务
hi_point_task_daliy(RoleId, RoleLv, Count) ->
%%    ?PRINT("@@@@@@daliy ~n~n", []),
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_TASK, ?SUB_ID, ?SINGLE, Count).

%% 护送
hi_point_task_husong(RoleId, RoleLv) ->
%%    ?PRINT("@@@@@@husong ~n~n", []),
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_HUSONG, ?SUB_ID, ?SINGLE, 1).

%% 竞技场
hi_point_task_jjc(RoleId, RoleLv, ChallengeTimes) ->
%%    ?PRINT("@@@@@@jjc ~n~n", []),
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_JJC, ?SUB_ID, ?SINGLE, ChallengeTimes).

%% 登录
hi_point_task_login(RoleId, RoleLv) ->
    mod_hi_point:complete_task(RoleId, RoleLv, ?MOD_BASE, ?SUB_ID, ?SINGLE, 1).
hi_point_task_login(Player) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    hi_point_task_login(RoleId, RoleLv).

%% 使用嗨点之灵物品
use_hi_goods(NewPlayerStatus, GoodsId, GoodsNum) ->
%%    ?PRINT("@@@@@@@@@@@@@@@@@@goodsid ~p ~n", [GoodsId]),
    case GoodsId == ?HI_GOODS_ID of
        true ->
            #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = NewPlayerStatus,
            mod_hi_point:complete_task(RoleId, RoleLv, 0, ?SUB_ID, ?SINGLE, GoodsNum);
        false -> skip
    end.

%% gm添加嗨点
gm_add_points(Num, PS) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = PS,
    mod_hi_point:complete_task(RoleId, RoleLv, 0, ?SUB_ID, ?SINGLE, Num).

%% 配置是根据 mod_id sub_id区分嗨点活动的任务，由于存在击杀和进入
%% mod_id 和 sub_id 会一致没所以在进入boss场景的时候做了特殊处理
get_enter_boss_sub_id(BossType) when is_number(BossType) ->
    1000 + BossType;
get_enter_boss_sub_id(BossType) -> BossType.

%% 每日零点触发
midnight_trigger() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_STATUS, lib_hi_point_api, hi_point_task_login, [])|| E <- OnlineRoles].