%%-----------------------------------------------------------------------------
%% @Module  :       lib_consume_data.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-09
%% @Description:    
%%-----------------------------------------------------------------------------

-module (lib_consume_data).
-export ([
    get_consume_between/4
    ,get_consume_gold_between/3
    ,get_consume_bgold_between/3
    ,get_consume_coin_between/3
    ,is_consume_for_act/1
    ,update_money_consume/3
    ,update_money_consume/4
    ,advance_cost_objects/5
    ,advance_payment_done/2
    ,advance_payment_fail/3
%%    ,save_advance_payments/1
    ,get_consume_day_by_day/4
    % ,update_consume_coin/3
    % ,update_consume_gold/4
    ,clear_cache/1
    ,advance_payment_all_fail/3
    ,advance_payment_all_done/2
    ]).

-include ("common.hrl").
-include ("predefine.hrl").
-include ("server.hrl").
-include ("errcode.hrl").
-include ("figure.hrl").

-ifdef(DEV_SERVER).
-define(CHECK_PROCESS(Player), 
    begin 
        Self = self(), 
        Pid = 
        if 
            is_integer(Player) ->
                misc:get_player_process(Player);
            true ->
                Player#player_status.pid
        end,
        if
            Self =/= Pid ->
                ?ERR("CHECK_PROCESS error ~p ~p~n", [[Self, Pid], Player]);
            true ->
                ok
        end,
        Self = Pid
    end).
-else.
-define(CHECK_PROCESS(_), ok).
-endif.

-define (IGNORE_CONSUME_IDS, [88, 107, 141, 144, 157, 215, 334]).
-define (IGNORE_CONSUME_TYPES, [pay_sell, pay_tax, advance_payment, seek_goods, red_envelopes, pay_auction]).

% -define (FOR_ACT_1, 1). %% 消费是否参与活动

-record (consume, {
    start_time,
    items = []
    }).

-record (gold_item, {
    time,
    gold = 0,
    bgold = 0,
    consume_type
    }).

-record (coin_item, {
    time,
    coin = 0,
    consume_type
    }).


clear_cache(RoleId) ->
    ?CHECK_PROCESS(RoleId),
    erase({?MODULE, gold}),
    erase({?MODULE, coin}),
    ok.

get_consume_day_by_day(RoleId, ?GOLD, StartTime, EndTime) ->
    #consume{items = Items} = get_consume_gold_since(RoleId, StartTime),
    lists:foldl(
        fun(#gold_item{time = T, gold = G}, Acc) when G > 0 andalso T < EndTime andalso T >= StartTime ->
            ZeroTime = utime:standard_unixdate(T),
            case lists:keyfind(ZeroTime, 1, Acc) of
                {ZeroTime, Gold} ->
                    lists:keystore(ZeroTime, 1, Acc, {ZeroTime, Gold + G});
                _ ->
                    [{ZeroTime, G}|Acc]
            end;
            (_, Acc) -> Acc
        end, [], Items);

get_consume_day_by_day(RoleId, ?BGOLD, StartTime, EndTime) ->
    #consume{items = Items} = get_consume_gold_since(RoleId, StartTime),
    lists:foldl(
        fun(#gold_item{time = T, bgold = G}, Acc) when T < EndTime andalso G > 0 ->
            ZeroTime = utime:standard_unixdate(T),
            case lists:keyfind(ZeroTime, 1, Acc) of
                {ZeroTime, Gold} ->
                    lists:keystore(ZeroTime, 1, Acc, {ZeroTime, Gold + G});
                _ ->
                    [{ZeroTime, G}|Acc]
            end;
            (_, Acc) -> Acc
        end, [], Items);

get_consume_day_by_day(RoleId, ?COIN, StartTime, EndTime) ->
    #consume{items = Items} = get_consume_coin_since(RoleId, StartTime),
    lists:foldl(
        fun(#coin_item{time = T, coin = G}, Acc) when T < EndTime andalso G > 0 ->
            ZeroTime = utime:standard_unixdate(T),
            case lists:keyfind(ZeroTime, 1, Acc) of
                {ZeroTime, Gold} ->
                    lists:keystore(ZeroTime, 1, Acc, {ZeroTime, Gold + G});
                _ ->
                    [{ZeroTime, G}|Acc]
            end;
            (_, Acc) -> Acc
        end, [], Items).

get_consume_between(RoleId, ?GOLD, StartTime, EndTime) ->
    get_consume_gold_between(RoleId, StartTime, EndTime);

get_consume_between(RoleId, ?BGOLD, StartTime, EndTime) ->
    get_consume_bgold_between(RoleId, StartTime, EndTime);

get_consume_between(RoleId, ?COIN, StartTime, EndTime) ->
    get_consume_coin_between(RoleId, StartTime, EndTime);

get_consume_between(_RoleId, _, _StartTime, _EndTime) ->
    0.

get_consume_coin_between(RoleId, StartTime, EndTime) ->
    #consume{items = Items} = get_consume_coin_since(RoleId, StartTime),
    lists:sum([C || #coin_item{time = T, coin = C} <- Items, StartTime =< T andalso T < EndTime andalso C > 0]).

get_consume_gold_between(RoleId, StartTime, EndTime) ->
    #consume{items = Items} = get_consume_gold_since(RoleId, StartTime),
    lists:sum([G || #gold_item{time = T, gold = G} <- Items, StartTime =< T andalso T < EndTime andalso G > 0]).

get_consume_bgold_between(RoleId, StartTime, EndTime) ->
    #consume{items = Items} = get_consume_gold_since(RoleId, StartTime),
    lists:sum([G || #gold_item{time = T, bgold = G} <- Items, StartTime =< T andalso T < EndTime andalso G > 0]).

get_consume_gold_since(RoleId, StartTime) ->
    ?CHECK_PROCESS(RoleId),
    % self() = misc:get_player_process(RoleId),
    case get({?MODULE, gold}) of
        undefined ->
            load_and_combine_gold(RoleId, calc_cache_start_time(StartTime), utime:unixtime(), #consume{});
        #consume{start_time = STime} = D when STime > StartTime ->
            load_and_combine_gold(RoleId, calc_cache_start_time(StartTime), STime, D);
        D ->
            D 
    end.

get_consume_coin_since(RoleId, StartTime) ->
    ?CHECK_PROCESS(RoleId),
    case get({?MODULE, coin}) of
        undefined ->
            load_and_combine_coin(RoleId, StartTime, utime:unixtime(), #consume{});
        #consume{start_time = STime} = D when STime > StartTime ->
            load_and_combine_coin(RoleId, StartTime, STime, D);
        D ->
            D
    end.

%% 预付款 暂时不计入消费
update_money_consume(NewPlayer, Player, {advance_payment, Ref}) ->
    Coin = {Player#player_status.coin, NewPlayer#player_status.coin},
    Gold = {Player#player_status.gold, NewPlayer#player_status.gold},
    BGold = {Player#player_status.bgold, NewPlayer#player_status.bgold},
    case self() =:= Player#player_status.pid of
        true ->
            handle_advance_payment(Player#player_status.id, Coin, Gold, BGold, Ref, Player#player_status.figure#figure.lv);
        _ ->
            lib_player:apply_cast(Player#player_status.pid, ?APPLY_CAST, ?MODULE, handle_advance_payment, [Player#player_status.id, Coin, Gold, BGold, Ref, Player#player_status.figure#figure.lv])
    end;

update_money_consume(NewPlayer, Player, ConsumeType) ->
    case is_consume_for_act(ConsumeType) of
        true ->
            ConsumeId = data_goods:get_consume_type(ConsumeType),
            Coin = Player#player_status.coin - NewPlayer#player_status.coin,
            % NowTime = utime:unixtime(),
            Gold = Player#player_status.gold - NewPlayer#player_status.gold,
            BGold = Player#player_status.bgold - NewPlayer#player_status.bgold,
            case self() =:= Player#player_status.pid of
                true ->
                    update_money_consume(Coin, Gold, BGold, ConsumeId);
                _ ->
                    lib_player:apply_cast(Player#player_status.pid, ?APPLY_CAST, ?MODULE, update_money_consume, [Coin, Gold, BGold, ConsumeId])
            end;
        _ ->
            skip
    end.

update_money_consume(Coin, Gold, BGold, ConsumeType) when is_atom(ConsumeType) ->
    case is_consume_for_act(ConsumeType) of
        true ->
            ConsumeId = data_goods:get_consume_type(ConsumeType),
            update_money_consume(Coin, Gold, BGold, ConsumeId);
        _ ->
            skip
    end;
update_money_consume(Coin, Gold, BGold, ConsumeId) ->
    NowTime = utime:unixtime(),
    if
        Coin > 0 ->
            update_consume_coin(Coin, ConsumeId, NowTime);
        true ->
            ok
    end,
    if
        Gold > 0 orelse BGold > 0 ->
            update_consume_gold(Gold, BGold, ConsumeId, NowTime);
        true ->
            ok
    end.

handle_advance_payment(RoleId, {Coin1, Coin2}, {Gold1, Gold2}, {BGold1, BGold2}, Ref, Lv) ->
    case erase({advance_payment, Ref}) of
        {CostList, ConsumeId, About} ->
            RealCostList = calc_real_cost_list(CostList, Coin1 - Coin2, Gold1 - Gold2, BGold1 - BGold2),
            keep_accounts(RoleId, Ref, RealCostList, ConsumeId, About, [Coin2, Gold2, BGold2, Lv]);
        _ ->
            ?ERR("miss advance_payment data ~p~n", [[RoleId, {Coin1, Coin2}, {Gold1, Gold2}, {BGold1, BGold2}, Ref]])
    end.

update_consume_coin(Coin, ConsumeId, NowTime) ->
    % ?PRINT("update_consume_coin ~p~n", [[Coin, ConsumeId, get({?MODULE, coin})]]),
    case get({?MODULE, coin}) of
        undefined ->
            NewD = #consume{items = [#coin_item{time = NowTime, coin = Coin, consume_type = ConsumeId}], start_time = NowTime};
        #consume{items = Items} = D ->
            NewD = D#consume{items = [#coin_item{time = NowTime, coin = Coin, consume_type = ConsumeId}|Items]}
    end,
    put({?MODULE, coin}, NewD).

update_consume_gold(Gold, BGold, ConsumeId, NowTime) ->
    case get({?MODULE, gold}) of
        undefined ->
            NewD = #consume{items = [#gold_item{time = NowTime, gold = Gold, bgold = BGold, consume_type = ConsumeId}], start_time = NowTime};
        #consume{items = Items} = D ->
            NewD = D#consume{items = [#gold_item{time = NowTime, gold = Gold, bgold = BGold, consume_type = ConsumeId}|Items]}
    end,
    put({?MODULE, gold}, NewD).

load_and_combine_gold(RoleId, StartTime, EndTime, #consume{items = Items} = GoldCache) ->
    SQL = io_lib:format("SELECT `cost_gold`, `cost_bgold`, `consume_type`, `time` FROM `log_consume_gold` WHERE `player_id`=~p AND `time` >= ~p AND `time` < ~p AND `consume_type` NOT IN (~s)", [RoleId, StartTime, EndTime, ulists:list_to_string(?IGNORE_CONSUME_IDS, ",")]),
    NewItems = [#gold_item{time = T, gold = G, bgold = BG, consume_type = CT} || [G, BG, CT, T] <- db:get_all(SQL)],
    NewGoldCache = GoldCache#consume{start_time = StartTime, items = NewItems ++ Items},
    put({?MODULE, gold}, NewGoldCache),
    NewGoldCache.

load_and_combine_coin(RoleId, StartTime, EndTime, #consume{items = Items} = CoinCache) ->
    SQL = io_lib:format("SELECT `cost_coin`, `consume_type`, `time` FROM `log_consume_coin` WHERE `player_id`=~p AND `time` >= ~p AND `time` < ~p AND `consume_type` NOT IN (~s)", [RoleId, StartTime, EndTime, ulists:list_to_string(?IGNORE_CONSUME_IDS, ",")]),
    NewItems = [#coin_item{time = T, coin = C, consume_type = CT} || [C, CT, T] <- db:get_all(SQL)],
    NewCoinCache = CoinCache#consume{start_time = StartTime, items = NewItems ++ Items},
    put({?MODULE, coin}, NewCoinCache),
    NewCoinCache.

is_consume_for_act(ConsumeId) when is_integer(ConsumeId) ->
    not lists:member(ConsumeId, ?IGNORE_CONSUME_IDS);

is_consume_for_act(ConsumeType) when is_atom(ConsumeType) ->
    not lists:member(ConsumeType, ?IGNORE_CONSUME_TYPES);

is_consume_for_act(_) -> false.

%% 至少包含7天数据，避免多次读库
calc_cache_start_time(StartTime) ->
    StartTime.
%%calc_cache_start_time(StartTime) ->
%%    min(utime:unixdate() - 7 * ?ONE_DAY_SECONDS, StartTime).

calc_real_cost_list(List, 0, 0, 0) -> List;
calc_real_cost_list(List, Coin, Gold, BGold) ->
    OtherList = [Item || {Type, _, _} = Item <- List, Type =/= ?TYPE_GOLD andalso Type =/= ?TYPE_BGOLD andalso Type =/= ?TYPE_COIN],
    MoneyList = [Item || {_, _, Num} = Item <- [{?TYPE_COIN, 0, Coin}, {?TYPE_GOLD, 0, Gold}, {?TYPE_BGOLD, 0, BGold}], Num > 0],
    MoneyList ++ OtherList.

keep_accounts(RoleId, Ref, RealCostList, ConsumeId, About, OtherData) ->
    Accounts
    = case get(advance_payment_account) of
        undefined ->
            #{};
        Data ->
            Data
    end,
    NewAccounts = Accounts#{Ref => [RoleId, RealCostList, ConsumeId, About, OtherData]},
    CostListStr = util:term_to_string(RealCostList),
    OtherDataStr = util:term_to_string(OtherData),
    SQL = io_lib:format("INSERT INTO `advance_payment_account`(`ref`, `role_id`, `cost_list`, `consume_id`, `about`, `other`) VALUES ('~s', ~p, '~s', ~p, '~s', '~s')", [Ref, RoleId, CostListStr, ConsumeId, About, OtherDataStr]),
    db:execute(SQL),
    put(advance_payment_account, NewAccounts).

%% 消费记录预付款 应用于某些操作可能不成功而需要返回的
%% 目前必须在玩家进程执行 
%% 消耗里面必须要有钻石、绑钻或者金币才会有预付款
%% 否则该接口无效
%% return {false, Code, PS} | 
%% {true, NewPS, Ref} Ref是一个二进制字符串，长度为使用varchar(63) | 
%% {false, Code}
%% 该消耗不会马上参与消费活动，直到调用方执行了 advance_payment_done(RoleId, Ref)消费生效
%% 或者advance_payment_fail(RoleId, Ref, CallBack) %% 失败处理 Callback = {M, F, A}, M:F(CostList, A)
advance_cost_objects(PS, ObjectList, Type, About, AutoBuy) ->
    % CostList = [{Type, GoodsTypeId, GoodsNum}||{ {Type, GoodsTypeId}, GoodsNum} <- lib_goods_util:trans_object_list(ObjectList)],
    case lib_goods_util:check_object_list(PS, ObjectList) of
        {false, ErrorCode} ->
            case ErrorCode =:= ?GOODS_NOT_ENOUGH andalso AutoBuy of
                true ->
                    case lib_goods_api:calc_auto_buy_list(ObjectList) of
                        {ok, NewObjectList} ->
                            case lib_goods_util:check_object_list(PS, NewObjectList) of
                                true ->
                                    do_advance_cost_objects(PS, NewObjectList, Type, About);
                                Err ->
                                    Err
                            end;
                        _A ->
                            {false, ErrorCode}
                    end;
                _ ->
                    {false, ErrorCode}
            end;
        true ->
            do_advance_cost_objects(PS, ObjectList, Type, About);
        Res ->
            Res
    end.

do_advance_cost_objects(PS, CostList, ConsumeType, About) ->
    ?CHECK_PROCESS(PS),
    <<_:32, Ref/binary>> = util:term_to_bitstring(make_ref()),
    case data_goods:get_consume_type(ConsumeType) of
        ConsumeId when ConsumeId > 0 ->
            put({advance_payment, Ref}, {CostList, ConsumeId, About}),
            case lib_goods_util:cost_object_list(PS, CostList, {advance_payment, Ref}, util:term_to_string(ConsumeType)) of
                {true, NewPS} ->
                    {true, NewPS, Ref};
                Err ->
                    erase({advance_payment, Ref}),
                    Err %% {false, Res, PS}
            end
    end.

advance_payment_done(RoleId, Ref) ->
    PlayerPid = misc:get_player_process(RoleId),
    Self = self(),
    if
        PlayerPid =:= Self ->
            case get(advance_payment_account) of
                #{Ref := [RoleId, RealCostList, ConsumeId, About, OtherData]} = Accounts ->
                    finish_advance_payment(RoleId, RealCostList, ConsumeId, About, OtherData),
                    delete_advance_account(Ref),
                    put(advance_payment_account, Accounts#{Ref => done});
                #{Ref := _} ->
                    ok;
                _ ->
                    case load_advance_account(Ref) of
                        {ok, [RoleId, RealCostList, ConsumeId, About, OtherData]} ->
                            delete_advance_account(Ref),
                            finish_advance_payment(RoleId, RealCostList, ConsumeId, About, OtherData);
                        _ ->
                            ok
                    end,
                    put(advance_payment_account, #{Ref => done})
            end;
        true ->
            case misc:is_process_alive(PlayerPid) of
                true ->
                    lib_player:apply_cast(PlayerPid, ?APPLY_CAST, ?MODULE, advance_payment_done, [RoleId, Ref]);
                _ ->
                    case load_advance_account(Ref) of
                        {ok, [RoleId, RealCostList, ConsumeId, About, OtherData]} ->
                            delete_advance_account(Ref),
                            finish_advance_payment(RoleId, RealCostList, ConsumeId, About, OtherData);
                        _ ->
                            ok
                    end
            end
    end.


load_advance_account("") -> undefined;
load_advance_account(Ref) ->
    SQL = io_lib:format("SELECT `role_id`, `cost_list`, `consume_id`, `about`, `other` FROM `advance_payment_account` WHERE `ref` = '~s'", [Ref]),
    case db:get_row(SQL) of
        [RoleId, CostListStr, ConsumeId, About, OtherStr] ->
            {ok, [RoleId, util:bitstring_to_term(CostListStr), ConsumeId, About, util:bitstring_to_term(OtherStr)]};
        _ ->
            undefined
    end.

load_advance_account(RoleId, ConsumeId) ->
    SQL = io_lib:format("SELECT `ref`, `cost_list`, `about`, `other` FROM `advance_payment_account` WHERE `role_id` = ~p AND `consume_id` = ~p", [RoleId, ConsumeId]),
    [{Ref, [RoleId, util:bitstring_to_term(CostListStr), ConsumeId, About, util:bitstring_to_term(OtherStr)]} || [Ref, CostListStr, About, OtherStr] <- db:get_all(SQL)].

finish_advance_payment(RoleId, RealCostList, ConsumeId, About, OtherData) ->
    F = fun
        ({?TYPE_COIN, _, Num}, {Gold, Coin, BGold}) ->
            {Gold, Coin + Num, BGold};
        ({?TYPE_BGOLD, _, Num}, {Gold, Coin, BGold}) ->
            {Gold, Coin, BGold + Num};
        ({?TYPE_GOLD, _, Num}, {Gold, Coin, BGold}) ->
            {Gold + Num, Coin, BGold};
        (_, Acc) -> Acc %% 只记录3种货币
    end,
    {Gold, Coin, BGold} = lists:foldl(F, {0, 0, 0}, RealCostList),
     case OtherData of
         [CoinLeft, GoldLeft, BGoldLeft, RoleLv] -> ok;
         _ -> CoinLeft = 0, GoldLeft = 0, BGoldLeft = 0, RoleLv = 0
     end,
    NowTime = utime:unixtime(),
    if
        Coin > 0 ->
            mod_log:add_log(log_consume_coin, [
                                               NowTime, ConsumeId, RoleId, 0, 0, Coin, CoinLeft, ulists:concat([About, "(", advance_payment, ")"]), RoleLv]);
        Gold > 0 orelse BGold > 0 ->
            mod_log:add_log(log_consume_gold, [
                                               NowTime, ConsumeId, RoleId, 0, 0, Gold, BGold, GoldLeft, BGoldLeft, ulists:concat([About, "(", advance_payment, ")"]), RoleLv]);
        true ->
            skip
    end,
    case is_consume_for_act(ConsumeId) of
        true when Gold > 0 ->
            lib_vip_api:add_exp_by_gold(RoleId, Gold);
        _ ->
            ok
    end,
    case self() =:= misc:get_player_process(RoleId) of
        true ->
            update_money_consume(Coin, Gold, BGold, ConsumeId);
        _ ->
            ok
    end.

advance_payment_fail(RoleId, Ref, CallBack) ->
    PlayerPid = misc:get_player_process(RoleId),
    Self = self(),
    if
        PlayerPid =:= Self ->
            Res
            = case get(advance_payment_account) of
                #{Ref := [RoleId, RealCostList|_]} = Accounts ->
                    put(advance_payment_account, Accounts#{Ref => fail}),
                    delete_advance_account(Ref),
                    RealCostList;
                #{Ref := _} ->
                    [];
                _ ->
                    put(advance_payment_account, #{Ref => fail}),
                    case load_advance_account(Ref) of
                        {ok, [RoleId, RealCostList|_]} ->
                            delete_advance_account(Ref),
                            RealCostList;
                        _ ->
                            []
                    end
            end,
            advance_payment_fail_callback(CallBack, Res);
        true ->
            case misc:is_process_alive(PlayerPid) of
                true ->
                    lib_player:apply_cast(PlayerPid, ?APPLY_CAST, ?MODULE, advance_payment_fail, [RoleId, Ref, CallBack]);
                _ ->
                    Res
                    = case load_advance_account(Ref) of
                        {ok, [RoleId, RealCostList|_]} ->
                            delete_advance_account(Ref),
                            RealCostList;
                        _ ->
                            []
                    end,
                    advance_payment_fail_callback(CallBack, Res)
            end
    end.

advance_payment_fail_callback({Mod, Fun, Args}, Res) ->
    Mod:Fun(Res, Args);

advance_payment_fail_callback(_, _) -> ok.

delete_advance_account(Ref) ->
    SQL = io_lib:format("DELETE FROM `advance_payment_account` WHERE `ref`= '~s'", [Ref]),
    db:execute(SQL).

delete_advance_account(RoleId, ConsumeId) ->
    SQL = io_lib:format("DELETE FROM `advance_payment_account` WHERE `role_id`= ~p AND `consume_id` = ~p", [RoleId, ConsumeId]),
    db:execute(SQL).

%%save_advance_payments(RoleId) ->
%%    ?CHECK_PROCESS(RoleId),
%%    case get(advance_payment_account) of
%%        undefined ->
%%            ok;
%%        Accounts ->
%%            SaveList
%%            = maps:fold(fun
%%                (Ref, Data, Acc) ->
%%                    case Data of
%%                        [RoleId, RealCostList, ConsumeId, About, OtherData] ->
%%                            CostListStr = util:term_to_string(RealCostList),
%%                            OtherDataStr = util:term_to_string(OtherData),
%%                            [io_lib:format("('~s', ~p, '~s', ~p, '~s', '~s')", [Ref, RoleId, CostListStr, ConsumeId, About, OtherDataStr])|Acc];
%%                        _ ->
%%                            Acc
%%                    end
%%            end, [], Accounts),
%%            case SaveList of
%%                [] ->
%%                    skip;
%%                _ ->
%%                    SQL = io_lib:format("INSERT INTO `advance_payment_account`(`ref`, `role_id`, `cost_list`, `consume_id`, `about`, `other`) VALUES ~s", [ulists:list_to_string(SaveList, ",")]),
%%                    db:execute(SQL)
%%            end
%%    end.

advance_payment_all_done(RoleId, ConsumeId) when is_integer(RoleId) ->
    PlayerPid = misc:get_player_process(RoleId),
    case is_pid(PlayerPid) andalso misc:is_process_alive(PlayerPid) of
        true ->
            lib_player:apply_cast(PlayerPid, ?APPLY_CAST_STATUS, ?MODULE, advance_payment_all_done, [ConsumeId]);
        _ ->
            case clear_db_advance_payment(RoleId, make_sure_consume_id(ConsumeId)) of
                [] ->
                    ok;
                TotalList ->
                    [finish_advance_payment(RoleId, RealCostList, ConsumeId, About, OtherData) || {_, [_RoleId, RealCostList, _ConsumeId, About, OtherData]} <- TotalList]
            end
    end;

advance_payment_all_done(Player, ConsumeArgs) when is_record(Player, player_status) ->
    ConsumeId = make_sure_consume_id(ConsumeArgs),
    CacheCostList = clear_cache_advance_payment(Player, ConsumeId),
    CostInDbList = clear_db_advance_payment(Player#player_status.id, ConsumeId),
    case CacheCostList ++ CostInDbList of
        [] ->
            ok;
        TotalList ->
            [finish_advance_payment(RoleId, RealCostList, ConsumeId, About, OtherData) || {_, [RoleId, RealCostList, _ConsumeId, About, OtherData]} <- TotalList]
    end,
    ok.

advance_payment_all_fail(RoleId, ConsumeId, Callback) when is_integer(RoleId) ->
    PlayerPid = misc:get_player_process(RoleId),
    case is_pid(PlayerPid) andalso misc:is_process_alive(PlayerPid) of
        true ->
            lib_player:apply_cast(PlayerPid, ?APPLY_CAST_STATUS, ?MODULE, advance_payment_all_fail, [ConsumeId, Callback]);
        _ ->
            CostList = calc_all_cost_list(clear_db_advance_payment(RoleId, make_sure_consume_id(ConsumeId)), []),
            advance_payment_fail_callback(Callback, CostList)
    end;

advance_payment_all_fail(Player, ConsumeArgs, Callback) when is_record(Player, player_status) ->
    ConsumeId = make_sure_consume_id(ConsumeArgs),
    CacheCostList = calc_all_cost_list(clear_cache_advance_payment(Player, ConsumeId), []),
    CostInDbList = calc_all_cost_list(clear_db_advance_payment(Player#player_status.id, ConsumeId), []),
    CostList = lib_goods_api:make_reward_unique(CacheCostList ++ CostInDbList),
    advance_payment_fail_callback(Callback, CostList).

clear_cache_advance_payment(RoleId, ConsumeId) ->
    ?CHECK_PROCESS(RoleId),
    case get(advance_payment_account) of
        undefined ->
            Cache = [];
        Accounts ->
            Cache = maps:fold(fun (Ref, Data, Acc) ->
                case Data of
                    [_RoleId, _RealCostList, ConsumeId|_] ->
                        [{Ref, Data}|Acc];
                    _ ->
                        Acc
                end
                              end, [], Accounts),
%%            CacheCostList = lib_goods_api:make_reward_unique(lists:flatten([Cost || {_, Cost} <- Cache])),
            NewAccounts = lists:foldl(fun({Ref, _}, Map) -> Map#{Ref => fail} end, Accounts, Cache),
            put(advance_payment_account, NewAccounts)
    end,
    Cache.
    
clear_db_advance_payment(RoleId, ConsumeId) ->
    case load_advance_account(RoleId, ConsumeId) of
        [] ->
            [];
        List ->
            delete_advance_account(RoleId, ConsumeId),
            List
%%            calc_all_cost_list(List, [])
    end.

calc_all_cost_list([{_, [_RoleId, Cost|_]}|List], Acc) ->
    calc_all_cost_list(List, lib_goods_api:make_reward_unique(Cost ++ Acc));

calc_all_cost_list([], Acc) -> Acc.

make_sure_consume_id(ConsumeType) when is_atom(ConsumeType) ->
    data_produce_type:get_consume(ConsumeType);

make_sure_consume_id(ConsumeId) when is_integer(ConsumeId) ->
    ConsumeId.


