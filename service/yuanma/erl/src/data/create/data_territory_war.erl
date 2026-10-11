%%%---------------------------------------
%%% module      : data_territory_war
%%% description : 跨服领地配置
%%%
%%%---------------------------------------
-module(data_territory_war).
-compile(export_all).
-include("territory_war.hrl").




get_cfg(1) ->
[{6,75600}];


get_cfg(2) ->
600;


get_cfg(3) ->
2000;


get_cfg(4) ->
60;


get_cfg(5) ->
240;


get_cfg(7) ->
86400;


get_cfg(8) ->
4203001;


get_cfg(9) ->
2;


get_cfg(10) ->
1;


get_cfg(11) ->
1;


get_cfg(12) ->
5;


get_cfg(13) ->
[{1,3000},{2,3000},{3,8000}];


get_cfg(14) ->
[5,[4],[5,9999]];


get_cfg(15) ->
[{1,[{1,0},{2,0},{3,0}]},{2,[{1,0},{2,0},{3,0}]},{3,[{1,0},{2,0},{3,0.3},{4,0.8},{5,2}]}];

get_cfg(_Key) ->
	0.

get_mode_cfg(1) ->
	#base_territory_mode{mode_num = 1,start_round = 2,guild_num = 4,wlv = 1,open_day = 0};

get_mode_cfg(2) ->
	#base_territory_mode{mode_num = 2,start_round = 1,guild_num = 4,wlv = 201,open_day = 5};

get_mode_cfg(4) ->
	#base_territory_mode{mode_num = 4,start_round = 1,guild_num = 2,wlv = 281,open_day = 9};

get_mode_cfg(8) ->
	#base_territory_mode{mode_num = 8,start_round = 1,guild_num = 1,wlv = 331,open_day = 18};

get_mode_cfg(_Modenum) ->
	[].

get_territory_cfg(1001) ->
	#base_territory{territory_id = 1001,territory_name = "沼源",round = 1,war_type = 2,next_territory_id = 1005,scene = [8001,8002],camp_born = [{1,1249,3594,200},{2,7457,3562,200}]};

get_territory_cfg(1002) ->
	#base_territory{territory_id = 1002,territory_name = "暗峡",round = 1,war_type = 2,next_territory_id = 1005,scene = [8001,8002],camp_born = [{1,1249,3594,200},{2,7457,3562,200}]};

get_territory_cfg(1003) ->
	#base_territory{territory_id = 1003,territory_name = "金沙",round = 1,war_type = 2,next_territory_id = 1006,scene = [8001,8002],camp_born = [{1,1249,3594,200},{2,7457,3562,200}]};

get_territory_cfg(1004) ->
	#base_territory{territory_id = 1004,territory_name = "尖塔",round = 1,war_type = 2,next_territory_id = 1006,scene = [8001,8002],camp_born = [{1,1249,3594,200},{2,7457,3562,200}]};

get_territory_cfg(1005) ->
	#base_territory{territory_id = 1005,territory_name = "荒芜领域",round = 2,war_type = 2,next_territory_id = 1007,scene = [8001,8002],camp_born = [{1,1249,3594,200},{2,7457,3562,200}]};

get_territory_cfg(1006) ->
	#base_territory{territory_id = 1006,territory_name = "熔岩领域",round = 2,war_type = 2,next_territory_id = 1007,scene = [8001,8002],camp_born = [{1,1249,3594,200},{2,7457,3562,200}]};

get_territory_cfg(1007) ->
	#base_territory{territory_id = 1007,territory_name = "巅峰王城",round = 3,war_type = 2,next_territory_id = 0,scene = [8001,8002],camp_born = [{1,1249,3594,200},{2,7457,3562,200}]};

get_territory_cfg(_Territoryid) ->
	[].


get_camp_born_location(1001) ->
[{1,1249,3594,200},{2,7457,3562,200}];


get_camp_born_location(1002) ->
[{1,1249,3594,200},{2,7457,3562,200}];


get_camp_born_location(1003) ->
[{1,1249,3594,200},{2,7457,3562,200}];


get_camp_born_location(1004) ->
[{1,1249,3594,200},{2,7457,3562,200}];


get_camp_born_location(1005) ->
[{1,1249,3594,200},{2,7457,3562,200}];


get_camp_born_location(1006) ->
[{1,1249,3594,200},{2,7457,3562,200}];


get_camp_born_location(1007) ->
[{1,1249,3594,200},{2,7457,3562,200}];

get_camp_born_location(_Territoryid) ->
	[].


get_territory_id_list_by_round(1) ->
[1001,1002,1003,1004];


get_territory_id_list_by_round(2) ->
[1005,1006];


get_territory_id_list_by_round(3) ->
[1007];

get_territory_id_list_by_round(_Round) ->
	[].

get_terri_mon(1001,8001001) ->
	#base_terri_mon{territory_id = 1001,mon_id = 8001001,camp = 0,mon_type = 2,x = 4353,y = 1914,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1001,8001003) ->
	#base_terri_mon{territory_id = 1001,mon_id = 8001003,camp = 0,mon_type = 2,x = 4353,y = 5258,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1001,8001005) ->
	#base_terri_mon{territory_id = 1001,mon_id = 8001005,camp = 0,mon_type = 1,x = 4353,y = 3434,range = 50,revive_priority = 0,kill_score = 100,guild_score = 50,condition = []};

get_terri_mon(1002,8001001) ->
	#base_terri_mon{territory_id = 1002,mon_id = 8001001,camp = 0,mon_type = 2,x = 4353,y = 1914,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1002,8001003) ->
	#base_terri_mon{territory_id = 1002,mon_id = 8001003,camp = 0,mon_type = 2,x = 4353,y = 5258,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1002,8001005) ->
	#base_terri_mon{territory_id = 1002,mon_id = 8001005,camp = 0,mon_type = 1,x = 4353,y = 3434,range = 50,revive_priority = 0,kill_score = 100,guild_score = 50,condition = []};

get_terri_mon(1003,8001001) ->
	#base_terri_mon{territory_id = 1003,mon_id = 8001001,camp = 0,mon_type = 2,x = 4353,y = 1914,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1003,8001003) ->
	#base_terri_mon{territory_id = 1003,mon_id = 8001003,camp = 0,mon_type = 2,x = 4353,y = 5258,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1003,8001005) ->
	#base_terri_mon{territory_id = 1003,mon_id = 8001005,camp = 0,mon_type = 1,x = 4353,y = 3434,range = 50,revive_priority = 0,kill_score = 100,guild_score = 50,condition = []};

get_terri_mon(1004,8001001) ->
	#base_terri_mon{territory_id = 1004,mon_id = 8001001,camp = 0,mon_type = 2,x = 4353,y = 1914,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1004,8001003) ->
	#base_terri_mon{territory_id = 1004,mon_id = 8001003,camp = 0,mon_type = 2,x = 4353,y = 5258,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1004,8001005) ->
	#base_terri_mon{territory_id = 1004,mon_id = 8001005,camp = 0,mon_type = 1,x = 4353,y = 3434,range = 50,revive_priority = 0,kill_score = 100,guild_score = 50,condition = []};

get_terri_mon(1005,8001001) ->
	#base_terri_mon{territory_id = 1005,mon_id = 8001001,camp = 0,mon_type = 2,x = 4353,y = 1914,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1005,8001003) ->
	#base_terri_mon{territory_id = 1005,mon_id = 8001003,camp = 0,mon_type = 2,x = 4353,y = 5258,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1005,8001005) ->
	#base_terri_mon{territory_id = 1005,mon_id = 8001005,camp = 0,mon_type = 1,x = 4353,y = 3434,range = 50,revive_priority = 0,kill_score = 100,guild_score = 50,condition = []};

get_terri_mon(1006,8001001) ->
	#base_terri_mon{territory_id = 1006,mon_id = 8001001,camp = 0,mon_type = 2,x = 4353,y = 1914,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1006,8001003) ->
	#base_terri_mon{territory_id = 1006,mon_id = 8001003,camp = 0,mon_type = 2,x = 4353,y = 5258,range = 50,revive_priority = 1,kill_score = 50,guild_score = 10,condition = []};

get_terri_mon(1006,8001005) ->
	#base_terri_mon{territory_id = 1006,mon_id = 8001005,camp = 0,mon_type = 1,x = 4353,y = 3434,range = 50,revive_priority = 0,kill_score = 100,guild_score = 50,condition = []};

get_terri_mon(1007,8001001) ->
	#base_terri_mon{territory_id = 1007,mon_id = 8001001,camp = 0,mon_type = 2,x = 2073,y = 2498,range = 50,revive_priority = 1,kill_score = 25,guild_score = 10,condition = []};

get_terri_mon(1007,8001002) ->
	#base_terri_mon{territory_id = 1007,mon_id = 8001002,camp = 0,mon_type = 2,x = 6625,y = 2498,range = 50,revive_priority = 1,kill_score = 25,guild_score = 10,condition = []};

get_terri_mon(1007,8001003) ->
	#base_terri_mon{territory_id = 1007,mon_id = 8001003,camp = 0,mon_type = 2,x = 6529,y = 4690,range = 50,revive_priority = 1,kill_score = 25,guild_score = 10,condition = []};

get_terri_mon(1007,8001004) ->
	#base_terri_mon{territory_id = 1007,mon_id = 8001004,camp = 0,mon_type = 2,x = 2177,y = 4690,range = 50,revive_priority = 1,kill_score = 25,guild_score = 10,condition = []};

get_terri_mon(1007,8001005) ->
	#base_terri_mon{territory_id = 1007,mon_id = 8001005,camp = 0,mon_type = 1,x = 4353,y = 3434,range = 50,revive_priority = 0,kill_score = 100,guild_score = 50,condition = []};

get_terri_mon(_Territoryid,_Monid) ->
	[].


get_mon_list_by_territory_id(1001) ->
[{8001001,2,0,4353,1914,50,[]},{8001003,2,0,4353,5258,50,[]},{8001005,1,0,4353,3434,50,[]}];


get_mon_list_by_territory_id(1002) ->
[{8001001,2,0,4353,1914,50,[]},{8001003,2,0,4353,5258,50,[]},{8001005,1,0,4353,3434,50,[]}];


get_mon_list_by_territory_id(1003) ->
[{8001001,2,0,4353,1914,50,[]},{8001003,2,0,4353,5258,50,[]},{8001005,1,0,4353,3434,50,[]}];


get_mon_list_by_territory_id(1004) ->
[{8001001,2,0,4353,1914,50,[]},{8001003,2,0,4353,5258,50,[]},{8001005,1,0,4353,3434,50,[]}];


get_mon_list_by_territory_id(1005) ->
[{8001001,2,0,4353,1914,50,[]},{8001003,2,0,4353,5258,50,[]},{8001005,1,0,4353,3434,50,[]}];


get_mon_list_by_territory_id(1006) ->
[{8001001,2,0,4353,1914,50,[]},{8001003,2,0,4353,5258,50,[]},{8001005,1,0,4353,3434,50,[]}];


get_mon_list_by_territory_id(1007) ->
[{8001001,2,0,2073,2498,50,[]},{8001002,2,0,6625,2498,50,[]},{8001003,2,0,6529,4690,50,[]},{8001004,2,0,2177,4690,50,[]},{8001005,1,0,4353,3434,50,[]}];

get_mon_list_by_territory_id(_Territoryid) ->
	[].


get_buff_attr(1) ->
[{19,5000},{20,5000},{22,5000}];


get_buff_attr(2) ->
[{19,10000},{20,10000},{22,10000}];

get_buff_attr(_Buffid) ->
	[].

get_buff_id(_WinNum) when _WinNum >= 3, _WinNum =< 9 ->
		1;
get_buff_id(_WinNum) when _WinNum >= 10, _WinNum =< 999 ->
		2;
get_buff_id(_WinNum) ->
	0.

get_streak_reward(_Wlv,2) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,32010017,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,32010017,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 1, _Wlv =< 219 ->
		[[{0,32010017,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,32010018,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,32010018,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 220, _Wlv =< 269 ->
		[[{0,32010018,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,32010019,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,32010019,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 270, _Wlv =< 319 ->
		[[{0,32010019,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,32010020,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,32010020,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 320, _Wlv =< 369 ->
		[[{0,32010020,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,32010021,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,32010021,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 370, _Wlv =< 419 ->
		[[{0,32010021,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,32010022,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,32010022,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 420, _Wlv =< 469 ->
		[[{0,32010022,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,32010023,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,32010023,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 470, _Wlv =< 519 ->
		[[{0,32010023,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,32010024,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,32010024,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 520, _Wlv =< 569 ->
		[[{0,32010024,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,32010025,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,32010025,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 570, _Wlv =< 619 ->
		[[{0,32010025,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,32010026,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,32010026,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 620, _Wlv =< 669 ->
		[[{0,32010026,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,32010027,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,32010027,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 670, _Wlv =< 719 ->
		[[{0,32010027,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,32010028,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,32010028,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,20030008,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 720, _Wlv =< 99999 ->
		[[{0,32010028,1}],[{0,20030008,1}]];
get_streak_reward(_Wlv,_Streak_times) ->
	[].

get_battle_reward(_Wlv) when _Wlv >= 1, _Wlv =< 99999 ->
		[[{0,38064005,1},{0,32010113,1}],[{4,0,250},{4,0,250},{0,37020001,1}]];
get_battle_reward(_Wlv) ->
	[].

get_all_role_reward(_Territoryid) ->
	[].

get_role_reward(_Territoryid,_Id) ->
	[].

get_terri_result_reward(1001,1) ->
[{[{0,20030108,2},{0,20020001,6},{4,0,1000}],[{0,20030108,1},{0,20020001,3},{4,0,600}]}];

get_terri_result_reward(1001,2) ->
[{[{0,20030108,3},{0,20020001,8},{4,0,1500}],[{0,20030108,2},{0,20020001,4},{4,0,900}]}];

get_terri_result_reward(1001,4) ->
[{[{0,20030108,4},{0,20020002,2},{4,0,2000}],[{0,20030108,2},{0,20020002,1},{4,0,1200}]}];

get_terri_result_reward(1001,8) ->
[{[{0,20030108,5},{0,20020002,4},{4,0,2500}],[{0,20030108,3},{0,20020002,2},{4,0,1500}]}];

get_terri_result_reward(1002,1) ->
[{[{0,20030108,2},{0,20020001,6},{4,0,1000}],[{0,20030108,1},{0,20020001,3},{4,0,600}]}];

get_terri_result_reward(1002,2) ->
[{[{0,20030108,3},{0,20020001,8},{4,0,1500}],[{0,20030108,2},{0,20020001,4},{4,0,900}]}];

get_terri_result_reward(1002,4) ->
[{[{0,20030108,4},{0,20020002,2},{4,0,2000}],[{0,20030108,2},{0,20020002,1},{4,0,1200}]}];

get_terri_result_reward(1002,8) ->
[{[{0,20030108,5},{0,20020002,4},{4,0,2500}],[{0,20030108,3},{0,20020002,2},{4,0,1500}]}];

get_terri_result_reward(1003,1) ->
[{[{0,20030108,2},{0,20020001,6},{4,0,1000}],[{0,20030108,1},{0,20020001,3},{4,0,600}]}];

get_terri_result_reward(1003,2) ->
[{[{0,20030108,3},{0,20020001,8},{4,0,1500}],[{0,20030108,2},{0,20020001,4},{4,0,900}]}];

get_terri_result_reward(1003,4) ->
[{[{0,20030108,4},{0,20020002,2},{4,0,2000}],[{0,20030108,2},{0,20020002,1},{4,0,1200}]}];

get_terri_result_reward(1003,8) ->
[{[{0,20030108,5},{0,20020002,4},{4,0,2500}],[{0,20030108,3},{0,20020002,2},{4,0,1500}]}];

get_terri_result_reward(1004,1) ->
[{[{0,20030108,2},{0,20020001,6},{4,0,1000}],[{0,20030108,1},{0,20020001,3},{4,0,600}]}];

get_terri_result_reward(1004,2) ->
[{[{0,20030108,3},{0,20020001,8},{4,0,1500}],[{0,20030108,2},{0,20020001,4},{4,0,900}]}];

get_terri_result_reward(1004,4) ->
[{[{0,20030108,4},{0,20020002,2},{4,0,2000}],[{0,20030108,2},{0,20020002,1},{4,0,1200}]}];

get_terri_result_reward(1004,8) ->
[{[{0,20030108,5},{0,20020002,4},{4,0,2500}],[{0,20030108,3},{0,20020002,2},{4,0,1500}]}];

get_terri_result_reward(1005,1) ->
[{[{0,20030108,2},{0,20020001,6},{4,0,1000}],[{0,20030108,1},{0,20020001,3},{4,0,600}]}];

get_terri_result_reward(1005,2) ->
[{[{0,20030108,3},{0,20020001,8},{4,0,1500}],[{0,20030108,2},{0,20020001,4},{4,0,900}]}];

get_terri_result_reward(1005,4) ->
[{[{0,20030108,4},{0,20020002,2},{4,0,2000}],[{0,20030108,2},{0,20020002,1},{4,0,1200}]}];

get_terri_result_reward(1005,8) ->
[{[{0,20030108,5},{0,20020002,4},{4,0,2500}],[{0,20030108,3},{0,20020002,2},{4,0,1500}]}];

get_terri_result_reward(1006,1) ->
[{[{0,20030108,2},{0,20020001,6},{4,0,1000}],[{0,20030108,1},{0,20020001,3},{4,0,600}]}];

get_terri_result_reward(1006,2) ->
[{[{0,20030108,3},{0,20020001,8},{4,0,1500}],[{0,20030108,2},{0,20020001,4},{4,0,900}]}];

get_terri_result_reward(1006,4) ->
[{[{0,20030108,4},{0,20020002,2},{4,0,2000}],[{0,20030108,2},{0,20020002,1},{4,0,1200}]}];

get_terri_result_reward(1006,8) ->
[{[{0,20030108,5},{0,20020002,4},{4,0,2500}],[{0,20030108,3},{0,20020002,2},{4,0,1500}]}];

get_terri_result_reward(1007,1) ->
[{[{0,20030108,2},{0,20020001,6},{4,0,1000}],[{0,20030108,1},{0,20020001,3},{4,0,600}]}];

get_terri_result_reward(1007,2) ->
[{[{0,20030108,3},{0,20020001,8},{4,0,1500}],[{0,20030108,2},{0,20020001,4},{4,0,900}]}];

get_terri_result_reward(1007,4) ->
[{[{0,20030108,4},{0,20020002,2},{4,0,2000}],[{0,20030108,2},{0,20020002,1},{4,0,1200}]}];

get_terri_result_reward(1007,8) ->
[{[{0,20030108,5},{0,20020002,4},{4,0,2500}],[{0,20030108,3},{0,20020002,2},{4,0,1500}]}];

get_terri_result_reward(_Territoryid,_Modenum) ->
	[].

