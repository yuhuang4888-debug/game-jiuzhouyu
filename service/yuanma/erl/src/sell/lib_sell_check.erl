-module (lib_sell_check).
-include ("common.hrl").
-include ("goods.hrl").
-include ("def_goods.hrl").
-include ("rec_sell.hrl").
-include ("server.hrl").
-include ("predefine.hrl").
-include ("errcode.hrl").
-include ("def_module.hrl").
-include ("figure.hrl").

-export ([
    sell_up/7
    , pay_sell/5
    , sell_down/2
    , check_anyone_sell2me/2
    , seek_goods/4
    , sell_seek_goods/6
]).

sell_up(_SellType, #player_status{mark = Mark}, _GoodsStatus, _GoodsId, _GoodsNum, _UnitPrice, _SpecifyId) when ?CHECK_MARK_WITH(Mark, ?MARK_SELF_CHARGE) ->
    {fail, ?FAIL};
sell_up(SellType, PS, GoodsStatus, GoodsId, GoodsNum, UnitPrice, SpecifyId) ->
    #player_status{id = PlayerId, figure = #figure{lv = RoleLv, vip = VipLv}} = PS,
    IsOpenKf = mod_global_counter:get_count(?MOD_SELL, ?GLOBAL_151_KF_IS_OPEN),
    case check_goods_base(PlayerId, GoodsId, GoodsNum, GoodsStatus) of
        {false, Res} -> {fail, Res};
        {true, GoodsInfo} ->
            case checklist([
                {check_sell_up_price, GoodsInfo#goods.goods_id, GoodsNum, UnitPrice},
                {check_sell_up_gold_limit, PlayerId, RoleLv, UnitPrice}
            ]) of
                true ->
                    %% mod_sell:check_sell_up_goods(SellType, PlayerId, VipLv, SpecifyId)
                    if
                        IsOpenKf >= 1 ->  %% 已经开启了跨服市场
                            case catch mod_clusters_node:apply_call(mod_kf_sell, check_sell_up_goods, [SellType, config:get_server_id(), PlayerId, VipLv, SpecifyId]) of
                                ok -> {ok, GoodsInfo};
                                {fail, Res} -> {fail, Res};
                                Error -> %% 出错 提示系统繁忙
                                    ?ERR("sell_up err:~p", [Error]),
                                    {fail, ?ERRCODE(system_busy)}
                            end;
                        true ->
                            case catch mod_sell:check_sell_up_goods(SellType, PlayerId, VipLv, SpecifyId) of
                                ok -> {ok, GoodsInfo};
                                {fail, Res} -> {fail, Res};
                                Error -> %% 出错 提示系统繁忙
                                    ?ERR("sell_up err:~p", [Error]),
                                    {fail, ?ERRCODE(system_busy)}
                            end
                    end;
                {false, Res} -> {fail, Res}
            end
    end.

pay_sell(#player_status{mark = Mark}, _SellerId, _GTypeId, _GoodsNum, _UnitPrice) when ?CHECK_MARK_WITH(Mark, ?MARK_SELF_CHARGE) ->
    {fail, ?FAIL};
pay_sell(PS, SellerId, GTypeId, GoodsNum, UnitPrice) ->
    Check = [
            {enough_money, PS, GTypeId, GoodsNum, UnitPrice, ?GOLD},
            {check_null_cells, [{GTypeId, GoodsNum}]},
            {check_payer_daily_quota, PS},
            {check_seller_gold_got_max, SellerId}
        ],
    case checklist(Check) of
        {false, Res} -> {fail, Res};
        true ->
            case catch mod_daily:get_count(PS#player_status.id, ?MOD_SELL, 1) of
                Times when is_integer(Times) ->
                    LimitTimes = data_sell:get_cfg(transaction_times_limit) + lib_vip_api:get_vip_privilege(?MOD_SELL, 2, PS#player_status.figure#figure.vip_type, PS#player_status.figure#figure.vip),
                    ?PRINT("LimitTimes ~p~n", [LimitTimes]),
                    case Times < LimitTimes of
                        true -> {ok, LimitTimes - Times};
                        false -> {fail, ?ERRCODE(err151_sell_times_limit)}
                    end;
                Error ->
                    ?ERR("pay_sell err:~p", [Error]),
                    {fail, ?ERRCODE(system_busy)}
            end
    end.

sell_down(GoodsId, GoodsNum) ->
    Check = [
        {check_null_cells, [{GoodsId, GoodsNum}]}
    ],
    case checklist(Check) of
        {false, Res} -> {fail, Res};
        true -> ok
    end.

seek_goods(PS, GTypeId, GoodsNum, UnitPrice) ->
    #player_status{id = PlayerId, figure = #figure{vip_type = VipType, vip = VipLv}, server_id = ServerId} = PS,
    LimitTimes = data_sell:get_cfg(transaction_times_limit) + lib_vip_api:get_vip_privilege(?MOD_SELL, 2, VipType, VipLv),
    SellTimes = mod_daily:get_count(PlayerId, ?MOD_SELL, 1), 
    case checklist([
            {enough_money, PS, GTypeId, GoodsNum, UnitPrice, ?GOLD}, 
            {check_sell_up_price, GTypeId, GoodsNum, UnitPrice},
            {check_payer_daily_quota, PS}
        ]) 
    of
        true ->
            case GoodsNum > 0 of 
                true ->
                    IsOpenKf = mod_global_counter:get_count(?MOD_SELL, ?GLOBAL_151_KF_IS_OPEN),
                    if
                        IsOpenKf >= 1 ->  %% 大于= 1 则是开启
                            case catch mod_clusters_node:apply_call(mod_kf_sell, check_seek_goods,
                                [ServerId, PlayerId, VipLv, SellTimes, LimitTimes]) of
                                ok -> ok;
                                {fail, Res} -> {fail, Res};
                                Error -> %% 出错 提示系统繁忙
                                    ?ERR("seek_goods err:~p", [Error]),
                                    {fail, ?ERRCODE(system_busy)}
                            end;
                        true ->
                            case catch mod_sell:check_seek_goods(PlayerId, VipLv, SellTimes, LimitTimes) of
                                ok -> ok;
                                {fail, Res} -> {fail, Res};
                                Error -> %% 出错 提示系统繁忙
                                    ?ERR("seek_goods err:~p", [Error]),
                                    {fail, ?ERRCODE(system_busy)}
                            end
                    end;
                _ ->
                    {fail, ?FAIL}
            end;
        {false, Res} -> {fail, Res}
    end.

sell_seek_goods(PS, GoodsStatus, BuyerId, GTypeId, GoodsNum, Price) ->
    #player_status{id = PlayerId, figure = #figure{lv = RoleLv}} = PS,
    {BuyerVipType, BuyerVipLv} = lib_role:get_role_vip(BuyerId),
    LimitTimes = data_sell:get_cfg(transaction_times_limit) + lib_vip_api:get_vip_privilege(?MOD_SELL, 2, BuyerVipType, BuyerVipLv),
    case mod_daily:get_count_offline(BuyerId, ?MOD_SELL, 1) of 
        SellTimes when SellTimes < LimitTimes ->
            case checklist([{check_sell_up_gold_limit, PlayerId, RoleLv, Price}]) of
                true ->
                    case data_goods_type:get(GTypeId) of 
                        #ets_goods_type{bag_location = Location} when GoodsNum > 0 ->
                            GoodsList = lib_goods_util:get_type_goods_list(PlayerId, GTypeId, ?UNBIND, Location, GoodsStatus#goods_status.dict),
                            F = fun(GoodsInfo, List) ->
                                case check_goods_can_sell(GoodsInfo, PlayerId) of 
                                    {true, _} -> [{GoodsInfo, GoodsInfo#goods.num}|List];
                                    _ -> List
                                end
                            end,
                            GoodsInfoList = lists:foldl(F, [], GoodsList),
                            F1 = fun({GoodsInfo, Num}, {DeleteNum, List}) ->
                                case Num >= DeleteNum of 
                                    true -> 
                                        case DeleteNum > 0 of 
                                            true ->
                                                {0, [{GoodsInfo, DeleteNum}|List]};
                                            _ ->
                                                {0, List}
                                        end;
                                    _ -> {DeleteNum-Num, [{GoodsInfo, Num}|List]}
                                end
                            end,
                            {LeftDeleteNum, CostGoodsInfoList} = lists:foldl(F1, {GoodsNum, []}, lists:keysort(2, GoodsInfoList)),
                            case LeftDeleteNum > 0 of 
                                true -> {fail, ?GOODS_NOT_ENOUGH};
                                _ -> 
                                    [{GoodsInfo, _Num}|_] = CostGoodsInfoList,
                                    case GoodsInfo#goods.type == ?GOODS_TYPE_EQUIP andalso is_record(GoodsInfo#goods.other, goods_other) of 
                                        true -> ExtraAttr = GoodsInfo#goods.other#goods_other.extra_attr, Rating = GoodsInfo#goods.other#goods_other.rating;
                                        _ -> ExtraAttr = [], Rating = 0
                                    end,
                                    {ok, CostGoodsInfoList, ExtraAttr, Rating}
                            end;
                        #ets_goods_type{} ->
                            {fail, ?FAIL};
                        _ -> {fail, ?MISSING_CONFIG}
                    end;
                {false, Res} -> 
                    {fail, Res}
            end;
        _ ->
            {fail, ?ERRCODE(err151_buyer_times_limit)}
    end.
    


check_goods_base(PlayerId, GoodsId, GoodsNum, GoodsStatus) ->
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    if
        %% 物品不存在
        is_record(GoodsInfo, goods) =:= false orelse GoodsInfo#goods.id < 0 ->
            {false, ?ERRCODE(err150_no_goods)};
        %% 物品不属于你所有
        GoodsInfo#goods.player_id =/= PlayerId ->
            {false, ?ERRCODE(err150_palyer_err)};
        %% 物品不在背包
        GoodsInfo#goods.location =/= GoodsInfo#goods.bag_location ->
            {false, ?ERRCODE(err150_location_err)};
        %% 物品数量不正确
        GoodsNum < 1 orelse GoodsInfo#goods.num < GoodsNum ->
            {false, ?ERRCODE(err150_num_err)};
        true ->
            check_goods_can_sell(GoodsInfo, PlayerId)
    end.

check_goods_can_sell(GoodsInfo, _PlayerId) ->
    if
        %% 时效物品
        GoodsInfo#goods.expire_time > 0 ->
            {false, ?ERRCODE(err151_not_sell_category)};
        %% 本物品不可交易
        GoodsInfo#goods.trade =/= ?CAN_TRADE ->
            {false, ?ERRCODE(err151_not_sell_category)};
        %% 绑定物品不可交易
        GoodsInfo#goods.bind == ?BIND ->
            {false, ?ERRCODE(err151_bind_cannot_sell)};
        GoodsInfo#goods.other#goods_other.stren > 0 ->
            {false, ?ERRCODE(err151_not_sell_category)};
        true ->
            case data_goods_type:get(GoodsInfo#goods.goods_id) of
                #ets_goods_type{
                    sell_category = Category,
                    sell_subcategory = SubCategory
                } when Category > 0 andalso SubCategory > 0 ->
                    case data_sell:get_sub_category(Category) of
                        List when List =/= [] ->
                            case lists:member(SubCategory, List) of
                                true ->
                                    {true, GoodsInfo};
                                false ->
                                    {false, ?ERRCODE(err151_not_sell_category)}
                            end;
                        _ ->
                            {false, ?ERRCODE(err151_not_sell_category)}
                    end;
                _ -> {false, ?ERRCODE(err151_not_sell_category)}
            end
    end.



%% 检查是否有其他玩家指定出售物品给自己
check_anyone_sell2me([], _PlayerId) -> false;
check_anyone_sell2me([T|L], PlayerId) ->
    case check_anyone_sell2me_helper(T, PlayerId) of
        true -> true;
        _ ->
            check_anyone_sell2me(L, PlayerId)
    end.

check_anyone_sell2me_helper([], _PlayerId) -> false;
check_anyone_sell2me_helper([T|L], PlayerId) ->
    case T of
        #sell_goods{specify_id = PlayerId} -> true;
        _ ->
            check_anyone_sell2me_helper(L, PlayerId)
    end.

check({enough_money, PS, _GTypeId, _GoodsNum, UnitPrice, MoneyType}) ->
    Price = UnitPrice,
    case lib_goods_util:is_enough_money(PS, Price, MoneyType) of
        false -> {false, ?ERRCODE(err151_not_enough_gold)};
        true -> true
    end;

check({check_null_cells, GoodsTypeList}) when is_list(GoodsTypeList) ->
    case lib_goods_do:can_give_goods(GoodsTypeList) of
        true -> true;
        {false, ErrorCode} -> {false, ErrorCode}
    end;

check({check_sell_up_price, GTypeId, GoodsNum, UnitPrice}) ->
    IsCustomPriceGoods = data_goods:is_custom_price_goods(GTypeId),
    case IsCustomPriceGoods of 
        false ->
            UpPercent = data_sell:get_cfg(up_percent),
            DownPercent = data_sell:get_cfg(down_percent),
            Price = data_goods:get_base_price(GTypeId),
            MaxPrice = util:ceil(Price * (1 + UpPercent / 100)) * GoodsNum,
            MinPrice = util:floor(Price * (1 - DownPercent / 100)) * GoodsNum,
            NumLimOnce = data_goods:get_trade_num_max(GTypeId);
        _ ->
            [MinPrice, MaxPrice, NumLimOnce] = data_goods:get_custom_price_info(GTypeId)
    end,
    case GoodsNum =< NumLimOnce of 
        true ->
            case UnitPrice >= MinPrice of
                true ->
                    case UnitPrice =< MaxPrice of
                        true -> true;
                        _ ->
                            {false, {?ERRCODE(err151_max_unit_price_lim), [data_goods_type:get_name(GTypeId), MaxPrice]}}
                    end;
                _ ->
                    {false, {?ERRCODE(err151_min_unit_price_lim), [data_goods_type:get_name(GTypeId), MinPrice]}}
            end;
        _ -> 
            {false, {?ERRCODE(err151_sell_up_once_num_lim), [data_goods_type:get_name(GTypeId), NumLimOnce]}}
    end;

check({check_sell_up_gold_limit, PlayerId, RoleLv, ThisGold}) ->
    GetGoldMax = lib_sell:get_daily_get_gold_max(RoleLv),
    GoldGot = mod_daily:get_count_offline(PlayerId, ?MOD_SELL, 2),
    case GoldGot + ThisGold >= GetGoldMax of
        true -> {false, ?ERRCODE(err151_today_got_max_gold)};
        _ -> true
    end;

check({check_sell_up_gold_limit, PlayerId, RoleLv}) ->
    GetGoldMax = lib_sell:get_daily_get_gold_max(RoleLv),
    GoldGot = mod_daily:get_count_offline(PlayerId, ?MOD_SELL, 2),
    case GoldGot >= GetGoldMax of 
        true -> {false, ?ERRCODE(err151_today_got_max_gold)};
        _ -> true 
    end;

check({check_seller_gold_got_max, SellerId}) ->
    #figure{lv = RoleLv} = lib_role:get_role_figure(SellerId),
    GetGoldMax = lib_sell:get_daily_get_gold_max(RoleLv),
    GoldGot = mod_daily:get_count_offline(SellerId, ?MOD_SELL, 2),
    case GoldGot >= GetGoldMax of 
        true -> {false, ?ERRCODE(err151_seller_today_got_max_gold)};
        _ -> true 
    end;

check({check_payer_daily_quota, PS}) ->
    #player_status{id = PlayerId, figure = #figure{lv = RoleLv}} = PS,
    GoldMax = lib_sell:get_daily_get_gold_max(RoleLv),
    GoldCost = mod_daily:get_count_offline(PlayerId, ?MOD_SELL, 3),
    case GoldCost >= GoldMax of 
        true -> {false, ?ERRCODE(err151_today_got_max_gold)};
        _ -> true 
    end;

check(_) -> {false, ?FAIL}.

checklist([]) -> true;
checklist([H|T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.
