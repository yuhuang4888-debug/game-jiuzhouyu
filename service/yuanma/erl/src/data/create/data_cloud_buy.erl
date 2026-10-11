%%%---------------------------------------
%%% module      : data_cloud_buy
%%% description : 众仙云购配置
%%%
%%%---------------------------------------
-module(data_cloud_buy).
-compile(export_all).
-include("cloud_buy.hrl").



get(_) ->
	[].

get_big_award_ids() ->
[].

get_cloud_buy_reward_con(_) ->
	[].

get_reward_cfg(1) ->
	#big_award_cfg{id = 1,reward = [{0,26070005,1}],num = 300,cost = [{1,0,20}],value = 6000,reward_pool = 1,award_num = 1};

get_reward_cfg(2) ->
	#big_award_cfg{id = 2,reward = [{0,26070005,1}],num = 300,cost = [{1,0,20}],value = 6000,reward_pool = 1,award_num = 1};

get_reward_cfg(3) ->
	#big_award_cfg{id = 3,reward = [{0,16030103,30}],num = 300,cost = [{1,0,20}],value = 10000,reward_pool = 1,award_num = 1};

get_reward_cfg(4) ->
	#big_award_cfg{id = 4,reward = [{0,16030103,30}],num = 300,cost = [{1,0,20}],value = 10000,reward_pool = 1,award_num = 1};

get_reward_cfg(5) ->
	#big_award_cfg{id = 5,reward = [{0,17030103,30}],num = 300,cost = [{1,0,20}],value = 10000,reward_pool = 1,award_num = 1};

get_reward_cfg(6) ->
	#big_award_cfg{id = 6,reward = [{0,17030103,30}],num = 300,cost = [{1,0,20}],value = 10000,reward_pool = 1,award_num = 1};

get_reward_cfg(7) ->
	#big_award_cfg{id = 7,reward = [{0,101055083,1}],num = 300,cost = [{1,0,20}],value = 10000,reward_pool = 1,award_num = 1};

get_reward_cfg(8) ->
	#big_award_cfg{id = 8,reward = [{0,101055083,1}],num = 300,cost = [{1,0,20}],value = 10000,reward_pool = 1,award_num = 1};

get_reward_cfg(_Id) ->
	#big_award_cfg{}.

get_all_big_award() ->
[1,2,3,4,5,6,7,8].

get_pool(1,1) ->
	#reward_pool_cfg{id = 1,reward_id = 1,begin_times = 0,end_times = 0,weight = 17700,special_weight = 0,reward = [{0,16020002 ,1}]};

get_pool(1,2) ->
	#reward_pool_cfg{id = 1,reward_id = 2,begin_times = 0,end_times = 0,weight = 17700,special_weight = 0,reward = [{0,17020002 ,1}]};

get_pool(1,3) ->
	#reward_pool_cfg{id = 1,reward_id = 3,begin_times = 0,end_times = 0,weight = 1000,special_weight = 0,reward = [{0,18010001 ,1}]};

get_pool(1,4) ->
	#reward_pool_cfg{id = 1,reward_id = 4,begin_times = 0,end_times = 0,weight = 1000,special_weight = 0,reward = [{0,19010001 ,1}]};

get_pool(1,5) ->
	#reward_pool_cfg{id = 1,reward_id = 5,begin_times = 0,end_times = 0,weight = 1000,special_weight = 0,reward = [{0,18010002 ,1}]};

get_pool(1,6) ->
	#reward_pool_cfg{id = 1,reward_id = 6,begin_times = 0,end_times = 0,weight = 1000,special_weight = 0,reward = [{0,19010002 ,1}]};

get_pool(1,7) ->
	#reward_pool_cfg{id = 1,reward_id = 7,begin_times = 0,end_times = 0,weight = 250,special_weight = 0,reward = [{0,18010003 ,1}]};

get_pool(1,8) ->
	#reward_pool_cfg{id = 1,reward_id = 8,begin_times = 0,end_times = 0,weight = 250,special_weight = 0,reward = [{0,19010003 ,1}]};

get_pool(1,9) ->
	#reward_pool_cfg{id = 1,reward_id = 9,begin_times = 0,end_times = 0,weight = 15000,special_weight = 0,reward = [{0,14010001 ,1}]};

get_pool(1,10) ->
	#reward_pool_cfg{id = 1,reward_id = 10,begin_times = 0,end_times = 0,weight = 15000,special_weight = 0,reward = [{0,14020001 ,1}]};

get_pool(1,11) ->
	#reward_pool_cfg{id = 1,reward_id = 11,begin_times = 0,end_times = 0,weight = 8000,special_weight = 0,reward = [{0,14010002 ,1}]};

get_pool(1,12) ->
	#reward_pool_cfg{id = 1,reward_id = 12,begin_times = 0,end_times = 0,weight = 8000,special_weight = 0,reward = [{0,14020002 ,1}]};

get_pool(1,13) ->
	#reward_pool_cfg{id = 1,reward_id = 13,begin_times = 0,end_times = 0,weight = 1000,special_weight = 0,reward = [{0,14010003 ,1}]};

get_pool(1,14) ->
	#reward_pool_cfg{id = 1,reward_id = 14,begin_times = 0,end_times = 0,weight = 1000,special_weight = 0,reward = [{0,14020003 ,1}]};

get_pool(1,15) ->
	#reward_pool_cfg{id = 1,reward_id = 15,begin_times = 0,end_times = 0,weight = 500,special_weight = 0,reward = [{0,20020001 ,2}]};

get_pool(1,16) ->
	#reward_pool_cfg{id = 1,reward_id = 16,begin_times = 0,end_times = 0,weight = 10000,special_weight = 0,reward = [{0,19020001 ,2}]};

get_pool(1,17) ->
	#reward_pool_cfg{id = 1,reward_id = 17,begin_times = 0,end_times = 0,weight = 100,special_weight = 0,reward = [{0,20020002 ,1}]};

get_pool(1,18) ->
	#reward_pool_cfg{id = 1,reward_id = 18,begin_times = 0,end_times = 0,weight = 500,special_weight = 0,reward = [{0,19020003 ,1}]};

get_pool(1,19) ->
	#reward_pool_cfg{id = 1,reward_id = 19,begin_times = 0,end_times = 0,weight = 1000,special_weight = 0,reward = [{0,38030004 ,1}]};

get_pool(_Id,_Rewardid) ->
	[].


get_pool_reward(1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19];

get_pool_reward(_Id) ->
	[].


get_value_by_id(need_send_mail) ->
0;

get_value_by_id(_Key) ->
	[].

get_all_times() ->
[5,10,20].


get_reward_by_times(5) ->
[{0,32010048,1}];


get_reward_by_times(10) ->
[{0,32010048,1}];


get_reward_by_times(20) ->
[{0,32010048,1}];

get_reward_by_times(_Buytimes) ->
	[].

