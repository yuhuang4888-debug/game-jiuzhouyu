%%%---------------------------------------
%%% module      : data_career
%%% description : 职业配置
%%%
%%%---------------------------------------
-module(data_career).
-compile(export_all).
-include("career.hrl").



get(1,1) ->
	#career{career_id = 1,career_name = "剑士",sex = 1};

get(2,2) ->
	#career{career_id = 2,career_name = "武姬",sex = 2};

get(3,1) ->
	#career{career_id = 3,career_name = "枪使",sex = 1};

get(4,2) ->
	#career{career_id = 4,career_name = "弓手",sex = 2};

get(_Careerid,_Sex) ->
	[].

get_all_career() ->
[{1,1},{2,2},{3,1},{4,2}].


get_sex_list(1) ->
[1];


get_sex_list(2) ->
[2];


get_sex_list(3) ->
[1];


get_sex_list(4) ->
[2];

get_sex_list(_Careerid) ->
	[].


get_career_list(1) ->
[1,3];


get_career_list(2) ->
[2,4];

get_career_list(_Sex) ->
	[].

