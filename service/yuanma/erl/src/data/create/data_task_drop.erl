%%%---------------------------------------
%%% module      : data_task_drop
%%% description : 任务掉落配置
%%%
%%%---------------------------------------
-module(data_task_drop).
-compile(export_all).
-include("drop.hrl").



get_drop(_) ->
	[].

get_drop_id_list(_Monid) ->
	[].

get_alloc_list(_Monid) ->
	[].

get_task_id_list() -> [].
get_task_func_drop(2,301100) ->
	#base_task_func_drop{type = 2,task_id = 301100,mon_lv = 100,reward_type = 1,reward_list = []};

get_task_func_drop(_Type,_Taskid) ->
	[].

get_task_func_task_id_list() ->
[301100].


get_task_func_task_id_list(2) ->
[301100];

get_task_func_task_id_list(_Type) ->
	[].

get_task_stage_func_drop(2,301102,0,1) ->
	#base_task_stage_func_drop{type = 2,task_id = 301102,stage = 0,scene_type = 1,condition = [],mon_lv = 130,drop_way = 0,reward_type = 1,reward_list = [{2000,[{0,38110013,1}]},{8000,[]}]};

get_task_stage_func_drop(2,301102,0,2) ->
	#base_task_stage_func_drop{type = 2,task_id = 301102,stage = 0,scene_type = 2,condition = [{dun_id,[10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016]}],mon_lv = 150,drop_way = 0,reward_type = 0,reward_list = [{0,38110013,15}]};

get_task_stage_func_drop(2,301102,0,12) ->
	#base_task_stage_func_drop{type = 2,task_id = 301102,stage = 0,scene_type = 12,condition = [],mon_lv = 150,drop_way = 0,reward_type = 0,reward_list = [{0,38110013,15}]};

get_task_stage_func_drop(2,301102,0,16) ->
	#base_task_stage_func_drop{type = 2,task_id = 301102,stage = 0,scene_type = 16,condition = [],mon_lv = 150,drop_way = 0,reward_type = 0,reward_list = [{0,38110013,15}]};

get_task_stage_func_drop(2,301102,0,22) ->
	#base_task_stage_func_drop{type = 2,task_id = 301102,stage = 0,scene_type = 22,condition = [],mon_lv = 150,drop_way = 0,reward_type = 0,reward_list = [{0,38110013,15}]};

get_task_stage_func_drop(2,301102,0,34) ->
	#base_task_stage_func_drop{type = 2,task_id = 301102,stage = 0,scene_type = 34,condition = [],mon_lv = 150,drop_way = 0,reward_type = 0,reward_list = [{0,38110013,15}]};

get_task_stage_func_drop(2,301201,0,1) ->
	#base_task_stage_func_drop{type = 2,task_id = 301201,stage = 0,scene_type = 1,condition = [],mon_lv = 200,drop_way = 0,reward_type = 1,reward_list = [{500,[{0,38110015,1}]},{9500,[]}]};

get_task_stage_func_drop(2,301201,0,2) ->
	#base_task_stage_func_drop{type = 2,task_id = 301201,stage = 0,scene_type = 2,condition = [{dun_id,[10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016]}],mon_lv = 220,drop_way = 0,reward_type = 0,reward_list = [{0,38110015,20}]};

get_task_stage_func_drop(2,301201,0,12) ->
	#base_task_stage_func_drop{type = 2,task_id = 301201,stage = 0,scene_type = 12,condition = [],mon_lv = 220,drop_way = 0,reward_type = 0,reward_list = [{0,38110015,20}]};

get_task_stage_func_drop(2,301201,0,16) ->
	#base_task_stage_func_drop{type = 2,task_id = 301201,stage = 0,scene_type = 16,condition = [],mon_lv = 220,drop_way = 0,reward_type = 0,reward_list = [{0,38110015,20}]};

get_task_stage_func_drop(2,301201,0,22) ->
	#base_task_stage_func_drop{type = 2,task_id = 301201,stage = 0,scene_type = 22,condition = [],mon_lv = 220,drop_way = 0,reward_type = 0,reward_list = [{0,38110015,20}]};

get_task_stage_func_drop(2,301201,0,34) ->
	#base_task_stage_func_drop{type = 2,task_id = 301201,stage = 0,scene_type = 34,condition = [],mon_lv = 220,drop_way = 0,reward_type = 0,reward_list = [{0,38110015,20}]};

get_task_stage_func_drop(2,301301,0,1) ->
	#base_task_stage_func_drop{type = 2,task_id = 301301,stage = 0,scene_type = 1,condition = [],mon_lv = 280,drop_way = 0,reward_type = 1,reward_list = [{50,[{0,38110017,1}]},{9950,[]}]};

get_task_stage_func_drop(2,301301,0,2) ->
	#base_task_stage_func_drop{type = 2,task_id = 301301,stage = 0,scene_type = 2,condition = [{dun_id,[10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016]}],mon_lv = 280,drop_way = 0,reward_type = 0,reward_list = [{0,38110017,5}]};

get_task_stage_func_drop(2,301301,0,12) ->
	#base_task_stage_func_drop{type = 2,task_id = 301301,stage = 0,scene_type = 12,condition = [],mon_lv = 280,drop_way = 0,reward_type = 0,reward_list = [{0,38110017,5}]};

get_task_stage_func_drop(2,301301,0,16) ->
	#base_task_stage_func_drop{type = 2,task_id = 301301,stage = 0,scene_type = 16,condition = [],mon_lv = 280,drop_way = 0,reward_type = 0,reward_list = [{0,38110017,5}]};

get_task_stage_func_drop(2,301301,0,22) ->
	#base_task_stage_func_drop{type = 2,task_id = 301301,stage = 0,scene_type = 22,condition = [],mon_lv = 280,drop_way = 0,reward_type = 0,reward_list = [{0,38110017,5}]};

get_task_stage_func_drop(2,301301,0,34) ->
	#base_task_stage_func_drop{type = 2,task_id = 301301,stage = 0,scene_type = 34,condition = [],mon_lv = 280,drop_way = 0,reward_type = 0,reward_list = [{0,38110017,5}]};

get_task_stage_func_drop(2,301400,0,2) ->
	#base_task_stage_func_drop{type = 2,task_id = 301400,stage = 0,scene_type = 2,condition = [{dun_id,[10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016]}],mon_lv = 350,drop_way = 0,reward_type = 3,reward_list = [{{0,9},[{5000,[{0,38110001,1}]},{5000,[]}]}]};

get_task_stage_func_drop(2,301400,0,12) ->
	#base_task_stage_func_drop{type = 2,task_id = 301400,stage = 0,scene_type = 12,condition = [],mon_lv = 350,drop_way = 0,reward_type = 3,reward_list = [{{0,9},[{10000,[{0,38110001,1}]},{0,[]}]}]};

get_task_stage_func_drop(2,301400,0,16) ->
	#base_task_stage_func_drop{type = 2,task_id = 301400,stage = 0,scene_type = 16,condition = [],mon_lv = 350,drop_way = 0,reward_type = 3,reward_list = [{{0,9},[{3000,[{0,38110001,1}]},{7000,[]}]}]};

get_task_stage_func_drop(2,301400,0,22) ->
	#base_task_stage_func_drop{type = 2,task_id = 301400,stage = 0,scene_type = 22,condition = [],mon_lv = 350,drop_way = 0,reward_type = 3,reward_list = [{{0,9},[{2000,[{0,38110001,1}]},{8000,[]}]}]};

get_task_stage_func_drop(2,301400,0,34) ->
	#base_task_stage_func_drop{type = 2,task_id = 301400,stage = 0,scene_type = 34,condition = [],mon_lv = 350,drop_way = 0,reward_type = 3,reward_list = [{{0,9},[{5000,[{0,38110001,1}]},{5000,[]}]}]};

get_task_stage_func_drop(2,301500,0,2) ->
	#base_task_stage_func_drop{type = 2,task_id = 301500,stage = 0,scene_type = 2,condition = [{dun_id,[10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016]}],mon_lv = 500,drop_way = 0,reward_type = 3,reward_list = [{{10,14},[{5000,[{0,38110002,1}]},{5000,[]}]},{{15,19},[{5000,[{0,38110003,1}]},{5000,[]}]},{{20,24},[{5000,[{0,38110004,1}]},{5000,[]}]}]};

get_task_stage_func_drop(2,301500,0,12) ->
	#base_task_stage_func_drop{type = 2,task_id = 301500,stage = 0,scene_type = 12,condition = [],mon_lv = 500,drop_way = 0,reward_type = 3,reward_list = [{{10,14},[{10000,[{0,38110002,1}]},{0,[]}]},{{15,19},[{10000,[{0,38110003,1}]},{0,[]}]},{{20,24},[{10000,[{0,38110004,1}]},{0,[]}]}]};

get_task_stage_func_drop(2,301500,0,16) ->
	#base_task_stage_func_drop{type = 2,task_id = 301500,stage = 0,scene_type = 16,condition = [],mon_lv = 500,drop_way = 0,reward_type = 3,reward_list = [{{10,14},[{3000,[{0,38110002,1}]},{7000,[]}]},{{15,19},[{3000,[{0,38110003,1}]},{7000,[]}]},{{20,24},[{3000,[{0,38110004,1}]},{7000,[]}]}]};

get_task_stage_func_drop(2,301500,0,34) ->
	#base_task_stage_func_drop{type = 2,task_id = 301500,stage = 0,scene_type = 34,condition = [],mon_lv = 500,drop_way = 0,reward_type = 3,reward_list = [{{10,14},[{5000,[{0,38110002,1}]},{5000,[]}]},{{15,19},[{5000,[{0,38110003,1}]},{5000,[]}]},{{20,24},[{5000,[{0,38110004,1}]},{5000,[]}]}]};

get_task_stage_func_drop(2,301500,0,43) ->
	#base_task_stage_func_drop{type = 2,task_id = 301500,stage = 0,scene_type = 43,condition = [],mon_lv = 500,drop_way = 0,reward_type = 3,reward_list = [{{10,14},[{5000,[{0,38110002,1}]},{5000,[]}]},{{15,19},[{5000,[{0,38110003,1}]},{5000,[]}]},{{20,24},[{5000,[{0,38110004,1}]},{5000,[]}]}]};

get_task_stage_func_drop(2,301500,0,45) ->
	#base_task_stage_func_drop{type = 2,task_id = 301500,stage = 0,scene_type = 45,condition = [],mon_lv = 500,drop_way = 0,reward_type = 3,reward_list = [{{10,14},[{10000,[{0,38110002,1}]},{0,[]}]},{{15,19},[{10000,[{0,38110003,1}]},{0,[]}]},{{20,24},[{10000,[{0,38110004,1}]},{0,[]}]}]};

get_task_stage_func_drop(2,301600,0,2) ->
	#base_task_stage_func_drop{type = 2,task_id = 301600,stage = 0,scene_type = 2,condition = [{dun_id,[10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016]}],mon_lv = 550,drop_way = 0,reward_type = 3,reward_list = [{{25,44},[{5000,[{0,38110005,1}]},{5000,[]}]}]};

get_task_stage_func_drop(2,301600,0,12) ->
	#base_task_stage_func_drop{type = 2,task_id = 301600,stage = 0,scene_type = 12,condition = [],mon_lv = 550,drop_way = 0,reward_type = 3,reward_list = [{{25,44},[{10000,[{0,38110005,1}]},{0,[]}]}]};

get_task_stage_func_drop(2,301600,0,16) ->
	#base_task_stage_func_drop{type = 2,task_id = 301600,stage = 0,scene_type = 16,condition = [],mon_lv = 550,drop_way = 0,reward_type = 3,reward_list = [{{25,44},[{3000,[{0,38110005,1}]},{7000,[]}]}]};

get_task_stage_func_drop(2,301600,0,34) ->
	#base_task_stage_func_drop{type = 2,task_id = 301600,stage = 0,scene_type = 34,condition = [],mon_lv = 550,drop_way = 0,reward_type = 3,reward_list = [{{25,44},[{5000,[{0,38110005,1}]},{5000,[]}]}]};

get_task_stage_func_drop(2,301600,0,43) ->
	#base_task_stage_func_drop{type = 2,task_id = 301600,stage = 0,scene_type = 43,condition = [],mon_lv = 550,drop_way = 0,reward_type = 3,reward_list = [{{25,44},[{5000,[{0,38110005,1}]},{5000,[]}]}]};

get_task_stage_func_drop(2,301600,0,45) ->
	#base_task_stage_func_drop{type = 2,task_id = 301600,stage = 0,scene_type = 45,condition = [],mon_lv = 550,drop_way = 0,reward_type = 3,reward_list = [{{25,44},[{10000,[{0,38110005,1}]},{0,[]}]}]};

get_task_stage_func_drop(2,301700,0,2) ->
	#base_task_stage_func_drop{type = 2,task_id = 301700,stage = 0,scene_type = 2,condition = [{dun_id,[10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016]}],mon_lv = 650,drop_way = 0,reward_type = 3,reward_list = [{{45,64},[{5000,[{0,38110009,1}]},{5000,[]}]}]};

get_task_stage_func_drop(2,301700,0,12) ->
	#base_task_stage_func_drop{type = 2,task_id = 301700,stage = 0,scene_type = 12,condition = [],mon_lv = 650,drop_way = 0,reward_type = 3,reward_list = [{{45,64},[{10000,[{0,38110009,1}]},{0,[]}]}]};

get_task_stage_func_drop(2,301700,0,16) ->
	#base_task_stage_func_drop{type = 2,task_id = 301700,stage = 0,scene_type = 16,condition = [],mon_lv = 650,drop_way = 0,reward_type = 3,reward_list = [{{45,64},[{3000,[{0,38110009,1}]},{7000,[]}]}]};

get_task_stage_func_drop(2,301700,0,34) ->
	#base_task_stage_func_drop{type = 2,task_id = 301700,stage = 0,scene_type = 34,condition = [],mon_lv = 650,drop_way = 0,reward_type = 3,reward_list = [{{45,64},[{5000,[{0,38110009,1}]},{5000,[]}]}]};

get_task_stage_func_drop(2,301700,0,43) ->
	#base_task_stage_func_drop{type = 2,task_id = 301700,stage = 0,scene_type = 43,condition = [],mon_lv = 650,drop_way = 0,reward_type = 3,reward_list = [{{45,64},[{5000,[{0,38110009,1}]},{5000,[]}]}]};

get_task_stage_func_drop(2,301700,0,45) ->
	#base_task_stage_func_drop{type = 2,task_id = 301700,stage = 0,scene_type = 45,condition = [],mon_lv = 650,drop_way = 0,reward_type = 3,reward_list = [{{45,64},[{10000,[{0,38110009,1}]},{0,[]}]}]};

get_task_stage_func_drop(2,2001200,0,1) ->
	#base_task_stage_func_drop{type = 2,task_id = 2001200,stage = 0,scene_type = 1,condition = [],mon_lv = 130,drop_way = 0,reward_type = 1,reward_list = [{500,[{0,38190010,1}]},{9500,[]}]};

get_task_stage_func_drop(2,2001400,0,34) ->
	#base_task_stage_func_drop{type = 2,task_id = 2001400,stage = 0,scene_type = 34,condition = [],mon_lv = 130,drop_way = 0,reward_type = 0,reward_list = [{0,38190011,1}]};

get_task_stage_func_drop(2,2002200,0,34) ->
	#base_task_stage_func_drop{type = 2,task_id = 2002200,stage = 0,scene_type = 34,condition = [],mon_lv = 190,drop_way = 0,reward_type = 0,reward_list = [{0,38190012,1}]};

get_task_stage_func_drop(3,301102,0,0) ->
	#base_task_stage_func_drop{type = 3,task_id = 301102,stage = 0,scene_type = 0,condition = [],mon_lv = 0,drop_way = 1,reward_type = 1,reward_list = [{1000,[{0,38110013,1}]},{9000,[]}]};

get_task_stage_func_drop(3,301201,0,0) ->
	#base_task_stage_func_drop{type = 3,task_id = 301201,stage = 0,scene_type = 0,condition = [],mon_lv = 0,drop_way = 1,reward_type = 1,reward_list = [{400,[{0,38110015,1}]},{9600,[]}]};

get_task_stage_func_drop(3,301301,0,0) ->
	#base_task_stage_func_drop{type = 3,task_id = 301301,stage = 0,scene_type = 0,condition = [],mon_lv = 0,drop_way = 1,reward_type = 1,reward_list = [{50,[{0,38110017,1}]},{9950,[]}]};

get_task_stage_func_drop(3,301400,0,0) ->
	#base_task_stage_func_drop{type = 3,task_id = 301400,stage = 0,scene_type = 0,condition = [],mon_lv = 0,drop_way = 0,reward_type = 3,reward_list = [{{0,10},[{86,[{0,38110001,1}]},{99914,[]}]}]};

get_task_stage_func_drop(3,301500,0,0) ->
	#base_task_stage_func_drop{type = 3,task_id = 301500,stage = 0,scene_type = 0,condition = [],mon_lv = 0,drop_way = 0,reward_type = 3,reward_list = [{{10,14},[{170,[{0,38110002,1}]},{99830,[]}]},{{15,19},[{90,[{0,38110003,1}]},{99910,[]}]},{{20,24},[{60,[{0,38110004,1}]},{99940,[]}]}]};

get_task_stage_func_drop(_Type,_Taskid,_Stage,_Scenetype) ->
	[].

get_task_func_task_stage_list() ->
[{301102,0},{301201,0},{301301,0},{301400,0},{301500,0},{301600,0},{301700,0},{2001200,0},{2001400,0},{2002200,0}].


get_task_func_task_stage_list(2) ->
[{301102,0},{301201,0},{301301,0},{301400,0},{301500,0},{301600,0},{301700,0},{2001200,0},{2001400,0},{2002200,0}];


get_task_func_task_stage_list(3) ->
[{301102,0},{301201,0},{301301,0},{301400,0},{301500,0}];

get_task_func_task_stage_list(_Type) ->
	[].


get_task_func_scene_type_list(2) ->
[1,2,12,16,22,34,43,45];


get_task_func_scene_type_list(3) ->
[0];

get_task_func_scene_type_list(_Type) ->
	[].

