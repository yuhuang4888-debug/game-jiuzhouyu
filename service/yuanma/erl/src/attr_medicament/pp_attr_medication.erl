%%%-----------------------------------
%%% @Module      : pp_attr_medication
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 02. 一月 2019 18:47
%%% @Description : 文件摘要
%%%-----------------------------------
-module(pp_attr_medication).
-author("chenyiming").

%% API
-compile(export_all).


-include("server.hrl").
-include("common.hrl").


handle(Cmd, Ps, Data) ->
	do_handle(Cmd, Ps, Data).


%%属性药剂次数
do_handle(21701, Ps, [Lv]) ->
	lib_attr_medicament:get_count(Ps, Lv),
	{ok, Ps};

%%吃药
do_handle(21702, Ps, [GoodId, Num, Lv]) ->
	NewPs = lib_attr_medicament:use_attr_medicament(Ps, GoodId, Num, Lv),
	{ok, NewPs};
%%属性药剂次数
do_handle(21703, Ps, []) ->
	lib_attr_medicament:get_all_count(Ps),
	{ok, Ps};




do_handle(_, _, _) ->
	ok.