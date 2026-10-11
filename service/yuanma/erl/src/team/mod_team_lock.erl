%% ---------------------------------------------------------------------------
%% @doc mod_team_lock
%% @author xiaoxiang
%% @since  2017-08-02
%% @deprecated 活动队伍锁
%% ---------------------------------------------------------------------------

-module(mod_team_lock).
-behaviour(gen_server).

-export([start_link/0,  cast_to_team_lock/2, call_to_team_lock/2]).
-export([init/1, handle_call/3, handle_cast/2, 
         handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("team.hrl").
-compile(export_all).

-record(lock_state, {
    team_list = [],
    lock_maps = maps:new()          %% role_id => team_id(玩家身上)
    }).

-define(TEAM_UNLOCK,    0).         %% 队伍非上锁状态
-define(TEAM_LOCK,      1).         %% 队伍上锁状态


%% ------------------------------------------------------------
logout(Player) ->
    #player_status{id = RoleId, team = #status_team{team_id=TeamId}} = Player,
    % ?INFO("TeamId:~p ~n", [TeamId]),
    if 
        TeamId == 0 -> skip;
        true ->
            cast_to_team_lock(logout, [RoleId, TeamId])
    end.

login(Player) ->
    #player_status{id = RoleId} = Player,
    cast_to_team_lock(login, [RoleId]),
    Player.
%% ------------------------------------------------------------
logout(State, RoleId, TeamId) ->
    #lock_state{team_list = TeamList, lock_maps = LockMaps} = State,
    % ?INFO("TeamId:~p, State:~p ~n", [TeamId, State]),
    NewLockMaps = case lists:member(TeamId, TeamList) of
        true ->
            maps:put(RoleId, TeamId, LockMaps);
        false ->
            LockMaps
    end,
    State#lock_state{lock_maps = NewLockMaps}.

login(State, RoleId) ->
    #lock_state{lock_maps = LockMaps} = State,
    % ?INFO("RoleId:~p ,State:~p ~n", [RoleId, State]),
    NewLockMaps = case maps:get(RoleId, LockMaps, false) of
        false ->
            LockMaps;
        TeamId ->
            mod_team:cast_to_team(TeamId, {'lock_login', RoleId}),
            maps:remove(RoleId, LockMaps)
    end,
    % ?INFO("NewLockMaps:~p ~n", [NewLockMaps]),
    State#lock_state{lock_maps = NewLockMaps}.
            
set_lock(State, TeamId, ?TEAM_UNLOCK) ->
    % ?INFO("State:~p ~n", [State]),
    #lock_state{team_list = TeamList, lock_maps = LockMaps} = State,
    NewTeamList = [Id||Id<-TeamList, TeamId/=Id],
    LockList = maps:to_list(LockMaps),
    NewLockList = [{RoleId, LockTeam}||{RoleId, LockTeam}<-LockList, 
                                case LockTeam/=TeamId of
                                    true ->
                                        true;
                                    false ->
                                        mod_team:cast_to_team(TeamId, {'quit_team', RoleId, 0}),
                                        false
                                end],
    NewLockMaps = maps:from_list(NewLockList),
    % ?INFO("NewTeamList:~p, NewLockMaps:~p ~n", [NewTeamList, NewLockMaps]),
    State#lock_state{team_list = NewTeamList, lock_maps = NewLockMaps};

set_lock(State, TeamId, ?TEAM_LOCK) ->
    % ?INFO("State:~p ~n", [{TeamId, State}]),
    #lock_state{team_list = TeamList} = State,
    State#lock_state{team_list = [TeamId|TeamList]};

set_lock(State, _,_) ->State.
%% -------------------------------------------------------------
cast_to_team_lock(F, A) ->
    gen_server:cast({global, ?MODULE}, {F, A}).


call_to_team_lock(F, A) ->
    gen_server:call({global, ?MODULE}, {F, A}).

%% --------------------------------- 公共函数 ----------------------------------
%% @doc Starts the server
-spec start_link() -> {ok, Pid} | ignore | {error, Error} when
    Pid :: pid(),
    Error :: term().
%% ---------------------------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).


%% @doc Initializes the server
-spec init(Args) ->
    {ok, State}
    | {ok, State, Timeout}
    | ignore
    | {stop, Reason} when
    Args    :: term() ,
    State   :: term(),
    Timeout :: non_neg_integer() | infinity,
    Reason  :: term().
%% ---------------------------------------------------------------------------
init([]) ->
    State = #lock_state{},
    {ok, State}.


-spec handle_call(Request, From, State) ->
    {reply, Reply, State}
    | {reply, Reply, State, Timeout}
    | {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, Reply, State}
    | {stop, Reason, State} when
    Request :: term(),
    From :: pid(),
    State :: term(),
    Reply :: term(),
    State :: term(),
    Timeout :: non_neg_integer() | infinity.
%% ---------------------------------------------------------------------------
handle_call({F, A}, _From, State) ->
    {NewState, Reply} = case catch apply(?MODULE, F, [State|A]) of
        {#lock_state{} = State1, Value} ->
            {State1, Value};
        _ ->
            {State, ok}
    end,
    {reply, Reply, NewState};


handle_call(_Request, _From, State) ->
    % ?ERR1("Handle unkown request[~w]~n", [_Request]),
    Reply = ok,
    {reply, Reply, State}.


%% @doc Handling cast messages
-spec handle_cast(Msg, State) ->
    {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, State} when
    Msg :: term(),
    State :: term(),
    Timeout :: non_neg_integer() | infinity,
    Reason :: term().
%% ---------------------------------------------------------------------------

handle_cast({F,A}, State) ->
    NewState = case catch apply(?MODULE, F, [State|A]) of
        #lock_state{} = State1 ->
            State1;
        _ ->
            State
    end, 
    {noreply, NewState};

handle_cast(_Msg, State) ->
    {noreply, State}.


% handle_cast(Msg, State) ->
%     case catch do_handle_cast(Msg, State) of
%         {ok, NewState} ->
%             {noreply, NewState};
%         Err ->
%             util:errlog("~p ~p Msg:~p Cast_Error:~p, State:~p~n", [?MODULE, ?LINE, Msg, Err, State]),
%             {noreply, State}
%     end.

% do_handle_cast(_Msg, State) ->
%     {ok, State}.    
%% ---------------------------------------------------------------------------
%% @doc Handling all non call/cast messages
-spec handle_info(Info, State) ->
    {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, State} when
    Info :: term(),
    State :: term(),
    Timeout :: non_neg_integer() | infinity,
    Reason :: term().
%% ---------------------------------------------------------------------------
handle_info(_Info, State) ->
    % ?ERR1("Handle unkown info[~w]~n", [_Info]),
    {noreply, State}.

%% ---------------------------------------------------------------------------
%% @doc called by a gen_server when it is about to terminate
-spec terminate(Reason, State) -> ok when
    Reason :: term(),
    State :: term().
%% ---------------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.


%% ---------------------------------------------------------------------------
%% @doc Convert process state when code is changed
-spec code_change(OldVsn, State, Extra) -> {ok, NewState} when
    OldVsn :: term(),
    State :: term(),
    Extra :: term(),
    NewState :: term().
%% ---------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.