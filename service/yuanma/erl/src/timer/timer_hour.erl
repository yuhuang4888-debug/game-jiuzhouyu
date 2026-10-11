%% ---------------------------------------------------------------------------
%% @doc timer_hour
%% @author ming_up@foxmail.com
%% @since  2016-09-18
%% @deprecated xx:00:01执行的定时器
%% ---------------------------------------------------------------------------
-module(timer_hour).
-include ("common.hrl").

-export([start_link/0, handle/0]).
-export([init/1, callback_mode/0, handle_event/4, terminate/3, code_change/4]).

handle() ->
    ClsType = config:get_cls_type(),
    do_handle(ClsType).

%% 游戏服handle
do_handle(?NODE_GAME) ->
    %% 要执行的代码写在下面
    ok;

%% 跨服handle
do_handle(?NODE_CENTER) ->
    %% 要执行的代码写在下面
    ok;

do_handle(ClsType) ->
    ?ERR("unkown cls_type:~p", [ClsType]),
    ok.

%% 定时器启动
start_link() ->
    gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).

callback_mode()->
    handle_event_function.

init([]) ->
    Time = get_next_time(),
    Ref  = erlang:send_after(Time*1000, self(), 'do'),
    {ok, timeout, Ref}.

handle_event(Type, Msg, StateName, State)->
    case catch do_handle_event(Type, Msg, StateName, State) of
        {'EXIT', _R} ->
            ?ERR("handle_exit_error:~p~n", [[Type, Msg, StateName, _R]]),
            {keep_state, State};
        Reply ->
            Reply
    end.

terminate(_Reason, _StateName, _State) ->
    %% ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, StateName, Status, _Extra) ->
    {ok, StateName, Status}.


%% ================================= private fun =================================
get_next_time() ->
    {_, {_, Min, S}} = calendar:local_time(),
    3600 - Min*60 - S + 1.

do_handle_event(info, 'do', timeout, ORef)->
    util:cancel_timer(ORef),
    case catch handle() of
        ok    -> skip;
        Error -> ?ERR("handle_error:~p", [Error])
    end,
    Time = get_next_time(),
    Ref = erlang:send_after(Time*1000, self(), 'do'),
    {next_state, timeout, Ref};

do_handle_event(_Type, _Msg, _StateName, State) ->
    ?PRINT("no match :~p~n", [[_Type, _Msg, _StateName]]),
    {keep_state, State}.
 
