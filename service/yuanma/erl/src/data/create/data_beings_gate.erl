%%%---------------------------------------
%%% module      : data_beings_gate
%%% description : 众生之门配置
%%%
%%%---------------------------------------
-module(data_beings_gate).
-compile(export_all).
-include("beings_gate.hrl").



get_portal_num(_Mod,_Activity) when _Mod == 1, _Activity >= 0, _Activity =< 500 ->
		5;
get_portal_num(_Mod,_Activity) when _Mod == 1, _Activity >= 501, _Activity =< 1000 ->
		10;
get_portal_num(_Mod,_Activity) when _Mod == 1, _Activity >= 1001, _Activity =< 1500 ->
		15;
get_portal_num(_Mod,_Activity) when _Mod == 1, _Activity >= 1501, _Activity =< 1800 ->
		18;
get_portal_num(_Mod,_Activity) when _Mod == 1, _Activity >= 1801, _Activity =< 2100 ->
		21;
get_portal_num(_Mod,_Activity) when _Mod == 1, _Activity >= 2101, _Activity =< 3000 ->
		25;
get_portal_num(_Mod,_Activity) when _Mod == 1, _Activity >= 3001, _Activity =< 4294967295 ->
		30;
get_portal_num(_Mod,_Activity) when _Mod == 2, _Activity >= 0, _Activity =< 500 ->
		5;
get_portal_num(_Mod,_Activity) when _Mod == 2, _Activity >= 501, _Activity =< 1000 ->
		10;
get_portal_num(_Mod,_Activity) when _Mod == 2, _Activity >= 1001, _Activity =< 1500 ->
		15;
get_portal_num(_Mod,_Activity) when _Mod == 2, _Activity >= 1501, _Activity =< 1800 ->
		18;
get_portal_num(_Mod,_Activity) when _Mod == 2, _Activity >= 1801, _Activity =< 2100 ->
		21;
get_portal_num(_Mod,_Activity) when _Mod == 2, _Activity >= 2101, _Activity =< 3000 ->
		25;
get_portal_num(_Mod,_Activity) when _Mod == 2, _Activity >= 3001, _Activity =< 4294967295 ->
		30;
get_portal_num(_Mod,_Activity) when _Mod == 4, _Activity >= 0, _Activity =< 500 ->
		5;
get_portal_num(_Mod,_Activity) when _Mod == 4, _Activity >= 501, _Activity =< 1000 ->
		10;
get_portal_num(_Mod,_Activity) when _Mod == 4, _Activity >= 1001, _Activity =< 1500 ->
		15;
get_portal_num(_Mod,_Activity) when _Mod == 4, _Activity >= 1501, _Activity =< 1800 ->
		18;
get_portal_num(_Mod,_Activity) when _Mod == 4, _Activity >= 1801, _Activity =< 2100 ->
		21;
get_portal_num(_Mod,_Activity) when _Mod == 4, _Activity >= 2101, _Activity =< 3000 ->
		25;
get_portal_num(_Mod,_Activity) when _Mod == 4, _Activity >= 3001, _Activity =< 4294967295 ->
		30;
get_portal_num(_Mod,_Activity) when _Mod == 8, _Activity >= 0, _Activity =< 500 ->
		5;
get_portal_num(_Mod,_Activity) when _Mod == 8, _Activity >= 501, _Activity =< 1000 ->
		10;
get_portal_num(_Mod,_Activity) when _Mod == 8, _Activity >= 1001, _Activity =< 1500 ->
		15;
get_portal_num(_Mod,_Activity) when _Mod == 8, _Activity >= 1501, _Activity =< 1800 ->
		18;
get_portal_num(_Mod,_Activity) when _Mod == 8, _Activity >= 1801, _Activity =< 2100 ->
		21;
get_portal_num(_Mod,_Activity) when _Mod == 8, _Activity >= 2101, _Activity =< 3000 ->
		25;
get_portal_num(_Mod,_Activity) when _Mod == 8, _Activity >= 3001, _Activity =< 4294967295 ->
		30;
get_portal_num(_Mod,_Activity) ->
	0.


get_value(beings_gate_coordinates) ->
[{7998,2895},{1910,3027},{6734,981},{6014,981},{5159,981},{4313,945},{3476,891},{2720,972},{1919,1125},{1397,1530},{1163,2133},{731,2844},{713,3627},{893,4608},{920,5472},{1271,6471},{2477,6498},{2774,5247},{3692,6435},{6248,6282},{5186,6210},{4844,4653},{8147,5481},{6779,3393},{6086,3060},{4322,2952},{3107,2646},{2009,2979},{7958,3195},{8210,4446},{4745,5238}];


get_value(beings_gate_dungeon_assist) ->
5;


get_value(beings_gate_dungeon_center) ->
[41003,41004];


get_value(beings_gate_dungeon_local) ->
[41001,41002];


get_value(beings_gate_dungeon_scene) ->
[41003,41004,41014,41013];


get_value(beings_gate_enter_lv) ->
130;


get_value(beings_gate_first_day) ->
30;


get_value(beings_gate_scene_center) ->
41002;


get_value(beings_gate_scene_enter) ->
5;


get_value(beings_gate_scene_local) ->
41001;

get_value(_Key) ->
	[].

