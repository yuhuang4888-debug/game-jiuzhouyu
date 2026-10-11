%%-----------------------------------------------------------------------------
%% @Module  :       lib_diamond_league_closed.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-25
%% @Description:    星钻联盟结束期
%%-----------------------------------------------------------------------------

-module (lib_diamond_league_closed).
-include ("diamond_league.hrl").
-include ("predefine.hrl").
-include ("common.hrl").
-export ([
     init_state/4
    ,update_state/5
    ,get_league_info/3
    ,handle_cast/2
    ,handle_info/2
    ]).

init_state(CycleIndex, StateId, StartTime, EndTime) ->
    Roles = load_roles(CycleIndex),
    % MinPower = calc_min_power(RoleList),
    State = #schedule_state{
        cycle_index = CycleIndex,
        state_id = StateId,
        start_time = StartTime,
        end_time = EndTime,
        roles = Roles
    },
    State.

update_state(OldState, CycleIndex, StateId, StartTime, EndTime) ->
    %% todo 也许要处理OldState
    State = OldState#schedule_state{
        cycle_index = CycleIndex,
        state_id = StateId,
        start_time = StartTime,
        end_time = EndTime
    },
    if
        OldState#schedule_state.state_id =:= ?STATE_KING_CHOOSE ->
            erlang:send_after(60000, self(), {close_scene, CycleIndex}),
            EnterRoles = maps:get(enter_players, OldState#schedule_state.typical_data, []),
            [lib_diamond_league:player_apply_cast_from_center(RoleId, lib_diamond_league_enter, player_quit, []) || RoleId <- EnterRoles];
        true ->
            ok
    end,
    State.

get_league_info(Node, RoleId, State) ->
    #schedule_state{roles = RoleMap, cycle_index = CycleIndex} = State,
    case lib_diamond_league_melee:calc_last_role(RoleMap, RoleId, ?MELEE_ROUND_NUM + ?KING_ROUND_NUM + 1) of
        #league_role{index = Index, round = Round} ->
            IsLose = 1,
            {ok, BinData} = pt_604:write(60404, [CycleIndex, Index, IsLose, Round]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            mod_clusters_center:apply_cast(Node, mod_diamond_league_local, mark_player_lose, [RoleId, Round]);
        _ ->
            {ok, BinData} = pt_604:write(60404, [CycleIndex, 0, 0, 0]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            mod_clusters_center:apply_cast(Node, mod_diamond_league_local, mark_role_never_apply, [RoleId])
    end.

handle_cast({player_quit, Node, RoleId}, State) ->
    #schedule_state{typical_data = TypicalData} = State,
    EnterRoles = maps:get(enter_players, TypicalData, []),
    % ?DEBUG("player_quit ~p~n", [RoleId]),
    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_diamond_league_enter, player_quit, []),
    NewEnterRoles = lists:delete(RoleId, EnterRoles),
    {noreply, State#schedule_state{typical_data = TypicalData#{enter_players => NewEnterRoles}}};


handle_cast(gm_next, State) ->
    mod_diamond_league_ctrl:gm_next(),
    {noreply, State};

handle_cast(_, State) ->
    {noreply, State}.

handle_info({close_scene, CycleIndex}, #schedule_state{cycle_index = CycleIndex} = State) ->
    WaitScene = data_diamond_league:get_kv(?CFG_KEY_WAITING_SCENE),
    BattleScene = data_diamond_league:get_kv(?CFG_KEY_BATTLE_SCENE),
    [
        case mod_scene_agent:get_scene_pid(Id, PoolId) of
            ScenePid when is_pid(ScenePid) ->
                mod_scene_agent:close_scene(Id, PoolId);
            _ ->
                ok
        end || Id <- [WaitScene, BattleScene], PoolId <- lists:seq(1, ?POOL_NUM)
    ],
    {noreply, State};

handle_info(_, State) ->
    {noreply, State}.

load_roles(CycleIndex) ->
    RoleSQL = io_lib:format("(SELECT `role_id`, `round`, `index`, `power`, `win`, `life` FROM `diamond_league_roles` WHERE `cycle_index` = ~p) AS `role`", [CycleIndex]),
    SQLWithFigure = io_lib:format("SELECT  `role`.`role_id`, `role`.`round`, `role`.`index`, `role`.`power`, `role`.`win`, `role`.`life`, `name`, `sex`, `career`, `turn`, `pic`, `picvsn`, `guild_name`, `server_name` FROM `diamond_league_role_figure` RIGHT JOIN ~s ON `diamond_league_role_figure`.role_id = `role`.role_id", [RoleSQL]),
    All = db:get_all(SQLWithFigure),
    init_roles(All, #{}).

init_roles([[RoleId, Round, Index, Power, Win, Life, Name, Sex, Career, Turn, Pic, PicVer, GuildName, ServerName]|T], RoleMap) ->
    RoleList = maps:get(Round, RoleMap, []),
    Role = #league_role{role_id = RoleId, round = Round, index = Index, win = Win, power = Power, life = Life, data = #{figure => #league_figure{name = ?VALUE(Name, <<"">>), sex = ?VALUE(Sex, 0), career = ?VALUE(Career, 0), turn = ?VALUE(Turn, 0), pic = ?VALUE(Pic, <<"">>), picvsn = ?VALUE(PicVer, 0), guild_name = ?VALUE(GuildName, <<"">>), power = Power, server_name = ?VALUE(ServerName, <<"">>)}}},
    NewRoleList = [Role|RoleList],
    init_roles(T, RoleMap#{Round => NewRoleList});

init_roles([], RoleMap) -> RoleMap.