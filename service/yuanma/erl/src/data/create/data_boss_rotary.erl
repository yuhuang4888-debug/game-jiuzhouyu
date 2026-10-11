%%%---------------------------------------
%%% module      : data_boss_rotary
%%% description : boss转盘配置
%%%
%%%---------------------------------------
-module(data_boss_rotary).
-compile(export_all).
-include("boss_rotary.hrl").




get_key(1) ->
[{16,3,[{1,8000},{2,5000},{3,2000}]},{12,3,[{1,5000},{2,3000},{3,2000}]}];


get_key(2) ->
[{1,38180012,0},{2,38180012,4},{3,38180012,10}];


get_key(3) ->
400;

get_key(_Key) ->
	[].

get_reward_cfg(12,400,0,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 14,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,0,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,0,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,0,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,1,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,1,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,1,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,2,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,2,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,2,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,400,585,3,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,400,585,3,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,400,585,3,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 14,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,0,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,0,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,0,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,1,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,1,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,1,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,2,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,2,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,2,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,445,585,3,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,445,585,3,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,445,585,3,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 14,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,0,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,0,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,0,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,1,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,1,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,1,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,2,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,2,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,2,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,500,585,3,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,500,585,3,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,500,585,3,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 14,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,0,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,0,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,0,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,1,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,1,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,1,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,2,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,2,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,2,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,545,585,3,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,545,585,3,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,545,585,3,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 14,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,0,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,0,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,0,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,1,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,1,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,1,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,2,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,2,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,2,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,600,585,3,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,600,585,3,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,600,585,3,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 14,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,0,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,0,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,0,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,1,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,1,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,1,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,2,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,2,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,2,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,645,585,3,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,645,585,3,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,645,585,3,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 5,weight = 0,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 6,weight = 0,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 7,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 8,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 11,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 12,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 13,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 14,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 15,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 16,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 17,weight = 300,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 18,weight = 100,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 19,weight = 50,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 20,weight = 0,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 21,weight = 300,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 22,weight = 100,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,1,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 23,weight = 50,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,1,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 24,weight = 0,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 3,weight = 10,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 4,weight = 10,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 5,weight = 10,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 6,weight = 10,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 9,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 10,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 11,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 13,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 14,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 15,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 16,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 17,weight = 1000,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 18,weight = 300,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 19,weight = 100,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 20,weight = 10,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 21,weight = 1000,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 22,weight = 300,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,2,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 23,weight = 100,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,2,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 24,weight = 10,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 3,weight = 50,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 4,weight = 50,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 5,weight = 50,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 6,weight = 50,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 9,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 11,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 13,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 14,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 15,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 16,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 17,weight = 0,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 18,weight = 800,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 19,weight = 300,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 20,weight = 100,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,0,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 21,weight = 0,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 22,weight = 800,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,0,3,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 23,weight = 300,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,0,3,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 24,weight = 100,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 5,weight = 0,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 6,weight = 0,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 7,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 8,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 11,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 12,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 13,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 14,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 15,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 16,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 17,weight = 300,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 18,weight = 100,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 19,weight = 50,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 20,weight = 0,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 21,weight = 300,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 22,weight = 100,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 23,weight = 50,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,1,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 24,weight = 0,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,1,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 25,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 26,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 27,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 28,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,1,29) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 29,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,1,30) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 30,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 3,weight = 10,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 4,weight = 10,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 5,weight = 10,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 6,weight = 10,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 11,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 13,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 14,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 15,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 16,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 17,weight = 600,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 18,weight = 200,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 19,weight = 100,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 20,weight = 10,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 21,weight = 600,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 22,weight = 200,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 23,weight = 100,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,2,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 24,weight = 10,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,2,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 25,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 26,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 27,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 28,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,2,29) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 29,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,2,30) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 30,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 3,weight = 13,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 4,weight = 13,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 5,weight = 13,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 6,weight = 13,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 9,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 11,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 13,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 15,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 16,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 17,weight = 0,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 18,weight = 800,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 19,weight = 300,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 20,weight = 100,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 21,weight = 0,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 22,weight = 800,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 23,weight = 300,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,3,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 24,weight = 100,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,700,585,3,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 26,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 27,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 28,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,700,585,3,29) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 29,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,700,585,3,30) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 30,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 5,weight = 0,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 6,weight = 0,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 7,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 8,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 11,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 12,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 13,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 14,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 15,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 16,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 17,weight = 300,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 18,weight = 100,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 19,weight = 50,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 20,weight = 0,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 21,weight = 300,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 22,weight = 100,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,1,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 23,weight = 50,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,1,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 24,weight = 0,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 3,weight = 10,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 4,weight = 10,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 5,weight = 10,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 6,weight = 10,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 9,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 10,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 11,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 13,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 14,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 15,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 16,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 17,weight = 1000,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 18,weight = 300,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 19,weight = 100,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 20,weight = 10,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 21,weight = 1000,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 22,weight = 300,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,2,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 23,weight = 100,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,2,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 24,weight = 10,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 3,weight = 50,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 4,weight = 50,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 5,weight = 50,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 6,weight = 50,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 9,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 11,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 13,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 14,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 15,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 16,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 17,weight = 0,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 18,weight = 800,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 19,weight = 300,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 20,weight = 100,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,0,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 21,weight = 0,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 22,weight = 800,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,0,3,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 23,weight = 300,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,0,3,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 24,weight = 100,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,1,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,1,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,1,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,1,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,1,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 5,weight = 0,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,1,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 6,weight = 0,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,1,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 7,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 8,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 11,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,1,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 12,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 13,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 14,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 15,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,1,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 16,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,1,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 17,weight = 300,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 18,weight = 100,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 19,weight = 50,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,1,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 20,weight = 0,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,1,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 21,weight = 300,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 22,weight = 100,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 23,weight = 50,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,1,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 24,weight = 0,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,1,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 25,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 26,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 27,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 28,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,1,29) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 29,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,1,30) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 30,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,2,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,2,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,2,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 3,weight = 10,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,2,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 4,weight = 10,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,2,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 5,weight = 10,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,2,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 6,weight = 10,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,2,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 11,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,2,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 13,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 14,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 15,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,2,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 16,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,2,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 17,weight = 600,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 18,weight = 200,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 19,weight = 100,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,2,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 20,weight = 10,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,2,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 21,weight = 600,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 22,weight = 200,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 23,weight = 100,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,2,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 24,weight = 10,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,2,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 25,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 26,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 27,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 28,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,2,29) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 29,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,2,30) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 30,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,3,1) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,3,2) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,3,3) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 3,weight = 13,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,3,4) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 4,weight = 13,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,3,5) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 5,weight = 13,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,3,6) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 6,weight = 13,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,3,7) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,8) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,9) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 9,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,10) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,11) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 11,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,3,12) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,13) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 13,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,14) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,15) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 15,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,3,16) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 16,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,3,17) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 17,weight = 0,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,18) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 18,weight = 800,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,19) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 19,weight = 300,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,3,20) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 20,weight = 100,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,3,21) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 21,weight = 0,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,22) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 22,weight = 800,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,23) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 23,weight = 300,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,3,24) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 24,weight = 100,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(12,745,585,3,25) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,26) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 26,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,27) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 27,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,28) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 28,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(12,745,585,3,29) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 29,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(12,745,585,3,30) ->
	#base_boss_rotary{boss_type = 12,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 30,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 14,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,0,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,0,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,0,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,1,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,1,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,1,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,2,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,2,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,2,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010253,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010261,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,400,585,3,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,400,585,3,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,400,585,3,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 400,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 14,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,0,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,0,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,0,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,1,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,1,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,1,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,2,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,2,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,2,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010254,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010262,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,445,585,3,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,445,585,3,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,445,585,3,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 445,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 14,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,0,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,0,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,0,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,1,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,1,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,1,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,2,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,2,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,2,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010255,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010263,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030002,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030102,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030102,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030102,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030102,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010002,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010002,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010002,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010002,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,500,585,3,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,500,585,3,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,500,585,3,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 500,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 14,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,0,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,0,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,0,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,1,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,1,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,1,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,2,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,2,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,2,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010256,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010264,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,545,585,3,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,545,585,3,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,545,585,3,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 545,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 2,weight = 600,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 14,weight = 2500,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,0,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,0,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,0,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,1,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,1,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,1,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,2,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,2,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,2,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010257,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010265,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,600,585,3,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,600,585,3,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,600,585,3,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 600,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 5,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 6,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 10,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 7,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 8,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 11,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 12,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 15,weight = 1000,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 16,weight = 300,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 19,weight = 1000,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 20,weight = 300,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 3,weight = 100,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 4,weight = 100,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 12,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 13,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 14,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,0,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,0,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,0,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 0,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 5,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 6,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 9,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 10,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 11,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 12,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 13,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 14,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 15,weight = 300,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 16,weight = 100,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 17,weight = 50,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 18,weight = 0,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 19,weight = 300,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 20,weight = 100,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 21,weight = 50,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 22,weight = 0,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,1,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 23,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 24,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 25,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 26,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,1,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 27,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,1,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 1,reward_id = 28,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 3,weight = 20,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 4,weight = 20,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 7,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 8,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 9,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 11,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 12,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 13,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 14,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 15,weight = 600,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 16,weight = 200,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 17,weight = 100,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 18,weight = 10,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 19,weight = 600,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 20,weight = 200,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 21,weight = 100,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 22,weight = 10,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,2,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 24,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 25,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 26,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,2,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 27,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,2,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 2,reward_id = 28,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010258,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010266,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 3,weight = 25,rewards = [{0,18030003,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 4,weight = 25,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 5,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 6,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 9,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 11,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 12,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 13,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 15,weight = 0,rewards = [{0,17030103,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 16,weight = 800,rewards = [{0,17030103,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 17,weight = 300,rewards = [{0,17030103,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 18,weight = 100,rewards = [{0,17030103,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 19,weight = 0,rewards = [{0,68010004,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 20,weight = 800,rewards = [{0,68010004,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 21,weight = 300,rewards = [{0,68010004,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 22,weight = 100,rewards = [{0,68010004,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,645,585,3,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 23,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 24,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 26,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,645,585,3,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 27,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,645,585,3,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 645,wlv = 585,pool_id = 3,reward_id = 28,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 5,weight = 0,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 6,weight = 0,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 7,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 8,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 11,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 12,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 13,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 14,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 15,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 16,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 17,weight = 300,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 18,weight = 100,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 19,weight = 50,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 20,weight = 0,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 21,weight = 300,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 22,weight = 100,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,1,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 23,weight = 50,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,1,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 1,reward_id = 24,weight = 0,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 3,weight = 10,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 4,weight = 10,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 5,weight = 10,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 6,weight = 10,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 9,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 10,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 11,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 13,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 14,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 15,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 16,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 17,weight = 1000,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 18,weight = 300,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 19,weight = 100,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 20,weight = 10,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 21,weight = 1000,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 22,weight = 300,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,2,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 23,weight = 100,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,2,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 2,reward_id = 24,weight = 10,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 3,weight = 50,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 4,weight = 50,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 5,weight = 50,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 6,weight = 50,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 9,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 11,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 13,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 14,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 15,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 16,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 17,weight = 0,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 18,weight = 800,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 19,weight = 300,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 20,weight = 100,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,0,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 21,weight = 0,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 22,weight = 800,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,0,3,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 23,weight = 300,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,0,3,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 0,pool_id = 3,reward_id = 24,weight = 100,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 5,weight = 0,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 6,weight = 0,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 7,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 8,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 11,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 12,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 13,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 14,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 15,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 16,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 17,weight = 300,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 18,weight = 100,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 19,weight = 50,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 20,weight = 0,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 21,weight = 300,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 22,weight = 100,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 23,weight = 50,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,1,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 24,weight = 0,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,1,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 25,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 26,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 27,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 28,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,1,29) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 29,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,1,30) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 1,reward_id = 30,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 3,weight = 10,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 4,weight = 10,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 5,weight = 10,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 6,weight = 10,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 11,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 13,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 14,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 15,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 16,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 17,weight = 600,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 18,weight = 200,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 19,weight = 100,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 20,weight = 10,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 21,weight = 600,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 22,weight = 200,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 23,weight = 100,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,2,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 24,weight = 10,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,2,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 25,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 26,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 27,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 28,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,2,29) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 29,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,2,30) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 2,reward_id = 30,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010259,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010267,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 3,weight = 13,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 4,weight = 13,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 5,weight = 13,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 6,weight = 13,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 9,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 11,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 13,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 15,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 16,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 17,weight = 0,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 18,weight = 800,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 19,weight = 300,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 20,weight = 100,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 21,weight = 0,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 22,weight = 800,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 23,weight = 300,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,3,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 24,weight = 100,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,700,585,3,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 26,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 27,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 28,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,700,585,3,29) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 29,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,700,585,3,30) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 700,wlv = 585,pool_id = 3,reward_id = 30,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 5,weight = 0,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 6,weight = 0,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 7,weight = 1900,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 8,weight = 1900,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 11,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 12,weight = 3200,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 13,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 14,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 15,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 16,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 17,weight = 300,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 18,weight = 100,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 19,weight = 50,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 20,weight = 0,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 21,weight = 300,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 22,weight = 100,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,1,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 23,weight = 50,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,1,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 1,reward_id = 24,weight = 0,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 3,weight = 10,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 4,weight = 10,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 5,weight = 10,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 6,weight = 10,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 9,weight = 1100,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 10,weight = 1100,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 11,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 13,weight = 2000,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 14,weight = 1400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 15,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 16,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 17,weight = 1000,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 18,weight = 300,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 19,weight = 100,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 20,weight = 10,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 21,weight = 1000,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 22,weight = 300,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,2,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 23,weight = 100,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,2,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 2,reward_id = 24,weight = 10,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 2,weight = 300,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 3,weight = 50,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 4,weight = 50,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 5,weight = 50,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 6,weight = 50,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 9,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 11,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 13,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 14,weight = 2400,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 15,weight = 1000,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 16,weight = 2800,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 17,weight = 0,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 18,weight = 800,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 19,weight = 300,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 20,weight = 100,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,0,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 21,weight = 0,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 22,weight = 800,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,0,3,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 23,weight = 300,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,0,3,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 0,pool_id = 3,reward_id = 24,weight = 100,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,1,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 1,weight = 300,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,1,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 2,weight = 50,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,1,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 3,weight = 0,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,1,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 4,weight = 0,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,1,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 5,weight = 0,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,1,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 6,weight = 0,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,1,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 7,weight = 800,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 8,weight = 800,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 11,weight = 20,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,1,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 12,weight = 1450,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 13,weight = 500,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 14,weight = 10,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 15,weight = 0,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,1,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 16,weight = 20,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,1,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 17,weight = 300,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 18,weight = 100,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 19,weight = 50,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,1,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 20,weight = 0,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,1,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 21,weight = 300,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 22,weight = 100,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 23,weight = 50,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,1,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 24,weight = 0,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,1,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 25,weight = 2000,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 26,weight = 1500,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 27,weight = 300,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 28,weight = 100,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,1,29) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 29,weight = 50,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,1,30) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 1,reward_id = 30,weight = 0,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,2,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 1,weight = 600,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,2,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 2,weight = 200,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,2,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 3,weight = 10,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,2,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 4,weight = 10,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,2,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 5,weight = 10,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,2,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 6,weight = 10,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,2,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 9,weight = 600,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 10,weight = 600,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 11,weight = 140,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,2,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 13,weight = 800,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 14,weight = 600,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 15,weight = 200,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,2,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 16,weight = 400,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,2,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 17,weight = 600,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 18,weight = 200,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 19,weight = 100,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,2,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 20,weight = 10,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,2,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 21,weight = 600,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 22,weight = 200,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 23,weight = 100,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,2,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 24,weight = 10,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,2,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 25,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 26,weight = 1800,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 27,weight = 1550,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 28,weight = 500,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,2,29) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 29,weight = 100,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,2,30) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 2,reward_id = 30,weight = 50,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,3,1) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 1,weight = 0,rewards = [{0,34010260,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,3,2) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 2,weight = 200,rewards = [{0,34010268,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,3,3) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 3,weight = 13,rewards = [{0,18030004,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,3,4) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 4,weight = 13,rewards = [{0,18030005,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,3,5) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 5,weight = 13,rewards = [{0,18030006,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,3,6) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 6,weight = 13,rewards = [{0,18030007,1}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,3,7) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 7,weight = 0,rewards = [{0,18020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,8) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 8,weight = 0,rewards = [{0,19020001,2}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,9) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 9,weight = 0,rewards = [{0,18010001,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,10) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 10,weight = 0,rewards = [{0,18010002,1}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,11) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 11,weight = 900,rewards = [{0,18010003,1}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,3,12) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 12,weight = 0,rewards = [{0,35,20}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,13) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 13,weight = 0,rewards = [{0,35,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,14) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 14,weight = 1000,rewards = [{0,35,188}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,15) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 15,weight = 300,rewards = [{0,35,688}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,3,16) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 16,weight = 1000,rewards = [{0,32010207,2}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,3,17) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 17,weight = 0,rewards = [{0,17030104,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,18) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 18,weight = 800,rewards = [{0,17030104,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,19) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 19,weight = 300,rewards = [{0,17030104,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,3,20) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 20,weight = 100,rewards = [{0,17030104,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,3,21) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 21,weight = 0,rewards = [{0,68010005,3}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,22) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 22,weight = 800,rewards = [{0,68010005,6}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,23) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 23,weight = 300,rewards = [{0,68010005,15}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,3,24) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 24,weight = 100,rewards = [{0,68010005,30}],rare = 2,is_tv = 1};

get_reward_cfg(16,745,585,3,25) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 25,weight = 0,rewards = [{255,36255096,50}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,26) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 26,weight = 0,rewards = [{255,36255096,100}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,27) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 27,weight = 0,rewards = [{255,36255096,150}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,28) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 28,weight = 2000,rewards = [{255,36255096,200}],rare = 0,is_tv = 0};

get_reward_cfg(16,745,585,3,29) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 29,weight = 1650,rewards = [{255,36255096,400}],rare = 1,is_tv = 1};

get_reward_cfg(16,745,585,3,30) ->
	#base_boss_rotary{boss_type = 16,boss_reward_lv = 745,wlv = 585,pool_id = 3,reward_id = 30,weight = 500,rewards = [{255,36255096,600}],rare = 2,is_tv = 1};

get_reward_cfg(_Bosstype,_Bossrewardlv,_Wlv,_Poolid,_Rewardid) ->
	[].

get_pool_id_list(12,400,0) ->
[1,2,3];

get_pool_id_list(12,400,585) ->
[1,2,3];

get_pool_id_list(12,445,0) ->
[1,2,3];

get_pool_id_list(12,445,585) ->
[1,2,3];

get_pool_id_list(12,500,0) ->
[1,2,3];

get_pool_id_list(12,500,585) ->
[1,2,3];

get_pool_id_list(12,545,0) ->
[1,2,3];

get_pool_id_list(12,545,585) ->
[1,2,3];

get_pool_id_list(12,600,0) ->
[1,2,3];

get_pool_id_list(12,600,585) ->
[1,2,3];

get_pool_id_list(12,645,0) ->
[1,2,3];

get_pool_id_list(12,645,585) ->
[1,2,3];

get_pool_id_list(12,700,0) ->
[1,2,3];

get_pool_id_list(12,700,585) ->
[1,2,3];

get_pool_id_list(12,745,0) ->
[1,2,3];

get_pool_id_list(12,745,585) ->
[1,2,3];

get_pool_id_list(16,400,0) ->
[1,2,3];

get_pool_id_list(16,400,585) ->
[1,2,3];

get_pool_id_list(16,445,0) ->
[1,2,3];

get_pool_id_list(16,445,585) ->
[1,2,3];

get_pool_id_list(16,500,0) ->
[1,2,3];

get_pool_id_list(16,500,585) ->
[1,2,3];

get_pool_id_list(16,545,0) ->
[1,2,3];

get_pool_id_list(16,545,585) ->
[1,2,3];

get_pool_id_list(16,600,0) ->
[1,2,3];

get_pool_id_list(16,600,585) ->
[1,2,3];

get_pool_id_list(16,645,0) ->
[1,2,3];

get_pool_id_list(16,645,585) ->
[1,2,3];

get_pool_id_list(16,700,0) ->
[1,2,3];

get_pool_id_list(16,700,585) ->
[1,2,3];

get_pool_id_list(16,745,0) ->
[1,2,3];

get_pool_id_list(16,745,585) ->
[1,2,3];

get_pool_id_list(_Bosstype,_Bossrewardlv,_Wlv) ->
	[].

	get_rotary_reward_list(12,400,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(12,400,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(12,400,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2800,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(12,400,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(12,400,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(12,400,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(12,445,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(12,445,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(12,445,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2800,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(12,445,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(12,445,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(12,445,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(12,500,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(12,500,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(12,500,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2800,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(12,500,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(12,500,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(12,500,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(12,545,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(12,545,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(12,545,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2800,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(12,545,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(12,545,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(12,545,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(12,600,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(12,600,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(12,600,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2800,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(12,600,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(12,600,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(12,600,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(12,645,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(12,645,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(12,645,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2800,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(12,645,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(12,645,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(12,645,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(12,700,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,0,2},{1,6,0,2},{1,7,1900,0},{1,8,1900,0},{1,9,600,0},{1,10,600,0},{1,11,20,1},{1,12,3200,0},{1,13,500,0},{1,14,10,0},{1,15,0,2},{1,16,20,1},{1,17,300,0},{1,18,100,0},{1,19,50,1},{1,20,0,2},{1,21,300,0},{1,22,100,0},{1,23,50,1},{1,24,0,2}];
	
	get_rotary_reward_list(12,700,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,10,2},{2,4,10,2},{2,5,10,2},{2,6,10,2},{2,7,0,0},{2,8,0,0},{2,9,1100,0},{2,10,1100,0},{2,11,140,1},{2,12,0,0},{2,13,2000,0},{2,14,1400,0},{2,15,200,2},{2,16,400,1},{2,17,1000,0},{2,18,300,0},{2,19,100,1},{2,20,10,2},{2,21,1000,0},{2,22,300,0},{2,23,100,1},{2,24,10,2}];
	
	get_rotary_reward_list(12,700,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,50,2},{3,4,50,2},{3,5,50,2},{3,6,50,2},{3,7,0,0},{3,8,0,0},{3,9,0,0},{3,10,0,0},{3,11,900,1},{3,12,0,0},{3,13,0,0},{3,14,2400,0},{3,15,1000,2},{3,16,2800,1},{3,17,0,0},{3,18,800,0},{3,19,300,1},{3,20,100,2},{3,21,0,0},{3,22,800,0},{3,23,300,1},{3,24,100,2}];
	
	get_rotary_reward_list(12,700,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,0,2},{1,6,0,2},{1,7,800,0},{1,8,800,0},{1,9,600,0},{1,10,600,0},{1,11,20,1},{1,12,1450,0},{1,13,500,0},{1,14,10,0},{1,15,0,2},{1,16,20,1},{1,17,300,0},{1,18,100,0},{1,19,50,1},{1,20,0,2},{1,21,300,0},{1,22,100,0},{1,23,50,1},{1,24,0,2},{1,25,2000,0},{1,26,1500,0},{1,27,300,0},{1,28,100,0},{1,29,50,1},{1,30,0,2}];
	
	get_rotary_reward_list(12,700,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,10,2},{2,4,10,2},{2,5,10,2},{2,6,10,2},{2,7,0,0},{2,8,0,0},{2,9,600,0},{2,10,600,0},{2,11,140,1},{2,12,0,0},{2,13,800,0},{2,14,600,0},{2,15,200,2},{2,16,400,1},{2,17,600,0},{2,18,200,0},{2,19,100,1},{2,20,10,2},{2,21,600,0},{2,22,200,0},{2,23,100,1},{2,24,10,2},{2,25,0,0},{2,26,1800,0},{2,27,1550,0},{2,28,500,0},{2,29,100,1},{2,30,50,2}];
	
	get_rotary_reward_list(12,700,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,13,2},{3,4,13,2},{3,5,13,2},{3,6,13,2},{3,7,0,0},{3,8,0,0},{3,9,0,0},{3,10,0,0},{3,11,900,1},{3,12,0,0},{3,13,0,0},{3,14,1000,0},{3,15,300,2},{3,16,1000,1},{3,17,0,0},{3,18,800,0},{3,19,300,1},{3,20,100,2},{3,21,0,0},{3,22,800,0},{3,23,300,1},{3,24,100,2},{3,25,0,0},{3,26,0,0},{3,27,0,0},{3,28,2000,0},{3,29,1650,1},{3,30,500,2}];
	
	get_rotary_reward_list(12,745,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,0,2},{1,6,0,2},{1,7,1900,0},{1,8,1900,0},{1,9,600,0},{1,10,600,0},{1,11,20,1},{1,12,3200,0},{1,13,500,0},{1,14,10,0},{1,15,0,2},{1,16,20,1},{1,17,300,0},{1,18,100,0},{1,19,50,1},{1,20,0,2},{1,21,300,0},{1,22,100,0},{1,23,50,1},{1,24,0,2}];
	
	get_rotary_reward_list(12,745,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,10,2},{2,4,10,2},{2,5,10,2},{2,6,10,2},{2,7,0,0},{2,8,0,0},{2,9,1100,0},{2,10,1100,0},{2,11,140,1},{2,12,0,0},{2,13,2000,0},{2,14,1400,0},{2,15,200,2},{2,16,400,1},{2,17,1000,0},{2,18,300,0},{2,19,100,1},{2,20,10,2},{2,21,1000,0},{2,22,300,0},{2,23,100,1},{2,24,10,2}];
	
	get_rotary_reward_list(12,745,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,50,2},{3,4,50,2},{3,5,50,2},{3,6,50,2},{3,7,0,0},{3,8,0,0},{3,9,0,0},{3,10,0,0},{3,11,900,1},{3,12,0,0},{3,13,0,0},{3,14,2400,0},{3,15,1000,2},{3,16,2800,1},{3,17,0,0},{3,18,800,0},{3,19,300,1},{3,20,100,2},{3,21,0,0},{3,22,800,0},{3,23,300,1},{3,24,100,2}];
	
	get_rotary_reward_list(12,745,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,0,2},{1,6,0,2},{1,7,800,0},{1,8,800,0},{1,9,600,0},{1,10,600,0},{1,11,20,1},{1,12,1450,0},{1,13,500,0},{1,14,10,0},{1,15,0,2},{1,16,20,1},{1,17,300,0},{1,18,100,0},{1,19,50,1},{1,20,0,2},{1,21,300,0},{1,22,100,0},{1,23,50,1},{1,24,0,2},{1,25,2000,0},{1,26,1500,0},{1,27,300,0},{1,28,100,0},{1,29,50,1},{1,30,0,2}];
	
	get_rotary_reward_list(12,745,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,10,2},{2,4,10,2},{2,5,10,2},{2,6,10,2},{2,7,0,0},{2,8,0,0},{2,9,600,0},{2,10,600,0},{2,11,140,1},{2,12,0,0},{2,13,800,0},{2,14,600,0},{2,15,200,2},{2,16,400,1},{2,17,600,0},{2,18,200,0},{2,19,100,1},{2,20,10,2},{2,21,600,0},{2,22,200,0},{2,23,100,1},{2,24,10,2},{2,25,0,0},{2,26,1800,0},{2,27,1550,0},{2,28,500,0},{2,29,100,1},{2,30,50,2}];
	
	get_rotary_reward_list(12,745,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,13,2},{3,4,13,2},{3,5,13,2},{3,6,13,2},{3,7,0,0},{3,8,0,0},{3,9,0,0},{3,10,0,0},{3,11,900,1},{3,12,0,0},{3,13,0,0},{3,14,1000,0},{3,15,300,2},{3,16,1000,1},{3,17,0,0},{3,18,800,0},{3,19,300,1},{3,20,100,2},{3,21,0,0},{3,22,800,0},{3,23,300,1},{3,24,100,2},{3,25,0,0},{3,26,0,0},{3,27,0,0},{3,28,2000,0},{3,29,1650,1},{3,30,500,2}];
	
	get_rotary_reward_list(16,400,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(16,400,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(16,400,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2800,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(16,400,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(16,400,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(16,400,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(16,445,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(16,445,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(16,445,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2800,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(16,445,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(16,445,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(16,445,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(16,500,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(16,500,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(16,500,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2800,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(16,500,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(16,500,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(16,500,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(16,545,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(16,545,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(16,545,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2800,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(16,545,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(16,545,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(16,545,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(16,600,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(16,600,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(16,600,0,3) ->
	[{3,1,0,1},{3,2,600,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2500,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(16,600,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(16,600,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(16,600,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(16,645,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,1900,0},{1,6,1900,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,3200,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2}];
	
	get_rotary_reward_list(16,645,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,1100,0},{2,8,1100,0},{2,9,140,1},{2,10,0,0},{2,11,2000,0},{2,12,1400,0},{2,13,200,2},{2,14,400,1},{2,15,1000,0},{2,16,300,0},{2,17,100,1},{2,18,10,2},{2,19,1000,0},{2,20,300,0},{2,21,100,1},{2,22,10,2}];
	
	get_rotary_reward_list(16,645,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,100,2},{3,4,100,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,2400,0},{3,13,1000,2},{3,14,2800,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2}];
	
	get_rotary_reward_list(16,645,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,800,0},{1,6,800,0},{1,7,600,0},{1,8,600,0},{1,9,20,1},{1,10,1450,0},{1,11,500,0},{1,12,10,0},{1,13,0,2},{1,14,20,1},{1,15,300,0},{1,16,100,0},{1,17,50,1},{1,18,0,2},{1,19,300,0},{1,20,100,0},{1,21,50,1},{1,22,0,2},{1,23,2000,0},{1,24,1500,0},{1,25,300,0},{1,26,100,0},{1,27,50,1},{1,28,0,2}];
	
	get_rotary_reward_list(16,645,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,20,2},{2,4,20,2},{2,5,0,0},{2,6,0,0},{2,7,600,0},{2,8,600,0},{2,9,140,1},{2,10,0,0},{2,11,800,0},{2,12,600,0},{2,13,200,2},{2,14,400,1},{2,15,600,0},{2,16,200,0},{2,17,100,1},{2,18,10,2},{2,19,600,0},{2,20,200,0},{2,21,100,1},{2,22,10,2},{2,23,0,0},{2,24,1800,0},{2,25,1550,0},{2,26,500,0},{2,27,100,1},{2,28,50,2}];
	
	get_rotary_reward_list(16,645,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,25,2},{3,4,25,2},{3,5,0,0},{3,6,0,0},{3,7,0,0},{3,8,0,0},{3,9,900,1},{3,10,0,0},{3,11,0,0},{3,12,1000,0},{3,13,300,2},{3,14,1000,1},{3,15,0,0},{3,16,800,0},{3,17,300,1},{3,18,100,2},{3,19,0,0},{3,20,800,0},{3,21,300,1},{3,22,100,2},{3,23,0,0},{3,24,0,0},{3,25,0,0},{3,26,2000,0},{3,27,1650,1},{3,28,500,2}];
	
	get_rotary_reward_list(16,700,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,0,2},{1,6,0,2},{1,7,1900,0},{1,8,1900,0},{1,9,600,0},{1,10,600,0},{1,11,20,1},{1,12,3200,0},{1,13,500,0},{1,14,10,0},{1,15,0,2},{1,16,20,1},{1,17,300,0},{1,18,100,0},{1,19,50,1},{1,20,0,2},{1,21,300,0},{1,22,100,0},{1,23,50,1},{1,24,0,2}];
	
	get_rotary_reward_list(16,700,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,10,2},{2,4,10,2},{2,5,10,2},{2,6,10,2},{2,7,0,0},{2,8,0,0},{2,9,1100,0},{2,10,1100,0},{2,11,140,1},{2,12,0,0},{2,13,2000,0},{2,14,1400,0},{2,15,200,2},{2,16,400,1},{2,17,1000,0},{2,18,300,0},{2,19,100,1},{2,20,10,2},{2,21,1000,0},{2,22,300,0},{2,23,100,1},{2,24,10,2}];
	
	get_rotary_reward_list(16,700,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,50,2},{3,4,50,2},{3,5,50,2},{3,6,50,2},{3,7,0,0},{3,8,0,0},{3,9,0,0},{3,10,0,0},{3,11,900,1},{3,12,0,0},{3,13,0,0},{3,14,2400,0},{3,15,1000,2},{3,16,2800,1},{3,17,0,0},{3,18,800,0},{3,19,300,1},{3,20,100,2},{3,21,0,0},{3,22,800,0},{3,23,300,1},{3,24,100,2}];
	
	get_rotary_reward_list(16,700,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,0,2},{1,6,0,2},{1,7,800,0},{1,8,800,0},{1,9,600,0},{1,10,600,0},{1,11,20,1},{1,12,1450,0},{1,13,500,0},{1,14,10,0},{1,15,0,2},{1,16,20,1},{1,17,300,0},{1,18,100,0},{1,19,50,1},{1,20,0,2},{1,21,300,0},{1,22,100,0},{1,23,50,1},{1,24,0,2},{1,25,2000,0},{1,26,1500,0},{1,27,300,0},{1,28,100,0},{1,29,50,1},{1,30,0,2}];
	
	get_rotary_reward_list(16,700,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,10,2},{2,4,10,2},{2,5,10,2},{2,6,10,2},{2,7,0,0},{2,8,0,0},{2,9,600,0},{2,10,600,0},{2,11,140,1},{2,12,0,0},{2,13,800,0},{2,14,600,0},{2,15,200,2},{2,16,400,1},{2,17,600,0},{2,18,200,0},{2,19,100,1},{2,20,10,2},{2,21,600,0},{2,22,200,0},{2,23,100,1},{2,24,10,2},{2,25,0,0},{2,26,1800,0},{2,27,1550,0},{2,28,500,0},{2,29,100,1},{2,30,50,2}];
	
	get_rotary_reward_list(16,700,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,13,2},{3,4,13,2},{3,5,13,2},{3,6,13,2},{3,7,0,0},{3,8,0,0},{3,9,0,0},{3,10,0,0},{3,11,900,1},{3,12,0,0},{3,13,0,0},{3,14,1000,0},{3,15,300,2},{3,16,1000,1},{3,17,0,0},{3,18,800,0},{3,19,300,1},{3,20,100,2},{3,21,0,0},{3,22,800,0},{3,23,300,1},{3,24,100,2},{3,25,0,0},{3,26,0,0},{3,27,0,0},{3,28,2000,0},{3,29,1650,1},{3,30,500,2}];
	
	get_rotary_reward_list(16,745,0,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,0,2},{1,6,0,2},{1,7,1900,0},{1,8,1900,0},{1,9,600,0},{1,10,600,0},{1,11,20,1},{1,12,3200,0},{1,13,500,0},{1,14,10,0},{1,15,0,2},{1,16,20,1},{1,17,300,0},{1,18,100,0},{1,19,50,1},{1,20,0,2},{1,21,300,0},{1,22,100,0},{1,23,50,1},{1,24,0,2}];
	
	get_rotary_reward_list(16,745,0,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,10,2},{2,4,10,2},{2,5,10,2},{2,6,10,2},{2,7,0,0},{2,8,0,0},{2,9,1100,0},{2,10,1100,0},{2,11,140,1},{2,12,0,0},{2,13,2000,0},{2,14,1400,0},{2,15,200,2},{2,16,400,1},{2,17,1000,0},{2,18,300,0},{2,19,100,1},{2,20,10,2},{2,21,1000,0},{2,22,300,0},{2,23,100,1},{2,24,10,2}];
	
	get_rotary_reward_list(16,745,0,3) ->
	[{3,1,0,1},{3,2,300,2},{3,3,50,2},{3,4,50,2},{3,5,50,2},{3,6,50,2},{3,7,0,0},{3,8,0,0},{3,9,0,0},{3,10,0,0},{3,11,900,1},{3,12,0,0},{3,13,0,0},{3,14,2400,0},{3,15,1000,2},{3,16,2800,1},{3,17,0,0},{3,18,800,0},{3,19,300,1},{3,20,100,2},{3,21,0,0},{3,22,800,0},{3,23,300,1},{3,24,100,2}];
	
	get_rotary_reward_list(16,745,585,1) ->
	[{1,1,300,1},{1,2,50,2},{1,3,0,2},{1,4,0,2},{1,5,0,2},{1,6,0,2},{1,7,800,0},{1,8,800,0},{1,9,600,0},{1,10,600,0},{1,11,20,1},{1,12,1450,0},{1,13,500,0},{1,14,10,0},{1,15,0,2},{1,16,20,1},{1,17,300,0},{1,18,100,0},{1,19,50,1},{1,20,0,2},{1,21,300,0},{1,22,100,0},{1,23,50,1},{1,24,0,2},{1,25,2000,0},{1,26,1500,0},{1,27,300,0},{1,28,100,0},{1,29,50,1},{1,30,0,2}];
	
	get_rotary_reward_list(16,745,585,2) ->
	[{2,1,600,1},{2,2,200,2},{2,3,10,2},{2,4,10,2},{2,5,10,2},{2,6,10,2},{2,7,0,0},{2,8,0,0},{2,9,600,0},{2,10,600,0},{2,11,140,1},{2,12,0,0},{2,13,800,0},{2,14,600,0},{2,15,200,2},{2,16,400,1},{2,17,600,0},{2,18,200,0},{2,19,100,1},{2,20,10,2},{2,21,600,0},{2,22,200,0},{2,23,100,1},{2,24,10,2},{2,25,0,0},{2,26,1800,0},{2,27,1550,0},{2,28,500,0},{2,29,100,1},{2,30,50,2}];
	
	get_rotary_reward_list(16,745,585,3) ->
	[{3,1,0,1},{3,2,200,2},{3,3,13,2},{3,4,13,2},{3,5,13,2},{3,6,13,2},{3,7,0,0},{3,8,0,0},{3,9,0,0},{3,10,0,0},{3,11,900,1},{3,12,0,0},{3,13,0,0},{3,14,1000,0},{3,15,300,2},{3,16,1000,1},{3,17,0,0},{3,18,800,0},{3,19,300,1},{3,20,100,2},{3,21,0,0},{3,22,800,0},{3,23,300,1},{3,24,100,2},{3,25,0,0},{3,26,0,0},{3,27,0,0},{3,28,2000,0},{3,29,1650,1},{3,30,500,2}];
	
get_rotary_reward_list(_Bosstype,_Bossrewardlv,_Wlv,_Poolid) ->
	[].


get_boss_reward_level(12) ->
[400,445,500,545,600,645,700,745];


get_boss_reward_level(16) ->
[400,445,500,545,600,645,700,745];

get_boss_reward_level(_Bosstype) ->
	[].


get_reward_wlv(12) ->
[0,585];


get_reward_wlv(16) ->
[0,585];

get_reward_wlv(_Bosstype) ->
	[].

