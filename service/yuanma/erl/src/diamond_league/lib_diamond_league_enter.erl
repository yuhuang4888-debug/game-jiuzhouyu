%%-----------------------------------------------------------------------------
%% @Module  :       lib_diamond_league_enter.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-23
%% @Description:    星钻联赛进入期
%%-----------------------------------------------------------------------------

-module (lib_diamond_league_enter).
-include ("diamond_league.hrl").
-include ("common.hrl").
-include ("errcode.hrl").
-include ("predefine.hrl").
-include ("scene.hrl").
-include ("server.hrl").
-include ("def_event.hrl").
-include ("rec_event.hrl").

-export ([
     init_state/4
    ,update_state/5
    ,get_league_info/3

    ,handle_cast/2
    ,handle_info/2

    ,handle_evt_logout/2
    ,player_enter/2
    ,player_quit/1
    ]).


init_state(CycleIndex, StateId, StartTime, EndTime) ->
    RoleList = load_roles(CycleIndex),
    State = #schedule_state{
        cycle_index = CycleIndex,
        state_id = StateId,
        start_time = StartTime,
        end_time = EndTime,
        roles = RoleList,
        typical_data = #{}
    },
    State.


update_state(OldState, CycleIndex, StateId, StartTime, EndTime) ->
    #schedule_state{roles = ApplyRoles} = OldState,
    spawn(fun () -> lib_diamond_league_apply:log_apply_roles(ApplyRoles) end),
    ChoosedRoles = calc_selectee(ApplyRoles, CycleIndex), 
    Length = length(ChoosedRoles),
    if
        Length >= ?CANCEL_NUM ->
            State = #schedule_state{
                cycle_index = CycleIndex,
                state_id = StateId,
                start_time = StartTime,
                end_time = EndTime,
                roles = ChoosedRoles,
                typical_data = #{}
            };
        true ->
            [lib_diamond_league:apply_cast_from_center(RoleId, lib_diamond_league, apply_cancel_return, [RoleId]) || #apply_role{role_id = RoleId} <- ApplyRoles],
            mod_diamond_league_ctrl:cancel(),
            State = #schedule_state{cycle_index = CycleIndex, state_id = ?STATE_CLOSED, roles = #{}}
    end,
    State.

get_league_info(Node, RoleId, State) ->
    #schedule_state{roles = RoleList, cycle_index = CycleIndex} = State,
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{index = Index} ->
            Round = 1,
            {ok, BinData} = pt_604:write(60404, [CycleIndex - 1, Index, 0, Round]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            {ok, BinData} = pt_604:write(60404, [CycleIndex - 1, 0, 0, 0]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            mod_clusters_center:apply_cast(Node, mod_diamond_league_local, mark_role_never_apply, [RoleId])
    end.

handle_cast({player_enter, Node, RoleId, RoleArgs}, State) ->
    #schedule_state{roles = RoleList, end_time = EndTime} = State,
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        false ->
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_not_competitor), []]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        #league_role{data = #{enter_args := _}} ->
            {noreply, State};
        #league_role{data = Data} = Role ->
            NewData = Data#{enter_args => RoleArgs},
            NewRole = Role#league_role{data = NewData},
            % EnterNums = lists:sum([1 || #league_role{data = #{enter_args := _}} <- RoleList]),
            CopyId = urand:rand(0, length(RoleList) div 40),
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, player_enter, [CopyId]),
            {ok, BinData} = pt_604:write(60415, [1, EndTime]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            NewRoleList = lists:keystore(RoleId, #league_role.role_id, RoleList, NewRole),
            {noreply, State#schedule_state{roles = NewRoleList}}
    end;

handle_cast({player_quit, Node, RoleId}, State) ->
    #schedule_state{roles = RoleList} = State,
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        false ->
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_not_competitor), []]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        #league_role{data = Data} = Role ->
            NewData = maps:remove(enter_args, Data),
            NewRole = Role#league_role{data = NewData},
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, player_quit, []),
            NewRoleList = lists:keystore(RoleId, #league_role.role_id, RoleList, NewRole),
            {noreply, State#schedule_state{roles = NewRoleList}}
    end;

handle_cast({player_logout, RoleId}, State) ->
    #schedule_state{roles = RoleList} = State,
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        false ->
            {noreply, State};
        #league_role{data = Data} = Role ->
            NewData = maps:remove(enter_args, Data),
            NewRole = Role#league_role{data = NewData},
            NewRoleList = lists:keystore(RoleId, #league_role.role_id, RoleList, NewRole),
            {noreply, State#schedule_state{roles = NewRoleList}}
    end;

handle_cast({get_battle_info, Node, RoleId}, State) ->
    #schedule_state{roles = RoleList, state_id = StateId} = State,
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{life = Life} ->
            {ok, BinData} = pt_604:write(60406, [StateId, 1, 0, 1, Life]);
        _ ->
            {ok, BinData} = pt_604:write(60406, [StateId, 1, 1, 0, 0])
    end,
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {noreply, State};

handle_cast({buy_life, Node, RoleId, Num}, State) ->
    #schedule_state{roles = RoleList} = State,
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{life = Life, data = Data} ->
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
        _ ->
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_not_competitor), []]),
            lib_server_send:send_to_uid(Node, RoleId, BinData)
    end,
    {noreply, State};

handle_cast({buy_life_done, Node, RoleId, Res}, State) ->
    #schedule_state{roles = RoleList} = State,
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{life = Life, data = Data} = Role ->
            case Res of
                {ok, Num} ->
                    NewRole = Role#league_role{life = Life + Num, data = Data#{buy_life_time => 0}},
                    {ok, BinData} = pt_604:write(60411, [Life + Num]),
                    lib_server_send:send_to_uid(Node, RoleId, BinData);
                _ ->
                    NewRole = Role#league_role{data = Data#{buy_life_time => 0}}
            end,
            NewRoleList = lists:keystore(RoleId, #league_role.role_id, RoleList, NewRole),
            NewState = State#schedule_state{roles = NewRoleList},
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

handle_cast(gm_next, State) ->
    mod_diamond_league_ctrl:gm_next(),
    {noreply, State};

handle_cast({get_60415_msg, Node, RoleId}, State) ->
    #schedule_state{roles = RoleList, end_time = EndTime} = State,
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{data = #{enter_args := _}} ->
            {ok, BinData} = pt_604:write(60415, [1, EndTime]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            skip
    end,
    {noreply, State};

handle_cast(_, State) ->
    {noreply, State}.

handle_info(_, State) ->
    {noreply, State}.

calc_selectee(ApplyRoles, CycleIndex) ->
    {ChoosedList, FailList} = ulists:sublist(ApplyRoles, ?TOTAL_APPLY_NUM),
    {NextIndex, ChoosedRoles} = lists:foldl(fun
        (#apply_role{role_id = RoleId, power = Power}, {Index, Acc}) ->
            {Index + 1, [#league_role{role_id = RoleId, index = Index, round = 1, power = Power}|Acc]}
    end, {1, []}, ChoosedList),
    spawn(fun() ->
        [begin lib_diamond_league:apply_cast_from_center(RoleId, lib_diamond_league, apply_fail_return, [RoleId]), timer:sleep(5000) end || #apply_role{role_id = RoleId} <- FailList]
        end),
    if
        NextIndex =< ?CANCEL_NUM ->
            [];
        true ->
            save_roles(CycleIndex, ChoosedRoles),
            ChoosedRoles
    end.

player_enter(Player, CopyId) ->
    SceneId = data_diamond_league:get_kv(?CFG_KEY_WAITING_SCENE),
    #ets_scene{x = X0, y = Y0, reborn_xys = RebornXYs} = data_scene:get(SceneId),
    case urand:list_rand(RebornXYs) of
        {X, Y} ->
            ok;
        _ ->
            X = X0, Y = Y0
    end,
    NewPlayer = lib_scene:change_scene(Player, SceneId, 0, CopyId, X, Y, false, [{action_lock, ?ERRCODE(err604_in_the_act)}]),
    {ok, BinData} = pt_604:write(60405, []),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    lib_player_event:add_listener(?EVENT_DISCONNECT_HOLD_END, ?MODULE, handle_evt_logout, []),
    {ok, NewPlayer}.

player_quit(Player) ->
    SceneId = data_diamond_league:get_kv(?CFG_KEY_WAITING_SCENE),
    lib_player_event:remove_listener(?EVENT_DISCONNECT_HOLD_END, ?MODULE, handle_evt_logout),
    if
        Player#player_status.scene =:= SceneId ->
            NewPlayer = lib_scene:change_default_scene(Player, [{action_free, ?ERRCODE(err604_in_the_act)}]),
            {ok, NewPlayer};
        true ->
            ok
    end.

handle_evt_logout(#player_status{id = RoleId} = Player, #event_callback{type_id = ?EVENT_DISCONNECT_HOLD_END}) ->
    mod_clusters_node:apply_cast(mod_diamond_league_schedule, player_logout, [RoleId]),
    case player_quit(Player) of
        {ok, NewPlayer} ->
            {ok, NewPlayer};
        _ ->
            {ok, lib_player:break_action_lock(Player, ?ERRCODE(err604_in_the_act))}
    end;

handle_evt_logout(Player, _) -> {ok, Player}.


load_roles(CycleIndex) ->
    SQL = io_lib:format("SELECT `role_id`, `index`, `power` FROM `diamond_league_roles` WHERE `cycle_index`=~p AND `round`=1", [CycleIndex]),
    [#league_role{role_id = RoleId, index = ApplyIndex, round = 1, power = Power, life = 0} || [RoleId, ApplyIndex, Power] <- db:get_all(SQL)].

save_roles(CycleIndex, ChoosedRoles) ->
    %% `role_id`, `cycle_index`, `round`, `index`, `win`
    RolesStr = ulists:list_to_string([io_lib:format("(~p, 1, ~p, ~p, ~p, 0, 0)", [RoleId, CycleIndex, ApplyIndex, Power]) || #league_role{role_id = RoleId, index = ApplyIndex, power = Power} <- ChoosedRoles], ","),
    SQL = io_lib:format("REPLACE INTO `diamond_league_roles` (`role_id`, `round`, `cycle_index`, `index`, `power`, `win`, `life`) VALUES ~s", [RolesStr]),
    db:execute(SQL).

