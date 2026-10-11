%%%---------------------------------------
%%% module      : data_hi_point
%%% description : 嗨点值配置
%%%
%%%---------------------------------------
-module(data_hi_point).
-compile(export_all).
-include("hi_point.hrl").



get_hi_point_cfg(0,0,0) ->
	#base_hi_point{sub_type = 0,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 10};

get_hi_point_cfg(0,158,0) ->
	#base_hi_point{sub_type = 0,mod_id = 158,sub_id = 0,name = "充值",is_single = 0,one_points = 5,max_points = 5,min_lv = 1,max_lv = 9999,order_id = 1,jump_id = 21,icon_type = "15801",reward_condition = [{recharge,3,30,1004}],is_process = 1,show_id = 10};

get_hi_point_cfg(0,159,0) ->
	#base_hi_point{sub_type = 0,mod_id = 159,sub_id = 0,name = "累计消费",is_single = 0,one_points = 5,max_points = 5,min_lv = 1,max_lv = 9999,order_id = 2,jump_id = 140,icon_type = "15802",reward_condition = [{cost,1680,50,1032},{cost,3880,50,1033},{cost,6880,50,1034},{cost,12880,70,1035},{cost,19880,90,1036}],is_process = 1,show_id = 10};

get_hi_point_cfg(0,160,1) ->
	#base_hi_point{sub_type = 0,mod_id = 160,sub_id = 1,name = "坐骑",is_single = 0,one_points = 5,max_points = 5,min_lv = 1,max_lv = 9999,order_id = 3,jump_id = 2,icon_type = "3702",reward_condition = [{stage,{4,2},6,1015},{stage,{4,3},9,1016},{stage,{4,5},15,1017}],is_process = 1,show_id = 10};

get_hi_point_cfg(0,160,2) ->
	#base_hi_point{sub_type = 0,mod_id = 160,sub_id = 2,name = "伙伴",is_single = 0,one_points = 5,max_points = 5,min_lv = 1,max_lv = 9999,order_id = 4,jump_id = 16,icon_type = "16002",reward_condition = [{stage,{4,2},6,1018},{stage,{4,3},9,1019},{stage,{4,5},15,1020}],is_process = 1,show_id = 10};

get_hi_point_cfg(0,170,0) ->
	#base_hi_point{sub_type = 0,mod_id = 170,sub_id = 0,name = "源力",is_single = 0,one_points = 5,max_points = 5,min_lv = 290,max_lv = 9999,order_id = 5,jump_id = 167,icon_type = "3732",reward_condition = [{lv,20,5,1010},{lv,30,5,1011},{lv,40,10,1012},{set,1,10,1013},{set,2,10,1014}],is_process = 1,show_id = 10};

get_hi_point_cfg(0,181,0) ->
	#base_hi_point{sub_type = 0,mod_id = 181,sub_id = 0,name = "龙纹",is_single = 0,one_points = 5,max_points = 5,min_lv = 320,max_lv = 9999,order_id = 6,jump_id = 117,icon_type = "3744",reward_condition = [{set,10,5,1025},{set,20,5,1026},{set,30,10,1027}],is_process = 1,show_id = 10};

get_hi_point_cfg(0,182,0) ->
	#base_hi_point{sub_type = 0,mod_id = 182,sub_id = 0,name = "宝宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 305,max_lv = 9999,order_id = 7,jump_id = 122,icon_type = "3747",reward_condition = [{lv,5,5,1021},{lv,10,5,1022},{lv,20,10,1023},{count,2,5,1024}],is_process = 1,show_id = 10};

get_hi_point_cfg(0,416,1) ->
	#base_hi_point{sub_type = 0,mod_id = 416,sub_id = 1,name = "装备夺宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 1,max_lv = 9999,order_id = 8,jump_id = 66,icon_type = "41601",reward_condition = [{count,10,20,1029},{count,20,40,1030},{count,50,100,1031}],is_process = 1,show_id = 10};

get_hi_point_cfg(0,460,4) ->
	#base_hi_point{sub_type = 0,mod_id = 460,sub_id = 4,name = "击杀1个蛮荒BOSS",is_single = 1,one_points = 1,max_points = 20,min_lv = 240,max_lv = 9999,order_id = 9,jump_id = 36,icon_type = "46004",reward_condition = [],is_process = 1,show_id = 10};

get_hi_point_cfg(0,460,7) ->
	#base_hi_point{sub_type = 0,mod_id = 460,sub_id = 7,name = "击杀1个BOSS之家BOSS",is_single = 1,one_points = 2,max_points = 40,min_lv = 180,max_lv = 9999,order_id = 10,jump_id = 28,icon_type = "46007",reward_condition = [],is_process = 1,show_id = 10};

get_hi_point_cfg(0,610,8) ->
	#base_hi_point{sub_type = 0,mod_id = 610,sub_id = 8,name = "源力副本",is_single = 0,one_points = 5,max_points = 5,min_lv = 290,max_lv = 9999,order_id = 11,jump_id = 101,icon_type = "3732",reward_condition = [{dungeon_8001,1,5,1008},{dungeon_8002,1,5,1009}],is_process = 1,show_id = 10};

get_hi_point_cfg(0,610,32) ->
	#base_hi_point{sub_type = 0,mod_id = 610,sub_id = 32,name = "参加1次龙纹副本",is_single = 1,one_points = 2,max_points = 20,min_lv = 320,max_lv = 9999,order_id = 12,jump_id = 120,icon_type = "3744",reward_condition = [],is_process = 1,show_id = 10};

get_hi_point_cfg(0,612,0) ->
	#base_hi_point{sub_type = 0,mod_id = 612,sub_id = 0,name = "等级",is_single = 0,one_points = 5,max_points = 5,min_lv = 1,max_lv = 9999,order_id = 13,jump_id = 82,icon_type = "61201",reward_condition = [{lv,300,5,1005},{lv,310,5,1006},{lv,320,10,1007}] ,is_process = 1,show_id = 10};

get_hi_point_cfg(2,0,0) ->
	#base_hi_point{sub_type = 2,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(2,102,0) ->
	#base_hi_point{sub_type = 2,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(2,158,0) ->
	#base_hi_point{sub_type = 2,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(2,159,0) ->
	#base_hi_point{sub_type = 2,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(2,280,0) ->
	#base_hi_point{sub_type = 2,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(2,415,0) ->
	#base_hi_point{sub_type = 2,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(2,416,1) ->
	#base_hi_point{sub_type = 2,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(2,416,4) ->
	#base_hi_point{sub_type = 2,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(2,460,1) ->
	#base_hi_point{sub_type = 2,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(2,460,1004) ->
	#base_hi_point{sub_type = 2,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(2,460,1020) ->
	#base_hi_point{sub_type = 2,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(2,610,2) ->
	#base_hi_point{sub_type = 2,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(2,610,5) ->
	#base_hi_point{sub_type = 2,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(2,610,10) ->
	#base_hi_point{sub_type = 2,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(2,610,18) ->
	#base_hi_point{sub_type = 2,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(2,610,20) ->
	#base_hi_point{sub_type = 2,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(2,610,32) ->
	#base_hi_point{sub_type = 2,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(2,610,37) ->
	#base_hi_point{sub_type = 2,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(3,0,0) ->
	#base_hi_point{sub_type = 3,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(3,102,0) ->
	#base_hi_point{sub_type = 3,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(3,158,0) ->
	#base_hi_point{sub_type = 3,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(3,159,0) ->
	#base_hi_point{sub_type = 3,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(3,280,0) ->
	#base_hi_point{sub_type = 3,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(3,415,0) ->
	#base_hi_point{sub_type = 3,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(3,416,1) ->
	#base_hi_point{sub_type = 3,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(3,416,4) ->
	#base_hi_point{sub_type = 3,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(3,460,1) ->
	#base_hi_point{sub_type = 3,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(3,460,1004) ->
	#base_hi_point{sub_type = 3,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(3,460,1020) ->
	#base_hi_point{sub_type = 3,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(3,610,2) ->
	#base_hi_point{sub_type = 3,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(3,610,5) ->
	#base_hi_point{sub_type = 3,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(3,610,10) ->
	#base_hi_point{sub_type = 3,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(3,610,18) ->
	#base_hi_point{sub_type = 3,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(3,610,20) ->
	#base_hi_point{sub_type = 3,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(3,610,32) ->
	#base_hi_point{sub_type = 3,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(3,610,37) ->
	#base_hi_point{sub_type = 3,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(4,0,0) ->
	#base_hi_point{sub_type = 4,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(4,102,0) ->
	#base_hi_point{sub_type = 4,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(4,158,0) ->
	#base_hi_point{sub_type = 4,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(4,159,0) ->
	#base_hi_point{sub_type = 4,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(4,280,0) ->
	#base_hi_point{sub_type = 4,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(4,415,0) ->
	#base_hi_point{sub_type = 4,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(4,416,1) ->
	#base_hi_point{sub_type = 4,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(4,416,4) ->
	#base_hi_point{sub_type = 4,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(4,460,1) ->
	#base_hi_point{sub_type = 4,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(4,460,1004) ->
	#base_hi_point{sub_type = 4,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(4,460,1020) ->
	#base_hi_point{sub_type = 4,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(4,610,2) ->
	#base_hi_point{sub_type = 4,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(4,610,5) ->
	#base_hi_point{sub_type = 4,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(4,610,10) ->
	#base_hi_point{sub_type = 4,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(4,610,18) ->
	#base_hi_point{sub_type = 4,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(4,610,20) ->
	#base_hi_point{sub_type = 4,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(4,610,32) ->
	#base_hi_point{sub_type = 4,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(4,610,37) ->
	#base_hi_point{sub_type = 4,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,0,0) ->
	#base_hi_point{sub_type = 5,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(5,102,0) ->
	#base_hi_point{sub_type = 5,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,158,0) ->
	#base_hi_point{sub_type = 5,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(5,159,0) ->
	#base_hi_point{sub_type = 5,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(5,280,0) ->
	#base_hi_point{sub_type = 5,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,415,0) ->
	#base_hi_point{sub_type = 5,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(5,416,1) ->
	#base_hi_point{sub_type = 5,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(5,416,4) ->
	#base_hi_point{sub_type = 5,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(5,460,1) ->
	#base_hi_point{sub_type = 5,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,460,1004) ->
	#base_hi_point{sub_type = 5,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,460,1020) ->
	#base_hi_point{sub_type = 5,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,610,2) ->
	#base_hi_point{sub_type = 5,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,610,5) ->
	#base_hi_point{sub_type = 5,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,610,10) ->
	#base_hi_point{sub_type = 5,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,610,18) ->
	#base_hi_point{sub_type = 5,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,610,20) ->
	#base_hi_point{sub_type = 5,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,610,32) ->
	#base_hi_point{sub_type = 5,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(5,610,37) ->
	#base_hi_point{sub_type = 5,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,0,0) ->
	#base_hi_point{sub_type = 6,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(6,102,0) ->
	#base_hi_point{sub_type = 6,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,158,0) ->
	#base_hi_point{sub_type = 6,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(6,159,0) ->
	#base_hi_point{sub_type = 6,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(6,280,0) ->
	#base_hi_point{sub_type = 6,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,415,0) ->
	#base_hi_point{sub_type = 6,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(6,416,1) ->
	#base_hi_point{sub_type = 6,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(6,416,4) ->
	#base_hi_point{sub_type = 6,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(6,460,1) ->
	#base_hi_point{sub_type = 6,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,460,1004) ->
	#base_hi_point{sub_type = 6,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,460,1020) ->
	#base_hi_point{sub_type = 6,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,610,2) ->
	#base_hi_point{sub_type = 6,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,610,5) ->
	#base_hi_point{sub_type = 6,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,610,10) ->
	#base_hi_point{sub_type = 6,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,610,18) ->
	#base_hi_point{sub_type = 6,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,610,20) ->
	#base_hi_point{sub_type = 6,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,610,32) ->
	#base_hi_point{sub_type = 6,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(6,610,37) ->
	#base_hi_point{sub_type = 6,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,0,0) ->
	#base_hi_point{sub_type = 7,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(7,102,0) ->
	#base_hi_point{sub_type = 7,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,158,0) ->
	#base_hi_point{sub_type = 7,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(7,159,0) ->
	#base_hi_point{sub_type = 7,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(7,280,0) ->
	#base_hi_point{sub_type = 7,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,415,0) ->
	#base_hi_point{sub_type = 7,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(7,416,1) ->
	#base_hi_point{sub_type = 7,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(7,416,4) ->
	#base_hi_point{sub_type = 7,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(7,460,1) ->
	#base_hi_point{sub_type = 7,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,460,1004) ->
	#base_hi_point{sub_type = 7,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,460,1020) ->
	#base_hi_point{sub_type = 7,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,610,2) ->
	#base_hi_point{sub_type = 7,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,610,5) ->
	#base_hi_point{sub_type = 7,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,610,10) ->
	#base_hi_point{sub_type = 7,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,610,18) ->
	#base_hi_point{sub_type = 7,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,610,20) ->
	#base_hi_point{sub_type = 7,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,610,32) ->
	#base_hi_point{sub_type = 7,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(7,610,37) ->
	#base_hi_point{sub_type = 7,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,0,0) ->
	#base_hi_point{sub_type = 8,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(8,102,0) ->
	#base_hi_point{sub_type = 8,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,158,0) ->
	#base_hi_point{sub_type = 8,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(8,159,0) ->
	#base_hi_point{sub_type = 8,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(8,280,0) ->
	#base_hi_point{sub_type = 8,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,415,0) ->
	#base_hi_point{sub_type = 8,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(8,416,1) ->
	#base_hi_point{sub_type = 8,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(8,416,4) ->
	#base_hi_point{sub_type = 8,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(8,460,1) ->
	#base_hi_point{sub_type = 8,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,460,1004) ->
	#base_hi_point{sub_type = 8,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,460,1020) ->
	#base_hi_point{sub_type = 8,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,610,2) ->
	#base_hi_point{sub_type = 8,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,610,5) ->
	#base_hi_point{sub_type = 8,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,610,10) ->
	#base_hi_point{sub_type = 8,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,610,18) ->
	#base_hi_point{sub_type = 8,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,610,20) ->
	#base_hi_point{sub_type = 8,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,610,32) ->
	#base_hi_point{sub_type = 8,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(8,610,37) ->
	#base_hi_point{sub_type = 8,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,0,0) ->
	#base_hi_point{sub_type = 9,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(9,102,0) ->
	#base_hi_point{sub_type = 9,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,158,0) ->
	#base_hi_point{sub_type = 9,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(9,159,0) ->
	#base_hi_point{sub_type = 9,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(9,280,0) ->
	#base_hi_point{sub_type = 9,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,415,0) ->
	#base_hi_point{sub_type = 9,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(9,416,1) ->
	#base_hi_point{sub_type = 9,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(9,416,4) ->
	#base_hi_point{sub_type = 9,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(9,460,1) ->
	#base_hi_point{sub_type = 9,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,460,1004) ->
	#base_hi_point{sub_type = 9,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,460,1020) ->
	#base_hi_point{sub_type = 9,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,610,2) ->
	#base_hi_point{sub_type = 9,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,610,5) ->
	#base_hi_point{sub_type = 9,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,610,10) ->
	#base_hi_point{sub_type = 9,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,610,18) ->
	#base_hi_point{sub_type = 9,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,610,20) ->
	#base_hi_point{sub_type = 9,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,610,32) ->
	#base_hi_point{sub_type = 9,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(9,610,37) ->
	#base_hi_point{sub_type = 9,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,0,0) ->
	#base_hi_point{sub_type = 10,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(10,102,0) ->
	#base_hi_point{sub_type = 10,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,158,0) ->
	#base_hi_point{sub_type = 10,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(10,159,0) ->
	#base_hi_point{sub_type = 10,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(10,280,0) ->
	#base_hi_point{sub_type = 10,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,415,0) ->
	#base_hi_point{sub_type = 10,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(10,416,1) ->
	#base_hi_point{sub_type = 10,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(10,416,4) ->
	#base_hi_point{sub_type = 10,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(10,460,1) ->
	#base_hi_point{sub_type = 10,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,460,1004) ->
	#base_hi_point{sub_type = 10,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,460,1020) ->
	#base_hi_point{sub_type = 10,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,610,2) ->
	#base_hi_point{sub_type = 10,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,610,5) ->
	#base_hi_point{sub_type = 10,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,610,10) ->
	#base_hi_point{sub_type = 10,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,610,18) ->
	#base_hi_point{sub_type = 10,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,610,20) ->
	#base_hi_point{sub_type = 10,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,610,32) ->
	#base_hi_point{sub_type = 10,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(10,610,37) ->
	#base_hi_point{sub_type = 10,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,0,0) ->
	#base_hi_point{sub_type = 11,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(11,102,0) ->
	#base_hi_point{sub_type = 11,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,158,0) ->
	#base_hi_point{sub_type = 11,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(11,159,0) ->
	#base_hi_point{sub_type = 11,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(11,280,0) ->
	#base_hi_point{sub_type = 11,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,415,0) ->
	#base_hi_point{sub_type = 11,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(11,416,1) ->
	#base_hi_point{sub_type = 11,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(11,416,4) ->
	#base_hi_point{sub_type = 11,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(11,460,1) ->
	#base_hi_point{sub_type = 11,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,460,1004) ->
	#base_hi_point{sub_type = 11,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,460,1020) ->
	#base_hi_point{sub_type = 11,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,610,2) ->
	#base_hi_point{sub_type = 11,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,610,5) ->
	#base_hi_point{sub_type = 11,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,610,10) ->
	#base_hi_point{sub_type = 11,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,610,18) ->
	#base_hi_point{sub_type = 11,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,610,20) ->
	#base_hi_point{sub_type = 11,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,610,32) ->
	#base_hi_point{sub_type = 11,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(11,610,37) ->
	#base_hi_point{sub_type = 11,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,0,0) ->
	#base_hi_point{sub_type = 12,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(12,102,0) ->
	#base_hi_point{sub_type = 12,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,158,0) ->
	#base_hi_point{sub_type = 12,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(12,159,0) ->
	#base_hi_point{sub_type = 12,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(12,280,0) ->
	#base_hi_point{sub_type = 12,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,415,0) ->
	#base_hi_point{sub_type = 12,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(12,416,1) ->
	#base_hi_point{sub_type = 12,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(12,416,4) ->
	#base_hi_point{sub_type = 12,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(12,460,1) ->
	#base_hi_point{sub_type = 12,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,460,1004) ->
	#base_hi_point{sub_type = 12,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,460,1020) ->
	#base_hi_point{sub_type = 12,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,610,2) ->
	#base_hi_point{sub_type = 12,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,610,5) ->
	#base_hi_point{sub_type = 12,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,610,10) ->
	#base_hi_point{sub_type = 12,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,610,18) ->
	#base_hi_point{sub_type = 12,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,610,20) ->
	#base_hi_point{sub_type = 12,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,610,32) ->
	#base_hi_point{sub_type = 12,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(12,610,37) ->
	#base_hi_point{sub_type = 12,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,0,0) ->
	#base_hi_point{sub_type = 13,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(13,102,0) ->
	#base_hi_point{sub_type = 13,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,158,0) ->
	#base_hi_point{sub_type = 13,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(13,159,0) ->
	#base_hi_point{sub_type = 13,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(13,280,0) ->
	#base_hi_point{sub_type = 13,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,415,0) ->
	#base_hi_point{sub_type = 13,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(13,416,1) ->
	#base_hi_point{sub_type = 13,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(13,416,4) ->
	#base_hi_point{sub_type = 13,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(13,460,1) ->
	#base_hi_point{sub_type = 13,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,460,1004) ->
	#base_hi_point{sub_type = 13,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,460,1020) ->
	#base_hi_point{sub_type = 13,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,610,2) ->
	#base_hi_point{sub_type = 13,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,610,5) ->
	#base_hi_point{sub_type = 13,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,610,10) ->
	#base_hi_point{sub_type = 13,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,610,18) ->
	#base_hi_point{sub_type = 13,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,610,20) ->
	#base_hi_point{sub_type = 13,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,610,32) ->
	#base_hi_point{sub_type = 13,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(13,610,37) ->
	#base_hi_point{sub_type = 13,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,0,0) ->
	#base_hi_point{sub_type = 14,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(14,102,0) ->
	#base_hi_point{sub_type = 14,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,158,0) ->
	#base_hi_point{sub_type = 14,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(14,159,0) ->
	#base_hi_point{sub_type = 14,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(14,280,0) ->
	#base_hi_point{sub_type = 14,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,415,0) ->
	#base_hi_point{sub_type = 14,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(14,416,1) ->
	#base_hi_point{sub_type = 14,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(14,416,4) ->
	#base_hi_point{sub_type = 14,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(14,460,1) ->
	#base_hi_point{sub_type = 14,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,460,1004) ->
	#base_hi_point{sub_type = 14,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,460,1020) ->
	#base_hi_point{sub_type = 14,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,610,2) ->
	#base_hi_point{sub_type = 14,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,610,5) ->
	#base_hi_point{sub_type = 14,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,610,10) ->
	#base_hi_point{sub_type = 14,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,610,18) ->
	#base_hi_point{sub_type = 14,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,610,20) ->
	#base_hi_point{sub_type = 14,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,610,32) ->
	#base_hi_point{sub_type = 14,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(14,610,37) ->
	#base_hi_point{sub_type = 14,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,0,0) ->
	#base_hi_point{sub_type = 15,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(15,102,0) ->
	#base_hi_point{sub_type = 15,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,158,0) ->
	#base_hi_point{sub_type = 15,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(15,159,0) ->
	#base_hi_point{sub_type = 15,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(15,280,0) ->
	#base_hi_point{sub_type = 15,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,415,0) ->
	#base_hi_point{sub_type = 15,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(15,416,1) ->
	#base_hi_point{sub_type = 15,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(15,416,4) ->
	#base_hi_point{sub_type = 15,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(15,460,1) ->
	#base_hi_point{sub_type = 15,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,460,1004) ->
	#base_hi_point{sub_type = 15,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,460,1020) ->
	#base_hi_point{sub_type = 15,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,610,2) ->
	#base_hi_point{sub_type = 15,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,610,5) ->
	#base_hi_point{sub_type = 15,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,610,10) ->
	#base_hi_point{sub_type = 15,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,610,18) ->
	#base_hi_point{sub_type = 15,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,610,20) ->
	#base_hi_point{sub_type = 15,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,610,32) ->
	#base_hi_point{sub_type = 15,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(15,610,37) ->
	#base_hi_point{sub_type = 15,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,0,0) ->
	#base_hi_point{sub_type = 16,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(16,102,0) ->
	#base_hi_point{sub_type = 16,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,158,0) ->
	#base_hi_point{sub_type = 16,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(16,159,0) ->
	#base_hi_point{sub_type = 16,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(16,280,0) ->
	#base_hi_point{sub_type = 16,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,415,0) ->
	#base_hi_point{sub_type = 16,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(16,416,1) ->
	#base_hi_point{sub_type = 16,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(16,416,4) ->
	#base_hi_point{sub_type = 16,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(16,460,1) ->
	#base_hi_point{sub_type = 16,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,460,1004) ->
	#base_hi_point{sub_type = 16,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,460,1020) ->
	#base_hi_point{sub_type = 16,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,610,2) ->
	#base_hi_point{sub_type = 16,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,610,5) ->
	#base_hi_point{sub_type = 16,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,610,10) ->
	#base_hi_point{sub_type = 16,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,610,18) ->
	#base_hi_point{sub_type = 16,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,610,20) ->
	#base_hi_point{sub_type = 16,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,610,32) ->
	#base_hi_point{sub_type = 16,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(16,610,37) ->
	#base_hi_point{sub_type = 16,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,0,0) ->
	#base_hi_point{sub_type = 17,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(17,102,0) ->
	#base_hi_point{sub_type = 17,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,158,0) ->
	#base_hi_point{sub_type = 17,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(17,159,0) ->
	#base_hi_point{sub_type = 17,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(17,280,0) ->
	#base_hi_point{sub_type = 17,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,415,0) ->
	#base_hi_point{sub_type = 17,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(17,416,1) ->
	#base_hi_point{sub_type = 17,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(17,416,4) ->
	#base_hi_point{sub_type = 17,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(17,460,1) ->
	#base_hi_point{sub_type = 17,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,460,1004) ->
	#base_hi_point{sub_type = 17,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,460,1020) ->
	#base_hi_point{sub_type = 17,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,610,2) ->
	#base_hi_point{sub_type = 17,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,610,5) ->
	#base_hi_point{sub_type = 17,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,610,10) ->
	#base_hi_point{sub_type = 17,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,610,18) ->
	#base_hi_point{sub_type = 17,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,610,20) ->
	#base_hi_point{sub_type = 17,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,610,32) ->
	#base_hi_point{sub_type = 17,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(17,610,37) ->
	#base_hi_point{sub_type = 17,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,0,0) ->
	#base_hi_point{sub_type = 18,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(18,102,0) ->
	#base_hi_point{sub_type = 18,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,158,0) ->
	#base_hi_point{sub_type = 18,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(18,159,0) ->
	#base_hi_point{sub_type = 18,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(18,280,0) ->
	#base_hi_point{sub_type = 18,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,415,0) ->
	#base_hi_point{sub_type = 18,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(18,416,1) ->
	#base_hi_point{sub_type = 18,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(18,416,4) ->
	#base_hi_point{sub_type = 18,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(18,460,1) ->
	#base_hi_point{sub_type = 18,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,460,1004) ->
	#base_hi_point{sub_type = 18,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,460,1020) ->
	#base_hi_point{sub_type = 18,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,610,2) ->
	#base_hi_point{sub_type = 18,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,610,5) ->
	#base_hi_point{sub_type = 18,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,610,10) ->
	#base_hi_point{sub_type = 18,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,610,18) ->
	#base_hi_point{sub_type = 18,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,610,20) ->
	#base_hi_point{sub_type = 18,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,610,32) ->
	#base_hi_point{sub_type = 18,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(18,610,37) ->
	#base_hi_point{sub_type = 18,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,0,0) ->
	#base_hi_point{sub_type = 19,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(19,102,0) ->
	#base_hi_point{sub_type = 19,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,158,0) ->
	#base_hi_point{sub_type = 19,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(19,159,0) ->
	#base_hi_point{sub_type = 19,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(19,280,0) ->
	#base_hi_point{sub_type = 19,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,415,0) ->
	#base_hi_point{sub_type = 19,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(19,416,1) ->
	#base_hi_point{sub_type = 19,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(19,416,4) ->
	#base_hi_point{sub_type = 19,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(19,460,1) ->
	#base_hi_point{sub_type = 19,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,460,1004) ->
	#base_hi_point{sub_type = 19,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,460,1020) ->
	#base_hi_point{sub_type = 19,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,610,2) ->
	#base_hi_point{sub_type = 19,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,610,5) ->
	#base_hi_point{sub_type = 19,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,610,10) ->
	#base_hi_point{sub_type = 19,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,610,18) ->
	#base_hi_point{sub_type = 19,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,610,20) ->
	#base_hi_point{sub_type = 19,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,610,32) ->
	#base_hi_point{sub_type = 19,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(19,610,37) ->
	#base_hi_point{sub_type = 19,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,0,0) ->
	#base_hi_point{sub_type = 20,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(20,102,0) ->
	#base_hi_point{sub_type = 20,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,158,0) ->
	#base_hi_point{sub_type = 20,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(20,159,0) ->
	#base_hi_point{sub_type = 20,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(20,280,0) ->
	#base_hi_point{sub_type = 20,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,415,0) ->
	#base_hi_point{sub_type = 20,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(20,416,1) ->
	#base_hi_point{sub_type = 20,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(20,416,4) ->
	#base_hi_point{sub_type = 20,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(20,460,1) ->
	#base_hi_point{sub_type = 20,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,460,1004) ->
	#base_hi_point{sub_type = 20,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,460,1020) ->
	#base_hi_point{sub_type = 20,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,610,2) ->
	#base_hi_point{sub_type = 20,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,610,5) ->
	#base_hi_point{sub_type = 20,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,610,10) ->
	#base_hi_point{sub_type = 20,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,610,18) ->
	#base_hi_point{sub_type = 20,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,610,20) ->
	#base_hi_point{sub_type = 20,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,610,32) ->
	#base_hi_point{sub_type = 20,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(20,610,37) ->
	#base_hi_point{sub_type = 20,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,0,0) ->
	#base_hi_point{sub_type = 21,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(21,102,0) ->
	#base_hi_point{sub_type = 21,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,158,0) ->
	#base_hi_point{sub_type = 21,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(21,159,0) ->
	#base_hi_point{sub_type = 21,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(21,280,0) ->
	#base_hi_point{sub_type = 21,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,415,0) ->
	#base_hi_point{sub_type = 21,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(21,416,1) ->
	#base_hi_point{sub_type = 21,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(21,416,4) ->
	#base_hi_point{sub_type = 21,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(21,460,1) ->
	#base_hi_point{sub_type = 21,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,460,1004) ->
	#base_hi_point{sub_type = 21,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,460,1020) ->
	#base_hi_point{sub_type = 21,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,610,2) ->
	#base_hi_point{sub_type = 21,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,610,5) ->
	#base_hi_point{sub_type = 21,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,610,10) ->
	#base_hi_point{sub_type = 21,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,610,18) ->
	#base_hi_point{sub_type = 21,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,610,20) ->
	#base_hi_point{sub_type = 21,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,610,32) ->
	#base_hi_point{sub_type = 21,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(21,610,37) ->
	#base_hi_point{sub_type = 21,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,0,0) ->
	#base_hi_point{sub_type = 22,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(22,102,0) ->
	#base_hi_point{sub_type = 22,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,158,0) ->
	#base_hi_point{sub_type = 22,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(22,159,0) ->
	#base_hi_point{sub_type = 22,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(22,280,0) ->
	#base_hi_point{sub_type = 22,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,415,0) ->
	#base_hi_point{sub_type = 22,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(22,416,1) ->
	#base_hi_point{sub_type = 22,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(22,416,4) ->
	#base_hi_point{sub_type = 22,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(22,460,1) ->
	#base_hi_point{sub_type = 22,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,460,1004) ->
	#base_hi_point{sub_type = 22,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,460,1020) ->
	#base_hi_point{sub_type = 22,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,610,2) ->
	#base_hi_point{sub_type = 22,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,610,5) ->
	#base_hi_point{sub_type = 22,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,610,10) ->
	#base_hi_point{sub_type = 22,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,610,18) ->
	#base_hi_point{sub_type = 22,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,610,20) ->
	#base_hi_point{sub_type = 22,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,610,32) ->
	#base_hi_point{sub_type = 22,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(22,610,37) ->
	#base_hi_point{sub_type = 22,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,0,0) ->
	#base_hi_point{sub_type = 23,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(23,102,0) ->
	#base_hi_point{sub_type = 23,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,158,0) ->
	#base_hi_point{sub_type = 23,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(23,159,0) ->
	#base_hi_point{sub_type = 23,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(23,280,0) ->
	#base_hi_point{sub_type = 23,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,415,0) ->
	#base_hi_point{sub_type = 23,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(23,416,1) ->
	#base_hi_point{sub_type = 23,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(23,416,4) ->
	#base_hi_point{sub_type = 23,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(23,460,1) ->
	#base_hi_point{sub_type = 23,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,460,1004) ->
	#base_hi_point{sub_type = 23,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,460,1020) ->
	#base_hi_point{sub_type = 23,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,610,2) ->
	#base_hi_point{sub_type = 23,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,610,5) ->
	#base_hi_point{sub_type = 23,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,610,10) ->
	#base_hi_point{sub_type = 23,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,610,18) ->
	#base_hi_point{sub_type = 23,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,610,20) ->
	#base_hi_point{sub_type = 23,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,610,32) ->
	#base_hi_point{sub_type = 23,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(23,610,37) ->
	#base_hi_point{sub_type = 23,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,0,0) ->
	#base_hi_point{sub_type = 24,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(24,102,0) ->
	#base_hi_point{sub_type = 24,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,158,0) ->
	#base_hi_point{sub_type = 24,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(24,159,0) ->
	#base_hi_point{sub_type = 24,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(24,280,0) ->
	#base_hi_point{sub_type = 24,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,415,0) ->
	#base_hi_point{sub_type = 24,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(24,416,1) ->
	#base_hi_point{sub_type = 24,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(24,416,4) ->
	#base_hi_point{sub_type = 24,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(24,460,1) ->
	#base_hi_point{sub_type = 24,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,460,1004) ->
	#base_hi_point{sub_type = 24,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,460,1020) ->
	#base_hi_point{sub_type = 24,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,610,2) ->
	#base_hi_point{sub_type = 24,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,610,5) ->
	#base_hi_point{sub_type = 24,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,610,10) ->
	#base_hi_point{sub_type = 24,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,610,18) ->
	#base_hi_point{sub_type = 24,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,610,20) ->
	#base_hi_point{sub_type = 24,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,610,32) ->
	#base_hi_point{sub_type = 24,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(24,610,37) ->
	#base_hi_point{sub_type = 24,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,0,0) ->
	#base_hi_point{sub_type = 25,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(25,102,0) ->
	#base_hi_point{sub_type = 25,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,158,0) ->
	#base_hi_point{sub_type = 25,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(25,159,0) ->
	#base_hi_point{sub_type = 25,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(25,280,0) ->
	#base_hi_point{sub_type = 25,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,415,0) ->
	#base_hi_point{sub_type = 25,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(25,416,1) ->
	#base_hi_point{sub_type = 25,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(25,416,4) ->
	#base_hi_point{sub_type = 25,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(25,460,1) ->
	#base_hi_point{sub_type = 25,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,460,1004) ->
	#base_hi_point{sub_type = 25,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,460,1020) ->
	#base_hi_point{sub_type = 25,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,610,2) ->
	#base_hi_point{sub_type = 25,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,610,5) ->
	#base_hi_point{sub_type = 25,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,610,10) ->
	#base_hi_point{sub_type = 25,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,610,18) ->
	#base_hi_point{sub_type = 25,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,610,20) ->
	#base_hi_point{sub_type = 25,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,610,32) ->
	#base_hi_point{sub_type = 25,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(25,610,37) ->
	#base_hi_point{sub_type = 25,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,0,0) ->
	#base_hi_point{sub_type = 26,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(26,102,0) ->
	#base_hi_point{sub_type = 26,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,158,0) ->
	#base_hi_point{sub_type = 26,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(26,159,0) ->
	#base_hi_point{sub_type = 26,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(26,280,0) ->
	#base_hi_point{sub_type = 26,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,415,0) ->
	#base_hi_point{sub_type = 26,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(26,416,1) ->
	#base_hi_point{sub_type = 26,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(26,416,4) ->
	#base_hi_point{sub_type = 26,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(26,460,1) ->
	#base_hi_point{sub_type = 26,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,460,1004) ->
	#base_hi_point{sub_type = 26,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,460,1020) ->
	#base_hi_point{sub_type = 26,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,610,2) ->
	#base_hi_point{sub_type = 26,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,610,5) ->
	#base_hi_point{sub_type = 26,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,610,10) ->
	#base_hi_point{sub_type = 26,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,610,18) ->
	#base_hi_point{sub_type = 26,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,610,20) ->
	#base_hi_point{sub_type = 26,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,610,32) ->
	#base_hi_point{sub_type = 26,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(26,610,37) ->
	#base_hi_point{sub_type = 26,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,0,0) ->
	#base_hi_point{sub_type = 27,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(27,102,0) ->
	#base_hi_point{sub_type = 27,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,158,0) ->
	#base_hi_point{sub_type = 27,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(27,159,0) ->
	#base_hi_point{sub_type = 27,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(27,280,0) ->
	#base_hi_point{sub_type = 27,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,415,0) ->
	#base_hi_point{sub_type = 27,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(27,416,1) ->
	#base_hi_point{sub_type = 27,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(27,416,4) ->
	#base_hi_point{sub_type = 27,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(27,460,1) ->
	#base_hi_point{sub_type = 27,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,460,1004) ->
	#base_hi_point{sub_type = 27,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,460,1020) ->
	#base_hi_point{sub_type = 27,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,610,2) ->
	#base_hi_point{sub_type = 27,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,610,5) ->
	#base_hi_point{sub_type = 27,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,610,10) ->
	#base_hi_point{sub_type = 27,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,610,18) ->
	#base_hi_point{sub_type = 27,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,610,20) ->
	#base_hi_point{sub_type = 27,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,610,32) ->
	#base_hi_point{sub_type = 27,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(27,610,37) ->
	#base_hi_point{sub_type = 27,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,0,0) ->
	#base_hi_point{sub_type = 28,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(28,102,0) ->
	#base_hi_point{sub_type = 28,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,158,0) ->
	#base_hi_point{sub_type = 28,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(28,159,0) ->
	#base_hi_point{sub_type = 28,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(28,280,0) ->
	#base_hi_point{sub_type = 28,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,415,0) ->
	#base_hi_point{sub_type = 28,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(28,416,1) ->
	#base_hi_point{sub_type = 28,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(28,416,4) ->
	#base_hi_point{sub_type = 28,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(28,460,1) ->
	#base_hi_point{sub_type = 28,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,460,1004) ->
	#base_hi_point{sub_type = 28,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,460,1020) ->
	#base_hi_point{sub_type = 28,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,610,2) ->
	#base_hi_point{sub_type = 28,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,610,5) ->
	#base_hi_point{sub_type = 28,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,610,10) ->
	#base_hi_point{sub_type = 28,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,610,18) ->
	#base_hi_point{sub_type = 28,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,610,20) ->
	#base_hi_point{sub_type = 28,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,610,32) ->
	#base_hi_point{sub_type = 28,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(28,610,37) ->
	#base_hi_point{sub_type = 28,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,0,0) ->
	#base_hi_point{sub_type = 29,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(29,102,0) ->
	#base_hi_point{sub_type = 29,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,158,0) ->
	#base_hi_point{sub_type = 29,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(29,159,0) ->
	#base_hi_point{sub_type = 29,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(29,280,0) ->
	#base_hi_point{sub_type = 29,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,415,0) ->
	#base_hi_point{sub_type = 29,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(29,416,1) ->
	#base_hi_point{sub_type = 29,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(29,416,4) ->
	#base_hi_point{sub_type = 29,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(29,460,1) ->
	#base_hi_point{sub_type = 29,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,460,1004) ->
	#base_hi_point{sub_type = 29,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,460,1020) ->
	#base_hi_point{sub_type = 29,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,610,2) ->
	#base_hi_point{sub_type = 29,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,610,5) ->
	#base_hi_point{sub_type = 29,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,610,10) ->
	#base_hi_point{sub_type = 29,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,610,18) ->
	#base_hi_point{sub_type = 29,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,610,20) ->
	#base_hi_point{sub_type = 29,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,610,32) ->
	#base_hi_point{sub_type = 29,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(29,610,37) ->
	#base_hi_point{sub_type = 29,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,0,0) ->
	#base_hi_point{sub_type = 30,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(30,102,0) ->
	#base_hi_point{sub_type = 30,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,158,0) ->
	#base_hi_point{sub_type = 30,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(30,159,0) ->
	#base_hi_point{sub_type = 30,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(30,280,0) ->
	#base_hi_point{sub_type = 30,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,415,0) ->
	#base_hi_point{sub_type = 30,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(30,416,1) ->
	#base_hi_point{sub_type = 30,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(30,416,4) ->
	#base_hi_point{sub_type = 30,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(30,460,1) ->
	#base_hi_point{sub_type = 30,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,460,1004) ->
	#base_hi_point{sub_type = 30,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,460,1020) ->
	#base_hi_point{sub_type = 30,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,610,2) ->
	#base_hi_point{sub_type = 30,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,610,5) ->
	#base_hi_point{sub_type = 30,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,610,10) ->
	#base_hi_point{sub_type = 30,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,610,18) ->
	#base_hi_point{sub_type = 30,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,610,20) ->
	#base_hi_point{sub_type = 30,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,610,32) ->
	#base_hi_point{sub_type = 30,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(30,610,37) ->
	#base_hi_point{sub_type = 30,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,0,0) ->
	#base_hi_point{sub_type = 31,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(31,102,0) ->
	#base_hi_point{sub_type = 31,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,158,0) ->
	#base_hi_point{sub_type = 31,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(31,159,0) ->
	#base_hi_point{sub_type = 31,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(31,280,0) ->
	#base_hi_point{sub_type = 31,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,415,0) ->
	#base_hi_point{sub_type = 31,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(31,416,1) ->
	#base_hi_point{sub_type = 31,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(31,416,4) ->
	#base_hi_point{sub_type = 31,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(31,460,1) ->
	#base_hi_point{sub_type = 31,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,460,1004) ->
	#base_hi_point{sub_type = 31,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,460,1020) ->
	#base_hi_point{sub_type = 31,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,610,2) ->
	#base_hi_point{sub_type = 31,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,610,5) ->
	#base_hi_point{sub_type = 31,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,610,10) ->
	#base_hi_point{sub_type = 31,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,610,18) ->
	#base_hi_point{sub_type = 31,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,610,20) ->
	#base_hi_point{sub_type = 31,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,610,32) ->
	#base_hi_point{sub_type = 31,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(31,610,37) ->
	#base_hi_point{sub_type = 31,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,0,0) ->
	#base_hi_point{sub_type = 32,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(32,102,0) ->
	#base_hi_point{sub_type = 32,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,158,0) ->
	#base_hi_point{sub_type = 32,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(32,159,0) ->
	#base_hi_point{sub_type = 32,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(32,280,0) ->
	#base_hi_point{sub_type = 32,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,415,0) ->
	#base_hi_point{sub_type = 32,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(32,416,1) ->
	#base_hi_point{sub_type = 32,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(32,416,4) ->
	#base_hi_point{sub_type = 32,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(32,460,1) ->
	#base_hi_point{sub_type = 32,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,460,1004) ->
	#base_hi_point{sub_type = 32,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,460,1020) ->
	#base_hi_point{sub_type = 32,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,610,2) ->
	#base_hi_point{sub_type = 32,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,610,5) ->
	#base_hi_point{sub_type = 32,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,610,10) ->
	#base_hi_point{sub_type = 32,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,610,18) ->
	#base_hi_point{sub_type = 32,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,610,20) ->
	#base_hi_point{sub_type = 32,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,610,32) ->
	#base_hi_point{sub_type = 32,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(32,610,37) ->
	#base_hi_point{sub_type = 32,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,0,0) ->
	#base_hi_point{sub_type = 33,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(33,102,0) ->
	#base_hi_point{sub_type = 33,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,158,0) ->
	#base_hi_point{sub_type = 33,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(33,159,0) ->
	#base_hi_point{sub_type = 33,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(33,280,0) ->
	#base_hi_point{sub_type = 33,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,415,0) ->
	#base_hi_point{sub_type = 33,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(33,416,1) ->
	#base_hi_point{sub_type = 33,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(33,416,4) ->
	#base_hi_point{sub_type = 33,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(33,460,1) ->
	#base_hi_point{sub_type = 33,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,460,1004) ->
	#base_hi_point{sub_type = 33,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,460,1020) ->
	#base_hi_point{sub_type = 33,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,610,2) ->
	#base_hi_point{sub_type = 33,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,610,5) ->
	#base_hi_point{sub_type = 33,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,610,10) ->
	#base_hi_point{sub_type = 33,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,610,18) ->
	#base_hi_point{sub_type = 33,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,610,20) ->
	#base_hi_point{sub_type = 33,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,610,32) ->
	#base_hi_point{sub_type = 33,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(33,610,37) ->
	#base_hi_point{sub_type = 33,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,0,0) ->
	#base_hi_point{sub_type = 34,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(34,102,0) ->
	#base_hi_point{sub_type = 34,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,158,0) ->
	#base_hi_point{sub_type = 34,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(34,159,0) ->
	#base_hi_point{sub_type = 34,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(34,280,0) ->
	#base_hi_point{sub_type = 34,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,415,0) ->
	#base_hi_point{sub_type = 34,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(34,416,1) ->
	#base_hi_point{sub_type = 34,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(34,416,4) ->
	#base_hi_point{sub_type = 34,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(34,460,1) ->
	#base_hi_point{sub_type = 34,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,460,1004) ->
	#base_hi_point{sub_type = 34,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,460,1020) ->
	#base_hi_point{sub_type = 34,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,610,2) ->
	#base_hi_point{sub_type = 34,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,610,5) ->
	#base_hi_point{sub_type = 34,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,610,10) ->
	#base_hi_point{sub_type = 34,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,610,18) ->
	#base_hi_point{sub_type = 34,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,610,20) ->
	#base_hi_point{sub_type = 34,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,610,32) ->
	#base_hi_point{sub_type = 34,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(34,610,37) ->
	#base_hi_point{sub_type = 34,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,0,0) ->
	#base_hi_point{sub_type = 35,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(35,102,0) ->
	#base_hi_point{sub_type = 35,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,158,0) ->
	#base_hi_point{sub_type = 35,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(35,159,0) ->
	#base_hi_point{sub_type = 35,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(35,280,0) ->
	#base_hi_point{sub_type = 35,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,415,0) ->
	#base_hi_point{sub_type = 35,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(35,416,1) ->
	#base_hi_point{sub_type = 35,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(35,416,4) ->
	#base_hi_point{sub_type = 35,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(35,460,1) ->
	#base_hi_point{sub_type = 35,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,460,1004) ->
	#base_hi_point{sub_type = 35,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,460,1020) ->
	#base_hi_point{sub_type = 35,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,610,2) ->
	#base_hi_point{sub_type = 35,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,610,5) ->
	#base_hi_point{sub_type = 35,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,610,10) ->
	#base_hi_point{sub_type = 35,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,610,18) ->
	#base_hi_point{sub_type = 35,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,610,20) ->
	#base_hi_point{sub_type = 35,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,610,32) ->
	#base_hi_point{sub_type = 35,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(35,610,37) ->
	#base_hi_point{sub_type = 35,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(36,0,0) ->
	#base_hi_point{sub_type = 36,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(36,102,0) ->
	#base_hi_point{sub_type = 36,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(36,158,0) ->
	#base_hi_point{sub_type = 36,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(36,159,0) ->
	#base_hi_point{sub_type = 36,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(36,280,0) ->
	#base_hi_point{sub_type = 36,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(36,415,0) ->
	#base_hi_point{sub_type = 36,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(36,416,1) ->
	#base_hi_point{sub_type = 36,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(36,416,4) ->
	#base_hi_point{sub_type = 36,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(36,460,1) ->
	#base_hi_point{sub_type = 36,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(36,460,1004) ->
	#base_hi_point{sub_type = 36,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(36,460,1020) ->
	#base_hi_point{sub_type = 36,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(36,610,2) ->
	#base_hi_point{sub_type = 36,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(36,610,5) ->
	#base_hi_point{sub_type = 36,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(36,610,10) ->
	#base_hi_point{sub_type = 36,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(36,610,18) ->
	#base_hi_point{sub_type = 36,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(36,610,20) ->
	#base_hi_point{sub_type = 36,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(36,610,32) ->
	#base_hi_point{sub_type = 36,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(36,610,37) ->
	#base_hi_point{sub_type = 36,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,0,0) ->
	#base_hi_point{sub_type = 37,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(37,102,0) ->
	#base_hi_point{sub_type = 37,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,158,0) ->
	#base_hi_point{sub_type = 37,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(37,159,0) ->
	#base_hi_point{sub_type = 37,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(37,280,0) ->
	#base_hi_point{sub_type = 37,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,415,0) ->
	#base_hi_point{sub_type = 37,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(37,416,1) ->
	#base_hi_point{sub_type = 37,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(37,416,4) ->
	#base_hi_point{sub_type = 37,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(37,460,1) ->
	#base_hi_point{sub_type = 37,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,460,1004) ->
	#base_hi_point{sub_type = 37,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,460,1020) ->
	#base_hi_point{sub_type = 37,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,610,2) ->
	#base_hi_point{sub_type = 37,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,610,5) ->
	#base_hi_point{sub_type = 37,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,610,10) ->
	#base_hi_point{sub_type = 37,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,610,18) ->
	#base_hi_point{sub_type = 37,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,610,20) ->
	#base_hi_point{sub_type = 37,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,610,32) ->
	#base_hi_point{sub_type = 37,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(37,610,37) ->
	#base_hi_point{sub_type = 37,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(38,0,0) ->
	#base_hi_point{sub_type = 38,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(38,102,0) ->
	#base_hi_point{sub_type = 38,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(38,158,0) ->
	#base_hi_point{sub_type = 38,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(38,159,0) ->
	#base_hi_point{sub_type = 38,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(38,280,0) ->
	#base_hi_point{sub_type = 38,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(38,415,0) ->
	#base_hi_point{sub_type = 38,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(38,416,1) ->
	#base_hi_point{sub_type = 38,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(38,416,4) ->
	#base_hi_point{sub_type = 38,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(38,460,1) ->
	#base_hi_point{sub_type = 38,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(38,460,1004) ->
	#base_hi_point{sub_type = 38,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(38,460,1020) ->
	#base_hi_point{sub_type = 38,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(38,610,2) ->
	#base_hi_point{sub_type = 38,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(38,610,5) ->
	#base_hi_point{sub_type = 38,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(38,610,10) ->
	#base_hi_point{sub_type = 38,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(38,610,18) ->
	#base_hi_point{sub_type = 38,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(38,610,20) ->
	#base_hi_point{sub_type = 38,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(38,610,32) ->
	#base_hi_point{sub_type = 38,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(38,610,37) ->
	#base_hi_point{sub_type = 38,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,0,0) ->
	#base_hi_point{sub_type = 39,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(39,102,0) ->
	#base_hi_point{sub_type = 39,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,158,0) ->
	#base_hi_point{sub_type = 39,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(39,159,0) ->
	#base_hi_point{sub_type = 39,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(39,280,0) ->
	#base_hi_point{sub_type = 39,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,415,0) ->
	#base_hi_point{sub_type = 39,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(39,416,1) ->
	#base_hi_point{sub_type = 39,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(39,416,4) ->
	#base_hi_point{sub_type = 39,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(39,460,1) ->
	#base_hi_point{sub_type = 39,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,460,1004) ->
	#base_hi_point{sub_type = 39,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,460,1020) ->
	#base_hi_point{sub_type = 39,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,610,2) ->
	#base_hi_point{sub_type = 39,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,610,5) ->
	#base_hi_point{sub_type = 39,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,610,10) ->
	#base_hi_point{sub_type = 39,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,610,18) ->
	#base_hi_point{sub_type = 39,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,610,20) ->
	#base_hi_point{sub_type = 39,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,610,32) ->
	#base_hi_point{sub_type = 39,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(39,610,37) ->
	#base_hi_point{sub_type = 39,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,0,0) ->
	#base_hi_point{sub_type = 40,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(40,102,0) ->
	#base_hi_point{sub_type = 40,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,158,0) ->
	#base_hi_point{sub_type = 40,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(40,159,0) ->
	#base_hi_point{sub_type = 40,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(40,280,0) ->
	#base_hi_point{sub_type = 40,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,415,0) ->
	#base_hi_point{sub_type = 40,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(40,416,1) ->
	#base_hi_point{sub_type = 40,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(40,416,4) ->
	#base_hi_point{sub_type = 40,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(40,460,1) ->
	#base_hi_point{sub_type = 40,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,460,1004) ->
	#base_hi_point{sub_type = 40,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,460,1020) ->
	#base_hi_point{sub_type = 40,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,610,2) ->
	#base_hi_point{sub_type = 40,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,610,5) ->
	#base_hi_point{sub_type = 40,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,610,10) ->
	#base_hi_point{sub_type = 40,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,610,18) ->
	#base_hi_point{sub_type = 40,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,610,20) ->
	#base_hi_point{sub_type = 40,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,610,32) ->
	#base_hi_point{sub_type = 40,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(40,610,37) ->
	#base_hi_point{sub_type = 40,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(41,0,0) ->
	#base_hi_point{sub_type = 41,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(41,102,0) ->
	#base_hi_point{sub_type = 41,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(41,158,0) ->
	#base_hi_point{sub_type = 41,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(41,159,0) ->
	#base_hi_point{sub_type = 41,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(41,280,0) ->
	#base_hi_point{sub_type = 41,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(41,415,0) ->
	#base_hi_point{sub_type = 41,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(41,416,1) ->
	#base_hi_point{sub_type = 41,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(41,416,4) ->
	#base_hi_point{sub_type = 41,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(41,460,1) ->
	#base_hi_point{sub_type = 41,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(41,460,1004) ->
	#base_hi_point{sub_type = 41,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(41,460,1020) ->
	#base_hi_point{sub_type = 41,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(41,610,2) ->
	#base_hi_point{sub_type = 41,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(41,610,5) ->
	#base_hi_point{sub_type = 41,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(41,610,10) ->
	#base_hi_point{sub_type = 41,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(41,610,18) ->
	#base_hi_point{sub_type = 41,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(41,610,20) ->
	#base_hi_point{sub_type = 41,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(41,610,32) ->
	#base_hi_point{sub_type = 41,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(41,610,37) ->
	#base_hi_point{sub_type = 41,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(42,0,0) ->
	#base_hi_point{sub_type = 42,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(42,102,0) ->
	#base_hi_point{sub_type = 42,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(42,158,0) ->
	#base_hi_point{sub_type = 42,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(42,159,0) ->
	#base_hi_point{sub_type = 42,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(42,280,0) ->
	#base_hi_point{sub_type = 42,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(42,415,0) ->
	#base_hi_point{sub_type = 42,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(42,416,1) ->
	#base_hi_point{sub_type = 42,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(42,416,4) ->
	#base_hi_point{sub_type = 42,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(42,460,1) ->
	#base_hi_point{sub_type = 42,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(42,460,1004) ->
	#base_hi_point{sub_type = 42,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(42,460,1020) ->
	#base_hi_point{sub_type = 42,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(42,610,2) ->
	#base_hi_point{sub_type = 42,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(42,610,5) ->
	#base_hi_point{sub_type = 42,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(42,610,10) ->
	#base_hi_point{sub_type = 42,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(42,610,18) ->
	#base_hi_point{sub_type = 42,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(42,610,20) ->
	#base_hi_point{sub_type = 42,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(42,610,32) ->
	#base_hi_point{sub_type = 42,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(42,610,37) ->
	#base_hi_point{sub_type = 42,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,0,0) ->
	#base_hi_point{sub_type = 43,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(43,102,0) ->
	#base_hi_point{sub_type = 43,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,158,0) ->
	#base_hi_point{sub_type = 43,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(43,159,0) ->
	#base_hi_point{sub_type = 43,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(43,280,0) ->
	#base_hi_point{sub_type = 43,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,415,0) ->
	#base_hi_point{sub_type = 43,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(43,416,1) ->
	#base_hi_point{sub_type = 43,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(43,416,4) ->
	#base_hi_point{sub_type = 43,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(43,460,1) ->
	#base_hi_point{sub_type = 43,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,460,1004) ->
	#base_hi_point{sub_type = 43,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,460,1020) ->
	#base_hi_point{sub_type = 43,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,610,2) ->
	#base_hi_point{sub_type = 43,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,610,5) ->
	#base_hi_point{sub_type = 43,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,610,10) ->
	#base_hi_point{sub_type = 43,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,610,18) ->
	#base_hi_point{sub_type = 43,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,610,20) ->
	#base_hi_point{sub_type = 43,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,610,32) ->
	#base_hi_point{sub_type = 43,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(43,610,37) ->
	#base_hi_point{sub_type = 43,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,0,0) ->
	#base_hi_point{sub_type = 44,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(44,102,0) ->
	#base_hi_point{sub_type = 44,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,158,0) ->
	#base_hi_point{sub_type = 44,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(44,159,0) ->
	#base_hi_point{sub_type = 44,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(44,280,0) ->
	#base_hi_point{sub_type = 44,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,415,0) ->
	#base_hi_point{sub_type = 44,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(44,416,1) ->
	#base_hi_point{sub_type = 44,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(44,416,4) ->
	#base_hi_point{sub_type = 44,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(44,460,1) ->
	#base_hi_point{sub_type = 44,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,460,1004) ->
	#base_hi_point{sub_type = 44,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,460,1020) ->
	#base_hi_point{sub_type = 44,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,610,2) ->
	#base_hi_point{sub_type = 44,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,610,5) ->
	#base_hi_point{sub_type = 44,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,610,10) ->
	#base_hi_point{sub_type = 44,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,610,18) ->
	#base_hi_point{sub_type = 44,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,610,20) ->
	#base_hi_point{sub_type = 44,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,610,32) ->
	#base_hi_point{sub_type = 44,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(44,610,37) ->
	#base_hi_point{sub_type = 44,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,0,0) ->
	#base_hi_point{sub_type = 45,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(45,102,0) ->
	#base_hi_point{sub_type = 45,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,158,0) ->
	#base_hi_point{sub_type = 45,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(45,159,0) ->
	#base_hi_point{sub_type = 45,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(45,280,0) ->
	#base_hi_point{sub_type = 45,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,415,0) ->
	#base_hi_point{sub_type = 45,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(45,416,1) ->
	#base_hi_point{sub_type = 45,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(45,416,4) ->
	#base_hi_point{sub_type = 45,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(45,460,1) ->
	#base_hi_point{sub_type = 45,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,460,1004) ->
	#base_hi_point{sub_type = 45,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,460,1020) ->
	#base_hi_point{sub_type = 45,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,610,2) ->
	#base_hi_point{sub_type = 45,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,610,5) ->
	#base_hi_point{sub_type = 45,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,610,10) ->
	#base_hi_point{sub_type = 45,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,610,18) ->
	#base_hi_point{sub_type = 45,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,610,20) ->
	#base_hi_point{sub_type = 45,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,610,32) ->
	#base_hi_point{sub_type = 45,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(45,610,37) ->
	#base_hi_point{sub_type = 45,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,0,0) ->
	#base_hi_point{sub_type = 46,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(46,102,0) ->
	#base_hi_point{sub_type = 46,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,158,0) ->
	#base_hi_point{sub_type = 46,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(46,159,0) ->
	#base_hi_point{sub_type = 46,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(46,280,0) ->
	#base_hi_point{sub_type = 46,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,415,0) ->
	#base_hi_point{sub_type = 46,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(46,416,1) ->
	#base_hi_point{sub_type = 46,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(46,416,4) ->
	#base_hi_point{sub_type = 46,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(46,460,1) ->
	#base_hi_point{sub_type = 46,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,460,1004) ->
	#base_hi_point{sub_type = 46,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,460,1020) ->
	#base_hi_point{sub_type = 46,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,610,2) ->
	#base_hi_point{sub_type = 46,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,610,5) ->
	#base_hi_point{sub_type = 46,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,610,10) ->
	#base_hi_point{sub_type = 46,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,610,18) ->
	#base_hi_point{sub_type = 46,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,610,20) ->
	#base_hi_point{sub_type = 46,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,610,32) ->
	#base_hi_point{sub_type = 46,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(46,610,37) ->
	#base_hi_point{sub_type = 46,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,0,0) ->
	#base_hi_point{sub_type = 47,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(47,102,0) ->
	#base_hi_point{sub_type = 47,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,158,0) ->
	#base_hi_point{sub_type = 47,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(47,159,0) ->
	#base_hi_point{sub_type = 47,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(47,280,0) ->
	#base_hi_point{sub_type = 47,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,415,0) ->
	#base_hi_point{sub_type = 47,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(47,416,1) ->
	#base_hi_point{sub_type = 47,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(47,416,4) ->
	#base_hi_point{sub_type = 47,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(47,460,1) ->
	#base_hi_point{sub_type = 47,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,460,1004) ->
	#base_hi_point{sub_type = 47,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,460,1020) ->
	#base_hi_point{sub_type = 47,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,610,2) ->
	#base_hi_point{sub_type = 47,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,610,5) ->
	#base_hi_point{sub_type = 47,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,610,10) ->
	#base_hi_point{sub_type = 47,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,610,18) ->
	#base_hi_point{sub_type = 47,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,610,20) ->
	#base_hi_point{sub_type = 47,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,610,32) ->
	#base_hi_point{sub_type = 47,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(47,610,37) ->
	#base_hi_point{sub_type = 47,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,0,0) ->
	#base_hi_point{sub_type = 48,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(48,102,0) ->
	#base_hi_point{sub_type = 48,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,158,0) ->
	#base_hi_point{sub_type = 48,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(48,159,0) ->
	#base_hi_point{sub_type = 48,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(48,280,0) ->
	#base_hi_point{sub_type = 48,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,415,0) ->
	#base_hi_point{sub_type = 48,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(48,416,1) ->
	#base_hi_point{sub_type = 48,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(48,416,4) ->
	#base_hi_point{sub_type = 48,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(48,460,1) ->
	#base_hi_point{sub_type = 48,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,460,1004) ->
	#base_hi_point{sub_type = 48,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,460,1020) ->
	#base_hi_point{sub_type = 48,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,610,2) ->
	#base_hi_point{sub_type = 48,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,610,5) ->
	#base_hi_point{sub_type = 48,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,610,10) ->
	#base_hi_point{sub_type = 48,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,610,18) ->
	#base_hi_point{sub_type = 48,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,610,20) ->
	#base_hi_point{sub_type = 48,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,610,32) ->
	#base_hi_point{sub_type = 48,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(48,610,37) ->
	#base_hi_point{sub_type = 48,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,0,0) ->
	#base_hi_point{sub_type = 49,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(49,102,0) ->
	#base_hi_point{sub_type = 49,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,158,0) ->
	#base_hi_point{sub_type = 49,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(49,159,0) ->
	#base_hi_point{sub_type = 49,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(49,280,0) ->
	#base_hi_point{sub_type = 49,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,415,0) ->
	#base_hi_point{sub_type = 49,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(49,416,1) ->
	#base_hi_point{sub_type = 49,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(49,416,4) ->
	#base_hi_point{sub_type = 49,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(49,460,1) ->
	#base_hi_point{sub_type = 49,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,460,1004) ->
	#base_hi_point{sub_type = 49,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,460,1020) ->
	#base_hi_point{sub_type = 49,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,610,2) ->
	#base_hi_point{sub_type = 49,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,610,5) ->
	#base_hi_point{sub_type = 49,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,610,10) ->
	#base_hi_point{sub_type = 49,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,610,18) ->
	#base_hi_point{sub_type = 49,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,610,20) ->
	#base_hi_point{sub_type = 49,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,610,32) ->
	#base_hi_point{sub_type = 49,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(49,610,37) ->
	#base_hi_point{sub_type = 49,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,0,0) ->
	#base_hi_point{sub_type = 50,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(50,102,0) ->
	#base_hi_point{sub_type = 50,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,158,0) ->
	#base_hi_point{sub_type = 50,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(50,159,0) ->
	#base_hi_point{sub_type = 50,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(50,280,0) ->
	#base_hi_point{sub_type = 50,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,415,0) ->
	#base_hi_point{sub_type = 50,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(50,416,1) ->
	#base_hi_point{sub_type = 50,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(50,416,4) ->
	#base_hi_point{sub_type = 50,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(50,460,1) ->
	#base_hi_point{sub_type = 50,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,460,1004) ->
	#base_hi_point{sub_type = 50,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,460,1020) ->
	#base_hi_point{sub_type = 50,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,610,2) ->
	#base_hi_point{sub_type = 50,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,610,5) ->
	#base_hi_point{sub_type = 50,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,610,10) ->
	#base_hi_point{sub_type = 50,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,610,18) ->
	#base_hi_point{sub_type = 50,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,610,20) ->
	#base_hi_point{sub_type = 50,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,610,32) ->
	#base_hi_point{sub_type = 50,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(50,610,37) ->
	#base_hi_point{sub_type = 50,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,0,0) ->
	#base_hi_point{sub_type = 51,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(51,102,0) ->
	#base_hi_point{sub_type = 51,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,158,0) ->
	#base_hi_point{sub_type = 51,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(51,159,0) ->
	#base_hi_point{sub_type = 51,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(51,280,0) ->
	#base_hi_point{sub_type = 51,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,415,0) ->
	#base_hi_point{sub_type = 51,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(51,416,1) ->
	#base_hi_point{sub_type = 51,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(51,416,4) ->
	#base_hi_point{sub_type = 51,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(51,460,1) ->
	#base_hi_point{sub_type = 51,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,460,1004) ->
	#base_hi_point{sub_type = 51,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,460,1020) ->
	#base_hi_point{sub_type = 51,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,610,2) ->
	#base_hi_point{sub_type = 51,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,610,5) ->
	#base_hi_point{sub_type = 51,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,610,10) ->
	#base_hi_point{sub_type = 51,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,610,18) ->
	#base_hi_point{sub_type = 51,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,610,20) ->
	#base_hi_point{sub_type = 51,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,610,32) ->
	#base_hi_point{sub_type = 51,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(51,610,37) ->
	#base_hi_point{sub_type = 51,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,0,0) ->
	#base_hi_point{sub_type = 52,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(52,102,0) ->
	#base_hi_point{sub_type = 52,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,158,0) ->
	#base_hi_point{sub_type = 52,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(52,159,0) ->
	#base_hi_point{sub_type = 52,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(52,280,0) ->
	#base_hi_point{sub_type = 52,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,415,0) ->
	#base_hi_point{sub_type = 52,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(52,416,1) ->
	#base_hi_point{sub_type = 52,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(52,416,4) ->
	#base_hi_point{sub_type = 52,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(52,460,1) ->
	#base_hi_point{sub_type = 52,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,460,1004) ->
	#base_hi_point{sub_type = 52,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,460,1020) ->
	#base_hi_point{sub_type = 52,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,610,2) ->
	#base_hi_point{sub_type = 52,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,610,5) ->
	#base_hi_point{sub_type = 52,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,610,10) ->
	#base_hi_point{sub_type = 52,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,610,18) ->
	#base_hi_point{sub_type = 52,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,610,20) ->
	#base_hi_point{sub_type = 52,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,610,32) ->
	#base_hi_point{sub_type = 52,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(52,610,37) ->
	#base_hi_point{sub_type = 52,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,0,0) ->
	#base_hi_point{sub_type = 53,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(53,102,0) ->
	#base_hi_point{sub_type = 53,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,158,0) ->
	#base_hi_point{sub_type = 53,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(53,159,0) ->
	#base_hi_point{sub_type = 53,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(53,280,0) ->
	#base_hi_point{sub_type = 53,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,415,0) ->
	#base_hi_point{sub_type = 53,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(53,416,1) ->
	#base_hi_point{sub_type = 53,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(53,416,4) ->
	#base_hi_point{sub_type = 53,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(53,460,1) ->
	#base_hi_point{sub_type = 53,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,460,1004) ->
	#base_hi_point{sub_type = 53,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,460,1020) ->
	#base_hi_point{sub_type = 53,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,610,2) ->
	#base_hi_point{sub_type = 53,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,610,5) ->
	#base_hi_point{sub_type = 53,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,610,10) ->
	#base_hi_point{sub_type = 53,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,610,18) ->
	#base_hi_point{sub_type = 53,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,610,20) ->
	#base_hi_point{sub_type = 53,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,610,32) ->
	#base_hi_point{sub_type = 53,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(53,610,37) ->
	#base_hi_point{sub_type = 53,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,0,0) ->
	#base_hi_point{sub_type = 54,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(54,102,0) ->
	#base_hi_point{sub_type = 54,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,158,0) ->
	#base_hi_point{sub_type = 54,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(54,159,0) ->
	#base_hi_point{sub_type = 54,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(54,280,0) ->
	#base_hi_point{sub_type = 54,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,415,0) ->
	#base_hi_point{sub_type = 54,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(54,416,1) ->
	#base_hi_point{sub_type = 54,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(54,416,4) ->
	#base_hi_point{sub_type = 54,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(54,460,1) ->
	#base_hi_point{sub_type = 54,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,460,1004) ->
	#base_hi_point{sub_type = 54,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,460,1020) ->
	#base_hi_point{sub_type = 54,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,610,2) ->
	#base_hi_point{sub_type = 54,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,610,5) ->
	#base_hi_point{sub_type = 54,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,610,10) ->
	#base_hi_point{sub_type = 54,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,610,18) ->
	#base_hi_point{sub_type = 54,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,610,20) ->
	#base_hi_point{sub_type = 54,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,610,32) ->
	#base_hi_point{sub_type = 54,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(54,610,37) ->
	#base_hi_point{sub_type = 54,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,0,0) ->
	#base_hi_point{sub_type = 55,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(55,102,0) ->
	#base_hi_point{sub_type = 55,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,158,0) ->
	#base_hi_point{sub_type = 55,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(55,159,0) ->
	#base_hi_point{sub_type = 55,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(55,280,0) ->
	#base_hi_point{sub_type = 55,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,415,0) ->
	#base_hi_point{sub_type = 55,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(55,416,1) ->
	#base_hi_point{sub_type = 55,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(55,416,4) ->
	#base_hi_point{sub_type = 55,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(55,460,1) ->
	#base_hi_point{sub_type = 55,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,460,1004) ->
	#base_hi_point{sub_type = 55,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,460,1020) ->
	#base_hi_point{sub_type = 55,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,610,2) ->
	#base_hi_point{sub_type = 55,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,610,5) ->
	#base_hi_point{sub_type = 55,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,610,10) ->
	#base_hi_point{sub_type = 55,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,610,18) ->
	#base_hi_point{sub_type = 55,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,610,20) ->
	#base_hi_point{sub_type = 55,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,610,32) ->
	#base_hi_point{sub_type = 55,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(55,610,37) ->
	#base_hi_point{sub_type = 55,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,0,0) ->
	#base_hi_point{sub_type = 56,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(56,102,0) ->
	#base_hi_point{sub_type = 56,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,158,0) ->
	#base_hi_point{sub_type = 56,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(56,159,0) ->
	#base_hi_point{sub_type = 56,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(56,280,0) ->
	#base_hi_point{sub_type = 56,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,415,0) ->
	#base_hi_point{sub_type = 56,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(56,416,1) ->
	#base_hi_point{sub_type = 56,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(56,416,4) ->
	#base_hi_point{sub_type = 56,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(56,460,1) ->
	#base_hi_point{sub_type = 56,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,460,1004) ->
	#base_hi_point{sub_type = 56,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,460,1020) ->
	#base_hi_point{sub_type = 56,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,610,2) ->
	#base_hi_point{sub_type = 56,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,610,5) ->
	#base_hi_point{sub_type = 56,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,610,10) ->
	#base_hi_point{sub_type = 56,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,610,18) ->
	#base_hi_point{sub_type = 56,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,610,20) ->
	#base_hi_point{sub_type = 56,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,610,32) ->
	#base_hi_point{sub_type = 56,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(56,610,37) ->
	#base_hi_point{sub_type = 56,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,0,0) ->
	#base_hi_point{sub_type = 57,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(57,102,0) ->
	#base_hi_point{sub_type = 57,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,158,0) ->
	#base_hi_point{sub_type = 57,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(57,159,0) ->
	#base_hi_point{sub_type = 57,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(57,280,0) ->
	#base_hi_point{sub_type = 57,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,415,0) ->
	#base_hi_point{sub_type = 57,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(57,416,1) ->
	#base_hi_point{sub_type = 57,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(57,416,4) ->
	#base_hi_point{sub_type = 57,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(57,460,1) ->
	#base_hi_point{sub_type = 57,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,460,1004) ->
	#base_hi_point{sub_type = 57,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,460,1020) ->
	#base_hi_point{sub_type = 57,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,610,2) ->
	#base_hi_point{sub_type = 57,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,610,5) ->
	#base_hi_point{sub_type = 57,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,610,10) ->
	#base_hi_point{sub_type = 57,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,610,18) ->
	#base_hi_point{sub_type = 57,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,610,20) ->
	#base_hi_point{sub_type = 57,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,610,32) ->
	#base_hi_point{sub_type = 57,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(57,610,37) ->
	#base_hi_point{sub_type = 57,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(58,0,0) ->
	#base_hi_point{sub_type = 58,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(58,102,0) ->
	#base_hi_point{sub_type = 58,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(58,158,0) ->
	#base_hi_point{sub_type = 58,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(58,159,0) ->
	#base_hi_point{sub_type = 58,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(58,280,0) ->
	#base_hi_point{sub_type = 58,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(58,415,0) ->
	#base_hi_point{sub_type = 58,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(58,416,1) ->
	#base_hi_point{sub_type = 58,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(58,416,4) ->
	#base_hi_point{sub_type = 58,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(58,460,1) ->
	#base_hi_point{sub_type = 58,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(58,460,1004) ->
	#base_hi_point{sub_type = 58,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(58,460,1020) ->
	#base_hi_point{sub_type = 58,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(58,610,2) ->
	#base_hi_point{sub_type = 58,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(58,610,5) ->
	#base_hi_point{sub_type = 58,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(58,610,10) ->
	#base_hi_point{sub_type = 58,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(58,610,18) ->
	#base_hi_point{sub_type = 58,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(58,610,20) ->
	#base_hi_point{sub_type = 58,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(58,610,32) ->
	#base_hi_point{sub_type = 58,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(58,610,37) ->
	#base_hi_point{sub_type = 58,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,0,0) ->
	#base_hi_point{sub_type = 59,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(59,102,0) ->
	#base_hi_point{sub_type = 59,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,158,0) ->
	#base_hi_point{sub_type = 59,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(59,159,0) ->
	#base_hi_point{sub_type = 59,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(59,280,0) ->
	#base_hi_point{sub_type = 59,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,415,0) ->
	#base_hi_point{sub_type = 59,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(59,416,1) ->
	#base_hi_point{sub_type = 59,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(59,416,4) ->
	#base_hi_point{sub_type = 59,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(59,460,1) ->
	#base_hi_point{sub_type = 59,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,460,1004) ->
	#base_hi_point{sub_type = 59,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,460,1020) ->
	#base_hi_point{sub_type = 59,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,610,2) ->
	#base_hi_point{sub_type = 59,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,610,5) ->
	#base_hi_point{sub_type = 59,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,610,10) ->
	#base_hi_point{sub_type = 59,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,610,18) ->
	#base_hi_point{sub_type = 59,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,610,20) ->
	#base_hi_point{sub_type = 59,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,610,32) ->
	#base_hi_point{sub_type = 59,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(59,610,37) ->
	#base_hi_point{sub_type = 59,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(60,0,0) ->
	#base_hi_point{sub_type = 60,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(60,102,0) ->
	#base_hi_point{sub_type = 60,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(60,158,0) ->
	#base_hi_point{sub_type = 60,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(60,159,0) ->
	#base_hi_point{sub_type = 60,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(60,280,0) ->
	#base_hi_point{sub_type = 60,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(60,415,0) ->
	#base_hi_point{sub_type = 60,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(60,416,1) ->
	#base_hi_point{sub_type = 60,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(60,416,4) ->
	#base_hi_point{sub_type = 60,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(60,460,1) ->
	#base_hi_point{sub_type = 60,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(60,460,1004) ->
	#base_hi_point{sub_type = 60,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(60,460,1020) ->
	#base_hi_point{sub_type = 60,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(60,610,2) ->
	#base_hi_point{sub_type = 60,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(60,610,5) ->
	#base_hi_point{sub_type = 60,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(60,610,10) ->
	#base_hi_point{sub_type = 60,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(60,610,18) ->
	#base_hi_point{sub_type = 60,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(60,610,20) ->
	#base_hi_point{sub_type = 60,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(60,610,32) ->
	#base_hi_point{sub_type = 60,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(60,610,37) ->
	#base_hi_point{sub_type = 60,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,0,0) ->
	#base_hi_point{sub_type = 61,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(61,102,0) ->
	#base_hi_point{sub_type = 61,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,158,0) ->
	#base_hi_point{sub_type = 61,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(61,159,0) ->
	#base_hi_point{sub_type = 61,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(61,280,0) ->
	#base_hi_point{sub_type = 61,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,415,0) ->
	#base_hi_point{sub_type = 61,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(61,416,1) ->
	#base_hi_point{sub_type = 61,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(61,416,4) ->
	#base_hi_point{sub_type = 61,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(61,460,1) ->
	#base_hi_point{sub_type = 61,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,460,1004) ->
	#base_hi_point{sub_type = 61,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,460,1020) ->
	#base_hi_point{sub_type = 61,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,610,2) ->
	#base_hi_point{sub_type = 61,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,610,5) ->
	#base_hi_point{sub_type = 61,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,610,10) ->
	#base_hi_point{sub_type = 61,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,610,18) ->
	#base_hi_point{sub_type = 61,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,610,20) ->
	#base_hi_point{sub_type = 61,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,610,32) ->
	#base_hi_point{sub_type = 61,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(61,610,37) ->
	#base_hi_point{sub_type = 61,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,0,0) ->
	#base_hi_point{sub_type = 62,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(62,102,0) ->
	#base_hi_point{sub_type = 62,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,158,0) ->
	#base_hi_point{sub_type = 62,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(62,159,0) ->
	#base_hi_point{sub_type = 62,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(62,280,0) ->
	#base_hi_point{sub_type = 62,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,415,0) ->
	#base_hi_point{sub_type = 62,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(62,416,1) ->
	#base_hi_point{sub_type = 62,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(62,416,4) ->
	#base_hi_point{sub_type = 62,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(62,460,1) ->
	#base_hi_point{sub_type = 62,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,460,1004) ->
	#base_hi_point{sub_type = 62,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,460,1020) ->
	#base_hi_point{sub_type = 62,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,610,2) ->
	#base_hi_point{sub_type = 62,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,610,5) ->
	#base_hi_point{sub_type = 62,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,610,10) ->
	#base_hi_point{sub_type = 62,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,610,18) ->
	#base_hi_point{sub_type = 62,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,610,20) ->
	#base_hi_point{sub_type = 62,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,610,32) ->
	#base_hi_point{sub_type = 62,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(62,610,37) ->
	#base_hi_point{sub_type = 62,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,0,0) ->
	#base_hi_point{sub_type = 63,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(63,102,0) ->
	#base_hi_point{sub_type = 63,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,158,0) ->
	#base_hi_point{sub_type = 63,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(63,159,0) ->
	#base_hi_point{sub_type = 63,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(63,280,0) ->
	#base_hi_point{sub_type = 63,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,415,0) ->
	#base_hi_point{sub_type = 63,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(63,416,1) ->
	#base_hi_point{sub_type = 63,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(63,416,4) ->
	#base_hi_point{sub_type = 63,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(63,460,1) ->
	#base_hi_point{sub_type = 63,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,460,1004) ->
	#base_hi_point{sub_type = 63,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,460,1020) ->
	#base_hi_point{sub_type = 63,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,610,2) ->
	#base_hi_point{sub_type = 63,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,610,5) ->
	#base_hi_point{sub_type = 63,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,610,10) ->
	#base_hi_point{sub_type = 63,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,610,18) ->
	#base_hi_point{sub_type = 63,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,610,20) ->
	#base_hi_point{sub_type = 63,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,610,32) ->
	#base_hi_point{sub_type = 63,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(63,610,37) ->
	#base_hi_point{sub_type = 63,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,0,0) ->
	#base_hi_point{sub_type = 64,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(64,102,0) ->
	#base_hi_point{sub_type = 64,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,158,0) ->
	#base_hi_point{sub_type = 64,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(64,159,0) ->
	#base_hi_point{sub_type = 64,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(64,280,0) ->
	#base_hi_point{sub_type = 64,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,415,0) ->
	#base_hi_point{sub_type = 64,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(64,416,1) ->
	#base_hi_point{sub_type = 64,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(64,416,4) ->
	#base_hi_point{sub_type = 64,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(64,460,1) ->
	#base_hi_point{sub_type = 64,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,460,1004) ->
	#base_hi_point{sub_type = 64,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,460,1020) ->
	#base_hi_point{sub_type = 64,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,610,2) ->
	#base_hi_point{sub_type = 64,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,610,5) ->
	#base_hi_point{sub_type = 64,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,610,10) ->
	#base_hi_point{sub_type = 64,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,610,18) ->
	#base_hi_point{sub_type = 64,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,610,20) ->
	#base_hi_point{sub_type = 64,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,610,32) ->
	#base_hi_point{sub_type = 64,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(64,610,37) ->
	#base_hi_point{sub_type = 64,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(65,0,0) ->
	#base_hi_point{sub_type = 65,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(65,102,0) ->
	#base_hi_point{sub_type = 65,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(65,158,0) ->
	#base_hi_point{sub_type = 65,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(65,159,0) ->
	#base_hi_point{sub_type = 65,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(65,280,0) ->
	#base_hi_point{sub_type = 65,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(65,415,0) ->
	#base_hi_point{sub_type = 65,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(65,416,1) ->
	#base_hi_point{sub_type = 65,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(65,416,4) ->
	#base_hi_point{sub_type = 65,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(65,460,1) ->
	#base_hi_point{sub_type = 65,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(65,460,1004) ->
	#base_hi_point{sub_type = 65,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(65,460,1020) ->
	#base_hi_point{sub_type = 65,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(65,610,2) ->
	#base_hi_point{sub_type = 65,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(65,610,5) ->
	#base_hi_point{sub_type = 65,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(65,610,10) ->
	#base_hi_point{sub_type = 65,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(65,610,18) ->
	#base_hi_point{sub_type = 65,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(65,610,20) ->
	#base_hi_point{sub_type = 65,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(65,610,32) ->
	#base_hi_point{sub_type = 65,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(65,610,37) ->
	#base_hi_point{sub_type = 65,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,0,0) ->
	#base_hi_point{sub_type = 66,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(66,102,0) ->
	#base_hi_point{sub_type = 66,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,158,0) ->
	#base_hi_point{sub_type = 66,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(66,159,0) ->
	#base_hi_point{sub_type = 66,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(66,280,0) ->
	#base_hi_point{sub_type = 66,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,415,0) ->
	#base_hi_point{sub_type = 66,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(66,416,1) ->
	#base_hi_point{sub_type = 66,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(66,416,4) ->
	#base_hi_point{sub_type = 66,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(66,460,1) ->
	#base_hi_point{sub_type = 66,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,460,1004) ->
	#base_hi_point{sub_type = 66,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,460,1020) ->
	#base_hi_point{sub_type = 66,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,610,2) ->
	#base_hi_point{sub_type = 66,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,610,5) ->
	#base_hi_point{sub_type = 66,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,610,10) ->
	#base_hi_point{sub_type = 66,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,610,18) ->
	#base_hi_point{sub_type = 66,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,610,20) ->
	#base_hi_point{sub_type = 66,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,610,32) ->
	#base_hi_point{sub_type = 66,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(66,610,37) ->
	#base_hi_point{sub_type = 66,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,0,0) ->
	#base_hi_point{sub_type = 67,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(67,102,0) ->
	#base_hi_point{sub_type = 67,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,158,0) ->
	#base_hi_point{sub_type = 67,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(67,159,0) ->
	#base_hi_point{sub_type = 67,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(67,280,0) ->
	#base_hi_point{sub_type = 67,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,415,0) ->
	#base_hi_point{sub_type = 67,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(67,416,1) ->
	#base_hi_point{sub_type = 67,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(67,416,4) ->
	#base_hi_point{sub_type = 67,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(67,460,1) ->
	#base_hi_point{sub_type = 67,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,460,1004) ->
	#base_hi_point{sub_type = 67,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,460,1020) ->
	#base_hi_point{sub_type = 67,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,610,2) ->
	#base_hi_point{sub_type = 67,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,610,5) ->
	#base_hi_point{sub_type = 67,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,610,10) ->
	#base_hi_point{sub_type = 67,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,610,18) ->
	#base_hi_point{sub_type = 67,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,610,20) ->
	#base_hi_point{sub_type = 67,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,610,32) ->
	#base_hi_point{sub_type = 67,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(67,610,37) ->
	#base_hi_point{sub_type = 67,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,0,0) ->
	#base_hi_point{sub_type = 68,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(68,102,0) ->
	#base_hi_point{sub_type = 68,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,158,0) ->
	#base_hi_point{sub_type = 68,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(68,159,0) ->
	#base_hi_point{sub_type = 68,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(68,280,0) ->
	#base_hi_point{sub_type = 68,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,415,0) ->
	#base_hi_point{sub_type = 68,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(68,416,1) ->
	#base_hi_point{sub_type = 68,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(68,416,4) ->
	#base_hi_point{sub_type = 68,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(68,460,1) ->
	#base_hi_point{sub_type = 68,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,460,1004) ->
	#base_hi_point{sub_type = 68,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,460,1020) ->
	#base_hi_point{sub_type = 68,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,610,2) ->
	#base_hi_point{sub_type = 68,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,610,5) ->
	#base_hi_point{sub_type = 68,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,610,10) ->
	#base_hi_point{sub_type = 68,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,610,18) ->
	#base_hi_point{sub_type = 68,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,610,20) ->
	#base_hi_point{sub_type = 68,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,610,32) ->
	#base_hi_point{sub_type = 68,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(68,610,37) ->
	#base_hi_point{sub_type = 68,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,0,0) ->
	#base_hi_point{sub_type = 69,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(69,102,0) ->
	#base_hi_point{sub_type = 69,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,158,0) ->
	#base_hi_point{sub_type = 69,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(69,159,0) ->
	#base_hi_point{sub_type = 69,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(69,280,0) ->
	#base_hi_point{sub_type = 69,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,415,0) ->
	#base_hi_point{sub_type = 69,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(69,416,1) ->
	#base_hi_point{sub_type = 69,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(69,416,4) ->
	#base_hi_point{sub_type = 69,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(69,460,1) ->
	#base_hi_point{sub_type = 69,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,460,1004) ->
	#base_hi_point{sub_type = 69,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,460,1020) ->
	#base_hi_point{sub_type = 69,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,610,2) ->
	#base_hi_point{sub_type = 69,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,610,5) ->
	#base_hi_point{sub_type = 69,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,610,10) ->
	#base_hi_point{sub_type = 69,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,610,18) ->
	#base_hi_point{sub_type = 69,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,610,20) ->
	#base_hi_point{sub_type = 69,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,610,32) ->
	#base_hi_point{sub_type = 69,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(69,610,37) ->
	#base_hi_point{sub_type = 69,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(70,0,0) ->
	#base_hi_point{sub_type = 70,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(70,102,0) ->
	#base_hi_point{sub_type = 70,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(70,158,0) ->
	#base_hi_point{sub_type = 70,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(70,159,0) ->
	#base_hi_point{sub_type = 70,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(70,280,0) ->
	#base_hi_point{sub_type = 70,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(70,415,0) ->
	#base_hi_point{sub_type = 70,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(70,416,1) ->
	#base_hi_point{sub_type = 70,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(70,416,4) ->
	#base_hi_point{sub_type = 70,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(70,460,1) ->
	#base_hi_point{sub_type = 70,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(70,460,1004) ->
	#base_hi_point{sub_type = 70,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(70,460,1020) ->
	#base_hi_point{sub_type = 70,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(70,610,2) ->
	#base_hi_point{sub_type = 70,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(70,610,5) ->
	#base_hi_point{sub_type = 70,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(70,610,10) ->
	#base_hi_point{sub_type = 70,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(70,610,18) ->
	#base_hi_point{sub_type = 70,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(70,610,20) ->
	#base_hi_point{sub_type = 70,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(70,610,32) ->
	#base_hi_point{sub_type = 70,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(70,610,37) ->
	#base_hi_point{sub_type = 70,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(71,0,0) ->
	#base_hi_point{sub_type = 71,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(71,102,0) ->
	#base_hi_point{sub_type = 71,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(71,158,0) ->
	#base_hi_point{sub_type = 71,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(71,159,0) ->
	#base_hi_point{sub_type = 71,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(71,280,0) ->
	#base_hi_point{sub_type = 71,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(71,415,0) ->
	#base_hi_point{sub_type = 71,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(71,416,1) ->
	#base_hi_point{sub_type = 71,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(71,416,4) ->
	#base_hi_point{sub_type = 71,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(71,460,1) ->
	#base_hi_point{sub_type = 71,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(71,460,1004) ->
	#base_hi_point{sub_type = 71,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(71,460,1020) ->
	#base_hi_point{sub_type = 71,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(71,610,2) ->
	#base_hi_point{sub_type = 71,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(71,610,5) ->
	#base_hi_point{sub_type = 71,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(71,610,10) ->
	#base_hi_point{sub_type = 71,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(71,610,18) ->
	#base_hi_point{sub_type = 71,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(71,610,20) ->
	#base_hi_point{sub_type = 71,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(71,610,32) ->
	#base_hi_point{sub_type = 71,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(71,610,37) ->
	#base_hi_point{sub_type = 71,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(72,0,0) ->
	#base_hi_point{sub_type = 72,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(72,102,0) ->
	#base_hi_point{sub_type = 72,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(72,158,0) ->
	#base_hi_point{sub_type = 72,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(72,159,0) ->
	#base_hi_point{sub_type = 72,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(72,280,0) ->
	#base_hi_point{sub_type = 72,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(72,415,0) ->
	#base_hi_point{sub_type = 72,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(72,416,1) ->
	#base_hi_point{sub_type = 72,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(72,416,4) ->
	#base_hi_point{sub_type = 72,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(72,460,1) ->
	#base_hi_point{sub_type = 72,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(72,460,1004) ->
	#base_hi_point{sub_type = 72,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(72,460,1020) ->
	#base_hi_point{sub_type = 72,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(72,610,2) ->
	#base_hi_point{sub_type = 72,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(72,610,5) ->
	#base_hi_point{sub_type = 72,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(72,610,10) ->
	#base_hi_point{sub_type = 72,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(72,610,18) ->
	#base_hi_point{sub_type = 72,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(72,610,20) ->
	#base_hi_point{sub_type = 72,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(72,610,32) ->
	#base_hi_point{sub_type = 72,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(72,610,37) ->
	#base_hi_point{sub_type = 72,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(73,0,0) ->
	#base_hi_point{sub_type = 73,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(73,102,0) ->
	#base_hi_point{sub_type = 73,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(73,158,0) ->
	#base_hi_point{sub_type = 73,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(73,159,0) ->
	#base_hi_point{sub_type = 73,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(73,280,0) ->
	#base_hi_point{sub_type = 73,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(73,415,0) ->
	#base_hi_point{sub_type = 73,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(73,416,1) ->
	#base_hi_point{sub_type = 73,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(73,416,4) ->
	#base_hi_point{sub_type = 73,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(73,460,1) ->
	#base_hi_point{sub_type = 73,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(73,460,1004) ->
	#base_hi_point{sub_type = 73,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(73,460,1020) ->
	#base_hi_point{sub_type = 73,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(73,610,2) ->
	#base_hi_point{sub_type = 73,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(73,610,5) ->
	#base_hi_point{sub_type = 73,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(73,610,10) ->
	#base_hi_point{sub_type = 73,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(73,610,18) ->
	#base_hi_point{sub_type = 73,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(73,610,20) ->
	#base_hi_point{sub_type = 73,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(73,610,32) ->
	#base_hi_point{sub_type = 73,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(73,610,37) ->
	#base_hi_point{sub_type = 73,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(74,0,0) ->
	#base_hi_point{sub_type = 74,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(74,102,0) ->
	#base_hi_point{sub_type = 74,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(74,158,0) ->
	#base_hi_point{sub_type = 74,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(74,159,0) ->
	#base_hi_point{sub_type = 74,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(74,280,0) ->
	#base_hi_point{sub_type = 74,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(74,415,0) ->
	#base_hi_point{sub_type = 74,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(74,416,1) ->
	#base_hi_point{sub_type = 74,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(74,416,4) ->
	#base_hi_point{sub_type = 74,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(74,460,1) ->
	#base_hi_point{sub_type = 74,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(74,460,1004) ->
	#base_hi_point{sub_type = 74,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(74,460,1020) ->
	#base_hi_point{sub_type = 74,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(74,610,2) ->
	#base_hi_point{sub_type = 74,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(74,610,5) ->
	#base_hi_point{sub_type = 74,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(74,610,10) ->
	#base_hi_point{sub_type = 74,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(74,610,18) ->
	#base_hi_point{sub_type = 74,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(74,610,20) ->
	#base_hi_point{sub_type = 74,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(74,610,32) ->
	#base_hi_point{sub_type = 74,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(74,610,37) ->
	#base_hi_point{sub_type = 74,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,0,0) ->
	#base_hi_point{sub_type = 75,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(75,102,0) ->
	#base_hi_point{sub_type = 75,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,158,0) ->
	#base_hi_point{sub_type = 75,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(75,159,0) ->
	#base_hi_point{sub_type = 75,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(75,280,0) ->
	#base_hi_point{sub_type = 75,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,415,0) ->
	#base_hi_point{sub_type = 75,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(75,416,1) ->
	#base_hi_point{sub_type = 75,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(75,416,4) ->
	#base_hi_point{sub_type = 75,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(75,460,1) ->
	#base_hi_point{sub_type = 75,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,460,1004) ->
	#base_hi_point{sub_type = 75,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,460,1020) ->
	#base_hi_point{sub_type = 75,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,610,2) ->
	#base_hi_point{sub_type = 75,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,610,5) ->
	#base_hi_point{sub_type = 75,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,610,10) ->
	#base_hi_point{sub_type = 75,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,610,18) ->
	#base_hi_point{sub_type = 75,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,610,20) ->
	#base_hi_point{sub_type = 75,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,610,32) ->
	#base_hi_point{sub_type = 75,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(75,610,37) ->
	#base_hi_point{sub_type = 75,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(76,0,0) ->
	#base_hi_point{sub_type = 76,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 1};

get_hi_point_cfg(76,102,0) ->
	#base_hi_point{sub_type = 76,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(76,158,0) ->
	#base_hi_point{sub_type = 76,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 1};

get_hi_point_cfg(76,159,0) ->
	#base_hi_point{sub_type = 76,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 1};

get_hi_point_cfg(76,280,0) ->
	#base_hi_point{sub_type = 76,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(76,415,0) ->
	#base_hi_point{sub_type = 76,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 1};

get_hi_point_cfg(76,416,1) ->
	#base_hi_point{sub_type = 76,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 1};

get_hi_point_cfg(76,416,4) ->
	#base_hi_point{sub_type = 76,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 1};

get_hi_point_cfg(76,460,1) ->
	#base_hi_point{sub_type = 76,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(76,460,1004) ->
	#base_hi_point{sub_type = 76,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(76,460,1020) ->
	#base_hi_point{sub_type = 76,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(76,610,2) ->
	#base_hi_point{sub_type = 76,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(76,610,5) ->
	#base_hi_point{sub_type = 76,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(76,610,10) ->
	#base_hi_point{sub_type = 76,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(76,610,18) ->
	#base_hi_point{sub_type = 76,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(76,610,20) ->
	#base_hi_point{sub_type = 76,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(76,610,32) ->
	#base_hi_point{sub_type = 76,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(76,610,37) ->
	#base_hi_point{sub_type = 76,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 1};

get_hi_point_cfg(77,0,0) ->
	#base_hi_point{sub_type = 77,mod_id = 0,sub_id = 0,name = "嗨点之灵",is_single = 0,one_points = 1,max_points = 9999999,min_lv = 1,max_lv = 9999,order_id = 14,jump_id = 82,icon_type = "61201",reward_condition = [],is_process = 0,show_id = 2};

get_hi_point_cfg(77,102,0) ->
	#base_hi_point{sub_type = 77,mod_id = 102,sub_id = 0,name = "每天登录",is_single = 1,one_points = 5,max_points = 10,min_lv = 120,max_lv = 9999,order_id = 1,jump_id = 0,icon_type = "3",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(77,158,0) ->
	#base_hi_point{sub_type = 77,mod_id = 158,sub_id = 0,name = "累计充值勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 17,jump_id = 21,icon_type = "5",reward_condition = [{recharge,60,40,1058},{recharge,300,50,1059},{recharge,980,55,1060},{recharge,1280,60,1061},{recharge,3280,65,1062},{recharge,6480,80,1063}],is_process = 1,show_id = 2};

get_hi_point_cfg(77,159,0) ->
	#base_hi_point{sub_type = 77,mod_id = 159,sub_id = 0,name = "累计消费勾玉",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 16,jump_id = 60,icon_type = "2",reward_condition = [{cost,60,20,1064},{cost,300,30,1065},{cost,980,35,1066},{cost,1280,40,1067},{cost,3280,60,1068},{cost,6480,80,1069}],is_process = 1,show_id = 2};

get_hi_point_cfg(77,280,0) ->
	#base_hi_point{sub_type = 77,mod_id = 280,sub_id = 0,name = "完成竞技场1次",is_single = 1,one_points = 1,max_points = 40,min_lv = 120,max_lv = 9999,order_id = 2,jump_id = 48,icon_type = "7",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(77,415,0) ->
	#base_hi_point{sub_type = 77,mod_id = 415,sub_id = 0,name = "祈愿",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 15,jump_id = 55,icon_type = "4",reward_condition = [{count,1,10,1076},{count,10,20,1077},{count,50,50,1078}],is_process = 1,show_id = 2};

get_hi_point_cfg(77,416,1) ->
	#base_hi_point{sub_type = 77,mod_id = 416,sub_id = 1,name = "装备寻宝",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 13,jump_id = 192,icon_type = "9",reward_condition = [{count,10,20,1070},{count,30,30,1071},{count,50,50,1072}],is_process = 1,show_id = 2};

get_hi_point_cfg(77,416,4) ->
	#base_hi_point{sub_type = 77,mod_id = 416,sub_id = 4,name = "御魂召唤",is_single = 0,one_points = 5,max_points = 5,min_lv = 120,max_lv = 9999,order_id = 14,jump_id = 65,icon_type = "9",reward_condition = [{count,10,20,1073},{count,30,30,1074},{count,50,50,1075}],is_process = 1,show_id = 2};

get_hi_point_cfg(77,460,1) ->
	#base_hi_point{sub_type = 77,mod_id = 460,sub_id = 1,name = "击杀蜃气楼大妖1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 320,max_lv = 9999,order_id = 11,jump_id = 86,icon_type = "8",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(77,460,1004) ->
	#base_hi_point{sub_type = 77,mod_id = 460,sub_id = 1004,name = "进入蛮荒大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 240,max_lv = 9999,order_id = 10,jump_id = 36,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(77,460,1020) ->
	#base_hi_point{sub_type = 77,mod_id = 460,sub_id = 1020,name = "进入秘境大妖1次",is_single = 1,one_points = 10,max_points = 100,min_lv = 400,max_lv = 9999,order_id = 12,jump_id = 135,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(77,610,2) ->
	#base_hi_point{sub_type = 77,mod_id = 610,sub_id = 2,name = "通关财源滚滚1次",is_single = 1,one_points = 10,max_points = 80,min_lv = 120,max_lv = 9999,order_id = 5,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(77,610,5) ->
	#base_hi_point{sub_type = 77,mod_id = 610,sub_id = 5,name = "通关寻装觅刃1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 3,jump_id = 119,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(77,610,10) ->
	#base_hi_point{sub_type = 77,mod_id = 610,sub_id = 10,name = "击杀专属大妖1次",is_single = 1,one_points = 20,max_points = 120,min_lv = 120,max_lv = 9999,order_id = 9,jump_id = 5,icon_type = "1",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(77,610,18) ->
	#base_hi_point{sub_type = 77,mod_id = 610,sub_id = 18,name = "通关万物有灵1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 6,jump_id = 53,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(77,610,20) ->
	#base_hi_point{sub_type = 77,mod_id = 610,sub_id = 20,name = "通关恶灵退治1次",is_single = 1,one_points = 10,max_points = 60,min_lv = 120,max_lv = 9999,order_id = 8,jump_id = 7,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(77,610,32) ->
	#base_hi_point{sub_type = 77,mod_id = 610,sub_id = 32,name = "进入神纹烙印1次",is_single = 1,one_points = 20,max_points = 80,min_lv = 290,max_lv = 9999,order_id = 4,jump_id = 120,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(77,610,37) ->
	#base_hi_point{sub_type = 77,mod_id = 610,sub_id = 37,name = "扫荡神巫副本1次",is_single = 1,one_points = 15,max_points = 90,min_lv = 120,max_lv = 9999,order_id = 7,jump_id = 190,icon_type = "6",reward_condition = [],is_process = 1,show_id = 2};

get_hi_point_cfg(_Subtype,_Modid,_Subid) ->
	[].

get_keys() ->
[{0,0,0},{0,158,0},{0,159,0},{0,160,1},{0,160,2},{0,170,0},{0,181,0},{0,182,0},{0,416,1},{0,460,4},{0,460,7},{0,610,8},{0,610,32},{0,612,0},{2,0,0},{2,102,0},{2,158,0},{2,159,0},{2,280,0},{2,415,0},{2,416,1},{2,416,4},{2,460,1},{2,460,1004},{2,460,1020},{2,610,2},{2,610,5},{2,610,10},{2,610,18},{2,610,20},{2,610,32},{2,610,37},{3,0,0},{3,102,0},{3,158,0},{3,159,0},{3,280,0},{3,415,0},{3,416,1},{3,416,4},{3,460,1},{3,460,1004},{3,460,1020},{3,610,2},{3,610,5},{3,610,10},{3,610,18},{3,610,20},{3,610,32},{3,610,37},{4,0,0},{4,102,0},{4,158,0},{4,159,0},{4,280,0},{4,415,0},{4,416,1},{4,416,4},{4,460,1},{4,460,1004},{4,460,1020},{4,610,2},{4,610,5},{4,610,10},{4,610,18},{4,610,20},{4,610,32},{4,610,37},{5,0,0},{5,102,0},{5,158,0},{5,159,0},{5,280,0},{5,415,0},{5,416,1},{5,416,4},{5,460,1},{5,460,1004},{5,460,1020},{5,610,2},{5,610,5},{5,610,10},{5,610,18},{5,610,20},{5,610,32},{5,610,37},{6,0,0},{6,102,0},{6,158,0},{6,159,0},{6,280,0},{6,415,0},{6,416,1},{6,416,4},{6,460,1},{6,460,1004},{6,460,1020},{6,610,2},{6,610,5},{6,610,10},{6,610,18},{6,610,20},{6,610,32},{6,610,37},{7,0,0},{7,102,0},{7,158,0},{7,159,0},{7,280,0},{7,415,0},{7,416,1},{7,416,4},{7,460,1},{7,460,1004},{7,460,1020},{7,610,2},{7,610,5},{7,610,10},{7,610,18},{7,610,20},{7,610,32},{7,610,37},{8,0,0},{8,102,0},{8,158,0},{8,159,0},{8,280,0},{8,415,0},{8,416,1},{8,416,4},{8,460,1},{8,460,1004},{8,460,1020},{8,610,2},{8,610,5},{8,610,10},{8,610,18},{8,610,20},{8,610,32},{8,610,37},{9,0,0},{9,102,0},{9,158,0},{9,159,0},{9,280,0},{9,415,0},{9,416,1},{9,416,4},{9,460,1},{9,460,1004},{9,460,1020},{9,610,2},{9,610,5},{9,610,10},{9,610,18},{9,610,20},{9,610,32},{9,610,37},{10,0,0},{10,102,0},{10,158,0},{10,159,0},{10,280,0},{10,415,0},{10,416,1},{10,416,4},{10,460,1},{10,460,1004},{10,460,1020},{10,610,2},{10,610,5},{10,610,10},{10,610,18},{10,610,20},{10,610,32},{10,610,37},{11,0,0},{11,102,0},{11,158,0},{11,159,0},{11,280,0},{11,415,0},{11,416,1},{11,416,4},{11,460,1},{11,460,1004},{11,460,1020},{11,610,2},{11,610,5},{11,610,10},{11,610,18},{11,610,20},{11,610,32},{11,610,37},{12,0,0},{12,102,0},{12,158,0},{12,159,0},{12,280,0},{12,415,0},{12,416,1},{12,416,4},{12,460,1},{12,460,1004},{12,460,1020},{12,610,2},{12,610,5},{12,610,10},{12,610,18},{12,610,20},{12,610,32},{12,610,37},{13,0,0},{13,102,0},{13,158,0},{13,159,0},{13,280,0},{13,415,0},{13,416,1},{13,416,4},{13,460,1},{13,460,1004},{13,460,1020},{13,610,2},{13,610,5},{13,610,10},{13,610,18},{13,610,20},{13,610,32},{13,610,37},{14,0,0},{14,102,0},{14,158,0},{14,159,0},{14,280,0},{14,415,0},{14,416,1},{14,416,4},{14,460,1},{14,460,1004},{14,460,1020},{14,610,2},{14,610,5},{14,610,10},{14,610,18},{14,610,20},{14,610,32},{14,610,37},{15,0,0},{15,102,0},{15,158,0},{15,159,0},{15,280,0},{15,415,0},{15,416,1},{15,416,4},{15,460,1},{15,460,1004},{15,460,1020},{15,610,2},{15,610,5},{15,610,10},{15,610,18},{15,610,20},{15,610,32},{15,610,37},{16,0,0},{16,102,0},{16,158,0},{16,159,0},{16,280,0},{16,415,0},{16,416,1},{16,416,4},{16,460,1},{16,460,1004},{16,460,1020},{16,610,2},{16,610,5},{16,610,10},{16,610,18},{16,610,20},{16,610,32},{16,610,37},{17,0,0},{17,102,0},{17,158,0},{17,159,0},{17,280,0},{17,415,0},{17,416,1},{17,416,4},{17,460,1},{17,460,1004},{17,460,1020},{17,610,2},{17,610,5},{17,610,10},{17,610,18},{17,610,20},{17,610,32},{17,610,37},{18,0,0},{18,102,0},{18,158,0},{18,159,0},{18,280,0},{18,415,0},{18,416,1},{18,416,4},{18,460,1},{18,460,1004},{18,460,1020},{18,610,2},{18,610,5},{18,610,10},{18,610,18},{18,610,20},{18,610,32},{18,610,37},{19,0,0},{19,102,0},{19,158,0},{19,159,0},{19,280,0},{19,415,0},{19,416,1},{19,416,4},{19,460,1},{19,460,1004},{19,460,1020},{19,610,2},{19,610,5},{19,610,10},{19,610,18},{19,610,20},{19,610,32},{19,610,37},{20,0,0},{20,102,0},{20,158,0},{20,159,0},{20,280,0},{20,415,0},{20,416,1},{20,416,4},{20,460,1},{20,460,1004},{20,460,1020},{20,610,2},{20,610,5},{20,610,10},{20,610,18},{20,610,20},{20,610,32},{20,610,37},{21,0,0},{21,102,0},{21,158,0},{21,159,0},{21,280,0},{21,415,0},{21,416,1},{21,416,4},{21,460,1},{21,460,1004},{21,460,1020},{21,610,2},{21,610,5},{21,610,10},{21,610,18},{21,610,20},{21,610,32},{21,610,37},{22,0,0},{22,102,0},{22,158,0},{22,159,0},{22,280,0},{22,415,0},{22,416,1},{22,416,4},{22,460,1},{22,460,1004},{22,460,1020},{22,610,2},{22,610,5},{22,610,10},{22,610,18},{22,610,20},{22,610,32},{22,610,37},{23,0,0},{23,102,0},{23,158,0},{23,159,0},{23,280,0},{23,415,0},{23,416,1},{23,416,4},{23,460,1},{23,460,1004},{23,460,1020},{23,610,2},{23,610,5},{23,610,10},{23,610,18},{23,610,20},{23,610,32},{23,610,37},{24,0,0},{24,102,0},{24,158,0},{24,159,0},{24,280,0},{24,415,0},{24,416,1},{24,416,4},{24,460,1},{24,460,1004},{24,460,1020},{24,610,2},{24,610,5},{24,610,10},{24,610,18},{24,610,20},{24,610,32},{24,610,37},{25,0,0},{25,102,0},{25,158,0},{25,159,0},{25,280,0},{25,415,0},{25,416,1},{25,416,4},{25,460,1},{25,460,1004},{25,460,1020},{25,610,2},{25,610,5},{25,610,10},{25,610,18},{25,610,20},{25,610,32},{25,610,37},{26,0,0},{26,102,0},{26,158,0},{26,159,0},{26,280,0},{26,415,0},{26,416,1},{26,416,4},{26,460,1},{26,460,1004},{26,460,1020},{26,610,2},{26,610,5},{26,610,10},{26,610,18},{26,610,20},{26,610,32},{26,610,37},{27,0,0},{27,102,0},{27,158,0},{27,159,0},{27,280,0},{27,415,0},{27,416,1},{27,416,4},{27,460,1},{27,460,1004},{27,460,1020},{27,610,2},{27,610,5},{27,610,10},{27,610,18},{27,610,20},{27,610,32},{27,610,37},{28,0,0},{28,102,0},{28,158,0},{28,159,0},{28,280,0},{28,415,0},{28,416,1},{28,416,4},{28,460,1},{28,460,1004},{28,460,1020},{28,610,2},{28,610,5},{28,610,10},{28,610,18},{28,610,20},{28,610,32},{28,610,37},{29,0,0},{29,102,0},{29,158,0},{29,159,0},{29,280,0},{29,415,0},{29,416,1},{29,416,4},{29,460,1},{29,460,1004},{29,460,1020},{29,610,2},{29,610,5},{29,610,10},{29,610,18},{29,610,20},{29,610,32},{29,610,37},{30,0,0},{30,102,0},{30,158,0},{30,159,0},{30,280,0},{30,415,0},{30,416,1},{30,416,4},{30,460,1},{30,460,1004},{30,460,1020},{30,610,2},{30,610,5},{30,610,10},{30,610,18},{30,610,20},{30,610,32},{30,610,37},{31,0,0},{31,102,0},{31,158,0},{31,159,0},{31,280,0},{31,415,0},{31,416,1},{31,416,4},{31,460,1},{31,460,1004},{31,460,1020},{31,610,2},{31,610,5},{31,610,10},{31,610,18},{31,610,20},{31,610,32},{31,610,37},{32,0,0},{32,102,0},{32,158,0},{32,159,0},{32,280,0},{32,415,0},{32,416,1},{32,416,4},{32,460,1},{32,460,1004},{32,460,1020},{32,610,2},{32,610,5},{32,610,10},{32,610,18},{32,610,20},{32,610,32},{32,610,37},{33,0,0},{33,102,0},{33,158,0},{33,159,0},{33,280,0},{33,415,0},{33,416,1},{33,416,4},{33,460,1},{33,460,1004},{33,460,1020},{33,610,2},{33,610,5},{33,610,10},{33,610,18},{33,610,20},{33,610,32},{33,610,37},{34,0,0},{34,102,0},{34,158,0},{34,159,0},{34,280,0},{34,415,0},{34,416,1},{34,416,4},{34,460,1},{34,460,1004},{34,460,1020},{34,610,2},{34,610,5},{34,610,10},{34,610,18},{34,610,20},{34,610,32},{34,610,37},{35,0,0},{35,102,0},{35,158,0},{35,159,0},{35,280,0},{35,415,0},{35,416,1},{35,416,4},{35,460,1},{35,460,1004},{35,460,1020},{35,610,2},{35,610,5},{35,610,10},{35,610,18},{35,610,20},{35,610,32},{35,610,37},{36,0,0},{36,102,0},{36,158,0},{36,159,0},{36,280,0},{36,415,0},{36,416,1},{36,416,4},{36,460,1},{36,460,1004},{36,460,1020},{36,610,2},{36,610,5},{36,610,10},{36,610,18},{36,610,20},{36,610,32},{36,610,37},{37,0,0},{37,102,0},{37,158,0},{37,159,0},{37,280,0},{37,415,0},{37,416,1},{37,416,4},{37,460,1},{37,460,1004},{37,460,1020},{37,610,2},{37,610,5},{37,610,10},{37,610,18},{37,610,20},{37,610,32},{37,610,37},{38,0,0},{38,102,0},{38,158,0},{38,159,0},{38,280,0},{38,415,0},{38,416,1},{38,416,4},{38,460,1},{38,460,1004},{38,460,1020},{38,610,2},{38,610,5},{38,610,10},{38,610,18},{38,610,20},{38,610,32},{38,610,37},{39,0,0},{39,102,0},{39,158,0},{39,159,0},{39,280,0},{39,415,0},{39,416,1},{39,416,4},{39,460,1},{39,460,1004},{39,460,1020},{39,610,2},{39,610,5},{39,610,10},{39,610,18},{39,610,20},{39,610,32},{39,610,37},{40,0,0},{40,102,0},{40,158,0},{40,159,0},{40,280,0},{40,415,0},{40,416,1},{40,416,4},{40,460,1},{40,460,1004},{40,460,1020},{40,610,2},{40,610,5},{40,610,10},{40,610,18},{40,610,20},{40,610,32},{40,610,37},{41,0,0},{41,102,0},{41,158,0},{41,159,0},{41,280,0},{41,415,0},{41,416,1},{41,416,4},{41,460,1},{41,460,1004},{41,460,1020},{41,610,2},{41,610,5},{41,610,10},{41,610,18},{41,610,20},{41,610,32},{41,610,37},{42,0,0},{42,102,0},{42,158,0},{42,159,0},{42,280,0},{42,415,0},{42,416,1},{42,416,4},{42,460,1},{42,460,1004},{42,460,1020},{42,610,2},{42,610,5},{42,610,10},{42,610,18},{42,610,20},{42,610,32},{42,610,37},{43,0,0},{43,102,0},{43,158,0},{43,159,0},{43,280,0},{43,415,0},{43,416,1},{43,416,4},{43,460,1},{43,460,1004},{43,460,1020},{43,610,2},{43,610,5},{43,610,10},{43,610,18},{43,610,20},{43,610,32},{43,610,37},{44,0,0},{44,102,0},{44,158,0},{44,159,0},{44,280,0},{44,415,0},{44,416,1},{44,416,4},{44,460,1},{44,460,1004},{44,460,1020},{44,610,2},{44,610,5},{44,610,10},{44,610,18},{44,610,20},{44,610,32},{44,610,37},{45,0,0},{45,102,0},{45,158,0},{45,159,0},{45,280,0},{45,415,0},{45,416,1},{45,416,4},{45,460,1},{45,460,1004},{45,460,1020},{45,610,2},{45,610,5},{45,610,10},{45,610,18},{45,610,20},{45,610,32},{45,610,37},{46,0,0},{46,102,0},{46,158,0},{46,159,0},{46,280,0},{46,415,0},{46,416,1},{46,416,4},{46,460,1},{46,460,1004},{46,460,1020},{46,610,2},{46,610,5},{46,610,10},{46,610,18},{46,610,20},{46,610,32},{46,610,37},{47,0,0},{47,102,0},{47,158,0},{47,159,0},{47,280,0},{47,415,0},{47,416,1},{47,416,4},{47,460,1},{47,460,1004},{47,460,1020},{47,610,2},{47,610,5},{47,610,10},{47,610,18},{47,610,20},{47,610,32},{47,610,37},{48,0,0},{48,102,0},{48,158,0},{48,159,0},{48,280,0},{48,415,0},{48,416,1},{48,416,4},{48,460,1},{48,460,1004},{48,460,1020},{48,610,2},{48,610,5},{48,610,10},{48,610,18},{48,610,20},{48,610,32},{48,610,37},{49,0,0},{49,102,0},{49,158,0},{49,159,0},{49,280,0},{49,415,0},{49,416,1},{49,416,4},{49,460,1},{49,460,1004},{49,460,1020},{49,610,2},{49,610,5},{49,610,10},{49,610,18},{49,610,20},{49,610,32},{49,610,37},{50,0,0},{50,102,0},{50,158,0},{50,159,0},{50,280,0},{50,415,0},{50,416,1},{50,416,4},{50,460,1},{50,460,1004},{50,460,1020},{50,610,2},{50,610,5},{50,610,10},{50,610,18},{50,610,20},{50,610,32},{50,610,37},{51,0,0},{51,102,0},{51,158,0},{51,159,0},{51,280,0},{51,415,0},{51,416,1},{51,416,4},{51,460,1},{51,460,1004},{51,460,1020},{51,610,2},{51,610,5},{51,610,10},{51,610,18},{51,610,20},{51,610,32},{51,610,37},{52,0,0},{52,102,0},{52,158,0},{52,159,0},{52,280,0},{52,415,0},{52,416,1},{52,416,4},{52,460,1},{52,460,1004},{52,460,1020},{52,610,2},{52,610,5},{52,610,10},{52,610,18},{52,610,20},{52,610,32},{52,610,37},{53,0,0},{53,102,0},{53,158,0},{53,159,0},{53,280,0},{53,415,0},{53,416,1},{53,416,4},{53,460,1},{53,460,1004},{53,460,1020},{53,610,2},{53,610,5},{53,610,10},{53,610,18},{53,610,20},{53,610,32},{53,610,37},{54,0,0},{54,102,0},{54,158,0},{54,159,0},{54,280,0},{54,415,0},{54,416,1},{54,416,4},{54,460,1},{54,460,1004},{54,460,1020},{54,610,2},{54,610,5},{54,610,10},{54,610,18},{54,610,20},{54,610,32},{54,610,37},{55,0,0},{55,102,0},{55,158,0},{55,159,0},{55,280,0},{55,415,0},{55,416,1},{55,416,4},{55,460,1},{55,460,1004},{55,460,1020},{55,610,2},{55,610,5},{55,610,10},{55,610,18},{55,610,20},{55,610,32},{55,610,37},{56,0,0},{56,102,0},{56,158,0},{56,159,0},{56,280,0},{56,415,0},{56,416,1},{56,416,4},{56,460,1},{56,460,1004},{56,460,1020},{56,610,2},{56,610,5},{56,610,10},{56,610,18},{56,610,20},{56,610,32},{56,610,37},{57,0,0},{57,102,0},{57,158,0},{57,159,0},{57,280,0},{57,415,0},{57,416,1},{57,416,4},{57,460,1},{57,460,1004},{57,460,1020},{57,610,2},{57,610,5},{57,610,10},{57,610,18},{57,610,20},{57,610,32},{57,610,37},{58,0,0},{58,102,0},{58,158,0},{58,159,0},{58,280,0},{58,415,0},{58,416,1},{58,416,4},{58,460,1},{58,460,1004},{58,460,1020},{58,610,2},{58,610,5},{58,610,10},{58,610,18},{58,610,20},{58,610,32},{58,610,37},{59,0,0},{59,102,0},{59,158,0},{59,159,0},{59,280,0},{59,415,0},{59,416,1},{59,416,4},{59,460,1},{59,460,1004},{59,460,1020},{59,610,2},{59,610,5},{59,610,10},{59,610,18},{59,610,20},{59,610,32},{59,610,37},{60,0,0},{60,102,0},{60,158,0},{60,159,0},{60,280,0},{60,415,0},{60,416,1},{60,416,4},{60,460,1},{60,460,1004},{60,460,1020},{60,610,2},{60,610,5},{60,610,10},{60,610,18},{60,610,20},{60,610,32},{60,610,37},{61,0,0},{61,102,0},{61,158,0},{61,159,0},{61,280,0},{61,415,0},{61,416,1},{61,416,4},{61,460,1},{61,460,1004},{61,460,1020},{61,610,2},{61,610,5},{61,610,10},{61,610,18},{61,610,20},{61,610,32},{61,610,37},{62,0,0},{62,102,0},{62,158,0},{62,159,0},{62,280,0},{62,415,0},{62,416,1},{62,416,4},{62,460,1},{62,460,1004},{62,460,1020},{62,610,2},{62,610,5},{62,610,10},{62,610,18},{62,610,20},{62,610,32},{62,610,37},{63,0,0},{63,102,0},{63,158,0},{63,159,0},{63,280,0},{63,415,0},{63,416,1},{63,416,4},{63,460,1},{63,460,1004},{63,460,1020},{63,610,2},{63,610,5},{63,610,10},{63,610,18},{63,610,20},{63,610,32},{63,610,37},{64,0,0},{64,102,0},{64,158,0},{64,159,0},{64,280,0},{64,415,0},{64,416,1},{64,416,4},{64,460,1},{64,460,1004},{64,460,1020},{64,610,2},{64,610,5},{64,610,10},{64,610,18},{64,610,20},{64,610,32},{64,610,37},{65,0,0},{65,102,0},{65,158,0},{65,159,0},{65,280,0},{65,415,0},{65,416,1},{65,416,4},{65,460,1},{65,460,1004},{65,460,1020},{65,610,2},{65,610,5},{65,610,10},{65,610,18},{65,610,20},{65,610,32},{65,610,37},{66,0,0},{66,102,0},{66,158,0},{66,159,0},{66,280,0},{66,415,0},{66,416,1},{66,416,4},{66,460,1},{66,460,1004},{66,460,1020},{66,610,2},{66,610,5},{66,610,10},{66,610,18},{66,610,20},{66,610,32},{66,610,37},{67,0,0},{67,102,0},{67,158,0},{67,159,0},{67,280,0},{67,415,0},{67,416,1},{67,416,4},{67,460,1},{67,460,1004},{67,460,1020},{67,610,2},{67,610,5},{67,610,10},{67,610,18},{67,610,20},{67,610,32},{67,610,37},{68,0,0},{68,102,0},{68,158,0},{68,159,0},{68,280,0},{68,415,0},{68,416,1},{68,416,4},{68,460,1},{68,460,1004},{68,460,1020},{68,610,2},{68,610,5},{68,610,10},{68,610,18},{68,610,20},{68,610,32},{68,610,37},{69,0,0},{69,102,0},{69,158,0},{69,159,0},{69,280,0},{69,415,0},{69,416,1},{69,416,4},{69,460,1},{69,460,1004},{69,460,1020},{69,610,2},{69,610,5},{69,610,10},{69,610,18},{69,610,20},{69,610,32},{69,610,37},{70,0,0},{70,102,0},{70,158,0},{70,159,0},{70,280,0},{70,415,0},{70,416,1},{70,416,4},{70,460,1},{70,460,1004},{70,460,1020},{70,610,2},{70,610,5},{70,610,10},{70,610,18},{70,610,20},{70,610,32},{70,610,37},{71,0,0},{71,102,0},{71,158,0},{71,159,0},{71,280,0},{71,415,0},{71,416,1},{71,416,4},{71,460,1},{71,460,1004},{71,460,1020},{71,610,2},{71,610,5},{71,610,10},{71,610,18},{71,610,20},{71,610,32},{71,610,37},{72,0,0},{72,102,0},{72,158,0},{72,159,0},{72,280,0},{72,415,0},{72,416,1},{72,416,4},{72,460,1},{72,460,1004},{72,460,1020},{72,610,2},{72,610,5},{72,610,10},{72,610,18},{72,610,20},{72,610,32},{72,610,37},{73,0,0},{73,102,0},{73,158,0},{73,159,0},{73,280,0},{73,415,0},{73,416,1},{73,416,4},{73,460,1},{73,460,1004},{73,460,1020},{73,610,2},{73,610,5},{73,610,10},{73,610,18},{73,610,20},{73,610,32},{73,610,37},{74,0,0},{74,102,0},{74,158,0},{74,159,0},{74,280,0},{74,415,0},{74,416,1},{74,416,4},{74,460,1},{74,460,1004},{74,460,1020},{74,610,2},{74,610,5},{74,610,10},{74,610,18},{74,610,20},{74,610,32},{74,610,37},{75,0,0},{75,102,0},{75,158,0},{75,159,0},{75,280,0},{75,415,0},{75,416,1},{75,416,4},{75,460,1},{75,460,1004},{75,460,1020},{75,610,2},{75,610,5},{75,610,10},{75,610,18},{75,610,20},{75,610,32},{75,610,37},{76,0,0},{76,102,0},{76,158,0},{76,159,0},{76,280,0},{76,415,0},{76,416,1},{76,416,4},{76,460,1},{76,460,1004},{76,460,1020},{76,610,2},{76,610,5},{76,610,10},{76,610,18},{76,610,20},{76,610,32},{76,610,37},{77,0,0},{77,102,0},{77,158,0},{77,159,0},{77,280,0},{77,415,0},{77,416,1},{77,416,4},{77,460,1},{77,460,1004},{77,460,1020},{77,610,2},{77,610,5},{77,610,10},{77,610,18},{77,610,20},{77,610,32},{77,610,37}].


get(continute_day) ->
999;


get(limit_lv) ->
999;


get(open_day) ->
999;


get(person_name) ->
"嗨点活动";

get(_Keyy) ->
	[].


get_desc(1001) ->
"击杀一个BOSS之家BOSS";


get_desc(1002) ->
"击杀一个蛮荒BOSS";


get_desc(1003) ->
"参加一次龙纹副本";


get_desc(1004) ->
"连续3天充值";


get_desc(1005) ->
"达到300级";


get_desc(1006) ->
"达到310级";


get_desc(1007) ->
"达到320级";


get_desc(1008) ->
"通关简单难度源力副本";


get_desc(1009) ->
"通关困难难度源力副本";


get_desc(1010) ->
"任意源力达到20级";


get_desc(1011) ->
"任意源力达到30级";


get_desc(1012) ->
"任意源力达到40级";


get_desc(1013) ->
"镶嵌1个橙色或以上源力";


get_desc(1014) ->
"镶嵌2个橙色或以上源力";


get_desc(1015) ->
"4阶以上坐骑提升2个星";


get_desc(1016) ->
"4阶以上坐骑提升3个星";


get_desc(1017) ->
"4阶以上坐骑提升5个星";


get_desc(1018) ->
"4阶以上伙伴提升2个星";


get_desc(1019) ->
"4阶以上伙伴提升3个星";


get_desc(1020) ->
"4阶以上伙伴提升5个星";


get_desc(1021) ->
"宝宝养育至5级";


get_desc(1022) ->
"宝宝养育至10级";


get_desc(1023) ->
"宝宝养育至20级";


get_desc(1024) ->
"宝宝升级至2阶";


get_desc(1025) ->
"紫色或以上龙纹提升到10级";


get_desc(1026) ->
"紫色或以上龙纹提升到20级";


get_desc(1027) ->
"紫色或以上龙纹提升到30级";


get_desc(1028) ->
"连续3天充值";


get_desc(1029) ->
"装备寻宝10次";


get_desc(1030) ->
"装备寻宝20次";


get_desc(1031) ->
"装备寻宝50次";


get_desc(1032) ->
"累计消费1680钻石";


get_desc(1033) ->
"累计消费3880钻石";


get_desc(1034) ->
"累计消费6880钻石";


get_desc(1035) ->
"累计消费12880钻石";


get_desc(1036) ->
"累计消费19880钻石";


get_desc(1037) ->
"击杀一个世界BOSS";


get_desc(1038) ->
"击杀一个专属BOSS";


get_desc(1039) ->
"进入一次蛮荒之地";


get_desc(1040) ->
"任意寻宝一次";


get_desc(1041) ->
"金币或经验祈愿一次";


get_desc(1042) ->
"完成1次日常任务";


get_desc(1043) ->
"进入1次经验副本";


get_desc(1044) ->
"进入1次金币副本";


get_desc(1045) ->
"进入1次伙伴副本";


get_desc(1046) ->
"进入1次伙伴副本";


get_desc(1047) ->
"护送女神1次";


get_desc(1048) ->
"情侣副本1次";


get_desc(1049) ->
"进行1次竞技";


get_desc(1050) ->
"消费300钻石";


get_desc(1051) ->
"消费680钻石";


get_desc(1052) ->
"消费1280钻石";


get_desc(1053) ->
"消费3280钻石";


get_desc(1054) ->
"消费6480钻石";


get_desc(1055) ->
"消费12880钻石";


get_desc(1056) ->
"消费18880钻石";


get_desc(1057) ->
"消费28880钻石";


get_desc(1058) ->
"累计充值6元";


get_desc(1059) ->
"累计充值30元";


get_desc(1060) ->
"累计充值98元";


get_desc(1061) ->
"累计充值128元";


get_desc(1062) ->
"累计充值328元";


get_desc(1063) ->
"累计充值648元";


get_desc(1064) ->
"累计消费60勾玉";


get_desc(1065) ->
"累计消费300勾玉";


get_desc(1066) ->
"累计消费980勾玉";


get_desc(1067) ->
"累计消费1280勾玉";


get_desc(1068) ->
"累计消费3280勾玉";


get_desc(1069) ->
"累计消费6480勾玉";


get_desc(1070) ->
"装备寻宝10次";


get_desc(1071) ->
"装备寻宝30次";


get_desc(1072) ->
"装备寻宝50次";


get_desc(1073) ->
"御魂召唤10次";


get_desc(1074) ->
"御魂召唤30次";


get_desc(1075) ->
"御魂召唤50次";


get_desc(1076) ->
"祈愿1次";


get_desc(1077) ->
"祈愿10次";


get_desc(1078) ->
"祈愿50次";

get_desc(_Id) ->
	"".

