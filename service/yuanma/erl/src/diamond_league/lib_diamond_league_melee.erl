%%-----------------------------------------------------------------------------
%% @Module  :       lib_diamond_league_melee.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-23
%% @Description:    星钻联赛混战期
%%-----------------------------------------------------------------------------

-module (lib_diamond_league_melee).
-include ("common.hrl").
-include ("diamond_league.hrl").
-include ("predefine.hrl").
-include ("errcode.hrl").
-export ([
     init_state/4
    ,update_state/5
    ,get_league_info/3
    ,handle_cast/2
    ,handle_info/2
    ,send_battle_info/3
    ,calc_last_role/3
    ]).

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
    #schedule_state{roles = RoleList} = OldState,
    {ChooseList, FailList} = lists:partition(fun
        (#league_role{data = Data}) ->
            maps:is_key(enter_args, Data)
    end, RoleList),
    spawn(fun () ->
        [begin
            lib_diamond_league:apply_cast_from_center(Id, lib_diamond_league_battle, player_handle_result, [Id, 0, 1, ?RES_REASON_NO_ENTER]),
            timer:sleep(10000)
        end|| #league_role{role_id = Id} <- FailList]
    end),
    ScheduleRoles = init_schedule_roles(ChooseList, ?ROLE_NUM(1)),
    State = #schedule_state{
        cycle_index = CycleIndex,
        state_id = StateId,
        start_time = StartTime,
        end_time = EndTime,
        roles = #{1 => ScheduleRoles},
        typical_data = #{round => 1, enter_players => [RoleId || #league_role{role_id = RoleId} <- ChooseList], win_list => []}
    },
    % ?DEBUG("melee start ~p~n ~p~n", [[StartTime, EndTime], ScheduleRoles]),
    start_round(State).


get_league_info(Node, RoleId, State) ->
    #schedule_state{roles = RoleMap, typical_data = #{round := CurRound}, cycle_index = CycleIndex} = State,
    case calc_last_role(RoleMap, RoleId, CurRound) of
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
    case lists:member(RoleId, EnterRoles) of
        true ->
            case check_role_in_battle(RoleId, maps:get(CurRound, RoleMap, [])) of
                false ->
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

handle_cast({handle_battle_result, CurRound, Infos}, #schedule_state{typical_data = #{round := CurRound} = TypicalData} = State) ->
    % ?DEBUG("handle_battle_result ~p~n", [[CurRound, Infos]]),
    #schedule_state{roles = RoleMap, cycle_index = CycleIndex} = State,
    RETime = maps:get(round_end_time, TypicalData, 0),
    RoleList = maps:get(CurRound, RoleMap, []),
    {NewRoleList, SaveList} = handle_battle_result(Infos, RoleList, []),
    save_roles(SaveList, CycleIndex),
    send_battle_info(CurRound, SaveList, RETime),
    AccWinList = maps:get(win_list, TypicalData, []),
    WinList = [{RoleName, ServerName} || #league_role{win = ?WIN_STATE_WIN, data = #{figure := #league_figure{name = RoleName, server_name = ServerName}}} <- SaveList] ++ AccWinList,
    NewRoleMap = RoleMap#{CurRound => NewRoleList},
    {noreply, State#schedule_state{roles = NewRoleMap, typical_data = TypicalData#{win_list => WinList}}};


handle_cast({get_battle_info, Node, RoleId}, State) ->
    #schedule_state{roles = RoleMap, state_id = StateId, typical_data = #{round := CurRound}} = State,
    case calc_last_role(RoleMap, RoleId, CurRound) of
        #league_role{life = Life, round = Round, win = Win} ->
            {ok, BinData} = pt_604:write(60406, [StateId, CurRound, Win, Round, Life]);
        _ ->
            {ok, BinData} = pt_604:write(60406, [StateId, CurRound, ?WIN_STATE_LOSE, 0, 0])
    end,
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {noreply, State};


handle_cast({buy_life, Node, RoleId, Num}, State) ->
    #schedule_state{roles = RoleMap, typical_data = #{round := CurRound} = TypicalData} = State,
    RoleList = maps:get(CurRound, RoleMap, []),
    EnterRoles = maps:get(enter_players, TypicalData, []),
    case lists:member(RoleId, EnterRoles) of
        true ->
            case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
                #league_role{life = Life, data = Data, win = ?WIN_STATE_WIN} ->
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
    RoleList = maps:get(CurRound, RoleMap, []),
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{life = Life, data = Data} = Role ->
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
            NewRoleMap = RoleMap#{CurRound => NewRoleList},
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

handle_cast(gm_next, State) ->
    #schedule_state{typical_data = #{round := CurRound}} = State,
    if
        CurRound < ?MELEE_ROUND_NUM ->
            handle_info({next_round, CurRound}, State);
        true ->
            mod_diamond_league_ctrl:gm_next(),
            {noreply, State}
    end;

handle_cast({get_60415_msg, Node, RoleId}, State) ->
    #schedule_state{roles = RoleMap, typical_data = #{round := CurRound, round_end_time := EndTime}} = State,
    RoleList = maps:get(CurRound, RoleMap, []),
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{win = ?WIN_STATE_WIN} ->
            {ok, BinData} = pt_604:write(60415, [4, EndTime]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            skip
    end,
    {noreply, State};

handle_cast({visit_battle, Node, VisitorId, BattleRoleId, EnterArgs}, State) ->
    #schedule_state{roles = RoleMap, typical_data = #{round := CurRound}} = State,
    BattleRoles = maps:get(CurRound, RoleMap, []),
    case lists:keyfind(VisitorId, #league_role.role_id, BattleRoles) of
        #league_role{win = ?WIN_STATE_NONE} ->
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_competitor_cannot_visit), []]),
            lib_server_send:send_to_uid(Node, VisitorId, BinData); %% 参赛选手不能观战
        _ ->
            case lists:keyfind(BattleRoleId, #league_role.role_id, BattleRoles) of
                #league_role{win = ?WIN_STATE_NONE, data = #{battle_pid := BattlePid}} ->
                    mod_battle_field:apply_cast(BattlePid, lib_diamond_league_battle, visit_battle, {Node, VisitorId, EnterArgs});
                _ ->
                    {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_battle_end), []]),
                    lib_server_send:send_to_uid(Node, VisitorId, BinData)
            end
    end,
    {noreply, State};

handle_cast(_, State) ->
    {noreply, State}.

handle_info({next_round, CurRound}, #schedule_state{typical_data = #{round := CurRound}} = State) ->
    NextRound = CurRound + 1,
    #schedule_state{roles = RoleMap, typical_data = TypicalData, cycle_index = CycleIndex} = State,
    EnterRoles = maps:get(enter_players, TypicalData, []),
    RoleList = maps:get(CurRound, RoleMap, []),
    {ChooseList, FailList} = lists:foldl(fun
        (#league_role{role_id = RoleId, win = ?WIN_STATE_WIN, data = Data} = Role, {Acc, OutList}) ->
        % (#league_role{role_id = RoleId, data = Data} = Role, {Acc, }) ->
            case lists:member(RoleId, EnterRoles) of
                true ->
                    {[Role#league_role{win = ?WIN_STATE_NONE, round = NextRound, data = Data#{battle_pid => undefined}}|Acc], OutList};
                _ ->
                    {Acc, [Role|OutList]}
            end;
        (_, Acc) ->
            Acc
    end, {[], []}, RoleList),
    ScheduleRoles = init_schedule_roles(ChooseList, ?ROLE_NUM(NextRound)),
    save_roles(ChooseList, CycleIndex),
    % ?DEBUG("next_round ~p ~p~n", [NextRound, ScheduleRoles]),
    NewRoleMap = RoleMap#{NextRound => ScheduleRoles},
    [lib_diamond_league:apply_cast_from_center(Id, lib_diamond_league_battle, player_handle_result, [Id, 0, 1, ?RES_REASON_NO_ENTER]) || #league_role{role_id = Id} <- FailList],
    State1 = State#schedule_state{typical_data = TypicalData#{round => NextRound, win_list => []}, roles = NewRoleMap},
    NewState = start_round(State1),
    {noreply, NewState};

handle_info(_, State) ->
    {noreply, State}.


calc_cur_round(StartTime, EndTime) ->
    NowTime = utime:unixtime(),
    max(1, min(?MELEE_ROUND_NUM, util:ceil((NowTime - StartTime)/(EndTime - StartTime) * ?MELEE_ROUND_NUM))).


init_schedule_roles(Roles, NeedNum) ->
    Len = length(Roles),
    if
        Len == NeedNum ->
            make_pair(Roles);
        Len > NeedNum ->
            make_pair(lists:sublist(Roles, NeedNum));
        true ->
            SortRoles = lists:reverse(lists:keysort(#league_role.power, Roles)),
            FakeNum = NeedNum - Len,
            if
                FakeNum =< Len ->
                    {RolesPairFake, PairRoles} = ulists:sublist(SortRoles, FakeNum),
                    make_fake_pair(RolesPairFake) ++ make_pair(PairRoles);
                true ->
                    make_fake_pair(SortRoles)
            end
    end.

make_pair(Roles) ->
    RandRoles = ulists:list_shuffle(Roles),
    RandRoles.

make_fake_pair(Roles) ->
    lists:foldl(fun
        (#league_role{role_id = RoleId} = R, Acc) ->
            [R, R#league_role{role_id = 16#FFFFFFFF band RoleId, life = 0}|Acc]
    end, [], Roles).


start_round(State) ->
    #schedule_state{typical_data = Data, roles = RoleMap, start_time = StartTime, end_time = EndTime} = State,
    #{round := CurRound} = Data,
    RoleList = maps:get(CurRound, RoleMap, []),
    NextTime = StartTime + trunc((EndTime - StartTime) / ?MELEE_ROUND_NUM * CurRound),
    Delay = max(1, NextTime - utime:unixtime()) * 1000,
    % ?DEBUG("start_round ~p ~p~n", [Delay, NextTime]),
    ORef = maps:get(round_ref, Data, []),
    NewRoleList = start_battle_field(RoleList, [Delay, CurRound], []),
    if
        CurRound < ?MELEE_ROUND_NUM ->
            Ref = util:send_after(ORef, Delay, self(), {next_round, CurRound});
        true ->
            Ref = undefined
    end,
    {ok, BinData} = pt_604:write(60418, [CurRound]),
    [lib_clusters_center:send_to_uid(RoleId, BinData) || RoleId <- maps:get(enter_players, Data, [])],
    NewRoleMap = RoleMap#{CurRound => NewRoleList},
    State#schedule_state{typical_data = Data#{round_ref => Ref, round_end_time => NextTime}, roles = NewRoleMap}.

start_battle_field([#league_role{data = DA} = A, #league_role{data = DB} = B|T], Args, Acc) ->
    % ?DEBUG("start_battle_field ~p~n", [[A#league_role.role_id, B#league_role.role_id]]),
    Pid = mod_battle_field:start(lib_diamond_league_battle, [A, B, Args]),
    start_battle_field(T, Args, [B#league_role{data = DB#{battle_pid => Pid}}, A#league_role{data = DA#{battle_pid => Pid}}|Acc]);

start_battle_field([A], _, Acc) ->
    ?ERR("start_battle_field error ~p~n", [A]),
    Acc;

start_battle_field([], _, Acc) ->
    Acc.

check_role_in_battle(RoleId, RoleList) ->
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{win = ?WIN_STATE_NONE} ->
            true;
        _ ->
            false
    end.

handle_battle_result([{RoleId, Res, Life, Figure, _}|T], RoleList, Acc) ->
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{data = Data} = R ->
            Win
            = if
                Res =:= 1 ->
                    ?WIN_STATE_WIN;
                true ->
                    ?WIN_STATE_LOSE
            end,
            NR = R#league_role{win = Win, life = Life, data = Data#{figure => Figure}, power = Figure#league_figure.power},
            NewRoleList = lists:keystore(RoleId, #league_role.role_id, RoleList, NR),
            handle_battle_result(T, NewRoleList, [NR|Acc]);
        _ ->
            handle_battle_result(T, RoleList, Acc)
    end;


handle_battle_result([], RoleList, Acc) -> {RoleList, Acc}.

calc_last_role(RoleMap, RoleId, Round) when Round > 0 ->
    RoleList = maps:get(Round, RoleMap, []),
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        false ->
            calc_last_role(RoleMap, RoleId, Round - 1);
        R ->
            R
    end;
calc_last_role(_, _, _) -> undefined.

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
    {ok, BinData} = pt_604:write(60406, [?STATE_MELEE, CurRound, Win, Round, Life]),
    lib_clusters_center:send_to_uid(RoleId, BinData),
    send_battle_info(CurRound, T, RETime);

send_battle_info(_, [], _RETime) -> ok.



save_roles([], _) -> ok;
save_roles(RoleList, CycleIndex) ->
    RolesStr = ulists:list_to_string([io_lib:format("(~p, ~p, ~p, ~p, ~p, ~p, ~p)", [RoleId, Round, CycleIndex, Index, Power, Win, Life]) || #league_role{role_id = RoleId, round = Round,  index = Index, power = Power, win = Win, life = Life} <- RoleList], ","),
    SQL = io_lib:format("REPLACE INTO `diamond_league_roles` (`role_id`, `round`, `cycle_index`, `index`, `power`, `win`, `life`) VALUES ~s", [RolesStr]),
    db:execute(SQL).