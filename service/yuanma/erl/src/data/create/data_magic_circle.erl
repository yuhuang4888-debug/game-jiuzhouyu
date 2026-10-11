%%%---------------------------------------
%%% module      : data_magic_circle
%%% description : 魔法阵配置
%%%
%%%---------------------------------------
-module(data_magic_circle).
-compile(export_all).
-include("magic_circle.hrl").



get_magic_circle_by_lv(0,1) ->
	#data_magic_circle{pre_lv = 0,magic_circle_lv = 1,lv = 0,name = "经验喵",cost = [{0, [{0,38040013,1}]}, {1, [{2,0,666}]}, {2, [{1,0,380}]}],last_day = 30,attr = [{1,750},{3,250},{202,5000}]};

get_magic_circle_by_lv(0,2) ->
	#data_magic_circle{pre_lv = 0,magic_circle_lv = 2,lv = 0,name = "守护喵",cost = [{0,[{0,38040014,1}]}, {1, [{2,0,288}]}, {2, [{1,0,288}]}],last_day = 10,attr = [{2,15000},{4,250},{10,1500}]};

get_magic_circle_by_lv(0,3) ->
	#data_magic_circle{pre_lv = 0,magic_circle_lv = 3,lv = 0,name = "高级经验喵",cost = [{0, [{0,38040055,1}]}, {1, []}, {2, []}],last_day = 3600,attr = [{9,500},{202,5000},{1,3000},{3,1000}]};

get_magic_circle_by_lv(0,4) ->
	#data_magic_circle{pre_lv = 0,magic_circle_lv = 4,lv = 0,name = "高级守护喵",cost = [{0, [{0,38040059,1}]}, {1, []}, {2, []}],last_day = 3600,attr = [{10,2000},{2,60000},{4,1000},{39,1000}]};

get_magic_circle_by_lv(_Prelv,_Magiccirclelv) ->
	[].


get_value_by_key(free_lv) ->
[[{60, 1}]];


get_value_by_key(free_time) ->
[1800];


get_value_by_key(guardian_angel_figure) ->
[2001];


get_value_by_key(high_magic_circle_id) ->
[2002];


get_value_by_key(low_magic_circle_id) ->
[2000];


get_value_by_key(naughty_devil_figure) ->
[2003];


get_value_by_key(task_id) ->
[101130];

get_value_by_key(_Key) ->
	[].

