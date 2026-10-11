%%%---------------------------------------
%%% module      : data_guild_assist
%%% description : 公会协助配置
%%%
%%%---------------------------------------
-module(data_guild_assist).
-compile(export_all).
-include("rec_assist.hrl").



get_assist_cfg(1,10) ->
	#base_guild_assist{type = 1,sub_type = 10,condition = [{role_lv, 130}, {open_day,1}],rewards = [{28,36255100,100}]};

get_assist_cfg(1,12) ->
	#base_guild_assist{type = 1,sub_type = 12,condition = [{role_lv, 200}, {open_day, 4}],rewards = [{28,36255100,100}]};

get_assist_cfg(1,17) ->
	#base_guild_assist{type = 1,sub_type = 17,condition = [{role_lv, 130}, {open_day,1}],rewards = [{28,36255100,100}]};

get_assist_cfg(2,5) ->
	#base_guild_assist{type = 2,sub_type = 5,condition = [{role_lv, 130}, {open_day,1}],rewards = [{28,36255100,100}]};

get_assist_cfg(2,32) ->
	#base_guild_assist{type = 2,sub_type = 32,condition = [{role_lv, 130}, {open_day,1}],rewards = [{28,36255100,100}]};

get_assist_cfg(2,41) ->
	#base_guild_assist{type = 2,sub_type = 41,condition = [{role_lv, 130}, {open_day,1}],rewards = [{28,36255100,100}]};

get_assist_cfg(3,1) ->
	#base_guild_assist{type = 3,sub_type = 1,condition = [{role_lv, 130}, {open_day,1}],rewards = []};

get_assist_cfg(4,1) ->
	#base_guild_assist{type = 4,sub_type = 1,condition = [{role_lv, 130}, {open_day,1}],rewards = [{28,36255100,100}]};

get_assist_cfg(_Type,_Subtype) ->
	[].

