%%-----------------------------------------------------------------------------
%% @Module  :       lib_investment.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-18
%% @Description:    投资活动
%%-----------------------------------------------------------------------------

-module (lib_investment).
-include ("server.hrl").
-include ("investment.hrl").
-include ("errcode.hrl").
-include ("figure.hrl").
-include ("common.hrl").
-include("designation.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include ("red_envelopes.hrl").
-include ("custom_act.hrl").
-include("vip.hrl").
-include("rec_recharge.hrl").

-export([
    load_data/1
    ,check_buy/4
    ,calc_price/4
    ,save_buy/2
    ,update_buy/2
    ,calc_rewards/3
    ,update_reward/2
    ,all_reward_finish/1
    ,delete_investment/2
    ,check_rewards/3
    ,handle_buy_investment/4
    ,get_condition/3
    ,buy/3
    ,send_error/2
    ,send_open_list/1
    ,handle_invest_show/1
    ,handle_event/2
    ,is_buy/2
    ,is_buy_by_type/2
    ,gm_get_reward/3
    ,gm_update/3
    ,gm_handle_invest_show/1
    ,gm_delete_investment/2
    ,get_data/1
    ,get_month_card_addition/2
    ,is_month_card/1
    ,daily_refresh/0
    ,update_login_days/1
    ]).

load_data(#player_status{investment = undefined, id = RoleId} = PS) ->
    SQL = io_lib:format("SELECT `type`, `lv`, `reward_info`, `buy_time`, get_time, days_utime, login_days FROM `investment_data` WHERE `role_id`= ~p", [RoleId]),
    InvestmentStatus = init_status(db:get_all(SQL), #{}),
    NewPS = repair_old_player_for_new_features(PS#player_status{investment = InvestmentStatus}),
    NewPS2 = update_login_days(NewPS),
    NewPS2;
    % PS#player_status{investment = InvestmentStatus};

load_data(PS) ->
    NewPS = update_login_days(PS),
    NewPS.

init_status([[Type, Lv, RewardInfoStr, BuyTime, GetTime, DaysUtime, LoginDays]|T], InvestmentMap) ->
    RewardInfo = util:bitstring_to_term(RewardInfoStr),
    init_status(T, InvestmentMap#{Type => #investment{type = Type, cur_lv = Lv, buy_time = BuyTime,
        get_time = GetTime, reward_info = RewardInfo, days_utime = DaysUtime, login_days = LoginDays}});

init_status([], InvestmentMap) -> InvestmentMap.

%% 更新天数
update_login_days(PS) ->
    #player_status{id = RoleId, investment = InvestmentStatus} = PS,
    NowDate = utime:unixdate(),
    F = fun(Type, Item = #investment{buy_time = BuyTime, days_utime = DaysUtime }) ->
        case NowDate == utime:unixdate(DaysUtime) of
            true ->
                case Type of
                    ?INVEST_DO_TYPE_MONTH_CARD ->
                        case BuyTime =< ?SPECIAL_TIME_POINT of
                            true ->
                                NewItem = send_all_reward_before_time(RoleId, Item),
                                update_login_days(RoleId, NewItem),
                                update_reward(RoleId, NewItem),
                                NewItem;
                            _ ->
                                Item
                        end;
                    _ ->
                        Item
                end;
            false ->
                do_daily_refresh(Type, Item, RoleId)
        end
    end,
    NewInvestmentStatus = maps:map(F, InvestmentStatus),
    PS#player_status{investment = NewInvestmentStatus}.

%% 检查本类型是否能够买
check_buy(PS, Type, [], _Item) ->
    case data_investment:get_item(Type) of
        #base_investment_item{condition = Condition} = BaseItem ->
            case check_condition(Condition, PS) of
                true -> {true, BaseItem};
                {false, ErrCode} -> {false, ErrCode}
            end;
        [] ->
            {false, ?MISSING_CONFIG}
    end;
check_buy(PS, Type, [{vip, NeedVip}|T], Item) ->
    #player_status{figure = #figure{vip = Vip}} = PS,
    case Vip >= NeedVip of
        true -> check_buy(PS, Type, T, Item);
        false -> {false, ?VIP_LIMIT}
    end;
check_buy(PS, Type, [{dsgn_id, _DsgnId}|T], Item) ->
    check_buy(PS, Type, T, Item);
check_buy(PS, Type, [{buy_reward, _BuyRewardId}|T], Item) ->
    check_buy(PS, Type, T, Item);
check_buy(PS, Type, [{model, _}|T], Item) ->
    check_buy(PS, Type, T, Item);
check_buy(PS, Type, [{effect, _}|T], Item) ->
    check_buy(PS, Type, T, Item);
check_buy(PS, Type, [{original_cost, _}|T], Item) ->
    check_buy(PS, Type, T, Item);
check_buy(PS, Type, [{fighting, _}|T], Item) ->
    check_buy(PS, Type, T, Item);
check_buy(PS, Type, [{show_reward, _}|T], Item) ->
    check_buy(PS, Type, T, Item);
check_buy(_PS, _Type, [_|_T], _Item) ->
    {false, ?FAIL}.

calc_price(PriceType, Price, Type, Lv) ->
    case data_investment:get_type(Type, Lv) of
        #base_investment_type{price_type = PriceType, price = Price0} when Price > Price0 ->
            [{PriceType, 0, Price - Price0}];
        _ ->
            {false, ?FAIL}
    end.

calc_rewards(RewardId, Item, Lv0) ->
    #investment{cur_lv = CurLv, type = Type} = Item,
    case data_investment:get_reward(Type, CurLv, RewardId) of
        #base_investment_reward{rewards = Rewards} ->
            Rewards0
            = case data_investment:get_reward(Type, Lv0, RewardId) of
                #base_investment_reward{rewards = R} ->
                    R;
                _ ->
                    []
            end,
            lib_goods_util:calc_diffrence_goods(Rewards, Rewards0);
        _ ->
            []
    end.

check_rewards(PS, Item, RewardId) ->
    #investment{cur_lv = CurLv, type = Type} = Item,
    case data_investment:get_reward(Type, CurLv, RewardId) of
        #base_investment_reward{condition = Condition} ->
            check_reward(PS, Item, RewardId, Condition);
        _ ->
            {false, ?FAIL}
    end.

check_reward(PS, Item, RewardId, [{lv, Lv}|T]) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    if
        RoleLv >= Lv ->
            check_reward(PS, Item, RewardId, T);
        true ->
            {false, {?ERRCODE(player_lv_less), [Lv]}}
    end;

check_reward(PS, Item, RewardId, [{day, Day}|T]) ->
    #investment{buy_time = Time} = Item,
    if
        Time > 0 ->
            PassDays = utime:diff_days(Time),
            if
                PassDays >= Day ->
                    check_reward(PS, Item, RewardId, T);
                true ->
                    {false, {?ERRCODE(err420_need_more_day), [Day]}}
            end;
        true ->
            {false, ?ERRCODE(err420_no_investment)}
    end;

check_reward(PS, Item, RewardId, [{login_days, Day}|T]) ->
    #investment{login_days = LoginDays} = Item,
    case LoginDays >= Day of
        true -> check_reward(PS, Item, RewardId, T);
        false -> {false, {?ERRCODE(err420_need_more_logins_day), [Day]}}
    end;

check_reward(PS, Item, RewardId, [{finish_reward_id, FinishRewardId}|T]) ->
    #investment{cur_lv = CurLv, reward_info = RewardInfo} = Item,
    case lists:keyfind(FinishRewardId, 1, RewardInfo) of
        {FinishRewardId, Lv} when Lv =< CurLv -> check_reward(PS, Item, RewardId, T);
        _ -> {false, ?ERRCODE(err420_must_finish_last_reward_id)}
    end;

check_reward(PS, Item, RewardId, [{daily}|T]) ->
    #investment{get_time = GetTime} = Item,
    if
        GetTime > 0 ->
            case utime:diff_days(GetTime) > 0 of
                true -> check_reward(PS, Item, RewardId, T);
                false ->
                    % 档次没有领取完能继续领取
                    #investment{cur_lv = CurLv, reward_info = RewardInfo} = Item,
                    case lists:keyfind(RewardId, 1, RewardInfo) of
                        {RewardId, Lv} when Lv < CurLv -> check_reward(PS, Item, RewardId, T);
                        _ -> {false, ?ERRCODE(err420_can_only_get_it_once_a_day)}
                    end
            end;
        true ->
            check_reward(PS, Item, RewardId, T)
    end;

check_reward(_, _, _, []) -> true.


all_reward_finish(#investment{type = Type, cur_lv = Lv, reward_info = RewardInfo}) ->
    AllIds = data_investment:get_all_reward_id(Type, Lv),
    F = fun
        (Id) ->
            case lists:keyfind(Id, 1, RewardInfo) of
                {Id, Lv} ->
                    true;
                _ ->
                    false
            end
    end,
    lists:all(F, AllIds).

handle_buy_investment(PS, Type, Lv, [{dsgn_id, DsgnId}|Condition]) ->
    #player_status{dsgt_status = DsgtStatus} = PS,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    PS1
    = case maps:find(DsgnId, DsgtMap) of
        {ok, _} ->
            PS;
        _ ->
            ActivePara = #active_para{id = DsgnId},
            case lib_designation:active_dsgt(PS, ActivePara) of
                {true, NewPs1} ->
                    NewPs1;
                {_, NewPs1, _} ->
                    NewPs1;
                _ ->
                    PS
            end
    end,
    handle_buy_investment(PS1, Type, Lv, Condition);

handle_buy_investment(PS, Type, Lv, [{buy_reward, BuyReward}|Condition]) ->
    case data_investment:get_type(Type, Lv-1) of
        [] -> LastBuyReward = [];
        #base_investment_type{condition = LastCondition} ->
            case lists:keyfind(buy_reward, 1, LastCondition) of
                {buy_reward, LastBuyReward} -> ok;
                _ -> LastBuyReward = []
            end
    end,
    DiffRewards = lib_goods_util:calc_diffrence_goods(BuyReward, LastBuyReward),
    Produce = #produce{type = investment_buy, subtype = Type, reward = DiffRewards, remark = ulists:concat([Type, "-", Lv])},
    {ok, RewardPS} = lib_goods_api:send_reward_with_mail(PS, Produce),
    handle_buy_investment(RewardPS, Type, Lv,  Condition);

handle_buy_investment(PS, Type, Lv, [_|Condition]) ->
    handle_buy_investment(PS, Type, Lv, Condition);

handle_buy_investment(PS, _Type, _Lv, []) -> PS.

repair_old_player_for_new_features(PS) ->
    #player_status{investment = InvestmentStatus} = PS,
    NewPS
    = maps:fold(fun
        (_, #investment{type = Type, cur_lv = CurLv}, PSAcc) ->
            Conditions = [Item || #base_investment_type{condition = Condition} <- [data_investment:get_type(Type, Lv) || Lv <- lists:seq(1, CurLv)], Item <- Condition],
            F = fun
                ({dsgn_id, _DsgnId}) -> true;
                (_) -> false
            end,
            handle_buy_investment(PSAcc, Type, CurLv, lists:filter(F, Conditions))
    end, PS, InvestmentStatus),
    NewPS.

get_condition(Type, CurLv, RewardId) ->
    case data_investment:get_reward(Type, CurLv, RewardId) of
        #base_investment_reward{condition = Condition} ->
            Condition;
        _ ->
            []
    end.

%% 购买
buy(#player_status{sid = Sid} = Player, Type, Lv) ->
    case check_buy(Player, Type, Lv) of
        {false, ErrCode} ->NewPlayer = Player;
        {true, Item, TypeCfg, DoType, Cost} ->
            FixCost = ?IF( Type == ?INVEST_DO_TYPE_MONTH_CARD, [], Cost),  %% 防止月卡多次扣费
            case do_buy(Player, Item, TypeCfg, DoType, FixCost) of
                {false, ErrCode} -> NewPlayer = Player;
                {ok, NewPlayer} -> ErrCode = ?SUCCESS
            end
    end,
    case ErrCode == ?SUCCESS of
        true ->
            {ok, BinData} = pt_420:write(42002, [Type, Lv]),
            lib_server_send:send_to_sid(Sid, BinData);
        false ->
            send_error(Sid, ErrCode)
    end,
    {ok, NewPlayer}.

check_buy(PS, Type, Lv) ->
    #player_status{investment = InvestmentStatus} = PS,
    case data_investment:get_type(Type, Lv) of
        #base_investment_type{price = Price, price_type = PriceType, condition = Condition, is_up = IsUp} = TypeCfg ->
            case maps:find(Type, InvestmentStatus) of
                {ok, #investment{cur_lv = Lv0}} when Lv0 > 0 andalso IsUp == 0 ->
                    {false, ?ERRCODE(err420_can_not_greater)};
                {ok, #investment{cur_lv = Lv0}} when Lv =< Lv0  ->
                    {false, ?ERRCODE(err420_need_buy_greater)};
                One ->
                    FixOne = ?IF( Type == ?INVEST_DO_TYPE_MONTH_CARD, [], One),
                    case lib_investment:check_buy(PS, Type, Condition, One) of
                        {true, #base_investment_item{do_type = DoType}} ->
                            Cost = case FixOne of
                                {ok, Item} ->
                                    calc_price(PriceType, Price, Type, Item#investment.cur_lv);
                                _ ->
                                    Item = #investment{type = Type},
                                    [{PriceType, 0, Price}]
                            end,
                            % Lv0 = Item#investment.cur_lv,
                            case Cost of
                                {false, Code} -> {false, Code};
                                _ -> {true, Item, TypeCfg, DoType, Cost}
                            end;
                        {false, Code} ->
                            {false, Code}
                    end
            end;
        _ ->
            {false, ?ERRCODE(err_config)}
    end.

do_buy(#player_status{id = RoleId, investment = InvestmentStatus} = PS, Item, TypeCfg, DoType, Cost) ->
    #base_investment_type{type = Type, level = Lv, price = Price, condition = Condition, any_tv_id = AnyTvId, first_tv_id = FirstTvId} = TypeCfg,
    Lv0 = Item#investment.cur_lv,
    case lib_goods_api:cost_object_list_with_check(PS, Cost, investment_buy, ulists:concat([Type, " from ", Lv0, " to ", Lv])) of
        {true, CostPS} ->
            NewItem = Item#investment{cur_lv = Lv},
            if
                AnyTvId > 0 ->
                    lib_chat:send_TV({all}, ?MOD_INVESTMENT, AnyTvId, [PS#player_status.figure#figure.name, RoleId, Price]);
                true ->
                    skip
            end,
            if
                Lv0 =:= 0 ->
                    if
                        % DoType =:= ?INVEST_DO_TYPE_MONTH_CARD ->
                        %     lib_chat:send_TV({all}, ?MOD_INVESTMENT, 2, [PS#player_status.figure#figure.name, RoleId]);
                        %     % lib_red_envelopes:trigger_red_envelopes(CostPS, ?RED_ENVELOPES_TYPE_MONTH_CARD);
                        % DoType =:= ?INVEST_DO_TYPE_VIP ->
                        %     lib_chat:send_TV({all}, ?MOD_INVESTMENT, 3, [PS#player_status.figure#figure.name, RoleId]);
                        %     % lib_red_envelopes:trigger_red_envelopes(CostPS, ?RED_ENVELOPES_TYPE_GOLD_INVEST);
                        FirstTvId > 0 ->
                            lib_chat:send_TV({all}, ?MOD_INVESTMENT, FirstTvId, [PS#player_status.figure#figure.name, RoleId]);
                        true ->
                            ok
                    end,
                    FinalItem = save_buy(RoleId, NewItem);
                true ->
                    update_buy(RoleId, NewItem),
                    FinalItem = NewItem
            end,
            NewStatus = InvestmentStatus#{Type => FinalItem},
            NewPS = CostPS#player_status{investment = NewStatus},
            NewPS1 = handle_buy_investment(NewPS, Type, Lv, Condition),
            case DoType of
                ?INVEST_DO_TYPE_MONTH_CARD ->
                    lib_red_envelopes:trigger_red_envelopes(NewPS1, ?RED_ENVELOPES_TYPE_MONTH_CARD),
                    mod_counter:increment_offline(RoleId, ?MOD_INVESTMENT, ?MOD_INVESTMENT_MONTHLY_CARD_BUY_COUNT),
                    % TA数据上报
                    ta_agent_fire:monthly_card_buy(NewPS1),
                    {ok, ValleyPS} = lib_eternal_valley_api:trigger(NewPS1, {month_card});
                ?INVEST_DO_TYPE_LV->
                    lib_red_envelopes:trigger_red_envelopes(NewPS1, ?RED_ENVELOPES_TYPE_LEVEL_INVEST),
                    {ok, ValleyPS} = lib_eternal_valley_api:trigger(NewPS1, {diamond_investment});
                ?INVEST_DO_TYPE_VIP->
                    {ok, ValleyPS} = lib_eternal_valley_api:trigger(NewPS1, {diamond_investment});
                _ -> ValleyPS = NewPS1
            end,
            {ok, LastPS} = lib_supreme_vip_api:buy_investment(ValleyPS, Type),
            lib_log_api:log_investment_buy(RoleId, Type, Lv0, Lv, Cost, PS#player_status.gold, LastPS#player_status.gold, utime:unixtime()),
            {ok, LastPS};
        {false, Code, _} ->
            {false, Code}
    end.

send_error(Sid, Code) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    {ok, BinData} = pt_420:write(42000, [CodeInt, CodeArgs]),
    % ?PRINT("investment error ~p~n", [Code]),
    lib_server_send:send_to_sid(Sid, BinData).

%% 发送开启列表[需要处理展示]
send_open_list(PS) ->
    List = handle_invest_show(PS),
    {ok, BinData} = pt_420:write(42004, [List]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData),
    ok.

%% 处理投资的展示
%% @return [{Type, State}]
handle_invest_show(#player_status{id = RoleId} = PS) ->
    TypeList = data_investment:get_type_list(),
    TypeDailyKeyL = [{?MOD_INVESTMENT, ?MOD_INVESTMENT_SHOW, Type}||Type<-TypeList],
    % 每日
    TypeDailyList = mod_daily:get_count(RoleId, TypeDailyKeyL),
    % 终身
    TypeCounterListL = mod_counter:get_count_and_refresh_time(RoleId, TypeDailyKeyL),
    F = fun({{Module, SubModule, Type} = Key, Count}, L) ->
        IsShow = Count > 0,
        case lists:keyfind(Key, 1, TypeCounterListL) of
            {_, _PermanentCount, RefreshTime} -> skip;
            _ -> _PermanentCount = 0, RefreshTime = 0
        end,
        #base_investment_item{show_id = ShowId} = data_investment:get_item(Type),
        case get_invest_open_info(PS, Type) of
            {false, miss, _ErrCode} -> L;
            {false, _ErrCode} -> ?IF(IsShow, [{Type, ShowId, 3, RefreshTime}|L], L);
            {true, all_get, _Item} ->
                Flag = IsShow orelse Type == ?INVEST_DO_TYPE_MONTH_CARD,   %% 特殊处理月卡
                ?IF(Flag, [{Type, ShowId, 2, RefreshTime}|L], L);
            {false, all_get, _Item} ->
                ?IF(IsShow, [{Type, ShowId, 2, RefreshTime}|L], L);
            {true, not_all_get, _Item} ->
                ?IF(IsShow, skip, mod_daily:set_count(RoleId, Module, SubModule, Type, 1)),
                [{Type, ShowId, 1, RefreshTime}|L];
            true ->
                ?IF(IsShow, skip, mod_daily:set_count(RoleId, Module, SubModule, Type, 1)),
                case RefreshTime > 0 of
                    true -> NewRefreshTime = RefreshTime;
                    false ->
                        mod_counter:set_count(RoleId, Module, SubModule, Type, 1),
                        NewRefreshTime = utime:unixtime()
                end,
                [{Type, ShowId, 0, NewRefreshTime}|L]
        end
    end,
    lists:foldl(F, [], TypeDailyList).

%% @return
%%  {false, miss, ErrCode} 直接忽略
%%  {false, ErrCode} 未开启
%%  {true, all_get, Item} 开启，全部领取完了
%%  {false, all_get, Item} 未开启，全部领取完了
%%  {true, not_all_get, Item} 没有领取完
%%  true 开启,但是没有领取过
get_invest_open_info(#player_status{investment = InvestmentStatus} = PS, Type) ->
    case data_investment:get_item(Type) of
        #base_investment_item{condition = Condition} ->
            case maps:find(Type, InvestmentStatus) of
                {ok, Item} ->
                    case all_reward_finish(Item) of
                        true ->
                            case check_condition(Condition, PS) of
                                true -> {true, all_get, Item};
                                {false, ErrCode} -> {false, all_get, ErrCode}
                            end;
                        false ->
                            {true, not_all_get, Item}
                    end;
                error ->
                    check_condition(Condition, PS)
            end;
        [] ->
            {false, miss, ?MISSING_CONFIG}
    end.

check_condition([], _PS) -> true;
check_condition([{min_lv, MinLv}|T], PS) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    case Lv >= MinLv of
        true -> check_condition(T, PS);
        false -> {false, ?PLAYER_LV_LESS_TO_OPEN(MinLv)}
    end;
check_condition([{max_lv, MaxLv}|T], PS) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    case Lv =< MaxLv of
        true -> check_condition(T, PS);
        false -> {false, ?PLAYER_LV_LARGE_TO_END(MaxLv)}
    end;
check_condition([{open_begin, OpenBegin}|T], PS) ->
    OpenDay = util:get_open_day(),
    case OpenDay >= OpenBegin of
        true -> check_condition(T, PS);
        false -> {false, ?OPEN_BEGIN_LESS_TO_OPEN(OpenBegin)}
    end;
check_condition([{open_end, OpenEnd}|T], PS) ->
    OpenDay = util:get_open_day(),
    case OpenDay =< OpenEnd of
        true -> check_condition(T, PS);
        false -> {false, ?OPEN_END_LARGE_TO_END(OpenEnd)}
    end;
check_condition([{merge_begin, MergeBegin}|T], PS) ->
    MergeDay = util:get_merge_day(),
    case MergeDay >= MergeBegin of
        true -> check_condition(T, PS);
        false -> {false, ?MERGE_BEGIN_LESS_TO_OPEN(MergeBegin)}
    end;
check_condition([{merge_end, MergeEnd}|T], PS) ->
    MergeDay = util:get_merge_day(),
    case MergeDay =< MergeEnd of
        true -> check_condition(T, PS);
        false -> {false, ?MERGE_END_LARGE_TO_END(MergeEnd)}
    end;
check_condition([{vip, NeedVip}|T], PS) ->
    #player_status{figure = #figure{vip = Vip}} = PS,
    case Vip >= NeedVip of
        true -> check_condition(T, PS);
        false -> {false, ?VIP_LIMIT}
    end;
check_condition([{custom_act_open, Type, SubType}|T], PS) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{stime=STime, etime=ETime} ->
            NowTime = utime:unixtime(),
            case NowTime >= STime andalso NowTime < ETime of
                true -> check_condition(T, PS);
                _ -> {false, ?ERRCODE(err331_act_closed)}
            end;
        false -> {false, ?ERRCODE(err331_act_closed)}
    end.

handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    NewPlayer = load_data(Player),
    case NewPlayer of
        % #player_status{investment = #{?INVEST_TYPE_EXTREME := #investment{cur_lv = Lv}}} when Lv > 0 ->
        %     {ok, LastPlayer} = lib_eternal_valley_api:trigger(NewPlayer, {diamond_investment});
        _ ->
            LastPlayer = NewPlayer
    end,
    {ok, LastPlayer};
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
    send_open_list(Player),
    {ok, Player};
handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{recharge_product = Product}}) ->
    #base_recharge_product{product_id = ProductId} = Product,
    case ProductId =:= ?MONTH_CARD_RECHARGE_ID of
        true ->
            lib_investment:buy(Player, ?INVEST_DO_TYPE_MONTH_CARD, 1);
        _ ->
            {ok, Player}
    end;
handle_event(Player, _) ->
    {ok, Player}.

%% 是否购买某一逻辑类型
is_buy(#player_status{investment = InvestmentStatus}, DoType) ->
    F = fun({Type, _Item}) ->
        case data_investment:get_item(Type) of
            #base_investment_item{do_type = DoType} -> true;
            _ -> false
        end
    end,
    lists:any(F, maps:to_list(InvestmentStatus)).

%% 是否购买某一类型
is_buy_by_type(#player_status{investment = undefined} = Player, Type) ->
    is_buy_by_type(load_data(Player), Type);
is_buy_by_type(#player_status{investment = InvestmentStatus}, Type) ->
   maps:is_key(Type, InvestmentStatus).

gm_get_reward(#player_status{investment = undefined} = PS, Type, RewardId) ->
    gm_get_reward(load_data(PS), Type, RewardId);

gm_get_reward(PS, Type, RewardId) ->
    #player_status{id = RoleId, sid = Sid, investment = InvestmentStatus} = PS,
    case maps:find(Type, InvestmentStatus) of
        {ok, Item} ->
            #investment{reward_info = RewardInfo, cur_lv = CurLv} = Item,
            case lists:keyfind(RewardId, 1, RewardInfo) of
                {RewardId, CurLv} ->
                    PS;
                One ->
                    case One of
                        {RewardId, Lv0} ->
                            ok;
                        _ ->
                            Lv0 = 0
                    end,
                    case calc_rewards(RewardId, Item, Lv0) of
                        [_|_] = Rewards ->
                            NewRewardInfo = lists:keystore(RewardId, 1, RewardInfo, {RewardId, CurLv}),
                            NewItem = Item#investment{reward_info = NewRewardInfo},
                            case data_investment:get_reset_type(Type) =:= ?RESET_TYPE_REWARD_FINISH andalso all_reward_finish(NewItem) of
                                true ->
                                    delete_investment(RoleId, Type),
                                    NewStatus = maps:remove(Type, InvestmentStatus);
                                _ ->
                                    update_reward(RoleId, NewItem),
                                    NewStatus = InvestmentStatus#{Type => NewItem}
                            end,
                            Produce = #produce{type = investment_reward, subtype = Type, reward = Rewards, remark = ulists:concat([Type, "-", CurLv])},
                            RewardPS = lib_goods_api:send_reward(PS, Produce),
                            {ok, BinData} = pt_420:write(42003, [Type, RewardId, Rewards]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            RewardPS#player_status{investment = NewStatus};
                        _ ->
                            PS
                    end
            end;
        _ ->
            PS
    end.

gm_update(PS, Type, List) ->
    #player_status{id = RoleId, investment = InvestmentStatus} = PS,
    ?PRINT("Type:~p List:~p InvestmentStatus:~p ~n", [Type, List, InvestmentStatus]),
    case maps:find(Type, InvestmentStatus) of
        {ok, Item} ->
            NewItem = do_gm_update(List, RoleId, Item),
            ?PRINT("NewItem:~p ~n", [NewItem]),
            update_reward(RoleId, NewItem),
            NewStatus = InvestmentStatus#{Type => NewItem},
            NewPS = PS#player_status{investment = NewStatus},
            pp_investment:handle(42001, NewPS, [Type]),
            NewPS;
        _ ->
            PS
    end.

do_gm_update([], _RoleId, Item) -> Item;
do_gm_update([H|T], RoleId, Item) ->
    case H of
        {get_time, GetTime} ->
            NewItem = Item#investment{get_time = GetTime},
            update_reward(RoleId, NewItem);
        {login_days, LoginDays} ->
            NewItem = Item#investment{login_days = LoginDays},
            update_login_days(RoleId, NewItem);
        _ ->
            NewItem = Item
    end,
    do_gm_update(T, RoleId, NewItem).

save_buy(RoleId, #investment{type = Type, cur_lv = Lv} = Item) ->
    Time = utime:unixtime(),
    LoginDays = 1, GetTime = 0,
    SQL = io_lib:format("INSERT INTO `investment_data` (`role_id`, `type`, `lv`, `buy_time`, get_time, days_utime, login_days) VALUES (~p, ~p, ~p, ~p, ~p, ~p, ~p)", [RoleId, Type, Lv, Time, GetTime, Time, LoginDays]),
    db:execute(SQL),
    Item#investment{buy_time = Time, get_time = GetTime, days_utime = Time, login_days = LoginDays}.

update_buy(RoleId, #investment{type = Type, cur_lv = Lv}) ->
    SQL = io_lib:format("UPDATE `investment_data` SET `lv` = ~p WHERE `role_id` = ~p AND `type` = ~p", [Lv, RoleId, Type]),
    db:execute(SQL).

update_reward(RoleId, #investment{type = Type, reward_info = RewardInfo, get_time = GetTime}) ->
    RewardInfoStr = util:term_to_string(RewardInfo),
    SQL = io_lib:format("UPDATE `investment_data` SET `reward_info` = '~s', get_time = ~p WHERE `role_id` = ~p AND `type` = ~p", [RewardInfoStr, GetTime, RoleId, Type]),
    db:execute(SQL).

delete_investment(RoleId, Type) ->
    SQL = io_lib:format("DELETE FROM `investment_data` WHERE `role_id` = ~p AND `type` = ~p", [RoleId, Type]),
    db:execute(SQL).

update_login_days(RoleId, #investment{type = Type, days_utime = DaysUtime, login_days = LoginDays}) ->
    SQL = io_lib:format("UPDATE `investment_data` SET days_utime=~p, login_days=~p WHERE `role_id` = ~p AND `type` = ~p", [DaysUtime, LoginDays, RoleId, Type]),
    db:execute(SQL).

%% 秘籍查看
gm_handle_invest_show(RoleId) when is_integer(RoleId) ->
    lib_player:apply_call(RoleId, ?APPLY_CALL_STATUS, ?MODULE, gm_handle_invest_show, []);
gm_handle_invest_show(PS) ->
    handle_invest_show(PS).

%% 秘籍删除投资
gm_delete_investment(#player_status{id = RoleId, investment = InvestmentStatus} = PS, Type) ->
    delete_investment(RoleId, Type),
    NewStatus = maps:remove(Type, InvestmentStatus),
    NewPS = PS#player_status{investment = NewStatus},
    send_open_list(NewPS),
    NewPS.

%% -----------------------------------------------------------------
%% @desc    功能描述 月卡特权处理
%% @param   参数
%% @return  返回值
%% -----------------------------------------------------------------

get_data(Ps) ->
    #player_status{investment = InvestmentStatus} = Ps,
    case maps:find(?INVEST_DO_TYPE_MONTH_CARD, InvestmentStatus) of
        {ok, Item} ->
            ?PRINT("Item:~p~n", [Item]),
            Item;
        _ ->
            []
    end.

login_check_reward(PlayerId, Item) ->
    #investment{buy_time = BuyTime, login_days = LoginDays, reward_info = RewardInfo} = Item,
    DiffDay = utime:diff_day(BuyTime),
    RewardInfoLength = erlang:length(RewardInfo),
    case DiffDay > RewardInfoLength of
        true ->
            AllRewardId = data_investment:get_all_reward_id(?INVEST_DO_TYPE_MONTH_CARD, 1),
            CfgDay = erlang:length(AllRewardId),
            FixDiffDay = ?IF( DiffDay >= CfgDay, CfgDay, DiffDay),
            SupplyDay = FixDiffDay - RewardInfoLength,
            {StartIndex, _Lv} = ?IF( RewardInfo == [], {0, 0}, lists:max(RewardInfo)),
            Filter = [ I || I <- AllRewardId, I > StartIndex],
            {SupplyRewardList, _Less} = ulists:sublist(Filter, SupplyDay),
            Fun = fun(SupplyRewardId, {RewardL, AddRewardInfo}) ->
                case data_investment:get_reward(?INVEST_DO_TYPE_MONTH_CARD, 1, SupplyRewardId) of
                    #base_investment_reward{ rewards = AwardsL } ->
                        NewRewardL = AwardsL ++ RewardL,
                        NewAddRewardInfo = lists:keystore(SupplyRewardId, 1, AddRewardInfo, {SupplyRewardId, 1}),
                        {NewRewardL, NewAddRewardInfo};
                    _ ->
                        {RewardL, AddRewardInfo}
                end
            end,
            {SendRewardL, AddRewardInfoL} = lists:foldl(Fun, {[], []}, SupplyRewardList),
            NowDate = utime:unixdate(),
            case SendRewardL == [] orelse AddRewardInfoL == [] of
                true ->
                    NewItem = Item#investment{ days_utime = NowDate, login_days = LoginDays + 1};
                false ->
                    Title = utext:get(4200001),
                    Content = utext:get(4200002, [SupplyDay]),
                    lib_mail_api:send_sys_mail([PlayerId], Title, Content, SendRewardL),
                    NewRewardInfo = AddRewardInfoL ++ RewardInfo,
                    NewItem = Item#investment{
                        days_utime = NowDate,
                        login_days = LoginDays + SupplyDay,
                        reward_info = NewRewardInfo,
                        get_time = NowDate - ?ONE_DAY_SECONDS + 1
                    }
            end,
            NewItem;
        false ->
            NowDate = utime:unixdate(),
            Item#investment{ days_utime = NowDate, login_days = LoginDays + 1}
    end.

%% 获取月卡功能对其他功能的加成
get_month_card_addition(#player_status{investment = undefined} = PS, ModVipAdd) ->
    get_month_card_addition(load_data(PS), ModVipAdd);
get_month_card_addition(Ps, ModVipAdd) ->
    #player_status{ investment = InvestmentMap } = Ps,
    case maps:find(?INVEST_DO_TYPE_MONTH_CARD, InvestmentMap) of
        {ok, Item} ->
            case is_month_card_expired(Item) of
                true -> 0;
                _ ->
                    case data_vip:data_num_by_vip_info(?MOD_INVESTMENT, ModVipAdd) of
                        #data_num_by_vip_info{ num = Add } -> Add;
                        _ -> 0
                    end
            end;
        _ -> 0
    end.

is_month_card_expired(#investment{type = ?INVEST_DO_TYPE_MONTH_CARD, buy_time = BuyTime}) ->
    DiffDay = utime:diff_day(BuyTime),
    DiffDay > ?MONTH_CARD_EFFECTIVE_TIME;
is_month_card_expired(_) ->
    false.


send_all_reward_before_time(_PlayerId, #investment{buy_time = BuyTime} = Item) when BuyTime == 0 ->
    Item;
send_all_reward_before_time(PlayerId, #investment{reward_info = RewardInfo, buy_time = _BuyTime} = Item) ->
    AllRewardId = data_investment:get_all_reward_id(?INVEST_DO_TYPE_MONTH_CARD, 1),
    Fun = fun(RewardId, {AddRewardL, Num}) ->
        case lists:keymember(RewardId, 1, RewardInfo) of
            true ->
                {AddRewardL, Num};
            _ ->
                #base_investment_reward{ rewards = AwardsL } = data_investment:get_reward(?INVEST_DO_TYPE_MONTH_CARD, 1, RewardId),
                NewRewardL = AwardsL ++ AddRewardL,
                {NewRewardL, Num + 1}
        end
    end,
    {AllRewardL, SupplyDay} = lists:foldl(Fun, {[], 0}, AllRewardId),
    case AllRewardL of
        [] ->
            Item;
        _ ->
            %% 先存最新的数据库
            delete_investment(PlayerId, ?INVEST_DO_TYPE_MONTH_CARD),
            Title = utext:get(4200001),
            Content = utext:get(4200002, [SupplyDay]),
            lib_mail_api:send_sys_mail([PlayerId], Title, Content, AllRewardL),
            #investment{type = ?INVEST_DO_TYPE_MONTH_CARD }
    end.

%% 月卡状态
is_month_card(PS) ->
    NewPS = lib_investment:load_data(PS),
    is_month_card_help(NewPS).

%% 月卡状态
%% false:无月卡； true:有月卡
is_month_card_help(#player_status{investment = InvestmentMap}) ->
    case maps:find(?INVEST_DO_TYPE_MONTH_CARD, InvestmentMap) of
        {ok, Item} ->
            case is_month_card_expired(Item) of
                true -> false;
                _ -> true
            end;
        _ ->
            false
    end.


%% -----------------------------------------------------------------
%% @desc 零点刷新月卡
%% @param
%% --------------------------------------------------------------z---
daily_refresh() ->
    spawn(fun()->
        OnlineRoleIds = lib_online:get_online_ids(),
        [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_investment, load_data, []) || RoleId <- OnlineRoleIds]
    end).

%% 每天第一次登录结算月卡
do_daily_refresh(?INVEST_DO_TYPE_MONTH_CARD, Item, RoleId) ->
    #investment{buy_time = BuyTime } = Item,
    case BuyTime > ?SPECIAL_TIME_POINT of
        true ->
            case all_reward_finish(Item) of
                true ->
                    ?MYLOG("lhh", "~p", [Item]),
                    delete_investment(RoleId, ?INVEST_DO_TYPE_MONTH_CARD),
                    NewItem = #investment{ type = ?INVEST_DO_TYPE_MONTH_CARD },
                    update_buy(RoleId, NewItem),
                    NewItem;
                false ->
                    NewItem = login_check_reward(RoleId, Item),
                    case all_reward_finish(NewItem) of
                        true -> %% 如果补领完最后一次属于完结时候，重设月卡信息
                            delete_investment(RoleId, ?INVEST_DO_TYPE_MONTH_CARD),
                            LastItem = #investment{ type = ?INVEST_DO_TYPE_MONTH_CARD },
                            update_buy(RoleId, NewItem),
                            LastItem;
                        _ ->
                            update_login_days(RoleId, NewItem),
                            update_reward(RoleId, NewItem),
                            NewItem
                    end
            end;
        false ->
            NewItem = send_all_reward_before_time(RoleId, Item),
            update_login_days(RoleId, NewItem),
            update_reward(RoleId, NewItem),
            NewItem
    end;
do_daily_refresh(_, #investment{ login_days = LoginDays } = Item, RoleId) ->
    NowDate = utime:unixdate(),
    NewItem = Item#investment{days_utime = NowDate, login_days = LoginDays + 1},
    update_login_days(RoleId, NewItem),
    NewItem.