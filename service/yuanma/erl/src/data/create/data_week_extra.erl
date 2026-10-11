%%%---------------------------------------
%%% module      : data_week_extra
%%% description : 周次数id(额外)
%%%
%%%---------------------------------------
-module(data_week_extra).
-compile(export_all).
-include("week.hrl").



get_id(150,1) ->
	#base_week{module = 150,sub_module = 1,limit = 0,about = "周掉落"};

get_id(150,3) ->
	#base_week{module = 150,sub_module = 3,limit = 0,about = "物品兑换(通用)"};

get_id(153,1) ->
	#base_week{module = 153,sub_module = 1,limit = 0,about = "商城"};

get_id(153,2) ->
	#base_week{module = 153,sub_module = 2,limit = 0,about = "根据键值商城计数"};

get_id(154,1) ->
	#base_week{module = 154,sub_module = 1,limit = 0,about = "拍品购买次数"};

get_id(339,1) ->
	#base_week{module = 339,sub_module = 1,limit = 1,about = "触发式红包上限"};

get_id(339,2) ->
	#base_week{module = 339,sub_module = 2,limit = 1,about = "物品红包使用上限"};

get_id(508,1) ->
	#base_week{module = 508,sub_module = 1,limit = 0,about = "副本通关"};

get_id(508,2) ->
	#base_week{module = 508,sub_module = 2,limit = 0,about = "击杀boss"};

get_id(508,3) ->
	#base_week{module = 508,sub_module = 3,limit = 0,about = ""};

get_id(610,1) ->
	#base_week{module = 610,sub_module = 1,limit = 0,about = "副本进入"};

get_id(_Module,_Submodule) ->
	[].

