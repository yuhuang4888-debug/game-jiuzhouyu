%% ---------------------------------------------------------------------------
%% @doc mod_guild_dun_fight
%% @author 
%% @since  
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(mod_guild_dun_fight).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([
    start/1
    ]).
-compile(export_all).
-include("guild_dun.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
%%-----------------------------

%%初始化战场
start([RoleId, GuildId, Figure, Type, Door, LevelInfo]) ->
    gen_server:start(?MODULE, [RoleId, GuildId, Figure, Type, Door, LevelInfo], []).


%%apply_cast
apply_cast(RoomPid, Msg) ->
    gen_server:cast(RoomPid, Msg).

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([RoleId, GuildId, Figure, Type, Door, LevelInfo]) ->
    SceneInfo = init_scene_info(RoleId, Type, Door, LevelInfo),
    NowTime = utime:unixtime(),
    RefEnd = util:send_after([], 120*1000, self(), {end_battle}),
    Data = #{
        battle_state => ?BATTLE_STATE_START,
        role_info => [RoleId, GuildId, Figure, ?ROLE_STATE_FREE],
        end_time => NowTime+120,
        challenge_type => {Type, Door},
        level_info => LevelInfo,
        scene_info => SceneInfo
    },
    State = #guild_dun_fight_state{data = Data, ref_end = RefEnd},
    ?PRINT("fight init ================== ~n", []),
    {ok, State}.

init_scene_info(RoleId, Type, Door, LevelInfo) ->
    {SceneId, PoolId} = lib_guild_dun:get_challenge_scene(RoleId, Type, Door, LevelInfo),
    CopyId = self(),
    MonCreateId = lib_guild_dun:create_challenge_mon(RoleId, Type, Door, LevelInfo, SceneId, PoolId, CopyId),
    _SceneInfo = [SceneId, PoolId, CopyId, MonCreateId],
    _SceneInfo.

%% ====================
%% hanle_call
%% ==================== 
do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 

do_handle_cast({target_die, _Args}, State) ->
    ?PRINT("target_die start : ~n", []),
    NewState = handle_battle_end(State, 1),
    {noreply, NewState};

do_handle_cast({player_die, _Args}, State) ->
    ?PRINT("player_die start : ~n", []),
    NewState = handle_battle_end(State, 0),
    {noreply, NewState};

do_handle_cast({send_guild_dun_endtime, Args}, State) ->
    #guild_dun_fight_state{data = Data} = State,
    [_RoleId, Sid] = Args,
    #{end_time := EndTime, challenge_type := {Type, _Door}, scene_info := [_SceneId, _PoolId, _CopyId, MonCreateId], level_info := LevelInfo} = Data,
    #level_info{challenge_info = ChallengeInfo} = LevelInfo,
    #{combat_power := CombatPower} = ChallengeInfo,
    NewCombatPower = ?IF(Type == 3, CombatPower, 0),
    ?PRINT("send_guild_dun_endtime start : ~p~n", [{MonCreateId, NewCombatPower}]),
    {ok, Bin} = pt_400:write(40052, [EndTime, Type, MonCreateId, NewCombatPower]),
    lib_server_send:send_to_sid(Sid, Bin),
    {noreply, State};

do_handle_cast({player_enter, [RoleId]}, State) ->
    #guild_dun_fight_state{data = Data} = State,
    #{role_info := RoleInfo, challenge_type := {Type, _Door}, scene_info := SceneInfo} = Data,
    [RoleId, GuildId, Figure, _RoleState] = RoleInfo,
    player_enter(Type, RoleId, SceneInfo, true),
    NewData = Data#{role_info => [RoleId, GuildId, Figure, ?ROLE_STATE_FIGHT]},
    NewState = State#guild_dun_fight_state{data = NewData},
    ?PRINT("player_enter ====================  ~n", []),
    {noreply, NewState};

do_handle_cast({reconnect, [RoleId]}, State) ->
    #guild_dun_fight_state{data = Data} = State,
    #{battle_state := BattleState, role_info := RoleInfo, challenge_type := {Type, _Door}, scene_info := SceneInfo} = Data,
    [RoleId, _GuildId, _Figure, RoleState] = RoleInfo,
    case BattleState == ?BATTLE_STATE_START andalso RoleState == ?ROLE_STATE_FIGHT of 
        true ->
            player_enter(Type, RoleId, SceneInfo, false);
        _ -> lib_scene:player_change_default_scene(RoleId, [])
    end,
    {noreply, State};

do_handle_cast({player_leave, _Args}, State) ->
    ?PRINT("player_leave ==================== start  ~n", []),
    #guild_dun_fight_state{data = Data, ref_end = RefEnd} = State,
    NewRef = util:send_after(RefEnd, 5000, self(), {close_battle}),
    #{
        battle_state := BattleState,
        role_info := RoleInfo, challenge_type := {Type, Door}, level_info := LevelInfo, scene_info := SceneInfo
    } = Data,
    [RoleId, GuildId, Figure, RoleState] = RoleInfo,
    case BattleState /= ?BATTLE_STATE_END of 
        true when RoleState /= ?ROLE_STATE_FREE -> %% 没结束 且 玩家没离开场景
            end_battle(RoleId, GuildId, Figure, Type, Door, SceneInfo, LevelInfo, 0),
            KeyValueList = [{group,0},{action_free, ?ERRCODE(err400_in_guild_dun)},{change_scene_hp_lim, 0}],
            lib_scene:player_change_scene(RoleId, 0, 0, 0, 0, 0, true, KeyValueList),
            NewData = Data#{battle_state => ?BATTLE_STATE_END, role_info => [RoleId, GuildId, Figure, ?ROLE_STATE_FREE]};
        true ->
            end_battle(RoleId, GuildId, Figure, Type, Door, SceneInfo, LevelInfo, 0),
            NewData = Data#{battle_state => ?BATTLE_STATE_END};
        _ when RoleState /= ?ROLE_STATE_FREE -> %% 已结束 但 玩家没离开
            KeyValueList = [{group,0},{action_free, ?ERRCODE(err400_in_guild_dun)},{change_scene_hp_lim, 0}],
            lib_scene:player_change_scene(RoleId, 0, 0, 0, 0, 0, true, KeyValueList),
            NewData = Data#{role_info => [RoleId, GuildId, Figure, ?ROLE_STATE_FREE]};
        _ -> NewData = Data
    end,
    NewState = State#guild_dun_fight_state{data = NewData, ref_end = NewRef},
    ?PRINT("player_leave ==================== end ~n", []),
    {noreply, NewState}; 

do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================
do_handle_info({end_battle}, State) ->
    NewState = handle_battle_end(State, 0),
    #guild_dun_fight_state{data = Data} = NewState,
    #{challenge_type := {Type, _Door}, scene_info := SceneInfo} = Data,
    clear_scene_mon(Type, SceneInfo),
    {noreply, NewState};

do_handle_info({leave_battle}, State) ->
    #guild_dun_fight_state{data = Data, ref_end = RefEnd} = State,
    NewRef = util:send_after(RefEnd, 5000, self(), {close_battle}), 
    #{
        role_info := RoleInfo
    } = Data,
    [RoleId, GuildId, Figure, RoleState] = RoleInfo,
    case RoleState == ?ROLE_STATE_FIGHT of 
        true ->
            KeyValueList = [{group,0},{action_free, ?ERRCODE(err400_in_guild_dun)},{change_scene_hp_lim, 0}],
            lib_scene:player_change_scene(RoleId, 0, 0, 0, 0, 0, true, KeyValueList),
            NewData = Data#{role_info => [RoleId, GuildId, Figure, ?ROLE_STATE_FREE]};
        _ ->
            NewData = Data
    end,
    NewState = State#guild_dun_fight_state{data = NewData, ref_end = NewRef},
    {noreply, NewState};

do_handle_info({close_battle}, State) ->
    #guild_dun_fight_state{data = Data, ref_end = RefEnd} = State,
    util:cancel_timer(RefEnd), 
    #{
        challenge_type := {Type, _Door},
        scene_info := SceneInfo
    } = Data,
    clear_scene_all(Type, SceneInfo),
    {stop, normal, State};

do_handle_info(_Info, State) -> {noreply, State}.


handle_battle_end(State, IsWin) ->
    #guild_dun_fight_state{data = Data, ref_end = RefEnd} = State,
    NewRef = util:send_after(RefEnd, 5000, self(), {leave_battle}),
    #{
        role_info := RoleInfo, challenge_type := {Type, Door}, level_info := LevelInfo, scene_info := SceneInfo
    } = Data,
    [RoleId, GuildId, Figure|_] = RoleInfo,
    end_battle(RoleId, GuildId, Figure, Type, Door, SceneInfo, LevelInfo, IsWin),
    NewData = Data#{battle_state => ?BATTLE_STATE_END},
    NewState = State#guild_dun_fight_state{data = NewData, ref_end = NewRef},
    NewState.


end_battle(RoleId, GuildId, Figure, Type, Door, _SceneInfo, _LevelInfo, IsWin) ->
    %% 通知公会副本管理进程战斗结束
    ?PRINT("end_battle start : ~n", []),
    mod_guild_dun_mgr:apply_cast({mod, end_battle, [RoleId, GuildId, Figure, IsWin, Type, Door]}),
    ok.

player_enter(Type, RoleId, SceneInfo, NeedOut) ->
    [SceneId, PoolId, CopyId, _MonCreateId] = SceneInfo,
    [{_, Location}] = data_guild_dun:get_born_info(Type),
    [{X, Y}|_] = Location,
    KeyValueList = [{action_lock, ?ERRCODE(err400_in_guild_dun)}, {group, 1}, {change_scene_hp_lim, 0}],
    lib_scene:player_change_scene(RoleId, SceneId, PoolId, CopyId, X, Y, NeedOut, KeyValueList),
    ok.

clear_scene_all(_Type, SceneInfo) ->
    [SceneId, PoolId, CopyId, _MonCreateId] = SceneInfo,
    lib_scene:clear_scene_room(SceneId, PoolId, CopyId),
    ok.

clear_scene_mon(_Type, SceneInfo) ->
    [SceneId, PoolId, _CopyId, MonCreateId] = SceneInfo,
    lib_mon:clear_scene_mon_by_ids(SceneId, PoolId, 1, [MonCreateId]),
    ok.