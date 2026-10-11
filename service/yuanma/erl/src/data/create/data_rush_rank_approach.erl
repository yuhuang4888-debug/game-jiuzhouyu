%%%---------------------------------------
%%% module      : data_rush_rank_approach
%%% description : 冲榜途径配置
%%%
%%%---------------------------------------
-module(data_rush_rank_approach).
-compile(export_all).




get_all_jump(1) ->
[228,229,232,234];


get_all_jump(2) ->
[230,231,232,234];


get_all_jump(3) ->
[230,231,232,234];


get_all_jump(4) ->
[230,231,232,234];


get_all_jump(5) ->
[230,232,233,234];


get_all_jump(6) ->
[230,232,233,234];


get_all_jump(13) ->
[230,232];


get_all_jump(14) ->
[230,232,234];

get_all_jump(_Rushid) ->
	[].

