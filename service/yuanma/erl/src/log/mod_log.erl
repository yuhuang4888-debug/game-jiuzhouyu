%% ---------------------------------------------------------------------------
%% @doc mod_log
%% @author ming_up@foxmail.com
%% @since  2016-07-28
%% @deprecated  日志缓存系统
%% ---------------------------------------------------------------------------
-module(mod_log).
-behaviour(gen_server).
-export([start_link/0, add_log/2, to_db/0, stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {ref, ad}).

-include("predefine.hrl").
-include("common.hrl").

-ifdef(DEV_SERVER).
-define(ADD_LOG_TIME, 1000).
-else.
-define(ADD_LOG_TIME, 60000).
-endif.

-define(MAX_ACC, 10).

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add_log(Type, Args) -> gen_server:cast(?MODULE, {'add_log', Type, Args}).

to_db() -> ?MODULE ! 'to_db'.

%% 节点关闭时关闭
stop() -> gen_server:call(?MODULE, 'stop').


%% ------------- --------------------------- ------------------------------

init([]) ->
    process_flag(trap_exit, true),
    Ref = erlang:send_after(?ADD_LOG_TIME, self(), 'to_db'),
    {ok, #state{ref=Ref, ad=#{}}}.

handle_call('stop', _From, #state{ref=Ref, ad=AD}) ->
    util:cancel_timer(Ref),
    KVList = maps:to_list(AD),
    all_to_db(KVList, 1, 0),
    {reply, ok, #state{ref=undefined, ad=#{}} };

handle_call(_R , _From, State) ->
    {reply, ok, State}.

handle_cast({'add_log', Type, Args}, #state{ad=AD} = State) ->
    IsArgsList = is_args_list(Args, 0),
    LastAD = case IsArgsList of
                 0 ->
                     add_log(Type, Args, AD);
                 _ ->
                     lists:foldl(
                       fun(NewArgs, NewAD) ->
                               add_log(Type, NewArgs, NewAD)
                       end, AD, Args)
             end,
    {noreply, State#state{ad=LastAD}};

handle_cast(_R , State) ->
    {noreply, State}.

handle_info('to_db', #state{ref=Ref, ad=AD} = State) ->
    util:cancel_timer(Ref),
    KVList = maps:to_list(AD),
    spawn(fun() -> all_to_db(KVList, 1, 100) end),
    Ref1 = erlang:send_after(?ADD_LOG_TIME, self(), 'to_db'),
    {noreply, State#state{ref=Ref1, ad=#{}}};

handle_info(_Reason, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    %% ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra)->
    {ok, State}.

is_args_list([], Len) -> Len;
is_args_list([H|N], Len) ->
    case is_list(H) of
        true -> is_args_list(N, Len+1);
        false -> 0
    end.

add_log(Type, Args, AD) ->
    case maps:find(Type, AD) of
        {ok, {?MAX_ACC, ArgsList}} ->
            lib_log:to_db(Type, [Args|ArgsList]),
            maps:remove(Type, AD);
        {ok, {Len,ArgsList}} ->
            AD#{Type := {Len+1, [Args|ArgsList]}};
        error ->
            AD#{Type => {1, [Args]}}
    end.

all_to_db([{Type, {_Len, Args}}|T], N, SleepMs) ->
    case N rem 2 of
        0 -> if SleepMs == 0 -> skip; true -> timer:sleep(SleepMs) end;
        _ -> skip
    end,
    lib_log:to_db(Type, Args),
    all_to_db(T, N+1, SleepMs);
all_to_db([], _, _) -> ok;
all_to_db([_|T], N, SleepMs) -> all_to_db(T, N, SleepMs).
