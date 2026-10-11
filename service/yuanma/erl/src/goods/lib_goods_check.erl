%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2011-12-23
%% Description: 装备检查
%% --------------------------------------------------------
-module(lib_goods_check).
-compile(export_all).
-include("def_goods.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").
-include("shop.hrl").
-include("task.hrl").
-include("drop.hrl").
-include("predefine.hrl").
-include("sell.hrl").
-include("attr.hrl").
-include("vip.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("team.hrl").
-include("scene.hrl").
-include("boss.hrl").
-include("eudemons_land.hrl").
-include("decoration.hrl").

%% 正常检查
check_goods_normal(GoodsStatus, GoodsId) ->
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    if
        is_record(GoodsInfo, goods) =:= false ->
            {fail, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.player_id =/= GoodsStatus#goods_status.player_id ->
            {fail, ?ERRCODE(err150_palyer_err)};
        GoodsInfo#goods.type == ?GOODS_TYPE_EQUIP andalso %% 天使恶魔过滤掉背包物品的位置
        GoodsInfo#goods.subtype == ?EQUIP_ANGLE_DEVIL ->
            {ok, GoodsInfo};
        GoodsInfo#goods.location =/= GoodsInfo#goods.bag_location ->
            {fail, ?ERRCODE(err150_location_err)};
        true ->
            {ok, GoodsInfo}
    end.

%%-------------------------------------------------------
%% @doc 检查删除单个物品
%% -spec check_delete(GoodsStatus, GoodsId, GoodsNum) -> {ok, GoodsInfo} | {fail, Err}
%% when
%%      GoodsStatus :: #goods_statuws{} 物品进程状态
%%      GoodsId     :: integer()        物品Id
%%      GoodsNum    :: integer()        要删除的物品数量
%%      GoodsInfo   :: #goods{}         物品信息
%%      Err         :: integer()        错误码
%% @end
%%-----------------------------------------------------------
check_delete(GoodsStatus, GoodsId, GoodsNum) ->
    case check_goods_normal(GoodsStatus, GoodsId) of
        {ok, GoodsInfo} ->
            if
                GoodsNum < 1 orelse GoodsInfo#goods.num < GoodsNum ->
                    %% 物品数量不正确
                    {fail, ?ERRCODE(err150_num_err)};
                true ->
                    {ok, GoodsInfo}
            end;
        ErrorRes ->
            ErrorRes
    end.

%%------------------------------------------------------------
%% @doc 检查删除多个物品
%% -spec check_delete_list(GoodsStatus, GoodsList) -> {ok, List} | {fail, Err}
%% when
%%      GoodsStatus :: #goods_statuws{} 物品进程状态
%%      GoodsList   :: list() 要删除的物品列表[{物品Id, 删除数量}]
%%      List        :: list() 要删除的物品列表[[{物品信息#goods{}], 删除数量}]
%%      Err         :: integer() 错误码
%% @end
%%----------------------------------------------------------------
check_delete_list(GoodsStatus, GoodsList) ->
    F = fun({GoodsId,GoodsNum}, List) ->
        case check_delete(GoodsStatus, GoodsId, GoodsNum) of
            {ok, GoodsInfo} -> {ok, [{GoodsInfo, GoodsNum} | List]};
            {fail, Res} -> {fail, Res}
        end
    end,
    list_handle(F, [], GoodsList).


%% ---------------------------------------------------------------------------
%% @doc 检查根据物品类型Id列表删除物品
-spec check_delete_type_list(GoodsStatus, GoodsTypeList) -> {ok} | {fail} when
    GoodsStatus :: #goods_status{},
    GoodsTypeList:: [{GoodsTypeId :: integer(), DeleteNum :: integer()}].
%% ---------------------------------------------------------------------------
check_delete_type_list(GoodsStatus, GoodsTypeList) ->
    #goods_status{player_id = PlayerId, dict = Dict} = GoodsStatus,
    Fun = fun({GoodsTypeId, DeleteNum}) ->
        case data_goods_type:get(GoodsTypeId) of
            #ets_goods_type{bag_location = BagLocation} ->
                GoodsList = lib_goods_util:get_type_goods_list(
                    PlayerId, GoodsTypeId, BagLocation, Dict
                ),
                TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
                TotalNum >= DeleteNum;
            _ -> false
        end
    end,
    case lists:all(Fun, GoodsTypeList) of
        false -> {fail};
        true -> {ok}
    end.

%%-----------------------------------------------------------------------
%% @doc 检查背包拖动物品
%% -spce check_drag_goods(GoodsStatus, GoodsId, OldCell, NewCell, MaxCellNum) ->
%%          {ok, GoodsInfo}|{fail, ?Err}
%% when
%%      GoodsStatus :: #goods_status{}      物品 进程状态
%%      GoodsId     :: integer()            物品Id
%%      OldCell     :: integer()            物品所在格子
%%      NewCell     :: integer()            要移到的格子
%%      MaxCellNum  :: integer()            最大格子数，也就是最大的格子编号
%% @end
%%--------------------------------------------------------------------------
check_drag_goods(GoodsStatus, GoodsId, OldCell, NewCell, MaxCellNum) ->
    case check_goods_normal(GoodsStatus, GoodsId) of
        {ok, GoodsInfo} ->
            if
                %% 物品格子位置不正确
                GoodsInfo#goods.cell =/= OldCell ->
                    {fail, ?ERRCODE(err150_location_err)};
                %% 物品格子位置不正确
                NewCell < 1 orelse NewCell > MaxCellNum ->
                    {fail, ?ERRCODE(err150_location_err)};
                true ->
                    {ok, GoodsInfo}
            end;
        ErrorRes ->
            ErrorRes
    end.


%%-------------------------------------------------------------------------------------------------------------------
%% @doc 检查使用物品
%% @spec check_use_goods(PlayerStatus, GoodsId, GoodsNum, GoodsStatus) -> {ok, GoodsInfo, GiftInfo} | {fail, ?ERRCODE} when
%% PlayerStatus :: #player_status{}     玩家记录
%% GoodsId      :: integer()            物品Id
%% GoodsStatus  :: #goods_status{}      玩家物品进程状态
%% GoodsInfo    :: #goods{}             物品记录
%% GiftInfo     :: #ets_gift{}          礼包记录,礼包有返回，否则为{}
%% ?ERRCODE     :: integer()            错误码
%% @end
%%-------------------------------------------------------------------------------------------------------------------
check_use_goods(PlayerStatus, GoodsId, GoodsNum, GoodsStatus) ->
    NowTime = utime:unixtime(),
    case check_goods_normal(GoodsStatus, GoodsId) of
        {ok, GoodsInfo} ->
            if
                GoodsNum < 1 orelse GoodsInfo#goods.num < GoodsNum ->
                    {fail, ?ERRCODE(err150_num_err)};
                GoodsInfo#goods.level > PlayerStatus#player_status.figure#figure.lv ->
                    {fail, {?ERRCODE(err150_lv_err_2), [GoodsInfo#goods.level]}};
                GoodsInfo#goods.expire_time > 0 andalso GoodsInfo#goods.expire_time =< NowTime ->
                    {fail, ?ERRCODE(err150_goods_expired)};
                GoodsInfo#goods.location =/= ?GOODS_LOC_BAG ->
                    {fail, ?ERRCODE(err150_location_err)};
                true ->
                    case data_goods_type:get(GoodsInfo#goods.goods_id) of
                        [] -> {fail, ?ERRCODE(err150_no_goods)};
                        _GoodsTypeInfo ->
                            if
                                GoodsInfo#goods.type =:= ?GOODS_TYPE_GIFT orelse
                                    GoodsInfo#goods.type =:= ?GOODS_TYPE_LV_GIFT ->
                                    lib_gift_check:ckeck_use_gift(PlayerStatus, GoodsStatus, GoodsInfo, GoodsNum);
                                GoodsInfo#goods.type =:= ?GOODS_TYPE_COUNT_GIFT ->
                                    lib_gift_check:check_use_count_gift(PlayerStatus, GoodsStatus, GoodsInfo, GoodsNum);
                                GoodsInfo#goods.type =:= ?GOODS_TYPE_OPTIONAL_GIFT ->
                                    #figure{career = Career, lv = Lv} = PlayerStatus#player_status.figure,
                                    case lib_gift_new:get_optional_gift(GoodsInfo#goods.goods_id, Career, Lv) of
                                        [] -> {fail, ?ERRCODE(err150_no_gift_type)};
                                        OptionalGift -> {ok, GoodsInfo, OptionalGift}
                                    end;
                                GoodsInfo#goods.type =:= ?GOODS_TYPE_POOL_GIFT ->
                                    lib_gift_check:check_use_pool_gift(PlayerStatus, GoodsStatus, GoodsInfo, GoodsNum);
                                true ->
                                    {ok, GoodsInfo}
                            end
                    end
            end;
        ErrorRes ->
            ErrorRes
    end.

%%--------------------------------------------
%% 销毁物品
%%--------------------------------------------
check_throw(GoodsStatus, GoodsId, GoodsNum) ->
    case check_goods_normal(GoodsStatus, GoodsId) of
        {ok, GoodsInfo} ->
            if
                %% 物品不可销毁
                GoodsInfo#goods.isdrop =:= 1 ->
                    {fail, ?ERRCODE(err150_not_trhow)};
                %% 物品数量不正确
                GoodsNum < 1 orelse GoodsInfo#goods.num < GoodsNum ->
                    {fail, ?ERRCODE(err150_num_err)};
                true ->
                    {ok, GoodsInfo}
            end;
        ErrorRes ->
            ErrorRes
    end.

%%------------------------------------------------------
%% 检查拣取地上掉落包的物品
%% @param DropId :: integer() 掉落包Id
%%------------------------------------------------------
check_drop_choose(PlayerStatus, GoodsStatus, DropId, GoodsStatus) ->
    case check_drop_list(PlayerStatus, DropId) of
        {fail, Res} -> {fail, Res};
        {ok, #ets_drop{drop_thing_type = ThingType, goods_id = GoodsTypeId, bind = Bind, num = DropNum} = DropInfo} ->
            #goods_status{player_id = PlayerId, dict = Dict} = GoodsStatus,
            case ThingType of
                ?TYPE_COIN -> %% 铜币
                    {ok, {coin, DropNum}, DropInfo, 0, 0};
                ?TYPE_GOODS -> %% 物品
                    case data_goods_type:get(GoodsTypeId) of
                        #ets_goods_type{bag_location = BagLocation, max_overlap = MaxOverLap} = GoodsTypeInfo->
                            NullCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, BagLocation),
                            GoodsList = lib_goods_util:get_type_goods_list(PlayerId, GoodsTypeId, Bind, BagLocation, Dict),
                            GoodsInfo = lib_goods_util:get_new_goods(GoodsTypeInfo),
                            CellNum   = lib_storage_util:get_null_cell_num(GoodsList, GoodsInfo, MaxOverLap, DropNum),
                            Dis = get_drop_distance(PlayerStatus, DropInfo),
                            if
                                Dis =:= false -> {fail, ?ERRCODE(err150_distance)};
                                CellNum > NullCellNum -> %% 查看是不是个人计数掉落
                                    case data_drop_limit:get_goods_limit(ThingType, GoodsTypeId) of
                                        #base_drop_limit{limit_type = ?DROP_LIMIT_GOODID} ->
                                            {ok, {goods, GoodsTypeInfo}, DropInfo, NullCellNum, CellNum};
                                        _ ->
                                            {fail, ?ERRCODE(err150_no_cell)}
                                    end;
                                true ->
                                    {ok, {goods, GoodsTypeInfo}, DropInfo, NullCellNum, CellNum}
                            end;
                        _ ->
                            {fail, ?ERRCODE(err150_no_goods_type)}
                    end;
                _ ->
                    {fail, ?FAIL}
            end
    end.

%%-------------------------------------------
%% 检查掉落包距离
%%-------------------------------------------
get_drop_distance(PlayerStatus,  DropInfo) ->
    PlayerStatus#player_status.scene =:= DropInfo#ets_drop.scene.
%%     (PlayerStatus#player_status.scene =:= DropInfo#ets_drop.scene andalso
%%         abs(DropInfo#ets_drop.x - PlayerStatus#player_status.x) =< 5*90 andalso
%%         abs(DropInfo#ets_drop.y - PlayerStatus#player_status.y) =< 5*90).

%%--------------------------------------------------
%% 检查掉落包
%% @param: DropId :: integer() 掉落包Id
%% @return: DropInfo :: #ets_drop() 掉落包信息
%%--------------------------------------------------
check_drop_list(#player_status{figure = #figure{vip = Vip, vip_type = VipType}} = Ps, DropId) ->
    NowTime = utime:unixtime(),
    case mod_drop:get_drop(DropId) of
        #ets_drop{player_id = PlayerId, expire_time = ExpireTime, mon_id = MonId, bltype = _BLType,
            scene = Scene, copy_id = CopyId, team_id = TeamId, hurt_list = HurtList} = DropInfo ->
            #mon{boss = BossType, lv = BossLv} = data_mon:get(MonId),
            IsNoCheckHp = IsNoNeedHurt = lib_boss:is_in_outside_boss(Scene) orelse lib_boss:is_in_forbdden_boss(Scene)
			orelse lib_boss:is_in_special_boss(Scene) orelse lib_boss:is_in_abyss_boss(Scene) orelse
			lib_boss:is_in_fairy_boss(Scene) orelse lib_boss:is_in_new_outside_boss(Scene),
            if
                ExpireTime < NowTime -> {fail, ?ERRCODE(err150_no_drop)}; %% 已过期
                Scene =/= Ps#player_status.scene -> {fail, ?ERRCODE(err150_notin_drop_scene)}; %% 不同场景
                CopyId =/= Ps#player_status.copy_id -> {fail, ?ERRCODE(err150_not_drop_copyid)}; %% 不同房间
                Ps#player_status.battle_attr#battle_attr.hp =< 0 andalso not IsNoCheckHp ->
                    {fail, ?ERRCODE(err150_drop_no_hp)}; %% 没有血量
                PlayerId > 0 andalso PlayerId =/= Ps#player_status.id andalso (ExpireTime - NowTime) > ?DROP_SAVE_TIME -> %% 在保护时间中
                    {fail, ?ERRCODE(err150_no_drop_per)};
                TeamId > 0 andalso TeamId =/= Ps#player_status.team#status_team.team_id andalso (ExpireTime - NowTime > ?DROP_SAVE_TIME) ->
                    if
                        IsNoNeedHurt ->
                            {ok, DropInfo};
                        true ->
                            %% 玩家退出队伍后，没有队伍，但是在伤害归属列表里面
                            case lists:keyfind(Ps#player_status.id, #mon_atter.id, HurtList) of
                                false ->
                                    case ?IS_DROP_BOSS(BossType) of
                                        true -> {fail, ?ERRCODE(err150_no_hurt_drop)}; %% 没有在伤害列表中
                                        false -> {fail, ?ERRCODE(err150_no_drop_per)} %%
                                    end;
                                _ -> {ok, DropInfo}
                            end
                    end;
                true ->
                    InDun = lib_dungeon:is_on_dungeon(Ps),
                    DropBoss = ?IS_DROP_BOSS(BossType),
                    if
                        not DropBoss orelse InDun -> {ok, DropInfo}; %% 普通怪物|在副本
                        true ->
                            {IsOverLv, ErrCode} = check_boss_lv(Scene, MonId, BossLv, Ps#player_status.figure#figure.lv),
                            HaveHurt = lists:keyfind(Ps#player_status.id, #mon_atter.id, HurtList),
                            IsBossTired = lib_battle_util:check_boss_tired(Scene, MonId, #scene_boss_tired{tired = Ps#player_status.boss_tired}, VipType, Vip),
                            if
                                IsOverLv andalso (TeamId > 0 andalso TeamId == Ps#player_status.team#status_team.team_id)==false andalso PlayerId =/= Ps#ps_args.role_id -> {fail, ErrCode}; %% 超过掉落包的拾取等级
                                %% boss疲劳值满,没有伤害, 第三次也是满的,但是造成过伤害可以拾取
                                IsBossTired andalso HaveHurt == false -> {fail, ?ERRCODE(err150_no_drop_boss_tired)};
                                ExpireTime - NowTime < ?DROP_SAVE_TIME -> {ok, DropInfo}; %%
                                HaveHurt == false andalso not IsNoNeedHurt -> {fail, ?ERRCODE(err150_no_hurt_drop)};
                                true -> {ok, DropInfo}
                            end
                    end
            end;
        _ ->
            {fail, ?ERRCODE(err150_no_drop)}
    end.

%%-----------------------------------------------------
%% 检查拆分物品
%% @param GoodsNum ::integer() 要拆分的数量
%%-----------------------------------------------------
check_split(GoodsStatus, GoodsId, GoodsNum) ->
    case check_goods_normal(GoodsStatus, GoodsId) of
        {ok, GoodsInfo} ->
            if
                %% 物品数量不正确
                GoodsNum < 1 ->
                    {fail, ?ERRCODE(err150_num_err)};
                GoodsInfo#goods.num =< GoodsNum ->
                    {fail, ?ERRCODE(err150_num_err)};
                true ->
                    NullCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, GoodsInfo#goods.bag_location),
                    if
                        %% 背包格子不足
                        NullCellNum =:= 0 ->
                            {fail, ?ERRCODE(err150_no_cell)};
                        true ->
                            {ok, GoodsInfo}
                    end
            end;
        ErrorRes ->
            ErrorRes
    end.

list_handle(_F, Data, []) -> {ok, Data};
list_handle(F, Data, [H|T]) ->
    case F(H, Data) of
        {ok, Data2} ->
            list_handle(F, Data2, T);
        Error ->
            Error
    end.

%%检查NPC
check_npc(PlayerStatus, ShopType, Type) ->
    Vip = PlayerStatus#player_status.vip,
    %%商店类型 - 商城
    if
        %% 35级以下不判断
        PlayerStatus#player_status.figure#figure.lv =< 35 ->
            true;
        Type =:= pay andalso (ShopType =:= ?SHOP_TYPE_GOLD orelse ShopType =:= ?SHOP_TYPE_SIEGE_SHOP2) ->
           true;
       %%商店类型 - VIP药店
        ShopType =:= ?SHOP_TYPE_VIP_DRUG andalso Vip#role_vip.vip_lv >= 0 ->
            true;
       %%商店类型 - VIP仓库
        ShopType =:= ?SHOP_TYPE_VIP_STORAGE andalso Vip#role_vip.vip_lv > 0 ->
            true;
        %%炼化NPC
        ShopType =:= ?SHOP_TYPE_FORGE ->
            true;
        %% 竞技场兑换NPC  战功兑换NPC  荣誉兑换NPC
        Type =:= exchange andalso (ShopType =:= ?SHOP_TYPE_ARENA orelse ShopType =:= ?SHOP_TYPE_BATTLE orelse ShopType =:= ?SHOP_TYPE_HOUNOR) ->
            true;
        true ->
            lib_npc:is_near_npc(ShopType, PlayerStatus#player_status.scene, PlayerStatus#player_status.x, PlayerStatus#player_status.y)
    end.

%%-------------------------------------------------------------------------
%% @doc 检查buff使用场景限制
%% -spec check_use_buff(PlayerStatus, GoodsInfo, GoodsNum) -> {ok, GoodsInfo, {}} | {fail, ?ERRCODE} when
%% PlayerStatus     ::          #player_status{}    玩家记录
%% GoodsInfo        ::          #goods{}            物品记录
%% @end
%%--------------------------------------------------------------------------
check_use_buff(PlayerStatus, GoodsInfo, GoodsNum) ->
    case data_goods_type:get(GoodsInfo#goods.goods_id) of
        [] ->
            {fail, ?ERRCODE(err150_no_goods)};
        _GoodsTypeInfo ->
            case data_goods_effect:get(GoodsInfo#goods.goods_id) of
                [] ->
                    {fail, ?ERRCODE(err150_type_err)};
                #goods_effect{
                    limit_type = LimitType,
                    counter_module = CounterModule, counter_id = CounterId} ->
                    case lib_goods_util:check_lessthan_limit(PlayerStatus#player_status.id, CounterModule, CounterId, LimitType, GoodsNum) of
                        true ->
                            {ok, GoodsInfo, {}};
                        false ->
                            {fail, ?ERRCODE(err150_num_over)}
                    end;
                _->
                    {ok, GoodsInfo, {}}
            end
    end.

check_goods_exchange(PlayerStatus, ExchangeRuleId, ExchangeTimes) ->
    ExchangeRule = data_exchange:get(ExchangeRuleId),
    if
        is_record(ExchangeRule, goods_exchange_cfg) =:= false ->
            {fail, ?ERRCODE(err150_no_rule)};                         %% 规则不存在
        true ->
            #goods_exchange_cfg{
                id = RuleId,
                role_lv = NeedRoleLv,
                lim_type = LimType,
                module = ModuleId,
                sub_module = SubModuleId,
                condition = Condition,
                cost_list = CostList,
                obtain_list = ObtainList
            } = ExchangeRule,
            #player_status{id = RoleId, figure = Figure} = PlayerStatus,
            IsSatisfiedCondition = lib_goods_exchange:check_condition(Condition, PlayerStatus),
            IsLimitTimes = lib_goods_exchange:check_times_limit(LimType, RoleId, RuleId, ModuleId, SubModuleId, ExchangeTimes),
            if
                Figure#figure.lv < NeedRoleLv ->
                    {fail, ?ERRCODE(err150_rule_unactive)};
                IsSatisfiedCondition =/= true ->
                    {fail, ?ERRCODE(err150_require_err)};  %% 未到达兑换条件
                IsLimitTimes == false ->
                    {fail, ?ERRCODE(err150_num_limit)};  %% 兑换次数不足
                true ->
                    case lib_goods_exchange:check_rule_is_vaild(ExchangeRule) of
                        true ->
                            RealCostList = lib_goods_util:goods_object_multiply_by(CostList, ExchangeTimes),
                            case lib_goods_api:check_object_list(PlayerStatus, RealCostList) of
                                true ->
                                    RealObtainList = lib_goods_util:goods_object_multiply_by(ObtainList, ExchangeTimes),
                                    case lib_goods_api:can_give_goods(PlayerStatus, RealObtainList) of
                                        true ->
                                            {ok, ExchangeRule, RealCostList, RealObtainList};
                                        {false, ErrorCode} ->
                                            {fail, ErrorCode}
                                    end;
                                {false, ErrorCode} ->
                                    {fail, ErrorCode}
                            end;
                        false ->
                            {fail, ?ERRCODE(err150_rule_unactive)}
                    end
            end
    end.

check_near_npc(PlayerStatus, NpcTypeId, NpcId, Type) ->
    Vip = PlayerStatus#player_status.vip,
    if  Type =:= pay andalso NpcTypeId =:= ?SHOP_TYPE_GOLD -> ok;
        Type =:= sell andalso NpcTypeId =:= ?SHOP_TYPE_VIP_DRUG andalso Vip#role_vip.vip_lv > 0 -> ok;
        Type =:= pay andalso NpcTypeId =:= ?SHOP_TYPE_VIP_DRUG andalso Vip#role_vip.vip_lv > 0 -> ok;
        Type =:= move andalso NpcTypeId =:= ?SHOP_TYPE_VIP_STORAGE andalso Vip#role_vip.vip_lv > 0 -> ok;
        Type =:= exchange andalso (NpcTypeId =:= ?SHOP_TYPE_ARENA orelse NpcTypeId =:= ?SHOP_TYPE_BATTLE orelse NpcTypeId =:= ?SHOP_TYPE_HOUNOR orelse NpcTypeId =:= 30063 orelse NpcTypeId =:= 30066 orelse NpcTypeId =:= 20108 orelse NpcTypeId =:= 30082 orelse NpcTypeId =:= 30095 orelse NpcTypeId =:= ?SHOP_TYPE_KING_HOUNOR) -> ok;
        true -> lib_npc:check_npc(NpcId, NpcTypeId, PlayerStatus#player_status.scene, PlayerStatus#player_status.x, PlayerStatus#player_status.y)
    end.

%% 出售物品
check_sell(PlayerStatus, _NpcId, GoodsList, GoodsStatus) ->
    %% 物品列表一个个检查
    case list_handle(fun check_sells/2, [PlayerStatus#player_status.id, [], [], GoodsStatus], GoodsList) of
        {fail, Res} ->
            {fail, Res};
        {ok, [_, MoneyList, NewGoodsList, _]} ->
            {ok, lib_goods_api:make_reward_unique(MoneyList), NewGoodsList}
    end.

check_sells({GoodsId, GoodsNum}, [PlayerId, MoneyList, GoodsList, GoodsStatus]) ->
    % NowTime   = utime:unixtime(),
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    %IsSellForce = check_sell_force(GoodsInfo),
    case check_goods_normal(GoodsStatus, GoodsId) of
        {ok, GoodsInfo} ->
            if
            %% 物品不可出售
                GoodsInfo#goods.sell =:= 0 ->
                    {fail, ?ERRCODE(err150_not_sell)};
                %% 物品不在对应的背包 出售限制物品背包
                GoodsInfo#goods.location =/= ?GOODS_LOC_BAG ->
                    {fail, ?ERRCODE(err150_location_err)};
                %% 物品数量不足
                GoodsNum < 1 orelse GoodsInfo#goods.num < GoodsNum ->
                    {fail, ?ERRCODE(err150_num_err)};
                % %% 物品已过有效期 物品出售不检查有效期 by Czc 2018/4/23
                % GoodsInfo#goods.subtype =/= ?EQUIP_ANGLE_DEVIL andalso
                % GoodsInfo#goods.expire_time > 0 andalso GoodsInfo#goods.expire_time =< NowTime ->
                %     {fail, ?ERRCODE(err150_goods_expired)};
                true ->
                    {PriceType, SellPrice} = data_goods:get_goods_sell_price(GoodsInfo#goods.goods_id),
                    NewMoneyList = calc_sell_money(PriceType, SellPrice, GoodsNum, MoneyList),
                    {ok, [PlayerId, NewMoneyList, [{GoodsInfo,GoodsNum}|GoodsList], GoodsStatus]}
            end;
        ErrorRes ->
            ErrorRes
    end.

check_sell_force(GoodsInfo) ->
    case GoodsInfo of
        #goods{type = _Type, subtype = _SubType} ->
            true;
        _ -> false
    end.

calc_sell_money(PriceType, Price, GoodsNum, List) ->
    {MomeyType, MoneyId} = case PriceType of
                    ?TYPE_COIN  -> {?TYPE_COIN, 0};
                    ?TYPE_BGOLD -> {?TYPE_BGOLD, 0};
                    ?TYPE_GOLD -> {?TYPE_GOLD, 0};
                    ?GOODS_ID_DEMONS_COIN -> {?TYPE_CURRENCY, ?GOODS_ID_DEMONS_COIN};
                    _ -> none
                end,
    SellMoney = round(Price*GoodsNum),
    case MomeyType =/=none of
        true -> [{MomeyType, MoneyId, SellMoney}|List];
        _ -> List
    end.

check_movein_guild(GoodsStatus, GuildId, GuildMaxNum, GoodsId, GoodsNum) ->
    case check_goods_normal(GoodsStatus, GoodsId) of
        {ok, GoodsInfo} ->
            if
                %% 物品数量不正确
                GoodsNum < 1 orelse GoodsInfo#goods.num < GoodsNum ->
                    {fail, 5};
                %% 物品不在背包
                GoodsInfo#goods.location =/= ?GOODS_LOC_BAG ->
                    {fail, ?ERRCODE(err150_location_err)};
                %% 绑定物品不可放入
                GoodsInfo#goods.bind =:= ?BIND ->
                    {fail, 6};
                GoodsInfo#goods.bind =/= ?UNBIND ->
                    {fail, ?ERRCODE(err150_require_err)};
                true ->
                    GoodsTypeId = GoodsInfo#goods.goods_id,
                    case data_goods_type:get(GoodsTypeId) of
                        %% 物品类型不存在
                        [] ->
                            {fail, 2};
                        GoodsTypeInfo ->
                            TotalNum = lib_storage_util:get_storage_count(GoodsStatus#goods_status.player_id, GuildId),
                            TypeNum = lib_storage_util:get_storage_type_count(GoodsStatus#goods_status.player_id, GuildId, GoodsTypeId, GoodsInfo#goods.bind),
                            CellNum = lib_storage_util:get_null_storage_num(TypeNum, GoodsNum, GoodsTypeInfo#ets_goods_type.max_overlap),
                            if
                                %% 帮派仓库格子不足
                                GuildMaxNum < (TotalNum + CellNum) ->
                                    {fail, 7};
                                true ->
                                    NewGoodsInfo = GoodsInfo#goods{ player_id=0, guild_id=GuildId },
                                    {ok, NewGoodsInfo, GoodsTypeInfo}
                            end
                    end
            end;
        ErrorRes ->
            ErrorRes
    end.

check_moveout_guild(GoodsStatus, GuildId, GoodsId, GoodsNum) ->
    GoodsInfo = lib_goods_util:get_goods_by_id(GoodsId),
    if  %% 物品不存在
        is_record(GoodsInfo, goods) =:= false ->
            {fail, 2};
        %% 物品不属于你所有
        GoodsInfo#goods.guild_id =/= GuildId ->
            {fail, 3};
        %% 物品不在仓库
        GoodsInfo#goods.location =/= ?GOODS_LOC_GUILD ->
            {fail, 4};
        %% 物品数量不正确
        GoodsNum < 1 orelse GoodsInfo#goods.num < GoodsNum ->
            {fail, 5};
        true ->
            GoodsTypeId = GoodsInfo#goods.goods_id,
            case data_goods_type:get(GoodsTypeId) of
                %% 物品类型不存在
                [] ->
                    {fail, 2};
                GoodsTypeInfo ->
                    TypeList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsInfo#goods.goods_id, 1,
                                                                  GoodsInfo#goods.bag_location, GoodsStatus#goods_status.dict),
                    GoodsTypeList = lib_goods_util:sort(TypeList, cell),
                    {ok, GoodsInfo, GoodsTypeInfo, GoodsTypeList}
            end
    end.

check_delete_guild(GuildId, GoodsId) ->
    GoodsInfo = lib_goods_util:get_goods_by_id(GoodsId),
    if
        %% 物品不存在
        is_record(GoodsInfo, goods) =:= false ->
            {fail, 2};
        %% 物品不属于帮派所有
        GoodsInfo#goods.guild_id =/= GuildId ->
            {fail, 3};
        %% 物品不在帮派仓库
        GoodsInfo#goods.location =/= ?GOODS_LOC_GUILD ->
            {fail, 4};
        %% 物品不可丢弃
        GoodsInfo#goods.isdrop =:= 1 ->
            {fail, 5};
        true ->
            {ok, GoodsInfo, GoodsInfo#goods.num}
    end.

check_extend_guild(PlayerStatus, GuildLevel, GoodsStatus) ->
    [GoldNum, GoodsNum] = data_goods:get_extend_guild(GuildLevel),
    if
        %% 帮派仓库已达上限
        GuildLevel >= ?GOODS_GUILD_MAX_LEVEL ->
            {fail, 2};
        %% 铜钱不足
        (PlayerStatus#player_status.coin) < GoldNum ->
            {fail, 3};
        true ->
            case data_goods_type:get(?GOODS_GUILD_EXTEND_MATERIAL) of
                %% 物品类型不存在
                [] ->
                    {fail, 2};
                GoodsTypeInfo ->
                    GoodsTypeList = lib_goods_util:get_type_goods_list(PlayerStatus#player_status.id, ?GOODS_GUILD_EXTEND_MATERIAL,
                                                                       GoodsTypeInfo#ets_goods_type.bag_location, GoodsStatus#goods_status.dict),
                    TotalNum = lib_goods_util:get_goods_totalnum(GoodsTypeList),
                    if
                        %% 建设卡数量不足
                        TotalNum < GoodsNum ->
                            {fail, 4};
                        true ->
                            {ok, GoldNum, GoodsNum, GoodsTypeList}
                    end
            end
    end.

%% 扩展背包 (只能扩展神器背包，神器保护箱)
check_expand_bag(PlayerStatus, GoodsStatus, Pos, CellNum) ->
    #player_status{id = _RoleId, gold = _Gold} = PlayerStatus,
    if
        CellNum =< 0 ->
            {fail, ?ERRCODE(data_error)};
        Pos =/= ?GOODS_LOC_BAG andalso Pos =/= ?GOODS_LOC_STORAGE ->
            {fail, ?ERRCODE(data_error)};
        % CellNum rem 5 =/= 0 ->
        %     {fail, ?ERRCODE(data_error)};
        true ->
            #goods_status{num_cells = NumCells} = GoodsStatus,
            case maps:get(Pos, NumCells, false) of
                {_UseNum, MaxNum} ->
                    case Pos of
                        ?GOODS_LOC_BAG -> DefMaxNum = ?GOODS_BAG_MAX_NUM;
                        ?GOODS_LOC_STORAGE -> DefMaxNum = ?GOODS_STORAGE_MAX_NUM
                    end,
                    case MaxNum + CellNum > DefMaxNum of
                        false ->
                            GoodsCost = [{?TYPE_GOODS, ?GOODS_BAG_EXTEND_GOODS, CellNum*?GOODS_BAG_EXTEND_GOODS_NUM}],
                            NewMaxNum = MaxNum + CellNum,
                            {ok, GoodsCost, NewMaxNum};
                        _ ->
                            {fail, ?FAIL}
                    end;
                _ ->
                    {fail, ?FAIL}
            end
    end.

%% 不传目标背包默认移动到初始背包
check_move_a2b(GoodsStatus, GoodsId, FromLoc, MoveNum) ->
    case lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict) of
        #goods{goods_id = GoodsTypeId} ->
            case data_goods_type:get(GoodsTypeId) of
                #ets_goods_type{bag_location = ToLoc} when FromLoc =/= ToLoc ->
                    check_move_a2b(GoodsStatus, GoodsId, FromLoc, ToLoc, MoveNum);
                _ ->
                    {fail, ?FAIL}
            end;
        _ ->
            {fail, ?ERRCODE(err150_no_goods)}
    end.

check_move_a2b(GoodsStatus, GoodsId, FromLoc, ToLoc, MoveNum)->
    IsAble = check_move_a2b_type(FromLoc, ToLoc),
    if  %% 位置错误
        IsAble =:= false ->
            {fail, ?ERRCODE(err150_location_err)};
        true ->
            do_check_move_a2b(GoodsId, GoodsStatus, FromLoc, MoveNum)
    end.

do_check_move_a2b(GoodsId, GoodsStatus, FromLoc, MoveNum) ->
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    if  %% 物品不存在
        is_record(GoodsInfo, goods) =:= false ->
            {fail, ?ERRCODE(err150_no_goods)};
        %% 物品不属于你所有
        GoodsInfo#goods.player_id =/= GoodsStatus#goods_status.player_id ->
            {fail, ?ERRCODE(err150_palyer_err)};
        GoodsInfo#goods.location =/= FromLoc ->
            {fail, ?ERRCODE(err150_location_err)};
        MoveNum =/= all andalso GoodsInfo#goods.num < MoveNum ->
            {fail, ?ERRCODE(goods_not_enough)};
        true ->
            case MoveNum of
                all ->
                    RealMoveNum = GoodsInfo#goods.num;
                _ ->
                    RealMoveNum = MoveNum
            end,
            case lib_goods:can_give_goods(GoodsStatus, [{?TYPE_GOODS, GoodsInfo#goods.goods_id, RealMoveNum, GoodsInfo#goods.bind}]) of
                true ->
                    {ok, GoodsInfo, RealMoveNum};
                {false, ErrorCode} ->
                    {fail, ErrorCode}
            end
    end.

check_move_a2b_type(FromLoc, ToLoc) ->
    %% 允许移动的类型列表, 只能在背包之间转移物品
    AbleMoveTypes = [
    ],
    case lists:member(FromLoc, ?GOODS_LOC_BAG_TYPES) of
        true ->
            case lists:member(ToLoc, ?GOODS_LOC_BAG_TYPES) of
                true ->
                    lists:member({FromLoc, ToLoc}, AbleMoveTypes);
                _ -> false
            end;
        _ -> false
    end.

%% 物品续费
check_goods_renew(PlayerStatus, GoodsStatus, GoodsId)->
    case check_goods_normal(GoodsStatus, GoodsId) of
        {ok, #goods{goods_id = GoodsTypeId, expire_time = ExpireTime} = GoodsInfo} ->
            NowTime = utime:unixtime(),
            if
                NowTime < ExpireTime -> {fail, ?ERRCODE(err150_good_in_expire)};
                true ->
                    case data_goods_effect:get(GoodsTypeId) of
                        #goods_effect{effect_list = EffLists} ->
                            case lists:keyfind(renew_day, 1, EffLists) of
                                false -> {fail, ?ERRCODE(good_renew_cf_miss)};
                                {_, RenewTime} ->
                                    case check_goods_buy_price(PlayerStatus, GoodsTypeId) of
                                        {ok, PriceType, Price} -> {ok, GoodsInfo, PriceType, Price, RenewTime};
                                        ErrorRes -> ErrorRes
                                    end
                            end;
                        _ -> {fail, ?ERRCODE(good_renew_cf_miss)}
                    end
            end;
        ErrorRes -> ErrorRes
    end.

% 暂时只允许背包仓库互移
check_good_change_pos(PlayerStatus, GoodsStatus, GoodsId, FromPos, ToPos) ->
    #player_status{id = PlayerId} = PlayerStatus,
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    if  %% 物品不存在
        is_record(GoodsInfo, goods) =:= false ->
            {false, ?ERRCODE(err150_no_goods)};
        %% 物品不属于你所有
        GoodsInfo#goods.player_id =/= GoodsStatus#goods_status.player_id ->
            {false, ?ERRCODE(err150_palyer_err)};
        true ->
            #goods{bind = Bind, num = GoodsNum} = GoodsInfo,
            #ets_goods_type{goods_id = GoodsTypeId, max_overlap = MaxNum, can_storge = CanStorge} = data_goods_type:get(GoodsInfo#goods.goods_id),
            CanChangePos = check_change_location(GoodsStatus, GoodsInfo, FromPos, ToPos),
            NullCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, ToPos),
            GoodsList = lib_goods_util:get_type_goods_list(PlayerId, GoodsTypeId, Bind, ToPos, GoodsStatus#goods_status.dict),
            NeedCells = lib_storage_util:get_null_cell_num(GoodsList, GoodsInfo, MaxNum, GoodsNum),
            if
                ToPos == ?GOODS_LOC_STORAGE andalso CanStorge == 0 -> {false, ?ERRCODE(err150_can_not_storge)};
                CanChangePos =/= true -> CanChangePos;
                NeedCells > NullCellNum -> {false, data_goods:get_no_cell_errcode(ToPos)};
                true ->
                    {ok, GoodsInfo}
            end
    end.

check_change_location(_GoodsStatus, GoodsInfo, FromPos, ToPos) ->
    ChangeLocLimitList = [
        %% {from, to}
        {?GOODS_LOC_TREASURE, ?GOODS_LOC_BAG}
        , {?GOODS_LOC_TREASURE, ?GOODS_LOC_RUNE_BAG}
        , {?GOODS_LOC_TREASURE, ?GOODS_LOC_EUDEMONS_BAG}
        , {?GOODS_LOC_BAG, ?GOODS_LOC_STORAGE}
        , {?GOODS_LOC_STORAGE, ?GOODS_LOC_BAG}
    ],
    #goods{goods_id = GoodsTypeId, location = Location} = GoodsInfo,
    EtsGoodsType = data_goods_type:get(GoodsTypeId),
    FromPosRes = lists:member({FromPos, ToPos}, ChangeLocLimitList),
    %HadCell = lib_goods_util:bag_had_cell_num(GoodsStatus#goods_status.num_cells, ToPos),
    if
        EtsGoodsType == [] -> {false, ?ERRCODE(err150_no_goods)};
        Location =/= FromPos orelse Location == ToPos -> {false, ?ERRCODE(err150_location_err)};
        FromPosRes == false -> {false, ?ERRCODE(err150_location_err)};
        %HadCell /= true -> {false, data_goods:get_no_cell_errcode(ToPos)};
        true ->
            true
    end.

% 神装背包和保护箱互移
check_good_change_sub_pos(_PlayerStatus, _GoodsStatus, _GoodsId)->{fail, ?FAIL}.
    % GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    % if  %% 物品不存在
    %     is_record(GoodsInfo, goods) =:= false ->
    %         {fail, ?ERRCODE(err150_no_goods)};
    %     %% 物品不属于你所有
    %     GoodsInfo#goods.player_id =/= GoodsStatus#goods_status.player_id ->
    %         {fail, ?ERRCODE(err150_palyer_err)};
    %     GoodsInfo#goods.type =/= ?GOODS_TYPE_EQUIP orelse GoodsInfo#goods.location =/= ?GOODS_LOC_GOD_EQUIP_BAG -> %% 只有神装背包的装备能改子位置
    %         {fail, ?ERRCODE(err150_not_god_equip)};
    %     true ->
    %         case GoodsInfo#goods.sub_location == ?GOODS_SUB_LOC_GOD_EQUIP_BAG of
    %             true -> %% 从保护箱移到背包
    %                 {ok, GoodsInfo, 0};
    %             _ ->
    %                 ExistList = lib_goods_util:get_list_by_sub_location(?GOODS_LOC_GOD_EQUIP_BAG, ?GOODS_SUB_LOC_GOD_EQUIP_BAG, GoodsStatus#goods_status.dict),
    %                 ProtLimit = data_goods:get_god_bag_prot_limit(PlayerStatus),
    %                 case length(ExistList) >= ProtLimit of
    %                     true -> {fail, ?ERRCODE(err150_god_bag_prot_limit)};
    %                     _ ->
    %                         {ok, GoodsInfo, ?GOODS_SUB_LOC_GOD_EQUIP_BAG}
    %                 end
    %         end
    % end.

%% 检查物品的购买价格+以及是够有足够的钱购买
check_goods_buy_price(Ps, GoodsTypeId)->
    case data_goods:get_goods_buy_price(GoodsTypeId) of
        {0, 0} -> %% 物品价格配置不存在
            {fail, ?ERRCODE(err150_price_err)};
        {PriceType, Price} ->
            case data_goods:get_price_type_to_right(PriceType) of
                none -> {fail, ?ERRCODE(err150_price_err)};
                RightType ->
                    case lib_goods_util:is_enough_money(Ps, Price, RightType) of
                        false -> {fail, ?ERRCODE(err150_price_err)};
                        true -> {ok, RightType, Price}
                    end
            end
    end.

%% ---------------------------------------------------------------------------
%% @doc 检查增加的物品列表中 GoodTypeId 是否有重复的
-spec check_give_list(GoodsList) -> {ok, List} | {false, duplicate} when
    GoodsList :: [{GoodTypeId, GoodsNum}] | [{goods, GoodTypeId, GoodsNum}]
    | [{goods, GoodTypeId, GoodsNum, Bind}] |
    [{equip, GoodsTypeId, Prefix, Stren}] | [{info, GoodsInfo}]
    | [{goods, GoodsTypeId, GoodsNum, Prefix, Stren, Bind}]
    | [{?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum}]
    | [{?TYPE_GOODS, GoodsTypeId, GoodsNum}]
    | [{goods_attr, GoodsTypeId, GoodsNum, AttrList}],
    GoodTypeId :: integer(),
    GoodsNum :: integer(),
    Bind :: integer(),
    Prefix :: integer(),
    Stren :: integer(),
    GoodsInfo :: #goods{},
    AttrList :: list(),
    List :: list().
%% ---------------------------------------------------------------------------
check_give_list(GoodsList) ->
    check_give_list(GoodsList, []).

check_give_list([], GoodTypeIdL) -> {ok, GoodTypeIdL};
check_give_list([OneGoods | T], GoodsTypeIdL) ->
    GoodsTypeId = case OneGoods of
                      {goods_other, GTypeId, _, _Stren, _Exp} -> GTypeId;
                      {goods, GTypeId, _} -> GTypeId;
                      {goods_attr, GTypeId, _, _} -> GTypeId;
                      {goods, GTypeId, _GoodsNum, _Bind} -> GTypeId;
                      {equip, GTypeId, _Prefix, _Stren} -> GTypeId;
                      {info, GoodsInfo} -> GoodsInfo#goods.goods_id;
                      {goods, GTypeId, _GoodsNum, _Prefix, _Stren, _Bind} -> GTypeId;
                      {?TYPE_BIND_GOODS, GTypeId, _} -> GTypeId;
                      {?TYPE_GOODS, GTypeId, _} -> GTypeId;
                      {GTypeId, _GoodsNum} when is_integer(GTypeId) -> GTypeId;
                      _ -> 0
                  end,
    case GoodsTypeId of
        0 ->
            {false, duplicate};
        _ ->
            case lists:member(GoodsTypeId, GoodsTypeIdL) of
                true ->
                    {false, duplicate};
                false ->
                    NewGoodTypeIdL = [GoodsTypeId | GoodsTypeIdL],
                    check_give_list(T, NewGoodTypeIdL)
            end
    end.

%% 检测发物品到指定背包
check_give_to_specify_loc(Location, GoodsList) ->
    case lists:member(Location, ?GOODS_LOC_BAG_TYPES) of
        true ->
            do_check_give_to_specify_loc(GoodsList, []);
        false ->
            {false, ?ERRCODE(err150_bag_location_fail)}
    end.

do_check_give_to_specify_loc([], _GoodTypeIdL) -> ok;
do_check_give_to_specify_loc([OneGoods|L], GoodsTypeIdL) ->
    GoodsTypeId = case OneGoods of
        {location, _Loc, GTypeId, _} -> GTypeId;
        _ -> 0
    end,
    case GoodsTypeId of
        0 ->
            {false, duplicate};
        _ ->
            case lists:member(GoodsTypeId, GoodsTypeIdL) of
                true ->
                    {false, duplicate};
                false ->
                    do_check_give_to_specify_loc(L, [GoodsTypeId|GoodsTypeIdL])
            end
    end.

%% ---------------------------------------------------------------------------
%% @doc 合并物品列表(GoodsTypeId相同的项 GoodsNum值相加)
-spec combine_goods_num_list(GoodsList) -> NewGoodsList when
    GoodsList   :: [{GoodTypeId, GoodsNum}],
    NewGoodsList:: [{GoodTypeId, GoodsNum}],
    GoodTypeId  :: integer(),
    GoodsNum    :: integer().
%% ---------------------------------------------------------------------------
combine_goods_num_list(GoodsList) ->
    ulists:kv_list_plus_extra([[], GoodsList]).

%%--------------------------------------------------
%% 检测物品分解
%% @param  GoodsList    [{GoodsId, Num}]
%% @return              {ok, GoodsInfo}|{fail, ErrorCode}
%%--------------------------------------------------
check_goods_decompose(PlayerStatus, GoodsStatus, GoodsList) ->
    CombineGoodsList = combine_goods_num_list(GoodsList),
    case do_check_goods_decompose(GoodsStatus, CombineGoodsList, []) of
        {ok, GoodsInfoNumList} ->
            case count_decompose_reward(PlayerStatus, GoodsInfoNumList, []) of
                {ok, DecomposeRewardList} ->
                    {ok, DecomposeRewardList};
                {fail, ErrorCode} -> {fail, ErrorCode}
            end;
        {fail, ErrorCode} -> {fail, ErrorCode}
    end.

do_check_goods_decompose(_GoodsStatus, [], Acc) -> {ok, Acc};
do_check_goods_decompose(GoodsStatus, [{GoodsId, GoodsNum}|L], Acc) ->
    case check_goods_normal(GoodsStatus, GoodsId) of
        {ok, GoodsInfo} ->
            #goods{num = OwnNum} = GoodsInfo,
            case OwnNum >= GoodsNum of
                true ->
                    case do_check_goods_decompose_other(GoodsInfo) of
                        true ->
                            do_check_goods_decompose(GoodsStatus, L, [{GoodsInfo, GoodsNum}|Acc]);
                        {fail, ErrorCode} -> {fail, ErrorCode}
                    end;
                false ->
                    {fail, ?ERRCODE(goods_not_enough)}
            end;
        {fail, ErrorCode} -> {fail, ErrorCode}
    end.

do_check_goods_decompose_other(#goods{type = ?GOODS_TYPE_FASHION} = GoodsInfo) ->
    lib_fashion:check_fashion_goods(GoodsInfo);

do_check_goods_decompose_other(#goods{type = ?GOODS_TYPE_SEAL, location = ?GOODS_LOC_SEAL_EQUIP}) ->
    {fail, ?ERRCODE(err150_decompose_wear)};

do_check_goods_decompose_other(#goods{type = ?GOODS_TYPE_EQUIP, location = ?GOODS_LOC_EQUIP}) ->
    {fail, ?ERRCODE(err150_decompose_wear)};

do_check_goods_decompose_other(#goods{type = ?GOODS_TYPE_DRACONIC, location = ?GOODS_LOC_DRACONIC_EQUIP}) ->
    {fail, ?ERRCODE(err150_decompose_wear)};

do_check_goods_decompose_other(#goods{type = ?GOODS_TYPE_SOUL} = GoodsInfo) ->
    lib_soul:check_goods_decompose_other(GoodsInfo);

do_check_goods_decompose_other(#goods{type = ?GOODS_TYPE_RUNE} = GoodsInfo) ->
    lib_rune:check_goods_decompose_other(GoodsInfo);

do_check_goods_decompose_other(_GoodsInfo) ->
    true.

count_decompose_reward(_PlayerStatus, [], AccList) -> {ok, AccList};
count_decompose_reward(PlayerStatus, [{GoodsInfo, GoodsNum} | L], AccList) ->
    #goods{goods_id = GTypeId} = GoodsInfo,
    case data_goods_decompose:get(GTypeId) of
        #goods_decompose_cfg{
            module = Module,
            irregular_num = IrregularNum,
            irregular_mat = IrregularMat,
            regular_mat = RegularMat
        } ->
            {NewRegularMat, NewIrregularMat} = count_decompose_rule(PlayerStatus, Module, GoodsInfo, RegularMat, IrregularMat),
            F = fun(_, Acc) ->
                TmpSubList = urand:get_rand_list_repeat(IrregularNum, NewIrregularMat),
                TmpSubList ++ Acc
            end,
            GiveIrregularMat = lists:foldl(F, [], lists:seq(1, GoodsNum)),
            GiveRegularMat = lib_goods_util:goods_object_multiply_by(NewRegularMat, GoodsNum),
            GiveExtraMat = count_decompose_reward_ex(GoodsInfo, GoodsNum),
            GiveList = GiveExtraMat ++ GiveRegularMat ++ GiveIrregularMat,
            %?PRINT("count_decompose_reward GiveIrregularMat:~p~n", [GiveIrregularMat]),
            %% 分解的物品是绑定的，分解得到的物品都转为绑定
            NGiveList = ?IF(GoodsInfo#goods.bind == ?BIND, lib_goods_util:goods_to_bind_goods(GiveList), GiveList),
            %?PRINT("count_decompose_reward NGiveList:~p~n", [NGiveList]),
            count_decompose_reward(PlayerStatus, L, NGiveList ++ AccList);
        _ -> {fail, ?ERRCODE(err_config)}
    end.

count_decompose_rule(_PlayerStatus, Module, GoodsInfo, RegularMat, IrregularMat) ->
    case Module of
        ?MOD_EQUIP ->
            %#player_status{figure = #figure{career = Career}} = PlayerStatus,
            #ets_goods_type{career = Career} = data_goods_type:get(GoodsInfo#goods.goods_id),
            Condition = ?IF(Career > 0, [{career, Career}], []),
            NewRegularMat = lib_goods_api:filter_goods(RegularMat, Condition),
            NewIrregularMat = lib_goods_api:filter_goods(IrregularMat, Condition),
            {NewRegularMat, NewIrregularMat};
        ?MOD_DECORATION ->
            NewRegularMat = count_decoration_mat(GoodsInfo, RegularMat),
            {NewRegularMat, IrregularMat};
        _ -> {RegularMat, IrregularMat}
    end.

count_decoration_mat(GoodsInfo, RegularMat) ->
    #goods{other = #goods_other{extra_attr = OldAttr}} = GoodsInfo,
    AllDecGoods = data_decoration:get_all_dec_goods(),
    F = fun({ObjectType, RGTypeId, RNum}, Tmp) ->
        case ObjectType == ?TYPE_GOODS andalso lists:member(RGTypeId, AllDecGoods) of
            true ->
                ExtraAttr = case data_decoration:get_dec_attr(RGTypeId) of
                                #dec_attr_cfg{color_attr = ColorAttr} ->
                                    NewColorAttr = lists:reverse(lists:keysort(1, ColorAttr)),
                                    AttrArgs = [{AttrNum, AttrVal} || {_Color, AttrNum, AttrVal} <- NewColorAttr],  %%先生成高品质的
                                    NewAttr = lib_equip_api:gen_equip_extra_attr(AttrArgs, OldAttr),
                                    NewAttr;
                                _ ->
                                    []
                            end,
                %?PRINT("count_decoration_mat  ExtraAttr:~p~n",[ExtraAttr]),
                [{?TYPE_ATTR_GOODS, RGTypeId, RNum, [{extra_attr, ExtraAttr}]} | Tmp];
            false ->
                [{ObjectType, RGTypeId, RNum} | Tmp]
        end
        end,
    lists:foldl(F, [], RegularMat).


%%--------------------------------------------------
%% 检测熔炼炼金
%% @param  GoodsList    [{GoodsId, Num}]
%% @return
%%--------------------------------------------------
check_goods_fusion(PlayerStatus, GoodsStatus, GoodsList) ->
    CombineGoodsList = combine_goods_num_list(GoodsList),
    case do_check_goods_fusion(GoodsStatus, CombineGoodsList, []) of
        {ok, GoodsInfoNumList} ->
            {TotalAddExp, ExpList} = count_fusion_exp_reward(PlayerStatus, GoodsInfoNumList),
            {ok, TotalAddExp, ExpList, GoodsInfoNumList};
        {fail, ErrorCode} -> {fail, ErrorCode}
    end.

%% 注意:离线挂机自动吞噬会调用
%% 修改筛选规则需要同步修改: (1)lib_onhook:onhook_auto_devour_equips/1;(2)lib_onhook:calc_auto_devour_equips/4
do_check_goods_fusion(_GoodsStatus, [], Acc) -> {ok, Acc};
do_check_goods_fusion(GoodsStatus, [{GoodsId, GoodsNum} | L], Acc) ->
    case check_goods_normal(GoodsStatus, GoodsId) of
        {ok, GoodsInfo} ->
            #goods{goods_id = GTypeId, num = OwnNum, type = _Type, location = Location} = GoodsInfo,
            case OwnNum >= GoodsNum of
                true ->
                    case Location == ?GOODS_LOC_BAG of
                        true ->
                            FusionExp = get_fusion_exp_by_goods(GoodsInfo),
                            case FusionExp > 0 of
                                true ->
                                    do_check_goods_fusion(GoodsStatus, L, [{GoodsInfo, GoodsNum} | Acc]);
                                _ ->
                                    ?INFO("check_goods_fusion missing_config ~p~n", [GTypeId]),
                                    do_check_goods_fusion(GoodsStatus, L, Acc)
                            end;
                        _ -> {fail, ?ERRCODE(err150_goods_cannt_fusion)}
                    end;
                false ->
                    {fail, ?ERRCODE(err150_no_fusion_equip)}
            end;
        {fail, ErrorCode} -> {fail, ErrorCode}
    end.

get_goods_fusion_exp(GoodsInfo) ->
    FusionExp = get_fusion_exp_by_goods(GoodsInfo),
    FusionExp.

count_fusion_exp_reward(PlayerStatus, GoodsInfoNumList) ->
    #player_status{figure = #figure{vip_type = VipType, vip = VipLv}} = PlayerStatus,
    VipRatio = lib_vip_api:get_vip_privilege(?MOD_GOODS, 3, VipType, VipLv),
    F = fun({GoodsInfo, GoodsNum}, {AccExp, ExpList}) ->
        #goods{goods_id = _GTypeId, location = _Location} = GoodsInfo,
        Ratio = 1,
        FusionExp = get_fusion_exp_by_goods(GoodsInfo) * GoodsNum,
        FusionExpAdd = FusionExp * (1 + VipRatio / 100),
        AddFusionExp = round(FusionExpAdd) * Ratio,
        NExpList = ExpList,%?IF(Ratio > 1, [{AddFusionExp, Ratio} | ExpList], ExpList),
        {AccExp + AddFusionExp, NExpList}
    end,
    lists:foldl(F, {0, []}, GoodsInfoNumList).
count_fusion_exp_reward_by_ids(PlayerStatus, GoodsNumList) ->
    #player_status{figure = #figure{vip_type = VipType, vip = VipLv}} = PlayerStatus,
    VipRatio = lib_vip_api:get_vip_privilege(?MOD_GOODS, 3, VipType, VipLv),
    F = fun({GoodsTypeId, GoodsNum}, {AccExp, ExpList}) ->
        Ratio = 1,
        FusionExp = get_fusion_exp_by_goods_type_id(GoodsTypeId) * GoodsNum,
        FusionExpAdd = FusionExp * (1 + VipRatio / 100),
        AddFusionExp = round(FusionExpAdd) * Ratio,
        NExpList =  [{AddFusionExp, Ratio} | ExpList],%?IF(Ratio > 1, [{AddFusionExp, Ratio} | ExpList], ExpList),
        {AccExp + AddFusionExp, NExpList}
    end,
    lists:foldl(F, {0, []}, GoodsNumList).

get_fusion_exp_by_goods(GoodsInfo) ->
    #goods{goods_id = GTypeId, type = _Type, other = _Others} = GoodsInfo,
    data_goods_decompose:get_fusion_exp_by_goods(GTypeId).
get_fusion_exp_by_goods_type_id(GTypeId) ->
    data_goods_decompose:get_fusion_exp_by_goods(GTypeId).

%%--------------------------------------------------
%% 计算分解的额外奖励
%% 符文需要返还额外的经验
%% 奖励格式[{type,id,num}]
%% @param  GoodsInfo #goods{}
%% @param  GoodsNum  分解的数量
%% @return           [{type,id,num}]
%%--------------------------------------------------
count_decompose_reward_ex(GoodsInfo, _GoodsNum) ->
    case GoodsInfo#goods.type of
        ?GOODS_TYPE_RUNE ->
            AddRunePoint = lib_rune:get_goods_rune_point(GoodsInfo),
            [{?TYPE_RUNE,   0,  AddRunePoint}]; %%和奖励找回保持一致， 用0就好
        ?GOODS_TYPE_SOUL ->
            AddSoulPoint = lib_soul:get_goods_soul_point(GoodsInfo),
            case AddSoulPoint == 0 of
                true -> [];
                false -> [{?TYPE_SOUL, ?GOODS_ID_SOUL, AddSoulPoint}]
            end;
        _ ->
            []
    end.

%% 检测合成配置
check_compose_cfg(RuleId, PlayerStatus, RegularGIdList, SpecifyGIdList) ->
    #player_status{figure = #figure{sex = Sex}} = PlayerStatus,
    ComposeCfg = data_goods_compose:get_cfg(RuleId),
    if
        is_record(ComposeCfg, goods_compose_cfg) =:= false ->
            {fail, ?ERRCODE(missing_config)};
        true ->
            #goods_compose_cfg{
                subtype = ComposeType,
                sex = SexLimit,
                regular_mat = RegularMat,
                irregular_mat = IrregularMat,
                cost = Cost,
                goods = GoodsList,
                ratio_type = RatioType,
                ratio = Ratio,
                bind_type = BindType
            } = ComposeCfg,
            if
                (IrregularMat =/= [] orelse ComposeType == ?COMPOSE_TYPE_IRREGULAR orelse
                ComposeType == ?COMPOSE_TYPE_MULTIPLE) andalso
                (RatioType =/= ?COMPOSE_RATIO_IRREGULAR orelse is_list(Ratio) == false) ->
                    {fail, ?ERRCODE(err_config)};
                ComposeType == ?COMPOSE_TYPE_REGULAR andalso
                (RegularMat == [] orelse RatioType =/= ?COMPOSE_RATIO_REGULAR orelse is_integer(Ratio) == false) ->
                    {fail, ?ERRCODE(err_config)};
                RegularMat == [] andalso IrregularMat == [] andalso Cost == [] -> {fail, ?ERRCODE(err_config)};
                GoodsList == [] -> {fail, ?ERRCODE(err_config)};
                BindType < ?COMPOSE_BIND orelse BindType > ?COMPOSE_BIND_IF_MAT_BIND ->
                    {fail, ?ERRCODE(err_config)};
                SexLimit /= 0 andalso SexLimit /= Sex ->
                    {fail, ?ERRCODE(err150_sex_limit)};
                true ->
                    %% 只能合物品
                    F = fun(Tmp) ->
                        case Tmp of
                            {?TYPE_GOODS, TmpGTypeId, TmpGNum} when TmpGNum > 0 ->
                                case data_goods_type:get(TmpGTypeId) of
                                    TmpGoods when is_record(TmpGoods, ets_goods_type) -> true;
                                    _ -> false
                                end;
                            _ -> false
                        end
                    end,
                    VailGoods = lists:all(F, GoodsList),
                    case VailGoods of
                        true ->
                            %% 限制固定材料和非固定材料不能有重复的物品
                            case RegularGIdList =/= [] andalso SpecifyGIdList =/= [] of
                                true ->
                                    F1 = fun(GoodsId) ->
                                        case lists:member(GoodsId, SpecifyGIdList) of
                                            true -> false;
                                            _ -> true
                                        end
                                    end,
                                    IsNotRepeatMat = lists:all(F1, RegularGIdList);
                                _ -> IsNotRepeatMat = true
                            end,
                            case IsNotRepeatMat of
                                true -> {ok, ComposeCfg};
                                _ -> {fail, ?ERRCODE(err150_compose_goods_not_enough)}
                            end;
                        _ -> {fail, ?ERRCODE(err_config)}
                    end
            end
    end.

%% 检查物品合成
%% 先检测配置 配置通过了这里是不会继续检测配置的
check_goods_compose(PlayerStatus, GoodsStatus, RuleId, RegularGIdList, SpecifyGIdList) ->
    case check_compose_cfg(RuleId, PlayerStatus, RegularGIdList, SpecifyGIdList) of
        {ok, ComposeCfg}
            when PlayerStatus#player_status.figure#figure.lv >= ComposeCfg#goods_compose_cfg.role_lv ->
            #goods_compose_cfg{
                type = ComposeGoodsType,
                condition = Condition,
                subtype = ComposeType,
                regular_mat = _RegularMat,
                cost = CostList,
                goods = ComposeGoods,
                bind_type = BindType
            } = ComposeCfg,
            case check_list(PlayerStatus, Condition) of
                true ->
                    %% 检测资源
                    case lib_goods_api:check_object_list(PlayerStatus, CostList) of
                        true ->
                            %% 检测要消耗的物品是否包含绑定道具
                            % F = fun(TmpGTypeList, TmpBind) ->
                            %     TmpBindGList = lib_goods_api:get_goods_num(PlayerStatus#player_status.id, TmpGTypeList, TmpBind),
                            %     TmpHasBindMat = lists:any(fun({_, TmpNum}) -> TmpNum > 0 end, TmpBindGList),
                            %     ?IF(TmpHasBindMat == true, ?BIND, ?UNBIND)
                            % end,
                            %% 检测合成材料是否足够
                            CheckMatResult = case ComposeType of
                                ?COMPOSE_TYPE_REGULAR ->    %% 只检测固定材料
                                    case check_regular_mat(GoodsStatus, RegularGIdList, ComposeCfg) of
                                        {ok, HasBindMat, RegularGInfoList} ->
                                            RealBind = case BindType of
                                                ?COMPOSE_BIND -> ?BIND;
                                                ?COMPOSE_UNBIND -> ?UNBIND;
                                                _ ->
                                                    ?IF(HasBindMat == 1, ?BIND, ?UNBIND)
                                            end,
                                            {ok, RegularGInfoList, [], RealBind, 100};
                                        {fail, TmpErrorCode} -> {fail, TmpErrorCode}
                                    end;
                                ?COMPOSE_TYPE_IRREGULAR ->  %% 只检测非固定材料
                                    case check_irregular_mat(GoodsStatus, SpecifyGIdList, ComposeCfg) of
                                        {ok, HasBindMat, SpecifyGInfoList, SuccessRatio} ->
                                            RealBind = case BindType of
                                                ?COMPOSE_BIND -> ?BIND;
                                                ?COMPOSE_UNBIND -> ?UNBIND;
                                                _ ->
                                                    ?IF(HasBindMat == 1, ?BIND, ?UNBIND)
                                            end,
                                            {ok, [], SpecifyGInfoList, RealBind, SuccessRatio};
                                        {fail, TmpErrorCode} -> {fail, TmpErrorCode}
                                    end;
                                ?COMPOSE_TYPE_MULTIPLE ->   %% 两者都检测
                                    case check_regular_mat(GoodsStatus, RegularGIdList, ComposeCfg) of
                                        {ok, HasBindMatRegular, RegularGInfoList} ->
                                            case check_irregular_mat(GoodsStatus, SpecifyGIdList, ComposeCfg) of
                                                {ok, HasBindMat, SpecifyGInfoList, SuccessRatio} ->
                                                    RealBind = case BindType of
                                                        ?COMPOSE_BIND -> ?BIND;
                                                        ?COMPOSE_UNBIND -> ?UNBIND;
                                                        _ ->
                                                            ?IF(HasBindMat == 1 orelse HasBindMatRegular == 1, ?BIND, ?UNBIND)
                                                    end,
                                                    {ok, RegularGInfoList, SpecifyGInfoList, RealBind, SuccessRatio};
                                                {fail, TmpErrorCode} -> {fail, TmpErrorCode}
                                            end;
                                        {fail, TmpErrorCode} -> {fail, TmpErrorCode}
                                    end
                            end,
                            %% 检测背包位置是否足够
                            case CheckMatResult of
                                {ok, CostRegularGInfoList, CostSpecifyGInfoList, ComposeGBind, CombineSuccessRatio} ->
                                    case check_is_special_compose(CostRegularGInfoList++CostSpecifyGInfoList, ComposeCfg, 0, 0) of
                                        {fail, ErrorCode} ->
                                            {fail, ErrorCode};
                                        IsSpecial ->
                                            CheckGList = [{TmpObjTypeId, TmpGTypeId, TmpGNum, ComposeGBind}
                                                || {TmpObjTypeId, TmpGTypeId, TmpGNum} <- ComposeGoods],
                                            case lib_goods_api:can_give_goods(PlayerStatus, CheckGList) of
                                                true ->
                                                    case ComposeGoodsType == ?COMPOSE_EQUIP andalso CombineSuccessRatio < 100 of
                                                        true -> %% 装备合成:并且合成概率低于100才会进行首次合成必定成功的判断
                                                            ComposeCount = mod_counter:get_count(PlayerStatus#player_status.id, ?MOD_GOODS, ?MOD_GOODS_COMPOSE, ComposeGoodsType),
                                                            {NewCombineSuccessRatio, IsFirst} = ?IF(ComposeCount > 0, {CombineSuccessRatio, false}, {100, true});
                                                        _ ->
                                                            NewCombineSuccessRatio = CombineSuccessRatio, IsFirst = false
                                                    end,
                                                    case ComposeGoodsType == ?COMPOSE_EQUIP of
                                                        true ->
                                                            [{_, GoodsTypeId, _}|_] = ComposeGoods,
                                                            case data_goods_type:get(GoodsTypeId) of
                                                                %% modify 装备合成暗加5%成功率，如果合成列表每有一件残装备+10% （20220322策划zbh要求修改）
                                                                #ets_goods_type{color = ?RED} ->
                                                                    F_ratio = fun({CGoodsInfo, Num}, Acc) ->
                                                                        #goods{goods_id = CGId} = CGoodsInfo,
                                                                        case CGoodsInfo#goods.type == ?GOODS_TYPE_EQUIP of
                                                                            true ->
                                                                                case data_equip:get_equip_attr_cfg(CGId) of
                                                                                    #equip_attr_cfg{class_type = 1} -> 1000*Num+Acc;
                                                                                    _ -> Acc
                                                                                end
                                                                        end
                                                                    end,
                                                                    ExtraRatioAdd = lib_module_buff:get_equip_compose_ratio_add(PlayerStatus) +
                                                                        lib_supreme_vip_api:get_red_equip_ratio_add(PlayerStatus) +
                                                                        lists:foldl(F_ratio, 500, CostRegularGInfoList ++ CostSpecifyGInfoList);
                                                                _ ->
                                                                    ExtraRatioAdd = 0
                                                            end;
                                                        _ ->
                                                            ExtraRatioAdd = 0
                                                    end,
                                                    LastCombineSuccessRatio = (NewCombineSuccessRatio) * 100 + ExtraRatioAdd,
                                                    {ok, ComposeCfg, CostRegularGInfoList, CostSpecifyGInfoList, ComposeGBind, IsFirst, LastCombineSuccessRatio, IsSpecial};
                                                _ ->
                                                    {fail, ?ERRCODE(err150_no_cell_to_compose)}
                                            end
                                    end;
                                {fail, ErrorCode} -> {fail, ErrorCode}
                            end;
                        {false, _ErrorCode} -> {fail, ?ERRCODE(err150_no_money_to_compose)}
                    end;
                {false, ErrorCode} -> {fail, ErrorCode}
            end;
        {ok, _ComposeCfg} -> {fail, ?ERRCODE(err150_not_satisfy_compose_lv)};
        {fail, ErrorCode} -> {fail, ErrorCode}
    end.

%% 恶魔，守护特殊合成
check_goods_compose_simple(PlayerStatus, GoodsStatus, RuleId, CombineNum, RegularList, IrRegularList) when RuleId == 26011 orelse  RuleId == 26021->
    lib_magic_circle:check_goods_compose(PlayerStatus, GoodsStatus, RuleId, CombineNum, RegularList, IrRegularList);
%% 先检测配置 配置通过了这里是不会继续检测配置的
check_goods_compose_simple(PlayerStatus, GoodsStatus, RuleId, CombineNum, RegularList, IrRegularList) ->
    case check_compose_cfg(RuleId, PlayerStatus, [], []) of
        {ok, ComposeCfg}
            when PlayerStatus#player_status.figure#figure.lv >= ComposeCfg#goods_compose_cfg.role_lv andalso ComposeCfg#goods_compose_cfg.type == ?COMPOSE_GOODS ->
            #goods_compose_cfg{
                condition = Condition,
                cost = CostList
            } = ComposeCfg,
            case check_list(PlayerStatus, Condition) of
                true ->
                    case lib_goods_api:check_object_list(PlayerStatus, CostList) of
                        true ->
                            check_goods_compose_simple_do(PlayerStatus, GoodsStatus, ComposeCfg, CombineNum, RegularList, IrRegularList);
                        {false, ErrorCode} ->
                            {fail, ErrorCode}
                    end;
                {false, ErrorCode} ->
                    {fail, ErrorCode}
            end;
        {ok, _ComposeCfg} ->
            {fail, ?ERRCODE(err150_not_satisfy_compose_lv)};
        {fail, ErrorCode} ->
            {fail, ErrorCode}
    end.

check_goods_compose_simple_do(PlayerStatus, _GoodsStatus, ComposeCfg, CombineNum, RegularList, IrRegularList) ->
    case check_goods_compose_simple_regular(PlayerStatus, ComposeCfg, CombineNum, RegularList) of
        {ok, CostListRegular, BindNum1} ->
            case check_goods_compose_simple_irregular(PlayerStatus, ComposeCfg, CombineNum, IrRegularList) of
                {ok, RealCombineNum, CostListIrregular, BindNum2} ->
                    RealCostList = CostListRegular ++ CostListIrregular,
                    case lib_goods_api:check_object_list(PlayerStatus, RealCostList) of
                        true ->
                            BindNum = min(RealCombineNum, max(BindNum1, BindNum2)),
                            %计算真实奖励
                            F = fun({Type, Id, Num}, Acc) ->
                                case Type == ?TYPE_GOODS andalso BindNum > 0 of
                                    true ->
                                        ?IF(BindNum < RealCombineNum,
                                            [{?TYPE_GOODS, Id, Num*(RealCombineNum-BindNum)}, {?TYPE_BIND_GOODS, Id, Num*BindNum}|Acc],
                                            [{?TYPE_BIND_GOODS, Id, Num*RealCombineNum}|Acc]);
                                    _ ->
                                        [{Type, Id, Num*RealCombineNum}|Acc]
                                end
                            end,
                            RewardList = lists:foldl(F, [], ComposeCfg#goods_compose_cfg.goods),
                            {ok, ComposeCfg, RealCombineNum, RealCostList, RewardList};
                        {false, ErrCode} ->
                            {fail, ErrCode}
                    end;
                {fail, ErrCode} ->
                    {fail, ErrCode}
            end;
        {fail, ErrCode} ->
            {fail, ErrCode}
    end.

check_goods_compose_simple_regular(PlayerStatus, ComposeCfg, CombineNum, RegularList) ->
    #goods_compose_cfg{
        subtype = ComposeType,
        regular_mat = RegularMat
    } = ComposeCfg,
    case ComposeType == ?COMPOSE_TYPE_REGULAR orelse ComposeType == ?COMPOSE_TYPE_MULTIPLE of
        true ->
            F = fun(_I, {ReMat, ReList, CostList, BindNum}) ->
                case ReMat of
                    [Group|LeftGroup] ->
                        case ReList of
                            [{_Pos, GoodsTypeId, Num}|Left] ->
                                case lists:keyfind(GoodsTypeId, 2, Group) of
                                    {_, _, NeedNum} when Num >= (NeedNum*CombineNum) ->
                                        NewCostList = [{?TYPE_GOODS, GoodsTypeId, NeedNum*CombineNum}|CostList],
                                        [{GoodsTypeId, GoodsNum}] = lib_goods_api:get_goods_num(PlayerStatus, [GoodsTypeId], ?BIND),
                                        NewBindNum = max(BindNum, umath:ceil(GoodsNum/NeedNum)),
                                        {LeftGroup, Left, NewCostList, NewBindNum};
                                    _ ->
                                        {ReMat, ReList, CostList, BindNum}
                                end;
                            _ ->
                                {ReMat, ReList, CostList, BindNum}
                        end;
                    _ ->
                        {ReMat, ReList, CostList, BindNum}
                end
            end,
            case lists:foldl(F, {RegularMat, RegularList, [], 0}, lists:seq(1, length(RegularMat))) of
                {[], _, CostList, BindNum} -> {ok, CostList, BindNum};
                _ -> {fail, ?ERRCODE(err150_compose_goods_not_enough)}
            end;
        _ ->
            {ok, [], 0}
    end.

check_goods_compose_simple_irregular(PlayerStatus, ComposeCfg, CombineNum, IrRegularList) ->
    #goods_compose_cfg{
        subtype = ComposeType,
        irregular_mat = IrregularMat,
        ratio = Ratio
    } = ComposeCfg,
    case ComposeType == ?COMPOSE_TYPE_MULTIPLE orelse ComposeType == ?COMPOSE_TYPE_IRREGULAR of
        true ->
            IrRegularListLen = length(IrRegularList),
            SortRatio = lists:keysort(1, Ratio),
            SuccessRatio = lib_goods:count_irregular_ratio(SortRatio, IrRegularListLen, 0),
            if
                SuccessRatio == 0 -> {fail, ?ERRCODE(err150_compose_goods_not_enough)};
                true ->
                    F = fun(_I, {IrreMat, IrReList, CostList, BindNum}) ->
                        case IrReList of
                            [{_Pos, GoodsTypeId, Num}|Left] ->
                                case IrreMat of
                                    [Group|LeftGroup] ->
                                        case lists:member(GoodsTypeId, Group) of
                                            true when Num >= CombineNum ->
                                                NewCostList = [{?TYPE_GOODS, GoodsTypeId, CombineNum}|CostList],
                                                [{GoodsTypeId, GoodsNum}] = lib_goods_api:get_goods_num(PlayerStatus, [GoodsTypeId], ?BIND),
                                                NewBindNum = max(BindNum, GoodsNum),
                                                {LeftGroup, Left, NewCostList, NewBindNum};
                                            _ ->
                                                {IrreMat, IrReList, CostList, BindNum}
                                        end;
                                    _ ->
                                        {IrreMat, IrReList, CostList, BindNum}
                                end;
                            _ ->
                                {IrreMat, IrReList, CostList, BindNum}
                        end
                    end,
                    case lists:foldl(F, {IrregularMat, IrRegularList, [], 0}, lists:seq(1, length(IrRegularList))) of
                        {_, _, [], _} -> {fail, ?ERRCODE(err150_compose_goods_not_enough)};
                        {_, _, CostList, BindNum} ->
                            NewSuccessRatio = SuccessRatio * 100,
                            RealCombineNum = length([I || I <- lists:seq(1, CombineNum), urand:rand(1, 10000) =< NewSuccessRatio]),
                            {ok, RealCombineNum, CostList, BindNum}
                    end
            end;
        _ ->
            {ok, CombineNum, [], 0}
    end.

%% 检测非固定的合成材料
check_irregular_mat(GoodsStatus, SpecifyGIdList, ComposeCfg) ->
    #goods_compose_cfg{
        irregular_mat = IrregularMat,
        ratio = Ratio
    } = ComposeCfg,
    SpecifyGListLen = length(SpecifyGIdList),
    SortRatio = lists:keysort(1, Ratio),
    SuccessRatio = lib_goods:count_irregular_ratio(SortRatio, SpecifyGListLen, 0),
    if
        SuccessRatio == 0 -> %% 非固定合成的成功率必须大于0才给合成
            {fail, ?ERRCODE(err150_compose_goods_not_enough)};
        true ->
            F = fun(GoodsId, AccList) ->
                case lists:keyfind(GoodsId, 1, AccList) of
                    {GoodsId, TmpNum} -> skip;
                    _ -> TmpNum = 0
                end,
                lists:keystore(GoodsId, 1, AccList, {GoodsId, TmpNum + 1})
            end,
            CombineList = lists:foldl(F, [], SpecifyGIdList),
            case do_check_irregular_mat(CombineList, IrregularMat, GoodsStatus, 0, []) of
                {ok, HasBindMat, GoodsInfoList} -> {ok, HasBindMat, GoodsInfoList, SuccessRatio};
                {fail, ErrorCode} -> {fail, ErrorCode}
            end
    end.

do_check_irregular_mat([], _, _, HasBindMat, Result) -> {ok, HasBindMat, Result};
do_check_irregular_mat([{NGoodsId, NGoodsNum}|L], IrregularMat, GoodsStatus, HasBindMat, Result) ->
    case check_compose_mat_normal(GoodsStatus, NGoodsId) of
        {ok, GoodsInfo} ->
            #goods{goods_id = GTypeId, num = Num, bind = Bind} = GoodsInfo,
            case do_check_irregular_mat_helper(GTypeId, IrregularMat) of
                {true, NIrregularMat} ->
                    case NGoodsNum > 0 andalso Num >= NGoodsNum of
                        true ->
                            NewHasBindMat = ?IF(HasBindMat == 0 andalso Bind == ?BIND, 1, HasBindMat),
                            do_check_irregular_mat(L, NIrregularMat, GoodsStatus, NewHasBindMat, [{GoodsInfo, NGoodsNum} | Result]);
                        _ ->
                            {fail, ?ERRCODE(err150_compose_goods_not_enough)}
                    end;
                _ -> {fail, ?ERRCODE(err150_not_compose_mat)}
            end;
        {fail, ErrorCode} -> {fail, ErrorCode}
    end.

do_check_irregular_mat_helper(GTypeId, IrregularMat) ->
    F = fun(SubL, {L, IsFind}) when IsFind == false ->
            case lists:member(GTypeId, SubL) of
                true -> {L, true};
                _ -> {[SubL|L], IsFind}
            end;
        (SubL, {L, IsFind}) -> {[SubL|L], IsFind}
    end,
    {NIrregularMat, IsFind} = lists:foldl(F, {[], false}, IrregularMat),
    case IsFind /= true of
        true ->
            false;
        _ -> {true, NIrregularMat}
    end.

%% 检测固定的合成材料
check_regular_mat(GoodsStatus, RegularGIdList, ComposeCfg) ->
    #goods_compose_cfg{
        regular_mat = RegularMat
    } = ComposeCfg,
    F = fun(GoodsId, AccList) ->
        case lists:keyfind(GoodsId, 1, AccList) of
            {GoodsId, TmpNum} -> skip;
            _ -> TmpNum = 0
        end,
        lists:keystore(GoodsId, 1, AccList, {GoodsId, TmpNum + 1})
        end,
    CombineList = lists:foldl(F, [], RegularGIdList),
    do_check_regular_mat(CombineList, RegularMat, GoodsStatus, 0, []).

do_check_regular_mat([], [], _, HasBindMat, Result) -> {ok, HasBindMat, Result};
do_check_regular_mat([], _RegularMat, _, _HasBindMat, _Result) ->
    {fail, ?ERRCODE(err150_compose_goods_not_enough)};
do_check_regular_mat([{NGoodsId, NGoodsNum} | L], RegularMat, GoodsStatus, HasBindMat, Result) ->
    case check_compose_mat_normal(GoodsStatus, NGoodsId) of
        {ok, GoodsInfo} when GoodsInfo#goods.num >= NGoodsNum ->
            #goods{goods_id = GTypeId, bind = Bind} = GoodsInfo,
            case do_check_regular_mat_helper(GTypeId, NGoodsNum, RegularMat) of
                {true, NewRegularMat, RealCostNum} ->
                    NewHasBindMat = ?IF(HasBindMat == 0 andalso Bind == ?BIND, 1, HasBindMat),
                    do_check_regular_mat(L, NewRegularMat, GoodsStatus, NewHasBindMat, [{GoodsInfo, RealCostNum} | Result]);
                {fail, Res} -> {fail, Res}
            end;
        {ok, _GoodsInfo} ->
            {fail, ?ERRCODE(err150_compose_goods_not_enough)};
        {fail, ErrorCode} -> {fail, ErrorCode}
    end.

do_check_regular_mat_helper(GTypeId, GoodsNum, RegularMat) ->
    F = fun(SubL, {L, Res, RealCostNum}) when Res =/= 1 ->
            case lists:keyfind(GTypeId, 2, SubL) of
                {_Type, GTypeId, NeedNum} ->
                    case GoodsNum >= NeedNum of
                        true -> {L, 1, NeedNum}; %% 存在组，并且物品足够
                        _ ->
                            NewSubL = lists:keystore(GTypeId, 2, SubL, {_Type, GTypeId, NeedNum-GoodsNum}),
                            {[NewSubL|L], 1, GoodsNum} %% 存在组，但是物品不足
                    end;
                _ -> {[SubL|L], Res, RealCostNum}
            end;
        (SubL, {L, Res, RealCostNum}) -> {[SubL|L], Res, RealCostNum}
    end,
    {NRegularMat, Res, NewGoodsNum} = lists:foldl(F, {[], 0, GoodsNum}, RegularMat),
    case Res of
        1 -> {true, NRegularMat, NewGoodsNum};
        2 -> {fail, ?ERRCODE(err150_compose_goods_not_enough)};
        _ -> {fail, ?ERRCODE(err150_not_compose_mat)}
    end.

check_is_special_compose([], _ComposeCfg, Count, SpecialType) ->
    case Count of
        1 -> {true, SpecialType};
        _ -> false
    end;
check_is_special_compose([{GoodsInfo, _Num} | L], ComposeCfg, Count, SpecialType) ->
    if
        GoodsInfo#goods.type == ?GOODS_TYPE_EQUIP andalso
            (GoodsInfo#goods.subtype == ?EQUIP_BRACELET orelse GoodsInfo#goods.subtype == ?EQUIP_RING) andalso
            GoodsInfo#goods.location == ?GOODS_LOC_EQUIP -> %% 只能有一个戒指或手镯装备在身上的
            case Count == 0 of
                true ->
                    case ComposeCfg#goods_compose_cfg.goods of
                        [{_, TargetGoodsTypeId, 1}] ->
                            case data_goods_type:get(TargetGoodsTypeId) of
                                #ets_goods_type{type = Type, subtype = SubType} when Type == GoodsInfo#goods.type, SubType == GoodsInfo#goods.subtype ->
                                    check_is_special_compose(L, ComposeCfg, Count + 1, ?GOODS_COMPOSE_SPECIAL_1);
                                _ ->
                                    {fail, ?ERRCODE(err_config)}
                            end;
                        _ ->
                            {fail, ?ERRCODE(err_config)}
                    end;
                _ ->
                    {fail, ?FAIL}
            end;
        GoodsInfo#goods.type == ?GOODS_TYPE_GOD_EQUIP andalso
            GoodsInfo#goods.location == ?GOODS_LOC_GOD2_EQUIP -> %% 降神身上的装备
            case Count == 0 of
                true ->
                    case ComposeCfg#goods_compose_cfg.goods of
                        [{_, TargetGoodsTypeId, 1}] ->
                            case data_goods_type:get(TargetGoodsTypeId) of
                                #ets_goods_type{type = Type, subtype = SubType} when Type == GoodsInfo#goods.type, SubType == GoodsInfo#goods.subtype ->
                                    check_is_special_compose(L, ComposeCfg, Count + 1, ?GOODS_COMPOSE_SPECIAL_2);
                                _ ->
                                    {fail, ?ERRCODE(err_config)}
                            end;
                        _ ->
                            {fail, ?ERRCODE(err_config)}
                    end;
                _ ->
                    {fail, ?FAIL}
            end;
        GoodsInfo#goods.type == ?GOODS_TYPE_REVELATION andalso
            GoodsInfo#goods.location == ?GOODS_LOC_REVELATION -> %%天启身上的装备
            case Count == 0 of
                true ->
                    case ComposeCfg#goods_compose_cfg.goods of
                        [{_, TargetGoodsTypeId, 1}] ->
                            case data_goods_type:get(TargetGoodsTypeId) of
                                #ets_goods_type{type = Type, subtype = SubType} when Type == GoodsInfo#goods.type, SubType == GoodsInfo#goods.subtype ->
                                    check_is_special_compose(L, ComposeCfg, Count + 1, ?GOODS_COMPOSE_SPECIAL_3);
                                _ ->
                                    {fail, ?ERRCODE(err_config)}
                            end;
                        _ ->
                            {fail, ?ERRCODE(err_config)}
                    end;
                _ ->
                    {fail, ?FAIL}
            end;
        GoodsInfo#goods.type == ?GOODS_TYPE_SEAL andalso
            GoodsInfo#goods.location == ?GOODS_LOC_SEAL_EQUIP -> %%圣印身上的装备
            case Count == 0 of
                true ->
                    case ComposeCfg#goods_compose_cfg.goods of
                        [{_, TargetGoodsTypeId, 1}] ->
                            case data_goods_type:get(TargetGoodsTypeId) of
                                #ets_goods_type{type = Type, subtype = SubType} when Type == GoodsInfo#goods.type, SubType == GoodsInfo#goods.subtype ->
                                    check_is_special_compose(L, ComposeCfg, Count + 1, ?GOODS_COMPOSE_SPECIAL_4);
                                _ ->
                                    {fail, ?ERRCODE(err_config)}
                            end;
                        _ ->
                            {fail, ?ERRCODE(err_config)}
                    end;
                _ ->
                    {fail, ?FAIL}
            end;
        GoodsInfo#goods.type == ?GOODS_TYPE_DRACONIC andalso
            GoodsInfo#goods.location == ?GOODS_LOC_DRACONIC_EQUIP -> %%龙语身上的装备
            case Count == 0 of
                true ->
                    case ComposeCfg#goods_compose_cfg.goods of
                        [{_, TargetGoodsTypeId, 1}] ->
                            case data_goods_type:get(TargetGoodsTypeId) of
                                #ets_goods_type{type = Type, subtype = SubType} when Type == GoodsInfo#goods.type, SubType == GoodsInfo#goods.subtype ->
                                    check_is_special_compose(L, ComposeCfg, Count + 1, ?GOODS_COMPOSE_SPECIAL_5);
                                _ ->
                                    {fail, ?ERRCODE(err_config)}
                            end;
                        _ ->
                            {fail, ?ERRCODE(err_config)}
                    end;
                _ ->
                    {fail, ?FAIL}
            end;
        GoodsInfo#goods.type == ?GOODS_TYPE_GOD_COURT andalso
            GoodsInfo#goods.location == ?GOODS_LOC_GOD_COURT_EQUIP -> %%神庭身上的装备
            case Count == 0 of
                true ->
                    case ComposeCfg#goods_compose_cfg.goods of
                        [{_, TargetGoodsTypeId, 1}] ->
                            case data_goods_type:get(TargetGoodsTypeId) of
                                #ets_goods_type{type = Type, subtype = SubType} when Type == GoodsInfo#goods.type, SubType == GoodsInfo#goods.subtype ->
                                    CorePosList = data_god_court:get_core_pos(),
                                    %% 判断是否核心
                                    case lists:member(SubType, CorePosList) of
                                        true -> check_is_special_compose(L, ComposeCfg, Count + 1, ?GOODS_COMPOSE_SPECIAL_6);
                                        false -> check_is_special_compose(L, ComposeCfg, Count, ?GOODS_COMPOSE_SPECIAL_6)
                                    end;
                                _ ->
                                    {fail, ?ERRCODE(err_config)}
                            end;
                        _ ->
                            {fail, ?ERRCODE(err_config)}
                    end;
                _ ->
                    {fail, ?FAIL}
            end;
        true ->
            check_is_special_compose(L, ComposeCfg, Count, SpecialType)
    end.

%% 检查合成材料
check_compose_mat_normal(GoodsStatus, GoodsId) ->
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    if
        is_record(GoodsInfo, goods) =:= false ->
            {fail, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.player_id =/= GoodsStatus#goods_status.player_id ->
            {fail, ?ERRCODE(err150_palyer_err)};
        %% 降神装备允许身上的装备作为材料
        GoodsInfo#goods.type == ?GOODS_TYPE_GOD_EQUIP ->
            {ok, GoodsInfo};
        GoodsInfo#goods.type == ?GOODS_TYPE_SEAL ->
            {ok, GoodsInfo};
        GoodsInfo#goods.type == ?GOODS_TYPE_DRACONIC ->
            {ok, GoodsInfo};
        GoodsInfo#goods.type == ?GOODS_TYPE_REVELATION ->
            {ok, GoodsInfo};
        GoodsInfo#goods.type == ?GOODS_TYPE_GOD_COURT ->
            {ok, GoodsInfo};
        not (GoodsInfo#goods.type == ?GOODS_TYPE_EQUIP andalso
        (GoodsInfo#goods.subtype == ?EQUIP_BRACELET orelse GoodsInfo#goods.subtype == ?EQUIP_RING))
        andalso GoodsInfo#goods.location =/= GoodsInfo#goods.bag_location ->
            {fail, ?ERRCODE(err150_location_err)};
        true ->
            {ok, GoodsInfo}
    end.

check(Ps, {rune_tower, Num}) ->
    TowerNum = lib_dungeon_rune:get_dungeon_level(Ps),  %%获得爬塔层数
    if
        TowerNum >= Num ->
            true;
        true ->
            {false, ?ERRCODE(err150_not_enough_run_dun)}
    end;

check(_PlayerStatus, _T) ->
    {false, ?FAIL}.

check_list(_PlayerStatus, []) -> true;
check_list(PlayerStatus, [H | T]) ->
    case check(PlayerStatus, H) of
        true -> check_list(PlayerStatus, T);
        {false, Res} -> {false, Res};
        false ->
            {false, ?FAIL}
    end.

%% 检查boss之间的等级差，太高就不给拾取
%% @return {true|false, ErrCode},true不给掉落,false允许掉落
check_boss_lv(Scene, MonId, BossLv, Lv) ->
    case data_scene:get(Scene) of
        % #ets_scene{type = ?SCENE_TYPE_EUDEMONS_BOSS} -> %% 世界服幻兽
        %     case data_eudemons_land:get_eudemons_boss_cfg(MonId) of
        %         #eudemons_boss_cfg{drop_lv = DropLv} ->
        %             if
        %                 DropLv == 0 -> false;
        %                 true -> Lv - BossLv >= DropLv
        %             end;
        %         _ ->
        %             false
        %     end;
        #ets_scene{type = Type} when
                Type == ?SCENE_TYPE_WORLD_BOSS;
                Type == ?SCENE_TYPE_HOME_BOSS;
                Type == ?SCENE_TYPE_NEW_OUTSIDE_BOSS;
                Type == ?SCENE_TYPE_SPECIAL_BOSS;
                Type == ?SCENE_TYPE_WORLD_BOSS_PER;
                Type == ?SCENE_TYPE_ABYSS_BOSS;
                Type == ?SCENE_TYPE_FORBIDDEB_BOSS ->
            case data_boss:get_boss_cfg(MonId) of
                #boss_cfg{drop_lv = DropLv} ->
                    if
                        DropLv == 0 -> {false, ?SUCCESS};
                        true ->
                            Diff = Lv - BossLv,
                            ?IF(Diff >= DropLv, {true, {?ERRCODE(err150_drop_overlv_with_args), [DropLv]}}, {false, ?SUCCESS})
                    end;
                _ ->
                    {false, ?SUCCESS}
            end;
        _ ->
            {false, ?SUCCESS}
    end.

get_nocell_errcode(_Location) ->
    ?ERRCODE(err150_no_cell).

%%-------------------------------------------------
%% @doc 扩展背包
%% -spec check_expand_bag(PlayerStatus, Type, Num, Gold) -> {ok}|{fail, Err}
%% when
%%      PlayerStatus    :: #player_status{}     玩家记录
%%      Type            :: integer()            格子位置
%%      Num             :: integer()            数量
%%      Gold            :: integer()            元宝数
%%      Err             :: integer()            错误码
%% @end
%%----------------------------------------------------
% check_expand_bag(PlayerStatus, GoodsStatus, Pos, CellNum) ->
%     #player_status{id = RoleId, cell_num = BagCell, storage_num = StoCell, gold = Gold} = PlayerStatus,
%     if
%         CellNum =< 0 orelse (Pos =/= ?GOODS_LOC_BAG andalso Pos =/= ?GOODS_LOC_STORAGE) ->
%             {fail, ?ERRCODE(data_error)};
%         true ->
%             CellMax = ?IF(Pos =:= ?GOODS_LOC_BAG, ?GOODS_BAG_MAX_NUM, ?GOODS_STORAGE_MAX_NUM),
%             CurrentCell = ?IF(Pos =:= ?GOODS_LOC_BAG, BagCell, StoCell),
%             if
%                 CurrentCell + CellNum > CellMax ->
%                     {fail, ?ERRCODE(cell_beyond)};
%                 true ->
%                     GoodId = ?GOODS_ID_KEY, %% 背包扩容钥匙
%                     [{_, GNum}|_] = lib_goods_do:goods_num([GoodId]),
%                     RNum = GNum div 2, %% 两把钥匙扩一个格子
%                     SGold = ?IF(Pos =:= ?GOODS_LOC_BAG, ?GOODS_BAG_EXTEND_GOLD, ?GOODS_STORAGE_EXTEND_GOLD),
%                     GoodsList = lib_goods_util:get_type_goods_list(RoleId, GoodId,
%                                                                    ?GOODS_LOC_BAG, GoodsStatus#goods_status.dict),
%                     {DelNum, NeedGold}
%                         = if
%                               RNum == 0 ->
%                                   {0, CellNum * SGold};
%                               RNum >= CellNum ->
%                                   {CellNum*2, 0};
%                               true ->
%                                   LGNum = CellNum - RNum,
%                                   {RNum*2, LGNum*SGold}
%                           end,
%                     if
%                         Gold < NeedGold ->
%                             {fail, ?ERRCODE(gold_not_enough)};
%                         true ->
%                             {ok, {GoodsList, DelNum, NeedGold}}
%                     end
%             end
%     end.
