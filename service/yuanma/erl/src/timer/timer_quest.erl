%% ---------------------------------------------------------------------------
%% @doc 动态定时服务
%% @author hek
%% @since  2016-11-30
%% @deprecated
%% ---------------------------------------------------------------------------
-module (timer_quest).

-include ("common.hrl").
-include ("def_timer_quest.hrl").

%% API
-export([start_link/0, add/4, delete/1]).
-export([init/1, callback_mode/0, handle_event/4, terminate/3, code_change/4]).

-record (timer, {
           id           = 0,                %% 定时器id
           duration     = 0,                %% 超时时长(秒)
           loop         = 0,                %% 是否循环:-1无限循环，0不循环，N循环N次
           mfa          = undefined,        %% MFA：{M, F, A}
           time         = 0                 %% 下次超时时间戳
          }).

-record (state, {
           ref        = none,               %% utimer定时器ref
           next_time  = 0,                  %% utimer下次超时时间戳
           timer_map  = #{}                 %% #{id => #timer{}}
          }).

%%% Usage:
%%% timer_quest:add(?UTIMER_ID(?TIMER_WANTED, 1), 10, 5, {io, format, ["timer_quest~n"]}).
%%% timer_quest:delete(?UTIMER_ID(?TIMER_WANTED, 1)).

%% 定时器启动
start_link() ->
    gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ---------------------------------------------------------------------------
%% @doc 添加一个动态定时器
-spec add(TimerId, Duration, Loop, MFA) -> Res when
      TimerId   :: {integer(), integer()},%% 定时器唯一id：是个组合id, ?UTIMER_ID(Type, Id)
                                          %% 注：Type为定时器类型, def_timer_quest.hrl中定义
                                          %%     Id为定时器Id
      Duration  :: integer(),             %% 超时时长(秒)
      Loop      :: integer(),             %% 是否循环
                                          %% ?LOOP_UNLIMIT::-1 循环类型：无限循环
                                          %% ?LOOP_LIMIT  ::0  循环类型：不循环
                                          %% N          ::N  循环类型：循环N次
      MFA       :: term(),                %% {模块, 函数, 参数}
      Res       :: ok.
%% ---------------------------------------------------------------------------
add(TimerId, Duration, Loop, MFA) ->
    misc:whereis_name(local, ?MODULE) ! {add, TimerId, Duration, Loop, MFA},
    ok.

%% ---------------------------------------------------------------------------
%% @doc 添加一个动态定时器
-spec delete(TimerId) -> Res when
      TimerId   :: {integer(), integer()},%% 定时器唯一id：是个组合id，?UTIMER_ID(Type, Id)
                                          %% 注：Type为定时器类型, def_timer_quest.hrl中定义
                                          %%     Id为定时器Id
      Res       :: ok.
%% ---------------------------------------------------------------------------
delete(TimerId) ->
    misc:whereis_name(local, ?MODULE) ! {delete, TimerId},
    ok.

%% callback function
callback_mode()->
    handle_event_function.

init([]) ->
    process_flag(trap_exit, true),
    NowTime = utime:unixtime(),
    Time    = get_next_time(), %% 1s
    Ref = erlang:send_after(Time*1000, self(), 'do'),
    {ok, timeout, #state{ref = Ref, next_time = NowTime + Time}}.

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

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.


%% ================================= private fun =================================

%% 定时时间
get_next_time() -> 1.

get_min_timeout(TimerList) ->
    TimeList = [Time || {_Id, #timer{time = Time}} <- TimerList],
    SortList = lists:sort(TimeList),
    case length(SortList) > 0 of
        true -> max(get_next_time(), hd(SortList) - utime:unixtime());
        false -> 0
    end.

%% 处理超时任务
hanlde_timeout(TimeoutList) ->
    F = fun(#timer{mfa = MFA}) -> lib_crontab:run_task(MFA) end,
    spawn(fun() -> lists:foreach(F, TimeoutList) end).

%% 处理循环
handle_loop(TimeoutList, TimerMap, State) ->
    NowTime = utime:unixtime(),
    F = fun(#timer{
               id           = Id,
               duration     = Duration,
               loop         = Loop
              } = Timer, Maps) ->
                NewLoop = Loop - 1,
                if
                    %% 继续处理循环
                    Loop >0 andalso NewLoop>0 ->
                        NewTimer =  Timer#timer{
                                      loop = NewLoop,
                                      time = NowTime+Duration
                                     },
                        maps:put(Id, NewTimer, Maps);
                    %% 循环完毕
                    Loop >0 ->
                        maps:remove(Id, Maps);
                    %% 不需要循环
                    Loop == ?LOOP_LIMIT    ->
                        maps:remove(Id, Maps);
                    %% 无限循环
                    true  ->
                        NewTimer =  Timer#timer{
                                      time = NowTime+Duration
                                     },
                        maps:put(Id, NewTimer, Maps)
                end
        end,
    NewTimerMap = lists:foldl(F, TimerMap, TimeoutList),
    State#state{timer_map = NewTimerMap}.

%% 是否重置下次超时
reset_ref(#state{ref = OldRef, timer_map = TimerMap, next_time = OldNextTime} = State) ->
    NowTime = utime:unixtime(),
    TimerList = maps:to_list(TimerMap),
    TimerOut = get_min_timeout(TimerList),
    if
        (OldNextTime == 0 andalso TimerOut >0) orelse
        (OldNextTime - NowTime > TimerOut) ->
            util:cancel_timer(OldRef),
            NexTime = NowTime + TimerOut,
            Ref = erlang:send_after(TimerOut*1000, self(), 'do');
        true ->
            NexTime = OldNextTime, Ref = OldRef
    end,
    State#state{ref = Ref, next_time = NexTime}.

%% handle event
do_handle_event(info, 'do', _StateName, State) ->
    Unixtime = utime:unixtime(),
    TimerMap = State#state.timer_map,
    TimerList = maps:to_list(TimerMap),
    TimeoutList = [ T || {_Id, #timer{time = Time} = T} <- TimerList, Time =< Unixtime],
    %% 处理超时
    hanlde_timeout(TimeoutList),
    %% 处理循环
    NewState = handle_loop(TimeoutList, TimerMap, State),
    %% 是否重置
    LastState = reset_ref(NewState#state{next_time = 0}),
    {next_state, timeout, LastState};

do_handle_event(info, {add, TimerId, Duration, Loop, MFA}, StateName, State)->
    NowTime  = utime:unixtime(),
    TimerMap = State#state.timer_map,
    Timer = #timer{
               id           = TimerId,
               duration     = Duration,
               loop         = Loop,
               mfa      = MFA,
               time         = NowTime + Duration
              },
    NewTimerMap = maps:put(TimerId, Timer, TimerMap),
    NewState = State#state{timer_map = NewTimerMap},
    LastState = reset_ref(NewState),
    {next_state, StateName, LastState};

do_handle_event(info, {delete, TimerId}, StateName, State)->
    TimerMap = State#state.timer_map,
    NewTimerMap = maps:remove(TimerId, TimerMap),
    NewState = State#state{timer_map = NewTimerMap},
    LastState = reset_ref(NewState),
    {next_state, StateName, LastState};

do_handle_event(_Type, _Msg, _StateName, State) ->
    ?PRINT("no match :~p~n", [[_Type, _Msg, _StateName]]),
    {keep_state, State}.
