%%%---------------------------------------
%%% module      : data_goods_bag
%%% description : 背包容量配置
%%%
%%%---------------------------------------
-module(data_goods_bag).
-compile(export_all).
-include("goods.hrl").



get_equip_bag_limit(_RoleLv) when _RoleLv >= 1, _RoleLv < 9999 ->
		150;
get_equip_bag_limit(_RoleLv) ->
	300.

