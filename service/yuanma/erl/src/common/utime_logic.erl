%% ---------------------------------------------------------------------------
%% @doc utime_logic
%% @author ming_up@foxmail.com
%% @since  2015-11-24
%% @deprecated  时间系统函数库
%%              mod_time:now/0 返回自1970年(GMT)至今的秒数{百万秒，秒，微秒}::erlang:timestamp()
%%          注：1.mod_time刷新时间为100ms一次
%%              2.换算时间时注意GMT/UTC时间和本地时间的问题
%% ---------------------------------------------------------------------------
-module(utime_logic).
-include("common.hrl").
-export([
         get_logic_day_start_time/0
         , get_logic_day_start_time/1
         , is_logic_same_day/1     %% 是否同一个逻辑天
         , is_logic_same_day/2   %% 是否同一个逻辑天
         , logic_week_start/0    %% 周逻辑开始时间戳
         , logic_week_start/1
         , logic_diff_days/1     %% 相差逻辑天数
         , logic_diff_days/2
         , logic_day_of_week/0  %% 获得逻辑星期
         , logic_day_of_week/1
         , get_logic_day_time_info/0  %% 获得逻辑天数信息
         , get_logic_day_time_info/1
        ]).

%% 逻辑天偏移
-define(LOGIC_OFFSET_HOUR,            4).  %% 天数逻辑偏移小时
-define(LOGIC_OFFSET_SECONDS,         (?LOGIC_OFFSET_HOUR*3600)).

%% 是否同一刷新天（今天凌晨4点到次日凌晨4点为一刷新天）
is_logic_same_day(Timestamp) ->
    NowTime                 = utime:unixtime(),
    ZeroTime                = utime:unixdate(NowTime),
    FourClock               = ZeroTime + ?LOGIC_OFFSET_SECONDS, %% 改成4点清理
    YesterDayThreeClock     = FourClock - ?ONE_DAY_SECONDS,
    TomorrowDayThreeClock   = FourClock + ?ONE_DAY_SECONDS,
    if
        Timestamp < YesterDayThreeClock orelse Timestamp >= TomorrowDayThreeClock -> false;
        NowTime < FourClock andalso Timestamp < FourClock -> true;
        NowTime >= FourClock andalso Timestamp >= FourClock -> true;
        true -> false
    end.

is_logic_same_day(Timestamp1, Timestamp2) ->
    ZeroTime1               = utime:unixdate(Timestamp1),
    ThreeClock1             = ZeroTime1 + ?LOGIC_OFFSET_HOUR*3600,
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
    NowTime = utime:unixtime(),
    get_logic_day_time_info(NowTime).

%% 计算4点偏差
get_logic_day_time_info(Timestamp) ->
    ZeroTime = utime:unixdate(Timestamp),
    %% 今天4点
    FourClock = ZeroTime + ?LOGIC_OFFSET_HOUR*3600,
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
    get_logic_day_start_time(utime:unixtime()).

get_logic_day_start_time(Timestamp) ->
    {FourClock, _ZeroTime, _NextFourClock} = get_logic_day_time_info(Timestamp),
    FourClock.

%% 逻辑相差天数
logic_diff_days(UnixTime) ->
    Now = utime:unixtime(),
    logic_diff_days(UnixTime, Now).

logic_diff_days(UnixTime1, UnixTime2) ->
    StartTime1 = get_logic_day_start_time(UnixTime1),
    StartTime2 = get_logic_day_start_time(UnixTime2),
    utime:diff_days(StartTime1, StartTime2).

%% 周到逻辑开始时间戳
logic_week_start() ->
    Now = utime:unixtime(),
    logic_week_start(Now).

logic_week_start(Unixtime) ->
    ZeroTime = utime:unixdate(Unixtime),
    FourClock = ZeroTime+?LOGIC_OFFSET_HOUR*3600,
    Week = utime:day_of_week(Unixtime),
    case Week == 1 andalso Unixtime < FourClock of
        true -> ZeroTime-?ONE_WEEK_SECONDS+?LOGIC_OFFSET_HOUR*3600;
        false -> ZeroTime-(Week-1)*?ONE_DAY_SECONDS+?LOGIC_OFFSET_HOUR*3600
    end.

%% 获得逻辑星期
logic_day_of_week() ->
    utime:day_of_week(get_logic_day_start_time()).
logic_day_of_week(Timestamp) ->
    utime:day_of_week(Timestamp).