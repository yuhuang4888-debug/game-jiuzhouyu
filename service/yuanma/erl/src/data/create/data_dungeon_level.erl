%%%---------------------------------------
%%% module      : data_dungeon_level
%%% description : 副本关卡配置
%%%
%%%---------------------------------------
-module(data_dungeon_level).
-compile(export_all).
-include("dungeon.hrl").



get_dungeon_level(2151,2150) ->
	#dungeon_level{dun_id = 2151,scene_id = 2150,serial_no = 1,time = 180,wave_num = 1,mon_event = [{1,1,[],[{level_time,5}]}],story_event = [],zone_event = [],scene_event = [],success_event = [{1,[],[{mon_event_id_kill_all_mon,1}]}],fail_event = [{1,[],[{level_timeout}]}]};

get_dungeon_level(2151,2151) ->
	#dungeon_level{dun_id = 2151,scene_id = 2151,serial_no = 2,time = 180,wave_num = 1,mon_event = [{1,1,[],[{level_time,5}]}],story_event = [],zone_event = [],scene_event = [],success_event = [{1,[],[{mon_event_id_kill_all_mon,1}]}],fail_event = [{1,[],[{level_timeout}]}]};

get_dungeon_level(_Dunid,_Sceneid) ->
	[].


get_scene_id_list(2151) ->
[2150,2151];

get_scene_id_list(_Dunid) ->
	[].

get_scene_by_lv(2151,_Lv) when 1 == _Lv ->
		2150;
get_scene_by_lv(2151,_Lv) when 2 == _Lv ->
		2151;
get_scene_by_lv(_Dun_id,_Lv) ->
	[].

