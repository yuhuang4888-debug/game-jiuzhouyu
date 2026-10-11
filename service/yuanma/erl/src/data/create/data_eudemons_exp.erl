%%%---------------------------------------
%%% module      : data_eudemons_exp
%%% description : 圣兽领经验配置
%%%
%%%---------------------------------------
-module(data_eudemons_exp).
-compile(export_all).




get_eudemons_exp(1) ->
0;


get_eudemons_exp(2) ->
50;


get_eudemons_exp(3) ->
105;


get_eudemons_exp(4) ->
155;


get_eudemons_exp(5) ->
315;


get_eudemons_exp(6) ->
380;


get_eudemons_exp(7) ->
490;


get_eudemons_exp(8) ->
615;


get_eudemons_exp(9) ->
820;


get_eudemons_exp(10) ->
1025;


get_eudemons_exp(11) ->
1095;


get_eudemons_exp(12) ->
1365;


get_eudemons_exp(13) ->
1775;


get_eudemons_exp(14) ->
1863;


get_eudemons_exp(15) ->
2294;


get_eudemons_exp(16) ->
3008;

get_eudemons_exp(_Lv) ->
	9999.

get_eudemons_max_lv() -> 16.


get_boss_kill_exp(2101001) ->
35;


get_boss_kill_exp(2101002) ->
35;


get_boss_kill_exp(2101003) ->
40;


get_boss_kill_exp(2101004) ->
40;


get_boss_kill_exp(2101005) ->
45;


get_boss_kill_exp(2101006) ->
45;


get_boss_kill_exp(2101007) ->
50;


get_boss_kill_exp(2101008) ->
50;


get_boss_kill_exp(2101009) ->
60;


get_boss_kill_exp(2101010) ->
60;


get_boss_kill_exp(2101011) ->
60;


get_boss_kill_exp(2101012) ->
60;


get_boss_kill_exp(2101013) ->
60;


get_boss_kill_exp(2101014) ->
60;


get_boss_kill_exp(2101015) ->
60;


get_boss_kill_exp(2101016) ->
60;


get_boss_kill_exp(2101017) ->
60;


get_boss_kill_exp(2101018) ->
60;


get_boss_kill_exp(2101019) ->
60;


get_boss_kill_exp(2101020) ->
60;


get_boss_kill_exp(2101021) ->
60;


get_boss_kill_exp(2101022) ->
60;


get_boss_kill_exp(2101023) ->
60;


get_boss_kill_exp(2101024) ->
60;


get_boss_kill_exp(2101028) ->
6;


get_boss_kill_exp(2101029) ->
7;


get_boss_kill_exp(2101030) ->
6;


get_boss_kill_exp(2101031) ->
7;


get_boss_kill_exp(2101032) ->
6;


get_boss_kill_exp(2101033) ->
7;


get_boss_kill_exp(2101034) ->
3;


get_boss_kill_exp(2101035) ->
3;


get_boss_kill_exp(2101036) ->
3;


get_boss_kill_exp(2101301) ->
0;


get_boss_kill_exp(2101302) ->
0;


get_boss_kill_exp(2101303) ->
0;

get_boss_kill_exp(_Bossid) ->
	0.


get_boss_kill_score(2101001) ->
100;


get_boss_kill_score(2101002) ->
110;


get_boss_kill_score(2101003) ->
120;


get_boss_kill_score(2101004) ->
130;


get_boss_kill_score(2101005) ->
140;


get_boss_kill_score(2101006) ->
150;


get_boss_kill_score(2101007) ->
160;


get_boss_kill_score(2101008) ->
170;


get_boss_kill_score(2101009) ->
180;


get_boss_kill_score(2101010) ->
190;


get_boss_kill_score(2101011) ->
200;


get_boss_kill_score(2101012) ->
210;


get_boss_kill_score(2101013) ->
220;


get_boss_kill_score(2101014) ->
230;


get_boss_kill_score(2101015) ->
240;


get_boss_kill_score(2101016) ->
250;


get_boss_kill_score(2101017) ->
260;


get_boss_kill_score(2101018) ->
270;


get_boss_kill_score(2101019) ->
275;


get_boss_kill_score(2101020) ->
280;


get_boss_kill_score(2101021) ->
285;


get_boss_kill_score(2101022) ->
290;


get_boss_kill_score(2101023) ->
295;


get_boss_kill_score(2101024) ->
300;


get_boss_kill_score(2101028) ->
0;


get_boss_kill_score(2101029) ->
0;


get_boss_kill_score(2101030) ->
0;


get_boss_kill_score(2101031) ->
0;


get_boss_kill_score(2101032) ->
0;


get_boss_kill_score(2101033) ->
0;


get_boss_kill_score(2101034) ->
0;


get_boss_kill_score(2101035) ->
0;


get_boss_kill_score(2101036) ->
0;


get_boss_kill_score(2101301) ->
80;


get_boss_kill_score(2101302) ->
80;


get_boss_kill_score(2101303) ->
80;

get_boss_kill_score(_Bossid) ->
	0.

get_rank_reward(1,_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,38063017,1},{0,39510000,30}];
get_rank_reward(1,_Rank) when _Rank >= 2, _Rank =< 2 ->
		[{0,39510000,25}];
get_rank_reward(1,_Rank) when _Rank >= 3, _Rank =< 3 ->
		[{0,39510000,20}];
get_rank_reward(1,_Rank) when _Rank >= 4, _Rank =< 6 ->
		[{0,39510000,15}];
get_rank_reward(1,_Rank) when _Rank >= 7, _Rank =< 20 ->
		[{0,39510000,12}];
get_rank_reward(2,_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,38063016,1},{0,19020003,2},{0,19010002,3}];
get_rank_reward(2,_Rank) when _Rank >= 2, _Rank =< 2 ->
		[{0,19020003,2},{0,19010002,3}];
get_rank_reward(2,_Rank) when _Rank >= 3, _Rank =< 3 ->
		[{0,19020003,1},{0,19010002,2}];
get_rank_reward(2,_Rank) when _Rank >= 4, _Rank =< 6 ->
		[{0,19010002,1},{0,19020002,5}];
get_rank_reward(2,_Rank) when _Rank >= 7, _Rank =< 20 ->
		[{0,19010002,1},{0,19020002,3}];
get_rank_reward(3,_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,38063015,1},{0,18010003,1},{0,18020003,2}];
get_rank_reward(3,_Rank) when _Rank >= 2, _Rank =< 2 ->
		[{0,18010003,1},{0,18020003,2}];
get_rank_reward(3,_Rank) when _Rank >= 3, _Rank =< 3 ->
		[{0,18010003,1},{0,18020003,1}];
get_rank_reward(3,_Rank) when _Rank >= 4, _Rank =< 6 ->
		[{0,18010002,1},{0,18020002,5}];
get_rank_reward(3,_Rank) when _Rank >= 7, _Rank =< 20 ->
		[{0,18010002,1},{0,18020002,1}];
get_rank_reward(_Rank_type,_Rank) ->
	[].

