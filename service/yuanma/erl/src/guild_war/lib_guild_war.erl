%%-----------------------------------------------------------------------------
%% @Module  :       lib_guild_war
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-04
%% @Description:    公会争霸逻辑模块
%%-----------------------------------------------------------------------------
-module(lib_guild_war).

-include("guild_war.hrl").
-include("common.hrl").

-export([
    get_battle_round/0
    , put_battle_round/1
    , get_match_id/0
    , get_room_id/0
    , get_mon_create_key_id/0
    , get_next_time/1
    , sort/3
    , pack_division_list/3
    , classify_guild_by_wintimes/2
    , send_error_code/2
    , get_born_xy/1
    , count_ranking_score/0
    , get_break_reward/2
    , format_time/1
    , get_key_id/1
    , log_guild_war_division/1
    , get_act_duration/0
    ]).

%% 获取当前是第几轮比赛
get_battle_round() ->
    case get("battle_round") of
        undefined -> 0;
        Val -> Val
    end.

put_battle_round(Val) ->
    put("battle_round", Val).

%% 获取匹配id 不进数据库在自己进程维护就行
get_match_id() ->
    case get("match_last_id") of
        undefined ->
            LastId = 1,
            put("match_last_id", LastId),
            LastId;
        LastId ->
            put("match_last_id", LastId + 1),
            LastId + 1
    end.

%% 获取房间号id 不进数据库在自己进程维护就行
get_room_id() ->
    case get("room_last_id") of
        undefined ->
            LastId = 1,
            put("room_last_id", LastId),
            LastId;
        LastId ->
            put("room_last_id", LastId + 1),
            LastId + 1
    end.

%% 获取怪物的创建key
get_mon_create_key_id() ->
    case get("mon_create_key_id") of
        undefined ->
            LastId = 1,
            put("mon_create_key_id", LastId),
            LastId;
        LastId ->
            put("mon_create_key_id", LastId + 1),
            LastId + 1
    end.

%% 通过服务器id进行拼接唯一key，合服的时候直接合并表
get_key_id(Type) ->
    SerId = config:get_server_id(),
    do_get_key_id(Type, SerId).

do_get_key_id(?GLOBAL_KEY_VAL_COMFIRM_STATUS, SerId) ->
    <<AutoId:48>> = <<SerId:16, 1:32>>, AutoId;
do_get_key_id(?GLOBAL_KEY_VAL_GAME_TIMES, SerId) ->
    <<AutoId:48>> = <<SerId:16, 2:32>>, AutoId;
do_get_key_id(?GLOBAL_KEY_VAL_STREAK_TIMES, SerId) ->
    <<AutoId:48>> = <<SerId:16, 3:32>>, AutoId;
do_get_key_id(?GLOBAL_KEY_VAL_DOMINATOR_GUILD_ID, SerId) ->
    <<AutoId:48>> = <<SerId:16, 4:32>>, AutoId.

get_next_time(NowTime) ->
    OpTime = util:get_open_time(),
    OpUnixdate = utime:unixdate(OpTime),
    NowWeek = utime:day_of_week(NowTime),
    Unixdate = utime:unixdate(NowTime),
    OpdayLimit = data_guild_war:get_cfg(opday_lim),
    MergeDayLimit = data_guild_war:get_cfg(merge_day_lim),
    SpecialOpdayL = data_guild_war:get_cfg(special_open_day),
    Opday = (Unixdate - OpUnixdate) div 86400 + 1, %% 因为是0点检测一次,所以这里取的开服天数是以0点来算的
    MergeDay = util:get_merge_day(NowTime),
    InSpecialDay = lists:member(Opday, SpecialOpdayL),
    OpOrMerLim = case util:is_merge_game() of
        true -> MergeDay < MergeDayLimit;
        _ -> Opday < OpdayLimit
    end,
    if
        not InSpecialDay andalso OpOrMerLim ->
            {close, ?ACT_STATUS_CLOSE, Unixdate + 86401 - NowTime, Unixdate + 86401};
        true ->
            OpenTime = data_guild_war:get_cfg(open_time),
            OpenWeek = data_guild_war:get_cfg(open_week),
            ConfirmTime = data_guild_war:get_cfg(confirm_time),
            Duration = get_act_duration(),
            case InSpecialDay orelse lists:member(NowWeek, OpenWeek) of
                true ->
                    {StatusName, Status, CountDownTime}
                        = do_get_next_time(format_time(ConfirmTime), format_time(OpenTime), Duration, NowTime - Unixdate),
                    {StatusName, Status, CountDownTime, NowTime + CountDownTime};
                false ->
                    {close, ?ACT_STATUS_CLOSE, Unixdate + 86401 - NowTime, Unixdate + 86401}
            end
    end.

do_get_next_time(ConfirmTime, OpenTime, Duration, NowDuration) ->
    if
        NowDuration < ConfirmTime ->
            {close, ?ACT_STATUS_CLOSE, ConfirmTime - NowDuration + 1};
        NowDuration >= ConfirmTime andalso NowDuration < OpenTime ->
            {confirm, ?ACT_STATUS_CONFIRM, OpenTime - NowDuration};
        NowDuration >= OpenTime + Duration ->
            {close, ?ACT_STATUS_CLOSE, 86401 - NowDuration};
        true -> %% 进程启动时候处于开启状态跳过这次活动
            {close, ?ACT_STATUS_CLOSE, 86401 - NowDuration}
    end.

format_time(TimeL) when is_list(TimeL) ->
    [H * 3600 + M * 60 + S||{H, M, S} <- TimeL];
format_time({H, M, S}) ->
    H * 3600 + M * 60 + S;
format_time(_) -> [].

get_act_duration() ->
    BattleTime = data_guild_war:get_cfg(battle_time),
    RoundTimes = data_guild_war:get_cfg(round_times),
    RestTime = data_guild_war:get_cfg(rest_time),
    BattleTime * RoundTimes + (RoundTimes - 1) * RestTime.

%%--------------------------------------------------
%% 对[#status_gwar_guild{}]类型列表排序
%% @param  List    [#status_gwar_guild{}]
%% @param  SortKey 用于排序的字段
%% @param  Len     排序的长度
%% @return         description
%%--------------------------------------------------
sort(List, SortKey, Len) ->
    SortList = lists:keysort(SortKey, List),
    SubList = lists:sublist(lists:reverse(SortList), Len),
    F = fun(T, {Ranking, Acc}) ->
        NewT = T#status_gwar_guild{ranking = Ranking},
        {Ranking + 1, [NewT|Acc]}
    end,
    {_, RankL} = lists:foldl(F, {1, []}, SubList),
    lists:reverse(RankL).

pack_division_list(StatusName, 0, StatusGWar)
    when StatusName == ?ACT_STATUS_CLOSE orelse StatusName == ?ACT_STATUS_CONFIRM ->
    #status_guild_war{division_map = DivisionMap} = StatusGWar,
    DivisionL = maps:to_list(DivisionMap),
    F = fun({_Division, GuildList}, Acc) ->
        TmpList = [{GuildId, GuildName, Ranking}
            || #status_gwar_guild{guild_id = GuildId, guild_name = GuildName, ranking = Ranking} <- GuildList],
        TmpList ++ Acc
    end,
    List = lists:foldl(F, [], DivisionL),
    pt_402:write(40241, [List]);
pack_division_list(StatusName, 0, StatusGWar)
    when StatusName == ?ACT_STATUS_BATTLE orelse StatusName == ?ACT_STATUS_REST ->
    #status_guild_war{division_map = DivisionMap, room_map = GWarRoomMap} = StatusGWar,
    DivisionL = maps:to_list(DivisionMap),
    F1 = fun({RoomId, GuildList}, Acc) ->
        case GuildList of
            [AGuild, BGuild|_] ->
                #status_gwar_guild{guild_id = AGuildId, guild_name = AGuildName} = AGuild,
                #status_gwar_guild{guild_id = BGuildId, guild_name = BGuildName} = BGuild,
                #gwar_room{winner_id = WinnerId} = maps:get(RoomId, GWarRoomMap, #gwar_room{});
            [AGuild|_] -> %% 只有一个公会, 轮空
                #status_gwar_guild{guild_id = AGuildId, guild_name = AGuildName} = AGuild,
                BGuildId = 0, BGuildName = <<>>,
                #gwar_room{winner_id = WinnerId} = maps:get(RoomId, GWarRoomMap, #gwar_room{})
        end,
        [{AGuildId, AGuildName, BGuildId, BGuildName, WinnerId}|Acc]
    end,
    F = fun({_Division, GuildList}, Acc) ->
        case GuildList =/= [] of
            true ->
                ClassifyMap = classify_guild_by_room_id(GuildList, #{}),
                ClassifyList = maps:to_list(ClassifyMap),
                lists:foldl(F1, Acc, ClassifyList);
            false -> Acc
        end
    end,
    List = lists:foldl(F, [], DivisionL),
    pt_402:write(40242, [List]);
pack_division_list(StatusName, _GameTimes, StatusGWar)
    when StatusName == ?ACT_STATUS_CLOSE orelse StatusName == ?ACT_STATUS_CONFIRM ->
    #status_guild_war{division_map = DivisionMap} = StatusGWar,
    DivisionL = maps:to_list(DivisionMap),
    F = fun({Division, GuildList}) ->
        TmpList = [{GuildId, GuildName, Ranking}
            || #status_gwar_guild{guild_id = GuildId, guild_name = GuildName, ranking = Ranking} <- GuildList],
        {Division, TmpList}
    end,
    List = lists:map(F, DivisionL),
    pt_402:write(40243, [List]);
pack_division_list(StatusName, _GameTimes, StatusGWar)
    when StatusName == ?ACT_STATUS_BATTLE orelse StatusName == ?ACT_STATUS_REST ->
    #status_guild_war{division_map = DivisionMap, room_map = GWarRoomMap} = StatusGWar,
    DivisionL = maps:to_list(DivisionMap),
    F1 = fun({RoomId, GuildList}, Acc) ->
        case GuildList of
            [AGuild, BGuild|_] ->
                #status_gwar_guild{guild_id = AGuildId, guild_name = AGuildName} = AGuild,
                #status_gwar_guild{guild_id = BGuildId, guild_name = BGuildName} = BGuild,
                #gwar_room{winner_id = WinnerId} = maps:get(RoomId, GWarRoomMap, #gwar_room{});
            [AGuild|_] -> %% 只有一个公会, 轮空
                #status_gwar_guild{guild_id = AGuildId, guild_name = AGuildName} = AGuild,
                BGuildId = 0, BGuildName = <<>>,
                #gwar_room{winner_id = WinnerId} = maps:get(RoomId, GWarRoomMap, #gwar_room{})
        end,
        [{AGuildId, AGuildName, BGuildId, BGuildName, WinnerId}|Acc]
    end,
    F = fun({Division, GuildList}, Acc) ->
        case GuildList =/= [] of
            true ->
                ClassifyMap = classify_guild_by_room_id(GuildList, #{}),
                ClassifyList = maps:to_list(ClassifyMap),
                List = lists:foldl(F1, [], ClassifyList),
                [{Division, List}|Acc];
            false -> [{Division, []}|Acc]
        end
    end,
    List = lists:foldl(F, [], DivisionL),
    pt_402:write(40244, [List]).

%% 根据room_id对公会进行分类
classify_guild_by_room_id([], Map) -> Map;
classify_guild_by_room_id([T|L], Map) ->
    #status_gwar_guild{room_id = RoomId} = T,
    List = maps:get(RoomId, Map, []),
    NewMap = maps:put(RoomId, [T|List], Map),
    classify_guild_by_room_id(L, NewMap).

%% 根据win_times对公会进行分类
classify_guild_by_wintimes([], Map) -> Map;
classify_guild_by_wintimes([T|L], Map) ->
    #status_gwar_guild{win_times = WinTimes} = T,
    List = maps:get(WinTimes, Map, []),
    NewMap = maps:put(WinTimes, [T|List], Map),
    classify_guild_by_wintimes(L, NewMap).

get_born_xy(GroupId) ->
    [{X, Y}|_] = case GroupId of
        ?GROUP_RED ->
            data_guild_war:get_cfg(red_reborn_xys);
        _ ->
            data_guild_war:get_cfg(blue_reborn_xys)
    end,
    {X, Y}.

%% 获取胜利所加排名积分(用于同赛区公会排名)
count_ranking_score() ->
    Round = get_battle_round(),
    100 - Round.

%% 获取终结奖励
get_break_reward(WorldLv, StreakTimes) ->
    List = data_guild_war:get_break_reward_list(),
    FilterList = [TStreakTimes || {TMinWLv, TMaxWLv, TStreakTimes} <- List, WorldLv >= TMinWLv andalso TMaxWLv >= WorldLv, StreakTimes >= TStreakTimes],
    case FilterList =/= [] of
        true ->
            Max = lists:max(FilterList),
            data_guild_war:get_break_reward(WorldLv, Max);
        false -> []
    end.

%% 发送错误码
send_error_code(RoleId, ErrorCode) ->
    {ok, BinData} = pt_402:write(40200, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% ========================== 日志相关接口 ==========================
log_guild_war_division(State) ->
    #status_guild_war{
        status = Status,
        division_map = DivisionMap
    } = State,
    LogStage = case Status of
        ?ACT_STATUS_CONFIRM -> 1; %% 确认期的赛区排名
        ?ACT_STATUS_CLOSE -> 2; %% 比赛结束结算期
        _ -> Status
    end,
    AllDivisionL = maps:values(DivisionMap),
    F = fun(OneDivisionL) ->
        log_guild_war_division(OneDivisionL, LogStage)
    end,
    lists:foreach(F, AllDivisionL).

log_guild_war_division([], _) -> skip;
log_guild_war_division([T|L], LogStage) ->
    case T of
        #status_gwar_guild{guild_id = GuildId, guild_name = GuildName, division = Division, ranking = Ranking} ->
            lib_log_api:log_guild_war_division(LogStage, GuildId, GuildName, Division, Ranking);
        _ -> skip
    end,
    log_guild_war_division(L, LogStage).