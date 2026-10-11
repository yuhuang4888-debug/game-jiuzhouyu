%%%------------------------------------
%%% @Module  : lib_consume_rank_act_mod
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 本服充值消费活动
%%%------------------------------------
-module(lib_consume_rank_act_mod).

-compile(export_all).

-include("errcode.hrl").
-include("language.hrl").
-include("common.hrl").
-include("consume_rank_act.hrl").
-include("record.hrl").
-include("relationship.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("custom_act.hrl").

make_record(rank_role, [RankType, SubType, RoleId, Value, SecVal, TrdVal, Time]) ->
    #rank_role{
        role_key  = {RankType, RoleId},        % {RankType, RoleId}
        rank_type = RankType,                  % 榜单类型
        sub_type  = SubType,                   % 活动子类型
        role_id   = RoleId,                    % 角色id
        value     = Value,                     % 排序值
        second_value = SecVal,
        third_value = TrdVal,
        time      = Time                       % 时间戳
    }.

init() ->
    %% 个人数据
    List = db_rank_role_select(),
    RoleList = [make_record(rank_role, T) || T <- List],
    %?PRINT("~p~n", [RoleList]),
    RoleMaps = get_role_map(RoleList),
    % 个人榜单
    RankMaps = sort_rank_maps(RoleMaps),
    RoleLimitList = clean_redundant_rank_data_from_db(rank_role, RankMaps),
    RankLimit = maps:from_list(RoleLimitList),
    ?PRINT("init RankMaps : ~p~n", [RankMaps]),
    ?PRINT("init RankLimit : ~p~n", [RankLimit]),
    #rank_state{role_maps = RoleMaps, rank_maps = RankMaps, rank_limit = RankLimit}.

%% 获得标准排序Maps(被截取了长度) Key:{RankType, ActType} Value:[#rank_role{}]
% get_standard_sort_rank_maps(rank_role, RoleMaps) ->
%     MapsKeyList = sort_rank_maps(RoleMaps),
%     MapsKeyList.

get_role_map(RoleList) ->
    F = fun(#rank_role{rank_type = RankType, sub_type = SubType} = RankRole, Maps) ->
        case maps:get({RankType, SubType}, Maps, false) of
            false -> NewList = [RankRole];
            TmpL -> NewList = [RankRole | TmpL]
        end,
        maps:put({RankType, SubType}, NewList, Maps)
        end,
    RoleMaps = lists:foldl(F, maps:new(), RoleList),
    RoleMaps.

%% 对Maps的Value排序
sort_rank_maps(Maps) ->
    F = fun({RankType, SubType}, List) ->
        RankList = sort_rank_list(List),
        NewRankList = set_rank_list(RankType, SubType, RankList),
        MaxRankLen = lib_consume_rank_act:get_max_len(RankType, SubType),
        LastRankList = lists:sublist(NewRankList, MaxRankLen),
        LastRankList
    end,
    NewMaps = maps:map(F, Maps),
    NewMaps.

%% 根据排序值排序
sort_rank_list(List) ->
    F = fun(A, B) ->
        if
            is_record(A, rank_role) ->
                if
                    A#rank_role.value > B#rank_role.value -> true;
                    A#rank_role.value == B#rank_role.value ->
                        A#rank_role.time =< B#rank_role.time;
                    true -> false
                end;
            true ->
                false
        end
        end,
    NewList = lists:sort(F, List),
    NewList.
    % F1 = fun(Member, {TempList, Value}) ->
    %     if
    %         is_record(Member, rank_role) ->
    %             NewMember = Member#rank_role{rank = Value},
    %             NewTempList = [NewMember | TempList],
    %             {NewTempList, Value + 1};
    %         true ->
    %             {TempList, Value}
    %     end
    %      end,
    % {NewRankList, _} = lists:foldl(F1, {[], 1}, NewList),
    % lists:reverse(NewRankList).

%% 设置排名
set_rank_list(RankType, SubType, RankList) ->
    ScoreRankCon1 = lib_consume_rank_act:get_score_rank_condition(RankType, SubType),
    ScoreRankCon = lists:keysort(1, ScoreRankCon1),
    NewRankList = set_rank(RankList, ScoreRankCon, 1, []),
    NewRankList.

set_rank([], _ScoreRankCon, _InitRank, List)-> lists:reverse(List);
set_rank([RankRole|T], ScoreRankCon, InitRank, List)->
    #rank_role{value = Score} = RankRole,
    case check_enter_rank(Score, ScoreRankCon) of
        false-> 
            set_rank(T, ScoreRankCon, InitRank, List);
        {RankMin, _RankMax}->
            case InitRank >= RankMin of
                true-> set_rank(T, ScoreRankCon, InitRank+1, [RankRole#rank_role{rank=InitRank}|List]);
                false-> set_rank(T, ScoreRankCon, RankMin+1, [RankRole#rank_role{rank=RankMin}|List])
            end
    end.

check_enter_rank(_Score, []) -> false;
check_enter_rank(Score, [{RankMin, RankMax, ScoreNeed}|ScoreRankCon]) ->
    case Score >= ScoreNeed of 
        true ->
            {RankMin, RankMax};
        _ ->
            check_enter_rank(Score, ScoreRankCon)
    end.

%% 阈值
clean_redundant_rank_data_from_db(rank_role, RankMaps) ->
    MapsKeyList = maps:to_list(RankMaps),
    F = fun
            ({{RankType, SubType}, []}) ->
                Limit = lib_consume_rank_act:get_rank_limit(RankType, SubType),
                {{RankType, SubType}, Limit};
            ({{RankType, SubType}, RankList}) ->
                RankMax = lib_consume_rank_act:get_max_len(RankType, SubType),
                Limit = lib_consume_rank_act:get_rank_limit(RankType, SubType),
                case length(RankList) >= RankMax of
                    true ->
                        RankLast = lists:last(RankList),
                        Value = RankLast#rank_role.value,
                        {{RankType, SubType}, max(Value, Limit)};
                    false ->
                        {{RankType, SubType}, Limit}
                end
        end,
    lists:map(F, MapsKeyList).


refresh_common_rank(State, RankType, SubType, #rank_role{role_id = RoleId, value = _Value} = RankRole) ->
    %?PRINT("~p~n", [_Value]),
    #rank_state{rank_maps = RankMaps, role_maps = RoleMaps, rank_limit = RankLimit} = State,
    RankList = maps:get({RankType, SubType}, RankMaps, []),
    %% 更新个人值maps 增加值
    RoleList = maps:get({RankType, SubType}, RoleMaps, []),
    NewRoleList = lists:keystore({RankType, RoleId}, #rank_role.role_key, RoleList, RankRole),
    NewRoleMaps = maps:put({RankType, SubType}, NewRoleList, RoleMaps),
    {NewRankList, NewRankLimit} = do_refresh_rank_help(RankList, RankType, SubType, RankRole, RankLimit),
    NewRankMaps = maps:put({RankType, SubType}, NewRankList, RankMaps),
    NewState = State#rank_state{rank_maps = NewRankMaps, role_maps = NewRoleMaps, rank_limit = NewRankLimit},
    ?PRINT("refresh_common_rank NewRankMaps : ~p~n", [NewRankMaps]),
    ?PRINT("refresh_common_rank NewRankLimit : ~p~n", [NewRankLimit]),
    %%--------db-------------
    db_rank_role_save(RankRole),
    {ok, NewState}.

%% 先判断list中是否存在key和value都相等的玩家，存在则跟新数据，不存在则将其进行队列排序：将其与队
%% 尾比较，若小于队尾并且队列长度大于最长长度，则丢弃，否则将其加入队列，排序并保证队列长度为最大
%% 队列长度，发送数据的时候，先截取显示长度，再判断是否满足limit，满足条件的才加入发送队列。
%% 时刻保证，排序之后队列和数据库保存的数据为整个服的前N，然后在这之中选择发送
do_refresh_rank_help(RankList, RankType, SubType, RankRole, RankLimit) ->
    #rank_role{role_key = RoleKey, value = Value} = RankRole,
    %% 阈值
    Limit = lib_consume_rank_act:get_rank_limit(RankType, SubType),
    %% 最大长度
    MaxRankLen = lib_consume_rank_act:get_max_len(RankType, SubType),
    Temp = maps:get({RankType, SubType}, RankLimit, Limit),
    %% 最终阈值
    LastLimit = max(Temp, Limit),
    case RankList == [] of
        true ->
            if
                Value >= LastLimit ->
                    NewRankList = [RankRole],
                    LastList = set_rank_list(RankType, SubType, NewRankList),
                    {LastList, RankLimit};
                true ->
                    {[], RankLimit}
            end;
        false ->
            case lists:keytake(RoleKey, #rank_role.role_key, RankList) of 
                {value, _, LeftList} ->
                    IsExistKey = true;
                _ ->
                    IsExistKey = false, LeftList = RankList
            end,
            % 是否需要排序
            case Value >= LastLimit orelse IsExistKey of
                false ->
                    {RankList, RankLimit};
                true ->
                    NewRankList2 = [RankRole|LeftList],
                    % 排序
                    NewRankList1 = sort_rank_list(NewRankList2),
                    NewRankList = set_rank_list(RankType, SubType, NewRankList1),
                    case length(NewRankList) > MaxRankLen of
                        true ->
                            LastList = lists:sublist(NewRankList, MaxRankLen),
                            LastRankRole = lists:last(LastList),
                            #rank_role{value = TempLastLimit} = LastRankRole,
                            NewLastLimit = max(TempLastLimit, Limit);
                        false -> 
                            LastList = NewRankList,
                            NewLastLimit = Limit
                    end,
                    NewRankLimit = maps:put({RankType, SubType}, NewLastLimit, RankLimit),
                    {LastList, NewRankLimit}
            end
    end.

send_rank_list(State, ActType, SubType, RoleId, Sid) ->
    %% 配置的最大长度和上榜阈值
   % ?PRINT("~p~n", [State]),
    RankType = lib_consume_rank_act:change_rank_type(ActType),
    Limit = lib_consume_rank_act:get_rank_limit(RankType, SubType),
    MaxRankLen = lib_consume_rank_act:get_max_len(RankType, SubType),
    #rank_state{rank_maps = RankMaps, role_maps = RoleMaps} = State,
    %% 自己在活动期间的值
    RoleList = maps:get({RankType, SubType}, RoleMaps, []),
    case lists:keyfind({RankType, RoleId}, #rank_role.role_key, RoleList) of
        #rank_role{value = SelValue} -> skip;
        _ -> SelValue = 0
    end,
    RankList = maps:get({RankType, SubType}, RankMaps, []),
    case lists:keyfind({RankType, RoleId}, #rank_role.role_key, RankList) of
        #rank_role{rank = RoleRank} -> skip;
        _ -> RoleRank = 0
    end,
    %?PRINT("~p~n", [List1]),
    F = fun(#rank_role{role_id = TmpRoleId, value = Value, rank = Rank}) ->
        #figure{name = Name} = lib_role:get_role_figure(TmpRoleId),
        {TmpRoleId, Name, Value, Rank}
    end,
    List = lists:map(F, RankList),
    % ?PRINT("send_rank_list List : ~p~n", [List]),
    % ?MYLOG(RankType == ?RANK_TYPE_RECHARGE, "cxd_rec_rank", "send_rank_list List : ~p~n", [List]),
    Sum = length(List),
    case Sid =:= none of 
        true ->
            Bin = pt_224:write(22405, [?SUCCESS, ActType, SubType, RankType, 0, SelValue, 0, MaxRankLen, Limit, List]),
            lib_server_send:send_to_uid(RoleId, Bin);
        false ->
            lib_server_send:send_to_sid(Sid, pt_224, 22405, [?SUCCESS, ActType, SubType, RankType, RoleRank, SelValue, Sum, MaxRankLen, Limit, List])
    end.

record_champion(State, [RankType, RoleId, GoodsTypeId]) ->
    #rank_state{champion_list = ChampionList} = State,
    NowTime = utime:unixtime(),
    NewChampionList = lists:keystore(RankType, 1, ChampionList, {RankType, RoleId, GoodsTypeId, NowTime}),
    case lists:keyfind(?RANK_TYPE_RECHARGE, 1, NewChampionList) of 
        {_, RoleIdRecharge, GoodsTypeIdRecharge, TimeRecharge} ->
            case lists:keyfind(?RANK_TYPE_CONSUME, 1, NewChampionList) of 
                {_, RoleIdConsume, GoodsTypeIdConsume, TimeConsume} ->
                    case RoleIdConsume == RoleIdRecharge andalso GoodsTypeIdConsume == GoodsTypeIdRecharge andalso abs(TimeConsume - TimeRecharge) < 120 of 
                        true -> %% 消费榜和充值榜都得第一名，得奖时间在2分钟之内
                            %% 发送一个特殊奖励
                            Title = utext:get(3310071),
                            Content = utext:get(3310072),
                            lib_mail_api:send_sys_mail([RoleIdConsume], Title, Content, [{?TYPE_GOODS, GoodsTypeIdConsume, 1}]),
                            ok;
                        _ ->
                            ok
                    end,
                    LastChampionList = [];
                _ ->
                   LastChampionList = NewChampionList 
            end;
        _ ->
            LastChampionList = NewChampionList
    end,
    ?PRINT("record_champion LastChampionList : ~p~n", [LastChampionList]),
    {ok, State#rank_state{champion_list = LastChampionList}}.


clear_recharge_rank_act(State, EndType, SubType, WLv) ->
    clear_act_by_rank_type(State, EndType, ?RANK_TYPE_RECHARGE, SubType, WLv).

clear_consume_rank_act(State, EndType, SubType, WLv) ->
    clear_act_by_rank_type(State, EndType, ?RANK_TYPE_CONSUME, SubType, WLv).

%% 发送本服充值榜奖励（活动结束时触发）
clear_act_by_rank_type(State, EndType, RankType, SubType, WLv) ->
    #rank_state{rank_maps = RankMaps, role_maps = RoleMaps} = State,
    RankList = maps:get({RankType, SubType}, RankMaps, []),
    RoleList = maps:get({RankType, SubType}, RoleMaps, []),
    Pred = fun(#rank_role{role_id = RoleId}) -> not lists:keymember(RoleId, #rank_role.role_id, RankList) end,
    FiltList = lists:filter(Pred, RoleList),
    case EndType of
        ?CUSTOM_ACT_STATUS_CLOSE ->
            %% 排行奖励
            spawn(fun()-> util:multiserver_delay(30, ?MODULE, send_rank_reward, [RankList, RankType, SubType, WLv, 1]) end),
            %% 参与奖励
            spawn(fun()-> util:multiserver_delay(30, ?MODULE, send_partake_reward, [FiltList, RankType, SubType]) end);
        _ -> skip
    end,
    %% 清空活动数据
    NewState = clear_act_data(State, RankType, SubType),
    case lists:keyfind(1, #rank_role.rank, RankList) of 
        #rank_role{role_id = RoleId} ->
            case lib_consume_rank_act:get_dual_champion(RankType, SubType) of 
                {dual_champion, GoodsTypeId} ->
                    mod_consume_rank_act:record_champion([RankType, RoleId, GoodsTypeId]);
                _ ->
                    skip
            end;
        _ ->
            skip
    end,
    {ok, NewState}.

send_rank_reward([], _RankType, _SubType, _, _) -> skip;
send_rank_reward([RankRole | RankList], RankType, SubType, WLv, Count) when is_record(RankRole, rank_role) ->
    #rank_role{role_id = RoleId, rank = Rank, value = Value} = RankRole,
     %%传闻
    #figure{name = Name, career = Career, sex = Sex, lv = Lv} = lib_role:get_role_figure(RoleId),
    case Rank =< 3 andalso Rank > 0 of 
        true ->
            case RankType of
                ?RANK_TYPE_RECHARGE -> lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 16, [Name, RoleId, Rank]);
                ?RANK_TYPE_CONSUME ->  lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 19, [Name, RoleId, Rank])
            end;
        _ ->
            skip
    end,
    case lib_consume_rank_act:get_rank_reward(RankType, SubType, Rank, [WLv, Lv, Career, Sex]) of
        [] -> send_rank_reward(RankList, RankType, SubType, WLv, Count);
        Reward when is_list(Reward) ->
            case RankType of
                ?RANK_TYPE_RECHARGE ->  Title = ?LAN_MSG(3310020), Content = uio:format(?LAN_MSG(3310021), [Rank]);
                ?RANK_TYPE_CONSUME ->  Title = ?LAN_MSG(3310027), Content = uio:format(?LAN_MSG(3310028), [Rank])
            end,
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
            %?PRINT("send_rank_reward Rank : ~p~n", [{Rank, Reward}]),
            %% 日志
            case RankType of
                ?RANK_TYPE_RECHARGE -> lib_log_api:log_recharge_rank_act(RoleId, Rank, Value, Reward);
                ?RANK_TYPE_CONSUME -> lib_log_api:log_consume_rank_act(RoleId, Rank, Value, Reward)
            end,
            case Count rem 20 of
                0 -> timer:sleep(20);
                _ -> skip
            end,
            send_rank_reward(RankList, RankType, SubType, WLv, Count + 1);
        _ -> skip
    end;
send_rank_reward(_, _, _, _, _) -> skip.

send_partake_reward(RankList, RankType, SubType) ->
    case lib_consume_rank_act:get_partake_reward(RankType, SubType) of
        [] ->
            ok;
        Reward when is_list(Reward) ->
            send_partake_reward_do(RankList, RankType, SubType, Reward, 1);
        _ ->
            ok
    end.

send_partake_reward_do([], _RankType, _SubType, _Reward, _) -> ok;
send_partake_reward_do([RankRole|RankList], RankType, SubType, Reward, Count) ->
    #rank_role{role_id = RoleId, rank = Rank, value = Value} = RankRole,
    Title = ?IF(RankType =:= ?RANK_TYPE_RECHARGE, ?LAN_MSG(3310020), ?LAN_MSG(3310027)),
    Content = ?IF(RankType =:= ?RANK_TYPE_RECHARGE, utext:get(3310024), utext:get(3310066)), 
    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
    %?PRINT("send_partake_reward Reward : ~p~n", [Reward]),
    %% 日志
    case RankType of
        ?RANK_TYPE_RECHARGE -> lib_log_api:log_recharge_rank_act(RoleId, Rank, Value, Reward);
        ?RANK_TYPE_CONSUME -> lib_log_api:log_consume_rank_act(RoleId, Rank, Value, Reward)
    end,
    case Count rem 20 of
        0 -> timer:sleep(20);
        _ ->skip
    end,
    send_partake_reward_do(RankList, RankType, SubType, Reward, Count+1).

%% 结算本次活动（活动结束时触发）
clear_act_data(State, RankType, SubType) ->
    #rank_state{rank_maps = RankMaps, role_maps = RoleMaps, rank_limit = Limit} = State,
    NewRankMaps = maps:remove({RankType, SubType}, RankMaps),
    NewRoleMaps = maps:remove({RankType, SubType}, RoleMaps),
    NewLimit = maps:remove({RankType, SubType}, Limit),
    NewState = State#rank_state{rank_maps = NewRankMaps, role_maps = NewRoleMaps, rank_limit = NewLimit},
    db:execute(io_lib:format(?sql_rank_role_clear, [RankType, SubType])),
    NewState.

%% 充值冲榜限制
limit_shield_recharge(State, RankType, SubType, RoleId) ->
    db_rank_delete_by_id(RankType, SubType, RoleId),
    #rank_state{role_maps = RoleMaps} = State,
    NewRoleMaps = del_data(role_list, [{RankType, SubType}, RoleMaps, {RankType, RoleId}]),
    %% 个人榜单
    NewRankMaps = sort_rank_maps(NewRoleMaps),
    RoleLimitList = clean_redundant_rank_data_from_db(rank_role, NewRankMaps),
    RankLimit = maps:from_list(RoleLimitList),
    NewState = #rank_state{role_maps = NewRoleMaps, rank_maps = NewRankMaps, rank_limit = RankLimit},
    ActType = lib_consume_rank_act:change_act_type(RankType),
    send_rank_list(NewState, ActType, SubType, RoleId, none),
    NewState.

%% ================== 数据结构操作 ==================
%% 存储
save_data(rank_list, [MapKey, RankMaps, ListKey, NewRankRole]) ->
    RankList = maps:get(MapKey, RankMaps, []),
    NewRankList = lists:keystore(ListKey, #rank_role.role_key, RankList, NewRankRole),
    maps:put(MapKey, NewRankList, RankMaps);
save_data(role_list, [MapKey, RoleMaps, ListKey, NewRankRole]) ->
    RoleList = maps:get(MapKey, RoleMaps, []),
    NewRoleList = lists:keystore(ListKey, #rank_role.role_key, RoleList, NewRankRole),
    maps:put(MapKey, NewRoleList, RoleMaps);
save_data(_, _) -> skip.

%% 删除
del_data(rank_list, [MapKey, RankMaps, ListKey]) ->
    RankList = maps:get(MapKey, RankMaps, []),
    NewRankList = lists:keydelete(ListKey, #rank_role.role_key, RankList),
    maps:put(MapKey, NewRankList, RankMaps);
del_data(role_list, [MapKey, RoleMaps, ListKey]) ->
    RoleList = maps:get(MapKey, RoleMaps, []),
    NewRoleList = lists:keydelete(ListKey, #rank_role.role_key, RoleList),
    maps:put(MapKey, NewRoleList, RoleMaps);
del_data(_, _) -> skip.


%%-----------------db-----------------------%%

db_rank_role_select() ->
    Sql = io_lib:format(?sql_rank_role_select, []),
    db:get_all(Sql).

db_rank_role_save(RankRole) ->
    #rank_role{
        rank_type = RankType,
        sub_type  = SubType,
        role_id   = RoleId,
        value     = Value,
        second_value = SecVal,
        third_value = TrdVal,
        time      = Time
    } = RankRole,
    Sql = io_lib:format(?sql_rank_role_save,
        [RankType, SubType, RoleId, Value, SecVal, TrdVal, Time]),
    db:execute(Sql).

db_rank_delete_by_id(RankType, SubType, RoleId) ->
    Sql = io_lib:format(?sql_rank_role_delete_by_role_id, [RankType, SubType, RoleId]),
    db:execute(Sql).

