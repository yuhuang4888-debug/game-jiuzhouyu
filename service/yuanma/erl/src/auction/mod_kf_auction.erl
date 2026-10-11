%% ---------------------------------------------------------------------------
%% @doc 拍卖行服务进程(跨服)
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(mod_kf_auction).
-behaviour(gen_server).
-include ("common.hrl").
-include ("rec_auction.hrl").

%% API
-export([start_link/0]).
-export([
        timer_check/0,
        start_auction_notice/1,
        start_kf_realm_auction/1
]).
-export([
        close_auction/1, 
        close_all_auction_gm/0
]).
-export([
        pay_auction/1
]).
-export ([
        daily_clear/1,
        zone_change/2
]).
-export([
        cast_kf_auction/2,
        call_kf_auction/2,
        send_auction_catalog/1, 
        send_auction_goods/1, 
        send_my_auction/1, 
        send_auction_estimate_bonus/1,
        quit_guild/1
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({global,?MODULE}, ?MODULE, [], []).

cast_kf_auction(Method, Msg) ->
    mod_clusters_node:apply_cast(?MODULE, Method, Msg).

call_kf_auction(Method, Msg) ->
    mod_clusters_node:apply_call(?MODULE, Method, Msg).

timer_check() ->
    gen_server:cast(misc:get_global_pid(?MODULE), {timer_check}).

start_kf_realm_auction(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {start_kf_realm_auction, Args}).

start_auction_notice(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {start_auction_notice, Args}).

close_auction(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {close_auction, Args}).

close_all_auction_gm() ->
    gen_server:cast(misc:get_global_pid(?MODULE), {close_all_auction_gm}).

pay_auction(Args) ->
    gen_server:call(misc:get_global_pid(?MODULE), {pay_auction, Args}).

daily_clear(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {daily_clear, {Args}}).

zone_change(OldZone, NewZone) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {zone_change, {OldZone, NewZone}}).

quit_guild(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {quit_guild, Args}).

send_auction_catalog(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_auction_catalog, Args}).

send_auction_goods(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_auction_goods, Args}).

send_my_auction(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_my_auction, Args}).

send_auction_estimate_bonus(Args)->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_auction_estimate_bonus, Args}).

do_init(_Args) ->
    self() ! 'init',
    {ok, #kf_auction_state{}}.

do_call({pay_auction, Args}, _From, State) ->
    {Reply, NewState} = lib_kf_auction_mod:pay_auction(State, Args),
    {reply, Reply, NewState};

do_call(_Request, _From, State) ->
    {reply, ok, State}.

do_cast(stop, State) ->
    {stop, normal, State};

do_cast({timer_check}, State) ->
    {ok, NewState} = lib_kf_auction_mod:timer_check(State),
    {noreply, NewState};

do_cast({start_kf_realm_auction, {ZoneId, ModuleId, StartTime, GuildGoodsList, BonusPlayerList}}, State) ->
    {ok, NewState} = lib_kf_auction_mod:start_auction(State, {?AUCTION_KF_REALM, ZoneId, ModuleId, StartTime, ?DEFAULT_CFG_ID, GuildGoodsList, BonusPlayerList}),
    {noreply, NewState};

do_cast({start_auction_notice, Args}, State) ->
    {ok, NewState} = lib_kf_auction_mod:start_auction_notice(State, Args),
    {noreply, NewState};

do_cast({close_auction, Args}, State) ->
    {ok, NewState} = lib_kf_auction_mod:close_auction(State, Args),
    {noreply, NewState};

do_cast({close_all_auction_gm}, State) ->
    {ok, NewState} = lib_kf_auction_mod:close_all_auction_gm(State),
    {noreply, NewState};    

% do_cast({daily_clear, Args}, State) ->
%     {ok, NewState} = lib_kf_auction_mod:daily_clear(State, Args),
%     {noreply, NewState};

do_cast({zone_change, Args}, State) ->
    {ok, NewState} = lib_kf_auction_mod:zone_change(State, Args),
    {noreply, NewState};

do_cast({quit_guild, Args}, State) ->
    {ok, NewState} = lib_kf_auction_mod:quit_guild(State, Args),
    {noreply, NewState};

do_cast({send_auction_catalog, Args}, State) ->
    lib_kf_auction_mod:send_auction_catalog(State, Args),
    {noreply, State};

do_cast({send_auction_goods, Args}, State) ->
    lib_kf_auction_mod:send_auction_goods(State, Args),
    {noreply, State};

do_cast({send_my_auction, Args}, State) ->
    lib_kf_auction_mod:send_my_auction(State, Args),
    {noreply, State};

do_cast({send_auction_estimate_bonus, Args}, State) ->
    lib_kf_auction_mod:send_auction_estimate_bonus(State, Args),
    {noreply, State};   

do_cast(_Msg, State) ->
    {noreply, State}.

do_info('init', _State) ->
    AuctionState = lib_kf_auction_mod:init(),
    ?PRINT("init AuctionState:~p~n", [AuctionState]),
    {noreply, AuctionState};
    
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

