%% ---------------------------------------------------------------------------
%% @doc    充值系统 - 关联商品参考例子
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------

-module (lib_recharge_product_example).
-include ("common.hrl").
-include ("rec_recharge.hrl").
-include ("def_recharge.hrl").
-include ("def_event.hrl").
-include ("rec_event.hrl").
-include ("errcode.hrl").
-include ("def_fun.hrl").
-export ([
	handle_event/2, 			%% 处理充值回调事件
	handle_product/2 			%% 处理商品逻辑
]).

%%%----------------------------------------------------------------------
%%% Usage: 
%%% 1.关联商品模块添加 handle_event/2, handle_product/2
%%%   分别处理充值回调事件，实现商品逻辑
%%%----------------------------------------------------------------------

%% 处理充值回调事件 -- 普通充值
handle_event(PS, 
	#event_callback{
		type_id = ?EVENT_RECHARGE, 
		data 	= #callback_recharge_data{
			recharge_product = #base_recharge_product{
				product_id 	 = ProductId,
				product_type = ?PRODUCT_TYPE_NORMAL
			} = _Product,
			associate_ids = AssociateIds
		}
	}) ->
		{ok, NewPS} = handle_product(PS, ProductId),
		{ok, LastPS} = lib_recharge:handle_associate_product(NewPS, AssociateIds),
		{ok, LastPS};
handle_event(PS, _) ->
	{ok, PS}.

%% 处理商品逻辑
handle_product(PS, ProductId) when is_integer(ProductId) ->
	case lib_recharge_check:check_product(ProductId) of
		{true, Product} -> handle_product(PS, Product);
		_ -> {ok, PS}
	end;

handle_product(PS, Product) ->
	#base_recharge_product{
	        product_id      = ProductId,
	        product_type    = _ProductType, 
	        product_subtype = _ProductSubType
    } = Product,		
    case data_recharge:get_recharge_return(ProductId, 1) of
    	#base_recharge_return{return_type = 0} ->
    		%% TODO :以下处理商品详细逻辑 
    		{ok, PS};
    	#base_recharge_return{return_type = 1} ->
    		%% TODO : 
    		{ok, PS};
    	#base_recharge_return{return_type = 2} -> 
    		%% TODO : 
    		{ok, PS};
    	_ -> 
    		{ok, PS}
    end.
