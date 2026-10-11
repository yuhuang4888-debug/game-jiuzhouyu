%% ---------------------------------------------------------------------------
%% @doc lib_drop_reward.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-21
%% @deprecated 掉落奖励
%% ---------------------------------------------------------------------------
-module(lib_drop_reward).

-compile(export_all).

-include("drop.hrl").
-include("goods.hrl").
-include("common.hrl").


%% 粗略计算掉落列表
calc_drop_reward(Career, Mid, DropLv, Alloc) ->
    DropRule = data_drop:get_rule(Mid, Alloc, DropLv),
    if
        DropRule == false -> [];
        true ->
            {_StableGoods, DropGoodsL, _TaskGoods, _DropGiftGoods} = calc_drop_reward_help(Career, DropRule),
            F = fun(DropGoods, List) ->
                #ets_drop_goods{type = Type, drop_thing_type = DTType, goods_id = GoodsTypeId, num = GoodsNum} = DropGoods,
                Goods = data_goods_type:get(GoodsTypeId),
                if
                    Type == ?DROP_TYPE_GIFT_RAND -> List;
                    (DTType == ?TYPE_GOODS andalso is_record(Goods, ets_goods_type) == false) orelse GoodsNum == 0 -> List;
                    true -> [{DTType, GoodsTypeId, GoodsNum}|List]
                end
            end,
            % ?PRINT("{_StableGoods, DropGoodsL, _TaskGoods, _DropGiftGoods}:~p ~n", [{_StableGoods, DropGoodsL, _TaskGoods, _DropGiftGoods}]),
            RewardL = lists:foldl(F, [], DropGoodsL),
            lib_goods_api:make_reward_unique(RewardL)
    end.

%% 计算掉落物品
calc_drop_reward_help(Career, DropRule) ->
    [StableGoods, TaskGoods, RandGoods, GiftGoods] = lib_goods_drop:get_drop_goods_list(DropRule#ets_drop_rule.drop_list, Career),
    DropNumList = lib_goods_drop:get_drop_num_list(DropRule),
    % 随机和礼包一起计算
    DropGoods = lib_goods_drop:drop_goods_list(RandGoods ++ GiftGoods, DropNumList),
    % DropGiftGoods = lib_goods_drop:drop_goods_list(GiftGoods, DropNumList),
    DropGiftGoods = [],
    {StableGoods, DropGoods, TaskGoods, DropGiftGoods}.

%% 计算掉落列表
%% 掉落奖励
calc_drop_reward(Player, MonArgs, Alloc) ->
    TeamMaxDropR = 0,
    #mon_args{mid = Mid, lv = DropLv} = MonArgs,
    DropRule = data_drop:get_rule(Mid, Alloc, DropLv),
    if
        DropRule == [] -> [];
        true ->
            {StableGoods, _TaskGoods, _RandGoods, _GiftGoods, DoRandGoods} = lib_goods_drop:calc_drop_goods(Player, DropRule, TeamMaxDropR),
            {ActDropList, _ActTaskGoods} = lib_goods_drop:calc_act_drop_goods(MonArgs),
            MulDropList = lib_goods_drop:calc_multiple_drops(Player, MonArgs, StableGoods),
            DropList = ActDropList ++ MulDropList ++ DoRandGoods,
            if
                DropList == [] -> [];
                true ->
                    %% 拿到限制的当前物品掉落的个人和全服限制数量
                    {PersonLimits, SerLimits, DropedCoin, DefCoinLimitCount} = lib_goods_drop:get_drop_goods_limit(Player, DropList),
                    Args = {PersonLimits, SerLimits, DropedCoin, DefCoinLimitCount},
                    %% {掉落金币数量, 玩家单个物品数量列表,全服掉落数量列表}
                    {CoinNum, PersonL, SererL, CanDrops, DropedCoin} = lib_goods_drop:do_handle_drop_goods_limit(Player, DropList, Args),
                    case CanDrops of
                        [] -> [];
                        _ ->
                            % 记录次数
                            lib_goods_drop:update_daily_drop_count(Player, CoinNum, PersonL, SererL, DropedCoin, PersonLimits, SerLimits),
                            F = fun(DropGoods, List) ->
                                #ets_drop_goods{drop_thing_type = DTType, goods_id = GoodsTypeId, num = GoodsNum} = DropGoods,
                                Goods = data_goods_type:get(GoodsTypeId),
                                if
                                    (DTType == ?TYPE_GOODS andalso is_record(Goods, ets_goods_type) == false) orelse GoodsNum == 0 -> List;
                                    true -> [{DTType, GoodsTypeId, GoodsNum}|List]
                                end
                            end,
                            % ?PRINT("{_StableGoods, DropGoodsL, _TaskGoods, _DropGiftGoods}:~p ~n", [{_StableGoods, DropGoodsL, _TaskGoods, _DropGiftGoods}]),
                            RewardL = lists:foldl(F, [], CanDrops),
                            lib_goods_api:make_reward_unique(RewardL)
                    end
            end
    end.

%% 多次计算纯掉落规则的奖励(不要加其他附加的加成)
calc_pure_drop_rule_reward_multi(Player, DropRule, Count) ->
    calc_pure_drop_rule_reward_multi_help(Count, Player, DropRule, []).

calc_pure_drop_rule_reward_multi_help(Count, _Player, _DropRule, SumRewardL) when Count =< 0 -> 
    lib_goods_api:make_reward_unique(SumRewardL);
calc_pure_drop_rule_reward_multi_help(Count, Player, DropRule, SumRewardL) ->
    RewardL = calc_pure_drop_rule_reward(Player, DropRule),
    calc_pure_drop_rule_reward_multi_help(Count-1, Player, DropRule, RewardL++SumRewardL).

%% 计算纯掉落规则的奖励(不要加其他附加的加成)
calc_pure_drop_rule_reward(_Player, []) -> [];
calc_pure_drop_rule_reward(Player, DropRule) ->
    TeamMaxDropR = 0,
    {StableGoods, _TaskGoods, _RandGoods, _GiftGoods, DoRandGoods} = lib_goods_drop:calc_drop_goods(Player, DropRule, TeamMaxDropR),
    DropList = StableGoods ++ DoRandGoods,
    %% 拿到限制的当前物品掉落的个人和全服限制数量
    {PersonLimits, SerLimits, DropedCoin, DefCoinLimitCount} = lib_goods_drop:get_drop_goods_limit(Player, DropList),
    Args = {PersonLimits, SerLimits, DropedCoin, DefCoinLimitCount},
    %% {掉落金币数量, 玩家单个物品数量列表,全服掉落数量列表}
    {CoinNum, PersonL, SererL, CanDrops, DropedCoin} = lib_goods_drop:do_handle_drop_goods_limit(Player, DropList, Args),
    case CanDrops of
        [] -> [];
        _ ->
            % 记录次数
            lib_goods_drop:update_daily_drop_count(Player, CoinNum, PersonL, SererL, DropedCoin, PersonLimits, SerLimits),
            F = fun(DropGoods, List) ->
                #ets_drop_goods{drop_thing_type = DTType, goods_id = GoodsTypeId, num = GoodsNum} = DropGoods,
                Goods = data_goods_type:get(GoodsTypeId),
                if
                    (DTType == ?TYPE_GOODS andalso is_record(Goods, ets_goods_type) == false) orelse GoodsNum == 0 -> List;
                    true -> [{DTType, GoodsTypeId, GoodsNum}|List]
                end
            end,
            % ?PRINT("{_StableGoods, DropGoodsL, _TaskGoods, _DropGiftGoods}:~p ~n", [{_StableGoods, DropGoodsL, _TaskGoods, _DropGiftGoods}]),
            RewardL = lists:foldl(F, [], CanDrops),
            lib_goods_api:make_reward_unique(RewardL)
    end.