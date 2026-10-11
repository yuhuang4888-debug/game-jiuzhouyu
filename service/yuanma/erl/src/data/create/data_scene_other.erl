%%%---------------------------------------
%%% module      : data_scene_other
%%% description : 场景其他属性配置
%%%
%%%---------------------------------------
-module(data_scene_other).
-compile(export_all).
-include("scene.hrl").



get(1001) ->
	#ets_scene_other{id = 1001,room_max_people = 30,is_pvp_sputter = 1};

get(1002) ->
	#ets_scene_other{id = 1002,room_max_people = 30,is_pvp_sputter = 1};

get(1003) ->
	#ets_scene_other{id = 1003,room_max_people = 30,is_pvp_sputter = 1};

get(1004) ->
	#ets_scene_other{id = 1004,room_max_people = 30,is_pvp_sputter = 1};

get(12001) ->
	#ets_scene_other{id = 12001,room_max_people = 200,is_pvp_sputter = 1};

get(12002) ->
	#ets_scene_other{id = 12002,room_max_people = 200,is_pvp_sputter = 1};

get(12003) ->
	#ets_scene_other{id = 12003,room_max_people = 200,is_pvp_sputter = 1};

get(24004) ->
	#ets_scene_other{id = 24004,room_max_people = 50,is_pvp_sputter = 0};

get(_Id) ->
	[].

