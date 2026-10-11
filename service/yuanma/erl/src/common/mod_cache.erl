%% ---------------------------------------------------------------------------
%% @doc key_value缓存服务
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------
-module(mod_cache).
-behaviour(gen_server).
-include("common.hrl").
-include("def_cache.hrl").

%%% Usage:
%%% 新增key_value缓存步骤
%%% 1. def_cache.hrl中定义一个缓存type类型
%%  需要刷新缓存的，继续步骤2,3；否则End.
%%% 2. ?CACHE_CALLBACK_LIST中添加刷新缓存回调函数 M:F()
%%% 3. 实现刷新缓存回调函数 M:F()
%%% End.

%% API
-export([start_link/0, get/1, put/2, refresh/2]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({global,?MODULE}, ?MODULE, [], []).

get(Key) ->
    gen_server:call(misc:get_global_pid(?MODULE), {get, Key}).

put(Key, Value) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {put, Key, Value}).

%% 热更刷新缓存
refresh(?CACHE_REFRESH_HOT, Mod) ->
    F = fun({_CacheType, DataMod, M, F, _Hot, _Twelve, _Three}) when DataMod == Mod->
        case catch M:F() of
            {'EXIT', Reason} -> ?ERR("refresh ~p error:~p~n", [?CACHE_REFRESH_HOT, Reason]);
            _ -> skip
        end;
        ({_CacheType, _DataMod, _M, _F, _Hot, _Twelve, _Three}) -> skip
    end,
    lists:foreach(F, ?CACHE_CALLBACK_LIST);

%% 24点刷新缓存
refresh(?CACHE_REFRESH_TWELVE, _DelaySec) ->
    F = fun({_CacheType, _DataMod, M, F, _Hot, 1, _Three}) ->
        case catch M:F() of
            {'EXIT', Reason} -> ?ERR("refresh ~p error:~p~n", [?CACHE_REFRESH_TWELVE, Reason]);
            _ -> skip
        end;
        ({_CacheType, _DataMod, _M, _F, _Hot, _Twelve, _Three}) -> skip
    end,
    lists:foreach(F, ?CACHE_CALLBACK_LIST);

%% 4点刷新缓存
refresh(?CACHE_REFRESH_FOUR, _DelaySec) ->
    F = fun({_CacheType, _DataMod, M, F, _Hot, _Twelve, 1}) ->
        case catch M:F() of
            {'EXIT', Reason} -> ?ERR("refresh ~p error:~p~n", [?CACHE_REFRESH_FOUR, Reason]);
            _ -> skip
        end;
        ({_CacheType, _DataMod, _M, _F, _Hot, _Twelve, _Three}) -> skip
    end,
    lists:foreach(F, ?CACHE_CALLBACK_LIST).

do_init(Args) ->
    {ok, Args}.

do_call({get, Key}, _From, State) ->
    {reply, erlang:get(Key), State};

do_call(_Request, _From, State) ->
    {reply, ok, State}.

do_cast({put, Key, Value}, State) ->
    erlang:put(Key, Value),
    {noreply, State};

do_cast(stop, State) ->
    {stop, normal, State};

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
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
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
