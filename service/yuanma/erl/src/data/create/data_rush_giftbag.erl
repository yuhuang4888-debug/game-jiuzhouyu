%%%---------------------------------------
%%% module      : data_rush_giftbag
%%% description : 冲级豪礼配置
%%%
%%%---------------------------------------
-module(data_rush_giftbag).
-compile(export_all).
-include("rec_rush_giftbag.hrl").



get_giftbag_cfg(35) ->
	#base_rush_giftbag{bag_lv = 35,bag_name = "35级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{0,38067001,1},{3,0,100000}],bag_gift_woman = [{0,38067001,1},{3,0,100000}],limit_gift_man = [],limit_gift_woman = [],task_show = [{38067001,38067001,0}]};

get_giftbag_cfg(50) ->
	#base_rush_giftbag{bag_lv = 50,bag_name = "50级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{0,101103030,1},{3,0,200000}],bag_gift_woman = [{0,102103030,1},{3,0,200000}],limit_gift_man = [],limit_gift_woman = [],task_show = [{101103030,101103030,uirwl_014a}]};

get_giftbag_cfg(60) ->
	#base_rush_giftbag{bag_lv = 60,bag_name = "60级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{0,17020001,5},{0,37020001,1},{3,0,200000}],bag_gift_woman = [{0,17020001,5},{0,37020001,1},{3,0,200000}],limit_gift_man = [],limit_gift_woman = [],task_show = [{17020001,17020001,0}]};

get_giftbag_cfg(80) ->
	#base_rush_giftbag{bag_lv = 80,bag_name = "80级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{0,38030001,3},{0,16020001,10},{2,0,50}],bag_gift_woman = [{0,38030001,3},{0,16020001,10},{2,0,50}],limit_gift_man = [],limit_gift_woman = [],task_show = [{32010158,32010158,0}]};

get_giftbag_cfg(120) ->
	#base_rush_giftbag{bag_lv = 120,bag_name = "120级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{0,14010001,1},{0,38160001,1},{3,0,300000},{2,0,100}],bag_gift_woman = [{0,14010001,1},{0,38160001,1},{3,0,300000},{2,0,100}],limit_gift_man = [],limit_gift_woman = [],task_show = [{14010001,14010001,0}]};

get_giftbag_cfg(165) ->
	#base_rush_giftbag{bag_lv = 165,bag_name = "165级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{100,101054051,1},{0,38030003,1},{3,0,500000},{2,0,100}],bag_gift_woman = [{100,101054051,1},{0,38030003,1},{3,0,500000},{2,0,100}],limit_gift_man = [],limit_gift_woman = [],task_show = [{101054051,101054051,uirwl_013a}]};

get_giftbag_cfg(180) ->
	#base_rush_giftbag{bag_lv = 180,bag_name = "180级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{0,5902001,1},{0,38030001,3},{0,37020001,1},{2,0,100}],bag_gift_woman = [{0,5902001,1},{0,38030001,3},{0,37020001,1},{2,0,100}],limit_gift_man = [],limit_gift_woman = [],task_show = [{5902001,5902001,0}]};

get_giftbag_cfg(200) ->
	#base_rush_giftbag{bag_lv = 200,bag_name = "200级礼包",bag_upperlimit = 2000,bag_upperday = 0,bag_gift_man = [{0,14010003,1},{0,14020003,1},{0,37020001,1}],bag_gift_woman = [{0,14010003,1},{0,14020003,1},{0,37020001,1}],limit_gift_man = [{100,18030001,1}],limit_gift_woman = [{100,18030001,1}],task_show = [{18030001,18030001,uirwl_011a}]};

get_giftbag_cfg(240) ->
	#base_rush_giftbag{bag_lv = 240,bag_name = "240级礼包",bag_upperlimit = 100,bag_upperday = 0,bag_gift_man = [{0,16020001,15},{0,17020001,15},{0,37020001,1},{0,38030004,1}],bag_gift_woman = [{0,16020001,15},{0,17020001,15},{0,37020001,1},{0,38030004,1}],limit_gift_man = [{100,26010003,1}],limit_gift_woman = [{100,26010003,1}],task_show = [{26010003,26010003,uirwl_011a}]};

get_giftbag_cfg(270) ->
	#base_rush_giftbag{bag_lv = 270,bag_name = "270级礼包",bag_upperlimit = 50,bag_upperday = 0,bag_gift_man = [{0,19010001,1},{0,18020001,15},{0,19020001,15},{0,38030004,2}],bag_gift_woman = [{0,19010001,1},{0,18020001,15},{0,19020001,15},{0,38030004,2}],limit_gift_man = [{100,18030002,1}],limit_gift_woman = [{100,18030002,1}],task_show = [{32010468,32010468,uirwl_011a}]};

get_giftbag_cfg(300) ->
	#base_rush_giftbag{bag_lv = 300,bag_name = "300级礼包",bag_upperlimit = 10,bag_upperday = 0,bag_gift_man = [{0,38390001,1},{0,38040005,50},{0,18020001,30},{3,0,500000},{2,0,150}],bag_gift_woman = [{0,38390001,1},{0,38040005,50},{0,18020001,30},{3,0,500000},{2,0,150}],limit_gift_man = [{100,101045082,1}],limit_gift_woman = [{100,102045082,1}],task_show = [{101045082,101045082,uirwl_011a}]};

get_giftbag_cfg(350) ->
	#base_rush_giftbag{bag_lv = 350,bag_name = "350级礼包",bag_upperlimit = 5,bag_upperday = 0,bag_gift_man = [{0,14010004,1},{0,19020001,30},{3,0,500000},{2,0,150}],bag_gift_woman = [{0,14010004,1},{0,19020001,30},{3,0,500000},{2,0,150}],limit_gift_man = [{100,101085092,1}],limit_gift_woman = [{100,102085092,1}],task_show = [{101085092,101085092,uirwl_011a}]};

get_giftbag_cfg(400) ->
	#base_rush_giftbag{bag_lv = 400,bag_name = "400级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{100,101035102,1},{0,36255006,1},{0,36255008,5},{2,0,200}],bag_gift_woman = [{100,101035102,1},{0,36255006,1},{0,36255008,5},{2,0,200}],limit_gift_man = [],limit_gift_woman = [],task_show = [{101035102,101035102,0}]};

get_giftbag_cfg(450) ->
	#base_rush_giftbag{bag_lv = 450,bag_name = "450级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{100,38240027,1},{0,36255006,1},{0,36255008,5},{2,0,250}],bag_gift_woman = [{100,38240027,1},{0,36255006,1},{0,36255008,5},{2,0,250}],limit_gift_man = [],limit_gift_woman = [],task_show = [{38240027,38240027,0}]};

get_giftbag_cfg(500) ->
	#base_rush_giftbag{bag_lv = 500,bag_name = "500级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,300}],bag_gift_woman = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,300}],limit_gift_man = [],limit_gift_woman = [],task_show = [{38240027,38240027,0}]};

get_giftbag_cfg(550) ->
	#base_rush_giftbag{bag_lv = 550,bag_name = "550级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,400}],bag_gift_woman = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,400}],limit_gift_man = [],limit_gift_woman = [],task_show = [{38240027,38240027,0}]};

get_giftbag_cfg(600) ->
	#base_rush_giftbag{bag_lv = 600,bag_name = "600级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],bag_gift_woman = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],limit_gift_man = [],limit_gift_woman = [],task_show = [{38240027,38240027,0}]};

get_giftbag_cfg(650) ->
	#base_rush_giftbag{bag_lv = 650,bag_name = "650级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],bag_gift_woman = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],limit_gift_man = [],limit_gift_woman = [],task_show = [{38240027,38240027,0}]};

get_giftbag_cfg(700) ->
	#base_rush_giftbag{bag_lv = 700,bag_name = "700级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],bag_gift_woman = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],limit_gift_man = [],limit_gift_woman = [],task_show = [{38240027,38240027,0}]};

get_giftbag_cfg(750) ->
	#base_rush_giftbag{bag_lv = 750,bag_name = "750级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],bag_gift_woman = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],limit_gift_man = [],limit_gift_woman = [],task_show = [{38240027,38240027,0}]};

get_giftbag_cfg(800) ->
	#base_rush_giftbag{bag_lv = 800,bag_name = "800级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],bag_gift_woman = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],limit_gift_man = [],limit_gift_woman = [],task_show = [{38240027,38240027,0}]};

get_giftbag_cfg(850) ->
	#base_rush_giftbag{bag_lv = 850,bag_name = "850级礼包",bag_upperlimit = 0,bag_upperday = 0,bag_gift_man = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],bag_gift_woman = [{100,38240027,1},{0,36255006,1},{0,36255009,5},{2,0,500}],limit_gift_man = [],limit_gift_woman = [],task_show = [{38240027,38240027,0}]};

get_giftbag_cfg(_Baglv) ->
	[].

get_all_giftbag_lv() ->
[35,50,60,80,120,165,180,200,240,270,300,350,400,450,500,550,600,650,700,750,800,850].

