%%% ------------------------------------------------------------------------------------------------
%%% @doc            pp_fiesta.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-12-03
%%% @modified
%%% @description    祭典协议路由
%%% ------------------------------------------------------------------------------------------------
-module(pp_fiesta).

-include("common.hrl").

-export([
    handle/3
]).

handle(Cmd, PS, Data) ->
   % ?PRINT("Cmd ~p~n", [{Cmd, Data}]),
   do_handle(Cmd, PS, Data).

do_handle(19401, PS, []) ->
    lib_fiesta:send_fiesta_info(PS),
    ok;

do_handle(19402, PS, [Lv]) ->
    NewPS = lib_fiesta:receive_fiesta_reward(Lv, PS),
    {ok, NewPS};

do_handle(19403, PS, [TaskType]) ->
    lib_fiesta:send_task_info(TaskType, PS),
    ok;

do_handle(19404, PS, [TaskType, TaskId]) ->
    NewPS = lib_fiesta:receive_task_reward(TaskType, TaskId, PS),
    {ok, NewPS};

do_handle(19405, PS, [Type]) ->
    NewPS = lib_fiesta:buy_premium_fiesta(Type, PS),
    {ok, NewPS};

%% 容错
do_handle(_, _, _) ->
    {error, "Illegal protocol~n"}.