%%-----------------------------------------------------------------------------
%% @Module  :       mod_custom_act
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-05
%% @Description:    定制活动
%%-----------------------------------------------------------------------------
-module(mod_custom_act).

-behavious(gen_server).

-include("custom_act.hrl").
-include("common.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    apply_cast/2
    , day_trigger/2
    , sync_kf_act_info/2
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

apply_cast(F, A) ->
    gen_server:cast(?MODULE, {'apply_cast', F, A}).

sync_kf_act_info(ActStatusType, ActInfoL) ->
    gen_server:cast(?MODULE, {'sync_kf_act_info', ActStatusType, ActInfoL}).

day_trigger(ClockType, Delay) ->
    gen_server:cast(?MODULE, {'day_trigger', ClockType, Delay}).

init([]) ->
    %% 处理在关服期间关闭的活动的结算逻辑
    List = db:get_all(?select_opening_custom_act),
    NowTime = utime:unixtime(),
    F = fun(T, Acc) ->
        case T of
            [Type, SubType, WLv, Stime, Etime] ->
                ActInfo = #act_info{key = {Type, SubType}, wlv = WLv, stime = Stime, etime = Etime},
                case lib_custom_act_util:get_act_time_range_by_type(Type, SubType) of
                    {CfgStime, CfgEtime} ->
                        if
                            CfgEtime == Etime andalso NowTime >= CfgEtime -> %% 关服期间活动配置未进行修改
                                [{?CUSTOM_ACT_STATUS_CLOSE, ActInfo}|Acc];
                            NowTime < CfgEtime -> %% 活动未结束
                                ets:insert(?ETS_CUSTOM_ACT, ActInfo#act_info{stime = CfgStime, etime = CfgEtime}),
                                Acc;
                            true -> %% 关服期间配置发生更改并且启动时候已经大于活动结束时间则认为手动关闭活动
                                [{?CUSTOM_ACT_STATUS_MANUAL_CLOSE, ActInfo}|Acc]
                        end;
                    _ ->
                        [{?CUSTOM_ACT_STATUS_MANUAL_CLOSE, ActInfo}|Acc]
                end;
            _ -> skip
        end
    end,
    InitSettlementL = lists:foldl(F, [], List),
    F1 = fun(T, Acc) ->
        case Acc rem 20 of
            0 -> timer:sleep(100);
            _ -> skip
        end,
        case T of
            {?CUSTOM_ACT_STATUS_CLOSE, ActInfo} ->
                lib_custom_act:act_end(?CUSTOM_ACT_STATUS_CLOSE, ActInfo, NowTime),
                Acc + 1;
            {?CUSTOM_ACT_STATUS_MANUAL_CLOSE, ActInfo} ->
                lib_custom_act:act_end(?CUSTOM_ACT_STATUS_MANUAL_CLOSE, ActInfo, NowTime),
                Acc + 1;
            _ -> Acc
        end
    end,
    spawn(fun() -> timer:sleep(60 * 1000), lists:foldl(F1, 1, InitSettlementL) end),
    % 进程启动的时候不进行检查 避免其他活动进程还未启动
    % State = lib_custom_act:timer_check([]),
    {ok, #custom_act_state{}}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({'apply_cast', F, A}, State) ->
    NewState = apply(lib_custom_act, F, [State|A]),
    {ok, NewState};

do_handle_cast({'sync_kf_act_info', ActStatusType, ActInfoL}, State) ->
    % ?ERR("sync_kf_act_info:~p", [ActInfoL]),
    NewState = lib_custom_act:sync_kf_act_info(ActStatusType, ActInfoL, State),
    {ok, NewState};

do_handle_cast({'day_trigger', ClockType, _Delay}, State) ->
    lib_custom_act:day_trigger(ClockType),
    {ok, State};

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info({'reload'}, State) -> 
    #custom_act_state{rl_check_ref = Ref, rl_check_times = ReloadCheckTimes} = State,
    NewState = lib_custom_act:reload_act_list(State#custom_act_state{rl_check_times = ReloadCheckTimes + 1}),
    case ReloadCheckTimes + 1 < 5 of
        true -> NewRef = util:send_after(Ref, 60000, self(), {'reload'});
        _ -> NewRef = []
    end,
    {ok, NewState#custom_act_state{rl_check_ref = NewRef}};

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.