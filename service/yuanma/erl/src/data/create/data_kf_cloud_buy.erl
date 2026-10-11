%%%---------------------------------------
%%% module      : data_kf_cloud_buy
%%% description : 跨服云购配置
%%%
%%%---------------------------------------
-module(data_kf_cloud_buy).
-compile(export_all).
-include("kf_cloud_buy.hrl").



get_act_cfg(1,1) ->
	#base_cld_buy_act{type = 1,subtype = 1,start_time = 1579636800,end_time = 1579795199,op_days = [{2,999}],merge_days = [],big_rewards = [{0,[2]}],reset_type = 2,buy_endtime = [{23,0,0}]};

get_act_cfg(1,2) ->
	#base_cld_buy_act{type = 1,subtype = 2,start_time = 1580068800,end_time = 1580227199,op_days = [{2,999}],merge_days = [],big_rewards = [{0,[2]}],reset_type = 2,buy_endtime = [{23,0,0}]};

get_act_cfg(2,1) ->
	#base_cld_buy_act{type = 2,subtype = 1,start_time = 1579636800,end_time = 1579795199,op_days = [{2,999}],merge_days = [],big_rewards = [{0,[1]}],reset_type = 2,buy_endtime = [{23,0,0}]};

get_act_cfg(2,2) ->
	#base_cld_buy_act{type = 2,subtype = 2,start_time = 1580068800,end_time = 1580227199,op_days = [{2,999}],merge_days = [],big_rewards = [{0,[1]}],reset_type = 2,buy_endtime = [{23,0,0}]};

get_act_cfg(_Type,_Subtype) ->
	[].

get_act_list() ->
[{1,1},{1,2},{2,1},{2,2}].

get_act_grade_cfg(1) ->
	#base_cld_buy_big_reward{grade_id = 1,rewards = [{0,32060069,1}],all_count = 60,costs = [{1,0,20}],pool_id = 1,rewards_show = [18020002,20020002,19020002,14010002,14020002,36255007,36255008,36255009,18020001,20020001,19020001,18010001,18010002,19010001,19010002,20010001,20010002,32060067]};

get_act_grade_cfg(2) ->
	#base_cld_buy_big_reward{grade_id = 2,rewards = [{0,32060070,1}],all_count = 60,costs = [{2,0,20}],pool_id = 2,rewards_show = [18020001,20020001,19020001,14010001,14020001,56010001,56010002,56010003,56010004,18010001,18010002,19010001,19010002,20010001,20010002,32010095,32060065,32060066]};

get_act_grade_cfg(_Gradeid) ->
	[].


get_reward_pool_list(1) ->
[{1,0,0,500,0,[{0,18020002,1}]},{2,0,0,500,0,[{0,20020002,1}]},{3,0,0,500,0,[{0,19020002,1}]},{4,0,0,1200,0,[{0,14010002,1}]},{5,0,0,1200,0,[{0,14020002,1}]},{6,0,0,1000,0,[{0,36255007,1}]},{7,0,0,700,0,[{0,36255008,1}]},{8,0,0,400,0,[{0,36255009,1}]},{9,0,0,1000,0,[{0,18020001,2}]},{10,0,0,1000,0,[{0,20020001,2}]},{11,0,0,1000,0,[{0,19020001,2}]},{12,0,0,170,0,[{0,18010001,1}]},{13,0,0,170,0,[{0,18010002,1}]},{14,0,0,160,0,[{0,19010001,1}]},{15,0,0,160,0,[{0,19010002,1}]},{16,0,0,160,0,[{0,20010001,1}]},{17,0,0,160,0,[{0,20010002,1}]},{18,0,0,20,0,[{0,32060067,1}]}];


get_reward_pool_list(2) ->
[{1,0,0,800,0,[{0,18020001,1}]},{2,0,0,800,0,[{0,20020001,1}]},{3,0,0,800,0,[{0,19020001,1}]},{4,0,0,1000,0,[{0,14010001,1}]},{5,0,0,1000,0,[{0,14020001,1}]},{6,0,0,1000,0,[{0,56010001,1}]},{7,0,0,1000,0,[{0,56010002,1}]},{8,0,0,1000,0,[{0,56010003,1}]},{9,0,0,1000,0,[{0,56010004,1}]},{10,0,0,100,0,[{0,18010001,1}]},{11,0,0,100,0,[{0,18010002,1}]},{12,0,0,100,0,[{0,19010001,1}]},{13,0,0,100,0,[{0,19010002,1}]},{14,0,0,100,0,[{0,20010001,1}]},{15,0,0,100,0,[{0,20010002,1}]},{16,0,0,1000,0,[{0,32010095,1}]},{17,0,0,10,0,[{0,32060065,1}]},{18,0,0,10,0,[{0,32060066,1}]}];

get_reward_pool_list(_Poolid) ->
	[].

get_stage_count_wlv_list(1,15) ->
[0];

get_stage_count_wlv_list(1,30) ->
[0];

get_stage_count_wlv_list(1,60) ->
[0];

get_stage_count_wlv_list(1,120) ->
[0];

get_stage_count_wlv_list(2,5) ->
[0];

get_stage_count_wlv_list(2,10) ->
[0];

get_stage_count_wlv_list(2,20) ->
[0];

get_stage_count_wlv_list(2,40) ->
[0];

get_stage_count_wlv_list(_Type,_Count) ->
	[].

get_stage_reward_list(1,15,0) ->
[{0,32060063,1}];

get_stage_reward_list(1,30,0) ->
[{0,32060063,1}];

get_stage_reward_list(1,60,0) ->
[{0,32060063,1}];

get_stage_reward_list(1,120,0) ->
[{0,32060063,1}];

get_stage_reward_list(2,5,0) ->
[{0,32060062,1}];

get_stage_reward_list(2,10,0) ->
[{0,32060062,1}];

get_stage_reward_list(2,20,0) ->
[{0,32060062,1}];

get_stage_reward_list(2,40,0) ->
[{0,32060062,1}];

get_stage_reward_list(_Type,_Count,_Wlv) ->
	[].


get_stage_count_list(1) ->
[15,30,60,120];


get_stage_count_list(2) ->
[5,10,20,40];

get_stage_count_list(_Type) ->
	[].

