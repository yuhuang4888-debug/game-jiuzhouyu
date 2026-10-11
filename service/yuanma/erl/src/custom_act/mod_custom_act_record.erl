%% ---------------------------------------------------------------------------
%% @doc 记录进程 
%% @author hejiahua
%% @since  2017-04-18 
%% ---------------------------------------------------------------------------
-module(mod_custom_act_record).

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
    ]).

-compile(export_all).

-include("common.hrl").
-include("custom_act.hrl").
-define(CYCLE_SAVE_TIME, (10 * 60 * 1000)). %% 保存时间

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
        role_id = 0
        , name = ""               %% 玩家名字
        , reward_list = []      %% 奖励列表
    }).

%% 记录
-record(act_record, {
        key = {0, 0}            %% {主类型, 次类型}
        , log_list = []         %% 日志列表## #act_log{}
    }).

%% 记录
-record(role_record, {
        role_id = 0             %% 玩家id
        , log_list = []         %% 日志列表## #act_log{}
    }).

%% 进程#state{}
-record(state, {
        need_save_list = []     %% 需要保存到数据库的转盘数据Key##这个是定时存数据库,如果要实时存数据库就要存记录就存数据库
        ,save_timer = 0         %% 定时保存数据定时器Ref
        ,record_map = #{}       %% 数据 Key:{Type, SubType}, #act_record{}
        ,role_record = #{}      %% 玩家抽奖记录 Key:{Type, SubType}, [#role_record{}]
    }).

%% 数据库
-define(sql_custom_act_record_select, <<"SELECT type, subtype, log_list FROM custom_act_record">>).
-define(sql_custom_act_record_replace_batch, "REPLACE INTO custom_act_record(type, subtype, log_list) VALUES ").
-define(sql_custom_act_record_delete, <<"DELETE FROM custom_act_record WHERE type = ~p and subtype = ~p">>).

%% 数据库
-define(sql_custom_act_role_record_select, <<"SELECT type, subtype, role_id, log_list FROM custom_act_role_record">>).
-define(sql_custom_act_role_record_replace_batch, "REPLACE INTO custom_act_role_record(type, subtype, role_id, log_list) VALUES ").
-define(sql_custom_act_role_record_delete, <<"DELETE FROM custom_act_role_record WHERE type = ~p and subtype = ~p">>).

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
    {ok, NewState}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% 发送记录
handle_cast({send_record_info, RoleId, Type, SubType}, State) ->
    send_record_info(State, RoleId, Type, SubType),
    {noreply, State};

%% 全服记录
%% 保存并通知[默认写数据库:能不写最好, 由 #state.need_save_list 控制]
handle_cast({save_log, Type, SubType, Name, RewardList}, State) ->
    #state{record_map = RecordMap, need_save_list = NeedSaveL} = State,
    Key = {Type, SubType},
    #act_record{log_list = LogList} = ActRecord = maps:get(Key, RecordMap, #act_record{key = Key}),
    LogLen = get_log_len(Type, SubType),
    Log = #act_log{name = Name, reward_list = RewardList},
    NewLogList = lists:sublist([Log|LogList], LogLen),
    % 默认写数据库:能不写最好
    NewActRecord = ActRecord#act_record{log_list = NewLogList},
    NewRecordMap = maps:put(Key, NewActRecord, RecordMap),
    Newstate = State#state{record_map = NewRecordMap, need_save_list = [Key | lists:delete(Key, NeedSaveL)]},
    {noreply, Newstate};

%% 全服记录
%% 保存并通知[默认写数据库:能不写最好, 由 #state.need_save_list 控制]
handle_cast({save_log_and_notice, RoleId, Type, SubType, Name, RewardList}, State) ->
    #state{record_map = RecordMap, need_save_list = NeedSaveL} = State,
    Key = {Type, SubType},
    #act_record{log_list = LogList} = ActRecord = maps:get(Key, RecordMap, #act_record{key = Key}),
    LogLen = get_log_len(Type, SubType),
    Log = #act_log{role_id = RoleId, name = Name, reward_list = RewardList},
    NewLogList = lists:sublist([Log|LogList], LogLen),
    NewActRecord = ActRecord#act_record{log_list = NewLogList},
    NewRecordMap = maps:put(Key, NewActRecord, RecordMap),
    % 默认写数据库:能不写最好
    Newstate = State#state{
        record_map = NewRecordMap, 
        need_save_list = [Key | lists:delete(Key, NeedSaveL)]
    },
    send_record_info(Newstate, RoleId, Type, SubType),
    {noreply, Newstate};

%% 個人记录
%% 保存并通知[默认写数据库:能不写最好, 由 #state.need_save_list 控制]
handle_cast({save_role_log_and_notice, RoleId, Type, SubType, Name, RewardList}, State) ->
    #state{role_record = RoleRecordMap, need_save_list = NeedSaveL} = State,
    Key = {Type, SubType},
    RoleRecordList = maps:get(Key, RoleRecordMap, []),
    case lists:keyfind(RoleId, #role_record.role_id, RoleRecordList) of
        #role_record{log_list = RoleLogList} = OldRoleRecord ->skip;
        _ -> RoleLogList = [], OldRoleRecord = #role_record{role_id = RoleId}
    end,
    LogLen = get_log_len(Type, SubType),
    Log = #act_log{role_id = RoleId, name = Name, reward_list = RewardList},
    NewRoleLogList = lists:sublist([Log|RoleLogList], LogLen),
    NewRoleRecord = OldRoleRecord#role_record{log_list = NewRoleLogList},
    NewRoleRecordList = lists:keystore(RoleId, #role_record.role_id, RoleRecordList, NewRoleRecord),
    NewRoleRecordMap = maps:put(Key, NewRoleRecordList, RoleRecordMap),
    % 默认写数据库:能不写最好
    Newstate = State#state{
        role_record = NewRoleRecordMap, 
        need_save_list = [Key | lists:delete(Key, NeedSaveL)]
    },
    send_record_info(Newstate, RoleId, Type, SubType),
    {noreply, Newstate};

%% 包含全服以及個人记录
%% 保存并通知[默认写数据库:能不写最好, 由 #state.need_save_list 控制]
handle_cast({save_all_log_and_notice, RoleId, Type, SubType, Name, RewardList}, State) ->
    #state{record_map = RecordMap, need_save_list = NeedSaveL, role_record = RoleRecordMap} = State,
    Key = {Type, SubType},
    #act_record{log_list = LogList} = ActRecord = maps:get(Key, RecordMap, #act_record{key = Key}),
    RoleRecordList = maps:get(Key, RoleRecordMap, []),
    case lists:keyfind(RoleId, #role_record.role_id, RoleRecordList) of
        #role_record{log_list = RoleLogList} = OldRoleRecord ->skip;
        _ -> RoleLogList = [], OldRoleRecord = #role_record{role_id = RoleId}
    end,
    LogLen = get_log_len(Type, SubType),
    Log = #act_log{role_id = RoleId, name = Name, reward_list = RewardList},
    NewLogList = lists:sublist([Log|LogList], LogLen),
    NewRoleLogList = lists:sublist([Log|RoleLogList], LogLen),
    NewActRecord = ActRecord#act_record{log_list = NewLogList},
    NewRoleRecord = OldRoleRecord#role_record{log_list = NewRoleLogList},
    NewRoleRecordList = lists:keystore(RoleId, #role_record.role_id, RoleRecordList, NewRoleRecord),
    NewRecordMap = maps:put(Key, NewActRecord, RecordMap),
    NewRoleRecordMap = maps:put(Key, NewRoleRecordList, RoleRecordMap),
    % 默认写数据库:能不写最好
    Newstate = State#state{
        record_map = NewRecordMap, 
        need_save_list = [Key | lists:delete(Key, NeedSaveL)], 
        role_record = NewRoleRecordMap
    },
    send_record_info(Newstate, RoleId, Type, SubType),
    {noreply, Newstate};

%% 清理
handle_cast({remove_log, Type, SubType}, State) ->
    #state{record_map = RecordMap, role_record = RoleRecordMap} = State,
    NewRecordMap = maps:remove({Type, SubType}, RecordMap),
    NewRoleRecordMap = maps:remove({Type, SubType}, RoleRecordMap),
    Newstate = State#state{record_map = NewRecordMap, role_record = NewRoleRecordMap},
    db_custom_act_record_delete(Type, SubType),
    % ?PRINT("Type:~p SubType:~p NewRecordMap:~p ~n", [Type, SubType, NewRecordMap]),
    {noreply, Newstate};

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
    RoleDbData = db:get_all(?sql_custom_act_role_record_select),
    RecordMap = format_map(DbDataList, #{}),
    RoleRecordMap = format_map(RoleDbData, #{}),
    #state{record_map = RecordMap, role_record = RoleRecordMap}.

format_map([], RecordMap) ->
    RecordMap;
format_map([[Type, SubType, LogListBin] | T], RecordMap) ->
    NewLogList = format_map_help(LogListBin),
    Key = {Type, SubType},
    ActRecord = #act_record{key = Key, log_list = NewLogList},
    NewRecordMap = maps:put(Key, ActRecord, RecordMap),
    format_map(T, NewRecordMap);
format_map([[Type, SubType, RoleId, LogListBin] | T], RecordMap) ->
    NewLogList = format_map_help(LogListBin),
    Key = {Type, SubType},
    RoleRecordList = maps:get(Key, RecordMap, []),
    RoleRecord = #role_record{role_id = RoleId, log_list = NewLogList},
    NewRecordList = lists:keystore(RoleId, #role_record.role_id, RoleRecordList, RoleRecord),
    NewRecordMap = maps:put(Key, NewRecordList, RecordMap),
    format_map(T, NewRecordMap).

format_map_help(LogListBin) ->
    case util:bitstring_to_term(LogListBin) of
        undefined -> LogList = [];
        LogList -> ok
    end,
    % 修正
    F = fun(Log, List) ->
        case Log of
            #act_log{} -> [Log|List];
            {act_log, Name, RewardList} ->
                [#act_log{name = Name, reward_list = RewardList}|List];
            _ -> List
        end
    end,
    lists:reverse(lists:foldl(F, [], LogList)).

%% ----------------------------------------------------------------------------
%% @doc 数据库存储
-spec save(State) -> ok when
    State        :: #state{}.
%% ----------------------------------------------------------------------------
save(#state{need_save_list = []}) -> ok;
save(State) ->
    #state{need_save_list = NeedSaveList, record_map = RecordMap, role_record = RoleRecordMap} = State,
    {SaveList, SaveRoleRecordL} = calc_save_list(NeedSaveList, RecordMap, RoleRecordMap, [], []),
    do_save(SaveList),
    do_save_role(SaveRoleRecordL),
    ok.

calc_save_list([], _RecordMap, _RoleRecordMap, SaveList, SaveRoleRecordL) -> 
    {SaveList, SaveRoleRecordL};
calc_save_list([Key | T], RecordMap, RoleRecordMap, SaveList, SaveRoleRecordL) ->
    NewSaveList = case maps:find(Key, RecordMap) of
        error -> SaveList;
        {ok, #act_record{key = {Type, SubType}, log_list = LogList}} -> [{Type, SubType, util:term_to_string(LogList)}|SaveList]
    end,
    NewSaveRoleRecordL = 
    case maps:find(Key, RoleRecordMap) of
        error -> SaveRoleRecordL;
        {ok, RoleRecordList} -> 
             {Type1, SubType1} = Key,            
            [{Type1, SubType1, RoleId, util:term_to_string(LogList)}||#role_record{role_id = RoleId, log_list = LogList} <- RoleRecordList]
    end,
    calc_save_list(T, RecordMap, RoleRecordMap, NewSaveList, NewSaveRoleRecordL).

do_save([]) -> ok;
do_save(SignList) -> 
    ValueSql = do_save_sql(SignList, "", 1),
    Sql = ?sql_custom_act_record_replace_batch ++ ValueSql,
    db:execute(Sql),
    ok.

do_save_role([]) -> ok;
do_save_role(SignList) -> 
    ValueSql = do_save_sql(SignList, "", 1),
    Sql = ?sql_custom_act_role_record_replace_batch ++ ValueSql,
    db:execute(Sql),
    ok.

do_save_sql([], TmpSql, _Index) -> TmpSql;
do_save_sql([{Type, SubType, LogList}|T], TmpSql, Index) ->
    TmpSql1 = case Index of
        1 -> io_lib:format("(~w, ~w, '~s') ", [Type, SubType, LogList]) ++ TmpSql;
        _ -> io_lib:format("(~w, ~w, '~s'), ", [Type, SubType, LogList]) ++ TmpSql
    end,
    do_save_sql(T, TmpSql1, Index+1);
do_save_sql([{Type, SubType, RoleId, LogList}|T], TmpSql, Index) ->
    TmpSql1 = case Index of
        1 -> io_lib:format("(~w, ~w, ~w, '~s') ", [Type, SubType, RoleId, LogList]) ++ TmpSql;
        _ -> io_lib:format("(~w, ~w, ~w, '~s'), ", [Type, SubType, RoleId, LogList]) ++ TmpSql
    end,
    do_save_sql(T, TmpSql1, Index+1).

%% 清理记录
db_custom_act_record_delete(Type, SubType) ->
    Sql = io_lib:format(?sql_custom_act_record_delete, [Type, SubType]),
    Sql1 = io_lib:format(?sql_custom_act_role_record_delete, [Type, SubType]),
    db:execute(Sql),
    db:execute(Sql1).

%% ---------------------------------------------------------------------------
%% @doc 定时回写数据 
-spec cycle_save(State) -> NewState when
    State       :: #state{},
    NewState    :: #state{}.
%% ---------------------------------------------------------------------------
cycle_save(State = #state{save_timer = SaveTimer}) ->
    save(State),
    NewSaveTimer = util:send_after(SaveTimer, ?CYCLE_SAVE_TIME, self(), cycle_save),
    State#state{need_save_list = [], save_timer = NewSaveTimer}.


%% ----------------------------------------------------------------------------
%% @doc 内部函数
%% ----------------------------------------------------------------------------

%% 发送记录
send_record_info(_, RoleId, Type, SubType) when Type == ?CUSTOM_ACT_TYPE_LUCKEY_WHEEL ->
    mod_luckey_wheel_local:send_record(Type, SubType, RoleId);
send_record_info(State, RoleId, Type, SubType)  ->
    #state{record_map = RecordMap, role_record = RoleRecordMap} = State,
    #act_record{log_list = LogList} = maps:get({Type, SubType}, RecordMap, #act_record{}),
    F = fun(#act_log{role_id = RoleId1, name = Name, reward_list = RewardList}) -> {RoleId1, Name, RewardList} end,
    List = lists:map(F, LogList),
    RoleRecordList = maps:get({Type, SubType}, RoleRecordMap, []),
    case lists:keyfind(RoleId, #role_record.role_id, RoleRecordList) of
        #role_record{log_list = RoleLogList} ->
            List1 = lists:map(F, RoleLogList);
        _ -> List1 = []
    end,
    % ?MYLOG("hjhcustom", "send_record_info List:~w  ~p~n", [List, List1]),
    {ok, BinData} = pt_331:write(33197, [Type, SubType, List, List1]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.