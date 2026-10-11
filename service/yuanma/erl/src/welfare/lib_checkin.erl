%% ---------------------------------------------------------------------------
%% @doc 月签到
%% @author Liuxl
%% @since  2017-2-20
%% @deprecated
%% ---------------------------------------------------------------------------

-module(lib_checkin).
-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("vip.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("checkin.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("def_daily.hrl").
-include("def_module.hrl").
-include("activitycalen.hrl").
-include("welfare.hrl").

-compile(export_all).

login(PS) ->
	#player_status{pid = Pid, figure = #figure{lv = Lv}} = PS,
    OpenLvCfg = get_open_lv(),
	if
		Lv < OpenLvCfg -> %% 等级限制
			gen_server:cast(Pid, {'apply_cast', ?APPLY_CAST, lib_checkin, add_listener, [[?EVENT_LV_UP]]}),
			CheckState  = get_daily_status(PS),
            PS#player_status{check_in = CheckState};
		true ->
    		CheckState  = get_daily_status(PS),
    		PS#player_status{check_in = CheckState}
	end.


get_daily_status(PS) ->
	#player_status{id = RoleId, reg_time = Regtime, login_time_before_last = LastLogTime, last_login_time = Logintime} = PS,
	% Month = utime:get_month(),
    IsSameDay = utime:is_same_day(LastLogTime,Logintime),
    {Month, _} = get_open_server_date(Regtime),
    IsChecked = mod_daily:get_count(RoleId, ?MOD_WELFARE, ?DAILY_CHECKIN_IS_CHECKED),
    case data_checkin:get_checkin_type(PS#player_status.figure#figure.lv, Month) of
        [] ->
            empty_checkin_status(Regtime);
        #base_checkin_type{daily_type = DailyType, total_type = TotalType} ->
            case get_daily_checkin_db(RoleId) of
                [OldMonth, TotalState_B, DailyState_B, RetTimes, RemainTimes] when Month == OldMonth ->
        			OldTotalState = util:bitstring_to_term(TotalState_B),
        			OldDState = util:bitstring_to_term(DailyState_B),
                    if
                        IsSameDay == true ->
                            OldDailyState = OldDState;
                        true ->
                            OldDailyState = change_dailystate(OldDState)
                    end,
                    if
                        IsChecked == ?DAILY_CHECK_NOT_DID ->
                            NewDailyState = refresh_daily_status(OldDailyState, DailyType, Regtime);
                        true ->
                            NewDailyState = refresh_daily_after(OldDailyState, DailyType, Regtime, RetTimes)
                    end,
                    NewTotalState = refresh_total_status(OldTotalState, TotalType, get_checkin_days(NewDailyState)),
        			#checkin_status{month = Month , total_state = NewTotalState , daily_state = NewDailyState ,
                        retroactive_times = RetTimes, remain_times = RemainTimes};
                [OldMonth, TotalState_B, DailyState_B, _RetTimes] when Month =/= OldMonth ->
                    OldTotalState = util:bitstring_to_term(TotalState_B),
                    OldDailyState = util:bitstring_to_term(DailyState_B),
                    RewardL = get_lastmonth_total_reward(OldTotalState, TotalType, get_checkin_days(OldDailyState)),
                    Titles = utext:get(?TOTAL_CHECKIN_TITLE),
                    Contents = utext:get(?TOTAL_CHECKIN_CONTENT),
                    lib_mail_api:send_sys_mail([RoleId], Titles, Contents, RewardL),
                    default_checkin_status(DailyType, TotalType, Month, Regtime);
                _ ->
                    default_checkin_status(DailyType, TotalType, Month, Regtime)
            end
	end.


%%
get_lastmonth_total_reward(OldTotalState,TotalType,CheckedDays) ->
    F = fun(Days, Acc) ->
        case lists:keyfind(Days, 1, OldTotalState) of
            {Days, ?GIFT_RECEIVED} ->
                Acc;
            _ ->
                if
                    Days =< CheckedDays ->
                        case data_checkin:get_total_rewards(TotalType, Days) of
                            #base_checkin_total_rewards{rewards = Rewards} ->
                                if
                                    is_list(Rewards) ->
                                        lists:foldl(fun(H, Accs) -> [H|Accs] end, Acc, Rewards);
                                    true ->
                                        [Rewards|Acc]
                                end;
                            _ ->
                                Acc
                        end;
                    true ->
                        Acc
                end
        end
    end,
    DayList = data_checkin:get_total_list(TotalType),
    RewardL = lists:foldl(F, [], DayList),
    RewardL.

%% 刷新每日签到状态
% refresh_daily_status_before(OldDailyState, DailyType) ->
%     F = fun(Day) ->
%         case lists:keyfind(Day, 1, OldDailyState) of
%             {Day, ?DAILY_CHECK_DID} -> {Day, ?DAILY_CHECK_DID};
%             _ ->
%                 {Day, ?DAILY_CHECK_NOT_DID}
%         end
%     end,
%     DayNum = ?DAY_NUM_MONTH,
%     DayList = lists:sublist((data_checkin:get_daily_list(DailyType)), DayNum),
%     [F(Day) ||Day <- DayList].

refresh_daily_status(OldDailyState, DailyType, Regtime) ->
    case get_first_check_day(OldDailyState) of
        {true, CDay} -> skip;
        false -> CDay = 1
    end,
    {_Month, CurDay} = get_open_server_date(Regtime),
    F = fun(Day) ->
        case lists:keyfind(Day, 1, OldDailyState) of
            {Day, ?DAILY_CHECK_DID} -> {Day, ?DAILY_CHECK_DID};
            {Day, ?DAILY_CHECK_TODAY} -> {Day, ?DAILY_CHECK_TODAY};
            _ ->
                if
                    Day == CDay andalso CDay =< CurDay ->
                        {Day, ?DAILY_CHECK_CAN_CHECK};
                    true ->
                        {Day, ?DAILY_CHECK_NOT_DID}
                end
        end
    end,
    DayNum = ?DAY_NUM_MONTH,
    DayList = lists:sublist((data_checkin:get_daily_list(DailyType)), DayNum),
    [F(Day) ||Day <- DayList].

refresh_daily_after(OldDailyState, DailyType, Regtime, _RetroTimes) ->
    case get_first_check_day(OldDailyState) of
        {true, CDay} -> skip;
        false -> CDay = 1
    end,
    {_Month, CurDay} = get_open_server_date(Regtime),
    % case data_checkin:get_checkin_value(chekin_retro_times) of
    %     [MaxRetroTimes] -> skip;
    %     _ -> MaxRetroTimes = 0
    % end,
    % ?PRINT("CurDay:~p, CDay:~p~n",[CurDay,CDay]),
    F = fun(Day) ->
        case lists:keyfind(Day, 1, OldDailyState) of
            {Day, ?DAILY_CHECK_DID} -> {Day, ?DAILY_CHECK_DID};
            {Day, ?DAILY_CHECK_REWARD_ONCE} ->{Day, ?DAILY_CHECK_REWARD_ONCE};
            {Day, ?DAILY_CHECK_TODAY} -> {Day, ?DAILY_CHECK_TODAY};
            _ ->
                if
                    % Day == CDay andalso CDay =< CurDay andalso RetroTimes < MaxRetroTimes ->
                    Day == CDay andalso CDay =< CurDay ->
                        {Day, ?DAILY_CHECK_CAN_RETRO};
                    % TotalDays < MaxRetroTimes andalso Day == CDay + 1 andalso CDay < CurDay->
                    %     {Day, ?DAILY_CHECK_CAN_RETRO};
                    true ->
                        {Day, ?DAILY_CHECK_NOT_DID}
                end
        end
    end,
    DayNum = ?DAY_NUM_MONTH,
    DayList = lists:sublist((data_checkin:get_daily_list(DailyType)), DayNum),
    [F(Day) ||Day <- DayList].

%% 初始化累计签到状态
refresh_total_status(OldTotalState, TotalType, CheckedDays) ->
    F = fun(Days) ->
        case lists:keyfind(Days, 1, OldTotalState) of
            {Days, ?DAILY_CHECK_DID} -> {Days, ?DAILY_CHECK_DID};
            _ ->
                if
                    Days =< CheckedDays -> {Days, ?DAILY_CHECK_CAN_CHECK};
                    true -> {Days, ?DAILY_CHECK_NOT_DID}
                end
        end
    end,
    [F(Days) || Days <- data_checkin:get_total_list(TotalType)].

empty_checkin_status(Regtime) ->
    % Month = utime:get_month(),
    {Month, _} = get_open_server_date(Regtime),
    #checkin_status{month = Month , total_state = [], daily_state = [] , retroactive_times = 0}.

default_checkin_status(DailyType, TotalType, Month, Regtime) ->
    DefaultTotalState = refresh_total_status([], TotalType, 0),
    DefaultDailyState = refresh_daily_status([], DailyType, Regtime),
    MonthRetroTimes = get_data_cfg(chekin_retro_times),
    #checkin_status{month = Month , total_state = DefaultTotalState, daily_state = DefaultDailyState ,
        retroactive_times = 0, remain_times = MonthRetroTimes}.

get_checkin_days(undefined) -> 0;
get_checkin_days(DailyStateList) when is_list(DailyStateList)->
    F = fun({_, State}, Num) ->
        if State == ?DAILY_CHECK_DID orelse State == ?DAILY_CHECK_TODAY -> Num + 1;
            true -> Num
        end
    end,
    lists:foldl(F, 0, DailyStateList).

%% 根据数据刷新状态
refresh_state([], _InitState, RList) -> RList;
refresh_state([H|L], InitState, RList) ->
	case H of
		{Day, ?GIFT_RECEIVED} ->
			case lists:keyfind(Day, 1, InitState) of
				{Day, _} -> NewRList = lists:keystore(Day, 1, RList, {Day, ?GIFT_RECEIVED});
				_ -> NewRList = RList
			end,
			refresh_state(L, InitState, NewRList);
		_ -> refresh_state(L, InitState, RList)
	end.

change_dailystate(DailyState) ->
    Fun = fun({Day, State}, Acc) ->
        if
            State =:= ?DAILY_CHECK_TODAY ->
                [{Day, ?DAILY_CHECK_DID}|Acc];
            true ->
                [{Day, State}|Acc]
        end
    end,
    New = lists:foldl(Fun, [], DailyState),
    lists:keysort(1,New).

notify_client(PS) ->
    #player_status{sid = Sid, figure = #figure{lv = Lv}, check_in = CheckInSt, reg_time = Regtime, id = RoleId} = PS,
    {_Month, CurDay} = get_open_server_date(Regtime),
    #checkin_status{month = Month, total_state = InitTotalState, daily_state = InitDailyState,
                retroactive_times = RetroTimes, remain_times = RemainTimes} = CheckInSt,
    update_daily_checkin_db(PS, CheckInSt),
    SumCheckedDays = get_checkin_days(InitDailyState),
	CheckDay = mod_daily:get_count(RoleId, ?MOD_WELFARE, 6),
    case data_checkin:get_checkin_type(Lv, Month) of
        [] ->
            ?ERR("checkin cfg err: no such Month cfg exist!{Lv, Month}~p",[{Lv, Month}]),
            {ok, BinData} = pt_417:write(41703, [0, 1, [], [], 1, 0, CurDay, RemainTimes, CheckDay]),
            lib_server_send:send_to_sid(Sid, BinData);
        #base_checkin_type{daily_type = DailyType, total_type = TotalType} ->
            {ok, BinData} = pt_417:write(41703, [SumCheckedDays, TotalType, InitTotalState,
                    InitDailyState, DailyType, RetroTimes, CurDay, RemainTimes, CheckDay]),
            lib_server_send:send_to_sid(Sid, BinData)
    end.
%% --------------  加载动态事件 事件处理 ---------------------------------
%% 升级监听：当升到功能开启等级后移除
add_listener([]) ->
	ok;
add_listener([H|T]) ->
	lib_player_event:add_listener(H, lib_checkin, handle_event, []),
	add_listener(T).

handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{sid = Sid, figure = #figure{lv = Lv}, reg_time = Regtime, id = RoleId} = PS,
    % Month = utime:get_month(),
    {Month, CurDay} = get_open_server_date(Regtime),
    OpenLvCfg = get_open_lv(),
    case Lv >= OpenLvCfg of
        false ->
            {ok, PS};
        true ->
            InitCheckState = get_daily_status(PS),
            #checkin_status{month = Month, total_state = InitTotalState, daily_state = InitDailyState,
                retroactive_times = RetroTimes, remain_times = RemainTimes} = InitCheckState,
            update_daily_checkin_db(PS, InitCheckState),
            SumCheckedDays = get_checkin_days(InitDailyState),
	        CheckDay = mod_daily:get_count(RoleId, ?MOD_WELFARE, 6),
            case data_checkin:get_checkin_type(Lv, Month) of
                [] ->
                    ?ERR("checkin cfg err: no such Month cfg exist!{Lv, Month}~p",[{Lv, Month}]),
                    {ok, BinData} = pt_417:write(41703, [0, 1, [], [], 1, 0, CurDay, RemainTimes, CheckDay]),
                    lib_server_send:send_to_sid(Sid, BinData);
                #base_checkin_type{daily_type = DailyType, total_type = TotalType} ->
                    {ok, BinData} = pt_417:write(41703, [SumCheckedDays, TotalType, InitTotalState,
                            InitDailyState, DailyType, RetroTimes, CurDay, RemainTimes, CheckDay]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end,
            NewPS = PS#player_status{check_in = InitCheckState},
            lib_player_event:remove_listener(?EVENT_LV_UP, lib_checkin, handle_event),
            {ok, NewPS}
    end;
handle_event(PS, #event_callback{type_id = ?EVENT_VIP}) when is_record(PS, player_status) ->
    #player_status{sid = Sid, figure = #figure{lv = Lv, vip = VipLv, vip_type = VipType}, check_in = CheckState, reg_time = Regtime, id = RoleId} = PS,
    IsChecked = mod_daily:get_count(PS#player_status.id, ?MOD_WELFARE, ?DAILY_CHECKIN_IS_CHECKED),
    % Day = utime:day_of_month(),
    {_Month, Day} = get_open_server_date(Regtime),
    % ?PRINT("@@@@@@@@@@@@@@@@  Day:~p,IsChecked:~p~n",[Day,IsChecked]),
    OpenLvCfg = get_open_lv(),
    case Lv >= OpenLvCfg of
        false ->
            {ok, PS};
        true ->
            #checkin_status{month = Month, total_state = TotalState, daily_state = DailyState,
                retroactive_times = RetroTimes, remain_times = RemainTimes} = CheckState,
            case data_checkin:get_checkin_type(Lv, Month) of
                #base_checkin_type{daily_type = DailyType, total_type = TotalType} -> skip;
                _ ->
                    ?ERR("NO SUCH cfg month :~p",[Month]),
                    TotalType = 1,
                    DailyType = 1
            end,
            Resoult = data_checkin:get_daily_rewards(DailyType,Day),
            IsNeedCheckin = if
                is_record(Resoult, base_checkin_daily_rewards) == true ->
                    #base_checkin_daily_rewards{vip_lv = [{vip_lv, LimitVipLv},{vip_type, LimitVipType}]} = Resoult,
                    if
                        VipLv-1 < LimitVipLv andalso VipLv >= LimitVipLv andalso VipType >= LimitVipType andalso IsChecked == ?DAILY_CHECK_DID ->
                            true;
                        true -> false
                    end;
                true ->
                    false
            end,
            % ?PRINT("IsNeedCheckin:~p,Resoult:~p~n",[IsNeedCheckin,Resoult]),
            case IsNeedCheckin of
                true ->
                    DayList = get_today_checkin_days(DailyState),
                    NewDailyState = get_vip_reward(VipLv, VipType, DailyState, DailyType, DayList),
                    TotalCheckDays = lib_checkin:get_checkin_days(DailyState),
                    % NewDailyState = lists:keyreplace(Day, 1, DailyState, {Day, ?DAILY_CHECK_REWARD_ONCE}),
                    % ?PRINT("NewDailyState:~p~nDailyState:~p~n",[NewDailyState,DailyState]),
	                CheckDay = mod_daily:get_count(RoleId, ?MOD_WELFARE, 6),
                    {ok, BinData} = pt_417:write(41703, [TotalCheckDays, TotalType, TotalState,
                            NewDailyState, DailyType, RetroTimes, Day, RemainTimes, CheckDay]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    NewCheckState = CheckState#checkin_status{is_need_reward = 1,daily_state = NewDailyState};
                false ->
                    NewCheckState = CheckState
            end,
            NewPS = PS#player_status{check_in = NewCheckState},
            {ok, NewPS}
    end;

handle_event(Player, #event_callback{type_id = ?EVENT_ADD_LIVENESS}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, check_in = CheckInSt} = Player,
    Liveness = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY), %%活跃度
    #checkin_status{remain_times = RemainTimes, retroactive_times = RetroTimes} = CheckInSt,
    LimitLiveness = get_data_cfg(liveness_retro_times),
    AddTimes = get_data_cfg(liveness_add_retro_times),
    MaxRetroTimes = get_data_cfg(max_retro_time),
    LivenessAddTimes = mod_daily:get_count(RoleId, ?MOD_WELFARE, ?DAILY_CHECKIN_IS_ADD),
    if
        LivenessAddTimes < 1 andalso Liveness >= LimitLiveness andalso RetroTimes < MaxRetroTimes ->
            if
                AddTimes + RemainTimes + RetroTimes =< MaxRetroTimes ->
                    NewRemain = AddTimes + RemainTimes;
                true ->
                    NewRemain = MaxRetroTimes - RetroTimes
            end,
            mod_daily:increment(RoleId, ?MOD_WELFARE, ?DAILY_CHECKIN_IS_ADD),
            NewPS = Player#player_status{check_in = CheckInSt#checkin_status{remain_times = NewRemain}},
            notify_client(NewPS),
            {ok, NewPS};
        true ->
            {ok, Player}
    end;
    % ?PRINT("NewRemain:~p,LimitLiveness:~p,Liveness:~p~n",[NewRemain,LimitLiveness,Liveness]),
    % NewPS = Player#player_status{check_in = CheckInSt#checkin_status{remain_times = NewRemain}},
    % {ok, NewPS};

handle_event(PS, #event_callback{}) ->
    {ok, PS}.

get_vip_reward(_VipLv, _VipType, DailyState, _DailyType, []) -> DailyState;
get_vip_reward(VipLv, VipType, DailyState, DailyType, [H|T]) ->
    case data_checkin:get_daily_rewards(DailyType,H) of
        #base_checkin_daily_rewards{vip_lv = [{vip_lv, LimitVipLv},{vip_type, LimitVipType}]} ->
            if
                LimitVipLv =/= 0 andalso VipLv >= LimitVipLv andalso VipType >= LimitVipType ->
                    NewDailyState = lists:keystore(H, 1, DailyState, {H, ?DAILY_CHECK_REWARD_ONCE}),
                    get_vip_reward(VipLv, VipType, NewDailyState, DailyType, T);
                true ->
                    get_vip_reward(VipLv, VipType, DailyState, DailyType, T)
            end;
        _ ->
            get_vip_reward(VipLv, VipType, DailyState, DailyType, T)
    end.

get_today_checkin_days(DailyState) ->
    Fun = fun({Day, State}, Acc) ->
        if
            State =:= ?DAILY_CHECK_TODAY ->
                [Day|Acc];
            true ->
                Acc
        end
    end,
    lists:foldl(Fun,[], DailyState).
%% -------------------------------- 每天0点 刷新 ---------------------------------
refresh_midnight(_DelaySec) ->
    util:rand_time_to_delay(1000, lib_checkin, refresh_midnight, []).

refresh_midnight()->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [refresh_mon_checkin_state(E#ets_online.id)|| E <- OnlineRoles].

refresh_mon_checkin_state(PlayerId) ->
	lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_checkin, midnight_refresh, []).

midnight_refresh(PS) ->
    % Month = utime:get_month(),
    {Month, CurDay} = get_open_server_date(PS#player_status.reg_time),
    #player_status{sid = Sid, figure = #figure{lv = Lv}, check_in = CheckInSt, id = RoleId} = PS,
    OpenLvCfg = get_open_lv(),
    if
        Lv < OpenLvCfg -> {ok, PS};
        is_record(CheckInSt, checkin_status) == false -> {ok, PS};
        true ->
            NewCheckState = get_daily_status(CheckInSt, PS#player_status.figure#figure.lv, PS#player_status.reg_time),
            #checkin_status{total_state = TotalState, daily_state = DailyState, retroactive_times = RetroTimes,
                remain_times = RemainTimes} = NewCheckState,
            TotalDays = get_checkin_days(DailyState),
	        CheckDay = mod_daily:get_count(RoleId, ?MOD_WELFARE, 6),
            case data_checkin:get_checkin_type(Lv, Month) of
                [] ->
                    ?ERR("checkin cfg err: no such Month cfg exist!{Lv, Month}:~p",[{Lv, Month}]),
                    {ok, BinData} = pt_417:write(41703, [0, 1, [], [], 1, 0, CurDay, RemainTimes, CheckDay]),
                    lib_server_send:send_to_sid(Sid, BinData);
                #base_checkin_type{daily_type = DailyType, total_type = TotalType} ->
                    {ok, BinData} = pt_417:write(41703, [TotalDays, TotalType, TotalState, DailyState, DailyType,
                            RetroTimes, CurDay, RemainTimes, CheckDay]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end,
            NewPS = PS#player_status{check_in = NewCheckState},
            {ok, NewPS}
    end.

get_daily_status(CheckInSt, PlayerLv, Regtime) when is_record(CheckInSt, checkin_status) ->
    % Month = utime:get_month(),
    {Month, _} = get_open_server_date(Regtime),
    #checkin_status{month = OldMonth, total_state = OldTState, daily_state = OldDState, retroactive_times = OldRet} = CheckInSt,
    case data_checkin:get_checkin_type(PlayerLv, Month) of
        [] -> empty_checkin_status(Regtime);
        #base_checkin_type{daily_type = DailyType, total_type = TotalType}->
            case Month == OldMonth of
                true ->
                    DailyState = refresh_daily_status(OldDState, DailyType, Regtime),
                    TotalState = refresh_total_status(OldTState, TotalType, get_checkin_days(DailyState)),
                    CheckInSt#checkin_status{month = Month, total_state = TotalState, daily_state = DailyState, retroactive_times = OldRet};
                _ ->
                    DailyState = refresh_daily_status([], DailyType, Regtime),
                    TotalState = refresh_total_status([], TotalType, get_checkin_days(DailyState)),
                    #checkin_status{month = Month, total_state = TotalState, daily_state = DailyState, retroactive_times = 0}
            end
    end.

%% -------------------------------- 领取礼包 -------------------------------------
receive_gift(PS, Day, IsRetroactive) ->
    #player_status{id = RoleId,
        figure = #figure{lv = PlayerLv},
        vip = #role_vip{vip_lv = PlayerVipLv, vip_type = PlayerVipType},
        reg_time = Regtime,
        check_in = #checkin_status{
                daily_state = DailyState,
                is_need_reward = IsNeedReward,
                retroactive_times = RetroTimes,
                remain_times = RemainTimes}
    } = PS,   % 之前有vip到期时间
    IsChecked = mod_daily:get_count(RoleId, ?MOD_WELFARE, ?DAILY_CHECKIN_IS_CHECKED),
    if
        IsChecked == ?DAILY_CHECK_NOT_DID ->
            CallbackData = #callback_join_act{type = ?MOD_WELFARE, subtype = ?WELFARE_DAILY_CHECKIN},
            {ok, NewPs1} = lib_player_event:dispatch(PS, ?EVENT_JOIN_ACT, CallbackData),
            {ok, NewPs} = lib_achievement_api:check_in_event(NewPs1, []);
        true ->
            NewPs = PS
    end,
%%    NowTime = utime:unixtime(),
    % Month = utime:get_month(),
    IsNeedOnce = need_reward_once(Day, DailyState),
    {Month, _} = get_open_server_date(Regtime),
    case data_checkin:get_checkin_type(PlayerLv, Month) of                    %% 根据等级获得对应签到类型和奖励倍数
        [] ->
            {false, ?ERRCODE(err417_level_illegal), NewPs};
        #base_checkin_type{daily_type = DailyType} ->
            case data_checkin:get_daily_rewards(DailyType, Day) of            %% 根据签到类型和日期获得奖励内容
                [] ->
                    {false, ?ERRCODE(err417_not_set_match_rewards), NewPs};
                #base_checkin_daily_rewards{rewards = Rewards, vip_lv = [{vip_lv, LimitVipLv},{vip_type, LimitVipType}], vip_multiple = VipMultiple} ->
                    if
                        IsNeedReward =:= 1 andalso IsNeedOnce == true ->
                            RewardL = if
                                PlayerVipLv >= LimitVipLv, LimitVipLv =/= 0, PlayerVipType >= LimitVipType->
                                    {[{GoodsType, Id, Num * (VipMultiple - 1)} || {GoodsType, Id, Num} <- Rewards],[]};
                                true ->
                                    % [{GoodsType, Id, Num} || {GoodsType, Id, Num} <- Rewards]
                                    {[],[]}
                            end,
                            {ExtraR, Reward} = RewardL,
                            CheckList = [{check_cell_enougth, ExtraR++Reward}];
                        true ->
                            % if
                            %     IsRetroactive == ?DAILY_CHECK_RETRO ->
                            %         RewardL = Rewards;
                            %     true ->
                            RewardL = if
                                PlayerVipLv >= LimitVipLv, LimitVipLv =/= 0, PlayerVipType >= LimitVipType->
                                    {[{GoodsType, Id, Num * (VipMultiple - 1)} || {GoodsType, Id, Num} <- Rewards],
                                        [{GoodsType, Id, Num} || {GoodsType, Id, Num} <- Rewards]};
                                true ->
                                    {[],[{GoodsType, Id, Num} || {GoodsType, Id, Num} <- Rewards]}
                            end,
                            % ?PRINT("RewardL:~p~n",[RewardL]),
                            % end,
                            {ExtraR, Reward} = RewardL,
                            CheckList = [
                                {check_retro_times, RetroTimes, IsRetroactive},
                                {check_day_is_valid, Day, IsRetroactive},
                                {check_is_checked, IsChecked, Day, IsRetroactive},
                                {check_remain_times, RemainTimes, IsRetroactive},
                                {check_lv_is_valid, PlayerLv},
                                {check_cell_enougth, ExtraR++Reward}]
                    end,
                    % RewardL = if
                    %     PlayerVipLv >= VipLv, VipLv =/= 0-> [{GoodsType, Id, Num * VipMultiple} || {GoodsType, Id, Num} <- Rewards];
                    %     true -> [{GoodsType, Id, Num} || {GoodsType, Id, Num} <- Rewards]
                    % end,
                    % CheckList = [
                    %     {check_day_is_valid, Day, IsRetroactive},
                    %     {check_is_checked, IsChecked, Day, IsRetroactive},
                    %     {check_lv_is_valid, PlayerLv},
                    %     {check_cell_enougth, RewardL}
                    % ],
                    case check_receive_gift(NewPs, CheckList) of
                        {true, NewPS} ->
                            receive_gift_do(NewPS, Day, RewardL, IsRetroactive);
                        {false, Res} ->
                            {false, Res, NewPs}
                    end
            end
    end.

%% 处理秘籍请求
handle_cheats(PS, Day, CheckinType) ->
%%    NowTime = utime:unixtime(),
    % Month = utime:get_month(),
    {Month, _} = get_open_server_date(PS#player_status.reg_time),
    #player_status{vip = #role_vip{vip_lv = PlayerVipLv, vip_type = VipType},     % 之前有vip到期时间
    figure = #figure{lv = PlayerLv}} = PS,
    #base_checkin_type{daily_type = DailyType} = data_checkin:get_checkin_type(PlayerLv, Month),
    case data_checkin:get_daily_rewards(DailyType, Day) of
        [] -> PS;
        #base_checkin_daily_rewards{rewards = Rewards, vip_lv = [{vip_lv, LimitVipLv},{vip_type, LimitVipType}], vip_multiple = VipMultiple} ->
            RewardL = if
                PlayerVipLv >= LimitVipLv, LimitVipLv =/= 0, VipType >= LimitVipType->
                    {[{GoodsType, Id, Num * (VipMultiple - 1)} || {GoodsType, Id, Num} <- Rewards],
                        [{GoodsType, Id, Num} || {GoodsType, Id, Num} <- Rewards]};
                true ->
                    {[],[{GoodsType, Id, Num} || {GoodsType, Id, Num} <- Rewards]}
            end,
            case receive_gift_do(PS, Day, RewardL, CheckinType) of
                {true, NewPS, RewardL} ->
                    {ExtraR, Reward} = RewardL,
                    {ok, BinData} = pt_417:write(41704, [?SUCCESS, Reward, ExtraR]),
                    lib_server_send:send_to_sid(NewPS#player_status.sid, BinData),
                    {ok, NewPS1} = lib_player_event:dispatch(NewPS, ?EVENT_CHECK_IN),
                    {ok, NewPS1};
                {false, Res, NewPS} ->
                    {ok, BinData} = pt_417:write(41704, [Res,[],[]]),
                    lib_server_send:send_to_sid(NewPS#player_status.sid, BinData),
                    {ok, NewPS}
            end
    end.

receive_gift_do(PS, Day, RewardL, IsRetroactive) ->
    #player_status{check_in = CheckInSt, id = RoleId} = PS,
    #checkin_status{retroactive_times = RetroTimes} = CheckInSt,
    if
        IsRetroactive == ?DAILY_CHECK_RETRO ->
            case retro_cost(PS, RetroTimes) of
                {true, CostPS} ->
                    send_rewards(CostPS, Day, RewardL, RetroTimes + 1, IsRetroactive);
                {false, Res, FailPS} ->
                    {false, Res, FailPS}
            end;
        IsRetroactive == ?DAILY_CHECK_S ->
            send_rewards(PS, Day, RewardL, RetroTimes, IsRetroactive);
        true ->
	        TotalCheckDays = mod_daily:get_count(RoleId, ?MOD_WELFARE, 6),
%%	        ?MYLOG("cym", "Day , TotalCheckDays ~p~n", [{Day, TotalCheckDays}]),
	        ?IF(TotalCheckDays == 0, mod_daily:set_count(RoleId, ?MOD_WELFARE, 6, Day), skip),
            send_rewards(PS, Day, RewardL, RetroTimes, IsRetroactive)
    end.

send_rewards(PS, Day, RewardL, NewRetroTimes, IsRetroactive) ->
    #player_status{
        figure = #figure{lv = PlayerLv},
        id = RoleId,
        sid = Sid,
        check_in = CheckInSt,
        vip = #role_vip{vip_lv = VipLv},
        reg_time = Regtime
    } = PS,
    #checkin_status{total_state = TotalState, daily_state = DailyState, remain_times = RemainTimes} = CheckInSt,
    % NDailyState = lists:keystore(Day, 1, DailyState, {Day, ?GIFT_RECEIVED}),%%由已签到改为今日已签到
    case lists:keyfind(Day, 1, DailyState) of
        {Day, State} when State == ?DAILY_CHECK_TODAY ->
            NDailyState = lists:keystore(Day, 1, DailyState, {Day, ?GIFT_RECEIVED});
        _ ->
            NDailyState = lists:keystore(Day, 1, DailyState, {Day, ?DAILY_CHECK_TODAY})
    end,
    {Month, CurDay} = get_open_server_date(Regtime),
    #base_checkin_type{daily_type = DailyType, total_type = TotalType} = data_checkin:get_checkin_type(PlayerLv, Month),
    NewDailyState = refresh_daily_after(NDailyState, DailyType, Regtime, NewRetroTimes),
    % Month = utime:get_month(),
    TotalDays = get_checkin_days(NewDailyState),
    NewTotalState = refresh_total_status(get_checked_status(TotalState), TotalType, TotalDays),
    RetroCheckInSt = CheckInSt#checkin_status{
        daily_state = NewDailyState,
        total_state = NewTotalState,
        retroactive_times = NewRetroTimes,
        remain_times = RemainTimes,
        is_need_reward = refresh_need_reward_once_state(NewDailyState)
    },
    % 更新数据库数据
    update_daily_checkin_db(PS, RetroCheckInSt),
    {ExtraR, Reward} = RewardL,
    log_daily_checkin(RoleId, VipLv, IsRetroactive, Day, ExtraR++Reward),
    NewPS = lib_goods_api:send_reward(PS, ExtraR++Reward, daily_checkin, 0),
    case IsRetroactive =:= ?DAILY_CHECK orelse IsRetroactive =:= ?DAILY_CHECK_S of
        true -> mod_daily:increment(RoleId, ?MOD_WELFARE, ?DAILY_CHECKIN_IS_CHECKED);
        false -> skip
    end,
	CheckDay = mod_daily:get_count(RoleId, ?MOD_WELFARE, 6),
    {ok, BinData} = pt_417:write(41703, [TotalDays, TotalType, NewTotalState, NewDailyState, DailyType,
            NewRetroTimes, CurDay, RemainTimes, CheckDay]),
    lib_server_send:send_to_sid(Sid, BinData),
    NewPS1 = NewPS#player_status{check_in = RetroCheckInSt},
    {true, NewPS1, RewardL}.

refresh_need_reward_once_state(DailyState) ->
    Fun = fun({_, State}) ->
        State =:= ?DAILY_CHECK_REWARD_ONCE
    end,
    case ulists:find(Fun, DailyState) of
        {ok, _}->
            1;
        _ ->
            0
    end.

need_reward_once(Day, DailyState) ->
    case lists:keyfind(Day, 1, DailyState) of
        {Day, State} when State =:= ?DAILY_CHECK_REWARD_ONCE ->
            true;
        _ ->
            false
    end.

%% 获取累计签到物品
receive_total_gift(PS, TotalDays) ->
    #player_status{
        figure = #figure{lv = Lv},
        reg_time = Regtime,
        check_in = #checkin_status{total_state = TotalState, daily_state = DailyState}} = PS,
    % Month = utime:get_month(),
    {Month, _} = get_open_server_date(Regtime),
    case data_checkin:get_checkin_type(Lv, Month) of
        [] -> {false, ?ERRCODE(err417_total_level_illegal), PS};
        #base_checkin_type{total_type = TotalType} ->
            case data_checkin:get_total_rewards(TotalType, TotalDays) of
                [] -> {false, ?ERRCODE(err417_total_typedays_not_match), PS};
                #base_checkin_total_rewards{rewards = Rewards} ->
                    CheckList = [
                        {check_total_gift, Rewards},
                        {check_lv_is_valid, Lv},
                        {check_receive_day_valid, TotalDays, DailyState},
                        {check_total_gift_received, TotalDays, TotalState},
                        {check_cell_enougth, Rewards}
                    ],
                    case checklist(CheckList, PS) of
                        {true, CheckPS} ->
                            receive_total_gift_do(CheckPS, TotalDays, Rewards);
                        {false, Res} ->
                            {false, Res, PS}
                    end
            end
    end.

receive_total_gift_do(PS, Days, RewardL) ->
	#player_status{id = RoleId, sid = Sid, check_in = CheckInSt, reg_time = Regtime} = PS,
	#checkin_status{total_state = TotalState, daily_state = DailyState, retroactive_times = RetroTimes,
        remain_times = RemainTimes} = CheckInSt,
	% 发放礼品
	NewPS = lib_goods_api:send_reward(PS, RewardL, total_checkin, 0),
	NewTotalState = lists:keystore(Days, 1, TotalState, {Days, ?GIFT_RECEIVED}),
	NewCheckInSt = CheckInSt#checkin_status{total_state = NewTotalState},
    update_daily_checkin_db(NewPS, NewCheckInSt),
    log_total_checkin(RoleId, Days, RewardL),
    TotalDays = get_checkin_days(DailyState),
    % Month = utime:get_month(),
    {Month, CurDay} = get_open_server_date(Regtime),
    case data_checkin:get_checkin_type(PS#player_status.figure#figure.lv, Month) of
        #base_checkin_type{daily_type = DailyType, total_type = TotalType} -> skip;
        _ ->
            ?ERR("NO SUCH cfg month :~p",[Month]),
            DailyType = 1,
            TotalType = 1
    end,
	CheckDay = mod_daily:get_count(RoleId, ?MOD_WELFARE, 6),
	{ok, BinData} = pt_417:write(41703, [TotalDays, TotalType, NewTotalState, DailyState, DailyType,
            RetroTimes, CurDay, RemainTimes, CheckDay]),
    lib_server_send:send_to_sid(Sid, BinData),
	NewPS1 = NewPS#player_status{check_in = NewCheckInSt},
	{true, NewPS1, RewardL}.

get_checked_status(AllStatus) ->
    Filter = fun({_, V}) -> V =:= ?GIFT_RECEIVED orelse V =:= ?DAILY_CHECK_TODAY end,
    lists:filter(Filter, AllStatus).

%% 重置签到
gm_refresh_state(PS) ->
    % Month = utime:get_month(),
    {Month, CurDay} = get_open_server_date(PS#player_status.reg_time),
    RemainTimes = get_data_cfg(chekin_retro_times),
    IsChecked = mod_daily:get_count(PS#player_status.id, ?MOD_WELFARE, ?DAILY_CHECKIN_IS_CHECKED),
    if
        IsChecked == ?DAILY_CHECK_NOT_DID -> skip;
        true ->
            mod_daily:set_count(PS#player_status.id, ?MOD_WELFARE, ?DAILY_CHECKIN_IS_CHECKED, ?DAILY_CHECK_NOT_DID)
    end,
	CheckDay = mod_daily:get_count(PS#player_status.id, ?MOD_WELFARE, 6),
    case data_checkin:get_checkin_type(PS#player_status.figure#figure.lv, Month) of
        #base_checkin_type{daily_type = DailyType, total_type = TotalType} ->
            DailyState = refresh_daily_status([], DailyType, PS#player_status.reg_time),
            TotalState = refresh_total_status([], TotalType, get_checkin_days(DailyState)),
            NewCheckState = #checkin_status{month = Month, total_state = TotalState,
                daily_state = DailyState, retroactive_times = 0, remain_times = RemainTimes},
            TotalDays = get_checkin_days(DailyState),
            {ok, BinData} = pt_417:write(41703, [TotalDays, TotalType, TotalState, DailyState,
                    DailyType, 0, CurDay, RemainTimes, CheckDay]);
        _ ->
            ?ERR("NO SUCH cfg month :~p",[Month]),
            NewCheckState = #checkin_status{month = Month, total_state = [], daily_state = [],
                retroactive_times = 0, remain_times = RemainTimes},
            {ok, BinData} = pt_417:write(41703, [0, 1, [], [], 1, 0, CurDay, RemainTimes, CheckDay])
    end,
    lib_server_send:send_to_sid(PS#player_status.sid, BinData),
    %?PRINT("Month:~p,CurDay:~p,RemainTimes:~p~n",[Month,CurDay,RemainTimes]),
    update_daily_checkin_db(PS, NewCheckState),
    NewPS = PS#player_status{check_in = NewCheckState},
    {ok, NewPS}.


%% 重置签到
gm_refresh_daily_state(PS) ->
    % Month = utime:get_month(),
    {Month, CurDay} = get_open_server_date(PS#player_status.reg_time),
    RemainTimes = get_data_cfg(chekin_retro_times),
    IsChecked = mod_daily:get_count(PS#player_status.id, ?MOD_WELFARE, ?DAILY_CHECKIN_IS_CHECKED),
    if
        IsChecked == ?DAILY_CHECK_NOT_DID -> skip;
        true ->
            mod_daily:set_count(PS#player_status.id, ?MOD_WELFARE, ?DAILY_CHECKIN_IS_CHECKED, ?DAILY_CHECK_NOT_DID)
    end,
    #player_status{check_in =  OldCheckState} = PS,
    #checkin_status{daily_state = OldDaily} = OldCheckState,
	CheckDay = mod_daily:get_count(PS#player_status.id, ?MOD_WELFARE, 6),
    case data_checkin:get_checkin_type(PS#player_status.figure#figure.lv, Month) of
        #base_checkin_type{daily_type = DailyType, total_type = TotalType} ->
            DailyState = refresh_daily_status([], DailyType, PS#player_status.reg_time),
            NewCheckState = OldCheckState#checkin_status{month = Month,
                daily_state = DailyState},
            TotalDays = get_checkin_days(DailyState),
            {ok, BinData} = pt_417:write(41703, [TotalDays, TotalType, OldCheckState#checkin_status.total_state, DailyState,
                DailyType, 0, CurDay, RemainTimes, CheckDay]);
        _ ->
            ?ERR("NO SUCH cfg month :~p",[Month]),
            NewCheckState = #checkin_status{month = Month, total_state = [], daily_state = [],
                retroactive_times = 0, remain_times = RemainTimes},
            {ok, BinData} = pt_417:write(41703, [0, 1, [], [], 1, 0, CurDay, RemainTimes, CheckDay])
    end,
    lib_server_send:send_to_sid(PS#player_status.sid, BinData),
    %?PRINT("Month:~p,CurDay:~p,RemainTimes:~p~n",[Month,CurDay,RemainTime s]),
    update_daily_checkin_db(PS, NewCheckState),
    NewPS = PS#player_status{check_in = NewCheckState},
    {ok, NewPS}.

gm_set_player_regtime(PS, Flag, Num) -> %%设置玩家注册时间设为原来注册时间多少天之后（仅仅修改内存）
    NowTime = utime:unixtime(),
    #player_status{id = Id, reg_time = RegTime} = PS,
    if
        Flag == 0 ->
            NewRegTime = RegTime + Num * ?ONE_DAY_SECONDS;
        Flag == 1 ->
            NewRegTime = RegTime - Num * ?ONE_DAY_SECONDS;
        true ->
            % ?PRINT("Flag:~p,Num:~p~n",[Flag, Num]),
            NewRegTime = RegTime
    end,
    if
        NewRegTime =< NowTime andalso NewRegTime > 0 ->
            CheckState  = get_daily_status(PS),
            SQL = io_lib:format("update `player_login` set `reg_time` = ~p where `id` = ~p", [NewRegTime, Id]),
            db:execute(SQL),
            NewPS = PS#player_status{reg_time = NewRegTime, check_in = CheckState};
        true ->
            NewPS = PS
    end,
    notify_client(NewPS),
    {ok, NewPS}.

%% 秘籍界面显示的天数
gm_for_read(RegTime) ->
    {Month, Day} = get_open_server_date(RegTime),
    (Month-1)*30+Day.

%%读取KV表数据
get_data_cfg(Key) ->
    case data_checkin:get_checkin_value(Key) of
        [Value] ->
            Value;
        _ ->
            Value = 0
    end,
    Value.

%% 获得当前可补签次数
% get_can_retro_times(RetroTimes, Liveness) ->
%     MaxRetroTimes = get_data_cfg(max_retro_time),
%     MonthRetroTimes = get_data_cfg(chekin_retro_times),
%     LimitLiveness = get_data_cfg(liveness_retro_times),
%     AddTimesLiveness = get_data_cfg(liveness_add_retro_times),
%     if
%         RetroTimes < MaxRetroTimes ->

%     end



get_open_server_date(Regtime) ->
    NowTime = utime:unixtime(),
    % case util:is_merge_game() of
    %     true ->
    %         Day = util:get_merge_day(NowTime);
    %     false ->
    %         Day = util:get_open_day(NowTime)
    % end,
    Temp = utime:diff_days(NowTime, Regtime),
    % if
    %     Temp == 0 ->
    %         Day = 1;
    %     true ->
            Day = Temp+1,
    % end,
    get_date(Day).

get_date(Day) ->
    if
        (Day rem ?DAY_NUM_MONTH) == 0 ->
            if
                Day rem (?DAY_NUM_MONTH * ?MONTH_NUM_YEAR) == 0 ->
                    RealMon = 1;
                true ->
                    RealMon = (Day div ?DAY_NUM_MONTH) rem ?MONTH_NUM_YEAR
            end,
            RealDay = 30;
        true ->
            RealDay = Day rem ?DAY_NUM_MONTH,
            Mon = (Day div ?DAY_NUM_MONTH + 1) rem ?MONTH_NUM_YEAR,
            if
                Mon == 0 ->
                    RealMon = 12;
                true ->
                    RealMon = Mon
            end
    end,
    {RealMon,RealDay}.

%% 获取第一个可以签到的天数
get_first_check_day(DailyState) ->
    NewDailyState = lists:reverse(DailyState),
    Fun = fun({_Day, State}) ->
        State == ?DAILY_CHECK_DID orelse State == ?DAILY_CHECK_TODAY
    end,
    case ulists:find(Fun, NewDailyState) of
        {ok,{Day, _}} ->
            {true,Day + 1};
        _ ->
            false
    end.
%% 获取第一个可以补签的天数
get_first_retro_day(PS) when is_record(PS, player_status) ->
    #player_status{check_in = CheckInSt} = PS,
    #checkin_status{daily_state = DailyState} = CheckInSt,
    get_retro_day(DailyState).

get_retro_day(DailyState) ->
    NewDailyState = lists:keysort(1, DailyState),
    Fun = fun({_Day, State}) ->
        State == ?DAILY_CHECK_CAN_RETRO
    end,
    case ulists:find(Fun, NewDailyState) of
        {ok,{Day, _}} ->
            {true,Day};
        _ ->
            false
    end.

%% -----------------------------  DB 操作 ------------------------------------
update_daily_checkin_db(PS, CheckInSt) ->
	#player_status{id = RoleId} = PS,
	#checkin_status{month = Month, total_state = TotalState, daily_state = DailyState, retroactive_times = RetTimes, remain_times = RemainTimes} = CheckInSt,
    FilteredTotalState = get_checked_status(TotalState),
    FilteredDailyState = get_checked_status(DailyState),
	TotalState_B = util:term_to_bitstring(FilteredTotalState),
    DailyState_B = util:term_to_bitstring(FilteredDailyState),
	Sql = io_lib:format(<<"replace into daily_checkin set player_id=~p, month=~p, total_state='~s', daily_state = '~s', retroactive_times = ~p, remain_times = ~p">>,
                        [RoleId, Month, TotalState_B, DailyState_B, RetTimes, RemainTimes]),
	db:execute(Sql).

get_daily_checkin_db(RoleId) ->
	Sql = io_lib:format(<<"select month, total_state, daily_state, retroactive_times, remain_times from daily_checkin where player_id = ~p ">>, [RoleId]),
	db:get_row(Sql).

%% -------------------------- 检查函数 -----------------------------------
check_receive_gift(PS, CheckList) ->
	case checklist(CheckList, PS) of
		{true, NewPS} -> {true, NewPS};
        {false, Res} -> {false, Res}
    end.

retro_cost(PS, RetroTimes) ->
    case data_checkin:get_retro_cost(RetroTimes+1) of
        [] ->
            {true, PS};
        #base_checkin_daily_retroactive{money_type = MoneyType, price = Num} ->
            case lib_goods_api:cost_object_list_with_check(PS, [{MoneyType, 0, Num}], retro_checkin, "") of
                {true, NewPS} ->
                    {true, NewPS};
                {false, Res, _} ->
                    {false, Res, PS}
            end
    end.
%% 检查补签次数是否足够
check_receive_list({check_remain_times, RemainTimes, IsRetroactive}, PS) ->
    %?PRINT("RemainTimes:~p~n",[RemainTimes]),
    #player_status{check_in = CheckInSt} = PS,
    case IsRetroactive of
        ?DAILY_CHECK ->
            {true, PS};
        ?DAILY_CHECK_S ->
            {true, PS};
        _ -> %%补签
            if
                RemainTimes >= 1 ->
                    NewPS = PS#player_status{check_in = CheckInSt#checkin_status{remain_times = RemainTimes - 1}},
                    {true, NewPS};
                true ->
                    {false, ?ERRCODE(err417_retro_times_not_enougth)}
            end
    end;

%% 检查签到日是否为当天
check_receive_list({check_day_is_valid, Day, IsRetroactive}, PS) ->
    % {{_, _, CurDay}, _} = calendar:local_time(),
    % {_Month, CurDay} = get_open_server_date(PS#player_status.reg_time),
    #player_status{check_in = CheckInSt} = PS,
    #checkin_status{daily_state = DailyState} = CheckInSt,
    case get_first_check_day(DailyState) of
        {true, CurDay} -> skip;
        false -> CurDay = 1
    end,
    % ?PRINT("Day:~p,CurDay:~p,IsRetroactive:~p~n",[Day,CurDay,IsRetroactive]),
%%    ?MYLOG("cym", "DailyState ++++++++++++++++ ~p ~n", [DailyState]),
%%    ?MYLOG("cym", "CurDay ++++++++++++++++ ~p ~n", [CurDay]),
    case IsRetroactive of
        ?DAILY_CHECK ->
            if
                Day == CurDay -> {true, PS};
                true -> {false, ?ERRCODE(err417_checkin_day_not_current)}
            end;
        ?DAILY_CHECK_S ->
            {true, PS};
        _ -> %%补签
            Res = get_first_retro_day(PS),
            % ?PRINT("Res:~p,Day:~p~n",[Res,Day]),
            case Res of
                {true, CanRetroDay} ->
                    if
                        Day == CanRetroDay  ->
                            {true, PS};
                        true ->
                            {false, ?ERRCODE(err417_cannot_retro_fulture_day)}
                    end;
                false ->
                    {false, ?ERRCODE(err417_no_retro_day)}
            end
            % if
            %     Day =< CurDay -> {true, PS};
            %     true -> {false, ?ERRCODE(err417_cannot_retro_fulture_day)}
            % end
    end;

%% 检查签到日是否为允许补签或签到的日期
check_receive_list({check_day_is_valid, Day}, PS) ->
    % {{_, _, CurDay}, _} = calendar:local_time(),
    {_Month, CurDay} = get_open_server_date(PS#player_status.reg_time),
    if
        Day =< CurDay -> {true, PS};
        true -> {false, ?ERRCODE(err417_checkin_day_illegal)}
    end;

%% 检查是否已经签到过
check_receive_list({check_is_checked, IsChecked, Day, IsRetroactive}, PS) ->
    % ?PRINT("IsChecked:~p,Day:~p,IsRetroactive:~p~n",[IsChecked, Day, IsRetroactive]),
    case IsRetroactive of
        ?DAILY_CHECK ->
        	if
        		IsChecked == ?DAILY_CHECK_NOT_DID -> {true, PS};
        		true ->  {false, ?ERRCODE(err417_checkin_today_has_checked)}
        	end;
        ?DAILY_CHECK_S ->
            IsCn = lib_vsn:is_cn(),
            if
                IsChecked == ?DAILY_CHECK_DID, not IsCn -> {true, PS};
                true ->  {false, ?ERRCODE(err417_checkin_today_has_checked)}
            end;
        _ ->
            #checkin_status{daily_state = DailyState} = PS#player_status.check_in,
            case lists:keyfind(Day, 1, DailyState) of
                {Day, ?DAILY_CHECK_DID} ->  {false, ?ERRCODE(err417_checkin_today_has_checked)};
                {Day, ?DAILY_CHECK_TODAY} ->  {false, ?ERRCODE(err417_checkin_today_has_checked)};
                _ ->  {true, PS}
            end
    end;

%% 检查补签次数是否达到上限
check_receive_list({check_retro_times, RetroTimes, IsRetroactive}, PS) ->
    %?PRINT("RetroTimes:~p~n",[RetroTimes]),
    case IsRetroactive of
        ?DAILY_CHECK ->
            {true, PS};
        ?DAILY_CHECK_S ->
            {true, PS};
        _ ->
            case data_checkin:get_checkin_value(max_retro_time) of
                [MaxRetroTimes] ->
                    if
                        RetroTimes < MaxRetroTimes ->
                            {true, PS};
                        true ->
                            {false, ?ERRCODE(err417_checkin_retro_limit)}
                    end;
                _ ->
                    ?ERRCODE(err417_checkin_kvcfg_error)
            end
    end;

%% 检查累计签到天数是否达到要求
check_receive_list({check_receive_day_valid, TotalDays, DailyState}, PS) ->
	case TotalDays =< get_checkin_days(DailyState) of
		false -> {false, ?ERRCODE(err417_daily_illeagal_day)};
		true -> {true, PS}
	end;
%% 检查是否达到开启签到功能等级
check_receive_list({check_lv_is_valid, Lv}, PS) ->
    OpenLvCfg = get_open_lv(),
	case Lv >= OpenLvCfg of
		true -> {true, PS};
		false -> {false, ?ERRCODE(err417_not_reach_open_lv)}
	end;
%% 检查奖励配置是否正确
check_receive_list({check_total_gift, TotalReward}, PS) ->
	case is_list(TotalReward) of
		true -> {true, PS};
		false -> {false, ?ERRCODE(err417_total_rewards_empty)}
	end;
%% 检查累计签到奖励是否已经领取
check_receive_list({check_total_gift_received, TotalDays, TotalState}, PS) ->
	case lists:keyfind(TotalDays, 1, TotalState) of
		{_, ?GIFT_NOT_RECEIVED} -> {true, PS};
        {_, ?DAILY_CHECK_CAN_CHECK} -> {true, PS};
		_ -> {false, ?ERRCODE(err417_checkin_gift_has_received)}
	end;
%% 检查背包空间是否足够
check_receive_list({check_cell_enougth, Rewards}, PS) ->
    case lib_goods_api:can_give_goods(PS, Rewards) of
        true -> {true, PS};
        {false, ErrorCode} -> {false, ErrorCode}
    end;
check_receive_list(_CheckType, _PS) ->
    {false, ?ERRCODE(err417_illegal_check)}.


checklist([], PS) -> {true, PS};
checklist([H|T], PS) ->
    case check_receive_list(H, PS) of
        {true, NewPS} -> checklist(T, NewPS);
        {false, Res} -> {false, Res}
    end.

log_daily_checkin(RoleId, VipLv, IsRetroactive, Day, RewardL) ->
	lib_log_api:log_daily_checkin(RoleId, VipLv, IsRetroactive, Day, RewardL).

log_total_checkin(RoleId, Days, RewardL) ->
    lib_log_api:log_total_checkin(RoleId, Days, RewardL).

get_open_lv() ->
    case data_checkin:get_checkin_value(checkin_open_lv) of
        [OpenLv] when is_integer(OpenLv) -> OpenLv;
        _ -> 1
    end.


get_checkin_today(DailyState) ->
	case lists:keyfind(?DAILY_CHECK_TODAY, 2, lists:reverse(DailyState)) of
		{Day, _} ->
			Day;
		_ ->
			0
	end.