%%%---------------------------------------
%%% module      : data_monday_bonus
%%% description : 周一大奖配置
%%%
%%%---------------------------------------
-module(data_monday_bonus).
-compile(export_all).
-include("bonus_monday.hrl").



get_bonus_type(0) ->
	#base_monday_bonus{id = 0,num = 1,display = [1],choose_list = [1,2],weight = 1,tv_id = [{179,1}]};

get_bonus_type(1) ->
	#base_monday_bonus{id = 1,num = 2,display = [3,4],choose_list = [3,4,5,6,7,8],weight = 400,tv_id = [{179,1}]};

get_bonus_type(2) ->
	#base_monday_bonus{id = 2,num = 2,display = [9,10],choose_list = [9,10,11],weight = {1,3,5000,10000, {5000,[4]}},tv_id = []};

get_bonus_type(3) ->
	#base_monday_bonus{id = 3,num = 3,display = [12,13,14],choose_list = [12,13,14],weight = {11,29700,0},tv_id = []};

get_bonus_type(_Id) ->
	[].

get_all_type() ->
[0,1,2,3].


get_value(kf_log_num) ->
30;


get_value(open_lv) ->
160;


get_value(draw_cost) ->
[{0,1102015063,1}];


get_value(draw_time) ->
[{day, [1]},{time, [{{12,0},{23,59}}]}];


get_value(open_day) ->
7;


get_value(before_draw_time) ->
[{day, [1,2,3,4,5,6,7]},{time, [{{12,0},{23,59}}]}];

get_value(_Key) ->
	[].

get_task_info(100) ->
	#base_monday_bonus_task{id = 100,reward = [{0,1102015063,1}],condition = []};

get_task_info(101) ->
	#base_monday_bonus_task{id = 101,reward = [{0,1102015063,1}],condition = []};

get_task_info(102) ->
	#base_monday_bonus_task{id = 102,reward = [{0,1102015063,1}],condition = [{livness, 140}]};

get_task_info(_Id) ->
	[].


get_reward(1) ->
[{0,35,8888}];


get_reward(2) ->
[{0,36255006,35}];


get_reward(3) ->
[{0,35,388}];


get_reward(4) ->
[{0,38030003,4}];


get_reward(5) ->
[{0,32010004,1}];


get_reward(6) ->
[{0,36255006,3}];


get_reward(7) ->
[{0,38160001,2}];


get_reward(8) ->
[{0,38100004,2}];


get_reward(9) ->
[{0,38030003,2}];


get_reward(10) ->
[{0,35,188}];


get_reward(11) ->
[{0,38040027,2}];


get_reward(12) ->
[{0,35,10}];


get_reward(13) ->
[{0,37020001,1}];


get_reward(14) ->
[{0,32010096,1}];

get_reward(_Id) ->
	[].

