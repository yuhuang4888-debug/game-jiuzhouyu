%%%---------------------------------------
%%% module      : data_guild_battle
%%% description : 公会战配置
%%%
%%%---------------------------------------
-module(data_guild_battle).
-compile(export_all).
-include("guild_battle.hrl").




get_cfg(1) ->
100;


get_cfg(2) ->
20;


get_cfg(3) ->
8001;


get_cfg(4) ->
5;


get_cfg(5) ->
15;


get_cfg(7) ->
0;


get_cfg(9) ->
20;


get_cfg(11) ->
10;


get_cfg(12) ->
130;


get_cfg(13) ->
4203001;


get_cfg(14) ->
300;


get_cfg(15) ->
3600;


get_cfg(16) ->
[[1881,1826],[4497,2978]];

get_cfg(_Guildkey) ->
	[].

get_birth_and_mon(1) ->
	#base_guild_battle_birth{cfg_id = 1,type = 1,location = [{196,680},{2487,2712}]};

get_birth_and_mon(2) ->
	#base_guild_battle_birth{cfg_id = 2,type = 1,location = [{2443,2935},{134,538}]};

get_birth_and_mon(3) ->
	#base_guild_battle_birth{cfg_id = 3,type = 1,location = [{5298,5930},{2514,3018}]};

get_birth_and_mon(4) ->
	#base_guild_battle_birth{cfg_id = 4,type = 1,location = [{2720,3218},{4636,5008}]};

get_birth_and_mon(_Cfgid) ->
	[].


get_birth_and_mon_list(1) ->
[1,2,3,4];

get_birth_and_mon_list(_Type) ->
	[].

get_own(8001001) ->
	#base_guild_battle_own{mon_id = 8001001,type = 1,sub_type = 1,location = [{1156,1325}],guild_add_score = 300,role_add_score = 1};

get_own(8001002) ->
	#base_guild_battle_own{mon_id = 8001002,type = 1,sub_type = 2,location = [{4698,1374}],guild_add_score = 300,role_add_score = 1};

get_own(8001003) ->
	#base_guild_battle_own{mon_id = 8001003,type = 1,sub_type = 3,location = [{4798,3908}],guild_add_score = 300,role_add_score = 1};

get_own(8001004) ->
	#base_guild_battle_own{mon_id = 8001004,type = 1,sub_type = 4,location = [{1308,4048}],guild_add_score = 300,role_add_score = 1};

get_own(8001005) ->
	#base_guild_battle_own{mon_id = 8001005,type = 2,sub_type = 1,location = [{2878,2613}],guild_add_score = 900,role_add_score = 1};

get_own(_Monid) ->
	[].

get_own_list() ->
[8001001,8001002,8001003,8001004,8001005].


get_own_type(1) ->
[8001001,8001002,8001003,8001004];


get_own_type(2) ->
[8001005];

get_own_type(_Type) ->
	[].


get_score_info(1) ->
3;


get_score_info(2) ->
200;


get_score_info(3) ->
200;


get_score_info(4) ->
5;


get_score_info(5) ->
1;


get_score_info(6) ->
1;

get_score_info(_Type) ->
	0.

get_battle_reward(_WorldLv) when _WorldLv >= 1, _WorldLv < 99999 ->
		[[{0,38064005,1},{0,32010113,1}],[{4,0,400},{4,0,300},{4,0,300},{3,0,100000},{0,37020001,1}]];
get_battle_reward(_WorldLv) ->
	[].

get_streak_reward(_Wlv,2) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,32010017,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,32010017,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,32010017,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 1, _Wlv =< 19 ->
		[[{0,32010017,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,5) when _Wlv >= 1, _Wlv =< 9999 ->
		[[{0,20030004,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,10) when _Wlv >= 1, _Wlv =< 9999 ->
		[[{0,20030004,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,15) when _Wlv >= 1, _Wlv =< 9999 ->
		[[{0,20030004,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,20) when _Wlv >= 1, _Wlv =< 9999 ->
		[[{0,20030004,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,25) when _Wlv >= 1, _Wlv =< 9999 ->
		[[{0,20030004,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,30) when _Wlv >= 1, _Wlv =< 9999 ->
		[[{0,20030004,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,35) when _Wlv >= 1, _Wlv =< 9999 ->
		[[{0,20030004,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,40) when _Wlv >= 1, _Wlv =< 9999 ->
		[[{0,20030004,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,45) when _Wlv >= 1, _Wlv =< 9999 ->
		[[{0,20030004,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,50) when _Wlv >= 1, _Wlv =< 9999 ->
		[[{0,20030004,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,32010018,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,32010018,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,32010018,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 20, _Wlv =< 59 ->
		[[{0,32010018,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,32010019,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,32010019,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,32010019,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 60, _Wlv =< 99 ->
		[[{0,32010019,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,32010020,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,32010020,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,32010020,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 100, _Wlv =< 149 ->
		[[{0,32010020,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,32010021,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,32010021,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,32010021,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 150, _Wlv =< 189 ->
		[[{0,32010021,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,32010022,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,32010022,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,32010022,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 190, _Wlv =< 229 ->
		[[{0,32010022,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,32010023,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,32010023,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,32010023,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 230, _Wlv =< 259 ->
		[[{0,32010023,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,32010024,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,32010024,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,32010024,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 260, _Wlv =< 279 ->
		[[{0,32010024,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,32010025,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,32010025,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,32010025,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 280, _Wlv =< 319 ->
		[[{0,32010025,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,32010026,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,32010026,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,32010026,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 320, _Wlv =< 379 ->
		[[{0,32010026,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,32010027,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,32010027,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,32010027,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 380, _Wlv =< 419 ->
		[[{0,32010027,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,32010028,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,32010028,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,32010028,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 420, _Wlv =< 519 ->
		[[{0,32010028,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,32010029,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,32010029,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,32010029,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 520, _Wlv =< 579 ->
		[[{0,32010029,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,32010030,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,32010030,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,32010030,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 580, _Wlv =< 669 ->
		[[{0,32010030,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,32010031,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,32010031,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,32010031,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 670, _Wlv =< 709 ->
		[[{0,32010031,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,2) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,32010032,1}]];
get_streak_reward(_Wlv,3) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,32010032,1}]];
get_streak_reward(_Wlv,4) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,32010032,1}]];
get_streak_reward(_Wlv,6) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,7) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,8) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,9) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,11) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,12) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,13) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,14) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,16) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,17) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,18) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,19) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,21) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,22) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,23) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,24) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,26) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,27) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,28) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,29) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,31) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,32) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,33) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,34) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,36) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,37) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,38) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,39) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,41) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,42) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,43) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,44) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,46) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,47) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,48) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,49) when _Wlv >= 710, _Wlv =< 9999 ->
		[[{0,32010032,1}],[{0,20030004,1}]];
get_streak_reward(_Wlv,_Streak_times) ->
	[[],[]].

get_role_rank_reward(_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,38062008,1},{0,32010015,1},{4,0,1000},{0,37010001,20},{0,38040002,30},{8,0,20}];
get_role_rank_reward(_Rank) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010015,1},{4,0,800},{0,37010001,16},{0,38040002,25},{8,0,17}];
get_role_rank_reward(_Rank) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010015,1},{4,0,600},{0,37010001,13},{0,38040002,20},{8,0,14}];
get_role_rank_reward(_Rank) when _Rank >= 4, _Rank =< 10 ->
		[{0,32010015,1},{4,0,500},{0,37010001,11},{0,38040002,18},{8,0,12}];
get_role_rank_reward(_Rank) when _Rank >= 11, _Rank =< 50 ->
		[{0,32010016,1},{4,0,400},{0,37010001,9},{0,38040002,15},{8,0,10}];
get_role_rank_reward(_Rank) when _Rank >= 51, _Rank =< 200 ->
		[{0,32010016,1},{4,0,300},{0,37010001,7},{0,38040002,13},{8,0,8}];
get_role_rank_reward(_Rank) ->
	[].

get_all_role_reward() ->
[1,2,3,4,5].


get_role_reward(1) ->
[{150,[{4,0,100},{2,0,5},{0,19020001,1}]}];


get_role_reward(2) ->
[{400,[{4,0,200},{0,32010001,1},{2,0,5},{0,19020001,2}]}];


get_role_reward(3) ->
[{700,[{4,0,200},{0,32010001,1},{2,0,10}]}];


get_role_reward(4) ->
[{1100,[{4,0,300},{0,32010001,2},{2,0,20},{0,19020001,3}]}];


get_role_reward(5) ->
[{1600,[{4,0,400},{2,0,30},{0,19020001,5}]}];

get_role_reward(_Id) ->
	[].


get_buff_attr(1) ->
[{19,5000},{20,5000},{22,5000}];


get_buff_attr(2) ->
[{19,10000},{20,10000},{22,10000}];

get_buff_attr(_Buffid) ->
	[].

get_buff_id(_WinNum) when _WinNum >= 3, _WinNum < 9 ->
		1;
get_buff_id(_WinNum) when _WinNum >= 10, _WinNum < 999 ->
		2;
get_buff_id(_WinNum) ->
	0.

