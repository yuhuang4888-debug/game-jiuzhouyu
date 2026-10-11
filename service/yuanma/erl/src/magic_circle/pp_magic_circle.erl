%%%-----------------------------------
%%% @Module      : pp_magic_circle
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 24. 十一月 2018 11:07
%%% @Description : 魔法阵
%%%-----------------------------------
-module(pp_magic_circle).
-author("chenyiming").

%% API
-compile(export_all).
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").

handle(Cmd, Ps, Data) ->
	do_handle(Cmd, Ps, Data).

%% 魔法阵信息
do_handle(21601, Ps, []) ->
	lib_magic_circle:get_info(Ps),
	{ok, Ps};

%% 召唤魔法阵
do_handle(21602, Ps, [Lv, Type, Auto]) ->
	NewPs= lib_magic_circle:create_magic_circle(Ps, Lv, Type, Auto),
	{ok, NewPs};

%% 幻化5
do_handle(21605, Ps, [Lv, Show]) ->
	NewPs= lib_magic_circle:show_magic_circle(Ps, Lv, Show),
	{ok, NewPs};

%% 登录检查魔法阵过期
do_handle(21606, PS, []) ->
	NewPs = lib_magic_circle:login_check_expired(PS),
	{ok, Bin} = pt_216:write(21606, [?SUCCESS]),
	lib_server_send:send_to_uid(PS#player_status.id, Bin),
	{ok, NewPs};

do_handle(_, _, _) ->
	ok.