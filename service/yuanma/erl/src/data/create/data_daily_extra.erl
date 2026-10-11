%%%---------------------------------------
%%% module      : data_daily_extra
%%% description : 日次数id(额外)
%%%
%%%---------------------------------------
-module(data_daily_extra).
-compile(export_all).
-include("daily.hrl").



get_id(140,1) ->
	#base_daily{module = 140,sub_module = 1,limit = 5,clock = 24,write_db = 1,about = "组队通关副本增加亲密度"};

get_id(140,2) ->
	#base_daily{module = 140,sub_module = 2,limit = 5,clock = 24,write_db = 1,about = "组队杀怪增加亲密度"};

get_id(150,1) ->
	#base_daily{module = 150,sub_module = 1,limit = 0,clock = 4,write_db = 1,about = "单个物品掉落次数"};

get_id(150,2) ->
	#base_daily{module = 150,sub_module = 2,limit = 1,clock = 24,write_db = 1,about = "礼包每天次数上限"};

get_id(150,3) ->
	#base_daily{module = 150,sub_module = 3,limit = 0,clock = 24,write_db = 1,about = "物品兑换(通用)"};

get_id(150,7) ->
	#base_daily{module = 150,sub_module = 7,limit = 0,clock = 24,write_db = 1,about = "单日获得货币数量"};

get_id(150,8) ->
	#base_daily{module = 150,sub_module = 8,limit = 0,clock = 24,write_db = 1,about = "单日消费货币数量"};

get_id(153,1) ->
	#base_daily{module = 153,sub_module = 1,limit = 0,clock = 24,write_db = 1,about = "商城"};

get_id(153,2) ->
	#base_daily{module = 153,sub_module = 2,limit = 0,clock = 24,write_db = 1,about = "根据键值商城计数"};

get_id(154,1) ->
	#base_daily{module = 154,sub_module = 1,limit = 0,clock = 4,write_db = 0,about = "拍品购买次数"};

get_id(157,1) ->
	#base_daily{module = 157,sub_module = 1,limit = 0,clock = 4,write_db = 1,about = "活动完成次数"};

get_id(157,2) ->
	#base_daily{module = 157,sub_module = 2,limit = 1,clock = 4,write_db = 1,about = "活跃度奖励"};

get_id(157,3) ->
	#base_daily{module = 157,sub_module = 3,limit = 9999,clock = 4,write_db = 1,about = "可领取活跃度数量"};

get_id(157,4) ->
	#base_daily{module = 157,sub_module = 4,limit = 9999,clock = 4,write_db = 1,about = "已经领取活跃度数量"};

get_id(159,1) ->
	#base_daily{module = 159,sub_module = 1,limit = 1,clock = 24,write_db = 1,about = "福利卡领取次数"};

get_id(159,2) ->
	#base_daily{module = 159,sub_module = 2,limit = 1,clock = 24,write_db = 1,about = "成长基金领取次数"};

get_id(172,7) ->
	#base_daily{module = 172,sub_module = 7,limit = 1,clock = 4,write_db = 0,about = ""};

get_id(183,1) ->
	#base_daily{module = 183,sub_module = 1,limit = 0,clock = 4,write_db = 0,about = "活动每天完成次数"};

get_id(331,28) ->
	#base_daily{module = 331,sub_module = 28,limit = 0,clock = 24,write_db = 1,about = "幸运抽奖次数"};

get_id(331,31) ->
	#base_daily{module = 331,sub_module = 31,limit = 800,clock = 24,write_db = 1,about = "幸运鉴宝幸运值"};

get_id(331,58) ->
	#base_daily{module = 331,sub_module = 58,limit = 10,clock = 24,write_db = 1,about = "赛博夺宝每日超值次数"};

get_id(331,67) ->
	#base_daily{module = 331,sub_module = 67,limit = 9999,clock = 24,write_db = 1,about = "神圣召唤每日免费计数器"};

get_id(331,99) ->
	#base_daily{module = 331,sub_module = 99,limit = 0,clock = 24,write_db = 1,about = "天命转盘免费奖励次数"};

get_id(331,126) ->
	#base_daily{module = 331,sub_module = 126,limit = 0,clock = 24,write_db = 1,about = "活动总览免费奖励次数"};

get_id(339,1) ->
	#base_daily{module = 339,sub_module = 1,limit = 1,clock = 24,write_db = 1,about = "触发式红包"};

get_id(339,2) ->
	#base_daily{module = 339,sub_module = 2,limit = 1,clock = 4,write_db = 1,about = "物品红包使用上限"};

get_id(339,3) ->
	#base_daily{module = 339,sub_module = 3,limit = 1,clock = 24,write_db = 1,about = "活动物品红包使用上限"};

get_id(339,4) ->
	#base_daily{module = 339,sub_module = 4,limit = 0,clock = 24,write_db = 1,about = "vip红包发送上限"};

get_id(400,1) ->
	#base_daily{module = 400,sub_module = 1,limit = 10,clock = 24,write_db = 0,about = "公会捐献"};

get_id(400,2) ->
	#base_daily{module = 400,sub_module = 2,limit = 1,clock = 24,write_db = 0,about = "公会礼包"};

get_id(400,3) ->
	#base_daily{module = 400,sub_module = 3,limit = 1,clock = 24,write_db = 0,about = "公会副本积分奖励"};

get_id(416,1) ->
	#base_daily{module = 416,sub_module = 1,limit = 30000,clock = 24,write_db = 0,about = "装备寻宝次数"};

get_id(416,2) ->
	#base_daily{module = 416,sub_module = 2,limit = 30000,clock = 24,write_db = 1,about = "传奇寻宝次数"};

get_id(416,3) ->
	#base_daily{module = 416,sub_module = 3,limit = 30000,clock = 24,write_db = 1,about = "至尊寻宝次数"};

get_id(416,5) ->
	#base_daily{module = 416,sub_module = 5,limit = 30000,clock = 24,write_db = 1,about = "宝宝寻宝次数"};

get_id(420,2) ->
	#base_daily{module = 420,sub_module = 2,limit = 0,clock = 24,write_db = 1,about = "判断投资活动今日是否需要显示"};

get_id(460,9) ->
	#base_daily{module = 460,sub_module = 9,limit = 5,clock = 4,write_db = 1,about = "获得最大归属次数（疲劳值）"};

get_id(460,10000) ->
	#base_daily{module = 460,sub_module = 10000,limit = 0,clock = 4,write_db = 1,about = "进入本服boss的次数"};

get_id(460,10001) ->
	#base_daily{module = 460,sub_module = 10001,limit = 0,clock = 4,write_db = 1,about = "进入boss的疲劳值"};

get_id(460,10002) ->
	#base_daily{module = 460,sub_module = 10002,limit = 0,clock = 4,write_db = 0,about = "采集次数"};

get_id(470,1) ->
	#base_daily{module = 470,sub_module = 1,limit = 0,clock = 4,write_db = 0,about = "幻兽之域采集次数"};

get_id(510,1) ->
	#base_daily{module = 510,sub_module = 1,limit = 0,clock = 4,write_db = 0,about = "转盘激活次数"};

get_id(610,1) ->
	#base_daily{module = 610,sub_module = 1,limit = 0,clock = 4,write_db = 1,about = "副本进入"};

get_id(610,2) ->
	#base_daily{module = 610,sub_module = 2,limit = 0,clock = 4,write_db = 1,about = "副本协助"};

get_id(610,3) ->
	#base_daily{module = 610,sub_module = 3,limit = 0,clock = 4,write_db = 1,about = "副本完成次数（和副本进入次数保持一致）,进入次数可能被玩家重置，完成次数不会"};

get_id(610,4) ->
	#base_daily{module = 610,sub_module = 4,limit = 0,clock = 4,write_db = 1,about = "副本购买次数"};

get_id(610,5) ->
	#base_daily{module = 610,sub_module = 5,limit = 0,clock = 4,write_db = 1,about = "重置次数"};

get_id(610,6) ->
	#base_daily{module = 610,sub_module = 6,limit = 0,clock = 4,write_db = 1,about = "副本协助奖励次数"};

get_id(610,10) ->
	#base_daily{module = 610,sub_module = 10,limit = 0,clock = 4,write_db = 0,about = "增加副本次数[通过物品等等,不受限制增加]"};

get_id(610,11) ->
	#base_daily{module = 610,sub_module = 11,limit = 0,clock = 4,write_db = 1,about = "副本挑战次数"};

get_id(610,12) ->
	#base_daily{module = 610,sub_module = 12,limit = 0,clock = 4,write_db = 1,about = "副本扫荡次数"};

get_id(_Module,_Submodule) ->
	[].

