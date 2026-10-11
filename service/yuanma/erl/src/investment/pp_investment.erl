%%-----------------------------------------------------------------------------
%% @Module  :       pp_investment.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-18
%% @Description:    投资活动
%%-----------------------------------------------------------------------------

-module (pp_investment).
-export ([handle/3]).
-include ("server.hrl").
-include ("investment.hrl").
-include ("common.hrl").
-include ("errcode.hrl").
-include ("figure.hrl").
-include ("def_module.hrl").
-include("goods.hrl").

handle(CMD, #player_status{investment = undefined} = PS, Args) ->
    NewPS = lib_investment:load_data(PS),
    case handle(CMD, NewPS, Args) of
        {ok, NewPS1} ->
            {ok, NewPS1};
        _ ->
            {ok, NewPS}
    end;

handle(42001, PS, [Type]) ->
    #player_status{investment = InvestmentStatus, sid = Sid} = PS,
    #investment{type = Type, cur_lv = Lv, buy_time = Time, get_time = GetTime, login_days = LoginDays, reward_info = RewardInfo} = maps:get(Type, InvestmentStatus, #investment{type = Type}),
    {ok, BinData} = pt_420:write(42001, [Type, Lv, Time, GetTime, LoginDays, RewardInfo]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 投资(修改投资档次)
handle(42002, PS, [Type, Lv]) ->
    lib_investment:buy(PS, Type, Lv);

handle(42003, PS, [Type, RewardId]) ->
    #player_status{id = RoleId, sid = Sid, investment = InvestmentStatus} = PS,
    case maps:find(Type, InvestmentStatus) of
        {ok, Item} ->
            #investment{reward_info = RewardInfo, cur_lv = CurLv} = Item,
            case lists:keyfind(RewardId, 1, RewardInfo) of
                {RewardId, CurLv} ->
                    lib_investment:send_error(Sid, ?ERRCODE(err420_reward_is_got));
                One ->
                    Lv0
                    = case One of
                        {RewardId, L} ->
                            L;
                        _ ->
                            0
                    end,
                    case lib_investment:check_rewards(PS, Item, RewardId) of
                        true  ->
                            case lib_investment:calc_rewards(RewardId, Item, Lv0) of
                                [_|_] = Rewards ->
                                    NewRewardInfo = lists:keystore(RewardId, 1, RewardInfo, {RewardId, CurLv}),
                                    NewItem = Item#investment{reward_info = NewRewardInfo, get_time = utime:unixtime()},
                                    %%case data_investment:get_reset_type(Type) =:= ?RESET_TYPE_REWARD_FINISH andalso lib_investment:all_reward_finish(NewItem) of
                                    %%    true ->
                                    %%        lib_investment:delete_investment(RoleId, Type),
                                    %%        NewStatus = maps:remove(Type, InvestmentStatus);
                                    %%    _ ->
                                    %%        lib_investment:update_reward(RoleId, NewItem),
                                    %%        NewStatus = InvestmentStatus#{Type => NewItem}
                                    %%end,
                                    %%根据策划要求，最后一天手动领取不删除月卡特权，在最后一天结算完的第二天才算是完整的结算
                                    lib_investment:update_reward(RoleId, NewItem),
                                    NewStatus = InvestmentStatus#{Type => NewItem},
                                    Produce = #produce{type = investment_reward, subtype = Type, reward = Rewards, remark = ulists:concat([Type, "-", CurLv])},
                                    {ok, RewardPS} = lib_goods_api:send_reward_with_mail(PS, Produce),
                                    Condition = lib_investment:get_condition(Type, CurLv, RewardId),
                                    lib_log_api:log_investment_reward(RoleId, Type, CurLv, Condition, Rewards, PS#player_status.bgold, RewardPS#player_status.bgold, if Lv0 > 0 -> 2; true -> 1 end, utime:unixtime()),
                                    {ok, BinData} = pt_420:write(42003, [Type, RewardId, Rewards]),
                                    lib_server_send:send_to_sid(Sid, BinData),
                                    {ok, RewardPS#player_status{investment = NewStatus}};
                                _ ->
                                    lib_investment:send_error(Sid, ?FAIL)
                            end;
                        {false, Code} ->
                            lib_investment:send_error(Sid, Code);
                        _ ->
                            lib_investment:send_error(Sid, ?FAIL)
                    end
            end;
        _ ->
            lib_investment:send_error(Sid, ?ERRCODE(err420_no_investment))
    end;

%% 开启列表
handle(42004, PS, []) ->
    lib_investment:send_open_list(PS);

handle(CMD, _PS, _Args) ->
    ?ERR("pp_investment no match ~p, ~p~n", [CMD, _Args]).


