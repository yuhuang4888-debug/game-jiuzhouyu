%% ---------------------------------------------------------------------------
%% @doc 伤害统计
%% @author hek
%% @since  2016-11-14
%% @deprecated 本模块提供伤害统计服务
%% ---------------------------------------------------------------------------
-module (mod_hurt_statis).
-behaviour(gen_server).
-include ("common.hrl").
-include ("partner.hrl").
-include ("rec_hurt_statis.hrl").

%% API
-export([start_link/1, set_other/2, stop/1]).
-export([hurt/2, async_hurt_to_act/3, async_hurt_to_act/4]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link(StatisType) ->
    gen_server:start_link(?MODULE, [StatisType], []).

set_other(CopyId, Other) ->
    gen_server:cast(CopyId, {set_other, {Other}}).  

stop(CopyId) ->
    gen_server:cast(CopyId, {stop}).

%% 带伙伴出战的1v1伤害统计
%% @param Id        唯一id
%% @param Sign      对象类型
%% @param Hurt      伤害
hurt(CopyId, {Id, Sign, Hurt}) ->
    gen_server:cast(CopyId, {hurt, {Id, Sign, Hurt}}).       

%% 异步的方式将伤害发送给活动进程
async_hurt_to_act(CopyId, Pid, Msg) -> 
    async_hurt_to_act(CopyId, Pid, Msg, 0).

async_hurt_to_act(CopyId, Pid, Msg, Delay) -> 
    gen_server:cast(CopyId, {async_hurt_to_act, Pid, Msg, Delay}).

do_init([StatisType]) ->
    {ok, #hurt_statis_state{type = StatisType}}.

do_call(_Request, _From, State) ->
    {reply, ok, State}.

do_cast({hurt, Args}, State) ->
    {ok, NewState} = lib_hurt_statis_mod:hurt(Args, State),
    {noreply, NewState};

do_cast({async_hurt_to_act, Pid, Msg, 0}, State) ->
    util:cancel_timer(State#hurt_statis_state.ref),
    Pid ! {Msg, State#hurt_statis_state.data},
    {noreply, State};

do_cast({async_hurt_to_act, Pid, Msg, Delay}, State) ->
    OldRef = State#hurt_statis_state.ref,
    Ref = util:send_after(OldRef, Delay, self(), {async_hurt_to_act, Pid, Msg, 0}),
    NewState = State#hurt_statis_state{ref = Ref},
    {noreply, NewState};

do_cast({set_other, {Other}}, State) ->
    {noreply, State#hurt_statis_state{other = Other}};

do_cast({stop}, State) ->
    {stop, normal, State};

do_cast(_Msg, State) ->
    {noreply, State}.

do_info({async_hurt_to_act, Pid, Msg, _Delay}, State) ->
    util:cancel_timer(State#hurt_statis_state.ref),
    Pid ! {Msg, State#hurt_statis_state.data},
    {noreply, State};

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
terminate(_Reason, State) ->
    util:cancel_timer(State#hurt_statis_state.ref),
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

