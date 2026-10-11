%%---------------------------------------------------------------------------
%% @doc:        lib_custom_daily_direct_buy
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-2月-10. 14:48
%% @deprecated: 每日直购礼包
%%---------------------------------------------------------------------------
-module(lib_custom_daily_direct_buy).

%% API
-export([
    handle_event/2,
    send_reward_status/2,
    clear_act_data/2,
    daily_clear/3
]).

-include("common.hrl").
-include("server.hrl").
-include("rec_event.hrl").
-include("rec_recharge.hrl").
-include("def_event.hrl").
-include("def_recharge.hrl").
-include("custom_act.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").

%% ====================================
%% external_function
%% ====================================
%% 重置后回调的函数
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

%%% 发送每日充值购买情况
send_reward_status(Player, ActInfo) ->
    #act_info{key = {ActType, SubType}, wlv = Wlv} = ActInfo,
    %% 获取该子类型活动对应的商品礼包Id
    {_, PackageRechargeId, _} = lib_custom_act_util:keyfind_act_condition(ActType, SubType, one_package),
    GradeIds = data_custom_act:get_reward_grade_list(ActType, SubType),
    BuySituation = get_buy_data(Player, ActType, SubType),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, GradeId) of
            #custom_act_reward_cfg{ name = Name, desc = Desc, condition = Condition, format = Format, reward = Reward } = RewardCfg ->
                RoleLv = Player#player_status.figure#figure.lv,
                case lib_custom_act_check:check_reward_in_wlv(ActType, SubType, [{wlv, Wlv}, {role_lv, RoleLv}, {open_day}], RewardCfg) of
                    true ->
                        {recharge_id, ProductId} = lists:keyfind(recharge_id, 1, Condition),
                        %% 根据购买情况计算各商品的状态
                        {Status, ReceiveTimes} =
                            case lists:member(ProductId, BuySituation) orelse lists:member(PackageRechargeId, BuySituation) of
                                true -> {2, 1};
                                false -> {0, 0}
                            end,
                        ConditionStr = util:term_to_string(Condition),
                        RewardStr = util:term_to_string(Reward),
                        [{GradeId, Format, Status, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | Acc];
                    _ -> Acc
                end;
            _ -> %% 特殊处理打包商品的信息
                case GradeId == PackageRechargeId of
                    true ->
                        {Status, ReceiveTimes} = ?IF( lists:member(GradeId, BuySituation), {2, 1}, {0, 0}),
                        #base_recharge_product{ product_name = ProductName, money = Money } = data_recharge:get_product(PackageRechargeId),
                        ConditionStr = util:term_to_string([{one_price, Money}]),
                        [{GradeId, 0, Status, ReceiveTimes, ProductName, ProductName, ConditionStr, util:term_to_string([])} | Acc];
                    false -> Acc
                end
        end
    end,
    SendList = lists:foldl(F, [], [PackageRechargeId|GradeIds]),
    {ok, BinData} = pt_331:write(33104, [ActType, SubType, SendList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData).

%% 仅用于活动开启/关闭时清理旧数据
clear_act_data(Type, SubType) ->
    %% 清除数据库
    db:execute(io_lib:format(?SQL_DELETE_CUSTOM_ACT_DATA_1, [Type, SubType])),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() ->
        [begin
             timer:sleep(500),
             lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_custom_daily_direct_buy, daily_clear, [Type, SubType])
         end || E <- OnlineRoles
        ]
    end).

daily_clear(Ps, Type, SubType) ->
    NewPlayer = lib_custom_act:delete_act_data_to_player_without_db(Ps, Type, SubType),
    lib_custom_act:db_delete_custom_act_data(Ps, Type, SubType),
    {ok, NewPlayer}.

%% =============================
%% inner_function
%% =============================
do_handle_event(Ps, ProductId) ->
    ActType = ?CUSTOM_ACT_TYPE_DAILY_DIRECT_BUY,
    SubTypeL = lib_custom_act_api:get_open_subtype_ids(ActType),
    Fun = fun(SubType, TemPS) ->
        %% 获取该子类型活动对应的商品礼包Id
        {one_package, PackageRechargeId, PackageGiftIdL} = lib_custom_act_util:keyfind_act_condition(ActType, SubType, one_package),
        Flag = ProductId == PackageRechargeId,
        case lists:member(ProductId, PackageGiftIdL) orelse Flag of
            true ->
                BoughtL = get_buy_data(TemPS, ActType, SubType),
                case lists:member(ProductId, BoughtL) of
                    true -> TemPS;
                    false ->
                        NewBoughtL = [ProductId|BoughtL],
                        NewData = #custom_act_daily_direct_buy{ bought = NewBoughtL, utime = utime:unixtime() },
                        NewActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData },
                        #player_status{ id = RoleId} = TemPS,
                        lib_custom_act:db_save_custom_act_data(RoleId, NewActData),
                        NewTemPS = lib_custom_act:save_act_data_to_player(TemPS, NewActData),
                        lib_custom_act:reward_status(NewTemPS, ActType, SubType),
                        %% 奖励与传闻相关处理(打包购买时会排除已购买过的礼包，不发重复奖励)
                        RewardProductL = ?IF( Flag, lists:subtract(PackageGiftIdL, BoughtL), [ProductId]),
                        send_reward_to_player(NewTemPS, ActType, SubType, RewardProductL, Flag, PackageRechargeId)
                end;
            false -> TemPS
        end
    end,
    lists:foldl(Fun, Ps, SubTypeL).

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
            #custom_act_cfg{ condition = ActConditionL } = lib_custom_act_util:get_act_cfg_info(ActType, SubType);
        false ->
            [ProductId2|_] = ProductIdList,
            [#custom_act_reward_cfg{ condition = ActConditionL }|_] = get_reward_cfg(ActType, SubType, ProductId2)
    end,
    %% 传闻
    case lists:keyfind(tv, 1, ActConditionL) of
        {tv, {ModuleId, TvId}} ->
            hearsay_handling(ModuleId, TvId, RoleId, RoleName, ProductId2, ActType, SubType);
        _ -> skip
    end,
    %% 日志
    GradeId = get_reward_grade_id(ActType, SubType, ProductId2, OnePackageProId),
    lib_log_api:log_custom_act_reward(NewPs, ActType, SubType, GradeId, RewardList),
    NewPs.

get_product_type() ->
    custom_act_daily_direct_buy.

%% 根据商品Id获取奖励配置信息
get_reward_cfg(ActType, SubType, ProductId) ->
    AllGradeList = data_custom_act:get_reward_grade_list(ActType, SubType),
    Fun = fun(GradeId, RewardCfgL) ->
        #custom_act_reward_cfg{ condition = RewardCondition } = RewardCfg = data_custom_act:get_reward_info(ActType, SubType, GradeId),
        {_, CfgProductId} = lists:keyfind(recharge_id, 1, RewardCondition),
        case CfgProductId == ProductId of
            true -> [RewardCfg|RewardCfgL];
            _ -> RewardCfgL
        end
    end,
    lists:foldl(Fun, [], AllGradeList).

%% 获取商品的购买情况
get_buy_data(Ps, ActType, SubType) ->
    case lib_custom_act:act_data(Ps, ActType, SubType) of
        #custom_act_data{ data = Data } ->
            case Data of
                #custom_act_daily_direct_buy{ bought = BoughtL, utime = Utime } ->
                    NowSec = utime:unixtime(),
                    case lib_custom_act_util:in_same_clear_day(ActType, SubType, NowSec, Utime) of
                        true -> BoughtL;
                        false -> []
                    end;
                _ -> []
            end;
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

%% 传闻处理
hearsay_handling(ModuleId, TvId, RoleId, RoleName, ProductId, ActType, SubType) ->
    #base_recharge_product{ product_name = ProductName} = data_recharge:get_product(ProductId),
    lib_chat:send_TV({all}, ModuleId, TvId, [RoleName, RoleId, ProductName, ActType, SubType]).