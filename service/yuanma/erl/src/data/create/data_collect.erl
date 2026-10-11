%%%---------------------------------------
%%% module      : data_collect
%%% description : 收集活动配置
%%%
%%%---------------------------------------
-module(data_collect).
-compile(export_all).
-include("collect.hrl").



get_collect_all_reward_con(1,1) ->
	#collect_all_reward_con{subtype = 1,reward_id = 1,type = 2,point = 150,time = 43200,goods_list = []};

get_collect_all_reward_con(1,2) ->
	#collect_all_reward_con{subtype = 1,reward_id = 2,type = 4,point = 300,time = 0,goods_list = [{100,14010003,1},{100,32010047,1},{100,38040036,2}]};

get_collect_all_reward_con(1,3) ->
	#collect_all_reward_con{subtype = 1,reward_id = 3,type = 1,point = 750,time = 14400,goods_list = []};

get_collect_all_reward_con(1,4) ->
	#collect_all_reward_con{subtype = 1,reward_id = 4,type = 3,point = 1500,time = 0,goods_list = []};

get_collect_all_reward_con(1,5) ->
	#collect_all_reward_con{subtype = 1,reward_id = 5,type = 4,point = 2400,time = 0,goods_list = [{100,14020003,1},{100,32010044,1},{100,38040036,4}]};

get_collect_all_reward_con(_Subtype,_Rewardid) ->
	[].


get_collect_all_reward_point_list(1) ->
[{150,1},{300,2},{750,3},{1500,4},{2400,5}];

get_collect_all_reward_point_list(_Subtype) ->
	[].

get_collect_self_reward_con(1,1,1) ->
	#collect_self_reward_con{subtype = 1,type = 1,reward_id = 1,weight = 10,goods_list = [{100,32010031,1}],stage_points = 0};

get_collect_self_reward_con(1,1,2) ->
	#collect_self_reward_con{subtype = 1,type = 1,reward_id = 2,weight = 10,goods_list = [{100,32010032,1}],stage_points = 0};

get_collect_self_reward_con(1,1,3) ->
	#collect_self_reward_con{subtype = 1,type = 1,reward_id = 3,weight = 5,goods_list = [{100,32010033,1}],stage_points = 0};

get_collect_self_reward_con(1,1,4) ->
	#collect_self_reward_con{subtype = 1,type = 1,reward_id = 4,weight = 10,goods_list = [{100,32010048,1}],stage_points = 0};

get_collect_self_reward_con(1,1,5) ->
	#collect_self_reward_con{subtype = 1,type = 1,reward_id = 5,weight = 10,goods_list = [{100,32010041,1}],stage_points = 0};

get_collect_self_reward_con(1,1,6) ->
	#collect_self_reward_con{subtype = 1,type = 1,reward_id = 6,weight = 5,goods_list = [{100,32010042,1}],stage_points = 0};

get_collect_self_reward_con(1,1,7) ->
	#collect_self_reward_con{subtype = 1,type = 1,reward_id = 7,weight = 10,goods_list = [{100,38040002,1}],stage_points = 0};

get_collect_self_reward_con(1,1,8) ->
	#collect_self_reward_con{subtype = 1,type = 1,reward_id = 8,weight = 10,goods_list = [{100,38100001,1}],stage_points = 0};

get_collect_self_reward_con(1,1,9) ->
	#collect_self_reward_con{subtype = 1,type = 1,reward_id = 9,weight = 20,goods_list = [{100,38040003,1}],stage_points = 0};

get_collect_self_reward_con(1,1,10) ->
	#collect_self_reward_con{subtype = 1,type = 1,reward_id = 10,weight = 10,goods_list = [{100,37020001,1}],stage_points = 0};

get_collect_self_reward_con(1,2,1) ->
	#collect_self_reward_con{subtype = 1,type = 2,reward_id = 1,weight = 1,goods_list = [{100,12020008,1}],stage_points = 68};

get_collect_self_reward_con(1,2,2) ->
	#collect_self_reward_con{subtype = 1,type = 2,reward_id = 2,weight = 2,goods_list = [{100,12010008,1}],stage_points = 168};

get_collect_self_reward_con(1,2,3) ->
	#collect_self_reward_con{subtype = 1,type = 2,reward_id = 3,weight = 5,goods_list = [{100,12030008,1}],stage_points = 288};

get_collect_self_reward_con(1,2,4) ->
	#collect_self_reward_con{subtype = 1,type = 2,reward_id = 4,weight = 2,goods_list = [{100,12040008,1}],stage_points = 428};

get_collect_self_reward_con(_Subtype,_Type,_Rewardid) ->
	[].

get_collect_self_weight_list(1,1) ->
[{10,1},{10,2},{5,3},{10,4},{10,5},{5,6},{10,7},{10,8},{20,9},{10,10}];

get_collect_self_weight_list(1,2) ->
[{1,1},{2,2},{5,3},{2,4}];

get_collect_self_weight_list(_Subtype,_Type) ->
	[].

get_collect_self_stage_list(1,1) ->
[0];

get_collect_self_stage_list(1,2) ->
[68,168,288,428];

get_collect_self_stage_list(_Subtype,_Type) ->
	[].

