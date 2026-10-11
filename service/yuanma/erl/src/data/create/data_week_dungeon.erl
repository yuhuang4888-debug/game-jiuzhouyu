%%%---------------------------------------
%%% module      : data_week_dungeon
%%% description : 周常本配置
%%%
%%%---------------------------------------
-module(data_week_dungeon).
-compile(export_all).
-include("week_dungeon.hrl").




get_key(0) ->
3;


get_key(1) ->
3;


get_key(3) ->
[{0,1},{1,1},{1.2,1}];

get_key(_Key) ->
	[].

get_week_dungeon(1) ->
	#base_week_dungeon{dun_id = 1,dun_name = "极寒之地",single_dun_id = 36001,team_dun_id = 36101,single_rewards = [{0,7305001,2}],team_rewards = [{0,7305001,2}],revive_count = 8,help_count = 3,help_reward = [{0,32010446,1}],time_score = [{1,1441,3600},{2,1081,1440},{3,1,1080}],dun_attr = [{1,15000},{2,300000},{3,7500},{4,7500},{7,6000},{6,3000},{10,10000}],active_skill = [],passive_skill = [{1,[{370002,1},{370013,1},{1401001,1}]},{2,[{370002,1},{370023,1},{1401001,1}]},{3,[{370002,1},{370033,1},{1401001,1}]},{4,[{370002,1},{370043,1},{1401001,1}]}]};

get_week_dungeon(2) ->
	#base_week_dungeon{dun_id = 2,dun_name = "埋骨之地",single_dun_id = 36002,team_dun_id = 36102,single_rewards = [{0,7305001,2}],team_rewards = [{0,7305001,3}],revive_count = 8,help_count = 3,help_reward = [{0,32010446,1}],time_score = [{1,1441,3600},{2,1081,1440},{3,1,1080}],dun_attr = [{1,1200},{2,300000},{3,600},{4,7500},{7,6000},{6,3000},{9,75000},{27,125000}],active_skill = [],passive_skill = [{1,[{370002,1},{370013,1},{1401001,1}]},{2,[{370002,1},{370023,1},{1401001,1}]},{3,[{370002,1},{370033,1},{1401001,1}]},{4,[{370002,1},{370043,1},{1401001,1}]}]};

get_week_dungeon(_Dunid) ->
	[].

get_all_week_dun() ->
[{1,36001,36101},{2,36002,36102}].


get_week_dun_id_1(1) ->
1;


get_week_dun_id_1(2) ->
2;

get_week_dun_id_1(_Dunid) ->
	0.


get_week_dun_id_2(36001) ->
1;


get_week_dun_id_2(36002) ->
2;

get_week_dun_id_2(_Singledunid) ->
	0.


get_week_dun_id_3(36101) ->
1;


get_week_dun_id_3(36102) ->
2;

get_week_dun_id_3(_Teamdunid) ->
	0.

get_rank_reward(36101,_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,7305002,1},{0,7301001,50},{0,38065069,1}];
get_rank_reward(36101,_Rank) when _Rank >= 2, _Rank =< 3 ->
		[{0,7305002,1},{0,7301001,30}];
get_rank_reward(36101,_Rank) when _Rank >= 4, _Rank =< 10 ->
		[{0,7305001,4},{0,7301001,20}];
get_rank_reward(36102,_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,7305002,1},{0,7301001,50},{0,38065069,1}];
get_rank_reward(36102,_Rank) when _Rank >= 2, _Rank =< 3 ->
		[{0,7305002,1},{0,7301001,30}];
get_rank_reward(36102,_Rank) when _Rank >= 4, _Rank =< 10 ->
		[{0,7305001,4},{0,7301001,20}];
get_rank_reward(_Dun_id,_Rank) ->
	[].

get_all_boss_id_list() ->
[3601001,3601002,3601003,3601004,3601005,3601006,3602101,3602102,3602103,3602104,3602201,3602202,3602203,3602204,3602205].


get_boss_id_list(36001) ->
[3601001,3601002,3601003];


get_boss_id_list(36101) ->
[3601004,3601005,3601006];


get_boss_id_list(36002) ->
[3602101,3602102,3602103,3602104];


get_boss_id_list(36102) ->
[3602201,3602202,3602203,3602204,3602205];

get_boss_id_list(_Reldunid) ->
	[].

get_boss_reward_view(36001,3601001) ->
[{100,7302001,2},{0,7301001,3},{0,7305001,2}];

get_boss_reward_view(36001,3601002) ->
[{100,7302001,2},{0,7301001,3},{0,7305001,3}];

get_boss_reward_view(36001,3601003) ->
[{100,7302001,3},{0,7301001,4},{0,7305001,4}];

get_boss_reward_view(36101,3601004) ->
[{100,7302001,3},{0,7301003,5},{0,7305001,3}];

get_boss_reward_view(36101,3601005) ->
[{100,7302002,3},{0,7301003,5},{0,7305001,5}];

get_boss_reward_view(36101,3601006) ->
[{100,7302002,3},{0,7301005,5},{0,7305001,8}];

get_boss_reward_view(36002,3602101) ->
[{100,7302002,1},{0,7305001,1}];

get_boss_reward_view(36002,3602102) ->
[{100,7302002,1},{0,7301003,3},{0,7305001,1}];

get_boss_reward_view(36002,3602103) ->
[{100,7302002,2},{0,7301003,3},{0,7305001,1}];

get_boss_reward_view(36002,3602104) ->
[];

get_boss_reward_view(36102,3602201) ->
[{100,7302003,1},{0,7301003,5},{0,7305001,2}];

get_boss_reward_view(36102,3602202) ->
[{100,7302003,1},{0,7301005,5},{0,7305001,2}];

get_boss_reward_view(36102,3602203) ->
[{100,7302003,2},{0,7301005,5},{0,7305001,2}];

get_boss_reward_view(36102,3602204) ->
[];

get_boss_reward_view(36102,3602205) ->
[];

get_boss_reward_view(_Reldunid,_Bossid) ->
	[].

