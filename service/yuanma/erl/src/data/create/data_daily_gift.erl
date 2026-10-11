%%%---------------------------------------
%%% module      : data_daily_gift
%%% description : 每日礼包
%%%
%%%---------------------------------------
-module(data_daily_gift).
-compile(export_all).
-include("recharge_act.hrl").



get_daily_gift(10) ->
	#base_recharge_daily_gift{product_id = 10,level = 1,value = 0,reward = [{0,400005,1}]};

get_daily_gift(_Productid) ->
	[].

get_daily_gift_ids() ->
[10].

