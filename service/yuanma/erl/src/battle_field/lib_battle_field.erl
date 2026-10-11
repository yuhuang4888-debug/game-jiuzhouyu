%%-----------------------------------------------------------------------------
%% @Module  :       lib_battle_field.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-01
%% @Description:    战场控制
%%-----------------------------------------------------------------------------

-module (lib_battle_field).
-include ("server.hrl").
-include ("figure.hrl").
-include ("scene.hrl").
-include ("def_event.hrl").
-include ("rec_event.hrl").
-include ("battle_field.hrl").
-include ("common.hrl").
-include ("predefine.hrl").

-define (TRY_HANDLE_EVT (PS, ListenerMod, Listener, Args), 
    case ?HAS_API(ListenerMod, Listener, 2) of
        true ->
            case ListenerMod:Listener(PS, Args) of
                PS1 when is_record(PS1, player_status) ->
                    PS1;
                _ ->
                    PS
            end;
        _ ->
            PS
    end).

%% 基础接口
-export ([
    take_role_in/9
    ,take_role_out/4
    ,take_role_in_finish/2
    %% 玩家事件回调
    ,handle_player_die/2
    % ,handle_offline/2
    ,handle_disconnect_hold_end/2
    ,handle_player_revive/2
    ,handle_disconnect/2
    ,handle_reconnect/2
    ]).

%% 行为接口
-export ([
    %% 战场进程
    init/2
    ,player_enter/3
    ,player_quit/3
    ,player_logout/3
    ,player_finish_change_scene/3
    ,player_die/3
    ,player_revive/3
    ,player_disconnect/3
    ,player_reconnect/3
    ,mon_hp_change/3
    ,mon_die/3
    %% 玩家进程 不一定需要实现 
    % ,evt_out_of_battle/2
    % ,evt_enter_scene_begin/2
    % ,evt_enter_scene_finish/2
    % ,evt_player_die/2
    ]).

%% 普通接口
-export([remove_listener_in_ps/0]).

-callback init(State::#battle_state{}, Args :: term()) ->
    {ok, State :: #battle_state{}}.

-callback player_enter(RoleKey :: term(), Args :: term(), State :: #battle_state{}) ->
    {ok, Role :: #battle_role{}, NewState :: #battle_state{}} | term().

-callback player_quit(Role :: #battle_role{}, Args :: term(), State :: #battle_state{}) ->
    {ok, Role :: #battle_role{}, NewState :: #battle_state{}} | term().

-callback player_logout(Role :: #battle_role{}, Args :: term(), State :: #battle_state{}) ->
    {ok, Role :: #battle_role{}, NewState :: #battle_state{}} | term().

-callback player_finish_change_scene(Role :: #battle_role{}, Args :: term(), State :: #battle_state{}) ->
    {ok, Role :: #battle_role{}, NewState :: #battle_state{}} | term().

-callback player_die(Role :: #battle_role{}, Args :: term(), State :: #battle_state{}) ->
    {ok, NewState :: #battle_state{}} | term().

-callback player_revive(Role :: #battle_role{}, Args :: term(), State :: #battle_state{}) ->
    {ok, NewState :: #battle_state{}} | term().

-callback player_disconnect(Role :: #battle_role{}, Args :: term(), State :: #battle_state{}) ->
    {ok, NewState :: #battle_state{}} | term().

-callback player_reconnect(Role :: #battle_role{}, Args :: term(), State :: #battle_state{}) ->
    {ok, NewState :: #battle_state{}} | term().

-callback mon_hp_change(MonKey :: term(), Args :: term(), State :: #battle_state{}) ->
    {ok, NewState :: #battle_state{}} | term().

-callback mon_die(MonKey :: term(), Args :: term(), State :: #battle_state{}) ->
    {ok, NewState :: #battle_state{}} | term().

-callback terminate(Reason :: term(), State :: #battle_state{}) ->
    ok.

% -callback handle_take_role_out(Player :: #player_status{}, Reason :: atom()) ->
%     NewPlayer :: #player_status{}.

% -callback handle_before_take_role_in(Player :: #player_status{}) ->
%     NewPlayer :: #player_status{}.

% -callback handle_take_role_in_finish(Player :: #player_status{}) ->
%     NewPlayer :: #player_status{}.

% -callback handle_player_after_die(Player :: #player_status{}) ->
%     NewPlayer :: #player_status{}.

-optional_callbacks(
    [mon_hp_change/3, mon_die/3, player_disconnect/3, player_reconnect/3, terminate/2]).

init(State, _Args) ->
    {ok, State}.

player_enter(_RoleKey, _Args, _State) ->
    skip.

player_quit(_Role, _Args, _State) ->
    skip.

player_logout(_Role, _Args, _State) ->
    skip.

player_finish_change_scene(Role, _Args, State) ->
    {ok, Role, State}.

player_die(_Role, _Args, _State) ->
    skip.

player_revive(_Role, _Args, _State) ->
    skip.

player_disconnect(_Role, _Args, _State) ->
    skip.

player_reconnect(_Role, _Args, _State) ->
    skip.

mon_hp_change(_MonKey, _Args, _State) ->
    skip.

mon_die(_MonKey, _Args, _State) ->
    skip.


take_role_out(Player, OutInfo, ModLib, Reason) ->
    if
        ModLib =:= lib_diamond_league_battle andalso Player#player_status.combat_power > 25000000 ->
            ?ERR("take_role_out res = ~p~n", [[Player#player_status.id, ModLib]]);
        true ->
            ok
    end,
    lib_player_event:remove_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, take_role_in_finish),
    lib_player_event:remove_listener(?EVENT_PLAYER_DIE, ?MODULE, handle_player_die),
    % lib_player_event:remove_listener(?EVENT_ONLINE_FLAG, ?MODULE, handle_offline),
    lib_player_event:remove_listener(?EVENT_REVIVE, ?MODULE, handle_player_revive),
    lib_player_event:remove_listener(?EVENT_DISCONNECT, ?MODULE, handle_disconnect),
    lib_player_event:remove_listener(?EVENT_DISCONNECT_HOLD_END, ?MODULE, handle_disconnect_hold_end),
    lib_player_event:remove_listener(?EVENT_RECONNECT, ?MODULE, handle_reconnect),
    TmpPlayer = ?TRY_HANDLE_EVT(Player, ModLib, evt_out_of_battle, Reason),
    #player_status{figure = #figure{lv = Lv}}  = TmpPlayer, %%  = ModLib:handle_take_role_out(Player, Reason),
    case OutInfo of
        #{scene := SceneId, scene_pool_id := ScenePoolId, copy_id := CopyId, x := X, y := Y, hp := Hp, hp_lim := HpLim,
        scene_args := ArgsList0} ->
            ArgsList = ArgsList0 ++ [{group, 0}, {ghost, 0}, {hp_lim, HpLim}, {hp, Hp}];
        _ ->
            [SceneId, X, Y] = lib_scene:get_outside_scene_by_lv(Lv),
            ScenePoolId = 0, CopyId = 0,
            ArgsList = [{group, 0}, {ghost, 0}]
    end,
    NewPlayer = lib_scene:change_scene(TmpPlayer, SceneId, ScenePoolId, CopyId, X, Y, false, ArgsList),
    {ok, NewPlayer#player_status{battle_field = undefined}}.

take_role_in(Player, SceneId, ScenePoolId, CopyId, InInfo, From, RoleKey, ModLib, Args) ->
    if
        ModLib =:= lib_diamond_league_battle andalso Player#player_status.combat_power > 25000000 ->
            ?ERR("take_role_in res = ~p~n", [[From, RoleKey, ModLib]]);
        true ->
            ok
    end,
    lib_player_event:add_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, take_role_in_finish, [SceneId, ScenePoolId, CopyId, From, RoleKey, ModLib, Args]),
    lib_player_event:add_listener(?EVENT_PLAYER_DIE, ?MODULE, handle_player_die, [From, RoleKey, ModLib]),
    % lib_player_event:add_listener(?EVENT_ONLINE_FLAG, ?MODULE, handle_offline, [From, RoleKey]),
    lib_player_event:add_listener(?EVENT_REVIVE, ?MODULE, handle_player_revive, [From, RoleKey]),
    lib_player_event:add_listener(?EVENT_DISCONNECT, ?MODULE, handle_disconnect, [From, RoleKey, ModLib]),
    lib_player_event:add_listener(?EVENT_DISCONNECT_HOLD_END, ?MODULE, handle_disconnect_hold_end, [From, RoleKey, ModLib]),
    lib_player_event:add_listener(?EVENT_RECONNECT, ?MODULE, handle_reconnect, [From, RoleKey, ModLib]),
    case InInfo of
        #{x := X, y := Y} ->
            ok;
        _ ->
            #ets_scene{x = X, y = Y} = data_scene:get(SceneId)
    end,
    ArgsList = maps:get(scene_args, InInfo, []),
    IsQueue = maps:get(queue_change, InInfo, false),
    #player_status{battle_field = FieldInfo} = Player,
    NewFieldInfo = if FieldInfo =:= undefined -> #{mod_lib => ModLib, pid => From}; true -> FieldInfo#{mod_lib => ModLib, pid => From} end,
    % TmpPlayer = ModLib:handle_before_take_role_in(Player),
    TmpPlayer = ?TRY_HANDLE_EVT(Player#player_status{battle_field = NewFieldInfo}, ModLib, evt_enter_scene_begin, Args),
    if
        IsQueue ->
            NewPlayer = lib_scene:change_scene_queue(TmpPlayer, SceneId, ScenePoolId, CopyId, X, Y, false, ArgsList);
        true ->
            NewPlayer = lib_scene:change_scene(TmpPlayer, SceneId, ScenePoolId, CopyId, X, Y, false, ArgsList)
    end,
    {ok, NewPlayer}.

take_role_in_finish(Player, #event_callback{param = [SceneId, ScenePoolId, CopyId, From, RoleKey, ModLib, Args]}) ->
    % ?PRINT("take_role_in_finish param = ~p~n", [[SceneId, ScenePoolId, CopyId, From, RoleKey, ModLib]]),
    case Player of
        #player_status{battle_field = #{scene := SceneId}} ->
            NewPlayer = Player;
        #player_status{scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, battle_field = BattleField} ->
            % ?PRINT("take_role_in_finish res = ~p~n", [ok]),
            % NewPlayer = ModLib:handle_take_role_in_finish(Player), !!!
            NewPlayer = ?TRY_HANDLE_EVT(Player#player_status{battle_field = BattleField#{scene => SceneId}}, ModLib, evt_enter_scene_finish, Args),
            mod_battle_field:player_finish_change_scene(From, RoleKey, []);
        _ ->
            NewPlayer = Player
    end,
    {ok, NewPlayer}.

handle_player_die(Player, #event_callback{param = [From, RoleKey, ModLib], data = Data}) ->
    if
        ModLib =:= lib_diamond_league_battle andalso Player#player_status.combat_power > 25000000 ->
            ?ERR("event_callback player_die ~p~n", [[From, RoleKey, ModLib]]);
        true ->
            ok
    end,
    NewPlayer = ?TRY_HANDLE_EVT(Player, ModLib, evt_player_die, Data),
    mod_battle_field:player_die(From, RoleKey, Data),
    % NewPlayer = ModLib:handle_player_after_die(Player),
    {ok, NewPlayer}.

%% LogoutType = ?LOGOUT_LOG_NORMAL(下线，玩家进程stop) | ?DELAY_LOGOUT(去离线挂机了，玩家进程还在)
handle_disconnect_hold_end(Player, #event_callback{param = [From, RoleKey, ModLib], data = LogoutType}) ->
    Args
    = case ?HAS_API(ModLib, pack_quit_args, 2) of
        true ->
            ModLib:pack_quit_args(Player, LogoutType);
        _ ->
            []
    end,
    case LogoutType of
        ?NORMAL_LOGOUT ->
            mod_battle_field:player_logout(From, RoleKey, Args);
        ?DELAY_LOGOUT ->
            mod_battle_field:player_force_quit(From, RoleKey, Args);
        _ ->
            mod_battle_field:player_logout(From, RoleKey, Args)
    end,
    {ok, Player}.

% handle_offline(Player, #event_callback{type_id = ?EVENT_ONLINE_FLAG, data = 0, param = [From, RoleKey]}) when is_record(Player, player_status) ->
%     mod_battle_field:player_logout(From, RoleKey, []),
%     {ok, Player};
% handle_offline(Player, _) ->
%     {ok, Player}.

handle_player_revive(Player, #event_callback{data = Data, param = [From, RoleKey]}) ->
    mod_battle_field:player_revive(From, RoleKey, Data),
    {ok, Player}.

handle_disconnect(Player, #event_callback{param = [From, RoleKey, ModLib]}) ->
    NewPlayer = ?TRY_HANDLE_EVT(Player, ModLib, evt_player_disconnect, []),
    mod_battle_field:player_disconnect(From, RoleKey, []),
    {ok, NewPlayer}.

handle_reconnect(Player, #event_callback{param = [From, RoleKey, ModLib]}) ->
    NewPlayer = ?TRY_HANDLE_EVT(Player, ModLib, evt_player_reconnect, []),
    Args
    = case ?HAS_API(ModLib, pack_reconnect_args, 1) of
        true ->
            ModLib:pack_reconnect_args(NewPlayer);
        _ ->
            []
    end,
    mod_battle_field:player_reconnect(From, RoleKey, Args),
    {ok, NewPlayer}.

%% 玩家进程执行
remove_listener_in_ps() ->
    lib_player_event:remove_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, take_role_in_finish),
    lib_player_event:remove_listener(?EVENT_PLAYER_DIE, ?MODULE, handle_player_die),
    % lib_player_event:remove_listener(?EVENT_ONLINE_FLAG, ?MODULE, handle_offline),
    lib_player_event:remove_listener(?EVENT_REVIVE, ?MODULE, handle_player_revive),
    lib_player_event:remove_listener(?EVENT_DISCONNECT, ?MODULE, handle_disconnect),
    lib_player_event:remove_listener(?EVENT_DISCONNECT_HOLD_END, ?MODULE, handle_disconnect_hold_end),
    lib_player_event:remove_listener(?EVENT_RECONNECT, ?MODULE, handle_reconnect).