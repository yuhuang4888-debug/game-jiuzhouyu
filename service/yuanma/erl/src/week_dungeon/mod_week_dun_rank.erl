% %% ---------------------------------------------------------------------------
% %% @doc mod_week_dun_rank
% %% @author 
% %% @since  
% %% @deprecated  
% %% ---------------------------------------------------------------------------
-module(mod_week_dun_rank).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("week_dungeon.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
%%-----------------------------

refresh_rank(DunId, Key, PassTime, WDunRankRoleList) ->
    gen_server:cast(?MODULE, {refresh_rank, DunId, Key, PassTime, WDunRankRoleList}).

send_rank_list(Msg) ->
    gen_server:cast(?MODULE, {send_rank_list, Msg}).


midnight_reset() ->
    case utime:day_of_week() of 
        1 ->
            gen_server:cast(?MODULE, {midnight_reset});
        _ ->
            skip
    end.

gm_midnight_reset() ->
    gen_server:cast(?MODULE, {midnight_reset}).

rename(Msg) ->
    gen_server:cast(?MODULE, {rename, Msg}).

reload() ->
    gen_server:cast(?MODULE, {reload}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([]) ->
    State = init_do(),
    {ok, State}.

%% ====================
%% hanle_call
%% ==================== 


do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 
do_handle_cast({reload}, _State) ->
    NewState = init_do(),
    ?PRINT("reload State :~p~n", [NewState]),
    {noreply, NewState};

do_handle_cast({refresh_rank, DunId, Key, PassTime, WDunRankRoleList}, State) ->
    ?PRINT("refresh_rank start :~p~n", [{DunId, Key, PassTime}]),
    #week_dun_state{rank_list = RankList, rank_limit = RankLimit, role_map = RoleMap} = State,
    NewRoleMap = update_rank_role(WDunRankRoleList, RoleMap),
    {_, LimitVal} = ulists:keyfind(DunId, 1, RankLimit, {DunId, 99999}),
    {_, DunRankList} = ulists:keyfind(DunId, 1, RankList, {DunId, []}),
    NowTime = utime:unixtime(),
    case lists:keytake(Key, #week_dun_rank.key, DunRankList) of 
        false ->
            NewWeekDunRank = #week_dun_rank{key = Key, pass_time = PassTime, time = NowTime},
            case PassTime < LimitVal of 
                true -> %% 重刷排名
                    NeedRefresh = true, NeedDb = true,
                    NewDunRankList = [NewWeekDunRank|DunRankList];
                _ -> %% 不刷排名，放到列表最后
                    NeedRefresh = false, NeedDb = true,
                    NewDunRankList = DunRankList ++ [NewWeekDunRank]
            end;
        {value, OldWeekDunRank, LeftList} ->
            OldPassTime = OldWeekDunRank#week_dun_rank.pass_time,
            if
                OldPassTime > PassTime andalso PassTime < LimitVal -> %% 新记录，并且是进入排名的
                    NeedRefresh = true, NeedDb = true,
                    NewWeekDunRank = OldWeekDunRank#week_dun_rank{pass_time = PassTime, time = NowTime},
                    NewDunRankList = [NewWeekDunRank|LeftList];
                OldPassTime > PassTime -> %% 新记录，但是还没进入排名
                    NeedRefresh = false, NeedDb = true,
                    NewWeekDunRank = OldWeekDunRank#week_dun_rank{pass_time = PassTime, time = NowTime, rank = 0},
                    NewDunRankList = LeftList ++ [NewWeekDunRank];
                true -> %% 没有刷新记录，不处理
                    NeedRefresh = false, NeedDb = false,
                    NewWeekDunRank = none,
                    NewDunRankList = DunRankList
            end
    end,
    ?PRINT("refresh_rank NeedDb NeedRefresh :~p~n", [{NeedDb, NeedRefresh}]),
    case NeedDb of 
        true -> 
            db_replace_week_dun_rank(DunId, NewWeekDunRank);
        _ -> skip
    end,
    case NeedRefresh of 
        true ->
            {LastDunRankList, LastLimitVal} = refresh_rank_do(NewDunRankList);
        _ ->
            LastDunRankList = NewDunRankList, LastLimitVal = LimitVal
    end,
    NewRankList = lists:keystore(DunId, 1, RankList, {DunId, LastDunRankList}),
    NewRankLimit = lists:keystore(DunId, 1, RankLimit, {DunId, LastLimitVal}),
    NewState = State#week_dun_state{rank_list = NewRankList, rank_limit = NewRankLimit, role_map = NewRoleMap},
    ?PRINT("refresh_rank NewRankList :~p~n", [NewRankList]),
    ?PRINT("refresh_rank NewRankLimit :~p~n", [NewRankLimit]),
    ?PRINT("refresh_rank end #################### ~n", []),
    {noreply, NewState};

do_handle_cast({send_rank_list, [TeamDunId, Rank1, Rank2, RoleId, Sid, Node]}, State) ->
    #week_dun_state{role_map = RoleMap, rank_list = RankList} = State,
    {_, DunRankList} = ulists:keyfind(TeamDunId, 1, RankList, {TeamDunId, []}),
    {SelfRank, SelfPassTime} = get_self_rank_info(DunRankList, RoleId),
    AreaRankList = get_area_rank_list(DunRankList, Rank1, Rank2, []),
    SendList = lists:foldl(fun(WeekDunRank, List) ->
        #week_dun_rank{key = Key, pass_time = PassTime, time = Time, rank = Rank} = WeekDunRank,
        RoleList = [begin
            #week_dun_rank_role{role_name = RoleName, server_id = ServerId, server_num = ServerNum} = maps:get(RoleId1, RoleMap, #week_dun_rank_role{}),
            {RoleId1, RoleName, ServerId, ServerNum}
        end ||RoleId1 <- Key],
        [{PassTime, Time, Rank, RoleList}|List]
    end, [], AreaRankList),
    ?PRINT("send_rank_list SelfRank :~p~n", [{SelfRank, SelfPassTime}]),
    ?PRINT("send_rank_list SendList :~p~n", [SendList]),
    {ok, Bin} = pt_508:write(50802, [TeamDunId, SelfRank, SelfPassTime, SendList]),
    lib_server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

do_handle_cast({midnight_reset}, State) ->
    #week_dun_state{role_map = RoleMap, rank_list = RankList} = State,
    %% 日志
    log_week_dungeon_rank(RankList, RoleMap),
    %% 发送擂主奖励
    send_week_dungeon_rank_reward(RankList, RoleMap),
    spawn(fun() -> 
        db:execute(io_lib:format(<<"truncate table `week_dun_rank`">>, [])),
        db:execute(io_lib:format(<<"truncate table `week_dun_rank_role`">>, []))
    end),
    {noreply, State#week_dun_state{role_map = #{}, rank_list = [], rank_limit = []}};

do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================

do_handle_info(_Info, State) -> {noreply, State}.

update_rank_role(WDunRankRoleList, RoleMap) ->
    F = fun(WeekDunRankRole, {Map, DbList}) ->
        #week_dun_rank_role{role_id = RoleId} = WeekDunRankRole,
        case maps:is_key(RoleId, Map) of 
            true -> {Map, DbList};
            _ ->
                {maps:put(RoleId, WeekDunRankRole, Map), [WeekDunRankRole|DbList]}
        end
    end,
    {NewRoleMap, UpList} = lists:foldl(F, {RoleMap, []}, WDunRankRoleList),
    db_replace_week_dun_rank_role(UpList),
    NewRoleMap.

refresh_rank_do(DunRankList) ->
    F = fun(#week_dun_rank{pass_time = PassTime1, time = Time1}, #week_dun_rank{pass_time = PassTime2, time = Time2}) ->
        if
            PassTime1 < PassTime2 -> true;
            PassTime1 == PassTime2 -> Time1 < Time2;
            true -> false
        end
    end,
    SortDunRankList = lists:sort(F, DunRankList),
    {NewDunRankList, NewLimitVal} = refresh_rank_do(SortDunRankList, 1, [], 99999),
    {NewDunRankList, NewLimitVal}.

refresh_rank_do([], _Rank, Return, OldLimitVal) ->
    {lists:reverse(Return), OldLimitVal};
refresh_rank_do([WeekDunRank|SortDunRankList], Rank, Return, OldLimitVal) ->
    case Rank > 30 of 
        false ->
            NewWeekDunRank = WeekDunRank#week_dun_rank{rank = Rank},
            NewLimitVal = ?IF(Rank == 30, WeekDunRank#week_dun_rank.pass_time, OldLimitVal),
            refresh_rank_do(SortDunRankList, Rank+1, [NewWeekDunRank|Return], NewLimitVal);
        true -> %% 低于的排名设为0
            NewWeekDunRank = WeekDunRank#week_dun_rank{rank = 0},
            refresh_rank_do(SortDunRankList, Rank, [NewWeekDunRank|Return], OldLimitVal)
    end.

init_do() ->
    DbWeekRankRoleList = db_select_week_dun_rank_role(),
    RoleMap = init_week_rank_role(DbWeekRankRoleList, #{}),
    DbWeekRankList = db_select_week_dun_rank(),
    {RankList, RankLimit} = init_week_rank(DbWeekRankList),
    #week_dun_state{rank_list = RankList, rank_limit = RankLimit, role_map = RoleMap}.

init_week_rank_role([], Map) -> Map;
init_week_rank_role([[RoleId, RoleName, ServerId, ServerNum]|DbWeekRankRoleList], Map) ->
    WeekDunRankRole = #week_dun_rank_role{role_id = RoleId, role_name = RoleName, server_id = ServerId, server_num = ServerNum},
    init_week_rank_role(DbWeekRankRoleList, maps:put(RoleId, WeekDunRankRole, Map)).

init_week_rank(DbWeekRankList) ->
    F = fun([DunId, KeyStr, PassTime, Time], List) ->
        WeekDunRank = #week_dun_rank{key = util:bitstring_to_term(KeyStr), pass_time = PassTime, time = Time},
        {_, OldList} = ulists:keyfind(DunId, 1, List, {DunId, []}),
        lists:keystore(DunId, 1, List, {DunId, [WeekDunRank|OldList]})
    end,
    RankList = lists:foldl(F, [], DbWeekRankList),
    F2 = fun({DunId, DunRankList}, {List2, List3}) ->
        {NewDunRankList, NewLimitVal} = refresh_rank_do(DunRankList),
        {[{DunId, NewDunRankList}|List2], [{DunId, NewLimitVal}|List3]}
    end,
    lists:foldl(F2, {[], []}, RankList).

get_self_rank_info([], _RoleId) -> {0, 0};
get_self_rank_info([WeekDunRank|RankList], RoleId) ->
    case lists:member(RoleId, WeekDunRank#week_dun_rank.key) of 
        true ->
            {WeekDunRank#week_dun_rank.rank, WeekDunRank#week_dun_rank.pass_time};
        _ ->
            get_self_rank_info(RankList, RoleId)
    end.

get_area_rank_list([], _Rank1, _Rank2, Return) -> Return;
get_area_rank_list([WeekDunRank|RankList], Rank1, Rank2, Return) ->
    if
        WeekDunRank#week_dun_rank.rank < Rank1 andalso WeekDunRank#week_dun_rank.rank > 0 ->
            get_area_rank_list(RankList, Rank1, Rank2, Return);
        WeekDunRank#week_dun_rank.rank >= Rank2 -> 
            [WeekDunRank|Return];
        true ->
            get_area_rank_list(RankList, Rank1, Rank2, [WeekDunRank|Return])
    end.

send_week_dungeon_rank_reward(RankList, RoleMap) ->
    ResultMap = get_week_dungeon_rank_reward(RankList, RoleMap, #{}),
    SendRewardListByServer = combine_result(ResultMap),
    %?PRINT("dungeon_rank_reward : ~p~n", [SendRewardListByServer]),
    spawn(fun() -> send_week_dungeon_rank_reward_do(SendRewardListByServer) end),
    ok.

send_week_dungeon_rank_reward_do([]) -> ok;
send_week_dungeon_rank_reward_do([{ServerId, RoleList}|SendRewardListByServer]) ->
    mod_clusters_center:apply_cast(ServerId, lib_week_dungeon, send_week_dungeon_reward, [RoleList]),
    timer:sleep(100),
    send_week_dungeon_rank_reward_do(SendRewardListByServer).


get_week_dungeon_rank_reward([], _RoleMap, ResultMap) -> ResultMap;
get_week_dungeon_rank_reward([{DunId, DunRankList}|RankList], RoleMap, ResultMap) ->
    NewResultMap = get_week_dungeon_rank_reward_helper(DunRankList, DunId, RoleMap, ResultMap),
    get_week_dungeon_rank_reward(RankList, RoleMap, NewResultMap).

get_week_dungeon_rank_reward_helper([], _WeekDunId, _RoleMap, ResultMap) -> ResultMap;
get_week_dungeon_rank_reward_helper([WeekDunRank|DunRankList], DunId, RoleMap, ResultMap) ->
    #week_dun_rank{key = RoleIdList, rank = Rank} = WeekDunRank,
    F = fun(RoleId, Map) ->
        case maps:is_key({DunId, RoleId}, Map) of 
            true -> Map;
            _ ->
                case maps:get(RoleId, RoleMap) of 
                    #week_dun_rank_role{server_id = ServerId} ->
                        maps:put({DunId, RoleId}, {Rank, ServerId}, Map);
                    _ ->
                        Map
                end
        end
    end,
    NewResultMap = lists:foldl(F, ResultMap, RoleIdList),
    get_week_dungeon_rank_reward_helper(DunRankList, DunId, RoleMap, NewResultMap).

combine_result(ResultMap) ->
    F = fun({DunId, RoleId}, {Rank, ServerId}, List) ->
        case lists:keyfind(ServerId, 1, List) of 
            {_, RoleList} -> NewRoleList = [{RoleId, DunId, Rank}|RoleList];
            _ -> NewRoleList = [{RoleId, DunId, Rank}]
        end,
        lists:keystore(ServerId, 1, List, {ServerId, NewRoleList})
    end,
    maps:fold(F, [], ResultMap).


db_select_week_dun_rank_role() ->
    db:get_all(io_lib:format(<<"select role_id, role_name, server_id, server_num from `week_dun_rank_role`">>, [])).

db_select_week_dun_rank() ->
     db:get_all(io_lib:format(<<"select `dun_id`, `key`, `pass_time`, `time` from `week_dun_rank`">>, [])).

db_replace_week_dun_rank_role([]) -> ok;
db_replace_week_dun_rank_role(UpList) ->
    DbList = [[RoleId, RoleName, ServerId, ServerNum] 
        || #week_dun_rank_role{role_id = RoleId, role_name = RoleName, server_id = ServerId, server_num = ServerNum} <- UpList],
    Sql = usql:replace(week_dun_rank_role, [role_id, role_name, server_id, server_num], DbList),
    db:execute(Sql).

db_replace_week_dun_rank(DunId, WeekDunRank) ->
    #week_dun_rank{key = Key, pass_time = PassTime, time = Time} = WeekDunRank,
    Sql = usql:replace(week_dun_rank, [dun_id, key, pass_time, time], [[DunId, util:term_to_bitstring(Key), PassTime, Time]]),
    db:execute(Sql).

log_week_dungeon_rank(RankList, RoleMap) ->
    NowTime = utime:unixtime(),
    F = fun({DunId, DunRankList}, List) ->
        F2 = fun(WeekDunRank, List2) ->
            #week_dun_rank{key = Key, rank = Rank, pass_time = PassTime} = WeekDunRank,
            OwnerStr = [begin
                #week_dun_rank_role{role_id = RoleId1, role_name = RoleName, server_id = SerId} = maps:get(RoleId, RoleMap, #week_dun_rank_role{}),
                uio:format("{1}_{2}_{3}", [RoleId1, RoleName, SerId])
            end ||RoleId <- Key],
            OwnerStrLink = util:link_list(OwnerStr),
            [[DunId, Rank, PassTime, util:make_sure_binary(OwnerStrLink), NowTime]|List2]
        end,
        lists:foldl(F2, List, DunRankList)
    end,
    LogList = lists:foldl(F, [], RankList),
    lib_log_api:log_week_dungeon_rank(LogList).