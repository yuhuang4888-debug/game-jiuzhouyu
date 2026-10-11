%%% -------------------------------------------------------------------
%%% @doc        mod_beings_gate_local
%%% @author     lwc
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-28 16:05
%%% @deprecated 众生之门本服进程
%%% -------------------------------------------------------------------

-module(mod_beings_gate_local).

-behaviour(gen_server).

-include("common.hrl").
-include("beings_gate.hrl").

%% API
-export([
    start_link/0
    , beings_gate_sync_partition/1
    , act_start/2
    , send_beings_gate_info/1
    , send_beings_portal_info/2
    , add_activity_value/2
    , refresh_activity_value/0
    , enter_beings_gate_scene/2
    , beings_gate_sync_data/1
    , match_teams/2
    , gm_act_start/1
    , gm_clear_activity/0
    , destroy_portal_by_id/3
    , enter_portal/3
    , is_exit_portal/1
    , beings_gate_sync_activity/1
]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%% ====================================== exported functions ======================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 活动开启
act_start(ModuleSub, AcSub) ->
    gen_server:cast(?MODULE, {'apply', act_start, [ModuleSub, AcSub]}).

%% 发送众生之门信息
send_beings_gate_info(Flag) ->
    gen_server:cast(?MODULE, {'apply', send_beings_gate_info, [Flag]}).

%% 发送传送门信息
send_beings_portal_info(RoleId, ServerId) ->
    gen_server:cast(?MODULE, {'apply', send_beings_portal_info, [RoleId, ServerId]}).

%% 增加活跃度
add_activity_value(AddValue, ServerId) ->
    gen_server:cast(?MODULE, {'apply', add_activity_value, [AddValue, ServerId]}).

%% 刷新活跃度
refresh_activity_value() ->
    gen_server:cast(?MODULE, {'apply', refresh_activity_value, []}).

%% 进入众生之门场景
enter_beings_gate_scene(RoleId, ServerId) ->
    gen_server:cast(?MODULE, {'apply', enter_beings_gate_scene, [RoleId, ServerId]}).

%% 队伍匹配
match_teams(Mb, ActivityList) ->
    gen_server:cast(?MODULE, {'apply', match_teams, [Mb, ActivityList]}).

%% 进入传送门
enter_portal(PortalId, ServerId, RoleId) ->
    gen_server:cast(?MODULE, {'apply', enter_portal, [PortalId, ServerId, RoleId]}).

%% 判断是否存在该传送门
is_exit_portal(PortalId) ->
    gen_server:call(?MODULE, {'apply', is_exit_portal, [PortalId]}).

%% 销毁传送门
destroy_portal_by_id(ServerId, PortalId, PoolId) ->
    gen_server:cast(?MODULE, {'apply', destroy_portal_by_id, [ServerId, PortalId, PoolId]}).

%% 同步分服情况
beings_gate_sync_partition(BeingsGateZone) ->
    gen_server:cast(?MODULE, {'apply', beings_gate_sync_partition, [BeingsGateZone]}).

%% 活动开启/结束同步信息
beings_gate_sync_data(Args) ->
    gen_server:cast(?MODULE, {'apply', beings_gate_sync_data, [Args]}).

%% 同步活跃度
beings_gate_sync_activity(ActivityData) ->
    gen_server:cast(?MODULE, {'apply', beings_gate_sync_activity, [ActivityData]}).

%% 秘籍开启活动
gm_act_start(EndTime) ->
    gen_server:cast(?MODULE, {'apply', gm_act_start, [EndTime]}).

%% 秘籍清理活跃度统计
gm_clear_activity() ->
    gen_server:cast(?MODULE, {'apply', gm_clear_activity}).

%%% ====================================== callback functions ======================================

init([]) ->
    DBActivityList = lib_beings_gate_sql:db_select_beings_gate_activity(),
    State = lib_beings_gate_mod:init(?LOCAL_SERVER, DBActivityList),
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("~p call error:~p, Reason:~p~n", [?MODULE, Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} when is_record(NewState, beings_gate_status) -> {noreply, NewState};
        Reason ->
            ?ERR("~p cast error:~p, Reason:~p~n", [?MODULE, Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} when is_record(NewState, beings_gate_status) -> {noreply, NewState};
        Reason ->
            ?ERR("~p info error:~p, Reason:~p~n", [beings_gate_status, Info, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

do_handle_call({'apply', F}, _From, State) ->
    erlang:apply(lib_beings_gate_mod_local, F, [State]);

do_handle_call({'apply', F, Args}, _From, State) ->
    erlang:apply(lib_beings_gate_mod_local, F, [State | Args]);

do_handle_call(_Request, _From, State) ->
    ?ERR("do_handle_call no match Info:~p~n",[_Request]),
    {reply, no_match, State}.

do_handle_cast({'apply', F}, State) ->
    erlang:apply(lib_beings_gate_mod_local, F, [State]);

do_handle_cast({'apply', F, Args}, State) ->
    erlang:apply(lib_beings_gate_mod_local, F, [State | Args]);

do_handle_cast(_Msg, State) ->
    ?ERR("do_handle_cast no match Msg:~p~n",[_Msg]),
    {noreply, State}.

do_handle_info({'apply', F}, State) ->
    erlang:apply(lib_beings_gate_mod_local, F, [State]);

do_handle_info({'apply', F, Args}, State) ->
    erlang:apply(lib_beings_gate_mod_local, F, [State | Args]);

do_handle_info(_Info, State) ->
    ?ERR("do_handle_info no match Info:~p~n",[_Info]),
    {noreply, State}.