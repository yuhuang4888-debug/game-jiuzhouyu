%%%---------------------------------------
%%% module      : data_rush_rank
%%% description : 开服冲榜配置
%%%
%%%---------------------------------------
-module(data_rush_rank).
-compile(export_all).
-include("rush_rank.hrl").



get_rush_rank_cfg(1) ->
	#base_rush_rank{id = 1,name = <<"等级狂人"/utf8>>,start_day = 1,clear_day = 3,max_len = 100,new_limit = [{lv,200}],limit = [{lv,200}],figure_id = 0,scale = 300,angle = 0,open_start_time = 1625500800,open_end_time = 1846512000,open_day_list = [2,3,4,5,6,7,8]};

get_rush_rank_cfg(2) ->
	#base_rush_rank{id = 2,name = <<"坐骑进阶"/utf8>>,start_day = 3,clear_day = 4,max_len = 100,new_limit = [{combat,130000}],limit = [{combat,180000}],figure_id = 0,scale = 180,angle = 0,open_start_time = 1625500800,open_end_time = 1846512000,open_day_list = [4,5,6,7,8]};

get_rush_rank_cfg(3) ->
	#base_rush_rank{id = 3,name = <<"最强侍魂"/utf8>>,start_day = 4,clear_day = 5,max_len = 100,new_limit = [{combat,130000}],limit = [{combat,110000}],figure_id = 0,scale = 100,angle = 0,open_start_time = 1625500800,open_end_time = 1846512000,open_day_list = [5,6,7,8]};

get_rush_rank_cfg(5) ->
	#base_rush_rank{id = 5,name = <<"宝石达人"/utf8>>,start_day = 6,clear_day = 7,max_len = 100,new_limit = [{lv,50}],limit = [{lv,50}],figure_id = 0,scale = 300,angle = 0,open_start_time = 1625500800,open_end_time = 1658419199,open_day_list = [7,8]};

get_rush_rank_cfg(6) ->
	#base_rush_rank{id = 6,name = <<"问鼎天下"/utf8>>,start_day = 7,clear_day = 8,max_len = 100,new_limit = [{combat,3000000}],limit = [{combat,3000000}],figure_id = 0,scale = 100,angle = 0,open_start_time = 1625500800,open_end_time = 1846512000,open_day_list = [8]};

get_rush_rank_cfg(13) ->
	#base_rush_rank{id = 13,name = <<"神纹排行"/utf8>>,start_day = 5,clear_day = 6,max_len = 100,new_limit = [{lv,20}],limit = [{lv,10}],figure_id = 0,scale = 100,angle = 0,open_start_time = 1625500800,open_end_time = 1846512000,open_day_list = [6,7,8]};

get_rush_rank_cfg(14) ->
	#base_rush_rank{id = 14,name = <<"御魂冲榜"/utf8>>,start_day = 6,clear_day = 7,max_len = 100,new_limit = [{combat,230000}],limit = [{combat,230000}],figure_id = 0,scale = 100,angle = 0,open_start_time = 1658419200,open_end_time = 1846512000,open_day_list = []};

get_rush_rank_cfg(_Id) ->
	[].

get_id_list() ->
[1,2,3,5,6,13,14].

get_rank_reward_cfg(1,1) ->
	#base_rush_rank_reward{id = 1,reward_id = 1,rank_min = 1,rank_max = 1,new_limit_val = 200,limit_val = 200,reward = [{1,[{0,101046074,1},{0,16010003,1},{0,16020001,40},{0,38065007,1}]},{2,[{0,102046074,1},{0,16010003,1},{0,16020001,40},{0,38065007,1}]},{3,[{0,101046074,1},{0,16010003,1},{0,16020001,40},{0,38065007,1}]},{4,[{0,102046074,1},{0,16010003,1},{0,16020001,40},{0,38065007,1}]}]};

get_rank_reward_cfg(1,2) ->
	#base_rush_rank_reward{id = 1,reward_id = 2,rank_min = 2,rank_max = 2,new_limit_val = 200,limit_val = 200,reward = [{1,[{0,101045073,1},{0,16010003,1},{0,16020001,35},{0,38065007,1}]},{2,[{0,102045073,1},{0,16010003,1},{0,16020001,35},{0,38065007,1}]},{3,[{0,101045073,1},{0,16010003,1},{0,16020001,35},{0,38065007,1}]},{4,[{0,102045073,1},{0,16010003,1},{0,16020001,35},{0,38065007,1}]}]};

get_rank_reward_cfg(1,3) ->
	#base_rush_rank_reward{id = 1,reward_id = 3,rank_min = 3,rank_max = 3,new_limit_val = 200,limit_val = 200,reward = [{1,[{0,101045073,1},{0,16010003,1},{0,16020001,30},{0,38065007,1}]},{2,[{0,102045073,1},{0,16010003,1},{0,16020001,30},{0,38065007,1}]},{3,[{0,101045073,1},{0,16010003,1},{0,16020001,30},{0,38065007,1}]},{4,[{0,102045073,1},{0,16010003,1},{0,16020001,30},{0,38065007,1}]}]};

get_rank_reward_cfg(1,4) ->
	#base_rush_rank_reward{id = 1,reward_id = 4,rank_min = 4,rank_max = 10,new_limit_val = 200,limit_val = 200,reward = [{1,[{0,101045072,1},{0,16010003,1},{0,16020001,20}]},{2,[{0,102045072,1},{0,16010003,1},{0,16020001,20}]},{3,[{0,101045072,1},{0,16010003,1},{0,16020001,20}]},{4,[{0,102045072,1},{0,16010003,1},{0,16020001,20}]}]};

get_rank_reward_cfg(1,5) ->
	#base_rush_rank_reward{id = 1,reward_id = 5,rank_min = 11,rank_max = 20,new_limit_val = 200,limit_val = 200,reward = [{1,[{0,101045062,1},{0,16010002,1},{0,16020001,15}]},{2,[{0,102045062,1},{0,16010002,1},{0,16020001,15}]},{3,[{0,101045062,1},{0,16010002,1},{0,16020001,15}]},{4,[{0,102045062,1},{0,16010002,1},{0,16020001,15}]}]};

get_rank_reward_cfg(1,6) ->
	#base_rush_rank_reward{id = 1,reward_id = 6,rank_min = 21,rank_max = 50,new_limit_val = 200,limit_val = 200,reward = [{1,[{0,101045062,1},{0,16010002,1},{0,16020001,12}]},{2,[{0,102045062,1},{0,16010002,1},{0,16020001,12}]},{3,[{0,101045062,1},{0,16010002,1},{0,16020001,12}]},{4,[{0,102045062,1},{0,16010002,1},{0,16020001,12}]}]};

get_rank_reward_cfg(1,7) ->
	#base_rush_rank_reward{id = 1,reward_id = 7,rank_min = 51,rank_max = 100,new_limit_val = 200,limit_val = 200,reward = [{1,[{0,101045062,1},{0,16010001,1},{0,16020001,10}]},{2,[{0,102045062,1},{0,16010002,1},{0,16020001,10}]},{3,[{0,101045062,1},{0,16010002,1},{0,16020001,10}]},{4,[{0,102045062,1},{0,16010002,1},{0,16020001,10}]}]};

get_rank_reward_cfg(2,1) ->
	#base_rush_rank_reward{id = 2,reward_id = 1,rank_min = 1,rank_max = 1,new_limit_val = 280000,limit_val = 180000,reward = [{1,[{0,101066074,1},{0,17010003,1},{0,17020001,40},{0,38065001,1}]},{2,[{0,102066074,1},{0,17010003,1},{0,17020001,40},{0,38065001,1}]},{3,[{0,101066074,1},{0,17010003,1},{0,17020001,40},{0,38065001,1}]},{4,[{0,102066074,1},{0,17010003,1},{0,17020001,40},{0,38065001,1}]}]};

get_rank_reward_cfg(2,2) ->
	#base_rush_rank_reward{id = 2,reward_id = 2,rank_min = 2,rank_max = 2,new_limit_val = 270000,limit_val = 180000,reward = [{1,[{0,101065073,1},{0,17010003,1},{0,17020001,35},{0,38065001,1}]},{2,[{0,102065073,1},{0,17010003,1},{0,17020001,35},{0,38065001,1}]},{3,[{0,101065073,1},{0,17010003,1},{0,17020001,35},{0,38065001,1}]},{4,[{0,102065073,1},{0,17010003,1},{0,17020001,35},{0,38065001,1}]}]};

get_rank_reward_cfg(2,3) ->
	#base_rush_rank_reward{id = 2,reward_id = 3,rank_min = 3,rank_max = 3,new_limit_val = 260000,limit_val = 180000,reward = [{1,[{0,101065073,1},{0,17010003,1},{0,17020001,30},{0,38065001,1}]},{2,[{0,102065073,1},{0,17010003,1},{0,17020001,30},{0,38065001,1}]},{3,[{0,101065073,1},{0,17010003,1},{0,17020001,30},{0,38065001,1}]},{4,[{0,102065073,1},{0,17010003,1},{0,17020001,30},{0,38065001,1}]}]};

get_rank_reward_cfg(2,4) ->
	#base_rush_rank_reward{id = 2,reward_id = 4,rank_min = 4,rank_max = 10,new_limit_val = 220000,limit_val = 180000,reward = [{1,[{0,101065072,1},{0,17010003,1},{0,17020001,20}]},{2,[{0,102065072,1},{0,17010003,1},{0,17020001,20}]},{3,[{0,101065072,1},{0,17010003,1},{0,17020001,20}]},{4,[{0,102065072,1},{0,17010003,1},{0,17020001,20}]}]};

get_rank_reward_cfg(2,5) ->
	#base_rush_rank_reward{id = 2,reward_id = 5,rank_min = 11,rank_max = 20,new_limit_val = 180000,limit_val = 180000,reward = [{1,[{0,101065072,1},{0,17010002,2},{0,17020001,15}]},{2,[{0,102065072,1},{0,17010002,2},{0,17020001,15}]},{3,[{0,101065072,1},{0,17010002,2},{0,17020001,15}]},{4,[{0,102065072,1},{0,17010002,2},{0,17020001,15}]}]};

get_rank_reward_cfg(2,6) ->
	#base_rush_rank_reward{id = 2,reward_id = 6,rank_min = 21,rank_max = 50,new_limit_val = 160000,limit_val = 180000,reward = [{1,[{0,101065062,1},{0,17010002,2},{0,17020001,12}]},{2,[{0,102065062,1},{0,17010002,2},{0,17020001,12}]},{3,[{0,101065062,1},{0,17010002,2},{0,17020001,12}]},{4,[{0,102065062,1},{0,17010002,2},{0,17020001,12}]}]};

get_rank_reward_cfg(2,7) ->
	#base_rush_rank_reward{id = 2,reward_id = 7,rank_min = 51,rank_max = 100,new_limit_val = 130000,limit_val = 180000,reward = [{1,[{0,101065062,1},{0,17010001,1},{0,17020001,10}]},{2,[{0,102065062,1},{0,17010001,1},{0,17020001,10}]},{3,[{0,101065062,1},{0,17010001,1},{0,17020001,10}]},{4,[{0,102065062,1},{0,17010001,1},{0,17020001,10}]}]};

get_rank_reward_cfg(3,1) ->
	#base_rush_rank_reward{id = 3,reward_id = 1,rank_min = 1,rank_max = 1,new_limit_val = 230000,limit_val = 110000,reward = [{1,[{0,101026074,1},{0,18010003,1},{0,18020001,40},{0,38065005,1}]},{2,[{0,102026074,1},{0,18010003,1},{0,18020001,40},{0,38065005,1}]},{3,[{0,101026074,1},{0,18010003,1},{0,18020001,40},{0,38065005,1}]},{4,[{0,102026074,1},{0,18010003,1},{0,18020001,40},{0,38065005,1}]}]};

get_rank_reward_cfg(3,2) ->
	#base_rush_rank_reward{id = 3,reward_id = 2,rank_min = 2,rank_max = 2,new_limit_val = 220000,limit_val = 110000,reward = [{1,[{0,101025073,1},{0,18010003,1},{0,18020001,35},{0,38065005,1}]},{2,[{0,102025073,1},{0,18010003,1},{0,18020001,35},{0,38065005,1}]},{3,[{0,101025073,1},{0,18010003,1},{0,18020001,35},{0,38065005,1}]},{4,[{0,102025073,1},{0,18010003,1},{0,18020001,35},{0,38065005,1}]}]};

get_rank_reward_cfg(3,3) ->
	#base_rush_rank_reward{id = 3,reward_id = 3,rank_min = 3,rank_max = 3,new_limit_val = 210000,limit_val = 110000,reward = [{1,[{0,101025073,1},{0,18010003,1},{0,18020001,30},{0,38065005,1}]},{2,[{0,102025073,1},{0,18010003,1},{0,18020001,30},{0,38065005,1}]},{3,[{0,101025073,1},{0,18010003,1},{0,18020001,30},{0,38065005,1}]},{4,[{0,102025073,1},{0,18010003,1},{0,18020001,30},{0,38065005,1}]}]};

get_rank_reward_cfg(3,4) ->
	#base_rush_rank_reward{id = 3,reward_id = 4,rank_min = 4,rank_max = 10,new_limit_val = 190000,limit_val = 110000,reward = [{1,[{0,101025072,1},{0,18010003,1},{0,18020001,20}]},{2,[{0,102025072,1},{0,18010003,1},{0,18020001,20}]},{3,[{0,101025072,1},{0,18010003,1},{0,18020001,20}]},{4,[{0,102025072,1},{0,18010003,1},{0,18020001,20}]}]};

get_rank_reward_cfg(3,5) ->
	#base_rush_rank_reward{id = 3,reward_id = 5,rank_min = 11,rank_max = 20,new_limit_val = 170000,limit_val = 110000,reward = [{1,[{0,101025072,1},{0,18010002,2},{0,18020001,15}]},{2,[{0,102025072,1},{0,18010002,2},{0,18020001,15}]},{3,[{0,101025072,1},{0,18010002,2},{0,18020001,15}]},{4,[{0,102025072,1},{0,18010002,2},{0,18020001,15}]}]};

get_rank_reward_cfg(3,6) ->
	#base_rush_rank_reward{id = 3,reward_id = 6,rank_min = 21,rank_max = 50,new_limit_val = 150000,limit_val = 110000,reward = [{1,[{0,101025062,1},{0,18010002,2},{0,18020001,12}]},{2,[{0,102025062,1},{0,18010002,2},{0,18020001,12}]},{3,[{0,101025062,1},{0,18010002,2},{0,18020001,12}]},{4,[{0,102025062,1},{0,18010002,2},{0,18020001,12}]}]};

get_rank_reward_cfg(3,7) ->
	#base_rush_rank_reward{id = 3,reward_id = 7,rank_min = 51,rank_max = 100,new_limit_val = 130000,limit_val = 110000,reward = [{1,[{0,101025062,1},{0,18010001,1},{0,18020001,10}]},{2,[{0,102025062,1},{0,18010001,1},{0,18020001,10}]},{3,[{0,101025062,1},{0,18010001,1},{0,18020001,10}]},{4,[{0,102025062,1},{0,18010001,1},{0,18020001,10}]}]};

get_rank_reward_cfg(4,1) ->
	#base_rush_rank_reward{id = 4,reward_id = 1,rank_min = 1,rank_max = 1,new_limit_val = 30,limit_val = 30,reward = [{1,[{0,101106074,1},{0,19010003,1},{0,14010004,1},{0,38065006,1}]},{2,[{0,102106074,1},{0,19010003,1},{0,14010004,1},{0,38065006,1}]},{3,[{0,101106074,1},{0,19010003,1},{0,14010004,1},{0,38065006,1}]},{4,[{0,102106074,1},{0,19010003,1},{0,14010004,1},{0,38065006,1}]}]};

get_rank_reward_cfg(4,2) ->
	#base_rush_rank_reward{id = 4,reward_id = 2,rank_min = 2,rank_max = 2,new_limit_val = 30,limit_val = 30,reward = [{1,[{0,101105073,1},{0,19010003,1},{0,14010003,2},{0,38065006,1}]},{2,[{0,102105073,1},{0,19010003,1},{0,14010003,2},{0,38065006,1}]},{3,[{0,101105073,1},{0,19010003,1},{0,14010003,2},{0,38065006,1}]},{4,[{0,102105073,1},{0,19010003,1},{0,14010003,2},{0,38065006,1}]}]};

get_rank_reward_cfg(4,3) ->
	#base_rush_rank_reward{id = 4,reward_id = 3,rank_min = 3,rank_max = 3,new_limit_val = 30,limit_val = 30,reward = [{1,[{0,101105073,1},{0,19010003,1},{0,14010003,2},{0,38065006,1}]},{2,[{0,102105073,1},{0,19010003,1},{0,14010003,2},{0,38065006,1}]},{3,[{0,101105073,1},{0,19010003,1},{0,14010003,2},{0,38065006,1}]},{4,[{0,102105073,1},{0,19010003,1},{0,14010003,2},{0,38065006,1}]}]};

get_rank_reward_cfg(4,4) ->
	#base_rush_rank_reward{id = 4,reward_id = 4,rank_min = 4,rank_max = 10,new_limit_val = 30,limit_val = 30,reward = [{1,[{0,101105072,1},{0,19010003,1},{0,14010003,1}]},{2,[{0,102105072,1},{0,19010003,1},{0,14010003,1}]},{3,[{0,101105072,1},{0,19010003,1},{0,14010003,1}]},{4,[{0,102105072,1},{0,19010003,1},{0,14010003,1}]}]};

get_rank_reward_cfg(4,5) ->
	#base_rush_rank_reward{id = 4,reward_id = 5,rank_min = 11,rank_max = 20,new_limit_val = 30,limit_val = 30,reward = [{1,[{0,101105072,1},{0,19010002,2},{0,14010003,2}]},{2,[{0,102105072,1},{0,19010002,2},{0,14010003,2}]},{3,[{0,101105072,1},{0,19010002,2},{0,14010003,2}]},{4,[{0,102105072,1},{0,19010002,2},{0,14010003,2}]}]};

get_rank_reward_cfg(4,6) ->
	#base_rush_rank_reward{id = 4,reward_id = 6,rank_min = 21,rank_max = 50,new_limit_val = 30,limit_val = 30,reward = [{1,[{0,101105062,1},{0,19010002,2},{0,14010003,1}]},{2,[{0,102105062,1},{0,19010002,2},{0,14010003,1}]},{3,[{0,101105062,1},{0,19010002,2},{0,14010003,1}]},{4,[{0,102105062,1},{0,19010002,2},{0,14010003,1}]}]};

get_rank_reward_cfg(4,7) ->
	#base_rush_rank_reward{id = 4,reward_id = 7,rank_min = 51,rank_max = 100,new_limit_val = 30,limit_val = 30,reward = [{1,[{0,101105062,1},{0,19010001,1},{0,14010003,1}]},{2,[{0,102105062,1},{0,19010001,1},{0,14010003,1}]},{3,[{0,101105062,1},{0,19010001,1},{0,14010003,1}]},{4,[{0,102105062,1},{0,19010001,1},{0,14010003,1}]}]};

get_rank_reward_cfg(5,1) ->
	#base_rush_rank_reward{id = 5,reward_id = 1,rank_min = 1,rank_max = 1,new_limit_val = 50,limit_val = 50,reward = [{1,[{0,101086074,1},{0,20010003,1},{0,20020001,40},{0,38065004,1}]},{2,[{0,102086074,1},{0,20010003,1},{0,20020001,40},{0,38065004,1}]},{3,[{0,101086074,1},{0,20010003,1},{0,20020001,40},{0,38065004,1}]},{4,[{0,102086074,1},{0,20010003,1},{0,20020001,40},{0,38065004,1}]}]};

get_rank_reward_cfg(5,2) ->
	#base_rush_rank_reward{id = 5,reward_id = 2,rank_min = 2,rank_max = 2,new_limit_val = 50,limit_val = 50,reward = [{1,[{0,101085073,1},{0,20010003,1},{0,20020001,35},{0,38065004,1}]},{2,[{0,102085073,1},{0,20010003,1},{0,20020001,35},{0,38065004,1}]},{3,[{0,101085073,1},{0,20010003,1},{0,20020001,35},{0,38065004,1}]},{4,[{0,102085073,1},{0,20010003,1},{0,20020001,35},{0,38065004,1}]}]};

get_rank_reward_cfg(5,3) ->
	#base_rush_rank_reward{id = 5,reward_id = 3,rank_min = 3,rank_max = 3,new_limit_val = 50,limit_val = 50,reward = [{1,[{0,101085073,1},{0,20010003,1},{0,20020001,30},{0,38065004,1}]},{2,[{0,102085073,1},{0,20010003,1},{0,20020001,30},{0,38065004,1}]},{3,[{0,101085073,1},{0,20010003,1},{0,20020001,30},{0,38065004,1}]},{4,[{0,102085073,1},{0,20010003,1},{0,20020001,30},{0,38065004,1}]}]};

get_rank_reward_cfg(5,4) ->
	#base_rush_rank_reward{id = 5,reward_id = 4,rank_min = 4,rank_max = 10,new_limit_val = 50,limit_val = 50,reward = [{1,[{0,101085072,1},{0,20010003,1},{0,20020001,20}]},{2,[{0,102085072,1},{0,20010003,1},{0,20020001,20}]},{3,[{0,101085072,1},{0,20010003,1},{0,20020001,20}]},{4,[{0,102085072,1},{0,20010003,1},{0,20020001,20}]}]};

get_rank_reward_cfg(5,5) ->
	#base_rush_rank_reward{id = 5,reward_id = 5,rank_min = 11,rank_max = 20,new_limit_val = 50,limit_val = 50,reward = [{1,[{0,101085072,1},{0,20010003,2},{0,20020001,15}]},{2,[{0,102085072,1},{0,20010003,2},{0,20020001,15}]},{3,[{0,101085072,1},{0,20010003,2},{0,20020001,15}]},{4,[{0,102085072,1},{0,20010003,2},{0,20020001,15}]}]};

get_rank_reward_cfg(5,6) ->
	#base_rush_rank_reward{id = 5,reward_id = 6,rank_min = 21,rank_max = 50,new_limit_val = 50,limit_val = 50,reward = [{1,[{0,101085062,1},{0,20010002,2},{0,20020001,12}]},{2,[{0,102085062,1},{0,20010002,2},{0,20020001,12}]},{3,[{0,101085062,1},{0,20010002,2},{0,20020001,12}]},{4,[{0,102085062,1},{0,20010002,2},{0,20020001,12}]}]};

get_rank_reward_cfg(5,7) ->
	#base_rush_rank_reward{id = 5,reward_id = 7,rank_min = 51,rank_max = 100,new_limit_val = 50,limit_val = 50,reward = [{1,[{0,101085062,1},{0,20010001,1},{0,20020001,10}]},{2,[{0,102085062,1},{0,20010001,1},{0,20020001,10}]},{3,[{0,101085062,1},{0,20010001,1},{0,20020001,10}]},{4,[{0,102085062,1},{0,20010001,1},{0,20020001,10}]}]};

get_rank_reward_cfg(6,1) ->
	#base_rush_rank_reward{id = 6,reward_id = 1,rank_min = 1,rank_max = 1,new_limit_val = 3000000,limit_val = 3000000,reward = [{1,[{0,101016074,1},{100,38240201,12},{100,32010569,20},{0,38065003,1}]},{2,[{0,102016074,1},{100,38240201,12},{100,32010569,20},{0,38065003,1}]},{3,[{0,103016074,1},{100,38240201,12},{100,32010569,20},{0,38065003,1}]},{4,[{0,104016074,1},{100,38240201,12},{100,32010569,20},{0,38065003,1}]}]};

get_rank_reward_cfg(6,2) ->
	#base_rush_rank_reward{id = 6,reward_id = 2,rank_min = 2,rank_max = 2,new_limit_val = 3000000,limit_val = 3000000,reward = [{1,[{0,101015073,1},{100,38240201,10},{100,32010569,18},{0,38065003,1}]},{2,[{0,102015073,1},{100,38240201,10},{100,32010569,18},{0,38065003,1}]},{3,[{0,103015073,1},{100,38240201,10},{100,32010569,18},{0,38065003,1}]},{4,[{0,104015073,1},{100,38240201,10},{100,32010569,18},{0,38065003,1}]}]};

get_rank_reward_cfg(6,3) ->
	#base_rush_rank_reward{id = 6,reward_id = 3,rank_min = 3,rank_max = 3,new_limit_val = 3000000,limit_val = 3000000,reward = [{1,[{0,101015073,1},{100,38240201,10},{100,32010569,16},{0,38065003,1}]},{2,[{0,102015073,1},{100,38240201,10},{100,32010569,16},{0,38065003,1}]},{3,[{0,103015073,1},{100,38240201,10},{100,32010569,16},{0,38065003,1}]},{4,[{0,104015073,1},{100,38240201,10},{100,32010569,16},{0,38065003,1}]}]};

get_rank_reward_cfg(6,4) ->
	#base_rush_rank_reward{id = 6,reward_id = 4,rank_min = 4,rank_max = 10,new_limit_val = 3000000,limit_val = 3000000,reward = [{1,[{0,101015072,1},{100,38240201,8},{100,32010569,15}]},{2,[{0,102015072,1},{100,38240201,8},{100,32010569,15}]},{3,[{0,103015072,1},{100,38240201,8},{100,32010569,15}]},{4,[{0,104015072,1},{100,38240201,8},{100,32010569,15}]}]};

get_rank_reward_cfg(6,5) ->
	#base_rush_rank_reward{id = 6,reward_id = 5,rank_min = 11,rank_max = 20,new_limit_val = 3000000,limit_val = 3000000,reward = [{1,[{0,101015072,1},{100,38240201,7},{100,32010569,12}]},{2,[{0,102015072,1},{100,38240201,7},{100,32010569,12}]},{3,[{0,103015072,1},{100,38240201,7},{100,32010569,12}]},{4,[{0,104015072,1},{100,38240201,7},{100,32010569,12}]}]};

get_rank_reward_cfg(6,6) ->
	#base_rush_rank_reward{id = 6,reward_id = 6,rank_min = 21,rank_max = 50,new_limit_val = 3000000,limit_val = 3000000,reward = [{1,[{0,101015062,1},{100,38240201,6},{100,32010569,10}]},{2,[{0,102015062,1},{100,38240201,6},{100,32010569,10}]},{3,[{0,103015062,1},{100,38240201,6},{100,32010569,10}]},{4,[{0,104015062,1},{100,38240201,6},{100,32010569,10}]}]};

get_rank_reward_cfg(6,7) ->
	#base_rush_rank_reward{id = 6,reward_id = 7,rank_min = 51,rank_max = 100,new_limit_val = 3000000,limit_val = 3000000,reward = [{1,[{0,101015062,1},{100,38240201,5},{100,32010569,8}]},{2,[{0,102015062,1},{100,38240201,5},{100,32010569,8}]},{3,[{0,103015062,1},{100,38240201,5},{100,32010569,8}]},{4,[{0,104015062,1},{100,38240201,5},{100,32010569,8}]}]};

get_rank_reward_cfg(7,1) ->
	#base_rush_rank_reward{id = 7,reward_id = 1,rank_min = 1,rank_max = 1,new_limit_val = 10,limit_val = 10,reward = [{1,[{0,101086073,1},{0,38065006,1},{0,19010003,1},{0,22020001,150}]},{2,[{0,102086073,1},{0,38065006,1},{0,19010003,1},{0,22020001,150}]},{3,[{0,101086073,1},{0,38065006,1},{0,19010003,1},{0,22020001,150}]},{4,[{0,102086073,1},{0,38065006,1},{0,19010003,1},{0,22020001,150}]}]};

get_rank_reward_cfg(7,2) ->
	#base_rush_rank_reward{id = 7,reward_id = 2,rank_min = 2,rank_max = 3,new_limit_val = 10,limit_val = 10,reward = [{1,[{0,101085073,1},{0,38065006,1},{0,19010003,1},{0,22020001,120}]},{2,[{0,102085073,1},{0,38065006,1},{0,19010003,1},{0,22020001,120}]},{3,[{0,101085073,1},{0,38065006,1},{0,19010003,1},{0,22020001,120}]},{4,[{0,102085073,1},{0,38065006,1},{0,19010003,1},{0,22020001,120}]}]};

get_rank_reward_cfg(7,3) ->
	#base_rush_rank_reward{id = 7,reward_id = 3,rank_min = 4,rank_max = 20,new_limit_val = 10,limit_val = 10,reward = [{1,[{0,101085072,1},{0,19010002,1},{0,22020001,90}]},{2,[{0,102085072,1},{0,19010002,1},{0,22020001,90}]},{3,[{0,101085072,1},{0,19010002,1},{0,22020001,90}]},{4,[{0,102085072,1},{0,19010002,1},{0,22020001,90}]}]};

get_rank_reward_cfg(7,4) ->
	#base_rush_rank_reward{id = 7,reward_id = 4,rank_min = 21,rank_max = 100,new_limit_val = 10,limit_val = 10,reward = [{1,[{0,101085062,1},{0,19010002,1},{0,22020001,60}]},{2,[{0,102085062,1},{0,19010002,1},{0,22020001,60}]},{3,[{0,101085062,1},{0,19010002,1},{0,22020001,60}]},{4,[{0,102085062,1},{0,19010002,1},{0,22020001,60}]}]};

get_rank_reward_cfg(13,1) ->
	#base_rush_rank_reward{id = 13,reward_id = 1,rank_min = 1,rank_max = 1,new_limit_val = 60,limit_val = 40,reward = [{1,[{0,101106074,1},{0,19010003,1},{0,26990005,3},{0,38065002,1}]},{2,[{0,102106074,1},{0,19010003,1},{0,26990005,3},{0,38065002,1}]},{3,[{0,101106074,1},{0,19010003,1},{0,26990005,3},{0,38065002,1}]},{4,[{0,102106074,1},{0,19010003,1},{0,26990005,3},{0,38065002,1}]}]};

get_rank_reward_cfg(13,2) ->
	#base_rush_rank_reward{id = 13,reward_id = 2,rank_min = 2,rank_max = 2,new_limit_val = 60,limit_val = 35,reward = [{1,[{0,101105073,1},{0,19010003,1},{0,26990004,3},{0,38065002,1}]},{2,[{0,102105073,1},{0,19010003,1},{0,26990004,3},{0,38065002,1}]},{3,[{0,101105073,1},{0,19010003,1},{0,26990004,3},{0,38065002,1}]},{4,[{0,102105073,1},{0,19010003,1},{0,26990004,3},{0,38065002,1}]}]};

get_rank_reward_cfg(13,3) ->
	#base_rush_rank_reward{id = 13,reward_id = 3,rank_min = 3,rank_max = 3,new_limit_val = 50,limit_val = 30,reward = [{1,[{0,101105073,1},{0,19010003,1},{0,26990004,3},{0,38065002,1}]},{2,[{0,102105073,1},{0,19010003,1},{0,26990004,3},{0,38065002,1}]},{3,[{0,101105073,1},{0,19010003,1},{0,26990004,3},{0,38065002,1}]},{4,[{0,102105073,1},{0,19010003,1},{0,26990004,3},{0,38065002,1}]}]};

get_rank_reward_cfg(13,4) ->
	#base_rush_rank_reward{id = 13,reward_id = 4,rank_min = 4,rank_max = 10,new_limit_val = 30,limit_val = 25,reward = [{1,[{0,101105072,1},{0,19010003,1},{0,26990004,2}]},{2,[{0,102105072,1},{0,19010003,1},{0,26990004,2}]},{3,[{0,101105072,1},{0,19010003,1},{0,26990004,2}]},{4,[{0,102105072,1},{0,19010003,1},{0,26990004,2}]}]};

get_rank_reward_cfg(13,5) ->
	#base_rush_rank_reward{id = 13,reward_id = 5,rank_min = 11,rank_max = 20,new_limit_val = 25,limit_val = 20,reward = [{1,[{0,101105072,1},{0,19010002,2},{0,26990004,1}]},{2,[{0,102105072,1},{0,19010002,2},{0,26990004,1}]},{3,[{0,101105072,1},{0,19010002,2},{0,26990004,1}]},{4,[{0,102105072,1},{0,19010002,2},{0,26990004,1}]}]};

get_rank_reward_cfg(13,6) ->
	#base_rush_rank_reward{id = 13,reward_id = 6,rank_min = 21,rank_max = 50,new_limit_val = 20,limit_val = 10,reward = [{1,[{0,101105062,1},{0,19010002,2},{0,26990003,2}]},{2,[{0,102105062,1},{0,19010002,2},{0,26990003,2}]},{3,[{0,101105062,1},{0,19010002,2},{0,26990003,2}]},{4,[{0,102105062,1},{0,19010002,2},{0,26990003,2}]}]};

get_rank_reward_cfg(13,7) ->
	#base_rush_rank_reward{id = 13,reward_id = 7,rank_min = 51,rank_max = 100,new_limit_val = 20,limit_val = 10,reward = [{1,[{0,101105062,1},{0,19010001,1},{0,26990003,2}]},{2,[{0,102105062,1},{0,19010001,1},{0,26990003,2}]},{3,[{0,101105062,1},{0,19010001,1},{0,26990003,2}]},{4,[{0,102105062,1},{0,19010001,1},{0,26990003,2}]}]};

get_rank_reward_cfg(14,1) ->
	#base_rush_rank_reward{id = 14,reward_id = 1,rank_min = 1,rank_max = 1,new_limit_val = 350000,limit_val = 350000,reward = [{1,[{0,101086074,1},{0,20010003,1},{0,20020001,40},{0,38065409,1}]},{2,[{0,102086074,1},{0,20010003,1},{0,20020001,40},{0,38065409,1}]},{3,[{0,101086074,1},{0,20010003,1},{0,20020001,40},{0,38065409,1}]},{4,[{0,102086074,1},{0,20010003,1},{0,20020001,40},{0,38065409,1}]}]};

get_rank_reward_cfg(14,2) ->
	#base_rush_rank_reward{id = 14,reward_id = 2,rank_min = 2,rank_max = 2,new_limit_val = 330000,limit_val = 330000,reward = [{1,[{0,101085073,1},{0,20010003,1},{0,20020001,35},{0,38065409,1}]},{2,[{0,102085073,1},{0,20010003,1},{0,20020001,35},{0,38065409,1}]},{3,[{0,101085073,1},{0,20010003,1},{0,20020001,35},{0,38065409,1}]},{4,[{0,102085073,1},{0,20010003,1},{0,20020001,35},{0,38065409,1}]}]};

get_rank_reward_cfg(14,3) ->
	#base_rush_rank_reward{id = 14,reward_id = 3,rank_min = 3,rank_max = 3,new_limit_val = 300000,limit_val = 300000,reward = [{1,[{0,101085073,1},{0,20010003,1},{0,20020001,30},{0,38065409,1}]},{2,[{0,102085073,1},{0,20010003,1},{0,20020001,30},{0,38065409,1}]},{3,[{0,101085073,1},{0,20010003,1},{0,20020001,30},{0,38065409,1}]},{4,[{0,102085073,1},{0,20010003,1},{0,20020001,30},{0,38065409,1}]}]};

get_rank_reward_cfg(14,4) ->
	#base_rush_rank_reward{id = 14,reward_id = 4,rank_min = 4,rank_max = 10,new_limit_val = 290000,limit_val = 290000,reward = [{1,[{0,101085072,1},{0,20010003,1},{0,20020001,20}]},{2,[{0,102085072,1},{0,20010003,1},{0,20020001,20}]},{3,[{0,101085072,1},{0,20010003,1},{0,20020001,20}]},{4,[{0,102085072,1},{0,20010003,1},{0,20020001,20}]}]};

get_rank_reward_cfg(14,5) ->
	#base_rush_rank_reward{id = 14,reward_id = 5,rank_min = 11,rank_max = 20,new_limit_val = 270000,limit_val = 270000,reward = [{1,[{0,101085072,1},{0,20010003,2},{0,20020001,15}]},{2,[{0,102085072,1},{0,20010003,2},{0,20020001,15}]},{3,[{0,101085072,1},{0,20010003,2},{0,20020001,15}]},{4,[{0,102085072,1},{0,20010003,2},{0,20020001,15}]}]};

get_rank_reward_cfg(14,6) ->
	#base_rush_rank_reward{id = 14,reward_id = 6,rank_min = 21,rank_max = 50,new_limit_val = 250000,limit_val = 250000,reward = [{1,[{0,101085062,1},{0,20010002,2},{0,20020001,12}]},{2,[{0,102085062,1},{0,20010002,2},{0,20020001,12}]},{3,[{0,101085062,1},{0,20010002,2},{0,20020001,12}]},{4,[{0,102085062,1},{0,20010002,2},{0,20020001,12}]}]};

get_rank_reward_cfg(14,7) ->
	#base_rush_rank_reward{id = 14,reward_id = 7,rank_min = 51,rank_max = 100,new_limit_val = 230000,limit_val = 230000,reward = [{1,[{0,101085062,1},{0,20010001,1},{0,20020001,10}]},{2,[{0,102085062,1},{0,20010001,1},{0,20020001,10}]},{3,[{0,101085062,1},{0,20010001,1},{0,20020001,10}]},{4,[{0,102085062,1},{0,20010001,1},{0,20020001,10}]}]};

get_rank_reward_cfg(_Id,_Rewardid) ->
	[].


get_rank_reward_ids(1) ->
[1,2,3,4,5,6,7];


get_rank_reward_ids(2) ->
[1,2,3,4,5,6,7];


get_rank_reward_ids(3) ->
[1,2,3,4,5,6,7];


get_rank_reward_ids(4) ->
[1,2,3,4,5,6,7];


get_rank_reward_ids(5) ->
[1,2,3,4,5,6,7];


get_rank_reward_ids(6) ->
[1,2,3,4,5,6,7];


get_rank_reward_ids(7) ->
[1,2,3,4];


get_rank_reward_ids(13) ->
[1,2,3,4,5,6,7];


get_rank_reward_ids(14) ->
[1,2,3,4,5,6,7];

get_rank_reward_ids(_Id) ->
	[].

get_highest_rank(1,Value) when Value >= 200 ->
		1;
get_highest_rank(1,Value) when Value >= 200 ->
		2;
get_highest_rank(1,Value) when Value >= 200 ->
		3;
get_highest_rank(1,Value) when Value >= 200 ->
		4;
get_highest_rank(1,Value) when Value >= 200 ->
		11;
get_highest_rank(1,Value) when Value >= 200 ->
		21;
get_highest_rank(1,Value) when Value >= 200 ->
		51;
get_highest_rank(2,Value) when Value >= 180000 ->
		1;
get_highest_rank(2,Value) when Value >= 180000 ->
		2;
get_highest_rank(2,Value) when Value >= 180000 ->
		3;
get_highest_rank(2,Value) when Value >= 180000 ->
		4;
get_highest_rank(2,Value) when Value >= 180000 ->
		11;
get_highest_rank(2,Value) when Value >= 180000 ->
		21;
get_highest_rank(2,Value) when Value >= 180000 ->
		51;
get_highest_rank(3,Value) when Value >= 110000 ->
		1;
get_highest_rank(3,Value) when Value >= 110000 ->
		2;
get_highest_rank(3,Value) when Value >= 110000 ->
		3;
get_highest_rank(3,Value) when Value >= 110000 ->
		4;
get_highest_rank(3,Value) when Value >= 110000 ->
		11;
get_highest_rank(3,Value) when Value >= 110000 ->
		21;
get_highest_rank(3,Value) when Value >= 110000 ->
		51;
get_highest_rank(4,Value) when Value >= 30 ->
		1;
get_highest_rank(4,Value) when Value >= 30 ->
		2;
get_highest_rank(4,Value) when Value >= 30 ->
		3;
get_highest_rank(4,Value) when Value >= 30 ->
		4;
get_highest_rank(4,Value) when Value >= 30 ->
		11;
get_highest_rank(4,Value) when Value >= 30 ->
		21;
get_highest_rank(4,Value) when Value >= 30 ->
		51;
get_highest_rank(5,Value) when Value >= 50 ->
		1;
get_highest_rank(5,Value) when Value >= 50 ->
		2;
get_highest_rank(5,Value) when Value >= 50 ->
		3;
get_highest_rank(5,Value) when Value >= 50 ->
		4;
get_highest_rank(5,Value) when Value >= 50 ->
		11;
get_highest_rank(5,Value) when Value >= 50 ->
		21;
get_highest_rank(5,Value) when Value >= 50 ->
		51;
get_highest_rank(6,Value) when Value >= 3000000 ->
		1;
get_highest_rank(6,Value) when Value >= 3000000 ->
		2;
get_highest_rank(6,Value) when Value >= 3000000 ->
		3;
get_highest_rank(6,Value) when Value >= 3000000 ->
		4;
get_highest_rank(6,Value) when Value >= 3000000 ->
		11;
get_highest_rank(6,Value) when Value >= 3000000 ->
		21;
get_highest_rank(6,Value) when Value >= 3000000 ->
		51;
get_highest_rank(7,Value) when Value >= 10 ->
		1;
get_highest_rank(7,Value) when Value >= 10 ->
		2;
get_highest_rank(7,Value) when Value >= 10 ->
		4;
get_highest_rank(7,Value) when Value >= 10 ->
		21;
get_highest_rank(13,Value) when Value >= 40 ->
		1;
get_highest_rank(13,Value) when Value >= 35 ->
		2;
get_highest_rank(13,Value) when Value >= 30 ->
		3;
get_highest_rank(13,Value) when Value >= 25 ->
		4;
get_highest_rank(13,Value) when Value >= 20 ->
		11;
get_highest_rank(13,Value) when Value >= 10 ->
		21;
get_highest_rank(13,Value) when Value >= 10 ->
		51;
get_highest_rank(14,Value) when Value >= 350000 ->
		1;
get_highest_rank(14,Value) when Value >= 330000 ->
		2;
get_highest_rank(14,Value) when Value >= 300000 ->
		3;
get_highest_rank(14,Value) when Value >= 290000 ->
		4;
get_highest_rank(14,Value) when Value >= 270000 ->
		11;
get_highest_rank(14,Value) when Value >= 250000 ->
		21;
get_highest_rank(14,Value) when Value >= 230000 ->
		51;
get_highest_rank(_Id,_Value) ->
	0.

get_rank_limit_val(1,Rank) when Rank >= 1, Rank =< 1 ->
		200;
get_rank_limit_val(1,Rank) when Rank >= 2, Rank =< 2 ->
		200;
get_rank_limit_val(1,Rank) when Rank >= 3, Rank =< 3 ->
		200;
get_rank_limit_val(1,Rank) when Rank >= 4, Rank =< 10 ->
		200;
get_rank_limit_val(1,Rank) when Rank >= 11, Rank =< 20 ->
		200;
get_rank_limit_val(1,Rank) when Rank >= 21, Rank =< 50 ->
		200;
get_rank_limit_val(1,Rank) when Rank >= 51, Rank =< 100 ->
		200;
get_rank_limit_val(2,Rank) when Rank >= 1, Rank =< 1 ->
		180000;
get_rank_limit_val(2,Rank) when Rank >= 2, Rank =< 2 ->
		180000;
get_rank_limit_val(2,Rank) when Rank >= 3, Rank =< 3 ->
		180000;
get_rank_limit_val(2,Rank) when Rank >= 4, Rank =< 10 ->
		180000;
get_rank_limit_val(2,Rank) when Rank >= 11, Rank =< 20 ->
		180000;
get_rank_limit_val(2,Rank) when Rank >= 21, Rank =< 50 ->
		180000;
get_rank_limit_val(2,Rank) when Rank >= 51, Rank =< 100 ->
		180000;
get_rank_limit_val(3,Rank) when Rank >= 1, Rank =< 1 ->
		110000;
get_rank_limit_val(3,Rank) when Rank >= 2, Rank =< 2 ->
		110000;
get_rank_limit_val(3,Rank) when Rank >= 3, Rank =< 3 ->
		110000;
get_rank_limit_val(3,Rank) when Rank >= 4, Rank =< 10 ->
		110000;
get_rank_limit_val(3,Rank) when Rank >= 11, Rank =< 20 ->
		110000;
get_rank_limit_val(3,Rank) when Rank >= 21, Rank =< 50 ->
		110000;
get_rank_limit_val(3,Rank) when Rank >= 51, Rank =< 100 ->
		110000;
get_rank_limit_val(4,Rank) when Rank >= 1, Rank =< 1 ->
		30;
get_rank_limit_val(4,Rank) when Rank >= 2, Rank =< 2 ->
		30;
get_rank_limit_val(4,Rank) when Rank >= 3, Rank =< 3 ->
		30;
get_rank_limit_val(4,Rank) when Rank >= 4, Rank =< 10 ->
		30;
get_rank_limit_val(4,Rank) when Rank >= 11, Rank =< 20 ->
		30;
get_rank_limit_val(4,Rank) when Rank >= 21, Rank =< 50 ->
		30;
get_rank_limit_val(4,Rank) when Rank >= 51, Rank =< 100 ->
		30;
get_rank_limit_val(5,Rank) when Rank >= 1, Rank =< 1 ->
		50;
get_rank_limit_val(5,Rank) when Rank >= 2, Rank =< 2 ->
		50;
get_rank_limit_val(5,Rank) when Rank >= 3, Rank =< 3 ->
		50;
get_rank_limit_val(5,Rank) when Rank >= 4, Rank =< 10 ->
		50;
get_rank_limit_val(5,Rank) when Rank >= 11, Rank =< 20 ->
		50;
get_rank_limit_val(5,Rank) when Rank >= 21, Rank =< 50 ->
		50;
get_rank_limit_val(5,Rank) when Rank >= 51, Rank =< 100 ->
		50;
get_rank_limit_val(6,Rank) when Rank >= 1, Rank =< 1 ->
		3000000;
get_rank_limit_val(6,Rank) when Rank >= 2, Rank =< 2 ->
		3000000;
get_rank_limit_val(6,Rank) when Rank >= 3, Rank =< 3 ->
		3000000;
get_rank_limit_val(6,Rank) when Rank >= 4, Rank =< 10 ->
		3000000;
get_rank_limit_val(6,Rank) when Rank >= 11, Rank =< 20 ->
		3000000;
get_rank_limit_val(6,Rank) when Rank >= 21, Rank =< 50 ->
		3000000;
get_rank_limit_val(6,Rank) when Rank >= 51, Rank =< 100 ->
		3000000;
get_rank_limit_val(7,Rank) when Rank >= 1, Rank =< 1 ->
		10;
get_rank_limit_val(7,Rank) when Rank >= 2, Rank =< 3 ->
		10;
get_rank_limit_val(7,Rank) when Rank >= 4, Rank =< 20 ->
		10;
get_rank_limit_val(7,Rank) when Rank >= 21, Rank =< 100 ->
		10;
get_rank_limit_val(13,Rank) when Rank >= 1, Rank =< 1 ->
		40;
get_rank_limit_val(13,Rank) when Rank >= 2, Rank =< 2 ->
		35;
get_rank_limit_val(13,Rank) when Rank >= 3, Rank =< 3 ->
		30;
get_rank_limit_val(13,Rank) when Rank >= 4, Rank =< 10 ->
		25;
get_rank_limit_val(13,Rank) when Rank >= 11, Rank =< 20 ->
		20;
get_rank_limit_val(13,Rank) when Rank >= 21, Rank =< 50 ->
		10;
get_rank_limit_val(13,Rank) when Rank >= 51, Rank =< 100 ->
		10;
get_rank_limit_val(14,Rank) when Rank >= 1, Rank =< 1 ->
		350000;
get_rank_limit_val(14,Rank) when Rank >= 2, Rank =< 2 ->
		330000;
get_rank_limit_val(14,Rank) when Rank >= 3, Rank =< 3 ->
		300000;
get_rank_limit_val(14,Rank) when Rank >= 4, Rank =< 10 ->
		290000;
get_rank_limit_val(14,Rank) when Rank >= 11, Rank =< 20 ->
		270000;
get_rank_limit_val(14,Rank) when Rank >= 21, Rank =< 50 ->
		250000;
get_rank_limit_val(14,Rank) when Rank >= 51, Rank =< 100 ->
		230000;
get_rank_limit_val(_Id,_Rank) ->
	0.

get_new_highest_rank(1,Value) when Value >= 200 ->
		1;
get_new_highest_rank(1,Value) when Value >= 200 ->
		2;
get_new_highest_rank(1,Value) when Value >= 200 ->
		3;
get_new_highest_rank(1,Value) when Value >= 200 ->
		4;
get_new_highest_rank(1,Value) when Value >= 200 ->
		11;
get_new_highest_rank(1,Value) when Value >= 200 ->
		21;
get_new_highest_rank(1,Value) when Value >= 200 ->
		51;
get_new_highest_rank(2,Value) when Value >= 280000 ->
		1;
get_new_highest_rank(2,Value) when Value >= 270000 ->
		2;
get_new_highest_rank(2,Value) when Value >= 260000 ->
		3;
get_new_highest_rank(2,Value) when Value >= 220000 ->
		4;
get_new_highest_rank(2,Value) when Value >= 180000 ->
		11;
get_new_highest_rank(2,Value) when Value >= 160000 ->
		21;
get_new_highest_rank(2,Value) when Value >= 130000 ->
		51;
get_new_highest_rank(3,Value) when Value >= 230000 ->
		1;
get_new_highest_rank(3,Value) when Value >= 220000 ->
		2;
get_new_highest_rank(3,Value) when Value >= 210000 ->
		3;
get_new_highest_rank(3,Value) when Value >= 190000 ->
		4;
get_new_highest_rank(3,Value) when Value >= 170000 ->
		11;
get_new_highest_rank(3,Value) when Value >= 150000 ->
		21;
get_new_highest_rank(3,Value) when Value >= 130000 ->
		51;
get_new_highest_rank(4,Value) when Value >= 30 ->
		1;
get_new_highest_rank(4,Value) when Value >= 30 ->
		2;
get_new_highest_rank(4,Value) when Value >= 30 ->
		3;
get_new_highest_rank(4,Value) when Value >= 30 ->
		4;
get_new_highest_rank(4,Value) when Value >= 30 ->
		11;
get_new_highest_rank(4,Value) when Value >= 30 ->
		21;
get_new_highest_rank(4,Value) when Value >= 30 ->
		51;
get_new_highest_rank(5,Value) when Value >= 50 ->
		1;
get_new_highest_rank(5,Value) when Value >= 50 ->
		2;
get_new_highest_rank(5,Value) when Value >= 50 ->
		3;
get_new_highest_rank(5,Value) when Value >= 50 ->
		4;
get_new_highest_rank(5,Value) when Value >= 50 ->
		11;
get_new_highest_rank(5,Value) when Value >= 50 ->
		21;
get_new_highest_rank(5,Value) when Value >= 50 ->
		51;
get_new_highest_rank(6,Value) when Value >= 3000000 ->
		1;
get_new_highest_rank(6,Value) when Value >= 3000000 ->
		2;
get_new_highest_rank(6,Value) when Value >= 3000000 ->
		3;
get_new_highest_rank(6,Value) when Value >= 3000000 ->
		4;
get_new_highest_rank(6,Value) when Value >= 3000000 ->
		11;
get_new_highest_rank(6,Value) when Value >= 3000000 ->
		21;
get_new_highest_rank(6,Value) when Value >= 3000000 ->
		51;
get_new_highest_rank(7,Value) when Value >= 10 ->
		1;
get_new_highest_rank(7,Value) when Value >= 10 ->
		2;
get_new_highest_rank(7,Value) when Value >= 10 ->
		4;
get_new_highest_rank(7,Value) when Value >= 10 ->
		21;
get_new_highest_rank(13,Value) when Value >= 60 ->
		1;
get_new_highest_rank(13,Value) when Value >= 60 ->
		2;
get_new_highest_rank(13,Value) when Value >= 50 ->
		3;
get_new_highest_rank(13,Value) when Value >= 30 ->
		4;
get_new_highest_rank(13,Value) when Value >= 25 ->
		11;
get_new_highest_rank(13,Value) when Value >= 20 ->
		21;
get_new_highest_rank(13,Value) when Value >= 20 ->
		51;
get_new_highest_rank(14,Value) when Value >= 350000 ->
		1;
get_new_highest_rank(14,Value) when Value >= 330000 ->
		2;
get_new_highest_rank(14,Value) when Value >= 300000 ->
		3;
get_new_highest_rank(14,Value) when Value >= 290000 ->
		4;
get_new_highest_rank(14,Value) when Value >= 270000 ->
		11;
get_new_highest_rank(14,Value) when Value >= 250000 ->
		21;
get_new_highest_rank(14,Value) when Value >= 230000 ->
		51;
get_new_highest_rank(_Id,_Value) ->
	0.

get_rank_new_limit_val(1,Rank) when Rank >= 1, Rank =< 1 ->
		200;
get_rank_new_limit_val(1,Rank) when Rank >= 2, Rank =< 2 ->
		200;
get_rank_new_limit_val(1,Rank) when Rank >= 3, Rank =< 3 ->
		200;
get_rank_new_limit_val(1,Rank) when Rank >= 4, Rank =< 10 ->
		200;
get_rank_new_limit_val(1,Rank) when Rank >= 11, Rank =< 20 ->
		200;
get_rank_new_limit_val(1,Rank) when Rank >= 21, Rank =< 50 ->
		200;
get_rank_new_limit_val(1,Rank) when Rank >= 51, Rank =< 100 ->
		200;
get_rank_new_limit_val(2,Rank) when Rank >= 1, Rank =< 1 ->
		280000;
get_rank_new_limit_val(2,Rank) when Rank >= 2, Rank =< 2 ->
		270000;
get_rank_new_limit_val(2,Rank) when Rank >= 3, Rank =< 3 ->
		260000;
get_rank_new_limit_val(2,Rank) when Rank >= 4, Rank =< 10 ->
		220000;
get_rank_new_limit_val(2,Rank) when Rank >= 11, Rank =< 20 ->
		180000;
get_rank_new_limit_val(2,Rank) when Rank >= 21, Rank =< 50 ->
		160000;
get_rank_new_limit_val(2,Rank) when Rank >= 51, Rank =< 100 ->
		130000;
get_rank_new_limit_val(3,Rank) when Rank >= 1, Rank =< 1 ->
		230000;
get_rank_new_limit_val(3,Rank) when Rank >= 2, Rank =< 2 ->
		220000;
get_rank_new_limit_val(3,Rank) when Rank >= 3, Rank =< 3 ->
		210000;
get_rank_new_limit_val(3,Rank) when Rank >= 4, Rank =< 10 ->
		190000;
get_rank_new_limit_val(3,Rank) when Rank >= 11, Rank =< 20 ->
		170000;
get_rank_new_limit_val(3,Rank) when Rank >= 21, Rank =< 50 ->
		150000;
get_rank_new_limit_val(3,Rank) when Rank >= 51, Rank =< 100 ->
		130000;
get_rank_new_limit_val(4,Rank) when Rank >= 1, Rank =< 1 ->
		30;
get_rank_new_limit_val(4,Rank) when Rank >= 2, Rank =< 2 ->
		30;
get_rank_new_limit_val(4,Rank) when Rank >= 3, Rank =< 3 ->
		30;
get_rank_new_limit_val(4,Rank) when Rank >= 4, Rank =< 10 ->
		30;
get_rank_new_limit_val(4,Rank) when Rank >= 11, Rank =< 20 ->
		30;
get_rank_new_limit_val(4,Rank) when Rank >= 21, Rank =< 50 ->
		30;
get_rank_new_limit_val(4,Rank) when Rank >= 51, Rank =< 100 ->
		30;
get_rank_new_limit_val(5,Rank) when Rank >= 1, Rank =< 1 ->
		50;
get_rank_new_limit_val(5,Rank) when Rank >= 2, Rank =< 2 ->
		50;
get_rank_new_limit_val(5,Rank) when Rank >= 3, Rank =< 3 ->
		50;
get_rank_new_limit_val(5,Rank) when Rank >= 4, Rank =< 10 ->
		50;
get_rank_new_limit_val(5,Rank) when Rank >= 11, Rank =< 20 ->
		50;
get_rank_new_limit_val(5,Rank) when Rank >= 21, Rank =< 50 ->
		50;
get_rank_new_limit_val(5,Rank) when Rank >= 51, Rank =< 100 ->
		50;
get_rank_new_limit_val(6,Rank) when Rank >= 1, Rank =< 1 ->
		3000000;
get_rank_new_limit_val(6,Rank) when Rank >= 2, Rank =< 2 ->
		3000000;
get_rank_new_limit_val(6,Rank) when Rank >= 3, Rank =< 3 ->
		3000000;
get_rank_new_limit_val(6,Rank) when Rank >= 4, Rank =< 10 ->
		3000000;
get_rank_new_limit_val(6,Rank) when Rank >= 11, Rank =< 20 ->
		3000000;
get_rank_new_limit_val(6,Rank) when Rank >= 21, Rank =< 50 ->
		3000000;
get_rank_new_limit_val(6,Rank) when Rank >= 51, Rank =< 100 ->
		3000000;
get_rank_new_limit_val(7,Rank) when Rank >= 1, Rank =< 1 ->
		10;
get_rank_new_limit_val(7,Rank) when Rank >= 2, Rank =< 3 ->
		10;
get_rank_new_limit_val(7,Rank) when Rank >= 4, Rank =< 20 ->
		10;
get_rank_new_limit_val(7,Rank) when Rank >= 21, Rank =< 100 ->
		10;
get_rank_new_limit_val(13,Rank) when Rank >= 1, Rank =< 1 ->
		60;
get_rank_new_limit_val(13,Rank) when Rank >= 2, Rank =< 2 ->
		60;
get_rank_new_limit_val(13,Rank) when Rank >= 3, Rank =< 3 ->
		50;
get_rank_new_limit_val(13,Rank) when Rank >= 4, Rank =< 10 ->
		30;
get_rank_new_limit_val(13,Rank) when Rank >= 11, Rank =< 20 ->
		25;
get_rank_new_limit_val(13,Rank) when Rank >= 21, Rank =< 50 ->
		20;
get_rank_new_limit_val(13,Rank) when Rank >= 51, Rank =< 100 ->
		20;
get_rank_new_limit_val(14,Rank) when Rank >= 1, Rank =< 1 ->
		350000;
get_rank_new_limit_val(14,Rank) when Rank >= 2, Rank =< 2 ->
		330000;
get_rank_new_limit_val(14,Rank) when Rank >= 3, Rank =< 3 ->
		300000;
get_rank_new_limit_val(14,Rank) when Rank >= 4, Rank =< 10 ->
		290000;
get_rank_new_limit_val(14,Rank) when Rank >= 11, Rank =< 20 ->
		270000;
get_rank_new_limit_val(14,Rank) when Rank >= 21, Rank =< 50 ->
		250000;
get_rank_new_limit_val(14,Rank) when Rank >= 51, Rank =< 100 ->
		230000;
get_rank_new_limit_val(_Id,_Rank) ->
	0.

get_goal_reward_cfg(1,1) ->
	#base_rush_goal_reward{id = 1,reward_id = 1,goal_value = [{lv,200}],reward = [{0,16020001,6}]};

get_goal_reward_cfg(1,2) ->
	#base_rush_goal_reward{id = 1,reward_id = 2,goal_value = [{lv,150}],reward = [{0,16020001,3}]};

get_goal_reward_cfg(1,3) ->
	#base_rush_goal_reward{id = 1,reward_id = 3,goal_value = [{lv,180}],reward = [{0,16020001,4}]};

get_goal_reward_cfg(1,4) ->
	#base_rush_goal_reward{id = 1,reward_id = 4,goal_value = [{lv,120}],reward = [{0,16020001,2}]};

get_goal_reward_cfg(2,1) ->
	#base_rush_goal_reward{id = 2,reward_id = 1,goal_value = [{combat,130000}],reward = [{0,17020001,6}]};

get_goal_reward_cfg(2,2) ->
	#base_rush_goal_reward{id = 2,reward_id = 2,goal_value = [{combat,110000}],reward = [{0,17020001,4}]};

get_goal_reward_cfg(2,3) ->
	#base_rush_goal_reward{id = 2,reward_id = 3,goal_value = [{combat,100000}],reward = [{0,17020001,3}]};

get_goal_reward_cfg(2,4) ->
	#base_rush_goal_reward{id = 2,reward_id = 4,goal_value = [{combat,90000}],reward = [{0,17020001,2}]};

get_goal_reward_cfg(3,1) ->
	#base_rush_goal_reward{id = 3,reward_id = 1,goal_value = [{combat,130000}],reward = [{0,18020001,6}]};

get_goal_reward_cfg(3,2) ->
	#base_rush_goal_reward{id = 3,reward_id = 2,goal_value = [{combat,110000}],reward = [{0,18020001,4}]};

get_goal_reward_cfg(3,3) ->
	#base_rush_goal_reward{id = 3,reward_id = 3,goal_value = [{combat,100000}],reward = [{0,18020001,3}]};

get_goal_reward_cfg(3,4) ->
	#base_rush_goal_reward{id = 3,reward_id = 4,goal_value = [{combat,90000}],reward = [{0,18020001,2}]};

get_goal_reward_cfg(4,1) ->
	#base_rush_goal_reward{id = 4,reward_id = 1,goal_value = [{recharge,300}],reward = [{0,14010002,1}]};

get_goal_reward_cfg(4,2) ->
	#base_rush_goal_reward{id = 4,reward_id = 2,goal_value = [{recharge,1}],reward = [{0,14020002,1}]};

get_goal_reward_cfg(4,3) ->
	#base_rush_goal_reward{id = 4,reward_id = 3,goal_value = [{recharge,120}],reward = [{0,14010002,1}]};

get_goal_reward_cfg(5,1) ->
	#base_rush_goal_reward{id = 5,reward_id = 1,goal_value = [{lv,50}],reward = [{0,20020001,6}]};

get_goal_reward_cfg(5,2) ->
	#base_rush_goal_reward{id = 5,reward_id = 2,goal_value = [{lv,30}],reward = [{0,20020001,3}]};

get_goal_reward_cfg(5,3) ->
	#base_rush_goal_reward{id = 5,reward_id = 3,goal_value = [{lv,40}],reward = [{0,20020001,4}]};

get_goal_reward_cfg(5,4) ->
	#base_rush_goal_reward{id = 5,reward_id = 4,goal_value = [{lv,20}],reward = [{0,20020001,2}]};

get_goal_reward_cfg(6,1) ->
	#base_rush_goal_reward{id = 6,reward_id = 1,goal_value = [{combat,3000000}],reward = [{100,32010569,6}]};

get_goal_reward_cfg(6,2) ->
	#base_rush_goal_reward{id = 6,reward_id = 2,goal_value = [{combat,2600000}],reward = [{100,32010569,4}]};

get_goal_reward_cfg(6,3) ->
	#base_rush_goal_reward{id = 6,reward_id = 3,goal_value = [{combat,2300000}],reward = [{100,32010569,3}]};

get_goal_reward_cfg(6,4) ->
	#base_rush_goal_reward{id = 6,reward_id = 4,goal_value = [{combat,2000000}],reward = [{100,32010569,2}]};

get_goal_reward_cfg(7,1) ->
	#base_rush_goal_reward{id = 7,reward_id = 1,goal_value = [{lv,10}],reward = [{0,22020001,30}]};

get_goal_reward_cfg(7,2) ->
	#base_rush_goal_reward{id = 7,reward_id = 2,goal_value = [{lv,5}],reward = [{0,22020001,20}]};

get_goal_reward_cfg(13,1) ->
	#base_rush_goal_reward{id = 13,reward_id = 1,goal_value = [{lv,30}],reward = [{0,38040030,4}]};

get_goal_reward_cfg(13,2) ->
	#base_rush_goal_reward{id = 13,reward_id = 2,goal_value = [{lv,20}],reward = [{0,38040030,3}]};

get_goal_reward_cfg(13,3) ->
	#base_rush_goal_reward{id = 13,reward_id = 3,goal_value = [{lv,15}],reward = [{0,38040030,2}]};

get_goal_reward_cfg(13,4) ->
	#base_rush_goal_reward{id = 13,reward_id = 4,goal_value = [{lv,10}],reward = [{0,38040030,1}]};

get_goal_reward_cfg(14,1) ->
	#base_rush_goal_reward{id = 14,reward_id = 1,goal_value = [{combat,260000}],reward = [{0,20020001,6}]};

get_goal_reward_cfg(14,2) ->
	#base_rush_goal_reward{id = 14,reward_id = 2,goal_value = [{combat,210000}],reward = [{0,20020001,4}]};

get_goal_reward_cfg(14,3) ->
	#base_rush_goal_reward{id = 14,reward_id = 3,goal_value = [{combat,190000}],reward = [{0,20020001,3}]};

get_goal_reward_cfg(14,4) ->
	#base_rush_goal_reward{id = 14,reward_id = 4,goal_value = [{combat,170000}],reward = [{0,20020001,2}]};

get_goal_reward_cfg(_Id,_Rewardid) ->
	[].


get_goal_reward_ids(1) ->
[1,2,3,4];


get_goal_reward_ids(2) ->
[1,2,3,4];


get_goal_reward_ids(3) ->
[1,2,3,4];


get_goal_reward_ids(4) ->
[1,2,3];


get_goal_reward_ids(5) ->
[1,2,3,4];


get_goal_reward_ids(6) ->
[1,2,3,4];


get_goal_reward_ids(7) ->
[1,2];


get_goal_reward_ids(13) ->
[1,2,3,4];


get_goal_reward_ids(14) ->
[1,2,3,4];

get_goal_reward_ids(_Id) ->
	[].

get_jump_info(227) ->
	#base_rush_rank_jump{jump_id = 227,module_id = 331,type_id = 4,sub_id = 0,label = 0,desc = <<"集字兑换"/utf8>>};

get_jump_info(228) ->
	#base_rush_rank_jump{jump_id = 228,module_id = 331,type_id = 36,sub_id = 0,label = 2,desc = <<"零元豪礼"/utf8>>};

get_jump_info(229) ->
	#base_rush_rank_jump{jump_id = 229,module_id = 331,type_id = 99,sub_id = 0,label = 1,desc = <<"天命转盘"/utf8>>};

get_jump_info(230) ->
	#base_rush_rank_jump{jump_id = 230,module_id = 331,type_id = 101,sub_id = 0,label = 2,desc = <<"限时抢购"/utf8>>};

get_jump_info(231) ->
	#base_rush_rank_jump{jump_id = 231,module_id = 331,type_id = 100,sub_id = 0,label = 1,desc = <<"特惠夺宝"/utf8>>};

get_jump_info(232) ->
	#base_rush_rank_jump{jump_id = 232,module_id = 331,type_id = 98,sub_id = 0,label = 2,desc = <<"超值特惠"/utf8>>};

get_jump_info(233) ->
	#base_rush_rank_jump{jump_id = 233,module_id = 331,type_id = 102,sub_id = 0,label = 2,desc = <<"幸运鉴宝"/utf8>>};

get_jump_info(234) ->
	#base_rush_rank_jump{jump_id = 234,module_id = 191,type_id = 7,sub_id = 0,label = 2,desc = <<"限时特惠-特色礼包"/utf8>>};

get_jump_info(_Jumpid) ->
	[].

