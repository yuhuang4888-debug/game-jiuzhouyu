%%%---------------------------------------
%%% module      : data_daily
%%% description : 每日次数配置
%%%
%%%---------------------------------------
-module(data_daily).
-compile(export_all).
-include("daily.hrl").



get_id(102,1) ->
	#base_daily{module = 102,id = 1,limit = 999999,clock = 24,write_db = 1,about = "玩家一天的的死亡次数"};

get_id(102,2) ->
	#base_daily{module = 102,id = 2,limit = 0,clock = 24,write_db = 1,about = "玩家一天在线时间"};

get_id(130,1) ->
	#base_daily{module = 130,id = 1,limit = 1,clock = 24,write_db = 1,about = "玩家头像上传限制"};

get_id(132,1) ->
	#base_daily{module = 132,id = 1,limit = 0,clock = 24,write_db = 1,about = "每天经验补偿物品次数"};

get_id(132,2) ->
	#base_daily{module = 132,id = 2,limit = 1,clock = 24,write_db = 1,about = "跨天离线挂机新增推送次数"};

get_id(133,1) ->
	#base_daily{module = 133,id = 1,limit = 0,clock = 24,write_db = 1,about = "玩家每日封印次数"};

get_id(133,2) ->
	#base_daily{module = 133,id = 2,limit = 0,clock = 24,write_db = 1,about = "玩家扫荡封印次数"};

get_id(133,3) ->
	#base_daily{module = 133,id = 3,limit = 999,clock = 4,write_db = 1,about = "玩家每日请求协助次数"};

get_id(151,1) ->
	#base_daily{module = 151,id = 1,limit = 10,clock = 4,write_db = 1,about = "玩家每日交易次数上限"};

get_id(151,2) ->
	#base_daily{module = 151,id = 2,limit = 0,clock = 4,write_db = 1,about = "玩家每日出售获得的钻石限制"};

get_id(151,3) ->
	#base_daily{module = 151,id = 3,limit = 0,clock = 4,write_db = 1,about = "玩家每日购买所消耗钻石限制"};

get_id(152,1) ->
	#base_daily{module = 152,id = 1,limit = 99,clock = 4,write_db = 1,about = "装备洗练次数"};

get_id(153,2039) ->
	#base_daily{module = 153,id = 2039,limit = 30,clock = 24,write_db = 1,about = "38340001"};

get_id(153,2040) ->
	#base_daily{module = 153,id = 2040,limit = 30,clock = 24,write_db = 1,about = "38340003"};

get_id(153,2041) ->
	#base_daily{module = 153,id = 2041,limit = 38340004,clock = 24,write_db = 1,about = "38340004"};

get_id(153,2042) ->
	#base_daily{module = 153,id = 2042,limit = 30,clock = 24,write_db = 1,about = "38340005"};

get_id(153,6001) ->
	#base_daily{module = 153,id = 6001,limit = 1,clock = 24,write_db = 1,about = "16010001"};

get_id(153,6002) ->
	#base_daily{module = 153,id = 6002,limit = 1,clock = 24,write_db = 1,about = "17010001"};

get_id(153,6003) ->
	#base_daily{module = 153,id = 6003,limit = 1,clock = 24,write_db = 1,about = "32010158"};

get_id(153,6004) ->
	#base_daily{module = 153,id = 6004,limit = 1,clock = 24,write_db = 1,about = "38030001"};

get_id(153,6005) ->
	#base_daily{module = 153,id = 6005,limit = 5,clock = 24,write_db = 1,about = "38040001"};

get_id(153,6006) ->
	#base_daily{module = 153,id = 6006,limit = 1,clock = 24,write_db = 1,about = "37020001"};

get_id(153,6007) ->
	#base_daily{module = 153,id = 6007,limit = 1,clock = 24,write_db = 1,about = "14010001"};

get_id(153,6008) ->
	#base_daily{module = 153,id = 6008,limit = 1,clock = 24,write_db = 1,about = "14020001"};

get_id(153,6009) ->
	#base_daily{module = 153,id = 6009,limit = 2,clock = 24,write_db = 1,about = "38040044"};

get_id(153,6010) ->
	#base_daily{module = 153,id = 6010,limit = 6,clock = 24,write_db = 1,about = "16020001"};

get_id(153,6011) ->
	#base_daily{module = 153,id = 6011,limit = 5,clock = 24,write_db = 1,about = "32010468"};

get_id(153,6012) ->
	#base_daily{module = 153,id = 6012,limit = 3,clock = 24,write_db = 1,about = "39510012"};

get_id(153,6015) ->
	#base_daily{module = 153,id = 6015,limit = 10,clock = 24,write_db = 1,about = "38340002"};

get_id(153,7001) ->
	#base_daily{module = 153,id = 7001,limit = 1,clock = 24,write_db = 1,about = "32010163"};

get_id(153,7002) ->
	#base_daily{module = 153,id = 7002,limit = 5,clock = 24,write_db = 1,about = "32010164"};

get_id(153,7003) ->
	#base_daily{module = 153,id = 7003,limit = 5,clock = 24,write_db = 1,about = "32010165"};

get_id(153,7004) ->
	#base_daily{module = 153,id = 7004,limit = 1,clock = 24,write_db = 1,about = "6101001"};

get_id(153,7005) ->
	#base_daily{module = 153,id = 7005,limit = 1,clock = 24,write_db = 1,about = "6101002"};

get_id(153,7006) ->
	#base_daily{module = 153,id = 7006,limit = 1,clock = 24,write_db = 1,about = "32010168"};

get_id(153,7007) ->
	#base_daily{module = 153,id = 7007,limit = 5,clock = 24,write_db = 1,about = "32010169"};

get_id(153,7008) ->
	#base_daily{module = 153,id = 7008,limit = 5,clock = 24,write_db = 1,about = "32010170"};

get_id(153,7009) ->
	#base_daily{module = 153,id = 7009,limit = 1,clock = 24,write_db = 1,about = "32010171"};

get_id(153,7010) ->
	#base_daily{module = 153,id = 7010,limit = 5,clock = 24,write_db = 1,about = "32010172"};

get_id(153,7011) ->
	#base_daily{module = 153,id = 7011,limit = 5,clock = 24,write_db = 1,about = "32010173"};

get_id(153,8001) ->
	#base_daily{module = 153,id = 8001,limit = 1,clock = 24,write_db = 1,about = "32010174"};

get_id(153,8002) ->
	#base_daily{module = 153,id = 8002,limit = 5,clock = 24,write_db = 1,about = "32010175"};

get_id(153,8003) ->
	#base_daily{module = 153,id = 8003,limit = 5,clock = 24,write_db = 1,about = "32010176"};

get_id(153,8004) ->
	#base_daily{module = 153,id = 8004,limit = 1,clock = 24,write_db = 1,about = "6101001"};

get_id(153,8005) ->
	#base_daily{module = 153,id = 8005,limit = 1,clock = 24,write_db = 1,about = "6101002"};

get_id(153,11001) ->
	#base_daily{module = 153,id = 11001,limit = 1,clock = 4,write_db = 1,about = "19010001"};

get_id(153,11002) ->
	#base_daily{module = 153,id = 11002,limit = 1,clock = 4,write_db = 1,about = "18010001"};

get_id(153,11003) ->
	#base_daily{module = 153,id = 11003,limit = 10,clock = 4,write_db = 1,about = "39510000"};

get_id(153,11004) ->
	#base_daily{module = 153,id = 11004,limit = 1,clock = 4,write_db = 1,about = "32010315"};

get_id(153,11005) ->
	#base_daily{module = 153,id = 11005,limit = 2,clock = 4,write_db = 1,about = "32010317"};

get_id(153,11006) ->
	#base_daily{module = 153,id = 11006,limit = 2,clock = 4,write_db = 1,about = "32010318"};

get_id(153,11007) ->
	#base_daily{module = 153,id = 11007,limit = 5,clock = 4,write_db = 1,about = "7110001"};

get_id(153,11008) ->
	#base_daily{module = 153,id = 11008,limit = 1,clock = 4,write_db = 1,about = "7120102"};

get_id(153,11011) ->
	#base_daily{module = 153,id = 11011,limit = 1,clock = 4,write_db = 1,about = "38040076"};

get_id(153,11012) ->
	#base_daily{module = 153,id = 11012,limit = 1,clock = 4,write_db = 1,about = "32060061"};

get_id(153,16007) ->
	#base_daily{module = 153,id = 16007,limit = 10,clock = 24,write_db = 1,about = "38040087"};

get_id(153,16008) ->
	#base_daily{module = 153,id = 16008,limit = 10,clock = 24,write_db = 1,about = "38040088"};

get_id(153,16009) ->
	#base_daily{module = 153,id = 16009,limit = 10,clock = 24,write_db = 1,about = "38040089"};

get_id(153,16010) ->
	#base_daily{module = 153,id = 16010,limit = 10,clock = 24,write_db = 1,about = "38040090"};

get_id(155,1) ->
	#base_daily{module = 155,id = 1,limit = 1,clock = 4,write_db = 1,about = "圣殿每日进入次数"};

get_id(157,1) ->
	#base_daily{module = 157,id = 1,limit = 1000,clock = 4,write_db = 1,about = "玩家活跃度"};

get_id(172,1) ->
	#base_daily{module = 172,id = 1,limit = 0,clock = 24,write_db = 1,about = "宝宝点赞次数"};

get_id(177,1) ->
	#base_daily{module = 177,id = 1,limit = 5,clock = 24,write_db = 1,about = "家园礼物-沧海遗珠"};

get_id(177,2) ->
	#base_daily{module = 177,id = 2,limit = 10,clock = 24,write_db = 1,about = "家园礼物-为爱加冕"};

get_id(177,3) ->
	#base_daily{module = 177,id = 3,limit = 10,clock = 24,write_db = 1,about = "家园礼物-似水年华"};

get_id(177,4) ->
	#base_daily{module = 177,id = 4,limit = 0,clock = 4,write_db = 1,about = "家园庭院许愿令每日领取状态"};

get_id(179,1) ->
	#base_daily{module = 179,id = 1,limit = 1,clock = 24,write_db = 1,about = "每日充值"};

get_id(183,1) ->
	#base_daily{module = 183,id = 1,limit = 1,clock = 24,write_db = 1,about = "是否打开过黑市"};

get_id(186,1) ->
	#base_daily{module = 186,id = 1,limit = 1,clock = 4,write_db = 1,about = "怒海争霸每日福利"};

get_id(187,1) ->
	#base_daily{module = 187,id = 1,limit = 999999,clock = 4,write_db = 1,about = "杀人次数"};

get_id(187,2) ->
	#base_daily{module = 187,id = 2,limit = 1500,clock = 4,write_db = 1,about = "海域功勋每日获取峰值"};

get_id(189,1) ->
	#base_daily{module = 189,id = 1,limit = 999,clock = 4,write_db = 1,about = "每日巡航次数"};

get_id(189,2) ->
	#base_daily{module = 189,id = 2,limit = 999,clock = 4,write_db = 1,about = "每日掠夺次数"};

get_id(189,3) ->
	#base_daily{module = 189,id = 3,limit = 999,clock = 4,write_db = 1,about = "每日基础升档奖励免费次数"};

get_id(189,4) ->
	#base_daily{module = 189,id = 4,limit = 999,clock = 4,write_db = 1,about = "每日获取绑钻数量"};

get_id(189,5) ->
	#base_daily{module = 189,id = 5,limit = 9999,clock = 4,write_db = 1,about = "当前船只档次幸运值"};

get_id(189,6) ->
	#base_daily{module = 189,id = 6,limit = 999,clock = 4,write_db = 1,about = "每日船只档次记录"};

get_id(190,2) ->
	#base_daily{module = 190,id = 2,limit = 20,clock = 24,write_db = 1,about = "发送公会邮件次数"};

get_id(192,1) ->
	#base_daily{module = 192,id = 1,limit = 9999,clock = 4,write_db = 1,about = "记录每日托管值获取量"};

get_id(192,2) ->
	#base_daily{module = 192,id = 2,limit = 0,clock = 24,write_db = 1,about = "每日托管值消耗量"};

get_id(221,1) ->
	#base_daily{module = 221,id = 1,limit = 3,clock = 24,write_db = 1,about = "榜单点赞次数"};

get_id(233,1) ->
	#base_daily{module = 233,id = 1,limit = 100,clock = 4,write_db = 1,about = "神之所开启橙水晶次数"};

get_id(280,1) ->
	#base_daily{module = 280,id = 1,limit = 10,clock = 24,write_db = 1,about = "竞技场鼓舞次数"};

get_id(280,2) ->
	#base_daily{module = 280,id = 2,limit = 10,clock = 24,write_db = 1,about = "竞技挑战使用次数"};

get_id(280,3) ->
	#base_daily{module = 280,id = 3,limit = 0,clock = 4,write_db = 1,about = "竞技购买次数"};

get_id(280,4) ->
	#base_daily{module = 280,id = 4,limit = 10,clock = 4,write_db = 1,about = "竞技场每日挑战次数"};

get_id(281,1) ->
	#base_daily{module = 281,id = 1,limit = 0,clock = 4,write_db = 1,about = "巅峰竞技奖励日常领取"};

get_id(281,2) ->
	#base_daily{module = 281,id = 2,limit = 10,clock = 4,write_db = 1,about = "巅峰竞技每日可参与次数"};

get_id(281,3) ->
	#base_daily{module = 281,id = 3,limit = 0,clock = 4,write_db = 1,about = "购买次数"};

get_id(281,4) ->
	#base_daily{module = 281,id = 4,limit = 0,clock = 4,write_db = 1,about = "每日次数奖励领取"};

get_id(283,1) ->
	#base_daily{module = 283,id = 1,limit = 999,clock = 24,write_db = 1,about = "打开圣域界面次数"};

get_id(283,2) ->
	#base_daily{module = 283,id = 2,limit = 9999,clock = 24,write_db = 1,about = "打开圣域界面后的登录次数"};

get_id(283,3) ->
	#base_daily{module = 283,id = 3,limit = 9999,clock = 4,write_db = 1,about = "圣域疲劳值"};

get_id(283,4) ->
	#base_daily{module = 283,id = 4,limit = 9999,clock = 4,write_db = 1,about = "归属奖励限制"};

get_id(284,1) ->
	#base_daily{module = 284,id = 1,limit = 1,clock = 24,write_db = 1,about = "跨服圣域是否清理疲劳计数器"};

get_id(285,1) ->
	#base_daily{module = 285,id = 1,limit = 9999,clock = 4,write_db = 1,about = "普通宝箱采集次数"};

get_id(285,2) ->
	#base_daily{module = 285,id = 2,limit = 9999,clock = 4,write_db = 1,about = "高级宝箱采集次数"};

get_id(285,3) ->
	#base_daily{module = 285,id = 3,limit = 1,clock = 4,write_db = 1,about = "第一次进入午间排队（成就用）"};

get_id(300,1) ->
	#base_daily{module = 300,id = 1,limit = 20,clock = 4,write_db = 1,about = "日常任务"};

get_id(300,2) ->
	#base_daily{module = 300,id = 2,limit = 10,clock = 4,write_db = 1,about = "公会任务-日常"};

get_id(300,3) ->
	#base_daily{module = 300,id = 3,limit = 10,clock = 4,write_db = 1,about = "悬赏任务"};

get_id(331,1) ->
	#base_daily{module = 331,id = 1,limit = 1,clock = 24,write_db = 1,about = "云购每日寻宝限制"};

get_id(331,23) ->
	#base_daily{module = 331,id = 23,limit = 1,clock = 24,write_db = 1,about = "嗨点每日登录"};

get_id(331,58) ->
	#base_daily{module = 331,id = 58,limit = 9999,clock = 24,write_db = 1,about = "赛博夺宝每日抽奖次数"};

get_id(331,61) ->
	#base_daily{module = 331,id = 61,limit = 9999,clock = 24,write_db = 1,about = "每日补给"};

get_id(331,84) ->
	#base_daily{module = 331,id = 84,limit = 999999999,clock = 24,write_db = 1,about = "充值转盘每日充值数量"};

get_id(340,1) ->
	#base_daily{module = 340,id = 1,limit = 15,clock = 24,write_db = 1,about = "宝箱领取次数"};

get_id(340,2) ->
	#base_daily{module = 340,id = 2,limit = 0,clock = 24,write_db = 1,about = "邀请上传的次数"};

get_id(340,3) ->
	#base_daily{module = 340,id = 3,limit = 0,clock = 24,write_db = 1,about = "邀请数据请求次数"};

get_id(400,1) ->
	#base_daily{module = 400,id = 1,limit = 1,clock = 4,write_db = 1,about = "公会工资领取次数"};

get_id(400,2) ->
	#base_daily{module = 400,id = 2,limit = 0,clock = 24,write_db = 1,about = "捐献次数"};

get_id(402,1) ->
	#base_daily{module = 402,id = 1,limit = 1,clock = 24,write_db = 1,about = "主宰公会俸禄"};

get_id(402,2) ->
	#base_daily{module = 402,id = 2,limit = 1,clock = 4,write_db = 1,about = "当天是否参加公会篝火"};

get_id(402,3) ->
	#base_daily{module = 402,id = 3,limit = 9999,clock = 4,write_db = 1,about = "购买菜肴状态"};

get_id(402,4) ->
	#base_daily{module = 402,id = 4,limit = 999999,clock = 4,write_db = 1,about = "公会晚宴经验加成"};

get_id(403,1) ->
	#base_daily{module = 403,id = 1,limit = 9999,clock = 4,write_db = 1,about = "每日领取公会宝箱数"};

get_id(404,1) ->
	#base_daily{module = 404,id = 1,limit = 0,clock = 4,write_db = 1,about = "公会协助次数"};

get_id(415,1) ->
	#base_daily{module = 415,id = 1,limit = 9999,clock = 4,write_db = 1,about = "金币祈愿"};

get_id(415,2) ->
	#base_daily{module = 415,id = 2,limit = 9999,clock = 4,write_db = 1,about = "经验祈愿"};

get_id(416,1) ->
	#base_daily{module = 416,id = 1,limit = 90000,clock = 24,write_db = 1,about = "符文寻宝第一轮计数器1"};

get_id(416,2) ->
	#base_daily{module = 416,id = 2,limit = 5000,clock = 24,write_db = 1,about = "符文寻宝第2轮计数器"};

get_id(416,3) ->
	#base_daily{module = 416,id = 3,limit = 5000,clock = 24,write_db = 1,about = "符文寻宝第3一轮计数器"};

get_id(416,4) ->
	#base_daily{module = 416,id = 4,limit = 5000,clock = 24,write_db = 1,about = "符文寻宝第4轮计数器"};

get_id(417,2) ->
	#base_daily{module = 417,id = 2,limit = 0,clock = 24,write_db = 1,about = "每日签到签到次数"};

get_id(417,3) ->
	#base_daily{module = 417,id = 3,limit = 0,clock = 24,write_db = 1,about = "夜间福利领取状态"};

get_id(417,4) ->
	#base_daily{module = 417,id = 4,limit = 0,clock = 24,write_db = 1,about = "签到，活跃度增加补签次数每日增加的次数"};

get_id(417,5) ->
	#base_daily{module = 417,id = 5,limit = 1,clock = 24,write_db = 1,about = "心悦礼包领取"};

get_id(417,6) ->
	#base_daily{module = 417,id = 6,limit = 999999,clock = 24,write_db = 1,about = "每日签到天数"};

get_id(426,1) ->
	#base_daily{module = 426,id = 1,limit = 1,clock = 24,write_db = 1,about = "每天改名次数"};

get_id(427,1) ->
	#base_daily{module = 427,id = 1,limit = 9999,clock = 24,write_db = 1,about = "重置次数"};

get_id(427,2) ->
	#base_daily{module = 427,id = 2,limit = 9999,clock = 24,write_db = 1,about = "投掷次数"};

get_id(427,3) ->
	#base_daily{module = 427,id = 3,limit = 9999,clock = 24,write_db = 1,about = "商城刷新次数"};

get_id(427,4) ->
	#base_daily{module = 427,id = 4,limit = 9999,clock = 24,write_db = 1,about = "免费重置次数"};

get_id(427,5) ->
	#base_daily{module = 427,id = 5,limit = 9999,clock = 24,write_db = 1,about = "额外免费投掷次数"};

get_id(437,1) ->
	#base_daily{module = 437,id = 1,limit = 1,clock = 4,write_db = 1,about = "跨服公会战每日奖励"};

get_id(450,1) ->
	#base_daily{module = 450,id = 1,limit = 0,clock = 24,write_db = 1,about = "每日登录增加vip经验次数"};

get_id(452,1) ->
	#base_daily{module = 452,id = 1,limit = 0,clock = 24,write_db = 1,about = "每日获取周卡资源礼包"};

get_id(460,1) ->
	#base_daily{module = 460,id = 1,limit = 3,clock = 4,write_db = 1,about = "世界BOSS疲劳值"};

get_id(460,3) ->
	#base_daily{module = 460,id = 3,limit = 5,clock = 4,write_db = 1,about = "蛮荒禁地进入次数"};

get_id(460,4) ->
	#base_daily{module = 460,id = 4,limit = 5,clock = 4,write_db = 1,about = "蛮荒禁地进入次数"};

get_id(460,5) ->
	#base_daily{module = 460,id = 5,limit = 1,clock = 4,write_db = 1,about = "遗忘神庙进入次数"};

get_id(460,9) ->
	#base_daily{module = 460,id = 9,limit = 5,clock = 4,write_db = 1,about = "秘境boss获得归属次数"};

get_id(460,12) ->
	#base_daily{module = 460,id = 12,limit = 999,clock = 4,write_db = 1,about = "新野外boss归属次数"};

get_id(460,16) ->
	#base_daily{module = 460,id = 16,limit = 5,clock = 4,write_db = 1,about = "秘境领域BOSS"};

get_id(460,20) ->
	#base_daily{module = 460,id = 20,limit = 5,clock = 4,write_db = 1,about = "跨服秘境领域boss日常进入次数"};

get_id(460,5000) ->
	#base_daily{module = 460,id = 5000,limit = 2,clock = 4,write_db = 1,about = "遗忘神庙首领疲劳"};

get_id(460,9000) ->
	#base_daily{module = 460,id = 9000,limit = 2,clock = 4,write_db = 1,about = "秘境boss宝箱采集次数"};

get_id(470,0) ->
	#base_daily{module = 470,id = 0,limit = 0,clock = 24,write_db = 2,about = "无限次内容的计数器"};

get_id(471,1) ->
	#base_daily{module = 471,id = 1,limit = 0,clock = 4,write_db = 1,about = "幻饰boss进入次数"};

get_id(471,2) ->
	#base_daily{module = 471,id = 2,limit = 0,clock = 4,write_db = 1,about = "幻饰boss协助进入次数"};

get_id(471,3) ->
	#base_daily{module = 471,id = 3,limit = 0,clock = 4,write_db = 1,about = "幻饰boss购买次数"};

get_id(471,4) ->
	#base_daily{module = 471,id = 4,limit = 0,clock = 4,write_db = 1,about = "幻饰boss增加进入次数"};

get_id(490,1) ->
	#base_daily{module = 490,id = 1,limit = 1,clock = 24,write_db = 1,about = "惊喜礼包免费次数"};

get_id(500,1) ->
	#base_daily{module = 500,id = 1,limit = 3,clock = 4,write_db = 1,about = "天使护送每日可免费刷新次数"};

get_id(500,2) ->
	#base_daily{module = 500,id = 2,limit = 3,clock = 4,write_db = 1,about = "天使护送每日可护送次数"};

get_id(500,3) ->
	#base_daily{module = 500,id = 3,limit = 3,clock = 4,write_db = 1,about = "天使护送每日可拦截次数"};

get_id(500,4) ->
	#base_daily{module = 500,id = 4,limit = 0,clock = 4,write_db = 1,about = "天使护送每日拦截获得经验"};

get_id(500,5) ->
	#base_daily{module = 500,id = 5,limit = 0,clock = 4,write_db = 1,about = "天使护送每日拦截获得铜币"};

get_id(505,1) ->
	#base_daily{module = 505,id = 1,limit = 1,clock = 4,write_db = 1,about = "公会战福利奖励"};

get_id(506,1) ->
	#base_daily{module = 506,id = 1,limit = 1,clock = 4,write_db = 1,about = "领地战每日福利"};

get_id(607,1) ->
	#base_daily{module = 607,id = 1,limit = 3,clock = 4,write_db = 1,about = "圣者殿每日挑战次数"};

get_id(610,1) ->
	#base_daily{module = 610,id = 1,limit = 0,clock = 4,write_db = 1,about = "进入次数"};

get_id(610,2) ->
	#base_daily{module = 610,id = 2,limit = 0,clock = 4,write_db = 1,about = "助战次数"};

get_id(610,3) ->
	#base_daily{module = 610,id = 3,limit = 0,clock = 4,write_db = 1,about = "副本完成次数（和副本进入次数保持一致）,进入次数可能被玩家重置，完成次数不会"};

get_id(610,4) ->
	#base_daily{module = 610,id = 4,limit = 0,clock = 4,write_db = 1,about = "副本购买次数"};

get_id(610,5) ->
	#base_daily{module = 610,id = 5,limit = 0,clock = 4,write_db = 1,about = "重置次数"};

get_id(610,6) ->
	#base_daily{module = 610,id = 6,limit = 0,clock = 4,write_db = 1,about = "助战奖励次数"};

get_id(610,10) ->
	#base_daily{module = 610,id = 10,limit = 3,clock = 4,write_db = 1,about = "个人BOSS进入次数"};

get_id(610,11) ->
	#base_daily{module = 610,id = 11,limit = 1,clock = 4,write_db = 1,about = "使魔副本扫荡次数"};

get_id(610,12) ->
	#base_daily{module = 610,id = 12,limit = 999999,clock = 4,write_db = 1,about = "伙伴副本扫荡次数"};

get_id(650,1) ->
	#base_daily{module = 650,id = 1,limit = 1,clock = 4,write_db = 1,about = "声望商店商品ID70001生命女神碎片"};

get_id(650,2) ->
	#base_daily{module = 650,id = 2,limit = 1,clock = 4,write_db = 1,about = "声望商店商品ID70002神圣遗迹碎片"};

get_id(650,3) ->
	#base_daily{module = 650,id = 3,limit = 1,clock = 4,write_db = 1,about = "声望商店商品ID70003烈焰遗迹碎片"};

get_id(650,4) ->
	#base_daily{module = 650,id = 4,limit = 3,clock = 4,write_db = 1,about = "声望商店商品ID70004圣灵低级宝箱"};

get_id(650,5) ->
	#base_daily{module = 650,id = 5,limit = 1,clock = 4,write_db = 1,about = "声望商店商品ID70005冰霜遗迹碎片"};

get_id(650,6) ->
	#base_daily{module = 650,id = 6,limit = 5,clock = 4,write_db = 1,about = "声望商店商品ID70006中级神圣宝典"};

get_id(650,7) ->
	#base_daily{module = 650,id = 7,limit = 10,clock = 4,write_db = 1,about = "声望商店商品ID70007低级神圣宝典"};

get_id(650,8) ->
	#base_daily{module = 650,id = 8,limit = 999,clock = 4,write_db = 1,about = "3v3每日奖励领取状态"};

get_id(650,9) ->
	#base_daily{module = 650,id = 9,limit = 9999,clock = 4,write_db = 1,about = "个人匹配次数"};

get_id(651,1) ->
	#base_daily{module = 651,id = 1,limit = 99999,clock = 4,write_db = 1,about = "进入龙语boss次数"};

get_id(651,2) ->
	#base_daily{module = 651,id = 2,limit = 999999,clock = 4,write_db = 1,about = "vip购买龙语boss进入次数"};

get_id(653,1) ->
	#base_daily{module = 653,id = 1,limit = 5,clock = 24,write_db = 1,about = "决斗场购买次数"};

get_id(653,2) ->
	#base_daily{module = 653,id = 2,limit = 10,clock = 24,write_db = 1,about = "决斗场已挑战次数"};

get_id(_Module,_Id) ->
	[].

