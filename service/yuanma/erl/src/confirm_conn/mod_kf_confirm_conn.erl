%% ---------------------------------------------------------------------------
%% @doc mod_kf_confirm_conn.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-07-20
%% @deprecated 跨服确认链接
%% ---------------------------------------------------------------------------
-module(mod_kf_confirm_conn).
-behavious(gen_server).

-include("common.hrl").
-include("def_gen_server.hrl").
-include("confirm_conn.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile(export_all).

%% 请求确认链接
ask_confirm_conn(ServerId, Node, MergeServerIds, Optime, ServerName, ServerNum, MergeDay) ->
    gen_server:cast(?MODULE, {'ask_confirm_conn', ServerId, Node, MergeServerIds, Optime, ServerName, ServerNum, MergeDay}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init(Args) ->
    ?DO_INIT(Args).
handle_call(Request, From, State) ->
    ?DO_HANDLE_CALL(Request, From, State).
handle_cast(Msg, State) ->
    ?DO_HANDLE_CAST(Msg, State).
handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State).
terminate(Reason, State) ->
    ?DO_TERMINATE(Reason, State).
code_change(OldVsn, State, Extra) ->
    ?DO_CODE_CHANGE(OldVsn, State, Extra).

do_init([]) ->
    {ok, #kf_confirm_conn_state{}}.

do_handle_call(_Request, _From, _State) ->
    no_match.

%% 请求确认链接
do_handle_cast({'ask_confirm_conn', ServerId, Node, MergeServerIds, Optime, ServerName, ServerNum, MergeDay}, State) ->
    case catch lib_kf_confirm_conn_event:confirm_conn(ServerId, Node, MergeServerIds, Optime, ServerName, ServerNum, MergeDay) of
        true -> skip;
        Error -> ?ERR("lib_kf_confirm_conn_event:confirm_conn SerId:~w, Node:~p error:~p~n", [ServerId, Node, Error])
    end,
    % ?MYLOG("kfconn", "ask_confirm_conn ~n", []),
    {noreply, State};

do_handle_cast(_Msg, _State) ->
    no_match.

do_handle_info(_Info, _State) ->
    no_match.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.