%%%---------------------------------------
%%% module      : data_scene_chat_bubble
%%% description : 场景聊天气泡配置
%%%
%%%---------------------------------------
-module(data_scene_chat_bubble).
-compile(export_all).
-include("scene_chat_bubble.hrl").



get_scene_chat_bubble(1) ->
	#base_scene_chat_bubble{bubble_id = 1,object_id = 100101,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "舞缘小姐就在附近。",condition = "{task_id,100010}",number = "",bubble_type = 2};

get_scene_chat_bubble(2) ->
	#base_scene_chat_bubble{bubble_id = 2,object_id = 100134,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "达摩倒是很适合让新人们练手呢！",condition = "{task_id,100020}",number = "",bubble_type = 2};

get_scene_chat_bubble(3) ->
	#base_scene_chat_bubble{bubble_id = 3,object_id = 100106,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "助眠草在这附近就有很多。",condition = "{task_id,100120}",number = "",bubble_type = 2};

get_scene_chat_bubble(4) ->
	#base_scene_chat_bubble{bubble_id = 4,object_id = 100107,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "助眠草，我需要大量的助眠草！",condition = "{task_id,100130}",number = "",bubble_type = 2};

get_scene_chat_bubble(5) ->
	#base_scene_chat_bubble{bubble_id = 5,object_id = 100107,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "真想早点解决失眠的问题！",condition = "{task_id,100140}",number = "",bubble_type = 2};

get_scene_chat_bubble(6) ->
	#base_scene_chat_bubble{bubble_id = 6,object_id = 100108,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "请帮帮我！",condition = "{task_id,100150}",number = "",bubble_type = 2};

get_scene_chat_bubble(7) ->
	#base_scene_chat_bubble{bubble_id = 7,object_id = 12000001,object_type = 4,min_lv = 0,max_lv = 0,bubble_content = "我不会原谅你们……",condition = "{obj_id,12000001}",number = "",bubble_type = 2};

get_scene_chat_bubble(8) ->
	#base_scene_chat_bubble{bubble_id = 8,object_id = 100109,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "御魂石就在那儿，拜托了。",condition = "{task_id,100210}",number = "",bubble_type = 2};

get_scene_chat_bubble(9) ->
	#base_scene_chat_bubble{bubble_id = 9,object_id = 10001070,object_type = 4,min_lv = 0,max_lv = 0,bubble_content = "你是谁？",condition = "{task_id,100240}",number = "",bubble_type = 2};

get_scene_chat_bubble(10) ->
	#base_scene_chat_bubble{bubble_id = 10,object_id = 100112,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "话说，是这条路吗？",condition = "{task_id,100270}",number = "",bubble_type = 2};

get_scene_chat_bubble(11) ->
	#base_scene_chat_bubble{bubble_id = 11,object_id = 100113,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "发挥咱们的能力，扰乱这些家伙们的方向感！",condition = "{task_id,100280}",number = "",bubble_type = 2};

get_scene_chat_bubble(12) ->
	#base_scene_chat_bubble{bubble_id = 12,object_id = 100117,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "幽谷响这种小妖，你一定没问题吧？",condition = "{task_id,100350}",number = "",bubble_type = 2};

get_scene_chat_bubble(13) ->
	#base_scene_chat_bubble{bubble_id = 13,object_id = 100119,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "有邪恶的妖秽在附近……",condition = "{task_id,100380}",number = "",bubble_type = 2};

get_scene_chat_bubble(14) ->
	#base_scene_chat_bubble{bubble_id = 14,object_id = 100123,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "抱歉……",condition = "{task_id,100460}",number = "",bubble_type = 2};

get_scene_chat_bubble(15) ->
	#base_scene_chat_bubble{bubble_id = 15,object_id = 10001073,object_type = 4,min_lv = 0,max_lv = 0,bubble_content = "赌局再开，败者留眼。",condition = "{obj_id,10001073}",number = "",bubble_type = 2};

get_scene_chat_bubble(16) ->
	#base_scene_chat_bubble{bubble_id = 16,object_id = 100127,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "那些狼窃偷走了送给新人训练师的裤子。",condition = "{task_id,100550}",number = "",bubble_type = 2};

get_scene_chat_bubble(17) ->
	#base_scene_chat_bubble{bubble_id = 17,object_id = 100130,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "呵，冤孽……",condition = "{task_id,100460}",number = "",bubble_type = 2};

get_scene_chat_bubble(18) ->
	#base_scene_chat_bubble{bubble_id = 18,object_id = 100131,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "先将羽翼升到2阶，很简单的！",condition = "{task_id,100660}",number = "",bubble_type = 2};

get_scene_chat_bubble(19) ->
	#base_scene_chat_bubble{bubble_id = 19,object_id = 100201,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "真是个奇怪的客人呢~",condition = "{task_id,100740}",number = "",bubble_type = 2};

get_scene_chat_bubble(20) ->
	#base_scene_chat_bubble{bubble_id = 20,object_id = 100202,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "拜托你了！",condition = "{task_id,100760}",number = "",bubble_type = 2};

get_scene_chat_bubble(21) ->
	#base_scene_chat_bubble{bubble_id = 21,object_id = 100207,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "才……才不会害怕呢！",condition = "{task_id,100840}",number = "",bubble_type = 2};

get_scene_chat_bubble(22) ->
	#base_scene_chat_bubble{bubble_id = 22,object_id = 100209,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "嗯……身材还不错！",condition = "{task_id,100880}",number = "",bubble_type = 2};

get_scene_chat_bubble(23) ->
	#base_scene_chat_bubble{bubble_id = 23,object_id = 100211,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "你不相信我吗？",condition = "{task_id,100910}",number = "",bubble_type = 2};

get_scene_chat_bubble(24) ->
	#base_scene_chat_bubble{bubble_id = 24,object_id = 100213,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "啊……好麻烦！",condition = "{task_id,100960}",number = "",bubble_type = 2};

get_scene_chat_bubble(25) ->
	#base_scene_chat_bubble{bubble_id = 25,object_id = 100214,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "偷酒的是一群狸猫哦！",condition = "{task_id,101000}",number = "",bubble_type = 2};

get_scene_chat_bubble(26) ->
	#base_scene_chat_bubble{bubble_id = 26,object_id = 12000004,object_type = 4,min_lv = 0,max_lv = 0,bubble_content = "为什么要来破坏我的家？我讨厌你们！",condition = "{obj_id,12000004}",number = "",bubble_type = 2};

get_scene_chat_bubble(27) ->
	#base_scene_chat_bubble{bubble_id = 27,object_id = 100216,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "可以帮帮忙吗？",condition = "{task_id,101040}",number = "",bubble_type = 2};

get_scene_chat_bubble(28) ->
	#base_scene_chat_bubble{bubble_id = 28,object_id = 12000005,object_type = 4,min_lv = 0,max_lv = 0,bubble_content = "想见守护神大人，必须先战胜我，喵呜~",condition = "{obj_id,12000005}",number = "",bubble_type = 2};

get_scene_chat_bubble(29) ->
	#base_scene_chat_bubble{bubble_id = 29,object_id = 100218,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "体验经验守护的时间有限，想获得大量经验的话可得抓紧咯！",condition = "{task_id,101130}",number = "",bubble_type = 2};

get_scene_chat_bubble(30) ->
	#base_scene_chat_bubble{bubble_id = 30,object_id = 100220,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "神明大人会喜欢闪亮的宝石吗？",condition = "{task_id,101170}",number = "",bubble_type = 2};

get_scene_chat_bubble(31) ->
	#base_scene_chat_bubble{bubble_id = 31,object_id = 100221,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "去吧，去往那个世界。",condition = "{task_id,101190}",number = "",bubble_type = 2};

get_scene_chat_bubble(32) ->
	#base_scene_chat_bubble{bubble_id = 32,object_id = 100221,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "装备有好好穿上吗？",condition = "{task_id,101200}",number = "",bubble_type = 2};

get_scene_chat_bubble(33) ->
	#base_scene_chat_bubble{bubble_id = 33,object_id = 100221,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "用劳动去获取丰富的资源，很公平吧？",condition = "{task_id,101201}",number = "",bubble_type = 2};

get_scene_chat_bubble(34) ->
	#base_scene_chat_bubble{bubble_id = 34,object_id = 100301,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "嘻嘻，小心一点哦！",condition = "{task_id,101240}",number = "",bubble_type = 2};

get_scene_chat_bubble(35) ->
	#base_scene_chat_bubble{bubble_id = 35,object_id = 100302,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "请等一下！",condition = "{task_id,101250}",number = "",bubble_type = 2};

get_scene_chat_bubble(36) ->
	#base_scene_chat_bubble{bubble_id = 36,object_id = 100303,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "蔚蓝大人❤",condition = "{task_id,101290}",number = "",bubble_type = 2};

get_scene_chat_bubble(37) ->
	#base_scene_chat_bubble{bubble_id = 37,object_id = 100304,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "在河中心等待一会吧！",condition = "{task_id,101300}",number = "",bubble_type = 2};

get_scene_chat_bubble(38) ->
	#base_scene_chat_bubble{bubble_id = 38,object_id = 100304,object_type = 3,min_lv = 0,max_lv = 0,bubble_content = "小心一点，不要让自己受伤。",condition = "{task_id,101320}",number = "",bubble_type = 2};

get_scene_chat_bubble(1001001) ->
	#base_scene_chat_bubble{bubble_id = 1001001,object_id = 1001,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001002) ->
	#base_scene_chat_bubble{bubble_id = 1001002,object_id = 1001,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001003) ->
	#base_scene_chat_bubble{bubble_id = 1001003,object_id = 1001,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001004) ->
	#base_scene_chat_bubble{bubble_id = 1001004,object_id = 1001,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001005) ->
	#base_scene_chat_bubble{bubble_id = 1001005,object_id = 1001,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001006) ->
	#base_scene_chat_bubble{bubble_id = 1001006,object_id = 1001,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001007) ->
	#base_scene_chat_bubble{bubble_id = 1001007,object_id = 1001,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001008) ->
	#base_scene_chat_bubble{bubble_id = 1001008,object_id = 1001,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001009) ->
	#base_scene_chat_bubble{bubble_id = 1001009,object_id = 1001,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001010) ->
	#base_scene_chat_bubble{bubble_id = 1001010,object_id = 1001,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001011) ->
	#base_scene_chat_bubble{bubble_id = 1001011,object_id = 1001,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001012) ->
	#base_scene_chat_bubble{bubble_id = 1001012,object_id = 1001,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001013) ->
	#base_scene_chat_bubble{bubble_id = 1001013,object_id = 1001,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001014) ->
	#base_scene_chat_bubble{bubble_id = 1001014,object_id = 1001,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001015) ->
	#base_scene_chat_bubble{bubble_id = 1001015,object_id = 1001,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001016) ->
	#base_scene_chat_bubble{bubble_id = 1001016,object_id = 1001,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001017) ->
	#base_scene_chat_bubble{bubble_id = 1001017,object_id = 1001,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001018) ->
	#base_scene_chat_bubble{bubble_id = 1001018,object_id = 1001,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001019) ->
	#base_scene_chat_bubble{bubble_id = 1001019,object_id = 1001,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001020) ->
	#base_scene_chat_bubble{bubble_id = 1001020,object_id = 1001,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1001021) ->
	#base_scene_chat_bubble{bubble_id = 1001021,object_id = 1001,object_type = 1,min_lv = 0,max_lv = 0,bubble_content = "你好，我是风语魂，\n叫我风语也可以。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002001) ->
	#base_scene_chat_bubble{bubble_id = 1002001,object_id = 1002,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002002) ->
	#base_scene_chat_bubble{bubble_id = 1002002,object_id = 1002,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002003) ->
	#base_scene_chat_bubble{bubble_id = 1002003,object_id = 1002,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002004) ->
	#base_scene_chat_bubble{bubble_id = 1002004,object_id = 1002,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002005) ->
	#base_scene_chat_bubble{bubble_id = 1002005,object_id = 1002,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002006) ->
	#base_scene_chat_bubble{bubble_id = 1002006,object_id = 1002,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002007) ->
	#base_scene_chat_bubble{bubble_id = 1002007,object_id = 1002,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002008) ->
	#base_scene_chat_bubble{bubble_id = 1002008,object_id = 1002,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002009) ->
	#base_scene_chat_bubble{bubble_id = 1002009,object_id = 1002,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002010) ->
	#base_scene_chat_bubble{bubble_id = 1002010,object_id = 1002,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002011) ->
	#base_scene_chat_bubble{bubble_id = 1002011,object_id = 1002,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002012) ->
	#base_scene_chat_bubble{bubble_id = 1002012,object_id = 1002,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002013) ->
	#base_scene_chat_bubble{bubble_id = 1002013,object_id = 1002,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002014) ->
	#base_scene_chat_bubble{bubble_id = 1002014,object_id = 1002,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002015) ->
	#base_scene_chat_bubble{bubble_id = 1002015,object_id = 1002,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002016) ->
	#base_scene_chat_bubble{bubble_id = 1002016,object_id = 1002,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002017) ->
	#base_scene_chat_bubble{bubble_id = 1002017,object_id = 1002,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002018) ->
	#base_scene_chat_bubble{bubble_id = 1002018,object_id = 1002,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002019) ->
	#base_scene_chat_bubble{bubble_id = 1002019,object_id = 1002,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002020) ->
	#base_scene_chat_bubble{bubble_id = 1002020,object_id = 1002,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1002021) ->
	#base_scene_chat_bubble{bubble_id = 1002021,object_id = 1002,object_type = 1,min_lv = 0,max_lv = 0,bubble_content = "三条尾巴的忍者，参上！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003001) ->
	#base_scene_chat_bubble{bubble_id = 1003001,object_id = 1003,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003002) ->
	#base_scene_chat_bubble{bubble_id = 1003002,object_id = 1003,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003003) ->
	#base_scene_chat_bubble{bubble_id = 1003003,object_id = 1003,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003004) ->
	#base_scene_chat_bubble{bubble_id = 1003004,object_id = 1003,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003005) ->
	#base_scene_chat_bubble{bubble_id = 1003005,object_id = 1003,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003006) ->
	#base_scene_chat_bubble{bubble_id = 1003006,object_id = 1003,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003007) ->
	#base_scene_chat_bubble{bubble_id = 1003007,object_id = 1003,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003008) ->
	#base_scene_chat_bubble{bubble_id = 1003008,object_id = 1003,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003009) ->
	#base_scene_chat_bubble{bubble_id = 1003009,object_id = 1003,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003010) ->
	#base_scene_chat_bubble{bubble_id = 1003010,object_id = 1003,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003011) ->
	#base_scene_chat_bubble{bubble_id = 1003011,object_id = 1003,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003012) ->
	#base_scene_chat_bubble{bubble_id = 1003012,object_id = 1003,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003013) ->
	#base_scene_chat_bubble{bubble_id = 1003013,object_id = 1003,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003014) ->
	#base_scene_chat_bubble{bubble_id = 1003014,object_id = 1003,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003015) ->
	#base_scene_chat_bubble{bubble_id = 1003015,object_id = 1003,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003016) ->
	#base_scene_chat_bubble{bubble_id = 1003016,object_id = 1003,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003017) ->
	#base_scene_chat_bubble{bubble_id = 1003017,object_id = 1003,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003018) ->
	#base_scene_chat_bubble{bubble_id = 1003018,object_id = 1003,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003019) ->
	#base_scene_chat_bubble{bubble_id = 1003019,object_id = 1003,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003020) ->
	#base_scene_chat_bubble{bubble_id = 1003020,object_id = 1003,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1003021) ->
	#base_scene_chat_bubble{bubble_id = 1003021,object_id = 1003,object_type = 1,min_lv = 0,max_lv = 0,bubble_content = "别小瞧我，我的知识可是很渊博的！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004001) ->
	#base_scene_chat_bubble{bubble_id = 1004001,object_id = 1004,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004002) ->
	#base_scene_chat_bubble{bubble_id = 1004002,object_id = 1004,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004003) ->
	#base_scene_chat_bubble{bubble_id = 1004003,object_id = 1004,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004004) ->
	#base_scene_chat_bubble{bubble_id = 1004004,object_id = 1004,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004005) ->
	#base_scene_chat_bubble{bubble_id = 1004005,object_id = 1004,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004006) ->
	#base_scene_chat_bubble{bubble_id = 1004006,object_id = 1004,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004007) ->
	#base_scene_chat_bubble{bubble_id = 1004007,object_id = 1004,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004008) ->
	#base_scene_chat_bubble{bubble_id = 1004008,object_id = 1004,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004009) ->
	#base_scene_chat_bubble{bubble_id = 1004009,object_id = 1004,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004010) ->
	#base_scene_chat_bubble{bubble_id = 1004010,object_id = 1004,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004011) ->
	#base_scene_chat_bubble{bubble_id = 1004011,object_id = 1004,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004012) ->
	#base_scene_chat_bubble{bubble_id = 1004012,object_id = 1004,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004013) ->
	#base_scene_chat_bubble{bubble_id = 1004013,object_id = 1004,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004014) ->
	#base_scene_chat_bubble{bubble_id = 1004014,object_id = 1004,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004015) ->
	#base_scene_chat_bubble{bubble_id = 1004015,object_id = 1004,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004016) ->
	#base_scene_chat_bubble{bubble_id = 1004016,object_id = 1004,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004017) ->
	#base_scene_chat_bubble{bubble_id = 1004017,object_id = 1004,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004018) ->
	#base_scene_chat_bubble{bubble_id = 1004018,object_id = 1004,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004019) ->
	#base_scene_chat_bubble{bubble_id = 1004019,object_id = 1004,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004020) ->
	#base_scene_chat_bubble{bubble_id = 1004020,object_id = 1004,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1004021) ->
	#base_scene_chat_bubble{bubble_id = 1004021,object_id = 1004,object_type = 1,min_lv = 0,max_lv = 0,bubble_content = "你看见天御子的玩偶了吗？",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005001) ->
	#base_scene_chat_bubble{bubble_id = 1005001,object_id = 1005,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005002) ->
	#base_scene_chat_bubble{bubble_id = 1005002,object_id = 1005,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005003) ->
	#base_scene_chat_bubble{bubble_id = 1005003,object_id = 1005,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005004) ->
	#base_scene_chat_bubble{bubble_id = 1005004,object_id = 1005,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005005) ->
	#base_scene_chat_bubble{bubble_id = 1005005,object_id = 1005,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005006) ->
	#base_scene_chat_bubble{bubble_id = 1005006,object_id = 1005,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005007) ->
	#base_scene_chat_bubble{bubble_id = 1005007,object_id = 1005,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005008) ->
	#base_scene_chat_bubble{bubble_id = 1005008,object_id = 1005,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005009) ->
	#base_scene_chat_bubble{bubble_id = 1005009,object_id = 1005,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005010) ->
	#base_scene_chat_bubble{bubble_id = 1005010,object_id = 1005,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005011) ->
	#base_scene_chat_bubble{bubble_id = 1005011,object_id = 1005,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005012) ->
	#base_scene_chat_bubble{bubble_id = 1005012,object_id = 1005,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005013) ->
	#base_scene_chat_bubble{bubble_id = 1005013,object_id = 1005,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005014) ->
	#base_scene_chat_bubble{bubble_id = 1005014,object_id = 1005,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005015) ->
	#base_scene_chat_bubble{bubble_id = 1005015,object_id = 1005,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005016) ->
	#base_scene_chat_bubble{bubble_id = 1005016,object_id = 1005,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005017) ->
	#base_scene_chat_bubble{bubble_id = 1005017,object_id = 1005,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005018) ->
	#base_scene_chat_bubble{bubble_id = 1005018,object_id = 1005,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005019) ->
	#base_scene_chat_bubble{bubble_id = 1005019,object_id = 1005,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005020) ->
	#base_scene_chat_bubble{bubble_id = 1005020,object_id = 1005,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1005021) ->
	#base_scene_chat_bubble{bubble_id = 1005021,object_id = 1005,object_type = 1,min_lv = 0,max_lv = 0,bubble_content = "唔，法术好难哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006001) ->
	#base_scene_chat_bubble{bubble_id = 1006001,object_id = 1006,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006002) ->
	#base_scene_chat_bubble{bubble_id = 1006002,object_id = 1006,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006003) ->
	#base_scene_chat_bubble{bubble_id = 1006003,object_id = 1006,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006004) ->
	#base_scene_chat_bubble{bubble_id = 1006004,object_id = 1006,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006005) ->
	#base_scene_chat_bubble{bubble_id = 1006005,object_id = 1006,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006006) ->
	#base_scene_chat_bubble{bubble_id = 1006006,object_id = 1006,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006007) ->
	#base_scene_chat_bubble{bubble_id = 1006007,object_id = 1006,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006008) ->
	#base_scene_chat_bubble{bubble_id = 1006008,object_id = 1006,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006009) ->
	#base_scene_chat_bubble{bubble_id = 1006009,object_id = 1006,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006010) ->
	#base_scene_chat_bubble{bubble_id = 1006010,object_id = 1006,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006011) ->
	#base_scene_chat_bubble{bubble_id = 1006011,object_id = 1006,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006012) ->
	#base_scene_chat_bubble{bubble_id = 1006012,object_id = 1006,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006013) ->
	#base_scene_chat_bubble{bubble_id = 1006013,object_id = 1006,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006014) ->
	#base_scene_chat_bubble{bubble_id = 1006014,object_id = 1006,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006015) ->
	#base_scene_chat_bubble{bubble_id = 1006015,object_id = 1006,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006016) ->
	#base_scene_chat_bubble{bubble_id = 1006016,object_id = 1006,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006017) ->
	#base_scene_chat_bubble{bubble_id = 1006017,object_id = 1006,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006018) ->
	#base_scene_chat_bubble{bubble_id = 1006018,object_id = 1006,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006019) ->
	#base_scene_chat_bubble{bubble_id = 1006019,object_id = 1006,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006020) ->
	#base_scene_chat_bubble{bubble_id = 1006020,object_id = 1006,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1006021) ->
	#base_scene_chat_bubble{bubble_id = 1006021,object_id = 1006,object_type = 1,min_lv = 0,max_lv = 0,bubble_content = "哼，幼稚！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007001) ->
	#base_scene_chat_bubble{bubble_id = 1007001,object_id = 1007,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007002) ->
	#base_scene_chat_bubble{bubble_id = 1007002,object_id = 1007,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007003) ->
	#base_scene_chat_bubble{bubble_id = 1007003,object_id = 1007,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007004) ->
	#base_scene_chat_bubble{bubble_id = 1007004,object_id = 1007,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007005) ->
	#base_scene_chat_bubble{bubble_id = 1007005,object_id = 1007,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007006) ->
	#base_scene_chat_bubble{bubble_id = 1007006,object_id = 1007,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007007) ->
	#base_scene_chat_bubble{bubble_id = 1007007,object_id = 1007,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007008) ->
	#base_scene_chat_bubble{bubble_id = 1007008,object_id = 1007,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007009) ->
	#base_scene_chat_bubble{bubble_id = 1007009,object_id = 1007,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007010) ->
	#base_scene_chat_bubble{bubble_id = 1007010,object_id = 1007,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007011) ->
	#base_scene_chat_bubble{bubble_id = 1007011,object_id = 1007,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007012) ->
	#base_scene_chat_bubble{bubble_id = 1007012,object_id = 1007,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007013) ->
	#base_scene_chat_bubble{bubble_id = 1007013,object_id = 1007,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007014) ->
	#base_scene_chat_bubble{bubble_id = 1007014,object_id = 1007,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007015) ->
	#base_scene_chat_bubble{bubble_id = 1007015,object_id = 1007,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007016) ->
	#base_scene_chat_bubble{bubble_id = 1007016,object_id = 1007,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007017) ->
	#base_scene_chat_bubble{bubble_id = 1007017,object_id = 1007,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007018) ->
	#base_scene_chat_bubble{bubble_id = 1007018,object_id = 1007,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007019) ->
	#base_scene_chat_bubble{bubble_id = 1007019,object_id = 1007,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007020) ->
	#base_scene_chat_bubble{bubble_id = 1007020,object_id = 1007,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1007021) ->
	#base_scene_chat_bubble{bubble_id = 1007021,object_id = 1007,object_type = 1,min_lv = 0,max_lv = 0,bubble_content = "冬天要储藏好食物才行！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008001) ->
	#base_scene_chat_bubble{bubble_id = 1008001,object_id = 1008,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008002) ->
	#base_scene_chat_bubble{bubble_id = 1008002,object_id = 1008,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008003) ->
	#base_scene_chat_bubble{bubble_id = 1008003,object_id = 1008,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008004) ->
	#base_scene_chat_bubble{bubble_id = 1008004,object_id = 1008,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008005) ->
	#base_scene_chat_bubble{bubble_id = 1008005,object_id = 1008,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008006) ->
	#base_scene_chat_bubble{bubble_id = 1008006,object_id = 1008,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008007) ->
	#base_scene_chat_bubble{bubble_id = 1008007,object_id = 1008,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008008) ->
	#base_scene_chat_bubble{bubble_id = 1008008,object_id = 1008,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008009) ->
	#base_scene_chat_bubble{bubble_id = 1008009,object_id = 1008,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008010) ->
	#base_scene_chat_bubble{bubble_id = 1008010,object_id = 1008,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008011) ->
	#base_scene_chat_bubble{bubble_id = 1008011,object_id = 1008,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008012) ->
	#base_scene_chat_bubble{bubble_id = 1008012,object_id = 1008,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008013) ->
	#base_scene_chat_bubble{bubble_id = 1008013,object_id = 1008,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008014) ->
	#base_scene_chat_bubble{bubble_id = 1008014,object_id = 1008,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008015) ->
	#base_scene_chat_bubble{bubble_id = 1008015,object_id = 1008,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008016) ->
	#base_scene_chat_bubble{bubble_id = 1008016,object_id = 1008,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008017) ->
	#base_scene_chat_bubble{bubble_id = 1008017,object_id = 1008,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008018) ->
	#base_scene_chat_bubble{bubble_id = 1008018,object_id = 1008,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008019) ->
	#base_scene_chat_bubble{bubble_id = 1008019,object_id = 1008,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1008020) ->
	#base_scene_chat_bubble{bubble_id = 1008020,object_id = 1008,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009001) ->
	#base_scene_chat_bubble{bubble_id = 1009001,object_id = 1009,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009002) ->
	#base_scene_chat_bubble{bubble_id = 1009002,object_id = 1009,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009003) ->
	#base_scene_chat_bubble{bubble_id = 1009003,object_id = 1009,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009004) ->
	#base_scene_chat_bubble{bubble_id = 1009004,object_id = 1009,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009005) ->
	#base_scene_chat_bubble{bubble_id = 1009005,object_id = 1009,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009006) ->
	#base_scene_chat_bubble{bubble_id = 1009006,object_id = 1009,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009007) ->
	#base_scene_chat_bubble{bubble_id = 1009007,object_id = 1009,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009008) ->
	#base_scene_chat_bubble{bubble_id = 1009008,object_id = 1009,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009009) ->
	#base_scene_chat_bubble{bubble_id = 1009009,object_id = 1009,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009010) ->
	#base_scene_chat_bubble{bubble_id = 1009010,object_id = 1009,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009011) ->
	#base_scene_chat_bubble{bubble_id = 1009011,object_id = 1009,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009012) ->
	#base_scene_chat_bubble{bubble_id = 1009012,object_id = 1009,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009013) ->
	#base_scene_chat_bubble{bubble_id = 1009013,object_id = 1009,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009014) ->
	#base_scene_chat_bubble{bubble_id = 1009014,object_id = 1009,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009015) ->
	#base_scene_chat_bubble{bubble_id = 1009015,object_id = 1009,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009016) ->
	#base_scene_chat_bubble{bubble_id = 1009016,object_id = 1009,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009017) ->
	#base_scene_chat_bubble{bubble_id = 1009017,object_id = 1009,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009018) ->
	#base_scene_chat_bubble{bubble_id = 1009018,object_id = 1009,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009019) ->
	#base_scene_chat_bubble{bubble_id = 1009019,object_id = 1009,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1009020) ->
	#base_scene_chat_bubble{bubble_id = 1009020,object_id = 1009,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010001) ->
	#base_scene_chat_bubble{bubble_id = 1010001,object_id = 1010,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010002) ->
	#base_scene_chat_bubble{bubble_id = 1010002,object_id = 1010,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010003) ->
	#base_scene_chat_bubble{bubble_id = 1010003,object_id = 1010,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010004) ->
	#base_scene_chat_bubble{bubble_id = 1010004,object_id = 1010,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010005) ->
	#base_scene_chat_bubble{bubble_id = 1010005,object_id = 1010,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010006) ->
	#base_scene_chat_bubble{bubble_id = 1010006,object_id = 1010,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010007) ->
	#base_scene_chat_bubble{bubble_id = 1010007,object_id = 1010,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010008) ->
	#base_scene_chat_bubble{bubble_id = 1010008,object_id = 1010,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010009) ->
	#base_scene_chat_bubble{bubble_id = 1010009,object_id = 1010,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010010) ->
	#base_scene_chat_bubble{bubble_id = 1010010,object_id = 1010,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010011) ->
	#base_scene_chat_bubble{bubble_id = 1010011,object_id = 1010,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010012) ->
	#base_scene_chat_bubble{bubble_id = 1010012,object_id = 1010,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010013) ->
	#base_scene_chat_bubble{bubble_id = 1010013,object_id = 1010,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010014) ->
	#base_scene_chat_bubble{bubble_id = 1010014,object_id = 1010,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010015) ->
	#base_scene_chat_bubble{bubble_id = 1010015,object_id = 1010,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010016) ->
	#base_scene_chat_bubble{bubble_id = 1010016,object_id = 1010,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010017) ->
	#base_scene_chat_bubble{bubble_id = 1010017,object_id = 1010,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010018) ->
	#base_scene_chat_bubble{bubble_id = 1010018,object_id = 1010,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010019) ->
	#base_scene_chat_bubble{bubble_id = 1010019,object_id = 1010,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1010020) ->
	#base_scene_chat_bubble{bubble_id = 1010020,object_id = 1010,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011001) ->
	#base_scene_chat_bubble{bubble_id = 1011001,object_id = 1011,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011002) ->
	#base_scene_chat_bubble{bubble_id = 1011002,object_id = 1011,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011003) ->
	#base_scene_chat_bubble{bubble_id = 1011003,object_id = 1011,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011004) ->
	#base_scene_chat_bubble{bubble_id = 1011004,object_id = 1011,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011005) ->
	#base_scene_chat_bubble{bubble_id = 1011005,object_id = 1011,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011006) ->
	#base_scene_chat_bubble{bubble_id = 1011006,object_id = 1011,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011007) ->
	#base_scene_chat_bubble{bubble_id = 1011007,object_id = 1011,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011008) ->
	#base_scene_chat_bubble{bubble_id = 1011008,object_id = 1011,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011009) ->
	#base_scene_chat_bubble{bubble_id = 1011009,object_id = 1011,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011010) ->
	#base_scene_chat_bubble{bubble_id = 1011010,object_id = 1011,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011011) ->
	#base_scene_chat_bubble{bubble_id = 1011011,object_id = 1011,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011012) ->
	#base_scene_chat_bubble{bubble_id = 1011012,object_id = 1011,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011013) ->
	#base_scene_chat_bubble{bubble_id = 1011013,object_id = 1011,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011014) ->
	#base_scene_chat_bubble{bubble_id = 1011014,object_id = 1011,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011015) ->
	#base_scene_chat_bubble{bubble_id = 1011015,object_id = 1011,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011016) ->
	#base_scene_chat_bubble{bubble_id = 1011016,object_id = 1011,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011017) ->
	#base_scene_chat_bubble{bubble_id = 1011017,object_id = 1011,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011018) ->
	#base_scene_chat_bubble{bubble_id = 1011018,object_id = 1011,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011019) ->
	#base_scene_chat_bubble{bubble_id = 1011019,object_id = 1011,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1011020) ->
	#base_scene_chat_bubble{bubble_id = 1011020,object_id = 1011,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012001) ->
	#base_scene_chat_bubble{bubble_id = 1012001,object_id = 1012,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012002) ->
	#base_scene_chat_bubble{bubble_id = 1012002,object_id = 1012,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012003) ->
	#base_scene_chat_bubble{bubble_id = 1012003,object_id = 1012,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012004) ->
	#base_scene_chat_bubble{bubble_id = 1012004,object_id = 1012,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012005) ->
	#base_scene_chat_bubble{bubble_id = 1012005,object_id = 1012,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012006) ->
	#base_scene_chat_bubble{bubble_id = 1012006,object_id = 1012,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012007) ->
	#base_scene_chat_bubble{bubble_id = 1012007,object_id = 1012,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012008) ->
	#base_scene_chat_bubble{bubble_id = 1012008,object_id = 1012,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012009) ->
	#base_scene_chat_bubble{bubble_id = 1012009,object_id = 1012,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012010) ->
	#base_scene_chat_bubble{bubble_id = 1012010,object_id = 1012,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012011) ->
	#base_scene_chat_bubble{bubble_id = 1012011,object_id = 1012,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012012) ->
	#base_scene_chat_bubble{bubble_id = 1012012,object_id = 1012,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012013) ->
	#base_scene_chat_bubble{bubble_id = 1012013,object_id = 1012,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012014) ->
	#base_scene_chat_bubble{bubble_id = 1012014,object_id = 1012,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012015) ->
	#base_scene_chat_bubble{bubble_id = 1012015,object_id = 1012,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012016) ->
	#base_scene_chat_bubble{bubble_id = 1012016,object_id = 1012,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012017) ->
	#base_scene_chat_bubble{bubble_id = 1012017,object_id = 1012,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012018) ->
	#base_scene_chat_bubble{bubble_id = 1012018,object_id = 1012,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012019) ->
	#base_scene_chat_bubble{bubble_id = 1012019,object_id = 1012,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1012020) ->
	#base_scene_chat_bubble{bubble_id = 1012020,object_id = 1012,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013001) ->
	#base_scene_chat_bubble{bubble_id = 1013001,object_id = 1013,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013002) ->
	#base_scene_chat_bubble{bubble_id = 1013002,object_id = 1013,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013003) ->
	#base_scene_chat_bubble{bubble_id = 1013003,object_id = 1013,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013004) ->
	#base_scene_chat_bubble{bubble_id = 1013004,object_id = 1013,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013005) ->
	#base_scene_chat_bubble{bubble_id = 1013005,object_id = 1013,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013006) ->
	#base_scene_chat_bubble{bubble_id = 1013006,object_id = 1013,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013007) ->
	#base_scene_chat_bubble{bubble_id = 1013007,object_id = 1013,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013008) ->
	#base_scene_chat_bubble{bubble_id = 1013008,object_id = 1013,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013009) ->
	#base_scene_chat_bubble{bubble_id = 1013009,object_id = 1013,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013010) ->
	#base_scene_chat_bubble{bubble_id = 1013010,object_id = 1013,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013011) ->
	#base_scene_chat_bubble{bubble_id = 1013011,object_id = 1013,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013012) ->
	#base_scene_chat_bubble{bubble_id = 1013012,object_id = 1013,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013013) ->
	#base_scene_chat_bubble{bubble_id = 1013013,object_id = 1013,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013014) ->
	#base_scene_chat_bubble{bubble_id = 1013014,object_id = 1013,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013015) ->
	#base_scene_chat_bubble{bubble_id = 1013015,object_id = 1013,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013016) ->
	#base_scene_chat_bubble{bubble_id = 1013016,object_id = 1013,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013017) ->
	#base_scene_chat_bubble{bubble_id = 1013017,object_id = 1013,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013018) ->
	#base_scene_chat_bubble{bubble_id = 1013018,object_id = 1013,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013019) ->
	#base_scene_chat_bubble{bubble_id = 1013019,object_id = 1013,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1013020) ->
	#base_scene_chat_bubble{bubble_id = 1013020,object_id = 1013,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014001) ->
	#base_scene_chat_bubble{bubble_id = 1014001,object_id = 1014,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014002) ->
	#base_scene_chat_bubble{bubble_id = 1014002,object_id = 1014,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014003) ->
	#base_scene_chat_bubble{bubble_id = 1014003,object_id = 1014,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014004) ->
	#base_scene_chat_bubble{bubble_id = 1014004,object_id = 1014,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014005) ->
	#base_scene_chat_bubble{bubble_id = 1014005,object_id = 1014,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014006) ->
	#base_scene_chat_bubble{bubble_id = 1014006,object_id = 1014,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014007) ->
	#base_scene_chat_bubble{bubble_id = 1014007,object_id = 1014,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014008) ->
	#base_scene_chat_bubble{bubble_id = 1014008,object_id = 1014,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014009) ->
	#base_scene_chat_bubble{bubble_id = 1014009,object_id = 1014,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014010) ->
	#base_scene_chat_bubble{bubble_id = 1014010,object_id = 1014,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014011) ->
	#base_scene_chat_bubble{bubble_id = 1014011,object_id = 1014,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014012) ->
	#base_scene_chat_bubble{bubble_id = 1014012,object_id = 1014,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014013) ->
	#base_scene_chat_bubble{bubble_id = 1014013,object_id = 1014,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014014) ->
	#base_scene_chat_bubble{bubble_id = 1014014,object_id = 1014,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014015) ->
	#base_scene_chat_bubble{bubble_id = 1014015,object_id = 1014,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014016) ->
	#base_scene_chat_bubble{bubble_id = 1014016,object_id = 1014,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014017) ->
	#base_scene_chat_bubble{bubble_id = 1014017,object_id = 1014,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014018) ->
	#base_scene_chat_bubble{bubble_id = 1014018,object_id = 1014,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014019) ->
	#base_scene_chat_bubble{bubble_id = 1014019,object_id = 1014,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1014020) ->
	#base_scene_chat_bubble{bubble_id = 1014020,object_id = 1014,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015001) ->
	#base_scene_chat_bubble{bubble_id = 1015001,object_id = 1015,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015002) ->
	#base_scene_chat_bubble{bubble_id = 1015002,object_id = 1015,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015003) ->
	#base_scene_chat_bubble{bubble_id = 1015003,object_id = 1015,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015004) ->
	#base_scene_chat_bubble{bubble_id = 1015004,object_id = 1015,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015005) ->
	#base_scene_chat_bubble{bubble_id = 1015005,object_id = 1015,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015006) ->
	#base_scene_chat_bubble{bubble_id = 1015006,object_id = 1015,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015007) ->
	#base_scene_chat_bubble{bubble_id = 1015007,object_id = 1015,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015008) ->
	#base_scene_chat_bubble{bubble_id = 1015008,object_id = 1015,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015009) ->
	#base_scene_chat_bubble{bubble_id = 1015009,object_id = 1015,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015010) ->
	#base_scene_chat_bubble{bubble_id = 1015010,object_id = 1015,object_type = 1,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015011) ->
	#base_scene_chat_bubble{bubble_id = 1015011,object_id = 1015,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015012) ->
	#base_scene_chat_bubble{bubble_id = 1015012,object_id = 1015,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015013) ->
	#base_scene_chat_bubble{bubble_id = 1015013,object_id = 1015,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015014) ->
	#base_scene_chat_bubble{bubble_id = 1015014,object_id = 1015,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015015) ->
	#base_scene_chat_bubble{bubble_id = 1015015,object_id = 1015,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015016) ->
	#base_scene_chat_bubble{bubble_id = 1015016,object_id = 1015,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015017) ->
	#base_scene_chat_bubble{bubble_id = 1015017,object_id = 1015,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015018) ->
	#base_scene_chat_bubble{bubble_id = 1015018,object_id = 1015,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015019) ->
	#base_scene_chat_bubble{bubble_id = 1015019,object_id = 1015,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(1015020) ->
	#base_scene_chat_bubble{bubble_id = 1015020,object_id = 1015,object_type = 1,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001001) ->
	#base_scene_chat_bubble{bubble_id = 2001001,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 199,bubble_content = "0元购中的天邪鬼拥有经验加成的特质。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001002) ->
	#base_scene_chat_bubble{bubble_id = 2001002,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 199,bubble_content = "御魂不仅可以从御魂塔获得，也可进行御魂召唤~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001003) ->
	#base_scene_chat_bubble{bubble_id = 2001003,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 199,bubble_content = "缺少绑玉的话，购买投资是不错的选择。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001004) ->
	#base_scene_chat_bubble{bubble_id = 2001004,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 199,bubble_content = "直升V4好处多多，更可进入无限挑战的大妖之境",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001005) ->
	#base_scene_chat_bubble{bubble_id = 2001005,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 199,bubble_content = "想要买买买？商城绝对不能错过~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001006) ->
	#base_scene_chat_bubble{bubble_id = 2001006,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 199,bubble_content = "想看自己是欧是非？金币、经验祈愿欢迎你~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001007) ->
	#base_scene_chat_bubble{bubble_id = 2001007,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 199,bubble_content = "限时特惠，买到就是赚~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001008) ->
	#base_scene_chat_bubble{bubble_id = 2001008,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 199,bubble_content = "开服限时冲榜，\n争当头号玩家~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001009) ->
	#base_scene_chat_bubble{bubble_id = 2001009,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 199,bubble_content = "稀有的装备可以通过装备夺宝获得",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001010) ->
	#base_scene_chat_bubble{bubble_id = 2001010,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 199,bubble_content = "特权礼包，购买后会全额返还，还能进行每日抽奖哦!",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001011) ->
	#base_scene_chat_bubble{bubble_id = 2001011,object_id = 1018,object_type = 2,min_lv = 100,max_lv = 299,bubble_content = "转职好处多多，可解锁进阶技能、帅美头像、高阶装备~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001012) ->
	#base_scene_chat_bubble{bubble_id = 2001012,object_id = 1018,object_type = 2,min_lv = 100,max_lv = 299,bubble_content = "努力升级，不要错过冲级豪礼哦！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001013) ->
	#base_scene_chat_bubble{bubble_id = 2001013,object_id = 1018,object_type = 2,min_lv = 100,max_lv = 299,bubble_content = "求大佬看一眼日常，金币、经验拿到手软~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001014) ->
	#base_scene_chat_bubble{bubble_id = 2001014,object_id = 1018,object_type = 2,min_lv = 100,max_lv = 299,bubble_content = "通关御魂塔层数，每天可收到固定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001015) ->
	#base_scene_chat_bubble{bubble_id = 2001015,object_id = 1018,object_type = 2,min_lv = 100,max_lv = 299,bubble_content = "日常任务获得的活跃度可提升活跃幻化形象",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001016) ->
	#base_scene_chat_bubble{bubble_id = 2001016,object_id = 1018,object_type = 2,min_lv = 100,max_lv = 299,bubble_content = "记得给装备镶嵌宝石哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001017) ->
	#base_scene_chat_bubble{bubble_id = 2001017,object_id = 1018,object_type = 2,min_lv = 100,max_lv = 299,bubble_content = "不小心错过了当日任务？可通过资源找回得到一定奖励",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001018) ->
	#base_scene_chat_bubble{bubble_id = 2001018,object_id = 1018,object_type = 2,min_lv = 100,max_lv = 299,bubble_content = "转职可解锁新头像、进阶技能",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001019) ->
	#base_scene_chat_bubble{bubble_id = 2001019,object_id = 1018,object_type = 2,min_lv = 100,max_lv = 299,bubble_content = "记得完成结社任务啦！奖励多多~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001020) ->
	#base_scene_chat_bubble{bubble_id = 2001020,object_id = 1018,object_type = 2,min_lv = 100,max_lv = 299,bubble_content = "不要忘记每日签到奖励哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001021) ->
	#base_scene_chat_bubble{bubble_id = 2001021,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "星星会指引你的方向。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001022) ->
	#base_scene_chat_bubble{bubble_id = 2001022,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "蹡蹡♪未来最喜欢你了❤",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001023) ->
	#base_scene_chat_bubble{bubble_id = 2001023,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "想感受夜空的魅力吗？",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001024) ->
	#base_scene_chat_bubble{bubble_id = 2001024,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "如果认可未来的法术，就叫声姐姐吧♪",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001025) ->
	#base_scene_chat_bubble{bubble_id = 2001025,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "多参加参加活动吧，未来很喜欢那种热闹的环境呢！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001026) ->
	#base_scene_chat_bubble{bubble_id = 2001026,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "挑战神纹烙印遇到困难的话，试试和其他人组队如何？",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001027) ->
	#base_scene_chat_bubble{bubble_id = 2001027,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "询问女孩子的年龄并不是礼貌的行为！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001028) ->
	#base_scene_chat_bubble{bubble_id = 2001028,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "挑战世界大妖时可以向结社的小伙伴请求协助哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001029) ->
	#base_scene_chat_bubble{bubble_id = 2001029,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "每天的20次日常任务是获取经验的好方法，不要忘记去完成哦~",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2001030) ->
	#base_scene_chat_bubble{bubble_id = 2001030,object_id = 1018,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "流星陨落的时候，记得许个愿望吧！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2011021) ->
	#base_scene_chat_bubble{bubble_id = 2011021,object_id = 1033,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "呵呵……人与人之间的缘分真的很奇妙呢！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2011022) ->
	#base_scene_chat_bubble{bubble_id = 2011022,object_id = 1033,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "有心仪的人了吗？要不要给TA送一束花呢？",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2011023) ->
	#base_scene_chat_bubble{bubble_id = 2011023,object_id = 1033,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "我掌管姻缘，最高兴的事莫过于见到两个人终成眷属了。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2011024) ->
	#base_scene_chat_bubble{bubble_id = 2011024,object_id = 1033,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "只要真心相恋，进行多少次婚礼都不会腻，对吧？",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2011025) ->
	#base_scene_chat_bubble{bubble_id = 2011025,object_id = 1033,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "婚礼有三种形式，试着向心爱的人求婚吧！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2011026) ->
	#base_scene_chat_bubble{bubble_id = 2011026,object_id = 1033,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "爱令人沉醉，爱也令人心碎……真是一种复杂的感情。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2011027) ->
	#base_scene_chat_bubble{bubble_id = 2011027,object_id = 1033,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "为爱而生，世界才会变得如此和睦。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2011028) ->
	#base_scene_chat_bubble{bubble_id = 2011028,object_id = 1033,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "心的火焰，若用力过猛容易灼烧他人，更容易灼伤自己。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2011029) ->
	#base_scene_chat_bubble{bubble_id = 2011029,object_id = 1033,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "执子之手，与子偕老。",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(2011030) ->
	#base_scene_chat_bubble{bubble_id = 2011030,object_id = 1033,object_type = 2,min_lv = 0,max_lv = 0,bubble_content = "女孩子往往比较注重仪式感，一定很期待举行一场难忘的婚礼！",condition = "",number = "",bubble_type = 1};

get_scene_chat_bubble(_Bubbleid) ->
	[].


get_all_bubble_id(3) ->
[1,2,3,4,5,6,8,10,11,12,13,14,16,17,18,19,20,21,22,23,24,25,27,29,30,31,32,33,34,35,36,37,38];


get_all_bubble_id(4) ->
[7,9,15,26,28];


get_all_bubble_id(1) ->
[1001001,1001002,1001003,1001004,1001005,1001006,1001007,1001008,1001009,1001010,1001011,1001012,1001013,1001014,1001015,1001016,1001017,1001018,1001019,1001020,1001021,1002001,1002002,1002003,1002004,1002005,1002006,1002007,1002008,1002009,1002010,1002011,1002012,1002013,1002014,1002015,1002016,1002017,1002018,1002019,1002020,1002021,1003001,1003002,1003003,1003004,1003005,1003006,1003007,1003008,1003009,1003010,1003011,1003012,1003013,1003014,1003015,1003016,1003017,1003018,1003019,1003020,1003021,1004001,1004002,1004003,1004004,1004005,1004006,1004007,1004008,1004009,1004010,1004011,1004012,1004013,1004014,1004015,1004016,1004017,1004018,1004019,1004020,1004021,1005001,1005002,1005003,1005004,1005005,1005006,1005007,1005008,1005009,1005010,1005011,1005012,1005013,1005014,1005015,1005016,1005017,1005018,1005019,1005020,1005021,1006001,1006002,1006003,1006004,1006005,1006006,1006007,1006008,1006009,1006010,1006011,1006012,1006013,1006014,1006015,1006016,1006017,1006018,1006019,1006020,1006021,1007001,1007002,1007003,1007004,1007005,1007006,1007007,1007008,1007009,1007010,1007011,1007012,1007013,1007014,1007015,1007016,1007017,1007018,1007019,1007020,1007021,1008001,1008002,1008003,1008004,1008005,1008006,1008007,1008008,1008009,1008010,1008011,1008012,1008013,1008014,1008015,1008016,1008017,1008018,1008019,1008020,1009001,1009002,1009003,1009004,1009005,1009006,1009007,1009008,1009009,1009010,1009011,1009012,1009013,1009014,1009015,1009016,1009017,1009018,1009019,1009020,1010001,1010002,1010003,1010004,1010005,1010006,1010007,1010008,1010009,1010010,1010011,1010012,1010013,1010014,1010015,1010016,1010017,1010018,1010019,1010020,1011001,1011002,1011003,1011004,1011005,1011006,1011007,1011008,1011009,1011010,1011011,1011012,1011013,1011014,1011015,1011016,1011017,1011018,1011019,1011020,1012001,1012002,1012003,1012004,1012005,1012006,1012007,1012008,1012009,1012010,1012011,1012012,1012013,1012014,1012015,1012016,1012017,1012018,1012019,1012020,1013001,1013002,1013003,1013004,1013005,1013006,1013007,1013008,1013009,1013010,1013011,1013012,1013013,1013014,1013015,1013016,1013017,1013018,1013019,1013020,1014001,1014002,1014003,1014004,1014005,1014006,1014007,1014008,1014009,1014010,1014011,1014012,1014013,1014014,1014015,1014016,1014017,1014018,1014019,1014020,1015001,1015002,1015003,1015004,1015005,1015006,1015007,1015008,1015009,1015010,1015011,1015012,1015013,1015014,1015015,1015016,1015017,1015018,1015019,1015020];


get_all_bubble_id(2) ->
[2001001,2001002,2001003,2001004,2001005,2001006,2001007,2001008,2001009,2001010,2001011,2001012,2001013,2001014,2001015,2001016,2001017,2001018,2001019,2001020,2001021,2001022,2001023,2001024,2001025,2001026,2001027,2001028,2001029,2001030,2011021,2011022,2011023,2011024,2011025,2011026,2011027,2011028,2011029,2011030];

get_all_bubble_id(_Objecttype) ->
	[].

