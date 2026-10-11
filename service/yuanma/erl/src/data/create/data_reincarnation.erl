%%%---------------------------------------
%%% module      : data_reincarnation
%%% description : 转生配置
%%%
%%%---------------------------------------
-module(data_reincarnation).
-compile(export_all).
-include("reincarnation.hrl").



get_reincarnation_cfg(1,1,0) ->
	#reincarnation_cfg{career = 1,sex = 1,turn = 0,full_lv = 370,icon = "90",name = <<"战士"/utf8>>,model_id = 120111000,attr = [],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = [{0,38420001,1}]};

get_reincarnation_cfg(1,1,1) ->
	#reincarnation_cfg{career = 1,sex = 1,turn = 1,full_lv = 370,icon = "91",name = <<"一转·剑心"/utf8>>,model_id = 120111000,attr = [{1,400},{2,8000},{3,200},{4,200}],unlock_skill = [],replace_skill = [],turn_skill = [{101010,2}],turn_cost = [{0,38420001,1}]};

get_reincarnation_cfg(1,1,2) ->
	#reincarnation_cfg{career = 1,sex = 1,turn = 2,full_lv = 370,icon = "92",name = <<"二转·斩风"/utf8>>,model_id = 120111000,attr = [{1,800},{2,16000},{3,400},{4,400}],unlock_skill = [],replace_skill = [],turn_skill = [{102010,2}],turn_cost = [{0,38420002,1}]};

get_reincarnation_cfg(1,1,3) ->
	#reincarnation_cfg{career = 1,sex = 1,turn = 3,full_lv = 370,icon = "93",name = <<"三转·飞皇"/utf8>>,model_id = 120111000,attr = [{1,1600},{2,32000},{3,800},{4,800}],unlock_skill = [],replace_skill = [],turn_skill = [{102020,2}],turn_cost = []};

get_reincarnation_cfg(1,1,4) ->
	#reincarnation_cfg{career = 1,sex = 1,turn = 4,full_lv = 520,icon = "94",name = <<"四转·冲斗"/utf8>>,model_id = 120111000,attr = [{1,2400},{2,48000},{3,1200},{4,1200}],unlock_skill = [],replace_skill = [],turn_skill = [{102030,2}],turn_cost = []};

get_reincarnation_cfg(1,1,5) ->
	#reincarnation_cfg{career = 1,sex = 1,turn = 5,full_lv = 630,icon = "95",name = <<"五转·耀辉"/utf8>>,model_id = 120111000,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],unlock_skill = [],replace_skill = [],turn_skill = [{102040,2}],turn_cost = []};

get_reincarnation_cfg(1,1,6) ->
	#reincarnation_cfg{career = 1,sex = 1,turn = 6,full_lv = 720,icon = "96",name = <<"六转·剑豪"/utf8>>,model_id = 120111000,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = []};

get_reincarnation_cfg(1,1,7) ->
	#reincarnation_cfg{career = 1,sex = 1,turn = 7,full_lv = 840,icon = "97",name = <<"七转·隐者"/utf8>>,model_id = 120111000,attr = [{1,5000},{2,100000},{3,2500},{4,2500}],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = []};

get_reincarnation_cfg(2,2,0) ->
	#reincarnation_cfg{career = 2,sex = 2,turn = 0,full_lv = 370,icon = "90",name = <<"武姬"/utf8>>,model_id = 120112000,attr = [],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = [{0,38420001,1}]};

get_reincarnation_cfg(2,2,1) ->
	#reincarnation_cfg{career = 2,sex = 2,turn = 1,full_lv = 370,icon = "91",name = <<"一转·武流"/utf8>>,model_id = 120112000,attr = [{1,400},{2,8000},{3,200},{4,200}],unlock_skill = [],replace_skill = [],turn_skill = [{201010,2}],turn_cost = [{0,38420001,1}]};

get_reincarnation_cfg(2,2,2) ->
	#reincarnation_cfg{career = 2,sex = 2,turn = 2,full_lv = 370,icon = "92",name = <<"二转·残雨"/utf8>>,model_id = 120112000,attr = [{1,800},{2,16000},{3,400},{4,400}],unlock_skill = [],replace_skill = [],turn_skill = [{202010,2}],turn_cost = [{0,38420002,1}]};

get_reincarnation_cfg(2,2,3) ->
	#reincarnation_cfg{career = 2,sex = 2,turn = 3,full_lv = 370,icon = "93",name = <<"三转·落樱"/utf8>>,model_id = 120112000,attr = [{1,1600},{2,32000},{3,800},{4,800}],unlock_skill = [],replace_skill = [],turn_skill = [{202020,2}],turn_cost = []};

get_reincarnation_cfg(2,2,4) ->
	#reincarnation_cfg{career = 2,sex = 2,turn = 4,full_lv = 520,icon = "94",name = <<"四转·影舞"/utf8>>,model_id = 120112000,attr = [{1,2400},{2,48000},{3,1200},{4,1200}],unlock_skill = [],replace_skill = [],turn_skill = [{202030,2}],turn_cost = []};

get_reincarnation_cfg(2,2,5) ->
	#reincarnation_cfg{career = 2,sex = 2,turn = 5,full_lv = 630,icon = "95",name = <<"五转·伶空"/utf8>>,model_id = 120112000,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],unlock_skill = [],replace_skill = [],turn_skill = [{202040,2}],turn_cost = []};

get_reincarnation_cfg(2,2,6) ->
	#reincarnation_cfg{career = 2,sex = 2,turn = 6,full_lv = 720,icon = "96",name = <<"六转·武代"/utf8>>,model_id = 120112000,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = []};

get_reincarnation_cfg(2,2,7) ->
	#reincarnation_cfg{career = 2,sex = 2,turn = 7,full_lv = 840,icon = "97",name = <<"七转·黯星"/utf8>>,model_id = 120112000,attr = [{1,5000},{2,100000},{3,2500},{4,2500}],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = []};

get_reincarnation_cfg(3,1,0) ->
	#reincarnation_cfg{career = 3,sex = 1,turn = 0,full_lv = 370,icon = "90",name = <<"枪使"/utf8>>,model_id = 120111000,attr = [],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = [{0,38420001,1}]};

get_reincarnation_cfg(3,1,1) ->
	#reincarnation_cfg{career = 3,sex = 1,turn = 1,full_lv = 370,icon = "91",name = <<"一转·枪魂"/utf8>>,model_id = 120111000,attr = [{1,400},{2,8000},{3,200},{4,200}],unlock_skill = [],replace_skill = [],turn_skill = [{301010,2}],turn_cost = [{0,38420001,1}]};

get_reincarnation_cfg(3,1,2) ->
	#reincarnation_cfg{career = 3,sex = 1,turn = 2,full_lv = 370,icon = "92",name = <<"二转·惊雷"/utf8>>,model_id = 120111000,attr = [{1,800},{2,16000},{3,400},{4,400}],unlock_skill = [],replace_skill = [],turn_skill = [{302010,2}],turn_cost = [{0,38420002,1}]};

get_reincarnation_cfg(3,1,3) ->
	#reincarnation_cfg{career = 3,sex = 1,turn = 3,full_lv = 370,icon = "93",name = <<"三转·百屠"/utf8>>,model_id = 120111000,attr = [{1,1600},{2,32000},{3,800},{4,800}],unlock_skill = [],replace_skill = [],turn_skill = [{302020,2}],turn_cost = []};

get_reincarnation_cfg(3,1,4) ->
	#reincarnation_cfg{career = 3,sex = 1,turn = 4,full_lv = 520,icon = "94",name = <<"四转·炽烈"/utf8>>,model_id = 120111000,attr = [{1,2400},{2,48000},{3,1200},{4,1200}],unlock_skill = [],replace_skill = [],turn_skill = [{302030,2}],turn_cost = []};

get_reincarnation_cfg(3,1,5) ->
	#reincarnation_cfg{career = 3,sex = 1,turn = 5,full_lv = 630,icon = "95",name = <<"五转·统御"/utf8>>,model_id = 120111000,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],unlock_skill = [],replace_skill = [],turn_skill = [{302040,2}],turn_cost = []};

get_reincarnation_cfg(3,1,6) ->
	#reincarnation_cfg{career = 3,sex = 1,turn = 6,full_lv = 720,icon = "96",name = <<"六转·枪杰"/utf8>>,model_id = 120111000,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = []};

get_reincarnation_cfg(3,1,7) ->
	#reincarnation_cfg{career = 3,sex = 1,turn = 7,full_lv = 840,icon = "97",name = <<"七转·逸将"/utf8>>,model_id = 120111000,attr = [{1,5000},{2,100000},{3,2500},{4,2500}],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = []};

get_reincarnation_cfg(4,2,0) ->
	#reincarnation_cfg{career = 4,sex = 2,turn = 0,full_lv = 370,icon = "90",name = <<"弓手"/utf8>>,model_id = 120112000,attr = [],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = [{0,38420001,1}]};

get_reincarnation_cfg(4,2,1) ->
	#reincarnation_cfg{career = 4,sex = 2,turn = 1,full_lv = 370,icon = "91",name = <<"一转·弓道"/utf8>>,model_id = 120112000,attr = [{1,400},{2,8000},{3,200},{4,200}],unlock_skill = [],replace_skill = [],turn_skill = [{401010,2}],turn_cost = [{0,38420001,1}]};

get_reincarnation_cfg(4,2,2) ->
	#reincarnation_cfg{career = 4,sex = 2,turn = 2,full_lv = 370,icon = "92",name = <<"二转·猎霜"/utf8>>,model_id = 120112000,attr = [{1,800},{2,16000},{3,400},{4,400}],unlock_skill = [],replace_skill = [],turn_skill = [{402010,2}],turn_cost = [{0,38420002,1}]};

get_reincarnation_cfg(4,2,3) ->
	#reincarnation_cfg{career = 4,sex = 2,turn = 3,full_lv = 370,icon = "93",name = <<"三转·轻羽"/utf8>>,model_id = 120112000,attr = [{1,1600},{2,32000},{3,800},{4,800}],unlock_skill = [],replace_skill = [],turn_skill = [{402020,2}],turn_cost = []};

get_reincarnation_cfg(4,2,4) ->
	#reincarnation_cfg{career = 4,sex = 2,turn = 4,full_lv = 520,icon = "94",name = <<"四转·冷凝"/utf8>>,model_id = 120112000,attr = [{1,2400},{2,48000},{3,1200},{4,1200}],unlock_skill = [],replace_skill = [],turn_skill = [{402030,2}],turn_cost = []};

get_reincarnation_cfg(4,2,5) ->
	#reincarnation_cfg{career = 4,sex = 2,turn = 5,full_lv = 630,icon = "95",name = <<"五转·穿云"/utf8>>,model_id = 120112000,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],unlock_skill = [],replace_skill = [],turn_skill = [{402040,2}],turn_cost = []};

get_reincarnation_cfg(4,2,6) ->
	#reincarnation_cfg{career = 4,sex = 2,turn = 6,full_lv = 720,icon = "96",name = <<"六转·弓取"/utf8>>,model_id = 120112000,attr = [{1,4000},{2,80000},{3,2000},{4,2000}],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = []};

get_reincarnation_cfg(4,2,7) ->
	#reincarnation_cfg{career = 4,sex = 2,turn = 7,full_lv = 840,icon = "97",name = <<"七转·清名"/utf8>>,model_id = 120112000,attr = [{1,5000},{2,100000},{3,2500},{4,2500}],unlock_skill = [],replace_skill = [],turn_skill = [],turn_cost = []};

get_reincarnation_cfg(_Career,_Sex,_Turn) ->
	[].

get_reincarnation_attr(1,1,0) ->
[];

get_reincarnation_attr(1,1,1) ->
[{1,400},{2,8000},{3,200},{4,200}];

get_reincarnation_attr(1,1,2) ->
[{1,800},{2,16000},{3,400},{4,400}];

get_reincarnation_attr(1,1,3) ->
[{1,1600},{2,32000},{3,800},{4,800}];

get_reincarnation_attr(1,1,4) ->
[{1,2400},{2,48000},{3,1200},{4,1200}];

get_reincarnation_attr(1,1,5) ->
[{1,4000},{2,80000},{3,2000},{4,2000}];

get_reincarnation_attr(1,1,6) ->
[{1,4000},{2,80000},{3,2000},{4,2000}];

get_reincarnation_attr(1,1,7) ->
[{1,5000},{2,100000},{3,2500},{4,2500}];

get_reincarnation_attr(2,2,0) ->
[];

get_reincarnation_attr(2,2,1) ->
[{1,400},{2,8000},{3,200},{4,200}];

get_reincarnation_attr(2,2,2) ->
[{1,800},{2,16000},{3,400},{4,400}];

get_reincarnation_attr(2,2,3) ->
[{1,1600},{2,32000},{3,800},{4,800}];

get_reincarnation_attr(2,2,4) ->
[{1,2400},{2,48000},{3,1200},{4,1200}];

get_reincarnation_attr(2,2,5) ->
[{1,4000},{2,80000},{3,2000},{4,2000}];

get_reincarnation_attr(2,2,6) ->
[{1,4000},{2,80000},{3,2000},{4,2000}];

get_reincarnation_attr(2,2,7) ->
[{1,5000},{2,100000},{3,2500},{4,2500}];

get_reincarnation_attr(3,1,0) ->
[];

get_reincarnation_attr(3,1,1) ->
[{1,400},{2,8000},{3,200},{4,200}];

get_reincarnation_attr(3,1,2) ->
[{1,800},{2,16000},{3,400},{4,400}];

get_reincarnation_attr(3,1,3) ->
[{1,1600},{2,32000},{3,800},{4,800}];

get_reincarnation_attr(3,1,4) ->
[{1,2400},{2,48000},{3,1200},{4,1200}];

get_reincarnation_attr(3,1,5) ->
[{1,4000},{2,80000},{3,2000},{4,2000}];

get_reincarnation_attr(3,1,6) ->
[{1,4000},{2,80000},{3,2000},{4,2000}];

get_reincarnation_attr(3,1,7) ->
[{1,5000},{2,100000},{3,2500},{4,2500}];

get_reincarnation_attr(4,2,0) ->
[];

get_reincarnation_attr(4,2,1) ->
[{1,400},{2,8000},{3,200},{4,200}];

get_reincarnation_attr(4,2,2) ->
[{1,800},{2,16000},{3,400},{4,400}];

get_reincarnation_attr(4,2,3) ->
[{1,1600},{2,32000},{3,800},{4,800}];

get_reincarnation_attr(4,2,4) ->
[{1,2400},{2,48000},{3,1200},{4,1200}];

get_reincarnation_attr(4,2,5) ->
[{1,4000},{2,80000},{3,2000},{4,2000}];

get_reincarnation_attr(4,2,6) ->
[{1,4000},{2,80000},{3,2000},{4,2000}];

get_reincarnation_attr(4,2,7) ->
[{1,5000},{2,100000},{3,2500},{4,2500}];

get_reincarnation_attr(_Career,_Sex,_Turn) ->
	[].

get_reincarnation_reskill(1,1,0) ->
[];

get_reincarnation_reskill(1,1,1) ->
[];

get_reincarnation_reskill(1,1,2) ->
[];

get_reincarnation_reskill(1,1,3) ->
[];

get_reincarnation_reskill(1,1,4) ->
[];

get_reincarnation_reskill(1,1,5) ->
[];

get_reincarnation_reskill(1,1,6) ->
[];

get_reincarnation_reskill(1,1,7) ->
[];

get_reincarnation_reskill(2,2,0) ->
[];

get_reincarnation_reskill(2,2,1) ->
[];

get_reincarnation_reskill(2,2,2) ->
[];

get_reincarnation_reskill(2,2,3) ->
[];

get_reincarnation_reskill(2,2,4) ->
[];

get_reincarnation_reskill(2,2,5) ->
[];

get_reincarnation_reskill(2,2,6) ->
[];

get_reincarnation_reskill(2,2,7) ->
[];

get_reincarnation_reskill(3,1,0) ->
[];

get_reincarnation_reskill(3,1,1) ->
[];

get_reincarnation_reskill(3,1,2) ->
[];

get_reincarnation_reskill(3,1,3) ->
[];

get_reincarnation_reskill(3,1,4) ->
[];

get_reincarnation_reskill(3,1,5) ->
[];

get_reincarnation_reskill(3,1,6) ->
[];

get_reincarnation_reskill(3,1,7) ->
[];

get_reincarnation_reskill(4,2,0) ->
[];

get_reincarnation_reskill(4,2,1) ->
[];

get_reincarnation_reskill(4,2,2) ->
[];

get_reincarnation_reskill(4,2,3) ->
[];

get_reincarnation_reskill(4,2,4) ->
[];

get_reincarnation_reskill(4,2,5) ->
[];

get_reincarnation_reskill(4,2,6) ->
[];

get_reincarnation_reskill(4,2,7) ->
[];

get_reincarnation_reskill(_Career,_Sex,_Turn) ->
	[].

get_turn_list(1,1) ->
[0,1,2,3,4,5,6,7];

get_turn_list(2,2) ->
[0,1,2,3,4,5,6,7];

get_turn_list(3,1) ->
[0,1,2,3,4,5,6,7];

get_turn_list(4,2) ->
[0,1,2,3,4,5,6,7];

get_turn_list(_Career,_Sex) ->
	[].

get_reincarnation_task_cfg(301101) ->
	#reincarnation_task_cfg{task_id = 301101,turn = 1,stage = 1,finish_lv = 0,attr = []};

get_reincarnation_task_cfg(301102) ->
	#reincarnation_task_cfg{task_id = 301102,turn = 1,stage = 2,finish_lv = 0,attr = []};

get_reincarnation_task_cfg(301103) ->
	#reincarnation_task_cfg{task_id = 301103,turn = 1,stage = 3,finish_lv = 0,attr = []};

get_reincarnation_task_cfg(301200) ->
	#reincarnation_task_cfg{task_id = 301200,turn = 2,stage = 1,finish_lv = 0,attr = []};

get_reincarnation_task_cfg(301201) ->
	#reincarnation_task_cfg{task_id = 301201,turn = 2,stage = 2,finish_lv = 0,attr = []};

get_reincarnation_task_cfg(301202) ->
	#reincarnation_task_cfg{task_id = 301202,turn = 2,stage = 3,finish_lv = 0,attr = []};

get_reincarnation_task_cfg(301300) ->
	#reincarnation_task_cfg{task_id = 301300,turn = 3,stage = 1,finish_lv = 0,attr = []};

get_reincarnation_task_cfg(301301) ->
	#reincarnation_task_cfg{task_id = 301301,turn = 3,stage = 2,finish_lv = 0,attr = []};

get_reincarnation_task_cfg(301302) ->
	#reincarnation_task_cfg{task_id = 301302,turn = 3,stage = 3,finish_lv = 0,attr = []};

get_reincarnation_task_cfg(301400) ->
	#reincarnation_task_cfg{task_id = 301400,turn = 4,stage = 1,finish_lv = 370,attr = []};

get_reincarnation_task_cfg(301500) ->
	#reincarnation_task_cfg{task_id = 301500,turn = 5,stage = 1,finish_lv = 520,attr = []};

get_reincarnation_task_cfg(301600) ->
	#reincarnation_task_cfg{task_id = 301600,turn = 6,stage = 1,finish_lv = 0,attr = []};

get_reincarnation_task_cfg(301700) ->
	#reincarnation_task_cfg{task_id = 301700,turn = 7,stage = 1,finish_lv = 0,attr = []};

get_reincarnation_task_cfg(_Taskid) ->
	[].

get_all_task_ids() ->
[301101,301102,301103,301200,301201,301202,301300,301301,301302,301400,301500,301600,301700].

get_task_by_stage(1,1) ->
[301101];

get_task_by_stage(1,2) ->
[301102];

get_task_by_stage(1,3) ->
[301103];

get_task_by_stage(2,1) ->
[301200];

get_task_by_stage(2,2) ->
[301201];

get_task_by_stage(2,3) ->
[301202];

get_task_by_stage(3,1) ->
[301300];

get_task_by_stage(3,2) ->
[301301];

get_task_by_stage(3,3) ->
[301302];

get_task_by_stage(4,1) ->
[301400];

get_task_by_stage(5,1) ->
[301500];

get_task_by_stage(6,1) ->
[301600];

get_task_by_stage(7,1) ->
[301700];

get_task_by_stage(_Turn,_Stage) ->
	[].


get_task_by_turn(1) ->
[301101,301102,301103];


get_task_by_turn(2) ->
[301200,301201,301202];


get_task_by_turn(3) ->
[301300,301301,301302];


get_task_by_turn(4) ->
[301400];


get_task_by_turn(5) ->
[301500];


get_task_by_turn(6) ->
[301600];


get_task_by_turn(7) ->
[301700];

get_task_by_turn(_Turn) ->
	[].

get_max_stage_by_turn(1) -> 3;
get_max_stage_by_turn(2) -> 3;
get_max_stage_by_turn(3) -> 3;
get_max_stage_by_turn(4) -> 1;
get_max_stage_by_turn(5) -> 1;
get_max_stage_by_turn(6) -> 1;
get_max_stage_by_turn(7) -> 1;
get_max_stage_by_turn(_Turn) -> 0.

