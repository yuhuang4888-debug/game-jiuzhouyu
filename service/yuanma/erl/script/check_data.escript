#!/usr/bin/env escript
%% -*- erlang -*-
%% @doc 配置检测脚本
-include("../include/common.hrl").

main(_) ->
	io:setopts([{encoding, utf8}]),
  	code:add_path("../ebin/"),
	case catch check:main([]) of
		ok -> 
			halt(1);
		Error -> 
			?PRINT("error data:~p~n", [Error]), 			
			?ERR("error data:~p~n", [Error]),
			halt(127)
	end.
