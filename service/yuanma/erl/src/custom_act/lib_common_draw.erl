%% ---------------------------------------------------------------------------
%% @doc lib_common_draw

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/6/4
%% @deprecated  通用抽奖活动（扭蛋）
%%           【抽奖记录通用协议】
%%           【领取特殊奖励走通用协议】
%%           活动：
%%              1. 伙伴抽奖： 每次抽奖获取幸运值，当幸运值达到
%%           最大之后，下次抽奖必定大奖。（放回性质大奖， 大奖后幸运值清空）
%%              2.  xxx
%% ---------------------------------------------------------------------------
-module(lib_common_draw).

%% API
-export([
    send_info/3,        %% 获取活动信息
    do_draw/6,          %% 抽奖
    receive_reward/4,   %% 领取奖励（走通用协议
    act_end/2           %% 活动结束
    ,get_draw_info/1
    ,check_draw/2
    ,load_all_reward/4
    ,calc_weight_value/3
]).

-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("custom_act.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("predefine.hrl").

-define(NOT_AUTO,    0).
-define(AUTO_BUY,    1).

%% 发送活动信息
send_info(Ps, Type = ?CUSTOM_ACT_TYPE_COMMON_DRAW, SubType) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Ps,
    CustomActCfg = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    ?PRINT(" CustomActCfg ~p ~n", [CustomActCfg]),
    case get_draw_info(CustomActCfg) of
        {MaxLuck, PerLuck, NeedLv, OneCost, TenCost, _ConsumeType} when Lv >= NeedLv ->
            %% TotalTimes 累计抽奖总次数
            %% LuckValue 当前幸运值
            %% GrandStatus 累计奖励领取状态
            %% NiceList 大奖抽取记录
            #custom_common_draw{
                total_times = TotalTimes, luck_value = LuckValue,
                grand_status = GrandStatus, nice_list = NiceList
            } = get_player_act_info(Ps, Type, SubType),
            {DrawRewardTmp, GradeRewardTmp, ExchangeRewardTmp} = load_all_reward(Type, SubType, GrandStatus, NiceList),
            DrawReward = [{GradeId, IsNice, IsGet, util:term_to_string(Reward)}||{GradeId, IsNice, IsGet, Reward, _}<-DrawRewardTmp],
            GradeReward = [{GradeId, IsGet, NeedNum, util:term_to_string(Reward)}||{GradeId, IsGet, NeedNum, Reward}<-GradeRewardTmp],
            ExchangeReward = [{GradeId, NeedPoint, util:term_to_string(Reward)}||{GradeId, NeedPoint, Reward}<-ExchangeRewardTmp],
%%            ?MYLOG("zh_draw", "33245 ~p ~n", [[Type, SubType, MaxLuck, LuckValue, PerLuck, TotalTimes, OneCost,
%%                TenCost, DrawReward, GradeReward, ExchangeReward]]),
            {ok, BinData} = pt_332:write(33245, [Type, SubType, MaxLuck, LuckValue, PerLuck, TotalTimes, util:term_to_string(OneCost),
                util:term_to_string(TenCost), DrawReward, GradeReward, ExchangeReward]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ -> skip
    end.

%% 抽奖
%% @params Times 抽奖次数  1/10
%% @params AutoBuy 是否自动购买
do_draw(Ps, Type = ?CUSTOM_ACT_TYPE_COMMON_DRAW, SubType, Times, AutoBuy, LunceField)
    when Times == 1 orelse Times == 10 ->
    #player_status{id = RoleId, figure = #figure{lv = Lv, name = RoleName}} = Ps,
    CustomActCfg = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    case get_draw_info(CustomActCfg) of
        {MaxLuck, PerLuck, NeedLv, OneCost, TenCost, ConsumeType} when Lv >= NeedLv ->
            case cal_real_cost(Ps, OneCost, TenCost, Times, AutoBuy) of
                {true, Cost} ->
                    case lib_goods_api:cost_object_list_with_check(Ps, Cost, ConsumeType, "") of
                        {true, NewPsTmp} ->
                            #custom_common_draw{
                                total_times = TotalTimes, luck_value = LuckValue,
                                grand_status = GrandStatus, nice_list = NiceList
                            } = ActData = get_player_act_info(NewPsTmp, Type, SubType),
                            {DrawReward, _, _} = load_all_reward(Type, SubType, GrandStatus, NiceList),
                            %% 是否放回奖励
                            IsBack = check_draw(CustomActCfg, is_back),

                            %% 抽中大奖后是否清空积分/幸运值 （若玩家自身有最大幸运值限制则抽中大奖后会清空）
                            IsClear = MaxLuck =/= 0,

                            {GradeRewards, NewNiceList, NewLuckValue} =
                                do_draw_core(IsBack, IsClear, NiceList, LuckValue, PerLuck, MaxLuck, DrawReward, TotalTimes, Times, []),
                            CurrentTimes = TotalTimes + Times,
                            NewActData = ActData#custom_common_draw{total_times = CurrentTimes, luck_value = NewLuckValue, nice_list = NewNiceList},
                            %% 保存新的抽奖状态
                            ActPs = save_player_act_info(NewPsTmp, Type, SubType, NewActData),
                            %% 获取传闻ID
                            {tv_info, {Mod, TvId}} = get_tv_info(CustomActCfg),
                            WrapperName = lib_player:get_wrap_role_name(Ps),
                            %% 奖励整合一次发放+记录、传闻处理
                            F = fun({GradeId, [{_,RealGtypeId,_}|_] = Reward, Condition}, {GrandGradeId, GrandReward, GrandProtoInfo}) ->
                                IsTv = check_reward(Condition, is_tv),
                                IsRare = check_reward(Condition, is_rare),
                                IsNice = check_reward(Condition, is_nice),
                                ?IF(IsTv, lib_chat:send_TV({all}, Mod, TvId, [WrapperName, RoleId, RealGtypeId, Type, SubType]), skip),
                                %%添加全服记录
                                ?IF(IsRare , mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, WrapperName, Reward}), skip),
                                {[GradeId|GrandGradeId], [Reward|GrandReward], [{GradeId, util:term_to_string(Reward), ?IF(IsNice,1,0)}|GrandProtoInfo]}
                                end,
                            {GradeGradeIds, GetRewardsTmp, ProtoInfo} = lists:foldl(F, {[], [], []}, GradeRewards),
                            GetRewards = lists:flatten(GetRewardsTmp),
                            %% 个人记录
                            mod_custom_act_record:cast({save_role_log_and_notice, RoleId, Type, SubType, RoleName, GetRewards}),
                            Remark = lists:concat(["SubType:", SubType, "GradeIds:", ulists:list_to_string(GradeGradeIds, ",")]),
                            Produce = #produce{type = ConsumeType, subtype = Type, remark = Remark, reward = GetRewards, show_tips = ?SHOW_TIPS_0},
                            LastPlayer = lib_goods_api:send_reward(ActPs, Produce),
                            lib_log_api:log_custom_act_reward(LastPlayer#player_status.id, Type, SubType, 0, GetRewards),
                            {ok, BinData} = pt_332:write(33246, [?SUCCESS, Type, SubType, AutoBuy, LunceField, NewLuckValue, CurrentTimes, ProtoInfo]),
                            lib_server_send:send_to_uid(RoleId, BinData),
                            {ok, LastPlayer};
                        {false, Res, ErrPs} ->
                            {ok, BinData} = pt_332:write(33246, [Res, Type, SubType, AutoBuy, LunceField, 0, 0, []]),
                            lib_server_send:send_to_uid(RoleId, BinData),
                            {ok, ErrPs}
                    end;
                {false, Errcode} ->
                    {ok, BinData} = pt_332:write(33246, [Errcode, Type, SubType, 0, 0, 0, 0, []]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    {ok, Ps}
            end;
        _ -> {ok, Ps}
     end;
do_draw(_Ps, _Type, _SubType, _Times, _AutoBuy, _LunceField) ->
    skip.

%% 领取奖励，走通用的领取奖励协议
%% 使用积分兑换奖励 / 根据抽奖次数领取所得奖励
receive_reward(Ps, Type, SubType, GradeId) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Ps,
    CustomActCfg = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    case get_draw_info(CustomActCfg) of
        {_, _, NeedLv, _, _, ConsumeType} when Lv >= NeedLv ->
            #custom_act_reward_cfg{
                reward = Reward, condition = Condition
            } = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
            ActData = get_player_act_info(Ps, Type, SubType),
            case do_receive_reward(ActData, GradeId, Condition) of
                {true, NewActData} ->
                    Errcode = ?SUCCESS,
                    ActPs = save_player_act_info(Ps, Type, SubType, NewActData),
                    Remark = lists:concat(["SubType:", SubType, "GradeId:", GradeId]),
                    Produce = #produce{type = ConsumeType, subtype = Type, remark = Remark, reward = Reward, show_tips = ?SHOW_TIPS_0},
                    LastPs = lib_goods_api:send_reward(ActPs, Produce),
                    lib_log_api:log_custom_act_reward(LastPs#player_status.id, Type, SubType, GradeId, Reward);
                {false, Errcode} ->
                    LastPs = Ps
            end,
            {ok, BinData} = pt_331:write(33105, [Errcode, Type, SubType, GradeId]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, LastPs};
        _ ->
            skip
    end.

%% 活动结束，清空数据
act_end(Type, SubType) ->
    db:execute(io_lib:format(?SQL_DELETE_CUSTOM_ACT_DATA_1, [Type, SubType])).

%% 积分兑换奖励
do_receive_reward(ActData, _GradeId, [{exchange, NeedValue}]) ->
    #custom_common_draw{ luck_value = LuckValue } = ActData,
    case LuckValue >= NeedValue of
        true -> {true, ActData#custom_common_draw{ luck_value = LuckValue - NeedValue }} ;
        false -> {false, ?ERRCODE(err331_luck_no_enough)}
    end;
%% 根据抽取次数兑换奖励
do_receive_reward(ActData, GradeId, [{total, NeedTimes}]) ->
    #custom_common_draw{ total_times = TotalTimes, grand_status = GrandStatus } = ActData,
    IsGet = lists:member(GradeId, GrandStatus),
    IsEnough = TotalTimes >= NeedTimes,
    if
        not IsGet -> {false, ?ERRCODE(err331_had_receive)};
        not IsEnough -> {false, ?ERRCODE(err331_no_enough)};
        true ->
            NewActData = ActData#custom_common_draw{grand_status = [GradeId|GrandStatus]},
            {true, NewActData}
    end;
do_receive_reward(_, _, _) ->
    {false, ?FAIL}.


%% 计算抽奖消耗
cal_real_cost(Ps, OneCost, _TenCost, 1, ?NOT_AUTO) ->
    [{NeedTypes, NeedGoodsId, SingleNum}|_] = OneCost,
    [HavingNum] = lib_goods_api:get_goods_num(Ps, [NeedGoodsId]),
    CostNum = SingleNum,
    NeedCost = [{NeedTypes, NeedGoodsId, CostNum}],
    if
        HavingNum >= CostNum -> {true, NeedCost};
        true ->
            {false, ?GOODS_NOT_ENOUGH}
    end;
cal_real_cost(Ps, _OneCost, TenCost, 10, ?NOT_AUTO) ->
    [{NeedTypes, NeedGoodsId, TenNum}|_] = TenCost,
    [HavingNum] = lib_goods_api:get_goods_num(Ps, [NeedGoodsId]),
    NeedCost = [{NeedTypes, NeedGoodsId, TenNum}],
    if
        HavingNum >= TenNum -> {true, NeedCost};
        true ->
            {false, ?GOODS_NOT_ENOUGH}
    end;
cal_real_cost(_Ps, OneCost, _TenCost, 1, ?AUTO_BUY) ->
    [{NeedTypes, NeedGoodsId, SingleNum}|_] = OneCost,
    NeedCost = [{NeedTypes, NeedGoodsId, SingleNum}],
    case lib_goods_api:calc_auto_buy_list(NeedCost) of
        {ok, NewCost} -> {true, NewCost};
        _A -> {false, ?GOODS_NOT_ENOUGH}
    end;
cal_real_cost(_Ps, _OneCost, TenCost, 10, ?AUTO_BUY) ->
    [{NeedTypes, NeedGoodsId, TenNum}|_] = TenCost,
    NeedCost = [{NeedTypes, NeedGoodsId, TenNum}],
    case lib_goods_api:calc_auto_buy_list(NeedCost) of
        {ok, NewCost} -> {true, NewCost};
        _A -> {false, ?GOODS_NOT_ENOUGH}
    end.

%% 抽奖核心逻辑
%% @params IsBack 是否放回奖励
%% @params IsClear 抽到大奖后是否清空幸运值
%% @params NiceList 以获取的大奖列表
%% @params LuckValue 当前幸运值
%% @params PerLuck 每次抽奖提供幸运值
%% @params MaxLuck 最大幸运值（当该值不等于0时，本次抽奖必定大奖)
%% @params DrawRewardPool 奖池 [{GradeId, IsNice, IsGet, Reward, Condition}|_]
%% @params CurrentTimes 当前抽奖次数
%% @params RemainTimes 剩余次数
%% @params GrandReward 抽到的奖励
%% @return {抽到的奖励({GradeId, Reward, Condition}), 以获取的大奖列表, 新的幸运值}
do_draw_core(_IsBack, _IsClear, NiceList, LuckValue, _PerLuck, _MaxLuck, _DrawRewardPool, _CurrentTimes, 0, GrandRewards) ->
    {GrandRewards, NiceList, LuckValue};
do_draw_core(IsBack, IsClear, NiceList, LuckValue, PerLuck, MaxLuck, DrawRewardPool, OldTimes, RemainTimes, GrandRewards) ->
    CurrentLuck = LuckValue + PerLuck,
    NewDrawRewardPool =
        if
            not IsBack ->
                [Item||{GradeId, _, _, _, _} = Item <-DrawRewardPool, not lists:member(GradeId, NiceList)];
            true ->
                DrawRewardPool
        end,
    %% 是否必中大奖
    IsMustNice = MaxLuck =/= 0 andalso CurrentLuck >= MaxLuck,
    CurrentTimes = OldTimes + 1,
%%    NewDrawRewardPool =
%%        case IsMustNice of
%%            true ->
%%                lists:filter(fun({_, IsNice, _, _, _}) -> IsNice == 1 end, NewDrawRewardPoolTmp);
%%            _ -> NewDrawRewardPoolTmp
%%        end,
%%    ?PRINT(IsMustNice, "NewDrawRewardPool ~p ~n", [NewDrawRewardPool]),
%%    WeightList =
%%        [begin
%%             {weight, WeightCon} = lists:keyfind(weight, 1, Condition),
%%             WeightVal = calc_weight_value(WeightCon, CurrentTimes, CurrentLuck),
%%             {WeightVal, {GradeId, IsNice, Reward, Condition}}
%%         end||{GradeId, IsNice, _, Reward, Condition} <- NewDrawRewardPool],
    F = fun({GradeId, IsNice, _, Reward, Condition}, GrandWeightList) ->
        {weight, WeightCon} = lists:keyfind(weight, 1, Condition),
        WeightVal = calc_weight_value(WeightCon, CurrentTimes, CurrentLuck),
        Item = {WeightVal, {GradeId, IsNice, Reward, Condition}},
        case IsMustNice of
            true -> ?IF(IsNice == 1, [Item|GrandWeightList], GrandWeightList);
            _ -> [Item|GrandWeightList]
        end
        end,
    WeightList = lists:foldl(F, [], NewDrawRewardPool),
    {GetGradeId, IsNice, GetReward, Condition} = urand:rand_with_weight(WeightList),
    NewNiceList = ?IF(IsNice == 1 andalso IsBack, [GetGradeId|NiceList], NiceList),
    LastLuckVal = ?IF(IsNice == 1 andalso IsClear, 0, CurrentLuck),
    NewGrandRewards = [{GetGradeId, GetReward, Condition}|GrandRewards],
    do_draw_core(IsBack, IsClear, NewNiceList, LastLuckVal, PerLuck, MaxLuck, DrawRewardPool, CurrentTimes, RemainTimes - 1, NewGrandRewards).

%% 计算权重值（规定权重值，根据幸运值计算权重值，根据抽奖区间选择权重值）
calc_weight_value(Weight, _CurrentTimes, _CurrentLuck) when is_integer(Weight) ->
    Weight;
calc_weight_value({DownTimes, UpTimes, DurationVal, NormalVal}, CurrentTimes, _CurrentLuck) ->
    if
        DownTimes =< CurrentTimes andalso CurrentTimes =< UpTimes -> DurationVal;
        true -> NormalVal
    end;
calc_weight_value({{DownLuck, UpLuck, PerVal}, BaseVal}, _CurrentTimes, CurrentLuck) ->
    RealTimes = ?IF(CurrentLuck >= UpLuck, UpLuck,
        ?IF(CurrentLuck >= DownLuck, CurrentLuck, 0)),
    BaseVal + RealTimes * PerVal;
calc_weight_value(_WeightCon, _CurrentTimes, _CurrentLuck) -> 0.


%% 获取所有Reward
%% @params GrandStatus 已领取的累计奖励ID [GradeId|_]
%% @params NiceList 已经抽中的大奖GradeId [GradeId|_] （该字段大奖不放回才有用）
%% @return {DrawReward, GradeReward, ExchangeReward}
load_all_reward(Type, SubType, GrandStatus, NiceList) ->
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, {DrawReward1, GrandReward1, ExchangeReward}) ->
        #custom_act_reward_cfg{
            reward = Reward, condition = Condition
        } = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        %% 奖励配置字段：weight(抽奖奖励), total（累计次数奖励）, exchange（兑换奖励） 必须三选一
        case lists:keymember(weight, 1, Condition) of
            true -> %% 抽奖奖励
                IsGet = ?IF(lists:member(GradeId, NiceList), 1, 0),
                %% 是否大奖
%%                {is_nice, IsNice} = ulists:keyfind(is_nice, 1, Condition, {is_nice, 0}),
                IsNice = ?IF(check_reward(Condition, is_nice), 1, 0),
                {[{GradeId, IsNice, IsGet, Reward, Condition}|DrawReward1], GrandReward1, ExchangeReward};
            _ ->
                case lists:keyfind(total, 1, Condition) of
                    {total, Total} -> %% 累计次数奖励
                        IsGet = ?IF(lists:member(GradeId, GrandStatus), 1, 0),
                        {DrawReward1, [{GradeId, IsGet, Total, Reward}|GrandReward1], ExchangeReward};
                    _ ->
                        case lists:keyfind(exchange, 1, Condition) of
                            {exchange, NeedVal} -> %% 兑换奖励
                                {DrawReward1, GrandReward1, [{GradeId, NeedVal, Reward}|ExchangeReward]};
                            _ -> %% 容错
                                {DrawReward1, GrandReward1, ExchangeReward}
                        end
                end
        end
        end,
    lists:foldl(F, {[], [], []}, GradeIds).


%% 获取活动条件信息
%% @return {最大幸运值(若该值是0，则是用幸运值兑换奖励类型), 所需等级, 抽奖消耗}   / 达到最大幸运值必中大奖
get_draw_info(#custom_act_cfg{condition = Condition}) ->
    case lib_custom_act_check:check_act_condtion([max_luck, per_luck, role_lv, one_cost, ten_cost, consume_type], Condition) of
        [MaxLuck, PerLuck, RoleLv, OneCost, TenCost, ConsumeType] -> {MaxLuck, PerLuck, RoleLv, OneCost, TenCost, ConsumeType};
        _ -> false
    end;
get_draw_info(_CustomActCfg) ->
    ?ERR("Common Draw Config Error ~p ~n", [_CustomActCfg]), false.

%% 获取抽奖传闻信息
get_tv_info(#custom_act_cfg{condition = Condition}) ->
    ulists:keyfind(tv_info, 1, Condition, {tv_info, {?MOD_AC_CUSTOM, 1}}).

%% 是否放回奖励
check_draw(#custom_act_cfg{condition = Condition}, is_back) ->
    case lists:keyfind(is_back, 1, Condition) of
        false -> false;
        IsBack -> IsBack == 1
    end;
check_draw(_, _) -> false.

%% 检查奖励条件
%% @param RewardCondition [{atom, Val}|_]
%% @param Atom is_tv(是否传闻) / is_rare（是否需要记录日志） / is_nice（是否大奖）
check_reward(RewardCondition, Atom) when is_atom(Atom) ->
    case lists:keyfind(Atom, 1, RewardCondition) of
        false -> false;
        {Atom, IsBack} -> IsBack == 1
    end;
check_reward(_, _) ->
    false.

%% 获取玩家活动数据
get_player_act_info(Ps, Type, SubType) ->
    case lib_custom_act:act_data(Ps, Type, SubType) of
        #custom_act_data{data = []} -> #custom_common_draw{};
        #custom_act_data{data = Data} -> Data;
        _ -> #custom_common_draw{}
    end.

%% 保存活动数据
%% @return NewPs
save_player_act_info(Ps, Type, SubType, Data) when is_record(Data, custom_common_draw) ->
    ActData = #custom_act_data{
        id = {Type, SubType},
        type = Type,
        subtype = SubType,
        data = Data
    },
    save_player_act_info(Ps, ActData);
save_player_act_info(Ps, _Type, _SubType, _Data) ->
    ?ERR("error save_player_act_info Data ~p ~n", [_Data]),
    Ps.
save_player_act_info(Ps, ActData) when is_record(ActData, custom_act_data) ->
    lib_custom_act:save_act_data_to_player(Ps, ActData);
save_player_act_info(Ps, _ActData) ->
    ?ERR("error save_player_act_info Data ~p ~n", [_ActData]),
    Ps.



