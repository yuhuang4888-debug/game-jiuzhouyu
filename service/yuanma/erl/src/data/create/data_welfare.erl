%%%---------------------------------------
%%% module      : data_welfare
%%% description : 福利配置
%%%
%%%---------------------------------------
-module(data_welfare).
-compile(export_all).
-include("welfare.hrl").




get_cfg(night_welfare_open_lv) ->
100;


get_cfg(night_welfare_open_time) ->
[{20,0},{24,0}];


get_cfg(online_reward_open_lv) ->
75;


get_cfg(new_player_reward) ->
[];


get_cfg(new_player_reward_time) ->
1603875600;


get_cfg(combat_welfare_open_lv) ->
100;


get_cfg(combat_welfare_times) ->
[{165000,1},{260000,1},{355000,1},{450000,1},{545000,1},{640000,1},{735000,1},{830000,1},{925000,1},{1035000,1},{1145000,1},{1255000,1},{1365000,1},{1475000,1},{1585000,1},{1695000,1},{1805000,1},{1915000,1},{2025000,1},{2140000,1}];


get_cfg(grow_welfare_open_lv) ->
135;


get_cfg(combat_welfare_open_day	) ->
2;

get_cfg(_Key) ->
	0.

get_reward(1) ->
	#base_welfare_night_reward{id = 1,lv_region = [{1,9999}],reward = [{2,0,5},{0,32010057,1}]};

get_reward(_Id) ->
	[].

get_reward_ids() ->
[1].

get_online_reward(1) ->
	#online_reward_cfg{id = 1,online_time = 300,lv_min = 1,lv_max = 239,world_lv_min = 1,world_lv_max = 9999,reward = [{0,18020001,1}]};

get_online_reward(2) ->
	#online_reward_cfg{id = 2,online_time = 600,lv_min = 1,lv_max = 239,world_lv_min = 1,world_lv_max = 9999,reward = [{0,37020001,1}]};

get_online_reward(3) ->
	#online_reward_cfg{id = 3,online_time = 1500,lv_min = 1,lv_max = 239,world_lv_min = 1,world_lv_max = 9999,reward = [{0,38100002,1}]};

get_online_reward(4) ->
	#online_reward_cfg{id = 4,online_time = 3600,lv_min = 1,lv_max = 239,world_lv_min = 1,world_lv_max = 9999,reward = [{0,32010066,1}]};

get_online_reward(5) ->
	#online_reward_cfg{id = 5,online_time = 5400,lv_min = 1,lv_max = 239,world_lv_min = 1,world_lv_max = 9999,reward = [{0,35,20}]};

get_online_reward(6) ->
	#online_reward_cfg{id = 6,online_time = 7200,lv_min = 1,lv_max = 239,world_lv_min = 1,world_lv_max = 9999,reward = [{0,32070066,1}]};

get_online_reward(7) ->
	#online_reward_cfg{id = 7,online_time = 300,lv_min = 240,lv_max = 399,world_lv_min = 1,world_lv_max = 9999,reward = [{0,23020001,2}]};

get_online_reward(8) ->
	#online_reward_cfg{id = 8,online_time = 600,lv_min = 240,lv_max = 399,world_lv_min = 1,world_lv_max = 9999,reward = [{0,37020001,1}]};

get_online_reward(9) ->
	#online_reward_cfg{id = 9,online_time = 1500,lv_min = 240,lv_max = 399,world_lv_min = 1,world_lv_max = 9999,reward = [{0,32010129,2}]};

get_online_reward(10) ->
	#online_reward_cfg{id = 10,online_time = 3600,lv_min = 240,lv_max = 399,world_lv_min = 1,world_lv_max = 9999,reward = [{0,32010066,1}]};

get_online_reward(11) ->
	#online_reward_cfg{id = 11,online_time = 5400,lv_min = 240,lv_max = 399,world_lv_min = 1,world_lv_max = 9999,reward = [{0,35,20}]};

get_online_reward(12) ->
	#online_reward_cfg{id = 12,online_time = 7200,lv_min = 240,lv_max = 399,world_lv_min = 1,world_lv_max = 9999,reward = [{0,32070066,1}]};

get_online_reward(13) ->
	#online_reward_cfg{id = 13,online_time = 300,lv_min = 400,lv_max = 449,world_lv_min = 1,world_lv_max = 9999,reward = [{0,38040018,2}]};

get_online_reward(14) ->
	#online_reward_cfg{id = 14,online_time = 600,lv_min = 400,lv_max = 449,world_lv_min = 1,world_lv_max = 9999,reward = [{0,37020001,1}]};

get_online_reward(15) ->
	#online_reward_cfg{id = 15,online_time = 1500,lv_min = 400,lv_max = 449,world_lv_min = 1,world_lv_max = 9999,reward = [{0,7110001,1}]};

get_online_reward(16) ->
	#online_reward_cfg{id = 16,online_time = 3600,lv_min = 400,lv_max = 449,world_lv_min = 1,world_lv_max = 9999,reward = [{0,32010066,1}]};

get_online_reward(17) ->
	#online_reward_cfg{id = 17,online_time = 5400,lv_min = 400,lv_max = 449,world_lv_min = 1,world_lv_max = 9999,reward = [{0,35,20}]};

get_online_reward(18) ->
	#online_reward_cfg{id = 18,online_time = 7200,lv_min = 400,lv_max = 449,world_lv_min = 1,world_lv_max = 9999,reward = [{0,32070066,1}]};

get_online_reward(19) ->
	#online_reward_cfg{id = 19,online_time = 300,lv_min = 450,lv_max = 9999,world_lv_min = 1,world_lv_max = 9999,reward = [{0,7301001,1}]};

get_online_reward(20) ->
	#online_reward_cfg{id = 20,online_time = 600,lv_min = 450,lv_max = 9999,world_lv_min = 1,world_lv_max = 9999,reward = [{0,37020001,1}]};

get_online_reward(21) ->
	#online_reward_cfg{id = 21,online_time = 1500,lv_min = 450,lv_max = 9999,world_lv_min = 1,world_lv_max = 9999,reward = [{0,7301003,1}]};

get_online_reward(22) ->
	#online_reward_cfg{id = 22,online_time = 3600,lv_min = 450,lv_max = 9999,world_lv_min = 1,world_lv_max = 9999,reward = [{0,32010066,1}]};

get_online_reward(23) ->
	#online_reward_cfg{id = 23,online_time = 5400,lv_min = 450,lv_max = 9999,world_lv_min = 1,world_lv_max = 9999,reward = [{0,35,20}]};

get_online_reward(24) ->
	#online_reward_cfg{id = 24,online_time = 7200,lv_min = 450,lv_max = 9999,world_lv_min = 1,world_lv_max = 9999,reward = [{0,32070066,1}]};

get_online_reward(_Id) ->
	[].

get_limit_lv() ->
[{1,239},{240,399},{400,449},{450,9999}].

get_limit_world_lv() ->
[{1,9999}].

	get_reward_id_by_limit(1,239,1,9999) ->
	[1,2,3,4,5,6];
	
	get_reward_id_by_limit(240,399,1,9999) ->
	[7,8,9,10,11,12];
	
	get_reward_id_by_limit(400,449,1,9999) ->
	[13,14,15,16,17,18];
	
	get_reward_id_by_limit(450,9999,1,9999) ->
	[19,20,21,22,23,24];
	
get_reward_id_by_limit(_Lvmin,_Lvmax,_Worldlvmin,_Worldlvmax) ->
	[].

get_combat_welfare_round(1,1) ->
	#base_combat_welfare_reward{round = 1,reward_id = 1,weight = [{weight, {1,1,150,0}}],reward = [{0,6101004,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(1,2) ->
	#base_combat_welfare_reward{round = 1,reward_id = 2,weight = [{weight, {1,1,200,0}}],reward = [{0,17010003,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(1,3) ->
	#base_combat_welfare_reward{round = 1,reward_id = 3,weight = [{weight, {1,1,100,0}}],reward = [{0,38040027,5}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(1,4) ->
	#base_combat_welfare_reward{round = 1,reward_id = 4,weight = [{weight, {1,1,150,0}}],reward = [{0,16010003,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(1,5) ->
	#base_combat_welfare_reward{round = 1,reward_id = 5,weight = [{weight, {1,1,1000,0}}],reward = [{0,14010003,1}],tv_id = []};

get_combat_welfare_round(1,6) ->
	#base_combat_welfare_reward{round = 1,reward_id = 6,weight = [{weight, {1,1,1000,0}}],reward = [{0,14020003,1}],tv_id = []};

get_combat_welfare_round(1,7) ->
	#base_combat_welfare_reward{round = 1,reward_id = 7,weight = [{weight, {1,1,600,0}}],reward = [{0,56040004,1}],tv_id = []};

get_combat_welfare_round(1,8) ->
	#base_combat_welfare_reward{round = 1,reward_id = 8,weight = [{weight, {1,1,2500,0}}],reward = [{0,6101003,1}],tv_id = []};

get_combat_welfare_round(1,9) ->
	#base_combat_welfare_reward{round = 1,reward_id = 9,weight = [{weight, {1,1,500,0}}],reward = [{0,38040006,1}],tv_id = []};

get_combat_welfare_round(1,10) ->
	#base_combat_welfare_reward{round = 1,reward_id = 10,weight = [{weight, {1,1,1500,0}}],reward = [{0,16010002,1}],tv_id = []};

get_combat_welfare_round(1,11) ->
	#base_combat_welfare_reward{round = 1,reward_id = 11,weight = [{weight, {1,1,1500,0}}],reward = [{0,17010002,1}],tv_id = []};

get_combat_welfare_round(1,12) ->
	#base_combat_welfare_reward{round = 1,reward_id = 12,weight = [{weight, {1,1,800,0}}],reward = [{0,38030001,1}],tv_id = []};

get_combat_welfare_round(2,1) ->
	#base_combat_welfare_reward{round = 2,reward_id = 1,weight = [{weight, {1,1,150,0}}],reward = [{0,6101004,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(2,2) ->
	#base_combat_welfare_reward{round = 2,reward_id = 2,weight = [{weight, {1,1,200,0}}],reward = [{100,38240027,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(2,3) ->
	#base_combat_welfare_reward{round = 2,reward_id = 3,weight = [{weight, {1,1,100,0}}],reward = [{0,19010003,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(2,4) ->
	#base_combat_welfare_reward{round = 2,reward_id = 4,weight = [{weight, {1,1,150,0}}],reward = [{0,18010003,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(2,5) ->
	#base_combat_welfare_reward{round = 2,reward_id = 5,weight = [{weight, {1,1,1000,0}}],reward = [{0,14010003,1}],tv_id = []};

get_combat_welfare_round(2,6) ->
	#base_combat_welfare_reward{round = 2,reward_id = 6,weight = [{weight, {1,1,1000,0}}],reward = [{0,14020003,1}],tv_id = []};

get_combat_welfare_round(2,7) ->
	#base_combat_welfare_reward{round = 2,reward_id = 7,weight = [{weight, {1,1,600,0}}],reward = [{0,56040003,1}],tv_id = []};

get_combat_welfare_round(2,8) ->
	#base_combat_welfare_reward{round = 2,reward_id = 8,weight = [{weight, {1,1,2500,0}}],reward = [{100,38240201,5}],tv_id = []};

get_combat_welfare_round(2,9) ->
	#base_combat_welfare_reward{round = 2,reward_id = 9,weight = [{weight, {1,1,500,0}}],reward = [{0,38040007,1}],tv_id = []};

get_combat_welfare_round(2,10) ->
	#base_combat_welfare_reward{round = 2,reward_id = 10,weight = [{weight, {1,1,1500,0}}],reward = [{0,19010002,1}],tv_id = []};

get_combat_welfare_round(2,11) ->
	#base_combat_welfare_reward{round = 2,reward_id = 11,weight = [{weight, {1,1,1500,0}}],reward = [{0,18010002,1}],tv_id = []};

get_combat_welfare_round(2,12) ->
	#base_combat_welfare_reward{round = 2,reward_id = 12,weight = [{weight, {1,1,800,0}}],reward = [{0,38030003,1}],tv_id = []};

get_combat_welfare_round(3,1) ->
	#base_combat_welfare_reward{round = 3,reward_id = 1,weight = [{weight, {1,1,150,0}}],reward = [{0,6101004,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(3,2) ->
	#base_combat_welfare_reward{round = 3,reward_id = 2,weight = [{weight, {1,1,200,0}}],reward = [{100,38240027,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(3,3) ->
	#base_combat_welfare_reward{round = 3,reward_id = 3,weight = [{weight, {1,1,100,0}}],reward = [{0,6102001,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(3,4) ->
	#base_combat_welfare_reward{round = 3,reward_id = 4,weight = [{weight, {1,1,150,0}}],reward = [{0,20010003,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(3,5) ->
	#base_combat_welfare_reward{round = 3,reward_id = 5,weight = [{weight, {1,1,1000,0}}],reward = [{0,14010003,1}],tv_id = []};

get_combat_welfare_round(3,6) ->
	#base_combat_welfare_reward{round = 3,reward_id = 6,weight = [{weight, {1,1,1000,0}}],reward = [{0,14020003,1}],tv_id = []};

get_combat_welfare_round(3,7) ->
	#base_combat_welfare_reward{round = 3,reward_id = 7,weight = [{weight, {1,1,600,0}}],reward = [{0,56040002,1}],tv_id = []};

get_combat_welfare_round(3,8) ->
	#base_combat_welfare_reward{round = 3,reward_id = 8,weight = [{weight, {1,1,2500,0}}],reward = [{100,38240201,5}],tv_id = []};

get_combat_welfare_round(3,9) ->
	#base_combat_welfare_reward{round = 3,reward_id = 9,weight = [{weight, {1,1,500,0}}],reward = [{0,38040027,1}],tv_id = []};

get_combat_welfare_round(3,10) ->
	#base_combat_welfare_reward{round = 3,reward_id = 10,weight = [{weight, {1,1,1500,0}}],reward = [{0,38040005,60}],tv_id = []};

get_combat_welfare_round(3,11) ->
	#base_combat_welfare_reward{round = 3,reward_id = 11,weight = [{weight, {1,1,1500,0}}],reward = [{0,20010002,1}],tv_id = []};

get_combat_welfare_round(3,12) ->
	#base_combat_welfare_reward{round = 3,reward_id = 12,weight = [{weight, {1,1,800,0}}],reward = [{0,38030004,1}],tv_id = []};

get_combat_welfare_round(4,1) ->
	#base_combat_welfare_reward{round = 4,reward_id = 1,weight = [{weight, {1,1,150,0}}],reward = [{0,6101004,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(4,2) ->
	#base_combat_welfare_reward{round = 4,reward_id = 2,weight = [{weight, {1,1,200,0}}],reward = [{0,38100005,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(4,3) ->
	#base_combat_welfare_reward{round = 4,reward_id = 3,weight = [{weight, {1,1,100,0}}],reward = [{100,38040017,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(4,4) ->
	#base_combat_welfare_reward{round = 4,reward_id = 4,weight = [{weight, {1,1,150,0}}],reward = [{0,20010003,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(4,5) ->
	#base_combat_welfare_reward{round = 4,reward_id = 5,weight = [{weight, {1,1,1000,0}}],reward = [{0,14010003,1}],tv_id = []};

get_combat_welfare_round(4,6) ->
	#base_combat_welfare_reward{round = 4,reward_id = 6,weight = [{weight, {1,1,1000,0}}],reward = [{0,14020003,1}],tv_id = []};

get_combat_welfare_round(4,7) ->
	#base_combat_welfare_reward{round = 4,reward_id = 7,weight = [{weight, {1,1,600,0}}],reward = [{0,56040001,1}],tv_id = []};

get_combat_welfare_round(4,8) ->
	#base_combat_welfare_reward{round = 4,reward_id = 8,weight = [{weight, {1,1,2500,0}}],reward = [{0,6101001,1}],tv_id = []};

get_combat_welfare_round(4,9) ->
	#base_combat_welfare_reward{round = 4,reward_id = 9,weight = [{weight, {1,1,500,0}}],reward = [{0,6101002,1}],tv_id = []};

get_combat_welfare_round(4,10) ->
	#base_combat_welfare_reward{round = 4,reward_id = 10,weight = [{weight, {1,1,1500,0}}],reward = [{0,16010001,1}],tv_id = []};

get_combat_welfare_round(4,11) ->
	#base_combat_welfare_reward{round = 4,reward_id = 11,weight = [{weight, {1,1,1500,0}}],reward = [{0,17010001,1}],tv_id = []};

get_combat_welfare_round(4,12) ->
	#base_combat_welfare_reward{round = 4,reward_id = 12,weight = [{weight, {1,1,800,0}}],reward = [{0,38030001,1}],tv_id = []};

get_combat_welfare_round(5,1) ->
	#base_combat_welfare_reward{round = 5,reward_id = 1,weight = [{weight, {1,1,150,0}}],reward = [{0,6101004,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(5,2) ->
	#base_combat_welfare_reward{round = 5,reward_id = 2,weight = [{weight, {1,1,200,0}}],reward = [{0,38100005,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(5,3) ->
	#base_combat_welfare_reward{round = 5,reward_id = 3,weight = [{weight, {1,1,100,0}}],reward = [{100,38240027,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(5,4) ->
	#base_combat_welfare_reward{round = 5,reward_id = 4,weight = [{weight, {1,1,150,0}}],reward = [{0,16010003,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(5,5) ->
	#base_combat_welfare_reward{round = 5,reward_id = 5,weight = [{weight, {1,1,1000,0}}],reward = [{0,14010003,1}],tv_id = []};

get_combat_welfare_round(5,6) ->
	#base_combat_welfare_reward{round = 5,reward_id = 6,weight = [{weight, {1,1,1000,0}}],reward = [{0,14020003,1}],tv_id = []};

get_combat_welfare_round(5,7) ->
	#base_combat_welfare_reward{round = 5,reward_id = 7,weight = [{weight, {1,1,600,0}}],reward = [{0,56040004,1}],tv_id = []};

get_combat_welfare_round(5,8) ->
	#base_combat_welfare_reward{round = 5,reward_id = 8,weight = [{weight, {1,1,2500,0}}],reward = [{0,6101003,1}],tv_id = []};

get_combat_welfare_round(5,9) ->
	#base_combat_welfare_reward{round = 5,reward_id = 9,weight = [{weight, {1,1,500,0}}],reward = [{0,38040030,5}],tv_id = []};

get_combat_welfare_round(5,10) ->
	#base_combat_welfare_reward{round = 5,reward_id = 10,weight = [{weight, {1,1,1500,0}}],reward = [{0,16010002,1}],tv_id = []};

get_combat_welfare_round(5,11) ->
	#base_combat_welfare_reward{round = 5,reward_id = 11,weight = [{weight, {1,1,1500,0}}],reward = [{0,16010002,1}],tv_id = []};

get_combat_welfare_round(5,12) ->
	#base_combat_welfare_reward{round = 5,reward_id = 12,weight = [{weight, {1,1,800,0}}],reward = [{0,38030001,1}],tv_id = []};

get_combat_welfare_round(6,1) ->
	#base_combat_welfare_reward{round = 6,reward_id = 1,weight = [{weight, {1,1,150,0}}],reward = [{0,6101004,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(6,2) ->
	#base_combat_welfare_reward{round = 6,reward_id = 2,weight = [{weight, {1,1,200,0}}],reward = [{0,38100005,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(6,3) ->
	#base_combat_welfare_reward{round = 6,reward_id = 3,weight = [{weight, {1,1,100,0}}],reward = [{100,38240027,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(6,4) ->
	#base_combat_welfare_reward{round = 6,reward_id = 4,weight = [{weight, {1,1,150,0}}],reward = [{0,17010003,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(6,5) ->
	#base_combat_welfare_reward{round = 6,reward_id = 5,weight = [{weight, {1,1,1000,0}}],reward = [{0,14010003,1}],tv_id = []};

get_combat_welfare_round(6,6) ->
	#base_combat_welfare_reward{round = 6,reward_id = 6,weight = [{weight, {1,1,1000,0}}],reward = [{0,14020003,1}],tv_id = []};

get_combat_welfare_round(6,7) ->
	#base_combat_welfare_reward{round = 6,reward_id = 7,weight = [{weight, {1,1,600,0}}],reward = [{0,56040003,1}],tv_id = []};

get_combat_welfare_round(6,8) ->
	#base_combat_welfare_reward{round = 6,reward_id = 8,weight = [{weight, {1,1,2500,0}}],reward = [{0,6101003,1}],tv_id = []};

get_combat_welfare_round(6,9) ->
	#base_combat_welfare_reward{round = 6,reward_id = 9,weight = [{weight, {1,1,500,0}}],reward = [{0,32060006,1}],tv_id = []};

get_combat_welfare_round(6,10) ->
	#base_combat_welfare_reward{round = 6,reward_id = 10,weight = [{weight, {1,1,1500,0}}],reward = [{0,17010002,1}],tv_id = []};

get_combat_welfare_round(6,11) ->
	#base_combat_welfare_reward{round = 6,reward_id = 11,weight = [{weight, {1,1,1500,0}}],reward = [{0,17010002,1}],tv_id = []};

get_combat_welfare_round(6,12) ->
	#base_combat_welfare_reward{round = 6,reward_id = 12,weight = [{weight, {1,1,800,0}}],reward = [{0,38030001,1}],tv_id = []};

get_combat_welfare_round(7,1) ->
	#base_combat_welfare_reward{round = 7,reward_id = 1,weight = [{weight, {1,1,150,0}}],reward = [{0,6101004,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(7,2) ->
	#base_combat_welfare_reward{round = 7,reward_id = 2,weight = [{weight, {1,1,200,0}}],reward = [{0,38100005,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(7,3) ->
	#base_combat_welfare_reward{round = 7,reward_id = 3,weight = [{weight, {1,1,100,0}}],reward = [{100,38240027,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(7,4) ->
	#base_combat_welfare_reward{round = 7,reward_id = 4,weight = [{weight, {1,1,150,0}}],reward = [{0,18010003,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(7,5) ->
	#base_combat_welfare_reward{round = 7,reward_id = 5,weight = [{weight, {1,1,1000,0}}],reward = [{0,14010003,1}],tv_id = []};

get_combat_welfare_round(7,6) ->
	#base_combat_welfare_reward{round = 7,reward_id = 6,weight = [{weight, {1,1,1000,0}}],reward = [{0,14020003,1}],tv_id = []};

get_combat_welfare_round(7,7) ->
	#base_combat_welfare_reward{round = 7,reward_id = 7,weight = [{weight, {1,1,600,0}}],reward = [{0,56040002,1}],tv_id = []};

get_combat_welfare_round(7,8) ->
	#base_combat_welfare_reward{round = 7,reward_id = 8,weight = [{weight, {1,1,2500,0}}],reward = [{0,6101003,1}],tv_id = []};

get_combat_welfare_round(7,9) ->
	#base_combat_welfare_reward{round = 7,reward_id = 9,weight = [{weight, {1,1,500,0}}],reward = [{0,38040030,5}],tv_id = []};

get_combat_welfare_round(7,10) ->
	#base_combat_welfare_reward{round = 7,reward_id = 10,weight = [{weight, {1,1,1500,0}}],reward = [{0,18010002,1}],tv_id = []};

get_combat_welfare_round(7,11) ->
	#base_combat_welfare_reward{round = 7,reward_id = 11,weight = [{weight, {1,1,1500,0}}],reward = [{0,18010002,1}],tv_id = []};

get_combat_welfare_round(7,12) ->
	#base_combat_welfare_reward{round = 7,reward_id = 12,weight = [{weight, {1,1,800,0}}],reward = [{0,38030001,1}],tv_id = []};

get_combat_welfare_round(8,1) ->
	#base_combat_welfare_reward{round = 8,reward_id = 1,weight = [{weight, {1,1,150,0}}],reward = [{0,6101004,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(8,2) ->
	#base_combat_welfare_reward{round = 8,reward_id = 2,weight = [{weight, {1,1,200,0}}],reward = [{0,38100005,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(8,3) ->
	#base_combat_welfare_reward{round = 8,reward_id = 3,weight = [{weight, {1,1,100,0}}],reward = [{100,38240027,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(8,4) ->
	#base_combat_welfare_reward{round = 8,reward_id = 4,weight = [{weight, {1,1,150,0}}],reward = [{0,19010003,1}],tv_id = [{tv, {417, 20}}]};

get_combat_welfare_round(8,5) ->
	#base_combat_welfare_reward{round = 8,reward_id = 5,weight = [{weight, {1,1,1000,0}}],reward = [{0,14010003,1}],tv_id = []};

get_combat_welfare_round(8,6) ->
	#base_combat_welfare_reward{round = 8,reward_id = 6,weight = [{weight, {1,1,1000,0}}],reward = [{0,14020003,1}],tv_id = []};

get_combat_welfare_round(8,7) ->
	#base_combat_welfare_reward{round = 8,reward_id = 7,weight = [{weight, {1,1,600,0}}],reward = [{0,56040001,1}],tv_id = []};

get_combat_welfare_round(8,8) ->
	#base_combat_welfare_reward{round = 8,reward_id = 8,weight = [{weight, {1,1,2500,0}}],reward = [{0,6101003,1}],tv_id = []};

get_combat_welfare_round(8,9) ->
	#base_combat_welfare_reward{round = 8,reward_id = 9,weight = [{weight, {1,1,500,0}}],reward = [{0,32060006,1}],tv_id = []};

get_combat_welfare_round(8,10) ->
	#base_combat_welfare_reward{round = 8,reward_id = 10,weight = [{weight, {1,1,1500,0}}],reward = [{0,19010002,1}],tv_id = []};

get_combat_welfare_round(8,11) ->
	#base_combat_welfare_reward{round = 8,reward_id = 11,weight = [{weight, {1,1,1500,0}}],reward = [{0,19010002,1}],tv_id = []};

get_combat_welfare_round(8,12) ->
	#base_combat_welfare_reward{round = 8,reward_id = 12,weight = [{weight, {1,1,800,0}}],reward = [{0,38030001,1}],tv_id = []};

get_combat_welfare_round(_Round,_Rewardid) ->
	[].

get_combat_reward_round() ->
[1,2,3,4,5,6,7,8].


get_combat_reward_id(1) ->
[1,2,3,4,5,6,7,8,9,10,11,12];


get_combat_reward_id(2) ->
[1,2,3,4,5,6,7,8,9,10,11,12];


get_combat_reward_id(3) ->
[1,2,3,4,5,6,7,8,9,10,11,12];


get_combat_reward_id(4) ->
[1,2,3,4,5,6,7,8,9,10,11,12];


get_combat_reward_id(5) ->
[1,2,3,4,5,6,7,8,9,10,11,12];


get_combat_reward_id(6) ->
[1,2,3,4,5,6,7,8,9,10,11,12];


get_combat_reward_id(7) ->
[1,2,3,4,5,6,7,8,9,10,11,12];


get_combat_reward_id(8) ->
[1,2,3,4,5,6,7,8,9,10,11,12];

get_combat_reward_id(_Round) ->
	[].

get_grow_welfare(1) ->
	#base_grow_welfare_info{task_id = 1,condition = {login_day, 1},reward = [{0,35,10},{3,0,150000}],open_day = 1};

get_grow_welfare(2) ->
	#base_grow_welfare_info{task_id = 2,condition = {join_guild, 1},reward = [{0,35,10},{0,37080001,1000}],open_day = 1};

get_grow_welfare(3) ->
	#base_grow_welfare_info{task_id = 3,condition = {compose_equip, 5, 1, 1, 1},reward = [{0,35,10},{3,0,200000}],open_day = 1};

get_grow_welfare(4) ->
	#base_grow_welfare_info{task_id = 4,condition = {turn, 1},reward = [{0,35,10},{0,38100002,1}],open_day = 1};

get_grow_welfare(5) ->
	#base_grow_welfare_info{task_id = 5,condition = {dun_type, 20, 2},reward = [{0,35,20},{0,17020001,2},{3,0,200000}],open_day = 1};

get_grow_welfare(6) ->
	#base_grow_welfare_info{task_id = 6,condition = {login_day, 2},reward = [{0,35,10},{3,0,250000}],open_day = 2};

get_grow_welfare(7) ->
	#base_grow_welfare_info{task_id = 7,condition = {dun_type, 13, 1},reward = [{0,35,10},{0,38100002,1}],open_day = 2};

get_grow_welfare(8) ->
	#base_grow_welfare_info{task_id = 8,condition = {enter_guild_feast, 1},reward = [{0,35,15},{0,37080001,2000},{3,0,150000}],open_day = 2};

get_grow_welfare(9) ->
	#base_grow_welfare_info{task_id = 9,condition = {enter_midday_party, 1},reward = [{0,35,15},{0,56010004,1},{0,56010003,1}],open_day = 2};

get_grow_welfare(10) ->
	#base_grow_welfare_info{task_id = 10,condition = {seal_status, 4, 1, 2},reward = [{0,35,15},{0,6101003,1}],open_day = 2};

get_grow_welfare(11) ->
	#base_grow_welfare_info{task_id = 11,condition = {login_day, 3},reward = [{0,35,10},{3,0,350000}],open_day = 3};

get_grow_welfare(12) ->
	#base_grow_welfare_info{task_id = 12,condition = {enter_nine, 1},reward = [{0,35,15},{0,20020001,2},{255,41,200}],open_day = 3};

get_grow_welfare(13) ->
	#base_grow_welfare_info{task_id = 13,condition = {enter_holy_spirit, 1},reward = [{0,35,15},{0,20020001,2},{255,41,200}],open_day = 3};

get_grow_welfare(14) ->
	#base_grow_welfare_info{task_id = 14,condition = {boss_type, 4, 2},reward = [{0,35,20},{0,32010129,1},{0,38100001,1}],open_day = 3};

get_grow_welfare(15) ->
	#base_grow_welfare_info{task_id = 15,condition = {dun_id, 12020, 1},reward = [{0,35,20},{0,26990002,1},{3,0,200000}],open_day = 3};

get_grow_welfare(16) ->
	#base_grow_welfare_info{task_id = 16,condition = {login_day, 4},reward = [{0,35,10},{3,0,500000}],open_day = 4};

get_grow_welfare(17) ->
	#base_grow_welfare_info{task_id = 17,condition = {level_up_ship, 1},reward = [{0,35,10},{3,0,300000}],open_day = 4};

get_grow_welfare(18) ->
	#base_grow_welfare_info{task_id = 18,condition = {receive_ship_reward, 1},reward = [{0,35,15},{0,56010002,1}],open_day = 4};

get_grow_welfare(19) ->
	#base_grow_welfare_info{task_id = 19,condition = {dun_type, 2, 2},reward = [{0,35,15},{3,0,1000000},{0,38100001,2}],open_day = 4};

get_grow_welfare(20) ->
	#base_grow_welfare_info{task_id = 20,condition = {turn, 2},reward = [{0,35,20},{0,14010001,1},{0,14020001,1}],open_day = 4};

get_grow_welfare(21) ->
	#base_grow_welfare_info{task_id = 21,condition = {login_day, 5},reward = [{0,35,10},{3,0,650000}],open_day = 5};

get_grow_welfare(22) ->
	#base_grow_welfare_info{task_id = 22,condition = {equip_wash, 3},reward = [{0,35,10},{0,38040005,5}],open_day = 5};

get_grow_welfare(23) ->
	#base_grow_welfare_info{task_id = 23,condition = {assist_role, 1},reward = [{0,35,10},{0,38040091,1},{0,37070002,100}],open_day = 5};

get_grow_welfare(24) ->
	#base_grow_welfare_info{task_id = 24,condition = {equip_suit, 1, 1,6},reward = [{0,35,15},{0,6101001,1},{0,6101002,1}],open_day = 5};

get_grow_welfare(25) ->
	#base_grow_welfare_info{task_id = 25,condition = {dun_type, 32, 2},reward = [{0,35,25},{0,38040030,2},{0,38100002,1}],open_day = 5};

get_grow_welfare(26) ->
	#base_grow_welfare_info{task_id = 26,condition = {login_day, 6},reward = [{0,35,10},{3,0,800000}],open_day = 6};

get_grow_welfare(27) ->
	#base_grow_welfare_info{task_id = 27,condition = {boss_type, 99, 1},reward = [{0,35,15},{0,32010129,2}],open_day = 6};

get_grow_welfare(28) ->
	#base_grow_welfare_info{task_id = 28,condition = {turn, 3},reward = [{0,35,20},{0,14010001,1},{0,14020001,1}],open_day = 6};

get_grow_welfare(29) ->
	#base_grow_welfare_info{task_id = 29,condition = {dun_id, 31005, 1},reward = [{0,35,20},{0,38030001,1}],open_day = 6};

get_grow_welfare(30) ->
	#base_grow_welfare_info{task_id = 30,condition = {dun_id,12030, 1},reward = [{0,35,25},{0,26990003,1},{3,0,250000}],open_day = 6};

get_grow_welfare(31) ->
	#base_grow_welfare_info{task_id = 31,condition = {login_day, 7},reward = [{0,35,10},{3,0,1000000}],open_day = 7};

get_grow_welfare(32) ->
	#base_grow_welfare_info{task_id = 32,condition = {bonus_monday, 1},reward = [{0,35,10},{0,1102015063,1}],open_day = 7};

get_grow_welfare(33) ->
	#base_grow_welfare_info{task_id = 33,condition = {enter_top_pk, 10},reward = [{0,35,15},{0,20020002,1},{255,41,300}],open_day = 7};

get_grow_welfare(34) ->
	#base_grow_welfare_info{task_id = 34,condition = {equip_suit, 1,2,6},reward = [{0,35,20},{0,38240201,1}],open_day = 7};

get_grow_welfare(35) ->
	#base_grow_welfare_info{task_id = 35,condition = {dun_id, 12040, 1},reward = [{0,35,30},{0,26990004,1},{3,0,300000}],open_day = 7};

get_grow_welfare(36) ->
	#base_grow_welfare_info{task_id = 36,condition = {is_marriage, 1},reward = [{2, 0, 50}],open_day = 1};

get_grow_welfare(_Taskid) ->
	[].

list_grow_welfare_task() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36].

list_combat_welfare_times() ->
[{165000,1},{260000,1},{355000,1},{450000,1},{545000,1},{640000,1},{735000,1},{830000,1},{925000,1},{1035000,1},{1145000,1},{1255000,1},{1365000,1},{1475000,1},{1585000,1},{1695000,1},{1805000,1},{1915000,1},{2025000,1},{2140000,1},{2255000,1},{2370000,1},{2485000,1},{2600000,1},{2715000,1},{2830000,1},{2945000,1},{3060000,1},{3175000,1},{3300000,1},{3425000,1},{3550000,1},{3675000,1},{3800000,1},{3940000,1},{4080000,1},{4220000,1},{4360000,1},{4500000,1},{4640000,1},{4780000,1},{4920000,1},{5060000,1},{5200000,1},{5340000,1},{5480000,1},{5620000,1},{5760000,1},{5900000,1},{6040000,1},{6180000,1},{6320000,1},{6460000,1},{6600000,1},{6740000,1},{6880000,1},{7020000,1},{7160000,1},{7300000,1},{7440000,1},{7580000,1},{7720000,1},{7860000,1},{8000000,1},{8140000,1},{8280000,1},{8420000,1},{8560000,1},{8700000,1},{8840000,1},{8980000,1},{9120000,1},{9260000,1},{9400000,1},{9540000,1},{9680000,1},{9820000,1},{9960000,1},{10100000,1},{10260000,1},{10420000,1},{10580000,1},{10740000,1},{10900000,1},{11060000,1},{11220000,1},{11380000,1},{11540000,1},{11700000,1},{11860000,1},{12020000,1},{12180000,1},{12340000,1},{12500000,1},{12660000,1},{12820000,1}].

