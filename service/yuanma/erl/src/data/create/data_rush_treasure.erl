%%%---------------------------------------
%%% module      : data_rush_treasure
%%% description : 冲榜夺宝配置
%%%
%%%---------------------------------------
-module(data_rush_treasure).
-compile(export_all).
-include("rush_treasure.hrl").




get(rush_treasure_type) ->
[116];

get(_Key) ->
	[].

get_rank_reward(116,1,1,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 1000,format = 0,reward = [{0,16030120,15},{0,16020004,40}],desc = ""};

get_rank_reward(116,1,1,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 1000,format = 0,reward = [{0,16030120,12},{0,16020004,35}],desc = ""};

get_rank_reward(116,1,1,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 1000,format = 0,reward = [{0,16030120,12},{0,16020004,33}],desc = ""};

get_rank_reward(116,1,1,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 600,format = 0,reward = [{0,16030120,8},{0,16020004,30}],desc = ""};

get_rank_reward(116,1,1,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 600,format = 0,reward = [{0,16030120,8},{0,16020004,28}],desc = ""};

get_rank_reward(116,1,1,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 500,format = 0,reward = [{0,16030120,7},{0,16020004,26}],desc = ""};

get_rank_reward(116,1,1,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 500,format = 0,reward = [{0,16030120,7},{0,16020004,25}],desc = ""};

get_rank_reward(116,1,1,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 500,format = 0,reward = [{0,16030120,6},{0,16020004,23}],desc = ""};

get_rank_reward(116,1,1,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 500,format = 0,reward = [{0,16030120,6},{0,16020004,22}],desc = ""};

get_rank_reward(116,1,1,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 500,format = 0,reward = [{0,16030120,5},{0,16020004,20}],desc = ""};

get_rank_reward(116,1,1,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 150,format = 0,reward = [{0,16020004,20}],desc = ""};

get_rank_reward(116,1,1,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 1,reward_id = 12,rank_min = 21,rank_max = 50,limit_val = 100,format = 0,reward = [{0,16020004,10}],desc = ""};

get_rank_reward(116,1,2,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 500,format = 0,reward = [{0,38040027,2},{0,38040005,200},{0,16020004,25}],desc = ""};

get_rank_reward(116,1,2,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,16020004,20}],desc = ""};

get_rank_reward(116,1,2,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,160},{0,16020004,18}],desc = ""};

get_rank_reward(116,1,2,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,16020004,15}],desc = ""};

get_rank_reward(116,1,2,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,16020004,13}],desc = ""};

get_rank_reward(116,1,2,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,16020004,11}],desc = ""};

get_rank_reward(116,1,2,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,16020004,10}],desc = ""};

get_rank_reward(116,1,2,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 100,format = 0,reward = [{0,38040005,130},{0,16020004,8}],desc = ""};

get_rank_reward(116,1,2,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 100,format = 0,reward = [{0,38040005,120},{0,16020004,7}],desc = ""};

get_rank_reward(116,1,2,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 100,format = 0,reward = [{0,38040005,100},{0,16020004,6}],desc = ""};

get_rank_reward(116,1,2,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 80,format = 0,reward = [{0,38040005,80},{0,16020004,6}],desc = ""};

get_rank_reward(116,1,2,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 12,rank_min = 21,rank_max = 30,limit_val = 50,format = 0,reward = [{0,38040005,30},{0,16020004,5}],desc = ""};

get_rank_reward(116,1,2,13) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 13,rank_min = 31,rank_max = 50,limit_val = 30,format = 0,reward = [{0,38040005,10},{0,16020004,5}],desc = ""};

get_rank_reward(116,1,2,14) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 1,rank_type = 2,reward_id = 14,rank_min = 51,rank_max = 100,limit_val = 30,format = 0,reward = [{0,16020004,2}],desc = ""};

get_rank_reward(116,2,1,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 1000,format = 0,reward = [{0,17030106,15},{0,17020004,40}],desc = ""};

get_rank_reward(116,2,1,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 1000,format = 0,reward = [{0,17030106,12},{0,17020004,35}],desc = ""};

get_rank_reward(116,2,1,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 1000,format = 0,reward = [{0,17030106,12},{0,17020004,33}],desc = ""};

get_rank_reward(116,2,1,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 600,format = 0,reward = [{0,17030106,8},{0,17020004,30}],desc = ""};

get_rank_reward(116,2,1,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 600,format = 0,reward = [{0,17030106,8},{0,17020004,28}],desc = ""};

get_rank_reward(116,2,1,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 500,format = 0,reward = [{0,17030106,7},{0,17020004,26}],desc = ""};

get_rank_reward(116,2,1,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 500,format = 0,reward = [{0,17030106,7},{0,17020004,25}],desc = ""};

get_rank_reward(116,2,1,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 500,format = 0,reward = [{0,17030106,6},{0,17020004,23}],desc = ""};

get_rank_reward(116,2,1,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 500,format = 0,reward = [{0,17030106,6},{0,17020004,22}],desc = ""};

get_rank_reward(116,2,1,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 500,format = 0,reward = [{0,17030106,5},{0,17020004,20}],desc = ""};

get_rank_reward(116,2,1,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 150,format = 0,reward = [{0,17020004,20}],desc = ""};

get_rank_reward(116,2,1,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 1,reward_id = 12,rank_min = 21,rank_max = 50,limit_val = 100,format = 0,reward = [{0,17020004,10}],desc = ""};

get_rank_reward(116,2,2,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 500,format = 0,reward = [{0,38040027,2},{0,38040005,200},{0,17020004,25}],desc = ""};

get_rank_reward(116,2,2,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,17020004,20}],desc = ""};

get_rank_reward(116,2,2,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,170},{0,17020004,18}],desc = ""};

get_rank_reward(116,2,2,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,17020004,15}],desc = ""};

get_rank_reward(116,2,2,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,17020004,13}],desc = ""};

get_rank_reward(116,2,2,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,17020004,11}],desc = ""};

get_rank_reward(116,2,2,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,17020004,10}],desc = ""};

get_rank_reward(116,2,2,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 100,format = 0,reward = [{0,38040005,130},{0,17020004,8}],desc = ""};

get_rank_reward(116,2,2,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 100,format = 0,reward = [{0,38040005,120},{0,17020004,7}],desc = ""};

get_rank_reward(116,2,2,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 100,format = 0,reward = [{0,38040005,100},{0,17020004,6}],desc = ""};

get_rank_reward(116,2,2,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 80,format = 0,reward = [{0,38040005,80},{0,17020004,6}],desc = ""};

get_rank_reward(116,2,2,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 12,rank_min = 21,rank_max = 30,limit_val = 50,format = 0,reward = [{0,38040005,30},{0,17020004,5}],desc = ""};

get_rank_reward(116,2,2,13) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 13,rank_min = 31,rank_max = 50,limit_val = 30,format = 0,reward = [{0,38040005,10},{0,17020004,5}],desc = ""};

get_rank_reward(116,2,2,14) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 2,rank_type = 2,reward_id = 14,rank_min = 51,rank_max = 100,limit_val = 30,format = 0,reward = [{0,17020004,2}],desc = ""};

get_rank_reward(116,3,1,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 1000,format = 0,reward = [{0,18030120,15},{0,18020004,40}],desc = ""};

get_rank_reward(116,3,1,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 1000,format = 0,reward = [{0,18030120,12},{0,18020004,35}],desc = ""};

get_rank_reward(116,3,1,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 1000,format = 0,reward = [{0,18030120,12},{0,18020004,33}],desc = ""};

get_rank_reward(116,3,1,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 600,format = 0,reward = [{0,18030120,8},{0,18020004,30}],desc = ""};

get_rank_reward(116,3,1,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 600,format = 0,reward = [{0,18030120,8},{0,18020004,28}],desc = ""};

get_rank_reward(116,3,1,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 500,format = 0,reward = [{0,18030120,7},{0,18020004,26}],desc = ""};

get_rank_reward(116,3,1,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 500,format = 0,reward = [{0,18030120,7},{0,18020004,25}],desc = ""};

get_rank_reward(116,3,1,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 500,format = 0,reward = [{0,18030120,6},{0,18020004,23}],desc = ""};

get_rank_reward(116,3,1,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 500,format = 0,reward = [{0,18030120,6},{0,18020004,22}],desc = ""};

get_rank_reward(116,3,1,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 500,format = 0,reward = [{0,18030120,5},{0,18020004,20}],desc = ""};

get_rank_reward(116,3,1,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 150,format = 0,reward = [{0,18020004,20}],desc = ""};

get_rank_reward(116,3,1,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 1,reward_id = 12,rank_min = 21,rank_max = 50,limit_val = 100,format = 0,reward = [{0,18020004,10}],desc = ""};

get_rank_reward(116,3,2,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 500,format = 0,reward = [{0,38040027,2},{0,38040005,200},{0,18020004,25}],desc = ""};

get_rank_reward(116,3,2,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,18020004,20}],desc = ""};

get_rank_reward(116,3,2,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,18020004,18}],desc = ""};

get_rank_reward(116,3,2,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,18020004,15}],desc = ""};

get_rank_reward(116,3,2,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,18020004,13}],desc = ""};

get_rank_reward(116,3,2,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,18020004,11}],desc = ""};

get_rank_reward(116,3,2,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,18020004,10}],desc = ""};

get_rank_reward(116,3,2,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 100,format = 0,reward = [{0,38040005,130},{0,18020004,8}],desc = ""};

get_rank_reward(116,3,2,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 100,format = 0,reward = [{0,38040005,120},{0,18020004,7}],desc = ""};

get_rank_reward(116,3,2,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 100,format = 0,reward = [{0,38040005,100},{0,18020004,6}],desc = ""};

get_rank_reward(116,3,2,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 80,format = 0,reward = [{0,38040005,80},{0,18020004,6}],desc = ""};

get_rank_reward(116,3,2,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 12,rank_min = 21,rank_max = 30,limit_val = 50,format = 0,reward = [{0,38040005,30},{0,18020004,5}],desc = ""};

get_rank_reward(116,3,2,13) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 13,rank_min = 31,rank_max = 50,limit_val = 30,format = 0,reward = [{0,38040005,10},{0,18020004,5}],desc = ""};

get_rank_reward(116,3,2,14) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 3,rank_type = 2,reward_id = 14,rank_min = 51,rank_max = 100,limit_val = 30,format = 0,reward = [{0,18020004,2}],desc = ""};

get_rank_reward(116,4,1,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 1000,format = 0,reward = [{0,19030111,15},{0,19020004,40}],desc = ""};

get_rank_reward(116,4,1,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 1000,format = 0,reward = [{0,19030111,12},{0,19020004,35}],desc = ""};

get_rank_reward(116,4,1,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 1000,format = 0,reward = [{0,19030111,12},{0,19020004,33}],desc = ""};

get_rank_reward(116,4,1,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 600,format = 0,reward = [{0,19030111,8},{0,19020004,30}],desc = ""};

get_rank_reward(116,4,1,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 600,format = 0,reward = [{0,19030111,8},{0,19020004,28}],desc = ""};

get_rank_reward(116,4,1,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 500,format = 0,reward = [{0,19030111,7},{0,19020004,26}],desc = ""};

get_rank_reward(116,4,1,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 500,format = 0,reward = [{0,19030111,7},{0,19020004,25}],desc = ""};

get_rank_reward(116,4,1,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 500,format = 0,reward = [{0,19030111,6},{0,19020004,23}],desc = ""};

get_rank_reward(116,4,1,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 500,format = 0,reward = [{0,19030111,6},{0,19020004,22}],desc = ""};

get_rank_reward(116,4,1,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 500,format = 0,reward = [{0,19030111,5},{0,19020004,20}],desc = ""};

get_rank_reward(116,4,1,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 150,format = 0,reward = [{0,19020004,20}],desc = ""};

get_rank_reward(116,4,1,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 1,reward_id = 12,rank_min = 21,rank_max = 50,limit_val = 100,format = 0,reward = [{0,19020004,10}],desc = ""};

get_rank_reward(116,4,2,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 500,format = 0,reward = [{0,38040027,2},{0,38040005,200},{0,19020004,25}],desc = ""};

get_rank_reward(116,4,2,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,19020004,20}],desc = ""};

get_rank_reward(116,4,2,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,190},{0,19020004,18}],desc = ""};

get_rank_reward(116,4,2,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,19020004,15}],desc = ""};

get_rank_reward(116,4,2,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,19020004,13}],desc = ""};

get_rank_reward(116,4,2,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,19020004,11}],desc = ""};

get_rank_reward(116,4,2,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,19020004,10}],desc = ""};

get_rank_reward(116,4,2,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 100,format = 0,reward = [{0,38040005,130},{0,19020004,8}],desc = ""};

get_rank_reward(116,4,2,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 100,format = 0,reward = [{0,38040005,120},{0,19020004,7}],desc = ""};

get_rank_reward(116,4,2,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 100,format = 0,reward = [{0,38040005,100},{0,19020004,6}],desc = ""};

get_rank_reward(116,4,2,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 80,format = 0,reward = [{0,38040005,80},{0,19020004,6}],desc = ""};

get_rank_reward(116,4,2,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 12,rank_min = 21,rank_max = 30,limit_val = 50,format = 0,reward = [{0,38040005,30},{0,19020004,5}],desc = ""};

get_rank_reward(116,4,2,13) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 13,rank_min = 31,rank_max = 50,limit_val = 30,format = 0,reward = [{0,38040005,10},{0,19020004,5}],desc = ""};

get_rank_reward(116,4,2,14) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 4,rank_type = 2,reward_id = 14,rank_min = 51,rank_max = 100,limit_val = 30,format = 0,reward = [{0,19020004,2}],desc = ""};

get_rank_reward(116,5,1,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 1000,format = 0,reward = [{0,20030106,15},{0,20020004,40}],desc = ""};

get_rank_reward(116,5,1,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 1000,format = 0,reward = [{0,20030106,12},{0,20020004,35}],desc = ""};

get_rank_reward(116,5,1,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 1000,format = 0,reward = [{0,20030106,12},{0,20020004,33}],desc = ""};

get_rank_reward(116,5,1,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 600,format = 0,reward = [{0,20030106,8},{0,20020004,30}],desc = ""};

get_rank_reward(116,5,1,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 600,format = 0,reward = [{0,20030106,8},{0,20020004,28}],desc = ""};

get_rank_reward(116,5,1,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 500,format = 0,reward = [{0,20030106,7},{0,20020004,26}],desc = ""};

get_rank_reward(116,5,1,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 500,format = 0,reward = [{0,20030106,7},{0,20020004,25}],desc = ""};

get_rank_reward(116,5,1,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 500,format = 0,reward = [{0,20030106,6},{0,20020004,23}],desc = ""};

get_rank_reward(116,5,1,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 500,format = 0,reward = [{0,20030106,6},{0,20020004,22}],desc = ""};

get_rank_reward(116,5,1,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 500,format = 0,reward = [{0,20030106,5},{0,20020004,20}],desc = ""};

get_rank_reward(116,5,1,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 150,format = 0,reward = [{0,20020004,20}],desc = ""};

get_rank_reward(116,5,1,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 1,reward_id = 12,rank_min = 21,rank_max = 50,limit_val = 100,format = 0,reward = [{0,20020004,10}],desc = ""};

get_rank_reward(116,5,2,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 500,format = 0,reward = [{0,38040027,2},{0,38040005,200},{0,20020004,25}],desc = ""};

get_rank_reward(116,5,2,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,20020004,20}],desc = ""};

get_rank_reward(116,5,2,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,200},{0,20020004,18}],desc = ""};

get_rank_reward(116,5,2,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,20020004,15}],desc = ""};

get_rank_reward(116,5,2,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,20020004,13}],desc = ""};

get_rank_reward(116,5,2,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,20020004,11}],desc = ""};

get_rank_reward(116,5,2,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,20020004,10}],desc = ""};

get_rank_reward(116,5,2,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 100,format = 0,reward = [{0,38040005,130},{0,20020004,8}],desc = ""};

get_rank_reward(116,5,2,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 100,format = 0,reward = [{0,38040005,120},{0,20020004,7}],desc = ""};

get_rank_reward(116,5,2,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 100,format = 0,reward = [{0,38040005,100},{0,20020004,6}],desc = ""};

get_rank_reward(116,5,2,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 80,format = 0,reward = [{0,38040005,80},{0,20020004,6}],desc = ""};

get_rank_reward(116,5,2,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 12,rank_min = 21,rank_max = 30,limit_val = 50,format = 0,reward = [{0,38040005,30},{0,20020004,5}],desc = ""};

get_rank_reward(116,5,2,13) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 13,rank_min = 31,rank_max = 50,limit_val = 30,format = 0,reward = [{0,38040005,10},{0,20020004,5}],desc = ""};

get_rank_reward(116,5,2,14) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 5,rank_type = 2,reward_id = 14,rank_min = 51,rank_max = 100,limit_val = 30,format = 0,reward = [{0,20020004,2}],desc = ""};

get_rank_reward(116,6,1,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 1000,format = 0,reward = [{0,16030120,15},{0,16020004,40}],desc = ""};

get_rank_reward(116,6,1,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 1000,format = 0,reward = [{0,16030120,12},{0,16020004,35}],desc = ""};

get_rank_reward(116,6,1,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 1000,format = 0,reward = [{0,16030120,12},{0,16020004,33}],desc = ""};

get_rank_reward(116,6,1,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 600,format = 0,reward = [{0,16030120,8},{0,16020004,30}],desc = ""};

get_rank_reward(116,6,1,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 600,format = 0,reward = [{0,16030120,8},{0,16020004,28}],desc = ""};

get_rank_reward(116,6,1,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 500,format = 0,reward = [{0,16030120,7},{0,16020004,26}],desc = ""};

get_rank_reward(116,6,1,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 500,format = 0,reward = [{0,16030120,7},{0,16020004,25}],desc = ""};

get_rank_reward(116,6,1,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 500,format = 0,reward = [{0,16030120,6},{0,16020004,23}],desc = ""};

get_rank_reward(116,6,1,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 500,format = 0,reward = [{0,16030120,6},{0,16020004,22}],desc = ""};

get_rank_reward(116,6,1,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 500,format = 0,reward = [{0,16030120,5},{0,16020004,20}],desc = ""};

get_rank_reward(116,6,1,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 150,format = 0,reward = [{0,16020004,20}],desc = ""};

get_rank_reward(116,6,1,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 1,reward_id = 12,rank_min = 21,rank_max = 50,limit_val = 100,format = 0,reward = [{0,16020004,10}],desc = ""};

get_rank_reward(116,6,2,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 500,format = 0,reward = [{0,38040027,2},{0,38040005,200},{0,16020004,25}],desc = ""};

get_rank_reward(116,6,2,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,16020004,20}],desc = ""};

get_rank_reward(116,6,2,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,160},{0,16020004,18}],desc = ""};

get_rank_reward(116,6,2,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,16020004,15}],desc = ""};

get_rank_reward(116,6,2,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,16020004,13}],desc = ""};

get_rank_reward(116,6,2,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,16020004,11}],desc = ""};

get_rank_reward(116,6,2,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,16020004,10}],desc = ""};

get_rank_reward(116,6,2,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 100,format = 0,reward = [{0,38040005,130},{0,16020004,8}],desc = ""};

get_rank_reward(116,6,2,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 100,format = 0,reward = [{0,38040005,120},{0,16020004,7}],desc = ""};

get_rank_reward(116,6,2,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 100,format = 0,reward = [{0,38040005,100},{0,16020004,6}],desc = ""};

get_rank_reward(116,6,2,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 80,format = 0,reward = [{0,38040005,80},{0,16020004,6}],desc = ""};

get_rank_reward(116,6,2,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 12,rank_min = 21,rank_max = 30,limit_val = 50,format = 0,reward = [{0,38040005,30},{0,16020004,5}],desc = ""};

get_rank_reward(116,6,2,13) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 13,rank_min = 31,rank_max = 50,limit_val = 30,format = 0,reward = [{0,38040005,10},{0,16020004,5}],desc = ""};

get_rank_reward(116,6,2,14) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 6,rank_type = 2,reward_id = 14,rank_min = 51,rank_max = 100,limit_val = 30,format = 0,reward = [{0,16020004,2}],desc = ""};

get_rank_reward(116,7,1,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 1000,format = 0,reward = [{0,17030106,15},{0,17020004,40}],desc = ""};

get_rank_reward(116,7,1,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 1000,format = 0,reward = [{0,17030106,12},{0,17020004,35}],desc = ""};

get_rank_reward(116,7,1,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 1000,format = 0,reward = [{0,17030106,12},{0,17020004,33}],desc = ""};

get_rank_reward(116,7,1,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 600,format = 0,reward = [{0,17030106,8},{0,17020004,30}],desc = ""};

get_rank_reward(116,7,1,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 600,format = 0,reward = [{0,17030106,8},{0,17020004,28}],desc = ""};

get_rank_reward(116,7,1,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 500,format = 0,reward = [{0,17030106,7},{0,17020004,26}],desc = ""};

get_rank_reward(116,7,1,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 500,format = 0,reward = [{0,17030106,7},{0,17020004,25}],desc = ""};

get_rank_reward(116,7,1,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 500,format = 0,reward = [{0,17030106,6},{0,17020004,23}],desc = ""};

get_rank_reward(116,7,1,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 500,format = 0,reward = [{0,17030106,6},{0,17020004,22}],desc = ""};

get_rank_reward(116,7,1,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 500,format = 0,reward = [{0,17030106,5},{0,17020004,20}],desc = ""};

get_rank_reward(116,7,1,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 150,format = 0,reward = [{0,17020004,20}],desc = ""};

get_rank_reward(116,7,1,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 1,reward_id = 12,rank_min = 21,rank_max = 50,limit_val = 100,format = 0,reward = [{0,17020004,10}],desc = ""};

get_rank_reward(116,7,2,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 500,format = 0,reward = [{0,38040027,2},{0,38040005,200},{0,17020004,25}],desc = ""};

get_rank_reward(116,7,2,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,17020004,20}],desc = ""};

get_rank_reward(116,7,2,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,170},{0,17020004,18}],desc = ""};

get_rank_reward(116,7,2,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,17020004,15}],desc = ""};

get_rank_reward(116,7,2,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,17020004,13}],desc = ""};

get_rank_reward(116,7,2,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,17020004,11}],desc = ""};

get_rank_reward(116,7,2,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,17020004,10}],desc = ""};

get_rank_reward(116,7,2,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 100,format = 0,reward = [{0,38040005,130},{0,17020004,8}],desc = ""};

get_rank_reward(116,7,2,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 100,format = 0,reward = [{0,38040005,120},{0,17020004,7}],desc = ""};

get_rank_reward(116,7,2,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 100,format = 0,reward = [{0,38040005,100},{0,17020004,6}],desc = ""};

get_rank_reward(116,7,2,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 80,format = 0,reward = [{0,38040005,80},{0,17020004,6}],desc = ""};

get_rank_reward(116,7,2,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 12,rank_min = 21,rank_max = 30,limit_val = 50,format = 0,reward = [{0,38040005,30},{0,17020004,5}],desc = ""};

get_rank_reward(116,7,2,13) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 13,rank_min = 31,rank_max = 50,limit_val = 30,format = 0,reward = [{0,38040005,10},{0,17020004,5}],desc = ""};

get_rank_reward(116,7,2,14) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 7,rank_type = 2,reward_id = 14,rank_min = 51,rank_max = 100,limit_val = 30,format = 0,reward = [{0,17020004,2}],desc = ""};

get_rank_reward(116,8,1,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 1000,format = 0,reward = [{0,18030120,15},{0,18020004,40}],desc = ""};

get_rank_reward(116,8,1,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 1000,format = 0,reward = [{0,18030120,12},{0,18020004,35}],desc = ""};

get_rank_reward(116,8,1,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 1000,format = 0,reward = [{0,18030120,12},{0,18020004,33}],desc = ""};

get_rank_reward(116,8,1,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 600,format = 0,reward = [{0,18030120,8},{0,18020004,30}],desc = ""};

get_rank_reward(116,8,1,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 600,format = 0,reward = [{0,18030120,8},{0,18020004,28}],desc = ""};

get_rank_reward(116,8,1,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 500,format = 0,reward = [{0,18030120,7},{0,18020004,26}],desc = ""};

get_rank_reward(116,8,1,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 500,format = 0,reward = [{0,18030120,7},{0,18020004,25}],desc = ""};

get_rank_reward(116,8,1,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 500,format = 0,reward = [{0,18030120,6},{0,18020004,23}],desc = ""};

get_rank_reward(116,8,1,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 500,format = 0,reward = [{0,18030120,6},{0,18020004,22}],desc = ""};

get_rank_reward(116,8,1,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 500,format = 0,reward = [{0,18030120,5},{0,18020004,20}],desc = ""};

get_rank_reward(116,8,1,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 150,format = 0,reward = [{0,18020004,20}],desc = ""};

get_rank_reward(116,8,1,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 1,reward_id = 12,rank_min = 21,rank_max = 50,limit_val = 100,format = 0,reward = [{0,18020004,10}],desc = ""};

get_rank_reward(116,8,2,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 500,format = 0,reward = [{0,38040027,2},{0,38040005,200},{0,18020004,25}],desc = ""};

get_rank_reward(116,8,2,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,18020004,20}],desc = ""};

get_rank_reward(116,8,2,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,18020004,18}],desc = ""};

get_rank_reward(116,8,2,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,18020004,15}],desc = ""};

get_rank_reward(116,8,2,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,18020004,13}],desc = ""};

get_rank_reward(116,8,2,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,18020004,11}],desc = ""};

get_rank_reward(116,8,2,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,18020004,10}],desc = ""};

get_rank_reward(116,8,2,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 100,format = 0,reward = [{0,38040005,130},{0,18020004,8}],desc = ""};

get_rank_reward(116,8,2,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 100,format = 0,reward = [{0,38040005,120},{0,18020004,7}],desc = ""};

get_rank_reward(116,8,2,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 100,format = 0,reward = [{0,38040005,100},{0,18020004,6}],desc = ""};

get_rank_reward(116,8,2,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 80,format = 0,reward = [{0,38040005,80},{0,18020004,6}],desc = ""};

get_rank_reward(116,8,2,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 12,rank_min = 21,rank_max = 30,limit_val = 50,format = 0,reward = [{0,38040005,30},{0,18020004,5}],desc = ""};

get_rank_reward(116,8,2,13) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 13,rank_min = 31,rank_max = 50,limit_val = 30,format = 0,reward = [{0,38040005,10},{0,18020004,5}],desc = ""};

get_rank_reward(116,8,2,14) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 8,rank_type = 2,reward_id = 14,rank_min = 51,rank_max = 100,limit_val = 30,format = 0,reward = [{0,18020004,2}],desc = ""};

get_rank_reward(116,9,1,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 1000,format = 0,reward = [{0,19030111,15},{0,19020004,40}],desc = ""};

get_rank_reward(116,9,1,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 1000,format = 0,reward = [{0,19030111,12},{0,19020004,35}],desc = ""};

get_rank_reward(116,9,1,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 1000,format = 0,reward = [{0,19030111,12},{0,19020004,33}],desc = ""};

get_rank_reward(116,9,1,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 600,format = 0,reward = [{0,19030111,8},{0,19020004,30}],desc = ""};

get_rank_reward(116,9,1,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 600,format = 0,reward = [{0,19030111,8},{0,19020004,28}],desc = ""};

get_rank_reward(116,9,1,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 500,format = 0,reward = [{0,19030111,7},{0,19020004,26}],desc = ""};

get_rank_reward(116,9,1,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 500,format = 0,reward = [{0,19030111,7},{0,19020004,25}],desc = ""};

get_rank_reward(116,9,1,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 500,format = 0,reward = [{0,19030111,6},{0,19020004,23}],desc = ""};

get_rank_reward(116,9,1,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 500,format = 0,reward = [{0,19030111,6},{0,19020004,22}],desc = ""};

get_rank_reward(116,9,1,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 500,format = 0,reward = [{0,19030111,5},{0,19020004,20}],desc = ""};

get_rank_reward(116,9,1,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 150,format = 0,reward = [{0,19020004,20}],desc = ""};

get_rank_reward(116,9,1,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 1,reward_id = 12,rank_min = 21,rank_max = 50,limit_val = 100,format = 0,reward = [{0,19020004,10}],desc = ""};

get_rank_reward(116,9,2,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 500,format = 0,reward = [{0,38040027,2},{0,38040005,200},{0,19020004,25}],desc = ""};

get_rank_reward(116,9,2,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,19020004,20}],desc = ""};

get_rank_reward(116,9,2,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,190},{0,19020004,18}],desc = ""};

get_rank_reward(116,9,2,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,19020004,15}],desc = ""};

get_rank_reward(116,9,2,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,19020004,13}],desc = ""};

get_rank_reward(116,9,2,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,19020004,11}],desc = ""};

get_rank_reward(116,9,2,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,19020004,10}],desc = ""};

get_rank_reward(116,9,2,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 100,format = 0,reward = [{0,38040005,130},{0,19020004,8}],desc = ""};

get_rank_reward(116,9,2,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 100,format = 0,reward = [{0,38040005,120},{0,19020004,7}],desc = ""};

get_rank_reward(116,9,2,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 100,format = 0,reward = [{0,38040005,100},{0,19020004,6}],desc = ""};

get_rank_reward(116,9,2,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 80,format = 0,reward = [{0,38040005,80},{0,19020004,6}],desc = ""};

get_rank_reward(116,9,2,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 12,rank_min = 21,rank_max = 30,limit_val = 50,format = 0,reward = [{0,38040005,30},{0,19020004,5}],desc = ""};

get_rank_reward(116,9,2,13) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 13,rank_min = 31,rank_max = 50,limit_val = 30,format = 0,reward = [{0,38040005,10},{0,19020004,5}],desc = ""};

get_rank_reward(116,9,2,14) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 9,rank_type = 2,reward_id = 14,rank_min = 51,rank_max = 100,limit_val = 30,format = 0,reward = [{0,19020004,2}],desc = ""};

get_rank_reward(116,10,1,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 1000,format = 0,reward = [{0,20030106,15},{0,20020004,40}],desc = ""};

get_rank_reward(116,10,1,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 1000,format = 0,reward = [{0,20030106,12},{0,20020004,35}],desc = ""};

get_rank_reward(116,10,1,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 1000,format = 0,reward = [{0,20030106,12},{0,20020004,33}],desc = ""};

get_rank_reward(116,10,1,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 600,format = 0,reward = [{0,20030106,8},{0,20020004,30}],desc = ""};

get_rank_reward(116,10,1,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 600,format = 0,reward = [{0,20030106,8},{0,20020004,28}],desc = ""};

get_rank_reward(116,10,1,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 500,format = 0,reward = [{0,20030106,7},{0,20020004,26}],desc = ""};

get_rank_reward(116,10,1,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 500,format = 0,reward = [{0,20030106,7},{0,20020004,25}],desc = ""};

get_rank_reward(116,10,1,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 500,format = 0,reward = [{0,20030106,6},{0,20020004,23}],desc = ""};

get_rank_reward(116,10,1,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 500,format = 0,reward = [{0,20030106,6},{0,20020004,22}],desc = ""};

get_rank_reward(116,10,1,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 500,format = 0,reward = [{0,20030106,5},{0,20020004,20}],desc = ""};

get_rank_reward(116,10,1,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 150,format = 0,reward = [{0,20020004,20}],desc = ""};

get_rank_reward(116,10,1,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 1,reward_id = 12,rank_min = 21,rank_max = 50,limit_val = 100,format = 0,reward = [{0,20020004,10}],desc = ""};

get_rank_reward(116,10,2,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 500,format = 0,reward = [{0,38040027,2},{0,38040005,200},{0,20020004,25}],desc = ""};

get_rank_reward(116,10,2,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,20020004,20}],desc = ""};

get_rank_reward(116,10,2,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,200},{0,20020004,18}],desc = ""};

get_rank_reward(116,10,2,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,20020004,15}],desc = ""};

get_rank_reward(116,10,2,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,20020004,13}],desc = ""};

get_rank_reward(116,10,2,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,20020004,11}],desc = ""};

get_rank_reward(116,10,2,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,20020004,10}],desc = ""};

get_rank_reward(116,10,2,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 100,format = 0,reward = [{0,38040005,130},{0,20020004,8}],desc = ""};

get_rank_reward(116,10,2,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 100,format = 0,reward = [{0,38040005,120},{0,20020004,7}],desc = ""};

get_rank_reward(116,10,2,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 100,format = 0,reward = [{0,38040005,100},{0,20020004,6}],desc = ""};

get_rank_reward(116,10,2,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 80,format = 0,reward = [{0,38040005,80},{0,20020004,6}],desc = ""};

get_rank_reward(116,10,2,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 12,rank_min = 21,rank_max = 30,limit_val = 50,format = 0,reward = [{0,38040005,30},{0,20020004,5}],desc = ""};

get_rank_reward(116,10,2,13) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 13,rank_min = 31,rank_max = 50,limit_val = 30,format = 0,reward = [{0,38040005,10},{0,20020004,5}],desc = ""};

get_rank_reward(116,10,2,14) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 10,rank_type = 2,reward_id = 14,rank_min = 51,rank_max = 100,limit_val = 30,format = 0,reward = [{0,20020004,2}],desc = ""};

get_rank_reward(116,11,1,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 1000,format = 0,reward = [{0,25030108,15},{0,25020004,40}],desc = ""};

get_rank_reward(116,11,1,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 1000,format = 0,reward = [{0,25030108,12},{0,25020004,35}],desc = ""};

get_rank_reward(116,11,1,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 1000,format = 0,reward = [{0,25030108,12},{0,25020004,33}],desc = ""};

get_rank_reward(116,11,1,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 600,format = 0,reward = [{0,25030108,8},{0,25020004,30}],desc = ""};

get_rank_reward(116,11,1,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 600,format = 0,reward = [{0,25030108,8},{0,25020004,28}],desc = ""};

get_rank_reward(116,11,1,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 500,format = 0,reward = [{0,25030108,7},{0,25020004,26}],desc = ""};

get_rank_reward(116,11,1,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 500,format = 0,reward = [{0,25030108,7},{0,25020004,25}],desc = ""};

get_rank_reward(116,11,1,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 500,format = 0,reward = [{0,25030108,6},{0,25020004,23}],desc = ""};

get_rank_reward(116,11,1,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 500,format = 0,reward = [{0,25030108,6},{0,25020004,22}],desc = ""};

get_rank_reward(116,11,1,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 500,format = 0,reward = [{0,25030108,5},{0,25020004,20}],desc = ""};

get_rank_reward(116,11,1,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 150,format = 0,reward = [{0,25020004,20}],desc = ""};

get_rank_reward(116,11,1,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 1,reward_id = 12,rank_min = 21,rank_max = 50,limit_val = 100,format = 0,reward = [{0,25020004,10}],desc = ""};

get_rank_reward(116,11,2,1) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 1,rank_min = 1,rank_max = 1,limit_val = 500,format = 0,reward = [{0,38040027,2},{0,38040005,200},{0,25020004,25}],desc = ""};

get_rank_reward(116,11,2,2) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 2,rank_min = 2,rank_max = 2,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,180},{0,25020004,20}],desc = ""};

get_rank_reward(116,11,2,3) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 3,rank_min = 3,rank_max = 3,limit_val = 500,format = 0,reward = [{0,38040027,1},{0,38040005,200},{0,25020004,18}],desc = ""};

get_rank_reward(116,11,2,4) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 4,rank_min = 4,rank_max = 4,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,25020004,15}],desc = ""};

get_rank_reward(116,11,2,5) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 5,rank_min = 5,rank_max = 5,limit_val = 150,format = 0,reward = [{0,38040005,150},{0,25020004,13}],desc = ""};

get_rank_reward(116,11,2,6) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 6,rank_min = 6,rank_max = 6,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,25020004,11}],desc = ""};

get_rank_reward(116,11,2,7) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 7,rank_min = 7,rank_max = 7,limit_val = 100,format = 0,reward = [{0,38040005,140},{0,25020004,10}],desc = ""};

get_rank_reward(116,11,2,8) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 8,rank_min = 8,rank_max = 8,limit_val = 100,format = 0,reward = [{0,38040005,130},{0,25020004,8}],desc = ""};

get_rank_reward(116,11,2,9) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 9,rank_min = 9,rank_max = 9,limit_val = 100,format = 0,reward = [{0,38040005,120},{0,25020004,7}],desc = ""};

get_rank_reward(116,11,2,10) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 10,rank_min = 10,rank_max = 10,limit_val = 100,format = 0,reward = [{0,38040005,100},{0,25020004,6}],desc = ""};

get_rank_reward(116,11,2,11) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 11,rank_min = 11,rank_max = 20,limit_val = 80,format = 0,reward = [{0,38040005,80},{0,25020004,6}],desc = ""};

get_rank_reward(116,11,2,12) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 12,rank_min = 21,rank_max = 30,limit_val = 50,format = 0,reward = [{0,38040005,30},{0,25020004,5}],desc = ""};

get_rank_reward(116,11,2,13) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 13,rank_min = 31,rank_max = 50,limit_val = 30,format = 0,reward = [{0,38040005,10},{0,25020004,5}],desc = ""};

get_rank_reward(116,11,2,14) ->
	#base_rush_treasure_rank_reward{type = 116,sub_type = 11,rank_type = 2,reward_id = 14,rank_min = 51,rank_max = 100,limit_val = 30,format = 0,reward = [{0,25020004,2}],desc = ""};

get_rank_reward(_Type,_Subtype,_Ranktype,_Rewardid) ->
	[].

get_rank_reward_all_id(116,1,1) ->
[1,2,3,4,5,6,7,8,9,10,20,50];

get_rank_reward_all_id(116,1,2) ->
[1,2,3,4,5,6,7,8,9,10,20,30,50,100];

get_rank_reward_all_id(116,2,1) ->
[1,2,3,4,5,6,7,8,9,10,20,50];

get_rank_reward_all_id(116,2,2) ->
[1,2,3,4,5,6,7,8,9,10,20,30,50,100];

get_rank_reward_all_id(116,3,1) ->
[1,2,3,4,5,6,7,8,9,10,20,50];

get_rank_reward_all_id(116,3,2) ->
[1,2,3,4,5,6,7,8,9,10,20,30,50,100];

get_rank_reward_all_id(116,4,1) ->
[1,2,3,4,5,6,7,8,9,10,20,50];

get_rank_reward_all_id(116,4,2) ->
[1,2,3,4,5,6,7,8,9,10,20,30,50,100];

get_rank_reward_all_id(116,5,1) ->
[1,2,3,4,5,6,7,8,9,10,20,50];

get_rank_reward_all_id(116,5,2) ->
[1,2,3,4,5,6,7,8,9,10,20,30,50,100];

get_rank_reward_all_id(116,6,1) ->
[1,2,3,4,5,6,7,8,9,10,20,50];

get_rank_reward_all_id(116,6,2) ->
[1,2,3,4,5,6,7,8,9,10,20,30,50,100];

get_rank_reward_all_id(116,7,1) ->
[1,2,3,4,5,6,7,8,9,10,20,50];

get_rank_reward_all_id(116,7,2) ->
[1,2,3,4,5,6,7,8,9,10,20,30,50,100];

get_rank_reward_all_id(116,8,1) ->
[1,2,3,4,5,6,7,8,9,10,20,50];

get_rank_reward_all_id(116,8,2) ->
[1,2,3,4,5,6,7,8,9,10,20,30,50,100];

get_rank_reward_all_id(116,9,1) ->
[1,2,3,4,5,6,7,8,9,10,20,50];

get_rank_reward_all_id(116,9,2) ->
[1,2,3,4,5,6,7,8,9,10,20,30,50,100];

get_rank_reward_all_id(116,10,1) ->
[1,2,3,4,5,6,7,8,9,10,20,50];

get_rank_reward_all_id(116,10,2) ->
[1,2,3,4,5,6,7,8,9,10,20,30,50,100];

get_rank_reward_all_id(116,11,1) ->
[1,2,3,4,5,6,7,8,9,10,20,50];

get_rank_reward_all_id(116,11,2) ->
[1,2,3,4,5,6,7,8,9,10,20,30,50,100];

get_rank_reward_all_id(_Type,_Subtype,_Ranktype) ->
	[].

get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 1, _Rank >= 21, _Rank =< 50 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 21, _Rank =< 30 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 31, _Rank =< 50 ->
		13;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 1, _RankType == 2, _Rank >= 51, _Rank =< 100 ->
		14;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 1, _Rank >= 21, _Rank =< 50 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 21, _Rank =< 30 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 31, _Rank =< 50 ->
		13;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 2, _RankType == 2, _Rank >= 51, _Rank =< 100 ->
		14;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 1, _Rank >= 21, _Rank =< 50 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 21, _Rank =< 30 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 31, _Rank =< 50 ->
		13;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 3, _RankType == 2, _Rank >= 51, _Rank =< 100 ->
		14;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 1, _Rank >= 21, _Rank =< 50 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 21, _Rank =< 30 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 31, _Rank =< 50 ->
		13;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 4, _RankType == 2, _Rank >= 51, _Rank =< 100 ->
		14;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 1, _Rank >= 21, _Rank =< 50 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 21, _Rank =< 30 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 31, _Rank =< 50 ->
		13;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 5, _RankType == 2, _Rank >= 51, _Rank =< 100 ->
		14;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 1, _Rank >= 21, _Rank =< 50 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 21, _Rank =< 30 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 31, _Rank =< 50 ->
		13;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 6, _RankType == 2, _Rank >= 51, _Rank =< 100 ->
		14;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 1, _Rank >= 21, _Rank =< 50 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 21, _Rank =< 30 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 31, _Rank =< 50 ->
		13;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 7, _RankType == 2, _Rank >= 51, _Rank =< 100 ->
		14;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 1, _Rank >= 21, _Rank =< 50 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 21, _Rank =< 30 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 31, _Rank =< 50 ->
		13;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 8, _RankType == 2, _Rank >= 51, _Rank =< 100 ->
		14;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 1, _Rank >= 21, _Rank =< 50 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 21, _Rank =< 30 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 31, _Rank =< 50 ->
		13;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 9, _RankType == 2, _Rank >= 51, _Rank =< 100 ->
		14;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 1, _Rank >= 21, _Rank =< 50 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 21, _Rank =< 30 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 31, _Rank =< 50 ->
		13;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 10, _RankType == 2, _Rank >= 51, _Rank =< 100 ->
		14;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 1, _Rank >= 21, _Rank =< 50 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 1, _Rank =< 1 ->
		1;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 2, _Rank =< 2 ->
		2;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 3, _Rank =< 3 ->
		3;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 4, _Rank =< 4 ->
		4;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 5, _Rank =< 5 ->
		5;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 6, _Rank =< 6 ->
		6;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 7, _Rank =< 7 ->
		7;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 8, _Rank =< 8 ->
		8;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 9, _Rank =< 9 ->
		9;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 10, _Rank =< 10 ->
		10;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 11, _Rank =< 20 ->
		11;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 21, _Rank =< 30 ->
		12;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 31, _Rank =< 50 ->
		13;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) when _Type == 116, _Sub == 11, _RankType == 2, _Rank >= 51, _Rank =< 100 ->
		14;
get_rank_reward_id(_Type,_Sub,_RankType,_Rank) ->
	[].

get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 1000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 1000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 1000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 600 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 600 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 150 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 1, _Score >= 100 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 500 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 500 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 500 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 150 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 150 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 100 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 100 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 100 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 100 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 100 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 80 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 50 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 30 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 1, _RankType == 2, _Score >= 30 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 1000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 1000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 1000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 600 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 600 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 150 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 1, _Score >= 100 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 500 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 500 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 500 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 150 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 150 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 100 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 100 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 100 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 100 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 100 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 80 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 50 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 30 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 2, _RankType == 2, _Score >= 30 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 1000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 1000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 1000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 600 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 600 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 150 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 1, _Score >= 100 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 500 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 500 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 500 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 150 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 150 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 100 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 100 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 100 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 100 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 100 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 80 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 50 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 30 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 3, _RankType == 2, _Score >= 30 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 1000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 1000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 1000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 600 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 600 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 150 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 1, _Score >= 100 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 500 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 500 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 500 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 150 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 150 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 100 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 100 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 100 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 100 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 100 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 80 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 50 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 30 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 4, _RankType == 2, _Score >= 30 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 1000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 1000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 1000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 600 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 600 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 150 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 1, _Score >= 100 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 500 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 500 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 500 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 150 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 150 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 100 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 100 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 100 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 100 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 100 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 80 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 50 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 30 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 5, _RankType == 2, _Score >= 30 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 1000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 1000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 1000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 600 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 600 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 150 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 1, _Score >= 100 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 500 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 500 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 500 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 150 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 150 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 100 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 100 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 100 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 100 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 100 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 80 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 50 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 30 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 6, _RankType == 2, _Score >= 30 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 1000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 1000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 1000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 600 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 600 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 150 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 1, _Score >= 100 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 500 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 500 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 500 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 150 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 150 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 100 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 100 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 100 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 100 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 100 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 80 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 50 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 30 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 7, _RankType == 2, _Score >= 30 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 1000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 1000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 1000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 600 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 600 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 150 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 1, _Score >= 100 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 500 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 500 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 500 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 150 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 150 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 100 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 100 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 100 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 100 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 100 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 80 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 50 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 30 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 8, _RankType == 2, _Score >= 30 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 1000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 1000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 1000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 600 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 600 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 150 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 1, _Score >= 100 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 500 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 500 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 500 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 150 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 150 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 100 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 100 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 100 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 100 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 100 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 80 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 50 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 30 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 9, _RankType == 2, _Score >= 30 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 1000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 1000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 1000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 600 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 600 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 150 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 1, _Score >= 100 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 500 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 500 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 500 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 150 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 150 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 100 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 100 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 100 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 100 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 100 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 80 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 50 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 30 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 10, _RankType == 2, _Score >= 30 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 1000 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 1000 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 1000 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 600 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 600 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 500 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 500 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 500 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 500 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 500 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 150 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 1, _Score >= 100 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 500 ->
		1;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 500 ->
		2;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 500 ->
		3;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 150 ->
		4;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 150 ->
		5;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 100 ->
		6;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 100 ->
		7;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 100 ->
		8;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 100 ->
		9;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 100 ->
		10;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 80 ->
		11;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 50 ->
		12;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 30 ->
		13;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) when _Type == 116, _Sub == 11, _RankType == 2, _Score >= 30 ->
		14;
get_enter_rank_list_id(_Type,_Sub,_RankType,_Score) ->
	[].

get_stage_reward(116,1,1) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 1,need_val = 100,format = 0,reward = [{0,16020004,2}],desc = ""};

get_stage_reward(116,1,2) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 2,need_val = 200,format = 0,reward = [{0,16020004,3}],desc = ""};

get_stage_reward(116,1,3) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 3,need_val = 300,format = 0,reward = [{0,16020004,3}],desc = ""};

get_stage_reward(116,1,4) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 4,need_val = 500,format = 0,reward = [{0,16020004,4}],desc = ""};

get_stage_reward(116,1,5) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 5,need_val = 700,format = 0,reward = [{0,16020004,4},{0,32010151,1}],desc = ""};

get_stage_reward(116,1,6) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 6,need_val = 900,format = 0,reward = [{0,16020004,5},{0,32010151,2}],desc = ""};

get_stage_reward(116,1,7) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 7,need_val = 1100,format = 0,reward = [{0,16020004,5},{0,32010151,3}],desc = ""};

get_stage_reward(116,1,8) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 8,need_val = 1400,format = 0,reward = [{0,16020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,1,9) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 9,need_val = 1800,format = 0,reward = [{0,16020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,1,10) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 10,need_val = 2100,format = 0,reward = [{0,16020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,1,11) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 11,need_val = 2500,format = 0,reward = [{0,16020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,1,12) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 12,need_val = 3000,format = 0,reward = [{0,16020004,10},{0,32010152,2}],desc = ""};

get_stage_reward(116,1,13) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 13,need_val = 3500,format = 0,reward = [{0,16020004,10},{0,32010152,3}],desc = ""};

get_stage_reward(116,1,14) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 14,need_val = 4000,format = 0,reward = [{0,16020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,1,15) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 15,need_val = 4500,format = 0,reward = [{0,16020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,1,16) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 1,reward_id = 16,need_val = 5000,format = 0,reward = [{0,16020004,15},{0,32010153,2}],desc = ""};

get_stage_reward(116,2,1) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 1,need_val = 100,format = 0,reward = [{0,17020004,2}],desc = ""};

get_stage_reward(116,2,2) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 2,need_val = 200,format = 0,reward = [{0,17020004,3}],desc = ""};

get_stage_reward(116,2,3) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 3,need_val = 300,format = 0,reward = [{0,17020004,3}],desc = ""};

get_stage_reward(116,2,4) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 4,need_val = 500,format = 0,reward = [{0,17020004,4}],desc = ""};

get_stage_reward(116,2,5) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 5,need_val = 700,format = 0,reward = [{0,17020004,4},{0,32010151,1}],desc = ""};

get_stage_reward(116,2,6) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 6,need_val = 900,format = 0,reward = [{0,17020004,5},{0,32010151,2}],desc = ""};

get_stage_reward(116,2,7) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 7,need_val = 1100,format = 0,reward = [{0,17020004,5},{0,32010151,3}],desc = ""};

get_stage_reward(116,2,8) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 8,need_val = 1400,format = 0,reward = [{0,17020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,2,9) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 9,need_val = 1800,format = 0,reward = [{0,17020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,2,10) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 10,need_val = 2100,format = 0,reward = [{0,17020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,2,11) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 11,need_val = 2500,format = 0,reward = [{0,17020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,2,12) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 12,need_val = 3000,format = 0,reward = [{0,17020004,10},{0,32010152,2}],desc = ""};

get_stage_reward(116,2,13) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 13,need_val = 3500,format = 0,reward = [{0,17020004,10},{0,32010152,3}],desc = ""};

get_stage_reward(116,2,14) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 14,need_val = 4000,format = 0,reward = [{0,17020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,2,15) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 15,need_val = 4500,format = 0,reward = [{0,17020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,2,16) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 2,reward_id = 16,need_val = 5000,format = 0,reward = [{0,17020004,15},{0,32010153,2}],desc = ""};

get_stage_reward(116,3,1) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 1,need_val = 100,format = 0,reward = [{0,18020004,2}],desc = ""};

get_stage_reward(116,3,2) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 2,need_val = 200,format = 0,reward = [{0,18020004,3}],desc = ""};

get_stage_reward(116,3,3) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 3,need_val = 300,format = 0,reward = [{0,18020004,3}],desc = ""};

get_stage_reward(116,3,4) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 4,need_val = 500,format = 0,reward = [{0,18020004,4}],desc = ""};

get_stage_reward(116,3,5) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 5,need_val = 700,format = 0,reward = [{0,18020004,4},{0,32010151,1}],desc = ""};

get_stage_reward(116,3,6) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 6,need_val = 900,format = 0,reward = [{0,18020004,5},{0,32010151,2}],desc = ""};

get_stage_reward(116,3,7) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 7,need_val = 1100,format = 0,reward = [{0,18020004,5},{0,32010151,3}],desc = ""};

get_stage_reward(116,3,8) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 8,need_val = 1400,format = 0,reward = [{0,18020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,3,9) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 9,need_val = 1800,format = 0,reward = [{0,18020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,3,10) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 10,need_val = 2100,format = 0,reward = [{0,18020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,3,11) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 11,need_val = 2500,format = 0,reward = [{0,18020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,3,12) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 12,need_val = 3000,format = 0,reward = [{0,18020004,10},{0,32010152,2}],desc = ""};

get_stage_reward(116,3,13) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 13,need_val = 3500,format = 0,reward = [{0,18020004,10},{0,32010152,3}],desc = ""};

get_stage_reward(116,3,14) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 14,need_val = 4000,format = 0,reward = [{0,18020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,3,15) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 15,need_val = 4500,format = 0,reward = [{0,18020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,3,16) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 3,reward_id = 16,need_val = 5000,format = 0,reward = [{0,18020004,15},{0,32010153,2}],desc = ""};

get_stage_reward(116,4,1) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 1,need_val = 100,format = 0,reward = [{0,19020004,2}],desc = ""};

get_stage_reward(116,4,2) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 2,need_val = 200,format = 0,reward = [{0,19020004,3}],desc = ""};

get_stage_reward(116,4,3) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 3,need_val = 300,format = 0,reward = [{0,19020004,3}],desc = ""};

get_stage_reward(116,4,4) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 4,need_val = 500,format = 0,reward = [{0,19020004,4}],desc = ""};

get_stage_reward(116,4,5) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 5,need_val = 700,format = 0,reward = [{0,19020004,4},{0,32010151,1}],desc = ""};

get_stage_reward(116,4,6) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 6,need_val = 900,format = 0,reward = [{0,19020004,5},{0,32010151,2}],desc = ""};

get_stage_reward(116,4,7) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 7,need_val = 1100,format = 0,reward = [{0,19020004,5},{0,32010151,3}],desc = ""};

get_stage_reward(116,4,8) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 8,need_val = 1400,format = 0,reward = [{0,19020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,4,9) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 9,need_val = 1800,format = 0,reward = [{0,19020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,4,10) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 10,need_val = 2100,format = 0,reward = [{0,19020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,4,11) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 11,need_val = 2500,format = 0,reward = [{0,19020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,4,12) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 12,need_val = 3000,format = 0,reward = [{0,19020004,10},{0,32010152,2}],desc = ""};

get_stage_reward(116,4,13) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 13,need_val = 3500,format = 0,reward = [{0,19020004,10},{0,32010152,3}],desc = ""};

get_stage_reward(116,4,14) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 14,need_val = 4000,format = 0,reward = [{0,19020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,4,15) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 15,need_val = 4500,format = 0,reward = [{0,19020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,4,16) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 4,reward_id = 16,need_val = 5000,format = 0,reward = [{0,19020004,15},{0,32010153,2}],desc = ""};

get_stage_reward(116,5,1) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 1,need_val = 100,format = 0,reward = [{0,20020004,2}],desc = ""};

get_stage_reward(116,5,2) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 2,need_val = 200,format = 0,reward = [{0,20020004,3}],desc = ""};

get_stage_reward(116,5,3) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 3,need_val = 300,format = 0,reward = [{0,20020004,3}],desc = ""};

get_stage_reward(116,5,4) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 4,need_val = 500,format = 0,reward = [{0,20020004,4}],desc = ""};

get_stage_reward(116,5,5) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 5,need_val = 700,format = 0,reward = [{0,20020004,4},{0,32010151,1}],desc = ""};

get_stage_reward(116,5,6) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 6,need_val = 900,format = 0,reward = [{0,20020004,5},{0,32010151,2}],desc = ""};

get_stage_reward(116,5,7) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 7,need_val = 1100,format = 0,reward = [{0,20020004,5},{0,32010151,3}],desc = ""};

get_stage_reward(116,5,8) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 8,need_val = 1400,format = 0,reward = [{0,20020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,5,9) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 9,need_val = 1800,format = 0,reward = [{0,20020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,5,10) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 10,need_val = 2100,format = 0,reward = [{0,20020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,5,11) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 11,need_val = 2500,format = 0,reward = [{0,20020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,5,12) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 12,need_val = 3000,format = 0,reward = [{0,20020004,10},{0,32010152,2}],desc = ""};

get_stage_reward(116,5,13) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 13,need_val = 3500,format = 0,reward = [{0,20020004,10},{0,32010152,3}],desc = ""};

get_stage_reward(116,5,14) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 14,need_val = 4000,format = 0,reward = [{0,20020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,5,15) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 15,need_val = 4500,format = 0,reward = [{0,20020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,5,16) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 5,reward_id = 16,need_val = 5000,format = 0,reward = [{0,20020004,15},{0,32010153,2}],desc = ""};

get_stage_reward(116,6,1) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 1,need_val = 100,format = 0,reward = [{0,16020004,2}],desc = ""};

get_stage_reward(116,6,2) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 2,need_val = 200,format = 0,reward = [{0,16020004,3}],desc = ""};

get_stage_reward(116,6,3) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 3,need_val = 300,format = 0,reward = [{0,16020004,3}],desc = ""};

get_stage_reward(116,6,4) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 4,need_val = 500,format = 0,reward = [{0,16020004,4}],desc = ""};

get_stage_reward(116,6,5) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 5,need_val = 700,format = 0,reward = [{0,16020004,4},{0,32010151,1}],desc = ""};

get_stage_reward(116,6,6) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 6,need_val = 900,format = 0,reward = [{0,16020004,5},{0,32010151,2}],desc = ""};

get_stage_reward(116,6,7) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 7,need_val = 1100,format = 0,reward = [{0,16020004,5},{0,32010151,3}],desc = ""};

get_stage_reward(116,6,8) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 8,need_val = 1400,format = 0,reward = [{0,16020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,6,9) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 9,need_val = 1800,format = 0,reward = [{0,16020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,6,10) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 10,need_val = 2100,format = 0,reward = [{0,16020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,6,11) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 11,need_val = 2500,format = 0,reward = [{0,16020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,6,12) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 12,need_val = 3000,format = 0,reward = [{0,16020004,10},{0,32010152,2}],desc = ""};

get_stage_reward(116,6,13) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 13,need_val = 3500,format = 0,reward = [{0,16020004,10},{0,32010152,3}],desc = ""};

get_stage_reward(116,6,14) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 14,need_val = 4000,format = 0,reward = [{0,16020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,6,15) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 15,need_val = 4500,format = 0,reward = [{0,16020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,6,16) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 6,reward_id = 16,need_val = 5000,format = 0,reward = [{0,16020004,15},{0,32010153,2}],desc = ""};

get_stage_reward(116,7,1) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 1,need_val = 100,format = 0,reward = [{0,17020004,2}],desc = ""};

get_stage_reward(116,7,2) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 2,need_val = 200,format = 0,reward = [{0,17020004,3}],desc = ""};

get_stage_reward(116,7,3) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 3,need_val = 300,format = 0,reward = [{0,17020004,3}],desc = ""};

get_stage_reward(116,7,4) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 4,need_val = 500,format = 0,reward = [{0,17020004,4}],desc = ""};

get_stage_reward(116,7,5) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 5,need_val = 700,format = 0,reward = [{0,17020004,4},{0,32010151,1}],desc = ""};

get_stage_reward(116,7,6) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 6,need_val = 900,format = 0,reward = [{0,17020004,5},{0,32010151,2}],desc = ""};

get_stage_reward(116,7,7) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 7,need_val = 1100,format = 0,reward = [{0,17020004,5},{0,32010151,3}],desc = ""};

get_stage_reward(116,7,8) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 8,need_val = 1400,format = 0,reward = [{0,17020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,7,9) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 9,need_val = 1800,format = 0,reward = [{0,17020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,7,10) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 10,need_val = 2100,format = 0,reward = [{0,17020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,7,11) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 11,need_val = 2500,format = 0,reward = [{0,17020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,7,12) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 12,need_val = 3000,format = 0,reward = [{0,17020004,10},{0,32010152,2}],desc = ""};

get_stage_reward(116,7,13) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 13,need_val = 3500,format = 0,reward = [{0,17020004,10},{0,32010152,3}],desc = ""};

get_stage_reward(116,7,14) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 14,need_val = 4000,format = 0,reward = [{0,17020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,7,15) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 15,need_val = 4500,format = 0,reward = [{0,17020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,7,16) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 7,reward_id = 16,need_val = 5000,format = 0,reward = [{0,17020004,15},{0,32010153,2}],desc = ""};

get_stage_reward(116,8,1) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 1,need_val = 100,format = 0,reward = [{0,18020004,2}],desc = ""};

get_stage_reward(116,8,2) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 2,need_val = 200,format = 0,reward = [{0,18020004,3}],desc = ""};

get_stage_reward(116,8,3) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 3,need_val = 300,format = 0,reward = [{0,18020004,3}],desc = ""};

get_stage_reward(116,8,4) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 4,need_val = 500,format = 0,reward = [{0,18020004,4}],desc = ""};

get_stage_reward(116,8,5) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 5,need_val = 700,format = 0,reward = [{0,18020004,4},{0,32010151,1}],desc = ""};

get_stage_reward(116,8,6) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 6,need_val = 900,format = 0,reward = [{0,18020004,5},{0,32010151,2}],desc = ""};

get_stage_reward(116,8,7) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 7,need_val = 1100,format = 0,reward = [{0,18020004,5},{0,32010151,3}],desc = ""};

get_stage_reward(116,8,8) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 8,need_val = 1400,format = 0,reward = [{0,18020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,8,9) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 9,need_val = 1800,format = 0,reward = [{0,18020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,8,10) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 10,need_val = 2100,format = 0,reward = [{0,18020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,8,11) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 11,need_val = 2500,format = 0,reward = [{0,18020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,8,12) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 12,need_val = 3000,format = 0,reward = [{0,18020004,10},{0,32010152,2}],desc = ""};

get_stage_reward(116,8,13) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 13,need_val = 3500,format = 0,reward = [{0,18020004,10},{0,32010152,3}],desc = ""};

get_stage_reward(116,8,14) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 14,need_val = 4000,format = 0,reward = [{0,18020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,8,15) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 15,need_val = 4500,format = 0,reward = [{0,18020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,8,16) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 8,reward_id = 16,need_val = 5000,format = 0,reward = [{0,18020004,15},{0,32010153,2}],desc = ""};

get_stage_reward(116,9,1) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 1,need_val = 100,format = 0,reward = [{0,19020004,2}],desc = ""};

get_stage_reward(116,9,2) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 2,need_val = 200,format = 0,reward = [{0,19020004,3}],desc = ""};

get_stage_reward(116,9,3) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 3,need_val = 300,format = 0,reward = [{0,19020004,3}],desc = ""};

get_stage_reward(116,9,4) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 4,need_val = 500,format = 0,reward = [{0,19020004,4}],desc = ""};

get_stage_reward(116,9,5) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 5,need_val = 700,format = 0,reward = [{0,19020004,4},{0,32010151,1}],desc = ""};

get_stage_reward(116,9,6) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 6,need_val = 900,format = 0,reward = [{0,19020004,5},{0,32010151,2}],desc = ""};

get_stage_reward(116,9,7) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 7,need_val = 1100,format = 0,reward = [{0,19020004,5},{0,32010151,3}],desc = ""};

get_stage_reward(116,9,8) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 8,need_val = 1400,format = 0,reward = [{0,19020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,9,9) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 9,need_val = 1800,format = 0,reward = [{0,19020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,9,10) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 10,need_val = 2100,format = 0,reward = [{0,19020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,9,11) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 11,need_val = 2500,format = 0,reward = [{0,19020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,9,12) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 12,need_val = 3000,format = 0,reward = [{0,19020004,10},{0,32010152,2}],desc = ""};

get_stage_reward(116,9,13) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 13,need_val = 3500,format = 0,reward = [{0,19020004,10},{0,32010152,3}],desc = ""};

get_stage_reward(116,9,14) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 14,need_val = 4000,format = 0,reward = [{0,19020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,9,15) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 15,need_val = 4500,format = 0,reward = [{0,19020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,9,16) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 9,reward_id = 16,need_val = 5000,format = 0,reward = [{0,19020004,15},{0,32010153,2}],desc = ""};

get_stage_reward(116,10,1) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 1,need_val = 100,format = 0,reward = [{0,20020004,2}],desc = ""};

get_stage_reward(116,10,2) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 2,need_val = 200,format = 0,reward = [{0,20020004,3}],desc = ""};

get_stage_reward(116,10,3) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 3,need_val = 300,format = 0,reward = [{0,20020004,3}],desc = ""};

get_stage_reward(116,10,4) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 4,need_val = 500,format = 0,reward = [{0,20020004,4}],desc = ""};

get_stage_reward(116,10,5) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 5,need_val = 700,format = 0,reward = [{0,20020004,4},{0,32010151,1}],desc = ""};

get_stage_reward(116,10,6) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 6,need_val = 900,format = 0,reward = [{0,20020004,5},{0,32010151,2}],desc = ""};

get_stage_reward(116,10,7) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 7,need_val = 1100,format = 0,reward = [{0,20020004,5},{0,32010151,3}],desc = ""};

get_stage_reward(116,10,8) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 8,need_val = 1400,format = 0,reward = [{0,20020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,10,9) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 9,need_val = 1800,format = 0,reward = [{0,20020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,10,10) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 10,need_val = 2100,format = 0,reward = [{0,20020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,10,11) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 11,need_val = 2500,format = 0,reward = [{0,20020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,10,12) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 12,need_val = 3000,format = 0,reward = [{0,20020004,10},{0,32010152,2}],desc = ""};

get_stage_reward(116,10,13) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 13,need_val = 3500,format = 0,reward = [{0,20020004,10},{0,32010152,3}],desc = ""};

get_stage_reward(116,10,14) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 14,need_val = 4000,format = 0,reward = [{0,20020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,10,15) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 15,need_val = 4500,format = 0,reward = [{0,20020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,10,16) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 10,reward_id = 16,need_val = 5000,format = 0,reward = [{0,20020004,15},{0,32010153,2}],desc = ""};

get_stage_reward(116,11,1) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 1,need_val = 100,format = 0,reward = [{0,25020004,2}],desc = ""};

get_stage_reward(116,11,2) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 2,need_val = 200,format = 0,reward = [{0,25020004,3}],desc = ""};

get_stage_reward(116,11,3) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 3,need_val = 300,format = 0,reward = [{0,25020004,3}],desc = ""};

get_stage_reward(116,11,4) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 4,need_val = 500,format = 0,reward = [{0,25020004,4}],desc = ""};

get_stage_reward(116,11,5) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 5,need_val = 700,format = 0,reward = [{0,25020004,4},{0,32010151,1}],desc = ""};

get_stage_reward(116,11,6) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 6,need_val = 900,format = 0,reward = [{0,25020004,5},{0,32010151,2}],desc = ""};

get_stage_reward(116,11,7) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 7,need_val = 1100,format = 0,reward = [{0,25020004,5},{0,32010151,3}],desc = ""};

get_stage_reward(116,11,8) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 8,need_val = 1400,format = 0,reward = [{0,25020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,11,9) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 9,need_val = 1800,format = 0,reward = [{0,25020004,6},{0,32010152,1}],desc = ""};

get_stage_reward(116,11,10) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 10,need_val = 2100,format = 0,reward = [{0,25020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,11,11) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 11,need_val = 2500,format = 0,reward = [{0,25020004,8},{0,32010152,2}],desc = ""};

get_stage_reward(116,11,12) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 12,need_val = 3000,format = 0,reward = [{0,25020004,10},{0,32010152,2}],desc = ""};

get_stage_reward(116,11,13) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 13,need_val = 3500,format = 0,reward = [{0,25020004,10},{0,32010152,3}],desc = ""};

get_stage_reward(116,11,14) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 14,need_val = 4000,format = 0,reward = [{0,25020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,11,15) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 15,need_val = 4500,format = 0,reward = [{0,25020004,12},{0,32010152,3}],desc = ""};

get_stage_reward(116,11,16) ->
	#base_rush_treasure_stage_reward{type = 116,sub_type = 11,reward_id = 16,need_val = 5000,format = 0,reward = [{0,25020004,15},{0,32010153,2}],desc = ""};

get_stage_reward(_Type,_Subtype,_Rewardid) ->
	[].

get_stage_reward_all_id(116,1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_stage_reward_all_id(116,2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_stage_reward_all_id(116,3) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_stage_reward_all_id(116,4) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_stage_reward_all_id(116,5) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_stage_reward_all_id(116,6) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_stage_reward_all_id(116,7) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_stage_reward_all_id(116,8) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_stage_reward_all_id(116,9) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_stage_reward_all_id(116,10) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_stage_reward_all_id(116,11) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

get_stage_reward_all_id(_Type,_Subtype) ->
	[].

