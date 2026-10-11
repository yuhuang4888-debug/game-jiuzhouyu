%%%---------------------------------------
%%% module      : data_adventure
%%% description : 天天冒险配置
%%%
%%%---------------------------------------
-module(data_adventure).
-compile(export_all).
-include("adventure.hrl").



get_adventure_info(1) ->
	#adventure_info_cfg{stage = 1,open_day = [10,9999],merge_day = [],start_time = 1645632000,end_time = 1686035545};

get_adventure_info(_Stage) ->
	[].

get_all_stage() ->
[1].

get_adventure_rand(_Point) when _Point >= 1, _Point =< 4 ->
	#adventure_rand_cfg{low_point=1,high_point=4,cost=[] ,weight=[{100,1},{200,2},{200,3},{1500,4},{4000,5},{4000,6}] };
get_adventure_rand(_Point) when _Point >= 5, _Point =< 9999 ->
	#adventure_rand_cfg{low_point=5,high_point=9999,cost=[{1,0,30}] ,weight=[{100,1},{200,2},{200,3},{1500,4},{4000,5},{4000,6}] };
get_adventure_rand(_Point) ->
	[].

get_adventure_loc(1,1,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,1,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,2,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,3,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,4,_Turn) when _Turn >= 1, _Turn =< 1 ->
		2;
get_adventure_loc(1,4,_Turn) when _Turn >= 2, _Turn =< 3 ->
		5;
get_adventure_loc(1,4,_Turn) when _Turn >= 4, _Turn =< 4 ->
		2;
get_adventure_loc(1,4,_Turn) when _Turn >= 5, _Turn =< 6 ->
		5;
get_adventure_loc(1,4,_Turn) when _Turn >= 7, _Turn =< 7 ->
		2;
get_adventure_loc(1,4,_Turn) when _Turn >= 8, _Turn =< 9 ->
		5;
get_adventure_loc(1,4,_Turn) when _Turn >= 10, _Turn =< 10 ->
		2;
get_adventure_loc(1,4,_Turn) when _Turn >= 11, _Turn =< 12 ->
		5;
get_adventure_loc(1,4,_Turn) when _Turn >= 13, _Turn =< 13 ->
		2;
get_adventure_loc(1,4,_Turn) when _Turn >= 14, _Turn =< 15 ->
		5;
get_adventure_loc(1,4,_Turn) when _Turn >= 16, _Turn =< 16 ->
		2;
get_adventure_loc(1,4,_Turn) when _Turn >= 17, _Turn =< 18 ->
		5;
get_adventure_loc(1,4,_Turn) when _Turn >= 19, _Turn =< 19 ->
		2;
get_adventure_loc(1,4,_Turn) when _Turn >= 20, _Turn =< 21 ->
		5;
get_adventure_loc(1,4,_Turn) when _Turn >= 22, _Turn =< 22 ->
		2;
get_adventure_loc(1,4,_Turn) when _Turn >= 23, _Turn =< 24 ->
		5;
get_adventure_loc(1,4,_Turn) when _Turn >= 25, _Turn =< 25 ->
		2;
get_adventure_loc(1,4,_Turn) when _Turn >= 26, _Turn =< 27 ->
		5;
get_adventure_loc(1,4,_Turn) when _Turn >= 28, _Turn =< 28 ->
		2;
get_adventure_loc(1,4,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		5;
get_adventure_loc(1,5,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,5,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,6,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,7,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,8,_Turn) when _Turn >= 1, _Turn =< 1 ->
		3;
get_adventure_loc(1,8,_Turn) when _Turn >= 2, _Turn =< 3 ->
		5;
get_adventure_loc(1,8,_Turn) when _Turn >= 4, _Turn =< 4 ->
		3;
get_adventure_loc(1,8,_Turn) when _Turn >= 5, _Turn =< 6 ->
		5;
get_adventure_loc(1,8,_Turn) when _Turn >= 7, _Turn =< 7 ->
		3;
get_adventure_loc(1,8,_Turn) when _Turn >= 8, _Turn =< 9 ->
		5;
get_adventure_loc(1,8,_Turn) when _Turn >= 10, _Turn =< 10 ->
		3;
get_adventure_loc(1,8,_Turn) when _Turn >= 11, _Turn =< 12 ->
		5;
get_adventure_loc(1,8,_Turn) when _Turn >= 13, _Turn =< 13 ->
		3;
get_adventure_loc(1,8,_Turn) when _Turn >= 14, _Turn =< 15 ->
		5;
get_adventure_loc(1,8,_Turn) when _Turn >= 16, _Turn =< 16 ->
		3;
get_adventure_loc(1,8,_Turn) when _Turn >= 17, _Turn =< 18 ->
		5;
get_adventure_loc(1,8,_Turn) when _Turn >= 19, _Turn =< 19 ->
		3;
get_adventure_loc(1,8,_Turn) when _Turn >= 20, _Turn =< 21 ->
		5;
get_adventure_loc(1,8,_Turn) when _Turn >= 22, _Turn =< 22 ->
		3;
get_adventure_loc(1,8,_Turn) when _Turn >= 23, _Turn =< 24 ->
		5;
get_adventure_loc(1,8,_Turn) when _Turn >= 25, _Turn =< 25 ->
		3;
get_adventure_loc(1,8,_Turn) when _Turn >= 26, _Turn =< 27 ->
		5;
get_adventure_loc(1,8,_Turn) when _Turn >= 28, _Turn =< 28 ->
		3;
get_adventure_loc(1,8,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		5;
get_adventure_loc(1,9,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,9,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,10,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,11,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,12,_Turn) when _Turn >= 1, _Turn =< 1 ->
		4;
get_adventure_loc(1,12,_Turn) when _Turn >= 2, _Turn =< 3 ->
		5;
get_adventure_loc(1,12,_Turn) when _Turn >= 4, _Turn =< 4 ->
		4;
get_adventure_loc(1,12,_Turn) when _Turn >= 5, _Turn =< 6 ->
		5;
get_adventure_loc(1,12,_Turn) when _Turn >= 7, _Turn =< 7 ->
		4;
get_adventure_loc(1,12,_Turn) when _Turn >= 8, _Turn =< 9 ->
		5;
get_adventure_loc(1,12,_Turn) when _Turn >= 10, _Turn =< 10 ->
		4;
get_adventure_loc(1,12,_Turn) when _Turn >= 11, _Turn =< 12 ->
		5;
get_adventure_loc(1,12,_Turn) when _Turn >= 13, _Turn =< 13 ->
		4;
get_adventure_loc(1,12,_Turn) when _Turn >= 14, _Turn =< 15 ->
		5;
get_adventure_loc(1,12,_Turn) when _Turn >= 16, _Turn =< 16 ->
		4;
get_adventure_loc(1,12,_Turn) when _Turn >= 17, _Turn =< 18 ->
		5;
get_adventure_loc(1,12,_Turn) when _Turn >= 19, _Turn =< 19 ->
		4;
get_adventure_loc(1,12,_Turn) when _Turn >= 20, _Turn =< 21 ->
		5;
get_adventure_loc(1,12,_Turn) when _Turn >= 22, _Turn =< 22 ->
		4;
get_adventure_loc(1,12,_Turn) when _Turn >= 23, _Turn =< 24 ->
		5;
get_adventure_loc(1,12,_Turn) when _Turn >= 25, _Turn =< 25 ->
		4;
get_adventure_loc(1,12,_Turn) when _Turn >= 26, _Turn =< 27 ->
		5;
get_adventure_loc(1,12,_Turn) when _Turn >= 28, _Turn =< 28 ->
		4;
get_adventure_loc(1,12,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		5;
get_adventure_loc(1,13,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,13,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,14,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,15,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,16,_Turn) when _Turn >= 1, _Turn =< 1 ->
		4;
get_adventure_loc(1,16,_Turn) when _Turn >= 2, _Turn =< 3 ->
		5;
get_adventure_loc(1,16,_Turn) when _Turn >= 4, _Turn =< 4 ->
		4;
get_adventure_loc(1,16,_Turn) when _Turn >= 5, _Turn =< 6 ->
		5;
get_adventure_loc(1,16,_Turn) when _Turn >= 7, _Turn =< 7 ->
		4;
get_adventure_loc(1,16,_Turn) when _Turn >= 8, _Turn =< 9 ->
		5;
get_adventure_loc(1,16,_Turn) when _Turn >= 10, _Turn =< 10 ->
		4;
get_adventure_loc(1,16,_Turn) when _Turn >= 11, _Turn =< 12 ->
		5;
get_adventure_loc(1,16,_Turn) when _Turn >= 13, _Turn =< 13 ->
		4;
get_adventure_loc(1,16,_Turn) when _Turn >= 14, _Turn =< 15 ->
		5;
get_adventure_loc(1,16,_Turn) when _Turn >= 16, _Turn =< 16 ->
		4;
get_adventure_loc(1,16,_Turn) when _Turn >= 17, _Turn =< 18 ->
		5;
get_adventure_loc(1,16,_Turn) when _Turn >= 19, _Turn =< 19 ->
		4;
get_adventure_loc(1,16,_Turn) when _Turn >= 20, _Turn =< 21 ->
		5;
get_adventure_loc(1,16,_Turn) when _Turn >= 22, _Turn =< 22 ->
		4;
get_adventure_loc(1,16,_Turn) when _Turn >= 23, _Turn =< 24 ->
		5;
get_adventure_loc(1,16,_Turn) when _Turn >= 25, _Turn =< 25 ->
		4;
get_adventure_loc(1,16,_Turn) when _Turn >= 26, _Turn =< 27 ->
		5;
get_adventure_loc(1,16,_Turn) when _Turn >= 28, _Turn =< 28 ->
		4;
get_adventure_loc(1,16,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		5;
get_adventure_loc(1,17,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,17,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,18,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,19,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,20,_Turn) when _Turn >= 1, _Turn =< 1 ->
		2;
get_adventure_loc(1,20,_Turn) when _Turn >= 2, _Turn =< 3 ->
		5;
get_adventure_loc(1,20,_Turn) when _Turn >= 4, _Turn =< 4 ->
		2;
get_adventure_loc(1,20,_Turn) when _Turn >= 5, _Turn =< 6 ->
		5;
get_adventure_loc(1,20,_Turn) when _Turn >= 7, _Turn =< 7 ->
		2;
get_adventure_loc(1,20,_Turn) when _Turn >= 8, _Turn =< 9 ->
		5;
get_adventure_loc(1,20,_Turn) when _Turn >= 10, _Turn =< 10 ->
		2;
get_adventure_loc(1,20,_Turn) when _Turn >= 11, _Turn =< 12 ->
		5;
get_adventure_loc(1,20,_Turn) when _Turn >= 13, _Turn =< 13 ->
		2;
get_adventure_loc(1,20,_Turn) when _Turn >= 14, _Turn =< 15 ->
		5;
get_adventure_loc(1,20,_Turn) when _Turn >= 16, _Turn =< 16 ->
		2;
get_adventure_loc(1,20,_Turn) when _Turn >= 17, _Turn =< 18 ->
		5;
get_adventure_loc(1,20,_Turn) when _Turn >= 19, _Turn =< 19 ->
		2;
get_adventure_loc(1,20,_Turn) when _Turn >= 20, _Turn =< 21 ->
		5;
get_adventure_loc(1,20,_Turn) when _Turn >= 22, _Turn =< 22 ->
		2;
get_adventure_loc(1,20,_Turn) when _Turn >= 23, _Turn =< 24 ->
		5;
get_adventure_loc(1,20,_Turn) when _Turn >= 25, _Turn =< 25 ->
		2;
get_adventure_loc(1,20,_Turn) when _Turn >= 26, _Turn =< 27 ->
		5;
get_adventure_loc(1,20,_Turn) when _Turn >= 28, _Turn =< 28 ->
		2;
get_adventure_loc(1,20,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		5;
get_adventure_loc(1,21,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,21,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,22,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,23,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,24,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,25,_Turn) when _Turn >= 1, _Turn =< 1 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 2, _Turn =< 3 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 4, _Turn =< 4 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 5, _Turn =< 6 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 7, _Turn =< 7 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 8, _Turn =< 9 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 10, _Turn =< 10 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 11, _Turn =< 12 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 13, _Turn =< 13 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 14, _Turn =< 15 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 16, _Turn =< 16 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 17, _Turn =< 18 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 19, _Turn =< 19 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 20, _Turn =< 21 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 22, _Turn =< 22 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 23, _Turn =< 24 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 25, _Turn =< 25 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 26, _Turn =< 27 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 28, _Turn =< 28 ->
		5;
get_adventure_loc(1,25,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		5;
get_adventure_loc(1,26,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,26,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,27,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,28,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 1, _Turn =< 1 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 2, _Turn =< 3 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 4, _Turn =< 4 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 5, _Turn =< 6 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 7, _Turn =< 7 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 8, _Turn =< 9 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 10, _Turn =< 10 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 11, _Turn =< 12 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 13, _Turn =< 13 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 14, _Turn =< 15 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 16, _Turn =< 16 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 17, _Turn =< 18 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 19, _Turn =< 19 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 20, _Turn =< 21 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 22, _Turn =< 22 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 23, _Turn =< 24 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 25, _Turn =< 25 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 26, _Turn =< 27 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 28, _Turn =< 28 ->
		1;
get_adventure_loc(1,29,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		1;
get_adventure_loc(1,30,_Turn) when _Turn >= 1, _Turn =< 1 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 2, _Turn =< 3 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 4, _Turn =< 4 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 5, _Turn =< 6 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 7, _Turn =< 7 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 8, _Turn =< 9 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 10, _Turn =< 10 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 11, _Turn =< 12 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 13, _Turn =< 13 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 14, _Turn =< 15 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 16, _Turn =< 16 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 17, _Turn =< 18 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 19, _Turn =< 19 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 20, _Turn =< 21 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 22, _Turn =< 22 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 23, _Turn =< 24 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 25, _Turn =< 25 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 26, _Turn =< 27 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 28, _Turn =< 28 ->
		6;
get_adventure_loc(1,30,_Turn) when _Turn >= 29, _Turn =< 9999 ->
		6;
get_adventure_loc(_Stage,_Location,_Turn) ->
	[].

get_adventure_reward(1,1) ->
[{1000,[{0,38040005,3}]},{100,[{0,32010129,1}]},{500,[{0,32010001,1}]}];

get_adventure_reward(1,2) ->
[{2000,[{0,36255038,1}]}];

get_adventure_reward(1,3) ->
[{2000,[{0,36255038,1}]},{640,[{0,38300101,1}]},{960,[{0,38300104,1}]},{640,[{0,38300103,1}]},{640,[{0,38300105,1}]},{1280,[{0,38300102,1}]},{1280,[{0,38300110,1}]},{1280,[{0,38300108,1}]},{1280,[{0,38300106,1}]}];

get_adventure_reward(1,4) ->
[{3000,[{0,36255038,1}]},{560,[{0,38300101,1}]},{840,[{0,38300104,1}]},{560,[{0,38300103,1}]},{560,[{0,38300105,1}]},{1120,[{0,38300102,1}]},{1120,[{0,38300110,1}]},{1120,[{0,38300108,1}]},{1120,[{0,38300106,1}]}];

get_adventure_reward(1,5) ->
[{1000,[{0,36255038,1}]},{720,[{0,38300101,1}]},{1080,[{0,38300104,1}]},{720,[{0,38300103,1}]},{720,[{0,38300105,1}]},{1440,[{0,38300102,1}]},{1440,[{0,38300110,1}]},{1440,[{0,38300108,1}]},{1440,[{0,38300106,1}]}];

get_adventure_reward(1,6) ->
[{1000,[{0,34010041,1},{0,32010244,5}]}];

get_adventure_reward(_Stage,_Type) ->
	[].


get_adventure_kv(1) ->
36255038;


get_adventure_kv(2) ->
15;


get_adventure_kv(3) ->
[{1,[{1,0,20}]},{2,[{1,0,30}]},{3,[{1,0,50}]},{4,[{1,0,80}]},{5,[{1,0,120}]}];


get_adventure_kv(4) ->
[34010041,32010244,32010129,36255038,38300101,38300104,38300103,38300105,38300102,38300110,38300108,38300106];


get_adventure_kv(5) ->
[1];


get_adventure_kv(6) ->
[2,3,4,5];


get_adventure_kv(7) ->
[{5,[{5901004,5902004}]}];


get_adventure_kv(8) ->
[{1,[{8000,1},{2000,2}]},{2,[{8000,1},{2000,2}]},{3,[{8000,1},{2000,2}]},{4,[{8000,1},{2000,2}]},{5,[{8000,1},{2000,2}]},{6,[{8000,1},{2000,2}]},{7,[{8000,1},{2000,2}]}];


get_adventure_kv(9) ->
[6];


get_adventure_kv(10) ->
[];


get_adventure_kv(11) ->
371;


get_adventure_kv(12) ->
[{42701,[1,2,3,4,5,6,7]}];


get_adventure_kv(13) ->
[{0,1},{1,5}];


get_adventure_kv(14) ->
[{1,6}];

get_adventure_kv(_Key) ->
	[].

get_adventure_shop(1) ->
	#adventure_shop_cfg{id = 1,type = 0,reward = [{0,38300101,2}],show_price = 200,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(2) ->
	#adventure_shop_cfg{id = 2,type = 0,reward = [{0,38300104,2}],show_price = 200,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(3) ->
	#adventure_shop_cfg{id = 3,type = 0,reward = [{0,38300103,2}],show_price = 200,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(4) ->
	#adventure_shop_cfg{id = 4,type = 0,reward = [{0,38300105,2}],show_price = 200,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(5) ->
	#adventure_shop_cfg{id = 5,type = 0,reward = [{0,38300102,2}],show_price = 200,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(6) ->
	#adventure_shop_cfg{id = 6,type = 0,reward = [{0,38300110,2}],show_price = 200,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(7) ->
	#adventure_shop_cfg{id = 7,type = 0,reward = [{0,38300108,2}],show_price = 200,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(8) ->
	#adventure_shop_cfg{id = 8,type = 0,reward = [{0,38300106,2}],show_price = 200,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(9) ->
	#adventure_shop_cfg{id = 9,type = 0,reward = [{0,38300101,3}],show_price = 300,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(10) ->
	#adventure_shop_cfg{id = 10,type = 0,reward = [{0,38300104,3}],show_price = 300,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(11) ->
	#adventure_shop_cfg{id = 11,type = 0,reward = [{0,38300103,3}],show_price = 300,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(12) ->
	#adventure_shop_cfg{id = 12,type = 0,reward = [{0,38300105,3}],show_price = 300,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(13) ->
	#adventure_shop_cfg{id = 13,type = 0,reward = [{0,38300102,3}],show_price = 300,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(14) ->
	#adventure_shop_cfg{id = 14,type = 0,reward = [{0,38300110,3}],show_price = 300,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(15) ->
	#adventure_shop_cfg{id = 15,type = 0,reward = [{0,38300108,3}],show_price = 300,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(16) ->
	#adventure_shop_cfg{id = 16,type = 0,reward = [{0,38300106,3}],show_price = 300,price = 0,weight = 2000,over_cheap = 0};

get_adventure_shop(17) ->
	#adventure_shop_cfg{id = 17,type = 1,reward = [{0,38300101,2}],show_price = 200,price = 160,weight = 2000,over_cheap = 0};

get_adventure_shop(18) ->
	#adventure_shop_cfg{id = 18,type = 1,reward = [{0,38300104,2}],show_price = 200,price = 160,weight = 2000,over_cheap = 0};

get_adventure_shop(19) ->
	#adventure_shop_cfg{id = 19,type = 1,reward = [{0,38300103,2}],show_price = 200,price = 160,weight = 2000,over_cheap = 0};

get_adventure_shop(20) ->
	#adventure_shop_cfg{id = 20,type = 1,reward = [{0,38300105,2}],show_price = 200,price = 160,weight = 2000,over_cheap = 0};

get_adventure_shop(21) ->
	#adventure_shop_cfg{id = 21,type = 1,reward = [{0,38300102,2}],show_price = 200,price = 160,weight = 2000,over_cheap = 0};

get_adventure_shop(22) ->
	#adventure_shop_cfg{id = 22,type = 1,reward = [{0,38300110,2}],show_price = 200,price = 160,weight = 2000,over_cheap = 0};

get_adventure_shop(23) ->
	#adventure_shop_cfg{id = 23,type = 1,reward = [{0,38300108,2}],show_price = 200,price = 160,weight = 2000,over_cheap = 0};

get_adventure_shop(24) ->
	#adventure_shop_cfg{id = 24,type = 1,reward = [{0,38300106,2}],show_price = 200,price = 160,weight = 2000,over_cheap = 0};

get_adventure_shop(25) ->
	#adventure_shop_cfg{id = 25,type = 1,reward = [{0,34010041,2}],show_price = 240,price = 192,weight = 2000,over_cheap = 0};

get_adventure_shop(26) ->
	#adventure_shop_cfg{id = 26,type = 1,reward = [{0,38300101,2}],show_price = 200,price = 140,weight = 2000,over_cheap = 0};

get_adventure_shop(27) ->
	#adventure_shop_cfg{id = 27,type = 1,reward = [{0,38300104,2}],show_price = 200,price = 140,weight = 2000,over_cheap = 0};

get_adventure_shop(28) ->
	#adventure_shop_cfg{id = 28,type = 1,reward = [{0,38300103,2}],show_price = 200,price = 140,weight = 2000,over_cheap = 0};

get_adventure_shop(29) ->
	#adventure_shop_cfg{id = 29,type = 1,reward = [{0,38300105,2}],show_price = 200,price = 140,weight = 2000,over_cheap = 0};

get_adventure_shop(30) ->
	#adventure_shop_cfg{id = 30,type = 1,reward = [{0,38300102,2}],show_price = 200,price = 140,weight = 2000,over_cheap = 0};

get_adventure_shop(31) ->
	#adventure_shop_cfg{id = 31,type = 1,reward = [{0,38300110,2}],show_price = 200,price = 140,weight = 2000,over_cheap = 0};

get_adventure_shop(32) ->
	#adventure_shop_cfg{id = 32,type = 1,reward = [{0,38300108,2}],show_price = 200,price = 140,weight = 2000,over_cheap = 0};

get_adventure_shop(33) ->
	#adventure_shop_cfg{id = 33,type = 1,reward = [{0,38300106,2}],show_price = 200,price = 140,weight = 2000,over_cheap = 0};

get_adventure_shop(34) ->
	#adventure_shop_cfg{id = 34,type = 1,reward = [{0,34010041,2}],show_price = 240,price = 168,weight = 2000,over_cheap = 0};

get_adventure_shop(35) ->
	#adventure_shop_cfg{id = 35,type = 1,reward = [{0,38300101,2}],show_price = 200,price = 120,weight = 2000,over_cheap = 0};

get_adventure_shop(36) ->
	#adventure_shop_cfg{id = 36,type = 1,reward = [{0,38300104,2}],show_price = 200,price = 120,weight = 2000,over_cheap = 0};

get_adventure_shop(37) ->
	#adventure_shop_cfg{id = 37,type = 1,reward = [{0,38300103,2}],show_price = 200,price = 120,weight = 2000,over_cheap = 0};

get_adventure_shop(38) ->
	#adventure_shop_cfg{id = 38,type = 1,reward = [{0,38300105,2}],show_price = 200,price = 120,weight = 2000,over_cheap = 0};

get_adventure_shop(39) ->
	#adventure_shop_cfg{id = 39,type = 1,reward = [{0,38300102,2}],show_price = 200,price = 120,weight = 2000,over_cheap = 0};

get_adventure_shop(40) ->
	#adventure_shop_cfg{id = 40,type = 1,reward = [{0,38300110,2}],show_price = 200,price = 120,weight = 2000,over_cheap = 0};

get_adventure_shop(41) ->
	#adventure_shop_cfg{id = 41,type = 1,reward = [{0,38300108,2}],show_price = 200,price = 120,weight = 2000,over_cheap = 0};

get_adventure_shop(42) ->
	#adventure_shop_cfg{id = 42,type = 1,reward = [{0,38300106,2}],show_price = 200,price = 120,weight = 2000,over_cheap = 0};

get_adventure_shop(43) ->
	#adventure_shop_cfg{id = 43,type = 1,reward = [{0,34010041,2}],show_price = 240,price = 144,weight = 2000,over_cheap = 0};

get_adventure_shop(44) ->
	#adventure_shop_cfg{id = 44,type = 1,reward = [{0,38300101,2}],show_price = 200,price = 60,weight = 100,over_cheap = 1};

get_adventure_shop(45) ->
	#adventure_shop_cfg{id = 45,type = 1,reward = [{0,38300104,2}],show_price = 200,price = 60,weight = 100,over_cheap = 1};

get_adventure_shop(46) ->
	#adventure_shop_cfg{id = 46,type = 1,reward = [{0,38300103,2}],show_price = 200,price = 60,weight = 100,over_cheap = 1};

get_adventure_shop(47) ->
	#adventure_shop_cfg{id = 47,type = 1,reward = [{0,38300105,2}],show_price = 200,price = 60,weight = 100,over_cheap = 1};

get_adventure_shop(48) ->
	#adventure_shop_cfg{id = 48,type = 1,reward = [{0,38300102,2}],show_price = 200,price = 60,weight = 100,over_cheap = 1};

get_adventure_shop(49) ->
	#adventure_shop_cfg{id = 49,type = 1,reward = [{0,38300110,2}],show_price = 200,price = 60,weight = 100,over_cheap = 1};

get_adventure_shop(50) ->
	#adventure_shop_cfg{id = 50,type = 1,reward = [{0,38300108,2}],show_price = 200,price = 60,weight = 100,over_cheap = 1};

get_adventure_shop(51) ->
	#adventure_shop_cfg{id = 51,type = 1,reward = [{0,38300106,2}],show_price = 200,price = 60,weight = 100,over_cheap = 1};

get_adventure_shop(52) ->
	#adventure_shop_cfg{id = 52,type = 1,reward = [{0,38300101,3}],show_price = 300,price = 240,weight = 2000,over_cheap = 0};

get_adventure_shop(53) ->
	#adventure_shop_cfg{id = 53,type = 1,reward = [{0,38300104,3}],show_price = 300,price = 240,weight = 2000,over_cheap = 0};

get_adventure_shop(54) ->
	#adventure_shop_cfg{id = 54,type = 1,reward = [{0,38300103,3}],show_price = 300,price = 240,weight = 2000,over_cheap = 0};

get_adventure_shop(55) ->
	#adventure_shop_cfg{id = 55,type = 1,reward = [{0,38300105,3}],show_price = 300,price = 240,weight = 2000,over_cheap = 0};

get_adventure_shop(56) ->
	#adventure_shop_cfg{id = 56,type = 1,reward = [{0,38300102,3}],show_price = 300,price = 240,weight = 2000,over_cheap = 0};

get_adventure_shop(57) ->
	#adventure_shop_cfg{id = 57,type = 1,reward = [{0,38300110,3}],show_price = 300,price = 240,weight = 2000,over_cheap = 0};

get_adventure_shop(58) ->
	#adventure_shop_cfg{id = 58,type = 1,reward = [{0,38300108,3}],show_price = 300,price = 240,weight = 2000,over_cheap = 0};

get_adventure_shop(59) ->
	#adventure_shop_cfg{id = 59,type = 1,reward = [{0,38300106,3}],show_price = 300,price = 240,weight = 2000,over_cheap = 0};

get_adventure_shop(60) ->
	#adventure_shop_cfg{id = 60,type = 1,reward = [{0,34010041,3}],show_price = 360,price = 288,weight = 2000,over_cheap = 0};

get_adventure_shop(61) ->
	#adventure_shop_cfg{id = 61,type = 1,reward = [{0,38300101,3}],show_price = 300,price = 210,weight = 2000,over_cheap = 0};

get_adventure_shop(62) ->
	#adventure_shop_cfg{id = 62,type = 1,reward = [{0,38300104,3}],show_price = 300,price = 210,weight = 2000,over_cheap = 0};

get_adventure_shop(63) ->
	#adventure_shop_cfg{id = 63,type = 1,reward = [{0,38300103,3}],show_price = 300,price = 210,weight = 2000,over_cheap = 0};

get_adventure_shop(64) ->
	#adventure_shop_cfg{id = 64,type = 1,reward = [{0,38300105,3}],show_price = 300,price = 210,weight = 2000,over_cheap = 0};

get_adventure_shop(65) ->
	#adventure_shop_cfg{id = 65,type = 1,reward = [{0,38300102,3}],show_price = 300,price = 210,weight = 2000,over_cheap = 0};

get_adventure_shop(66) ->
	#adventure_shop_cfg{id = 66,type = 1,reward = [{0,38300110,3}],show_price = 300,price = 210,weight = 2000,over_cheap = 0};

get_adventure_shop(67) ->
	#adventure_shop_cfg{id = 67,type = 1,reward = [{0,38300108,3}],show_price = 300,price = 210,weight = 2000,over_cheap = 0};

get_adventure_shop(68) ->
	#adventure_shop_cfg{id = 68,type = 1,reward = [{0,38300106,3}],show_price = 300,price = 210,weight = 2000,over_cheap = 0};

get_adventure_shop(69) ->
	#adventure_shop_cfg{id = 69,type = 1,reward = [{0,34010041,3}],show_price = 360,price = 252,weight = 2000,over_cheap = 0};

get_adventure_shop(70) ->
	#adventure_shop_cfg{id = 70,type = 1,reward = [{0,38300101,3}],show_price = 300,price = 180,weight = 2000,over_cheap = 0};

get_adventure_shop(71) ->
	#adventure_shop_cfg{id = 71,type = 1,reward = [{0,38300104,3}],show_price = 300,price = 180,weight = 2000,over_cheap = 0};

get_adventure_shop(72) ->
	#adventure_shop_cfg{id = 72,type = 1,reward = [{0,38300103,3}],show_price = 300,price = 180,weight = 2000,over_cheap = 0};

get_adventure_shop(73) ->
	#adventure_shop_cfg{id = 73,type = 1,reward = [{0,38300105,3}],show_price = 300,price = 180,weight = 2000,over_cheap = 0};

get_adventure_shop(74) ->
	#adventure_shop_cfg{id = 74,type = 1,reward = [{0,38300102,3}],show_price = 300,price = 180,weight = 2000,over_cheap = 0};

get_adventure_shop(75) ->
	#adventure_shop_cfg{id = 75,type = 1,reward = [{0,38300110,3}],show_price = 300,price = 180,weight = 2000,over_cheap = 0};

get_adventure_shop(76) ->
	#adventure_shop_cfg{id = 76,type = 1,reward = [{0,38300108,3}],show_price = 300,price = 180,weight = 2000,over_cheap = 0};

get_adventure_shop(77) ->
	#adventure_shop_cfg{id = 77,type = 1,reward = [{0,38300106,3}],show_price = 300,price = 180,weight = 2000,over_cheap = 0};

get_adventure_shop(78) ->
	#adventure_shop_cfg{id = 78,type = 1,reward = [{0,34010041,3}],show_price = 360,price = 216,weight = 2000,over_cheap = 0};

get_adventure_shop(79) ->
	#adventure_shop_cfg{id = 79,type = 1,reward = [{0,38300101,3}],show_price = 300,price = 90,weight = 100,over_cheap = 1};

get_adventure_shop(80) ->
	#adventure_shop_cfg{id = 80,type = 1,reward = [{0,38300104,3}],show_price = 300,price = 90,weight = 100,over_cheap = 1};

get_adventure_shop(81) ->
	#adventure_shop_cfg{id = 81,type = 1,reward = [{0,38300103,3}],show_price = 300,price = 90,weight = 100,over_cheap = 1};

get_adventure_shop(82) ->
	#adventure_shop_cfg{id = 82,type = 1,reward = [{0,38300105,3}],show_price = 300,price = 90,weight = 100,over_cheap = 1};

get_adventure_shop(83) ->
	#adventure_shop_cfg{id = 83,type = 1,reward = [{0,38300102,3}],show_price = 300,price = 90,weight = 100,over_cheap = 1};

get_adventure_shop(84) ->
	#adventure_shop_cfg{id = 84,type = 1,reward = [{0,38300110,3}],show_price = 300,price = 90,weight = 100,over_cheap = 1};

get_adventure_shop(85) ->
	#adventure_shop_cfg{id = 85,type = 1,reward = [{0,38300108,3}],show_price = 300,price = 90,weight = 100,over_cheap = 1};

get_adventure_shop(86) ->
	#adventure_shop_cfg{id = 86,type = 1,reward = [{0,38300106,3}],show_price = 300,price = 90,weight = 100,over_cheap = 1};

get_adventure_shop(87) ->
	#adventure_shop_cfg{id = 87,type = 1,reward = [{0,38300101,5}],show_price = 500,price = 400,weight = 2000,over_cheap = 0};

get_adventure_shop(88) ->
	#adventure_shop_cfg{id = 88,type = 1,reward = [{0,38300104,5}],show_price = 500,price = 400,weight = 2000,over_cheap = 0};

get_adventure_shop(89) ->
	#adventure_shop_cfg{id = 89,type = 1,reward = [{0,38300103,5}],show_price = 500,price = 400,weight = 2000,over_cheap = 0};

get_adventure_shop(90) ->
	#adventure_shop_cfg{id = 90,type = 1,reward = [{0,38300105,5}],show_price = 500,price = 400,weight = 2000,over_cheap = 0};

get_adventure_shop(91) ->
	#adventure_shop_cfg{id = 91,type = 1,reward = [{0,38300102,5}],show_price = 500,price = 400,weight = 2000,over_cheap = 0};

get_adventure_shop(92) ->
	#adventure_shop_cfg{id = 92,type = 1,reward = [{0,38300110,5}],show_price = 500,price = 400,weight = 2000,over_cheap = 0};

get_adventure_shop(93) ->
	#adventure_shop_cfg{id = 93,type = 1,reward = [{0,38300108,5}],show_price = 500,price = 400,weight = 2000,over_cheap = 0};

get_adventure_shop(94) ->
	#adventure_shop_cfg{id = 94,type = 1,reward = [{0,38300106,5}],show_price = 500,price = 400,weight = 2000,over_cheap = 0};

get_adventure_shop(95) ->
	#adventure_shop_cfg{id = 95,type = 1,reward = [{0,34010041,5}],show_price = 600,price = 480,weight = 2000,over_cheap = 0};

get_adventure_shop(96) ->
	#adventure_shop_cfg{id = 96,type = 1,reward = [{0,38300101,5}],show_price = 500,price = 350,weight = 2000,over_cheap = 0};

get_adventure_shop(97) ->
	#adventure_shop_cfg{id = 97,type = 1,reward = [{0,38300104,5}],show_price = 500,price = 350,weight = 2000,over_cheap = 0};

get_adventure_shop(98) ->
	#adventure_shop_cfg{id = 98,type = 1,reward = [{0,38300103,5}],show_price = 500,price = 350,weight = 2000,over_cheap = 0};

get_adventure_shop(99) ->
	#adventure_shop_cfg{id = 99,type = 1,reward = [{0,38300105,5}],show_price = 500,price = 350,weight = 2000,over_cheap = 0};

get_adventure_shop(100) ->
	#adventure_shop_cfg{id = 100,type = 1,reward = [{0,38300102,5}],show_price = 500,price = 350,weight = 2000,over_cheap = 0};

get_adventure_shop(101) ->
	#adventure_shop_cfg{id = 101,type = 1,reward = [{0,38300110,5}],show_price = 500,price = 350,weight = 2000,over_cheap = 0};

get_adventure_shop(102) ->
	#adventure_shop_cfg{id = 102,type = 1,reward = [{0,38300108,5}],show_price = 500,price = 350,weight = 2000,over_cheap = 0};

get_adventure_shop(103) ->
	#adventure_shop_cfg{id = 103,type = 1,reward = [{0,38300106,5}],show_price = 500,price = 350,weight = 2000,over_cheap = 0};

get_adventure_shop(104) ->
	#adventure_shop_cfg{id = 104,type = 1,reward = [{0,34010041,5}],show_price = 600,price = 420,weight = 2000,over_cheap = 0};

get_adventure_shop(105) ->
	#adventure_shop_cfg{id = 105,type = 1,reward = [{0,38300101,5}],show_price = 500,price = 300,weight = 2000,over_cheap = 0};

get_adventure_shop(106) ->
	#adventure_shop_cfg{id = 106,type = 1,reward = [{0,38300104,5}],show_price = 500,price = 300,weight = 2000,over_cheap = 0};

get_adventure_shop(107) ->
	#adventure_shop_cfg{id = 107,type = 1,reward = [{0,38300103,5}],show_price = 500,price = 300,weight = 2000,over_cheap = 0};

get_adventure_shop(108) ->
	#adventure_shop_cfg{id = 108,type = 1,reward = [{0,38300105,5}],show_price = 500,price = 300,weight = 2000,over_cheap = 0};

get_adventure_shop(109) ->
	#adventure_shop_cfg{id = 109,type = 1,reward = [{0,38300102,5}],show_price = 500,price = 300,weight = 2000,over_cheap = 0};

get_adventure_shop(110) ->
	#adventure_shop_cfg{id = 110,type = 1,reward = [{0,38300110,5}],show_price = 500,price = 300,weight = 2000,over_cheap = 0};

get_adventure_shop(111) ->
	#adventure_shop_cfg{id = 111,type = 1,reward = [{0,38300108,5}],show_price = 500,price = 300,weight = 2000,over_cheap = 0};

get_adventure_shop(112) ->
	#adventure_shop_cfg{id = 112,type = 1,reward = [{0,38300106,5}],show_price = 500,price = 300,weight = 2000,over_cheap = 0};

get_adventure_shop(113) ->
	#adventure_shop_cfg{id = 113,type = 1,reward = [{0,34010041,5}],show_price = 600,price = 360,weight = 2000,over_cheap = 0};

get_adventure_shop(114) ->
	#adventure_shop_cfg{id = 114,type = 1,reward = [{0,38300101,5}],show_price = 500,price = 150,weight = 100,over_cheap = 1};

get_adventure_shop(115) ->
	#adventure_shop_cfg{id = 115,type = 1,reward = [{0,38300104,5}],show_price = 500,price = 150,weight = 100,over_cheap = 1};

get_adventure_shop(116) ->
	#adventure_shop_cfg{id = 116,type = 1,reward = [{0,38300103,5}],show_price = 500,price = 150,weight = 100,over_cheap = 1};

get_adventure_shop(117) ->
	#adventure_shop_cfg{id = 117,type = 1,reward = [{0,38300105,5}],show_price = 500,price = 150,weight = 100,over_cheap = 1};

get_adventure_shop(118) ->
	#adventure_shop_cfg{id = 118,type = 1,reward = [{0,38300102,5}],show_price = 500,price = 150,weight = 100,over_cheap = 1};

get_adventure_shop(119) ->
	#adventure_shop_cfg{id = 119,type = 1,reward = [{0,38300110,5}],show_price = 500,price = 150,weight = 100,over_cheap = 1};

get_adventure_shop(120) ->
	#adventure_shop_cfg{id = 120,type = 1,reward = [{0,38300108,5}],show_price = 500,price = 150,weight = 100,over_cheap = 1};

get_adventure_shop(121) ->
	#adventure_shop_cfg{id = 121,type = 1,reward = [{0,38300106,5}],show_price = 500,price = 150,weight = 100,over_cheap = 1};

get_adventure_shop(_Id) ->
	[].

get_adven_shop_type() ->
[0,1].


get_adventure_shop_weight(0) ->
[{2000,1},{2000,2},{2000,3},{2000,4},{2000,5},{2000,6},{2000,7},{2000,8},{2000,9},{2000,10},{2000,11},{2000,12},{2000,13},{2000,14},{2000,15},{2000,16}];


get_adventure_shop_weight(1) ->
[{2000,17},{2000,18},{2000,19},{2000,20},{2000,21},{2000,22},{2000,23},{2000,24},{2000,25},{2000,26},{2000,27},{2000,28},{2000,29},{2000,30},{2000,31},{2000,32},{2000,33},{2000,34},{2000,35},{2000,36},{2000,37},{2000,38},{2000,39},{2000,40},{2000,41},{2000,42},{2000,43},{100,44},{100,45},{100,46},{100,47},{100,48},{100,49},{100,50},{100,51},{2000,52},{2000,53},{2000,54},{2000,55},{2000,56},{2000,57},{2000,58},{2000,59},{2000,60},{2000,61},{2000,62},{2000,63},{2000,64},{2000,65},{2000,66},{2000,67},{2000,68},{2000,69},{2000,70},{2000,71},{2000,72},{2000,73},{2000,74},{2000,75},{2000,76},{2000,77},{2000,78},{100,79},{100,80},{100,81},{100,82},{100,83},{100,84},{100,85},{100,86},{2000,87},{2000,88},{2000,89},{2000,90},{2000,91},{2000,92},{2000,93},{2000,94},{2000,95},{2000,96},{2000,97},{2000,98},{2000,99},{2000,100},{2000,101},{2000,102},{2000,103},{2000,104},{2000,105},{2000,106},{2000,107},{2000,108},{2000,109},{2000,110},{2000,111},{2000,112},{2000,113},{100,114},{100,115},{100,116},{100,117},{100,118},{100,119},{100,120},{100,121}];

get_adventure_shop_weight(_Type) ->
	[].

get_adventure_shop_refresh(_Refresh) when _Refresh >= 1, _Refresh =< 3 ->
		[{1,0,20}];
get_adventure_shop_refresh(_Refresh) when _Refresh >= 4, _Refresh =< 9 ->
		[{1,0,35}];
get_adventure_shop_refresh(_Refresh) when _Refresh >= 10, _Refresh =< 19 ->
		[{1,0,50}];
get_adventure_shop_refresh(_Refresh) when _Refresh >= 20, _Refresh =< 999999 ->
		[{1,0,100}];
get_adventure_shop_refresh(_Refresh) ->
	[].

