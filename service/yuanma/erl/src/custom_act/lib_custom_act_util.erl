%%-----------------------------------------------------------------------------
%% @Module  :       lib_custom_act_util
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-06
%% @Description:    定制活动工具类
%%-----------------------------------------------------------------------------
-module(lib_custom_act_util).

-include("custom_act.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_goods.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([
    get_act_cfg_info/2
    , get_act_reward_cfg_info/3
    , get_subtype_list/1
    , get_custom_act_open_list/0
    , get_open_subtype_list/1
    , get_open_subtype_list/2
    , get_act_time_range_by_type/2
    , get_act_time_range/2
    , format_time/1
    , format_time/2
    , make_check_args_map/0
    , make_check_args_map/1
    , get_custom_act_open_info/2
    , get_act_reward_grade_list/2
    , in_same_clear_day/4
    , reward_in_same_clear_day/5
    , reward_in_same_clear_day/3
    , count_act_reward/3
    , count_act_reward/2
    , count_act_reward_last_day/3         % 第二日补发奖励计算
    , count_act_reward_last_day/4         % 第二日补发奖励计算
    , keyfind_act_condition/3
    , keyfind_act_condition2/2
    , get_act_name/2
    , get_act_logic_stime/1
    , calc_clear_time/3
    , get_real_goodstypeid/2
    ]).

%%--------------------------------------------------
%% 获取活动配置信息
%% @param  Type    活动主类型
%% @param  SubType 活动子类型
%% @return         #custom_act_cfg{}|[]
%%--------------------------------------------------
get_act_cfg_info(Type, SubType) ->
    case SubType < ?EXTRA_CUSTOM_ACT_SUB_ADD of
        true ->
            case data_custom_act_extra:get_switch(?CUSTOM_ACT_NORMAL) of
                ?CUSTOM_ACT_SWITCH_OPEN ->
                    data_custom_act:get_act_info(Type, SubType);
                _ ->
                    []
            end;
        _ ->
            case data_custom_act_extra:get_switch(?CUSTOM_ACT_EXTRA) of
                ?CUSTOM_ACT_SWITCH_OPEN ->
                    data_custom_act_extra:get_act_info(Type, SubType - ?EXTRA_CUSTOM_ACT_SUB_ADD);
                _ ->
                    []
            end
    end.

%%--------------------------------------------------
%% 获取活动奖励
%% @param  Type    活动主类型
%% @param  SubType 活动子类型
%% @param  Grade   奖励档次
%% @return         #custom_act_reward_cfg{}|[]
%%--------------------------------------------------
get_act_reward_cfg_info(Type, SubType, Grade) ->
    case SubType < ?EXTRA_CUSTOM_ACT_SUB_ADD of
        true ->
            case data_custom_act_extra:get_switch(?CUSTOM_ACT_NORMAL) of
                ?CUSTOM_ACT_SWITCH_OPEN ->
                    data_custom_act:get_reward_info(Type, SubType, Grade);
                _ ->
                    []
            end;
        _ ->
            case data_custom_act_extra:get_switch(?CUSTOM_ACT_EXTRA) of
                ?CUSTOM_ACT_SWITCH_OPEN ->
                    data_custom_act_extra:get_reward_info(Type, SubType - ?EXTRA_CUSTOM_ACT_SUB_ADD, Grade);
                _ ->
                    []
            end
    end.

%%--------------------------------------------------
%% 获取活动所有档次奖励id
%% @param  Type    活动主类型
%% @param  SubType 活动子类型
%% @return         [grade]
%%--------------------------------------------------
get_act_reward_grade_list(Type, SubType) ->
    case SubType < ?EXTRA_CUSTOM_ACT_SUB_ADD of
        true ->
            case data_custom_act_extra:get_switch(?CUSTOM_ACT_NORMAL) of
                ?CUSTOM_ACT_SWITCH_OPEN ->
                    data_custom_act:get_reward_grade_list(Type, SubType);
                _ ->
                    []
            end;
        _ ->
            case data_custom_act_extra:get_switch(?CUSTOM_ACT_EXTRA) of
                ?CUSTOM_ACT_SWITCH_OPEN ->
                    data_custom_act_extra:get_reward_grade_list(Type, SubType - ?EXTRA_CUSTOM_ACT_SUB_ADD);
                _ ->
                    []
            end
    end.

%% 获取主类型下的子类型列表
get_subtype_list(Type) ->
    List1 = case data_custom_act_extra:get_switch(?CUSTOM_ACT_NORMAL) of
        ?CUSTOM_ACT_SWITCH_OPEN ->
            data_custom_act:get_act_subtype(Type);
        _ ->
            []
    end,
    List2 = case data_custom_act_extra:get_switch(?CUSTOM_ACT_EXTRA) of
        ?CUSTOM_ACT_SWITCH_OPEN ->
            [TmpId + ?EXTRA_CUSTOM_ACT_SUB_ADD || TmpId <- data_custom_act_extra:get_act_subtype(Type)];
        _ ->
            []
    end,
    List1 ++ List2.

%%--------------------------------------------------
%% 获取开启中的活动列表
%% @return [#act_info{}]
%%--------------------------------------------------
get_custom_act_open_list() ->
    NowTime = utime:unixtime(),
    Mspec = ets:fun2ms(fun(#act_info{etime = Etime} = T) when NowTime < Etime ->
        T
    end),
    ets:select(?ETS_CUSTOM_ACT, Mspec).

%%--------------------------------------------------
%% 获取活动开启信息
%% @return #act_info{}|false
%%--------------------------------------------------
get_custom_act_open_info(Type, SubType) ->
    case ets:lookup(?ETS_CUSTOM_ACT, {Type, SubType}) of
        [ActInfo|_] when is_record(ActInfo, act_info) ->
            ActInfo;
        _ -> false
    end.

%%--------------------------------------------------
%% 获取当前主类型开启的活动列表
%% @param  Type 活动主类型
%% @return      [#act_info{}]
%%--------------------------------------------------
get_open_subtype_list(Type) ->
    NowTime = utime:unixtime(),
    get_open_subtype_list(Type, NowTime).

get_open_subtype_list(Type, NowTime) ->
    Mspec = ets:fun2ms(fun(#act_info{key = {_Type, _Subtype}, etime = Etime} = T) when Type =:= _Type, NowTime < Etime ->
        T
    end),
    List = ets:select(?ETS_CUSTOM_ACT, Mspec),
    F = fun(#act_info{key = {_, ASubtype}}, #act_info{key = {_, BSubtype}}) ->
        ASubtype =< BSubtype
    end,
    lists:sort(F, List).

%%--------------------------------------------------
%% 获取活动开启的时间范围
%% @param  Type    活动主类型
%% @param  SubType 活动子类型
%% @return         description
%%--------------------------------------------------
get_act_time_range_by_type(Type, SubType) ->
    case get_act_cfg_info(Type, SubType) of
        ActInfo when is_record(ActInfo, custom_act_cfg) ->
            ArgsMap = make_check_args_map(),
            get_act_time_range(ActInfo, ArgsMap);
        _ ->
            false
    end.

%%--------------------------------------------------
%% 获取活动开启的时间范围
%% @param  ActInfo #custom_act_cfg{}
%% @param  ArgsMap #{}
%% @return         {Stime, Etime}
%%--------------------------------------------------
get_act_time_range(ActInfo, ArgsMap) ->
    #custom_act_cfg{
        opday_lim = OpdayLim,
        merday_lim = MerdayLim,
        wlv_lim = WLvLim,
        open_start_time = OpenStartTime,
        open_end_time = OpenEndTime
    } = ActInfo,
    #{opday := Opday, merday := MergeDay, wlv := WLv, cur_open_time := CurOpenTime} = ArgsMap,
    CheckList = [{cur_open_time_lim, OpenStartTime, OpenEndTime, CurOpenTime},{opday_lim, OpdayLim, Opday}, {merday_lim, MerdayLim, MergeDay}, {wlv_lim, WLvLim, WLv}],
    case lib_custom_act_check:check_list(CheckList) of
        true -> do_get_act_time_range(ActInfo, ArgsMap);
        _ -> false
    end.

do_get_act_time_range(#custom_act_cfg{optype = ?OPEN_TYPE_SPECIFY_TIME} = ActInfo, ArgsMap) ->
    #custom_act_cfg{
        opday_lim = OpdayLim, merday_lim = MerdayLim,
        start_time = Stime, end_time = Etime
    } = ActInfo,
    IsCls = util:is_cls(),
    #{opday := Opday, merday := MergeDay} = ArgsMap,
    case OpdayLim =/= [] andalso not IsCls of
        true ->
            {MinOpdayLim, MaxOpdayLim} = ulists:is_in_range(OpdayLim, Opday),
            OpTime = util:get_open_time(),
            OpUnixDate = utime:unixdate(OpTime),
            OpdayTimeLim = [{OpUnixDate + (MinOpdayLim - 1) * 86400, OpUnixDate + MaxOpdayLim * 86400 - 1}];
        false -> OpdayTimeLim = []
    end,
    case MerdayLim =/= [] andalso not IsCls of
        true ->
            {MinMerdayLim, MaxMerdayLim} = ulists:is_in_range(MerdayLim, MergeDay),
            MergeTime = util:get_merge_time(),
            MergeUnixDate = utime:unixdate(MergeTime),
            MerdayTimeLim = [{MergeUnixDate + (MinMerdayLim - 1) * 86400, MergeUnixDate + MaxMerdayLim * 86400 - 1}];
        false -> MerdayTimeLim = []
    end,
    TimeLimL = OpdayTimeLim ++ MerdayTimeLim ++ [{Stime, Etime}],
    StL = [St || {St, _} <- TimeLimL, St > 0],
    EtL = [Et || {_, Et} <- TimeLimL, Et > 0],
    case StL =/= [] andalso EtL =/= [] of
        true ->
            {lists:max(StL), lists:min(EtL)};
        false -> false
    end;
do_get_act_time_range(#custom_act_cfg{optype = ?OPEN_TYPE_WEEK} = ActInfo, ArgsMap) ->
    #custom_act_cfg{
        opday = OpDay,
        optime = OpTime
    } = ActInfo,
    #{time := NowTime, unixdate := UnixDate, week := Week} = ArgsMap,
    case OpDay =:= [] orelse lists:member(Week, OpDay) of
        true ->
            case OpTime =/= [] of
                true ->
                    OpTimeL = lib_custom_act_util:format_time(OpTime, UnixDate),
                    case ulists:is_in_range(OpTimeL, NowTime) of
                        {Stime, Etime} when NowTime < Etime ->
                            {Stime, Etime};
                        _ ->
                           false
                    end;
                false ->
                    {UnixDate, UnixDate + ?ACT_DURATION_ONE_DAY}
            end;
        false -> false
    end;
do_get_act_time_range(#custom_act_cfg{optype = ?OPEN_TYPE_MONTH} = ActInfo, ArgsMap) ->
    #custom_act_cfg{
        opday = OpDay,
        optime = OpTime
    } = ActInfo,
    #{time := NowTime, unixdate := UnixDate, date := Date} = ArgsMap,
    {{_Y, _M, D}, _} = Date,
    case OpDay =:= [] orelse lists:member(D, OpDay) of
        true ->
            case OpTime =/= [] of
                true ->
                    OpTimeL = lib_custom_act_util:format_time(OpTime, UnixDate),
                    case ulists:is_in_range(OpTimeL, NowTime) of
                        {Stime, Etime} when NowTime < Etime ->
                            {Stime, Etime};
                        _ ->
                           false
                    end;
                false ->
                    {UnixDate, UnixDate + ?ACT_DURATION_ONE_DAY}
            end;
        false -> false
    end;
do_get_act_time_range(#custom_act_cfg{optype = ?OPEN_TYPE_SPECIFY_DATE} = ActInfo, ArgsMap) ->
    #custom_act_cfg{
        opday = OpDay,
        optime = OpTime
    } = ActInfo,
    #{time := NowTime, unixdate := UnixDate, date := Date} = ArgsMap,
    {YMD, _} = Date,
    case OpDay =:= [] orelse lists:member(YMD, OpDay) of
        true ->
            case OpTime =/= [] of
                true ->
                    OpTimeL = lib_custom_act_util:format_time(OpTime, UnixDate),
                    case ulists:is_in_range(OpTimeL, NowTime) of
                        {Stime, Etime} when NowTime < Etime ->
                            {Stime, Etime};
                        _ ->
                           false
                    end;
                false ->
                    {UnixDate, UnixDate + 86400}
            end;
        false -> false
    end;
do_get_act_time_range(#custom_act_cfg{optype = ?OPEN_TYPE_CONTINUOUS_WEEK} = ActInfo, ArgsMap) ->
    #custom_act_cfg{
        opday = OpDay
    } = ActInfo,
    #{time := NowTime, unixdate := UnixDate, week := Week} = ArgsMap,
    case lists:member(Week, OpDay) of
        true ->
            case utime:is_continuous_week(OpDay) of
                true ->
                    CurWeek = utime:day_of_week(NowTime),
                    {StartSpace, EndSpace} = count_week_space(OpDay, CurWeek, false, 0, 0),
                    {UnixDate - StartSpace * ?ONE_DAY_SECONDS, UnixDate + EndSpace * ?ONE_DAY_SECONDS + ?ACT_DURATION_ONE_DAY};
                _ -> false
            end;
        false -> false
    end;
do_get_act_time_range(#custom_act_cfg{optype = ?OPEN_TYPE_OPEN_DAY} = ActInfo, ArgsMap) ->
    #custom_act_cfg{
        opday = OpDay
    } = ActInfo,
    #{time := _NowTime, unixdate := UnixDate, opday := Openday} = ArgsMap,
    case OpDay of
        [{StartOpenDay, DayGap, DuraDays}] ->
            DValOpenday = Openday - StartOpenDay,
            case DValOpenday >= 0 of
                true ->
                    RemDay = DValOpenday rem DayGap,
                    case RemDay >= 0 andalso RemDay < DuraDays of
                        true ->
                            STime = UnixDate - RemDay*?ONE_DAY_SECONDS,
                            ETime = STime + DuraDays*?ONE_DAY_SECONDS - 1,
                            {STime, ETime};
                        _ ->
                           false
                    end;
                _ ->
                    false
            end;
        _ -> false
    end;
do_get_act_time_range(#custom_act_cfg{ optype = ?OPEN_TYPE_DAYS_APART } = ActInfo, ArgsMap) ->
    #custom_act_cfg{
        opday = OpDay, start_time = StartTime, end_time = EndTime
    } = ActInfo,
    #{time := NowTime, unixdate := _UnixDate } = ArgsMap,
    case OpDay of
        [] ->
            false;
        _ ->
            case NowTime >= StartTime andalso NowTime =< EndTime of
                true ->
                    {Gap, LastDay} = hd(OpDay),
                    FixGapDay = Gap + 1,
                    Div = (NowTime - StartTime) div ?ONE_DAY_SECONDS,
                    case Div rem FixGapDay of
                        0 ->
                            STime = StartTime + ?ONE_DAY_SECONDS * Div,
                            ETime = STime + ?ONE_DAY_SECONDS * LastDay,
                            case ETime > EndTime of
                                true ->
                                    false;
                                _ ->
                                    {STime, ETime}
                            end;
                        _ ->
                            false
                    end;
                _ ->
                    false
            end
    end.

%% 计算OPEN_TYPE_CONTINUOUS_WEEK模式定制活动的开始周/结束周到当前周的间隔
count_week_space([], _CurWeek, _IsConfirmStart, StartSpace, EndSpace) -> {StartSpace, EndSpace};
count_week_space([Week|WeekL], CurWeek, IsConfirmStart, StartSpace, EndSpace) ->
    case Week == CurWeek of
        true ->
            count_week_space(WeekL, CurWeek, true, StartSpace, 0);
        false ->
            case IsConfirmStart of
                true ->
                    count_week_space(WeekL, CurWeek, IsConfirmStart, StartSpace, EndSpace + 1);
                _ ->
                    count_week_space(WeekL, CurWeek, IsConfirmStart, StartSpace + 1, EndSpace)
            end
    end.

%% 构建参数Map
make_check_args_map() ->
    NowTime = utime:unixtime(),
    make_check_args_map(NowTime).

make_check_args_map(NowTime) ->
    UnixDate = utime:unixdate(NowTime),
    Opday = util:get_open_day(NowTime),
    MergeDay = util:get_merge_day(NowTime),
    Week = utime:day_of_week(NowTime),
    Date = utime:unixtime_to_localtime(NowTime),
    CurOpenTime = util:get_cur_open_time(),
    WLv = util:get_world_lv(),
    #{time => NowTime, unixdate => UnixDate, opday => Opday, merday => MergeDay,  week => Week, date => Date, cur_open_time => CurOpenTime, wlv => WLv}.

%% 格式化开启的时间段
%% return 时间点对应当天0点的偏移值组成的列表
format_time(TimeL) ->
    [{SH * 3600 + SM * 60 + SS, EH * 3600 + EM * 60 + ES}||{{SH, SM, SS}, {EH, EM, ES}} <- TimeL].

%% 格式化开启的时间段
%% return 当天时间点对应的时间戳组成的列表
format_time(TimeL, NowTime) ->
    [{NowTime + SH * 3600 + SM * 60 + SS, NowTime + EH * 3600 + EM * 60 + ES}||{{SH, SM, SS}, {EH, EM, ES}} <- TimeL].

%%--------------------------------------------------
%% 判断是否在同一逻辑清理天内
%% 比如活动凌晨4点清理,当天4点到明天4点都属于同一天
%% @param  Type    活动主类型
%% @param  SubType 活动子类型
%% @param  Time1   时间戳
%% @param  Time2   时间戳
%% @return         description
%%--------------------------------------------------
in_same_clear_day(Type, SubType, Time1, Time2) ->
    case get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{clear_type = ClearType} ->
            case ClearType of
                ?CUSTOM_ACT_CLEAR_ZERO ->
                    OffSetVal = 0,
                    utime:is_same_day(max(0, Time1 - OffSetVal), max(0, Time2 - OffSetVal));
                ?CUSTOM_ACT_CLEAR_FOUR ->
                    OffSetVal = 4 * 3600,
                    utime:is_same_day(max(0, Time1 - OffSetVal), max(0, Time2 - OffSetVal));
                _ ->
                    true
            end;
        _ -> true
    end.

%% 奖励是否同一天清理
reward_in_same_clear_day(Type, SubType, GradeId, Time1, Time2) ->
    RewardCfg = get_act_reward_cfg_info(Type, SubType, GradeId),
    reward_in_same_clear_day(RewardCfg, Time1, Time2).

%% 奖励是否同一天清理
reward_in_same_clear_day(#custom_act_reward_cfg{condition = Conditions}, Time1, Time2) ->
    case lib_custom_act_check:check_act_condtion([clear_type], Conditions) of
        [?CUSTOM_ACT_CLEAR_ZERO] ->
            OffSetVal = 0,
            utime:is_same_day(max(0, Time1 - OffSetVal), max(0, Time2 - OffSetVal));
        [?CUSTOM_ACT_CLEAR_FOUR] ->
            OffSetVal = 4 * 3600,
            utime:is_same_day(max(0, Time1 - OffSetVal), max(0, Time2 - OffSetVal));
        _ ->
            true
    end;
reward_in_same_clear_day(_RewardCfg, _Time1, _Time2) ->
    true.

%%--------------------------------------------------
%% 依据清理类型获取清理时间
%% 比如活动凌晨4点清理,清理时间为前一天凌晨4点
%% @param  Type    活动主类型
%% @param  SubType 活动子类型
%% @param  Time1   时间戳
%% @param  Time2   时间戳
%% @return         description
%%--------------------------------------------------
calc_clear_time(Type, SubType, Time) ->
    Zero = utime:unixdate(Time),
    case get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{clear_type = ClearType} ->
            case ClearType of
                ?CUSTOM_ACT_CLEAR_ZERO ->
                    Zero - 86400;
                ?CUSTOM_ACT_CLEAR_FOUR ->
                    Zero - 86400 + 4*3600;
                _ ->
                    0
            end;
        _ -> 0
    end.

%%--------------------------------------------------
%% 获取活动逻辑开始时间
%% 比如活动配置0点清理，则取当天0点作为新开始时间
%% @return         description
%%--------------------------------------------------
get_act_logic_stime(ActInfo) ->
    #act_info{key = {Type, SubType}, stime = Stime} = ActInfo,
    case get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{clear_type = ClearType} ->
            case ClearType of
                ?CUSTOM_ACT_CLEAR_ZERO ->
                    utime:unixdate();
                ?CUSTOM_ACT_CLEAR_FOUR ->
                    utime:get_logic_day_start_time();
                _ ->
                    Stime
            end;
        _ -> Stime
    end.

%% 计算定制活动的奖励
count_act_reward(_Player, _ActInfo, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_COMMON} = RewardCfg) ->
    RewardCfg#custom_act_reward_cfg.reward;
count_act_reward(Player, _ActInfo, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_LV} = RewardCfg) ->
    #player_status{figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    SortL = lists:keysort(1, CandidateList),
    filter_reward(FormatType, SortL, RoleLv, []);
count_act_reward(_Player, _ActInfo, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_RAND} = RewardCfg) ->
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, [], []);
count_act_reward(_Player, #act_info{wlv = WLv}, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_WLV} = RewardCfg) ->
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    SortL = lists:keysort(1, CandidateList),
    filter_reward(FormatType, SortL, WLv, []);
count_act_reward(#player_status{figure = Figure}, _ActInfo, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_SEX} = RewardCfg) ->
    #custom_act_reward_cfg{reward = CandidateList} = RewardCfg,
    case lists:keyfind(Figure#figure.sex, 1, CandidateList) of
        {_Sex, RewardList} -> RewardList;
        _ -> []
    end;
count_act_reward(Player, _ActInfo, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_SPECIFY_LV} = RewardCfg) ->
    #player_status{figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, RoleLv, []);
count_act_reward(_Player, _ActInfo, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_OPEN_DAY} = RewardCfg) ->
    Day = util:get_open_day(),
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, Day, []);
count_act_reward(Player, _ActInfo, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_SPECIFY_LVASEX} = RewardCfg) ->
    #player_status{figure = Figure} = Player,
    #figure{lv = RoleLv, sex = Sex} = Figure,
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, {RoleLv, Sex}, []);
count_act_reward(Player, #act_info{wlv = WLv}, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_SPECIFY_WLVASEX} = RewardCfg) ->
    #player_status{figure = Figure} = Player,
    #figure{sex = Sex} = Figure,
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, {WLv, Sex}, []);
count_act_reward(#player_status{figure = Figure}, _ActInfo, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_CAREER} = RewardCfg) ->
    #custom_act_reward_cfg{reward = CandidateList} = RewardCfg,
    case lists:keyfind(Figure#figure.career, 1, CandidateList) of
        {_Career, RewardList} -> RewardList;
        _ -> []
    end;
count_act_reward(_Player, _ActInfo, _) ->
    [].

%% 用参数计算的奖励
count_act_reward(_, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_COMMON} = RewardCfg) ->
    RewardCfg#custom_act_reward_cfg.reward;
count_act_reward(#reward_param{player_lv = RoleLv}, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_LV} = RewardCfg) ->
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    SortL = lists:keysort(1, CandidateList),
    filter_reward(FormatType, SortL, RoleLv, []);
count_act_reward(_, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_RAND} = RewardCfg) ->
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, [], []);
count_act_reward(#reward_param{wlv = WLv}, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_WLV} = RewardCfg) ->
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    SortL = lists:keysort(1, CandidateList),
    filter_reward(FormatType, SortL, WLv, []);
count_act_reward(#reward_param{sex = Sex}, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_SEX} = RewardCfg) ->
    #custom_act_reward_cfg{reward = CandidateList} = RewardCfg,
    case lists:keyfind(Sex, 1, CandidateList) of
        {_Sex, RewardList} -> RewardList;
        _ -> []
    end;
count_act_reward(#reward_param{player_lv = RoleLv}, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_SPECIFY_LV} = RewardCfg) ->
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, RoleLv, []);
count_act_reward(#reward_param{}, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_OPEN_DAY} = RewardCfg) ->
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, util:get_open_day(), []);
count_act_reward(#reward_param{player_lv = RoleLv, sex = Sex}, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_SPECIFY_LVASEX} = RewardCfg) ->
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, {RoleLv, Sex}, []);
count_act_reward(#reward_param{wlv = WLv, sex = Sex}, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_SPECIFY_WLVASEX} = RewardCfg) ->
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, {WLv, Sex}, []);
count_act_reward(#reward_param{career = Career}, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_CAREER} = RewardCfg) ->
    #custom_act_reward_cfg{reward = CandidateList} = RewardCfg,
    case lists:keyfind(Career, 1, CandidateList) of
        {_Career, RewardList} -> RewardList;
        _ -> []
    end;
count_act_reward(_, _) -> [].

%% 第二天补发奖励计算
count_act_reward_last_day(_, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_OPEN_DAY} = RewardCfg, OldTime) ->
    DiffDay = utime:diff_day(OldTime),
    % 防止负数溢出，防备测试服随便调开服天数找不到数据
    OpenDay = max(util:get_open_day()-DiffDay, 1),
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, OpenDay, []);
count_act_reward_last_day(Param, Cfg, _) -> count_act_reward(Param, Cfg).

count_act_reward_last_day(_Player, _Param, #custom_act_reward_cfg{format = ?REWARD_FORMAT_TYPE_OPEN_DAY} = RewardCfg, OldTime) ->
    DiffDay = utime:diff_day(OldTime),
    % 防止负数溢出，防备测试服随便调开服天数找不到数据
    OpenDay = max(util:get_open_day()-DiffDay, 1),
    #custom_act_reward_cfg{format = FormatType, reward = CandidateList} = RewardCfg,
    filter_reward(FormatType, CandidateList, OpenDay, []);
count_act_reward_last_day(Player, Param, Cfg, _) -> count_act_reward(Player, Param, Cfg).


filter_reward(_, [], _, CurReward) -> CurReward;
filter_reward(?REWARD_FORMAT_TYPE_LV = Type, [{LimLv, T}|L], RoleLv, CurReward) ->
    case RoleLv >= LimLv of
        true ->
            filter_reward(Type, L, RoleLv, T);
        false -> CurReward
    end;
filter_reward(?REWARD_FORMAT_TYPE_RAND = _Type, List, _, _) ->
    case urand:rand_with_weight(List) of
        RewardList when is_list(RewardList) -> RewardList;
        _ -> []
    end;
filter_reward(?REWARD_FORMAT_TYPE_WLV = Type, [{LimLv, T}|L], WLv, CurReward) ->
    case WLv >= LimLv of
        true ->
            filter_reward(Type, L, WLv, T);
        false -> CurReward
    end;
filter_reward(?REWARD_FORMAT_TYPE_SPECIFY_LV = Type, [{[MinLv, MaxLv], T}|L], RoleLv, CurReward) ->
    case RoleLv >= MinLv andalso RoleLv =< MaxLv of
        true -> T;
        false -> filter_reward(Type, L, RoleLv, CurReward)
    end;
filter_reward(?REWARD_FORMAT_TYPE_OPEN_DAY = Type, [{[MinDay, MaxDay], T}|L], NowOpenDay, CurReward) ->
    case NowOpenDay >= MinDay andalso NowOpenDay =< MaxDay of
        true -> T;
        false -> filter_reward(Type, L, NowOpenDay, CurReward)
    end;
filter_reward(?REWARD_FORMAT_TYPE_SPECIFY_LVASEX = Type, [{[MinLv, MaxLv], T}|L], {RoleLv, Sex}, CurReward) ->
    case RoleLv >= MinLv andalso RoleLv =< MaxLv of
        true ->
            case lists:keyfind(Sex, 1, T) of
                {Sex, RewardList} -> RewardList;
                _ -> []
            end;
        false -> filter_reward(Type, L, {RoleLv, Sex}, CurReward)
    end;
filter_reward(?REWARD_FORMAT_TYPE_SPECIFY_WLVASEX = Type, [{[MinLv, MaxLv], T}|L], {WLv, Sex}, CurReward) ->
    case WLv >= MinLv andalso WLv =< MaxLv of
        true ->
            case lists:keyfind(Sex, 1, T) of
                {Sex, RewardList} -> RewardList;
                _ -> []
            end;
        false -> filter_reward(Type, L, {WLv, Sex}, CurReward)
    end;
filter_reward(_, _, _, CurReward) -> CurReward.

%% 查找
%% @return false | {max_lv, MaxLv}...
keyfind_act_condition(Type, SubType, Key) ->
    Config = get_act_cfg_info(Type, SubType),
    case is_record(Config, custom_act_cfg) of
        true -> keyfind_act_condition(Config, Key);
        false -> false
    end.

keyfind_act_condition(Act, Key) when is_record(Act, custom_act_cfg) ->
    keyfind_act_condition(Act#custom_act_cfg.condition, Key);
keyfind_act_condition(Condition, Key) ->
    lists:keyfind(Key, 1, Condition).

%% 根据主类型 返回Value值列表
%% param List [Key, Key]
%% @return [Value,...] | false
keyfind_act_condition2(Type, List) ->
    case lib_custom_act_api:get_open_subtype_ids(Type) of
        [SubType|_] ->
            case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                #custom_act_cfg{condition = Conditions} -> lib_custom_act_check:check_act_condtion(List, Conditions);
                _ -> false
            end;
        _ ->
            false
    end.

get_act_name(Type, SubType) ->
    case get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{name = Name} ->
            util:make_sure_binary(Name);
        _ ->
            <<>>
    end.

get_real_goodstypeid(GoodsTypeId, Gtype) ->
    if
        GoodsTypeId =/= 0 ->
            GoodsTypeId;
        true ->
            if
                Gtype == 1 ->
                    ?GOODS_ID_GOLD;
                Gtype == 2 ->
                    ?GOODS_ID_BGOLD;
                Gtype == 3 ->
                    ?GOODS_ID_COIN;
                true ->
                    0
            end
    end.
