%%-----------------------------------------------------------------------------
%% @Module  :       mod_cloud_buy.erl
%% @Author  :       hyh
%% @Email   :       huyihao@suyougame.com
%% @Created :       2018-03-20
%% @Description:    众仙云购
%%-----------------------------------------------------------------------------

-module(mod_cloud_buy).

-include("common.hrl").
-include("custom_act.hrl").
-include("cloud_buy.hrl").
-include("vip.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("mail.hrl").
-include("language.hrl").

-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export([
    start_link/1
]).
%% define
-define (SERVER, ?MODULE).

%% API
start_link(SubType) ->
    gen_server:start_link(?SERVER, [SubType], []).

%% private
init([SubType]) ->
    State = do_init(SubType),
    {ok, State}.

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {'EXIT', Error} ->
            ?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
            {reply, error, State};
        Return  ->
            Return
    end.

handle_cast(Msg, State) ->
    #cloud_buy_kf_state{
        custom_act_subtype = ActType
    } = State,
    case ActType > 0 of
        true ->
            case catch do_handle_cast(Msg, State) of
                {'EXIT', Error} ->
                    ?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
                    {noreply, State};
                Return  ->
                    % ?PRINT("Return:~p~n",[Return]),
                    Return
            end;
        false ->
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', Error} ->
            ?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
            {noreply, State};
        Return  ->
            % ?PRINT("Return:~p~n",[Return]),
            Return
    end.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

do_handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

do_handle_cast({order, Args}, State) ->
    [Node, PlatForm, Server, RoleId, RoleName, Sid, Count, VipLv, VipType, IfAutoBuy] = Args,
    #cloud_buy_kf_state{
        custom_act_subtype = SubType,
        unfinished_orders = UnFinishedOrders, 
        done_orders = DoneOrders, 
        big_award_id = BigAwardId,
        clear_unfinished_ref = ClearRef,
        unlimited_time = UnlimitedTime,
        award_time = AwardTime,
        cur_count = CurCount,
        cloud_end_flag = CFlag
    } = State,
    {Code, Order, NewState}
    = case data_cloud_buy:get_reward_cfg(BigAwardId) of
        #big_award_cfg{num = TotalCount} ->
            if
                CFlag =/= 1 ->
                    if
                        Count + CurCount =< TotalCount ->
                            case lists:keyfind(RoleId, #cloud_order.customer_uid, UnFinishedOrders) of
                                false ->
                                    Now = utime:unixtime(),
                                    % ?PRINT("CurCount:~p,UnlimitedTime:~p,Now:~p~n",[CurCount,UnlimitedTime,Now]),
                                    case Now > UnlimitedTime orelse check_personal_count_limit(BigAwardId, SubType, DoneOrders, RoleId, VipLv, VipType, Count) of
                                        true ->
                                            case catch create_a_order(BigAwardId, RoleId, RoleName, PlatForm, Server, Count, Now, SubType, AwardTime, 0) of
                                                {ok, O} ->
                                                    NewUnFinishedOrders = [O|UnFinishedOrders],
                                                    NewCurCount = CurCount + Count,
                                                    NewClearRef
                                                    = if
                                                        is_reference(ClearRef) ->
                                                            ClearRef;
                                                        true ->
                                                            make_clear_ref(NewUnFinishedOrders, Now)
                                                    end,
                                                    State1 = State#cloud_buy_kf_state{unfinished_orders = NewUnFinishedOrders, cur_count = NewCurCount, clear_unfinished_ref = NewClearRef},
                                                    {ok, O, State1};
                                                _ ->
                                                    {?FAIL, [], State}
                                            end;
                                        _ ->
                                            {?ERRCODE(err331_cloud_buy_personal_limit), [], State}
                                    end;
                                _ ->
                                    {?ERRCODE(err331_cloud_buy_order_unfinished), [], State}
                            end;
                        true ->
                            {?ERRCODE(err331_cloud_buy_not_enough), [], State}
                    end;
                true ->
                    {?ERRCODE(err331_cloud_buy_not_ennough), [], State}
            end;
        _ ->
            {?FAIL, [], State}
    end,
    if
        Code =/= ok ->
            unode:apply(Node, lib_server_send, send_to_sid, [Sid, pt_331, 33113, [Code, SubType, [], []]]);
        true ->
            SelfBuyNum = get_self_buy_num(DoneOrders, RoleId),
            unode:apply(Node, lib_cloud_buy, order_success, [RoleId, SubType, Order, IfAutoBuy, SelfBuyNum, self()])
    end,
    {noreply, NewState};

do_handle_cast({pay_order_done, Node, RoleId, OrderId, GtypeIds, Res}, State) ->
    #cloud_buy_kf_state{
        custom_act_subtype = SubType,
        unfinished_orders = UnFinishedOrders,
        done_orders = DoneOrders, cur_count = CurCount,
        big_award_id = BigAwardId, join_num = JoinNum
    } = State,
    case lists:keytake(OrderId, #cloud_order.order_id, UnFinishedOrders) of
        {value, Order, OthersList} ->
            if
                Res =:= ok ->
                    NewCurCount = CurCount,
                    DoneOrder = Order#cloud_order{state = ?ORDER_STATE_PAID, goods_type_id = GtypeIds},
                    spawn(fun () ->log_order_done(SubType, DoneOrder) end),
                    erlang:send_after(100, self(), {updata_joinnum, Node}),
                    % NewBuyNum = get_role_buynum([DoneOrder], RoleBuyNum),
                    NewDoneOrders = [DoneOrder|DoneOrders];
                true ->
                    NewCurCount = CurCount - Order#cloud_order.count,
                    DoneOrder = Order#cloud_order{state = ?ORDER_STATE_FAIL},
                    % NewBuyNum = RoleBuyNum,
                    NewDoneOrders = DoneOrders
            end,
            save_order(DoneOrder),
            NewState = State#cloud_buy_kf_state{unfinished_orders = OthersList, done_orders = NewDoneOrders, 
                cur_count = NewCurCount, join_num = JoinNum},
            #big_award_cfg{num = TotalCount} = data_cloud_buy:get_reward_cfg(BigAwardId),
            if
                NewCurCount >= TotalCount ->
                    erlang:send_after(1000, self(), award),
                    erlang:send_after(2500, self(), {updata_joinnum, Node}),
                    {noreply, NewState};
                true ->
                    {noreply, NewState}
            end;
        _ ->
            if
                Res =:= ok ->
                    unode:apply(Node, lib_cloud_buy, pay_order_error, [RoleId, SubType, OrderId]);
                true ->
                    skip 
            end,
            {noreply, State}
    end;

do_handle_cast({get_last_lucky_orders, Node, Sid}, State) ->
    #cloud_buy_kf_state{
        custom_act_subtype = SubType,
        last_lucky_orders = LastLuckyOrders
        % last_big_award_id = BigAwardId
    } = State,
    LastLuckyOrdersSendList = [begin
        {BigAwardId, Time, Platform, Server, util:make_sure_binary(RoleName), RoleUnique, Count}
    end || #cloud_order{big_award_id = BigAwardId, time = Time, platform = Platform, server = Server, customer_name = RoleName, 
            customer_uid = RoleUnique, count = Count} <- LastLuckyOrders],
    % ?PRINT("LastLuckyOrders:~p~n",[LastLuckyOrders]),
    {ok, BinData} = pt_331:write(33114, [SubType, LastLuckyOrdersSendList]),
    unode:apply(Node, lib_server_send, send_to_sid, [Sid, BinData]),
    {noreply, State};

do_handle_cast({get_info, Node, RoleId, Sid, VipLv, VipType, StageReward}, State) ->
    #cloud_buy_kf_state{
        custom_act_subtype = SubType,
        done_orders = Orders, 
        award_time = AwardTime, 
        cur_count = CurCount,
        unlimited_time = UnlimitedTime,
        big_award_id = BigAwardId,
        join_num = JoinNum,
        order_record = OrderRecord
    } = State,
    VipLvCount = lib_vip_api:get_vip_privilege(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_CLOUD_BUY, VipType, VipLv),
    {award_time,[Hour,Minute]} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, award_time),
    NowTime = utime:unixtime(),
    NowDate = utime:unixdate(),
    ConAwardTime = Hour*60*60 + Minute*60,
    case (NowTime-NowDate) >= ConAwardTime of
        true ->
            BeforeAwardTime = NowDate + ConAwardTime,
            NextAwardTime = NowDate + 24*60*60 + ConAwardTime;
        false ->
            BeforeAwardTime = max(0, (NowDate - (24*60*60 - ConAwardTime))),
            NextAwardTime = NowDate + ConAwardTime
    end,
    F = fun(O, {SelfBuyNum1, TodayBuyNum1}) ->
        #cloud_order{
            customer_uid = CustomerUid,
            count = Count,
            time = OrderTime
        } = O,
        case CustomerUid of
            RoleId ->
                SelfBuyNum2 = SelfBuyNum1 + Count,
                case OrderTime >= BeforeAwardTime andalso OrderTime < NextAwardTime of
                    true ->
                        TodayBuyNum2 = TodayBuyNum1 + Count;
                    false ->
                        TodayBuyNum2 = TodayBuyNum1
                end;
            _ ->
                SelfBuyNum2 = SelfBuyNum1,
                TodayBuyNum2 = TodayBuyNum1
        end,
        {SelfBuyNum2, TodayBuyNum2}
    end,
    {SelfBuyNum, TodayBuyNum} = lists:foldl(F, {0, 0}, Orders),
    {unlimited_time,[UnlimitedHour, UnlimitedMinute]} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, unlimited_time),
    TodayUnlimitedTime = NowDate + UnlimitedHour*60*60 + UnlimitedMinute*60,
    TodayAwardTime = NowDate + ConAwardTime,
    #big_award_cfg{num = TotalCount} = data_cloud_buy:get_reward_cfg(BigAwardId),
    AllLessBuyNum = max(0, (TotalCount - CurCount)),
    case NowTime >= TodayUnlimitedTime andalso NowTime < TodayAwardTime of
        true ->
            LessBuyNum = AllLessBuyNum;
        false ->
            SelfLessBuyNum = max(0, (VipLvCount - TodayBuyNum)),
            case AllLessBuyNum < SelfLessBuyNum of
                true ->
                    LessBuyNum = AllLessBuyNum;
                false ->
                    LessBuyNum = SelfLessBuyNum
            end
    end,
    OrderRecs = lists:sublist(Orders, 10),
    Length = erlang:length(OrderRecs),
    if
        Length < 10 ->
            NewRec = OrderRecs ++ OrderRecord,
            NewOrderRecs = lists:sublist(NewRec, 10);
        true ->
            NewOrderRecs = OrderRecs
    end,
    OrderSendList =[begin
        #cloud_order{
            platform = Platform,
            server = Server,
            customer_name = RoleName,
            count = Count,
            goods_type_id = GtypeIds,
            time = OrderTime
        } = O,
        {Platform, Server, RoleName, GtypeIds, Count, OrderTime}
    end||O <- NewOrderRecs],
    {if_kf, IfKf} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, if_kf),
    {ok, BinData} = pt_331:write(33112, [?SUCCESS, SubType, IfKf, AwardTime, UnlimitedTime, 
        CurCount, BigAwardId, OrderSendList, StageReward, SelfBuyNum, LessBuyNum, JoinNum]),
    % ?PRINT("LessBuyNum:~p,BigAwardId:~p~n",[LessBuyNum,BigAwardId]),
    unode:apply(Node, lib_server_send, send_to_sid, [Sid, BinData]),
    unode:apply(Node, lib_cloud_buy, set_cur_award_info, [RoleId, SubType, AwardTime, BigAwardId, 0, 0]),
    {noreply, State};

do_handle_cast({get_cur_award_info, Node, RoleId, Count, IfAutoBuy}, State) ->
    #cloud_buy_kf_state{
        custom_act_subtype = SubType,
        award_time = AwardTime,
        big_award_id = BigAwardId
    } = State,
    unode:apply(Node, lib_cloud_buy, set_cur_award_info, [RoleId, SubType, AwardTime, BigAwardId, Count, IfAutoBuy]),
    {noreply, State};

do_handle_cast({close}, State) ->
    #cloud_buy_kf_state{
        custom_act_subtype = SubType,
        start_time = StartTime,
        award_open_ref = AwardOpenRef,
        unlimited_ref = UnlimitedRef,
        clear_unfinished_ref = ClearRef
    } = State,
    util:cancel_timer(AwardOpenRef),
    util:cancel_timer(UnlimitedRef),
    util:cancel_timer(ClearRef),
    if
        StartTime > 0 ->
            db:execute(io_lib:format("DELETE FROM `cloud_buy_kf` WHERE `subtype` = ~p", [SubType]));
        true ->
            skip
    end,
    {stop, normal, State};

do_handle_cast({gm_award}, State) ->
    #cloud_buy_kf_state{
        custom_act_subtype = SubType,
        done_orders = DoneOrders,
        big_award_id = BigAwardId,
        cur_count = _CurCount,
        award_time = AwardTime,
        last_lucky_orders = OldLuckyOrders,
        award_open_ref = AwardOpenRef,
        unlimited_ref = UnlimitedRef,
        last_award_time = LastAwardTime
    } = State,
    util:cancel_timer(AwardOpenRef),
    util:cancel_timer(UnlimitedRef),
    #big_award_cfg{num = _TotalCount, award_num = AwardCount} = data_cloud_buy:get_reward_cfg(BigAwardId),
    % if
    %     CurCount >= TotalCount ->
    %         LuckyOrders = handle_awards(DoneOrders, AwardCount, AwardTime, BigAwardId, SubType),
    %         case util:is_cls() of
    %             true ->
    %                 mod_clusters_center:apply_to_all_node(mod_cloud_buy_local, send_award_tv, [LuckyOrders, SubType], 50);
    %             false ->
    %                 mod_cloud_buy_local:send_award_tv(LuckyOrders, SubType)
    %         end;
    %     true ->
    %         LuckyOrders = handle_awards(DoneOrders, 0, AwardTime, BigAwardId, SubType)
    % end,
    LuckyOrders = handle_awards(DoneOrders, AwardCount, AwardTime, BigAwardId, SubType, LastAwardTime),
    case util:is_cls() of
        true ->
            mod_clusters_center:apply_to_all_node(mod_cloud_buy_local, send_award_tv, [LuckyOrders, SubType], 50);
        false ->
            mod_cloud_buy_local:send_award_tv(LuckyOrders, SubType)
    end,
    NewState = State#cloud_buy_kf_state{
        done_orders = [],
        unfinished_orders = [],
        last_lucky_orders = OldLuckyOrders ++ LuckyOrders,
        last_big_award_id = BigAwardId,
        award_open_ref = [],
        unlimited_ref = [],
        end_time = 0
    },
    do_handle_cast({close}, NewState);

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info({gm_restart}, State) ->
    #cloud_buy_kf_state{
            big_award_id = BigAwardId,
            custom_act_type = Type,
            custom_act_subtype = SubType} = State,
    NextBigAwardId = get_next_big_award_id(Type, SubType, BigAwardId),
    NewState = State#cloud_buy_kf_state{
                done_orders = [], 
                cur_count = 0, 
                cloud_end_flag = 0,
                big_award_id = NextBigAwardId
            },
    {noreply, NewState};

do_handle_info({restart}, State) ->
    #cloud_buy_kf_state{
            big_award_id = BigAwardId,
            custom_act_type = Type,
            custom_act_subtype = SubType} = State,
    NextBigAwardId = get_next_big_award_id(Type, SubType, BigAwardId),
    NewState = State#cloud_buy_kf_state{
                done_orders = [], 
                cur_count = 0, 
                cloud_end_flag = 0,
                big_award_id = NextBigAwardId
            },
    IsOpen = lib_custom_act_api:is_open_act(Type, SubType), 
    if
        IsOpen == true ->
            spawn(fun() -> timer:sleep(5000), 
                mod_cloud_buy_local:send_open_tv(SubType)
                % Title = ?LAN_MSG(?LAN_TITLE_CLOUD_BUY_START_SALE),
                % Content = utext:get(?LAN_CONTENT_CLOUD_BUY_START_SALE, []),
                % AllRewards = "[]",
                % CloudOpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_CLOUD_BUY),%% 120
                % lib_mail_api:send_sys_mail_to_all(Title, Content, AllRewards, [], CloudOpenLv, ?SEND_LOG_TYPE_YES) 
                end);
        true ->
            skip
    end,
    % ?PRINT("$#$#$@#@$@$@$@#$@#,NextBigAwardId:~p,~p~n",[BigAwardId,NextBigAwardId]),
    {noreply, NewState};

do_handle_info({updata_joinnum, Node}, State) ->
    #cloud_buy_kf_state{done_orders = DoneOrders, join_num = _JoinNum} = State,
    Fun = fun(#cloud_order{customer_uid = UserId}, Acc) ->
        [UserId|Acc]
    end,
    UserIdList = lists:foldl(Fun, [], DoneOrders),
    NewUserIdList = ulists:removal_duplicate(UserIdList),
    lists:foreach(fun(RoleId) -> 
        {ok, BinData} = pt_331:write(33185, [1]),
        unode:apply(Node, lib_server_send, send_to_uid, [RoleId, BinData]) end, NewUserIdList),
    NewJoinNum = erlang:length(NewUserIdList),
    NewState = State#cloud_buy_kf_state{join_num = NewJoinNum},
    {noreply, NewState};

do_handle_info(clear_unfinished, State) ->
    #cloud_buy_kf_state{unfinished_orders = UnFinishedOrders, cur_count = CurCount} = State,
    Now = utime:unixtime(),
    {TimeoutOrders, NewUnFinishedOrders} = lists:partition(fun
        (#cloud_order{time = Time}) ->
            Time + 60 =< Now
    end, UnFinishedOrders),
    NewClearRef = make_clear_ref(NewUnFinishedOrders, Now),
    {noreply, State#cloud_buy_kf_state{unfinished_orders = NewUnFinishedOrders, clear_unfinished_ref = NewClearRef, cur_count = CurCount - calc_order_count(TimeoutOrders)}};

do_handle_info(unlimited_open, State) ->
    #cloud_buy_kf_state{
        custom_act_subtype = SubType
    } = State,
    case util:is_cls() of
        true ->
            mod_clusters_center:apply_to_all_node(mod_cloud_buy_local, send_unlimited_tv, [SubType], 50);
        false ->
            mod_cloud_buy_local:send_unlimited_tv(SubType)
    end,
    {noreply, State};
 
%% 一天两次
% do_handle_info(award, State) ->
%     #cloud_buy_kf_state{
%         custom_act_type = Type,
%         custom_act_subtype = SubType,
%         done_orders = DoneOrders, 
%         big_award_id = BigAwardId, 
%         cur_count = CurCount,
%         award_time = AwardTime,
%         last_lucky_orders = OldLuckyOrders,
%         award_open_ref = AwardOpenRef,
%         unlimited_time = UnlimitedTime,
%         unlimited_ref = UnlimitedRef,
%         end_time = EndTime,
%         last_award_time = LastAwardTime
%     } = State,
%     NowDate = utime:unixdate(),
%     NowTime = utime:unixtime(),
%     NextAwardTime = AwardTime + 86400,
%     NextUnlimitedTime = UnlimitedTime + 86400,
%     #big_award_cfg{num = TotalCount, award_num = AwardCount} = data_cloud_buy:get_reward_cfg(BigAwardId),
%     if
%         CurCount >= TotalCount orelse NowTime >= AwardTime -> 
%             LuckyOrders = handle_awards(DoneOrders, AwardCount, AwardTime, BigAwardId, SubType, LastAwardTime),
%             NextBigAwardId = get_next_big_award_id(Type, SubType, BigAwardId),
%             case lib_custom_act_util:keyfind_act_condition(Type, SubType, big_award_ids) of
%                 {big_award_ids, Ids} -> ok;
%                 _ -> Ids = data_cloud_buy:get_all_big_award()
%             end,
%             [FirstBigId|_] = Ids,        
%             if   %%一天2次大奖，
%                 NextBigAwardId =/= FirstBigId -> %% 开奖时间未过，当天云购大奖没有卖完
%                     if
%                         NowTime >= UnlimitedTime andalso NowTime =< AwardTime ->
%                             RealAwardTime = AwardTime,
%                             AwardOpenRef1 = util:send_after(AwardOpenRef, max(1 ,AwardTime - NowTime) * 1000, self(), award),
%                             UnlimitedRef1 = util:send_after(UnlimitedRef, 500, self(), unlimited_open);
%                         NowTime < UnlimitedTime ->
%                             RealAwardTime = AwardTime,
%                             AwardOpenRef1 = util:send_after(AwardOpenRef, max(1 ,AwardTime - NowTime) * 1000, self(), award),
%                             UnlimitedRef1 = util:send_after(UnlimitedRef, (UnlimitedTime - NowTime) * 1000, self(), unlimited_open);
%                         NextAwardTime > EndTime ->
%                             RealAwardTime = 0,
%                             AwardOpenRef1 = undefined,
%                             UnlimitedRef1 = undefined;
%                         true ->
%                             RealAwardTime = AwardTime,
%                             AwardOpenRef1 = util:send_after(AwardOpenRef, (NextAwardTime - NowTime) * 1000, self(), award),
%                             UnlimitedRef1 = util:send_after(UnlimitedRef, (NextUnlimitedTime - NowTime) * 1000, self(), unlimited_open)
%                     end,
%                     if
%                         NowTime >= RealAwardTime ->
%                             skip;
%                         true ->
%                             spawn(fun() -> timer:sleep(1000),
%                                 mod_cloud_buy_local:send_open_tv(SubType)
%                                 % Title = ?LAN_MSG(?LAN_TITLE_CLOUD_BUY_START_SALE),
%                                 % Content = utext:get(?LAN_CONTENT_CLOUD_BUY_START_SALE, []),
%                                 % AllRewards = "[]",
%                                 % CloudOpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_CLOUD_BUY),%% 120
%                                 % lib_mail_api:send_sys_mail_to_all(Title, Content, AllRewards, [], CloudOpenLv, ?SEND_LOG_TYPE_YES)
%                                 end)
%                     end,
%                     NewState = State#cloud_buy_kf_state{
%                         done_orders = [],
%                         unfinished_orders = [],
%                         award_time = RealAwardTime,
%                         award_open_ref = AwardOpenRef1,
%                         last_lucky_orders = OldLuckyOrders ++ LuckyOrders,
%                         last_big_award_id = BigAwardId,
%                         big_award_id = NextBigAwardId,
%                         unlimited_time = UnlimitedTime,
%                         unlimited_ref = UnlimitedRef1,
%                         cur_count = 0,
%                         join_num = 0,
%                         last_award_time = NowTime
%                     };
%                 NextBigAwardId == FirstBigId ->%%当天大奖卖完了
%                     if
%                         NextAwardTime > EndTime  ->
%                             NNextAwardTime = 0,
%                             util:cancel_timer(AwardOpenRef),
%                             util:cancel_timer(UnlimitedRef),
%                             AwardOpenRef1 = undefined,
%                             UnlimitedRef1 = undefined;
%                         true ->
%                             NNextAwardTime = NextAwardTime,
%                             AwardOpenRef1 = util:send_after(AwardOpenRef, (NextAwardTime - NowTime) * 1000, self(), award),
%                             UnlimitedRef1 = util:send_after(UnlimitedRef, (NextUnlimitedTime - NowTime) * 1000, self(), unlimited_open)
%                     end,
%                     erlang:send_after((NowDate+86400 - NowTime)*1000, self(), {restart}),
%                     NewState = State#cloud_buy_kf_state{
%                         % done_orders = [],
%                         unfinished_orders = [],
%                         award_time = NNextAwardTime,
%                         award_open_ref = AwardOpenRef1,
%                         last_lucky_orders = OldLuckyOrders ++ LuckyOrders,
%                         last_big_award_id = BigAwardId,
%                         big_award_id = BigAwardId,   %活动结束发最后一个大奖id
%                         unlimited_time = NextUnlimitedTime,
%                         unlimited_ref = UnlimitedRef1,
%                         cloud_end_flag = 1,
%                         last_award_time = NowTime
%                     };
%                 true ->
%                     NewState = State#cloud_buy_kf_state{
%                         done_orders = [],
%                         unfinished_orders = [],
%                         last_lucky_orders = OldLuckyOrders ++ LuckyOrders,
%                         last_big_award_id = BigAwardId,
%                         last_award_time = NowTime
%                     }
%             end,
%             case util:is_cls() of
%                 true ->
%                     mod_clusters_center:apply_to_all_node(mod_cloud_buy_local, send_award_tv, [LuckyOrders, SubType], 50);
%                 false ->
%                     ?DEBUG("Award once!  LuckyOrders:~p~n",[LuckyOrders]),
%                     mod_cloud_buy_local:send_award_tv(LuckyOrders, SubType)
%             end;
%         % NextAwardTime > EndTime -> %% 还没买完但是活动快结束了
%         true ->
%             LuckyOrders = handle_awards(DoneOrders, 0, AwardTime, BigAwardId, SubType, LastAwardTime),
%             NewState = State#cloud_buy_kf_state{
%                 done_orders = [],
%                 unfinished_orders = [],
%                 last_lucky_orders = OldLuckyOrders ++ LuckyOrders,
%                 last_big_award_id = BigAwardId,
%                 last_award_time = NowTime
%             }
%         % true -> %% 还没卖完，推迟到下个开奖时间
%         %     AwardOpenRef1 = util:send_after(AwardOpenRef, (NextAwardTime - AwardTime) * 1000, self(), award),
%         %     UnlimitedRef1 = util:send_after(UnlimitedRef, (NextUnlimitedTime - UnlimitedTime) * 1000, self(), unlimited_open),
%         %     LuckyOrders = handle_awards(DoneOrders, AwardCount, 0, BigAwardId, SubType),
%         %     NewState = State#cloud_buy_kf_state{
%         %         done_orders = [],
%         %         unfinished_orders = [],
%         %         award_time = NextAwardTime,
%         %         award_open_ref = AwardOpenRef1,
%         %         last_lucky_orders = LuckyOrders,
%         %         last_big_award_id = BigAwardId,
%         %         big_award_id = get_next_big_award_id(Type, SubType, BigAwardId),
%         %         unlimited_time = NextUnlimitedTime,
%         %         unlimited_ref = UnlimitedRef1,
%         %         cur_count = 0
%         %     }
%     end,
%     db:execute(io_lib:format("DELETE FROM `cloud_buy_kf` WHERE `time`<~p ", [(AwardTime-24*60*60*3)])),
%     {noreply, NewState};

do_handle_info(award, State) ->
    #cloud_buy_kf_state{
        custom_act_type = Type,
        custom_act_subtype = SubType,
        done_orders = DoneOrders, 
        big_award_id = BigAwardId, 
        cur_count = CurCount,
        award_time = AwardTime,
        last_lucky_orders = OldLuckyOrders,
        award_open_ref = AwardOpenRef,
        unlimited_time = UnlimitedTime,
        unlimited_ref = UnlimitedRef,
        end_time = EndTime,
        last_award_time = LastAwardTime
    } = State,
    NowTime = utime:unixtime(),
    NextAwardTime = AwardTime + 86400,
    NextUnlimitedTime = UnlimitedTime + 86400,
    #big_award_cfg{num = TotalCount, award_num = AwardCount} = data_cloud_buy:get_reward_cfg(BigAwardId),
    if
        CurCount >= TotalCount orelse NowTime >= AwardTime -> 
            LuckyOrders = handle_awards(DoneOrders, AwardCount, AwardTime, BigAwardId, SubType, LastAwardTime),
            NextBigAwardId = get_next_big_award_id(Type, SubType, BigAwardId),        
            if
                NowTime >= UnlimitedTime andalso NowTime =< AwardTime ->
                    RealAwardTime = AwardTime,
                    AwardOpenRef1 = util:send_after(AwardOpenRef, max(1 ,AwardTime - NowTime) * 1000, self(), award),
                    UnlimitedRef1 = util:send_after(UnlimitedRef, 500, self(), unlimited_open);
                NowTime < UnlimitedTime ->
                    RealAwardTime = AwardTime,
                    AwardOpenRef1 = util:send_after(AwardOpenRef, max(1 ,AwardTime - NowTime) * 1000, self(), award),
                    UnlimitedRef1 = util:send_after(UnlimitedRef, (UnlimitedTime - NowTime) * 1000, self(), unlimited_open);
                NextAwardTime > EndTime ->
                    RealAwardTime = 0,
                    AwardOpenRef1 = undefined,
                    UnlimitedRef1 = undefined;
                true ->
                    RealAwardTime = AwardTime,
                    AwardOpenRef1 = util:send_after(AwardOpenRef, (NextAwardTime - NowTime) * 1000, self(), award),
                    UnlimitedRef1 = util:send_after(UnlimitedRef, (NextUnlimitedTime - NowTime) * 1000, self(), unlimited_open)
            end,
            if
                NowTime >= RealAwardTime ->
                    skip;
                true ->
                    spawn(fun() -> timer:sleep(1000),
                        mod_cloud_buy_local:send_open_tv(SubType)
                        % Title = ?LAN_MSG(?LAN_TITLE_CLOUD_BUY_START_SALE),
                        % Content = utext:get(?LAN_CONTENT_CLOUD_BUY_START_SALE, []),
                        % AllRewards = "[]",
                        % CloudOpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_CLOUD_BUY),%% 120
                        % lib_mail_api:send_sys_mail_to_all(Title, Content, AllRewards, [], CloudOpenLv, ?SEND_LOG_TYPE_YES)
                        end)
            end,
            OrderRecord = lists:sublist(DoneOrders, 10),
            NewState = State#cloud_buy_kf_state{
                done_orders = [],
                unfinished_orders = [],
                award_time = RealAwardTime,
                award_open_ref = AwardOpenRef1,
                last_lucky_orders = OldLuckyOrders ++ LuckyOrders,
                last_big_award_id = BigAwardId,
                big_award_id = NextBigAwardId,
                unlimited_time = UnlimitedTime,
                unlimited_ref = UnlimitedRef1,
                cur_count = 0,
                join_num = 0,
                cloud_end_flag = 0,
                last_award_time = NowTime,
                order_record = OrderRecord
            },
            % ?MYLOG("cloud_buy","LuckyOrders:~p~n",[OldLuckyOrders ++ LuckyOrders]),
            case util:is_cls() of
                true ->
                    mod_clusters_center:apply_to_all_node(mod_cloud_buy_local, send_award_tv, [LuckyOrders, SubType], 50);
                false ->
                    ?DEBUG("Award once!  LuckyOrders:~p~n",[LuckyOrders]),
                    mod_cloud_buy_local:send_award_tv(LuckyOrders, SubType)
            end;
        true ->
            LuckyOrders = handle_awards(DoneOrders, 0, AwardTime, BigAwardId, SubType, LastAwardTime),
            OrderRecord = lists:sublist(DoneOrders, 10),
            NewState = State#cloud_buy_kf_state{
                done_orders = [],
                unfinished_orders = [],
                last_lucky_orders = OldLuckyOrders ++ LuckyOrders,
                last_big_award_id = BigAwardId,
                last_award_time = NowTime,
                order_record = OrderRecord
            }
    end,
    db:execute(io_lib:format("DELETE FROM `cloud_buy_kf` WHERE `time`<~p ", [(AwardTime-24*60*60*3)])),
    db:execute(io_lib:format("DELETE FROM `cloud_buy_stage_reward` WHERE `subtype`=~p ",[SubType])),
    {noreply, NewState};

do_handle_info(_Msg, State) ->
    {noreply, State}.
 

%% internal
do_init(SubType) ->
    ZeroTime = utime:unixdate(),
    Now = utime:unixtime(),
    {StartTime, EndTime} = lib_custom_act_util:get_act_time_range_by_type(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType),
    {award_time,[Hour,Minute]} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, award_time),
    % [{_,[Hour,Minute]}|_] =data_cloud_buy:get_value_by_id(big_award_id_list),
    TodayAwardTime = ZeroTime + Hour * 3600 + Minute * 60,
    if
        Now < TodayAwardTime orelse TodayAwardTime + 86400 =< EndTime ->
            {AwardId, Orders, JoinNum} = load(TodayAwardTime, Now, SubType),
            if
                AwardId =:= 0 ->
                    case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, big_award_ids) of
                        {big_award_ids, [BigAwardId|_]} -> skip;
                        _ -> [BigAwardId|_] = data_cloud_buy:get_all_big_award()
                    end;
                true ->
                    BigAwardId = AwardId
            end,
            case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, unlimited_time) of
                {unlimited_time,[UH,UM]} ->
                    UnlimitedTime0 = ZeroTime + UH*3600 + UM * 60;
                _A ->
                    UnlimitedTime0 = 0
            end,
            if
                Now < TodayAwardTime ->
                    UnlimitedTime = UnlimitedTime0,
                    AwardDelay = TodayAwardTime - Now;
                true ->
                    UnlimitedTime = UnlimitedTime0 + 86400,
                    AwardDelay = TodayAwardTime + 86400 - Now
            end,
            if
                UnlimitedTime > Now ->
                    UnlimitedRef = erlang:send_after((UnlimitedTime - Now) * 1000, self(), unlimited_open);
                true ->
                    UnlimitedRef = undefined
            end,
            % erlang:send_after(1000, self(), {restart}),
            AwardOpenRef1 = erlang:send_after(AwardDelay * 1000, self(), award),
            {LastBigAwardId, LastLuckyOrders, LastAwardTime} = load_last_lucky_orders(Now, BigAwardId, SubType),
            % ?PRINT("Count:~p,BigAwardId:~p~n",[calc_order_count(Orders), BigAwardId]),
            State = #cloud_buy_kf_state{
                custom_act_type = ?CUSTOM_ACT_TYPE_CLOUD_BUY, 
                custom_act_subtype = SubType, 
                start_time = StartTime, 
                end_time = EndTime, 
                done_orders = Orders, 
                big_award_id = BigAwardId, 
                cur_count = calc_order_count(Orders), 
                award_time = Now + AwardDelay,
                unlimited_time = UnlimitedTime,
                unlimited_ref = UnlimitedRef,
                award_open_ref = AwardOpenRef1,
                last_big_award_id = LastBigAwardId,
                last_lucky_orders = LastLuckyOrders,
                cloud_end_flag = 0,
                last_award_time = LastAwardTime,
                join_num = JoinNum
                % role_buynum = get_role_buynum(Orders, [])
            };
        true ->
            case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, big_award_ids) of
                {big_award_ids, [BigAwardId|_]} -> ok;
                _ -> [BigAwardId|_] = data_cloud_buy:get_all_big_award()
            end,
            State = #cloud_buy_kf_state{
                custom_act_type = ?CUSTOM_ACT_TYPE_CLOUD_BUY,
                custom_act_subtype = SubType,
                start_time = StartTime, 
                end_time = EndTime,
                big_award_id = BigAwardId,
                award_time = TodayAwardTime,
                cloud_end_flag = 0,
                last_award_time = 0
            }
    end,
    State.

load(TodayAwardTime, Now, SubType) ->
    if
        TodayAwardTime > Now ->
            TimeBegin = TodayAwardTime - 86400;
        true ->
            TimeBegin = TodayAwardTime
    end,
    SQL = io_lib:format("SELECT `order_id`, `big_award_id`,`role_id`, `role_name`, `platform`, `server_num`, `count`, `state`,
        `time`, `award_time`,`gtype_id` FROM `cloud_buy_kf` WHERE `time` >= ~p AND `state`=~p AND `subtype` = ~p ORDER BY `time` DESC", 
        [TimeBegin, ?ORDER_STATE_PAID, SubType]),
    case db:get_all(SQL) of
        [[_, BigAwardId|_]|_] = All ->
            % Orders = [db_data_2_order(D) || D <- All],
            Fun = fun([_, _, RoleId, _, _, _, _, _, _, _,_] = D, {TemOrders, TemJoinIds}) ->
                {[db_data_2_order(D)|TemOrders],[RoleId|TemJoinIds]}
            end,
            {Orders, JoinIds} = lists:foldl(Fun, {[],[]}, All),
            NewUserIdList = ulists:removal_duplicate(JoinIds),
            JoinNum = erlang:length(NewUserIdList),
            {BigAwardId, Orders, JoinNum};
        _ ->
            SQL2 = io_lib:format("SELECT `big_award_id` FROM `cloud_buy_kf` WHERE `time` >= ~p AND `subtype` = ~p LIMIT 1", [TimeBegin - 24*60*60, SubType]),
            case db:get_one(SQL2) of
                null ->
                    {0, [], 0};
                BigAwardId ->
                    {BigAwardId, [], 0}
            end
    end.

calc_order_count(Orders) ->
    lists:sum([Count || #cloud_order{count = Count} <- Orders]).

%%TODO: VIP配置临时改下
% check_personal_count_limit(_,_,_,_,_,_) ->  false.
check_personal_count_limit(_BigAwardId, SubType, DoneOrders, RoleId, VipLv, VipType, BuyCount) ->
   case lib_vip_api:get_vip_privilege(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_CLOUD_BUY, VipType, VipLv) of
        0 ->
           false;
        VipLvCount ->
           {award_time,[Hour,Minute]} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, award_time),
           NowTime = utime:unixtime(),
           NowDate = utime:unixdate(),
           ConAwardTime = Hour*60*60 + Minute*60,
           case (NowTime-NowDate) >= ConAwardTime of
               true ->
                   BeforeAwardTime = NowDate + ConAwardTime,
                   NextAwardTime = NowDate + 24*60*60 + ConAwardTime;
               false ->
                   BeforeAwardTime = max(0, (NowDate - (24*60*60 - ConAwardTime))),
                   NextAwardTime = NowDate + ConAwardTime
           end,
           F = fun(O, TodayBuyNum1) ->
               #cloud_order{
                   customer_uid = CustomerUid,
                   count = Count,
                   time = OrderTime
               } = O,
               case CustomerUid of
                   RoleId ->
                       case OrderTime >= BeforeAwardTime andalso OrderTime < NextAwardTime of
                           true ->
                               TodayBuyNum1 + Count;
                           false ->
                               TodayBuyNum1
                       end;
                   _ ->
                       TodayBuyNum1
               end
           end,
           TodayBuyNum = lists:foldl(F, 0, DoneOrders),
           BuyCount + TodayBuyNum =< VipLvCount
   end.

create_a_order(BigAwardId, RoleId, RoleName, PlatForm, Server, Count, Now, SubType, AwardTime, GtypeIds) ->
    F = fun
        () ->
            SQL = io_lib:format("INSERT INTO `cloud_buy_kf` (`big_award_id`, `role_id`, `role_name`, `platform`, 
                `server_num`, `count`, `state`, `time`, `subtype`, `award_time`, `gtype_id`) VALUES (~p, ~p, '~s', '~s', ~p, 
                ~p, ~p, ~p, ~p, ~p, '~s')", [BigAwardId, RoleId, util:fix_sql_str(RoleName), util:fix_sql_str(PlatForm), 
                Server, Count, ?ORDER_STATE_NONE, Now, SubType, AwardTime, util:term_to_string(GtypeIds)]),
            db:execute(SQL),
            OId = db:get_one("SELECT LAST_INSERT_ID()"),
            Order = #cloud_order{
                order_id = OId,
                big_award_id = BigAwardId,
                customer_uid = RoleId,
                customer_name = RoleName,
                platform = PlatForm,
                server = Server,
                state = ?ORDER_STATE_NONE,
                count = Count,
                time = Now,
                goods_type_id = GtypeIds
            },
            {ok, Order}
    end,
    db:transaction(F).

save_order(#cloud_order{order_id = OId, state = State, goods_type_id = GtypeIds}) ->
    NGtypeIds = util:term_to_string(GtypeIds),
    SQL = io_lib:format("UPDATE `cloud_buy_kf` SET `state` = ~p, `gtype_id` = '~s' WHERE `order_id` = ~p", [State, NGtypeIds, OId]),
    db:execute(SQL).

make_clear_ref([], _) -> undefined;
make_clear_ref(UnFinishedOrders, Now) ->
    MinTime = lists:min([T || #cloud_order{time = T} <- UnFinishedOrders]),
    Delay = max(1, MinTime - Now + 5),
    erlang:send_after(Delay* 1000, self(), clear_unfinished).

handle_awards(DoneOrders, AwardCount, AwardTime, BigAwardId, SubType, LastAwardTime) ->
    case data_cloud_buy:get_reward_cfg(BigAwardId) of
        #big_award_cfg{num = MaxNum} -> skip;
        _ ->
            ?ERR("No such cfg BigAwardId =<< ~p >>~n",[BigAwardId]), 
            MaxNum = 1
    end, 
    {LuckyOrders, NewDoneOrders} = calc_award(AwardTime, DoneOrders, AwardCount, MaxNum, [], []),
    % PrevAwardTime = AwardTime - 86400,
    PrevAwardTime = LastAwardTime,
    case [Id || #cloud_order{order_id = Id} <- LuckyOrders] of
        [] ->
            SQL = io_lib:format("UPDATE `cloud_buy_kf` SET `state`=3, `award_time` = ~p WHERE `time` >= ~p AND `subtype` = ~p", [AwardTime, PrevAwardTime, SubType]);
        LuckyIds ->
            IsdStr = ulists:list_to_string(LuckyIds, ","),
            SQL = io_lib:format("UPDATE `cloud_buy_kf` SET `state`=if(`order_id` IN(~s), 2,3), `award_time` = ~p WHERE `time` >= ~p AND `subtype` = ~p", [IsdStr, AwardTime, PrevAwardTime, SubType])
    end,
    db:execute(SQL),
    if length(LuckyOrders) > 0 -> spawn(fun () -> 
            [db:execute(io_lib:format("UPDATE `cloud_buy_kf` SET `count`= ~p WHERE `order_id` = ~p", [LCount, LId]))|| #cloud_order{order_id = LId, count = LCount}<- LuckyOrders],
            log_lucky_orders(SubType, LuckyOrders) end); true -> ok end,
    F = fun
        (#cloud_order{customer_uid = RoleId, count = Count, state = State}, Acc) ->
            case lists:keyfind(RoleId, 1, Acc) of
                {RoleId, AccCount, AccState} ->
                    NewAccState = if State =:= ?ORDER_STATE_AWARD -> ?ORDER_STATE_AWARD; true -> AccState end,
                    lists:keystore(RoleId, 1, Acc, {RoleId, AccCount + Count, NewAccState});
                _ ->
                    [{RoleId, Count, State}|Acc]
            end
    end,
    Baunch = lists:foldl(F, [], NewDoneOrders),
    LuckyOrderNameList = [io_lib:format("~s", [O#cloud_order.customer_name]) || O <- LuckyOrders],
    case util:is_cls() of
        true ->
            mod_clusters_center:apply_to_all_node(lib_cloud_buy, award_result_handler, [BigAwardId, Baunch, LuckyOrderNameList], 50);
        false ->
            lib_cloud_buy:award_result_handler(BigAwardId, Baunch, LuckyOrderNameList)
    end,
    LuckyOrders.

calc_award(AwardTime, DoneOrders, AwardCount, MaxNum, LuckyOrders, SetupOrders) when AwardCount > 0 andalso length(DoneOrders) > 0 ->
    WeightList = [{Weight, Order} || #cloud_order{count = Weight} = Order <- DoneOrders],
    % #cloud_order{order_id = Id, customer_uid = RoleId} = Order = urand:rand_with_weight(WeightList),
    NowTime = utime:unixtime(),
    Order = urand:rand_with_percent(WeightList, MaxNum),
    case Order of
        #cloud_order{order_id = Id, customer_uid = RoleId} ->
            {PersonalList, OthersList} = lists:partition(fun
                (#cloud_order{customer_uid = U}) ->
                    U =:= RoleId
            end, DoneOrders),
            % PersonalList1 = [O#cloud_order{state = if OId =:= Id -> ?ORDER_STATE_AWARD; true -> ?ORDER_STATE_LOSE end} || #cloud_order{order_id = OId} = O <- PersonalList],
            Fun = fun(#cloud_order{order_id = OId, count = Count} = O, {Acc, Sum}) ->
                State = if 
                    OId =:= Id -> 
                        ?ORDER_STATE_AWARD; 
                    true -> 
                        ?ORDER_STATE_LOSE 
                end,
                {[O#cloud_order{state = State}|Acc], Count+Sum}
            end,
            {PersonalList1, Total} = lists:foldl(Fun, {[], 0}, PersonalList),
            NewOrder = Order#cloud_order{time = NowTime, count = Total},
            NewLuckyOders = [NewOrder|LuckyOrders],
            NewSetupOrders = PersonalList1 ++ SetupOrders;
        _ ->
            OthersList = DoneOrders,
            NewLuckyOders = LuckyOrders,
            NewSetupOrders = SetupOrders
    end,
    calc_award(AwardTime, OthersList, AwardCount - 1, MaxNum, NewLuckyOders, NewSetupOrders);

calc_award(_AwardTime, DoneOrders, 0, _, LuckyOrders, SetupOrders) ->
    NewSetupOrders = [O#cloud_order{state = ?ORDER_STATE_LOSE} || O <- DoneOrders] ++ SetupOrders,
    {LuckyOrders, NewSetupOrders};

calc_award(_AwardTime, [], _, _, LuckyOrders, SetupOrders) ->
    {LuckyOrders, SetupOrders}.

load_last_lucky_orders(NowTime, NowBigAwardId, _SubType) ->
    NowDate = utime:unixdate(NowTime),
    LastBeginTime = NowDate - 86400*3,
    LastEndTime = NowTime,
    SQL = io_lib:format("SELECT `order_id`, `big_award_id`,`role_id`, `role_name`, `platform`, `server_num`, `count`, `state`,
        `time`, `award_time`, `gtype_id` FROM `cloud_buy_kf` WHERE `state` = ~p AND `time` >= ~p AND `time` < ~p", 
        [?ORDER_STATE_AWARD, LastBeginTime, LastEndTime]),
    case db:get_all(SQL) of
        [[_, BigAwardId|_]|_] = All ->
            Orders = [db_data_2_order(D) || D <- All],
            Fun = fun([_, _, _, _, _, _, _, _, _, AwardTime,_], LastAwardTime) ->
                if
                    LastAwardTime == 0 ->
                        AwardTime;
                    LastAwardTime =< AwardTime ->
                        AwardTime;
                    true ->
                        LastAwardTime
                end
            end,
            NewLastAwardT = lists:foldl(Fun, 0, All),
            {BigAwardId, Orders, NewLastAwardT};
        _ ->
            {NowBigAwardId, [], 0}
    end.
    
db_data_2_order([Id, BigAwardId, RoleId, NStr, PStr, S, Count, State, Time, AwardTime, GtypeIds]) ->
    NewGtypeIds = calc_gtypeids(GtypeIds),
    #cloud_order{
        order_id = Id, 
        customer_uid = RoleId,
        customer_name = binary_to_list(NStr),
        platform = binary_to_list(PStr),
        server = S,
        state = State, 
        time = Time, 
        count = Count,
        big_award_id = BigAwardId,
        award_time = AwardTime,
        goods_type_id = NewGtypeIds
    }.

calc_gtypeids(GtypeIds) when is_integer(GtypeIds) andalso GtypeIds > 0 ->
    [GtypeIds];
calc_gtypeids(GtypeIds) when is_list(GtypeIds) ->
    GtypeIds;
calc_gtypeids(_) -> [].

get_self_buy_num(Orders, RoleId) ->
    F = fun(O, SelfBuyNum1) ->
        #cloud_order{
            customer_uid = CustomerUid,
            count = Count
        } = O,
        case CustomerUid of
            RoleId ->
                SelfBuyNum2 = SelfBuyNum1 + Count;
            _ ->
                SelfBuyNum2 = SelfBuyNum1
        end,
        SelfBuyNum2
    end,
    SelfBuyNum = lists:foldl(F, 0, Orders),
    SelfBuyNum.

get_next_big_award_id(Type, SubType, BigAwardId) ->
    case lib_custom_act_util:keyfind_act_condition(Type, SubType, big_award_ids) of
        {big_award_ids, Ids} -> ok;
        _ -> Ids = data_cloud_buy:get_all_big_award()
    end,
    case Ids of
        [Id|OthersList] ->
            get_next_id_circle(BigAwardId, Id, OthersList, Id);
        _ -> 
            BigAwardId
    end.


get_next_id_circle(_BigAwardId, _NextId, [], FirstId) ->
    FirstId;
get_next_id_circle(BigAwardId, BigAwardId, [NextId|_], _FirstId) ->
    NextId;
get_next_id_circle(BigAwardId, _NextId, [NextId2|OthersList], FirstId) ->
    get_next_id_circle(BigAwardId, NextId2, OthersList, FirstId).

log_order_done(SubType, DoneOrder) ->
    #cloud_order{order_id = OId, customer_uid = RoleId, customer_name = RoleName, platform = PlatForm, server = Server, count = Count} = DoneOrder,
    Time = utime:unixtime(), 
    Event = 1, %% 订单生效
    Values = [[OId, RoleId, util:fix_sql_str(RoleName), util:fix_sql_str(PlatForm), Server, Count, Event, SubType, Time]],
    lib_log_api:log_cloud_buy_kf(Values).

log_lucky_orders(SubType, Orders) ->
    Time = utime:unixtime(), 
    Event = 2, %% 订单中奖
    Values = [
        [OId, RoleId, util:fix_sql_str(RoleName), util:fix_sql_str(PlatForm), Server, Count, Event, SubType, Time] ||
        #cloud_order{order_id = OId, customer_uid = RoleId, customer_name = RoleName, platform = PlatForm, server = Server, count = Count} <- Orders 
    ],
    lib_log_api:log_cloud_buy_kf(Values).

% get_role_buynum([], Acc) -> Acc;
% get_role_buynum([H|T], Acc) ->
%     #cloud_order{
%             customer_uid = CustomerUid,
%             count = Count
%         } = H,
%     case lists:keyfind(CustomerUid, 1, Acc) of
%         {CustomerUid, Num} ->
%             NewAcc = lists:keystore(CustomerUid, 1, Acc, {CustomerUid, Num + Count});
%         _ ->
%             NewAcc = lists:keystore(CustomerUid, 1, Acc, {CustomerUid, Count})
%     end,
%     get_role_buynum(T, NewAcc).