%%%-------------------------------------------------------------------
%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%% 幻兽之域
%%% @end
%%% Created : 27 Oct 2017 by root <root@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(mod_eudemons_land_zone).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-compile(export_all).

-include("common.hrl").
-include("chat.hrl").
-include("eudemons_land.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("eudemons_zone.hrl").
-include("def_cache.hrl").

-ifdef(DEV_SERVER).
-define(RECALC_ZONE,  60).
-define(RESET_ZONE,  300).
-else.
-define(RECALC_ZONE, 600). %% 定时分区计算
-define(RESET_ZONE,  3600). %% 重置时间一个小时
-endif.

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_server_info(Node) ->
    mod_clusters_center:apply_cast(Node, lib_eudemons_zone_api, get_server_info_local, []).

get_zone_list() ->
    gen_server:call(?MODULE, {get_zone_list}, 1000).

get_same_zone_servers(ServerId) ->
    gen_server:call(?MODULE, {get_same_zone_servers, ServerId}, 1000).

add_server_in_eudemons(ServerId, Node, ServerNum, ServerName, Power, OpTime, MergeServerIds) ->
    gen_server:cast(?MODULE, {'add_server_in_eudemons', ServerId, Node, ServerNum, ServerName, Power, OpTime, MergeServerIds}).

apply_to_zone_cast(ZoneId, M, F, A) ->
    gen_server:cast(?MODULE, {'apply_to_zone_cast', ZoneId, M, F, A}).

gm_test_reset() ->
    gen_server:cast(?MODULE, {'gm_test_reset'}).

gm_get_same_zone(ZoneId) ->
    gen_server:call(?MODULE, {gm_get_same_zone, ZoneId}, 1000).

gm_reset_start() ->
    ?MODULE ! 'reset_start'.

show_state() ->
    gen_server:cast(?MODULE, {'show_state'}).

cast_center(Msg) ->
    mod_clusters_node:apply_cast(?MODULE, apply_cast, Msg).

apply_cast(Msg) ->
    gen_server:cast(?MODULE, Msg).

apply_cast_with_state(M, F, A) ->
    gen_server:cast(?MODULE, {apply_cast_with_state, M, F, A}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    process_flag(trap_exit, true),
    %% 区域路由表
    ets:new(eudemons_zone, [named_table, protected, set, {keypos, #eudemons_zone.server_id}]),
    State = zone_init(),
    %?PRINT("zone init ~p~n", [State#eudemons_zone_mgr.server_map]),
    {ok, State}.

zone_init() ->
    _NowTime = utime:unixtime(),
    {ServerMap, ZoneMap, ZoneId} = init_zone_server_status(),
    case maps:size(ZoneMap) == 0 of 
        true -> 
            Ref = util:send_after([], ?RECALC_ZONE*1000, self(), 'reset_end'),
            NewState = #eudemons_zone_mgr{status = 2, reset_etime = utime:unixtime() + ?RECALC_ZONE, ref_reset = Ref},
            %lib_eudemons_zone_api:reset_start(NewState),
            NewState;
        _ ->
            %% ?ERR("~p ~p LinesEudemonsBoss:~p~n", [?MODULE, ?LINE, LinesEudemonsBoss]),
            State = #eudemons_zone_mgr{zone_id = ZoneId, server_map = ServerMap, zone_map = ZoneMap},
            NewState = init_next_reset(State),
            NewState
    end.


handle_call(Req, From, State) ->
    case catch do_handle_call(Req, From, State) of
        {reply, Res, NewState} ->
            {reply, Res, NewState};
        Res ->
            ?ERR("Eudemons Land Call Error:~p~n", [[Req, Res]]),
            {reply, error, State}

    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Eudemons Land Cast Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Eudemons Land Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

do_handle_call({get_zone_list}, _From, State) ->
    #eudemons_zone_mgr{status = Status, reset_etime = ResetETime, next_reset_time = NextResetTime, zone_map = ZoneMap} = State,
    Reply = case Status == 2 andalso utime:unixtime() =< ResetETime of 
        true -> {true, in_reset, ResetETime};
        false ->
            ZoneIdList = maps:keys(ZoneMap),
            {true, ZoneIdList, NextResetTime}
    end,
    %?PRINT("zone get_zone_list Reply ~p ~n", [Reply]),
    {reply, Reply, State};

do_handle_call({get_same_zone_servers, ServerId}, _From, State) ->
    #eudemons_zone_mgr{server_map = ServerMap, zone_map = ZoneMap} = State,
    Reply = case maps:get(ServerId, ServerMap, false) of 
        #eudemons_server{zone_id = ZoneId} ->
            SameList = get_same_zone_servers(ZoneId, ZoneMap, ServerMap),
            {ok, SameList};
        _ -> {ok, []}
    end,
    {reply, Reply, State};

% do_handle_call({gm_get_same_zone, ZoneId}, _From, State) ->
%     #eudemons_zone_mgr{server_map = _ServerMap, zone_map = ZoneMap} = State,
%     List = maps:get(ZoneId, ZoneMap, false),
%     ?PRINT("zone gm_get_same_zone List ~p ~n", [List]),
%     {reply, ok, State};


do_handle_call(_Req, _From, State)->
    ?ERR("_Req:~p~n", [_Req]),
    {reply, ok, State}.

%% 增加一个服
do_handle_cast({'add_server_in_eudemons', ServerId, Node, ServerNum, ServerName, Power, OpTime, MergeServerIds}, State)->
    %?PRINT("add_server_in_eudemons ~p~n", [{ServerId, Node, ServerNum}]),
    #eudemons_zone_mgr{status = Status, reset_etime = ResetETime, sign_list = SignList} = State,
    NMergeServerIds = lists:delete(ServerId, MergeServerIds),
    case Status == 2 andalso utime:unixtime() < ResetETime of 
        true -> %% 正在重置，放进sign_list
            NewSignList = [{ServerId, ServerNum, ServerName, Power, OpTime, NMergeServerIds}|lists:keydelete(ServerId, 1, SignList)],
            NewState = State#eudemons_zone_mgr{sign_list = NewSignList},
            lib_eudemons_zone_api:in_reset(ServerId, NewState),
            {noreply, NewState};
        _ -> %% 添加新节点到幻兽分区
            {Type, NewState} = add_server_in_eudemons({ServerId, Node, ServerNum, ServerName, Power, OpTime, NMergeServerIds}, State),
            lib_eudemons_zone_api:sync_server_data(Type, ServerId, NewState),
            {noreply, NewState}
    end;

%% 发送分区执行
do_handle_cast({'apply_to_zone_cast', ZoneId, M, F, A}, State)->
    #eudemons_zone_mgr{zone_map = ZoneMap, server_map = ServerMap} = State,
    apply_to_zone_cast_do(ZoneId, ZoneMap, ServerMap, M, F, A),
    {noreply, State};

% do_handle_cast({'gm_test_reset'}, State)->
%     F = fun(I, List) ->
%         Power = urand:rand(1,600),
%         OpTime = utime:unixtime() - urand:rand(1, 30 * ?ONE_DAY_SECONDS),
%         [{I, I, "", Power, OpTime, []}|List]
%     end,
%     SignList = lists:foldl(F, [], lists:seq(1,130)),
%     NewState = reset_zone(#eudemons_zone_mgr{sign_list = SignList}),
%     %?PRINT("gm test reset ~p~n", [NewState#eudemons_zone_mgr.zone_id]),
%     %?PRINT("gm test reset ~p~n", [NewState#eudemons_zone_mgr.zone_map]),
%     {noreply, NewState};

% do_handle_cast({zone_chat, ServerId, BinData}, State)->
%     #eudemons_zone_mgr{zone_map = ZoneMap, server_map = ServerMap} = State,
%     ZoneId = get_zone_id(ServerId, ServerMap),
%     SerList = maps:get(ZoneId, ZoneMap, []),
%     {M, F, A} = {lib_server_send, send_to_all, [all_lv, {?CHAT_LV_EUDEMONS_ZONE, 65535}, BinData]},
%     [begin
%         case maps:get(SerId, ServerMap, false) of 
%             #eudemons_server{optime = OpTime} ->
%                 case util:check_open_day_2(?CHAT_OPEN_DAY_EUDEMONS_ZONE, OpTime) of 
%                     true ->
%                         mod_clusters_center:apply_cast(SerId, M, F, A);
%                     _ -> skip
%                 end;
%             _ -> skip
%         end
%     end || SerId <- SerList],  
%     {noreply, State};

do_handle_cast({apply_cast_with_state, M, F, A}, State)->
    apply(M, F, [State|A]),
    {noreply, State};


do_handle_cast({'show_state'}, State)->
    ?PRINT("show_state ~p~n", [State]),
    {noreply, State};

do_handle_cast(Msg, State)->
    ?ERR("Boss Cast No Match:~w~n", [Msg]),
    {noreply, State}.

do_handle_info('reset_pre', State) ->
    #eudemons_zone_mgr{ref_reset = ORef} = State,
    Ref = util:send_after(ORef, ?ANNOUNCE_TIME*1000, self(), 'reset_start'),
    lib_eudemons_zone_api:reset_pre(?ANNOUNCE_TIME),
    {noreply, State#eudemons_zone_mgr{ref_reset = Ref}};

do_handle_info('reset_start', State) ->
    #eudemons_zone_mgr{ref_reset = ORef} = State,
    Ref = util:send_after(ORef, ?RESET_ZONE*1000, self(), 'reset_end'),
    NewState = #eudemons_zone_mgr{status = 2, reset_etime = utime:unixtime()+?RESET_ZONE, ref_reset = Ref},
    db:execute(<<"truncate table eudemons_zone">>),
    ets:delete_all_objects(eudemons_zone),
    lib_eudemons_zone_api:reset_start(NewState),
    {noreply, NewState};

do_handle_info('reset_end', State) ->
    NewState = reset_zone(State),
    LastState = init_next_reset(NewState),
    lib_eudemons_zone_api:reset_end(LastState),
    {noreply, LastState};

do_handle_info(_Info, State) ->
    ?ERR("Boss Info No Match:~w~n", [_Info]),
    {noreply, State}.


%% ================================= private fun =================================
init_zone_server_status() ->
    case db:get_all(<<"select server_id, zone_id, server_num, server_name, op_time from eudemons_zone">>) of 
        [] -> {#{}, #{}, 0};
        ZoneList ->
            F = fun([ServerId, ZoneId, ServerNum, ServerName, OpTime], {M1, M2}) ->
                save_eudemons_zone(ServerId, ZoneId),
                ServerInfo = #eudemons_server{server_id = ServerId, zone_id = ZoneId, server_num = ServerNum, server_name = ServerName, optime = OpTime},
                NewM1 = maps:put(ServerId, ServerInfo, M1),
                ZoneServerList = maps:get(ZoneId, M2, []),
                NewM2 = maps:put(ZoneId, [ServerId|ZoneServerList], M2),
                {NewM1, NewM2}
            end,
            {ServerMap, ZoneMap} = lists:foldl(F, {#{}, #{}}, ZoneList),
            MaxZoneId = lists:max(maps:keys(ZoneMap)),
            {ServerMap, ZoneMap, MaxZoneId}
    end.

%% 计算下次重置时间
init_next_reset(State) ->
    #eudemons_zone_mgr{ref_reset = RefReset} = State,
    NowTime = utime:unixtime(),
    AnnounceGap = ?ANNOUNCE_TIME,  
    WeekDay5 = utime:get_month_start_weekday(5),
    NextWeekDay5 = utime:get_next_month_start_weekday(5),
    {Msg, RefTime, NextResetTime} = 
        if
            WeekDay5 >= NowTime andalso (WeekDay5 - AnnounceGap) >= NowTime -> {'reset_pre', WeekDay5 - AnnounceGap, WeekDay5};
            WeekDay5 >= NowTime -> {'reset_start', WeekDay5, WeekDay5};
            NextWeekDay5 >= NowTime andalso (NextWeekDay5 - AnnounceGap) >= NowTime -> {'reset_pre', NextWeekDay5 - AnnounceGap, NextWeekDay5};
            true -> {'reset_start', NextWeekDay5, NextWeekDay5}
        end,
    Ref = util:send_after(RefReset, (RefTime - NowTime)*1000, self(), Msg),
    State#eudemons_zone_mgr{next_reset_time = NextResetTime, ref_reset = Ref}.
    
%%------------------------------------ 重置区域
reset_zone(State) ->
    %% SignList: [{ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds}]
    #eudemons_zone_mgr{sign_list = SignList} = State,
    OpTimeSort = lists:keysort(5, SignList),
    {Left, GroupFirst} = divide_group_first(OpTimeSort, []),
    GroupList = divide_group(Left, GroupFirst),
    {ZoneId, ServerMap, ZoneMap} = divide_zone(GroupList, 0, #{}, #{}),
    %?PRINT("reset_zone ~p~n", [{ZoneId, ServerMap, ZoneMap}]),
    save_zones_all(ServerMap),
    spawn(fun() -> db_replace_eudemons_server(maps:values(ServerMap)) end),
    NewState = #eudemons_zone_mgr{zone_id = ZoneId, server_map = ServerMap, zone_map = ZoneMap},
    NewState.

%% 分组1：将开服天数大于等于90天的服归为一个大组
divide_group_first(OpTimeSort, _Result) ->
    %% 开服超过90天的全部分为一组
    OpEndTime90 = utime:unixtime() - ?EUDEMONS_DAY_1 * ?ONE_DAY_SECONDS,
    {Left, GroupDay90} = divide_group_2(OpTimeSort, OpEndTime90, []),
    {Left, [GroupDay90]}.

%% 分组2：将开服天数在7天之类的服归为一组
divide_group([], Result) -> lists:reverse(Result);
divide_group([{ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds}|OpTimeSort], Result) ->
    OpEndTime7 = OpTime + ?EUDEMONS_DAY_2 * ?ONE_DAY_SECONDS,
    {LeftOpTimeSort, Group} = divide_group_2([{ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds}|OpTimeSort], OpEndTime7, []),
    divide_group(LeftOpTimeSort, [Group|Result]).

divide_group_2([], _OpEndTime, Result) -> {[], Result};
divide_group_2([{ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds}|OpTimeSort], OpEndTime, Result) ->
    case OpTime =< OpEndTime of 
        true -> 
            NewResult = [{ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds}|Result],
            divide_group_2(OpTimeSort, OpEndTime, NewResult);
        _ ->
            {[{ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds}|OpTimeSort], Result}
    end.

%% 分区域：对分组后的每一组进行分区
%% 以24个服为例：将24服按战力分8个小组，分别从8个小组随机取一个服归为同一个区域
divide_zone([], ZoneId, ServerMap, ZoneMap) -> {ZoneId, ServerMap, ZoneMap};
divide_zone([Group|GroupList], ZoneId, ServerMap, ZoneMap) ->
    PowerSort = lists:reverse(lists:keysort(4, Group)),   %% 战力排序
    Len = length(PowerSort),
    {NewServerMap, NewZoneMap, NewZoneId} = divide_zone_1(Len, ZoneId, PowerSort, ServerMap, ZoneMap),
    divide_zone(GroupList, NewZoneId, NewServerMap, NewZoneMap).

divide_zone_1(Len, ZoneId, PowerSort, ServerMap, ZoneMap) when Len >= 24 ->
    {SubPowerSort, LeftPowerSort} = lists:split(24, PowerSort),
    ZoneList = divide_zone_core(SubPowerSort, [1,2,3]),
    {NewServerMap, NewZoneMap, NewZoneId} = divide_zone_core_1(ZoneList, ZoneId, ServerMap, ZoneMap),
    LeftLen = length(LeftPowerSort),
    divide_zone_1(LeftLen, NewZoneId, LeftPowerSort, NewServerMap, NewZoneMap);
divide_zone_1(Len, ZoneId, PowerSort, ServerMap, ZoneMap) when Len >= 16 ->
    {SubPowerSort, LeftPowerSort} = lists:split(16, PowerSort),
    ZoneList = divide_zone_core(SubPowerSort, [1,2]),
    {NewServerMap, NewZoneMap, NewZoneId} = divide_zone_core_1(ZoneList, ZoneId, ServerMap, ZoneMap),
    LeftLen = length(LeftPowerSort),
    divide_zone_1(LeftLen, NewZoneId, LeftPowerSort, NewServerMap, NewZoneMap);
divide_zone_1(Len, ZoneId, PowerSort, ServerMap, ZoneMap) when Len >= 8 ->
    {SubPowerSort, LeftPowerSort} = lists:split(8, PowerSort),
    {NewServerMap, NewZoneMap, NewZoneId} = divide_zone_core_1([SubPowerSort, LeftPowerSort], ZoneId, ServerMap, ZoneMap),
    {NewServerMap, NewZoneMap, NewZoneId};
divide_zone_1(_Len, ZoneId, PowerSort, ServerMap, ZoneMap) ->
    {NewServerMap, NewZoneMap, NewZoneId} = divide_zone_core_1([PowerSort], ZoneId, ServerMap, ZoneMap),
    {NewServerMap, NewZoneMap, NewZoneId}.

divide_zone_core(SubPowerSort, IndexList) ->
    F = fun({ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds}, {List, TmpIndexList}) ->
        case TmpIndexList of 
            [] ->
                [Index|L] = ulists:list_shuffle(IndexList),
                {[{ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds, Index}|List], L};
            [Index|L] ->
                {[{ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds, Index}|List], L}
        end
    end,
    {SubPowerSort1, _} = lists:foldl(F, {[], ulists:list_shuffle(IndexList)}, SubPowerSort),
    F2 = fun(Index, List) ->
        ZoneOne = [ {ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds} || {ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds, Index1} <- SubPowerSort1, Index1 == Index],
        [ZoneOne|List]
    end,
    lists:foldl(F2, [], IndexList).

divide_zone_core_1(ZoneList, ZoneId, ServerMap, ZoneMap) ->
    F = fun(ZoneOne, {M1, M2, Z1}) ->
        case length(ZoneOne) > 0 of 
            true ->
                NewZ1 = Z1 + 1,
                FI = fun({ServerId, ServerNum, ServerName, _Power, OpTime, MergeServerIds}, {TM1, List}) ->
                    ServerInfo = #eudemons_server{server_id = ServerId, zone_id = NewZ1, server_num = ServerNum, server_name = ServerName, optime = OpTime, merge_servers = MergeServerIds},
                    NewTM1 = maps:put(ServerId, ServerInfo, TM1),
                    {NewTM1, [ServerId|List]}
                end,
                {NewM1, NewList} = lists:foldl(FI, {M1, []}, ZoneOne),
                NewM2 = maps:put(NewZ1, NewList, M2),
                {NewM1, NewM2, NewZ1};
            _ ->
               {M1, M2, Z1} 
        end
    end,
    {NewServerMap, NewZoneMap, NewZoneId} = lists:foldl(F, {ServerMap, ZoneMap, ZoneId}, ZoneList),
    {NewServerMap, NewZoneMap, NewZoneId}.

%% 添加服务器
add_server_in_eudemons({ServerId, _Node, ServerNum, ServerName, Power, OpTime, MergeServerIds}, State) ->
    #eudemons_zone_mgr{server_map = ServerMap, zone_map = _ZoneMap} = State,
    case maps:get(ServerId, ServerMap, false) of 
        #eudemons_server{} = OServerInfo -> %% 老服，要进行合服分区处理
            ?PRINT("old server ~p~n", [{ServerId, MergeServerIds}]),
            NewServerInfo = OServerInfo#eudemons_server{server_num = ServerNum, server_name = ServerName, merge_servers = MergeServerIds},
            NewServerMap = maps:put(ServerId, NewServerInfo, ServerMap),
            NewState = merge_fix(NewServerInfo, MergeServerIds, State#eudemons_zone_mgr{server_map = NewServerMap}),
            {old, NewState};
        _ ->
            NewState = add_new_server({ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds}, State),
            {new, NewState}
    end.

%% 合服处理
merge_fix(MainServerInfo, MergeServerIds, State) ->
    #eudemons_zone_mgr{server_map = ServerMap, zone_map = ZoneMap} = State,
    #eudemons_server{zone_id = MainZoneId} = MainServerInfo,
    F = fun(SerId, {M1, M2, DelList}) ->
        case maps:get(SerId, M1, false) of 
            #eudemons_server{zone_id = OZoneId} = _ServerInfo -> 
                update_eudemon_zone(SerId, OZoneId, MainZoneId),
                NewM1 = maps:remove(SerId, M1),
                OServerIdList = maps:get(OZoneId, M2, []),
                NewM2 = maps:put(OZoneId, lists:delete(SerId, OServerIdList), M2),
                {NewM1, NewM2, [SerId|DelList]};
            _ -> 
                save_eudemons_zone(SerId, MainZoneId),
                {M1, M2, DelList}
        end
    end,
    {NewServerMap, NewZoneMap, DelServerIds} = lists:foldl(F, {ServerMap, ZoneMap, []}, MergeServerIds),
    ?PRINT("merge_fix ~p~n", [DelServerIds]),
    case DelServerIds == [] of 
        true -> ok;
        _ ->
            SqlDel = io_lib:format(<<"delete from eudemons_zone where server_id in (~s)">>, [util:link_list(DelServerIds)]),
            db:execute(SqlDel)
    end,
    State#eudemons_zone_mgr{server_map = NewServerMap, zone_map = NewZoneMap}.

%% 添加新服
add_new_server({ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds}, State) ->
    #eudemons_zone_mgr{zone_id = ZoneId, server_map = ServerMap, zone_map = ZoneMap} = State,
    ServerIds = maps:get(ZoneId, ZoneMap, []),
    %% ZoneId=0说明还没有服务器加入分区，zoneid初始是从1开始
    case ZoneId == 0 orelse length(ServerIds) >= 8 of 
        false ->
            {NewServerMap, NewZoneMap} = add_new_server_do({ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds}, ZoneId, ServerMap, ZoneMap),  
            State#eudemons_zone_mgr{server_map = NewServerMap, zone_map = NewZoneMap};
        _ -> %% 创建新区域
            NewZoneId = ZoneId + 1,
            {NewServerMap, NewZoneMap} = add_new_server_do({ServerId, ServerNum, ServerName, Power, OpTime, MergeServerIds}, NewZoneId, ServerMap, ZoneMap), 
            NewState = State#eudemons_zone_mgr{zone_id = NewZoneId, server_map = NewServerMap, zone_map = NewZoneMap},
            lib_eudemons_zone_api:add_new_zone(NewZoneId, NewState),
            NewState
    end.

add_new_server_do({ServerId, ServerNum, ServerName, _Power, OpTime, MergeServerIds}, ZoneId, ServerMap, ZoneMap) ->
    ServerInfo = #eudemons_server{server_id = ServerId, zone_id = ZoneId, server_num = ServerNum, server_name = ServerName, optime = OpTime, merge_servers = MergeServerIds},
    NewServerMap = maps:put(ServerId, ServerInfo, ServerMap),
    ServerIds = maps:get(ZoneId, ZoneMap, []),
    NewZoneMap = maps:put(ZoneId, [ServerId|ServerIds], ZoneMap),
    save_eudemons_zone(ServerId, ZoneId),
    %% db
    db_replace_eudemons_server([ServerInfo]),
    ?PRINT("add_new_server_do ~p~n", [ServerInfo]),
    {NewServerMap, NewZoneMap}.

%% db
db_replace_eudemons_server([]) -> ok;
db_replace_eudemons_server(ServerInfoList) ->
    F = fun(ServerInfo, ArgsList) ->
        #eudemons_server{server_id = ServerId, zone_id = ZoneId, server_num = ServerNum, server_name = ServerName, optime = OpTime} = ServerInfo,
        [[ServerId, ZoneId, ServerNum, util:fix_sql_str(ServerName), OpTime]|ArgsList]
    end,
    SqlArgs = lists:foldl(F, [], ServerInfoList),
    Sql = usql:replace(eudemons_zone, [server_id, zone_id, server_num, server_name, op_time], SqlArgs),
    db:execute(Sql).

save_zones_all(ServerMap) ->
    F = fun(ServerId, #eudemons_server{zone_id = ZoneId, merge_servers = MergeServerIds}, Acc) ->
        [save_eudemons_zone(SerId, ZoneId) || SerId <- [ServerId|MergeServerIds]], 
        Acc
    end,
    maps:fold(F, 0, ServerMap).

save_eudemons_zone(ServerId, ZoneId) ->
    ets:insert(eudemons_zone, #eudemons_zone{server_id = ServerId, zone_id = ZoneId}).

update_eudemon_zone(SerId, OZoneId, NewZoneId) ->
    case OZoneId == NewZoneId of 
        true -> ok;
        _ ->
            lib_eudemons_zone_api:zone_change(SerId, OZoneId, NewZoneId),
            ets:update_element(eudemons_zone, SerId, {#eudemons_zone.zone_id, NewZoneId})
    end.

get_zone_id(ServerId, ServerMap) ->
    case maps:get(ServerId, ServerMap, false) of 
        #eudemons_server{zone_id = ZoneId} -> ZoneId;
        _ -> 
            ?ERR("get_zone_id fail server_id=~w ~n", [ServerId]), 
            0
    end.

%% 获取相同区域的服务器列表
get_same_zone_servers(ZoneId, ZoneMap, ServerMap) ->
    ServerIds = maps:get(ZoneId, ZoneMap, []),
    F = fun(ServerId, List) -> 
        case maps:get(ServerId, ServerMap, false) of 
            #eudemons_server{} = Item ->
                [Item|List];
            _ -> List
        end
    end,
    lists:foldl(F, [], ServerIds).

apply_to_zone_cast_do(ZoneId, ZoneMap, _ServerMap, M, F, A) -> 
    ServerIds = maps:get(ZoneId, ZoneMap, []),
    [ mod_clusters_center:apply_cast(SerId, M, F, A) || SerId <- ServerIds].


