%%%---------------------------------------
%%% module      : data_quick_buy
%%% description : 快速购买配置
%%%
%%%---------------------------------------
-module(data_quick_buy).
-compile(export_all).
-include("goods.hrl").



get_quick_buy_price(16020001) ->
	#quick_buy_price{goods_type_id = 16020001,gold_price = 10,bgold_price = 10};

get_quick_buy_price(17020001) ->
	#quick_buy_price{goods_type_id = 17020001,gold_price = 10,bgold_price = 10};

get_quick_buy_price(18020001) ->
	#quick_buy_price{goods_type_id = 18020001,gold_price = 10,bgold_price = 10};

get_quick_buy_price(19020001) ->
	#quick_buy_price{goods_type_id = 19020001,gold_price = 10,bgold_price = 10};

get_quick_buy_price(25020001) ->
	#quick_buy_price{goods_type_id = 25020001,gold_price = 10,bgold_price = 10};

get_quick_buy_price(36255004) ->
	#quick_buy_price{goods_type_id = 36255004,gold_price = 50,bgold_price = 0};

get_quick_buy_price(36255005) ->
	#quick_buy_price{goods_type_id = 36255005,gold_price = 20,bgold_price = 0};

get_quick_buy_price(36255006) ->
	#quick_buy_price{goods_type_id = 36255006,gold_price = 150,bgold_price = 0};

get_quick_buy_price(36255007) ->
	#quick_buy_price{goods_type_id = 36255007,gold_price = 20,bgold_price = 0};

get_quick_buy_price(36255008) ->
	#quick_buy_price{goods_type_id = 36255008,gold_price = 40,bgold_price = 0};

get_quick_buy_price(36255009) ->
	#quick_buy_price{goods_type_id = 36255009,gold_price = 40,bgold_price = 0};

get_quick_buy_price(36255016) ->
	#quick_buy_price{goods_type_id = 36255016,gold_price = 30,bgold_price = 0};

get_quick_buy_price(36255018) ->
	#quick_buy_price{goods_type_id = 36255018,gold_price = 20,bgold_price = 0};

get_quick_buy_price(36255021) ->
	#quick_buy_price{goods_type_id = 36255021,gold_price = 1,bgold_price = 0};

get_quick_buy_price(36255028) ->
	#quick_buy_price{goods_type_id = 36255028,gold_price = 40,bgold_price = 0};

get_quick_buy_price(36255031) ->
	#quick_buy_price{goods_type_id = 36255031,gold_price = 1,bgold_price = 0};

get_quick_buy_price(36255036) ->
	#quick_buy_price{goods_type_id = 36255036,gold_price = 50,bgold_price = 0};

get_quick_buy_price(36255038) ->
	#quick_buy_price{goods_type_id = 36255038,gold_price = 15,bgold_price = 0};

get_quick_buy_price(36255049) ->
	#quick_buy_price{goods_type_id = 36255049,gold_price = 1,bgold_price = 0};

get_quick_buy_price(36255102) ->
	#quick_buy_price{goods_type_id = 36255102,gold_price = 40,bgold_price = 0};

get_quick_buy_price(37020001) ->
	#quick_buy_price{goods_type_id = 37020001,gold_price = 15,bgold_price = 15};

get_quick_buy_price(37100001) ->
	#quick_buy_price{goods_type_id = 37100001,gold_price = 50,bgold_price = 0};

get_quick_buy_price(37120001) ->
	#quick_buy_price{goods_type_id = 37120001,gold_price = 1,bgold_price = 0};

get_quick_buy_price(38030001) ->
	#quick_buy_price{goods_type_id = 38030001,gold_price = 40,bgold_price = 40};

get_quick_buy_price(38030006) ->
	#quick_buy_price{goods_type_id = 38030006,gold_price = 150,bgold_price = 150};

get_quick_buy_price(38040001) ->
	#quick_buy_price{goods_type_id = 38040001,gold_price = 10,bgold_price = 10};

get_quick_buy_price(38040005) ->
	#quick_buy_price{goods_type_id = 38040005,gold_price = 1,bgold_price = 1};

get_quick_buy_price(38040027) ->
	#quick_buy_price{goods_type_id = 38040027,gold_price = 100,bgold_price = 0};

get_quick_buy_price(38040073) ->
	#quick_buy_price{goods_type_id = 38040073,gold_price = 30,bgold_price = 0};

get_quick_buy_price(38180013) ->
	#quick_buy_price{goods_type_id = 38180013,gold_price = 40,bgold_price = 0};

get_quick_buy_price(38220001) ->
	#quick_buy_price{goods_type_id = 38220001,gold_price = 30,bgold_price = 0};

get_quick_buy_price(38220002) ->
	#quick_buy_price{goods_type_id = 38220002,gold_price = 1,bgold_price = 0};

get_quick_buy_price(38250026) ->
	#quick_buy_price{goods_type_id = 38250026,gold_price = 10,bgold_price = 0};

get_quick_buy_price(53010001) ->
	#quick_buy_price{goods_type_id = 53010001,gold_price = 50,bgold_price = 0};

get_quick_buy_price(1102015064) ->
	#quick_buy_price{goods_type_id = 1102015064,gold_price = 18,bgold_price = 0};

get_quick_buy_price(_Goodstypeid) ->
	[].

