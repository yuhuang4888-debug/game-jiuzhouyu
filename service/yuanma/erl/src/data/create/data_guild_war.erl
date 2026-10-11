%%%---------------------------------------
%%% module      : data_guild_war
%%% description : 公会争霸配置
%%%
%%%---------------------------------------
-module(data_guild_war).
-compile(export_all).
-include("guild_war.hrl").



get_cfg(_Key) ->
	0.

get_battle_victory_reward(_WorldLv,_Division,_Round) when _WorldLv >= 170, _WorldLv =< 219, _Division == 2, _Round == 2 ->
		[{4,0,9000},{100,37010002,12},{8,0,100},{17,0,10}];
get_battle_victory_reward(_WorldLv,_Division,_Round) ->
	[].

get_battle_failure_reward(_WorldLv,_Division,_Round) when _WorldLv >= 170, _WorldLv =< 219, _Division == 2, _Round == 2 ->
		[{4,0,7200},{100,37010002,9},{8,0,100},{17,0,10}];
get_battle_failure_reward(_WorldLv,_Division,_Round) ->
	[].

get_streak_reward_list() ->
[{1,199,2},{1,199,3},{1,199,4},{1,199,5},{1,199,6},{1,199,7},{1,199,8},{1,199,9},{1,199,10},{1,199,11},{1,199,12},{1,199,13},{1,199,14},{1,199,15},{1,199,16},{1,199,17},{1,199,18},{1,199,19},{1,199,20},{1,199,21},{1,199,22},{1,199,23},{1,199,24},{1,199,25},{1,199,26},{1,199,27},{1,199,28},{1,199,29},{1,199,30},{1,199,31},{1,199,32},{1,199,33},{1,199,34},{1,199,35},{1,199,36},{1,199,37},{1,199,38},{1,199,39},{1,199,40},{1,199,41},{1,199,42},{1,199,43},{1,199,44},{1,199,45},{1,199,46},{1,199,47},{1,199,48},{200,249,2},{200,249,3},{200,249,4},{200,249,5},{200,249,6},{200,249,7},{200,249,8},{200,249,9},{200,249,10},{200,249,11},{200,249,12},{200,249,13},{200,249,14},{200,249,15},{200,249,16},{200,249,17},{200,249,18},{200,249,19},{200,249,20},{200,249,21},{200,249,22},{200,249,23},{200,249,24},{200,249,25},{200,249,26},{200,249,27},{200,249,28},{200,249,29},{200,249,30},{200,249,31},{200,249,32},{200,249,33},{200,249,34},{200,249,35},{200,249,36},{200,249,37},{200,249,38},{200,249,39},{200,249,40},{200,249,41},{200,249,42},{200,249,43},{200,249,44},{200,249,45},{200,249,46},{200,249,47},{200,249,48},{250,299,2},{250,299,3},{250,299,4},{250,299,5},{250,299,6},{250,299,7},{250,299,8},{250,299,9},{250,299,10},{250,299,11},{250,299,12},{250,299,13},{250,299,14},{250,299,15},{250,299,16},{250,299,17},{250,299,18},{250,299,19},{250,299,20},{250,299,21},{250,299,22},{250,299,23},{250,299,24},{250,299,25},{250,299,26},{250,299,27},{250,299,28},{250,299,29},{250,299,30},{250,299,31},{250,299,32},{250,299,33},{250,299,34},{250,299,35},{250,299,36},{250,299,37},{250,299,38},{250,299,39},{250,299,40},{250,299,41},{250,299,42},{250,299,43},{250,299,44},{250,299,45},{250,299,46},{250,299,47},{250,299,48},{300,349,2},{300,349,3},{300,349,4},{300,349,5},{300,349,6},{300,349,7},{300,349,8},{300,349,9},{300,349,10},{300,349,11},{300,349,12},{300,349,13},{300,349,14},{300,349,15},{300,349,16},{300,349,17},{300,349,18},{300,349,19},{300,349,20},{300,349,21},{300,349,22},{300,349,23},{300,349,24},{300,349,25},{300,349,26},{300,349,27},{300,349,28},{300,349,29},{300,349,30},{300,349,31},{300,349,32},{300,349,33},{300,349,34},{300,349,35},{300,349,36},{300,349,37},{300,349,38},{300,349,39},{300,349,40},{300,349,41},{300,349,42},{300,349,43},{300,349,44},{300,349,45},{300,349,46},{300,349,47},{300,349,48},{350,399,2},{350,399,3},{350,399,4},{350,399,5},{350,399,6},{350,399,7},{350,399,8},{350,399,9},{350,399,10},{350,399,11},{350,399,12},{350,399,13},{350,399,14},{350,399,15},{350,399,16},{350,399,17},{350,399,18},{350,399,19},{350,399,20},{350,399,21},{350,399,22},{350,399,23},{350,399,24},{350,399,25},{350,399,26},{350,399,27},{350,399,28},{350,399,29},{350,399,30},{350,399,31},{350,399,32},{350,399,33},{350,399,34},{350,399,35},{350,399,36},{350,399,37},{350,399,38},{350,399,39},{350,399,40},{350,399,41},{350,399,42},{350,399,43},{350,399,44},{350,399,45},{350,399,46},{350,399,47},{350,399,48},{400,449,2},{400,449,3},{400,449,4},{400,449,5},{400,449,6},{400,449,7},{400,449,8},{400,449,9},{400,449,10},{400,449,11},{400,449,12},{400,449,13},{400,449,14},{400,449,15},{400,449,16},{400,449,17},{400,449,18},{400,449,19},{400,449,20},{400,449,21},{400,449,22},{400,449,23},{400,449,24},{400,449,25},{400,449,26},{400,449,27},{400,449,28},{400,449,29},{400,449,30},{400,449,31},{400,449,32},{400,449,33},{400,449,34},{400,449,35},{400,449,36},{400,449,37},{400,449,38},{400,449,39},{400,449,40},{400,449,41},{400,449,42},{400,449,43},{400,449,44},{400,449,45},{400,449,46},{400,449,47},{400,449,48},{450,499,2},{450,499,3},{450,499,4},{450,499,5},{450,499,6},{450,499,7},{450,499,8},{450,499,9},{450,499,10},{450,499,11},{450,499,12},{450,499,13},{450,499,14},{450,499,15},{450,499,16},{450,499,17},{450,499,18},{450,499,19},{450,499,20},{450,499,21},{450,499,22},{450,499,23},{450,499,24},{450,499,25},{450,499,26},{450,499,27},{450,499,28},{450,499,29},{450,499,30},{450,499,31},{450,499,32},{450,499,33},{450,499,34},{450,499,35},{450,499,36},{450,499,37},{450,499,38},{450,499,39},{450,499,40},{450,499,41},{450,499,42},{450,499,43},{450,499,44},{450,499,45},{450,499,46},{450,499,47},{450,499,48},{500,549,2},{500,549,3},{500,549,4},{500,549,5},{500,549,6},{500,549,7},{500,549,8},{500,549,9},{500,549,10},{500,549,11},{500,549,12},{500,549,13},{500,549,14},{500,549,15},{500,549,16},{500,549,17},{500,549,18},{500,549,19},{500,549,20},{500,549,21},{500,549,22},{500,549,23},{500,549,24},{500,549,25},{500,549,26},{500,549,27},{500,549,28},{500,549,29},{500,549,30},{500,549,31},{500,549,32},{500,549,33},{500,549,34},{500,549,35},{500,549,36},{500,549,37},{500,549,38},{500,549,39},{500,549,40},{500,549,41},{500,549,42},{500,549,43},{500,549,44},{500,549,45},{500,549,46},{500,549,47},{500,549,48},{550,599,2},{550,599,3},{550,599,4},{550,599,5},{550,599,6},{550,599,7},{550,599,8},{550,599,9},{550,599,10},{550,599,11},{550,599,12},{550,599,13},{550,599,14},{550,599,15},{550,599,16},{550,599,17},{550,599,18},{550,599,19},{550,599,20},{550,599,21},{550,599,22},{550,599,23},{550,599,24},{550,599,25},{550,599,26},{550,599,27},{550,599,28},{550,599,29},{550,599,30},{550,599,31},{550,599,32},{550,599,33},{550,599,34},{550,599,35},{550,599,36},{550,599,37},{550,599,38},{550,599,39},{550,599,40},{550,599,41},{550,599,42},{550,599,43},{550,599,44},{550,599,45},{550,599,46},{550,599,47},{550,599,48},{600,649,2},{600,649,3},{600,649,4},{600,649,5},{600,649,6},{600,649,7},{600,649,8},{600,649,9},{600,649,10},{600,649,11},{600,649,12},{600,649,13},{600,649,14},{600,649,15},{600,649,16},{600,649,17},{600,649,18},{600,649,19},{600,649,20},{600,649,21},{600,649,22},{600,649,23},{600,649,24},{600,649,25},{600,649,26},{600,649,27},{600,649,28},{600,649,29},{600,649,30},{600,649,31},{600,649,32},{600,649,33},{600,649,34},{600,649,35},{600,649,36},{600,649,37},{600,649,38},{600,649,39},{600,649,40},{600,649,41},{600,649,42},{600,649,43},{600,649,44},{600,649,45},{600,649,46},{600,649,47},{600,649,48},{650,699,2},{650,699,3},{650,699,4},{650,699,5},{650,699,6},{650,699,7},{650,699,8},{650,699,9},{650,699,10},{650,699,11},{650,699,12},{650,699,13},{650,699,14},{650,699,15},{650,699,16},{650,699,17},{650,699,18},{650,699,19},{650,699,20},{650,699,21},{650,699,22},{650,699,23},{650,699,24},{650,699,25},{650,699,26},{650,699,27},{650,699,28},{650,699,29},{650,699,30},{650,699,31},{650,699,32},{650,699,33},{650,699,34},{650,699,35},{650,699,36},{650,699,37},{650,699,38},{650,699,39},{650,699,40},{650,699,41},{650,699,42},{650,699,43},{650,699,44},{650,699,45},{650,699,46},{650,699,47},{650,699,48},{700,999,2},{700,999,3},{700,999,4},{700,999,5},{700,999,6},{700,999,7},{700,999,8},{700,999,9},{700,999,10},{700,999,11},{700,999,12},{700,999,13},{700,999,14},{700,999,15},{700,999,16},{700,999,17},{700,999,18},{700,999,19},{700,999,20},{700,999,21},{700,999,22},{700,999,23},{700,999,24},{700,999,25},{700,999,26},{700,999,27},{700,999,28},{700,999,29},{700,999,30},{700,999,31},{700,999,32},{700,999,33},{700,999,34},{700,999,35},{700,999,36},{700,999,37},{700,999,38},{700,999,39},{700,999,40},{700,999,41},{700,999,42},{700,999,43},{700,999,44},{700,999,45},{700,999,46},{700,999,47},{700,999,48}].

get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 2 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 3 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 4 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 5 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 6 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 7 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 8 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 9 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 10 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 11 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 12 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 13 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 14 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 15 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 16 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 17 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 18 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 19 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 20 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 21 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 22 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 23 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 24 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 25 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 26 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 27 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 28 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 29 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 30 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 31 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 32 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 33 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 34 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 35 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 36 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 37 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 38 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 39 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 40 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 41 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 42 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 43 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 44 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 45 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 46 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 47 ->
		[{0,16010001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 48 ->
		[{0,16010001,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 2 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 3 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 4 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 5 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 6 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 7 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 8 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 9 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 10 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 11 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 12 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 13 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 14 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 15 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 16 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 17 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 18 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 19 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 20 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 21 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 22 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 23 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 24 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 25 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 26 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 27 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 28 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 29 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 30 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 31 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 32 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 33 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 34 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 35 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 36 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 37 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 38 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 39 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 40 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 41 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 42 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 43 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 44 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 45 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 46 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 47 ->
		[{0,32010019,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 48 ->
		[{0,32010019,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 2 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 3 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 4 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 5 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 6 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 7 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 8 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 9 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 10 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 11 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 12 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 13 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 14 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 15 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 16 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 17 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 18 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 19 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 20 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 21 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 22 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 23 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 24 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 25 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 26 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 27 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 28 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 29 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 30 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 31 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 32 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 33 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 34 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 35 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 36 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 37 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 38 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 39 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 40 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 41 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 42 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 43 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 44 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 45 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 46 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 47 ->
		[{0,32010020,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 48 ->
		[{0,32010020,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 2 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 3 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 4 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 5 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 6 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 7 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 8 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 9 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 10 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 11 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 12 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 13 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 14 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 15 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 16 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 17 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 18 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 19 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 20 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 21 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 22 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 23 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 24 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 25 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 26 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 27 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 28 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 29 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 30 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 31 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 32 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 33 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 34 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 35 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 36 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 37 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 38 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 39 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 40 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 41 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 42 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 43 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 44 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 45 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 46 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 47 ->
		[{0,32010021,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 48 ->
		[{0,32010021,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 2 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 3 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 4 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 5 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 6 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 7 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 8 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 9 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 10 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 11 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 12 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 13 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 14 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 15 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 16 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 17 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 18 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 19 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 20 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 21 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 22 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 23 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 24 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 25 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 26 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 27 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 28 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 29 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 30 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 31 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 32 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 33 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 34 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 35 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 36 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 37 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 38 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 39 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 40 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 41 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 42 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 43 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 44 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 45 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 46 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 47 ->
		[{0,32010022,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 48 ->
		[{0,32010022,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 2 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 3 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 4 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 5 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 6 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 7 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 8 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 9 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 10 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 11 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 12 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 13 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 14 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 15 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 16 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 17 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 18 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 19 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 20 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 21 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 22 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 23 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 24 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 25 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 26 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 27 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 28 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 29 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 30 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 31 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 32 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 33 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 34 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 35 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 36 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 37 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 38 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 39 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 40 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 41 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 42 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 43 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 44 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 45 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 46 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 47 ->
		[{0,32010023,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 48 ->
		[{0,32010023,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 2 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 3 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 4 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 5 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 6 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 7 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 8 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 9 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 10 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 11 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 12 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 13 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 14 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 15 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 16 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 17 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 18 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 19 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 20 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 21 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 22 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 23 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 24 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 25 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 26 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 27 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 28 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 29 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 30 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 31 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 32 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 33 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 34 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 35 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 36 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 37 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 38 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 39 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 40 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 41 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 42 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 43 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 44 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 45 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 46 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 47 ->
		[{0,32010024,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 48 ->
		[{0,32010024,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 2 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 3 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 4 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 5 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 6 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 7 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 8 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 9 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 10 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 11 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 12 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 13 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 14 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 15 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 16 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 17 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 18 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 19 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 20 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 21 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 22 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 23 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 24 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 25 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 26 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 27 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 28 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 29 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 30 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 31 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 32 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 33 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 34 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 35 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 36 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 37 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 38 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 39 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 40 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 41 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 42 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 43 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 44 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 45 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 46 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 47 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 48 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 2 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 3 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 4 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 5 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 6 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 7 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 8 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 9 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 10 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 11 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 12 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 13 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 14 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 15 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 16 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 17 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 18 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 19 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 20 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 21 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 22 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 23 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 24 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 25 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 26 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 27 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 28 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 29 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 30 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 31 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 32 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 33 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 34 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 35 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 36 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 37 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 38 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 39 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 40 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 41 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 42 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 43 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 44 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 45 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 46 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 47 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 48 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 2 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 3 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 4 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 5 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 6 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 7 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 8 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 9 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 10 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 11 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 12 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 13 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 14 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 15 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 16 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 17 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 18 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 19 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 20 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 21 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 22 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 23 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 24 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 25 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 26 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 27 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 28 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 29 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 30 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 31 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 32 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 33 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 34 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 35 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 36 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 37 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 38 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 39 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 40 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 41 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 42 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 43 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 44 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 45 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 46 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 47 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 48 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 2 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 3 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 4 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 5 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 6 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 7 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 8 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 9 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 10 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 11 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 12 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 13 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 14 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 15 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 16 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 17 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 18 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 19 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 20 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 21 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 22 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 23 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 24 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 25 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 26 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 27 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 28 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 29 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 30 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 31 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 32 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 33 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 34 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 35 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 36 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 37 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 38 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 39 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 40 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 41 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 42 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 43 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 44 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 45 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 46 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 47 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 48 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 2 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 3 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 4 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 5 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 6 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 7 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 8 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 9 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 10 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 11 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 12 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 13 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 14 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 15 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 16 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 17 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 18 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 19 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 20 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 21 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 22 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 23 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 24 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 25 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 26 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 27 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 28 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 29 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 30 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 31 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 32 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 33 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 34 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 35 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 36 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 37 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 38 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 39 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 40 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 41 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 42 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 43 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 44 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 45 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 46 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 47 ->
		[{0,32010025,1}];
get_streak_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 48 ->
		[{0,32010025,1},{0,22030001,1}];
get_streak_reward(_WorldLv,_StreakTimes) ->
	[].

get_break_reward_list() ->
[{1,199,2},{1,199,3},{1,199,4},{1,199,5},{1,199,6},{1,199,7},{1,199,8},{1,199,9},{1,199,10},{1,199,11},{1,199,12},{1,199,13},{1,199,14},{1,199,15},{1,199,16},{1,199,17},{1,199,18},{1,199,19},{1,199,20},{1,199,21},{1,199,22},{1,199,23},{1,199,24},{1,199,25},{1,199,26},{1,199,27},{1,199,28},{1,199,29},{1,199,30},{1,199,31},{1,199,32},{1,199,33},{1,199,34},{1,199,35},{1,199,36},{1,199,37},{1,199,38},{1,199,39},{1,199,40},{1,199,41},{1,199,42},{1,199,43},{1,199,44},{1,199,45},{1,199,46},{1,199,47},{1,199,48},{200,249,2},{200,249,3},{200,249,4},{200,249,5},{200,249,6},{200,249,7},{200,249,8},{200,249,9},{200,249,10},{200,249,11},{200,249,12},{200,249,13},{200,249,14},{200,249,15},{200,249,16},{200,249,17},{200,249,18},{200,249,19},{200,249,20},{200,249,21},{200,249,22},{200,249,23},{200,249,24},{200,249,25},{200,249,26},{200,249,27},{200,249,28},{200,249,29},{200,249,30},{200,249,31},{200,249,32},{200,249,33},{200,249,34},{200,249,35},{200,249,36},{200,249,37},{200,249,38},{200,249,39},{200,249,40},{200,249,41},{200,249,42},{200,249,43},{200,249,44},{200,249,45},{200,249,46},{200,249,47},{200,249,48},{250,299,2},{250,299,3},{250,299,4},{250,299,5},{250,299,6},{250,299,7},{250,299,8},{250,299,9},{250,299,10},{250,299,11},{250,299,12},{250,299,13},{250,299,14},{250,299,15},{250,299,16},{250,299,17},{250,299,18},{250,299,19},{250,299,20},{250,299,21},{250,299,22},{250,299,23},{250,299,24},{250,299,25},{250,299,26},{250,299,27},{250,299,28},{250,299,29},{250,299,30},{250,299,31},{250,299,32},{250,299,33},{250,299,34},{250,299,35},{250,299,36},{250,299,37},{250,299,38},{250,299,39},{250,299,40},{250,299,41},{250,299,42},{250,299,43},{250,299,44},{250,299,45},{250,299,46},{250,299,47},{250,299,48},{300,349,2},{300,349,3},{300,349,4},{300,349,5},{300,349,6},{300,349,7},{300,349,8},{300,349,9},{300,349,10},{300,349,11},{300,349,12},{300,349,13},{300,349,14},{300,349,15},{300,349,16},{300,349,17},{300,349,18},{300,349,19},{300,349,20},{300,349,21},{300,349,22},{300,349,23},{300,349,24},{300,349,25},{300,349,26},{300,349,27},{300,349,28},{300,349,29},{300,349,30},{300,349,31},{300,349,32},{300,349,33},{300,349,34},{300,349,35},{300,349,36},{300,349,37},{300,349,38},{300,349,39},{300,349,40},{300,349,41},{300,349,42},{300,349,43},{300,349,44},{300,349,45},{300,349,46},{300,349,47},{300,349,48},{350,399,2},{350,399,3},{350,399,4},{350,399,5},{350,399,6},{350,399,7},{350,399,8},{350,399,9},{350,399,10},{350,399,11},{350,399,12},{350,399,13},{350,399,14},{350,399,15},{350,399,16},{350,399,17},{350,399,18},{350,399,19},{350,399,20},{350,399,21},{350,399,22},{350,399,23},{350,399,24},{350,399,25},{350,399,26},{350,399,27},{350,399,28},{350,399,29},{350,399,30},{350,399,31},{350,399,32},{350,399,33},{350,399,34},{350,399,35},{350,399,36},{350,399,37},{350,399,38},{350,399,39},{350,399,40},{350,399,41},{350,399,42},{350,399,43},{350,399,44},{350,399,45},{350,399,46},{350,399,47},{350,399,48},{400,449,2},{400,449,3},{400,449,4},{400,449,5},{400,449,6},{400,449,7},{400,449,8},{400,449,9},{400,449,10},{400,449,11},{400,449,12},{400,449,13},{400,449,14},{400,449,15},{400,449,16},{400,449,17},{400,449,18},{400,449,19},{400,449,20},{400,449,21},{400,449,22},{400,449,23},{400,449,24},{400,449,25},{400,449,26},{400,449,27},{400,449,28},{400,449,29},{400,449,30},{400,449,31},{400,449,32},{400,449,33},{400,449,34},{400,449,35},{400,449,36},{400,449,37},{400,449,38},{400,449,39},{400,449,40},{400,449,41},{400,449,42},{400,449,43},{400,449,44},{400,449,45},{400,449,46},{400,449,47},{400,449,48},{450,499,2},{450,499,3},{450,499,4},{450,499,5},{450,499,6},{450,499,7},{450,499,8},{450,499,9},{450,499,10},{450,499,11},{450,499,12},{450,499,13},{450,499,14},{450,499,15},{450,499,16},{450,499,17},{450,499,18},{450,499,19},{450,499,20},{450,499,21},{450,499,22},{450,499,23},{450,499,24},{450,499,25},{450,499,26},{450,499,27},{450,499,28},{450,499,29},{450,499,30},{450,499,31},{450,499,32},{450,499,33},{450,499,34},{450,499,35},{450,499,36},{450,499,37},{450,499,38},{450,499,39},{450,499,40},{450,499,41},{450,499,42},{450,499,43},{450,499,44},{450,499,45},{450,499,46},{450,499,47},{450,499,48},{500,549,2},{500,549,3},{500,549,4},{500,549,5},{500,549,6},{500,549,7},{500,549,8},{500,549,9},{500,549,10},{500,549,11},{500,549,12},{500,549,13},{500,549,14},{500,549,15},{500,549,16},{500,549,17},{500,549,18},{500,549,19},{500,549,20},{500,549,21},{500,549,22},{500,549,23},{500,549,24},{500,549,25},{500,549,26},{500,549,27},{500,549,28},{500,549,29},{500,549,30},{500,549,31},{500,549,32},{500,549,33},{500,549,34},{500,549,35},{500,549,36},{500,549,37},{500,549,38},{500,549,39},{500,549,40},{500,549,41},{500,549,42},{500,549,43},{500,549,44},{500,549,45},{500,549,46},{500,549,47},{500,549,48},{550,599,2},{550,599,3},{550,599,4},{550,599,5},{550,599,6},{550,599,7},{550,599,8},{550,599,9},{550,599,10},{550,599,11},{550,599,12},{550,599,13},{550,599,14},{550,599,15},{550,599,16},{550,599,17},{550,599,18},{550,599,19},{550,599,20},{550,599,21},{550,599,22},{550,599,23},{550,599,24},{550,599,25},{550,599,26},{550,599,27},{550,599,28},{550,599,29},{550,599,30},{550,599,31},{550,599,32},{550,599,33},{550,599,34},{550,599,35},{550,599,36},{550,599,37},{550,599,38},{550,599,39},{550,599,40},{550,599,41},{550,599,42},{550,599,43},{550,599,44},{550,599,45},{550,599,46},{550,599,47},{550,599,48},{600,649,2},{600,649,3},{600,649,4},{600,649,5},{600,649,6},{600,649,7},{600,649,8},{600,649,9},{600,649,10},{600,649,11},{600,649,12},{600,649,13},{600,649,14},{600,649,15},{600,649,16},{600,649,17},{600,649,18},{600,649,19},{600,649,20},{600,649,21},{600,649,22},{600,649,23},{600,649,24},{600,649,25},{600,649,26},{600,649,27},{600,649,28},{600,649,29},{600,649,30},{600,649,31},{600,649,32},{600,649,33},{600,649,34},{600,649,35},{600,649,36},{600,649,37},{600,649,38},{600,649,39},{600,649,40},{600,649,41},{600,649,42},{600,649,43},{600,649,44},{600,649,45},{600,649,46},{600,649,47},{600,649,48},{650,699,2},{650,699,3},{650,699,4},{650,699,5},{650,699,6},{650,699,7},{650,699,8},{650,699,9},{650,699,10},{650,699,11},{650,699,12},{650,699,13},{650,699,14},{650,699,15},{650,699,16},{650,699,17},{650,699,18},{650,699,19},{650,699,20},{650,699,21},{650,699,22},{650,699,23},{650,699,24},{650,699,25},{650,699,26},{650,699,27},{650,699,28},{650,699,29},{650,699,30},{650,699,31},{650,699,32},{650,699,33},{650,699,34},{650,699,35},{650,699,36},{650,699,37},{650,699,38},{650,699,39},{650,699,40},{650,699,41},{650,699,42},{650,699,43},{650,699,44},{650,699,45},{650,699,46},{650,699,47},{650,699,48},{700,999,2},{700,999,3},{700,999,4},{700,999,5},{700,999,6},{700,999,7},{700,999,8},{700,999,9},{700,999,10},{700,999,11},{700,999,12},{700,999,13},{700,999,14},{700,999,15},{700,999,16},{700,999,17},{700,999,18},{700,999,19},{700,999,20},{700,999,21},{700,999,22},{700,999,23},{700,999,24},{700,999,25},{700,999,26},{700,999,27},{700,999,28},{700,999,29},{700,999,30},{700,999,31},{700,999,32},{700,999,33},{700,999,34},{700,999,35},{700,999,36},{700,999,37},{700,999,38},{700,999,39},{700,999,40},{700,999,41},{700,999,42},{700,999,43},{700,999,44},{700,999,45},{700,999,46},{700,999,47},{700,999,48}].

get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 2 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 3 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 4 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 5 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 6 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 7 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 8 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 9 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 10 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 11 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 12 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 13 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 14 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 15 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 16 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 17 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 18 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 19 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 20 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 21 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 22 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 23 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 24 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 25 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 26 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 27 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 28 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 29 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 30 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 31 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 32 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 33 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 34 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 35 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 36 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 37 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 38 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 39 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 40 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 41 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 42 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 43 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 44 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 45 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 46 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 47 ->
		[{0,16010001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 1, _WorldLv =< 199, _StreakTimes == 48 ->
		[{0,16010001,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 2 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 3 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 4 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 5 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 6 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 7 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 8 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 9 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 10 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 11 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 12 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 13 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 14 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 15 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 16 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 17 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 18 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 19 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 20 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 21 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 22 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 23 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 24 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 25 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 26 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 27 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 28 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 29 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 30 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 31 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 32 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 33 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 34 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 35 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 36 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 37 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 38 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 39 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 40 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 41 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 42 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 43 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 44 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 45 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 46 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 47 ->
		[{0,32010019,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 200, _WorldLv =< 249, _StreakTimes == 48 ->
		[{0,32010019,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 2 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 3 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 4 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 5 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 6 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 7 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 8 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 9 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 10 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 11 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 12 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 13 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 14 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 15 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 16 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 17 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 18 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 19 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 20 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 21 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 22 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 23 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 24 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 25 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 26 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 27 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 28 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 29 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 30 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 31 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 32 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 33 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 34 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 35 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 36 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 37 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 38 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 39 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 40 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 41 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 42 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 43 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 44 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 45 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 46 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 47 ->
		[{0,32010020,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 250, _WorldLv =< 299, _StreakTimes == 48 ->
		[{0,32010020,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 2 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 3 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 4 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 5 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 6 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 7 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 8 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 9 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 10 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 11 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 12 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 13 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 14 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 15 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 16 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 17 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 18 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 19 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 20 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 21 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 22 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 23 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 24 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 25 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 26 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 27 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 28 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 29 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 30 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 31 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 32 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 33 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 34 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 35 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 36 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 37 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 38 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 39 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 40 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 41 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 42 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 43 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 44 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 45 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 46 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 47 ->
		[{0,32010021,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 300, _WorldLv =< 349, _StreakTimes == 48 ->
		[{0,32010021,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 2 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 3 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 4 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 5 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 6 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 7 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 8 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 9 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 10 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 11 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 12 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 13 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 14 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 15 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 16 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 17 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 18 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 19 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 20 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 21 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 22 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 23 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 24 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 25 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 26 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 27 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 28 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 29 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 30 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 31 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 32 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 33 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 34 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 35 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 36 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 37 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 38 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 39 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 40 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 41 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 42 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 43 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 44 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 45 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 46 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 47 ->
		[{0,32010022,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 350, _WorldLv =< 399, _StreakTimes == 48 ->
		[{0,32010022,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 2 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 3 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 4 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 5 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 6 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 7 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 8 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 9 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 10 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 11 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 12 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 13 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 14 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 15 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 16 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 17 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 18 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 19 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 20 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 21 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 22 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 23 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 24 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 25 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 26 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 27 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 28 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 29 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 30 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 31 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 32 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 33 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 34 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 35 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 36 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 37 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 38 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 39 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 40 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 41 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 42 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 43 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 44 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 45 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 46 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 47 ->
		[{0,32010023,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 400, _WorldLv =< 449, _StreakTimes == 48 ->
		[{0,32010023,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 2 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 3 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 4 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 5 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 6 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 7 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 8 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 9 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 10 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 11 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 12 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 13 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 14 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 15 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 16 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 17 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 18 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 19 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 20 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 21 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 22 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 23 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 24 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 25 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 26 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 27 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 28 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 29 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 30 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 31 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 32 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 33 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 34 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 35 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 36 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 37 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 38 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 39 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 40 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 41 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 42 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 43 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 44 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 45 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 46 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 47 ->
		[{0,32010024,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 450, _WorldLv =< 499, _StreakTimes == 48 ->
		[{0,32010024,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 2 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 3 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 4 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 5 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 6 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 7 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 8 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 9 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 10 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 11 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 12 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 13 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 14 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 15 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 16 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 17 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 18 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 19 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 20 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 21 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 22 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 23 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 24 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 25 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 26 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 27 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 28 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 29 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 30 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 31 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 32 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 33 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 34 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 35 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 36 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 37 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 38 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 39 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 40 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 41 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 42 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 43 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 44 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 45 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 46 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 47 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 500, _WorldLv =< 549, _StreakTimes == 48 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 2 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 3 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 4 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 5 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 6 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 7 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 8 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 9 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 10 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 11 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 12 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 13 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 14 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 15 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 16 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 17 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 18 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 19 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 20 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 21 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 22 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 23 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 24 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 25 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 26 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 27 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 28 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 29 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 30 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 31 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 32 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 33 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 34 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 35 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 36 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 37 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 38 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 39 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 40 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 41 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 42 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 43 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 44 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 45 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 46 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 47 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 550, _WorldLv =< 599, _StreakTimes == 48 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 2 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 3 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 4 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 5 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 6 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 7 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 8 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 9 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 10 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 11 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 12 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 13 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 14 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 15 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 16 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 17 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 18 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 19 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 20 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 21 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 22 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 23 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 24 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 25 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 26 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 27 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 28 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 29 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 30 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 31 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 32 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 33 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 34 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 35 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 36 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 37 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 38 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 39 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 40 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 41 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 42 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 43 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 44 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 45 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 46 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 47 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 600, _WorldLv =< 649, _StreakTimes == 48 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 2 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 3 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 4 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 5 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 6 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 7 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 8 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 9 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 10 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 11 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 12 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 13 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 14 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 15 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 16 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 17 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 18 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 19 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 20 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 21 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 22 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 23 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 24 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 25 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 26 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 27 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 28 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 29 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 30 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 31 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 32 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 33 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 34 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 35 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 36 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 37 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 38 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 39 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 40 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 41 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 42 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 43 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 44 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 45 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 46 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 47 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 650, _WorldLv =< 699, _StreakTimes == 48 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 2 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 3 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 4 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 5 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 6 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 7 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 8 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 9 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 10 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 11 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 12 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 13 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 14 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 15 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 16 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 17 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 18 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 19 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 20 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 21 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 22 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 23 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 24 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 25 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 26 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 27 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 28 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 29 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 30 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 31 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 32 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 33 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 34 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 35 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 36 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 37 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 38 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 39 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 40 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 41 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 42 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 43 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 44 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 45 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 46 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 47 ->
		[{0,32010025,1}];
get_break_reward(_WorldLv,_StreakTimes) when _WorldLv >= 700, _WorldLv =< 999, _StreakTimes == 48 ->
		[{0,32010025,1},{0,22030001,1}];
get_break_reward(_WorldLv,_StreakTimes) ->
	[].

