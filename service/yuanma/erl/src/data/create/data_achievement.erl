%%%---------------------------------------
%%% module      : data_achievement
%%% description : 成就配置
%%%
%%%---------------------------------------
-module(data_achievement).
-compile(export_all).
-include("rec_achievement.hrl").



get_category_list() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133].


get_category_type(1) ->
1;


get_category_type(2) ->
2;


get_category_type(3) ->
2;


get_category_type(4) ->
2;


get_category_type(5) ->
2;


get_category_type(6) ->
2;


get_category_type(7) ->
2;


get_category_type(8) ->
2;


get_category_type(9) ->
2;


get_category_type(10) ->
2;


get_category_type(11) ->
2;


get_category_type(12) ->
2;


get_category_type(13) ->
2;


get_category_type(14) ->
2;


get_category_type(15) ->
2;


get_category_type(16) ->
2;


get_category_type(17) ->
2;


get_category_type(18) ->
2;


get_category_type(19) ->
2;


get_category_type(20) ->
2;


get_category_type(21) ->
2;


get_category_type(22) ->
2;


get_category_type(23) ->
2;


get_category_type(24) ->
2;


get_category_type(25) ->
2;


get_category_type(26) ->
2;


get_category_type(27) ->
2;


get_category_type(28) ->
2;


get_category_type(29) ->
2;


get_category_type(30) ->
2;


get_category_type(31) ->
2;


get_category_type(32) ->
2;


get_category_type(33) ->
2;


get_category_type(34) ->
2;


get_category_type(35) ->
2;


get_category_type(36) ->
2;


get_category_type(37) ->
2;


get_category_type(38) ->
2;


get_category_type(39) ->
2;


get_category_type(40) ->
2;


get_category_type(41) ->
2;


get_category_type(42) ->
2;


get_category_type(43) ->
2;


get_category_type(44) ->
3;


get_category_type(45) ->
3;


get_category_type(46) ->
3;


get_category_type(47) ->
3;


get_category_type(48) ->
3;


get_category_type(49) ->
3;


get_category_type(50) ->
3;


get_category_type(51) ->
3;


get_category_type(52) ->
3;


get_category_type(53) ->
3;


get_category_type(58) ->
4;


get_category_type(59) ->
4;


get_category_type(60) ->
4;


get_category_type(61) ->
4;


get_category_type(62) ->
4;


get_category_type(63) ->
4;


get_category_type(64) ->
4;


get_category_type(65) ->
4;


get_category_type(66) ->
4;


get_category_type(67) ->
4;


get_category_type(68) ->
4;


get_category_type(69) ->
4;


get_category_type(70) ->
4;


get_category_type(71) ->
4;


get_category_type(72) ->
4;


get_category_type(73) ->
4;


get_category_type(74) ->
4;


get_category_type(75) ->
4;


get_category_type(76) ->
4;


get_category_type(77) ->
4;


get_category_type(78) ->
4;


get_category_type(79) ->
4;


get_category_type(80) ->
4;


get_category_type(81) ->
4;


get_category_type(82) ->
4;


get_category_type(83) ->
4;


get_category_type(84) ->
4;


get_category_type(85) ->
4;


get_category_type(86) ->
4;


get_category_type(87) ->
4;


get_category_type(88) ->
4;


get_category_type(89) ->
4;


get_category_type(90) ->
4;


get_category_type(91) ->
4;


get_category_type(92) ->
4;


get_category_type(93) ->
4;


get_category_type(94) ->
5;


get_category_type(95) ->
5;


get_category_type(96) ->
5;


get_category_type(97) ->
5;


get_category_type(98) ->
5;


get_category_type(99) ->
5;


get_category_type(100) ->
5;


get_category_type(101) ->
5;


get_category_type(102) ->
5;


get_category_type(103) ->
5;


get_category_type(104) ->
5;


get_category_type(105) ->
6;


get_category_type(106) ->
6;


get_category_type(107) ->
6;


get_category_type(108) ->
6;


get_category_type(109) ->
6;


get_category_type(110) ->
6;


get_category_type(111) ->
6;


get_category_type(112) ->
6;


get_category_type(113) ->
6;


get_category_type(114) ->
6;


get_category_type(115) ->
6;


get_category_type(116) ->
7;


get_category_type(117) ->
7;


get_category_type(118) ->
7;


get_category_type(119) ->
7;


get_category_type(120) ->
7;


get_category_type(121) ->
7;


get_category_type(122) ->
7;


get_category_type(123) ->
7;


get_category_type(124) ->
7;


get_category_type(125) ->
7;


get_category_type(126) ->
7;


get_category_type(127) ->
7;


get_category_type(128) ->
7;


get_category_type(129) ->
7;


get_category_type(130) ->
7;


get_category_type(131) ->
7;


get_category_type(132) ->
4;


get_category_type(133) ->
5;

get_category_type(_Category) ->
	[].

get(1) ->
	#achievement_cfg{id = 1,category = 1,star = 0,next_id = 2,is_inherit = 1,show_progress = 1,condition = [{achv_stage_reward,1000}],reward = [{2,0,50}],ways = 0};

get(2) ->
	#achievement_cfg{id = 2,category = 1,star = 0,next_id = 3,is_inherit = 1,show_progress = 1,condition = [{achv_stage_reward,2000}],reward = [{2,0,60}],ways = 0};

get(3) ->
	#achievement_cfg{id = 3,category = 1,star = 0,next_id = 4,is_inherit = 1,show_progress = 1,condition = [{achv_stage_reward,5000}],reward = [{2,0,70}],ways = 0};

get(4) ->
	#achievement_cfg{id = 4,category = 1,star = 0,next_id = 5,is_inherit = 1,show_progress = 1,condition = [{achv_stage_reward,8000}],reward = [{2,0,80}],ways = 0};

get(5) ->
	#achievement_cfg{id = 5,category = 1,star = 0,next_id = 6,is_inherit = 1,show_progress = 1,condition = [{achv_stage_reward,12000}],reward = [{2,0,100}],ways = 0};

get(6) ->
	#achievement_cfg{id = 6,category = 1,star = 0,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{achv_stage_reward,15000}],reward = [{2,0,120}],ways = 0};

get(2001) ->
	#achievement_cfg{id = 2001,category = 2,star = 80,next_id = 2002,is_inherit = 0,show_progress = 0,condition = [{recharge_first,1}],reward = [{0,38064108,1}],ways = 0};

get(2002) ->
	#achievement_cfg{id = 2002,category = 2,star = 50,next_id = 2003,is_inherit = 0,show_progress = 0,condition = [{vip_lv,2}],reward = [{2,0,20},{0,20020002,1}],ways = 0};

get(2003) ->
	#achievement_cfg{id = 2003,category = 2,star = 50,next_id = 2004,is_inherit = 0,show_progress = 0,condition = [{vip_lv,3}],reward = [{2,0,30},{0,20020002,1}],ways = 0};

get(2004) ->
	#achievement_cfg{id = 2004,category = 2,star = 100,next_id = 2005,is_inherit = 0,show_progress = 0,condition = [{vip_lv,4}],reward = [{2,0,50},{0,20020002,1}],ways = 0};

get(2005) ->
	#achievement_cfg{id = 2005,category = 2,star = 100,next_id = 2006,is_inherit = 0,show_progress = 0,condition = [{vip_lv,5}],reward = [{2,0,50},{0,20020002,1}],ways = 0};

get(2006) ->
	#achievement_cfg{id = 2006,category = 2,star = 100,next_id = 2007,is_inherit = 0,show_progress = 0,condition = [{vip_lv,6}],reward = [{0,38064110,1}],ways = 0};

get(2007) ->
	#achievement_cfg{id = 2007,category = 2,star = 150,next_id = 2008,is_inherit = 0,show_progress = 0,condition = [{vip_lv,7}],reward = [{2,0,50},{0,20020002,2}],ways = 0};

get(2008) ->
	#achievement_cfg{id = 2008,category = 2,star = 150,next_id = 2009,is_inherit = 0,show_progress = 0,condition = [{vip_lv,8}],reward = [{2,0,50},{0,20020002,2}],ways = 0};

get(2009) ->
	#achievement_cfg{id = 2009,category = 2,star = 150,next_id = 2010,is_inherit = 0,show_progress = 0,condition = [{vip_lv,9}],reward = [{2,0,50},{0,20020002,2}],ways = 0};

get(2010) ->
	#achievement_cfg{id = 2010,category = 2,star = 150,next_id = 0,is_inherit = 0,show_progress = 0,condition = [{vip_lv,10}],reward = [{2,0,50},{0,20020002,2}],ways = 0};

get(3001) ->
	#achievement_cfg{id = 3001,category = 3,star = 40,next_id = 3002,is_inherit = 0,show_progress = 1,condition = [{role_lv,110}],reward = [{2,0,10},{0,16020001,2}],ways = 0};

get(3002) ->
	#achievement_cfg{id = 3002,category = 3,star = 50,next_id = 3003,is_inherit = 0,show_progress = 1,condition = [{role_lv,180}],reward = [{2,0,25},{0,16020001,2}],ways = 0};

get(3003) ->
	#achievement_cfg{id = 3003,category = 3,star = 70,next_id = 3004,is_inherit = 0,show_progress = 1,condition = [{role_lv,200}],reward = [{2,0,35},{0,16020001,2}],ways = 0};

get(3004) ->
	#achievement_cfg{id = 3004,category = 3,star = 90,next_id = 3005,is_inherit = 0,show_progress = 1,condition = [{role_lv,220}],reward = [{2,0,45},{0,16020001,2}],ways = 0};

get(3005) ->
	#achievement_cfg{id = 3005,category = 3,star = 110,next_id = 3006,is_inherit = 0,show_progress = 1,condition = [{role_lv,250}],reward = [{2,0,55},{0,16020001,2}],ways = 0};

get(3006) ->
	#achievement_cfg{id = 3006,category = 3,star = 150,next_id = 3007,is_inherit = 0,show_progress = 1,condition = [{role_lv,280}],reward = [{2,0,55},{0,16020001,2}],ways = 0};

get(3007) ->
	#achievement_cfg{id = 3007,category = 3,star = 160,next_id = 3008,is_inherit = 0,show_progress = 1,condition = [{role_lv,320}],reward = [{2,0,55},{0,16020001,2}],ways = 0};

get(3008) ->
	#achievement_cfg{id = 3008,category = 3,star = 170,next_id = 3009,is_inherit = 0,show_progress = 1,condition = [{role_lv,370}],reward = [{2,0,55},{0,16020001,2}],ways = 0};

get(3009) ->
	#achievement_cfg{id = 3009,category = 3,star = 180,next_id = 3010,is_inherit = 0,show_progress = 1,condition = [{role_lv,420}],reward = [{2,0,55},{0,16020001,2}],ways = 0};

get(3010) ->
	#achievement_cfg{id = 3010,category = 3,star = 190,next_id = 3011,is_inherit = 0,show_progress = 1,condition = [{role_lv,470}],reward = [{2,0,55},{0,16020001,2}],ways = 0};

get(3011) ->
	#achievement_cfg{id = 3011,category = 3,star = 200,next_id = 3012,is_inherit = 0,show_progress = 1,condition = [{role_lv,520}],reward = [{2,0,55},{0,16020001,2}],ways = 0};

get(3012) ->
	#achievement_cfg{id = 3012,category = 3,star = 210,next_id = 3013,is_inherit = 0,show_progress = 1,condition = [{role_lv,570}],reward = [{2,0,55},{0,16020001,2}],ways = 0};

get(3013) ->
	#achievement_cfg{id = 3013,category = 3,star = 220,next_id = 3014,is_inherit = 0,show_progress = 1,condition = [{role_lv,620}],reward = [{2,0,55},{0,16020001,2}],ways = 0};

get(3014) ->
	#achievement_cfg{id = 3014,category = 3,star = 230,next_id = 0,is_inherit = 0,show_progress = 1,condition = [{role_lv,670}],reward = [{2,0,60},{0,16020001,2}],ways = 0};

get(4001) ->
	#achievement_cfg{id = 4001,category = 4,star = 100,next_id = 4002,is_inherit = 0,show_progress = 0,condition = [{role_turn,1}],reward = [{2,0,15},{3,0,1000000}],ways = 0};

get(4002) ->
	#achievement_cfg{id = 4002,category = 4,star = 200,next_id = 4003,is_inherit = 0,show_progress = 0,condition = [{role_turn,2}],reward = [{2,0,30},{3,0,2000000}],ways = 0};

get(4003) ->
	#achievement_cfg{id = 4003,category = 4,star = 300,next_id = 4004,is_inherit = 0,show_progress = 0,condition = [{role_turn,3}],reward = [{2,0,45},{3,0,3000000}],ways = 0};

get(4004) ->
	#achievement_cfg{id = 4004,category = 4,star = 400,next_id = 4005,is_inherit = 0,show_progress = 0,condition = [{role_turn,4}],reward = [{2,0,60},{3,0,4000000}],ways = 0};

get(4005) ->
	#achievement_cfg{id = 4005,category = 4,star = 500,next_id = 4006,is_inherit = 0,show_progress = 0,condition = [{role_turn,5}],reward = [{2,0,75},{3,0,5000000}],ways = 0};

get(4006) ->
	#achievement_cfg{id = 4006,category = 4,star = 500,next_id = 4007,is_inherit = 0,show_progress = 0,condition = [{role_turn,6}],reward = [{2,0,80},{3,0,5000000}],ways = 0};

get(4007) ->
	#achievement_cfg{id = 4007,category = 4,star = 500,next_id = 0,is_inherit = 0,show_progress = 0,condition = [{role_turn,7}],reward = [{2,0,85},{3,0,5000000}],ways = 0};

get(7001) ->
	#achievement_cfg{id = 7001,category = 7,star = 10,next_id = 7002,is_inherit = 0,show_progress = 1,condition = [{fasion_active,1}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(7002) ->
	#achievement_cfg{id = 7002,category = 7,star = 10,next_id = 7003,is_inherit = 0,show_progress = 1,condition = [{fasion_active,3}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(7003) ->
	#achievement_cfg{id = 7003,category = 7,star = 20,next_id = 7004,is_inherit = 0,show_progress = 1,condition = [{fasion_active,5}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(7004) ->
	#achievement_cfg{id = 7004,category = 7,star = 30,next_id = 7005,is_inherit = 0,show_progress = 1,condition = [{fasion_active,7}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(7005) ->
	#achievement_cfg{id = 7005,category = 7,star = 50,next_id = 7006,is_inherit = 0,show_progress = 1,condition = [{fasion_active,9}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(7006) ->
	#achievement_cfg{id = 7006,category = 7,star = 50,next_id = 7007,is_inherit = 0,show_progress = 1,condition = [{fasion_active,12}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(7007) ->
	#achievement_cfg{id = 7007,category = 7,star = 50,next_id = 7008,is_inherit = 0,show_progress = 1,condition = [{fasion_active,15}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(7008) ->
	#achievement_cfg{id = 7008,category = 7,star = 50,next_id = 7009,is_inherit = 0,show_progress = 1,condition = [{fasion_active,18}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(7009) ->
	#achievement_cfg{id = 7009,category = 7,star = 50,next_id = 0,is_inherit = 0,show_progress = 1,condition = [{fasion_active,20}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(13001) ->
	#achievement_cfg{id = 13001,category = 13,star = 20,next_id = 13002,is_inherit = 0,show_progress = 1,condition = [{rune_lv,10},{rune_equip,1}],reward = [{2,0,30},{3,0,100000}],ways = 0};

get(13002) ->
	#achievement_cfg{id = 13002,category = 13,star = 30,next_id = 13003,is_inherit = 0,show_progress = 1,condition = [{rune_lv,20},{rune_equip,1}],reward = [{2,0,40},{3,0,200000}],ways = 0};

get(13003) ->
	#achievement_cfg{id = 13003,category = 13,star = 40,next_id = 13004,is_inherit = 0,show_progress = 1,condition = [{rune_lv,30},{rune_equip,1}],reward = [{2,0,50},{3,0,300000}],ways = 0};

get(13004) ->
	#achievement_cfg{id = 13004,category = 13,star = 50,next_id = 13005,is_inherit = 0,show_progress = 1,condition = [{rune_lv,40},{rune_equip,1}],reward = [{2,0,60},{3,0,400000}],ways = 0};

get(13005) ->
	#achievement_cfg{id = 13005,category = 13,star = 80,next_id = 0,is_inherit = 0,show_progress = 1,condition = [{rune_lv,50},{rune_equip,1}],reward = [{2,0,70},{3,0,500000}],ways = 0};

get(17001) ->
	#achievement_cfg{id = 17001,category = 17,star = 20,next_id = 17002,is_inherit = 0,show_progress = 0,condition = [{rune_color,4},{rune_equip_color,1}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(17002) ->
	#achievement_cfg{id = 17002,category = 17,star = 30,next_id = 17003,is_inherit = 0,show_progress = 0,condition = [{rune_color,4},{rune_equip_color,4}],reward = [{2,0,20},{0,53020204,1}],ways = 0};

get(17003) ->
	#achievement_cfg{id = 17003,category = 17,star = 50,next_id = 17004,is_inherit = 0,show_progress = 0,condition = [{rune_color,4},{rune_equip_color,8}],reward = [{2,0,40},{3,0,400000}],ways = 0};

get(17004) ->
	#achievement_cfg{id = 17004,category = 17,star = 60,next_id = 17005,is_inherit = 0,show_progress = 0,condition = [{rune_color,5},{rune_equip_color,1}],reward = [{2,0,10},{3,0,400000}],ways = 0};

get(17005) ->
	#achievement_cfg{id = 17005,category = 17,star = 80,next_id = 17006,is_inherit = 0,show_progress = 0,condition = [{rune_color,5},{rune_equip_color,4}],reward = [{2,0,20},{3,0,600000}],ways = 0};

get(17006) ->
	#achievement_cfg{id = 17006,category = 17,star = 100,next_id = 0,is_inherit = 0,show_progress = 0,condition = [{rune_color,5},{rune_equip_color,8}],reward = [{2,0,40},{3,0,1000000}],ways = 0};

get(19001) ->
	#achievement_cfg{id = 19001,category = 19,star = 50,next_id = 19002,is_inherit = 1,show_progress = 1,condition = [{compose_rune,1}],reward = [{2,0,20},{0,38040012,15}],ways = 0};

get(19002) ->
	#achievement_cfg{id = 19002,category = 19,star = 60,next_id = 19003,is_inherit = 1,show_progress = 1,condition = [{compose_rune,5}],reward = [{2,0,30},{0,38040012,30}],ways = 0};

get(19003) ->
	#achievement_cfg{id = 19003,category = 19,star = 80,next_id = 19004,is_inherit = 1,show_progress = 1,condition = [{compose_rune,10}],reward = [{2,0,40},{0,38040012,45}],ways = 0};

get(19004) ->
	#achievement_cfg{id = 19004,category = 19,star = 100,next_id = 19005,is_inherit = 1,show_progress = 1,condition = [{compose_rune,15}],reward = [{2,0,50},{0,38040012,60}],ways = 0};

get(19005) ->
	#achievement_cfg{id = 19005,category = 19,star = 120,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{compose_rune,20}],reward = [{2,0,60},{0,38040012,60}],ways = 0};

get(39001) ->
	#achievement_cfg{id = 39001,category = 39,star = 50,next_id = 39002,is_inherit = 0,show_progress = 1,condition = [{compose_equip, 4}, {compose_equip_color, 5},{compose_equip_star, 2},{compose_equip_num, 1}],reward = [{2,0,30},{3,0,200000}],ways = 0};

get(39002) ->
	#achievement_cfg{id = 39002,category = 39,star = 60,next_id = 0,is_inherit = 0,show_progress = 1,condition = [{compose_equip, 4}, {compose_equip_color, 5},{compose_equip_star, 3},{compose_equip_num, 1}],reward = [{2,0,40},{0,53020201,1}],ways = 0};

get(44001) ->
	#achievement_cfg{id = 44001,category = 44,star = 60,next_id = 44002,is_inherit = 0,show_progress = 0,condition = [{mount_star,3},{mount_stage,2 }],reward = [{2,0,15},{0,16020001,2}],ways = 0};

get(44002) ->
	#achievement_cfg{id = 44002,category = 44,star = 70,next_id = 44003,is_inherit = 0,show_progress = 0,condition = [{mount_star,3},{mount_stage,3 }],reward = [{2,0,20},{0,16020001,2}],ways = 0};

get(44003) ->
	#achievement_cfg{id = 44003,category = 44,star = 80,next_id = 44004,is_inherit = 0,show_progress = 0,condition = [{mount_star,3},{mount_stage,4 }],reward = [{2,0,25},{0,16020001,2}],ways = 0};

get(44004) ->
	#achievement_cfg{id = 44004,category = 44,star = 90,next_id = 44005,is_inherit = 0,show_progress = 0,condition = [{mount_star,3},{mount_stage,5 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(44005) ->
	#achievement_cfg{id = 44005,category = 44,star = 100,next_id = 44006,is_inherit = 0,show_progress = 0,condition = [{mount_star,3},{mount_stage,6 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(44006) ->
	#achievement_cfg{id = 44006,category = 44,star = 100,next_id = 44007,is_inherit = 0,show_progress = 0,condition = [{mount_star,3},{mount_stage,7 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(44007) ->
	#achievement_cfg{id = 44007,category = 44,star = 100,next_id = 44008,is_inherit = 0,show_progress = 0,condition = [{mount_star,3},{mount_stage,8 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(44008) ->
	#achievement_cfg{id = 44008,category = 44,star = 100,next_id = 44009,is_inherit = 0,show_progress = 0,condition = [{mount_star,3},{mount_stage,9 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(44009) ->
	#achievement_cfg{id = 44009,category = 44,star = 100,next_id = 0,is_inherit = 0,show_progress = 0,condition = [{mount_star,3},{mount_stage,10 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(45001) ->
	#achievement_cfg{id = 45001,category = 45,star = 60,next_id = 45002,is_inherit = 1,show_progress = 1,condition = [{mount_name,1}],reward = [{2,0,10},{0,16020002,1}],ways = 0};

get(45002) ->
	#achievement_cfg{id = 45002,category = 45,star = 70,next_id = 45003,is_inherit = 1,show_progress = 1,condition = [{mount_name,4}],reward = [{2,0,15},{0,16020002,2}],ways = 0};

get(45003) ->
	#achievement_cfg{id = 45003,category = 45,star = 80,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{mount_name,7}],reward = [{2,0,20},{0,16020002,3}],ways = 0};

get(46001) ->
	#achievement_cfg{id = 46001,category = 46,star = 40,next_id = 46002,is_inherit = 0,show_progress = 1,condition = [{wing_star,15}],reward = [{2,0,10},{0,18020001,5}],ways = 0};

get(46002) ->
	#achievement_cfg{id = 46002,category = 46,star = 40,next_id = 46003,is_inherit = 0,show_progress = 1,condition = [{wing_star,35}],reward = [{2,0,10},{0,18020001,5}],ways = 0};

get(46003) ->
	#achievement_cfg{id = 46003,category = 46,star = 50,next_id = 46004,is_inherit = 0,show_progress = 1,condition = [{wing_star,55}],reward = [{2,0,15},{0,18020001,5}],ways = 0};

get(46004) ->
	#achievement_cfg{id = 46004,category = 46,star = 50,next_id = 46005,is_inherit = 0,show_progress = 1,condition = [{wing_star,75}],reward = [{2,0,15},{0,18020001,5}],ways = 0};

get(46005) ->
	#achievement_cfg{id = 46005,category = 46,star = 60,next_id = 46006,is_inherit = 0,show_progress = 1,condition = [{wing_star,105}],reward = [{2,0,20},{0,18020001,5}],ways = 0};

get(46006) ->
	#achievement_cfg{id = 46006,category = 46,star = 60,next_id = 46007,is_inherit = 0,show_progress = 1,condition = [{wing_star,135}],reward = [{2,0,20},{0,18020001,5}],ways = 0};

get(46007) ->
	#achievement_cfg{id = 46007,category = 46,star = 70,next_id = 46008,is_inherit = 0,show_progress = 1,condition = [{wing_star,165}],reward = [{2,0,30},{0,18020001,5}],ways = 0};

get(46008) ->
	#achievement_cfg{id = 46008,category = 46,star = 70,next_id = 46009,is_inherit = 0,show_progress = 1,condition = [{wing_star,205}],reward = [{2,0,30},{0,18020001,5}],ways = 0};

get(46009) ->
	#achievement_cfg{id = 46009,category = 46,star = 80,next_id = 46010,is_inherit = 0,show_progress = 1,condition = [{wing_star,305}],reward = [{2,0,30},{0,18020001,5}],ways = 0};

get(46010) ->
	#achievement_cfg{id = 46010,category = 46,star = 90,next_id = 0,is_inherit = 0,show_progress = 1,condition = [{wing_star,405}],reward = [{2,0,30},{0,18020001,5}],ways = 0};

get(47001) ->
	#achievement_cfg{id = 47001,category = 47,star = 60,next_id = 47002,is_inherit = 1,show_progress = 1,condition = [{wing_name,1}],reward = [{2,0,10},{0,18020002,1}],ways = 0};

get(47002) ->
	#achievement_cfg{id = 47002,category = 47,star = 70,next_id = 47003,is_inherit = 1,show_progress = 1,condition = [{wing_name,4}],reward = [{2,0,15},{0,18020002,2}],ways = 0};

get(47003) ->
	#achievement_cfg{id = 47003,category = 47,star = 80,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{wing_name,7}],reward = [{2,0,20},{0,18020002,3}],ways = 0};

get(48001) ->
	#achievement_cfg{id = 48001,category = 48,star = 60,next_id = 48002,is_inherit = 0,show_progress = 0,condition = [{mate_star,3},{mate_stage,2 }],reward = [{2,0,15},{0,16020001,2}],ways = 0};

get(48002) ->
	#achievement_cfg{id = 48002,category = 48,star = 70,next_id = 48003,is_inherit = 0,show_progress = 0,condition = [{mate_star,3},{mate_stage,3 }],reward = [{2,0,20},{0,16020001,2}],ways = 0};

get(48003) ->
	#achievement_cfg{id = 48003,category = 48,star = 80,next_id = 48004,is_inherit = 0,show_progress = 0,condition = [{mate_star,3},{mate_stage,4 }],reward = [{2,0,25},{0,16020001,2}],ways = 0};

get(48004) ->
	#achievement_cfg{id = 48004,category = 48,star = 90,next_id = 48005,is_inherit = 0,show_progress = 0,condition = [{mate_star,3},{mate_stage,5 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(48005) ->
	#achievement_cfg{id = 48005,category = 48,star = 100,next_id = 48006,is_inherit = 0,show_progress = 0,condition = [{mate_star,3},{mate_stage,6 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(48006) ->
	#achievement_cfg{id = 48006,category = 48,star = 100,next_id = 48007,is_inherit = 0,show_progress = 0,condition = [{mate_star,3},{mate_stage,7 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(48007) ->
	#achievement_cfg{id = 48007,category = 48,star = 100,next_id = 48008,is_inherit = 0,show_progress = 0,condition = [{mate_star,3},{mate_stage,8 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(48008) ->
	#achievement_cfg{id = 48008,category = 48,star = 100,next_id = 48009,is_inherit = 0,show_progress = 0,condition = [{mate_star,3},{mate_stage,9 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(48009) ->
	#achievement_cfg{id = 48009,category = 48,star = 100,next_id = 0,is_inherit = 0,show_progress = 0,condition = [{mate_star,3},{mate_stage,10 }],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(49001) ->
	#achievement_cfg{id = 49001,category = 49,star = 60,next_id = 49002,is_inherit = 1,show_progress = 1,condition = [{mate_name,1}],reward = [{2,0,10},{0,16020002,1}],ways = 0};

get(49002) ->
	#achievement_cfg{id = 49002,category = 49,star = 70,next_id = 49003,is_inherit = 1,show_progress = 1,condition = [{mate_name,4}],reward = [{2,0,15},{0,16020002,2}],ways = 0};

get(49003) ->
	#achievement_cfg{id = 49003,category = 49,star = 80,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{mate_name,7}],reward = [{2,0,20},{0,16020002,3}],ways = 0};

get(50001) ->
	#achievement_cfg{id = 50001,category = 50,star = 40,next_id = 50002,is_inherit = 0,show_progress = 1,condition = [{holyorgan_lv,15}],reward = [{2,0,10},{0,20020001,5}],ways = 0};

get(50002) ->
	#achievement_cfg{id = 50002,category = 50,star = 40,next_id = 50003,is_inherit = 0,show_progress = 1,condition = [{holyorgan_lv,35}],reward = [{2,0,10},{0,20020001,5}],ways = 0};

get(50003) ->
	#achievement_cfg{id = 50003,category = 50,star = 50,next_id = 50004,is_inherit = 0,show_progress = 1,condition = [{holyorgan_lv,55}],reward = [{2,0,15},{0,20020001,5}],ways = 0};

get(50004) ->
	#achievement_cfg{id = 50004,category = 50,star = 50,next_id = 50005,is_inherit = 0,show_progress = 1,condition = [{holyorgan_lv,75}],reward = [{2,0,15},{0,20020001,5}],ways = 0};

get(50005) ->
	#achievement_cfg{id = 50005,category = 50,star = 60,next_id = 50006,is_inherit = 0,show_progress = 1,condition = [{holyorgan_lv,105}],reward = [{2,0,20},{0,20020001,5}],ways = 0};

get(50006) ->
	#achievement_cfg{id = 50006,category = 50,star = 60,next_id = 50007,is_inherit = 0,show_progress = 1,condition = [{holyorgan_lv,135}],reward = [{2,0,20},{0,20020001,5}],ways = 0};

get(50007) ->
	#achievement_cfg{id = 50007,category = 50,star = 70,next_id = 50008,is_inherit = 0,show_progress = 1,condition = [{holyorgan_lv,165}],reward = [{2,0,30},{0,20020001,5}],ways = 0};

get(50008) ->
	#achievement_cfg{id = 50008,category = 50,star = 70,next_id = 50009,is_inherit = 0,show_progress = 1,condition = [{holyorgan_lv,205}],reward = [{2,0,30},{0,20020001,5}],ways = 0};

get(50009) ->
	#achievement_cfg{id = 50009,category = 50,star = 80,next_id = 50010,is_inherit = 0,show_progress = 1,condition = [{holyorgan_lv,305}],reward = [{2,0,30},{0,20020001,5}],ways = 0};

get(50010) ->
	#achievement_cfg{id = 50010,category = 50,star = 90,next_id = 0,is_inherit = 0,show_progress = 1,condition = [{holyorgan_lv,405}],reward = [{2,0,30},{0,20020001,5}],ways = 0};

get(51001) ->
	#achievement_cfg{id = 51001,category = 51,star = 50,next_id = 51002,is_inherit = 1,show_progress = 1,condition = [{holyorgan_name,1}],reward = [{2,0,10},{0,20020002,1}],ways = 0};

get(51002) ->
	#achievement_cfg{id = 51002,category = 51,star = 100,next_id = 51003,is_inherit = 1,show_progress = 1,condition = [{holyorgan_name,4}],reward = [{2,0,15},{0,20020002,2}],ways = 0};

get(51003) ->
	#achievement_cfg{id = 51003,category = 51,star = 150,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{holyorgan_name,7}],reward = [{2,0,20},{0,20020002,3}],ways = 0};

get(52001) ->
	#achievement_cfg{id = 52001,category = 52,star = 40,next_id = 52002,is_inherit = 0,show_progress = 1,condition = [{artifact_lv,15}],reward = [{2,0,10},{0,19020001,5}],ways = 0};

get(52002) ->
	#achievement_cfg{id = 52002,category = 52,star = 40,next_id = 52003,is_inherit = 0,show_progress = 1,condition = [{artifact_lv,35}],reward = [{2,0,10},{0,19020001,5}],ways = 0};

get(52003) ->
	#achievement_cfg{id = 52003,category = 52,star = 50,next_id = 52004,is_inherit = 0,show_progress = 1,condition = [{artifact_lv,55}],reward = [{2,0,15},{0,19020001,5}],ways = 0};

get(52004) ->
	#achievement_cfg{id = 52004,category = 52,star = 50,next_id = 52005,is_inherit = 0,show_progress = 1,condition = [{artifact_lv,75}],reward = [{2,0,15},{0,19020001,5}],ways = 0};

get(52005) ->
	#achievement_cfg{id = 52005,category = 52,star = 60,next_id = 52006,is_inherit = 0,show_progress = 1,condition = [{artifact_lv,105}],reward = [{2,0,20},{0,19020001,5}],ways = 0};

get(52006) ->
	#achievement_cfg{id = 52006,category = 52,star = 60,next_id = 52007,is_inherit = 0,show_progress = 1,condition = [{artifact_lv,135}],reward = [{2,0,20},{0,19020001,5}],ways = 0};

get(52007) ->
	#achievement_cfg{id = 52007,category = 52,star = 70,next_id = 52008,is_inherit = 0,show_progress = 1,condition = [{artifact_lv,165}],reward = [{2,0,30},{0,19020001,5}],ways = 0};

get(52008) ->
	#achievement_cfg{id = 52008,category = 52,star = 70,next_id = 52009,is_inherit = 0,show_progress = 1,condition = [{artifact_lv,205}],reward = [{2,0,30},{0,19020001,5}],ways = 0};

get(52009) ->
	#achievement_cfg{id = 52009,category = 52,star = 80,next_id = 52010,is_inherit = 0,show_progress = 1,condition = [{artifact_lv,305}],reward = [{2,0,30},{0,19020001,5}],ways = 0};

get(52010) ->
	#achievement_cfg{id = 52010,category = 52,star = 90,next_id = 0,is_inherit = 0,show_progress = 1,condition = [{artifact_lv,405}],reward = [{2,0,30},{0,19020001,5}],ways = 0};

get(53001) ->
	#achievement_cfg{id = 53001,category = 53,star = 50,next_id = 53002,is_inherit = 1,show_progress = 1,condition = [{artifact_name,1}],reward = [{2,0,10},{0,19020002,1}],ways = 0};

get(53002) ->
	#achievement_cfg{id = 53002,category = 53,star = 100,next_id = 53003,is_inherit = 1,show_progress = 1,condition = [{artifact_name,4}],reward = [{2,0,15},{0,19020002,2}],ways = 0};

get(53003) ->
	#achievement_cfg{id = 53003,category = 53,star = 150,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{artifact_name,7}],reward = [{2,0,20},{0,19020002,3}],ways = 0};

get(58001) ->
	#achievement_cfg{id = 58001,category = 58,star = 30,next_id = 58002,is_inherit = 0,show_progress = 1,condition = [{compose_equip, 5 }, {compose_equip_color, 1},{compose_equip_star, 1},{compose_equip_num, 1}],reward = [{2,0,20},{3,0,200000}],ways = 0};

get(58002) ->
	#achievement_cfg{id = 58002,category = 58,star = 40,next_id = 58003,is_inherit = 0,show_progress = 1,condition = [{compose_equip, 7 }, {compose_equip_color, 1},{compose_equip_star, 1},{compose_equip_num, 1}],reward = [{2,0,30},{3,0,300000}],ways = 0};

get(58003) ->
	#achievement_cfg{id = 58003,category = 58,star = 50,next_id = 58004,is_inherit = 0,show_progress = 1,condition = [{compose_equip, 9 }, {compose_equip_color, 1},{compose_equip_star, 1},{compose_equip_num, 1}],reward = [{2,0,40},{3,0,500000}],ways = 0};

get(58004) ->
	#achievement_cfg{id = 58004,category = 58,star = 60,next_id = 58005,is_inherit = 0,show_progress = 1,condition = [{compose_equip, 11 }, {compose_equip_color, 1},{compose_equip_star, 1},{compose_equip_num, 1}],reward = [{2,0,50},{3,0,800000}],ways = 0};

get(58005) ->
	#achievement_cfg{id = 58005,category = 58,star = 80,next_id = 58006,is_inherit = 0,show_progress = 1,condition = [{compose_equip, 13 }, {compose_equip_color, 1},{compose_equip_star, 1},{compose_equip_num, 1}],reward = [{2,0,50},{3,0,1000000}],ways = 0};

get(58006) ->
	#achievement_cfg{id = 58006,category = 58,star = 100,next_id = 0,is_inherit = 0,show_progress = 1,condition = [{compose_equip, 15 }, {compose_equip_color, 1},{compose_equip_star, 1},{compose_equip_num, 1}],reward = [{2,0,50},{3,0,1000000}],ways = 0};

get(62001) ->
	#achievement_cfg{id = 62001,category = 62,star = 20,next_id = 62002,is_inherit = 0,show_progress = 1,condition = [{wash_stage,1},{equip_wash,1}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(62002) ->
	#achievement_cfg{id = 62002,category = 62,star = 40,next_id = 62003,is_inherit = 0,show_progress = 1,condition = [{wash_stage,3},{equip_wash,1}],reward = [{2,0,20},{0,53020203,1}],ways = 0};

get(62003) ->
	#achievement_cfg{id = 62003,category = 62,star = 60,next_id = 62004,is_inherit = 0,show_progress = 1,condition = [{wash_stage,5},{equip_wash,1}],reward = [{2,0,35},{3,0,500000}],ways = 0};

get(62004) ->
	#achievement_cfg{id = 62004,category = 62,star = 70,next_id = 62005,is_inherit = 0,show_progress = 1,condition = [{wash_stage,7},{equip_wash,1}],reward = [{2,0,50},{3,0,500000}],ways = 0};

get(62005) ->
	#achievement_cfg{id = 62005,category = 62,star = 100,next_id = 62006,is_inherit = 0,show_progress = 1,condition = [{wash_stage,10},{equip_wash,1}],reward = [{2,0,50},{3,0,1000000}],ways = 0};

get(62006) ->
	#achievement_cfg{id = 62006,category = 62,star = 120,next_id = 0,is_inherit = 0,show_progress = 1,condition = [{wash_stage,15},{equip_wash,1}],reward = [{2,0,50},{3,0,1000000}],ways = 0};

get(69001) ->
	#achievement_cfg{id = 69001,category = 69,star = 100,next_id = 0,is_inherit = 0,show_progress = 0,condition = [{wear_bracelet,1}],reward = [{2,0,25},{3,0,1000000}],ways = 0};

get(70001) ->
	#achievement_cfg{id = 70001,category = 70,star = 100,next_id = 0,is_inherit = 0,show_progress = 0,condition = [{wear_ring,1}],reward = [{2,0,25},{3,0,1000000}],ways = 0};

get(71001) ->
	#achievement_cfg{id = 71001,category = 71,star = 40,next_id = 71002,is_inherit = 0,show_progress = 1,condition = [{equip_stage, 1},{equip_color, 4},{equip_star, 1},{equip_num, 1}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(71002) ->
	#achievement_cfg{id = 71002,category = 71,star = 60,next_id = 71003,is_inherit = 0,show_progress = 1,condition = [{equip_stage, 1},{equip_color, 4},{equip_star, 2},{equip_num, 1}],reward = [{2,0,15},{3,0,300000}],ways = 0};

get(71003) ->
	#achievement_cfg{id = 71003,category = 71,star = 200,next_id = 0,is_inherit = 0,show_progress = 1,condition = [{equip_stage, 1},{equip_color, 5},{equip_star, 3},{equip_num, 1}],reward = [{2,0,30},{3,0,400000}],ways = 0};

get(82001) ->
	#achievement_cfg{id = 82001,category = 82,star = 60,next_id = 82002,is_inherit = 0,show_progress = 0,condition = [{immortal_equip_suit,1,1}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(82002) ->
	#achievement_cfg{id = 82002,category = 82,star = 80,next_id = 82003,is_inherit = 0,show_progress = 0,condition = [{immortal_equip_suit,2,1}],reward = [{2,0,20},{0,53020202,1}],ways = 0};

get(82003) ->
	#achievement_cfg{id = 82003,category = 82,star = 100,next_id = 82004,is_inherit = 0,show_progress = 0,condition = [{immortal_equip_suit,3,1}],reward = [{2,0,30},{3,0,400000}],ways = 0};

get(82004) ->
	#achievement_cfg{id = 82004,category = 82,star = 120,next_id = 0,is_inherit = 0,show_progress = 0,condition = [{immortal_equip_suit,4,1}],reward = [{2,0,50},{3,0,600000}],ways = 0};

get(86001) ->
	#achievement_cfg{id = 86001,category = 86,star = 60,next_id = 86002,is_inherit = 0,show_progress = 0,condition = [{immortal_ornament_suit,1,1}],reward = [{2,0,10},{3,0,200000}],ways = 0};

get(86002) ->
	#achievement_cfg{id = 86002,category = 86,star = 80,next_id = 86003,is_inherit = 0,show_progress = 0,condition = [{immortal_ornament_suit,2,1}],reward = [{2,0,20},{3,0,300000}],ways = 0};

get(86003) ->
	#achievement_cfg{id = 86003,category = 86,star = 100,next_id = 86004,is_inherit = 0,show_progress = 0,condition = [{immortal_ornament_suit,3,1}],reward = [{2,0,30},{3,0,400000}],ways = 0};

get(86004) ->
	#achievement_cfg{id = 86004,category = 86,star = 120,next_id = 0,is_inherit = 0,show_progress = 0,condition = [{immortal_ornament_suit,4,1}],reward = [{2,0,50},{3,0,600000}],ways = 0};

get(94001) ->
	#achievement_cfg{id = 94001,category = 94,star = 10,next_id = 94002,is_inherit = 1,show_progress = 1,condition = [{add_friend,1}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(94002) ->
	#achievement_cfg{id = 94002,category = 94,star = 10,next_id = 94003,is_inherit = 1,show_progress = 1,condition = [{add_friend,3}],reward = [{2,0,15},{3,0,150000}],ways = 0};

get(94003) ->
	#achievement_cfg{id = 94003,category = 94,star = 20,next_id = 94004,is_inherit = 1,show_progress = 1,condition = [{add_friend,10}],reward = [{2,0,20},{3,0,200000}],ways = 0};

get(94004) ->
	#achievement_cfg{id = 94004,category = 94,star = 30,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{add_friend,50}],reward = [{2,0,30},{3,0,300000}],ways = 0};

get(95001) ->
	#achievement_cfg{id = 95001,category = 95,star = 10,next_id = 95002,is_inherit = 1,show_progress = 1,condition = [{chat_private,1}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(95002) ->
	#achievement_cfg{id = 95002,category = 95,star = 10,next_id = 95003,is_inherit = 1,show_progress = 1,condition = [{chat_private,10}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(95003) ->
	#achievement_cfg{id = 95003,category = 95,star = 20,next_id = 95004,is_inherit = 1,show_progress = 1,condition = [{chat_private,50}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(95004) ->
	#achievement_cfg{id = 95004,category = 95,star = 30,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{chat_private,100}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(98001) ->
	#achievement_cfg{id = 98001,category = 98,star = 10,next_id = 98002,is_inherit = 1,show_progress = 1,condition = [{cuple_pass,1}],reward = [{2,0,10},{0,16020001,2}],ways = 0};

get(98002) ->
	#achievement_cfg{id = 98002,category = 98,star = 30,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{cuple_pass,7}],reward = [{2,0,10},{0,16020001,2}],ways = 0};

get(100001) ->
	#achievement_cfg{id = 100001,category = 100,star = 10,next_id = 100002,is_inherit = 1,show_progress = 1,condition = [{guild_task,10}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(100002) ->
	#achievement_cfg{id = 100002,category = 100,star = 10,next_id = 100003,is_inherit = 1,show_progress = 1,condition = [{guild_task,40}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(100003) ->
	#achievement_cfg{id = 100003,category = 100,star = 20,next_id = 100004,is_inherit = 1,show_progress = 1,condition = [{guild_task,70}],reward = [{2,0,15},{3,0,200000}],ways = 0};

get(100004) ->
	#achievement_cfg{id = 100004,category = 100,star = 20,next_id = 100005,is_inherit = 1,show_progress = 1,condition = [{guild_task,150}],reward = [{2,0,15},{3,0,200000}],ways = 0};

get(100005) ->
	#achievement_cfg{id = 100005,category = 100,star = 30,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{guild_task,300}],reward = [{2,0,20},{3,0,300000}],ways = 0};

get(101001) ->
	#achievement_cfg{id = 101001,category = 101,star = 20,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{join_guild_fire,10}],reward = [{2,0,10},{0,38064101,1}],ways = 0};

get(102001) ->
	#achievement_cfg{id = 102001,category = 102,star = 20,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{guild_war,10}],reward = [{2,0,10},{0,38064102,1}],ways = 0};

get(103001) ->
	#achievement_cfg{id = 103001,category = 103,star = 20,next_id = 103002,is_inherit = 1,show_progress = 1,condition = [{guild_red_packet,1}],reward = [{2,0,15},{0,18020001,5}],ways = 0};

get(103002) ->
	#achievement_cfg{id = 103002,category = 103,star = 30,next_id = 103003,is_inherit = 1,show_progress = 1,condition = [{guild_red_packet,20}],reward = [{2,0,15},{0,18020001,5}],ways = 0};

get(103003) ->
	#achievement_cfg{id = 103003,category = 103,star = 50,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{guild_red_packet,50}],reward = [{2,0,15},{0,38064103,1}],ways = 0};

get(106001) ->
	#achievement_cfg{id = 106001,category = 106,star = 10,next_id = 106002,is_inherit = 1,show_progress = 1,condition = [{checkin,1}],reward = [{2,0,10},{0,18020001,5}],ways = 0};

get(106002) ->
	#achievement_cfg{id = 106002,category = 106,star = 20,next_id = 106003,is_inherit = 1,show_progress = 1,condition = [{checkin,3}],reward = [{2,0,10},{0,18020001,5}],ways = 0};

get(106003) ->
	#achievement_cfg{id = 106003,category = 106,star = 30,next_id = 106004,is_inherit = 1,show_progress = 1,condition = [{checkin,5}],reward = [{2,0,10},{0,18020001,5}],ways = 0};

get(106004) ->
	#achievement_cfg{id = 106004,category = 106,star = 50,next_id = 106005,is_inherit = 1,show_progress = 1,condition = [{checkin,7}],reward = [{2,0,15},{0,18020001,5}],ways = 0};

get(106005) ->
	#achievement_cfg{id = 106005,category = 106,star = 50,next_id = 106006,is_inherit = 1,show_progress = 1,condition = [{checkin,30}],reward = [{2,0,15},{0,18020001,5}],ways = 0};

get(106006) ->
	#achievement_cfg{id = 106006,category = 106,star = 50,next_id = 106007,is_inherit = 1,show_progress = 1,condition = [{checkin,50}],reward = [{2,0,20},{0,18020001,5}],ways = 0};

get(106007) ->
	#achievement_cfg{id = 106007,category = 106,star = 50,next_id = 106008,is_inherit = 1,show_progress = 1,condition = [{checkin,80}],reward = [{2,0,20},{0,18020001,5}],ways = 0};

get(106008) ->
	#achievement_cfg{id = 106008,category = 106,star = 50,next_id = 106009,is_inherit = 1,show_progress = 1,condition = [{checkin,120}],reward = [{2,0,20},{0,18020001,5}],ways = 0};

get(106009) ->
	#achievement_cfg{id = 106009,category = 106,star = 50,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{checkin,300}],reward = [{2,0,20},{0,18020001,5}],ways = 0};

get(107001) ->
	#achievement_cfg{id = 107001,category = 107,star = 10,next_id = 107002,is_inherit = 1,show_progress = 1,condition = [{bounty,20}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(107002) ->
	#achievement_cfg{id = 107002,category = 107,star = 20,next_id = 107003,is_inherit = 1,show_progress = 1,condition = [{bounty,80}],reward = [{2,0,15},{3,0,200000}],ways = 0};

get(107003) ->
	#achievement_cfg{id = 107003,category = 107,star = 20,next_id = 107004,is_inherit = 1,show_progress = 1,condition = [{bounty,300}],reward = [{2,0,15},{3,0,200000}],ways = 0};

get(108001) ->
	#achievement_cfg{id = 108001,category = 108,star = 70,next_id = 108002,is_inherit = 1,show_progress = 1,condition = [{coin_get,5000000}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(108002) ->
	#achievement_cfg{id = 108002,category = 108,star = 70,next_id = 108003,is_inherit = 1,show_progress = 1,condition = [{coin_get,15000000}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(108003) ->
	#achievement_cfg{id = 108003,category = 108,star = 70,next_id = 108004,is_inherit = 1,show_progress = 1,condition = [{coin_get,30000000}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(108004) ->
	#achievement_cfg{id = 108004,category = 108,star = 70,next_id = 108005,is_inherit = 1,show_progress = 1,condition = [{coin_get,80000000}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(108005) ->
	#achievement_cfg{id = 108005,category = 108,star = 80,next_id = 108006,is_inherit = 1,show_progress = 1,condition = [{coin_get,100000000}],reward = [{0,38064109,1}],ways = 0};

get(108006) ->
	#achievement_cfg{id = 108006,category = 108,star = 80,next_id = 108007,is_inherit = 1,show_progress = 1,condition = [{coin_get,300000000}],reward = [{2,0,15},{3,0,200000}],ways = 0};

get(108007) ->
	#achievement_cfg{id = 108007,category = 108,star = 80,next_id = 108008,is_inherit = 1,show_progress = 1,condition = [{coin_get,500000000}],reward = [{2,0,15},{3,0,200000}],ways = 0};

get(108008) ->
	#achievement_cfg{id = 108008,category = 108,star = 100,next_id = 108009,is_inherit = 1,show_progress = 1,condition = [{coin_get,1000000000}],reward = [{2,0,20},{3,0,200000}],ways = 0};

get(108009) ->
	#achievement_cfg{id = 108009,category = 108,star = 100,next_id = 108010,is_inherit = 1,show_progress = 1,condition = [{coin_get,2000000000}],reward = [{2,0,20},{3,0,200000}],ways = 0};

get(108010) ->
	#achievement_cfg{id = 108010,category = 108,star = 100,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{coin_get,4000000000}],reward = [{2,0,20},{3,0,200000}],ways = 0};

get(109001) ->
	#achievement_cfg{id = 109001,category = 109,star = 50,next_id = 109002,is_inherit = 1,show_progress = 1,condition = [{sell_sell,100}],reward = [{2,0,20},{0,19020001,5}],ways = 0};

get(109002) ->
	#achievement_cfg{id = 109002,category = 109,star = 50,next_id = 109003,is_inherit = 1,show_progress = 1,condition = [{sell_sell,300}],reward = [{2,0,20},{0,19020001,5}],ways = 0};

get(109003) ->
	#achievement_cfg{id = 109003,category = 109,star = 60,next_id = 109004,is_inherit = 1,show_progress = 1,condition = [{sell_sell,500}],reward = [{2,0,30},{0,19020001,5}],ways = 0};

get(109004) ->
	#achievement_cfg{id = 109004,category = 109,star = 60,next_id = 109005,is_inherit = 1,show_progress = 1,condition = [{sell_sell,1000}],reward = [{2,0,30},{0,38064104,1}],ways = 0};

get(109005) ->
	#achievement_cfg{id = 109005,category = 109,star = 80,next_id = 109006,is_inherit = 1,show_progress = 1,condition = [{sell_sell,3000}],reward = [{2,0,40},{0,19020001,5}],ways = 0};

get(109006) ->
	#achievement_cfg{id = 109006,category = 109,star = 80,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{sell_sell,5000}],reward = [{2,0,40},{0,19020001,5}],ways = 0};

get(110001) ->
	#achievement_cfg{id = 110001,category = 110,star = 50,next_id = 110002,is_inherit = 1,show_progress = 1,condition = [{sell_cost,100}],reward = [{2,0,20},{0,18020001,5}],ways = 0};

get(110002) ->
	#achievement_cfg{id = 110002,category = 110,star = 50,next_id = 110003,is_inherit = 1,show_progress = 1,condition = [{sell_cost,300}],reward = [{2,0,20},{0,18020001,5}],ways = 0};

get(110003) ->
	#achievement_cfg{id = 110003,category = 110,star = 60,next_id = 110004,is_inherit = 1,show_progress = 1,condition = [{sell_cost,500}],reward = [{2,0,30},{0,18020001,5}],ways = 0};

get(110004) ->
	#achievement_cfg{id = 110004,category = 110,star = 60,next_id = 110005,is_inherit = 1,show_progress = 1,condition = [{sell_cost,1000}],reward = [{2,0,30},{0,38064105,1}],ways = 0};

get(110005) ->
	#achievement_cfg{id = 110005,category = 110,star = 80,next_id = 110006,is_inherit = 1,show_progress = 1,condition = [{sell_cost,5000}],reward = [{2,0,40},{0,18020001,5}],ways = 0};

get(110006) ->
	#achievement_cfg{id = 110006,category = 110,star = 80,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{sell_cost,15000}],reward = [{2,0,40},{0,18020001,5}],ways = 0};

get(116001) ->
	#achievement_cfg{id = 116001,category = 116,star = 10,next_id = 116002,is_inherit = 1,show_progress = 1,condition = [{nine_kill,10}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(116002) ->
	#achievement_cfg{id = 116002,category = 116,star = 10,next_id = 116003,is_inherit = 1,show_progress = 1,condition = [{nine_kill,30}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(116003) ->
	#achievement_cfg{id = 116003,category = 116,star = 20,next_id = 116004,is_inherit = 1,show_progress = 1,condition = [{nine_kill,50}],reward = [{2,0,15},{3,0,200000}],ways = 0};

get(116004) ->
	#achievement_cfg{id = 116004,category = 116,star = 20,next_id = 116005,is_inherit = 1,show_progress = 1,condition = [{nine_kill,100}],reward = [{2,0,15},{3,0,200000}],ways = 0};

get(116005) ->
	#achievement_cfg{id = 116005,category = 116,star = 20,next_id = 116006,is_inherit = 1,show_progress = 1,condition = [{nine_kill,200}],reward = [{2,0,15},{3,0,200000}],ways = 0};

get(116006) ->
	#achievement_cfg{id = 116006,category = 116,star = 30,next_id = 116007,is_inherit = 1,show_progress = 1,condition = [{nine_kill,500}],reward = [{2,0,20},{3,0,300000}],ways = 0};

get(116007) ->
	#achievement_cfg{id = 116007,category = 116,star = 30,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{nine_kill,1000}],reward = [{2,0,20},{3,0,300000}],ways = 0};

get(117001) ->
	#achievement_cfg{id = 117001,category = 117,star = 10,next_id = 117002,is_inherit = 0,show_progress = 0,condition = [{top_pk,1}],reward = [{2,0,10},{3,0,100000}],ways = 0};

get(117002) ->
	#achievement_cfg{id = 117002,category = 117,star = 20,next_id = 117003,is_inherit = 0,show_progress = 0,condition = [{top_pk,2}],reward = [{2,0,15},{3,0,100000}],ways = 0};

get(117003) ->
	#achievement_cfg{id = 117003,category = 117,star = 40,next_id = 117004,is_inherit = 0,show_progress = 0,condition = [{top_pk,3}],reward = [{2,0,20},{3,0,200000}],ways = 0};

get(117004) ->
	#achievement_cfg{id = 117004,category = 117,star = 60,next_id = 117005,is_inherit = 0,show_progress = 0,condition = [{top_pk,4}],reward = [{2,0,20},{3,0,200000}],ways = 0};

get(117005) ->
	#achievement_cfg{id = 117005,category = 117,star = 100,next_id = 0,is_inherit = 0,show_progress = 0,condition = [{top_pk,5}],reward = [{2,0,30},{3,0,300000}],ways = 0};

get(122001) ->
	#achievement_cfg{id = 122001,category = 122,star = 20,next_id = 122002,is_inherit = 1,show_progress = 1,condition = [{dungeon_exp,2}],reward = [{2,0,10},{0,16020001,2}],ways = 0};

get(122002) ->
	#achievement_cfg{id = 122002,category = 122,star = 50,next_id = 122003,is_inherit = 1,show_progress = 1,condition = [{dungeon_exp,15}],reward = [{2,0,15},{0,16020001,2}],ways = 0};

get(122003) ->
	#achievement_cfg{id = 122003,category = 122,star = 80,next_id = 122004,is_inherit = 1,show_progress = 1,condition = [{dungeon_exp,50}],reward = [{2,0,20},{0,16020001,2}],ways = 0};

get(122004) ->
	#achievement_cfg{id = 122004,category = 122,star = 100,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{dungeon_exp,100}],reward = [{2,0,30},{0,16020001,2}],ways = 0};

get(124001) ->
	#achievement_cfg{id = 124001,category = 124,star = 20,next_id = 124002,is_inherit = 0,show_progress = 1,condition = [{dungeon_rune,5}],reward = [{2,0,10},{0,32010188,2}],ways = 0};

get(124002) ->
	#achievement_cfg{id = 124002,category = 124,star = 30,next_id = 124003,is_inherit = 0,show_progress = 1,condition = [{dungeon_rune,10}],reward = [{2,0,15},{0,32010188,2}],ways = 0};

get(124003) ->
	#achievement_cfg{id = 124003,category = 124,star = 40,next_id = 124004,is_inherit = 0,show_progress = 1,condition = [{dungeon_rune,20}],reward = [{2,0,20},{0,32010188,4}],ways = 0};

get(124004) ->
	#achievement_cfg{id = 124004,category = 124,star = 50,next_id = 124005,is_inherit = 0,show_progress = 1,condition = [{dungeon_rune,30}],reward = [{2,0,20},{0,32010188,6}],ways = 0};

get(124005) ->
	#achievement_cfg{id = 124005,category = 124,star = 80,next_id = 0,is_inherit = 0,show_progress = 1,condition = [{dungeon_rune,200}],reward = [{2,0,30},{0,32010188,10}],ways = 0};

get(127001) ->
	#achievement_cfg{id = 127001,category = 127,star = 20,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{outside_num,3}],reward = [{2,0,10},{0,18020002,1}],ways = 0};

get(128001) ->
	#achievement_cfg{id = 128001,category = 128,star = 20,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{dungeon_vip_perboss,3}],reward = [{2,0,10},{0,18020002,1}],ways = 0};

get(130001) ->
	#achievement_cfg{id = 130001,category = 130,star = 20,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{forbidden_num,3}],reward = [{2,0,10},{0,18020002,1}],ways = 0};

get(131001) ->
	#achievement_cfg{id = 131001,category = 131,star = 20,next_id = 131002,is_inherit = 1,show_progress = 1,condition = [{decoration_num, 3}],reward = [{0,55014101,1},{0,38040018,20}],ways = 0};

get(131002) ->
	#achievement_cfg{id = 131002,category = 131,star = 30,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{decoration_num, 10}],reward = [{0,55024101,1},{0,38040019,1}],ways = 0};

get(133001) ->
	#achievement_cfg{id = 133001,category = 133,star = 30,next_id = 133002,is_inherit = 1,show_progress = 1,condition = [{kill_player_num,1}],reward = [{2,0,30},{0,38064106,1}],ways = 0};

get(133002) ->
	#achievement_cfg{id = 133002,category = 133,star = 30,next_id = 133003,is_inherit = 1,show_progress = 1,condition = [{kill_player_num,10}],reward = [{2,0,30},{3,0,100000}],ways = 0};

get(133003) ->
	#achievement_cfg{id = 133003,category = 133,star = 50,next_id = 133004,is_inherit = 1,show_progress = 1,condition = [{kill_player_num,50}],reward = [{2,0,30},{3,0,200000}],ways = 0};

get(133004) ->
	#achievement_cfg{id = 133004,category = 133,star = 80,next_id = 133005,is_inherit = 1,show_progress = 1,condition = [{kill_player_num,150}],reward = [{2,0,30},{3,0,300000}],ways = 0};

get(133005) ->
	#achievement_cfg{id = 133005,category = 133,star = 120,next_id = 0,is_inherit = 1,show_progress = 1,condition = [{kill_player_num,500}],reward = [{2,0,30},{0,38064107,1}],ways = 0};

get(_Id) ->
	[].

get_all_achievement_ids() ->
[1,2,3,4,5,6,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,3001,3002,3003,3004,3005,3006,3007,3008,3009,3010,3011,3012,3013,3014,4001,4002,4003,4004,4005,4006,4007,7001,7002,7003,7004,7005,7006,7007,7008,7009,13001,13002,13003,13004,13005,17001,17002,17003,17004,17005,17006,19001,19002,19003,19004,19005,39001,39002,44001,44002,44003,44004,44005,44006,44007,44008,44009,45001,45002,45003,46001,46002,46003,46004,46005,46006,46007,46008,46009,46010,47001,47002,47003,48001,48002,48003,48004,48005,48006,48007,48008,48009,49001,49002,49003,50001,50002,50003,50004,50005,50006,50007,50008,50009,50010,51001,51002,51003,52001,52002,52003,52004,52005,52006,52007,52008,52009,52010,53001,53002,53003,58001,58002,58003,58004,58005,58006,62001,62002,62003,62004,62005,62006,69001,70001,71001,71002,71003,82001,82002,82003,82004,86001,86002,86003,86004,94001,94002,94003,94004,95001,95002,95003,95004,98001,98002,100001,100002,100003,100004,100005,101001,102001,103001,103002,103003,106001,106002,106003,106004,106005,106006,106007,106008,106009,107001,107002,107003,108001,108002,108003,108004,108005,108006,108007,108008,108009,108010,109001,109002,109003,109004,109005,109006,110001,110002,110003,110004,110005,110006,116001,116002,116003,116004,116005,116006,116007,117001,117002,117003,117004,117005,122001,122002,122003,122004,124001,124002,124003,124004,124005,127001,128001,130001,131001,131002,133001,133002,133003,133004,133005].


get_ids(1) ->
[1,2,3,4,5,6];


get_ids(2) ->
[2001,2002,2003,2004,2005,2006,2007,2008,2009,2010];


get_ids(3) ->
[3001,3002,3003,3004,3005,3006,3007,3008,3009,3010,3011,3012,3013,3014];


get_ids(4) ->
[4001,4002,4003,4004,4005,4006,4007];


get_ids(7) ->
[7001,7002,7003,7004,7005,7006,7007,7008,7009];


get_ids(13) ->
[13001,13002,13003,13004,13005];


get_ids(17) ->
[17001,17002,17003,17004,17005,17006];


get_ids(19) ->
[19001,19002,19003,19004,19005];


get_ids(39) ->
[39001,39002];


get_ids(44) ->
[44001,44002,44003,44004,44005,44006,44007,44008,44009];


get_ids(45) ->
[45001,45002,45003];


get_ids(46) ->
[46001,46002,46003,46004,46005,46006,46007,46008,46009,46010];


get_ids(47) ->
[47001,47002,47003];


get_ids(48) ->
[48001,48002,48003,48004,48005,48006,48007,48008,48009];


get_ids(49) ->
[49001,49002,49003];


get_ids(50) ->
[50001,50002,50003,50004,50005,50006,50007,50008,50009,50010];


get_ids(51) ->
[51001,51002,51003];


get_ids(52) ->
[52001,52002,52003,52004,52005,52006,52007,52008,52009,52010];


get_ids(53) ->
[53001,53002,53003];


get_ids(58) ->
[58001,58002,58003,58004,58005,58006];


get_ids(62) ->
[62001,62002,62003,62004,62005,62006];


get_ids(69) ->
[69001];


get_ids(70) ->
[70001];


get_ids(71) ->
[71001,71002,71003];


get_ids(82) ->
[82001,82002,82003,82004];


get_ids(86) ->
[86001,86002,86003,86004];


get_ids(94) ->
[94001,94002,94003,94004];


get_ids(95) ->
[95001,95002,95003,95004];


get_ids(98) ->
[98001,98002];


get_ids(100) ->
[100001,100002,100003,100004,100005];


get_ids(101) ->
[101001];


get_ids(102) ->
[102001];


get_ids(103) ->
[103001,103002,103003];


get_ids(106) ->
[106001,106002,106003,106004,106005,106006,106007,106008,106009];


get_ids(107) ->
[107001,107002,107003];


get_ids(108) ->
[108001,108002,108003,108004,108005,108006,108007,108008,108009,108010];


get_ids(109) ->
[109001,109002,109003,109004,109005,109006];


get_ids(110) ->
[110001,110002,110003,110004,110005,110006];


get_ids(116) ->
[116001,116002,116003,116004,116005,116006,116007];


get_ids(117) ->
[117001,117002,117003,117004,117005];


get_ids(122) ->
[122001,122002,122003,122004];


get_ids(124) ->
[124001,124002,124003,124004,124005];


get_ids(127) ->
[127001];


get_ids(128) ->
[128001];


get_ids(130) ->
[130001];


get_ids(131) ->
[131001,131002];


get_ids(133) ->
[133001,133002,133003,133004,133005];

get_ids(_Category) ->
	[].

get_star_reward(1) ->
	#star_reward_cfg{stage = 1,star = 100,reward = [{1,11},{2,220},{3,6},{4,6}]};

get_star_reward(2) ->
	#star_reward_cfg{stage = 2,star = 100,reward = [{1,15},{2,300},{3,8},{4,8}]};

get_star_reward(3) ->
	#star_reward_cfg{stage = 3,star = 100,reward = [{1,21},{2,420},{3,11},{4,11}]};

get_star_reward(4) ->
	#star_reward_cfg{stage = 4,star = 100,reward = [{1,27},{2,540},{3,14},{4,14}]};

get_star_reward(5) ->
	#star_reward_cfg{stage = 5,star = 100,reward = [{1,34},{2,680},{3,17},{4,17}]};

get_star_reward(6) ->
	#star_reward_cfg{stage = 6,star = 100,reward = [{1,42},{2,840},{3,21},{4,21}]};

get_star_reward(7) ->
	#star_reward_cfg{stage = 7,star = 100,reward = [{1,50},{2,1000},{3,25},{4,25}]};

get_star_reward(8) ->
	#star_reward_cfg{stage = 8,star = 100,reward = [{1,59},{2,1180},{3,30},{4,30}]};

get_star_reward(9) ->
	#star_reward_cfg{stage = 9,star = 100,reward = [{1,68},{2,1360},{3,34},{4,34}]};

get_star_reward(10) ->
	#star_reward_cfg{stage = 10,star = 100,reward = [{1,78},{2,1560},{3,39},{4,39}]};

get_star_reward(11) ->
	#star_reward_cfg{stage = 11,star = 100,reward = [{1,89},{2,1780},{3,45},{4,45}]};

get_star_reward(12) ->
	#star_reward_cfg{stage = 12,star = 100,reward = [{1,100},{2,2000},{3,50},{4,50}]};

get_star_reward(13) ->
	#star_reward_cfg{stage = 13,star = 100,reward = [{1,111},{2,2220},{3,56},{4,56}]};

get_star_reward(14) ->
	#star_reward_cfg{stage = 14,star = 100,reward = [{1,124},{2,2480},{3,62},{4,62}]};

get_star_reward(15) ->
	#star_reward_cfg{stage = 15,star = 100,reward = [{1,136},{2,2720},{3,68},{4,68}]};

get_star_reward(16) ->
	#star_reward_cfg{stage = 16,star = 100,reward = [{1,149},{2,2980},{3,75},{4,75}]};

get_star_reward(17) ->
	#star_reward_cfg{stage = 17,star = 100,reward = [{1,163},{2,3260},{3,82},{4,82}]};

get_star_reward(18) ->
	#star_reward_cfg{stage = 18,star = 100,reward = [{1,177},{2,3540},{3,89},{4,89}]};

get_star_reward(19) ->
	#star_reward_cfg{stage = 19,star = 100,reward = [{1,191},{2,3820},{3,96},{4,96}]};

get_star_reward(20) ->
	#star_reward_cfg{stage = 20,star = 100,reward = [{1,207},{2,4140},{3,104},{4,104}]};

get_star_reward(21) ->
	#star_reward_cfg{stage = 21,star = 100,reward = [{1,222},{2,4440},{3,111},{4,111}]};

get_star_reward(22) ->
	#star_reward_cfg{stage = 22,star = 100,reward = [{1,238},{2,4760},{3,119},{4,119}]};

get_star_reward(23) ->
	#star_reward_cfg{stage = 23,star = 100,reward = [{1,254},{2,5080},{3,127},{4,127}]};

get_star_reward(24) ->
	#star_reward_cfg{stage = 24,star = 100,reward = [{1,271},{2,5420},{3,136},{4,136}]};

get_star_reward(25) ->
	#star_reward_cfg{stage = 25,star = 100,reward = [{1,289},{2,5780},{3,145},{4,145}]};

get_star_reward(26) ->
	#star_reward_cfg{stage = 26,star = 100,reward = [{1,306},{2,6120},{3,153},{4,153}]};

get_star_reward(27) ->
	#star_reward_cfg{stage = 27,star = 100,reward = [{1,324},{2,6480},{3,162},{4,162}]};

get_star_reward(28) ->
	#star_reward_cfg{stage = 28,star = 100,reward = [{1,343},{2,6860},{3,172},{4,172}]};

get_star_reward(29) ->
	#star_reward_cfg{stage = 29,star = 100,reward = [{1,362},{2,7240},{3,181},{4,181}]};

get_star_reward(30) ->
	#star_reward_cfg{stage = 30,star = 100,reward = [{1,381},{2,7620},{3,191},{4,191}]};

get_star_reward(31) ->
	#star_reward_cfg{stage = 31,star = 100,reward = [{1,401},{2,8020},{3,201},{4,201}]};

get_star_reward(32) ->
	#star_reward_cfg{stage = 32,star = 100,reward = [{1,422},{2,8440},{3,211},{4,211}]};

get_star_reward(33) ->
	#star_reward_cfg{stage = 33,star = 100,reward = [{1,442},{2,8840},{3,221},{4,221}]};

get_star_reward(34) ->
	#star_reward_cfg{stage = 34,star = 100,reward = [{1,463},{2,9260},{3,232},{4,232}]};

get_star_reward(35) ->
	#star_reward_cfg{stage = 35,star = 100,reward = [{1,485},{2,9700},{3,243},{4,243}]};

get_star_reward(36) ->
	#star_reward_cfg{stage = 36,star = 100,reward = [{1,507},{2,10140},{3,254},{4,254}]};

get_star_reward(37) ->
	#star_reward_cfg{stage = 37,star = 100,reward = [{1,529},{2,10580},{3,265},{4,265}]};

get_star_reward(38) ->
	#star_reward_cfg{stage = 38,star = 100,reward = [{1,552},{2,11040},{3,276},{4,276}]};

get_star_reward(39) ->
	#star_reward_cfg{stage = 39,star = 100,reward = [{1,575},{2,11500},{3,288},{4,288}]};

get_star_reward(40) ->
	#star_reward_cfg{stage = 40,star = 100,reward = [{1,598},{2,11960},{3,299},{4,299}]};

get_star_reward(41) ->
	#star_reward_cfg{stage = 41,star = 100,reward = [{1,622},{2,12440},{3,311},{4,311}]};

get_star_reward(42) ->
	#star_reward_cfg{stage = 42,star = 100,reward = [{1,646},{2,12920},{3,323},{4,323}]};

get_star_reward(43) ->
	#star_reward_cfg{stage = 43,star = 100,reward = [{1,671},{2,13420},{3,336},{4,336}]};

get_star_reward(44) ->
	#star_reward_cfg{stage = 44,star = 100,reward = [{1,696},{2,13920},{3,348},{4,348}]};

get_star_reward(45) ->
	#star_reward_cfg{stage = 45,star = 100,reward = [{1,721},{2,14420},{3,361},{4,361}]};

get_star_reward(46) ->
	#star_reward_cfg{stage = 46,star = 100,reward = [{1,747},{2,14940},{3,374},{4,374}]};

get_star_reward(47) ->
	#star_reward_cfg{stage = 47,star = 100,reward = [{1,773},{2,15460},{3,387},{4,387}]};

get_star_reward(48) ->
	#star_reward_cfg{stage = 48,star = 100,reward = [{1,800},{2,16000},{3,400},{4,400}]};

get_star_reward(49) ->
	#star_reward_cfg{stage = 49,star = 100,reward = [{1,826},{2,16520},{3,413},{4,413}]};

get_star_reward(50) ->
	#star_reward_cfg{stage = 50,star = 100,reward = [{1,854},{2,17080},{3,427},{4,427}]};

get_star_reward(51) ->
	#star_reward_cfg{stage = 51,star = 100,reward = [{1,881},{2,17620},{3,441},{4,441}]};

get_star_reward(52) ->
	#star_reward_cfg{stage = 52,star = 100,reward = [{1,909},{2,18180},{3,455},{4,455}]};

get_star_reward(53) ->
	#star_reward_cfg{stage = 53,star = 100,reward = [{1,937},{2,18740},{3,469},{4,469}]};

get_star_reward(54) ->
	#star_reward_cfg{stage = 54,star = 100,reward = [{1,966},{2,19320},{3,483},{4,483}]};

get_star_reward(55) ->
	#star_reward_cfg{stage = 55,star = 100,reward = [{1,995},{2,19900},{3,498},{4,498}]};

get_star_reward(56) ->
	#star_reward_cfg{stage = 56,star = 100,reward = [{1,1024},{2,20480},{3,512},{4,512}]};

get_star_reward(57) ->
	#star_reward_cfg{stage = 57,star = 100,reward = [{1,1054},{2,21080},{3,527},{4,527}]};

get_star_reward(58) ->
	#star_reward_cfg{stage = 58,star = 100,reward = [{1,1084},{2,21680},{3,542},{4,542}]};

get_star_reward(59) ->
	#star_reward_cfg{stage = 59,star = 100,reward = [{1,1114},{2,22280},{3,557},{4,557}]};

get_star_reward(60) ->
	#star_reward_cfg{stage = 60,star = 100,reward = [{1,1145},{2,22900},{3,573},{4,573}]};

get_star_reward(61) ->
	#star_reward_cfg{stage = 61,star = 100,reward = [{1,1176},{2,23520},{3,588},{4,588}]};

get_star_reward(62) ->
	#star_reward_cfg{stage = 62,star = 100,reward = [{1,1208},{2,24160},{3,604},{4,604}]};

get_star_reward(63) ->
	#star_reward_cfg{stage = 63,star = 100,reward = [{1,1239},{2,24780},{3,620},{4,620}]};

get_star_reward(64) ->
	#star_reward_cfg{stage = 64,star = 100,reward = [{1,1272},{2,25440},{3,636},{4,636}]};

get_star_reward(65) ->
	#star_reward_cfg{stage = 65,star = 100,reward = [{1,1304},{2,26080},{3,652},{4,652}]};

get_star_reward(66) ->
	#star_reward_cfg{stage = 66,star = 100,reward = [{1,1337},{2,26740},{3,669},{4,669}]};

get_star_reward(67) ->
	#star_reward_cfg{stage = 67,star = 100,reward = [{1,1370},{2,27400},{3,685},{4,685}]};

get_star_reward(68) ->
	#star_reward_cfg{stage = 68,star = 100,reward = [{1,1403},{2,28060},{3,702},{4,702}]};

get_star_reward(69) ->
	#star_reward_cfg{stage = 69,star = 100,reward = [{1,1437},{2,28740},{3,719},{4,719}]};

get_star_reward(70) ->
	#star_reward_cfg{stage = 70,star = 100,reward = [{1,1471},{2,29420},{3,736},{4,736}]};

get_star_reward(71) ->
	#star_reward_cfg{stage = 71,star = 100,reward = [{1,1506},{2,30120},{3,753},{4,753}]};

get_star_reward(72) ->
	#star_reward_cfg{stage = 72,star = 100,reward = [{1,1540},{2,30800},{3,770},{4,770}]};

get_star_reward(73) ->
	#star_reward_cfg{stage = 73,star = 100,reward = [{1,1575},{2,31500},{3,788},{4,788}]};

get_star_reward(74) ->
	#star_reward_cfg{stage = 74,star = 100,reward = [{1,1611},{2,32220},{3,806},{4,806}]};

get_star_reward(75) ->
	#star_reward_cfg{stage = 75,star = 100,reward = [{1,1646},{2,32920},{3,823},{4,823}]};

get_star_reward(76) ->
	#star_reward_cfg{stage = 76,star = 100,reward = [{1,1683},{2,33660},{3,842},{4,842}]};

get_star_reward(77) ->
	#star_reward_cfg{stage = 77,star = 100,reward = [{1,1719},{2,34380},{3,860},{4,860}]};

get_star_reward(78) ->
	#star_reward_cfg{stage = 78,star = 100,reward = [{1,1756},{2,35120},{3,878},{4,878}]};

get_star_reward(79) ->
	#star_reward_cfg{stage = 79,star = 100,reward = [{1,1793},{2,35860},{3,897},{4,897}]};

get_star_reward(80) ->
	#star_reward_cfg{stage = 80,star = 100,reward = [{1,1830},{2,36600},{3,915},{4,915}]};

get_star_reward(81) ->
	#star_reward_cfg{stage = 81,star = 100,reward = [{1,1868},{2,37360},{3,934},{4,934}]};

get_star_reward(82) ->
	#star_reward_cfg{stage = 82,star = 100,reward = [{1,1906},{2,38120},{3,953},{4,953}]};

get_star_reward(83) ->
	#star_reward_cfg{stage = 83,star = 100,reward = [{1,1944},{2,38880},{3,972},{4,972}]};

get_star_reward(84) ->
	#star_reward_cfg{stage = 84,star = 100,reward = [{1,1982},{2,39640},{3,991},{4,991}]};

get_star_reward(85) ->
	#star_reward_cfg{stage = 85,star = 100,reward = [{1,2021},{2,40420},{3,1011},{4,1011}]};

get_star_reward(86) ->
	#star_reward_cfg{stage = 86,star = 100,reward = [{1,2060},{2,41200},{3,1030},{4,1030}]};

get_star_reward(87) ->
	#star_reward_cfg{stage = 87,star = 100,reward = [{1,2100},{2,42000},{3,1050},{4,1050}]};

get_star_reward(88) ->
	#star_reward_cfg{stage = 88,star = 100,reward = [{1,2140},{2,42800},{3,1070},{4,1070}]};

get_star_reward(89) ->
	#star_reward_cfg{stage = 89,star = 100,reward = [{1,2180},{2,43600},{3,1090},{4,1090}]};

get_star_reward(90) ->
	#star_reward_cfg{stage = 90,star = 100,reward = [{1,2220},{2,44400},{3,1110},{4,1110}]};

get_star_reward(91) ->
	#star_reward_cfg{stage = 91,star = 100,reward = [{1,2261},{2,45220},{3,1131},{4,1131}]};

get_star_reward(92) ->
	#star_reward_cfg{stage = 92,star = 100,reward = [{1,2302},{2,46040},{3,1151},{4,1151}]};

get_star_reward(93) ->
	#star_reward_cfg{stage = 93,star = 100,reward = [{1,2343},{2,46860},{3,1172},{4,1172}]};

get_star_reward(94) ->
	#star_reward_cfg{stage = 94,star = 100,reward = [{1,2385},{2,47700},{3,1193},{4,1193}]};

get_star_reward(95) ->
	#star_reward_cfg{stage = 95,star = 100,reward = [{1,2427},{2,48540},{3,1214},{4,1214}]};

get_star_reward(96) ->
	#star_reward_cfg{stage = 96,star = 100,reward = [{1,2469},{2,49380},{3,1235},{4,1235}]};

get_star_reward(97) ->
	#star_reward_cfg{stage = 97,star = 100,reward = [{1,2512},{2,50240},{3,1256},{4,1256}]};

get_star_reward(98) ->
	#star_reward_cfg{stage = 98,star = 100,reward = [{1,2555},{2,51100},{3,1278},{4,1278}]};

get_star_reward(99) ->
	#star_reward_cfg{stage = 99,star = 100,reward = [{1,2598},{2,51960},{3,1299},{4,1299}]};

get_star_reward(100) ->
	#star_reward_cfg{stage = 100,star = 100,reward = [{1,2641},{2,52820},{3,1321},{4,1321}]};

get_star_reward(101) ->
	#star_reward_cfg{stage = 101,star = 100,reward = [{1,2685},{2,53700},{3,1343},{4,1343}]};

get_star_reward(102) ->
	#star_reward_cfg{stage = 102,star = 100,reward = [{1,2729},{2,54580},{3,1365},{4,1365}]};

get_star_reward(103) ->
	#star_reward_cfg{stage = 103,star = 100,reward = [{1,2773},{2,55460},{3,1387},{4,1387}]};

get_star_reward(104) ->
	#star_reward_cfg{stage = 104,star = 100,reward = [{1,2818},{2,56360},{3,1409},{4,1409}]};

get_star_reward(105) ->
	#star_reward_cfg{stage = 105,star = 100,reward = [{1,2863},{2,57260},{3,1432},{4,1432}]};

get_star_reward(106) ->
	#star_reward_cfg{stage = 106,star = 100,reward = [{1,2908},{2,58160},{3,1454},{4,1454}]};

get_star_reward(107) ->
	#star_reward_cfg{stage = 107,star = 100,reward = [{1,2954},{2,59080},{3,1477},{4,1477}]};

get_star_reward(108) ->
	#star_reward_cfg{stage = 108,star = 100,reward = [{1,3000},{2,60000},{3,1500},{4,1500}]};

get_star_reward(109) ->
	#star_reward_cfg{stage = 109,star = 100,reward = [{1,3046},{2,60920},{3,1523},{4,1523}]};

get_star_reward(110) ->
	#star_reward_cfg{stage = 110,star = 100,reward = [{1,3092},{2,61840},{3,1546},{4,1546}]};

get_star_reward(111) ->
	#star_reward_cfg{stage = 111,star = 100,reward = [{1,3139},{2,62780},{3,1570},{4,1570}]};

get_star_reward(112) ->
	#star_reward_cfg{stage = 112,star = 100,reward = [{1,3186},{2,63720},{3,1593},{4,1593}]};

get_star_reward(113) ->
	#star_reward_cfg{stage = 113,star = 100,reward = [{1,3233},{2,64660},{3,1617},{4,1617}]};

get_star_reward(114) ->
	#star_reward_cfg{stage = 114,star = 100,reward = [{1,3280},{2,65600},{3,1640},{4,1640}]};

get_star_reward(115) ->
	#star_reward_cfg{stage = 115,star = 100,reward = [{1,3328},{2,66560},{3,1664},{4,1664}]};

get_star_reward(116) ->
	#star_reward_cfg{stage = 116,star = 100,reward = [{1,3376},{2,67520},{3,1688},{4,1688}]};

get_star_reward(117) ->
	#star_reward_cfg{stage = 117,star = 100,reward = [{1,3425},{2,68500},{3,1713},{4,1713}]};

get_star_reward(118) ->
	#star_reward_cfg{stage = 118,star = 100,reward = [{1,3473},{2,69460},{3,1737},{4,1737}]};

get_star_reward(119) ->
	#star_reward_cfg{stage = 119,star = 100,reward = [{1,3522},{2,70440},{3,1761},{4,1761}]};

get_star_reward(120) ->
	#star_reward_cfg{stage = 120,star = 100,reward = [{1,3571},{2,71420},{3,1786},{4,1786}]};

get_star_reward(121) ->
	#star_reward_cfg{stage = 121,star = 100,reward = [{1,3621},{2,72420},{3,1811},{4,1811}]};

get_star_reward(122) ->
	#star_reward_cfg{stage = 122,star = 100,reward = [{1,3671},{2,73420},{3,1836},{4,1836}]};

get_star_reward(123) ->
	#star_reward_cfg{stage = 123,star = 100,reward = [{1,3721},{2,74420},{3,1861},{4,1861}]};

get_star_reward(124) ->
	#star_reward_cfg{stage = 124,star = 100,reward = [{1,3771},{2,75420},{3,1886},{4,1886}]};

get_star_reward(125) ->
	#star_reward_cfg{stage = 125,star = 100,reward = [{1,3822},{2,76440},{3,1911},{4,1911}]};

get_star_reward(126) ->
	#star_reward_cfg{stage = 126,star = 100,reward = [{1,3873},{2,77460},{3,1937},{4,1937}]};

get_star_reward(127) ->
	#star_reward_cfg{stage = 127,star = 100,reward = [{1,3924},{2,78480},{3,1962},{4,1962}]};

get_star_reward(128) ->
	#star_reward_cfg{stage = 128,star = 100,reward = [{1,3975},{2,79500},{3,1988},{4,1988}]};

get_star_reward(129) ->
	#star_reward_cfg{stage = 129,star = 100,reward = [{1,4027},{2,80540},{3,2014},{4,2014}]};

get_star_reward(130) ->
	#star_reward_cfg{stage = 130,star = 100,reward = [{1,4079},{2,81580},{3,2040},{4,2040}]};

get_star_reward(131) ->
	#star_reward_cfg{stage = 131,star = 100,reward = [{1,4131},{2,82620},{3,2066},{4,2066}]};

get_star_reward(132) ->
	#star_reward_cfg{stage = 132,star = 100,reward = [{1,4184},{2,83680},{3,2092},{4,2092}]};

get_star_reward(133) ->
	#star_reward_cfg{stage = 133,star = 100,reward = [{1,4237},{2,84740},{3,2119},{4,2119}]};

get_star_reward(134) ->
	#star_reward_cfg{stage = 134,star = 100,reward = [{1,4290},{2,85800},{3,2145},{4,2145}]};

get_star_reward(135) ->
	#star_reward_cfg{stage = 135,star = 100,reward = [{1,4343},{2,86860},{3,2172},{4,2172}]};

get_star_reward(136) ->
	#star_reward_cfg{stage = 136,star = 100,reward = [{1,4397},{2,87940},{3,2199},{4,2199}]};

get_star_reward(137) ->
	#star_reward_cfg{stage = 137,star = 100,reward = [{1,4451},{2,89020},{3,2226},{4,2226}]};

get_star_reward(138) ->
	#star_reward_cfg{stage = 138,star = 100,reward = [{1,4505},{2,90100},{3,2253},{4,2253}]};

get_star_reward(139) ->
	#star_reward_cfg{stage = 139,star = 100,reward = [{1,4559},{2,91180},{3,2280},{4,2280}]};

get_star_reward(140) ->
	#star_reward_cfg{stage = 140,star = 100,reward = [{1,4614},{2,92280},{3,2307},{4,2307}]};

get_star_reward(141) ->
	#star_reward_cfg{stage = 141,star = 100,reward = [{1,4669},{2,93380},{3,2335},{4,2335}]};

get_star_reward(142) ->
	#star_reward_cfg{stage = 142,star = 100,reward = [{1,4724},{2,94480},{3,2362},{4,2362}]};

get_star_reward(143) ->
	#star_reward_cfg{stage = 143,star = 100,reward = [{1,4780},{2,95600},{3,2390},{4,2390}]};

get_star_reward(144) ->
	#star_reward_cfg{stage = 144,star = 100,reward = [{1,4835},{2,96700},{3,2418},{4,2418}]};

get_star_reward(145) ->
	#star_reward_cfg{stage = 145,star = 100,reward = [{1,4892},{2,97840},{3,2446},{4,2446}]};

get_star_reward(146) ->
	#star_reward_cfg{stage = 146,star = 100,reward = [{1,4948},{2,98960},{3,2474},{4,2474}]};

get_star_reward(147) ->
	#star_reward_cfg{stage = 147,star = 100,reward = [{1,5004},{2,100080},{3,2502},{4,2502}]};

get_star_reward(148) ->
	#star_reward_cfg{stage = 148,star = 100,reward = [{1,5061},{2,101220},{3,2531},{4,2531}]};

get_star_reward(149) ->
	#star_reward_cfg{stage = 149,star = 100,reward = [{1,5118},{2,102360},{3,2559},{4,2559}]};

get_star_reward(150) ->
	#star_reward_cfg{stage = 150,star = 100,reward = [{1,5176},{2,103520},{3,2588},{4,2588}]};

get_star_reward(151) ->
	#star_reward_cfg{stage = 151,star = 100,reward = [{1,5233},{2,104660},{3,2617},{4,2617}]};

get_star_reward(152) ->
	#star_reward_cfg{stage = 152,star = 100,reward = [{1,5291},{2,105820},{3,2646},{4,2646}]};

get_star_reward(153) ->
	#star_reward_cfg{stage = 153,star = 100,reward = [{1,5349},{2,106980},{3,2675},{4,2675}]};

get_star_reward(154) ->
	#star_reward_cfg{stage = 154,star = 100,reward = [{1,5408},{2,108160},{3,2704},{4,2704}]};

get_star_reward(155) ->
	#star_reward_cfg{stage = 155,star = 100,reward = [{1,5467},{2,109340},{3,2734},{4,2734}]};

get_star_reward(156) ->
	#star_reward_cfg{stage = 156,star = 100,reward = [{1,5526},{2,110520},{3,2763},{4,2763}]};

get_star_reward(157) ->
	#star_reward_cfg{stage = 157,star = 100,reward = [{1,5585},{2,111700},{3,2793},{4,2793}]};

get_star_reward(158) ->
	#star_reward_cfg{stage = 158,star = 100,reward = [{1,5644},{2,112880},{3,2822},{4,2822}]};

get_star_reward(159) ->
	#star_reward_cfg{stage = 159,star = 100,reward = [{1,5704},{2,114080},{3,2852},{4,2852}]};

get_star_reward(160) ->
	#star_reward_cfg{stage = 160,star = 100,reward = [{1,5764},{2,115280},{3,2882},{4,2882}]};

get_star_reward(161) ->
	#star_reward_cfg{stage = 161,star = 100,reward = [{1,5824},{2,116480},{3,2912},{4,2912}]};

get_star_reward(162) ->
	#star_reward_cfg{stage = 162,star = 100,reward = [{1,5885},{2,117700},{3,2943},{4,2943}]};

get_star_reward(163) ->
	#star_reward_cfg{stage = 163,star = 100,reward = [{1,5945},{2,118900},{3,2973},{4,2973}]};

get_star_reward(164) ->
	#star_reward_cfg{stage = 164,star = 100,reward = [{1,6006},{2,120120},{3,3003},{4,3003}]};

get_star_reward(165) ->
	#star_reward_cfg{stage = 165,star = 100,reward = [{1,6068},{2,121360},{3,3034},{4,3034}]};

get_star_reward(166) ->
	#star_reward_cfg{stage = 166,star = 100,reward = [{1,6129},{2,122580},{3,3065},{4,3065}]};

get_star_reward(167) ->
	#star_reward_cfg{stage = 167,star = 100,reward = [{1,6191},{2,123820},{3,3096},{4,3096}]};

get_star_reward(168) ->
	#star_reward_cfg{stage = 168,star = 100,reward = [{1,6253},{2,125060},{3,3127},{4,3127}]};

get_star_reward(169) ->
	#star_reward_cfg{stage = 169,star = 100,reward = [{1,6315},{2,126300},{3,3158},{4,3158}]};

get_star_reward(170) ->
	#star_reward_cfg{stage = 170,star = 100,reward = [{1,6378},{2,127560},{3,3189},{4,3189}]};

get_star_reward(171) ->
	#star_reward_cfg{stage = 171,star = 100,reward = [{1,6441},{2,128820},{3,3221},{4,3221}]};

get_star_reward(172) ->
	#star_reward_cfg{stage = 172,star = 100,reward = [{1,6504},{2,130080},{3,3252},{4,3252}]};

get_star_reward(173) ->
	#star_reward_cfg{stage = 173,star = 100,reward = [{1,6567},{2,131340},{3,3284},{4,3284}]};

get_star_reward(174) ->
	#star_reward_cfg{stage = 174,star = 100,reward = [{1,6631},{2,132620},{3,3316},{4,3316}]};

get_star_reward(175) ->
	#star_reward_cfg{stage = 175,star = 100,reward = [{1,6694},{2,133880},{3,3347},{4,3347}]};

get_star_reward(176) ->
	#star_reward_cfg{stage = 176,star = 100,reward = [{1,6758},{2,135160},{3,3379},{4,3379}]};

get_star_reward(177) ->
	#star_reward_cfg{stage = 177,star = 100,reward = [{1,6823},{2,136460},{3,3412},{4,3412}]};

get_star_reward(178) ->
	#star_reward_cfg{stage = 178,star = 100,reward = [{1,6887},{2,137740},{3,3444},{4,3444}]};

get_star_reward(179) ->
	#star_reward_cfg{stage = 179,star = 100,reward = [{1,6952},{2,139040},{3,3476},{4,3476}]};

get_star_reward(180) ->
	#star_reward_cfg{stage = 180,star = 100,reward = [{1,7017},{2,140340},{3,3509},{4,3509}]};

get_star_reward(181) ->
	#star_reward_cfg{stage = 181,star = 100,reward = [{1,7083},{2,141660},{3,3542},{4,3542}]};

get_star_reward(182) ->
	#star_reward_cfg{stage = 182,star = 100,reward = [{1,7148},{2,142960},{3,3574},{4,3574}]};

get_star_reward(183) ->
	#star_reward_cfg{stage = 183,star = 100,reward = [{1,7214},{2,144280},{3,3607},{4,3607}]};

get_star_reward(184) ->
	#star_reward_cfg{stage = 184,star = 100,reward = [{1,7280},{2,145600},{3,3640},{4,3640}]};

get_star_reward(185) ->
	#star_reward_cfg{stage = 185,star = 100,reward = [{1,7346},{2,146920},{3,3673},{4,3673}]};

get_star_reward(186) ->
	#star_reward_cfg{stage = 186,star = 100,reward = [{1,7413},{2,148260},{3,3707},{4,3707}]};

get_star_reward(187) ->
	#star_reward_cfg{stage = 187,star = 100,reward = [{1,7480},{2,149600},{3,3740},{4,3740}]};

get_star_reward(188) ->
	#star_reward_cfg{stage = 188,star = 100,reward = [{1,7547},{2,150940},{3,3774},{4,3774}]};

get_star_reward(189) ->
	#star_reward_cfg{stage = 189,star = 100,reward = [{1,7614},{2,152280},{3,3807},{4,3807}]};

get_star_reward(190) ->
	#star_reward_cfg{stage = 190,star = 100,reward = [{1,7682},{2,153640},{3,3841},{4,3841}]};

get_star_reward(191) ->
	#star_reward_cfg{stage = 191,star = 100,reward = [{1,7749},{2,154980},{3,3875},{4,3875}]};

get_star_reward(192) ->
	#star_reward_cfg{stage = 192,star = 100,reward = [{1,7817},{2,156340},{3,3909},{4,3909}]};

get_star_reward(193) ->
	#star_reward_cfg{stage = 193,star = 100,reward = [{1,7886},{2,157720},{3,3943},{4,3943}]};

get_star_reward(194) ->
	#star_reward_cfg{stage = 194,star = 100,reward = [{1,7954},{2,159080},{3,3977},{4,3977}]};

get_star_reward(195) ->
	#star_reward_cfg{stage = 195,star = 100,reward = [{1,8023},{2,160460},{3,4012},{4,4012}]};

get_star_reward(196) ->
	#star_reward_cfg{stage = 196,star = 100,reward = [{1,8092},{2,161840},{3,4046},{4,4046}]};

get_star_reward(197) ->
	#star_reward_cfg{stage = 197,star = 100,reward = [{1,8161},{2,163220},{3,4081},{4,4081}]};

get_star_reward(198) ->
	#star_reward_cfg{stage = 198,star = 100,reward = [{1,8231},{2,164620},{3,4116},{4,4116}]};

get_star_reward(199) ->
	#star_reward_cfg{stage = 199,star = 100,reward = [{1,8300},{2,166000},{3,4150},{4,4150}]};

get_star_reward(200) ->
	#star_reward_cfg{stage = 200,star = 100,reward = [{1,8370},{2,167400},{3,4185},{4,4185}]};

get_star_reward(_Stage) ->
	[].

get_reward_all_stage() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200].


get_star_by_stage(1) ->
[100];


get_star_by_stage(2) ->
[100];


get_star_by_stage(3) ->
[100];


get_star_by_stage(4) ->
[100];


get_star_by_stage(5) ->
[100];


get_star_by_stage(6) ->
[100];


get_star_by_stage(7) ->
[100];


get_star_by_stage(8) ->
[100];


get_star_by_stage(9) ->
[100];


get_star_by_stage(10) ->
[100];


get_star_by_stage(11) ->
[100];


get_star_by_stage(12) ->
[100];


get_star_by_stage(13) ->
[100];


get_star_by_stage(14) ->
[100];


get_star_by_stage(15) ->
[100];


get_star_by_stage(16) ->
[100];


get_star_by_stage(17) ->
[100];


get_star_by_stage(18) ->
[100];


get_star_by_stage(19) ->
[100];


get_star_by_stage(20) ->
[100];


get_star_by_stage(21) ->
[100];


get_star_by_stage(22) ->
[100];


get_star_by_stage(23) ->
[100];


get_star_by_stage(24) ->
[100];


get_star_by_stage(25) ->
[100];


get_star_by_stage(26) ->
[100];


get_star_by_stage(27) ->
[100];


get_star_by_stage(28) ->
[100];


get_star_by_stage(29) ->
[100];


get_star_by_stage(30) ->
[100];


get_star_by_stage(31) ->
[100];


get_star_by_stage(32) ->
[100];


get_star_by_stage(33) ->
[100];


get_star_by_stage(34) ->
[100];


get_star_by_stage(35) ->
[100];


get_star_by_stage(36) ->
[100];


get_star_by_stage(37) ->
[100];


get_star_by_stage(38) ->
[100];


get_star_by_stage(39) ->
[100];


get_star_by_stage(40) ->
[100];


get_star_by_stage(41) ->
[100];


get_star_by_stage(42) ->
[100];


get_star_by_stage(43) ->
[100];


get_star_by_stage(44) ->
[100];


get_star_by_stage(45) ->
[100];


get_star_by_stage(46) ->
[100];


get_star_by_stage(47) ->
[100];


get_star_by_stage(48) ->
[100];


get_star_by_stage(49) ->
[100];


get_star_by_stage(50) ->
[100];


get_star_by_stage(51) ->
[100];


get_star_by_stage(52) ->
[100];


get_star_by_stage(53) ->
[100];


get_star_by_stage(54) ->
[100];


get_star_by_stage(55) ->
[100];


get_star_by_stage(56) ->
[100];


get_star_by_stage(57) ->
[100];


get_star_by_stage(58) ->
[100];


get_star_by_stage(59) ->
[100];


get_star_by_stage(60) ->
[100];


get_star_by_stage(61) ->
[100];


get_star_by_stage(62) ->
[100];


get_star_by_stage(63) ->
[100];


get_star_by_stage(64) ->
[100];


get_star_by_stage(65) ->
[100];


get_star_by_stage(66) ->
[100];


get_star_by_stage(67) ->
[100];


get_star_by_stage(68) ->
[100];


get_star_by_stage(69) ->
[100];


get_star_by_stage(70) ->
[100];


get_star_by_stage(71) ->
[100];


get_star_by_stage(72) ->
[100];


get_star_by_stage(73) ->
[100];


get_star_by_stage(74) ->
[100];


get_star_by_stage(75) ->
[100];


get_star_by_stage(76) ->
[100];


get_star_by_stage(77) ->
[100];


get_star_by_stage(78) ->
[100];


get_star_by_stage(79) ->
[100];


get_star_by_stage(80) ->
[100];


get_star_by_stage(81) ->
[100];


get_star_by_stage(82) ->
[100];


get_star_by_stage(83) ->
[100];


get_star_by_stage(84) ->
[100];


get_star_by_stage(85) ->
[100];


get_star_by_stage(86) ->
[100];


get_star_by_stage(87) ->
[100];


get_star_by_stage(88) ->
[100];


get_star_by_stage(89) ->
[100];


get_star_by_stage(90) ->
[100];


get_star_by_stage(91) ->
[100];


get_star_by_stage(92) ->
[100];


get_star_by_stage(93) ->
[100];


get_star_by_stage(94) ->
[100];


get_star_by_stage(95) ->
[100];


get_star_by_stage(96) ->
[100];


get_star_by_stage(97) ->
[100];


get_star_by_stage(98) ->
[100];


get_star_by_stage(99) ->
[100];


get_star_by_stage(100) ->
[100];


get_star_by_stage(101) ->
[100];


get_star_by_stage(102) ->
[100];


get_star_by_stage(103) ->
[100];


get_star_by_stage(104) ->
[100];


get_star_by_stage(105) ->
[100];


get_star_by_stage(106) ->
[100];


get_star_by_stage(107) ->
[100];


get_star_by_stage(108) ->
[100];


get_star_by_stage(109) ->
[100];


get_star_by_stage(110) ->
[100];


get_star_by_stage(111) ->
[100];


get_star_by_stage(112) ->
[100];


get_star_by_stage(113) ->
[100];


get_star_by_stage(114) ->
[100];


get_star_by_stage(115) ->
[100];


get_star_by_stage(116) ->
[100];


get_star_by_stage(117) ->
[100];


get_star_by_stage(118) ->
[100];


get_star_by_stage(119) ->
[100];


get_star_by_stage(120) ->
[100];


get_star_by_stage(121) ->
[100];


get_star_by_stage(122) ->
[100];


get_star_by_stage(123) ->
[100];


get_star_by_stage(124) ->
[100];


get_star_by_stage(125) ->
[100];


get_star_by_stage(126) ->
[100];


get_star_by_stage(127) ->
[100];


get_star_by_stage(128) ->
[100];


get_star_by_stage(129) ->
[100];


get_star_by_stage(130) ->
[100];


get_star_by_stage(131) ->
[100];


get_star_by_stage(132) ->
[100];


get_star_by_stage(133) ->
[100];


get_star_by_stage(134) ->
[100];


get_star_by_stage(135) ->
[100];


get_star_by_stage(136) ->
[100];


get_star_by_stage(137) ->
[100];


get_star_by_stage(138) ->
[100];


get_star_by_stage(139) ->
[100];


get_star_by_stage(140) ->
[100];


get_star_by_stage(141) ->
[100];


get_star_by_stage(142) ->
[100];


get_star_by_stage(143) ->
[100];


get_star_by_stage(144) ->
[100];


get_star_by_stage(145) ->
[100];


get_star_by_stage(146) ->
[100];


get_star_by_stage(147) ->
[100];


get_star_by_stage(148) ->
[100];


get_star_by_stage(149) ->
[100];


get_star_by_stage(150) ->
[100];


get_star_by_stage(151) ->
[100];


get_star_by_stage(152) ->
[100];


get_star_by_stage(153) ->
[100];


get_star_by_stage(154) ->
[100];


get_star_by_stage(155) ->
[100];


get_star_by_stage(156) ->
[100];


get_star_by_stage(157) ->
[100];


get_star_by_stage(158) ->
[100];


get_star_by_stage(159) ->
[100];


get_star_by_stage(160) ->
[100];


get_star_by_stage(161) ->
[100];


get_star_by_stage(162) ->
[100];


get_star_by_stage(163) ->
[100];


get_star_by_stage(164) ->
[100];


get_star_by_stage(165) ->
[100];


get_star_by_stage(166) ->
[100];


get_star_by_stage(167) ->
[100];


get_star_by_stage(168) ->
[100];


get_star_by_stage(169) ->
[100];


get_star_by_stage(170) ->
[100];


get_star_by_stage(171) ->
[100];


get_star_by_stage(172) ->
[100];


get_star_by_stage(173) ->
[100];


get_star_by_stage(174) ->
[100];


get_star_by_stage(175) ->
[100];


get_star_by_stage(176) ->
[100];


get_star_by_stage(177) ->
[100];


get_star_by_stage(178) ->
[100];


get_star_by_stage(179) ->
[100];


get_star_by_stage(180) ->
[100];


get_star_by_stage(181) ->
[100];


get_star_by_stage(182) ->
[100];


get_star_by_stage(183) ->
[100];


get_star_by_stage(184) ->
[100];


get_star_by_stage(185) ->
[100];


get_star_by_stage(186) ->
[100];


get_star_by_stage(187) ->
[100];


get_star_by_stage(188) ->
[100];


get_star_by_stage(189) ->
[100];


get_star_by_stage(190) ->
[100];


get_star_by_stage(191) ->
[100];


get_star_by_stage(192) ->
[100];


get_star_by_stage(193) ->
[100];


get_star_by_stage(194) ->
[100];


get_star_by_stage(195) ->
[100];


get_star_by_stage(196) ->
[100];


get_star_by_stage(197) ->
[100];


get_star_by_stage(198) ->
[100];


get_star_by_stage(199) ->
[100];


get_star_by_stage(200) ->
[100];

get_star_by_stage(_Stage) ->
	[].

get_all_achv_type() ->
[1,2,3,4,5,6,7].

