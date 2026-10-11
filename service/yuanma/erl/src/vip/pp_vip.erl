%%%===================================================================
%%% @author z.hua
%%% @doc
%%%
%%% @end
%%%===================================================================

-module(pp_vip).

-include("server.hrl").
-include("vip.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("def_fun.hrl").

%% API
-export([handle/3]).

%%%-------------------------------------------------------------------
%%% API Functions
%%%-------------------------------------------------------------------
%% 查看VIP信息
handle(45000, Player, _) ->
    #role_vip{
        vip_lv = VipLv,
        vip_exp = VipExp0,
        vip_hide = VipHide,
        fetched_list = FetchedList,
        week_list = WeekList} = Player#player_status.vip,
    case data_vip:get(VipLv + 1) of
        #data_vip{need_gold = NeedExp} ->
            VipExp = VipExp0;
        _ ->
            VipExp = NeedExp = 0
    end,
    CanGetWeekList =
        case VipLv > 0 of
            true -> lib_vip:week_list_filter(VipLv, WeekList);
            false -> []
        end,
    {UseCardList, NewPlayer} = lib_vip:get_use_card_list(Player),
    % ?PRINT("45000vip========================WeekList,~p~n CanGetWeekList:~p~n", [WeekList, CanGetWeekList]),

	% ?PRINT("45000vip========================~p~n", [{VipLv, util:floor(VipExp / ?VIP_CONVERT), NeedExp, FetchedList, CanGetWeekList, UseCardList}]),
    {ok, Bin} = pt_450:write(45000, [VipLv, util:floor(VipExp / ?VIP_CONVERT), NeedExp, VipHide, FetchedList, CanGetWeekList, UseCardList]),
    lib_server_send:send_to_sid(Player#player_status.sid, Bin),
    {ok, NewPlayer};

%% 领取VIP奖励
handle(45001, Player = #player_status{id = RoleID, sid = Sid, vip = RoleVip}, [FetchLv]) ->
    case check_fetch_reward(RoleVip, FetchLv) of
        {error, _Err} ->
            {ok, Bin} = pt_450:write(45001, [?ERRCODE(err505_condition_not_enough)]),
            lib_server_send:send_to_sid(Sid, Bin),
            {ok, Player};
        ok ->
            NewList = [FetchLv | RoleVip#role_vip.fetched_list],
            Sql = io_lib:format(?UPDATE_VIP_REWARD, [util:term_to_string(NewList), RoleID]),
            db:execute(Sql),
            #data_vip{rewards = Rewards, reward_cost = Cost} = data_vip:get(FetchLv),
            case lib_goods_api:cost_object_list_with_check(Player, Cost, vip_lv_reward_cost, "") of
                {true, NewPS} ->
                    NewRewards =
                        case lists:keyfind(design, 1, Rewards) of
                            false -> % 没有称号奖励
                                Rewards;
                            {design, _DesignId} ->
                                lists:keydelete(design, 1, Rewards)
                        end,
                    Produce = #produce{type = vip_reward, reward = NewRewards, show_tips = 3},
                    NewPlayer1 = lib_goods_api:send_reward(NewPS, Produce),
                    {ok, Bin} = pt_450:write(45001, [?ERR_REWARD_SUCC]),
                    lib_server_send:send_to_sid(Sid, Bin),
                    {ok, NewPlayer1#player_status{vip = RoleVip#role_vip{fetched_list = NewList}}};
                {false, Err, _} ->
                    {ok, Bin} = pt_450:write(45001, [Err]),
                    lib_server_send:send_to_sid(Sid, Bin),
                    {ok, Player}
            end
    end;

%% 领取周礼包
handle(45002, Player = #player_status{id = RoleID, sid = Sid, vip = RoleVip}, [Viplv]) ->
    case lists:member(Viplv, data_vip:get_all_vip_lv()) of
        true ->
            case check_fetch_week_reward(RoleVip, Viplv) of
                {ok, #data_vip{week_rewards = WeekRewards}, NewWeekList} ->
                    Sql = io_lib:format(?UPDATE_VIP_WEEK_REWARD, [util:term_to_string(NewWeekList), RoleID]),
                    db:execute(Sql),
                    Produce = #produce{type = vip_weekly_reward, reward = WeekRewards, show_tips = 3},
                    NewPlayer = lib_goods_api:send_reward(Player, Produce),
                    ?PRINT("45002 ok ~n", []),
                    {ok, Bin} = pt_450:write(45002, [?ERR_WEEK_REWARD_SUCC]),
                    lib_server_send:send_to_sid(Sid, Bin),
                    {ok, NewPlayer#player_status{vip = RoleVip#role_vip{week_list = NewWeekList}}};
                {error, Err} ->
                    ?PRINT("45002 Err:~p~n", [Err]),
                    {ok, Bin} = pt_450:write(45002, [Err]),
                    lib_server_send:send_to_sid(Sid, Bin),
                    {ok, Player}
            end;
        false ->
            {ok, Bin} = pt_450:write(45002, [?ERRCODE(err450_vip_lv)]),
            lib_server_send:send_to_sid(Sid, Bin)
    end;

%% 购买特权卡
handle(45003, Player, [VipType]) ->
    {ok, NewPlayer} = lib_vip:buy_vip_card(Player, VipType),
    {ok, NewPlayer};

%% 特权卡信息
handle(45004, #player_status{sid = Sid} = Player, []) ->
    NowTime = utime:unixtime(),
    #role_vip{vip_card_list = CardList} = Player#player_status.vip,
    VipTypeList = data_vip:get_vip_type_list(),
    F = fun(VipType) ->
        case lists:keyfind(VipType, #vip_card.vip_type, CardList) of
            #vip_card{} = Card -> skip;
            _ -> Card = #vip_card{vip_type = VipType}
        end,
        #vip_card{vip_type = VipType, forever = Forever, end_time = EndTime, is_temp_card = IsTempCard} = Card,
        Enable = ?IF(Forever == 1 orelse EndTime > NowTime, 1, 0),
        {VipType, IsTempCard, Enable, Forever, EndTime}
        end,
    Packet = lists:map(F, VipTypeList),
    %%    ?PRINT("=======================~w~n", [Packet]),
    {ok, Bin} = pt_450:write(45004, [Packet]),
    lib_server_send:send_to_sid(Sid, Bin),
    ok;

%% 领取免费特权卡
handle(45007, #player_status{sid = Sid} = Player, [VipType]) ->
    {UseCardList, NewPlayer} = lib_vip:get_use_card_list(Player),
    case lists:keyfind(VipType, 1, UseCardList) of
        {VipType, 1} ->
            {ok, _NewPlayer1} = lib_vip:receive_vip_card(NewPlayer, VipType);
        {VipType, 2} ->
            {ok, Bin} = pt_450:write(45007, [?ERRCODE(err450_had_free_card)]),
            lib_server_send:send_to_sid(Sid, Bin),
            {ok, NewPlayer};
        _ ->
            {ok, Bin} = pt_450:write(45007, [?ERRCODE(err450_have_not_cond)]),
            lib_server_send:send_to_sid(Sid, Bin),
            {ok, NewPlayer}
    end;

%% 隐藏vip
handle(45008, Player, [Hide]) when Hide == 0; Hide == 1 ->
    NewPlayer = lib_vip:hide_vip(Player, Hide),
    {ok, NewPlayer};

handle(_Cmd, Status, _R) ->
    ?ERR("~p, ~p, Cmd:~p, Recv:~p~n", [?MODULE, ?LINE, _Cmd, _R]),
    {ok, Status}.

%%%-------------------------------------------------------------------
%%% Internal Functions
%%%-------------------------------------------------------------------
check_fetch_reward(#role_vip{vip_lv = VipLv, fetched_list = FetchedList}, FetchLv) ->
    case FetchLv =< 0 orelse FetchLv > VipLv of
        true ->
            {error, ?ERR_REWARD_VIPLV_LIMIT};
        false ->
            case lists:member(FetchLv, FetchedList) of
                true ->
                    {error, ?ERR_REWARD_FETCHED};
                false ->
                    ok
            end
    end.

check_fetch_week_reward(RoleVip, Lv) ->
    #role_vip{vip_lv = VipLv, week_list = WeekList} = RoleVip,
    NowTime = utime:unixtime(),
    CanGetList = lib_vip:week_list_filter(VipLv, WeekList),
    case lists:member(Lv, CanGetList) of
        true ->
            {Lv, UnLockTime, _LastGetTime} = lists:keyfind(Lv, 1, WeekList),
            DataVip = data_vip:get(Lv),
            NewWeekList = lists:keystore(Lv, 1, WeekList, {Lv, UnLockTime, NowTime}),
            {ok, DataVip, NewWeekList};
        false ->
            {error, ?ERR_WEEK_REWARD_FETCHED}
    end.
