%%%------------------------------------
%%% @Module  : lib_activitycalen_mod
%%% @Author  :  xiaoxiang
%%% @Created :  2017-02-05
%%% @Description: 抢旗战场数据进程
%%%------------------------------------

-module(lib_activitycalen_mod).
-include("common.hrl").
-include("activitycalen.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("watchdog.hrl").
-include("predefine.hrl").
-compile(export_all).

-export([

]).

% -define(AC_WAIT, 0).    %% 活动等待
% -define(AC_OPEN, 0).    %% 活动开启
% -define(AC_END, 0).     %% 活动结束

%%% ------------------------------------各个活动定时开启--------------------------------------------------
timer_start_ac(Module, ModuleSub, AcSub) ->  %% 增加日志
    Time = utime:unixtime(),
    %?PRINT("timer_start_ac ,Module:~p , ModuleSub:~p , AcSub:~p ,time:~p ~n ", [Module, ModuleSub, AcSub, calendar:local_time()]),
    catch lib_log_api:log_ac_start(Module, ModuleSub, AcSub, ?LOG_TYPE_AC_START_BY_CALEN, Time),
    case {Module, ModuleSub} of
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_GUARD} ->
            mod_guild_guard:act_start(AcSub);
        {?MOD_TOPPK, _} ->
            lib_top_pk:act_start(AcSub);
        {?MOD_TREASURE_CHEST, _} ->
            mod_treasure_chest:act_start(AcSub);
        {?MOD_NOON_QUIZ, _} ->
            mod_noon_quiz:act_start(AcSub);
        {?MOD_VOID_FAM, _} ->
            mod_void_fam_local:act_start(AcSub);
        {?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE} ->
            lib_activitycalen_api:success_start_activity(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE),
            lib_husong:double_change(AcSub);
        {?MOD_NINE, _} ->
            mod_nine_local:act_start(AcSub);
        % {?MOD_GUILD_BATTLE, _} ->
        %     mod_guild_battle:start_fight();
        {?MOD_SANCTUARY, _} ->
            mod_sanctuary:act_start(AcSub);
        {?MOD_TERRITORY, _} ->
            mod_territory_treasure:start_act();
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY} ->
            mod_guild_feast_mgr:activity_calendar_start();
        {?MOD_MIDDAY_PARTY, _} ->
            mod_midday_party:act_start();
        {?MOD_BEINGS_GATE, _} ->
            lib_beings_gate_api:act_start(ModuleSub, AcSub);
        {?MOD_NIGHT_GHOST, _} ->
            mod_night_ghost_local:act_start(ModuleSub, AcSub);
        _ ->
            skip
    end.

timer_check(State) ->
    %?PRINT("timer_check:~n", []),
    IdList = data_activitycalen:get_ac_list(),
    F = fun
        ({Module, ModuleSub, AcSub}) ->
            BaseAc = data_activitycalen:get_ac(Module, ModuleSub, AcSub),
            lib_subscribe_api:check_subscribe_is_open() andalso lib_activitycalen_util:do_wx_push(BaseAc),
            case lib_activitycalen_util:do_check_ac_sub(BaseAc, [fix_time, week, month, time, region, open_day, merge_day]) of
                true ->
                    timer_start_ac(Module, ModuleSub, AcSub);
                _ ->
                    case lib_activitycalen_util:do_check_ac_sub(BaseAc, [region_end]) of
                        true ->
                            timer_end_ac(Module, ModuleSub, AcSub);
                        _ ->
                            skip
                    end,
                    case lib_activitycalen_util:check_advance(BaseAc) of
                        true ->
                            ac_advance(Module, ModuleSub, AcSub);
                        _ ->
                            skip
                    end
            end
    end,
    lists:foreach(F, IdList),
    State.


timer_end_ac(Module, ModuleSub, _AcSub) ->  %% 无实际开启类活动用
    %?PRINT("timer_start_ac ,Module:~p , ModuleSub:~p , AcSub:~p ,time:~p ~n ", [Module, ModuleSub, AcSub, calendar:local_time()]),
    case {Module, ModuleSub} of
        {?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE} ->
            lib_activitycalen_api:success_end_activity(?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE);
        %lib_husong:double_change(0);
        _ ->
            skip
    end.

%% ----------------------------------------------各个活动开启预告-------------------------------------------------------------
%% 活动开启前xx分钟预告  手动配置data_activitycalen_m:get_advance(Module, ModuleSub) -> Time.
ac_advance(Module, ModuleSub, AcSub) ->
    Time = utime:unixtime(),
    %?PRINT("ac_advance ,Module:~p , ModuleSub:~p , AcSub:~p ,time:~p ~n ", [Module, ModuleSub, AcSub, calendar:local_time()]),
    catch lib_log_api:log_ac_start(Module, ModuleSub, AcSub, ?LOG_TYPE_AC_ADVANCE_BY_CALEN, Time),
    case {Module, ModuleSub} of
        {?MOD_TREASURE_CHEST, _} ->
            lib_chat:send_TV({all}, ?MOD_TREASURE_CHEST, 2, []);
        {?MOD_NOON_QUIZ, _} ->
            mod_noon_quiz:send_advance();
        {?MOD_GUILD_ACT, ?MOD_GUILD_ACT_GUARD} ->
            Minute = data_activitycalen_m:get_advance(Module, ModuleSub),
            lib_chat:send_TV({all}, ?MOD_GUILD_ACT, 19, [Minute]);
        {?MOD_HUSONG, ?MOD_SUB_HUSONG_DOUBLE} ->
            lib_chat:send_TV({all}, ?MOD_HUSONG, 4, []);
        {?MOD_KF_GUILD_WAR, _} ->
            % Minute = data_activitycalen_m:get_advance(Module, ModuleSub),
            case lib_kf_guild_war:is_kf_guild_war_server() of
                true ->
                    lib_chat:send_TV({all}, ?MOD_KF_GUILD_WAR, 1, []);
                _ ->
                    skip
            end;
        % {?MOD_GUILD_BATTLE, _} ->
        %     mod_guild_battle:start_tip();
        {?MOD_MIDDAY_PARTY, _} ->
            lib_midday_party:start_tip();
        _ ->
            skip
    end.

%% 活动结束
success_end_activity(Module, ModuleSub, State) ->
    IdList = data_activitycalen:get_ac_sub(Module, ModuleSub),
    CheckList = [time, week, month, open_day, merge_day],
    AcSub = lib_activitycalen:get_ac_sub_with_end(Module, ModuleSub, IdList, CheckList),
    % ?PRINT("{Module, ModuleSub, AcSub}:~p ~n", [{Module, ModuleSub, AcSub}]),
    catch lib_log_api:log_ac_start(Module, ModuleSub, AcSub, ?LOG_TYPE_AC_END_BY_AC, utime:unixtime()),
    send_15706(Module, ModuleSub, AcSub, ?AC_END),
    #ac_mgr_state{ac_maps = AcMaps} = State,
    NewAcMaps = maps:put({Module, ModuleSub, AcSub}, ?AC_END, AcMaps),
    add_monitor(NewAcMaps),
    State#ac_mgr_state{ac_maps = NewAcMaps}.

%% 活动开启
success_start_activity(Module, ModuleSub, State) ->
    AcSub = lib_activitycalen:get_ac_sub_with_end(Module, ModuleSub),
    %?PRINT("{Module, ModuleSub, AcSub}:~p ~n", [{Module, ModuleSub, AcSub}]),
    catch lib_log_api:log_ac_start(Module, ModuleSub, AcSub, ?LOG_TYPE_AC_START_BY_AC, utime:unixtime()),
    send_15706(Module, ModuleSub, AcSub, ?AC_OPEN),
    #ac_mgr_state{ac_maps = AcMaps} = State,
    NewAcMaps = maps:put({Module, ModuleSub, AcSub}, ?AC_OPEN, AcMaps),
    add_monitor(NewAcMaps),
    State#ac_mgr_state{ac_maps = NewAcMaps}.

gm_end_act_state(Module, ModuleSub, AcSub, State) ->
    catch lib_log_api:log_ac_start(Module, ModuleSub, AcSub, ?LOG_TYPE_AC_END_BY_AC, utime:unixtime()),
    send_15706(Module, ModuleSub, AcSub, ?AC_END),
    #ac_mgr_state{ac_maps = AcMaps} = State,
    NewAcMaps = maps:put({Module, ModuleSub, AcSub}, ?AC_END, AcMaps),
    add_monitor(NewAcMaps),
    State#ac_mgr_state{ac_maps = NewAcMaps}.

add_monitor(AcMaps) ->
    F = fun({Module, ModuleSub, _AcSub}, ActStatus, Acc) when ActStatus ==?AC_OPEN ->
            [{Module, ModuleSub}|Acc];
        (_ActKey, _ActStatus, Acc) -> Acc
    end,
    lib_watchdog_api:add_monitor(?WATCHDOD_OPENNING_ACT_LIST, maps:fold(F, [], AcMaps)),
    ok.

%% 客户端更新
send_act_status(Module, ModuleSub, RoleId, Lv, State) ->
    AcSub = lib_activitycalen:get_ac_sub_with_end(Module, ModuleSub),
    #ac_mgr_state{ac_maps = AcMaps} = State,
    Status = maps:get({Module, ModuleSub, AcSub}, AcMaps, ?AC_END),
    case data_activitycalen:get_ac(Module, ModuleSub, AcSub) of
        #base_ac{start_lv = MinLv, end_lv = MaxLv, ac_type = AcType} ->
            case Lv >= MinLv andalso Lv =< MaxLv of
                true ->
                    lib_server_send:send_to_uid(RoleId, pt_157, 15706, [Module, ModuleSub, AcType, Status]);
                false ->
                    skip
            end;
        _ ->
            skip
    end,
    State.

send_15706(Module, ModuleSub, AcSub, Status) ->
    case data_activitycalen:get_ac(Module, ModuleSub, AcSub) of
        #base_ac{start_lv = MinLv, end_lv = MaxLv, ac_type = ActType} ->
            {ok, Bin} = pt_157:write(15706, [Module, ModuleSub, ActType, Status]),
            lib_server_send:send_to_all(all_lv, {MinLv, MaxLv}, Bin);
        _ ->
            skip
    end.


%% -----------------------init -------------------
init() ->
    #ac_mgr_state{}.

%% 日常界面信息
ask_activity_num(RoleId, Lv, OnHookTime, Type, State) ->
    #ac_mgr_state{ac_maps = AcMaps} = State,
    %%应该是这里控制排序了
    IdList = data_activitycalen:get_ac_list(),
    F = fun({Module, ModuleSub, AcSub}, TempList) ->
        #base_ac{start_lv = StartLv, end_lv = EndLv, ac_type = ActType} = data_activitycalen:get_ac(Module, ModuleSub, AcSub),
        %% 分必做 和 限时类型
        case ActType == Type of
            true ->
                IsOpenDayLimit = is_open_day_limit(Module, ModuleSub, AcSub),
%%                IsWeekTaskAct  = is_week_task_act(Module, ModuleSub, AcSub), %%周任务特殊处理
                if
                    IsOpenDayLimit == true ->
                        TempList;
%%                    IsWeekTaskAct  == true ->
%%                        TempList;
                    true ->
                        case Lv >= StartLv andalso EndLv >= Lv of
                            true ->
                                case Type == ?ACTIVITY_TYPE_DAILY of
                                    true ->
                                        ActStatus = ?AC_OPEN;
                                    _ ->
                                        ActStatus = maps:get({Module, ModuleSub, AcSub}, AcMaps, ?AC_END)
                                end,
                                [{{Module, ModuleSub, ActStatus}, AcSub} | TempList];
                            _ ->    %% 显示即将到达等级段的活动
                                [{{Module, ModuleSub, ?AC_LV_LIMIT}, AcSub} | TempList]
                        end
                end;
            _ ->
                TempList
        end
    end,
    TmpActL = lists:foldl(F, [], IdList),
    F2 = fun({Module, ModuleSub}, TmpL) ->   %%就是转换一下格式
        case lists:keyfind({Module, ModuleSub, ?AC_LV_LIMIT}, 1, TmpActL) of
            {{_, _, _}, TmpActSub} ->
                [{Module, ModuleSub, TmpActSub, ?AC_LV_LIMIT} | TmpL];  %%等级限制
            _ ->
                case lists:keyfind({Module, ModuleSub, ?AC_OPEN}, 1, TmpActL) of
                    {{_, _, _}, TmpActSub} ->
                        [{Module, ModuleSub, TmpActSub, ?AC_OPEN} | TmpL];
                    _ ->
                        case lists:keyfind({Module, ModuleSub, ?AC_END}, 1, TmpActL) of
                            {{_, _, _}, _} ->

                                TmpActSub = lib_activitycalen_util:get_near_act(Module, ModuleSub), %% 未开启的找最靠近的下一个子活动
                                [{Module, ModuleSub, TmpActSub, ?AC_END} | TmpL];
                            _ ->
                                TmpL
                        end
                end
        end
    end,
    _list = [{{_Type, _SubId},  _SubActType} || {_Type, _SubId, _SubActType} <- IdList],
    NewIdlist =[  Key  ||  {Key, _V}<-util:combine_list(_list) ],
    ActList = lists:foldl(F2, [], NewIdlist),
    %% 要请求的计数列表一次call
    TmpL = mod_daily:get_count(RoleId, [{?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, TmpMod * ?AC_LIVE_ADD + TmpModSub} || {TmpMod, TmpModSub, _, _} <- ActList]),
    %% 解析回来模块和子模块
    CountList = [{{TmpType div ?AC_LIVE_ADD, TmpType rem ?AC_LIVE_ADD}, Count} || {{_, _, TmpType}, Count} <- TmpL],
    F3 = fun({Module, ModuleSub, AcSub, ActStatus}, TempList) ->
        CanGetLive = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_NUM, Module * ?AC_LIVE_ADD + ModuleSub),
        case ActStatus of
            ?AC_LV_LIMIT ->
                Value = Live = 0;
            _ ->
                case lib_activitycalen:check_ac_live_day(Module, ModuleSub) of
                    true ->

                        TempValue = case lists:keyfind({Module, ModuleSub}, 1, CountList) of
                            {_, Count} ->
                                Count;
                            _ ->
                                0
                        end,
%%                        Value = min(Max, TempValue),  %% 判断是否达到顶值
                        Value = TempValue,
                        Live = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_YET_GET_NUM, Module * ?AC_LIVE_ADD + ModuleSub);
                    _ ->
                        Value = Live = 0
                end
        end,
        [{Module, ModuleSub, AcSub, Value, Live, CanGetLive, ActStatus} | TempList]
    end,
    Info    = lists:foldl(F3, [], ActList),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_activitycalen, ask_activity_num, [Type, OnHookTime, Info]),
    % lib_server_send:send_to_uid(RoleId, pt_157, 15701, [Type, OnHookTime, Info]),
    State.

send_act_remind(RoleId, Lv, SignUpList, State) ->
    #ac_mgr_state{ac_maps = AcMap, remind_map = RemindMap} = State,
    {IsRemind0, SetTime} = maps:get(RoleId, RemindMap, {1, 0}),
    % 提醒开关状态
    IsRemind =
    case {IsRemind0, utime:is_today(SetTime)} of
        {0, true} -> 0; % 玩家当天关闭提醒开关
        _ -> 1
    end,
    % 活动开启、报名信息
    F = fun({ModId, SubId, SubAc} = ActId, AccL) ->
        #base_ac{start_lv = StartLv, end_lv = EndLv, ac_type = ActType} = data_activitycalen:get_ac(ModId, SubId, SubAc),
        case {ActType, is_open_day_limit(ModId, SubId, SubAc)} of
            {?ACTIVITY_TYPE_TIME, false} ->
                RealAcStatus = maps:get(ActId, AcMap, ?AC_END),
                ActStatus = ?IF(Lv>=StartLv andalso Lv=<EndLv, RealAcStatus, ?AC_LV_LIMIT),
                Time =
                case RealAcStatus of
                    ?AC_OPEN -> % 正在开启的活动获取结束时间
                        case lib_activitycalen:get_act_open_time_region(ModId, SubId, SubAc) of
                            {ok, [_StartTime, EndTime]} -> EndTime;
                            _ -> 0
                        end;
                    _ -> % 未开启的活动获取开启时间
                        lib_activitycalen:get_timestamp(ModId, SubId, SubAc)
                end,
                #sign_up_msg{status = SignUpStatus} = ulists:keyfind(ActId, #sign_up_msg.key, SignUpList, #sign_up_msg{}),
                if
                    ActStatus == ?AC_LV_LIMIT; ActStatus /= ?AC_OPEN, Time == 0 -> AccL; % 当前等级未开放 | 当天没有该活动
                    true -> [{ModId, SubId, SubAc, ActStatus, Time, SignUpStatus} | AccL]
                end;
            _ ->
                AccL
        end
    end,
    ActList = lists:foldl(F, [], data_activitycalen:get_ac_list()),
    % 返回
    lib_server_send:send_to_uid(RoleId, pt_157, 15721, [IsRemind, ActList]),
    ok.

%% 设置玩家提醒开关
set_act_remind(RoleId, _Lv, IsRemind, State) ->
    #ac_mgr_state{remind_map = M} = State,
    NewM = maps:put(RoleId, {IsRemind, utime:unixtime()}, M),
    State#ac_mgr_state{remind_map = NewM}.

%%%% ----------------------------------------------------------------------
send_event_after(OldRef, Time, Event) ->
    util:cancel_timer(OldRef),
    gen_fsm:send_event_after(Time, Event).

db_inset_ac_start(Module, ModuleSub, AcSub) ->
    Sql = io_lib:format(?sql_inset_ac_start, [Module, ModuleSub, AcSub, utime:unixtime()]),
    db:execute(Sql).

db_select_ac_start() ->
    Sql = io_lib:format(?sql_select_ac_start, []),
    db:get_all(Sql).



%%是否受限于开服天数
is_open_day_limit(Module, ModuleSub, AcSub) ->
    #base_ac{open_day = Day} = data_activitycalen:get_ac(Module, ModuleSub, AcSub),
    if
        Day == []-> %%每天都开
            false;
        true ->
            is_open_day_limit(Day)
    end.

is_open_day_limit([]) ->
    true;
is_open_day_limit([{Start, End} | T]) ->
    OpenDay = util:get_open_day(),
    case OpenDay >= Start andalso OpenDay =< End of
        true -> %%开启了
            false;
        false ->
            is_open_day_limit(T)
    end.

%%%%限时活动添加到非限时活动的特殊处理
%%get_other_act(?ACTIVITY_TYPE_DAILY, Info, AcMaps, RoleId) ->
%%    IdList = data_activitycalen:get_ac_list(),
%%    F = fun({M, SubM, SubType}, AccList) ->
%%        Ac = data_activitycalen:get_ac(M, SubM, SubType),
%%        #base_ac{ac_type = AcType} = Ac,
%%        if
%%            AcType == ?ACTIVITY_TYPE_TIME ->
%%                IsOpenDayLimit = is_open_day_limit(M, SubM, SubType),
%%                IsHaveLiveReward = is_have_live_reward(M, SubM),
%%                if
%%                    IsOpenDayLimit == true-> %%开服天数不满足的，不推
%%                        AccList;
%%                    IsHaveLiveReward == false ->  %%没有活跃度奖励的，不推
%%                        AccList;
%%                    true ->
%%                        [{M, SubM, SubType} | AccList]
%%                end;
%%            true ->
%%                AccList
%%        end
%%    end,
%%    OtherAc = lists:foldl(F, [], IdList), %%选出限时活动, 且满足开服天数的，且由活跃度奖励的
%%    F1 = fun({M1, SubM1, SubType1}, AccInfo) ->
%%        AcState    = get_other_ac_right_state(M1, SubM1, SubType1, AcMaps),
%%        ActNum     = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_NUM, M1 * ?AC_LIVE_ADD + SubM1),
%%        CurrLive   = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_YET_GET_NUM, M1 * ?AC_LIVE_ADD + SubM1),
%%        CanGetLive = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_NUM, M1 * ?AC_LIVE_ADD + SubM1),
%%        [{M1, SubM1, SubType1, ActNum, CurrLive, CanGetLive, AcState} | AccInfo]
%%        end,
%%    NewInfo = lists:foldl(F1, Info, OtherAc),
%%%%  ?MYLOG("cym", "NewInfo ~p~n", [NewInfo]),
%%    NewInfo;
%%get_other_act(_, Info, _AcMaps, _RoleId) ->
%%    Info.

get_other_ac_right_state(M, SubM, SubType, _AcMaps) ->
%%  AcState    = maps:get({M, SubM, SubType}, AcMaps, ?AC_END),
    Ac = data_activitycalen:get_ac(M, SubM, SubType),
    CheckList = [time, week, month, open_day, merge_day, time_region],
    case lib_activitycalen_util:do_check_ac_sub(Ac, CheckList) of
        true ->
            ?AC_OPEN;
        _ ->
            ?AC_END
    end.

%% 活动是否有活跃度奖励
is_have_live_reward(M, SubM) ->
    #ac_liveness{live = Live} = data_activitycalen:get_live_config(M, SubM),
    Live > 0.

is_week_task_act(?MOD_TASK, ?week_task, _AcSub) ->
    true;
is_week_task_act(_, _, _) ->
    false.

%% 返回 [{Module, ModuleSub, AcSub, Value, Live, CanGetLive, ActStatus}]
get_week_task_info(RoleId, Lv, ?ACTIVITY_TYPE_DAILY) ->
    IdList = data_activitycalen:get_ac_sub(?MOD_TASK, ?week_task),
    Module = ?MOD_TASK,
    ModuleSub = ?week_task,
    #ac_liveness{max = Max} = data_activitycalen:get_live_config(Module, ModuleSub),
    F = fun(AcSub, TempList) ->
        #base_ac{start_lv = StartLv, end_lv = EndLv, ac_type = _ActType} = data_activitycalen:get_ac(Module, ModuleSub, AcSub),
        IsOpenDayLimit = is_open_day_limit(Module, ModuleSub, AcSub),
        if
            IsOpenDayLimit == true ->
                TempList;
            true ->
                case Lv >= StartLv andalso EndLv >= Lv of
                    true ->
                        _Value = mod_week:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_WEEK_NUM),
                        Value = min(_Value, Max),
                        [{Module, ModuleSub, AcSub, Value, 0, 0, ?AC_OPEN} | TempList];
                    _ ->    %% 显示即将到达等级段的活动

                        [{Module, ModuleSub, AcSub, 0, 0, 0, ?AC_LV_LIMIT}| TempList]
                end
        end
    end,
    lists:foldl(F, [], IdList);
get_week_task_info(_RoleId, _Lv, _) ->
    [].