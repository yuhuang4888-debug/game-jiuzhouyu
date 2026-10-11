%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%% 惊喜礼包
%%% @end
%%% Created : 24. 四月 2019 1:50
%%%-------------------------------------------------------------------
-module(lib_surprise_gift).
-author("whao").
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
-include("rec_event.hrl").
-include("def_daily.hrl").
-include("def_fun.hrl").
-include("activitycalen.hrl").

%% API
-compile(export_all).

%% 登录
login(PS) ->
    StatusSurprise = get_status_surprise(PS#player_status.id),
    PS#player_status{status_surprise = StatusSurprise}.

%% 获取惊喜礼包状态
get_status_surprise(RoleId) ->
    SelectSurp = sql_select_surprise(RoleId),
    case SelectSurp of
        [[_RoleId, DrawTimes, AddFreeTimes, UseFreeTimes, TurnId, GiftListStr, DrawListStr]] ->
            GiftList = util:bitstring_to_term(GiftListStr),
            DrawList = util:bitstring_to_term(DrawListStr),
            #status_surprise{
                draw_times = DrawTimes,
                add_free_times = AddFreeTimes,
                use_free_times = UseFreeTimes,
                turn_id = TurnId,
                gift_list = GiftList,
                draw_list = DrawList
            };
        _ ->
            #status_surprise{}
    end.

%% 处理充值回调事件
handle_event(PS, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{gold = Gold}}) ->
    case Gold > 0 of
        true ->
            TodayPay = lib_recharge_data:get_today_pay_gold(PS#player_status.id),
            OldTodayPay = TodayPay - Gold,
            PayValue = data_surprise:get_surprise_kv(8),
            case OldTodayPay < PayValue andalso TodayPay >= PayValue of 
                true ->
                    LastPS = add_free_times(PS, 1);
                _ ->
                    LastPS = PS
            end;    
        _ ->
            LastPS = PS
    end,
    {ok, LastPS};
handle_event(PS, _) ->
    {ok, PS}.

add_liveness(RoleId, OldLive, NewLive) ->
    ActValue = data_surprise:get_surprise_kv(9),            % 要求达到的活跃值
    Pid = lib_player:get_alive_pid(RoleId),                 % 玩家进程id
    StatusSurprise = get_status_surprise(RoleId),           % 玩家惊喜礼包状态
    GiftList = StatusSurprise#status_surprise.gift_list,    % 玩家惊喜礼包的礼包状态
    MaxGiftNum = data_surprise:get_max_gift_num(),          % 惊喜礼包配置个数
    if 
        OldLive >= ActValue orelse NewLive < ActValue -> 
            skip;
        MaxGiftNum > length(GiftList) -> 
            skip;
        Pid =/= false -> 
            lib_player:apply_cast(Pid, ?APPLY_CAST_SAVE, ?MODULE, add_free_times, [1]);
        true ->
            AddFreeTimes = StatusSurprise#status_surprise.add_free_times,
            db:execute(io_lib:format(<<"update player_surprise_gift set `add_free_times`=~p where role_id=~p">>, [AddFreeTimes+1, RoleId]))
    end.

add_free_times(PS, Add) ->
    case is_active_draw(PS) of
        true ->
            % 计算并更新免费抽奖次数
            #player_status{id = RoleId, sid = Sid, status_surprise = StatuSurp} = PS,
            #status_surprise{add_free_times = AddFreeTimes, use_free_times = UseFreeTimes} = StatuSurp,
            NewAddFreeTimes = AddFreeTimes + Add,
            db:execute(io_lib:format(<<"update player_surprise_gift set add_free_times=~p where role_id=~p">>, [NewAddFreeTimes, RoleId])),
            % 更新玩家相关状态
            NewStatuSurp = StatuSurp#status_surprise{add_free_times = NewAddFreeTimes},
            LastPS = PS#player_status{status_surprise = NewStatuSurp},
            % 向客户端更新相关信息
            FreeDrawTimes = get_acc_daily_free_times(LastPS),
            TaskStateList = lib_surprise_gift:get_task_state_list(LastPS),
            lib_server_send:send_to_sid(Sid, pt_490, 49004, [FreeDrawTimes, NewAddFreeTimes, UseFreeTimes, TaskStateList]),
            LastPS;
        _ -> 
            PS
    end.

%% 检查购买礼物
check_buy_gift(PS, GiftId) ->
    VipLv = lib_vip:get_vip_lv(PS),
    CheckList = [{vip_lv, VipLv}, {check_is_buy, GiftId, PS}],
    case checklist(CheckList) of
        true ->
            true;
        {false, ErrCode} ->
            {false, ErrCode}
    end.

draw_surprise_gift(Turns, DrawGift) ->
    MaxTurns = data_surprise:get_surp_max_turns(),
    OldTurnDrawList = data_surprise:get_surp_turn_draw(Turns), % 此轮的所有抽奖id
    ?PRINT("Turns:~p DrawGift  :~p MaxTurns:~p~n ", [Turns, DrawGift, MaxTurns]),
    {NewTurns, GiftId, NewDrawGift} =
        case Turns == 0 of
            true ->
                draw_surprise_gift(Turns + 1, DrawGift);
            false ->
                case Turns == MaxTurns andalso length(DrawGift) == length(OldTurnDrawList) of
                    true -> % 已经全部领取
                        {Turns, ?MAX_DRAW_ID, DrawGift};
                    false ->
                        case OldTurnDrawList -- DrawGift of
                            [] ->
                                draw_surprise_gift(Turns + 1, []);
                            LastDrawGift ->
                                F = fun(DrawGiftId, WeightTmp) ->
                                    #surprise_gift_draw{reward_weigh = RewardWeight} =
                                        data_surprise:get_surprise_gift_draw(Turns, DrawGiftId),
                                    [{RewardWeight, DrawGiftId} | WeightTmp]
                                    end,
                                WeightList = lists:foldl(F, [], LastDrawGift),
                                GtId = urand:rand_with_weight(WeightList),
                                NDrawGift = [GtId | DrawGift],
                                {Turns, GtId, NDrawGift}
                        end
                end
        end,
    {NewTurns, GiftId, NewDrawGift}.


%% 领取返利方法
get_back_gift(PS, GiftId) ->
    #player_status{id = RoleId, status_surprise = StatuSurp} = PS,
    #status_surprise{
        gift_list = GiftList, draw_times = DrawTimes, add_free_times = AddFreeTimes, use_free_times = UseFreeTimes,
        turn_id = Turns, draw_list = DrawGift
    } = StatuSurp,
    case check_get_back_gift(GiftList, GiftId) of
        {true, NewBack, BackDay} ->
            ?PRINT("GiftList:~p, NewBack:~p, BackDay:~p~n", [GiftList, NewBack, BackDay]),
            NewGiftList = lists:keyreplace(GiftId, 1, GiftList, NewBack),
            NewStatuSurp = StatuSurp#status_surprise{gift_list = NewGiftList},
            #surprise_gift_cfg{return_gold = ReturnGold} = data_surprise:get_surprise_gift(GiftId),
            AllBackReward = [{Type, GoodId, GoodNum * BackDay} || {Type, GoodId, GoodNum} <- ReturnGold],
            Produce = #produce{type = surprise_gift, remark = "back_surprise_gift", reward = AllBackReward},
            NewPs = lib_goods_api:send_reward(PS, Produce),
            NewPs1 = NewPs#player_status{status_surprise = NewStatuSurp},
            %% 记录日志
            lib_log_api:log_back_surprise_gift(RoleId, GiftId, BackDay, AllBackReward),
            lib_surprise_gift:sql_replace_surprise(RoleId, DrawTimes, AddFreeTimes, UseFreeTimes, Turns, NewGiftList, DrawGift),
            {?SUCCESS, NewPs1};
        {false, ECode} ->
            {ECode, PS}
    end.


%% 领取返回奖励
check_get_back_gift(GiftList, GiftId) ->
    case lists:keyfind(GiftId, 1, GiftList) of
        {GiftId, BuyTime, BackDay} -> % 已经购买的礼包
            NowTime = utime:unixtime(),
            DiffDay = utime:diff_days(BuyTime, NowTime), % 领取与购买相差天数
            #surprise_gift_cfg{return_day = ReturnDay} = data_surprise:get_surprise_gift(GiftId), % 最大返利天数
            % 可领取天数
            CanReceive = min(ReturnDay, DiffDay + 1),
            case BackDay >= ReturnDay of % 已经领取最大的天数
                true ->
                    {false, ?ERRCODE(err490_already_back)};
                false ->
                    {true, {GiftId, BuyTime, CanReceive}, max(0, CanReceive - BackDay)}    % gift_list , can_back_day
            end;
        false ->
            {false, ?ERRCODE(err490_not_buy)}
    end.

%% 获取礼包的累积免费次数
get_acc_free_times(PS) ->
    #player_status{status_surprise = StatuSurp} = PS,
    #status_surprise{draw_times = DrawTimes, add_free_times = AddFreeTimes, gift_list = GiftList} = StatuSurp,
    case is_active_draw(PS) of 
        true ->
            MaxBuyTime = lists:max([BuyTime ||{_, BuyTime, _} <- GiftList]),
            DiffDay = utime:diff_days(MaxBuyTime) + 1,
            TotalFreeTimes = DiffDay * ?DAILY_FREE,
            max(0, TotalFreeTimes + AddFreeTimes - DrawTimes);
        _ ->
            0
    end.

%% 获取每日累积免费总次数
get_acc_daily_free_times(PS) ->
    #player_status{status_surprise = StatuSurp} = PS,
    #status_surprise{gift_list = GiftList} = StatuSurp,
    case is_active_draw(PS) of 
        true ->
            MaxBuyTime = lists:max([BuyTime ||{_, BuyTime, _} <- GiftList]),
            DiffDay = utime:diff_days(MaxBuyTime) + 1,
            TotalFreeTimes = DiffDay * ?DAILY_FREE,
            TotalFreeTimes;
        _ ->
            0
    end.

get_task_state_list(PS) ->
    TodayPay = lib_recharge_data:get_today_pay_gold(PS#player_status.id),
    PayValue = data_surprise:get_surprise_kv(8),
    TodayLive = mod_daily:get_count_offline(PS#player_status.id, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
    ActValue = data_surprise:get_surprise_kv(9),
    [{1, ?IF(TodayPay>=PayValue, 1, 0)}, {2, ?IF(TodayLive>=ActValue, 1, 0)}].

%% 是否达到抽奖条件
is_active_draw(PS) ->
    #player_status{status_surprise = StatuSurp} = PS,
    #status_surprise{gift_list = GiftList} = StatuSurp,
    MaxGiftNum = data_surprise:get_max_gift_num(),
    MaxGiftNum == length(GiftList).

%% 因购买礼包对免费抽奖次数更新
update_free_times(PS) ->
    case is_active_draw(PS) of
        false ->
            PS;
        true ->
            RechargePS = update_free_times(recharge, PS),
            LivenessPS = update_free_times(liveness, RechargePS),
            LivenessPS
    end.
%% 对充值金额进行检查
update_free_times(recharge, PS) ->
    RechargeConfig = data_surprise:get_surprise_kv(8),
    RechargeToday = lib_recharge_data:get_today_pay_gold(PS#player_status.id),
    case RechargeToday >= RechargeConfig of
        false -> 
            RechargePS = PS;
        true ->
            RechargePS = add_free_times(PS, 1)
    end,
    RechargePS;
%% 对活跃度进行检查
update_free_times(liveness, PS) ->
    LivenessConfig = data_surprise:get_surprise_kv(9),
    LivenessToday = mod_daily:get_count(PS#player_status.id, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
    case LivenessToday >= LivenessConfig of
        false ->
            LivenessPS = PS;
        true ->
            LivenessPS = add_free_times(PS, 1)
    end,
    LivenessPS.

checklist([]) -> true;
checklist([H | L]) ->
    case check_list(H) of
        true -> checklist(L);
        {false, Res} -> {false, Res}
    end.



check_list({vip_lv, VipLv}) ->
    case VipLv >= ?SURP_KV_VIP_LEV of
        true -> true;
        false -> {false, 0}
    end;


check_list({check_is_buy, GiftId, PS}) ->
    #player_status{status_surprise = StatuSurp} = PS,
    #status_surprise{gift_list = GiftList} = StatuSurp,
    case lists:keymember(GiftId, 1, GiftList) of
        true ->
            {false, ?ERRCODE(err490_is_buy)};
        false ->
            true
    end;

check_list(_) -> true.




%% ---------------------------------- db函数 -----------------------------------

sql_select_surprise(RoleId) ->
    Sql = io_lib:format(?sql_select_surprise, [RoleId]),
    db:get_all(Sql).



sql_replace_surprise(RoleId, DrawTimes, AddFreeTimes, UseFreeTimes, TurnId, GiftList, DrawList) ->
    GiftListStr = util:term_to_bitstring(GiftList),
    DrawListStr = util:term_to_bitstring(DrawList),
    Sql = io_lib:format(?sql_replace_surprise, [RoleId, DrawTimes, AddFreeTimes, UseFreeTimes, TurnId, GiftListStr, DrawListStr]),
    db:execute(Sql).

%% ---------------------------------- 秘籍 -----------------------------------

%% 清理未购买全部礼包玩家的相关抽奖数据
gm_clear_free_times() ->
    Sql = io_lib:format(<<"select role_id, draw_times, add_free_times, use_free_times, turn_id, 
                            gift_list, draw_list from player_surprise_gift">>, []),
    List = db:get_all(Sql),
    MaxGiftNum = data_surprise:get_max_gift_num(),
    F = fun(Status, {Ids, Summary}) ->
            [RoleId, _DrawTimes, _AddFreeTimes, _UseFreeTimes, _TurnId, GiftListStr, DrawListStr] = Status,
            GiftList = util:bitstring_to_term(GiftListStr),
            case MaxGiftNum =:= length(GiftList) of
                true ->
                    {Ids, Summary};
                false ->
                    NewIds = [RoleId|Ids],
                    NewSummary = [[RoleId, 0, 0, 0, 0, GiftListStr, DrawListStr]|Summary],
                    {NewIds, NewSummary}
            end
    end,
    {UpdateIds, UpdateList} = lists:foldl(F, {[], []}, List),
    UpdateSql = usql:replace(player_surprise_gift, [role_id, draw_times, add_free_times, use_free_times, turn_id, gift_list, draw_list], UpdateList),
    ?IF(UpdateSql =/= [], db:execute(UpdateSql), skip),
    % 对有影响的在线玩家进行更新
    [lib_player:apply_cast(UpdateId, ?APPLY_CAST_SAVE, lib_surprise_gift, gm_update_status_surprise, []) || UpdateId <- UpdateIds].

gm_update_status_surprise(PS) ->
    StatusSurprise = PS#player_status.status_surprise,
    NewStatus = StatusSurprise#status_surprise{draw_times = 0, add_free_times = 0, use_free_times = 0, turn_id = 0},
    NewPS = PS#player_status{status_surprise = NewStatus},
    NewPS.