%%%---------------------------------------
%%% module      : data_color
%%% description : 颜色配置
%%%
%%%---------------------------------------
-module(data_color).
-compile(export_all).




get_name(0) ->
<<"白色"/utf8>>;


get_name(1) ->
<<"绿色"/utf8>>;


get_name(2) ->
<<"蓝色"/utf8>>;


get_name(3) ->
<<"紫色"/utf8>>;


get_name(4) ->
<<"橙色"/utf8>>;


get_name(5) ->
<<"红色"/utf8>>;


get_name(6) ->
<<"暗金"/utf8>>;


get_name(7) ->
<<"粉色"/utf8>>;


get_name(8) ->
<<"钻石"/utf8>>;

get_name(_Colorid) ->
	<<>>.

