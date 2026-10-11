%%% ------------------------------------------------------------------------------------------------
%%% @doc            pp_night_ghost.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-04-01
%%% @modified
%%% @description    百鬼夜行协议路由
%%% ------------------------------------------------------------------------------------------------
-module(pp_night_ghost).

-include("common.hrl").
-include("def_module.hrl").


-export([
    handle/3
]).

handle(Cmd, PS, Data) ->
   ?PRINT("Cmd ~p~n", [{Cmd, Data}]),
   do_handle(Cmd, PS, Data).

%% 获取活动信息
do_handle(20601, PS, []) ->
    lib_night_ghost:send_act_info(PS),
    ok;

%% 获取boss信息
do_handle(20602, PS, [SceneId]) ->
    lib_night_ghost:send_boss_info(SceneId, PS),
    ok;

%% 进入场景
do_handle(20603, PS, [SceneId]) ->
    lib_night_ghost:enter_scene(SceneId, PS),
    ok;

%% 退出场景
do_handle(20604, PS, []) ->
    NewPS = lib_night_ghost:exit_scene(PS),
    {ok, NewPS};

%% 容错
do_handle(_, _, _) ->
    {error, "Illegal protocol~n"}.
