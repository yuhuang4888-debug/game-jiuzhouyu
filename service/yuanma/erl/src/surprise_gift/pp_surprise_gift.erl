%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%% 惊喜礼包
%%% @end
%%% Created : 24. 四月 2019 2:12
%%%-------------------------------------------------------------------
-module(pp_surprise_gift).
-author("whao").

%% API
-export([handle/3]).
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("surprise_gift.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").
-include("guild.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("goods.hrl").

handle(Cmd, Player, Data) ->
    #player_status{figure = Figure} = Player,
    ServerTime = util:get_open_day(), %  开服天数
    case ServerTime >= ?SURP_KV_OPEN_DAY andalso Figure#figure.lv >= ?SURP_KV_OPEN_LEV of % 是否有外观种类 和 达到等级
        true -> do_handle(Cmd, Player, Data);
        false -> skip
    end.


%% 惊喜礼包界面
do_handle(49000, #player_status{sid = Sid, status_surprise = StatuSurp}=PS, []) ->
    #status_surprise{draw_times = DrawTimes, add_free_times = AddFreeTimes, use_free_times = UseFreeTimes, turn_id = TurnId, gift_list = GiftList, draw_list = DrawList} = StatuSurp,
    %HadDrawTimes = mod_daily:get_count(RoleId, ?MOD_SURPRISE_GIFT, 1), % 获取免费的次数
    %FreeDrawTimes = max(0, (1 - HadDrawTimes)),
    FreeDrawTimes = lib_surprise_gift:get_acc_daily_free_times(PS),
    TaskStateList = lib_surprise_gift:get_task_state_list(PS),
    NewGiftList = [{GiftIdTmp, utime:diff_days(BuyTimeTmp) + 1, BackDayTmp} || {GiftIdTmp, BuyTimeTmp, BackDayTmp} <- GiftList, BuyTimeTmp =/= 0],
    {ok, BinData} = pt_490:write(49000, [?SUCCESS, FreeDrawTimes, AddFreeTimes, UseFreeTimes, DrawTimes, TurnId, DrawList, NewGiftList, TaskStateList]),
    lib_server_send:send_to_sid(Sid, BinData);

%%  购买礼包
do_handle(49001, #player_status{id = RoleId, sid = Sid, status_surprise = StatusSurp, figure = Figure} = PS, [GiftId]) ->
    #surprise_gift_cfg{gift_price = [_, GiftCost], gift_reward = RewardList, gift_dec = GiftName} = data_surprise:get_surprise_gift(GiftId),
    #status_surprise{
        draw_times = DrawTimes, add_free_times = AddFreeTimes, use_free_times = UseFreeTimes,
        turn_id = TurnId, gift_list = GiftList, draw_list = DrawList
    } = StatusSurp,
    {ErrCode, LastPlayer} =
        case lib_surprise_gift:check_buy_gift(PS, GiftId) of
            true ->
                case lib_goods_api:cost_object_list_with_check(PS, [GiftCost], surprise_gift, "") of
                    {true, CostPS} ->
                        % 更新PS惊喜礼包的礼包列表状态
                        NowTime = utime:unixtime(),
                        NewGiftList = [{GiftId, NowTime, 0} | GiftList],
                        NewSurp = StatusSurp#status_surprise{gift_list = NewGiftList},
                        StatusPS = CostPS#player_status{status_surprise = NewSurp},
                        % 发送购买的礼包奖励
                        Reward = case lists:keyfind(Figure#figure.sex, 1, RewardList) of
                                     {_Sex, RewardL} -> RewardL;
                                     _ -> []
                                 end,
                        Produce = #produce{type = surprise_gift, remark = "buy_surprise_gift", reward = Reward},
                        RewardPS = lib_goods_api:send_reward(StatusPS, Produce),
                        % 记录数据库
                        lib_surprise_gift:sql_replace_surprise(RoleId, DrawTimes, AddFreeTimes, UseFreeTimes, TurnId, NewGiftList, DrawList),
                        % 检查本日的充值金额和活跃度以更新抽奖次数
                        FreeTimePS = lib_surprise_gift:update_free_times(RewardPS),
                        % 购买日志记录
                        lib_log_api:log_buy_surprise_gift(RoleId, GiftId, GiftCost, Reward),
                        % 觉醒传闻
                        lib_chat:send_TV({all}, ?MOD_SURPRISE_GIFT, 1, [Figure#figure.name, RoleId, util:make_sure_binary(GiftName)]),
                        {?SUCCESS, FreeTimePS};
                    {false, ECode, NewPlayer} ->
                        {ECode, NewPlayer}
                end;
            {false, ECode} ->
                {ECode, PS}
        end,
    {ok, BinData} = pt_490:write(49001, [ErrCode, GiftId]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, LastPlayer};




%% 抽奖
do_handle(49002, #player_status{id = RoleId, sid = Sid, status_surprise = StatuSurp} = PS, []) ->
    #status_surprise{
        draw_times = DrawTimes, add_free_times = AddFreeTimes, use_free_times = UseFreeTimes,
        turn_id = Turns, draw_list = DrawGift, gift_list = GiftList
    } = StatuSurp,
    {ErrCode, LastUseFreeTimes, LastPlayer, TurnId, RewardId} =
        case lib_surprise_gift:is_active_draw(PS) of % 判断是否都已经买了
            true ->
                AccDailyFreeTimes = lib_surprise_gift:get_acc_daily_free_times(PS),
                FreeDrawTimes = max(0, AccDailyFreeTimes + AddFreeTimes - DrawTimes),
                case FreeDrawTimes > 0 of % 判断有没有抽奖次数
                    true ->
                        {NewTurns, GiftDrawId, NewDrawGift} = lib_surprise_gift:draw_surprise_gift(Turns, DrawGift),
                        case GiftDrawId == 0 of
                            false ->
                                #surprise_gift_draw{reward_list = RewardList} = data_surprise:get_surprise_gift_draw(NewTurns, GiftDrawId), % 还有 传闻
                                Produce = #produce{type = surprise_gift, remark = "draw_surprise_gift", reward = RewardList},
                                NewPs = lib_goods_api:send_reward(PS, Produce),
                                %mod_daily:increment(RoleId, ?MOD_SURPRISE_GIFT, 1),
                                lib_log_api:log_draw_surprise_gift(RoleId, RewardList, DrawTimes), % 记录日志
                                NewDrawTimes = DrawTimes + 1,
                                %% 如果累积的每日免费次数大于总抽奖次数，证明这次使用的是每日免费次数
                                NewUseFreeTimes = case AccDailyFreeTimes > UseFreeTimes of true -> UseFreeTimes+1; _ -> UseFreeTimes end,
                                NewStatuSurp = StatuSurp#status_surprise{
                                    draw_times = NewDrawTimes, use_free_times = NewUseFreeTimes, turn_id = NewTurns, draw_list = NewDrawGift
                                },
                                lib_surprise_gift:sql_replace_surprise(RoleId, NewDrawTimes, AddFreeTimes, NewUseFreeTimes, NewTurns, GiftList, NewDrawGift),
                                LastPs = NewPs#player_status{status_surprise = NewStatuSurp},
                                {?SUCCESS, NewUseFreeTimes, LastPs, NewTurns, GiftDrawId};
                            true ->
                                {?ERRCODE(err490_full_draw), 0, PS, NewTurns, GiftDrawId}
                        end;
                    _ ->
                        {?ERRCODE(err490_no_draw_times), 0, PS, Turns, 0}
                end;
            false ->
                {?ERRCODE(err490_not_buy_all), 0, PS, Turns, 0}
        end,
    ?PRINT("49002 ErrCode, LastUseFreeTimes, TurnId, RewardId :~w~n",[[ErrCode, LastUseFreeTimes, TurnId, RewardId]]),
    {ok, BinData} = pt_490:write(49002, [ErrCode, TurnId, RewardId, LastUseFreeTimes]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, LastPlayer};



%% 领取返利
do_handle(49003, #player_status{sid = Sid} = PS, [GiftId]) ->
    {ErrCode, LastPlayer} =
        case GiftId == 0 of
            true ->
                MaxGiftNum = data_surprise:get_max_gift_num(),
                F = fun(GiftIdTmp, PlayerTmp) ->
                    {_, PsTmp} = lib_surprise_gift:get_back_gift(PlayerTmp, GiftIdTmp),
                    PsTmp
                    end,
                LPlayer = lists:foldl(F, PS, lists:seq(1, MaxGiftNum)),
                {?SUCCESS, LPlayer};
            false ->
                lib_surprise_gift:get_back_gift(PS, GiftId)
        end,
    {ok, BinData} = pt_490:write(49003, [ErrCode, GiftId]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, LastPlayer};



do_handle(_Code, Ps, []) ->
    ?PRINT("ERR : ~p~n", [[?MODULE, _Code]]),
    {ok, Ps}.












