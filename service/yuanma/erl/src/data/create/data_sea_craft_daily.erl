%%%---------------------------------------
%%% module      : data_sea_craft_daily
%%% description : 海战日常配置
%%%
%%%---------------------------------------
-module(data_sea_craft_daily).
-compile(export_all).
-include("seacraft_daily.hrl").



get_brick(1) ->
	#brick_cfg{id = 1,cost = [{0,38040094,1}],reward = [{3,0,150000}],exp_ratio = 1500,snatch_ratio = [{1,1},{2,2},{3,4},{4,6},{5,8}],attr = [{2,80000},{18,160}]};

get_brick(2) ->
	#brick_cfg{id = 2,cost = [{0,38040094,2}],reward = [{3,0,250000}],exp_ratio = 3000,snatch_ratio = [{1,2},{2,4},{3,8},{4,12},{5,16}],attr = [{2,100000},{18,160}]};

get_brick(3) ->
	#brick_cfg{id = 3,cost = [{0,38040094,4}],reward = [{3,0,350000}],exp_ratio = 6000,snatch_ratio = [{1,3},{2,6},{3,12},{4,18},{5,24}],attr = [{2,150000},{18,160}]};

get_brick(4) ->
	#brick_cfg{id = 4,cost = [],reward = [{3,0,500000}],exp_ratio = 10000,snatch_ratio = [{1,4},{2,8},{3,16},{4,24},{5,32}],attr = [{2,200000},{18,160}]};

get_brick(_Id) ->
	[].

get_exp_attr(_Num) when _Num =< 799 ->
		0;
get_exp_attr(_Num) when _Num =< 1599 ->
		0;
get_exp_attr(_Num) when _Num =< 2599 ->
		0;
get_exp_attr(_Num) when _Num =< 3799 ->
		1000;
get_exp_attr(_Num) when _Num =< 9999 ->
		2000;
get_exp_attr(_Num) ->
	0.

get_building_lv(_Num) when _Num =< 799 ->
		1;
get_building_lv(_Num) when _Num =< 1599 ->
		2;
get_building_lv(_Num) when _Num =< 2599 ->
		3;
get_building_lv(_Num) when _Num =< 3799 ->
		4;
get_building_lv(_Num) when _Num =< 9999 ->
		5;
get_building_lv(_Num) ->
	1.

get_brick_exp(_Lv) when _Lv =< 370 ->
		100000;
get_brick_exp(_Lv) when _Lv =< 380 ->
		200000;
get_brick_exp(_Lv) when _Lv =< 390 ->
		300000;
get_brick_exp(_Lv) when _Lv =< 400 ->
		400000;
get_brick_exp(_Lv) when _Lv =< 410 ->
		500000;
get_brick_exp(_Lv) when _Lv =< 420 ->
		600000;
get_brick_exp(_Lv) when _Lv =< 430 ->
		700000;
get_brick_exp(_Lv) when _Lv =< 440 ->
		800000;
get_brick_exp(_Lv) when _Lv =< 450 ->
		900000;
get_brick_exp(_Lv) when _Lv =< 460 ->
		1000000;
get_brick_exp(_Lv) when _Lv =< 470 ->
		1100000;
get_brick_exp(_Lv) when _Lv =< 480 ->
		1200000;
get_brick_exp(_Lv) when _Lv =< 490 ->
		1300000;
get_brick_exp(_Lv) when _Lv =< 500 ->
		1400000;
get_brick_exp(_Lv) when _Lv =< 510 ->
		1500000;
get_brick_exp(_Lv) when _Lv =< 520 ->
		1600000;
get_brick_exp(_Lv) when _Lv =< 530 ->
		1700000;
get_brick_exp(_Lv) when _Lv =< 540 ->
		1800000;
get_brick_exp(_Lv) when _Lv =< 550 ->
		1900000;
get_brick_exp(_Lv) when _Lv =< 560 ->
		2000000;
get_brick_exp(_Lv) when _Lv =< 570 ->
		2100000;
get_brick_exp(_Lv) when _Lv =< 580 ->
		2200000;
get_brick_exp(_Lv) when _Lv =< 590 ->
		2300000;
get_brick_exp(_Lv) when _Lv =< 600 ->
		2400000;
get_brick_exp(_Lv) when _Lv =< 610 ->
		2500000;
get_brick_exp(_Lv) when _Lv =< 620 ->
		2600000;
get_brick_exp(_Lv) when _Lv =< 630 ->
		2700000;
get_brick_exp(_Lv) when _Lv =< 640 ->
		2800000;
get_brick_exp(_Lv) when _Lv =< 650 ->
		2900000;
get_brick_exp(_Lv) when _Lv =< 660 ->
		3000000;
get_brick_exp(_Lv) when _Lv =< 670 ->
		3100000;
get_brick_exp(_Lv) when _Lv =< 680 ->
		3200000;
get_brick_exp(_Lv) when _Lv =< 690 ->
		3300000;
get_brick_exp(_Lv) when _Lv =< 700 ->
		3400000;
get_brick_exp(_Lv) when _Lv =< 710 ->
		3500000;
get_brick_exp(_Lv) when _Lv =< 720 ->
		3600000;
get_brick_exp(_Lv) when _Lv =< 730 ->
		3700000;
get_brick_exp(_Lv) when _Lv =< 740 ->
		3800000;
get_brick_exp(_Lv) when _Lv =< 750 ->
		3900000;
get_brick_exp(_Lv) when _Lv =< 760 ->
		4000000;
get_brick_exp(_Lv) when _Lv =< 770 ->
		4100000;
get_brick_exp(_Lv) when _Lv =< 780 ->
		4200000;
get_brick_exp(_Lv) when _Lv =< 790 ->
		4300000;
get_brick_exp(_Lv) when _Lv =< 800 ->
		4400000;
get_brick_exp(_Lv) when _Lv =< 810 ->
		4500000;
get_brick_exp(_Lv) when _Lv =< 820 ->
		4600000;
get_brick_exp(_Lv) when _Lv =< 830 ->
		4700000;
get_brick_exp(_Lv) when _Lv =< 840 ->
		4800000;
get_brick_exp(_Lv) when _Lv =< 850 ->
		4900000;
get_brick_exp(_Lv) when _Lv =< 860 ->
		5000000;
get_brick_exp(_Lv) when _Lv =< 870 ->
		5100000;
get_brick_exp(_Lv) when _Lv =< 880 ->
		5200000;
get_brick_exp(_Lv) when _Lv =< 890 ->
		5300000;
get_brick_exp(_Lv) when _Lv =< 900 ->
		5400000;
get_brick_exp(_Lv) when _Lv =< 910 ->
		5500000;
get_brick_exp(_Lv) when _Lv =< 920 ->
		5600000;
get_brick_exp(_Lv) when _Lv =< 930 ->
		5700000;
get_brick_exp(_Lv) when _Lv =< 940 ->
		5800000;
get_brick_exp(_Lv) when _Lv =< 950 ->
		5900000;
get_brick_exp(_Lv) when _Lv =< 960 ->
		6000000;
get_brick_exp(_Lv) when _Lv =< 970 ->
		6100000;
get_brick_exp(_Lv) when _Lv =< 980 ->
		6200000;
get_brick_exp(_Lv) when _Lv =< 990 ->
		6300000;
get_brick_exp(_Lv) when _Lv =< 1000 ->
		6400000;
get_brick_exp(_Lv) ->
	0.

get_task(1) ->
	#sea_daily_task_cfg{id = 1,type = 1,count = 1,reward = [{0,32060088,1},{0,18010001,1},{29,0,200}],condition = [{kill,19}]};

get_task(2) ->
	#sea_daily_task_cfg{id = 2,type = 1,count = 1,reward = [{0,32060088,1},{0,18010001,2},{29,0,200}],condition = [{kill,18}]};

get_task(3) ->
	#sea_daily_task_cfg{id = 3,type = 1,count = 10,reward = [{0,32060088,1},{0,18010001,1},{29,0,200}],condition = []};

get_task(4) ->
	#sea_daily_task_cfg{id = 4,type = 2,count = 1,reward = [{0,32060088,1},{0,18010001,2},{29,0,200}],condition = []};

get_task(_Id) ->
	[].

get_task_ids() ->
[1,2,3,4].


get_kv(af_kill_reward) ->
[{29,0,5}];


get_kv(boss_tv) ->
300;


get_kv(carry_birck_max) ->
30;


get_kv(carry_brick_count) ->
3;


get_kv(daily_exploit_limit) ->
1500;


get_kv(default_brick) ->
2000;


get_kv(defend_count) ->
3;


get_kv(defend_reward) ->
[{29,0,50}];


get_kv(del_hp_each_time) ->
3000;


get_kv(drop_list) ->
[41001,41101,41201,41301,41401,41501,41601,41701,41801,41901,42001,42101,42201,42301,42401,42501,42601,42701,42801,42901,43001,43101,43201,43301,43401,43501,43601,43701,43801,43901,44001,44101,44201,44301,44401,44501,44601,44701,44801,44901,45001,45101,45201,45301,45401,45501,45601,2200101,2200201,2200301,2200401,2200501,2200601,2200701,2200801,2200901,2201001,2201101,2201201,2201301,2201401,2201501,2201601,2201701,2201801,2201901,2202001,2202101,2202201,2202301,2202401,2202501,2202601,2202701,2202801,2202901,2203001,2203101,2203201,2203301,2203401,2203501,2203601,2203701,2203801,2203901,2204001,2204101,2204201,2204301,2204401,2204501,2204502,50001301,50001302,50001303,50001304,50001305,50001306,50001307,50001308];


get_kv(guard_coord) ->
{2645,2970} ;


get_kv(guard_reborn_time) ->
7200;


get_kv(in_other_sea_kill_reward) ->
[{29,0,5}];


get_kv(my_sea_coord) ->
{6400,1215};


get_kv(other_sea_coord) ->
{1281,3989};


get_kv(pre_kill_count) ->
20;


get_kv(pre_kill_reward) ->
[{29,0,20}];


get_kv(scene_id) ->
50001;


get_kv(skill_ids) ->
[510001,510002,510003];


get_kv(statue_coord) ->
{3808,2273} ;


get_kv(statue_reborn_time) ->
14400;


get_kv(task_end_pos) ->
{6462,3834} ;


get_kv(task_end_range) ->
100;


get_kv(task_start_pos) ->
{1257,1190} ;

get_kv(_Key) ->
	[].

get_all_boss() ->
[[50001101,50001201],[50001102,50001202],[50001103,50001203],[50001104,50001204],[50001105,50001205],[50001106,50001206]].

get_boss_id(_Lv) when _Lv =< 450 ->
		[50001101,50001201];
get_boss_id(_Lv) when _Lv =< 500 ->
		[50001102,50001202];
get_boss_id(_Lv) when _Lv =< 550 ->
		[50001103,50001203];
get_boss_id(_Lv) when _Lv =< 600 ->
		[50001104,50001204];
get_boss_id(_Lv) when _Lv =< 650 ->
		[50001105,50001205];
get_boss_id(_Lv) when _Lv =< 1000 ->
		[50001106,50001206];
get_boss_id(_Lv) ->
	[].

get_small_mon_list(_Lv) when _Lv =< 450 ->
		[{[{50001301,2523,2831},{50001302,2823,2849},{50001303,2637,3103}],[{50001302,3622,2211},{50001303,4006,2207},{50001304,3816,2405}]}];
get_small_mon_list(_Lv) when _Lv =< 500 ->
		[{[{50001302,2523,2831},{50001303,2823,2849},{50001304,2637,3103}],[{50001303,3622,2211},{50001304,4006,2207},{50001305,3816,2405}]}];
get_small_mon_list(_Lv) when _Lv =< 550 ->
		[{[{50001303,2523,2831},{50001304,2823,2849},{50001305,2637,3103}],[{50001304,3622,2211},{50001305,4006,2207},{50001306,3816,2405}]}];
get_small_mon_list(_Lv) when _Lv =< 600 ->
		[{[{50001304,2523,2831},{50001305,2823,2849},{50001306,2637,3103}],[{50001305,3622,2211},{50001306,4006,2207},{50001307,3816,2405}]}];
get_small_mon_list(_Lv) when _Lv =< 650 ->
		[{[{50001305,2523,2831},{50001306,2823,2849},{50001307,2637,3103}],[{50001306,3622,2211},{50001307,4006,2207},{50001308,3816,2405}]}];
get_small_mon_list(_Lv) when _Lv =< 1000 ->
		[{[{50001306,2523,2831},{50001307,2823,2849},{50001308,2637,3103}],[{50001307,3622,2211},{50001308,4006,2207},{50001308,3816,2405}]}];
get_small_mon_list(_Lv) ->
	[].

get_single_rank_reward(_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,38040091,20},{0,18010002,4}];
get_single_rank_reward(_Rank) when _Rank >= 2, _Rank =< 3 ->
		[{0,38040091,12},{0,18010002,3}];
get_single_rank_reward(_Rank) when _Rank >= 4, _Rank =< 20 ->
		[{0,38040091,8},{0,18010002,2}];
get_single_rank_reward(_Rank) when _Rank >= 20, _Rank =< 50 ->
		[{0,38040091,5},{0,18010002,1}];
get_single_rank_reward(_Rank) ->
	[].

get_all_sea_rank_reward(_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,38069001,1}];
get_all_sea_rank_reward(_Rank) when _Rank >= 2, _Rank =< 3 ->
		[{0,38069002,1}];
get_all_sea_rank_reward(_Rank) when _Rank >= 4, _Rank =< 20 ->
		[{0,38069003,1}];
get_all_sea_rank_reward(_Rank) ->
	[].

