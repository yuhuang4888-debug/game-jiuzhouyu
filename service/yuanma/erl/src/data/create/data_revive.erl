%%%---------------------------------------
%%% module      : data_revive
%%% description : 复活配置
%%%
%%%---------------------------------------
-module(data_revive).
-compile(export_all).




get_scene_revive_cost(12) ->
[{0,38380003,1}];


get_scene_revive_cost(34) ->
[{0,38380002,1}];


get_scene_revive_cost(38) ->
[{0,38380001,1}];

get_scene_revive_cost(_Scenetype) ->
	false.

