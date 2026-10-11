%%%---------------------------------------
%%% module      : data_dungeon_setting
%%% description : 副本设置配置
%%%
%%%---------------------------------------
-module(data_dungeon_setting).
-compile(export_all).
-include("dungeon.hrl").



get_setting(5,1,0) ->
	#base_dungeon_setting{dun_key = 5,type = 1,select_type = 0,cost = []};

get_setting(20,1,0) ->
	#base_dungeon_setting{dun_key = 20,type = 1,select_type = 0,cost = []};

get_setting(20,2,0) ->
	#base_dungeon_setting{dun_key = 20,type = 2,select_type = 0,cost = []};

get_setting(20,4,0) ->
	#base_dungeon_setting{dun_key = 20,type = 4,select_type = 0,cost = []};

get_setting(34,2,0) ->
	#base_dungeon_setting{dun_key = 34,type = 2,select_type = 0,cost = []};

get_setting(34,4,0) ->
	#base_dungeon_setting{dun_key = 34,type = 4,select_type = 0,cost = []};

get_setting(_Dunkey,_Type,_Selecttype) ->
	[].


get_setting_type_list(5) ->
[1];


get_setting_type_list(20) ->
[1,2,4];


get_setting_type_list(34) ->
[2,4];

get_setting_type_list(_Dunkey) ->
	[].

get_setting_select_type_list(5,1) ->
[0];

get_setting_select_type_list(20,1) ->
[0];

get_setting_select_type_list(20,2) ->
[0];

get_setting_select_type_list(20,4) ->
[0];

get_setting_select_type_list(34,2) ->
[0];

get_setting_select_type_list(34,4) ->
[0];

get_setting_select_type_list(_Dunkey,_Type) ->
	[].

