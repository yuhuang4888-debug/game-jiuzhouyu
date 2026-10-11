%% ---------------------------------------------------------------------------
%% @doc lib_scene_timer
%% @author ming_up@foxmail.com
%% @since  2017-05-02
%% @deprecated 场景定时器函数
%% ---------------------------------------------------------------------------
-module(lib_scene_timer).

-compile([export_all]).

add_timer(_NowTime, WaitTime, Sign, Id, EventId, Args) -> 
    %% erlang:send_after(WaitTime+200, self(), {'timer_call_back', [{Sign, Id, EventId, Args}]}).
    erlang:start_timer(WaitTime+200, self(), {'timer_call_back', [{Sign, Id, EventId, Args}]}).
