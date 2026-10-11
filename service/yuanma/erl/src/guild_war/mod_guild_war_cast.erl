%%-----------------------------------------------------------------------------
%% @Module  :       mod_guild_war_cast
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-06
%% @Description:
%%-----------------------------------------------------------------------------
-module(mod_guild_war_cast).

-include("guild_war.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("def_module.hrl").

-export([handle_event/3]).

%% 打印公会争霸调试信息
handle_event({'test'}, _StateName, State) ->
    ?ERR("State:~p", [State]),
    #status_guild_war{room_map = GWarRoomMap} = State,
    maps:map(fun(_, #gwar_room{pid = RoomPid}) ->
        RoomPid ! 'test',
        ok
    end, GWarRoomMap),
    {keep_state, State};

%% 重置公会争霸活动,只有在关闭期才有效
handle_event({'gm_reset'}, close, State) ->
    case lib_guild_war_mod:guild_war_reset() of
        {ok, NewStatusDominator} ->
            IndexMap = #{},
            %% 同步赛区信息到公会进程
            mod_guild:update_guild_division(IndexMap),
            NewState = State#status_guild_war{
                status = ?ACT_STATUS_CLOSE,
                game_times = 0,
                index_map = IndexMap,
                division_map = ?ORIGIN_DIVISION_MAP,
                status_dominator = NewStatusDominator
            },
            {next_state, close, NewState};
        _ ->
            {keep_state, State}
    end;

%% 公会争霸活动信息
handle_event({'send_act_info', RoleId}, _StateName, State) ->
    % ?ERR("State:~p", [State]),
    #status_guild_war{status = Status, etime = Etime, game_times = GameTimes} = State,
    Round = lib_guild_war:get_battle_round(),
    {ok, BinData} = pt_402:write(40240, [Status, GameTimes, Round, Etime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {keep_state, State};

%% 公会争霸界面信息
handle_event({'send_gwar_view_info', RoleId}, _StateName, State) ->
    #status_guild_war{status = Status, game_times = GameTimes} = State,
    {ok, BinData} = lib_guild_war:pack_division_list(Status, GameTimes, State),
    lib_server_send:send_to_uid(RoleId, BinData),
    {keep_state, State};

%% 确定D赛区的公会信息
%% 首届比赛取16个公会分配到D赛区
handle_event({'sync_guild_list', GuildList}, StateName, State) when StateName == confirm ->
    case GuildList =/= [] of
        true ->
            NewState = lib_guild_war_mod:sync_guild_list(State, GuildList);
        false ->
            NewState = State
    end,
    {keep_state, NewState};

handle_event({'enter_scene', GuildId, RoleId, JoinGuildTime}, _StateName, State) ->
    #status_guild_war{
        status = ActStatus,
        game_times = GameTimes,
        index_map = IndexMaps,
        room_map = GWarRoomMap,
        division_map = DivisionMap,
        status_dominator = StatusDominator
    } = State,
    Division = maps:get(GuildId, IndexMaps, false),
    NeedJoinTime = data_guild_war:get_cfg(min_join_guild_time),
    NowTime = utime:unixtime(),
    if
        ActStatus =/= ?ACT_STATUS_BATTLE ->
            lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_not_battle_stage));
        Division == false ->
            lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_gwar_no_qualification));
        GameTimes > 0 andalso NowTime - JoinGuildTime < NeedJoinTime ->
            lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_join_in_guild_not_enough_time));
        true ->
            GuildList = maps:get(Division, DivisionMap, []),
            #status_gwar_guild{match_id = _MatchId, room_id = RoomId} = lists:keyfind(GuildId, #status_gwar_guild.guild_id, GuildList),
            #gwar_room{pid = RoomPid, winner_id = WinnerId} = maps:get(RoomId, GWarRoomMap, #gwar_room{}),
            if
                % MatchId == 0 -> %% 轮空
                %     lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_gwar_battle_end));
                WinnerId > 0 ->
                    lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_gwar_battle_end));
                true ->
                    mod_guild_war_battle:enter_scene(RoomPid, GuildId, RoleId, StatusDominator)
            end
    end,
    {keep_state, State};

handle_event({'exit_scene', GuildId, RoleId}, _StateName, State) ->
    #status_guild_war{
        status = ActStatus,
        index_map = IndexMaps,
        room_map = GWarRoomMap,
        division_map = DivisionMap
    } = State,
    Division = maps:get(GuildId, IndexMaps, false),
    if
        ActStatus =/= ?ACT_STATUS_BATTLE -> skip;
        Division == false -> skip;
        true ->
            GuildList = maps:get(Division, DivisionMap, []),
            #status_gwar_guild{room_id = RoomId} = lists:keyfind(GuildId, #status_gwar_guild.guild_id, GuildList),
            #gwar_room{pid = RoomPid} = maps:get(RoomId, GWarRoomMap, #gwar_room{}),
            mod_guild_war_battle:exit_scene(RoomPid, GuildId, RoleId)
    end,
    {keep_state, State};

handle_event({'sync_battle_result', Division, RoomId, WinnerId}, _StateName, State) ->
    #status_guild_war{
        status = ActStatus,
        room_map = GWarRoomMap,
        division_map = DivisionMap
    } = State,
    case maps:get(RoomId, GWarRoomMap, false) of
        Room when is_record(Room, gwar_room) ->
            NewGWarRoomMap = maps:put(RoomId, Room#gwar_room{winner_id = WinnerId}, GWarRoomMap);
        _ ->
            NewGWarRoomMap = GWarRoomMap
    end,
    DivisionGuildL = maps:get(Division, DivisionMap, []),
    F = fun(T) ->
        case T of
            #status_gwar_guild{
                guild_id = WinnerId,
                ranking_score = RankingScore,
                win_times = WinTimes
            } ->
                RankingScorePlus = lib_guild_war:count_ranking_score(),
                T#status_gwar_guild{win_times = WinTimes + 1, ranking_score = RankingScore + RankingScorePlus};
            _ -> T
        end
    end,
    NewDivisionGuildL = lists:map(F, DivisionGuildL),
    NewDivisionMap = maps:put(Division, NewDivisionGuildL, DivisionMap),

    NewState = State#status_guild_war{room_map = NewGWarRoomMap, division_map = NewDivisionMap},

    case ActStatus == ?ACT_STATUS_CLOSE of
        true ->
            case lib_guild_war_mod:is_sync_battle_result_finish(NewGWarRoomMap) of
                true -> %% 活动结束之后最后的房间结算结果同步过来后要处理结算逻辑
                    LastState = lib_guild_war_mod:act_end(NewState);
                false -> LastState = NewState
            end;
        false -> LastState = NewState
    end,

    {keep_state, LastState};

handle_event({'update_guild_info', GuildId, KeyValList}, _StateName, State) ->
    #status_guild_war{
        status = ActStatus,
        index_map = IndexMaps,
        division_map = DivisionMap,
        status_dominator = StatusDominator
    } = State,
    Division = maps:get(GuildId, IndexMaps, false),
    if
        ActStatus =/= ?ACT_STATUS_CLOSE -> NewState = State;
        Division == false -> NewState = State;
        true ->
            GuildList = maps:get(Division, DivisionMap, []),
            GuildInfo = lists:keyfind(GuildId, #status_gwar_guild.guild_id, GuildList),
            if
                is_record(GuildInfo, status_gwar_guild) == false ->
                    NewState = State;
                true ->
                    NewGuildInfo = lib_guild_war_mod:update_guild_info(KeyValList, GuildInfo),
                    NewGuildList = lists:keystore(GuildId, #status_gwar_guild.guild_id, GuildList, NewGuildInfo),
                    NewDivisionMap = maps:put(Division, NewGuildList, DivisionMap),
                    NewStatusDominator = lib_guild_war_mod:update_dominator_info(KeyValList, GuildId, StatusDominator),
                    NewState = State#status_guild_war{division_map = NewDivisionMap, status_dominator = NewStatusDominator}
            end
    end,
    {keep_state, NewState};

handle_event({'disband_guild', GuildId}, _StateName, State) ->
    #status_guild_war{
        status = ActStatus,
        index_map = IndexMaps,
        division_map = DivisionMap
    } = State,
    Division = maps:get(GuildId, IndexMaps, false),
    if
        ActStatus =/= ?ACT_STATUS_CLOSE -> NewState = State;
        Division == false -> NewState = State;
        true ->
            db:execute(io_lib:format(?sql_delete_guild, [GuildId])),
            NewIndexMaps = maps:remove(GuildId, IndexMaps),
            GuildList = maps:get(Division, DivisionMap, []),
            NewGuildList = lists:keydelete(GuildId, #status_gwar_guild.guild_id, GuildList),
            NewDivisionMap = maps:put(Division, NewGuildList, DivisionMap),
            NewState = State#status_guild_war{index_map = NewIndexMaps, division_map = NewDivisionMap}
    end,
    {keep_state, NewState};

handle_event({'send_dominator_info', RoleId, RoleGuildId, JoinGuildTime}, _StateName, State) ->
    #status_guild_war{
        status_dominator = StatusDominator
    } = State,
    #status_dominator{
        guild_id = GuildId,
        guild_name = GuildName,
        chief_id = ChiefId,
        streak_times = StreakTimes
    } = StatusDominator,
    if
        GuildId == 0 ->
            Args = [GuildId, GuildName, #figure{}, StreakTimes, 0];
        true ->
            case lib_role:get_role_show(ChiefId) of
                #ets_role_show{figure = Figure} ->
                    case GuildId == RoleGuildId of
                        true ->
                            NowTime = utime:unixtime(),
                            NeedTime = data_guild_war:get_cfg(min_join_guild_time),
                            case NowTime - JoinGuildTime >= NeedTime of
                                true ->
                                    case catch mod_daily:get_count(RoleId, ?MOD_GUILD_ACT, 1) of
                                        Times when is_integer(Times) ->
                                            LimitTimes = lib_daily:get_count_limit(?MOD_GUILD_ACT, 1),
                                            case Times < LimitTimes of
                                                true -> SalaryStatus = 1;
                                                false -> SalaryStatus = 2
                                            end;
                                        _Error -> SalaryStatus = 2
                                    end;
                                _ -> SalaryStatus = 0
                            end;
                        _ -> SalaryStatus = 0
                    end,
                    Args = [GuildId, GuildName, Figure, StreakTimes, SalaryStatus];
                _ ->
                    Args = [GuildId, GuildName, #figure{}, StreakTimes, 0]
            end
    end,
    {ok, BinData} = pt_402:write(40250, Args),
    lib_server_send:send_to_uid(RoleId, BinData),
    {keep_state, State};

handle_event({'send_streak_reward_info', RoleId}, _StateName, State) ->
    #status_guild_war{
        status_dominator = StatusDominator
    } = State,
    #status_dominator{
        guild_id = GuildId,
        streak_times = StreakTimes,
        reward = StreakRewardMap
    } = StatusDominator,
    WorldLv = util:get_world_lv(),
    F = fun(TStreakTimes) ->
        Reward = data_guild_war:get_streak_reward(WorldLv, TStreakTimes),
        {TStreakTimes, Reward}
    end,
    List = data_guild_war:get_streak_reward_list(),
    FilterList = [TStreakTimes || {TMinWLv, TMaxWLv, TStreakTimes} <- List, WorldLv >= TMinWLv andalso TMaxWLv >= WorldLv],
    RewardArgs = lists:map(F, FilterList),
    NotAllotList = [{TmpId, TmpObjType, TmpObjId, TmpObjNum} || {TmpId, #status_reward{reward = [{TmpObjType, TmpObjId, TmpObjNum}], allot_times = TmpAllotTimes}} <- maps:to_list(StreakRewardMap), TmpAllotTimes == 0],
    {ok, BinData} = pt_402:write(40251, [GuildId, StreakTimes, RewardArgs, NotAllotList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {keep_state, State};

handle_event({'send_break_reward_info', RoleId}, _StateName, State) ->
    #status_guild_war{
        status_dominator = StatusDominator
    } = State,
    #status_dominator{
        guild_id = GuildId,
        streak_times = StreakTimes,
        break_reward = BreakReward
    } = StatusDominator,
    case BreakReward of
        #status_reward{
            allot_times = AllotTimes,
            reward = Reward
        } -> skip;
        _ -> AllotTimes = 1, Reward = []
    end,
    AllotStatus = ?IF(AllotTimes > 0, 1, 0),
    WorldLv = util:get_world_lv(),
    PreviewReward = lib_guild_war:get_break_reward(WorldLv, StreakTimes),
    {ok, BinData} = pt_402:write(40252, [GuildId, AllotStatus, Reward, PreviewReward]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {keep_state, State};

handle_event({'allot_reward', RoleId, GuildId, Type, SpecifyId, Extra}, _StateName, State) ->
    #status_guild_war{
        status_dominator = StatusDominator
    } = State,
    #status_dominator{
        guild_id = DominatorGuildId,
        chief_id = DominatorId
    } = StatusDominator,
    if
        GuildId =/= DominatorGuildId ->
            NewState = State,
            lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_not_dominator));
        RoleId =/= DominatorId ->
            NewState = State,
            lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_no_permission_allot));
        true ->
            SpecifyRole = lib_role:get_role_show(SpecifyId),
            if
                is_record(SpecifyRole, ets_role_show) == false ->
                    NewState = State,
                    lib_guild_war:send_error_code(RoleId, ?ERRCODE(err140_3_role_no_exist));
                SpecifyRole#ets_role_show.figure#figure.guild_id =/= DominatorGuildId ->
                    NewState = State,
                    lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_not_in_guild));
                true ->
                    NewState = lib_guild_war_mod:allot_reward(State, Type, RoleId, SpecifyId, Extra)
            end
    end,
    {keep_state, NewState};

handle_event({'receive_salary_paul', RoleId, GuildId, SalaryPaulReward}, _StateName, State) ->
    #status_guild_war{
        status_dominator = StatusDominator
    } = State,
    #status_dominator{
        guild_id = DominatorGuildId
    } = StatusDominator,
    if
        GuildId =/= DominatorGuildId ->
            lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_not_dominator));
        true ->
            case catch mod_daily:get_count(RoleId, ?MOD_GUILD_ACT, 1) of
                Times when is_integer(Times) ->
                    LimitTimes = lib_daily:get_count_limit(?MOD_GUILD_ACT, 1),
                    case Times < LimitTimes of
                        true ->
                            mod_daily:increment(RoleId, ?MOD_GUILD_ACT, 1),
                            lib_goods_api:send_reward_by_id(SalaryPaulReward, guild_war_salary_paul, RoleId),
                            {ok, BinData} = pt_402:write(40254, [?SUCCESS]),
                            lib_server_send:send_to_uid(RoleId, BinData);
                        false ->
                            lib_guild_war:send_error_code(RoleId, ?ERRCODE(err402_has_receive_salary_paul))
                    end;
                Error ->
                    ?ERR("receive_salary_paul err:~p", [Error]),
                    lib_guild_war:send_error_code(RoleId, ?ERRCODE(system_busy))
            end
    end,
    {keep_state, State};

handle_event({'role_login', GuildId, RoleId}, _StateName, State) ->
    #status_guild_war{
        status_dominator = StatusDominator
    } = State,
    #status_dominator{
        guild_id = DominatorGuildId,
        chief_id = ChiefId
    } = StatusDominator,
    case GuildId == DominatorGuildId andalso RoleId == ChiefId of
        true ->
            case data_guild_war:get_cfg(dominator_buff) of
                BuffGTypeId when BuffGTypeId > 0 ->
                    lib_goods_buff:add_goods_buff(RoleId, BuffGTypeId, 1, []);
                _ -> skip
            end;
        false ->
            skip
    end,
    {keep_state, State};

handle_event(_Msg, _StateName, State) ->
    ?ERR("no match :~p~n", [[ _Msg, _StateName]]),
    {keep_state, State}.