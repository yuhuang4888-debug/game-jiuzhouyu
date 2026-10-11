%%% -------------------------------------------------------------------
%%% @doc        lib_weekly_card
%%% @author     lwc
%%% @email      liuweichao@suyougame.com
%%% @since      2022-03-21 11:01
%%% @deprecated 周卡逻辑层
%%% -------------------------------------------------------------------

-module(lib_weekly_card).

-include("weekly_card.hrl").
-include("server.hrl").
-include("def_fun.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("figure.hrl").

%% API
-export([
    login/1
    , offline_login/1
    , activity_weekly_card/2
    , send_weekly_card_info/1
    , get_newest_lv_exp/2
    , receive_gift_bag/1
    , add_gift_bag_num/1
    , refresh_weekly_card/1
    , store_reward_list/4
    , send_reward_list/1
    , get_weekly_card_merge_reward_list/1
    , gm_add_exp/2
    , gm_expired_weekly_card/1
    , gm_update_expired_weekly_card/1]).

%% -----------------------------------------------------------------
%% @desc 登录初始化
%% @param PS 玩家记录
%% @return NewPS
%% -----------------------------------------------------------------
login(PS) ->
    #player_status{id = RoleId, last_logout_time = _LastLogoutTime} = PS,
    NowTime = utime:unixtime(),
    LastLogoutTime = ?IF(_LastLogoutTime =:= 0, NowTime, _LastLogoutTime),
    DBWeeklyCardList = lib_weekly_card_sql:db_get_weekly_card_info(RoleId),
    F = fun(DBWeeklyCard, WeeklyCardStatus) ->
            [Lv, Exp, IsActivity, GiftBagNum, CanReceiveGift, ExpiredTime, _RewardList] = DBWeeklyCard,
            BaseRewardList = util:bitstring_to_term(_RewardList),
        RewardList = ?IF(BaseRewardList == undefined, [], BaseRewardList),
        %% 判断登出时间是否在0点到4点之间
        IsInFour = LastLogoutTime >= utime:unixdate(LastLogoutTime) andalso LastLogoutTime =< utime:unixdate_four(LastLogoutTime),
        %% 在0点~4点拿当天4点时间，不在取第二天凌晨4点时间
        FourClearTime = ?IF(IsInFour, utime:unixdate_four(LastLogoutTime), utime:get_next_unixdate_four(LastLogoutTime)),
        %% 不在0点~4点拿当天4点时间，在取前一天凌晨4点时间
        AddExpTime = ?IF(IsInFour, utime:unixdate_four(LastLogoutTime) - ?ONE_DAY_SECONDS, utime:unixdate_four(LastLogoutTime)),
        %% 需要加经验天数
        AddDay = utime_logic:logic_diff_days(AddExpTime),
        %% 时间大于凌晨4点并且开服天数大于1
        IsFourClock = utime:unixtime() >= FourClearTime andalso util:get_open_day() > 1,
            if
                ExpiredTime =:= 0 orelse IsActivity =:= ?ACTIVATION_CLOSE ->
                %% IsFourClock true 清零
                {NewGiftBagNum, NewCanReceiveGift, NewRewardList} = ?IF(IsFourClock, {0, 0, []},  {GiftBagNum, CanReceiveGift, RewardList}),
                NewWeeklyCardStatus = make_weekly_card_status(WeeklyCardStatus, Lv, Exp, ?ACTIVATION_CLOSE, NewGiftBagNum, NewCanReceiveGift, 0, NewRewardList),
                %% 持久化
                (NewGiftBagNum =/= GiftBagNum orelse NewCanReceiveGift =/= CanReceiveGift orelse NewRewardList =/= RewardList)
                    andalso lib_weekly_card_sql:db_replace_weekly_card_info(RoleId, NewWeeklyCardStatus),
                %% 日志
                lib_log_api:log_weekly_card_info(RoleId, Lv, Lv, Exp, Exp, CanReceiveGift, NewCanReceiveGift, GiftBagNum, NewGiftBagNum, NewRewardList),
                NewWeeklyCardStatus;
                true ->
                    case NowTime < ExpiredTime of
                        %% 未过期
                        true ->
                        %% 获得最新的周卡信息（新等级，新经验，新领取，新可领取）
                        {NewLv, NewExp, NewGiftBagNum, NewCanReceiveGift} =
                            get_new_weekly_card(Lv, Exp, IsActivity, CanReceiveGift, GiftBagNum, IsFourClock, AddDay),
                                    NewWeeklyCardStatus = make_weekly_card_status(WeeklyCardStatus, NewLv, NewExp, IsActivity, NewGiftBagNum, NewCanReceiveGift, ExpiredTime, []),
                        %% 持久化
                        lib_weekly_card_sql:db_replace_weekly_card_info(RoleId, NewWeeklyCardStatus),
                        %% 补发礼包
                        IsFourClock andalso reissue_gift_bag(RoleId, CanReceiveGift),
                        (NewLv =/= Lv orelse NewExp =/= Exp orelse NewGiftBagNum =/= GiftBagNum orelse NewCanReceiveGift =/= CanReceiveGift) andalso
                                    lib_log_api:log_weekly_card_info(RoleId, Lv, NewLv, Exp, NewExp, CanReceiveGift, NewCanReceiveGift, GiftBagNum, NewGiftBagNum, RewardList),
                        NewWeeklyCardStatus;
                        %% 过期
                        false ->
                        %% 计算应加多少天经验
                        Day = utime_logic:logic_diff_days(ExpiredTime, AddExpTime),
                        %?MYLOG("lwccard","{LastLogoutTime, ExpiredTime, Day}:~p~n",[{LastLogoutTime, ExpiredTime, Day}]),
                        %% 获得新的等级，新的经验
                        {NewLv, NewExp} = ?IF(IsActivity =:= ?ACTIVATION_OPEN, get_newest_lv_exp(Lv, Exp + ?WEEKLY_CARD_EXP * Day), {Lv, Exp}),
                            NewWeeklyCardStatus = make_weekly_card_status(WeeklyCardStatus, NewLv, NewExp, ?ACTIVATION_CLOSE, 0, 0, 0, []),
                        %% 补发礼包
                            reissue_gift_bag(RoleId, CanReceiveGift),
                            lib_weekly_card_sql:db_replace_weekly_card_info(RoleId, NewWeeklyCardStatus),
                        lib_log_api:log_weekly_card_info(RoleId, Lv, NewLv, Exp, NewExp, CanReceiveGift, 0, GiftBagNum, 0, RewardList),
                        NewWeeklyCardStatus
                    end
            end
    end,
    NewWeeklyCardStatusA = lists:foldl(F, #weekly_card_status{}, DBWeeklyCardList),
    NewPS = PS#player_status{weekly_card_status = NewWeeklyCardStatusA},
    send_weekly_card_info(NewPS),
    send_reward_list_red_point(NewPS),
    NewPS.

%% 离线登陆##只取周卡等级
offline_login(RoleId) ->
    case lib_weekly_card_sql:db_get_weekly_card_info(RoleId) of
        [Lv, _Exp, IsActivity, _GiftBagNum, _CanReceiveGift, _ExpiredTime, _RewardList] -> NewWeeklyCardStatus = #weekly_card_status{lv = Lv, is_activity = IsActivity};
        _ -> NewWeeklyCardStatus = #weekly_card_status{}
    end,
    NewWeeklyCardStatus.
%% -----------------------------------------------------------------
%% @desc 获得最新周卡信息
%% @param Lv             周卡等级
%% @param Exp            周卡经验
%% @param IsActivity     是否激活
%% @param CanReceiveGift 可以领取的礼包数量
%% @param GiftBagNum     已经领取的礼包数量
%% @param IsFourClock    是否符合四点
%% @param AddDay         需要加的经验天数
%% @return {Lv, Exp, GiftBagNum, CanReceiveGift}
%% -----------------------------------------------------------------
get_new_weekly_card(Lv, Exp, IsActivity, CanReceiveGift, GiftBagNum, IsFourClock, AddDay) ->
    if
        IsActivity =:= ?ACTIVATION_OPEN andalso IsFourClock ->
            {NewLv, NewExp} = get_newest_lv_exp(Lv, Exp + ?WEEKLY_CARD_EXP * AddDay),
            {NewLv, NewExp, 0, 0};
        true -> {Lv, Exp, GiftBagNum, CanReceiveGift}
    end.

%% -----------------------------------------------------------------
%% @desc 激活周卡
%% @param PS 玩家记录
%% @return {ok, NewPS}
%% -----------------------------------------------------------------
activity_weekly_card(PS, RechargeData) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}, weekly_card_status = WeeklyCardStatus} = PS,
    #weekly_card_status{
        lv               = Lv,
        exp              = Exp,
        expired_time     = ExpiredTime,
        is_activity      = IsActivity,
        reward_list      = RewardList,
        can_receive_gift = CanReceiveGift,
        gift_bag_num     = GiftBagNum
    } = WeeklyCardStatus,
    %% 计算周卡礼包数据
    {Type, GoodsId, Num} = ?WEEKLY_CARD_GIFT_BAG,
    GiftBagRewardList = ?IF(CanReceiveGift =:= 0, [], [{Type, GoodsId, Num * CanReceiveGift}]),
    ActivityDay = ?WEEKLY_CARD_LAST_DAY * ?ONE_DAY_SECONDS,
    case ExpiredTime =:= 0 orelse IsActivity =:= ?ACTIVATION_CLOSE of
        true ->
            NowTime = utime:unixtime(),
            FourClock = utime:unixdate_four(),
            %% 在开服第一天或者今天凌晨4点之后正常开，在今天凌晨0~4点前开按前一天凌晨4点开
            NewExpiredTime = ?IF(NowTime > FourClock orelse util:get_open_day() =:= 1,
                FourClock + ActivityDay, FourClock - ?ONE_DAY_SECONDS + ActivityDay),
            %% 激活补发奖励
            ReissueRewards = reissue_reward_list(PS, RewardList),
            SumRewardList = ?WEEKLY_CARD_ACTIVATION_REWARD ++ ReissueRewards ++ GiftBagRewardList,
            NewWeeklyCardStatus = make_weekly_card_status(WeeklyCardStatus, Lv, Exp, ?ACTIVATION_OPEN, GiftBagNum + CanReceiveGift, 0, NewExpiredTime, []),
            {ok, BinData} = pt_452:write(45203, [?ACTIVATION_OPEN_REISSUE,  filter_zero_num_reward(SumRewardList)]),
            lib_server_send:send_to_uid(RoleId, BinData),
            lib_log_api:log_weekly_card_info(RoleId, Lv, Lv, Exp, Exp, CanReceiveGift, 0, GiftBagNum, GiftBagNum + CanReceiveGift, []);
        false ->
            NewExpiredTime = ExpiredTime + ActivityDay,
            SumRewardList = ?WEEKLY_CARD_ACTIVATION_REWARD,
            NewWeeklyCardStatus = make_weekly_card_status(WeeklyCardStatus, Lv, Exp, ?ACTIVATION_OPEN, GiftBagNum, CanReceiveGift, NewExpiredTime, []),
            lib_log_api:log_weekly_card_info(RoleId, Lv, Lv, Exp, Exp, GiftBagNum, GiftBagNum, CanReceiveGift, CanReceiveGift, [])
    end,
    lib_weekly_card_sql:db_replace_weekly_card_info(RoleId, NewWeeklyCardStatus),
    NewPS = PS#player_status{weekly_card_status = NewWeeklyCardStatus},
    lib_goods_api:send_reward(NewPS, SumRewardList, weekly_card, 0),
    lib_log_api:log_weekly_card_open(RoleId, RoleLv, NewExpiredTime),
    mod_counter:increment_offline(RoleId, ?MOD_WEEKLY_CARD, ?MOD_WEEKLY_CARD_BUY_COUNT),
    RoleName = lib_player:get_role_name_by_id(RoleId),
    lib_chat:send_TV({all_lv, ?WEEKLY_CARD_ROLE_LV, 99999}, ?MOD_WEEKLY_CARD, 1, [RoleName, RoleId]),
    send_weekly_card_info(NewPS),
    % TA数据上报
    ta_agent_fire:weekly_card_buy(NewPS, RechargeData),
    {ok, NewPS}.

%% -----------------------------------------------------------------
%% @desc 计算最新等级和经验
%% @param Lv  周卡等级
%% @param Exp 周卡经验
%% @return {Lv, Exp}
%% -----------------------------------------------------------------
get_newest_lv_exp(Lv, Exp) ->
    #base_weekly_card{exp = CfgExp} = data_weekly_card:get_weekly_card(Lv),
    case CfgExp =< Exp of
        true ->
            ?IF(data_weekly_card:get_weekly_card(Lv + 1) =:= [], {Lv, CfgExp}, get_newest_lv_exp(Lv + 1, Exp - CfgExp));
        false -> {Lv, Exp}
    end.

%% -----------------------------------------------------------------
%% @desc 一键领取礼包
%% @param PS 玩家记录
%% @return {ok, NewPS}
%% -----------------------------------------------------------------
receive_gift_bag(PS) ->
    #player_status{id = RoleId, weekly_card_status = WeeklyCardStatus} = PS,
    #weekly_card_status{
        lv               = Lv,
        exp              = Exp,
        is_activity      = IsActivity,
        can_receive_gift = CanReceiveGift,
        gift_bag_num     = GiftBagNum
    } = WeeklyCardStatus,
    if
        CanReceiveGift =:= 0 ->
            {ok, BinData} = pt_452:write(45202, [?ERRCODE(err503_no_award), []]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, PS};
        IsActivity =:= ?ACTIVATION_CLOSE ->
            {ok, BinData} = pt_452:write(45202, [?ERRCODE(err610_no_active_weekly_card), []]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, PS};
        true ->
            {Type, GoodsId, Num} = ?WEEKLY_CARD_GIFT_BAG,
            RewardList = [{Type, GoodsId, Num * CanReceiveGift}],
            lib_goods_api:send_reward(PS, RewardList, weekly_card, 0),
            %?MYLOG("lwccard","{RewardList}:~p~n",[{RewardList}]),
            NewWeeklyCardStatus = WeeklyCardStatus#weekly_card_status{can_receive_gift = 0, gift_bag_num = GiftBagNum + CanReceiveGift},
            lib_weekly_card_sql:db_replace_weekly_card_info(RoleId, NewWeeklyCardStatus),
            NewPS = PS#player_status{weekly_card_status = NewWeeklyCardStatus},
            mod_daily:plus_count(RoleId, ?MOD_WEEKLY_CARD, ?MOD_WEEKLY_CARD_DAILY_GIFT, CanReceiveGift),
            lib_log_api:log_weekly_card_info(RoleId, Lv, Lv, Exp, Exp, CanReceiveGift, 0, GiftBagNum, GiftBagNum + CanReceiveGift, RewardList),
            {ok, BinData} = pt_452:write(45202, [?SUCCESS, RewardList]),
            lib_server_send:send_to_uid(RoleId, BinData),
            send_weekly_card_info(NewPS),
            {ok, NewPS}
    end.

%% -----------------------------------------------------------------
%% @desc 增加礼包数量(没开通也进行计算)
%% @param PS 玩家记录
%% @return NewPS
%% -----------------------------------------------------------------
add_gift_bag_num(PS) ->
    #player_status{id = RoleId, weekly_card_status = WeeklyCardStatus} = PS,
    #weekly_card_status{lv = Lv, exp = Exp, can_receive_gift = CanReceiveGift, gift_bag_num = GiftBagNum, reward_list = RewardList} = WeeklyCardStatus,
    LimitNum = ?WEEKLY_CARD_BASE_GIFT_NUM + (Lv - 1) * ?WEEKLY_CARD_LV_ADD_NUM,
    if
        GiftBagNum + CanReceiveGift >= LimitNum -> PS;
        true ->
            NewCanReceiveGift = ?IF((CanReceiveGift + GiftBagNum + ?WEEKLY_CARD_BOSS_KILL) >= LimitNum, LimitNum - GiftBagNum, CanReceiveGift + ?WEEKLY_CARD_BOSS_KILL),
            NewWeeklyCardStatus = WeeklyCardStatus#weekly_card_status{can_receive_gift = NewCanReceiveGift},
            lib_weekly_card_sql:db_replace_weekly_card_info(RoleId, NewWeeklyCardStatus),
            NewPS = PS#player_status{weekly_card_status = NewWeeklyCardStatus},
            NewCanReceiveGift =/= CanReceiveGift andalso lib_log_api:log_weekly_card_info(RoleId, Lv, Lv, Exp, Exp, CanReceiveGift, NewCanReceiveGift, GiftBagNum, GiftBagNum, RewardList),
            send_weekly_card_info(NewPS),
            %%  未激活周卡预补发奖励首次不为空提醒客户端亮红点
            CanReceiveGift =:= 0 andalso RewardList =:= [] andalso send_reward_list_red_point(NewPS),
            NewPS
    end.

%% -----------------------------------------------------------------
%% @desc 发送周卡信息
%% @param PS 玩家记录
%% @return
%% -----------------------------------------------------------------
send_weekly_card_info(PS) ->
    #player_status{id = RoleId, weekly_card_status = WeeklyCardStatus} = PS,
    #weekly_card_status{
        lv               = Lv,
        exp              = Exp,
        is_activity      = IsActivity,
        gift_bag_num     = GiftBagNum,
        can_receive_gift = CanReceiveGift,
        expired_time     = ExpiredTime
    } = WeeklyCardStatus,
    %?MYLOG("lwccard","{Lv, Exp, IsActivity, GiftBagNum, CanReceiveGift, ExpiredTime}:~p~n",[{Lv, Exp, IsActivity, GiftBagNum, CanReceiveGift, ExpiredTime}]),
    {ok, BinData} = pt_452:write(45201, [Lv, Exp, IsActivity, GiftBagNum, CanReceiveGift, ExpiredTime]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% -----------------------------------------------------------------
%% @desc 发送未激活周卡补发奖励
%% @param PS
%% @return
%% -----------------------------------------------------------------
send_reward_list(PS) ->
    #player_status{id = RoleId, weekly_card_status = WeeklyCardStatus} = PS,
    #weekly_card_status{reward_list = RewardList, can_receive_gift = CanReceiveGift} = WeeklyCardStatus,
    F = fun({{_Type, _SubType}, Rewards}, ClientRewardList) ->
        Rewards ++ ClientRewardList
    end,
    NewClientRewardList = lists:foldl(F, [], RewardList),
    {Type, GoodsId, Num} = ?WEEKLY_CARD_GIFT_BAG,
    CanReceiveGiftList = ?IF(CanReceiveGift =:= 0, [], [{Type, GoodsId, Num * CanReceiveGift}]),
    %?MYLOG("lwccard","NewClientRewardList, CanReceiveGiftList:~p~n",[{NewClientRewardList, CanReceiveGiftList}]),
    SumRewardList = ulists:object_list_merge(NewClientRewardList ++ CanReceiveGiftList),
    %?MYLOG("lwccard","SumRewardList:~p~n",[{SumRewardList}]),
    {ok, BinData} = pt_452:write(45203, [?ACTIVATION_CLOSE_REISSUE, filter_zero_num_reward(SumRewardList)]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% -----------------------------------------------------------------
%% @desc 未激活周卡时提醒客户端亮红点
%% @param PS
%% @return
%% -----------------------------------------------------------------
send_reward_list_red_point(PS) ->
    #player_status{id = RoleId, weekly_card_status = WeeklyCardStatus} = PS,
    #weekly_card_status{reward_list = RewardList, can_receive_gift = CanReceiveGift, is_activity = IsActivity} = WeeklyCardStatus,
    F = fun({{_Type, _SubType}, Rewards}, ClientRewardList) ->
        Rewards ++ ClientRewardList
    end,
    NewClientRewardList = lists:foldl(F, [], RewardList),
    {Type, GoodsId, Num} = ?WEEKLY_CARD_GIFT_BAG,
    CanReceiveGiftList = ?IF(CanReceiveGift =:= 0, [], [{Type, GoodsId, Num * CanReceiveGift}]),
    %?MYLOG("lwccard","NewClientRewardList, CanReceiveGiftList:~p~n",[{NewClientRewardList, CanReceiveGiftList}]),
    SumRewardList = ulists:object_list_merge(NewClientRewardList ++ CanReceiveGiftList),
    %=?MYLOG("lwccard","SumRewardList:~p~n",[{SumRewardList}]),
    List = filter_zero_num_reward(SumRewardList),
    %% ?INFO("List:~p//SumReward:~p", [List, SumRewardList]),
    case List of
        [] ->
            skip;
        _ ->
            {ok, BinData} = pt_452:write(45203, [?ACTIVATION_OPEN_RED_POINT, List]),
            length(SumRewardList) =/= 0 andalso IsActivity =:= ?ACTIVATION_CLOSE andalso lib_server_send:send_to_uid(RoleId, BinData)
    end.

%% -----------------------------------------------------------------
%% @desc 刷新在线玩家周卡
%% @param PS
%% @return {ok, NewPS}
%% -----------------------------------------------------------------
refresh_weekly_card(PS) ->
    #player_status{id = RoleId,weekly_card_status = WeeklyCardStatus} = PS,
    #weekly_card_status{
        lv               = Lv,
        exp              = Exp,
        is_activity      = IsActivity,
        expired_time     = ExpiredTime,
        can_receive_gift = CanReceiveGift,
        gift_bag_num     = GiftBagNum,
        reward_list      = RewardList
    } = WeeklyCardStatus,
    NowTime = utime:unixtime(),
    {NewLv, NewExp} = get_newest_lv_exp(Lv, Exp + ?WEEKLY_CARD_EXP),
    {NewGiftBagNum, NewCanReceiveGift, NewRewardList} = ?IF(util:get_open_day() > 1, {0, 0, []}, {GiftBagNum, CanReceiveGift, RewardList}),
    if
        ExpiredTime =:= 0 orelse IsActivity =:= ?ACTIVATION_CLOSE ->
            NewWeeklyCardStatus = make_weekly_card_status(WeeklyCardStatus, Lv, Exp, ?ACTIVATION_CLOSE, NewGiftBagNum, NewCanReceiveGift, 0, NewRewardList);
        true ->
            case NowTime >= ExpiredTime of
                true ->
                    NewWeeklyCardStatus = make_weekly_card_status(WeeklyCardStatus, NewLv, NewExp, ?ACTIVATION_CLOSE, NewGiftBagNum, NewCanReceiveGift, 0, NewRewardList);
                false ->
                    NewWeeklyCardStatus = make_weekly_card_status(WeeklyCardStatus, NewLv, NewExp, IsActivity, NewGiftBagNum, NewCanReceiveGift, ExpiredTime, NewRewardList)
            end,
            %% 补发宝箱奖励
            reissue_gift_bag(RoleId, CanReceiveGift)
    end,
    lib_log_api:log_weekly_card_info(RoleId, Lv, NewLv, Exp, NewExp, CanReceiveGift, NewCanReceiveGift, GiftBagNum, NewGiftBagNum, NewRewardList),
    lib_weekly_card_sql:db_replace_weekly_card_info(RoleId, NewWeeklyCardStatus),
    NewPS = PS#player_status{weekly_card_status = NewWeeklyCardStatus},
    send_weekly_card_info(NewPS),
    {ok, NewPS}.

%% -----------------------------------------------------------------
%% @desc 保存未开通周卡的补发奖励
%% @param Type    类型
%% @param SubType 子类型
%% @param Rewards 需要保存的奖励
%% @return {ok, NewPS}
%% -----------------------------------------------------------------
store_reward_list(PS, Type, SubType, BaseRewards) ->
    Rewards = filter_zero_num_reward(BaseRewards),
    case Rewards of
        [] ->
            {ok, PS};
        _ ->
            #player_status{id = RoleId, weekly_card_status = WeeklyCardStatus} = PS,
            #weekly_card_status{
                lv               = Lv,
                exp              = Exp,
                can_receive_gift = CanReceiveGift,
                gift_bag_num     = GiftBagNum,
                reward_list      = RewardList
            } = WeeklyCardStatus,
            {_Index, OldRewards} = ulists:keyfind({Type, SubType}, 1, RewardList, {{Type, SubType}, []}),
            NewRewardList = lists:keystore({Type, SubType}, 1, RewardList, {{Type, SubType}, OldRewards ++ Rewards}),
            NewWeeklyCardStatus = WeeklyCardStatus#weekly_card_status{reward_list = NewRewardList},
            NewPS = PS#player_status{weekly_card_status = NewWeeklyCardStatus},
            lib_log_api:log_weekly_card_info(RoleId, Lv, Lv, Exp, Exp, CanReceiveGift, GiftBagNum, GiftBagNum, CanReceiveGift, NewRewardList),
            lib_weekly_card_sql:db_replace_weekly_card_info(RoleId, NewWeeklyCardStatus),
            %% 第一次有数据时，发送红点提醒
            length(RewardList) =:= 0 andalso length(NewRewardList) =/= 0 andalso send_reward_list_red_point(NewPS),
            {ok, NewPS}
    end.

%% -----------------------------------------------------------------
%% @desc 补发礼包
%% @param RoleId
%% @param CanReceiveGift
%% @return
%% -----------------------------------------------------------------
reissue_gift_bag(RoleId, CanReceiveGift) ->
    {Type, GoodsId, Num} = ?WEEKLY_CARD_GIFT_BAG,
    RewardList = [{Type, GoodsId, Num * CanReceiveGift}],
    Title = utext:get(4520001, []),
    Content = utext:get(4520002, []),
    CanReceiveGift =/= 0 andalso mod_mail_queue:add(?MOD_WEEKLY_CARD, [RoleId], Title, Content, RewardList).

%% -----------------------------------------------------------------
%% @desc 激活周卡补发奖励
%% @param
%% @return
%% -----------------------------------------------------------------
reissue_reward_list(_PS, RewardList) ->
    F = fun({_Type, Rewards}, RewardListA) -> Rewards ++ RewardListA end,
    lists:foldl(F, [], RewardList).

%% -----------------------------------------------------------------
%% @desc  构造周卡记录
%% @param WeeklyCardStatus 周卡记录
%% @param Lv               等级
%% @param Exp              经验
%% @param IsActivity       是否激活
%% @param NewGiftBagNum    已领取礼包数量
%% @param CanReceiveGift   可领取礼包数量
%% @param ExpiredTime      过期时间
%% @return #weekly_card_status{}
%% -----------------------------------------------------------------
make_weekly_card_status(WeeklyCardStatus, Lv, Exp, IsActivity, GiftBagNum, CanReceiveGift, ExpiredTime, RewardList) ->
   WeeklyCardStatus#weekly_card_status{
        lv               = Lv,
        exp              = Exp,
        is_activity      = IsActivity,
        gift_bag_num     = GiftBagNum,
        can_receive_gift = CanReceiveGift,
        expired_time     = ExpiredTime,
        reward_list      = RewardList
    }.

%% -----------------------------------------------------------------
%% @desc 合并补发奖励
%% @param RewardList 奖励列表
%% @return [{Type, GoodsId, Num},...]
%% -----------------------------------------------------------------
get_weekly_card_merge_reward_list([]) -> [];
get_weekly_card_merge_reward_list(RewardList) ->
    RewardListA = hd(RewardList),
    FA = fun({Type, GoodsId, Num}, NewRewardListA) ->
        [{Type, GoodsId, Num * length(RewardList)} | NewRewardListA]
    end,
    lists:reverse(lists:foldl(FA, [], RewardListA)).

%% -----------------------------------------------------------------
%% @desc 增加周卡经验
%% @param PS
%% @param AddExp
%% @return NewPS
%% -----------------------------------------------------------------
gm_add_exp(PS, AddExp) ->
    #player_status{id = RoleId, weekly_card_status = WeeklyCardStatus} = PS,
    #weekly_card_status{lv = Lv, exp = Exp, is_activity = IsActivity} = WeeklyCardStatus,
    if
        IsActivity =:= ?ACTIVATION_CLOSE -> PS;
        true ->
            {NewLv, NewExp} = get_newest_lv_exp(Lv, Exp + AddExp),
            NewWeeklyCardStatus = WeeklyCardStatus#weekly_card_status{lv = NewLv, exp = NewExp},
            NewPS = PS#player_status{weekly_card_status = NewWeeklyCardStatus},
            lib_weekly_card_sql:db_replace_weekly_card_info(RoleId, NewWeeklyCardStatus),
            send_weekly_card_info(NewPS),
            NewPS
    end.

%% -----------------------------------------------------------------
%% @desc 重置周卡
%% @param PS
%% @return NewPS
%% -----------------------------------------------------------------
gm_expired_weekly_card(PS) ->
    #player_status{id = RoleId} = PS,
    NewPS = PS#player_status{weekly_card_status = #weekly_card_status{}},
    lib_weekly_card_sql:db_replace_weekly_card_info(RoleId, #weekly_card_status{}),
    send_weekly_card_info(NewPS),
    NewPS.

%% -----------------------------------------------------------------
%% @desc 修改周卡过期时间（过期时间第二天凌晨4点）
%% @param PS
%% @return NewPS
%% -----------------------------------------------------------------
gm_update_expired_weekly_card(PS) ->
    #player_status{id = RoleId, weekly_card_status = WeeklyCardStatus, figure = #figure{lv = RoleLv}} = PS,
    #weekly_card_status{expired_time = ExpiredTime} = WeeklyCardStatus,
    NewExpiredTime = utime:get_next_unixdate_four(ExpiredTime),
    NewWeeklyCardStatus = WeeklyCardStatus#weekly_card_status{expired_time = NewExpiredTime},
    lib_weekly_card_sql:db_replace_weekly_card_info(RoleId, NewWeeklyCardStatus),
    lib_log_api:log_weekly_card_open(RoleId, RoleLv, NewExpiredTime),
    NewPS = PS#player_status{weekly_card_status = NewWeeklyCardStatus},
    send_weekly_card_info(NewPS),
    NewPS.

filter_zero_num_reward(RewardL) ->
    Pre = fun({_Type, _GoodsId, Num}) -> Num > 0 end,
    lists:filter(Pre, RewardL).