%%-----------------------------------------------------------------------------
%% @Module  :       lib_diamond_league_apply.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-23
%% @Description:    
%%-----------------------------------------------------------------------------

-module (lib_diamond_league_apply).
-include ("common.hrl").
-include ("diamond_league.hrl").
-include ("errcode.hrl").
-include ("predefine.hrl").
-export ([handle_cast/2, handle_info/2]).
-export ([
     init_state/4
    ,update_state/5
    ,get_league_info/3

    ,apply/3
    ,update_role_power/4
    ,delete_apply/2
    ,gm_apply_all/0
    ,log_apply_roles/1
    ,get_apply_list/1
    ,diamond_league_cancel_mail/2
    ,apply_cancel_return/1
]).

-define (SERVER, mod_diamond_league_schedule).


init_state(CycleIndex, StateId, StartTime, EndTime) ->
    RoleList = load_roles(StartTime, EndTime),
    MinPower = calc_min_power(RoleList),
    State = #schedule_state{
        cycle_index = CycleIndex,
        state_id = StateId,
        start_time = StartTime,
        end_time = EndTime,
        roles = RoleList,
        typical_data = MinPower
    },
    % ?PRINT("apply start ~p~n", [[StartTime, EndTime]]),
    State.

update_state(_OldState, CycleIndex, StateId, StartTime, EndTime) ->
    %% todo 也许要处理OldState
    State = #schedule_state{
        cycle_index = CycleIndex,
        state_id = StateId,
        start_time = StartTime,
        end_time = EndTime,
        roles = [],
        typical_data = 0
    },
    % ?PRINT("apply start ~p~n", [[StartTime, EndTime]]),
    State.

get_league_info(Node, RoleId, State) ->
    #schedule_state{roles = RoleList, cycle_index = CycleIndex} = State,
    Index = ulists:find_index(fun
        (#apply_role{role_id = Id}) ->
            Id =:= RoleId
    end, RoleList),
    {ok, BinData} = pt_604:write(60404, [CycleIndex - 1, Index, 0, 0]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    if
        Index =:= 0 ->
            mod_clusters_center:apply_cast(Node, mod_diamond_league_local, mark_role_never_apply, [RoleId]);
        true ->
            mod_clusters_center:apply_cast(Node, mod_diamond_league_local, mark_player_applied, [RoleId, Index])
    end.

apply(Node, RoleId, RoleArgs) ->
    gen_server:cast(?SERVER, {apply, Node, RoleId, RoleArgs}).

update_role_power(Node, RoleId, Power, Index) ->
    gen_server:cast(?SERVER, {update_role_power, Node, RoleId, Power, Index}).

delete_apply(Node, RoleId) ->
    gen_server:cast(?SERVER, {delete_apply, Node, RoleId}).

gm_apply_all() ->
    gen_server:cast(?SERVER, gm_apply_all).

get_apply_list(Node) ->
    gen_server:cast(?SERVER, {get_apply_list, Node}).

handle_cast({apply, Node, RoleId, RoleArgs}, State) ->
    #schedule_state{typical_data = MinPower, roles = RoleList} = State,
    [Power, RoleName, ServName, GuildName, Lv] = RoleArgs,
    case lists:keyfind(RoleId, #apply_role.role_id, RoleList) of
        false ->
            if
                Power >= MinPower ->
                    Role = #apply_role{role_id = RoleId, power = Power, time = utime:unixtime(), server_name = ServName, role_name = RoleName, guild_name = GuildName, lv = Lv},
                    save_apply_role(Role),
                    {MyIndex, NewRoleList} = ulists:sorted_insert(fun insert_sort_fun/2, Role, RoleList),
                    NewMinPower = calc_min_power(NewRoleList),
                    % {ok, BinData} = pt_604:write(60403, [MyIndex, Power, NewMinPower]),
                    % lib_server_send:send_to_uid(Node, RoleId, BinData),
                    mod_clusters_center:apply_cast(Node, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_diamond_league, player_cost_apply, [MyIndex, NewMinPower]]),
                    if
                        NewMinPower =/= MinPower ->
                            mod_clusters_center:apply_to_all_node(mod_diamond_league_local, update_min_power, [NewMinPower], 50);
                        true ->
                            skip
                    end,
                    {noreply, State#schedule_state{typical_data = NewMinPower, roles = NewRoleList}};
                true ->
                    {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_apply_power_limit), []]),
                    lib_server_send:send_to_uid(Node, RoleId, BinData),
                    {noreply, State}
            end;
        _ ->
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_apply_repeat), []]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            {noreply, State}
    end;

handle_cast({update_role_power, Node, RoleId, Power, OIndex}, State) ->
    #schedule_state{typical_data = MinPower, roles = RoleList} = State,
    case lists:keytake(RoleId, #apply_role.role_id, RoleList) of
        {value, #apply_role{power = OPower} = Role, TmpList} when OPower =/= Power ->
            NewRole = Role#apply_role{power = Power},
            update_apply_role(NewRole),
            {Index, NewRoleList} = ulists:sorted_insert(fun insert_sort_fun/2, NewRole, TmpList),
            if
                Index =/= OIndex ->
                    mod_clusters_center:apply_cast(Node, mod_diamond_league_local, update_role_power_res, [RoleId, Power, Index]);
                true ->
                    ok
            end,
            case calc_min_power(NewRoleList) of
                MinPower ->
                    {noreply, State#schedule_state{roles = NewRoleList}};
                NewMinPower ->
                    mod_clusters_center:apply_to_all_node(mod_diamond_league_local, update_min_power, [NewMinPower], 50),
                    {noreply, State#schedule_state{typical_data = NewMinPower, roles = NewRoleList}}
            end;
        _ ->
            {noreply, State}
    end;

handle_cast({delete_apply, Node, RoleId}, State) ->
    #schedule_state{typical_data = MinPower, roles = RoleList} = State,
    case lists:keytake(RoleId, #apply_role.role_id, RoleList) of
        {value, Role, NewRoleList} ->
            delete_apply_role(Role),
            mod_clusters_center:apply_cast(Node, mod_diamond_league_local, mark_role_never_apply, [RoleId]),
            case calc_min_power(NewRoleList) of
                MinPower ->
                    {noreply, State#schedule_state{roles = NewRoleList}};
                NewMinPower ->
                    mod_clusters_center:apply_to_all_node(mod_diamond_league_local, update_min_power, [NewMinPower], 50),
                    {noreply, State#schedule_state{typical_data = NewMinPower, roles = NewRoleList}}
            end;
        _ ->
            {noreply, State}
    end;

handle_cast(gm_apply_all, #schedule_state{start_time = StartTime, end_time = EndTime} = State) ->
    db:execute("REPLACE INTO diamond_league_apply (`role_id`, `power`, `time`) SELECT `id`, `hightest_combat_power`, UNIX_TIMESTAMP() FROM player_high WHERE `hightest_combat_power` > 0"),
    RoleList = load_roles(StartTime, EndTime),
    MinPower = calc_min_power(RoleList),
    NewState = State#schedule_state{
        roles = RoleList,
        typical_data = MinPower
    },
    mod_clusters_center:apply_to_all_node(mod_diamond_league_local, update_min_power, [MinPower], 50),
    {noreply, NewState};

handle_cast(gm_next, State) ->
    mod_diamond_league_ctrl:gm_next(),
    {noreply, State};

handle_cast({get_apply_list, Node}, State) ->
    #schedule_state{roles = RoleList} = State,
    mod_clusters_center:apply_cast(Node, mod_diamond_league_local, set_apply_list, [RoleList]),
    {noreply, State};

handle_cast(_, State) ->
    {noreply, State}.

handle_info(_, State) ->
    % ?PRINT("~p~n", [State]),
    {noreply, State}.


load_roles(StartTime, EndTime) ->
    SQL = io_lib:format("SELECT `role_id`, `power`, `time`, `server_name`, `role_name`, `role_lv`, `guild_name` FROM `diamond_league_apply` WHERE `time` >= ~p AND `time` < ~p ORDER BY `power` DESC, `time`", [StartTime, EndTime]),
    All = db:get_all(SQL),
    F = fun
        ([RoleId, Power, Time, ServName, RoleName, RoleLv, GuildName]) ->
            #apply_role{
                role_id = RoleId,
                power = Power,
                time = Time,
                server_name = ServName,
                role_name = RoleName,
                lv = RoleLv,
                guild_name = GuildName
            }
    end,
    [F(R) || R <- All].

save_apply_role(#apply_role{role_id = RoleId, power = Power, time = Time, server_name = ServName, role_name = RoleName, lv = RoleLv, guild_name = GuildName}) ->
    SQL = io_lib:format("REPLACE INTO `diamond_league_apply` (`role_id`, `power`, `time`, `server_name`, `role_name`, `role_lv`, `guild_name`) VALUES(~p, ~p, ~p, '~s', '~s', ~p, '~s')", [RoleId, Power, Time, ServName, RoleName, RoleLv, GuildName]),
    db:execute(SQL).

update_apply_role(#apply_role{role_id = RoleId, power = Power}) ->
    SQL = io_lib:format("UPDATE `diamond_league_apply` SET `power`=~p WHERE `role_id`=~p", [Power, RoleId]),
    db:execute(SQL).

delete_apply_role(#apply_role{role_id = RoleId}) ->
    SQL = io_lib:format("DELETE FROM `diamond_league_apply` WHERE `role_id`=~p", [RoleId]),
    db:execute(SQL).

calc_min_power(RoleList) ->
    case length(RoleList) of
        L when L >= ?TOTAL_APPLY_NUM ->
            [#apply_role{power = Power}|_] = lists:reverse(lists:sublist(RoleList, ?TOTAL_APPLY_NUM)),
            Power;
        _ ->
            0
    end.

insert_sort_fun(#apply_role{power = Power1}, #apply_role{power = Power2}) ->
    Power1 > Power2.

log_apply_roles([]) -> ok;
log_apply_roles(RoleList) ->
    {_, LogRoles} = lists:foldl(fun
        (#apply_role{role_id = RoleId, power = Power, server_name = ServName, role_name = RoleName, time = Time}, {Index, Acc}) ->
            {Index + 1, [[RoleId, RoleName, ServName, Power, Time, Index]|Acc]}
    end, {1, []}, RoleList),
    lib_log_api:log_diamond_league_apply(LogRoles).

diamond_league_cancel_mail(StartTime, EndTime) ->
    ApplyRoles = load_roles(StartTime, EndTime),
    spawn(fun () ->
        [begin
             lib_diamond_league:apply_cast_from_center(RoleId, ?MODULE, apply_cancel_return, [RoleId]),
             timer:sleep(1000)
         end || #apply_role{role_id = RoleId} <- ApplyRoles]
        end),
    log_apply_roles(ApplyRoles),
    SQL = io_lib:format("DELETE FROM `diamond_league_apply` WHERE `time`>=~p AND `time` < ~p", [StartTime, EndTime]),
    db:execute(SQL),
    ok.

%% 非正常取消的返还
apply_cancel_return(RoleId) ->
    case data_diamond_league:get_kv(?CFG_KEY_APPLY_COST) of
        [_|_] = Cost ->
            Title = "“星钻联赛”报名返还",
            Content = "“星钻联赛”已修改到每周四开启，在此特返还报名消耗的联赛门票，感谢各位勇士的参与，咱们周四再战！",
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Cost);
        _ ->
            ok
    end.
