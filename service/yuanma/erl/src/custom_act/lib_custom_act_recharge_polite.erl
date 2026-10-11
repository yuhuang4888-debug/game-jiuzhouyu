%%---------------------------------------------------------------------------
%% @doc:        lib_custom_act_recharge_polite
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-5月-24. 15:55
%% @deprecated: 累充有礼
%%---------------------------------------------------------------------------
-module(lib_custom_act_recharge_polite).

-include("common.hrl").
-include("server.hrl").
-include("rec_event.hrl").
-include("rec_recharge.hrl").
-include("def_event.hrl").
-include("def_recharge.hrl").
-include("custom_act.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").

%% API
-export([
    get_data/1,
    handle_event/2,
    send_reward_status/3,
    send_reward_status/4,
    act_end/2,
    get_recharge_polite_reward/4,
    clear_recharge_polite_data/4
]).

-export([
    gm_set_num/2,
    gm_clear/1
]).

get_data(Player) ->
    ActType = ?CUSTOM_ACT_TYPE_RECHARGE_POLITE,
    OpenSubTypeL = lib_custom_act_api:get_open_subtype_ids(ActType),
    Fun = fun(SubType) ->
        ?MYLOG("lhh_polite", "Type:~p//SubType:~p//Num:~p//Data:~p", [ActType, SubType, get_recharge_polite_data(Player, ActType, SubType), get_num(SubType)])
    end,
    lists:foreach(Fun, OpenSubTypeL).

%% 活动结束时清算
act_end(ActType, SubType) ->
    %% 结算问题
    db:execute(io_lib:format(?SQL_DELETE_CUSTOM_ACT_DATA_1, [ActType, SubType])),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    RechargeNum = get_num(SubType),
    clear_num(SubType),
    spawn(fun() ->
        [begin
             timer:sleep(500),
             lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, clear_recharge_polite_data, [ActType, SubType, RechargeNum])
         end || E <- OnlineRoles
        ]
    end).

%% 清除活动数据
clear_recharge_polite_data(Player, ActType, ClearSubType, _RechargeNum) ->
    case get_recharge_polite_data(Player, ActType, ClearSubType) of
        #custom_recharge_polite{ } ->
            NewPlayer = lib_custom_act:delete_act_data_to_player_without_db(Player, ActType, ClearSubType),
            Fun = fun(SubType) ->
                send_reward_status(NewPlayer, ?CUSTOM_ACT_TYPE_RECHARGE_POLITE, SubType)
            end,
            lists:foreach(Fun, lib_custom_act_api:get_open_subtype_ids(ActType)),
            NewPlayer;
        _ ->
            Player
    end.

%% 充值回调
handle_event(Player, #event_callback{ type_id = ?EVENT_RECHARGE, data = Data }) ->
    #callback_recharge_data{
        recharge_product = #base_recharge_product{ money = AddMoney }
    } = Data,
    LastPlayer = do_handle_event(Player, AddMoney),
    {ok, LastPlayer};
handle_event(Player, _) ->
    {ok, Player}.

do_handle_event(Player, AddMoney) ->
    ActType = ?CUSTOM_ACT_TYPE_RECHARGE_POLITE,
    #player_status{ id = PlayerId } = Player,
    OpenSubTypeL = lib_custom_act_api:get_open_subtype_ids(ActType),
    Fun = fun(SubType, TemPlayer) ->
        case get_recharge_polite_data(TemPlayer, ActType, SubType) of
            #custom_recharge_polite{ money = HasMoney } = Data ->
                case HasMoney > 0 of
                    true ->
                        ok;
                    _ ->
                        add_num(SubType),
                        send_to_all(ActType, SubType)
                end,
                NewData = Data#custom_recharge_polite{ money = HasMoney + AddMoney },
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

%% 领取奖励
get_recharge_polite_reward(Player, ActType, SubType, GradeId) ->
    #player_status{ id = PlayerId } = Player,
    Data = get_recharge_polite_data(Player, ActType, SubType),
    RechargeNum = get_num(SubType),
    case check_can_get_reward(Data, ActType, SubType, GradeId, RechargeNum) of
        {ok, RewardList, NewData} ->
            ActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = NewData },
            lib_custom_act:db_save_custom_act_data(PlayerId, ActData),
            NewPlayer = lib_custom_act:save_act_data_to_player(Player, ActData),
            Product = #produce{type = custom_act_recharge_polite, subtype = SubType, reward = RewardList, show_tips = ?SHOW_TIPS_4},
            LastPlayer = lib_goods_api:send_reward(NewPlayer, Product),
            send_reward_status(LastPlayer, ActType, SubType),
            %% 特殊处理，补发33257协议
            {ok, BinData} = pt_332:write(33257, [ActType, SubType, RewardList]),
            lib_server_send:send_to_uid(PlayerId, BinData),
            lib_log_api:log_custom_act_reward(PlayerId, ActType, SubType, GradeId, RewardList),
            pack(PlayerId, 33105, [?SUCCESS, ActType, SubType, GradeId]);
        {error, Code} ->
            pack(PlayerId, 33105, [Code, ActType, SubType, GradeId]),
            LastPlayer = Player
    end,
    {ok, LastPlayer}.

check_can_get_reward(Data, ActType, SubType, GradeId, RechargeNum) when is_record(Data, custom_recharge_polite)->
    case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, GradeId) of
        #custom_act_reward_cfg{condition = ConditionL, reward = RewardList} ->
            #custom_recharge_polite{money = Money, free_ids = FreeIds, pay_ids = PayIds} = Data,
            {_, NeedNum} = ulists:keyfind(recharge_num, 1, ConditionL, {recharge_num, 0}),  %% ��Ҫ�ﵽ������
            if
                NeedNum > RechargeNum ->
                    {error, ?ERRCODE(err331_stage_not_achieve)};
                true ->
                    {?REGULAR_REWARD_TYPE, CfgFreeRewardL} = ulists:keyfind(?REGULAR_REWARD_TYPE, 1, RewardList, {?REGULAR_REWARD_TYPE, []}),
                    {?RARE_REWARD_TYPE, CfgRareRewardL} = ulists:keyfind(?RARE_REWARD_TYPE, 1, RewardList, {?RARE_REWARD_TYPE, []}),
                    FreeRewardL = ?IF( lists:member(GradeId, FreeIds), [], CfgFreeRewardL),
                    RareRewardL = ?IF( lists:member(GradeId, PayIds), [], CfgRareRewardL),
                    if
                        FreeRewardL == [] andalso RareRewardL =/= [] andalso Money =< 0 ->
                            {error, ?ERRCODE(err331_need_recharge)};
                        FreeRewardL == [] andalso RareRewardL == []->
                            {error, ?ERRCODE(err331_already_get_reward)};
                        true ->
                            %% 未充值过的玩家无法获取奖励
                            case Money =< 0 of
                                true ->
                                    SendRewardL = FreeRewardL, NewFreeIds = [GradeId|FreeIds], NewPayIDs = PayIds;
                                _ ->
                                    SendRewardL = FreeRewardL ++ RareRewardL,
                                    NewFreeIds = [GradeId|FreeIds], NewPayIDs = [GradeId|PayIds]
                            end,
                            {ok, SendRewardL, Data#custom_recharge_polite{ free_ids = NewFreeIds, pay_ids = NewPayIDs }}
                    end
            end;
        _ ->
            {error, ?ERRCODE(err331_no_act_reward_cfg)}
    end;
check_can_get_reward(_, _, _, _, _) ->
    {error, ?ERRCODE(err331_act_closed)}.


send_reward_status(Player, ActType, SubType) ->
    RechargeNum = get_num(SubType),
    send_reward_status(Player, ActType, SubType, RechargeNum).
%% 发送面板信息
send_reward_status(Player, ActType, SubType, RechargeNum) ->
    #player_status{ id = PlayerId } = Player,
    case get_recharge_polite_data(Player, ActType, SubType) of
        #custom_recharge_polite{ money = Money, free_ids = FreeIds, pay_ids = PayIds } ->
            GradeIds = data_custom_act:get_reward_grade_list(ActType, SubType),
            Fun = fun(GradeId, AccL) ->
                case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, GradeId) of
                    #custom_act_reward_cfg{ name = Name, desc = Desc, condition = ConditionL, reward = RewardList } ->
                        ConditionStr = util:term_to_string(ConditionL),
                        {_, NeedNum} = ulists:keyfind(recharge_num, 1, ConditionL, {recharge_num, 0}),  %% ��Ҫ�ﵽ������
                        Fun2 = fun({RewardType, Reward}) ->
                            RewardStatus = case RewardType of
                                               ?RARE_REWARD_TYPE ->
                                                   case lists:member(GradeId, PayIds) of
                                                       true -> 2;
                                                       false -> ?IF(Money > 0 andalso RechargeNum >= NeedNum, 1, 0)
                                                   end;
                                               _ ->
                                                   case lists:member(GradeId, FreeIds) of
                                                       true -> 2;
                                                       false -> ?IF(RechargeNum >= NeedNum, 1, 0)
                                                   end
                                           end,
                            RewardStr = util:term_to_string(Reward),
                            {RewardType, RewardStatus, RewardStr}
                        end,
                        [{GradeId, ConditionStr, Name, Desc, lists:map(Fun2, RewardList)}|AccL];
                    _ ->
                        AccL
                end
            end,
            SendList = lists:foldl(Fun, [], GradeIds),
            Args = [ActType, SubType, RechargeNum, 0, lists:reverse(SendList)],
            {ok, Bin} = pt_332:write(33259, Args),
            %% ?MYLOG("lhh_polite", "lhh_polite:~p//~p", [33259, Args]),
            lib_server_send:send_to_uid(PlayerId, Bin);
        _ ->
            ?ERR("h5_error_request Type:~p//SubType:~p", [ActType, SubType])
    end.

%% 获取活动数据
get_recharge_polite_data(Player, ActType, SubType) ->
    case lib_custom_act:act_data(Player, ActType, SubType) of
        #custom_act_data{ data = Data } ->
            Data;
        _ ->
            NowTime = utime:unixtime(),
            case lib_custom_act_util:get_custom_act_open_info(ActType, SubType) of
                #act_info{etime = Etime} when NowTime < Etime ->
                    #custom_recharge_polite{ end_time = Etime };
                _ ->
                    ?ERRCODE(err331_act_closed)
            end
    end.

%% 全服充值+1
add_num(ActSubType) ->
    ActType = ?CUSTOM_ACT_TYPE_RECHARGE_POLITE,
    mod_global_counter:increment(?MOD_AC_CUSTOM, ActType, ActSubType).

%% 获取全服充值人数
get_num(ActSubType) ->
    ActType = ?CUSTOM_ACT_TYPE_RECHARGE_POLITE,
    mod_global_counter:get_count(?MOD_AC_CUSTOM, ActType, ActSubType).

%% 清楚全服充值人数
clear_num(SubType) ->
    ActType = ?CUSTOM_ACT_TYPE_RECHARGE_POLITE,
    mod_global_counter:set_count(?MOD_AC_CUSTOM, ActType, SubType, 0).

pack(PlayerId, Cmd, Args) ->
    %% ?MYLOG("lhh_polite", "lhh_polite:~p//~p", [Cmd, Args]),
    {ok, Bin} = pt_331:write(Cmd, Args),
    lib_server_send:send_to_uid(PlayerId, Bin).

%% 秘籍设置全服充值人人数
gm_set_num(SubType, Count) ->
    ActType = ?CUSTOM_ACT_TYPE_RECHARGE_POLITE,
    mod_global_counter:set_count(?MOD_AC_CUSTOM, ActType, SubType, Count).

%% 秘籍清理全服数据
gm_clear(SubType) ->
    act_end(?CUSTOM_ACT_TYPE_RECHARGE_POLITE, SubType).

send_to_all(ActType, SubType) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    RechargeNum = get_num(SubType),
    [begin
         lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_STATUS, ?MODULE, send_reward_status, [ActType, SubType, RechargeNum])
     end || E <- OnlineRoles
    ].