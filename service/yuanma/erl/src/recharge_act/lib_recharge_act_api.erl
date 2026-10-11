%% ---------------------------------------------------------------------------
%% @doc    充值活动api
%% @author xiaoxiang
%% @since  2017-06-27
%% @deprecated 
%% ---------------------------------------------------------------------------

-module(lib_recharge_act_api).
-include("def_recharge.hrl").
-include("rec_recharge.hrl").
-include("errcode.hrl").
-export([can_recharge/2]).


can_recharge(Player, ProductId) ->
    #base_recharge_product{ product_type = ProductType} = lib_recharge_check:get_product(ProductId), 
    case ProductType of
        %% ?PRODUCT_TYPE_FUND ->
        %%     lib_recharge_act:can_recharge(Player, ProductId, ProductType);
        ?PRODUCT_TYPE_WELFARE ->
            lib_recharge_act:can_recharge(Player, ProductId, ProductType);
        _ ->
            {false, ?ERRCODE(err158_product_type_error)}
    end.
