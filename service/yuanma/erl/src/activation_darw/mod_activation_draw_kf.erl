% ---------------------------------------------------------------------------
%% @doc 小跨服记录进程 
%% @author xlh
%% @since  2019-10-09 
%% ---------------------------------------------------------------------------
-module(mod_activation_draw_kf).

-compile(export_all).

-behaviour(gen_server).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% API
-export([
        start_link/0
        ,call/1                     %% call本进程
        ,cast/1                     %% cast本进程
        ,info/1                     %% 给进程发送消息
        ,load_data/0                %% 加载数据库数据
        ,cast_center/1
        ,call_center/1
    ]).

-compile(export_all).

-include("common.hrl").
-include("custom_act.hrl").
-define(CYCLE_SAVE_TIME, 10*60*1000).%(10 * 60 * 1000)). %% 保存时间

%% ----------------------------------------------------------------------------
%% ----------------------------------------------------------------------------
%% 注意事项:本记录活动结束要通知清理
%% ----------------------------------------------------------------------------
%% ----------------------------------------------------------------------------

%% ----------------------------------------------------------------------------
%% 配置和记录
%% ----------------------------------------------------------------------------

%% 日志##会直接存数据库,只能往下加字段
-record(act_log, {
        role_id = 0             %% 玩家id
        , name = ""             %% 玩家名字
        , reward_list = []      %% 奖励列表
        , server_num = 0        %% 服数
    }).

%% 记录
-record(act_record, {
        key = {0, 0, 0}            %% {主类型, 次类型}
        , log_list = []         %% 日志列表## #act_log{}
    }).

%% 进程#state{}
-record(state, {
        need_save_map = #{}     %% 需要保存到数据库的转盘数据Key##这个是定时存数据库,如果要实时存数据库就要存记录就存数据库zoneid => [{Type,Subtype}]
        ,save_timer = 0         %% 定时保存数据定时器Ref
        ,record_map = #{}       %% 数据 Key:{ZoneId, Type, SubType},#act_record{}
        ,zone_map = #{}         %% zoneid => [server_id]
        ,server_info = []
    }).

%% 数据库
-define(sql_custom_act_record_select, <<"SELECT zone, type, subtype, log_list FROM custom_act_kf_record">>).
-define(sql_custom_act_record_replace_batch, "REPLACE INTO custom_act_kf_record(zone, type, subtype, log_list) VALUES ").
-define(sql_custom_act_record_delete, <<"DELETE FROM custom_act_kf_record WHERE zone = ~p and type = ~p and subtype = ~p">>).

%% 获得日志的长度
get_log_len(_Type, _SubType) -> 
    #custom_act_cfg{condition = TypeCondition} = lib_custom_act_util:get_act_cfg_info(_Type, _SubType),
    case lists:keyfind(log_length, 1, TypeCondition) of
        {_, Length} when is_integer(Length) -> Length;
        _ -> 20
    end.

%% ----------------------------------------------------------------------------
%% 功能
%% ----------------------------------------------------------------------------

%%本地->跨服中心 
cast_center(Msg)->
    mod_clusters_node:apply_cast(?MODULE, cast_mgr, Msg).
call_center(Msg)->
    mod_clusters_node:apply_call(?MODULE, call_mgr, Msg).

%%跨服中心分发到管理进程
call_mgr(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mgr(Msg) ->
    gen_server:cast(?MODULE, Msg).

update_zone_map(ServerInfo) ->
    gen_server:cast(?MODULE, {update_zone_map, ServerInfo}).

zone_change(ServerId, OldZone, NewZone) ->
    gen_server:cast(?MODULE, {zone_change, ServerId, OldZone, NewZone}).

server_info_chage(ServerId, ChangeList) ->
    gen_server:cast(?MODULE, {server_info_chage, ServerId, ChangeList}).

call(Msg) ->
    try gen_server:call(?MODULE, Msg) of
    Reply -> Reply
    catch _A:_B ->
        ?ERR("~w call:~w error: ~w", [?MODULE, Msg, {_A, _B}]),
        {error, _B}
    end.

cast(Msg) ->
    gen_server:cast(?MODULE, Msg).

info(Msg) ->
    erlang:send(?MODULE, Msg).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    State = load_data(),
    NewState = cycle_save(State),
    % ?PRINT("=========== ~n",[]),
    mod_zone_mgr:activation_draw_init(),
    {ok, NewState}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

% %% 发送记录
handle_cast({send_record_info, ServerId, Type, SubType}, State) ->
    #state{record_map = RecordMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    Key = {ZoneId, Type, SubType},
    #act_record{log_list = LogList} = maps:get(Key, RecordMap, #act_record{key = Key}),
    send_record_info(LogList, [ServerId], Type, SubType),
    {noreply, State};

%% 保存并通知[默认写数据库:能不写最好, 由 #state.need_save_map 控制]
handle_cast({save_log_and_notice, ServerId, ServerNum, RoleId, Type, SubType, Name, RewardList}, State) ->
    #state{record_map = RecordMap, need_save_map = NeedSaveMap, zone_map = ZoneMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    SaveList = maps:get(ZoneId, NeedSaveMap, []),
    NewSaveList = [{Type, SubType}|lists:delete({Type, SubType}, SaveList)],
    NewMap = maps:put(ZoneId, NewSaveList, NeedSaveMap),
    Key = {ZoneId, Type, SubType},
    #act_record{log_list = LogList} = ActRecord = maps:get(Key, RecordMap, #act_record{key = Key}),
    LogLen = get_log_len(Type, SubType),
    Log = #act_log{role_id = RoleId, name = Name, reward_list = RewardList, server_num = ServerNum},
    NewLogList = lists:sublist([Log|LogList], LogLen),
    NewActRecord = ActRecord#act_record{log_list = NewLogList},
    NewRecordMap = maps:put(Key, NewActRecord, RecordMap),
    % 默认写数据库:能不写最好
    Newstate = State#state{record_map = NewRecordMap, need_save_map = NewMap},
    ServerIdList = maps:get(Key, ZoneMap, []),
    send_record_info(NewLogList, ServerIdList, Type, SubType),
    {noreply, Newstate};

%% 清理
handle_cast({remove_log, ServerId, Type, SubType}, State) ->
    #state{record_map = RecordMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    NewRecordMap = maps:remove({ZoneId, Type, SubType}, RecordMap),
    Newstate = State#state{record_map = NewRecordMap},
    if
        NewRecordMap == RecordMap ->
            skip;
        true ->
            db_custom_act_record_delete(ZoneId, Type, SubType)
    end,
    % ?PRINT("Type:~p SubType:~p NewRecordMap:~p ~n", [Type, SubType, NewRecordMap]),
    {noreply, Newstate};

handle_cast({update_zone_map, ServerInfo}, State) ->
    TypeList = [?CUSTOM_ACT_TYPE_ACTIVATION, ?CUSTOM_ACT_TYPE_RECHARGE],
    F1 = fun(Type, Map) ->
        SubTypeList = lib_custom_act_util:get_subtype_list(Type),
        Fun = fun(SubType, Acc) ->
            #custom_act_cfg{opday_lim = [{Min, Max}]} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            calc_server_id_list(Min, Max, Type, SubType, ServerInfo, Acc)
        end,
        lists:foldl(Fun, Map, SubTypeList)
    end,
    ZoneMap = lists:foldl(F1, #{}, TypeList),
    % ?PRINT("ZoneMap:~p~n",[ZoneMap]),
    {noreply, State#state{zone_map = ZoneMap, server_info = ServerInfo}};

handle_cast({zone_change, ServerId, OldZone, NewZone}, State) ->
    #state{zone_map = ZoneMap} = State,
    TypeList = [?CUSTOM_ACT_TYPE_ACTIVATION, ?CUSTOM_ACT_TYPE_RECHARGE],
    F1 = fun(Type, Map) ->
        SubTypeList = lib_custom_act_util:get_subtype_list(Type),
        Fun = fun
            (SubType, Acc) when OldZone =/= 0 ->
                ServerIdList = maps:get({OldZone, Type, SubType}, Acc, []),
                NewList = lists:delete(ServerId, ServerIdList),
                NewAcc = maps:put({OldZone, Type, SubType}, NewList, Acc),
                ServerList = maps:get({NewZone, Type, SubType}, NewAcc, []),
                maps:put({NewZone, Type, SubType}, [ServerId|lists:delete(ServerId, ServerList)], NewAcc);
            (SubType, Acc) ->    
                ServerList = maps:get({NewZone, Type, SubType}, Acc, []),
                maps:put({NewZone, Type, SubType}, [ServerId|lists:delete(ServerId, ServerList)], Acc)
        end,
        lists:foldl(Fun, Map, SubTypeList)
    end,
    NewZoneMap = lists:foldl(F1, ZoneMap, TypeList),
    {noreply, State#state{zone_map = NewZoneMap}};

handle_cast({server_info_chage, ServerId, [{open_time, OpenTime}|_]}, State) ->
    #state{zone_map = ZoneMap, server_info = ServerInfo} = State,
    case lists:keyfind(ServerId, 1, ServerInfo) of
        {ServerId, ZoneId, _Optime, WorldLv, ServerNum, ServerName} ->
            NewServerInfo = lists:keystore(ServerId, 1, ServerInfo, {ServerId, ZoneId, OpenTime, WorldLv, ServerNum, ServerName});
        _ ->
            ZoneId = lib_clusters_center_api:get_zone(ServerId),
            NewServerInfo = ServerInfo
    end,
    TypeList = [?CUSTOM_ACT_TYPE_ACTIVATION, ?CUSTOM_ACT_TYPE_RECHARGE],
    F1 = fun(Type, Map) ->
        SubTypeList = lib_custom_act_util:get_subtype_list(Type),
        OpenDay = get_open_day(OpenTime),
        Fun = fun(SubType, TemMap) ->
            #custom_act_cfg{opday_lim = [{Min, Max}]} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            if
                OpenDay >= Min andalso Max >= OpenDay ->
                    ServerIdList = maps:get({ZoneId, Type, SubType}, TemMap, []),
                    case lists:member(ServerId, ServerIdList) of
                        false -> NewList = [ServerId|ServerIdList];
                        _ -> NewList = ServerIdList
                    end,
                    maps:put({ZoneId, Type, SubType}, NewList, TemMap);
                true ->
                    ServerIdList = maps:get({ZoneId, Type, SubType}, TemMap, []),
                    maps:put({ZoneId, Type, SubType}, lists:delete(ServerId, ServerIdList), TemMap)
            end
        end,
        lists:foldl(Fun, Map, SubTypeList)
    end,
    NewZoneMap = lists:foldl(F1, ZoneMap, TypeList),
    {noreply, State#state{zone_map = NewZoneMap, server_info = NewServerInfo}};

handle_cast({send_tv, Args, Type, SubType}, State) ->
    #state{zone_map = ZoneMap} = State,
    ZoneServerList = maps:to_list(ZoneMap),
    Fun = fun
        ({{_, TemType, TemSubType}, ServerIdList}, Acc) when Type == TemType andalso TemSubType == SubType ->
            % ?PRINT("ServerList:~p~n",[ServerIdList]),
            Acc ++ ServerIdList;
        ({_, _}, Acc) -> Acc
    end,
    ServerList = lists:foldl(Fun, [], ZoneServerList),
    NewList = ulists:removal_duplicate(ServerList),
    % ?PRINT("NewList:~p,ZoneServerList:~p,ZoneMap:~p,{Type, SubType}:~p~n",[NewList,ZoneServerList,ZoneMap, {Type, SubType}]),
    [mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV, Args)|| ServerId <- NewList],
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 定时回写数据到数据库
handle_info(cycle_save, State) ->
    Newstate = cycle_save(State),
    {noreply, Newstate};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    save(State),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ---------------------------------------------------------------------------
%% @doc 加载数据库数据 
-spec load_data() -> State when
    State      :: #state{}.
%% ---------------------------------------------------------------------------
load_data() ->
    DbDataList = db:get_all(?sql_custom_act_record_select),
    RecordMap = format_map(DbDataList, #{}),
    #state{record_map = RecordMap}.

format_map([], RecordMap) ->
    RecordMap;
format_map([ActRecordDb | T], RecordMap) ->
    [ZoneId, Type, SubType, LogListBin] = ActRecordDb,
    LogList = util:bitstring_to_term(LogListBin),
    Key = {ZoneId, Type, SubType},
    % 修正
    F = fun(Log, List) ->
        case Log of
            #act_log{} -> [Log|List];
            {act_log, Name, RewardList, ServerNum} ->
                [#act_log{name = Name, reward_list = RewardList, server_num = ServerNum}|List];
            _ -> List
        end
    end,
    NewLogList = lists:reverse(lists:foldl(F, [], LogList)),
    ActRecord = #act_record{key = Key, log_list = NewLogList},
    NewRecordMap = maps:put(Key, ActRecord, RecordMap),
    format_map(T, NewRecordMap).

%% ----------------------------------------------------------------------------
%% @doc 数据库存储
-spec save(State) -> ok when
    State        :: #state{}.
%% ----------------------------------------------------------------------------
save(State) ->
    #state{need_save_map = NeedSaveMap, record_map = RecordMap} = State,
    MapList = maps:to_list(NeedSaveMap),
    Fun = fun({ZoneId, NeedSaveList}) ->
        SaveList = calc_save_list(ZoneId, NeedSaveList, RecordMap, []),
        do_save(SaveList)
    end,
    lists:foreach(Fun, MapList),
    ok.

calc_save_list(_, [], _RecordMap, SaveList) -> SaveList;
calc_save_list(ZoneId, [{Type, SubType} | T], RecordMap, SaveList) ->
    NewSaveList = case maps:find({ZoneId, Type, SubType}, RecordMap) of
        error -> SaveList;
        {ok, #act_record{key = {ZoneId, Type, SubType}, log_list = LogList}} -> [{ZoneId, Type, SubType, util:term_to_string(LogList)}|SaveList]
    end,
    calc_save_list(ZoneId, T, RecordMap, NewSaveList).

do_save([]) -> ok;
do_save(SignList) -> 
    ValueSql = do_save_sql(SignList, "", 1),
    Sql = ?sql_custom_act_record_replace_batch ++ ValueSql,
    db:execute(Sql),
    ok.

do_save_sql([], TmpSql, _Index) -> TmpSql;
do_save_sql([{ZoneId, Type, SubType, LogList}|T], TmpSql, Index) ->
    TmpSql1 = case Index of
        1 -> io_lib:format("(~w, ~w, ~w, '~s') ", [ZoneId, Type, SubType, LogList]) ++ TmpSql;
        _ -> io_lib:format("(~w, ~w, ~w, '~s'), ", [ZoneId, Type, SubType, LogList]) ++ TmpSql
    end,
    do_save_sql(T, TmpSql1, Index+1).

%% 清理记录
db_custom_act_record_delete(ZoneId, Type, SubType) ->
    Sql = io_lib:format(?sql_custom_act_record_delete, [ZoneId, Type, SubType]),
    db:execute(Sql).

%% ---------------------------------------------------------------------------
%% @doc 定时回写数据 
-spec cycle_save(State) -> NewState when
    State       :: #state{},
    NewState    :: #state{}.
%% ---------------------------------------------------------------------------
cycle_save(State = #state{save_timer = SaveTimer}) ->
    save(State),
    NewSaveTimer = util:send_after(SaveTimer, ?CYCLE_SAVE_TIME, self(), cycle_save),
    State#state{need_save_map = #{}, save_timer = NewSaveTimer}.


%% ----------------------------------------------------------------------------
%% @doc 内部函数
%% ----------------------------------------------------------------------------

%% 发送记录
send_record_info(LogList, ServerIdList, Type, SubType)  ->
    F = fun(#act_log{role_id = RoleId, name = Name, reward_list = RewardList, server_num = ServerNum}) -> 
        RealName = uio:format("S{1}.{2}", [ServerNum, Name]),
        {RoleId, RealName, RewardList} 
    end,
    List = lists:map(F, LogList),
    % ?MYLOG("hjhcustom", "send_record_info List:~w ~n", [List]),
    % ?PRINT("RecordList:~p,ServerIdList:~p~n",[List, ServerIdList]),
    [mod_clusters_center:apply_cast(ServerId, mod_activation_draw, update_record, [Type, SubType, List])|| ServerId <- ServerIdList],
    ok.

%% 获取开服天数
get_open_day(OpenTime) ->
    Now = utime:unixtime(),
    Day = (Now - OpenTime) div 86400,
    Day + 1.

calc_server_id_list(MinDay, MaxDay, Type, SubType, ServerInfo, Map) ->
    Fun = fun({ServerId, ZoneId, Optime, _, _, _}, TemMap) ->
        OpenDay = get_open_day(Optime),
        if
            OpenDay >= MinDay andalso MaxDay >= OpenDay ->
                ServerIdList = maps:get({ZoneId, Type, SubType}, TemMap, []),
                case lists:member(ServerId, ServerIdList) of
                    false -> NewList = [ServerId|ServerIdList];
                    _ -> NewList = ServerIdList
                end,
                maps:put({ZoneId, Type, SubType}, NewList, TemMap);
            true ->
                TemMap
        end
    end,
    lists:foldl(Fun, Map, ServerInfo).