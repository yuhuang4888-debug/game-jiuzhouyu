%%%---------------------------------------
%%% module      : data_anima_equip
%%% description : 灵器配置
%%%
%%%---------------------------------------
-module(data_anima_equip).
-compile(export_all).
-include("anima_equip.hrl").



get_anima_cfg(1) ->
	#base_anima_cfg{anima_id = 1,anima_name = "灵器库1",open_lv = 300,condition = [{stage,1},{qa,1,1}]};

get_anima_cfg(2) ->
	#base_anima_cfg{anima_id = 2,anima_name = "灵器库2",open_lv = 480,condition = [{stage,2},{qa,2,1}]};

get_anima_cfg(3) ->
	#base_anima_cfg{anima_id = 3,anima_name = "灵器库3",open_lv = 50,condition = [{stage,3},{qa,3,2}]};

get_anima_cfg(4) ->
	#base_anima_cfg{anima_id = 4,anima_name = "灵器库4",open_lv = 80,condition = [{stage,4},{qa,4,2}]};

get_anima_cfg(_Animaid) ->
	[].

get_all_anima() ->
[1,2,3,4].


get_anima_attr(1) ->
[{1,[2,1,1,1],[{1,100},{3,1000},{5,1000}]},{2,[4,1,1,1],[{1,100},{3,1000},{5,1000}]},{3,[6,1,1,1],[{1,100},{3,1000},{5,1000}]}];


get_anima_attr(2) ->
[{1,[2,1,1,1],[{1,100},{3,1000},{5,1000}]},{2,[4,1,1,1],[{1,100},{3,1000},{5,1000}]},{3,[6,1,1,1],[{1,100},{3,1000},{5,1000}]}];


get_anima_attr(3) ->
[{1,[2,1,1,1],[{1,100},{3,1000},{5,1000}]},{2,[4,1,1,1],[{1,100},{3,1000},{5,1000}]},{3,[6,1,1,1],[{1,100},{3,1000},{5,1000}]}];


get_anima_attr(4) ->
[{1,[2,1,1,1],[{1,100},{3,1000},{5,1000}]},{2,[4,1,1,1],[{1,100},{3,1000},{5,1000}]},{3,[6,1,1,1],[{1,100},{3,1000},{5,1000}]}];

get_anima_attr(_Animaid) ->
	[].

