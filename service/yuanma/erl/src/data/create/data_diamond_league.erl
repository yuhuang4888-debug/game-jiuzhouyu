%%%---------------------------------------
%%% module      : data_diamond_league
%%% description : 星钻联盟配置
%%%
%%%---------------------------------------
-module(data_diamond_league).
-compile(export_all).
-include("diamond_league.hrl").



get_time_ctrl(0) ->
	#diamond_time_ctrl{id = 0,week_day = 4,time = {22,16,0},next_id = 1};

get_time_ctrl(1) ->
	#diamond_time_ctrl{id = 1,week_day = 4,time = {4,0,0},next_id = 2};

get_time_ctrl(2) ->
	#diamond_time_ctrl{id = 2,week_day = 4,time = {21,30,0},next_id = 3};

get_time_ctrl(3) ->
	#diamond_time_ctrl{id = 3,week_day = 4,time = {21,35,0},next_id = 4};

get_time_ctrl(4) ->
	#diamond_time_ctrl{id = 4,week_day = 4,time = {21,56,0},next_id = 0};

get_time_ctrl(_Id) ->
	[].

get_state_ids() ->
[0,1,2,3,4].


get_kv(1) ->
[{0, 38040035,1}];


get_kv(2) ->
245;


get_kv(3) ->
4500;


get_kv(4) ->
4550;


get_kv(5) ->
[{943,673},{1875,663}];


get_kv(6) ->
[{0, 38040035,2}];

get_kv(_Id) ->
	undefined.


get_win_rewards(1) ->
[{2,36020001, 60}];


get_win_rewards(2) ->
[{2,36020001, 80}];


get_win_rewards(3) ->
[{2,36020001, 100}];


get_win_rewards(4) ->
[{2,36020001, 120}];


get_win_rewards(5) ->
[{2,36020001, 140}];


get_win_rewards(6) ->
[{2,36020001, 160}];


get_win_rewards(7) ->
[{2,36020001, 180}];


get_win_rewards(8) ->
[{2,36020001, 210}];


get_win_rewards(9) ->
[{2,36020001, 250}];


get_win_rewards(10) ->
[{2,36020001, 350}];


get_win_rewards(11) ->
[{2,36020001, 1200}];

get_win_rewards(_Round) ->
	[].


get_lose_rewards(1) ->
[{2,36020001, 60}];


get_lose_rewards(2) ->
[{2,36020001, 80}];


get_lose_rewards(3) ->
[{2,36020001, 100}];


get_lose_rewards(4) ->
[{2,36020001, 120}];


get_lose_rewards(5) ->
[{2,36020001, 140}];


get_lose_rewards(6) ->
[{2,36020001, 160}];


get_lose_rewards(7) ->
[{2,36020001, 180}];


get_lose_rewards(8) ->
[{2,36020001, 210}];


get_lose_rewards(9) ->
[{2,36020001, 250}];


get_lose_rewards(10) ->
[{2,36020001, 350}];


get_lose_rewards(11) ->
[{2,36020001, 500}];

get_lose_rewards(_Round) ->
	[].


get_round_name(1) ->
"混战赛第一轮";


get_round_name(2) ->
"混战赛第二轮";


get_round_name(3) ->
"混战赛第三轮";


get_round_name(4) ->
"混战赛第四轮";


get_round_name(5) ->
"混战赛第五轮";


get_round_name(6) ->
"混战赛第六轮";


get_round_name(7) ->
"混战赛第七轮";


get_round_name(8) ->
"王者赛第一轮";


get_round_name(9) ->
"王者赛第二轮";


get_round_name(10) ->
"王者赛第三轮";


get_round_name(11) ->
"王者赛第四轮";

get_round_name(_Round) ->
	"".

get_skill_ids() ->
[20000000,20000001,20000002].

get_skill_cfg(20000000,_Count) when 1 =< _Count, _Count =< 999 ->
		[[{2, 0, 25}],30];
get_skill_cfg(20000001,_Count) when 1 =< _Count, _Count =< 999 ->
		[[{2, 0, 25}],30];
get_skill_cfg(20000002,_Count) when 1 =< _Count, _Count =< 999 ->
		[[{2, 0, 25}],60];
get_skill_cfg(_Skill_id,_Count) ->
	[].

get_reward_counts(1,1) ->
[1];

get_reward_counts(1,2) ->
[1];

get_reward_counts(1,3) ->
[1];

get_reward_counts(1,4) ->
[1];

get_reward_counts(2,1) ->
[2];

get_reward_counts(2,2) ->
[2];

get_reward_counts(2,3) ->
[2];

get_reward_counts(2,4) ->
[2];

get_reward_counts(3,1) ->
[3];

get_reward_counts(3,2) ->
[3];

get_reward_counts(3,3) ->
[3];

get_reward_counts(3,4) ->
[3];

get_reward_counts(4,1) ->
[3,4];

get_reward_counts(4,2) ->
[3,4];

get_reward_counts(4,3) ->
[3,4];

get_reward_counts(4,4) ->
[3,4];

get_reward_counts(_Allcount,_Priceid) ->
	[].

get_guess_reward(1,1,1) ->
[{2, 0, 90}];

get_guess_reward(1,1,2) ->
[{2, 0, 180}];

get_guess_reward(1,1,3) ->
[{2, 0, 150}];

get_guess_reward(1,1,4) ->
[{2, 0, 300}];

get_guess_reward(2,2,1) ->
[{2, 0, 90}];

get_guess_reward(2,2,2) ->
[{2, 0, 180}];

get_guess_reward(2,2,3) ->
[{2, 0, 150}];

get_guess_reward(2,2,4) ->
[{2, 0, 300}];

get_guess_reward(3,3,1) ->
[{2, 0, 90}];

get_guess_reward(3,3,2) ->
[{2, 0, 180}];

get_guess_reward(3,3,3) ->
[{2, 0, 150}];

get_guess_reward(3,3,4) ->
[{2, 0, 300}];

get_guess_reward(4,3,1) ->
[{2, 0, 90}];

get_guess_reward(4,3,2) ->
[{2, 0, 180}];

get_guess_reward(4,3,3) ->
[{2, 0, 150}];

get_guess_reward(4,3,4) ->
[{2, 0, 300}];

get_guess_reward(4,4,1) ->
[{2, 0, 90}];

get_guess_reward(4,4,2) ->
[{2, 0, 180}];

get_guess_reward(4,4,3) ->
[{2, 0, 150}];

get_guess_reward(4,4,4) ->
[{2, 0, 300}];

get_guess_reward(_Allcount,_Rightcount,_Priceid) ->
	[].


get_guess_price(1) ->
[[{2, 0, 50}]];


get_guess_price(2) ->
[[{2, 0, 100}]];


get_guess_price(3) ->
[[{1, 0, 50}]];


get_guess_price(4) ->
[[{1, 0, 100}]];

get_guess_price(_Priceid) ->
	[].

