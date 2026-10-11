%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%             勾玉祈愿抽奖
%%% @end
%%% Created : 26. 7月 2022 16:27
%%%-------------------------------------------------------------------
-module(lib_custom_act_wish_draw).
-author("xzj").

-include("custom_act.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("common.hrl").

%% API
-export([
    handle_recharge/3
    , get_wish_draw_data/3
    , send_wish_draw_info/3
    , send_reward_cfg_by_turn/4
    , start_draw/3
    , get_free_gift/3
]).

%% 充值触发
handle_recharge(Player, Product, Gold) ->
    RealGold = lib_recharge_api:special_recharge_gold(Product, Gold),
    IsTrigger = lib_recharge_api:is_trigger_recharge_act(Product),
    if
        RealGold > 0 andalso IsTrigger ->
            TypeList = [?CUSTOM_ACT_TYPE_WISH_DRAW],
            F = fun(Type, List) ->
                [{Type, SubType}||SubType<-lib_custom_act_util:get_subtype_list(Type)] ++ List
                end,
            KeyList = lists:foldl(F, [], TypeList),
            F2 = fun({Type, SubType}, TmpPlayer) ->
                handle_recharge_do(TmpPlayer, Type, SubType)
                 end,
            lists:foldl(F2, Player, KeyList);
        true ->
            Player
    end.

handle_recharge_do(Player, Type, SubType) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            Key = {Type, SubType},
            WishDrawAct = #wish_draw_act{
                free_times = _FreeTimes,
                recharge_time = RechargeTime,
                turn = Turn
            } = get_wish_draw_data(Player, Type, SubType),
            Now = utime:unixtime(),
            #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            {_, TurnTimesList} = lists:keyfind(turn_frequency, 1, Condition),
            {_, FreeOpen} = ulists:keyfind(free_open, 1, Condition, {free_open, 1}),
            CheckOpen = ?IF(FreeOpen == 1, true, false),
            CheckTurn =
                case lists:keyfind(Turn, 1, TurnTimesList) of
                    false -> false;
                    _ -> true
                end,
            case not utime:is_same_day(RechargeTime, Now) andalso CheckTurn andalso CheckOpen of
                true ->
                    NewWishDrawAct = WishDrawAct#wish_draw_act{free_times = 1, recharge_time = Now, utime = Now},
                    ActData = #custom_act_data{id = Key, type = Type, subtype = SubType, data = NewWishDrawAct},
                    PSAfSave = lib_custom_act:save_act_data_to_player(Player, ActData),
                    send_wish_draw_info(PSAfSave, Type, SubType),
                    PSAfSave;
                _ ->
                    Player
            end;
        false ->
            Player
    end.

%% 获取祈愿活动数据
get_wish_draw_data(Player, Type, SubType) ->
    case lib_custom_act:act_data(Player, Type, SubType) of
        #custom_act_data{data = Data} ->
            NewData = case Data of
                          #wish_draw_act{utime = UTime} = Data -> Data;
                          _ ->
                              UTime = utime:unixtime(),
                              #wish_draw_act{utime = UTime}
                      end,
            case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
                #act_info{stime = Stime, etime = Etime} when UTime >= Stime, UTime =< Etime ->
                    case lib_custom_act_util:in_same_clear_day(Type, SubType, Etime, UTime) of
                        true -> NewData;
                        false -> #wish_draw_act{}
                    end;
                _ ->
                    #wish_draw_act{}
            end;
        _ ->
            #wish_draw_act{}
    end.

%% 领取免费每日礼包
get_free_gift(Ps, Type, SubType) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            Key = {Type, SubType},
            WishDrawAct = #wish_draw_act{
                free_gift_time = FreeGiftTime
            } = get_wish_draw_data(Ps, Type, SubType),
            Now = utime:unixtime(),
            case utime:is_same_day(FreeGiftTime, Now) of
                true -> {false, ?ERRCODE(reward_is_got)};
                _ ->
                    NewWishDrawAct = WishDrawAct#wish_draw_act{free_gift_time = Now, utime = Now},
                    ActData = #custom_act_data{id = Key, type = Type, subtype = SubType, data = NewWishDrawAct},
                    PSAfSave = lib_custom_act:save_act_data_to_player(Ps, ActData),
                    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
                    {_, Reward} = ulists:keyfind(gift, 1, Condition, {gift, []}),
                    NewPlayer = lib_goods_api:send_reward(PSAfSave, Reward, act_wish_draw, 0),
                    lib_log_api:log_custom_act_reward(PSAfSave, Type, SubType, 0, Reward),
                    {ok, BinData} = pt_332:write(33263, [Type, SubType, ?SUCCESS]),
                    lib_server_send:send_to_sid(NewPlayer#player_status.sid, BinData),
                    {ok, NewPlayer}
            end;
        _ -> {false, ?ERRCODE(err512_act_close)}
    end.

%% 发送祈愿活动界面信息
send_wish_draw_info(Ps, Type, SubType) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            #wish_draw_act{turn = Turn, times = Times, free_times = FreeTimes, recharge_time = RechargeTime,
                free_gift_time = FreegiftTime} = get_wish_draw_data(Ps, Type, SubType),
            FreeStatus =
                case utime:is_same_day(FreegiftTime, utime:unixtime()) of
                    true -> ?ACT_REWARD_HAS_GET;
                    _ -> ?ACT_REWARD_CAN_GET
                end,
            RechargeStatus =
                case utime:is_same_day(RechargeTime, utime:unixtime()) of
                    true -> 1;
                    _ -> 0
                end,
            {ok, BinData} = pt_332:write(33260, [Type, SubType, FreeTimes, RechargeStatus, Turn, Times, FreeStatus]),
            lib_server_send:send_to_sid(Ps#player_status.sid, BinData);
        _ -> skip
    end.

%% 根据轮次发送配置
send_reward_cfg_by_turn(Ps, Type, SubType, Turn) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            RewardCfgList = get_reward_cfg_by_turn(Type, SubType, Turn),
            SendList = [{Grade, Name, Desc, util:term_to_string(Conditions), util:term_to_string(Reward)} ||
                            #custom_act_reward_cfg{condition = Conditions,
                                grade = Grade, name = Name, desc = Desc, reward = Reward} <- RewardCfgList],
            {ok, BinData} = pt_332:write(33261, [Type, SubType, Turn, SendList]),
            lib_server_send:send_to_sid(Ps#player_status.sid, BinData);
        _ ->
            skip
    end.

%% 根据轮次获取配置列表
get_reward_cfg_by_turn(Type, SubType, Turn) ->
    Ids = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    RewardCfgList = filter_id_by_turn(Ids, Type, SubType, Turn, []),
    RewardCfgList.

filter_id_by_turn([], _Type, _SubType, _Turn, L) -> L;
filter_id_by_turn([Id | N], Type, SubType, Turn, L) ->
    #custom_act_reward_cfg{condition = RConditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, Id),
    case lists:keyfind(turn, 1, RConditions) of
        {turn, Turn} ->
            filter_id_by_turn(N, Type, SubType, Turn, [RewardCfg | L]);
        _ ->
            filter_id_by_turn(N, Type, SubType, Turn, L)
    end.

%% 进行抽奖
start_draw(Ps, Type, SubType) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            WishDrawAct = #wish_draw_act{free_times = FreeTimes, turn = Turn,
                times = Times} = get_wish_draw_data(Ps, Type, SubType),
            #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            {_, TurnTimesList} = lists:keyfind(turn_frequency, 1, Condition),
            case lists:keyfind(Turn, 1, TurnTimesList) of
                {_, ChangeTimes} ->
                    case check_draw(Ps, Type, SubType) of
                        {true, CostPs} ->
                            GradeList = get_reward_cfg_by_turn(Type, SubType, Turn),
                            F = fun(GradeCfg, Acc) ->
                                #custom_act_reward_cfg{condition = Con} = GradeCfg,
                                {_, WeightValue} = lists:keyfind(weight, 1, Con),
                                [{WeightValue, GradeCfg} | Acc]
                                end,
                            WeightList = lists:foldl(F, [], GradeList),
                            RewardCfg = urand:rand_with_weight(WeightList),
                            #custom_act_reward_cfg{grade = GradeId, reward = Reward, condition = Conditon1} = RewardCfg,
                            {_, Multiple} = ulists:keyfind(times, 1, Conditon1, {times, 1}),
                            RealReward = [{K1, K2, Num * Multiple} || {K1, K2, Num} <- Reward],
                            NewFreeTimes = ?IF(FreeTimes > 0, FreeTimes - 1, FreeTimes),
                            {NewTurn, NewTimes} = ?IF(Times + 1 == ChangeTimes, {Turn + 1, 0}, {Turn, Times + 1}),
                            NewWishDrawAct = WishDrawAct#wish_draw_act{free_times = NewFreeTimes, turn = NewTurn, times = NewTimes, utime = utime:unixtime()},
                            ActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = NewWishDrawAct},
                            PSAfSave = lib_custom_act:save_act_data_to_player(CostPs, ActData),
                            lib_log_api:log_custom_act_reward(PSAfSave, Type, SubType, GradeId, RealReward),
                            NewPlayer = lib_delay_reward:set_delay_reward(PSAfSave, 33262, RealReward),
                            {ok, BinData} = pt_332:write(33262, [Type, SubType, GradeId, NewTurn, NewTimes, ?SUCCESS]),
                            lib_server_send:send_to_sid(NewPlayer#player_status.sid, BinData),
                            send_tv(NewPlayer, RewardCfg, RealReward),
                            {true, NewPlayer};
                        {false, Err, _Ps} ->
                            {false, Err}
                    end;
                _ ->
                    {false, ?FAIL}
            end;
        _ ->
            {false, ?ERRCODE(err512_act_close)}
    end.

%% 检查是否能抽奖
check_draw(Ps, Type, SubType) ->
    #player_status{figure = #figure{lv = Lv}} = Ps,
    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    #wish_draw_act{free_times = FreeTimes, turn = Turn} = get_wish_draw_data(Ps, Type, SubType),
    {_, CheckLv} = ulists:keyfind(role_lv, 1, Condition, {role_lv, 0}),
    {_, PriceList} = ulists:keyfind(price, 1, Condition, {price, []}),
    {_, Cost} = ulists:keyfind(Turn, 1, PriceList, {Turn, []}),
    if
        CheckLv > Lv ->
            {false, ?ERRCODE(err144_lv_not_enough), Ps};
        FreeTimes < 1 ->
            Results = lib_goods_api:cost_object_list_with_check(Ps, Cost, act_wish_draw, ""),
            lib_log_api:log_custom_act_cost(Ps#player_status.id, Type, SubType, Cost, []),
            Results;
        true ->
            lib_log_api:log_custom_act_cost(Ps#player_status.id, Type, SubType, [], []),
            {true, Ps}
    end.

%% 发送传闻
send_tv(#player_status{id = Id, figure = #figure{name = Name}}, RewardCfg, RealReward) ->
    #custom_act_reward_cfg{type = Type, subtype = SubType, condition = RConditions} = RewardCfg,
    mod_msg_cache_queue:update_queue(Id, 33262, {save_role_log_and_notice, Id, Type, SubType, Name, RealReward}, record),
    case lists:keyfind(is_rare, 1, RConditions) of
        {is_rare, 1} ->
            [{_, GoodsId, GoodsNum}|_] = RealReward,
            mod_msg_cache_queue:update_queue(Id, 33262, {?MOD_AC_CUSTOM, 74, [Name, Id, GoodsId, GoodsNum, Type, SubType]}, tv);
        _ -> skip
    end,
    ok.


