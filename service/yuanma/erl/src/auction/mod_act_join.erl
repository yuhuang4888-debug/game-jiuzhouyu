%% ---------------------------------------------------------------------------
%% @doc 活动参与记录服务 -- 主要用于拍卖分红
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------
-module (mod_act_join).
-behaviour(gen_server).
-include ("common.hrl").
-include ("rec_act_join.hrl").

%% API
-export([start_link/0]).
-export([
	get_join/1, get_join_num/1, stop/0, daily_clear/1, add_join/3, clear_module/1, quit_guild/1,
    add_authentication_player/1, get_authentication_player/2, get_authentication_player_num/2,
    clear_with_authentication_id/2]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({global,?MODULE}, ?MODULE, [], []).

get_join(ModuleId) -> 
	gen_server:call(misc:get_global_pid(?MODULE), {get_join, ModuleId}).

get_join_num(ModuleId) -> 
    gen_server:call(misc:get_global_pid(?MODULE), {get_join_num, ModuleId}).

get_authentication_player(AuthenticationId, ModuleId) ->
    gen_server:call(misc:get_global_pid(?MODULE), {get_authentication_player, AuthenticationId, ModuleId}).

get_authentication_player_num(AuthenticationId, ModuleId) ->
    gen_server:call(misc:get_global_pid(?MODULE), {get_authentication_player_num, AuthenticationId, ModuleId}).

stop() -> 
	gen_server:call(misc:get_global_pid(?MODULE), {stop}).

daily_clear(DelaySec) ->
    RandTime = urand:rand(1, 1000),
    spawn( fun() -> timer:sleep(RandTime), gen_server:cast(misc:get_global_pid(?MODULE), {daily_clear, DelaySec}) end).

add_join(PlayerId, GuildId, ModuleId) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {add_join, PlayerId, GuildId, ModuleId}).

add_authentication_player(AuthenticationList) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {add_authentication_player, AuthenticationList}).

clear_module(ModuleId) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {clear_module, ModuleId}).

clear_with_authentication_id(AuthenticationId, ModuleId) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {clear_with_authentication_id, AuthenticationId, ModuleId}).

quit_guild(PlayerId) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {quit_guild, PlayerId}).

do_init(_Args) ->
	{ok, State} = lib_act_join_mod:init(),
    {ok, State}.

do_call({get_join, ModuleId}, _From, State) ->
	Reply = lib_act_join_mod:get_join({ModuleId}, State),
    {reply, Reply, State};

do_call({get_join_num, ModuleId}, _From, State) ->
    JoinList = lib_act_join_mod:get_join({ModuleId}, State),
    Reply    = length(JoinList),
    {reply, Reply, State};

do_call({get_authentication_player, AuthenticationId, ModuleId}, _From, State) ->
    Reply = lib_act_join_mod:get_authentication_player({AuthenticationId, ModuleId}, State),
    {reply, Reply, State};

do_call({get_authentication_player_num, AuthenticationId, ModuleId}, _From, State) ->
    PlayerList = lib_act_join_mod:get_authentication_player({AuthenticationId, ModuleId}, State),
    Reply = length(PlayerList),
    {reply, Reply, State};

do_call({stop}, _From, State) ->
	{ok, NewState} = lib_act_join_mod:stop(State),
    {reply, ok, NewState};

do_call(_Request, _From, State) ->
    {reply, ok, State}.

do_cast({daily_clear, DelaySec}, State) ->
	{ok, NewState} = lib_act_join_mod:daily_clear({DelaySec}, State),
    {noreply, NewState};

do_cast({add_join, PlayerId, GuildId, ModuleId}, State) ->
	{ok, NewState} = lib_act_join_mod:add_join({PlayerId, GuildId, ModuleId}, State),
    {noreply, NewState};

do_cast({add_authentication_player, AuthenticationList}, State) ->
    {ok, NewState} = lib_act_join_mod:add_authentication_player(AuthenticationList, State),
    {noreply, NewState};

do_cast({clear_module, ModuleId}, State) ->
	{ok, NewState} = lib_act_join_mod:clear_module({ModuleId}, State),
    {noreply, NewState};

do_cast({clear_with_authentication_id, AuthenticationId, ModuleId}, State) ->
    {ok, NewState} = lib_act_join_mod:clear_with_authentication_id({AuthenticationId, ModuleId}, State),
    {noreply, NewState};

do_cast({quit_guild, PlayerId}, State) ->
	{ok, NewState} = lib_act_join_mod:quit_guild({PlayerId}, State),
    {noreply, NewState};

do_cast(_Msg, State) ->
    {noreply, State}.

% do_info({init}, State) ->
% 	{ok, NewState} = lib_act_join_mod:init(State),
%     {noreply, NewState};

do_info({to_db}, State) ->
	{ok, NewState} = lib_act_join_mod:to_db(State),
    {noreply, NewState};

do_info(_Info, State) ->
    {noreply, State}.   

%% --------------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------------
init(Args) ->
    case catch do_init(Args) of
        {'EXIT', Reason} ->
            ?ERR("init error:~p~n", [Reason]),
            {stop, Reason};
        {ok, State} ->
            {ok, State};
        Other ->
            {stop, Other}
    end.

%% --------------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_call(Request, From, State) ->
    case catch do_call(Request, From, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_call error:~p~n", [Reason]),
            {reply, error, State};
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        _ ->
            {reply, true, State}
    end.

%% --------------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_cast(Msg, State) ->
    case catch do_cast(Msg, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_cast error:~p~n", [Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        _ ->
            {noreply, State}
    end.

%% --------------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_info(Info, State) ->
    case catch do_info(Info, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_info error:~p~n", [Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

%% --------------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------------

