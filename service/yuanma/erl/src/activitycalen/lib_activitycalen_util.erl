%%%--------------------------------------
%%% @Module  : lib_activitycalen_util
%%% @Author  : xiaoxiang
%%% @Created : 2017-03-01
%%% @Description:  lib_activitycalen
%%%--------------------------------------
-module(lib_activitycalen_util).
-export([

    ]).
-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("activitycalen.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("def_fun.hrl").
-include("wx.hrl").
%% 玩家活动开启判断
do_check_ac(_Player, BaseAc, []) when is_record(BaseAc, base_ac) -> true;
do_check_ac(Player, BaseAc, [H|T]) when is_record(BaseAc, base_ac) ->
    case do_check_ac_help(Player, BaseAc, H) of
        true ->
            do_check_ac(Player,BaseAc, T);
        _R ->
            % ?PRINT("H:~p  _R:~p  ~n", [H, _R]),
            false
    end;
do_check_ac(_Player, _BaseAc, _) -> false.

do_check_ac_help(_Player, BaseAc, daily) ->
    #base_ac{ac_type = AcType} = BaseAc,
    AcType == ?ACTIVITY_TYPE_DAILY;

do_check_ac_help(_Player, BaseAc, open_day) ->
    #base_ac{open_day = OpenDay} = BaseAc,
    Now = util:get_open_day(),
    case OpenDay of
        [] ->
            true;
        OpenDay when is_list(OpenDay) ->
            OpenDayList = [Now||{Start, End} <- OpenDay, Now >= Start, Now =< End],
            lists:member(Now, OpenDayList);
        _ ->
            false
    end;


do_check_ac_help(_Player, BaseAc, merge_day) ->
    #base_ac{merge_day = MergeDay, type=Type} = BaseAc,
    Now = util:get_merge_day(),
    case MergeDay of
        [] ->
            Type == 1 orelse Now == 0;
        MergeDay when is_list(MergeDay) ->
            MergeDayList = [Now||{Start, End}<-MergeDay, Now>=Start, Now=<End],
            lists:member(Now, MergeDayList);
        _ ->
            false
    end;

do_check_ac_help(Player, BaseAc, lv) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    #base_ac{start_lv = StartLv, end_lv = EndLv} = BaseAc,
    (Lv>=StartLv andalso Lv=<EndLv) orelse (StartLv==EndLv andalso EndLv ==0);

do_check_ac_help(_Player, _BaseAc, _) ->
    false.



do_check_ac_sub(BaseAc,  []) when is_record(BaseAc, base_ac) -> true;
do_check_ac_sub(BaseAc,  [H|T]) when is_record(BaseAc, base_ac)->
    case do_check_ac_sub_help(BaseAc, H) of
        true ->
            do_check_ac_sub(BaseAc, T);
        _ ->
            false
    end;
do_check_ac_sub(_BaseAc,  _) -> false.

%% fix_time: 是否为定时活动，
%% 1.设定了时间段
%% 2.是设定了定时触发活动
do_check_ac_sub_help(BaseAc, fix_time) ->
    #base_ac{time_region = TimeRegion, other=Other} = BaseAc,
    TimeRegion /= [] orelse lists:keyfind(timer_trigger, 1, Other) /= false;

%%  格式：[1,2,3,4,5,6,7] ，7表示星期天 []默认为每天都开
do_check_ac_sub_help(BaseAc, week) ->
    #base_ac{week = Week} = BaseAc,
    WeekDay = utime:logic_day_of_week(),
    case Week of
        [] ->
            true;
        Week when is_list(Week) ->
            lists:member(WeekDay, Week);
        _ ->
            false
    end;

do_check_ac_sub_help(BaseAc, week_advance) ->
    #base_ac{week = Week} = BaseAc,
    WeekDay = utime:logic_day_of_week()+1,
    case Week of
        [] ->
            true;
        Week when is_list(Week) ->
            lists:member(WeekDay, Week);
        _ ->
            false
    end;


%%  格式：[1,2,28], 勿填>28的数字（程序容错，>28时不开启） []默认为每天都开
do_check_ac_sub_help(BaseAc, month) ->
    #base_ac{month = Month} = BaseAc,
    {{_NowY,_NowM,NowD},_} = utime:get_logic_time(),
    case Month of
        [] ->
            true;
        Month when is_list(Month) ->
            lists:member(NowD, Month);
        _ ->
            false
    end;

do_check_ac_sub_help(BaseAc, month_advance) ->
    #base_ac{month = Month} = BaseAc,
    {{_NowY,_NowM,NowD},_} = utime:get_logic_time(),
    case Month of
        [] ->
            true;
        Month when is_list(Month) ->
            lists:member(NowD+1, Month);
        _ ->
            false
    end;

%% %%  格式：[{2017,3,11}]，[] 默认为每天都开
do_check_ac_sub_help(BaseAc, time) ->
    #base_ac{time = Time} = BaseAc,
    {{NowY,NowM,NowD} = NowDay, _} = utime:get_logic_time(),
    case Time of
        [] ->
            true;
        Time when is_list(Time) ->
            TimeList = [NowDay||{Y,M,D}<-Time,Y == NowY, M == NowM, D == NowD],
            lists:member(NowDay, TimeList);
        _ ->
            false
    end;


%% 跨天预告采用
do_check_ac_sub_help(BaseAc, time_advance) ->
    #base_ac{time = Time} = BaseAc,
    {NowDay, _} = utime:get_logic_time(),
    {NowY,NowM,NowD} = utime:get_before_day(NowDay, 1, 1),
    case Time of
        [] ->
            true;
        Time when is_list(Time) ->
            TimeList = [NowDay||{Y,M,D}<-Time,Y == NowY, M == NowM, D == NowD],
            lists:member(NowDay, TimeList);
        _ ->
            false
    end;

%%  格式：[{{开始时间},{结束时间}},{{}}]；如[{{20,0},{20,30}}] 非定时活动固定填[]
%% 准时活动开启
do_check_ac_sub_help(BaseAc, region) ->
    #base_ac{time_region = TimeRegion} = BaseAc,
    {_NowDay, {NowH,NowM,_}} = calendar:local_time(),
    % Now = utime:unixtime({NowDay, {NowH,NowM,0}}),
    case TimeRegion of
        [] ->
            true;
        TimeRegion when is_list(TimeRegion) ->
            TimeList=[{NowH,NowM}||{{H,M},_}<-TimeRegion, H==NowH, M==NowM],
            lists:member({NowH,NowM}, TimeList);
        _ ->
            false
    end;
%% 到点结束
do_check_ac_sub_help(BaseAc, region_end) ->
    #base_ac{time_region = TimeRegion} = BaseAc,
    {_, {NowH,NowM,_}} = calendar:local_time(),
    % Now = utime:unixtime({NowDay, {NowH,NowM,0}}),
    case TimeRegion of
        [] -> false;
        TimeRegion when is_list(TimeRegion) ->
            TimeList=[{NowH,NowM}||{_,{H,M}}<-TimeRegion, H == NowH, M == NowM],
            lists:member({NowH,NowM}, TimeList);
        _ -> false
    end;


%%  格式：[{{开始时间},{结束时间}},{{}}]；如[{{20,0},{20,30}}] 非定时活动固定填[]
%% 活动是否在开启时间区间内（不含结束时间）
do_check_ac_sub_help(BaseAc, time_region) ->
    #base_ac{time_region = TimeRegion, module = Module} = BaseAc,
    {_NowDay, {NowH,NowM,_}} = calendar:local_time(),
    % Now = utime:unixtime({NowDay, {NowH,NowM,0}}),
    case TimeRegion of
        [] ->
            true;
        TimeRegion when is_list(TimeRegion) ->
            if
                Module == ?MOD_SANCTUARY->
                    TimeList=[{NowH,NowM}||{{SH,SM},{EH,EM}}<-TimeRegion, NowH > SH orelse (NowH =:= SH andalso NowM >= SM),
                        NowH < EH orelse (NowH =:= EH andalso NowM < EM) orelse (SH > EH) orelse (SH =:= EH andalso SM > EM)],
                    lists:member({NowH,NowM}, TimeList);
                true ->
                    TimeList=[{NowH,NowM}||{{SH,SM},{EH,EM}}<-TimeRegion, NowH > SH orelse (NowH =:= SH andalso NowM >= SM), NowH < EH orelse (NowH =:= EH andalso NowM < EM)],
                    lists:member({NowH,NowM}, TimeList)
            end;
        _ ->
            false
    end;

%%  格式：[{{开始时间},{结束时间}},{{}}]；如[{{20,0},{20,30}}] 非定时活动固定填[]
%% 活动是否在配置时间区间内（包含结束时间）
do_check_ac_sub_help(BaseAc, time_region_loose) ->
    #base_ac{time_region = TimeRegion} = BaseAc,
    {_NowDay, {NowH,NowM,_}} = calendar:local_time(),
    % Now = utime:unixtime({NowDay, {NowH,NowM,0}}),
    case TimeRegion of
        [] ->
            true;
        TimeRegion when is_list(TimeRegion) ->
            TimeList=[{NowH,NowM}||{{SH,SM},{EH,EM}}<-TimeRegion, NowH > SH orelse (NowH =:= SH andalso NowM >= SM), NowH < EH orelse (NowH =:= EH andalso NowM =< EM)],
            lists:member({NowH,NowM}, TimeList);
        _ ->
            false
    end;


%%  格式：[{开服开始天数，结束天数},{}];如[{1,20},{50,100}],[]默认每天都开
do_check_ac_sub_help(BaseAc, open_day) ->
    #base_ac{open_day = OpenDay} = BaseAc,
    Now = util:get_open_day(),
    case OpenDay of
        [] ->
            true;
        OpenDay when is_list(OpenDay) ->
            OpenDayList = [Now||{Start, End}<-OpenDay, Now>=Start, Now=<End],
            lists:member(Now, OpenDayList);
        _ ->
            false
    end;
%% 跨天预告采用
do_check_ac_sub_help(BaseAc, open_day_advance) ->
    #base_ac{open_day = OpenDay} = BaseAc,
    Now = util:get_open_day()+1,
    case OpenDay of
        [] ->
            true;
        OpenDay when is_list(OpenDay) ->
            OpenDayList = [Now||{Start, End}<-OpenDay, Now>=Start, Now=<End],
            lists:member(Now, OpenDayList);
        _ ->
            false
    end;

%% 活动日历规则 type为0 []为单服，合服必须填具体内容  如果合服[]也为满足，则会出现[]和[{1,2}]出现冲突
%% 充值活动规则 type为1 为充值活动规则 []全满足
do_check_ac_sub_help(BaseAc, merge_day) ->
    #base_ac{merge_day = MergeDay, type=Type} = BaseAc,
    Now = util:get_merge_day(),
    case MergeDay of
        [] ->
            Type == 1 orelse Now == 0;
        MergeDay when is_list(MergeDay) ->
            MergeDayList = [Now||{Start, End}<-MergeDay, Now>=Start, Now=<End],
            lists:member(Now, MergeDayList);
        _ ->
            false
    end;
%% 跨天预告采用
do_check_ac_sub_help(BaseAc, merge_day_advance) ->
    #base_ac{merge_day = MergeDay, type=Type} = BaseAc,
    Now = util:get_merge_day(),
    case MergeDay of
        [] ->
            Type == 1 orelse Now == 0;
        MergeDay when is_list(MergeDay) ->
            MergeDayList = [Now||{Start, End}<-MergeDay, Now+1>=Start, Now+1=<End],
            lists:member(Now, MergeDayList);
        _ ->
            false
    end;
 %% 时间范围有效 [{start_timestamp, end_timestamp}|...] 开始时间戳，结束时间戳  时间戳属于区间则生效 []默认满足
do_check_ac_sub_help(BaseAc, timestamp) ->
    #base_ac{start_timestamp=StartTimestamp, end_timestamp=EndTimeStamp, timestamp = TimeStamp} = BaseAc,
    LastTimeStamp = case StartTimestamp>0 orelse EndTimeStamp>0 of
        true ->
            case is_list(TimeStamp) of
                true ->
                    [{StartTimestamp, EndTimeStamp}|TimeStamp];
                _ ->
                    TimeStamp
            end;
        _ ->
            TimeStamp
    end,
    Now = utime:unixtime(),
    case LastTimeStamp of
        [] ->
            true;
        LastTimeStamp when is_list(LastTimeStamp) ->
            TimeStampList = [Now||{Start, End}<-LastTimeStamp, Now>=Start, Now=<End+5*60],
            lists:member(Now, TimeStampList);
        _ ->
            false
    end;

%% 检查是否到了微信推送的时间
%% 方法若返回true，则说明已经发送微信推送
do_check_ac_sub_help(BaseAc, push_time) ->
    #base_ac{time_region = TimeRegion, module = Module} = BaseAc,
    {_NowDay, {NowH,NowM,_}} = calendar:local_time(),
    % NowH = 20, NowM = 20,
    NowTime = utime:unixtime(),
    case TimeRegion of
        [] ->
            false;
        TimeRegion when is_list(TimeRegion) ->
            ReadyTime = ?WX_KV_SUBSCRIBE_BEFORE_TIME * ?ONE_MIN,
            TimeList = [
                Region
             || {{H, M}, _} = Region <- TimeRegion,
                ((H - NowH) * ?ONE_HOUR_SECONDS + (M - NowM) * ?ONE_MIN) == ReadyTime
            ],
            case TimeList of
                [] -> false;
                [{{H, M}, {EH, EM}}] ->
                    OpenTime = NowTime + ReadyTime,
                    DurTime = (EH - H) * ?ONE_HOUR_SECONDS + (EM - M) * ?ONE_MIN,
                    EndTime = OpenTime + DurTime,
                    % 注:现在402公会活动模块只有公会晚宴,所以先由公会晚宴占用,如后续402模块有其它新活动加入,需要后续再做处理
                    lib_subscribe_api:send_subscribe_of_act(Module, OpenTime, EndTime),
                    true
            end;
        _ ->
            false
    end;

%% 跨天预告采用
do_check_ac_sub_help(BaseAc, timestamp_advance) ->
    #base_ac{module=Module, module_sub=ModuleSub, start_timestamp=StartTimestamp, end_timestamp=EndTimeStamp, timestamp = TimeStamp} = BaseAc,
    Time = data_activitycalen_m:get_advance(Module, ModuleSub),
    Min = Time*60,
    LastTimeStamp = case StartTimestamp>0 orelse EndTimeStamp>0 of
        true ->
            case is_list(TimeStamp) of
                true ->
                    [{StartTimestamp, EndTimeStamp}|TimeStamp];
                _ ->
                    TimeStamp
            end;
        _ ->
            TimeStamp
    end,
    LastLastTimeStamp = [{S+Min,E+Min}||{S,E}<-LastTimeStamp],

    Now = utime:unixtime(),
    case LastLastTimeStamp of
        [] ->
            true;
        LastLastTimeStamp when is_list(LastLastTimeStamp) ->
            TimeStampList = [Now||{Start, End}<-LastLastTimeStamp, Now>=Start, Now=<End],
            lists:member(Now, TimeStampList);
        _ ->
            false
    end;

do_check_ac_sub_help(BaseAc, timer_trigger) ->
    #base_ac{other = Other} = BaseAc,
    {_NowDay, {NowH,NowM,_}} = calendar:local_time(),
    case lists:keyfind(timer_trigger,1,Other) of
        {timer_trigger, NowH, NowM} ->
            true;
        {timer_trigger, _H, _M} ->
            false;
        false ->
            true;
        _ ->
            false
    end;

do_check_ac_sub_help(_BaseAc, _) ->false.

%%% --------------------------------------------------------------------
check_advance(BaseAc) when is_record(BaseAc, base_ac) ->
    #base_ac{module=Module, module_sub=ModuleSub, time_region = TimeRegion} = BaseAc,
    {_, {NowH,NowM,_}} = calendar:local_time(),
    Min = NowH*60+NowM,
    case catch data_activitycalen_m:get_advance(Module, ModuleSub) of
        Time when is_integer(Time) andalso Time > 0 ->
            LastTime = ?IF(Min+Time>=24*60, Min+Time-24*60, Min+Time),
            case TimeRegion of
                [] ->
                    false;
                TimeRegion when is_list(TimeRegion) ->
                    TimeList=[{NowH,NowM}||{{SH,SM},{_EH,_EM}}<-TimeRegion, LastTime==SH*60+SM],
                    case lists:member({NowH,NowM}, TimeList) of
                        true ->
                            case Min>=2*60+60-Time andalso  Min=<3*60 of
                                false ->
                                    do_check_ac_sub(BaseAc, [fix_time, week, month, time, open_day, merge_day]);
                                true ->
                                    do_check_ac_sub(BaseAc, [fix_time, week_advance, month_advance, time_advance, open_day_advance, merge_day_advance])
                            end;
                        false ->
                            false
                    end;
                _r2 ->
                    false
            end;
        _r1 ->
            false
    end;

check_advance(_BaseAc) -> false.


%% 未开启时去下个最近的活动子类
get_near_act(Module, ModuleSub) ->
    ActL = data_activitycalen:get_ac_sub(Module, ModuleSub),
    AcSubL = [{Module, ModuleSub, AcSub}||AcSub <- ActL],
    L1 = [{Mod, ModSub, AcSub}||{Mod, ModSub, AcSub} <- AcSubL, do_check_ac_sub(data_activitycalen:get_ac(Mod, ModSub, AcSub),[merge_day])],
    case L1 =:= [] of
        true ->  %% 不满足合服开启条件
            AcSub = get_near_act_sub(AcSubL, merge_day);
        _ ->
           L2 = [{Mod, ModSub, AcSub}||{Mod, ModSub, AcSub} <- L1, do_check_ac_sub(data_activitycalen:get_ac(Mod, ModSub, AcSub),[open_day])],
           case L2 =:= [] of
               true ->   %% 不满足开服开启条件
                    AcSub = get_near_act_sub(L1, open_day);
               _ ->
                    L3 = [{Mod, ModSub, AcSub}||{Mod, ModSub, AcSub} <- L2, do_check_ac_sub(data_activitycalen:get_ac(Mod, ModSub, AcSub),[week, month, time])],
                    case L3 =:= [] of
                        true ->  %% 不满足天数开启条件
                            AcSub = get_near_act_sub(L2, day);
                        _ ->    %% 不满足时分区域开启条件
                            AcSub = get_near_act_sub(L3, time_region)
                    end
           end
    end,
    AcSub.


get_near_act_sub(ActL, time_region) ->
    Now = utime:unixtime(),
    F = fun({Mod, ModSub, AcSub}, TmpL) ->
            #base_ac{time_region = TimeRegion} = data_activitycalen:get_ac(Mod, ModSub, AcSub),
            case TimeRegion of
                [] -> TmpL;
                TimeRegion when is_list(TimeRegion) ->
                    %% 同一条内跟当前时间相差的最小值 如果当前时间都过了配置里所有的 就以第二天最早的时间相减
                    %% 后面的匹配同理
                     MinL = [H * 60 + M - Now||{{H, M}, {_, _}} <- TimeRegion, (H * 60 + M - Now) > 0],
                    case MinL of
                        [] -> MinT = 86400 + lists:min([H * 60 + M||{{H, M}, {_, _}} <- TimeRegion]) - Now;
                        _ ->  MinT = lists:min(MinL)
                    end,
                    [{MinT, AcSub}|TmpL];
                _ -> TmpL
            end
        end,
    L = lists:foldl(F, [], ActL),
    AcSub = case L of
                [] -> 1;
                _ ->
                    %% 所有子类里最近的
                    Min = lists:min([Time||{Time, _} <- L]),
                    {_, TmpAcSub} = lists:keyfind(Min, 1, L),
                    TmpAcSub
            end,
    AcSub;

get_near_act_sub(ActL, day) ->
    [{Mod, ModSub, AcSub}|_] = ActL,
    #base_ac{week = Week, month = Month, time = Time} = data_activitycalen:get_ac(Mod, ModSub, AcSub),
    %?PRINT("~p,~p,~p,~p,~p,~p~n",[Mod, ModSub, AcSub, Week, Month, Time]),
    if
        Week  =/= [] andalso is_list(Week)  -> get_near_act_sub(ActL, week);
        Month =/= [] andalso is_list(Month) -> get_near_act_sub(ActL, month);
        Time  =/= [] andalso is_list(Week)  -> get_near_act_sub(ActL, time);
        true -> 1
    end;

get_near_act_sub(ActL, week) ->
    WeekDay = utime:logic_day_of_week(),
    F = fun({Mod, ModSub, AcSub}, TmpL) ->
            #base_ac{week = Week} = data_activitycalen:get_ac(Mod, ModSub, AcSub),
            case Week of
                [] -> TmpL;
                Week when is_list(Week) ->
                    MinL = [Day - WeekDay||Day <- Week, (Day - WeekDay) > 0],
                    case MinL of
                        [] -> MinT = 7 + lists:min([Day||Day <- Week]) - WeekDay;
                        _  -> MinT = lists:min(MinL)
                    end,
                    [{MinT, AcSub}|TmpL];
                _ -> TmpL
            end
        end,
    L = lists:foldl(F, [], ActL),
    AcSub = case L of
                [] -> 1;
                _ ->
                    Min = lists:min([Time||{Time, _} <- L]),
                    {_, TmpAcSub} = lists:keyfind(Min, 1, L),
                    TmpAcSub
            end,
    AcSub;

get_near_act_sub(ActL, month) ->
    {{_,_,NowD},_} = utime:get_logic_time(),
    F = fun({Mod, ModSub, AcSub}, TmpL) ->
            #base_ac{month = Month} = data_activitycalen:get_ac(Mod, ModSub, AcSub),
            case Month of
                [] -> TmpL;
                Month when is_list(Month) ->
                    MinL = [Day - NowD||Day <- Month, (Day - NowD) > 0],
                    case MinL of
                        [] -> MinT = 28 + lists:min([Day||Day <- Month]) - NowD;
                        _  -> MinT = lists:min(MinL)
                    end,
                    [{MinT, AcSub}|TmpL];
                _ -> TmpL
            end
        end,
    L = lists:foldl(F, [], ActL),
    AcSub = case L of
                [] -> 1;
                _ ->
                    Min = lists:min([Time||{Time, _} <- L]),
                    {_, TmpAcSub} = lists:keyfind(Min, 1, L),
                    TmpAcSub
            end,
    AcSub;

get_near_act_sub(ActL, time) ->
    {{NowY,NowM,NowD},_} = utime:get_logic_time(),
    Now = utime:unixtime({{NowY, NowM, NowD},{0,0,0}}),
    F = fun({Mod, ModSub, AcSub}, TmpL) ->
            #base_ac{time = Time} = data_activitycalen:get_ac(Mod, ModSub, AcSub),
            case Time of
                [] -> TmpL;
                Time when is_list(Time) ->
                    MinL = [utime:unixtime({{Y,M,D},{0,0,0}}) - Now||{Y,M,D} <- Time, (utime:unixtime({{Y,M,D},{0,0,0}}) - Now) > 0],
                    case MinL of
                        [] -> MinT = 86400 * 365 + lists:min([utime:unixtime({{Y,M,D},{0,0,0}})||{Y,M,D} <- Time]) - Now;
                        _  -> MinT = lists:min(MinL)
                    end,
                    [{MinT, AcSub}|TmpL];
                _ -> TmpL
            end
        end,
    L = lists:foldl(F, [], ActL),
   AcSub = case L of
                [] -> 1;
                _ ->
                    Min = lists:min([Time||{Time, _} <- L]),
                    {_, TmpAcSub} = lists:keyfind(Min, 1, L),
                    TmpAcSub
            end,
    AcSub;

get_near_act_sub(ActL, open_day) ->
   Now = util:get_open_day(),
    F = fun({Mod, ModSub, AcSub}, TmpL) ->
            #base_ac{open_day = OpenDay} = data_activitycalen:get_ac(Mod, ModSub, AcSub),
            case OpenDay of
                [] -> TmpL;
                OpenDay when is_list(OpenDay) ->
                    MinL = [Start - Now||{Start, _End} <- OpenDay, (Start - Now) > 0],
                    case MinL of
                        [] -> TmpL ;
                        _  -> [{lists:min(MinL), AcSub}|TmpL]
                    end;
                _ -> TmpL
            end
        end,
    L = lists:foldl(F, [], ActL),
    AcSub = case L of
                [] -> 1;
                _ ->
                    Min = lists:min([Time||{Time, _} <- L]),
                    {_, TmpAcSub} = lists:keyfind(Min, 1, L),
                    TmpAcSub
            end,
    AcSub;

get_near_act_sub(ActL, merge_day) ->
   Now = util:get_merge_day(),
    F = fun({Mod, ModSub, AcSub}, TmpL) ->
            #base_ac{merge_day = MergeDay} = data_activitycalen:get_ac(Mod, ModSub, AcSub),
            case MergeDay of
                [] -> TmpL;
                MergeDay when is_list(MergeDay) ->
                    MinL = [Start - Now||{Start, _End} <- MergeDay, (Start - Now) > 0],
                    case MinL of
                        [] -> TmpL ;
                        _  -> [{lists:min(MinL), AcSub}|TmpL]
                    end;
                _ -> TmpL
            end
        end,
    L = lists:foldl(F, [], ActL),
    AcSub = case L of
                [] -> 1;
                _ ->
                    Min = lists:min([Time||{Time, _} <- L]),
                    {_, TmpAcSub} = lists:keyfind(Min, 1, L),
                    TmpAcSub
            end,
    AcSub.

%% 活动开始前10分钟微信推送
do_wx_push(BaseAc) ->
    lib_activitycalen_util:do_check_ac_sub(BaseAc, [fix_time, week, month, open_day, merge_day, push_time]).
    % % 现阶段测试先用圣灵战场，后面根据需要增加
    % NeedWxPushAct = [?MOD_HOLY_SPIRIT_BATTLEFIELD],
    % #base_ac{module = Module} = BaseAc,
    % case lists:member(Module, NeedWxPushAct) of
    %     true ->
    %         lib_activitycalen_util:do_check_ac_sub(BaseAc, [fix_time, week, month, open_day, merge_day, push_time]);
    %     false ->
    %         skip
    % end.
