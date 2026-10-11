%% ---------------------------------------------------------------------------
%% @doc utime
%% @author ming_up@foxmail.com
%% @since  2015-11-24
%% @deprecated  时间系统函数库
%%              mod_time:now/0 返回自1970年(GMT)至今的秒数{百万秒，秒，微秒}::erlang:timestamp()
%%          注：1.mod_time刷新时间为100ms一次
%%              2.换算时间时注意GMT/UTC时间和本地时间的问题
%% ---------------------------------------------------------------------------
-module(utime).
-include("common.hrl").
-export([
        unixtime/0, unixtime/1,                                 %% 获取时间戳(s)
        longunixtime/0,                                         %% 获取时间戳(ms)
        microunixtime/0,                                        %% 获取时间戳(微秒)
        unixdate/0, unixdate/1,                                 %% 获取凌晨时间戳(s)
        unixdate_four/0, unixdate_four/1,                       %% 获取凌晨4点时间戳(s)
        warn_get_next_unixdate/1,
        get_next_unixdate/0,                                    %% 获取下一天0点时间戳(s)
        get_next_unixdate/1,                                    %% 根据某天获取下一天0点时间戳(s)
        get_next_unixdate_four/0,                               %% 获取下一天凌晨4点时间戳(s)
        get_next_unixdate_four/1,                               %% 获取某天下一天凌晨4点时间戳(s)
%%        standard_unixdate/1,
        unixtime_to_now/1,
        micro_to_s/1,                                           %% 微秒转换成秒
        unixtime_to_localtime/1, unixtime_to_gmttime/1,         %% 时间戳转本地时间/GMT时间
        localtime/0,                                            %% 获取本地时间戳
        get_month_unixtime_range/0, get_month_unixtime_range/1, %% 获取这个月的时间戳范围
        get_date/0,
        get_datetime_string/1,
        day_of_week/0, day_of_week/1,                           %% 获取星期几
        day_of_month/0, day_of_month/1,                         %% 获取今天是当月第几天
        diff_days/1, diff_days/2,                               %% 两个时间戳直接相差多少天
        diff_day/1,                                             %% 两个时间戳直接相差多少天(有一点区别)
        diff_day_of_week/1,                                     %% 距离周几N天
        diff_day_of_week/2,                                     %% 距离周几N天
        diff_weeks/1, diff_weeks/2,                             %% 两个时间戳(绝对距离)直接相差多少周
        is_today/1,                                             %% 是否今日
        is_same_day/2,                                          %% 判断是否同一天
        is_same_date/2,                                         %% 判断是否同一天
        is_same_week/2,                                         %% 是否同一周
        is_same_month/2,                                        %% 是否同一月
        is_logic_same_day/1, is_logic_same_day/2,               %% 是否同一刷新日
        get_logic_day_time_info/0,                              %% 逻辑天数信息
        get_logic_day_time_info/1,
        get_logic_day_start_time/0,
        get_logic_day_start_time/1,
        logic_diff_days/1,
        logic_diff_days/2,
        logic_week_start/0,
        logic_week_start/1,
        get_logic_time/0,
        get_logic_time/1,                                       %% 返回本地逻辑时间：  {{年，月，日}，{时，分，秒}}
        logic_day_of_week/0,                                    %% 逻辑星期
        logic_day_of_week/1,                                    %% 逻辑星期
        get_before_day/3,                                       %% 获取某一天的前天或者后天
        get_seconds_from_midnight/0,                            %% 获取当天0点到现在的秒数
        get_seconds_from_midnight/1,                            %% 获取当天0点到现在的秒数
        time_to_hms/1,
        get_month/0,
        is_continuous_week/1
        , calc_click_time/0
        , calc_click_time/1
        , get_month_start_weekday/1
        , get_month_start_weekday/2
        , get_next_month_start_weekday/1
        , get_next_time/2
        , sys_guess_unixtime/1
        , standard_unixdate/0
        , standard_unixdate/1
        , get_diff_day_standard_unixdate/2                     %% 当前时间前或后几天的0点时间
        , get_diff_day_standard_unixdate/3                     %% 给定时间前或后几天的0点时间
        , native_utc_zone/0
        , utc_unixtime/1
        , utc_unixtime/2
        , get_skv_utc_zone/0
        , unixtime_to_timestr/1                             %% Unix时间戳转换为本地时区的时间字符串格式
    ]).

%% 取得当前的unix时间戳（秒）
unixtime() ->
    {M, S, _} = mod_time:now(),
    M * 1000000 + S.

%% 通过本地时间取得unix时间戳
%% LocalTime = {{Y,M,D},{H,M,S}}, 必须大于1970年
%% 注意此函数不能批量同时使用
unixtime(LocalTime) ->
    %% local_time_to_universal_time_dst 在liunx上效率非常低
    [UniversalTime] = calendar:local_time_to_universal_time_dst(LocalTime), %% 带夏令时
    %% UniversalTime = erlang:localtime_to_universaltime(LocalTime),
    S = calendar:datetime_to_gregorian_seconds(UniversalTime),
    max(0, S - ?DIFF_SECONDS_0000_1970).

%% 取得当前的unix时间戳（毫秒）
longunixtime() ->
    {M, S, Us} = mod_time:now(),
    (M * 1000000000000 + S*1000000 + Us) div 1000.

%% 取得当前的unix时间戳（微秒）
microunixtime() ->
    {M, S, Us} = mod_time:now(),
    M * 1000000000000 + S * 1000000 + Us.

%% 取得当天零点的unix时间戳
unixdate() ->
    Now = mod_time:now(),
    % 获取{{year,month,day},{hour,minute,second}}
    {_, Time} = calendar:now_to_local_time(Now),
    % 算出当天的秒数，不管夏令时和冬令时
    % {1,minute,second}(3600) => {2,minute,second}(7200)
    Ds = calendar:time_to_seconds(Time),
    {M, S, _} = Now,
    % 当前的秒数-计算出的秒数（因为夏令时和冬令时会导致这个值波动）
    M * 1000000 + S - Ds.
unixdate(UnixTime) ->
    Now = unixtime_to_now(UnixTime),
    {_, Time} = calendar:now_to_local_time(Now),
    Ds = calendar:time_to_seconds(Time),
    {M, S, _} = Now,
    M * 1000000 + S - Ds.
    % Now = unixtime_to_now(UnixTime),
    % {{Y,M,D}, _} = calendar:now_to_local_time(Now),
    % unixtime({{Y,M,D},{0,0,0}}).

%% 取得当天4点的unix时间戳
unixdate_four() ->
    unixdate() + 4 * ?ONE_HOUR_SECONDS.
%% 根据某天取得当天4点的unix时间戳
unixdate_four(UnixTime) ->
    unixdate(UnixTime) + 4 * ?ONE_HOUR_SECONDS.

%% 获得下一天时间戳[注意此函数不能批量同时使用]
warn_get_next_unixdate(Unixtime) ->
    {{Year, Month, Day}, _} = unixtime_to_localtime(Unixtime),
    Days = calendar:date_to_gregorian_days(Year, Month, Day),
    Date = calendar:gregorian_days_to_date(Days+1),
    unixtime({Date, {0, 0, 0}}).

%% 获得下一天时间戳0点
get_next_unixdate() ->
    % UnixDate = unixdate(),
    % date_to_next_unixdate(UnixDate).
    get_next_unixdate(utime:unixtime()).

get_next_unixdate(Unixtime) ->
    % UnixDate = unixdate(Unixtime),
    % date_to_next_unixdate(UnixDate).
    {Date, _Time} = unixtime_to_localtime(Unixtime),
    EndLocalTime = {Date, {23, 59, 59}},
    sys_guess_unixtime(EndLocalTime) + 1.

%% 获得下一天时间戳凌晨4点
get_next_unixdate_four() ->
    get_next_unixdate() + 4 *?ONE_HOUR_SECONDS.
%% 根据某天获得下一天时间戳凌晨4点
get_next_unixdate_four(Unixtime) ->
    get_next_unixdate(Unixtime) + 4 *?ONE_HOUR_SECONDS.

% %% 零点时间戳转换成下一天
% date_to_next_unixdate(UnixDate) ->
%     % 冬令时/夏令时的情况，会导致一天不够86400或者超过86400，误差是一个小时
%     utime:unixdate(UnixDate+?ONE_DAY_SECONDS+2*?ONE_HOUR_SECONDS).

%%%% 获取当天的零点(冬令时/夏令时会影响到零点)
%%standard_unixdate(Unixtime) ->
%%    % % 如果是伦敦夏令时转变当天，时间戳是四点的话，获取零点时间戳是昨天的23点。所以要加多两个小时保证是这个时间戳的零点
%%    % UnixDate = unixdate(Unixtime),
%%    % utime:unixdate(UnixDate+2*?ONE_HOUR_SECONDS).
%%    {{Year, Month, Day}, _} = unixtime_to_localtime(Unixtime),
%%    sys_guess_unixtime({{Year, Month, Day}, {0, 0, 0}}).
%%
%%%% 夏令时->冬令时和冬令时->夏令时转换，系统底层会猜测你需要哪一个.
%%%% 效率比 utime:unixtime({{_Y,_M,_D},{_H,_I,_S}}) 高
%%sys_guess_unixtime(LocalTime = {{_Y,_M,_D},{_H,_I,_S}}) ->
%%    UniversalTime = erlang:localtime_to_universaltime(LocalTime),
%%    Unixtime = erlang:universaltime_to_posixtime(UniversalTimeli),
%%    Unixtime.

%% [时间戳::unixtime()] 转换为[erlang:timestamp()]
unixtime_to_now(UnixTime) ->
    M = UnixTime div 1000000,
    S = UnixTime rem 1000000,
    {M, S, 0}.

%% 微秒转换成秒
micro_to_s(Timestamp) -> Timestamp div 1000000.

%% [时间戳::unixtime()] 转换为[本地时间::datetime()]
unixtime_to_localtime(Unixtime) ->
    Now = unixtime_to_now(Unixtime),
    calendar:now_to_local_time(Now).
%% [时间戳::unixtime()] 转换为[GMT时间::datetime()]
unixtime_to_gmttime(Unixtime) ->
    Now = unixtime_to_now(Unixtime),
    calendar:now_to_universal_time(Now).

%% 获取本地时间戳 LocalTime = {{Y,M,D},{H,M,S}}
localtime() ->
    Now = mod_time:now(),
    calendar:now_to_local_time(Now).

%% 获得本月的时间范围 -> {BeginUnixTime, EndUnixTime}
get_month_unixtime_range() ->
    NowTime = utime:unixdate(),
    get_month_unixtime_range(NowTime).
get_month_unixtime_range(Unixtime) ->
    {{Y, M, _D}, _} = unixtime_to_localtime(Unixtime),
    DayNum = calendar:last_day_of_the_month(Y, M),
    StartDate = {{Y, M, 1}, {0, 0, 0}},
    StartTime = sys_guess_unixtime(StartDate),
%%    EndTime = StartTime + DayNum*?ONE_DAY_SECONDS,
    Time = sys_guess_unixtime({{Y, M, DayNum}, {23, 59, 59}}),
    {StartTime, Time + 1}.

%% 获取月份
get_month() ->
    Unixtime = unixtime(),
    {{_, M, _}, _} = unixtime_to_localtime(Unixtime),
    M.

is_same_month(Unixtime1, Unixtime2) ->
    {{_, M1, _}, _} = unixtime_to_localtime(Unixtime1),
    {{_, M2, _}, _} = unixtime_to_localtime(Unixtime2),
    M1 == M2.

%% 获取月初的周x
get_month_start_weekday(FindWeekDay) ->
    NowTime = utime:unixdate(),
    get_month_start_weekday(NowTime, FindWeekDay).
get_month_start_weekday(Unixtime, FindWeekDay) ->
    {{Y, M, _D}, _} = unixtime_to_localtime(Unixtime),
    WeekDay = calendar:day_of_the_week(Y, M, 1),
    Gap = get_weekday_gap(WeekDay, FindWeekDay),
    Date = {{Y, M, 1+Gap}, {0, 0, 0}},
    Time = unixtime(Date),
    Time.

%% 获取下一个月月初周x
get_next_month_start_weekday(FindWeekDay) ->
    NowTime = utime:unixdate(),
    {{Y, M, _D}, _} = unixtime_to_localtime(NowTime),
    DayNum = calendar:last_day_of_the_month(Y, M),
    StartDate = {{Y, M, DayNum}, {0, 0, 0}},
    StartTime = unixtime(StartDate),
    EndTime = StartTime + ?ONE_DAY_SECONDS,
    get_month_start_weekday(EndTime, FindWeekDay).

get_weekday_gap(WeekDay, FindWeekDay) ->
    case FindWeekDay >= WeekDay of
        true -> FindWeekDay - WeekDay;
        _ -> FindWeekDay + 7 - WeekDay
    end.

%% ---------------------------------------------------------------------------
%% @doc 计算今天的日期 返回一个YYYYMMDD时间样板数值(如20140708)
-spec get_date() -> Date when
      Date      :: integer().
%% ---------------------------------------------------------------------------
get_date() ->
    {Y, M, D} = erlang:date(),
    Y * 10000 + M * 100 + D.

%% 获取字符串格式
get_datetime_string({{Y,M,D}, {H, I,S}})->
    io_lib:format("~4..0w~2..0w~2..0w~2..0w~2..0w~2..0w", [Y, M, D, H, I, S]).

%% 今天是星期几
day_of_week() ->
    UnixTime = unixtime(),
    day_of_week(UnixTime).
day_of_week(UnixTime) ->
    {{Year, Month, Day}, _Time} = unixtime_to_localtime(UnixTime),
    calendar:day_of_the_week(Year, Month, Day).

%% 今天是当月第几天
day_of_month() ->
    UnixTime = unixtime(),
    day_of_month(UnixTime).
day_of_month(UnixTime) ->
    {{_Year, _Month, Day}, _Time} = unixtime_to_localtime(UnixTime),
    Day.

%% 相差的天数
diff_days(UnixTime) ->
    Now=unixtime(),
    diff_days(UnixTime, Now).
diff_days(UnixTime1, UnixTime2) ->
    {Date1, _} = unixtime_to_localtime(UnixTime1),
    {Date2, _} = unixtime_to_localtime(UnixTime2),
    abs(calendar:date_to_gregorian_days(Date2) - calendar:date_to_gregorian_days(Date1)).

%% 相差的天数(有负数)
diff_day(UnixTime) ->
    {Date1, _} = calendar:now_to_local_time(unixtime_to_now(UnixTime)),
    {Date2, _} = calendar:local_time(),
    calendar:date_to_gregorian_days(Date2) - calendar:date_to_gregorian_days(Date1).

%% 距离周几N天
diff_day_of_week(Week) ->
    diff_day_of_week(Week, unixtime()).
diff_day_of_week(Week, Time) ->
    NowWeek = utime:day_of_week(Time),
    if
        NowWeek < Week -> Week - NowWeek;
        NowWeek > Week -> ((7 - NowWeek) + Week);
        true -> 0
    end.

%% 相差的周数
diff_weeks(UnixTime) ->
    Now = unixtime(),
    diff_weeks(UnixTime, Now).
diff_weeks(UnixTime1, UnixTime2) ->
    DiffDays = diff_days(UnixTime1, UnixTime2),
    DiffDays div 7.

%% @spec is_today(Time) -> boolean()
%% @doc 判断是否为今天时间
is_today(Time) ->
    Now = utime:unixtime(),
    is_same_day(Time, Now).

%% 判断是否同一天
is_same_day(UnixTime1, UnixTime2) ->
    %% diff_days(UnixTime1, UnixTime2) =:= 1.
    diff_days(UnixTime1, UnixTime2) =:= 0.

%% seconds_to_localtime(UnixTime) ->
%%    UniversalTime = erlang:posixtime_to_universaltime(UnixTime),
%%    erlang:universaltime_to_localtime(UniversalTime).

is_same_week(UnixTime1, UnixTime2) ->
    {{Year1, Month1, Day1}, {Hour1, Min1, Second1}} = unixtime_to_localtime(UnixTime1),
    Week1  = calendar:day_of_the_week(Year1, Month1, Day1),
    DateTime1 = UnixTime1 - Hour1*3600 - Min1*60 - Second1, %% 本地时间凌晨时间戳

    (DateTime1 - (Week1-1)*?ONE_DAY_SECONDS) =< UnixTime2  andalso
        DateTime1 + (7-Week1+1)*?ONE_DAY_SECONDS > UnixTime2.

%% 是否同一刷新天（今天凌晨4点到次日凌晨4点为一刷新天）
is_logic_same_day(Timestamp) ->
    NowTime                 = unixtime(),
    ZeroTime                = unixdate(NowTime),
    FourClock               = ZeroTime + ?DAY_LOGIC_OFFSET_SECONDS, %% 改成4点清理
    YesterDayThreeClock     = FourClock - ?ONE_DAY_SECONDS,
    TomorrowDayThreeClock   = FourClock + ?ONE_DAY_SECONDS,
    if
        Timestamp < YesterDayThreeClock orelse Timestamp >= TomorrowDayThreeClock -> false;
        NowTime < FourClock andalso Timestamp < FourClock -> true;
        NowTime >= FourClock andalso Timestamp >= FourClock -> true;
        true -> false
    end.

is_logic_same_day(Timestamp1, Timestamp2) ->
    ZeroTime1               = unixdate(Timestamp1),
    ThreeClock1             = ZeroTime1 + ?DAY_LOGIC_OFFSET_HOUR*3600,
    YesterDayThreeClock1    = ThreeClock1 - ?ONE_DAY_SECONDS,
    TomorrowDayThreeClock1  = ThreeClock1 + ?ONE_DAY_SECONDS,
    if
        Timestamp2 < YesterDayThreeClock1 orelse Timestamp2 >= TomorrowDayThreeClock1 -> false;
        Timestamp1 < ThreeClock1 andalso Timestamp2 < ThreeClock1 -> true;
        Timestamp1 >= ThreeClock1 andalso Timestamp2 >= ThreeClock1 -> true;
        true -> false
    end.

%% 获得逻辑天时间信息
%% @return {逻辑天数开始, 逻辑天数中间的零点, 逻辑天数结束}
get_logic_day_time_info() ->
    NowTime = unixtime(),
    get_logic_day_time_info(NowTime).

%% 计算4点偏差
get_logic_day_time_info(Timestamp) ->
    ZeroTime = unixdate(Timestamp),
    %% 今天4点
    FourClock = ZeroTime + ?DAY_LOGIC_OFFSET_HOUR*3600,
    %% 昨天4点
    YesterDayFourClock = FourClock - ?ONE_DAY_SECONDS,
    %% 明天4点
    TomorrowDayFourClock = FourClock + ?ONE_DAY_SECONDS,
    %% 现在的时间大于4点
    case Timestamp >= FourClock of
        true ->
            TomorrowZeroTime = ZeroTime + ?ONE_DAY_SECONDS,
            {FourClock, TomorrowZeroTime, TomorrowDayFourClock};
        false ->
            {YesterDayFourClock, ZeroTime, FourClock}
    end.

%% 获得逻辑天数的开始时间
%% @retrun 逻辑天数开始时间
get_logic_day_start_time() ->
    get_logic_day_start_time(unixtime()).

get_logic_day_start_time(Timestamp) ->
    {FourClock, _ZeroTime, _NextFourClock} = get_logic_day_time_info(Timestamp),
    FourClock.

%% 逻辑相差天数
logic_diff_days(UnixTime) ->
    Now = unixtime(),
    logic_diff_days(UnixTime, Now).

logic_diff_days(UnixTime1, UnixTime2) ->
    StartTime1 = get_logic_day_start_time(UnixTime1),
    StartTime2 = get_logic_day_start_time(UnixTime2),
    diff_days(StartTime1, StartTime2).

%% 周到逻辑开始时间戳
logic_week_start() ->
    Now = unixtime(),
    logic_week_start(Now).

logic_week_start(Unixtime) ->
    ZeroTime = unixdate(Unixtime),
    FourClock = ZeroTime+?DAY_LOGIC_OFFSET_HOUR*3600,
    Week = day_of_week(Unixtime),
    case Week == 1 andalso Unixtime < FourClock of
        true -> ZeroTime-?ONE_WEEK_SECONDS+?DAY_LOGIC_OFFSET_HOUR*3600;
        false -> ZeroTime-(Week-1)*?ONE_DAY_SECONDS+?DAY_LOGIC_OFFSET_HOUR*3600
    end.

%% 返回本地逻辑时间：  {{年，月，日}，{时，分，秒}}
get_logic_time() ->
    {{NowYear,NowMon,NowDay}, {NowHour, NowMin,NowSec}} = calendar:local_time(),
    get_logic_time({{NowYear,NowMon,NowDay}, {NowHour, NowMin,NowSec}}).

get_logic_time({{NowYear,NowMon,NowDay}, {NowHour, NowMin,NowSec}}) ->
    case NowHour < ?LOGIC_NEW_DAY of
        true ->
            case NowDay-1 =< 0 of
                true ->
                    case NowMon-1=< 0 of
                        true ->
                            Year=NowYear-1,
                            Month = 12,
                            Day = 31;
                        _ ->
                            Year=NowYear,
                            Month=NowMon-1,
                            Day=calendar:last_day_of_the_month(Year,Month)
                    end;
                _ ->
                    Year = NowYear,
                    Month = NowMon,
                    Day = NowDay-1
            end,
            {{Year, Month, Day}, {NowHour, NowMin,NowSec}};
        _ ->
            {{NowYear,NowMon,NowDay}, {NowHour, NowMin,NowSec}}
    end.

%% 获得逻辑星期 目前是没有逻辑天数的概念的， 直接用day_of_week
logic_day_of_week() ->
    %%
    day_of_week().
logic_day_of_week(T) ->
    day_of_week(T).
%%    day_of_week(get_logic_day_start_time()).
%%logic_day_of_week(Timestamp) ->
%%    day_of_week(Timestamp).

%% X年X月X日的前后X天是几月几号  Type 0为前，1为后
get_before_day({Year, Month, Day}, Dif, Type) ->
    Time1 = sys_guess_unixtime({{Year, Month, Day}, {12, 0, 0}}), %% 中午的时间
    case Type == 0 of
        true ->
            Time1 = sys_guess_unixtime({{Year, Month, Day}, {12, 0, 0}}), %% 中午的时间， 这里绕过了夏零时和冬令时的1个小时的时差
            Time2 = Time1 - ?ONE_DAY_SECONDS * Dif,
            {{YearNew, MonthNew, DayNew}, _} = unixtime_to_localtime(Time2),
            {YearNew, MonthNew, DayNew};
        false ->
            Time1 = sys_guess_unixtime({{Year, Month, Day}, {12, 0, 0}}), %% 中午的时间， 这里绕过了夏零时和冬令时的1个小时的时差
            Time2 = Time1 + ?ONE_DAY_SECONDS * Dif,
            {{YearNew, MonthNew, DayNew}, _} = unixtime_to_localtime(Time2),
            {YearNew, MonthNew, DayNew}
    end.

%% -----------------------------------------------------------------
%% 获取当天0点到现在的秒数
%% -----------------------------------------------------------------
get_seconds_from_midnight() ->
    NowTime  = unixtime(),
    {{_Year, _Month, _Day}, Time} = unixtime_to_localtime(NowTime),
    calendar:time_to_seconds(Time).

get_seconds_from_midnight(Seconds) ->
    {{_Year, _Month, _Day}, Time} = unixtime_to_localtime(Seconds),
    calendar:time_to_seconds(Time).

%% -----------------------------------------------------------------
%% 判断是否同一天
%% -----------------------------------------------------------------
is_same_date(UnixTime1, UnixTime2) ->
    utime:diff_days(max(0, UnixTime1), max(0, UnixTime2)) == 0.

%% 时间转时分秒
time_to_hms(Time) ->
    H = Time div 3600,
    M = Time rem 3600 div 60,
    S = Time rem 3600 rem 60,
    {H, M, S}.

%%--------------------------------------------------
%% 是否是连续的周数
%% @param  WeekL [周几]
%% @return       true|false
%%--------------------------------------------------
is_continuous_week([]) -> false;
is_continuous_week(WeekL) ->
    List = [1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6],
    is_continuous_week_helper(WeekL, length(WeekL), List).

is_continuous_week_helper(_WeekL, _Len, []) -> false;
is_continuous_week_helper(WeekL, Len, [_H|L] = List) ->
    case lists:sublist(List, Len) =:= WeekL of
        false ->
            is_continuous_week_helper(WeekL, Len, L);
        _ -> true
    end.

%%时钟计算 获取距离下一个N*5分钟检测点秒差
%%warning N=1 2 3 4 5 6 再多报错自己负责
calc_click_time()->
    calc_click_time(1).
calc_click_time(N) when 1=<N andalso N=<6 ->
    Per = N*5,
    {_Date, {_H,M,S}} = calendar:local_time(),
    Sec=((M div Per + 1)*Per-M)*60-S,
    %io:format("~p,~p,~p~n",[?MODULE,?LINE,{_H,M,S,Sec}]),
    Sec;
calc_click_time(_)->999999.

%% 获得下次时间
get_next_time(H, S) ->
    NowTime = utime:unixtime(),
    NowDate = utime:unixdate(),
    Time = NowDate + H*?ONE_HOUR_SECONDS + S,
    case NowTime < Time of
        true -> Time;
        false -> Time + ?ONE_DAY_SECONDS
    end.


%% 获取当天的零点(冬令时/夏令时会影响到零点)
standard_unixdate() ->
    Now = mod_time:now(),
    {_, Time} = calendar:now_to_local_time(Now),
    Ds = calendar:time_to_seconds(Time),
    {M, S, _} = Now,
    M * 1000000 + S - Ds.
standard_unixdate(Unixtime) ->
    % % 如果是伦敦夏令时转变当天，时间戳是四点的话，获取零点时间戳是昨天的23点。所以要加多两个小时保证是这个时间戳的零点
    % UnixDate = unixdate(Unixtime),
    % utime:unixdate(UnixDate+2*?ONE_HOUR_SECONDS).
    {{Year, Month, Day}, _} = unixtime_to_localtime(Unixtime),
    sys_guess_unixtime({{Year, Month, Day}, {0, 0, 0}}).

%% 夏令时->冬令时和冬令时->夏令时转换，系统底层会猜测你需要哪一个.
%% 效率比 utime:unixtime({{_Y,_M,_D},{_H,_I,_S}}) 高
sys_guess_unixtime(LocalTime = {{_Y,_M,_D},{_H,_I,_S}}) ->
    UniversalTime = erlang:localtime_to_universaltime(LocalTime),
    Unixtime = erlang:universaltime_to_posixtime(UniversalTime),
    Unixtime.

%% 当前时间Diff天前或后的零点   Type 0为前， 1为后  慎用
get_diff_day_standard_unixdate(Diff, Type) ->
    {{Year, Month, Day}, _} = calendar:local_time(),
    {NewYear, NewMonth, NewDay} = utime:get_before_day({Year, Month, Day}, Diff, Type),
    utime:sys_guess_unixtime({{NewYear, NewMonth, NewDay}, {0, 0, 0}}).

%% Time时间 Diff天前或后的零点   Type 0为前， 1为后 慎用
get_diff_day_standard_unixdate(Time, Diff, Type) ->
    {{Year, Month, Day}, _} = utime:unixtime_to_localtime(Time),
    {NewYear, NewMonth, NewDay} = utime:get_before_day({Year, Month, Day}, Diff, Type),
    utime:sys_guess_unixtime({{NewYear, NewMonth, NewDay}, {0, 0, 0}}).

%% ----------------------------------------
%% 时区转换
%% ----------------------------------------

%% 获取本地时区（带夏令时）- bif native api
%% 例如：纽约时区：西五区。在冬令时计算是-5，在夏令时计算是-4。
native_utc_zone() ->
    {Y, M, D} = erlang:date(),
    case erlang:universaltime_to_localtime({{Y, M, D}, {0, 0, 0}}) of
        {{Y, M, D}, {H, _, _}} -> H;
        {{_Y, _M, _D}, {H, _, _}} -> H - 24
    end.

%% 将东8区unix时间戳 转化为服务器本地时区的unix时间戳（秒）
utc_unixtime(UtcZone8UnixTime) ->
    utc_unixtime(UtcZone8UnixTime, true).

%% 将东8区unix时间戳 转化为服务器本地时区的unix时间戳（秒）
%% 注：通常游戏配置时间以东8区为时间基准，其它时区根据本地时区动态偏移

%% @param UtcZone8UnixTime :: integer()  东8区unix时间戳
%% @param IgnoreZero       :: boolean()  是否忽略不转换时间戳0
%%  默认忽略转换配置中的时间戳0，其它具体的逻辑计算视情况转换
utc_unixtime(0, true) -> 0;
utc_unixtime(UtcZone8UnixTime, _IgnoreZero) ->
    UtcZone = lib_vsn:utc_zone(),
    UtcZone8UnixTime + (?DEFAULT_UTC_ZONE - UtcZone) * 3600.

%% 获取 server_kv 中的时区
get_skv_utc_zone() ->
    case lib_server_kv:get_utc_zone() of
        false -> ?DEFAULT_UTC_ZONE;
        V -> V
    end.

%% ----------------------------------------
%% 其他
%% ----------------------------------------

%% Unix时间戳转换为本地时区的时间字符串格式
%% 注意：这个接口产生的数据，存在与其他外部系统交互的时间字符串,
%% 所以月、日、时、分、秒必须是两位数字，不足需要补0，否则不能被识别为时间字符串
unixtime_to_timestr(Unixtime) ->
    {{Y, Mo, D}, {H, Mi, S}} = unixtime_to_localtime(Unixtime),
    % iolist_to_binary(lists:concat([Y, "-", Mo, "-", D, " ", H, ":", Mi, ":", S])).
    iolist_to_binary(
        io_lib:format(
            "~4..0w-~2..0w-~2..0w ~2..0w:~2..0w:~2..0w",
            [Y, Mo, D, H, Mi, S]
        )).