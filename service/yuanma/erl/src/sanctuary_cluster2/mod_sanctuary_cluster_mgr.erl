%% ---------------------------------------------------------------------------
%% @doc mod_sanctuary_cluster_mgr

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/9/3 0003
%% @desc  
%% ---------------------------------------------------------------------------
-module(mod_sanctuary_cluster_mgr).

-behaviour(gen_server).

%% API
-export([
      start_link/0
    % , midnight_update/2
    , sync_zone_group/1
    , center_connected/2
    , server_info_change/2
    , zone_change/5
    , process_stop/0
]).

%GM
-export([
    gm_create_mon/0,
    mon_reborn/0,
    gm_start_act/0
]).

%% gen_server callbacks

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-include("common.hrl").
-include("def_gen_server.hrl").
-include("clusters.hrl").
-include("cluster_sanctuary.hrl").

%% ===========================
%%  Function Need Export
%% ===========================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 零点定时器
% midnight_update(AllZones, Z2SMap) ->
%     gen_server:cast(?MODULE, {'midnight_update', AllZones, Z2SMap}).

% 分区分组同步
sync_zone_group(InfoList) ->
    gen_server:cast(?MODULE, {'sync_zone_group', InfoList}).

%% 游戏服连接上跨服中心
%% 1. 处理合服情况（一些数据矫正，可能涉及到跨分区合服）
%% 2. 数据再次同步到连接上的游戏服，确保数据成功同步
center_connected(ServerId, MergeSerIds) ->
    gen_server:cast(?MODULE, {'center_connected', ServerId, MergeSerIds}).

server_info_change(ServerId, Args) ->
    mod_sanctuary_cluster:server_info_change(ServerId, Args).
    % 直接去对应的进程处理， 保存的信息用处不太大
    % gen_server:cast(?MODULE, {'server_info_change', ServerId, Args}).

%% 分区更改
zone_change(ServerId, OldZoneId, OZoneGroupInfo, NewZoneId, NZoneGroupInfo) ->
    gen_server:cast(?MODULE, {'zone_change', ServerId, OldZoneId, OZoneGroupInfo, NewZoneId, NZoneGroupInfo}).

gm_create_mon() ->
    mod_clusters_node:apply_cast(?MODULE, mon_reborn, []).

mon_reborn() -> whereis(?MODULE) ! mon_reborn.

%% 跨服中心关闭时调用
process_stop() ->
    gen_server:call(?MODULE, {process_stop}).

gm_start_act() ->
    mod_clusters_node:apply_call(gen_server, cast, [?MODULE, 'gm_start_act']).

%% ===========================
%% gen_server callbacks temples
%% ===========================
init(Args) ->
    ?DO_INIT(Args).
handle_call(Request, From, State) ->
    ?DO_HANDLE_CALL(Request, From, State).

handle_cast({'sync_zone_group', InfoList}, State) ->
    NewState = lib_sanctuary_cluster_mod:sync_zone_group(State, InfoList),
    {noreply, NewState};
handle_cast(Msg, #sanctuary_mgr_state{is_init = IsInit, message_queue = MessQueue} = State) when IsInit == 0 ->
    NewMessQueue = [Msg|MessQueue],
    NewState = State#sanctuary_mgr_state{message_queue = NewMessQueue},
    {noreply, NewState};
handle_cast(Msg, State) ->
    ?DO_HANDLE_CAST(Msg, State).

handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State).
terminate(Reason, State) ->
    ?DO_TERMINATE(Reason, State).
code_change(OldVsn, State, Extra) ->
    ?DO_CODE_CHANGE(OldVsn, State, Extra).

%% =============================
%% gen_server callbacks
%% =============================

do_init([]) ->
    {ok, #sanctuary_mgr_state{}}.

do_handle_call({process_stop}, _From, State)->
    #sanctuary_mgr_state{zone_division = ZoneDivision} = State,
    [begin
         case catch mod_sanctuary_cluster:process_stop(Pid) of
             ok -> ok;
             {reply, _Reply, _} -> ok;
             Err ->
                 ?ERR("mod_sanctuary_cluster process_stop error:~p~n", [Err])
         end
     end|| Pid<-ZoneDivision],
    {reply, ok, State};

do_handle_call(_Request, _From, _State) ->
    no_match.

% do_handle_cast({'midnight_update', AllZones, _Z2SMap}, State) ->
%     NewState = lib_sanctuary_cluster_mod:midnight_update(State, AllZones),
%     {noreply, NewState};

do_handle_cast({'center_connected', ServerId, MergeSerIds}, State) ->
    #sanctuary_mgr_state{all_zone_server = AllZoneServer, zone_server_map = ZoneServerMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    % 先处理信息同步
    mod_sanctuary_cluster:center_connected(ZoneId, ServerId),

    % 次服ID
    SecSerIds = lists:delete(ServerId, MergeSerIds),
    F = fun(SerId) -> lists:keymember(SerId, #zone_base.server_id, AllZoneServer) end,
    % 首次成为次服的服务器列表
    FirstSecSerIds = lists:filter(F, SecSerIds),
    F2 = fun(SerId, {AccZoneL, AccZonSerMap}) ->
        case lists:keytake(SerId, #zone_base.server_id, AccZoneL) of
            {value, #zone_base{zone = SecZoneId}, NewAccZoneL} ->
                % 修正合服后的数据
                mod_sanctuary_cluster:fix_merge_server_data(SecZoneId, SerId, ZoneId, ServerId),

                ZoneSerL = maps:get(SecZoneId, AccZonSerMap, []),
                NewZoneSerL = lists:keydelete(SerId, #zone_base.server_id, ZoneSerL),
                NewAccZonSerMap = AccZonSerMap#{SecZoneId => NewZoneSerL};
            _ ->
                NewAccZoneL = AccZoneL, NewAccZonSerMap = AccZonSerMap
        end,
        {NewAccZoneL, NewAccZonSerMap}
    end,
    {NewAllZoneServer, NewZoneServerMap} = lists:foldl(F2, {AllZoneServer, ZoneServerMap}, FirstSecSerIds),
    NewState = State#sanctuary_mgr_state{all_zone_server = NewAllZoneServer, zone_server_map = NewZoneServerMap},
    {noreply, NewState};

do_handle_cast({'zone_change', ServerId, OldZoneId, OZoneGroupInfo, NewZoneId, NZoneGroupInfo}, State) ->
    #sanctuary_mgr_state{all_zone_server = AllZoneServer, zone_server_map = ZoneServerMap} = State,
    case lists:keyfind(ServerId, #zone_base.server_id, AllZoneServer) of
        false -> {noreply, State};
        ZoneBase ->
            mod_sanctuary_cluster:zone_change(OldZoneId, OZoneGroupInfo, NewZoneId, NZoneGroupInfo),

            NewAllZoneServer = lists:keystore(ServerId, #zone_base.server_id, AllZoneServer, ZoneBase#zone_base{zone = NewZoneId}),
            ZonSerL1 = maps:get(OldZoneId, ZoneServerMap, []),
            ZonSerL2 = maps:get(NewZoneId, ZoneServerMap, []),

            NewZonSerL1 = lists:keydelete(ServerId, #zone_base.server_id, ZonSerL1),
            NewZonSerL2 = lists:keystore(ServerId, #zone_base.server_id, ZonSerL2, ZoneBase#zone_base{zone = NewZoneId}),

            NewZoneServerMap = ZoneServerMap#{OldZoneId => NewZonSerL1, NewZoneId => NewZonSerL2},
            NewState = State#sanctuary_mgr_state{all_zone_server = NewAllZoneServer, zone_server_map = NewZoneServerMap},
            {noreply, NewState}
    end;

do_handle_cast('gm_start_act', State) ->
    #sanctuary_mgr_state{start_ref = StartRef, mon_reborn_ref = ReBornRef} = State,
    NowTime = utime:unixtime(),
    NewStartRef = util:send_after(StartRef, 100, self(), 'act_start'),
    NewReBornRef = util:send_after(ReBornRef, 1000, self(), 'mon_reborn'),
    {noreply, State#sanctuary_mgr_state{start_time = NowTime, start_ref = NewStartRef, mon_reborn_ref = NewReBornRef}};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info('act_start', State) ->
    #sanctuary_mgr_state{
        start_ref = Ref,
        zone_division = ZoneDivision, start_time = StartTime,
        end_time = EndTime, mon_reborn_time = MonRebornTime
    } = State,
    util:cancel_timer(Ref),
    [mod_sanctuary_cluster:act_start(Pid, StartTime, EndTime, MonRebornTime)||Pid<-ZoneDivision],
    {noreply, State#sanctuary_mgr_state{start_ref = []}};

do_handle_info('role_anger_clear', State) ->
    #sanctuary_mgr_state{role_anger_ref = OClearRef} = State,
    mod_clusters_center:apply_to_all_node(lib_sanctuary_cluster, clear_role_anger, [], 20),
    ClearRef = util:send_after(OClearRef, ?ONE_DAY_SECONDS * 1000, self(), 'role_anger_clear'),
    {noreply, State#sanctuary_mgr_state{role_anger_ref = ClearRef}};

do_handle_info({'tips_act_end', NotifyLastMin}, State) ->
    #sanctuary_mgr_state{act_tv_ref = ONotifyRef} = State,
    mod_clusters_center:apply_to_all_node(lib_sanctuary_cluster, send_act_end_tv, [NotifyLastMin]),
    % 没两分钟通知一次
    case NotifyLastMin - 2 of
        NextNotify when NextNotify > 0 ->
            NotifyRef = util:send_after(ONotifyRef, NextNotify * 60 * 1000, self(), {'tips_act_end', NextNotify});
        _ ->
            util:cancel_timer(ONotifyRef),
            NotifyRef = []
    end,
    {noreply, State#sanctuary_mgr_state{act_tv_ref = NotifyRef}};

do_handle_info('mon_reborn', State) ->
    #sanctuary_mgr_state{
        zone_division = ZoneDivision, mon_reborn_ref = OldRef, start_time = StartTime
    } = State,
    NowTime = utime:unixtime(),
    NextRebornTime0 = lib_sanctuary_cluster_util:calc_next_mon_time(NowTime),
    case NextRebornTime0 < StartTime of
        true -> NextRebornTime = lib_sanctuary_cluster_util:calc_next_mon_time(NextRebornTime0 + 10);
        _ -> NextRebornTime = NextRebornTime0
    end,
    ?PRINT("ZoneDivision ~p ~n", [ZoneDivision]),
    [mod_sanctuary_cluster:mon_reborn(Pid, NextRebornTime)||Pid<-ZoneDivision],
    Ref = util:send_after(OldRef, (NextRebornTime - NowTime) * 1000, self(), 'mon_reborn'),
    %% db:execute(?SQL_TRUNCATE_SERVER_BL),
    {noreply, State#sanctuary_mgr_state{mon_reborn_ref = Ref}};

do_handle_info('act_end', State) ->
    #sanctuary_mgr_state{
        zone_division = ZoneDivision,
        mon_reborn_ref = MonRebornRef,
        role_anger_ref = AngerRef,
        act_tv_ref = TvRef,
        start_ref = StartRef,
        end_ref = EndRef
    } = State,
    util:cancel_timer(MonRebornRef),
    util:cancel_timer(AngerRef),
    util:cancel_timer(TvRef),
    util:cancel_timer(StartRef),
    util:cancel_timer(EndRef),
    [mod_sanctuary_cluster:act_end(Pid)||Pid<-ZoneDivision],
    {noreply, State};

do_handle_info(_Info, State) ->
    {noreply, State}.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.