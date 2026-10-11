%%%---------------------------------------
%%% module      : data_horn
%%% description : 喇叭配置
%%%
%%%---------------------------------------
-module(data_horn).
-compile(export_all).




get_value(cost_goods) ->
[{1,[{0,1102015065,1}]},{2,[{0,1102015065, 3}]},{3,[{0, 1102015065, 5}]}];


get_value(horn_show_time) ->
13;


get_value(open_lv) ->
60;


get_value(send_msg_interval) ->
0;

get_value(_Key) ->
	[].

