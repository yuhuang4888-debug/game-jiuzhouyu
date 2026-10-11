%% ---------------------------------------------------------------------------
%% @doc timer_custom_kf.erl

%% @author hjh
%% @since  2016-09-22
%% @deprecated 定时器定制(跨服中心):用于定时开始、结束以及清理;附加延时需要开进程睡眠处理,错开时间.
%% ---------------------------------------------------------------------------
-module(timer_custom_kf).
-behaviour(gen_fsm).

-export([start_link/0, timeout/2]).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-export([add/1, delete/1]).

-include("timer_custom.hrl").

%% info_list = [#timer_custom{}]
-record(state, {tc_list, ref}).

%% 增加
add(Tc) -> 
    gen_fsm:send_all_state_event(?MODULE, {'add', Tc}).

%% 移除
delete(Key) -> 
    gen_fsm:send_all_state_event(?MODULE, {'delete', Key}).

start_link() -> 
    gen_fsm:start_link({global, ?MODULE}, ?MODULE, [], []).
    
init([]) ->
    TcList = load_timer_custom_list(),
    Ref = get_ref(TcList),
    State = #state{tc_list = TcList, ref = Ref},
    {ok, timeout, State}.

handle_event({'add', Tc}, StateName, State) ->
    #state{tc_list = TcList} = State,
    NewTcList = lists:keystore(Tc#timer_custom.key, #timer_custom.key, TcList, Tc),
    NewState = State#state{tc_list = NewTcList},
    NewState2 = reset_ref(NewState),
    {next_state, StateName, NewState2};

handle_event({'delete', Key}, StateName, State) ->
    #state{tc_list = TcList} = State,
    NewTcList = lists:keydelete(Key, #timer_custom.key, TcList),
    NewState = State#state{tc_list = NewTcList},
    NewState2 = reset_ref(NewState),
    {next_state, StateName, NewState2};

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
    {reply, ok, StateName, State}.

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

%% fsm State handle

timeout('do', State) -> 
    #state{tc_list = TcList} = State,
    Unixtime = utime:unixtime(),
    TimeoutList = [ T || #timer_custom{time = Time} = T <- TcList, Time < Unixtime],
    hanlde_timeout(TimeoutList),
    NewTcList = TcList -- TimeoutList,
    NewState = State#state{tc_list = NewTcList},
    NewState2 = reset_ref(NewState),
    {next_state, timeout, NewState2};
timeout(_Event, State) -> 
    {next_state, timeout, State}.

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

reset_ref(#state{ref = OldRef, tc_list = TcList} = State) ->
    util:cancel_timer(OldRef),
    Ref = get_ref(TcList),
    State#state{ref = Ref}.

get_ref(TcList) ->
    Timeout = get_timeout(TcList),
    case is_integer(Timeout) of
        true -> gen_fsm:send_event_after(Timeout*1000, 'do');
        false -> undefined
    end.

%% return second
get_timeout(TcList) ->
    TimeList = [Time || #timer_custom{time = Time} <- TcList],
    SortList = lists:sort(TimeList),
    case length(SortList) > 0 of
        true -> 
            max(0, hd(SortList) - utime:unixtime());
        false -> 
            infinity
    end.

%% 加载定制时间列表
load_timer_custom_list() ->
    TcList = [
        % lib_timer_custom:make_record(timer_custom, [?TC_TYPE_ACT, {a, a}, ?TC_TIME_TYPE_START, 0, #{}]),
        % lib_timer_custom:make_record(timer_custom, [?TC_TYPE_ACT, {b, b}, ?TC_TIME_TYPE_END, 0, #{}]),
        % lib_timer_custom:make_record(timer_custom, [?TC_TYPE_ACT, {c, c}, ?TC_TIME_TYPE_START, 1476949447, #{}]),
        % lib_timer_custom:make_record(timer_custom, [?TC_TYPE_ACT, {d, d}, ?TC_TIME_TYPE_END, 1477013241, #{}])
        ],
    TcList.

%% 处理timeout
hanlde_timeout(TimeoutList) ->
    DelayTimeoutList = attach_delay(TimeoutList),
    spawn(fun() -> handle_per_timeout(DelayTimeoutList) end),
    spawn(fun() -> handle_pack_timeout(DelayTimeoutList)end),
    ok.

%% 附加延迟
attach_delay(List) ->
    attach_delay(List, 0, []).

%% 需要特殊加附加时间在这里定义
attach_delay([], _Count, R) -> lists:reverse(R);
attach_delay([T|L], Count, R) ->
    NewT = T#timer_custom{delay = Count*?TC_DEF_DELAY},
    attach_delay(L, Count+1, [NewT|R]).

%% -----------------------------------------------------------
%% handle_per_timeout、handle_pack_timeout选择其一处理
%% 带有延迟的字段,需要先获取数据,再开进程睡眠处理消息
%% -----------------------------------------------------------

%% 处理每一个活动
handle_per_timeout([]) -> ok;
handle_per_timeout([_T|L]) -> 
    % io:format("~n M:~p L:~p _T:~p ~n", [?MODULE, ?LINE, _T]),
    handle_per_timeout(L).

%% 打包同类型,并且通知对应进程
handle_pack_timeout(List) ->
    F = fun(#timer_custom{type = Type} = Ts, TmpList)  ->
        case lists:keyfind(Type, 1, TmpList) of
            false -> [{Type, [Ts]}|TmpList];
            {_, TcList} -> lists:keystore(Type, 1, TmpList, {Type, [Ts|TcList]})
        end
    end,
    NewList = lists:foldr(F, [], List),
    do_handle_pack_timeout(NewList).

do_handle_pack_timeout([]) -> ok;
do_handle_pack_timeout([{_Type, _TcList}|L]) ->
    % io:format("~n M:~p L:~p Type:~p TcList:~p ~n", [?MODULE, ?LINE, _Type, _TcList]),
    do_handle_pack_timeout(L).
