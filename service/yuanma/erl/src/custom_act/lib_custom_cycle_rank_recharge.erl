%%%-------------------------------------------------------------------
%%% @author lianghaihui
%%% 循环冲榜单笔充值活动
%%% @end
%%% Created : 28. 6月 2022 17:54
%%%-------------------------------------------------------------------
-module(lib_custom_cycle_rank_recharge).

-include("server.hrl").
-include("custom_act.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("rec_recharge.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("figure.hrl").

%% API
-export([
    login/1,
    handle_event/2,
    send_reward_status/3,
    get_act_rewards/4,
    act_end/2,
    settlement_act_data/3
]).

-export([
    gm_act_start/3,
    act_start_online/4,
    act_start_offline/4
]).

%% 登录时候结算玩家数据
login(Player) ->
    ActType = ?CUSTOM_ACT_CYCLE_RANK_ONE_CHARGE,
    AllSubType = lib_custom_act_util:get_subtype_list(ActType),
    NowSec = utime:unixtime(),
    Fun = fun(SubType, TemPlayer) ->
        case get_act_data(TemPlayer, ActType, SubType, 0) of
            #cycle_rank_single_recharge{ times_map = Maps, end_time = EndTime } when NowSec >= EndTime ->
                do_settlement_act_data(TemPlayer, ActType, SubType, Maps);
            _ ->
                TemPlayer
        end
    end,
    lists:foldl(Fun, Player, AllSubType).

get_act_data(Player, ActType, SubType, IsSend) ->
    case lib_custom_act:act_data(Player, ActType, SubType) of
        #custom_act_data{ data = Data } ->
            Data;
        _ ->
            case IsSend of
                1 ->
                    case lib_custom_act_util:get_custom_act_open_info(ActType, SubType) of
                        #act_info{etime = EndTime} ->
                            #cycle_rank_single_recharge{ end_time = EndTime };
                        _ ->
                            undefined
                    end;
                _ ->
                    undefined
            end
    end.

%% 充值回调
handle_event(Player, #event_callback{ type_id = ?EVENT_RECHARGE, data = Data }) ->
    #callback_recharge_data{
        recharge_product = #base_recharge_product{ product_id = ProductId }
    } = Data,
    LastPlayer = do_handle_event(Player, ProductId),
    {ok, LastPlayer};
handle_event(Player, _) ->
    {ok, Player}.

do_handle_event(Player, ProductId) ->
    ActType = ?CUSTOM_ACT_CYCLE_RANK_ONE_CHARGE,
    #player_status{ id = PlayerId } = Player,
    OpenSubTypeL = lib_custom_act_api:get_open_subtype_ids(ActType),
    Fun = fun(SubType, TemPlayer) ->
        case get_act_data(TemPlayer, ActType, SubType, 1) of
            #cycle_rank_single_recharge{ times_map = Maps } = Data ->
                {OldRechargeTimes, OldGetTimes} = maps:get(ProductId, Maps, {0, 0}),
                NewMaps = maps:put(ProductId, {OldRechargeTimes + 1, OldGetTimes}, Maps),
                NewData = Data#cycle_rank_single_recharge{ times_map = NewMaps },
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

%% 发送面板信息

send_reward_status(Player, ActType, SubType) ->
    #player_status{ id = PlayerId } = Player,
    case get_act_data(Player, ActType, SubType, 1) of
        #cycle_rank_single_recharge{ times_map = Maps } ->
            AllRewardId = lib_custom_act_util:get_act_reward_grade_list(ActType, SubType),
            Fun = fun(RewardId, AccL) ->
                case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, RewardId) of
                    #custom_act_reward_cfg{ name = Name, format = Format, desc = Desc, condition = ConditionL, reward = RewardList } ->
                        {_, CfgProductId} = ulists:keyfind(product_id, 1, ConditionL, {product_id, 0}),
                        {_, CfgRewardTimes} = ulists:keyfind(reward_times, 1, ConditionL, {reward_times, 0}),
                        case maps:get(CfgProductId, Maps, none) of
                            none ->
                                GetTimes = 0,
                                BuyInfo = {CfgProductId, 0},
                                RewardStatus = ?ACT_REWARD_CAN_NOT_GET;
                            {BuyTimes, HasGetTimes} ->
                                if
                                    HasGetTimes >= CfgRewardTimes ->
                                        GetTimes = CfgRewardTimes,
                                        BuyInfo = {CfgProductId, BuyTimes},
                                        RewardStatus = ?ACT_REWARD_HAS_GET;
                                    true ->
                                        GetTimes = HasGetTimes,
                                        BuyInfo = {CfgProductId, BuyTimes},
                                        RewardStatus = ?IF(BuyTimes - HasGetTimes > 0, ?ACT_REWARD_CAN_GET, ?ACT_REWARD_CAN_NOT_GET)
                                end
                        end,
                        RewardStr = util:term_to_string(RewardList),
                        BuyTimesList = [BuyInfo],
                        ConditionStr = util:term_to_string(ConditionL ++ [{cycle_rank_buy, BuyTimesList}]) ,
                        [{RewardId, Format, RewardStatus, GetTimes, Name, Desc, ConditionStr, RewardStr}|AccL];
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

%% 领取奖励
get_act_rewards(Player, ActType, SubType, GradeId) ->
    #player_status{ id = PlayerId, figure = #figure{ name = RoleName } } = Player,
    case get_act_data(Player, ActType, SubType, 0) of
        #cycle_rank_single_recharge{ times_map = Maps } = Data ->
            case check_can_get_reward(ActType, SubType, Maps, GradeId) of
                {ok, RewardList, NewMaps, IsTv} ->
                    NewData = Data#cycle_rank_single_recharge{ times_map = NewMaps },
                    ActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData },
                    lib_custom_act:db_save_custom_act_data(PlayerId, ActData),
                    NewPlayer = lib_custom_act:save_act_data_to_player(Player, ActData),
                    Product = #produce{type = cycle_rank_single_recharge, subtype = SubType, reward = RewardList, show_tips = ?SHOW_TIPS_4},
                    LastPlayer = lib_goods_api:send_reward(NewPlayer, Product),
                    {ok, Bin} = pt_331:write(33105, [?SUCCESS, ActType, SubType, GradeId]),
                    lib_server_send:send_to_uid(PlayerId, Bin),
                    IsTv =/= 0 andalso lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 73, [RoleName, ActType, SubType]),
                    lib_log_api:log_custom_act_reward(PlayerId, ActType, SubType, GradeId, RewardList),
                    send_reward_status(LastPlayer, ActType, SubType),
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

check_can_get_reward(ActType, SubType, Maps, GradeId) ->
    case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, GradeId) of
        #custom_act_reward_cfg{ condition = ConditionL, reward = RewardList } ->
            {_, CfgProductId} = ulists:keyfind(product_id, 1, ConditionL, {product_id, 0}),
            {_, CfgRewardTimes} = ulists:keyfind(reward_times, 1, ConditionL, {reward_times, 0}),
            case maps:get(CfgProductId, Maps, none) of
                {BuyTimes, HasGetTimes} ->
                    NewHasGetTimes = HasGetTimes + 1,
                    if
                        NewHasGetTimes > CfgRewardTimes ->
                            {error, ?ERRCODE(err331_already_get_reward)};
                        NewHasGetTimes > BuyTimes ->
                            {error, ?ERRCODE(err331_already_get_reward)};
                        true ->
                            case lib_custom_act_util:get_act_cfg_info(ActType, SubType) of
                                #custom_act_cfg{ condition = ActConditionL } ->
                                    {is_tv, IsTv} = ulists:keyfind(is_tv, 1, ActConditionL, {is_tv, 0});
                                _ ->
                                    IsTv = 0
                            end,
                            NewMaps = maps:put(CfgProductId, {BuyTimes, NewHasGetTimes}, Maps),
                            {ok, RewardList, NewMaps, IsTv}
                    end;
                _ ->
                    {error, ?ERRCODE(err331_stage_not_achieve)}
            end;
        _ ->
            {error, ?ERRCODE(err331_no_act_reward_cfg)}
    end.

%% 活动结束清算数据
act_end(ActType, SubType) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() ->
        [begin
             timer:sleep(500),
             lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, settlement_act_data, [ActType, SubType])
         end || E <- OnlineRoles
        ]
    end). %% lib_player:apply_cast(4294967515, 3, lib_custom_cycle_rank_recharge, settlement_act_data, [125, 4]).

%% 活动结束时结算在线玩家的数据
settlement_act_data(Player, ActType, SubType) ->
    case get_act_data(Player, ActType, SubType, 0) of
        #cycle_rank_single_recharge{ times_map = Maps } when Maps =/= #{} ->
            do_settlement_act_data(Player, ActType, SubType, Maps);
        _ ->
            Player
    end.

do_settlement_act_data(Player, ActType, SubType, Maps) ->
    #player_status{ id = PlayerId } = Player,
    AllRewardIds = lib_custom_act_util:get_act_reward_grade_list(ActType, SubType),
    Fun = fun(RewardId, AccRewardL) ->
        #custom_act_reward_cfg{
            condition = ConditionL, reward = RewardList
        } = lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, RewardId),
        {_, CfgProductId} = ulists:keyfind(product_id, 1, ConditionL, {product_id, 0}),
        {_, CfgRewardTimes} = ulists:keyfind(reward_times, 1, ConditionL, {reward_times, 0}),
        case maps:get(CfgProductId, Maps, none) of
            {BuyTimes, HasGetTimes} ->
                AllTimes = ?IF(BuyTimes > CfgRewardTimes, CfgRewardTimes, BuyTimes),
                EmailTimes = AllTimes - HasGetTimes,
                case EmailTimes =< 0 of
                    true ->
                        AccRewardL;
                    false ->
                        TimesRewardL = ulists:elem_multiply(RewardList, EmailTimes),
                        TimesRewardL ++ AccRewardL
                end;
            _ ->
                AccRewardL
        end
    end,
    SendRewardL = lists:foldl(Fun, [], AllRewardIds),
    NewPlayer = lib_custom_act:delete_act_data_to_player_without_db(Player, ActType, SubType),
    lib_custom_act:db_delete_custom_act_data(PlayerId, ActType, SubType),
    case SendRewardL of
        [] -> skip;
        _ ->
            Title = utext:get(3310121),
            Content = utext:get(3310122),
            lib_mail_api:send_sys_mail([PlayerId], Title, Content, lib_goods_api:make_reward_unique(SendRewardL))
    end,
    NewPlayer.

%% -------------------------------------------------------------------------------------------------
%% @doc Nosec 开放游戏入口的时间
%% -------------------------------------------------------------------------------------------------
gm_act_start(ActType, SubType, NowSec) ->
    DateBegin = utime:unixdate(NowSec),
    Sql = io_lib:format(<<"select player_id, product_id, money from recharge_log where time > ~p and time < ~p">>, [DateBegin, NowSec]),
    case db:get_all(Sql) of
        [] -> skip;
        List -> 
            Fun = fun([RoleId, ProductId, _Money], AccMap) ->
                OldList = maps:get(RoleId, AccMap, []),
                maps:put(RoleId, [ProductId|OldList], AccMap)
            end,
            RoleMaps = lists:foldl(Fun, #{}, List),
            HandleFun = fun(RoleId, ProductIdL) ->
                Pid = misc:get_player_process(RoleId),
                case is_pid(Pid) andalso misc:is_process_alive(Pid) of
                    true ->
                        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, act_start_online, [ActType, SubType, ProductIdL]);
                    false ->
                        act_start_offline(RoleId, ActType, SubType, ProductIdL)
                end,
                timer:sleep(1000)
            end,
            spawn(fun() ->
                maps:map(HandleFun, RoleMaps)
            end)
    end.

act_start_online(Player, ActType, SubType, ProductIdL) ->
    #player_status{ id = PlayerId } = Player,
    case get_act_data(Player, ActType, SubType, 1) of
            #cycle_rank_single_recharge{ times_map = Maps } = Data ->
                NewMaps = add_times_map_from_list(Maps, ProductIdL),
                NewData = Data#cycle_rank_single_recharge{ times_map = NewMaps },
                ActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData },
                lib_custom_act:db_save_custom_act_data(PlayerId, ActData),
                NewTemPlayer = lib_custom_act:save_act_data_to_player(Player, ActData),
                %% ?MYLOG("lhh_charge", "NewData:~p", [NewData]),
                send_reward_status(NewTemPlayer, ActType, SubType),
                NewTemPlayer;
            _ ->
                Player
    end.

act_start_offline(RoleId, ActType, SubType, ProductIdL) ->
    Sql = io_lib:format(<<"select `data_list` from `custom_act_data` where `player_id`=~p and `type` = ~p and `subtype` = ~p">>, [RoleId, ActType, SubType]),
    List = db:get_all(Sql),
    case List == [] of
        true -> 
            case lib_custom_act_util:get_custom_act_open_info(ActType, SubType) of
                #act_info{etime = EndTime} ->
                    ActData = #cycle_rank_single_recharge{ end_time = EndTime };
                _ ->
                    ActData = false
            end;
        false -> 
            NowSec = utime:unixtime(),
            Fun = fun([Item], AccL) ->
                I = util:bitstring_to_term(Item),
                #cycle_rank_single_recharge{ end_time = EndTime, times_map = TimesMaps } = I,
                %% 过期的进行结算邮件补发
                case EndTime > NowSec of
                    true -> [I|AccL];
                    _ ->
                        send_email_offline(RoleId, TimesMaps, ActType, SubType),
                        AccL
                end
            end,
            Filter = lists:foldl(Fun, [], List),
            case Filter of
                [] -> 
                    case lib_custom_act_util:get_custom_act_open_info(ActType, SubType) of
                        #act_info{etime = EndTime} ->
                            ActData = #cycle_rank_single_recharge{ end_time = EndTime };
                        _ ->
                            ActData = false
                    end;
                _ ->
                    [ActData|_] = Filter
            end

    end,
    case ActData of
        #cycle_rank_single_recharge{ times_map = TimesMaps } -> 
            NewTimesMaps = add_times_map_from_list(TimesMaps, ProductIdL),
            NewActData = ActData#cycle_rank_single_recharge{ times_map = NewTimesMaps },
            LastActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewActData },
            lib_custom_act:db_save_custom_act_data(RoleId, LastActData);
        false -> 
            skip
    end.   

add_times_map_from_list(TimesMaps, ProductIdL) ->
    Fun = fun(ProductId, TemTimesMaps) ->
        {OldRechargeTimes, OldGetTimes} = maps:get(ProductId, TemTimesMaps, {0, 0}),
        maps:put(ProductId, {OldRechargeTimes + 1, OldGetTimes}, TemTimesMaps)
    end,
    lists:foldl(Fun, TimesMaps, ProductIdL).    


send_email_offline(RoleId, TimesMaps, ActType, SubType) ->
    AllRewardIds = lib_custom_act_util:get_act_reward_grade_list(ActType, SubType),
    Fun = fun(RewardId, AccRewardL) ->
        #custom_act_reward_cfg{
            condition = ConditionL, reward = RewardList
        } = lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, RewardId),
        {_, CfgProductId} = ulists:keyfind(product_id, 1, ConditionL, {product_id, 0}),
        {_, CfgRewardTimes} = ulists:keyfind(reward_times, 1, ConditionL, {reward_times, 0}),
        case maps:get(CfgProductId, TimesMaps, none) of
            {BuyTimes, HasGetTimes} ->
                AllTimes = ?IF(BuyTimes > CfgRewardTimes, CfgRewardTimes, BuyTimes),
                EmailTimes = AllTimes - HasGetTimes,
                case EmailTimes =< 0 of
                    true ->
                        AccRewardL;
                    false ->
                        TimesRewardL = ulists:elem_multiply(RewardList, EmailTimes),
                        TimesRewardL ++ AccRewardL
                end;
            _ ->
                AccRewardL
        end
    end,
    SendRewardL = lists:foldl(Fun, [], AllRewardIds),   
    lib_custom_act:db_delete_custom_act_data(RoleId, ActType, SubType), 
    case SendRewardL of
        [] -> skip;
        _ ->
            Title = utext:get(3310121),
            Content = utext:get(3310122),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, lib_goods_api:make_reward_unique(SendRewardL))
    end.
