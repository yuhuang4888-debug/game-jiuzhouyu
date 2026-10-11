%% ---------------------------------------------------------------------------
%% @doc lib_bf_confirm_conn_event.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-07-20
%% @deprecated 本服确认链接的事件
%% ---------------------------------------------------------------------------
-module(lib_bf_confirm_conn_event).
-compile(export_all).

-include("common.hrl").

%% 本服确认链接到跨服(可能多次触发)
confirm_conn() ->
    % ?INFO("lib_bf_confirm_conn_event:confirm_conn ~n", []),
    true.