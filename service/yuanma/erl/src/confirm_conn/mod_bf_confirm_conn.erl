%% ---------------------------------------------------------------------------
%% @doc mod_bf_confirm_conn.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-07-20
%% @deprecated 本服确认链接
%% ---------------------------------------------------------------------------
-module(mod_bf_confirm_conn).
-behavious(gen_server).

-include("common.hrl").
-include("def_gen_server.hrl").
-include("confirm_conn.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile(export_all).

%% 链接到跨服中心
center_connected() ->
    gen_server:cast(?MODULE, {'center_connected'}).

%% 跨服链接断开
cluster_link_close() ->
    gen_server:cast(?MODULE, {'cluster_link_close'}).

%% 确认链接
confirm_conn() ->
    gen_server:cast(?MODULE, {'confirm_conn'}).

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
    State = #bf_confirm_conn_state{
        is_conn = ?CONFIRM_CONN_NO,
        conn_ref = erlang:send_after(1000, self(), {'conn_ref'}),
        server_id = config:get_server_id(),
        merge_server_ids = config:get_merge_server_ids(),
        optime = util:get_open_time(),
        server_name = util:get_server_name(),
        server_num = config:get_server_num(),
        merge_day = util:get_merge_day()
    },
    {ok, State}.

do_handle_call(_Request, _From, _State) ->
    no_match.

%% 链接跨服成功:立刻去确认
do_handle_cast({'center_connected'}, State) ->
    #bf_confirm_conn_state{conn_ref = OldRef} = State,
    ConnRef = util:send_after(OldRef, 1000, self(), {'conn_ref'}),
    NewState = State#bf_confirm_conn_state{is_conn = ?CONFIRM_CONN_NO, conn_ref = ConnRef},
    ?PRINT("center_connected ~n", []),
    % ?MYLOG("conn", "center_connected ~n", []),
    {noreply, NewState};

%% 链接跨服失败:定时去请求链接
do_handle_cast({'cluster_link_close'}, State) ->
    #bf_confirm_conn_state{conn_ref = OldRef} = State,
    ConnRef = util:send_after(OldRef, ?CONFIRM_CONN_TIME, self(), {'conn_ref'}),
    NewState = State#bf_confirm_conn_state{is_conn = ?CONFIRM_CONN_NO, conn_ref = ConnRef},
    ?PRINT("cluster_link_close ~n", []),
    % ?MYLOG("conn", "cluster_link_close ~n", []),
    {noreply, NewState};

%% 跨服通知确认链接
do_handle_cast({'confirm_conn'}, State) ->
    case catch lib_bf_confirm_conn_event:confirm_conn() of
        true -> skip;
        Error -> ?ERR("lib_bf_confirm_conn_event:confirm_conn error:~p~n", [Error])
    end,
    #bf_confirm_conn_state{conn_ref = OldRef} = State,
    util:cancel_timer(OldRef),
    NewState = State#bf_confirm_conn_state{is_conn = ?CONFIRM_CONN_YES, conn_ref = none},
    ?PRINT("confirm_conn ~n", []),
    % ?MYLOG("conn", "confirm_conn ~n", []),
    {noreply, NewState};

do_handle_cast(_Msg, _State) ->
    no_match.

%% 链接定时器
do_handle_info({'conn_ref'}, State) ->
    #bf_confirm_conn_state{
        conn_ref = OldRef, server_id = ServerId, merge_server_ids = MergeServerIds, optime = Optime, 
        server_name = ServerName, server_num = ServerNum, merge_day = MergeDay
        } = State,
    mod_clusters_node:apply_cast(mod_kf_confirm_conn, ask_confirm_conn, [ServerId, node(), MergeServerIds, Optime, ServerName, ServerNum, MergeDay]),
    ConnRef = util:send_after(OldRef, ?CONFIRM_CONN_TIME, self(), {'conn_ref'}),
    NewState = State#bf_confirm_conn_state{conn_ref = ConnRef},
    % ?PRINT("conn_ref ~n", []),
    % ?MYLOG("conn", "conn_ref ~n", []),
    {noreply, NewState};

do_handle_info(_Info, _State) ->
    no_match.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.