%% ---------------------------------------------------------------------------
%% @doc lib_cycle_rank_api

%% @author  lianghaihui
%% @email   1457863678@qq.com
%% @since   2022/03/18
%% @desc    循环冲榜##配置表操作函数
%% ---------------------------------------------------------------------------

-module(lib_cycle_rank_cfg).

%% API
-compile(export_all).


-include("common.hrl").
-include("cycle_rank.hrl").
-include("def_fun.hrl").

get_open_cycle_rank_info() ->
    CycleRankList = data_cycle_rank:get_all_cycle_rank_list(),
    case CycleRankList of
        [] -> [];
        _ ->
            InitList = do_get_open_cycle_rank_info(CycleRankList, [], []),
            NowSec = utime:unixtime(),
            Fun = fun(#base_cycle_rank_info{ end_time = EndTime } = RankInfo) ->
                Flag = EndTime >= NowSec,  %% 结束时间大于现在的未过期的数据需要保留
                Flag2 = not lib_cycle_rank_util:is_kf_clear(RankInfo), %% 保留可能到期但处于展示期间的活动数据
                Flag orelse Flag2
            end,
            NewInitList = lists:filter(Fun, InitList),
            if
                NewInitList == [] ->
                    [];
                true ->
                    lists:keysort(#base_cycle_rank_info.start_time, NewInitList)
            end
    end.

do_get_open_cycle_rank_info([], _HasInitSubTypeL, AccL) ->
    AccL;
do_get_open_cycle_rank_info([{Type, SubType}|Tail], HasInitSubTypeL, OpenAccL) ->
    CycleOrder = data_cycle_rank:get_kv_cfg(cycle_order),
    SortRankList = proplists:get_value(SubType, CycleOrder, []),
    case SortRankList == [] orelse lists:member(SubType, HasInitSubTypeL) of
        true ->
            do_get_open_cycle_rank_info(Tail, HasInitSubTypeL, OpenAccL);
        _ ->
            %% 子类型的开始结束时间
            #base_cycle_rank_info{ start_time = StartTime, end_time = EndTime } = data_cycle_rank:get_cycle_rank_info(Type, SubType),
            DiffSec = EndTime - StartTime,
            TimeLen = round(DiffSec/?ONE_DAY_SECONDS),
            SortRankLen = erlang:length(SortRankList),
            BaseBanTimeSec = case data_cycle_rank:get_kv_cfg(ban_update_time) of
                                 Num when is_integer(Num) -> Num;
                                 _ -> 79200
                             end,
            Fun2 = fun(DaySort, AccL) ->
                Rem = DaySort rem SortRankLen,
                FixType = ?IF( Rem == 0, lists:nth(SortRankLen, SortRankList), lists:nth(Rem, SortRankList)),
                case data_cycle_rank:get_cycle_rank_info(FixType, SubType) of
                    #base_cycle_rank_info{ } = ActInfo ->
                        FixStartTime = StartTime + 86400 * (DaySort - 1),
                        FixEndTime = FixStartTime + 86399,   %% 计算结束时间 与策划确定只能为1天
                        BanTime = FixStartTime + BaseBanTimeSec,             %% 每天十点，这里写死,
                        NewActInfo = ActInfo#base_cycle_rank_info{
                            id = {FixType, SubType},
                            start_time = FixStartTime,
                            end_time = FixEndTime,
                            banned_time = BanTime
                        },
                        [NewActInfo|AccL];
                    _ ->
                        AccL
                end
            end,
            SubTypeOpenActL = lists:foldl(Fun2, OpenAccL, lists:seq(1, TimeLen)),
            do_get_open_cycle_rank_info(Tail, [SubType|HasInitSubTypeL], SubTypeOpenActL)
    end.

%% 根据当前时间计算处于开放期间的活动、与处于展示
%% 与运营再三确认过，一天只会有一个活动开启，一个活动展示
%% 新版本逻辑，节省性能版本，定时计算更新最新的活动信息
calc_open_and_show_activity() ->
   CycleOrderL = data_cycle_rank:get_kv_cfg(new_cycle_order),
   case CycleOrderL of
       []->
           {[], [], [], false};
       _ ->
           NowUnixDate = utime:standard_unixdate(),
           case data_cycle_rank:get_kv_cfg(ban_update_time) of
               Num when is_integer(Num) ->
                   BaseBanTimeSec = Num;
               _ ->
                   BaseBanTimeSec = 79200
           end,
           Fun = fun({SubType, OrderL, OrderStartTime, OrderEndTime}, {OpenActL, ShowActL, ReadyOpenL, IsNeedNewOrder}) ->
               AllTypeLen = erlang:length(OrderL),
               TemNowTimes = NowUnixDate - ?ONE_DAY_SECONDS,
               if
                   NowUnixDate >= OrderStartTime andalso NowUnixDate < OrderEndTime ->
                       %% 当前时间在该子类型的循环期间才会有活动开启
                       ActOpenInfo = do_calc_act_info(act_open, SubType, NowUnixDate, BaseBanTimeSec, AllTypeLen, OrderStartTime, OrderL),
                       NewActOpenL = ?IF( ActOpenInfo == none, OpenActL, [ActOpenInfo|OpenActL]),
                       %% 当前时间的前一天的活动信息(一般都是处于展示期间的活动)
                       %% 需要注意这里只算当前时间对应的正在开启展示期间的活动
                       BeforeActInfo = do_calc_act_info(act_before, SubType, NowUnixDate, BaseBanTimeSec, AllTypeLen, OrderStartTime, OrderL),
                       NewShowActL = ?IF( BeforeActInfo == none, ShowActL, [BeforeActInfo|ShowActL]),
                       %% 当前时间的下一天的活动信息（一般是即将开启的新活动）
                       case ActOpenInfo of
                           #base_cycle_rank_info{ end_time = CurEndTime } when (CurEndTime + ?ONE_DAY_SECONDS) > OrderEndTime ->
                               NewReadyOpenL = ReadyOpenL, NewIsNeedNewOrder = true;
                           _ ->
                               NextActOpenInfo = do_calc_act_info(act_next, SubType, NowUnixDate, BaseBanTimeSec, AllTypeLen, OrderStartTime, OrderL),
                               NewReadyOpenL = ?IF( NextActOpenInfo == none, ReadyOpenL, [NextActOpenInfo|ReadyOpenL]),
                               NewIsNeedNewOrder = false
                       end,
                       {NewActOpenL, NewShowActL, NewReadyOpenL, NewIsNeedNewOrder};
                   NowUnixDate >= OrderEndTime andalso (TemNowTimes >= OrderStartTime andalso TemNowTimes < OrderEndTime) ->
                       %% 只计算前一天的展示活动
                       BeforeActInfo = do_calc_act_info(act_before_yesterday, SubType, NowUnixDate, BaseBanTimeSec, AllTypeLen, OrderStartTime, OrderL),
                       NewShowActL = ?IF( BeforeActInfo == none, ShowActL, [BeforeActInfo|ShowActL]),
                       {OpenActL, NewShowActL, ReadyOpenL, IsNeedNewOrder};
                   IsNeedNewOrder ->
                       if
                           OpenActL == [] ->
                               ActOpenInfo = do_calc_act_info(act_open_new_round, SubType, NowUnixDate, BaseBanTimeSec, AllTypeLen, OrderStartTime, OrderL),
                               NewActOpenL = ?IF( ActOpenInfo == none, OpenActL, [ActOpenInfo|OpenActL]);
                           true ->
                               NewActOpenL = OpenActL
                       end,
                       if
                           ReadyOpenL == [] ->
                               NextActOpenInfo = do_calc_act_info(act_next_new_round, SubType, NowUnixDate, BaseBanTimeSec, AllTypeLen, OrderStartTime, OrderL),
                               NewReadyOpenL = ?IF( NextActOpenInfo == none, ReadyOpenL, [NextActOpenInfo|ReadyOpenL]);
                           true ->
                               NewReadyOpenL = ReadyOpenL
                       end,
                       if
                           ShowActL == [] ->
                               BeforeActInfo = do_calc_act_info(act_before_new_round, SubType, NowUnixDate, BaseBanTimeSec, AllTypeLen, OrderStartTime, OrderL),
                               NewShowActL = ?IF( BeforeActInfo == none, ShowActL, [BeforeActInfo|ShowActL]);
                           true ->
                               NewShowActL = ShowActL
                       end,
                       {NewActOpenL, NewShowActL, NewReadyOpenL, false};
                   true ->
                       {OpenActL, ShowActL, ReadyOpenL, IsNeedNewOrder}
               end
           end,
           lists:foldl(Fun, {[], [], [], false}, CycleOrderL)
   end.

do_calc_act_info(CalcActType, SubType, NowUnixDate, BaseBanTimeSec, AllTypeLen, OrderStartTime, OrderL) ->
    case CalcActType of
        act_open ->
            DiffDay = utime:diff_days(OrderStartTime, NowUnixDate) + 1;  %% 这里自己算距离当天凌晨之前的天数，要计算到当天的，需要+1;
        act_next ->
            DiffDay = utime:diff_days(OrderStartTime, NowUnixDate) + 1 + 1;
        act_before ->
            DiffDay = utime:diff_days(OrderStartTime, NowUnixDate);
        act_next_new_round ->
            DiffDay = 1;
        act_open_new_round ->
            DiffDay = 0;
        act_before_new_round ->
            DiffDay = 0;
        act_before_yesterday ->
            DiffDay = utime:diff_days(OrderStartTime, NowUnixDate)
    end,
    if
        DiffDay == 0 ->
            none ;
        true ->
            Rem = DiffDay rem AllTypeLen,
            ActType = ?IF(Rem == 0, lists:nth(AllTypeLen, OrderL), lists:nth(Rem, OrderL)),
            case data_cycle_rank:get_cycle_rank_info(ActType, SubType) of
                #base_cycle_rank_info{ } = ActInfo ->
                    ActStartTime = OrderStartTime + (DiffDay - 1) * ?ONE_DAY_SECONDS,
                    ActEndTime = ActStartTime + ?ONE_DAY_SECONDS - 1,
                    ActBanTime = ActStartTime + BaseBanTimeSec,
                    ActInfo#base_cycle_rank_info{
                        id = {ActType, SubType},
                        start_time = ActStartTime,
                        end_time =ActEndTime,
                        banned_time = ActBanTime
                    };
                _ ->
                    none
            end
    end.




