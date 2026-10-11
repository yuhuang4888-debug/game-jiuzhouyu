%%%---------------------------------------
%%% module      : data_level_act
%%% description : 等级抢购商城配置
%%%
%%%---------------------------------------
-module(data_level_act).
-compile(export_all).
-include("level_rush_act.hrl").



get_act_cfg(1,1) ->
	#base_lv_act_open{act_type = 1,act_subtype = 1,act_name = <<"宝石抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61208},{title, uidjqg_004h},{act_type,1},{gap,172800},{cycle_gap,604800},{cycle_time,2},{push_times,4}],circuit = 1,clear_type = 1};

get_act_cfg(2,1) ->
	#base_lv_act_open{act_type = 2,act_subtype = 1,act_name = <<"御魂抢购"/utf8>>,open_lv = 120,continue_time = 3,conditions = [{pic, 61210},{title, uidjqg_004i},{open_day,6},{act_type,1},{gap,172800},{cycle_gap,604800},{cycle_time,2},{push_times,4}],circuit = 1,clear_type = 1};

get_act_cfg(3,1) ->
	#base_lv_act_open{act_type = 3,act_subtype = 1,act_name = <<"神纹抢购"/utf8>>,open_lv = 270,continue_time = 3,conditions = [{pic, 61211},{title, uidjqg_004j},{open_day,7},{act_type,1},{gap,172800},{cycle_gap,604800},{cycle_time,2},{push_times,4}],circuit = 1,clear_type = 1};

get_act_cfg(4,1) ->
	#base_lv_act_open{act_type = 4,act_subtype = 1,act_name = <<"蜃妖抢购"/utf8>>,open_lv = 320,continue_time = 3,conditions = [{pic, 61209},{title, uidjqg_004k},{open_day,8},{act_type,1},{gap,172800},{cycle_gap,604800},{cycle_time,2},{push_times,4}],circuit = 1,clear_type = 1};

get_act_cfg(5,1) ->
	#base_lv_act_open{act_type = 5,act_subtype = 1,act_name = <<"宝宝抢购"/utf8>>,open_lv = 305,continue_time = 3,conditions = [{pic, 61201},{title, uidjqg_004l},{act_type,1},{gap,172800},{cycle_gap,604800},{cycle_time,2},{push_times,4}],circuit = 0,clear_type = 1};

get_act_cfg(6,1) ->
	#base_lv_act_open{act_type = 6,act_subtype = 1,act_name = <<"降神抢购"/utf8>>,open_lv = 400,continue_time = 5,conditions = [{pic, 61202},{title, uidjqg_004m},{act_type,1},{gap,172800},{cycle_gap,604800},{cycle_time,2},{push_times,4}],circuit = 1,clear_type = 1};

get_act_cfg(7,1) ->
	#base_lv_act_open{act_type = 7,act_subtype = 1,act_name = <<"妖灵抢购"/utf8>>,open_lv = 450,continue_time = 5,conditions = [{pic, 61203},{title, uidjqg_004n},{act_type,1},{gap,172800},{cycle_gap,604800},{cycle_time,2},{push_times,4}],circuit = 1,clear_type = 1};

get_act_cfg(8,1) ->
	#base_lv_act_open{act_type = 8,act_subtype = 1,act_name = <<"圣衣抢购"/utf8>>,open_lv = 580,continue_time = 7,conditions = [{pic, 61207},{title, uidjqg_004p},{act_type,1},{gap,172800},{cycle_gap,604800},{cycle_time,2},{push_times,4}],circuit = 1,clear_type = 1};

get_act_cfg(9,1) ->
	#base_lv_act_open{act_type = 9,act_subtype = 1,act_name = <<"神祭抢购"/utf8>>,open_lv = 660,continue_time = 7,conditions = [{pic, 61206},{title, uidjqg_004o},{act_type,1},{gap,172800},{cycle_gap,604800},{cycle_time,2},{push_times,4}],circuit = 1,clear_type = 1};

get_act_cfg(10,1) ->
	#base_lv_act_open{act_type = 10,act_subtype = 1,act_name = <<"背饰抢购"/utf8>>,open_lv = 280,continue_time = 2,conditions = [{pic, 61212},{title, uidjqg_004q},{open_day,6},{act_type,1},{gap,172800},{cycle_gap,604800},{cycle_time,2},{push_times,4}],circuit = 1,clear_type = 1};

get_act_cfg(63,1) ->
	#base_lv_act_open{act_type = 63,act_subtype = 1,act_name = <<"合服抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61204},{title, uidjqg_004e},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(63,2) ->
	#base_lv_act_open{act_type = 63,act_subtype = 2,act_name = <<"合服抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61204},{title, uidjqg_004e},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(63,3) ->
	#base_lv_act_open{act_type = 63,act_subtype = 3,act_name = <<"合服抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61204},{title, uidjqg_004e},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(63,4) ->
	#base_lv_act_open{act_type = 63,act_subtype = 4,act_name = <<"合服抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61204},{title, uidjqg_004e},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(66,1) ->
	#base_lv_act_open{act_type = 66,act_subtype = 1,act_name = <<"超值推荐"/utf8>>,open_lv = 50,continue_time = 300,conditions = [{pic,61205},{cd, 180},{need_paid, 1}],circuit = 0,clear_type = 1};

get_act_cfg(75,1) ->
	#base_lv_act_open{act_type = 75,act_subtype = 1,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,2) ->
	#base_lv_act_open{act_type = 75,act_subtype = 2,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,3) ->
	#base_lv_act_open{act_type = 75,act_subtype = 3,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,4) ->
	#base_lv_act_open{act_type = 75,act_subtype = 4,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,5) ->
	#base_lv_act_open{act_type = 75,act_subtype = 5,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,6) ->
	#base_lv_act_open{act_type = 75,act_subtype = 6,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,7) ->
	#base_lv_act_open{act_type = 75,act_subtype = 7,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,8) ->
	#base_lv_act_open{act_type = 75,act_subtype = 8,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,9) ->
	#base_lv_act_open{act_type = 75,act_subtype = 9,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,10) ->
	#base_lv_act_open{act_type = 75,act_subtype = 10,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,11) ->
	#base_lv_act_open{act_type = 75,act_subtype = 11,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,12) ->
	#base_lv_act_open{act_type = 75,act_subtype = 12,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,13) ->
	#base_lv_act_open{act_type = 75,act_subtype = 13,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,14) ->
	#base_lv_act_open{act_type = 75,act_subtype = 14,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,15) ->
	#base_lv_act_open{act_type = 75,act_subtype = 15,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,16) ->
	#base_lv_act_open{act_type = 75,act_subtype = 16,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,17) ->
	#base_lv_act_open{act_type = 75,act_subtype = 17,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,18) ->
	#base_lv_act_open{act_type = 75,act_subtype = 18,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,19) ->
	#base_lv_act_open{act_type = 75,act_subtype = 19,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,20) ->
	#base_lv_act_open{act_type = 75,act_subtype = 20,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,21) ->
	#base_lv_act_open{act_type = 75,act_subtype = 21,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,22) ->
	#base_lv_act_open{act_type = 75,act_subtype = 22,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,23) ->
	#base_lv_act_open{act_type = 75,act_subtype = 23,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,24) ->
	#base_lv_act_open{act_type = 75,act_subtype = 24,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,25) ->
	#base_lv_act_open{act_type = 75,act_subtype = 25,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,26) ->
	#base_lv_act_open{act_type = 75,act_subtype = 26,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,27) ->
	#base_lv_act_open{act_type = 75,act_subtype = 27,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,28) ->
	#base_lv_act_open{act_type = 75,act_subtype = 28,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,29) ->
	#base_lv_act_open{act_type = 75,act_subtype = 29,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,30) ->
	#base_lv_act_open{act_type = 75,act_subtype = 30,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,31) ->
	#base_lv_act_open{act_type = 75,act_subtype = 31,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,32) ->
	#base_lv_act_open{act_type = 75,act_subtype = 32,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,33) ->
	#base_lv_act_open{act_type = 75,act_subtype = 33,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,34) ->
	#base_lv_act_open{act_type = 75,act_subtype = 34,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,35) ->
	#base_lv_act_open{act_type = 75,act_subtype = 35,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,36) ->
	#base_lv_act_open{act_type = 75,act_subtype = 36,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,37) ->
	#base_lv_act_open{act_type = 75,act_subtype = 37,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,38) ->
	#base_lv_act_open{act_type = 75,act_subtype = 38,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,39) ->
	#base_lv_act_open{act_type = 75,act_subtype = 39,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,40) ->
	#base_lv_act_open{act_type = 75,act_subtype = 40,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,41) ->
	#base_lv_act_open{act_type = 75,act_subtype = 41,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,42) ->
	#base_lv_act_open{act_type = 75,act_subtype = 42,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,43) ->
	#base_lv_act_open{act_type = 75,act_subtype = 43,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,44) ->
	#base_lv_act_open{act_type = 75,act_subtype = 44,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,45) ->
	#base_lv_act_open{act_type = 75,act_subtype = 45,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,46) ->
	#base_lv_act_open{act_type = 75,act_subtype = 46,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,47) ->
	#base_lv_act_open{act_type = 75,act_subtype = 47,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,48) ->
	#base_lv_act_open{act_type = 75,act_subtype = 48,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,49) ->
	#base_lv_act_open{act_type = 75,act_subtype = 49,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,50) ->
	#base_lv_act_open{act_type = 75,act_subtype = 50,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,51) ->
	#base_lv_act_open{act_type = 75,act_subtype = 51,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,52) ->
	#base_lv_act_open{act_type = 75,act_subtype = 52,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,53) ->
	#base_lv_act_open{act_type = 75,act_subtype = 53,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,54) ->
	#base_lv_act_open{act_type = 75,act_subtype = 54,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,55) ->
	#base_lv_act_open{act_type = 75,act_subtype = 55,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,56) ->
	#base_lv_act_open{act_type = 75,act_subtype = 56,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,57) ->
	#base_lv_act_open{act_type = 75,act_subtype = 57,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,58) ->
	#base_lv_act_open{act_type = 75,act_subtype = 58,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,59) ->
	#base_lv_act_open{act_type = 75,act_subtype = 59,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,60) ->
	#base_lv_act_open{act_type = 75,act_subtype = 60,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,61) ->
	#base_lv_act_open{act_type = 75,act_subtype = 61,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,62) ->
	#base_lv_act_open{act_type = 75,act_subtype = 62,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,63) ->
	#base_lv_act_open{act_type = 75,act_subtype = 63,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,64) ->
	#base_lv_act_open{act_type = 75,act_subtype = 64,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,65) ->
	#base_lv_act_open{act_type = 75,act_subtype = 65,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,66) ->
	#base_lv_act_open{act_type = 75,act_subtype = 66,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,67) ->
	#base_lv_act_open{act_type = 75,act_subtype = 67,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,68) ->
	#base_lv_act_open{act_type = 75,act_subtype = 68,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,69) ->
	#base_lv_act_open{act_type = 75,act_subtype = 69,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,70) ->
	#base_lv_act_open{act_type = 75,act_subtype = 70,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,71) ->
	#base_lv_act_open{act_type = 75,act_subtype = 71,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,72) ->
	#base_lv_act_open{act_type = 75,act_subtype = 72,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,73) ->
	#base_lv_act_open{act_type = 75,act_subtype = 73,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,74) ->
	#base_lv_act_open{act_type = 75,act_subtype = 74,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,75) ->
	#base_lv_act_open{act_type = 75,act_subtype = 75,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,76) ->
	#base_lv_act_open{act_type = 75,act_subtype = 76,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,77) ->
	#base_lv_act_open{act_type = 75,act_subtype = 77,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,78) ->
	#base_lv_act_open{act_type = 75,act_subtype = 78,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,79) ->
	#base_lv_act_open{act_type = 75,act_subtype = 79,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,80) ->
	#base_lv_act_open{act_type = 75,act_subtype = 80,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,81) ->
	#base_lv_act_open{act_type = 75,act_subtype = 81,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,82) ->
	#base_lv_act_open{act_type = 75,act_subtype = 82,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,83) ->
	#base_lv_act_open{act_type = 75,act_subtype = 83,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,84) ->
	#base_lv_act_open{act_type = 75,act_subtype = 84,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,85) ->
	#base_lv_act_open{act_type = 75,act_subtype = 85,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,86) ->
	#base_lv_act_open{act_type = 75,act_subtype = 86,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,87) ->
	#base_lv_act_open{act_type = 75,act_subtype = 87,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,88) ->
	#base_lv_act_open{act_type = 75,act_subtype = 88,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,89) ->
	#base_lv_act_open{act_type = 75,act_subtype = 89,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,90) ->
	#base_lv_act_open{act_type = 75,act_subtype = 90,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,91) ->
	#base_lv_act_open{act_type = 75,act_subtype = 91,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,92) ->
	#base_lv_act_open{act_type = 75,act_subtype = 92,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,93) ->
	#base_lv_act_open{act_type = 75,act_subtype = 93,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,94) ->
	#base_lv_act_open{act_type = 75,act_subtype = 94,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,95) ->
	#base_lv_act_open{act_type = 75,act_subtype = 95,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,96) ->
	#base_lv_act_open{act_type = 75,act_subtype = 96,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,97) ->
	#base_lv_act_open{act_type = 75,act_subtype = 97,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,98) ->
	#base_lv_act_open{act_type = 75,act_subtype = 98,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,99) ->
	#base_lv_act_open{act_type = 75,act_subtype = 99,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,100) ->
	#base_lv_act_open{act_type = 75,act_subtype = 100,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,101) ->
	#base_lv_act_open{act_type = 75,act_subtype = 101,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,102) ->
	#base_lv_act_open{act_type = 75,act_subtype = 102,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,103) ->
	#base_lv_act_open{act_type = 75,act_subtype = 103,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,104) ->
	#base_lv_act_open{act_type = 75,act_subtype = 104,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,105) ->
	#base_lv_act_open{act_type = 75,act_subtype = 105,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,106) ->
	#base_lv_act_open{act_type = 75,act_subtype = 106,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,107) ->
	#base_lv_act_open{act_type = 75,act_subtype = 107,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,108) ->
	#base_lv_act_open{act_type = 75,act_subtype = 108,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,109) ->
	#base_lv_act_open{act_type = 75,act_subtype = 109,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,110) ->
	#base_lv_act_open{act_type = 75,act_subtype = 110,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,111) ->
	#base_lv_act_open{act_type = 75,act_subtype = 111,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,112) ->
	#base_lv_act_open{act_type = 75,act_subtype = 112,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,113) ->
	#base_lv_act_open{act_type = 75,act_subtype = 113,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,114) ->
	#base_lv_act_open{act_type = 75,act_subtype = 114,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,115) ->
	#base_lv_act_open{act_type = 75,act_subtype = 115,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,116) ->
	#base_lv_act_open{act_type = 75,act_subtype = 116,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,117) ->
	#base_lv_act_open{act_type = 75,act_subtype = 117,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,118) ->
	#base_lv_act_open{act_type = 75,act_subtype = 118,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,119) ->
	#base_lv_act_open{act_type = 75,act_subtype = 119,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(75,120) ->
	#base_lv_act_open{act_type = 75,act_subtype = 120,act_name = <<"限时抢购"/utf8>>,open_lv = 150,continue_time = 3,conditions = [{pic, 61224},{title,uidjqg_004g},{act_open},{act_type,2}],circuit = 1,clear_type = 1};

get_act_cfg(_Acttype,_Actsubtype) ->
	[].

get_all_lv_limit() ->
[150,120,270,320,305,400,450,580,660,280,50].


get_act_info(150) ->
[{1,1},{63,1},{63,2},{63,3},{63,4},{75,1},{75,2},{75,3},{75,4},{75,5},{75,6},{75,7},{75,8},{75,9},{75,10},{75,11},{75,12},{75,13},{75,14},{75,15},{75,16},{75,17},{75,18},{75,19},{75,20},{75,21},{75,22},{75,23},{75,24},{75,25},{75,26},{75,27},{75,28},{75,29},{75,30},{75,31},{75,32},{75,33},{75,34},{75,35},{75,36},{75,37},{75,38},{75,39},{75,40},{75,41},{75,42},{75,43},{75,44},{75,45},{75,46},{75,47},{75,48},{75,49},{75,50},{75,51},{75,52},{75,53},{75,54},{75,55},{75,56},{75,57},{75,58},{75,59},{75,60},{75,61},{75,62},{75,63},{75,64},{75,65},{75,66},{75,67},{75,68},{75,69},{75,70},{75,71},{75,72},{75,73},{75,74},{75,75},{75,76},{75,77},{75,78},{75,79},{75,80},{75,81},{75,82},{75,83},{75,84},{75,85},{75,86},{75,87},{75,88},{75,89},{75,90},{75,91},{75,92},{75,93},{75,94},{75,95},{75,96},{75,97},{75,98},{75,99},{75,100},{75,101},{75,102},{75,103},{75,104},{75,105},{75,106},{75,107},{75,108},{75,109},{75,110},{75,111},{75,112},{75,113},{75,114},{75,115},{75,116},{75,117},{75,118},{75,119},{75,120}];


get_act_info(120) ->
[{2,1}];


get_act_info(270) ->
[{3,1}];


get_act_info(320) ->
[{4,1}];


get_act_info(305) ->
[{5,1}];


get_act_info(400) ->
[{6,1}];


get_act_info(450) ->
[{7,1}];


get_act_info(580) ->
[{8,1}];


get_act_info(660) ->
[{9,1}];


get_act_info(280) ->
[{10,1}];


get_act_info(50) ->
[{66,1}];

get_act_info(_Openlv) ->
	[].


get_act_subtype(1) ->
[1];


get_act_subtype(2) ->
[1];


get_act_subtype(3) ->
[1];


get_act_subtype(4) ->
[1];


get_act_subtype(5) ->
[1];


get_act_subtype(6) ->
[1];


get_act_subtype(7) ->
[1];


get_act_subtype(8) ->
[1];


get_act_subtype(9) ->
[1];


get_act_subtype(10) ->
[1];


get_act_subtype(63) ->
[1,2,3,4];


get_act_subtype(66) ->
[1];


get_act_subtype(75) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120];

get_act_subtype(_Acttype) ->
	[].

get_act_reward_cfg(1,1,1) ->
	#base_lv_act_reward{act_type = 1,act_subtype = 1,reward_name = <<"超值宝石"/utf8>>,grade = 1,normal_cost = 360,cost = 88,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_051},{tips_show,uiqg_wz_051},{tab_show,uiqg_yq_051,uiqg_tb_051},{tab_mark,tab1}],reward = [{0,14010002,1},{0,14010002,1},{0,14020002,1},{0,14020002,1},{0,14020002,1},{0,14020002,1}],condition = [{tv, 612, 1},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(1,1,2) ->
	#base_lv_act_reward{act_type = 1,act_subtype = 1,reward_name = <<"珍稀宝石"/utf8>>,grade = 2,normal_cost = 1680,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_052},{tips_show,uiqg_wz_052},{tab_show,uiqg_yq_052,uiqg_tb_052},{tab_mark,tab2}],reward = [{0,14010004,1},{0,14020004,1},{0,14010003,1},{0,14020003,1},{3,0,500000},{3,0,500000},{3,0,500000},{3,0,500000}],condition = [{tv, 612, 1},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(1,1,3) ->
	#base_lv_act_reward{act_type = 1,act_subtype = 1,reward_name = <<"宝石直升礼包"/utf8>>,grade = 3,normal_cost = 1880,cost = 638,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_053},{tips_show,uiqg_wz_053},{tab_show,uiqg_yq_053,uiqg_tb_053},{tab_mark,tab3}],reward = [{0,14110007,1},{0,14010003,1},{0,14010003,1},{0,14020003,1},{0,14020003,1},{3,0,500000},{3,0,500000},{3,0,500000}],condition = [{tv, 612, 1},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(2,1,1) ->
	#base_lv_act_reward{act_type = 2,act_subtype = 1,reward_name = <<"御魂升阶"/utf8>>,grade = 1,normal_cost = 1200,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_057},{tips_show,uiqg_wz_057},{tab_show,uiqg_yq_057,uiqg_tb_057},{tab_mark,tab1}],reward = [{0,26990005,1},{0,26990005,1},{0,36255006,2},{0,36255006,2},{0,26990002,1},{0,26990002,1},{0,26990002,1},{0,26990002,1}],condition = [{tv, 612, 2},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(2,1,2) ->
	#base_lv_act_reward{act_type = 2,act_subtype = 1,reward_name = <<"超值秘钥"/utf8>>,grade = 2,normal_cost = 2000,cost = 388,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_058},{tips_show,uiqg_wz_058},{tab_show,uiqg_yq_058,uiqg_tb_058},{tab_mark,tab2}],reward = [{0,36255000,1},{0,38040012,100},{0,38040012,100},{0,26990004,1},{0,26990002,1},{0,26990002,1},{0,26990002,1},{0,26990002,1}],condition = [{tv, 612, 2},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(2,1,3) ->
	#base_lv_act_reward{act_type = 2,act_subtype = 1,reward_name = <<"超强御魂"/utf8>>,grade = 3,normal_cost = 3000,cost = 888,string = <<"3"/utf8>>,show = [{show,goods_id,26050004},{tips_show,uiqg_wz_059},{tab_show,uiqg_yq_059,uiqg_tb_059},{tab_mark,tab3}],reward = [{0,26050004,1},{0,36255006,5},{0,36255006,2},{0,36255006,1},{0,26990002,1},{0,26990002,1},{0,26990002,1},{0,26990002,1}],condition = [{tv, 612, 2},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(3,1,1) ->
	#base_lv_act_reward{act_type = 3,act_subtype = 1,reward_name = <<"神纹升阶"/utf8>>,grade = 1,normal_cost = 260,cost = 108,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_060},{tips_show,uiqg_wz_060},{tab_show,uiqg_yq_060,uiqg_tb_060},{tab_mark,tab1}],reward = [{0,38040030,10},{0,38040030,5},{0,38040030,5},{255,36255025,50},{255,36255025,50},{255,36255025,20},{255,36255025,20},{255,36255025,10}],condition = [{tv, 612, 3},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(3,1,2) ->
	#base_lv_act_reward{act_type = 3,act_subtype = 1,reward_name = <<"进阶神纹"/utf8>>,grade = 2,normal_cost = 800,cost = 288,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_061},{tips_show,uiqg_wz_061},{tab_show,uiqg_yq_061,uiqg_tb_061},{tab_mark,tab2}],reward = [{0,6320803,1},{0,38040030,10},{0,38040030,10},{0,38040030,10},{255,36255025,50},{255,36255025,20},{255,36255025,20},{255,36255025,10}],condition = [{tv, 612, 3},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(3,1,3) ->
	#base_lv_act_reward{act_type = 3,act_subtype = 1,reward_name = <<"增伤神纹"/utf8>>,grade = 3,normal_cost = 2400,cost = 688,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_062},{tips_show,uiqg_wz_062},{tab_show,uiqg_yq_062,uiqg_tb_062},{tab_mark,tab3}],reward = [{0,6431404,30},{0,38040030,20},{0,38040030,20},{0,38040030,20},{255,36255025,50},{255,36255025,50},{255,36255025,20},{255,36255025,10}],condition = [{tv, 612, 3},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(4,1,1) ->
	#base_lv_act_reward{act_type = 4,act_subtype = 1,reward_name = <<"蜃妖强化"/utf8>>,grade = 1,normal_cost = 500,cost = 138,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_054},{tips_show,uiqg_wz_054},{tab_show,uiqg_yq_054,uiqg_tb_054},{tab_mark,tab1}],reward = [{0,39510000,10},{0,39510000,10},{0,39510000,10},{0,39510000,10},{0,32010570,1},{0,32010571,1},{0,32010571,1},{0,32010571,1}],condition = [{tv, 612, 4},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(4,1,2) ->
	#base_lv_act_reward{act_type = 4,act_subtype = 1,reward_name = <<"蜃妖装备礼包"/utf8>>,grade = 2,normal_cost = 2200,cost = 688,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_055},{tips_show,uiqg_wz_055},{tab_show,uiqg_yq_055,uiqg_tb_055},{tab_mark,tab2}],reward = [{0,32010316,1},{0,32010316,1},{0,32010316,1},{0,39510000,10},{0,39510000,10},{0,39510000,10},{0,39510000,10},{0,39510000,10}],condition = [{tv, 612, 4},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(4,1,3) ->
	#base_lv_act_reward{act_type = 4,act_subtype = 1,reward_name = <<"豪华助战"/utf8>>,grade = 3,normal_cost = 12000,cost = 3288,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_056},{tips_show,uiqg_wz_056},{tab_show,uiqg_yq_056,uiqg_tb_056},{tab_mark,tab3}],reward = [{0,39510011,1},{0,32010316,1},{0,32010316,1},{0,39510000,10},{0,39510000,10},{0,39510000,10},{0,39510000,10},{0,39510000,10}],condition = [{tv, 612, 4},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(5,1,1) ->
	#base_lv_act_reward{act_type = 5,act_subtype = 1,reward_name = <<"超值果实礼包"/utf8>>,grade = 1,normal_cost = 1080,cost = 388,string = <<"1"/utf8>>,show = [{show,show_effect,ui_icon_effectglow8},{tips_show,uidjqg_005d},{tab_show,uidjqg_008d,uidjqg_010c}],reward = [{0,34010039,2},{0,34010038,2},{0,38040042,5},{0,38040041,4},{0,38040041,4},{0,38040041,4},{0,38040041,4},{0,38040041,4}],condition = [{tv, 612, 5},{cost_type,3}],recharge_id = 0};

get_act_reward_cfg(5,1,2) ->
	#base_lv_act_reward{act_type = 5,act_subtype = 1,reward_name = <<"神装宝具礼包"/utf8>>,grade = 2,normal_cost = 4000,cost = 988,string = <<"2"/utf8>>,show = [{show,show_effect,ui_icon_effectglow6},{tips_show,uidjqg_005e},{tab_show,uidjqg_008e,uidjqg_010d}],reward = [{0,34010039,2},{0,38040034,1},{0,38040034,1},{0,65020301,1},{0,38040032,5},{0,38040032,4},{0,38040032,3},{0,38040032,3}],condition = [{tv, 612, 5},{cost_type,3}],recharge_id = 0};

get_act_reward_cfg(5,1,3) ->
	#base_lv_act_reward{act_type = 5,act_subtype = 1,reward_name = <<"帅气皮肤礼包"/utf8>>,grade = 3,normal_cost = 8000,cost = 1888,string = <<"3"/utf8>>,show = [{show,show_model,{{9,901008}}},{tips_show,uidjqg_005f},{tab_show,uidjqg_008f,uidjqg_010e}],reward = [{0,68010004,15},{0,68010004,5},{0,68010004,5},{0,68010004,5},{0,34010040,2},{0,38040042,5},{0,38040032,5},{0,38040032,5}],condition = [{tv, 612, 5},{cost_type,3}],recharge_id = 0};

get_act_reward_cfg(6,1,1) ->
	#base_lv_act_reward{act_type = 6,act_subtype = 1,reward_name = <<"全套神器"/utf8>>,grade = 1,normal_cost = 1880,cost = 388,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_063},{tips_show,uiqg_wz_063},{tab_show,uiqg_yq_063,uiqg_tb_063},{tab_mark,tab1}],reward = [{0,32010573,2},{0,32010240,1},{0,32010239,1},{0,7110002,3},{0,7110002,2},{0,7110001,4},{0,7110001,4},{0,7110001,2}],condition = [{tv, 612, 6},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(6,1,2) ->
	#base_lv_act_reward{act_type = 6,act_subtype = 1,reward_name = <<"海量材料"/utf8>>,grade = 2,normal_cost = 8000,cost = 1588,string = <<"2"/utf8>>,show = [{show,show_model,{{10,1003}}},{tips_show,uiqg_wz_064},{tab_show,uiqg_yq_064,uiqg_tb_064},{tab_mark,tab2}],reward = [{0,7120103,30},{0,32010243,1},{0,32010242,1},{0,7110002,15},{0,7110002,15},{0,7110001,40},{0,7110001,30},{0,7110001,30}],condition = [{tv, 612, 6},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(6,1,3) ->
	#base_lv_act_reward{act_type = 6,act_subtype = 1,reward_name = <<"绝世神灵"/utf8>>,grade = 3,normal_cost = 30000,cost = 4888,string = <<"3"/utf8>>,show = [{show,show_model,{{10,1004}}},{tips_show,uiqg_wz_065},{tab_show,uiqg_yq_065,uiqg_tb_065},{tab_mark,tab3}],reward = [{0,7120201,30},{0,7120201,12},{0,7120201,8},{0,7120201,5},{0,7120201,3},{0,7120201,2},{0,32010572,1},{0,32010572,1}],condition = [{tv, 612, 6},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(7,1,1) ->
	#base_lv_act_reward{act_type = 7,act_subtype = 1,reward_name = <<"妖灵进阶"/utf8>>,grade = 1,normal_cost = 1580,cost = 388,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_066},{tips_show,uiqg_wz_066},{tab_show,uiqg_yq_066,uiqg_tb_066},{tab_mark,tab1}],reward = [{0,7301004,5},{0,7301004,5},{0,7302001,2},{0,7301001,8},{0,7301001,7},{0,7301001,5},{0,7301001,5},{0,7301001,5}],condition = [{tv, 612, 7},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(7,1,2) ->
	#base_lv_act_reward{act_type = 7,act_subtype = 1,reward_name = <<"单挑骷髅"/utf8>>,grade = 2,normal_cost = 8000,cost = 2288,string = <<"2"/utf8>>,show = [{show,show_model,{{11,1002}}},{tips_show,uiqg_wz_067},{tab_show,uiqg_yq_067,uiqg_tb_067},{tab_mark,tab2}],reward = [{0,7302002,10},{0,7302002,10},{0,7302002,10},{0,7301005,5},{0,7301002,3},{0,7301002,3},{0,7301002,2},{0,7301002,2}],condition = [{tv, 612, 7},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(7,1,3) ->
	#base_lv_act_reward{act_type = 7,act_subtype = 1,reward_name = <<"暴击小鸭"/utf8>>,grade = 3,normal_cost = 12000,cost = 2888,string = <<"3"/utf8>>,show = [{show,show_model,{{11,1004}}},{tips_show,uiqg_wz_068},{tab_show,uiqg_yq_068,uiqg_tb_068},{tab_mark,tab3}],reward = [{0,7302003,10},{0,7302003,10},{0,7302003,10},{0,7301006,5},{0,7301003,3},{0,7301003,3},{0,7301003,2},{0,7301003,2}],condition = [{tv, 612, 7},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(8,1,1) ->
	#base_lv_act_reward{act_type = 8,act_subtype = 1,reward_name = <<"极品圣手"/utf8>>,grade = 1,normal_cost = 1880,cost = 388,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_072},{tips_show,uiqg_wz_072},{tab_show,uiqg_yq_072,uiqg_tb_072},{tab_mark,tab1}],reward = [{0,79050601,1},{0,32010574,1},{0,38040070,10},{0,38040070,10},{0,38040071,3},{0,38040071,3},{0,38040072,2},{0,38040076,2}],condition = [{tv, 612, 8},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(8,1,2) ->
	#base_lv_act_reward{act_type = 8,act_subtype = 1,reward_name = <<"珍稀圣兵"/utf8>>,grade = 2,normal_cost = 3888,cost = 888,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_073},{tips_show,uiqg_wz_073},{tab_show,uiqg_yq_073,uiqg_tb_073},{tab_mark,tab2}],reward = [{0,79010601,1},{0,32010575,1},{0,32010574,1},{0,32010574,1},{0,38040076,2},{0,38040076,2},{0,38040073,6},{0,38040073,6}],condition = [{tv, 612, 8},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(8,1,3) ->
	#base_lv_act_reward{act_type = 8,act_subtype = 1,reward_name = <<"启灵升战"/utf8>>,grade = 3,normal_cost = 5000,cost = 1680,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_074},{tips_show,uiqg_wz_074},{tab_show,uiqg_yq_074,uiqg_tb_074},{tab_mark,tab3}],reward = [{0,38040074,1},{0,38040070,30},{0,38040071,3},{0,38040071,3},{0,38040072,2},{0,38040076,2},{0,38040073,6},{0,38040073,6}],condition = [{tv, 612, 8},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(9,1,1) ->
	#base_lv_act_reward{act_type = 9,act_subtype = 1,reward_name = <<"西锋进阶"/utf8>>,grade = 1,normal_cost = 1880,cost = 388,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_069},{tips_show,uiqg_wz_069},{tab_show,uiqg_yq_069,uiqg_tb_069},{tab_mark,tab1}],reward = [{0,7701402,1},{0,7702402,1},{0,38040069,5},{0,38040069,5},{0,38040068,5},{0,38040068,5},{0,38040068,5},{0,38040068,5}],condition = [{tv, 612, 9},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(9,1,2) ->
	#base_lv_act_reward{act_type = 9,act_subtype = 1,reward_name = <<"超值棘甲"/utf8>>,grade = 2,normal_cost = 3888,cost = 888,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_070},{tips_show,uiqg_wz_070},{tab_show,uiqg_yq_070,uiqg_tb_070},{tab_mark,tab2}],reward = [{0,7707503,1},{0,7708503,1},{0,38040069,10},{0,38040069,10},{0,38040068,10},{0,38040068,10},{0,38040068,10},{0,38040068,10}],condition = [{tv, 612, 9},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(9,1,3) ->
	#base_lv_act_reward{act_type = 9,act_subtype = 1,reward_name = <<"豪华棘甲礼包"/utf8>>,grade = 3,normal_cost = 5000,cost = 1680,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_071},{tips_show,uiqg_wz_071},{tab_show,uiqg_yq_071,uiqg_tb_071},{tab_mark,tab3}],reward = [{0,7709503,1},{0,7710503,1},{0,7703402,1},{0,7704402,1},{0,7705402,1},{0,7706402,1}],condition = [{tv, 612, 9},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(10,1,1) ->
	#base_lv_act_reward{act_type = 10,act_subtype = 1,reward_name = <<"海量资源"/utf8>>,grade = 1,normal_cost = 680,cost = 168,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_075},{tips_show,uiqg_wz_075},{tab_show,uiqg_yq_075,uiqg_tb_075},{tab_mark,tab1}],reward = [{0,25020002,2},{0,25020002,1},{0,25020002,1},{0,25020002,1},{0,25020004,5},{0,25020004,5},{0,25020004,5},{0,25020004,5}],condition = [{tv, 612, 10},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(10,1,2) ->
	#base_lv_act_reward{act_type = 10,act_subtype = 1,reward_name = <<"战力飙升"/utf8>>,grade = 2,normal_cost = 1280,cost = 328,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_076},{tips_show,uiqg_wz_076},{tab_show,uiqg_yq_076,uiqg_tb_076},{tab_mark,tab2}],reward = [{0,25010003,1},{0,25010002,1},{0,25010002,1},{0,25020002,2},{0,25020002,1},{0,25020002,1},{0,25020004,5},{0,25020004,5}],condition = [{tv, 612, 10},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(10,1,3) ->
	#base_lv_act_reward{act_type = 10,act_subtype = 1,reward_name = <<"稀有背饰"/utf8>>,grade = 3,normal_cost = 2380,cost = 688,string = <<"3"/utf8>>,show = [{show,show_model,{{20,1010}}},{tips_show,uiqg_wz_077},{tab_show,uiqg_yq_077,uiqg_tb_077},{tab_mark,tab3}],reward = [{0,25030109,30},{0,25010002,1},{0,25010001,1},{0,25020002,2},{0,25020002,2},{0,25020002,2},{0,25020004,10},{0,25020004,10}],condition = [{tv, 612, 10},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,1,1) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 1,reward_name = <<"超高性价比礼包"/utf8>>,grade = 1,normal_cost = 2048,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uidjqg_005j},{tab_show,uidjqg_008j,uiqg_tb_002}],reward = [{0,38240201,20},{0,32010129,40},{0,36255007,20},{0,38340001,1},{0,19010002,1},{0,20010002,1},{0,35,188}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,1,2) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 1,reward_name = <<"神装助力礼包"/utf8>>,grade = 2,normal_cost = 5918,cost = 688,string = <<"2"/utf8>>,show = [{show,show_model,{{19,1110}}},{tips_show,uidjqg_005k},{tab_show,uidjqg_008k,uidjqg_010j}],reward = [{0,12010009,1},{0,12020009,1},{0,36255006,5},{0,36255007,50},{0,36255021,100},{0,36255021,100},{0,35,288}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,1,3) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 1,reward_name = <<"特殊符文礼包"/utf8>>,grade = 3,normal_cost = 7868,cost = 1688,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_009},{tips_show,uidjqg_005m},{tab_show,uidjqg_008m,uidjqg_010m}],reward = [{0,32070034,1},{0,36255006,10},{0,36255007,50},{0,19020002,5},{0,19020001,20},{0,38040012,200},{0,35,688}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,2,1) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 2,reward_name = <<"超高性价比礼包"/utf8>>,grade = 1,normal_cost = 2048,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uidjqg_005j},{tab_show,uidjqg_008j,uiqg_tb_002}],reward = [{0,38240201,20},{0,32010129,40},{0,36255006,3},{0,38340001,1},{0,19010002,1},{0,20010002,1},{0,35,188}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,2,2) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 2,reward_name = <<"神装助力礼包"/utf8>>,grade = 2,normal_cost = 5918,cost = 788,string = <<"2"/utf8>>,show = [{show,show_model,{{19,1110}}},{tips_show,uidjqg_005k},{tab_show,uidjqg_008k,uidjqg_010j}],reward = [{0,12010009,1},{0,12020009,1},{0,34010079,1},{0,32010244,10},{0,34010041,5},{0,36255021,100},{0,35,288}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,2,3) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 2,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 7868,cost = 1688,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,34010079,1},{0,34010079,1},{0,36255008,50},{0,32010244,20},{0,19020002,5},{0,19020001,20},{0,35,688}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,3,1) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 3,reward_name = <<"超高性价比礼包"/utf8>>,grade = 1,normal_cost = 2048,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_007},{tips_show,uidjqg_005j},{tab_show,uidjqg_008j,uidjqg_010l}],reward = [{0,34010077,1},{0,36255006,2},{0,34010041,5},{0,38340001,1},{0,19010002,1},{0,20010002,1},{0,35,188}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,3,2) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 3,reward_name = <<"神装助力礼包"/utf8>>,grade = 2,normal_cost = 5918,cost = 788,string = <<"2"/utf8>>,show = [{show,show_model,{{19,1110}}},{tips_show,uidjqg_005k},{tab_show,uidjqg_008k,uidjqg_010j}],reward = [{0,12010009,1},{0,12020009,1},{0,34010079,1},{0,32010244,10},{0,34010041,10},{0,36255021,100},{0,35,288}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,3,3) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 3,reward_name = <<"降神自选礼包"/utf8>>,grade = 3,normal_cost = 7868,cost = 1688,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_008},{tips_show,uidjqg_005l},{tab_show,uidjqg_008l,uidjqg_010k}],reward = [{0,34010078,1},{0,34010079,1},{0,36255008,50},{0,19020002,5},{0,19020001,20},{0,36255021,200},{0,35,688}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,4,1) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 4,reward_name = <<"超高性价比礼包"/utf8>>,grade = 1,normal_cost = 2048,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_007},{tips_show,uidjqg_005j},{tab_show,uidjqg_008j,uidjqg_010l}],reward = [{0,34010077,1},{0,36255006,2},{0,34010041,5},{0,38340001,1},{0,19010002,1},{0,20010002,1},{0,35,188}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,4,2) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 4,reward_name = <<"神装助力礼包"/utf8>>,grade = 2,normal_cost = 5918,cost = 788,string = <<"2"/utf8>>,show = [{show,show_model,{{19,1110}}},{tips_show,uidjqg_005k},{tab_show,uidjqg_008k,uidjqg_010j}],reward = [{0,12010009,1},{0,12020009,1},{0,34010079,1},{0,32010244,10},{0,34010041,10},{0,36255031,100},{0,35,288}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(63,4,3) ->
	#base_lv_act_reward{act_type = 63,act_subtype = 4,reward_name = <<"降神自选礼包"/utf8>>,grade = 3,normal_cost = 7868,cost = 1688,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_008},{tips_show,uidjqg_005l},{tab_show,uidjqg_008l,uidjqg_010k}],reward = [{0,34010078,1},{0,34010079,1},{0,36255008,50},{0,19020002,5},{0,19020001,20},{0,36255031,200},{0,35,688}],condition = [{tv, 612, 63},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,1,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 1,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,1,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 1,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,1,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 1,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,2,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 2,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,2,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 2,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,2,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 2,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,3,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 3,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,3,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 3,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,3,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 3,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,4,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 4,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,4,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 4,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,4,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 4,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,5,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 5,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,5,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 5,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,5,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 5,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,6,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 6,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,6,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 6,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,6,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 6,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,7,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 7,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,7,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 7,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,7,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 7,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,8,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 8,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,8,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 8,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,8,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 8,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,9,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 9,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,9,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 9,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,9,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 9,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,10,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 10,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,10,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 10,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,10,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 10,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,11,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 11,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,11,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 11,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,11,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 11,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,12,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 12,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,12,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 12,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,12,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 12,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,13,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 13,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,13,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 13,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,13,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 13,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,14,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 14,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,14,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 14,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,14,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 14,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,15,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 15,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,15,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 15,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,15,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 15,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,16,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 16,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,16,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 16,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,16,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 16,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,17,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 17,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,17,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 17,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,17,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 17,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,18,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 18,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,18,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 18,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,18,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 18,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,19,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 19,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,19,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 19,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,19,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 19,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,20,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 20,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,20,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 20,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,20,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 20,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,21,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 21,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,21,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 21,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,21,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 21,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,22,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 22,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,22,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 22,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,22,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 22,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,23,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 23,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,23,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 23,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,23,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 23,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,24,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 24,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,24,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 24,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,24,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 24,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,25,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 25,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,25,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 25,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,25,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 25,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,26,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 26,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,26,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 26,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,26,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 26,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,27,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 27,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,27,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 27,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,27,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 27,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,28,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 28,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,28,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 28,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,28,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 28,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,29,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 29,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,29,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 29,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,29,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 29,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,30,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 30,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,30,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 30,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,30,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 30,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,31,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 31,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,31,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 31,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,31,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 31,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,32,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 32,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,32,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 32,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,32,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 32,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,33,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 33,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,33,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 33,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,33,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 33,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,34,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 34,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,34,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 34,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,34,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 34,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,35,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 35,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,35,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 35,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,35,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 35,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,36,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 36,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,36,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 36,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,36,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 36,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,37,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 37,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,37,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 37,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,37,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 37,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,38,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 38,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,38,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 38,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,38,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 38,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,39,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 39,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,39,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 39,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,39,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 39,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,40,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 40,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,40,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 40,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,40,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 40,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,41,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 41,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,41,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 41,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,41,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 41,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,42,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 42,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,42,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 42,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,42,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 42,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,43,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 43,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,43,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 43,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,43,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 43,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,44,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 44,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,44,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 44,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,44,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 44,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,45,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 45,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,45,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 45,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,45,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 45,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,46,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 46,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,46,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 46,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,46,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 46,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,47,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 47,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,47,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 47,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,47,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 47,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,48,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 48,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,48,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 48,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,48,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 48,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,49,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 49,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,49,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 49,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,49,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 49,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,50,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 50,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,50,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 50,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,50,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 50,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,51,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 51,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,51,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 51,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,51,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 51,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,52,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 52,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,52,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 52,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,52,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 52,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,53,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 53,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,53,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 53,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,53,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 53,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,54,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 54,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,54,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 54,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,54,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 54,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,55,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 55,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,55,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 55,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,55,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 55,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,56,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 56,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,56,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 56,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,56,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 56,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,57,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 57,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,57,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 57,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,57,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 57,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,58,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 58,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,58,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 58,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,58,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 58,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,59,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 59,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,59,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 59,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,59,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 59,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,60,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 60,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,60,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 60,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,60,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 60,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,61,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 61,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,61,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 61,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,61,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 61,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,62,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 62,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,62,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 62,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,62,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 62,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,63,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 63,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,63,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 63,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,63,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 63,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,64,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 64,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,64,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 64,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,64,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 64,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,65,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 65,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,65,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 65,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,65,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 65,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,66,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 66,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,66,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 66,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,66,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 66,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,67,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 67,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,67,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 67,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,67,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 67,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,68,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 68,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,68,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 68,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,68,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 68,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,69,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 69,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,69,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 69,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,69,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 69,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,70,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 70,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,70,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 70,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,70,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 70,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,71,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 71,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,71,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 71,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,71,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 71,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,72,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 72,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,72,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 72,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,72,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 72,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,73,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 73,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,73,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 73,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,73,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 73,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,74,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 74,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,74,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 74,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,74,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 74,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,75,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 75,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,75,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 75,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,75,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 75,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,76,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 76,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,76,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 76,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,76,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 76,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,77,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 77,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,77,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 77,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,77,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 77,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,78,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 78,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,78,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 78,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,78,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 78,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,79,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 79,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,79,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 79,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,79,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 79,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,80,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 80,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,80,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 80,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,80,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 80,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,81,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 81,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,81,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 81,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,81,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 81,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,82,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 82,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,82,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 82,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,82,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 82,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,83,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 83,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,83,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 83,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,83,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 83,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,84,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 84,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,84,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 84,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,84,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 84,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,85,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 85,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,85,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 85,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,85,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 85,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,86,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 86,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,86,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 86,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,86,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 86,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,87,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 87,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,87,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 87,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,87,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 87,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,88,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 88,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,88,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 88,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,88,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 88,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,89,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 89,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,89,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 89,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,89,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 89,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,90,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 90,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,90,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 90,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,90,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 90,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,91,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 91,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,91,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 91,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,91,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 91,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,92,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 92,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,92,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 92,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,92,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 92,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,93,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 93,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,93,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 93,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,93,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 93,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,94,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 94,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,94,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 94,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,94,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 94,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,95,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 95,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,95,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 95,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,95,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 95,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,96,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 96,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,96,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 96,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,96,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 96,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,97,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 97,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,97,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 97,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,97,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 97,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,98,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 98,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,98,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 98,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,98,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 98,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,99,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 99,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,99,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 99,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,99,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 99,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,100,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 100,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,100,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 100,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,100,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 100,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,101,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 101,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,101,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 101,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,101,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 101,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,102,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 102,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,102,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 102,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,102,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 102,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,103,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 103,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,103,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 103,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,103,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 103,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,104,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 104,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,104,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 104,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,104,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 104,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,105,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 105,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,105,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 105,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,105,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 105,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,106,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 106,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,106,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 106,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,106,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 106,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,107,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 107,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,107,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 107,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,107,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 107,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,108,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 108,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,108,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 108,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,108,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 108,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,109,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 109,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,109,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 109,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,109,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 109,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,110,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 110,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,110,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 110,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,110,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 110,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,111,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 111,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,111,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 111,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,111,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 111,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,112,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 112,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,112,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 112,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,112,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 112,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,113,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 113,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,113,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 113,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,113,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 113,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,114,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 114,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,114,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 114,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,114,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 114,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,115,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 115,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,115,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 115,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,115,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 115,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,116,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 116,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 188,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,116,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 116,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 588,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,116,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 116,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,38040030,20},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,117,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 117,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,32010194,1},{0,32010193,1},{100,38040044,6}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,117,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 117,reward_name = <<"修罗石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_002},{tips_show,uiqg_wz_002},{tab_show,uiqg_yq_002,uiqg_tb_002}],reward = [{100,38240201,10},{100,38240201,10},{0,34010021,1},{0,32010206,1},{0,36255007,5}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,117,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 117,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_005},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_005}],reward = [{0,36255007,30},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,118,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 118,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,7}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,118,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 118,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,118,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 118,reward_name = <<"秘钥礼包"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_006},{tips_show,uiqg_wz_003},{tab_show,uiqg_yq_003,uiqg_tb_006}],reward = [{0,36255008,20},{0,32010244,10},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,119,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 119,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,8}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,119,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 119,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,119,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 119,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,120,1) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 120,reward_name = <<"开荒礼包"/utf8>>,grade = 1,normal_cost = 560,cost = 288,string = <<"1"/utf8>>,show = [{show,show_icon,uiqg_ztb_001},{tips_show,uiqg_wz_005},{tab_show,uiqg_yq_001,uiqg_tb_001}],reward = [{0,38160001,1},{0,38030003,2},{0,38030004,2},{0,38030005,1},{0,36255008,7},{100,38040044,10}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(75,120,2) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 120,reward_name = <<"神装石礼包"/utf8>>,grade = 2,normal_cost = 860,cost = 488,string = <<"2"/utf8>>,show = [{show,show_icon,uiqg_ztb_003},{tips_show,uiqg_wz_001},{tab_show,uiqg_yq_004,uiqg_tb_003}],reward = [{0,32010244,2},{0,34010041,2},{100,38240201,10},{100,38240201,10},{0,36255008,3}],condition = [{tv, 612, 75},{cost_type,2}],recharge_id = 0};

get_act_reward_cfg(75,120,3) ->
	#base_lv_act_reward{act_type = 75,act_subtype = 120,reward_name = <<"天启礼盒"/utf8>>,grade = 3,normal_cost = 2560,cost = 888,string = <<"3"/utf8>>,show = [{show,show_icon,uiqg_ztb_004},{tips_show,uiqg_wz_004},{tab_show,uiqg_yq_005,uiqg_tb_004}],reward = [{0,34010082,1},{0,34010079,1},{0,19010001,2},{0,19010002,2},{0,19010003,1},{0,16010003,1}],condition = [{tv, 612, 75},{cost_type,1}],recharge_id = 0};

get_act_reward_cfg(_Acttype,_Actsubtype,_Grade) ->
	[].

get_all_grade(1,1) ->
[1,2,3];

get_all_grade(2,1) ->
[1,2,3];

get_all_grade(3,1) ->
[1,2,3];

get_all_grade(4,1) ->
[1,2,3];

get_all_grade(5,1) ->
[1,2,3];

get_all_grade(6,1) ->
[1,2,3];

get_all_grade(7,1) ->
[1,2,3];

get_all_grade(8,1) ->
[1,2,3];

get_all_grade(9,1) ->
[1,2,3];

get_all_grade(10,1) ->
[1,2,3];

get_all_grade(63,1) ->
[1,2,3];

get_all_grade(63,2) ->
[1,2,3];

get_all_grade(63,3) ->
[1,2,3];

get_all_grade(63,4) ->
[1,2,3];

get_all_grade(75,1) ->
[1,2,3];

get_all_grade(75,2) ->
[1,2,3];

get_all_grade(75,3) ->
[1,2,3];

get_all_grade(75,4) ->
[1,2,3];

get_all_grade(75,5) ->
[1,2,3];

get_all_grade(75,6) ->
[1,2,3];

get_all_grade(75,7) ->
[1,2,3];

get_all_grade(75,8) ->
[1,2,3];

get_all_grade(75,9) ->
[1,2,3];

get_all_grade(75,10) ->
[1,2,3];

get_all_grade(75,11) ->
[1,2,3];

get_all_grade(75,12) ->
[1,2,3];

get_all_grade(75,13) ->
[1,2,3];

get_all_grade(75,14) ->
[1,2,3];

get_all_grade(75,15) ->
[1,2,3];

get_all_grade(75,16) ->
[1,2,3];

get_all_grade(75,17) ->
[1,2,3];

get_all_grade(75,18) ->
[1,2,3];

get_all_grade(75,19) ->
[1,2,3];

get_all_grade(75,20) ->
[1,2,3];

get_all_grade(75,21) ->
[1,2,3];

get_all_grade(75,22) ->
[1,2,3];

get_all_grade(75,23) ->
[1,2,3];

get_all_grade(75,24) ->
[1,2,3];

get_all_grade(75,25) ->
[1,2,3];

get_all_grade(75,26) ->
[1,2,3];

get_all_grade(75,27) ->
[1,2,3];

get_all_grade(75,28) ->
[1,2,3];

get_all_grade(75,29) ->
[1,2,3];

get_all_grade(75,30) ->
[1,2,3];

get_all_grade(75,31) ->
[1,2,3];

get_all_grade(75,32) ->
[1,2,3];

get_all_grade(75,33) ->
[1,2,3];

get_all_grade(75,34) ->
[1,2,3];

get_all_grade(75,35) ->
[1,2,3];

get_all_grade(75,36) ->
[1,2,3];

get_all_grade(75,37) ->
[1,2,3];

get_all_grade(75,38) ->
[1,2,3];

get_all_grade(75,39) ->
[1,2,3];

get_all_grade(75,40) ->
[1,2,3];

get_all_grade(75,41) ->
[1,2,3];

get_all_grade(75,42) ->
[1,2,3];

get_all_grade(75,43) ->
[1,2,3];

get_all_grade(75,44) ->
[1,2,3];

get_all_grade(75,45) ->
[1,2,3];

get_all_grade(75,46) ->
[1,2,3];

get_all_grade(75,47) ->
[1,2,3];

get_all_grade(75,48) ->
[1,2,3];

get_all_grade(75,49) ->
[1,2,3];

get_all_grade(75,50) ->
[1,2,3];

get_all_grade(75,51) ->
[1,2,3];

get_all_grade(75,52) ->
[1,2,3];

get_all_grade(75,53) ->
[1,2,3];

get_all_grade(75,54) ->
[1,2,3];

get_all_grade(75,55) ->
[1,2,3];

get_all_grade(75,56) ->
[1,2,3];

get_all_grade(75,57) ->
[1,2,3];

get_all_grade(75,58) ->
[1,2,3];

get_all_grade(75,59) ->
[1,2,3];

get_all_grade(75,60) ->
[1,2,3];

get_all_grade(75,61) ->
[1,2,3];

get_all_grade(75,62) ->
[1,2,3];

get_all_grade(75,63) ->
[1,2,3];

get_all_grade(75,64) ->
[1,2,3];

get_all_grade(75,65) ->
[1,2,3];

get_all_grade(75,66) ->
[1,2,3];

get_all_grade(75,67) ->
[1,2,3];

get_all_grade(75,68) ->
[1,2,3];

get_all_grade(75,69) ->
[1,2,3];

get_all_grade(75,70) ->
[1,2,3];

get_all_grade(75,71) ->
[1,2,3];

get_all_grade(75,72) ->
[1,2,3];

get_all_grade(75,73) ->
[1,2,3];

get_all_grade(75,74) ->
[1,2,3];

get_all_grade(75,75) ->
[1,2,3];

get_all_grade(75,76) ->
[1,2,3];

get_all_grade(75,77) ->
[1,2,3];

get_all_grade(75,78) ->
[1,2,3];

get_all_grade(75,79) ->
[1,2,3];

get_all_grade(75,80) ->
[1,2,3];

get_all_grade(75,81) ->
[1,2,3];

get_all_grade(75,82) ->
[1,2,3];

get_all_grade(75,83) ->
[1,2,3];

get_all_grade(75,84) ->
[1,2,3];

get_all_grade(75,85) ->
[1,2,3];

get_all_grade(75,86) ->
[1,2,3];

get_all_grade(75,87) ->
[1,2,3];

get_all_grade(75,88) ->
[1,2,3];

get_all_grade(75,89) ->
[1,2,3];

get_all_grade(75,90) ->
[1,2,3];

get_all_grade(75,91) ->
[1,2,3];

get_all_grade(75,92) ->
[1,2,3];

get_all_grade(75,93) ->
[1,2,3];

get_all_grade(75,94) ->
[1,2,3];

get_all_grade(75,95) ->
[1,2,3];

get_all_grade(75,96) ->
[1,2,3];

get_all_grade(75,97) ->
[1,2,3];

get_all_grade(75,98) ->
[1,2,3];

get_all_grade(75,99) ->
[1,2,3];

get_all_grade(75,100) ->
[1,2,3];

get_all_grade(75,101) ->
[1,2,3];

get_all_grade(75,102) ->
[1,2,3];

get_all_grade(75,103) ->
[1,2,3];

get_all_grade(75,104) ->
[1,2,3];

get_all_grade(75,105) ->
[1,2,3];

get_all_grade(75,106) ->
[1,2,3];

get_all_grade(75,107) ->
[1,2,3];

get_all_grade(75,108) ->
[1,2,3];

get_all_grade(75,109) ->
[1,2,3];

get_all_grade(75,110) ->
[1,2,3];

get_all_grade(75,111) ->
[1,2,3];

get_all_grade(75,112) ->
[1,2,3];

get_all_grade(75,113) ->
[1,2,3];

get_all_grade(75,114) ->
[1,2,3];

get_all_grade(75,115) ->
[1,2,3];

get_all_grade(75,116) ->
[1,2,3];

get_all_grade(75,117) ->
[1,2,3];

get_all_grade(75,118) ->
[1,2,3];

get_all_grade(75,119) ->
[1,2,3];

get_all_grade(75,120) ->
[1,2,3];

get_all_grade(_Acttype,_Actsubtype) ->
	[].


get_act_info_by_recharge(0) ->
[{1,1,1},{1,1,2},{1,1,3},{2,1,1},{2,1,2},{2,1,3},{3,1,1},{3,1,2},{3,1,3},{4,1,1},{4,1,2},{4,1,3},{5,1,1},{5,1,2},{5,1,3},{6,1,1},{6,1,2},{6,1,3},{7,1,1},{7,1,2},{7,1,3},{8,1,1},{8,1,2},{8,1,3},{9,1,1},{9,1,2},{9,1,3},{10,1,1},{10,1,2},{10,1,3},{63,1,1},{63,1,2},{63,1,3},{63,2,1},{63,2,2},{63,2,3},{63,3,1},{63,3,2},{63,3,3},{63,4,1},{63,4,2},{63,4,3},{75,1,1},{75,1,2},{75,1,3},{75,2,1},{75,2,2},{75,2,3},{75,3,1},{75,3,2},{75,3,3},{75,4,1},{75,4,2},{75,4,3},{75,5,1},{75,5,2},{75,5,3},{75,6,1},{75,6,2},{75,6,3},{75,7,1},{75,7,2},{75,7,3},{75,8,1},{75,8,2},{75,8,3},{75,9,1},{75,9,2},{75,9,3},{75,10,1},{75,10,2},{75,10,3},{75,11,1},{75,11,2},{75,11,3},{75,12,1},{75,12,2},{75,12,3},{75,13,1},{75,13,2},{75,13,3},{75,14,1},{75,14,2},{75,14,3},{75,15,1},{75,15,2},{75,15,3},{75,16,1},{75,16,2},{75,16,3},{75,17,1},{75,17,2},{75,17,3},{75,18,1},{75,18,2},{75,18,3},{75,19,1},{75,19,2},{75,19,3},{75,20,1},{75,20,2},{75,20,3},{75,21,1},{75,21,2},{75,21,3},{75,22,1},{75,22,2},{75,22,3},{75,23,1},{75,23,2},{75,23,3},{75,24,1},{75,24,2},{75,24,3},{75,25,1},{75,25,2},{75,25,3},{75,26,1},{75,26,2},{75,26,3},{75,27,1},{75,27,2},{75,27,3},{75,28,1},{75,28,2},{75,28,3},{75,29,1},{75,29,2},{75,29,3},{75,30,1},{75,30,2},{75,30,3},{75,31,1},{75,31,2},{75,31,3},{75,32,1},{75,32,2},{75,32,3},{75,33,1},{75,33,2},{75,33,3},{75,34,1},{75,34,2},{75,34,3},{75,35,1},{75,35,2},{75,35,3},{75,36,1},{75,36,2},{75,36,3},{75,37,1},{75,37,2},{75,37,3},{75,38,1},{75,38,2},{75,38,3},{75,39,1},{75,39,2},{75,39,3},{75,40,1},{75,40,2},{75,40,3},{75,41,1},{75,41,2},{75,41,3},{75,42,1},{75,42,2},{75,42,3},{75,43,1},{75,43,2},{75,43,3},{75,44,1},{75,44,2},{75,44,3},{75,45,1},{75,45,2},{75,45,3},{75,46,1},{75,46,2},{75,46,3},{75,47,1},{75,47,2},{75,47,3},{75,48,1},{75,48,2},{75,48,3},{75,49,1},{75,49,2},{75,49,3},{75,50,1},{75,50,2},{75,50,3},{75,51,1},{75,51,2},{75,51,3},{75,52,1},{75,52,2},{75,52,3},{75,53,1},{75,53,2},{75,53,3},{75,54,1},{75,54,2},{75,54,3},{75,55,1},{75,55,2},{75,55,3},{75,56,1},{75,56,2},{75,56,3},{75,57,1},{75,57,2},{75,57,3},{75,58,1},{75,58,2},{75,58,3},{75,59,1},{75,59,2},{75,59,3},{75,60,1},{75,60,2},{75,60,3},{75,61,1},{75,61,2},{75,61,3},{75,62,1},{75,62,2},{75,62,3},{75,63,1},{75,63,2},{75,63,3},{75,64,1},{75,64,2},{75,64,3},{75,65,1},{75,65,2},{75,65,3},{75,66,1},{75,66,2},{75,66,3},{75,67,1},{75,67,2},{75,67,3},{75,68,1},{75,68,2},{75,68,3},{75,69,1},{75,69,2},{75,69,3},{75,70,1},{75,70,2},{75,70,3},{75,71,1},{75,71,2},{75,71,3},{75,72,1},{75,72,2},{75,72,3},{75,73,1},{75,73,2},{75,73,3},{75,74,1},{75,74,2},{75,74,3},{75,75,1},{75,75,2},{75,75,3},{75,76,1},{75,76,2},{75,76,3},{75,77,1},{75,77,2},{75,77,3},{75,78,1},{75,78,2},{75,78,3},{75,79,1},{75,79,2},{75,79,3},{75,80,1},{75,80,2},{75,80,3},{75,81,1},{75,81,2},{75,81,3},{75,82,1},{75,82,2},{75,82,3},{75,83,1},{75,83,2},{75,83,3},{75,84,1},{75,84,2},{75,84,3},{75,85,1},{75,85,2},{75,85,3},{75,86,1},{75,86,2},{75,86,3},{75,87,1},{75,87,2},{75,87,3},{75,88,1},{75,88,2},{75,88,3},{75,89,1},{75,89,2},{75,89,3},{75,90,1},{75,90,2},{75,90,3},{75,91,1},{75,91,2},{75,91,3},{75,92,1},{75,92,2},{75,92,3},{75,93,1},{75,93,2},{75,93,3},{75,94,1},{75,94,2},{75,94,3},{75,95,1},{75,95,2},{75,95,3},{75,96,1},{75,96,2},{75,96,3},{75,97,1},{75,97,2},{75,97,3},{75,98,1},{75,98,2},{75,98,3},{75,99,1},{75,99,2},{75,99,3},{75,100,1},{75,100,2},{75,100,3},{75,101,1},{75,101,2},{75,101,3},{75,102,1},{75,102,2},{75,102,3},{75,103,1},{75,103,2},{75,103,3},{75,104,1},{75,104,2},{75,104,3},{75,105,1},{75,105,2},{75,105,3},{75,106,1},{75,106,2},{75,106,3},{75,107,1},{75,107,2},{75,107,3},{75,108,1},{75,108,2},{75,108,3},{75,109,1},{75,109,2},{75,109,3},{75,110,1},{75,110,2},{75,110,3},{75,111,1},{75,111,2},{75,111,3},{75,112,1},{75,112,2},{75,112,3},{75,113,1},{75,113,2},{75,113,3},{75,114,1},{75,114,2},{75,114,3},{75,115,1},{75,115,2},{75,115,3},{75,116,1},{75,116,2},{75,116,3},{75,117,1},{75,117,2},{75,117,3},{75,118,1},{75,118,2},{75,118,3},{75,119,1},{75,119,2},{75,119,3},{75,120,1},{75,120,2},{75,120,3}];

get_act_info_by_recharge(_Rechargeid) ->
	[].

get_gift_reward_cfg(66,1,1) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 1,sort = 1,recharge_id = 51,reward_name = <<"超值2"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 2,open_day_max = 2,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,3}],reward = [{0,34010136,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,2) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 2,sort = 2,recharge_id = 52,reward_name = <<"超值2"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 250,vip_max = 499,open_day_min = 2,open_day_max = 2,circle = 0,discount = 1,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,2}],reward = [{0,101035062,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,3) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 3,sort = 3,recharge_id = 53,reward_name = <<"超值2"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 99999,open_day_min = 2,open_day_max = 2,circle = 0,discount = 6,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,4}],reward = [{0,34010137,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,11) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 11,sort = 1,recharge_id = 54,reward_name = <<"超值3"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 3,open_day_max = 3,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,5}],reward = [{0,34010138,20},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,12) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 12,sort = 2,recharge_id = 55,reward_name = <<"超值3"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 250,vip_max = 499,open_day_min = 3,open_day_max = 3,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,6}],reward = [{0,34010139,50},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,13) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 13,sort = 3,recharge_id = 56,reward_name = <<"超值3"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 99999,open_day_min = 3,open_day_max = 3,circle = 0,discount = 3,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,24}],reward = [{0,34010140,30},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,21) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 21,sort = 1,recharge_id = 57,reward_name = <<"超值4"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 4,open_day_max = 4,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,5}],reward = [{0,34010138,20},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,22) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 22,sort = 2,recharge_id = 58,reward_name = <<"超值4"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 250,vip_max = 499,open_day_min = 4,open_day_max = 4,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,6}],reward = [{0,34010139,50},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,23) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 23,sort = 3,recharge_id = 59,reward_name = <<"超值4"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 99999,open_day_min = 4,open_day_max = 4,circle = 0,discount = 6,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,23}],reward = [{0,34010143,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,31) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 31,sort = 1,recharge_id = 60,reward_name = <<"超值5"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 5,open_day_max = 5,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,5}],reward = [{0,34010138,20},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,32) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 32,sort = 2,recharge_id = 61,reward_name = <<"超值5"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 250,vip_max = 499,open_day_min = 5,open_day_max = 5,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,6}],reward = [{0,34010139,50},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,33) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 33,sort = 3,recharge_id = 62,reward_name = <<"超值5"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 99999,open_day_min = 5,open_day_max = 5,circle = 0,discount = 6,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,22}],reward = [{0,34010145,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,41) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 41,sort = 1,recharge_id = 63,reward_name = <<"超值7"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 7,open_day_max = 7,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,21}],reward = [{0,34010144,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,42) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 42,sort = 2,recharge_id = 64,reward_name = <<"超值7"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 250,vip_max = 499,open_day_min = 7,open_day_max = 7,circle = 0,discount = 1,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,20}],reward = [{0,34010147,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,43) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 43,sort = 3,recharge_id = 65,reward_name = <<"超值7"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 99999,open_day_min = 7,open_day_max = 7,circle = 0,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,19}],reward = [{0,34010054,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,44) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 44,sort = 1,recharge_id = 0,reward_name = <<"超值8"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 8,open_day_max = 8,circle = 0,discount = 2,cost = 60,string = <<"xxxx"/utf8>>,show = [{tips_show,8}],reward = [{0,36255006,1},{0,20010002,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,45) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 45,sort = 2,recharge_id = 0,reward_name = <<"超值8"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 250,vip_max = 499,open_day_min = 8,open_day_max = 8,circle = 0,discount = 2,cost = 180,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255006,2},{0,20010003,1}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,46) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 46,sort = 3,recharge_id = 0,reward_name = <<"超值8"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 99999,open_day_min = 8,open_day_max = 8,circle = 0,discount = 3,cost = 680,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255006,7},{0,20010003,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,51) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 51,sort = 1,recharge_id = 66,reward_name = <<"超值9"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 9,open_day_max = 9,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,18}],reward = [{0,34010146,5},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,52) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 52,sort = 2,recharge_id = 67,reward_name = <<"超值9"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 250,vip_max = 499,open_day_min = 9,open_day_max = 9,circle = 0,discount = 1,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,17}],reward = [{0,34010148,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,53) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 53,sort = 3,recharge_id = 68,reward_name = <<"超值9"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 99999,open_day_min = 9,open_day_max = 9,circle = 0,discount = 3,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,16}],reward = [{0,32010244,40},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,54) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 54,sort = 1,recharge_id = 0,reward_name = <<"超值10"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 10,open_day_max = 10,circle = 0,discount = 2,cost = 60,string = <<"xxxx"/utf8>>,show = [{tips_show,8}],reward = [{0,36255006,1},{0,20010002,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,55) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 55,sort = 2,recharge_id = 0,reward_name = <<"超值10"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 250,vip_max = 499,open_day_min = 10,open_day_max = 10,circle = 0,discount = 2,cost = 180,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255006,2},{0,20010003,1}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,56) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 56,sort = 3,recharge_id = 0,reward_name = <<"超值10"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 99999,open_day_min = 10,open_day_max = 10,circle = 0,discount = 3,cost = 688,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255006,7},{0,20010003,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,61) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 61,sort = 1,recharge_id = 69,reward_name = <<"超值12"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 12,open_day_max = 12,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,18}],reward = [{0,34010146,5},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,62) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 62,sort = 2,recharge_id = 70,reward_name = <<"超值12"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 250,vip_max = 499,open_day_min = 12,open_day_max = 12,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,16}],reward = [{0,32010244,10},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,63) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 63,sort = 3,recharge_id = 71,reward_name = <<"超值12"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 99999,open_day_min = 12,open_day_max = 12,circle = 0,discount = 3,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,16}],reward = [{0,32010244,40},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,64) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 64,sort = 1,recharge_id = 0,reward_name = <<"超值15"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 15,open_day_max = 15,circle = 0,discount = 2,cost = 60,string = <<"xxxx"/utf8>>,show = [{tips_show,8}],reward = [{0,36255031,100},{0,20010002,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,65) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 65,sort = 2,recharge_id = 0,reward_name = <<"超值15"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 250,vip_max = 499,open_day_min = 15,open_day_max = 15,circle = 0,discount = 2,cost = 180,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,300},{0,20010003,1}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,66) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 66,sort = 3,recharge_id = 0,reward_name = <<"超值15"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 99999,open_day_min = 15,open_day_max = 15,circle = 0,discount = 3,cost = 688,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,800},{0,20010003,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,71) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 71,sort = 1,recharge_id = 72,reward_name = <<"超值17"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 17,open_day_max = 17,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,16}],reward = [{0,32010244,5},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,72) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 72,sort = 2,recharge_id = 73,reward_name = <<"超值17"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 1099,open_day_min = 17,open_day_max = 17,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,16}],reward = [{0,32010244,10},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,73) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 73,sort = 3,recharge_id = 74,reward_name = <<"超值17"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 1100,vip_max = 99999,open_day_min = 17,open_day_max = 17,circle = 0,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,15}],reward = [{0,34010085,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,74) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 74,sort = 1,recharge_id = 0,reward_name = <<"超值19"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 499,open_day_min = 19,open_day_max = 19,circle = 0,discount = 2,cost = 60,string = <<"xxxx"/utf8>>,show = [{tips_show,8}],reward = [{0,36255031,100},{0,20010002,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,75) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 75,sort = 2,recharge_id = 0,reward_name = <<"超值19"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 1099,open_day_min = 19,open_day_max = 19,circle = 0,discount = 2,cost = 180,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,300},{0,20010003,1}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,76) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 76,sort = 3,recharge_id = 0,reward_name = <<"超值19"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 1100,vip_max = 99999,open_day_min = 19,open_day_max = 19,circle = 0,discount = 3,cost = 688,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,800},{0,20010003,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,81) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 81,sort = 1,recharge_id = 75,reward_name = <<"超值24"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 499,open_day_min = 24,open_day_max = 24,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,16}],reward = [{0,32010244,5},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,82) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 82,sort = 2,recharge_id = 76,reward_name = <<"超值24"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 1099,open_day_min = 24,open_day_max = 24,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,14}],reward = [{0,34010060,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,83) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 83,sort = 3,recharge_id = 77,reward_name = <<"超值24"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 1100,vip_max = 99999,open_day_min = 24,open_day_max = 24,circle = 0,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,13}],reward = [{0,38040019,15},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,84) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 84,sort = 1,recharge_id = 0,reward_name = <<"超值27"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 499,open_day_min = 27,open_day_max = 27,circle = 0,discount = 2,cost = 60,string = <<"xxxx"/utf8>>,show = [{tips_show,8}],reward = [{0,36255031,100},{0,20010002,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,85) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 85,sort = 2,recharge_id = 0,reward_name = <<"超值27"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 1099,open_day_min = 27,open_day_max = 27,circle = 0,discount = 2,cost = 180,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,300},{0,20010003,1}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,86) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 86,sort = 3,recharge_id = 0,reward_name = <<"超值27"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 1100,vip_max = 99999,open_day_min = 27,open_day_max = 27,circle = 0,discount = 3,cost = 688,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,800},{0,20010003,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,91) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 91,sort = 1,recharge_id = 78,reward_name = <<"超值32"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 499,open_day_min = 32,open_day_max = 32,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,36}],reward = [{0,34010293,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,92) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 92,sort = 2,recharge_id = 79,reward_name = <<"超值32"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 2299,open_day_min = 32,open_day_max = 32,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,32}],reward = [{0,34010297,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,93) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 93,sort = 3,recharge_id = 80,reward_name = <<"超值32"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 2300,vip_max = 99999,open_day_min = 32,open_day_max = 32,circle = 0,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,28}],reward = [{0,34010301,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,94) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 94,sort = 1,recharge_id = 0,reward_name = <<"超值35"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 499,open_day_min = 35,open_day_max = 35,circle = 0,discount = 2,cost = 60,string = <<"xxxx"/utf8>>,show = [{tips_show,8}],reward = [{0,36255031,100},{0,20010002,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,95) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 95,sort = 2,recharge_id = 0,reward_name = <<"超值35"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 1099,open_day_min = 35,open_day_max = 35,circle = 0,discount = 2,cost = 180,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,300},{0,20010003,1}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,96) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 96,sort = 3,recharge_id = 0,reward_name = <<"超值35"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 1100,vip_max = 99999,open_day_min = 35,open_day_max = 35,circle = 0,discount = 3,cost = 688,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,800},{0,20010003,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,101) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 101,sort = 1,recharge_id = 81,reward_name = <<"超值40"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 150,vip_max = 499,open_day_min = 40,open_day_max = 40,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,35}],reward = [{0,34010294,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,102) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 102,sort = 2,recharge_id = 82,reward_name = <<"超值40"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 2299,open_day_min = 40,open_day_max = 40,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,31}],reward = [{0,34010298,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,103) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 103,sort = 3,recharge_id = 83,reward_name = <<"超值40"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 2300,vip_max = 99999,open_day_min = 40,open_day_max = 40,circle = 0,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,27}],reward = [{0,34010302,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,104) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 104,sort = 1,recharge_id = 0,reward_name = <<"超值42"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 499,open_day_min = 42,open_day_max = 42,circle = 0,discount = 2,cost = 60,string = <<"xxxx"/utf8>>,show = [{tips_show,8}],reward = [{0,36255031,100},{0,20010002,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,105) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 105,sort = 2,recharge_id = 0,reward_name = <<"超值42"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 1099,open_day_min = 42,open_day_max = 42,circle = 0,discount = 2,cost = 180,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,300},{0,20010003,1}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,106) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 106,sort = 3,recharge_id = 0,reward_name = <<"超值42"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 1100,vip_max = 99999,open_day_min = 42,open_day_max = 42,circle = 0,discount = 3,cost = 688,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,800},{0,20010003,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,111) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 111,sort = 1,recharge_id = 84,reward_name = <<"超值50"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 150,vip_max = 499,open_day_min = 50,open_day_max = 50,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,34}],reward = [{0,34010295,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,112) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 112,sort = 2,recharge_id = 85,reward_name = <<"超值50"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 2299,open_day_min = 50,open_day_max = 50,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,30}],reward = [{0,34010299,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,113) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 113,sort = 3,recharge_id = 86,reward_name = <<"超值50"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 2300,vip_max = 99999,open_day_min = 50,open_day_max = 50,circle = 0,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,26}],reward = [{0,34010303,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,114) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 114,sort = 1,recharge_id = 0,reward_name = <<"超值53"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 499,open_day_min = 53,open_day_max = 53,circle = 0,discount = 2,cost = 60,string = <<"xxxx"/utf8>>,show = [{tips_show,8}],reward = [{0,36255031,100},{0,20010002,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,115) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 115,sort = 2,recharge_id = 0,reward_name = <<"超值53"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 1099,open_day_min = 53,open_day_max = 53,circle = 0,discount = 2,cost = 180,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,300},{0,20010003,1}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,116) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 116,sort = 3,recharge_id = 0,reward_name = <<"超值53"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 1100,vip_max = 99999,open_day_min = 53,open_day_max = 53,circle = 0,discount = 3,cost = 688,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,800},{0,20010003,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,121) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 121,sort = 1,recharge_id = 88,reward_name = <<"超值22"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 249,open_day_min = 22,open_day_max = 22,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,16}],reward = [{0,32010244,5},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,122) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 122,sort = 2,recharge_id = 89,reward_name = <<"超值22"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 1099,open_day_min = 22,open_day_max = 22,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,16}],reward = [{0,32010244,10},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,123) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 123,sort = 3,recharge_id = 90,reward_name = <<"超值22"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 1100,vip_max = 99999,open_day_min = 22,open_day_max = 22,circle = 0,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,15}],reward = [{0,34010085,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,124) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 124,sort = 1,recharge_id = 91,reward_name = <<"超值30"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 499,open_day_min = 30,open_day_max = 30,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,16}],reward = [{0,32010244,5},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,125) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 125,sort = 2,recharge_id = 92,reward_name = <<"超值30"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 1099,open_day_min = 30,open_day_max = 30,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,14}],reward = [{0,34010060,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,126) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 126,sort = 3,recharge_id = 93,reward_name = <<"超值30"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 1100,vip_max = 99999,open_day_min = 30,open_day_max = 30,circle = 0,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,13}],reward = [{0,38040019,15},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,127) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 127,sort = 1,recharge_id = 94,reward_name = <<"超值37"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 499,open_day_min = 37,open_day_max = 37,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,36}],reward = [{0,34010293,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,128) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 128,sort = 2,recharge_id = 95,reward_name = <<"超值37"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 2299,open_day_min = 37,open_day_max = 37,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,32}],reward = [{0,34010297,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,129) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 129,sort = 3,recharge_id = 96,reward_name = <<"超值37"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 2300,vip_max = 99999,open_day_min = 37,open_day_max = 37,circle = 0,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,28}],reward = [{0,34010301,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,130) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 130,sort = 1,recharge_id = 97,reward_name = <<"超值45"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 150,vip_max = 499,open_day_min = 45,open_day_max = 45,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,35}],reward = [{0,34010294,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,131) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 131,sort = 2,recharge_id = 98,reward_name = <<"超值45"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 2299,open_day_min = 45,open_day_max = 45,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,31}],reward = [{0,34010298,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,132) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 132,sort = 3,recharge_id = 99,reward_name = <<"超值45"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 2300,vip_max = 99999,open_day_min = 45,open_day_max = 45,circle = 0,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,27}],reward = [{0,34010302,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,133) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 133,sort = 1,recharge_id = 0,reward_name = <<"超值47"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 499,open_day_min = 47,open_day_max = 47,circle = 0,discount = 2,cost = 60,string = <<"xxxx"/utf8>>,show = [{tips_show,8}],reward = [{0,36255031,100},{0,20010002,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,134) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 134,sort = 2,recharge_id = 0,reward_name = <<"超值47"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 1099,open_day_min = 47,open_day_max = 47,circle = 0,discount = 2,cost = 180,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,300},{0,20010003,1}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,135) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 135,sort = 3,recharge_id = 0,reward_name = <<"超值47"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 1100,vip_max = 99999,open_day_min = 47,open_day_max = 47,circle = 0,discount = 3,cost = 688,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,800},{0,20010003,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,136) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 136,sort = 1,recharge_id = 100,reward_name = <<"超值56"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 150,vip_max = 499,open_day_min = 56,open_day_max = 56,circle = 0,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,34}],reward = [{0,34010295,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,137) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 137,sort = 2,recharge_id = 101,reward_name = <<"超值56"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 2299,open_day_min = 56,open_day_max = 56,circle = 0,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,30}],reward = [{0,34010299,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,138) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 138,sort = 3,recharge_id = 102,reward_name = <<"超值56"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 2300,vip_max = 99999,open_day_min = 56,open_day_max = 56,circle = 0,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,26}],reward = [{0,34010303,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,139) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 139,sort = 1,recharge_id = 103,reward_name = <<"超值60+6"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 150,vip_max = 499,open_day_min = 60,open_day_max = 60,circle = 6,discount = 1,cost = 6,string = <<"xxxx"/utf8>>,show = [{tips_show,33}],reward = [{0,34010296,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,140) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 140,sort = 2,recharge_id = 104,reward_name = <<"超值60+6"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 4299,open_day_min = 60,open_day_max = 60,circle = 6,discount = 2,cost = 18,string = <<"xxxx"/utf8>>,show = [{tips_show,29}],reward = [{0,34010300,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,141) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 141,sort = 3,recharge_id = 105,reward_name = <<"超值60+6"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 4300,vip_max = 99999,open_day_min = 60,open_day_max = 60,circle = 6,discount = 4,cost = 128,string = <<"xxxx"/utf8>>,show = [{tips_show,25}],reward = [{0,34010304,1},{0,32010189,1}],condition = [{cost_type,3}]};

get_gift_reward_cfg(66,1,142) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 142,sort = 1,recharge_id = 0,reward_name = <<"超值63+6"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 50,vip_max = 499,open_day_min = 63,open_day_max = 63,circle = 6,discount = 2,cost = 60,string = <<"xxxx"/utf8>>,show = [{tips_show,8}],reward = [{0,36255031,100},{0,20010002,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,143) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 143,sort = 2,recharge_id = 0,reward_name = <<"超值63+6"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 500,vip_max = 1099,open_day_min = 63,open_day_max = 63,circle = 6,discount = 2,cost = 180,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,300},{0,20010003,1}],condition = [{cost_type,1}]};

get_gift_reward_cfg(66,1,144) ->
	#base_lv_gift_reward{act_type = 66,act_subtype = 1,grade = 144,sort = 3,recharge_id = 0,reward_name = <<"超值63+6"/utf8>>,lv_min = 0,lv_max = 0,vip_min = 1100,vip_max = 99999,open_day_min = 63,open_day_max = 63,circle = 6,discount = 3,cost = 688,string = <<"xxxx"/utf8>>,show = [{tips_show,7}],reward = [{0,36255031,800},{0,20010003,2}],condition = [{cost_type,1}]};

get_gift_reward_cfg(_Acttype,_Actsubtype,_Grade) ->
	[].

get_gift_day_limit() ->
[{2,2},{3,3},{4,4},{5,5},{7,7},{8,8},{9,9},{10,10},{12,12},{15,15},{17,17},{19,19},{24,24},{27,27},{32,32},{35,35},{40,40},{42,42},{50,50},{53,53},{22,22},{30,30},{37,37},{45,45},{47,47},{56,56},{60,60},{63,63}].

get_circle_type() ->
[0,6].


get_act_information(51) ->
[{66,1,1}];


get_act_information(52) ->
[{66,1,2}];


get_act_information(53) ->
[{66,1,3}];


get_act_information(54) ->
[{66,1,11}];


get_act_information(55) ->
[{66,1,12}];


get_act_information(56) ->
[{66,1,13}];


get_act_information(57) ->
[{66,1,21}];


get_act_information(58) ->
[{66,1,22}];


get_act_information(59) ->
[{66,1,23}];


get_act_information(60) ->
[{66,1,31}];


get_act_information(61) ->
[{66,1,32}];


get_act_information(62) ->
[{66,1,33}];


get_act_information(63) ->
[{66,1,41}];


get_act_information(64) ->
[{66,1,42}];


get_act_information(65) ->
[{66,1,43}];


get_act_information(0) ->
[{66,1,44},{66,1,45},{66,1,46},{66,1,54},{66,1,55},{66,1,56},{66,1,64},{66,1,65},{66,1,66},{66,1,74},{66,1,75},{66,1,76},{66,1,84},{66,1,85},{66,1,86},{66,1,94},{66,1,95},{66,1,96},{66,1,104},{66,1,105},{66,1,106},{66,1,114},{66,1,115},{66,1,116},{66,1,133},{66,1,134},{66,1,135},{66,1,142},{66,1,143},{66,1,144}];


get_act_information(66) ->
[{66,1,51}];


get_act_information(67) ->
[{66,1,52}];


get_act_information(68) ->
[{66,1,53}];


get_act_information(69) ->
[{66,1,61}];


get_act_information(70) ->
[{66,1,62}];


get_act_information(71) ->
[{66,1,63}];


get_act_information(72) ->
[{66,1,71}];


get_act_information(73) ->
[{66,1,72}];


get_act_information(74) ->
[{66,1,73}];


get_act_information(75) ->
[{66,1,81}];


get_act_information(76) ->
[{66,1,82}];


get_act_information(77) ->
[{66,1,83}];


get_act_information(78) ->
[{66,1,91}];


get_act_information(79) ->
[{66,1,92}];


get_act_information(80) ->
[{66,1,93}];


get_act_information(81) ->
[{66,1,101}];


get_act_information(82) ->
[{66,1,102}];


get_act_information(83) ->
[{66,1,103}];


get_act_information(84) ->
[{66,1,111}];


get_act_information(85) ->
[{66,1,112}];


get_act_information(86) ->
[{66,1,113}];


get_act_information(88) ->
[{66,1,121}];


get_act_information(89) ->
[{66,1,122}];


get_act_information(90) ->
[{66,1,123}];


get_act_information(91) ->
[{66,1,124}];


get_act_information(92) ->
[{66,1,125}];


get_act_information(93) ->
[{66,1,126}];


get_act_information(94) ->
[{66,1,127}];


get_act_information(95) ->
[{66,1,128}];


get_act_information(96) ->
[{66,1,129}];


get_act_information(97) ->
[{66,1,130}];


get_act_information(98) ->
[{66,1,131}];


get_act_information(99) ->
[{66,1,132}];


get_act_information(100) ->
[{66,1,136}];


get_act_information(101) ->
[{66,1,137}];


get_act_information(102) ->
[{66,1,138}];


get_act_information(103) ->
[{66,1,139}];


get_act_information(104) ->
[{66,1,140}];


get_act_information(105) ->
[{66,1,141}];

get_act_information(_Rechargeid) ->
	[].

get_act_info_by_sort(1,2,2) ->
[{66,1,1}];

get_act_info_by_sort(1,3,3) ->
[{66,1,11}];

get_act_info_by_sort(1,4,4) ->
[{66,1,21}];

get_act_info_by_sort(1,5,5) ->
[{66,1,31}];

get_act_info_by_sort(1,7,7) ->
[{66,1,41}];

get_act_info_by_sort(1,8,8) ->
[{66,1,44}];

get_act_info_by_sort(1,9,9) ->
[{66,1,51}];

get_act_info_by_sort(1,10,10) ->
[{66,1,54}];

get_act_info_by_sort(1,12,12) ->
[{66,1,61}];

get_act_info_by_sort(1,15,15) ->
[{66,1,64}];

get_act_info_by_sort(1,17,17) ->
[{66,1,71}];

get_act_info_by_sort(1,19,19) ->
[{66,1,74}];

get_act_info_by_sort(1,24,24) ->
[{66,1,81}];

get_act_info_by_sort(1,27,27) ->
[{66,1,84}];

get_act_info_by_sort(1,32,32) ->
[{66,1,91}];

get_act_info_by_sort(1,35,35) ->
[{66,1,94}];

get_act_info_by_sort(1,40,40) ->
[{66,1,101}];

get_act_info_by_sort(1,42,42) ->
[{66,1,104}];

get_act_info_by_sort(1,50,50) ->
[{66,1,111}];

get_act_info_by_sort(1,53,53) ->
[{66,1,114}];

get_act_info_by_sort(1,22,22) ->
[{66,1,121}];

get_act_info_by_sort(1,30,30) ->
[{66,1,124}];

get_act_info_by_sort(1,37,37) ->
[{66,1,127}];

get_act_info_by_sort(1,45,45) ->
[{66,1,130}];

get_act_info_by_sort(1,47,47) ->
[{66,1,133}];

get_act_info_by_sort(1,56,56) ->
[{66,1,136}];

get_act_info_by_sort(1,60,60) ->
[{66,1,139}];

get_act_info_by_sort(1,63,63) ->
[{66,1,142}];

get_act_info_by_sort(2,2,2) ->
[{66,1,2}];

get_act_info_by_sort(2,3,3) ->
[{66,1,12}];

get_act_info_by_sort(2,4,4) ->
[{66,1,22}];

get_act_info_by_sort(2,5,5) ->
[{66,1,32}];

get_act_info_by_sort(2,7,7) ->
[{66,1,42}];

get_act_info_by_sort(2,8,8) ->
[{66,1,45}];

get_act_info_by_sort(2,9,9) ->
[{66,1,52}];

get_act_info_by_sort(2,10,10) ->
[{66,1,55}];

get_act_info_by_sort(2,12,12) ->
[{66,1,62}];

get_act_info_by_sort(2,15,15) ->
[{66,1,65}];

get_act_info_by_sort(2,17,17) ->
[{66,1,72}];

get_act_info_by_sort(2,19,19) ->
[{66,1,75}];

get_act_info_by_sort(2,24,24) ->
[{66,1,82}];

get_act_info_by_sort(2,27,27) ->
[{66,1,85}];

get_act_info_by_sort(2,32,32) ->
[{66,1,92}];

get_act_info_by_sort(2,35,35) ->
[{66,1,95}];

get_act_info_by_sort(2,40,40) ->
[{66,1,102}];

get_act_info_by_sort(2,42,42) ->
[{66,1,105}];

get_act_info_by_sort(2,50,50) ->
[{66,1,112}];

get_act_info_by_sort(2,53,53) ->
[{66,1,115}];

get_act_info_by_sort(2,22,22) ->
[{66,1,122}];

get_act_info_by_sort(2,30,30) ->
[{66,1,125}];

get_act_info_by_sort(2,37,37) ->
[{66,1,128}];

get_act_info_by_sort(2,45,45) ->
[{66,1,131}];

get_act_info_by_sort(2,47,47) ->
[{66,1,134}];

get_act_info_by_sort(2,56,56) ->
[{66,1,137}];

get_act_info_by_sort(2,60,60) ->
[{66,1,140}];

get_act_info_by_sort(2,63,63) ->
[{66,1,143}];

get_act_info_by_sort(3,2,2) ->
[{66,1,3}];

get_act_info_by_sort(3,3,3) ->
[{66,1,13}];

get_act_info_by_sort(3,4,4) ->
[{66,1,23}];

get_act_info_by_sort(3,5,5) ->
[{66,1,33}];

get_act_info_by_sort(3,7,7) ->
[{66,1,43}];

get_act_info_by_sort(3,8,8) ->
[{66,1,46}];

get_act_info_by_sort(3,9,9) ->
[{66,1,53}];

get_act_info_by_sort(3,10,10) ->
[{66,1,56}];

get_act_info_by_sort(3,12,12) ->
[{66,1,63}];

get_act_info_by_sort(3,15,15) ->
[{66,1,66}];

get_act_info_by_sort(3,17,17) ->
[{66,1,73}];

get_act_info_by_sort(3,19,19) ->
[{66,1,76}];

get_act_info_by_sort(3,24,24) ->
[{66,1,83}];

get_act_info_by_sort(3,27,27) ->
[{66,1,86}];

get_act_info_by_sort(3,32,32) ->
[{66,1,93}];

get_act_info_by_sort(3,35,35) ->
[{66,1,96}];

get_act_info_by_sort(3,40,40) ->
[{66,1,103}];

get_act_info_by_sort(3,42,42) ->
[{66,1,106}];

get_act_info_by_sort(3,50,50) ->
[{66,1,113}];

get_act_info_by_sort(3,53,53) ->
[{66,1,116}];

get_act_info_by_sort(3,22,22) ->
[{66,1,123}];

get_act_info_by_sort(3,30,30) ->
[{66,1,126}];

get_act_info_by_sort(3,37,37) ->
[{66,1,129}];

get_act_info_by_sort(3,45,45) ->
[{66,1,132}];

get_act_info_by_sort(3,47,47) ->
[{66,1,135}];

get_act_info_by_sort(3,56,56) ->
[{66,1,138}];

get_act_info_by_sort(3,60,60) ->
[{66,1,141}];

get_act_info_by_sort(3,63,63) ->
[{66,1,144}];

get_act_info_by_sort(_Sort,_Opendaymin,_Opendaymax) ->
	[].

get_grade_sort(66,1,1) ->
[1];

get_grade_sort(66,1,2) ->
[2];

get_grade_sort(66,1,3) ->
[3];

get_grade_sort(66,1,11) ->
[1];

get_grade_sort(66,1,12) ->
[2];

get_grade_sort(66,1,13) ->
[3];

get_grade_sort(66,1,21) ->
[1];

get_grade_sort(66,1,22) ->
[2];

get_grade_sort(66,1,23) ->
[3];

get_grade_sort(66,1,31) ->
[1];

get_grade_sort(66,1,32) ->
[2];

get_grade_sort(66,1,33) ->
[3];

get_grade_sort(66,1,41) ->
[1];

get_grade_sort(66,1,42) ->
[2];

get_grade_sort(66,1,43) ->
[3];

get_grade_sort(66,1,44) ->
[1];

get_grade_sort(66,1,45) ->
[2];

get_grade_sort(66,1,46) ->
[3];

get_grade_sort(66,1,51) ->
[1];

get_grade_sort(66,1,52) ->
[2];

get_grade_sort(66,1,53) ->
[3];

get_grade_sort(66,1,54) ->
[1];

get_grade_sort(66,1,55) ->
[2];

get_grade_sort(66,1,56) ->
[3];

get_grade_sort(66,1,61) ->
[1];

get_grade_sort(66,1,62) ->
[2];

get_grade_sort(66,1,63) ->
[3];

get_grade_sort(66,1,64) ->
[1];

get_grade_sort(66,1,65) ->
[2];

get_grade_sort(66,1,66) ->
[3];

get_grade_sort(66,1,71) ->
[1];

get_grade_sort(66,1,72) ->
[2];

get_grade_sort(66,1,73) ->
[3];

get_grade_sort(66,1,74) ->
[1];

get_grade_sort(66,1,75) ->
[2];

get_grade_sort(66,1,76) ->
[3];

get_grade_sort(66,1,81) ->
[1];

get_grade_sort(66,1,82) ->
[2];

get_grade_sort(66,1,83) ->
[3];

get_grade_sort(66,1,84) ->
[1];

get_grade_sort(66,1,85) ->
[2];

get_grade_sort(66,1,86) ->
[3];

get_grade_sort(66,1,91) ->
[1];

get_grade_sort(66,1,92) ->
[2];

get_grade_sort(66,1,93) ->
[3];

get_grade_sort(66,1,94) ->
[1];

get_grade_sort(66,1,95) ->
[2];

get_grade_sort(66,1,96) ->
[3];

get_grade_sort(66,1,101) ->
[1];

get_grade_sort(66,1,102) ->
[2];

get_grade_sort(66,1,103) ->
[3];

get_grade_sort(66,1,104) ->
[1];

get_grade_sort(66,1,105) ->
[2];

get_grade_sort(66,1,106) ->
[3];

get_grade_sort(66,1,111) ->
[1];

get_grade_sort(66,1,112) ->
[2];

get_grade_sort(66,1,113) ->
[3];

get_grade_sort(66,1,114) ->
[1];

get_grade_sort(66,1,115) ->
[2];

get_grade_sort(66,1,116) ->
[3];

get_grade_sort(66,1,121) ->
[1];

get_grade_sort(66,1,122) ->
[2];

get_grade_sort(66,1,123) ->
[3];

get_grade_sort(66,1,124) ->
[1];

get_grade_sort(66,1,125) ->
[2];

get_grade_sort(66,1,126) ->
[3];

get_grade_sort(66,1,127) ->
[1];

get_grade_sort(66,1,128) ->
[2];

get_grade_sort(66,1,129) ->
[3];

get_grade_sort(66,1,130) ->
[1];

get_grade_sort(66,1,131) ->
[2];

get_grade_sort(66,1,132) ->
[3];

get_grade_sort(66,1,133) ->
[1];

get_grade_sort(66,1,134) ->
[2];

get_grade_sort(66,1,135) ->
[3];

get_grade_sort(66,1,136) ->
[1];

get_grade_sort(66,1,137) ->
[2];

get_grade_sort(66,1,138) ->
[3];

get_grade_sort(66,1,139) ->
[1];

get_grade_sort(66,1,140) ->
[2];

get_grade_sort(66,1,141) ->
[3];

get_grade_sort(66,1,142) ->
[1];

get_grade_sort(66,1,143) ->
[2];

get_grade_sort(66,1,144) ->
[3];

get_grade_sort(_Acttype,_Actsubtype,_Grade) ->
	[].

get_grade_by_day(2,2) ->
[1,2,3];

get_grade_by_day(3,3) ->
[11,12,13];

get_grade_by_day(4,4) ->
[21,22,23];

get_grade_by_day(5,5) ->
[31,32,33];

get_grade_by_day(7,7) ->
[41,42,43];

get_grade_by_day(8,8) ->
[44,45,46];

get_grade_by_day(9,9) ->
[51,52,53];

get_grade_by_day(10,10) ->
[54,55,56];

get_grade_by_day(12,12) ->
[61,62,63];

get_grade_by_day(15,15) ->
[64,65,66];

get_grade_by_day(17,17) ->
[71,72,73];

get_grade_by_day(19,19) ->
[74,75,76];

get_grade_by_day(24,24) ->
[81,82,83];

get_grade_by_day(27,27) ->
[84,85,86];

get_grade_by_day(32,32) ->
[91,92,93];

get_grade_by_day(35,35) ->
[94,95,96];

get_grade_by_day(40,40) ->
[101,102,103];

get_grade_by_day(42,42) ->
[104,105,106];

get_grade_by_day(50,50) ->
[111,112,113];

get_grade_by_day(53,53) ->
[114,115,116];

get_grade_by_day(22,22) ->
[121,122,123];

get_grade_by_day(30,30) ->
[124,125,126];

get_grade_by_day(37,37) ->
[127,128,129];

get_grade_by_day(45,45) ->
[130,131,132];

get_grade_by_day(47,47) ->
[133,134,135];

get_grade_by_day(56,56) ->
[136,137,138];

get_grade_by_day(60,60) ->
[139,140,141];

get_grade_by_day(63,63) ->
[142,143,144];

get_grade_by_day(_Opendaymin,_Opendaymax) ->
	[].


get_circle_grade(0) ->
[1,2,3,11,12,13,21,22,23,31,32,33,41,42,43,44,45,46,51,52,53,54,55,56,61,62,63,64,65,66,71,72,73,74,75,76,81,82,83,84,85,86,91,92,93,94,95,96,101,102,103,104,105,106,111,112,113,114,115,116,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138];


get_circle_grade(6) ->
[139,140,141,142,143,144];

get_circle_grade(_Circle) ->
	[].

