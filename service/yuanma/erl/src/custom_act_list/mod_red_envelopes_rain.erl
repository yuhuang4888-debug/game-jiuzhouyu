% %% ---------------------------------------------------------------------------
% %% @doc mod_red_envelopes_rain
% %% @author
% %% @since
% %% @deprecated
% %% ---------------------------------------------------------------------------
-module(mod_red_envelopes_rain).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("custom_act.hrl").
-include("custom_act_list.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("counter_global.hrl").
-include("goods.hrl").
%%-----------------------------

act_start(ActInfo) ->
    gen_server:cast(?MODULE, {act_start, ActInfo}).

act_end(ActInfo) ->
    gen_server:cast(?MODULE, {act_end, ActInfo}).

clear_daily(Type, SubType) ->
    gen_server:cast(?MODULE, {clear_daily, Type, SubType}).

server_add_recharge(Add) ->
    gen_server:cast(?MODULE, {server_add_recharge, Add}).

server_add_activity(Add) ->
    gen_server:cast(?MODULE, {server_add_activity, Add}).

send_red_envelopes_rain(Msg) ->
    gen_server:cast(?MODULE, {send_red_envelopes_rain, Msg}).

send_red_envelopes_rain_reward_view(Msg) ->
    gen_server:cast(?MODULE, {send_red_envelopes_rain_reward_view, Msg}).

receive_red_envelopes(Msg) ->
    gen_server:cast(?MODULE, {receive_red_envelopes, Msg}).

gm_start_red_rain(SubType) ->
    gen_server:cast(?MODULE, {gm_start_red_rain, SubType}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

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
    {ok, #rer_state{custom_act_rain = #{}}}.

%% ====================
%% hanle_call
%% ====================


do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ====================
do_handle_cast({act_start, ActInfo}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    #act_info{key = {Type, SubType}} = ActInfo,
    erase({?MODULE, source}),
    ?PRINT("act_start ########### ~n", []),
    case maps:get(SubType, CustomActRain, 0) of
        #red_envelopes_rain{} ->
            {noreply, State};
        _ ->
            RedEnvelopseRain = new_red_envelopes_rain(Type, SubType),
            NewCustomActRain = maps:put(SubType, RedEnvelopseRain, CustomActRain),
            NewState = State#rer_state{custom_act_rain = NewCustomActRain},
            %?PRINT("act_start : ~p~n", [NewState]),
            {noreply, NewState}
    end;

do_handle_cast({act_end, ActInfo}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    #act_info{key = {Type, SubType}} = ActInfo,
    case maps:get(SubType, CustomActRain, 0) of
        #red_envelopes_rain{ref = Ref} ->
            erase({?MODULE, source}),
            util:cancel_timer(Ref),
            lib_red_envelopes_rain:clear_act_value(Type, SubType),
            NewCustomActRain = maps:remove(SubType, CustomActRain),
            NewState = State#rer_state{custom_act_rain = NewCustomActRain},
            %?PRINT("act_end : ~p~n", [NewState]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({clear_daily, Type, SubType}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    case maps:get(SubType, CustomActRain, 0) of
        #red_envelopes_rain{} = RedEnvelopseRain ->
            lib_red_envelopes_rain:clear_act_value(Type, SubType),
            NewRedEnvelopseRain = RedEnvelopseRain#red_envelopes_rain{act_value = 0},
            NewCustomActRain = maps:put(SubType, NewRedEnvelopseRain, CustomActRain),
            NewState = State#rer_state{custom_act_rain = NewCustomActRain},
            %?PRINT("clear_daily : ~p~n", [NewRedEnvelopseRain]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({server_add_recharge, Add}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    %% 获取正在开启的红包雨活动
    Type = ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN,
    case lib_custom_act_api:get_open_subtype_ids(Type) of
        [] ->
            {noreply, State};
        SubTypeList ->
            case check_open_source(Type) of
                true ->
                    F = fun(SubType, CustomActRainTmp) ->
                        case lib_red_envelopes_rain:is_recharge_red_rain(SubType) of
                            true ->
                                NowTime = utime:unixtime(),
                                case maps:get(SubType, CustomActRainTmp, 0) of
                                    #red_envelopes_rain{start_time = StartTime} = RedEnvelopseRain ->
                                        IsSameDay = lib_red_envelopes_rain:is_same_day(Type, SubType, StartTime, NowTime),
                                        case IsSameDay andalso NowTime < StartTime of
                                            true ->
                                                mod_global_counter:plus_count(?MOD_AC_CUSTOM, ?GLOBAL_331_RER_RAIN_RECHARGE, Add),
                                                NewActValue = RedEnvelopseRain#red_envelopes_rain.act_value + Add,
                                                NewRedEnvelopseRain = RedEnvelopseRain#red_envelopes_rain{act_value = NewActValue},
                                                send_server_red_rain_start_af_time(RedEnvelopseRain, NewRedEnvelopseRain),
                                                maps:put(SubType, NewRedEnvelopseRain, CustomActRainTmp);
                                            _ ->
                                                CustomActRainTmp
                                        end;
                                    _ ->
                                        mod_global_counter:plus_count(?MOD_AC_CUSTOM, ?GLOBAL_331_RER_RAIN_RECHARGE, Add),
                                        CustomActRainTmp
                                end;
                            _ ->
                                CustomActRainTmp
                        end
                    end,
                    NewCustomActRain = lists:foldl(F, CustomActRain, SubTypeList),
                    {noreply, State#rer_state{custom_act_rain = NewCustomActRain}};
                _ ->
                    {noreply, State}
            end
    end;

do_handle_cast({server_add_activity, Add}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    Type = ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN,
    case lib_custom_act_api:get_open_subtype_ids(Type) of
        [] ->
            {noreply, State};
        SubTypeList ->
            case check_open_source(Type) of
                true ->
                    F = fun(SubType, CustomActRainTmp) ->
                        case lib_red_envelopes_rain:is_activity_red_rain(SubType) of
                            true ->
                                ?PRINT("server_add_activity ok ~p~n", [SubType]),
                                NowTime = utime:unixtime(),
                                case maps:get(SubType, CustomActRainTmp, 0) of
                                    #red_envelopes_rain{start_time = StartTime} = RedEnvelopseRain ->
                                        IsSameDay = lib_red_envelopes_rain:is_same_day(Type, SubType, StartTime, NowTime),
                                        case IsSameDay andalso NowTime < StartTime of
                                            true ->
                                                mod_global_counter:plus_count(?MOD_AC_CUSTOM, ?GLOBAL_331_RER_RAIN_ACTIVITY, Add),
                                                NewActValue = RedEnvelopseRain#red_envelopes_rain.act_value + Add,
                                                NewRedEnvelopseRain = RedEnvelopseRain#red_envelopes_rain{act_value = NewActValue},
                                                send_server_red_rain_start_af_time(RedEnvelopseRain, NewRedEnvelopseRain),
                                                maps:put(SubType, NewRedEnvelopseRain, CustomActRainTmp);
                                            _ ->
                                                %?PRINT("server_add_activity not add ~p~n", [{IsSameDay, NowTime < StartTime}]),
                                                CustomActRainTmp
                                        end;
                                    _ ->
                                        mod_global_counter:plus_count(?MOD_AC_CUSTOM, ?GLOBAL_331_RER_RAIN_ACTIVITY, Add),
                                        CustomActRainTmp
                                end;
                            _ ->
                                CustomActRainTmp
                        end
                    end,
                    NewCustomActRain = lists:foldl(F, CustomActRain, SubTypeList),
                    {noreply, State#rer_state{custom_act_rain = NewCustomActRain}};
                _ ->
                    {noreply, State}
            end
    end;

do_handle_cast({send_red_envelopes_rain, [SubType, RoleId, Sid]}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    case maps:get(SubType, CustomActRain, 0) of
        #red_envelopes_rain{start_time = StartTime, wave = Wave, act_value = ActValue, receivers = ReceiverList, not_receivers = NotReceiverList} ->
            SendList = lists:foldl(fun({WaveSend, WaveReceiverList}, List) ->
                case lists:keyfind(RoleId, #envelopes_receiver.role_id, WaveReceiverList) of
                    #envelopes_receiver{rewards = RewardList} -> [{WaveSend, 1, RewardList}|List];
                    _ ->
                        {_, NotWaveReceiverList} = ulists:keyfind(WaveSend, 1, NotReceiverList, {WaveSend, []}),
                        case lists:keymember(RoleId, #envelopes_receiver.role_id, NotWaveReceiverList) of
                            true ->
                                [{WaveSend, 1, []}|List];
                            _ ->
                                [{WaveSend, 0, []}|List]
                        end
                end
            end, [], ReceiverList),
            ClearType1 = lib_red_envelopes_rain:get_clear_type(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType),
            ClearType = ?IF(ClearType1 == ?CUSTOM_ACT_CLEAR_FOUR, 2, 1),
            lib_server_send:send_to_sid(Sid, pt_331, 33155, [SubType, ActValue, Wave, StartTime, ClearType, SendList]),
            ?PRINT("send_red_envelopes_rain {ActValue, Wave} : ~p~n", [{ActValue, Wave}]),
            %?PRINT("send_red_envelopes_rain StartTime : ~p~n", [utime:unixtime_to_localtime(StartTime)]),
            ?PRINT("send_red_envelopes_rain SendList : ~p~n", [SendList]),
            {noreply, State};
        _ ->
            lib_server_send:send_to_sid(Sid, pt_331, 33155, [SubType, 0, 0, 0, 0, []]),
            {noreply, State}
    end;

do_handle_cast({send_red_envelopes_rain_reward_view, [SubType, Wave, _RoleId, Sid]}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    case maps:get(SubType, CustomActRain, 0) of
        #red_envelopes_rain{} ->
            RewardIdAll = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType),
            F = fun(RewardId, Acc) ->
                case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType, RewardId) of
                    #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_COMMON, condition = Condition, reward = RewardList} ->
                        case lists:keyfind(wave, 1, Condition) of
                            {_, Wave} ->
                                {_, IsRare} = ulists:keyfind(rare, 1, Condition, {rare, 0}),
                                [{RewardList, util:term_to_string([{rare, IsRare}])}|Acc];
                            _ -> Acc
                        end;
                    _ -> Acc
                end
            end,
            SendList = lists:foldl(F, [], RewardIdAll),
            ?PRINT("send_red_envelopes_rain_reward_view SendList : ~p~n", [SendList]),
            lib_server_send:send_to_sid(Sid, pt_331, 33156, [SubType, Wave, SendList]),
            {noreply, State};
        _ ->
            lib_server_send:send_to_sid(Sid, pt_331, 33156, [SubType, Wave, []]),
            {noreply, State}
    end;

do_handle_cast({receive_red_envelopes, [SubType, Sid, Wlv, RerReceiver]}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    case maps:get(SubType, CustomActRain, 0) of
        #red_envelopes_rain{start_time = StartTime, wave = Wave} = RedEnvelopseRain ->
            NowTime = utime:unixtime(),
            case Wave == 1 andalso NowTime < StartTime of
                true -> %% 没到时间
                    Code = ?ERRCODE(err331_not_send_time),
                    ReceiveWave = 0,
                    RewardList = [],
                    NewState = State;
                _ ->
                    ReceiveWave = ?IF(NowTime < StartTime, Wave - 1, Wave),
                    {Code, RewardCfg, NewRerReceiver, NewRedEnvelopseRain} = calc_red_envelopes_do(RedEnvelopseRain, ReceiveWave, Wlv, RerReceiver),
                    NewCustomActRain = maps:put(SubType, NewRedEnvelopseRain, CustomActRain),
                    #envelopes_receiver{role_id = RoleId, rewards = RewardList} = NewRerReceiver,
                    RewardList = NewRerReceiver#envelopes_receiver.rewards,
                    ?PRINT("receive_red_envelopes RewardList : ~p~n", [RewardList]),
                    case Code == ?SUCCESS of
                        true ->
                            case RewardCfg == [] of
                                true ->
                                    lib_log_api:log_custom_act_reward(RoleId, ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType, ReceiveWave, RewardList);
                                _ ->
                                    lib_log_api:log_custom_act_reward(RoleId, ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType, RewardCfg#custom_act_reward_cfg.grade, RewardList)
                            end,
                            send_red_envelopes_rain_reward(ReceiveWave, RewardCfg, NewRerReceiver),
                            handle_receive_succ(ReceiveWave, NewRerReceiver, RewardCfg);
                        _ ->
                            skip
                    end,
                    NewState = State#rer_state{custom_act_rain = NewCustomActRain}
            end,
            ?PRINT("receive_red_envelopes Code : ~p~n", [Code]),
            lib_server_send:send_to_sid(Sid, pt_331, 33157, [Code, SubType, ReceiveWave, RewardList]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({gm_start_red_rain, SubType}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    case maps:get(SubType, CustomActRain, 0) of
        #red_envelopes_rain{ref = OldRef} = RedEnvelopseRain ->
            util:cancel_timer(OldRef),
            NowTime = utime:unixtime(),
            NewStartTime = NowTime + 60,
            Wave = 1,
            Ref = reset_ref(Wave, NewStartTime, NowTime, SubType),
            NewRedEnvelopesRain = RedEnvelopseRain#red_envelopes_rain{start_time = NewStartTime, wave = Wave, ref = Ref},
            NewCustomActRain = maps:put(SubType, NewRedEnvelopesRain, CustomActRain),
            %?PRINT("gm_start_red_rain NewCustomActRain : ~p~n", [NewCustomActRain]),
            NewState = State#rer_state{custom_act_rain = NewCustomActRain},
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================
do_handle_info({prepare_send_red_rain, SubType}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    case check_open_source(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN) of
        true ->
            NowTime = utime:unixtime(),
            case maps:get(SubType, CustomActRain, 0) of
                #red_envelopes_rain{start_time = StartTime, wave = Wave, ref = OldRef} = RedEnvelopseRain when NowTime < StartTime ->
                    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType) of
                        true ->
                            case lib_red_envelopes_rain:check_can_send_rain(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType, RedEnvelopseRain) of
                                true ->
                                    %% 发送预告传闻
                                    send_prepare_tv(SubType, NowTime, StartTime, Wave),
                                    ok;
                                _ ->
                                    skip
                            end,
                            %% 都开定时器进行红包发送，在具体发送时才判断活动数值是否满足发送条件
                            Ref = util:send_after(OldRef, (StartTime - NowTime)*1000, self(), {send_red_rain, SubType}),
                            NewRedEnvelopesRain = RedEnvelopseRain#red_envelopes_rain{ref = Ref},
                            NewCustomActRain = maps:put(SubType, NewRedEnvelopesRain, CustomActRain),
                            NewState = State#rer_state{custom_act_rain = NewCustomActRain},
                            {noreply, NewState};
                        _ ->
                            {noreply, State}
                    end;
                _ ->
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;

do_handle_info({send_red_rain, SubType}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    NowTime = utime:unixtime(),
    Type = ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN,
    case check_open_source(Type) of
        true ->
            case maps:get(SubType, CustomActRain, 0) of
                #red_envelopes_rain{wave = OldWave, start_time = OldStartTime, ref = OldRef} = RedEnvelopseRain ->
                    case lib_custom_act_api:is_open_act(Type, SubType) of
                        true ->
                            case lib_red_envelopes_rain:check_can_send_rain(Type, SubType, RedEnvelopseRain) of
                                true ->
                                    %% 发送红包
                                    {ok, Bin} = pt_331:write(33158, [SubType, OldWave, OldStartTime]),
                                    lib_server_send:send_to_all(Bin),
                                    %% 计算下一波
                                    util:cancel_timer(OldRef),
                                    {_, TotalWave, TimeGap} = lib_red_envelopes_rain:get_red_envelopes_rain_time(Type, SubType),
                                    case OldWave == TotalWave of
                                        true -> %% 发送最后一波
                                            Ref = util:send_after([], TimeGap*1000, self(), {end_red_rain, SubType}),
                                            NewRedEnvelopesRain = RedEnvelopseRain#red_envelopes_rain{ref = Ref},
                                            NewCustomActRain = maps:put(SubType, NewRedEnvelopesRain, CustomActRain),
                                            ?PRINT("send_red_rain Last Wave ~n", []),
                                            NewState = State#rer_state{custom_act_rain = NewCustomActRain},
                                            {noreply, NewState};
                                        _ ->
                                            {Wave, NewStartTime} = lib_red_envelopes_rain:get_next_start_time(OldWave, OldStartTime, Type, SubType, NowTime),
                                            Ref = reset_ref(Wave, NewStartTime, NowTime, SubType),
                                            NewRedEnvelopesRain = RedEnvelopseRain#red_envelopes_rain{start_time = NewStartTime, wave = Wave, ref = Ref},
                                            NewCustomActRain = maps:put(SubType, NewRedEnvelopesRain, CustomActRain),
                                            NewState = State#rer_state{custom_act_rain = NewCustomActRain},
                                            ?PRINT("send_red_rain Next Wave : ~p~n", [Wave]),
                                            %?PRINT("send_red_rain NewStartTime : ~p~n", [utime:unixtime_to_localtime(NewStartTime)]),
                                            {noreply, NewState}
                                    end;
                                _ -> %% 不满足发送，后续波数也不发送了, 直接计算下一天的红包雨
                                    util:cancel_timer(OldRef),
                                    {Wave, NewStartTime} = lib_red_envelopes_rain:get_next_day_start_time(Type, SubType, NowTime),
                                    Ref = reset_ref(Wave, NewStartTime, NowTime, SubType),
                                    NewRedEnvelopesRain = RedEnvelopseRain#red_envelopes_rain{start_time = NewStartTime, wave = Wave, ref = Ref},
                                    NewCustomActRain = maps:put(SubType, NewRedEnvelopesRain, CustomActRain),
                                    ?PRINT("send_red_rain not send Next Wave : ~p~n", [Wave]),
                                    %?PRINT("send_red_rain not send NewStartTime : ~p~n", [utime:unixtime_to_localtime(NewStartTime)]),
                                    NewState = State#rer_state{custom_act_rain = NewCustomActRain},
                                    {noreply, NewState}
                            end;
                        _ ->
                            {noreply, State}
                    end;
                _ ->
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;

do_handle_info({end_red_rain, SubType}, State) ->
    #rer_state{custom_act_rain = CustomActRain} = State,
    NowTime = utime:unixtime(),
    Type = ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN,
    erase({?MODULE, source}),
    case maps:get(SubType, CustomActRain, 0) of
        #red_envelopes_rain{wave = OldWave, start_time = OldStartTime, ref = OldRef} = RedEnvelopseRain ->
            case lib_custom_act_api:is_open_act(Type, SubType) of
                true ->
                    %% 红包结束
                    {ok, Bin} = pt_331:write(33158, [SubType, 0, 0]),
                    lib_server_send:send_to_all(Bin),
                    %% 计算下一波
                    util:cancel_timer(OldRef),
                    {Wave, NewStartTime} = lib_red_envelopes_rain:get_next_start_time(OldWave, OldStartTime, Type, SubType, NowTime),
                    Ref = reset_ref(Wave, NewStartTime, NowTime, SubType),
                    NewRedEnvelopesRain = RedEnvelopseRain#red_envelopes_rain{start_time = NewStartTime, wave = Wave, receivers = [], not_receivers = [], ref = Ref},
                    NewCustomActRain = maps:put(SubType, NewRedEnvelopesRain, CustomActRain),
                    NewState = State#rer_state{custom_act_rain = NewCustomActRain},
                    ?PRINT("end_red_rain Next Wave : ~p~n", [Wave]),
                    %?PRINT("end_red_rain NewStartTime : ~p~n", [utime:unixtime_to_localtime(NewStartTime)]),
                    {noreply, NewState};
                _ ->
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;

do_handle_info(_Info, State) -> {noreply, State}.

new_red_envelopes_rain(Type, SubType) ->
    NowTime = utime:unixtime(),
    {Wave, NewStartTime} = lib_red_envelopes_rain:get_start_time(Type, SubType, NowTime),
    Ref = reset_ref(Wave, NewStartTime, NowTime, SubType),
    ActValue = lib_red_envelopes_rain:get_act_value(Type, SubType),
    %?PRINT("new_red_envelopes_rain NewStartTime ~p ~n", [utime:unixtime_to_localtime(NewStartTime)]),
    %?PRINT("new_red_envelopes_rain {Wave, ActValue} ~p ~n", [{Wave, ActValue}]),
    RedEnvelopseRain = #red_envelopes_rain{subtype = SubType, act_value = ActValue, start_time = NewStartTime, wave = Wave, ref = Ref},
    RedEnvelopseRain.

reset_ref(0, _NewStartTime, _NowTime, _SubType) -> none;
reset_ref(_Wave, NewStartTime, NowTime, SubType) ->
    NotifyTime = NewStartTime - lib_red_envelopes_rain:get_notify_time(SubType),  %% 预告时间
    case NotifyTime =< NowTime of
        true ->
            Ref = util:send_after([], (NewStartTime - NowTime)*1000, self(), {send_red_rain, SubType});
        _ ->
            Ref = util:send_after([], (NotifyTime - NowTime)*1000, self(), {prepare_send_red_rain, SubType})
    end,
    Ref.

send_server_red_rain_start_af_time(OldRedEnvelopseRain, NewRedEnvelopseRain) ->
    #red_envelopes_rain{subtype = SubType, act_value = OldActValue} = OldRedEnvelopseRain,
    #red_envelopes_rain{wave = Wave, start_time = StartTime, act_value = NewActValue} = NewRedEnvelopseRain,
    ActValue = lib_red_envelopes_rain:get_act_value(SubType),
    ClearType1 = lib_red_envelopes_rain:get_clear_type(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType),
    ClearType = ?IF(ClearType1 == ?CUSTOM_ACT_CLEAR_FOUR, 2, 1),
    case OldActValue < ActValue andalso NewActValue >= ActValue of
        true ->
            {ok, Bin} = pt_331:write(33155, [SubType, NewActValue, Wave, StartTime, ClearType, []]),
            lib_server_send:send_to_all(Bin),
            {_,{StartH, StartM, _}} = utime:unixtime_to_localtime(StartTime),
            StartTimeString = io_lib:format("~2..0w:~2..0w", [StartH, StartM]),
            ActName = lib_custom_act_api:get_act_name(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType),
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 48, [util:make_sure_binary(ActName), util:make_sure_binary(StartTimeString)]);
        _ -> skip
    end.

send_prepare_tv(_SubType, NowTime, StartTime, Wave) ->
    %ActName = lib_custom_act_api:get_act_name(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType),
    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 49, [Wave, StartTime - NowTime]).

handle_receive_succ(_ReceiveWave, NewRerReceiver, RewardCfg) when is_record(RewardCfg, custom_act_reward_cfg) ->
    #custom_act_reward_cfg{subtype = SubType, condition = Condition} = RewardCfg,
    case lists:keyfind(rare, 1, Condition) of
        {rare, 1} ->
            #envelopes_receiver{role_id = RoleId, role_name = RoleName, rewards = RewardsList} = NewRerReceiver,
            case RewardsList of
                [{?TYPE_GOODS, GoodsTypeId, GoodsNum}|_] ->
                    ActName = lib_custom_act_api:get_act_name(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType),
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 50, [RoleName, RoleId, util:make_sure_binary(ActName), GoodsTypeId, GoodsNum]);
                _ ->
                    skip
            end;
        _ ->
            skip
    end;
handle_receive_succ(_ReceiveWave, _NewRerReceiver, _RewardCfg) ->
    skip.

send_red_envelopes_rain_reward(ReceiveWave, RewardCfg, NewRerReceiver) ->
    case RewardCfg of
        #custom_act_reward_cfg{grade = RewardId} -> Remark = lists:concat([RewardId]);
        _ -> Remark = lists:concat([ReceiveWave])
    end,
    #envelopes_receiver{role_id = RoleId, rewards = RewardsList} = NewRerReceiver,
    Produce = #produce{type = envelopes_rain, reward = RewardsList, remark = Remark, show_tips = ?SHOW_TIPS_4},
    lib_goods_api:send_reward_with_mail(RoleId, Produce).

calc_red_envelopes_do(RedEnvelopseRain, ReceiveWave, Wlv, RerReceiver) ->
    #red_envelopes_rain{subtype = SubType, receivers = ReceiverList, not_receivers = NotReceiverList} = RedEnvelopseRain,
    #envelopes_receiver{role_id = RoleId} = RerReceiver,
    {_, WaveReceiverList} = ulists:keyfind(ReceiveWave, 1, ReceiverList, {ReceiveWave, []}),
    case lists:keymember(RoleId, #envelopes_receiver.role_id, WaveReceiverList) of
        true ->
            {?ERRCODE(err331_receive_red_envelopes), [], RerReceiver, RedEnvelopseRain};
        _ ->
            RedEnvelopseNum = lib_red_envelopes_rain:get_wave_red_envelopse_num(SubType, ReceiveWave),
            case length(WaveReceiverList) >= RedEnvelopseNum of
                true ->
                    {_, WaveNotReceiverList} = ulists:keyfind(ReceiveWave, 1, NotReceiverList, {ReceiveWave, []}),
                    case lists:keymember(RoleId, #envelopes_receiver.role_id, WaveNotReceiverList) of
                        true ->
                            NewRedEnvelopseRain = RedEnvelopseRain;
                        _ ->
                            NewNotReceiverList = lists:keystore(ReceiveWave, 1, NotReceiverList, {ReceiveWave, [RerReceiver|WaveNotReceiverList]}),
                            NewRedEnvelopseRain = RedEnvelopseRain#red_envelopes_rain{not_receivers = NewNotReceiverList}
                    end,
                    {?ERRCODE(err331_wave_red_envelopes_num_over), [], RerReceiver, NewRedEnvelopseRain};
                _ ->
                    RewardList= lib_red_envelopes_rain:get_red_envelopes_reward(SubType, ReceiveWave, Wlv, RerReceiver, WaveReceiverList),
                    NewRerReceiver = RerReceiver#envelopes_receiver{rewards = RewardList},
                    NewWaveReceiverList = [NewRerReceiver|WaveReceiverList],
                    NewReceiverList = lists:keystore(ReceiveWave, 1, ReceiverList, {ReceiveWave, NewWaveReceiverList}),
                    NewRedEnvelopseRain = RedEnvelopseRain#red_envelopes_rain{receivers = NewReceiverList},
                    {?SUCCESS, [], NewRerReceiver, NewRedEnvelopseRain}
            end
    end.

%%%%%%%%%%%%%%%% 渠道开启
check_open_source(Type) ->
    case lib_custom_act_api:get_open_subtype_ids(Type) of
        [] ->
            false;
        SubTypeList ->
            F = fun(SubType, List) ->
                case lib_custom_act_util:keyfind_act_condition(Type, SubType, source_list) of
                    {source_list, OpenSource} ->
                        List ++ OpenSource;
                    _ ->
                        List
                end
            end,
            OpenSourceList = lists:foldl(F, [], SubTypeList),
            case OpenSourceList == [] of
                true -> true;
                _ ->
                    SourceList = get_source_list(),
                    case [1 || Source <- OpenSourceList, lists:member(Source, SourceList)] == [] of
                        true -> false;
                        _ -> true
                    end
            end
    end.

get_source_list() ->
    case get({?MODULE, source}) of
        SourceList when is_list(SourceList) andalso length(SourceList) > 0 ->
            SourceList;
        _ ->
            case db:get_all(<<"select distinct source from player_login">>) of
                [] -> [];
                DbList ->
                    SourceList = [list_to_atom(util:make_sure_list(Source)) || [Source] <- DbList],
                    put({?MODULE, source}, SourceList),
                    SourceList
            end
    end.