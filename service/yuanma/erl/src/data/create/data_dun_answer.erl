%%%---------------------------------------
%%% module      : data_dun_answer
%%% description : 副本答题配置
%%%
%%%---------------------------------------
-module(data_dun_answer).
-compile(export_all).




get_questions_by_dun(13001) ->
[1,2,3];

get_questions_by_dun(_Dunid) ->
	[].

get_answers(13001,1) ->
["春季","夏季","冬季","秋季"];

get_answers(13001,2) ->
["花草戒指","纯金戒指","纯银戒指","钻石戒指"];

get_answers(13001,3) ->
["火锅店","鲜花店","服装店","奶茶店"];

get_answers(_Dunid,_Id) ->
	[].

