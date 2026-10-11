%%%---------------------------------------
%%% module      : data_cycle_rank
%%% description : 循环冲榜配置
%%%
%%%---------------------------------------
-module(data_cycle_rank).
-compile(export_all).
-include("cycle_rank.hrl").



get_cycle_rank_info(1,1) ->
	#base_cycle_rank_info{type = 1,sub_type = 1,name = <<"坐骑冲榜"/utf8>>,open_day = 8,open_over = 999,start_time = 1651334400,end_time = 1661270400,banned_time = 1661263200};

get_cycle_rank_info(1,2) ->
	#base_cycle_rank_info{type = 1,sub_type = 2,name = <<"坐骑冲榜"/utf8>>,open_day = 8,open_over = 999,start_time = 1661270400,end_time = 1903708800,banned_time = 1903701600};

get_cycle_rank_info(2,1) ->
	#base_cycle_rank_info{type = 2,sub_type = 1,name = <<"侍魂冲榜"/utf8>>,open_day = 8,open_over = 999,start_time = 1651334400,end_time = 1661270400,banned_time = 1661263200};

get_cycle_rank_info(2,2) ->
	#base_cycle_rank_info{type = 2,sub_type = 2,name = <<"侍魂冲榜"/utf8>>,open_day = 8,open_over = 999,start_time = 1661270400,end_time = 1903708800,banned_time = 1903701600};

get_cycle_rank_info(3,1) ->
	#base_cycle_rank_info{type = 3,sub_type = 1,name = <<"羽翼冲榜"/utf8>>,open_day = 8,open_over = 999,start_time = 1651334400,end_time = 1661270400,banned_time = 1661263200};

get_cycle_rank_info(3,2) ->
	#base_cycle_rank_info{type = 3,sub_type = 2,name = <<"羽翼冲榜"/utf8>>,open_day = 8,open_over = 999,start_time = 1661270400,end_time = 1903708800,banned_time = 1903701600};

get_cycle_rank_info(4,1) ->
	#base_cycle_rank_info{type = 4,sub_type = 1,name = <<"御守冲榜"/utf8>>,open_day = 8,open_over = 999,start_time = 1651334400,end_time = 1661270400,banned_time = 1661263200};

get_cycle_rank_info(4,2) ->
	#base_cycle_rank_info{type = 4,sub_type = 2,name = <<"御守冲榜"/utf8>>,open_day = 8,open_over = 999,start_time = 1661270400,end_time = 1903708800,banned_time = 1903701600};

get_cycle_rank_info(5,1) ->
	#base_cycle_rank_info{type = 5,sub_type = 1,name = <<"神兵冲榜"/utf8>>,open_day = 8,open_over = 999,start_time = 1651334400,end_time = 1661270400,banned_time = 1661263200};

get_cycle_rank_info(5,2) ->
	#base_cycle_rank_info{type = 5,sub_type = 2,name = <<"神兵冲榜"/utf8>>,open_day = 8,open_over = 999,start_time = 1661270400,end_time = 1903708800,banned_time = 1903701600};

get_cycle_rank_info(6,2) ->
	#base_cycle_rank_info{type = 6,sub_type = 2,name = <<"背饰冲榜"/utf8>>,open_day = 8,open_over = 999,start_time = 1661270400,end_time = 1903708800,banned_time = 1903701600};

get_cycle_rank_info(_Type,_Subtype) ->
	[].

get_all_cycle_rank_list() ->
[{1,1},{1,2},{2,1},{2,2},{3,1},{3,2},{4,1},{4,2},{5,1},{5,2},{6,2}].


get_kv_cfg(ban_update_time) ->
79200;


get_kv_cfg(cycle_order) ->
[{1, [1,2,3,4,5]}, {2, [6,1,2,3,4,5]}];


get_kv_cfg(new_cycle_order) ->
[{1, [1,2,3,4,5], 1651334400, 1661270400}, {2, [6,1,2,3,4,5], 1661270400, 1903708800}];


get_kv_cfg(rank_level_limit) ->
130;


get_kv_cfg(send_change_info_cd) ->
600;


get_kv_cfg(show_rank_length) ->
10;

get_kv_cfg(_Key) ->
	[].

get_reach_reward_info(1,1,1) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 1,need = 30,rewards = [{0,16020004,1}]};

get_reach_reward_info(1,1,2) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 2,need = 80,rewards = [{0,16020004,1},{0,16020004,1}]};

get_reach_reward_info(1,1,3) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 3,need = 150,rewards = [{0,16020004,1},{0,16020004,1},{0,16020004,1},{0,38040005,5}]};

get_reach_reward_info(1,1,4) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 4,need = 300,rewards = [{0,16020004,2},{0,16020004,1},{0,16020004,1},{0,38040005,5}]};

get_reach_reward_info(1,1,5) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 5,need = 500,rewards = [{0,16020004,2},{0,16020004,2},{0,16020004,1},{0,38040005,8}]};

get_reach_reward_info(1,1,6) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 6,need = 700,rewards = [{0,16020004,2},{0,16020004,2},{0,16020004,2},{0,38040005,8}]};

get_reach_reward_info(1,1,7) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 7,need = 900,rewards = [{0,16020004,3},{0,16020004,2},{0,16020004,2},{0,38040005,12}]};

get_reach_reward_info(1,1,8) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 8,need = 1200,rewards = [{0,16020004,3},{0,16020004,3},{0,16020004,2},{0,38040005,12}]};

get_reach_reward_info(1,1,9) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 9,need = 1500,rewards = [{0,16020004,3},{0,16020004,3},{0,16020004,3},{0,38040005,15}]};

get_reach_reward_info(1,1,10) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 10,need = 1800,rewards = [{0,16020004,4},{0,16020004,3},{0,16020004,3},{0,38040005,15}]};

get_reach_reward_info(1,1,11) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 11,need = 2100,rewards = [{0,16020004,4},{0,16020004,4},{0,16020004,4},{0,38040005,18}]};

get_reach_reward_info(1,1,12) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 12,need = 2500,rewards = [{0,16020004,5},{0,16020004,5},{0,16020004,4},{0,38040005,18}]};

get_reach_reward_info(1,1,13) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 13,need = 3000,rewards = [{0,16020004,5},{0,16020004,5},{0,16020004,5},{0,38040005,20}]};

get_reach_reward_info(1,1,14) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 14,need = 3500,rewards = [{0,16020004,5},{0,16020004,5},{0,16020004,5},{0,38040005,20}]};

get_reach_reward_info(1,1,15) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 15,need = 4000,rewards = [{0,16020004,6},{0,16020004,5},{0,16020004,5},{0,38040005,20}]};

get_reach_reward_info(1,1,16) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 16,need = 4600,rewards = [{0,16020004,6},{0,16020004,6},{0,16020004,6},{0,38040005,20}]};

get_reach_reward_info(1,1,17) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 17,need = 5200,rewards = [{0,16020004,6},{0,16020004,6},{0,16020004,6},{0,38040005,20}]};

get_reach_reward_info(1,1,18) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 18,need = 5900,rewards = [{0,16020004,7},{0,16020004,7},{0,16020004,6},{0,38040005,20}]};

get_reach_reward_info(1,1,19) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 19,need = 6600,rewards = [{0,16020004,7},{0,16020004,7},{0,16020004,6},{0,38040005,20}]};

get_reach_reward_info(1,1,20) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 20,need = 7300,rewards = [{0,16020004,8},{0,16020004,7},{0,16020004,7},{0,38040005,20}]};

get_reach_reward_info(1,1,21) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 21,need = 8100,rewards = [{0,16020004,8},{0,16020004,8},{0,16020004,8},{0,38040005,20}]};

get_reach_reward_info(1,1,22) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 22,need = 9000,rewards = [{0,16020004,9},{0,16020004,9},{0,16020004,8},{0,38040005,20}]};

get_reach_reward_info(1,1,23) ->
	#base_reach_reward_info{type = 1,sub_type = 1,reward_id = 23,need = 10000,rewards = [{0,16020004,10},{0,16020004,9},{0,16020004,9},{0,38040005,20}]};

get_reach_reward_info(1,2,1) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 1,need = 30,rewards = [{0,16020004,1}]};

get_reach_reward_info(1,2,2) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 2,need = 80,rewards = [{0,16020004,1},{0,16020004,1}]};

get_reach_reward_info(1,2,3) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 3,need = 150,rewards = [{0,16020004,1},{0,16020004,1},{0,16020004,1},{0,38040005,5}]};

get_reach_reward_info(1,2,4) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 4,need = 300,rewards = [{0,16020004,2},{0,16020004,1},{0,16020004,1},{0,38040005,5}]};

get_reach_reward_info(1,2,5) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 5,need = 500,rewards = [{0,16020004,2},{0,16020004,2},{0,16020004,1},{0,38040005,8}]};

get_reach_reward_info(1,2,6) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 6,need = 700,rewards = [{0,16020004,2},{0,16020004,2},{0,16020004,2},{0,38040005,8}]};

get_reach_reward_info(1,2,7) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 7,need = 900,rewards = [{0,16020004,3},{0,16020004,2},{0,16020004,2},{0,38040005,12}]};

get_reach_reward_info(1,2,8) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 8,need = 1200,rewards = [{0,16020004,3},{0,16020004,3},{0,16020004,2},{0,38040005,12}]};

get_reach_reward_info(1,2,9) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 9,need = 1500,rewards = [{0,16020004,3},{0,16020004,3},{0,16020004,3},{0,38040005,15}]};

get_reach_reward_info(1,2,10) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 10,need = 1800,rewards = [{0,16020004,4},{0,16020004,3},{0,16020004,3},{0,38040005,15}]};

get_reach_reward_info(1,2,11) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 11,need = 2100,rewards = [{0,16020004,4},{0,16020004,4},{0,16020004,4},{0,38040005,18}]};

get_reach_reward_info(1,2,12) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 12,need = 2500,rewards = [{0,16020004,5},{0,16020004,5},{0,16020004,4},{0,38040005,18}]};

get_reach_reward_info(1,2,13) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 13,need = 3000,rewards = [{0,16020004,5},{0,16020004,5},{0,16020004,5},{0,38040005,20}]};

get_reach_reward_info(1,2,14) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 14,need = 3500,rewards = [{0,16020004,5},{0,16020004,5},{0,16020004,5},{0,38040005,20}]};

get_reach_reward_info(1,2,15) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 15,need = 4000,rewards = [{0,16020004,6},{0,16020004,5},{0,16020004,5},{0,38040005,20}]};

get_reach_reward_info(1,2,16) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 16,need = 4600,rewards = [{0,16020004,6},{0,16020004,6},{0,16020004,6},{0,38040005,20}]};

get_reach_reward_info(1,2,17) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 17,need = 5200,rewards = [{0,16020004,6},{0,16020004,6},{0,16020004,6},{0,38040005,20}]};

get_reach_reward_info(1,2,18) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 18,need = 5900,rewards = [{0,16020004,7},{0,16020004,7},{0,16020004,6},{0,38040005,20}]};

get_reach_reward_info(1,2,19) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 19,need = 6600,rewards = [{0,16020004,7},{0,16020004,7},{0,16020004,6},{0,38040005,20}]};

get_reach_reward_info(1,2,20) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 20,need = 7300,rewards = [{0,16020004,8},{0,16020004,7},{0,16020004,7},{0,38040005,20}]};

get_reach_reward_info(1,2,21) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 21,need = 8100,rewards = [{0,16020004,8},{0,16020004,8},{0,16020004,8},{0,38040005,20}]};

get_reach_reward_info(1,2,22) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 22,need = 9000,rewards = [{0,16020004,9},{0,16020004,9},{0,16020004,8},{0,38040005,20}]};

get_reach_reward_info(1,2,23) ->
	#base_reach_reward_info{type = 1,sub_type = 2,reward_id = 23,need = 10000,rewards = [{0,16020004,10},{0,16020004,9},{0,16020004,9},{0,38040005,20}]};

get_reach_reward_info(2,1,1) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 1,need = 30,rewards = [{0,17020004,1}]};

get_reach_reward_info(2,1,2) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 2,need = 80,rewards = [{0,17020004,1},{0,17020004,1}]};

get_reach_reward_info(2,1,3) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 3,need = 150,rewards = [{0,17020004,1},{0,17020004,1},{0,17020004,1},{0,38040005,5}]};

get_reach_reward_info(2,1,4) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 4,need = 300,rewards = [{0,17020004,2},{0,17020004,1},{0,17020004,1},{0,38040005,5}]};

get_reach_reward_info(2,1,5) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 5,need = 500,rewards = [{0,17020004,2},{0,17020004,2},{0,17020004,1},{0,38040005,8}]};

get_reach_reward_info(2,1,6) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 6,need = 700,rewards = [{0,17020004,2},{0,17020004,2},{0,17020004,2},{0,38040005,8}]};

get_reach_reward_info(2,1,7) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 7,need = 900,rewards = [{0,17020004,3},{0,17020004,2},{0,17020004,2},{0,38040005,12}]};

get_reach_reward_info(2,1,8) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 8,need = 1200,rewards = [{0,17020004,3},{0,17020004,3},{0,17020004,2},{0,38040005,12}]};

get_reach_reward_info(2,1,9) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 9,need = 1500,rewards = [{0,17020004,3},{0,17020004,3},{0,17020004,3},{0,38040005,15}]};

get_reach_reward_info(2,1,10) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 10,need = 1800,rewards = [{0,17020004,4},{0,17020004,3},{0,17020004,3},{0,38040005,15}]};

get_reach_reward_info(2,1,11) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 11,need = 2100,rewards = [{0,17020004,4},{0,17020004,4},{0,17020004,4},{0,38040005,18}]};

get_reach_reward_info(2,1,12) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 12,need = 2500,rewards = [{0,17020004,5},{0,17020004,5},{0,17020004,4},{0,38040005,18}]};

get_reach_reward_info(2,1,13) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 13,need = 3000,rewards = [{0,17020004,5},{0,17020004,5},{0,17020004,5},{0,38040005,20}]};

get_reach_reward_info(2,1,14) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 14,need = 3500,rewards = [{0,17020004,5},{0,17020004,5},{0,17020004,5},{0,38040005,20}]};

get_reach_reward_info(2,1,15) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 15,need = 4000,rewards = [{0,17020004,6},{0,17020004,5},{0,17020004,5},{0,38040005,20}]};

get_reach_reward_info(2,1,16) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 16,need = 4600,rewards = [{0,17020004,6},{0,17020004,6},{0,17020004,6},{0,38040005,20}]};

get_reach_reward_info(2,1,17) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 17,need = 5200,rewards = [{0,17020004,6},{0,17020004,6},{0,17020004,6},{0,38040005,20}]};

get_reach_reward_info(2,1,18) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 18,need = 5900,rewards = [{0,17020004,7},{0,17020004,7},{0,17020004,6},{0,38040005,20}]};

get_reach_reward_info(2,1,19) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 19,need = 6600,rewards = [{0,17020004,7},{0,17020004,7},{0,17020004,6},{0,38040005,20}]};

get_reach_reward_info(2,1,20) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 20,need = 7300,rewards = [{0,17020004,8},{0,17020004,7},{0,17020004,7},{0,38040005,20}]};

get_reach_reward_info(2,1,21) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 21,need = 8100,rewards = [{0,17020004,8},{0,17020004,8},{0,17020004,8},{0,38040005,20}]};

get_reach_reward_info(2,1,22) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 22,need = 9000,rewards = [{0,17020004,9},{0,17020004,9},{0,17020004,8},{0,38040005,20}]};

get_reach_reward_info(2,1,23) ->
	#base_reach_reward_info{type = 2,sub_type = 1,reward_id = 23,need = 10000,rewards = [{0,17020004,10},{0,17020004,9},{0,17020004,9},{0,38040005,20}]};

get_reach_reward_info(2,2,1) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 1,need = 30,rewards = [{0,17020004,1}]};

get_reach_reward_info(2,2,2) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 2,need = 80,rewards = [{0,17020004,1},{0,17020004,1}]};

get_reach_reward_info(2,2,3) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 3,need = 150,rewards = [{0,17020004,1},{0,17020004,1},{0,17020004,1},{0,38040005,5}]};

get_reach_reward_info(2,2,4) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 4,need = 300,rewards = [{0,17020004,2},{0,17020004,1},{0,17020004,1},{0,38040005,5}]};

get_reach_reward_info(2,2,5) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 5,need = 500,rewards = [{0,17020004,2},{0,17020004,2},{0,17020004,1},{0,38040005,8}]};

get_reach_reward_info(2,2,6) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 6,need = 700,rewards = [{0,17020004,2},{0,17020004,2},{0,17020004,2},{0,38040005,8}]};

get_reach_reward_info(2,2,7) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 7,need = 900,rewards = [{0,17020004,3},{0,17020004,2},{0,17020004,2},{0,38040005,12}]};

get_reach_reward_info(2,2,8) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 8,need = 1200,rewards = [{0,17020004,3},{0,17020004,3},{0,17020004,2},{0,38040005,12}]};

get_reach_reward_info(2,2,9) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 9,need = 1500,rewards = [{0,17020004,3},{0,17020004,3},{0,17020004,3},{0,38040005,15}]};

get_reach_reward_info(2,2,10) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 10,need = 1800,rewards = [{0,17020004,4},{0,17020004,3},{0,17020004,3},{0,38040005,15}]};

get_reach_reward_info(2,2,11) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 11,need = 2100,rewards = [{0,17020004,4},{0,17020004,4},{0,17020004,4},{0,38040005,18}]};

get_reach_reward_info(2,2,12) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 12,need = 2500,rewards = [{0,17020004,5},{0,17020004,5},{0,17020004,4},{0,38040005,18}]};

get_reach_reward_info(2,2,13) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 13,need = 3000,rewards = [{0,17020004,5},{0,17020004,5},{0,17020004,5},{0,38040005,20}]};

get_reach_reward_info(2,2,14) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 14,need = 3500,rewards = [{0,17020004,5},{0,17020004,5},{0,17020004,5},{0,38040005,20}]};

get_reach_reward_info(2,2,15) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 15,need = 4000,rewards = [{0,17020004,6},{0,17020004,5},{0,17020004,5},{0,38040005,20}]};

get_reach_reward_info(2,2,16) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 16,need = 4600,rewards = [{0,17020004,6},{0,17020004,6},{0,17020004,6},{0,38040005,20}]};

get_reach_reward_info(2,2,17) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 17,need = 5200,rewards = [{0,17020004,6},{0,17020004,6},{0,17020004,6},{0,38040005,20}]};

get_reach_reward_info(2,2,18) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 18,need = 5900,rewards = [{0,17020004,7},{0,17020004,7},{0,17020004,6},{0,38040005,20}]};

get_reach_reward_info(2,2,19) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 19,need = 6600,rewards = [{0,17020004,7},{0,17020004,7},{0,17020004,6},{0,38040005,20}]};

get_reach_reward_info(2,2,20) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 20,need = 7300,rewards = [{0,17020004,8},{0,17020004,7},{0,17020004,7},{0,38040005,20}]};

get_reach_reward_info(2,2,21) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 21,need = 8100,rewards = [{0,17020004,8},{0,17020004,8},{0,17020004,8},{0,38040005,20}]};

get_reach_reward_info(2,2,22) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 22,need = 9000,rewards = [{0,17020004,9},{0,17020004,9},{0,17020004,8},{0,38040005,20}]};

get_reach_reward_info(2,2,23) ->
	#base_reach_reward_info{type = 2,sub_type = 2,reward_id = 23,need = 10000,rewards = [{0,17020004,10},{0,17020004,9},{0,17020004,9},{0,38040005,20}]};

get_reach_reward_info(3,1,1) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 1,need = 30,rewards = [{0,18020004,1}]};

get_reach_reward_info(3,1,2) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 2,need = 80,rewards = [{0,18020004,1},{0,18020004,1}]};

get_reach_reward_info(3,1,3) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 3,need = 150,rewards = [{0,18020004,1},{0,18020004,1},{0,18020004,1},{0,38040005,5}]};

get_reach_reward_info(3,1,4) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 4,need = 300,rewards = [{0,18020004,2},{0,18020004,1},{0,18020004,1},{0,38040005,5}]};

get_reach_reward_info(3,1,5) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 5,need = 500,rewards = [{0,18020004,2},{0,18020004,2},{0,18020004,1},{0,38040005,8}]};

get_reach_reward_info(3,1,6) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 6,need = 700,rewards = [{0,18020004,2},{0,18020004,2},{0,18020004,2},{0,38040005,8}]};

get_reach_reward_info(3,1,7) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 7,need = 900,rewards = [{0,18020004,3},{0,18020004,2},{0,18020004,2},{0,38040005,12}]};

get_reach_reward_info(3,1,8) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 8,need = 1200,rewards = [{0,18020004,3},{0,18020004,3},{0,18020004,2},{0,38040005,12}]};

get_reach_reward_info(3,1,9) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 9,need = 1500,rewards = [{0,18020004,3},{0,18020004,3},{0,18020004,3},{0,38040005,15}]};

get_reach_reward_info(3,1,10) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 10,need = 1800,rewards = [{0,18020004,4},{0,18020004,3},{0,18020004,3},{0,38040005,15}]};

get_reach_reward_info(3,1,11) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 11,need = 2100,rewards = [{0,18020004,4},{0,18020004,4},{0,18020004,4},{0,38040005,18}]};

get_reach_reward_info(3,1,12) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 12,need = 2500,rewards = [{0,18020004,5},{0,18020004,5},{0,18020004,4},{0,38040005,18}]};

get_reach_reward_info(3,1,13) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 13,need = 3000,rewards = [{0,18020004,5},{0,18020004,5},{0,18020004,5},{0,38040005,20}]};

get_reach_reward_info(3,1,14) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 14,need = 3500,rewards = [{0,18020004,5},{0,18020004,5},{0,18020004,5},{0,38040005,20}]};

get_reach_reward_info(3,1,15) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 15,need = 4000,rewards = [{0,18020004,6},{0,18020004,5},{0,18020004,5},{0,38040005,20}]};

get_reach_reward_info(3,1,16) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 16,need = 4600,rewards = [{0,18020004,6},{0,18020004,6},{0,18020004,6},{0,38040005,20}]};

get_reach_reward_info(3,1,17) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 17,need = 5200,rewards = [{0,18020004,6},{0,18020004,6},{0,18020004,6},{0,38040005,20}]};

get_reach_reward_info(3,1,18) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 18,need = 5900,rewards = [{0,18020004,7},{0,18020004,7},{0,18020004,6},{0,38040005,20}]};

get_reach_reward_info(3,1,19) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 19,need = 6600,rewards = [{0,18020004,7},{0,18020004,7},{0,18020004,6},{0,38040005,20}]};

get_reach_reward_info(3,1,20) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 20,need = 7300,rewards = [{0,18020004,8},{0,18020004,7},{0,18020004,7},{0,38040005,20}]};

get_reach_reward_info(3,1,21) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 21,need = 8100,rewards = [{0,18020004,8},{0,18020004,8},{0,18020004,8},{0,38040005,20}]};

get_reach_reward_info(3,1,22) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 22,need = 9000,rewards = [{0,18020004,9},{0,18020004,9},{0,18020004,8},{0,38040005,20}]};

get_reach_reward_info(3,1,23) ->
	#base_reach_reward_info{type = 3,sub_type = 1,reward_id = 23,need = 10000,rewards = [{0,18020004,10},{0,18020004,9},{0,18020004,9},{0,38040005,20}]};

get_reach_reward_info(3,2,1) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 1,need = 30,rewards = [{0,18020004,1}]};

get_reach_reward_info(3,2,2) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 2,need = 80,rewards = [{0,18020004,1},{0,18020004,1}]};

get_reach_reward_info(3,2,3) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 3,need = 150,rewards = [{0,18020004,1},{0,18020004,1},{0,18020004,1},{0,38040005,5}]};

get_reach_reward_info(3,2,4) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 4,need = 300,rewards = [{0,18020004,2},{0,18020004,1},{0,18020004,1},{0,38040005,5}]};

get_reach_reward_info(3,2,5) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 5,need = 500,rewards = [{0,18020004,2},{0,18020004,2},{0,18020004,1},{0,38040005,8}]};

get_reach_reward_info(3,2,6) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 6,need = 700,rewards = [{0,18020004,2},{0,18020004,2},{0,18020004,2},{0,38040005,8}]};

get_reach_reward_info(3,2,7) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 7,need = 900,rewards = [{0,18020004,3},{0,18020004,2},{0,18020004,2},{0,38040005,12}]};

get_reach_reward_info(3,2,8) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 8,need = 1200,rewards = [{0,18020004,3},{0,18020004,3},{0,18020004,2},{0,38040005,12}]};

get_reach_reward_info(3,2,9) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 9,need = 1500,rewards = [{0,18020004,3},{0,18020004,3},{0,18020004,3},{0,38040005,15}]};

get_reach_reward_info(3,2,10) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 10,need = 1800,rewards = [{0,18020004,4},{0,18020004,3},{0,18020004,3},{0,38040005,15}]};

get_reach_reward_info(3,2,11) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 11,need = 2100,rewards = [{0,18020004,4},{0,18020004,4},{0,18020004,4},{0,38040005,18}]};

get_reach_reward_info(3,2,12) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 12,need = 2500,rewards = [{0,18020004,5},{0,18020004,5},{0,18020004,4},{0,38040005,18}]};

get_reach_reward_info(3,2,13) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 13,need = 3000,rewards = [{0,18020004,5},{0,18020004,5},{0,18020004,5},{0,38040005,20}]};

get_reach_reward_info(3,2,14) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 14,need = 3500,rewards = [{0,18020004,5},{0,18020004,5},{0,18020004,5},{0,38040005,20}]};

get_reach_reward_info(3,2,15) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 15,need = 4000,rewards = [{0,18020004,6},{0,18020004,5},{0,18020004,5},{0,38040005,20}]};

get_reach_reward_info(3,2,16) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 16,need = 4600,rewards = [{0,18020004,6},{0,18020004,6},{0,18020004,6},{0,38040005,20}]};

get_reach_reward_info(3,2,17) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 17,need = 5200,rewards = [{0,18020004,6},{0,18020004,6},{0,18020004,6},{0,38040005,20}]};

get_reach_reward_info(3,2,18) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 18,need = 5900,rewards = [{0,18020004,7},{0,18020004,7},{0,18020004,6},{0,38040005,20}]};

get_reach_reward_info(3,2,19) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 19,need = 6600,rewards = [{0,18020004,7},{0,18020004,7},{0,18020004,6},{0,38040005,20}]};

get_reach_reward_info(3,2,20) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 20,need = 7300,rewards = [{0,18020004,8},{0,18020004,7},{0,18020004,7},{0,38040005,20}]};

get_reach_reward_info(3,2,21) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 21,need = 8100,rewards = [{0,18020004,8},{0,18020004,8},{0,18020004,8},{0,38040005,20}]};

get_reach_reward_info(3,2,22) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 22,need = 9000,rewards = [{0,18020004,9},{0,18020004,9},{0,18020004,8},{0,38040005,20}]};

get_reach_reward_info(3,2,23) ->
	#base_reach_reward_info{type = 3,sub_type = 2,reward_id = 23,need = 10000,rewards = [{0,18020004,10},{0,18020004,9},{0,18020004,9},{0,38040005,20}]};

get_reach_reward_info(4,1,1) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 1,need = 30,rewards = [{0,19020004,1}]};

get_reach_reward_info(4,1,2) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 2,need = 80,rewards = [{0,19020004,1},{0,19020004,1}]};

get_reach_reward_info(4,1,3) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 3,need = 150,rewards = [{0,19020004,1},{0,19020004,1},{0,19020004,1},{0,38040005,5}]};

get_reach_reward_info(4,1,4) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 4,need = 300,rewards = [{0,19020004,2},{0,19020004,1},{0,19020004,1},{0,38040005,5}]};

get_reach_reward_info(4,1,5) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 5,need = 500,rewards = [{0,19020004,2},{0,19020004,2},{0,19020004,1},{0,38040005,8}]};

get_reach_reward_info(4,1,6) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 6,need = 700,rewards = [{0,19020004,2},{0,19020004,2},{0,19020004,2},{0,38040005,8}]};

get_reach_reward_info(4,1,7) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 7,need = 900,rewards = [{0,19020004,3},{0,19020004,2},{0,19020004,2},{0,38040005,12}]};

get_reach_reward_info(4,1,8) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 8,need = 1200,rewards = [{0,19020004,3},{0,19020004,3},{0,19020004,2},{0,38040005,12}]};

get_reach_reward_info(4,1,9) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 9,need = 1500,rewards = [{0,19020004,3},{0,19020004,3},{0,19020004,3},{0,38040005,15}]};

get_reach_reward_info(4,1,10) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 10,need = 1800,rewards = [{0,19020004,4},{0,19020004,3},{0,19020004,3},{0,38040005,15}]};

get_reach_reward_info(4,1,11) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 11,need = 2100,rewards = [{0,19020004,4},{0,19020004,4},{0,19020004,4},{0,38040005,18}]};

get_reach_reward_info(4,1,12) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 12,need = 2500,rewards = [{0,19020004,5},{0,19020004,5},{0,19020004,4},{0,38040005,18}]};

get_reach_reward_info(4,1,13) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 13,need = 3000,rewards = [{0,19020004,5},{0,19020004,5},{0,19020004,5},{0,38040005,20}]};

get_reach_reward_info(4,1,14) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 14,need = 3500,rewards = [{0,19020004,5},{0,19020004,5},{0,19020004,5},{0,38040005,20}]};

get_reach_reward_info(4,1,15) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 15,need = 4000,rewards = [{0,19020004,6},{0,19020004,5},{0,19020004,5},{0,38040005,20}]};

get_reach_reward_info(4,1,16) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 16,need = 4600,rewards = [{0,19020004,6},{0,19020004,6},{0,19020004,6},{0,38040005,20}]};

get_reach_reward_info(4,1,17) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 17,need = 5200,rewards = [{0,19020004,6},{0,19020004,6},{0,19020004,6},{0,38040005,20}]};

get_reach_reward_info(4,1,18) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 18,need = 5900,rewards = [{0,19020004,7},{0,19020004,7},{0,19020004,6},{0,38040005,20}]};

get_reach_reward_info(4,1,19) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 19,need = 6600,rewards = [{0,19020004,7},{0,19020004,7},{0,19020004,6},{0,38040005,20}]};

get_reach_reward_info(4,1,20) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 20,need = 7300,rewards = [{0,19020004,8},{0,19020004,7},{0,19020004,7},{0,38040005,20}]};

get_reach_reward_info(4,1,21) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 21,need = 8100,rewards = [{0,19020004,8},{0,19020004,8},{0,19020004,8},{0,38040005,20}]};

get_reach_reward_info(4,1,22) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 22,need = 9000,rewards = [{0,19020004,9},{0,19020004,9},{0,19020004,8},{0,38040005,20}]};

get_reach_reward_info(4,1,23) ->
	#base_reach_reward_info{type = 4,sub_type = 1,reward_id = 23,need = 10000,rewards = [{0,19020004,10},{0,19020004,9},{0,19020004,9},{0,38040005,20}]};

get_reach_reward_info(4,2,1) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 1,need = 30,rewards = [{0,19020004,1}]};

get_reach_reward_info(4,2,2) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 2,need = 80,rewards = [{0,19020004,1},{0,19020004,1}]};

get_reach_reward_info(4,2,3) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 3,need = 150,rewards = [{0,19020004,1},{0,19020004,1},{0,19020004,1},{0,38040005,5}]};

get_reach_reward_info(4,2,4) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 4,need = 300,rewards = [{0,19020004,2},{0,19020004,1},{0,19020004,1},{0,38040005,5}]};

get_reach_reward_info(4,2,5) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 5,need = 500,rewards = [{0,19020004,2},{0,19020004,2},{0,19020004,1},{0,38040005,8}]};

get_reach_reward_info(4,2,6) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 6,need = 700,rewards = [{0,19020004,2},{0,19020004,2},{0,19020004,2},{0,38040005,8}]};

get_reach_reward_info(4,2,7) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 7,need = 900,rewards = [{0,19020004,3},{0,19020004,2},{0,19020004,2},{0,38040005,12}]};

get_reach_reward_info(4,2,8) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 8,need = 1200,rewards = [{0,19020004,3},{0,19020004,3},{0,19020004,2},{0,38040005,12}]};

get_reach_reward_info(4,2,9) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 9,need = 1500,rewards = [{0,19020004,3},{0,19020004,3},{0,19020004,3},{0,38040005,15}]};

get_reach_reward_info(4,2,10) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 10,need = 1800,rewards = [{0,19020004,4},{0,19020004,3},{0,19020004,3},{0,38040005,15}]};

get_reach_reward_info(4,2,11) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 11,need = 2100,rewards = [{0,19020004,4},{0,19020004,4},{0,19020004,4},{0,38040005,18}]};

get_reach_reward_info(4,2,12) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 12,need = 2500,rewards = [{0,19020004,5},{0,19020004,5},{0,19020004,4},{0,38040005,18}]};

get_reach_reward_info(4,2,13) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 13,need = 3000,rewards = [{0,19020004,5},{0,19020004,5},{0,19020004,5},{0,38040005,20}]};

get_reach_reward_info(4,2,14) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 14,need = 3500,rewards = [{0,19020004,5},{0,19020004,5},{0,19020004,5},{0,38040005,20}]};

get_reach_reward_info(4,2,15) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 15,need = 4000,rewards = [{0,19020004,6},{0,19020004,5},{0,19020004,5},{0,38040005,20}]};

get_reach_reward_info(4,2,16) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 16,need = 4600,rewards = [{0,19020004,6},{0,19020004,6},{0,19020004,6},{0,38040005,20}]};

get_reach_reward_info(4,2,17) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 17,need = 5200,rewards = [{0,19020004,6},{0,19020004,6},{0,19020004,6},{0,38040005,20}]};

get_reach_reward_info(4,2,18) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 18,need = 5900,rewards = [{0,19020004,7},{0,19020004,7},{0,19020004,6},{0,38040005,20}]};

get_reach_reward_info(4,2,19) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 19,need = 6600,rewards = [{0,19020004,7},{0,19020004,7},{0,19020004,6},{0,38040005,20}]};

get_reach_reward_info(4,2,20) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 20,need = 7300,rewards = [{0,19020004,8},{0,19020004,7},{0,19020004,7},{0,38040005,20}]};

get_reach_reward_info(4,2,21) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 21,need = 8100,rewards = [{0,19020004,8},{0,19020004,8},{0,19020004,8},{0,38040005,20}]};

get_reach_reward_info(4,2,22) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 22,need = 9000,rewards = [{0,19020004,9},{0,19020004,9},{0,19020004,8},{0,38040005,20}]};

get_reach_reward_info(4,2,23) ->
	#base_reach_reward_info{type = 4,sub_type = 2,reward_id = 23,need = 10000,rewards = [{0,19020004,10},{0,19020004,9},{0,19020004,9},{0,38040005,20}]};

get_reach_reward_info(5,1,1) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 1,need = 30,rewards = [{0,20020004,1}]};

get_reach_reward_info(5,1,2) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 2,need = 80,rewards = [{0,20020004,1},{0,20020004,1}]};

get_reach_reward_info(5,1,3) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 3,need = 150,rewards = [{0,20020004,1},{0,20020004,1},{0,20020004,1},{0,38040005,5}]};

get_reach_reward_info(5,1,4) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 4,need = 300,rewards = [{0,20020004,2},{0,20020004,1},{0,20020004,1},{0,38040005,5}]};

get_reach_reward_info(5,1,5) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 5,need = 500,rewards = [{0,20020004,2},{0,20020004,2},{0,20020004,1},{0,38040005,8}]};

get_reach_reward_info(5,1,6) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 6,need = 700,rewards = [{0,20020004,2},{0,20020004,2},{0,20020004,2},{0,38040005,8}]};

get_reach_reward_info(5,1,7) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 7,need = 900,rewards = [{0,20020004,3},{0,20020004,2},{0,20020004,2},{0,38040005,12}]};

get_reach_reward_info(5,1,8) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 8,need = 1200,rewards = [{0,20020004,3},{0,20020004,3},{0,20020004,2},{0,38040005,12}]};

get_reach_reward_info(5,1,9) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 9,need = 1500,rewards = [{0,20020004,3},{0,20020004,3},{0,20020004,3},{0,38040005,15}]};

get_reach_reward_info(5,1,10) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 10,need = 1800,rewards = [{0,20020004,4},{0,20020004,3},{0,20020004,3},{0,38040005,15}]};

get_reach_reward_info(5,1,11) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 11,need = 2100,rewards = [{0,20020004,4},{0,20020004,4},{0,20020004,4},{0,38040005,18}]};

get_reach_reward_info(5,1,12) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 12,need = 2500,rewards = [{0,20020004,5},{0,20020004,5},{0,20020004,4},{0,38040005,18}]};

get_reach_reward_info(5,1,13) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 13,need = 3000,rewards = [{0,20020004,5},{0,20020004,5},{0,20020004,5},{0,38040005,20}]};

get_reach_reward_info(5,1,14) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 14,need = 3500,rewards = [{0,20020004,5},{0,20020004,5},{0,20020004,5},{0,38040005,20}]};

get_reach_reward_info(5,1,15) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 15,need = 4000,rewards = [{0,20020004,6},{0,20020004,5},{0,20020004,5},{0,38040005,20}]};

get_reach_reward_info(5,1,16) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 16,need = 4600,rewards = [{0,20020004,6},{0,20020004,6},{0,20020004,6},{0,38040005,20}]};

get_reach_reward_info(5,1,17) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 17,need = 5200,rewards = [{0,20020004,6},{0,20020004,6},{0,20020004,6},{0,38040005,20}]};

get_reach_reward_info(5,1,18) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 18,need = 5900,rewards = [{0,20020004,7},{0,20020004,7},{0,20020004,6},{0,38040005,20}]};

get_reach_reward_info(5,1,19) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 19,need = 6600,rewards = [{0,20020004,7},{0,20020004,7},{0,20020004,6},{0,38040005,20}]};

get_reach_reward_info(5,1,20) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 20,need = 7300,rewards = [{0,20020004,8},{0,20020004,7},{0,20020004,7},{0,38040005,20}]};

get_reach_reward_info(5,1,21) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 21,need = 8100,rewards = [{0,20020004,8},{0,20020004,8},{0,20020004,8},{0,38040005,20}]};

get_reach_reward_info(5,1,22) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 22,need = 9000,rewards = [{0,20020004,9},{0,20020004,9},{0,20020004,8},{0,38040005,20}]};

get_reach_reward_info(5,1,23) ->
	#base_reach_reward_info{type = 5,sub_type = 1,reward_id = 23,need = 10000,rewards = [{0,20020004,10},{0,20020004,9},{0,20020004,9},{0,38040005,20}]};

get_reach_reward_info(5,2,1) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 1,need = 30,rewards = [{0,20020004,1}]};

get_reach_reward_info(5,2,2) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 2,need = 80,rewards = [{0,20020004,1},{0,20020004,1}]};

get_reach_reward_info(5,2,3) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 3,need = 150,rewards = [{0,20020004,1},{0,20020004,1},{0,20020004,1},{0,38040005,5}]};

get_reach_reward_info(5,2,4) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 4,need = 300,rewards = [{0,20020004,2},{0,20020004,1},{0,20020004,1},{0,38040005,5}]};

get_reach_reward_info(5,2,5) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 5,need = 500,rewards = [{0,20020004,2},{0,20020004,2},{0,20020004,1},{0,38040005,8}]};

get_reach_reward_info(5,2,6) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 6,need = 700,rewards = [{0,20020004,2},{0,20020004,2},{0,20020004,2},{0,38040005,8}]};

get_reach_reward_info(5,2,7) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 7,need = 900,rewards = [{0,20020004,3},{0,20020004,2},{0,20020004,2},{0,38040005,12}]};

get_reach_reward_info(5,2,8) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 8,need = 1200,rewards = [{0,20020004,3},{0,20020004,3},{0,20020004,2},{0,38040005,12}]};

get_reach_reward_info(5,2,9) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 9,need = 1500,rewards = [{0,20020004,3},{0,20020004,3},{0,20020004,3},{0,38040005,15}]};

get_reach_reward_info(5,2,10) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 10,need = 1800,rewards = [{0,20020004,4},{0,20020004,3},{0,20020004,3},{0,38040005,15}]};

get_reach_reward_info(5,2,11) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 11,need = 2100,rewards = [{0,20020004,4},{0,20020004,4},{0,20020004,4},{0,38040005,18}]};

get_reach_reward_info(5,2,12) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 12,need = 2500,rewards = [{0,20020004,5},{0,20020004,5},{0,20020004,4},{0,38040005,18}]};

get_reach_reward_info(5,2,13) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 13,need = 3000,rewards = [{0,20020004,5},{0,20020004,5},{0,20020004,5},{0,38040005,20}]};

get_reach_reward_info(5,2,14) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 14,need = 3500,rewards = [{0,20020004,5},{0,20020004,5},{0,20020004,5},{0,38040005,20}]};

get_reach_reward_info(5,2,15) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 15,need = 4000,rewards = [{0,20020004,6},{0,20020004,5},{0,20020004,5},{0,38040005,20}]};

get_reach_reward_info(5,2,16) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 16,need = 4600,rewards = [{0,20020004,6},{0,20020004,6},{0,20020004,6},{0,38040005,20}]};

get_reach_reward_info(5,2,17) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 17,need = 5200,rewards = [{0,20020004,6},{0,20020004,6},{0,20020004,6},{0,38040005,20}]};

get_reach_reward_info(5,2,18) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 18,need = 5900,rewards = [{0,20020004,7},{0,20020004,7},{0,20020004,6},{0,38040005,20}]};

get_reach_reward_info(5,2,19) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 19,need = 6600,rewards = [{0,20020004,7},{0,20020004,7},{0,20020004,6},{0,38040005,20}]};

get_reach_reward_info(5,2,20) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 20,need = 7300,rewards = [{0,20020004,8},{0,20020004,7},{0,20020004,7},{0,38040005,20}]};

get_reach_reward_info(5,2,21) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 21,need = 8100,rewards = [{0,20020004,8},{0,20020004,8},{0,20020004,8},{0,38040005,20}]};

get_reach_reward_info(5,2,22) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 22,need = 9000,rewards = [{0,20020004,9},{0,20020004,9},{0,20020004,8},{0,38040005,20}]};

get_reach_reward_info(5,2,23) ->
	#base_reach_reward_info{type = 5,sub_type = 2,reward_id = 23,need = 10000,rewards = [{0,20020004,10},{0,20020004,9},{0,20020004,9},{0,38040005,20}]};

get_reach_reward_info(6,1,1) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 1,need = 30,rewards = [{0,25020004,1}]};

get_reach_reward_info(6,1,2) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 2,need = 80,rewards = [{0,25020004,1},{0,25020004,1}]};

get_reach_reward_info(6,1,3) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 3,need = 150,rewards = [{0,25020004,1},{0,25020004,1},{0,25020004,1},{0,38040005,5}]};

get_reach_reward_info(6,1,4) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 4,need = 300,rewards = [{0,25020004,2},{0,25020004,1},{0,25020004,1},{0,38040005,5}]};

get_reach_reward_info(6,1,5) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 5,need = 500,rewards = [{0,25020004,2},{0,25020004,2},{0,25020004,1},{0,38040005,8}]};

get_reach_reward_info(6,1,6) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 6,need = 700,rewards = [{0,25020004,2},{0,25020004,2},{0,25020004,2},{0,38040005,8}]};

get_reach_reward_info(6,1,7) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 7,need = 900,rewards = [{0,25020004,3},{0,25020004,2},{0,25020004,2},{0,38040005,12}]};

get_reach_reward_info(6,1,8) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 8,need = 1200,rewards = [{0,25020004,3},{0,25020004,3},{0,25020004,2},{0,38040005,12}]};

get_reach_reward_info(6,1,9) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 9,need = 1500,rewards = [{0,25020004,3},{0,25020004,3},{0,25020004,3},{0,38040005,15}]};

get_reach_reward_info(6,1,10) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 10,need = 1800,rewards = [{0,25020004,4},{0,25020004,3},{0,25020004,3},{0,38040005,15}]};

get_reach_reward_info(6,1,11) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 11,need = 2100,rewards = [{0,25020004,4},{0,25020004,4},{0,25020004,4},{0,38040005,18}]};

get_reach_reward_info(6,1,12) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 12,need = 2500,rewards = [{0,25020004,5},{0,25020004,5},{0,25020004,4},{0,38040005,18}]};

get_reach_reward_info(6,1,13) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 13,need = 3000,rewards = [{0,25020004,5},{0,25020004,5},{0,25020004,5},{0,38040005,20}]};

get_reach_reward_info(6,1,14) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 14,need = 3500,rewards = [{0,25020004,5},{0,25020004,5},{0,25020004,5},{0,38040005,20}]};

get_reach_reward_info(6,1,15) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 15,need = 4000,rewards = [{0,25020004,6},{0,25020004,5},{0,25020004,5},{0,38040005,20}]};

get_reach_reward_info(6,1,16) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 16,need = 4600,rewards = [{0,25020004,6},{0,25020004,6},{0,25020004,6},{0,38040005,20}]};

get_reach_reward_info(6,1,17) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 17,need = 5200,rewards = [{0,25020004,6},{0,25020004,6},{0,25020004,6},{0,38040005,20}]};

get_reach_reward_info(6,1,18) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 18,need = 5900,rewards = [{0,25020004,7},{0,25020004,7},{0,25020004,6},{0,38040005,20}]};

get_reach_reward_info(6,1,19) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 19,need = 6600,rewards = [{0,25020004,7},{0,25020004,7},{0,25020004,6},{0,38040005,20}]};

get_reach_reward_info(6,1,20) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 20,need = 7300,rewards = [{0,25020004,8},{0,25020004,7},{0,25020004,7},{0,38040005,20}]};

get_reach_reward_info(6,1,21) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 21,need = 8100,rewards = [{0,25020004,8},{0,25020004,8},{0,25020004,8},{0,38040005,20}]};

get_reach_reward_info(6,1,22) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 22,need = 9000,rewards = [{0,25020004,9},{0,25020004,9},{0,25020004,8},{0,38040005,20}]};

get_reach_reward_info(6,1,23) ->
	#base_reach_reward_info{type = 6,sub_type = 1,reward_id = 23,need = 10000,rewards = [{0,25020004,10},{0,25020004,9},{0,25020004,9},{0,38040005,20}]};

get_reach_reward_info(6,2,1) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 1,need = 30,rewards = [{0,25020004,1}]};

get_reach_reward_info(6,2,2) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 2,need = 80,rewards = [{0,25020004,1},{0,25020004,1}]};

get_reach_reward_info(6,2,3) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 3,need = 150,rewards = [{0,25020004,1},{0,25020004,1},{0,25020004,1},{0,38040005,5}]};

get_reach_reward_info(6,2,4) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 4,need = 300,rewards = [{0,25020004,2},{0,25020004,1},{0,25020004,1},{0,38040005,5}]};

get_reach_reward_info(6,2,5) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 5,need = 500,rewards = [{0,25020004,2},{0,25020004,2},{0,25020004,1},{0,38040005,8}]};

get_reach_reward_info(6,2,6) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 6,need = 700,rewards = [{0,25020004,2},{0,25020004,2},{0,25020004,2},{0,38040005,8}]};

get_reach_reward_info(6,2,7) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 7,need = 900,rewards = [{0,25020004,3},{0,25020004,2},{0,25020004,2},{0,38040005,12}]};

get_reach_reward_info(6,2,8) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 8,need = 1200,rewards = [{0,25020004,3},{0,25020004,3},{0,25020004,2},{0,38040005,12}]};

get_reach_reward_info(6,2,9) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 9,need = 1500,rewards = [{0,25020004,3},{0,25020004,3},{0,25020004,3},{0,38040005,15}]};

get_reach_reward_info(6,2,10) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 10,need = 1800,rewards = [{0,25020004,4},{0,25020004,3},{0,25020004,3},{0,38040005,15}]};

get_reach_reward_info(6,2,11) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 11,need = 2100,rewards = [{0,25020004,4},{0,25020004,4},{0,25020004,4},{0,38040005,18}]};

get_reach_reward_info(6,2,12) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 12,need = 2500,rewards = [{0,25020004,5},{0,25020004,5},{0,25020004,4},{0,38040005,18}]};

get_reach_reward_info(6,2,13) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 13,need = 3000,rewards = [{0,25020004,5},{0,25020004,5},{0,25020004,5},{0,38040005,20}]};

get_reach_reward_info(6,2,14) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 14,need = 3500,rewards = [{0,25020004,5},{0,25020004,5},{0,25020004,5},{0,38040005,20}]};

get_reach_reward_info(6,2,15) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 15,need = 4000,rewards = [{0,25020004,6},{0,25020004,5},{0,25020004,5},{0,38040005,20}]};

get_reach_reward_info(6,2,16) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 16,need = 4600,rewards = [{0,25020004,6},{0,25020004,6},{0,25020004,6},{0,38040005,20}]};

get_reach_reward_info(6,2,17) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 17,need = 5200,rewards = [{0,25020004,6},{0,25020004,6},{0,25020004,6},{0,38040005,20}]};

get_reach_reward_info(6,2,18) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 18,need = 5900,rewards = [{0,25020004,7},{0,25020004,7},{0,25020004,6},{0,38040005,20}]};

get_reach_reward_info(6,2,19) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 19,need = 6600,rewards = [{0,25020004,7},{0,25020004,7},{0,25020004,6},{0,38040005,20}]};

get_reach_reward_info(6,2,20) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 20,need = 7300,rewards = [{0,25020004,8},{0,25020004,7},{0,25020004,7},{0,38040005,20}]};

get_reach_reward_info(6,2,21) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 21,need = 8100,rewards = [{0,25020004,8},{0,25020004,8},{0,25020004,8},{0,38040005,20}]};

get_reach_reward_info(6,2,22) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 22,need = 9000,rewards = [{0,25020004,9},{0,25020004,9},{0,25020004,8},{0,38040005,20}]};

get_reach_reward_info(6,2,23) ->
	#base_reach_reward_info{type = 6,sub_type = 2,reward_id = 23,need = 10000,rewards = [{0,25020004,10},{0,25020004,9},{0,25020004,9},{0,38040005,20}]};

get_reach_reward_info(_Type,_Subtype,_Rewardid) ->
	[].

get_reach_reward_id_list(1,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(1,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(2,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(2,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(3,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(3,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(4,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(4,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(5,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(5,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(6,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(6,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];

get_reach_reward_id_list(_Type,_Subtype) ->
	[].

get_all_points_goods_id() ->
[16020004,17020004,18020004,19020004,20020004,25020004].

get_cycle_rank_points(1,1,16020004) ->
10;

get_cycle_rank_points(1,2,16020004) ->
10;

get_cycle_rank_points(2,1,17020004) ->
10;

get_cycle_rank_points(2,2,17020004) ->
10;

get_cycle_rank_points(3,1,18020004) ->
10;

get_cycle_rank_points(3,2,18020004) ->
10;

get_cycle_rank_points(4,1,19020004) ->
10;

get_cycle_rank_points(4,2,19020004) ->
10;

get_cycle_rank_points(5,1,20020004) ->
10;

get_cycle_rank_points(5,2,20020004) ->
10;

get_cycle_rank_points(6,1,25020004) ->
10;

get_cycle_rank_points(6,2,25020004) ->
10;

get_cycle_rank_points(_Type,_Subtype,_Goodsid) ->
	0.

get_rank_reward(1,1,1) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,16030120,30},{0,16020004,60},{0,16010003,2},{0,16010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(1,1,2) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,16030120,25},{0,16020004,35},{0,16010003,1},{0,16010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(1,1,3) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,16030120,25},{0,16020004,33},{0,16010003,1},{0,16010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(1,1,4) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,16030120,15},{0,16020004,30},{0,16010002,3},{0,16010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,1,5) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,16030120,15},{0,16020004,28},{0,16010002,2},{0,16010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,1,6) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,16030120,14},{0,16020004,26},{0,16010002,2},{0,16010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,1,7) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,16030120,13},{0,16020004,25},{0,16010002,1},{0,16010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,1,8) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,16030120,12},{0,16020004,23},{0,16010002,1},{0,16010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,1,9) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,16030120,11},{0,16020004,22},{0,16010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,1,10) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,16030120,10},{0,16020004,20},{0,16010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,1,11) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,16030120,8},{0,16020004,20},{0,16010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(1,1,12) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,16030120,7},{0,16020004,20},{0,16010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(1,1,13) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,16030120,6},{0,16020004,20},{0,16010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(1,1,14) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,16030120,5},{0,16020004,20},{0,16010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(1,1,15) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,16020004,15},{0,16010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(1,1,16) ->
	#base_cycle_rank_reward{type = 1,sub_type = 1,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,16020004,10},{0,16010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(1,2,1) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,16030120,30},{0,16020004,60},{0,16010003,2},{0,16010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(1,2,2) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,16030120,25},{0,16020004,35},{0,16010003,1},{0,16010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(1,2,3) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,16030120,25},{0,16020004,33},{0,16010003,1},{0,16010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(1,2,4) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,16030120,15},{0,16020004,30},{0,16010002,3},{0,16010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,2,5) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,16030120,15},{0,16020004,28},{0,16010002,2},{0,16010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,2,6) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,16030120,14},{0,16020004,26},{0,16010002,2},{0,16010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,2,7) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,16030120,13},{0,16020004,25},{0,16010002,1},{0,16010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,2,8) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,16030120,12},{0,16020004,23},{0,16010002,1},{0,16010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,2,9) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,16030120,11},{0,16020004,22},{0,16010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,2,10) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,16030120,10},{0,16020004,20},{0,16010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(1,2,11) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,16030120,8},{0,16020004,20},{0,16010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(1,2,12) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,16030120,7},{0,16020004,20},{0,16010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(1,2,13) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,16030120,6},{0,16020004,20},{0,16010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(1,2,14) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,16030120,5},{0,16020004,20},{0,16010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(1,2,15) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,16020004,15},{0,16010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(1,2,16) ->
	#base_cycle_rank_reward{type = 1,sub_type = 2,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,16020004,10},{0,16010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(2,1,1) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,17030106,30},{0,17020004,60},{0,17010003,2},{0,17010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(2,1,2) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,17030106,25},{0,17020004,35},{0,17010003,1},{0,17010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(2,1,3) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,17030106,25},{0,17020004,33},{0,17010003,1},{0,17010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(2,1,4) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,17030106,15},{0,17020004,30},{0,17010002,3},{0,17010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,1,5) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,17030106,15},{0,17020004,28},{0,17010002,2},{0,17010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,1,6) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,17030106,14},{0,17020004,26},{0,17010002,2},{0,17010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,1,7) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,17030106,13},{0,17020004,25},{0,17010002,1},{0,17010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,1,8) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,17030106,12},{0,17020004,23},{0,17010002,1},{0,17010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,1,9) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,17030106,11},{0,17020004,22},{0,17010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,1,10) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,17030106,10},{0,17020004,20},{0,17010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,1,11) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,17030106,8},{0,17020004,20},{0,17010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(2,1,12) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,17030106,7},{0,17020004,20},{0,17010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(2,1,13) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,17030106,6},{0,17020004,20},{0,17010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(2,1,14) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,17030106,5},{0,17020004,20},{0,17010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(2,1,15) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,17020004,15},{0,17010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(2,1,16) ->
	#base_cycle_rank_reward{type = 2,sub_type = 1,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,17020004,10},{0,17010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(2,2,1) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,17030106,30},{0,17020004,60},{0,17010003,2},{0,17010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(2,2,2) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,17030106,25},{0,17020004,35},{0,17010003,1},{0,17010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(2,2,3) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,17030106,25},{0,17020004,33},{0,17010003,1},{0,17010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(2,2,4) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,17030106,15},{0,17020004,30},{0,17010002,3},{0,17010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,2,5) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,17030106,15},{0,17020004,28},{0,17010002,2},{0,17010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,2,6) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,17030106,14},{0,17020004,26},{0,17010002,2},{0,17010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,2,7) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,17030106,13},{0,17020004,25},{0,17010002,1},{0,17010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,2,8) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,17030106,12},{0,17020004,23},{0,17010002,1},{0,17010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,2,9) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,17030106,11},{0,17020004,22},{0,17010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,2,10) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,17030106,10},{0,17020004,20},{0,17010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(2,2,11) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,17030106,8},{0,17020004,20},{0,17010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(2,2,12) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,17030106,7},{0,17020004,20},{0,17010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(2,2,13) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,17030106,6},{0,17020004,20},{0,17010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(2,2,14) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,17030106,5},{0,17020004,20},{0,17010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(2,2,15) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,17020004,15},{0,17010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(2,2,16) ->
	#base_cycle_rank_reward{type = 2,sub_type = 2,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,17020004,10},{0,17010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(3,1,1) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,18030120,30},{0,18020004,60},{0,18010003,2},{0,18010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(3,1,2) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,18030120,25},{0,18020004,35},{0,18010003,1},{0,18010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(3,1,3) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,18030120,25},{0,18020004,33},{0,18010003,1},{0,18010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(3,1,4) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,18030120,15},{0,18020004,30},{0,18010002,3},{0,18010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,1,5) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,18030120,15},{0,18020004,28},{0,18010002,2},{0,18010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,1,6) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,18030120,14},{0,18020004,26},{0,18010002,2},{0,18010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,1,7) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,18030120,13},{0,18020004,25},{0,18010002,1},{0,18010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,1,8) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,18030120,12},{0,18020004,23},{0,18010002,1},{0,18010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,1,9) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,18030120,11},{0,18020004,22},{0,18010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,1,10) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,18030120,10},{0,18020004,20},{0,18010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,1,11) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,18030120,8},{0,18020004,20},{0,18010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(3,1,12) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,18030120,7},{0,18020004,20},{0,18010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(3,1,13) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,18030120,6},{0,18020004,20},{0,18010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(3,1,14) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,18030120,5},{0,18020004,20},{0,18010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(3,1,15) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,18020004,15},{0,18010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(3,1,16) ->
	#base_cycle_rank_reward{type = 3,sub_type = 1,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,18020004,10},{0,18010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(3,2,1) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,18030120,30},{0,18020004,60},{0,18010003,2},{0,18010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(3,2,2) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,18030120,25},{0,18020004,35},{0,18010003,1},{0,18010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(3,2,3) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,18030120,25},{0,18020004,33},{0,18010003,1},{0,18010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(3,2,4) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,18030120,15},{0,18020004,30},{0,18010002,3},{0,18010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,2,5) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,18030120,15},{0,18020004,28},{0,18010002,2},{0,18010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,2,6) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,18030120,14},{0,18020004,26},{0,18010002,2},{0,18010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,2,7) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,18030120,13},{0,18020004,25},{0,18010002,1},{0,18010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,2,8) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,18030120,12},{0,18020004,23},{0,18010002,1},{0,18010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,2,9) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,18030120,11},{0,18020004,22},{0,18010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,2,10) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,18030120,10},{0,18020004,20},{0,18010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(3,2,11) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,18030120,8},{0,18020004,20},{0,18010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(3,2,12) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,18030120,7},{0,18020004,20},{0,18010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(3,2,13) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,18030120,6},{0,18020004,20},{0,18010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(3,2,14) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,18030120,5},{0,18020004,20},{0,18010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(3,2,15) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,18020004,15},{0,18010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(3,2,16) ->
	#base_cycle_rank_reward{type = 3,sub_type = 2,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,18020004,10},{0,18010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(4,1,1) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,19030111,30},{0,19020004,60},{0,19010003,2},{0,19010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(4,1,2) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,19030111,25},{0,19020004,35},{0,19010003,1},{0,19010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(4,1,3) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,19030111,25},{0,19020004,33},{0,19010003,1},{0,19010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(4,1,4) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,19030111,15},{0,19020004,30},{0,19010002,3},{0,19010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,1,5) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,19030111,15},{0,19020004,28},{0,19010002,2},{0,19010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,1,6) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,19030111,14},{0,19020004,26},{0,19010002,2},{0,19010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,1,7) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,19030111,13},{0,19020004,25},{0,19010002,1},{0,19010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,1,8) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,19030111,12},{0,19020004,23},{0,19010002,1},{0,19010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,1,9) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,19030111,11},{0,19020004,22},{0,19010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,1,10) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,19030111,10},{0,19020004,20},{0,19010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,1,11) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,19030111,8},{0,19020004,20},{0,19010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(4,1,12) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,19030111,7},{0,19020004,20},{0,19010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(4,1,13) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,19030111,6},{0,19020004,20},{0,19010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(4,1,14) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,19030111,5},{0,19020004,20},{0,19010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(4,1,15) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,19020004,15},{0,19010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(4,1,16) ->
	#base_cycle_rank_reward{type = 4,sub_type = 1,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,19020004,10},{0,19010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(4,2,1) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,19030111,30},{0,19020004,60},{0,19010003,2},{0,19010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(4,2,2) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,19030111,25},{0,19020004,35},{0,19010003,1},{0,19010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(4,2,3) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,19030111,25},{0,19020004,33},{0,19010003,1},{0,19010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(4,2,4) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,19030111,15},{0,19020004,30},{0,19010002,3},{0,19010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,2,5) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,19030111,15},{0,19020004,28},{0,19010002,2},{0,19010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,2,6) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,19030111,14},{0,19020004,26},{0,19010002,2},{0,19010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,2,7) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,19030111,13},{0,19020004,25},{0,19010002,1},{0,19010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,2,8) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,19030111,12},{0,19020004,23},{0,19010002,1},{0,19010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,2,9) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,19030111,11},{0,19020004,22},{0,19010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,2,10) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,19030111,10},{0,19020004,20},{0,19010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(4,2,11) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,19030111,8},{0,19020004,20},{0,19010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(4,2,12) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,19030111,7},{0,19020004,20},{0,19010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(4,2,13) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,19030111,6},{0,19020004,20},{0,19010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(4,2,14) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,19030111,5},{0,19020004,20},{0,19010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(4,2,15) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,19020004,15},{0,19010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(4,2,16) ->
	#base_cycle_rank_reward{type = 4,sub_type = 2,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,19020004,10},{0,19010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(5,1,1) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,20030106,30},{0,20020004,60},{0,20010003,2},{0,20010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(5,1,2) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,20030106,25},{0,20020004,35},{0,20010003,1},{0,20010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(5,1,3) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,20030106,25},{0,20020004,33},{0,20010003,1},{0,20010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(5,1,4) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,20030106,15},{0,20020004,30},{0,20010002,3},{0,20010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,1,5) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,20030106,15},{0,20020004,28},{0,20010002,2},{0,20010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,1,6) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,20030106,14},{0,20020004,26},{0,20010002,2},{0,20010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,1,7) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,20030106,13},{0,20020004,25},{0,20010002,1},{0,20010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,1,8) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,20030106,12},{0,20020004,23},{0,20010002,1},{0,20010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,1,9) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,20030106,11},{0,20020004,22},{0,20010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,1,10) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,20030106,10},{0,20020004,20},{0,20010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,1,11) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,20030106,8},{0,20020004,20},{0,20010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(5,1,12) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,20030106,7},{0,20020004,20},{0,20010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(5,1,13) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,20030106,6},{0,20020004,20},{0,20010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(5,1,14) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,20030106,5},{0,20020004,20},{0,20010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(5,1,15) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,20020004,15},{0,20010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(5,1,16) ->
	#base_cycle_rank_reward{type = 5,sub_type = 1,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,20020004,10},{0,20010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(5,2,1) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,20030106,30},{0,20020004,60},{0,20010003,2},{0,20010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(5,2,2) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,20030106,25},{0,20020004,35},{0,20010003,1},{0,20010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(5,2,3) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,20030106,25},{0,20020004,33},{0,20010003,1},{0,20010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(5,2,4) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,20030106,15},{0,20020004,30},{0,20010002,3},{0,20010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,2,5) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,20030106,15},{0,20020004,28},{0,20010002,2},{0,20010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,2,6) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,20030106,14},{0,20020004,26},{0,20010002,2},{0,20010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,2,7) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,20030106,13},{0,20020004,25},{0,20010002,1},{0,20010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,2,8) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,20030106,12},{0,20020004,23},{0,20010002,1},{0,20010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,2,9) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,20030106,11},{0,20020004,22},{0,20010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,2,10) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,20030106,10},{0,20020004,20},{0,20010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(5,2,11) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,20030106,8},{0,20020004,20},{0,20010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(5,2,12) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,20030106,7},{0,20020004,20},{0,20010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(5,2,13) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,20030106,6},{0,20020004,20},{0,20010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(5,2,14) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,20030106,5},{0,20020004,20},{0,20010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(5,2,15) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,20020004,15},{0,20010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(5,2,16) ->
	#base_cycle_rank_reward{type = 5,sub_type = 2,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,20020004,10},{0,20010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(6,1,1) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,25030108,30},{0,25020004,60},{0,25010003,2},{0,25010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(6,1,2) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,25030108,25},{0,25020004,35},{0,25010003,1},{0,25010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(6,1,3) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,25030108,25},{0,25020004,33},{0,25010003,1},{0,25010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(6,1,4) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,25030108,15},{0,25020004,30},{0,25010002,3},{0,25010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,1,5) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,25030108,15},{0,25020004,28},{0,25010002,2},{0,25010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,1,6) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,25030108,14},{0,25020004,26},{0,25010002,2},{0,25010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,1,7) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,25030108,13},{0,25020004,25},{0,25010002,1},{0,25010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,1,8) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,25030108,12},{0,25020004,23},{0,25010002,1},{0,25010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,1,9) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,25030108,11},{0,25020004,22},{0,25010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,1,10) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,25030108,10},{0,25020004,20},{0,25010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,1,11) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,25030108,8},{0,25020004,20},{0,25010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(6,1,12) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,25030108,7},{0,25020004,20},{0,25010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(6,1,13) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,25030108,6},{0,25020004,20},{0,25010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(6,1,14) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,25030108,5},{0,25020004,20},{0,25010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(6,1,15) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,25020004,15},{0,25010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(6,1,16) ->
	#base_cycle_rank_reward{type = 6,sub_type = 1,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,25020004,10},{0,25010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(6,2,1) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 3000,rewards = [{0,25030108,30},{0,25020004,60},{0,25010003,2},{0,25010002,8}],reward = <<"榜单第<font color='#0a953e'>1</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(6,2,2) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 3000,rewards = [{0,25030108,25},{0,25020004,35},{0,25010003,1},{0,25010002,7}],reward = <<"榜单第<font color='#0a953e'>2</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(6,2,3) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 3000,rewards = [{0,25030108,25},{0,25020004,33},{0,25010003,1},{0,25010002,6}],reward = <<"榜单第<font color='#0a953e'>3</font>名<br>且达到<font color='#0a953e'>3000</font>分可领取"/utf8>>};

get_rank_reward(6,2,4) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 2500,rewards = [{0,25030108,15},{0,25020004,30},{0,25010002,3},{0,25010001,5}],reward = <<"榜单第<font color='#0a953e'>4</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,2,5) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 2500,rewards = [{0,25030108,15},{0,25020004,28},{0,25010002,2},{0,25010001,5}],reward = <<"榜单第<font color='#0a953e'>5</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,2,6) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 2500,rewards = [{0,25030108,14},{0,25020004,26},{0,25010002,2},{0,25010001,4}],reward = <<"榜单第<font color='#0a953e'>6</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,2,7) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 2500,rewards = [{0,25030108,13},{0,25020004,25},{0,25010002,1},{0,25010001,4}],reward = <<"榜单第<font color='#0a953e'>7</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,2,8) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 2500,rewards = [{0,25030108,12},{0,25020004,23},{0,25010002,1},{0,25010001,4}],reward = <<"榜单第<font color='#0a953e'>8</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,2,9) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 2500,rewards = [{0,25030108,11},{0,25020004,22},{0,25010001,3}],reward = <<"榜单第<font color='#0a953e'>9</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,2,10) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 2500,rewards = [{0,25030108,10},{0,25020004,20},{0,25010001,3}],reward = <<"榜单第<font color='#0a953e'>10</font>名<br>且达到<font color='#0a953e'>2500</font>分可领取"/utf8>>};

get_rank_reward(6,2,11) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 11,rank_min = 11,rank_max = 12,limit_val = 2000,rewards = [{0,25030108,8},{0,25020004,20},{0,25010001,2}],reward = <<"榜单第<font color='#0a953e'>11-12</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(6,2,12) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 12,rank_min = 13,rank_max = 14,limit_val = 2000,rewards = [{0,25030108,7},{0,25020004,20},{0,25010001,2}],reward = <<"榜单第<font color='#0a953e'>13-14</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(6,2,13) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 13,rank_min = 15,rank_max = 16,limit_val = 2000,rewards = [{0,25030108,6},{0,25020004,20},{0,25010001,2}],reward = <<"榜单第<font color='#0a953e'>15-16</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(6,2,14) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 14,rank_min = 17,rank_max = 20,limit_val = 2000,rewards = [{0,25030108,5},{0,25020004,20},{0,25010001,2}],reward = <<"榜单第<font color='#0a953e'>17-20</font>名<br>且达到<font color='#0a953e'>2000</font>分可领取"/utf8>>};

get_rank_reward(6,2,15) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 15,rank_min = 21,rank_max = 30,limit_val = 1500,rewards = [{0,25020004,15},{0,25010001,1}],reward = <<"榜单第<font color='#0a953e'>21-30</font>名<br>且达到<font color='#0a953e'>1500</font>分可领取"/utf8>>};

get_rank_reward(6,2,16) ->
	#base_cycle_rank_reward{type = 6,sub_type = 2,reward_id = 16,rank_min = 31,rank_max = 50,limit_val = 1000,rewards = [{0,25020004,10},{0,25010001,1}],reward = <<"榜单第<font color='#0a953e'>31-50</font>名<br>且达到<font color='#0a953e'>1000</font>分可领取"/utf8>>};

get_rank_reward(_Type,_Subtype,_Rewardid) ->
	[].

get_all_rank_reward_id(1,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(1,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(2,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(2,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(3,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(3,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(4,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(4,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(5,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(5,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(6,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(6,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_all_rank_reward_id(_Type,_Subtype) ->
	[].

get_all_rank_max(1,1) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(1,2) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(2,1) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(2,2) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(3,1) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(3,2) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(4,1) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(4,2) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(5,1) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(5,2) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(6,1) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(6,2) ->
[1,2,3,4,5,6,7,8,9,10,12,14,16,20,30,50];

get_all_rank_max(_Type,_Subtype) ->
	[].

get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 1, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 1, _Sub == 2, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 1, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 2, _Sub == 2, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 1, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 3, _Sub == 2, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 1, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 4, _Sub == 2, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 1, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 5, _Sub == 2, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 1, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 11, _Rank =< 12 ->
		11;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 13, _Rank =< 14 ->
		12;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 15, _Rank =< 16 ->
		13;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 17, _Rank =< 20 ->
		14;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 21, _Rank =< 30 ->
		15;
get_rank_reward_id(_Type,_Sub,_Rank) when _Type == 6, _Sub == 2, _Rank >= 31, _Rank =< 50 ->
		16;
get_rank_reward_id(_Type,_Sub,_Rank) ->
	0.

get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 1, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 1, _Sub == 2, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 1, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 2, _Sub == 2, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 1, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 3, _Sub == 2, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 1, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 4, _Sub == 2, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 1, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 5, _Sub == 2, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 1, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 3000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 3000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 3000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 2500 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 2500 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 2500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 2500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 2500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 2500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 2500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 2000 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 2000 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 2000 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 2000 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 1500 ->
		15;
get_enter_rank_list_id(_Type,_Sub,_Score) when _Type == 6, _Sub == 2, _Score >= 1000 ->
		16;
get_enter_rank_list_id(_Type,_Sub,_Score) ->
	0.

