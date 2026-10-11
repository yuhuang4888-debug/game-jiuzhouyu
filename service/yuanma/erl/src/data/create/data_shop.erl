%%%---------------------------------------
%%% module      : data_shop
%%% description : 商城配置
%%%
%%%---------------------------------------
-module(data_shop).
-compile(export_all).
-include("shop.hrl").



get_shop_config(1001) ->
	#shop{key_id = 1001,shop_type = 1,shop_subtype_list = [],career = [],rank = 5,goods_id = 32010107,num = 1,ctype = 1,price = 80,discount = 100,quota_type = 2,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 1001,bind = 1,turn = []};

get_shop_config(1002) ->
	#shop{key_id = 1002,shop_type = 1,shop_subtype_list = [],career = [],rank = 6,goods_id = 32010127,num = 1,ctype = 1,price = 60,discount = 100,quota_type = 2,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 1002,bind = 1,turn = []};

get_shop_config(1003) ->
	#shop{key_id = 1003,shop_type = 1,shop_subtype_list = [],career = [],rank = 7,goods_id = 19020003,num = 1,ctype = 1,price = 60,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{vip,1}],counter_module = 153,counter_id = 1003,bind = 1,turn = []};

get_shop_config(1004) ->
	#shop{key_id = 1004,shop_type = 1,shop_subtype_list = [],career = [],rank = 8,goods_id = 18020003,num = 1,ctype = 1,price = 60,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{vip,1}],counter_module = 153,counter_id = 1004,bind = 1,turn = []};

get_shop_config(1005) ->
	#shop{key_id = 1005,shop_type = 1,shop_subtype_list = [],career = [],rank = 10,goods_id = 16020001,num = 20,ctype = 1,price = 100,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{vip,1}],counter_module = 153,counter_id = 1005,bind = 1,turn = []};

get_shop_config(1006) ->
	#shop{key_id = 1006,shop_type = 1,shop_subtype_list = [],career = [],rank = 11,goods_id = 17020001,num = 20,ctype = 1,price = 100,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{vip,1}],counter_module = 153,counter_id = 1006,bind = 1,turn = []};

get_shop_config(1007) ->
	#shop{key_id = 1007,shop_type = 1,shop_subtype_list = [],career = [],rank = 12,goods_id = 14010004,num = 1,ctype = 1,price = 325,discount = 100,quota_type = 2,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{vip,4}],counter_module = 153,counter_id = 1007,bind = 1,turn = []};

get_shop_config(1008) ->
	#shop{key_id = 1008,shop_type = 1,shop_subtype_list = [],career = [],rank = 13,goods_id = 14020004,num = 1,ctype = 1,price = 325,discount = 100,quota_type = 2,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{vip,4}],counter_module = 153,counter_id = 1008,bind = 1,turn = []};

get_shop_config(1009) ->
	#shop{key_id = 1009,shop_type = 1,shop_subtype_list = [],career = [],rank = 9,goods_id = 38040005,num = 100,ctype = 1,price = 40,discount = 100,quota_type = 2,quota_num = 20,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,260,9999}],counter_module = 153,counter_id = 1009,bind = 1,turn = []};

get_shop_config(1010) ->
	#shop{key_id = 1010,shop_type = 1,shop_subtype_list = [],career = [],rank = 1,goods_id = 38370002,num = 1,ctype = 1,price = 50,discount = 100,quota_type = 2,quota_num = 5,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,320,9999}],counter_module = 153,counter_id = 1010,bind = 1,turn = []};

get_shop_config(1011) ->
	#shop{key_id = 1011,shop_type = 1,shop_subtype_list = [],career = [],rank = 4,goods_id = 38040044,num = 1,ctype = 1,price = 40,discount = 100,quota_type = 2,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,100,9999},{vip,1}],counter_module = 153,counter_id = 1011,bind = 1,turn = []};

get_shop_config(1012) ->
	#shop{key_id = 1012,shop_type = 1,shop_subtype_list = [],career = [],rank = 2,goods_id = 37110001,num = 1,ctype = 1,price = 50,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,9999},{vip,4}],counter_module = 153,counter_id = 1012,bind = 1,turn = []};

get_shop_config(1013) ->
	#shop{key_id = 1013,shop_type = 1,shop_subtype_list = [],career = [],rank = 3,goods_id = 38340002,num = 1,ctype = 2,price = 20,discount = 100,quota_type = 1,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,200,9999}],counter_module = 153,counter_id = 1013,bind = 1,turn = []};

get_shop_config(2001) ->
	#shop{key_id = 2001,shop_type = 2,shop_subtype_list = [1],career = [],rank = 5,goods_id = 38070001,num = 1,ctype = 1,price = 25,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2002) ->
	#shop{key_id = 2002,shop_type = 2,shop_subtype_list = [1],career = [],rank = 6,goods_id = 38040013,num = 1,ctype = 1,price = 380,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2003) ->
	#shop{key_id = 2003,shop_type = 2,shop_subtype_list = [1],career = [],rank = 7,goods_id = 38040014,num = 1,ctype = 1,price = 288,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2004) ->
	#shop{key_id = 2004,shop_type = 2,shop_subtype_list = [1],career = [],rank = 8,goods_id = 38210001,num = 1,ctype = 1,price = 300,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2005) ->
	#shop{key_id = 2005,shop_type = 2,shop_subtype_list = [1],career = [],rank = 9,goods_id = 38100006,num = 1,ctype = 1,price = 599,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2006) ->
	#shop{key_id = 2006,shop_type = 2,shop_subtype_list = [1],career = [],rank = 10,goods_id = 38100003,num = 1,ctype = 1,price = 99,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2007) ->
	#shop{key_id = 2007,shop_type = 2,shop_subtype_list = [1],career = [],rank = 11,goods_id = 38030001,num = 1,ctype = 1,price = 40,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2008) ->
	#shop{key_id = 2008,shop_type = 2,shop_subtype_list = [1],career = [],rank = 12,goods_id = 38030003,num = 1,ctype = 1,price = 80,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2009) ->
	#shop{key_id = 2009,shop_type = 2,shop_subtype_list = [1],career = [],rank = 13,goods_id = 38030004,num = 1,ctype = 1,price = 80,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2010) ->
	#shop{key_id = 2010,shop_type = 2,shop_subtype_list = [1],career = [],rank = 14,goods_id = 37020001,num = 1,ctype = 1,price = 15,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2011) ->
	#shop{key_id = 2011,shop_type = 2,shop_subtype_list = [1],career = [],rank = 15,goods_id = 36255006,num = 1,ctype = 1,price = 150,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2012) ->
	#shop{key_id = 2012,shop_type = 2,shop_subtype_list = [1],career = [],rank = 16,goods_id = 36255007,num = 1,ctype = 1,price = 20,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2013) ->
	#shop{key_id = 2013,shop_type = 2,shop_subtype_list = [1],career = [],rank = 18,goods_id = 38110015,num = 1,ctype = 1,price = 10,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = [{trigger_task, 301201}]};

get_shop_config(2014) ->
	#shop{key_id = 2014,shop_type = 2,shop_subtype_list = [1],career = [],rank = 19,goods_id = 38110016,num = 1,ctype = 1,price = 10,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = [{trigger_task, 301203}]};

get_shop_config(2015) ->
	#shop{key_id = 2015,shop_type = 2,shop_subtype_list = [1],career = [],rank = 20,goods_id = 38110017,num = 1,ctype = 1,price = 20,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = [{trigger_task, 301301}]};

get_shop_config(2016) ->
	#shop{key_id = 2016,shop_type = 2,shop_subtype_list = [1],career = [],rank = 21,goods_id = 38110018,num = 1,ctype = 1,price = 20,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = [{trigger_task, 301303}]};

get_shop_config(2017) ->
	#shop{key_id = 2017,shop_type = 2,shop_subtype_list = [1],career = [],rank = 22,goods_id = 38110001,num = 1,ctype = 1,price = 15,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = [{trigger_task, 301400}]};

get_shop_config(2018) ->
	#shop{key_id = 2018,shop_type = 2,shop_subtype_list = [1],career = [],rank = 23,goods_id = 38110002,num = 1,ctype = 1,price = 15,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = [{trigger_task, 301500}]};

get_shop_config(2019) ->
	#shop{key_id = 2019,shop_type = 2,shop_subtype_list = [1],career = [],rank = 24,goods_id = 38110003,num = 1,ctype = 1,price = 20,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = [{trigger_task, 301500}]};

get_shop_config(2020) ->
	#shop{key_id = 2020,shop_type = 2,shop_subtype_list = [1],career = [],rank = 25,goods_id = 38110004,num = 1,ctype = 1,price = 25,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = [{trigger_task, 301500}]};

get_shop_config(2021) ->
	#shop{key_id = 2021,shop_type = 2,shop_subtype_list = [4],career = [],rank = 401,goods_id = 37050003,num = 250,ctype = 1,price = 100,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2022) ->
	#shop{key_id = 2022,shop_type = 2,shop_subtype_list = [4],career = [],rank = 402,goods_id = 79070501,num = 1,ctype = 1,price = 1200,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2023) ->
	#shop{key_id = 2023,shop_type = 2,shop_subtype_list = [4],career = [],rank = 403,goods_id = 79080501,num = 1,ctype = 1,price = 1200,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2024) ->
	#shop{key_id = 2024,shop_type = 2,shop_subtype_list = [4],career = [],rank = 404,goods_id = 79090501,num = 1,ctype = 1,price = 1500,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2025) ->
	#shop{key_id = 2025,shop_type = 2,shop_subtype_list = [4],career = [],rank = 405,goods_id = 79070502,num = 1,ctype = 1,price = 1500,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,2}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2026) ->
	#shop{key_id = 2026,shop_type = 2,shop_subtype_list = [4],career = [],rank = 406,goods_id = 79080502,num = 1,ctype = 1,price = 1500,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,2}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2027) ->
	#shop{key_id = 2027,shop_type = 2,shop_subtype_list = [4],career = [],rank = 407,goods_id = 79090502,num = 1,ctype = 1,price = 1800,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,2}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2028) ->
	#shop{key_id = 2028,shop_type = 2,shop_subtype_list = [4],career = [],rank = 408,goods_id = 79070503,num = 1,ctype = 1,price = 2000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,3}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2029) ->
	#shop{key_id = 2029,shop_type = 2,shop_subtype_list = [4],career = [],rank = 409,goods_id = 79080503,num = 1,ctype = 1,price = 2000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,3}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2030) ->
	#shop{key_id = 2030,shop_type = 2,shop_subtype_list = [4],career = [],rank = 410,goods_id = 79090503,num = 1,ctype = 1,price = 2300,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,3}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2031) ->
	#shop{key_id = 2031,shop_type = 2,shop_subtype_list = [4],career = [],rank = 411,goods_id = 79070504,num = 1,ctype = 1,price = 2500,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,4}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2032) ->
	#shop{key_id = 2032,shop_type = 2,shop_subtype_list = [4],career = [],rank = 412,goods_id = 79080504,num = 1,ctype = 1,price = 2500,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,4}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2033) ->
	#shop{key_id = 2033,shop_type = 2,shop_subtype_list = [4],career = [],rank = 413,goods_id = 79090504,num = 1,ctype = 1,price = 3000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,4}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2034) ->
	#shop{key_id = 2034,shop_type = 2,shop_subtype_list = [4],career = [],rank = 414,goods_id = 79070505,num = 1,ctype = 1,price = 2800,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,5}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2035) ->
	#shop{key_id = 2035,shop_type = 2,shop_subtype_list = [4],career = [],rank = 415,goods_id = 79080505,num = 1,ctype = 1,price = 2800,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,5}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2036) ->
	#shop{key_id = 2036,shop_type = 2,shop_subtype_list = [4],career = [],rank = 416,goods_id = 79090505,num = 1,ctype = 1,price = 3300,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580},{constellation_equip,5}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2037) ->
	#shop{key_id = 2037,shop_type = 2,shop_subtype_list = [1],career = [],rank = 26,goods_id = 38110005,num = 1,ctype = 1,price = 50,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = [{trigger_task, 301600}]};

get_shop_config(2038) ->
	#shop{key_id = 2038,shop_type = 2,shop_subtype_list = [1],career = [],rank = 27,goods_id = 38110009,num = 1,ctype = 1,price = 50,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = [{trigger_task, 301700}]};

get_shop_config(2039) ->
	#shop{key_id = 2039,shop_type = 2,shop_subtype_list = [1],career = [],rank = 1,goods_id = 38340001,num = 1,ctype = 1,price = 300,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,200,9999}],counter_module = 153,counter_id = 2039,bind = 0,turn = []};

get_shop_config(2040) ->
	#shop{key_id = 2040,shop_type = 2,shop_subtype_list = [1],career = [],rank = 2,goods_id = 38340003,num = 1,ctype = 1,price = 120,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,200,9999}],counter_module = 153,counter_id = 2040,bind = 0,turn = []};

get_shop_config(2041) ->
	#shop{key_id = 2041,shop_type = 2,shop_subtype_list = [1],career = [],rank = 3,goods_id = 38340004,num = 1,ctype = 1,price = 130,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,200,9999}],counter_module = 153,counter_id = 2041,bind = 0,turn = []};

get_shop_config(2042) ->
	#shop{key_id = 2042,shop_type = 2,shop_subtype_list = [1],career = [],rank = 4,goods_id = 38340005,num = 1,ctype = 1,price = 150,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,200,9999}],counter_module = 153,counter_id = 2042,bind = 0,turn = []};

get_shop_config(2043) ->
	#shop{key_id = 2043,shop_type = 2,shop_subtype_list = [1],career = [],rank = 17,goods_id = 38390001,num = 1,ctype = 1,price = 888,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,9999}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(2044) ->
	#shop{key_id = 2044,shop_type = 2,shop_subtype_list = [1],career = [],rank = 18,goods_id = 801705,num = 1,ctype = 1,price = 10,discount = 100,quota_type = 0,quota_num = 0,on_sale = 50,halt_sale = 9999,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,500}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3001) ->
	#shop{key_id = 3001,shop_type = 3,shop_subtype_list = [],career = [],rank = 1,goods_id = 16020001,num = 1,ctype = 2,price = 10,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3002) ->
	#shop{key_id = 3002,shop_type = 3,shop_subtype_list = [],career = [],rank = 2,goods_id = 17020001,num = 1,ctype = 2,price = 10,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3003) ->
	#shop{key_id = 3003,shop_type = 3,shop_subtype_list = [],career = [],rank = 3,goods_id = 18020001,num = 1,ctype = 2,price = 10,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3004) ->
	#shop{key_id = 3004,shop_type = 3,shop_subtype_list = [],career = [],rank = 4,goods_id = 19020001,num = 1,ctype = 2,price = 10,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3005) ->
	#shop{key_id = 3005,shop_type = 3,shop_subtype_list = [],career = [],rank = 9,goods_id = 38040013,num = 1,ctype = 2,price = 666,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3006) ->
	#shop{key_id = 3006,shop_type = 3,shop_subtype_list = [],career = [],rank = 10,goods_id = 38040014,num = 1,ctype = 2,price = 288,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3007) ->
	#shop{key_id = 3007,shop_type = 3,shop_subtype_list = [],career = [],rank = 11,goods_id = 38030001,num = 1,ctype = 2,price = 40,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3008) ->
	#shop{key_id = 3008,shop_type = 3,shop_subtype_list = [],career = [],rank = 12,goods_id = 38030003,num = 1,ctype = 2,price = 80,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3009) ->
	#shop{key_id = 3009,shop_type = 3,shop_subtype_list = [],career = [],rank = 13,goods_id = 38030004,num = 1,ctype = 2,price = 80,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3010) ->
	#shop{key_id = 3010,shop_type = 3,shop_subtype_list = [],career = [],rank = 14,goods_id = 38070001,num = 1,ctype = 2,price = 25,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3011) ->
	#shop{key_id = 3011,shop_type = 3,shop_subtype_list = [],career = [],rank = 15,goods_id = 37020001,num = 1,ctype = 2,price = 15,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3014) ->
	#shop{key_id = 3014,shop_type = 3,shop_subtype_list = [],career = [],rank = 17,goods_id = 40010001,num = 1,ctype = 2,price = 288,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,170,9999}],counter_module = 153,counter_id = 3014,bind = 0,turn = []};

get_shop_config(3015) ->
	#shop{key_id = 3015,shop_type = 3,shop_subtype_list = [],career = [],rank = 5,goods_id = 38040061,num = 1,ctype = 2,price = 100,discount = 100,quota_type = 3,quota_num = 5,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,350,9999}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3016) ->
	#shop{key_id = 3016,shop_type = 3,shop_subtype_list = [],career = [],rank = 6,goods_id = 38040060,num = 1,ctype = 2,price = 20,discount = 100,quota_type = 3,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,350,9999}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3017) ->
	#shop{key_id = 3017,shop_type = 3,shop_subtype_list = [],career = [],rank = 7,goods_id = 38040057,num = 1,ctype = 2,price = 100,discount = 100,quota_type = 3,quota_num = 5,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,350,9999}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3018) ->
	#shop{key_id = 3018,shop_type = 3,shop_subtype_list = [],career = [],rank = 8,goods_id = 38040056,num = 1,ctype = 2,price = 20,discount = 100,quota_type = 3,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,350,9999}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(3019) ->
	#shop{key_id = 3019,shop_type = 3,shop_subtype_list = [],career = [],rank = 5,goods_id = 25020001,num = 1,ctype = 2,price = 10,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(6001) ->
	#shop{key_id = 6001,shop_type = 6,shop_subtype_list = [],career = [],rank = 7,goods_id = 16010001,num = 1,ctype = 41,price = 2000,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 6001,bind = 1,turn = []};

get_shop_config(6002) ->
	#shop{key_id = 6002,shop_type = 6,shop_subtype_list = [],career = [],rank = 8,goods_id = 17010001,num = 1,ctype = 41,price = 2000,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 6002,bind = 1,turn = []};

get_shop_config(6003) ->
	#shop{key_id = 6003,shop_type = 6,shop_subtype_list = [],career = [],rank = 6,goods_id = 32010158,num = 1,ctype = 41,price = 1000,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 6003,bind = 1,turn = []};

get_shop_config(6004) ->
	#shop{key_id = 6004,shop_type = 6,shop_subtype_list = [],career = [],rank = 9,goods_id = 38030001,num = 1,ctype = 41,price = 800,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 6004,bind = 1,turn = []};

get_shop_config(6006) ->
	#shop{key_id = 6006,shop_type = 6,shop_subtype_list = [],career = [],rank = 11,goods_id = 37020001,num = 1,ctype = 41,price = 300,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 6006,bind = 1,turn = []};

get_shop_config(6007) ->
	#shop{key_id = 6007,shop_type = 6,shop_subtype_list = [],career = [],rank = 12,goods_id = 14010001,num = 1,ctype = 41,price = 400,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 6007,bind = 1,turn = []};

get_shop_config(6008) ->
	#shop{key_id = 6008,shop_type = 6,shop_subtype_list = [],career = [],rank = 13,goods_id = 14020001,num = 1,ctype = 41,price = 400,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 6008,bind = 1,turn = []};

get_shop_config(6009) ->
	#shop{key_id = 6009,shop_type = 6,shop_subtype_list = [],career = [],rank = 5,goods_id = 38040044,num = 1,ctype = 41,price = 600,discount = 100,quota_type = 1,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 6009,bind = 1,turn = []};

get_shop_config(6010) ->
	#shop{key_id = 6010,shop_type = 6,shop_subtype_list = [],career = [],rank = 14,goods_id = 16020001,num = 1,ctype = 41,price = 200,discount = 100,quota_type = 1,quota_num = 6,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 6010,bind = 1,turn = []};

get_shop_config(6011) ->
	#shop{key_id = 6011,shop_type = 6,shop_subtype_list = [],career = [],rank = 4,goods_id = 32010468,num = 1,ctype = 41,price = 1000,discount = 100,quota_type = 1,quota_num = 5,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,240,9999}],counter_module = 153,counter_id = 6011,bind = 1,turn = []};

get_shop_config(6013) ->
	#shop{key_id = 6013,shop_type = 6,shop_subtype_list = [],career = [],rank = 3,goods_id = 38040019,num = 1,ctype = 41,price = 8000,discount = 100,quota_type = 2,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,360,9999}],counter_module = 153,counter_id = 6013,bind = 1,turn = []};

get_shop_config(6014) ->
	#shop{key_id = 6014,shop_type = 6,shop_subtype_list = [],career = [],rank = 2,goods_id = 38040096,num = 1,ctype = 41,price = 40000,discount = 100,quota_type = 3,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,360,9999}],counter_module = 153,counter_id = 6014,bind = 1,turn = []};

get_shop_config(6015) ->
	#shop{key_id = 6015,shop_type = 6,shop_subtype_list = [],career = [],rank = 1,goods_id = 38340002,num = 1,ctype = 41,price = 300,discount = 100,quota_type = 1,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,200,9999}],counter_module = 153,counter_id = 6015,bind = 1,turn = []};

get_shop_config(7001) ->
	#shop{key_id = 7001,shop_type = 7,shop_subtype_list = [],career = [],rank = 1,goods_id = 32010163,num = 1,ctype = 42,price = 150,discount = 100,quota_type = 1,quota_num = 1,on_sale = 2,halt_sale = 4,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 7001,bind = 1,turn = []};

get_shop_config(7002) ->
	#shop{key_id = 7002,shop_type = 7,shop_subtype_list = [],career = [],rank = 2,goods_id = 32010164,num = 1,ctype = 42,price = 100,discount = 100,quota_type = 1,quota_num = 5,on_sale = 2,halt_sale = 4,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 7002,bind = 1,turn = []};

get_shop_config(7003) ->
	#shop{key_id = 7003,shop_type = 7,shop_subtype_list = [],career = [],rank = 3,goods_id = 32010165,num = 1,ctype = 42,price = 100,discount = 100,quota_type = 1,quota_num = 5,on_sale = 2,halt_sale = 4,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 7003,bind = 1,turn = []};

get_shop_config(7004) ->
	#shop{key_id = 7004,shop_type = 7,shop_subtype_list = [],career = [],rank = 4,goods_id = 6101001,num = 1,ctype = 42,price = 80,discount = 100,quota_type = 1,quota_num = 1,on_sale = 2,halt_sale = 4,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 7004,bind = 1,turn = []};

get_shop_config(7005) ->
	#shop{key_id = 7005,shop_type = 7,shop_subtype_list = [],career = [],rank = 5,goods_id = 6101002,num = 1,ctype = 42,price = 80,discount = 100,quota_type = 1,quota_num = 1,on_sale = 2,halt_sale = 4,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 7005,bind = 1,turn = []};

get_shop_config(8001) ->
	#shop{key_id = 8001,shop_type = 8,shop_subtype_list = [],career = [],rank = 1,goods_id = 32010174,num = 1,ctype = 36255012,price = 150,discount = 100,quota_type = 1,quota_num = 1,on_sale = 5,halt_sale = 999,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 8001,bind = 1,turn = []};

get_shop_config(8002) ->
	#shop{key_id = 8002,shop_type = 8,shop_subtype_list = [],career = [],rank = 2,goods_id = 32010175,num = 1,ctype = 36255012,price = 100,discount = 100,quota_type = 1,quota_num = 5,on_sale = 5,halt_sale = 999,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 8002,bind = 1,turn = []};

get_shop_config(8003) ->
	#shop{key_id = 8003,shop_type = 8,shop_subtype_list = [],career = [],rank = 3,goods_id = 32010176,num = 1,ctype = 36255012,price = 100,discount = 100,quota_type = 1,quota_num = 5,on_sale = 5,halt_sale = 999,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 8003,bind = 1,turn = []};

get_shop_config(8004) ->
	#shop{key_id = 8004,shop_type = 8,shop_subtype_list = [],career = [],rank = 4,goods_id = 6101001,num = 1,ctype = 36255012,price = 80,discount = 100,quota_type = 1,quota_num = 1,on_sale = 5,halt_sale = 999,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 8004,bind = 1,turn = []};

get_shop_config(8005) ->
	#shop{key_id = 8005,shop_type = 8,shop_subtype_list = [],career = [],rank = 5,goods_id = 6101002,num = 1,ctype = 36255012,price = 80,discount = 100,quota_type = 1,quota_num = 1,on_sale = 5,halt_sale = 999,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 8005,bind = 1,turn = []};

get_shop_config(10001) ->
	#shop{key_id = 10001,shop_type = 10,shop_subtype_list = [],career = [],rank = 1,goods_id = 37010003,num = 1,ctype = 36255042,price = 50,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right}],counter_module = 153,counter_id = 10001,bind = 0,turn = []};

get_shop_config(10002) ->
	#shop{key_id = 10002,shop_type = 10,shop_subtype_list = [],career = [],rank = 2,goods_id = 16020001,num = 1,ctype = 36255042,price = 30,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10001}],counter_module = 153,counter_id = 10002,bind = 0,turn = []};

get_shop_config(10003) ->
	#shop{key_id = 10003,shop_type = 10,shop_subtype_list = [],career = [],rank = 3,goods_id = 17020001,num = 1,ctype = 36255042,price = 30,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10002}],counter_module = 153,counter_id = 10003,bind = 0,turn = []};

get_shop_config(10004) ->
	#shop{key_id = 10004,shop_type = 10,shop_subtype_list = [],career = [],rank = 4,goods_id = 38065025,num = 1,ctype = 36255042,price = 500,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10003}],counter_module = 153,counter_id = 10004,bind = 0,turn = []};

get_shop_config(10005) ->
	#shop{key_id = 10005,shop_type = 10,shop_subtype_list = [],career = [],rank = 5,goods_id = 32010306,num = 1,ctype = 36255042,price = 120,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10004}],counter_module = 153,counter_id = 10005,bind = 0,turn = []};

get_shop_config(10006) ->
	#shop{key_id = 10006,shop_type = 10,shop_subtype_list = [],career = [],rank = 6,goods_id = 39510012,num = 1,ctype = 36255042,price = 40,discount = 100,quota_type = 1,quota_num = 5,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10005}],counter_module = 153,counter_id = 10006,bind = 0,turn = []};

get_shop_config(10007) ->
	#shop{key_id = 10007,shop_type = 10,shop_subtype_list = [],career = [],rank = 7,goods_id = 32010152,num = 1,ctype = 36255042,price = 60,discount = 100,quota_type = 1,quota_num = 5,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10006}],counter_module = 153,counter_id = 10007,bind = 0,turn = []};

get_shop_config(10008) ->
	#shop{key_id = 10008,shop_type = 10,shop_subtype_list = [],career = [],rank = 8,goods_id = 37010004,num = 1,ctype = 36255042,price = 100,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10007}],counter_module = 153,counter_id = 10008,bind = 0,turn = []};

get_shop_config(10009) ->
	#shop{key_id = 10009,shop_type = 10,shop_subtype_list = [],career = [],rank = 9,goods_id = 32010307,num = 1,ctype = 36255042,price = 200,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10008}],counter_module = 153,counter_id = 10009,bind = 0,turn = []};

get_shop_config(10010) ->
	#shop{key_id = 10010,shop_type = 10,shop_subtype_list = [],career = [],rank = 10,goods_id = 38160001,num = 1,ctype = 36255042,price = 180,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10009}],counter_module = 153,counter_id = 10010,bind = 0,turn = []};

get_shop_config(10011) ->
	#shop{key_id = 10011,shop_type = 10,shop_subtype_list = [],career = [],rank = 11,goods_id = 38100004,num = 1,ctype = 36255042,price = 599,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10010}],counter_module = 153,counter_id = 10011,bind = 0,turn = []};

get_shop_config(10012) ->
	#shop{key_id = 10012,shop_type = 10,shop_subtype_list = [],career = [],rank = 12,goods_id = 23020001,num = 1,ctype = 36255042,price = 30,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10011}],counter_module = 153,counter_id = 10012,bind = 0,turn = []};

get_shop_config(10013) ->
	#shop{key_id = 10013,shop_type = 10,shop_subtype_list = [],career = [],rank = 13,goods_id = 32010308,num = 1,ctype = 36255042,price = 250,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10012}],counter_module = 153,counter_id = 10013,bind = 0,turn = []};

get_shop_config(10014) ->
	#shop{key_id = 10014,shop_type = 10,shop_subtype_list = [],career = [],rank = 14,goods_id = 38065026,num = 1,ctype = 36255042,price = 500,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10013}],counter_module = 153,counter_id = 10014,bind = 0,turn = []};

get_shop_config(10015) ->
	#shop{key_id = 10015,shop_type = 10,shop_subtype_list = [],career = [],rank = 15,goods_id = 38040005,num = 1,ctype = 36255042,price = 5,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10014}],counter_module = 153,counter_id = 10015,bind = 0,turn = []};

get_shop_config(10016) ->
	#shop{key_id = 10016,shop_type = 10,shop_subtype_list = [],career = [],rank = 16,goods_id = 32010214,num = 1,ctype = 36255042,price = 180,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10015}],counter_module = 153,counter_id = 10016,bind = 0,turn = []};

get_shop_config(10017) ->
	#shop{key_id = 10017,shop_type = 10,shop_subtype_list = [],career = [],rank = 17,goods_id = 32010309,num = 1,ctype = 36255042,price = 280,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10016}],counter_module = 153,counter_id = 10017,bind = 0,turn = []};

get_shop_config(10018) ->
	#shop{key_id = 10018,shop_type = 10,shop_subtype_list = [],career = [],rank = 18,goods_id = 18020001,num = 1,ctype = 36255042,price = 30,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10017}],counter_module = 153,counter_id = 10018,bind = 0,turn = []};

get_shop_config(10019) ->
	#shop{key_id = 10019,shop_type = 10,shop_subtype_list = [],career = [],rank = 19,goods_id = 22020001,num = 1,ctype = 36255042,price = 10,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10018}],counter_module = 153,counter_id = 10019,bind = 0,turn = []};

get_shop_config(10020) ->
	#shop{key_id = 10020,shop_type = 10,shop_subtype_list = [],career = [],rank = 20,goods_id = 32010310,num = 1,ctype = 36255042,price = 400,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10019}],counter_module = 153,counter_id = 10020,bind = 0,turn = []};

get_shop_config(10021) ->
	#shop{key_id = 10021,shop_type = 10,shop_subtype_list = [],career = [],rank = 21,goods_id = 38040030,num = 1,ctype = 36255042,price = 30,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10020}],counter_module = 153,counter_id = 10021,bind = 0,turn = []};

get_shop_config(10022) ->
	#shop{key_id = 10022,shop_type = 10,shop_subtype_list = [],career = [],rank = 22,goods_id = 7110001,num = 1,ctype = 36255042,price = 30,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10021}],counter_module = 153,counter_id = 10022,bind = 0,turn = []};

get_shop_config(10023) ->
	#shop{key_id = 10023,shop_type = 10,shop_subtype_list = [],career = [],rank = 23,goods_id = 32010311,num = 1,ctype = 36255042,price = 400,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10022}],counter_module = 153,counter_id = 10023,bind = 0,turn = []};

get_shop_config(10024) ->
	#shop{key_id = 10024,shop_type = 10,shop_subtype_list = [],career = [],rank = 24,goods_id = 38040018,num = 1,ctype = 36255042,price = 10,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10023}],counter_module = 153,counter_id = 10024,bind = 0,turn = []};

get_shop_config(10025) ->
	#shop{key_id = 10025,shop_type = 10,shop_subtype_list = [],career = [],rank = 25,goods_id = 32010312,num = 1,ctype = 36255042,price = 600,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10024}],counter_module = 153,counter_id = 10025,bind = 0,turn = []};

get_shop_config(10026) ->
	#shop{key_id = 10026,shop_type = 10,shop_subtype_list = [],career = [],rank = 26,goods_id = 32010313,num = 1,ctype = 36255042,price = 2000,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10025}],counter_module = 153,counter_id = 10026,bind = 0,turn = []};

get_shop_config(10027) ->
	#shop{key_id = 10027,shop_type = 10,shop_subtype_list = [],career = [],rank = 27,goods_id = 7301001,num = 1,ctype = 36255042,price = 30,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10026}],counter_module = 153,counter_id = 10027,bind = 0,turn = []};

get_shop_config(10028) ->
	#shop{key_id = 10028,shop_type = 10,shop_subtype_list = [],career = [],rank = 28,goods_id = 7301003,num = 1,ctype = 36255042,price = 45,discount = 100,quota_type = 1,quota_num = 99,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10027}],counter_module = 153,counter_id = 10028,bind = 0,turn = []};

get_shop_config(10029) ->
	#shop{key_id = 10029,shop_type = 10,shop_subtype_list = [],career = [],rank = 29,goods_id = 32010314,num = 1,ctype = 36255042,price = 5000,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{supvip_right},{pre, 10028}],counter_module = 153,counter_id = 10029,bind = 0,turn = []};

get_shop_config(11001) ->
	#shop{key_id = 11001,shop_type = 11,shop_subtype_list = [],career = [],rank = 1,goods_id = 19010001,num = 1,ctype = 36255041,price = 100,discount = 100,quota_type = 1,quota_num = 1,on_sale = 1,halt_sale = 9999,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 11001,bind = 0,turn = []};

get_shop_config(11002) ->
	#shop{key_id = 11002,shop_type = 11,shop_subtype_list = [],career = [],rank = 2,goods_id = 18010001,num = 1,ctype = 36255041,price = 100,discount = 100,quota_type = 1,quota_num = 1,on_sale = 1,halt_sale = 9999,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 11002,bind = 0,turn = []};

get_shop_config(11003) ->
	#shop{key_id = 11003,shop_type = 11,shop_subtype_list = [],career = [],rank = 3,goods_id = 39510000,num = 1,ctype = 36255041,price = 10,discount = 100,quota_type = 1,quota_num = 10,on_sale = 1,halt_sale = 9999,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 11003,bind = 0,turn = []};

get_shop_config(11004) ->
	#shop{key_id = 11004,shop_type = 11,shop_subtype_list = [],career = [],rank = 4,goods_id = 32010315,num = 1,ctype = 36255041,price = 200,discount = 100,quota_type = 1,quota_num = 1,on_sale = 1,halt_sale = 9999,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 11004,bind = 0,turn = []};

get_shop_config(11005) ->
	#shop{key_id = 11005,shop_type = 11,shop_subtype_list = [],career = [],rank = 7,goods_id = 32010317,num = 1,ctype = 36255041,price = 50,discount = 100,quota_type = 1,quota_num = 2,on_sale = 1,halt_sale = 9999,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,400,9999}],counter_module = 153,counter_id = 11005,bind = 0,turn = []};

get_shop_config(11006) ->
	#shop{key_id = 11006,shop_type = 11,shop_subtype_list = [],career = [],rank = 8,goods_id = 32010318,num = 1,ctype = 36255041,price = 100,discount = 100,quota_type = 1,quota_num = 2,on_sale = 1,halt_sale = 9999,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,400,9999}],counter_module = 153,counter_id = 11006,bind = 0,turn = []};

get_shop_config(11007) ->
	#shop{key_id = 11007,shop_type = 11,shop_subtype_list = [],career = [],rank = 9,goods_id = 7110001,num = 1,ctype = 36255041,price = 10,discount = 100,quota_type = 1,quota_num = 5,on_sale = 1,halt_sale = 9999,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,400,9999}],counter_module = 153,counter_id = 11007,bind = 0,turn = []};

get_shop_config(11008) ->
	#shop{key_id = 11008,shop_type = 11,shop_subtype_list = [],career = [],rank = 10,goods_id = 7120102,num = 1,ctype = 36255041,price = 100,discount = 100,quota_type = 1,quota_num = 1,on_sale = 1,halt_sale = 9999,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,400,9999}],counter_module = 153,counter_id = 11008,bind = 0,turn = []};

get_shop_config(11009) ->
	#shop{key_id = 11009,shop_type = 11,shop_subtype_list = [],career = [],rank = 5,goods_id = 38040062,num = 1,ctype = 36255041,price = 6000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 1,halt_sale = 9999,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,350,9999}],counter_module = 153,counter_id = 11009,bind = 0,turn = []};

get_shop_config(11010) ->
	#shop{key_id = 11010,shop_type = 11,shop_subtype_list = [],career = [],rank = 6,goods_id = 38040058,num = 1,ctype = 36255041,price = 6000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 1,halt_sale = 9999,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,350,9999}],counter_module = 153,counter_id = 11010,bind = 0,turn = []};

get_shop_config(11011) ->
	#shop{key_id = 11011,shop_type = 11,shop_subtype_list = [],career = [],rank = 11,goods_id = 38040076,num = 1,ctype = 36255041,price = 125,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{extra_quota,vip,[{lv,580,9999},{8,2}]}],counter_module = 153,counter_id = 11011,bind = 0,turn = []};

get_shop_config(11013) ->
	#shop{key_id = 11013,shop_type = 11,shop_subtype_list = [],career = [],rank = 13,goods_id = 79070401,num = 1,ctype = 36255041,price = 1500,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999}],counter_module = 153,counter_id = 11013,bind = 0,turn = []};

get_shop_config(11014) ->
	#shop{key_id = 11014,shop_type = 11,shop_subtype_list = [],career = [],rank = 14,goods_id = 79080401,num = 1,ctype = 36255041,price = 1500,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999}],counter_module = 153,counter_id = 11014,bind = 0,turn = []};

get_shop_config(11015) ->
	#shop{key_id = 11015,shop_type = 11,shop_subtype_list = [],career = [],rank = 15,goods_id = 79090401,num = 1,ctype = 36255041,price = 2000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999}],counter_module = 153,counter_id = 11015,bind = 0,turn = []};

get_shop_config(11016) ->
	#shop{key_id = 11016,shop_type = 11,shop_subtype_list = [],career = [],rank = 16,goods_id = 79070402,num = 1,ctype = 36255041,price = 3000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,2}],counter_module = 153,counter_id = 11016,bind = 0,turn = []};

get_shop_config(11017) ->
	#shop{key_id = 11017,shop_type = 11,shop_subtype_list = [],career = [],rank = 17,goods_id = 79080402,num = 1,ctype = 36255041,price = 3000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,2}],counter_module = 153,counter_id = 11017,bind = 0,turn = []};

get_shop_config(11018) ->
	#shop{key_id = 11018,shop_type = 11,shop_subtype_list = [],career = [],rank = 18,goods_id = 79090402,num = 1,ctype = 36255041,price = 4000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,2}],counter_module = 153,counter_id = 11018,bind = 0,turn = []};

get_shop_config(11019) ->
	#shop{key_id = 11019,shop_type = 11,shop_subtype_list = [],career = [],rank = 19,goods_id = 79070403,num = 1,ctype = 36255041,price = 3750,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,3}],counter_module = 153,counter_id = 11019,bind = 0,turn = []};

get_shop_config(11020) ->
	#shop{key_id = 11020,shop_type = 11,shop_subtype_list = [],career = [],rank = 20,goods_id = 79080403,num = 1,ctype = 36255041,price = 3750,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,3}],counter_module = 153,counter_id = 11020,bind = 0,turn = []};

get_shop_config(11021) ->
	#shop{key_id = 11021,shop_type = 11,shop_subtype_list = [],career = [],rank = 21,goods_id = 79090403,num = 1,ctype = 36255041,price = 5000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,3}],counter_module = 153,counter_id = 11021,bind = 0,turn = []};

get_shop_config(11022) ->
	#shop{key_id = 11022,shop_type = 11,shop_subtype_list = [],career = [],rank = 22,goods_id = 79070404,num = 1,ctype = 36255041,price = 6000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,4}],counter_module = 153,counter_id = 11022,bind = 0,turn = []};

get_shop_config(11023) ->
	#shop{key_id = 11023,shop_type = 11,shop_subtype_list = [],career = [],rank = 23,goods_id = 79080404,num = 1,ctype = 36255041,price = 6000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,4}],counter_module = 153,counter_id = 11023,bind = 0,turn = []};

get_shop_config(11024) ->
	#shop{key_id = 11024,shop_type = 11,shop_subtype_list = [],career = [],rank = 24,goods_id = 79090404,num = 1,ctype = 36255041,price = 7500,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,4}],counter_module = 153,counter_id = 11024,bind = 0,turn = []};

get_shop_config(11025) ->
	#shop{key_id = 11025,shop_type = 11,shop_subtype_list = [],career = [],rank = 25,goods_id = 79070405,num = 1,ctype = 36255041,price = 7500,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,5}],counter_module = 153,counter_id = 11025,bind = 0,turn = []};

get_shop_config(11026) ->
	#shop{key_id = 11026,shop_type = 11,shop_subtype_list = [],career = [],rank = 26,goods_id = 79080405,num = 1,ctype = 36255041,price = 7500,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,5}],counter_module = 153,counter_id = 11026,bind = 0,turn = []};

get_shop_config(11027) ->
	#shop{key_id = 11027,shop_type = 11,shop_subtype_list = [],career = [],rank = 27,goods_id = 79090405,num = 1,ctype = 36255041,price = 10000,discount = 100,quota_type = 3,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,580,9999},{constellation_equip,5}],counter_module = 153,counter_id = 11027,bind = 0,turn = []};

get_shop_config(12001) ->
	#shop{key_id = 12001,shop_type = 12,shop_subtype_list = [],career = [],rank = 1,goods_id = 7601001,num = 1,ctype = 36255094,price = 5,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 12001,bind = 0,turn = []};

get_shop_config(12002) ->
	#shop{key_id = 12002,shop_type = 12,shop_subtype_list = [],career = [],rank = 2,goods_id = 7601002,num = 1,ctype = 36255094,price = 15,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{rank_dun_level,2}],counter_module = 153,counter_id = 12002,bind = 0,turn = []};

get_shop_config(12003) ->
	#shop{key_id = 12003,shop_type = 12,shop_subtype_list = [],career = [],rank = 3,goods_id = 7601003,num = 1,ctype = 36255094,price = 25,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{rank_dun_level,3}],counter_module = 153,counter_id = 12003,bind = 0,turn = []};

get_shop_config(12004) ->
	#shop{key_id = 12004,shop_type = 12,shop_subtype_list = [],career = [],rank = 4,goods_id = 7601004,num = 1,ctype = 36255094,price = 35,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{rank_dun_level,4}],counter_module = 153,counter_id = 12004,bind = 0,turn = []};

get_shop_config(12005) ->
	#shop{key_id = 12005,shop_type = 12,shop_subtype_list = [],career = [],rank = 5,goods_id = 7601005,num = 1,ctype = 36255094,price = 45,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{rank_dun_level,5}],counter_module = 153,counter_id = 12005,bind = 0,turn = []};

get_shop_config(12006) ->
	#shop{key_id = 12006,shop_type = 12,shop_subtype_list = [],career = [],rank = 6,goods_id = 7601006,num = 1,ctype = 36255094,price = 55,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{rank_dun_level,6}],counter_module = 153,counter_id = 12006,bind = 0,turn = []};

get_shop_config(12007) ->
	#shop{key_id = 12007,shop_type = 12,shop_subtype_list = [],career = [],rank = 7,goods_id = 7601007,num = 1,ctype = 36255094,price = 65,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{rank_dun_level,7}],counter_module = 153,counter_id = 12007,bind = 0,turn = []};

get_shop_config(12008) ->
	#shop{key_id = 12008,shop_type = 12,shop_subtype_list = [],career = [],rank = 8,goods_id = 7601008,num = 1,ctype = 36255094,price = 75,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{rank_dun_level,8}],counter_module = 153,counter_id = 12008,bind = 0,turn = []};

get_shop_config(12009) ->
	#shop{key_id = 12009,shop_type = 12,shop_subtype_list = [],career = [],rank = 9,goods_id = 7601009,num = 1,ctype = 36255094,price = 85,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{rank_dun_level,9}],counter_module = 153,counter_id = 12009,bind = 0,turn = []};

get_shop_config(12010) ->
	#shop{key_id = 12010,shop_type = 12,shop_subtype_list = [],career = [],rank = 10,goods_id = 7601010,num = 1,ctype = 36255094,price = 95,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{rank_dun_level,10}],counter_module = 153,counter_id = 12010,bind = 0,turn = []};

get_shop_config(14001) ->
	#shop{key_id = 14001,shop_type = 14,shop_subtype_list = [],career = [],rank = 1,goods_id = 32060043,num = 1,ctype = 36255097,price = 5,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,0},{51,0},{52,0}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14002) ->
	#shop{key_id = 14002,shop_type = 14,shop_subtype_list = [],career = [],rank = 2,goods_id = 32060044,num = 1,ctype = 36255097,price = 6,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,60},{51,40},{52,0}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14003) ->
	#shop{key_id = 14003,shop_type = 14,shop_subtype_list = [],career = [],rank = 3,goods_id = 32060045,num = 1,ctype = 36255097,price = 9,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,140},{51,120},{52,0}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14004) ->
	#shop{key_id = 14004,shop_type = 14,shop_subtype_list = [],career = [],rank = 4,goods_id = 32060046,num = 1,ctype = 36255097,price = 12,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,400},{51,325},{52,0}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14005) ->
	#shop{key_id = 14005,shop_type = 14,shop_subtype_list = [],career = [],rank = 5,goods_id = 32060047,num = 1,ctype = 36255097,price = 25,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,800},{51,650},{52,0}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14006) ->
	#shop{key_id = 14006,shop_type = 14,shop_subtype_list = [],career = [],rank = 6,goods_id = 32060048,num = 1,ctype = 36255097,price = 70,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,1200},{51,960},{52,700}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14007) ->
	#shop{key_id = 14007,shop_type = 14,shop_subtype_list = [],career = [],rank = 7,goods_id = 32060049,num = 1,ctype = 36255097,price = 110,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,1750},{51,1250},{52,1000}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14008) ->
	#shop{key_id = 14008,shop_type = 14,shop_subtype_list = [],career = [],rank = 8,goods_id = 32060050,num = 1,ctype = 36255097,price = 200,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,2500},{51,2000},{52,2500}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14009) ->
	#shop{key_id = 14009,shop_type = 14,shop_subtype_list = [],career = [],rank = 9,goods_id = 32060051,num = 1,ctype = 36255097,price = 375,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,3100},{51,2500},{52,3100}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14010) ->
	#shop{key_id = 14010,shop_type = 14,shop_subtype_list = [],career = [],rank = 10,goods_id = 32060052,num = 1,ctype = 36255097,price = 500,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,3900},{51,3120},{52,3900}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14011) ->
	#shop{key_id = 14011,shop_type = 14,shop_subtype_list = [],career = [],rank = 11,goods_id = 32060053,num = 1,ctype = 36255097,price = 540,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,4900},{51,3920},{52,4900}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14012) ->
	#shop{key_id = 14012,shop_type = 14,shop_subtype_list = [],career = [],rank = 12,goods_id = 32060054,num = 1,ctype = 36255097,price = 950,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,6100},{51,4880},{52,6100}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14013) ->
	#shop{key_id = 14013,shop_type = 14,shop_subtype_list = [],career = [],rank = 13,goods_id = 32060055,num = 1,ctype = 36255097,price = 1050,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,7600},{51,6080},{52,7600}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14014) ->
	#shop{key_id = 14014,shop_type = 14,shop_subtype_list = [],career = [],rank = 14,goods_id = 32060056,num = 1,ctype = 36255097,price = 1700,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,9500},{51,7600},{52,9500}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(14015) ->
	#shop{key_id = 14015,shop_type = 14,shop_subtype_list = [],career = [],rank = 15,goods_id = 32060057,num = 1,ctype = 36255097,price = 1800,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{attr, [{50,11900},{51,9520},{52,11900}]}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15001) ->
	#shop{key_id = 15001,shop_type = 15,shop_subtype_list = [],career = [],rank = 1,goods_id = 800130,num = 1,ctype = 36255099,price = 100,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15002) ->
	#shop{key_id = 15002,shop_type = 15,shop_subtype_list = [],career = [],rank = 2,goods_id = 800230,num = 1,ctype = 36255099,price = 100,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15003) ->
	#shop{key_id = 15003,shop_type = 15,shop_subtype_list = [],career = [],rank = 3,goods_id = 800330,num = 1,ctype = 36255099,price = 100,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15004) ->
	#shop{key_id = 15004,shop_type = 15,shop_subtype_list = [],career = [],rank = 4,goods_id = 800430,num = 1,ctype = 36255099,price = 100,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15005) ->
	#shop{key_id = 15005,shop_type = 15,shop_subtype_list = [],career = [],rank = 5,goods_id = 800530,num = 1,ctype = 36255099,price = 100,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15006) ->
	#shop{key_id = 15006,shop_type = 15,shop_subtype_list = [],career = [],rank = 6,goods_id = 800630,num = 1,ctype = 36255099,price = 100,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15007) ->
	#shop{key_id = 15007,shop_type = 15,shop_subtype_list = [],career = [],rank = 7,goods_id = 800730,num = 1,ctype = 36255099,price = 100,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15008) ->
	#shop{key_id = 15008,shop_type = 15,shop_subtype_list = [],career = [],rank = 8,goods_id = 800830,num = 1,ctype = 36255099,price = 100,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15009) ->
	#shop{key_id = 15009,shop_type = 15,shop_subtype_list = [],career = [],rank = 9,goods_id = 801702,num = 1,ctype = 36255099,price = 100,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15010) ->
	#shop{key_id = 15010,shop_type = 15,shop_subtype_list = [],career = [],rank = 10,goods_id = 801704,num = 1,ctype = 36255099,price = 350,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15011) ->
	#shop{key_id = 15011,shop_type = 15,shop_subtype_list = [],career = [],rank = 11,goods_id = 801706,num = 1,ctype = 36255099,price = 1500,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,1}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15012) ->
	#shop{key_id = 15012,shop_type = 15,shop_subtype_list = [],career = [],rank = 12,goods_id = 800950,num = 1,ctype = 36255099,price = 700,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,2}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15013) ->
	#shop{key_id = 15013,shop_type = 15,shop_subtype_list = [],career = [],rank = 13,goods_id = 801050,num = 1,ctype = 36255099,price = 700,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,3}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15014) ->
	#shop{key_id = 15014,shop_type = 15,shop_subtype_list = [],career = [],rank = 14,goods_id = 801150,num = 1,ctype = 36255099,price = 700,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,4}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15015) ->
	#shop{key_id = 15015,shop_type = 15,shop_subtype_list = [],career = [],rank = 15,goods_id = 801250,num = 1,ctype = 36255099,price = 700,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,5}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15016) ->
	#shop{key_id = 15016,shop_type = 15,shop_subtype_list = [],career = [],rank = 16,goods_id = 801350,num = 1,ctype = 36255099,price = 700,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,6}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15017) ->
	#shop{key_id = 15017,shop_type = 15,shop_subtype_list = [],career = [],rank = 17,goods_id = 801450,num = 1,ctype = 36255099,price = 700,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,7}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(15018) ->
	#shop{key_id = 15018,shop_type = 15,shop_subtype_list = [],career = [],rank = 18,goods_id = 801550,num = 1,ctype = 36255099,price = 700,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{god_pool_lv,8}],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(16001) ->
	#shop{key_id = 16001,shop_type = 16,shop_subtype_list = [1],career = [],rank = 1,goods_id = 38040082,num = 1,ctype = 36255100,price = 9000,discount = 100,quota_type = 2,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 16001,bind = 0,turn = []};

get_shop_config(16002) ->
	#shop{key_id = 16002,shop_type = 16,shop_subtype_list = [1],career = [],rank = 2,goods_id = 38040083,num = 1,ctype = 36255100,price = 5000,discount = 100,quota_type = 0,quota_num = 0,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 0,counter_id = 0,bind = 0,turn = []};

get_shop_config(16003) ->
	#shop{key_id = 16003,shop_type = 16,shop_subtype_list = [1],career = [],rank = 3,goods_id = 37080001,num = 500,ctype = 36255100,price = 500,discount = 100,quota_type = 2,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 16003,bind = 0,turn = []};

get_shop_config(16004) ->
	#shop{key_id = 16004,shop_type = 16,shop_subtype_list = [1],career = [],rank = 4,goods_id = 18010001,num = 1,ctype = 36255100,price = 2000,discount = 100,quota_type = 2,quota_num = 3,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 16004,bind = 0,turn = []};

get_shop_config(16005) ->
	#shop{key_id = 16005,shop_type = 16,shop_subtype_list = [1],career = [],rank = 5,goods_id = 19010001,num = 1,ctype = 36255100,price = 2000,discount = 100,quota_type = 2,quota_num = 3,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 16005,bind = 0,turn = []};

get_shop_config(16006) ->
	#shop{key_id = 16006,shop_type = 16,shop_subtype_list = [1],career = [],rank = 6,goods_id = 81010031,num = 1,ctype = 36255100,price = 2000,discount = 100,quota_type = 2,quota_num = 5,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 16006,bind = 0,turn = []};

get_shop_config(16007) ->
	#shop{key_id = 16007,shop_type = 16,shop_subtype_list = [2],career = [],rank = 1,goods_id = 38040087,num = 1,ctype = 38040091,price = 5,discount = 100,quota_type = 1,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 16007,bind = 0,turn = []};

get_shop_config(16008) ->
	#shop{key_id = 16008,shop_type = 16,shop_subtype_list = [2],career = [],rank = 2,goods_id = 38040088,num = 1,ctype = 38040091,price = 10,discount = 100,quota_type = 1,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{guild_title,3}],counter_module = 153,counter_id = 16008,bind = 0,turn = []};

get_shop_config(16009) ->
	#shop{key_id = 16009,shop_type = 16,shop_subtype_list = [2],career = [],rank = 3,goods_id = 38040089,num = 1,ctype = 38040091,price = 20,discount = 100,quota_type = 1,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{guild_title,5}],counter_module = 153,counter_id = 16009,bind = 0,turn = []};

get_shop_config(16010) ->
	#shop{key_id = 16010,shop_type = 16,shop_subtype_list = [2],career = [],rank = 4,goods_id = 38040090,num = 1,ctype = 38040091,price = 30,discount = 100,quota_type = 1,quota_num = 10,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{guild_title,7}],counter_module = 153,counter_id = 16010,bind = 0,turn = []};

get_shop_config(16011) ->
	#shop{key_id = 16011,shop_type = 16,shop_subtype_list = [2],career = [],rank = 5,goods_id = 81010041,num = 1,ctype = 38040091,price = 200,discount = 100,quota_type = 2,quota_num = 3,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 16011,bind = 0,turn = []};

get_shop_config(17003) ->
	#shop{key_id = 17003,shop_type = 17,shop_subtype_list = [],career = [],rank = 1,goods_id = 18030001,num = 1,ctype = 36240001,price = 2280,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,9999}],counter_module = 153,counter_id = 17003,bind = 0,turn = []};

get_shop_config(17004) ->
	#shop{key_id = 17004,shop_type = 17,shop_subtype_list = [],career = [],rank = 2,goods_id = 18030002,num = 1,ctype = 36240001,price = 4680,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,9999}],counter_module = 153,counter_id = 17004,bind = 0,turn = []};

get_shop_config(17005) ->
	#shop{key_id = 17005,shop_type = 17,shop_subtype_list = [],career = [],rank = 3,goods_id = 18030003,num = 1,ctype = 36240001,price = 10180,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,9999}],counter_module = 153,counter_id = 17005,bind = 0,turn = []};

get_shop_config(17006) ->
	#shop{key_id = 17006,shop_type = 17,shop_subtype_list = [],career = [],rank = 4,goods_id = 18030004,num = 1,ctype = 36240001,price = 14430,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,370,9999}],counter_module = 153,counter_id = 17006,bind = 0,turn = []};

get_shop_config(17007) ->
	#shop{key_id = 17007,shop_type = 17,shop_subtype_list = [],career = [],rank = 5,goods_id = 19030001,num = 1,ctype = 36240001,price = 2980,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,9999}],counter_module = 153,counter_id = 17007,bind = 0,turn = []};

get_shop_config(17008) ->
	#shop{key_id = 17008,shop_type = 17,shop_subtype_list = [],career = [],rank = 6,goods_id = 19030002,num = 1,ctype = 36240001,price = 6380,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,9999}],counter_module = 153,counter_id = 17008,bind = 0,turn = []};

get_shop_config(17009) ->
	#shop{key_id = 17009,shop_type = 17,shop_subtype_list = [],career = [],rank = 7,goods_id = 19030003,num = 1,ctype = 36240001,price = 11260,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,9999}],counter_module = 153,counter_id = 17009,bind = 0,turn = []};

get_shop_config(17010) ->
	#shop{key_id = 17010,shop_type = 17,shop_subtype_list = [],career = [],rank = 8,goods_id = 19030004,num = 1,ctype = 36240001,price = 16980,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,370,9999}],counter_module = 153,counter_id = 17010,bind = 0,turn = []};

get_shop_config(17011) ->
	#shop{key_id = 17011,shop_type = 17,shop_subtype_list = [],career = [],rank = 9,goods_id = 34010321,num = 1,ctype = 36240001,price = 640,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,400}],counter_module = 153,counter_id = 17011,bind = 0,turn = []};

get_shop_config(17012) ->
	#shop{key_id = 17012,shop_type = 17,shop_subtype_list = [],career = [],rank = 10,goods_id = 34010322,num = 1,ctype = 36240001,price = 860,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,420}],counter_module = 153,counter_id = 17012,bind = 0,turn = []};

get_shop_config(17013) ->
	#shop{key_id = 17013,shop_type = 17,shop_subtype_list = [],career = [],rank = 11,goods_id = 34010323,num = 1,ctype = 36240001,price = 1120,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,350,500}],counter_module = 153,counter_id = 17013,bind = 0,turn = []};

get_shop_config(17014) ->
	#shop{key_id = 17014,shop_type = 17,shop_subtype_list = [],career = [],rank = 12,goods_id = 34010324,num = 1,ctype = 36240001,price = 1440,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,400,520}],counter_module = 153,counter_id = 17014,bind = 0,turn = []};

get_shop_config(17015) ->
	#shop{key_id = 17015,shop_type = 17,shop_subtype_list = [],career = [],rank = 13,goods_id = 34010346,num = 1,ctype = 36240001,price = 1780,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,420,600}],counter_module = 153,counter_id = 17015,bind = 0,turn = []};

get_shop_config(17016) ->
	#shop{key_id = 17016,shop_type = 17,shop_subtype_list = [],career = [],rank = 14,goods_id = 34010347,num = 1,ctype = 36240001,price = 2260,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,500,999}],counter_module = 153,counter_id = 17016,bind = 0,turn = []};

get_shop_config(17017) ->
	#shop{key_id = 17017,shop_type = 17,shop_subtype_list = [],career = [],rank = 15,goods_id = 34010348,num = 1,ctype = 36240001,price = 2720,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,520,999}],counter_module = 153,counter_id = 17017,bind = 0,turn = []};

get_shop_config(17018) ->
	#shop{key_id = 17018,shop_type = 17,shop_subtype_list = [],career = [],rank = 16,goods_id = 34010349,num = 1,ctype = 36240001,price = 3240,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,600,999}],counter_module = 153,counter_id = 17018,bind = 0,turn = []};

get_shop_config(17019) ->
	#shop{key_id = 17019,shop_type = 17,shop_subtype_list = [],career = [],rank = 17,goods_id = 34010354,num = 1,ctype = 36240001,price = 2240,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,400}],counter_module = 153,counter_id = 17019,bind = 0,turn = []};

get_shop_config(17020) ->
	#shop{key_id = 17020,shop_type = 17,shop_subtype_list = [],career = [],rank = 18,goods_id = 34010355,num = 1,ctype = 36240001,price = 3010,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,300,420}],counter_module = 153,counter_id = 17020,bind = 0,turn = []};

get_shop_config(17021) ->
	#shop{key_id = 17021,shop_type = 17,shop_subtype_list = [],career = [],rank = 19,goods_id = 34010356,num = 1,ctype = 36240001,price = 3920,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,350,500}],counter_module = 153,counter_id = 17021,bind = 0,turn = []};

get_shop_config(17022) ->
	#shop{key_id = 17022,shop_type = 17,shop_subtype_list = [],career = [],rank = 20,goods_id = 34010357,num = 1,ctype = 36240001,price = 5040,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,400,520}],counter_module = 153,counter_id = 17022,bind = 0,turn = []};

get_shop_config(17023) ->
	#shop{key_id = 17023,shop_type = 17,shop_subtype_list = [],career = [],rank = 21,goods_id = 34010358,num = 1,ctype = 36240001,price = 6230,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,420,600}],counter_module = 153,counter_id = 17023,bind = 0,turn = []};

get_shop_config(17024) ->
	#shop{key_id = 17024,shop_type = 17,shop_subtype_list = [],career = [],rank = 22,goods_id = 34010359,num = 1,ctype = 36240001,price = 7910,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,500,999}],counter_module = 153,counter_id = 17024,bind = 0,turn = []};

get_shop_config(17025) ->
	#shop{key_id = 17025,shop_type = 17,shop_subtype_list = [],career = [],rank = 23,goods_id = 34010360,num = 1,ctype = 36240001,price = 9520,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,520,999}],counter_module = 153,counter_id = 17025,bind = 0,turn = []};

get_shop_config(17026) ->
	#shop{key_id = 17026,shop_type = 17,shop_subtype_list = [],career = [],rank = 24,goods_id = 34010361,num = 1,ctype = 36240001,price = 11340,discount = 100,quota_type = 2,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [{lv,600,999}],counter_module = 153,counter_id = 17026,bind = 0,turn = []};

get_shop_config(18003) ->
	#shop{key_id = 18003,shop_type = 18,shop_subtype_list = [],career = [],rank = 1,goods_id = 5902011,num = 1,ctype = 36255115,price = 13500,discount = 100,quota_type = 2,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 18003,bind = 0,turn = []};

get_shop_config(18004) ->
	#shop{key_id = 18004,shop_type = 18,shop_subtype_list = [],career = [],rank = 2,goods_id = 5901005,num = 1,ctype = 36255115,price = 13500,discount = 100,quota_type = 2,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 18004,bind = 0,turn = []};

get_shop_config(18005) ->
	#shop{key_id = 18005,shop_type = 18,shop_subtype_list = [],career = [],rank = 5,goods_id = 16020004,num = 1,ctype = 36255115,price = 100,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 18005,bind = 0,turn = []};

get_shop_config(18006) ->
	#shop{key_id = 18006,shop_type = 18,shop_subtype_list = [],career = [],rank = 6,goods_id = 17020004,num = 1,ctype = 36255115,price = 100,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 18006,bind = 0,turn = []};

get_shop_config(18007) ->
	#shop{key_id = 18007,shop_type = 18,shop_subtype_list = [],career = [],rank = 7,goods_id = 18020004,num = 1,ctype = 36255115,price = 100,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 18007,bind = 0,turn = []};

get_shop_config(18008) ->
	#shop{key_id = 18008,shop_type = 18,shop_subtype_list = [],career = [],rank = 8,goods_id = 19020004,num = 1,ctype = 36255115,price = 100,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 18008,bind = 0,turn = []};

get_shop_config(18009) ->
	#shop{key_id = 18009,shop_type = 18,shop_subtype_list = [],career = [],rank = 9,goods_id = 20020004,num = 1,ctype = 36255115,price = 100,discount = 100,quota_type = 1,quota_num = 30,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 18009,bind = 0,turn = []};

get_shop_config(18010) ->
	#shop{key_id = 18010,shop_type = 18,shop_subtype_list = [],career = [],rank = 3,goods_id = 38040027,num = 1,ctype = 36255115,price = 1000,discount = 100,quota_type = 1,quota_num = 1,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 18010,bind = 0,turn = []};

get_shop_config(18011) ->
	#shop{key_id = 18011,shop_type = 18,shop_subtype_list = [],career = [],rank = 10,goods_id = 38040005,num = 1,ctype = 36255115,price = 10,discount = 100,quota_type = 1,quota_num = 50,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 18011,bind = 0,turn = []};

get_shop_config(18012) ->
	#shop{key_id = 18012,shop_type = 18,shop_subtype_list = [],career = [],rank = 11,goods_id = 37020001,num = 1,ctype = 36255115,price = 200,discount = 100,quota_type = 1,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 18012,bind = 0,turn = []};

get_shop_config(18013) ->
	#shop{key_id = 18013,shop_type = 18,shop_subtype_list = [],career = [],rank = 4,goods_id = 35,num = 30,ctype = 36255115,price = 300,discount = 100,quota_type = 1,quota_num = 2,on_sale = 0,halt_sale = 0,wlv_sale = 0,wlv_unsale = 0,condition = [],counter_module = 153,counter_id = 18013,bind = 0,turn = []};

get_shop_config(_Keyid) ->
	[].

get_shop_config_key() ->
[1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030,2031,2032,2033,2034,2035,2036,2037,2038,2039,2040,2041,2042,2043,2044,3001,3002,3003,3004,3005,3006,3007,3008,3009,3010,3011,3014,3015,3016,3017,3018,3019,6001,6002,6003,6004,6006,6007,6008,6009,6010,6011,6013,6014,6015,7001,7002,7003,7004,7005,8001,8002,8003,8004,8005,10001,10002,10003,10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016,10017,10018,10019,10020,10021,10022,10023,10024,10025,10026,10027,10028,10029,11001,11002,11003,11004,11005,11006,11007,11008,11009,11010,11011,11013,11014,11015,11016,11017,11018,11019,11020,11021,11022,11023,11024,11025,11026,11027,12001,12002,12003,12004,12005,12006,12007,12008,12009,12010,14001,14002,14003,14004,14005,14006,14007,14008,14009,14010,14011,14012,14013,14014,14015,15001,15002,15003,15004,15005,15006,15007,15008,15009,15010,15011,15012,15013,15014,15015,15016,15017,15018,16001,16002,16003,16004,16005,16006,16007,16008,16009,16010,16011,17003,17004,17005,17006,17007,17008,17009,17010,17011,17012,17013,17014,17015,17016,17017,17018,17019,17020,17021,17022,17023,17024,17025,17026,18003,18004,18005,18006,18007,18008,18009,18010,18011,18012,18013].


get_shop(1) ->
[1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013];


get_shop(2) ->
[2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030,2031,2032,2033,2034,2035,2036,2037,2038,2039,2040,2041,2042,2043,2044];


get_shop(3) ->
[3001,3002,3003,3004,3005,3006,3007,3008,3009,3010,3011,3014,3015,3016,3017,3018,3019];


get_shop(6) ->
[6001,6002,6003,6004,6006,6007,6008,6009,6010,6011,6013,6014,6015];


get_shop(7) ->
[7001,7002,7003,7004,7005];


get_shop(8) ->
[8001,8002,8003,8004,8005];


get_shop(10) ->
[10001,10002,10003,10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016,10017,10018,10019,10020,10021,10022,10023,10024,10025,10026,10027,10028,10029];


get_shop(11) ->
[11001,11002,11003,11004,11005,11006,11007,11008,11009,11010,11011,11013,11014,11015,11016,11017,11018,11019,11020,11021,11022,11023,11024,11025,11026,11027];


get_shop(12) ->
[12001,12002,12003,12004,12005,12006,12007,12008,12009,12010];


get_shop(14) ->
[14001,14002,14003,14004,14005,14006,14007,14008,14009,14010,14011,14012,14013,14014,14015];


get_shop(15) ->
[15001,15002,15003,15004,15005,15006,15007,15008,15009,15010,15011,15012,15013,15014,15015,15016,15017,15018];


get_shop(16) ->
[16001,16002,16003,16004,16005,16006,16007,16008,16009,16010,16011];


get_shop(17) ->
[17003,17004,17005,17006,17007,17008,17009,17010,17011,17012,17013,17014,17015,17016,17017,17018,17019,17020,17021,17022,17023,17024,17025,17026];


get_shop(18) ->
[18003,18004,18005,18006,18007,18008,18009,18010,18011,18012,18013];

get_shop(_Shoptype) ->
	[].

get_hit_cost(_Type,_Time) when _Type == 1, _Time >= 1, _Time =< 3 ->
		[{2,0,20},{0,38040003,1}];
get_hit_cost(_Type,_Time) when _Type == 1, _Time >= 4, _Time =< 7 ->
		[{2,0,30},{0,38040003,1}];
get_hit_cost(_Type,_Time) when _Type == 1, _Time >= 8, _Time =< 9999 ->
		[{2,0,50},{0,38040003,1}];
get_hit_cost(_Type,_Time) when _Type == 2, _Time >= 1, _Time =< 1 ->
		[{1,0,0},[]];
get_hit_cost(_Type,_Time) when _Type == 2, _Time >= 2, _Time =< 2 ->
		[{1,0,20},[]];
get_hit_cost(_Type,_Time) when _Type == 2, _Time >= 3, _Time =< 3 ->
		[{1,0,30},[]];
get_hit_cost(_Type,_Time) when _Type == 2, _Time >= 4, _Time =< 9999 ->
		[{1,0,50},[]];
get_hit_cost(_Type,_Time) ->
	0.

get_mystery_goods(1) ->
	#base_shop_good{id = 1,type = 2,career = 1,goods = [{0,6410102,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(2) ->
	#base_shop_good{id = 2,type = 2,career = 1,goods = [{0,6410202,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(3) ->
	#base_shop_good{id = 3,type = 2,career = 1,goods = [{0,6410302,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(4) ->
	#base_shop_good{id = 4,type = 2,career = 1,goods = [{0,6410402,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(5) ->
	#base_shop_good{id = 5,type = 2,career = 1,goods = [{0,6410502,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(6) ->
	#base_shop_good{id = 6,type = 2,career = 1,goods = [{0,6410602,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(7) ->
	#base_shop_good{id = 7,type = 2,career = 1,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(8) ->
	#base_shop_good{id = 8,type = 2,career = 1,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(9) ->
	#base_shop_good{id = 9,type = 2,career = 1,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(10) ->
	#base_shop_good{id = 10,type = 2,career = 1,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(11) ->
	#base_shop_good{id = 11,type = 2,career = 1,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(12) ->
	#base_shop_good{id = 12,type = 2,career = 1,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(13) ->
	#base_shop_good{id = 13,type = 2,career = 1,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(15) ->
	#base_shop_good{id = 15,type = 2,career = 1,goods = [{0,6410102,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(16) ->
	#base_shop_good{id = 16,type = 2,career = 1,goods = [{0,6410202,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(17) ->
	#base_shop_good{id = 17,type = 2,career = 1,goods = [{0,6410302,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(18) ->
	#base_shop_good{id = 18,type = 2,career = 1,goods = [{0,6410402,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(19) ->
	#base_shop_good{id = 19,type = 2,career = 1,goods = [{0,6410502,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(20) ->
	#base_shop_good{id = 20,type = 2,career = 1,goods = [{0,6410602,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(21) ->
	#base_shop_good{id = 21,type = 2,career = 1,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(22) ->
	#base_shop_good{id = 22,type = 2,career = 1,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(23) ->
	#base_shop_good{id = 23,type = 2,career = 1,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(24) ->
	#base_shop_good{id = 24,type = 2,career = 1,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(25) ->
	#base_shop_good{id = 25,type = 2,career = 1,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(26) ->
	#base_shop_good{id = 26,type = 2,career = 1,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(27) ->
	#base_shop_good{id = 27,type = 2,career = 1,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(28) ->
	#base_shop_good{id = 28,type = 2,career = 1,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(29) ->
	#base_shop_good{id = 29,type = 2,career = 1,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(30) ->
	#base_shop_good{id = 30,type = 2,career = 1,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(31) ->
	#base_shop_good{id = 31,type = 2,career = 1,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(32) ->
	#base_shop_good{id = 32,type = 2,career = 1,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(33) ->
	#base_shop_good{id = 33,type = 2,career = 1,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(35) ->
	#base_shop_good{id = 35,type = 2,career = 1,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(36) ->
	#base_shop_good{id = 36,type = 2,career = 1,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(37) ->
	#base_shop_good{id = 37,type = 2,career = 1,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(38) ->
	#base_shop_good{id = 38,type = 2,career = 1,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(39) ->
	#base_shop_good{id = 39,type = 2,career = 1,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(40) ->
	#base_shop_good{id = 40,type = 2,career = 1,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(41) ->
	#base_shop_good{id = 41,type = 2,career = 1,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(42) ->
	#base_shop_good{id = 42,type = 2,career = 1,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(43) ->
	#base_shop_good{id = 43,type = 2,career = 1,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(44) ->
	#base_shop_good{id = 44,type = 2,career = 1,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(45) ->
	#base_shop_good{id = 45,type = 2,career = 1,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(46) ->
	#base_shop_good{id = 46,type = 2,career = 1,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(47) ->
	#base_shop_good{id = 47,type = 2,career = 1,goods = [{0,6410104,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(48) ->
	#base_shop_good{id = 48,type = 2,career = 1,goods = [{0,6410204,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(49) ->
	#base_shop_good{id = 49,type = 2,career = 1,goods = [{0,6410304,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(50) ->
	#base_shop_good{id = 50,type = 2,career = 1,goods = [{0,6410404,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(51) ->
	#base_shop_good{id = 51,type = 2,career = 1,goods = [{0,6410504,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(52) ->
	#base_shop_good{id = 52,type = 2,career = 1,goods = [{0,6410604,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(53) ->
	#base_shop_good{id = 53,type = 2,career = 1,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 10};

get_mystery_goods(55) ->
	#base_shop_good{id = 55,type = 2,career = 1,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(56) ->
	#base_shop_good{id = 56,type = 2,career = 1,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(57) ->
	#base_shop_good{id = 57,type = 2,career = 1,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(58) ->
	#base_shop_good{id = 58,type = 2,career = 1,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(59) ->
	#base_shop_good{id = 59,type = 2,career = 1,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(60) ->
	#base_shop_good{id = 60,type = 2,career = 1,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(61) ->
	#base_shop_good{id = 61,type = 2,career = 1,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(62) ->
	#base_shop_good{id = 62,type = 2,career = 1,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(63) ->
	#base_shop_good{id = 63,type = 2,career = 1,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(64) ->
	#base_shop_good{id = 64,type = 2,career = 1,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(65) ->
	#base_shop_good{id = 65,type = 2,career = 1,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(66) ->
	#base_shop_good{id = 66,type = 2,career = 1,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(67) ->
	#base_shop_good{id = 67,type = 2,career = 1,goods = [{0,6410104,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(68) ->
	#base_shop_good{id = 68,type = 2,career = 1,goods = [{0,6410204,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(69) ->
	#base_shop_good{id = 69,type = 2,career = 1,goods = [{0,6410304,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(70) ->
	#base_shop_good{id = 70,type = 2,career = 1,goods = [{0,6410404,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(71) ->
	#base_shop_good{id = 71,type = 2,career = 1,goods = [{0,6410504,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(72) ->
	#base_shop_good{id = 72,type = 2,career = 1,goods = [{0,6410604,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(73) ->
	#base_shop_good{id = 73,type = 2,career = 1,goods = [{0,6420704,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(74) ->
	#base_shop_good{id = 74,type = 2,career = 1,goods = [{0,6420804,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(75) ->
	#base_shop_good{id = 75,type = 2,career = 1,goods = [{0,6420904,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(76) ->
	#base_shop_good{id = 76,type = 2,career = 1,goods = [{0,6421004,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(77) ->
	#base_shop_good{id = 77,type = 2,career = 1,goods = [{0,6421104,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(78) ->
	#base_shop_good{id = 78,type = 2,career = 1,goods = [{0,6421204,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(79) ->
	#base_shop_good{id = 79,type = 2,career = 1,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 10};

get_mystery_goods(81) ->
	#base_shop_good{id = 81,type = 2,career = 2,goods = [{0,6410102,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(82) ->
	#base_shop_good{id = 82,type = 2,career = 2,goods = [{0,6410202,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(83) ->
	#base_shop_good{id = 83,type = 2,career = 2,goods = [{0,6410302,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(84) ->
	#base_shop_good{id = 84,type = 2,career = 2,goods = [{0,6410402,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(85) ->
	#base_shop_good{id = 85,type = 2,career = 2,goods = [{0,6410502,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(86) ->
	#base_shop_good{id = 86,type = 2,career = 2,goods = [{0,6410602,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(87) ->
	#base_shop_good{id = 87,type = 2,career = 2,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(88) ->
	#base_shop_good{id = 88,type = 2,career = 2,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(89) ->
	#base_shop_good{id = 89,type = 2,career = 2,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(90) ->
	#base_shop_good{id = 90,type = 2,career = 2,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(91) ->
	#base_shop_good{id = 91,type = 2,career = 2,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(92) ->
	#base_shop_good{id = 92,type = 2,career = 2,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(93) ->
	#base_shop_good{id = 93,type = 2,career = 2,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(95) ->
	#base_shop_good{id = 95,type = 2,career = 2,goods = [{0,6410102,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(96) ->
	#base_shop_good{id = 96,type = 2,career = 2,goods = [{0,6410202,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(97) ->
	#base_shop_good{id = 97,type = 2,career = 2,goods = [{0,6410302,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(98) ->
	#base_shop_good{id = 98,type = 2,career = 2,goods = [{0,6410402,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(99) ->
	#base_shop_good{id = 99,type = 2,career = 2,goods = [{0,6410502,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(100) ->
	#base_shop_good{id = 100,type = 2,career = 2,goods = [{0,6410602,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(101) ->
	#base_shop_good{id = 101,type = 2,career = 2,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(102) ->
	#base_shop_good{id = 102,type = 2,career = 2,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(103) ->
	#base_shop_good{id = 103,type = 2,career = 2,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(104) ->
	#base_shop_good{id = 104,type = 2,career = 2,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(105) ->
	#base_shop_good{id = 105,type = 2,career = 2,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(106) ->
	#base_shop_good{id = 106,type = 2,career = 2,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(107) ->
	#base_shop_good{id = 107,type = 2,career = 2,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(108) ->
	#base_shop_good{id = 108,type = 2,career = 2,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(109) ->
	#base_shop_good{id = 109,type = 2,career = 2,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(110) ->
	#base_shop_good{id = 110,type = 2,career = 2,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(111) ->
	#base_shop_good{id = 111,type = 2,career = 2,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(112) ->
	#base_shop_good{id = 112,type = 2,career = 2,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(113) ->
	#base_shop_good{id = 113,type = 2,career = 2,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(115) ->
	#base_shop_good{id = 115,type = 2,career = 2,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(116) ->
	#base_shop_good{id = 116,type = 2,career = 2,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(117) ->
	#base_shop_good{id = 117,type = 2,career = 2,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(118) ->
	#base_shop_good{id = 118,type = 2,career = 2,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(119) ->
	#base_shop_good{id = 119,type = 2,career = 2,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(120) ->
	#base_shop_good{id = 120,type = 2,career = 2,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(121) ->
	#base_shop_good{id = 121,type = 2,career = 2,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(122) ->
	#base_shop_good{id = 122,type = 2,career = 2,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(123) ->
	#base_shop_good{id = 123,type = 2,career = 2,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(124) ->
	#base_shop_good{id = 124,type = 2,career = 2,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(125) ->
	#base_shop_good{id = 125,type = 2,career = 2,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(126) ->
	#base_shop_good{id = 126,type = 2,career = 2,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(127) ->
	#base_shop_good{id = 127,type = 2,career = 2,goods = [{0,6410104,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(128) ->
	#base_shop_good{id = 128,type = 2,career = 2,goods = [{0,6410204,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(129) ->
	#base_shop_good{id = 129,type = 2,career = 2,goods = [{0,6410304,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(130) ->
	#base_shop_good{id = 130,type = 2,career = 2,goods = [{0,6410404,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(131) ->
	#base_shop_good{id = 131,type = 2,career = 2,goods = [{0,6410504,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(132) ->
	#base_shop_good{id = 132,type = 2,career = 2,goods = [{0,6410604,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(133) ->
	#base_shop_good{id = 133,type = 2,career = 2,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 10};

get_mystery_goods(135) ->
	#base_shop_good{id = 135,type = 2,career = 2,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(136) ->
	#base_shop_good{id = 136,type = 2,career = 2,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(137) ->
	#base_shop_good{id = 137,type = 2,career = 2,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(138) ->
	#base_shop_good{id = 138,type = 2,career = 2,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(139) ->
	#base_shop_good{id = 139,type = 2,career = 2,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(140) ->
	#base_shop_good{id = 140,type = 2,career = 2,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(141) ->
	#base_shop_good{id = 141,type = 2,career = 2,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(142) ->
	#base_shop_good{id = 142,type = 2,career = 2,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(143) ->
	#base_shop_good{id = 143,type = 2,career = 2,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(144) ->
	#base_shop_good{id = 144,type = 2,career = 2,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(145) ->
	#base_shop_good{id = 145,type = 2,career = 2,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(146) ->
	#base_shop_good{id = 146,type = 2,career = 2,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(147) ->
	#base_shop_good{id = 147,type = 2,career = 2,goods = [{0,6410104,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(148) ->
	#base_shop_good{id = 148,type = 2,career = 2,goods = [{0,6410204,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(149) ->
	#base_shop_good{id = 149,type = 2,career = 2,goods = [{0,6410304,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(150) ->
	#base_shop_good{id = 150,type = 2,career = 2,goods = [{0,6410404,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(151) ->
	#base_shop_good{id = 151,type = 2,career = 2,goods = [{0,6410504,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(152) ->
	#base_shop_good{id = 152,type = 2,career = 2,goods = [{0,6410604,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(153) ->
	#base_shop_good{id = 153,type = 2,career = 2,goods = [{0,6420704,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(154) ->
	#base_shop_good{id = 154,type = 2,career = 2,goods = [{0,6420804,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(155) ->
	#base_shop_good{id = 155,type = 2,career = 2,goods = [{0,6420904,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(156) ->
	#base_shop_good{id = 156,type = 2,career = 2,goods = [{0,6421004,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(157) ->
	#base_shop_good{id = 157,type = 2,career = 2,goods = [{0,6421104,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(158) ->
	#base_shop_good{id = 158,type = 2,career = 2,goods = [{0,6421204,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(159) ->
	#base_shop_good{id = 159,type = 2,career = 2,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 10};

get_mystery_goods(160) ->
	#base_shop_good{id = 160,type = 2,career = 3,goods = [{0,6410102,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(161) ->
	#base_shop_good{id = 161,type = 2,career = 3,goods = [{0,6410202,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(162) ->
	#base_shop_good{id = 162,type = 2,career = 3,goods = [{0,6410302,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(163) ->
	#base_shop_good{id = 163,type = 2,career = 3,goods = [{0,6410402,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(164) ->
	#base_shop_good{id = 164,type = 2,career = 3,goods = [{0,6410502,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(165) ->
	#base_shop_good{id = 165,type = 2,career = 3,goods = [{0,6410602,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(166) ->
	#base_shop_good{id = 166,type = 2,career = 3,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(167) ->
	#base_shop_good{id = 167,type = 2,career = 3,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(168) ->
	#base_shop_good{id = 168,type = 2,career = 3,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(169) ->
	#base_shop_good{id = 169,type = 2,career = 3,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(170) ->
	#base_shop_good{id = 170,type = 2,career = 3,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(171) ->
	#base_shop_good{id = 171,type = 2,career = 3,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(172) ->
	#base_shop_good{id = 172,type = 2,career = 3,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(173) ->
	#base_shop_good{id = 173,type = 2,career = 3,goods = [{0,6410102,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(174) ->
	#base_shop_good{id = 174,type = 2,career = 3,goods = [{0,6410202,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(175) ->
	#base_shop_good{id = 175,type = 2,career = 3,goods = [{0,6410302,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(176) ->
	#base_shop_good{id = 176,type = 2,career = 3,goods = [{0,6410402,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(177) ->
	#base_shop_good{id = 177,type = 2,career = 3,goods = [{0,6410502,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(178) ->
	#base_shop_good{id = 178,type = 2,career = 3,goods = [{0,6410602,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(179) ->
	#base_shop_good{id = 179,type = 2,career = 3,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(180) ->
	#base_shop_good{id = 180,type = 2,career = 3,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(181) ->
	#base_shop_good{id = 181,type = 2,career = 3,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(182) ->
	#base_shop_good{id = 182,type = 2,career = 3,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(183) ->
	#base_shop_good{id = 183,type = 2,career = 3,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(184) ->
	#base_shop_good{id = 184,type = 2,career = 3,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(185) ->
	#base_shop_good{id = 185,type = 2,career = 3,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(186) ->
	#base_shop_good{id = 186,type = 2,career = 3,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(187) ->
	#base_shop_good{id = 187,type = 2,career = 3,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(188) ->
	#base_shop_good{id = 188,type = 2,career = 3,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(189) ->
	#base_shop_good{id = 189,type = 2,career = 3,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(190) ->
	#base_shop_good{id = 190,type = 2,career = 3,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(191) ->
	#base_shop_good{id = 191,type = 2,career = 3,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(192) ->
	#base_shop_good{id = 192,type = 2,career = 3,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(193) ->
	#base_shop_good{id = 193,type = 2,career = 3,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(194) ->
	#base_shop_good{id = 194,type = 2,career = 3,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(195) ->
	#base_shop_good{id = 195,type = 2,career = 3,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(196) ->
	#base_shop_good{id = 196,type = 2,career = 3,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(197) ->
	#base_shop_good{id = 197,type = 2,career = 3,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(198) ->
	#base_shop_good{id = 198,type = 2,career = 3,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(199) ->
	#base_shop_good{id = 199,type = 2,career = 3,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(200) ->
	#base_shop_good{id = 200,type = 2,career = 3,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(201) ->
	#base_shop_good{id = 201,type = 2,career = 3,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(202) ->
	#base_shop_good{id = 202,type = 2,career = 3,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(203) ->
	#base_shop_good{id = 203,type = 2,career = 3,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(204) ->
	#base_shop_good{id = 204,type = 2,career = 3,goods = [{0,6410104,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(205) ->
	#base_shop_good{id = 205,type = 2,career = 3,goods = [{0,6410204,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(206) ->
	#base_shop_good{id = 206,type = 2,career = 3,goods = [{0,6410304,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(207) ->
	#base_shop_good{id = 207,type = 2,career = 3,goods = [{0,6410404,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(208) ->
	#base_shop_good{id = 208,type = 2,career = 3,goods = [{0,6410504,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(209) ->
	#base_shop_good{id = 209,type = 2,career = 3,goods = [{0,6410604,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(210) ->
	#base_shop_good{id = 210,type = 2,career = 3,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 10};

get_mystery_goods(211) ->
	#base_shop_good{id = 211,type = 2,career = 3,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(212) ->
	#base_shop_good{id = 212,type = 2,career = 3,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(213) ->
	#base_shop_good{id = 213,type = 2,career = 3,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(214) ->
	#base_shop_good{id = 214,type = 2,career = 3,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(215) ->
	#base_shop_good{id = 215,type = 2,career = 3,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(216) ->
	#base_shop_good{id = 216,type = 2,career = 3,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(217) ->
	#base_shop_good{id = 217,type = 2,career = 3,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(218) ->
	#base_shop_good{id = 218,type = 2,career = 3,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(219) ->
	#base_shop_good{id = 219,type = 2,career = 3,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(220) ->
	#base_shop_good{id = 220,type = 2,career = 3,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(221) ->
	#base_shop_good{id = 221,type = 2,career = 3,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(222) ->
	#base_shop_good{id = 222,type = 2,career = 3,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(223) ->
	#base_shop_good{id = 223,type = 2,career = 3,goods = [{0,6410104,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(224) ->
	#base_shop_good{id = 224,type = 2,career = 3,goods = [{0,6410204,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(225) ->
	#base_shop_good{id = 225,type = 2,career = 3,goods = [{0,6410304,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(226) ->
	#base_shop_good{id = 226,type = 2,career = 3,goods = [{0,6410404,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(227) ->
	#base_shop_good{id = 227,type = 2,career = 3,goods = [{0,6410504,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(228) ->
	#base_shop_good{id = 228,type = 2,career = 3,goods = [{0,6410604,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(229) ->
	#base_shop_good{id = 229,type = 2,career = 3,goods = [{0,6420704,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(230) ->
	#base_shop_good{id = 230,type = 2,career = 3,goods = [{0,6420804,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(231) ->
	#base_shop_good{id = 231,type = 2,career = 3,goods = [{0,6420904,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(232) ->
	#base_shop_good{id = 232,type = 2,career = 3,goods = [{0,6421004,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(233) ->
	#base_shop_good{id = 233,type = 2,career = 3,goods = [{0,6421104,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(234) ->
	#base_shop_good{id = 234,type = 2,career = 3,goods = [{0,6421204,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(235) ->
	#base_shop_good{id = 235,type = 2,career = 3,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 10};

get_mystery_goods(236) ->
	#base_shop_good{id = 236,type = 2,career = 4,goods = [{0,6410102,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(237) ->
	#base_shop_good{id = 237,type = 2,career = 4,goods = [{0,6410202,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(238) ->
	#base_shop_good{id = 238,type = 2,career = 4,goods = [{0,6410302,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(239) ->
	#base_shop_good{id = 239,type = 2,career = 4,goods = [{0,6410402,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 120,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(240) ->
	#base_shop_good{id = 240,type = 2,career = 4,goods = [{0,6410502,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(241) ->
	#base_shop_good{id = 241,type = 2,career = 4,goods = [{0,6410602,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(242) ->
	#base_shop_good{id = 242,type = 2,career = 4,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(243) ->
	#base_shop_good{id = 243,type = 2,career = 4,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(244) ->
	#base_shop_good{id = 244,type = 2,career = 4,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(245) ->
	#base_shop_good{id = 245,type = 2,career = 4,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(246) ->
	#base_shop_good{id = 246,type = 2,career = 4,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(247) ->
	#base_shop_good{id = 247,type = 2,career = 4,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 5};

get_mystery_goods(248) ->
	#base_shop_good{id = 248,type = 2,career = 4,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 10};

get_mystery_goods(249) ->
	#base_shop_good{id = 249,type = 2,career = 4,goods = [{0,6410102,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(250) ->
	#base_shop_good{id = 250,type = 2,career = 4,goods = [{0,6410202,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(251) ->
	#base_shop_good{id = 251,type = 2,career = 4,goods = [{0,6410302,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(252) ->
	#base_shop_good{id = 252,type = 2,career = 4,goods = [{0,6410402,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(253) ->
	#base_shop_good{id = 253,type = 2,career = 4,goods = [{0,6410502,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(254) ->
	#base_shop_good{id = 254,type = 2,career = 4,goods = [{0,6410602,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(255) ->
	#base_shop_good{id = 255,type = 2,career = 4,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(256) ->
	#base_shop_good{id = 256,type = 2,career = 4,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(257) ->
	#base_shop_good{id = 257,type = 2,career = 4,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(258) ->
	#base_shop_good{id = 258,type = 2,career = 4,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(259) ->
	#base_shop_good{id = 259,type = 2,career = 4,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(260) ->
	#base_shop_good{id = 260,type = 2,career = 4,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(261) ->
	#base_shop_good{id = 261,type = 2,career = 4,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(262) ->
	#base_shop_good{id = 262,type = 2,career = 4,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(263) ->
	#base_shop_good{id = 263,type = 2,career = 4,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(264) ->
	#base_shop_good{id = 264,type = 2,career = 4,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(265) ->
	#base_shop_good{id = 265,type = 2,career = 4,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(266) ->
	#base_shop_good{id = 266,type = 2,career = 4,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 5};

get_mystery_goods(267) ->
	#base_shop_good{id = 267,type = 2,career = 4,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(268) ->
	#base_shop_good{id = 268,type = 2,career = 4,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(269) ->
	#base_shop_good{id = 269,type = 2,career = 4,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(270) ->
	#base_shop_good{id = 270,type = 2,career = 4,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(271) ->
	#base_shop_good{id = 271,type = 2,career = 4,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 80,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(272) ->
	#base_shop_good{id = 272,type = 2,career = 4,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(273) ->
	#base_shop_good{id = 273,type = 2,career = 4,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 40,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(274) ->
	#base_shop_good{id = 274,type = 2,career = 4,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(275) ->
	#base_shop_good{id = 275,type = 2,career = 4,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(276) ->
	#base_shop_good{id = 276,type = 2,career = 4,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(277) ->
	#base_shop_good{id = 277,type = 2,career = 4,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 60,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(278) ->
	#base_shop_good{id = 278,type = 2,career = 4,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(279) ->
	#base_shop_good{id = 279,type = 2,career = 4,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 5};

get_mystery_goods(280) ->
	#base_shop_good{id = 280,type = 2,career = 4,goods = [{0,6410104,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(281) ->
	#base_shop_good{id = 281,type = 2,career = 4,goods = [{0,6410204,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(282) ->
	#base_shop_good{id = 282,type = 2,career = 4,goods = [{0,6410304,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(283) ->
	#base_shop_good{id = 283,type = 2,career = 4,goods = [{0,6410404,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(284) ->
	#base_shop_good{id = 284,type = 2,career = 4,goods = [{0,6410504,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(285) ->
	#base_shop_good{id = 285,type = 2,career = 4,goods = [{0,6410604,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(286) ->
	#base_shop_good{id = 286,type = 2,career = 4,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 10};

get_mystery_goods(287) ->
	#base_shop_good{id = 287,type = 2,career = 4,goods = [{0,6410103,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(288) ->
	#base_shop_good{id = 288,type = 2,career = 4,goods = [{0,6410203,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(289) ->
	#base_shop_good{id = 289,type = 2,career = 4,goods = [{0,6410303,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(290) ->
	#base_shop_good{id = 290,type = 2,career = 4,goods = [{0,6410403,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(291) ->
	#base_shop_good{id = 291,type = 2,career = 4,goods = [{0,6410503,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(292) ->
	#base_shop_good{id = 292,type = 2,career = 4,goods = [{0,6410603,1}],price_type = 36255025,old_price = [{255,36255025,15}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(293) ->
	#base_shop_good{id = 293,type = 2,career = 4,goods = [{0,6420703,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(294) ->
	#base_shop_good{id = 294,type = 2,career = 4,goods = [{0,6420803,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(295) ->
	#base_shop_good{id = 295,type = 2,career = 4,goods = [{0,6420903,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(296) ->
	#base_shop_good{id = 296,type = 2,career = 4,goods = [{0,6421003,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(297) ->
	#base_shop_good{id = 297,type = 2,career = 4,goods = [{0,6421103,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(298) ->
	#base_shop_good{id = 298,type = 2,career = 4,goods = [{0,6421203,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 5};

get_mystery_goods(299) ->
	#base_shop_good{id = 299,type = 2,career = 4,goods = [{0,6410104,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(300) ->
	#base_shop_good{id = 300,type = 2,career = 4,goods = [{0,6410204,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(301) ->
	#base_shop_good{id = 301,type = 2,career = 4,goods = [{0,6410304,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(302) ->
	#base_shop_good{id = 302,type = 2,career = 4,goods = [{0,6410404,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 50,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(303) ->
	#base_shop_good{id = 303,type = 2,career = 4,goods = [{0,6410504,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(304) ->
	#base_shop_good{id = 304,type = 2,career = 4,goods = [{0,6410604,1}],price_type = 36255025,old_price = [{255,36255025,30}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(305) ->
	#base_shop_good{id = 305,type = 2,career = 4,goods = [{0,6420704,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(306) ->
	#base_shop_good{id = 306,type = 2,career = 4,goods = [{0,6420804,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(307) ->
	#base_shop_good{id = 307,type = 2,career = 4,goods = [{0,6420904,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(308) ->
	#base_shop_good{id = 308,type = 2,career = 4,goods = [{0,6421004,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(309) ->
	#base_shop_good{id = 309,type = 2,career = 4,goods = [{0,6421104,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(310) ->
	#base_shop_good{id = 310,type = 2,career = 4,goods = [{0,6421204,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(311) ->
	#base_shop_good{id = 311,type = 2,career = 4,goods = [{0,38040030,1}],price_type = 36255025,old_price = [{255,36255025,10}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 10};

get_mystery_goods(312) ->
	#base_shop_good{id = 312,type = 2,career = 1,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 3};

get_mystery_goods(313) ->
	#base_shop_good{id = 313,type = 2,career = 2,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 3};

get_mystery_goods(314) ->
	#base_shop_good{id = 314,type = 2,career = 3,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 3};

get_mystery_goods(315) ->
	#base_shop_good{id = 315,type = 2,career = 4,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 75,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [1,320],server_lv = [],limit = 3};

get_mystery_goods(316) ->
	#base_shop_good{id = 316,type = 2,career = 1,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 3};

get_mystery_goods(317) ->
	#base_shop_good{id = 317,type = 2,career = 2,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 3};

get_mystery_goods(318) ->
	#base_shop_good{id = 318,type = 2,career = 3,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 3};

get_mystery_goods(319) ->
	#base_shop_good{id = 319,type = 2,career = 4,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 30,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 3};

get_mystery_goods(320) ->
	#base_shop_good{id = 320,type = 2,career = 1,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 3};

get_mystery_goods(321) ->
	#base_shop_good{id = 321,type = 2,career = 2,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 3};

get_mystery_goods(322) ->
	#base_shop_good{id = 322,type = 2,career = 3,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 3};

get_mystery_goods(323) ->
	#base_shop_good{id = 323,type = 2,career = 4,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 20,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 3};

get_mystery_goods(324) ->
	#base_shop_good{id = 324,type = 2,career = 1,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(325) ->
	#base_shop_good{id = 325,type = 2,career = 2,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(326) ->
	#base_shop_good{id = 326,type = 2,career = 3,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(327) ->
	#base_shop_good{id = 327,type = 2,career = 4,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [321,379],server_lv = [],limit = 10};

get_mystery_goods(328) ->
	#base_shop_good{id = 328,type = 2,career = 1,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(329) ->
	#base_shop_good{id = 329,type = 2,career = 2,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(330) ->
	#base_shop_good{id = 330,type = 2,career = 3,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(331) ->
	#base_shop_good{id = 331,type = 2,career = 4,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(332) ->
	#base_shop_good{id = 332,type = 2,career = 1,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(333) ->
	#base_shop_good{id = 333,type = 2,career = 2,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(334) ->
	#base_shop_good{id = 334,type = 2,career = 3,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(335) ->
	#base_shop_good{id = 335,type = 2,career = 4,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(336) ->
	#base_shop_good{id = 336,type = 2,career = 1,goods = [{0,32010581,1}],price_type = 36255025,old_price = [{255,36255025,100}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(337) ->
	#base_shop_good{id = 337,type = 2,career = 2,goods = [{0,32010581,1}],price_type = 36255025,old_price = [{255,36255025,100}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(338) ->
	#base_shop_good{id = 338,type = 2,career = 3,goods = [{0,32010581,1}],price_type = 36255025,old_price = [{255,36255025,100}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(339) ->
	#base_shop_good{id = 339,type = 2,career = 4,goods = [{0,32010581,1}],price_type = 36255025,old_price = [{255,36255025,100}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 3};

get_mystery_goods(340) ->
	#base_shop_good{id = 340,type = 2,career = 1,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 10};

get_mystery_goods(341) ->
	#base_shop_good{id = 341,type = 2,career = 2,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 10};

get_mystery_goods(342) ->
	#base_shop_good{id = 342,type = 2,career = 3,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 10};

get_mystery_goods(343) ->
	#base_shop_good{id = 343,type = 2,career = 4,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [380,539],server_lv = [],limit = 10};

get_mystery_goods(344) ->
	#base_shop_good{id = 344,type = 2,career = 1,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(345) ->
	#base_shop_good{id = 345,type = 2,career = 2,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(346) ->
	#base_shop_good{id = 346,type = 2,career = 3,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(347) ->
	#base_shop_good{id = 347,type = 2,career = 4,goods = [{0,32010579,1}],price_type = 36255025,old_price = [{255,36255025,40}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(348) ->
	#base_shop_good{id = 348,type = 2,career = 1,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(349) ->
	#base_shop_good{id = 349,type = 2,career = 2,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(350) ->
	#base_shop_good{id = 350,type = 2,career = 3,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(351) ->
	#base_shop_good{id = 351,type = 2,career = 4,goods = [{0,32010580,1}],price_type = 36255025,old_price = [{255,36255025,70}],weight = 15,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(352) ->
	#base_shop_good{id = 352,type = 2,career = 1,goods = [{0,32010581,1}],price_type = 36255025,old_price = [{255,36255025,100}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(353) ->
	#base_shop_good{id = 353,type = 2,career = 2,goods = [{0,32010581,1}],price_type = 36255025,old_price = [{255,36255025,100}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(354) ->
	#base_shop_good{id = 354,type = 2,career = 3,goods = [{0,32010581,1}],price_type = 36255025,old_price = [{255,36255025,100}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(355) ->
	#base_shop_good{id = 355,type = 2,career = 4,goods = [{0,32010581,1}],price_type = 36255025,old_price = [{255,36255025,100}],weight = 10,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 3};

get_mystery_goods(356) ->
	#base_shop_good{id = 356,type = 2,career = 1,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 10};

get_mystery_goods(357) ->
	#base_shop_good{id = 357,type = 2,career = 2,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 10};

get_mystery_goods(358) ->
	#base_shop_good{id = 358,type = 2,career = 3,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 10};

get_mystery_goods(359) ->
	#base_shop_good{id = 359,type = 2,career = 4,goods = [{0,38040100,1}],price_type = 36255025,old_price = [{255,36255025,20}],weight = 25,discount = [{10,100}],show_type = 2,reborn = [0,100],day = [0,9999],role_lv = [540,9999],server_lv = [],limit = 10};

get_mystery_goods(_Id) ->
	[].

get_mystery_config_key() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,81,82,83,84,85,86,87,88,89,90,91,92,93,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359].


get_mystery_ids(2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,81,82,83,84,85,86,87,88,89,90,91,92,93,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359];

get_mystery_ids(_Type) ->
	[].


get_goods_discount(1) ->
[{10,100}];


get_goods_discount(2) ->
[{10,100}];


get_goods_discount(3) ->
[{10,100}];


get_goods_discount(4) ->
[{10,100}];


get_goods_discount(5) ->
[{10,100}];


get_goods_discount(6) ->
[{10,100}];


get_goods_discount(7) ->
[{10,100}];


get_goods_discount(8) ->
[{10,100}];


get_goods_discount(9) ->
[{10,100}];


get_goods_discount(10) ->
[{10,100}];


get_goods_discount(11) ->
[{10,100}];


get_goods_discount(12) ->
[{10,100}];


get_goods_discount(13) ->
[{10,100}];


get_goods_discount(15) ->
[{10,100}];


get_goods_discount(16) ->
[{10,100}];


get_goods_discount(17) ->
[{10,100}];


get_goods_discount(18) ->
[{10,100}];


get_goods_discount(19) ->
[{10,100}];


get_goods_discount(20) ->
[{10,100}];


get_goods_discount(21) ->
[{10,100}];


get_goods_discount(22) ->
[{10,100}];


get_goods_discount(23) ->
[{10,100}];


get_goods_discount(24) ->
[{10,100}];


get_goods_discount(25) ->
[{10,100}];


get_goods_discount(26) ->
[{10,100}];


get_goods_discount(27) ->
[{10,100}];


get_goods_discount(28) ->
[{10,100}];


get_goods_discount(29) ->
[{10,100}];


get_goods_discount(30) ->
[{10,100}];


get_goods_discount(31) ->
[{10,100}];


get_goods_discount(32) ->
[{10,100}];


get_goods_discount(33) ->
[{10,100}];


get_goods_discount(35) ->
[{10,100}];


get_goods_discount(36) ->
[{10,100}];


get_goods_discount(37) ->
[{10,100}];


get_goods_discount(38) ->
[{10,100}];


get_goods_discount(39) ->
[{10,100}];


get_goods_discount(40) ->
[{10,100}];


get_goods_discount(41) ->
[{10,100}];


get_goods_discount(42) ->
[{10,100}];


get_goods_discount(43) ->
[{10,100}];


get_goods_discount(44) ->
[{10,100}];


get_goods_discount(45) ->
[{10,100}];


get_goods_discount(46) ->
[{10,100}];


get_goods_discount(47) ->
[{10,100}];


get_goods_discount(48) ->
[{10,100}];


get_goods_discount(49) ->
[{10,100}];


get_goods_discount(50) ->
[{10,100}];


get_goods_discount(51) ->
[{10,100}];


get_goods_discount(52) ->
[{10,100}];


get_goods_discount(53) ->
[{10,100}];


get_goods_discount(55) ->
[{10,100}];


get_goods_discount(56) ->
[{10,100}];


get_goods_discount(57) ->
[{10,100}];


get_goods_discount(58) ->
[{10,100}];


get_goods_discount(59) ->
[{10,100}];


get_goods_discount(60) ->
[{10,100}];


get_goods_discount(61) ->
[{10,100}];


get_goods_discount(62) ->
[{10,100}];


get_goods_discount(63) ->
[{10,100}];


get_goods_discount(64) ->
[{10,100}];


get_goods_discount(65) ->
[{10,100}];


get_goods_discount(66) ->
[{10,100}];


get_goods_discount(67) ->
[{10,100}];


get_goods_discount(68) ->
[{10,100}];


get_goods_discount(69) ->
[{10,100}];


get_goods_discount(70) ->
[{10,100}];


get_goods_discount(71) ->
[{10,100}];


get_goods_discount(72) ->
[{10,100}];


get_goods_discount(73) ->
[{10,100}];


get_goods_discount(74) ->
[{10,100}];


get_goods_discount(75) ->
[{10,100}];


get_goods_discount(76) ->
[{10,100}];


get_goods_discount(77) ->
[{10,100}];


get_goods_discount(78) ->
[{10,100}];


get_goods_discount(79) ->
[{10,100}];


get_goods_discount(81) ->
[{10,100}];


get_goods_discount(82) ->
[{10,100}];


get_goods_discount(83) ->
[{10,100}];


get_goods_discount(84) ->
[{10,100}];


get_goods_discount(85) ->
[{10,100}];


get_goods_discount(86) ->
[{10,100}];


get_goods_discount(87) ->
[{10,100}];


get_goods_discount(88) ->
[{10,100}];


get_goods_discount(89) ->
[{10,100}];


get_goods_discount(90) ->
[{10,100}];


get_goods_discount(91) ->
[{10,100}];


get_goods_discount(92) ->
[{10,100}];


get_goods_discount(93) ->
[{10,100}];


get_goods_discount(95) ->
[{10,100}];


get_goods_discount(96) ->
[{10,100}];


get_goods_discount(97) ->
[{10,100}];


get_goods_discount(98) ->
[{10,100}];


get_goods_discount(99) ->
[{10,100}];


get_goods_discount(100) ->
[{10,100}];


get_goods_discount(101) ->
[{10,100}];


get_goods_discount(102) ->
[{10,100}];


get_goods_discount(103) ->
[{10,100}];


get_goods_discount(104) ->
[{10,100}];


get_goods_discount(105) ->
[{10,100}];


get_goods_discount(106) ->
[{10,100}];


get_goods_discount(107) ->
[{10,100}];


get_goods_discount(108) ->
[{10,100}];


get_goods_discount(109) ->
[{10,100}];


get_goods_discount(110) ->
[{10,100}];


get_goods_discount(111) ->
[{10,100}];


get_goods_discount(112) ->
[{10,100}];


get_goods_discount(113) ->
[{10,100}];


get_goods_discount(115) ->
[{10,100}];


get_goods_discount(116) ->
[{10,100}];


get_goods_discount(117) ->
[{10,100}];


get_goods_discount(118) ->
[{10,100}];


get_goods_discount(119) ->
[{10,100}];


get_goods_discount(120) ->
[{10,100}];


get_goods_discount(121) ->
[{10,100}];


get_goods_discount(122) ->
[{10,100}];


get_goods_discount(123) ->
[{10,100}];


get_goods_discount(124) ->
[{10,100}];


get_goods_discount(125) ->
[{10,100}];


get_goods_discount(126) ->
[{10,100}];


get_goods_discount(127) ->
[{10,100}];


get_goods_discount(128) ->
[{10,100}];


get_goods_discount(129) ->
[{10,100}];


get_goods_discount(130) ->
[{10,100}];


get_goods_discount(131) ->
[{10,100}];


get_goods_discount(132) ->
[{10,100}];


get_goods_discount(133) ->
[{10,100}];


get_goods_discount(135) ->
[{10,100}];


get_goods_discount(136) ->
[{10,100}];


get_goods_discount(137) ->
[{10,100}];


get_goods_discount(138) ->
[{10,100}];


get_goods_discount(139) ->
[{10,100}];


get_goods_discount(140) ->
[{10,100}];


get_goods_discount(141) ->
[{10,100}];


get_goods_discount(142) ->
[{10,100}];


get_goods_discount(143) ->
[{10,100}];


get_goods_discount(144) ->
[{10,100}];


get_goods_discount(145) ->
[{10,100}];


get_goods_discount(146) ->
[{10,100}];


get_goods_discount(147) ->
[{10,100}];


get_goods_discount(148) ->
[{10,100}];


get_goods_discount(149) ->
[{10,100}];


get_goods_discount(150) ->
[{10,100}];


get_goods_discount(151) ->
[{10,100}];


get_goods_discount(152) ->
[{10,100}];


get_goods_discount(153) ->
[{10,100}];


get_goods_discount(154) ->
[{10,100}];


get_goods_discount(155) ->
[{10,100}];


get_goods_discount(156) ->
[{10,100}];


get_goods_discount(157) ->
[{10,100}];


get_goods_discount(158) ->
[{10,100}];


get_goods_discount(159) ->
[{10,100}];


get_goods_discount(160) ->
[{10,100}];


get_goods_discount(161) ->
[{10,100}];


get_goods_discount(162) ->
[{10,100}];


get_goods_discount(163) ->
[{10,100}];


get_goods_discount(164) ->
[{10,100}];


get_goods_discount(165) ->
[{10,100}];


get_goods_discount(166) ->
[{10,100}];


get_goods_discount(167) ->
[{10,100}];


get_goods_discount(168) ->
[{10,100}];


get_goods_discount(169) ->
[{10,100}];


get_goods_discount(170) ->
[{10,100}];


get_goods_discount(171) ->
[{10,100}];


get_goods_discount(172) ->
[{10,100}];


get_goods_discount(173) ->
[{10,100}];


get_goods_discount(174) ->
[{10,100}];


get_goods_discount(175) ->
[{10,100}];


get_goods_discount(176) ->
[{10,100}];


get_goods_discount(177) ->
[{10,100}];


get_goods_discount(178) ->
[{10,100}];


get_goods_discount(179) ->
[{10,100}];


get_goods_discount(180) ->
[{10,100}];


get_goods_discount(181) ->
[{10,100}];


get_goods_discount(182) ->
[{10,100}];


get_goods_discount(183) ->
[{10,100}];


get_goods_discount(184) ->
[{10,100}];


get_goods_discount(185) ->
[{10,100}];


get_goods_discount(186) ->
[{10,100}];


get_goods_discount(187) ->
[{10,100}];


get_goods_discount(188) ->
[{10,100}];


get_goods_discount(189) ->
[{10,100}];


get_goods_discount(190) ->
[{10,100}];


get_goods_discount(191) ->
[{10,100}];


get_goods_discount(192) ->
[{10,100}];


get_goods_discount(193) ->
[{10,100}];


get_goods_discount(194) ->
[{10,100}];


get_goods_discount(195) ->
[{10,100}];


get_goods_discount(196) ->
[{10,100}];


get_goods_discount(197) ->
[{10,100}];


get_goods_discount(198) ->
[{10,100}];


get_goods_discount(199) ->
[{10,100}];


get_goods_discount(200) ->
[{10,100}];


get_goods_discount(201) ->
[{10,100}];


get_goods_discount(202) ->
[{10,100}];


get_goods_discount(203) ->
[{10,100}];


get_goods_discount(204) ->
[{10,100}];


get_goods_discount(205) ->
[{10,100}];


get_goods_discount(206) ->
[{10,100}];


get_goods_discount(207) ->
[{10,100}];


get_goods_discount(208) ->
[{10,100}];


get_goods_discount(209) ->
[{10,100}];


get_goods_discount(210) ->
[{10,100}];


get_goods_discount(211) ->
[{10,100}];


get_goods_discount(212) ->
[{10,100}];


get_goods_discount(213) ->
[{10,100}];


get_goods_discount(214) ->
[{10,100}];


get_goods_discount(215) ->
[{10,100}];


get_goods_discount(216) ->
[{10,100}];


get_goods_discount(217) ->
[{10,100}];


get_goods_discount(218) ->
[{10,100}];


get_goods_discount(219) ->
[{10,100}];


get_goods_discount(220) ->
[{10,100}];


get_goods_discount(221) ->
[{10,100}];


get_goods_discount(222) ->
[{10,100}];


get_goods_discount(223) ->
[{10,100}];


get_goods_discount(224) ->
[{10,100}];


get_goods_discount(225) ->
[{10,100}];


get_goods_discount(226) ->
[{10,100}];


get_goods_discount(227) ->
[{10,100}];


get_goods_discount(228) ->
[{10,100}];


get_goods_discount(229) ->
[{10,100}];


get_goods_discount(230) ->
[{10,100}];


get_goods_discount(231) ->
[{10,100}];


get_goods_discount(232) ->
[{10,100}];


get_goods_discount(233) ->
[{10,100}];


get_goods_discount(234) ->
[{10,100}];


get_goods_discount(235) ->
[{10,100}];


get_goods_discount(236) ->
[{10,100}];


get_goods_discount(237) ->
[{10,100}];


get_goods_discount(238) ->
[{10,100}];


get_goods_discount(239) ->
[{10,100}];


get_goods_discount(240) ->
[{10,100}];


get_goods_discount(241) ->
[{10,100}];


get_goods_discount(242) ->
[{10,100}];


get_goods_discount(243) ->
[{10,100}];


get_goods_discount(244) ->
[{10,100}];


get_goods_discount(245) ->
[{10,100}];


get_goods_discount(246) ->
[{10,100}];


get_goods_discount(247) ->
[{10,100}];


get_goods_discount(248) ->
[{10,100}];


get_goods_discount(249) ->
[{10,100}];


get_goods_discount(250) ->
[{10,100}];


get_goods_discount(251) ->
[{10,100}];


get_goods_discount(252) ->
[{10,100}];


get_goods_discount(253) ->
[{10,100}];


get_goods_discount(254) ->
[{10,100}];


get_goods_discount(255) ->
[{10,100}];


get_goods_discount(256) ->
[{10,100}];


get_goods_discount(257) ->
[{10,100}];


get_goods_discount(258) ->
[{10,100}];


get_goods_discount(259) ->
[{10,100}];


get_goods_discount(260) ->
[{10,100}];


get_goods_discount(261) ->
[{10,100}];


get_goods_discount(262) ->
[{10,100}];


get_goods_discount(263) ->
[{10,100}];


get_goods_discount(264) ->
[{10,100}];


get_goods_discount(265) ->
[{10,100}];


get_goods_discount(266) ->
[{10,100}];


get_goods_discount(267) ->
[{10,100}];


get_goods_discount(268) ->
[{10,100}];


get_goods_discount(269) ->
[{10,100}];


get_goods_discount(270) ->
[{10,100}];


get_goods_discount(271) ->
[{10,100}];


get_goods_discount(272) ->
[{10,100}];


get_goods_discount(273) ->
[{10,100}];


get_goods_discount(274) ->
[{10,100}];


get_goods_discount(275) ->
[{10,100}];


get_goods_discount(276) ->
[{10,100}];


get_goods_discount(277) ->
[{10,100}];


get_goods_discount(278) ->
[{10,100}];


get_goods_discount(279) ->
[{10,100}];


get_goods_discount(280) ->
[{10,100}];


get_goods_discount(281) ->
[{10,100}];


get_goods_discount(282) ->
[{10,100}];


get_goods_discount(283) ->
[{10,100}];


get_goods_discount(284) ->
[{10,100}];


get_goods_discount(285) ->
[{10,100}];


get_goods_discount(286) ->
[{10,100}];


get_goods_discount(287) ->
[{10,100}];


get_goods_discount(288) ->
[{10,100}];


get_goods_discount(289) ->
[{10,100}];


get_goods_discount(290) ->
[{10,100}];


get_goods_discount(291) ->
[{10,100}];


get_goods_discount(292) ->
[{10,100}];


get_goods_discount(293) ->
[{10,100}];


get_goods_discount(294) ->
[{10,100}];


get_goods_discount(295) ->
[{10,100}];


get_goods_discount(296) ->
[{10,100}];


get_goods_discount(297) ->
[{10,100}];


get_goods_discount(298) ->
[{10,100}];


get_goods_discount(299) ->
[{10,100}];


get_goods_discount(300) ->
[{10,100}];


get_goods_discount(301) ->
[{10,100}];


get_goods_discount(302) ->
[{10,100}];


get_goods_discount(303) ->
[{10,100}];


get_goods_discount(304) ->
[{10,100}];


get_goods_discount(305) ->
[{10,100}];


get_goods_discount(306) ->
[{10,100}];


get_goods_discount(307) ->
[{10,100}];


get_goods_discount(308) ->
[{10,100}];


get_goods_discount(309) ->
[{10,100}];


get_goods_discount(310) ->
[{10,100}];


get_goods_discount(311) ->
[{10,100}];


get_goods_discount(312) ->
[{10,100}];


get_goods_discount(313) ->
[{10,100}];


get_goods_discount(314) ->
[{10,100}];


get_goods_discount(315) ->
[{10,100}];


get_goods_discount(316) ->
[{10,100}];


get_goods_discount(317) ->
[{10,100}];


get_goods_discount(318) ->
[{10,100}];


get_goods_discount(319) ->
[{10,100}];


get_goods_discount(320) ->
[{10,100}];


get_goods_discount(321) ->
[{10,100}];


get_goods_discount(322) ->
[{10,100}];


get_goods_discount(323) ->
[{10,100}];


get_goods_discount(324) ->
[{10,100}];


get_goods_discount(325) ->
[{10,100}];


get_goods_discount(326) ->
[{10,100}];


get_goods_discount(327) ->
[{10,100}];


get_goods_discount(328) ->
[{10,100}];


get_goods_discount(329) ->
[{10,100}];


get_goods_discount(330) ->
[{10,100}];


get_goods_discount(331) ->
[{10,100}];


get_goods_discount(332) ->
[{10,100}];


get_goods_discount(333) ->
[{10,100}];


get_goods_discount(334) ->
[{10,100}];


get_goods_discount(335) ->
[{10,100}];


get_goods_discount(336) ->
[{10,100}];


get_goods_discount(337) ->
[{10,100}];


get_goods_discount(338) ->
[{10,100}];


get_goods_discount(339) ->
[{10,100}];


get_goods_discount(340) ->
[{10,100}];


get_goods_discount(341) ->
[{10,100}];


get_goods_discount(342) ->
[{10,100}];


get_goods_discount(343) ->
[{10,100}];


get_goods_discount(344) ->
[{10,100}];


get_goods_discount(345) ->
[{10,100}];


get_goods_discount(346) ->
[{10,100}];


get_goods_discount(347) ->
[{10,100}];


get_goods_discount(348) ->
[{10,100}];


get_goods_discount(349) ->
[{10,100}];


get_goods_discount(350) ->
[{10,100}];


get_goods_discount(351) ->
[{10,100}];


get_goods_discount(352) ->
[{10,100}];


get_goods_discount(353) ->
[{10,100}];


get_goods_discount(354) ->
[{10,100}];


get_goods_discount(355) ->
[{10,100}];


get_goods_discount(356) ->
[{10,100}];


get_goods_discount(357) ->
[{10,100}];


get_goods_discount(358) ->
[{10,100}];


get_goods_discount(359) ->
[{10,100}];

get_goods_discount(_Id) ->
	[].

get_weight_good(2,1) ->
[{120,1,2},{120,2,2},{120,3,2},{120,4,2},{60,5,2},{60,6,2},{50,7,2},{50,8,2},{50,9,2},{50,10,2},{25,11,2},{25,12,2},{75,13,2},{80,15,2},{80,16,2},{80,17,2},{80,18,2},{40,19,2},{40,20,2},{60,21,2},{60,22,2},{60,23,2},{60,24,2},{30,25,2},{30,26,2},{30,27,2},{30,28,2},{30,29,2},{30,30,2},{15,31,2},{15,32,2},{75,33,2},{80,35,2},{80,36,2},{80,37,2},{80,38,2},{40,39,2},{40,40,2},{60,41,2},{60,42,2},{60,43,2},{60,44,2},{30,45,2},{30,46,2},{30,47,2},{30,48,2},{30,49,2},{30,50,2},{15,51,2},{15,52,2},{75,53,2},{50,55,2},{50,56,2},{50,57,2},{50,58,2},{25,59,2},{25,60,2},{50,61,2},{50,62,2},{50,63,2},{50,64,2},{25,65,2},{25,66,2},{50,67,2},{50,68,2},{50,69,2},{50,70,2},{25,71,2},{25,72,2},{20,73,2},{20,74,2},{20,75,2},{20,76,2},{10,77,2},{10,78,2},{75,79,2},{75,312,2},{30,316,2},{20,320,2},{25,324,2},{25,328,2},{15,332,2},{10,336,2},{25,340,2},{25,344,2},{15,348,2},{10,352,2},{25,356,2}];

get_weight_good(2,2) ->
[{120,81,2},{120,82,2},{120,83,2},{120,84,2},{60,85,2},{60,86,2},{50,87,2},{50,88,2},{50,89,2},{50,90,2},{25,91,2},{25,92,2},{75,93,2},{80,95,2},{80,96,2},{80,97,2},{80,98,2},{40,99,2},{40,100,2},{60,101,2},{60,102,2},{60,103,2},{60,104,2},{30,105,2},{30,106,2},{30,107,2},{30,108,2},{30,109,2},{30,110,2},{15,111,2},{15,112,2},{75,113,2},{80,115,2},{80,116,2},{80,117,2},{80,118,2},{40,119,2},{40,120,2},{60,121,2},{60,122,2},{60,123,2},{60,124,2},{30,125,2},{30,126,2},{30,127,2},{30,128,2},{30,129,2},{30,130,2},{15,131,2},{15,132,2},{75,133,2},{50,135,2},{50,136,2},{50,137,2},{50,138,2},{25,139,2},{25,140,2},{50,141,2},{50,142,2},{50,143,2},{50,144,2},{25,145,2},{25,146,2},{50,147,2},{50,148,2},{50,149,2},{50,150,2},{25,151,2},{25,152,2},{20,153,2},{20,154,2},{20,155,2},{20,156,2},{10,157,2},{10,158,2},{75,159,2},{75,313,2},{30,317,2},{20,321,2},{25,325,2},{25,329,2},{15,333,2},{10,337,2},{25,341,2},{25,345,2},{15,349,2},{10,353,2},{25,357,2}];

get_weight_good(2,3) ->
[{120,160,2},{120,161,2},{120,162,2},{120,163,2},{60,164,2},{60,165,2},{50,166,2},{50,167,2},{50,168,2},{50,169,2},{25,170,2},{25,171,2},{75,172,2},{80,173,2},{80,174,2},{80,175,2},{80,176,2},{40,177,2},{40,178,2},{60,179,2},{60,180,2},{60,181,2},{60,182,2},{30,183,2},{30,184,2},{30,185,2},{30,186,2},{30,187,2},{30,188,2},{15,189,2},{15,190,2},{75,191,2},{80,192,2},{80,193,2},{80,194,2},{80,195,2},{40,196,2},{40,197,2},{60,198,2},{60,199,2},{60,200,2},{60,201,2},{30,202,2},{30,203,2},{30,204,2},{30,205,2},{30,206,2},{30,207,2},{15,208,2},{15,209,2},{75,210,2},{50,211,2},{50,212,2},{50,213,2},{50,214,2},{25,215,2},{25,216,2},{50,217,2},{50,218,2},{50,219,2},{50,220,2},{25,221,2},{25,222,2},{50,223,2},{50,224,2},{50,225,2},{50,226,2},{25,227,2},{25,228,2},{20,229,2},{20,230,2},{20,231,2},{20,232,2},{10,233,2},{10,234,2},{75,235,2},{75,314,2},{30,318,2},{20,322,2},{25,326,2},{25,330,2},{15,334,2},{10,338,2},{25,342,2},{25,346,2},{15,350,2},{10,354,2},{25,358,2}];

get_weight_good(2,4) ->
[{120,236,2},{120,237,2},{120,238,2},{120,239,2},{60,240,2},{60,241,2},{50,242,2},{50,243,2},{50,244,2},{50,245,2},{25,246,2},{25,247,2},{75,248,2},{80,249,2},{80,250,2},{80,251,2},{80,252,2},{40,253,2},{40,254,2},{60,255,2},{60,256,2},{60,257,2},{60,258,2},{30,259,2},{30,260,2},{30,261,2},{30,262,2},{30,263,2},{30,264,2},{15,265,2},{15,266,2},{75,267,2},{80,268,2},{80,269,2},{80,270,2},{80,271,2},{40,272,2},{40,273,2},{60,274,2},{60,275,2},{60,276,2},{60,277,2},{30,278,2},{30,279,2},{30,280,2},{30,281,2},{30,282,2},{30,283,2},{15,284,2},{15,285,2},{75,286,2},{50,287,2},{50,288,2},{50,289,2},{50,290,2},{25,291,2},{25,292,2},{50,293,2},{50,294,2},{50,295,2},{50,296,2},{25,297,2},{25,298,2},{50,299,2},{50,300,2},{50,301,2},{50,302,2},{25,303,2},{25,304,2},{20,305,2},{20,306,2},{20,307,2},{20,308,2},{10,309,2},{10,310,2},{75,311,2},{75,315,2},{30,319,2},{20,323,2},{25,327,2},{25,331,2},{15,335,2},{10,339,2},{25,343,2},{25,347,2},{15,351,2},{10,355,2},{25,359,2}];

get_weight_good(_Type,_Career) ->
	[].

get_special_lv(_Rolelv,2,1) when _Rolelv >= 1 , _Rolelv =< 320 ->
[{120,1,2},{120,2,2},{120,3,2},{120,4,2},{60,5,2},{60,6,2},{50,7,2},{50,8,2},{50,9,2},{50,10,2},{25,11,2},{25,12,2},{75,13,2},{75,312,2}];

get_special_lv(_Rolelv,2,2) when _Rolelv >= 1 , _Rolelv =< 320 ->
[{120,81,2},{120,82,2},{120,83,2},{120,84,2},{60,85,2},{60,86,2},{50,87,2},{50,88,2},{50,89,2},{50,90,2},{25,91,2},{25,92,2},{75,93,2},{75,313,2}];

get_special_lv(_Rolelv,2,3) when _Rolelv >= 1 , _Rolelv =< 320 ->
[{120,160,2},{120,161,2},{120,162,2},{120,163,2},{60,164,2},{60,165,2},{50,166,2},{50,167,2},{50,168,2},{50,169,2},{25,170,2},{25,171,2},{75,172,2},{75,314,2}];

get_special_lv(_Rolelv,2,4) when _Rolelv >= 1 , _Rolelv =< 320 ->
[{120,236,2},{120,237,2},{120,238,2},{120,239,2},{60,240,2},{60,241,2},{50,242,2},{50,243,2},{50,244,2},{50,245,2},{25,246,2},{25,247,2},{75,248,2},{75,315,2}];

get_special_lv(_Rolelv,2,1) when _Rolelv >= 321 , _Rolelv =< 379 ->
[{80,15,2},{80,16,2},{80,17,2},{80,18,2},{40,19,2},{40,20,2},{60,21,2},{60,22,2},{60,23,2},{60,24,2},{30,25,2},{30,26,2},{30,27,2},{30,28,2},{30,29,2},{30,30,2},{15,31,2},{15,32,2},{75,33,2},{30,316,2},{20,320,2},{25,324,2}];

get_special_lv(_Rolelv,2,2) when _Rolelv >= 321 , _Rolelv =< 379 ->
[{80,95,2},{80,96,2},{80,97,2},{80,98,2},{40,99,2},{40,100,2},{60,101,2},{60,102,2},{60,103,2},{60,104,2},{30,105,2},{30,106,2},{30,107,2},{30,108,2},{30,109,2},{30,110,2},{15,111,2},{15,112,2},{75,113,2},{30,317,2},{20,321,2},{25,325,2}];

get_special_lv(_Rolelv,2,3) when _Rolelv >= 321 , _Rolelv =< 379 ->
[{80,173,2},{80,174,2},{80,175,2},{80,176,2},{40,177,2},{40,178,2},{60,179,2},{60,180,2},{60,181,2},{60,182,2},{30,183,2},{30,184,2},{30,185,2},{30,186,2},{30,187,2},{30,188,2},{15,189,2},{15,190,2},{75,191,2},{30,318,2},{20,322,2},{25,326,2}];

get_special_lv(_Rolelv,2,4) when _Rolelv >= 321 , _Rolelv =< 379 ->
[{80,249,2},{80,250,2},{80,251,2},{80,252,2},{40,253,2},{40,254,2},{60,255,2},{60,256,2},{60,257,2},{60,258,2},{30,259,2},{30,260,2},{30,261,2},{30,262,2},{30,263,2},{30,264,2},{15,265,2},{15,266,2},{75,267,2},{30,319,2},{20,323,2},{25,327,2}];

get_special_lv(_Rolelv,2,1) when _Rolelv >= 380 , _Rolelv =< 539 ->
[{80,35,2},{80,36,2},{80,37,2},{80,38,2},{40,39,2},{40,40,2},{60,41,2},{60,42,2},{60,43,2},{60,44,2},{30,45,2},{30,46,2},{30,47,2},{30,48,2},{30,49,2},{30,50,2},{15,51,2},{15,52,2},{75,53,2},{25,328,2},{15,332,2},{10,336,2},{25,340,2}];

get_special_lv(_Rolelv,2,2) when _Rolelv >= 380 , _Rolelv =< 539 ->
[{80,115,2},{80,116,2},{80,117,2},{80,118,2},{40,119,2},{40,120,2},{60,121,2},{60,122,2},{60,123,2},{60,124,2},{30,125,2},{30,126,2},{30,127,2},{30,128,2},{30,129,2},{30,130,2},{15,131,2},{15,132,2},{75,133,2},{25,329,2},{15,333,2},{10,337,2},{25,341,2}];

get_special_lv(_Rolelv,2,3) when _Rolelv >= 380 , _Rolelv =< 539 ->
[{80,192,2},{80,193,2},{80,194,2},{80,195,2},{40,196,2},{40,197,2},{60,198,2},{60,199,2},{60,200,2},{60,201,2},{30,202,2},{30,203,2},{30,204,2},{30,205,2},{30,206,2},{30,207,2},{15,208,2},{15,209,2},{75,210,2},{25,330,2},{15,334,2},{10,338,2},{25,342,2}];

get_special_lv(_Rolelv,2,4) when _Rolelv >= 380 , _Rolelv =< 539 ->
[{80,268,2},{80,269,2},{80,270,2},{80,271,2},{40,272,2},{40,273,2},{60,274,2},{60,275,2},{60,276,2},{60,277,2},{30,278,2},{30,279,2},{30,280,2},{30,281,2},{30,282,2},{30,283,2},{15,284,2},{15,285,2},{75,286,2},{25,331,2},{15,335,2},{10,339,2},{25,343,2}];

get_special_lv(_Rolelv,2,1) when _Rolelv >= 540 , _Rolelv =< 9999 ->
[{50,55,2},{50,56,2},{50,57,2},{50,58,2},{25,59,2},{25,60,2},{50,61,2},{50,62,2},{50,63,2},{50,64,2},{25,65,2},{25,66,2},{50,67,2},{50,68,2},{50,69,2},{50,70,2},{25,71,2},{25,72,2},{20,73,2},{20,74,2},{20,75,2},{20,76,2},{10,77,2},{10,78,2},{75,79,2},{25,344,2},{15,348,2},{10,352,2},{25,356,2}];

get_special_lv(_Rolelv,2,2) when _Rolelv >= 540 , _Rolelv =< 9999 ->
[{50,135,2},{50,136,2},{50,137,2},{50,138,2},{25,139,2},{25,140,2},{50,141,2},{50,142,2},{50,143,2},{50,144,2},{25,145,2},{25,146,2},{50,147,2},{50,148,2},{50,149,2},{50,150,2},{25,151,2},{25,152,2},{20,153,2},{20,154,2},{20,155,2},{20,156,2},{10,157,2},{10,158,2},{75,159,2},{25,345,2},{15,349,2},{10,353,2},{25,357,2}];

get_special_lv(_Rolelv,2,3) when _Rolelv >= 540 , _Rolelv =< 9999 ->
[{50,211,2},{50,212,2},{50,213,2},{50,214,2},{25,215,2},{25,216,2},{50,217,2},{50,218,2},{50,219,2},{50,220,2},{25,221,2},{25,222,2},{50,223,2},{50,224,2},{50,225,2},{50,226,2},{25,227,2},{25,228,2},{20,229,2},{20,230,2},{20,231,2},{20,232,2},{10,233,2},{10,234,2},{75,235,2},{25,346,2},{15,350,2},{10,354,2},{25,358,2}];

get_special_lv(_Rolelv,2,4) when _Rolelv >= 540 , _Rolelv =< 9999 ->
[{50,287,2},{50,288,2},{50,289,2},{50,290,2},{25,291,2},{25,292,2},{50,293,2},{50,294,2},{50,295,2},{50,296,2},{25,297,2},{25,298,2},{50,299,2},{50,300,2},{50,301,2},{50,302,2},{25,303,2},{25,304,2},{20,305,2},{20,306,2},{20,307,2},{20,308,2},{10,309,2},{10,310,2},{75,311,2},{25,347,2},{15,351,2},{10,355,2},{25,359,2}];

get_special_lv(_Rolelv,_Type,_Career) ->
	[].

get_shop_type_list() ->
[{2,0},{2,1},{2,2},{2,3},{2,4}].

get_shop_refresh_time(2,0) ->
[{0,0,0},{6,0,0},{12,0,0},{18,0,0}];

get_shop_refresh_time(2,1) ->
[{0,0,0},{6,0,0},{12,0,0},{18,0,0}];

get_shop_refresh_time(2,2) ->
[{0,0,0},{6,0,0},{12,0,0},{18,0,0}];

get_shop_refresh_time(2,3) ->
[{0,0,0},{6,0,0},{12,0,0},{18,0,0}];

get_shop_refresh_time(2,4) ->
[{0,0,0},{6,0,0},{12,0,0},{18,0,0}];

get_shop_refresh_time(_Type,_Career) ->
	0.

get_goods_type_discount(2,0) ->
2;

get_goods_type_discount(2,1) ->
2;

get_goods_type_discount(2,2) ->
2;

get_goods_type_discount(2,3) ->
2;

get_goods_type_discount(2,4) ->
2;

get_goods_type_discount(_Type,_Career) ->
	0.

get_goods_show_num(2,0) ->
8;

get_goods_show_num(2,1) ->
8;

get_goods_show_num(2,2) ->
8;

get_goods_show_num(2,3) ->
8;

get_goods_show_num(2,4) ->
8;

get_goods_show_num(_Type,_Career) ->
	[].

