%% ---------------------------------------------------------------------------
%% @doc data_chat_m.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-06-29
%% @deprecated 聊天
%% ---------------------------------------------------------------------------
-module(data_chat_m).
-export([]).

-compile(export_all).

-include("chat.hrl").

get_forbid_type(Type, Args) ->
    if
        Type =:= ?TALK_LIMIT_TYPE_1 -> utext:get(151, Args);
        Type =:= ?TALK_LIMIT_TYPE_2 -> utext:get(152, Args);
        Type =:= ?TALK_LIMIT_TYPE_3 -> utext:get(153, Args);
        Type =:= ?TALK_LIMIT_TYPE_4 -> utext:get(154, Args);
        Type =:= ?TALK_LIMIT_TYPE_5 -> utext:get(1100001, Args);
        Type =:= ?TALK_LIMIT_TYPE_6 -> utext:get(1100002, Args);
        Type =:= ?TALK_LIMIT_TYPE_7 -> utext:get(1100003, Args)
    end.

get_release_type(Type) ->
    if
        Type =:= ?TALK_RELEASE_TYPE_1 -> utext:get(155);
        Type =:= ?TALK_RELEASE_TYPE_2 -> utext:get(156)
    end.

is_admin_forbid(Type) ->
    if
        Type =:= 1 -> utext:get(157);
        true -> utext:get(158)
    end.
