%%%---------------------------------------
%%% module      : data_drop_ratio
%%% description : 掉落概率倍率配置
%%%
%%%---------------------------------------
-module(data_drop_ratio).
-compile(export_all).



get_ratio_id_list() ->
[22001,34001,34000501,34000502,34000503,34000504,34000505,34000601,34000602,34000603,34000604,34000605].

get_ratio(22001,_Count) when _Count >= 16 ->
		20000;
get_ratio(22001,_Count) when _Count >= 15 ->
		19000;
get_ratio(22001,_Count) when _Count >= 14 ->
		18000;
get_ratio(22001,_Count) when _Count >= 13 ->
		17000;
get_ratio(22001,_Count) when _Count >= 12 ->
		16000;
get_ratio(22001,_Count) when _Count >= 11 ->
		15000;
get_ratio(22001,_Count) when _Count >= 10 ->
		14000;
get_ratio(22001,_Count) when _Count >= 9 ->
		13000;
get_ratio(22001,_Count) when _Count >= 8 ->
		12000;
get_ratio(22001,_Count) when _Count >= 7 ->
		11000;
get_ratio(22001,_Count) when _Count >= 6 ->
		10000;
get_ratio(22001,_Count) when _Count >= 5 ->
		9000;
get_ratio(22001,_Count) when _Count >= 4 ->
		8000;
get_ratio(22001,_Count) when _Count >= 3 ->
		7000;
get_ratio(22001,_Count) when _Count >= 2 ->
		6000;
get_ratio(22001,_Count) when _Count >= 1 ->
		5000;
get_ratio(34001,_Count) when _Count >= 11 ->
		20000;
get_ratio(34001,_Count) when _Count >= 10 ->
		18500;
get_ratio(34001,_Count) when _Count >= 9 ->
		17000;
get_ratio(34001,_Count) when _Count >= 8 ->
		15500;
get_ratio(34001,_Count) when _Count >= 7 ->
		14000;
get_ratio(34001,_Count) when _Count >= 6 ->
		12500;
get_ratio(34001,_Count) when _Count >= 5 ->
		11000;
get_ratio(34001,_Count) when _Count >= 4 ->
		9500;
get_ratio(34001,_Count) when _Count >= 3 ->
		8000;
get_ratio(34001,_Count) when _Count >= 2 ->
		6500;
get_ratio(34001,_Count) when _Count >= 1 ->
		5000;
get_ratio(34000501,_Count) when _Count >= 3 ->
		99000;
get_ratio(34000501,_Count) when _Count >= 2 ->
		3000;
get_ratio(34000501,_Count) when _Count >= 1 ->
		429;
get_ratio(34000502,_Count) when _Count >= 6 ->
		99000;
get_ratio(34000502,_Count) when _Count >= 5 ->
		1500;
get_ratio(34000502,_Count) when _Count >= 4 ->
		250;
get_ratio(34000502,_Count) when _Count >= 3 ->
		0;
get_ratio(34000502,_Count) when _Count >= 2 ->
		0;
get_ratio(34000502,_Count) when _Count >= 1 ->
		0;
get_ratio(34000503,_Count) when _Count >= 9 ->
		99000;
get_ratio(34000503,_Count) when _Count >= 8 ->
		538;
get_ratio(34000503,_Count) when _Count >= 7 ->
		176;
get_ratio(34000503,_Count) when _Count >= 6 ->
		0;
get_ratio(34000503,_Count) when _Count >= 5 ->
		0;
get_ratio(34000503,_Count) when _Count >= 4 ->
		0;
get_ratio(34000503,_Count) when _Count >= 3 ->
		0;
get_ratio(34000503,_Count) when _Count >= 2 ->
		0;
get_ratio(34000503,_Count) when _Count >= 1 ->
		0;
get_ratio(34000504,_Count) when _Count >= 14 ->
		99000;
get_ratio(34000504,_Count) when _Count >= 13 ->
		1500;
get_ratio(34000504,_Count) when _Count >= 12 ->
		1222;
get_ratio(34000504,_Count) when _Count >= 11 ->
		333;
get_ratio(34000504,_Count) when _Count >= 10 ->
		176;
get_ratio(34000504,_Count) when _Count >= 9 ->
		0;
get_ratio(34000504,_Count) when _Count >= 8 ->
		0;
get_ratio(34000504,_Count) when _Count >= 7 ->
		0;
get_ratio(34000504,_Count) when _Count >= 6 ->
		0;
get_ratio(34000504,_Count) when _Count >= 5 ->
		0;
get_ratio(34000504,_Count) when _Count >= 4 ->
		0;
get_ratio(34000504,_Count) when _Count >= 3 ->
		0;
get_ratio(34000504,_Count) when _Count >= 2 ->
		0;
get_ratio(34000504,_Count) when _Count >= 1 ->
		0;
get_ratio(34000505,_Count) when _Count >= 19 ->
		99000;
get_ratio(34000505,_Count) when _Count >= 18 ->
		1500;
get_ratio(34000505,_Count) when _Count >= 17 ->
		1222;
get_ratio(34000505,_Count) when _Count >= 16 ->
		333;
get_ratio(34000505,_Count) when _Count >= 15 ->
		176;
get_ratio(34000505,_Count) when _Count >= 14 ->
		0;
get_ratio(34000505,_Count) when _Count >= 13 ->
		0;
get_ratio(34000505,_Count) when _Count >= 12 ->
		0;
get_ratio(34000505,_Count) when _Count >= 11 ->
		0;
get_ratio(34000505,_Count) when _Count >= 10 ->
		0;
get_ratio(34000505,_Count) when _Count >= 9 ->
		0;
get_ratio(34000505,_Count) when _Count >= 8 ->
		0;
get_ratio(34000505,_Count) when _Count >= 7 ->
		0;
get_ratio(34000505,_Count) when _Count >= 6 ->
		0;
get_ratio(34000505,_Count) when _Count >= 5 ->
		0;
get_ratio(34000505,_Count) when _Count >= 4 ->
		0;
get_ratio(34000505,_Count) when _Count >= 3 ->
		0;
get_ratio(34000505,_Count) when _Count >= 2 ->
		0;
get_ratio(34000505,_Count) when _Count >= 1 ->
		0;
get_ratio(34000601,_Count) when _Count >= 3 ->
		99000;
get_ratio(34000601,_Count) when _Count >= 2 ->
		3000;
get_ratio(34000601,_Count) when _Count >= 1 ->
		429;
get_ratio(34000602,_Count) when _Count >= 6 ->
		99000;
get_ratio(34000602,_Count) when _Count >= 5 ->
		1500;
get_ratio(34000602,_Count) when _Count >= 4 ->
		250;
get_ratio(34000602,_Count) when _Count >= 3 ->
		0;
get_ratio(34000602,_Count) when _Count >= 2 ->
		0;
get_ratio(34000602,_Count) when _Count >= 1 ->
		0;
get_ratio(34000603,_Count) when _Count >= 9 ->
		99000;
get_ratio(34000603,_Count) when _Count >= 8 ->
		538;
get_ratio(34000603,_Count) when _Count >= 7 ->
		176;
get_ratio(34000603,_Count) when _Count >= 6 ->
		0;
get_ratio(34000603,_Count) when _Count >= 5 ->
		0;
get_ratio(34000603,_Count) when _Count >= 4 ->
		0;
get_ratio(34000603,_Count) when _Count >= 3 ->
		0;
get_ratio(34000603,_Count) when _Count >= 2 ->
		0;
get_ratio(34000603,_Count) when _Count >= 1 ->
		0;
get_ratio(34000604,_Count) when _Count >= 14 ->
		99000;
get_ratio(34000604,_Count) when _Count >= 13 ->
		1500;
get_ratio(34000604,_Count) when _Count >= 12 ->
		1222;
get_ratio(34000604,_Count) when _Count >= 11 ->
		333;
get_ratio(34000604,_Count) when _Count >= 10 ->
		176;
get_ratio(34000604,_Count) when _Count >= 9 ->
		0;
get_ratio(34000604,_Count) when _Count >= 8 ->
		0;
get_ratio(34000604,_Count) when _Count >= 7 ->
		0;
get_ratio(34000604,_Count) when _Count >= 6 ->
		0;
get_ratio(34000604,_Count) when _Count >= 5 ->
		0;
get_ratio(34000604,_Count) when _Count >= 4 ->
		0;
get_ratio(34000604,_Count) when _Count >= 3 ->
		0;
get_ratio(34000604,_Count) when _Count >= 2 ->
		0;
get_ratio(34000604,_Count) when _Count >= 1 ->
		0;
get_ratio(34000605,_Count) when _Count >= 19 ->
		99000;
get_ratio(34000605,_Count) when _Count >= 18 ->
		1500;
get_ratio(34000605,_Count) when _Count >= 17 ->
		1222;
get_ratio(34000605,_Count) when _Count >= 16 ->
		333;
get_ratio(34000605,_Count) when _Count >= 15 ->
		176;
get_ratio(34000605,_Count) when _Count >= 14 ->
		0;
get_ratio(34000605,_Count) when _Count >= 13 ->
		0;
get_ratio(34000605,_Count) when _Count >= 12 ->
		0;
get_ratio(34000605,_Count) when _Count >= 11 ->
		0;
get_ratio(34000605,_Count) when _Count >= 10 ->
		0;
get_ratio(34000605,_Count) when _Count >= 9 ->
		0;
get_ratio(34000605,_Count) when _Count >= 8 ->
		0;
get_ratio(34000605,_Count) when _Count >= 7 ->
		0;
get_ratio(34000605,_Count) when _Count >= 6 ->
		0;
get_ratio(34000605,_Count) when _Count >= 5 ->
		0;
get_ratio(34000605,_Count) when _Count >= 4 ->
		0;
get_ratio(34000605,_Count) when _Count >= 3 ->
		0;
get_ratio(34000605,_Count) when _Count >= 2 ->
		0;
get_ratio(34000605,_Count) when _Count >= 1 ->
		0;
get_ratio(_Id,_Count) ->
	0.

get_additional_drop_ratio(380001,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380001,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380001,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380001,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380001,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380002,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380002,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380002,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380002,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380002,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380003,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380003,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380003,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380003,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380003,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380004,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380004,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380004,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380004,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380004,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380005,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380005,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380005,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380005,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380005,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380006,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380006,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380006,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380006,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380006,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380007,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380007,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380007,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380007,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380007,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380008,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380008,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380008,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380008,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380008,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380009,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380009,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380009,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380009,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380009,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380010,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380010,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380010,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380010,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380010,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380011,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380011,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380011,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380011,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380011,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380012,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380012,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380012,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380012,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380012,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380013,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380013,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380013,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380013,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380013,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380014,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380014,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380014,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380014,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380014,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380015,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380015,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380015,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380015,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380015,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380016,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380016,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380016,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380016,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380016,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380017,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380017,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380017,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380017,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380017,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380018,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380018,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380018,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380018,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380018,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380019,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380019,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380019,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380019,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380019,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380020,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380020,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380020,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380020,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380020,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380021,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380021,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380021,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380021,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380021,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380022,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380022,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380022,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380022,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380022,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380023,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380023,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380023,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380023,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380023,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380024,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380024,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380024,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380024,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380024,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380025,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380025,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380025,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380025,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380025,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380026,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380026,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380026,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380026,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380026,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380027,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380027,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380027,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380027,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380027,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380028,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380028,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380028,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380028,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380028,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380029,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380029,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380029,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380029,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380029,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380030,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380030,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380030,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380030,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380030,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380031,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380031,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380031,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380031,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380031,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380032,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380032,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380032,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380032,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380032,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380033,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380033,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380033,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380033,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380033,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380034,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380034,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380034,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380034,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380034,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380035,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380035,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380035,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380035,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380035,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380036,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380036,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380036,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380036,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380036,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380037,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380037,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380037,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380037,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380037,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380038,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380038,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380038,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380038,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380038,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380039,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380039,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380039,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380039,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380039,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380040,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380040,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380040,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380040,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380040,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380041,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380041,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380041,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380041,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380041,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380042,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380042,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380042,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380042,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380042,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380043,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380043,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380043,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380043,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380043,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380044,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380044,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380044,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380044,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380044,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380045,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380045,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380045,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380045,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380045,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380046,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380046,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380046,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380046,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380046,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380047,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380047,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380047,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380047,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380047,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380048,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380048,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380048,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380048,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380048,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380049,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380049,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380049,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380049,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380049,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380050,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380050,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380050,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380050,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380050,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380051,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380051,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380051,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380051,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380051,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380052,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380052,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380052,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380052,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380052,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380053,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380053,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380053,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380053,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380053,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380054,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380054,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380054,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380054,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380054,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380055,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380055,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380055,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380055,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380055,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380056,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380056,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380056,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380056,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380056,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380057,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380057,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380057,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380057,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380057,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380058,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380058,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380058,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380058,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380058,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380059,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380059,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380059,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380059,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380059,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380060,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380060,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380060,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380060,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380060,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380061,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380061,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380061,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380061,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380061,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380062,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380062,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380062,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380062,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380062,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380063,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380063,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380063,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380063,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380063,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380064,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380064,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380064,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380064,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380064,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380065,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380065,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380065,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380065,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380065,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380066,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380066,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380066,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380066,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380066,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380067,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380067,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380067,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380067,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380067,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380068,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380068,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380068,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380068,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380068,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380069,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380069,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380069,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380069,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380069,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380070,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380070,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380070,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380070,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380070,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380071,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380071,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380071,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380071,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380071,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380072,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380072,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380072,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380072,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380072,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380073,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380073,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380073,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380073,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380073,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380074,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380074,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380074,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380074,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380074,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380075,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380075,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380075,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380075,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380075,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380076,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380076,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380076,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380076,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380076,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380077,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380077,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380077,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380077,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380077,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380078,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380078,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380078,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380078,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380078,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380079,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380079,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380079,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380079,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380079,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380080,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380080,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380080,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380080,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380080,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380081,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380081,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380081,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380081,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380081,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380082,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380082,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380082,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380082,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380082,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380083,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380083,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380083,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380083,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380083,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380084,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380084,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380084,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380084,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380084,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380085,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380085,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380085,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380085,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380085,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380086,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380086,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380086,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380086,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380086,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380087,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380087,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380087,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380087,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380087,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380088,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380088,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380088,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380088,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380088,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380089,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380089,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380089,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380089,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380089,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380090,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380090,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380090,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380090,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380090,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380091,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380091,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380091,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380091,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380091,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380092,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380092,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380092,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380092,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380092,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380093,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380093,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380093,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380093,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380093,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380094,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380094,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380094,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380094,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380094,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380095,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380095,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380095,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380095,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380095,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380096,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380096,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380096,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380096,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380096,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380097,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380097,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380097,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380097,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380097,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380098,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380098,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380098,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380098,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380098,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380099,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380099,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380099,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380099,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380099,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380100,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380100,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380100,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380100,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380100,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380101,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380101,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380101,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380101,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380101,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380102,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380102,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380102,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380102,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380102,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380103,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380103,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380103,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380103,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380103,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380104,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380104,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380104,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380104,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380104,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380105,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380105,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380105,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380105,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380105,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380106,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380106,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380106,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380106,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380106,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380107,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380107,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380107,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380107,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380107,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380108,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380108,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380108,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380108,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380108,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380109,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380109,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380109,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380109,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380109,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380110,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380110,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380110,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380110,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380110,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380111,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380111,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380111,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380111,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380111,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380112,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380112,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380112,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380112,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380112,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380113,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380113,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380113,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380113,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380113,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380114,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380114,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380114,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380114,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380114,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380115,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380115,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380115,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380115,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380115,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380116,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380116,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380116,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380116,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380116,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380117,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380117,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380117,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380117,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380117,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380118,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380118,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380118,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380118,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380118,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380119,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380119,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380119,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380119,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380119,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380120,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380120,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380120,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380120,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380120,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380121,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380121,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380121,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380121,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380121,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380122,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380122,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380122,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380122,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380122,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380123,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380123,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380123,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380123,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380123,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380124,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380124,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380124,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380124,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380124,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380125,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380125,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380125,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380125,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380125,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380126,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380126,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380126,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380126,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380126,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380127,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380127,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380127,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380127,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380127,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380128,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380128,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380128,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380128,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380128,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380129,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380129,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380129,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380129,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380129,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380130,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380130,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380130,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380130,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380130,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380131,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380131,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380131,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380131,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380131,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380132,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380132,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380132,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380132,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380132,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380133,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380133,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380133,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380133,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380133,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380134,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380134,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380134,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380134,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380134,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380135,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380135,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380135,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380135,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380135,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380136,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380136,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380136,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380136,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380136,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380137,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380137,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380137,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380137,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380137,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380138,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380138,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380138,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380138,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380138,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380139,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380139,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380139,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380139,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380139,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380140,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380140,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380140,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380140,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380140,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380141,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380141,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380141,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380141,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380141,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380142,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380142,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380142,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380142,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380142,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380143,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380143,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380143,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380143,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380143,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380144,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380144,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380144,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380144,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380144,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380145,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380145,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380145,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380145,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380145,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380146,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380146,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380146,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380146,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380146,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380147,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380147,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380147,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380147,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380147,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380148,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380148,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380148,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380148,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380148,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380149,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380149,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380149,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380149,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380149,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380150,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380150,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380150,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380150,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380150,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380151,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380151,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380151,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380151,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380151,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380152,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380152,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380152,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380152,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380152,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380153,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380153,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380153,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380153,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380153,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380154,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380154,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380154,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380154,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380154,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380155,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380155,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380155,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380155,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380155,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380156,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380156,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380156,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380156,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380156,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380157,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380157,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380157,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380157,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380157,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380158,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380158,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380158,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380158,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380158,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380159,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380159,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380159,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380159,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380159,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380160,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380160,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380160,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380160,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380160,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380161,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380161,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380161,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380161,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380161,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380162,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380162,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380162,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380162,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380162,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380163,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380163,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380163,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380163,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380163,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380164,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380164,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380164,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380164,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380164,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380165,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380165,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380165,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380165,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380165,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380166,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380166,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380166,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380166,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380166,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380167,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380167,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380167,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380167,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380167,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380168,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380168,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380168,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380168,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380168,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380169,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380169,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380169,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380169,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380169,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380170,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380170,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380170,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380170,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380170,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380171,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380171,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380171,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380171,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380171,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380172,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380172,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380172,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380172,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380172,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380173,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380173,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380173,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380173,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380173,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380174,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380174,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380174,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380174,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380174,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380175,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380175,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380175,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380175,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380175,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380176,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380176,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380176,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380176,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380176,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380177,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380177,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380177,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380177,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380177,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380178,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380178,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380178,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380178,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380178,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380179,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380179,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380179,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380179,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380179,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380180,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380180,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380180,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380180,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380180,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380181,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380181,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380181,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380181,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380181,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380182,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380182,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380182,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380182,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380182,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380183,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380183,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380183,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380183,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380183,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380184,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380184,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380184,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380184,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380184,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380185,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380185,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380185,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380185,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380185,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380186,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380186,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380186,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380186,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380186,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380187,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380187,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380187,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380187,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380187,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380188,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380188,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380188,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380188,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380188,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380189,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380189,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380189,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380189,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380189,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380190,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380190,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380190,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380190,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380190,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380191,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380191,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380191,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380191,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380191,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380192,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380192,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380192,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380192,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380192,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380193,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380193,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380193,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380193,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380193,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380194,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380194,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380194,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380194,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380194,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380195,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380195,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380195,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380195,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380195,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380196,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380196,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380196,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380196,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380196,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380197,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380197,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380197,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380197,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380197,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380198,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380198,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380198,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380198,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380198,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380199,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380199,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380199,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380199,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380199,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380200,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380200,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380200,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380200,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380200,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380201,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380201,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380201,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380201,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380201,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380202,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380202,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380202,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380202,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380202,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380203,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380203,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380203,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380203,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380203,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380204,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380204,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380204,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380204,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380204,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380205,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380205,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380205,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380205,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380205,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380206,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380206,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380206,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380206,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380206,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380207,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380207,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380207,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380207,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380207,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380208,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380208,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380208,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380208,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380208,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380209,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380209,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380209,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380209,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380209,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380210,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380210,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380210,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380210,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380210,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380211,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380211,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380211,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380211,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380211,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380212,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380212,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380212,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380212,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380212,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380213,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380213,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380213,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380213,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380213,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380214,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380214,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380214,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380214,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380214,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380215,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380215,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380215,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380215,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380215,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380216,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380216,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380216,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380216,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380216,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380217,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380217,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380217,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380217,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380217,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380218,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380218,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380218,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380218,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380218,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380219,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380219,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380219,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380219,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380219,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(380220,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(380220,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(380220,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(380220,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(380220,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800101,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800101,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800101,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800101,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800101,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800102,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800102,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800102,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800102,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800102,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800103,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800103,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800103,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800103,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800103,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800104,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800104,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800104,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800104,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800104,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800105,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800105,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800105,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800105,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800105,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800106,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800106,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800106,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800106,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800106,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800107,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800107,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800107,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800107,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800107,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800108,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800108,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800108,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800108,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800108,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800109,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800109,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800109,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800109,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800109,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800110,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800110,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800110,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800110,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800110,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800111,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800111,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800111,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800111,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800111,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800112,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800112,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800112,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800112,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800112,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800113,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800113,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800113,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800113,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800113,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800114,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800114,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800114,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800114,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800114,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800115,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800115,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800115,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800115,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800115,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800116,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800116,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800116,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800116,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800116,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800117,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800117,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800117,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800117,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800117,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800118,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800118,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800118,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800118,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800118,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800119,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800119,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800119,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800119,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800119,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800120,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800120,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800120,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800120,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800120,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800121,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800121,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800121,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800121,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800121,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800122,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800122,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800122,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800122,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800122,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800123,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800123,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800123,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800123,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800123,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800124,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800124,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800124,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800124,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800124,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800125,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800125,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800125,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800125,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800125,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800126,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800126,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800126,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800126,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800126,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800127,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800127,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800127,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800127,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800127,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800128,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800128,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800128,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800128,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800128,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800129,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800129,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800129,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800129,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800129,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(2800130,_HurtNum) when _HurtNum >= 5 ->
		26000;
get_additional_drop_ratio(2800130,_HurtNum) when _HurtNum >= 4 ->
		25000;
get_additional_drop_ratio(2800130,_HurtNum) when _HurtNum >= 3 ->
		22000;
get_additional_drop_ratio(2800130,_HurtNum) when _HurtNum >= 2 ->
		16000;
get_additional_drop_ratio(2800130,_HurtNum) when _HurtNum >= 1 ->
		10000;
get_additional_drop_ratio(_Mon_id,_HurtNum) ->
	[].

