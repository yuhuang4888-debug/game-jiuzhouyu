%%%---------------------------------------
%%% module      : data_guild_daily
%%% description : 公会宝箱配置
%%%
%%%---------------------------------------
-module(data_guild_daily).
-compile(export_all).
-include("guild_daily.hrl").



get_guild_daily_cfg(1001) ->
	#base_guild_daily{task_id = 1001,key = world_boss,max_num = 5,reward = [{500,{4,0,300}},{1000,{4,0,500}},{200,{4,0,1200}},{1000,{3,0,10000}},{1000,{3,0,20000}},{1500,{3,0,50000}},{1000,{3,0,100000}},{1050,{0,18020001,1}},{1050,{0,19020001,1}},{200,{0,36255007,1}},{500,{2,0,5}},{500,{2,0,10}}],persist = 4};

get_guild_daily_cfg(1002) ->
	#base_guild_daily{task_id = 1002,key = personal_boss,max_num = 3,reward = [{500,{4,0,300}},{1000,{4,0,500}},{200,{4,0,1200}},{1000,{3,0,10000}},{1000,{3,0,20000}},{1500,{3,0,50000}},{1000,{3,0,100000}},{1050,{0,18020001,1}},{1050,{0,19020001,1}},{200,{0,36255007,1}},{500,{2,0,5}},{500,{2,0,10}}],persist = 4};

get_guild_daily_cfg(1003) ->
	#base_guild_daily{task_id = 1003,key = activation_num,max_num = 1,reward = [{500,{4,0,300}},{1000,{4,0,500}},{200,{4,0,1200}},{1000,{3,0,10000}},{1000,{3,0,20000}},{1500,{3,0,50000}},{1000,{3,0,100000}},{1050,{0,18020001,1}},{1050,{0,19020001,1}},{200,{0,36255007,1}},{500,{2,0,5}},{500,{2,0,10}}],persist = 4};

get_guild_daily_cfg(1004) ->
	#base_guild_daily{task_id = 1004,key = treasure_hunt,max_num = 1,reward = [{500,{4,0,300}},{1000,{4,0,500}},{200,{4,0,1200}},{1000,{3,0,10000}},{1000,{3,0,20000}},{1500,{3,0,50000}},{1000,{3,0,100000}},{1050,{0,18020001,1}},{1050,{0,19020001,1}},{200,{0,36255007,1}},{500,{2,0,5}},{500,{2,0,10}}],persist = 4};

get_guild_daily_cfg(1005) ->
	#base_guild_daily{task_id = 1005,key = recharge_once,max_num = 2,reward = [{500,{4,0,300}},{1000,{4,0,500}},{200,{4,0,1200}},{1000,{3,0,10000}},{1000,{3,0,20000}},{1500,{3,0,50000}},{1000,{3,0,100000}},{1050,{0,18020001,1}},{1050,{0,19020001,1}},{200,{0,36255007,1}},{500,{2,0,5}},{500,{2,0,10}}],persist = 4};

get_guild_daily_cfg(1006) ->
	#base_guild_daily{task_id = 1006,key = forbidden_boss,max_num = 1,reward = [{500,{4,0,300}},{1000,{4,0,500}},{200,{4,0,1200}},{1000,{3,0,10000}},{1000,{3,0,20000}},{1500,{3,0,50000}},{1000,{3,0,100000}},{1050,{0,18020001,1}},{1050,{0,19020001,1}},{200,{0,36255007,1}},{500,{2,0,5}},{500,{2,0,10}}],persist = 4};

get_guild_daily_cfg(1007) ->
	#base_guild_daily{task_id = 1007,key = treasure_hunt_rune,max_num = 2,reward = [{500,{4,0,300}},{1000,{4,0,500}},{200,{4,0,1200}},{1000,{3,0,10000}},{1000,{3,0,20000}},{1500,{3,0,50000}},{1000,{3,0,100000}},{1050,{0,18020001,1}},{1050,{0,19020001,1}},{200,{0,36255007,1}},{500,{2,0,5}},{500,{2,0,10}}],persist = 4};

get_guild_daily_cfg(_Taskid) ->
	[].

get_all_task_id() ->
[1001,1002,1003,1004,1005,1006,1007].

get_all_task_key() ->
[world_boss,personal_boss,activation_num,treasure_hunt,recharge_once,forbidden_boss,treasure_hunt_rune].


get_task_id(world_boss) ->
1001;


get_task_id(personal_boss) ->
1002;


get_task_id(activation_num) ->
1003;


get_task_id(treasure_hunt) ->
1004;


get_task_id(recharge_once) ->
1005;


get_task_id(forbidden_boss) ->
1006;


get_task_id(treasure_hunt_rune) ->
1007;

get_task_id(_Key) ->
	[].


get_num_by_vip(0) ->
50;


get_num_by_vip(1) ->
60;


get_num_by_vip(2) ->
60;


get_num_by_vip(3) ->
60;


get_num_by_vip(4) ->
80;


get_num_by_vip(5) ->
80;


get_num_by_vip(6) ->
80;


get_num_by_vip(7) ->
80;


get_num_by_vip(8) ->
80;


get_num_by_vip(9) ->
80;


get_num_by_vip(10) ->
80;


get_num_by_vip(11) ->
80;


get_num_by_vip(12) ->
80;


get_num_by_vip(13) ->
80;


get_num_by_vip(14) ->
80;


get_num_by_vip(15) ->
80;

get_num_by_vip(_Vip) ->
	[].

get_max_vip() -> 15.

get_max_num() -> 80.

