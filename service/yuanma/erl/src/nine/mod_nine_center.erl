%% ---------------------------------------------------------------------------
%% @doc mod_nine_center.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-09-30
%% @deprecated 九魂圣殿
%% ---------------------------------------------------------------------------
-module(mod_nine_center).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile(export_all).

-include("role_nine.hrl").
-include("common.hrl").
-include("clusters.hrl").

-define(MOD_STATE, nine_state).     %% 九魂圣殿状态

%% 本地->跨服中心 Msg = [{start,args}]
call_center(Msg) ->
    mod_clusters_node:apply_call(?MODULE, call_mod, Msg).
cast_center(Msg) ->
    mod_clusters_node:apply_cast(?MODULE, cast_mod, Msg).
info_center(Msg) ->
    mod_clusters_node:apply_cast(?MODULE, info_mod, Msg).

gm_partition() ->
    cast_center([{'gm_partition'}]).

gm_act_end() ->
    cast_center([{'apply', gm_act_end, []}]).

%% 跨服中心分发到管理进程
call_mod(Msg) ->
    gen_server:call({global, ?MODULE}, Msg).
cast_mod(Msg) ->
    gen_server:cast({global, ?MODULE}, Msg).
info_mod(Msg) ->
    misc:whereis_name(global,?MODULE) ! Msg.

%% 获得状态
print() ->
    gen_server:call({global, ?MODULE}, {'print'}).

% 分区分组信息同步
sync_zone_group(InfoList) ->
    gen_server:cast({global, ?MODULE}, {'sync_zone_group', InfoList}).

%% 活动开启
act_start(AcSub) ->
    gen_server:cast({global, ?MODULE}, {'apply', act_start, AcSub}).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    State = lib_nine_battle:init(?CLS_TYPE_CENTER),
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("~p call error: ~p, Reason=~p~n", [?MODULE, Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
%%    ?MYLOG("nine_local_zh", "cast LogMsg ~p State zoneMap ~p ~n", [Msg, State#nine_state.zone_map]),
    case catch do_handle_cast(Msg, State) of
        ok -> {noreply, State};
        {ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        {noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        Reason ->
            ?ERR("~p cast error: ~p, Reason:=~p~n", [?MODULE, Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
%%    ?MYLOG("nine_local_zh", "info Info ~p State zoneMap ~p ~n", [Info, State#nine_state.zone_map]),
    case catch do_handle_info(Info, State) of
        ok -> {noreply, State};
        {ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        {noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        Reason ->
            ?ERR("~p info error: ~p, Reason:=~p~n", [?MODULE, Info, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------------
%% handle_call
%% --------------------------------------------------------------------------

do_handle_call({'get_state'}, _From, State) ->
    ?INFO("get_state:~p~n", [State]),
    {reply, State, State};

do_handle_call({'print'}, _From, State) ->
    #nine_state{state_type = StateType, cls_type = ClsType, status = Status, stime = Stime, etime = Etime} = State,
    Msg = {StateType, ClsType, Status, Stime, Etime},
    ?INFO("Msg:~p~n", [Msg]),
    {reply, Msg, State};

do_handle_call(_Request, _From, State) ->
    ?ERR("do_handle_call no match _Info:~p ~n",[_Request]),
    {reply, no_match, State}.

%% --------------------------------------------------------------------------
%% handle_cast
%% --------------------------------------------------------------------------
do_handle_cast({'sync_zone_group', InfoList}, State) ->
    F = fun({ZoneId, {Servers, GroupInfo}}, AccMap) ->
        #zone_group_info{group_mod_servers = GroupModServers} = GroupInfo,
        F2 = fun(ModGroupData, {AccSerModMap, AccModGroupMap}) ->
            #zone_mod_group_data{group_id = GroupId, mod = Mod, server_ids = ServerIds} = ModGroupData,
            ServerZones = [Server||Server<-Servers, lists:member(Server#zone_base.server_id, ServerIds)],
            NewAccModGroupMap = AccModGroupMap#{{Mod, GroupId} => ServerZones},
            Map = maps:from_list([{SerId, {Mod, GroupId}}||SerId<-ServerIds]),
            NewAccSerModMap = maps:merge(AccSerModMap, Map),
            [mod_clusters_center:apply_cast(SerId, mod_nine_local, sync_partition, [{ZoneId, GroupId, Mod, ServerZones}])||SerId <- ServerIds],
            {NewAccSerModMap, NewAccModGroupMap}
        end,
        {ServerModMap, ModGroupMap} = lists:foldl(F2, {#{}, #{}}, GroupModServers),
        AccMap#{ZoneId => {ServerModMap, ModGroupMap}}
    end,
    GroupMap = lists:foldl(F, #{}, InfoList),
    {noreply, State#nine_state{group_map = GroupMap}};

do_handle_cast({'apply', F}, State) ->
    erlang:apply(lib_nine_battle, F, [State]);

do_handle_cast({'apply', F, Args}, State) ->
    erlang:apply(lib_nine_battle, F, [State|Args]);

do_handle_cast(_Msg, State) -> 
    ?ERR("do_handle_cast no match _Msg:~p ~n",[_Msg]),
    {noreply, State}.

%% -----------------------------------------------------------------
%% hanle_info
%% -----------------------------------------------------------------

do_handle_info({'apply', F}, State) ->
    erlang:apply(lib_nine_battle, F, [State]);

do_handle_info({'apply', F, Args}, State) ->
    erlang:apply(lib_nine_battle, F, [State|Args]);

do_handle_info(_Info, State) -> 
    ?ERR("do_handle_info no match _Info:~p ~n",[_Info]),
    {noreply, State}.


