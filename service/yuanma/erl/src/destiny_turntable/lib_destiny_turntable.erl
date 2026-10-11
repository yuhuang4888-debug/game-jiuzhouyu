%% ---------------------------------------------------------------------------
%% @doc lib_destiny_turntable

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/5/14
%% @deprecated  %% 天命转盘
%% ---------------------------------------------------------------------------
-module(lib_destiny_turntable).

%% API
-export([send_act_info/2, turntable/2, handle_event/2, act_end/1, check_is_reward_pool/5,
    daily_refresh/0, send_reward_status/3, receive_reward/4, gm_add_turntable_point/2,
    gm_add_destiny_point_by_weekly_card/0, add_destiny_point_by_weekly_card/2]).

-include("custom_act.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("weekly_card.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("predefine.hrl").
-include("investment.hrl").
-include("rec_recharge.hrl").

-define(NO_GET,     0).
-define(HAD_GET,    1).


%% 钻石消耗
handle_event(PS, #event_callback{type_id = ?EVENT_MONEY_CONSUME, data = Data})  ->
    #callback_money_cost{consume_type = ConsumeType, money_type = MoneyType, cost = Cost} = Data,
    case lib_consume_data:is_consume_for_act(ConsumeType) of
        true ->
            case MoneyType =:= ?GOLD of
                true ->
                    SubList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_DESTINY_TURN),
                    add_turntable_point(SubList, PS, ConsumeType, Cost);
                false -> {ok, PS}
            end;
        _ -> {ok, PS}
    end;

%% 充值事件
handle_event(PS, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{recharge_product = Product, gold = Gold}}) ->
    #base_recharge_product{product_id = ProductId, money = Money} = Product,
    Cost =
    case lib_vsn:is_cn() of
        true -> Money * 10; % 特殊规则：月卡/周卡充值积分 = 消耗金额 * 10
        false -> lib_recharge_api:special_recharge_gold(Product, Gold) % 因外服充值金额有小数点，改为对应价值的钻石
    end,
    if
        ProductId == ?MONTH_CARD_RECHARGE_ID ->
            SubList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_DESTINY_TURN),
            add_turntable_point(SubList, PS, 'investment_buy', Cost);

        ProductId == ?WEEK_CARD_RECHARGE_ID ->
            SubList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_DESTINY_TURN),
            add_turntable_point(SubList, PS, 'weekly_buy', Cost);
        true ->
            {ok, PS}
    end.

%% 每日零点刷新
daily_refresh() ->
    OpSubtypeL = lib_custom_act_util:get_custom_act_open_list(),
    OpenTurnActL = [Act || #act_info{key = {Type, _}} = Act <- OpSubtypeL, Type == ?CUSTOM_ACT_TYPE_DESTINY_TURN],
    lists:foreach(
    fun(#act_info{key = {Type, SubType}}) ->
        spawn(
            fun() ->
                timer:sleep(2000), % 延迟2秒等待日计数器清理
                lib_player:apply_cast_all_online(?APPLY_CAST_STATUS, lib_destiny_turntable, send_reward_status, [Type, SubType])
            end
        )
    end
    , OpenTurnActL).

%% 每日免费奖励信息
send_reward_status(PS, Type, SubType) ->
    #player_status{id = RoleId} = PS,
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, AccL) ->
        #custom_act_reward_cfg{
            name = Name,
            desc = Desc,
            condition = Condition,
            format = Format,
            reward = Reward
        } = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        case ulists:keyfind(is_free, 1, Condition, {is_free, false}) of
            {_, false} -> AccL;
            {_, true} ->
                ReceiveTimes = mod_daily:get_count(RoleId, ?MOD_AC_CUSTOM, Type, ?CUSTOM_ACT_COUNTER_TYPE(SubType, GradeId)),
                RewardStatus = ?IF(ReceiveTimes == 0, ?ACT_REWARD_CAN_GET, ?ACT_REWARD_HAS_GET),
                ConditionStr = util:term_to_string(Condition),
                RewardStr = util:term_to_string(Reward),
                [{GradeId, Format, RewardStatus, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | AccL]
        end
    end,
    PackList = lists:foldl(F, [], GradeIds),
    lib_server_send:send_to_uid(RoleId, pt_331, 33104, [Type, SubType, PackList]),
    ok.

%% 领取每日免费奖励
receive_reward(PS, Type, SubType, GradeId) ->
    #player_status{id = RoleId} = PS,
    #custom_act_reward_cfg{
        condition = Condition,
        reward = Reward
    } = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    IsOpen = lib_custom_act_api:is_open_act(Type, SubType),
    ReceiveTimes = mod_daily:get_count(RoleId, ?MOD_AC_CUSTOM, Type, ?CUSTOM_ACT_COUNTER_TYPE(SubType, GradeId)),
    {is_free, IsFree} = ulists:keyfind(is_free, 1, Condition, {is_free, false}),
    case {IsOpen, IsFree, ReceiveTimes} of
        {true, true, 0} -> % 免费奖励且今天未领取
            lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = destiny_turnable}),
            mod_daily:increment(RoleId, ?MOD_AC_CUSTOM, Type, ?CUSTOM_ACT_COUNTER_TYPE(SubType, GradeId)),
            lib_log_api:log_custom_act_reward(PS, Type, SubType, GradeId, Reward),
            lib_server_send:send_to_uid(RoleId, pt_331, 33105, [?SUCCESS, Type, SubType, GradeId]);
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33105, [?FAIL, Type, SubType, GradeId])
    end,
    ok.

%% 发送活动信息
send_act_info(PS, #act_info{key = {Type, SubType}}) ->
    case get_turntable_info(PS, Type, SubType) of
        {true, AllPoint, GetGrades, Turn, NeedPoint, CustomCondition} ->
            JumpIds = data_destiny_turnable:get_double_jump_ids(),
            JumpInfos = pack_jumps_info(PS, JumpIds),
            {MaxTurn, _} = get_max_turn(CustomCondition),
            RewardList = load_reward_list(Type, SubType, GetGrades),
            Label = get_now_label(Type, SubType, GetGrades),
            lib_server_send:send_to_uid(PS#player_status.id, pt_332, 33238, [Type, SubType, Turn, AllPoint, NeedPoint, MaxTurn, RewardList, JumpInfos, Label]);
        _ -> skip
    end.

%% 获得当前显示的标签
get_now_label(Type, SubType, GetGrades) ->
    CustomActInfo = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    #custom_act_cfg{condition = Condition} = CustomActInfo,
    {label, DayList} = ulists:keyfind(label, 1, Condition, {label, []}),
    OpenDay = util:get_open_day(),
    {_Day, LabelList} = ulists:keyfind(OpenDay, 1, DayList, {0, []}),
    F = fun({WeightA, _LabelA}, {WeightB, _LabelB}) -> WeightA >= WeightB end,
    NewLabelList = lists:sort(F, LabelList),
    Ids = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F1 = fun(GradeId) ->
        #custom_act_reward_cfg{condition = RewardCondition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        {_, IsFree} = ulists:keyfind(is_free, 1, RewardCondition, {is_free, false}),
        not IsFree
    end,
    Ids1 = lists:filter(F1, Ids),
    ?IF(length(Ids1) =:= length(GetGrades), 0, hd([Label || {_Weight, Label} <- NewLabelList, lists:member(Label, GetGrades) == false])).

%% 转盘抽抽抽
turntable(PS, #act_info{key = {Type, SubType}}) ->
    case do_turntable(PS, Type, SubType) of
        {true, NewPlayer} ->
            {ok, NewPlayer};
        {false, ErrorCode} ->
            lib_server_send:send_to_uid(PS#player_status.id, pt_332, 33240, [ErrorCode, Type, SubType, 0, 0, 0, 0])
    end.

%% 秘籍添加天命值
gm_add_turntable_point(PS, AddPoint) ->
    SubList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_DESTINY_TURN),
    add_turntable_point(SubList, PS, 'gm', AddPoint).

%% 消耗钻石添加点数
%% 需要兼容玩家等级未达到等级开启（等级未开始也要添加点数天命值，策划奇怪的需求
add_turntable_point([], PS, _ConsumeType, _Cost) -> {ok, PS};
add_turntable_point([SubType|T], PS, ConsumeType, Cost) ->
    Type = ?CUSTOM_ACT_TYPE_DESTINY_TURN,
    ResInfo = get_turntable_info(PS, Type, SubType),
    if
        ResInfo =:= false -> add_turntable_point(T, PS, ConsumeType, Cost);
        true ->
            case ResInfo of
                {level_limit, TurnInfo} -> skip;
                _ -> TurnInfo = ResInfo
            end,
            {true, AllPoint, GetGrades, Turn, NeedPoint, CustomCondition} = TurnInfo,
            {MaxTurn, _} = get_max_turn(CustomCondition),
            if
                Turn > MaxTurn -> add_turntable_point(T, PS, ConsumeType, Cost);
                true ->
                    AddPoint = ?IF(is_double_point(PS, ConsumeType, Type, SubType), Cost * 2, Cost),
                    NewPoint = AddPoint + AllPoint,
                    NewData = {Turn, NewPoint, utime:unixtime(), GetGrades},
                    ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = NewData},
                    NewPlayer = lib_custom_act:save_act_data_to_player(PS, ActData),
%%                    ?PRINT("[Type, SubType, Turn, NewPoint, NeedPoint] ~p ~n", [[Type, SubType, Turn, NewPoint, NeedPoint]]),
                    lib_server_send:send_to_uid(PS#player_status.id, pt_332, 33239, [Type, SubType, Turn, NewPoint, NeedPoint]),
                    add_turntable_point(T, NewPlayer, ConsumeType, Cost)
            end
    end.

%% 是否可以触发双倍点数
%% @return boolean()
is_double_point(PS, ConsumeType, Type, SubType) ->
    #player_status{weekly_card_status = WeeklyCardStatus} = PS,
    case WeeklyCardStatus of
        #weekly_card_status{is_activity = IsActivity} -> skip;
        _ -> IsActivity = 0
    end,

    IsWeeklyDou = ConsumeType == weekly_buy andalso IsActivity == 0,

    % 是否常规的双倍consume type
    IsRegDouble = lists:member(ConsumeType, data_destiny_turnable:get_double_consume_type()) ,

    % 特殊条件下可触发双倍的consume type
    DoubleConsumeType = data_destiny_turnable:get_double_consume_type2(),
    IsSpecDouble = is_list(DoubleConsumeType) andalso lists:member(ConsumeType, DoubleConsumeType),

    % 按开服天数范围判断
    OpenDay = util:get_open_day(),
    case lib_custom_act_util:keyfind_act_condition(Type, SubType, 'double_opday') of
        false -> OpDayRange = undefined;
        {_, OpDayRange} -> skip
    end,
    IsOpDayDouble = IsSpecDouble andalso is_list(OpDayRange) andalso (ulists:is_in_range(OpDayRange, OpenDay) /= false),

    % 按时间戳范围判断
    NowTime = utime:unixtime(),
    case lib_custom_act_util:keyfind_act_condition(Type, SubType, 'double_timestamp') of
        false -> TimeStampRange = undefined;
        {_, TimeStampRange} -> skip
    end,
    IsTimeStampDouble = IsSpecDouble andalso is_list(TimeStampRange) andalso (ulists:is_in_range(TimeStampRange, NowTime) /= false),

    IsWeeklyDou orelse IsRegDouble orelse IsOpDayDouble orelse IsTimeStampDouble.

act_end(#act_info{key = {Type, SubType}}) ->
    % 1.减少无用数据
    % 2.防止复用子类型,活动记录更新时间在开始时间和结束时间之间导致数据不清理
    lib_custom_act:db_delete_custom_act_data(Type, SubType).


do_turntable(PS, Type, SubType) ->
    case get_turntable_info(PS, Type, SubType) of
        {true, AllPoint, GetGrades, Turn, NeedPoint, CustomCondition} ->
            {MaxTurn, _} = get_max_turn(CustomCondition),
            if
                AllPoint < NeedPoint -> {false, ?ERRCODE(err331_point_no_enough)};
                Turn > MaxTurn -> {false, ?ERRCODE(err331_max_turn)};
                true ->
                    Ids = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
                    WeightList =
                        [begin
                             RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
                             #custom_act_reward_cfg{condition = Condition} = RewardCfg,
                             {weight, Weight} = lists:keyfind(weight, 1, Condition),
                             {Weight, RewardCfg}
                         end||GradeId<-Ids, check_is_reward_pool(Type, SubType, GradeId, GetGrades, Turn)],
                    #custom_act_reward_cfg{condition = Condition, reward = Rewards, grade = Grade} =  urand:rand_with_weight(WeightList),
                    % 保存状态
                    NewTurn = Turn + 1, NewPoint = AllPoint - NeedPoint,
                    NewData = {NewTurn, NewPoint, utime:unixtime(), [Grade|GetGrades]},
                    ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = NewData},
                    NewPlayer = lib_custom_act:save_act_data_to_player(PS, ActData),
                    send_tv(Type, SubType, NewPlayer, Condition, Rewards),
                    {_, NextPoint} = get_turn_point(CustomCondition, NewTurn),
                    lib_server_send:send_to_uid(NewPlayer#player_status.id, pt_332, 33240, [?SUCCESS, Type, SubType, Grade, util:term_to_string(Rewards), NewTurn, NewPoint, NextPoint]),
                    %% 发奖励
                    Remark = lists:concat(["SubType:", SubType, "GradeId:", Grade]),
                    Produce = #produce{type = destiny_turnable, subtype = Type, remark = Remark, reward = Rewards, show_tips = ?SHOW_TIPS_0},
                    lib_log_api:log_custom_act_reward(NewPlayer, Type, SubType, Grade, Rewards),
                    LastPlayer = lib_goods_api:send_reward(NewPlayer, Produce),
                    pp_custom_act_list:handle(33238, LastPlayer, [Type, SubType]),
                    {true, LastPlayer}
            end;
        _ -> {false, ?FAIL}
    end.

check_is_reward_pool(Type, SubType, GradeId, GetGrades, Turn) ->
    IsDraw = lists:member(GradeId, GetGrades) == false,
    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    #custom_act_reward_cfg{condition = Condition} = RewardCfg,
    {turns, Turns} = lists:keyfind(turns, 1, Condition),
    {_, Free} = ulists:keyfind(is_free, 1, Condition, {is_free, false}),
    IsTurn = Turn >= Turns,
    IsDraw andalso IsTurn andalso (not Free).

%% 获取转盘信息
get_turntable_info(PS, Type, SubType) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = CustomCondition} ->
            {Turn_, AllPoint, _, GetGrades} = get_turntable_data(PS, Type, SubType),
            case lib_custom_act_check:check_act_condtion([turn, role_lv], CustomCondition) of
                [NeedPoints, NeedLv] ->
                    case lists:keyfind(Turn_, 1, NeedPoints) of
                        false -> Turn = Turn_, NeedPoint = 0;
                        {Turn, NeedPoint} -> skip
                    end,
                    %%     当前积分 已经领取的奖励  跳转  当前次数 所需point
                    Res = {true, AllPoint, GetGrades, Turn, NeedPoint, CustomCondition},
                    if
                        NeedLv > Lv -> %% 等级不够，不开放活动，但是会累计钻石消耗天命值（策划奇怪的需求
                            {level_limit, Res};
                        true -> Res
                    end;
                _ ->
                    ?ERR("destiny_turntable config err ~n", []),
                    false
            end;
        _ -> false
    end.


%% 获取转盘数据
get_turntable_data(PS, Type, SubType) ->
    case lib_custom_act:act_data(PS, Type, SubType) of
        #custom_act_data{data = []} ->
            UTime = utime:unixtime(),
            {1, 0, UTime, []};
        #custom_act_data{data = Data} ->
            Data;
        _ ->
            {1, 0, 0, []}
    end.

%% 获取最大次数信息
get_max_turn(CustomCondition) ->
    case lib_custom_act_check:check_act_condtion([turn], CustomCondition) of
        [NeedPoints] ->
            lists:last(NeedPoints);
        _ ->
            ?ERR("destiny_turntable config err ~n", []),
            {0, 0}
    end.

%% 获取制次数信息
get_turn_point(CustomCondition, Turn) ->
    case lib_custom_act_check:check_act_condtion([turn], CustomCondition) of
        [NeedPoints] ->
            case lists:keyfind(Turn, 1, NeedPoints) of
                false -> get_max_turn(CustomCondition);
                Res -> Res
            end;
        _ ->
            ?ERR("destiny_turntable config err ~n", []),
            {0, 0}
    end.

%% 加载奖励数据
load_reward_list(Type, SubType, GetGrades) ->
    Ids = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, ResList) ->
        #custom_act_reward_cfg{
            format = Format, name = Name,
            desc = Desc, reward = Reward,
            condition = Condition
        } = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        {_, IsFree} = ulists:keyfind(is_free, 1, Condition, {is_free, false}),
        case IsFree of
            false ->
                Status = ?IF(lists:member(GradeId, GetGrades), ?HAD_GET, ?NO_GET),
                Res = {GradeId, Format, Status, Name, Desc, util:term_to_string(Reward), util:term_to_string(Condition)},
                [Res | ResList];
            true -> % 过滤免费奖励
                ResList
        end
    end,
    lists:reverse(lists:foldl(F, [], Ids)).

%% 传闻
send_tv(Type, SubType, Player, Condition, Rewards) ->
    case lists:keyfind(is_rare,1,Condition) of
        {is_rare, 1} ->
            [{_, GoodsId, GoodsNum}|_] = Rewards,
            Name = lib_player:get_wrap_role_name(Player),
            spawn(fun() ->
                        timer:sleep(2000),
                        lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 57, [Name, Player#player_status.id, GoodsId, GoodsNum, Type, SubType])
                  end );
        _ -> skip
    end .

%% 打包跳转id信息（无法直视的代码~）
%% 判断跳转Id(购买活动)是否达成, 活动双倍积分跳转id变动次函数必须修改
%% @params JumpIds 指定的购买活动[购买vip，超级投资, 月卡投资]
pack_jumps_info(Ps, JumpIds) ->
    #player_status{figure = #figure{vip = Vip}, weekly_card_status = WeeklyCardStatus} = Ps,
    Now = utime:unixtime(),
    case JumpIds of
        [BuyVipJump, SuperInvestJump, MonCardJump, WeekJump] ->
            %% 已开启投资列表
            %% InvestOpenList： [{类型,展示id,状态（0代表没购买）, 时间}|_]
            InvestOpenList = lib_investment:handle_invest_show(Ps),
            MonCardType = 2,%% 月卡类型
            %% 获取所有开启的投资列表状态和是否购买了月卡状态
            case lists:keytake(MonCardType, 1, InvestOpenList) of
                false ->
                    IsBuyMonCard = 0, SuperInvestListStatus = InvestOpenList;
                {value,{MonCardType,_,IsBuyMonCardStatus,_},SuperInvestListStatus} ->
                    IsBuyMonCard = ?IF(IsBuyMonCardStatus =/= 0, 1, 0)
            end,
            %% 找出是否用没有购买的但是已经开启的超级投资
            IsAllInvestBut = ?IF(ulists:keyfind(0, 3, SuperInvestListStatus, false) == false, 1, 0),
            IsVip4 = ?IF(Vip >= 4, 1, 0),
            IsBuyWeekCard = ?IF(Now =< WeeklyCardStatus#weekly_card_status.expired_time, 1, 0),
            [{BuyVipJump, IsVip4}, {SuperInvestJump, IsAllInvestBut}, {MonCardJump, IsBuyMonCard}, {WeekJump, IsBuyWeekCard}];
        _ ->
            [{JumpId, 0}||JumpId<-JumpIds]
    end.

%% 秘籍为购买周卡的玩家增加天命转盘天命
gm_add_destiny_point_by_weekly_card() ->
    OpenDay = util:get_open_day(),
    Now = utime:unixtime(),
    OnlineList = ets:tab2list(?ETS_ONLINE),
    IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
    case OpenDay =< 7 of
        true ->
            Sql = io_lib:format(<<"SELECT `role_id` FROM log_weekly_card_open">>, []),
            AddRoleIdList = db:get_all(Sql),
            F = fun([RoleId], Acc) ->
                {_, OldTimes} = ulists:keyfind(RoleId, 1, Acc, {RoleId, 0}),

                lists:keystore(RoleId, 1, Acc, {RoleId, OldTimes + 1})
                end,
            CountRoleIdList = lists:foldl(F, [], AddRoleIdList),
            ActType = ?CUSTOM_ACT_TYPE_DESTINY_TURN,
            Sql2 = io_lib:format(<<"select `subtype`, `player_id`, `data_list` from `custom_act_data` where `type`= ~p">>, [ActType]),
            ActDataList = [{A, B, C} ||[A, B, C] <- db:get_all(Sql2)],
            Title = <<"天命转盘天命值补偿说明"/utf8>>,
            Content = <<"本次更新购买周卡将计入天命值计算，系统检测到您在本次更新前已购买周卡，已自动为您补偿相应天命值，祝您游戏愉快~"/utf8>>,
            F2 = fun({RoleId, Times}, Acc) ->
                mod_mail_queue:add({99, 1}, [RoleId], Title, Content, []),
                case lists:member(RoleId, IdList) of
                    true ->
                        lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, add_destiny_point_by_weekly_card, [Times]),
                        Acc;
                    _ ->
                        case lists:keyfind(RoleId, 2, ActDataList) of
                            false ->
                                Data = {1, 160 + 80 * (Times - 1), Now, []},
                                [[RoleId, ActType, 1, util:term_to_string(Data)] | Acc];
                            {SubType, RoleId, DataList} ->
                                {Turn , OldPoint, Time, GetGrades} =  util:bitstring_to_term(DataList),
                                Data = {Turn , OldPoint + 160 + 80 * (Times - 1), Time, GetGrades},
                                [[RoleId, ActType, SubType, util:term_to_string(Data)] | Acc];
                            Err ->
                                ?INFO("Err = ~p~n",[Err]), Acc
                        end
                end end,
            List = lists:foldl(F2, [], CountRoleIdList),
            SqlList = usql:replace(custom_act_data, [player_id, type, subtype, data_list], List),
            SqlList =/= [] andalso db:execute(SqlList),
            ok;
        _ -> skip
    end.

add_destiny_point_by_weekly_card(Ps, Times) ->
    AddPoint = 160 + 80 * (Times - 1),
    gm_add_turntable_point(Ps, AddPoint).