%%%---------------------------------------
%%% module      : data_sys_sell
%%% description : 系统出售配置
%%%
%%%---------------------------------------
-module(data_sys_sell).
-compile(export_all).
-include("rec_sell.hrl").



get_sys_sell_by_openday() ->
[{38240101,5,14},{38240101,15,30},{38240101,31,9999},{38240102,5,14},{38240102,15,30},{38240102,31,9999},{38240201,5,10},{38240201,11,20},{38240201,21,40},{38240201,41,9999}].

get_sys_sell(38240101,_OpenDay) when _OpenDay >= 5, _OpenDay =< 14 ->
	#base_sys_sell{goods_id=38240101,open_day1=5,open_day2=14,price=6,group_num=5,num=[{3,30}],replenish=60};
get_sys_sell(38240101,_OpenDay) when _OpenDay >= 15, _OpenDay =< 30 ->
	#base_sys_sell{goods_id=38240101,open_day1=15,open_day2=30,price=5,group_num=5,num=[{3,30}],replenish=60};
get_sys_sell(38240101,_OpenDay) when _OpenDay >= 31, _OpenDay =< 9999 ->
	#base_sys_sell{goods_id=38240101,open_day1=31,open_day2=9999,price=4,group_num=5,num=[{3,30}],replenish=60};
get_sys_sell(38240102,_OpenDay) when _OpenDay >= 5, _OpenDay =< 14 ->
	#base_sys_sell{goods_id=38240102,open_day1=5,open_day2=14,price=6,group_num=5,num=[{3,30}],replenish=60};
get_sys_sell(38240102,_OpenDay) when _OpenDay >= 15, _OpenDay =< 30 ->
	#base_sys_sell{goods_id=38240102,open_day1=15,open_day2=30,price=5,group_num=5,num=[{3,30}],replenish=60};
get_sys_sell(38240102,_OpenDay) when _OpenDay >= 31, _OpenDay =< 9999 ->
	#base_sys_sell{goods_id=38240102,open_day1=31,open_day2=9999,price=4,group_num=5,num=[{3,30}],replenish=60};
get_sys_sell(38240201,_OpenDay) when _OpenDay >= 5, _OpenDay =< 10 ->
	#base_sys_sell{goods_id=38240201,open_day1=5,open_day2=10,price=20,group_num=5,num=[{3,30}],replenish=60};
get_sys_sell(38240201,_OpenDay) when _OpenDay >= 11, _OpenDay =< 20 ->
	#base_sys_sell{goods_id=38240201,open_day1=11,open_day2=20,price=15,group_num=5,num=[{3,30}],replenish=60};
get_sys_sell(38240201,_OpenDay) when _OpenDay >= 21, _OpenDay =< 40 ->
	#base_sys_sell{goods_id=38240201,open_day1=21,open_day2=40,price=10,group_num=5,num=[{3,30}],replenish=60};
get_sys_sell(38240201,_OpenDay) when _OpenDay >= 41, _OpenDay =< 9999 ->
	#base_sys_sell{goods_id=38240201,open_day1=41,open_day2=9999,price=8,group_num=5,num=[{3,30}],replenish=60};
get_sys_sell(_Goods_id,_OpenDay) ->
	[].

