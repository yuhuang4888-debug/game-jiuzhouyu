%%%---------------------------------------
%%% module      : data_global_counter_extra
%%% description : 全服计数器(额外)配置
%%%
%%%---------------------------------------
-module(data_global_counter_extra).
-compile(export_all).
-include("counter_global.hrl").



get_global_id(150,1) ->
	#base_global_counter{module = 150,sub_module = 1,limit = 0,about = "全局怪物掉落上限"};

get_global_id(331,4) ->
	#base_global_counter{module = 331,sub_module = 4,limit = 0,about = "开服集字"};

get_global_id(331,22) ->
	#base_global_counter{module = 331,sub_module = 22,limit = 0,about = "烟花活动物品全服次数"};

get_global_id(331,59) ->
	#base_global_counter{module = 331,sub_module = 59,limit = 0,about = "节日抢购"};

get_global_id(331,68) ->
	#base_global_counter{module = 331,sub_module = 68,limit = 0,about = "全服抢购次数"};

get_global_id(331,86) ->
	#base_global_counter{module = 331,sub_module = 86,limit = 0,about = "充值返利重置活动状态记录"};

get_global_id(331,114) ->
	#base_global_counter{module = 331,sub_module = 114,limit = 0,about = "冲榜抢购"};

get_global_id(331,121) ->
	#base_global_counter{module = 331,sub_module = 121,limit = 0,about = "累充有礼的全服充值人数"};

get_global_id(417,1) ->
	#base_global_counter{module = 417,sub_module = 1,limit = 0,about = "福利等级礼包"};

get_global_id(610,1) ->
	#base_global_counter{module = 610,sub_module = 1,limit = 0,about = "限时爬塔的当前轮数"};

get_global_id(610,2) ->
	#base_global_counter{module = 610,sub_module = 2,limit = 0,about = "限时爬塔的结束时间"};

get_global_id(_Module,_Submodule) ->
	[].

