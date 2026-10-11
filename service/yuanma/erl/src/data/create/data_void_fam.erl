%%%---------------------------------------
%%% module      : data_void_fam
%%% description : 虚空秘境配置
%%%
%%%---------------------------------------
-module(data_void_fam).
-compile(export_all).
-include("void_fam.hrl").




get_cfg(need_role_lv) ->
115;


get_cfg(kill_player_score) ->
2;


get_cfg(kill_mon_score) ->
1;


get_cfg(reward_preview) ->
[{0,32020001,1},{0,22010001,1},{0,24010001,1}];


get_cfg(special_pass_no) ->
[6,16,26,36,66];


get_cfg(pass_exit_count_down) ->
10;


get_cfg(kf_act_min_opday) ->
14;

get_cfg(_Key) ->
	0.

get_floor_cfg(1) ->
	#void_fam_floor_cfg{floor = 1,scene = 4001,kf_scene = 4011,score = 3,reward = [{0,22010001,1}]};

get_floor_cfg(2) ->
	#void_fam_floor_cfg{floor = 2,scene = 4002,kf_scene = 4012,score = 4,reward = [{0,22010001,2}]};

get_floor_cfg(3) ->
	#void_fam_floor_cfg{floor = 3,scene = 4003,kf_scene = 4013,score = 5,reward = [{0,32020001,1},{0,22010001,1}]};

get_floor_cfg(4) ->
	#void_fam_floor_cfg{floor = 4,scene = 4004,kf_scene = 4014,score = 7,reward = [{0,24010001,1}]};

get_floor_cfg(5) ->
	#void_fam_floor_cfg{floor = 5,scene = 4005,kf_scene = 4015,score = 9,reward = [{0,24010001,1},{0,22010001,1}]};

get_floor_cfg(6) ->
	#void_fam_floor_cfg{floor = 6,scene = 4006,kf_scene = 4016,score = 11,reward = [{0,32020001,1},{0,22010001,2}]};

get_floor_cfg(7) ->
	#void_fam_floor_cfg{floor = 7,scene = 4007,kf_scene = 4017,score = 13,reward = [{0,24010001,1},{0,22010001,1}]};

get_floor_cfg(8) ->
	#void_fam_floor_cfg{floor = 8,scene = 4008,kf_scene = 4018,score = 15,reward = [{0,24010001,1},{0,22010001,1}]};

get_floor_cfg(9) ->
	#void_fam_floor_cfg{floor = 9,scene = 4009,kf_scene = 4019,score = 17,reward = [{0,32020001,1},{0,22010001,3}]};

get_floor_cfg(_Floor) ->
	[].

get_all_floor() ->
[9,8,7,6,5,4,3,2,1].

get_scene() ->
[4001,4002,4003,4004,4005,4006,4007,4008,4009].

get_kf_scene() ->
[4011,4012,4013,4014,4015,4016,4017,4018,4019].


get_pass_reward(1) ->
[{0,32020001,1},{0,24010001,3}];


get_pass_reward(2) ->
[{0,32020001,1},{0,24010001,2}];


get_pass_reward(3) ->
[{0,32020001,1},{0,24010001,1}];


get_pass_reward(4) ->
[{0,32020001,1}];

get_pass_reward(_Id) ->
	[].

