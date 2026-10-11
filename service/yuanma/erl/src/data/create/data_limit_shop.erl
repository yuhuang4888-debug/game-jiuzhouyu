%%%---------------------------------------
%%% module      : data_limit_shop
%%% description : 神秘限购配置
%%%
%%%---------------------------------------
-module(data_limit_shop).
-compile(export_all).
-include("limit_shop.hrl").



get_ls_sell_con_info(1) ->
	#limit_shop_sell_con{sell_id = 1,goods_list = [{0,32010101,1}],sell_name = "金币*100万",cost_list = [{1,0,1}],discount = 1,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(2) ->
	#limit_shop_sell_con{sell_id = 2,goods_list = [{0,32010188,10}],sell_name = "紫色经验符文",cost_list = [{1,0,30}],discount = 10,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(3) ->
	#limit_shop_sell_con{sell_id = 3,goods_list = [{0,26010003,1}],sell_name = "紫色经验符文",cost_list = [{1,0,12}],discount = 10,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(4) ->
	#limit_shop_sell_con{sell_id = 4,goods_list = [{0,37020002,1}],sell_name = "2倍经验药水",cost_list = [{1,0,15}],discount = 10,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(5) ->
	#limit_shop_sell_con{sell_id = 5,goods_list = [{0,38040044,3}],sell_name = "晋升之证",cost_list = [{1,0,15}],discount = 10,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(6) ->
	#limit_shop_sell_con{sell_id = 6,goods_list = [{0,20020001,10}],sell_name = "初级源晶",cost_list = [{1,0,30}],discount = 30,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(7) ->
	#limit_shop_sell_con{sell_id = 7,goods_list = [{0,14020004,1}],sell_name = "4级防御宝石",cost_list = [{1,0,162}],discount = 30,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(8) ->
	#limit_shop_sell_con{sell_id = 8,goods_list = [{0,38100003,10}],sell_name = "999朵玫瑰",cost_list = [{1,0,99}],discount = 10,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(9) ->
	#limit_shop_sell_con{sell_id = 9,goods_list = [{0,53010304,1}],sell_name = "冰川巨猿图鉴",cost_list = [{1,0,30}],discount = 30,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(10) ->
	#limit_shop_sell_con{sell_id = 10,goods_list = [{0,32010193,2}],sell_name = "伙伴升星石宝箱",cost_list = [{1,0,160}],discount = 40,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(11) ->
	#limit_shop_sell_con{sell_id = 11,goods_list = [{0,32010194,2}],sell_name = "伙伴升阶石宝箱",cost_list = [{1,0,160}],discount = 40,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(12) ->
	#limit_shop_sell_con{sell_id = 12,goods_list = [{0,38040005,100}],sell_name = "洗炼石",cost_list = [{1,0,20}],discount = 20,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(13) ->
	#limit_shop_sell_con{sell_id = 13,goods_list = [{0,38040027,2}],sell_name = "洗炼之尘",cost_list = [{1,0,40}],discount = 40,limit_num = 1,limit_time = 86400,start_lv = 999};

get_ls_sell_con_info(_Sellid) ->
	[].

get_ls_sell_lv_list() ->
[999].


get_ls_sell_id(999) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13];

get_ls_sell_id(_Startlv) ->
	[].

