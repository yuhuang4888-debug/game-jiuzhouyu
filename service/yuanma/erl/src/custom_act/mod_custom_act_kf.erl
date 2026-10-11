%%-----------------------------------------------------------------------------
%% @Module  :       mod_custom_act_kf
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-03-21
%% @Description:    跨服定制活动
%% @Desc    :
%% ·跨服定制活动在本服判断活动开启的时候还要额外判断开服合服等条件是否满足(默认规则:本服在活动开启期间达到的就能参加活动)
%% ·跨服定制活动开启/结束的时候在跨服中心通知对应其他功能在跨服中心的功能模块，然后由各模块自行通知本服功能的开启/结束
%% ·跨服类型的定制活动在同步到本服定制活动模块的时候不做通知各模块开启结束的处理,只处理ets的相关逻辑
%%-----------------------------------------------------------------------------
-module(mod_custom_act_kf).

-behavious(gen_server).

-include("custom_act.hrl").
-include("common.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    apply_cast/2
    , day_trigger/2
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

apply_cast(F, A) ->
    gen_server:cast(?MODULE, {'apply_cast', F, A}).

day_trigger(ClockType, Delay) ->
    gen_server:cast(?MODULE, {'day_trigger', ClockType, Delay}).

init([]) ->
    %% 处理在关服期间关闭的活动的结算逻辑
    List = db:get_all(?select_opening_kf_custom_act),
    NowTime = utime:unixtime(),
    F = fun(T, Acc) ->
        case T of
            [Type, SubType, WLv, Stime, Etime] ->
                ActInfo = #act_info{key = {Type, SubType}, wlv = WLv, stime = Stime, etime = Etime},
                case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                    ActCfg when is_record(ActCfg, custom_act_cfg) ->
                        case NowTime >= Etime of
                            true ->
                                [{?CUSTOM_ACT_STATUS_CLOSE, ActInfo}|Acc];
                            false ->
                                ets:insert(?ETS_CUSTOM_ACT, ActInfo),
                                Acc
                        end;
                    _ ->
                        [{?CUSTOM_ACT_STATUS_MANUAL_CLOSE, ActInfo}|Acc]
                end;
            _ -> skip
        end
    end,
    InitSettlementL = lists:foldl(F, [], List),
    F1 = fun(T) ->
        case T of
            {?CUSTOM_ACT_STATUS_CLOSE, ActInfo} ->
                lib_custom_act_kf:act_end(?CUSTOM_ACT_STATUS_CLOSE, ActInfo, NowTime),
                timer:sleep(100);
            {?CUSTOM_ACT_STATUS_MANUAL_CLOSE, ActInfo} ->
                lib_custom_act_kf:act_end(?CUSTOM_ACT_STATUS_MANUAL_CLOSE, ActInfo, NowTime),
                timer:sleep(100);
            _ -> skip
        end
    end,
    spawn(fun() -> timer:sleep(60 * 1000), lists:foreach(F1, InitSettlementL) end),
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
    NewState = apply(lib_custom_act_kf, F, [State|A]),
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
    NewState = lib_custom_act_kf:reload_act_list(State#custom_act_state{rl_check_times = ReloadCheckTimes + 1}),
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