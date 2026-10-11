-module(mod_guild_daily).

-behaviour(gen_server).

-include("common.hrl").
-include("errcode.hrl").
-include("guild_daily.hrl").
-include("def_id_create.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([
        complete_task/5,
        info/5,
        recieve_reward/8,
        day_clear/0,
        gm_clear/1
    ]).

complete_task(TaskId, Guild, GuildName, RoleId, RoleName) ->
    gen_server:cast(?MODULE, {'complete_task', TaskId, Guild, GuildName, RoleId, RoleName}).

info(Guild, RoleId, DayGetNum, DayMaxNum, EnterTime) ->
    gen_server:cast(?MODULE, {'info', Guild, RoleId, DayGetNum, DayMaxNum, EnterTime}).

recieve_reward(AutoId, Guild, GuildName, RoleId, RoleName, CanGetNum, DayGetNum, EnterTime) ->
    gen_server:cast(?MODULE, {'recieve_reward', AutoId, Guild, GuildName, RoleId, RoleName, CanGetNum, DayGetNum, EnterTime}).

day_clear() ->
    gen_server:cast(?MODULE, {'day_clear'}).

gm_clear(Guild) ->
    gen_server:cast(?MODULE, {'gm_clear', Guild}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = init(),
    {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_cast({'complete_task', TaskId, Guild, GuildName, RoleId, RoleName}, State) ->
    #guild_daily_state{task = TaskMap, reward_status = GuildDailyMap, log = LogMap} = State,
    TaskList = maps:get(RoleId, TaskMap, []),
    case lists:keyfind(TaskId, #task_item.task_id, TaskList) of
        #task_item{num = Num} -> Num;
        _ -> Num = 0
    end,
    ?PRINT("TaskId:~p~n",[TaskId]),
    case data_guild_daily:get_guild_daily_cfg(TaskId) of
        #base_guild_daily{persist = Persist, max_num = MaxNum} when is_integer(Persist) andalso Persist > 0 andalso Num < MaxNum -> 
            RewardInfoList = maps:get(Guild, GuildDailyMap, []),
            AutoId = mod_id_create:get_new_id(?GUILD_DAILY_ID_CREATE),
            Now = utime:unixtime(),
            Ref = util:send_after(undefined, Persist*3600*1000, self(), {'time_out', Guild, AutoId}),
            db:execute(io_lib:format(?UPDATE_GUILD_DAILY, [AutoId, Guild, TaskId, RoleId, RoleName, Now])),
            Info = #reward_info{id = AutoId, task_id = TaskId, bl = RoleId, bl_name = RoleName, time = Now,
                end_ref = Ref, record = []},
            NewGuildDailyMap = maps:put(Guild, [Info|RewardInfoList], GuildDailyMap),
            db:execute(io_lib:format(?UPDATE_GUILD_TASK, [RoleId, TaskId, Num+1, Now])),
            NewTaskList = lists:keystore(TaskId, #task_item.task_id, TaskList, 
                #task_item{task_id = TaskId, num = Num+1, stime = Now}),
            NewTaskMap = maps:put(RoleId, NewTaskList, TaskMap),

            RecordList = maps:get(Guild, LogMap, []),
            Log = #send_log{task_id = TaskId, role_id = RoleId, role_name = RoleName, time = Now},
            NRecordList = [Log|RecordList],
            NewRecordList = lists:sublist(NRecordList, ?RECORD_LENGTH),
            db:execute(io_lib:format(?UPDATE_GUILD_RECORD, [Guild, util:term_to_string(NewRecordList)])),
            NewLogMap = maps:put(Guild, NewRecordList, LogMap),

            lib_log_api:log_guild_daily_send(Guild, GuildName, RoleId, RoleName, TaskId, AutoId, Num+1),

            TaskInfoList = [{TaskId, Num+1}],
            SendList = [{AutoId, RoleName, RoleId, TaskId, 0, [], Now}],
            SendLogL = [{RoleName, RoleId, TaskId, Now}],
            {ok, Bin} = pt_403:write(40303, [SendList, SendLogL]),
            lib_server_send:send_to_all(guild, Guild, Bin),

            {ok, Bin1} = pt_403:write(40305, [TaskInfoList]),
            lib_server_send:send_to_uid(RoleId, Bin1),

            NewState = State#guild_daily_state{task = NewTaskMap, reward_status = NewGuildDailyMap, log = NewLogMap};
        _ ->
            NewState = State
    end,
    % lib_server_send:send_to_all(guild, Guild, Bin),
    {noreply, NewState};

do_handle_cast({'recieve_reward', 0, Guild, GuildName, RoleId, RoleName, CanGetNum, DayGetNum, EnterTime}, State) ->
    #guild_daily_state{reward_status = GuildDailyMap} = State,
    RewardInfoList = maps:get(Guild, GuildDailyMap, []),
    % DayGetNum = mod_daily:get_count(RoleId, ?MOD_GUILD_DAILY, ?DAILY_GUILD_DAILY_REWARD),
    Fun = fun
        (#reward_info{id = AutoId, record = RecordList, task_id = TaskId, time = Time} = Info, {Acc, TemMap, Number, List}) when Number > 0 andalso Time > EnterTime ->
            case lists:keyfind(RoleId, 1, RecordList) of
                {_, _} ->
                    {Acc, TemMap, Number, List};
                _ ->
                    case data_guild_daily:get_guild_daily_cfg(TaskId) of
                        #base_guild_daily{reward = RewardPool} when is_list(RewardPool) ->
                            InfoList = maps:get(Guild, TemMap, []),
                            Reward = urand:rand_with_weight(RewardPool),
                            RewardL = [Reward],
                            % mod_daily:increment(RoleId, ?MOD_GUILD_DAILY, ?DAILY_GUILD_DAILY_REWARD),
                            % mod_daily:get_count(RoleId, ?MOD_GUILD_DAILY, ?DAILY_GUILD_DAILY_REWARD),
                            NewRecordList = lists:keystore(RoleId, 1, RecordList, {RoleId, RewardL}),
                            db:execute(io_lib:format(?UPDATE_GUILD_DAILY_RECIEVE, [AutoId, Guild, RoleId, util:term_to_string(RewardL), utime:unixtime()])),
                            NewInfoList = lists:keystore(AutoId, #reward_info.id, InfoList, Info#reward_info{record = NewRecordList}),
                            NewMap = maps:put(Guild, NewInfoList, TemMap),
                            lib_log_api:log_guild_daily_recieve(Guild, GuildName, RoleId, RoleName, TaskId, AutoId, RewardL),
                            {[{RoleId, RewardL}|Acc], NewMap, Number - 1, RewardL++List};
                        _ ->
                            {Acc, TemMap, Number, List}
                    end
            end;
        (_, {Acc, TemMap, Number, List}) ->
            {Acc, TemMap, Number, List}
    end,
    {SendList, NewGdMap, NewCanGetNum, RewardList} = lists:foldl(Fun, {[], GuildDailyMap, CanGetNum, []}, RewardInfoList),
    if
        SendList =/= [] ->
            mod_daily:set_count(RoleId, ?MOD_GUILD_DAILY, ?DAILY_GUILD_DAILY_REWARD, DayGetNum + CanGetNum - NewCanGetNum),
            lib_goods_api:send_reward_by_id(RewardList, guild_daily, RoleId),
            {ok, Bin} = pt_403:write(40302, [?SUCCESS, SendList]);
        true ->
            {ok, Bin} = pt_403:write(40302, [?ERRCODE(err403_has_recieved), []])
    end,
    lib_server_send:send_to_uid(RoleId, Bin),
    % ?MYLOG("xlh", "GuildDailyMap:~p~n NewGdMap:~p~n",[GuildDailyMap, NewGdMap]),
    NewState = State#guild_daily_state{reward_status = NewGdMap},
    {noreply, NewState};

do_handle_cast({'recieve_reward', AutoId, Guild, GuildName, RoleId, RoleName, _, _, EnterTime}, State) ->
    #guild_daily_state{reward_status = GuildDailyMap} = State,
    RewardInfoList = maps:get(Guild, GuildDailyMap, []),
    case lists:keyfind(AutoId, #reward_info.id, RewardInfoList) of
        #reward_info{record = RecordList, task_id = TaskId, time = Time} = Info when Time > EnterTime ->
            case lists:keyfind(RoleId, 1, RecordList) of
                {_, _} ->
                    NewState = State,
                    {ok, Bin} = pt_403:write(40302, [?ERRCODE(err403_has_recieved), []]);
                _ ->
                    case data_guild_daily:get_guild_daily_cfg(TaskId) of
                        #base_guild_daily{reward = RewardPool} when is_list(RewardPool) ->
                            Reward = urand:rand_with_weight(RewardPool),
                            RewardL = [Reward],
                            % mod_daily:DAILY_GUILD_DAILY_REWARD
                            mod_daily:increment(RoleId, ?MOD_GUILD_DAILY, ?DAILY_GUILD_DAILY_REWARD),
                            % mod_daily:get_count(RoleId, ?MOD_GUILD_DAILY, ?DAILY_GUILD_DAILY_REWARD),
                            NewRecordList = lists:keystore(RoleId, 1, RecordList, {RoleId, RewardL}),
                            db:execute(io_lib:format(?UPDATE_GUILD_DAILY_RECIEVE, [AutoId, Guild, RoleId, util:term_to_string(RewardL), utime:unixtime()])),
                            NewInfoList = lists:keystore(AutoId, #reward_info.id, RewardInfoList, Info#reward_info{record = NewRecordList}),
                            NewMap = maps:put(Guild, NewInfoList, GuildDailyMap),
                            lib_goods_api:send_reward_by_id(RewardL, guild_daily, RoleId),
                            lib_log_api:log_guild_daily_recieve(Guild, GuildName, RoleId, RoleName, TaskId, AutoId, RewardL),
                            {ok, Bin} = pt_403:write(40302, [?SUCCESS, [{AutoId, RewardL}]]),
                            NewState = State#guild_daily_state{reward_status = NewMap};
                        _ ->
                            {ok, Bin} = pt_403:write(40302, [?MISSING_CONFIG, []]),
                            NewState = State
                    end
            end;
        _ ->
            {ok, Bin} = pt_403:write(40302, [?ERRCODE(err403_has_recieved), []]),
            NewState = State
    end,
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

do_handle_cast({'info', Guild, RoleId, DayGetNum, DayMaxNum, EnterTime}, State) ->
    #guild_daily_state{task = TaskMap, reward_status = GuildDailyMap, log = LogMap} = State,
    TaskList = maps:get(RoleId, TaskMap, []),
    TaskInfoList = [{TaskId, Num} || #task_item{task_id = TaskId, num = Num} <- TaskList],
    
    RewardInfoList = maps:get(Guild, GuildDailyMap, []),
    SendList = [calc_send_list(AutoId, BlName, Bl, TaskId, Time, Record, RoleId) || 
        #reward_info{id = AutoId, task_id = TaskId, bl = Bl, bl_name = BlName, time = Time, record = Record} <- RewardInfoList, EnterTime < Time],

    LogList = maps:get(Guild, LogMap, []),
    SendLogL = [{RoleName, TemRoleId, TaskId, Time} ||
        #send_log{task_id = TaskId, role_id = TemRoleId, role_name = RoleName, time = Time} <- LogList],
    % ?PRINT("RewardInfoList:~p~n",[RewardInfoList]),
    % ?PRINT("DayGetNum:~p, DayMaxNum:~p, SendList~p~n, SendLogL:~p~n, TaskInfoList:~p~n",[DayGetNum, DayMaxNum, SendList, SendLogL, TaskInfoList]),
    {ok, Bin} = pt_403:write(40301, [DayGetNum, DayMaxNum, SendList, SendLogL, TaskInfoList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

do_handle_cast({'day_clear'}, State) ->
    db:execute(?TRUNCATE_GUILD_TASK),
    TaskInfoList = calc_default_task_info(),
    {ok, Bin1} = pt_403:write(40305, [TaskInfoList]),
    lib_server_send:send_to_all(Bin1),
    {noreply, State#guild_daily_state{task = #{}}};

do_handle_cast({'gm_clear', Guild}, State) ->
    #guild_daily_state{reward_status = GuildDailyMap} = State,
    RewardInfoList = maps:get(Guild, GuildDailyMap, []),
    Fun = fun(#reward_info{id = AutoId, end_ref = OldRef}, TemMap) ->
        util:cancel_timer(OldRef),
        InfoList = maps:get(Guild, TemMap, []),
        NewInfoList = lists:keydelete(AutoId, #reward_info.id, InfoList),
        db:execute(io_lib:format(?DELETE_GUILD_DAILY_RECIEVE, [AutoId])),
        db:execute(io_lib:format(?DELETE_GUILD_DAILY, [AutoId])),
        {ok, Bin} = pt_403:write(40304, [AutoId]),
        lib_server_send:send_to_all(guild, Guild, Bin),
        maps:put(Guild, NewInfoList, TemMap)
    end,
    NewMap = lists:foldl(Fun, GuildDailyMap, RewardInfoList),
    db:execute(?TRUNCATE_GUILD_TASK),
    TaskInfoList = calc_default_task_info(),
    {ok, Bin1} = pt_403:write(40305, [TaskInfoList]),
    lib_server_send:send_to_all(Bin1),
    {noreply, State#guild_daily_state{reward_status = NewMap, task = #{}}};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_call(_, State) ->
    {reply, ok, State}.

do_handle_info({'time_out', Guild, AutoId}, State) ->
    #guild_daily_state{reward_status = GuildDailyMap} = State,
    RewardInfoList = maps:get(Guild, GuildDailyMap, []),
    case lists:keyfind(AutoId, #reward_info.id, RewardInfoList) of
        #reward_info{end_ref = OldRef} ->
            util:cancel_timer(OldRef),
            NewInfoList = lists:keydelete(AutoId, #reward_info.id, RewardInfoList),
            db:execute(io_lib:format(?DELETE_GUILD_DAILY_RECIEVE, [AutoId])),
            db:execute(io_lib:format(?DELETE_GUILD_DAILY, [AutoId])),
            NewMap = maps:put(Guild, NewInfoList, GuildDailyMap),
            {ok, Bin} = pt_403:write(40304, [AutoId]),
            lib_server_send:send_to_all(guild, Guild, Bin),
            NewState = State#guild_daily_state{reward_status = NewMap};
        _ ->
            NewState = State
    end,
    {noreply, NewState};

do_handle_info(_Msg, State) ->
    {noreply, State}.

init() ->
    Now = utime:unixtime(),
    RecieveList = db:get_all(io_lib:format(?SELECT_GUILD_DAILY_RECIEVE, [])),
    F = fun([Id, Guild, RoleId, RewardStr, Stime], Acc) ->
        IsSameDay = utime_logic:is_logic_same_day(Stime, Now),
        if
            IsSameDay == true ->
                Reward = util:bitstring_to_term(RewardStr),
                case lists:keyfind({Id, Guild}, 1, Acc) of
                    {_, List} -> 
                        lists:keystore({Id, Guild}, 1, Acc, {{Id, Guild}, [{RoleId, Reward}|List]});
                    _ ->
                        lists:keystore({Id, Guild}, 1, Acc, {{Id, Guild}, [{RoleId, Reward}]})
                end;
            true ->
                db:execute(io_lib:format(?DELETE_GUILD_DAILY_RECIEVE, [Id])),
                Acc
        end
    end,
    RecieveL = lists:foldl(F, [], RecieveList),
    GuildDailyList = db:get_all(io_lib:format(?SELECT_GUILD_DAILY, [])),
    Fun = fun([Id, Guild, TaskId, Bl, BlName, Time], TemMap) ->
        case data_guild_daily:get_guild_daily_cfg(TaskId) of
            #base_guild_daily{persist = Persist} when Now - Time < Persist*3600 ->
                Ref = util:send_after(undefined, max((Time + Persist*3600 - Now), 1)*1000, self(), {'time_out', Guild, Id}),
                Record = case lists:keyfind({Id, Guild}, 1, RecieveL) of
                            {_, List} -> List;
                            _ -> []
                        end,
                Info = #reward_info{
                    id = Id,
                    task_id = TaskId,
                    bl = Bl,
                    bl_name = BlName,
                    time = Time,
                    end_ref = Ref,
                    record = Record},
                RewardInfoList = maps:get(Guild, TemMap, []),
                maps:put(Guild, [Info|RewardInfoList], TemMap);
            _ ->
                TemMap
        end
    end,
    GuildDailyMap = lists:foldl(Fun, #{}, GuildDailyList),

    RecordList = db:get_all(io_lib:format(?SELECT_GUILD_RECORD, [])),

    Fun1 = fun([Guild, LogListStr], {TemMap, AccClear}) ->
        case util:bitstring_to_term(LogListStr) of
            LogList when is_list(LogList) ->
                NAccClear = AccClear,
                LogList;
            _ ->
                NAccClear = [Guild|AccClear],
                LogList = []
        end,
        NTemMap = maps:put(Guild, LogList, TemMap),
        {NTemMap, NAccClear}
    end,
    {LogMap, ClearGuilds} = lists:foldl(Fun1, {#{}, []}, RecordList),
    %% 容错清理
    case ClearGuilds of
        [] -> skip;
        _ ->
            WhereIn = usql:condition({guild, in, ClearGuilds}),
            catch db:execute(io_lib:format("delete from guild_daily_record ~s", [WhereIn]))
    end,

    RoleTask = db:get_all(io_lib:format(?SELECT_GUILD_TASK, [])),
    Fun2 = fun([RoleId, TaskId, Num, Stime], TemMap) ->
        IsSameDay = utime_logic:is_logic_same_day(Stime, Now),
        if
            IsSameDay == true ->
                TaskList = maps:get(RoleId, TemMap, []),
                NewTaskList = lists:keystore(TaskId, #task_item.task_id, TaskList, 
                    #task_item{task_id = TaskId, num = Num, stime = Stime}),
                maps:put(RoleId, NewTaskList, TemMap);
            true ->
                db:execute(io_lib:format(?DELETE_GUILD_TASK, [RoleId])),
                TemMap
        end
    end,
    TaskMap = lists:foldl(Fun2, #{}, RoleTask),
    #guild_daily_state{task = TaskMap, reward_status = GuildDailyMap, log = LogMap}.

calc_send_list(AutoId, BlName, Bl, TaskId, Time, Record, RoleId) ->
    case lists:keyfind(RoleId, 1, Record) of
        {_, Reward} ->
            {AutoId, BlName, Bl, TaskId, 1, Reward, Time};
        _ ->
            {AutoId, BlName, Bl, TaskId, 0, [], Time}
    end.

calc_default_task_info() ->
    TaskIdL = data_guild_daily:get_all_task_id(),
    Fun = fun(TaskId, Acc) ->
        [{TaskId, 0}|Acc]
    end,
    lists:foldl(Fun, [], TaskIdL).