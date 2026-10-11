%%%---------------------------------------
%%% module      : data_global_counter
%%% description : 全服计数器配置
%%%
%%%---------------------------------------
-module(data_global_counter).
-compile(export_all).
-include("counter_global.hrl").



get_global_id(0,1) ->
	#base_global_counter{module = 0,id = 1,limit = 0,about = "世界等级不变的等级##测试使用"};

get_global_id(0,2) ->
	#base_global_counter{module = 0,id = 2,limit = 99999,about = "世界等级记录"};

get_global_id(102,1) ->
	#base_global_counter{module = 102,id = 1,limit = 999,about = "是否禁用开服天数设置（0可以设置， 1 禁用设置）"};

get_global_id(133,1) ->
	#base_global_counter{module = 133,id = 1,limit = 99,about = "判断是否首次进入跨服"};

get_global_id(151,1) ->
	#base_global_counter{module = 151,id = 1,limit = 999,about = "是否开启跨服市场"};

get_global_id(151,2) ->
	#base_global_counter{module = 151,id = 2,limit = 0,about = "跨服交易id计数"};

get_global_id(218,1) ->
	#base_global_counter{module = 218,id = 1,limit = 999999,about = "跨服模式"};

get_global_id(331,1) ->
	#base_global_counter{module = 331,id = 1,limit = 0,about = "今日全服活跃度(红包雨)"};

get_global_id(331,2) ->
	#base_global_counter{module = 331,id = 2,limit = 0,about = "今日全服充值额度(红包雨)"};

get_global_id(332,1) ->
	#base_global_counter{module = 332,id = 1,limit = 99999,about = "红包返利登录红包提现次数"};

get_global_id(332,2) ->
	#base_global_counter{module = 332,id = 2,limit = 99999,about = "红包返利充值红包提现次数"};

get_global_id(417,35) ->
	#base_global_counter{module = 417,id = 35,limit = 0,about = "35级等级礼包"};

get_global_id(417,50) ->
	#base_global_counter{module = 417,id = 50,limit = 0,about = "50级等级礼包"};

get_global_id(417,60) ->
	#base_global_counter{module = 417,id = 60,limit = 0,about = "60级等级礼包"};

get_global_id(417,80) ->
	#base_global_counter{module = 417,id = 80,limit = 0,about = "80级等级礼包"};

get_global_id(417,120) ->
	#base_global_counter{module = 417,id = 120,limit = 0,about = "120级等级礼包"};

get_global_id(417,165) ->
	#base_global_counter{module = 417,id = 165,limit = 0,about = "165级等级礼包"};

get_global_id(417,180) ->
	#base_global_counter{module = 417,id = 180,limit = 0,about = "180级等级礼包"};

get_global_id(417,200) ->
	#base_global_counter{module = 417,id = 200,limit = 2000,about = "200级等级礼包"};

get_global_id(417,240) ->
	#base_global_counter{module = 417,id = 240,limit = 500,about = "240级等级礼包"};

get_global_id(417,270) ->
	#base_global_counter{module = 417,id = 270,limit = 50,about = "270级等级礼包"};

get_global_id(417,295) ->
	#base_global_counter{module = 417,id = 295,limit = 20,about = "295级等级礼包"};

get_global_id(417,350) ->
	#base_global_counter{module = 417,id = 350,limit = 3,about = "350级等级礼包"};

get_global_id(604,1) ->
	#base_global_counter{module = 604,id = 1,limit = 0,about = "时间偏移量（用于秘籍）"};

get_global_id(604,2) ->
	#base_global_counter{module = 604,id = 2,limit = 0,about = "当前第几届"};

get_global_id(604,3) ->
	#base_global_counter{module = 604,id = 3,limit = 0,about = "上次报名时间"};

get_global_id(_Module,_Id) ->
	[].

