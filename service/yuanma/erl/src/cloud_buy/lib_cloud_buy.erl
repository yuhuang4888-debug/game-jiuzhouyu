%%-----------------------------------------------------------------------------
%% @Module  :       lib_cloud_buy.erl
%% @Author  :       hyh
%% @Email   :       huyihao@suyougame.com
%% @Created :       2018-03-20
%% @Description:    众仙云购
%%-----------------------------------------------------------------------------

-module(lib_cloud_buy).

-include("cloud_buy.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("language.hrl").
-include("common.hrl").

-export ([
    order_success/6
    ,pay_for_order/6
    ,pay_order_error/3
    ,return_error_order_cost/3
    ,award_result_handler/3
    ,set_cur_award_info/6
    ,set_cur_award_info_1/6
    ,get_order_first_code/1
    ,format_orders_code/1
    % ,get_stage_reward/3
    ,user_login/2
    ]).

user_login(RoleId, CloudBuyDataList) ->
    List = db:get_all(io_lib:format(?sql_select_stage, [RoleId])),
    Fun = fun([_, SubType, OStageReward, BuyTimes, BigAwardId], Acc) ->
        StageReward = util:bitstring_to_term(OStageReward), 
        BuyData = #cloud_buy_status{big_award_id = BigAwardId, subtype = SubType, buy_times = BuyTimes, stage_reward = StageReward},
        lists:keystore(SubType, #cloud_buy_status.subtype, Acc, BuyData)
    end,
    lists:foldl(Fun, CloudBuyDataList, List).

order_success(RoleId, SubType, Order, IfAutoBuy, SelfBuyNum, SubPid) ->
    lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, ?NOT_HAND_OFFLINE, lib_cloud_buy, pay_for_order, 
            [SubType, Order, IfAutoBuy, SelfBuyNum, SubPid]).

pay_for_order(Ps, SubType, Order, IfAutoBuy, SelfBuyNum, SubPid) ->
    #player_status{
        id = RoleId,
        sid = Sid,
        cloud_buy_list = CloudBuyDataList
    } = Ps,
    BuyData = lists:keyfind(SubType, #cloud_buy_status.subtype, CloudBuyDataList),
    #cloud_buy_status{big_award_id = BigAwardId, buy_times = BuyTimes, stage_reward = StageReward} = BuyData,
    #cloud_order{
        big_award_id = BigAwardId,
        count = Count,
        order_id = OrderId
    } = Order,
    % #cloud_award_config{
    %     cost = CostList,
    %     happy_awards = HappyAwardsWeightList
    % } = data_cloud_buy:get(BigAwardId),
    #big_award_cfg{
        cost = CostList, 
        reward_pool = PoolId
    } = data_cloud_buy:get_reward_cfg(BigAwardId),
    {NewHappyAwards, _AwardSendList} = cloud_rand_rewards(Count, SelfBuyNum, PoolId, [], []),
    Funx = fun({_,GT,_}, Acc) ->
        [GT|Acc]
    end,
    Gtypeids = lists:foldl(Funx, [], NewHappyAwards),
    NewCostList = lib_goods_util:goods_object_multiply_by(CostList, Count),
    Node = mod_disperse:get_clusters_node(),
    case lib_goods_api:can_give_goods(Ps, NewHappyAwards) of
        {false, ErrCode} ->
            NewPs1 = Ps,
            gen_server:cast(SubPid, {pay_order_done, Node, RoleId, OrderId, 0, error}),
            lib_server_send:send_to_sid(Sid, pt_331, 33113, [ErrCode, SubType, [], []]),
            NewBuyData = BuyData#cloud_buy_status{
                cur_order = undefined
            };
        true ->
            Result = case IfAutoBuy of
                0 ->
                    lib_goods_api:cost_object_list_with_check(Ps, NewCostList, cloud_buy, "");
                _ ->
                    lib_goods_api:cost_objects_with_auto_buy(Ps, NewCostList, cloud_buy, "")
            end,
            case Result of
                {true, CostPs1} ->
                    gen_server:cast(SubPid, {pay_order_done, Node, RoleId, OrderId, Gtypeids, ok}),
                    {NewStageReward, RtimesList} = calc_stage_reward(StageReward, BuyTimes + Count, RoleId, SubType, BigAwardId),
                    Fun = fun(Rtimes, Acc) ->
                        if
                            Rtimes > 0 ->
                                Reward = data_cloud_buy:get_reward_by_times(Rtimes),
                                Reward++Acc;
                            true ->
                                Acc
                        end
                    end,
                    Rewards = lists:foldl(Fun, [], RtimesList),
                    NewPS = lib_goods_api:send_reward(CostPs1, Rewards, cloud_buy_stage, 0),
                    NewPs1 = lib_goods_api:send_reward(NewPS, NewHappyAwards, cloud_buy_happy, 0),
                    lib_server_send:send_to_sid(Sid, pt_331, 33113, [?SUCCESS, SubType, NewHappyAwards, RtimesList]),
                    NewBuyData = BuyData#cloud_buy_status{
                        cur_order = Order,
                        buy_times = BuyTimes + Count,
                        stage_reward = NewStageReward
                    };
                {true, CostPs1, _RealCostList} ->
                    gen_server:cast(SubPid, {pay_order_done, Node, RoleId, OrderId, Gtypeids, ok}),
                    {NewStageReward, RtimeList} = calc_stage_reward(StageReward, BuyTimes + Count, RoleId, SubType, BigAwardId),
                    Fun = fun(Rtimes, Acc) ->
                        if
                            Rtimes > 0 ->
                                Reward = data_cloud_buy:get_reward_by_times(Rtimes),
                                [Reward|Acc];
                            true ->
                                Acc
                        end
                    end,
                    Rewards = lists:foldl(Fun, [], RtimeList),
                    NewPS = lib_goods_api:send_reward(CostPs1, Rewards, cloud_buy_stage, 0),
                    NewPs1 = lib_goods_api:send_reward(NewPS, NewHappyAwards, cloud_buy_happy, 0),
                    lib_server_send:send_to_sid(Sid, pt_331, 33113, [?SUCCESS, SubType, NewHappyAwards, RtimeList]),
                    NewBuyData = BuyData#cloud_buy_status{
                        cur_order = Order,
                        buy_times = BuyTimes + Count,
                        stage_reward = NewStageReward
                    };
                {false, ErrCode, NewPs1} ->
                    gen_server:cast(SubPid, {pay_order_done, Node, RoleId, OrderId, [], error}),
                    lib_server_send:send_to_sid(Sid, pt_331, 33113, [ErrCode, SubType, [], []]),
                    NewBuyData = BuyData#cloud_buy_status{
                        cur_order = undefined
                    }
            end
    end,
    NewCloudBuyDataList = lists:keyreplace(SubType, #cloud_buy_status.subtype, CloudBuyDataList, NewBuyData),
    NewPs1#player_status{
        cloud_buy_list = NewCloudBuyDataList
    }.

cloud_rand_rewards(0, _SelfBuyNum, _PoolId, NewHappyAwards, AwardSendList) ->
    {NewHappyAwards, AwardSendList};
cloud_rand_rewards(Count, SelfBuyNum, PoolId, NewHappyAwards, AwardSendList) ->
    HappyAwardsWeightList = get_happy_weight_list(PoolId, SelfBuyNum + 1),
    HappyAwardsId = urand:rand_with_weight(HappyAwardsWeightList),
    HappyAwardsCon = data_cloud_buy:get_pool(PoolId, HappyAwardsId),
    case HappyAwardsCon of
        #reward_pool_cfg{reward = HappyAwards} ->
            [{GoodsType, GoodsTypeId, GoodsNum}|_] = HappyAwards,
            % case lists:keyfind(GoodsTypeId, 2, NewHappyAwards) of
            %     false ->
            %         NewHappyAwards1 = [{GoodsType, GoodsTypeId, GoodsNum}|NewHappyAwards];
            %     {_, _, GoodsNum1} ->
            %         NewHappyAwards1 = lists:keyreplace(GoodsTypeId, 2, NewHappyAwards, {GoodsType, GoodsTypeId, GoodsNum1+GoodsNum})
            % end,
            NewHappyAwards1 = [{GoodsType, GoodsTypeId, GoodsNum}|NewHappyAwards],
            AwardSendList1 = AwardSendList;%%客户端需要这种数据[Type, GoodTypeid, num]
            % case lists:keyfind(HappyAwardsId, 1, AwardSendList) of
            %     false ->
            %         AwardSendList1 = [{HappyAwardsId, 1}|AwardSendList];
            %     {_, RewardNum} ->
            %         AwardSendList1 = lists:keyreplace(HappyAwardsId, 1, AwardSendList, {HappyAwardsId, RewardNum+1})
            % end;
        _ ->
            % ?PRINT("HappyAwardsCon:~p,PoolId:~p,HappyAwardsId:~p~n",[HappyAwardsCon,PoolId,HappyAwardsId]),
            NewHappyAwards1 = NewHappyAwards,AwardSendList1 = AwardSendList
    end,
    cloud_rand_rewards(Count-1, SelfBuyNum + 1, PoolId, NewHappyAwards1, AwardSendList1).

pay_order_error(RoleId, SubType, OrderId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, ?MODULE, return_error_order_cost, [SubType, OrderId]).

return_error_order_cost(Ps, SubType, OrderId) ->
    #player_status{
        cloud_buy_list = CloudBuyDataList
    } = Ps,
    Data = lists:keyfind(SubType, #cloud_buy_status.subtype, CloudBuyDataList),
    case Data of
        #cloud_buy_status{cur_order = #cloud_order{order_id = OrderId, big_award_id = BigAwardId, count = Count}} ->
            #big_award_cfg{cost = [{C, T, Num}]} = data_cloud_buy:get_reward_cfg(BigAwardId),
            Return = [{C, T, Num*Count}],
            lib_goods_api:send_reward(Return, cloud_buy_error, Ps),
            NewData = Data#cloud_buy_status{
                cur_order = undefined
            },
            NewCloudBuyDataList = lists:keyreplace(SubType, #cloud_buy_status.subtype, CloudBuyDataList, NewData),
            Ps#player_status{cloud_buy_list = NewCloudBuyDataList};
        _ ->
            Ps
    end.

award_result_handler(BigAwardId, Bunch, LuckyOrderNameList) ->
    Config = data_cloud_buy:get_reward_cfg(BigAwardId),
    spawn(fun () ->
        [begin
            send_reward_mail(RoleId, AwardState, Config, LuckyOrderNameList),
            timer:sleep(1000)
        end|| {RoleId, _AllBuyCount, AwardState} <- Bunch]
    end).

send_reward_mail(RoleId, State, Config, LuckyOrderNameList) ->
    #big_award_cfg{reward = Rewards} = Config,
    SMsg = ulists:list_to_string(LuckyOrderNameList, ","),
    Msg = util:make_sure_binary(SMsg),
    if
        LuckyOrderNameList == [] ->
            Title = ?LAN_MSG(?LAN_TITLE_CLOUD_BUY_NOMAL),
            Content = utext:get(?LAN_CONTENT_CLOUD_BUY_SPECIAL, []),
            AllRewards = [];
        State =:= ?ORDER_STATE_AWARD ->
            Title = ?LAN_MSG(?LAN_TITLE_CLOUD_BUY_LUCKY),
            Content = utext:get(?LAN_CONTENT_CLOUD_BUY_LUCKY, [Msg]),
            AllRewards = Rewards;
        true ->
            Title = ?LAN_MSG(?LAN_TITLE_CLOUD_BUY_NOMAL),
            Content = utext:get(?LAN_CONTENT_CLOUD_BUY_NOMAL, [Msg]),
            AllRewards = []
    end,
    lib_mail_api:send_sys_mail([RoleId], Title, Content, AllRewards).

set_cur_award_info(RoleId, SubType, AwardTime, BigAwardId, Count, IfAutoBuy) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, ?MODULE, set_cur_award_info_1, [SubType, AwardTime, BigAwardId, Count, IfAutoBuy]).

set_cur_award_info_1(PS, SubType, AwardTime, BigAwardId, _Count, _IfAutoBuy) ->
    #player_status{id = RoleId, cloud_buy_list = CloudBuyDataList} = PS,
    CloudBuyStatus =  lists:keyfind(SubType, #cloud_buy_status.subtype, CloudBuyDataList),
    case lists:keyfind(SubType, #cloud_buy_status.subtype, CloudBuyDataList) of
        CloudBuyStatus when is_record(CloudBuyStatus, cloud_buy_status) ->
            #cloud_buy_status{big_award_id = OldBigAwardId} = CloudBuyStatus,
            % ?MYLOG("cloud_buy","OldBigAwardId:~p,BigAwardId:~p~n",[OldBigAwardId,BigAwardId]),
            if
                OldBigAwardId =/= BigAwardId ->
                    NStageReward = util:term_to_string([]), 
                    db:execute(io_lib:format(?sql_replace_stage, [RoleId, SubType, NStageReward, 0, BigAwardId])),
                    lib_server_send:send_to_uid(RoleId, pt_331, 33116, [SubType,[]]),
                    NewCloudStatus = CloudBuyStatus#cloud_buy_status{
                        req_times = 0,
                        big_award_id = BigAwardId,
                        stage_reward = [],
                        buy_times = 0,
                        award_time = AwardTime
                    };
                true ->
                    NewCloudStatus = CloudBuyStatus#cloud_buy_status{
                        req_times = 0,
                        big_award_id = BigAwardId,
                        award_time = AwardTime
                    }
            end;
        _ -> 
            NewCloudStatus = #cloud_buy_status{
                    subtype = SubType,
                    req_times = 0,
                    stage_reward = [],
                    buy_times = 0,
                    big_award_id = BigAwardId,
                    award_time = AwardTime
                }
    end,
    NewCloudBuyDataList = lists:keystore(SubType, #cloud_buy_status.subtype, CloudBuyDataList, NewCloudStatus),
    NewPs = PS#player_status{cloud_buy_list = NewCloudBuyDataList},
    {ok, NewPs}.

get_order_first_code(#cloud_order{order_id = Id, big_award_id = BigAwardId}) ->
    io_lib:format("~-4.16.0B~4.16.0B~8.16.0B", [BigAwardId, 1, Id]).

format_orders_code(Orders) ->
    [pt:write_string(io_lib:format("~-4.16.0B~4.16.0B~8.16.0B", [BigAwardId, I, Id])) || #cloud_order{order_id = Id, count = Count, big_award_id = BigAwardId} <- Orders, I <- lists:seq(1, Count)].

get_happy_weight_list(PoolId, SelfBuyNum) ->
    RewardL = data_cloud_buy:get_pool_reward(PoolId),
    Fun = fun(RewardId, Acc) ->
        case data_cloud_buy:get_pool(PoolId, RewardId) of
            #reward_pool_cfg{begin_times = BeginCount,end_times = EndCount,
                    weight = NorWeight,special_weight = SpecialWeight} ->
                if
                    SelfBuyNum =< EndCount andalso SelfBuyNum >= BeginCount ->
                        Weight = NorWeight + SpecialWeight;
                    true ->
                        Weight = NorWeight
                end,
                [{Weight, RewardId}|Acc];
            _ ->
                Acc
        end
    end,
    HappyAwardsWeightList = lists:foldl(Fun, [], RewardL),
    HappyAwardsWeightList.

%% 计算阶段奖励
calc_stage_reward(StageReward, BuyTimes, RoleId, SubType, BigAwardId) ->
    List = data_cloud_buy:get_all_times(),
    % case lists:member(BuyTimes, List) of
    %     true ->
    %         case lists:keyfind(BuyTimes, 1, StageReward) of
    %             {BuyTimes, _State} -> 
    %                 NewStageReward = StageReward, Rtimes = 0;
    %             _ ->
    %                 NewStage = {BuyTimes, ?STAGE_GETTED},
    %                 % lib_server_send:send_to_uid(RoleId, pt_331, 33116, [SubType,BuyTimes]),
    %                 Rtimes = BuyTimes,
    %                 NewStageReward = lists:keystore(BuyTimes, 1, StageReward, NewStage),
    %                 NStageReward = util:term_to_string(NewStageReward), 
    %                 db:execute(io_lib:format(?sql_replace_stage, [RoleId, SubType, NStageReward, BuyTimes]))
    %         end;
    %     _ ->
    %         Rtimes = 0,
    %         NewStageReward = StageReward
    % end,
    {NewStageReward, Rtimes} = calc_stage_reward_helper(List, BuyTimes, StageReward, RoleId, SubType, BigAwardId),
    {NewStageReward, Rtimes}.

calc_stage_reward_helper(List, BuyTimes, StageReward, RoleId, SubType, BigAwardId) ->
    Fun = fun(CfgNum, {TemStageReward, TemAcc}) ->
        if
            BuyTimes >= CfgNum ->
                case lists:keyfind(CfgNum, 1, TemStageReward) of
                    {CfgNum, _State} -> 
                        {TemStageReward, TemAcc};
                    _ ->
                        NewStage = {CfgNum, ?STAGE_GETTED},
                        % lib_server_send:send_to_uid(RoleId, pt_331, 33116, [SubType,BuyTimes]),
                        NewAcc = [CfgNum|TemAcc],
                        NewStageReward = lists:keystore(CfgNum, 1, TemStageReward, NewStage),
                        NStageReward = util:term_to_string(NewStageReward), 
                        db:execute(io_lib:format(?sql_replace_stage, [RoleId, SubType, NStageReward, BuyTimes, BigAwardId])),
                        {NewStageReward, NewAcc}
                end;
            true ->
                db:execute(io_lib:format(?sql_replace_stage, [RoleId, SubType, util:term_to_string(StageReward), BuyTimes, BigAwardId])),
                {TemStageReward, TemAcc}
        end
    end,
    lists:foldl(Fun, {StageReward, []}, List).

% %% 领取阶段奖励
% get_stage_reward(PS, SubType, GetTimes) ->
%     #player_status{
%         sid = Sid,
%         cloud_buy_list = CloudBuyDataList
%     } = PS,
%     BuyData = lists:keyfind(SubType, #cloud_buy_status.subtype, CloudBuyDataList),
%     #cloud_buy_status{stage_reward = StageReward} = BuyData,
%     case lists:keyfind(GetTimes, 1, StageReward) of
%         {GetTimes, ?STAGE_CAN_GET} ->
%             Rewards = data_cloud_buy:get_reward_by_times(GetTimes),
%             NewPS = lib_goods_api:send_reward(PS, Rewards, cloud_buy_stage, 0),
%             lib_server_send:send_to_sid(Sid, pt_331, 33116, [[{GetTimes, ?STAGE_GETTED}]]),
%             NewStageReward = lists:keystore(GetTimes, 1, StageReward, {GetTimes, ?STAGE_GETTED}),
%             NewData = BuyData#cloud_buy_status{stage_reward = NewStageReward},
%             NewCloudBuyDataList = lists:keystore(SubType, #cloud_buy_status.subtype, CloudBuyDataList, NewData),
%             Code = ?SUCCESS,
%             Player = NewPS#player_status{cloud_buy_list = NewCloudBuyDataList};
%         {GetTimes, ?STAGE_GETTED} ->
%             Code = ?ERRCODE(err331_has_recieved),
%             Player = PS;
%         _ ->
%             Code = ?ERRCODE(err331_can_not_get),
%             Player = PS
%     end,
%     lib_server_send:send_to_sid(Sid, pt_331, 33117, [GetTimes, Code]),
%     Player.