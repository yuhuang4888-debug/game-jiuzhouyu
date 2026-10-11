%% ---------------------------------------------------------------------------
%% @doc 拍卖行服务进程
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(mod_auction).
-behaviour(gen_server).
-include ("common.hrl").
-include ("rec_auction.hrl").

%% API
-export([start_link/0]).
-export([
        timer_check/0,
        start_system_auction/1, 
        start_guild_auction/1, 
        start_world_auction/1, 
        start_auction_notice/1,
        add_player_auction_log/1,
        add_bonus_log/1
]).
-export([
        close_auction/1, 
        close_all_auction_gm/0
]).
-export([
        pay_auction/1,
        get_bonus_map/0
]).
-export ([
        daily_clear/1,
        quit_guild/1,
        gm_clear_auction_pay_record/1,
        gm_clear_auction_bonus/1
]).
-export([
        send_auction_catalog/1, 
        send_auction_goods/1, 
        send_my_auction/1, 
        send_auction_log/1,
        send_auction_estimate_bonus/1,
        send_player_auction_log/1,
        send_bonus_log/1
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({global,?MODULE}, ?MODULE, [], []).

timer_check() ->
    gen_server:cast(misc:get_global_pid(?MODULE), {timer_check}).

start_system_auction(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {start_system_auction, Args}).

start_guild_auction(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {start_guild_auction, Args}).

start_world_auction(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {start_world_auction, Args}).

start_auction_notice(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {start_auction_notice, Args}).

close_auction(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {close_auction, Args}).

close_all_auction_gm() ->
    gen_server:cast(misc:get_global_pid(?MODULE), {close_all_auction_gm}).

pay_auction(Args) ->
    gen_server:call(misc:get_global_pid(?MODULE), {pay_auction, Args}).

get_bonus_map() ->
    gen_server:call(misc:get_global_pid(?MODULE), {get_bonus_map}).

daily_clear(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {daily_clear, {Args}}).

quit_guild(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {quit_guild, Args}).

send_auction_catalog(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_auction_catalog, Args}).

send_auction_goods(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_auction_goods, Args}).

send_my_auction(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_my_auction, Args}).

send_auction_log(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_auction_log, Args}).

send_auction_estimate_bonus(Args)->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_auction_estimate_bonus, Args}).

add_player_auction_log(PlayerLogList) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {add_player_auction_log, PlayerLogList}).

add_bonus_log(BonusLogList) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {add_bonus_log, BonusLogList}).

send_player_auction_log(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_player_auction_log, Args}).

send_bonus_log(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_bonus_log, Args}).

gm_clear_auction_pay_record(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {gm_clear_auction_pay_record, Args}).

gm_clear_auction_bonus(Args) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {gm_clear_auction_bonus, Args}).

do_init(_Args) ->
    self() ! 'init',
    {ok, #auction_state{}}.

do_call({pay_auction, Args}, _From, State) ->
    {Reply, NewState} = lib_auction_mod:pay_auction(State, Args),
    {reply, Reply, NewState};

do_call({get_bonus_map}, _From, State) ->
    Reply = {ok, State#auction_state.bonus_map},
    {reply, Reply, State};

do_call(_Request, _From, State) ->
    {reply, ok, State}.

do_cast(stop, State) ->
    {stop, normal, State};

do_cast({timer_check}, State) ->
    {ok, NewState} = lib_auction_mod:timer_check(State),
    {noreply, NewState};

do_cast({start_system_auction, Args}, State) ->
    {ok, NewState} = lib_auction_mod:start_system_auction(State, Args),
    {noreply, NewState};

do_cast({start_guild_auction, {ModuleId, AuthenticationId, GuildGoodsList}}, State) ->
    {ok, NewState} = lib_auction_mod:start_auction(State, {?AUCTION_GUILD, ModuleId, AuthenticationId, ?DEFAULT_CFG_ID, GuildGoodsList}),
    {noreply, NewState};

do_cast({start_guild_auction, {ModuleId, AuthenticationId, StartTime, GuildGoodsList}}, State) ->
    {ok, NewState} = lib_auction_mod:start_auction(State, {?AUCTION_GUILD, ModuleId, AuthenticationId, StartTime, ?DEFAULT_CFG_ID, GuildGoodsList}),
    {noreply, NewState};

do_cast({start_world_auction, {ModuleId, AuthenticationId, GoodsList}}, State) ->
    GuildGoodsList = [{0, GoodsList}],
    {ok, NewState} = lib_auction_mod:start_auction(State, {?AUCTION_WORLD, ModuleId, AuthenticationId, ?DEFAULT_CFG_ID, GuildGoodsList}),
    {noreply, NewState};

do_cast({start_world_auction, {ModuleId, AuthenticationId, StartTime, GoodsList}}, State) ->
    GuildGoodsList = [{0, GoodsList}],
    {ok, NewState} = lib_auction_mod:start_auction(State, {?AUCTION_WORLD, ModuleId, AuthenticationId, StartTime, ?DEFAULT_CFG_ID, GuildGoodsList}),
    {noreply, NewState};

do_cast({start_auction_notice, Args}, State) ->
    {ok, NewState} = lib_auction_mod:start_auction_notice(State, Args),
    {noreply, NewState};

do_cast({close_auction, Args}, State) ->
    {ok, NewState} = lib_auction_mod:close_auction(State, Args),
    {noreply, NewState};

do_cast({close_all_auction_gm}, State) ->
    {ok, NewState} = lib_auction_mod:close_all_auction_gm(State),
    {noreply, NewState};    

do_cast({daily_clear, Args}, State) ->
    {ok, NewState} = lib_auction_mod:daily_clear(State, Args),
    {noreply, NewState};

do_cast({quit_guild, Args}, State) ->
    {ok, NewState} = lib_auction_mod:quit_guild(State, Args),
    {noreply, NewState};

do_cast({send_auction_catalog, Args}, State) ->
    lib_auction_mod:send_auction_catalog(State, Args),
    {noreply, State};

do_cast({send_auction_goods, Args}, State) ->
    lib_auction_mod:send_auction_goods(State, Args),
    {noreply, State};

do_cast({send_my_auction, Args}, State) ->
    lib_auction_mod:send_my_auction(State, Args),
    {noreply, State};

do_cast({send_auction_log, Args}, State) ->
    lib_auction_mod:send_auction_log(State, Args),
    {noreply, State};

do_cast({send_auction_estimate_bonus, Args}, State) ->
    lib_auction_mod:send_auction_estimate_bonus(State, Args),
    {noreply, State};   

do_cast({add_player_auction_log, PlayerLogList}, State) ->
    {ok, NewState} = lib_auction_mod:add_player_auction_log(State, PlayerLogList),
    {noreply, NewState}; 

do_cast({add_bonus_log, BonusLogList}, State) ->
    {ok, NewState} = lib_auction_data:add_bonus_log(State, BonusLogList),
    {noreply, NewState};  

do_cast({send_player_auction_log, Args}, State) ->
    lib_auction_mod:send_player_auction_log(State, Args),
    {noreply, State};  

do_cast({send_bonus_log, Args}, State) ->
    lib_auction_mod:send_bonus_log(State, Args),
    {noreply, State}; 

do_cast({gm_clear_auction_pay_record, Args}, State) ->
    {ok, NewState} = lib_auction_mod:gm_clear_auction_pay_record(State, Args),
    {noreply, NewState};

do_cast({gm_clear_auction_bonus, Args}, State) ->
    {ok, NewState} = lib_auction_mod:gm_clear_auction_bonus(State, Args),
    {noreply, NewState};

do_cast(_Msg, State) ->
    {noreply, State}.

do_info('init', _State) ->
    AuctionState = lib_auction_mod:init(),
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

