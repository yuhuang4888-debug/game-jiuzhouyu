%% ---------------------------------------------------------------------------
%% @doc 看门狗服务
%% @author hek
%% @since  2018-05-24
%% @deprecated 守家护院就靠watchdog啦，值得信赖的伙伴
%% ---------------------------------------------------------------------------
-module(mod_watchdog).
-behaviour(gen_server).
-include("common.hrl").
-include("watchdog.hrl").

%% API
-export([start_link/0, add_monitor/3, stop/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).

add_monitor(CtrlType, Id, Value) ->
    gen_server:cast(?MODULE, {add_monitor, CtrlType, Id, Value}).

stop() ->
    gen_server:call(?MODULE, stop).

do_init([]) ->
    {ok, State} = lib_watchdog_mod:init(),
    case State#watchdog_state.is_tick==1 of
        true -> 
            Ref = erlang:start_timer(10*1000, self(), tick),
            {ok, State#watchdog_state{tick_ref = Ref}};
        _ ->
            {ok, State}            
    end.

do_handle_call(stop, _From, #watchdog_state{is_tick = 1} = State) ->
    ItemList = [
        {?CTRL_TYPE_SET, ?WATCHDOD_NODE_CLOSE_TIME, utime:unixtime()},
        {?CTRL_TYPE_SET, ?WATCHDOD_SERVER_STATUS, ?SERVER_STATUS_CLOSE}
    ],         
    {ok, NewState} = lib_watchdog_mod:add_monitor(State, ItemList),
    {ok, LastState} = lib_watchdog_mod:tick(NewState),
    {reply, ok, LastState};
do_handle_call(_Request, _From, State) ->
    {reply, ok, State}.

do_handle_cast({add_monitor, CtrlType, Id, Value}, State) ->
    {ok, NewState} = lib_watchdog_mod:add_monitor(State, CtrlType, Id, Value),
    {noreply, NewState};
do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info({timeout, TickRef, tick}, State = #watchdog_state{tick_ref = TickRef}) ->
    % ?INFO("mod_watchdog:tick ~p~n", [do]),
    {ok, NewState} = lib_watchdog_mod:tick(State),
    Ref = erlang:start_timer(?TICK_TIME*1000, self(), tick),
    {noreply, NewState#watchdog_state{tick_ref = Ref}};
do_handle_info(_Info, State) ->
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
    case catch do_handle_call(Request, From, State) of
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
    case catch do_handle_cast(Msg, State) of
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
    case catch do_handle_info(Info, State) of
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

