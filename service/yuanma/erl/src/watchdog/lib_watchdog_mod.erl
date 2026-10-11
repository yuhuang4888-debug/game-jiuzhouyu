%% ---------------------------------------------------------------------------
%% @doc 看门狗服务
%% @author hek
%% @since  2018-05-24
%% @deprecated 守家护院就靠watchdog啦，值得信赖的伙伴
%% ---------------------------------------------------------------------------

-module(lib_watchdog_mod).
-include("common.hrl").
-include("watchdog.hrl").
-include("def_fun.hrl").
-export([
    init/0,
    tick/1,
    add_monitor/4,
    add_monitor/2
]).

get_init_list() ->
    [     
        {?WATCHDOD_NODE_START_TIME, utime:unixtime()}       %% 节点启动时间
        , {?WATCHDOD_SERVER_STATUS, ?SERVER_STATUS_STARTING}%% 服务器状态
        , {?WATCHDOG_GAME_ERR_CNT, 0}                       %% 当前错误次数
        , {?WATCHDOG_GAME_ERR_OVERFLOW, 0}                  %% 错误日志是否超过阀值
        , {?WATCHDOG_GAME_ERR_RESUME_CNT, 0}                %% 日志服务恢复次数
        , {?WATCHDOG_DB_GC_NUM, 0}                          %% db内存回收次数

        , {?WATCHDOG_ONLINE_PLAYER_CNT, 0}                  %% 在线人数
        , {?WATCHDOG_ONLINE_OBJECT_CNT, 0}                  %% 场景对象数量
        , {?WATCHDOG_LOGIN_PLAYER_CNT, 0}                   %% 上线人数
        , {?WATCHDOG_LOGOUT_PLAYER_CNT, 0}                  %% 下线人数
    ].

get_info_list() ->
    NowTime = utime:unixtime(),
    {OpenTime, OpenDay, MergeTime, MergeDay, MergeCNT} = case config:get_cls_type() of
        ?NODE_GAME -> 
            {
                util:get_open_time(), util:get_open_day(),
                util:get_merge_time(), util:get_merge_day(), util:get_merge_count()
            };
        _ -> {0, 0, 0, 0, 0}
    end,
    DBWoekerSize = ets:info(mysql_poolboy_worker, size),
    DBMaxConnS = config:get_mysql(db_max_connections),
    DBConnCNT = ?IF(is_integer(DBWoekerSize), DBWoekerSize, 0),
    DBMaxConnCNT = ?IF(is_integer(DBMaxConnS), DBMaxConnS, 0),
    DBOverFlowCNT = max(DBMaxConnCNT - DBConnCNT, 0),
    [
        {?WATCHDOD_SERVER_NODE, node()}                     %% 服务器节点
        , {?WATCHDOD_SERVER_TYPE, config:get_cls_type()}    %% 服务器类型
        , {?WATCHDOD_SERVER_ID, config:get_server_id()}     %% 服务器id
        , {?WATCHDOD_NOW_SYNC_TIME, NowTime}                %% 当前状态同步时间
        , {?WATCHDOD_NEXT_SYNC_TIME,  NowTime + ?TICK_TIME} %% 下次状态同步时间
        , {?WATCHDOD_SERVER_VERSION, data_version:server_version()}
        , {?WATCHDOD_SERVER_VERSION_TIME, data_version:server_version_time()}
        , {?WATCHDOD_SERVER_OPEN_TIME, OpenTime}            %% 开服时间
        , {?WATCHDOD_SERVER_OPEN_DAY, OpenDay}              %% 开发服天数
        , {?WATCHDOD_SERVER_MERGE_TIME, MergeTime}          %% 合服时间
        , {?WATCHDOD_SERVER_MERGE_DAY, MergeDay}            %% 合服天数
        , {?WATCHDOD_SERVER_MERGE_CNT, MergeCNT}            %% 合服次数
        , {?WATCHDOD_WORLD_LV, util:get_world_lv()}         %% 当前世界等级
        , {?WATCHDOG_DB_CONN_CNT, DBConnCNT}                %% db连接数
        , {?WATCHDOG_DB_OVERFLOW_CNT, DBOverFlowCNT}        %% db扩容数量

        , {?WATCHDOG_IS_OPEN_SMP, erlang:system_info(smp_support)}
        , {?WATCHDOG_SCHEDULER_ONLINE, erlang:system_info(schedulers_online)}
        , {?WATCHDOG_RUN_QUEUE_CNT, erlang:statistics(run_queue)}
        , {?WATCHDOG_MEMORY_TOTAL, byte_to_m(erlang:memory(total))}
        , {?WATCHDOG_MEMORY_PROCESSES, byte_to_m(erlang:memory(processes))}
        , {?WATCHDOG_MEMORY_ATOM, byte_to_m(erlang:memory(atom))}
        , {?WATCHDOG_MEMORY_BINARY, byte_to_m(erlang:memory(binary))}
        , {?WATCHDOG_MEMORY_CODE, byte_to_m(erlang:memory(code))}
        , {?WATCHDOG_MEMORY_ETS, byte_to_m(erlang:memory(ets))}
        , {?WATCHDOG_PROCESS_CNT, erlang:system_info(process_count)}    
        , {?WATCHDOG_ETS_CNT, length(ets:all())}         
        , {?WATCHDOG_PORT_CNT, erlang:system_info(port_count)}
        , {?WATCHDOG_PROCESS_LIMIT, erlang:system_info(process_limit)}    
        , {?WATCHDOG_ETS_LIMIT, erlang:system_info(ets_limit)}       
        , {?WATCHDOG_PORT_LIMIT, erlang:system_info(port_limit)}

        , {?WATCHDOG_CLUSTER_CENTER_NODE, config:get_cls_node()}
        , {?WATCHDOG_GAME_NODE_CONN_CNT, length(nodes()) + length(nodes(hidden))}
        % , {?WATCHDOG_ZONE_MGR_GROUP, []}      
        , {?WATCHDOG_ERLANG_VERSION, ulists:concat(["otp_", erlang:system_info(otp_release)])}        
    ].

%% 部分监控值需要重置
get_reset_list() ->
    NowTime = utime:unixtime(),
    [
        {?WATCHDOG_LOGIN_PLAYER_CNT, 0}                     %% 上线人数
        , {?WATCHDOG_LOGOUT_PLAYER_CNT, 0}                  %% 下线人数
        , {?WATCHDOD_NOW_SYNC_TIME, NowTime}                %% 当前状态同步时间
        , {?WATCHDOD_NEXT_SYNC_TIME,  NowTime + ?TICK_TIME} %% 下次状态同步时间
    ].

get_snapshot_ids() ->
    [
        ?WATCHDOD_SERVER_NODE                               %% 服务器节点
        , ?WATCHDOD_SERVER_STATUS                           %% 服务器状态
        , ?WATCHDOD_NOW_SYNC_TIME                           %% 当前状态同步时间
        , ?WATCHDOD_NEXT_SYNC_TIME                          %% 下次状态同步时间
        , ?WATCHDOG_CLUSTER_LINK_STATUS                     %% 跨服连接状态
        , ?WATCHDOG_MEMORY_TOTAL                            %% 内存total(M)
        , ?WATCHDOG_SCHEDULER_ONLINE                        %% 调度器数量
        , ?WATCHDOG_ONLINE_PLAYER_CNT                       %% 在线人数
        , ?WATCHDOG_ONLINE_OBJECT_CNT                       %% 场景对象数量
        , ?WATCHDOG_LOGIN_PLAYER_CNT                        %% 上线人数
        , ?WATCHDOG_LOGOUT_PLAYER_CNT                       %% 下线人数
        , ?WATCHDOD_OPENNING_ACT_LIST                       %% 当前活动列表
        , ?WATCHDOG_GAME_ERR_CNT                            %% 当前错误次数
        , ?WATCHDOG_GAME_ERR_OVERFLOW                       %% 错误日志是否超过阀值
        , ?WATCHDOG_GAME_ERR_RESUME_CNT                     %% 日志服务恢复次数
        , ?WATCHDOG_DB_CONN_CNT                             %% db连接数
        , ?WATCHDOG_DB_OVERFLOW_CNT                         %% db扩容数量
        , ?WATCHDOG_DB_GC_NUM                               %% db内存回收次数
    ].

get_top_n_process_list() ->
    TopTypeList = [                                         %% 占用内存、占用CPU前20进程 
        ?TOP_N_TYPE_MEMORY, ?TOP_N_TYPE_BINARY_MEMORY, ?TOP_N_TYPE_REDUCTIONS, ?TOP_N_TYPE_MSG_QUEUE_LEM
    ],      
    F = fun(TopType) -> {TopType, recon:proc_count(?TOP_N_NAME(TopType), ?TOP_N)} end,
    lists:map(F, TopTypeList).

byte_to_m(Bytes) -> 
    util:ceil(Bytes/(?ONE_KBYTE*?ONE_KBYTE)).

%% ---------------------------------------------------------------------------
%% @doc 系统初始化
-spec init() -> {ok, State} when
    State       :: #watchdog_state{}.
%% ---------------------------------------------------------------------------
init() ->
    InitList = get_init_list(),
    InfoList = get_info_list(),
    MonitorMap = to_monitor_item(InitList ++ InfoList, #{}),
    ServerType = config:get_cls_type(),
    IsTick = case {?IS_DEV_SERVER, ServerType} of {true, ?NODE_CENTER} -> 0; _ -> 1 end,
    {ok, #watchdog_state{monitor_map = MonitorMap, is_tick = IsTick}}.

%% ---------------------------------------------------------------------------
%% @doc tick超时，阶段监控item入库，并重置准备下移阶段监控
-spec tick(State) -> {ok, NewState} when
    State       :: #watchdog_state{},
    NewState    :: #watchdog_state{}.
%% ---------------------------------------------------------------------------
tick(State) ->
    #watchdog_state{monitor_map = MonitorMap} = State,
    InfoList = get_info_list(),
    SnapShotIds = get_snapshot_ids(),
    TopNProcessList = get_top_n_process_list(),
    NewMonitorMap = to_monitor_item(InfoList, MonitorMap),
    SnapShotList = to_monitor_item_snapshot(lists:reverse(SnapShotIds), NewMonitorMap, []),
    NewTopNProcessList = to_top_n_process(TopNProcessList, []),
    Fun = fun() -> 
            db_replace_serverdog(NewMonitorMap),
            db_insert_log_serverdog(SnapShotList),
            db_replace_top_n_processes(NewTopNProcessList),
            ok
    end,
    case lib_goods_util:transaction(Fun) of
        ok ->
            log_server_memory(NewMonitorMap),
            ResetList = get_reset_list(),
            LastMonitorMap = to_monitor_item(ResetList, NewMonitorMap),
            {ok, State#watchdog_state{monitor_map = LastMonitorMap}};
        Error ->
            ?ERR("tick error:~p~n", [Error]),
            {ok, State}
    end.

to_monitor_item([], Map) -> Map;
to_monitor_item([{Id, Value}|T], Map) ->
    NewMap = maps:put(Id, #monitor_item{id = Id, value = Value}, Map),
    to_monitor_item(T, NewMap).

to_monitor_item_snapshot([], _MonitorMap, List) -> List;
to_monitor_item_snapshot([Id|T], MonitorMap, List) ->
    case {maps:get(Id, MonitorMap, none), List} of
        {#monitor_item{value = Value}, []} -> 
            NewValue = to_snapshot_args(Id, Value),
            NewList = ulists:concat(["{", Id, ",", NewValue, "}"]),
            to_monitor_item_snapshot(T, MonitorMap, NewList);
        {#monitor_item{value = Value}, List} ->
            NewValue = to_snapshot_args(Id, Value),
            NewList = ulists:concat(["{", Id, ",", NewValue, "}", ",", List]),
            to_monitor_item_snapshot(T, MonitorMap, NewList);
        _ -> to_monitor_item_snapshot(T, MonitorMap, List)
    end.

%% 部分监控快照值格式需要转换
to_snapshot_args(Id, Value) 
    when Id == ?WATCHDOD_OPENNING_ACT_LIST->
    binary_to_list(list_to_binary(io_lib:format("\"~p\"", [Value])));
to_snapshot_args(_Id, Value) -> Value.

to_top_n_process([], AccList) -> AccList;
to_top_n_process([{TopType, ProcessList}|T], AccList) ->
    List = to_top_n_process_helper(TopType, ProcessList, 1, []),
    case AccList == [] of
        true -> to_top_n_process(T, List ++ AccList);
        false -> to_top_n_process(T, List ++ "," ++ AccList)
    end.

to_top_n_process_helper(_TopType, [], _Index, List) -> List;
to_top_n_process_helper(TopType, [{Pid, Attr, [CurrentFunction, InitialCall] }|T], Index, List) ->
    to_top_n_process_helper(TopType, [{Pid, Attr, [none, CurrentFunction, InitialCall] }|T], Index, List);
to_top_n_process_helper(TopType, [{Pid, Attr, [RegisteredName, CurrentFunction, InitialCall] }|T], Index, List) ->
    NewAttr = to_top_n_value(TopType, Attr),
    NewPid = binary_to_list(list_to_binary(io_lib:format("\"~p\"", [Pid]))),
    NewRegisteredName = binary_to_list(list_to_binary(io_lib:format("\"~p\"", [RegisteredName]))),
    NewCurrentFunction = binary_to_list(list_to_binary(io_lib:format("\"~p\"", [CurrentFunction]))),
    NewInitialCall = binary_to_list(list_to_binary(io_lib:format("\"~p\"", [InitialCall]))),
    ConcatList = ulists:concat(["(", Index, ",", TopType, ",", NewPid, ",", NewAttr, ",", NewRegisteredName, ",", 
                    NewCurrentFunction, ",", NewInitialCall, ")"]),    
    NewList = case List==[] of
        true -> ulists:concat([ConcatList, List]);
        false -> ulists:concat([ConcatList, ",", List])
    end,
    to_top_n_process_helper(TopType, T, Index+1, NewList).

%% 部分监控快照值格式需要转换
to_top_n_value(TopType, Attr) 
    when TopType == ?TOP_N_TYPE_MEMORY;
    TopType == ?TOP_N_TYPE_BINARY_MEMORY -> byte_to_m(Attr);
to_top_n_value(_, Attr) -> Attr.

%% ---------------------------------------------------------------------------
%% @doc 加入监控item
-spec add_monitor(State, CtrlType, Id, Value) -> {ok, NewState} when
    State       :: #watchdog_state{},   
    CtrlType    :: integer(),           %% 监控操作?CTRL_TYPE_ADD | ?CTRL_TYPE_SET
    Id          :: integer(),           %% 监控Id
    Value       :: term(),              %% 监控值
    NewState    :: #watchdog_state{}.   
%% ---------------------------------------------------------------------------
add_monitor(State, CtrlType, Id, Value) ->
    #watchdog_state{monitor_map = MonitorMap} = State,
    MonitorItem = maps:get(Id, MonitorMap, #monitor_item{id = Id, value = 0}),
    OldValue = MonitorItem#monitor_item.value,
    NewMonitorItem = case CtrlType of
        ?CTRL_TYPE_ADD -> MonitorItem#monitor_item{value = OldValue + Value};
        ?CTRL_TYPE_SET -> MonitorItem#monitor_item{value = Value};
        _ -> MonitorItem
    end,
    NewMonitorMap = maps:put(Id, NewMonitorItem, MonitorMap),
    {ok, State#watchdog_state{monitor_map = NewMonitorMap}}.

%% 加入监控item_list
add_monitor(State, ItemList) ->
    F = fun({CtrlType, Id, Value}, {ok, AccState}) ->
        add_monitor(AccState, CtrlType, Id, Value)
    end,
    lists:foldl(F, {ok, State}, ItemList).

%% 部分监控值格式需要转换
to_sql_args([], SqlList) -> SqlList;
to_sql_args([{Id, #monitor_item{value = Value}} |T], SqlList) 
    when Id == ?WATCHDOD_SERVER_VERSION;
    Id == ?WATCHDOD_SERVER_VERSION_TIME;
    Id == ?WATCHDOG_ERLANG_VERSION ->
    %% 将"xxx"转为 "\"xxx\""
    NewValue = binary_to_list(list_to_binary(io_lib:format("~p", [Value]))),
    NewSqlList = sql_args(Id, NewValue, SqlList),
    to_sql_args(T, NewSqlList);
to_sql_args([{Id, #monitor_item{value = Value}} |T], SqlList) 
    when Id == ?WATCHDOD_OPENNING_ACT_LIST ->
    %% 将[{}]转为 "\"[{}]\""
    NewValue = binary_to_list(list_to_binary(io_lib:format("\"~p\"", [Value]))),
    NewSqlList = sql_args(Id, NewValue, SqlList),
    to_sql_args(T, NewSqlList);
to_sql_args([{Id, #monitor_item{value = Value}} |T], SqlList) ->
    NewValue = util:term_to_bitstring(Value),
    NewSqlList = sql_args(Id, NewValue, SqlList),
    to_sql_args(T, NewSqlList).

sql_args(Id, Value, SqlList) ->
    case SqlList==[] of
        true -> ulists:concat(["(", Id, ",", Value, ")", SqlList]);
        false -> ulists:concat(["(", Id, ",", Value, ")", ",", SqlList])
    end.

%% ------------------------------- db 处理部分 --------------------------------

db_replace_serverdog(MonitorMap) ->
    SqlArgs = to_sql_args(maps:to_list(MonitorMap), []),
    Sql = ulists:concat([?SQL_REPLACE_INTO_SERVER_DOG, SqlArgs]),
    db:execute(Sql).

db_insert_log_serverdog(ValueList) ->
    Sql = io_lib:format(?SQL_INSERT_LOG_SERVER_DOG,  [utime:unixtime(), ValueList]),
    db:execute(Sql).

db_replace_top_n_processes(SqlArgs) ->
    Sql = ulists:concat([?SQL_REPLACE_INTO_TOP_N_PROCESSES, SqlArgs]),
    db:execute(Sql).

log_server_memory(MonitorMap) ->
    #monitor_item{value = MemoryTotal} = maps:get(?WATCHDOG_MEMORY_TOTAL, MonitorMap, #monitor_item{}),
    #monitor_item{value = MemoryProcesses} = maps:get(?WATCHDOG_MEMORY_PROCESSES, MonitorMap, #monitor_item{}),
    #monitor_item{value = MemoryAtom} = maps:get(?WATCHDOG_MEMORY_ATOM, MonitorMap, #monitor_item{}),
    #monitor_item{value = MemoryBinary} = maps:get(?WATCHDOG_MEMORY_BINARY, MonitorMap, #monitor_item{}),
    #monitor_item{value = MemoryCode} = maps:get(?WATCHDOG_MEMORY_CODE, MonitorMap, #monitor_item{}),
    #monitor_item{value = MemoryEts} = maps:get(?WATCHDOG_MEMORY_ETS, MonitorMap, #monitor_item{}),
    #monitor_item{value = ProcessCNT} = maps:get(?WATCHDOG_PROCESS_CNT, MonitorMap, #monitor_item{}),
    #monitor_item{value = EtsCNT} = maps:get(?WATCHDOG_ETS_CNT, MonitorMap, #monitor_item{}),
    #monitor_item{value = PortCNT} = maps:get(?WATCHDOG_PORT_CNT, MonitorMap, #monitor_item{}),
    lib_log_api:log_server_memory(MemoryTotal, MemoryProcesses, MemoryAtom, MemoryBinary, MemoryCode, MemoryEts, 
                ProcessCNT, EtsCNT, PortCNT),
    ok.
