%%%---------------------------------------
%%% module      : data_counter_extra
%%% description : 终生次数id(额外)
%%%
%%%---------------------------------------
-module(data_counter_extra).
-compile(export_all).
-include("counter.hrl").



get_id(110,3) ->
	#base_counter{module = 110,sub_module = 3,limit = 1,about = "假人聊天触发次数"};

get_id(130,1) ->
	#base_counter{module = 130,sub_module = 1,limit = 0,about = "玩家信息上报"};

get_id(150,3) ->
	#base_counter{module = 150,sub_module = 3,limit = 0,about = "物品兑换(通用)"};

get_id(150,4) ->
	#base_counter{module = 150,sub_module = 4,limit = 1,about = "装备是否首次合成"};

get_id(150,9) ->
	#base_counter{module = 150,sub_module = 9,limit = 0,about = "奖池礼包当前轮次"};

get_id(150,10) ->
	#base_counter{module = 150,sub_module = 10,limit = 0,about = "奖池礼包当前轮次失败次数"};

get_id(153,1) ->
	#base_counter{module = 153,sub_module = 1,limit = 0,about = "商城"};

get_id(153,2) ->
	#base_counter{module = 153,sub_module = 2,limit = 0,about = "根据键值商城计数"};

get_id(153,1001) ->
	#base_counter{module = 153,sub_module = 1001,limit = 0,about = "前置物品购买次数"};

get_id(155,3) ->
	#base_counter{module = 155,sub_module = 3,limit = 0,about = "圣魂使用次数"};

get_id(159,2) ->
	#base_counter{module = 159,sub_module = 2,limit = 0,about = "用来保存每日累充的周期时间"};

get_id(203,1) ->
	#base_counter{module = 203,sub_module = 1,limit = 999999,about = "挖宝累计次数[{挖宝类型,次数}]"};

get_id(300,1) ->
	#base_counter{module = 300,sub_module = 1,limit = 999,about = "主线任务弹窗相关记录（为了换设备了不弹出）"};

get_id(331,25) ->
	#base_counter{module = 331,sub_module = 25,limit = 1,about = "奖励领取"};

get_id(339,1) ->
	#base_counter{module = 339,sub_module = 1,limit = 1,about = "触发式红包上限"};

get_id(339,2) ->
	#base_counter{module = 339,sub_module = 2,limit = 1,about = "物品红包使用上限"};

get_id(420,2) ->
	#base_counter{module = 420,sub_module = 2,limit = 0,about = "是否要展示图标"};

get_id(450,1) ->
	#base_counter{module = 450,sub_module = 1,limit = 1,about = "特权礼包"};

get_id(450,3) ->
	#base_counter{module = 450,sub_module = 3,limit = 0,about = "当日消耗钻石增加vip经验值，2点重置"};

get_id(450,4) ->
	#base_counter{module = 450,sub_module = 4,limit = 0,about = "当日登录增加的vip经验值，2点重置"};

get_id(460,10003) ->
	#base_counter{module = 460,sub_module = 10003,limit = 0,about = "boss首次奖励,次数id是bossid"};

get_id(460,10004) ->
	#base_counter{module = 460,sub_module = 10004,limit = 0,about = "击杀野外特殊层boss次数"};

get_id(610,1) ->
	#base_counter{module = 610,sub_module = 1,limit = 0,about = "副本进入"};

get_id(610,3) ->
	#base_counter{module = 610,sub_module = 3,limit = 0,about = "副本挑战胜利"};

get_id(610,7) ->
	#base_counter{module = 610,sub_module = 7,limit = 0,about = "额外普通奖励领取"};

get_id(610,8) ->
	#base_counter{module = 610,sub_module = 8,limit = 0,about = "额外顶级奖励领取"};

get_id(610,9) ->
	#base_counter{module = 610,sub_module = 9,limit = 0,about = "额外首次通关奖励"};

get_id(610,10) ->
	#base_counter{module = 610,sub_module = 10,limit = 0,about = "御魂塔解锁层级"};

get_id(_Module,_Submodule) ->
	[].

