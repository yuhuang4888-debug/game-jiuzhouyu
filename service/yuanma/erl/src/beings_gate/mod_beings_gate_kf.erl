%%% -------------------------------------------------------------------
%%% @doc        mod_beings_gate_kf                 
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-28 16:04
%%% @deprecated 众生之门跨服进程
%%% -------------------------------------------------------------------

-module(mod_beings_gate_kf).

-behaviour(gen_server).

-include("common.hrl").
-include("beings_gate.hrl").
-include("clusters.hrl").

%% API
-export([start_link/0, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
    call_center/1
    , cast_center/1
    , call_mod/1
    , cast_mod/1
    , init/1
    , sync_zone_group/1
    , is_exit_portal/1
    , beings_gate_sync_server_data/1
    , server_info_change/3]).

%%% ====================================== exported functions ======================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 本地->跨服中心
call_center(Msg) ->
    mod_clusters_node:apply_call(?MODULE, call_mod, Msg).
cast_center(Msg) ->
    mod_clusters_node:apply_cast(?MODULE, cast_mod, Msg).

%% 跨服中心分发到管理进程
call_mod(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mod(Msg) ->
    gen_server:cast(?MODULE, Msg).

%% 判断是否存在该传送门
is_exit_portal(PortalId) ->
    gen_server:call(?MODULE, {'apply', is_exit_portal, [PortalId]}).

%% 同步跨服信息到本服
beings_gate_sync_server_data(ServerId) ->
    gen_server:cast(?MODULE, {'apply', beings_gate_sync_server_data, [ServerId]}).

%% 分区分组信息同步
sync_zone_group(InfoList) ->
    gen_server:cast(?MODULE, {'apply', sync_zone_group, [InfoList]}).

%% 服信息发生改变
server_info_change(ZoneId, ServerId, KvList) ->
    gen_server:cast(?MODULE, {'apply', server_info_change, [ZoneId, ServerId, KvList]}).

%%% ====================================== callback functions ======================================

init([]) ->
    DBActivityList = lib_beings_gate_sql:db_select_beings_gate_activity_cls(),
    State = lib_beings_gate_mod:init(?CROSS_SERVER, DBActivityList),
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} -> {reply, Reply, NewState};
        Reason ->
            ?ERR("~p call error: ~p, Reason=~p~n", [?MODULE, Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} when is_record(NewState, beings_gate_status) -> {noreply, NewState};
        Reason ->
            ?ERR("~p cast error: ~p, Reason:=~p~n", [?MODULE, Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} when is_record(NewState, beings_gate_status) -> {noreply, NewState};
        Reason ->
            ?ERR("~p info error: ~p, Reason:=~p~n", [beings_gate_status, Info, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

do_handle_call({'apply', F}, _From, State) ->
    erlang:apply(lib_beings_gate_mod_kf, F, [State]);

do_handle_call({'apply', F, Args}, _From, State) ->
    erlang:apply(lib_beings_gate_mod_kf, F, [State | Args]);

do_handle_call(_Request, _From, State) ->
    ?ERR("do_handle_call no match _Info:~p ~n",[_Request]),
    {reply, no_match, State}.

do_handle_cast({'apply', F}, State) ->
    erlang:apply(lib_beings_gate_mod_kf, F, [State]);

do_handle_cast({'apply', F, Args}, State) ->
    erlang:apply(lib_beings_gate_mod_kf, F, [State | Args]);

do_handle_cast(_Msg, State) ->
    ?ERR("do_handle_cast no match _Msg:~p ~n",[_Msg]),
    {noreply, State}.

do_handle_info({'apply', F}, State) ->
    erlang:apply(lib_beings_gate_mod_kf, F, [State]);

do_handle_info({'apply', F, Args}, State) ->
    erlang:apply(lib_beings_gate_mod_kf, F, [State | Args]);

do_handle_info(_Info, State) ->
    ?ERR("do_handle_info no match _Info:~p ~n",[_Info]),
    {noreply, State}.


