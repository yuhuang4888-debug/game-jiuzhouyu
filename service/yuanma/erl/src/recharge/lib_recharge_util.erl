%% ---------------------------------------------------------------------------
%% @doc lib_recharge_util

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/2/22
%% @desc
%% ---------------------------------------------------------------------------
-module(lib_recharge_util).

%% API
-export([
    is_trigger_recharge_act/1,
    is_trigger_recharge_act/2,
    welfare_recharge/0,
    gift_recharge/1,
    verify_recharge_support/0,
    special_recharge_gold/3
]).

-export([
    check_recharge_direct_coin/2
]).

-include("rec_recharge.hrl").
-include("def_recharge.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_goods.hrl").

%% 判断是否触发充值活动
is_trigger_recharge_act(#base_recharge_product{product_type = ProductType, product_id = ProductId}) ->
    is_trigger_recharge_act(ProductId, ProductType).
is_trigger_recharge_act(ProductId, ProductType) ->
    ProductType == ?PRODUCT_TYPE_DIRECT_GIFT orelse
    ProductType == ?PRODUCT_TYPE_NORMAL orelse
    (ProductType == ?PRODUCT_TYPE_GIFT andalso lib_vsn:is_personal_exclusivity_recharge(ProductId)) orelse
    verify_recharge_support().

%% 福利充值审核服特殊处理
%% 审核服下。福利卡能作为普通充值（估计是运营以前遗留下的图方便问题，兼容下）
welfare_recharge() ->
    ?IF(config:get_is_shenhe(), normal, welfare).

%% 礼包充值审核服特殊处理
%% 审核服或者在英文服，充值类型用了礼包充值，确定就是运营图方便，以后类似添加锤运营，也兼容下
%% 英文零元礼包
gift_recharge(ProductId) ->
    ?IF(config:get_is_shenhe() orelse lib_vsn:is_personal_exclusivity_recharge(ProductId), normal, gift).

%% 是否支持审核类型充值
%% 审核服模式下支持审核类型充值，外文特殊渠道也支持审核类型充值，这个也是运营图方便，兼容下，后续继续要求就去锤
%% 越南三方充值
verify_recharge_support() ->
    config:get_is_shenhe() orelse lib_vsn:is_pay_product_verify().

%% 某些充值类型（非普通充值，比如像是某些特定渠道的礼包充值或者审核充值能达到普通充值的效果，渠道特定的充值面额）需要特殊处理下钻石
special_recharge_gold(ProductId, ProductType, Gold) ->
    IsShenHe = config:get_is_shenhe(),
    IsPayVerify = lib_vsn:is_pay_product_verify(),
    IsPersonalRecharge = lib_vsn:is_personal_exclusivity_recharge(ProductId),
    if
        % 审核服下，php映射配置的的钻石直接返回
        ProductType =/= ?PRODUCT_TYPE_DIRECT_GIFT, IsShenHe -> Gold;
        % 审核充值类型，在允许充值审核的渠道直接返回
        ProductType == ?PRODUCT_TYPE_VERIFY andalso IsPayVerify -> Gold;
        % 英文服充值特殊处理
        ProductType == ?PRODUCT_TYPE_GIFT andalso IsPersonalRecharge -> Gold;
        % 福利卡/礼包充值 不触发钻石充值额度
        ProductType =:= ?PRODUCT_TYPE_WELFARE orelse ProductType =:= ?PRODUCT_TYPE_GIFT -> 0;
        % 直购礼包，买了之后不会获取钻石，但是会获取充值钻石额度
        ProductType =:= ?PRODUCT_TYPE_DIRECT_GIFT -> data_recharge:get_value_of_gold(ProductId);
        true -> Gold
    end.

%% 直购币使用检查
check_recharge_direct_coin(PS, ProductId) ->
    case lib_recharge_check:check_product(ProductId) of
        {true, Product} ->
            #base_recharge_product{product_type = ProductTpe, money = Money} = Product,
            IsSatisfy = ProductTpe == ?PRODUCT_TYPE_DIRECT_GIFT orelse ProductTpe == ?PRODUCT_TYPE_GIFT,
            Cost = [{?TYPE_GOODS, ?GOODS_ID_RECHARGE_COIN, util:ceil(Money)}], % 兼容Money小数的情况
            case lib_goods_api:check_object_list(PS, Cost) of
                _ when not IsSatisfy -> {false, ?FAIL};
                true -> {true, Cost, Product};
                ErrInfo -> ErrInfo
            end;
        {false, Errcode} -> {false, Errcode};
        _ -> {false, ?FAIL}
    end.