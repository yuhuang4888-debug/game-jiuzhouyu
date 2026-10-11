%%%---------------------------------------
%%% module      : data_rush_shop
%%% description : 抢购商城配置
%%%
%%%---------------------------------------
-module(data_rush_shop).
-compile(export_all).
-include("rush_shop.hrl").



get_goods_info(1) ->
	#rush_shop_goods{id = 1,goods_id = 37010003,default_num = 5,price_type = 1,price = 50,limit_price = 20,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 1,open_end = 1,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(2) ->
	#rush_shop_goods{id = 2,goods_id = 37010003,default_num = 5,price_type = 1,price = 50,limit_price = 30,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 1,open_end = 1,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(3) ->
	#rush_shop_goods{id = 3,goods_id = 37010004,default_num = 5,price_type = 1,price = 150,limit_price = 100,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 1,open_end = 1,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(4) ->
	#rush_shop_goods{id = 4,goods_id = 37010004,default_num = 5,price_type = 1,price = 150,limit_price = 120,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 1,open_end = 1,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(5) ->
	#rush_shop_goods{id = 5,goods_id = 37010005,default_num = 5,price_type = 1,price = 300,limit_price = 200,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 1,open_end = 1,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(6) ->
	#rush_shop_goods{id = 6,goods_id = 37010006,default_num = 3,price_type = 1,price = 450,limit_price = 300,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 1,open_end = 1,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(7) ->
	#rush_shop_goods{id = 7,goods_id = 37010003,default_num = 5,price_type = 1,price = 50,limit_price = 20,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 2,open_end = 2,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(8) ->
	#rush_shop_goods{id = 8,goods_id = 37010003,default_num = 5,price_type = 1,price = 50,limit_price = 30,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 2,open_end = 2,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(9) ->
	#rush_shop_goods{id = 9,goods_id = 37010004,default_num = 5,price_type = 1,price = 150,limit_price = 100,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 2,open_end = 2,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(10) ->
	#rush_shop_goods{id = 10,goods_id = 37010004,default_num = 5,price_type = 1,price = 150,limit_price = 120,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 2,open_end = 2,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(11) ->
	#rush_shop_goods{id = 11,goods_id = 37010005,default_num = 5,price_type = 1,price = 300,limit_price = 200,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 2,open_end = 2,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(12) ->
	#rush_shop_goods{id = 12,goods_id = 37010006,default_num = 3,price_type = 1,price = 450,limit_price = 300,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 2,open_end = 2,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(13) ->
	#rush_shop_goods{id = 13,goods_id = 16020001,default_num = 5,price_type = 1,price = 50,limit_price = 25,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 3,open_end = 3,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(14) ->
	#rush_shop_goods{id = 14,goods_id = 16020001,default_num = 20,price_type = 1,price = 200,limit_price = 120,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 3,open_end = 3,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(15) ->
	#rush_shop_goods{id = 15,goods_id = 16020002,default_num = 6,price_type = 1,price = 300,limit_price = 210,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 3,open_end = 3,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(16) ->
	#rush_shop_goods{id = 16,goods_id = 16010001,default_num = 1,price_type = 1,price = 200,limit_price = 100,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 3,open_end = 3,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(17) ->
	#rush_shop_goods{id = 17,goods_id = 16020002,default_num = 15,price_type = 1,price = 750,limit_price = 560,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 3,open_end = 3,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(18) ->
	#rush_shop_goods{id = 18,goods_id = 16020002,default_num = 30,price_type = 1,price = 1500,limit_price = 1200,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 3,open_end = 3,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(19) ->
	#rush_shop_goods{id = 19,goods_id = 17020001,default_num = 5,price_type = 1,price = 50,limit_price = 25,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 4,open_end = 4,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(20) ->
	#rush_shop_goods{id = 20,goods_id = 17020001,default_num = 20,price_type = 1,price = 200,limit_price = 120,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 4,open_end = 4,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(21) ->
	#rush_shop_goods{id = 21,goods_id = 17020002,default_num = 6,price_type = 1,price = 300,limit_price = 210,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 4,open_end = 4,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(22) ->
	#rush_shop_goods{id = 22,goods_id = 17010001,default_num = 1,price_type = 1,price = 200,limit_price = 100,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 4,open_end = 4,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(23) ->
	#rush_shop_goods{id = 23,goods_id = 17020002,default_num = 15,price_type = 1,price = 750,limit_price = 560,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 4,open_end = 4,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(24) ->
	#rush_shop_goods{id = 24,goods_id = 17020002,default_num = 30,price_type = 1,price = 1500,limit_price = 1200,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 4,open_end = 4,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(25) ->
	#rush_shop_goods{id = 25,goods_id = 32010114,default_num = 2,price_type = 1,price = 100,limit_price = 30,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 5,open_end = 5,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(26) ->
	#rush_shop_goods{id = 26,goods_id = 32010114,default_num = 5,price_type = 1,price = 250,limit_price = 100,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 5,open_end = 5,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(27) ->
	#rush_shop_goods{id = 27,goods_id = 32010114,default_num = 10,price_type = 1,price = 500,limit_price = 250,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 5,open_end = 5,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(28) ->
	#rush_shop_goods{id = 28,goods_id = 36255006,default_num = 2,price_type = 1,price = 300,limit_price = 150,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 5,open_end = 5,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(29) ->
	#rush_shop_goods{id = 29,goods_id = 36255006,default_num = 5,price_type = 1,price = 750,limit_price = 450,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 5,open_end = 5,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(30) ->
	#rush_shop_goods{id = 30,goods_id = 36255006,default_num = 10,price_type = 1,price = 1500,limit_price = 1050,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 5,open_end = 5,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(31) ->
	#rush_shop_goods{id = 31,goods_id = 14010003,default_num = 1,price_type = 1,price = 180,limit_price = 60,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 6,open_end = 6,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(32) ->
	#rush_shop_goods{id = 32,goods_id = 14020003,default_num = 1,price_type = 1,price = 180,limit_price = 60,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 6,open_end = 6,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(33) ->
	#rush_shop_goods{id = 33,goods_id = 14010004,default_num = 1,price_type = 1,price = 540,limit_price = 240,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 6,open_end = 6,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(34) ->
	#rush_shop_goods{id = 34,goods_id = 14020004,default_num = 1,price_type = 1,price = 540,limit_price = 240,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 6,open_end = 6,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(35) ->
	#rush_shop_goods{id = 35,goods_id = 14010005,default_num = 1,price_type = 1,price = 1620,limit_price = 888,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 6,open_end = 6,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(36) ->
	#rush_shop_goods{id = 36,goods_id = 14020005,default_num = 1,price_type = 1,price = 1620,limit_price = 888,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 6,open_end = 6,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(37) ->
	#rush_shop_goods{id = 37,goods_id = 20020003,default_num = 1,price_type = 1,price = 300,limit_price = 120,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 7,open_end = 7,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(38) ->
	#rush_shop_goods{id = 38,goods_id = 20020003,default_num = 2,price_type = 1,price = 600,limit_price = 300,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 7,open_end = 7,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(39) ->
	#rush_shop_goods{id = 39,goods_id = 20020003,default_num = 5,price_type = 1,price = 1500,limit_price = 900,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 7,open_end = 7,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(40) ->
	#rush_shop_goods{id = 40,goods_id = 20010001,default_num = 1,price_type = 1,price = 500,limit_price = 250,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 7,open_end = 7,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(41) ->
	#rush_shop_goods{id = 41,goods_id = 20010002,default_num = 1,price_type = 1,price = 500,limit_price = 300,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 7,open_end = 7,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(42) ->
	#rush_shop_goods{id = 42,goods_id = 20010003,default_num = 1,price_type = 1,price = 3000,limit_price = 2400,refresh = 0,daily_limit_num = 1,total_limit_num = 99999,open_begin = 7,open_end = 7,merge_begin = 0,merge_end = 0,act_begin = 0,act_end = 0,open_switch = 1,merge_switch = 0,expire_time = 0};

get_goods_info(_Id) ->
	[].

get_all_goods() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42].

