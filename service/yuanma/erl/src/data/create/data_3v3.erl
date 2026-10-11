%%%---------------------------------------
%%% module      : data_3v3
%%% description : 3v3配置
%%%
%%%---------------------------------------
-module(data_3v3).
-compile(export_all).
-include("3v3.hrl").



get_act_info(1) ->
	#act_info{id = 1,week = [4,6],time = [{21, 00, 00},{21, 30, 00}]};

get_act_info(_Id) ->
	[].

get_act_list() ->
[1].

get_act_rewards_list() ->
[4,1,2].


get_act_rewards(4) ->
[{255,36255024,3000}];


get_act_rewards(1) ->
[{255,36255024,800}];


get_act_rewards(2) ->
[{255,36255024,1500}];

get_act_rewards(_Winnum) ->
	[].

get_tier_info(26) ->
	#tier_info{tier = 26,stage = 6,star = 440,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"王者"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,800}],k_value = 8};

get_tier_info(25) ->
	#tier_info{tier = 25,stage = 5,star = 420,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"钻石Ⅰ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,800}],k_value = 8};

get_tier_info(24) ->
	#tier_info{tier = 24,stage = 5,star = 400,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"钻石Ⅱ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,800}],k_value = 8};

get_tier_info(23) ->
	#tier_info{tier = 23,stage = 5,star = 380,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"钻石Ⅲ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,800}],k_value = 8};

get_tier_info(22) ->
	#tier_info{tier = 22,stage = 5,star = 350,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"钻石Ⅳ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,800}],k_value = 8};

get_tier_info(21) ->
	#tier_info{tier = 21,stage = 5,star = 320,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"钻石Ⅴ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,800}],k_value = 8};

get_tier_info(20) ->
	#tier_info{tier = 20,stage = 4,star = 290,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"黄金Ⅰ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,650}],k_value = 14};

get_tier_info(19) ->
	#tier_info{tier = 19,stage = 4,star = 270,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"黄金Ⅱ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,650}],k_value = 14};

get_tier_info(18) ->
	#tier_info{tier = 18,stage = 4,star = 250,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"黄金Ⅲ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,650}],k_value = 14};

get_tier_info(17) ->
	#tier_info{tier = 17,stage = 4,star = 230,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"黄金Ⅳ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,650}],k_value = 14};

get_tier_info(16) ->
	#tier_info{tier = 16,stage = 4,star = 200,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"黄金Ⅴ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,650}],k_value = 14};

get_tier_info(15) ->
	#tier_info{tier = 15,stage = 3,star = 180,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"白银Ⅰ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,500}],k_value = 20};

get_tier_info(14) ->
	#tier_info{tier = 14,stage = 3,star = 160,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"白银Ⅱ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,500}],k_value = 20};

get_tier_info(13) ->
	#tier_info{tier = 13,stage = 3,star = 140,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"白银Ⅲ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,400}],k_value = 20};

get_tier_info(12) ->
	#tier_info{tier = 12,stage = 3,star = 120,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"白银Ⅳ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,400}],k_value = 20};

get_tier_info(11) ->
	#tier_info{tier = 11,stage = 3,star = 100,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"白银Ⅴ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,400}],k_value = 20};

get_tier_info(10) ->
	#tier_info{tier = 10,stage = 2,star = 90,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"青铜Ⅰ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,400}],k_value = 26};

get_tier_info(9) ->
	#tier_info{tier = 9,stage = 2,star = 80,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"青铜Ⅱ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,400}],k_value = 26};

get_tier_info(8) ->
	#tier_info{tier = 8,stage = 2,star = 70,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"青铜Ⅲ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,400}],k_value = 26};

get_tier_info(7) ->
	#tier_info{tier = 7,stage = 2,star = 60,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"青铜Ⅳ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,400}],k_value = 26};

get_tier_info(6) ->
	#tier_info{tier = 6,stage = 2,star = 50,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"青铜Ⅴ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,250}],k_value = 26};

get_tier_info(5) ->
	#tier_info{tier = 5,stage = 1,star = 40,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"黑铁Ⅰ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,250}],k_value = 30};

get_tier_info(4) ->
	#tier_info{tier = 4,stage = 1,star = 30,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"黑铁Ⅱ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,250}],k_value = 30};

get_tier_info(3) ->
	#tier_info{tier = 3,stage = 1,star = 20,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"黑铁Ⅲ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,250}],k_value = 30};

get_tier_info(2) ->
	#tier_info{tier = 2,stage = 1,star = 10,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"黑铁Ⅳ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,250}],k_value = 30};

get_tier_info(1) ->
	#tier_info{tier = 1,stage = 1,star = 0,daily_reward = 0,win_star = 0,lose_star = 0,win_reward = [{255,36255024,600}],lose_reward = [{255,36255024,400}],tier_name = <<"黑铁Ⅴ"/utf8>>,win_fame = 0,lose_fame = 0,season_reward = [],today_reward = [{255,36255024,100}],k_value = 30};

get_tier_info(_Tier) ->
	[].

get_tier_and_star_info() ->
[{1,0},{2,10},{3,20},{4,30},{5,40},{6,50},{7,60},{8,70},{9,80},{10,90},{11,100},{12,120},{13,140},{14,160},{15,180},{16,200},{17,230},{18,250},{19,270},{20,290},{21,320},{22,350},{23,380},{24,400},{25,420},{26,440}].

get_win_row(_Winrow) ->
	0.

get_rank_rewards(_Rank) ->
	0.


get_inherit_tier(29) ->
1;


get_inherit_tier(28) ->
1;


get_inherit_tier(27) ->
1;


get_inherit_tier(26) ->
1;


get_inherit_tier(25) ->
1;


get_inherit_tier(24) ->
1;


get_inherit_tier(23) ->
1;


get_inherit_tier(22) ->
1;


get_inherit_tier(21) ->
1;


get_inherit_tier(20) ->
1;


get_inherit_tier(19) ->
1;


get_inherit_tier(18) ->
1;


get_inherit_tier(17) ->
1;


get_inherit_tier(16) ->
1;


get_inherit_tier(15) ->
1;


get_inherit_tier(14) ->
1;


get_inherit_tier(13) ->
1;


get_inherit_tier(12) ->
1;


get_inherit_tier(11) ->
1;


get_inherit_tier(10) ->
1;


get_inherit_tier(9) ->
1;


get_inherit_tier(8) ->
1;


get_inherit_tier(7) ->
1;


get_inherit_tier(6) ->
1;


get_inherit_tier(5) ->
1;


get_inherit_tier(4) ->
1;


get_inherit_tier(3) ->
1;


get_inherit_tier(2) ->
1;


get_inherit_tier(1) ->
1;

get_inherit_tier(_Oldtier) ->
	false.


get_kv(add_score) ->
20;


get_kv(add_score_ratio) ->
[{1, 0}, {2,0}, {3,0.6}];


get_kv(altar_coordinate) ->
[{1,{856, 675}}, {2, {2380,1610}}, {3, {3835,2644}}];


get_kv(altar_radius) ->
500;


get_kv(champion_pk_fail_reward) ->
[{255,36255024,400}];


get_kv(champion_pk_win_reward) ->
[{255,36255024,600}];


get_kv(change_name_cost) ->
[{2, 0, 200}];


get_kv(create_team_cost) ->
[];


get_kv(daily_match_count) ->
4;


get_kv(oval_radius) ->
{420, 210};


get_kv(reborn_coordinate) ->
[{red, {761, 2781}}, {blue, {3974,463}}];


get_kv(server_open_day) ->
9999;


get_kv(speed) ->
[{1,12}, {2,18}, {3, 25}];

get_kv(_Key) ->
	[].

get_fame_reward_list() ->
[].

get_fame_reward_by_id(_Id) ->
	[].

get_fame_by_id(_Id) ->
	0.


get_champion_reward(1) ->
[{0,38063021,1},{0,32010299,20},{0,16010003,2},{0,58010002,30}];


get_champion_reward(2) ->
[{0,38063020,1},{0,32010299,15},{0,16010003,1},{0,58010002,20}];


get_champion_reward(4) ->
[{0,32010299,10},{0,16010003,1},{0,58010002,15}];


get_champion_reward(8) ->
[{0,32010299,8},{0,16010003,1},{0,58010002,10}];


get_champion_reward(16) ->
[{0,32010299,5},{0,16010003,1},{0,58010002,8}];

get_champion_reward(_Rank) ->
	[].

get_guess_config(1) ->
	#base_guess_config{turn = 1,type = 1,opt_list = [{1,1},{2,2}],cost_list = [{2,1,50},{36255024,1,1000}],reward_list = [{1,[{2,2},{36255024,2}]},{2,[{2,0.3},{36255024,0.3}]}]};

get_guess_config(2) ->
	#base_guess_config{turn = 2,type = 2,opt_list = [{1,0,1},{2,2,2},{3,3,3}],cost_list = [{2,1,80},{36255024,1,2000}],reward_list = [{1,[{2,2.5},{36255024,2.5}]},{2,[{2,0.3},{36255024,0.3}]}]};

get_guess_config(3) ->
	#base_guess_config{turn = 3,type = 2,opt_list = [{1,0,1},{2,2,2},{3,3,3}],cost_list = [{2,1,100},{36255024,1,3000}],reward_list = [{1,[{2,2.5},{36255024,2.5}]},{2,[{2,0.3},{36255024,0.3}]}]};

get_guess_config(4) ->
	#base_guess_config{turn = 4,type = 3,opt_list = [{1,0,500},{2,501,1000},{3,1001,2000}],cost_list = [{2,1,120},{36255024,1,5000}],reward_list = [{1,[{2,3},{36255024,3}]},{2,[{2,0.3},{36255024,0.3}]}]};

get_guess_config(_Turn) ->
	[].

get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 300, _WorldLv =< 329, _Point >= 0, _Point =< 50 ->
		2400000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 300, _WorldLv =< 329, _Point >= 51, _Point =< 100 ->
		2880000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 300, _WorldLv =< 329, _Point >= 101, _Point =< 200 ->
		3600000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 300, _WorldLv =< 329, _Point >= 201, _Point =< 320 ->
		4800000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 300, _WorldLv =< 329, _Point >= 321, _Point =< 440 ->
		6000000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 300, _WorldLv =< 329, _Point >= 441, _Point =< 9999 ->
		7200000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 330, _WorldLv =< 359, _Point >= 0, _Point =< 50 ->
		3300000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 330, _WorldLv =< 359, _Point >= 51, _Point =< 100 ->
		3960000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 330, _WorldLv =< 359, _Point >= 101, _Point =< 200 ->
		4950000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 330, _WorldLv =< 359, _Point >= 201, _Point =< 320 ->
		6600000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 330, _WorldLv =< 359, _Point >= 321, _Point =< 440 ->
		8250000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 330, _WorldLv =< 359, _Point >= 441, _Point =< 9999 ->
		9900000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 360, _WorldLv =< 389, _Point >= 0, _Point =< 50 ->
		4760000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 360, _WorldLv =< 389, _Point >= 51, _Point =< 100 ->
		5712000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 360, _WorldLv =< 389, _Point >= 101, _Point =< 200 ->
		7140000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 360, _WorldLv =< 389, _Point >= 201, _Point =< 320 ->
		9520000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 360, _WorldLv =< 389, _Point >= 321, _Point =< 440 ->
		11900000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 360, _WorldLv =< 389, _Point >= 441, _Point =< 9999 ->
		14280000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 390, _WorldLv =< 419, _Point >= 0, _Point =< 50 ->
		6800000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 390, _WorldLv =< 419, _Point >= 51, _Point =< 100 ->
		8160000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 390, _WorldLv =< 419, _Point >= 101, _Point =< 200 ->
		10200000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 390, _WorldLv =< 419, _Point >= 201, _Point =< 320 ->
		13600000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 390, _WorldLv =< 419, _Point >= 321, _Point =< 440 ->
		17000000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 390, _WorldLv =< 419, _Point >= 441, _Point =< 9999 ->
		20400000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 420, _WorldLv =< 439, _Point >= 0, _Point =< 50 ->
		8840000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 420, _WorldLv =< 439, _Point >= 51, _Point =< 100 ->
		10608000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 420, _WorldLv =< 439, _Point >= 101, _Point =< 200 ->
		13260000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 420, _WorldLv =< 439, _Point >= 201, _Point =< 320 ->
		17680000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 420, _WorldLv =< 439, _Point >= 321, _Point =< 440 ->
		22100000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 420, _WorldLv =< 439, _Point >= 441, _Point =< 9999 ->
		26520000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 440, _WorldLv =< 459, _Point >= 0, _Point =< 50 ->
		10200000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 440, _WorldLv =< 459, _Point >= 51, _Point =< 100 ->
		12240000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 440, _WorldLv =< 459, _Point >= 101, _Point =< 200 ->
		15300000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 440, _WorldLv =< 459, _Point >= 201, _Point =< 320 ->
		20400000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 440, _WorldLv =< 459, _Point >= 321, _Point =< 440 ->
		25500000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 440, _WorldLv =< 459, _Point >= 441, _Point =< 9999 ->
		30600000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 460, _WorldLv =< 479, _Point >= 0, _Point =< 50 ->
		11560000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 460, _WorldLv =< 479, _Point >= 51, _Point =< 100 ->
		13872000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 460, _WorldLv =< 479, _Point >= 101, _Point =< 200 ->
		17340000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 460, _WorldLv =< 479, _Point >= 201, _Point =< 320 ->
		23120000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 460, _WorldLv =< 479, _Point >= 321, _Point =< 440 ->
		28900000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 460, _WorldLv =< 479, _Point >= 441, _Point =< 9999 ->
		34680000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 480, _WorldLv =< 499, _Point >= 0, _Point =< 50 ->
		12920000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 480, _WorldLv =< 499, _Point >= 51, _Point =< 100 ->
		15504000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 480, _WorldLv =< 499, _Point >= 101, _Point =< 200 ->
		19380000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 480, _WorldLv =< 499, _Point >= 201, _Point =< 320 ->
		25840000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 480, _WorldLv =< 499, _Point >= 321, _Point =< 440 ->
		32300000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 480, _WorldLv =< 499, _Point >= 441, _Point =< 9999 ->
		38760000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 500, _WorldLv =< 519, _Point >= 0, _Point =< 50 ->
		14280000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 500, _WorldLv =< 519, _Point >= 51, _Point =< 100 ->
		17136000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 500, _WorldLv =< 519, _Point >= 101, _Point =< 200 ->
		21420000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 500, _WorldLv =< 519, _Point >= 201, _Point =< 320 ->
		28560000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 500, _WorldLv =< 519, _Point >= 321, _Point =< 440 ->
		35700000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 500, _WorldLv =< 519, _Point >= 441, _Point =< 9999 ->
		42840000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 520, _WorldLv =< 539, _Point >= 0, _Point =< 50 ->
		17000000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 520, _WorldLv =< 539, _Point >= 51, _Point =< 100 ->
		20400000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 520, _WorldLv =< 539, _Point >= 101, _Point =< 200 ->
		25500000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 520, _WorldLv =< 539, _Point >= 201, _Point =< 320 ->
		34000000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 520, _WorldLv =< 539, _Point >= 321, _Point =< 440 ->
		42500000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 520, _WorldLv =< 539, _Point >= 441, _Point =< 9999 ->
		51000000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 540, _WorldLv =< 559, _Point >= 0, _Point =< 50 ->
		19720000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 540, _WorldLv =< 559, _Point >= 51, _Point =< 100 ->
		23664000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 540, _WorldLv =< 559, _Point >= 101, _Point =< 200 ->
		29580000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 540, _WorldLv =< 559, _Point >= 201, _Point =< 320 ->
		39440000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 540, _WorldLv =< 559, _Point >= 321, _Point =< 440 ->
		49300000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 540, _WorldLv =< 559, _Point >= 441, _Point =< 9999 ->
		59160000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 560, _WorldLv =< 579, _Point >= 0, _Point =< 50 ->
		22440000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 560, _WorldLv =< 579, _Point >= 51, _Point =< 100 ->
		26928000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 560, _WorldLv =< 579, _Point >= 101, _Point =< 200 ->
		33660000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 560, _WorldLv =< 579, _Point >= 201, _Point =< 320 ->
		44880000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 560, _WorldLv =< 579, _Point >= 321, _Point =< 440 ->
		56100000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 560, _WorldLv =< 579, _Point >= 441, _Point =< 9999 ->
		67320000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 580, _WorldLv =< 599, _Point >= 0, _Point =< 50 ->
		25160000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 580, _WorldLv =< 599, _Point >= 51, _Point =< 100 ->
		30192000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 580, _WorldLv =< 599, _Point >= 101, _Point =< 200 ->
		37740000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 580, _WorldLv =< 599, _Point >= 201, _Point =< 320 ->
		50320000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 580, _WorldLv =< 599, _Point >= 321, _Point =< 440 ->
		62900000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 580, _WorldLv =< 599, _Point >= 441, _Point =< 9999 ->
		75480000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 600, _WorldLv =< 619, _Point >= 0, _Point =< 50 ->
		27880000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 600, _WorldLv =< 619, _Point >= 51, _Point =< 100 ->
		33456000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 600, _WorldLv =< 619, _Point >= 101, _Point =< 200 ->
		41820000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 600, _WorldLv =< 619, _Point >= 201, _Point =< 320 ->
		55760000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 600, _WorldLv =< 619, _Point >= 321, _Point =< 440 ->
		69700000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 600, _WorldLv =< 619, _Point >= 441, _Point =< 9999 ->
		83640000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 620, _WorldLv =< 639, _Point >= 0, _Point =< 50 ->
		30600000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 620, _WorldLv =< 639, _Point >= 51, _Point =< 100 ->
		36720000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 620, _WorldLv =< 639, _Point >= 101, _Point =< 200 ->
		45900000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 620, _WorldLv =< 639, _Point >= 201, _Point =< 320 ->
		61200000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 620, _WorldLv =< 639, _Point >= 321, _Point =< 440 ->
		76500000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 620, _WorldLv =< 639, _Point >= 441, _Point =< 9999 ->
		91800000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 640, _WorldLv =< 659, _Point >= 0, _Point =< 50 ->
		36040000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 640, _WorldLv =< 659, _Point >= 51, _Point =< 100 ->
		43248000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 640, _WorldLv =< 659, _Point >= 101, _Point =< 200 ->
		54060000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 640, _WorldLv =< 659, _Point >= 201, _Point =< 320 ->
		72080000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 640, _WorldLv =< 659, _Point >= 321, _Point =< 440 ->
		90100000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 640, _WorldLv =< 659, _Point >= 441, _Point =< 9999 ->
		108120000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 660, _WorldLv =< 679, _Point >= 0, _Point =< 50 ->
		41480000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 660, _WorldLv =< 679, _Point >= 51, _Point =< 100 ->
		49776000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 660, _WorldLv =< 679, _Point >= 101, _Point =< 200 ->
		62220000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 660, _WorldLv =< 679, _Point >= 201, _Point =< 320 ->
		82960000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 660, _WorldLv =< 679, _Point >= 321, _Point =< 440 ->
		103700000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 660, _WorldLv =< 679, _Point >= 441, _Point =< 9999 ->
		124440000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 680, _WorldLv =< 699, _Point >= 0, _Point =< 50 ->
		46920000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 680, _WorldLv =< 699, _Point >= 51, _Point =< 100 ->
		56304000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 680, _WorldLv =< 699, _Point >= 101, _Point =< 200 ->
		70380000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 680, _WorldLv =< 699, _Point >= 201, _Point =< 320 ->
		93840000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 680, _WorldLv =< 699, _Point >= 321, _Point =< 440 ->
		117300000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 680, _WorldLv =< 699, _Point >= 441, _Point =< 9999 ->
		140760000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 700, _WorldLv =< 9999, _Point >= 0, _Point =< 50 ->
		52360000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 700, _WorldLv =< 9999, _Point >= 51, _Point =< 100 ->
		62832000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 700, _WorldLv =< 9999, _Point >= 101, _Point =< 200 ->
		78540000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 700, _WorldLv =< 9999, _Point >= 201, _Point =< 320 ->
		104720000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 700, _WorldLv =< 9999, _Point >= 321, _Point =< 440 ->
		130900000;
get_3v3_standard_power(_WorldLv,_Point) when _WorldLv >= 700, _WorldLv =< 9999, _Point >= 441, _Point =< 9999 ->
		157080000;
get_3v3_standard_power(_WorldLv,_Point) ->
	0.

