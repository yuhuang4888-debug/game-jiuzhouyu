%%-----------------------------------------------------------------------------
%% @Module  :       lib_diamond_league_king_fight.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-25
%% @Description:    星钻联赛王者塞
%%-----------------------------------------------------------------------------

-module (lib_diamond_league_king_fight).
-include ("common.hrl").
-include ("diamond_league.hrl").
-include ("predefine.hrl").
-include ("errcode.hrl").
-include ("def_module.hrl").
-export ([
     init_state/4
    ,update_state/5
    ,get_league_info/3
    ,handle_cast/2
    ,handle_info/2
    ]).

-define (INDEX_TO_MSG_INDEX (Index, Round), (Index - math:pow(2, ?MELEE_ROUND_NUM + ?KING_ROUND_NUM + 1 -Round) + 1)).
% -define ?MELEE_ROUND_NUM + ?KING_ROUND_NUM, ?MELEE_ROUND_NUM + ?KING_ROUND_NUM).
-record (battle_pair, {
    pair = 0,
    pid,
    roles = [],
    visitors = []
    }).

% -define (ROLE_NUM (Round), trunc(?TOTAL_APPLY_NUM / math:pow(2, (Round-1)))).
init_state(CycleIndex, StateId, StartTime, EndTime) ->
    Round = calc_cur_round(StartTime, EndTime),
    State = #schedule_state{
        cycle_index = CycleIndex,
        state_id = StateId,
        start_time = StartTime,
        end_time = EndTime,
        roles = #{},
        typical_data = #{round => Round, enter_players => []}
    },
    State.

update_state(OldState, CycleIndex, StateId, StartTime, EndTime) ->
    #schedule_state{roles = RoleMap, typical_data = TypicalData} = OldState,
    RoleList = maps:get(?MELEE_ROUND_NUM, RoleMap, []),
    Round = ?MELEE_ROUND_NUM + 1,
    ChooseList = [R#league_role{round = Round, win = ?WIN_STATE_NONE} || #league_role{win = ?WIN_STATE_WIN} = R <- RoleList],
    % ChooseList = [R#league_role{round = Round, win = ?WIN_STATE_NONE} || R <- RoleList],
    {RealList, FakeList} = lists:partition(fun
        (#league_role{role_id = RoleId}) ->
            RoleId > 16#FFFFFFFF
    end, ChooseList),
    RoleNeedNum = ?ROLE_NUM(Round),
    SortList = lists:keysort(#league_role.power, RealList),

    SetupRealList = make_pair(lists:sublist(SortList, RoleNeedNum), RoleNeedNum, RoleNeedNum*2-1),
    ScheduleRoles = fill_empty_pos_with_fake(SetupRealList, FakeList, RoleNeedNum),
    ?DEBUG("king start ~p~n", [ScheduleRoles]),
    save_roles_figure(ScheduleRoles),
    save_roles(ScheduleRoles, CycleIndex),
    save_history(ScheduleRoles, CycleIndex),
    State = OldState#schedule_state{
        cycle_index = CycleIndex,
        state_id = StateId,
        start_time = StartTime,
        end_time = EndTime,
        roles = RoleMap#{Round => ScheduleRoles},
        typical_data = TypicalData#{round => Round, win_list => []}
    },
    % ?PRINT("king start ~p~n", [[StartTime, EndTime]]),
    State,
    start_round(State).


get_league_info(Node, RoleId, State) ->
    #schedule_state{roles = RoleMap, typical_data = #{round := CurRound}, cycle_index = CycleIndex} = State,
    case lib_diamond_league_melee:calc_last_role(RoleMap, RoleId, CurRound) of
        #league_role{index = Index, round = Round, win = Win} ->
            IsLose 
            = if 
                Round < CurRound -> 1;
                Win == ?WIN_STATE_LOSE -> 1; 
                true -> 0 
            end,
            {ok, BinData} = pt_604:write(60404, [CycleIndex - 1, Index, IsLose, Round]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            {ok, BinData} = pt_604:write(60404, [CycleIndex - 1, 0, 0, 0]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            mod_clusters_center:apply_cast(Node, mod_diamond_league_local, mark_role_never_apply, [RoleId])
    end.

handle_cast({player_quit, Node, RoleId}, State) ->
    #schedule_state{typical_data = #{round := CurRound} = TypicalData, roles = RoleMap} = State,
    EnterRoles = maps:get(enter_players, TypicalData, []),
    GuessEndTime = maps:get(guess_end_time, TypicalData, 0),
    NowTime = utime:unixtime(),
    % ?DEBUG("player_quit ~p~n", [RoleId]),
    case lists:member(RoleId, EnterRoles) of
        true ->
            case NowTime < GuessEndTime orelse check_role_in_battle(RoleId, maps:get(CurRound, RoleMap, [])) == false of
                true ->
                    % ?DEBUG("quit ! ~p~n", [RoleId]),
                    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_diamond_league_enter, player_quit, []),
                    NewEnterRoles = lists:delete(RoleId, EnterRoles),
                    {noreply, State#schedule_state{typical_data = TypicalData#{enter_players => NewEnterRoles}}};
                _ ->
                    {noreply, State}
            end;
        _ ->
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_not_competitor), []]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            {noreply, State}
    end;

handle_cast({player_logout, RoleId}, State) ->
    #schedule_state{typical_data = TypicalData} = State,
    EnterRoles = maps:get(enter_players, TypicalData, []),
    % #schedule_state{roles = RoleList} = State,
    case lists:member(RoleId, EnterRoles) of
        true ->
            NewEnterRoles = lists:delete(RoleId, EnterRoles),
            {noreply, State#schedule_state{typical_data = TypicalData#{enter_players => NewEnterRoles}}};
        _ ->
            {noreply, State}
    end;


handle_cast({handle_battle_result, CurRound, Infos}, #schedule_state{typical_data = #{round := CurRound}} = State) ->
    #schedule_state{roles = RoleMap, cycle_index = CycleIndex, typical_data = TypicalData, end_time = EndTime} = State,
    RoleList = maps:get(CurRound, RoleMap, []),
    {NewRoleList, SaveList} = handle_battle_result(Infos, RoleList, []),
    NextRound = CurRound + 1,
    WinList = [R#league_role{round = NextRound, index = I div 2, win = ?WIN_STATE_NONE} || #league_role{win = ?WIN_STATE_WIN, index = I} = R <- SaveList],
    save_roles(WinList ++ SaveList, CycleIndex),
    save_roles_figure(WinList),
    save_history(WinList, CycleIndex),
    RETime = maps:get(round_end_time, TypicalData, 0),
    send_battle_info(CurRound, SaveList, RETime),
    ?DEBUG("handle_battle_result ~p~n~p~n", [Infos, WinList]),
    WinRoles = maps:get(NextRound, RoleMap, []),
    MergeWinRoles = lists:foldl(fun
        (#league_role{role_id = Id} = R, Acc) ->
            lists:keystore(Id, #league_role.role_id, Acc, R)
    end, WinRoles, WinList),
    AccWinList = maps:get(win_list, TypicalData, []),
    NewWinList = [{RoleName, ServerName} || #league_role{data = #{figure := #league_figure{name = RoleName, server_name = ServerName}}} <- WinList] ++ AccWinList,
    NewRoleMap = RoleMap#{CurRound => NewRoleList, NextRound => MergeWinRoles},
    case SaveList of
        [#league_role{index = Index}|_] ->
            PairId = Index div 2,
            case WinList of
                [#league_role{role_id = WinId}|_] ->
                    ok;
                _ -> WinId = 0
            end,
            mod_clusters_center:apply_to_all_node(mod_diamond_league_guess, update_team_after_battle_end, [{CurRound, PairId, WinId}]);
        _ ->
            ok
    end,
    if
        CurRound =:= ?MELEE_ROUND_NUM + ?KING_ROUND_NUM ->
            EnterRoles = maps:get(enter_players, TypicalData, []),
            {ok, BinData} = pt_604:write(60415, [9, EndTime]),
            [lib_clusters_center:send_to_uid(RoleId, BinData) || RoleId <- EnterRoles];
        true ->
            ok
    end,
    {noreply, State#schedule_state{roles = NewRoleMap, typical_data = TypicalData#{win_list => NewWinList}}};

handle_cast({get_battle_info, Node, RoleId}, State) ->
    #schedule_state{roles = RoleMap, state_id = StateId, typical_data = #{round := CurRound}} = State,
    case lib_diamond_league_melee:calc_last_role(RoleMap, RoleId, CurRound) of
        #league_role{life = Life, round = Round, win = Win} ->
            {ok, BinData} = pt_604:write(60406, [StateId, CurRound, Win, Round, Life]);
        _ ->
            {ok, BinData} = pt_604:write(60406, [StateId, CurRound, ?WIN_STATE_LOSE, 0, 0])
    end,
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {noreply, State};

handle_cast({get_competition_list, Node, RoleId}, State) ->
    #schedule_state{roles = RoleMap, typical_data = #{round := CurRound}} = State,
    KingRoleMap = maps:filter(fun
        (Round, _) ->
            Round > ?MELEE_ROUND_NUM
    end, RoleMap),
    BinData = pack_competition_list(CurRound, KingRoleMap),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {noreply, State};


handle_cast({buy_life, Node, RoleId, Num}, State) ->
    #schedule_state{roles = RoleMap, typical_data = #{round := CurRound} = TypicalData} = State,
    EnterRoles = maps:get(enter_players, TypicalData, []),
    case lists:member(RoleId, EnterRoles) of
        true ->
            RoleList = maps:get(CurRound, RoleMap, []),
            NowTime = utime:unixtime(),
            GuessEndTime = maps:get(guess_end_time, TypicalData, 0),
            case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
                #league_role{life = Life, data = Data, win = Win} when Win =:= ?WIN_STATE_WIN orelse (Win =:= ?WIN_STATE_NONE andalso NowTime < GuessEndTime) ->
                    LastBuyLifeTime = maps:get(buy_life_time, Data, 0),
                    NowTime = utime:unixtime(),
                    if
                        Life + Num > ?MAX_LIFE ->
                            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_life_num_max), []]),
                            lib_server_send:send_to_uid(Node, RoleId, BinData);
                        NowTime - LastBuyLifeTime < 10 ->
                            ok;
                        true ->
                            mod_clusters_center:apply_cast(Node, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_diamond_league, cost_buy_life, [Num]])
                    end;
                #league_role{win = ?WIN_STATE_NONE} -> %% 正在比赛中还没出来
                    ok;
                _ ->
                    {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_has_fail), []]),
                    lib_server_send:send_to_uid(Node, RoleId, BinData)
            end;
        _ ->
            ok
    end,
    {noreply, State};

handle_cast({buy_life_done, Node, RoleId, Res}, State) ->
    #schedule_state{roles = RoleMap, typical_data = #{round := CurRound}} = State,
    case lib_diamond_league_melee:calc_last_role(RoleMap, RoleId, CurRound + 1) of
        #league_role{life = Life, data = Data, round = Round} = Role ->
            RoleList = maps:get(Round, RoleMap, []),
            case Res of
                {ok, Num} ->
                    NewRole = Role#league_role{life = Life + Num, data = Data#{buy_life_time => 0}},
                    {ok, BinData} = pt_604:write(60411, [Life + Num]),
                    case maps:get(battle_pid, Data, undefined) of
                        undefined ->
                            ok;
                        BattlePid ->
                            mod_battle_field:apply_cast(BattlePid, lib_diamond_league_battle, add_life, RoleId)
                    end,
                    lib_server_send:send_to_uid(Node, RoleId, BinData);
                _ ->
                    NewRole = Role#league_role{data = Data#{buy_life_time => 0}}
            end,
            NewRoleList = lists:keystore(RoleId, #league_role.role_id, RoleList, NewRole),
            NewRoleMap = RoleMap#{Round => NewRoleList},
            NewState = State#schedule_state{roles = NewRoleMap},
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

handle_cast({get_round_win_roles, Node, RoleId}, State) -> 
    #schedule_state{typical_data = #{win_list := WinList}} = State,
    {ok, BinData} = pt_604:write(60416, [WinList]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {noreply, State};

handle_cast({get_competitors_for_guess, Node}, State) ->
    #schedule_state{roles = RoleMap, typical_data = #{round := CurRound} = Data} = State,
    List = maps:fold(fun
        (Round, RoleList, Acc) when Round > ?MELEE_ROUND_NUM ->
            RoleList ++ Acc;
        (_, _, Acc) -> Acc
    end, [], RoleMap),
    GuessEndTime = maps:get(guess_end_time, Data, 0),
    SlimList = [R#league_role{data = #{figure => Figure}} || #league_role{data = #{figure := Figure}} = R <- List],
    mod_clusters_center:apply_cast(Node, mod_diamond_league_guess, set_competitors_for_guess, [CurRound, SlimList, GuessEndTime]),
    {noreply, State};

handle_cast({visit_battle, Node, VisitorId, BattleRoleId, EnterArgs}, State) ->
    #schedule_state{roles = RoleMap, typical_data = #{round := CurRound} = TypicalData} = State,
    BattleRoles = maps:get(CurRound, RoleMap, []),
    BattlePairs = maps:get(battle_pair, TypicalData, []),
    case lists:keyfind(VisitorId, #league_role.role_id, BattleRoles) of
        #league_role{win = ?WIN_STATE_NONE} ->
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_competitor_cannot_visit), []]),
            lib_server_send:send_to_uid(Node, VisitorId, BinData); %% 参赛选手不能观战
        _ ->
            case lists:keyfind(BattleRoleId, #league_role.role_id, BattleRoles) of
                #league_role{win = ?WIN_STATE_NONE, index = Index} ->
                    PairId = Index div 2,
                    case lists:keyfind(PairId, #battle_pair.pair, BattlePairs) of
                        #battle_pair{pid = BattlePid} when is_pid(BattlePid) ->
                            mod_battle_field:apply_cast(BattlePid, lib_diamond_league_battle, visit_battle, {Node, VisitorId, EnterArgs});
                        _ ->
                            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_battle_end), []]),
                            lib_server_send:send_to_uid(Node, VisitorId, BinData)
                    end;
                _ ->
                    {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_battle_end), []]),
                    lib_server_send:send_to_uid(Node, VisitorId, BinData)
            end
    end,
    {noreply, State};

handle_cast(gm_next, State) ->
    #schedule_state{typical_data = #{round := CurRound} = TypicalData} = State,
    case maps:find(start_ref, TypicalData) of
        {ok, _} ->
            handle_info({round_start, CurRound}, State);
        _ ->
            if
                CurRound < ?MELEE_ROUND_NUM + ?KING_ROUND_NUM ->
                    handle_info({next_round, CurRound}, State);
                true ->
                    mod_diamond_league_ctrl:gm_next(),
                    {noreply, State}
            end
    end;

handle_cast({get_60415_msg, Node, RoleId}, State) ->
    #schedule_state{roles = RoleMap, typical_data = #{round := CurRound, round_end_time := EndTime} = Data} = State,
    RoleList = maps:get(CurRound, RoleMap, []),
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{win = ?WIN_STATE_WIN} ->
            GuessEndTime = maps:get(guess_end_time, Data, 0),
            NowTime = utime:unixtime(),
            if
                NowTime < GuessEndTime ->
                    {ok, BinData} = pt_604:write(60415, [10, GuessEndTime]);
                CurRound >= ?MELEE_ROUND_NUM + ?KING_ROUND_NUM ->
                    {ok, BinData} = pt_604:write(60415, [9, EndTime]);
                true ->
                    {ok, BinData} = pt_604:write(60415, [8, EndTime])
            end,
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            skip
    end,
    {noreply, State};

handle_cast(_, State) ->
    {noreply, State}.

handle_info({next_round, CurRound}, #schedule_state{typical_data = #{round := CurRound}} = State) ->
    NextRound = CurRound + 1,
    #schedule_state{typical_data = TypicalData} = State,
    State1 = State#schedule_state{typical_data = TypicalData#{round => NextRound, win_list => []}},
    NewState = start_round(State1),
    {noreply, NewState};

handle_info({round_start, CurRound}, #schedule_state{typical_data = #{round := CurRound}} = State) ->
    #schedule_state{roles = RoleMap, typical_data = TypicalData} = State,
    RoleList = maps:get(CurRound, RoleMap, []),
    util:cancel_timer(maps:get(start_ref, TypicalData, [])),
    EnterRoles = maps:get(enter_players, TypicalData, []),
    BattlePairs = start_battle_field([R#league_role{data = D#{enter => lists:member(Id, EnterRoles)}} || #league_role{role_id = Id, data = D} = R <- RoleList]),
    ?DEBUG("round_start ~p~n", [[utime:unixtime(), CurRound]]),
    {noreply, State#schedule_state{typical_data = maps:remove(start_ref, TypicalData#{battle_pair => BattlePairs})}};
handle_info(_, State) ->
    {noreply, State}.


calc_cur_round(StartTime, EndTime) ->
    NowTime = utime:unixtime(),
    max(1, min(?KING_ROUND_NUM, util:ceil((NowTime - StartTime)/(EndTime - StartTime) * ?KING_ROUND_NUM))) + ?MELEE_ROUND_NUM.

start_round(State) ->
    #schedule_state{typical_data = Data, start_time = StartTime, end_time = EndTime, roles = RoleMap} = State,
    #{round := CurRound} = Data,
    NowTime = utime:unixtime(),
    NextTime = StartTime + trunc((EndTime - StartTime) / ?KING_ROUND_NUM * (CurRound - ?MELEE_ROUND_NUM)),
    Delay = max(1, NextTime - NowTime) * 1000,
    ORef = maps:get(round_ref, Data, []),
    % start_battle_field(RoleList, [Delay, CurRound]),
    if
        CurRound < ?KING_ROUND_NUM + ?MELEE_ROUND_NUM ->
            Ref = util:send_after(ORef, Delay, self(), {next_round, CurRound});
        true ->
            Ref = undefined
    end,
    StartDelay = max(1, Delay - ?TOTAL_BATTLE_MS), %% 5分钟比赛时间，其余为竞猜时间
    GuessEndTime = NowTime + trunc(StartDelay/1000),
    OSRef = maps:get(start_ref, Data, []),
    SRef = util:send_after(OSRef, StartDelay, self(), {round_start, CurRound}),
    ?DEBUG("start_round ~p~n", [[CurRound, Delay, StartDelay]]),
    SlimList = [R#league_role{data = #{figure => Figure}} || #league_role{data = #{figure := Figure}} = R <- maps:get(CurRound, RoleMap, [])],
    mod_clusters_center:apply_to_all_node(mod_diamond_league_guess, set_competitors_for_guess, [CurRound, SlimList, GuessEndTime]),
    {ok, BinData} = pt_604:write(60415, [10, GuessEndTime]),
    [lib_clusters_center:send_to_uid(RoleId, BinData) || #league_role{role_id = RoleId} <- SlimList],
    State#schedule_state{typical_data = Data#{round_ref => Ref, start_ref => SRef, guess_end_time => GuessEndTime, round_end_time => NextTime}}.

start_battle_field(RoleList) ->
    F = fun
        (#league_role{index = I} = R, Acc) ->
            P = I div 2,
            case lists:keyfind(P, 1, Acc) of
                {P, List} ->
                    lists:keystore(P, 1, Acc, {P,[R|List]});
                _ ->
                    [{P, [R]}|Acc]
            end
    end,
    Pairs = lists:foldl(F, [], RoleList),
    [do_start_battle_field(Item)|| Item <- Pairs].

do_start_battle_field({P, [#league_role{role_id = Id1, round = CurRound, data = #{enter := AEnter}} = A, #league_role{role_id = Id2, data = #{enter := BEnter}} = B]}) ->
    ?DEBUG("do_start_battle_field ~p : ~p~n", [[Id1, AEnter, A#league_role.index], [Id2, BEnter, B#league_role.index]]),
    if
        AEnter andalso BEnter ->
            Pid = mod_battle_field:start(lib_diamond_league_battle, [A, B, [?TOTAL_BATTLE_MS, CurRound]]),
            #battle_pair{pair = P, pid = Pid};
        AEnter ->
            #league_role{life = Life, data = DataA, power = PowerA} = A,
            #league_role{data = DataB, power = PowerB} = B,
            FigureA = maps:get(figure, DataA, #league_figure{power = PowerA}),
            FigureB = maps:get(figure, DataB, #league_figure{power = PowerB}),
            ResInfos = [{Id1, 1, Life, FigureA, 0}, {Id2, 0, 0, FigureB, 0}],
            lib_diamond_league:apply_cast_from_center(Id1, lib_diamond_league_battle, player_handle_result, [Id1, 1, CurRound, ?RES_REASON_NO_ENTER]),
            lib_diamond_league:apply_cast_from_center(Id2, lib_diamond_league_battle, player_handle_result, [Id2, 0, CurRound, ?RES_REASON_NO_ENTER]),
            Node = lib_clusters_center:get_node_by_role_id(Id1),
            mod_diamond_league_schedule:get_60415_msg(Node, Id1),
            lib_diamond_league_battle:log_battle(CurRound, ResInfos),
            mod_diamond_league_schedule:handle_battle_result(CurRound, ResInfos),
            #battle_pair{pair = P};
        BEnter ->
            #league_role{data = DataA, power = PowerA} = A,
            #league_role{life = Life, data = DataB, power = PowerB} = B,
            FigureA = maps:get(figure, DataA, #league_figure{power = PowerA}),
            FigureB = maps:get(figure, DataB, #league_figure{power = PowerB}),
            ResInfos = [{Id1, 0, 0, FigureA, 0}, {Id2, 1, Life, FigureB, 0}], 
            lib_diamond_league:apply_cast_from_center(Id1, lib_diamond_league_battle, player_handle_result, [Id1, 0, CurRound, ?RES_REASON_NO_ENTER]),
            lib_diamond_league:apply_cast_from_center(Id2, lib_diamond_league_battle, player_handle_result, [Id2, 1, CurRound, ?RES_REASON_NO_ENTER]),
            Node = lib_clusters_center:get_node_by_role_id(Id2),
            mod_diamond_league_schedule:get_60415_msg(Node, Id2),
            lib_diamond_league_battle:log_battle(CurRound, ResInfos),
            mod_diamond_league_schedule:handle_battle_result(CurRound, ResInfos),
            #battle_pair{pair = P};
        true ->
            #league_role{data = DataA, power = PowerA} = A,
            #league_role{data = DataB, power = PowerB} = B,
            FigureA = maps:get(figure, DataA, #league_figure{power = PowerA}),
            FigureB = maps:get(figure, DataB, #league_figure{power = PowerB}),
            ResInfos = [{Id1, 0, 0, FigureA, 0}, {Id2, 0, 0, FigureB, 0}],
            lib_diamond_league:apply_cast_from_center(Id1, lib_diamond_league_battle, player_handle_result, [Id1, 0, CurRound, ?RES_REASON_NO_ENTER]),
            lib_diamond_league:apply_cast_from_center(Id2, lib_diamond_league_battle, player_handle_result, [Id2, 0, CurRound, ?RES_REASON_NO_ENTER]),
            lib_diamond_league_battle:log_battle(CurRound, ResInfos),
            mod_diamond_league_schedule:handle_battle_result(CurRound, ResInfos),
            #battle_pair{pair = P}
    end;

do_start_battle_field({P, [#league_role{role_id = Id, round = CurRound, data = #{enter := Enter}} = A]}) ->
    #league_role{life = Life, data = Data, power = Power} = A,
    Figure = maps:get(figure, Data, #league_figure{power = Power}),
    ?DEBUG("do_start_battle_field ~p~n", [[Id, Enter, A#league_role.index]]),
    if
        Enter ->
            ResInfos = [{Id, 1, Life, Figure, 0}],
            lib_diamond_league:apply_cast_from_center(Id, lib_diamond_league_battle, player_handle_result, [Id, 1, CurRound, ?RES_REASON_NO_ENEMY]),
            lib_diamond_league_battle:log_battle(CurRound, ResInfos),
            mod_diamond_league_schedule:handle_battle_result(CurRound, ResInfos),
            Node = lib_clusters_center:get_node_by_role_id(Id),
            mod_diamond_league_schedule:get_60415_msg(Node, Id),
            #battle_pair{pair = P};
        true ->
            ResInfos = [{Id, 0, 0, Figure, 0}],
            lib_diamond_league:apply_cast_from_center(Id, lib_diamond_league_battle, player_handle_result, [Id, 0, CurRound, ?RES_REASON_NO_ENEMY]),
            lib_diamond_league_battle:log_battle(CurRound, ResInfos),
            mod_diamond_league_schedule:handle_battle_result(CurRound, ResInfos),
            #battle_pair{pair = P}
    end.


check_role_in_battle(RoleId, RoleList) ->
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{win = ?WIN_STATE_NONE} ->
            true;
        _ ->
            false
    end.

handle_battle_result([{RoleId, Res, Life, Figure, _}|T], RoleList, Acc) ->
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{data = Data, round = Round, win = ?WIN_STATE_NONE} = R ->
            if
                Res =:= 1 ->
                    if
                        Round == ?MELEE_ROUND_NUM + ?KING_ROUND_NUM ->
                            #league_figure{server_name = ServName, name = Name} = Figure,
                            ServerId = mod_player_create:get_serid_by_id(RoleId),
                            {ok, BinData} = pt_650:write(65042, [ServerId, RoleId]),
                            mod_clusters_center:apply_to_all_node(lib_server_send, send_to_all, [BinData]),
                            mod_clusters_center:apply_to_all_node(lib_chat, send_TV, [{all}, ?MOD_DIAMOND_LEAGUE, 1, [ServName, Name]]);
                        true ->
                            ok
                    end,
                    Win = ?WIN_STATE_WIN;
                true ->
                    Win = ?WIN_STATE_LOSE
            end,
            NR = R#league_role{win = Win, life = Life, data = Data#{figure => Figure}, power = Figure#league_figure.power},
            NewRoleList = lists:keystore(RoleId, #league_role.role_id, RoleList, NR),
            handle_battle_result(T, NewRoleList, [NR|Acc]);
        _ ->
            handle_battle_result(T, RoleList, Acc)
    end;


handle_battle_result([], RoleList, Acc) -> {RoleList, Acc}.


send_battle_info(CurRound, [#league_role{role_id = RoleId, win = Win, round = Round, life = Life}|T], RETime) ->
    % if
    %     Win =:= ?WIN_STATE_LOSE ->
    %         ok;
    %         % MyRound = Round;
    %     true ->
    %         % {ok, BinData1} = pt_604:write(60415, [4, RETime]),
    %         % lib_clusters_center:send_to_uid(RoleId, BinData1)
    %         % MyRound = Round
    % end,
    {ok, BinData} = pt_604:write(60406, [?STATE_KING_CHOOSE, CurRound, Win, Round, Life]),
    lib_clusters_center:send_to_uid(RoleId, BinData),
    send_battle_info(CurRound, T, RETime);

send_battle_info(_, [], _RETime) -> ok.


make_pair(RoleList, Index, Index) ->
    case RoleList of
        [R] ->
            [R#league_role{index = Index}];
        [] ->
            []
    end;

%% 战力越高的人离得越远
make_pair(RoleList, Index1, Index2) ->
    {RoleList1, RoleList2} = split_roles(RoleList, {[], []}),
    Min = (Index1 + Index2) div 2,
    make_pair(RoleList1, Index1, Min) ++ make_pair(RoleList2, Min + 1, Index2).

split_roles([], Acc) ->
    Acc;
split_roles([A], {Acc1, Acc2}) ->
    {Acc1 ++ [A], Acc2};
split_roles([A, B|T], {Acc1, Acc2}) ->
    Acc = {Acc1 ++ [A], [B|Acc2]},
    split_roles(T, Acc).

fill_empty_pos_with_fake(RealList, FakeList, RoleNeedNum) ->
    Len = length(RealList),
    if
        RoleNeedNum =< Len ->
            RealList;
        true ->
            FreePos = lists:seq(RoleNeedNum, RoleNeedNum * 2 - 1) -- [I || #league_role{index = I} <- RealList],
            RealList ++ setup_fake_index(FakeList, FreePos, [])
    end.

setup_fake_index([#league_role{data = D} = R|T], [I|L], Acc) ->
    setup_fake_index(T, L, [R#league_role{index = I, data = D#{enter => false}, life = 0}|Acc]);

setup_fake_index(_, _, Acc) -> Acc.

% role_list:array{
%                 role_id:int64,
%                 name:string
%                 server_name:string
%                 power:int32
%                 sex:int8
%                 career:int8
%                 turn:int8
%                 pic:string
%                 picvsn:32
%             }
pack_competition_list(CurRound, RoleMap) ->
    List = maps:fold(fun
        (Round, List, Acc) when Round =< ?MELEE_ROUND_NUM + ?KING_ROUND_NUM ->
            NeedNum = ?ROLE_NUM(Round),
            PairNum = NeedNum div 2,
            FormatRoleList 
            = [begin 
                    Pair = PairNum + I - 1,
                    Index1 = Pair * 2,
                    Index2 = Index1 + 1,
                    case lists:keyfind(Index1, #league_role.index, List) of
                        #league_role{role_id = RoleId1, data = Data1, power = Power1} ->
                            Figure1 = maps:get(figure, Data1, #league_figure{});
                        _ ->
                            RoleId1 = 0, Figure1 = #league_figure{}, Power1 = 0
                    end,
                    #league_figure{name = Name1, server_name = ServName1, sex = Sex1, career = Career1, turn = Turn1, pic = Pic1, picvsn = PicVer1} = Figure1,

                    case lists:keyfind(Index2, #league_role.index, List) of
                        #league_role{role_id = RoleId2, data = Data2, power = Power2} ->
                            Figure2 = maps:get(figure, Data2, #league_figure{});
                        _ ->
                            RoleId2 = 0, Figure2 = #league_figure{}, Power2 = 0
                    end,
                    #league_figure{name = Name2, server_name = ServName2, sex = Sex2, career = Career2, turn = Turn2, pic = Pic2, picvsn = PicVer2} = Figure2,
                    {RoleId1, Name1, ServName1, Power1, Sex1, Career1, Turn1, Pic1, PicVer1, RoleId2, Name2, ServName2, Power2, Sex2, Career2, Turn2, Pic2, PicVer2}
            end || I <- lists:seq(1, PairNum)],
            [{Round, FormatRoleList}|Acc];
        (Round, [#league_role{role_id = RoleId1, data = Data1, power = Power1}|_], Acc) ->
            Figure1 = maps:get(figure, Data1, #league_figure{}),
            #league_figure{name = Name1, server_name = ServName1, sex = Sex1, career = Career1, turn = Turn1, pic = Pic1, picvsn = PicVer1} = Figure1,
            FormatRoleList = [{RoleId1, Name1, ServName1, Power1, Sex1, Career1, Turn1, Pic1, PicVer1, 0, "", "", 0, 0, 0, 0, "", 0}],
            [{Round, FormatRoleList}|Acc];
        (_, _, Acc) ->
            Acc
    end, [], RoleMap),
    {ok, BinData} = pt_604:write(60412, [CurRound, List]),
    BinData.

save_roles([], _) -> ok;
save_roles(RoleList, CycleIndex) ->
    RolesStr = ulists:list_to_string([io_lib:format("(~p, ~p, ~p, ~p, ~p, ~p, ~p)", [RoleId, Round, CycleIndex, Index, Power, Win, Life]) || #league_role{role_id = RoleId, round = Round,  index = Index, power = Power, win = Win, life = Life} <- RoleList], ","),
    SQL = io_lib:format("REPLACE INTO `diamond_league_roles` (`role_id`, `round`, `cycle_index`, `index`, `power`, `win`, `life`) VALUES ~s", [RolesStr]),
    db:execute(SQL).

save_roles_figure([]) -> ok;
save_roles_figure(RoleList) ->
    RolesStr = ulists:list_to_string([io_lib:format("(~p, '~s', ~p, ~p, ~p, '~s', ~p, '~s', '~s', '~s', '~s', '~s', ~p)", [RoleId, Name, Sex, Career, Turn, Pic, PicVer, GuildName, ServName, util:term_to_string(LvModel), util:term_to_string(FashionModel), util:term_to_string(GodWeaponModel), Wing]) || #league_role{role_id = RoleId, data = #{figure := #league_figure{name = Name, sex = Sex, career = Career, turn = Turn, pic = Pic, picvsn = PicVer, guild_name = GuildName, server_name = ServName, lv_model = LvModel, fashion_model = FashionModel, god_weapon_model = GodWeaponModel, wing = Wing}}} <- RoleList], ","),
    SQL = io_lib:format("REPLACE INTO `diamond_league_role_figure` (`role_id`, `name`, `sex`, `career`, `turn`, `pic`, `picvsn`, `guild_name`, `server_name`, `lv_model`, `fashion_model`, `god_weapon_model`, `wing`) VALUES ~s", [RolesStr]),
    db:execute(SQL).

save_history([], _) -> ok;
save_history(RoleList, CycleIndex) ->
    RolesStr = ulists:list_to_string([io_lib:format("(~p, ~p, ~p, ~p)", [RoleId, Round, CycleIndex, Power]) || #league_role{role_id = RoleId, round = Round, power = Power} <- RoleList], ","),
    SQL = io_lib:format("REPLACE INTO `diamond_league_history` (`role_id`, `round`, `cycle_index`, `power`) VALUES ~s", [RolesStr]),
    db:execute(SQL).

