%% ---------------------------------------------------------------------------
%% @doc lib_contract_challenge_util

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/7/29
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_contract_challenge_util).

%% API
-compile([export_all]).

-include("custom_act.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("contract_challenge.hrl").
-include("def_recharge.hrl").

%% ==================================================================
%% 初始化用户的契约挑战信息
%% return #role_challenge{}
%% ==================================================================
init_role_challenge(SubType, OpenDay, RoleId, RewardGrades) ->
    DaliyChallengeList = init_daily_challenge_list(SubType, OpenDay, RoleId),
    GrandTaskIds = data_contract_challenge:get_task_ids_by_type(SubType, ?GRAND_TASK),
    GrandChallengeList = init_challenge_list(RoleId, GrandTaskIds, SubType, OpenDay, ?DAILY_TASK_NUM + 1, [], []),
    RewardStatus = [{Grade, ?NO_GET}||Grade <- RewardGrades],
    RoleChallenge =
        #role_challenge{
            challenge_list = DaliyChallengeList ++ GrandChallengeList,
            reward_status = RewardStatus
        },
    save_act_info(SubType, RoleId, RoleChallenge),
    RoleChallenge.

%% ==================================================================
%% 初始化每日任务
%% 每日凌晨四点调用，首次加载也会调用
%% return [#challenge_item{} | _]
%% ==================================================================
init_daily_challenge_list(SubType, OpenDay, RoleId) ->
    DailyTaskIds = data_contract_challenge:get_task_ids_by_type_opday(SubType, ?DAILY_TASK, OpenDay),
    F = fun(TaskId, {ResList, Index, GrandParam}) ->
        #base_contract_challenge{
            task_id = TaskId,
            challenge_type = ChallengeType,
            module = Module,
            sub_module = SubModule
        } = data_contract_challenge:get_cfg(SubType, TaskId),
        Item = #challenge_item{
            item_id = Index,
            task_id = TaskId,
            challenge_type = ChallengeType,
            module = Module,
            sub_module = SubModule,
            is_get = ?NO_GET              %% 是否领取奖励 0未领取，1可领取，2已领取
        },
        NParam = save_act_task_item2(SubType, RoleId, Item),
        {[Item|ResList], Index + 1, [NParam|GrandParam]}
        end,
    {AllDailyItems, _, ReplaceParams} = lists:foldl(F, {[], 1, []}, DailyTaskIds),
    Sql = usql:replace(contract_challenge_act_item, [sub_type, role_id, item_id, task_id, grand_num, is_get, utime], ReplaceParams),
    ?IF(Sql =/= [], db:execute(Sql), skip),
    lists:reverse(AllDailyItems).

%% ==================================================================
%% 初始化累计任务
%% 首次加载才调用
%% return [#challenge_item{} | _]
%% ==================================================================
init_challenge_list(_RoleId, [], _SubType, _OpenDay, _ItemId, ReplaceParam, ResList) ->
    Sql = usql:replace(contract_challenge_act_item, [sub_type, role_id, item_id, task_id, grand_num, is_get, utime], ReplaceParam),
    ?IF(Sql =/= [], db:execute(Sql), skip),
    lists:reverse(ResList);
init_challenge_list(RoleId, [TaskId|T], SubType, _OpenDay, ItemId, ReplaceParam, ResList) ->
    #base_contract_challenge{
        task_id = TaskId,
        challenge_type = ChallengeType,
        module = Module,
        sub_module = SubModule
    } = data_contract_challenge:get_cfg(SubType, TaskId),
    Item = #challenge_item{
        item_id = ItemId,
        task_id = TaskId,
        challenge_type = ChallengeType,
        module = Module,
        sub_module = SubModule,
        is_get = ?NO_GET              %% 是否领取奖励 0未领取，1可领取，2已领取
    },
    NParam = save_act_task_item2(SubType, RoleId, Item),
    init_challenge_list(RoleId, T,SubType, _OpenDay, ItemId + 1, [NParam|ReplaceParam], [Item|ResList]).

%%======================================================
%% 更新奖励状态,领取契约点和激活传说契约需要调用
%% return NewRewardStatus
%%======================================================
flush_reward_status(SubType, SumPoint, IsLegend, RewardStatus) ->
    F = fun(Item) ->
        {Grade, GetStatus} = Item,
        case GetStatus == ?NO_GET of
            false -> Item;
            true ->
                #custom_act_reward_cfg{
                    condition = Condition
                } = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade),
                {is_legend, IsLeg} = lists:keyfind(is_legend, 1, Condition),
                {point, Point} = lists:keyfind(point, 1, Condition),
                if
                    SumPoint < Point -> Item;
                    true ->
                        if
                            IsLeg == ?IS_LEGEND andalso IsLegend == ?NOT_LEGEND -> Item;
                            true -> {Grade, ?CAN_GET}
                        end
                end
        end
        end,
    lists:map(F, RewardStatus).

%% =============================================================
%%   刷新奖励状态
%%   @return {#role_challenge{}, bool(奖励状态是否改变了，改变了推协议)}
%% =============================================================
flush_reward_status(SubType, RoleChallenge) ->
    #role_challenge{sum_point = SumPoint, reward_status = RewardStatus, is_legend = IsLegend} = RoleChallenge,
    F = fun(Item) ->
        {Grade, GetStatus} = Item,
        case GetStatus == ?NO_GET of
            false -> Item;
            true ->
                #custom_act_reward_cfg{
                    condition = Condition
                } = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade),
                {is_legend, IsLeg} = lists:keyfind(is_legend, 1, Condition),
                {point, Point} = lists:keyfind(point, 1, Condition),
                if
                    SumPoint < Point -> Item;
                    true ->
                        if
                            IsLeg == ?IS_LEGEND andalso IsLegend == ?NOT_LEGEND -> Item;
                            true -> {Grade, ?CAN_GET}
                        end
                end
        end
        end,
    NewRewardStatus = lists:map(F, RewardStatus),
    {RoleChallenge#role_challenge{reward_status = NewRewardStatus}, NewRewardStatus == RewardStatus}.


%% ===============================================
%% 推送33234协议  告知客户端任务状态改变
%% ===============================================
push_challenge_status(SubType, RoleId, ChangeList) ->
    ChangeTaskList =
        [begin
             #challenge_item{
                 item_id = ItemId,
                 challenge_type = ChallengeType,
                 grand_num = ProcessNum,
                 is_get = IsGet
             } = ChallengeItem,
             {ItemId, ChallengeType, ProcessNum, IsGet}
         end || ChallengeItem <- ChangeList],
    {ok, BinData} = pt_332:write(33234, [?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, ChangeTaskList]),
    ?PRINT("push_challenge_status ~n", []),
    lib_server_send:send_to_uid(RoleId, BinData).


%% =======================================================
%% 计算未领取的 契约值  活动结束会调用，发放奖励
%% =======================================================
cal_not_get_point(SubType, ChallengeList) ->
    F = fun(#challenge_item{is_get = IsGet, task_id = TaskId}, SumPoint) ->
        case IsGet == ?CAN_GET of
            false -> SumPoint;
            true ->
                case data_contract_challenge:get_cfg(SubType, TaskId) of
                    #base_contract_challenge{point = AddPoint} -> AddPoint + SumPoint;
                    _ -> SumPoint
                end
        end
        end,
    lists:foldl(F, 0, ChallengeList).

%% =======================================================
%% 计算未领取的 每日任务 契约值。任务刷新会调用
%% =======================================================
cal_not_get_daily_point(SubType, ChallengeList) ->
    F = fun(#challenge_item{is_get = IsGet, task_id = TaskId, challenge_type = ChallengeType}, SumPoint) ->
        case IsGet == ?CAN_GET andalso ChallengeType == ?DAILY_TASK of
            false -> SumPoint;
            true ->
                case data_contract_challenge:get_cfg(SubType, TaskId) of
                    #base_contract_challenge{point = AddPoint} -> AddPoint + SumPoint;
                    _ -> SumPoint
                end
        end
        end,
    lists:foldl(F, 0, ChallengeList).

%% =======================================================
%% 合并任务列表
%% @param ChallengeList         原本的任务列表
%% @param DaliyItems            刷新的每日任务
%% =======================================================
merge_challenge_list(ChallengeList, DaliyItems) ->
    F = fun(DaliyItem, ResList) ->
        lists:keystore(DaliyItem#challenge_item.item_id, #challenge_item.item_id, ResList, DaliyItem)
        end,
    lists:foldl(F, ChallengeList, DaliyItems).


create_task_item_params(SubType, RoleId, Item) ->
    #challenge_item{
        item_id = ItemId,
        task_id = TaskId,
        grand_num = GrandNum,
        is_get = IsGet,
        utime = UTime
    } = Item,
    [SubType, RoleId, ItemId, TaskId, GrandNum, IsGet, UTime].


%%=======================================================================
%%  Database Functions
%%=======================================================================
save_act_info(SubType, RoleId, RoleChallenge) ->
    #role_challenge{
        sum_point = SumPoint,
        is_legend = IsLegend,
        reward_status = RewardStatus,
        daily_recharge = DailyRecharge,
        daily_cost = DailyCost
    } = RoleChallenge,
    db:execute(io_lib:format(?SAVE_CONTRACT_ACT_INFO,
        [SubType, RoleId, SumPoint, IsLegend, util:term_to_bitstring(RewardStatus), DailyRecharge, DailyCost])).

save_act_info2(SubType, RoleId, RoleChallenge) ->
    #role_challenge{
        sum_point = SumPoint,
        is_legend = IsLegend,
        reward_status = RewardStatus,
        daily_recharge = DailyRecharge,
        daily_cost = DailyCost
    } = RoleChallenge,
    [SubType, RoleId, SumPoint, IsLegend, util:term_to_bitstring(RewardStatus), DailyRecharge, DailyCost].


save_act_task_item(SubType, RoleId, Item) ->
    #challenge_item{
        item_id = ItemId,
        task_id = TaskId,
        grand_num = GrandNum,
        is_get = IsGet,
        utime = UTime
    } = Item,
    db:execute(io_lib:format(?SAVE_CONTRACT_ACT_TASK_ITEM, [SubType, RoleId, ItemId, TaskId, GrandNum, IsGet, UTime])).

save_act_task_item2(SubType, RoleId, Item) ->
    #challenge_item{
        item_id = ItemId,
        task_id = TaskId,
        grand_num = GrandNum,
        is_get = IsGet,
        utime = UTime
    } = Item,
    [SubType, RoleId, ItemId, TaskId, GrandNum, IsGet, UTime].


save_contract_buff(RoleId, ContractBuff) ->
    #contract_buff{
        effect_time = EffectTime,
        buff_attr = BuffAttr,
        buff_other = BuffOther
    } = ContractBuff,
    db:execute(io_lib:format(?SAVE_ROLE_CONTRACT_BUFF, [RoleId, EffectTime, util:term_to_bitstring(BuffAttr), util:term_to_bitstring(BuffOther)])).
