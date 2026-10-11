%%---------------------------------------------------------------------------
%% @doc:        lib_dungeon_resource
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-3月-31. 16:17
%% @deprecated: 资源副本
%%---------------------------------------------------------------------------
-module(lib_dungeon_resource).

%% API
-export([
    is_resource_dungeon_type/1,
    is_resource_success/1,
    get_dungeon_count/2,
    get_daily_sweep_times/4,
    check_can_gage/2,
    material_one_operate/2,
    send_resource_count_info/3,
    calc_resource_dungeon_reward/2
]).

-export([
    add_challenges_daily_count/4,
    add_sweep_daily_count/4,
    mod_calc_resource_dungeon_reward/2
]).

-include("common.hrl").
-include("def_fun.hrl").
-include("dungeon.hrl").
-include("server.hrl").
-include("def_module.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("vip.hrl").
-include("weekly_card.hrl").
-include("def_vip.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("predefine.hrl").
-include("def_event.hrl").


%% 计算加成，过滤特定活动对宝箱的加成(扫荡专用)
calc_resource_dungeon_reward(BaseReward, N) when N > 1 ->
    {BaseRate, FilterRate} = filter_some_act_add(N - 1),
    F = fun({Type, GoodsId, Num}, NewRewardsA) ->
        case lists:member(GoodsId, ?WEEKLY_CARD_SHIELDED_TREASURE_CHESTS) of
            true ->
                NewNum = round(Num * FilterRate),
                ?IF(NewNum > 0, [{Type, GoodsId, NewNum}|NewRewardsA], NewRewardsA);
            false ->
                NewNum = round(Num * BaseRate),
                ?IF(NewNum > 0, [{Type, GoodsId, NewNum}|NewRewardsA], NewRewardsA)
        end
    end,
    AddReward = lists:foldl(F, [], BaseReward),
    lib_goods_api:make_reward_unique(AddReward ++ BaseReward);
calc_resource_dungeon_reward(BaseReward, _) ->
    BaseReward.

%% 计算加成，过滤特定活动对宝箱的加成(挑战结算专用)
mod_calc_resource_dungeon_reward(BaseReward, N) ->
    {BaseRate, FilterRate} = filter_some_act_add(N),
    F = fun({Type, GoodsId, Num}, NewRewardsA) ->
        case lists:member(GoodsId, ?WEEKLY_CARD_SHIELDED_TREASURE_CHESTS) of
            true ->
                NewNum = round(Num * FilterRate),
                ?IF(NewNum > 0, [{Type, GoodsId, NewNum}|NewRewardsA], NewRewardsA);
            false ->
                NewNum = round(Num * BaseRate),
                ?IF(NewNum > 0, [{Type, GoodsId, NewNum}|NewRewardsA], NewRewardsA)
        end
    end,
    lists:foldl(F, [], BaseReward).

%%  判断是否为资源副本，资源副本的挑战次数与扫荡次数需特殊处理
is_resource_dungeon_type(DunType) ->
    lists:member(DunType, ?DUNGEON_NEW_VERSION_MATERIEL_LIST).

%% 获取资源副本类型当天扫荡与挑战的次数并发送给玩家
get_dungeon_count(Player, DT) ->
    #player_status{ id = PlayerId } = Player,
    DunTypeL = ?IF( DT == 0, ?DUNGEON_NEW_VERSION_MATERIEL_LIST, [DT]),
    Fun = fun(DunType) ->
        ChallengeNum = mod_daily:get_count(PlayerId, ?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_CHALLENGE, DunType),
        SweepNum = mod_daily:get_count(PlayerId, ?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_SWEEP, DunType),
        {DunType, SweepNum, ChallengeNum}
    end,
    SendList = lists:map(Fun, DunTypeL),
    {ok, Bin} = pt_611:write(61121, [SendList]),
    lib_server_send:send_to_uid(PlayerId, Bin).

%% 判断资源副本是否通过
is_resource_success(Data) ->
    #callback_dungeon_succ{dun_type = DunType, pass_time = PassTime, dun_id = DunId} = Data,
    Flag = not lib_dungeon_resource:is_resource_dungeon_type(DunType),
    if
        Flag ->
            false;
        true ->
            TimeScore = lib_dungeon:get_time_score(DunId, PassTime),
            TimeScore > 0 %% 大于1分则认为是通关
    end.

%% 获取当天副本扫荡或者通过的次数
get_daily_sweep_times(DunType, AutoNum, CountType, DailyCountList) ->
    SubModule = ?IF( is_resource_dungeon_type(DunType), ?MOD_RESOURCE_DUNGEON_SWEEP, ?MOD_DUNGEON_ENTER),
    case lists:keyfind({?MOD_DUNGEON, SubModule, CountType}, 1, DailyCountList) of
        {_, Count} -> Count + AutoNum;
        _ -> AutoNum
    end.

%% 增加某个类型的资源副本的挑战次数
add_challenges_daily_count(PlayerId, DunType, DunId, AddCount)  ->
    case is_resource_dungeon_type(DunType) of
        true ->
            CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
            mod_daily:plus_count_offline(PlayerId, ?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_CHALLENGE, CountType, AddCount);
        _ ->
            skip
    end.

%% 增加某个类型的资源副本的扫荡次数
add_sweep_daily_count(PlayerId, DunType, DunId, Count) ->
    case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
        true ->
            CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
            mod_daily:plus_count_offline(PlayerId, ?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_SWEEP, CountType, Count);
        false ->
            skip
    end.

%% 手动挑战资源副本完成时，推送61121
send_resource_count_info(Node, RoleId, DunType) ->
    case is_resource_dungeon_type(DunType) of
        true ->
            case node() of
                Node ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, get_dungeon_count, [DunType]);
                _ ->
                    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, get_dungeon_count, [DunType])
            end;
        false ->
            skip
    end.

%% 检测是否可以进行一键挑战，同时计算合并奖励
check_can_gage(Player, DunType) ->
    case data_dungeon:get_ids_by_type(DunType) of
        [] ->
            {false, ?ERRCODE(err_config)};
        Ids ->
            DailyList = lib_dungeon_api:get_daily_gage_times_type_list(DunType),
            DailyCountList = mod_daily:get_count(Player#player_status.id, DailyList),
            LegalDunId = filter_legal_dungeon_id(Player#player_status.id, Ids),
            case LegalDunId of
                0 ->  {false, ?ERRCODE(err610_nothing_sweep)};
                _ ->
                    case check_can_gage(Player, data_dungeon:get(LegalDunId), 1, DailyCountList) of
                        {ok, RewardsList, SweepCost, _} ->
                            [RewardsList1] = RewardsList,
                            Re = {[{LegalDunId, RewardsList1}], lib_dungeon_sweep:merge_object_list(SweepCost, [])};
                        _ ->
                            Re = {[], []}
                    end,
                    case Re of
                        {[], []} ->
                            {false, ?ERRCODE(err610_nothing_sweep)};
                        {LastRewardsList, AllCost} ->
                            {ok, LastRewardsList, AllCost}
                    end
            end
    end.

%% ===================== 资源副本一键操作 =============================

material_one_operate(Ps, Operate) ->
    #player_status{ id = PlayerId, weekly_card_status = WeeklyStatus } = Ps,
    Flag = WeeklyStatus#weekly_card_status.is_activity == ?ACTIVATION_CLOSE,
    if
        Flag ->
            {ok, BinData} = pt_611:write(61120, [?ERRCODE(err610_no_active_weekly_card), Operate, []]),
            lib_server_send:send_to_uid(PlayerId, BinData),
            {ok, Ps};
        Operate == 1 ->
            one_click_sweep(Ps, 1);
        Operate == 2 ->
            one_click_sweep(Ps, 2);
        true ->
            {ok, BinData} = pt_611:write(61120, [?ERRCODE(fail), Operate, []]),
            lib_server_send:send_to_uid(PlayerId, BinData),
            {ok, Ps}
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述 一键完成所有资源副本的挑战和扫荡
%% @param   参数   Ps:#player_status{}   Operate:1-一键挑战(无消耗)；2-一键消耗(有消耗)
%% @return  返回值 {ok, NewPs}
%% -----------------------------------------------------------------
one_click_sweep(Ps, Operate) ->
    #player_status{ id = PlayerId } = Ps,
    {RewardLMap, CostsLMap} =
        case Operate of
            1 ->
                get_gage_reward(?DUNGEON_NEW_VERSION_MATERIEL_LIST, Ps, #{}, #{});
            2 ->
                get_all_material_dun_count(?DUNGEON_NEW_VERSION_MATERIEL_LIST, Ps, #{}, #{})
        end,
    F = fun(DunType, {SendRewardL, PassDunIds}) ->
        RewardL = maps:get(DunType, RewardLMap, []),
        case RewardL of
            [] ->
                {SendRewardL, PassDunIds};
            _ ->
                AddPassDunIds = [Id || {Id, _} <- RewardL],
                AddRewardL = lists:flatten([R1 ++ R2 ++R3 || {_, [{_, R1}, {_, R2}, {_, R3}]} <- RewardL]),
                NewSendRewardL = AddRewardL ++ SendRewardL,
                NewPassDunIds = AddPassDunIds ++ PassDunIds,
                {NewSendRewardL, NewPassDunIds}
        end
     end,
    {SendRewardL, PassDunIds} = lists:foldl(F, {[], []}, ?DUNGEON_NEW_VERSION_MATERIEL_LIST),
    case SendRewardL == [] of
        true ->
            {ok, BinData} = pt_611:write(61120, [?ERRCODE(err610_nothing_sweep), Operate, []]),
            lib_server_send:send_to_uid(PlayerId, BinData),
            {ok, Ps};
        _ ->
            case lib_goods_do:can_give_goods(SendRewardL, [?GOODS_LOC_BAG]) of
                true ->
                    Fun2 = fun(DunType, CostsL) ->
                        BaseAddCostL = maps:get(DunType, CostsLMap, []),
                        AddCostL = [I || {_, _, Num} = I <- BaseAddCostL, Num > 0],
                        AddCostL ++ CostsL
                    end,
                    CostsL = lists:foldl(Fun2, [], ?DUNGEON_NEW_VERSION_MATERIEL_LIST),
                    case lib_goods_api:check_object_list(Ps, CostsL) of
                        true ->
                            NewPs = ?IF(Operate == 1, Ps, dungeon_one_sweep_cost(?DUNGEON_NEW_VERSION_MATERIEL_LIST, CostsLMap, Ps)),
                            %% ?INFO("PassIds:~p~n", [PassDunIds]),
                            %% 完成扫荡后，次数和事件的派发
                            lib_dungeon:dungeon_count_plus(NewPs#player_status.id, PassDunIds, 1, Operate),
                            EventPs = event_other_activity(NewPs, PassDunIds, Operate),
                            RewardType = ?IF( Operate == 1, one_click_gage_reward, one_click_sweep_reward),
                            Fun3 = fun({_TempDunId, [{?REWARD_SOURCE_DUNGEON, FBaseReward}, {?REWARD_SOURCE_DUNGEON_MULTIPLE, FMultipleReward}, {?REWARD_SOURCE_WEEKLY_CARD, WeekCardReward}|_]}, {AccList, FunPs}) ->
                                {_, _, NewFunPs, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(FunPs, #produce{reward = FBaseReward ++ FMultipleReward ++ WeekCardReward, type = RewardType}),
                                FunSeeRewardList = lib_goods_api:make_see_reward_list(FBaseReward, UpGoodsList),
                                NewUpGoodsList  = lib_dungeon:take_see_reward_list_from_up_goods_list(FunSeeRewardList, UpGoodsList),
                                FunMultipleSeeReward = lib_goods_api:make_see_reward_list(FMultipleReward, NewUpGoodsList),
                                case FunMultipleSeeReward of
                                    [] ->
                                        ExtraReward = [];
                                    _ ->
                                        ExtraReward = [{?DUNGEON_PUSH_SETTLE_MULTIPLE_REWARD, FunMultipleSeeReward}]
                                end,
                                FunWeekCardReward =  lib_goods_api:make_see_reward_list(WeekCardReward, NewUpGoodsList),
                                case FunWeekCardReward of
                                    [] ->
                                        ExtraReward2 = ExtraReward;
                                    _ ->
                                        ExtraReward2 = [{?REWARD_SOURCE_WEEKLY_CARD, FunWeekCardReward}] ++ ExtraReward
                                end,
                                {[{FunSeeRewardList, ExtraReward2} | AccList], NewFunPs}
                             end,
                            RewardLMapList = maps:to_list(RewardLMap),
                            RewardLInfoList =  lists:flatten([RewardLInfo || {_DunType, RewardLInfo} <- RewardLMapList]),
                            {RewardsList, TmpPlayer} = lists:foldl(Fun3, {[], EventPs}, RewardLInfoList),
                            Fun4 = fun({DunType, RList}, FPs) ->
                                DunIds = [ DunId || {DunId, _} <- RList ],
                                NewFPs = lib_dungeon_sweep:handle_finish_duns(FPs, DunType, DunIds),
                                pp_dungeon:handle(61038, NewFPs, [DunType]),
                                NewFPs
                                   end,
                            LastsPs = lists:foldl(Fun4, TmpPlayer, RewardLMapList),
                            Code = ?SUCCESS;
                        {false, ErrorCode} ->
                            Code = ErrorCode,
                            RewardsList = [],
                            LastsPs = Ps
                    end;
                {false, ErrorCode} ->
                    Code = ErrorCode,
                    RewardsList = [],
                    LastsPs = Ps
            end,
            {ok, BinData} = pt_611:write(61120, [Code, Operate, RewardsList]),
            lib_server_send:send_to_uid(PlayerId, BinData),
            lib_dungeon_resource:get_dungeon_count(LastsPs, 0),
            {ok, LastsPs}
    end.

%% 删除消耗
dungeon_one_sweep_cost([], _, Ps) ->
    Ps;
dungeon_one_sweep_cost([DunType|Tail], CostsLMap, Ps) ->
    Costs = maps:get(DunType, CostsLMap, []),
    case lib_dungeon_sweep:sweep_cost(Ps, 0, DunType, Costs, one_click_sweep_cost, "") of
        {true, NewPs} ->
            dungeon_one_sweep_cost(Tail, CostsLMap, NewPs);
        _ ->
            dungeon_one_sweep_cost(Tail, CostsLMap, Ps)
    end.

%% 获取所有资源副本类型该次扫荡的总奖励和进行扫荡的关卡ID
get_all_material_dun_count([], _Ps, RewardMap, CostsMap) ->
    {RewardMap, CostsMap};
get_all_material_dun_count([DunType|Tail], Ps, RewardMap, CostsMap) ->
    case lib_dungeon:is_on_same_dun_type2(DunType, Ps) of
        true ->
            get_all_material_dun_count(Tail, Ps, RewardMap, CostsMap);
        _ ->
            case check_sweep(Ps, DunType) of
                {ok, AddRewardL, AddCostL} ->
                    RewardL = maps:get(DunType, RewardMap, []),
                    NewRewardL = AddRewardL ++ RewardL,
                    NewRewardMap = maps:put(DunType, NewRewardL, RewardMap),
                    CostL = maps:get(DunType, CostsMap, []),
                    NewCostsL = AddCostL ++ CostL,
                    NewCostsMap = maps:put(DunType, NewCostsL, CostsMap),
                    get_all_material_dun_count(Tail, Ps, NewRewardMap, NewCostsMap);
                _ ->
                    get_all_material_dun_count(Tail, Ps, RewardMap, CostsMap)
            end
    end.

get_gage_reward([], _Ps, RewardMap, CostsMap) ->
    {RewardMap, CostsMap};
get_gage_reward([DunType|Tail], Ps, RewardMap, CostsMap) ->
    case lib_dungeon:is_on_same_dun_type2(DunType, Ps) of
        true ->
            get_gage_reward(Tail, Ps, RewardMap, CostsMap);
        _ ->
            case lib_dungeon_resource:check_can_gage(Ps, DunType) of
                {ok, AddRewardL, _AddCostL} ->
                    RewardL = maps:get(DunType, RewardMap, []),
                    NewRewardL = AddRewardL ++ RewardL,
                    NewRewardMap = maps:put(DunType, NewRewardL, RewardMap),
                    get_gage_reward(Tail, Ps, NewRewardMap, CostsMap);
                _ ->
                    get_gage_reward(Tail, Ps, RewardMap, CostsMap)
            end
    end.

%% ======================================================
%% inner_function
%% ======================================================
check_can_gage(Player, Dun, AutoNum, DailyList) ->
    #dungeon{
        id = DunId, type = DunType, sweep_lv = Lv, sweep_cost = SweepCost, count_cond = CountCondition
    } = Dun,
    #player_status{
        figure = #figure{lv = RoleLv, vip = VipLv, vip_type = VipType}, dungeon_record = Rec, weekly_card_status = WeeklyCardStatus
    } = Player,
    case maps:find(DunId, Rec) of
        {ok, RecData} ->
            Score = lib_dungeon:calc_record_score(DunId, DunType, RecData),
            IsFinish = true;
        _ ->
            Score = 0,
            IsFinish = false
    end,
    Count = mod_counter:get_count(Player#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId),
    if
        Lv =:= 0 -> {false, ?ERRCODE(err610_sweep_limit_error)};
        RoleLv < Lv andalso WeeklyCardStatus#weekly_card_status.is_activity =:= ?ACTIVATION_CLOSE -> {false, {?ERRCODE(err610_sweep_lv_limit), [Lv]}};
        % 没有挑战过以及没有记录
        Count == 0 andalso IsFinish == false -> {false, ?ERRCODE(err610_sweep_never_finish)};
        true ->
            case check_gate_count(VipType, VipLv, DunId, DunType, AutoNum, DailyList, CountCondition) of
                true ->
                    Mul = lib_dungeon:get_mul_drop_times(Dun, Player),
                    case lib_dungeon_sweep:calc_sweep_rewards(Dun, Score, AutoNum, Mul, WeeklyCardStatus) of
                        {ok, RewardsList, WeeklyCardRewards} ->
                            RewardsList1 = lib_dungeon_api:get_base_reward_and_multiple_reward_by_multiple(RewardsList, Mul, WeeklyCardRewards),
                            RewardsList2 = lib_dungeon_util:get_merge_reward_list(RewardsList1),
                            AllSweepCost = lib_goods_util:goods_object_multiply_by(SweepCost, AutoNum),
                            {ok, RewardsList2, AllSweepCost, Score};
                        Error ->
                            Error
                    end;
                Error ->
                    Error
            end
    end.

check_gate_count(VipType, VipLv, DunId, DunType, AutoNum, DailyList, [{_, Max}|_]) ->
    UseCount = lib_dungeon:get_daily_use_count(DunType, DunId, DailyList, 1),
    CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
    VipFreeCount = lib_vip_api:get_vip_privilege(?MOD_DUNGEON, ?VIP_DUNGEON_ENTER_RIGHT_ID(CountType), VipType, VipLv),
    if
        UseCount + AutoNum =< Max + VipFreeCount ->
            true;
        true ->
            {false, ?ERRCODE(err610_dungeon_count_daily)}
    end.

%% 成功一键挑战或者一键扫荡后，各种活动的次数和其他功能时间的派发
event_other_activity(Ps, PassDunIds, Operate) ->
    case Operate of
        1 ->
            challenge_event_other_activity(Ps, PassDunIds);
        2 ->
            NewPs = sweep_event_other_activity(Ps, PassDunIds),
            sweep_event_by_dungeon_type(NewPs, PassDunIds)
    end.

challenge_event_other_activity(Player, [DunId|Tail]) ->
    #dungeon{type = DunType} = data_dungeon:get(DunId),
    Data = #callback_dungeon_succ{dun_id = DunId, dun_type = DunType, count = 1},
    lib_player_event:async_dispatch(Player#player_status.id, ?EVENT_DUNGEON_SUCCESS, Data),
    challenge_event_other_activity(Player, Tail);
challenge_event_other_activity(Player, []) ->
    Player.

sweep_event_other_activity(Player, [DunId|Tail]) ->
    #dungeon{type = DunType} = data_dungeon:get(DunId),
    Data = #callback_dungeon_succ{dun_id = DunId, dun_type = DunType, count = 1},
    lib_player_event:async_dispatch(Player#player_status.id, ?EVENT_DUNGEON_SUCCESS, Data),
    NewPlayer = lib_dungeon_sweep:handle_finish_duns(Player, DunType, lists:duplicate(1, DunId)),
    sweep_event_other_activity(NewPlayer, Tail);
sweep_event_other_activity(Player, []) ->
    Player.

%% 一键扫荡特殊处理的check_fun
check_sweep(Player, DunType) ->
    #player_status{ id = PlayerId, figure = #figure{vip = VipLv, vip_type = VipType} } = Player,
    ChallengeNum = mod_daily:get_count(PlayerId, ?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_CHALLENGE, DunType),
    Ids = data_dungeon:get_ids_by_type(DunType),
    %% 只有当天挑战过的副本的才可参与一键扫荡
    case ChallengeNum > 0 andalso Ids =/= [] of
        true ->
            DailyList = lib_dungeon_api:get_daily_sweep_times_type_list(DunType),
            DailyCountList = mod_daily:get_count(Player#player_status.id, DailyList),
            HasSweepNum = mod_daily:get_count(PlayerId, ?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_SWEEP, DunType),   %% 已经扫荡的次数
            CanSweepNum = lib_vip_api:get_vip_privilege(?MOD_DUNGEON, ?VIP_DUNGEON_BUY_RIGHT_ID(DunType), VipType, VipLv),   %% 玩家所有扫荡的次数
            ThisSweepNum = CanSweepNum - HasSweepNum,
            LegalDunId = filter_legal_dungeon_id(PlayerId, Ids),
            case ThisSweepNum > 0 of
                true ->
                    RoundFun = fun(Round, {AllRewardL, AllCostsL}) ->
                        CurSweepCount = HasSweepNum + Round,
                        F = fun(DunId, {Acc, AllCost}) ->
                            Dun = data_dungeon:get(DunId),
                            case lib_dungeon_sweep:check_sweep(Player, Dun, 1, DailyCountList, CurSweepCount) of
                                {ok, RewardsList, SweepCost, _} ->
                                    [RewardsList1] = RewardsList,
                                    {[{DunId, RewardsList1}|Acc], lib_dungeon_sweep:merge_object_list(SweepCost, AllCost)};
                                _ ->
                                    {Acc, AllCost}
                            end
                        end,
                        {DunRewardL, DunCostsL} = lists:foldl(F, {[], []}, [LegalDunId]),
                        NewAllRewardL = DunRewardL ++ AllRewardL,
                        NewAllCosts = DunCostsL ++ AllCostsL,
                        {NewAllRewardL, NewAllCosts}
                    end,
                    case lists:foldl(RoundFun, {[], []}, lists:seq(1, ThisSweepNum)) of
                        {[], []} ->
                            {false, ?ERRCODE(err610_nothing_sweep)};
                        {RewardsList, AllCost} ->
                            {ok, RewardsList, AllCost}
                    end;
                false ->
                    skip
            end;
        _ ->
            skip
    end.

filter_legal_dungeon_id(PlayerId, DunIds) ->
    Fun = fun(DunId) ->
        Count = mod_counter:get_count(PlayerId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId),
        Count > 0
    end,
    Filter = lists:filter(Fun, DunIds),
    case Filter of
        [] -> 0;
        _ -> lists:max(Filter)
    end.

sweep_event_by_dungeon_type(Player, PassDunIds) ->
    Fun = fun(DunId, AccL) ->
        #dungeon{type = DunType} = data_dungeon:get(DunId),
        case lists:keyfind(DunType, 1, AccL) of
            {DunType, Num} ->
                lists:keystore(DunType, 1, AccL, {DunType, Num + 1});
            _ ->
                [{DunType, 1}|AccL]
        end
    end,
    DunTypeTimesL = lists:foldl(Fun, [], PassDunIds),
    PlayerId = Player#player_status.id,
    Level = Player#player_status.figure#figure.lv,
    Fun2 = fun({DunType, Times}, TemPs) ->
        lib_hi_point_api:hi_point_task_sweep_dun(PlayerId, Level, DunType, Times),
        {ok, SupVipPlayer} = lib_supreme_vip_api:dun_clean(TemPs, DunType, Times),
        SupVipPlayer
    end,
    lists:foldl(Fun2, Player, DunTypeTimesL).

%% 过滤某些定制活动的加成
filter_some_act_add(BaseRate) ->
    %% ?CUSTOM_ACT_TYPE_LIVENESS 56 特殊处理
    case lib_custom_act_util:get_open_subtype_list(56) of
        [] ->
            {BaseRate, BaseRate};
        _ ->
            {BaseRate, BaseRate - data_key_value:get(3310050)}
    end.