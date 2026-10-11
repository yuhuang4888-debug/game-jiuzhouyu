%%%---------------------------------------
%%% module      : data_house
%%% description : 家园配置
%%%
%%%---------------------------------------
-module(data_house).
-compile(export_all).
-include("house.hrl").



get_house_lv_con(_) ->
	[].

get_house_scene_list() ->
[].

get_house_lv_list() ->
[].

get_house_location_con(_,_) ->
	[].

get_block_house_id_list(_Blockid) ->
	[].

get_house_furniture_con(_) ->
	[].

get_furniture_id_list() ->
[].

get_house_block_con(_) ->
	[].

get_block_id_list() ->
[].

get_house_theme(_) ->
	[].

get_house_gift_con(1) ->
	#house_gift_con{gift_id = 1,goods_list = [{0,45100001,1}],add_fame = 5,add_intimacy = 5,add_popularity = 5,daily_max = 5,counter_id = 1,wish_word = "一天一点爱恋,我的爱意只增不减！爱你的心天地做证,沧海为媒",se_name = "ui_jiayuanliwu_01",if_send_tv = 0};

get_house_gift_con(_Giftid) ->
	[].

get_house_gift_id_list() ->
[1].

