%%%---------------------------------------
%%% module      : data_zone_mod
%%% description : 小跨服248配置
%%%
%%%---------------------------------------
-module(data_zone_mod).
-compile(export_all).
-include("clusters.hrl").



get_mod_cfg(133,1) ->
	#base_zone_mod_group{module_id = 133,mod = 1,name = "本服",min_world_lv = 1,max_world_lv = 200,open_day = 0,max_open_day = 1};

get_mod_cfg(133,2) ->
	#base_zone_mod_group{module_id = 133,mod = 2,name = "2服",min_world_lv = 201,max_world_lv = 280,open_day = 5,max_open_day = 5};

get_mod_cfg(133,4) ->
	#base_zone_mod_group{module_id = 133,mod = 4,name = "4服",min_world_lv = 281,max_world_lv = 330,open_day = 9,max_open_day = 10};

get_mod_cfg(133,8) ->
	#base_zone_mod_group{module_id = 133,mod = 8,name = "8服",min_world_lv = 331,max_world_lv = 9999,open_day = 18,max_open_day = 20};

get_mod_cfg(135,1) ->
	#base_zone_mod_group{module_id = 135,mod = 1,name = "本服",min_world_lv = 1,max_world_lv = 200,open_day = 0,max_open_day = 1};

get_mod_cfg(135,2) ->
	#base_zone_mod_group{module_id = 135,mod = 2,name = "2服",min_world_lv = 201,max_world_lv = 280,open_day = 5,max_open_day = 5};

get_mod_cfg(135,4) ->
	#base_zone_mod_group{module_id = 135,mod = 4,name = "4服",min_world_lv = 281,max_world_lv = 330,open_day = 9,max_open_day = 10};

get_mod_cfg(135,8) ->
	#base_zone_mod_group{module_id = 135,mod = 8,name = "8服",min_world_lv = 331,max_world_lv = 9999,open_day = 18,max_open_day = 20};

get_mod_cfg(189,1) ->
	#base_zone_mod_group{module_id = 189,mod = 1,name = "本服",min_world_lv = 1,max_world_lv = 200,open_day = 0,max_open_day = 1};

get_mod_cfg(189,2) ->
	#base_zone_mod_group{module_id = 189,mod = 2,name = "2服",min_world_lv = 201,max_world_lv = 280,open_day = 5,max_open_day = 5};

get_mod_cfg(189,4) ->
	#base_zone_mod_group{module_id = 189,mod = 4,name = "4服",min_world_lv = 281,max_world_lv = 330,open_day = 9,max_open_day = 10};

get_mod_cfg(189,8) ->
	#base_zone_mod_group{module_id = 189,mod = 8,name = "8服",min_world_lv = 331,max_world_lv = 9999,open_day = 18,max_open_day = 20};

get_mod_cfg(204,1) ->
	#base_zone_mod_group{module_id = 204,mod = 1,name = "8服",min_world_lv = 1,max_world_lv = 399,open_day = 0,max_open_day = 50};

get_mod_cfg(204,8) ->
	#base_zone_mod_group{module_id = 204,mod = 8,name = "8服",min_world_lv = 400,max_world_lv = 9999,open_day = 50,max_open_day = 50};

get_mod_cfg(206,1) ->
	#base_zone_mod_group{module_id = 206,mod = 1,name = "本服",min_world_lv = 1,max_world_lv = 200,open_day = 0,max_open_day = 1};

get_mod_cfg(206,2) ->
	#base_zone_mod_group{module_id = 206,mod = 2,name = "2服",min_world_lv = 201,max_world_lv = 280,open_day = 5,max_open_day = 5};

get_mod_cfg(206,4) ->
	#base_zone_mod_group{module_id = 206,mod = 4,name = "4服",min_world_lv = 281,max_world_lv = 330,open_day = 9,max_open_day = 10};

get_mod_cfg(206,8) ->
	#base_zone_mod_group{module_id = 206,mod = 8,name = "8服",min_world_lv = 331,max_world_lv = 9999,open_day = 18,max_open_day = 20};

get_mod_cfg(218,1) ->
	#base_zone_mod_group{module_id = 218,mod = 1,name = "本服",min_world_lv = 1,max_world_lv = 200,open_day = 0,max_open_day = 1};

get_mod_cfg(218,2) ->
	#base_zone_mod_group{module_id = 218,mod = 2,name = "2服",min_world_lv = 201,max_world_lv = 280,open_day = 5,max_open_day = 5};

get_mod_cfg(218,4) ->
	#base_zone_mod_group{module_id = 218,mod = 4,name = "4服",min_world_lv = 281,max_world_lv = 330,open_day = 9,max_open_day = 10};

get_mod_cfg(218,8) ->
	#base_zone_mod_group{module_id = 218,mod = 8,name = "8服",min_world_lv = 331,max_world_lv = 9999,open_day = 18,max_open_day = 20};

get_mod_cfg(241,1) ->
	#base_zone_mod_group{module_id = 241,mod = 1,name = "本服",min_world_lv = 1,max_world_lv = 200,open_day = 0,max_open_day = 1};

get_mod_cfg(241,2) ->
	#base_zone_mod_group{module_id = 241,mod = 2,name = "2服",min_world_lv = 201,max_world_lv = 280,open_day = 5,max_open_day = 5};

get_mod_cfg(241,4) ->
	#base_zone_mod_group{module_id = 241,mod = 4,name = "4服",min_world_lv = 281,max_world_lv = 330,open_day = 9,max_open_day = 10};

get_mod_cfg(241,8) ->
	#base_zone_mod_group{module_id = 241,mod = 8,name = "8服",min_world_lv = 331,max_world_lv = 9999,open_day = 18,max_open_day = 20};

get_mod_cfg(284,1) ->
	#base_zone_mod_group{module_id = 284,mod = 1,name = "本服",min_world_lv = 1,max_world_lv = 200,open_day = 0,max_open_day = 1};

get_mod_cfg(284,2) ->
	#base_zone_mod_group{module_id = 284,mod = 2,name = "2服",min_world_lv = 201,max_world_lv = 280,open_day = 5,max_open_day = 5};

get_mod_cfg(284,4) ->
	#base_zone_mod_group{module_id = 284,mod = 4,name = "4服",min_world_lv = 281,max_world_lv = 330,open_day = 9,max_open_day = 10};

get_mod_cfg(284,8) ->
	#base_zone_mod_group{module_id = 284,mod = 8,name = "8服",min_world_lv = 331,max_world_lv = 9999,open_day = 18,max_open_day = 20};

get_mod_cfg(402,1) ->
	#base_zone_mod_group{module_id = 402,mod = 1,name = "本服",min_world_lv = 1,max_world_lv = 200,open_day = 0,max_open_day = 1};

get_mod_cfg(402,2) ->
	#base_zone_mod_group{module_id = 402,mod = 2,name = "2服",min_world_lv = 201,max_world_lv = 280,open_day = 5,max_open_day = 5};

get_mod_cfg(402,4) ->
	#base_zone_mod_group{module_id = 402,mod = 4,name = "4服",min_world_lv = 281,max_world_lv = 330,open_day = 9,max_open_day = 10};

get_mod_cfg(402,8) ->
	#base_zone_mod_group{module_id = 402,mod = 8,name = "8服",min_world_lv = 331,max_world_lv = 9999,open_day = 18,max_open_day = 20};

get_mod_cfg(506,1) ->
	#base_zone_mod_group{module_id = 506,mod = 1,name = "本服",min_world_lv = 1,max_world_lv = 250,open_day = 0,max_open_day = 1};

get_mod_cfg(506,2) ->
	#base_zone_mod_group{module_id = 506,mod = 2,name = "2服",min_world_lv = 251,max_world_lv = 330,open_day = 5,max_open_day = 5};

get_mod_cfg(506,4) ->
	#base_zone_mod_group{module_id = 506,mod = 4,name = "4服",min_world_lv = 331,max_world_lv = 440,open_day = 9,max_open_day = 10};

get_mod_cfg(506,8) ->
	#base_zone_mod_group{module_id = 506,mod = 8,name = "8服",min_world_lv = 441,max_world_lv = 9999,open_day = 18,max_open_day = 20};

get_mod_cfg(_Moduleid,_Mod) ->
	[].

get_module_list() ->
[133,135,189,204,206,218,241,284,402,506].


get_mod_cfg_list(133) ->
[{1,1,200,0},{2,201,280,5},{4,281,330,9},{8,331,9999,18}];


get_mod_cfg_list(135) ->
[{1,1,200,0},{2,201,280,5},{4,281,330,9},{8,331,9999,18}];


get_mod_cfg_list(189) ->
[{1,1,200,0},{2,201,280,5},{4,281,330,9},{8,331,9999,18}];


get_mod_cfg_list(204) ->
[{1,1,399,0},{8,400,9999,50}];


get_mod_cfg_list(206) ->
[{1,1,200,0},{2,201,280,5},{4,281,330,9},{8,331,9999,18}];


get_mod_cfg_list(218) ->
[{1,1,200,0},{2,201,280,5},{4,281,330,9},{8,331,9999,18}];


get_mod_cfg_list(241) ->
[{1,1,200,0},{2,201,280,5},{4,281,330,9},{8,331,9999,18}];


get_mod_cfg_list(284) ->
[{1,1,200,0},{2,201,280,5},{4,281,330,9},{8,331,9999,18}];


get_mod_cfg_list(402) ->
[{1,1,200,0},{2,201,280,5},{4,281,330,9},{8,331,9999,18}];


get_mod_cfg_list(506) ->
[{1,1,250,0},{2,251,330,5},{4,331,440,9},{8,441,9999,18}];

get_mod_cfg_list(_Moduleid) ->
	[].

