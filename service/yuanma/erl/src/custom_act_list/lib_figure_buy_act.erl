%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%             外形直购活动
%%% @end
%%% Created : 19. 8月 2022 10:12
%%%-------------------------------------------------------------------
-module(lib_figure_buy_act).

-include("server.hrl").
-include("common.hrl").
-include("custom_act.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("goods.hrl").
-include("rec_recharge.hrl").
-include("figure.hrl").
-include("def_recharge.hrl").

%% API
-export([
    send_reward_status/2
    , handle_event/2
    , buy_other_grade/4
]).

%%% 发送每日充值购买情况
send_reward_status(Player, ActInfo) ->
    #act_info{key = {ActType, SubType}, wlv = Wlv} = ActInfo,
    GradeIds = data_custom_act:get_reward_grade_list(ActType, SubType),
    %% 获取该子类型活动对应的商品礼包Id
    case lib_custom_act_util:keyfind_act_condition(ActType, SubType, one_package) of
        {_, PackageRechargeId, _} -> ok;
%%            AllGradeIds = [PackageRechargeId|GradeIds];
        _ -> PackageRechargeId = 0

    end,
    #custom_act_figure_buy{bought = BuySituation, other_bought = OtherL} = get_buy_data(Player, ActType, SubType),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, GradeId) of
            #custom_act_reward_cfg{name = Name, desc = Desc, condition = Condition, format = Format, reward = Reward} = RewardCfg ->
                RoleLv = Player#player_status.figure#figure.lv,
                case lib_custom_act_check:check_reward_in_wlv(ActType, SubType, [{wlv, Wlv}, {role_lv, RoleLv}, {open_day}], RewardCfg) of
                    true ->
                        case lists:keyfind(recharge_id, 1, Condition) of
                            {recharge_id, ProductId} ->
                                {recharge_id, ProductId} = lists:keyfind(recharge_id, 1, Condition),
                                %% 根据购买情况计算各商品的状态
                                {Status, ReceiveTimes} =
                                    case lists:member(ProductId, BuySituation) orelse lists:member(PackageRechargeId, BuySituation) of
                                        true -> {2, 1};
                                        false -> {0, 0}
                                    end;
                            _ ->
                                {_, LimitBuy} = lists:keyfind(limit_buy, 1, Condition),
                                {_, BuyTimes} = ulists:keyfind(GradeId, 1, OtherL, {GradeId, 0}),
                                Status = ?IF(BuyTimes < LimitBuy, 0, 2),
                                ReceiveTimes = BuyTimes
                        end,
                        ConditionStr =
                            case lists:keyfind(fight, 1, Condition) of
                                {fight, AttrS} ->
                                    Prower = lib_player:calc_expact_power(Player#player_status.original_attr, 0, AttrS),
                                    Condition2 = lists:keystore(fight, 1, Condition, {fight, Prower}),
                                    util:term_to_string(Condition2);
                                _ ->
                                    util:term_to_string(Condition)
                            end,
%%                        ConditionStr = util:term_to_string(Condition),
                        RewardStr = util:term_to_string(Reward),
                        [{GradeId, Format, Status, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | Acc];
                    _ -> Acc
                end;
            _ -> %% 特殊处理打包商品的信息
                case GradeId == PackageRechargeId of
                    true ->
                        {Status, ReceiveTimes} = ?IF(lists:member(GradeId, BuySituation), {2, 1}, {0, 0}),
                        #base_recharge_product{ product_name = ProductName, money = Money} = data_recharge:get_product(PackageRechargeId),
                        ConditionStr = util:term_to_string([{one_price, Money}]),
                        [{GradeId, 0, Status, ReceiveTimes, ProductName, ProductName, ConditionStr, util:term_to_string([])} | Acc];
                    false -> Acc
                end
        end
        end,
    SendList = lists:foldl(F, [], GradeIds),
    {ok, BinData} = pt_331:write(33104, [ActType, SubType, SendList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData).

%% 获取商品的购买情况
get_buy_data(Ps, ActType, SubType) ->
    case lib_custom_act:act_data(Ps, ActType, SubType) of
        #custom_act_data{data = Data} ->
            case Data of
                #custom_act_figure_buy{utime = Utime} ->
                    case lib_custom_act_util:get_custom_act_open_info(ActType, SubType) of
                        #act_info{stime = Stime, etime = Etime} when Utime >= Stime, Utime =< Etime ->
                            case lib_custom_act_util:in_same_clear_day(ActType, SubType, Etime, Utime) of
                                true -> Data;
                                false -> #custom_act_figure_buy{}
                            end;
                        _ -> #custom_act_figure_buy{}
                    end;
                _ -> #custom_act_figure_buy{}
            end;
        _ -> #custom_act_figure_buy{}
    end.

%% 使用绑玉勾玉购买礼包
buy_other_grade(Ps, Type, SubType, GradeId) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            FigureBuy = #custom_act_figure_buy{other_bought = OtherL} = get_buy_data(Ps, Type, SubType),
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                #custom_act_reward_cfg{condition = Condition, reward = Reward, name = RName} ->
                    {_, LimitBuy} = lists:keyfind(limit_buy, 1, Condition),
                    {_, BuyTimes} = ulists:keyfind(GradeId, 1, OtherL, {GradeId, 0}),
                    case BuyTimes < LimitBuy of
                        true ->
                            case lists:keyfind(cost, 1, Condition) of
                                {cost, Cost} ->
                                    case lib_goods_api:cost_object_list_with_check(Ps, Cost, custom_act_figure_buy, "") of
                                        {true, CostPs} ->
                                            NewOtherL = lists:keystore(GradeId, 1, OtherL, {GradeId, BuyTimes + 1}),
                                            NewData = FigureBuy#custom_act_figure_buy{other_bought = NewOtherL, utime = utime:unixtime()},
                                            NewActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = NewData},
                                            #player_status{ id = RoleId, figure = #figure{name = RoleName}} = Ps,
                                            lib_custom_act:db_save_custom_act_data(RoleId, NewActData),
                                            NewTemPS = lib_custom_act:save_act_data_to_player(CostPs, NewActData),
                                            SendPs = lib_goods_api:send_reward(NewTemPS, Reward, custom_act_figure_buy, 0),
                                            {ok, BinData} = pt_332:write(33265, [Type, SubType, GradeId, ?SUCCESS]),
                                            lib_server_send:send_to_sid(SendPs#player_status.sid, BinData),

                                            %% 特殊处理，补发33257协议
                                            {ok, BinData1} = pt_332:write(33257, [Type, SubType, Reward]),
                                            lib_server_send:send_to_uid(RoleId, BinData1),

                                            %% 传闻
                                            case lists:keyfind(tv, 1, Condition) of
                                                {tv, {ModuleId, TvId}} ->
                                                    lib_chat:send_TV({all}, ModuleId, TvId, [RoleName, RoleId, RName, Type, SubType]);
                                                _ -> skip
                                            end,
                                            lib_log_api:log_custom_act_reward(SendPs, Type, SubType, GradeId, Reward),
                                            {ok, SendPs};
                                        {false, Err, _} -> {false, Err}
                                    end;
                                _ -> {false, ?FAIL}
                            end;
                        _ -> {false, ?ERRCODE(error_count_limit)}
                    end;
                _ ->  {false, ?FAIL}
            end;
        _ ->
            {false, ?ERRCODE(err512_act_close)}
    end.

%% 充值后回调的函数
handle_event(PlayerStatus, #event_callback{ type_id = ?EVENT_RECHARGE, data = Data }) ->
    #callback_recharge_data{
        recharge_product = #base_recharge_product{product_id = ProductId, product_type = ProductType, product_subtype = _ProductSubType}
    } = Data,
    case ProductType == ?PRODUCT_TYPE_DIRECT_GIFT of
        true ->
            NewPlayerStatus = do_handle_event(PlayerStatus, ProductId),
            {ok, NewPlayerStatus};
        false ->
            {ok, PlayerStatus}
    end;
handle_event(PlayerStatus, _) ->
    {ok, PlayerStatus}.

do_handle_event(Ps, ProductId) ->
    ActType = ?CUSTOM_ACT_TYPE_FIGURE_BUY,
    SubTypeL = lib_custom_act_api:get_open_subtype_ids(ActType),
    Fun = fun(SubType, TemPS) ->
        %% 获取该子类型活动对应的商品礼包Id
        case lib_custom_act_util:keyfind_act_condition(ActType, SubType, one_package) of
            {one_package, PackageRechargeId, PackageGiftIdL} ->
                Flag = ProductId == PackageRechargeId,
                case lists:member(ProductId, PackageGiftIdL) orelse Flag of
                    true ->
                        FigureBuy = #custom_act_figure_buy{bought = BoughtL} = get_buy_data(TemPS, ActType, SubType),
                        Check = lists:member(PackageRechargeId, BoughtL),
                        case lists:member(ProductId, BoughtL) orelse Check of
                            true -> TemPS;
                            false ->
                                NewBoughtL = [ProductId|BoughtL],
                                NewData = FigureBuy#custom_act_figure_buy{bought = NewBoughtL, utime = utime:unixtime()},
                                NewActData = #custom_act_data{id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData},
                                #player_status{ id = RoleId} = TemPS,
                                lib_custom_act:db_save_custom_act_data(RoleId, NewActData),
                                NewTemPS = lib_custom_act:save_act_data_to_player(TemPS, NewActData),
                                lib_custom_act:reward_status(NewTemPS, ActType, SubType),
                                %% 奖励与传闻相关处理(打包购买时会排除已购买过的礼包，不发重复奖励)
                                RewardProductL = ?IF( Flag, lists:subtract(PackageGiftIdL, BoughtL), [ProductId]),
                                send_reward_to_player(NewTemPS, ActType, SubType, RewardProductL, Flag, PackageRechargeId)
                        end;
                    false -> TemPS
                end;
            _ ->
                FigureBuy = #custom_act_figure_buy{bought = BoughtL} = get_buy_data(TemPS, ActType, SubType),
                case check_product_id(ActType, SubType, ProductId) andalso (not lists:member(ProductId, BoughtL)) of
                    true ->
                        NewBoughtL = [ProductId|BoughtL],
                        NewData = FigureBuy#custom_act_figure_buy{bought = NewBoughtL, utime = utime:unixtime()},
                        NewActData = #custom_act_data{id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData},
                        #player_status{ id = RoleId} = TemPS,
                        lib_custom_act:db_save_custom_act_data(RoleId, NewActData),
                        NewTemPS = lib_custom_act:save_act_data_to_player(TemPS, NewActData),
                        lib_custom_act:reward_status(NewTemPS, ActType, SubType),
                        %% 奖励与传闻相关处理(打包购买时会排除已购买过的礼包，不发重复奖励)
                        RewardProductL = [ProductId],
                        send_reward_to_player(NewTemPS, ActType, SubType, RewardProductL, false, 0);
                    _ ->
                        TemPS

                end
        end end,
    lists:foldl(Fun, Ps, SubTypeL).

check_product_id(ActType, SubType, ProductId) ->
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(ActType, SubType),
    check_product_id(ActType, SubType, GradeIds, ProductId).

check_product_id(_ActType, _SubType, [], _ProductId) -> false;
check_product_id(ActType, SubType, [GradeId | Next], ProductId) ->
    #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, GradeId),
    {_, CheckId} = ulists:keyfind(recharge_id, 1, Condition, {recharge_id, 0}),
    case CheckId == ProductId of
        true -> true;
        _ -> check_product_id(ActType, SubType, Next, ProductId)
    end.


%% 发放对应商品的实际奖励到玩家背包
send_reward_to_player(Ps, ActType, SubType, ProductIdList, IsOnePackage, OnePackageProId) ->
    #player_status{ id = RoleId, figure = #figure{name = RoleName} } = Ps,
    ActInfo = lib_custom_act_util:get_custom_act_open_info(ActType, SubType),
    Fun = fun(ProductId, AwardList) ->
        RewardCfgList = get_reward_cfg(ActType, SubType, ProductId),
        case RewardCfgList of
            [] -> AwardList;
            [RewardCfg|_] ->
                AwardList0 = lib_custom_act_util:count_act_reward(Ps, ActInfo, RewardCfg),
                AwardList0 ++ AwardList
        end
          end,
    RewardList = lists:foldl(Fun, [], ProductIdList),
    ProductType = get_product_type(),
    Product = #produce{type = ProductType, subtype = SubType, reward = RewardList, show_tips = ?SHOW_TIPS_0},
    NewPs = lib_goods_api:send_reward(Ps, Product),
    %% 特殊处理，补发33257协议
    {ok, BinData} = pt_332:write(33257, [ActType, SubType, RewardList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    %% 日志与传闻处理
    case IsOnePackage of
        true ->
            ProductId2 = OnePackageProId,
            #custom_act_cfg{condition = ActConditionL, name = CfgName} = lib_custom_act_util:get_act_cfg_info(ActType, SubType);
        false ->
            [ProductId2|_] = ProductIdList,
            [#custom_act_reward_cfg{condition = ActConditionL, name = CfgName}|_] = get_reward_cfg(ActType, SubType, ProductId2)
    end,
    %% 传闻
    case lists:keyfind(tv, 1, ActConditionL) of
        {tv, {ModuleId, TvId}} ->
            lib_chat:send_TV({all}, ModuleId, TvId, [RoleName, RoleId, CfgName, ActType, SubType]);
        _ -> skip
    end,
    %% 日志
    GradeId = get_reward_grade_id(ActType, SubType, ProductId2, OnePackageProId),
    lib_log_api:log_custom_act_reward(NewPs, ActType, SubType, GradeId, RewardList),
    NewPs.

get_product_type() ->
    custom_act_figure_buy.

%% 根据商品Id获取奖励配置信息
get_reward_cfg(ActType, SubType, ProductId) ->
    case lib_custom_act_api:is_open_act(ActType, SubType) of
        true ->
            AllGradeList = data_custom_act:get_reward_grade_list(ActType, SubType),
            Fun = fun(GradeId, RewardCfgL) ->
                #custom_act_reward_cfg{condition = RewardCondition} = RewardCfg = data_custom_act:get_reward_info(ActType, SubType, GradeId),
                {_, CfgProductId} = lists:keyfind(recharge_id, 1, RewardCondition),
                case CfgProductId == ProductId of
                    true -> [RewardCfg|RewardCfgL];
                    _ -> RewardCfgL
                end
                  end,
            lists:foldl(Fun, [], AllGradeList);
        _ -> []
    end.

%% 根据商品Id获取奖励等级Id
get_reward_grade_id(ActType, SubType, ProductId, Defaults)->
    AllGradeList = data_custom_act:get_reward_grade_list(ActType, SubType),
    Fun = fun(GradeId, Def) ->
        #custom_act_reward_cfg{ condition = RewardCondition } = data_custom_act:get_reward_info(ActType, SubType, GradeId),
        {_, CfgProductId} = lists:keyfind(recharge_id, 1, RewardCondition),
        case CfgProductId == ProductId of
            true -> GradeId;
            _ -> Def
        end
          end,
    lists:foldl(Fun, Defaults, AllGradeList).
