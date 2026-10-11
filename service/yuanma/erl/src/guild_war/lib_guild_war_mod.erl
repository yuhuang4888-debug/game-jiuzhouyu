%%-----------------------------------------------------------------------------
%% @Module  :       lib_guild_war_mod
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-04
%% @Description:
%%-----------------------------------------------------------------------------
-module(lib_guild_war_mod).

-include("guild_war.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("guild.hrl").
-include("predefine.hrl").
-include("buff.hrl").

-export([
    init/0
    , repair_division_map/0
    , sync_guild_list/2
    , send_act_tv/2
    , match_guild/1
    , start_battle/1
    , act_end/1
    , update_guild_info/2
    , update_dominator_info/3
    , allot_reward/5
    , send_battle_tv/1
    , is_sync_battle_result_finish/1
    , broadcast_act_info/1
    , guild_war_reset/0
    ]).

make_record(status_reward, [Reward, AllotTimes]) ->
    #status_reward{reward = Reward, allot_times = AllotTimes};
make_record(sql_gwar_guild, [GuildId, GuildName, ChiefId, Division, Ranking]) ->
    #status_gwar_guild{
        guild_id = GuildId,
        guild_name = GuildName,
        chief_id = ChiefId,
        division = Division,
        ranking = Ranking
    };
make_record(gwar_guild, [GuildId, GuildName, ChiefId, Division, CombatPower]) ->
    #status_gwar_guild{
        guild_id = GuildId,
        guild_name = GuildName,
        chief_id = ChiefId,
        division = Division,
        combat_power = CombatPower
    };
make_record(gwar_guild_info, [StatusGWarGuild, GroupId]) ->
    #gwar_guild_info{
        guild_id = StatusGWarGuild#status_gwar_guild.guild_id,
        guild_name = StatusGWarGuild#status_gwar_guild.guild_name,
        combat_power = StatusGWarGuild#status_gwar_guild.combat_power,
        group_id = GroupId
    }.

init() ->
    case util:get_merge_day() of
        1 -> %% 合服第一天合服要把连胜奖励和终结奖励发给所属公会，并把数据库数据删除
            do_init(merge);
        _ ->
            do_init(normal)
    end.

do_init(normal) ->
    NewStatusDominator = init_dominator(),
    List = db:get_all(io_lib:format(?sql_guild_war_division, [])),
    {IndexMap, DivisionMap} = init_division(List, #{}, ?ORIGIN_DIVISION_MAP),
    KeyId = lib_guild_war:get_key_id(?GLOBAL_KEY_VAL_GAME_TIMES),
    GameTimes = case db:get_row(io_lib:format(?sql_select_global_key_val, [KeyId])) of
        [Val|_] -> util:bitstring_to_term(Val);
        _ -> 0
    end,
    %% 同步赛区信息到公会进程
    mod_guild:update_guild_division(IndexMap),
    State = #status_guild_war{
        game_times = GameTimes,
        index_map = IndexMap,
        division_map = DivisionMap,
        status_dominator = NewStatusDominator
    },
    {ok, State};
do_init(merge) ->
    case guild_war_reset() of
        {ok, NewStatusDominator} ->
            IndexMap = #{},
            %% 同步赛区信息到公会进程
            mod_guild:update_guild_division(IndexMap),
            State = #status_guild_war{
                game_times = 0,
                index_map = IndexMap,
                division_map = ?ORIGIN_DIVISION_MAP,
                status_dominator = NewStatusDominator
            },
            {ok, State};
        {fail, Reason} ->
            {stop, Reason}
    end;
do_init(_) -> {stop, error}.

init_dominator() ->
    List = db:get_all(io_lib:format(?sql_guild_war_reward, [])),
    VictoryRewardMap = init_victory_reward(List, #{}),
    %% 终结奖励
    case db:get_all(io_lib:format(?sql_guild_war_break_reward, [])) of
        [[_GuildId, RewardBin, AllotTimes]|_] ->
            Reward = util:bitstring_to_term(RewardBin),
            BreakReward = make_record(status_reward, [Reward, AllotTimes]);
        _ -> BreakReward = #status_reward{}
    end,
    KeyId = lib_guild_war:get_key_id(?GLOBAL_KEY_VAL_STREAK_TIMES),
    StreakTimes = case db:get_row(io_lib:format(?sql_select_global_key_val, [KeyId])) of
        [Val|_] -> util:bitstring_to_term(Val);
        _ -> 0
    end,
    KeyId1 = lib_guild_war:get_key_id(?GLOBAL_KEY_VAL_DOMINATOR_GUILD_ID),
    DominatorId = case db:get_row(io_lib:format(?sql_select_global_key_val, [KeyId1])) of
        [Val1|_] -> util:bitstring_to_term(Val1);
        _ -> 0
    end,
    case db:get_row(io_lib:format(?sql_select_guild_short_info, [DominatorId])) of
        [GuildName, ChiefId|_] -> skip;
        _ -> GuildName = <<>>, ChiefId = 0
    end,
    #status_dominator{
        guild_id = DominatorId,
        guild_name = GuildName,
        chief_id = ChiefId,
        streak_times = StreakTimes,
        reward = VictoryRewardMap,
        break_reward = BreakReward
    }.

%% 初始化连胜奖励
init_victory_reward([], RewardMap) ->
    RewardMap;
init_victory_reward([[Id, _GuildId, StreakTimes, RewardBin, AllotTimes]|L], RewardMap) ->
    Reward = util:bitstring_to_term(RewardBin),
    RewardR = make_record(status_reward, [Reward, AllotTimes]),
    NewRewardMap = ?IF(Reward =/= [], RewardMap#{Id => RewardR#status_reward{extra = StreakTimes}}, RewardMap),
    init_victory_reward(L, NewRewardMap).

%% 初始化赛区数据
init_division([], IndexMap, DivisionMap) -> {IndexMap, DivisionMap};
init_division([T|L], IndexMap, DivisionMap) ->
    DivisionGuildR = make_record(sql_gwar_guild, T),
    GuildId = DivisionGuildR#status_gwar_guild.guild_id,
    Division = DivisionGuildR#status_gwar_guild.division,
    GuildList = maps:get(Division, DivisionMap, []),
    NewDivisionMap = maps:put(Division, [DivisionGuildR|GuildList], DivisionMap),
    NewIndexMap = IndexMap#{GuildId => Division},
    init_division(L, NewIndexMap, NewDivisionMap).

%% 合服重置公会战活动
guild_war_reset() ->
    F = fun() ->
        NewDominator = do_guild_war_reset(),
        {ok, NewDominator}
    end,
    case catch db:transaction(F) of
        {ok, Dominator} -> {ok, Dominator};
        Err ->
            ?ERR("guild war reset err:~p", [Err]),
            {fail, Err}
    end.

do_guild_war_reset() ->
    %% 合服的时候会把多个服的表都合并在一起
    List = db:get_all(io_lib:format(?sql_guild_war_reward, [])),
    F = fun
        ([Id, GuildId, StreakTimes, RewardBin, AllotTimes], TMap) ->
            Reward = util:bitstring_to_term(RewardBin),
            case Reward =/= [] of
                true ->
                    #status_dominator{
                        reward = TRewardMap
                    } = TDominator = maps:get(GuildId, TMap, #status_dominator{}),
                    RewardR = make_record(status_reward, [Reward, AllotTimes]),
                    NewTRewardMap = TRewardMap#{Id => RewardR#status_reward{extra = StreakTimes}},
                    NewTDominator = TDominator#status_dominator{reward = NewTRewardMap},
                    maps:put(GuildId, NewTDominator, TMap);
                false -> TMap
            end;
        (_, TMap) -> TMap
    end,
    DominatorMap = lists:foldl(F, #{}, List),
    List1 = db:get_all(io_lib:format(?sql_guild_war_break_reward, [])),
    F1 = fun
        ([GuildId, RewardBin, AllotTimes], TMap) ->
            Reward = util:bitstring_to_term(RewardBin),
            case Reward =/= [] of
                true ->
                    TDominator = maps:get(GuildId, TMap, #status_dominator{}),
                    BreakReward = make_record(status_reward, [Reward, AllotTimes]),
                    NewTDominator = TDominator#status_dominator{break_reward = BreakReward},
                    maps:put(GuildId, NewTDominator, TMap);
                false -> TMap
            end;
        (_, TMap) -> TMap
    end,
    NewDominatorMap = lists:foldl(F1, DominatorMap, List1),
    GuildIds = maps:keys(NewDominatorMap),
    case GuildIds =/= [] of
        true ->
            ChiefIds = db:get_all(io_lib:format(<<"select id, coalesce(chief_id, 0) from guild where id in (~s)">>, [util:link_list(GuildIds)]));
        false -> ChiefIds = []
    end,
    %% 清空之前的公会争霸数据
    db:execute(io_lib:format(?sql_guild_war_clear_division, [])),
    db:execute(io_lib:format(?sql_guild_war_clear_streak_reward, [])),
    db:execute(io_lib:format(?sql_guild_war_clear_break_reward, [])),
    db:execute(io_lib:format(?sql_guild_war_clear_global_key_val, [])),

    %% 移除对应Buff
    lib_goods_buff:db_remove_goods_buff(?BUFF_GWAR_DOMINATOR),

    case data_guild_war:get_cfg(dominator_designation) of
        DsgtId when DsgtId > 0 ->
            lib_designation_api:active_dsgt_common(0, DsgtId);
        _ -> skip
    end,

    F2 = fun
        ([GuildId, ChiefId]) when ChiefId > 0 ->
            TDominator = maps:get(GuildId, NewDominatorMap, #status_dominator{guild_id = GuildId}),
            NewTDominator = TDominator#status_dominator{chief_id = ChiefId},
            auto_send_reward(?ALLOT_TYPE_MERGE, NewTDominator);
        (_) -> skip
    end,
    lists:foreach(F2, ChiefIds),
    #status_dominator{}.

%% 进程启动时候处于确认阶段但是数据库没有D赛区的公会需要重新去公会进程拿一遍
repair_division_map() ->
    KeyId = lib_guild_war:get_key_id(?GLOBAL_KEY_VAL_COMFIRM_STATUS),
    case db:get_row(io_lib:format(?sql_select_global_key_val, [KeyId])) of
        [Val|_] when Val == <<"1">> -> skip;
        _ ->
            spawn(fun() ->
                timer:sleep(3000),
                mod_guild:sync_guild_list_to_gwar()
            end)
    end.

%% 确定D赛区的公会信息
sync_guild_list(State, GuildList) ->
    #status_guild_war{
        game_times = GameTimes,
        index_map = OldIndexMap,
        division_map = DivisionMap
    } = State,
    %% 把旧的D赛区公会信息删掉，避免重复确认的时候出错
    IndexMap = maps:filter(fun(_, TmpDivision) -> TmpDivision =/= ?DIVISION_TYPE_D end, OldIndexMap),
    DivisionGuildIds = maps:keys(IndexMap),
    MaxCreateTime = utime:unixtime() - data_guild_war:get_cfg(min_join_guild_time),
    F = fun(T, Acc) ->
        case T of
            #guild{id = TGuildId, name = TGName, chief_id = ChiefId, combat_power = TPower, create_time = TCreateTime} ->
                IsInDivision = lists:member(TGuildId, DivisionGuildIds),
                case not IsInDivision andalso (GameTimes == 0 orelse (GameTimes > 0 andalso TCreateTime < MaxCreateTime)) of
                    true ->
                        TR = make_record(gwar_guild, [TGuildId, TGName, ChiefId, ?DIVISION_TYPE_D, TPower]),
                        [TR|Acc];
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    CandidatesL = lists:foldl(F, [], GuildList),
    NewState = case CandidatesL =/= [] of
        true ->
            GuildNum = ?IF(GameTimes == 0, ?FIRST_GAME_GUILD_NUM, ?DIVISION_GUILD_NUM),
            DDivisionGuildL = lib_guild_war:sort(CandidatesL, #status_gwar_guild.combat_power, GuildNum),
            SqlArgs = [[TGuildId, TDivision, TRanking]
                        ||#status_gwar_guild{guild_id = TGuildId, division = TDivision, ranking = TRanking} <- DDivisionGuildL],
            Sql = usql:replace(guild_war_division, [guild_id, division, ranking], SqlArgs),
            F2 = fun() ->
                db:execute(io_lib:format(Sql, [])),
                KeyId = lib_guild_war:get_key_id(?GLOBAL_KEY_VAL_COMFIRM_STATUS),
                db:execute(io_lib:format(?sql_update_global_key_val, [KeyId, "1"])),
                ok
            end,
            case catch db:transaction(F2) of
                ok ->
                    NewDivisionMap = maps:put(?DIVISION_TYPE_D, DDivisionGuildL, DivisionMap),
                    F3 = fun(#status_gwar_guild{guild_id = TGuildId}, AccMap) ->
                        AccMap#{TGuildId => ?DIVISION_TYPE_D}
                    end,
                    NewIndexMap = lists:foldl(F3, IndexMap, DDivisionGuildL),
                    State#status_guild_war{index_map = NewIndexMap, division_map = NewDivisionMap};
                _Err ->
                    ?ERR("sync_guild_list err:~p", [_Err]),
                    % %% 重新去拿一遍
                    % mod_guild:sync_guild_list_to_gwar(),
                    State
            end;
        false ->
            State
    end,
    %% 日志
    spawn(fun() -> lib_guild_war:log_guild_war_division(NewState) end),
    NewState.

send_act_tv(?TV_TYPE_BATTLE_START, [IndexMap]) ->
    Round = lib_guild_war:get_battle_round(),
    BinData = lib_chat:make_tv(?MOD_GUILD_ACT, 9, [Round]),
    do_send_act_tv(IndexMap, BinData);
send_act_tv(?TV_TYPE_BATTLE_END, [IndexMap]) ->
    Round = lib_guild_war:get_battle_round(),
    RestTime = data_guild_war:get_cfg(rest_time),
    {_H, M, _S} = utime:time_to_hms(RestTime),
    BinData = lib_chat:make_tv(?MOD_GUILD_ACT, 10, [Round, M, Round + 1]),
    do_send_act_tv(IndexMap, BinData);
send_act_tv(_, _) -> skip.

do_send_act_tv(IndexMap, BinData) ->
    GuildIds = maps:keys(IndexMap),
    F = fun(TmpGuildId) ->
        lib_server_send:send_to_guild(TmpGuildId, BinData)
    end,
    lists:foreach(F, GuildIds).

send_battle_tv({?TV_TYPE_COMBO, AttackerName, Combo}) when Combo == 10 ->
    BinData = lib_chat:make_tv(?MOD_GUILD_ACT, 13, [AttackerName]),
    do_send_battle_tv({scene}, BinData);
send_battle_tv({?TV_TYPE_COMBO, AttackerName, Combo}) when Combo == 20 ->
    BinData = lib_chat:make_tv(?MOD_GUILD_ACT, 14, [AttackerName]),
    do_send_battle_tv({scene}, BinData);
send_battle_tv({?TV_TYPE_OCCUPY, AttackerName, MonName}) ->
    BinData = lib_chat:make_tv(?MOD_GUILD_ACT, 15, [AttackerName, MonName]),
    do_send_battle_tv({scene}, BinData);
send_battle_tv({?TV_TYPE_RES_BE_ATTACKED, GuildId, GuildMap, MonName}) when GuildId > 0 ->
    case maps:get(GuildId, GuildMap, false) of
        #gwar_guild_info{role_map = RoleMap} ->
            RoleList = maps:values(RoleMap),
            RoleIds = [RoleId || #gwar_role_info{role_id = RoleId, scene = SceneId} <- RoleList, SceneId > 0],
            BinData = lib_chat:make_tv(?MOD_GUILD_ACT, 16, [MonName]),
            spawn(fun() -> do_send_battle_tv({players, RoleIds}, BinData) end);
        _ -> skip
    end;
send_battle_tv({?TV_TYPE_RESOURCE, GuildName, PreResource, CurResource}) when PreResource < 2500 andalso CurResource >= 2500 ->
    BinData = lib_chat:make_tv(?MOD_GUILD_ACT, 17, [GuildName]),
    do_send_battle_tv({scene}, BinData);
send_battle_tv(_) -> skip.

do_send_battle_tv({scene}, BinData) ->
    SceneId = data_guild_war:get_cfg(scene_id),
    lib_server_send:send_to_scene(SceneId, ?GWAR_SCENE_POOL_ID, self(), BinData);
do_send_battle_tv({players, RoleIds}, BinData) ->
    F = fun(RoleId) ->
        lib_server_send:send_to_uid(RoleId, BinData)
    end,
    lists:foreach(F, RoleIds).

%% 各赛区的公会进行匹配
match_guild(StatusGWar) ->
    #status_guild_war{etime = Etime, division_map = DivisionMap} = StatusGWar,
    ForbidPkTime = data_guild_war:get_cfg(forbid_pk_time),
    NowTime = utime:unixtime(),
    StartPkTime = NowTime + ForbidPkTime,
    DivisionL = maps:to_list(DivisionMap),
    % ?ERR("before match guild:~p", [DivisionL]),
    F = fun({Division, GuildList}, [TmpDivisionMap, TmpRoomMap]) ->
        ClassifyMap = lib_guild_war:classify_guild_by_wintimes(GuildList, #{}),
        % ?ERR("Division:~p ClassifyMap:~p", [Division, ClassifyMap]),
        ClassifyList = maps:to_list(ClassifyMap),
        %% 显示的时候让胜利次数多的分组排前面
        SortList = lists:keysort(1, ClassifyList),
        {NewGuildList, NewTmpRoomMap} = do_match_guild(SortList, StartPkTime, Etime, [], TmpRoomMap),
        % ?ERR("Division:~p after match:~p", [Division, NewGuildList]),
        NewTmpDivisonMap = maps:put(Division, NewGuildList, TmpDivisionMap),
        [NewTmpDivisonMap, NewTmpRoomMap]
    end,
    [NewDivisionMap, NewRoomMap] = lists:foldl(F, [#{}, #{}], DivisionL),
    % ?ERR("after math DivisionMap:~p", [NewDivisionMap]),
    StatusGWar#status_guild_war{division_map = NewDivisionMap, room_map = NewRoomMap}.

do_match_guild([], _StartPkTime, _Etime, Acc, RoomMap) -> {Acc, RoomMap};
do_match_guild([{_WinTimes, GuildList}|L], StartPkTime, Etime, Acc, RoomMap) ->
    ShuffleList = ulists:list_shuffle(GuildList),
    {NewAcc, NewRoomMap} = do_match_guild_core(ShuffleList, StartPkTime, Etime, Acc, RoomMap),
    do_match_guild(L, StartPkTime, Etime, NewAcc, NewRoomMap).

do_match_guild_core([], _StartPkTime, _Etime, Acc, RoomMap) -> {Acc, RoomMap};
do_match_guild_core([AGuild, BGuild|L], StartPkTime, Etime, Acc, RoomMap) ->
    MatchId = lib_guild_war:get_match_id(),
    RoomId = lib_guild_war:get_room_id(),
    Round = lib_guild_war:get_battle_round(),
    #status_gwar_guild{guild_id = AGuildId, division = AGDivision} = AGuild,
    #status_gwar_guild{guild_id = BGuildId} = BGuild,
    NewAGuild = AGuild#status_gwar_guild{match_id = MatchId, room_id = RoomId},
    NewBGuild = BGuild#status_gwar_guild{match_id = MatchId, room_id = RoomId},
    AGroupId = urand:rand(?GROUP_RED, ?GROUP_BLUE),
    BGroupId = ?IF(AGroupId == ?GROUP_RED, ?GROUP_BLUE, ?GROUP_RED),
    AGuildInfo = make_record(gwar_guild_info, [NewAGuild, AGroupId]),
    BGuildInfo = make_record(gwar_guild_info, [NewBGuild, BGroupId]),
    GuildInfoMap = #{AGuildId => AGuildInfo, BGuildId => BGuildInfo},
    {ok, Pid} = mod_guild_war_battle:start([AGDivision, Round, RoomId, StartPkTime, Etime, GuildInfoMap]),
    NewRoomMap = RoomMap#{RoomId => #gwar_room{pid = Pid, division = AGDivision}},
    do_match_guild_core(L, StartPkTime, Etime, [NewAGuild, NewBGuild|Acc], NewRoomMap);
do_match_guild_core([AGuild|L], StartPkTime, Etime, Acc, RoomMap) ->
    RoomId = lib_guild_war:get_room_id(),
    Round = lib_guild_war:get_battle_round(),
    #status_gwar_guild{guild_id = AGuildId, division = AGDivision} = AGuild,
    NewAGuild = AGuild#status_gwar_guild{match_id = 0, room_id = RoomId},
    AGroupId = urand:rand(?GROUP_RED, ?GROUP_BLUE),
    AGuildInfo = make_record(gwar_guild_info, [NewAGuild, AGroupId]),
    GuildInfoMap = #{AGuildId => AGuildInfo},
    {ok, Pid} = mod_guild_war_battle:start([AGDivision, Round, RoomId, StartPkTime, Etime, GuildInfoMap]),
    NewRoomMap = RoomMap#{RoomId => #gwar_room{pid = Pid, division = AGDivision}},
    do_match_guild_core(L, StartPkTime, Etime, [NewAGuild|Acc], NewRoomMap).

%% 每场战斗开始
start_battle(State) ->
    #status_guild_war{
        ref = ORef,
        index_map = IndexMap,
        division_map = DivisionMap
    } = State,
    util:cancel_timer(ORef),

    %% 设置比赛回合次数
    BattleRound = lib_guild_war:get_battle_round(),
    lib_guild_war:put_battle_round(BattleRound + 1),

    NowTime = utime:unixtime(),
    CountDownTime = data_guild_war:get_cfg(battle_time),
    Etime = NowTime + CountDownTime,
    % ?ERR("Start Battle BattleRound:~p", [BattleRound]),
    case BattleRound == 0 of
        true -> %% 第一场开打前重置活动相关数据
            spawn(fun() ->
                lib_activitycalen_api:success_start_activity(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_GWAR)
            end),
            erase("match_last_id"),
            erase("room_last_id"),
            F = fun(_Division, GuildL) ->
                [T#status_gwar_guild{ranking_score = 0, match_id = 0, room_id = 0, win_times = 0}|| T <- GuildL]
            end,
            NewDivisionMap = maps:map(F, DivisionMap);
        false ->
            NewDivisionMap = DivisionMap
    end,

    NewStateTmp = State#status_guild_war{etime = Etime, room_map = #{}, division_map = NewDivisionMap},
    NewState = lib_guild_war_mod:match_guild(NewStateTmp),

    lib_guild_war_mod:send_act_tv(?TV_TYPE_BATTLE_START, [IndexMap]),

    Ref = erlang:send_after(CountDownTime * 1000 + 1, self(), 'time_out'),
    LastState = NewState#status_guild_war{
        status = ?ACT_STATUS_BATTLE,
        etime = Etime,
        ref = Ref
    },
    lib_guild_war_mod:broadcast_act_info(LastState),
    LastState.

%% 活动结束
%% 若活动开始时，某赛区公会数量本身不足4个或其下一级赛区公会数量为0，则本次活动该赛区不进行降级
%% 计算各个公会所处新的赛区以及排名
%% 处理连胜奖励以及终结奖励
act_end(State) ->
    #status_guild_war{
        game_times = GameTimes,
        division_map = DivisionMap,
        status_dominator = OldDominator
    } = State,

    spawn(fun() ->
        lib_activitycalen_api:success_end_activity(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_GWAR)
    end),

    DivisionL = maps:to_list(DivisionMap),
    %% 按赛区级别由高到低排序
    SortDivisionL = lists:keysort(1, DivisionL),
    %% 各赛区的公会按排名积分进行排序
    F1 = fun(A, B) ->
        A#status_gwar_guild.ranking_score > B#status_gwar_guild.ranking_score
    end,
    F = fun({Division, GuildList}) ->
        NewGuildList = lists:sort(F1, GuildList),
        {Division, NewGuildList}
    end,
    NewSortDivisionL = lists:map(F, SortDivisionL),
    %% 更新公会的赛区信息
    % ?ERR("before update division:~p", [NewSortDivisionL]),
    case GameTimes == 0 of
        true ->
            NewDivisionL = update_guild_division_first(NewSortDivisionL);
        false -> %% 大于0为非首届定级赛
            NewDivisionL = update_guild_division(NewSortDivisionL, [])
    end,
    % ?ERR("after update division:~p", [NewDivisionL]),
    {NewDivisionMap, DBUpdateDivisionArgs} = sort_division_guild_and_update_db(NewDivisionL, ?ORIGIN_DIVISION_MAP, []),
    % ?ERR("sort division:~p", [NewDivisionMap]),
    %% 主宰公会相关处理
    {NewDominator, DBUpdateStreakArgs, DBUpdateBreakArgs} = update_dominator_and_db(GameTimes, NewDivisionMap, OldDominator),
    UpdateDivisionSql = usql:insert(guild_war_division, [guild_id, division, ranking], DBUpdateDivisionArgs),
    UpdateStreakRewardSql = usql:insert(guild_war_reward, [id, guild_id, streak_times, reward, allot_times], DBUpdateStreakArgs),
    UpdateBreakRewardSql = usql:insert(guild_war_break_reward, [guild_id, reward, allot_times], DBUpdateBreakArgs),
    F2 = fun() ->
        %% 先清空所有赛区数据
        db:execute(io_lib:format(?sql_guild_war_clear_division, [])),
        db:execute(io_lib:format(?sql_guild_war_clear_streak_reward, [])),
        db:execute(io_lib:format(?sql_guild_war_clear_break_reward, [])),
        %% 赛区确认信息状态重置
        KeyId = lib_guild_war:get_key_id(?GLOBAL_KEY_VAL_COMFIRM_STATUS),
        db:execute(io_lib:format(?sql_update_global_key_val, [KeyId, "0"])),
        %% 更新比赛举办届数
        KeyId1 = lib_guild_war:get_key_id(?GLOBAL_KEY_VAL_GAME_TIMES),
        db:execute(io_lib:format(?sql_update_global_key_val, [KeyId1, integer_to_list(GameTimes + 1)])),
        %% 更新主宰公会id
        KeyId2 = lib_guild_war:get_key_id(?GLOBAL_KEY_VAL_DOMINATOR_GUILD_ID),
        db:execute(io_lib:format(?sql_update_global_key_val, [KeyId2, integer_to_list(NewDominator#status_dominator.guild_id)])),
        %% 更新本届主宰公会连胜次数
        KeyId3 = lib_guild_war:get_key_id(?GLOBAL_KEY_VAL_STREAK_TIMES),
        db:execute(io_lib:format(?sql_update_global_key_val, [KeyId3, integer_to_list(NewDominator#status_dominator.streak_times)])),
        %% 更新赛区信息
        case UpdateDivisionSql =/= "" of
            true ->
                db:execute(UpdateDivisionSql);
            false ->
                skip
        end,
        %% 更新连胜奖励(没有奖励的时候不用操作数据库)
        case UpdateStreakRewardSql =/= "" of
            true ->
                db:execute(UpdateStreakRewardSql);
            false -> skip
        end,
        %% 更新终结连胜奖励
        case UpdateBreakRewardSql =/= "" of
            true ->
                db:execute(UpdateBreakRewardSql);
            false -> skip
        end,
        ok
    end,
    case catch db:transaction(F2) of
        ok ->
            %% 清空战斗轮数以及房间号等信息
            erase("match_last_id"),
            erase("room_last_id"),
            erase("battle_round"),

            %% 发送全服传闻
            lib_chat:send_TV({all}, ?MOD_GUILD_ACT, 18, []),

            %% 更新索引Map
            F3 = fun(T, Acc) ->
                case T of
                    {TDivision, TGuildL} ->
                        TL = [{TGuildId, TDivision} || #status_gwar_guild{guild_id = TGuildId} <- TGuildL],
                        TL ++ Acc;
                    _ -> Acc
                end
            end,
            NewIndexList = lists:foldl(F3, [], maps:to_list(NewDivisionMap)),
            NewIndexMap = maps:from_list(NewIndexList),

            %% 同步赛区信息到公会进程
            mod_guild:update_guild_division(NewIndexMap),

            %% 在子进程处理
            spawn(fun() ->
                send_dominator_reward(OldDominator, NewDominator)
            end),

            case NewDominator#status_dominator.guild_id > 0 of
                true ->
                    mod_guild:apply_cast(mod_custom_act_gwar, sync_gwar_result, [NewDominator#status_dominator.chief_id, NewDominator#status_dominator.guild_id]);
                _ -> skip
            end,

            NewState = State#status_guild_war{
                status = ?ACT_STATUS_CLOSE,
                game_times = GameTimes + 1,
                room_map = #{},
                index_map = NewIndexMap,
                division_map = NewDivisionMap,
                status_dominator = NewDominator
            },

            %% 日志
            spawn(fun() -> lib_guild_war:log_guild_war_division(NewState) end),

            NewState;
        _Err ->
            ?ERR("act_end err:~p", [_Err]),
            State
    end.

%% 首届比赛公会的定级处理
update_guild_division_first(L) ->
    case lists:keyfind(?DIVISION_TYPE_D, 1, L) of
        {?DIVISION_TYPE_D, DGuildL} ->
            DivisionTypeL = [?DIVISION_TYPE_S, ?DIVISION_TYPE_A, ?DIVISION_TYPE_B, ?DIVISION_TYPE_C],
            do_update_guild_division_first(DGuildL, DivisionTypeL, []);
        _ -> []
    end.

do_update_guild_division_first(L, DivisionL, Acc) when L == [] orelse DivisionL == [] -> Acc;
do_update_guild_division_first(L, [Division|DivisionL], Acc) ->
    {SubL, RemainL} = ulists:sublist(L, ?DIVISION_GUILD_NUM),
    NewSubL = [T#status_gwar_guild{division = Division} || T <- SubL],
    do_update_guild_division_first(RemainL, DivisionL, [{Division, NewSubL}|Acc]).

%% 公会定级更新公会所属的赛区
update_guild_division([{HDivision, HDGuildL}, {LDivision, LDGuildL}|L], Acc) ->
    if
        %% 下一级赛区公会数量为0, 不进行升降级
        LDGuildL == [] ->
            NewL = [{LDivision, LDGuildL}|L],
            NewAcc = [{HDivision, HDGuildL}|Acc];
        true ->
            %% 升级的高级赛区的公会排最后一名，降级到低级赛区的公会排第一名
            [HeadGuild|RemainLDGuildL] = LDGuildL,
            if
                %% 高级赛区公会数量本身不足4个, 不进行降级
                length(HDGuildL) < ?DIVISION_GUILD_NUM ->
                    LastGuildId = 0,
                    NewL = [{LDivision, RemainLDGuildL}|L];
                true ->
                    LastGuild = lists:last(HDGuildL),
                    LastGuildId = LastGuild#status_gwar_guild.guild_id,
                    %% 设置排名积分为9999999999保证降级后在新赛区排第一名
                    NewLDGuildL = [LastGuild#status_gwar_guild{division = LDivision, ranking_score = 9999999999}|RemainLDGuildL],
                    NewL = [{LDivision, NewLDGuildL}|L]
            end,
            %% 低级赛区的第一名升级到高级赛区的最后一名
            NewHDGuildL = [HeadGuild#status_gwar_guild{division = HDivision, ranking_score = -1}|lists:keydelete(LastGuildId, #status_gwar_guild.guild_id, HDGuildL)],
            NewAcc = [{HDivision, NewHDGuildL}|Acc]
    end,
    update_guild_division(NewL, NewAcc);
update_guild_division([{?DIVISION_TYPE_D, _LDGuildL}], Acc) -> %% 本届比赛结束后D赛区的忽略掉
    Acc;
update_guild_division([{LDivision, LDGuildL}], Acc) ->
    [{LDivision, LDGuildL}|Acc].

%%--------------------------------------------------
%% 更新主宰公会信息
%% @param  DivisionMap        description
%% @param  OldStatusDominator 上一届的主宰公会数据
%% @return                    description
%%--------------------------------------------------
update_dominator_and_db(GameTimes, DivisionMap, OldDominator) ->
    case GameTimes > 0 of
        true ->
            NewDominator = update_dominator(DivisionMap, OldDominator),
            #status_dominator{
                guild_id = GuildId,
                reward = StreakRewardMap,
                break_reward = BreakReward
            } = NewDominator,
            StreakRewardList = maps:to_list(StreakRewardMap),
            SqlArgs = [[Id, GuildId, StreakTimes, util:term_to_string(Reward), AllotTimes]
                        ||{Id, #status_reward{reward = Reward, allot_times = AllotTimes, extra = StreakTimes}} <- StreakRewardList],
            SqlArgs1 = [[GuildId, util:term_to_string(Reward), AllotTimes]
                        ||#status_reward{reward = Reward, allot_times = AllotTimes} <- [BreakReward], Reward =/= []],
            {NewDominator, SqlArgs, SqlArgs1};
        false -> %% 首届不产生主宰公会
            {OldDominator, [], []}
    end.

update_dominator(DivisionMap, OldDominator) ->
    case maps:get(?DIVISION_TYPE_S, DivisionMap, []) of
        [NewDominatorGuild|_] ->
            NewDominatorId = NewDominatorGuild#status_gwar_guild.guild_id,
            OldDominatorId = OldDominator#status_dominator.guild_id,
            OldDominatorStreakTimes = OldDominator#status_dominator.streak_times,
            case NewDominatorId =/= OldDominatorId of
                true -> %% 终结连胜
                    %% 自动发放还未分配的奖励
                    auto_send_reward(?ALLOT_TYPE_BE_BREAK, OldDominator),
                    NewDominator = #status_dominator{
                        guild_id = NewDominatorGuild#status_gwar_guild.guild_id,
                        guild_name = NewDominatorGuild#status_gwar_guild.guild_name,
                        chief_id = NewDominatorGuild#status_gwar_guild.chief_id,
                        streak_times = 1
                    },
                    update_dominator_reward(OldDominatorId, OldDominatorStreakTimes, NewDominator);
                false -> %% 连胜
                    NewDominator = OldDominator#status_dominator{
                        streak_times = OldDominatorStreakTimes + 1
                    },
                    update_dominator_reward(OldDominatorId, OldDominatorStreakTimes, NewDominator)
            end;
        _ -> OldDominator
    end.

%%--------------------------------------------------
%% 更新本届主宰公会的奖励
%% @param  OldDominatorStreakTimes      上届主宰公会的连胜次数
%% @param  Dominator                    新的主宰公会
%% @return                              description
%%--------------------------------------------------
update_dominator_reward(OldDominatorId, OldDominatorStreakTimes, Dominator) ->
    #status_dominator{
        guild_id = GuildId,
        guild_name = GuildName,
        streak_times = StreakTimes,
        reward = StreakRewardMap,
        break_reward = BreakReward
    } = Dominator,
    WorldLv = util:get_world_lv(),
    case data_guild_war:get_streak_reward(WorldLv, StreakTimes) of
        RewardL when RewardL =/= [] ->
            %% 日志
            lib_log_api:log_guild_war_reward(GuildId, GuildName, 1, RewardL, [{streak_times, StreakTimes}]),
            RewardIds = maps:keys(StreakRewardMap),
            case RewardIds =/= [] of
                true ->
                    MaxRewardId = lists:max(RewardIds);
                _ -> MaxRewardId = 0
            end,
            %% 将此次的连胜奖励逐个插入到奖励中
            F = fun(T, {TmpMap, TmpId}) ->
                case T of
                    {_TmpObjType, _TmpObjId, _TmpObjNum} ->
                        NewTmpMap = maps:put(TmpId, #status_reward{reward = [T], extra = StreakTimes}, TmpMap),
                        {NewTmpMap, TmpId + 1};
                    _ -> {TmpMap, TmpId}
                end
            end,
            {NewStreakRewardMap, _} = lists:foldl(F, {StreakRewardMap, MaxRewardId + 1}, RewardL);
        _ -> NewStreakRewardMap = StreakRewardMap
    end,
    %% 处理终结连胜奖励
    case StreakTimes == 1 andalso GuildId =/= OldDominatorId andalso OldDominatorStreakTimes > 0 of
        true ->
            case lib_guild_war:get_break_reward(WorldLv, OldDominatorStreakTimes) of
                Reward1 when Reward1 =/= [] ->
                    %% 日志
                    lib_log_api:log_guild_war_reward(GuildId, GuildName, 2, Reward1, [{break_streak_times, OldDominatorStreakTimes}]),
                    NewBreakReward = #status_reward{reward = Reward1};
                _ -> NewBreakReward = BreakReward
            end;
        false -> NewBreakReward = BreakReward
    end,
    Dominator#status_dominator{
        reward = NewStreakRewardMap,
        break_reward = NewBreakReward
    }.

%%--------------------------------------------------
%% 对各赛区的公会按Ranking进行排序，并返回更新数据库的sql
%% @param  L                [{Division, [#status_gwar_guild{}]}]
%% @param  DivisionMap      #{Division => [#status_gwar_guild{}]}
%% @param  DBUpdateSql      更新数据公会赛区以及排名的sql
%% @return                  description
%%--------------------------------------------------
sort_division_guild_and_update_db([], DivisionMap, DBUpdateSql) -> {DivisionMap, DBUpdateSql};
sort_division_guild_and_update_db([{TDivision, TGuildL}|L], DivisionMap, DBUpdateSql) ->
    NewTGuildL = lib_guild_war:sort(TGuildL, #status_gwar_guild.ranking_score, ?DIVISION_GUILD_NUM),
    SqlArgs = [[TGuildId, TDivision, TRanking]
                ||#status_gwar_guild{guild_id = TGuildId, ranking = TRanking} <- NewTGuildL],
    NewDivisionMap = DivisionMap#{TDivision => NewTGuildL},
    sort_division_guild_and_update_db(L, NewDivisionMap, SqlArgs ++ DBUpdateSql).

%%--------------------------------------------------
%% 自动发放未分配的连胜奖励以及终结奖励
%% @param  Dominator        当前的主宰公会数据
%% @return                  description
%%--------------------------------------------------
auto_send_reward(_, #status_dominator{chief_id = 0}) -> skip;
auto_send_reward(AllotType, Dominator) ->
    #status_dominator{
        guild_id = GuildId,
        guild_name = GuildName,
        chief_id = ChiefId,
        reward = StreakReward,
        break_reward = BreakReward
    } = Dominator,
    RewardList = maps:values(StreakReward),
    F = fun(T, Acc) ->
        case T of
            #status_reward{
                reward = TmpReward,
                allot_times = 0         %% 没有分配的自动发给公会会长
            } ->
                TmpReward ++ Acc;
            _ -> Acc
        end
    end,
    NewRewardList = lists:foldl(F, [], RewardList),
    LastRewardList = ulists:object_list_plus([[], NewRewardList]),
    case LastRewardList =/= [] of
        true ->
            lib_log_api:log_guild_war_allot_reward(GuildId, GuildName, ChiefId, AllotType, 1, LastRewardList),
            lib_mail_api:send_sys_mail([ChiefId], utext:get(257), utext:get(258), LastRewardList);
        false -> skip
    end,
    case BreakReward of
        #status_reward{
            reward = BreakRewardList,
            allot_times = 0         %% 没有分配的自动发给公会会长
        } when BreakRewardList =/= [] ->
            lib_log_api:log_guild_war_allot_reward(GuildId, GuildName, ChiefId, AllotType, 2, BreakRewardList),
            lib_mail_api:send_sys_mail([ChiefId], utext:get(259), utext:get(260), BreakRewardList);
        _ -> skip
    end.

%% 发放成为主宰公会的奖励
send_dominator_reward(_OldDominator, #status_dominator{chief_id = 0}) -> skip;
send_dominator_reward(OldDominator, NewDominator) ->
    #status_dominator{chief_id = OldChiefId} = OldDominator,
    #status_dominator{chief_id = NewChiefId, guild_name = NewDominatorGuildName} = NewDominator,

    %% 发送全服传闻
    lib_chat:send_TV({all}, ?MOD_GUILD_ACT, 12, [NewDominatorGuildName]),

    case NewChiefId =/= OldChiefId of
        true ->
            %% 激活称号
            case data_guild_war:get_cfg(dominator_designation) of
                DsgtId when DsgtId > 0 ->
                    lib_designation_api:active_dsgt_common(NewChiefId, DsgtId);
                _ -> skip
            end,
            %% 激活buff
            case data_guild_war:get_cfg(dominator_buff) of
                BuffGTypeId when BuffGTypeId > 0 ->
                    %% 移除上一届主宰公会会长的buff
                    lib_goods_buff:remove_goods_buff_by_type(OldChiefId, ?BUFF_GWAR_DOMINATOR, ?HAND_OFFLINE),
                    lib_goods_buff:add_goods_buff(NewChiefId, BuffGTypeId, 1, []);
                _ -> skip
            end;
        false -> %% 主宰公会连胜不用处理
            skip
    end.

%% 更新公会信息
update_guild_info([], GuildInfo) -> GuildInfo;
update_guild_info([T|L], GuildInfo) ->
    case T of
        {chief_id, Val} ->
            NewGuildInfo = GuildInfo#status_gwar_guild{chief_id = Val};
        {guild_name, Val} ->
            NewGuildInfo = GuildInfo#status_gwar_guild{guild_name = Val};
        {combat_power, CombatPower} ->
            NewGuildInfo = GuildInfo#status_gwar_guild{combat_power = CombatPower};
        _ -> NewGuildInfo = GuildInfo
    end,
    update_guild_info(L, NewGuildInfo).

update_dominator_info(KeyValList, GuildId, StatusDominator) ->
    case StatusDominator#status_dominator.guild_id == GuildId of
        true ->
            do_update_dominator_info(KeyValList, StatusDominator);
        false -> StatusDominator
    end.

do_update_dominator_info([], StatusDominator) -> StatusDominator;
do_update_dominator_info([T|L], StatusDominator) ->
    case T of
        {chief_id, Val} ->
            %% 激活称号
            case data_guild_war:get_cfg(dominator_designation) of
                DsgtId when DsgtId > 0 ->
                    lib_designation_api:active_dsgt_common(Val, DsgtId);
                _ -> skip
            end,
            %% 激活buff
            case data_guild_war:get_cfg(dominator_buff) of
                BuffGTypeId when BuffGTypeId > 0 ->
                    %% 移除旧会长的buff
                    lib_goods_buff:remove_goods_buff_by_type(StatusDominator#status_dominator.chief_id, ?BUFF_GWAR_DOMINATOR, ?HAND_OFFLINE),
                    lib_goods_buff:add_goods_buff(Val, BuffGTypeId, 1, []);
                _ -> skip
            end,
            NewStatusDominator = StatusDominator#status_dominator{chief_id = Val};
        {guild_name, Val} ->
            NewStatusDominator = StatusDominator#status_dominator{guild_name = Val};
        _ -> NewStatusDominator = StatusDominator
    end,
    do_update_dominator_info(L, NewStatusDominator).

check_allot_streak_reward([], _StreakRewardMap, RewardL) -> {ok, ulists:object_list_plus(RewardL)};
check_allot_streak_reward([Id|RewardIds], StreakRewardMap, RewardL) ->
    case maps:get(Id, StreakRewardMap, false) of
        #status_reward{allot_times = 0, reward = Reward} ->
            check_allot_streak_reward(RewardIds, StreakRewardMap, [Reward|RewardL]);
        #status_reward{} ->
            {false, ?ERRCODE(err402_reward_has_allot)};
        _ ->
            {false, ?ERRCODE(err402_unacommpolished)}
    end.

allot_reward(State, ?ALLOT_REWARD_TYPE_STREAK, RoleId, SpecifyId, RewardIds) ->
    #status_guild_war{
        status_dominator = StatusDominator
    } = State,
    #status_dominator{
        guild_id = GuildId,
        guild_name = GuildName,
        reward = StreakRewardMap
    } = StatusDominator,
    case check_allot_streak_reward(RewardIds, StreakRewardMap, []) of
        {false, ErrorCode} ->
            NewState = State,
            lib_guild_war:send_error_code(RoleId, ErrorCode);
        {ok, AllotRewardL} when AllotRewardL =/= [] ->
            db:execute(io_lib:format(?sql_update_streak_reward_more, [1, util:link_list(RewardIds)])),
            F = fun(TmpId, TmpMap) ->
                case maps:get(TmpId, TmpMap, false) of
                    TmpReward when is_record(TmpReward, status_reward) ->
                        maps:put(TmpId, TmpReward#status_reward{allot_times = 1}, TmpMap);
                    _ -> TmpMap
                end
            end,
            NewStreakRewardMap = lists:foldl(F, StreakRewardMap, RewardIds),
            NewStatusDominator = StatusDominator#status_dominator{reward = NewStreakRewardMap},
            NewState = State#status_guild_war{status_dominator = NewStatusDominator},
            %% 日志
            lib_log_api:log_guild_war_allot_reward(GuildId, GuildName, SpecifyId, ?ALLOT_TYPE_MANUAL, 1, AllotRewardL),
            lib_mail_api:send_sys_mail([SpecifyId], utext:get(238), utext:get(239), AllotRewardL),
            {ok, BinData} = pt_402:write(40253, [?SUCCESS, ?ALLOT_REWARD_TYPE_STREAK]),
            lib_server_send:send_to_uid(RoleId, BinData)
            ;
        _ -> NewState = State
    end,
    NewState;
allot_reward(State, ?ALLOT_REWARD_TYPE_BREAK, RoleId, SpecifyId, _) ->
    #status_guild_war{
        status_dominator = StatusDominator
    } = State,
    #status_dominator{
        guild_id = GuildId,
        guild_name = GuildName,
        break_reward = BreakReward
    } = StatusDominator,
    case BreakReward of
        #status_reward{allot_times = AllotTimes, reward = Reward} when Reward =/= [] ->
            case AllotTimes == 0 of
                true ->
                    NewAllotTimes = AllotTimes + 1,
                    db:execute(io_lib:format(?sql_update_break_reward, [NewAllotTimes, GuildId])),
                    NewBreakReward = BreakReward#status_reward{allot_times = NewAllotTimes},
                    NewStatusDominator = StatusDominator#status_dominator{break_reward = NewBreakReward},
                    NewState = State#status_guild_war{status_dominator = NewStatusDominator},
                    %% 日志
                    lib_log_api:log_guild_war_allot_reward(GuildId, GuildName, SpecifyId, ?ALLOT_TYPE_MANUAL, 2, Reward),
                    lib_mail_api:send_sys_mail([SpecifyId], utext:get(240), utext:get(241), Reward),
                    {ok, BinData} = pt_402:write(40253, [?SUCCESS, ?ALLOT_REWARD_TYPE_BREAK]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                false ->
                    NewState = State,
                    lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_reward_has_allot))
            end;
        _ ->
            NewState = State,
            lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_unacommpolished))
    end,
    NewState.

%% 检测是否所有房间的战斗结果都已经同步完成
is_sync_battle_result_finish(RoomMap) ->
    RoomList = maps:values(RoomMap),
    F = fun(T) ->
        case T of
            #gwar_room{winner_id = WinnerId} when WinnerId > 0 ->
                true;
            _ -> false
        end
    end,
    lists:all(F, RoomList).

broadcast_act_info(State) ->
    #status_guild_war{status = Status, etime = Etime, game_times = GameTimes} = State,
    Round = lib_guild_war:get_battle_round(),
    {ok, BinData} = pt_402:write(40240, [Status, GameTimes, Round, Etime]),
    lib_server_send:send_to_all(BinData).








