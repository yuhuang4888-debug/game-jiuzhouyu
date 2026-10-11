%%%---------------------------------------
%%% module      : data_designation
%%% description : 称号配置
%%%
%%%---------------------------------------
-module(data_designation).
-compile(export_all).
-include("designation.hrl").



get_by_id(301002) ->
	#base_designation{id = 301002,main_type = 3,name = <<"呼朋唤友"/utf8>>,description = "活动获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38061002,1}],attr_list = [{1,1000},{2,20000}],resource_id = "301002",is_global = 0,color = 3,location = 54,order_limit = 40,skill_list = []};

get_by_id(301007) ->
	#base_designation{id = 301007,main_type = 2,name = <<"家财万贯"/utf8>>,description = "VIP7专属称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38061007,1}],attr_list = [{1,1000},{2,20000},{3,500}],resource_id = "301007",is_global = 0,color = 4,location = 9,order_limit = 1,skill_list = []};

get_by_id(302008) ->
	#base_designation{id = 302008,main_type = 2,name = <<"结社支柱"/utf8>>,description = "最强结社个人排名第一.",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38062008,1}],attr_list = [{1,50},{2,1000},{4,25},{3,25}],resource_id = "302008",is_global = 0,color = 5,location = 14,order_limit = 1,skill_list = []};

get_by_id(303015) ->
	#base_designation{id = 303015,main_type = 2,name = <<"持之以恒"/utf8>>,description = "蜃气楼悬赏积分排名第一.限时7天.",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38063015,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "303015",is_global = 0,color = 5,location = 81,order_limit = 1,skill_list = []};

get_by_id(303016) ->
	#base_designation{id = 303016,main_type = 2,name = <<"鬼见愁"/utf8>>,description = "蜃气楼首领榜排名第一.限时7天.",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38063016,1}],attr_list = [{1,200},{2,4000},{4,100},{3,100}],resource_id = "303016",is_global = 0,color = 5,location = 82,order_limit = 1,skill_list = []};

get_by_id(303017) ->
	#base_designation{id = 303017,main_type = 2,name = <<"出门横着走"/utf8>>,description = "蜃气楼击杀榜第一.限时7天.",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38063017,1}],attr_list = [{1,100},{2,2000},{4,50},{3,50}],resource_id = "303017",is_global = 0,color = 5,location = 83,order_limit = 1,skill_list = []};

get_by_id(304005) ->
	#base_designation{id = 304005,main_type = 2,name = <<"最强会长"/utf8>>,description = "最强结社第一名会长的专属荣誉",type = 3,expire_time = 604800,is_overlay = 1,goods_consume = [{0,38064005,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "304005",is_global = 1,color = 5,location = 44,order_limit = 1,skill_list = []};

get_by_id(304006) ->
	#base_designation{id = 304006,main_type = 2,name = <<"一发登顶"/utf8>>,description = "九魂妖塔第一个到达顶层",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38064006,1}],attr_list = [{1,300},{2,6000},{4,300},{203,200}],resource_id = "304006",is_global = 1,color = 4,location = 45,order_limit = 1,skill_list = []};

get_by_id(304007) ->
	#base_designation{id = 304007,main_type = 2,name = <<"还有话要说"/utf8>>,description = "最强王者第三名",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38064007,1}],attr_list = [{1,500},{2,10000},{4,250},{3,250}],resource_id = "304007",is_global = 1,color = 5,location = 46,order_limit = 1,skill_list = []};

get_by_id(304008) ->
	#base_designation{id = 304008,main_type = 2,name = <<"还有谁不服"/utf8>>,description = "最强王者第二名",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38064008,1}],attr_list = [{1,800},{2,16000},{4,400},{3,400}],resource_id = "304008",is_global = 1,color = 5,location = 47,order_limit = 1,skill_list = []};

get_by_id(304009) ->
	#base_designation{id = 304009,main_type = 2,name = <<"最强王者"/utf8>>,description = "最强王者第一名",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38064009,1}],attr_list = [{1,1200},{2,24000},{4,600},{3,600}],resource_id = "304009",is_global = 1,color = 5,location = 48,order_limit = 1,skill_list = []};

get_by_id(304010) ->
	#base_designation{id = 304010,main_type = 2,name = <<"1v8"/utf8>>,description = "跨服1v8",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38064010,1}],attr_list = [{1,200},{2,4000},{4,100},{3,100}],resource_id = "304010",is_global = 0,color = 5,location = 49,order_limit = 1,skill_list = []};

get_by_id(304011) ->
	#base_designation{id = 304011,main_type = 2,name = <<"1v10"/utf8>>,description = "跨服1v10",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38064011,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "304011",is_global = 0,color = 5,location = 50,order_limit = 1,skill_list = []};

get_by_id(304012) ->
	#base_designation{id = 304012,main_type = 2,name = <<"1v13"/utf8>>,description = "跨服1v13",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38064012,1}],attr_list = [{1,280},{2,5600},{4,140},{3,140}],resource_id = "304012",is_global = 0,color = 5,location = 51,order_limit = 1,skill_list = []};

get_by_id(304013) ->
	#base_designation{id = 304013,main_type = 2,name = <<"1v16"/utf8>>,description = "跨服1v16",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38064013,1}],attr_list = [{1,320},{2,6400},{4,160},{3,160}],resource_id = "304013",is_global = 0,color = 5,location = 52,order_limit = 1,skill_list = []};

get_by_id(304101) ->
	#base_designation{id = 304101,main_type = 2,name = <<"大智若愚"/utf8>>,description = "累计参加结社晚宴10次",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38064101,1}],attr_list = [{2,2000},{3,50},{4,50}],resource_id = "304101",is_global = 0,color = 5,location = 85,order_limit = 1,skill_list = []};

get_by_id(304102) ->
	#base_designation{id = 304102,main_type = 2,name = <<"结社守护者"/utf8>>,description = "累计参加最强结社10次",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38064102,1}],attr_list = [{1,100},{2,2000}],resource_id = "304102",is_global = 0,color = 5,location = 86,order_limit = 1,skill_list = []};

get_by_id(304103) ->
	#base_designation{id = 304103,main_type = 2,name = <<"结社财神"/utf8>>,description = "累计发放结社红包50次",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38064103,1}],attr_list = [{1,100},{3,50},{4,50}],resource_id = "304103",is_global = 0,color = 5,location = 87,order_limit = 1,skill_list = []};

get_by_id(304104) ->
	#base_designation{id = 304104,main_type = 2,name = <<"经商有道"/utf8>>,description = "市场获得勾玉1000",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38064104,1}],attr_list = [{2,2000},{3,50},{4,50}],resource_id = "304104",is_global = 0,color = 5,location = 88,order_limit = 1,skill_list = []};

get_by_id(304105) ->
	#base_designation{id = 304105,main_type = 2,name = <<"挥金如土"/utf8>>,description = "市场消费勾玉1000",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38064105,1}],attr_list = [{2,4000},{3,100},{4,100}],resource_id = "304105",is_global = 0,color = 5,location = 89,order_limit = 1,skill_list = []};

get_by_id(304106) ->
	#base_designation{id = 304106,main_type = 2,name = <<"初露头角"/utf8>>,description = "累计击杀1个玩家",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38064106,1}],attr_list = [{1,100},{2,2000},{3,50}],resource_id = "304106",is_global = 0,color = 5,location = 90,order_limit = 1,skill_list = []};

get_by_id(304107) ->
	#base_designation{id = 304107,main_type = 2,name = <<"百人斩"/utf8>>,description = "累计击杀100个玩家",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38064107,1}],attr_list = [{1,200},{2,4000},{3,100}],resource_id = "304107",is_global = 0,color = 5,location = 91,order_limit = 1,skill_list = []};

get_by_id(304108) ->
	#base_designation{id = 304108,main_type = 2,name = <<"有钱任性"/utf8>>,description = "完成首充",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38064108,1}],attr_list = [{1,50},{2,1000}],resource_id = "304108",is_global = 0,color = 5,location = 92,order_limit = 1,skill_list = []};

get_by_id(304109) ->
	#base_designation{id = 304109,main_type = 2,name = <<"手握小钱钱"/utf8>>,description = "累计获得铜币100000000",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38064109,1}],attr_list = [{3,75},{4,75}],resource_id = "304109",is_global = 0,color = 5,location = 93,order_limit = 1,skill_list = []};

get_by_id(304110) ->
	#base_designation{id = 304110,main_type = 2,name = <<"跻身中产"/utf8>>,description = "升至VIP6",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38064110,1}],attr_list = [{1,100},{2,2000},{4,50}],resource_id = "304110",is_global = 0,color = 5,location = 94,order_limit = 1,skill_list = []};

get_by_id(304111) ->
	#base_designation{id = 304111,main_type = 2,name = <<"绝对零度"/utf8>>,description = "极限试炼周榜第一",type = 3,expire_time = 518400,is_overlay = 0,goods_consume = [{0,38065069,1}],attr_list = [{1,16000},{2,800},{4,400}],resource_id = "304111",is_global = 0,color = 5,location = 95,order_limit = 1,skill_list = []};

get_by_id(305001) ->
	#base_designation{id = 305001,main_type = 2,name = <<"驯兽大师"/utf8>>,description = "开服坐骑竞榜前三名",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065001,1}],attr_list = [{1,120},{2,2400},{4,60},{3,60}],resource_id = "305001",is_global = 0,color = 4,location = 15,order_limit = 1,skill_list = []};

get_by_id(305002) ->
	#base_designation{id = 305002,main_type = 2,name = <<"谁与争锋"/utf8>>,description = "开服神纹竞榜前三名",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065002,1}],attr_list = [{1,120},{2,2400},{4,60},{3,60}],resource_id = "305002",is_global = 0,color = 4,location = 16,order_limit = 1,skill_list = []};

get_by_id(305003) ->
	#base_designation{id = 305003,main_type = 2,name = <<"永恒烙印"/utf8>>,description = "开服战力竞榜前三名",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065003,1}],attr_list = [{1,120},{2,2400},{4,60},{3,60}],resource_id = "305003",is_global = 0,color = 4,location = 17,order_limit = 1,skill_list = []};

get_by_id(305004) ->
	#base_designation{id = 305004,main_type = 2,name = <<"珠光宝气"/utf8>>,description = "开服宝石竞榜前三名",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065004,1}],attr_list = [{1,120},{2,2400},{4,60},{3,60}],resource_id = "305004",is_global = 0,color = 4,location = 18,order_limit = 1,skill_list = []};

get_by_id(305005) ->
	#base_designation{id = 305005,main_type = 2,name = <<"绝世羁绊"/utf8>>,description = "开服侍魂竞榜前三名",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065005,1}],attr_list = [{1,120},{2,2400},{4,60},{3,60}],resource_id = "305005",is_global = 0,color = 4,location = 19,order_limit = 1,skill_list = []};

get_by_id(305006) ->
	#base_designation{id = 305006,main_type = 2,name = <<"家里有矿"/utf8>>,description = "开服充值竞榜前三名",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065006,1}],attr_list = [{1,120},{2,2400},{4,60},{3,60}],resource_id = "305006",is_global = 0,color = 4,location = 20,order_limit = 1,skill_list = []};

get_by_id(305007) ->
	#base_designation{id = 305007,main_type = 2,name = <<"超世拔俗"/utf8>>,description = "开服等级竞榜前三名",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065007,1}],attr_list = [{1,120},{2,2400},{4,60},{3,60}],resource_id = "305007",is_global = 0,color = 4,location = 21,order_limit = 1,skill_list = []};

get_by_id(305008) ->
	#base_designation{id = 305008,main_type = 3,name = <<"卖萌求陪玩"/utf8>>,description = "活动获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065008,1}],attr_list = [{1,35},{2,700}],resource_id = "305008",is_global = 0,color = 2,location = 53,order_limit = 40,skill_list = []};

get_by_id(305011) ->
	#base_designation{id = 305011,main_type = 3,name = <<"庆典贵族"/utf8>>,description = "活动获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065011,1}],attr_list = [{1,200},{2,4000},{4,120},{3,120}],resource_id = "305011",is_global = 0,color = 4,location = 56,order_limit = 40,skill_list = []};

get_by_id(305028) ->
	#base_designation{id = 305028,main_type = 3,name = <<"豪门新贵"/utf8>>,description = "至尊VIP特权商城",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065025,1}],attr_list = [{1,80},{2,1600},{3,40},{4,40}],resource_id = "305028",is_global = 0,color = 4,location = 81,order_limit = 50,skill_list = []};

get_by_id(305029) ->
	#base_designation{id = 305029,main_type = 3,name = <<"声名显赫"/utf8>>,description = "至尊VIP特权商城",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065026,1}],attr_list = [{1,160},{2,3200},{3,80},{4,80}],resource_id = "305029",is_global = 0,color = 4,location = 82,order_limit = 50,skill_list = []};

get_by_id(305030) ->
	#base_designation{id = 305030,main_type = 4,name = <<"新秀登场"/utf8>>,description = "1元礼包活动获得",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065027,1}],attr_list = [{1,50},{2,1000}],resource_id = "ui_2047",is_global = 0,color = 5,location = 104,order_limit = 1,skill_list = []};

get_by_id(305031) ->
	#base_designation{id = 305031,main_type = 3,name = <<"梦之伊始"/utf8>>,description = "1元礼包活动获得",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065028,1}],attr_list = [{1,500},{2,10000}],resource_id = "ui_2044",is_global = 0,color = 5,location = 104,order_limit = 5,skill_list = []};

get_by_id(305076) ->
	#base_designation{id = 305076,main_type = 4,name = <<"真·神壕"/utf8>>,description = "充值榜、消费榜双榜第一可获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38068008,1}],attr_list = [{1,600},{2,12000},{3,300},{17,100}],resource_id = "305076",is_global = 0,color = 5,location = 82,order_limit = 1,skill_list = []};

get_by_id(305143) ->
	#base_designation{id = 305143,main_type = 4,name = <<"大冒险家"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065143,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "UI_2045",is_global = 0,color = 4,location = 230,order_limit = 1,skill_list = []};

get_by_id(305144) ->
	#base_designation{id = 305144,main_type = 4,name = <<"神巫之契"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065144,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "305144",is_global = 0,color = 4,location = 231,order_limit = 1,skill_list = []};

get_by_id(305145) ->
	#base_designation{id = 305145,main_type = 2,name = <<"闪亮登场"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065145,1}],attr_list = [{1,100},{2,6000},{3,100},{4,100}],resource_id = "ui_2046",is_global = 0,color = 4,location = 24,order_limit = 1,skill_list = []};

get_by_id(305146) ->
	#base_designation{id = 305146,main_type = 3,name = <<"幸福恋人"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065146,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "ui_2050",is_global = 0,color = 4,location = 105,order_limit = 50,skill_list = []};

get_by_id(305147) ->
	#base_designation{id = 305147,main_type = 3,name = <<"鹊桥之恋"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065147,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "ui_2051",is_global = 0,color = 4,location = 106,order_limit = 50,skill_list = []};

get_by_id(305148) ->
	#base_designation{id = 305148,main_type = 3,name = <<"比翼同心"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065148,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "ui_2052",is_global = 0,color = 4,location = 107,order_limit = 50,skill_list = []};

get_by_id(305149) ->
	#base_designation{id = 305149,main_type = 3,name = <<"玉兔献礼"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065149,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "ui_2053",is_global = 0,color = 4,location = 108,order_limit = 50,skill_list = []};

get_by_id(305150) ->
	#base_designation{id = 305150,main_type = 3,name = <<"团团圆圆"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065150,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "ui_2055",is_global = 0,color = 4,location = 109,order_limit = 50,skill_list = []};

get_by_id(305151) ->
	#base_designation{id = 305151,main_type = 3,name = <<"琼楼玉宇"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065151,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "ui_2056",is_global = 0,color = 4,location = 110,order_limit = 50,skill_list = []};

get_by_id(305152) ->
	#base_designation{id = 305152,main_type = 3,name = <<"传道受业"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065152,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "ui_2063",is_global = 0,color = 4,location = 111,order_limit = 50,skill_list = []};

get_by_id(305153) ->
	#base_designation{id = 305153,main_type = 3,name = <<"照世明灯"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065153,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "ui_2064",is_global = 0,color = 4,location = 112,order_limit = 50,skill_list = []};

get_by_id(305154) ->
	#base_designation{id = 305154,main_type = 3,name = <<"阴阳传承"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065154,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "ui_2065",is_global = 0,color = 4,location = 113,order_limit = 50,skill_list = []};

get_by_id(305155) ->
	#base_designation{id = 305155,main_type = 3,name = <<"把酒赏菊"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065155,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "ui_2057",is_global = 0,color = 4,location = 114,order_limit = 50,skill_list = []};

get_by_id(305156) ->
	#base_designation{id = 305156,main_type = 3,name = <<"九九重阳"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065156,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "ui_2058",is_global = 0,color = 4,location = 115,order_limit = 50,skill_list = []};

get_by_id(305157) ->
	#base_designation{id = 305157,main_type = 3,name = <<"避邪翁"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065157,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "ui_2059",is_global = 0,color = 4,location = 116,order_limit = 50,skill_list = []};

get_by_id(305158) ->
	#base_designation{id = 305158,main_type = 3,name = <<"万圣小鬼"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065158,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "ui_2060",is_global = 0,color = 4,location = 117,order_limit = 50,skill_list = []};

get_by_id(305159) ->
	#base_designation{id = 305159,main_type = 3,name = <<"给糖或捣蛋"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065159,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "ui_2061",is_global = 0,color = 4,location = 118,order_limit = 50,skill_list = []};

get_by_id(305160) ->
	#base_designation{id = 305160,main_type = 3,name = <<"鬼脸南瓜"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065160,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "ui_2062",is_global = 0,color = 4,location = 119,order_limit = 50,skill_list = []};

get_by_id(305161) ->
	#base_designation{id = 305161,main_type = 3,name = <<"一叶知秋"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065161,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "305161",is_global = 0,color = 4,location = 120,order_limit = 50,skill_list = []};

get_by_id(305162) ->
	#base_designation{id = 305162,main_type = 3,name = <<"叠翠流金"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065162,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "305162",is_global = 0,color = 4,location = 121,order_limit = 50,skill_list = []};

get_by_id(305163) ->
	#base_designation{id = 305163,main_type = 3,name = <<"丹枫迎秋"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065163,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "305163",is_global = 0,color = 4,location = 122,order_limit = 50,skill_list = []};

get_by_id(305164) ->
	#base_designation{id = 305164,main_type = 3,name = <<"拯救单身汪"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065164,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "ui_2066",is_global = 0,color = 4,location = 123,order_limit = 50,skill_list = []};

get_by_id(305165) ->
	#base_designation{id = 305165,main_type = 3,name = <<"剁手买买买"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065165,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "ui_2067",is_global = 0,color = 4,location = 124,order_limit = 50,skill_list = []};

get_by_id(305166) ->
	#base_designation{id = 305166,main_type = 3,name = <<"购物狂欢"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065166,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "ui_2068",is_global = 0,color = 4,location = 125,order_limit = 50,skill_list = []};

get_by_id(305167) ->
	#base_designation{id = 305167,main_type = 3,name = <<"听我说谢谢你"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065167,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "ui_2069",is_global = 0,color = 4,location = 126,order_limit = 50,skill_list = []};

get_by_id(305168) ->
	#base_designation{id = 305168,main_type = 3,name = <<"一起吃鸡"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065168,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "ui_2070",is_global = 0,color = 4,location = 127,order_limit = 50,skill_list = []};

get_by_id(305169) ->
	#base_designation{id = 305169,main_type = 3,name = <<"黑色星期五"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065169,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "ui_2071",is_global = 0,color = 4,location = 128,order_limit = 50,skill_list = []};

get_by_id(305176) ->
	#base_designation{id = 305176,main_type = 3,name = <<"冬日暖阳"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065176,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "305176",is_global = 0,color = 4,location = 135,order_limit = 50,skill_list = []};

get_by_id(305177) ->
	#base_designation{id = 305177,main_type = 3,name = <<"霜雪婵夜"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065177,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "305177",is_global = 0,color = 4,location = 136,order_limit = 50,skill_list = []};

get_by_id(305178) ->
	#base_designation{id = 305178,main_type = 3,name = <<"一阳生"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065178,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "305178",is_global = 0,color = 4,location = 137,order_limit = 50,skill_list = []};

get_by_id(305179) ->
	#base_designation{id = 305179,main_type = 3,name = <<"快乐雪人"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065179,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "ui_2072",is_global = 0,color = 4,location = 138,order_limit = 50,skill_list = []};

get_by_id(305180) ->
	#base_designation{id = 305180,main_type = 3,name = <<"礼物满满"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065180,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "ui_2073",is_global = 0,color = 4,location = 139,order_limit = 50,skill_list = []};

get_by_id(305181) ->
	#base_designation{id = 305181,main_type = 3,name = <<"圣诞老人"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065181,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "ui_2074",is_global = 0,color = 4,location = 140,order_limit = 50,skill_list = []};

get_by_id(305182) ->
	#base_designation{id = 305182,main_type = 3,name = <<"兔年吉祥"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065182,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "ui_2075",is_global = 0,color = 4,location = 141,order_limit = 50,skill_list = []};

get_by_id(305183) ->
	#base_designation{id = 305183,main_type = 3,name = <<"欢乐元旦"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065183,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "ui_2076",is_global = 0,color = 4,location = 142,order_limit = 50,skill_list = []};

get_by_id(305184) ->
	#base_designation{id = 305184,main_type = 3,name = <<"元气满满"/utf8>>,description = "活动纪念称号",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065184,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "ui_2077",is_global = 0,color = 4,location = 143,order_limit = 50,skill_list = []};

get_by_id(305185) ->
	#base_designation{id = 305185,main_type = 3,name = <<"兔年大旺"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065185,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "305185",is_global = 0,color = 4,location = 144,order_limit = 50,skill_list = []};

get_by_id(305186) ->
	#base_designation{id = 305186,main_type = 3,name = <<"年年有余"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065186,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "305186",is_global = 0,color = 4,location = 145,order_limit = 50,skill_list = []};

get_by_id(305187) ->
	#base_designation{id = 305187,main_type = 3,name = <<"财源滚滚"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065187,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "305187",is_global = 0,color = 4,location = 146,order_limit = 50,skill_list = []};

get_by_id(305188) ->
	#base_designation{id = 305188,main_type = 3,name = <<"阖家团圆"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065188,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "305188",is_global = 0,color = 4,location = 147,order_limit = 50,skill_list = []};

get_by_id(305189) ->
	#base_designation{id = 305189,main_type = 3,name = <<"灯谜寄趣"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065189,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "305189",is_global = 0,color = 4,location = 148,order_limit = 50,skill_list = []};

get_by_id(305190) ->
	#base_designation{id = 305190,main_type = 3,name = <<"闹元宵"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065190,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "305190",is_global = 0,color = 4,location = 149,order_limit = 50,skill_list = []};

get_by_id(305191) ->
	#base_designation{id = 305191,main_type = 3,name = <<"情窦初开"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065191,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "305191",is_global = 0,color = 4,location = 150,order_limit = 50,skill_list = []};

get_by_id(305192) ->
	#base_designation{id = 305192,main_type = 3,name = <<"甜蜜热恋"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065192,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "305192",is_global = 0,color = 4,location = 151,order_limit = 50,skill_list = []};

get_by_id(305193) ->
	#base_designation{id = 305193,main_type = 3,name = <<"海誓山盟"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065193,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "305193",is_global = 0,color = 4,location = 152,order_limit = 50,skill_list = []};

get_by_id(305194) ->
	#base_designation{id = 305194,main_type = 3,name = <<"二月二"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065194,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "305194",is_global = 0,color = 4,location = 153,order_limit = 50,skill_list = []};

get_by_id(305195) ->
	#base_designation{id = 305195,main_type = 3,name = <<"龙行天下"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065195,1}],attr_list = [{1,180},{2,3600},{4,90},{3,90}],resource_id = "305195",is_global = 0,color = 4,location = 154,order_limit = 50,skill_list = []};

get_by_id(305196) ->
	#base_designation{id = 305196,main_type = 3,name = <<"龙抬头"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065196,1}],attr_list = [{1,240},{2,4800},{4,120},{3,120}],resource_id = "305196",is_global = 0,color = 4,location = 155,order_limit = 50,skill_list = []};

get_by_id(305405) ->
	#base_designation{id = 305405,main_type = 2,name = <<"大妖宿敌"/utf8>>,description = "大妖开荒活动",type = 3,expire_time = 604800,is_overlay = 1,goods_consume = [{0,38065405,1}],attr_list = [{1,500},{2,10000},{4,250},{3,250}],resource_id = "305405",is_global = 0,color = 4,location = 233,order_limit = 1,skill_list = []};

get_by_id(305406) ->
	#base_designation{id = 305406,main_type = 2,name = <<"奉行阴阳"/utf8>>,description = "封测活动",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065406,1}],attr_list = [{1,50},{2,1000},{4,25},{3,25}],resource_id = "305406",is_global = 0,color = 5,location = 234,order_limit = 1,skill_list = []};

get_by_id(305407) ->
	#base_designation{id = 305407,main_type = 3,name = <<"风云化龙"/utf8>>,description = "运营活动",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065407,1}],attr_list = [{1,500},{2,10000},{4,250},{3,250}],resource_id = "305407",is_global = 0,color = 5,location = 235,order_limit = 40,skill_list = []};

get_by_id(305408) ->
	#base_designation{id = 305408,main_type = 2,name = <<"新的旅程"/utf8>>,description = "开服活动",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065408,1}],attr_list = [{1,50},{2,1000},{4,25},{3,25}],resource_id = "305408",is_global = 0,color = 5,location = 236,order_limit = 1,skill_list = []};

get_by_id(305409) ->
	#base_designation{id = 305409,main_type = 2,name = <<"御魂达人"/utf8>>,description = "开服御魂竞榜前三名",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065409,1}],attr_list = [{1,120},{2,2400},{4,60},{3,60}],resource_id = "305409",is_global = 0,color = 4,location = 19,order_limit = 1,skill_list = []};

get_by_id(305410) ->
	#base_designation{id = 305410,main_type = 3,name = <<"夏日狂欢"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065410,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "305410",is_global = 0,color = 5,location = 237,order_limit = 50,skill_list = []};

get_by_id(305411) ->
	#base_designation{id = 305411,main_type = 2,name = <<"游戏管理员"/utf8>>,description = "GM称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065411,1}],attr_list = [{1,50},{2,1000},{4,25},{3,25}],resource_id = "305411",is_global = 0,color = 5,location = 238,order_limit = 1,skill_list = []};

get_by_id(305412) ->
	#base_designation{id = 305412,main_type = 3,name = <<"月末庆典"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065412,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "305412",is_global = 0,color = 5,location = 239,order_limit = 50,skill_list = []};

get_by_id(305413) ->
	#base_designation{id = 305413,main_type = 2,name = <<"谕你初见"/utf8>>,description = "封测活动",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065413,1}],attr_list = [{1,50},{2,1000},{4,25},{3,25}],resource_id = "305413",is_global = 0,color = 5,location = 234,order_limit = 1,skill_list = []};

get_by_id(305414) ->
	#base_designation{id = 305414,main_type = 3,name = <<"主角光环"/utf8>>,description = "主角光环特有称号，激活还有更多特权",type = 1,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065414,1}],attr_list = [{1,1000},{2,20000},{3,500},{9,30}],resource_id = "UI_305414",is_global = 0,color = 5,location = 2,order_limit = 30,skill_list = []};

get_by_id(305415) ->
	#base_designation{id = 305415,main_type = 3,name = <<"年终盛典"/utf8>>,description = "活动纪念称号",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38065415,1}],attr_list = [{1,150},{2,3000},{4,75},{3,75}],resource_id = "305415",is_global = 0,color = 5,location = 240,order_limit = 50,skill_list = []};

get_by_id(306001) ->
	#base_designation{id = 306001,main_type = 6,name = <<"隐冰之王"/utf8>>,description = "占领隐冰异域且战力前十成员拥有的荣誉称号！",type = 1,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,12000},{3,4000}],resource_id = "ui_306001",is_global = 0,color = 5,location = 22,order_limit = 1,skill_list = []};

get_by_id(306002) ->
	#base_designation{id = 306002,main_type = 6,name = <<"隐冰之将"/utf8>>,description = "占领隐冰异域且战力前十成员拥有的荣誉称号！",type = 1,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,8000},{3,4000}],resource_id = "ui_306002",is_global = 0,color = 4,location = 23,order_limit = 1,skill_list = []};

get_by_id(306003) ->
	#base_designation{id = 306003,main_type = 6,name = <<"隐冰之士"/utf8>>,description = "占领隐冰异域且战力前十成员拥有的荣誉称号！",type = 1,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,3000},{3,2000}],resource_id = "ui_306003",is_global = 0,color = 3,location = 24,order_limit = 1,skill_list = []};

get_by_id(306004) ->
	#base_designation{id = 306004,main_type = 6,name = <<"千森之王"/utf8>>,description = "占领千森异域且战力前十成员拥有的荣誉称号！",type = 1,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,12000},{3,4000}],resource_id = "ui_306004",is_global = 0,color = 5,location = 25,order_limit = 1,skill_list = []};

get_by_id(306005) ->
	#base_designation{id = 306005,main_type = 6,name = <<"千森之将"/utf8>>,description = "占领千森异域且战力前十成员拥有的荣誉称号！",type = 1,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,8000},{3,4000}],resource_id = "ui_306005",is_global = 0,color = 4,location = 26,order_limit = 1,skill_list = []};

get_by_id(306006) ->
	#base_designation{id = 306006,main_type = 6,name = <<"千森之士"/utf8>>,description = "占领千森异域且战力前十成员拥有的荣誉称号！",type = 1,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,3000},{3,2000}],resource_id = "ui_306006",is_global = 0,color = 3,location = 27,order_limit = 1,skill_list = []};

get_by_id(306007) ->
	#base_designation{id = 306007,main_type = 6,name = <<"落日之王"/utf8>>,description = "占领落日异域且战力前十成员拥有的荣誉称号！",type = 1,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,12000},{3,4000}],resource_id = "ui_306007",is_global = 0,color = 5,location = 28,order_limit = 1,skill_list = []};

get_by_id(306008) ->
	#base_designation{id = 306008,main_type = 6,name = <<"落日之将"/utf8>>,description = "占领落日异域且战力前十成员拥有的荣誉称号！",type = 1,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,8000},{3,4000}],resource_id = "ui_306008",is_global = 0,color = 4,location = 29,order_limit = 1,skill_list = []};

get_by_id(306009) ->
	#base_designation{id = 306009,main_type = 6,name = <<"落日之士"/utf8>>,description = "占领落日异域且战力前十成员拥有的荣誉称号！",type = 1,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,3000},{3,2000}],resource_id = "ui_306009",is_global = 0,color = 3,location = 30,order_limit = 1,skill_list = []};

get_by_id(307001) ->
	#base_designation{id = 307001,main_type = 3,name = <<"初心阴阳师"/utf8>>,description = "初心不变,冒险不止",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38067001,1}],attr_list = [{2,2000},{4,50}],resource_id = "307001",is_global = 0,color = 1,location = 0,order_limit = 1,skill_list = []};

get_by_id(308001) ->
	#base_designation{id = 308001,main_type = 2,name = <<"搬砖大神"/utf8>>,description = "全海域搬砖排行榜第1名可获得，限时1天",type = 3,expire_time = 85800,is_overlay = 0,goods_consume = [{0,38069001,1}],attr_list = [{1,800},{2,16000},{4,400}],resource_id = "308001",is_global = 0,color = 4,location = 208,order_limit = 1,skill_list = []};

get_by_id(308002) ->
	#base_designation{id = 308002,main_type = 2,name = <<"搬砖狂魔"/utf8>>,description = "全海域搬砖排行榜第2-3名可获得，限时1天",type = 3,expire_time = 85800,is_overlay = 0,goods_consume = [{0,38069002,1}],attr_list = [{1,500},{2,10000},{4,250}],resource_id = "308002",is_global = 0,color = 4,location = 209,order_limit = 1,skill_list = []};

get_by_id(308003) ->
	#base_designation{id = 308003,main_type = 2,name = <<"搬砖达人"/utf8>>,description = "全海域搬砖排行榜第4-20名可获得，限时1天",type = 3,expire_time = 85800,is_overlay = 0,goods_consume = [{0,38069003,1}],attr_list = [{1,300},{2,6000},{4,150}],resource_id = "308003",is_global = 0,color = 4,location = 210,order_limit = 1,skill_list = []};

get_by_id(401001) ->
	#base_designation{id = 401001,main_type = 5,name = <<"喜成连理"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,120},{2,2400},{4,60},{3,60}],resource_id = "401001",is_global = 0,color = 3,location = 31,order_limit = 1,skill_list = []};

get_by_id(401002) ->
	#base_designation{id = 401002,main_type = 5,name = <<"一心一意"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,360},{2,7200},{4,180},{3,180}],resource_id = "401002",is_global = 0,color = 3,location = 32,order_limit = 1,skill_list = []};

get_by_id(401003) ->
	#base_designation{id = 401003,main_type = 5,name = <<"无间长情"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,900},{2,18000},{4,450},{3,450}],resource_id = "401003",is_global = 0,color = 3,location = 33,order_limit = 1,skill_list = []};

get_by_id(401004) ->
	#base_designation{id = 401004,main_type = 5,name = <<"比翼连枝"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,100},{2,2000}],resource_id = "401004",is_global = 0,color = 3,location = 34,order_limit = 1,skill_list = []};

get_by_id(401005) ->
	#base_designation{id = 401005,main_type = 5,name = <<"相见恨晚"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,200},{2,4000}],resource_id = "401005",is_global = 0,color = 3,location = 35,order_limit = 1,skill_list = []};

get_by_id(401006) ->
	#base_designation{id = 401006,main_type = 5,name = <<"相敬如宾"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,400},{2,8000}],resource_id = "401006",is_global = 0,color = 3,location = 36,order_limit = 1,skill_list = []};

get_by_id(401007) ->
	#base_designation{id = 401007,main_type = 5,name = <<"遍历沧桑"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,800},{2,16000}],resource_id = "401007",is_global = 0,color = 4,location = 37,order_limit = 1,skill_list = []};

get_by_id(401008) ->
	#base_designation{id = 401008,main_type = 5,name = <<"白头偕老"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,1600},{2,32000}],resource_id = "401008",is_global = 0,color = 4,location = 38,order_limit = 1,skill_list = []};

get_by_id(401009) ->
	#base_designation{id = 401009,main_type = 5,name = <<"天造地设"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,3200},{2,64000}],resource_id = "401009",is_global = 0,color = 4,location = 39,order_limit = 1,skill_list = []};

get_by_id(401010) ->
	#base_designation{id = 401010,main_type = 5,name = <<"永浴爱河"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,6400},{2,128000}],resource_id = "401010",is_global = 0,color = 4,location = 40,order_limit = 1,skill_list = []};

get_by_id(401011) ->
	#base_designation{id = 401011,main_type = 5,name = <<"生死不离"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,12800},{2,256000}],resource_id = "401011",is_global = 0,color = 5,location = 41,order_limit = 1,skill_list = []};

get_by_id(401012) ->
	#base_designation{id = 401012,main_type = 5,name = <<"缘定三生"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,25600},{2,512000}],resource_id = "401012",is_global = 0,color = 5,location = 42,order_limit = 1,skill_list = []};

get_by_id(401013) ->
	#base_designation{id = 401013,main_type = 5,name = <<"三生三世"/utf8>>,description = "伴侣系统获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{1,51200},{2,1024000}],resource_id = "401013",is_global = 0,color = 6,location = 43,order_limit = 1,skill_list = []};

get_by_id(402001) ->
	#base_designation{id = 402001,main_type = 4,name = <<"盖章认证·男神"/utf8>>,description = "全民偶像男神榜人气第一名",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38068001,1}],attr_list = [{1,3000},{2,60000},{9,250},{13,250}],resource_id = "402001",is_global = 1,color = 5,location = 75,order_limit = 1,skill_list = []};

get_by_id(402002) ->
	#base_designation{id = 402002,main_type = 4,name = <<"时尚idol"/utf8>>,description = "全民偶像男神榜人气第二名",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38068002,1}],attr_list = [{1,1600},{2,32000},{9,150},{13,150}],resource_id = "402002",is_global = 1,color = 4,location = 77,order_limit = 1,skill_list = []};

get_by_id(402003) ->
	#base_designation{id = 402003,main_type = 4,name = <<"40°C暖男"/utf8>>,description = "全民偶像男神榜人气第三名",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38068003,1}],attr_list = [{1,800},{2,16000},{9,100},{13,100}],resource_id = "402003",is_global = 1,color = 3,location = 79,order_limit = 1,skill_list = []};

get_by_id(402004) ->
	#base_designation{id = 402004,main_type = 4,name = <<"盖章认证·女神"/utf8>>,description = "全民偶像女神榜人气第一名",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38068004,1}],attr_list = [{1,3000},{2,60000},{9,250},{13,250}],resource_id = "402004",is_global = 1,color = 5,location = 76,order_limit = 1,skill_list = []};

get_by_id(402005) ->
	#base_designation{id = 402005,main_type = 4,name = <<"C位出道"/utf8>>,description = "全民偶像女神榜人气第二名",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38068005,1}],attr_list = [{1,1600},{2,32000},{9,150},{13,150}],resource_id = "402005",is_global = 1,color = 4,location = 78,order_limit = 1,skill_list = []};

get_by_id(402006) ->
	#base_designation{id = 402006,main_type = 4,name = <<"人见人爱"/utf8>>,description = "全民偶像女神榜人气第三名",type = 3,expire_time = 604800,is_overlay = 0,goods_consume = [{0,38068006,1}],attr_list = [{1,800},{2,16000},{9,100},{13,100}],resource_id = "402006",is_global = 1,color = 3,location = 80,order_limit = 1,skill_list = []};

get_by_id(403001) ->
	#base_designation{id = 403001,main_type = 4,name = <<"完美情缘"/utf8>>,description = "完成开服·完美情缘活动获得此称号奖励",type = 3,expire_time = 0,is_overlay = 0,goods_consume = [{0,38068007,1}],attr_list = [{1,500},{2,10000},{4,250},{3,250}],resource_id = "403001",is_global = 0,color = 4,location = 81,order_limit = 1,skill_list = []};

get_by_id(701001) ->
	#base_designation{id = 701001,main_type = 7,name = <<"伴侣称号"/utf8>>,description = "完成求婚后获得",type = 2,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{2,2000},{4,100}],resource_id = "701001",is_global = 0,color = 4,location = 82,order_limit = 1,skill_list = []};

get_by_id(801001) ->
	#base_designation{id = 801001,main_type = 8,name = <<"海域之王"/utf8>>,description = "拥有海王职位可获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{311,1000},{20,500},{19,500}],resource_id = "801001",is_global = 0,color = 4,location = 202,order_limit = 1,skill_list = []};

get_by_id(801002) ->
	#base_designation{id = 801002,main_type = 8,name = <<"海域统帅"/utf8>>,description = "拥有海域统帅职位可获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{311,500},{20,200},{19,200}],resource_id = "801002",is_global = 0,color = 4,location = 203,order_limit = 1,skill_list = []};

get_by_id(801003) ->
	#base_designation{id = 801003,main_type = 8,name = <<"海域元帅"/utf8>>,description = "拥有海域元帅职位可获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{311,500},{20,200},{19,200}],resource_id = "801003",is_global = 0,color = 4,location = 204,order_limit = 1,skill_list = []};

get_by_id(801004) ->
	#base_designation{id = 801004,main_type = 8,name = <<"海域指挥"/utf8>>,description = "拥有海域指挥职位可获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{311,500},{20,200},{19,200}],resource_id = "801004",is_global = 0,color = 4,location = 205,order_limit = 1,skill_list = []};

get_by_id(801005) ->
	#base_designation{id = 801005,main_type = 8,name = <<"海域禁军"/utf8>>,description = "拥有海域禁军职位可获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{311,200},{20,100},{19,100}],resource_id = "801005",is_global = 0,color = 4,location = 206,order_limit = 1,skill_list = []};

get_by_id(801006) ->
	#base_designation{id = 801006,main_type = 8,name = <<"海域霸主"/utf8>>,description = "拥有海域霸主职位可获得",type = 3,expire_time = 0,is_overlay = 0,goods_consume = 0,attr_list = [{311,1000},{20,500},{19,500}],resource_id = "801006",is_global = 0,color = 4,location = 207,order_limit = 1,skill_list = [{1860001,1}]};

get_by_id(_Id) ->
	[].

get_all_designation() ->
[301002,301007,302008,303015,303016,303017,304005,304006,304007,304008,304009,304010,304011,304012,304013,304101,304102,304103,304104,304105,304106,304107,304108,304109,304110,304111,305001,305002,305003,305004,305005,305006,305007,305008,305011,305028,305029,305030,305031,305076,305143,305144,305145,305146,305147,305148,305149,305150,305151,305152,305153,305154,305155,305156,305157,305158,305159,305160,305161,305162,305163,305164,305165,305166,305167,305168,305169,305176,305177,305178,305179,305180,305181,305182,305183,305184,305185,305186,305187,305188,305189,305190,305191,305192,305193,305194,305195,305196,305405,305406,305407,305408,305409,305410,305411,305412,305413,305414,305415,306001,306002,306003,306004,306005,306006,306007,306008,306009,307001,308001,308002,308003,401001,401002,401003,401004,401005,401006,401007,401008,401009,401010,401011,401012,401013,402001,402002,402003,402004,402005,402006,403001,701001,801001,801002,801003,801004,801005,801006].


get_designation_id([{0,38061002,1}]) ->
[301002];


get_designation_id([{0,38061007,1}]) ->
[301007];


get_designation_id([{0,38062008,1}]) ->
[302008];


get_designation_id([{0,38063015,1}]) ->
[303015];


get_designation_id([{0,38063016,1}]) ->
[303016];


get_designation_id([{0,38063017,1}]) ->
[303017];


get_designation_id([{0,38064005,1}]) ->
[304005];


get_designation_id([{0,38064006,1}]) ->
[304006];


get_designation_id([{0,38064007,1}]) ->
[304007];


get_designation_id([{0,38064008,1}]) ->
[304008];


get_designation_id([{0,38064009,1}]) ->
[304009];


get_designation_id([{0,38064010,1}]) ->
[304010];


get_designation_id([{0,38064011,1}]) ->
[304011];


get_designation_id([{0,38064012,1}]) ->
[304012];


get_designation_id([{0,38064013,1}]) ->
[304013];


get_designation_id([{0,38064101,1}]) ->
[304101];


get_designation_id([{0,38064102,1}]) ->
[304102];


get_designation_id([{0,38064103,1}]) ->
[304103];


get_designation_id([{0,38064104,1}]) ->
[304104];


get_designation_id([{0,38064105,1}]) ->
[304105];


get_designation_id([{0,38064106,1}]) ->
[304106];


get_designation_id([{0,38064107,1}]) ->
[304107];


get_designation_id([{0,38064108,1}]) ->
[304108];


get_designation_id([{0,38064109,1}]) ->
[304109];


get_designation_id([{0,38064110,1}]) ->
[304110];


get_designation_id([{0,38065069,1}]) ->
[304111];


get_designation_id([{0,38065001,1}]) ->
[305001];


get_designation_id([{0,38065002,1}]) ->
[305002];


get_designation_id([{0,38065003,1}]) ->
[305003];


get_designation_id([{0,38065004,1}]) ->
[305004];


get_designation_id([{0,38065005,1}]) ->
[305005];


get_designation_id([{0,38065006,1}]) ->
[305006];


get_designation_id([{0,38065007,1}]) ->
[305007];


get_designation_id([{0,38065008,1}]) ->
[305008];


get_designation_id([{0,38065011,1}]) ->
[305011];


get_designation_id([{0,38065025,1}]) ->
[305028];


get_designation_id([{0,38065026,1}]) ->
[305029];


get_designation_id([{0,38065027,1}]) ->
[305030];


get_designation_id([{0,38065028,1}]) ->
[305031];


get_designation_id([{0,38068008,1}]) ->
[305076];


get_designation_id([{0,38065143,1}]) ->
[305143];


get_designation_id([{0,38065144,1}]) ->
[305144];


get_designation_id([{0,38065145,1}]) ->
[305145];


get_designation_id([{0,38065146,1}]) ->
[305146];


get_designation_id([{0,38065147,1}]) ->
[305147];


get_designation_id([{0,38065148,1}]) ->
[305148];


get_designation_id([{0,38065149,1}]) ->
[305149];


get_designation_id([{0,38065150,1}]) ->
[305150];


get_designation_id([{0,38065151,1}]) ->
[305151];


get_designation_id([{0,38065152,1}]) ->
[305152];


get_designation_id([{0,38065153,1}]) ->
[305153];


get_designation_id([{0,38065154,1}]) ->
[305154];


get_designation_id([{0,38065155,1}]) ->
[305155];


get_designation_id([{0,38065156,1}]) ->
[305156];


get_designation_id([{0,38065157,1}]) ->
[305157];


get_designation_id([{0,38065158,1}]) ->
[305158];


get_designation_id([{0,38065159,1}]) ->
[305159];


get_designation_id([{0,38065160,1}]) ->
[305160];


get_designation_id([{0,38065161,1}]) ->
[305161];


get_designation_id([{0,38065162,1}]) ->
[305162];


get_designation_id([{0,38065163,1}]) ->
[305163];


get_designation_id([{0,38065164,1}]) ->
[305164];


get_designation_id([{0,38065165,1}]) ->
[305165];


get_designation_id([{0,38065166,1}]) ->
[305166];


get_designation_id([{0,38065167,1}]) ->
[305167];


get_designation_id([{0,38065168,1}]) ->
[305168];


get_designation_id([{0,38065169,1}]) ->
[305169];


get_designation_id([{0,38065176,1}]) ->
[305176];


get_designation_id([{0,38065177,1}]) ->
[305177];


get_designation_id([{0,38065178,1}]) ->
[305178];


get_designation_id([{0,38065179,1}]) ->
[305179];


get_designation_id([{0,38065180,1}]) ->
[305180];


get_designation_id([{0,38065181,1}]) ->
[305181];


get_designation_id([{0,38065182,1}]) ->
[305182];


get_designation_id([{0,38065183,1}]) ->
[305183];


get_designation_id([{0,38065184,1}]) ->
[305184];


get_designation_id([{0,38065185,1}]) ->
[305185];


get_designation_id([{0,38065186,1}]) ->
[305186];


get_designation_id([{0,38065187,1}]) ->
[305187];


get_designation_id([{0,38065188,1}]) ->
[305188];


get_designation_id([{0,38065189,1}]) ->
[305189];


get_designation_id([{0,38065190,1}]) ->
[305190];


get_designation_id([{0,38065191,1}]) ->
[305191];


get_designation_id([{0,38065192,1}]) ->
[305192];


get_designation_id([{0,38065193,1}]) ->
[305193];


get_designation_id([{0,38065194,1}]) ->
[305194];


get_designation_id([{0,38065195,1}]) ->
[305195];


get_designation_id([{0,38065196,1}]) ->
[305196];


get_designation_id([{0,38065405,1}]) ->
[305405];


get_designation_id([{0,38065406,1}]) ->
[305406];


get_designation_id([{0,38065407,1}]) ->
[305407];


get_designation_id([{0,38065408,1}]) ->
[305408];


get_designation_id([{0,38065409,1}]) ->
[305409];


get_designation_id([{0,38065410,1}]) ->
[305410];


get_designation_id([{0,38065411,1}]) ->
[305411];


get_designation_id([{0,38065412,1}]) ->
[305412];


get_designation_id([{0,38065413,1}]) ->
[305413];


get_designation_id([{0,38065414,1}]) ->
[305414];


get_designation_id([{0,38065415,1}]) ->
[305415];


get_designation_id(0) ->
[306001,306002,306003,306004,306005,306006,306007,306008,306009,401001,401002,401003,401004,401005,401006,401007,401008,401009,401010,401011,401012,401013,701001,801001,801002,801003,801004,801005,801006];


get_designation_id([{0,38067001,1}]) ->
[307001];


get_designation_id([{0,38069001,1}]) ->
[308001];


get_designation_id([{0,38069002,1}]) ->
[308002];


get_designation_id([{0,38069003,1}]) ->
[308003];


get_designation_id([{0,38068001,1}]) ->
[402001];


get_designation_id([{0,38068002,1}]) ->
[402002];


get_designation_id([{0,38068003,1}]) ->
[402003];


get_designation_id([{0,38068004,1}]) ->
[402004];


get_designation_id([{0,38068005,1}]) ->
[402005];


get_designation_id([{0,38068006,1}]) ->
[402006];


get_designation_id([{0,38068007,1}]) ->
[403001];

get_designation_id(_Goodsconsume) ->
	[].


get_dsgt_id_list(3) ->
[301002,305008,305011,305028,305029,305031,305146,305147,305148,305149,305150,305151,305152,305153,305154,305155,305156,305157,305158,305159,305160,305161,305162,305163,305164,305165,305166,305167,305168,305169,305176,305177,305178,305179,305180,305181,305182,305183,305184,305185,305186,305187,305188,305189,305190,305191,305192,305193,305194,305195,305196,305407,305410,305412,305414,305415,307001];


get_dsgt_id_list(2) ->
[301007,302008,303015,303016,303017,304005,304006,304007,304008,304009,304010,304011,304012,304013,304101,304102,304103,304104,304105,304106,304107,304108,304109,304110,304111,305001,305002,305003,305004,305005,305006,305007,305145,305405,305406,305408,305409,305411,305413,308001,308002,308003];


get_dsgt_id_list(4) ->
[305030,305076,305143,305144,402001,402002,402003,402004,402005,402006,403001];


get_dsgt_id_list(6) ->
[306001,306002,306003,306004,306005,306006,306007,306008,306009];


get_dsgt_id_list(5) ->
[401001,401002,401003,401004,401005,401006,401007,401008,401009,401010,401011,401012,401013];


get_dsgt_id_list(7) ->
[701001];


get_dsgt_id_list(8) ->
[801001,801002,801003,801004,801005,801006];

get_dsgt_id_list(_Maintype) ->
	[].

get_by_id_order(104001,1) ->
	#base_dsgt_order{dsgt_id = 104001,consume = [],dsgt_order = 1,attr_list = [{1,200},{2,4000},{4,100},{3,100}]};

get_by_id_order(104002,1) ->
	#base_dsgt_order{dsgt_id = 104002,consume = [],dsgt_order = 1,attr_list = [{1,400},{2,8000},{4,200},{3,200}]};

get_by_id_order(104003,1) ->
	#base_dsgt_order{dsgt_id = 104003,consume = [],dsgt_order = 1,attr_list = [{1,400},{2,8000},{4,200},{3,200}]};

get_by_id_order(301001,1) ->
	#base_dsgt_order{dsgt_id = 301001,consume = [],dsgt_order = 1,attr_list = [{1,20},{2,400},{4,10},{3,10}]};

get_by_id_order(301002,1) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 1,attr_list = [{1,1000},{2,20000}]};

get_by_id_order(301002,2) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 2,attr_list = [{1,2000},{2,40000}]};

get_by_id_order(301002,3) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 3,attr_list = [{1,3000},{2,60000}]};

get_by_id_order(301002,4) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 4,attr_list = [{1,4000},{2,80000}]};

get_by_id_order(301002,5) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 5,attr_list = [{1,5000},{2,100000}]};

get_by_id_order(301002,6) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 6,attr_list = [{1,6000},{2,120000}]};

get_by_id_order(301002,7) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 7,attr_list = [{1,7000},{2,140000}]};

get_by_id_order(301002,8) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 8,attr_list = [{1,8000},{2,160000}]};

get_by_id_order(301002,9) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 9,attr_list = [{1,9000},{2,180000}]};

get_by_id_order(301002,10) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 10,attr_list = [{1,10000},{2,200000}]};

get_by_id_order(301002,11) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 11,attr_list = [{1,11000},{2,220000}]};

get_by_id_order(301002,12) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 12,attr_list = [{1,12000},{2,240000}]};

get_by_id_order(301002,13) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 13,attr_list = [{1,13000},{2,260000}]};

get_by_id_order(301002,14) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 14,attr_list = [{1,14000},{2,280000}]};

get_by_id_order(301002,15) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 15,attr_list = [{1,15000},{2,300000}]};

get_by_id_order(301002,16) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 16,attr_list = [{1,16000},{2,320000}]};

get_by_id_order(301002,17) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 17,attr_list = [{1,17000},{2,340000}]};

get_by_id_order(301002,18) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 18,attr_list = [{1,18000},{2,360000}]};

get_by_id_order(301002,19) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 19,attr_list = [{1,19000},{2,380000}]};

get_by_id_order(301002,20) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 20,attr_list = [{1,20000},{2,400000}]};

get_by_id_order(301002,21) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 21,attr_list = [{1,21000},{2,420000}]};

get_by_id_order(301002,22) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 22,attr_list = [{1,22000},{2,440000}]};

get_by_id_order(301002,23) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 23,attr_list = [{1,23000},{2,460000}]};

get_by_id_order(301002,24) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 24,attr_list = [{1,24000},{2,480000}]};

get_by_id_order(301002,25) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 25,attr_list = [{1,25000},{2,500000}]};

get_by_id_order(301002,26) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 26,attr_list = [{1,26000},{2,520000}]};

get_by_id_order(301002,27) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 27,attr_list = [{1,27000},{2,540000}]};

get_by_id_order(301002,28) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 28,attr_list = [{1,28000},{2,560000}]};

get_by_id_order(301002,29) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 29,attr_list = [{1,29000},{2,580000}]};

get_by_id_order(301002,30) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 30,attr_list = [{1,30000},{2,600000}]};

get_by_id_order(301002,31) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 31,attr_list = [{1,31000},{2,620000}]};

get_by_id_order(301002,32) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 32,attr_list = [{1,32000},{2,640000}]};

get_by_id_order(301002,33) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 33,attr_list = [{1,33000},{2,660000}]};

get_by_id_order(301002,34) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 34,attr_list = [{1,34000},{2,680000}]};

get_by_id_order(301002,35) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 35,attr_list = [{1,35000},{2,700000}]};

get_by_id_order(301002,36) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 36,attr_list = [{1,36000},{2,720000}]};

get_by_id_order(301002,37) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 37,attr_list = [{1,37000},{2,740000}]};

get_by_id_order(301002,38) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 38,attr_list = [{1,38000},{2,760000}]};

get_by_id_order(301002,39) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 39,attr_list = [{1,39000},{2,780000}]};

get_by_id_order(301002,40) ->
	#base_dsgt_order{dsgt_id = 301002,consume = [{0,38061002,1}],dsgt_order = 40,attr_list = [{1,40000},{2,800000}]};

get_by_id_order(301003,1) ->
	#base_dsgt_order{dsgt_id = 301003,consume = [],dsgt_order = 1,attr_list = [{1,70},{2,1400},{4,35},{3,35}]};

get_by_id_order(301004,1) ->
	#base_dsgt_order{dsgt_id = 301004,consume = [],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(301005,1) ->
	#base_dsgt_order{dsgt_id = 301005,consume = [],dsgt_order = 1,attr_list = [{1,340},{2,6800},{4,170},{3,170}]};

get_by_id_order(301006,1) ->
	#base_dsgt_order{dsgt_id = 301006,consume = [],dsgt_order = 1,attr_list = [{1,680},{2,13600},{4,340},{3,340}]};

get_by_id_order(301007,1) ->
	#base_dsgt_order{dsgt_id = 301007,consume = [],dsgt_order = 1,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(301008,1) ->
	#base_dsgt_order{dsgt_id = 301008,consume = [],dsgt_order = 1,attr_list = [{1,1400},{2,28000},{4,700},{3,700}]};

get_by_id_order(301009,1) ->
	#base_dsgt_order{dsgt_id = 301009,consume = [],dsgt_order = 1,attr_list = [{1,1600},{2,32000},{4,800},{3,800}]};

get_by_id_order(301010,1) ->
	#base_dsgt_order{dsgt_id = 301010,consume = [],dsgt_order = 1,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(301011,1) ->
	#base_dsgt_order{dsgt_id = 301011,consume = [],dsgt_order = 1,attr_list = [{1,2000},{2,40000},{4,1000},{3,1000}]};

get_by_id_order(302008,1) ->
	#base_dsgt_order{dsgt_id = 302008,consume = [],dsgt_order = 1,attr_list = [{1,50},{2,1000},{4,25},{3,25}]};

get_by_id_order(304005,1) ->
	#base_dsgt_order{dsgt_id = 304005,consume = [],dsgt_order = 1,attr_list = [{1,120},{2,2400},{4,60},{3,60}]};

get_by_id_order(304006,1) ->
	#base_dsgt_order{dsgt_id = 304006,consume = [],dsgt_order = 1,attr_list = [{1,96},{2,1920},{3,48},{4,48}]};

get_by_id_order(304007,1) ->
	#base_dsgt_order{dsgt_id = 304007,consume = [],dsgt_order = 1,attr_list = [{1,500},{2,10000},{4,250},{3,250}]};

get_by_id_order(304008,1) ->
	#base_dsgt_order{dsgt_id = 304008,consume = [],dsgt_order = 1,attr_list = [{1,800},{2,16000},{4,400},{3,400}]};

get_by_id_order(304009,1) ->
	#base_dsgt_order{dsgt_id = 304009,consume = [],dsgt_order = 1,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305001,1) ->
	#base_dsgt_order{dsgt_id = 305001,consume = [],dsgt_order = 1,attr_list = [{1,120},{2,2400},{4,60},{3,60}]};

get_by_id_order(305002,1) ->
	#base_dsgt_order{dsgt_id = 305002,consume = [],dsgt_order = 1,attr_list = [{1,120},{2,2400},{4,60},{3,60}]};

get_by_id_order(305003,1) ->
	#base_dsgt_order{dsgt_id = 305003,consume = [],dsgt_order = 1,attr_list = [{1,120},{2,2400},{4,60},{3,60}]};

get_by_id_order(305004,1) ->
	#base_dsgt_order{dsgt_id = 305004,consume = [],dsgt_order = 1,attr_list = [{1,120},{2,2400},{4,60},{3,60}]};

get_by_id_order(305005,1) ->
	#base_dsgt_order{dsgt_id = 305005,consume = [],dsgt_order = 1,attr_list = [{1,120},{2,2400},{4,60},{3,60}]};

get_by_id_order(305006,1) ->
	#base_dsgt_order{dsgt_id = 305006,consume = [],dsgt_order = 1,attr_list = [{1,120},{2,2400},{4,60},{3,60}]};

get_by_id_order(305007,1) ->
	#base_dsgt_order{dsgt_id = 305007,consume = [],dsgt_order = 1,attr_list = [{1,120},{2,2400},{4,60},{3,60}]};

get_by_id_order(305008,1) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 1,attr_list = [{1,35},{2,700}]};

get_by_id_order(305008,2) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 2,attr_list = [{1,70},{2,1400}]};

get_by_id_order(305008,3) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 3,attr_list = [{1,105},{2,2100}]};

get_by_id_order(305008,4) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 4,attr_list = [{1,140},{2,2800}]};

get_by_id_order(305008,5) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 5,attr_list = [{1,175},{2,3500}]};

get_by_id_order(305008,6) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 6,attr_list = [{1,210},{2,4200}]};

get_by_id_order(305008,7) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 7,attr_list = [{1,245},{2,4900}]};

get_by_id_order(305008,8) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 8,attr_list = [{1,280},{2,5600}]};

get_by_id_order(305008,9) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 9,attr_list = [{1,315},{2,6300}]};

get_by_id_order(305008,10) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 10,attr_list = [{1,350},{2,7000}]};

get_by_id_order(305008,11) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 11,attr_list = [{1,385},{2,7700}]};

get_by_id_order(305008,12) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 12,attr_list = [{1,420},{2,8400}]};

get_by_id_order(305008,13) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 13,attr_list = [{1,455},{2,9100}]};

get_by_id_order(305008,14) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 14,attr_list = [{1,490},{2,9800}]};

get_by_id_order(305008,15) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 15,attr_list = [{1,525},{2,10500}]};

get_by_id_order(305008,16) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 16,attr_list = [{1,560},{2,11200}]};

get_by_id_order(305008,17) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 17,attr_list = [{1,595},{2,11900}]};

get_by_id_order(305008,18) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 18,attr_list = [{1,630},{2,12600}]};

get_by_id_order(305008,19) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 19,attr_list = [{1,665},{2,13300}]};

get_by_id_order(305008,20) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 20,attr_list = [{1,700},{2,14000}]};

get_by_id_order(305008,21) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 21,attr_list = [{1,735},{2,14700}]};

get_by_id_order(305008,22) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 22,attr_list = [{1,770},{2,15400}]};

get_by_id_order(305008,23) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 23,attr_list = [{1,805},{2,16100}]};

get_by_id_order(305008,24) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 24,attr_list = [{1,840},{2,16800}]};

get_by_id_order(305008,25) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 25,attr_list = [{1,875},{2,17500}]};

get_by_id_order(305008,26) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 26,attr_list = [{1,910},{2,18200}]};

get_by_id_order(305008,27) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 27,attr_list = [{1,945},{2,18900}]};

get_by_id_order(305008,28) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 28,attr_list = [{1,980},{2,19600}]};

get_by_id_order(305008,29) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 29,attr_list = [{1,1015},{2,20300}]};

get_by_id_order(305008,30) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 30,attr_list = [{1,1050},{2,21000}]};

get_by_id_order(305008,31) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 31,attr_list = [{1,1085},{2,21700}]};

get_by_id_order(305008,32) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 32,attr_list = [{1,1120},{2,22400}]};

get_by_id_order(305008,33) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 33,attr_list = [{1,1155},{2,23100}]};

get_by_id_order(305008,34) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 34,attr_list = [{1,1190},{2,23800}]};

get_by_id_order(305008,35) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 35,attr_list = [{1,1225},{2,24500}]};

get_by_id_order(305008,36) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 36,attr_list = [{1,1260},{2,25200}]};

get_by_id_order(305008,37) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 37,attr_list = [{1,1295},{2,25900}]};

get_by_id_order(305008,38) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 38,attr_list = [{1,1330},{2,26600}]};

get_by_id_order(305008,39) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 39,attr_list = [{1,1365},{2,27300}]};

get_by_id_order(305008,40) ->
	#base_dsgt_order{dsgt_id = 305008,consume = [{0,38065008,1}],dsgt_order = 40,attr_list = [{1,1400},{2,28000}]};

get_by_id_order(305009,1) ->
	#base_dsgt_order{dsgt_id = 305009,consume = [],dsgt_order = 1,attr_list = [{1,50},{2,1000},{4,25},{3,25}]};

get_by_id_order(305010,1) ->
	#base_dsgt_order{dsgt_id = 305010,consume = [],dsgt_order = 1,attr_list = [{1,70},{2,1400},{4,35},{3,35}]};

get_by_id_order(305011,1) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 1,attr_list = [{1,200},{2,4000},{4,120},{3,120}]};

get_by_id_order(305011,2) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 2,attr_list = [{1,400},{2,8000},{4,240},{3,240}]};

get_by_id_order(305011,3) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 3,attr_list = [{1,600},{2,12000},{4,360},{3,360}]};

get_by_id_order(305011,4) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 4,attr_list = [{1,800},{2,16000},{4,480},{3,480}]};

get_by_id_order(305011,5) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 5,attr_list = [{1,1000},{2,20000},{4,600},{3,600}]};

get_by_id_order(305011,6) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 6,attr_list = [{1,1200},{2,24000},{4,720},{3,720}]};

get_by_id_order(305011,7) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 7,attr_list = [{1,1400},{2,28000},{4,840},{3,840}]};

get_by_id_order(305011,8) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 8,attr_list = [{1,1600},{2,32000},{4,960},{3,960}]};

get_by_id_order(305011,9) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 9,attr_list = [{1,1800},{2,36000},{4,1080},{3,1080}]};

get_by_id_order(305011,10) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 10,attr_list = [{1,2000},{2,40000},{4,1200},{3,1200}]};

get_by_id_order(305011,11) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 11,attr_list = [{1,2200},{2,44000},{4,1320},{3,1320}]};

get_by_id_order(305011,12) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 12,attr_list = [{1,2400},{2,48000},{4,1440},{3,1440}]};

get_by_id_order(305011,13) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 13,attr_list = [{1,2600},{2,52000},{4,1560},{3,1560}]};

get_by_id_order(305011,14) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 14,attr_list = [{1,2800},{2,56000},{4,1680},{3,1680}]};

get_by_id_order(305011,15) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 15,attr_list = [{1,3000},{2,60000},{4,1800},{3,1800}]};

get_by_id_order(305011,16) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 16,attr_list = [{1,3200},{2,64000},{4,1920},{3,1920}]};

get_by_id_order(305011,17) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 17,attr_list = [{1,3400},{2,68000},{4,2040},{3,2040}]};

get_by_id_order(305011,18) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 18,attr_list = [{1,3600},{2,72000},{4,2160},{3,2160}]};

get_by_id_order(305011,19) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 19,attr_list = [{1,3800},{2,76000},{4,2280},{3,2280}]};

get_by_id_order(305011,20) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 20,attr_list = [{1,4000},{2,80000},{4,2400},{3,2400}]};

get_by_id_order(305011,21) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 21,attr_list = [{1,4200},{2,84000},{4,2520},{3,2520}]};

get_by_id_order(305011,22) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 22,attr_list = [{1,4400},{2,88000},{4,2640},{3,2640}]};

get_by_id_order(305011,23) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 23,attr_list = [{1,4600},{2,92000},{4,2760},{3,2760}]};

get_by_id_order(305011,24) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 24,attr_list = [{1,4800},{2,96000},{4,2880},{3,2880}]};

get_by_id_order(305011,25) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 25,attr_list = [{1,5000},{2,100000},{4,3000},{3,3000}]};

get_by_id_order(305011,26) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 26,attr_list = [{1,5200},{2,104000},{4,3120},{3,3120}]};

get_by_id_order(305011,27) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 27,attr_list = [{1,5400},{2,108000},{4,3240},{3,3240}]};

get_by_id_order(305011,28) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 28,attr_list = [{1,5600},{2,112000},{4,3360},{3,3360}]};

get_by_id_order(305011,29) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 29,attr_list = [{1,5800},{2,116000},{4,3480},{3,3480}]};

get_by_id_order(305011,30) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 30,attr_list = [{1,6000},{2,120000},{4,3600},{3,3600}]};

get_by_id_order(305011,31) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 31,attr_list = [{1,6200},{2,124000},{4,3720},{3,3720}]};

get_by_id_order(305011,32) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 32,attr_list = [{1,6400},{2,128000},{4,3840},{3,3840}]};

get_by_id_order(305011,33) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 33,attr_list = [{1,6600},{2,132000},{4,3960},{3,3960}]};

get_by_id_order(305011,34) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 34,attr_list = [{1,6800},{2,136000},{4,4080},{3,4080}]};

get_by_id_order(305011,35) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 35,attr_list = [{1,7000},{2,140000},{4,4200},{3,4200}]};

get_by_id_order(305011,36) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 36,attr_list = [{1,7200},{2,144000},{4,4320},{3,4320}]};

get_by_id_order(305011,37) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 37,attr_list = [{1,7400},{2,148000},{4,4440},{3,4440}]};

get_by_id_order(305011,38) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 38,attr_list = [{1,7600},{2,152000},{4,4560},{3,4560}]};

get_by_id_order(305011,39) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 39,attr_list = [{1,7800},{2,156000},{4,4680},{3,4680}]};

get_by_id_order(305011,40) ->
	#base_dsgt_order{dsgt_id = 305011,consume = [{0,38065011,1}],dsgt_order = 40,attr_list = [{1,8000},{2,160000},{4,4800},{3,4800}]};

get_by_id_order(305012,1) ->
	#base_dsgt_order{dsgt_id = 305012,consume = [],dsgt_order = 1,attr_list = [{1,180},{2,3600},{3,90},{4,90}]};

get_by_id_order(305020,1) ->
	#base_dsgt_order{dsgt_id = 305020,consume = [{0,38062003,1}],dsgt_order = 1,attr_list = [{1,200},{2,4000},{4,100},{3,100}]};

get_by_id_order(305020,2) ->
	#base_dsgt_order{dsgt_id = 305020,consume = [{0,38062003,1}],dsgt_order = 2,attr_list = [{1,400},{2,8000},{4,200},{3,200}]};

get_by_id_order(305020,3) ->
	#base_dsgt_order{dsgt_id = 305020,consume = [{0,38062003,1}],dsgt_order = 3,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305020,4) ->
	#base_dsgt_order{dsgt_id = 305020,consume = [{0,38062003,1}],dsgt_order = 4,attr_list = [{1,800},{2,16000},{4,400},{3,400}]};

get_by_id_order(305020,5) ->
	#base_dsgt_order{dsgt_id = 305020,consume = [{0,38062003,1}],dsgt_order = 5,attr_list = [{1,1000},{2,20000},{4,500},{3,500}]};

get_by_id_order(305020,6) ->
	#base_dsgt_order{dsgt_id = 305020,consume = [{0,38062003,1}],dsgt_order = 6,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305020,7) ->
	#base_dsgt_order{dsgt_id = 305020,consume = [{0,38062003,1}],dsgt_order = 7,attr_list = [{1,1400},{2,28000},{4,700},{3,700}]};

get_by_id_order(305020,8) ->
	#base_dsgt_order{dsgt_id = 305020,consume = [{0,38062003,1}],dsgt_order = 8,attr_list = [{1,1600},{2,32000},{4,800},{3,800}]};

get_by_id_order(305020,9) ->
	#base_dsgt_order{dsgt_id = 305020,consume = [{0,38062003,1}],dsgt_order = 9,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305020,10) ->
	#base_dsgt_order{dsgt_id = 305020,consume = [{0,38062003,1}],dsgt_order = 10,attr_list = [{1,2000},{2,40000},{4,1000},{3,1000}]};

get_by_id_order(305021,1) ->
	#base_dsgt_order{dsgt_id = 305021,consume = [{0,38062005,1}],dsgt_order = 1,attr_list = [{1,200},{2,4000},{4,100},{3,100}]};

get_by_id_order(305021,2) ->
	#base_dsgt_order{dsgt_id = 305021,consume = [{0,38062005,1}],dsgt_order = 2,attr_list = [{1,400},{2,8000},{4,200},{3,200}]};

get_by_id_order(305021,3) ->
	#base_dsgt_order{dsgt_id = 305021,consume = [{0,38062005,1}],dsgt_order = 3,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305021,4) ->
	#base_dsgt_order{dsgt_id = 305021,consume = [{0,38062005,1}],dsgt_order = 4,attr_list = [{1,800},{2,16000},{4,400},{3,400}]};

get_by_id_order(305021,5) ->
	#base_dsgt_order{dsgt_id = 305021,consume = [{0,38062005,1}],dsgt_order = 5,attr_list = [{1,1000},{2,20000},{4,500},{3,500}]};

get_by_id_order(305021,6) ->
	#base_dsgt_order{dsgt_id = 305021,consume = [{0,38062005,1}],dsgt_order = 6,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305021,7) ->
	#base_dsgt_order{dsgt_id = 305021,consume = [{0,38062005,1}],dsgt_order = 7,attr_list = [{1,1400},{2,28000},{4,700},{3,700}]};

get_by_id_order(305021,8) ->
	#base_dsgt_order{dsgt_id = 305021,consume = [{0,38062005,1}],dsgt_order = 8,attr_list = [{1,1600},{2,32000},{4,800},{3,800}]};

get_by_id_order(305021,9) ->
	#base_dsgt_order{dsgt_id = 305021,consume = [{0,38062005,1}],dsgt_order = 9,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305021,10) ->
	#base_dsgt_order{dsgt_id = 305021,consume = [{0,38062005,1}],dsgt_order = 10,attr_list = [{1,2000},{2,40000},{4,1000},{3,1000}]};

get_by_id_order(305022,1) ->
	#base_dsgt_order{dsgt_id = 305022,consume = [{0,38063011,1}],dsgt_order = 1,attr_list = [{1,200},{2,4000},{4,100},{3,100}]};

get_by_id_order(305022,2) ->
	#base_dsgt_order{dsgt_id = 305022,consume = [{0,38062005,1}],dsgt_order = 2,attr_list = [{1,400},{2,8000},{4,200},{3,200}]};

get_by_id_order(305022,3) ->
	#base_dsgt_order{dsgt_id = 305022,consume = [{0,38062005,1}],dsgt_order = 3,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305022,4) ->
	#base_dsgt_order{dsgt_id = 305022,consume = [{0,38062005,1}],dsgt_order = 4,attr_list = [{1,800},{2,16000},{4,400},{3,400}]};

get_by_id_order(305022,5) ->
	#base_dsgt_order{dsgt_id = 305022,consume = [{0,38062005,1}],dsgt_order = 5,attr_list = [{1,1000},{2,20000},{4,500},{3,500}]};

get_by_id_order(305022,6) ->
	#base_dsgt_order{dsgt_id = 305022,consume = [{0,38062005,1}],dsgt_order = 6,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305022,7) ->
	#base_dsgt_order{dsgt_id = 305022,consume = [{0,38062005,1}],dsgt_order = 7,attr_list = [{1,1400},{2,28000},{4,700},{3,700}]};

get_by_id_order(305022,8) ->
	#base_dsgt_order{dsgt_id = 305022,consume = [{0,38062005,1}],dsgt_order = 8,attr_list = [{1,1600},{2,32000},{4,800},{3,800}]};

get_by_id_order(305022,9) ->
	#base_dsgt_order{dsgt_id = 305022,consume = [{0,38062005,1}],dsgt_order = 9,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305022,10) ->
	#base_dsgt_order{dsgt_id = 305022,consume = [{0,38062005,1}],dsgt_order = 10,attr_list = [{1,2000},{2,40000},{4,1000},{3,1000}]};

get_by_id_order(305028,1) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 1,attr_list = [{1,80},{2,1600},{3,40},{4,40}]};

get_by_id_order(305028,2) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 2,attr_list = [{1,160},{2,3200},{3,80},{4,80}]};

get_by_id_order(305028,3) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 3,attr_list = [{1,240},{2,4800},{3,120},{4,120}]};

get_by_id_order(305028,4) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 4,attr_list = [{1,320},{2,6400},{3,160},{4,160}]};

get_by_id_order(305028,5) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 5,attr_list = [{1,400},{2,8000},{3,200},{4,200}]};

get_by_id_order(305028,6) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 6,attr_list = [{1,480},{2,9600},{3,240},{4,240}]};

get_by_id_order(305028,7) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 7,attr_list = [{1,560},{2,11200},{3,280},{4,280}]};

get_by_id_order(305028,8) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 8,attr_list = [{1,640},{2,12800},{3,320},{4,320}]};

get_by_id_order(305028,9) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 9,attr_list = [{1,720},{2,14400},{3,360},{4,360}]};

get_by_id_order(305028,10) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 10,attr_list = [{1,800},{2,16000},{3,400},{4,400}]};

get_by_id_order(305028,11) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 11,attr_list = [{1,880},{2,17600},{3,440},{4,440}]};

get_by_id_order(305028,12) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 12,attr_list = [{1,960},{2,19200},{3,480},{4,480}]};

get_by_id_order(305028,13) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 13,attr_list = [{1,1040},{2,20800},{3,520},{4,520}]};

get_by_id_order(305028,14) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 14,attr_list = [{1,1120},{2,22400},{3,560},{4,560}]};

get_by_id_order(305028,15) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 15,attr_list = [{1,1200},{2,24000},{3,600},{4,600}]};

get_by_id_order(305028,16) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 16,attr_list = [{1,1280},{2,25600},{3,640},{4,640}]};

get_by_id_order(305028,17) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 17,attr_list = [{1,1360},{2,27200},{3,680},{4,680}]};

get_by_id_order(305028,18) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 18,attr_list = [{1,1440},{2,28800},{3,720},{4,720}]};

get_by_id_order(305028,19) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 19,attr_list = [{1,1520},{2,30400},{3,760},{4,760}]};

get_by_id_order(305028,20) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 20,attr_list = [{1,1600},{2,32000},{3,800},{4,800}]};

get_by_id_order(305028,21) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 21,attr_list = [{1,1680},{2,33600},{3,840},{4,840}]};

get_by_id_order(305028,22) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 22,attr_list = [{1,1760},{2,35200},{3,880},{4,880}]};

get_by_id_order(305028,23) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 23,attr_list = [{1,1840},{2,36800},{3,920},{4,920}]};

get_by_id_order(305028,24) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 24,attr_list = [{1,1920},{2,38400},{3,960},{4,960}]};

get_by_id_order(305028,25) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 25,attr_list = [{1,2000},{2,40000},{3,1000},{4,1000}]};

get_by_id_order(305028,26) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 26,attr_list = [{1,2080},{2,41600},{3,1040},{4,1040}]};

get_by_id_order(305028,27) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 27,attr_list = [{1,2160},{2,43200},{3,1080},{4,1080}]};

get_by_id_order(305028,28) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 28,attr_list = [{1,2240},{2,44800},{3,1120},{4,1120}]};

get_by_id_order(305028,29) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 29,attr_list = [{1,2320},{2,46400},{3,1160},{4,1160}]};

get_by_id_order(305028,30) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 30,attr_list = [{1,2400},{2,48000},{3,1200},{4,1200}]};

get_by_id_order(305028,31) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 31,attr_list = [{1,2480},{2,49600},{3,1240},{4,1240}]};

get_by_id_order(305028,32) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 32,attr_list = [{1,2560},{2,51200},{3,1280},{4,1280}]};

get_by_id_order(305028,33) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 33,attr_list = [{1,2640},{2,52800},{3,1320},{4,1320}]};

get_by_id_order(305028,34) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 34,attr_list = [{1,2720},{2,54400},{3,1360},{4,1360}]};

get_by_id_order(305028,35) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 35,attr_list = [{1,2800},{2,56000},{3,1400},{4,1400}]};

get_by_id_order(305028,36) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 36,attr_list = [{1,2880},{2,57600},{3,1440},{4,1440}]};

get_by_id_order(305028,37) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 37,attr_list = [{1,2960},{2,59200},{3,1480},{4,1480}]};

get_by_id_order(305028,38) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 38,attr_list = [{1,3040},{2,60800},{3,1520},{4,1520}]};

get_by_id_order(305028,39) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 39,attr_list = [{1,3120},{2,62400},{3,1560},{4,1560}]};

get_by_id_order(305028,40) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 40,attr_list = [{1,3200},{2,64000},{3,1600},{4,1600}]};

get_by_id_order(305028,41) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 41,attr_list = [{1,3280},{2,65600},{3,1640},{4,1640}]};

get_by_id_order(305028,42) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 42,attr_list = [{1,3360},{2,67200},{3,1680},{4,1680}]};

get_by_id_order(305028,43) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 43,attr_list = [{1,3440},{2,68800},{3,1720},{4,1720}]};

get_by_id_order(305028,44) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 44,attr_list = [{1,3520},{2,70400},{3,1760},{4,1760}]};

get_by_id_order(305028,45) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 45,attr_list = [{1,3600},{2,72000},{3,1800},{4,1800}]};

get_by_id_order(305028,46) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 46,attr_list = [{1,3680},{2,73600},{3,1840},{4,1840}]};

get_by_id_order(305028,47) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 47,attr_list = [{1,3760},{2,75200},{3,1880},{4,1880}]};

get_by_id_order(305028,48) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 48,attr_list = [{1,3840},{2,76800},{3,1920},{4,1920}]};

get_by_id_order(305028,49) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 49,attr_list = [{1,3920},{2,78400},{3,1960},{4,1960}]};

get_by_id_order(305028,50) ->
	#base_dsgt_order{dsgt_id = 305028,consume = [{0,38065025,1}],dsgt_order = 50,attr_list = [{1,4000},{2,80000},{3,2000},{4,2000}]};

get_by_id_order(305029,1) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 1,attr_list = [{1,160},{2,3200},{3,80},{4,80}]};

get_by_id_order(305029,2) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 2,attr_list = [{1,320},{2,6400},{3,160},{4,160}]};

get_by_id_order(305029,3) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 3,attr_list = [{1,480},{2,9600},{3,240},{4,240}]};

get_by_id_order(305029,4) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 4,attr_list = [{1,640},{2,12800},{3,320},{4,320}]};

get_by_id_order(305029,5) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 5,attr_list = [{1,800},{2,16000},{3,400},{4,400}]};

get_by_id_order(305029,6) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 6,attr_list = [{1,960},{2,19200},{3,480},{4,480}]};

get_by_id_order(305029,7) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 7,attr_list = [{1,1120},{2,22400},{3,560},{4,560}]};

get_by_id_order(305029,8) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 8,attr_list = [{1,1280},{2,25600},{3,640},{4,640}]};

get_by_id_order(305029,9) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 9,attr_list = [{1,1440},{2,28800},{3,720},{4,720}]};

get_by_id_order(305029,10) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 10,attr_list = [{1,1600},{2,32000},{3,800},{4,800}]};

get_by_id_order(305029,11) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 11,attr_list = [{1,1760},{2,35200},{3,880},{4,880}]};

get_by_id_order(305029,12) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 12,attr_list = [{1,1920},{2,38400},{3,960},{4,960}]};

get_by_id_order(305029,13) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 13,attr_list = [{1,2080},{2,41600},{3,1040},{4,1040}]};

get_by_id_order(305029,14) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 14,attr_list = [{1,2240},{2,44800},{3,1120},{4,1120}]};

get_by_id_order(305029,15) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 15,attr_list = [{1,2400},{2,48000},{3,1200},{4,1200}]};

get_by_id_order(305029,16) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 16,attr_list = [{1,2560},{2,51200},{3,1280},{4,1280}]};

get_by_id_order(305029,17) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 17,attr_list = [{1,2720},{2,54400},{3,1360},{4,1360}]};

get_by_id_order(305029,18) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 18,attr_list = [{1,2880},{2,57600},{3,1440},{4,1440}]};

get_by_id_order(305029,19) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 19,attr_list = [{1,3040},{2,60800},{3,1520},{4,1520}]};

get_by_id_order(305029,20) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 20,attr_list = [{1,3200},{2,64000},{3,1600},{4,1600}]};

get_by_id_order(305029,21) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 21,attr_list = [{1,3360},{2,67200},{3,1680},{4,1680}]};

get_by_id_order(305029,22) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 22,attr_list = [{1,3520},{2,70400},{3,1760},{4,1760}]};

get_by_id_order(305029,23) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 23,attr_list = [{1,3680},{2,73600},{3,1840},{4,1840}]};

get_by_id_order(305029,24) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 24,attr_list = [{1,3840},{2,76800},{3,1920},{4,1920}]};

get_by_id_order(305029,25) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 25,attr_list = [{1,4000},{2,80000},{3,2000},{4,2000}]};

get_by_id_order(305029,26) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 26,attr_list = [{1,4160},{2,83200},{3,2080},{4,2080}]};

get_by_id_order(305029,27) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 27,attr_list = [{1,4320},{2,86400},{3,2160},{4,2160}]};

get_by_id_order(305029,28) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 28,attr_list = [{1,4480},{2,89600},{3,2240},{4,2240}]};

get_by_id_order(305029,29) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 29,attr_list = [{1,4640},{2,92800},{3,2320},{4,2320}]};

get_by_id_order(305029,30) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 30,attr_list = [{1,4800},{2,96000},{3,2400},{4,2400}]};

get_by_id_order(305029,31) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 31,attr_list = [{1,4960},{2,99200},{3,2480},{4,2480}]};

get_by_id_order(305029,32) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 32,attr_list = [{1,5120},{2,102400},{3,2560},{4,2560}]};

get_by_id_order(305029,33) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 33,attr_list = [{1,5280},{2,105600},{3,2640},{4,2640}]};

get_by_id_order(305029,34) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 34,attr_list = [{1,5440},{2,108800},{3,2720},{4,2720}]};

get_by_id_order(305029,35) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 35,attr_list = [{1,5600},{2,112000},{3,2800},{4,2800}]};

get_by_id_order(305029,36) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 36,attr_list = [{1,5760},{2,115200},{3,2880},{4,2880}]};

get_by_id_order(305029,37) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 37,attr_list = [{1,5920},{2,118400},{3,2960},{4,2960}]};

get_by_id_order(305029,38) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 38,attr_list = [{1,6080},{2,121600},{3,3040},{4,3040}]};

get_by_id_order(305029,39) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 39,attr_list = [{1,6240},{2,124800},{3,3120},{4,3120}]};

get_by_id_order(305029,40) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 40,attr_list = [{1,6400},{2,128000},{3,3200},{4,3200}]};

get_by_id_order(305029,41) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 41,attr_list = [{1,6560},{2,131200},{3,3280},{4,3280}]};

get_by_id_order(305029,42) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 42,attr_list = [{1,6720},{2,134400},{3,3360},{4,3360}]};

get_by_id_order(305029,43) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 43,attr_list = [{1,6880},{2,137600},{3,3440},{4,3440}]};

get_by_id_order(305029,44) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 44,attr_list = [{1,7040},{2,140800},{3,3520},{4,3520}]};

get_by_id_order(305029,45) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 45,attr_list = [{1,7200},{2,144000},{3,3600},{4,3600}]};

get_by_id_order(305029,46) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 46,attr_list = [{1,7360},{2,147200},{3,3680},{4,3680}]};

get_by_id_order(305029,47) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 47,attr_list = [{1,7520},{2,150400},{3,3760},{4,3760}]};

get_by_id_order(305029,48) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 48,attr_list = [{1,7680},{2,153600},{3,3840},{4,3840}]};

get_by_id_order(305029,49) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 49,attr_list = [{1,7840},{2,156800},{3,3920},{4,3920}]};

get_by_id_order(305029,50) ->
	#base_dsgt_order{dsgt_id = 305029,consume = [{0,38065026,1}],dsgt_order = 50,attr_list = [{1,8000},{2,160000},{3,4000},{4,4000}]};

get_by_id_order(305031,1) ->
	#base_dsgt_order{dsgt_id = 305031,consume = [{0,38065028,1}],dsgt_order = 1,attr_list = [{1,500},{2,10000}]};

get_by_id_order(305031,2) ->
	#base_dsgt_order{dsgt_id = 305031,consume = [{0,38065028,1}],dsgt_order = 2,attr_list = [{1,1000},{2,20000}]};

get_by_id_order(305031,3) ->
	#base_dsgt_order{dsgt_id = 305031,consume = [{0,38065028,1}],dsgt_order = 3,attr_list = [{1,1500},{2,30000}]};

get_by_id_order(305031,4) ->
	#base_dsgt_order{dsgt_id = 305031,consume = [{0,38065028,1}],dsgt_order = 4,attr_list = [{1,2000},{2,40000}]};

get_by_id_order(305031,5) ->
	#base_dsgt_order{dsgt_id = 305031,consume = [{0,38065028,1}],dsgt_order = 5,attr_list = [{1,2500},{2,50000}]};

get_by_id_order(305090,1) ->
	#base_dsgt_order{dsgt_id = 305090,consume = [{0,38065090,1}],dsgt_order = 1,attr_list = [{1,300},{4,150},{3,150}]};

get_by_id_order(305090,2) ->
	#base_dsgt_order{dsgt_id = 305090,consume = [{0,38065090,1}],dsgt_order = 2,attr_list = [{1,600},{4,300},{3,300}]};

get_by_id_order(305090,3) ->
	#base_dsgt_order{dsgt_id = 305090,consume = [{0,38065090,1}],dsgt_order = 3,attr_list = [{1,900},{4,450},{3,450}]};

get_by_id_order(305090,4) ->
	#base_dsgt_order{dsgt_id = 305090,consume = [{0,38065090,1}],dsgt_order = 4,attr_list = [{1,1200},{4,600},{3,600}]};

get_by_id_order(305090,5) ->
	#base_dsgt_order{dsgt_id = 305090,consume = [{0,38065090,1}],dsgt_order = 5,attr_list = [{1,1500},{4,750},{3,750}]};

get_by_id_order(305091,1) ->
	#base_dsgt_order{dsgt_id = 305091,consume = [{0,38065091,1}],dsgt_order = 1,attr_list = [{1,350},{4,175},{3,175}]};

get_by_id_order(305091,2) ->
	#base_dsgt_order{dsgt_id = 305091,consume = [{0,38065091,1}],dsgt_order = 2,attr_list = [{1,700},{4,350},{3,350}]};

get_by_id_order(305091,3) ->
	#base_dsgt_order{dsgt_id = 305091,consume = [{0,38065091,1}],dsgt_order = 3,attr_list = [{1,1050},{4,525},{3,525}]};

get_by_id_order(305091,4) ->
	#base_dsgt_order{dsgt_id = 305091,consume = [{0,38065091,1}],dsgt_order = 4,attr_list = [{1,1400},{4,700},{3,700}]};

get_by_id_order(305091,5) ->
	#base_dsgt_order{dsgt_id = 305091,consume = [{0,38065091,1}],dsgt_order = 5,attr_list = [{1,1750},{4,875},{3,875}]};

get_by_id_order(305092,1) ->
	#base_dsgt_order{dsgt_id = 305092,consume = [{0,38065092,1}],dsgt_order = 1,attr_list = [{1,450},{4,225},{3,225},{17,100}]};

get_by_id_order(305092,2) ->
	#base_dsgt_order{dsgt_id = 305092,consume = [{0,38065092,1}],dsgt_order = 2,attr_list = [{1,900},{4,450},{3,450},{17,200}]};

get_by_id_order(305092,3) ->
	#base_dsgt_order{dsgt_id = 305092,consume = [{0,38065092,1}],dsgt_order = 3,attr_list = [{1,1350},{4,675},{3,675},{17,300}]};

get_by_id_order(305092,4) ->
	#base_dsgt_order{dsgt_id = 305092,consume = [{0,38065092,1}],dsgt_order = 4,attr_list = [{1,1800},{4,900},{3,900},{17,400}]};

get_by_id_order(305092,5) ->
	#base_dsgt_order{dsgt_id = 305092,consume = [{0,38065092,1}],dsgt_order = 5,attr_list = [{1,2250},{4,1125},{3,1125},{17,500}]};

get_by_id_order(305093,1) ->
	#base_dsgt_order{dsgt_id = 305093,consume = [{0,38065093,1}],dsgt_order = 1,attr_list = [{1,300},{4,150},{3,150}]};

get_by_id_order(305093,2) ->
	#base_dsgt_order{dsgt_id = 305093,consume = [{0,38065093,1}],dsgt_order = 2,attr_list = [{1,600},{4,300},{3,300}]};

get_by_id_order(305093,3) ->
	#base_dsgt_order{dsgt_id = 305093,consume = [{0,38065093,1}],dsgt_order = 3,attr_list = [{1,900},{4,450},{3,450}]};

get_by_id_order(305093,4) ->
	#base_dsgt_order{dsgt_id = 305093,consume = [{0,38065093,1}],dsgt_order = 4,attr_list = [{1,1200},{4,600},{3,600}]};

get_by_id_order(305093,5) ->
	#base_dsgt_order{dsgt_id = 305093,consume = [{0,38065093,1}],dsgt_order = 5,attr_list = [{1,1500},{4,750},{3,750}]};

get_by_id_order(305094,1) ->
	#base_dsgt_order{dsgt_id = 305094,consume = [{0,38065094,1}],dsgt_order = 1,attr_list = [{1,350},{4,175},{3,175}]};

get_by_id_order(305094,2) ->
	#base_dsgt_order{dsgt_id = 305094,consume = [{0,38065094,1}],dsgt_order = 2,attr_list = [{1,700},{4,350},{3,350}]};

get_by_id_order(305094,3) ->
	#base_dsgt_order{dsgt_id = 305094,consume = [{0,38065094,1}],dsgt_order = 3,attr_list = [{1,1050},{4,525},{3,525}]};

get_by_id_order(305094,4) ->
	#base_dsgt_order{dsgt_id = 305094,consume = [{0,38065094,1}],dsgt_order = 4,attr_list = [{1,1400},{4,700},{3,700}]};

get_by_id_order(305094,5) ->
	#base_dsgt_order{dsgt_id = 305094,consume = [{0,38065094,1}],dsgt_order = 5,attr_list = [{1,1750},{4,875},{3,875}]};

get_by_id_order(305095,1) ->
	#base_dsgt_order{dsgt_id = 305095,consume = [{0,38065095,1}],dsgt_order = 1,attr_list = [{1,450},{4,225},{3,225},{17,100}]};

get_by_id_order(305095,2) ->
	#base_dsgt_order{dsgt_id = 305095,consume = [{0,38065095,1}],dsgt_order = 2,attr_list = [{1,900},{4,450},{3,450},{17,200}]};

get_by_id_order(305095,3) ->
	#base_dsgt_order{dsgt_id = 305095,consume = [{0,38065095,1}],dsgt_order = 3,attr_list = [{1,1350},{4,675},{3,675},{17,300}]};

get_by_id_order(305095,4) ->
	#base_dsgt_order{dsgt_id = 305095,consume = [{0,38065095,1}],dsgt_order = 4,attr_list = [{1,1800},{4,900},{3,900},{17,400}]};

get_by_id_order(305095,5) ->
	#base_dsgt_order{dsgt_id = 305095,consume = [{0,38065095,1}],dsgt_order = 5,attr_list = [{1,2250},{4,1125},{3,1125},{17,500}]};

get_by_id_order(305096,1) ->
	#base_dsgt_order{dsgt_id = 305096,consume = [{0,38065096,1}],dsgt_order = 1,attr_list = [{1,600},{2,12000},{3,300},{17,100}]};

get_by_id_order(305096,2) ->
	#base_dsgt_order{dsgt_id = 305096,consume = [{0,38065096,1}],dsgt_order = 2,attr_list = [{1,1200},{2,24000},{3,600},{17,200}]};

get_by_id_order(305096,3) ->
	#base_dsgt_order{dsgt_id = 305096,consume = [{0,38065096,1}],dsgt_order = 3,attr_list = [{1,1800},{2,36000},{3,900},{17,300}]};

get_by_id_order(305096,4) ->
	#base_dsgt_order{dsgt_id = 305096,consume = [{0,38065096,1}],dsgt_order = 4,attr_list = [{1,2400},{2,48000},{3,1200},{17,400}]};

get_by_id_order(305096,5) ->
	#base_dsgt_order{dsgt_id = 305096,consume = [{0,38065096,1}],dsgt_order = 5,attr_list = [{1,3000},{2,60000},{3,1500},{17,500}]};

get_by_id_order(305101,1) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{3,75},{4,75}]};

get_by_id_order(305101,2) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{3,150},{4,150}]};

get_by_id_order(305101,3) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{3,225},{4,225}]};

get_by_id_order(305101,4) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{3,300},{4,300}]};

get_by_id_order(305101,5) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{3,375},{4,375}]};

get_by_id_order(305101,6) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{3,450},{4,450}]};

get_by_id_order(305101,7) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{3,525},{4,525}]};

get_by_id_order(305101,8) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{3,600},{4,600}]};

get_by_id_order(305101,9) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{3,675},{4,675}]};

get_by_id_order(305101,10) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{3,750},{4,750}]};

get_by_id_order(305101,11) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{3,825},{4,825}]};

get_by_id_order(305101,12) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{3,900},{4,900}]};

get_by_id_order(305101,13) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{3,975},{4,975}]};

get_by_id_order(305101,14) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{3,1050},{4,1050}]};

get_by_id_order(305101,15) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{3,1125},{4,1125}]};

get_by_id_order(305101,16) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{3,1200},{4,1200}]};

get_by_id_order(305101,17) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{3,1275},{4,1275}]};

get_by_id_order(305101,18) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{3,1350},{4,1350}]};

get_by_id_order(305101,19) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{3,1425},{4,1425}]};

get_by_id_order(305101,20) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{3,1500},{4,1500}]};

get_by_id_order(305101,21) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{3,1575},{4,1575}]};

get_by_id_order(305101,22) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{3,1650},{4,1650}]};

get_by_id_order(305101,23) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{3,1725},{4,1725}]};

get_by_id_order(305101,24) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{3,1800},{4,1800}]};

get_by_id_order(305101,25) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{3,1875},{4,1875}]};

get_by_id_order(305101,26) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{3,1950},{4,1950}]};

get_by_id_order(305101,27) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{3,2025},{4,2025}]};

get_by_id_order(305101,28) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{3,2100},{4,2100}]};

get_by_id_order(305101,29) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{3,2175},{4,2175}]};

get_by_id_order(305101,30) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{3,2250},{4,2250}]};

get_by_id_order(305101,31) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{3,2325},{4,2325}]};

get_by_id_order(305101,32) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{3,2400},{4,2400}]};

get_by_id_order(305101,33) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{3,2475},{4,2475}]};

get_by_id_order(305101,34) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{3,2550},{4,2550}]};

get_by_id_order(305101,35) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{3,2625},{4,2625}]};

get_by_id_order(305101,36) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{3,2700},{4,2700}]};

get_by_id_order(305101,37) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{3,2775},{4,2775}]};

get_by_id_order(305101,38) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{3,2850},{4,2850}]};

get_by_id_order(305101,39) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{3,2925},{4,2925}]};

get_by_id_order(305101,40) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{3,3000},{4,3000}]};

get_by_id_order(305101,41) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{3,3075},{4,3075}]};

get_by_id_order(305101,42) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{3,3150},{4,3150}]};

get_by_id_order(305101,43) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{3,3225},{4,3225}]};

get_by_id_order(305101,44) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{3,3300},{4,3300}]};

get_by_id_order(305101,45) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{3,3375},{4,3375}]};

get_by_id_order(305101,46) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{3,3450},{4,3450}]};

get_by_id_order(305101,47) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{3,3525},{4,3525}]};

get_by_id_order(305101,48) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{3,3600},{4,3600}]};

get_by_id_order(305101,49) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{3,3675},{4,3675}]};

get_by_id_order(305101,50) ->
	#base_dsgt_order{dsgt_id = 305101,consume = [{0,38065101,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{3,3750},{4,3750}]};

get_by_id_order(305102,1) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{3,90},{4,90}]};

get_by_id_order(305102,2) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{3,180},{4,180}]};

get_by_id_order(305102,3) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{3,270},{4,270}]};

get_by_id_order(305102,4) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{3,360},{4,360}]};

get_by_id_order(305102,5) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{3,450},{4,450}]};

get_by_id_order(305102,6) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{3,540},{4,540}]};

get_by_id_order(305102,7) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{3,630},{4,630}]};

get_by_id_order(305102,8) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{3,720},{4,720}]};

get_by_id_order(305102,9) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{3,810},{4,810}]};

get_by_id_order(305102,10) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{3,900},{4,900}]};

get_by_id_order(305102,11) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{3,990},{4,990}]};

get_by_id_order(305102,12) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{3,1080},{4,1080}]};

get_by_id_order(305102,13) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{3,1170},{4,1170}]};

get_by_id_order(305102,14) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{3,1260},{4,1260}]};

get_by_id_order(305102,15) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{3,1350},{4,1350}]};

get_by_id_order(305102,16) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{3,1440},{4,1440}]};

get_by_id_order(305102,17) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{3,1530},{4,1530}]};

get_by_id_order(305102,18) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{3,1620},{4,1620}]};

get_by_id_order(305102,19) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{3,1710},{4,1710}]};

get_by_id_order(305102,20) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{3,1800},{4,1800}]};

get_by_id_order(305102,21) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{3,1890},{4,1890}]};

get_by_id_order(305102,22) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{3,1980},{4,1980}]};

get_by_id_order(305102,23) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{3,2070},{4,2070}]};

get_by_id_order(305102,24) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{3,2160},{4,2160}]};

get_by_id_order(305102,25) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{3,2250},{4,2250}]};

get_by_id_order(305102,26) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{3,2340},{4,2340}]};

get_by_id_order(305102,27) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{3,2430},{4,2430}]};

get_by_id_order(305102,28) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{3,2520},{4,2520}]};

get_by_id_order(305102,29) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{3,2610},{4,2610}]};

get_by_id_order(305102,30) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{3,2700},{4,2700}]};

get_by_id_order(305102,31) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{3,2790},{4,2790}]};

get_by_id_order(305102,32) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{3,2880},{4,2880}]};

get_by_id_order(305102,33) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{3,2970},{4,2970}]};

get_by_id_order(305102,34) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{3,3060},{4,3060}]};

get_by_id_order(305102,35) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{3,3150},{4,3150}]};

get_by_id_order(305102,36) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{3,3240},{4,3240}]};

get_by_id_order(305102,37) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{3,3330},{4,3330}]};

get_by_id_order(305102,38) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{3,3420},{4,3420}]};

get_by_id_order(305102,39) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{3,3510},{4,3510}]};

get_by_id_order(305102,40) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{3,3600},{4,3600}]};

get_by_id_order(305102,41) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{3,3690},{4,3690}]};

get_by_id_order(305102,42) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{3,3780},{4,3780}]};

get_by_id_order(305102,43) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{3,3870},{4,3870}]};

get_by_id_order(305102,44) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{3,3960},{4,3960}]};

get_by_id_order(305102,45) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{3,4050},{4,4050}]};

get_by_id_order(305102,46) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{3,4140},{4,4140}]};

get_by_id_order(305102,47) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{3,4230},{4,4230}]};

get_by_id_order(305102,48) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{3,4320},{4,4320}]};

get_by_id_order(305102,49) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{3,4410},{4,4410}]};

get_by_id_order(305102,50) ->
	#base_dsgt_order{dsgt_id = 305102,consume = [{0,38065102,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{3,4500},{4,4500}]};

get_by_id_order(305103,1) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{3,120},{4,120}]};

get_by_id_order(305103,2) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{3,240},{4,240}]};

get_by_id_order(305103,3) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{3,360},{4,360}]};

get_by_id_order(305103,4) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{3,480},{4,480}]};

get_by_id_order(305103,5) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{3,600},{4,600}]};

get_by_id_order(305103,6) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{3,720},{4,720}]};

get_by_id_order(305103,7) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{3,840},{4,840}]};

get_by_id_order(305103,8) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{3,960},{4,960}]};

get_by_id_order(305103,9) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{3,1080},{4,1080}]};

get_by_id_order(305103,10) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{3,1200},{4,1200}]};

get_by_id_order(305103,11) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{3,1320},{4,1320}]};

get_by_id_order(305103,12) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{3,1440},{4,1440}]};

get_by_id_order(305103,13) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{3,1560},{4,1560}]};

get_by_id_order(305103,14) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{3,1680},{4,1680}]};

get_by_id_order(305103,15) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{3,1800},{4,1800}]};

get_by_id_order(305103,16) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{3,1920},{4,1920}]};

get_by_id_order(305103,17) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{3,2040},{4,2040}]};

get_by_id_order(305103,18) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{3,2160},{4,2160}]};

get_by_id_order(305103,19) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{3,2280},{4,2280}]};

get_by_id_order(305103,20) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{3,2400},{4,2400}]};

get_by_id_order(305103,21) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{3,2520},{4,2520}]};

get_by_id_order(305103,22) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{3,2640},{4,2640}]};

get_by_id_order(305103,23) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{3,2760},{4,2760}]};

get_by_id_order(305103,24) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{3,2880},{4,2880}]};

get_by_id_order(305103,25) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{3,3000},{4,3000}]};

get_by_id_order(305103,26) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{3,3120},{4,3120}]};

get_by_id_order(305103,27) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{3,3240},{4,3240}]};

get_by_id_order(305103,28) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{3,3360},{4,3360}]};

get_by_id_order(305103,29) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{3,3480},{4,3480}]};

get_by_id_order(305103,30) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{3,3600},{4,3600}]};

get_by_id_order(305103,31) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{3,3720},{4,3720}]};

get_by_id_order(305103,32) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{3,3840},{4,3840}]};

get_by_id_order(305103,33) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{3,3960},{4,3960}]};

get_by_id_order(305103,34) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{3,4080},{4,4080}]};

get_by_id_order(305103,35) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{3,4200},{4,4200}]};

get_by_id_order(305103,36) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{3,4320},{4,4320}]};

get_by_id_order(305103,37) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{3,4440},{4,4440}]};

get_by_id_order(305103,38) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{3,4560},{4,4560}]};

get_by_id_order(305103,39) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{3,4680},{4,4680}]};

get_by_id_order(305103,40) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{3,4800},{4,4800}]};

get_by_id_order(305103,41) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{3,4920},{4,4920}]};

get_by_id_order(305103,42) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{3,5040},{4,5040}]};

get_by_id_order(305103,43) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{3,5160},{4,5160}]};

get_by_id_order(305103,44) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{3,5280},{4,5280}]};

get_by_id_order(305103,45) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{3,5400},{4,5400}]};

get_by_id_order(305103,46) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{3,5520},{4,5520}]};

get_by_id_order(305103,47) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{3,5640},{4,5640}]};

get_by_id_order(305103,48) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{3,5760},{4,5760}]};

get_by_id_order(305103,49) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{3,5880},{4,5880}]};

get_by_id_order(305103,50) ->
	#base_dsgt_order{dsgt_id = 305103,consume = [{0,38065103,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{3,6000},{4,6000}]};

get_by_id_order(305146,1) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305146,2) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305146,3) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305146,4) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305146,5) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305146,6) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305146,7) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305146,8) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305146,9) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305146,10) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305146,11) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305146,12) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305146,13) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305146,14) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305146,15) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305146,16) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305146,17) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305146,18) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305146,19) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305146,20) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305146,21) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305146,22) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305146,23) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305146,24) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305146,25) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305146,26) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305146,27) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305146,28) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305146,29) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305146,30) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305146,31) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305146,32) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305146,33) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305146,34) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305146,35) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305146,36) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305146,37) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305146,38) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305146,39) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305146,40) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305146,41) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305146,42) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305146,43) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305146,44) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305146,45) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305146,46) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305146,47) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305146,48) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305146,49) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305146,50) ->
	#base_dsgt_order{dsgt_id = 305146,consume = [{0,38065146,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305147,1) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305147,2) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305147,3) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305147,4) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305147,5) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305147,6) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305147,7) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305147,8) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305147,9) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305147,10) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305147,11) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305147,12) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305147,13) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305147,14) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305147,15) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305147,16) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305147,17) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305147,18) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305147,19) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305147,20) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305147,21) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305147,22) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305147,23) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305147,24) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305147,25) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305147,26) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305147,27) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305147,28) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305147,29) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305147,30) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305147,31) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305147,32) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305147,33) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305147,34) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305147,35) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305147,36) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305147,37) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305147,38) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305147,39) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305147,40) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305147,41) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305147,42) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305147,43) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305147,44) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305147,45) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305147,46) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305147,47) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305147,48) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305147,49) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305147,50) ->
	#base_dsgt_order{dsgt_id = 305147,consume = [{0,38065147,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305148,1) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305148,2) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305148,3) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305148,4) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305148,5) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305148,6) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305148,7) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305148,8) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305148,9) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305148,10) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305148,11) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305148,12) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305148,13) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305148,14) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305148,15) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305148,16) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305148,17) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305148,18) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305148,19) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305148,20) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305148,21) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305148,22) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305148,23) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305148,24) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305148,25) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305148,26) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305148,27) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305148,28) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305148,29) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305148,30) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305148,31) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305148,32) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305148,33) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305148,34) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305148,35) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305148,36) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305148,37) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305148,38) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305148,39) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305148,40) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305148,41) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305148,42) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305148,43) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305148,44) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305148,45) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305148,46) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305148,47) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305148,48) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305148,49) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305148,50) ->
	#base_dsgt_order{dsgt_id = 305148,consume = [{0,38065148,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305149,1) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305149,2) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305149,3) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305149,4) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305149,5) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305149,6) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305149,7) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305149,8) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305149,9) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305149,10) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305149,11) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305149,12) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305149,13) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305149,14) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305149,15) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305149,16) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305149,17) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305149,18) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305149,19) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305149,20) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305149,21) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305149,22) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305149,23) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305149,24) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305149,25) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305149,26) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305149,27) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305149,28) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305149,29) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305149,30) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305149,31) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305149,32) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305149,33) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305149,34) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305149,35) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305149,36) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305149,37) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305149,38) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305149,39) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305149,40) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305149,41) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305149,42) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305149,43) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305149,44) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305149,45) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305149,46) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305149,47) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305149,48) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305149,49) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305149,50) ->
	#base_dsgt_order{dsgt_id = 305149,consume = [{0,38065149,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305150,1) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305150,2) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305150,3) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305150,4) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305150,5) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305150,6) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305150,7) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305150,8) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305150,9) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305150,10) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305150,11) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305150,12) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305150,13) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305150,14) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305150,15) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305150,16) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305150,17) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305150,18) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305150,19) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305150,20) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305150,21) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305150,22) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305150,23) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305150,24) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305150,25) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305150,26) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305150,27) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305150,28) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305150,29) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305150,30) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305150,31) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305150,32) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305150,33) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305150,34) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305150,35) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305150,36) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305150,37) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305150,38) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305150,39) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305150,40) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305150,41) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305150,42) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305150,43) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305150,44) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305150,45) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305150,46) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305150,47) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305150,48) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305150,49) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305150,50) ->
	#base_dsgt_order{dsgt_id = 305150,consume = [{0,38065150,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305151,1) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305151,2) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305151,3) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305151,4) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305151,5) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305151,6) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305151,7) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305151,8) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305151,9) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305151,10) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305151,11) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305151,12) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305151,13) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305151,14) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305151,15) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305151,16) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305151,17) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305151,18) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305151,19) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305151,20) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305151,21) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305151,22) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305151,23) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305151,24) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305151,25) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305151,26) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305151,27) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305151,28) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305151,29) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305151,30) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305151,31) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305151,32) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305151,33) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305151,34) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305151,35) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305151,36) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305151,37) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305151,38) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305151,39) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305151,40) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305151,41) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305151,42) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305151,43) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305151,44) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305151,45) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305151,46) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305151,47) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305151,48) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305151,49) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305151,50) ->
	#base_dsgt_order{dsgt_id = 305151,consume = [{0,38065151,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305152,1) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305152,2) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305152,3) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305152,4) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305152,5) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305152,6) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305152,7) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305152,8) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305152,9) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305152,10) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305152,11) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305152,12) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305152,13) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305152,14) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305152,15) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305152,16) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305152,17) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305152,18) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305152,19) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305152,20) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305152,21) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305152,22) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305152,23) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305152,24) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305152,25) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305152,26) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305152,27) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305152,28) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305152,29) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305152,30) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305152,31) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305152,32) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305152,33) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305152,34) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305152,35) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305152,36) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305152,37) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305152,38) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305152,39) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305152,40) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305152,41) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305152,42) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305152,43) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305152,44) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305152,45) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305152,46) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305152,47) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305152,48) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305152,49) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305152,50) ->
	#base_dsgt_order{dsgt_id = 305152,consume = [{0,38065152,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305153,1) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305153,2) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305153,3) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305153,4) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305153,5) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305153,6) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305153,7) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305153,8) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305153,9) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305153,10) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305153,11) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305153,12) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305153,13) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305153,14) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305153,15) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305153,16) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305153,17) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305153,18) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305153,19) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305153,20) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305153,21) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305153,22) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305153,23) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305153,24) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305153,25) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305153,26) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305153,27) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305153,28) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305153,29) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305153,30) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305153,31) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305153,32) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305153,33) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305153,34) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305153,35) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305153,36) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305153,37) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305153,38) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305153,39) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305153,40) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305153,41) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305153,42) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305153,43) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305153,44) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305153,45) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305153,46) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305153,47) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305153,48) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305153,49) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305153,50) ->
	#base_dsgt_order{dsgt_id = 305153,consume = [{0,38065153,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305154,1) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305154,2) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305154,3) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305154,4) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305154,5) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305154,6) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305154,7) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305154,8) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305154,9) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305154,10) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305154,11) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305154,12) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305154,13) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305154,14) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305154,15) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305154,16) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305154,17) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305154,18) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305154,19) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305154,20) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305154,21) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305154,22) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305154,23) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305154,24) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305154,25) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305154,26) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305154,27) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305154,28) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305154,29) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305154,30) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305154,31) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305154,32) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305154,33) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305154,34) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305154,35) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305154,36) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305154,37) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305154,38) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305154,39) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305154,40) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305154,41) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305154,42) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305154,43) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305154,44) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305154,45) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305154,46) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305154,47) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305154,48) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305154,49) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305154,50) ->
	#base_dsgt_order{dsgt_id = 305154,consume = [{0,38065154,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305155,1) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305155,2) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305155,3) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305155,4) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305155,5) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305155,6) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305155,7) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305155,8) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305155,9) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305155,10) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305155,11) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305155,12) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305155,13) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305155,14) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305155,15) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305155,16) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305155,17) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305155,18) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305155,19) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305155,20) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305155,21) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305155,22) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305155,23) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305155,24) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305155,25) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305155,26) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305155,27) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305155,28) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305155,29) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305155,30) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305155,31) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305155,32) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305155,33) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305155,34) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305155,35) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305155,36) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305155,37) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305155,38) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305155,39) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305155,40) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305155,41) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305155,42) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305155,43) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305155,44) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305155,45) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305155,46) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305155,47) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305155,48) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305155,49) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305155,50) ->
	#base_dsgt_order{dsgt_id = 305155,consume = [{0,38065155,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305156,1) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305156,2) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305156,3) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305156,4) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305156,5) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305156,6) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305156,7) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305156,8) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305156,9) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305156,10) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305156,11) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305156,12) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305156,13) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305156,14) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305156,15) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305156,16) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305156,17) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305156,18) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305156,19) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305156,20) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305156,21) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305156,22) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305156,23) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305156,24) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305156,25) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305156,26) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305156,27) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305156,28) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305156,29) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305156,30) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305156,31) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305156,32) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305156,33) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305156,34) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305156,35) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305156,36) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305156,37) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305156,38) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305156,39) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305156,40) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305156,41) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305156,42) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305156,43) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305156,44) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305156,45) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305156,46) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305156,47) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305156,48) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305156,49) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305156,50) ->
	#base_dsgt_order{dsgt_id = 305156,consume = [{0,38065156,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305157,1) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305157,2) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305157,3) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305157,4) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305157,5) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305157,6) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305157,7) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305157,8) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305157,9) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305157,10) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305157,11) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305157,12) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305157,13) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305157,14) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305157,15) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305157,16) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305157,17) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305157,18) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305157,19) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305157,20) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305157,21) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305157,22) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305157,23) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305157,24) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305157,25) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305157,26) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305157,27) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305157,28) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305157,29) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305157,30) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305157,31) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305157,32) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305157,33) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305157,34) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305157,35) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305157,36) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305157,37) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305157,38) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305157,39) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305157,40) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305157,41) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305157,42) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305157,43) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305157,44) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305157,45) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305157,46) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305157,47) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305157,48) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305157,49) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305157,50) ->
	#base_dsgt_order{dsgt_id = 305157,consume = [{0,38065157,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305158,1) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305158,2) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305158,3) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305158,4) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305158,5) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305158,6) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305158,7) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305158,8) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305158,9) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305158,10) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305158,11) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305158,12) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305158,13) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305158,14) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305158,15) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305158,16) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305158,17) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305158,18) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305158,19) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305158,20) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305158,21) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305158,22) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305158,23) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305158,24) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305158,25) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305158,26) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305158,27) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305158,28) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305158,29) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305158,30) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305158,31) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305158,32) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305158,33) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305158,34) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305158,35) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305158,36) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305158,37) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305158,38) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305158,39) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305158,40) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305158,41) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305158,42) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305158,43) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305158,44) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305158,45) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305158,46) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305158,47) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305158,48) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305158,49) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305158,50) ->
	#base_dsgt_order{dsgt_id = 305158,consume = [{0,38065158,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305159,1) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305159,2) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305159,3) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305159,4) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305159,5) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305159,6) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305159,7) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305159,8) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305159,9) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305159,10) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305159,11) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305159,12) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305159,13) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305159,14) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305159,15) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305159,16) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305159,17) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305159,18) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305159,19) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305159,20) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305159,21) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305159,22) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305159,23) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305159,24) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305159,25) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305159,26) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305159,27) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305159,28) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305159,29) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305159,30) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305159,31) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305159,32) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305159,33) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305159,34) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305159,35) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305159,36) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305159,37) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305159,38) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305159,39) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305159,40) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305159,41) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305159,42) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305159,43) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305159,44) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305159,45) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305159,46) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305159,47) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305159,48) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305159,49) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305159,50) ->
	#base_dsgt_order{dsgt_id = 305159,consume = [{0,38065159,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305160,1) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305160,2) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305160,3) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305160,4) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305160,5) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305160,6) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305160,7) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305160,8) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305160,9) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305160,10) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305160,11) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305160,12) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305160,13) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305160,14) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305160,15) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305160,16) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305160,17) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305160,18) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305160,19) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305160,20) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305160,21) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305160,22) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305160,23) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305160,24) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305160,25) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305160,26) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305160,27) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305160,28) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305160,29) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305160,30) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305160,31) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305160,32) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305160,33) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305160,34) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305160,35) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305160,36) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305160,37) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305160,38) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305160,39) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305160,40) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305160,41) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305160,42) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305160,43) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305160,44) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305160,45) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305160,46) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305160,47) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305160,48) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305160,49) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305160,50) ->
	#base_dsgt_order{dsgt_id = 305160,consume = [{0,38065160,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305161,1) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305161,2) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305161,3) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305161,4) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305161,5) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305161,6) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305161,7) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305161,8) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305161,9) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305161,10) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305161,11) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305161,12) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305161,13) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305161,14) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305161,15) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305161,16) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305161,17) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305161,18) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305161,19) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305161,20) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305161,21) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305161,22) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305161,23) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305161,24) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305161,25) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305161,26) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305161,27) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305161,28) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305161,29) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305161,30) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305161,31) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305161,32) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305161,33) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305161,34) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305161,35) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305161,36) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305161,37) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305161,38) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305161,39) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305161,40) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305161,41) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305161,42) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305161,43) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305161,44) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305161,45) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305161,46) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305161,47) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305161,48) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305161,49) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305161,50) ->
	#base_dsgt_order{dsgt_id = 305161,consume = [{0,38065161,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305162,1) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305162,2) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305162,3) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305162,4) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305162,5) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305162,6) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305162,7) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305162,8) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305162,9) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305162,10) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305162,11) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305162,12) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305162,13) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305162,14) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305162,15) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305162,16) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305162,17) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305162,18) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305162,19) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305162,20) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305162,21) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305162,22) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305162,23) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305162,24) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305162,25) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305162,26) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305162,27) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305162,28) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305162,29) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305162,30) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305162,31) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305162,32) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305162,33) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305162,34) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305162,35) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305162,36) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305162,37) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305162,38) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305162,39) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305162,40) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305162,41) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305162,42) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305162,43) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305162,44) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305162,45) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305162,46) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305162,47) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305162,48) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305162,49) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305162,50) ->
	#base_dsgt_order{dsgt_id = 305162,consume = [{0,38065162,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305163,1) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305163,2) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305163,3) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305163,4) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305163,5) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305163,6) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305163,7) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305163,8) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305163,9) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305163,10) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305163,11) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305163,12) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305163,13) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305163,14) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305163,15) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305163,16) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305163,17) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305163,18) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305163,19) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305163,20) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305163,21) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305163,22) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305163,23) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305163,24) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305163,25) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305163,26) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305163,27) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305163,28) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305163,29) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305163,30) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305163,31) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305163,32) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305163,33) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305163,34) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305163,35) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305163,36) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305163,37) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305163,38) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305163,39) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305163,40) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305163,41) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305163,42) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305163,43) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305163,44) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305163,45) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305163,46) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305163,47) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305163,48) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305163,49) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305163,50) ->
	#base_dsgt_order{dsgt_id = 305163,consume = [{0,38065163,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305164,1) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305164,2) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305164,3) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305164,4) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305164,5) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305164,6) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305164,7) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305164,8) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305164,9) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305164,10) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305164,11) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305164,12) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305164,13) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305164,14) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305164,15) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305164,16) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305164,17) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305164,18) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305164,19) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305164,20) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305164,21) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305164,22) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305164,23) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305164,24) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305164,25) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305164,26) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305164,27) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305164,28) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305164,29) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305164,30) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305164,31) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305164,32) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305164,33) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305164,34) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305164,35) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305164,36) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305164,37) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305164,38) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305164,39) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305164,40) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305164,41) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305164,42) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305164,43) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305164,44) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305164,45) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305164,46) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305164,47) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305164,48) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305164,49) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305164,50) ->
	#base_dsgt_order{dsgt_id = 305164,consume = [{0,38065164,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305165,1) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305165,2) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305165,3) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305165,4) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305165,5) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305165,6) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305165,7) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305165,8) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305165,9) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305165,10) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305165,11) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305165,12) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305165,13) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305165,14) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305165,15) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305165,16) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305165,17) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305165,18) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305165,19) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305165,20) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305165,21) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305165,22) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305165,23) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305165,24) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305165,25) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305165,26) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305165,27) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305165,28) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305165,29) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305165,30) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305165,31) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305165,32) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305165,33) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305165,34) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305165,35) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305165,36) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305165,37) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305165,38) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305165,39) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305165,40) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305165,41) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305165,42) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305165,43) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305165,44) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305165,45) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305165,46) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305165,47) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305165,48) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305165,49) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305165,50) ->
	#base_dsgt_order{dsgt_id = 305165,consume = [{0,38065165,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305166,1) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305166,2) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305166,3) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305166,4) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305166,5) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305166,6) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305166,7) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305166,8) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305166,9) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305166,10) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305166,11) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305166,12) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305166,13) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305166,14) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305166,15) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305166,16) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305166,17) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305166,18) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305166,19) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305166,20) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305166,21) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305166,22) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305166,23) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305166,24) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305166,25) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305166,26) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305166,27) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305166,28) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305166,29) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305166,30) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305166,31) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305166,32) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305166,33) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305166,34) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305166,35) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305166,36) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305166,37) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305166,38) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305166,39) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305166,40) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305166,41) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305166,42) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305166,43) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305166,44) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305166,45) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305166,46) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305166,47) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305166,48) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305166,49) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305166,50) ->
	#base_dsgt_order{dsgt_id = 305166,consume = [{0,38065166,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305167,1) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305167,2) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305167,3) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305167,4) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305167,5) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305167,6) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305167,7) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305167,8) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305167,9) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305167,10) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305167,11) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305167,12) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305167,13) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305167,14) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305167,15) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305167,16) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305167,17) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305167,18) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305167,19) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305167,20) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305167,21) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305167,22) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305167,23) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305167,24) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305167,25) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305167,26) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305167,27) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305167,28) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305167,29) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305167,30) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305167,31) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305167,32) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305167,33) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305167,34) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305167,35) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305167,36) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305167,37) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305167,38) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305167,39) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305167,40) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305167,41) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305167,42) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305167,43) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305167,44) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305167,45) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305167,46) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305167,47) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305167,48) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305167,49) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305167,50) ->
	#base_dsgt_order{dsgt_id = 305167,consume = [{0,38065167,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305168,1) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305168,2) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305168,3) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305168,4) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305168,5) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305168,6) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305168,7) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305168,8) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305168,9) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305168,10) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305168,11) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305168,12) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305168,13) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305168,14) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305168,15) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305168,16) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305168,17) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305168,18) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305168,19) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305168,20) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305168,21) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305168,22) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305168,23) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305168,24) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305168,25) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305168,26) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305168,27) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305168,28) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305168,29) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305168,30) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305168,31) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305168,32) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305168,33) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305168,34) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305168,35) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305168,36) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305168,37) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305168,38) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305168,39) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305168,40) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305168,41) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305168,42) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305168,43) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305168,44) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305168,45) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305168,46) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305168,47) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305168,48) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305168,49) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305168,50) ->
	#base_dsgt_order{dsgt_id = 305168,consume = [{0,38065168,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305169,1) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305169,2) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305169,3) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305169,4) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305169,5) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305169,6) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305169,7) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305169,8) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305169,9) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305169,10) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305169,11) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305169,12) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305169,13) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305169,14) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305169,15) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305169,16) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305169,17) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305169,18) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305169,19) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305169,20) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305169,21) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305169,22) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305169,23) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305169,24) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305169,25) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305169,26) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305169,27) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305169,28) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305169,29) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305169,30) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305169,31) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305169,32) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305169,33) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305169,34) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305169,35) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305169,36) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305169,37) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305169,38) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305169,39) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305169,40) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305169,41) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305169,42) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305169,43) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305169,44) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305169,45) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305169,46) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305169,47) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305169,48) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305169,49) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305169,50) ->
	#base_dsgt_order{dsgt_id = 305169,consume = [{0,38065169,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305176,1) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305176,2) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305176,3) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305176,4) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305176,5) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305176,6) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305176,7) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305176,8) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305176,9) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305176,10) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305176,11) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305176,12) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305176,13) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305176,14) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305176,15) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305176,16) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305176,17) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305176,18) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305176,19) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305176,20) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305176,21) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305176,22) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305176,23) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305176,24) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305176,25) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305176,26) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305176,27) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305176,28) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305176,29) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305176,30) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305176,31) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305176,32) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305176,33) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305176,34) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305176,35) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305176,36) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305176,37) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305176,38) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305176,39) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305176,40) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305176,41) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305176,42) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305176,43) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305176,44) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305176,45) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305176,46) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305176,47) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305176,48) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305176,49) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305176,50) ->
	#base_dsgt_order{dsgt_id = 305176,consume = [{0,38065176,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305177,1) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305177,2) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305177,3) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305177,4) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305177,5) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305177,6) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305177,7) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305177,8) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305177,9) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305177,10) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305177,11) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305177,12) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305177,13) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305177,14) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305177,15) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305177,16) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305177,17) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305177,18) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305177,19) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305177,20) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305177,21) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305177,22) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305177,23) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305177,24) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305177,25) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305177,26) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305177,27) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305177,28) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305177,29) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305177,30) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305177,31) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305177,32) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305177,33) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305177,34) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305177,35) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305177,36) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305177,37) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305177,38) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305177,39) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305177,40) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305177,41) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305177,42) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305177,43) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305177,44) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305177,45) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305177,46) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305177,47) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305177,48) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305177,49) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305177,50) ->
	#base_dsgt_order{dsgt_id = 305177,consume = [{0,38065177,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305178,1) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305178,2) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305178,3) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305178,4) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305178,5) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305178,6) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305178,7) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305178,8) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305178,9) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305178,10) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305178,11) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305178,12) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305178,13) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305178,14) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305178,15) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305178,16) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305178,17) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305178,18) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305178,19) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305178,20) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305178,21) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305178,22) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305178,23) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305178,24) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305178,25) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305178,26) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305178,27) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305178,28) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305178,29) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305178,30) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305178,31) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305178,32) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305178,33) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305178,34) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305178,35) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305178,36) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305178,37) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305178,38) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305178,39) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305178,40) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305178,41) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305178,42) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305178,43) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305178,44) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305178,45) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305178,46) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305178,47) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305178,48) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305178,49) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305178,50) ->
	#base_dsgt_order{dsgt_id = 305178,consume = [{0,38065178,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305179,1) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305179,2) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305179,3) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305179,4) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305179,5) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305179,6) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305179,7) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305179,8) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305179,9) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305179,10) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305179,11) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305179,12) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305179,13) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305179,14) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305179,15) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305179,16) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305179,17) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305179,18) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305179,19) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305179,20) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305179,21) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305179,22) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305179,23) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305179,24) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305179,25) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305179,26) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305179,27) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305179,28) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305179,29) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305179,30) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305179,31) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305179,32) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305179,33) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305179,34) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305179,35) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305179,36) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305179,37) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305179,38) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305179,39) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305179,40) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305179,41) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305179,42) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305179,43) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305179,44) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305179,45) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305179,46) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305179,47) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305179,48) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305179,49) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305179,50) ->
	#base_dsgt_order{dsgt_id = 305179,consume = [{0,38065179,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305180,1) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305180,2) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305180,3) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305180,4) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305180,5) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305180,6) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305180,7) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305180,8) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305180,9) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305180,10) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305180,11) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305180,12) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305180,13) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305180,14) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305180,15) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305180,16) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305180,17) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305180,18) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305180,19) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305180,20) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305180,21) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305180,22) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305180,23) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305180,24) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305180,25) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305180,26) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305180,27) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305180,28) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305180,29) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305180,30) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305180,31) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305180,32) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305180,33) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305180,34) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305180,35) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305180,36) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305180,37) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305180,38) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305180,39) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305180,40) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305180,41) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305180,42) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305180,43) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305180,44) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305180,45) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305180,46) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305180,47) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305180,48) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305180,49) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305180,50) ->
	#base_dsgt_order{dsgt_id = 305180,consume = [{0,38065180,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305181,1) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305181,2) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305181,3) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305181,4) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305181,5) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305181,6) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305181,7) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305181,8) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305181,9) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305181,10) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305181,11) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305181,12) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305181,13) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305181,14) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305181,15) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305181,16) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305181,17) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305181,18) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305181,19) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305181,20) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305181,21) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305181,22) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305181,23) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305181,24) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305181,25) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305181,26) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305181,27) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305181,28) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305181,29) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305181,30) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305181,31) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305181,32) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305181,33) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305181,34) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305181,35) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305181,36) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305181,37) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305181,38) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305181,39) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305181,40) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305181,41) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305181,42) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305181,43) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305181,44) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305181,45) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305181,46) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305181,47) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305181,48) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305181,49) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305181,50) ->
	#base_dsgt_order{dsgt_id = 305181,consume = [{0,38065181,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305182,1) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305182,2) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305182,3) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305182,4) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305182,5) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305182,6) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305182,7) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305182,8) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305182,9) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305182,10) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305182,11) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305182,12) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305182,13) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305182,14) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305182,15) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305182,16) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305182,17) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305182,18) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305182,19) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305182,20) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305182,21) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305182,22) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305182,23) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305182,24) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305182,25) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305182,26) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305182,27) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305182,28) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305182,29) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305182,30) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305182,31) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305182,32) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305182,33) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305182,34) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305182,35) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305182,36) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305182,37) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305182,38) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305182,39) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305182,40) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305182,41) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305182,42) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305182,43) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305182,44) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305182,45) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305182,46) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305182,47) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305182,48) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305182,49) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305182,50) ->
	#base_dsgt_order{dsgt_id = 305182,consume = [{0,38065182,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305183,1) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305183,2) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305183,3) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305183,4) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305183,5) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305183,6) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305183,7) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305183,8) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305183,9) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305183,10) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305183,11) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305183,12) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305183,13) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305183,14) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305183,15) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305183,16) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305183,17) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305183,18) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305183,19) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305183,20) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305183,21) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305183,22) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305183,23) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305183,24) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305183,25) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305183,26) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305183,27) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305183,28) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305183,29) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305183,30) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305183,31) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305183,32) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305183,33) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305183,34) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305183,35) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305183,36) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305183,37) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305183,38) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305183,39) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305183,40) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305183,41) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305183,42) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305183,43) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305183,44) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305183,45) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305183,46) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305183,47) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305183,48) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305183,49) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305183,50) ->
	#base_dsgt_order{dsgt_id = 305183,consume = [{0,38065183,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305184,1) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305184,2) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305184,3) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305184,4) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305184,5) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305184,6) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305184,7) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305184,8) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305184,9) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305184,10) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305184,11) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305184,12) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305184,13) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305184,14) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305184,15) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305184,16) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305184,17) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305184,18) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305184,19) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305184,20) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305184,21) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305184,22) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305184,23) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305184,24) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305184,25) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305184,26) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305184,27) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305184,28) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305184,29) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305184,30) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305184,31) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305184,32) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305184,33) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305184,34) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305184,35) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305184,36) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305184,37) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305184,38) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305184,39) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305184,40) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305184,41) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305184,42) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305184,43) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305184,44) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305184,45) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305184,46) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305184,47) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305184,48) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305184,49) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305184,50) ->
	#base_dsgt_order{dsgt_id = 305184,consume = [{0,38065184,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305185,1) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305185,2) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305185,3) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305185,4) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305185,5) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305185,6) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305185,7) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305185,8) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305185,9) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305185,10) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305185,11) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305185,12) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305185,13) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305185,14) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305185,15) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305185,16) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305185,17) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305185,18) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305185,19) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305185,20) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305185,21) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305185,22) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305185,23) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305185,24) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305185,25) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305185,26) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305185,27) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305185,28) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305185,29) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305185,30) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305185,31) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305185,32) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305185,33) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305185,34) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305185,35) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305185,36) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305185,37) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305185,38) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305185,39) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305185,40) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305185,41) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305185,42) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305185,43) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305185,44) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305185,45) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305185,46) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305185,47) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305185,48) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305185,49) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305185,50) ->
	#base_dsgt_order{dsgt_id = 305185,consume = [{0,38065185,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305186,1) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305186,2) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305186,3) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305186,4) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305186,5) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305186,6) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305186,7) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305186,8) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305186,9) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305186,10) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305186,11) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305186,12) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305186,13) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305186,14) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305186,15) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305186,16) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305186,17) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305186,18) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305186,19) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305186,20) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305186,21) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305186,22) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305186,23) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305186,24) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305186,25) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305186,26) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305186,27) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305186,28) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305186,29) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305186,30) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305186,31) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305186,32) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305186,33) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305186,34) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305186,35) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305186,36) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305186,37) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305186,38) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305186,39) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305186,40) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305186,41) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305186,42) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305186,43) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305186,44) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305186,45) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305186,46) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305186,47) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305186,48) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305186,49) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305186,50) ->
	#base_dsgt_order{dsgt_id = 305186,consume = [{0,38065186,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305187,1) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305187,2) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305187,3) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305187,4) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305187,5) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305187,6) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305187,7) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305187,8) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305187,9) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305187,10) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305187,11) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305187,12) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305187,13) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305187,14) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305187,15) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305187,16) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305187,17) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305187,18) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305187,19) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305187,20) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305187,21) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305187,22) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305187,23) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305187,24) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305187,25) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305187,26) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305187,27) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305187,28) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305187,29) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305187,30) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305187,31) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305187,32) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305187,33) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305187,34) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305187,35) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305187,36) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305187,37) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305187,38) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305187,39) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305187,40) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305187,41) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305187,42) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305187,43) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305187,44) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305187,45) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305187,46) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305187,47) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305187,48) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305187,49) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305187,50) ->
	#base_dsgt_order{dsgt_id = 305187,consume = [{0,38065187,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305188,1) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305188,2) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305188,3) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305188,4) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305188,5) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305188,6) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305188,7) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305188,8) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305188,9) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305188,10) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305188,11) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305188,12) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305188,13) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305188,14) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305188,15) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305188,16) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305188,17) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305188,18) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305188,19) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305188,20) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305188,21) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305188,22) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305188,23) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305188,24) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305188,25) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305188,26) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305188,27) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305188,28) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305188,29) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305188,30) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305188,31) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305188,32) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305188,33) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305188,34) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305188,35) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305188,36) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305188,37) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305188,38) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305188,39) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305188,40) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305188,41) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305188,42) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305188,43) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305188,44) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305188,45) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305188,46) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305188,47) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305188,48) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305188,49) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305188,50) ->
	#base_dsgt_order{dsgt_id = 305188,consume = [{0,38065188,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305189,1) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305189,2) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305189,3) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305189,4) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305189,5) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305189,6) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305189,7) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305189,8) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305189,9) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305189,10) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305189,11) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305189,12) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305189,13) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305189,14) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305189,15) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305189,16) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305189,17) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305189,18) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305189,19) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305189,20) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305189,21) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305189,22) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305189,23) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305189,24) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305189,25) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305189,26) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305189,27) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305189,28) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305189,29) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305189,30) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305189,31) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305189,32) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305189,33) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305189,34) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305189,35) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305189,36) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305189,37) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305189,38) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305189,39) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305189,40) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305189,41) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305189,42) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305189,43) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305189,44) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305189,45) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305189,46) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305189,47) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305189,48) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305189,49) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305189,50) ->
	#base_dsgt_order{dsgt_id = 305189,consume = [{0,38065189,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305190,1) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305190,2) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305190,3) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305190,4) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305190,5) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305190,6) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305190,7) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305190,8) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305190,9) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305190,10) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305190,11) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305190,12) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305190,13) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305190,14) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305190,15) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305190,16) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305190,17) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305190,18) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305190,19) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305190,20) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305190,21) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305190,22) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305190,23) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305190,24) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305190,25) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305190,26) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305190,27) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305190,28) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305190,29) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305190,30) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305190,31) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305190,32) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305190,33) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305190,34) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305190,35) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305190,36) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305190,37) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305190,38) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305190,39) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305190,40) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305190,41) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305190,42) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305190,43) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305190,44) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305190,45) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305190,46) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305190,47) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305190,48) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305190,49) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305190,50) ->
	#base_dsgt_order{dsgt_id = 305190,consume = [{0,38065190,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305191,1) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305191,2) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305191,3) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305191,4) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305191,5) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305191,6) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305191,7) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305191,8) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305191,9) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305191,10) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305191,11) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305191,12) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305191,13) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305191,14) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305191,15) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305191,16) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305191,17) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305191,18) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305191,19) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305191,20) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305191,21) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305191,22) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305191,23) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305191,24) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305191,25) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305191,26) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305191,27) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305191,28) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305191,29) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305191,30) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305191,31) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305191,32) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305191,33) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305191,34) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305191,35) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305191,36) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305191,37) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305191,38) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305191,39) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305191,40) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305191,41) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305191,42) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305191,43) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305191,44) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305191,45) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305191,46) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305191,47) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305191,48) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305191,49) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305191,50) ->
	#base_dsgt_order{dsgt_id = 305191,consume = [{0,38065191,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305192,1) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305192,2) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305192,3) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305192,4) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305192,5) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305192,6) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305192,7) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305192,8) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305192,9) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305192,10) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305192,11) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305192,12) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305192,13) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305192,14) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305192,15) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305192,16) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305192,17) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305192,18) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305192,19) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305192,20) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305192,21) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305192,22) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305192,23) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305192,24) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305192,25) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305192,26) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305192,27) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305192,28) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305192,29) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305192,30) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305192,31) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305192,32) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305192,33) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305192,34) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305192,35) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305192,36) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305192,37) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305192,38) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305192,39) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305192,40) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305192,41) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305192,42) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305192,43) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305192,44) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305192,45) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305192,46) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305192,47) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305192,48) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305192,49) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305192,50) ->
	#base_dsgt_order{dsgt_id = 305192,consume = [{0,38065192,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305193,1) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305193,2) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305193,3) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305193,4) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305193,5) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305193,6) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305193,7) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305193,8) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305193,9) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305193,10) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305193,11) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305193,12) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305193,13) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305193,14) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305193,15) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305193,16) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305193,17) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305193,18) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305193,19) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305193,20) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305193,21) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305193,22) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305193,23) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305193,24) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305193,25) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305193,26) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305193,27) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305193,28) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305193,29) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305193,30) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305193,31) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305193,32) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305193,33) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305193,34) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305193,35) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305193,36) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305193,37) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305193,38) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305193,39) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305193,40) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305193,41) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305193,42) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305193,43) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305193,44) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305193,45) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305193,46) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305193,47) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305193,48) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305193,49) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305193,50) ->
	#base_dsgt_order{dsgt_id = 305193,consume = [{0,38065193,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305194,1) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305194,2) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305194,3) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305194,4) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305194,5) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305194,6) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305194,7) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305194,8) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305194,9) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305194,10) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305194,11) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305194,12) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305194,13) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305194,14) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305194,15) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305194,16) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305194,17) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305194,18) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305194,19) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305194,20) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305194,21) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305194,22) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305194,23) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305194,24) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305194,25) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305194,26) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305194,27) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305194,28) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305194,29) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305194,30) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305194,31) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305194,32) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305194,33) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305194,34) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305194,35) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305194,36) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305194,37) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305194,38) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305194,39) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305194,40) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305194,41) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305194,42) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305194,43) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305194,44) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305194,45) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305194,46) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305194,47) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305194,48) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305194,49) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305194,50) ->
	#base_dsgt_order{dsgt_id = 305194,consume = [{0,38065194,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305195,1) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 1,attr_list = [{1,180},{2,3600},{4,90},{3,90}]};

get_by_id_order(305195,2) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 2,attr_list = [{1,360},{2,7200},{4,180},{3,180}]};

get_by_id_order(305195,3) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 3,attr_list = [{1,540},{2,10800},{4,270},{3,270}]};

get_by_id_order(305195,4) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 4,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305195,5) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 5,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305195,6) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 6,attr_list = [{1,1080},{2,21600},{4,540},{3,540}]};

get_by_id_order(305195,7) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 7,attr_list = [{1,1260},{2,25200},{4,630},{3,630}]};

get_by_id_order(305195,8) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 8,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305195,9) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 9,attr_list = [{1,1620},{2,32400},{4,810},{3,810}]};

get_by_id_order(305195,10) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 10,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305195,11) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 11,attr_list = [{1,1980},{2,39600},{4,990},{3,990}]};

get_by_id_order(305195,12) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 12,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305195,13) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 13,attr_list = [{1,2340},{2,46800},{4,1170},{3,1170}]};

get_by_id_order(305195,14) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 14,attr_list = [{1,2520},{2,50400},{4,1260},{3,1260}]};

get_by_id_order(305195,15) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 15,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305195,16) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 16,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305195,17) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 17,attr_list = [{1,3060},{2,61200},{4,1530},{3,1530}]};

get_by_id_order(305195,18) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 18,attr_list = [{1,3240},{2,64800},{4,1620},{3,1620}]};

get_by_id_order(305195,19) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 19,attr_list = [{1,3420},{2,68400},{4,1710},{3,1710}]};

get_by_id_order(305195,20) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 20,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305195,21) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 21,attr_list = [{1,3780},{2,75600},{4,1890},{3,1890}]};

get_by_id_order(305195,22) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 22,attr_list = [{1,3960},{2,79200},{4,1980},{3,1980}]};

get_by_id_order(305195,23) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 23,attr_list = [{1,4140},{2,82800},{4,2070},{3,2070}]};

get_by_id_order(305195,24) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 24,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305195,25) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 25,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305195,26) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 26,attr_list = [{1,4680},{2,93600},{4,2340},{3,2340}]};

get_by_id_order(305195,27) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 27,attr_list = [{1,4860},{2,97200},{4,2430},{3,2430}]};

get_by_id_order(305195,28) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 28,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305195,29) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 29,attr_list = [{1,5220},{2,104400},{4,2610},{3,2610}]};

get_by_id_order(305195,30) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 30,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305195,31) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 31,attr_list = [{1,5580},{2,111600},{4,2790},{3,2790}]};

get_by_id_order(305195,32) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 32,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305195,33) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 33,attr_list = [{1,5940},{2,118800},{4,2970},{3,2970}]};

get_by_id_order(305195,34) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 34,attr_list = [{1,6120},{2,122400},{4,3060},{3,3060}]};

get_by_id_order(305195,35) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 35,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305195,36) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 36,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305195,37) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 37,attr_list = [{1,6660},{2,133200},{4,3330},{3,3330}]};

get_by_id_order(305195,38) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 38,attr_list = [{1,6840},{2,136800},{4,3420},{3,3420}]};

get_by_id_order(305195,39) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 39,attr_list = [{1,7020},{2,140400},{4,3510},{3,3510}]};

get_by_id_order(305195,40) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 40,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305195,41) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 41,attr_list = [{1,7380},{2,147600},{4,3690},{3,3690}]};

get_by_id_order(305195,42) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 42,attr_list = [{1,7560},{2,151200},{4,3780},{3,3780}]};

get_by_id_order(305195,43) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 43,attr_list = [{1,7740},{2,154800},{4,3870},{3,3870}]};

get_by_id_order(305195,44) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 44,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305195,45) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 45,attr_list = [{1,8100},{2,162000},{4,4050},{3,4050}]};

get_by_id_order(305195,46) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 46,attr_list = [{1,8280},{2,165600},{4,4140},{3,4140}]};

get_by_id_order(305195,47) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 47,attr_list = [{1,8460},{2,169200},{4,4230},{3,4230}]};

get_by_id_order(305195,48) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 48,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305195,49) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 49,attr_list = [{1,8820},{2,176400},{4,4410},{3,4410}]};

get_by_id_order(305195,50) ->
	#base_dsgt_order{dsgt_id = 305195,consume = [{0,38065195,1}],dsgt_order = 50,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305196,1) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 1,attr_list = [{1,240},{2,4800},{4,120},{3,120}]};

get_by_id_order(305196,2) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 2,attr_list = [{1,480},{2,9600},{4,240},{3,240}]};

get_by_id_order(305196,3) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 3,attr_list = [{1,720},{2,14400},{4,360},{3,360}]};

get_by_id_order(305196,4) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 4,attr_list = [{1,960},{2,19200},{4,480},{3,480}]};

get_by_id_order(305196,5) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 5,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305196,6) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 6,attr_list = [{1,1440},{2,28800},{4,720},{3,720}]};

get_by_id_order(305196,7) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 7,attr_list = [{1,1680},{2,33600},{4,840},{3,840}]};

get_by_id_order(305196,8) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 8,attr_list = [{1,1920},{2,38400},{4,960},{3,960}]};

get_by_id_order(305196,9) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 9,attr_list = [{1,2160},{2,43200},{4,1080},{3,1080}]};

get_by_id_order(305196,10) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 10,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305196,11) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 11,attr_list = [{1,2640},{2,52800},{4,1320},{3,1320}]};

get_by_id_order(305196,12) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 12,attr_list = [{1,2880},{2,57600},{4,1440},{3,1440}]};

get_by_id_order(305196,13) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 13,attr_list = [{1,3120},{2,62400},{4,1560},{3,1560}]};

get_by_id_order(305196,14) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 14,attr_list = [{1,3360},{2,67200},{4,1680},{3,1680}]};

get_by_id_order(305196,15) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 15,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305196,16) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 16,attr_list = [{1,3840},{2,76800},{4,1920},{3,1920}]};

get_by_id_order(305196,17) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 17,attr_list = [{1,4080},{2,81600},{4,2040},{3,2040}]};

get_by_id_order(305196,18) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 18,attr_list = [{1,4320},{2,86400},{4,2160},{3,2160}]};

get_by_id_order(305196,19) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 19,attr_list = [{1,4560},{2,91200},{4,2280},{3,2280}]};

get_by_id_order(305196,20) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 20,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305196,21) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 21,attr_list = [{1,5040},{2,100800},{4,2520},{3,2520}]};

get_by_id_order(305196,22) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 22,attr_list = [{1,5280},{2,105600},{4,2640},{3,2640}]};

get_by_id_order(305196,23) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 23,attr_list = [{1,5520},{2,110400},{4,2760},{3,2760}]};

get_by_id_order(305196,24) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 24,attr_list = [{1,5760},{2,115200},{4,2880},{3,2880}]};

get_by_id_order(305196,25) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 25,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305196,26) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 26,attr_list = [{1,6240},{2,124800},{4,3120},{3,3120}]};

get_by_id_order(305196,27) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 27,attr_list = [{1,6480},{2,129600},{4,3240},{3,3240}]};

get_by_id_order(305196,28) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 28,attr_list = [{1,6720},{2,134400},{4,3360},{3,3360}]};

get_by_id_order(305196,29) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 29,attr_list = [{1,6960},{2,139200},{4,3480},{3,3480}]};

get_by_id_order(305196,30) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 30,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305196,31) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 31,attr_list = [{1,7440},{2,148800},{4,3720},{3,3720}]};

get_by_id_order(305196,32) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 32,attr_list = [{1,7680},{2,153600},{4,3840},{3,3840}]};

get_by_id_order(305196,33) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 33,attr_list = [{1,7920},{2,158400},{4,3960},{3,3960}]};

get_by_id_order(305196,34) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 34,attr_list = [{1,8160},{2,163200},{4,4080},{3,4080}]};

get_by_id_order(305196,35) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 35,attr_list = [{1,8400},{2,168000},{4,4200},{3,4200}]};

get_by_id_order(305196,36) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 36,attr_list = [{1,8640},{2,172800},{4,4320},{3,4320}]};

get_by_id_order(305196,37) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 37,attr_list = [{1,8880},{2,177600},{4,4440},{3,4440}]};

get_by_id_order(305196,38) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 38,attr_list = [{1,9120},{2,182400},{4,4560},{3,4560}]};

get_by_id_order(305196,39) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 39,attr_list = [{1,9360},{2,187200},{4,4680},{3,4680}]};

get_by_id_order(305196,40) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 40,attr_list = [{1,9600},{2,192000},{4,4800},{3,4800}]};

get_by_id_order(305196,41) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 41,attr_list = [{1,9840},{2,196800},{4,4920},{3,4920}]};

get_by_id_order(305196,42) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 42,attr_list = [{1,10080},{2,201600},{4,5040},{3,5040}]};

get_by_id_order(305196,43) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 43,attr_list = [{1,10320},{2,206400},{4,5160},{3,5160}]};

get_by_id_order(305196,44) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 44,attr_list = [{1,10560},{2,211200},{4,5280},{3,5280}]};

get_by_id_order(305196,45) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 45,attr_list = [{1,10800},{2,216000},{4,5400},{3,5400}]};

get_by_id_order(305196,46) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 46,attr_list = [{1,11040},{2,220800},{4,5520},{3,5520}]};

get_by_id_order(305196,47) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 47,attr_list = [{1,11280},{2,225600},{4,5640},{3,5640}]};

get_by_id_order(305196,48) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 48,attr_list = [{1,11520},{2,230400},{4,5760},{3,5760}]};

get_by_id_order(305196,49) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 49,attr_list = [{1,11760},{2,235200},{4,5880},{3,5880}]};

get_by_id_order(305196,50) ->
	#base_dsgt_order{dsgt_id = 305196,consume = [{0,38065196,1}],dsgt_order = 50,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305197,1) ->
	#base_dsgt_order{dsgt_id = 305197,consume = [{0,38065197,1}],dsgt_order = 1,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305197,2) ->
	#base_dsgt_order{dsgt_id = 305197,consume = [{0,38065197,1}],dsgt_order = 2,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305197,3) ->
	#base_dsgt_order{dsgt_id = 305197,consume = [{0,38065197,1}],dsgt_order = 3,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305197,4) ->
	#base_dsgt_order{dsgt_id = 305197,consume = [{0,38065197,1}],dsgt_order = 4,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305197,5) ->
	#base_dsgt_order{dsgt_id = 305197,consume = [{0,38065197,1}],dsgt_order = 5,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305197,6) ->
	#base_dsgt_order{dsgt_id = 305197,consume = [{0,38065197,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305197,7) ->
	#base_dsgt_order{dsgt_id = 305197,consume = [{0,38065197,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305197,8) ->
	#base_dsgt_order{dsgt_id = 305197,consume = [{0,38065197,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305197,9) ->
	#base_dsgt_order{dsgt_id = 305197,consume = [{0,38065197,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305197,10) ->
	#base_dsgt_order{dsgt_id = 305197,consume = [{0,38065197,1}],dsgt_order = 10,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305198,1) ->
	#base_dsgt_order{dsgt_id = 305198,consume = [{0,38065198,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305198,2) ->
	#base_dsgt_order{dsgt_id = 305198,consume = [{0,38065198,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305198,3) ->
	#base_dsgt_order{dsgt_id = 305198,consume = [{0,38065198,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305198,4) ->
	#base_dsgt_order{dsgt_id = 305198,consume = [{0,38065198,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305198,5) ->
	#base_dsgt_order{dsgt_id = 305198,consume = [{0,38065198,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305198,6) ->
	#base_dsgt_order{dsgt_id = 305198,consume = [{0,38065198,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305198,7) ->
	#base_dsgt_order{dsgt_id = 305198,consume = [{0,38065198,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305198,8) ->
	#base_dsgt_order{dsgt_id = 305198,consume = [{0,38065198,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305198,9) ->
	#base_dsgt_order{dsgt_id = 305198,consume = [{0,38065198,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305198,10) ->
	#base_dsgt_order{dsgt_id = 305198,consume = [{0,38065198,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305199,1) ->
	#base_dsgt_order{dsgt_id = 305199,consume = [{0,38065199,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305199,2) ->
	#base_dsgt_order{dsgt_id = 305199,consume = [{0,38065199,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305199,3) ->
	#base_dsgt_order{dsgt_id = 305199,consume = [{0,38065199,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305199,4) ->
	#base_dsgt_order{dsgt_id = 305199,consume = [{0,38065199,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305199,5) ->
	#base_dsgt_order{dsgt_id = 305199,consume = [{0,38065199,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305199,6) ->
	#base_dsgt_order{dsgt_id = 305199,consume = [{0,38065199,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305199,7) ->
	#base_dsgt_order{dsgt_id = 305199,consume = [{0,38065199,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305199,8) ->
	#base_dsgt_order{dsgt_id = 305199,consume = [{0,38065199,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305199,9) ->
	#base_dsgt_order{dsgt_id = 305199,consume = [{0,38065199,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305199,10) ->
	#base_dsgt_order{dsgt_id = 305199,consume = [{0,38065199,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305208,1) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 1,attr_list = [{1,50},{2,2000},{4,50},{3,50}]};

get_by_id_order(305208,2) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 2,attr_list = [{1,100},{2,4000},{4,100},{3,100}]};

get_by_id_order(305208,3) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 3,attr_list = [{1,150},{2,6000},{4,150},{3,150}]};

get_by_id_order(305208,4) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 4,attr_list = [{1,200},{2,8000},{4,200},{3,200}]};

get_by_id_order(305208,5) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 5,attr_list = [{1,250},{2,10000},{4,250},{3,250}]};

get_by_id_order(305208,6) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 6,attr_list = [{1,300},{2,12000},{4,300},{3,300}]};

get_by_id_order(305208,7) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 7,attr_list = [{1,350},{2,14000},{4,350},{3,350}]};

get_by_id_order(305208,8) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 8,attr_list = [{1,400},{2,16000},{4,400},{3,400}]};

get_by_id_order(305208,9) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 9,attr_list = [{1,450},{2,18000},{4,450},{3,450}]};

get_by_id_order(305208,10) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 10,attr_list = [{1,500},{2,20000},{4,500},{3,500}]};

get_by_id_order(305208,11) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 11,attr_list = [{1,550},{2,22000},{4,550},{3,550}]};

get_by_id_order(305208,12) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 12,attr_list = [{1,600},{2,24000},{4,600},{3,600}]};

get_by_id_order(305208,13) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 13,attr_list = [{1,650},{2,26000},{4,650},{3,650}]};

get_by_id_order(305208,14) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 14,attr_list = [{1,700},{2,28000},{4,700},{3,700}]};

get_by_id_order(305208,15) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 15,attr_list = [{1,750},{2,30000},{4,750},{3,750}]};

get_by_id_order(305208,16) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 16,attr_list = [{1,800},{2,32000},{4,800},{3,800}]};

get_by_id_order(305208,17) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 17,attr_list = [{1,850},{2,34000},{4,850},{3,850}]};

get_by_id_order(305208,18) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 18,attr_list = [{1,900},{2,36000},{4,900},{3,900}]};

get_by_id_order(305208,19) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 19,attr_list = [{1,950},{2,38000},{4,950},{3,950}]};

get_by_id_order(305208,20) ->
	#base_dsgt_order{dsgt_id = 305208,consume = [{0,38065208,1}],dsgt_order = 20,attr_list = [{1,1000},{2,40000},{4,1000},{3,1000}]};

get_by_id_order(305209,1) ->
	#base_dsgt_order{dsgt_id = 305209,consume = [{0,38065209,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305209,2) ->
	#base_dsgt_order{dsgt_id = 305209,consume = [{0,38065209,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305209,3) ->
	#base_dsgt_order{dsgt_id = 305209,consume = [{0,38065209,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305209,4) ->
	#base_dsgt_order{dsgt_id = 305209,consume = [{0,38065209,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305209,5) ->
	#base_dsgt_order{dsgt_id = 305209,consume = [{0,38065209,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305209,6) ->
	#base_dsgt_order{dsgt_id = 305209,consume = [{0,38065209,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305209,7) ->
	#base_dsgt_order{dsgt_id = 305209,consume = [{0,38065209,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305209,8) ->
	#base_dsgt_order{dsgt_id = 305209,consume = [{0,38065209,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305209,9) ->
	#base_dsgt_order{dsgt_id = 305209,consume = [{0,38065209,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305209,10) ->
	#base_dsgt_order{dsgt_id = 305209,consume = [{0,38065209,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305210,1) ->
	#base_dsgt_order{dsgt_id = 305210,consume = [{0,38065210,1}],dsgt_order = 1,attr_list = [{1,100},{2,10000},{4,100},{3,300}]};

get_by_id_order(305210,2) ->
	#base_dsgt_order{dsgt_id = 305210,consume = [{0,38065210,1}],dsgt_order = 2,attr_list = [{1,200},{2,20000},{4,200},{3,600}]};

get_by_id_order(305210,3) ->
	#base_dsgt_order{dsgt_id = 305210,consume = [{0,38065210,1}],dsgt_order = 3,attr_list = [{1,300},{2,30000},{4,300},{3,900}]};

get_by_id_order(305210,4) ->
	#base_dsgt_order{dsgt_id = 305210,consume = [{0,38065210,1}],dsgt_order = 4,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305210,5) ->
	#base_dsgt_order{dsgt_id = 305210,consume = [{0,38065210,1}],dsgt_order = 5,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305210,6) ->
	#base_dsgt_order{dsgt_id = 305210,consume = [{0,38065210,1}],dsgt_order = 6,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305210,7) ->
	#base_dsgt_order{dsgt_id = 305210,consume = [{0,38065210,1}],dsgt_order = 7,attr_list = [{1,700},{2,70000},{4,700},{3,2100}]};

get_by_id_order(305210,8) ->
	#base_dsgt_order{dsgt_id = 305210,consume = [{0,38065210,1}],dsgt_order = 8,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305210,9) ->
	#base_dsgt_order{dsgt_id = 305210,consume = [{0,38065210,1}],dsgt_order = 9,attr_list = [{1,900},{2,90000},{4,900},{3,2700}]};

get_by_id_order(305210,10) ->
	#base_dsgt_order{dsgt_id = 305210,consume = [{0,38065210,1}],dsgt_order = 10,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305211,1) ->
	#base_dsgt_order{dsgt_id = 305211,consume = [{0,38065211,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305211,2) ->
	#base_dsgt_order{dsgt_id = 305211,consume = [{0,38065211,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305211,3) ->
	#base_dsgt_order{dsgt_id = 305211,consume = [{0,38065211,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305211,4) ->
	#base_dsgt_order{dsgt_id = 305211,consume = [{0,38065211,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305211,5) ->
	#base_dsgt_order{dsgt_id = 305211,consume = [{0,38065211,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305211,6) ->
	#base_dsgt_order{dsgt_id = 305211,consume = [{0,38065211,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305211,7) ->
	#base_dsgt_order{dsgt_id = 305211,consume = [{0,38065211,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305211,8) ->
	#base_dsgt_order{dsgt_id = 305211,consume = [{0,38065211,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305211,9) ->
	#base_dsgt_order{dsgt_id = 305211,consume = [{0,38065211,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305211,10) ->
	#base_dsgt_order{dsgt_id = 305211,consume = [{0,38065211,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305212,1) ->
	#base_dsgt_order{dsgt_id = 305212,consume = [{0,38065212,1}],dsgt_order = 1,attr_list = [{1,100},{2,10000},{4,100},{3,300}]};

get_by_id_order(305212,2) ->
	#base_dsgt_order{dsgt_id = 305212,consume = [{0,38065212,1}],dsgt_order = 2,attr_list = [{1,200},{2,20000},{4,200},{3,600}]};

get_by_id_order(305212,3) ->
	#base_dsgt_order{dsgt_id = 305212,consume = [{0,38065212,1}],dsgt_order = 3,attr_list = [{1,300},{2,30000},{4,300},{3,900}]};

get_by_id_order(305212,4) ->
	#base_dsgt_order{dsgt_id = 305212,consume = [{0,38065212,1}],dsgt_order = 4,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305212,5) ->
	#base_dsgt_order{dsgt_id = 305212,consume = [{0,38065212,1}],dsgt_order = 5,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305212,6) ->
	#base_dsgt_order{dsgt_id = 305212,consume = [{0,38065212,1}],dsgt_order = 6,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305212,7) ->
	#base_dsgt_order{dsgt_id = 305212,consume = [{0,38065212,1}],dsgt_order = 7,attr_list = [{1,700},{2,70000},{4,700},{3,2100}]};

get_by_id_order(305212,8) ->
	#base_dsgt_order{dsgt_id = 305212,consume = [{0,38065212,1}],dsgt_order = 8,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305212,9) ->
	#base_dsgt_order{dsgt_id = 305212,consume = [{0,38065212,1}],dsgt_order = 9,attr_list = [{1,900},{2,90000},{4,900},{3,2700}]};

get_by_id_order(305212,10) ->
	#base_dsgt_order{dsgt_id = 305212,consume = [{0,38065212,1}],dsgt_order = 10,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305213,1) ->
	#base_dsgt_order{dsgt_id = 305213,consume = [{0,38065213,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305213,2) ->
	#base_dsgt_order{dsgt_id = 305213,consume = [{0,38065213,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305213,3) ->
	#base_dsgt_order{dsgt_id = 305213,consume = [{0,38065213,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305213,4) ->
	#base_dsgt_order{dsgt_id = 305213,consume = [{0,38065213,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305213,5) ->
	#base_dsgt_order{dsgt_id = 305213,consume = [{0,38065213,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305213,6) ->
	#base_dsgt_order{dsgt_id = 305213,consume = [{0,38065213,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305213,7) ->
	#base_dsgt_order{dsgt_id = 305213,consume = [{0,38065213,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305213,8) ->
	#base_dsgt_order{dsgt_id = 305213,consume = [{0,38065213,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305213,9) ->
	#base_dsgt_order{dsgt_id = 305213,consume = [{0,38065213,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305213,10) ->
	#base_dsgt_order{dsgt_id = 305213,consume = [{0,38065213,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305214,1) ->
	#base_dsgt_order{dsgt_id = 305214,consume = [{0,38065214,1}],dsgt_order = 1,attr_list = [{1,100},{2,10000},{4,100},{3,300}]};

get_by_id_order(305214,2) ->
	#base_dsgt_order{dsgt_id = 305214,consume = [{0,38065214,1}],dsgt_order = 2,attr_list = [{1,200},{2,20000},{4,200},{3,600}]};

get_by_id_order(305214,3) ->
	#base_dsgt_order{dsgt_id = 305214,consume = [{0,38065214,1}],dsgt_order = 3,attr_list = [{1,300},{2,30000},{4,300},{3,900}]};

get_by_id_order(305214,4) ->
	#base_dsgt_order{dsgt_id = 305214,consume = [{0,38065214,1}],dsgt_order = 4,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305214,5) ->
	#base_dsgt_order{dsgt_id = 305214,consume = [{0,38065214,1}],dsgt_order = 5,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305214,6) ->
	#base_dsgt_order{dsgt_id = 305214,consume = [{0,38065214,1}],dsgt_order = 6,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305214,7) ->
	#base_dsgt_order{dsgt_id = 305214,consume = [{0,38065214,1}],dsgt_order = 7,attr_list = [{1,700},{2,70000},{4,700},{3,2100}]};

get_by_id_order(305214,8) ->
	#base_dsgt_order{dsgt_id = 305214,consume = [{0,38065214,1}],dsgt_order = 8,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305214,9) ->
	#base_dsgt_order{dsgt_id = 305214,consume = [{0,38065214,1}],dsgt_order = 9,attr_list = [{1,900},{2,90000},{4,900},{3,2700}]};

get_by_id_order(305214,10) ->
	#base_dsgt_order{dsgt_id = 305214,consume = [{0,38065214,1}],dsgt_order = 10,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305215,1) ->
	#base_dsgt_order{dsgt_id = 305215,consume = [{0,38065215,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305215,2) ->
	#base_dsgt_order{dsgt_id = 305215,consume = [{0,38065215,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305215,3) ->
	#base_dsgt_order{dsgt_id = 305215,consume = [{0,38065215,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305215,4) ->
	#base_dsgt_order{dsgt_id = 305215,consume = [{0,38065215,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305215,5) ->
	#base_dsgt_order{dsgt_id = 305215,consume = [{0,38065215,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305215,6) ->
	#base_dsgt_order{dsgt_id = 305215,consume = [{0,38065215,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305215,7) ->
	#base_dsgt_order{dsgt_id = 305215,consume = [{0,38065215,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305215,8) ->
	#base_dsgt_order{dsgt_id = 305215,consume = [{0,38065215,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305215,9) ->
	#base_dsgt_order{dsgt_id = 305215,consume = [{0,38065215,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305215,10) ->
	#base_dsgt_order{dsgt_id = 305215,consume = [{0,38065215,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305216,1) ->
	#base_dsgt_order{dsgt_id = 305216,consume = [{0,38065216,1}],dsgt_order = 1,attr_list = [{1,100},{2,10000},{4,100},{3,300}]};

get_by_id_order(305216,2) ->
	#base_dsgt_order{dsgt_id = 305216,consume = [{0,38065216,1}],dsgt_order = 2,attr_list = [{1,200},{2,20000},{4,200},{3,600}]};

get_by_id_order(305216,3) ->
	#base_dsgt_order{dsgt_id = 305216,consume = [{0,38065216,1}],dsgt_order = 3,attr_list = [{1,300},{2,30000},{4,300},{3,900}]};

get_by_id_order(305216,4) ->
	#base_dsgt_order{dsgt_id = 305216,consume = [{0,38065216,1}],dsgt_order = 4,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305216,5) ->
	#base_dsgt_order{dsgt_id = 305216,consume = [{0,38065216,1}],dsgt_order = 5,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305216,6) ->
	#base_dsgt_order{dsgt_id = 305216,consume = [{0,38065216,1}],dsgt_order = 6,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305216,7) ->
	#base_dsgt_order{dsgt_id = 305216,consume = [{0,38065216,1}],dsgt_order = 7,attr_list = [{1,700},{2,70000},{4,700},{3,2100}]};

get_by_id_order(305216,8) ->
	#base_dsgt_order{dsgt_id = 305216,consume = [{0,38065216,1}],dsgt_order = 8,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305216,9) ->
	#base_dsgt_order{dsgt_id = 305216,consume = [{0,38065216,1}],dsgt_order = 9,attr_list = [{1,900},{2,90000},{4,900},{3,2700}]};

get_by_id_order(305216,10) ->
	#base_dsgt_order{dsgt_id = 305216,consume = [{0,38065216,1}],dsgt_order = 10,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305217,1) ->
	#base_dsgt_order{dsgt_id = 305217,consume = [{0,38065217,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305217,2) ->
	#base_dsgt_order{dsgt_id = 305217,consume = [{0,38065217,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305217,3) ->
	#base_dsgt_order{dsgt_id = 305217,consume = [{0,38065217,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305217,4) ->
	#base_dsgt_order{dsgt_id = 305217,consume = [{0,38065217,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305217,5) ->
	#base_dsgt_order{dsgt_id = 305217,consume = [{0,38065217,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305217,6) ->
	#base_dsgt_order{dsgt_id = 305217,consume = [{0,38065217,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305217,7) ->
	#base_dsgt_order{dsgt_id = 305217,consume = [{0,38065217,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305217,8) ->
	#base_dsgt_order{dsgt_id = 305217,consume = [{0,38065217,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305217,9) ->
	#base_dsgt_order{dsgt_id = 305217,consume = [{0,38065217,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305217,10) ->
	#base_dsgt_order{dsgt_id = 305217,consume = [{0,38065217,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305218,1) ->
	#base_dsgt_order{dsgt_id = 305218,consume = [{0,38065218,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305218,2) ->
	#base_dsgt_order{dsgt_id = 305218,consume = [{0,38065218,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305218,3) ->
	#base_dsgt_order{dsgt_id = 305218,consume = [{0,38065218,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305218,4) ->
	#base_dsgt_order{dsgt_id = 305218,consume = [{0,38065218,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305218,5) ->
	#base_dsgt_order{dsgt_id = 305218,consume = [{0,38065218,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305218,6) ->
	#base_dsgt_order{dsgt_id = 305218,consume = [{0,38065218,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305218,7) ->
	#base_dsgt_order{dsgt_id = 305218,consume = [{0,38065218,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305218,8) ->
	#base_dsgt_order{dsgt_id = 305218,consume = [{0,38065218,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305218,9) ->
	#base_dsgt_order{dsgt_id = 305218,consume = [{0,38065218,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305218,10) ->
	#base_dsgt_order{dsgt_id = 305218,consume = [{0,38065218,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305239,1) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 1,attr_list = [{1,200},{2,2000},{4,100},{3,100}]};

get_by_id_order(305239,2) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 2,attr_list = [{1,400},{2,4000},{4,200},{3,200}]};

get_by_id_order(305239,3) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 3,attr_list = [{1,600},{2,6000},{4,300},{3,300}]};

get_by_id_order(305239,4) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 4,attr_list = [{1,800},{2,8000},{4,400},{3,400}]};

get_by_id_order(305239,5) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 5,attr_list = [{1,1000},{2,10000},{4,500},{3,500}]};

get_by_id_order(305239,6) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 6,attr_list = [{1,1200},{2,12000},{4,600},{3,600}]};

get_by_id_order(305239,7) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 7,attr_list = [{1,1400},{2,14000},{4,700},{3,700}]};

get_by_id_order(305239,8) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 8,attr_list = [{1,1600},{2,16000},{4,800},{3,800}]};

get_by_id_order(305239,9) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 9,attr_list = [{1,1800},{2,18000},{4,900},{3,900}]};

get_by_id_order(305239,10) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 10,attr_list = [{1,2000},{2,20000},{4,1000},{3,1000}]};

get_by_id_order(305239,11) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 11,attr_list = [{1,2200},{2,22000},{4,1100},{3,1100}]};

get_by_id_order(305239,12) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 12,attr_list = [{1,2400},{2,24000},{4,1200},{3,1200}]};

get_by_id_order(305239,13) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 13,attr_list = [{1,2600},{2,26000},{4,1300},{3,1300}]};

get_by_id_order(305239,14) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 14,attr_list = [{1,2800},{2,28000},{4,1400},{3,1400}]};

get_by_id_order(305239,15) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 15,attr_list = [{1,3000},{2,30000},{4,1500},{3,1500}]};

get_by_id_order(305239,16) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 16,attr_list = [{1,3200},{2,32000},{4,1600},{3,1600}]};

get_by_id_order(305239,17) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 17,attr_list = [{1,3400},{2,34000},{4,1700},{3,1700}]};

get_by_id_order(305239,18) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 18,attr_list = [{1,3600},{2,36000},{4,1800},{3,1800}]};

get_by_id_order(305239,19) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 19,attr_list = [{1,3800},{2,38000},{4,1900},{3,1900}]};

get_by_id_order(305239,20) ->
	#base_dsgt_order{dsgt_id = 305239,consume = [{0,38065239,1}],dsgt_order = 20,attr_list = [{1,4000},{2,40000},{4,2000},{3,2000}]};

get_by_id_order(305240,1) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 1,attr_list = [{1,200},{2,12000},{4,100},{3,100}]};

get_by_id_order(305240,2) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 2,attr_list = [{1,400},{2,24000},{4,200},{3,200}]};

get_by_id_order(305240,3) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 3,attr_list = [{1,600},{2,36000},{4,300},{3,300}]};

get_by_id_order(305240,4) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 4,attr_list = [{1,800},{2,48000},{4,400},{3,400}]};

get_by_id_order(305240,5) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 5,attr_list = [{1,1000},{2,60000},{4,500},{3,500}]};

get_by_id_order(305240,6) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 6,attr_list = [{1,1200},{2,72000},{4,600},{3,600}]};

get_by_id_order(305240,7) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 7,attr_list = [{1,1400},{2,84000},{4,700},{3,700}]};

get_by_id_order(305240,8) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 8,attr_list = [{1,1600},{2,96000},{4,800},{3,800}]};

get_by_id_order(305240,9) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 9,attr_list = [{1,1800},{2,108000},{4,900},{3,900}]};

get_by_id_order(305240,10) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 10,attr_list = [{1,2000},{2,120000},{4,1000},{3,1000}]};

get_by_id_order(305240,11) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 11,attr_list = [{1,2200},{2,132000},{4,1100},{3,1100}]};

get_by_id_order(305240,12) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 12,attr_list = [{1,2400},{2,144000},{4,1200},{3,1200}]};

get_by_id_order(305240,13) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 13,attr_list = [{1,2600},{2,156000},{4,1300},{3,1300}]};

get_by_id_order(305240,14) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 14,attr_list = [{1,2800},{2,168000},{4,1400},{3,1400}]};

get_by_id_order(305240,15) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 15,attr_list = [{1,3000},{2,180000},{4,1500},{3,1500}]};

get_by_id_order(305240,16) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 16,attr_list = [{1,3200},{2,192000},{4,1600},{3,1600}]};

get_by_id_order(305240,17) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 17,attr_list = [{1,3400},{2,204000},{4,1700},{3,1700}]};

get_by_id_order(305240,18) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 18,attr_list = [{1,3600},{2,216000},{4,1800},{3,1800}]};

get_by_id_order(305240,19) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 19,attr_list = [{1,3800},{2,228000},{4,1900},{3,1900}]};

get_by_id_order(305240,20) ->
	#base_dsgt_order{dsgt_id = 305240,consume = [{0,38065240,1}],dsgt_order = 20,attr_list = [{1,4000},{2,240000},{4,2000},{3,2000}]};

get_by_id_order(305241,1) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 1,attr_list = [{1,200},{2,12000},{4,100},{3,100}]};

get_by_id_order(305241,2) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 2,attr_list = [{1,400},{2,24000},{4,200},{3,200}]};

get_by_id_order(305241,3) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 3,attr_list = [{1,600},{2,36000},{4,300},{3,300}]};

get_by_id_order(305241,4) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 4,attr_list = [{1,800},{2,48000},{4,400},{3,400}]};

get_by_id_order(305241,5) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 5,attr_list = [{1,1000},{2,60000},{4,500},{3,500}]};

get_by_id_order(305241,6) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 6,attr_list = [{1,1200},{2,72000},{4,600},{3,600}]};

get_by_id_order(305241,7) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 7,attr_list = [{1,1400},{2,84000},{4,700},{3,700}]};

get_by_id_order(305241,8) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 8,attr_list = [{1,1600},{2,96000},{4,800},{3,800}]};

get_by_id_order(305241,9) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 9,attr_list = [{1,1800},{2,108000},{4,900},{3,900}]};

get_by_id_order(305241,10) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 10,attr_list = [{1,2000},{2,120000},{4,1000},{3,1000}]};

get_by_id_order(305241,11) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 11,attr_list = [{1,2200},{2,132000},{4,1100},{3,1100}]};

get_by_id_order(305241,12) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 12,attr_list = [{1,2400},{2,144000},{4,1200},{3,1200}]};

get_by_id_order(305241,13) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 13,attr_list = [{1,2600},{2,156000},{4,1300},{3,1300}]};

get_by_id_order(305241,14) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 14,attr_list = [{1,2800},{2,168000},{4,1400},{3,1400}]};

get_by_id_order(305241,15) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 15,attr_list = [{1,3000},{2,180000},{4,1500},{3,1500}]};

get_by_id_order(305241,16) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 16,attr_list = [{1,3200},{2,192000},{4,1600},{3,1600}]};

get_by_id_order(305241,17) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 17,attr_list = [{1,3400},{2,204000},{4,1700},{3,1700}]};

get_by_id_order(305241,18) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 18,attr_list = [{1,3600},{2,216000},{4,1800},{3,1800}]};

get_by_id_order(305241,19) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 19,attr_list = [{1,3800},{2,228000},{4,1900},{3,1900}]};

get_by_id_order(305241,20) ->
	#base_dsgt_order{dsgt_id = 305241,consume = [{0,38065241,1}],dsgt_order = 20,attr_list = [{1,4000},{2,240000},{4,2000},{3,2000}]};

get_by_id_order(305242,1) ->
	#base_dsgt_order{dsgt_id = 305242,consume = [{0,38065242,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305242,2) ->
	#base_dsgt_order{dsgt_id = 305242,consume = [{0,38065242,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305242,3) ->
	#base_dsgt_order{dsgt_id = 305242,consume = [{0,38065242,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305242,4) ->
	#base_dsgt_order{dsgt_id = 305242,consume = [{0,38065242,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305242,5) ->
	#base_dsgt_order{dsgt_id = 305242,consume = [{0,38065242,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305242,6) ->
	#base_dsgt_order{dsgt_id = 305242,consume = [{0,38065242,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305242,7) ->
	#base_dsgt_order{dsgt_id = 305242,consume = [{0,38065242,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305242,8) ->
	#base_dsgt_order{dsgt_id = 305242,consume = [{0,38065242,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305242,9) ->
	#base_dsgt_order{dsgt_id = 305242,consume = [{0,38065242,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305242,10) ->
	#base_dsgt_order{dsgt_id = 305242,consume = [{0,38065242,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305243,1) ->
	#base_dsgt_order{dsgt_id = 305243,consume = [{0,38065243,1}],dsgt_order = 1,attr_list = [{1,100},{2,10000},{4,100},{3,300}]};

get_by_id_order(305243,2) ->
	#base_dsgt_order{dsgt_id = 305243,consume = [{0,38065243,1}],dsgt_order = 2,attr_list = [{1,200},{2,20000},{4,200},{3,600}]};

get_by_id_order(305243,3) ->
	#base_dsgt_order{dsgt_id = 305243,consume = [{0,38065243,1}],dsgt_order = 3,attr_list = [{1,300},{2,30000},{4,300},{3,900}]};

get_by_id_order(305243,4) ->
	#base_dsgt_order{dsgt_id = 305243,consume = [{0,38065243,1}],dsgt_order = 4,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305243,5) ->
	#base_dsgt_order{dsgt_id = 305243,consume = [{0,38065243,1}],dsgt_order = 5,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305243,6) ->
	#base_dsgt_order{dsgt_id = 305243,consume = [{0,38065243,1}],dsgt_order = 6,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305243,7) ->
	#base_dsgt_order{dsgt_id = 305243,consume = [{0,38065243,1}],dsgt_order = 7,attr_list = [{1,700},{2,70000},{4,700},{3,2100}]};

get_by_id_order(305243,8) ->
	#base_dsgt_order{dsgt_id = 305243,consume = [{0,38065243,1}],dsgt_order = 8,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305243,9) ->
	#base_dsgt_order{dsgt_id = 305243,consume = [{0,38065243,1}],dsgt_order = 9,attr_list = [{1,900},{2,90000},{4,900},{3,2700}]};

get_by_id_order(305243,10) ->
	#base_dsgt_order{dsgt_id = 305243,consume = [{0,38065243,1}],dsgt_order = 10,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305244,1) ->
	#base_dsgt_order{dsgt_id = 305244,consume = [{0,38065244,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305244,2) ->
	#base_dsgt_order{dsgt_id = 305244,consume = [{0,38065244,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305244,3) ->
	#base_dsgt_order{dsgt_id = 305244,consume = [{0,38065244,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305244,4) ->
	#base_dsgt_order{dsgt_id = 305244,consume = [{0,38065244,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305244,5) ->
	#base_dsgt_order{dsgt_id = 305244,consume = [{0,38065244,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305244,6) ->
	#base_dsgt_order{dsgt_id = 305244,consume = [{0,38065244,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305244,7) ->
	#base_dsgt_order{dsgt_id = 305244,consume = [{0,38065244,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305244,8) ->
	#base_dsgt_order{dsgt_id = 305244,consume = [{0,38065244,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305244,9) ->
	#base_dsgt_order{dsgt_id = 305244,consume = [{0,38065244,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305244,10) ->
	#base_dsgt_order{dsgt_id = 305244,consume = [{0,38065244,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305245,1) ->
	#base_dsgt_order{dsgt_id = 305245,consume = [{0,38065245,1}],dsgt_order = 1,attr_list = [{1,100},{2,10000},{4,100},{3,300}]};

get_by_id_order(305245,2) ->
	#base_dsgt_order{dsgt_id = 305245,consume = [{0,38065245,1}],dsgt_order = 2,attr_list = [{1,200},{2,20000},{4,200},{3,600}]};

get_by_id_order(305245,3) ->
	#base_dsgt_order{dsgt_id = 305245,consume = [{0,38065245,1}],dsgt_order = 3,attr_list = [{1,300},{2,30000},{4,300},{3,900}]};

get_by_id_order(305245,4) ->
	#base_dsgt_order{dsgt_id = 305245,consume = [{0,38065245,1}],dsgt_order = 4,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305245,5) ->
	#base_dsgt_order{dsgt_id = 305245,consume = [{0,38065245,1}],dsgt_order = 5,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305245,6) ->
	#base_dsgt_order{dsgt_id = 305245,consume = [{0,38065245,1}],dsgt_order = 6,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305245,7) ->
	#base_dsgt_order{dsgt_id = 305245,consume = [{0,38065245,1}],dsgt_order = 7,attr_list = [{1,700},{2,70000},{4,700},{3,2100}]};

get_by_id_order(305245,8) ->
	#base_dsgt_order{dsgt_id = 305245,consume = [{0,38065245,1}],dsgt_order = 8,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305245,9) ->
	#base_dsgt_order{dsgt_id = 305245,consume = [{0,38065245,1}],dsgt_order = 9,attr_list = [{1,900},{2,90000},{4,900},{3,2700}]};

get_by_id_order(305245,10) ->
	#base_dsgt_order{dsgt_id = 305245,consume = [{0,38065245,1}],dsgt_order = 10,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305246,1) ->
	#base_dsgt_order{dsgt_id = 305246,consume = [{0,38065246,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305246,2) ->
	#base_dsgt_order{dsgt_id = 305246,consume = [{0,38065246,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305246,3) ->
	#base_dsgt_order{dsgt_id = 305246,consume = [{0,38065246,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305246,4) ->
	#base_dsgt_order{dsgt_id = 305246,consume = [{0,38065246,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305246,5) ->
	#base_dsgt_order{dsgt_id = 305246,consume = [{0,38065246,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305246,6) ->
	#base_dsgt_order{dsgt_id = 305246,consume = [{0,38065246,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305246,7) ->
	#base_dsgt_order{dsgt_id = 305246,consume = [{0,38065246,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305246,8) ->
	#base_dsgt_order{dsgt_id = 305246,consume = [{0,38065246,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305246,9) ->
	#base_dsgt_order{dsgt_id = 305246,consume = [{0,38065246,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305246,10) ->
	#base_dsgt_order{dsgt_id = 305246,consume = [{0,38065246,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305247,1) ->
	#base_dsgt_order{dsgt_id = 305247,consume = [{0,38065247,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305247,2) ->
	#base_dsgt_order{dsgt_id = 305247,consume = [{0,38065247,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305247,3) ->
	#base_dsgt_order{dsgt_id = 305247,consume = [{0,38065247,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305247,4) ->
	#base_dsgt_order{dsgt_id = 305247,consume = [{0,38065247,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305247,5) ->
	#base_dsgt_order{dsgt_id = 305247,consume = [{0,38065247,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305247,6) ->
	#base_dsgt_order{dsgt_id = 305247,consume = [{0,38065247,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305247,7) ->
	#base_dsgt_order{dsgt_id = 305247,consume = [{0,38065247,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305247,8) ->
	#base_dsgt_order{dsgt_id = 305247,consume = [{0,38065247,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305247,9) ->
	#base_dsgt_order{dsgt_id = 305247,consume = [{0,38065247,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305247,10) ->
	#base_dsgt_order{dsgt_id = 305247,consume = [{0,38065247,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305248,1) ->
	#base_dsgt_order{dsgt_id = 305248,consume = [{0,38065248,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305248,2) ->
	#base_dsgt_order{dsgt_id = 305248,consume = [{0,38065248,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305248,3) ->
	#base_dsgt_order{dsgt_id = 305248,consume = [{0,38065248,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305248,4) ->
	#base_dsgt_order{dsgt_id = 305248,consume = [{0,38065248,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305248,5) ->
	#base_dsgt_order{dsgt_id = 305248,consume = [{0,38065248,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305248,6) ->
	#base_dsgt_order{dsgt_id = 305248,consume = [{0,38065248,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305248,7) ->
	#base_dsgt_order{dsgt_id = 305248,consume = [{0,38065248,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305248,8) ->
	#base_dsgt_order{dsgt_id = 305248,consume = [{0,38065248,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305248,9) ->
	#base_dsgt_order{dsgt_id = 305248,consume = [{0,38065248,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305248,10) ->
	#base_dsgt_order{dsgt_id = 305248,consume = [{0,38065248,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305249,1) ->
	#base_dsgt_order{dsgt_id = 305249,consume = [{0,38065249,1}],dsgt_order = 1,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305249,2) ->
	#base_dsgt_order{dsgt_id = 305249,consume = [{0,38065249,1}],dsgt_order = 2,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305249,3) ->
	#base_dsgt_order{dsgt_id = 305249,consume = [{0,38065249,1}],dsgt_order = 3,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305249,4) ->
	#base_dsgt_order{dsgt_id = 305249,consume = [{0,38065249,1}],dsgt_order = 4,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305249,5) ->
	#base_dsgt_order{dsgt_id = 305249,consume = [{0,38065249,1}],dsgt_order = 5,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305249,6) ->
	#base_dsgt_order{dsgt_id = 305249,consume = [{0,38065249,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305249,7) ->
	#base_dsgt_order{dsgt_id = 305249,consume = [{0,38065249,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305249,8) ->
	#base_dsgt_order{dsgt_id = 305249,consume = [{0,38065249,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305249,9) ->
	#base_dsgt_order{dsgt_id = 305249,consume = [{0,38065249,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305249,10) ->
	#base_dsgt_order{dsgt_id = 305249,consume = [{0,38065249,1}],dsgt_order = 10,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305250,1) ->
	#base_dsgt_order{dsgt_id = 305250,consume = [{0,38065250,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305250,2) ->
	#base_dsgt_order{dsgt_id = 305250,consume = [{0,38065250,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305250,3) ->
	#base_dsgt_order{dsgt_id = 305250,consume = [{0,38065250,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305250,4) ->
	#base_dsgt_order{dsgt_id = 305250,consume = [{0,38065250,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305250,5) ->
	#base_dsgt_order{dsgt_id = 305250,consume = [{0,38065250,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305250,6) ->
	#base_dsgt_order{dsgt_id = 305250,consume = [{0,38065250,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305250,7) ->
	#base_dsgt_order{dsgt_id = 305250,consume = [{0,38065250,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305250,8) ->
	#base_dsgt_order{dsgt_id = 305250,consume = [{0,38065250,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305250,9) ->
	#base_dsgt_order{dsgt_id = 305250,consume = [{0,38065250,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305250,10) ->
	#base_dsgt_order{dsgt_id = 305250,consume = [{0,38065250,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305251,1) ->
	#base_dsgt_order{dsgt_id = 305251,consume = [{0,38065251,1}],dsgt_order = 1,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305251,2) ->
	#base_dsgt_order{dsgt_id = 305251,consume = [{0,38065251,1}],dsgt_order = 2,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305251,3) ->
	#base_dsgt_order{dsgt_id = 305251,consume = [{0,38065251,1}],dsgt_order = 3,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305251,4) ->
	#base_dsgt_order{dsgt_id = 305251,consume = [{0,38065251,1}],dsgt_order = 4,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305251,5) ->
	#base_dsgt_order{dsgt_id = 305251,consume = [{0,38065251,1}],dsgt_order = 5,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305251,6) ->
	#base_dsgt_order{dsgt_id = 305251,consume = [{0,38065251,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305251,7) ->
	#base_dsgt_order{dsgt_id = 305251,consume = [{0,38065251,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305251,8) ->
	#base_dsgt_order{dsgt_id = 305251,consume = [{0,38065251,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305251,9) ->
	#base_dsgt_order{dsgt_id = 305251,consume = [{0,38065251,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305251,10) ->
	#base_dsgt_order{dsgt_id = 305251,consume = [{0,38065251,1}],dsgt_order = 10,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305252,1) ->
	#base_dsgt_order{dsgt_id = 305252,consume = [{0,38065252,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305252,2) ->
	#base_dsgt_order{dsgt_id = 305252,consume = [{0,38065252,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305252,3) ->
	#base_dsgt_order{dsgt_id = 305252,consume = [{0,38065252,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305252,4) ->
	#base_dsgt_order{dsgt_id = 305252,consume = [{0,38065252,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305252,5) ->
	#base_dsgt_order{dsgt_id = 305252,consume = [{0,38065252,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305252,6) ->
	#base_dsgt_order{dsgt_id = 305252,consume = [{0,38065252,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305252,7) ->
	#base_dsgt_order{dsgt_id = 305252,consume = [{0,38065252,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305252,8) ->
	#base_dsgt_order{dsgt_id = 305252,consume = [{0,38065252,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305252,9) ->
	#base_dsgt_order{dsgt_id = 305252,consume = [{0,38065252,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305252,10) ->
	#base_dsgt_order{dsgt_id = 305252,consume = [{0,38065252,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305253,1) ->
	#base_dsgt_order{dsgt_id = 305253,consume = [{0,38065253,1}],dsgt_order = 1,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305253,2) ->
	#base_dsgt_order{dsgt_id = 305253,consume = [{0,38065253,1}],dsgt_order = 2,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305253,3) ->
	#base_dsgt_order{dsgt_id = 305253,consume = [{0,38065253,1}],dsgt_order = 3,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305253,4) ->
	#base_dsgt_order{dsgt_id = 305253,consume = [{0,38065253,1}],dsgt_order = 4,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305253,5) ->
	#base_dsgt_order{dsgt_id = 305253,consume = [{0,38065253,1}],dsgt_order = 5,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305253,6) ->
	#base_dsgt_order{dsgt_id = 305253,consume = [{0,38065253,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305253,7) ->
	#base_dsgt_order{dsgt_id = 305253,consume = [{0,38065253,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305253,8) ->
	#base_dsgt_order{dsgt_id = 305253,consume = [{0,38065253,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305253,9) ->
	#base_dsgt_order{dsgt_id = 305253,consume = [{0,38065253,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305253,10) ->
	#base_dsgt_order{dsgt_id = 305253,consume = [{0,38065253,1}],dsgt_order = 10,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305254,1) ->
	#base_dsgt_order{dsgt_id = 305254,consume = [{0,38065254,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305254,2) ->
	#base_dsgt_order{dsgt_id = 305254,consume = [{0,38065254,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305254,3) ->
	#base_dsgt_order{dsgt_id = 305254,consume = [{0,38065254,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305254,4) ->
	#base_dsgt_order{dsgt_id = 305254,consume = [{0,38065254,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305254,5) ->
	#base_dsgt_order{dsgt_id = 305254,consume = [{0,38065254,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305254,6) ->
	#base_dsgt_order{dsgt_id = 305254,consume = [{0,38065254,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305254,7) ->
	#base_dsgt_order{dsgt_id = 305254,consume = [{0,38065254,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305254,8) ->
	#base_dsgt_order{dsgt_id = 305254,consume = [{0,38065254,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305254,9) ->
	#base_dsgt_order{dsgt_id = 305254,consume = [{0,38065254,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305254,10) ->
	#base_dsgt_order{dsgt_id = 305254,consume = [{0,38065254,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305255,1) ->
	#base_dsgt_order{dsgt_id = 305255,consume = [{0,38065255,1}],dsgt_order = 1,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305255,2) ->
	#base_dsgt_order{dsgt_id = 305255,consume = [{0,38065255,1}],dsgt_order = 2,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305255,3) ->
	#base_dsgt_order{dsgt_id = 305255,consume = [{0,38065255,1}],dsgt_order = 3,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305255,4) ->
	#base_dsgt_order{dsgt_id = 305255,consume = [{0,38065255,1}],dsgt_order = 4,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305255,5) ->
	#base_dsgt_order{dsgt_id = 305255,consume = [{0,38065255,1}],dsgt_order = 5,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305255,6) ->
	#base_dsgt_order{dsgt_id = 305255,consume = [{0,38065255,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305255,7) ->
	#base_dsgt_order{dsgt_id = 305255,consume = [{0,38065255,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305255,8) ->
	#base_dsgt_order{dsgt_id = 305255,consume = [{0,38065255,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305255,9) ->
	#base_dsgt_order{dsgt_id = 305255,consume = [{0,38065255,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305255,10) ->
	#base_dsgt_order{dsgt_id = 305255,consume = [{0,38065255,1}],dsgt_order = 10,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305256,1) ->
	#base_dsgt_order{dsgt_id = 305256,consume = [{0,38065256,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305256,2) ->
	#base_dsgt_order{dsgt_id = 305256,consume = [{0,38065256,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305256,3) ->
	#base_dsgt_order{dsgt_id = 305256,consume = [{0,38065256,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305256,4) ->
	#base_dsgt_order{dsgt_id = 305256,consume = [{0,38065256,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305256,5) ->
	#base_dsgt_order{dsgt_id = 305256,consume = [{0,38065256,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305256,6) ->
	#base_dsgt_order{dsgt_id = 305256,consume = [{0,38065256,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305256,7) ->
	#base_dsgt_order{dsgt_id = 305256,consume = [{0,38065256,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305256,8) ->
	#base_dsgt_order{dsgt_id = 305256,consume = [{0,38065256,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305256,9) ->
	#base_dsgt_order{dsgt_id = 305256,consume = [{0,38065256,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305256,10) ->
	#base_dsgt_order{dsgt_id = 305256,consume = [{0,38065256,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305257,1) ->
	#base_dsgt_order{dsgt_id = 305257,consume = [{0,38065257,1}],dsgt_order = 1,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305257,2) ->
	#base_dsgt_order{dsgt_id = 305257,consume = [{0,38065257,1}],dsgt_order = 2,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305257,3) ->
	#base_dsgt_order{dsgt_id = 305257,consume = [{0,38065257,1}],dsgt_order = 3,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305257,4) ->
	#base_dsgt_order{dsgt_id = 305257,consume = [{0,38065257,1}],dsgt_order = 4,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305257,5) ->
	#base_dsgt_order{dsgt_id = 305257,consume = [{0,38065257,1}],dsgt_order = 5,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305257,6) ->
	#base_dsgt_order{dsgt_id = 305257,consume = [{0,38065257,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305257,7) ->
	#base_dsgt_order{dsgt_id = 305257,consume = [{0,38065257,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305257,8) ->
	#base_dsgt_order{dsgt_id = 305257,consume = [{0,38065257,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305257,9) ->
	#base_dsgt_order{dsgt_id = 305257,consume = [{0,38065257,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305257,10) ->
	#base_dsgt_order{dsgt_id = 305257,consume = [{0,38065257,1}],dsgt_order = 10,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305258,1) ->
	#base_dsgt_order{dsgt_id = 305258,consume = [{0,38065258,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305258,2) ->
	#base_dsgt_order{dsgt_id = 305258,consume = [{0,38065258,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305258,3) ->
	#base_dsgt_order{dsgt_id = 305258,consume = [{0,38065258,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305258,4) ->
	#base_dsgt_order{dsgt_id = 305258,consume = [{0,38065258,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305258,5) ->
	#base_dsgt_order{dsgt_id = 305258,consume = [{0,38065258,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305258,6) ->
	#base_dsgt_order{dsgt_id = 305258,consume = [{0,38065258,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305258,7) ->
	#base_dsgt_order{dsgt_id = 305258,consume = [{0,38065258,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305258,8) ->
	#base_dsgt_order{dsgt_id = 305258,consume = [{0,38065258,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305258,9) ->
	#base_dsgt_order{dsgt_id = 305258,consume = [{0,38065258,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305258,10) ->
	#base_dsgt_order{dsgt_id = 305258,consume = [{0,38065258,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305259,1) ->
	#base_dsgt_order{dsgt_id = 305259,consume = [{0,38065259,1}],dsgt_order = 1,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305259,2) ->
	#base_dsgt_order{dsgt_id = 305259,consume = [{0,38065259,1}],dsgt_order = 2,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305259,3) ->
	#base_dsgt_order{dsgt_id = 305259,consume = [{0,38065259,1}],dsgt_order = 3,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305259,4) ->
	#base_dsgt_order{dsgt_id = 305259,consume = [{0,38065259,1}],dsgt_order = 4,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305259,5) ->
	#base_dsgt_order{dsgt_id = 305259,consume = [{0,38065259,1}],dsgt_order = 5,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305259,6) ->
	#base_dsgt_order{dsgt_id = 305259,consume = [{0,38065259,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305259,7) ->
	#base_dsgt_order{dsgt_id = 305259,consume = [{0,38065259,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305259,8) ->
	#base_dsgt_order{dsgt_id = 305259,consume = [{0,38065259,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305259,9) ->
	#base_dsgt_order{dsgt_id = 305259,consume = [{0,38065259,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305259,10) ->
	#base_dsgt_order{dsgt_id = 305259,consume = [{0,38065259,1}],dsgt_order = 10,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305260,1) ->
	#base_dsgt_order{dsgt_id = 305260,consume = [{0,38065260,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305260,2) ->
	#base_dsgt_order{dsgt_id = 305260,consume = [{0,38065260,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305260,3) ->
	#base_dsgt_order{dsgt_id = 305260,consume = [{0,38065260,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305260,4) ->
	#base_dsgt_order{dsgt_id = 305260,consume = [{0,38065260,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305260,5) ->
	#base_dsgt_order{dsgt_id = 305260,consume = [{0,38065260,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305260,6) ->
	#base_dsgt_order{dsgt_id = 305260,consume = [{0,38065260,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305260,7) ->
	#base_dsgt_order{dsgt_id = 305260,consume = [{0,38065260,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305260,8) ->
	#base_dsgt_order{dsgt_id = 305260,consume = [{0,38065260,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305260,9) ->
	#base_dsgt_order{dsgt_id = 305260,consume = [{0,38065260,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305260,10) ->
	#base_dsgt_order{dsgt_id = 305260,consume = [{0,38065260,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305261,1) ->
	#base_dsgt_order{dsgt_id = 305261,consume = [{0,38065261,1}],dsgt_order = 1,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305261,2) ->
	#base_dsgt_order{dsgt_id = 305261,consume = [{0,38065261,1}],dsgt_order = 2,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305261,3) ->
	#base_dsgt_order{dsgt_id = 305261,consume = [{0,38065261,1}],dsgt_order = 3,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305261,4) ->
	#base_dsgt_order{dsgt_id = 305261,consume = [{0,38065261,1}],dsgt_order = 4,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305261,5) ->
	#base_dsgt_order{dsgt_id = 305261,consume = [{0,38065261,1}],dsgt_order = 5,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305261,6) ->
	#base_dsgt_order{dsgt_id = 305261,consume = [{0,38065261,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305261,7) ->
	#base_dsgt_order{dsgt_id = 305261,consume = [{0,38065261,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305261,8) ->
	#base_dsgt_order{dsgt_id = 305261,consume = [{0,38065261,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305261,9) ->
	#base_dsgt_order{dsgt_id = 305261,consume = [{0,38065261,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305261,10) ->
	#base_dsgt_order{dsgt_id = 305261,consume = [{0,38065261,1}],dsgt_order = 10,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305262,1) ->
	#base_dsgt_order{dsgt_id = 305262,consume = [{0,38065262,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305262,2) ->
	#base_dsgt_order{dsgt_id = 305262,consume = [{0,38065262,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305262,3) ->
	#base_dsgt_order{dsgt_id = 305262,consume = [{0,38065262,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305262,4) ->
	#base_dsgt_order{dsgt_id = 305262,consume = [{0,38065262,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305262,5) ->
	#base_dsgt_order{dsgt_id = 305262,consume = [{0,38065262,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305262,6) ->
	#base_dsgt_order{dsgt_id = 305262,consume = [{0,38065262,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305262,7) ->
	#base_dsgt_order{dsgt_id = 305262,consume = [{0,38065262,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305262,8) ->
	#base_dsgt_order{dsgt_id = 305262,consume = [{0,38065262,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305262,9) ->
	#base_dsgt_order{dsgt_id = 305262,consume = [{0,38065262,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305262,10) ->
	#base_dsgt_order{dsgt_id = 305262,consume = [{0,38065262,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305263,1) ->
	#base_dsgt_order{dsgt_id = 305263,consume = [{0,38065263,1}],dsgt_order = 1,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305263,2) ->
	#base_dsgt_order{dsgt_id = 305263,consume = [{0,38065263,1}],dsgt_order = 2,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305263,3) ->
	#base_dsgt_order{dsgt_id = 305263,consume = [{0,38065263,1}],dsgt_order = 3,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305263,4) ->
	#base_dsgt_order{dsgt_id = 305263,consume = [{0,38065263,1}],dsgt_order = 4,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305263,5) ->
	#base_dsgt_order{dsgt_id = 305263,consume = [{0,38065263,1}],dsgt_order = 5,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305263,6) ->
	#base_dsgt_order{dsgt_id = 305263,consume = [{0,38065263,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305263,7) ->
	#base_dsgt_order{dsgt_id = 305263,consume = [{0,38065263,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305263,8) ->
	#base_dsgt_order{dsgt_id = 305263,consume = [{0,38065263,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305263,9) ->
	#base_dsgt_order{dsgt_id = 305263,consume = [{0,38065263,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305263,10) ->
	#base_dsgt_order{dsgt_id = 305263,consume = [{0,38065263,1}],dsgt_order = 10,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305264,1) ->
	#base_dsgt_order{dsgt_id = 305264,consume = [{0,38065264,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305264,2) ->
	#base_dsgt_order{dsgt_id = 305264,consume = [{0,38065264,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305264,3) ->
	#base_dsgt_order{dsgt_id = 305264,consume = [{0,38065264,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305264,4) ->
	#base_dsgt_order{dsgt_id = 305264,consume = [{0,38065264,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305264,5) ->
	#base_dsgt_order{dsgt_id = 305264,consume = [{0,38065264,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305264,6) ->
	#base_dsgt_order{dsgt_id = 305264,consume = [{0,38065264,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305264,7) ->
	#base_dsgt_order{dsgt_id = 305264,consume = [{0,38065264,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305264,8) ->
	#base_dsgt_order{dsgt_id = 305264,consume = [{0,38065264,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305264,9) ->
	#base_dsgt_order{dsgt_id = 305264,consume = [{0,38065264,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305264,10) ->
	#base_dsgt_order{dsgt_id = 305264,consume = [{0,38065264,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305265,1) ->
	#base_dsgt_order{dsgt_id = 305265,consume = [{0,38065265,1}],dsgt_order = 1,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305265,2) ->
	#base_dsgt_order{dsgt_id = 305265,consume = [{0,38065265,1}],dsgt_order = 2,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305265,3) ->
	#base_dsgt_order{dsgt_id = 305265,consume = [{0,38065265,1}],dsgt_order = 3,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305265,4) ->
	#base_dsgt_order{dsgt_id = 305265,consume = [{0,38065265,1}],dsgt_order = 4,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305265,5) ->
	#base_dsgt_order{dsgt_id = 305265,consume = [{0,38065265,1}],dsgt_order = 5,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305265,6) ->
	#base_dsgt_order{dsgt_id = 305265,consume = [{0,38065265,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305265,7) ->
	#base_dsgt_order{dsgt_id = 305265,consume = [{0,38065265,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305265,8) ->
	#base_dsgt_order{dsgt_id = 305265,consume = [{0,38065265,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305265,9) ->
	#base_dsgt_order{dsgt_id = 305265,consume = [{0,38065265,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305265,10) ->
	#base_dsgt_order{dsgt_id = 305265,consume = [{0,38065265,1}],dsgt_order = 10,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305266,1) ->
	#base_dsgt_order{dsgt_id = 305266,consume = [{0,38065266,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305266,2) ->
	#base_dsgt_order{dsgt_id = 305266,consume = [{0,38065266,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305266,3) ->
	#base_dsgt_order{dsgt_id = 305266,consume = [{0,38065266,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305266,4) ->
	#base_dsgt_order{dsgt_id = 305266,consume = [{0,38065266,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305266,5) ->
	#base_dsgt_order{dsgt_id = 305266,consume = [{0,38065266,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305266,6) ->
	#base_dsgt_order{dsgt_id = 305266,consume = [{0,38065266,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305266,7) ->
	#base_dsgt_order{dsgt_id = 305266,consume = [{0,38065266,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305266,8) ->
	#base_dsgt_order{dsgt_id = 305266,consume = [{0,38065266,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305266,9) ->
	#base_dsgt_order{dsgt_id = 305266,consume = [{0,38065266,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305266,10) ->
	#base_dsgt_order{dsgt_id = 305266,consume = [{0,38065266,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305267,1) ->
	#base_dsgt_order{dsgt_id = 305267,consume = [{0,38065267,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305267,2) ->
	#base_dsgt_order{dsgt_id = 305267,consume = [{0,38065267,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305267,3) ->
	#base_dsgt_order{dsgt_id = 305267,consume = [{0,38065267,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305267,4) ->
	#base_dsgt_order{dsgt_id = 305267,consume = [{0,38065267,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305267,5) ->
	#base_dsgt_order{dsgt_id = 305267,consume = [{0,38065267,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305267,6) ->
	#base_dsgt_order{dsgt_id = 305267,consume = [{0,38065267,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305267,7) ->
	#base_dsgt_order{dsgt_id = 305267,consume = [{0,38065267,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305267,8) ->
	#base_dsgt_order{dsgt_id = 305267,consume = [{0,38065267,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305267,9) ->
	#base_dsgt_order{dsgt_id = 305267,consume = [{0,38065267,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305267,10) ->
	#base_dsgt_order{dsgt_id = 305267,consume = [{0,38065267,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305268,1) ->
	#base_dsgt_order{dsgt_id = 305268,consume = [{0,38065268,1}],dsgt_order = 1,attr_list = [{1,200},{2,20000},{4,200},{3,600}]};

get_by_id_order(305268,2) ->
	#base_dsgt_order{dsgt_id = 305268,consume = [{0,38065268,1}],dsgt_order = 2,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305268,3) ->
	#base_dsgt_order{dsgt_id = 305268,consume = [{0,38065268,1}],dsgt_order = 3,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305268,4) ->
	#base_dsgt_order{dsgt_id = 305268,consume = [{0,38065268,1}],dsgt_order = 4,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305268,5) ->
	#base_dsgt_order{dsgt_id = 305268,consume = [{0,38065268,1}],dsgt_order = 5,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305268,6) ->
	#base_dsgt_order{dsgt_id = 305268,consume = [{0,38065268,1}],dsgt_order = 6,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305268,7) ->
	#base_dsgt_order{dsgt_id = 305268,consume = [{0,38065268,1}],dsgt_order = 7,attr_list = [{1,1400},{2,140000},{4,1400},{3,4200}]};

get_by_id_order(305268,8) ->
	#base_dsgt_order{dsgt_id = 305268,consume = [{0,38065268,1}],dsgt_order = 8,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305268,9) ->
	#base_dsgt_order{dsgt_id = 305268,consume = [{0,38065268,1}],dsgt_order = 9,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305268,10) ->
	#base_dsgt_order{dsgt_id = 305268,consume = [{0,38065268,1}],dsgt_order = 10,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305269,1) ->
	#base_dsgt_order{dsgt_id = 305269,consume = [{0,38065269,1}],dsgt_order = 1,attr_list = [{1,200},{2,20000},{4,200},{3,600}]};

get_by_id_order(305269,2) ->
	#base_dsgt_order{dsgt_id = 305269,consume = [{0,38065269,1}],dsgt_order = 2,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305269,3) ->
	#base_dsgt_order{dsgt_id = 305269,consume = [{0,38065269,1}],dsgt_order = 3,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305269,4) ->
	#base_dsgt_order{dsgt_id = 305269,consume = [{0,38065269,1}],dsgt_order = 4,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305269,5) ->
	#base_dsgt_order{dsgt_id = 305269,consume = [{0,38065269,1}],dsgt_order = 5,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305269,6) ->
	#base_dsgt_order{dsgt_id = 305269,consume = [{0,38065269,1}],dsgt_order = 6,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305269,7) ->
	#base_dsgt_order{dsgt_id = 305269,consume = [{0,38065269,1}],dsgt_order = 7,attr_list = [{1,1400},{2,140000},{4,1400},{3,4200}]};

get_by_id_order(305269,8) ->
	#base_dsgt_order{dsgt_id = 305269,consume = [{0,38065269,1}],dsgt_order = 8,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305269,9) ->
	#base_dsgt_order{dsgt_id = 305269,consume = [{0,38065269,1}],dsgt_order = 9,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305269,10) ->
	#base_dsgt_order{dsgt_id = 305269,consume = [{0,38065269,1}],dsgt_order = 10,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305270,1) ->
	#base_dsgt_order{dsgt_id = 305270,consume = [{0,38065270,1}],dsgt_order = 1,attr_list = [{1,200},{2,20000},{4,200},{3,600}]};

get_by_id_order(305270,2) ->
	#base_dsgt_order{dsgt_id = 305270,consume = [{0,38065270,1}],dsgt_order = 2,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305270,3) ->
	#base_dsgt_order{dsgt_id = 305270,consume = [{0,38065270,1}],dsgt_order = 3,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305270,4) ->
	#base_dsgt_order{dsgt_id = 305270,consume = [{0,38065270,1}],dsgt_order = 4,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305270,5) ->
	#base_dsgt_order{dsgt_id = 305270,consume = [{0,38065270,1}],dsgt_order = 5,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305270,6) ->
	#base_dsgt_order{dsgt_id = 305270,consume = [{0,38065270,1}],dsgt_order = 6,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305270,7) ->
	#base_dsgt_order{dsgt_id = 305270,consume = [{0,38065270,1}],dsgt_order = 7,attr_list = [{1,1400},{2,140000},{4,1400},{3,4200}]};

get_by_id_order(305270,8) ->
	#base_dsgt_order{dsgt_id = 305270,consume = [{0,38065270,1}],dsgt_order = 8,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305270,9) ->
	#base_dsgt_order{dsgt_id = 305270,consume = [{0,38065270,1}],dsgt_order = 9,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305270,10) ->
	#base_dsgt_order{dsgt_id = 305270,consume = [{0,38065270,1}],dsgt_order = 10,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305271,1) ->
	#base_dsgt_order{dsgt_id = 305271,consume = [{0,38065271,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305271,2) ->
	#base_dsgt_order{dsgt_id = 305271,consume = [{0,38065271,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305271,3) ->
	#base_dsgt_order{dsgt_id = 305271,consume = [{0,38065271,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305271,4) ->
	#base_dsgt_order{dsgt_id = 305271,consume = [{0,38065271,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305271,5) ->
	#base_dsgt_order{dsgt_id = 305271,consume = [{0,38065271,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305271,6) ->
	#base_dsgt_order{dsgt_id = 305271,consume = [{0,38065271,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305271,7) ->
	#base_dsgt_order{dsgt_id = 305271,consume = [{0,38065271,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305271,8) ->
	#base_dsgt_order{dsgt_id = 305271,consume = [{0,38065271,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305271,9) ->
	#base_dsgt_order{dsgt_id = 305271,consume = [{0,38065271,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305271,10) ->
	#base_dsgt_order{dsgt_id = 305271,consume = [{0,38065271,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305276,1) ->
	#base_dsgt_order{dsgt_id = 305276,consume = [{0,38065276,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305276,2) ->
	#base_dsgt_order{dsgt_id = 305276,consume = [{0,38065276,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305276,3) ->
	#base_dsgt_order{dsgt_id = 305276,consume = [{0,38065276,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305276,4) ->
	#base_dsgt_order{dsgt_id = 305276,consume = [{0,38065276,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305276,5) ->
	#base_dsgt_order{dsgt_id = 305276,consume = [{0,38065276,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305276,6) ->
	#base_dsgt_order{dsgt_id = 305276,consume = [{0,38065276,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305276,7) ->
	#base_dsgt_order{dsgt_id = 305276,consume = [{0,38065276,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305276,8) ->
	#base_dsgt_order{dsgt_id = 305276,consume = [{0,38065276,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305276,9) ->
	#base_dsgt_order{dsgt_id = 305276,consume = [{0,38065276,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305276,10) ->
	#base_dsgt_order{dsgt_id = 305276,consume = [{0,38065276,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305277,1) ->
	#base_dsgt_order{dsgt_id = 305277,consume = [{0,38065277,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305277,2) ->
	#base_dsgt_order{dsgt_id = 305277,consume = [{0,38065277,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305277,3) ->
	#base_dsgt_order{dsgt_id = 305277,consume = [{0,38065277,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305277,4) ->
	#base_dsgt_order{dsgt_id = 305277,consume = [{0,38065277,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305277,5) ->
	#base_dsgt_order{dsgt_id = 305277,consume = [{0,38065277,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305277,6) ->
	#base_dsgt_order{dsgt_id = 305277,consume = [{0,38065277,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305277,7) ->
	#base_dsgt_order{dsgt_id = 305277,consume = [{0,38065277,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305277,8) ->
	#base_dsgt_order{dsgt_id = 305277,consume = [{0,38065277,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305277,9) ->
	#base_dsgt_order{dsgt_id = 305277,consume = [{0,38065277,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305277,10) ->
	#base_dsgt_order{dsgt_id = 305277,consume = [{0,38065277,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305278,1) ->
	#base_dsgt_order{dsgt_id = 305278,consume = [{0,38065278,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305278,2) ->
	#base_dsgt_order{dsgt_id = 305278,consume = [{0,38065278,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305278,3) ->
	#base_dsgt_order{dsgt_id = 305278,consume = [{0,38065278,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305278,4) ->
	#base_dsgt_order{dsgt_id = 305278,consume = [{0,38065278,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305278,5) ->
	#base_dsgt_order{dsgt_id = 305278,consume = [{0,38065278,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305278,6) ->
	#base_dsgt_order{dsgt_id = 305278,consume = [{0,38065278,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305278,7) ->
	#base_dsgt_order{dsgt_id = 305278,consume = [{0,38065278,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305278,8) ->
	#base_dsgt_order{dsgt_id = 305278,consume = [{0,38065278,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305278,9) ->
	#base_dsgt_order{dsgt_id = 305278,consume = [{0,38065278,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305278,10) ->
	#base_dsgt_order{dsgt_id = 305278,consume = [{0,38065278,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305279,1) ->
	#base_dsgt_order{dsgt_id = 305279,consume = [{0,38065279,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305279,2) ->
	#base_dsgt_order{dsgt_id = 305279,consume = [{0,38065279,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305279,3) ->
	#base_dsgt_order{dsgt_id = 305279,consume = [{0,38065279,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305279,4) ->
	#base_dsgt_order{dsgt_id = 305279,consume = [{0,38065279,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305279,5) ->
	#base_dsgt_order{dsgt_id = 305279,consume = [{0,38065279,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305279,6) ->
	#base_dsgt_order{dsgt_id = 305279,consume = [{0,38065279,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305279,7) ->
	#base_dsgt_order{dsgt_id = 305279,consume = [{0,38065279,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305279,8) ->
	#base_dsgt_order{dsgt_id = 305279,consume = [{0,38065279,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305279,9) ->
	#base_dsgt_order{dsgt_id = 305279,consume = [{0,38065279,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305279,10) ->
	#base_dsgt_order{dsgt_id = 305279,consume = [{0,38065279,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305280,1) ->
	#base_dsgt_order{dsgt_id = 305280,consume = [{0,38065280,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305280,2) ->
	#base_dsgt_order{dsgt_id = 305280,consume = [{0,38065280,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305280,3) ->
	#base_dsgt_order{dsgt_id = 305280,consume = [{0,38065280,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305280,4) ->
	#base_dsgt_order{dsgt_id = 305280,consume = [{0,38065280,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305280,5) ->
	#base_dsgt_order{dsgt_id = 305280,consume = [{0,38065280,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305280,6) ->
	#base_dsgt_order{dsgt_id = 305280,consume = [{0,38065280,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305280,7) ->
	#base_dsgt_order{dsgt_id = 305280,consume = [{0,38065280,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305280,8) ->
	#base_dsgt_order{dsgt_id = 305280,consume = [{0,38065280,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305280,9) ->
	#base_dsgt_order{dsgt_id = 305280,consume = [{0,38065280,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305280,10) ->
	#base_dsgt_order{dsgt_id = 305280,consume = [{0,38065280,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305281,1) ->
	#base_dsgt_order{dsgt_id = 305281,consume = [{0,38065281,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305281,2) ->
	#base_dsgt_order{dsgt_id = 305281,consume = [{0,38065281,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305281,3) ->
	#base_dsgt_order{dsgt_id = 305281,consume = [{0,38065281,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305281,4) ->
	#base_dsgt_order{dsgt_id = 305281,consume = [{0,38065281,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305281,5) ->
	#base_dsgt_order{dsgt_id = 305281,consume = [{0,38065281,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305281,6) ->
	#base_dsgt_order{dsgt_id = 305281,consume = [{0,38065281,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305281,7) ->
	#base_dsgt_order{dsgt_id = 305281,consume = [{0,38065281,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305281,8) ->
	#base_dsgt_order{dsgt_id = 305281,consume = [{0,38065281,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305281,9) ->
	#base_dsgt_order{dsgt_id = 305281,consume = [{0,38065281,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305281,10) ->
	#base_dsgt_order{dsgt_id = 305281,consume = [{0,38065281,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305282,1) ->
	#base_dsgt_order{dsgt_id = 305282,consume = [{0,38065282,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305282,2) ->
	#base_dsgt_order{dsgt_id = 305282,consume = [{0,38065282,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305282,3) ->
	#base_dsgt_order{dsgt_id = 305282,consume = [{0,38065282,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305282,4) ->
	#base_dsgt_order{dsgt_id = 305282,consume = [{0,38065282,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305282,5) ->
	#base_dsgt_order{dsgt_id = 305282,consume = [{0,38065282,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305282,6) ->
	#base_dsgt_order{dsgt_id = 305282,consume = [{0,38065282,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305282,7) ->
	#base_dsgt_order{dsgt_id = 305282,consume = [{0,38065282,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305282,8) ->
	#base_dsgt_order{dsgt_id = 305282,consume = [{0,38065282,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305282,9) ->
	#base_dsgt_order{dsgt_id = 305282,consume = [{0,38065282,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305282,10) ->
	#base_dsgt_order{dsgt_id = 305282,consume = [{0,38065282,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305283,1) ->
	#base_dsgt_order{dsgt_id = 305283,consume = [{0,38065283,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305283,2) ->
	#base_dsgt_order{dsgt_id = 305283,consume = [{0,38065283,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305283,3) ->
	#base_dsgt_order{dsgt_id = 305283,consume = [{0,38065283,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305283,4) ->
	#base_dsgt_order{dsgt_id = 305283,consume = [{0,38065283,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305283,5) ->
	#base_dsgt_order{dsgt_id = 305283,consume = [{0,38065283,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305283,6) ->
	#base_dsgt_order{dsgt_id = 305283,consume = [{0,38065283,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305283,7) ->
	#base_dsgt_order{dsgt_id = 305283,consume = [{0,38065283,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305283,8) ->
	#base_dsgt_order{dsgt_id = 305283,consume = [{0,38065283,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305283,9) ->
	#base_dsgt_order{dsgt_id = 305283,consume = [{0,38065283,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305283,10) ->
	#base_dsgt_order{dsgt_id = 305283,consume = [{0,38065283,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305284,1) ->
	#base_dsgt_order{dsgt_id = 305284,consume = [{0,38065284,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305284,2) ->
	#base_dsgt_order{dsgt_id = 305284,consume = [{0,38065284,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305284,3) ->
	#base_dsgt_order{dsgt_id = 305284,consume = [{0,38065284,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305284,4) ->
	#base_dsgt_order{dsgt_id = 305284,consume = [{0,38065284,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305284,5) ->
	#base_dsgt_order{dsgt_id = 305284,consume = [{0,38065284,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305284,6) ->
	#base_dsgt_order{dsgt_id = 305284,consume = [{0,38065284,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305284,7) ->
	#base_dsgt_order{dsgt_id = 305284,consume = [{0,38065284,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305284,8) ->
	#base_dsgt_order{dsgt_id = 305284,consume = [{0,38065284,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305284,9) ->
	#base_dsgt_order{dsgt_id = 305284,consume = [{0,38065284,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305284,10) ->
	#base_dsgt_order{dsgt_id = 305284,consume = [{0,38065284,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305285,1) ->
	#base_dsgt_order{dsgt_id = 305285,consume = [{0,38065285,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305285,2) ->
	#base_dsgt_order{dsgt_id = 305285,consume = [{0,38065285,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305285,3) ->
	#base_dsgt_order{dsgt_id = 305285,consume = [{0,38065285,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305285,4) ->
	#base_dsgt_order{dsgt_id = 305285,consume = [{0,38065285,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305285,5) ->
	#base_dsgt_order{dsgt_id = 305285,consume = [{0,38065285,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305285,6) ->
	#base_dsgt_order{dsgt_id = 305285,consume = [{0,38065285,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305285,7) ->
	#base_dsgt_order{dsgt_id = 305285,consume = [{0,38065285,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305285,8) ->
	#base_dsgt_order{dsgt_id = 305285,consume = [{0,38065285,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305285,9) ->
	#base_dsgt_order{dsgt_id = 305285,consume = [{0,38065285,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305285,10) ->
	#base_dsgt_order{dsgt_id = 305285,consume = [{0,38065285,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305286,1) ->
	#base_dsgt_order{dsgt_id = 305286,consume = [{0,38065286,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305286,2) ->
	#base_dsgt_order{dsgt_id = 305286,consume = [{0,38065286,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305286,3) ->
	#base_dsgt_order{dsgt_id = 305286,consume = [{0,38065286,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305286,4) ->
	#base_dsgt_order{dsgt_id = 305286,consume = [{0,38065286,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305286,5) ->
	#base_dsgt_order{dsgt_id = 305286,consume = [{0,38065286,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305286,6) ->
	#base_dsgt_order{dsgt_id = 305286,consume = [{0,38065286,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305286,7) ->
	#base_dsgt_order{dsgt_id = 305286,consume = [{0,38065286,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305286,8) ->
	#base_dsgt_order{dsgt_id = 305286,consume = [{0,38065286,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305286,9) ->
	#base_dsgt_order{dsgt_id = 305286,consume = [{0,38065286,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305286,10) ->
	#base_dsgt_order{dsgt_id = 305286,consume = [{0,38065286,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305287,1) ->
	#base_dsgt_order{dsgt_id = 305287,consume = [{0,38065287,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305287,2) ->
	#base_dsgt_order{dsgt_id = 305287,consume = [{0,38065287,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305287,3) ->
	#base_dsgt_order{dsgt_id = 305287,consume = [{0,38065287,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305287,4) ->
	#base_dsgt_order{dsgt_id = 305287,consume = [{0,38065287,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305287,5) ->
	#base_dsgt_order{dsgt_id = 305287,consume = [{0,38065287,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305287,6) ->
	#base_dsgt_order{dsgt_id = 305287,consume = [{0,38065287,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305287,7) ->
	#base_dsgt_order{dsgt_id = 305287,consume = [{0,38065287,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305287,8) ->
	#base_dsgt_order{dsgt_id = 305287,consume = [{0,38065287,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305287,9) ->
	#base_dsgt_order{dsgt_id = 305287,consume = [{0,38065287,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305287,10) ->
	#base_dsgt_order{dsgt_id = 305287,consume = [{0,38065287,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305288,1) ->
	#base_dsgt_order{dsgt_id = 305288,consume = [{0,38065288,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305288,2) ->
	#base_dsgt_order{dsgt_id = 305288,consume = [{0,38065288,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305288,3) ->
	#base_dsgt_order{dsgt_id = 305288,consume = [{0,38065288,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305288,4) ->
	#base_dsgt_order{dsgt_id = 305288,consume = [{0,38065288,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305288,5) ->
	#base_dsgt_order{dsgt_id = 305288,consume = [{0,38065288,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305288,6) ->
	#base_dsgt_order{dsgt_id = 305288,consume = [{0,38065288,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305288,7) ->
	#base_dsgt_order{dsgt_id = 305288,consume = [{0,38065288,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305288,8) ->
	#base_dsgt_order{dsgt_id = 305288,consume = [{0,38065288,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305288,9) ->
	#base_dsgt_order{dsgt_id = 305288,consume = [{0,38065288,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305288,10) ->
	#base_dsgt_order{dsgt_id = 305288,consume = [{0,38065288,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305289,1) ->
	#base_dsgt_order{dsgt_id = 305289,consume = [{0,38065289,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305289,2) ->
	#base_dsgt_order{dsgt_id = 305289,consume = [{0,38065289,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305289,3) ->
	#base_dsgt_order{dsgt_id = 305289,consume = [{0,38065289,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305289,4) ->
	#base_dsgt_order{dsgt_id = 305289,consume = [{0,38065289,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305289,5) ->
	#base_dsgt_order{dsgt_id = 305289,consume = [{0,38065289,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305289,6) ->
	#base_dsgt_order{dsgt_id = 305289,consume = [{0,38065289,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305289,7) ->
	#base_dsgt_order{dsgt_id = 305289,consume = [{0,38065289,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305289,8) ->
	#base_dsgt_order{dsgt_id = 305289,consume = [{0,38065289,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305289,9) ->
	#base_dsgt_order{dsgt_id = 305289,consume = [{0,38065289,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305289,10) ->
	#base_dsgt_order{dsgt_id = 305289,consume = [{0,38065289,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305290,1) ->
	#base_dsgt_order{dsgt_id = 305290,consume = [{0,38065290,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305290,2) ->
	#base_dsgt_order{dsgt_id = 305290,consume = [{0,38065290,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305290,3) ->
	#base_dsgt_order{dsgt_id = 305290,consume = [{0,38065290,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305290,4) ->
	#base_dsgt_order{dsgt_id = 305290,consume = [{0,38065290,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305290,5) ->
	#base_dsgt_order{dsgt_id = 305290,consume = [{0,38065290,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305290,6) ->
	#base_dsgt_order{dsgt_id = 305290,consume = [{0,38065290,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305290,7) ->
	#base_dsgt_order{dsgt_id = 305290,consume = [{0,38065290,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305290,8) ->
	#base_dsgt_order{dsgt_id = 305290,consume = [{0,38065290,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305290,9) ->
	#base_dsgt_order{dsgt_id = 305290,consume = [{0,38065290,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305290,10) ->
	#base_dsgt_order{dsgt_id = 305290,consume = [{0,38065290,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305291,1) ->
	#base_dsgt_order{dsgt_id = 305291,consume = [{0,38065291,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305291,2) ->
	#base_dsgt_order{dsgt_id = 305291,consume = [{0,38065291,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305291,3) ->
	#base_dsgt_order{dsgt_id = 305291,consume = [{0,38065291,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305291,4) ->
	#base_dsgt_order{dsgt_id = 305291,consume = [{0,38065291,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305291,5) ->
	#base_dsgt_order{dsgt_id = 305291,consume = [{0,38065291,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305291,6) ->
	#base_dsgt_order{dsgt_id = 305291,consume = [{0,38065291,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305291,7) ->
	#base_dsgt_order{dsgt_id = 305291,consume = [{0,38065291,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305291,8) ->
	#base_dsgt_order{dsgt_id = 305291,consume = [{0,38065291,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305291,9) ->
	#base_dsgt_order{dsgt_id = 305291,consume = [{0,38065291,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305291,10) ->
	#base_dsgt_order{dsgt_id = 305291,consume = [{0,38065291,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305292,1) ->
	#base_dsgt_order{dsgt_id = 305292,consume = [{0,38065292,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305292,2) ->
	#base_dsgt_order{dsgt_id = 305292,consume = [{0,38065292,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305292,3) ->
	#base_dsgt_order{dsgt_id = 305292,consume = [{0,38065292,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305292,4) ->
	#base_dsgt_order{dsgt_id = 305292,consume = [{0,38065292,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305292,5) ->
	#base_dsgt_order{dsgt_id = 305292,consume = [{0,38065292,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305292,6) ->
	#base_dsgt_order{dsgt_id = 305292,consume = [{0,38065292,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305292,7) ->
	#base_dsgt_order{dsgt_id = 305292,consume = [{0,38065292,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305292,8) ->
	#base_dsgt_order{dsgt_id = 305292,consume = [{0,38065292,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305292,9) ->
	#base_dsgt_order{dsgt_id = 305292,consume = [{0,38065292,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305292,10) ->
	#base_dsgt_order{dsgt_id = 305292,consume = [{0,38065292,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305293,1) ->
	#base_dsgt_order{dsgt_id = 305293,consume = [{0,38065293,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305293,2) ->
	#base_dsgt_order{dsgt_id = 305293,consume = [{0,38065293,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305293,3) ->
	#base_dsgt_order{dsgt_id = 305293,consume = [{0,38065293,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305293,4) ->
	#base_dsgt_order{dsgt_id = 305293,consume = [{0,38065293,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305293,5) ->
	#base_dsgt_order{dsgt_id = 305293,consume = [{0,38065293,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305293,6) ->
	#base_dsgt_order{dsgt_id = 305293,consume = [{0,38065293,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305293,7) ->
	#base_dsgt_order{dsgt_id = 305293,consume = [{0,38065293,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305293,8) ->
	#base_dsgt_order{dsgt_id = 305293,consume = [{0,38065293,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305293,9) ->
	#base_dsgt_order{dsgt_id = 305293,consume = [{0,38065293,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305293,10) ->
	#base_dsgt_order{dsgt_id = 305293,consume = [{0,38065293,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305294,1) ->
	#base_dsgt_order{dsgt_id = 305294,consume = [{0,38065294,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305294,2) ->
	#base_dsgt_order{dsgt_id = 305294,consume = [{0,38065294,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305294,3) ->
	#base_dsgt_order{dsgt_id = 305294,consume = [{0,38065294,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305294,4) ->
	#base_dsgt_order{dsgt_id = 305294,consume = [{0,38065294,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305294,5) ->
	#base_dsgt_order{dsgt_id = 305294,consume = [{0,38065294,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305294,6) ->
	#base_dsgt_order{dsgt_id = 305294,consume = [{0,38065294,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305294,7) ->
	#base_dsgt_order{dsgt_id = 305294,consume = [{0,38065294,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305294,8) ->
	#base_dsgt_order{dsgt_id = 305294,consume = [{0,38065294,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305294,9) ->
	#base_dsgt_order{dsgt_id = 305294,consume = [{0,38065294,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305294,10) ->
	#base_dsgt_order{dsgt_id = 305294,consume = [{0,38065294,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305295,1) ->
	#base_dsgt_order{dsgt_id = 305295,consume = [{0,38065295,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305295,2) ->
	#base_dsgt_order{dsgt_id = 305295,consume = [{0,38065295,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305295,3) ->
	#base_dsgt_order{dsgt_id = 305295,consume = [{0,38065295,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305295,4) ->
	#base_dsgt_order{dsgt_id = 305295,consume = [{0,38065295,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305295,5) ->
	#base_dsgt_order{dsgt_id = 305295,consume = [{0,38065295,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305295,6) ->
	#base_dsgt_order{dsgt_id = 305295,consume = [{0,38065295,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305295,7) ->
	#base_dsgt_order{dsgt_id = 305295,consume = [{0,38065295,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305295,8) ->
	#base_dsgt_order{dsgt_id = 305295,consume = [{0,38065295,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305295,9) ->
	#base_dsgt_order{dsgt_id = 305295,consume = [{0,38065295,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305295,10) ->
	#base_dsgt_order{dsgt_id = 305295,consume = [{0,38065295,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305296,1) ->
	#base_dsgt_order{dsgt_id = 305296,consume = [{0,38065296,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305296,2) ->
	#base_dsgt_order{dsgt_id = 305296,consume = [{0,38065296,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305296,3) ->
	#base_dsgt_order{dsgt_id = 305296,consume = [{0,38065296,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305296,4) ->
	#base_dsgt_order{dsgt_id = 305296,consume = [{0,38065296,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305296,5) ->
	#base_dsgt_order{dsgt_id = 305296,consume = [{0,38065296,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305296,6) ->
	#base_dsgt_order{dsgt_id = 305296,consume = [{0,38065296,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305296,7) ->
	#base_dsgt_order{dsgt_id = 305296,consume = [{0,38065296,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305296,8) ->
	#base_dsgt_order{dsgt_id = 305296,consume = [{0,38065296,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305296,9) ->
	#base_dsgt_order{dsgt_id = 305296,consume = [{0,38065296,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305296,10) ->
	#base_dsgt_order{dsgt_id = 305296,consume = [{0,38065296,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305297,1) ->
	#base_dsgt_order{dsgt_id = 305297,consume = [{0,38065297,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305297,2) ->
	#base_dsgt_order{dsgt_id = 305297,consume = [{0,38065297,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305297,3) ->
	#base_dsgt_order{dsgt_id = 305297,consume = [{0,38065297,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305297,4) ->
	#base_dsgt_order{dsgt_id = 305297,consume = [{0,38065297,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305297,5) ->
	#base_dsgt_order{dsgt_id = 305297,consume = [{0,38065297,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305297,6) ->
	#base_dsgt_order{dsgt_id = 305297,consume = [{0,38065297,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305297,7) ->
	#base_dsgt_order{dsgt_id = 305297,consume = [{0,38065297,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305297,8) ->
	#base_dsgt_order{dsgt_id = 305297,consume = [{0,38065297,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305297,9) ->
	#base_dsgt_order{dsgt_id = 305297,consume = [{0,38065297,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305297,10) ->
	#base_dsgt_order{dsgt_id = 305297,consume = [{0,38065297,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305298,1) ->
	#base_dsgt_order{dsgt_id = 305298,consume = [{0,38065298,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305298,2) ->
	#base_dsgt_order{dsgt_id = 305298,consume = [{0,38065298,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305298,3) ->
	#base_dsgt_order{dsgt_id = 305298,consume = [{0,38065298,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305298,4) ->
	#base_dsgt_order{dsgt_id = 305298,consume = [{0,38065298,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305298,5) ->
	#base_dsgt_order{dsgt_id = 305298,consume = [{0,38065298,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305298,6) ->
	#base_dsgt_order{dsgt_id = 305298,consume = [{0,38065298,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305298,7) ->
	#base_dsgt_order{dsgt_id = 305298,consume = [{0,38065298,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305298,8) ->
	#base_dsgt_order{dsgt_id = 305298,consume = [{0,38065298,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305298,9) ->
	#base_dsgt_order{dsgt_id = 305298,consume = [{0,38065298,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305298,10) ->
	#base_dsgt_order{dsgt_id = 305298,consume = [{0,38065298,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305299,1) ->
	#base_dsgt_order{dsgt_id = 305299,consume = [{0,38065299,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305299,2) ->
	#base_dsgt_order{dsgt_id = 305299,consume = [{0,38065299,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305299,3) ->
	#base_dsgt_order{dsgt_id = 305299,consume = [{0,38065299,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305299,4) ->
	#base_dsgt_order{dsgt_id = 305299,consume = [{0,38065299,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305299,5) ->
	#base_dsgt_order{dsgt_id = 305299,consume = [{0,38065299,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305299,6) ->
	#base_dsgt_order{dsgt_id = 305299,consume = [{0,38065299,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305299,7) ->
	#base_dsgt_order{dsgt_id = 305299,consume = [{0,38065299,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305299,8) ->
	#base_dsgt_order{dsgt_id = 305299,consume = [{0,38065299,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305299,9) ->
	#base_dsgt_order{dsgt_id = 305299,consume = [{0,38065299,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305299,10) ->
	#base_dsgt_order{dsgt_id = 305299,consume = [{0,38065299,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305300,1) ->
	#base_dsgt_order{dsgt_id = 305300,consume = [{0,38065300,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305300,2) ->
	#base_dsgt_order{dsgt_id = 305300,consume = [{0,38065300,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305300,3) ->
	#base_dsgt_order{dsgt_id = 305300,consume = [{0,38065300,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305300,4) ->
	#base_dsgt_order{dsgt_id = 305300,consume = [{0,38065300,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305300,5) ->
	#base_dsgt_order{dsgt_id = 305300,consume = [{0,38065300,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305300,6) ->
	#base_dsgt_order{dsgt_id = 305300,consume = [{0,38065300,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305300,7) ->
	#base_dsgt_order{dsgt_id = 305300,consume = [{0,38065300,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305300,8) ->
	#base_dsgt_order{dsgt_id = 305300,consume = [{0,38065300,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305300,9) ->
	#base_dsgt_order{dsgt_id = 305300,consume = [{0,38065300,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305300,10) ->
	#base_dsgt_order{dsgt_id = 305300,consume = [{0,38065300,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305301,1) ->
	#base_dsgt_order{dsgt_id = 305301,consume = [{0,38065301,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305301,2) ->
	#base_dsgt_order{dsgt_id = 305301,consume = [{0,38065301,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305301,3) ->
	#base_dsgt_order{dsgt_id = 305301,consume = [{0,38065301,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305301,4) ->
	#base_dsgt_order{dsgt_id = 305301,consume = [{0,38065301,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305301,5) ->
	#base_dsgt_order{dsgt_id = 305301,consume = [{0,38065301,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305301,6) ->
	#base_dsgt_order{dsgt_id = 305301,consume = [{0,38065301,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305301,7) ->
	#base_dsgt_order{dsgt_id = 305301,consume = [{0,38065301,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305301,8) ->
	#base_dsgt_order{dsgt_id = 305301,consume = [{0,38065301,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305301,9) ->
	#base_dsgt_order{dsgt_id = 305301,consume = [{0,38065301,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305301,10) ->
	#base_dsgt_order{dsgt_id = 305301,consume = [{0,38065301,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305302,1) ->
	#base_dsgt_order{dsgt_id = 305302,consume = [{0,38065302,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305302,2) ->
	#base_dsgt_order{dsgt_id = 305302,consume = [{0,38065302,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305302,3) ->
	#base_dsgt_order{dsgt_id = 305302,consume = [{0,38065302,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305302,4) ->
	#base_dsgt_order{dsgt_id = 305302,consume = [{0,38065302,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305302,5) ->
	#base_dsgt_order{dsgt_id = 305302,consume = [{0,38065302,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305302,6) ->
	#base_dsgt_order{dsgt_id = 305302,consume = [{0,38065302,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305302,7) ->
	#base_dsgt_order{dsgt_id = 305302,consume = [{0,38065302,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305302,8) ->
	#base_dsgt_order{dsgt_id = 305302,consume = [{0,38065302,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305302,9) ->
	#base_dsgt_order{dsgt_id = 305302,consume = [{0,38065302,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305302,10) ->
	#base_dsgt_order{dsgt_id = 305302,consume = [{0,38065302,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305303,1) ->
	#base_dsgt_order{dsgt_id = 305303,consume = [{0,38065303,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305303,2) ->
	#base_dsgt_order{dsgt_id = 305303,consume = [{0,38065303,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305303,3) ->
	#base_dsgt_order{dsgt_id = 305303,consume = [{0,38065303,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305303,4) ->
	#base_dsgt_order{dsgt_id = 305303,consume = [{0,38065303,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305303,5) ->
	#base_dsgt_order{dsgt_id = 305303,consume = [{0,38065303,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305303,6) ->
	#base_dsgt_order{dsgt_id = 305303,consume = [{0,38065303,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305303,7) ->
	#base_dsgt_order{dsgt_id = 305303,consume = [{0,38065303,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305303,8) ->
	#base_dsgt_order{dsgt_id = 305303,consume = [{0,38065303,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305303,9) ->
	#base_dsgt_order{dsgt_id = 305303,consume = [{0,38065303,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305303,10) ->
	#base_dsgt_order{dsgt_id = 305303,consume = [{0,38065303,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305304,1) ->
	#base_dsgt_order{dsgt_id = 305304,consume = [{0,38065304,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305304,2) ->
	#base_dsgt_order{dsgt_id = 305304,consume = [{0,38065304,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305304,3) ->
	#base_dsgt_order{dsgt_id = 305304,consume = [{0,38065304,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305304,4) ->
	#base_dsgt_order{dsgt_id = 305304,consume = [{0,38065304,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305304,5) ->
	#base_dsgt_order{dsgt_id = 305304,consume = [{0,38065304,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305304,6) ->
	#base_dsgt_order{dsgt_id = 305304,consume = [{0,38065304,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305304,7) ->
	#base_dsgt_order{dsgt_id = 305304,consume = [{0,38065304,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305304,8) ->
	#base_dsgt_order{dsgt_id = 305304,consume = [{0,38065304,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305304,9) ->
	#base_dsgt_order{dsgt_id = 305304,consume = [{0,38065304,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305304,10) ->
	#base_dsgt_order{dsgt_id = 305304,consume = [{0,38065304,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305305,1) ->
	#base_dsgt_order{dsgt_id = 305305,consume = [{0,38065305,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305305,2) ->
	#base_dsgt_order{dsgt_id = 305305,consume = [{0,38065305,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305305,3) ->
	#base_dsgt_order{dsgt_id = 305305,consume = [{0,38065305,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305305,4) ->
	#base_dsgt_order{dsgt_id = 305305,consume = [{0,38065305,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305305,5) ->
	#base_dsgt_order{dsgt_id = 305305,consume = [{0,38065305,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305305,6) ->
	#base_dsgt_order{dsgt_id = 305305,consume = [{0,38065305,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305305,7) ->
	#base_dsgt_order{dsgt_id = 305305,consume = [{0,38065305,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305305,8) ->
	#base_dsgt_order{dsgt_id = 305305,consume = [{0,38065305,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305305,9) ->
	#base_dsgt_order{dsgt_id = 305305,consume = [{0,38065305,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305305,10) ->
	#base_dsgt_order{dsgt_id = 305305,consume = [{0,38065305,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305306,1) ->
	#base_dsgt_order{dsgt_id = 305306,consume = [{0,38065306,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305306,2) ->
	#base_dsgt_order{dsgt_id = 305306,consume = [{0,38065306,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305306,3) ->
	#base_dsgt_order{dsgt_id = 305306,consume = [{0,38065306,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305306,4) ->
	#base_dsgt_order{dsgt_id = 305306,consume = [{0,38065306,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305306,5) ->
	#base_dsgt_order{dsgt_id = 305306,consume = [{0,38065306,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305306,6) ->
	#base_dsgt_order{dsgt_id = 305306,consume = [{0,38065306,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305306,7) ->
	#base_dsgt_order{dsgt_id = 305306,consume = [{0,38065306,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305306,8) ->
	#base_dsgt_order{dsgt_id = 305306,consume = [{0,38065306,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305306,9) ->
	#base_dsgt_order{dsgt_id = 305306,consume = [{0,38065306,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305306,10) ->
	#base_dsgt_order{dsgt_id = 305306,consume = [{0,38065306,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305307,1) ->
	#base_dsgt_order{dsgt_id = 305307,consume = [{0,38065307,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305307,2) ->
	#base_dsgt_order{dsgt_id = 305307,consume = [{0,38065307,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305307,3) ->
	#base_dsgt_order{dsgt_id = 305307,consume = [{0,38065307,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305307,4) ->
	#base_dsgt_order{dsgt_id = 305307,consume = [{0,38065307,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305307,5) ->
	#base_dsgt_order{dsgt_id = 305307,consume = [{0,38065307,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305307,6) ->
	#base_dsgt_order{dsgt_id = 305307,consume = [{0,38065307,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305307,7) ->
	#base_dsgt_order{dsgt_id = 305307,consume = [{0,38065307,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305307,8) ->
	#base_dsgt_order{dsgt_id = 305307,consume = [{0,38065307,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305307,9) ->
	#base_dsgt_order{dsgt_id = 305307,consume = [{0,38065307,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305307,10) ->
	#base_dsgt_order{dsgt_id = 305307,consume = [{0,38065307,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305308,1) ->
	#base_dsgt_order{dsgt_id = 305308,consume = [{0,38065308,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305308,2) ->
	#base_dsgt_order{dsgt_id = 305308,consume = [{0,38065308,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305308,3) ->
	#base_dsgt_order{dsgt_id = 305308,consume = [{0,38065308,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305308,4) ->
	#base_dsgt_order{dsgt_id = 305308,consume = [{0,38065308,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305308,5) ->
	#base_dsgt_order{dsgt_id = 305308,consume = [{0,38065308,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305308,6) ->
	#base_dsgt_order{dsgt_id = 305308,consume = [{0,38065308,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305308,7) ->
	#base_dsgt_order{dsgt_id = 305308,consume = [{0,38065308,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305308,8) ->
	#base_dsgt_order{dsgt_id = 305308,consume = [{0,38065308,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305308,9) ->
	#base_dsgt_order{dsgt_id = 305308,consume = [{0,38065308,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305308,10) ->
	#base_dsgt_order{dsgt_id = 305308,consume = [{0,38065308,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305309,1) ->
	#base_dsgt_order{dsgt_id = 305309,consume = [{0,38065309,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305309,2) ->
	#base_dsgt_order{dsgt_id = 305309,consume = [{0,38065309,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305309,3) ->
	#base_dsgt_order{dsgt_id = 305309,consume = [{0,38065309,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305309,4) ->
	#base_dsgt_order{dsgt_id = 305309,consume = [{0,38065309,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305309,5) ->
	#base_dsgt_order{dsgt_id = 305309,consume = [{0,38065309,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305309,6) ->
	#base_dsgt_order{dsgt_id = 305309,consume = [{0,38065309,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305309,7) ->
	#base_dsgt_order{dsgt_id = 305309,consume = [{0,38065309,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305309,8) ->
	#base_dsgt_order{dsgt_id = 305309,consume = [{0,38065309,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305309,9) ->
	#base_dsgt_order{dsgt_id = 305309,consume = [{0,38065309,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305309,10) ->
	#base_dsgt_order{dsgt_id = 305309,consume = [{0,38065309,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305310,1) ->
	#base_dsgt_order{dsgt_id = 305310,consume = [{0,38065310,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305310,2) ->
	#base_dsgt_order{dsgt_id = 305310,consume = [{0,38065310,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305310,3) ->
	#base_dsgt_order{dsgt_id = 305310,consume = [{0,38065310,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305310,4) ->
	#base_dsgt_order{dsgt_id = 305310,consume = [{0,38065310,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305310,5) ->
	#base_dsgt_order{dsgt_id = 305310,consume = [{0,38065310,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305310,6) ->
	#base_dsgt_order{dsgt_id = 305310,consume = [{0,38065310,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305310,7) ->
	#base_dsgt_order{dsgt_id = 305310,consume = [{0,38065310,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305310,8) ->
	#base_dsgt_order{dsgt_id = 305310,consume = [{0,38065310,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305310,9) ->
	#base_dsgt_order{dsgt_id = 305310,consume = [{0,38065310,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305310,10) ->
	#base_dsgt_order{dsgt_id = 305310,consume = [{0,38065310,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305311,1) ->
	#base_dsgt_order{dsgt_id = 305311,consume = [{0,38065311,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305311,2) ->
	#base_dsgt_order{dsgt_id = 305311,consume = [{0,38065311,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305311,3) ->
	#base_dsgt_order{dsgt_id = 305311,consume = [{0,38065311,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305311,4) ->
	#base_dsgt_order{dsgt_id = 305311,consume = [{0,38065311,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305311,5) ->
	#base_dsgt_order{dsgt_id = 305311,consume = [{0,38065311,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305311,6) ->
	#base_dsgt_order{dsgt_id = 305311,consume = [{0,38065311,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305311,7) ->
	#base_dsgt_order{dsgt_id = 305311,consume = [{0,38065311,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305311,8) ->
	#base_dsgt_order{dsgt_id = 305311,consume = [{0,38065311,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305311,9) ->
	#base_dsgt_order{dsgt_id = 305311,consume = [{0,38065311,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305311,10) ->
	#base_dsgt_order{dsgt_id = 305311,consume = [{0,38065311,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305312,1) ->
	#base_dsgt_order{dsgt_id = 305312,consume = [{0,38065312,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305312,2) ->
	#base_dsgt_order{dsgt_id = 305312,consume = [{0,38065312,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305312,3) ->
	#base_dsgt_order{dsgt_id = 305312,consume = [{0,38065312,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305312,4) ->
	#base_dsgt_order{dsgt_id = 305312,consume = [{0,38065312,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305312,5) ->
	#base_dsgt_order{dsgt_id = 305312,consume = [{0,38065312,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305312,6) ->
	#base_dsgt_order{dsgt_id = 305312,consume = [{0,38065312,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305312,7) ->
	#base_dsgt_order{dsgt_id = 305312,consume = [{0,38065312,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305312,8) ->
	#base_dsgt_order{dsgt_id = 305312,consume = [{0,38065312,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305312,9) ->
	#base_dsgt_order{dsgt_id = 305312,consume = [{0,38065312,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305312,10) ->
	#base_dsgt_order{dsgt_id = 305312,consume = [{0,38065312,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305313,1) ->
	#base_dsgt_order{dsgt_id = 305313,consume = [{0,38065313,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305313,2) ->
	#base_dsgt_order{dsgt_id = 305313,consume = [{0,38065313,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305313,3) ->
	#base_dsgt_order{dsgt_id = 305313,consume = [{0,38065313,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305313,4) ->
	#base_dsgt_order{dsgt_id = 305313,consume = [{0,38065313,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305313,5) ->
	#base_dsgt_order{dsgt_id = 305313,consume = [{0,38065313,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305313,6) ->
	#base_dsgt_order{dsgt_id = 305313,consume = [{0,38065313,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305313,7) ->
	#base_dsgt_order{dsgt_id = 305313,consume = [{0,38065313,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305313,8) ->
	#base_dsgt_order{dsgt_id = 305313,consume = [{0,38065313,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305313,9) ->
	#base_dsgt_order{dsgt_id = 305313,consume = [{0,38065313,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305313,10) ->
	#base_dsgt_order{dsgt_id = 305313,consume = [{0,38065313,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305314,1) ->
	#base_dsgt_order{dsgt_id = 305314,consume = [{0,38065314,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305314,2) ->
	#base_dsgt_order{dsgt_id = 305314,consume = [{0,38065314,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305314,3) ->
	#base_dsgt_order{dsgt_id = 305314,consume = [{0,38065314,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305314,4) ->
	#base_dsgt_order{dsgt_id = 305314,consume = [{0,38065314,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305314,5) ->
	#base_dsgt_order{dsgt_id = 305314,consume = [{0,38065314,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305314,6) ->
	#base_dsgt_order{dsgt_id = 305314,consume = [{0,38065314,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305314,7) ->
	#base_dsgt_order{dsgt_id = 305314,consume = [{0,38065314,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305314,8) ->
	#base_dsgt_order{dsgt_id = 305314,consume = [{0,38065314,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305314,9) ->
	#base_dsgt_order{dsgt_id = 305314,consume = [{0,38065314,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305314,10) ->
	#base_dsgt_order{dsgt_id = 305314,consume = [{0,38065314,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305315,1) ->
	#base_dsgt_order{dsgt_id = 305315,consume = [{0,38065315,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305315,2) ->
	#base_dsgt_order{dsgt_id = 305315,consume = [{0,38065315,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305315,3) ->
	#base_dsgt_order{dsgt_id = 305315,consume = [{0,38065315,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305315,4) ->
	#base_dsgt_order{dsgt_id = 305315,consume = [{0,38065315,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305315,5) ->
	#base_dsgt_order{dsgt_id = 305315,consume = [{0,38065315,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305315,6) ->
	#base_dsgt_order{dsgt_id = 305315,consume = [{0,38065315,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305315,7) ->
	#base_dsgt_order{dsgt_id = 305315,consume = [{0,38065315,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305315,8) ->
	#base_dsgt_order{dsgt_id = 305315,consume = [{0,38065315,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305315,9) ->
	#base_dsgt_order{dsgt_id = 305315,consume = [{0,38065315,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305315,10) ->
	#base_dsgt_order{dsgt_id = 305315,consume = [{0,38065315,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305316,1) ->
	#base_dsgt_order{dsgt_id = 305316,consume = [{0,38065316,1}],dsgt_order = 1,attr_list = [{1,300},{2,30000},{4,300},{3,900}]};

get_by_id_order(305316,2) ->
	#base_dsgt_order{dsgt_id = 305316,consume = [{0,38065316,1}],dsgt_order = 2,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305316,3) ->
	#base_dsgt_order{dsgt_id = 305316,consume = [{0,38065316,1}],dsgt_order = 3,attr_list = [{1,900},{2,90000},{4,900},{3,2700}]};

get_by_id_order(305316,4) ->
	#base_dsgt_order{dsgt_id = 305316,consume = [{0,38065316,1}],dsgt_order = 4,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305316,5) ->
	#base_dsgt_order{dsgt_id = 305316,consume = [{0,38065316,1}],dsgt_order = 5,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305316,6) ->
	#base_dsgt_order{dsgt_id = 305316,consume = [{0,38065316,1}],dsgt_order = 6,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305316,7) ->
	#base_dsgt_order{dsgt_id = 305316,consume = [{0,38065316,1}],dsgt_order = 7,attr_list = [{1,2100},{2,210000},{4,2100},{3,6300}]};

get_by_id_order(305316,8) ->
	#base_dsgt_order{dsgt_id = 305316,consume = [{0,38065316,1}],dsgt_order = 8,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305316,9) ->
	#base_dsgt_order{dsgt_id = 305316,consume = [{0,38065316,1}],dsgt_order = 9,attr_list = [{1,2700},{2,270000},{4,2700},{3,8100}]};

get_by_id_order(305316,10) ->
	#base_dsgt_order{dsgt_id = 305316,consume = [{0,38065316,1}],dsgt_order = 10,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305317,1) ->
	#base_dsgt_order{dsgt_id = 305317,consume = [{0,38065317,1}],dsgt_order = 1,attr_list = [{1,300},{2,30000},{4,300},{3,900}]};

get_by_id_order(305317,2) ->
	#base_dsgt_order{dsgt_id = 305317,consume = [{0,38065317,1}],dsgt_order = 2,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305317,3) ->
	#base_dsgt_order{dsgt_id = 305317,consume = [{0,38065317,1}],dsgt_order = 3,attr_list = [{1,900},{2,90000},{4,900},{3,2700}]};

get_by_id_order(305317,4) ->
	#base_dsgt_order{dsgt_id = 305317,consume = [{0,38065317,1}],dsgt_order = 4,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305317,5) ->
	#base_dsgt_order{dsgt_id = 305317,consume = [{0,38065317,1}],dsgt_order = 5,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305317,6) ->
	#base_dsgt_order{dsgt_id = 305317,consume = [{0,38065317,1}],dsgt_order = 6,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305317,7) ->
	#base_dsgt_order{dsgt_id = 305317,consume = [{0,38065317,1}],dsgt_order = 7,attr_list = [{1,2100},{2,210000},{4,2100},{3,6300}]};

get_by_id_order(305317,8) ->
	#base_dsgt_order{dsgt_id = 305317,consume = [{0,38065317,1}],dsgt_order = 8,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305317,9) ->
	#base_dsgt_order{dsgt_id = 305317,consume = [{0,38065317,1}],dsgt_order = 9,attr_list = [{1,2700},{2,270000},{4,2700},{3,8100}]};

get_by_id_order(305317,10) ->
	#base_dsgt_order{dsgt_id = 305317,consume = [{0,38065317,1}],dsgt_order = 10,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305318,1) ->
	#base_dsgt_order{dsgt_id = 305318,consume = [{0,38065318,1}],dsgt_order = 1,attr_list = [{1,300},{2,30000},{4,300},{3,900}]};

get_by_id_order(305318,2) ->
	#base_dsgt_order{dsgt_id = 305318,consume = [{0,38065318,1}],dsgt_order = 2,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305318,3) ->
	#base_dsgt_order{dsgt_id = 305318,consume = [{0,38065318,1}],dsgt_order = 3,attr_list = [{1,900},{2,90000},{4,900},{3,2700}]};

get_by_id_order(305318,4) ->
	#base_dsgt_order{dsgt_id = 305318,consume = [{0,38065318,1}],dsgt_order = 4,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305318,5) ->
	#base_dsgt_order{dsgt_id = 305318,consume = [{0,38065318,1}],dsgt_order = 5,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305318,6) ->
	#base_dsgt_order{dsgt_id = 305318,consume = [{0,38065318,1}],dsgt_order = 6,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305318,7) ->
	#base_dsgt_order{dsgt_id = 305318,consume = [{0,38065318,1}],dsgt_order = 7,attr_list = [{1,2100},{2,210000},{4,2100},{3,6300}]};

get_by_id_order(305318,8) ->
	#base_dsgt_order{dsgt_id = 305318,consume = [{0,38065318,1}],dsgt_order = 8,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305318,9) ->
	#base_dsgt_order{dsgt_id = 305318,consume = [{0,38065318,1}],dsgt_order = 9,attr_list = [{1,2700},{2,270000},{4,2700},{3,8100}]};

get_by_id_order(305318,10) ->
	#base_dsgt_order{dsgt_id = 305318,consume = [{0,38065318,1}],dsgt_order = 10,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305319,1) ->
	#base_dsgt_order{dsgt_id = 305319,consume = [{0,38065319,1}],dsgt_order = 1,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305319,2) ->
	#base_dsgt_order{dsgt_id = 305319,consume = [{0,38065319,1}],dsgt_order = 2,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305319,3) ->
	#base_dsgt_order{dsgt_id = 305319,consume = [{0,38065319,1}],dsgt_order = 3,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305319,4) ->
	#base_dsgt_order{dsgt_id = 305319,consume = [{0,38065319,1}],dsgt_order = 4,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305319,5) ->
	#base_dsgt_order{dsgt_id = 305319,consume = [{0,38065319,1}],dsgt_order = 5,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305319,6) ->
	#base_dsgt_order{dsgt_id = 305319,consume = [{0,38065319,1}],dsgt_order = 6,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305319,7) ->
	#base_dsgt_order{dsgt_id = 305319,consume = [{0,38065319,1}],dsgt_order = 7,attr_list = [{1,2800},{2,280000},{4,2800},{3,8400}]};

get_by_id_order(305319,8) ->
	#base_dsgt_order{dsgt_id = 305319,consume = [{0,38065319,1}],dsgt_order = 8,attr_list = [{1,3200},{2,320000},{4,3200},{3,9600}]};

get_by_id_order(305319,9) ->
	#base_dsgt_order{dsgt_id = 305319,consume = [{0,38065319,1}],dsgt_order = 9,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305319,10) ->
	#base_dsgt_order{dsgt_id = 305319,consume = [{0,38065319,1}],dsgt_order = 10,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305320,1) ->
	#base_dsgt_order{dsgt_id = 305320,consume = [{0,38065320,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305320,2) ->
	#base_dsgt_order{dsgt_id = 305320,consume = [{0,38065320,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305320,3) ->
	#base_dsgt_order{dsgt_id = 305320,consume = [{0,38065320,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305320,4) ->
	#base_dsgt_order{dsgt_id = 305320,consume = [{0,38065320,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305320,5) ->
	#base_dsgt_order{dsgt_id = 305320,consume = [{0,38065320,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305320,6) ->
	#base_dsgt_order{dsgt_id = 305320,consume = [{0,38065320,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305320,7) ->
	#base_dsgt_order{dsgt_id = 305320,consume = [{0,38065320,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305320,8) ->
	#base_dsgt_order{dsgt_id = 305320,consume = [{0,38065320,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305320,9) ->
	#base_dsgt_order{dsgt_id = 305320,consume = [{0,38065320,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305320,10) ->
	#base_dsgt_order{dsgt_id = 305320,consume = [{0,38065320,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305321,1) ->
	#base_dsgt_order{dsgt_id = 305321,consume = [{0,38065321,1}],dsgt_order = 1,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305321,2) ->
	#base_dsgt_order{dsgt_id = 305321,consume = [{0,38065321,1}],dsgt_order = 2,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305321,3) ->
	#base_dsgt_order{dsgt_id = 305321,consume = [{0,38065321,1}],dsgt_order = 3,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305321,4) ->
	#base_dsgt_order{dsgt_id = 305321,consume = [{0,38065321,1}],dsgt_order = 4,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305321,5) ->
	#base_dsgt_order{dsgt_id = 305321,consume = [{0,38065321,1}],dsgt_order = 5,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305321,6) ->
	#base_dsgt_order{dsgt_id = 305321,consume = [{0,38065321,1}],dsgt_order = 6,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305321,7) ->
	#base_dsgt_order{dsgt_id = 305321,consume = [{0,38065321,1}],dsgt_order = 7,attr_list = [{1,2800},{2,280000},{4,2800},{3,8400}]};

get_by_id_order(305321,8) ->
	#base_dsgt_order{dsgt_id = 305321,consume = [{0,38065321,1}],dsgt_order = 8,attr_list = [{1,3200},{2,320000},{4,3200},{3,9600}]};

get_by_id_order(305321,9) ->
	#base_dsgt_order{dsgt_id = 305321,consume = [{0,38065321,1}],dsgt_order = 9,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305321,10) ->
	#base_dsgt_order{dsgt_id = 305321,consume = [{0,38065321,1}],dsgt_order = 10,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305322,1) ->
	#base_dsgt_order{dsgt_id = 305322,consume = [{0,38065322,1}],dsgt_order = 1,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305322,2) ->
	#base_dsgt_order{dsgt_id = 305322,consume = [{0,38065322,1}],dsgt_order = 2,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305322,3) ->
	#base_dsgt_order{dsgt_id = 305322,consume = [{0,38065322,1}],dsgt_order = 3,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305322,4) ->
	#base_dsgt_order{dsgt_id = 305322,consume = [{0,38065322,1}],dsgt_order = 4,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305322,5) ->
	#base_dsgt_order{dsgt_id = 305322,consume = [{0,38065322,1}],dsgt_order = 5,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305322,6) ->
	#base_dsgt_order{dsgt_id = 305322,consume = [{0,38065322,1}],dsgt_order = 6,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305322,7) ->
	#base_dsgt_order{dsgt_id = 305322,consume = [{0,38065322,1}],dsgt_order = 7,attr_list = [{1,2800},{2,280000},{4,2800},{3,8400}]};

get_by_id_order(305322,8) ->
	#base_dsgt_order{dsgt_id = 305322,consume = [{0,38065322,1}],dsgt_order = 8,attr_list = [{1,3200},{2,320000},{4,3200},{3,9600}]};

get_by_id_order(305322,9) ->
	#base_dsgt_order{dsgt_id = 305322,consume = [{0,38065322,1}],dsgt_order = 9,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305322,10) ->
	#base_dsgt_order{dsgt_id = 305322,consume = [{0,38065322,1}],dsgt_order = 10,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305323,1) ->
	#base_dsgt_order{dsgt_id = 305323,consume = [{0,38065323,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305323,2) ->
	#base_dsgt_order{dsgt_id = 305323,consume = [{0,38065323,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305323,3) ->
	#base_dsgt_order{dsgt_id = 305323,consume = [{0,38065323,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305323,4) ->
	#base_dsgt_order{dsgt_id = 305323,consume = [{0,38065323,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305323,5) ->
	#base_dsgt_order{dsgt_id = 305323,consume = [{0,38065323,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305323,6) ->
	#base_dsgt_order{dsgt_id = 305323,consume = [{0,38065323,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305323,7) ->
	#base_dsgt_order{dsgt_id = 305323,consume = [{0,38065323,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305323,8) ->
	#base_dsgt_order{dsgt_id = 305323,consume = [{0,38065323,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305323,9) ->
	#base_dsgt_order{dsgt_id = 305323,consume = [{0,38065323,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305323,10) ->
	#base_dsgt_order{dsgt_id = 305323,consume = [{0,38065323,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305324,1) ->
	#base_dsgt_order{dsgt_id = 305324,consume = [{0,38065324,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305324,2) ->
	#base_dsgt_order{dsgt_id = 305324,consume = [{0,38065324,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305324,3) ->
	#base_dsgt_order{dsgt_id = 305324,consume = [{0,38065324,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305324,4) ->
	#base_dsgt_order{dsgt_id = 305324,consume = [{0,38065324,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305324,5) ->
	#base_dsgt_order{dsgt_id = 305324,consume = [{0,38065324,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305324,6) ->
	#base_dsgt_order{dsgt_id = 305324,consume = [{0,38065324,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305324,7) ->
	#base_dsgt_order{dsgt_id = 305324,consume = [{0,38065324,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305324,8) ->
	#base_dsgt_order{dsgt_id = 305324,consume = [{0,38065324,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305324,9) ->
	#base_dsgt_order{dsgt_id = 305324,consume = [{0,38065324,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305324,10) ->
	#base_dsgt_order{dsgt_id = 305324,consume = [{0,38065324,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305325,1) ->
	#base_dsgt_order{dsgt_id = 305325,consume = [{0,38065325,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305325,2) ->
	#base_dsgt_order{dsgt_id = 305325,consume = [{0,38065325,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305325,3) ->
	#base_dsgt_order{dsgt_id = 305325,consume = [{0,38065325,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305325,4) ->
	#base_dsgt_order{dsgt_id = 305325,consume = [{0,38065325,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305325,5) ->
	#base_dsgt_order{dsgt_id = 305325,consume = [{0,38065325,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305325,6) ->
	#base_dsgt_order{dsgt_id = 305325,consume = [{0,38065325,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305325,7) ->
	#base_dsgt_order{dsgt_id = 305325,consume = [{0,38065325,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305325,8) ->
	#base_dsgt_order{dsgt_id = 305325,consume = [{0,38065325,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305325,9) ->
	#base_dsgt_order{dsgt_id = 305325,consume = [{0,38065325,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305325,10) ->
	#base_dsgt_order{dsgt_id = 305325,consume = [{0,38065325,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305326,1) ->
	#base_dsgt_order{dsgt_id = 305326,consume = [{0,38065326,1}],dsgt_order = 1,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305326,2) ->
	#base_dsgt_order{dsgt_id = 305326,consume = [{0,38065326,1}],dsgt_order = 2,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305326,3) ->
	#base_dsgt_order{dsgt_id = 305326,consume = [{0,38065326,1}],dsgt_order = 3,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305326,4) ->
	#base_dsgt_order{dsgt_id = 305326,consume = [{0,38065326,1}],dsgt_order = 4,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305326,5) ->
	#base_dsgt_order{dsgt_id = 305326,consume = [{0,38065326,1}],dsgt_order = 5,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305326,6) ->
	#base_dsgt_order{dsgt_id = 305326,consume = [{0,38065326,1}],dsgt_order = 6,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305326,7) ->
	#base_dsgt_order{dsgt_id = 305326,consume = [{0,38065326,1}],dsgt_order = 7,attr_list = [{1,2800},{2,280000},{4,2800},{3,8400}]};

get_by_id_order(305326,8) ->
	#base_dsgt_order{dsgt_id = 305326,consume = [{0,38065326,1}],dsgt_order = 8,attr_list = [{1,3200},{2,320000},{4,3200},{3,9600}]};

get_by_id_order(305326,9) ->
	#base_dsgt_order{dsgt_id = 305326,consume = [{0,38065326,1}],dsgt_order = 9,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305326,10) ->
	#base_dsgt_order{dsgt_id = 305326,consume = [{0,38065326,1}],dsgt_order = 10,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305327,1) ->
	#base_dsgt_order{dsgt_id = 305327,consume = [{0,38065327,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305327,2) ->
	#base_dsgt_order{dsgt_id = 305327,consume = [{0,38065327,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305327,3) ->
	#base_dsgt_order{dsgt_id = 305327,consume = [{0,38065327,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305327,4) ->
	#base_dsgt_order{dsgt_id = 305327,consume = [{0,38065327,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305327,5) ->
	#base_dsgt_order{dsgt_id = 305327,consume = [{0,38065327,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305327,6) ->
	#base_dsgt_order{dsgt_id = 305327,consume = [{0,38065327,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305327,7) ->
	#base_dsgt_order{dsgt_id = 305327,consume = [{0,38065327,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305327,8) ->
	#base_dsgt_order{dsgt_id = 305327,consume = [{0,38065327,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305327,9) ->
	#base_dsgt_order{dsgt_id = 305327,consume = [{0,38065327,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305327,10) ->
	#base_dsgt_order{dsgt_id = 305327,consume = [{0,38065327,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305328,1) ->
	#base_dsgt_order{dsgt_id = 305328,consume = [{0,38065328,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305328,2) ->
	#base_dsgt_order{dsgt_id = 305328,consume = [{0,38065328,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305328,3) ->
	#base_dsgt_order{dsgt_id = 305328,consume = [{0,38065328,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305328,4) ->
	#base_dsgt_order{dsgt_id = 305328,consume = [{0,38065328,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305328,5) ->
	#base_dsgt_order{dsgt_id = 305328,consume = [{0,38065328,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305328,6) ->
	#base_dsgt_order{dsgt_id = 305328,consume = [{0,38065328,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305328,7) ->
	#base_dsgt_order{dsgt_id = 305328,consume = [{0,38065328,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305328,8) ->
	#base_dsgt_order{dsgt_id = 305328,consume = [{0,38065328,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305328,9) ->
	#base_dsgt_order{dsgt_id = 305328,consume = [{0,38065328,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305328,10) ->
	#base_dsgt_order{dsgt_id = 305328,consume = [{0,38065328,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305329,1) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305329,2) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305329,3) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305329,4) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305329,5) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305329,6) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305329,7) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305329,8) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305329,9) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305329,10) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305329,11) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305329,12) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305329,13) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305329,14) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305329,15) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305329,16) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305329,17) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305329,18) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305329,19) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305329,20) ->
	#base_dsgt_order{dsgt_id = 305329,consume = [{0,38065329,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305330,1) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305330,2) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305330,3) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305330,4) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305330,5) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305330,6) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305330,7) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305330,8) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305330,9) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305330,10) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305330,11) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305330,12) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305330,13) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305330,14) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305330,15) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305330,16) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305330,17) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305330,18) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305330,19) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305330,20) ->
	#base_dsgt_order{dsgt_id = 305330,consume = [{0,38065330,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305331,1) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305331,2) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305331,3) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305331,4) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305331,5) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305331,6) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305331,7) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305331,8) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305331,9) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305331,10) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305331,11) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305331,12) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305331,13) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305331,14) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305331,15) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305331,16) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305331,17) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305331,18) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305331,19) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305331,20) ->
	#base_dsgt_order{dsgt_id = 305331,consume = [{0,38065331,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305332,1) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305332,2) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305332,3) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305332,4) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305332,5) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305332,6) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305332,7) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305332,8) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305332,9) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305332,10) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305332,11) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305332,12) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305332,13) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305332,14) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305332,15) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305332,16) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305332,17) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305332,18) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305332,19) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305332,20) ->
	#base_dsgt_order{dsgt_id = 305332,consume = [{0,38065332,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305333,1) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305333,2) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305333,3) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305333,4) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305333,5) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305333,6) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305333,7) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305333,8) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305333,9) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305333,10) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305333,11) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305333,12) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305333,13) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305333,14) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305333,15) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305333,16) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305333,17) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305333,18) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305333,19) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305333,20) ->
	#base_dsgt_order{dsgt_id = 305333,consume = [{0,38065333,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305334,1) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305334,2) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305334,3) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305334,4) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305334,5) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305334,6) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305334,7) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305334,8) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305334,9) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305334,10) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305334,11) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305334,12) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305334,13) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305334,14) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305334,15) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305334,16) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305334,17) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305334,18) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305334,19) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305334,20) ->
	#base_dsgt_order{dsgt_id = 305334,consume = [{0,38065334,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305335,1) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305335,2) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305335,3) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305335,4) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305335,5) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305335,6) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305335,7) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305335,8) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305335,9) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305335,10) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305335,11) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305335,12) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305335,13) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305335,14) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305335,15) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305335,16) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305335,17) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305335,18) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305335,19) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305335,20) ->
	#base_dsgt_order{dsgt_id = 305335,consume = [{0,38065335,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305336,1) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305336,2) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305336,3) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305336,4) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305336,5) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305336,6) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305336,7) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305336,8) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305336,9) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305336,10) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305336,11) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305336,12) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305336,13) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305336,14) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305336,15) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305336,16) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305336,17) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305336,18) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305336,19) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305336,20) ->
	#base_dsgt_order{dsgt_id = 305336,consume = [{0,38065336,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305337,1) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305337,2) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305337,3) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305337,4) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305337,5) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305337,6) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305337,7) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305337,8) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305337,9) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305337,10) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305337,11) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305337,12) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305337,13) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305337,14) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305337,15) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305337,16) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305337,17) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305337,18) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305337,19) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305337,20) ->
	#base_dsgt_order{dsgt_id = 305337,consume = [{0,38065337,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305338,1) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305338,2) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305338,3) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305338,4) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305338,5) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305338,6) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305338,7) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305338,8) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305338,9) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305338,10) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305338,11) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305338,12) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305338,13) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305338,14) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305338,15) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305338,16) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305338,17) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305338,18) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305338,19) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305338,20) ->
	#base_dsgt_order{dsgt_id = 305338,consume = [{0,38065338,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305339,1) ->
	#base_dsgt_order{dsgt_id = 305339,consume = [{0,38065339,1}],dsgt_order = 1,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305339,2) ->
	#base_dsgt_order{dsgt_id = 305339,consume = [{0,38065339,1}],dsgt_order = 2,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305339,3) ->
	#base_dsgt_order{dsgt_id = 305339,consume = [{0,38065339,1}],dsgt_order = 3,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305339,4) ->
	#base_dsgt_order{dsgt_id = 305339,consume = [{0,38065339,1}],dsgt_order = 4,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305339,5) ->
	#base_dsgt_order{dsgt_id = 305339,consume = [{0,38065339,1}],dsgt_order = 5,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305339,6) ->
	#base_dsgt_order{dsgt_id = 305339,consume = [{0,38065339,1}],dsgt_order = 6,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305339,7) ->
	#base_dsgt_order{dsgt_id = 305339,consume = [{0,38065339,1}],dsgt_order = 7,attr_list = [{1,2800},{2,280000},{4,2800},{3,8400}]};

get_by_id_order(305339,8) ->
	#base_dsgt_order{dsgt_id = 305339,consume = [{0,38065339,1}],dsgt_order = 8,attr_list = [{1,3200},{2,320000},{4,3200},{3,9600}]};

get_by_id_order(305339,9) ->
	#base_dsgt_order{dsgt_id = 305339,consume = [{0,38065339,1}],dsgt_order = 9,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305339,10) ->
	#base_dsgt_order{dsgt_id = 305339,consume = [{0,38065339,1}],dsgt_order = 10,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305340,1) ->
	#base_dsgt_order{dsgt_id = 305340,consume = [{0,38065340,1}],dsgt_order = 1,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305340,2) ->
	#base_dsgt_order{dsgt_id = 305340,consume = [{0,38065340,1}],dsgt_order = 2,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305340,3) ->
	#base_dsgt_order{dsgt_id = 305340,consume = [{0,38065340,1}],dsgt_order = 3,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305340,4) ->
	#base_dsgt_order{dsgt_id = 305340,consume = [{0,38065340,1}],dsgt_order = 4,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305340,5) ->
	#base_dsgt_order{dsgt_id = 305340,consume = [{0,38065340,1}],dsgt_order = 5,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305340,6) ->
	#base_dsgt_order{dsgt_id = 305340,consume = [{0,38065340,1}],dsgt_order = 6,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305340,7) ->
	#base_dsgt_order{dsgt_id = 305340,consume = [{0,38065340,1}],dsgt_order = 7,attr_list = [{1,2800},{2,280000},{4,2800},{3,8400}]};

get_by_id_order(305340,8) ->
	#base_dsgt_order{dsgt_id = 305340,consume = [{0,38065340,1}],dsgt_order = 8,attr_list = [{1,3200},{2,320000},{4,3200},{3,9600}]};

get_by_id_order(305340,9) ->
	#base_dsgt_order{dsgt_id = 305340,consume = [{0,38065340,1}],dsgt_order = 9,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305340,10) ->
	#base_dsgt_order{dsgt_id = 305340,consume = [{0,38065340,1}],dsgt_order = 10,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305341,1) ->
	#base_dsgt_order{dsgt_id = 305341,consume = [{0,38065341,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305341,2) ->
	#base_dsgt_order{dsgt_id = 305341,consume = [{0,38065341,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305341,3) ->
	#base_dsgt_order{dsgt_id = 305341,consume = [{0,38065341,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305341,4) ->
	#base_dsgt_order{dsgt_id = 305341,consume = [{0,38065341,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305341,5) ->
	#base_dsgt_order{dsgt_id = 305341,consume = [{0,38065341,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305341,6) ->
	#base_dsgt_order{dsgt_id = 305341,consume = [{0,38065341,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305341,7) ->
	#base_dsgt_order{dsgt_id = 305341,consume = [{0,38065341,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305341,8) ->
	#base_dsgt_order{dsgt_id = 305341,consume = [{0,38065341,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305341,9) ->
	#base_dsgt_order{dsgt_id = 305341,consume = [{0,38065341,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305341,10) ->
	#base_dsgt_order{dsgt_id = 305341,consume = [{0,38065341,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305342,1) ->
	#base_dsgt_order{dsgt_id = 305342,consume = [{0,38065342,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305342,2) ->
	#base_dsgt_order{dsgt_id = 305342,consume = [{0,38065342,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305342,3) ->
	#base_dsgt_order{dsgt_id = 305342,consume = [{0,38065342,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305342,4) ->
	#base_dsgt_order{dsgt_id = 305342,consume = [{0,38065342,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305342,5) ->
	#base_dsgt_order{dsgt_id = 305342,consume = [{0,38065342,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305342,6) ->
	#base_dsgt_order{dsgt_id = 305342,consume = [{0,38065342,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305342,7) ->
	#base_dsgt_order{dsgt_id = 305342,consume = [{0,38065342,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305342,8) ->
	#base_dsgt_order{dsgt_id = 305342,consume = [{0,38065342,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305342,9) ->
	#base_dsgt_order{dsgt_id = 305342,consume = [{0,38065342,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305342,10) ->
	#base_dsgt_order{dsgt_id = 305342,consume = [{0,38065342,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305343,1) ->
	#base_dsgt_order{dsgt_id = 305343,consume = [{0,38065343,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305343,2) ->
	#base_dsgt_order{dsgt_id = 305343,consume = [{0,38065343,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305343,3) ->
	#base_dsgt_order{dsgt_id = 305343,consume = [{0,38065343,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305343,4) ->
	#base_dsgt_order{dsgt_id = 305343,consume = [{0,38065343,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305343,5) ->
	#base_dsgt_order{dsgt_id = 305343,consume = [{0,38065343,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305343,6) ->
	#base_dsgt_order{dsgt_id = 305343,consume = [{0,38065343,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305343,7) ->
	#base_dsgt_order{dsgt_id = 305343,consume = [{0,38065343,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305343,8) ->
	#base_dsgt_order{dsgt_id = 305343,consume = [{0,38065343,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305343,9) ->
	#base_dsgt_order{dsgt_id = 305343,consume = [{0,38065343,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305343,10) ->
	#base_dsgt_order{dsgt_id = 305343,consume = [{0,38065343,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305344,1) ->
	#base_dsgt_order{dsgt_id = 305344,consume = [{0,38065344,1}],dsgt_order = 1,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305344,2) ->
	#base_dsgt_order{dsgt_id = 305344,consume = [{0,38065344,1}],dsgt_order = 2,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305344,3) ->
	#base_dsgt_order{dsgt_id = 305344,consume = [{0,38065344,1}],dsgt_order = 3,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305344,4) ->
	#base_dsgt_order{dsgt_id = 305344,consume = [{0,38065344,1}],dsgt_order = 4,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305344,5) ->
	#base_dsgt_order{dsgt_id = 305344,consume = [{0,38065344,1}],dsgt_order = 5,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305344,6) ->
	#base_dsgt_order{dsgt_id = 305344,consume = [{0,38065344,1}],dsgt_order = 6,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305344,7) ->
	#base_dsgt_order{dsgt_id = 305344,consume = [{0,38065344,1}],dsgt_order = 7,attr_list = [{1,2800},{2,280000},{4,2800},{3,8400}]};

get_by_id_order(305344,8) ->
	#base_dsgt_order{dsgt_id = 305344,consume = [{0,38065344,1}],dsgt_order = 8,attr_list = [{1,3200},{2,320000},{4,3200},{3,9600}]};

get_by_id_order(305344,9) ->
	#base_dsgt_order{dsgt_id = 305344,consume = [{0,38065344,1}],dsgt_order = 9,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305344,10) ->
	#base_dsgt_order{dsgt_id = 305344,consume = [{0,38065344,1}],dsgt_order = 10,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305345,1) ->
	#base_dsgt_order{dsgt_id = 305345,consume = [{0,38065345,1}],dsgt_order = 1,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305345,2) ->
	#base_dsgt_order{dsgt_id = 305345,consume = [{0,38065345,1}],dsgt_order = 2,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305345,3) ->
	#base_dsgt_order{dsgt_id = 305345,consume = [{0,38065345,1}],dsgt_order = 3,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305345,4) ->
	#base_dsgt_order{dsgt_id = 305345,consume = [{0,38065345,1}],dsgt_order = 4,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305345,5) ->
	#base_dsgt_order{dsgt_id = 305345,consume = [{0,38065345,1}],dsgt_order = 5,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305345,6) ->
	#base_dsgt_order{dsgt_id = 305345,consume = [{0,38065345,1}],dsgt_order = 6,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305345,7) ->
	#base_dsgt_order{dsgt_id = 305345,consume = [{0,38065345,1}],dsgt_order = 7,attr_list = [{1,2800},{2,280000},{4,2800},{3,8400}]};

get_by_id_order(305345,8) ->
	#base_dsgt_order{dsgt_id = 305345,consume = [{0,38065345,1}],dsgt_order = 8,attr_list = [{1,3200},{2,320000},{4,3200},{3,9600}]};

get_by_id_order(305345,9) ->
	#base_dsgt_order{dsgt_id = 305345,consume = [{0,38065345,1}],dsgt_order = 9,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305345,10) ->
	#base_dsgt_order{dsgt_id = 305345,consume = [{0,38065345,1}],dsgt_order = 10,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305346,1) ->
	#base_dsgt_order{dsgt_id = 305346,consume = [{0,38065346,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305346,2) ->
	#base_dsgt_order{dsgt_id = 305346,consume = [{0,38065346,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305346,3) ->
	#base_dsgt_order{dsgt_id = 305346,consume = [{0,38065346,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305346,4) ->
	#base_dsgt_order{dsgt_id = 305346,consume = [{0,38065346,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305346,5) ->
	#base_dsgt_order{dsgt_id = 305346,consume = [{0,38065346,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305346,6) ->
	#base_dsgt_order{dsgt_id = 305346,consume = [{0,38065346,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305346,7) ->
	#base_dsgt_order{dsgt_id = 305346,consume = [{0,38065346,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305346,8) ->
	#base_dsgt_order{dsgt_id = 305346,consume = [{0,38065346,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305346,9) ->
	#base_dsgt_order{dsgt_id = 305346,consume = [{0,38065346,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305346,10) ->
	#base_dsgt_order{dsgt_id = 305346,consume = [{0,38065346,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305347,1) ->
	#base_dsgt_order{dsgt_id = 305347,consume = [{0,38065347,1}],dsgt_order = 1,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305347,2) ->
	#base_dsgt_order{dsgt_id = 305347,consume = [{0,38065347,1}],dsgt_order = 2,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305347,3) ->
	#base_dsgt_order{dsgt_id = 305347,consume = [{0,38065347,1}],dsgt_order = 3,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305347,4) ->
	#base_dsgt_order{dsgt_id = 305347,consume = [{0,38065347,1}],dsgt_order = 4,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305347,5) ->
	#base_dsgt_order{dsgt_id = 305347,consume = [{0,38065347,1}],dsgt_order = 5,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305347,6) ->
	#base_dsgt_order{dsgt_id = 305347,consume = [{0,38065347,1}],dsgt_order = 6,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305347,7) ->
	#base_dsgt_order{dsgt_id = 305347,consume = [{0,38065347,1}],dsgt_order = 7,attr_list = [{1,2800},{2,280000},{4,2800},{3,8400}]};

get_by_id_order(305347,8) ->
	#base_dsgt_order{dsgt_id = 305347,consume = [{0,38065347,1}],dsgt_order = 8,attr_list = [{1,3200},{2,320000},{4,3200},{3,9600}]};

get_by_id_order(305347,9) ->
	#base_dsgt_order{dsgt_id = 305347,consume = [{0,38065347,1}],dsgt_order = 9,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305347,10) ->
	#base_dsgt_order{dsgt_id = 305347,consume = [{0,38065347,1}],dsgt_order = 10,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305348,1) ->
	#base_dsgt_order{dsgt_id = 305348,consume = [{0,38065348,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305348,2) ->
	#base_dsgt_order{dsgt_id = 305348,consume = [{0,38065348,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305348,3) ->
	#base_dsgt_order{dsgt_id = 305348,consume = [{0,38065348,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305348,4) ->
	#base_dsgt_order{dsgt_id = 305348,consume = [{0,38065348,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305348,5) ->
	#base_dsgt_order{dsgt_id = 305348,consume = [{0,38065348,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305348,6) ->
	#base_dsgt_order{dsgt_id = 305348,consume = [{0,38065348,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305348,7) ->
	#base_dsgt_order{dsgt_id = 305348,consume = [{0,38065348,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305348,8) ->
	#base_dsgt_order{dsgt_id = 305348,consume = [{0,38065348,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305348,9) ->
	#base_dsgt_order{dsgt_id = 305348,consume = [{0,38065348,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305348,10) ->
	#base_dsgt_order{dsgt_id = 305348,consume = [{0,38065348,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305349,1) ->
	#base_dsgt_order{dsgt_id = 305349,consume = [{0,38065349,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305349,2) ->
	#base_dsgt_order{dsgt_id = 305349,consume = [{0,38065349,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305349,3) ->
	#base_dsgt_order{dsgt_id = 305349,consume = [{0,38065349,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305349,4) ->
	#base_dsgt_order{dsgt_id = 305349,consume = [{0,38065349,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305349,5) ->
	#base_dsgt_order{dsgt_id = 305349,consume = [{0,38065349,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305349,6) ->
	#base_dsgt_order{dsgt_id = 305349,consume = [{0,38065349,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305349,7) ->
	#base_dsgt_order{dsgt_id = 305349,consume = [{0,38065349,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305349,8) ->
	#base_dsgt_order{dsgt_id = 305349,consume = [{0,38065349,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305349,9) ->
	#base_dsgt_order{dsgt_id = 305349,consume = [{0,38065349,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305349,10) ->
	#base_dsgt_order{dsgt_id = 305349,consume = [{0,38065349,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305350,1) ->
	#base_dsgt_order{dsgt_id = 305350,consume = [{0,38065350,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305350,2) ->
	#base_dsgt_order{dsgt_id = 305350,consume = [{0,38065350,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305350,3) ->
	#base_dsgt_order{dsgt_id = 305350,consume = [{0,38065350,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305350,4) ->
	#base_dsgt_order{dsgt_id = 305350,consume = [{0,38065350,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305350,5) ->
	#base_dsgt_order{dsgt_id = 305350,consume = [{0,38065350,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305350,6) ->
	#base_dsgt_order{dsgt_id = 305350,consume = [{0,38065350,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305350,7) ->
	#base_dsgt_order{dsgt_id = 305350,consume = [{0,38065350,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305350,8) ->
	#base_dsgt_order{dsgt_id = 305350,consume = [{0,38065350,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305350,9) ->
	#base_dsgt_order{dsgt_id = 305350,consume = [{0,38065350,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305350,10) ->
	#base_dsgt_order{dsgt_id = 305350,consume = [{0,38065350,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305351,1) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305351,2) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305351,3) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305351,4) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305351,5) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305351,6) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305351,7) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305351,8) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305351,9) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305351,10) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305351,11) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 11,attr_list = [{1,11000},{2,1100000},{4,11000},{3,33000}]};

get_by_id_order(305351,12) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 12,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305351,13) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 13,attr_list = [{1,13000},{2,1300000},{4,13000},{3,39000}]};

get_by_id_order(305351,14) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 14,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305351,15) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 15,attr_list = [{1,15000},{2,1500000},{4,15000},{3,45000}]};

get_by_id_order(305351,16) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 16,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305351,17) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 17,attr_list = [{1,17000},{2,1700000},{4,17000},{3,51000}]};

get_by_id_order(305351,18) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 18,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305351,19) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 19,attr_list = [{1,19000},{2,1900000},{4,19000},{3,57000}]};

get_by_id_order(305351,20) ->
	#base_dsgt_order{dsgt_id = 305351,consume = [{0,38065351,1}],dsgt_order = 20,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305352,1) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305352,2) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305352,3) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305352,4) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305352,5) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305352,6) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305352,7) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305352,8) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305352,9) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305352,10) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305352,11) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 11,attr_list = [{1,11000},{2,1100000},{4,11000},{3,33000}]};

get_by_id_order(305352,12) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 12,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305352,13) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 13,attr_list = [{1,13000},{2,1300000},{4,13000},{3,39000}]};

get_by_id_order(305352,14) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 14,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305352,15) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 15,attr_list = [{1,15000},{2,1500000},{4,15000},{3,45000}]};

get_by_id_order(305352,16) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 16,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305352,17) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 17,attr_list = [{1,17000},{2,1700000},{4,17000},{3,51000}]};

get_by_id_order(305352,18) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 18,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305352,19) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 19,attr_list = [{1,19000},{2,1900000},{4,19000},{3,57000}]};

get_by_id_order(305352,20) ->
	#base_dsgt_order{dsgt_id = 305352,consume = [{0,38065352,1}],dsgt_order = 20,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305353,1) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305353,2) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305353,3) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305353,4) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305353,5) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305353,6) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305353,7) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305353,8) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305353,9) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305353,10) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305353,11) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 11,attr_list = [{1,11000},{2,1100000},{4,11000},{3,33000}]};

get_by_id_order(305353,12) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 12,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305353,13) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 13,attr_list = [{1,13000},{2,1300000},{4,13000},{3,39000}]};

get_by_id_order(305353,14) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 14,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305353,15) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 15,attr_list = [{1,15000},{2,1500000},{4,15000},{3,45000}]};

get_by_id_order(305353,16) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 16,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305353,17) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 17,attr_list = [{1,17000},{2,1700000},{4,17000},{3,51000}]};

get_by_id_order(305353,18) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 18,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305353,19) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 19,attr_list = [{1,19000},{2,1900000},{4,19000},{3,57000}]};

get_by_id_order(305353,20) ->
	#base_dsgt_order{dsgt_id = 305353,consume = [{0,38065353,1}],dsgt_order = 20,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305354,1) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305354,2) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305354,3) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305354,4) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305354,5) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305354,6) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305354,7) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305354,8) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305354,9) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305354,10) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305354,11) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 11,attr_list = [{1,11000},{2,1100000},{4,11000},{3,33000}]};

get_by_id_order(305354,12) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 12,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305354,13) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 13,attr_list = [{1,13000},{2,1300000},{4,13000},{3,39000}]};

get_by_id_order(305354,14) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 14,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305354,15) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 15,attr_list = [{1,15000},{2,1500000},{4,15000},{3,45000}]};

get_by_id_order(305354,16) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 16,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305354,17) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 17,attr_list = [{1,17000},{2,1700000},{4,17000},{3,51000}]};

get_by_id_order(305354,18) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 18,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305354,19) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 19,attr_list = [{1,19000},{2,1900000},{4,19000},{3,57000}]};

get_by_id_order(305354,20) ->
	#base_dsgt_order{dsgt_id = 305354,consume = [{0,38065354,1}],dsgt_order = 20,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305355,1) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305355,2) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305355,3) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305355,4) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305355,5) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305355,6) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305355,7) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305355,8) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305355,9) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305355,10) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305355,11) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 11,attr_list = [{1,11000},{2,1100000},{4,11000},{3,33000}]};

get_by_id_order(305355,12) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 12,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305355,13) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 13,attr_list = [{1,13000},{2,1300000},{4,13000},{3,39000}]};

get_by_id_order(305355,14) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 14,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305355,15) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 15,attr_list = [{1,15000},{2,1500000},{4,15000},{3,45000}]};

get_by_id_order(305355,16) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 16,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305355,17) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 17,attr_list = [{1,17000},{2,1700000},{4,17000},{3,51000}]};

get_by_id_order(305355,18) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 18,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305355,19) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 19,attr_list = [{1,19000},{2,1900000},{4,19000},{3,57000}]};

get_by_id_order(305355,20) ->
	#base_dsgt_order{dsgt_id = 305355,consume = [{0,38065355,1}],dsgt_order = 20,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305356,1) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305356,2) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305356,3) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305356,4) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305356,5) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305356,6) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305356,7) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305356,8) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305356,9) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305356,10) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305356,11) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 11,attr_list = [{1,11000},{2,1100000},{4,11000},{3,33000}]};

get_by_id_order(305356,12) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 12,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305356,13) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 13,attr_list = [{1,13000},{2,1300000},{4,13000},{3,39000}]};

get_by_id_order(305356,14) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 14,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305356,15) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 15,attr_list = [{1,15000},{2,1500000},{4,15000},{3,45000}]};

get_by_id_order(305356,16) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 16,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305356,17) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 17,attr_list = [{1,17000},{2,1700000},{4,17000},{3,51000}]};

get_by_id_order(305356,18) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 18,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305356,19) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 19,attr_list = [{1,19000},{2,1900000},{4,19000},{3,57000}]};

get_by_id_order(305356,20) ->
	#base_dsgt_order{dsgt_id = 305356,consume = [{0,38065356,1}],dsgt_order = 20,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305357,1) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 1,attr_list = [{1,4000},{2,400000},{4,5000},{3,11000}]};

get_by_id_order(305357,2) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 2,attr_list = [{1,8000},{2,800000},{4,10000},{3,22000}]};

get_by_id_order(305357,3) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 3,attr_list = [{1,12000},{2,1200000},{4,15000},{3,33000}]};

get_by_id_order(305357,4) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 4,attr_list = [{1,16000},{2,1600000},{4,20000},{3,44000}]};

get_by_id_order(305357,5) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 5,attr_list = [{1,20000},{2,2000000},{4,25000},{3,55000}]};

get_by_id_order(305357,6) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 6,attr_list = [{1,24000},{2,2400000},{4,30000},{3,66000}]};

get_by_id_order(305357,7) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 7,attr_list = [{1,28000},{2,2800000},{4,35000},{3,77000}]};

get_by_id_order(305357,8) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 8,attr_list = [{1,32000},{2,3200000},{4,40000},{3,88000}]};

get_by_id_order(305357,9) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 9,attr_list = [{1,36000},{2,3600000},{4,45000},{3,99000}]};

get_by_id_order(305357,10) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 10,attr_list = [{1,40000},{2,4000000},{4,50000},{3,110000}]};

get_by_id_order(305357,11) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 11,attr_list = [{1,44000},{2,4400000},{4,55000},{3,121000}]};

get_by_id_order(305357,12) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 12,attr_list = [{1,48000},{2,4800000},{4,60000},{3,132000}]};

get_by_id_order(305357,13) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 13,attr_list = [{1,52000},{2,5200000},{4,65000},{3,143000}]};

get_by_id_order(305357,14) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 14,attr_list = [{1,56000},{2,5600000},{4,70000},{3,154000}]};

get_by_id_order(305357,15) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 15,attr_list = [{1,60000},{2,6000000},{4,75000},{3,165000}]};

get_by_id_order(305357,16) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 16,attr_list = [{1,64000},{2,6400000},{4,80000},{3,176000}]};

get_by_id_order(305357,17) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 17,attr_list = [{1,68000},{2,6800000},{4,85000},{3,187000}]};

get_by_id_order(305357,18) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 18,attr_list = [{1,72000},{2,7200000},{4,90000},{3,198000}]};

get_by_id_order(305357,19) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 19,attr_list = [{1,76000},{2,7600000},{4,95000},{3,209000}]};

get_by_id_order(305357,20) ->
	#base_dsgt_order{dsgt_id = 305357,consume = [{0,38065357,1}],dsgt_order = 20,attr_list = [{1,80000},{2,8000000},{4,100000},{3,220000}]};

get_by_id_order(305358,1) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 1,attr_list = [{1,2000},{2,180000},{4,2000},{3,7000}]};

get_by_id_order(305358,2) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 2,attr_list = [{1,4000},{2,360000},{4,4000},{3,14000}]};

get_by_id_order(305358,3) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 3,attr_list = [{1,6000},{2,540000},{4,6000},{3,21000}]};

get_by_id_order(305358,4) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 4,attr_list = [{1,8000},{2,720000},{4,8000},{3,28000}]};

get_by_id_order(305358,5) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 5,attr_list = [{1,10000},{2,900000},{4,10000},{3,35000}]};

get_by_id_order(305358,6) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1080000},{4,12000},{3,42000}]};

get_by_id_order(305358,7) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1260000},{4,14000},{3,49000}]};

get_by_id_order(305358,8) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1440000},{4,16000},{3,56000}]};

get_by_id_order(305358,9) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1620000},{4,18000},{3,63000}]};

get_by_id_order(305358,10) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 10,attr_list = [{1,20000},{2,1800000},{4,20000},{3,70000}]};

get_by_id_order(305358,11) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 11,attr_list = [{1,22000},{2,1980000},{4,22000},{3,77000}]};

get_by_id_order(305358,12) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 12,attr_list = [{1,24000},{2,2160000},{4,24000},{3,84000}]};

get_by_id_order(305358,13) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 13,attr_list = [{1,26000},{2,2340000},{4,26000},{3,91000}]};

get_by_id_order(305358,14) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 14,attr_list = [{1,28000},{2,2520000},{4,28000},{3,98000}]};

get_by_id_order(305358,15) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 15,attr_list = [{1,30000},{2,2700000},{4,30000},{3,105000}]};

get_by_id_order(305358,16) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 16,attr_list = [{1,32000},{2,2880000},{4,32000},{3,112000}]};

get_by_id_order(305358,17) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 17,attr_list = [{1,34000},{2,3060000},{4,34000},{3,119000}]};

get_by_id_order(305358,18) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 18,attr_list = [{1,36000},{2,3240000},{4,36000},{3,126000}]};

get_by_id_order(305358,19) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 19,attr_list = [{1,38000},{2,3420000},{4,38000},{3,133000}]};

get_by_id_order(305358,20) ->
	#base_dsgt_order{dsgt_id = 305358,consume = [{0,38065358,1}],dsgt_order = 20,attr_list = [{1,40000},{2,3600000},{4,40000},{3,140000}]};

get_by_id_order(305359,1) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305359,2) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305359,3) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305359,4) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305359,5) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305359,6) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305359,7) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305359,8) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305359,9) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305359,10) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305359,11) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305359,12) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305359,13) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305359,14) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305359,15) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305359,16) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305359,17) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305359,18) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305359,19) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305359,20) ->
	#base_dsgt_order{dsgt_id = 305359,consume = [{0,38065359,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305360,1) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 1,attr_list = [{1,5000},{2,500000},{4,6000},{3,14000}]};

get_by_id_order(305360,2) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 2,attr_list = [{1,10000},{2,1000000},{4,12000},{3,28000}]};

get_by_id_order(305360,3) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 3,attr_list = [{1,15000},{2,1500000},{4,18000},{3,42000}]};

get_by_id_order(305360,4) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 4,attr_list = [{1,20000},{2,2000000},{4,24000},{3,56000}]};

get_by_id_order(305360,5) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 5,attr_list = [{1,25000},{2,2500000},{4,30000},{3,70000}]};

get_by_id_order(305360,6) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 6,attr_list = [{1,30000},{2,3000000},{4,36000},{3,84000}]};

get_by_id_order(305360,7) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 7,attr_list = [{1,35000},{2,3500000},{4,42000},{3,98000}]};

get_by_id_order(305360,8) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 8,attr_list = [{1,40000},{2,4000000},{4,48000},{3,112000}]};

get_by_id_order(305360,9) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 9,attr_list = [{1,45000},{2,4500000},{4,54000},{3,126000}]};

get_by_id_order(305360,10) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 10,attr_list = [{1,50000},{2,5000000},{4,60000},{3,140000}]};

get_by_id_order(305360,11) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 11,attr_list = [{1,55000},{2,5500000},{4,66000},{3,154000}]};

get_by_id_order(305360,12) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 12,attr_list = [{1,60000},{2,6000000},{4,72000},{3,168000}]};

get_by_id_order(305360,13) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 13,attr_list = [{1,65000},{2,6500000},{4,78000},{3,182000}]};

get_by_id_order(305360,14) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 14,attr_list = [{1,70000},{2,7000000},{4,84000},{3,196000}]};

get_by_id_order(305360,15) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 15,attr_list = [{1,75000},{2,7500000},{4,90000},{3,210000}]};

get_by_id_order(305360,16) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 16,attr_list = [{1,80000},{2,8000000},{4,96000},{3,224000}]};

get_by_id_order(305360,17) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 17,attr_list = [{1,85000},{2,8500000},{4,102000},{3,238000}]};

get_by_id_order(305360,18) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 18,attr_list = [{1,90000},{2,9000000},{4,108000},{3,252000}]};

get_by_id_order(305360,19) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 19,attr_list = [{1,95000},{2,9500000},{4,114000},{3,266000}]};

get_by_id_order(305360,20) ->
	#base_dsgt_order{dsgt_id = 305360,consume = [{0,38065360,1}],dsgt_order = 20,attr_list = [{1,100000},{2,10000000},{4,120000},{3,280000}]};

get_by_id_order(305361,1) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 1,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305361,2) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 2,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305361,3) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 3,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305361,4) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 4,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305361,5) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 5,attr_list = [{1,15000},{2,1500000},{4,15000},{3,45000}]};

get_by_id_order(305361,6) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 6,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305361,7) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 7,attr_list = [{1,21000},{2,2100000},{4,21000},{3,63000}]};

get_by_id_order(305361,8) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 8,attr_list = [{1,24000},{2,2400000},{4,24000},{3,72000}]};

get_by_id_order(305361,9) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 9,attr_list = [{1,27000},{2,2700000},{4,27000},{3,81000}]};

get_by_id_order(305361,10) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 10,attr_list = [{1,30000},{2,3000000},{4,30000},{3,90000}]};

get_by_id_order(305361,11) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 11,attr_list = [{1,33000},{2,3300000},{4,33000},{3,99000}]};

get_by_id_order(305361,12) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 12,attr_list = [{1,36000},{2,3600000},{4,36000},{3,108000}]};

get_by_id_order(305361,13) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 13,attr_list = [{1,39000},{2,3900000},{4,39000},{3,117000}]};

get_by_id_order(305361,14) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 14,attr_list = [{1,42000},{2,4200000},{4,42000},{3,126000}]};

get_by_id_order(305361,15) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 15,attr_list = [{1,45000},{2,4500000},{4,45000},{3,135000}]};

get_by_id_order(305361,16) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 16,attr_list = [{1,48000},{2,4800000},{4,48000},{3,144000}]};

get_by_id_order(305361,17) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 17,attr_list = [{1,51000},{2,5100000},{4,51000},{3,153000}]};

get_by_id_order(305361,18) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 18,attr_list = [{1,54000},{2,5400000},{4,54000},{3,162000}]};

get_by_id_order(305361,19) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 19,attr_list = [{1,57000},{2,5700000},{4,57000},{3,171000}]};

get_by_id_order(305361,20) ->
	#base_dsgt_order{dsgt_id = 305361,consume = [{0,38065361,1}],dsgt_order = 20,attr_list = [{1,60000},{2,6000000},{4,60000},{3,180000}]};

get_by_id_order(305362,1) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 1,attr_list = [{1,5000},{2,500000},{4,6000},{3,14000}]};

get_by_id_order(305362,2) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 2,attr_list = [{1,10000},{2,1000000},{4,12000},{3,28000}]};

get_by_id_order(305362,3) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 3,attr_list = [{1,15000},{2,1500000},{4,18000},{3,42000}]};

get_by_id_order(305362,4) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 4,attr_list = [{1,20000},{2,2000000},{4,24000},{3,56000}]};

get_by_id_order(305362,5) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 5,attr_list = [{1,25000},{2,2500000},{4,30000},{3,70000}]};

get_by_id_order(305362,6) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 6,attr_list = [{1,30000},{2,3000000},{4,36000},{3,84000}]};

get_by_id_order(305362,7) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 7,attr_list = [{1,35000},{2,3500000},{4,42000},{3,98000}]};

get_by_id_order(305362,8) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 8,attr_list = [{1,40000},{2,4000000},{4,48000},{3,112000}]};

get_by_id_order(305362,9) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 9,attr_list = [{1,45000},{2,4500000},{4,54000},{3,126000}]};

get_by_id_order(305362,10) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 10,attr_list = [{1,50000},{2,5000000},{4,60000},{3,140000}]};

get_by_id_order(305362,11) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 11,attr_list = [{1,55000},{2,5500000},{4,66000},{3,154000}]};

get_by_id_order(305362,12) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 12,attr_list = [{1,60000},{2,6000000},{4,72000},{3,168000}]};

get_by_id_order(305362,13) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 13,attr_list = [{1,65000},{2,6500000},{4,78000},{3,182000}]};

get_by_id_order(305362,14) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 14,attr_list = [{1,70000},{2,7000000},{4,84000},{3,196000}]};

get_by_id_order(305362,15) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 15,attr_list = [{1,75000},{2,7500000},{4,90000},{3,210000}]};

get_by_id_order(305362,16) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 16,attr_list = [{1,80000},{2,8000000},{4,96000},{3,224000}]};

get_by_id_order(305362,17) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 17,attr_list = [{1,85000},{2,8500000},{4,102000},{3,238000}]};

get_by_id_order(305362,18) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 18,attr_list = [{1,90000},{2,9000000},{4,108000},{3,252000}]};

get_by_id_order(305362,19) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 19,attr_list = [{1,95000},{2,9500000},{4,114000},{3,266000}]};

get_by_id_order(305362,20) ->
	#base_dsgt_order{dsgt_id = 305362,consume = [{0,38065362,1}],dsgt_order = 20,attr_list = [{1,100000},{2,10000000},{4,120000},{3,280000}]};

get_by_id_order(305363,1) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305363,2) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305363,3) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305363,4) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305363,5) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305363,6) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305363,7) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305363,8) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305363,9) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305363,10) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305363,11) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 11,attr_list = [{1,11000},{2,1100000},{4,11000},{3,33000}]};

get_by_id_order(305363,12) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 12,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305363,13) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 13,attr_list = [{1,13000},{2,1300000},{4,13000},{3,39000}]};

get_by_id_order(305363,14) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 14,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305363,15) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 15,attr_list = [{1,15000},{2,1500000},{4,15000},{3,45000}]};

get_by_id_order(305363,16) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 16,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305363,17) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 17,attr_list = [{1,17000},{2,1700000},{4,17000},{3,51000}]};

get_by_id_order(305363,18) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 18,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305363,19) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 19,attr_list = [{1,19000},{2,1900000},{4,19000},{3,57000}]};

get_by_id_order(305363,20) ->
	#base_dsgt_order{dsgt_id = 305363,consume = [{0,38065363,1}],dsgt_order = 20,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305364,1) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 1,attr_list = [{1,5000},{2,500000},{4,6000},{3,14000}]};

get_by_id_order(305364,2) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 2,attr_list = [{1,10000},{2,1000000},{4,12000},{3,28000}]};

get_by_id_order(305364,3) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 3,attr_list = [{1,15000},{2,1500000},{4,18000},{3,42000}]};

get_by_id_order(305364,4) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 4,attr_list = [{1,20000},{2,2000000},{4,24000},{3,56000}]};

get_by_id_order(305364,5) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 5,attr_list = [{1,25000},{2,2500000},{4,30000},{3,70000}]};

get_by_id_order(305364,6) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 6,attr_list = [{1,30000},{2,3000000},{4,36000},{3,84000}]};

get_by_id_order(305364,7) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 7,attr_list = [{1,35000},{2,3500000},{4,42000},{3,98000}]};

get_by_id_order(305364,8) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 8,attr_list = [{1,40000},{2,4000000},{4,48000},{3,112000}]};

get_by_id_order(305364,9) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 9,attr_list = [{1,45000},{2,4500000},{4,54000},{3,126000}]};

get_by_id_order(305364,10) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 10,attr_list = [{1,50000},{2,5000000},{4,60000},{3,140000}]};

get_by_id_order(305364,11) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 11,attr_list = [{1,55000},{2,5500000},{4,66000},{3,154000}]};

get_by_id_order(305364,12) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 12,attr_list = [{1,60000},{2,6000000},{4,72000},{3,168000}]};

get_by_id_order(305364,13) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 13,attr_list = [{1,65000},{2,6500000},{4,78000},{3,182000}]};

get_by_id_order(305364,14) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 14,attr_list = [{1,70000},{2,7000000},{4,84000},{3,196000}]};

get_by_id_order(305364,15) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 15,attr_list = [{1,75000},{2,7500000},{4,90000},{3,210000}]};

get_by_id_order(305364,16) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 16,attr_list = [{1,80000},{2,8000000},{4,96000},{3,224000}]};

get_by_id_order(305364,17) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 17,attr_list = [{1,85000},{2,8500000},{4,102000},{3,238000}]};

get_by_id_order(305364,18) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 18,attr_list = [{1,90000},{2,9000000},{4,108000},{3,252000}]};

get_by_id_order(305364,19) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 19,attr_list = [{1,95000},{2,9500000},{4,114000},{3,266000}]};

get_by_id_order(305364,20) ->
	#base_dsgt_order{dsgt_id = 305364,consume = [{0,38065364,1}],dsgt_order = 20,attr_list = [{1,100000},{2,10000000},{4,120000},{3,280000}]};

get_by_id_order(305365,1) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 1,attr_list = [{1,4000},{2,400000},{4,5000},{3,11000}]};

get_by_id_order(305365,2) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 2,attr_list = [{1,8000},{2,800000},{4,10000},{3,22000}]};

get_by_id_order(305365,3) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 3,attr_list = [{1,12000},{2,1200000},{4,15000},{3,33000}]};

get_by_id_order(305365,4) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 4,attr_list = [{1,16000},{2,1600000},{4,20000},{3,44000}]};

get_by_id_order(305365,5) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 5,attr_list = [{1,20000},{2,2000000},{4,25000},{3,55000}]};

get_by_id_order(305365,6) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 6,attr_list = [{1,24000},{2,2400000},{4,30000},{3,66000}]};

get_by_id_order(305365,7) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 7,attr_list = [{1,28000},{2,2800000},{4,35000},{3,77000}]};

get_by_id_order(305365,8) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 8,attr_list = [{1,32000},{2,3200000},{4,40000},{3,88000}]};

get_by_id_order(305365,9) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 9,attr_list = [{1,36000},{2,3600000},{4,45000},{3,99000}]};

get_by_id_order(305365,10) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 10,attr_list = [{1,40000},{2,4000000},{4,50000},{3,110000}]};

get_by_id_order(305365,11) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 11,attr_list = [{1,44000},{2,4400000},{4,55000},{3,121000}]};

get_by_id_order(305365,12) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 12,attr_list = [{1,48000},{2,4800000},{4,60000},{3,132000}]};

get_by_id_order(305365,13) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 13,attr_list = [{1,52000},{2,5200000},{4,65000},{3,143000}]};

get_by_id_order(305365,14) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 14,attr_list = [{1,56000},{2,5600000},{4,70000},{3,154000}]};

get_by_id_order(305365,15) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 15,attr_list = [{1,60000},{2,6000000},{4,75000},{3,165000}]};

get_by_id_order(305365,16) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 16,attr_list = [{1,64000},{2,6400000},{4,80000},{3,176000}]};

get_by_id_order(305365,17) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 17,attr_list = [{1,68000},{2,6800000},{4,85000},{3,187000}]};

get_by_id_order(305365,18) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 18,attr_list = [{1,72000},{2,7200000},{4,90000},{3,198000}]};

get_by_id_order(305365,19) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 19,attr_list = [{1,76000},{2,7600000},{4,95000},{3,209000}]};

get_by_id_order(305365,20) ->
	#base_dsgt_order{dsgt_id = 305365,consume = [{0,38065365,1}],dsgt_order = 20,attr_list = [{1,80000},{2,8000000},{4,100000},{3,220000}]};

get_by_id_order(305366,1) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 1,attr_list = [{1,500},{2,50000},{4,500},{3,1500}]};

get_by_id_order(305366,2) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 2,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305366,3) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 3,attr_list = [{1,1500},{2,150000},{4,1500},{3,4500}]};

get_by_id_order(305366,4) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 4,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305366,5) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 5,attr_list = [{1,2500},{2,250000},{4,2500},{3,7500}]};

get_by_id_order(305366,6) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 6,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305366,7) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 7,attr_list = [{1,3500},{2,350000},{4,3500},{3,10500}]};

get_by_id_order(305366,8) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 8,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305366,9) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 9,attr_list = [{1,4500},{2,450000},{4,4500},{3,13500}]};

get_by_id_order(305366,10) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 10,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305366,11) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 11,attr_list = [{1,5500},{2,550000},{4,5500},{3,16500}]};

get_by_id_order(305366,12) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 12,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305366,13) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 13,attr_list = [{1,6500},{2,650000},{4,6500},{3,19500}]};

get_by_id_order(305366,14) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 14,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305366,15) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 15,attr_list = [{1,7500},{2,750000},{4,7500},{3,22500}]};

get_by_id_order(305366,16) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 16,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305366,17) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 17,attr_list = [{1,8500},{2,850000},{4,8500},{3,25500}]};

get_by_id_order(305366,18) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 18,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305366,19) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 19,attr_list = [{1,9500},{2,950000},{4,9500},{3,28500}]};

get_by_id_order(305366,20) ->
	#base_dsgt_order{dsgt_id = 305366,consume = [{0,38065366,1}],dsgt_order = 20,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305367,1) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 1,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305367,2) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 2,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305367,3) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 3,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305367,4) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 4,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305367,5) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 5,attr_list = [{1,15000},{2,1500000},{4,15000},{3,45000}]};

get_by_id_order(305367,6) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 6,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305367,7) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 7,attr_list = [{1,21000},{2,2100000},{4,21000},{3,63000}]};

get_by_id_order(305367,8) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 8,attr_list = [{1,24000},{2,2400000},{4,24000},{3,72000}]};

get_by_id_order(305367,9) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 9,attr_list = [{1,27000},{2,2700000},{4,27000},{3,81000}]};

get_by_id_order(305367,10) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 10,attr_list = [{1,30000},{2,3000000},{4,30000},{3,90000}]};

get_by_id_order(305367,11) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 11,attr_list = [{1,33000},{2,3300000},{4,33000},{3,99000}]};

get_by_id_order(305367,12) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 12,attr_list = [{1,36000},{2,3600000},{4,36000},{3,108000}]};

get_by_id_order(305367,13) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 13,attr_list = [{1,39000},{2,3900000},{4,39000},{3,117000}]};

get_by_id_order(305367,14) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 14,attr_list = [{1,42000},{2,4200000},{4,42000},{3,126000}]};

get_by_id_order(305367,15) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 15,attr_list = [{1,45000},{2,4500000},{4,45000},{3,135000}]};

get_by_id_order(305367,16) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 16,attr_list = [{1,48000},{2,4800000},{4,48000},{3,144000}]};

get_by_id_order(305367,17) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 17,attr_list = [{1,51000},{2,5100000},{4,51000},{3,153000}]};

get_by_id_order(305367,18) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 18,attr_list = [{1,54000},{2,5400000},{4,54000},{3,162000}]};

get_by_id_order(305367,19) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 19,attr_list = [{1,57000},{2,5700000},{4,57000},{3,171000}]};

get_by_id_order(305367,20) ->
	#base_dsgt_order{dsgt_id = 305367,consume = [{0,38065367,1}],dsgt_order = 20,attr_list = [{1,60000},{2,6000000},{4,60000},{3,180000}]};

get_by_id_order(305368,1) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 1,attr_list = [{1,1000},{2,100000},{4,1000},{3,3000}]};

get_by_id_order(305368,2) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 2,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305368,3) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 3,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305368,4) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 4,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305368,5) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 5,attr_list = [{1,5000},{2,500000},{4,5000},{3,15000}]};

get_by_id_order(305368,6) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 6,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305368,7) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 7,attr_list = [{1,7000},{2,700000},{4,7000},{3,21000}]};

get_by_id_order(305368,8) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 8,attr_list = [{1,8000},{2,800000},{4,8000},{3,24000}]};

get_by_id_order(305368,9) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 9,attr_list = [{1,9000},{2,900000},{4,9000},{3,27000}]};

get_by_id_order(305368,10) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 10,attr_list = [{1,10000},{2,1000000},{4,10000},{3,30000}]};

get_by_id_order(305368,11) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 11,attr_list = [{1,11000},{2,1100000},{4,11000},{3,33000}]};

get_by_id_order(305368,12) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 12,attr_list = [{1,12000},{2,1200000},{4,12000},{3,36000}]};

get_by_id_order(305368,13) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 13,attr_list = [{1,13000},{2,1300000},{4,13000},{3,39000}]};

get_by_id_order(305368,14) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 14,attr_list = [{1,14000},{2,1400000},{4,14000},{3,42000}]};

get_by_id_order(305368,15) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 15,attr_list = [{1,15000},{2,1500000},{4,15000},{3,45000}]};

get_by_id_order(305368,16) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 16,attr_list = [{1,16000},{2,1600000},{4,16000},{3,48000}]};

get_by_id_order(305368,17) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 17,attr_list = [{1,17000},{2,1700000},{4,17000},{3,51000}]};

get_by_id_order(305368,18) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 18,attr_list = [{1,18000},{2,1800000},{4,18000},{3,54000}]};

get_by_id_order(305368,19) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 19,attr_list = [{1,19000},{2,1900000},{4,19000},{3,57000}]};

get_by_id_order(305368,20) ->
	#base_dsgt_order{dsgt_id = 305368,consume = [{0,38065368,1}],dsgt_order = 20,attr_list = [{1,20000},{2,2000000},{4,20000},{3,60000}]};

get_by_id_order(305369,1) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 1,attr_list = [{1,2000},{2,180000},{4,2000},{3,7000}]};

get_by_id_order(305369,2) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 2,attr_list = [{1,4000},{2,360000},{4,4000},{3,14000}]};

get_by_id_order(305369,3) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 3,attr_list = [{1,6000},{2,540000},{4,6000},{3,21000}]};

get_by_id_order(305369,4) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 4,attr_list = [{1,8000},{2,720000},{4,8000},{3,28000}]};

get_by_id_order(305369,5) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 5,attr_list = [{1,10000},{2,900000},{4,10000},{3,35000}]};

get_by_id_order(305369,6) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 6,attr_list = [{1,12000},{2,1080000},{4,12000},{3,42000}]};

get_by_id_order(305369,7) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 7,attr_list = [{1,14000},{2,1260000},{4,14000},{3,49000}]};

get_by_id_order(305369,8) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 8,attr_list = [{1,16000},{2,1440000},{4,16000},{3,56000}]};

get_by_id_order(305369,9) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 9,attr_list = [{1,18000},{2,1620000},{4,18000},{3,63000}]};

get_by_id_order(305369,10) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 10,attr_list = [{1,20000},{2,1800000},{4,20000},{3,70000}]};

get_by_id_order(305369,11) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 11,attr_list = [{1,22000},{2,1980000},{4,22000},{3,77000}]};

get_by_id_order(305369,12) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 12,attr_list = [{1,24000},{2,2160000},{4,24000},{3,84000}]};

get_by_id_order(305369,13) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 13,attr_list = [{1,26000},{2,2340000},{4,26000},{3,91000}]};

get_by_id_order(305369,14) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 14,attr_list = [{1,28000},{2,2520000},{4,28000},{3,98000}]};

get_by_id_order(305369,15) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 15,attr_list = [{1,30000},{2,2700000},{4,30000},{3,105000}]};

get_by_id_order(305369,16) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 16,attr_list = [{1,32000},{2,2880000},{4,32000},{3,112000}]};

get_by_id_order(305369,17) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 17,attr_list = [{1,34000},{2,3060000},{4,34000},{3,119000}]};

get_by_id_order(305369,18) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 18,attr_list = [{1,36000},{2,3240000},{4,36000},{3,126000}]};

get_by_id_order(305369,19) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 19,attr_list = [{1,38000},{2,3420000},{4,38000},{3,133000}]};

get_by_id_order(305369,20) ->
	#base_dsgt_order{dsgt_id = 305369,consume = [{0,38065369,1}],dsgt_order = 20,attr_list = [{1,40000},{2,3600000},{4,40000},{3,140000}]};

get_by_id_order(305370,1) ->
	#base_dsgt_order{dsgt_id = 305370,consume = [{0,38065370,1}],dsgt_order = 1,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305370,2) ->
	#base_dsgt_order{dsgt_id = 305370,consume = [{0,38065370,1}],dsgt_order = 2,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305370,3) ->
	#base_dsgt_order{dsgt_id = 305370,consume = [{0,38065370,1}],dsgt_order = 3,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305370,4) ->
	#base_dsgt_order{dsgt_id = 305370,consume = [{0,38065370,1}],dsgt_order = 4,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305370,5) ->
	#base_dsgt_order{dsgt_id = 305370,consume = [{0,38065370,1}],dsgt_order = 5,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305370,6) ->
	#base_dsgt_order{dsgt_id = 305370,consume = [{0,38065370,1}],dsgt_order = 6,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305370,7) ->
	#base_dsgt_order{dsgt_id = 305370,consume = [{0,38065370,1}],dsgt_order = 7,attr_list = [{1,2800},{2,280000},{4,2800},{3,8400}]};

get_by_id_order(305370,8) ->
	#base_dsgt_order{dsgt_id = 305370,consume = [{0,38065370,1}],dsgt_order = 8,attr_list = [{1,3200},{2,320000},{4,3200},{3,9600}]};

get_by_id_order(305370,9) ->
	#base_dsgt_order{dsgt_id = 305370,consume = [{0,38065370,1}],dsgt_order = 9,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305370,10) ->
	#base_dsgt_order{dsgt_id = 305370,consume = [{0,38065370,1}],dsgt_order = 10,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305371,1) ->
	#base_dsgt_order{dsgt_id = 305371,consume = [{0,38065371,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305371,2) ->
	#base_dsgt_order{dsgt_id = 305371,consume = [{0,38065371,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305371,3) ->
	#base_dsgt_order{dsgt_id = 305371,consume = [{0,38065371,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305371,4) ->
	#base_dsgt_order{dsgt_id = 305371,consume = [{0,38065371,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305371,5) ->
	#base_dsgt_order{dsgt_id = 305371,consume = [{0,38065371,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305371,6) ->
	#base_dsgt_order{dsgt_id = 305371,consume = [{0,38065371,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305371,7) ->
	#base_dsgt_order{dsgt_id = 305371,consume = [{0,38065371,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305371,8) ->
	#base_dsgt_order{dsgt_id = 305371,consume = [{0,38065371,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305371,9) ->
	#base_dsgt_order{dsgt_id = 305371,consume = [{0,38065371,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305371,10) ->
	#base_dsgt_order{dsgt_id = 305371,consume = [{0,38065371,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305372,1) ->
	#base_dsgt_order{dsgt_id = 305372,consume = [{0,38065372,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305372,2) ->
	#base_dsgt_order{dsgt_id = 305372,consume = [{0,38065372,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305372,3) ->
	#base_dsgt_order{dsgt_id = 305372,consume = [{0,38065372,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305372,4) ->
	#base_dsgt_order{dsgt_id = 305372,consume = [{0,38065372,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305372,5) ->
	#base_dsgt_order{dsgt_id = 305372,consume = [{0,38065372,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305372,6) ->
	#base_dsgt_order{dsgt_id = 305372,consume = [{0,38065372,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305372,7) ->
	#base_dsgt_order{dsgt_id = 305372,consume = [{0,38065372,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305372,8) ->
	#base_dsgt_order{dsgt_id = 305372,consume = [{0,38065372,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305372,9) ->
	#base_dsgt_order{dsgt_id = 305372,consume = [{0,38065372,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305372,10) ->
	#base_dsgt_order{dsgt_id = 305372,consume = [{0,38065372,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305373,1) ->
	#base_dsgt_order{dsgt_id = 305373,consume = [{0,38065373,1}],dsgt_order = 1,attr_list = [{1,400},{2,40000},{4,400},{3,1200}]};

get_by_id_order(305373,2) ->
	#base_dsgt_order{dsgt_id = 305373,consume = [{0,38065373,1}],dsgt_order = 2,attr_list = [{1,800},{2,80000},{4,800},{3,2400}]};

get_by_id_order(305373,3) ->
	#base_dsgt_order{dsgt_id = 305373,consume = [{0,38065373,1}],dsgt_order = 3,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305373,4) ->
	#base_dsgt_order{dsgt_id = 305373,consume = [{0,38065373,1}],dsgt_order = 4,attr_list = [{1,1600},{2,160000},{4,1600},{3,4800}]};

get_by_id_order(305373,5) ->
	#base_dsgt_order{dsgt_id = 305373,consume = [{0,38065373,1}],dsgt_order = 5,attr_list = [{1,2000},{2,200000},{4,2000},{3,6000}]};

get_by_id_order(305373,6) ->
	#base_dsgt_order{dsgt_id = 305373,consume = [{0,38065373,1}],dsgt_order = 6,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305373,7) ->
	#base_dsgt_order{dsgt_id = 305373,consume = [{0,38065373,1}],dsgt_order = 7,attr_list = [{1,2800},{2,280000},{4,2800},{3,8400}]};

get_by_id_order(305373,8) ->
	#base_dsgt_order{dsgt_id = 305373,consume = [{0,38065373,1}],dsgt_order = 8,attr_list = [{1,3200},{2,320000},{4,3200},{3,9600}]};

get_by_id_order(305373,9) ->
	#base_dsgt_order{dsgt_id = 305373,consume = [{0,38065373,1}],dsgt_order = 9,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305373,10) ->
	#base_dsgt_order{dsgt_id = 305373,consume = [{0,38065373,1}],dsgt_order = 10,attr_list = [{1,4000},{2,400000},{4,4000},{3,12000}]};

get_by_id_order(305374,1) ->
	#base_dsgt_order{dsgt_id = 305374,consume = [{0,38065374,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305374,2) ->
	#base_dsgt_order{dsgt_id = 305374,consume = [{0,38065374,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305374,3) ->
	#base_dsgt_order{dsgt_id = 305374,consume = [{0,38065374,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305374,4) ->
	#base_dsgt_order{dsgt_id = 305374,consume = [{0,38065374,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305374,5) ->
	#base_dsgt_order{dsgt_id = 305374,consume = [{0,38065374,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305374,6) ->
	#base_dsgt_order{dsgt_id = 305374,consume = [{0,38065374,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305374,7) ->
	#base_dsgt_order{dsgt_id = 305374,consume = [{0,38065374,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305374,8) ->
	#base_dsgt_order{dsgt_id = 305374,consume = [{0,38065374,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305374,9) ->
	#base_dsgt_order{dsgt_id = 305374,consume = [{0,38065374,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305374,10) ->
	#base_dsgt_order{dsgt_id = 305374,consume = [{0,38065374,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305375,1) ->
	#base_dsgt_order{dsgt_id = 305375,consume = [{0,38065375,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305375,2) ->
	#base_dsgt_order{dsgt_id = 305375,consume = [{0,38065375,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305375,3) ->
	#base_dsgt_order{dsgt_id = 305375,consume = [{0,38065375,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305375,4) ->
	#base_dsgt_order{dsgt_id = 305375,consume = [{0,38065375,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305375,5) ->
	#base_dsgt_order{dsgt_id = 305375,consume = [{0,38065375,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305375,6) ->
	#base_dsgt_order{dsgt_id = 305375,consume = [{0,38065375,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305375,7) ->
	#base_dsgt_order{dsgt_id = 305375,consume = [{0,38065375,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305375,8) ->
	#base_dsgt_order{dsgt_id = 305375,consume = [{0,38065375,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305375,9) ->
	#base_dsgt_order{dsgt_id = 305375,consume = [{0,38065375,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305375,10) ->
	#base_dsgt_order{dsgt_id = 305375,consume = [{0,38065375,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305376,1) ->
	#base_dsgt_order{dsgt_id = 305376,consume = [{0,38065376,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305376,2) ->
	#base_dsgt_order{dsgt_id = 305376,consume = [{0,38065376,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305376,3) ->
	#base_dsgt_order{dsgt_id = 305376,consume = [{0,38065376,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305376,4) ->
	#base_dsgt_order{dsgt_id = 305376,consume = [{0,38065376,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305376,5) ->
	#base_dsgt_order{dsgt_id = 305376,consume = [{0,38065376,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305376,6) ->
	#base_dsgt_order{dsgt_id = 305376,consume = [{0,38065376,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305376,7) ->
	#base_dsgt_order{dsgt_id = 305376,consume = [{0,38065376,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305376,8) ->
	#base_dsgt_order{dsgt_id = 305376,consume = [{0,38065376,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305376,9) ->
	#base_dsgt_order{dsgt_id = 305376,consume = [{0,38065376,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305376,10) ->
	#base_dsgt_order{dsgt_id = 305376,consume = [{0,38065376,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305377,1) ->
	#base_dsgt_order{dsgt_id = 305377,consume = [{0,38065377,1}],dsgt_order = 1,attr_list = [{1,600},{2,60000},{4,600},{3,1800}]};

get_by_id_order(305377,2) ->
	#base_dsgt_order{dsgt_id = 305377,consume = [{0,38065377,1}],dsgt_order = 2,attr_list = [{1,1200},{2,120000},{4,1200},{3,3600}]};

get_by_id_order(305377,3) ->
	#base_dsgt_order{dsgt_id = 305377,consume = [{0,38065377,1}],dsgt_order = 3,attr_list = [{1,1800},{2,180000},{4,1800},{3,5400}]};

get_by_id_order(305377,4) ->
	#base_dsgt_order{dsgt_id = 305377,consume = [{0,38065377,1}],dsgt_order = 4,attr_list = [{1,2400},{2,240000},{4,2400},{3,7200}]};

get_by_id_order(305377,5) ->
	#base_dsgt_order{dsgt_id = 305377,consume = [{0,38065377,1}],dsgt_order = 5,attr_list = [{1,3000},{2,300000},{4,3000},{3,9000}]};

get_by_id_order(305377,6) ->
	#base_dsgt_order{dsgt_id = 305377,consume = [{0,38065377,1}],dsgt_order = 6,attr_list = [{1,3600},{2,360000},{4,3600},{3,10800}]};

get_by_id_order(305377,7) ->
	#base_dsgt_order{dsgt_id = 305377,consume = [{0,38065377,1}],dsgt_order = 7,attr_list = [{1,4200},{2,420000},{4,4200},{3,12600}]};

get_by_id_order(305377,8) ->
	#base_dsgt_order{dsgt_id = 305377,consume = [{0,38065377,1}],dsgt_order = 8,attr_list = [{1,4800},{2,480000},{4,4800},{3,14400}]};

get_by_id_order(305377,9) ->
	#base_dsgt_order{dsgt_id = 305377,consume = [{0,38065377,1}],dsgt_order = 9,attr_list = [{1,5400},{2,540000},{4,5400},{3,16200}]};

get_by_id_order(305377,10) ->
	#base_dsgt_order{dsgt_id = 305377,consume = [{0,38065377,1}],dsgt_order = 10,attr_list = [{1,6000},{2,600000},{4,6000},{3,18000}]};

get_by_id_order(305405,1) ->
	#base_dsgt_order{dsgt_id = 305405,consume = [{0,38065405,1}],dsgt_order = 1,attr_list = [{1,500},{2,10000},{4,250},{3,250}]};

get_by_id_order(305405,2) ->
	#base_dsgt_order{dsgt_id = 305405,consume = [{0,38065405,1}],dsgt_order = 2,attr_list = [{1,1000},{2,20000},{4,500},{3,500}]};

get_by_id_order(305407,1) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 1,attr_list = [{1,500},{2,10000},{4,250},{3,250}]};

get_by_id_order(305407,2) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 2,attr_list = [{1,1000},{2,20000},{4,500},{3,500}]};

get_by_id_order(305407,3) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 3,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305407,4) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 4,attr_list = [{1,2000},{2,40000},{4,1000},{3,1000}]};

get_by_id_order(305407,5) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 5,attr_list = [{1,2500},{2,50000},{4,1250},{3,1250}]};

get_by_id_order(305407,6) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 6,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305407,7) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 7,attr_list = [{1,3500},{2,70000},{4,1750},{3,1750}]};

get_by_id_order(305407,8) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 8,attr_list = [{1,4000},{2,80000},{4,2000},{3,2000}]};

get_by_id_order(305407,9) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 9,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305407,10) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 10,attr_list = [{1,5000},{2,100000},{4,2500},{3,2500}]};

get_by_id_order(305407,11) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 11,attr_list = [{1,5500},{2,110000},{4,2750},{3,2750}]};

get_by_id_order(305407,12) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 12,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305407,13) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 13,attr_list = [{1,6500},{2,130000},{4,3250},{3,3250}]};

get_by_id_order(305407,14) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 14,attr_list = [{1,7000},{2,140000},{4,3500},{3,3500}]};

get_by_id_order(305407,15) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 15,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305407,16) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 16,attr_list = [{1,8000},{2,160000},{4,4000},{3,4000}]};

get_by_id_order(305407,17) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 17,attr_list = [{1,8500},{2,170000},{4,4250},{3,4250}]};

get_by_id_order(305407,18) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 18,attr_list = [{1,9000},{2,180000},{4,4500},{3,4500}]};

get_by_id_order(305407,19) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 19,attr_list = [{1,9500},{2,190000},{4,4750},{3,4750}]};

get_by_id_order(305407,20) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 20,attr_list = [{1,10000},{2,200000},{4,5000},{3,5000}]};

get_by_id_order(305407,21) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 21,attr_list = [{1,10500},{2,210000},{4,5250},{3,5250}]};

get_by_id_order(305407,22) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 22,attr_list = [{1,11000},{2,220000},{4,5500},{3,5500}]};

get_by_id_order(305407,23) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 23,attr_list = [{1,11500},{2,230000},{4,5750},{3,5750}]};

get_by_id_order(305407,24) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 24,attr_list = [{1,12000},{2,240000},{4,6000},{3,6000}]};

get_by_id_order(305407,25) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 25,attr_list = [{1,12500},{2,250000},{4,6250},{3,6250}]};

get_by_id_order(305407,26) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 26,attr_list = [{1,13000},{2,260000},{4,6500},{3,6500}]};

get_by_id_order(305407,27) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 27,attr_list = [{1,13500},{2,270000},{4,6750},{3,6750}]};

get_by_id_order(305407,28) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 28,attr_list = [{1,14000},{2,280000},{4,7000},{3,7000}]};

get_by_id_order(305407,29) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 29,attr_list = [{1,14500},{2,290000},{4,7250},{3,7250}]};

get_by_id_order(305407,30) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 30,attr_list = [{1,15000},{2,300000},{4,7500},{3,7500}]};

get_by_id_order(305407,31) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 31,attr_list = [{1,15500},{2,310000},{4,7750},{3,7750}]};

get_by_id_order(305407,32) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 32,attr_list = [{1,16000},{2,320000},{4,8000},{3,8000}]};

get_by_id_order(305407,33) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 33,attr_list = [{1,16500},{2,330000},{4,8250},{3,8250}]};

get_by_id_order(305407,34) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 34,attr_list = [{1,17000},{2,340000},{4,8500},{3,8500}]};

get_by_id_order(305407,35) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 35,attr_list = [{1,17500},{2,350000},{4,8750},{3,8750}]};

get_by_id_order(305407,36) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 36,attr_list = [{1,18000},{2,360000},{4,9000},{3,9000}]};

get_by_id_order(305407,37) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 37,attr_list = [{1,18500},{2,370000},{4,9250},{3,9250}]};

get_by_id_order(305407,38) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 38,attr_list = [{1,19000},{2,380000},{4,9500},{3,9500}]};

get_by_id_order(305407,39) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 39,attr_list = [{1,19500},{2,390000},{4,9750},{3,9750}]};

get_by_id_order(305407,40) ->
	#base_dsgt_order{dsgt_id = 305407,consume = [{0,38065407,1}],dsgt_order = 40,attr_list = [{1,20000},{2,400000},{4,10000},{3,10000}]};

get_by_id_order(305409,1) ->
	#base_dsgt_order{dsgt_id = 305409,consume = [],dsgt_order = 1,attr_list = [{1,120},{2,2400},{4,60},{3,60}]};

get_by_id_order(305410,1) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305410,2) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305410,3) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305410,4) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305410,5) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305410,6) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305410,7) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305410,8) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305410,9) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305410,10) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305410,11) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305410,12) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305410,13) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305410,14) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305410,15) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305410,16) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305410,17) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305410,18) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305410,19) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305410,20) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305410,21) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305410,22) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305410,23) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305410,24) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305410,25) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305410,26) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305410,27) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305410,28) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305410,29) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305410,30) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305410,31) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305410,32) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305410,33) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305410,34) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305410,35) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305410,36) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305410,37) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305410,38) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305410,39) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305410,40) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305410,41) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305410,42) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305410,43) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305410,44) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305410,45) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305410,46) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305410,47) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305410,48) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305410,49) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305410,50) ->
	#base_dsgt_order{dsgt_id = 305410,consume = [{0,38065410,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305412,1) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305412,2) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305412,3) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305412,4) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305412,5) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305412,6) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305412,7) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305412,8) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305412,9) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305412,10) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305412,11) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305412,12) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305412,13) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305412,14) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305412,15) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305412,16) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305412,17) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305412,18) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305412,19) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305412,20) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305412,21) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305412,22) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305412,23) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305412,24) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305412,25) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305412,26) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305412,27) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305412,28) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305412,29) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305412,30) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305412,31) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305412,32) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305412,33) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305412,34) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305412,35) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305412,36) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305412,37) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305412,38) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305412,39) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305412,40) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305412,41) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305412,42) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305412,43) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305412,44) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305412,45) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305412,46) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305412,47) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305412,48) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305412,49) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305412,50) ->
	#base_dsgt_order{dsgt_id = 305412,consume = [{0,38065412,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(305414,1) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 1,attr_list = [{1,1000},{2,20000},{3,500},{9,30}]};

get_by_id_order(305414,2) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 2,attr_list = [{1,2000},{2,40000},{3,1000},{9,60}]};

get_by_id_order(305414,3) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 3,attr_list = [{1,3000},{2,60000},{3,1500},{9,90}]};

get_by_id_order(305414,4) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 4,attr_list = [{1,4000},{2,80000},{3,2000},{9,120}]};

get_by_id_order(305414,5) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 5,attr_list = [{1,5000},{2,100000},{3,2500},{9,150}]};

get_by_id_order(305414,6) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 6,attr_list = [{1,6000},{2,120000},{3,3000},{9,180}]};

get_by_id_order(305414,7) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 7,attr_list = [{1,7000},{2,140000},{3,3500},{9,210}]};

get_by_id_order(305414,8) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 8,attr_list = [{1,8000},{2,160000},{3,4000},{9,240}]};

get_by_id_order(305414,9) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 9,attr_list = [{1,9000},{2,180000},{3,4500},{9,270}]};

get_by_id_order(305414,10) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 10,attr_list = [{1,10000},{2,200000},{3,5000},{9,300}]};

get_by_id_order(305414,11) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 11,attr_list = [{1,11000},{2,220000},{3,5500},{9,330}]};

get_by_id_order(305414,12) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 12,attr_list = [{1,12000},{2,240000},{3,6000},{9,360}]};

get_by_id_order(305414,13) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 13,attr_list = [{1,13000},{2,260000},{3,6500},{9,390}]};

get_by_id_order(305414,14) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 14,attr_list = [{1,14000},{2,280000},{3,7000},{9,420}]};

get_by_id_order(305414,15) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 15,attr_list = [{1,15000},{2,300000},{3,7500},{9,450}]};

get_by_id_order(305414,16) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 16,attr_list = [{1,16000},{2,320000},{3,8000},{9,480}]};

get_by_id_order(305414,17) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 17,attr_list = [{1,17000},{2,340000},{3,8500},{9,510}]};

get_by_id_order(305414,18) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 18,attr_list = [{1,18000},{2,360000},{3,9000},{9,540}]};

get_by_id_order(305414,19) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 19,attr_list = [{1,19000},{2,380000},{3,9500},{9,570}]};

get_by_id_order(305414,20) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 20,attr_list = [{1,20000},{2,400000},{3,10000},{9,600}]};

get_by_id_order(305414,21) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 21,attr_list = [{1,21000},{2,420000},{3,10500},{9,630}]};

get_by_id_order(305414,22) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 22,attr_list = [{1,22000},{2,440000},{3,11000},{9,660}]};

get_by_id_order(305414,23) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 23,attr_list = [{1,23000},{2,460000},{3,11500},{9,690}]};

get_by_id_order(305414,24) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 24,attr_list = [{1,24000},{2,480000},{3,12000},{9,720}]};

get_by_id_order(305414,25) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 25,attr_list = [{1,25000},{2,500000},{3,12500},{9,750}]};

get_by_id_order(305414,26) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 26,attr_list = [{1,26000},{2,520000},{3,13000},{9,780}]};

get_by_id_order(305414,27) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 27,attr_list = [{1,27000},{2,540000},{3,13500},{9,810}]};

get_by_id_order(305414,28) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 28,attr_list = [{1,28000},{2,560000},{3,14000},{9,840}]};

get_by_id_order(305414,29) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 29,attr_list = [{1,29000},{2,580000},{3,14500},{9,870}]};

get_by_id_order(305414,30) ->
	#base_dsgt_order{dsgt_id = 305414,consume = [{0,38065414,1}],dsgt_order = 30,attr_list = [{1,30000},{2,600000},{3,15000},{9,900}]};

get_by_id_order(305415,1) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 1,attr_list = [{1,150},{2,3000},{4,75},{3,75}]};

get_by_id_order(305415,2) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 2,attr_list = [{1,300},{2,6000},{4,150},{3,150}]};

get_by_id_order(305415,3) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 3,attr_list = [{1,450},{2,9000},{4,225},{3,225}]};

get_by_id_order(305415,4) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 4,attr_list = [{1,600},{2,12000},{4,300},{3,300}]};

get_by_id_order(305415,5) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 5,attr_list = [{1,750},{2,15000},{4,375},{3,375}]};

get_by_id_order(305415,6) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 6,attr_list = [{1,900},{2,18000},{4,450},{3,450}]};

get_by_id_order(305415,7) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 7,attr_list = [{1,1050},{2,21000},{4,525},{3,525}]};

get_by_id_order(305415,8) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 8,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(305415,9) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 9,attr_list = [{1,1350},{2,27000},{4,675},{3,675}]};

get_by_id_order(305415,10) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 10,attr_list = [{1,1500},{2,30000},{4,750},{3,750}]};

get_by_id_order(305415,11) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 11,attr_list = [{1,1650},{2,33000},{4,825},{3,825}]};

get_by_id_order(305415,12) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 12,attr_list = [{1,1800},{2,36000},{4,900},{3,900}]};

get_by_id_order(305415,13) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 13,attr_list = [{1,1950},{2,39000},{4,975},{3,975}]};

get_by_id_order(305415,14) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 14,attr_list = [{1,2100},{2,42000},{4,1050},{3,1050}]};

get_by_id_order(305415,15) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 15,attr_list = [{1,2250},{2,45000},{4,1125},{3,1125}]};

get_by_id_order(305415,16) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 16,attr_list = [{1,2400},{2,48000},{4,1200},{3,1200}]};

get_by_id_order(305415,17) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 17,attr_list = [{1,2550},{2,51000},{4,1275},{3,1275}]};

get_by_id_order(305415,18) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 18,attr_list = [{1,2700},{2,54000},{4,1350},{3,1350}]};

get_by_id_order(305415,19) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 19,attr_list = [{1,2850},{2,57000},{4,1425},{3,1425}]};

get_by_id_order(305415,20) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 20,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(305415,21) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 21,attr_list = [{1,3150},{2,63000},{4,1575},{3,1575}]};

get_by_id_order(305415,22) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 22,attr_list = [{1,3300},{2,66000},{4,1650},{3,1650}]};

get_by_id_order(305415,23) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 23,attr_list = [{1,3450},{2,69000},{4,1725},{3,1725}]};

get_by_id_order(305415,24) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 24,attr_list = [{1,3600},{2,72000},{4,1800},{3,1800}]};

get_by_id_order(305415,25) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 25,attr_list = [{1,3750},{2,75000},{4,1875},{3,1875}]};

get_by_id_order(305415,26) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 26,attr_list = [{1,3900},{2,78000},{4,1950},{3,1950}]};

get_by_id_order(305415,27) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 27,attr_list = [{1,4050},{2,81000},{4,2025},{3,2025}]};

get_by_id_order(305415,28) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 28,attr_list = [{1,4200},{2,84000},{4,2100},{3,2100}]};

get_by_id_order(305415,29) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 29,attr_list = [{1,4350},{2,87000},{4,2175},{3,2175}]};

get_by_id_order(305415,30) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 30,attr_list = [{1,4500},{2,90000},{4,2250},{3,2250}]};

get_by_id_order(305415,31) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 31,attr_list = [{1,4650},{2,93000},{4,2325},{3,2325}]};

get_by_id_order(305415,32) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 32,attr_list = [{1,4800},{2,96000},{4,2400},{3,2400}]};

get_by_id_order(305415,33) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 33,attr_list = [{1,4950},{2,99000},{4,2475},{3,2475}]};

get_by_id_order(305415,34) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 34,attr_list = [{1,5100},{2,102000},{4,2550},{3,2550}]};

get_by_id_order(305415,35) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 35,attr_list = [{1,5250},{2,105000},{4,2625},{3,2625}]};

get_by_id_order(305415,36) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 36,attr_list = [{1,5400},{2,108000},{4,2700},{3,2700}]};

get_by_id_order(305415,37) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 37,attr_list = [{1,5550},{2,111000},{4,2775},{3,2775}]};

get_by_id_order(305415,38) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 38,attr_list = [{1,5700},{2,114000},{4,2850},{3,2850}]};

get_by_id_order(305415,39) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 39,attr_list = [{1,5850},{2,117000},{4,2925},{3,2925}]};

get_by_id_order(305415,40) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 40,attr_list = [{1,6000},{2,120000},{4,3000},{3,3000}]};

get_by_id_order(305415,41) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 41,attr_list = [{1,6150},{2,123000},{4,3075},{3,3075}]};

get_by_id_order(305415,42) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 42,attr_list = [{1,6300},{2,126000},{4,3150},{3,3150}]};

get_by_id_order(305415,43) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 43,attr_list = [{1,6450},{2,129000},{4,3225},{3,3225}]};

get_by_id_order(305415,44) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 44,attr_list = [{1,6600},{2,132000},{4,3300},{3,3300}]};

get_by_id_order(305415,45) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 45,attr_list = [{1,6750},{2,135000},{4,3375},{3,3375}]};

get_by_id_order(305415,46) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 46,attr_list = [{1,6900},{2,138000},{4,3450},{3,3450}]};

get_by_id_order(305415,47) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 47,attr_list = [{1,7050},{2,141000},{4,3525},{3,3525}]};

get_by_id_order(305415,48) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 48,attr_list = [{1,7200},{2,144000},{4,3600},{3,3600}]};

get_by_id_order(305415,49) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 49,attr_list = [{1,7350},{2,147000},{4,3675},{3,3675}]};

get_by_id_order(305415,50) ->
	#base_dsgt_order{dsgt_id = 305415,consume = [{0,38065415,1}],dsgt_order = 50,attr_list = [{1,7500},{2,150000},{4,3750},{3,3750}]};

get_by_id_order(306001,1) ->
	#base_dsgt_order{dsgt_id = 306001,consume = [],dsgt_order = 1,attr_list = [{1,4000},{2,80000},{4,2000},{3,2000}]};

get_by_id_order(306002,1) ->
	#base_dsgt_order{dsgt_id = 306002,consume = [],dsgt_order = 1,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(306003,1) ->
	#base_dsgt_order{dsgt_id = 306003,consume = [],dsgt_order = 1,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(306004,1) ->
	#base_dsgt_order{dsgt_id = 306004,consume = [],dsgt_order = 1,attr_list = [{1,4000},{2,80000},{4,2000},{3,2000}]};

get_by_id_order(306005,1) ->
	#base_dsgt_order{dsgt_id = 306005,consume = [],dsgt_order = 1,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(306006,1) ->
	#base_dsgt_order{dsgt_id = 306006,consume = [],dsgt_order = 1,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(306007,1) ->
	#base_dsgt_order{dsgt_id = 306007,consume = [],dsgt_order = 1,attr_list = [{1,4000},{2,80000},{4,2000},{3,2000}]};

get_by_id_order(306008,1) ->
	#base_dsgt_order{dsgt_id = 306008,consume = [],dsgt_order = 1,attr_list = [{1,3000},{2,60000},{4,1500},{3,1500}]};

get_by_id_order(306009,1) ->
	#base_dsgt_order{dsgt_id = 306009,consume = [],dsgt_order = 1,attr_list = [{1,1200},{2,24000},{4,600},{3,600}]};

get_by_id_order(307001,1) ->
	#base_dsgt_order{dsgt_id = 307001,consume = [],dsgt_order = 1,attr_list = [{2,2000},{4,50}]};

get_by_id_order(_Dsgtid,_Dsgtorder) ->
	[].

