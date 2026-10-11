%% ---------------------------------------------------------------------------
%% @doc mod_guild_dun_mgr
%% @author 
%% @since  
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(mod_guild_dun_mgr).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("guild_dun.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
%%-----------------------------

finish_init_guild_dun(RankRoleInfoList) ->
    gen_server:cast({global, ?MODULE}, {finish_init_guild_dun, RankRoleInfoList}).

daily_clear() ->
    gen_server:cast({global, ?MODULE}, {daily_clear}).

show_state() ->
    gen_server:cast({global, ?MODULE}, {show_state}).

apply_call(Msg, Timeout) ->
    gen_server:call({global, ?MODULE}, Msg, Timeout).

apply_cast(Msg) ->
    gen_server:cast({global, ?MODULE}, Msg).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

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
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
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

init([]) ->
    State = lib_guild_dun_mod:init(),
    {ok, State}.

%% ====================
%% hanle_call
%% ==================== 
do_handle_call({mod, F, Args}, _From, State) ->
    apply(lib_guild_dun_mod, F, [State, Args]);
do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 
do_handle_cast({finish_init_guild_dun, Args}, State) -> 
    lib_guild_dun_mod:finish_init_guild_dun(State, [Args]);

do_handle_cast({daily_clear}, State) -> 
    lib_guild_dun_mod:zero_clear(State);

do_handle_cast({show_state}, State) -> 
    ?PRINT("show state ~p~n", [State]),
    {noreply, State};

do_handle_cast({mod, F, Args}, State) -> 
    apply(lib_guild_dun_mod, F, [State, Args]);
do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================
do_handle_info('end_battle', State) ->

    {noreply, State}; 
do_handle_info(_Info, State) -> {noreply, State}.
