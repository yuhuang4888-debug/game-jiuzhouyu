%%%-----------------------------------
%%% @Module  : lib_rush_shop_data
%%% @Author  : ngq
%%% @Email   : ngq_scut@126.com
%%% @Created : 2015.07.13
%%% @Description: 抢购商城数据
%%%-----------------------------------
-module(lib_rush_shop_data).

-include("common.hrl").
-include("rush_shop.hrl").
-include("custom_act.hrl").

%% 定制活动的结构配置
% -record(custom_act_info, {
%         type = 0,                       %% 活动主类型
%         subtype = 0,                    %% 活动子类型
%         show_id = 0,                    %% 展示id
%         name = "",                      %% 活动名字
%         desc = "",                      %% 活动描述
%         is_open = 0,                    %% 总开关标志位（1:开,0:关） - 无效开关
%         open_switch = 0,                %% 开服的开关（1:开,0:关） - 如果是开服,且开,就用[open_begin,open_end,start_time,end_time]
%         open_begin = 0,                 %% 开服时段开始天数
%         open_end = 0,                   %% 开服时段结束天数
%         merge_switch = 0,               %% 合服的开关（1:开,0:关） - 如果是合服,且开,就用[merge_begin,merge_end,start_time,end_time]
%         merge_begin = 0,                %% 合服时段开始天数
%         merge_end = 0,                  %% 合服时段结束天数
%         act_time_switch = 0,            %% 活动时间的开关（1:开,0:关） - 无效开关
%         start_time = 0,                 %% 活动开始时间
%         end_time = 0,                   %% 活动结束时间
%         condition = [],                 %% 条件 ,见 lib_custom_act_util底部
%         clear_rule = []                 %% 清理规则 [{three_clock, Value(1:清理,0:不清理)}|{zero_clock, Value(1:清理,0:不清理)}]
%     }).

-export([
    load_role_data/1,
    init_all/0,
    delete_db_data/1,
    get_update/0,
    set_update/1,
    save_buy/4
]).
-compile(export_all).
%% @doc 加载玩家抢购商城每日信息
load_role_data(RoleID) ->
    Sql = io_lib:format(?RUSH_SHOP_BUY_LOG_SELECT, [RoleID]),
    db:get_all(Sql).

%% @doc 初始化抢购商城进程数据
init_all() ->
    Now = utime:unixtime(),
    All = data_rush_shop:get_all_goods(),
    List = [list_to_tuple(One) || One <- db:get_all(?RUSH_SHOP_SELECT)],
    {DelList, SellList, WaitList, Records} =
        init_goods(All, Now, List, [], [], [], []),
    %% 移除超时商品
    delete_db_data(DelList),
    %% 上架商品设置
    case WaitList of
        [{_, AddTime, _} | _] ->
            AddTimer = erlang:send_after((AddTime - Now) * 1000, self(), 'add');
        _ ->
            AddTimer = 0
    end,
    %% 下架商品设置
    case SellList of
        [{_, _, DelTime} | _] ->
            DelTimer = erlang:send_after((DelTime - Now) * 1000, self(), 'del');
        _ ->
            DelTimer = 0
    end,
    #rush_shop{
        selling = SellList
        , wait = WaitList
        , add_timer = AddTimer
        , del_timer = DelTimer
        , old_records = Records
        , check_timer = erlang:send_after(60000, self(), 'check')
    }.

init_goods([ID | T], Now, List, DelList, SellList, WaitList, Records) ->
    GoodsInfo = #rush_shop_goods{} = data_rush_shop:get_goods_info(ID),
    NewRecords = [GoodsInfo | Records],
    case get_goods_time_range(GoodsInfo) of
        {StartTime, EndTime} when Now >= StartTime andalso Now < EndTime ->
            case lists:keyfind(ID, 1, List) of
                {_, DoneNum, Time} ->
                    case Time < StartTime orelse Time > EndTime of %% 重置超出时间段的数量
                        true ->
                            NewDelList = [ID | DelList],
                            NewSellList = [{ID, 0, EndTime} | SellList];
                        false ->
                            NewDelList = DelList,
                            NewSellList = [{ID, DoneNum, EndTime} | SellList]
                    end;
                false ->
                    NewDelList = DelList,
                    NewSellList = [{ID, 0, EndTime} | SellList]
            end,
            init_goods(T, Now, List, NewDelList, NewSellList, WaitList, NewRecords);
        {StartTime, EndTime} when Now < StartTime ->
            NewDelList =
                case lists:keyfind(ID, 1, List) of
                    {_, _DoneNum, Time} ->
                        case Time < StartTime orelse Time > EndTime of %% 重置超出时间段的数量
                            true -> [ID | DelList];
                            false -> DelList
                        end;
                    false -> DelList
                end,
            NewWaitList = [{ID, StartTime, EndTime} | WaitList],
            init_goods(T, Now, List, NewDelList, SellList, NewWaitList, NewRecords);
        _ -> %% 没有配置开售时间或者出售时间已经过了
            NewDelList = case lists:keymember(ID, 1, List) of
                             true -> [ID | DelList];
                             false -> DelList
                         end,
            init_goods(T, Now, List, NewDelList, SellList, WaitList, NewRecords)
    end;
init_goods([], _Now, _List, DelList, SellList, WaitList, Records) ->
    {DelList, lists:keysort(3, SellList), lists:keysort(2, WaitList), Records}.

%% @doc 移除超时商品
delete_db_data(DelIds) ->
    spawn(fun() -> delete_db_data(DelIds, 0) end).

%% 移除超时商品
delete_db_data([ID | T], N) ->
    %% 删除玩家购买记录
    Sql = io_lib:format(?RUSH_SHOP_BUY_LOG_DELETE, [ID]),
    db:execute(Sql),
    %% 删除物品出售记录
    Sql_2 = io_lib:format(?RUSH_SHOP_DELETE, [ID]),
    db:execute(Sql_2),
    case N >= 10 of
        true ->
            timer:sleep(10),
            delete_db_data(T, 0);
        false ->
            delete_db_data(T, N + 1)
    end;
delete_db_data([], _N) ->
    ok.

%% @doc 设置更新道具
get_update() ->
    case get('refresh') of
        L when is_list(L) ->
            L;
        _ ->
            []
    end.

set_update(ID) when is_integer(ID) ->
    L = get_update(),
    case lists:member(ID, L) of
        true ->
            skip;
        false ->
            put('refresh', [ID | L])
    end,
    ok;
set_update(Info) ->
    put('refresh', Info),
    ok.

%% @doc 保存玩家购买信息
save_buy(RoleID, ID, TotalNum, DailyNum) ->
    Time = utime:unixtime(),
    Fun =
        fun() ->
            Sql1 = io_lib:format(?RUSH_SHOP_REPLACE_INTO, [ID, TotalNum, Time]),
            Sql2 = io_lib:format(?RUSH_SHOP_BUY_LOG_REPLACE_INTO, [RoleID, ID, DailyNum, Time]),
            db:execute(Sql1),
            db:execute(Sql2),
            ok
        end,
    case db:transaction(Fun) of
        ok -> ok;
        Err ->
            ?ERR("[~w]Player update database error!Err:~w Data:~w",
                [RoleID, Err, [ID, TotalNum, DailyNum]]),
            skip
    end.

%% 查询时间范围(暂时注释，为了编译)
% get_goods_time_range(#rush_shop_goods{})->
%     {[1502190319],[1502294400]}.
get_goods_time_range(#rush_shop_goods{
    open_begin = OpenBegin
    , open_end = OpenEnd
    , merge_begin = MergeBegin
    , merge_end = MergeEnd
    , act_begin = StartTime
    , act_end = EndTime
    , open_switch = OpenSwitch
    , merge_switch = MergeSwitch
}) ->
    %% 构造活动结构
    OpenEndTime = util:get_open_time() + 86400 * 7,
    ActInfo = #rush_info{
        type = 0, %% 没有这个活动
        open_begin = OpenBegin, open_end = OpenEnd, open_end_time = OpenEndTime,
        merge_begin = MergeBegin, merge_end = MergeEnd,
        start_time = StartTime, end_time = EndTime,
        open_switch = OpenSwitch, merge_switch = MergeSwitch
    },
    case get_time_check_list(ActInfo) of
        [] -> false;
        CheckList ->
            StList = [St || {St, _Et} <- CheckList, St /= 0],
            EtList = [Et || {_St, Et} <- CheckList, Et /= 0],
            NewSt = case StList == [] of
                        true -> 0;
                        false -> lists:max(StList)
                    end,
            NewEt = case EtList == [] of
                        true -> 0;
                        false -> lists:min(EtList)
                    end,
            % 开始时间和结束时间都必须大于0
            Bool = NewSt > 0 andalso NewEt > 0,
            case Bool andalso NewSt =< NewEt of
                true -> {NewSt, NewEt};
                false -> false
            end
    end.


%% 获得封测活动时间检查
%% @return [] | lists(), lists() = [{St, Et}|...]
%% 抢购商城使用同样的时间机制(lib_limit_shop_data模块调用,忽略跨服)
get_time_check_list(ActInfo) ->
    #rush_info{
        type = _Type, subtype = _SubType,
        open_start_time = ServerOpenSt, open_end_time = ServerOpenEt,
        open_begin = OpenBegin, open_end = OpenEnd,
        merge_begin = MergeBegin, merge_end = MergeEnd,
        start_time = StartTime, end_time = EndTime,
        open_switch = OpenSwitch, merge_switch = MergeSwitch
        , condition = Condition
    } = ActInfo,
    IsMerge = util:is_merge_game(),
    IsCls = util:is_cls(), % 是否跨服中心
    OpenCurTime = util:get_open_time(),
    if
    % 1>没有合服过(新服)2>合服开关'打开'
    %% IsMerge == false andalso MergeSwitch == 1 -> NewCheckList = [];
    % 若是跨服中心,任意开关开了,只计算活动时间
        IsCls andalso (OpenSwitch == 1 orelse MergeSwitch == 1) ->
            NewCheckList = [{StartTime, EndTime}];
    % 本服: 小于服开始时间戳 或者 大于服结束时间戳 则活动关闭
        IsCls == false andalso (OpenCurTime < ServerOpenSt orelse OpenCurTime > ServerOpenEt) ->
            NewCheckList = [];
        true ->
            OpenBeginTime = trans_to_time(open_begin, OpenBegin, Condition),
            OpenEndTime = trans_to_time(open_end, OpenEnd, Condition),
            MergeBeginTime = trans_to_time(merge_begin, MergeBegin, Condition),
            MergeEndTime = trans_to_time(merge_end, MergeEnd, Condition),

            % 开服开关是否‘打开’
            case OpenSwitch == 1 andalso IsMerge =:= false of
                true -> OpenCheckList = [{OpenBeginTime, OpenEndTime}];
                false -> OpenCheckList = []
            end,
            % 合服开关是否‘打开’
            case MergeSwitch == 1 andalso IsMerge =:= true of
                true -> MergeCheckList = [{MergeBeginTime, MergeEndTime}];
                false -> MergeCheckList = []
            end,
            % 合服和开服开关是否打开
            case OpenSwitch == 1 orelse MergeSwitch == 1 of
                true -> CommonCheckList = [{StartTime, EndTime}];
                false -> CommonCheckList = []
            end,
            CheckList0 = OpenCheckList ++ MergeCheckList ++ CommonCheckList,

            %% 合服后，如果配置了北京时间，则以北京时间为准
            CheckList = case IsMerge =:= true andalso (StartTime * EndTime) =/= 0 of
                            true -> [{StartTime, EndTime}];
                            false -> CheckList0
                        end,
            NewCheckList = CheckList
    end,
    NewCheckList.



%% 转换成时间戳
trans_to_time(_, 0, _Condition) -> 0;
trans_to_time(open_begin, Day, Condition) ->   %% 获得当天的凌晨秒数
    Time = (Day - 1) * 86400, %% (Day-1)*一天的秒数
    OpenTime = util:get_open_time(),
    OpenBeginTime = OpenTime + Time,
    OpenDay = util:get_open_day(),
    %% 检查活动根据开服天数循环开放
    case check_cycle_daily_open(Condition, OpenDay, begin_time) of
        AddTime when is_integer(AddTime) ->
            OpenTime + AddTime;
        _ ->
            OpenBeginTime
    end;
trans_to_time(open_end, Day, Condition) ->
    OpenTime = util:get_open_time(),
    Time = Day * 86400, %% Day*一天的秒数
    OpenEndTime = OpenTime + Time,
    OpenDay = util:get_open_day(),
    %% 检查活动根据开服天数循环开放
    case check_cycle_daily_open(Condition, OpenDay, end_time) of
        AddTime when is_integer(AddTime) ->
            OpenTime + AddTime;
        _ ->
            OpenEndTime
    end;
trans_to_time(merge_begin, Day, Condition) ->
    MergeTime = util:get_merge_day_start_time(),
    Time = (Day - 1) * 86400, %% (Day-1)*一天的秒数
    MergeBeginTime = max(MergeTime + Time, 0),
    MergeDay = util:get_merge_day(),
    %% 检查活动根据合服天数循环开放
    case check_cycle_daily_open(Condition, MergeDay, begin_time) of
        AddTime when is_integer(AddTime) ->
            MergeTime + AddTime;
        _ ->
            MergeBeginTime
    end;
trans_to_time(merge_end, Day, Condition) ->
    MergeTime = util:get_merge_day_start_time(),
    Time = Day * 86400, %% Day*一天的秒数
    MergeEndTime = MergeTime + Time,
    MergeDay = util:get_merge_day(),
    %% 检查活动根据合服天数循环开放
    case check_cycle_daily_open(Condition, MergeDay, end_time) of
        AddTime when is_integer(AddTime) ->
            MergeTime + AddTime;
        _ ->
            MergeEndTime
    end.


%% ---------------------------------------------------------------------------
%% @doc 检查是否根据开服天数或者合服天数，每天循环开启
-spec check_cycle_daily_open(Condition, DayNth, Type) -> Return when
    Condition   :: [tuple()],
    DayNth      :: integer(),
    Type        :: begin_time | end_time,
    Return      :: false | Time,
    Time        :: integer().
%% ---------------------------------------------------------------------------
%% {cycle_startday, StartDay}:循环开始时间
%% {cycle_days, DivisorDays, RemNum}:DivisorDays循环内的总天数 RemNum循环内的第几天
%% {cycle_days2, DivisorDays, RemList}:DivisorDays循环内的总天数 RemList循环内的【连续天数】列表
check_cycle_daily_open(Condition, DayNth, Type) ->
    case lists:keyfind(cycle_startday, 1, Condition) of
        {cycle_startday, StartDay} when DayNth >= StartDay ->
            case lists:keyfind(cycle_days, 1, Condition) of
                {cycle_days, DivisorDays, RemNum} ->
                    case DayNth rem DivisorDays of
                        RemNum ->
                            case Type of
                                begin_time -> (DayNth - 1) * 86400;
                                end_time -> DayNth * 86400
                            end;
                        _ ->
                            false
                    end;
                _ ->  check_cycle_daily_open2(Condition, DayNth, Type)
                % false
            end;
        _ ->
            false
    end.

check_cycle_daily_open2(Condition, DayNth, Type) ->
    case lists:keyfind(cycle_days2, 1, Condition) of
        {cycle_days2, DivisorDays, RemList} ->
            RemNum = DayNth rem DivisorDays,
            MaxRem =
                case lists:reverse(lists:sort(RemList)) of
                [MaxRem1|_] -> MaxRem1;
                _ ->  0
            end,
            case {lists:member(RemNum, RemList), Type} of
                {true, begin_time} -> (DayNth - 1) * 86400;
                {true, end_time} -> (DayNth + max(MaxRem - RemNum, 0)) * 86400;
                _ ->
                    false
            end;
        _ ->
            false
    end.