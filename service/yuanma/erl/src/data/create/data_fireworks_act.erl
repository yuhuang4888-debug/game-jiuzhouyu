%%%---------------------------------------
%%% module      : data_fireworks_act
%%% description : 烟花活动配置
%%%
%%%---------------------------------------
-module(data_fireworks_act).
-compile(export_all).
-include("fireworks_act.hrl").




get_key(num_period) ->
100;


get_key(fireworks_id) ->
38220002;


get_key(global_num_period) ->
200;


get_key(fireworks_effect) ->
effect_xunbaoyanhua_001;

get_key(_Key) ->
	0.

get_info_cfg(1) ->
	#base_fireworks_act{id = 1,wlv = 0,goods = [{0,20030001,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(2) ->
	#base_fireworks_act{id = 2,wlv = 0,goods = [{0,24030001,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(3) ->
	#base_fireworks_act{id = 3,wlv = 0,goods = [{0,20020003,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(4) ->
	#base_fireworks_act{id = 4,wlv = 0,goods = [{0,24020003,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(5) ->
	#base_fireworks_act{id = 5,wlv = 0,goods = [{0,14010003,1}],weight = 75,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(6) ->
	#base_fireworks_act{id = 6,wlv = 0,goods = [{0,14020003,1}],weight = 75,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(7) ->
	#base_fireworks_act{id = 7,wlv = 0,goods = [{0,32010045,1}],weight = 80,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(8) ->
	#base_fireworks_act{id = 8,wlv = 0,goods = [{0,37020002,1}],weight = 100,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(9) ->
	#base_fireworks_act{id = 9,wlv = 0,goods = [{0,20020001,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(10) ->
	#base_fireworks_act{id = 10,wlv = 0,goods = [{0,20020002,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(11) ->
	#base_fireworks_act{id = 11,wlv = 0,goods = [{0,24020001,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(12) ->
	#base_fireworks_act{id = 12,wlv = 0,goods = [{0,24020002,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(13) ->
	#base_fireworks_act{id = 13,wlv = 0,goods = [{0,20010002,1}],weight = 150,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(14) ->
	#base_fireworks_act{id = 14,wlv = 0,goods = [{0,24010002,1}],weight = 150,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(15) ->
	#base_fireworks_act{id = 15,wlv = 0,goods = [{0,14010002,1}],weight = 100,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(16) ->
	#base_fireworks_act{id = 16,wlv = 0,goods = [{0,14020002,1}],weight = 100,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(17) ->
	#base_fireworks_act{id = 17,wlv = 0,goods = [{0,32010044,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(18) ->
	#base_fireworks_act{id = 18,wlv = 201,goods = [{0,20030002,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(19) ->
	#base_fireworks_act{id = 19,wlv = 201,goods = [{0,24030002,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(20) ->
	#base_fireworks_act{id = 20,wlv = 201,goods = [{0,20030001,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(21) ->
	#base_fireworks_act{id = 21,wlv = 201,goods = [{0,24030001,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(22) ->
	#base_fireworks_act{id = 22,wlv = 201,goods = [{0,20020003,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(23) ->
	#base_fireworks_act{id = 23,wlv = 201,goods = [{0,24020003,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(24) ->
	#base_fireworks_act{id = 24,wlv = 201,goods = [{0,32010058,1}],weight = 150,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(25) ->
	#base_fireworks_act{id = 25,wlv = 201,goods = [{0,32010045,1}],weight = 70,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(26) ->
	#base_fireworks_act{id = 26,wlv = 201,goods = [{0,14010003,1}],weight = 75,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(27) ->
	#base_fireworks_act{id = 27,wlv = 201,goods = [{0,14020003,1}],weight = 75,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(28) ->
	#base_fireworks_act{id = 28,wlv = 201,goods = [{0,37020002,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(29) ->
	#base_fireworks_act{id = 29,wlv = 201,goods = [{0,32010044,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(30) ->
	#base_fireworks_act{id = 30,wlv = 201,goods = [{0,20020001,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(31) ->
	#base_fireworks_act{id = 31,wlv = 201,goods = [{0,20020002,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(32) ->
	#base_fireworks_act{id = 32,wlv = 201,goods = [{0,24020001,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(33) ->
	#base_fireworks_act{id = 33,wlv = 201,goods = [{0,24020002,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(34) ->
	#base_fireworks_act{id = 34,wlv = 201,goods = [{0,20010002,1}],weight = 100,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(35) ->
	#base_fireworks_act{id = 35,wlv = 201,goods = [{0,24010002,1}],weight = 100,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(36) ->
	#base_fireworks_act{id = 36,wlv = 201,goods = [{0,14010002,1}],weight = 100,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(37) ->
	#base_fireworks_act{id = 37,wlv = 201,goods = [{0,14020002,1}],weight = 100,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(38) ->
	#base_fireworks_act{id = 38,wlv = 251,goods = [{0,20030002,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(39) ->
	#base_fireworks_act{id = 39,wlv = 251,goods = [{0,24030002,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(40) ->
	#base_fireworks_act{id = 40,wlv = 251,goods = [{0,20030001,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(41) ->
	#base_fireworks_act{id = 41,wlv = 251,goods = [{0,24030001,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(42) ->
	#base_fireworks_act{id = 42,wlv = 251,goods = [{0,32010059,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(43) ->
	#base_fireworks_act{id = 43,wlv = 251,goods = [{0,32010058,1}],weight = 150,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(44) ->
	#base_fireworks_act{id = 44,wlv = 251,goods = [{0,14010004,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(45) ->
	#base_fireworks_act{id = 45,wlv = 251,goods = [{0,14020004,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(46) ->
	#base_fireworks_act{id = 46,wlv = 251,goods = [{0,38040011,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(47) ->
	#base_fireworks_act{id = 47,wlv = 251,goods = [{0,38040002,50}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(48) ->
	#base_fireworks_act{id = 48,wlv = 251,goods = [{0,20020003,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(49) ->
	#base_fireworks_act{id = 49,wlv = 251,goods = [{0,24020003,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(50) ->
	#base_fireworks_act{id = 50,wlv = 251,goods = [{0,20020001,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(51) ->
	#base_fireworks_act{id = 51,wlv = 251,goods = [{0,20020002,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(52) ->
	#base_fireworks_act{id = 52,wlv = 251,goods = [{0,24020001,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(53) ->
	#base_fireworks_act{id = 53,wlv = 251,goods = [{0,24020002,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(54) ->
	#base_fireworks_act{id = 54,wlv = 251,goods = [{0,20010002,1}],weight = 80,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(55) ->
	#base_fireworks_act{id = 55,wlv = 251,goods = [{0,24010002,1}],weight = 80,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(56) ->
	#base_fireworks_act{id = 56,wlv = 251,goods = [{0,14010003,1}],weight = 75,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(57) ->
	#base_fireworks_act{id = 57,wlv = 251,goods = [{0,14020003,1}],weight = 75,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(58) ->
	#base_fireworks_act{id = 58,wlv = 251,goods = [{0,37020002,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(59) ->
	#base_fireworks_act{id = 59,wlv = 251,goods = [{0,32010044,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(60) ->
	#base_fireworks_act{id = 60,wlv = 251,goods = [{0,32010045,1}],weight = 60,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(61) ->
	#base_fireworks_act{id = 61,wlv = 301,goods = [{0,24030003,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(62) ->
	#base_fireworks_act{id = 62,wlv = 301,goods = [{0,20030004,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(63) ->
	#base_fireworks_act{id = 63,wlv = 301,goods = [{0,24030002,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(64) ->
	#base_fireworks_act{id = 64,wlv = 301,goods = [{0,20030002,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(65) ->
	#base_fireworks_act{id = 65,wlv = 301,goods = [{0,38041018,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(66) ->
	#base_fireworks_act{id = 66,wlv = 301,goods = [{0,38040005,1}],weight = 20,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(67) ->
	#base_fireworks_act{id = 67,wlv = 301,goods = [{0,32010059,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(68) ->
	#base_fireworks_act{id = 68,wlv = 301,goods = [{0,32010058,1}],weight = 130,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(69) ->
	#base_fireworks_act{id = 69,wlv = 301,goods = [{0,20030001,1}],weight = 5,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(70) ->
	#base_fireworks_act{id = 70,wlv = 301,goods = [{0,24030001,1}],weight = 5,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(71) ->
	#base_fireworks_act{id = 71,wlv = 301,goods = [{0,14010004,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(72) ->
	#base_fireworks_act{id = 72,wlv = 301,goods = [{0,14020004,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(73) ->
	#base_fireworks_act{id = 73,wlv = 301,goods = [{0,38040011,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(74) ->
	#base_fireworks_act{id = 74,wlv = 301,goods = [{0,38040002,50}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(75) ->
	#base_fireworks_act{id = 75,wlv = 301,goods = [{0,20020003,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(76) ->
	#base_fireworks_act{id = 76,wlv = 301,goods = [{0,24020003,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(77) ->
	#base_fireworks_act{id = 77,wlv = 301,goods = [{0,20020001,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(78) ->
	#base_fireworks_act{id = 78,wlv = 301,goods = [{0,20020002,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(79) ->
	#base_fireworks_act{id = 79,wlv = 301,goods = [{0,24020001,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(80) ->
	#base_fireworks_act{id = 80,wlv = 301,goods = [{0,24020002,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(81) ->
	#base_fireworks_act{id = 81,wlv = 301,goods = [{0,20010002,1}],weight = 80,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(82) ->
	#base_fireworks_act{id = 82,wlv = 301,goods = [{0,24010002,1}],weight = 80,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(83) ->
	#base_fireworks_act{id = 83,wlv = 301,goods = [{0,14010003,1}],weight = 70,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(84) ->
	#base_fireworks_act{id = 84,wlv = 301,goods = [{0,14020003,1}],weight = 70,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(85) ->
	#base_fireworks_act{id = 85,wlv = 301,goods = [{0,37020002,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(86) ->
	#base_fireworks_act{id = 86,wlv = 301,goods = [{0,32010044,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(87) ->
	#base_fireworks_act{id = 87,wlv = 301,goods = [{0,32010045,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(88) ->
	#base_fireworks_act{id = 88,wlv = 401,goods = [{0,24030004,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(89) ->
	#base_fireworks_act{id = 89,wlv = 401,goods = [{0,20030005,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(90) ->
	#base_fireworks_act{id = 90,wlv = 401,goods = [{0,24030003,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(91) ->
	#base_fireworks_act{id = 91,wlv = 401,goods = [{0,20030004,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(92) ->
	#base_fireworks_act{id = 92,wlv = 401,goods = [{0,38040019,1}],weight = 10,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(93) ->
	#base_fireworks_act{id = 93,wlv = 401,goods = [{0,38040005,1}],weight = 20,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(94) ->
	#base_fireworks_act{id = 94,wlv = 401,goods = [{0,38041018,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(95) ->
	#base_fireworks_act{id = 95,wlv = 401,goods = [{0,32010059,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(96) ->
	#base_fireworks_act{id = 96,wlv = 401,goods = [{0,24030002,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(97) ->
	#base_fireworks_act{id = 97,wlv = 401,goods = [{0,20030002,1}],weight = 5,limit_num = 1,all_server_num = 1,is_tv = 1};

get_info_cfg(98) ->
	#base_fireworks_act{id = 98,wlv = 401,goods = [{0,24030001,1}],weight = 5,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(99) ->
	#base_fireworks_act{id = 99,wlv = 401,goods = [{0,20030001,1}],weight = 5,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(100) ->
	#base_fireworks_act{id = 100,wlv = 401,goods = [{0,14010004,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(101) ->
	#base_fireworks_act{id = 101,wlv = 401,goods = [{0,14020004,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(102) ->
	#base_fireworks_act{id = 102,wlv = 401,goods = [{0,20020003,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(103) ->
	#base_fireworks_act{id = 103,wlv = 401,goods = [{0,24020003,1}],weight = 10,limit_num = 1,all_server_num = 2,is_tv = 1};

get_info_cfg(104) ->
	#base_fireworks_act{id = 104,wlv = 401,goods = [{0,20020001,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(105) ->
	#base_fireworks_act{id = 105,wlv = 401,goods = [{0,20020002,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(106) ->
	#base_fireworks_act{id = 106,wlv = 401,goods = [{0,24020001,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(107) ->
	#base_fireworks_act{id = 107,wlv = 401,goods = [{0,24020002,1}],weight = 20,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(108) ->
	#base_fireworks_act{id = 108,wlv = 401,goods = [{0,20010002,1}],weight = 80,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(109) ->
	#base_fireworks_act{id = 109,wlv = 401,goods = [{0,24010002,1}],weight = 80,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(110) ->
	#base_fireworks_act{id = 110,wlv = 401,goods = [{0,14010003,1}],weight = 65,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(111) ->
	#base_fireworks_act{id = 111,wlv = 401,goods = [{0,14020003,1}],weight = 65,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(112) ->
	#base_fireworks_act{id = 112,wlv = 401,goods = [{0,37020002,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(113) ->
	#base_fireworks_act{id = 113,wlv = 401,goods = [{0,32010044,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(114) ->
	#base_fireworks_act{id = 114,wlv = 401,goods = [{0,32010045,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(115) ->
	#base_fireworks_act{id = 115,wlv = 401,goods = [{0,32010058,1}],weight = 120,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(116) ->
	#base_fireworks_act{id = 116,wlv = 401,goods = [{0,38040002,50}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(117) ->
	#base_fireworks_act{id = 117,wlv = 401,goods = [{0,38040011,1}],weight = 50,limit_num = 0,all_server_num = 0,is_tv = 0};

get_info_cfg(_Id) ->
	[].

get_id_list() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117].

get_wlv_list() ->
[401,301,251,201,0].


get_ids_by_wlv(0) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17];


get_ids_by_wlv(201) ->
[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37];


get_ids_by_wlv(251) ->
[38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60];


get_ids_by_wlv(301) ->
[61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87];


get_ids_by_wlv(401) ->
[88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117];

get_ids_by_wlv(_Wlv) ->
	[].

get_plus_weight_cfg(_,_) ->
	[].

get_plus_weight_count(_Id) ->
	[].

