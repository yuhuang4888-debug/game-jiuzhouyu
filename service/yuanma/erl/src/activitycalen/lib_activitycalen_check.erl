%%%--------------------------------------
%%% @Module  : lib_activitycalen_check
%%% @Author  : xiaoxiang
%%% @Created : 2017-03-01
%%% @Description:  lib_activitycalen_check
%%%--------------------------------------
-module(lib_activitycalen_check).
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

check_ac_start(Module, ModuleSub, {{_,_,_},{_,_,_}} = DataTime) ->
    AcSubList = data_activitycalen:get_ac_sub(Module, ModuleSub),
    CheckList = [time, week, month, open_day, merge_day], 
    [AcSub||AcSub<-AcSubList, do_check_ac_start(data_activitycalen:get_ac(Module, ModuleSub, AcSub), DataTime, CheckList)];

check_ac_start(_Module, _ModuleSub, _) -> [].


do_check_ac_start(#base_ac{}, _TimeStamp, []) -> true;
do_check_ac_start(#base_ac{} = BaseAc, DataTime, [H|T]) -> 
    case do_check_ac_start_help(BaseAc, DataTime, H) of
        true ->
            do_check_ac_start(BaseAc, DataTime, T);
        false ->
%%            ?PRINT("H:~p ~n", [H]),
            false
    end;
do_check_ac_start(_,_,_) -> false.

%%  格式：[{2017,3,11}]，[] 默认为每天都开 
do_check_ac_start_help(#base_ac{time=Time}, TimeData, time) ->
    {{Year, Month, Day},_} = utime:get_logic_time(TimeData),
    case Time of
        [] ->
            true;
        Time when is_list(Time) ->
            List = [1||{Y, M, D}<-Time,Year == Y, Month==M, Day == D],
            lists:member(1, List);
        _ ->
            false
    end;

%%  格式：[1,2,3,4,5,6,7] ，7表示星期天 []默认为每天都开 
do_check_ac_start_help(#base_ac{week=Week}, TimeData, week) ->
    {Data,_} = utime:get_logic_time(TimeData),
    TimdWeek = calendar:day_of_the_week(Data),
    case Week of
        [] ->
            true;
        Week when is_list(Week) ->
            lists:member(TimdWeek, Week);
        _ ->
            false
    end;

 %%  格式：[1,2,28], 勿填>28的数字（程序容错，>28时不开启） []默认为每天都开 
do_check_ac_start_help(#base_ac{month=Month}, TimeData, month) ->
    {{_,_,Day},_} = utime:get_logic_time(TimeData),
    case Month of
        [] ->
            true;
        Month when is_list(Month) ->
            lists:member(Day, Month);
        _ ->
            false
    end;

%%  格式：[{开服开始天数，结束天数},{}];如[{1,20},{50,100}],[]默认每天都开 
do_check_ac_start_help(#base_ac{open_day = OpenDay}, TimeData, open_day) ->
    {Data1,_} = utime:get_logic_time(TimeData),
    Day1 = calendar:date_to_gregorian_days(Data1),
    {Now, _} = utime:get_logic_time(),
    Day2 = calendar:date_to_gregorian_days(Now),
    NowOpenDay = util:get_open_day(),
    Day3 = Day1-Day2+NowOpenDay,
    IsList = is_list(OpenDay),
    if 
        Day3 =< 0 -> false;
        OpenDay == [] -> true;
        IsList ->
            List = [1||{S, E}<-OpenDay, Day3>=S, Day3=<E],
            lists:member(1, List);
        true -> false
    end;
%% 活动日历规则 type为0 []为单服，合服必须填具体内容  如果合服[]也为满足，则会出现[]和[{1,2}]出现冲突
%% 充值活动规则 type为1 为充值活动规则 []全满足
do_check_ac_start_help(#base_ac{merge_day = MergeDay, type=Type}, TimeData, merge_day) ->
    {Data1,_} = utime:get_logic_time(TimeData),
    Day1 = calendar:date_to_gregorian_days(Data1),
    {Now, _} = utime:get_logic_time(),
    Day2 = calendar:date_to_gregorian_days(Now),
    NowMergeDay = util:get_merge_day(),
    Day3 = max(Day1-Day2+NowMergeDay, 0),
    IsList = is_list(MergeDay),
    if
        NowMergeDay > 0 andalso Day3 < 0 ->
            false;
        MergeDay == [] ->
            Type == 1 orelse NowMergeDay == 0;
        IsList ->
            List = [1||{S, E}<-MergeDay, Day3>=S, Day3=<E],
            lists:member(1, List);
        true -> false
    end;

do_check_ac_start_help(_, _, _) ->false.