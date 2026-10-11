%%%---------------------------------------
%%% module      : data_sanctuary
%%% description : 圣域配置
%%%
%%%---------------------------------------
-module(data_sanctuary).
-compile(export_all).
-include("sanctuary.hrl").




get_sanctuary_scene(1) ->
36001;


get_sanctuary_scene(2) ->
36002;


get_sanctuary_scene(3) ->
36003;

get_sanctuary_scene(_Sanctuaryid) ->
	0.


get_sanctuary_id_by_scene(36001) ->
1;


get_sanctuary_id_by_scene(36002) ->
2;


get_sanctuary_id_by_scene(36003) ->
3;

get_sanctuary_id_by_scene(_Sceneid) ->
	[].


get_sanctuary_name(1) ->
<<"隐冰圣域"/utf8>>;


get_sanctuary_name(2) ->
<<"千森圣域"/utf8>>;


get_sanctuary_name(3) ->
<<"落日圣域"/utf8>>;

get_sanctuary_name(_Sanctuaryid) ->
	[].


get_kv(add_guild_member_limit) ->
20;


get_kv(belonger_reward) ->
[];


get_kv(die_wait_time) ->
[{min_times, 4},{special,[{5,30}]},{extra, 30}];


get_kv(fatigue_limit) ->
80;


get_kv(kill_player_reward) ->
[{255, 42, 2}];


get_kv(kill_point) ->
[{1, 10}, {2, 20}, {3, 0.3}];


get_kv(kill_reward) ->
[{1, 5}, {2, 20}, {3, 50}];


get_kv(limit_lv) ->
95;


get_kv(open_day) ->
{2,4};


get_kv(open_time) ->
{2019, 6, 15};


get_kv(participant_reward) ->
[];


get_kv(participant_reward_limit) ->
10;


get_kv(player_die_times) ->
300;


get_kv(rank_reward_match_limit) ->
10;


get_kv(reborn_time_after_die_time_limit) ->
[{4, 15}, {99999, 0}];


get_kv(remind_cd) ->
360;


get_kv(revive_point_gost) ->
15;


get_kv(sanctuary_clear_day) ->
5;

get_kv(_Sanctuarykey) ->
	[].

get_mon_type(1,2800101) ->
1;

get_mon_type(1,2800102) ->
1;

get_mon_type(1,2800103) ->
1;

get_mon_type(1,2800104) ->
1;

get_mon_type(1,2800105) ->
1;

get_mon_type(1,2800106) ->
1;

get_mon_type(1,2800107) ->
2;

get_mon_type(1,2800108) ->
2;

get_mon_type(1,2800109) ->
2;

get_mon_type(1,2800110) ->
3;

get_mon_type(2,2800111) ->
1;

get_mon_type(2,2800112) ->
1;

get_mon_type(2,2800113) ->
1;

get_mon_type(2,2800114) ->
1;

get_mon_type(2,2800115) ->
1;

get_mon_type(2,2800116) ->
1;

get_mon_type(2,2800117) ->
2;

get_mon_type(2,2800118) ->
2;

get_mon_type(2,2800119) ->
2;

get_mon_type(2,2800120) ->
3;

get_mon_type(3,2800121) ->
1;

get_mon_type(3,2800122) ->
1;

get_mon_type(3,2800123) ->
1;

get_mon_type(3,2800124) ->
1;

get_mon_type(3,2800125) ->
1;

get_mon_type(3,2800126) ->
1;

get_mon_type(3,2800127) ->
2;

get_mon_type(3,2800128) ->
2;

get_mon_type(3,2800129) ->
2;

get_mon_type(3,2800130) ->
3;

get_mon_type(_Sanctuaryid,_Monid) ->
	[].


get_mon_list_by_sanctuary(1) ->
[2800101,2800102,2800103,2800104,2800105,2800106,2800107,2800108,2800109,2800110];


get_mon_list_by_sanctuary(2) ->
[2800111,2800112,2800113,2800114,2800115,2800116,2800117,2800118,2800119,2800120];


get_mon_list_by_sanctuary(3) ->
[2800121,2800122,2800123,2800124,2800125,2800126,2800127,2800128,2800129,2800130];

get_mon_list_by_sanctuary(_Sanctuaryid) ->
	[].

get_mon_list_by_sanctuary_and_type(1,1) ->
[2800101,2800102,2800103,2800104,2800105,2800106];

get_mon_list_by_sanctuary_and_type(1,2) ->
[2800107,2800108,2800109];

get_mon_list_by_sanctuary_and_type(1,3) ->
[2800110];

get_mon_list_by_sanctuary_and_type(2,1) ->
[2800111,2800112,2800113,2800114,2800115,2800116];

get_mon_list_by_sanctuary_and_type(2,2) ->
[2800117,2800118,2800119];

get_mon_list_by_sanctuary_and_type(2,3) ->
[2800120];

get_mon_list_by_sanctuary_and_type(3,1) ->
[2800121,2800122,2800123,2800124,2800125,2800126];

get_mon_list_by_sanctuary_and_type(3,2) ->
[2800127,2800128,2800129];

get_mon_list_by_sanctuary_and_type(3,3) ->
[2800130];

get_mon_list_by_sanctuary_and_type(_Sanctuaryid,_Montype) ->
	[].

get_designation_list() ->
[306001,306002,306003,306004,306005,306006,306007,306008,306009].

get_designation_by_rank(1,_Rank) when _Rank >= 1, _Rank =< 1 ->
		306001;
get_designation_by_rank(1,_Rank) when _Rank >= 2, _Rank =< 4 ->
		306002;
get_designation_by_rank(1,_Rank) when _Rank >= 5, _Rank =< 10 ->
		306003;
get_designation_by_rank(2,_Rank) when _Rank >= 1, _Rank =< 1 ->
		306004;
get_designation_by_rank(2,_Rank) when _Rank >= 2, _Rank =< 4 ->
		306005;
get_designation_by_rank(2,_Rank) when _Rank >= 5, _Rank =< 10 ->
		306006;
get_designation_by_rank(3,_Rank) when _Rank >= 1, _Rank =< 1 ->
		306007;
get_designation_by_rank(3,_Rank) when _Rank >= 2, _Rank =< 4 ->
		306008;
get_designation_by_rank(3,_Rank) when _Rank >= 5, _Rank =< 10 ->
		306009;
get_designation_by_rank(_Sanctuary_id,_Rank) ->
	[].

