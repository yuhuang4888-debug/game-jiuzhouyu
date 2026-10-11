%%%---------------------------------------
%%% module      : data_recharge
%%% description : 充值配置
%%%
%%%---------------------------------------
-module(data_recharge).
-compile(export_all).
-include("rec_recharge.hrl").



get_product(0) ->
	#base_recharge_product{product_id = 0,product_name = <<"0元随心充"/utf8>>,product_type = 5,product_subtype = 1,money = 2,associate_list = [{4,1}],about = "",show_condition = []};

get_product(2) ->
	#base_recharge_product{product_id = 2,product_name = <<"60勾玉"/utf8>>,product_type = 1,product_subtype = 1,money = 6,associate_list = [{4,1}],about = "",show_condition = []};

get_product(3) ->
	#base_recharge_product{product_id = 3,product_name = <<"300勾玉"/utf8>>,product_type = 1,product_subtype = 1,money = 30,associate_list = [{4,1}],about = "",show_condition = []};

get_product(4) ->
	#base_recharge_product{product_id = 4,product_name = <<"680勾玉"/utf8>>,product_type = 1,product_subtype = 1,money = 68,associate_list = [{4,1}],about = "",show_condition = []};

get_product(5) ->
	#base_recharge_product{product_id = 5,product_name = <<"1280勾玉"/utf8>>,product_type = 1,product_subtype = 1,money = 128,associate_list = [{4,1}],about = "",show_condition = []};

get_product(6) ->
	#base_recharge_product{product_id = 6,product_name = <<"1980勾玉"/utf8>>,product_type = 1,product_subtype = 1,money = 198,associate_list = [{4,1}],about = "",show_condition = []};

get_product(7) ->
	#base_recharge_product{product_id = 7,product_name = <<"3280勾玉"/utf8>>,product_type = 1,product_subtype = 1,money = 328,associate_list = [{4,1}],about = "",show_condition = []};

get_product(8) ->
	#base_recharge_product{product_id = 8,product_name = <<"6480勾玉"/utf8>>,product_type = 1,product_subtype = 1,money = 648,associate_list = [{4,1}],about = "",show_condition = []};

get_product(40) ->
	#base_recharge_product{product_id = 40,product_name = <<"首冲礼包"/utf8>>,product_type = 4,product_subtype = 1,money = 999,associate_list = [],about = "充值任意金额，个性时装，极品武器大派送！",show_condition = []};

get_product(50) ->
	#base_recharge_product{product_id = 50,product_name = <<"1元礼包"/utf8>>,product_type = 5,product_subtype = 1,money = 1,associate_list = [],about = "",show_condition = []};

get_product(51) ->
	#base_recharge_product{product_id = 51,product_name = <<"新手豪华祭典"/utf8>>,product_type = 6,product_subtype = 1,money = 68,associate_list = [{4,1}],about = "",show_condition = []};

get_product(52) ->
	#base_recharge_product{product_id = 52,product_name = <<"新手至尊祭典"/utf8>>,product_type = 6,product_subtype = 1,money = 88,associate_list = [{4,1}],about = "",show_condition = []};

get_product(53) ->
	#base_recharge_product{product_id = 53,product_name = <<"豪华祭典"/utf8>>,product_type = 6,product_subtype = 1,money = 88,associate_list = [{4,1}],about = "",show_condition = []};

get_product(54) ->
	#base_recharge_product{product_id = 54,product_name = <<"至尊祭典"/utf8>>,product_type = 6,product_subtype = 1,money = 128,associate_list = [{4,1}],about = "",show_condition = []};

get_product(55) ->
	#base_recharge_product{product_id = 55,product_name = <<"每日1元秒杀"/utf8>>,product_type = 6,product_subtype = 1,money = 1,associate_list = [],about = "",show_condition = []};

get_product(56) ->
	#base_recharge_product{product_id = 56,product_name = <<"每日3元秒杀"/utf8>>,product_type = 6,product_subtype = 1,money = 3,associate_list = [],about = "",show_condition = []};

get_product(57) ->
	#base_recharge_product{product_id = 57,product_name = <<"每日6元秒杀"/utf8>>,product_type = 6,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(58) ->
	#base_recharge_product{product_id = 58,product_name = <<"8元打包秒杀"/utf8>>,product_type = 6,product_subtype = 1,money = 8,associate_list = [],about = "",show_condition = []};

get_product(59) ->
	#base_recharge_product{product_id = 59,product_name = <<"超值4"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(60) ->
	#base_recharge_product{product_id = 60,product_name = <<"超值5"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(61) ->
	#base_recharge_product{product_id = 61,product_name = <<"超值5"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(62) ->
	#base_recharge_product{product_id = 62,product_name = <<"超值5"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(63) ->
	#base_recharge_product{product_id = 63,product_name = <<"超值7"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(64) ->
	#base_recharge_product{product_id = 64,product_name = <<"超值7"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(65) ->
	#base_recharge_product{product_id = 65,product_name = <<"超值7"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(66) ->
	#base_recharge_product{product_id = 66,product_name = <<"超值9"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(67) ->
	#base_recharge_product{product_id = 67,product_name = <<"超值9"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(68) ->
	#base_recharge_product{product_id = 68,product_name = <<"超值9"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(69) ->
	#base_recharge_product{product_id = 69,product_name = <<"超值12"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(70) ->
	#base_recharge_product{product_id = 70,product_name = <<"超值12"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(71) ->
	#base_recharge_product{product_id = 71,product_name = <<"超值12"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(72) ->
	#base_recharge_product{product_id = 72,product_name = <<"超值17"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(73) ->
	#base_recharge_product{product_id = 73,product_name = <<"超值17"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(74) ->
	#base_recharge_product{product_id = 74,product_name = <<"超值17"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(75) ->
	#base_recharge_product{product_id = 75,product_name = <<"超值24"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(76) ->
	#base_recharge_product{product_id = 76,product_name = <<"超值24"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(77) ->
	#base_recharge_product{product_id = 77,product_name = <<"超值24"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(78) ->
	#base_recharge_product{product_id = 78,product_name = <<"超值32"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(79) ->
	#base_recharge_product{product_id = 79,product_name = <<"超值32"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(80) ->
	#base_recharge_product{product_id = 80,product_name = <<"超值32"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(81) ->
	#base_recharge_product{product_id = 81,product_name = <<"超值40"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(82) ->
	#base_recharge_product{product_id = 82,product_name = <<"超值40"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(83) ->
	#base_recharge_product{product_id = 83,product_name = <<"超值40"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(84) ->
	#base_recharge_product{product_id = 84,product_name = <<"超值50"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(85) ->
	#base_recharge_product{product_id = 85,product_name = <<"超值50"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(86) ->
	#base_recharge_product{product_id = 86,product_name = <<"超值50"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(87) ->
	#base_recharge_product{product_id = 87,product_name = <<"传说契约"/utf8>>,product_type = 5,product_subtype = 1,money = 68,associate_list = [],about = "",show_condition = []};

get_product(88) ->
	#base_recharge_product{product_id = 88,product_name = <<"超值22"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(89) ->
	#base_recharge_product{product_id = 89,product_name = <<"超值22"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(90) ->
	#base_recharge_product{product_id = 90,product_name = <<"超值22"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(91) ->
	#base_recharge_product{product_id = 91,product_name = <<"超值30"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(92) ->
	#base_recharge_product{product_id = 92,product_name = <<"超值30"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(93) ->
	#base_recharge_product{product_id = 93,product_name = <<"超值30"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(94) ->
	#base_recharge_product{product_id = 94,product_name = <<"超值37"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(95) ->
	#base_recharge_product{product_id = 95,product_name = <<"超值37"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(96) ->
	#base_recharge_product{product_id = 96,product_name = <<"超值37"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(97) ->
	#base_recharge_product{product_id = 97,product_name = <<"超值45"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(98) ->
	#base_recharge_product{product_id = 98,product_name = <<"超值45"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(99) ->
	#base_recharge_product{product_id = 99,product_name = <<"超值45"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(100) ->
	#base_recharge_product{product_id = 100,product_name = <<"超值56"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(101) ->
	#base_recharge_product{product_id = 101,product_name = <<"超值56"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(102) ->
	#base_recharge_product{product_id = 102,product_name = <<"超值56"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(103) ->
	#base_recharge_product{product_id = 103,product_name = <<"超值60加6"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(104) ->
	#base_recharge_product{product_id = 104,product_name = <<"超值60加6"/utf8>>,product_type = 5,product_subtype = 1,money = 18,associate_list = [],about = "",show_condition = []};

get_product(105) ->
	#base_recharge_product{product_id = 105,product_name = <<"超值60加6"/utf8>>,product_type = 5,product_subtype = 1,money = 128,associate_list = [],about = "",show_condition = []};

get_product(106) ->
	#base_recharge_product{product_id = 106,product_name = <<"QQ1元礼包"/utf8>>,product_type = 5,product_subtype = 1,money = 1,associate_list = [],about = "",show_condition = []};

get_product(107) ->
	#base_recharge_product{product_id = 107,product_name = <<"周卡"/utf8>>,product_type = 6,product_subtype = 3,money = 8,associate_list = [],about = "",show_condition = []};

get_product(108) ->
	#base_recharge_product{product_id = 108,product_name = <<"月卡"/utf8>>,product_type = 6,product_subtype = 2,money = 25,associate_list = [],about = "",show_condition = []};

get_product(120) ->
	#base_recharge_product{product_id = 120,product_name = <<"超值礼包"/utf8>>,product_type = 5,product_subtype = 1,money = 6,associate_list = [],about = "",show_condition = []};

get_product(121) ->
	#base_recharge_product{product_id = 121,product_name = <<"豪华礼包"/utf8>>,product_type = 5,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(122) ->
	#base_recharge_product{product_id = 122,product_name = <<"至尊礼包"/utf8>>,product_type = 5,product_subtype = 1,money = 68,associate_list = [],about = "",show_condition = []};

get_product(123) ->
	#base_recharge_product{product_id = 123,product_name = <<"传说礼包"/utf8>>,product_type = 5,product_subtype = 1,money = 98,associate_list = [],about = "",show_condition = []};

get_product(130) ->
	#base_recharge_product{product_id = 130,product_name = <<"超值礼包(充)"/utf8>>,product_type = 6,product_subtype = 1,money = 6,associate_list = [{4,1}],about = "",show_condition = []};

get_product(131) ->
	#base_recharge_product{product_id = 131,product_name = <<"豪华礼包(充)"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [{4,1}],about = "",show_condition = []};

get_product(132) ->
	#base_recharge_product{product_id = 132,product_name = <<"至尊礼包(充)"/utf8>>,product_type = 6,product_subtype = 1,money = 68,associate_list = [{4,1}],about = "",show_condition = []};

get_product(133) ->
	#base_recharge_product{product_id = 133,product_name = <<"传说礼包(充)"/utf8>>,product_type = 6,product_subtype = 1,money = 128,associate_list = [{4,1}],about = "",show_condition = []};

get_product(141) ->
	#base_recharge_product{product_id = 141,product_name = <<"坐骑仙灵直购"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(142) ->
	#base_recharge_product{product_id = 142,product_name = <<"侍魂仙灵直购"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(143) ->
	#base_recharge_product{product_id = 143,product_name = <<"翅膀仙灵直购"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(144) ->
	#base_recharge_product{product_id = 144,product_name = <<"御守仙灵直购"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(145) ->
	#base_recharge_product{product_id = 145,product_name = <<"神兵仙灵直购"/utf8>>,product_type = 6,product_subtype = 1,money = 68,associate_list = [],about = "",show_condition = []};

get_product(150) ->
	#base_recharge_product{product_id = 150,product_name = <<"绝版幻形打包"/utf8>>,product_type = 6,product_subtype = 1,money = 328,associate_list = [{4,1}],about = "",show_condition = []};

get_product(151) ->
	#base_recharge_product{product_id = 151,product_name = <<"绝版坐骑"/utf8>>,product_type = 6,product_subtype = 1,money = 198,associate_list = [{4,1}],about = "",show_condition = []};

get_product(152) ->
	#base_recharge_product{product_id = 152,product_name = <<"绝版翅膀"/utf8>>,product_type = 6,product_subtype = 1,money = 168,associate_list = [{4,1}],about = "",show_condition = []};

get_product(153) ->
	#base_recharge_product{product_id = 153,product_name = <<"绝版时装"/utf8>>,product_type = 6,product_subtype = 1,money = 68,associate_list = [{4,1}],about = "",show_condition = []};

get_product(154) ->
	#base_recharge_product{product_id = 154,product_name = <<"主角光环"/utf8>>,product_type = 6,product_subtype = 1,money = 88,associate_list = [],about = "",show_condition = []};

get_product(200) ->
	#base_recharge_product{product_id = 200,product_name = <<"神龙雕像"/utf8>>,product_type = 6,product_subtype = 1,money = 68,associate_list = [],about = "",show_condition = []};

get_product(201) ->
	#base_recharge_product{product_id = 201,product_name = <<"一星龙玉"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(202) ->
	#base_recharge_product{product_id = 202,product_name = <<"二星龙玉"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(203) ->
	#base_recharge_product{product_id = 203,product_name = <<"三星龙玉"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(204) ->
	#base_recharge_product{product_id = 204,product_name = <<"四星龙玉"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(205) ->
	#base_recharge_product{product_id = 205,product_name = <<"五星龙玉"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(206) ->
	#base_recharge_product{product_id = 206,product_name = <<"六星龙玉"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(207) ->
	#base_recharge_product{product_id = 207,product_name = <<"七星龙玉"/utf8>>,product_type = 6,product_subtype = 1,money = 68,associate_list = [],about = "",show_condition = []};

get_product(208) ->
	#base_recharge_product{product_id = 208,product_name = <<"龙玉觉醒"/utf8>>,product_type = 6,product_subtype = 1,money = 30,associate_list = [],about = "",show_condition = []};

get_product(_Productid) ->
	[].

get_all_product_ids() ->
[0,2,3,4,5,6,7,8,40,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,120,121,122,123,130,131,132,133,141,142,143,144,145,150,151,152,153,154,200,201,202,203,204,205,206,207,208].

get_product_ids_by_type(5,1) ->
[0,50,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,120,121,122,123];

get_product_ids_by_type(1,1) ->
[2,3,4,5,6,7,8];

get_product_ids_by_type(4,1) ->
[40];

get_product_ids_by_type(6,1) ->
[51,52,53,54,55,56,57,58,130,131,132,133,141,142,143,144,145,150,151,152,153,154,200,201,202,203,204,205,206,207,208];

get_product_ids_by_type(6,3) ->
[107];

get_product_ids_by_type(6,2) ->
[108];

get_product_ids_by_type(_Producttype,_Productsubtype) ->
	[].

get_product_ctrl(0) ->
	#base_recharge_product_ctrl{product_id = 0,start_time = 1497628800,end_time = 1513264429,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(2) ->
	#base_recharge_product_ctrl{product_id = 2,start_time = 1513180800,end_time = 1513264429,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(3) ->
	#base_recharge_product_ctrl{product_id = 3,start_time = 1513323030,end_time = 1513264429,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(4) ->
	#base_recharge_product_ctrl{product_id = 4,start_time = 1513267200,end_time = 1513264429,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(5) ->
	#base_recharge_product_ctrl{product_id = 5,start_time = 1513328400,end_time = 1513264429,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(6) ->
	#base_recharge_product_ctrl{product_id = 6,start_time = 1513320689,end_time = 1513264429,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(7) ->
	#base_recharge_product_ctrl{product_id = 7,start_time = 1513267200,end_time = 1513264429,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(8) ->
	#base_recharge_product_ctrl{product_id = 8,start_time = 1513267200,end_time = 1513264429,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(40) ->
	#base_recharge_product_ctrl{product_id = 40,start_time = 0,end_time = 0,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(50) ->
	#base_recharge_product_ctrl{product_id = 50,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(51) ->
	#base_recharge_product_ctrl{product_id = 51,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(52) ->
	#base_recharge_product_ctrl{product_id = 52,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(53) ->
	#base_recharge_product_ctrl{product_id = 53,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(54) ->
	#base_recharge_product_ctrl{product_id = 54,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(55) ->
	#base_recharge_product_ctrl{product_id = 55,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(56) ->
	#base_recharge_product_ctrl{product_id = 56,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(57) ->
	#base_recharge_product_ctrl{product_id = 57,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(58) ->
	#base_recharge_product_ctrl{product_id = 58,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(59) ->
	#base_recharge_product_ctrl{product_id = 59,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(60) ->
	#base_recharge_product_ctrl{product_id = 60,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(61) ->
	#base_recharge_product_ctrl{product_id = 61,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(62) ->
	#base_recharge_product_ctrl{product_id = 62,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(63) ->
	#base_recharge_product_ctrl{product_id = 63,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(64) ->
	#base_recharge_product_ctrl{product_id = 64,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(65) ->
	#base_recharge_product_ctrl{product_id = 65,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(66) ->
	#base_recharge_product_ctrl{product_id = 66,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(67) ->
	#base_recharge_product_ctrl{product_id = 67,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(68) ->
	#base_recharge_product_ctrl{product_id = 68,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(69) ->
	#base_recharge_product_ctrl{product_id = 69,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(70) ->
	#base_recharge_product_ctrl{product_id = 70,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(71) ->
	#base_recharge_product_ctrl{product_id = 71,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(72) ->
	#base_recharge_product_ctrl{product_id = 72,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(73) ->
	#base_recharge_product_ctrl{product_id = 73,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(74) ->
	#base_recharge_product_ctrl{product_id = 74,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(75) ->
	#base_recharge_product_ctrl{product_id = 75,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(76) ->
	#base_recharge_product_ctrl{product_id = 76,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(77) ->
	#base_recharge_product_ctrl{product_id = 77,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(78) ->
	#base_recharge_product_ctrl{product_id = 78,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(79) ->
	#base_recharge_product_ctrl{product_id = 79,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(80) ->
	#base_recharge_product_ctrl{product_id = 80,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(81) ->
	#base_recharge_product_ctrl{product_id = 81,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(82) ->
	#base_recharge_product_ctrl{product_id = 82,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(83) ->
	#base_recharge_product_ctrl{product_id = 83,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(84) ->
	#base_recharge_product_ctrl{product_id = 84,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(85) ->
	#base_recharge_product_ctrl{product_id = 85,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(86) ->
	#base_recharge_product_ctrl{product_id = 86,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(87) ->
	#base_recharge_product_ctrl{product_id = 87,start_time = 1546272000,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(88) ->
	#base_recharge_product_ctrl{product_id = 88,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(89) ->
	#base_recharge_product_ctrl{product_id = 89,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(90) ->
	#base_recharge_product_ctrl{product_id = 90,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(91) ->
	#base_recharge_product_ctrl{product_id = 91,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(92) ->
	#base_recharge_product_ctrl{product_id = 92,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(93) ->
	#base_recharge_product_ctrl{product_id = 93,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(94) ->
	#base_recharge_product_ctrl{product_id = 94,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(95) ->
	#base_recharge_product_ctrl{product_id = 95,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(96) ->
	#base_recharge_product_ctrl{product_id = 96,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(97) ->
	#base_recharge_product_ctrl{product_id = 97,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(98) ->
	#base_recharge_product_ctrl{product_id = 98,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(99) ->
	#base_recharge_product_ctrl{product_id = 99,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(100) ->
	#base_recharge_product_ctrl{product_id = 100,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(101) ->
	#base_recharge_product_ctrl{product_id = 101,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(102) ->
	#base_recharge_product_ctrl{product_id = 102,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(103) ->
	#base_recharge_product_ctrl{product_id = 103,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(104) ->
	#base_recharge_product_ctrl{product_id = 104,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(105) ->
	#base_recharge_product_ctrl{product_id = 105,start_time = 1564653670,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(106) ->
	#base_recharge_product_ctrl{product_id = 106,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(107) ->
	#base_recharge_product_ctrl{product_id = 107,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(108) ->
	#base_recharge_product_ctrl{product_id = 108,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(120) ->
	#base_recharge_product_ctrl{product_id = 120,start_time = 1564653670,end_time = 1913623278,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(121) ->
	#base_recharge_product_ctrl{product_id = 121,start_time = 1561910400,end_time = 1913623278,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(122) ->
	#base_recharge_product_ctrl{product_id = 122,start_time = 1561910400,end_time = 1913623278,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(123) ->
	#base_recharge_product_ctrl{product_id = 123,start_time = 1561910400,end_time = 1913623278,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(130) ->
	#base_recharge_product_ctrl{product_id = 130,start_time = 1561910400,end_time = 1893462649,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(131) ->
	#base_recharge_product_ctrl{product_id = 131,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(132) ->
	#base_recharge_product_ctrl{product_id = 132,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(133) ->
	#base_recharge_product_ctrl{product_id = 133,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(141) ->
	#base_recharge_product_ctrl{product_id = 141,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(142) ->
	#base_recharge_product_ctrl{product_id = 142,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(143) ->
	#base_recharge_product_ctrl{product_id = 143,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(144) ->
	#base_recharge_product_ctrl{product_id = 144,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(145) ->
	#base_recharge_product_ctrl{product_id = 145,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(150) ->
	#base_recharge_product_ctrl{product_id = 150,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(151) ->
	#base_recharge_product_ctrl{product_id = 151,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(152) ->
	#base_recharge_product_ctrl{product_id = 152,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(153) ->
	#base_recharge_product_ctrl{product_id = 153,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(154) ->
	#base_recharge_product_ctrl{product_id = 154,start_time = 1561910400,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(200) ->
	#base_recharge_product_ctrl{product_id = 200,start_time = 1667094291,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(201) ->
	#base_recharge_product_ctrl{product_id = 201,start_time = 1667094291,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(202) ->
	#base_recharge_product_ctrl{product_id = 202,start_time = 1667094291,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(203) ->
	#base_recharge_product_ctrl{product_id = 203,start_time = 1667094291,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(204) ->
	#base_recharge_product_ctrl{product_id = 204,start_time = 1667094291,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(205) ->
	#base_recharge_product_ctrl{product_id = 205,start_time = 1667094291,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(206) ->
	#base_recharge_product_ctrl{product_id = 206,start_time = 1667094291,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(207) ->
	#base_recharge_product_ctrl{product_id = 207,start_time = 1667094291,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(208) ->
	#base_recharge_product_ctrl{product_id = 208,start_time = 1667094291,end_time = 1893427201,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(999) ->
	#base_recharge_product_ctrl{product_id = 999,start_time = 1513180800,end_time = 1513264429,week_time_list = [],month_time_list = [],open_begin = 0,open_end = 0,merge_begin = 0,merge_end = 0,serv_lv_begin = 0,serv_lv_end = 0,condition = []};

get_product_ctrl(_Productid) ->
	[].

get_product_id() ->
[0,2,3,4,5,6,7,8,40,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,120,121,122,123,130,131,132,133,141,142,143,144,145,150,151,152,153,154,200,201,202,203,204,205,206,207,208,999].

get_recharge_return(2,1) ->
	#base_recharge_return{product_id = 2,return_type = 1,gold = 60,return_gold = 60};

get_recharge_return(2,2) ->
	#base_recharge_return{product_id = 2,return_type = 2,gold = 60,return_gold = 60};

get_recharge_return(3,1) ->
	#base_recharge_return{product_id = 3,return_type = 1,gold = 300,return_gold = 300};

get_recharge_return(3,2) ->
	#base_recharge_return{product_id = 3,return_type = 2,gold = 300,return_gold = 300};

get_recharge_return(4,1) ->
	#base_recharge_return{product_id = 4,return_type = 1,gold = 680,return_gold = 680};

get_recharge_return(4,2) ->
	#base_recharge_return{product_id = 4,return_type = 2,gold = 680,return_gold = 680};

get_recharge_return(5,1) ->
	#base_recharge_return{product_id = 5,return_type = 1,gold = 1280,return_gold = 1280};

get_recharge_return(5,2) ->
	#base_recharge_return{product_id = 5,return_type = 2,gold = 1280,return_gold = 1280};

get_recharge_return(6,1) ->
	#base_recharge_return{product_id = 6,return_type = 1,gold = 1980,return_gold = 1980};

get_recharge_return(6,2) ->
	#base_recharge_return{product_id = 6,return_type = 2,gold = 1980,return_gold = 1980};

get_recharge_return(7,1) ->
	#base_recharge_return{product_id = 7,return_type = 1,gold = 3280,return_gold = 3280};

get_recharge_return(7,2) ->
	#base_recharge_return{product_id = 7,return_type = 2,gold = 3280,return_gold = 3280};

get_recharge_return(8,1) ->
	#base_recharge_return{product_id = 8,return_type = 1,gold = 6480,return_gold = 6480};

get_recharge_return(8,2) ->
	#base_recharge_return{product_id = 8,return_type = 2,gold = 6480,return_gold = 6480};

get_recharge_return(999,1) ->
	#base_recharge_return{product_id = 999,return_type = 1,gold = 180,return_gold = 180};

get_recharge_return(999,2) ->
	#base_recharge_return{product_id = 999,return_type = 2,gold = 180,return_gold = 180};

get_recharge_return(_Productid,_Returntype) ->
	[].

get_recharge_return_keys() ->
[2,3,4,5,6,7,8,999].


get_return_type_by_product_id(2) ->
[1,2];


get_return_type_by_product_id(3) ->
[1,2];


get_return_type_by_product_id(4) ->
[1,2];


get_return_type_by_product_id(5) ->
[1,2];


get_return_type_by_product_id(6) ->
[1,2];


get_return_type_by_product_id(7) ->
[1,2];


get_return_type_by_product_id(8) ->
[1,2];


get_return_type_by_product_id(999) ->
[1,2];

get_return_type_by_product_id(_Productid) ->
	[].

get_recharge_first_ids() ->
[40].

get_recharge_first(40,1,1) ->
[{1,[{100,1101015062,1},{0,12010003,1},{0,38420001,1},{0,38160001,1},{0,37020002,1},{0,16020002,1}]},{3,[{100,1103015062,1},{0,12010003,1},{0,38420001,1},{0,38160001,1},{0,37020002,1},{0,16020002,1}]}];

get_recharge_first(40,1,2) ->
[{1,[{100,34010459,1},{0,37090001,1},{0,37020002,1},{3,0,300000},{0,32010127,1}]},{3,[{100,34010459,1},{0,37090001,1},{0,37020002,1},{3,0,300000},{0,32010127,1}]}];

get_recharge_first(40,1,3) ->
[{1,[{100,34010459,1},{100,12020003,1},{0,36255007,10},{0,16010001,1},{0,38040005,50}]},{3,[{100,34010459,1},{100,12020003,1},{0,36255007,10},{0,16010001,1},{0,38040005,50}]}];

get_recharge_first(40,2,1) ->
[{2,[{100,1102015062,1},{0,12010003,1},{0,38420001,1},{0,38160001,1},{0,37020002,1},{0,16020002,1}]},{4,[{100,1104015062,1},{0,12010003,1},{0,38420001,1},{0,38160001,1},{0,37020002,1},{0,16020002,1}]}];

get_recharge_first(40,2,2) ->
[{2,[{100,34010459,1},{0,37090001,1},{0,37020002,1},{3,0,300000},{0,32010127,1}]},{4,[{100,34010459,1},{0,37090001,1},{0,37020002,1},{3,0,300000},{0,32010127,1}]}];

get_recharge_first(40,2,3) ->
[{2,[{100,34010459,1},{100,12020003,1},{0,36255007,10},{0,16010001,1},{0,38040005,50}]},{4,[{100,34010459,1},{100,12020003,1},{0,36255007,10},{0,16010001,1},{0,38040005,50}]}];

get_recharge_first(_Productid,_Type,_Index) ->
	[].

get_index_list(40,1) ->
[1,2,3];

get_index_list(40,2) ->
[1,2,3];

get_index_list(_Productid,_Type) ->
	[].

get_recharge_first_language_id(40,1,1) ->
1;

get_recharge_first_language_id(40,1,2) ->
2;

get_recharge_first_language_id(40,1,3) ->
3;

get_recharge_first_language_id(40,2,1) ->
1;

get_recharge_first_language_id(40,2,2) ->
2;

get_recharge_first_language_id(40,2,3) ->
3;

get_recharge_first_language_id(_Productid,_Type,_Index) ->
	0.

get_max_index(40,1) -> 3;
get_max_index(40,2) -> 3;
get_max_index(_Product_id,_Type) -> 0.

get_product_vip_exp(_Productid) ->
	[].


get_value_of_gold(51) ->
680;


get_value_of_gold(52) ->
880;


get_value_of_gold(53) ->
880;


get_value_of_gold(54) ->
1280;


get_value_of_gold(55) ->
10;


get_value_of_gold(56) ->
30;


get_value_of_gold(57) ->
60;


get_value_of_gold(58) ->
80;


get_value_of_gold(107) ->
80;


get_value_of_gold(108) ->
250;


get_value_of_gold(130) ->
60;


get_value_of_gold(131) ->
300;


get_value_of_gold(132) ->
680;


get_value_of_gold(133) ->
1280;


get_value_of_gold(141) ->
300;


get_value_of_gold(142) ->
300;


get_value_of_gold(143) ->
300;


get_value_of_gold(144) ->
300;


get_value_of_gold(145) ->
680;


get_value_of_gold(150) ->
3280;


get_value_of_gold(151) ->
1980;


get_value_of_gold(152) ->
1680;


get_value_of_gold(153) ->
680;


get_value_of_gold(154) ->
880;


get_value_of_gold(200) ->
680;


get_value_of_gold(201) ->
300;


get_value_of_gold(202) ->
300;


get_value_of_gold(203) ->
300;


get_value_of_gold(204) ->
300;


get_value_of_gold(205) ->
300;


get_value_of_gold(206) ->
300;


get_value_of_gold(207) ->
680;


get_value_of_gold(208) ->
300;

get_value_of_gold(_Rechargeid) ->
	0.

