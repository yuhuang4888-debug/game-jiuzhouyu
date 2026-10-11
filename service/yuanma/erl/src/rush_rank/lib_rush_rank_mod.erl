%%%------------------------------------
%%% @Module  : lib_rush_rank_mod
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 通用榜单
%%%------------------------------------

-module(lib_rush_rank_mod).


-export([
    init/0
    , refresh_rush_rank/4
    , send_rank_list/6
]).

-compile(export_all).

-include("errcode.hrl").
-include("language.hrl").
-include("rush_rank.hrl").
-include("kv.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("record.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("goods.hrl").
-include("custom_act.hrl").
-include("def_module.hrl").
-include("server.hrl").
-include("def_fun.hrl").

make_record(rush_rank_role, [RankType, SubType, RoleId, Value, Time, GetRewardStatus]) ->
    #rush_rank_role{
        role_key = {RankType, SubType, RoleId},
        rank_type = RankType,
        sub_type = SubType,
        role_id = RoleId,
        value = Value,
        time = Time,
        get_reward_status = GetRewardStatus
    }.

init() ->
    %% 个人榜单
    List = db_rush_rank_role_select(),
    RoleList = [make_record(rush_rank_role, T) || T <- List],
    RankMaps = get_standard_sort_rank_maps(rush_rank_role, RoleList),  %%排好序，长度也截取了
    RoleLimitList = clean_redundant_rank_data_from_db(RankMaps),
    RankLimit = maps:from_list(RoleLimitList),

    List1 = db_rush_rank_goal_select(),
    GoalList = [{{RankType, SubType, RoleId}, util:bitstring_to_term(_GoalList)} || [RankType, SubType, RoleId, _GoalList] <- List1],
    GoalMaps = maps:from_list(GoalList),
    AllRankMap = get_rush_rank_all_role(),
    State = #rush_rank_state{rank_maps = RankMaps, rank_limit = RankLimit, goal_maps = GoalMaps, all_rank_maps = AllRankMap},

    % 因活动进行到一半修改了配置,重新对goal_list进行初始化
    reinit_goal_list(State).

%% @return #rush_rank_state{}
reinit_goal_list(#rush_rank_state{goal_maps = GoalMap, all_rank_maps = AllRankMap} = State) ->
    F = fun({RankType, SubType, RoleId} = Key, OGoalList, {AccL, AccM}) ->
        NGoalList0 = [
            begin
                {_, OState} = ulists:keyfind(RewardId, 1, OGoalList, {RewardId, ?NOT_REWARD}),
                {RewardId, OState}
            end
        || RewardId <- data_rush_rank:get_goal_reward_ids(RankType)
        ],
        Value = maps:get(Key, AllRankMap, 0),
        NGoalList = update_goal_state_by_rank_type(NGoalList0, RankType, Value),
        NAccL =
        case NGoalList -- OGoalList of
            [] -> AccL; % 没有新奖励状态需要改变
            _ -> [[RankType, SubType, RoleId, NGoalList] | AccL]
        end,
        {NAccL, AccM#{Key => NGoalList}}
    end,
    {ChangeL0, NGoalMap} = maps:fold(F, {[], GoalMap}, GoalMap),

    % db更新
    ChangeL = [
        [RankType, SubType, RoleId, util:term_to_string(GoalList)]
    || [RankType, SubType, RoleId, GoalList] <- ChangeL0],
    Sql = usql:replace(rush_rank_goal, [rank_type, sub_type, player_id, goal_list], ChangeL),
    Sql /= [] andalso db:execute(Sql),

    State#rush_rank_state{goal_maps = NGoalMap}.

%% -----------------------------------------------------------------
%% @desc     功能描述    获得标准排序Maps(被截取了长度) Key:{RankType,subType}  Value:[#rush_rank_role{}]
%% @param    参数       RoleList::lists   [#rush_rank_role]
%% @return   返回值     #{{RankType, SubType} => [#rush_rank_role]}
%% @history  修改历史
%% -----------------------------------------------------------------
get_standard_sort_rank_maps(rush_rank_role, RoleList) ->
    MapsKeyList = get_sort_rank_maps(rush_rank_role, RoleList), %%排序后的list
    F = fun({{RankType, SubType}, RankList}) ->
        MaxRankLen = lib_rush_rank:get_max_len(RankType),
        NewRankList = lists:sublist(RankList, MaxRankLen),
        {{RankType, SubType}, NewRankList}
        end,
    NewKeyList = lists:map(F, MapsKeyList),   %%截取了长度的list
    NewMaps = maps:from_list(NewKeyList),     %%从list变为了map
    NewMaps.

%% 分类到Maps,然后对Maps的Value排序 Key:RankType Value:[#rush_rank_role{}] 返回  [{{RankType, SubType}, [#run_rank_role]}]
get_sort_rank_maps(rush_rank_role, RoleList) ->
    F = fun(#rush_rank_role{rank_type = RankType, sub_type = SubType} = RankRole, Maps) ->
        case maps:get({RankType, SubType}, Maps, false) of
            false ->
                NewList = [RankRole];
            List ->
                NewList = [RankRole | List]
        end,
        maps:put({RankType, SubType}, NewList, Maps)
        end,
    Maps = lists:foldl(F, maps:new(), RoleList),  %%  根据#{{RankType, SubType} => RoleList}
    NewKeyList = sort_rank_maps(Maps),            %%
    NewKeyList.

%% 对Maps的Value排序 结果 [{{RankType, SubType}, [#run_rank_role]}]
sort_rank_maps(Maps) ->
    MapsKeyList = maps:to_list(Maps),
    F = fun({{RankType, SubType}, List}) ->
        RankList = sort_rank_list(List),
        {{RankType, SubType}, RankList}
        end,
    NewKeyList = lists:map(F, MapsKeyList),
    NewKeyList.
%%列表里的排序
sort_rank_list([]) -> [];
sort_rank_list(List) ->
    % 排序
    F = fun(A, B) ->
        if
            is_record(A, rush_rank_role) ->
                if
                    A#rush_rank_role.value > B#rush_rank_role.value ->
                        true;
                    A#rush_rank_role.value == B#rush_rank_role.value ->
                        A#rush_rank_role.time =< B#rush_rank_role.time;
                    true ->
                        false
                end;
            true ->
                false
        end
        end,
    NewList = lists:sort(F, List),

    OpenTime = util:get_open_time(),
    ChangeOpenTime = data_key_value:get(?KEY_RUSH_CHANGE_OPEN_TIME),
    OpenDay = util:get_open_day(ChangeOpenTime),

    % 排名赋值
    F1 = fun
    (#rush_rank_role{rank_type = RankType, value = Value} = Member, {TempList, Rank0}) ->
        CfgRank = get_rush_rank(OpenDay, OpenTime, ChangeOpenTime, RankType, Value),
        Rank = max(Rank0, CfgRank),
        case CfgRank of
            0 ->
                {TempList, Rank};
            _ ->
                NewMember = Member#rush_rank_role{rank = Rank},
                NewTempList = [NewMember | TempList],
                {NewTempList, Rank + 1}
        end;
    (_, {TempList, Rank}) ->
        {TempList, Rank}
    end,
    {TmpRankList, _} = lists:foldl(F1, {[], 1}, NewList),
    lists:reverse(TmpRankList).

%% 按开服时间来获取不同的阈值排名
get_rush_rank(OpenDay, OpenTime, ChangeOpenTime, RankType, Value) ->
    #base_rush_rank{open_day_list = OldOpenDayList} = data_rush_rank:get_rush_rank_cfg(RankType),
    CfgRank = data_rush_rank:get_highest_rank(RankType, Value),
    NewCfgRank = data_rush_rank:get_new_highest_rank(RankType, Value),
    case check_is_change(OpenDay, OpenTime, ChangeOpenTime, OldOpenDayList) of
        true -> NewCfgRank;
        _ -> CfgRank
    end.

check_is_change(OpenDay, OpenTime, ChangeOpenTime, OldOpenDayList) ->
    case ChangeOpenTime =< OpenTime of
        true -> true;
        _ -> not lists:member(OpenDay, OldOpenDayList)
    end.


%% 清理数据库的冗余数据,防止数据过多, 更新Limit值
clean_redundant_rank_data_from_db(RankMaps) ->
    MapsKeyList = maps:to_list(RankMaps),
    F = fun({{RankType, SubType}, []}) ->
        Limit = lib_rush_rank:get_rank_limit(RankType),
        {{RankType, SubType}, Limit};   %%这种格式
        ({{RankType, SubType}, RankList}) ->
            Limit = lib_rush_rank:get_rank_limit(RankType),
            RankMax = lib_rush_rank:get_max_len(RankType),
            case length(RankList) >= RankMax of
                true ->
                    #rush_rank_role{value = Value} = lists:last(RankList),
                    db_rush_rank_delete_by_value(RankType, SubType, Value),
                    {{RankType, SubType}, max(Value, Limit)};
                false ->
                    {{RankType, SubType}, Limit}
            end
        end,
    lists:map(F, MapsKeyList).

%% @param [{RankType, RushRankRole}]
refresh_rush_rank_by_list(State, List) ->
    F = fun({{RankType, SubType}, CommonRank}, TmpState) ->
        {ok, NewTmpState} = refresh_rush_rank(TmpState, RankType, SubType, CommonRank),
        NewTmpState
        end,
    NewState = lists:foldl(F, State, List),
    {ok, NewState}.

%% 刷新榜单
refresh_rush_rank(State, RankType, SubType, RushRankRole) ->
    #rush_rank_state{
        rank_maps = RankMaps,
        rank_limit = RankLimit,
        all_rank_maps = AllRankMaps,
        goal_maps = GoalMaps
    } = State,
    #rush_rank_role{
        role_id = RoleId,
        value = Value
    } = RushRankRole,
    RankList = maps:get({RankType, SubType}, RankMaps, []),
    % 更新目标奖励领取状态
%%	{GoalId, RewardState} = maps:get({RankType, SubType, RoleId}, GoalMaps, init_goal_list(RankType)),  %%有两个目标怎么办，现在好像只是支持一个目标奖励
    _GoalList = maps:get({RankType, SubType, RoleId}, GoalMaps, init_goal_list(RankType)),  %%支持两个目标啦
    case _GoalList of
        [] ->
            GoalList = init_goal_list(RankType);
        _ ->
            GoalList = _GoalList
    end,
    %% 已完成或已达成状态 不用根据值来更新状态
    NewGoalList = update_goal_state_by_rank_type(GoalList, RankType, Value),
    NewGoalMaps = maps:put({RankType, SubType, RoleId}, NewGoalList, GoalMaps),
    db_rush_rank_goal_save(RankType, SubType, RoleId, NewGoalList),  %%同步数据库
    send_goal_list(State#rush_rank_state{goal_maps = NewGoalMaps}, SubType, RoleId), %%发送客户端
    {NewRankList, NewRankLimit} = do_refresh_rush_rank_help(RankList, RankType, SubType, RushRankRole, RankLimit),
    % 发送排名变化通知
    State1 = send_rank_change_notify(State, RankType, RankList, NewRankList, RoleId, Value),
    %%更新玩家排序值，这里只要是刷新就更新，不管是否上榜
    NewAllRankMaps = maps:put({RankType, SubType, RoleId}, Value, AllRankMaps),
    update_all_role(RushRankRole),
    %%修正状态
    NewRankMaps = maps:put({RankType, SubType}, NewRankList, RankMaps),
    NewState = State1#rush_rank_state{rank_maps = NewRankMaps, rank_limit = NewRankLimit,
        goal_maps = NewGoalMaps, all_rank_maps = NewAllRankMaps},
    % 第一名玩家变化推送
    broadcast_rank1_change({RankType, SubType}, RankList, NewRankList),
    ?IF(RankType == ?RANK_TYPE_RECHARGE_RUSH, send_rank_list(NewState, RankType, SubType, RoleId, Value, ?IS_SHOW_COMBAT), skip),
    {ok, NewState}.

%% 第一名玩家变化推送
broadcast_rank1_change({RankType, SubType}, OldRankList, NewRankList) ->
    OldRank1Role = lists:keyfind(1, #rush_rank_role.rank, OldRankList),
    NewRank1Role = lists:keyfind(1, #rush_rank_role.rank, NewRankList),
    case {OldRank1Role, NewRank1Role} of
        {false, false} -> skip; % 仍然没有玩家上榜
        {#rush_rank_role{role_id = Id}, #rush_rank_role{role_id = Id}} -> skip; % 第一名玩家没变
        _ ->
            [lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_rush_rank, send_rank_list, [{RankType, SubType}]) || RoleId <- lib_online:get_online_ids()]
    end.

%% 先判断list中是否存在key和value都相等的玩家，存在则跟新数据，不存在则将其进行队列排序：将其与队
%% 尾比较，若小于队尾并且队列长度大于最长长度，则丢弃，否则将其加入队列，排序并保证队列长度为最大
%% 队列长度，发送数据的时候，先截取显示长度，再判断是否满足limit，满足条件的才加入发送队列。
%% 时刻保证，排序之后队列和数据库保存的数据为整个服的前N，然后在这之中选择发送、
do_refresh_rush_rank_help(RankList, RankType, SubType, RushRankRole, RankLimit) ->
    #rush_rank_role{role_key = RoleKey, value = Value, accid = AccId, accname = AccName} = RushRankRole,
    %% 充值活动限制
    %% 充值榜单时判断当前账号信息是否被限制上榜
    if
        RankType == ?RANK_TYPE_RECHARGE_RUSH ->
            IsLimit = lib_recharge_limit:check_recharge_limit(AccId, AccName);
        true -> IsLimit = false
    end,
    if
        IsLimit -> {RankList, RankLimit};
        true ->
            case lists:keyfind(RoleKey, #rush_rank_role.role_key, RankList) of
                #rush_rank_role{rank_type = RankType} when RankType == ?RANK_TYPE_SUIT_RUSH orelse RankType == ?RANK_TYPE_STONE_RUSH ->  %%更新后，值比原来的还小，保留最大值
                    do_refresh_rush_rank_help2(RankList, RankType, SubType, RushRankRole, RankLimit);
                #rush_rank_role{value = OldValue} when Value =< OldValue ->  %%更新后，值比原来的还小，保留最大值
                    {RankList, RankLimit};
                _ ->
                    do_refresh_rush_rank_help2(RankList, RankType, SubType, RushRankRole, RankLimit)
            end
    end.

do_refresh_rush_rank_help2(RankList, RankType, SubType, RushRankRole, RankLimit) ->
    MaxRankLenTmp = lib_rush_rank:get_max_len(RankType),  %%最大长度
    %% 此处特殊处理：充值榜的时候会保存多一点榜单数据，方便运营限制指定玩家充值榜单移除内玩
    MaxRankLen = ?IF(RankType == ?RANK_TYPE_RECHARGE_RUSH, MaxRankLenTmp + 50, MaxRankLenTmp),
    Limit = lib_rush_rank:get_rank_limit(RankType),    %%上榜阈值
    LastValue = max(maps:get({RankType, SubType}, RankLimit, Limit), Limit),  %%榜单的阈值，或者榜尾最小值
    case RankList == [] of
        true ->
            if
                RushRankRole#rush_rank_role.value >= LastValue ->  %%即使是空榜，也要达到阈值才能上榜
                    db_rush_rank_role_save(RushRankRole),
                    NewRankList = [RushRankRole],
                    NewRankList2 = sort_rank_list(NewRankList),
                    {NewRankList2, RankLimit};
                true ->  %%未达到阈值，未能上榜
                    NewRankList2 = [],
                    {NewRankList2, RankLimit}
            end;
        false ->
            IsExistKey = lists:keymember(RushRankRole#rush_rank_role.role_key, #rush_rank_role.role_key, RankList),
            #rush_rank_role{role_key = RoleKey, value = Value} = RushRankRole,
            %% 是否需要排序
            case Value < LastValue andalso (not IsExistKey) of
                true ->  %%未能上榜
                    NewRankList2 = RankList,
                    {NewRankList2, RankLimit};
                false -> %%可以上榜，重新排序， 修正内存数据，同步数据库
                    %% 内存和数据库存储
                    NewRankList = lists:keystore(RoleKey, #rush_rank_role.role_key, RankList, RushRankRole),
                    db_rush_rank_role_save(RushRankRole),
                    %% 排序
                    NewRankList2 = sort_rank_list(NewRankList),
                    % 分开上榜显示数据和冗余数据
                    {LastList, LeftRankList} = lists:partition(fun(#rush_rank_role{rank = Rank}) -> Rank =< MaxRankLen end, NewRankList2),
                    %% 清理冗余数据,这样修改插入数据效率会提高-----就是删除被挤下来的数据
                    TmpRoleIds = [TmpRoleId || #rush_rank_role{role_id = TmpRoleId} <- LeftRankList],
                    db_rush_rank_delete_by_ids(RankType, SubType, TmpRoleIds),
                    %% 更新阈值
                    case LeftRankList of
                        [] ->
                            NewLastValue = LastValue;
                        _ ->
                            case LastList of
                                [] ->
                                    LastRankRole = #rush_rank_role{};
                                _ ->
                                    LastRankRole = lists:last(LastList)
                            end,
                            #rush_rank_role{value = TempLastValue} = LastRankRole,
                            NewLastValue = max(TempLastValue, LastValue)
                    end,
                    NewRankLimit = maps:put({RankType, SubType}, NewLastValue, RankLimit),
                    {LastList, NewRankLimit}
            end
    end.

%% 发送目标奖励状态列表
send_goal_list(State, SubType, RoleId) ->
    #rush_rank_state{goal_maps = GoalMaps} = State,
    %% 榜单类型根据开服天数排序 对应客户端的顺序，开服天数越小排序越前
    F = fun(A, B) ->
        case data_rush_rank:get_rush_rank_cfg(A) of
            #base_rush_rank{start_day = StDayA} ->
                skip;
            _ ->
                ?ERR("rush rank config err!~n", []), StDayA = 99999
        end,
        case data_rush_rank:get_rush_rank_cfg(B) of
            #base_rush_rank{start_day = StDayB} ->
                skip;
            _ ->
                ?ERR("rush rank config err!~n", []),
                StDayB = 99999
        end,
        StDayA < StDayB
        end,
    SortTypeL = lists:sort(F, ?RANK_TYPE_LIST),
    SendList = [begin
                    StDay = case data_rush_rank:get_rush_rank_cfg(RankType) of
                                #base_rush_rank{start_day = TmpStDay} ->
                                    TmpStDay;
                                _ ->
                                    99999
                            end,
                    case maps:get({RankType, SubType, RoleId}, GoalMaps, false) of
                        [] ->
                            GoalList = init_goal_list(RankType);
                        false ->
                            GoalList = init_goal_list(RankType);
                        GoalList ->
                            skip
                    end,
                    %% 未到达开始时间 奖励状态为不可领状态
                    case util:get_open_day() >= StDay of
                        true ->
                            LastGoalList = GoalList;
                        false ->
                            LastGoalList = [{_GoalId, ?NOT_REWARD} || {_GoalId, _} <- GoalList]
                    end,
                    {RankType, LastGoalList}
                end
        || RankType <- SortTypeL],
    lib_server_send:send_to_uid(RoleId, pt_225, 22502, [SendList]).

%% 领取目标奖励
get_goal_reward(State, RoleId, RankType, SubType, GoalId, SelValue) ->
    #rush_rank_state{goal_maps = GoalMaps} = State,
%%	{OldGoalId, RewardState} = maps:get({RankType, SubType, RoleId}, GoalMaps, init_goal_list(RankType)),
    GoalList = maps:get({RankType, SubType, RoleId}, GoalMaps, init_goal_list(RankType)),
    case data_rush_rank:get_rush_rank_cfg(RankType) of
        #base_rush_rank{start_day = StDay} ->
            case util:get_open_day() >= StDay of
                true ->
                    case lists:keyfind(GoalId, 1, GoalList) of
                        {GoalId, RewardState} ->
                            case RewardState == ?HAVE_REWARD of
                                true ->
                                    NewGoalList = lists:keystore(GoalId, 1, GoalList, {GoalId, ?FINISH}),
                                    NewGoalMaps = maps:put({RankType, SubType, RoleId}, NewGoalList,
                                        GoalMaps),
                                    %% 存库
                                    db_rush_rank_goal_save(RankType, SubType, RoleId, NewGoalList),
                                    Reward = lib_rush_rank:get_cfg_goal_reward(RankType, GoalId),
                                    Produce = #produce{
                                        title = utext:get(281),
                                        content = utext:get(282),
                                        reward = Reward,
                                        type = rush_goal_reward,
                                        show_tips = 1
                                    },
                                    ?DEBUG("Reward ~p~n", [Reward]),
                                    lib_goods_api:send_reward_with_mail(RoleId, Produce),
                                    %% 日志
                                    lib_log_api:log_rush_goal_reward(RoleId, RankType, GoalId, SelValue, Reward),
                                    lib_server_send:send_to_uid(RoleId, pt_225, 22503, [?SUCCESS, RankType, GoalId, SubType]),
                                    NewState = State#rush_rank_state{goal_maps = NewGoalMaps};
                                _ ->
                                    NewState = State
                            end;
                        _ ->
                            lib_server_send:send_to_uid(RoleId, pt_225, 22503, [?FAIL, RankType, GoalId, SubType]),
                            NewState = State
                    end;
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_225, 22503, [?FAIL, RankType, GoalId, SubType]),
                    NewState = State
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_225, 22503, [?ERRCODE(err_config), RankType, GoalId, SubType]),
            NewState = State
    end,
    {ok, NewState}.

%% 发送排行榜
send_rank_list(State, RankType, SubType, RoleId, SelValue, IsShowCombat) ->
    #rush_rank_state{rank_maps = RankMaps, all_rank_maps = AllRankMaps} = State,
    RankList = maps:get({RankType, SubType}, RankMaps, []),
    MaxRankLen = lib_rush_rank:get_max_len(RankType), %%榜单长度
    Limit = lib_rush_rank:get_rank_limit(RankType),   %%阈值
    SubRankList = lists:sublist(RankList, MaxRankLen),%%截取
    List1 = [RushRole || RushRole <- SubRankList, RushRole#rush_rank_role.value >= Limit],
    F = fun(#rush_rank_role{role_id = TmpRoleId, value = Value, rank = Rank}) ->
        case lib_role:get_role_show(TmpRoleId) of
            [] ->
                Figure = #figure{};
            #ets_role_show{figure = Figure} ->
                skip
        end,
        {TmpRoleId, Figure#figure.name, Value, Rank}
    end,
    List = lists:map(F, List1),
    %%结算时间
    EndTime = get_end_time(RankType),
    Sum = length(List),
    if
        Sum == 0 ->  %%空榜
            {ok, BinData} = pt_225:write(22501, [RankType, 0, SelValue, 0, MaxRankLen, Limit, 0, EndTime, IsShowCombat, []]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            case lists:keyfind({RankType, SubType, RoleId}, #rush_rank_role.role_key, List1) of
                #rush_rank_role{rank = RoleRank, get_reward_status = RewardStatus} ->
                    skip;  %%玩家在榜
                _ ->
                    RoleRank = 0, RewardStatus = 0
            end,
            LastSelVal = maps:get({RankType, SubType, RoleId}, AllRankMaps, SelValue),
            {ok, BinData} = pt_225:write(22501, [RankType, RoleRank, max(LastSelVal, SelValue), Sum, MaxRankLen, Limit, RewardStatus, EndTime, IsShowCombat, List]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end.

%%%% 活动期间每日结算-----
%%day_clear(DelaySec, State) ->
%%    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_RUSH_RANK) of
%%        true ->
%%            case lib_rush_rank:get_id_by_clear_day() of  %%找出当天要结算的id，只是支持不重复的天数，
%%                0 -> skip;
%%                RankId ->
%%                    spawn(fun() ->
%%                        util:multiserver_delay(DelaySec, lib_rush_rank_mod, send_reward, [State, RankId]) end)  %%这个是考虑到服太多了，负载过重
%%            end;
%%        _ ->
%%            skip
%%    end,
%%    {ok, State}.


%% 活动期间每日结算-----
day_clear(DelaySec, State) ->
    CloseDay =
        case lib_custom_act_util:get_act_cfg_info(10, 1) of
            #custom_act_cfg{opday_lim = Lim} ->
                [{_, _CloseDay}] = Lim,
                _CloseDay + 1;
            _ ->
                0
        end,
    case util:get_open_day() of
        CloseDay ->    %%活动结束天数
            [spawn(fun() ->
                util:multiserver_delay(DelaySec, mod_rush_rank, send_reward_by_mail, [RankId]) end) ||  %%活动结束,没有领取的发送邮件
                RankId <- data_rush_rank:get_id_list()],
            mod_rush_rank:send_goal_reward_by_mail(),
            spawn(fun() ->
                timer:sleep(1000 * 1000), %%10秒后清理数据
                ?MYLOG("cym", "++++++++++++++++ rush_rank clear data", []),
                mod_rush_rank:act_end() end);
        _ ->
            case lib_rush_rank:get_id_by_clear_day() of  %%找出当天要结算的id，只是支持不重复的天数，
                0 ->
                    ?DEBUG("not rankId~n", []),
                    skip;
                RankId ->
                    ?DEBUG("RankId ~p~n", [RankId]),
                    spawn(fun() ->
                        util:multiserver_delay(DelaySec, lib_rush_rank_mod, update_reward, [State, RankId]) end)  %%修改领取状态
            end
    end,
%%	case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_RUSH_RANK) of
%%		true ->
%%
%%		_ ->
%%			skip
%%	end,
    {ok, State}.

apply_cast(State, M, F, A) ->
    M:F(State, A).


%% 每天结算的后，领取状态改变
update_reward(State, RankType) ->
    #rush_rank_state{rank_maps = RankMaps} = State,
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_RUSH_RANK) of
        true ->
            #base_rush_rank{name = _RankTypeName} = data_rush_rank:get_rush_rank_cfg(RankType),
            SubList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_RUSH_RANK),
            F = fun(SubType) ->
                case maps:get({RankType, SubType}, RankMaps, []) of
                    [] ->
%%						?DEBUG("RankId ~p~n", [RankType]),
                        skip;
                    _RankList ->
%%						?DEBUG("RankId ~p~n", [RankType]),
                        mod_rush_rank:update_rank_reward_status(RankType, SubType, ?HAVE_REWARD)

                end
%%				[send_goal_list(State, SubType, OnlineRole#ets_online.id) || OnlineRole <- ets:tab2list(?ETS_ONLINE)]
                end,
            [F(SubType) || SubType <- SubList];
        _ ->
            ?DEBUG("not open ~n", []),
            ok
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  活动结束后，发送邮件 排行榜奖励
%% @param    参数      State::#rush_rank_state{}
%%                     RankType::integer()  排行榜类型
%% @return   返回值   无
%% @history  修改历史
%% -----------------------------------------------------------------
send_reward_by_mail(State, RankType) ->
    #rush_rank_state{rank_maps = RankMaps} = State,
    #base_rush_rank{name = RankTypeName} = data_rush_rank:get_rush_rank_cfg(RankType),
    SubType = 1,  %%开服冲榜就一个子类型
    NewRankList =
        case maps:get({RankType, SubType}, RankMaps, []) of
            [] ->
%%				?DEBUG("log1 ~n", []),
                [];
            RankList ->
%%				?DEBUG("log2 ~n", []),

                Title = uio:format(?LAN_MSG(279), [RankTypeName]),  %%
                do_send_reward(RankList, RankType, RankTypeName, Title, 1),
                [X#rush_rank_role{get_reward_status = ?FINISH} || X <- RankList]
        end,
%%	[send_goal_list(State, SubType, OnlineRole#ets_online.id) || OnlineRole <- ets:tab2list(?ETS_ONLINE)],
    NewRankMap = maps:put({RankType, SubType}, NewRankList, RankMaps),
    %%同步数据库
    Sql = io_lib:format(?slq_rush_rank_role_update_rewardStatus, [?FINISH, RankType, SubType]),
    db:execute(Sql),
    {ok, State#rush_rank_state{rank_maps = NewRankMap}}.


%% -----------------------------------------------------------------
%% @desc     功能描述  活动结束后，发送邮件 目标奖励
%% @param    参数      State::#rush_rank_state{}
%%                     RankType::integer()  排行榜类型
%% @return   返回值    {ok, NewState}
%% @history  修改历史
%% -----------------------------------------------------------------
send_goal_reward_by_mail(State) ->
    #rush_rank_state{goal_maps = GoalMap, rank_maps = RankMap} = State,
    GoalList = maps:to_list(GoalMap),  %%[{{RankType, SubType, RoleId}, GoalList}]
%%	?MYLOG("cym", "GoalList ~p~n", [GoalList]),
    spawn(fun() ->
        [   begin
                timer:sleep(100),
                do_send_goal_reward_by_mail(RankMap, X)
            end
            || X <- GoalList]
          end),
%%	TempList = [{{RankType1, SubType1, RoleId1}, {GoalId1, ?FINISH}} || {{RankType1, SubType1, RoleId1}, {GoalId1, _RewardState1}} <- GoalList],
    F = fun({{RankType, SubType, RoleId}, RoleGoalList}, AccList) ->
        FF = fun({GoalId, StatusF}, AccList1) ->
            case StatusF of
                ?HAVE_REWARD ->
                    [{GoalId, ?FINISH} | AccList1];
                _ ->
                    [{GoalId, StatusF} | AccList1]
            end
             end,
        RoleGoalListNew = lists:foldl(FF, [], RoleGoalList),
        [{{RankType, SubType, RoleId}, RoleGoalListNew} | AccList]
        end,
    TempList = lists:foldl(F, [], GoalList),
    NewMap = maps:from_list(TempList),
    {ok, State#rush_rank_state{goal_maps = NewMap}}.


%% -----------------------------------------------------------------
%% @desc     功能描述  发送目标奖励
%% @param    参数      Goal  {{RankType, SubType, RoleId}, {GoalId, RewardState}}
%%                     RankMap:: {RankType,SubType} => [#rush_rank_role{}|...]
%% @return   返回值    {{RankType, SubType, RoleId}, GoalList}
%% @history  修改历史
%% -----------------------------------------------------------------
do_send_goal_reward_by_mail(RankMap, {{RankType, SubType, RoleId}, GoalList}) ->
    SelValue = get_sel_value(RankType, SubType, RoleId, RankMap),  %%排位榜对应的值
    send_goal_reward_by_mail_helper({{RankType, SubType, RoleId}, GoalList}, SelValue).



%%返回  {{RankType, SubType, RoleId},  NewGoalList}
send_goal_reward_by_mail_helper({{RankType, SubType, RoleId}, GoalList}, _SelValue) ->
    NewGoalList = [send_goal_reward_by_mail_helper2(X, RankType, RoleId) || X <- GoalList],
    db_rush_rank_goal_save(RankType, SubType, RoleId, NewGoalList),
    {{RankType, SubType, RoleId}, NewGoalList}.



%%返回   {goalId, State}
send_goal_reward_by_mail_helper2({GoalId, ?HAVE_REWARD}, RankType, RoleId) ->
    Reward = lib_rush_rank:get_cfg_goal_reward(RankType, GoalId),
    Title = ?LAN_MSG(281),
    Content = ?LAN_MSG(282),
%%	?MYLOG("cym", "GoalId ~p RoleId ~p~n Reward ~p~n", [GoalId, RoleId, Reward]),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),  %%发送邮件
    {GoalId, ?FINISH};
%%	case data_rush_rank:get_goal_reward_cfg(RankType, GoalId + 1) of
%%		#base_rush_goal_reward{} -> %%还有下一个目标奖励
%%			NewGoalStatus = lib_rush_rank:get_new_reward_state(RankType, SelValue, GoalId + 1),
%%			send_goal_reward_by_mail_helper({{RankType, SubType, RoleId}, {GoalId + 1, NewGoalStatus}}, SelValue);
%%		_ -> %%么有下个奖励了
%%			%%同步书库库
%%			db_rush_rank_goal_save(RankType, SubType, RoleId, GoalId, ?FINISH),
%%			%%返回
%%			{{RankType, SubType, RoleId}, {GoalId, ?FINISH}}
%%	end.
send_goal_reward_by_mail_helper2({GoalId, State}, _RankType, _RoleId) ->
    {GoalId, State}.



do_send_reward([], _RankType, _RankTypeName, _Title, _Count) ->
    skip;
do_send_reward([#rush_rank_role{role_id = RoleId, rank = Rank, value = Value, get_reward_status = ?HAVE_REWARD} | RankList], RankType, Name, Title, Count) ->  %%只有可领取的才能发送邮件
    ?DEBUG("RankType ~p ~n", [RankType]),
    case lib_role:get_role_show(RoleId) of
        [] ->
            ?ERR("rush rank can not find role info :~p~n", [RoleId]),
            do_send_reward(RankList, RankType, Name, Title, Count);
        #ets_role_show{figure = #figure{sex = Sex, name = _RoleName}} ->
            case lib_rush_rank:get_rank_reward(RankType, Rank, Sex) of %% 奖励根据性别有区别
                [] ->
                    ?ERR("rush rank can not find reward :~p~n", [[RankType, Rank, Sex]]),
                    do_send_reward(RankList, RankType, Name, Title, Count);
                Reward ->
                    if
                        Count rem 20 == 0 ->
                            timer:sleep(500);
                        true ->
                            skip
                    end,
%%					if
%%						Rank =/= 1 ->
%%							skip;
%%						true ->
%%							lib_chat:send_TV({all}, ?MOD_RUSH_RANK, 1, [RoleName, Name])
%%					end,
                    Content = uio:format(?LAN_MSG(280), [Name, Rank]),
                    ?DEBUG("RoleId ~p ~n Reward ~p ~n", [RoleId, Reward]),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
                    %% 日志
                    lib_log_api:log_rush_rank_reward(RoleId, RankType, Rank, Value, Reward),
                    do_send_reward(RankList, RankType, Name, Title, Count + 1)
            end
    end;
do_send_reward([_ | RankList], RankType, Name, Title, Count) ->
    do_send_reward(RankList, RankType, Name, Title, Count).



set_reward([], _RankType, _RankTypeName, _Title, _Count) ->
    skip;
set_reward([#rush_rank_role{role_id = RoleId, rank = Rank, value = Value} | RankList], RankType, Name, Title, Count) ->
    case lib_role:get_role_show(RoleId) of
        [] ->
            ?ERR("rush rank can not find role info :~p~n", [RoleId]),
            do_send_reward(RankList, RankType, Name, Title, Count);
        #ets_role_show{figure = #figure{sex = Sex, name = RoleName}} ->
            case lib_rush_rank:get_rank_reward(RankType, Rank, Sex) of %% 奖励根据性别有区别
                [] ->
                    ?ERR("rush rank can not find reward :~p~n", [[RankType, Rank, Sex]]),
                    do_send_reward(RankList, RankType, Name, Title, Count);
                Reward ->
                    if
                        Count rem 20 == 0 ->
                            timer:sleep(500);
                        true ->
                            skip
                    end,
                    if
                        Rank =/= 1 ->
                            skip;
                        true ->
                            lib_chat:send_TV({all}, ?MOD_RUSH_RANK, 1, [RoleName, Name])
                    end,
                    Content = uio:format(?LAN_MSG(280), [Name, Rank]),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
                    %% 日志
                    lib_log_api:log_rush_rank_reward(RoleId, RankType, Rank, Value, Reward),
                    do_send_reward(RankList, RankType, Name, Title, Count + 1)
            end
    end;
set_reward([R | _RankList], RankType, _Name, _Title, _Count) ->
    ?ERR("rush rank back data:~p,~nrank_type:~p~n", [R, RankType]),
    skip.


%%----------------db-----------------------%%
db_rush_rank_role_select() ->
    Sql = io_lib:format(?sql_rush_rank_role_select, []),
    db:get_all(Sql).

db_rush_rank_goal_select() ->
    Sql = io_lib:format(?sql_rush_rank_goal_select, []),
    db:get_all(Sql).

db_rush_rank_role_save(RankRole) ->
    #rush_rank_role{
        rank_type = RankType,
        sub_type = SubType,
        role_id = RoleId,
        value = Value,
        time = Time,
        get_reward_status = RewardStatus
    } = RankRole,
    Sql = io_lib:format(?sql_rush_rank_role_save, [RankType, SubType, RoleId, Value, Time, RewardStatus]),
    db:execute(Sql).

db_rush_rank_goal_save(RankType, SubType, RoleId, GoalList) ->
    Sql = io_lib:format(?sql_rush_rank_goal_save,
        [RankType, SubType, RoleId, util:term_to_string(GoalList)]),
    db:execute(Sql).

db_rush_rank_delete_by_id(RankType, SubType, RoleId) ->
    Sql = io_lib:format(?sql_rush_rank_role_delete_by_role_id, [RankType, SubType, RoleId]),
    db:execute(Sql).

db_rush_rank_delete_by_ids(_RankType, _SubType, []) -> skip;
db_rush_rank_delete_by_ids(RankType, SubType, RoleIds) ->
    Condition = usql:condition({player_id, in, RoleIds}),
    Sql = io_lib:format(?sql_rush_rank_role_delete_by_role_ids, [Condition, RankType, SubType]),
    db:execute(Sql).

db_rush_rank_delete_by_value(RankType, SubType, Value) ->
    Sql = io_lib:format(?sql_rush_rank_role_delete_by_value, [RankType, SubType, Value]),
    db:execute(Sql).

gm_send_rewards(State, SubType) ->
    #rush_rank_state{rank_maps = RankMaps} = State,
    F = fun(RankType) ->
        case maps:get({RankType, SubType}, RankMaps, []) of
            [] ->
                ?ERR("rushrank_gm_rewards nothing ~n", []);
            RankList ->
                case lists:keyfind(1, #rush_rank_role.rank, RankList) of
                    #rush_rank_role{role_id = RoleId} ->
                        Title = "开服冲榜补偿",
                        Content = "亲爱的骑士大人，公主阁下决定提高开服冲榜的奖励力度，经查阅资料确认，可以给您补发以下奖励，敬请查收！",
                        RewardList = get_gm_rewards(RankType),
                        lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
                        ?ERR("rush_rank_gm_rewards done role_id = ~p, ~p~n", [RoleId, RankType]);
                    _ ->
                        ?ERR("rushrank_gm_rewards nothing ~n", [])
                end
        end
        end,
    [F(Id) || Id <- get_ids_by_day(util:get_open_day())].

get_ids_by_day(Day) ->
    [Id || Id <- data_rush_rank:get_id_list(),
        case data_rush_rank:get_rush_rank_cfg(Id) of
            #base_rush_rank{clear_day = CDay} when Day >= CDay ->
                true;
            _ ->
                false
        end].

%% -----------------------------------------------------------------
%% @desc     功能描述 更新排行榜获奖状态  注意同步数据库
%% @param    参数   State::#rush_rank_state{}
%%                  RankType::integer() 排行榜类型
%%                  SubType::integer()  任务子类型
%%                  RewardStatus::integer() 奖励领取状态
%% @return   返回值 {ok, NewState}
%% @history  修改历史
%% -----------------------------------------------------------------
update_rank_reward_status(State, RankType, SubType, RewardStatus) ->
    ?DEBUG("RankType  ~p  SubType ~p RewardStatus ~p ~n", [RankType, SubType, RewardStatus]),
    #rush_rank_state{rank_maps = RankMap} = State,
    NewRankMap =
        case maps:find({RankType, SubType}, RankMap) of
            error ->
                RankMap;
            {ok, RankListTmp} ->
                %% 确保下长度
                MaxRankLen = lib_rush_rank:get_max_len(RankType),
                RankList = lists:sublist(RankListTmp, MaxRankLen),
                NewRankList = [X#rush_rank_role{get_reward_status = RewardStatus} || X <- RankList],
                maps:put({RankType, SubType}, NewRankList, RankMap)
        end,
    %%同步数据库
    Sql = io_lib:format(?slq_rush_rank_role_update_rewardStatus, [RewardStatus, RankType, SubType]),
    db:execute(Sql),
    % TA数据上报
    RankList1 = maps:get({RankType, SubType}, NewRankMap, []),
    F = fun(#rush_rank_role{role_id = RoleId, rank = Rank, value = Value}) ->
        timer:sleep(timer:seconds(10)), % 每个玩家之间作10s延迟
        lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, ta_agent_fire, log_rush_rank_reward, [RankType, Rank, Value, undefined])
    end,
    spawn(fun() -> timer:sleep(timer:seconds(5*60)), lists:foreach(F, RankList1) end),
    {ok, State#rush_rank_state{rank_maps = NewRankMap}}.

get_gm_rewards(1) ->
    [{100, 38060024, 1}];
get_gm_rewards(2) ->
    [{100, 16030002, 1}];
get_gm_rewards(3) ->
    [{100, 18040002, 1}];
get_gm_rewards(4) ->
    [{100, 38140003, 1}];
get_gm_rewards(5) ->
    [{100, 38150003, 1}, {100, 14010003, 1}];
get_gm_rewards(6) ->
    [{100, 12040002, 1}].


%% -----------------------------------------------------------------
%% @desc     功能描述  玩家领取排行榜奖励    检查是否可以领取， 档次否对 ->生成奖励->生成日志->发送奖励->通知客户端->修正领取状态->同步数据库
%% @param    参数      State::#rush_rank_state{}
%%                     RoleId::integer() 玩家id
%%                     RankType::integer() 排行榜类型
%%                     Subtype::integer()
%%                     活动子类型  RewardId::interger() 奖励档次
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_rank_reward(#rush_rank_state{rank_maps = RankMap} = State, RoleId, RankType, SubType, RewardId, Career) ->
    NewMap =
        case maps:find({RankType, SubType}, RankMap) of
            {ok, RankRoleList} ->
                NewRoleList =
                    case lists:keyfind({RankType, SubType, RoleId}, #rush_rank_role.role_key, RankRoleList) of
                        #rush_rank_role{rank = Rank, get_reward_status = RewardStatus, value = Value} = RankRole ->
                            case RewardStatus of
                                ?NOT_REWARD ->  %%不能领取
                                    send_err_code(RoleId, ?ERRCODE(err225_rank_not_end)),
                                    RankRoleList;
                                ?FINISH ->  %%已经领取了
                                    send_err_code(RoleId, ?ERRCODE(err331_already_get_reward)),
                                    RankRoleList;
                                ?HAVE_REWARD ->  %%可以领取
                                    %%档次对的上否
                                    case data_rush_rank:get_rank_reward_cfg(RankType, RewardId) of
                                        #base_rush_rank_reward{rank_min = RankMin, rank_max = RankMax} ->
                                            case Rank >= RankMin andalso Rank =< RankMax of
                                                true ->
                                                    %%生成奖励
                                                    Reward = lib_rush_rank:get_rank_reward(RankType, Rank, Career),   %% 奖励根据职业有区别，这里是一定有的，检查过了
                                                    %% 日志
                                                    lib_log_api:log_rush_rank_reward(RoleId, RankType, Rank, Value, Reward),
                                                    %% rush_rank 发送奖励
                                                    lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = rush_rank}),
                                                    %%通知客户端
                                                    lib_server_send:send_to_uid(RoleId, pt_225, 22504, [?SUCCESS, RewardId, SubType, RankType]),
                                                    %%修正领取状态
                                                    NewRankRole = RankRole#rush_rank_role{get_reward_status = ?FINISH},
                                                    NewRankRoleList = lists:keystore({RankType, SubType, RoleId}, #rush_rank_role.role_key,
                                                        RankRoleList, NewRankRole),
                                                    %%同步数据库
                                                    ?DEBUG("reward ~p~n", [Reward]),
                                                    db_rush_rank_role_save(NewRankRole),
                                                    NewRankRoleList;
                                                false ->  %%档次错误
                                                    send_err_code(RoleId, ?ERRCODE(err255_err_reward_id)),
                                                    RankRoleList
                                            end;
                                        _ -> %%丢失配置
                                            send_err_code(RoleId, ?MISSING_CONFIG),
                                            RankRoleList
                                    end
                            end;
                        _ -> %%没有上榜
                            send_err_code(RoleId, ?ERRCODE(err225_not_on_rank)),
                            RankRoleList
                    end,
                _Map = maps:put({RankType, SubType}, NewRoleList, RankMap),
                _Map;
            _ ->
                send_err_code(RoleId, ?FAIL),
                RankMap
        end,
%%	?DEBUG("NewMap ~p~n", [NewMap]),
    {ok, State#rush_rank_state{rank_maps = NewMap}}.


send_err_code(RoleId, Err) ->
    ?DEBUG("err ~p ~n", [Err]),
    {ok, Bin} = pt_225:write(22500, [Err]),
    lib_server_send:send_to_uid(RoleId, Bin).


%% -----------------------------------------------------------------
%% @desc     功能描述  获取排行榜对应的值
%% @param    参数     RankType::排行榜类型 SubType::活动子类型  RoleId 玩家id，
%%                    RankMap::{RankType,SubType} => [#rush_rank_role{}|...]
%% @return   返回值   SelVale::integer()  排位榜对应的值
%% @history  修改历史
%% -----------------------------------------------------------------
get_sel_value(RankType, SubType, RoleId, RankMap) ->
    case maps:find({RankType, SubType}, RankMap) of
        {ok, List} ->
            case lists:keyfind({RankType, SubType, RoleId}, #rush_rank_role.role_key, List) of
                #rush_rank_role{value = SelValue} ->
                    SelValue;
                _ ->
                    0
            end;
        _ ->
            0
    end.

%%获取排行榜结算时间
get_end_time(RankType) ->
    case data_rush_rank:get_rush_rank_cfg(RankType) of
        #base_rush_rank{start_day = _StartDay, clear_day = EndDay} ->
            OpenDay = util:get_open_day(),
            if
                OpenDay >= EndDay ->  %%已经结算了
                    0;
                OpenDay < EndDay -> %% 当天结算0点了，直接返回0
                    utime:unixdate() + (EndDay - OpenDay) * 86400;   %%当天0点时间戳 + （结算天数 - 开服天数） * 86400
                true ->
                    0
            end;
        _ ->
            0
    end.



get_rush_rank_all_role() ->
    Sql = io_lib:format(?sql_rush_rank_all_role, []),
    List = db:get_all(Sql),
    List1 = [{{RankType, SubType, RoleId}, Value} || [RankType, SubType, RoleId, Value] <- List],
    maps:from_list(List1).


%更新玩家排行榜信息
update_all_role(#rush_rank_role{rank_type = Type, sub_type = SubType, role_id = RoleId, value = Value}) ->
    Sql = io_lib:format(?sql_rush_rank_all_role_save, [Type, SubType, RoleId, Value]),
    db:execute(Sql).


%%初始化目标列表  返回[{goalId, State}]
init_goal_list(RankType) ->
    GoalSum = length(data_rush_rank:get_goal_reward_ids(RankType)),
    init_goal_list_helper(GoalSum).

init_goal_list_helper(GoalSum) ->
    init_goal_list_helper(GoalSum, []).

init_goal_list_helper(0, List) ->
    List;
init_goal_list_helper(N, List) ->
    init_goal_list_helper(N - 1, [{N, 0} | List]).


%%更新目标奖励状态--刷新
update_goal_state_by_rank_type(GoalList, RankType, Value) ->
    update_goal_state_by_rank_type_helper(GoalList, RankType, Value, []).


update_goal_state_by_rank_type_helper([], _RankType, _Value, AccList) ->
    lists:reverse(AccList);
update_goal_state_by_rank_type_helper([{GoalId, RewardState} | H], RankType, Value, AccList) ->
    if
        RewardState == ?NOT_REWARD ->
            NewRewardState = lib_rush_rank:get_new_reward_state(RankType, Value, GoalId);  %%更新状态
        true ->
            NewRewardState = RewardState
    end,
    update_goal_state_by_rank_type_helper(H, RankType, Value, [{GoalId, NewRewardState} | AccList]).

%%活动结算，清理数据
act_end(_State) ->
    %%清理数据库
    Sql1 = io_lib:format(?del_rush_rank_role, []),
    Sql2 = io_lib:format(?del_rush_rank_all_role, []),
    Sql3 = io_lib:format(?del_rush_rank_goal, []),
    db:execute(Sql1),
    db:execute(Sql2),
    db:execute(Sql3),
    {ok, #rush_rank_state{}}.

remove_role_in_rank(State, SubType, ?RANK_TYPE_RECHARGE_RUSH, RoleIds) ->
    #rush_rank_state{rank_maps = RankMap} = State,
    case maps:get({?RANK_TYPE_RECHARGE_RUSH, SubType}, RankMap, false) of
        false -> {ok, State};
        RankList ->
            NewRankListTmp = [RankRole||RankRole<-RankList, not lists:member(RankRole#rush_rank_role.role_id, RoleIds)],
            NewRankList = sort_rank_list(NewRankListTmp),
            TmpRoleIds = [TmpRoleId || TmpRoleId <- RoleIds],
            db_rush_rank_delete_by_ids(?RANK_TYPE_RECHARGE_RUSH, SubType, TmpRoleIds),
            NewRankMap = maps:put({?RANK_TYPE_RECHARGE_RUSH, SubType}, NewRankList, RankMap),
            {ok, State#rush_rank_state{rank_maps = NewRankMap}}
    end;
remove_role_in_rank(State, _SubType, _RankType, _RoleIds) ->
    {ok,State}.

%%用于数据修复
get_reward2(Rank, RankType, RoleId) ->
    case lib_role:get_role_show(RoleId) of
        #ets_role_show{figure = Figure} ->
            lib_rush_rank:get_rank_reward(RankType, Rank, Figure#figure.sex);   %% 奖励根据性别有区别，这里是一定有的，检查过了
        _ ->
            []
    end.


clear_old_data(State) ->
    Sql1 = io_lib:format(<<"DELETE from  rush_rank_all_role where rank_type = 4 or  rank_type =  6 ">>, []),
    db:execute(Sql1),
    Sql2 = io_lib:format(<<"DELETE from  rush_rank_role where rank_type = 4 or  rank_type =  6 ">>, []),
    db:execute(Sql2),
    Sql3 = io_lib:format(<<"DELETE from  rush_rank_goal where rank_type = 4 or  rank_type =  6 ">>, []),
    db:execute(Sql3),
    #rush_rank_state{rank_maps = RankMap, goal_maps = GoalMaps} = State,
    List = maps:get({?RANK_TYPE_RECHARGE_RUSH, 1}, RankMap, []) ++
        maps:get({?RANK_TYPE_COMBAT_RUSH, 1}, RankMap, []),
    Tile = utext:get(2250001),
    Content1 = utext:get(2250002),  %% 开服冲榜排行榜奖励
    Content2 = utext:get(2250003),  %% 开服冲榜目标奖励
    [begin
         case get_reward2(Rank, RankType, RoleId) of
             [_ | _] = Reward ->
                 lib_mail_api:send_sys_mail([RoleId], Tile, Content1, Reward);
             _ ->
                 skip
         end
     end
        || #rush_rank_role{get_reward_status = Status, rank = Rank, rank_type = RankType, role_id = RoleId} <- List, Status == ?HAVE_REWARD],
    RankMap1 = maps:remove({?RANK_TYPE_RECHARGE_RUSH, 1}, RankMap),
    RankMap2 = maps:remove({?RANK_TYPE_COMBAT_RUSH, 1}, RankMap1),
    GoalList = maps:to_list(GoalMaps),
    F = fun({{RankType, SubType, RoleId}, ValuesList}, AccList) ->
        if
            RankType == ?RANK_TYPE_RECHARGE_RUSH orelse RankType == ?RANK_TYPE_COMBAT_RUSH ->
                [begin
                     case lib_rush_rank:get_cfg_goal_reward(RankType, GoalId) of
                         [_ | _] = Reward ->
                             lib_mail_api:send_sys_mail([RoleId], Tile, Content2, Reward);
                         _ ->
                             skip
                     end
                 end
                    || {GoalId, Status} <- ValuesList, Status == 1],
                AccList;
            true ->
                [{{RankType, SubType, RoleId}, ValuesList} | AccList]
        end
        end,
    NewGoalList = lists:foldl(F, [], GoalList),
    NewGoalMaps = maps:from_list(NewGoalList),
    State#rush_rank_state{rank_maps = RankMap2, goal_maps = NewGoalMaps}.

%% 发送榜单排名变化的通知
%% 只有当天开的活动才发通知
send_rank_change_notify(State, RankType, RankList, NewRankList, RoleId, RoleVal) ->
    case data_rush_rank:get_rush_rank_cfg(RankType) of
        #base_rush_rank{start_day = StartDay, clear_day = ClearDay} ->
            NowOpenDay = util:get_open_day(),
            case NowOpenDay >= StartDay andalso NowOpenDay < ClearDay of
                true -> send_rank_change_notify_help(State, RankType, RankList, NewRankList, RoleId, RoleVal);
                false -> State
            end;
        [] -> State
    end.

send_rank_change_notify_help(State, RankType, RankList, NewRankList, RoleId, RoleVal) ->
    MaxRankLen = lib_rush_rank:get_max_len(RankType),  %%榜单长度
    Limit = lib_rush_rank:get_rank_limit(RankType),    %%阈值
    NewSubRankList = lists:sublist(NewRankList, MaxRankLen),
    OldSubRankList = lists:sublist(RankList, MaxRankLen), %%截取
    NowTime = utime:unixtime(),
    F = fun(#rush_rank_role{rank = Rank, value = Val}, {Rank100, Rank50, Rank20, Rank10, Rank3, Rank2, Rank1}) ->
        case Rank of
            100 -> {Val, Rank50, Rank20, Rank10, Rank3, Rank2, Rank1};
            50 -> {Rank100, Val, Rank20, Rank10, Rank3, Rank2, Rank1};
            20 -> {Rank100, Rank50, Val, Rank10, Rank3, Rank2, Rank1};
            10 -> {Rank100, Rank50, Rank20, Val, Rank3, Rank2, Rank1};
            3 -> {Rank100, Rank50, Rank20, Rank10, Val, Rank2, Rank1};
            2 -> {Rank100, Rank50, Rank20, Rank10, Rank3, Val, Rank1};
            1 -> {Rank100, Rank50, Rank20, Rank10, Rank3, Rank2, Val};
            _ -> {Rank100, Rank50, Rank20, Rank10, Rank3, Rank2, Rank1}
        end
    end,
    RankLevelValue0 ={ % -1 是为了修正下一阶段提醒的数值
        data_rush_rank:get_rank_limit_val(RankType, 100) - 1,
        data_rush_rank:get_rank_limit_val(RankType, 50) - 1,
        data_rush_rank:get_rank_limit_val(RankType, 20) - 1,
        data_rush_rank:get_rank_limit_val(RankType, 10) - 1,
        data_rush_rank:get_rank_limit_val(RankType, 3) - 1,
        data_rush_rank:get_rank_limit_val(RankType, 2) - 1,
        data_rush_rank:get_rank_limit_val(RankType, 1) - 1
    },
    RankLevelValue = lists:foldl(F, RankLevelValue0, NewSubRankList),
    F1 = fun(#rush_rank_role{role_id = ListRoleId, rank = Rank}, AccState) ->
        case check_send_time_limit(AccState, RankType, ListRoleId, NowTime) of
            true ->
                case lists:keyfind(ListRoleId, #rush_rank_role.role_id, NewSubRankList) of
                    #rush_rank_role{rank = NewRank, value = NewValue} ->
                        handle_rank_change(AccState, RankType, ListRoleId, Rank, NewRank, NewValue, RankLevelValue, RoleId);
                    false ->
                        % 掉榜，提示被其他人超过
                        send_rank_change_info(AccState, ListRoleId, [RankType, ?RUSH_RANK_NOTIFY_TYPE_0, 0, 0, 0])
                end;
            false -> AccState
        end
         end,
    NewState = lists:foldl(F1, State, OldSubRankList),
    InLimit = not check_send_time_limit(NewState, RankType, RoleId, NowTime),
    if
        InLimit -> NewState;
        RoleVal < Limit ->
            % 发送多久到阈值
            NearLimit = calc_nearest_limit(RankType, RoleVal, Limit),   %% 阈值未到即是未上榜
            {Val, SubVal} = calc_level_value(RankType, RoleVal, NearLimit, true),
            send_rank_change_info(NewState, RoleId, [RankType, ?RUSH_RANK_NOTIFY_TYPE_3, 0, Val, SubVal]);
        true ->
            case lists:keyfind(RoleId, #rush_rank_role.role_id, OldSubRankList) of
                false ->
                    #rush_rank_role{rank = NewRoleRank, value = NewRoleValue} = ulists:keyfind(RoleId, #rush_rank_role.role_id, NewSubRankList, #rush_rank_role{rank = MaxRankLen + 1, value = RoleVal}),
                    % 新上榜，触发逻辑
                    handle_rank_change(NewState, RankType, RoleId, MaxRankLen + 1, NewRoleRank, NewRoleValue, RankLevelValue, RoleId);
                _ ->
                    % 在原来的榜单中，说明已经触发逻辑了
                    NewState
            end
    end.

%% 处理排名变化
%% 被别人超过处理
handle_rank_change(State, RankType, RoleId, OldRank, NewRank, _NowValue,_RankLevelValue, _TriggerRoleId) when OldRank < NewRank->
    send_rank_change_info(State, RoleId, [RankType, ?RUSH_RANK_NOTIFY_TYPE_0, 0, 0, 0]);
%% 排名提升处理
handle_rank_change(State, RankType, RoleId, OldRank, NewRank, Value, {Rank100, Rank50, Rank20, Rank10, Rank3, Rank2, Rank1} = _RankLevelValue, TriggerRoleId) when OldRank >= NewRank->
    OldLevel = calc_rank_level(OldRank),
    NewLevel = calc_rank_level(NewRank),
    CalcNextLevelDis = fun(Level) ->
        case Level of
            8 -> % 提示多久到第100名
                {?RUSH_RANK_NOTIFY_TYPE_1, 100, Value, Rank100};
            7 -> % 提示多久到第50名
                {?RUSH_RANK_NOTIFY_TYPE_1, 50, Value, Rank50};
            6 -> % 提示多久到第20名
                {?RUSH_RANK_NOTIFY_TYPE_1, 20, Value, Rank20};
            5 -> % 提示多久到10名
                {?RUSH_RANK_NOTIFY_TYPE_1, 10, Value, Rank10};
            4 -> % 提示多久到第3名
                {?RUSH_RANK_NOTIFY_TYPE_1, 3, Value, Rank3};
            3 -> % 提示多久到第2名
                {?RUSH_RANK_NOTIFY_TYPE_1, 2, Value, Rank2};
            2 -> % 提示第多久到第1名
                {?RUSH_RANK_NOTIFY_TYPE_1, 1, Value, Rank1};
            1 -> % 登临榜首
                {?RUSH_RANK_NOTIFY_TYPE_2, 0, 0, 0}
        end
                       end,

    case OldLevel =:= NewLevel of
        true ->
            % 第一名发送第二名何时追过
            case RoleId =:= TriggerRoleId of
                true ->
                    % 排名第一要发送第二名多久超过
                    case OldLevel =:= 1 of
                        true ->
                            %% 20220308 应策划要求修改该处逻辑，不再给第一名推送其与第二名的差距
                            %%{SendValue, SendSubValue} = calc_level_value(RankType, Rank2, Value, false),
                            %%send_rank_change_info(State, RoleId, [RankType, ?RUSH_RANK_NOTIFY_TYPE_4, 1, SendValue, SendSubValue]);
                            State;
                        false ->
                            {SendType, NextRank, NowValue, NextValue} = CalcNextLevelDis(NewLevel),
                            {SendValue, SendSubValue} = calc_level_value(RankType, NowValue, NextValue, false),
                            send_rank_change_info(State, RoleId, [RankType, SendType, NextRank, SendValue, SendSubValue])
                    end;
                false -> State
            end;
        false ->
            % 阶段发生变化，提示提升多少到下一阶段
            {SendType, NextRank, NowValue, NextValue} = CalcNextLevelDis(NewLevel),
            {SendValue, SendSubValue} = calc_level_value(RankType, NowValue, NextValue, false),
            send_rank_change_info(State, RoleId,[RankType, SendType, NextRank, SendValue, SendSubValue])
    end.

%% 计算排名阶段
%% _-101, 51-100, 21-50, 11-20, 4-10, 3, 2, 1 8个阶段
calc_rank_level(Rank) ->
    if
        Rank > 100 -> 8;
        Rank > 50 -> 7;
        Rank > 20 -> 6;
        Rank > 10 -> 5;
        Rank > 3 -> 4;
        Rank > 2 -> 3;
        Rank > 1 -> 2;
        true -> 1
    end.

calc_next_level(Level) ->
    if
        Level =:= 1 -> 1;
        true -> Level - 1
    end.

%% 计算
%% IsLimit 是否低于阈值
calc_level_value(RankType, NowValue, NextValue, IsLimit) ->
    case lists:member(RankType, ?RUSH_RANK_SPECIAL_STAR) of
        true when IsLimit == false ->
            LevelDis = NextValue - NowValue,
            {util:ceil(LevelDis/10000) * 10000, 0};
        true ->
            StageDis1 = round((NextValue - NowValue) / ?STAGE_ADD),
            LowLevelStar = NowValue rem ?STAGE_ADD,
            HighLevelStar = NextValue rem ?STAGE_ADD,
            {StageDis3, StarDis1} = case  HighLevelStar < LowLevelStar of
                                        true -> {StageDis1 - 1, 10 - LowLevelStar + HighLevelStar};
                                        false -> {StageDis1, HighLevelStar - LowLevelStar}
                                    end,
            StageDis2 = supplement_num_to_tem(RankType, StageDis3),
            {StageDis2, StarDis1};
        _ ->
            LevelDis = NextValue - NowValue,
            NewLevelDis = ?IF(IsLimit =:= true, LevelDis, LevelDis + 1),
            {supplement_num_to_tem(RankType, NewLevelDis), 0}
    end.

%% 20220308 应策划要求，补充
%% 充值榜的数字为整十
%% 战力榜补w
supplement_num_to_tem(RankType, Old) ->
    case RankType of
        ?RANK_TYPE_RECHARGE_RUSH ->
            util:ceil(Old/10) * 10;
        ?RANK_TYPE_COMBAT_RUSH ->
            util:ceil(Old/10000) * 10000;
        _ -> Old
    end.

%% 计算最近的阈值
%% 阈值有两个， 就是冲榜奖励条件里面的
calc_nearest_limit(RankType, RoleVal, Limit) ->
    F = fun(#base_rush_goal_reward{goal_value = GoalV}, Res) ->
        [{_, Val}] = GoalV,
        case Val of
            {Stage, Star} ->
                NewVal = Stage * ?STAGE_ADD + Star;
            V ->
                NewVal = V
        end,
        ?IF(RoleVal < NewVal, min(NewVal, Res), Res)
    end,
    Goals = data_rush_rank:get_goal_reward_ids(RankType),
    GoalRewards = [data_rush_rank:get_goal_reward_cfg(RankType, GoalId) || GoalId <- Goals],
    lists:foldl(F, Limit, GoalRewards).

check_send_time_limit(State, RankType, RoleId, NowTime) ->
    #rush_rank_state{role_send_time_limit = AllSendTimeLimitMap} = State,
    RoleMap = case maps:find(RankType, AllSendTimeLimitMap) of
                  {ok, RoleMap1} ->RoleMap1;
                  error -> #{}
              end,
    case maps:find(RoleId, RoleMap) of
        {ok, Val} ->
            NowTime >= Val;
        error ->
            true
    end.

send_rank_change_info(State, RoleId, [RankType, _, _, _, _] = SendData) ->
    #rush_rank_state{role_send_time_limit = AllSendTimeLimitMap} = State,
    RoleMap = case maps:find(RankType, AllSendTimeLimitMap) of
                  {ok, RoleMap1} ->RoleMap1;
                  error -> #{}
              end,
    NextTime = utime:unixtime() + ?ONE_MIN * 5, % 间隔5分钟
    {ok, BinData} = pt_332:write(33251, SendData),
    Back = lib_server_send:send_to_uid(RoleId, BinData),
    case Back of
        skip -> State;
        _ ->
            NewRoleMap = maps:put(RoleId, NextTime, RoleMap),
            NewLimitMap = maps:put(RankType, NewRoleMap, AllSendTimeLimitMap),
            State#rush_rank_state{role_send_time_limit = NewLimitMap}
    end.

role_refresh_send_time(State, RoleId) ->
    #rush_rank_state{role_send_time_limit = AllSendTimeLimitMap} = State,
    F = fun(_, RoleMap) ->
        maps:remove(RoleId, RoleMap)
        end,
    NewMap = maps:map(F, AllSendTimeLimitMap),
    {ok, State#rush_rank_state{role_send_time_limit = NewMap}}.

%% 刷新榜单
gm_refresh_rush_rank(State, RankType, SubType, RushRankRole) ->
    #rush_rank_state{
        rank_maps = RankMaps,
        rank_limit = RankLimit,
        all_rank_maps = AllRankMaps,
        goal_maps = GoalMaps
    } = State,
    #rush_rank_role{
        role_id = RoleId,
        value = Value
    } = RushRankRole,
    RankList = maps:get({RankType, SubType}, RankMaps, []),
    % 更新目标奖励领取状态
%%	{GoalId, RewardState} = maps:get({RankType, SubType, RoleId}, GoalMaps, init_goal_list(RankType)),  %%有两个目标怎么办，现在好像只是支持一个目标奖励
    _GoalList = maps:get({RankType, SubType, RoleId}, GoalMaps, init_goal_list(RankType)),  %%支持两个目标啦
    case _GoalList of
        [] ->
            GoalList = init_goal_list(RankType);
        _ ->
            GoalList = _GoalList
    end,
    %% 已完成或已达成状态 不用根据值来更新状态
    NewGoalList = update_goal_state_by_rank_type(GoalList, RankType, Value),
    NewGoalMaps = maps:put({RankType, SubType, RoleId}, NewGoalList, GoalMaps),
    db_rush_rank_goal_save(RankType, SubType, RoleId, NewGoalList),  %%同步数据库
    send_goal_list(State#rush_rank_state{goal_maps = NewGoalMaps}, SubType, RoleId), %%发送客户端
    {NewRankList, NewRankLimit} = do_gm_refresh_rush_rank_help(RankList, RankType, SubType, RushRankRole, RankLimit),
    % 发送排名变化通知
    State1 = send_rank_change_notify(State, RankType, RankList, NewRankList, RoleId, Value),
    %%更新玩家排序值，这里只要是刷新就更新，不管是否上榜
    NewAllRankMaps = maps:put({RankType, SubType, RoleId}, Value, AllRankMaps),
    update_all_role(RushRankRole),
    %%修正状态
    NewRankMaps = maps:put({RankType, SubType}, NewRankList, RankMaps),
    NewState = State1#rush_rank_state{rank_maps = NewRankMaps, rank_limit = NewRankLimit,
        goal_maps = NewGoalMaps, all_rank_maps = NewAllRankMaps},
    % 第一名玩家变化推送
    broadcast_rank1_change({RankType, SubType}, RankList, NewRankList),
    ?IF(RankType == ?RANK_TYPE_RECHARGE_RUSH, send_rank_list(NewState, RankType, SubType, RoleId, Value, ?IS_SHOW_COMBAT), skip),
    {ok, NewState}.

%% 先判断list中是否存在key和value都相等的玩家，存在则跟新数据，不存在则将其进行队列排序：将其与队
%% 尾比较，若小于队尾并且队列长度大于最长长度，则丢弃，否则将其加入队列，排序并保证队列长度为最大
%% 队列长度，发送数据的时候，先截取显示长度，再判断是否满足limit，满足条件的才加入发送队列。
%% 时刻保证，排序之后队列和数据库保存的数据为整个服的前N，然后在这之中选择发送、
do_gm_refresh_rush_rank_help(RankList, RankType, SubType, RushRankRole, RankLimit) ->
    #rush_rank_role{role_key = RoleKey, value = _Value, accid = AccId, accname = AccName} = RushRankRole,
    %% 充值活动限制
    %% 充值榜单时判断当前账号信息是否被限制上榜
    if
        RankType == ?RANK_TYPE_RECHARGE_RUSH ->
            IsLimit = lib_recharge_limit:check_recharge_limit(AccId, AccName);
        true -> IsLimit = false
    end,
    if
        IsLimit -> {RankList, RankLimit};
        true ->
            case lists:keyfind(RoleKey, #rush_rank_role.role_key, RankList) of
                #rush_rank_role{rank_type = RankType} when RankType == ?RANK_TYPE_SUIT_RUSH orelse RankType == ?RANK_TYPE_STONE_RUSH ->  %%更新后，值比原来的还小，保留最大值
                    do_refresh_rush_rank_help2(RankList, RankType, SubType, RushRankRole, RankLimit);
                _ ->
                    do_refresh_rush_rank_help2(RankList, RankType, SubType, RushRankRole, RankLimit)
            end
    end.
