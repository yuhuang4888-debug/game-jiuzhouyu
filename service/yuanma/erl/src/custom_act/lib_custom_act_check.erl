%%-----------------------------------------------------------------------------
%% @Module  :       lib_custom_act_check
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-05
%% @Description:    定制活动检测模块
%%-----------------------------------------------------------------------------
-module(lib_custom_act_check).

-include("custom_act.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("server.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include_lib("kernel/include/file.hrl").
-include("def_module.hrl").
-include("guild.hrl").
-include("def_daily.hrl").
-include("custom_act_liveness.hrl").
-include("vip.hrl").

-export([
    check_cfg/2
    , check_file_mtime/0
    , check_unique_type/1
    , check_list/1
    , check_in_act_time/2
    , check_receive_reward/4
    , check_receive_reward/5
    , check_receive_reward_conditions/3
    , check_reward_receive_times/3
    , check_act_condition/3
    , check_act_reward_condition/4
    , check_act_condtion/2
    , check_reward_in_wlv/4
]).

%% 检查配置是否有问题
check_cfg(Type, SubType) ->
    ActInfo = case SubType < ?EXTRA_CUSTOM_ACT_SUB_ADD of
                  true ->
                      data_custom_act:get_act_info(Type, SubType);
                  false ->
                      data_custom_act_extra:get_act_info(Type, SubType - ?EXTRA_CUSTOM_ACT_SUB_ADD)
              end,
    case ActInfo of
        #custom_act_cfg{
            opday_lim = OpdayLim, merday_lim = MerdayLim,
            optype = OpType,
            opday = _OpDay, optime = OpTime,
            start_time = _Stime, end_time = _Etime,
            condition = Condition
        } ->
            if
                is_list(OpdayLim) == false -> false;
                is_list(MerdayLim) == false -> false;
                is_list(Condition) == false -> false;
                true ->
                    case lists:member(OpType, ?OPEN_TYPE_LIST) of
                        true ->
                            OpTimeL = lib_custom_act_util:format_time(OpTime),
                            case check_optime_unique(OpTimeL) of
                                true -> check_cfg(ActInfo);
                                false -> false
                            end;
                        false ->
                            false
                    end
            end;
        _ -> false
    end.

check_cfg(#custom_act_cfg{type = ?CUSTOM_ACT_TYPE_SMASHED_EGG} = ActInfo) ->
    #custom_act_cfg{condition = Condition} = ActInfo,
    case check_act_condtion([role_lv, free_times, free_time, free_max, coloregg, refreshstart_gold, refreshincrease], Condition) of
        false -> false;
        _ -> true
    end;
check_cfg(_) -> true.

%% 检查开启的时间段是否唯一
%% 两个时间段之间的间隔要大于1分钟
%% OpTimeL [{Stime, Etime}] Stime可为具体时间点对应的时间戳也可为时间点对应当天0点的偏移值
%% lists:sort/1排序后会按Stime从小到大排序
check_optime_unique([]) -> true;
check_optime_unique(OpTimeL) ->
    SortList = lists:sort(OpTimeL),
    do_check_optime_unique(SortList).

do_check_optime_unique([_]) -> true;
do_check_optime_unique([{AStime, AEtime}, {BStime, BEtime} | L]) ->
    case AEtime > AStime andalso BEtime > BStime andalso BStime - AEtime > 60 of
        true ->
            do_check_optime_unique([{BStime, BEtime} | L]);
        false -> false
    end.

%% 检查定制文件是否被修改过，以此判断文件是否被进行热更过
check_file_mtime() ->
    LastMtime = get(?P_CUSTOM_ACT_NORMAL_LAST_MTIME),
    NewMtime = case file:read_file_info("../ebin/data_custom_act.beam") of
                   {ok, FileInfo} ->
                       FileInfo#file_info.mtime;
                   _ -> 0
               end,
    case LastMtime =:= NewMtime of
        true ->
            true;
        false ->
            {{_Y,_M,_D},{_H,Min,S}} = utime:localtime(),
            case LastMtime of
                {{_LY,_LM,_LD},{_LH,_LMin,_LS}} ->
                    {{_NY, _NM, _ND},{_NH,NMin,NS}} = NewMtime,
                    case (Min == NMin andalso abs(NS - S) > 6) orelse Min =/= NMin of
                        true -> {false, NewMtime};
                        _ -> true
                    end;
                _ ->
                    {false, NewMtime}
            end
    end.

%% 检查这个活动类型的活动是否只能同时开启一个
check_unique_type(Type) -> lists:member(Type, ?UNIQUE_CUSTOM_ACT_TYPE).

%% 星际旅行活动结束时间特殊处理
check_in_act_time(#custom_act_cfg{type = Type, subtype = SubType} = ActInfo, ArgsMap) when Type == ?CUSTOM_ACT_TYPE_STAR_TREK ->
    case lib_custom_act_util:get_act_time_range(ActInfo, ArgsMap) of
        {Stime, _Etime} ->
            #{time := NowTime} = ArgsMap,
            case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                #custom_act_cfg{condition = CustomCondition} ->
                    case lib_custom_act_check:check_act_condtion([continue_day], CustomCondition) of
                        [CDay] ->
                            NEndTime = Stime + CDay * 3600 * 24,
                            case NowTime >= Stime andalso NowTime < NEndTime of
                                true -> {true, Stime, NEndTime};
                                false -> false
                            end;
                        _ ->false
                    end;
                _ -> false
            end;
        _ -> false
    end;
%% 检查活动是否在开启时间内
check_in_act_time(ActInfo, ArgsMap) ->
    case lib_custom_act_util:get_act_time_range(ActInfo, ArgsMap) of
        {Stime, Etime} ->
            #{time := NowTime} = ArgsMap,
            case NowTime >= Stime andalso NowTime < Etime of
                true -> {true, Stime, Etime};
                false -> false
            end;
        _ -> false
    end.

%% 检测是否能领取奖励
check_receive_reward(Player, Type, SubType, GradeId) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{
            etime = Etime
        } = ActInfo when NowTime < Etime ->
            check_receive_reward_normal(Player, ActInfo, GradeId);
        _ ->
            {false, ?ERRCODE(err331_act_closed)}
    end.

check_receive_reward_normal(Player, ActInfo, GradeId) ->
    #act_info{key = {Type, SubType}, wlv = Wlv} = ActInfo,
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
        RewardCfg when is_record(RewardCfg, custom_act_reward_cfg) ->
            case check_reward_in_wlv(Type, SubType, Wlv, RewardCfg) of
                true ->
                    %% 这里不但只包含次数的判断
                    case check_reward_receive_times(Player, ActInfo, RewardCfg) of
                        {true, NewReceiveTimes} ->
                            case check_receive_reward_special(Player, ActInfo, RewardCfg) of
                                {true, RewardList} ->
                                    {true, ActInfo, NewReceiveTimes, RewardList, RewardCfg};
                                {false, Errcode} ->
                                    {false, Errcode}
                            end;
                        false ->
                            {false, ?ERRCODE(err331_already_get_reward)};
                        Res ->
                            Res
                    end;
                {false, Errcode} ->
                    {false, Errcode}
            end;
        _ ->
            {false, ?ERRCODE(err331_no_act_reward_cfg)}
    end.

check_receive_reward(Player, Type, SubType, GradeId, Num) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{
            etime = Etime
        } = ActInfo when NowTime < Etime ->
            check_receive_reward_normal(Player, ActInfo, GradeId, Num);
        _ ->
            {false, ?ERRCODE(err331_act_closed)}
    end.

check_receive_reward_normal(Player, ActInfo, GradeId, Num) ->
    #act_info{key = {Type, SubType}, wlv = Wlv} = ActInfo,
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
        RewardCfg when is_record(RewardCfg, custom_act_reward_cfg) ->
            case check_reward_in_wlv(Type, SubType, Wlv, RewardCfg) of
                true ->
                    %% 这里不但只包含次数的判断
                    case check_reward_receive_times(Player, ActInfo, RewardCfg, Num) of
                        {true, NewReceiveTimes} ->
                            case check_receive_reward_special(Player, ActInfo, RewardCfg, Num) of
                                {true, RewardList} ->
                                    {true, ActInfo, NewReceiveTimes, RewardList, RewardCfg};
                                {false, Errcode} ->
                                    {false, Errcode}
                            end;
                        false ->
                            if
                                Type =:= ?CUSTOM_ACT_TYPE_RUSH_BUY -> {false, ?ERRCODE(err331_goods_sold_out)};
                                true -> {false, ?ERRCODE(err331_already_get_reward)}
                            end;
                        Res ->
                            Res
                    end;
                {false, Errcode} ->
                    {false, Errcode}
            end;
        _ ->
            {false, ?ERRCODE(err331_no_act_reward_cfg)}
    end.
%% 先特殊处理一下
check_receive_reward_special(Player, #act_info{key = {?CUSTOM_ACT_TYPE_CONSUME, _}} = ActInfo, RewardCfg) ->
    case check_receive_reward_conditions(Player, ActInfo, RewardCfg) of
        true ->
            RewardList = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
            Len = length(RewardList),
            Cells = lib_goods_api:get_cell_num(Player),
            case Cells >= Len of
                true ->
                    {true, RewardList};
                false ->
                    {false, ?ERRCODE(err150_no_cell)}
            end;
        {false, Errcode} ->
            {false, Errcode}
    end;

%% 先特殊处理一下
check_receive_reward_special(Player, #act_info{key = {?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, SubType}} = ActInfo, RewardCfg) ->
    case lib_limit_gift:check(Player, SubType, RewardCfg#custom_act_reward_cfg.grade) of
        true ->
            RewardList = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
            {true, RewardList};
        {false, Errcode} ->
            {false, Errcode}
    end;

check_receive_reward_special(Player, #act_info{key = {Type, _SubType}} = ActInfo, RewardCfg) when
        Type == ?CUSTOM_ACT_TYPE_TRAIN_POWER;
        Type == ?CUSTOM_ACT_TYPE_TRAIN_STAGE ->
    case check_receive_reward_conditions(Player, ActInfo, RewardCfg) of
        true ->
            %RewardList = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
            RewardList = lib_train_act:get_normal_reward(Player, ActInfo, RewardCfg),
            ExtraReward = lib_train_act:get_extra_reward(Player, ActInfo, RewardCfg),
            UniqueRewardL = lib_goods_api:make_reward_unique(RewardList++ExtraReward),
            case lib_goods_api:can_give_goods(Player, UniqueRewardL) of
                true ->
                    {true, UniqueRewardL};
                {false, Errcode} ->
                    {false, Errcode}
            end;
        {false, Errcode} ->
            {false, Errcode}
    end;

check_receive_reward_special(Player, #act_info{key = {Type, _SubType}} = ActInfo, RewardCfg) when
        Type == ?CUSTOM_ACT_TYPE_FOLLOW ->
    case check_receive_reward_conditions(Player, ActInfo, RewardCfg) of
        true ->
            RewardList = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
            {true, RewardList};
        {false, Errcode} ->
            {false, Errcode}
    end;

%% 超值特惠礼包
check_receive_reward_special(#player_status{figure = #figure{lv = RoleLv}, vip = #role_vip{vip_lv = VipLv}} = Player, #act_info{key = {Type, SubType}} = ActInfo, RewardCfg) when
        Type == ?CUSTOM_ACT_TYPE_SPECIAL_GIFT ->
    #custom_act_reward_cfg{grade = GradeId, condition = RewardCondition} = RewardCfg,
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} ->
            {role_lv, LimitRoleLv} = ulists:keyfind(role_lv, 1, Condition, {role_lv, 0}),
            {vip_lv, MinVipLv} = ulists:keyfind(vip_lv, 1, Condition, {vip_lv, 0}),
            case lists:keyfind(grade_ids, 1, Condition) of
                {grade_ids, GradeIds} when is_list(GradeIds), LimitRoleLv > 0, RoleLv >= LimitRoleLv, VipLv >= MinVipLv ->
                    case lists:member(GradeId, GradeIds) of
                        true ->
                            case lib_special_gift:check_cost_list(Player, RewardCondition) of
                                true ->
                                    RewardList = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                                    {true, RewardList};
                                {false, Errcode} ->
                                    {false, Errcode}
                            end;
                        false ->
                            %% 不是购买奖励，判断是否是额外奖励
                            case lists:keyfind(extra_reward, 1, RewardCondition) of
                                {extra_reward} ->
                                    ReceiveTimes = lib_special_gift:count_receive_times(Type, SubType, GradeId, Player#player_status.status_custom_act#status_custom_act.reward_map),
                                    case lib_special_gift:check_all_grades_finish(Player, ActInfo, GradeIds, ReceiveTimes) of
                                        ?ACT_REWARD_CAN_GET ->
                                            RewardList = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                                            {true, RewardList};
                                        _ ->
                                            {false, ?ERRCODE(err331_act_can_not_get)}
                                    end;

                                _ ->
                                    {false, ?ERRCODE(err331_reward_not_bl_act)}
                            end
                    end;
                _ ->
                    {false, ?MISSING_CONFIG}
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end;

check_receive_reward_special(Player, #act_info{key = {?CUSTOM_ACT_TYPE_SYS_MAIL, _}} = ActInfo, RewardCfg) ->
    RewardList = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
    {true, RewardList};

check_receive_reward_special(Player, ActInfo, RewardCfg) ->
    case check_receive_reward_conditions(Player, ActInfo, RewardCfg) of
        true ->
            RewardList = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
            case lib_goods_api:can_give_goods(Player, RewardList) of
                true ->
                    {true, RewardList};
                {false, Errcode} ->
                    {false, Errcode}
            end;
        {false, Errcode} ->
            {false, Errcode}
    end.

check_receive_reward_special(Player, ActInfo, RewardCfg, Num) ->
    case check_receive_reward_conditions(Player, ActInfo, RewardCfg, Num) of
        true ->
            RewardList = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
            Fun = fun({T, GT, N}, Acc) ->
                [{T, GT, N*Num}|Acc]
            end,
            RealReward = lists:foldl(Fun, [], lists:reverse(RewardList)),
            case lib_goods_api:can_give_goods(Player, RealReward) of
                true ->
                    {true, RealReward};
                {false, Errcode} ->
                    {false, Errcode}
            end;
        {false, Errcode} ->
            {false, Errcode}
    end.

%% 各个活动类型写自己的判断逻辑

%% 集字兑换是否有足够的物品兑换
check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_COLWORD, _}}, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(goods_exchange, 1, Conditions) of
        {goods_exchange, ExGoods, _ModId, _CId} ->
            case lib_goods_api:check_object_list(Player, ExGoods) of
                true -> true;
                Res -> Res
            end;
        _ ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

check_receive_reward_conditions(Player, #act_info{key = {Type, _}}, RwCfg)
when Type == ?CUSTOM_ACT_TYPE_FEAST_SHOP orelse Type == ?CUSTOM_ACT_TYPE_BUY orelse Type == ?CUSTOM_ACT_TYPE_SHOP_REWARD
    orelse Type == ?CUSTOM_ACT_TYPE_RUSH_BUY ->
    #player_status{figure = #figure{lv = RoleLv}, vip = #role_vip{vip_lv = VipLv}} = Player,
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    IsLvSatisfy = case lists:keyfind(role_lv, 1, Conditions) of
        {_, [{Min, Max}|_]} when RoleLv > Max orelse RoleLv < Min -> false;
        {_, WlvCfg} when is_integer(WlvCfg) andalso WlvCfg > RoleLv  -> false;
        _ ->
            true
    end,
    {vip_lv, MinVipLv} = ulists:keyfind(vip_lv, 1, Conditions, {vip_lv, 0}),
    if
        IsLvSatisfy, VipLv >= MinVipLv ->
            case lists:keyfind(price, 1, Conditions) of
                {price, CurrencyType, _Price, RealPrice} ->
                    case lib_goods_api:check_object_list(Player, [{CurrencyType, 0, RealPrice}]) of
                        true -> true;
                        Res -> Res
                    end;
                _ ->
                    {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        true ->
            {false, ?ERRCODE(err331_lv_not_enougth)}
    end;


check_receive_reward_conditions(Player, #act_info{key = {Type, _}}, RwCfg)
when Type == ?CUSTOM_ACT_TYPE_TREE_SHOP ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(cost, 1, Conditions) of
        {cost, CostList} when is_list(CostList) ->
            case lib_goods_api:check_object_list(Player, CostList) of
                true -> true;
                Res -> Res
            end;
        _ ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_7_RECHARGE, _}, stime = Stime}, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(gold, 1, Conditions) of
        {gold, Value} ->
            % TodayGold = lib_recharge_data:get_today_pay_gold(Player#player_status.id),
            DiffDay = utime:diff_days(Stime),
            HistoryList = lib_recharge_data:get_my_daily_recharge_summaries(Player#player_status.id, DiffDay),
            % HistoryListWithToday = [{0, {TodayGold, 0}}|HistoryList],
            X = lists:sum([G || {_, {G, _}} <- HistoryList]),
            if
                X >= Value ->
                    true;
                true ->
                    {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        _ ->
            {false, ?ERRCODE(err331_no_act_reward_cfg)}
    end;

check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_OVERSEAS_RECHARGE, _}, stime = StartTime}, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(gold, 1, Conditions) of
        {gold, Value} ->
            TotalGold = lib_recharge_data:get_my_recharge_between(Player#player_status.id, StartTime, utime:unixtime()),
            if
                TotalGold >= Value ->
                    true;
                true ->
                    {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        _ ->
            {false, ?ERRCODE(err331_no_act_reward_cfg)}
    end;

check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_CONTINUOUS_RECHARGE, SubType}, stime = Stime}, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    Now = utime:unixtime(),
    #custom_act_cfg{condition = TypeCondition} = lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_CONTINUOUS_RECHARGE, SubType),
    case lists:keyfind(role_lv, 1, TypeCondition) of
        {_, LimitLv} -> LimitLv;
        _ -> LimitLv = 0
    end,
    RoleLv = Player#player_status.figure#figure.lv,
    if
        RoleLv < LimitLv ->
            {false, ?ERRCODE(err331_lv_not_enougth)};
        Now < Stime ->
            {false, ?ERRCODE(err331_act_can_not_get)};
        true ->
            case lists:keyfind(gold, 1, Conditions) of
                {gold, Gold} ->
                    DiffDay = utime:diff_days(Stime),
                    HistoryList = lib_recharge_data:get_my_daily_recharge_summaries(Player#player_status.id, DiffDay),
                    X = lists:sum([1 || {_, {G, _}} <- HistoryList, G >= Gold]),
                    case lists:keyfind(day, 1, Conditions) of
                        {day, Day} ->
                            if
                                X >= Day ->
                                    true;
                                true ->
                                    {false, ?ERRCODE(err331_act_can_not_get)}
                            end;
                        _ ->
                            {false, ?MISSING_CONFIG}
                    end;
                _ ->
                    {false, ?ERRCODE(err331_no_act_reward_cfg)}
            end
    end;

check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_LV_GIFT, SubType}, stime = _Stime}, _RwCfg) ->
    #custom_act_cfg{condition = TypeCondition} = lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_LV_GIFT, SubType),
    case lists:keyfind(limit_time, 1, TypeCondition) of
        {_, LimitTime} -> LimitTime;
        _ -> LimitTime = 0
    end,
    #player_status{status_custom_act = CustomAct} = Player,
    case CustomAct of
        #status_custom_act{data_map = DataMap} ->
            case maps:get({?CUSTOM_ACT_TYPE_LV_GIFT, SubType}, DataMap, []) of
                #custom_act_data{data = DataList} ->
                    case lists:keyfind(min_lv, 1, DataList) of
                        {min_lv, MinLvTime} ->
                            case lists:keyfind(max_lv, 1, DataList) of
                                {max_lv, MaxLvTime} ->
                                    if
                                        MaxLvTime - MinLvTime =< LimitTime * 60 ->
                                            true;
                                        true ->
                                            {false, ?ERRCODE(err331_act_can_not_get)}
                                    end;
                                _ ->
                                    {false, ?ERRCODE(err331_act_can_not_get)}
                            end;
                        _ ->
                            {false, ?ERRCODE(err331_act_can_not_get)}
                    end;
                _ ->
                    {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        _ ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_RECHARGE_GIFT, _}, stime = _Stime} = _ActInfo, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(gold, 1, Conditions) of
        {gold, Value} ->
%%            NSTime = lib_custom_act_util:get_act_logic_stime(ActInfo),
            X = lib_recharge_data:get_my_recharge_between(Player#player_status.id, _Stime, utime:unixtime()),
%%             ?PRINT("reward_conditions ~p~n", [{utime:unixtime_to_localtime(_Stime),utime:unixtime_to_localtime(utime:unixtime()),X}]),
            if
                X >= Value ->
                    true;
                true ->
                    {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        _ ->
            case lists:keyfind(today_gold, 1, Conditions) of
                {today_gold, Value} ->
                    X = lib_recharge_data:get_my_recharge_between(Player#player_status.id, utime:unixdate(), utime:unixtime()),
%%                    ?PRINT("reward_conditions ~p~n", [X]),
                    if
                        X >= Value ->
                            true;
                        true ->
                            {false, ?ERRCODE(err331_act_can_not_get)}
                    end;
                _ ->
                    {false, ?ERRCODE(err331_no_act_reward_cfg)}
            end
    end;

check_receive_reward_conditions(Player, ActInfo = #act_info{key = {?CUSTOM_ACT_TYPE_FIVE_STAR, _}}, _RwCfg) ->
    #act_info{
        stime = StartTime,
        etime = EndTime
    } = ActInfo,
    FiveStarMarkNum = mod_counter:get_count(Player#player_status.id, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_FIVE_STAR),
    case FiveStarMarkNum >= StartTime andalso FiveStarMarkNum < EndTime of
        true ->
            true;
        false ->
            {false, ?ERRCODE(err331_no_act_reward_cfg)}
    end;

%% 登录有礼
check_receive_reward_conditions(Player, _ActInfo = #act_info{stime = StartTime, key = {?CUSTOM_ACT_TYPE_SIGN_REWARD = Type, SubType}}, RwCfg) ->
    #custom_act_reward_cfg{
        grade = _GradeId,
        type = Type,
        condition = Conditions
    } = RwCfg,
    RoleLv = Player#player_status.figure#figure.lv,
    #custom_act_cfg{condition = TypeCondition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    case lists:keyfind(role_lv, 1, TypeCondition) of
        {_, LimitLv} -> LimitLv;
        _ -> LimitLv = 100
    end,
    if
        RoleLv >= LimitLv ->
            StatusCustomAct = Player#player_status.status_custom_act,
            DataMap = StatusCustomAct#status_custom_act.data_map,

            case maps:get({Type, SubType}, DataMap, []) of
                #custom_act_data{data = Data} ->
                    {_, LoginTimes, _, RechargeList} = ulists:keyfind(sign, 1, Data, {sign, 0, 0, []});
                _ ->
                    LoginTimes = 0, RechargeList = []
            end,
            CanRecieve = lib_sign_reward_act:calc_need_send_reward(normal, Conditions, StartTime, LoginTimes, RechargeList),
            if
                CanRecieve == true ->
                    true;
                true ->
                    {false, ?ERRCODE(err331_login_times_limit)}
            end;
        true ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;


%% 特惠商城
check_receive_reward_conditions(Player, ActInfo = #act_info{key = {?CUSTOM_ACT_TYPE_LIMIT_BUY, SubType}}, RwCfg) ->
    #custom_act_reward_cfg{
        grade = GradeId,
        condition = Conditions
    } = RwCfg,
    case mod_limit_buy:limit_buy_check(SubType, GradeId, Player#player_status.id) of
        {false, Code} ->
            {false, Code};
        true ->
            case lib_custom_act_util:count_act_reward(Player, ActInfo, RwCfg) of
                [] ->
                    {false, ?FAIL};
                _ ->
                    {cost, CostList} = lists:keyfind(cost, 1, Conditions),
                    {discount, Discount} = lists:keyfind(discount, 1, Conditions),
                    [{CostGoodsType, CostGoodsId, CostNum} | _] = CostList,
                    NewCostNum = round(CostNum * Discount / 100),
                    lib_goods_api:check_object_list(Player, [{CostGoodsType, CostGoodsId, NewCostNum}])
            end
    end;

%% 活动兑换
check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_ACT_EXCHANGE, _}}, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(goods_exchange, 1, Conditions) of
        {goods_exchange, ExGoods, _ModId, _CId} ->
            case lib_goods_api:check_object_list(Player, ExGoods) of
                true -> true;
                Res -> Res
            end;
        _ ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

%% 公会争霸 1档奖励 主宰公会会长可领取 2档奖励 主宰公会成员可领取 3档奖励 公会战参与者可领取
% check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_GWAR, SubType}}, RwCfg) ->
%     #player_status{id = RoleId, guild = Guild} = Player,
%     #status_guild{id = GuildId, position = Position} = Guild,
%     #custom_act_reward_cfg{grade = GradeId} = RwCfg,
%     case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType) of
%         #custom_act_cfg{condition = Condition} ->
%             NowTime = utime:unixtime(),
%             OpDay = util:get_open_day(NowTime),
%             case check_act_condtion([need_opday], Condition) of
%                 [NeedOpday] when OpDay >= NeedOpday -> %% 超过指定开服天数才能领取奖励
%                     case GuildId > 0 of
%                         true ->
%                             case GradeId =/= 1 orelse (GradeId == 1 andalso Position == ?POS_CHIEF) of
%                                 true ->
%                                     case catch mod_custom_act_gwar:check_receive_reward(RoleId, GuildId, GradeId) of
%                                         Res when Res == true -> true;
%                                         _ ->
%                                             {false, ?ERRCODE(err331_act_can_not_get)}
%                                     end;
%                                 _ -> {false, ?ERRCODE(err331_act_can_not_get)}
%                             end;
%                         false ->
%                             {false, ?ERRCODE(err331_act_can_not_get)}
%                     end;
%                 _ -> {false, ?ERRCODE(err_config)}
%             end;
%         _ -> {false, ?ERRCODE(err_config)}
%     end;

check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_CONSUME, _}, stime = Stime, etime = Etime}, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(money_type, 1, Conditions) of
        {money_type, MoneyType, Value} ->
            case lib_consume_data:get_consume_between(Player#player_status.id, MoneyType, Stime, Etime) of
                ConsumeValue when ConsumeValue >= Value ->
                    true;
                _ ->
                    {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        _ ->
            {false, ?ERRCODE(err_config)}
    end;

check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_RECHARGE_CONSUME, _}, stime = Stime, etime = Etime}, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    RechargeCon = lists:keyfind(recharge, 1, Conditions),
    ConsumeCon = lists:keyfind(consume, 1, Conditions),
    IfRecharge = case RechargeCon of
                     {recharge, NeedRechargeNum} ->
                         case lib_recharge_data:get_my_recharge_between(Player#player_status.id, Stime, Etime) of
                             RechargeNum when RechargeNum >= NeedRechargeNum ->
                                 true;
                             _ ->
                                 {false, ?ERRCODE(err331_act_can_not_get)}
                         end;
                     _ ->
                         true
                 end,
    IfConsume = case ConsumeCon of
                    {consume, MoneyType, NeedConsumeNum} ->
                        case lib_consume_data:get_consume_between(Player#player_status.id, MoneyType, Stime, Etime) of
                            ConsumeValue when ConsumeValue >= NeedConsumeNum ->
                                true;
                            _ ->
                                {false, ?ERRCODE(err331_act_can_not_get)}
                        end;
                    _ ->
                        true
                end,
    if
        IfRecharge =/= true ->
            IfRecharge;
        IfConsume =/= true ->
            IfConsume;
        true ->
            true
    end;

%% 连续消费
check_receive_reward_conditions(#player_status{id = RoleId}, #act_info{key = {?CUSTOM_ACT_TYPE_CONTINUE_CONSUME, _}, stime = Stime, etime = Etime}, RwCfg) ->
%%    UnixDate = utime:unixdate(),
    UnixDate = utime:standard_unixdate(),
    #custom_act_reward_cfg{condition = Condition} = RwCfg,
    [ClearType, GoldLim] = check_act_condtion([type, gold], Condition),
    case ClearType of
        1 -> %% 每日的
            case lib_consume_data:get_consume_gold_between(RoleId, UnixDate, Etime) >= GoldLim of
                true -> true;
                false -> {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        2 -> %% 累计连续的
            [CfgDay] = check_act_condtion([day], Condition),
            F = fun({_, Gold}, Acc) when Gold >= GoldLim -> Acc + 1;
                (_, Acc) -> Acc
                end,
            case lists:foldl(F, 0, lib_consume_data:get_consume_day_by_day(RoleId, gold, Stime, Etime)) >= CfgDay of
                true -> true;
                false -> {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        _ -> {false, ?ERRCODE(err_config)}
    end;

%% 每日活跃转盘
check_receive_reward_conditions(#player_status{id = RoleId}, #act_info{key = {?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, _}}, RwCfg) ->
    #custom_act_reward_cfg{grade = GradeId, condition = Condition} = RwCfg,
    Liveness = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
    case check_act_condtion([liveness], Condition) of
        [LiveLimit] when GradeId >= 100 ->
            case Liveness >= LiveLimit of
                true ->
                    true;
                false ->
                    {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        _ ->
            {false, ?ERRCODE(err_config)}
    end;

check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_FASHION_ACT, _}}, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(cost, 1, Conditions) of
        {cost, CostList} ->
            case lib_goods_api:check_object_list(Player, CostList) of
                true -> true;
                Res -> Res
            end;
        _ ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

%% 摇摇乐 检查领取条件
check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_SHAKE, SubType}}, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    Times = lib_shake:get_draw_times(Player, SubType),
    case lists:keyfind(stage, 1, Conditions) of
        {stage, Stage} ->
            case Times >= Stage of
                true -> true;
                false -> {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        _ ->
            {false, ?ERRCODE(err_config)}
    end;

%% 每日补给 检查领取条件
check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_SUPPLY, _SubType}}, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    Activity = mod_daily:get_count_offline(Player#player_status.id, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_SUPPLY),
    case lists:keyfind(liveness, 1, Conditions) of
        {liveness, Liveness} ->
            case Activity >= Liveness of
                true -> true;
                false -> {false, ?ERRCODE(err157_1_live_not_enough)}
            end;
        _ ->
            {false, ?ERRCODE(err_config)}
    end;


%% 活动兑换
check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_EXCHANGE_NEW = Type, SubType}}, RwCfg) ->
    RoleLv = Player#player_status.figure#figure.lv,
    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_, LimitLv} = lists:keyfind(role_lv, 1, Condition),
    if
        RoleLv >= LimitLv ->
            #custom_act_reward_cfg{condition = Conditions} = RwCfg,
            case lists:keyfind(cost, 1, Conditions) of
                {cost, ExGoods} ->
                    case lib_goods_api:check_object_list(Player, ExGoods) of
                        true -> true;
                        Res ->
                            Res
                    end;
                _ ->
                    {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        true ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

%% 节日活跃
check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_LIVENESS = Type, SubType}}, RwCfg) ->
    #custom_act_liveness{times = Times} = lib_custom_act_liveness:get_liveness_data(Player, Type, SubType),
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case check_act_condtion([total], Conditions) of
        [Total] ->
            case Times >= Total of
                true ->
                    true;
                false ->
                    {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        _ ->
            {false, ?ERRCODE(err_config)}
    end;

check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_TRAIN_STAGE, SubType}, stime = STime, etime = ETime}=ActInfo, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(train_type, 1, Conditions) of
        {train_type, TrainType, Value} ->
            TrainInitState = lib_train_act:get_initial_train_info(Player, ?CUSTOM_ACT_TYPE_TRAIN_STAGE, SubType, STime, ETime),
            case lib_train_act:can_show_in_this_act(TrainInitState, ActInfo, RwCfg) of
                true ->
                    case lists:keyfind(stage, 1, Conditions) of
                        {stage, StageCfg, StarCfg} ->
                            {Stage, Star} = lib_train_act:get_train_stage_with_type(Player, TrainType, Value),
                            case Stage > StageCfg orelse (Stage == StageCfg andalso Star >= StarCfg) of
                                true -> true;
                                _ -> {false, ?ERRCODE(err331_act_can_not_get)}
                            end;
                        _ ->
                            {false, ?ERRCODE(err331_no_act_reward_cfg)}
                    end;
                _ ->
                    {false, ?ERRCODE(err331_no_act_reward_cfg)}
            end;
        _ ->
            {false, ?ERRCODE(err331_no_act_reward_cfg)}
    end;
check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_TRAIN_POWER, SubType}, stime = STime, etime = ETime}=ActInfo, RwCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(train_type, 1, Conditions) of
        {train_type, TrainType, Value} ->
            TrainInitState = lib_train_act:get_initial_train_info(Player, ?CUSTOM_ACT_TYPE_TRAIN_POWER, SubType, STime, ETime),
            case lib_train_act:can_show_in_this_act(TrainInitState, ActInfo, RwCfg) of
                true ->
                    case lists:keyfind(power, 1, Conditions) of
                        {power, PowerCfg} ->
                            Power = lib_train_act:get_train_power_with_type(Player, TrainType, Value),
                            case Power >= PowerCfg of
                                true -> true;
                                _ -> {false, ?ERRCODE(err331_act_can_not_get)}
                            end;
                        _ ->
                            {false, ?ERRCODE(err331_no_act_reward_cfg)}
                    end;
                _ ->
                    {false, ?ERRCODE(err331_no_act_reward_cfg)}
            end;
        _ ->
            {false, ?ERRCODE(err331_no_act_reward_cfg)}
    end;
check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_NAME_VERIFICATION, SubType}}, _RwCfg) ->
    #player_status{status_custom_act = StatusCustomAct} = Player,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    case maps:get({?CUSTOM_ACT_TYPE_NAME_VERIFICATION, SubType}, DataMap, 0) of
        #custom_act_data{} -> true;
        _ ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;
%% 问卷调查
check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_QUESTIONNAIRE, SubType}}, RwCfg) ->
    #player_status{c_source = Source} = Player,
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_QUESTIONNAIRE, SubType),
    case check_act_condtion([questionnaire], Conditions) of
        [QuestionType] ->
            Source1 = erlang:list_to_atom(util:make_sure_list(Source)),
            {_, SourceList} = ulists:keyfind(source_list, 1, ActConditions, {source_list, [Source1]}),
            case lists:member(Source1, SourceList) of
                true ->
                    case lib_questionnaire:is_finish(Player, QuestionType) of
                        true ->
                            true;
                        false ->
                            {false, ?ERRCODE(err331_act_can_not_get)}
                    end;
                false ->
                    {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        _ ->
            {false, ?ERRCODE(err_config)}
    end;

check_receive_reward_conditions(Player, #act_info{key = {Type, _}, stime = STime}, RwCfg) when Type == ?CUSTOM_ACT_TYPE_LOGIN_REWARD ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case check_act_condtion([vip, day], Conditions) of
        [NeedVip, Day] ->
            VipLv = lib_vip:get_vip_lv(Player),
            DiffDay = abs(utime:diff_day(STime)) + 1,
            case VipLv >= NeedVip andalso Day == DiffDay of
                true ->
                    true;
                false ->
                    {false, ?ERRCODE(err331_act_can_not_get)}
            end;
        _ ->
            {false, ?ERRCODE(err_config)}
    end;

check_receive_reward_conditions(_Player, _, _) -> true.

%% 集字兑换是否有足够的物品兑换
check_receive_reward_conditions(Player, #act_info{key = {?CUSTOM_ACT_TYPE_COLWORD, _}}, RwCfg, Num) ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(goods_exchange, 1, Conditions) of
        {goods_exchange, ExGoods, _ModId, _CId} ->
            Fun = fun({T, GT, N}, Acc) ->
                [{T, GT, N*Num}|Acc]
            end,
            RealCost = lists:foldl(Fun, [], ExGoods),
            case lib_goods_api:check_object_list(Player, RealCost) of
                true -> true;
                Res -> Res
            end;
        _ ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

check_receive_reward_conditions(Player, #act_info{key = {Type, _}}, RwCfg, Num)
when Type == ?CUSTOM_ACT_TYPE_FEAST_SHOP orelse Type == ?CUSTOM_ACT_TYPE_BUY orelse Type == ?CUSTOM_ACT_TYPE_SHOP_REWARD
    orelse Type == ?CUSTOM_ACT_TYPE_RUSH_BUY ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(price, 1, Conditions) of
        {price, CurrencyType, _Price, RealPrice} ->
            case lib_goods_api:check_object_list(Player, [{CurrencyType, 0, RealPrice*Num}]) of
                true -> true;
                Res -> Res
            end;
        _ ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

check_receive_reward_conditions(Player, #act_info{key = {Type, _}}, RwCfg, Num)
when Type == ?CUSTOM_ACT_TYPE_TREE_SHOP ->
    #custom_act_reward_cfg{condition = Conditions} = RwCfg,
    case lists:keyfind(cost, 1, Conditions) of
        {cost, CostList} when is_list(CostList) ->
            Fun = fun({T, GT, N}, Acc) ->
                [{T, GT, N*Num}|Acc];
                (_, Acc) -> Acc
            end,
            Cost = lists:foldl(Fun, [], CostList),
            case lib_goods_api:check_object_list(Player, Cost) of
                true -> true;
                Res -> Res
            end;
        _ ->
            {false, ?ERRCODE(err331_act_can_not_get)}
    end;

check_receive_reward_conditions(_Player, _, _,_) -> true.
%%--------------------------------------------------
%% 检查奖励领取次数是否达到限制
%% @param  Player       #player_status{}
%% @param  ActInfo      #act_info{}
%% @param  RwInfo       #custom_act_reward_cfg{}
%% @return              {true, NewTimes}|false
%%--------------------------------------------------

%% 开服集字活动没有次数限制
check_reward_receive_times(Player, #act_info{key = {?CUSTOM_ACT_TYPE_COLWORD = Type, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{condition = RewardCondition, grade = GradeId}) ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    UnixDate = utime:unixdate(),
    {_, _ExGoods, ModId, CounterId} = lists:keyfind(goods_exchange, 1, RewardCondition),
    if
        ModId > 0 andalso CounterId > 0 ->
            [{_, ExchangeTime} | _] = mod_global_counter:get_count([{ModId, Type, CounterId}],[{global_diff_day, 1}]);
        true ->
            ExchangeTime = 0
    end,
    case lists:keyfind(all_num, 1, RewardCondition) of
        {_, AllLimit} -> AllLimit;
        _ -> AllLimit = 0
    end,
    case lists:keyfind(personal_num, 1, RewardCondition) of
        {_, PerLimit} -> PerLimit;
        _ -> PerLimit = 0
    end,
    case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_COLWORD, SubType) of
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(role_lv, 1, Condition) of
                {_, DefLv} -> skip;
                _ ->
                    DefLv = 0
            end,
            {_, ClearType} =
                case lists:keyfind(clear_type, 1, Condition) of
                    {_, CType} -> {clear_type, CType};
                    _ -> {clear_type, skip}
                end,
            if
                Player#player_status.figure#figure.lv < DefLv -> false;
                true ->
                    case maps:get({?CUSTOM_ACT_TYPE_COLWORD, SubType, GradeId}, RewardMap, []) of
                        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
                            case ClearType of
                                day ->
                                    case Utime >= UnixDate of
                                        true ->
                                            if
                                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes >= PerLimit orelse ExchangeTime >= AllLimit, false, {true, ReceiveTimes + 1});
                                                AllLimit =/= 0 andalso PerLimit == 0 ->
                                                    ?IF(ExchangeTime >= AllLimit, false, {true, ReceiveTimes + 1});
                                                AllLimit == 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes >= PerLimit, false, {true, ReceiveTimes + 1});
                                                true ->
                                                    {true, ReceiveTimes + 1}
                                            end;
                                        false ->
                                            if
                                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                                    ?IF(1 > PerLimit orelse ExchangeTime+1 > AllLimit, false, {true, 1});
                                                AllLimit =/= 0 andalso PerLimit == 0 ->
                                                    ?IF(ExchangeTime+1 > AllLimit, false, {true, 1});
                                                AllLimit == 0 andalso PerLimit =/= 0 ->
                                                    ?IF(1 > PerLimit, false, {true, 1});
                                                true ->
                                                    {true, 1}
                                            end
                                    end;
                                _ ->
                                    case Utime >= Stime andalso Utime =< Etime of
                                        true ->
                                            if
                                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes >= PerLimit orelse ExchangeTime >= AllLimit, false, {true, ReceiveTimes + 1});
                                                AllLimit == 0 ->
                                                    ?IF(ReceiveTimes >= PerLimit, false, {true, ReceiveTimes + 1});
                                                true ->
                                                    {true, ReceiveTimes + 1}
                                            end;
                                        false -> {true, 1}
                                    end
                            end;
                        _ ->
                            {true, 1}
                    end
            end;
        _ ->
            false
    end;

check_reward_receive_times(Player, #act_info{key = {Type, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{condition = RewardCondition, grade = GradeId})
when Type == ?CUSTOM_ACT_TYPE_FEAST_SHOP orelse Type == ?CUSTOM_ACT_TYPE_BUY orelse Type == ?CUSTOM_ACT_TYPE_SHOP_REWARD orelse Type == ?CUSTOM_ACT_TYPE_RUSH_BUY ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    UnixDate = utime:standard_unixdate(),
    case lists:keyfind(sp_gap_time, 1, RewardCondition) of
        {_, Day} -> Day;
        _ -> Day = 1
    end,
    case lists:keyfind(counter, 1, RewardCondition) of
        {_, ModId, CounterId} -> Day;
        _ -> ModId = 0,CounterId = 0
    end,
    if
        ModId > 0 andalso CounterId > 0 ->
            [{_, ExchangeTime} | _] = mod_global_counter:get_count([{ModId, Type, CounterId}],[{global_diff_day, Day}]);
        true ->
            ExchangeTime = 0
    end,
    case lists:keyfind(all_num, 1, RewardCondition) of
        {_, AllLimit} -> AllLimit;
        _ -> AllLimit = 0
    end,
    case lists:keyfind(personal_num, 1, RewardCondition) of
        {_, PerLimit} -> PerLimit;
        _ -> PerLimit = 0
    end,
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(role_lv, 1, Condition) of
                {_, DefLv} -> skip;
                _ ->
                    DefLv = 0
            end,
            case lists:keyfind(clear_type, 1, RewardCondition) of
                {_, ClearType} -> skip;
                _ ->
                    ClearType = 0
            end,
            if
                Player#player_status.figure#figure.lv < DefLv -> false;
                true ->
                    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
                        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
                            case ClearType of
                                day ->
                                    case Utime >= UnixDate of
                                        true ->
                                            if
                                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes >= PerLimit orelse ExchangeTime >= AllLimit, false, {true, ReceiveTimes + 1});
                                                AllLimit =/= 0 andalso PerLimit == 0 ->
                                                    ?IF(ExchangeTime >= AllLimit, false, {true, ReceiveTimes + 1});
                                                AllLimit == 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes >= PerLimit, false, {true, ReceiveTimes + 1});
                                                true ->
                                                    {true, ReceiveTimes + 1}
                                            end;
                                        false -> {true, 1}
                                    end;
                                _ ->
                                    case Utime >= Stime andalso Utime =< Etime of
                                        true ->
                                            if
                                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes >= PerLimit orelse ExchangeTime >= AllLimit, false, {true, ReceiveTimes + 1});
                                                AllLimit == 0 ->
                                                    ?IF(ReceiveTimes >= PerLimit, false, {true, ReceiveTimes + 1});
                                                true ->
                                                    {true, ReceiveTimes + 1}
                                            end;
                                        false -> {true, 1}
                                    end
                            end;
                        _ ->
                            if
                                AllLimit =/= 0 ->
                                    ?IF(ExchangeTime >= AllLimit, false, {true, 1});
                                true ->
                                    {true, 1}
                            end
                    end
            end;
        _ ->
            false
    end;

check_reward_receive_times(Player, #act_info{key = {Type, SubType}, wlv = Wlv, stime = Stime, etime = Etime}, #custom_act_reward_cfg{condition = RewardCondition, grade = GradeId})
when Type == ?CUSTOM_ACT_TYPE_TREE_SHOP; Type == ?CUSTOM_ACT_TYPE_SALE ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    UnixDate = utime:standard_unixdate(),
    {_, PerLimit} = ulists:keyfind(exchange_num, 1, RewardCondition, {exchange_num, 0}),
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} ->
            {role_lv, DefLv} = ulists:keyfind(role_lv, 1, Condition, {role_lv, 0}),
            {clear_type, ClearType} = ulists:keyfind(clear_type, 1, RewardCondition, {clear_type, 0}),
            {wlv, NeedWlv} = ulists:keyfind(wlv, 1, RewardCondition, {wlv, 0}),
            if
                Player#player_status.figure#figure.lv < DefLv -> false;
                NeedWlv > Wlv -> false;
                true ->
                    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
                        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
                            case ClearType of
                                day ->
                                    case Utime >= UnixDate of
                                        true ->
                                            if
                                                PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes >= PerLimit, false, {true, ReceiveTimes + 1});
                                                true ->
                                                    {true, ReceiveTimes + 1}
                                            end;
                                        false -> {true, 1}
                                    end;
                                _ ->
                                    case Utime >= Stime andalso Utime =< Etime of
                                        true ->
                                            if
                                                PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes >= PerLimit, false, {true, ReceiveTimes + 1});
                                                true ->
                                                    {true, ReceiveTimes + 1}
                                            end;
                                        false -> {true, 1}
                                    end
                            end;
                        _ ->
                            {true, 1}
                    end
            end;
        _ ->
            false
    end;

check_reward_receive_times(_Player, #act_info{key = {?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, _SubType}}, #custom_act_reward_cfg{}) ->
    {true, 0};

check_reward_receive_times(Player, #act_info{key = {?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubType}}, #custom_act_reward_cfg{grade = GradeId}) ->
    #player_status{status_custom_act = CustomAct} = Player,
    #status_custom_act{reward_map = RewardMap, data_map = DataMap} = CustomAct,
    ActData = maps:get({?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubType}, DataMap, []),
    if
        ActData == [] ->
            false;
        true ->
            #custom_act_data{data = Data} = ActData,
%%            ?MYLOG("cym", "GradeId ~p~n", [GradeId]),
            case lists:keyfind(GradeId, 1, Data) of
                {_, Count, _SeeTime} -> %% 观看广告次数
                    #reward_status{receive_times = ReceiveTimes} = maps:get({?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubType, GradeId}, RewardMap, #reward_status{}),
                    if
                        Count > ReceiveTimes -> %% 观看广告次数大于领取次数， 可以领取
%%                            ?MYLOG("cym", "RewardMap ~p~n", [RewardMap]),
%%                            ?MYLOG("cym", "ReceiveTimes ~p~n", [ReceiveTimes]),
                            {true, ReceiveTimes + 1};
                        ReceiveTimes > 0 ->  %% 已经领取过了
                            {false, ?ERRCODE(err331_already_get_reward)};
                        true ->
                            false
                    end;
                _ -> %% 没有记录不能领取
                    false
            end
    end;

%% 特惠商城不在这判断次数
check_reward_receive_times(Player, #act_info{key = {?CUSTOM_ACT_TYPE_LIMIT_BUY, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{grade = GradeId}) ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    case maps:get({?CUSTOM_ACT_TYPE_LIMIT_BUY, SubType, GradeId}, RewardMap, []) of
        #reward_status{utime = Utime, receive_times = ReceiveTimes}
            when Utime >= Stime andalso Utime =< Etime ->
            {true, ReceiveTimes};
        _ ->
            {true, 0}
    end;

%% 连续充值 不带ps的检查
check_reward_receive_times(RewardList,
    #act_info{key = {_Type = ?CUSTOM_ACT_TYPE_CONTINUOUS_RECHARGE, _SubType}, stime = Stime, etime = Etime},
    #custom_act_reward_cfg{grade = GradeId}) when is_list(RewardList) ->
%%    #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    case lists:keyfind(GradeId, 1, RewardList) of
        {GradeId, ReceiveTimes, Utime} ->
            case Utime >= Stime andalso Utime =< Etime  andalso ReceiveTimes > 0 of
                true ->
                    false;
                false ->
                    {true, 1}
            end;
        _ ->
            {true, 1}
    end;

%% 开启期间只能领一次的活动
check_reward_receive_times(Player, #act_info{key = {Type, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{grade = GradeId}) when
        Type =:= ?CUSTOM_ACT_TYPE_7_RECHARGE;
        %Type =:= ?CUSTOM_ACT_TYPE_RECHARGE_GIFT;
        Type =:= ?CUSTOM_ACT_TYPE_FIVE_STAR;
        Type =:= ?CUSTOM_ACT_TYPE_SIGN_REWARD;
        Type =:= ?CUSTOM_ACT_TYPE_CONSUME;
        %Type =:= ?CUSTOM_ACT_TYPE_GWAR;
        Type =:= ?CUSTOM_ACT_TYPE_RECHARGE_CONSUME;
        Type =:= ?CUSTOM_ACT_TYPE_OVERFLOW_GIFTBAG;
        Type =:= ?CUSTOM_ACT_TYPE_SPEC_SELL;
        Type =:= ?CUSTOM_ACT_TYPE_DAILY_TURNTABLE;
        Type =:= ?CUSTOM_ACT_TYPE_FASHION_ACT;
        Type =:= ?CUSTOM_ACT_TYPE_TRAIN_STAGE;
        Type =:= ?CUSTOM_ACT_TYPE_TRAIN_POWER;
        Type =:= ?CUSTOM_ACT_TYPE_CONTINUOUS_RECHARGE;
        Type =:= ?CUSTOM_ACT_TYPE_QUESTIONNAIRE;
        Type =:= ?CUSTOM_ACT_TYPE_LV_GIFT;
        Type =:= ?CUSTOM_ACT_TYPE_LOGIN_REWARD;
        Type =:= ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE;
        Type =:= ?CUSTOM_ACT_TYPE_THE_CARNIVAL;
        Type =:= ?CUSTOM_ACT_TYPE_OVERSEAS_RECHARGE
    ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        #reward_status{utime = Utime, receive_times = ReceiveTimes}
        when Utime >= Stime andalso Utime =< Etime andalso ReceiveTimes > 0 ->
            false;
        _ ->
            {true, 1}
    end;
%% 终生只能领一次的活动
check_reward_receive_times(Player, #act_info{key = {Type, SubType}}, #custom_act_reward_cfg{grade = GradeId}) when
        Type =:= ?CUSTOM_ACT_TYPE_LV_BLOCK;
        Type =:= ?CUSTOM_ACT_TYPE_NAME_VERIFICATION ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        #reward_status{utime = _Utime, receive_times = ReceiveTimes}
        when ReceiveTimes > 0 ->
            false;
        _ ->
            {true, 1}
    end;
%% 开启期间每天领一次的活动
% check_reward_receive_times(Player, #act_info{key = {Type, SubType}}, #custom_act_reward_cfg{grade = GradeId}) when
% Type =:= 0 ->
%     StatusCustomAct = Player#player_status.status_custom_act,
%     RewardMap = StatusCustomAct#status_custom_act.reward_map,
%     UnixDate = utime:unixdate(),
%     case maps:get({Type, SubType, GradeId}, RewardMap, []) of
%         #reward_status{utime = Utime, receive_times = ReceiveTimes}
%         when Utime >= UnixDate andalso ReceiveTimes > 0 ->
%             false;
%         _ ->
%             {true, 1}
%     end;

%% 活动兑换
check_reward_receive_times(Player, #act_info{key = {?CUSTOM_ACT_TYPE_ACT_EXCHANGE = Type, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{grade = GradeId}) ->
    UnixDate = utime:standard_unixdate(),
    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_, ClearType} = lists:keyfind(clear_type, 1, Condition),
    #custom_act_reward_cfg{condition = RewardCondition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    {_, Limit} = lists:keyfind(exchange_limit, 1, RewardCondition),
    RewardMap = Player#player_status.status_custom_act#status_custom_act.reward_map,
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
            case ClearType  of
                day ->
                    case Utime >= UnixDate of
                        true -> ?IF(ReceiveTimes >= Limit, false, {true, ReceiveTimes + 1});
                        false -> {true, 1}
                    end;
                _ ->
                    case Utime >= Stime andalso Utime =< Etime of
                        true -> ?IF(ReceiveTimes >= Limit, false, {true, ReceiveTimes + 1});
                        false -> {true, 1}
                    end
            end;
        _ -> {true, 1}
    end;

%% 连续消费
check_reward_receive_times(#player_status{status_custom_act = #status_custom_act{reward_map = RewardMap}},
        #act_info{key = {Type = ?CUSTOM_ACT_TYPE_CONTINUE_CONSUME, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{grade = GradeId}) ->
    #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    [ClearType] = check_act_condtion([type], Condition),
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
            case ClearType of
                1 -> %% 单天的
                    case Utime >= utime:standard_unixdate() andalso ReceiveTimes > 0 of
                        true -> false;
                        false -> {true, 1}
                    end;
                2 -> %% 累计的
                    case Utime >= Stime andalso Utime =< Etime andalso ReceiveTimes > 0 of
                        true -> false;
                        false -> {true, 1}
                    end
            end;
        _ -> {true, 1}
    end;

%% 摇摇乐 累计的奖励仅领取一次
check_reward_receive_times(Player, #act_info{key = {?CUSTOM_ACT_TYPE_SHAKE, SubType}, stime = Stime, etime = Etime}, RwInfo) ->
    #player_status{status_custom_act = #status_custom_act{reward_map = RewardMap}} = Player,
    #custom_act_reward_cfg{grade = GradeId} = RwInfo,
    #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_SHAKE, SubType, GradeId),
    case check_act_condtion([stage], Condition) of
        false ->
            false;
        _Stage ->
            % 当获取摇摇乐的时间在次日
            case maps:get({?CUSTOM_ACT_TYPE_SHAKE, SubType, GradeId}, RewardMap, []) of
                #reward_status{utime = Utime, receive_times = _ReceiveTimes} when Utime >= Stime andalso Utime =< Etime ->
                    false;
%%                    NowTime = utime:unixtime(),
%%                    case lib_shake:get_draw_last_time(Player, SubType) of
%%                        Time when Time =/= 0 ->
%%                            case utime:is_same_day(NowTime, Utime) of
%%                                true -> false;
%%                                false -> {true, 1}
%%                            end;
%%                        _ -> false
%%                    end;
                [] -> % 未领取奖励的
                    {true, 1};
                _ ->
                    false
            end
    end;

%% 累积充值
check_reward_receive_times(#player_status{status_custom_act = #status_custom_act{reward_map = RewardMap}},
    #act_info{key = {Type = ?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{grade = GradeId}) ->
    #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    case check_act_condtion([type], Condition) of
        [ClearType] ->
            skip;
        _ ->
            ClearType = 2
    end,
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
            IsSameClearDay = lib_custom_act_util:in_same_clear_day(?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType, utime:unixtime(), Utime),
            case ClearType of
                1 -> %% 单天的
                    case IsSameClearDay andalso ReceiveTimes > 0 of
                        true -> false;
                        false -> {true, 1}
                    end;
                2 -> %% 累计的
                    case Utime >= Stime andalso Utime =< Etime andalso ReceiveTimes > 0 of
                        true -> false;
                        false -> {true, 1}
                    end
            end;
        _ -> {true, 1}
    end;

%% 累积充值 不带ps的检查
check_reward_receive_times(RewardList,
    #act_info{key = {Type = ?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType}, stime = Stime, etime = Etime},
    #custom_act_reward_cfg{grade = GradeId}) when is_list(RewardList) ->
    #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    case check_act_condtion([type], Condition) of
        [ClearType] ->
            skip;
        _ ->
            ClearType = 2
    end,
    case lists:keyfind(GradeId, 1, RewardList) of
        {GradeId, ReceiveTimes, Utime} ->
            IsSameClearDay = lib_custom_act_util:in_same_clear_day(?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType, utime:unixtime(), Utime),
            case ClearType of
                1 -> %% 单天的
                    case IsSameClearDay andalso ReceiveTimes > 0 of
                        true -> false;
                        false -> {true, 1}
                    end;
                2 -> %% 累计的
%%                    ?MYLOG("cym", "Utime ~p Stime ~p  ReceiveTimes ~p ~n" , [Utime, Stime, ReceiveTimes]),
                    case Utime >= Stime andalso Utime =< Etime  andalso ReceiveTimes > 0 of
                        true ->
                            false;
                        false ->
                            {true, 1}
                    end
            end;
        _ ->
            {true, 1}
    end;


%% 每日补给
check_reward_receive_times(#player_status{status_custom_act = #status_custom_act{reward_map = RewardMap}},
        #act_info{key = {Type = ?CUSTOM_ACT_TYPE_SUPPLY, SubType}}, #custom_act_reward_cfg{grade = GradeId}) ->
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
            IsSameClearDay = lib_custom_act_util:in_same_clear_day(?CUSTOM_ACT_TYPE_SUPPLY, SubType, utime:unixtime(), Utime),
            case IsSameClearDay of
                true -> %%
                    case ReceiveTimes > 0 of  % 今天已经领取就不可以再领
                        true -> false;
                        false -> {true, 1}
                    end;
                false -> %% 上次奖励领取的时间已经被清理
                    {true, 1}
            end;
        _ -> {true, 1}
    end;


%% 节日兑换活动
check_reward_receive_times(Player, #act_info{key = {?CUSTOM_ACT_TYPE_EXCHANGE_NEW = Type, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{grade = GradeId}) ->
    UnixDate = utime:standard_unixdate(),
    #custom_act_reward_cfg{condition = RewardCondition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    {_, Limit} = lists:keyfind(exchang_times, 1, RewardCondition),
    {_, ClearType} = lists:keyfind(refresh, 1, RewardCondition),
    RewardMap = Player#player_status.status_custom_act#status_custom_act.reward_map,
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
            case ClearType =:= 1 of
                true ->
                    case Utime >= UnixDate of
                        true -> ?IF(ReceiveTimes >= Limit, false, {true, ReceiveTimes + 1});
                        false -> {true, 1}
                    end;
                false ->
                    case Utime >= Stime andalso Utime =< Etime of
                        true -> ?IF(ReceiveTimes >= Limit, false, {true, ReceiveTimes + 1});
                        false -> {true, 1}
                    end
            end;
        _ -> {true, 1}
    end;

%% 奖励独立判断清理
%% 活跃奖励
%% 70:关注公众号
check_reward_receive_times(
        #player_status{status_custom_act = #status_custom_act{reward_map = RewardMap}}
        , #act_info{key = {Type, SubType}, stime = Stime, etime = Etime}
        , #custom_act_reward_cfg{grade = GradeId} = RewardCfg
        ) when
            Type == ?CUSTOM_ACT_TYPE_LIVENESS;
            Type == ?CUSTOM_ACT_TYPE_FOLLOW ->
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
            % 奖励单独
            IsSameClearDay = lib_custom_act_util:reward_in_same_clear_day(RewardCfg, utime:unixtime(), Utime),
            case IsSameClearDay of
                true ->
                    %% 同一清理天数不清理
                    case Utime >= Stime andalso Utime =< Etime andalso ReceiveTimes > 0 of
                        true -> false;
                        false -> {true, 1}
                    end;
                _ -> %% 上次奖励领取的时间已经被清理
                    {true, 1}
            end;
        _ -> {true, 1}
    end;

%% 超级特惠礼包
check_reward_receive_times(
        #player_status{status_custom_act = #status_custom_act{reward_map = RewardMap}}
        , #act_info{key = {Type, SubType}, stime = Stime, etime = Etime}
        , #custom_act_reward_cfg{grade = GradeId, condition = Condition}
        ) when Type == ?CUSTOM_ACT_TYPE_SPECIAL_GIFT ->
    case lists:keyfind(limit_buy, 1, Condition) of
        false -> false;
        {limit_buy, LimitBuyTimes} ->
            case maps:get({Type, SubType, GradeId}, RewardMap, []) of
                #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
                    case Utime >= Stime andalso Utime =< Etime andalso ReceiveTimes >= LimitBuyTimes of
                        true -> false;
                        false -> {true, ReceiveTimes + 1}
                    end;
                _ -> {true, 1}
            end
    end;

%% 系统邮件(为了兼容调用 lib_custom_act_check:check_receive_reward/4, 此处检查总是为真, 真实检查在lib_custom_act_sys_mail中)
check_reward_receive_times(_PS, #act_info{key = {?CUSTOM_ACT_TYPE_SYS_MAIL, _}}, _) ->
    {true, 1};

% %% 每天清理判断
% check_reward_receive_times(
%         #player_status{status_custom_act = #status_custom_act{reward_map = RewardMap}}
%         , #act_info{key = {Type, SubType}}
%         , #custom_act_reward_cfg{grade = GradeId} = RewardCfg
%         ) ->
%     case maps:get({Type, SubType, GradeId}, RewardMap, []) of
%         #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
%             IsSameClearDay = lib_custom_act_util:in_same_clear_day(Type, SubType, utime:unixtime(), Utime),
%             case IsSameClearDay of
%                 true ->
%                     %% 同一清理天数不清理
%                     case ReceiveTimes > 0 of
%                         true -> false;
%                         false -> {true, 1}
%                     end;
%                 _ -> %% 上次奖励领取的时间已经被清理
%                     {true, 1}
%             end;
%         _ -> {true, 1}
%     end;

check_reward_receive_times(_, _, _) ->
    false.

%% 开服集字活动没有次数限制
check_reward_receive_times(Player, #act_info{key = {?CUSTOM_ACT_TYPE_COLWORD = Type, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{condition = RewardCondition, grade = GradeId}, Num) ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    UnixDate = utime:standard_unixdate(),
    {_, _ExGoods, ModId, CounterId} = lists:keyfind(goods_exchange, 1, RewardCondition),
    if
        ModId > 0 andalso CounterId > 0 ->
            [{_, ExchangeTime} | _] = mod_global_counter:get_count([{ModId, Type, CounterId}],[{global_diff_day, 1}]);
        true ->
            ExchangeTime = 0
    end,
    case lists:keyfind(all_num, 1, RewardCondition) of
        {_, AllLimit} -> AllLimit;
        _ -> AllLimit = 0
    end,
    case lists:keyfind(personal_num, 1, RewardCondition) of
        {_, PerLimit} -> PerLimit;
        _ -> PerLimit = 0
    end,
    case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_COLWORD, SubType) of
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(role_lv, 1, Condition) of
                {_, DefLv} -> skip;
                _ ->
                    DefLv = 0
            end,
            {_, ClearType} = lists:keyfind(clear_type, 1, Condition),
            if
                Player#player_status.figure#figure.lv < DefLv -> false;
                true ->
                    case maps:get({?CUSTOM_ACT_TYPE_COLWORD, SubType, GradeId}, RewardMap, []) of
                        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
                            case ClearType of
                                day ->
                                    case Utime >= UnixDate of
                                        true ->
                                            if
                                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes+Num > PerLimit orelse ExchangeTime+Num > AllLimit, false, {true, ReceiveTimes + Num});
                                                AllLimit =/= 0 andalso PerLimit == 0 ->
                                                    ?IF(ExchangeTime+Num > AllLimit, false, {true, ReceiveTimes + Num});
                                                AllLimit == 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes+Num > PerLimit, false, {true, ReceiveTimes + Num});
                                                true ->
                                                    {true, ReceiveTimes + Num}
                                            end;
                                        false ->
                                            if
                                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                                    ?IF(Num > PerLimit orelse ExchangeTime+Num > AllLimit, false, {true, Num});
                                                AllLimit =/= 0 andalso PerLimit == 0 ->
                                                    ?IF(ExchangeTime+Num > AllLimit, false, {true, Num});
                                                AllLimit == 0 andalso PerLimit =/= 0 ->
                                                    ?IF(Num > PerLimit, false, {true, Num});
                                                true ->
                                                    {true, Num}
                                            end
                                    end;
                                _ ->
                                    case Utime >= Stime andalso Utime =< Etime of
                                        true ->
                                            if
                                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes+Num > PerLimit orelse ExchangeTime+Num > AllLimit, false, {true, ReceiveTimes + Num});
                                                AllLimit == 0 ->
                                                    ?IF(ReceiveTimes+Num > PerLimit, false, {true, ReceiveTimes + Num});
                                                PerLimit == 0 ->
                                                    {true, ReceiveTimes + Num}
                                            end;
                                        false ->
                                            false
                                    end
                            end;
                        _ ->
                            if
                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                    ?IF(Num > PerLimit orelse ExchangeTime+Num > AllLimit, false, {true, Num});
                                AllLimit =/= 0 andalso PerLimit == 0 ->
                                    ?IF(ExchangeTime+Num > AllLimit, false, {true, Num});
                                AllLimit == 0 andalso PerLimit =/= 0 ->
                                    ?IF(Num > PerLimit, false, {true, Num});
                                true ->
                                    {true, Num}
                            end
                    end
            end;
        _ ->
            false
    end;

check_reward_receive_times(Player, #act_info{key = {Type, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{condition = RewardCondition, grade = GradeId}, Num)
when Type == ?CUSTOM_ACT_TYPE_FEAST_SHOP orelse Type  == ?CUSTOM_ACT_TYPE_BUY orelse Type == ?CUSTOM_ACT_TYPE_SHOP_REWARD orelse Type == ?CUSTOM_ACT_TYPE_RUSH_BUY ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    UnixDate = utime:standard_unixdate(),
    case lists:keyfind(sp_gap_time, 1, RewardCondition) of
        {_, Day} -> Day;
        _ -> Day = 1
    end,
    case lists:keyfind(counter, 1, RewardCondition) of
        {_, ModId, CounterId} -> Day;
        _ -> ModId = 0,CounterId = 0
    end,
    if
        ModId > 0 andalso CounterId > 0 ->
            [{_, ExchangeTime} | _] = mod_global_counter:get_count([{ModId, Type, CounterId}],[{global_diff_day, Day}]);
        true ->
            ExchangeTime = 0
    end,
    case lists:keyfind(all_num, 1, RewardCondition) of
        {_, AllLimit} -> AllLimit;
        _ -> AllLimit = 0
    end,
    case lists:keyfind(personal_num, 1, RewardCondition) of
        {_, PerLimit} -> PerLimit;
        _ -> PerLimit = 0
    end,
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(role_lv, 1, Condition) of
                {_, DefLv} -> skip;
                _ ->
                    DefLv = 0
            end,
            case lists:keyfind(clear_type, 1, RewardCondition) of
                {_, ClearType} -> skip;
                _ ->
                    ClearType = 0
            end,
            if
                Player#player_status.figure#figure.lv < DefLv -> false;
                true ->
                    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
                        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
                            case ClearType of
                                day ->
                                    case Utime >= UnixDate of
                                        true ->
                                            if
                                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes+Num > PerLimit orelse ExchangeTime+Num > AllLimit, false, {true, ReceiveTimes + Num});
                                                AllLimit =/= 0 andalso PerLimit == 0 ->
                                                    ?IF(ExchangeTime+Num > AllLimit, false, {true, ReceiveTimes + Num});
                                                AllLimit == 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes+Num > PerLimit, false, {true, ReceiveTimes + Num});
                                                true ->
                                                    {true, ReceiveTimes + Num}
                                            end;
                                        false ->
                                            if
                                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                                    ?IF(Num > PerLimit orelse ExchangeTime+Num > AllLimit, false, {true, Num});
                                                AllLimit =/= 0 andalso PerLimit == 0 ->
                                                    ?IF(ExchangeTime+Num > AllLimit, false, {true, Num});
                                                AllLimit == 0 andalso PerLimit =/= 0 ->
                                                    ?IF(Num > PerLimit, false, {true, Num});
                                                true ->
                                                    {true, Num}
                                            end
                                    end;
                                _ ->
                                    case Utime >= Stime andalso Utime =< Etime of
                                        true ->
                                            if
                                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes+Num > PerLimit orelse ExchangeTime+Num > AllLimit, false, {true, ReceiveTimes + Num});
                                                AllLimit == 0 ->
                                                    ?IF(ReceiveTimes+Num > PerLimit, false, {true, ReceiveTimes + Num});
                                                true ->
                                                    {true, ReceiveTimes + Num}
                                            end;
                                        false ->
                                            false
                                    end
                            end;
                        _ ->
                            if
                                AllLimit =/= 0 andalso PerLimit =/= 0 ->
                                    ?IF(Num > PerLimit orelse ExchangeTime+Num > AllLimit, false, {true, Num});
                                AllLimit =/= 0 andalso PerLimit == 0 ->
                                    ?IF(ExchangeTime+Num > AllLimit, false, {true, Num});
                                AllLimit == 0 andalso PerLimit =/= 0 ->
                                    ?IF(Num > PerLimit, false, {true, Num});
                                true ->
                                    {true, Num}
                            end
                    end
            end;
        _ ->
            false
    end;

%% 节日兑换活动
check_reward_receive_times(Player, #act_info{key = {?CUSTOM_ACT_TYPE_EXCHANGE_NEW = Type, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{grade = GradeId}, Num) ->
    UnixDate = utime:standard_unixdate(),
    #custom_act_reward_cfg{condition = RewardCondition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    {_, Limit} = lists:keyfind(exchang_times, 1, RewardCondition),
    {_, ClearType} = lists:keyfind(refresh, 1, RewardCondition),
    RewardMap = Player#player_status.status_custom_act#status_custom_act.reward_map,
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
            case ClearType =:= 1 of
                true ->
                    case Utime >= UnixDate of
                        true -> ?IF(ReceiveTimes + Num > Limit, false, {true, ReceiveTimes + Num});
                        false -> {true, Num}
                    end;
                false ->
                    case Utime >= Stime andalso Utime =< Etime of
                        true -> ?IF(ReceiveTimes + Num > Limit, false, {true, ReceiveTimes + Num});
                        false -> {true, Num}
                    end
            end;
        _ -> {true, Num}
    end;

check_reward_receive_times(Player, #act_info{key = {Type, SubType}, wlv = Wlv, stime = Stime, etime = Etime}, #custom_act_reward_cfg{condition = RewardCondition, grade = GradeId}, Num)
when Type == ?CUSTOM_ACT_TYPE_TREE_SHOP ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    UnixDate = utime:standard_unixdate(),
    {exchange_num, PerLimit} = ulists:keyfind(exchange_num, 1, RewardCondition, {exchange_num, 0}),
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} ->
            {role_lv, DefLv} = ulists:keyfind(role_lv, 1, Condition, {role_lv, 0}),
            {clear_type, ClearType} = ulists:keyfind(clear_type, 1, RewardCondition, {clear_type, 0}),
            {wlv, NeedWlv} = ulists:keyfind(wlv, 1, RewardCondition, {wlv, 0}),
            if
                Player#player_status.figure#figure.lv < DefLv -> false;
                NeedWlv > Wlv -> false;
                true ->
                    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
                        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
                            case ClearType of
                                day ->
                                    case Utime >= UnixDate of
                                        true ->
                                            if
                                                PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes+Num > PerLimit, false, {true, ReceiveTimes + Num});
                                                true ->
                                                    {true, ReceiveTimes + Num}
                                            end;
                                        false -> {true, Num}
                                    end;
                                _ ->
                                    case Utime >= Stime andalso Utime =< Etime of
                                        true ->
                                            if
                                                PerLimit =/= 0 ->
                                                    ?IF(ReceiveTimes+Num > PerLimit, false, {true, ReceiveTimes + Num});
                                                true ->
                                                    {true, ReceiveTimes + Num}
                                            end;
                                        false -> {true, Num}
                                    end
                            end;
                        _ ->
                            {true, Num}
                    end
            end;
        _ ->
            false
    end;

check_reward_receive_times(_, _, _, _) ->
    false.

%% 检查活动的世界等级
% check_reward_in_wlv(Type, SubType, [{wlv, Wlv}, {role_lv, RoleLv}], RewardCfg)
check_reward_in_wlv(Type, SubType, Wlv, RewardCfg) when is_integer(Wlv) ->
    check_reward_in_wlv(Type, SubType, [{wlv, Wlv}], RewardCfg);
check_reward_in_wlv(_Type, _SubType, [], _RewardCfg) -> true;
check_reward_in_wlv(Type, SubType, CheckList, GradeId) when is_integer(GradeId) ->
    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    check_reward_in_wlv(Type, SubType, CheckList, RewardCfg);
check_reward_in_wlv(Type, SubType, [{wlv, Wlv}|CheckList], RewardCfg) ->
    case RewardCfg of
        #custom_act_reward_cfg{
            condition = Condition
        } ->
            case lists:keyfind(wlv, 1, Condition) of
                {_, [{Min, Max}|_]} when Wlv > Max orelse Wlv < Min ->
                    {false, ?ERRCODE(err331_cannot_get_reward_out_wlv)};
                {_, WlvCfg} when is_integer(WlvCfg) andalso WlvCfg > Wlv  ->
                    {false, ?ERRCODE(err331_cannot_get_reward_out_wlv)};
                _ ->
                    check_reward_in_wlv(Type, SubType, CheckList, RewardCfg)
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end;
check_reward_in_wlv(Type, SubType, [{role_lv, RoleLv}|CheckList], RewardCfg) ->
    case RewardCfg of
        #custom_act_reward_cfg{
            condition = Condition
        } ->
            case lists:keyfind(role_lv, 1, Condition) of
                {_, [{Min, Max}|_]} when RoleLv > Max orelse RoleLv < Min ->
                    {false, ?ERRCODE(err331_lv_not_enougth)};
                {_, WlvCfg} when is_integer(WlvCfg) andalso WlvCfg > RoleLv  ->
                    {false, ?ERRCODE(err331_lv_not_enougth)};
                _ ->
                    check_reward_in_wlv(Type, SubType, CheckList, RewardCfg)
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end;
check_reward_in_wlv(Type, SubType, [{open_day}|CheckList], RewardCfg) ->
    case RewardCfg of
        #custom_act_reward_cfg{
            condition = Condition
        } ->
            Opday = util:get_open_day(),
            case lists:keyfind(open_day, 1, Condition) of
                {_, List} when is_list(List) ->
                    F = fun({DayMin, DayMax}) ->
                        Opday >= DayMin andalso Opday =< DayMax
                    end,
                    case ulists:find(F, List) of
                        {ok, _} ->
                            check_reward_in_wlv(Type, SubType, CheckList, RewardCfg);
                        _ ->
                            {false, ?ERRCODE(err405_open_day_limit)}
                    end;
                {_, DayCfg} when is_integer(DayCfg) andalso DayCfg > Opday  ->
                    {false, ?ERRCODE(err405_open_day_limit)};
                _ ->
                    check_reward_in_wlv(Type, SubType, CheckList, RewardCfg)
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end;
check_reward_in_wlv(Type, SubType, [_|CheckList], RewardCfg) ->
    check_reward_in_wlv(Type, SubType, CheckList, RewardCfg).

%% 检测定制活动Condition字段的配置
check_act_condition(Type, SubType, List) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} -> check_act_condtion(List, Condition);
        _ -> false
    end.

check_act_reward_condition(Type, SubType, RewardId, List) ->
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of
        #custom_act_reward_cfg{condition = Condition} -> check_act_condtion(List, Condition);
        _ -> false
    end.

%%--------------------------------------------------
%% 检测定制活动Condition字段的配置
%% @param  List      需要检查Condition里面的Key组成的List
%% @param  Condition 定制活动Condition字段
%% @return           false|[value]
%%--------------------------------------------------
check_act_condtion(List, Condition) ->
    do_check_act_condtion(List, Condition, []).

do_check_act_condtion([], _Condition, Result) ->
    lists:reverse(Result);
do_check_act_condtion([H | List], Condition, Result) ->
    case is_atom(H) of
        true ->
            case lists:keyfind(H, 1, Condition) of
                {H, Value} ->
                    do_check_act_condtion(List, Condition, [Value | Result]);
                _ -> false
            end;
        false -> false
    end.

check_list([]) -> true;
check_list([T | L]) ->
    case do_check(T) of
        true ->
            check_list(L);
        {false, Errcode} ->
            {false, Errcode}
    end.

%% 开服时间判断
do_check({cur_open_time_lim, OpenStartTime, OpenEndTime, CurOpenTime}) ->
    case util:is_cls() of
        true -> true;
        false ->
            case CurOpenTime >= OpenStartTime andalso CurOpenTime =< OpenEndTime of
                true -> true;
                false -> {false, ?FAIL}
            end
    end;
do_check({opday_lim, OpdayLim, Opday}) ->
    case OpdayLim =/= [] of
        true ->
            case util:is_cls() of
                false ->
                    case ulists:is_in_range(OpdayLim, Opday) of
                        false ->
                            {false, ?FAIL};
                        _ -> true
                    end;
                true -> true
            end;
        _ -> true
    end;
do_check({merday_lim, MerdayLim, MergeDay}) ->
    case MerdayLim =/= [] of
        true ->
            case util:is_cls() of
                false ->
                    case ulists:is_in_range(MerdayLim, MergeDay) of
                        false ->
                            {false, ?FAIL};
                        _ -> true
                    end;
                true -> true
            end;
        _ -> true
    end;
do_check({wlv_lim, WLvLim, WorldLv}) ->
    case WLvLim =/= [] of
        true ->
            case util:is_cls() of
                false ->
                    case ulists:is_in_range(WLvLim, WorldLv) of
                        false ->
                            {false, ?FAIL};
                        _ -> true
                    end;
                true -> true
            end;
        _ -> true
    end;

do_check(_) -> {false, ?FAIL}.
