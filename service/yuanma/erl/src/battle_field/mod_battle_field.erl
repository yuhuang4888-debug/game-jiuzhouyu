%%-----------------------------------------------------------------------------
%% @Module  :       mod_battle_field.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-01
%% @Description:    战场控制
%%-----------------------------------------------------------------------------

-module (mod_battle_field).

-include ("common.hrl").
-include ("battle_field.hrl").
-include ("predefine.hrl").
-include ("def_fun.hrl").
-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/3
    ,start/3
    ,start_link/2
    ,start/2
    ,stop/1
    ,apply_cast/4
]).

-export ([
    player_enter/3
    ,player_quit/3
    ,player_force_quit/3
    ,player_logout/3
    ,player_finish_change_scene/3
    ,player_die/3
    ,player_revive/3
    ,player_disconnect/3
    ,player_reconnect/3
    ,mon_hp_change/3
    ,mon_die/3
    ]).

-define (SERVER, ?MODULE).

%% API
start_link(Name, ModLib, Args) ->
    {ok, Pid} = gen_server:start_link(Name, ?MODULE, [ModLib, Args], []),
    Pid.

start(Name, ModLib, Args) ->
    {ok, Pid} = gen_server:start(Name, ?MODULE, [ModLib, Args], []),
    Pid.

start_link(ModLib, Args) ->
    {ok, Pid} = gen_server:start_link(?MODULE, [ModLib, Args], []),
    Pid.

start(ModLib, Args) ->
    {ok, Pid} = gen_server:start(?MODULE, [ModLib, Args], []),
    Pid.

stop(Pid) ->
    gen_server:cast(Pid, stop).

%% 玩家请求进入
player_enter(Pid, RoleKey, Args) ->
    gen_server:cast(Pid, {player_enter, RoleKey, Args}).

%% 玩家请求退出
player_quit(Pid, RoleKey, Args) ->
    gen_server:cast(Pid, {player_quit, RoleKey, Args}).

%% 玩家被强制退出
player_force_quit(Pid, RoleKey, Args) ->
    gen_server:cast(Pid, {player_force_quit, RoleKey, Args}).

%% 玩家登出 注意分延时登出和真正登出
player_logout(Pid, RoleKey, Args) ->
    gen_server:cast(Pid, {player_logout, RoleKey, Args}).

%% 玩家切换战场场景完成
player_finish_change_scene(Pid, RoleKey, Args) ->
    gen_server:cast(Pid, {player_finish_change_scene, RoleKey, Args}).

% %% 玩家血量变化
% player_hp_change(Pid, RoleKey, Args) ->
%     gen_server:cast(Pid, {player_hp_change, RoleKey, Args}).

player_die(Pid, RoleKey, Args) ->
    gen_server:cast(Pid, {player_die, RoleKey, Args}).

player_revive(Pid, RoleKey, Args) ->
    gen_server:cast(Pid, {player_revive, RoleKey, Args}).

player_disconnect(Pid, RoleKey, Args) ->
    gen_server:cast(Pid, {player_disconnect, RoleKey, Args}).

player_reconnect(Pid, RoleKey, Args) ->
    gen_server:cast(Pid, {player_reconnect, RoleKey, Args}).

mon_hp_change(Pid, MonKey, Args) ->
    gen_server:cast(Pid, {mon_hp_change, MonKey, Args}).

mon_die(Pid, MonKey, Args) ->
    gen_server:cast(Pid, {mon_die, MonKey, Args}).

apply_cast(Pid, Mod, Fun, Args) ->
    gen_server:cast(Pid, {apply, Mod, Fun, Args}).


%% private
init([ModLib, Args]) ->
    % {ok, State} = setup_args(Args, #battle_state{lib = ModLib}), 
    {ok, State} = ModLib:init(#battle_state{lib = ModLib, self = self()}, Args),
    {ok, State}.

handle_call(_Msg, _From, State) ->
    {reply, undefined, State}.

handle_cast({player_enter, RoleKey, Args}, State) ->
    % ?MYLOG("xlh_battle"," player_enter ============= self:~p RoleMap:~p~n",[State#battle_state.self, State#battle_state.roles]),
    #battle_state{lib = ModLib, roles = RoleMap} = State,
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{state = ?ROLE_STATE_IN}} ->
            {noreply, State};
        _ ->
            case ModLib:player_enter(RoleKey, Args, State) of
                {ok, Role, NewState} ->
                    #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, self = Self} = State,
                    TakeInArgs
                    = case ?HAS_API(ModLib, pack_enter_args, 2) of
                        true ->
                            ModLib:pack_enter_args(Role, NewState);
                        _ ->
                            undefined
                    end,
                    take_role_in(Self, Role, SceneId, ScenePoolId, CopyId, ModLib, TakeInArgs),
                    NewRoleMap = RoleMap#{RoleKey => Role#battle_role{state = ?ROLE_STATE_BEFORE_IN}},
                    {noreply, NewState#battle_state{roles = NewRoleMap}};
                {ok, NewState} ->
                    {noreply, NewState};
                _ ->
                    {noreply, State}
            end
    end;

handle_cast({player_quit, RoleKey, Args}, State) ->
    % ?MYLOG("xlh_battle"," player_quit ============= self:~p RoleMap:~p~n",[State#battle_state.self, State#battle_state.roles]),
    #battle_state{lib = ModLib, roles = RoleMap} = State,
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{state = RoleState} = Role} when RoleState =/= ?ROLE_STATE_OUT ->
            case ModLib:player_quit(Role, Args, State) of
                {ok, NewRole, NewState} ->
                    take_role_out(NewRole, manual, ModLib),
                    NewRoleMap = RoleMap#{RoleKey => NewRole#battle_role{state = ?ROLE_STATE_OUT}},
                    {noreply, NewState#battle_state{roles = NewRoleMap}};
                {remove, NewState} ->
                    take_role_out(Role, manual, ModLib),
                    NewRoleMap = maps:remove(RoleKey, RoleMap),
                    {noreply, NewState#battle_state{roles = NewRoleMap}};
                _ ->
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;

handle_cast({player_force_quit, RoleKey, Args}, State) ->
    % ?MYLOG("xlh_battle"," player_force_quit ============= self:~p RoleMap:~p~n",[State#battle_state.self, State#battle_state.roles]),
    #battle_state{lib = ModLib, roles = RoleMap} = State,
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{state = RoleState} = Role} when RoleState =/= ?ROLE_STATE_OUT ->
            take_role_out(Role, force, ModLib),
            case ModLib:player_quit(Role, Args, State) of
                {ok, NewRole, NewState} ->
                    NewRoleMap = RoleMap#{RoleKey => NewRole#battle_role{state = ?ROLE_STATE_OUT}},
                    {noreply, NewState#battle_state{roles = NewRoleMap}};
                {remove, NewState} ->
                    NewRoleMap = maps:remove(RoleKey, RoleMap),
                    {noreply, NewState#battle_state{roles = NewRoleMap}};
                _ ->
                    NewRoleMap = RoleMap#{RoleKey => Role#battle_role{state = ?ROLE_STATE_OUT}},
                    {noreply, State#battle_state{roles = NewRoleMap}}
            end;
        _ ->
            {noreply, State}
    end;

handle_cast({player_logout, RoleKey, Args}, State) ->
    % ?MYLOG("xlh_battle"," player_logout ============= self:~p RoleMap:~p~n",[State#battle_state.self, State#battle_state.roles]),
    #battle_state{lib = ModLib, roles = RoleMap} = State,
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{state = RoleState} = Role} when RoleState =/= ?ROLE_STATE_OUT ->
            case ModLib:player_logout(Role, Args, State) of
                {ok, NewRole, NewState} ->
                    NewRoleMap = RoleMap#{RoleKey => NewRole#battle_role{state = ?ROLE_STATE_OUT}},
                    {noreply, NewState#battle_state{roles = NewRoleMap}};
                {remove, NewState} ->
                    NewRoleMap = maps:remove(RoleKey, RoleMap),
                    {noreply, NewState#battle_state{roles = NewRoleMap}};
                _ ->
                    NewRoleMap = RoleMap#{RoleKey => Role#battle_role{state = ?ROLE_STATE_OUT}},
                    {noreply, State#battle_state{roles = NewRoleMap}}
            end;
        _ ->
            {noreply, State}
    end;

handle_cast({player_finish_change_scene, RoleKey, Args}, State) ->
    % ?MYLOG("xlh_battle"," player_finish_change_scene ============= self:~p RoleMap:~p~n",[State#battle_state.self, State#battle_state.roles]),
    #battle_state{lib = ModLib, roles = RoleMap} = State,
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{state = ?ROLE_STATE_BEFORE_IN} = Role} ->
            case ?HAS_API(ModLib, player_finish_change_scene, 3) of
                true ->
                    case ModLib:player_finish_change_scene(Role, Args, State) of
                        {ok, NewRole, NewState} ->
                            NewRoleMap = RoleMap#{RoleKey => NewRole#battle_role{state = ?ROLE_STATE_IN}},
                            {noreply, NewState#battle_state{roles = NewRoleMap}};
                        _ ->
                            NewRoleMap = RoleMap#{RoleKey => Role#battle_role{state = ?ROLE_STATE_IN}},
                            {noreply, State#battle_state{roles = NewRoleMap}}
                    end;
                _ ->
                    NewRoleMap = RoleMap#{RoleKey => Role#battle_role{state = ?ROLE_STATE_IN}},
                    {noreply, State#battle_state{roles = NewRoleMap}}
            end;
        _ ->
            {noreply, State}
    end;

handle_cast({player_die, RoleKey, Args}, State) ->
    % ?MYLOG("xlh_battle"," player_die ============= self:~p RoleMap:~p~n",[State#battle_state.self, State#battle_state.roles]),
    #battle_state{lib = ModLib, roles = RoleMap} = State,
    if
        ModLib =:= lib_diamond_league_battle ->
            ?PRINT("mod_battle_field player_die~p~n", [RoleKey]);
        true ->
            ok
    end,
    
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{state = RoleState} = Role} when RoleState =/= ?ROLE_STATE_OUT ->
            case ?HAS_API(ModLib, player_die, 3) of
                true ->
                    case ModLib:player_die(Role, Args, State) of
                        {ok, NewState} ->
                            {noreply, NewState};
                        _ ->
                            {noreply, State}
                    end;
                _ ->
                    {noreply, State}
            end;
        _A ->
            ?ERR("player_die no match ~p~n", [_A]),
            {noreply, State}
    end;

handle_cast({player_revive, RoleKey, Args}, State) ->
    % ?MYLOG("xlh_battle"," player_revive ============= self:~p RoleMap:~p~n",[State#battle_state.self, State#battle_state.roles]),
    #battle_state{lib = ModLib, roles = RoleMap} = State,
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{state = RoleState} = Role} when RoleState =/= ?ROLE_STATE_OUT ->
            case ?HAS_API(ModLib, player_revive, 3) of
                true ->
                    case ModLib:player_revive(Role, Args, State) of
                        {ok, NewState} ->
                            {noreply, NewState};
                        _ ->
                            {noreply, State}
                    end;
                _ ->
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;


handle_cast({player_disconnect, RoleKey, Args}, State) ->
    % ?MYLOG("xlh_battle"," player_disconnect ============= self:~p RoleMap:~p~n",[State#battle_state.self, State#battle_state.roles]),
    #battle_state{lib = ModLib, roles = RoleMap} = State,
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{state = RoleState} = Role} when RoleState =/= ?ROLE_STATE_OUT ->
            case ?HAS_API(ModLib, player_disconnect, 3) of
                true ->
                    case ModLib:player_disconnect(Role, Args, State) of
                        {ok, NewState} ->
                            {noreply, NewState};
                        {ok, NewRole, NewState} ->
                            take_role_out(NewRole, manual, ModLib),
                            NewRoleMap = RoleMap#{RoleKey => NewRole#battle_role{state = ?ROLE_STATE_OUT}},
                            {noreply, NewState#battle_state{roles = NewRoleMap}};
                        _ ->
                            {noreply, State}
                    end;
                _ ->
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;


handle_cast({player_reconnect, RoleKey, Args}, State) ->
    % ?MYLOG("xlh_battle"," player_reconnect ============= self:~p RoleMap:~p~n",[State#battle_state.self, State#battle_state.roles]),
    #battle_state{lib = ModLib, roles = RoleMap, self = Self, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId} = State,
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{state = RoleState} = Role} when RoleState =/= ?ROLE_STATE_OUT ->
            if
                RoleState =:= ?ROLE_STATE_BEFORE_IN ->
                    TakeInArgs
                    = case ?HAS_API(ModLib, pack_enter_args, 2) of
                        true ->
                            ModLib:pack_enter_args(Role, State);
                        _ ->
                            undefined
                    end,
                    take_role_in(Self, Role, SceneId, ScenePoolId, CopyId, ModLib, TakeInArgs);
                true ->
                    ok
            end,
            case ?HAS_API(ModLib, player_reconnect, 3) of
                true ->
                    case ModLib:player_reconnect(Role, Args, State) of
                        {ok, NewState} ->
                            {noreply, NewState};
                        _ ->
                            {noreply, State}
                    end;
                _ ->
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;

handle_cast({mon_hp_change, MonKey, Args}, State) ->
    #battle_state{lib = ModLib} = State,
    case ModLib:mon_hp_change(MonKey, Args, State) of
        {ok, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

handle_cast({mon_die, MonKey, Args}, State) ->
    #battle_state{lib = ModLib} = State,
    case ModLib:mon_die(MonKey, Args, State) of
        {ok, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

handle_cast({apply, Mod, Fun, Args}, State) ->
    % ?MYLOG("xlh_battle"," apply Fun:~p ============= self:~p RoleMap:~p~n",[Fun, State#battle_state.self, State#battle_state.roles]),
    case catch Mod:Fun(State, Args) of
        NewState when is_record(NewState, battle_state) ->
            {noreply, NewState};
        {'EXIT', Error} ->
            ?ERR("~p apply error ~p~n", [{Mod, Fun, Args}, Error]),
            {noreply, State};
        _ ->
            {noreply, State}
    end;

handle_cast(stop, State) ->
    % ?MYLOG("xlh_battle"," stop ============= self:~p RoleMap:~p~n",[State#battle_state.self, State#battle_state.roles]),
    {stop, normal, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({apply, Mod, Fun, Args}, State) ->
    % ?MYLOG("xlh_battle","handle_info apply Fun:~p ============= self:~p RoleMap:~p~n",[Fun, State#battle_state.self, State#battle_state.roles]),
    case catch Mod:Fun(State, Args) of
        NewState when is_record(NewState, battle_state) ->
            {noreply, NewState};
        {'EXIT', Error} ->
            ?ERR("~p apply error ~p~n", [{Mod, Fun, Args}, Error]),
            {noreply, State};
        _ ->
            {noreply, State}
    end;

handle_info(stop, State) ->
    % ?MYLOG("xlh_battle"," stop ============= self:~p RoleMap:~p~n",[State#battle_state.self, State#battle_state.roles]),
    {stop, normal, State};
    
handle_info(_Info, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(Reason, State) ->
    % ?INFO("battle_field terminate for ~p~n", [Reason]),
    #battle_state{roles = RoleMap, lib = ModLib} = State,
    maps:map(fun
        (_, #battle_role{state = RoleState} = Role) when RoleState =/= ?ROLE_STATE_OUT ->
            take_role_out(Role, ?IF(Reason =:= normal, normal, error), ModLib);
        (_, _) ->
            skip
    end, RoleMap),
    case ?HAS_API(ModLib, terminate, 2) of
        true ->
             ModLib:terminate(Reason, State);
        _ ->
            ok
    end.

take_role_in(From, Role, SceneId, ScenePoolId, CopyId, ModLib, Args) ->
    #battle_role{key = RoleKey, in_info = InInfo} = Role,
    ClsType = config:get_cls_type(),
    case RoleKey of
        {Node, RoleId} when Node =/= node() ->
            rpc:cast(Node, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_battle_field, take_role_in, [SceneId, ScenePoolId, CopyId, InInfo, From, RoleKey, ModLib, Args]]);
        {_Node, RoleId} ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_battle_field, take_role_in, [SceneId, ScenePoolId, CopyId, InInfo, From, RoleKey, ModLib, Args]);
        RoleId when ClsType =:= ?NODE_GAME ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_battle_field, take_role_in, [SceneId, ScenePoolId, CopyId, InInfo, From, RoleKey, ModLib, Args]);
        RoleId ->
            ServId = mod_player_create:get_serid_by_id(RoleId),
            mod_clusters_center:apply_cast(ServId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_battle_field, take_role_in, [SceneId, ScenePoolId, CopyId, InInfo, From, RoleKey, ModLib, Args]])
    end.

take_role_out(Role, Reason, ModLib) ->
    #battle_role{key = RoleKey, out_info = OutInfo} = Role,
    ClsType = config:get_cls_type(),
    case RoleKey of
        {Node, RoleId} when Node =/= node() ->
            rpc:cast(Node, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_battle_field, take_role_out, [OutInfo, ModLib, Reason]]);
        {_Node, RoleId} ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_battle_field, take_role_out, [OutInfo, ModLib, Reason]);
        RoleId when ClsType =:= ?NODE_GAME ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_battle_field, take_role_out, [OutInfo, ModLib, Reason]);
        RoleId ->
            ServId = mod_player_create:get_serid_by_id(RoleId),
            mod_clusters_center:apply_cast(ServId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, lib_battle_field, take_role_out, [OutInfo, ModLib, Reason]])
    end.

%% internal
