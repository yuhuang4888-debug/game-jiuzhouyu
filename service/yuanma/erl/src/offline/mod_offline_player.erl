%% ---------------------------------------------------------------------------
%% @doc 离线玩家信息
%% @author hek
%% @since  2016-11-30
%% @deprecated 
%% ---------------------------------------------------------------------------
-module (mod_offline_player).
-behaviour(gen_server).
-include ("common.hrl").
-include ("server.hrl").
-include ("figure.hrl").
-include ("attr.hrl").
-include ("def_fun.hrl").
-include ("predefine.hrl").
-include ("rec_offline.hrl").

%% API
-export([start_link/0, apply_cast/4, apply_cast/3]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({global,?MODULE}, ?MODULE, [], []).

apply_cast(PlayerId, Moudle, Method, Args) ->
	gen_server:cast(misc:get_global_pid(?MODULE), {apply_cast, PlayerId, Moudle, Method, Args}).

apply_cast(Moudle, Method, Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {apply_cast, Moudle, Method, Args}).

do_init(Args) ->
    process_flag(trap_exit, true),
    {ok, Args}.

do_call(_Request, _From, State) ->
    {reply, ok, State}.

do_cast(stop, State) ->
    {stop, normal, State};

do_cast({apply_cast, PlayerId, Moudle, Method, Args}, State) ->
    PS = lib_offline_api:get_player_info(PlayerId, all),
    case is_record(PS, player_status) of
        false ->
            ?ERR("player not_exist:~p~n", [{PlayerId, Moudle, Method, Args}]);
        true ->
            NewArgs = [PS|Args],
            apply(Moudle, Method, NewArgs)
    end,
    {noreply, State};

do_cast({apply_cast, Moudle, Method, Args}, State) ->
    apply(Moudle, Method, Args),
    {noreply, State};

do_cast(_Msg, State) ->
    {noreply, State}.

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
            ?ERR("handle_cast error:~p~n", [[Msg, Reason]]),
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
    %% ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
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

