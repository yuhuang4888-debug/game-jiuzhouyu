%%%-------------------------------------------------------------------
%%% @author lianghaihui
%%% 循环冲榜的充值活动
%%% @end
%%% Created : 27. 6月 2022 14:13
%%%-------------------------------------------------------------------
-module(lib_custom_cycle_rank).

-include("server.hrl").
-include("custom_act.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("rec_recharge.hrl").
-include("def_recharge.hrl").
-include("def_fun.hrl").


%% API
-export([
    act_end/2,
    login/1,
    send_reward_status/3,
    handle_event/2,
    get_act_rewards/4,
    settlement_act_data/3
]).

-export([
    gm_refresh_act_start_before/1,
    return_data_online/2,
    return_data_offline/2,
    repair_recharge_error_type/0,
    repair_recharge_error_type_online/2,
    repair_recharge_error_type_offline/2
]).

%% ========================================
%% API
%% ========================================

%% 活动结束清算数据
act_end(ActType, SubType) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() ->
        [begin
             timer:sleep(500),
             lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, settlement_act_data, [ActType, SubType])
         end || E <- OnlineRoles
        ]
    end).

%% 登录时候结算玩家数据
login(Player) ->
    ActType = ?CUSTOM_ACT_CYCLE_RANK_RECHARGE,
    AllSubType = lib_custom_act_util:get_subtype_list(ActType),
    NowSec = utime:unixtime(),
    Fun = fun(SubType, TemPlayer) ->
        case get_act_data(TemPlayer, ActType, SubType, 0) of
            #cycle_rank_recharge{ money = Money, reward_ids = RewardIds, end_time = EndTime } when NowSec >= EndTime ->
                do_settlement_act_data(TemPlayer, ActType, SubType, Money, RewardIds);
            _ ->
                TemPlayer
        end
    end,
    lists:foldl(Fun, Player, AllSubType).

%% 发送面板信息
send_reward_status(Player, ActType, SubType) ->
    #player_status{ id = PlayerId } = Player,
    WorldLv = util:get_world_lv(),
    case get_act_data(Player, ActType, SubType, 1) of
        #cycle_rank_recharge{ money = Money, reward_ids = RewardIds } ->
            AllRewardId = lib_custom_act_util:get_act_reward_grade_list(ActType, SubType),
            Fun = fun(RewardId, AccL) ->
                case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, RewardId) of
                    #custom_act_reward_cfg{ name = Name, format = Format, desc = Desc, condition = ConditionL, reward = RewardList } ->
                        ConditionStr = util:term_to_string(ConditionL),
                        {_, NeedNum} = ulists:keyfind(gold, 1, ConditionL, {gold, 0}),
                        IsGet = lists:member(RewardId, RewardIds),
                        if
                            IsGet ->
                                Times = 1,
                                RewardState = ?ACT_REWARD_HAS_GET;
                            Money >= NeedNum ->
                                Times = 0,
                                RewardState = ?ACT_REWARD_CAN_GET;
                            true ->
                                Times = 0,
                                RewardState = ?ACT_REWARD_CAN_NOT_GET
                        end,
                        Fun2 = fun({CfgWorldLv, _}) -> WorldLv >= CfgWorldLv end,
                        Filter = lists:filter(Fun2, RewardList),
                        case Filter of
                            [] -> RewardL = [];
                            _ ->
                                {_CfgLv, RewardL} = lists:last(Filter)
                        end,
                        RewardStr = util:term_to_string(RewardL),
                        [{RewardId, Format, RewardState, Times, Name, Desc, ConditionStr, RewardStr}|AccL];
                    _ ->
                        AccL
                end
            end,
            SendList = lists:foldl(Fun, [], AllRewardId),
            %% ?MYLOG("lhh_charge", "NewData:~p", [{ActType, SubType, SendList}]),
            {ok, BinData} = pt_331:write(33104, [ActType, SubType, SendList]),
            lib_server_send:send_to_uid(PlayerId, BinData);
        _ ->
            ?ERR("h5_error_request Type:~p//SubType:~p", [ActType, SubType])
    end.

%% 充值回调
handle_event(Player, #event_callback{ type_id = ?EVENT_RECHARGE, data = CallBackData }) ->
    case CallBackData of
        #callback_recharge_data{recharge_product = Product, gold = Gold} ->
            case lib_recharge_api:is_trigger_recharge_act(Product) of
                true ->
                    RealGold = lib_recharge_api:special_recharge_gold(Product, Gold),
                    LastPlayer = ?IF(RealGold > 0, do_handle_event(Player, Gold), Player);
                _ ->
                    LastPlayer = Player
            end;
        _ ->
            LastPlayer = Player
    end,
    {ok, LastPlayer};
handle_event(Player, _) ->
    {ok, Player}.

%% -------------------------------------------------------------------------------------------------
%% @doc 领取活动奖励
%% -------------------------------------------------------------------------------------------------    
get_act_rewards(Player, ActType, SubType, GradeId) ->
    #player_status{ id = PlayerId, figure = #figure{ name = RoleName } } = Player,
    case get_act_data(Player, ActType, SubType, 0) of
        #cycle_rank_recharge{ money = Money, reward_ids = RewardIds } = Data ->
            case check_can_get_reward(Money, ActType, SubType, GradeId, RewardIds) of
                {ok, RewardList, IsTv} ->
                    NewData = Data#cycle_rank_recharge{ reward_ids = [GradeId|RewardIds] },
                    ActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData },
                    lib_custom_act:db_save_custom_act_data(PlayerId, ActData),
                    NewPlayer = lib_custom_act:save_act_data_to_player(Player, ActData),
                    Product = #produce{type = cycle_rank_accumulated, subtype = SubType, reward = RewardList, show_tips = ?SHOW_TIPS_4},
                    LastPlayer = lib_goods_api:send_reward(NewPlayer, Product),
                    lib_log_api:log_custom_act_reward(PlayerId, ActType, SubType, GradeId, RewardList),
                    {ok, Bin} = pt_331:write(33105, [?SUCCESS, ActType, SubType, GradeId]),
                    lib_server_send:send_to_uid(PlayerId, Bin),
                    send_reward_status(LastPlayer, ActType, SubType),
                    IsTv =/= 0 andalso lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 72, [RoleName, ActType, SubType]),
                    {ok, LastPlayer};
                {error, Code} ->
                    {ok, Bin} = pt_331:write(33105, [Code, ActType, SubType, GradeId]),
                    lib_server_send:send_to_uid(PlayerId, Bin),
                    {ok, Player}
            end;
        _ ->
            Code = ?ERRCODE(err331_can_not_recieve),
            {ok, Bin} = pt_331:write(33105, [Code, ActType, SubType, GradeId]),
            lib_server_send:send_to_uid(PlayerId, Bin),
            {ok, Player}
    end.

%% ==================================
%% inner_function
%% ==================================

do_handle_event(Player, AddMoney) ->
    ActType = ?CUSTOM_ACT_CYCLE_RANK_RECHARGE,
    #player_status{ id = PlayerId } = Player,
    OpenSubTypeL = lib_custom_act_api:get_open_subtype_ids(ActType),
    Fun = fun(SubType, TemPlayer) ->
        case get_act_data(TemPlayer, ActType, SubType, 1) of
            #cycle_rank_recharge{ money = HasMoney } = Data ->
                NewData = Data#cycle_rank_recharge{ money = HasMoney + AddMoney },
                ActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData },
                lib_custom_act:db_save_custom_act_data(PlayerId, ActData),
                NewTemPlayer = lib_custom_act:save_act_data_to_player(TemPlayer, ActData),
                %% ?MYLOG("lhh_charge", "NewData:~p", [NewData]),
                send_reward_status(NewTemPlayer, ActType, SubType),
                NewTemPlayer;
            _ ->
                TemPlayer
        end
    end,
    lists:foldl(Fun, Player, OpenSubTypeL).

%% 活动结束时结算在线玩家的数据
settlement_act_data(Player, ActType, SubType) ->
    case get_act_data(Player, ActType, SubType, 0) of
        #cycle_rank_recharge{ money = Money, reward_ids = RewardIds} ->
            do_settlement_act_data(Player, ActType, SubType, Money, RewardIds);
        _ ->
            Player
    end.

%% 结算的主要逻辑
do_settlement_act_data(Player, ActType, SubType, Money, RewardIds) ->
    #player_status{ id = PlayerId } = Player,
    WorldLv = util:get_world_lv(),
    AllRewardIds = lib_custom_act_util:get_act_reward_grade_list(ActType, SubType),
    Fun = fun(RewardId, AccRewardL) ->
        case lists:member(RewardId, RewardIds) of
            true ->
                AccRewardL;
            false ->
                #custom_act_reward_cfg{
                    condition = Condition, reward = RewardList
                } = lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, RewardId),
                {_, NeedNum} = ulists:keyfind(gold, 1, Condition, {gold, 0}),
                case Money >= NeedNum of
                    true ->
                        Fun2 = fun({CfgWorldLv, _}) -> WorldLv >= CfgWorldLv end,
                        Filter = lists:filter(Fun2, RewardList),
                        case Filter of
                            [] ->
                                AccRewardL;
                            _ ->
                                {_CfgLv, AddRewardL} = lists:last(Filter),
                                AddRewardL ++ AccRewardL
                        end;
                    false ->
                        AccRewardL
                end
        end
    end,
    SendRewardL = lists:foldl(Fun, [], AllRewardIds),
    NewPlayer = lib_custom_act:delete_act_data_to_player_without_db(Player, ActType, SubType),
    lib_custom_act:db_delete_custom_act_data(Player, ActType, SubType),
    case SendRewardL of
        [] -> skip;
        _ ->
            Title = utext:get(3310119),
            Content = utext:get(3310120),
            lib_mail_api:send_sys_mail([PlayerId], Title, Content, lib_goods_api:make_reward_unique(SendRewardL))
    end,
    NewPlayer.

get_act_data(Player, ActType, SubType, IsSend) ->
    case lib_custom_act:act_data(Player, ActType, SubType) of
        #custom_act_data{ data = Data } ->
            Data;
        _ ->
            case IsSend of
                1 ->
                    case lib_custom_act_util:get_custom_act_open_info(ActType, SubType) of
                        #act_info{etime = EndTime} -> #cycle_rank_recharge{ end_time = EndTime };
                        _ -> undefined
                    end;
                _ -> undefined
            end
    end.

check_can_get_reward(Money, ActType, SubType, GradeId, RewardIds) ->
    case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, GradeId) of
        #custom_act_reward_cfg{ condition = ConditionL, reward = RewardList } ->
            case lists:member(GradeId, RewardIds) of
                true ->
                    {error, ?ERRCODE(err331_already_get_reward)};
                _ ->
                    {_, NeedNum} = ulists:keyfind(gold, 1, ConditionL, {gold, 0}),
                    if
                        Money < NeedNum ->
                            {error, ?ERRCODE(err331_stage_not_achieve)};
                        true ->
                            WorldLv = util:get_world_lv(),
                            Fun2 = fun({CfgWorldLv, _}) -> WorldLv >= CfgWorldLv end,
                            Filter = lists:filter(Fun2, RewardList),
                            case Filter of
                                [] ->
                                    {error, ?ERRCODE(err331_no_act_reward_cfg)};
                                _ ->
                                    {_CfgLv, RewardL} = lists:last(Filter),
                                    {_, IsTv} = ulists:keyfind(is_tv, 1, ConditionL, {is_tv, 0}),
                                    {ok, RewardL, IsTv}
                            end
                    end
            end;
        _ ->
            {error, ?ERRCODE(err331_no_act_reward_cfg)}
    end.

gm_refresh_act_start_before(Type) ->
    NowSec = utime:unixtime(),
    TodayZero = utime:unixdate(NowSec),
    Sql =
        case Type of
            1 ->
                io_lib:format(<<"select player_id, product_id, money, gold  from recharge_log where type = 1 and time > ~p and time < ~p">>, [TodayZero, NowSec]);
            2 ->
                io_lib:format(<<"select player_id, product_id, money, gold  from recharge_log where type != 1 and time > ~p and time < ~p">>, [TodayZero, NowSec]);
            3 ->
                io_lib:format(<<"select player_id, product_id, money, gold  from recharge_log where time > ~p and time < ~p">>, [TodayZero, NowSec])
        end,
    List = db:get_all(Sql),
    case List of
        [] -> skip;
        _ ->
            Fun = fun([RoleId, ProductId, Money, _Gold], AccL) ->
                case data_recharge:get_product(ProductId) of
                    #base_recharge_product{ product_type = ProDuctType } when ProDuctType == ?PRODUCT_TYPE_NORMAL orelse ProDuctType == ?PRODUCT_TYPE_DIRECT_GIFT ->
                        {RoleId, OldSumMoney} = ulists:keyfind(RoleId, 1, AccL, {RoleId, 0}),
                        lists:keystore(RoleId, 1, AccL, {RoleId, OldSumMoney + round(Money)});
                    _ ->
                        AccL
                end
            end,
            NeedHandlePlayerList = lists:foldl(Fun, [], List),
            HandleFun = fun({RoleId, SumMoney}) ->
                Pid = misc:get_player_process(RoleId),
                case is_pid(Pid) andalso misc:is_process_alive(Pid) of
                    true ->
                        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, return_data_online, [SumMoney]);
                    false ->
                        ?INFO("RoleID:~p//SumMoneu:~p", [RoleId, SumMoney]),
                        return_data_offline(RoleId, SumMoney*10)
                end,
                timer:sleep(1000)
            end,
            spawn(fun() ->
                lists:foreach(HandleFun, NeedHandlePlayerList)
            end),
            NeedHandlePlayerList
    end.

return_data_online(Player, SumMoney) ->
    do_handle_event(Player, SumMoney * 10).

return_data_offline(RoleId, SumMoney) ->
    ActType = ?CUSTOM_ACT_CYCLE_RANK_RECHARGE,
    OpenSubTypeL = lib_custom_act_api:get_open_subtype_ids(ActType),
    Sql = io_lib:format(<<"select `type`, `subtype`, `data_list` from`custom_act_data` where `player_id`=~p and `type` = 124">>, [RoleId]),
    ActDataList = [ erlang:list_to_tuple(I) || I <- db:get_all(Sql)],
    Fun = fun(SubType) ->
        StrData = lists:keyfind(SubType, 2, ActDataList),
        case StrData of
            false ->
                case lib_custom_act_util:get_custom_act_open_info(ActType, SubType) of
                    #act_info{etime = EndTime} ->
                        NewData = #cycle_rank_recharge{ end_time = EndTime, money = SumMoney },
                        ActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData },
                        lib_custom_act:db_save_custom_act_data(RoleId, ActData);
                    _ ->
                        skip
                end;
            _ ->
                Data = util:bitstring_to_term(erlang:element(3, StrData)),
                case Data of
                    #cycle_rank_recharge{ money = HasMoney } ->
                        NewData = Data#cycle_rank_recharge{ money = HasMoney + SumMoney },
                        ActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData },
                        lib_custom_act:db_save_custom_act_data(RoleId, ActData);
                    _ -> skip
                end
        end
    end,
    lists:foreach(Fun, OpenSubTypeL).

%% 错误计算5类型的修复秘籍
repair_recharge_error_type() ->
    NowSec = utime:unixtime(),
    TodayZero = utime:unixdate(NowSec),
    Sql = io_lib:format(
        <<"select player_id, sum(gold) from recharge_log where time > ~p and time < ~p GROUP BY player_id">>, [TodayZero, NowSec]),
    List = db:get_all(Sql),
    case List of
        [] -> skip;
        _ ->
            Fun = fun([RoleId, SumGold]) ->
                Pid = misc:get_player_process(RoleId),
                case is_pid(Pid) andalso misc:is_process_alive(Pid) of
                    true ->
                        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, repair_recharge_error_type_online, [SumGold]);
                    false ->
                        repair_recharge_error_type_offline(RoleId, SumGold)
                end,
                timer:sleep(500)
            end,
            spawn(fun() ->
                lists:foreach(Fun, List)
            end),
            List
    end.

repair_recharge_error_type_online(Player, SumGold) ->
    ActType = ?CUSTOM_ACT_CYCLE_RANK_RECHARGE,
    #player_status{ id = PlayerId } = Player,
    OpenSubTypeL = lib_custom_act_api:get_open_subtype_ids(ActType),
    Fun = fun(SubType, TemPlayer) ->
        case get_act_data(TemPlayer, ActType, SubType, 0) of
            #cycle_rank_recharge{ } = Data ->
                NewData = Data#cycle_rank_recharge{ money = SumGold },
                ActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData },
                lib_custom_act:db_save_custom_act_data(PlayerId, ActData),
                NewTemPlayer = lib_custom_act:save_act_data_to_player(TemPlayer, ActData),
                send_reward_status(NewTemPlayer, ActType, SubType),
                NewTemPlayer;
            _ ->
                TemPlayer
        end
    end,
    lists:foldl(Fun, Player, OpenSubTypeL).

repair_recharge_error_type_offline(RoleId, SumGold) ->
    ActType = ?CUSTOM_ACT_CYCLE_RANK_RECHARGE,
    OpenSubTypeL = lib_custom_act_api:get_open_subtype_ids(ActType),
    Sql = io_lib:format(<<"select `type`, `subtype`, `data_list` from`custom_act_data` where `player_id`=~p and `type` = 124">>, [RoleId]),
    ActDataList = [ erlang:list_to_tuple(I) || I <- db:get_all(Sql)],
    Fun = fun(SubType) ->
        StrData = lists:keyfind(SubType, 2, ActDataList),
        case StrData of
            false ->
                skip;
            _ ->
                Data = util:bitstring_to_term(erlang:element(3, StrData)),
                case Data of
                    #cycle_rank_recharge{ } = Data ->
                        NewData = Data#cycle_rank_recharge{ money = SumGold},
                        ActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData },
                        lib_custom_act:db_save_custom_act_data(RoleId, ActData);
                    _ -> skip
                end
        end
    end,
    lists:foreach(Fun, OpenSubTypeL).