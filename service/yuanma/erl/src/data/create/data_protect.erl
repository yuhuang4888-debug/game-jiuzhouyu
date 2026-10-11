%%%---------------------------------------
%%% module      : data_protect
%%% description : 免战保护配置
%%%
%%%---------------------------------------
-module(data_protect).
-compile(export_all).
-include("protect.hrl").



get_protect(22) ->
	#base_protect{scene_type = 22,use_time = 600,use_count = 1};

get_protect(_Scenetype) ->
	[].

get_protect_scene_type_list() ->
[22].

