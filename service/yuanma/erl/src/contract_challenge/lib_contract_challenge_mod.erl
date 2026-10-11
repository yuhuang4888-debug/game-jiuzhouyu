%% ---------------------------------------------------------------------------
%% @doc lib_contract_challenge_mod

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/7/29
%% @deprecated      契约挑战进程
%% ---------------------------------------------------------------------------
-module(lib_contract_challenge_mod).

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

%%-export([
%%    send_act_info/3
%%    , send_reward_status/3
%%    , send_reward_list_core/3
%%    , get_point_reward/4
%%    , receive_reward/4
%%    , task_process/5
%%    , flush_daily_task/2
%%]).

-compile([export_all]).

% 发送活动信息
send_act_info(RoleId, SubType, ChallengeStatus) ->
    #challenge_status{flush_time = FlushTime, role_map = RoleMap, open_day = OpenDay, reward_grades = RewardGrades} = ChallengeStatus,
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_contract_challenge, send_contract_buff, []),
    case maps:get(RoleId, RoleMap, false) of
        false ->
            RoleChallenge = lib_contract_challenge_util:init_role_challenge(SubType, OpenDay, RoleId, RewardGrades),
            send_act_info_core(RoleId, SubType, OpenDay, FlushTime, RoleChallenge),
            NewRoleMap = maps:put(RoleId, RoleChallenge, RoleMap),
            ChallengeStatus#challenge_status{role_map = NewRoleMap};
        RoleChallenge ->
            send_act_info_core(RoleId, SubType, OpenDay, FlushTime, RoleChallenge),
            ChallengeStatus
    end.

send_act_info_core(RoleId, SubType, OpenDay, FlushTime, RoleChallenge) ->
    #role_challenge{sum_point = SumPoint, is_legend = IsLegend, challenge_list = ChallengeList} = RoleChallenge,
    F = fun(ChallengeItem, Res) ->
        #challenge_item{
            item_id = ItemId,
            task_id = TaskId,
            grand_num = ProcessNum,
            is_get = IsGet
        } = ChallengeItem,
        #base_contract_challenge{
            task_id = TaskId,
            challenge_type = ChallengeType,
            challenge_name = ChallengeName,
            icon_type = IConType,
            point = Point,
            grand_num = GrandNum,
            jump_id = JumpId,
            open_day = NeedDay
        } = data_contract_challenge:get_cfg(SubType, TaskId),
        Status = ?IF(OpenDay >= NeedDay, ?HAD_OPEN, ?NO_OPEN),
        ResItem = {ItemId, TaskId, ChallengeType, ChallengeName, IConType, Point, GrandNum, JumpId, ProcessNum, IsGet, Status},
        [ResItem|Res]
        end,
    TaskList = lists:foldl(F, [], ChallengeList),
    %?PRINT("TaskList ~p ~n", [TaskList]),
    {ok, BinData} = pt_332:write(33232, [?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, SumPoint, IsLegend, FlushTime, TaskList]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 发送奖励状态
send_reward_status(RoleId, SubType, ChallengeStatus) ->
    #challenge_status{role_map = RoleMap, open_day = OpenDay, reward_grades = RewardGrades} = ChallengeStatus,
    case maps:get(RoleId, RoleMap, false) of
        false ->
            RoleChallenge = lib_contract_challenge_util:init_role_challenge(SubType, OpenDay, RoleId, RewardGrades),
            send_reward_list_core(RoleId, SubType, RoleChallenge),
            NewRoleMap = maps:put(RoleId, RoleChallenge, RoleMap),
            ChallengeStatus#challenge_status{role_map = NewRoleMap};
        RoleChallenge ->
            send_reward_list_core(RoleId, SubType, RoleChallenge),
            ChallengeStatus
    end.

send_reward_list_core(RoleId, SubType, RoleChallenge) ->
    #role_challenge{reward_status = RewardStatus} = RoleChallenge,
    RewardList =
        [begin
             #custom_act_reward_cfg{
                 condition = Condition,
                 name = Name,
                 desc = Desc,
                 format = Format,
                 reward = Reward
             } = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade),
             {Grade, Format, GetStatus, 0, Name, Desc, util:term_to_bitstring(Condition), util:term_to_bitstring(Reward)}
         end ||{Grade, GetStatus} <- RewardStatus],
    {ok, BinData} = pt_331:write(33104, [?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, RewardList]),
%%    ?PRINT("RewardList ~p ~n", [RewardList]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 领取契约点
get_point_reward(RoleId, SubType, ItemId, ChallengeStatus) ->
    #challenge_status{role_map = RoleMap} = ChallengeStatus,
    RoleChallenge = maps:get(RoleId, RoleMap, #role_challenge{}),
    #role_challenge{challenge_list = ChallengeList, sum_point = SumPoint} = RoleChallenge,
%%    ?PRINT("@@@@@@@@@@@@@@@@ ChallengeList ~p ~n",[ChallengeList]),
    case lists:keyfind(ItemId, #challenge_item.item_id, ChallengeList) of
        #challenge_item{is_get = ?CAN_GET, task_id = TaskId} = ChallengeItem ->
            #base_contract_challenge{point = Point} = data_contract_challenge:get_cfg(SubType, TaskId),
            NewItem = ChallengeItem#challenge_item{is_get = ?HAD_GET},
            lib_contract_challenge_util:save_act_task_item(SubType, RoleId, NewItem),
            NewChallengeList = lists:keystore(ItemId, #challenge_item.item_id, ChallengeList, NewItem),
            NewRoleChallengeTmp = RoleChallenge#role_challenge{challenge_list = NewChallengeList, sum_point = SumPoint + Point},
            lib_contract_challenge_util:save_act_info(SubType, RoleId, NewRoleChallengeTmp),
            lib_log_api:log_contract_challenge_point(SubType, RoleId, "", TaskId, SumPoint, SumPoint + Point),
            ?PRINT("==================zhongni beimei ~n ", []),
            {ok, BinData} = pt_332:write(33233, [?SUCCESS, ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, ItemId, SumPoint + Point, NewItem#challenge_item.challenge_type]),
%%            ?PRINT("BinData ~p ~n", [BinData]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {NewRoleChallenge, Flag} = lib_contract_challenge_util:flush_reward_status(SubType, NewRoleChallengeTmp),
            %% 发送奖励状况
            ?IF(Flag,skip,send_reward_list_core(RoleId, SubType, NewRoleChallenge)),
            ChallengeStatus#challenge_status{
                role_map = maps:put(RoleId, NewRoleChallenge, RoleMap)
            };
        _ ->
            ?PRINT("@@@@@@@@@@@@@@@@ no this task or not complete  ~n",[]),
            ChallengeStatus
    end.


%% 领取奖励
receive_reward(RoleId, SubType, Grade, ChallengeStatus) ->
    #challenge_status{role_map = RoleMap} = ChallengeStatus,
    case maps:get(RoleId, RoleMap, false) of
        false ->
            {ok, BinData} = pt_331:write(33105, [?ERRCODE(err331_no_act_reward_cfg), ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade]),
            lib_server_send:send_to_uid(RoleId, BinData), ChallengeStatus;
        RoleChallenge ->
            #role_challenge{reward_status = RewardStatus} = RoleChallenge,
            case lists:keyfind(Grade, 1, RewardStatus) of
                false ->
                    {ok, BinData} = pt_331:write(33105, [?ERRCODE(err331_no_act_reward_cfg), ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade]),
                    lib_server_send:send_to_uid(RoleId, BinData), ChallengeStatus;
                {_, ?NO_GET} ->
                    {ok, BinData} = pt_331:write(33105, [?ERRCODE(err331_act_can_not_get), ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade]),
                    lib_server_send:send_to_uid(RoleId, BinData), ChallengeStatus;
                {_, ?HAD_GET} ->
                    {ok, BinData} = pt_331:write(33105, [?ERRCODE(err331_already_get_reward), ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade]),
                    lib_server_send:send_to_uid(RoleId, BinData), ChallengeStatus;
                {_, ?CAN_GET} ->
                    ?PRINT("ok get reward ~n", []),
                    NewRewardStatus = lists:keystore(Grade, 1, RewardStatus, {Grade, ?HAD_GET}),
                    NewRoleChallenge = RoleChallenge#role_challenge{reward_status = NewRewardStatus},
                    lib_contract_challenge_util:save_act_info(SubType, RoleId, NewRoleChallenge),
                    #custom_act_reward_cfg{
                        reward = Reward
                    } = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade),
                    lib_goods_api:send_reward_by_id(Reward, contract_challenge, RoleId),
                    {ok, BinData} = pt_331:write(33105, [?SUCCESS, ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    lib_log_api:log_custom_act_reward(RoleId, ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType, Grade, Reward),
                    NewRoleMap = maps:put(RoleId, NewRoleChallenge, RoleMap),
                    ChallengeStatus#challenge_status{role_map = NewRoleMap}
            end
    end.

%% 完成任务触发
task_process(RoleId, Module, SubModule, Count, State) ->
    F = fun(SubType, ChallengeStatus) ->
        #challenge_status{role_map = RoleMap, open_day = OpenDay, reward_grades = RewardGrades} = ChallengeStatus,
        ChallengeRole = case maps:get(RoleId, RoleMap, false) of
                            false -> lib_contract_challenge_util:init_role_challenge(SubType, OpenDay, RoleId, RewardGrades);
                            Return -> Return
                        end,
        case task_process_done(SubType, RoleId, ChallengeRole, Module, SubModule, Count) of
            noreplay ->
                ChallengeStatus;
            NewChallengeRole ->
                lib_contract_challenge_util:save_act_info(SubType, RoleId, NewChallengeRole),
                NewRoleMap = maps:put(RoleId, NewChallengeRole, RoleMap),
                ChallengeStatus#challenge_status{role_map = NewRoleMap}
        end
        end,
    maps:map(F, State).

%% 累计消费/充值 n 天特殊处理
task_process_done(SubType, RoleId, ChallengeRole, Module, SubModule, Count) when Module == ?MOD_RECHARGE orelse Module == ?CONTRACT_COST ->
    #role_challenge{daily_recharge = OldRecharge, daily_cost = OldCost, challenge_list = ChallengeList} = ChallengeRole,
    OldJudgeVal = ?IF(Module == ?MOD_RECHARGE, OldRecharge, OldCost),
    NewJudgeVal = OldJudgeVal + Count,
    %% 过滤
    NeedChangeList = lists:filter(
        fun(Item) ->
            #challenge_item{module = Mod, sub_module = SubMod} = Item ,
            Mod == Module  andalso SubMod == SubModule
        end, ChallengeList),
    Now = utime:unixtime(),
    F = fun(ChangeItem, {ResList, GrandParams}) ->
        #challenge_item{task_id = TaskId, grand_num = GrandNum, utime = UTime, is_get = OGet} = ChangeItem,
        #base_contract_challenge{grand_num = NeedNum, special_value = SpecialVal} = data_contract_challenge:get_cfg(SubType, TaskId),
        case OGet of
            ?NO_GET ->
                case NewJudgeVal >= SpecialVal of
                    false -> NChangeItem =ChangeItem#challenge_item{is_get = ?NO_GET, grand_num = GrandNum};
                    true ->
                        case utime:is_same_day(UTime, Now) of
                            true -> NChangeItem =ChangeItem#challenge_item{is_get = ?NO_GET, grand_num = GrandNum};
                            false ->
                                NewGrandNum = GrandNum + 1,
                                IsGet = ?IF(NewGrandNum >= NeedNum, ?CAN_GET, ?NO_GET),
                                lib_log_api:log_contract_challenge_task(SubType, RoleId, "", TaskId, NewGrandNum),
                                NChangeItem =ChangeItem#challenge_item{is_get = IsGet, grand_num = NewGrandNum, utime = Now}
                        end
                end;
            _ ->
                case NewJudgeVal >= SpecialVal of
                    false -> NChangeItem =ChangeItem#challenge_item{grand_num = GrandNum};
                    true ->
                        case utime:is_same_day(UTime, Now) of
                            true -> NChangeItem =ChangeItem#challenge_item{grand_num = GrandNum};
                            false ->
                                NewGrandNum = GrandNum + 1,
                                NChangeItem =ChangeItem#challenge_item{grand_num = NewGrandNum, utime = Now}
                        end
                end
        end,
        ParamKv = lib_contract_challenge_util:create_task_item_params(SubType, RoleId, NChangeItem),
        NewGrandParams = [ParamKv|GrandParams],
        NewResList = lists:keystore(NChangeItem#challenge_item.item_id, #challenge_item.item_id, ResList, NChangeItem),
        {NewResList, NewGrandParams}
        end,
    {ChangeList, ChangeItemKv} = lists:foldl(F,{NeedChangeList, []}, NeedChangeList),
    Sql = usql:replace(contract_challenge_act_item, [sub_type, role_id, item_id, task_id, grand_num, is_get, utime], ChangeItemKv),
    Sql =/= [] andalso db:execute(Sql),
    lib_contract_challenge_util:push_challenge_status(SubType, RoleId, ChangeList),
    F2 = fun(ChangeItem, ResList) ->
        lists:keystore(ChangeItem#challenge_item.item_id, #challenge_item.item_id, ResList, ChangeItem)
         end,
    NewChallengeList = lists:foldl(F2, ChallengeList, ChangeList),
    ?IF(Module == ?MOD_RECHARGE,
        ChallengeRole#role_challenge{challenge_list = NewChallengeList, daily_recharge = NewJudgeVal},
        ChallengeRole#role_challenge{challenge_list = NewChallengeList, daily_cost = NewJudgeVal});

task_process_done(SubType, RoleId, ChallengeRole, Module, SubModule, Count) ->
    #role_challenge{challenge_list = ChallengeList} = ChallengeRole,
    %% 过滤已经完成的和符合的任务
    NeedChangeList = lists:filter(
        fun(Item) ->
            #challenge_item{module = Mod, sub_module = SubMod} = Item ,
            Mod == Module  andalso SubMod == SubModule
        end, ChallengeList),
    case NeedChangeList of
        [] -> noreplay;
        _ ->
            Now = utime:unixtime(),
            ChangeList = task_process_done_core(SubType, RoleId, NeedChangeList, Count, Now, [], []),
            lib_contract_challenge_util:push_challenge_status(SubType, RoleId, ChangeList),
            F = fun(ChangeItem, ResList) ->
                lists:keystore(ChangeItem#challenge_item.item_id, #challenge_item.item_id, ResList, ChangeItem)
                end,
            NewChallengeList = lists:foldl(F, ChallengeList, ChangeList),
            ChallengeRole#role_challenge{challenge_list = NewChallengeList}
    end.

%%%% ==================================================================
%%%% 完成任务如果完成度超过了需求值                              %
%%%% 但是同时有两个同类型的任务会两个任务的进度都会添加           % 弃用
%%%% return [#challenge_item{}|_]                              %
%%%% ==================================================================
%%task_process_done_core(_SubType, _RoleId, [], _Count, Res) -> Res;
%%task_process_done_core(SubType, RoleId, [ChallengeItem|T], Count, Res) ->
%%    #challenge_item{task_id = TaskId, grand_num = OldNum} = ChallengeItem,
%%    #base_contract_challenge{grand_num = NeedNum} = data_contract_challenge:get_cfg(SubType, TaskId),
%%    NewNum = OldNum ++ Count,
%%    case NewNum >= NeedNum of
%%        false ->
%%            NewChallengeItem = ChallengeItem#challenge_item{grand_num = NewNum},
%%            push_challenge_status(SubType, RoleId, NewChallengeItem),
%%            [NewChallengeItem | T] ++ Res;
%%        true ->
%%            NewChallengeItem = ChallengeItem#challenge_item{grand_num = NeedNum, is_get = ?CAN_GET},
%%            push_challenge_status(SubType, RoleId, NewChallengeItem),
%%            task_process_done_core(SubType, RoleId, T, NewNum - NeedNum, [NewChallengeItem|Res])
%%    end.
task_process_done_core(_SubType, _RoleId, [], _Count, _UTime, Res, ChangeParamKv) ->
    Sql = usql:replace(contract_challenge_act_item, [sub_type, role_id, item_id, task_id, grand_num, is_get, utime], ChangeParamKv),
    Sql =/= [] andalso db:execute(Sql),
    Res;
task_process_done_core(SubType, RoleId, [ChallengeItem|T], Count, UTime, Res, ChangeParamKv) ->
    #challenge_item{task_id = TaskId, grand_num = OldNum} = ChallengeItem,
    #base_contract_challenge{grand_num = NeedNum} = data_contract_challenge:get_cfg(SubType, TaskId),
    NewNum = OldNum + Count,
    NewChallengeItem =
        case NewNum >= NeedNum of
            false -> ChallengeItem#challenge_item{grand_num = NewNum, utime = UTime};
            true ->
                #challenge_item{is_get = OGet} = ChallengeItem,
                IsGet = ?IF(OGet == ?NO_GET, ?CAN_GET, OGet),
                ChallengeItem#challenge_item{grand_num = NewNum, is_get = IsGet, utime = UTime}
        end,
    ParamKv = lib_contract_challenge_util:create_task_item_params(SubType, RoleId, NewChallengeItem),
    lib_log_api:log_contract_challenge_task(SubType, RoleId, "", TaskId, NewNum),
    task_process_done_core(SubType, RoleId, T, Count, UTime, [NewChallengeItem|Res], [ParamKv|ChangeParamKv]).


%% 刷新日常任务和解锁累计任务
flush_daily_task(SubType, ChallengeStatus) ->
    #challenge_status{role_map = RoleMap} = ChallengeStatus,
    {OpenDay, FlushTime} = mod_contract_challenge:get_open_day_and_flush_time(SubType),
    OnlineList = ets:tab2list(?ETS_ONLINE),
    F = fun(RoleId, RoleChallenge, {GrandParam, GrandMap}) ->
        #role_challenge{challenge_list = ChallengeList, sum_point = SumPoint} = RoleChallenge,
        NewGetPoint = lib_contract_challenge_util:cal_not_get_daily_point(SubType, ChallengeList),
        %% 刷新每日任务
        DaliyItems = lib_contract_challenge_util:init_daily_challenge_list(SubType, OpenDay, RoleId),
        %% 解锁新的累计任务
        %% UnLockChallengeList = unlock_grand_challenge_list(SubType, OpenDay, RoleId, ChallengeList),
        NewChallengeList = lib_contract_challenge_util:merge_challenge_list(ChallengeList, DaliyItems),
        NewRoleChallenge = RoleChallenge#role_challenge{challenge_list = NewChallengeList, sum_point = SumPoint + NewGetPoint},
        NParam = lib_contract_challenge_util:save_act_info2(SubType, RoleId, NewRoleChallenge),
        %% 判断用户是否在线，在线推送新的任务
        case lists:keyfind(RoleId, #ets_online.id, OnlineList) of
            false -> skip;
            _ ->
                send_act_info_core(RoleId, SubType, OpenDay, FlushTime, NewRoleChallenge)
        end,
        NewGrandMap = maps:put(RoleId, NewRoleChallenge, GrandMap),
        {[NParam|GrandParam], NewGrandMap}
        end,
    {ReplaceParams, NewRoleMap} = maps:fold(F, {[], RoleMap}, RoleMap),
    Sql = usql:replace(contract_challenge_act, [sub_type, role_id, sum_point, is_legend, reward_status, daily_recharge, daily_cost], ReplaceParams),
    ?IF(Sql =/= [], db:execute(Sql), skip),
    ChallengeStatus#challenge_status{open_day = OpenDay, flush_time = FlushTime, role_map = NewRoleMap}.
