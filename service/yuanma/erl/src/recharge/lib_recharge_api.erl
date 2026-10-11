%% ---------------------------------------------------------------------------
%% @doc    充值系统对外api
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------

-module (lib_recharge_api).
-include ("predefine.hrl").
-include("rec_recharge.hrl").
-include("def_recharge.hrl").

-export ([
	nofity_pay/1, 					%% 通知充值入账游戏服务器
	notify_handle_all_orders/0		%% 通知处理一批待处理的充值订单
]).

-export ([
	get_total/1,  					%% 获取充值总额
	get_today_pay_gold/1 			%% 获取玩家当天充值元宝量
	,get_today_pay_rmb/1
	, is_trigger_recharge_act/1		%% 是否累计与充值活动
	, is_trigger_recharge_act/2		%% 是否累计与充值活动
	, special_recharge_gold/2		%%
	, change_recharge_type/2		%% 充值类型特殊处理
]).


%% 通知充值入账游戏服务器
nofity_pay(PlayerId) ->
	lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_recharge, pay, []),
	ok.

%% 通知处理一批待处理的充值订单
notify_handle_all_orders() ->
	lib_recharge:notify_handle_all_orders(),
	ok.

%% 获取充值总额
get_total(PlayerId) ->
	lib_recharge_data:get_total(PlayerId).

%% 获取玩家当天充值量
get_today_pay_gold(PlayerId) ->
	lib_recharge_data:get_today_pay_gold(PlayerId).

%% 获取玩家当天充值量  人民币
get_today_pay_rmb(PlayerId) ->
	lib_recharge_data:get_today_pay_rmb(PlayerId).

%% 判断是否触发充值活动
is_trigger_recharge_act(Product) ->
	lib_recharge_util:is_trigger_recharge_act(Product).
is_trigger_recharge_act(ProductId, ProductType) ->
	lib_recharge_util:is_trigger_recharge_act(ProductId, ProductType).

%% 某些充值类型（非普通充值，比如像是某些特定渠道的礼包充值或者审核充值能达到普通充值的效果，渠道特定的充值面额）需要特殊处理下钻石
special_recharge_gold(#base_recharge_product{product_id = ProductId, product_type = ProductType}, Gold) ->
	lib_recharge_util:special_recharge_gold(ProductId, ProductType, Gold).

%% 特殊充值类型特殊处理
%% 某些特定渠道的特定充值类型需要当成普通充值类型处理
change_recharge_type(ProductId, ProductType) ->
	IsPayVerify = lib_vsn:is_pay_product_verify(),
	IsPersonalRecharge = lib_vsn:is_personal_exclusivity_recharge(ProductId),
	if
		ProductType == ?PRODUCT_TYPE_VERIFY andalso IsPayVerify -> ?PRODUCT_TYPE_NORMAL;
		ProductType == ?PRODUCT_TYPE_GIFT andalso IsPersonalRecharge -> ?PRODUCT_TYPE_NORMAL;
		ProductType == ?PRODUCT_TYPE_DIRECT_GIFT -> ?PRODUCT_TYPE_NORMAL;
		true -> ProductType
	end.

%% -------------------------------------------------------------------
%%  local function 
%% -------------------------------------------------------------------

