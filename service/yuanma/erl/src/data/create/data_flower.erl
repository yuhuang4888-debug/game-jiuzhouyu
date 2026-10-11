%%%---------------------------------------
%%% module      : data_flower
%%% description : 鲜花配置
%%%
%%%---------------------------------------
-module(data_flower).
-compile(export_all).
-include("flower.hrl").



get_flower_gift_cfg(38100001) ->
	#flower_gift_cfg{goods_id = 38100001,intimacy = 1,charm = 1,fame = 1,need_lv = 0,need_vip = 0,is_sell = 1,is_tv = 0,effect_type = 2,effect = "uifx_giftlv8"};

get_flower_gift_cfg(38100002) ->
	#flower_gift_cfg{goods_id = 38100002,intimacy = 9,charm = 9,fame = 9,need_lv = 0,need_vip = 0,is_sell = 1,is_tv = 1,effect_type = 2,effect = "uifx_giftlv8"};

get_flower_gift_cfg(38100003) ->
	#flower_gift_cfg{goods_id = 38100003,intimacy = 99,charm = 99,fame = 99,need_lv = 0,need_vip = 0,is_sell = 1,is_tv = 1,effect_type = 2,effect = "uifx_giftlv1"};

get_flower_gift_cfg(38100004) ->
	#flower_gift_cfg{goods_id = 38100004,intimacy = 199,charm = 199,fame = 199,need_lv = 0,need_vip = 0,is_sell = 1,is_tv = 1,effect_type = 2,effect = "uifx_giftlv3"};

get_flower_gift_cfg(38100005) ->
	#flower_gift_cfg{goods_id = 38100005,intimacy = 399,charm = 399,fame = 399,need_lv = 0,need_vip = 0,is_sell = 1,is_tv = 1,effect_type = 2,effect = "uifx_giftlv4"};

get_flower_gift_cfg(38100006) ->
	#flower_gift_cfg{goods_id = 38100006,intimacy = 599,charm = 599,fame = 599,need_lv = 0,need_vip = 0,is_sell = 1,is_tv = 1,effect_type = 3,effect = "uifx_giftlv5"};

get_flower_gift_cfg(_Goodsid) ->
	[].

get_flower_gift_cfg_ids() ->
[38100001,38100002,38100003,38100004,38100005,38100006].

get_fame_lv_cfg(1) ->
	#fame_lv_cfg{lv = 1,color = 0,name = "人情练达",fame = 400,attr = [{1,150},{2,3000}]};

get_fame_lv_cfg(2) ->
	#fame_lv_cfg{lv = 2,color = 0,name = "左右逢源",fame = 900,attr = [{1,300},{2,6000}]};

get_fame_lv_cfg(3) ->
	#fame_lv_cfg{lv = 3,color = 0,name = "屈尊敬贤",fame = 1800,attr = [{1,500},{2,10000}]};

get_fame_lv_cfg(4) ->
	#fame_lv_cfg{lv = 4,color = 0,name = "八面玲珑",fame = 3600,attr = [{1,800},{2,16000}]};

get_fame_lv_cfg(5) ->
	#fame_lv_cfg{lv = 5,color = 0,name = "高朋满座",fame = 7200,attr = [{1,1200},{2,24000}]};

get_fame_lv_cfg(6) ->
	#fame_lv_cfg{lv = 6,color = 0,name = "宾客盈门",fame = 14400,attr = [{1,1800},{2,36000}]};

get_fame_lv_cfg(7) ->
	#fame_lv_cfg{lv = 7,color = 0,name = "家喻户晓",fame = 28800,attr = [{1,2600},{2,52000}]};

get_fame_lv_cfg(8) ->
	#fame_lv_cfg{lv = 8,color = 0,name = "声名显赫",fame = 57600,attr = [{1,3600},{2,72000}]};

get_fame_lv_cfg(9) ->
	#fame_lv_cfg{lv = 9,color = 0,name = "大名鼎鼎",fame = 115200,attr = [{1,5000},{2,100000}]};

get_fame_lv_cfg(10) ->
	#fame_lv_cfg{lv = 10,color = 0,name = "名动四方",fame = 230400,attr = [{1,7000},{2,140000}]};

get_fame_lv_cfg(11) ->
	#fame_lv_cfg{lv = 11,color = 0,name = "举世闻名",fame = 460800,attr = [{1,10000},{2,200000}]};

get_fame_lv_cfg(_Lv) ->
	[].

get_fame_lv_cfg_ids() ->
[11,10,9,8,7,6,5,4,3,2,1].

