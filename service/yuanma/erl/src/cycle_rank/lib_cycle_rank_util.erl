%% ---------------------------------------------------------------------------
%% @doc lib_cycle_rank_util

%% @author  lianghaihui
%% @email   1457863678@qq.com
%% @since   2022/03/18
%% @desc    循环冲榜##工具函数库
%% ---------------------------------------------------------------------------

-module(lib_cycle_rank_util).

%% API
-compile(export_all).

-include("common.hrl").
-include("server.hrl").
-include("cycle_rank.hrl").
-include("figure.hrl").


%% 根据配置的时间、是否属于昨天结算的数据
is_kf_clear(Type, SubType, AllOpenActList) ->
    RankInfo = lists:keyfind({Type, SubType}, #base_cycle_rank_info.id, AllOpenActList),
    case RankInfo == false of
        true->
            true;
        _ ->
            IsOpen = kf_check_is_open(RankInfo),
            IsShow = kf_check_is_show(RankInfo),
            %% 判断IsOpen没开并且IsShow没展示
            IsOpen =/= true andalso IsShow =/= true
    end.

is_kf_clear(RankInfo) ->
    case RankInfo == false of
        true-> true;
        _ ->
            IsOpen = kf_check_is_open(RankInfo),
            IsShow = kf_check_is_show(RankInfo),
            %% 判断IsOpen没开并且IsShow没展示
            IsOpen =/= true andalso IsShow =/= true
    end.

%% 跨服专用 检测活动是否开启
%% true 处于开启阶段，false 关闭
%% 跨服上的活动不需要检测开发天数
kf_check_is_open(RankInfo) ->
    #base_cycle_rank_info{start_time = StartTime, end_time = EndTime} = RankInfo,
    check_condition({open_time, StartTime, EndTime}).

%% 跨服专用 检测活动是否结算且处于展示榜单时期
%% 跨服上的活动不需要检测开发天数
kf_check_is_show(RankInfo) ->
    #base_cycle_rank_info{start_time = StartTime, end_time = EndTime} = RankInfo,
    NowSec = utime:unixtime(),
    ShowDay = 1,
    ShowEndTime = EndTime + ShowDay * 86400,
    NowSec < ShowEndTime andalso NowSec > StartTime.


game_is_clear(Type, SubType, AllActList) ->
    ActInfo = lists:keyfind({Type, SubType}, #base_cycle_rank_info.id, AllActList),
    case ActInfo of
        false ->
            true;
        _ ->
            IsOpen = game_check_is_open(ActInfo),
            IsShow = game_check_is_show(ActInfo),
            IsOpen =/= true andalso IsShow =/= true
    end.


game_check_is_open(RankInfo) ->
    #base_cycle_rank_info{
        start_time = StartTime,
        end_time = EndTime,
        open_day = OpenDay,
        open_over = CloseDay
    } = RankInfo,
    Condition = [{open_day, OpenDay, CloseDay}, {open_time, StartTime, EndTime}],
    check_condition_list(Condition).

game_check_is_show(RankInfo) ->
    #base_cycle_rank_info{
        open_over = OverDay,
        open_day = OpenDay,
        start_time = StartTime,
        end_time = EndTime
    } = RankInfo,
    NowSec = utime:unixtime(),
    Condition = [{open_day, OpenDay, OverDay}, {show_time, NowSec, StartTime, EndTime}],
    check_condition_list(Condition).

%% 对数据库所有类型的冲榜类型数据进行排行
sort_all_type_rank([], _AllOpenActList, SortList) ->
    SortList;
sort_all_type_rank([RankTypeData|Tail], AllOpenActList, SortList) ->
    #rank_type{id = {Type, SubType}, rank_role_list = RankList } = RankTypeData,
    case lib_cycle_rank_util:is_kf_clear(Type, SubType, AllOpenActList) of
        true->
            %% 清除不在开启时间段且不处于展示期的数据
            Sql = io_lib:format(?sql_delete_cycle_rank_info, [Type, SubType]),
            db:execute(Sql),
            sort_all_type_rank(Tail, AllOpenActList, SortList);
        false->
            {NewRankList, LimitScore} = sort_rank_list(RankList, Type, SubType),
            NewRankTypeData = RankTypeData#rank_type{rank_role_list = NewRankList, score_limit = LimitScore},
            sort_all_type_rank(Tail, AllOpenActList, [NewRankTypeData|SortList])
    end.

%% 针对某种确切的榜单数据进行排行
sort_rank_list([], _Type, _SubType) ->
    {[], 0};
sort_rank_list(RankList , Type, SubType) ->
    NewRankList = sort_rank_list(RankList),
    FixRankList = set_role_ranking(NewRankList, Type, SubType, 1, []),
    Max = get_rank_max(Type, SubType),
    {LastRankList, LastScore} = get_limit_score(Type, SubType, FixRankList, Max),
    {LastRankList, LastScore}.

%% 按积分排序，积分相同按时间
sort_rank_list(RankList)->
    F = fun(RoleA,RoleB)->
        if
            RoleA#rank_role.score > RoleB#rank_role.score -> true;
            RoleA#rank_role.score < RoleB#rank_role.score -> false;
            RoleA#rank_role.last_time < RoleB#rank_role.last_time -> true;
            true ->
                false
        end
    end,
    lists:sort(F,RankList).

%% 设置玩家名次
set_role_ranking([], _Type, _SubType, _InitRank, List) ->
    lists:reverse(List);
set_role_ranking([RankRole|Tail], Type, SubType, InitRank, List) ->
    #rank_role{score = Score} = RankRole,
    case lib_cycle_rank_util:check_enter_rank(Type, SubType, Score) of
        false->
            set_role_ranking(Tail, Type, SubType, InitRank, List);
        {RankMin,_RankMax}->
            case InitRank >= RankMin of
                true->
                    set_role_ranking(Tail, Type, SubType, InitRank + 1, [RankRole#rank_role{rank=InitRank}|List]);
                false->
                    set_role_ranking(Tail, Type, SubType, RankMin + 1, [RankRole#rank_role{rank=RankMin}|List])
            end
    end.

%% 获取榜单长度
get_rank_max(Type,SubType)->
    List = data_cycle_rank:get_all_rank_max(Type, SubType),
    case List == [] of
        true-> 0;
        false-> lists:max(List)
    end.

%% 获取上限内榜单和最低分数
get_limit_score(Type, SubType, List, Max)->
    Length = length(List),
    case Length >= Max of
        true->
            SortList = lists:keysort(#rank_role.rank, List),
            {NRankList, DelList} = lists:split(Max, SortList),
            LastRole = lists:last(NRankList),
            LastScore = LastRole#rank_role.score,
            lib_cycle_rank_util:db_delete_cycle_rank_role_id(Type, SubType, DelList),
            {NRankList, LastScore};
        false-> {List,0}
    end.

%% ===========================================
%% current_function
%% ===========================================

check_condition_list([]) ->
    true;
check_condition_list([T|Condition]) ->
    case check_condition(T) of
        true ->
            check_condition_list(Condition);
        false ->
            false
    end.

%% 检测活动是否、处于开启时间段
check_condition({open_day, StartDay, OverDay}) ->
    Now = util:get_open_day(),
    Now >= StartDay andalso Now < OverDay;
%% 检测活动是否、处于开启时间段
check_condition({open_time, StartTime, EndTime}) ->
    NowSec = utime:unixtime(),
    NowSec >= StartTime andalso NowSec =< EndTime;
%% 检测是否处于展示期间
check_condition({show_time, NowSec, StartTime, EndTime}) ->
    ShowDay = 1,
    ShowEndTime = EndTime + ShowDay * 86400,
    NowSec < ShowEndTime andalso NowSec > StartTime.

gm_cycle_rank(Type) ->
    case Type of
        1 ->
            mod_cycle_rank_local:get_state();
        _ ->
            mod_cycle_rank_local:cast_to_cluster(Type)
    end.

%% 发送具体变化给对应的玩家
send_rank_change_info(State, _RoleId, [_RankType, 0, _NextRank, _NexValue, _], _ServerId) ->
    State;
send_rank_change_info(State, RoleId, [RankType, SendType, NextRank, NexValue, _], ServerId) ->
    case State of
        #cluster_rank_status{ role_send_time_limit = AllSendTimeLimitMap } ->
            IsLocal = 0;
        #game_rank_status{ role_send_time_limit = AllSendTimeLimitMap } ->
            IsLocal = 1
    end,
    RoleMap = case maps:find(RankType, AllSendTimeLimitMap) of
                  {ok, RoleMap1} -> RoleMap1;
                  error -> #{}
              end,
    Cd = case data_cycle_rank:get_kv_cfg(send_change_info_cd) of
             Num when is_integer(Num) -> Num;
             _ -> ?ONE_MIN * 10
         end,
    NextTime = utime:unixtime() + Cd, % 间隔30秒
    {Type, SubType} = RankType,
    FixSendData = [Type, SubType, SendType, NextRank, NexValue],
    %% 通知游戏节点的玩家
    {ok, BinData} = pt_227:write(22705, FixSendData),
    case IsLocal of
        0 ->
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            NewRoleMap = maps:put(RoleId, NextTime, RoleMap),
            NewLimitMap = maps:put(RankType, NewRoleMap, AllSendTimeLimitMap),
            State#cluster_rank_status{ role_send_time_limit = NewLimitMap};
        _ ->
            lib_server_send:send_to_uid(RoleId, BinData),
            NewRoleMap = maps:put(RoleId, NextTime, RoleMap),
            NewLimitMap = maps:put(RankType, NewRoleMap, AllSendTimeLimitMap),
            State#game_rank_status{ role_send_time_limit = NewLimitMap}
    end.

%% 通知变化时，不管上榜与否都会发送距离目标奖励
send_num_to_reach_reward(State, RankType, RoleId, RoleVal, ServerId) ->
    {Type, SubType} = RankType,
    NowSec = utime:unixtime(),
    InLimit = not check_send_time_limit(State, RankType, RoleId, NowSec),
    if
        InLimit -> State;
        true ->
            %% 计算变化类型1的，提示该名玩家提高多少分可领取目标奖励
            AllReachIds = data_cycle_rank:get_reach_reward_id_list(Type, SubType),
            Fun = fun(ReachId, AccL) ->
                #base_reach_reward_info{ need = Need } = data_cycle_rank:get_reach_reward_info(Type, SubType, ReachId),
                case Need > RoleVal of
                    true -> [{ReachId, Need}|AccL];
                    false -> AccL
                end
                  end,
            Filter = lists:foldl(Fun, [], AllReachIds),
            case Filter of
                [] -> State;
                _ ->
                    {NextReachId, NextNeed} = lists:min(Filter),
                    Diff = NextNeed - RoleVal,
                    case Diff > 0 of
                        true ->
                            lib_cycle_rank_util:send_rank_change_info(State, RoleId, [RankType, ?CYCLE_RANK_NOTIFY_TYPE_1, NextReachId,  Diff, 0], ServerId);
                        false ->
                            State
                    end
            end
    end.

check_send_time_limit(State, RankType, RoleId, NowTime) ->
    case State of
        #cluster_rank_status{ role_send_time_limit = AllSendTimeLimitMap } -> ok;
        #game_rank_status{ role_send_time_limit = AllSendTimeLimitMap} -> ok
    end,
    RoleMap = case maps:find(RankType, AllSendTimeLimitMap) of
                  {ok, RoleMap1} -> RoleMap1;
                  error -> #{}
              end,
    case maps:find(RoleId, RoleMap) of
        {ok, Val} ->
            NowTime >= Val;
        error ->
            true
    end.

%% 检测是否可以进榜
check_enter_rank(Type, SubType, Score) ->
    Id = data_cycle_rank:get_enter_rank_list_id(Type, SubType, Score),
    case Id == [] orelse Id == 0 of
        true->
            false;
        false->
            #base_cycle_rank_reward{ rank_min = RankMin, rank_max = RankMax} = data_cycle_rank:get_rank_reward(Type, SubType, Id),
            {RankMin,RankMax}
    end.

%% ============================================
%% db_function
%% ============================================

%% 榜单玩家的数据更新
db_update_cycle_rank_role(Type, SubType, RankRole) ->
    #rank_role{
        id = RoleId
        ,server_id = ServerId
        ,platform = Platform
        ,server_num = ServerNum
        ,score = Score
        ,figure = #figure{ name=Name }
        ,last_time = Time
    } = RankRole,
    NameF = util:fix_sql_str(Name),
    Sql = io_lib:format(?sql_cycle_rank_role_replace, [RoleId, Type, SubType, ServerId, Platform, ServerNum, NameF, Score, Time]),
    db:execute(Sql).

%% 删除某个玩家的榜单数据
db_delete_cycle_rank_role_id(_Type, _SubType, []) ->
    ok;
db_delete_cycle_rank_role_id(Type, SubType, [#rank_role{id = RoleId}|Tail]) ->
    timer:sleep(100),
    Sql = io_lib:format(?sql_delete_cycle_rank_info_by_role_id, [Type, SubType, RoleId]),
    db:execute(Sql),
    db_delete_cycle_rank_role_id(Type, SubType, Tail).

%% 更新玩家循环冲榜数据 - 领取达标奖励时调用
db_update_player_cycle_rank_reward(PlayerId, NewRewardState, NewGotList, Type, SubType) ->
    State = util:term_to_string(NewRewardState),
    GotList = util:term_to_string(NewGotList),
    Sql = io_lib:format(?sql_update_player_cycle_rank_reward, [State, GotList, PlayerId, Type, SubType]),
    db:execute(Sql).

%% 更新玩家循环冲榜数据 - 新增达标奖励时调用
db_updata_player_cycle_rank_state(PlayerId, NewScore, NewRewardState, Type, SubType) ->
    State = util:term_to_string(NewRewardState),
    Sql = io_lib:format(?sql_update_player_cycle_rank_state, [State, NewScore, PlayerId, Type, SubType]),
    db:execute(Sql).

%% 更新玩家循环冲榜数据 - 第一次插入玩家数据调用
db_insert_player_cycle_rank_info(PlayerId, PlayerCycleInfo) ->
    #status_cycle_rank_info{
        type = Type, sub_type = SubType, score = Score,
        reward_state = State, reward_got = GotList, other = Other, end_time = EndTime
    } = PlayerCycleInfo,
    State2 = util:term_to_string(State),
    GotList2 = util:term_to_string(GotList),
    Other2 = util:term_to_string(Other),
    Args = [PlayerId, Type, SubType, Score, State2, GotList2, Other2, EndTime],
    Sql = io_lib:format(?sql_replace_player_cycle_rank_info, Args),
    db:execute(Sql).

%% 更新玩家循环冲榜数据 - 补发达标奖励时调用
db_update_player_cycle_rank_other(PlayerId, NewRewardState, NewGotList, NewOther, Type, SubType) ->
    State = util:term_to_string(NewRewardState),
    GotList = util:term_to_string(NewGotList),
    Other = util:term_to_string(NewOther),
    Sql = io_lib:format(?sql_update_player_cycle_rank_other, [State, GotList, Other, PlayerId, Type, SubType]),
    db:execute(Sql).

%% 删除玩家数据
%% 更新玩家循环冲榜数据 - 补发达标奖励时调用
db_delete_player_cycle_rank_info(PlayerId, Type, SubType) ->
    Sql = io_lib:format(?sql_delete_player_cycle_info_by_type, [PlayerId, Type, SubType]),
    db:execute(Sql).