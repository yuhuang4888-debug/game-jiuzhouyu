%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_sweep.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-10-13
%% @Description:    副本扫荡
%%-----------------------------------------------------------------------------

-module (lib_dungeon_sweep).
-include ("errcode.hrl").
-include ("def_module.hrl").
-include ("dungeon.hrl").
-include ("server.hrl").
-include ("figure.hrl").
-include("goods.hrl").
-include ("common.hrl").
-include ("rec_event.hrl").
-include("def_vip.hrl").
-include("weekly_card.hrl").
-include("def_fun.hrl").

-export([
    check_sweep/5
    , check_sweep/2
    , check_sweep_count/8
    , handle_finish_duns/3
    , simple_check_sweep/2
    , sweep_cost/6
    , send_sweep_dungeon_reward_online/3
    , send_sweep_dungeon_reward_offline/4
    , do_calc_weekly_card_reward/1
    , merge_object_list/2
    ,calc_sweep_rewards/5
    ,calc_weekly_card_reward/3
]).

calc_sweep_rewards(Dun, Score, AutoNum, Mul, WeeklyCardStatus) ->
    #dungeon{type = DunType} = Dun,
    case calc_multiple_sweep_rewards(Dun, Score, AutoNum, Mul) of
        {ok, RewardsList} ->
            #weekly_card_status{is_activity = IsActivity} = WeeklyCardStatus,
            IsAddDunType = lib_dungeon_resource:is_resource_dungeon_type(DunType),
            if
                IsActivity =:= ?ACTIVATION_OPEN andalso IsAddDunType ->
                    WeeklyCardRewards = calc_weekly_card_reward(Dun, Score, AutoNum),
                    {ok, RewardsList, WeeklyCardRewards};
                true -> {ok, RewardsList, []}
            end;
        Error -> Error
    end.

calc_multiple_sweep_rewards(Dun, Score, AutoNum, Mul) ->
    #dungeon{id = DunId, type = DunType } = Dun,
    case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
        true ->
            %% 与策划确认过,资源副本的扫荡奖励和通过评分时候的一样,故这里特殊处理资源副本
            Cfg = data_dungeon_grade:get_dungeon_grade(DunId, Score),
            case Cfg == [] of
                true ->
                    AddRewardList = [[], []];
                false ->
                    AddRewardList = [Cfg#dungeon_grade.draw_list, Cfg#dungeon_grade.reward]
            end;
        false ->
            AddRewardList = data_dungeon_sweep:get_rewards(DunId, Score)
    end,
    case AddRewardList of
        [] ->
            {false, ?ERRCODE(err_config)};
        [DrawList, Rewards] ->
            case DrawList of
                [] ->
                    case lib_goods_util:is_random_rewards(Rewards) of
                        false ->
                            MulRewards = case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
                                             false ->
                                                 lib_goods_util:goods_object_multiply_by(Rewards, Mul);
                                             true ->
                                                 lib_dungeon_resource:calc_resource_dungeon_reward(Rewards, Mul)
                                         end,
                            {ok, [MulRewards || _ <- lists:seq(1, AutoNum)]};
                        _ ->
                            F = fun(_Seq, Result) ->
                                Rs = lib_goods_util:calc_random_rewards(Rewards),
                                MulRewards = case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
                                                 false ->
                                                     lib_goods_util:goods_object_multiply_by(Rewards, Mul);
                                                 true ->
                                                     lib_dungeon_resource:calc_resource_dungeon_reward(Rewards, Mul)
                                             end,
                                [MulRewards|Result]
                                end,
                            SweepReward = lists:foldl(F, [], lists:seq(1, AutoNum)),
                            {ok, SweepReward}
                    end;
                _ ->
                    F = fun(_Seq, Result) ->
                        List = lib_dungeon_api:get_dungeon_grade_help(DrawList, Rewards, []),  %%新的格式
                        MulRewards = case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
                                         false ->
                                             lib_goods_util:goods_object_multiply_by(Rewards, Mul);
                                         true ->
                                             lib_dungeon_resource:calc_resource_dungeon_reward(Rewards, Mul)
                                     end,
                        NewList = [{GoodType, GoodId, Num} || {GoodType, GoodId, Num} <- MulRewards, Num > 0],
                        [NewList|Result]
                    end,
                    SweepReward = lists:foldl(F, [], lists:seq(1, AutoNum)),
                    {ok, SweepReward}
            end
    end.

calc_weekly_card_reward(Dun, Score, AutoNum) ->
    #dungeon{id = DunId, type = DunType} = Dun,
    case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
        true ->
            %% 与策划确认过,资源副本的扫荡奖励和通过评分时候的一样,故这里特殊处理资源副本
            Cfg = data_dungeon_grade:get_dungeon_grade(DunId, Score),
            case Cfg == [] of
                true ->
                    [DrawList, Rewards] = [[], []];
                false ->
                    [DrawList, Rewards] = [Cfg#dungeon_grade.draw_list, Cfg#dungeon_grade.reward]
            end;
        false ->
            [DrawList, Rewards] = data_dungeon_sweep:get_rewards(DunId, Score)
    end,
    case DrawList of
        [] ->
            case lib_goods_util:is_random_rewards(Rewards) of
                false ->
                    NewRewards = do_calc_weekly_card_reward(Rewards),
                    [NewRewards || _ <- lists:seq(1, AutoNum)];
                _ ->
                    RewardsA = lib_goods_util:calc_random_rewards(Rewards),
                    NewRewards = do_calc_weekly_card_reward(RewardsA),
                    [NewRewards || _ <- lists:seq(1, AutoNum)]
            end;
        _ ->
            F = fun(_Seq, Result) ->
                List = lib_dungeon_api:get_dungeon_grade_help(DrawList, Rewards, []),
                NewList = [{GoodType, GoodId, Num} || {GoodType, GoodId, Num} <- List, Num > 0],
                NewRewards = do_calc_weekly_card_reward(NewList),
                [NewRewards | Result]
            end,
           lists:foldl(F, [], lists:seq(1, AutoNum))
    end.

do_calc_weekly_card_reward(Rewards) ->
    F = fun(Reward, NewRewardsA) ->
        {Type, GoodsId, Num} = Reward,
        case lists:member(GoodsId, ?WEEKLY_CARD_SHIELDED_TREASURE_CHESTS) of
            true -> NewRewardsA;
            false -> [{Type, GoodsId, round(Num * ?WEEKLY_CARD_DUNGEON_ADD)} | NewRewardsA]
        end
    end,
    lists:foldl(F, [], Rewards).

check_sweep(Player, Dun, AutoNum, DailyList, CurSweepCount) ->
    #dungeon{id = DunId, type = DunType, sweep_lv = Lv, sweep_cost = CfgCostsL, count_cond = CountCondition} = Dun,
    #player_status{figure = #figure{lv = RoleLv, vip = VipLv, vip_type = VipType}, dungeon_record = Rec, id = RoleId, weekly_card_status = WeeklyCardStatus} = Player,
    case maps:find(DunId, Rec) of
        {ok, RecData} ->
            Score = lib_dungeon:calc_record_score(DunId, DunType, RecData),
            IsFinish = true;
        _ ->
            Score = 0,
            IsFinish = false
    end,
    Count = mod_counter:get_count(Player#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId),
    SweepCost = calc_costs_by_count(CurSweepCount, CfgCostsL),
    if
        Lv =:= 0 ->
            {false, ?ERRCODE(err610_sweep_limit_error)};
        RoleLv < Lv andalso WeeklyCardStatus#weekly_card_status.is_activity =:= ?ACTIVATION_CLOSE ->
            {false, {?ERRCODE(err610_sweep_lv_limit), [Lv]}};
        % 没有挑战过以及没有记录
        Count == 0 andalso IsFinish == false ->
            {false, ?ERRCODE(err610_sweep_never_finish)};
        true ->
            case check_sweep_count(RoleId, VipType, VipLv, DunId, DunType, AutoNum, DailyList, CountCondition) of
                true ->
                    Mul = lib_dungeon:get_mul_drop_times(Dun, Player),
                    case calc_sweep_rewards(Dun, Score, AutoNum, Mul, WeeklyCardStatus) of
                        {ok, RewardsList, WeeklyCardRewards} ->
                            RewardsList1 = lib_dungeon_api:get_base_reward_and_multiple_reward_by_multiple(RewardsList, Mul, WeeklyCardRewards),
                            RewardsList2 = lib_dungeon_util:get_merge_reward_list(RewardsList1),
                            %?MYLOG("lwccard","RewardsList1:~p~n",[RewardsList2]),
                            AllSweepCost = lib_goods_util:goods_object_multiply_by(SweepCost, AutoNum),
                            {ok, RewardsList2, AllSweepCost, Score};
                        Error ->
                            Error
                    end;
                Error ->
                    Error
            end
    end.

check_sweep(Player, DunType) ->
    case data_dungeon:get_ids_by_type(DunType) of
        [] ->
            {false, ?ERRCODE(err_config)};
        Ids ->
            DailyList = lib_dungeon_api:get_daily_sweep_times_type_list(DunType),
            DailyCountList = mod_daily:get_count(Player#player_status.id, DailyList),
            HasSweepNum = mod_daily:get_count(Player#player_status.id, ?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_SWEEP, DunType),   %% 已经扫荡的次数
            F = fun
                (DunId, {Acc, AllCost}) ->
                    case check_sweep(Player, data_dungeon:get(DunId), 1, DailyCountList, HasSweepNum + 1) of
                        {ok, RewardsList, SweepCost, _} ->
                            [RewardsList1] = RewardsList, %%[{Source1, Reerward}, {Source2, Reerward}]
                            {[{DunId, RewardsList1}|Acc], merge_object_list(SweepCost, AllCost)};
                        _ ->
                            {Acc, AllCost}
                    end
            end,
            case lists:foldl(F, {[], []}, Ids) of
                {[], []} ->
                    {false, ?ERRCODE(err610_nothing_sweep)};
                {RewardsList, AllCost} ->
                    {ok, RewardsList, AllCost}
            end
    end.

check_sweep_count(RoleId, VipType, VipLv, DunId, DunType, AutoNum, DailyList, [{?DUN_COUNT_COND_DAILY, Max}|T]) ->
    UseCount = lib_dungeon:get_daily_use_count(DunType, DunId, DailyList, 2),
    CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
    VipFreeCount = lib_vip_api:get_vip_privilege(?MOD_DUNGEON, ?VIP_DUNGEON_BUY_RIGHT_ID(CountType), VipType, VipLv),
    %% ?MYLOG("lhhsweep", "UseCount:~p//AutoNum:~p//Max:~p//Vip:~p//Other:~p", [UseCount, AutoNum, Max, VipFreeCount, {CountType, VipType, VipLv,DunId, DunType, AutoNum, DailyList}]),
    if
        UseCount + AutoNum =< Max + VipFreeCount ->
            check_sweep_count(RoleId, VipType, VipLv, DunId, DunType, AutoNum, DailyList, T);
        true ->
            {false, ?ERRCODE(err610_dungeon_count_daily_sweep)}
    end;

check_sweep_count(RoleId, VipType, VipLv, DunId, DunType, AutoNum, DailyList, [{?DUN_COUNT_COND_WEEK, Max}|T]) ->
    Num = mod_week:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId),
    if
        Num + AutoNum =< Max ->
            check_sweep_count(RoleId, VipType, VipLv, DunId, DunType, AutoNum, DailyList, T);
        true ->
            {false, ?ERRCODE(err610_dungeon_count_weekly_sweep)}
    end;

check_sweep_count(RoleId, VipType, VipLv, DunId, DunType, AutoNum, DailyList, [{?DUN_COUNT_COND_PERMANENT, Max}|T]) ->
    Num = mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId),
    if
        Num + AutoNum =< Max ->
            check_sweep_count(RoleId, VipType, VipLv, DunId, DunType, AutoNum, DailyList, T);
        true ->
            {false, ?ERRCODE(err610_dungeon_count_permanent_sweep)}
    end;

check_sweep_count(RoleId, VipType, VipLv, DunId, DunType, AutoNum, DailyList, [_|T]) ->
    check_sweep_count(RoleId, VipType, VipLv, DunId, DunType, AutoNum, DailyList, T);

check_sweep_count(_RoleId, _VipType, _VipLv, _DunId, _DunType, _AutoNum, _DailyList, []) -> true.

merge_object_list([{Type, Id, Num}|T], All) ->
    case lists:keyfind({Type, Id}, 1, All) of
        {_, Num0} ->
            All1 = lists:keystore({Type, Id}, 1, All, {{Type, Id}, Num0 + Num});
        _ ->
            All1 = [{{Type, Id}, Num} | All]
    end,
    merge_object_list(T, All1);

merge_object_list([{Id, Num}|T], All) ->
    case lists:keyfind({?TYPE_GOODS, Id}, 1, All) of
        {_, Num0} ->
            All1 = lists:keystore({?TYPE_GOODS, Id}, 1, All, {{?TYPE_GOODS, Id}, Num0 + Num});
        _ ->
            All1 = [{{?TYPE_GOODS, Id}, Num} | All]
    end,
    merge_object_list(T, All1);

merge_object_list([], All) ->
    [{Type, Id, Num} || {{Type, Id}, Num} <- All].

handle_finish_duns(#player_status{id = RoleId} = Player, DunType, DunIds) ->
    NewPlayer = handle_achievement(Player, DunIds),
    [lib_dungeon:handle_task_trigger(RoleId, DunType, DunId) || DunId <- DunIds],
    [begin
%%         lib_activitycalen_api:role_success_end_activity(Player#player_status.id, ?MOD_DUNGEON, DunType),
         lib_dungeon:handle_dungeon_sweep_by_type(Player, DunType)
     end || _DunId <- DunIds],
    NewPlayer.

handle_achievement(Player, [DunId|T]) ->
    NewPlayer = lib_dungeon:handle_achievement(Player, DunId),
    handle_achievement(NewPlayer, T);

handle_achievement(Player, []) -> Player.

%% 简单判断是否能扫荡,给客户端使用
simple_check_sweep(DungeonInfo, RoleLv) ->
    #dungeon_info{id = DunId, is_rec = IsRec, success_count = Count} = DungeonInfo,
    case data_dungeon:get(DunId) of
        #dungeon{sweep_lv = SweepLv} -> ok;
        _ -> SweepLv = 0
    end,
    if
        SweepLv =:= 0 -> false;
        RoleLv < SweepLv -> false;
        % 没有挑战过以及没有记录
        Count == 0 andalso IsRec == false -> false;
        true -> true
    end.

%% 扫荡消耗
sweep_cost(Player, DunId, DunType, ObjectList, Type, About) ->
    case is_auto_buy_sweep(DunId, DunType) of
        true ->
            case lib_goods_api:cost_objects_with_auto_buy_with_bg_to_g(Player, ObjectList, Type, About) of
                {true, NewPlayer, _RealCostList} -> {true, NewPlayer};
                Other -> Other
            end;
        false ->
            lib_goods_api:cost_object_list_with_check(Player, ObjectList, Type, About)
    end.

%% 是否自动购买扫荡
%% DunId等于0,就是判断副本类型
%% @param DunId 副本id
%% @param DunType 副本类型
is_auto_buy_sweep(DunId, DunType) ->
    case data_dungeon:get(DunId) of
        #dungeon{is_auto_buy_sweep = IsAutoBuySweep} -> IsAutoBuySweep == 1;
        _ ->
            case data_dungeon_special:get(DunType, is_auto_buy_sweep) of
                undefined -> false;
                IsAutoBuySweep -> IsAutoBuySweep == 1
            end
    end.

%% 扫荡发奖励
send_sweep_dungeon_reward_online(DunType, CostPlayer, RewardsList0) ->
    F = fun([{?REWARD_SOURCE_DUNGEON, FBaseReward}, {?REWARD_SOURCE_DUNGEON_MULTIPLE, FMultipleReward}, {?REWARD_SOURCE_WEEKLY_CARD, WeeklyCardReward}], {AccList, FunPs}) ->
            {_, _, NewFunPs, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(FunPs, #produce{reward = FBaseReward ++ FMultipleReward ++ WeeklyCardReward,
                type = dungeon_count_sweep_rewards, subtype = DunType}),
        %% 基础奖励see列表
        FunSeeRewardList = lib_goods_api:make_see_reward_list(FBaseReward, UpGoodsList),
        NewUpGoodsListA = lib_dungeon:take_see_reward_list_from_up_goods_list(FunSeeRewardList, UpGoodsList),
        %% 多倍奖励see列表
        FunMultipleSeeReward = lib_goods_api:make_see_reward_list(FMultipleReward, NewUpGoodsListA),
        NewUpGoodsListB = lib_dungeon:take_see_reward_list_from_up_goods_list(FunMultipleSeeReward, NewUpGoodsListA),
        %% 周卡奖励see列表
        FunWeeklyCardSeeReward = lib_goods_api:make_see_reward_list(WeeklyCardReward, NewUpGoodsListB),
        NewOtherSeeRewardA = ?IF(length(FunMultipleSeeReward) =:= 0, [], [{?DUNGEON_PUSH_SETTLE_MULTIPLE_REWARD, FunMultipleSeeReward}]),
        NewOtherSeeRewardB = ?IF(length(FunWeeklyCardSeeReward) =:= 0, [] ++ NewOtherSeeRewardA, [{?REWARD_SOURCE_WEEKLY_CARD, FunWeeklyCardSeeReward}] ++ NewOtherSeeRewardA),
        {[{FunSeeRewardList, NewOtherSeeRewardB} | AccList], NewFunPs}
    end,
    %?MYLOG("lwccard","RewardsList0:~p~n",[RewardsList0]),
    lists:foldl(F, {[], CostPlayer}, RewardsList0).

send_sweep_dungeon_reward_offline(DunType, CostPlayer, RewardsList0, Rewards) ->
    TmpPlayer = lib_goods_api:send_reward(CostPlayer, Rewards, dungeon_count_sweep_rewards, DunType),
    F = fun([{?REWARD_SOURCE_DUNGEON, FBaseReward}, {?REWARD_SOURCE_DUNGEON_MULTIPLE, FMultipleReward}, {?REWARD_SOURCE_WEEKLY_CARD, WeeklyCardReward}], AccList) ->
        %% 基础奖励see列表
        FunSeeRewardList = lib_goods_api:make_see_reward_list(FBaseReward, []),
        %% 多倍奖励see列表
        FunMultipleSeeReward = lib_goods_api:make_see_reward_list(FMultipleReward, []),
        %% 周卡奖励see列表
        FunWeeklyCardSeeReward = lib_goods_api:make_see_reward_list(WeeklyCardReward, []),
        NewFunMultipleSeeReward = ?IF(length(FunMultipleSeeReward) =:= 0, [], [{?DUNGEON_PUSH_SETTLE_MULTIPLE_REWARD, FunMultipleSeeReward}]),
        NewFunWeeklyCardSeeReward = ?IF(length(FunWeeklyCardSeeReward) =:= 0, [], [{?REWARD_SOURCE_WEEKLY_CARD, FunWeeklyCardSeeReward}]),
        [{FunSeeRewardList, NewFunMultipleSeeReward, NewFunWeeklyCardSeeReward} | AccList]
    end,
    RewardsList = lists:foldl(F, [], RewardsList0),
    {RewardsList, TmpPlayer}.

%% 根据扫荡次数计算消耗
calc_costs_by_count(Count, CfgCostsL) ->
    Fun = fun
              ({Min, Max, CostTuple}, RealCostL) ->
                  case Count >= Min andalso Count =< Max of
                      true -> [CostTuple];
                      false -> RealCostL
                  end;
              (BaseCost, _RealCostL) ->
                  [BaseCost]
    end,
    lists:foldl(Fun, [{2,0,20}], CfgCostsL).