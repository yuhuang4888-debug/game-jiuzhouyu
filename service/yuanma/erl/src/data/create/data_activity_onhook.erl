%%%---------------------------------------
%%% module      : data_activity_onhook
%%% description : 活动托管配置
%%%
%%%---------------------------------------
-module(data_activity_onhook).
-compile(export_all).
-include("activity_onhook.hrl").



get_module(135,0) ->
	#base_activity_onhook_module{module_id = 135,sub_module = 0,name = <<"九天秘境"/utf8>>,cost_min = 2,condition = [{1}, {join, [{lv,130}]}]};

get_module(137,0) ->
	#base_activity_onhook_module{module_id = 137,sub_module = 0,name = <<"钻石大战"/utf8>>,cost_min = 1,condition = [{1}, {join, [{lv,250}]}]};

get_module(218,0) ->
	#base_activity_onhook_module{module_id = 218,sub_module = 0,name = <<"圣灵战场"/utf8>>,cost_min = 2,condition = [{1}, {join, [{lv,130}]}]};

get_module(281,0) ->
	#base_activity_onhook_module{module_id = 281,sub_module = 0,name = <<"巅峰竞技"/utf8>>,cost_min = 2,condition = [{1}, {join, [{lv,180}]}]};

get_module(285,1) ->
	#base_activity_onhook_module{module_id = 285,sub_module = 1,name = <<"午间派对"/utf8>>,cost_min = 2,condition = [{1}, {join, [{lv,100}]}]};

get_module(402,2) ->
	#base_activity_onhook_module{module_id = 402,sub_module = 2,name = <<"晚宴"/utf8>>,cost_min = 2,condition = [{1}, {join, [{lv,95},{guild,1}]}]};

get_module(506,0) ->
	#base_activity_onhook_module{module_id = 506,sub_module = 0,name = <<"最强结社"/utf8>>,cost_min = 1,condition = [{2}, {join, [{lv,125},{guild,1}]}]};

get_module(621,0) ->
	#base_activity_onhook_module{module_id = 621,sub_module = 0,name = <<"最强王者"/utf8>>,cost_min = 1,condition = [{1}, {join, [{lv,125}]}]};

get_module(652,31) ->
	#base_activity_onhook_module{module_id = 652,sub_module = 31,name = <<"领地夺宝"/utf8>>,cost_min = 2,condition = [{0}, {join, [{lv,160},{open,[2,4]}]}]};

get_module(_Moduleid,_Submodule) ->
	[].

get_all_onhook_act() ->
[{135,0},{137,0},{218,0},{281,0},{285,1},{402,2},{506,0},{621,0},{652,31}].

get_module_bahaviour(281,0,1) ->
	#base_activity_onhook_module_behaviour{module_id = 281,sub_module = 0,behaviour_id = 1,name = <<"购买匹配次数"/utf8>>,behaviour_list = [{buy_cnt, 3}]};

get_module_bahaviour(402,2,1) ->
	#base_activity_onhook_module_behaviour{module_id = 402,sub_module = 2,behaviour_id = 1,name = <<"购买食物"/utf8>>,behaviour_list = [{buy_food, 1, 1}]};

get_module_bahaviour(402,2,2) ->
	#base_activity_onhook_module_behaviour{module_id = 402,sub_module = 2,behaviour_id = 2,name = <<"购买食物"/utf8>>,behaviour_list = [{buy_food, 2, 1}]};

get_module_bahaviour(402,2,3) ->
	#base_activity_onhook_module_behaviour{module_id = 402,sub_module = 2,behaviour_id = 3,name = <<"购买食物"/utf8>>,behaviour_list = [{buy_food, 3, 1}]};

get_module_bahaviour(_Moduleid,_Submodule,_Behaviourid) ->
	[].

