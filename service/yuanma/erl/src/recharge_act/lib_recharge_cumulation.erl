%%-----------------------------------------------------------------------------
%% @Module  :       lib_recharge_cumulation.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-01-17
%% @Description:    累充活动
%%-----------------------------------------------------------------------------

-module (lib_recharge_cumulation).
-include ("def_event.hrl").
-include ("rec_event.hrl").
-include ("custom_act.hrl").
-include("predefine.hrl").
-include ("server.hrl").
-include ("common.hrl").
-include ("recharge_act.hrl").
-include ("errcode.hrl").
-include ("def_module.hrl").
-include ("figure.hrl").
-include ("goods.hrl").
-include ("def_fun.hrl").


-export ([
    handle_event/2
    ,login/1
    ,receive_reward/3
    ,get_reward_state/3
    , gm_day_push_forward/1
    ,update/1
    ,update_daily/1
    ,do_update_daily/1
]).

login(Player) ->
    #player_status{id = RoleId, recharge_act_status = RechargeActStatus} = Player,
    SQL = io_lib:format("SELECT `subtype`, `id`, `time`, `state`, `info` FROM `recharge_cumulation_reward` WHERE `player_id` = ~p", [RoleId]),
    All = db:get_all(SQL),
    CycleTimeList =   %%[{SubType,  Time}]
    case lib_custom_act_util:get_subtype_list(?CUSTOM_ACT_TYPE_DAILY_CHARGE) of
        [] ->
            [];
        SubTypeList ->
            mod_counter:get_count_offline(RoleId, ?MOD_RECHARGE_ACT, ?MOD_RECHARGE_ACT_CUMULATION, SubTypeList)
    end,
    Cumulation0 = lists:foldl(fun
        ({SubType, Time}, Map)  when Time > 0 ->
            Map#{{cycle_time, SubType} => Time};
        (_, Map) -> Map
    end, #{}, CycleTimeList),
    {ForgotList1, NewAll, DeleList, {FixSubType, FixTime}} = change_act(RoleId, All, Cumulation0),
    Cumulation1 =
        case maps:get({cycle_time, FixSubType}, Cumulation0, 0) of
            0 ->
                case FixTime =/= 0 of
                    true ->
                        mod_counter:set_count_offline(RoleId, ?MOD_RECHARGE_ACT, ?MOD_RECHARGE_ACT_CUMULATION, FixSubType, FixTime),
                        Cumulation0#{{cycle_time, FixSubType} => FixTime};
                    _ ->
                        Cumulation0
                end;
            _ ->
                Cumulation0

        end,

    ZeroTime = utime:standard_unixdate(),  %%当天0点
    {Cumulation, ForgotList, InvailableList, IsFix} = init_data(Cumulation1, NewAll, ZeroTime, [], [], 0),
    {FixCumulation, FixForgotList, FixDeleList} = fix(RoleId, IsFix, Cumulation),
%%    ?MYLOG("cym", "Cumulation0 ~p ~n Cumulation ~p   ForgotList ~p InvailableList ~p~n", [Cumulation0, Cumulation, ForgotList, InvailableList]),
    ForgotListN = FixForgotList ++ ForgotList1 ++ ForgotList,
    send_forgot_rewards(RoleId, ForgotListN),
    delete_forgot_list(RoleId,FixDeleList ++ DeleList ++ InvailableList ++ ForgotListN),
    Player#player_status{recharge_act_status = RechargeActStatus#recharge_act_status{cumulation = FixCumulation}}.

fix(RoleId, IsFix, Cumulation) ->
    case IsFix of
        1 ->
            F = fun(K, V, {Acc, ForgotList, DeleList}) ->
                case K of
                    {reward, SubType, Id} ->
                        {Time, State, Info} = V,
                        #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType, Id),
                        case lists:keyfind(type, 1, Condition) of
                            {type, 2} ->
                                case State of
                                    2 ->
                                        {Acc, ForgotList, [[SubType, Id] | DeleList]};
                                    _ ->
                                        {Acc, [[SubType, Id, Info, Time] | ForgotList], DeleList}
                                end;
                            _ ->
                                {Acc#{K => V}, ForgotList, DeleList}
                        end;
                    {cycle_time,SubType} ->
                        mod_counter:set_count_offline(RoleId, ?MOD_RECHARGE_ACT, ?MOD_RECHARGE_ACT_CUMULATION, SubType, utime:unixdate()),
                        {Acc#{K => utime:unixdate()}, ForgotList, DeleList}
                end end,
            {CumulationN, ForgotListN, DeleListN} = maps:fold(F, {#{}, [], []}, Cumulation),
            {CumulationN, ForgotListN, DeleListN};
        _ ->
            {Cumulation, [], []}
    end.

%% 子活动切换时对旧子活动数据进行处理
change_act(RoleId, All, Cumulation) ->
    Type = ?CUSTOM_ACT_TYPE_DAILY_CHARGE,
    case lib_custom_act_util:get_open_subtype_list(Type) of
        [#act_info{key = {_, SubType}} | _] ->
            #custom_act_cfg{condition =Condition1} = lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType),
            {_, OldSubtype} = ulists:keyfind(old_subtype, 1, Condition1, {old_subtype, 0}),
            case OldSubtype =/= 0 of
                true ->
                    CycleTime = maps:get({cycle_time, OldSubtype}, Cumulation, 0),
                    {ForgotList, NewList, DeleList, {SubType, StartTime}} = do_change_act(All, RoleId, OldSubtype, SubType, [], [], [], CycleTime),
                    {ForgotList, NewList, DeleList, {SubType, ?IF(CycleTime =/= 0, CycleTime, StartTime)}};
                _ ->
                    {[], All, [], {SubType, 0}}
            end;
        _ ->
            {[], All, [], {0, 0}}
    end.

do_change_act([], _RoleId, _OldSubtype, SubType, ForgotList, NewList, DeleList, StartTime) -> {ForgotList, NewList, DeleList, {SubType, StartTime}};
do_change_act([[OldSubtype, Id, Time, State, InfoStr]|All], RoleId, OldSubtype, SubType, ForgotList, NewList, DeleList, StartTime) ->
    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, OldSubtype, Id) of
        #custom_act_reward_cfg{condition = Condition} ->
            case lists:keyfind(type, 1, Condition) of
                %% 周期领取 两次触发最后一个类型为2的奖励之间为1周期
                {type, 2} ->
                    #custom_act_cfg{condition = Condition1} = lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, OldSubtype),
                    {_, IsClear} = ulists:keyfind(is_clear, 1, Condition1, {is_clear, 0}),
                    case IsClear of
                        0 ->    % 不清理，将旧子类型活动数据转换成新活动接着使用
                            NewStartTime =
                                if
                                    StartTime == 0 -> Time;
                                    true -> min(Time, StartTime)
                                end,
                            save_reward_status(RoleId, SubType, Id, Time, State, util:bitstring_to_term(InfoStr)),
                            do_change_act(All, RoleId, OldSubtype, SubType, ForgotList, [[SubType, Id, Time, State, InfoStr] | NewList], [[OldSubtype, Id, InfoStr, Time] | DeleList], NewStartTime);
                        1 ->    % 清理，将旧子类型活动数据清除掉
                            case State =/= 2 of % 还没领奖
                                true ->
                                    do_change_act(All, RoleId, OldSubtype, SubType, [[OldSubtype, Id, util:bitstring_to_term(InfoStr), Time] | ForgotList], NewList, DeleList, StartTime);
                                _ ->
                                    do_change_act(All, RoleId, OldSubtype, SubType, ForgotList, NewList, [[OldSubtype, Id, InfoStr, Time] | DeleList], StartTime)
                            end
                    end;
                _ ->
                    do_change_act(All, RoleId, OldSubtype, SubType, ForgotList, [[OldSubtype, Id, Time, State, InfoStr] | NewList], DeleList, StartTime)
            end;
        _ ->
            do_change_act(All, RoleId, OldSubtype, SubType, ForgotList, [[OldSubtype, Id, Time, State, InfoStr] | NewList], DeleList, StartTime)
    end;
do_change_act([[Subtype1, Id, Time, State, InfoStr]|All], RoleId, OldSubtype, SubType, ForgotList, NewList, DeleList, StartTime) ->
    do_change_act(All, RoleId, OldSubtype, SubType, ForgotList, [[Subtype1, Id, Time, State, InfoStr] | NewList], DeleList, StartTime).


%% 返回当前的累充数据、忘记领取奖励但已经失效的数据、已经领奖并且已经失效的数据
init_data(Cumulation, [[SubType, Id, Time, State, InfoStr]|All], ZeroTime, ForgotList, InvailableList, IsFix) ->
    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType, Id) of
        #custom_act_reward_cfg{condition = Condition} ->
            Info = util:bitstring_to_term(InfoStr),
            case lists:keyfind(type, 1, Condition) of
                %% 每日领取 
                {type, 1} ->
                    if
                        %%已经过时
                        Time < ZeroTime ->
                            if
                                % 还没领奖
                                State =/= 2 ->
                                    init_data(Cumulation, All, ZeroTime, [[SubType, Id, Info, Time]|ForgotList], InvailableList, IsFix);
                                % State为0时在之前的实现中也代表可领取，主要是为了兼容之前的旧数据
                                true ->
                                    init_data(Cumulation, All, ZeroTime, ForgotList, [[SubType, Id]|InvailableList], IsFix)
                            end;
                        %% 未过期
                        true ->
                            NewCumulation = Cumulation#{{reward, SubType, Id} => {Time, State, Info}},
                            init_data(NewCumulation, All, ZeroTime, ForgotList, InvailableList, IsFix)
                    end;
                %% 周期领取 两次触发最后一个类型为2的奖励之间为1周期
                {type, 2} ->
                    CycleTime = maps:get({cycle_time, SubType}, Cumulation, 0),
                    NowTime = utime:unixtime(),
                    if
                        %% 已经有周期 并且已经过期
                        CycleTime > 0 andalso  Time < CycleTime ->
                            if
                                % 过期
                                NowTime >= CycleTime ->
                                    if 
                                        % 还没领取
                                        State =/= 2 ->
                                            init_data(Cumulation, All, ZeroTime, [[SubType, Id, Info, Time]|ForgotList], InvailableList, IsFix);
                                        % State为0时在之前的实现中也代表可领取，主要是为了兼容之前的旧数据
                                        true ->
                                            init_data(Cumulation, All, ZeroTime, ForgotList, [[SubType, Id]|InvailableList], IsFix)
                                    end;
                                % 当前还没有到下一次的更新点，说明还没过期，那么什么都不做
                                true ->
                                    NewCumulation = Cumulation#{{reward, SubType, Id} => {Time, State, Info}},
                                    init_data(NewCumulation, All, ZeroTime, ForgotList, InvailableList, IsFix)
                            end;
                        %% 还没过期
                        true ->
                            case lists:keyfind(cycle, 1, Condition) of
                                % 每轮的最后一个累充可领说明新的一轮将从明日开始
                                {cycle, _} ->
                                    NewCumulation = Cumulation#{{reward, SubType, Id} => {Time, State, Info}},
                                    init_data(NewCumulation, All, ZeroTime, ForgotList,  InvailableList, 1);
                                _ ->
                                    NewCumulation = Cumulation#{{reward, SubType, Id} => {Time, State, Info}},
                                    init_data(NewCumulation, All, ZeroTime, ForgotList,  InvailableList, IsFix)
                            end
                    end;
                %% 没有活动的配置 当作是失效的
                _ ->
                    init_data(Cumulation, All, ZeroTime, ForgotList, [[SubType, Id]|InvailableList], IsFix)
            end;
        %% 没有活动的配置 当作是失效的
        _ ->
            init_data(Cumulation, All, ZeroTime, ForgotList, [[SubType, Id]|InvailableList], IsFix)
    end;

init_data(Cumulation, [], _ZeroTime, ForgotList, InvailableList, IsFix) -> {Cumulation, ForgotList, InvailableList, IsFix}.

update(#player_status{} = Player) ->
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_DAILY_CHARGE) of
        [#act_info{key = {_, ActSub}}|_] ->
            pp_recharge_act:handle(15955, Player, [ActSub]),
            pp_recharge_act:handle(15956, Player, [ActSub]);
        _ ->
            ok
    end;
update(_) -> ok.

update_daily(#player_status{id = Roleid} = Player) ->
    spawn(fun() ->
            timer:sleep(3000),
            lib_player:apply_cast(Roleid, ?APPLY_CAST_SAVE, lib_recharge_cumulation, do_update_daily, [])
          end),
    Player;
update_daily(PS) ->
    PS.

do_update_daily(Player) ->
    NewPlayer = login(Player),
    update(NewPlayer),
    NewPlayer.

handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE}) ->
    case lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_DAILY_CHARGE) of
        [] ->
            {ok, Player};
        OpenActList ->
            #player_status{recharge_act_status = ActStatus, id = RoleId} = Player,
            #recharge_act_status{cumulation = Cumulation} = ActStatus,
            #player_status{figure = #figure{lv = Lv}} = Player,
            NewCumulation = handle_recharge_act(RoleId, Cumulation, OpenActList, [{lv, Lv}]),
            NewPlayer = Player#player_status{recharge_act_status = ActStatus#recharge_act_status{cumulation = NewCumulation}},
            update(NewPlayer),
            {ok, NewPlayer}
    end;

handle_event(Player, _) -> {ok, Player}.

handle_recharge_act(RoleId, Cumulation, [ActInfo|OpenActList], RewardParam) ->
    NowTime = utime:unixtime(),
    case ActInfo of
%%        % #act_info{stime = Stime, etime = ETime, key = {Type, SubType}, wlv = WLv} when ETime >= NowTime ->
        #act_info{stime = StartTime, etime = ETime, key = {Type, SubType}, wlv = WLv} when (ETime >= NowTime andalso StartTime =< NowTime) ->
            RewardIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
%%            ?PRINT("RewardIds = ~w~n",[RewardIds]),
            ZeroTime = utime:standard_unixdate(),
            CycleTime = maps:get({cycle_time, SubType}, Cumulation, StartTime),
            F = fun
                (Id, Acc) ->
                    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, Id) of
                        #custom_act_reward_cfg{condition = Condition} ->
                            case lists:keyfind(type, 1, Condition) of
                                {type, 1} -> %%
                                    update_reward_status(RoleId, SubType, Id, ZeroTime, 1, Condition, Acc, [{wlv, WLv}|RewardParam], CycleTime);
                                {type, 2} ->
                                    update_reward_status(RoleId, SubType, Id, ZeroTime, 2, Condition, Acc, [{wlv, WLv}|RewardParam], CycleTime);
                                _ ->
                                    Acc
                            end;
                        _ ->
                            Acc
                    end
            end,
            NewCumulation = lists:foldl(F, Cumulation, RewardIds),
            handle_recharge_act(RoleId, NewCumulation, OpenActList, RewardParam);
        _ ->
            handle_recharge_act(RoleId, Cumulation, OpenActList, RewardParam)
    end;

handle_recharge_act(_RoleId, Cumulation, [], _) -> Cumulation.

update_reward_status(RoleId, SubType, Id, Time, Type, Condition, Cumulation, RewardParam, StartTime) ->
    case maps:find({reward, SubType, Id}, Cumulation) of
        % 有记录的不用变
        {ok, {_, _State, _Info}} ->
            Cumulation;
        % 没有记录的进行更新
        _ ->
            CheckTime = ?IF(Type =:= 2, StartTime, Time),
            case check_reward_condition(RoleId, Type, Condition, CheckTime) of
                true ->
                    save_reward_status(RoleId, SubType, Id, Time, 1, RewardParam),
                    case lists:keyfind(cycle, 1, Condition) of
                        % 每轮的最后一个累充可领说明新的一轮将从明日开始
                        {cycle, _} ->
%%                            NewCycleTime = utime:unixdate() + ?ONE_DAY_SECONDS,
                            NewCycleTime = utime:get_diff_day_standard_unixdate(1, 1),
                            mod_counter:set_count_offline(RoleId, ?MOD_RECHARGE_ACT, ?MOD_RECHARGE_ACT_CUMULATION, SubType, NewCycleTime),
                            Cumulation#{{reward, SubType, Id} => {Time, 1, RewardParam}, {cycle_time, SubType} => NewCycleTime};
                        _ ->
                            Cumulation#{{reward, SubType, Id} => {Time, 1, RewardParam}}
                    end;
                _ ->
                    Cumulation
            end
    end.

send_forgot_rewards(RoleId, [[SubType, Id, Info, OldTime]|ForgotList]) ->
    send_forgot_rewards(RoleId, SubType, Id, Info, OldTime),
    send_forgot_rewards(RoleId, ForgotList);

send_forgot_rewards(_RoleId, []) -> ok.

send_forgot_rewards(RoleId, SubType, Id, Info, OldTime) ->
    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType, Id) of
        #custom_act_reward_cfg{condition = Condition} = RewardCfg ->
            RwParam = info_2_rwparam(#reward_param{}, Info),
            case lib_custom_act_util:count_act_reward_last_day(RwParam, RewardCfg, OldTime) of
                [_|_] = RewardList ->
                    case lists:keyfind(gold, 1, Condition) of
                        {gold, Gold} ->
                            case lists:keyfind(type, 1, Condition) of
                                {type, 1} ->
                                    TimeText = utext:get_mm_dd_time_text(OldTime),
                                    Title   = utext:get(290, [Gold]),
                                    Content = utext:get(291, [TimeText, Gold]),
%%                                    ?MYLOG("cym",  "rewardList ~p~n", [RewardList]),
                                    lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList);
                                {type, 2} ->
                                    case lists:keyfind(day, 1, Condition) of
                                        {day, Day} ->
                                            % TimeText = utext:get_mm_dd_time_text(OldTime),
                                            Title   = utext:get(292, [Day, Gold]),
                                            Content = utext:get(293, [Day, Gold]),
%%                                            ?MYLOG("cym",  "rewardList ~p~n", [RewardList]),
                                            lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList);
                                        _ ->
                                            ok %% 配置不对，忽略
                                    end;
                                _ ->
                                    ok %% 配置不对，忽略
                            end;
                        _ ->
                            ok %% 配置不对，忽略
                    end;
                _ ->
                    ok
            end;
        _ ->
            skip %% 配置不对，忽略
    end.

info_2_rwparam(Param, [{lv, Lv}|T]) ->
    info_2_rwparam(Param#reward_param{player_lv = Lv}, T);

info_2_rwparam(Param, [{wlv, WLv}|T]) ->
    info_2_rwparam(Param#reward_param{wlv = WLv}, T);

info_2_rwparam(Param, [_|T]) ->
    info_2_rwparam(Param, T);

info_2_rwparam(Param, []) -> Param.


check_reward_condition(RoleId, 1, Condition, _Time) ->
    TodayGold = lib_recharge_data:get_today_pay_gold(RoleId),
    {gold, Gold} = lists:keyfind(gold, 1, Condition),
    case lists:keyfind(gold, 1, Condition) of
        {gold, Gold} when TodayGold >= Gold ->
            true;
        _ ->
            false
    end;

check_reward_condition(RoleId, 2, Condition, StartTime) ->
%%    ?PRINT("StartTime = ~w~n",[StartTime]),
    NowTime = utime:unixtime(),
%%    ?PRINT("NowTime = ~w~n",[NowTime]),
    if
        StartTime < NowTime ->
            % TodayGold = lib_recharge_data:get_today_pay_gold(RoleId),
            DiffDay = utime:diff_day(StartTime),
%%            ?PRINT("DiffDay = ~w~n",[DiffDay]),
            HistoryList = lib_recharge_data:get_my_daily_recharge_summaries(RoleId, DiffDay),
%%            ?PRINT("HistoryList = ~w~n",[HistoryList]),
            % HistoryListWithToday = [{0, {TodayGold, 0}}|HistoryList],
            case lists:keyfind(gold, 1, Condition) of
                {gold, Gold} ->
                    case lists:keyfind(day, 1, Condition) of
                        {day, Day} ->
                            X = lists:sum([1 || {_, {G, _}} <- HistoryList, G >= Gold]),
                            if
                                X >= Day ->
                                    true;
                                true ->
                                    false
                            end;
                        _ ->
                            false
                    end;
                _ ->
                    false
            end;
        true ->
            false
    end;

check_reward_condition(_RoleId, _, _Condition, _Time) -> false.

receive_reward(Player, SubType, Id) ->
    case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType) of
        #act_info{stime = _STime} = ActInfo ->
            case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType, Id) of
                RewardCfg when is_record(RewardCfg, custom_act_reward_cfg) ->
                    case get_reward_state(Player, ActInfo, RewardCfg) of
                        {?ACT_REWARD_CAN_GET, Time} ->
                            case lib_custom_act_util:count_act_reward_last_day(Player, ActInfo, RewardCfg, Time) of
                                [_|_] = RewardList ->
                                    try_do_receive_reward(Player, RewardList, SubType, Id, Time);
                                _ ->
                                    {false, ?ERRCODE(err331_no_act_reward_cfg)}
                            end;
                        {?ACT_REWARD_HAS_GET, _} ->
                            {false, ?ERRCODE(err331_already_get_reward)};
                        _ ->
                            {false, ?ERRCODE(err331_act_can_not_get)}
                    end;
                _ ->
                    {false, ?ERRCODE(err331_no_act_reward_cfg)}
            end;
        _ ->
            {false, ?ERRCODE(err331_act_closed)}
    end.

try_do_receive_reward(Player, RewardList, SubType, Id, Time) ->
    case lib_goods_api:can_give_goods(Player, RewardList) of
        true ->
            #player_status{id = RoleId, recharge_act_status = RechargeActStatus} = Player,
            #recharge_act_status{cumulation = Cumulation} = RechargeActStatus,
            NewCumulation = Cumulation#{{reward, SubType, Id} => {Time, 2, []}},
            NewRechargeActStatus = RechargeActStatus#recharge_act_status{cumulation = NewCumulation},
            save_reward_status(RoleId, SubType, Id, Time, 2, []),
            lib_log_api:log_custom_act_reward(RoleId, ?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType, Id, RewardList),
            Produce = #produce{type = ac_recharge_cumulation, subtype = SubType, reward = RewardList, remark = integer_to_list(Id)},
            NewPlayer = lib_goods_api:send_reward(Player, Produce),
            NewPlayer2 = NewPlayer#player_status{recharge_act_status = NewRechargeActStatus},
            LastPlayer = lib_demons_api:daily_charge_reward(NewPlayer2, Id),
            {ok, LastPlayer};
        {false, ErrorCode} ->
            {false, ErrorCode}
    end.

%% 改版：之前的过于逆天，导致很多bug
%% 现在只要是内存中已有的，都是正确的领取状态
%% 内存中没有的，说明不能领取
get_reward_state(Player, #act_info{key = {_, SubType}}, #custom_act_reward_cfg{grade = Id}) ->
    #player_status{recharge_act_status = RechargeActStatus} = Player,
    Cumulation = RechargeActStatus#recharge_act_status.cumulation,
    case maps:find({reward, SubType, Id}, Cumulation) of 
        % 兼容旧数据，状态为0时也为可领取状态
        {ok, {Time, State, _}} -> {?IF(State =:= 0, ?ACT_REWARD_CAN_GET, State), Time};
        % {ok, {Time, State, _}} -> {State, Time};
        _ ->
            {0, 0}
    end.
% get_reward_state(Player, #act_info{key = {_, SubType}, stime = STime}, #custom_act_reward_cfg{grade = Id,  condition = Condition}) ->
%     #player_status{recharge_act_status = #recharge_act_status{cumulation = Cumulation}, id = RoleId} = Player,
%     case lists:keyfind(type, 1, Condition) of
%         {type, Type} ->
%             CycleTime = maps:get({cycle_time, SubType}, Cumulation, 0),
%             Time = 
%             if 
%                 Type =:= 1 -> utime:standard_unixdate();
%                 CycleTime =:= 0 -> STime; 
%                 true -> CycleTime 
%             end,
% %%	        ?MYLOG("see", "Cumulation ~p~n", [Cumulation]),
% 	        Now = utime:unixtime(),
%             case maps:find({reward, SubType, Id}, Cumulation) of
%                 {ok, {WhateverTime, 0, _}} ->
%                     {?ACT_REWARD_CAN_GET, WhateverTime};
%                 {ok, {Time, 1, _}}  ->
%                     {?ACT_REWARD_HAS_GET, Time};
%                 {ok, {DiffTime, 1, _}} when Type =:= 2 andalso CycleTime =:= 0 ->
%                     {?ACT_REWARD_HAS_GET, DiffTime};
% 	            {ok, {DiffTime, 1, _}} when Type =:= 2 andalso CycleTime >= Now ->
% 		            {?ACT_REWARD_HAS_GET, DiffTime};
%                 _ ->
%                     case check_reward_condition(RoleId, Type, Condition, Time) of
%                         true ->
%                             {?ACT_REWARD_CAN_GET, Time};
%                         _ ->
%                             {?ACT_REWARD_CAN_NOT_GET, Time}
%                     end
%             end;
%         _ ->
%             {?ACT_REWARD_CAN_NOT_GET, 0}
%     end.

save_reward_status(RoleId, SubType, Id, Time, State, Info) ->
    SQL = io_lib:format("REPLACE INTO `recharge_cumulation_reward` (`player_id`, `subtype`, `id`, `time`, `state`, `info`) VALUES (~p, ~p, ~p, ~p, ~p, '~s')", [RoleId, SubType, Id, Time, State, util:term_to_string(Info)]),
    db:execute(SQL).

delete_forgot_list(_RoleId, []) -> ok;
delete_forgot_list(RoleId, DelList) ->
    Conditions = [io_lib:format("(`subtype`=~p AND `id`=~p)", [SubType, Id]) || [SubType, Id|_] <- DelList],
    ConditionsStr = ulists:list_to_string(Conditions, " OR "),
    SQL = io_lib:format("DELETE FROM `recharge_cumulation_reward` WHERE `player_id`=~p AND (~s)", [RoleId, ConditionsStr]),
    db:execute(SQL).



%%秘籍往前推， 模拟跨天
gm_day_push_forward(Day) ->
%%    ?MYLOG("cym", "Day ~p~n", [Day]),
    Time =  Day * 86400 ,
    SQL = io_lib:format("UPDATE   recharge_cumulation_reward   set  time = time - ~p;", [Time]),
    db:execute(SQL),
    ok.
