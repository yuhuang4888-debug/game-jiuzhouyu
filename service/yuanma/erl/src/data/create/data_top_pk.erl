%%%---------------------------------------
%%% module      : data_top_pk
%%% description : 巅峰竞技配置
%%%
%%%---------------------------------------
-module(data_top_pk).
-compile(export_all).
-include("top_pk.hrl").



get_reward_counts() ->
[10,5,1].


get_daily_count_rewards(1) ->
[{0,18020002,1},{100,32010479,1}];


get_daily_count_rewards(5) ->
[{0,18020002,2},{100,32010479,2}];


get_daily_count_rewards(10) ->
[{0,18020002,2},{100,32010479,2}];

get_daily_count_rewards(_Times) ->
	[].

get_kv(battle_scene,global) ->
7001;

get_kv(battle_scene_local,local) ->
7002;

get_kv(born_pos,global) ->
[{682,890},{1867,883}];

get_kv(default,battle_time) ->
90;

get_kv(default,before_start_time) ->
3;

get_kv(default,buy_cost) ->
10;

get_kv(default,buy_count) ->
10;

get_kv(default,daily_count) ->
10;

get_kv(default,local_serv_day) ->
0;

get_kv(default,need_time) ->
0;

get_kv(default,open_lv) ->
180;

get_kv(default,serial_win_count) ->
100000;

get_kv(designation_list,global) ->
[305008,305009,401001,305011];

get_kv(fake_man_battle_delay_time,default) ->
3;

get_kv(fashion_list,global) ->
[{1,[1101]},{2,[1201]},{3,[1101]},{4,[1201]}];

get_kv(fly_list,global) ->
[1001];

get_kv(holyorgan_list,global) ->
[{1,[1101]},{2,[1201]},{3,[1301]},{4,[1401]}];

get_kv(local_match_day,default) ->
{1, 15};

get_kv(mount_list,global) ->
[1001];

get_kv(open_day_limit,default) ->
[{1, 3},{5, 9999}];

get_kv(pk_rewards,0) ->
[{0,20010001,1},{16,0,50}];

get_kv(pk_rewards,1) ->
[{0,20010001,1},{0,22010001,1},{16,0,100}];

get_kv(season_reward_condition,match_count) ->
20;

get_kv(_Key,_Args) ->
	undefined.

get_rank_reward(1) ->
	#base_top_pk_rank_reward{rank_lv = 1,big_rank = 1,rank_name = "黑铁Ⅴ",point = 50,day_reward = [{255,41,100}],is_stage_reward = 0,stage_reward = [{0,18020001,2},{2,0,20}],other_reward = [],resource_id = 1000,local_day_reward = [{255,41,100}],local_stage_reward = [{0,18020001,2},{2,0,20}]};

get_rank_reward(2) ->
	#base_top_pk_rank_reward{rank_lv = 2,big_rank = 1,rank_name = "黑铁Ⅳ",point = 50,day_reward = [{255,41,500}],is_stage_reward = 1,stage_reward = [{0,18020001,2},{2,0,20}],other_reward = [],resource_id = 1000,local_day_reward = [{255,41,500}],local_stage_reward = [{0,18020001,2},{2,0,20}]};

get_rank_reward(3) ->
	#base_top_pk_rank_reward{rank_lv = 3,big_rank = 1,rank_name = "黑铁Ⅲ",point = 50,day_reward = [{255,41,500}],is_stage_reward = 1,stage_reward = [{0,18020001,2},{2,0,20}],other_reward = [],resource_id = 1000,local_day_reward = [{255,41,500}],local_stage_reward = [{0,18020001,2},{2,0,20}]};

get_rank_reward(4) ->
	#base_top_pk_rank_reward{rank_lv = 4,big_rank = 1,rank_name = "黑铁Ⅱ",point = 50,day_reward = [{255,41,500}],is_stage_reward = 1,stage_reward = [{0,18020001,2},{2,0,20}],other_reward = [],resource_id = 1000,local_day_reward = [{255,41,500}],local_stage_reward = [{0,18020001,2},{2,0,20}]};

get_rank_reward(5) ->
	#base_top_pk_rank_reward{rank_lv = 5,big_rank = 1,rank_name = "黑铁Ⅰ",point = 50,day_reward = [{255,41,500}],is_stage_reward = 1,stage_reward = [{0,18020001,2},{2,0,20}],other_reward = [],resource_id = 1000,local_day_reward = [{255,41,500}],local_stage_reward = [{0,18020001,2},{2,0,20}]};

get_rank_reward(6) ->
	#base_top_pk_rank_reward{rank_lv = 6,big_rank = 2,rank_name = "青铜Ⅴ",point = 100,day_reward = [{255,41,500}],is_stage_reward = 1,stage_reward = [{0,18020001,2},{2,0,50}],other_reward = [],resource_id = 2000,local_day_reward = [{255,41,500}],local_stage_reward = [{0,18020001,2},{2,0,50}]};

get_rank_reward(7) ->
	#base_top_pk_rank_reward{rank_lv = 7,big_rank = 2,rank_name = "青铜Ⅳ",point = 100,day_reward = [{255,41,1000}],is_stage_reward = 1,stage_reward = [{0,18020001,2},{2,0,20}],other_reward = [],resource_id = 2000,local_day_reward = [{255,41,1000}],local_stage_reward = [{0,18020001,2},{2,0,20}]};

get_rank_reward(8) ->
	#base_top_pk_rank_reward{rank_lv = 8,big_rank = 2,rank_name = "青铜Ⅲ",point = 100,day_reward = [{255,41,1000}],is_stage_reward = 1,stage_reward = [{0,18020001,2},{2,0,20}],other_reward = [],resource_id = 2000,local_day_reward = [{255,41,1000}],local_stage_reward = [{0,18020001,2},{2,0,20}]};

get_rank_reward(9) ->
	#base_top_pk_rank_reward{rank_lv = 9,big_rank = 2,rank_name = "青铜Ⅱ",point = 100,day_reward = [{255,41,1000}],is_stage_reward = 1,stage_reward = [{0,18020001,2},{2,0,20}],other_reward = [],resource_id = 2000,local_day_reward = [{255,41,1000}],local_stage_reward = [{0,18020001,2},{2,0,20}]};

get_rank_reward(10) ->
	#base_top_pk_rank_reward{rank_lv = 10,big_rank = 2,rank_name = "青铜Ⅰ",point = 100,day_reward = [{255,41,1000}],is_stage_reward = 1,stage_reward = [{0,18020001,2},{2,0,20}],other_reward = [],resource_id = 2000,local_day_reward = [{255,41,1000}],local_stage_reward = [{0,18020001,2},{2,0,20}]};

get_rank_reward(11) ->
	#base_top_pk_rank_reward{rank_lv = 11,big_rank = 3,rank_name = "白银Ⅴ",point = 150,day_reward = [{255,41,1000}],is_stage_reward = 1,stage_reward = [{0,18010001,1},{0,18020002,2},{2,0,80}],other_reward = [],resource_id = 3000,local_day_reward = [{255,41,1000}],local_stage_reward = [{0,18010001,1},{0,18020002,2},{2,0,80}]};

get_rank_reward(12) ->
	#base_top_pk_rank_reward{rank_lv = 12,big_rank = 3,rank_name = "白银Ⅳ",point = 150,day_reward = [{255,41,1000}],is_stage_reward = 1,stage_reward = [{0,18020001,3},{2,0,20}],other_reward = [],resource_id = 3000,local_day_reward = [{255,41,1000}],local_stage_reward = [{0,18020001,3},{2,0,20}]};

get_rank_reward(13) ->
	#base_top_pk_rank_reward{rank_lv = 13,big_rank = 3,rank_name = "白银Ⅲ",point = 150,day_reward = [{255,41,1000}],is_stage_reward = 1,stage_reward = [{0,18020001,3},{2,0,20}],other_reward = [],resource_id = 3000,local_day_reward = [{255,41,1000}],local_stage_reward = [{0,18020001,3},{2,0,20}]};

get_rank_reward(14) ->
	#base_top_pk_rank_reward{rank_lv = 14,big_rank = 3,rank_name = "白银Ⅱ",point = 150,day_reward = [{255,41,1500}],is_stage_reward = 1,stage_reward = [{0,18020001,3},{2,0,20}],other_reward = [],resource_id = 3000,local_day_reward = [{255,41,1500}],local_stage_reward = [{0,18020001,3},{2,0,20}]};

get_rank_reward(15) ->
	#base_top_pk_rank_reward{rank_lv = 15,big_rank = 3,rank_name = "白银Ⅰ",point = 150,day_reward = [{255,41,1500}],is_stage_reward = 1,stage_reward = [{0,18020001,3},{2,0,20}],other_reward = [],resource_id = 3000,local_day_reward = [{255,41,1500}],local_stage_reward = [{0,18020001,3},{2,0,20}]};

get_rank_reward(16) ->
	#base_top_pk_rank_reward{rank_lv = 16,big_rank = 4,rank_name = "黄金Ⅴ",point = 200,day_reward = [{255,41,1500}],is_stage_reward = 1,stage_reward = [{0,18010002,1},{0,18020002,2},{2,0,100}],other_reward = [],resource_id = 4000,local_day_reward = [{255,41,1500}],local_stage_reward = [{0,18010002,1},{0,18020002,2},{2,0,100}]};

get_rank_reward(17) ->
	#base_top_pk_rank_reward{rank_lv = 17,big_rank = 4,rank_name = "黄金Ⅳ",point = 200,day_reward = [{255,41,1500}],is_stage_reward = 1,stage_reward = [{0,18020001,5},{2,0,30}],other_reward = [],resource_id = 4000,local_day_reward = [{255,41,1500}],local_stage_reward = [{0,18020001,5},{2,0,30}]};

get_rank_reward(18) ->
	#base_top_pk_rank_reward{rank_lv = 18,big_rank = 4,rank_name = "黄金Ⅲ",point = 200,day_reward = [{255,41,1500}],is_stage_reward = 1,stage_reward = [{0,18020001,5},{2,0,30}],other_reward = [],resource_id = 4000,local_day_reward = [{255,41,1500}],local_stage_reward = [{0,18020001,5},{2,0,30}]};

get_rank_reward(19) ->
	#base_top_pk_rank_reward{rank_lv = 19,big_rank = 4,rank_name = "黄金Ⅱ",point = 200,day_reward = [{255,41,1500}],is_stage_reward = 1,stage_reward = [{0,18020001,5},{2,0,30}],other_reward = [],resource_id = 4000,local_day_reward = [{255,41,1500}],local_stage_reward = [{0,18020001,5},{2,0,30}]};

get_rank_reward(20) ->
	#base_top_pk_rank_reward{rank_lv = 20,big_rank = 4,rank_name = "黄金Ⅰ",point = 200,day_reward = [{255,41,1500}],is_stage_reward = 1,stage_reward = [{0,18020001,5},{2,0,30}],other_reward = [],resource_id = 4000,local_day_reward = [{255,41,1500}],local_stage_reward = [{0,18020001,5},{2,0,30}]};

get_rank_reward(21) ->
	#base_top_pk_rank_reward{rank_lv = 21,big_rank = 5,rank_name = "钻石Ⅴ",point = 300,day_reward = [{255,41,2000}],is_stage_reward = 1,stage_reward = [{0,18010003,1},{0,18020002,3},{2,0,120}],other_reward = [],resource_id = 5000,local_day_reward = [{255,41,2000}],local_stage_reward = [{0,18010003,1},{0,18020002,3},{2,0,120}]};

get_rank_reward(22) ->
	#base_top_pk_rank_reward{rank_lv = 22,big_rank = 5,rank_name = "钻石Ⅳ",point = 300,day_reward = [{255,41,2000}],is_stage_reward = 1,stage_reward = [{0,18020002,2},{2,0,50}],other_reward = [],resource_id = 5000,local_day_reward = [{255,41,2000}],local_stage_reward = [{0,18020002,2},{2,0,50}]};

get_rank_reward(23) ->
	#base_top_pk_rank_reward{rank_lv = 23,big_rank = 5,rank_name = "钻石Ⅲ",point = 300,day_reward = [{255,41,2000}],is_stage_reward = 1,stage_reward = [{0,18020002,2},{2,0,50}],other_reward = [],resource_id = 5000,local_day_reward = [{255,41,2000}],local_stage_reward = [{0,18020002,2},{2,0,50}]};

get_rank_reward(24) ->
	#base_top_pk_rank_reward{rank_lv = 24,big_rank = 5,rank_name = "钻石Ⅱ",point = 300,day_reward = [{255,41,2000}],is_stage_reward = 1,stage_reward = [{0,18020002,2},{2,0,50}],other_reward = [],resource_id = 5000,local_day_reward = [{255,41,2000}],local_stage_reward = [{0,18020002,2},{2,0,50}]};

get_rank_reward(25) ->
	#base_top_pk_rank_reward{rank_lv = 25,big_rank = 5,rank_name = "钻石Ⅰ",point = 300,day_reward = [{255,41,2000}],is_stage_reward = 1,stage_reward = [{0,18020002,2},{2,0,50}],other_reward = [],resource_id = 5000,local_day_reward = [{255,41,2000}],local_stage_reward = [{0,18020002,2},{2,0,50}]};

get_rank_reward(26) ->
	#base_top_pk_rank_reward{rank_lv = 26,big_rank = 6,rank_name = "最强王者",point = 300,day_reward = [{255,41,2000}],is_stage_reward = 1,stage_reward = [{0,18010003,1},{0,18020002,5},{2,0,150}],other_reward = [],resource_id = 6000,local_day_reward = [{255,41,2500}],local_stage_reward = [{0,18010003,1},{0,18020002,5},{2,0,150}]};

get_rank_reward(_Ranklv) ->
	[].


get_small_rank_by_big_rank(1) ->
[1,2,3,4,5];


get_small_rank_by_big_rank(2) ->
[6,7,8,9,10];


get_small_rank_by_big_rank(3) ->
[11,12,13,14,15];


get_small_rank_by_big_rank(4) ->
[16,17,18,19,20];


get_small_rank_by_big_rank(5) ->
[21,22,23,24,25];


get_small_rank_by_big_rank(6) ->
[26];

get_small_rank_by_big_rank(_Bigrank) ->
	[].


get_rank_by_is_stage_reward(0) ->
[1];


get_rank_by_is_stage_reward(1) ->
[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26];

get_rank_by_is_stage_reward(_Isstagereward) ->
	[].

get_end_reward(_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{2,0,500},{0,18010003,3},{0,18010002,5},{0,18010001,5},{0,18020002,20}];
get_end_reward(_Rank) when _Rank >= 2, _Rank =< 2 ->
		[{2,0,400},{0,18010003,2},{0,18010002,5},{0,18010001,5},{0,18020002,18}];
get_end_reward(_Rank) when _Rank >= 3, _Rank =< 3 ->
		[{2,0,300},{0,18010003,1},{0,18010002,5},{0,18010001,5},{0,18020002,15}];
get_end_reward(_Rank) when _Rank >= 4, _Rank =< 5 ->
		[{2,0,200},{0,18010003,1},{0,18010002,4},{0,18010001,4},{0,18020002,12}];
get_end_reward(_Rank) when _Rank >= 6, _Rank =< 10 ->
		[{2,0,150},{0,18010003,1},{0,18010002,4},{0,18010001,4},{0,18020002,10}];
get_end_reward(_Rank) when _Rank >= 11, _Rank =< 20 ->
		[{2,0,120},{0,18010002,3},{0,18010001,3},{0,18020002,8}];
get_end_reward(_Rank) when _Rank >= 21, _Rank =< 50 ->
		[{2,0,100},{0,18010002,3},{0,18010001,3},{0,18020002,6}];
get_end_reward(_Rank) when _Rank >= 51, _Rank =< 100 ->
		[{2,0,80},{0,18010002,2},{0,18010001,2},{0,18020002,5}];
get_end_reward(_Rank) ->
	[].


get_battle_reward(1) ->
[{50,0,200,120}];


get_battle_reward(2) ->
[{50,0,200,120}];


get_battle_reward(3) ->
[{50,0,200,120}];


get_battle_reward(4) ->
[{50,0,200,120}];


get_battle_reward(5) ->
[{50,0,200,120}];


get_battle_reward(6) ->
[{50,-10,200,120}];


get_battle_reward(7) ->
[{50,-10,200,120}];


get_battle_reward(8) ->
[{50,-10,200,120}];


get_battle_reward(9) ->
[{50,-10,200,120}];


get_battle_reward(10) ->
[{50,-10,200,120}];


get_battle_reward(11) ->
[{50,-20,200,120}];


get_battle_reward(12) ->
[{50,-20,200,120}];


get_battle_reward(13) ->
[{50,-20,200,120}];


get_battle_reward(14) ->
[{50,-20,200,120}];


get_battle_reward(15) ->
[{50,-20,200,120}];


get_battle_reward(16) ->
[{50,-20,200,120}];


get_battle_reward(17) ->
[{50,-20,200,120}];


get_battle_reward(18) ->
[{50,-20,200,120}];


get_battle_reward(19) ->
[{50,-20,200,120}];


get_battle_reward(20) ->
[{50,-20,200,120}];


get_battle_reward(21) ->
[{50,-30,200,120}];


get_battle_reward(22) ->
[{50,-30,200,120}];


get_battle_reward(23) ->
[{50,-30,200,120}];


get_battle_reward(24) ->
[{50,-30,200,120}];


get_battle_reward(25) ->
[{50,-30,200,120}];


get_battle_reward(26) ->
[{50,-50,200,120}];

get_battle_reward(_Ranklv) ->
	[].

get_end_local_reward(_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{2,0,350},{0,18010003,2},{0,18010002,4},{0,18010001,4},{0,18020002,15}];
get_end_local_reward(_Rank) when _Rank >= 2, _Rank =< 2 ->
		[{2,0,250},{0,18010003,1},{0,18010002,4},{0,18010001,4},{0,18020002,12}];
get_end_local_reward(_Rank) when _Rank >= 3, _Rank =< 3 ->
		[{2,0,200},{0,18010003,1},{0,18010002,4},{0,18010001,4},{0,18020002,10}];
get_end_local_reward(_Rank) when _Rank >= 4, _Rank =< 5 ->
		[{2,0,140},{0,18010002,3},{0,18010001,3},{0,18020002,8}];
get_end_local_reward(_Rank) when _Rank >= 6, _Rank =< 10 ->
		[{2,0,100},{0,18010002,3},{0,18010001,3},{0,18020002,7}];
get_end_local_reward(_Rank) when _Rank >= 11, _Rank =< 20 ->
		[{2,0,85},{0,18010002,2},{0,18010001,2},{0,18020002,5}];
get_end_local_reward(_Rank) when _Rank >= 21, _Rank =< 50 ->
		[{2,0,70},{0,18010002,2},{0,18010001,2},{0,18020002,4}];
get_end_local_reward(_Rank) when _Rank >= 51, _Rank =< 100 ->
		[{2,0,50},{0,18010002,1},{0,18010001,1},{0,18020002,3}];
get_end_local_reward(_Rank) ->
	[].

