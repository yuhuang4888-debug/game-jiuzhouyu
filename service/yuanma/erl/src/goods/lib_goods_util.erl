%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2011-12-13
%% Description: 物品实用工具类
%% --------------------------------------------------------
-module(lib_goods_util).

-include("common.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("sql_goods.hrl").
-include("server.hrl").
-include("sell.hrl").
-include("sql_player.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_id_create.hrl").
-include("attr.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_module.hrl").
-include("skill.hrl").
-include("rune.hrl").
-include("soul.hrl").
-include("gift.hrl").
-include("decoration.hrl").
-include("seal.hrl").
-include("dragon.hrl").
-include("draconic.hrl").
-include("mon_pic.hrl").
% -export ([
%     is_enough_money/3         %% 计算余额够不够
%     , check_object_list/2       %% 判断是否满足消耗列表
%     , cost_object_list/5        %% 扣除消耗列表object_list
%     , get_money/2               %% 获取金钱数量
%     , get_money_offline/2       %% 获取金钱数量（离线版）
%     , cost_money/5              %% 扣钱
%     , cost_money_offline/5      %% 扣钱（离线版）
%     , add_money/5               %% 加钱
%     , goods_object_multiply_by/2 %% 将物品里面的数量乘以某个数
%     , calc_random_rewards/1     %% 根据随机配置计算出要发的奖励 可能返回[] 需要上层自己兼容
%     , is_random_rewards/1       %% 奖励配置是否随机
%     , goods_to_bind_goods/1     %% 物品转化成绑定物品
% ]).

-compile(export_all).

%%----------------------------------------------------
%% 计算余额够不够 true为充足，false为不足
%%----------------------------------------------------
is_enough_money(PlayerStatus, Cost, Type) ->
    case Type of
        ?BGOLD_AND_GOLD ->
            (PlayerStatus#player_status.bgold + PlayerStatus#player_status.gold) >= Cost;
        ?BGOLD ->
            (PlayerStatus#player_status.bgold + PlayerStatus#player_status.gold) >= Cost;
        ?COIN ->
            (PlayerStatus#player_status.coin) >= Cost;
        ?GOLD ->
            PlayerStatus#player_status.gold >= Cost;
        ?GCOIN ->
            PlayerStatus#player_status.gcoin >= Cost;
        ?HONOUR ->
            PlayerStatus#player_status.jjc_honour >= Cost
    end.

%% ---------------------------------------------------------------------------
%% @doc 判断是否满足消耗列表
-spec check_object_list(PS, ObjectList) ->  Return when
    PS             :: #player_status{},         %% #player_status{}
    ObjectList     :: list(),                   %% object_list :: [{type,goods_id,num}]
    Return         :: true | {false, integer()}.%% 返回：true|{false,错误码}
%% ---------------------------------------------------------------------------
check_object_list(PS, ObjectList) ->
    ObjectList2 = ulists:object_list_plus([[], ObjectList]),
    do_check_object_list(PS, ObjectList2).

do_check_object_list(_PS, []) -> true;
do_check_object_list(PS, [H|T]) ->
    case check_object(PS, H) of
        true -> do_check_object_list(PS, T);
        {false, Res} -> {false, Res}
    end.

%% 要扣除的物品数量需要大于0,不然提示错误
check_object(PS, { ?TYPE_GOODS, GoodsId, GoodsNum}) when GoodsNum > 0 ->
    case lib_goods_api:check_goods_num(PS, [{GoodsId, GoodsNum}]) of
        1 -> true;
        _ -> {false, ?GOODS_NOT_ENOUGH}
    end;
check_object(PS, { ?TYPE_GOLD, _GoodsId, GoodsNum}) when GoodsNum > 0 ->
    case lib_goods_util:is_enough_money(PS, GoodsNum, ?GOLD) of
        true -> true;
        false -> {false, ?GOLD_NOT_ENOUGH}
    end;
check_object(PS, { ?TYPE_BGOLD, _GoodsId, GoodsNum}) when GoodsNum > 0 ->
    case lib_goods_util:is_enough_money(PS, GoodsNum, ?BGOLD_AND_GOLD) of
        true -> true;
        false -> {false, ?BGOLD_NOT_ENOUGH}
    end;
check_object(PS, { ?TYPE_COIN, _GoodsId, GoodsNum}) when GoodsNum > 0 ->
    case lib_goods_util:is_enough_money(PS, GoodsNum, ?COIN) of
        true -> true;
        false -> {false, ?COIN_NOT_ENOUGH}
    end;
check_object(PS, { ?TYPE_HONOUR, _GoodsId, GoodsNum}) when GoodsNum > 0 ->
    case lib_goods_util:is_enough_money(PS, GoodsNum, ?HONOUR) of
        true -> true;
        false -> {false, ?HONOUR_NOT_ENOUGH}
    end;
check_object(PS, {?TYPE_CURRENCY, CurrencyId, GoodsNum}) when GoodsNum > 0 ->
    case lib_goods_util:is_enough_currency(PS, CurrencyId, GoodsNum) of
        true ->
            true;
        false ->
            % case data_goods_type:get(CurrencyId) of
            %     #ets_goods_type{goods_name = GoodsName} ->
            %         {false, {?ERRCODE(err150_currency_not_enough),[GoodsName]}};
            %     _ ->
            %         {false, ?GOODS_NOT_ENOUGH}
            % end
            {false, ?CURRENCY_NOT_ENOUGH}
    end;
%% check_object(PS, { {?TYPE_GCOIN, _GoodsId}, GoodsNum}) ->
%%     case lib_goods_util:is_enough_money(PS, GoodsNum, ?GCOIN) of
%%         true -> true;
%%         false -> {false, ?MONEY_NOT_ENOUGH}
%%     end;
check_object(_PS, { _Type, _GoodsId, _GoodsNum}) ->
    ?ERR("unkown object:~p", [{ {_Type, _GoodsId}, _GoodsNum}]),
    tool:back_trace_to_file(),
    {false, ?FAIL}.

%% ---------------------------------------------------------------------------
%% @doc 扣除消耗列表object_list
-spec cost_object_list(PS, ObjectList, Type, About) ->  Return when
    PS             :: #player_status{},         %% #player_status{}
    ObjectList     :: list(),                   %% object_list :: [{type,goods_id,num}]
    Type           :: atom(),                   %% 物品|货币消耗类型：需要后台定义"消耗类型"
    About          :: string(),                 %% 消耗描述
    Return         :: {true, #player_status{}}|{false, integer(), #player_status{}}. %% 返回：{true, PS}|{false,错误码,PS}
%% ---------------------------------------------------------------------------
cost_object_list(PS, [], _Type, _About) ->
    {true, PS};
cost_object_list(PS, [H|T], Type, About) ->
    case cost_object(PS, H, Type, About) of
        {true, NewPS} ->
            cost_object_list(NewPS, T, Type, About);
        {false, Res} ->
            {false, Res, PS}
    end.

cost_object(PS, {?TYPE_GOODS, GoodsId, GoodsNum}, Type, _About) ->
    case lib_goods_api:goods_delete_type_list(PS, [{GoodsId, GoodsNum}], Type) of
        1 -> {true, PS};
        _ -> {false, ?FAIL}
    end;
cost_object(PS, {GoodsId, GoodsNum}, Type, _About) ->
    case lib_goods_api:goods_delete_type_list(PS, [{GoodsId, GoodsNum}], Type) of
        1 -> {true, PS};
        _ -> {false, ?FAIL}
    end;
cost_object(PS, {?TYPE_GOLD, _GoodsId, GoodsNum}, Type, About) ->
    NewPS = cost_money(PS, GoodsNum, ?GOLD, Type, About),
    {true, NewPS};
%% cost_object(PS, {?TYPE_BGOLD, _GoodsId, GoodsNum}, Type, About) ->
%%     NewPS = cost_money(PS, GoodsNum, ?BGOLD, Type, About),
%%     {true, NewPS};
cost_object(PS, {?TYPE_BGOLD, _GoodsId, GoodsNum}, Type, About) ->
    NewPS = cost_money(PS, GoodsNum, ?BGOLD_AND_GOLD, Type, About),
    {true, NewPS};
cost_object(PS, {?TYPE_COIN, _GoodsId, GoodsNum}, Type, About) ->
    NewPS = cost_money(PS, GoodsNum, ?COIN, Type, About),
    {true, NewPS};
cost_object(PS, {?TYPE_HONOUR, _GoodsId, GoodsNum}, Type, About) ->
    NewPS = lib_jjc:cost_honour(PS, GoodsNum, ?HONOUR, Type, About),
    {true, NewPS};
cost_object(PS, {?TYPE_CURRENCY, CurrencyId, GoodsNum}, Type, About) ->
    NewPS = cost_currency(PS, CurrencyId, GoodsNum, Type, About),
    {true, NewPS};
cost_object(_PS, {_Type, _GoodsId, _GoodsNum}, _Type, _About) ->
    ?ERR("unkown object:~p", [_Type]),
    {false, ?FAIL}.

%% 扣除消耗列表object_list (物品模块内部使用)
cost_object_list(PS, [], _Type, _About, GoodsStatus) ->
    {true, GoodsStatus, PS};
cost_object_list(PS, [H|T], Type, About, GoodsStatus) ->
    case cost_object(PS, H, Type, About, GoodsStatus) of
        {true, NewStatus, NewPS} ->
            cost_object_list(NewPS, T, Type, About, NewStatus);
        {false, Res} ->
            {false, Res, GoodsStatus, PS}
    end.

cost_object(PS, {?TYPE_GOODS, GoodsId, GoodsNum}, Type, _About, GoodsStatus) ->
    case lib_goods:delete_type_list_goods({GoodsId,GoodsNum}, GoodsStatus) of
        {ok, NewStatus} ->
            lib_log_api:log_throw(Type, PS#player_status.id, 0, GoodsId, GoodsNum, 0, 0),
            {true, NewStatus, PS};
        _ -> {false, ?GOODS_NOT_ENOUGH}
    end;
cost_object(PS, {?TYPE_GOLD, _GoodsId, GoodsNum}, Type, About, GoodsStatus) ->
    NewPS = cost_money(PS, GoodsNum, ?GOLD, Type, About),
    {true, GoodsStatus, NewPS};
cost_object(PS, {?TYPE_BGOLD, _GoodsId, GoodsNum}, Type, About, GoodsStatus) ->
    NewPS = cost_money(PS, GoodsNum, ?BGOLD, Type, About),
    {true, GoodsStatus, NewPS};
cost_object(PS, {?TYPE_COIN, _GoodsId, GoodsNum}, Type, About, GoodsStatus) ->
    NewPS = cost_money(PS, GoodsNum, ?COIN, Type, About),
    {true, GoodsStatus, NewPS};
%% cost_object(PS, {?TYPE_GCOIN, _GoodsId, GoodsNum}, Type, About, GoodsStatus) ->
%%     NewPS = cost_money(PS, GoodsNum, ?GCOIN, Type, About),
%%     {true, GoodsStatus, NewPS};
cost_object(PS, {?TYPE_CURRENCY, CurrencyId, GoodsNum}, Type, About, GoodsStatus) ->
    NewPS = cost_currency(PS, CurrencyId, GoodsNum, Type, About),
    {true, GoodsStatus, NewPS};

cost_object(_PS, {_Type, _GoodsId, _GoodsNum}, _Type, _About, _GoodsStatus) ->
    ?ERR("unkown object:~p", [_Type]),
    {false, ?FAIL}.

%% 扣除消耗列表object_list (物品模块内部使用, PS轻量化，只取金钱相关参数)
lightly_cost_object_list(PSMoney, [], _Type, _About, GoodsStatus) ->
    {true, GoodsStatus, PSMoney};
lightly_cost_object_list(PSMoney, [H|T], Type, About, GoodsStatus) ->
    case lightly_cost_object(PSMoney, H, Type, About, GoodsStatus) of
        {true, NewStatus, NewPSMoney} ->
            lightly_cost_object_list(NewPSMoney, T, Type, About, NewStatus);
        {false, Res} ->
            {false, Res, GoodsStatus, PSMoney}
    end.

lightly_cost_object(PSMoney, {?TYPE_GOODS, GoodsId, GoodsNum}, Type, _About, GoodsStatus) ->
    case lib_goods:delete_type_list_goods({GoodsId,GoodsNum}, GoodsStatus) of
        {ok, NewStatus} ->
            lib_log_api:log_throw(Type, PSMoney#ps_money.id, 0, GoodsId, GoodsNum, 0, 0),
            {true, NewStatus, PSMoney};
        _ -> {false, ?GOODS_NOT_ENOUGH}
    end;
lightly_cost_object(PSMoney, {?TYPE_GOLD, _GoodsId, GoodsNum}, Type, About, GoodsStatus) ->
    NewPSMoney = lightly_cost_money(PSMoney, ?TYPE_GOLD, _GoodsId, GoodsNum, Type, About),
    {true, GoodsStatus, NewPSMoney};
lightly_cost_object(PSMoney, {?TYPE_BGOLD, _GoodsId, GoodsNum}, Type, About, GoodsStatus) ->
    NewPSMoney = lightly_cost_money(PSMoney, ?TYPE_BGOLD, _GoodsId, GoodsNum, Type, About),
    {true, GoodsStatus, NewPSMoney};
lightly_cost_object(PSMoney, {?TYPE_COIN, _GoodsId, GoodsNum}, Type, About, GoodsStatus) ->
    NewPSMoney = lightly_cost_money(PSMoney, ?TYPE_COIN, _GoodsId, GoodsNum, Type, About),
    {true, GoodsStatus, NewPSMoney};
lightly_cost_object(PSMoney, {?TYPE_CURRENCY, CurrencyId, GoodsNum}, Type, About, GoodsStatus) ->
    NewPSMoney = lightly_cost_money(PSMoney, ?TYPE_CURRENCY, CurrencyId, GoodsNum, Type, About),
    {true, GoodsStatus, NewPSMoney};

lightly_cost_object(PSMoney, {_Type, _GoodsId, _GoodsNum}, _Type, _About, GoodsStatus) ->
    ?ERR("unkown object:~p", [_Type]),
    {false, ?FAIL, GoodsStatus, PSMoney}.

%% ---------------------------------------------------------------------------
%% @doc 获取货币数量
-spec get_money(PlayerStatus, MoneyType) ->  Return when
    PlayerStatus   :: #player_status{},   %% #player_status{}
    MoneyType      :: atom(),             %% 货币类型
    Return         :: integer().          %% 金钱数量
%% ---------------------------------------------------------------------------
get_money(PlayerStatus, MoneyType) ->
    case MoneyType of
        ?COIN -> % 铜钱
            PlayerStatus#player_status.coin;
        ?BGOLD ->
            PlayerStatus#player_status.bgold;
        ?GOLD ->
            PlayerStatus#player_status.gold;
        ?BGOLD_AND_GOLD ->
            PlayerStatus#player_status.bgold + PlayerStatus#player_status.gold;
        _ ->
            ?ERR("unkown MoneyType:~p", [MoneyType]),
            0
    end.

%% ---------------------------------------------------------------------------
%% @doc 获取货币数量（离线版）
-spec get_money_offline(PlayerId, MoneyType) ->  Return when
    PlayerId       :: integer(),          %% 玩家Id
    MoneyType      :: atom(),             %% 货币类型
    Return         :: integer().          %% 金钱数量
%% ---------------------------------------------------------------------------
get_money_offline(PlayerId, MoneyType) ->
    [Gold, BGold, Coin, GCoin] = lib_player:get_player_money_data(PlayerId),
    case MoneyType of
        ?GOLD  -> Gold;
        ?BGOLD -> BGold;
        ?COIN  -> Coin;
        ?GCOIN -> GCoin;
        _ -> ?ERR("unkown MoneyType:~p", [MoneyType]), 0
    end.

%% ---------------------------------------------------------------------------
%% @doc 扣钱
-spec cost_money(PlayerStatus, Cost, MoneyType, Type, About) ->  Return when
    PlayerStatus   :: #player_status{},   %% #player_status{}
    Cost           :: integer(),          %% 数量
    MoneyType      :: atom(),             %% 货币类型
    Type           :: atom(),             %% 货币消耗类型：需要后台定义"产出消耗类型--消耗类型"
    About          :: string(),           %% 扣钱描述
    Return         :: #player_status{}.   %% #player_status{}
%% ---------------------------------------------------------------------------
cost_money(PlayerStatus, Cost, MoneyType, Type, About) ->
    NewPlayerStatus1 = do_cost_money(PlayerStatus, Cost, MoneyType, Type),
    if
        Type=/=[] andalso Type=/=none ->
            lib_log_api:log_consume(Type, MoneyType, PlayerStatus, NewPlayerStatus1, About);
        true -> skip
    end,
    NewPlayerStatus1.

cost_money(PS, CostList, Type, About) ->
    CoinList = [{coin, Num} || {coin, Num} <- CostList],
    GoldList = [{gold, Num} || {gold, Num} <- CostList],
    F = fun({_, Num}, Sum) -> Num + Sum end,
    CostCoin = lists:foldl(F, 0, CoinList),
    CostGold = lists:foldl(F, 0, GoldList),
    NewPS = cost_money(PS, CostCoin, coin, Type, About),
    cost_money(NewPS, CostGold, gold, Type, About).

%% 新款扣钱
lightly_cost_money(PSMoney, GType, GoodsTypeId, Num, Type, About) ->
    #ps_money{id = RoleId, lv = Lv, gold = OldGold, bgold = OldBGold, coin = OldCoin, currency_map = OldCurrencyMap, real_cost = OldRealCost} = PSMoney,
    case GType of
        ?TYPE_GOLD ->
            MoneyType = ?GOLD, Left = OldGold - Num,
            NewPsMoney = PSMoney#ps_money{gold = Left};
        ?TYPE_COIN ->
            MoneyType = ?COIN, Left = OldCoin - Num,
            NewPsMoney = PSMoney#ps_money{coin = Left};
        ?TYPE_BGOLD ->
            case OldBGold < Num of
                false ->
                    MoneyType = ?BGOLD, Left = OldBGold - Num,
                    NewPsMoney = PSMoney#ps_money{bgold = Left};
                true  ->
                    MoneyType = ?BGOLD_AND_GOLD, Left = OldBGold + OldGold - Num,
                    NewPsMoney = PSMoney#ps_money{bgold = 0, gold = Left}
            end;
        ?TYPE_CURRENCY ->
            MoneyType = ?CURRENCY,
            OldCurrencyCoin = maps:get(GoodsTypeId, OldCurrencyMap, 0),
            Left = OldCurrencyCoin - Num,
            NewCurrencyMap = maps:put(GoodsTypeId, Left, OldCurrencyMap),
            NewPsMoney = PSMoney#ps_money{currency_map = NewCurrencyMap}
    end,
    %% 验证计算
    if
        Left < 0 -> throw(money_error);
        true -> skip
    end,
    %% 更新数据库and日志
    NowTime = utime:unixtime(),
    CsumeType = data_goods:get_consume_type(Type),
    if
        MoneyType == ?GOLD orelse MoneyType == ?COIN orelse MoneyType == ?BGOLD orelse MoneyType == ?BGOLD_AND_GOLD ->
            #ps_money{gold = NewGold, bgold = NewBGold, coin = NewCoin, gcoin = NewGCoin} = NewPsMoney,
            case MoneyType == ?COIN of
                true ->
                    lib_log_api:log_consume_2(log_consume_coin, [NowTime, CsumeType, RoleId, 0, 0, Num, NewCoin, About, Lv]);
                _ ->
                    CostGold = NewGold - OldGold, CostBgold = NewBGold - OldBGold,
                    lib_log_api:log_consume_2(log_consume_gold, [NowTime, CsumeType, RoleId, 0, 0, CostGold, CostBgold, NewGold, NewBGold, About, Lv])
            end,
            lib_player:update_player_money(RoleId, NewGold, NewBGold, NewCoin, NewGCoin);
        MoneyType == ?CURRENCY ->
            lib_log_api:log_consume_currency(RoleId, Type, GoodsTypeId, Num, Left, About),
            SQL = io_lib:format(?SQL_UPDATE_CURRENCY, [Left, RoleId, GoodsTypeId]),
            db:execute(SQL);
        true -> skip
    end,
    % 计数器
    lists:member(GType, ?DAILY_COUNTER_REC_TYPES) andalso mod_daily:plus_count_offline(RoleId, ?MOD_GOODS, ?MOD_GOODS_DAILY_CONSUME, GType, Num),
    RealCost = [{GType, GoodsTypeId, Num}|OldRealCost],
    NewPsMoney#ps_money{real_cost = RealCost}.

% new_cost_money(PsMoney)->
%     NewPsMoney = new_do_cost_money(PsMoney),
%     #ps_money{gold = Gold, bgold = BGold, coin = Coin} = PsMoney,
%     #ps_money{gold = NewGold, bgold = NewBGold, coin = NewCoin} = NewPsMoney,
%     if
%         PsMoney#ps_money.type =/= [] andalso PsMoney#ps_money.type =/= none andalso
%         (Gold /= NewGold orelse BGold /= NewBGold orelse Coin /= NewCoin) ->
%             lib_log_api:new_log_consume(PsMoney, NewPsMoney);
%         true ->
%             skip
%     end,
%     NewPsMoney.

% %% 新扣钱处理
% new_do_cost_money(PsMoney)->
%     #ps_money{gold = OldGold, bgold = OldBGold, coin = OldCoin, gcoin = OldGCoin, coin_cost = CoinCost} = PsMoney,
%     F = fun({Type, _Id, Num}, PsMoneyTmp) ->
%         #ps_money{gold = Gold, bgold = BGold, coin = Coin} = PsMoneyTmp,
%         case Type of
%             ?TYPE_GOLD -> PsMoneyTmp#ps_money{gold = (Gold - Num)};
%             ?TYPE_COIN -> PsMoneyTmp#ps_money{coin = (Coin - Num)};
%             ?TYPE_BGOLD ->
%                 case BGold < Num of
%                     false -> PsMoneyTmp#ps_money{bgold = (BGold - Num)};
%                     true  -> PsMoneyTmp#ps_money{bgold = 0, gold = (BGold + Gold - Num)}
%                 end;
%             _ -> PsMoneyTmp
%         end
%     end,
%     NewPsMoney = lists:foldl(F, PsMoney, CoinCost),
%     %% 验证计算
%     #ps_money{id = RoleId, gold = NewGold, bgold = NewBGold, coin = NewCoin, gcoin = NewGCoin} = NewPsMoney,
%     RealCost = #{?GOLD=>(OldGold-NewGold), ?COIN=>(OldCoin-NewCoin), ?BGOLD=>(OldBGold-NewBGold), ?GCOIN=>(OldGCoin-NewGCoin)},
%     if
%         NewCoin < 0  orelse NewBGold < 0 orelse NewGold < 0 orelse NewGCoin < 0 ->
%             %% Playeer:玩家,  MoneyError:金钱错误
%             lists:concat(["Player:", RoleId, ", bgold=", NewBGold, ", gold=", NewGold, ", gcoin=", NewGCoin]),
%             throw(money_error);
%         true ->
%             skip
%     end,
%     %% 更新数据库
%     lib_player:update_player_money(RoleId, NewGold, NewBGold, NewCoin, NewGCoin),
%     NewPsMoney#ps_money{real_cost = RealCost}.

%% 新款增加金钱
% new_add_money(PsMoney) ->
%     NewPsMoney = new_do_add_money(PsMoney),
%     #ps_money{gold = Gold, bgold = BGold, coin = Coin} = PsMoney,
%     #ps_money{gold = NewGold, bgold = NewBGold, coin = NewCoin} = NewPsMoney,
%     if
%         PsMoney#ps_money.type =/= [] andalso PsMoney#ps_money.type =/= none andalso
%         (Gold /= NewGold orelse BGold /= NewBGold orelse Coin /= NewCoin) ->
%             lib_log_api:new_log_produce(PsMoney, NewPsMoney);
%         true ->
%             skip
%     end,
%     NewPsMoney.

% new_do_add_money(PsMoney) ->
%     #ps_money{gold = OldGold, bgold = OldBGold, coin = OldCoin, gcoin = OldGCoin, coin_reward = CoinReward} = PsMoney,
%     F = fun({Type, _Id, Num}, PsMoneyTmp) ->
%         #ps_money{gold = Gold, bgold = BGold, coin = Coin} = PsMoneyTmp,
%         case Type of
%             ?TYPE_GOLD -> PsMoneyTmp#ps_money{gold = (Gold + Num)};
%             ?TYPE_COIN -> PsMoneyTmp#ps_money{coin = (Coin + Num)};
%             ?TYPE_BGOLD -> PsMoneyTmp#ps_money{bgold = (BGold + Num)};
%             _ -> PsMoneyTmp
%         end
%     end,
%     NewPsMoney = lists:foldl(F, PsMoney, CoinReward),
%     %% 验证计算
%     #ps_money{id = RoleId, gold = NewGold, bgold = NewBGold, coin = NewCoin, gcoin = NewGCoin} = NewPsMoney,
%     RealReward = #{?GOLD=>(NewGold-OldGold), ?COIN=>(NewCoin-OldCoin), ?BGOLD=>(NewBGold-OldBGold), ?GCOIN=>(NewGCoin-OldGCoin)},
%     %% 更新数据库
%     lib_player:update_player_money(RoleId, NewGold, NewBGold, NewCoin, NewGCoin),
%     NewPsMoney#ps_money{real_reward = RealReward}.

%%-----------------------------------------------------------
%% @doc 扣钱,不够钱会抛出错误,调用前要判断是否够钱
%%【注】
%% 没有日志：不要直接调用cost_money(PlayerStatus, Cost, MoneyType)
%% 调用cost_money(PlayerStatus, Cost, MoneyType, Type, About)
-spec do_cost_money(PlayerStatus, Cost, MoneyType, Type) -> Return when
    PlayerStatus    :: #player_status{},   %% 玩家记录
    Cost            :: integer(),          %% 消耗的数量
    MoneyType       :: integer(),          %% 类型
    Type            :: atom(),             %% 货币消耗类型：需要后台定义"产出消耗类型--消耗类型"
    Return          :: #player_status{}.   %% #player_status{}
%% ------------------------------------------------------------
do_cost_money(#player_status{id = RoleId} = PlayerStatus, Cost, MoneyType, Type) ->
    case MoneyType of
        ?COIN -> % 铜钱
            NewPlayerStatus = PlayerStatus#player_status{coin = (PlayerStatus#player_status.coin - Cost)};
        ?GCOIN ->
            NewPlayerStatus = PlayerStatus#player_status{gcoin = (PlayerStatus#player_status.gcoin - Cost)};
        ?BGOLD ->
            case PlayerStatus#player_status.bgold < Cost of
                false ->
                    mod_daily:plus_count_offline(RoleId, ?MOD_GOODS, ?MOD_GOODS_DAILY_CONSUME, ?TYPE_BGOLD, Cost),
                    NewPlayerStatus = PlayerStatus#player_status{bgold = (PlayerStatus#player_status.bgold - Cost)};
                true ->
                    mod_daily:plus_count_offline(RoleId, ?MOD_GOODS, ?MOD_GOODS_DAILY_CONSUME, ?TYPE_BGOLD, PlayerStatus#player_status.bgold),
                    mod_daily:plus_count_offline(RoleId, ?MOD_GOODS, ?MOD_GOODS_DAILY_CONSUME, ?TYPE_GOLD, Cost - PlayerStatus#player_status.bgold),
                    NewPlayerStatus = PlayerStatus#player_status{bgold = 0, gold = (PlayerStatus#player_status.bgold + PlayerStatus#player_status.gold - Cost)}
            end;
        ?GOLD ->
            mod_daily:plus_count_offline(RoleId, ?MOD_GOODS, ?MOD_GOODS_DAILY_CONSUME, ?TYPE_GOLD, Cost),
            NewPlayerStatus = PlayerStatus#player_status{gold = (PlayerStatus#player_status.gold - Cost)}; % 元宝
        ?BGOLD_AND_GOLD -> % 绑定元宝和元宝 silver_and_gold
           case PlayerStatus#player_status.bgold < Cost of
              false ->
                  mod_daily:plus_count_offline(RoleId, ?MOD_GOODS, ?MOD_GOODS_DAILY_CONSUME, ?TYPE_BGOLD, Cost),
                  NewPlayerStatus = PlayerStatus#player_status{bgold = (PlayerStatus#player_status.bgold - Cost)};
              true ->
                  mod_daily:plus_count_offline(RoleId, ?MOD_GOODS, ?MOD_GOODS_DAILY_CONSUME, ?TYPE_BGOLD, PlayerStatus#player_status.bgold),
                  mod_daily:plus_count_offline(RoleId, ?MOD_GOODS, ?MOD_GOODS_DAILY_CONSUME, ?TYPE_GOLD, Cost - PlayerStatus#player_status.bgold),
                  NewPlayerStatus = PlayerStatus#player_status{bgold = 0, gold = (PlayerStatus#player_status.bgold + PlayerStatus#player_status.gold - Cost)}
          end

    end,
    %判断金钱数
    if  NewPlayerStatus#player_status.coin < 0  orelse NewPlayerStatus#player_status.bgold < 0
        orelse NewPlayerStatus#player_status.gold < 0 ->
            %% Playeer:玩家,  MoneyError:金钱错误
            lists:concat(["Playeer：",NewPlayerStatus#player_status.id," ",
                  NewPlayerStatus#player_status.figure#figure.name,
                  " MoneyError：coin=", NewPlayerStatus#player_status.coin,
                  ", bgold=",NewPlayerStatus#player_status.bgold,
                  ", gold=",NewPlayerStatus#player_status.gold
                  ]),
            throw(money_error);
        true ->
            skip
    end,
    lib_player:update_player_money(PlayerStatus, NewPlayerStatus),
    lib_player:send_attribute_change_notify(NewPlayerStatus, ?NOTIFY_MONEY),
    lib_consume_data:update_money_consume(NewPlayerStatus, PlayerStatus, Type),
    case MoneyType of
        ?BGOLD_AND_GOLD -> % 绑定元宝和元宝 silver_and_gold
            case PlayerStatus#player_status.bgold < Cost of
                false ->
                    lib_player_event:async_dispatch(NewPlayerStatus#player_status.pid, ?EVENT_MONEY_CONSUME,
                        #callback_money_cost{consume_type = Type, money_type = MoneyType, cost = Cost});
                true ->
                    % 绑定钻石不够,派发绑定钻石事件和钻石事件
                    lib_player_event:async_dispatch(NewPlayerStatus#player_status.pid, ?EVENT_MONEY_CONSUME,
                        #callback_money_cost{consume_type = Type, money_type = ?BGOLD, cost = PlayerStatus#player_status.bgold}),
                    lib_player_event:async_dispatch(NewPlayerStatus#player_status.pid, ?EVENT_MONEY_CONSUME,
                        #callback_money_cost{consume_type = Type, money_type = ?GOLD, cost = Cost - PlayerStatus#player_status.bgold})
            end;
        _ ->
            lib_player_event:async_dispatch(NewPlayerStatus#player_status.pid, ?EVENT_MONEY_CONSUME,
                #callback_money_cost{consume_type = Type, money_type = MoneyType, cost = Cost})
    end,
    NewPlayerStatus.

%% ---------------------------------------------------------------------------
%% @doc 扣钱（离线版）
-spec cost_money_offline(PlayerId, Cost, MoneyType, Type, About) ->  Return when
    PlayerId       :: integer(),          %% 玩家Id
    Cost           :: integer(),          %% 数量
    MoneyType      :: atom(),             %% 货币类型
    Type           :: atom(),             %% 货币消耗类型：需要后台定义"产出消耗类型--消耗类型"
    About          :: string(),           %% 扣钱描述
    Return         :: ok|error.           %% 返回
%% ---------------------------------------------------------------------------
cost_money_offline(PlayerId, Cost, MoneyType, Type, About) ->
    F = fun() ->
        do_cost_money_offline(PlayerId, Cost, MoneyType, Type, About),
        ok
    end,
    case catch db:transaction(F) of
        ok -> ok;
        Error ->
            ?ERR("cost_money_offline:~p~n", [Error]),
            error
    end.

do_cost_money_offline(PlayerId, Cost, MoneyType, Type, About) ->
    [Gold, BGold, Coin, GCoin] = lib_player:get_player_money_data(PlayerId),
    case MoneyType of
        ?COIN ->
            NewGold = Gold, NewBGold = BGold, NewCoin = Coin - Cost, NewGCoin = GCoin;
        ?GCOIN ->
            NewGold = Gold, NewBGold = BGold, NewCoin = Coin, NewGCoin = GCoin - Cost;
        ?BGOLD ->
            % NewGold = Gold, NewBGold = BGold - Cost, NewCoin = Coin, NewGCoin = GCoin;
            case BGold < Cost of
                false ->
                    NewGold = Gold, NewBGold = BGold - Cost, NewCoin = Coin, NewGCoin = GCoin;
                true ->
                    NewGold = BGold + Gold - Cost, NewBGold = 0, NewCoin = Coin, NewGCoin = GCoin
            end;
        ?GOLD ->
            NewGold = Gold - Cost, NewBGold = BGold, NewCoin = Coin, NewGCoin = GCoin;
        ?BGOLD_AND_GOLD ->
            case BGold < Cost of
                false ->
                    NewGold = Gold, NewBGold = BGold - Cost, NewCoin = Coin, NewGCoin = GCoin;
                true ->
                    NewGold = BGold + Gold - Cost, NewBGold = 0, NewCoin = Coin, NewGCoin = GCoin
            end
    end,
    %判断金钱数
    if  NewGold < 0  orelse NewBGold < 0 orelse NewCoin < 0 orelse NewGCoin < 0->
            %% Playeer:玩家,  MoneyError:金钱错误
            lists:concat(["Playeer Offline：",PlayerId,
                  " MoneyError：coin=", NewCoin,
                  ", bgold=", NewBGold,
                  ", gold=", NewGold
                  ]),
            throw(money_error);
        true ->
            skip
    end,
    Args = [NewGold, NewBGold, NewCoin, NewGCoin, PlayerId],
    Sql = io_lib:format(?sql_update_player_money, Args),
    db:execute(Sql),
    if
        Type=/=[] andalso Type=/=none ->
            lib_log_api:log_consume_offline(
                PlayerId, Type, MoneyType, Cost, [Gold, BGold, Coin, GCoin], [NewGold, NewBGold, NewCoin, NewGCoin], About);
        true -> skip
    end.

cost_currency(PS, CurrencyId, Num, Type, About) ->
    #player_status{currency_map = CMap, id = PlayerId} = PS,
    case maps:find(CurrencyId, CMap) of
        {ok, Value} when Value >= Num andalso Num > 0 ->
            NewValue = Value - Num,
            SQL = io_lib:format(?SQL_UPDATE_CURRENCY, [NewValue, PlayerId, CurrencyId]),
            db:execute(SQL),
            NewPS = PS#player_status{currency_map = CMap#{CurrencyId => NewValue}},
            if
                Type=/=[] andalso Type=/=none ->
                    lib_log_api:log_consume_currency(PlayerId, Type, CurrencyId, Num, NewValue, About),
                    ta_agent_fire:log_consume_currency(NewPS, [CurrencyId, Num, data_goods:get_consume_type(Type)]);
                true -> skip
            end,
            lib_goods_api:send_update_currency(NewPS, CurrencyId),
            lib_consume_currency_data:update_money_consume(NewPS, CurrencyId, Num, Type),
            lib_player_event:async_dispatch(NewPS#player_status.pid, ?EVENT_MONEY_CONSUME_CURRENCY,
                        #callback_currency_cost{consume_type = Type, currency_id = CurrencyId, cost = Num}),
            NewPS;
        _ ->
            throw(money_error)
    end.

%%-----------------------------------------------------------------------------
%% @doc 加钱
%% -spec add_money(PlayerStatus, Amount, Type) -> NewPlayerStatus
%% PlayerStatus | NewPlayerStatus   ::  玩家记录
%% Amount                           ::  增加的数量
%% Type                             ::  要加的类型
%%     coin:铜钱 rcoin:铜钱 一般不用 bgold:绑定元宝 gold:元宝 bcoin:绑定铜币，不用
%% @end
%% ---------------------------------------------------------------------------------
add_money(PlayerStatus, Amount, Type) ->
    add_money(PlayerStatus, Amount, Type, none, "").

%% ---------------------------------------------------------------------------
%% @doc 加钱
-spec add_money(PlayerStatus, Amount, MoneyType, Type, About) ->  Return when
    PlayerStatus   :: #player_status{},   %% #player_status{}
    Amount         :: integer(),          %% 数量
    MoneyType      :: atom(),             %% 货币类型
    Type           :: atom(),             %% 货币产出类型
    About          :: string(),           %% 产出描述
    Return         :: #player_status{}.   %% #player_status{}
%% ---------------------------------------------------------------------------
add_money(#player_status{id = RoleId} = PlayerStatus, Amount, MoneyType, ProduceType, About) ->
    case MoneyType of
        ?COIN ->
            GType = ?TYPE_COIN,
            Total = PlayerStatus#player_status.coin + Amount,
            PS = PlayerStatus#player_status{coin =Total},
            %% 触发金币成就
            {ok, NewPlayerStatus} = lib_achievement_api:coin_get_event(PS, Amount);
        ?GCOIN ->
            GType = ?TYPE_COIN,
            Total = PlayerStatus#player_status.gcoin + Amount,
            NewPlayerStatus = PlayerStatus#player_status{gcoin =Total};
        ?BGOLD ->
            GType = ?TYPE_BGOLD,
            NewPlayerStatus = PlayerStatus#player_status{bgold = (PlayerStatus#player_status.bgold + Amount)};
        ?GOLD ->
            GType = ?TYPE_GOLD,
            NewPlayerStatus = PlayerStatus#player_status{gold = (PlayerStatus#player_status.gold + Amount)}
    end,
    lists:member(GType, ?DAILY_COUNTER_REC_TYPES) andalso mod_daily:plus_count_offline(RoleId, ?MOD_GOODS, ?MOD_GOODS_DAILY_GET, GType, Amount),
    lib_player:update_player_money(PlayerStatus, NewPlayerStatus),
    lib_player:send_attribute_change_notify(NewPlayerStatus, ?NOTIFY_MONEY),
    if
        ProduceType=/=none -> lib_log_api:log_produce(ProduceType, MoneyType, PlayerStatus, NewPlayerStatus, About);
        true -> skip
    end,
    NewPlayerStatus.

%% 金币内存添加，请自己增加添加db机制
add_money_memory(PlayerStatus, Amount, MoneyType, ProduceType, About) ->
    case MoneyType of
        ?COIN ->
            Total = PlayerStatus#player_status.coin + Amount,
            PS = PlayerStatus#player_status{coin = Total},
            %% 触发金币成就
            {ok, NewPlayerStatus} = lib_achievement_api:coin_get_event(PS, Amount);
        ?GCOIN ->
            Total = PlayerStatus#player_status.gcoin + Amount,
            NewPlayerStatus = PlayerStatus#player_status{gcoin = Total}
    end,
    lib_player:send_attribute_change_notify(NewPlayerStatus, ?NOTIFY_MONEY),
    if
        ProduceType =/= none -> lib_log_api:log_produce(ProduceType, MoneyType, PlayerStatus, NewPlayerStatus, About);
        true -> skip
    end,
    NewPlayerStatus.

add_currency(PS, CurrencyId, Value) ->
    #player_status{currency_map = CMap, id = PlayerId} = PS,
    case maps:find(CurrencyId, CMap) of
        {ok, 0} ->
            New = Value,
            SQL = io_lib:format(?SQL_REPLACE_CURRENCY, [PlayerId, CurrencyId, New]);
        {ok, Old} ->
            New = Old + Value,
            SQL = io_lib:format(?SQL_UPDATE_CURRENCY, [New, PlayerId, CurrencyId]);
        _ ->
            New = Value,
            SQL = io_lib:format(?SQL_INSERT_CURRENCY, [PlayerId, CurrencyId, New])
    end,
    db:execute(SQL),
    NewPS = PS#player_status{currency_map = CMap#{CurrencyId => New}},
    lib_goods_api:send_update_currency(NewPS, CurrencyId),
    case CurrencyId of
        ?GOODS_ID_STAR ->
            pp_star_map:handle(42200, NewPS, []);
        _ ->
            skip
    end,
    NewPS.



%% 是否叠加在同一个背包格子
%% 绑定、有效时间、锁定时间一致才叠加在同一格子，不然另外新起格子
%% OldGoodsInfo 已有物品记录
%% AddGoodsInfo 新增物品记录
can_overlap_same_cell(OldGoodsInfo, AddGoodsInfo) ->
    #goods{type = Type, bind = Bind, expire_time = ExpireTime, lock_time = LockTime, other = GoodsOther} = OldGoodsInfo,
    if
        Type == ?GOODS_TYPE_GIFT orelse Type == ?GOODS_TYPE_COUNT_GIFT ->
            case AddGoodsInfo of
                #goods{bind = Bind, expire_time = ExpireTime, lock_time = LockTime, other = AddGoodsOther} ->
                    GoodsOther#goods_other.optional_data == AddGoodsOther#goods_other.optional_data;
                _ -> false
            end;
        true ->
            case AddGoodsInfo of
                #goods{bind = Bind, expire_time = ExpireTime, lock_time = LockTime} -> true;
                _ -> false
            end
    end.


%% NPC已领取礼包列表
get_gift_got_list(PlayerId) ->
    Sql = io_lib:format(?SQL_GIFT_SELECT_GOT, [PlayerId]),
    List = db:get_all(Sql),
    [GiftId || [GiftId] <- List].

%% ---------------------------------------------------------------------------
%% @doc 取装备列表
-spec get_equip_list(PlayerId, Dict) -> Return when
    PlayerId    :: integer(),       %% 玩家id
    Dict        :: dict:new(),      %% 物品dict
    Return      :: list().          %% 物品信息列表[#goods{}]
%% ---------------------------------------------------------------------------
get_equip_list(PlayerId, Dict) ->
    EquipList = get_equip_list(PlayerId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, Dict),
    %% MountList = get_equip_list(PlayerId, ?GOODS_TYPE_MOUNT, ?GOODS_LOC_EQUIP, Dict),
    EquipList.


%% 获取幻饰装备
get_dec_equip_list(PlayerId, Dict) ->
    EquipList = get_equip_list(PlayerId, ?GOODS_TYPE_DECORATION, ?GOODS_LOC_DECORATION, Dict),
    %% MountList = get_equip_list(PlayerId, ?GOODS_TYPE_MOUNT, ?GOODS_LOC_EQUIP, Dict),
    EquipList.

get_seal_equip_list(PlayerId, Dict) ->
    EquipList = get_equip_list(PlayerId, ?GOODS_TYPE_SEAL, ?GOODS_LOC_SEAL_EQUIP, Dict),
    EquipList.

get_draconic_equip_list(PlayerId, Dict) ->
    EquipList = get_equip_list(PlayerId, ?GOODS_TYPE_DRACONIC, ?GOODS_LOC_DRACONIC_EQUIP, Dict),
    EquipList.

get_revelation_equip_list(PlayerId, Dict) ->
    EquipList = get_equip_list(PlayerId, ?GOODS_TYPE_REVELATION, ?GOODS_LOC_REVELATION, Dict),
    EquipList.

%% 获取所有常规攻装
get_attack_equip_list(PlayerId, Dict) ->
    EquipList = get_equip_list(PlayerId, Dict),
    [Equip || #goods{equip_type = EquipType} = Equip <- EquipList, lists:member(EquipType, ?ATTACK_EQUIP_TYPES)].

%% 获取所有常规防装
get_defence_equip_list(PlayerId, Dict) ->
    EquipList = get_equip_list(PlayerId, Dict),
    [Equip || #goods{equip_type = EquipType} = Equip <- EquipList, lists:member(EquipType, ?DEFENCE_EQUIP_TYPES)].

%% ---------------------------------------------------------------------------
%% @doc 取装备列表
-spec get_equip_list(_PlayerId, Type, Location, Dict) -> Return when
    _PlayerId   :: integer(),       %% 玩家id
    Type        :: integer(),       %% 物品大类型
    Location    :: integer(),       %% 物品位置
    Dict        :: dict:new(),      %% 物品dict
    Return      :: list().          %% 物品信息列表[#goods{}]
%% ---------------------------------------------------------------------------
get_equip_list(_PlayerId, Type, Location, Dict) ->
    case Dict =/= [] of
        true ->
            Dict1 = dict:filter(fun(_Key, [Value]) ->
                Value#goods.type =:= Type andalso Value#goods.location =:= Location end, Dict),
            DictList = dict:to_list(Dict1),
            List = lib_goods_dict:get_list(DictList, []),
            List;
        false ->
            []
    end.
get_equip_list(_PlayerId, Type, Dict) ->
    case Dict =/= [] of
        true ->
            Dict1 = dict:filter(fun(_Key, [Value]) -> Value#goods.type=:=Type end, Dict),
            DictList = dict:to_list(Dict1),
            List = lib_goods_dict:get_list(DictList, []),
            List;
        false ->
            []
    end.
%% 加上颜色判断
%% Location integer() | lists()
%% Color integer() | lists()
get_equip_list(_PlayerId, Type, Location, Color, Dict) ->
    case is_integer(Location) of
        true -> LocationL = [Location];
        false -> LocationL = Location
    end,
    case is_integer(Color) of
        true -> ColorL = [Color];
        false -> ColorL = Color
    end,
    case Dict =/= [] of
        true ->
            Dict1 = dict:filter(fun(_Key, [Value]) ->
                Value#goods.type =:= Type andalso lists:member(Value#goods.location, LocationL) andalso lists:member(Value#goods.color, ColorL)
            end, Dict),
            DictList = dict:to_list(Dict1),
            List = lib_goods_dict:get_list(DictList, []),
            List;
        false ->
            []
    end.

%% 组装装备的列表
%% @return [物品的元组信息]
equip_list_format(PlayerId, GoodsStatus) ->
    GoodsDict = GoodsStatus#goods_status.dict,
    EquipList = lib_goods_util:get_equip_list(PlayerId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, GoodsDict),
    F = fun(GoodsInfo) ->
        [
            {id, GoodsInfo#goods.id},
            {goods_id, GoodsInfo#goods.goods_id},
            {cell, GoodsInfo#goods.cell},
            {num, GoodsInfo#goods.num},
            {bind, GoodsInfo#goods.bind},
            {trade, GoodsInfo#goods.trade},
            {sell, GoodsInfo#goods.sell},
            {isdrop, GoodsInfo#goods.isdrop},
            {expire_time, GoodsInfo#goods.expire_time},
            {price_type, GoodsInfo#goods.price_type},

            {color, GoodsInfo#goods.color},
            {equip_type, GoodsInfo#goods.equip_type},
            {stren, GoodsInfo#goods.other#goods_other.stren},
            {refine, GoodsInfo#goods.other#goods_other.refine},
            {suit_id, GoodsInfo#goods.other#goods_other.suit_id}
            %% 属性
        ]
    end,
    [F(Goods) || Goods <- EquipList].

%% 根据列表组装#goods{}
goods_info_format_by_list([], GoodsInfo) -> GoodsInfo;
goods_info_format_by_list([H|AttrKeyValueList], GoodsInfo) ->
    GoodsOther = GoodsInfo#goods.other,
    NewGoodsInfo = case H of
        {id, V}         -> GoodsInfo#goods{id = V};
        {goods_id, V}   -> GoodsInfo#goods{goods_id = V};
        {cell, V}       -> GoodsInfo#goods{cell = V};
        {num, V}        -> GoodsInfo#goods{num = V};
        {bind, V}       -> GoodsInfo#goods{bind = V};
        {trade, V}      -> GoodsInfo#goods{trade = V};
        {sell, V}       -> GoodsInfo#goods{sell = V};
        {isdrop, V}     -> GoodsInfo#goods{isdrop = V};
        {expire_time, V} -> GoodsInfo#goods{expire_time = V};
        {price_type, V} -> GoodsInfo#goods{price_type = V};
        {color, V}      -> GoodsInfo#goods{color = V};

        {equip_type, V} -> GoodsInfo#goods{equip_type = V};
        {stren, V}      -> GoodsInfo#goods{other = GoodsOther#goods_other{stren = V}};
        {refine, V}      -> GoodsInfo#goods{other = GoodsOther#goods_other{refine = V}};
        {suit_id, V}    -> GoodsInfo#goods{other = GoodsOther#goods_other{suit_id = V}};
        %% 属性
        _               -> GoodsInfo
    end,
    goods_info_format_by_list(AttrKeyValueList, NewGoodsInfo).

%%------------------------------------------------
%% @doc 物品信息,物品字典里没有会去数据库里取
%% -spec get_goods_info(GoodsId, Dict) -> GoodsInfo|[]
%% when
%%      GoodsId     :: integer() 物品Id
%%      Dict        :: dict()    物品字典
%%      GoodsInfo   :: #goods{}  物品信息
%%      []                       没有物品
%% @end
%%------------------------------------------------
get_goods_info(GoodsId, Dict) ->
    case Dict =/= [] of
        true ->
            Dict1 = dict:filter(fun(_Key, [Value]) -> Value#goods.id =:= GoodsId end, Dict),
            DictList = dict:to_list(Dict1),
            List = lib_goods_dict:get_list(DictList, []);
        false ->
            List = []
    end,
    case List =:= [] of
        true ->
            _GoodsInfo = get_goods_by_id(GoodsId),
            _GoodsInfo;
        false ->
            [GoodsInfo|_] = List,
            GoodsInfo
    end.
%%------------------------------------------------------------
%% 从数据库里找对应Id的物品
%%------------------------------------------------------------
get_goods_by_id(GoodsId) ->
	Sql = io_lib:format(?SQL_GOODS_SELECT_BY_ID, [GoodsId]),
	Info = db:get_row(Sql),
	case make_info(goods, Info) of
		[] ->
			[];
		[GoodsInfo] ->
			GoodsInfo
	end.

%%----------------------------------------------------------------------------------------------------
%% 把数据库里取出来的数据构建成物品记录
%%----------------------------------------------------------------------------------------------------
make_info(Table, Info) ->
    case Table of
        goods when Info =/= [] ->
            [
                Id, PlayerId, GuildId, GoodsId, Type, Subtype, EquipType, PriceType, Price,
                Bind, _Trade, _Sell, Level, SuitId, SkillId, Location, SubLocation, Cell,
                Num, Color, ExpireTime, LockTime, Addition, ExtraAttr, OtherData, CTime
            ] = Info,
            case data_goods_type:get(GoodsId) of
                GoodsTypeR when is_record(GoodsTypeR, ets_goods_type) ->
                    %% 物品额外记录
                    case load_goods_other(Type) of
                        true ->
                            GoodsOtherTmp = make(other, [SuitId, SkillId, Addition, ExtraAttr, OtherData]),
                            GoodsOther = case Type of %% 装备类型要计算基础装备评分
                                ?GOODS_TYPE_EQUIP ->
                                    BaseRating = lib_equip:cal_equip_rating(GoodsTypeR, GoodsOtherTmp#goods_other.extra_attr),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                %% 幻兽装备也用了人物装备的评分规则
                                ?GOODS_TYPE_EUDEMONS ->
                                    BaseRating = lib_eudemons:cal_equip_rating(GoodsTypeR, GoodsOtherTmp#goods_other.extra_attr),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                ?GOODS_TYPE_SEAL ->
                                    BaseRating = lib_seal:cal_equip_rating(GoodsTypeR, GoodsOtherTmp#goods_other.extra_attr),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                ?GOODS_TYPE_DRACONIC ->
                                    BaseRating = lib_draconic:cal_equip_rating(GoodsTypeR, GoodsOtherTmp#goods_other.extra_attr),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                ?GOODS_TYPE_MOUNT_EQUIP ->
                                    BaseRating = lib_mount_equip:cal_figure_equip_rating(Subtype, GoodsOtherTmp#goods_other.optional_data, 1),
                                    %%?PRINT("============ Subtype :~p, GoodsOtherTmp#goods_other.optional_data:~p BaseRating  :~p~n",[Subtype, GoodsOtherTmp#goods_other.optional_data, BaseRating]),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                ?GOODS_TYPE_MATE_EQUIP ->
                                    BaseRating = lib_mount_equip:cal_figure_equip_rating(Subtype, GoodsOtherTmp#goods_other.optional_data, 2),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                ?GOODS_TYPE_PET_EQUIP ->
                                    BaseRating = lib_pet:cal_equip_rating(Subtype, GoodsOtherTmp#goods_other.optional_data),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                ?GOODS_TYPE_DECORATION ->
                                    BaseRating = lib_equip:cal_equip_rating(GoodsTypeR, GoodsOtherTmp#goods_other.extra_attr),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                ?GOODS_TYPE_CONSTELLATION ->
                                    BaseRating = lib_constellation_equip:cal_equip_rating(GoodsTypeR),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                ?GOODS_TYPE_SOUL ->  % 修复旧数据
                                    %%                                                 ?PRINT("GOODS_TYPE_SOUL====== :~n",[]),
                                    NewExtraAttr = lib_soul:count_one_soul_extra_attr(Subtype, Color, Level),
                                    GoodsOtherTmp#goods_other{extra_attr = NewExtraAttr};
                                ?GOODS_TYPE_BABY_EQUIP ->
                                    BaseRating = lib_equip:cal_equip_rating(GoodsTypeR, []),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                ?GOODS_TYPE_GOD_EQUIP ->
                                    BaseRating = lib_god_util:cal_equip_rating(GoodsTypeR),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                ?GOODS_TYPE_REVELATION ->
                                    BaseRating = lib_equip:cal_equip_rating(GoodsTypeR, []),
                                    GoodsOtherTmp#goods_other{rating = BaseRating};
                                ?GOODS_TYPE_GOD_COURT ->
                                    BaseRating = lib_god_court:cal_goods_rating(GoodsTypeR),
                                    GoodsOtherTmp#goods_other{rating = round(BaseRating)};
                                _ -> GoodsOtherTmp
                            end;
                        false ->
                            GoodsOther = #goods_other{}
                    end,
                    %% 物品记录
                    Goods = make(goods, [Id, PlayerId, GuildId, GoodsId, Type, Subtype, EquipType, PriceType, Price,
                                         Bind, GoodsTypeR#ets_goods_type.trade, GoodsTypeR#ets_goods_type.sell, Location, SubLocation, Cell, Num,  ExpireTime, LockTime, Level, Color, GoodsOther, CTime]),
                    [Goods];
                _ -> %% 没有该物品配置
                    %catch ?ERR("lib_goods_util:make_info/2 ERROR: no such a goods config, goods_id=~p~n", [GoodsId]),
                    []
            end;
        _ -> []
    end.

make(goods, [Id, PlayerId, GuildId, GoodsId, Type, Subtype, EquipType, PriceType, Price,
             Bind, Trade, Sell, Location, SubLocation, Cell, Num, ExpireTime, LockTime, Level, Color, Other, CTime]) ->
    case data_goods_type:get(GoodsId) of
        #ets_goods_type{type = TypeCfg, bag_location = BagLocation, subtype = SubTypeCfg} ->
            %% 策划将礼包的物品类型更改了，先对这个类型的物品处理下 符文也是
            if
                TypeCfg == ?GOODS_TYPE_OPTIONAL_GIFT andalso TypeCfg =/= Type ->
                    NSubType = Subtype,
                    NType = TypeCfg;
                TypeCfg == ?GOODS_TYPE_RUNE->
                    NSubType = SubTypeCfg,
                    NType = TypeCfg;
                true ->
                    NSubType = Subtype,
                    NType = Type
            end;
        _ -> BagLocation = ?GOODS_LOC_BAG, NType = Type,  NSubType = Subtype
    end,
    #goods{
        id = Id, player_id = PlayerId, guild_id = GuildId, goods_id = GoodsId, type = NType,
        subtype = NSubType, equip_type = EquipType, price_type = PriceType, price = Price,
        bind = Bind, trade = Trade, sell = Sell, bag_location = BagLocation, location = Location, sub_location = SubLocation,
        cell = Cell, num = Num, expire_time = ExpireTime, lock_time = LockTime, level = Level,
       color = Color, other = Other, ctime = CTime
    };
make(other, [SuitId, SkillId, Addition, ExtraAttr, OtherData]) ->
    Other = #goods_other{
        suit_id = SuitId, skill_id = SkillId, addition = to_term(Addition), extra_attr = to_term(ExtraAttr)
    },
    make_other(Other, to_term(OtherData));
make(equip_stren, [Stren]) ->
    #equip_stren{ stren = Stren };

make(equip_refine, [Refine]) ->
    #equip_refine{
        refine = Refine
    };

make(equip_stone, [RefineLv, StoneList]) ->
    #equip_stone{
        refine_lv = RefineLv, stone_list = StoneList
    }.

make_other(Other, [?GOODS_OTHER_KEY_EUDEMONS_EXP|Data]) ->
    lib_eudemons:make_goods_other(Other, Data);

%%降神装备
make_other(Other, [?GOODS_OTHER_KEY_GOD | Data]) ->
    lib_god_util:make_goods_other(Other, Data);


%%公会神像装备
make_other(Other, [?GOODS_OTHER_KEY_GUILD_GOD | Data]) ->
    lib_guild_god_util:make_goods_other(Other, Data);

make_other(Other, [?GOODS_OTHER_KEY_SEAL | Data]) ->
    lib_seal:make_goods_other(Other, Data);
%% 精灵装备
make_other(Other, [?GOODS_OTHER_KEY_PET_EQUIP | Data]) ->
    Other#goods_other{optional_data = [?GOODS_OTHER_KEY_PET_EQUIP | Data]};

%% 坐骑装备
make_other(Other, [?GOODS_OTHER_KEY_MOUNT_EQUIP | Data]) ->
    Other#goods_other{optional_data = [?GOODS_OTHER_KEY_MOUNT_EQUIP | Data]};

%% 伙伴装备
make_other(Other, [?GOODS_OTHER_KEY_MATE_EQUIP | Data]) ->
    Other#goods_other{optional_data = [?GOODS_OTHER_KEY_MATE_EQUIP | Data]};

%% 次数礼包
make_other(Other, [?GOODS_OTHER_KEY_COUNT_GIFT|Data]) ->
    case Data of
        [DayCount, UseCount, LastGetTime, FreezeEndtime] ->
            CountGift = [#count_gift{day_count = DayCount, use_count = UseCount, last_get_time = LastGetTime, freeze_endtime = FreezeEndtime}];
        _ -> CountGift = [#count_gift{}]
    end,
    Other#goods_other{optional_data = CountGift};

%% 等级礼包
make_other(Other, [?GOODS_OTHER_KEY_GIFT | Data]) ->
    case Data of
        L when is_list(L) -> ok;
        _ -> L = []
    end,
    Other#goods_other{optional_data = L};

%% 聚魂装备
make_other(Other, [?GOODS_OTHER_KEY_SOUL | Data]) ->
    lib_soul:make_goods_other(Other, Data);

%% 符文装备
make_other(Other, [?GOODS_OTHER_KEY_RUNE | Data]) ->
    lib_rune:make_goods_other(Other, Data);

%% 藏宝图
make_other(Other, [?GOODS_OTHER_KEY_TREASURE_MAP | Data]) ->
    lib_tsmap:make_goods_other(Other, Data);

%% 星宿
make_other(Other, [?GOODS_OTHER_KEY_CONSTELLATION|Data]) ->
    lib_constellation_equip:make_goods_other(Other, Data);

%% 神庭
make_other(Other, [?GOODS_OTHER_KEY_GOD_COURT|Data]) ->
    lib_god_court:make_goods_other(Other, Data);

make_other(Other, _OtherData) ->
    Other.

%% 当数据库事务出现问题、回滚后，会执行fun函数
transaction(F) ->
	db:transaction(F, fun lib_goods_dict:close_dict/0).

%% 带入异常终止函数
transaction(F, {M, Fun, Args}) ->
    db:transaction(F, fun() -> lib_goods_dict:close_dict(), apply(M, Fun, Args) end).

%%==========================================
%% 执行F函数N次
%%=========================================
deeploop(F, N, Data) ->
	case N > 0 of
		true ->
			[N1, Data1] = F(N, Data),
			deeploop(F, N1, Data1);
		false ->
			Data
	end.

%%----------------------------------------------------
%% @doc 通过物品类型信息构建物品记录
%% -spec get_new_goods(GoodsTypeInfo) -> Goods
%% GoodsTypeInfo    :: #ets_goods_type{}    物品类型记录
%% Goods            :: #goods{}             物品记录
%% @end
%%-----------------------------------------------------

get_new_goods(GoodsTypeInfo, ExtraArgs) ->
    GoodsInfo = get_new_goods(GoodsTypeInfo),
    set_goods_info(ExtraArgs, GoodsInfo).

get_new_goods(GoodsTypeInfo) ->
    NowTime = utime:unixtime(),
    GoodsTypeId = GoodsTypeInfo#ets_goods_type.goods_id,
    ExpireTime = calc_goods_expire_time(GoodsTypeInfo),

    GoodsOther = #goods_other{
        suit_id = GoodsTypeInfo#ets_goods_type.suit_id,
        addition= GoodsTypeInfo#ets_goods_type.addition
    },
    {BuyType, BuyPrice} = data_goods:get_goods_buy_price(GoodsTypeId),

	#goods{
		goods_id = GoodsTypeId,
        type = GoodsTypeInfo#ets_goods_type.type,
        subtype = GoodsTypeInfo#ets_goods_type.subtype,
        equip_type = GoodsTypeInfo#ets_goods_type.equip_type,
        price_type = BuyType,
        price = BuyPrice,
        bind = GoodsTypeInfo#ets_goods_type.bind,
        trade = GoodsTypeInfo#ets_goods_type.trade,
        sell = GoodsTypeInfo#ets_goods_type.sell,
        level = GoodsTypeInfo#ets_goods_type.level,
        expire_time = ExpireTime,
        color = GoodsTypeInfo#ets_goods_type.color,
        other = GoodsOther,
        bag_location = GoodsTypeInfo#ets_goods_type.bag_location,
        ctime = NowTime %% 物品创建时间
	 }.

%% 设置物品属性
set_goods_info([], GoodsInfo)-> GoodsInfo;
set_goods_info([{K, V}|DyAttrList], GoodsInfo)->
    NewGoodsInfo = case K of
        bind -> GoodsInfo#goods{bind = V};
        expire_time ->
            V2 = if
                    V > 1200000000 -> V;
                    true -> V + utime:unixtime()
                end,
            GoodsInfo#goods{expire_time = V2};
        lock_time -> GoodsInfo#goods{lock_time = V};
        level -> GoodsInfo#goods{level = V};
        color -> GoodsInfo#goods{color = V};
        addition ->
            GoodsOther = GoodsInfo#goods.other,
            GoodsInfo#goods{other = GoodsOther#goods_other{addition = V}};
        extra_attr ->
            GoodsOther = GoodsInfo#goods.other,
            GoodsInfo#goods{other = GoodsOther#goods_other{extra_attr = V}};
        optional_data ->
            GoodsOther = GoodsInfo#goods.other,
            GoodsInfo#goods{other = GoodsOther#goods_other{optional_data = V}};
        rating ->
            GoodsOther = GoodsInfo#goods.other,
            GoodsInfo#goods{other = GoodsOther#goods_other{rating = V}};
        stren ->
            GoodsOther = GoodsInfo#goods.other,
            {Stren, Exp} = V,
            GoodsInfo#goods{other = GoodsOther#goods_other{stren = Stren, overflow_exp = Exp}};
        skill ->
            GoodsOther = GoodsInfo#goods.other,
            GoodsInfo#goods{other = GoodsOther#goods_other{skill_id = V}};
        role_lv ->
            GoodsOther = GoodsInfo#goods.other,
            OptionalData = get_new_other_data(GoodsInfo, role_lv, V),
            GoodsInfo#goods{other = GoodsOther#goods_other{optional_data = OptionalData}};
        rune_lv ->
            GoodsOther = GoodsInfo#goods.other,
            OptionalData = get_new_other_data(GoodsInfo, rune_lv, V),
            GoodsInfo#goods{other = GoodsOther#goods_other{optional_data = OptionalData}};
                        open_day ->
                           GoodsOther = GoodsInfo#goods.other,
                           OptionalData = get_new_other_data(GoodsInfo, open_day, V),
                           GoodsInfo#goods{other = GoodsOther#goods_other{optional_data = OptionalData}};
       _ -> GoodsInfo
   end,
    set_goods_info(DyAttrList, NewGoodsInfo).

%% -----------------------------------------------
%% @doc 计算物品过期时间
-spec
calc_goods_expire_time(GTypeInfo) -> ExpireTime when
GTypeInfo  :: #ets_goods_type{},
ExpireTime :: integer().
%% -----------------------------------------------
calc_goods_expire_time(#ets_goods_type{
    expire_type = ?EXPIRE_PERMAMENT
}) ->
    0;
calc_goods_expire_time(#ets_goods_type{
    expire_type = ?EXPIRE_DURATION,
    expire_time = Duration
}) ->
    utime:unixtime() + Duration;
calc_goods_expire_time(#ets_goods_type{
    expire_type = ?EXPIRE_TIMESTAMP,
    expire_time = ExpireTime
}) ->
    ExpireTime;
calc_goods_expire_time(#ets_goods_type{
    expire_type = ?EXPIRE_DAY,
    expire_time = ExpireDay
}) ->
    utime_logic:get_logic_day_start_time() + ExpireDay * ?ONE_DAY_SECONDS;
calc_goods_expire_time(#ets_goods_type{
    expire_type = ?EXPIRE_OPEN_DAY,
    expire_time = ExpireDay
}) ->
    OpenTime  = util:get_open_time(),
    StartTime = utime_logic:get_logic_day_start_time(OpenTime),
    RealSTime = ?IF(utime:is_same_day(OpenTime, StartTime), StartTime, StartTime + ?ONE_DAY_SECONDS),
    RealSTime + ExpireDay * ?ONE_DAY_SECONDS;
calc_goods_expire_time(#ets_goods_type{
    expire_type = ?EXPIRE_ZERO_DAY,
    expire_time = ExpireDay
}) ->
    utime:unixdate() + ExpireDay * ?ONE_DAY_SECONDS;

calc_goods_expire_time(_) -> 0.

%%---------------------------------------------------
%% 读取物品
%%---------------------------------------------------
get_goods(GoodsId, Dict) ->
    case GoodsId > 0 andalso dict:is_key(GoodsId, Dict) of
        true ->
            List = dict:fetch(GoodsId, Dict),
            case List =:= [] of
                true ->
                    [];
                false ->
                    [GoodsInfo|_] = List,
                    GoodsInfo
            end;
        false ->
            []
    end.

%%-----------------------------------------------------
%% @doc 取对应位置的物品列表
%% -spec get_goods_list(PlayerId, Pos, Dict) -> List
%% when
%% PlayerId     :: integer() 玩家Id
%% Pos          :: integer() 位置
%% Dict         :: dict()   物品字典
%% List         :: list()   物品列表[#goods{}]
%% @end
%%-----------------------------------------------------
get_goods_list(PlayerId, Pos, Dict) ->
	case lib_goods:is_cache(Pos) of
		true ->
            Dict1 = dict:filter(fun(_Key, [Value]) -> Value#goods.location =:= Pos end, Dict),
            DictList = dict:to_list(Dict1),
            lib_goods_dict:get_list(DictList, []);
		false ->
			Sql = io_lib:format(?SQL_GOODS_LIST_BY_LOCATION, [PlayerId, Pos]),
			get_list(goods, Sql)
	end.

%%-----------------------------------------------------
%% @doc 取对应位置的物品列表
%% -spec get_goods_list_by_type(PlayerId, Pos, Type, Dict) -> List
%% when
%% PlayerId     :: integer() 玩家Id
%% Pos          :: integer() 位置
%% Type         :: integer() 物品类型
%% Dict         :: dict()   物品字典
%% List         :: list()   物品列表[#goods{}]
%% @end
%%-----------------------------------------------------
get_goods_list_by_type(PlayerId, Pos, Type, Dict) ->
    case lib_goods:is_cache(Pos) of
        true ->
            Dict1 = dict:filter(fun(_Key, [Value]) ->
                Value#goods.location =:= Pos andalso Value#goods.type == Type end, Dict),
            DictList = dict:to_list(Dict1),
            lib_goods_dict:get_list(DictList, []);
        false ->
            Sql = io_lib:format(?SQL_GOODS_LIST_BY_LOCATION_TYPE, [PlayerId, Pos, Type]),
            get_list(goods, Sql)
    end.

%%----------------------------------------------------------------------------
%% @doc 获取同类物品列表
%% -spec get_type_goods_list(PlayerId, GoodsTypeId, Bind, Location, Dict) -> List
%% PlayerId         :: integer()        玩家Id
%% GoodsTypeId      :: integer()        物品类型Id
%% Bind             :: integer()        绑定类型
%% Location         :: integer()        位置
%% Dict             :: dict()           物品字典
%% List             :: list() [#goods{}] 物品列表
%% @end
%%-------------------------------------------------------------------------------
get_type_goods_list(PlayerId, GoodsTypeId, Bind, Location, Dict) ->
    NowTime = utime:unixtime(),
    case lib_goods:is_cache(Location) of
        true ->
            Dict1 = dict:filter(fun(_Key, [Value]) -> Value#goods.location =:= Location
                andalso Value#goods.goods_id =:= GoodsTypeId andalso Value#goods.bind =:= Bind
                andalso (Value#goods.expire_time == 0 orelse Value#goods.expire_time >= NowTime) end, Dict),
            DictList = dict:to_list(Dict1),
            lib_goods_dict:get_list(DictList, []);
        false -> %% 数据库
            Sql = io_lib:format(?SQL_GOODS_LIST_BY_TYPE3, [PlayerId, Location, Bind, GoodsTypeId, NowTime]),
            get_list(goods, Sql)
    end.

get_type_goods_list(PlayerId, GoodsTypeId, Location, Dict) ->
    NowTime = utime:unixtime(),
    case lib_goods:is_cache(Location) of
        true ->
            Dict1 = dict:filter(fun(_Key, [Value]) -> Value#goods.location =:= Location
                andalso Value#goods.goods_id =:= GoodsTypeId
                andalso (Value#goods.expire_time == 0 orelse Value#goods.expire_time >= NowTime) end, Dict),
            DictList = dict:to_list(Dict1),
            lib_goods_dict:get_list(DictList, []);
        false -> %% 数据库
            Sql = io_lib:format(?SQL_GOODS_LIST_BY_TYPE2, [PlayerId, Location, GoodsTypeId, NowTime]),
            get_list(goods, Sql)
    end.

%% 获取背包有效的物品
get_type_goods_list_expire_time(_PlayerId, GoodsTypeId, Location, NowTime, Dict) ->
    Dict1 = dict:filter(fun(_Key, [Value]) ->
        Value#goods.location =:= Location andalso Value#goods.goods_id =:= GoodsTypeId andalso Value#goods.expire_time > NowTime end, Dict),
    DictList = dict:to_list(Dict1),
    lib_goods_dict:get_list(DictList, []).

get_type_goods_list(equip_exchange,PlayerId, GoodsId, GoodsTypeId, Location, Dict) ->
    case lib_goods:is_cache(Location) of
        true ->
            Dict1 = dict:filter(fun(_Key, [Value]) -> Value#goods.location =:= Location
                                andalso Value#goods.goods_id =:= GoodsTypeId andalso
                                Value#goods.id =:= GoodsId end, Dict),
            DictList = dict:to_list(Dict1),
            lib_goods_dict:get_list(DictList, []);
        false -> %% 仓库
            Sql = io_lib:format(?SQL_GOODS_LIST_BY_TYPE2, [PlayerId, Location, GoodsTypeId, utime:unixtime()]),
            get_list(goods, Sql)
    end.

%%----------------------------------------------------
%% 取物品总数
%%----------------------------------------------------
get_goods_totalnum(GoodsList) ->
    lists:foldl(fun(X, Sum) -> X#goods.num + Sum end, 0, GoodsList).

get_list_by_subtype(Type, SubType, Dict) ->
    Dict1 = dict:filter(fun(_Key, [Value]) ->
        Value#goods.type =:= Type andalso Value#goods.subtype =:= SubType end, Dict),
    DictList = dict:to_list(Dict1),
    lib_goods_dict:get_list(DictList, []).

get_list_by_type(Type, Dict) ->
    Dict1 = dict:filter(fun(_Key, [Value]) -> Value#goods.type =:= Type end, Dict),
    DictList = dict:to_list(Dict1),
    lib_goods_dict:get_list(DictList, []).

get_list_by_sub_location(Location, SubLocation, Dict) ->
    Dict1 = dict:filter(fun(_Key, [Value]) ->
        Value#goods.location =:= Location andalso Value#goods.sub_location == SubLocation end, Dict),
    DictList = dict:to_list(Dict1),
    lib_goods_dict:get_list(DictList, []).


get_goods_list_by_type_ids(Dict, GTypeIdList) ->
    Dict1 = dict:filter(fun(_Key, [Value]) -> lists:member(Value#goods.goods_id, GTypeIdList) end, Dict),
    DictList = dict:to_list(Dict1),
    lib_goods_dict:get_list(DictList, []).

get_goods_list_by_type_ids(Dict, Index, GTypeIdList) ->
    Dict1 = dict:filter(fun(_Key, [Value]) -> lists:keymember(Value#goods.goods_id, Index, GTypeIdList) end, Dict),
    DictList = dict:to_list(Dict1),
    lib_goods_dict:get_list(DictList, []).

get_goods_list_by_ids(Dict, IdList) ->
    lists:foldl(fun(Id, Acc) -> Goods = get_goods(Id, Dict), ?IF(Goods==[], Acc, [Goods|Acc]) end, [], IdList).

get_goods_list_by_location_list(Dict, LocationList) ->
    Dict1 = dict:filter(fun(_Key, [Value]) -> lists:member(Value#goods.location, LocationList) end, Dict),
    DictList = dict:to_list(Dict1),
    lib_goods_dict:get_list(DictList, []).

get_goods_list_by_type_list(Dict, TypeList) ->
    Dict1 = dict:filter(fun(_Key, [Value]) -> lists:member(Value#goods.type, TypeList) end, Dict),
    DictList = dict:to_list(Dict1),
    lib_goods_dict:get_list(DictList, []).

%%-------------------------------------------------
%% @doc 根据物品位置取物品
%% -spec get_goods_by_cell(_PlayerId, Location, Cell, Dict) -> GoodsInfo | []
%% when
%%      PlayerId    :: integer()    玩家Id
%%      Location    :: integer()    装备位置
%%      Cell        :: integer()    装备格子
%%      Dict        :: dict()       物品字典
%%      GoodsInfo   :: #goods{}     物品信息
%% @end
%%--------------------------------------------------
get_goods_by_cell(_PlayerId, Location, Cell, Dict) ->
    case Dict =/= [] of
        true ->
            Dict1 = dict:filter(fun(_Key, [Value]) ->
                Value#goods.location =:= Location andalso Value#goods.cell =:= Cell end, Dict),
            DictList = dict:to_list(Dict1),
            List = lib_goods_dict:get_list(DictList, []),
            case List =/= [] of
                true ->
                    [GoodsInfo|_] = List,
                    GoodsInfo;
                false ->
                    []
            end;
        false ->
            []
    end.

get_goods_by_type(_PlayerId, GoodsTypeId, Location, Dict) ->
    Dict1 = dict:filter(fun(_Key, [Value]) ->
        Value#goods.location =:= Location andalso Value#goods.goods_id =:= GoodsTypeId end, Dict),
    DictList = dict:to_list(Dict1),
    List = lib_goods_dict:get_list(DictList, []),
    case List =/= [] of
        true ->
            [GoodsInfo|_] = List,
            GoodsInfo;
        false ->
            []
    end.

%% 获取身上装备所有的准确装备位置
get_equip_location(EquipList) ->
    [{Goods#goods.cell, Goods#goods.id} || Goods <- EquipList].

%% 初始化装备属性
init_role_equip_attribute(PlayerStatus) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #player_status{id = RoleId, figure = Figure, goods = StatusGoods, skill = SkillStatus, dragon = StatusDragon, mon_pic = MonPic} = PlayerStatus,
    #status_skill{skill_talent_list = SkillTalentList} = SkillStatus,
    #status_dragon{attr_special_list = EquipSpecialAttrList} = StatusDragon,
    #status_mon_pic{special_attr=MonPicSpecialAttr} = MonPic,
    {StatusGoods1, GoodsStatus1} = update_ex_equip_attr(StatusGoods, GoodsStatus),
    {TotalAttr, EquipSkillPower, SpecialAttrMap} = count_equip_attribute(RoleId, Figure#figure.lv, SkillTalentList, EquipSpecialAttrList ++ MonPicSpecialAttr, GoodsStatus1),
    StatusGoods2 = StatusGoods1#status_goods{
        equip_attribute = TotalAttr,
        equip_skill_power = EquipSkillPower
    },
    NewGoodsStatus = GoodsStatus1#goods_status{equip_special_attr = SpecialAttrMap},
    lib_goods_do:set_goods_status(NewGoodsStatus),
    NewPlayerStatus = PlayerStatus#player_status{goods = StatusGoods2},
    {ok, NewPlayerStatus}.

%% 人物装备属性重新计算
count_role_equip_attribute(PlayerStatus) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    count_role_equip_attribute(PlayerStatus, GoodsStatus).

%% 人物装备属性重新计算
count_role_equip_attribute(PlayerStatus, GoodsStatus) ->
    #player_status{id = RoleId, figure = Figure, goods = StatusGoods, skill = SkillStatus, dragon = StatusDragon, mon_pic = MonPic} = PlayerStatus,
    #status_skill{skill_talent_list = SkillTalentList} = SkillStatus,
    #status_dragon{attr_special_list = EquipSpecialAttrList} = StatusDragon,
    #status_mon_pic{special_attr=MonPicSpecialAttr} = MonPic,
    {StatusGoods1, GoodsStatus1} = update_ex_equip_attr(StatusGoods, GoodsStatus),
    {TotalAttr, EquipSkillPower, SpecialAttrMap} = count_equip_attribute(RoleId, Figure#figure.lv, SkillTalentList, EquipSpecialAttrList ++ MonPicSpecialAttr, GoodsStatus1),
    StatusGoods2 = StatusGoods1#status_goods{
        equip_attribute = TotalAttr,
        equip_skill_power = EquipSkillPower
    },
    NewGoodsStatus = GoodsStatus1#goods_status{equip_special_attr = SpecialAttrMap},
    lib_goods_do:set_goods_status(NewGoodsStatus),
    NewPlayerStatus = lib_player:count_player_attribute(PlayerStatus#player_status{goods = StatusGoods2}),
    lib_player:send_attribute_change_notify(NewPlayerStatus, ?NOTIFY_ATTR),
    {ok, NewPlayerStatus}.

%% 取装备的属性加成
count_equip_attribute(PlayerId, PlayerLv, SkillTalentList, EquipSpecialAttrList, GoodsStatus) ->
    #goods_status{
        dict = Dict,
        % stren_award_list = StrenAwardList,
        stren_whole_lv = StrenWholeLv,
        refine_award_list = RefineAwardList,
        % stone_award_list = StoneAwardList,
        stone_whole_lv = StoneWholeLv,
        star_award_list = StarAwardList,
        red_equip_award_list = RedEquipAwardList,
        rune = Rune,
        soul = Soul,
        equip_casting_spirit = EquipCastingSpiritL,
        equip_spirit = EquipSpirit,
        mount_equip_pos_list = MountEquipPos,
        mate_equip_pos_list = MateEquipPos,
        god_equip_list = GodEquipLevelList
    } = GoodsStatus,
    EquipList = get_equip_list(PlayerId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, Dict),
    #{?EQUIP_TYPE_WEAPON := WeaponL, ?EQUIP_TYPE_ARMOR := ArmorL, ?EQUIP_TYPE_ORNAMENT := OrnamentL, ?EQUIP_TYPE_SPECIAL := SpecialL}
        = data_goods:classify_euqip(EquipList),

    WeaponAttr = data_goods:count_goods_attribute(WeaponL),
    ArmorAttr = data_goods:count_goods_attribute(ArmorL),
    OrnamentAttr = data_goods:count_goods_attribute(OrnamentL),
    %% io:format("~p ~p Args:~w~n", [?MODULE, ?LINE, [SpecialL]]),
    SpecailAttr = data_goods:count_goods_attribute(SpecialL),

    TalentSkillAttr = lib_skill_api:get_skill_attr2mod(?MOD_EQUIP, SkillTalentList),

    %% 符文装备百分比加成
    RuneAttr = Rune#rune.equip_add_ratio_attr,

    %% 聚魂装备百分比加成
    SoulAttr = Soul#soul.equip_add_ratio_attr,

    %%  坐骑装备
    FigureEquipAttr = lib_mount_equip:get_figure_equip_attr(PlayerId, MountEquipPos, MateEquipPos, Dict),
%%    ?PRINT("count_equip_attribute FigureEquipAttr :~p~n", [FigureEquipAttr]),

    %% 装备的额外基础属性
    % BaseOtherAttr = data_goods:count_equip_base_other_attribute(EquipList),
    WeaponOtherAttr = data_goods:count_equip_base_other_attribute(WeaponL),
    ArmorOtherAttr = data_goods:count_equip_base_other_attribute(ArmorL),
    OrnamentOtherAttr = data_goods:count_equip_base_other_attribute(OrnamentL),
    SpecailOtherAttr = data_goods:count_equip_base_other_attribute(SpecialL),

    NewWeaponAttr = ulists:kv_list_plus_extra([TalentSkillAttr, RuneAttr, SoulAttr, WeaponAttr, WeaponOtherAttr, EquipSpecialAttrList]),
    NewArmorAttr = ulists:kv_list_plus_extra([TalentSkillAttr, RuneAttr, SoulAttr, ArmorAttr, ArmorOtherAttr, EquipSpecialAttrList]),
    NewOrnamentAttr = ulists:kv_list_plus_extra([TalentSkillAttr, RuneAttr, SoulAttr, OrnamentAttr, OrnamentOtherAttr, EquipSpecialAttrList]),

    LastWeaponAttr = data_goods:count_euqip_base_attr_ex(?EQUIP_TYPE_WEAPON, NewWeaponAttr),
    LastArmorAttr = data_goods:count_euqip_base_attr_ex(?EQUIP_TYPE_ARMOR, NewArmorAttr),
    LastOrnamentAttr = data_goods:count_euqip_base_attr_ex(?EQUIP_TYPE_ORNAMENT, NewOrnamentAttr),

    % 装备属性加成 基础属性+附加属性+其他系统基础属性提升
    EquipBaseAttr = util:combine_list(SpecailAttr ++ SpecailOtherAttr ++ LastWeaponAttr ++ LastArmorAttr ++ LastOrnamentAttr),

    %% 装备的极品属性
    EquipExtraAttr = data_goods:count_extra_attr(PlayerLv, EquipList),

    %% 装备的洗炼属性
    EquipWashAttr = data_goods:count_wash_attribute(GoodsStatus),



    %% 已穿戴装备强化属性
    StrenAttribute = data_goods:count_stren_attribute(SoulAttr, GoodsStatus),

    %% 已穿戴装备精炼属性
    RefineAttribute = data_goods:count_refine_attribute(SoulAttr, GoodsStatus),

    %% 宝石属性[所有已穿戴装备镶嵌的宝石属性]
    StoneAttribute = data_goods:count_stone_attribute(GoodsStatus),

    %% 装备全身加成
    StrenAwardAttr = lib_equip:get_12_equip_manual_award(StrenWholeLv, ?WHOLE_AWARD_STREN),
    RefineAwardAttr = lib_equip:get_12_equip_award(RefineAwardList, ?WHOLE_AWARD_REFINE),
    StoneAwardAttr = lib_equip:get_12_equip_manual_award(StoneWholeLv, ?WHOLE_AWARD_STONE),
    StarAwardAttr = lib_equip:get_12_equip_award(StarAwardList, ?WHOLE_AWARD_STAR),
    RedEquipAttr = lib_equip:get_12_equip_award(RedEquipAwardList, ?WHOLE_AWARD_RED_EQUIP),

    %% 铸灵护灵属性
    CastingSpiritAttr = lib_equip:count_casting_spirit_attr(EquipCastingSpiritL, EquipList),
    #equip_spirit{lv = SpiritLv} = EquipSpirit,
    case data_equip_spirit:get_spirit_lv_cfg(SpiritLv) of
        #spirit_lv_cfg{attr = EquipSpiritAttr} -> skip;
        _ -> EquipSpiritAttr = []
    end,

    %% 觉醒属性
    AwakeningAttr = lib_equip:count_awakening_attr(GoodsStatus, EquipList),

    %% 装备技能属性
    EquipSkillAttr = lib_equip:count_equip_skill_attr(GoodsStatus, EquipList),
    EquipSkillPower = lib_equip:count_equip_skill_power(GoodsStatus, EquipList),

    %% 神装属性
    GodAttr = lib_god_equip:calc_god_equip_attr(EquipList, GodEquipLevelList, []),
    %% 属性、战力汇总
    %% 三个一行，方便查看
    TotalList = [
        EquipBaseAttr, EquipExtraAttr, EquipWashAttr,
        StrenAttribute, RefineAttribute, StoneAttribute,
        StrenAwardAttr, RefineAwardAttr, StoneAwardAttr,
        StarAwardAttr, CastingSpiritAttr, EquipSpiritAttr,
        AwakeningAttr, EquipSkillAttr, RedEquipAttr%, BaseOtherAttr
        , FigureEquipAttr, GodAttr
    ],
    %% 属性、战力汇总 , BaseOtherAttr
    % TotalList = [
    %     EquipBaseAttr, EquipExtraAttr, EquipWashAttr,
    %     StrenAttribute, RefineAttribute, StoneAttribute, StrenAwardAttr, RefineAwardAttr,
    %     StoneAwardAttr, StarAwardAttr, CastingSpiritAttr,
    %     EquipSpiritAttr, AwakeningAttr, EquipSkillAttr, RedEquipAttr%, BaseOtherAttr
    %     , FigureEquipAttr, GodAttr
    % ],
    TotalAttribute = ulists:kv_list_plus_extra(TotalList),
    AttrRecord = to_attr_record(TotalAttribute),

    %% 计算特殊属性
    OriSpecialAttrMap = #{?EXP_ADD => 0, ?RARE_GOODS_DROP_UP => 0},
    SpecialAttrMap = lists:foldl(fun({TmpKey, TmpVal}, TmpMap) ->
        case maps:is_key(TmpKey, TmpMap) of
            true ->
                #{TmpKey := PreVal} = TmpMap,
                TmpMap#{TmpKey => PreVal + TmpVal};
            false -> TmpMap
        end
                                 end, OriSpecialAttrMap, TotalAttribute),

    {AttrRecord, EquipSkillPower, SpecialAttrMap}.

to_attr_record([]) -> #attr{};
to_attr_record(TotalAttribute) ->
    lib_player_attr:add_attr(record, [TotalAttribute]).

filter_equip_list([], _, L) -> L;
filter_equip_list([G|T], FL, L) ->
    case lists:member(G#goods.cell, FL) of
        false ->
            NewFL = [G#goods.cell|FL],
            filter_equip_list(T, NewFL, [G|L]);
        true ->
            filter_equip_list(T, FL, L)
    end.

update_ex_equip_attr(G, GoodsStatus) ->
    G1 = if
        GoodsStatus#goods_status.is_dirty_suit ->
            G#status_goods{equip_suit_attr = lib_equip:calc_suit_attr(GoodsStatus#goods_status.equip_suit_state)};
        true ->
            G
    end,

    {G1, GoodsStatus#goods_status{is_dirty_suit = false}}.

%%---------------------------------------------------------------------
%% 更改物品格子位置和使用数量
%%---------------------------------------------------------------------
change_goods_cell_and_use(GoodsInfo, Location, Cell) ->
    Sql = io_lib:format(?SQL_GOODS_UPDATE_CELL_USENUM, [Location, Cell, GoodsInfo#goods.id]),
    db:execute(Sql),
    GoodsInfo#goods{location = Location, cell = Cell}.

%%-----------------------------------------------------
%% 更改物品格子位置和数量
%%-----------------------------------------------------
change_goods_cell_and_num(GoodsInfo, Location, Cell, Num) ->
    Sql = io_lib:format(?SQL_GOODS_UPDATE_CELL_NUM, [Location, Cell, Num, GoodsInfo#goods.id]),
    db:execute(Sql),
    GoodsInfo#goods{location=Location, cell = Cell, num=Num}.

%%--------------------------------------------
%% 更改物品格子位置
%%--------------------------------------------
change_goods_cell(GoodsInfo, Location, Cell) ->
    case is_integer(GoodsInfo#goods.id) of
        true ->
            Sql = io_lib:format(?SQL_GOODS_UPDATE_CELL, [Location, Cell, GoodsInfo#goods.id]),
            db:execute(Sql),
            GoodsInfo#goods{location=Location, cell=Cell};
        false ->
            #goods{}
    end.

%%--------------------------------------------
%% 更改物品子位置
%%--------------------------------------------
change_goods_sub_location(GoodsInfo, Location, SubLocation, Cell) ->
    case is_integer(GoodsInfo#goods.id) of
        true ->
            Sql = io_lib:format(?SQL_GOODS_UPDATE_SUB_LOCATION, [Location, SubLocation, Cell, GoodsInfo#goods.id]),
            db:execute(Sql),
            GoodsInfo#goods{location=Location, sub_location = SubLocation, cell=Cell};
        false ->
            #goods{}
    end.

%%--------------------------------------------
%% 更改物品等级 附加属性
%%--------------------------------------------
change_goods_level_extra_attr(GoodsInfo, Level, ExtraAttr) ->
    case is_integer(GoodsInfo#goods.id) of
        true ->
            SExtraAttr = util:term_to_bitstring(ExtraAttr),
            Sql = io_lib:format(?SQL_GOODS_UPDATE_LEVEL_EXTRA_ATTR, [Level, SExtraAttr, GoodsInfo#goods.id]),
            db:execute(Sql),
            GoodsOther = GoodsInfo#goods.other,
            GoodsInfo#goods{
                level = Level,
                other = GoodsOther#goods_other{extra_attr = ExtraAttr}
            };
        false ->
            #goods{}
    end.

%% 更改物品额外数据
change_goods_other(GoodsId, OtherData) ->
    DataStr = util:term_to_string(OtherData),
    SQL = io_lib:format(?SQL_GOODS_UPDATE_OTHER, [DataStr, GoodsId]),
    db:execute(SQL).


%% %% 更改物品时效
%% change_goods_expire(GoodsInfo, ExpireTime) ->
%%     Sql = io_lib:format(?SQL_GOODS_UPDATE_EXPIRE, [ExpireTime, GoodsInfo#goods.id]),
%%     db:execute(Sql),
%%     GoodsInfo#goods{expire_time=ExpireTime}.

%% 更改物品类型ID
change_goods_type(GoodsInfo, GoodsTypeId) ->
    GoodsTypeInfo = data_goods_type:get(GoodsTypeId),
    Color = GoodsTypeInfo#ets_goods_type.color,
    Sql1 = io_lib:format(?SQL_GOODS_UPDATE_GOODS1, [GoodsTypeId, GoodsInfo#goods.id]),
    db:execute(Sql1),
    Sql2 = io_lib:format(?SQL_GOODS_UPDATE_GOODS2, [GoodsTypeId, Color, GoodsInfo#goods.id]),
    db:execute(Sql2),
    GoodsInfo#goods{goods_id = GoodsTypeId, color = Color}.

%%--------------------------------------------------------
%% 更改玩家,位置
%%--------------------------------------------------------
change_goods_player(GoodsInfo, PlayerId, Location, Cell) ->
    Sql1 = io_lib:format(?SQL_GOODS_UPDATE_PLAYER1, [PlayerId, GoodsInfo#goods.id]),
    db:execute(Sql1),
    Sql2 = io_lib:format(?SQL_GOODS_UPDATE_PLAYER2, [PlayerId, GoodsInfo#goods.id]),
    db:execute(Sql2),
    Sql3 = io_lib:format(?SQL_GOODS_UPDATE_PLAYER3, [PlayerId, Location, Cell, GoodsInfo#goods.id]),
    db:execute(Sql3),
    GoodsInfo#goods{player_id = PlayerId, location = Location, cell = Cell}.

%% 更改信息
% change_goods_info(GoodsInfo, Bind, Trade) ->
%     WashTime = GoodsInfo#goods.wash_time,
%     MinStar = GoodsInfo#goods.min_star,
%     Sql = io_lib:format(?SQL_GOODS_UPDATE_INFO, [Bind, Trade, WashTime, MinStar, GoodsInfo#goods.id]),
%     db:execute(Sql),
%     GoodsInfo#goods{bind = Bind, trade = Trade}.
change_goods_level(GoodsInfo) ->
    _GoodsOther = GoodsInfo#goods.other,
    Sql = io_lib:format(?SQL_GOODS_UPDATE_LEVEL, [GoodsInfo#goods.level, GoodsInfo#goods.id]),
    db:execute(Sql).

change_goods_addition(GoodsInfo) ->
    GoodsOther = GoodsInfo#goods.other,
    Sql = io_lib:format(?SQL_GOODS_UPDATE_ADDITION, [GoodsInfo#goods.color, util:term_to_bitstring(GoodsOther#goods_other.addition), GoodsInfo#goods.id]),
    db:execute(Sql).

change_equip_stren(PlayerId, EquipPos, EquipStren) ->
    Stren      = EquipStren#equip_stren.stren,
    Sql = io_lib:format(?SQL_EQUIP_STREN, [PlayerId, EquipPos, Stren]),
    db:execute(Sql).

change_equip_refine(PlayerId, EquipPos, EquipRefine) ->
    Refine  = EquipRefine#equip_refine.refine,
    Sql =io_lib:format(?SQL_EQUIP_REFINE, [PlayerId,EquipPos,Refine]),
    db:execute(Sql).

update_equip_wash(PlayerId, EquipPos, EquipWash) ->
    #equip_wash{duan = Duan, wash_rating = WashRating, attr = Attr} = EquipWash,
    Sql = io_lib:format(?SQL_EQUIP_WASH, [PlayerId, EquipPos, Duan, WashRating, util:term_to_bitstring(Attr)]),
    db:execute(Sql).

change_goods_skill_id(GoodsInfo, SkillId) ->
    case is_integer(GoodsInfo#goods.id) of
        true ->
            Sql = io_lib:format(?SQL_GOODS_UPDATE_SKILL, [SkillId, GoodsInfo#goods.id]),
            db:execute(Sql),
            GoodsOthers = GoodsInfo#goods.other,
            GoodsInfo#goods{other = GoodsOthers#goods_other{skill_id = SkillId}};
        false ->
            #goods{}
    end.

%%update_equip_division(NewDivision, RoleId, EquipPos) ->
%%    db:execute(io_lib:format(?SQL_EQUIP_UPGRADE_DIVISION, [NewDivision, RoleId, EquipPos])).

get_stren_list(PlayerId, EquipList) ->
    Sql = io_lib:format(?SQL_STREN_LIST, [PlayerId]),
    List = db:get_all(Sql),
    lists:foldl(
        fun([EquipPos, Stren], Acc) ->
            EquipStren = make(equip_stren, [Stren]),
            case lists:keyfind(EquipPos, #goods.cell, EquipList) of
                #goods{goods_id = GTypeId, color = Color} ->
                    EquipStage = lib_equip:get_equip_stage(GTypeId),
                    NewEquipStren = lib_equip:conver_stren_lv(Color, EquipPos, EquipStren, EquipStage);
                _ -> NewEquipStren = EquipStren
            end,
            lists:keystore(EquipPos, 1, Acc, {EquipPos, NewEquipStren})
        end, [], List).

get_dec_level_list(PlayerId, EquipList) ->
    Sql = io_lib:format(?SELET_DECORATION_LEVEL_LIST, [PlayerId]),
    List = db:get_all(Sql),
    lists:foldl(
        fun([EquipPos, Level], Acc) ->
            case lists:keyfind(EquipPos, #goods.cell, EquipList) of
                #goods{goods_id = GTypeId, color = Color} ->
                    EquipStage = case data_decoration:get_dec_attr(GTypeId) of
                                     #dec_attr_cfg{stage = EqStage} -> EqStage;
                                     _ -> 1
                                 end,
                    DecLevMax = data_decoration:get_dec_level_max(EquipPos, EquipStage, Color),
                    NewEquipStren =
                        case is_record(DecLevMax, dec_level_max_cfg) of
                            true ->
                                case Level >= DecLevMax#dec_level_max_cfg.limit_level of
                                    true -> DecLevMax#dec_level_max_cfg.limit_level;
                                    false -> Level
                                end;
                            false -> 0
                        end;
                _ -> NewEquipStren = Level
            end,
            lists:keystore(EquipPos, 1, Acc, {EquipPos, NewEquipStren})
        end, [], List).

get_seal_level_list(PlayerId, _) ->
    Sql = io_lib:format(?seal_select_other, [PlayerId]),
    List = db:get_all(Sql),
    lists:foldl(
        fun([EquipPos, Level], Acc) ->
            lists:keystore(EquipPos, 1, Acc, {EquipPos, Level})
        end, [], List).

get_draconic_level_list(PlayerId, _) ->
    Sql = io_lib:format(?draconic_select_other, [PlayerId]),
    List = db:get_all(Sql),
    lists:foldl(
        fun([EquipPos, Level], Acc) ->
            lists:keystore(EquipPos, 1, Acc, {EquipPos, Level})
        end, [], List).

get_refine_list(PlayerId, EquipList) ->
    Sql = io_lib:format(?SQL_REFINE_LIST, [PlayerId]),
    List = db:get_all(Sql),
    lists:foldl(
        fun([EquipPos, Refine], Acc) ->
            EquipRefine = make(equip_refine, [Refine]),
            NewEquipRefine =
                case lists:keyfind(EquipPos, #goods.cell, EquipList) of
                #goods{goods_id = GTypeId, color = Color} ->
                    EquipStage = lib_equip:get_equip_stage(GTypeId),
                    lib_equip:conver_refine_lv(Color, EquipPos, EquipRefine, EquipStage);
                _ -> EquipRefine
            end,
            lists:keystore(EquipPos, 1, Acc, {EquipPos, NewEquipRefine})
        end, [], List).

get_stone_list(PlayerId) ->
    Sql = io_lib:format(?SQL_STONE_LIST, [PlayerId]),
    List = db:get_all(Sql),
    Sql1 = io_lib:format(?SQL_STONE_REFINE_LIST, [PlayerId]),
    List1 = db:get_all(Sql1),
    StoneList = lists:foldl(
        fun
            ([EquipPos, RefineLv, Exp], Acc) ->
                Tuple = lists:keyfind(EquipPos, 1, Acc),
                {EquipPos, PosStoneInfoR} = ?IF(Tuple == false, {EquipPos, #equip_stone{}}, Tuple),
                lists:keystore(EquipPos, 1, Acc, {EquipPos, PosStoneInfoR#equip_stone{refine_lv = RefineLv, exp = Exp}});
            ([EquipPos, StonePos, StoneId, Bind], Acc) ->
                case data_goods_type:get(StoneId) == [] orelse data_equip:get_stone_lv_cfg(StoneId) == [] of
                    true -> Acc;
                    _ ->
                        Tuple = lists:keyfind(EquipPos, 1, Acc),
                        {EquipPos, PosStoneInfoR} = ?IF(Tuple == false, {EquipPos, #equip_stone{}}, Tuple),
                        PosStoneList = PosStoneInfoR#equip_stone.stone_list,
                        NewPosStoneList = [#stone_info{pos = StonePos, bind = Bind, gtype_id = StoneId}|PosStoneList],
                        lists:keystore(EquipPos, 1, Acc, {EquipPos, PosStoneInfoR#equip_stone{stone_list = NewPosStoneList}})
                end
        end, [], List1 ++ List),
    lists:map(fun({EquipPos, PosStoneInfoR}) ->
        Rating = lib_equip:cal_stone_rating(EquipPos, PosStoneInfoR),
        {EquipPos, PosStoneInfoR#equip_stone{rating = Rating}}
    end, StoneList).

%% 获取洗练map
get_wash_map(PlayerId) ->
    Sql = io_lib:format(?SQL_EQUIP_WASH_LIST, [PlayerId]),
    List = db:get_all(Sql),
    lists:foldl(
        fun([EquipPos, Duan, WashRating, AttrStr], Acc) ->
            AttrList = util:bitstring_to_term(AttrStr),
%%            LegalAttr = wash_legal_attr(AttrList),
%%            {LastDuan, LastWashRating, LastAttr} =
%%                case length(LegalAttr) == length(AttrList) of
%%                    true ->
%%                        {Duan, WashRating, AttrList};
%%                    false ->
%%                        {NewDuan, NewWashRating} = fix_wash_duan_rating(EquipPos, AttrList),
%%                        NewAttr = fix_wash_attr(AttrList, EquipPos, NewDuan, LegalAttr, []), % ( 原属性列表， 评分，评分，  新属性列表)
%%                        {NewDuan, NewWashRating, NewAttr}
%%                end,
%%            EquipWash = #equip_wash{duan = LastDuan, wash_rating = LastWashRating, attr = LastAttr},
            EquipWash = #equip_wash{duan = Duan, wash_rating = WashRating, attr = AttrList},
            update_equip_wash(PlayerId, EquipPos, EquipWash),   % 更新数据
            maps:put(EquipPos, EquipWash, Acc)
        end, #{}, List).

%%  修复旧号的段位和评分
fix_wash_duan_rating(EquipPos, AttrList) ->
    NewWashRating = lib_equip:count_equip_wash_rating(AttrList),
    NewDuan =  case  data_equip:get_wash_duan_rating(EquipPos, NewWashRating)  of
                   [] ->
                       data_equip:get_wash_max_duan(EquipPos);
                   Duan -> Duan
               end,
    {NewDuan, NewWashRating}.


%%  合法的洗炼属性
wash_legal_attr(AttrList) ->
    F = fun({_PosId, _Color, AttrId, _AttrVal}, TmpList) ->
        case lists:member(AttrId, [1, 2, 3, 4, 5, 6, 7, 8, 15, 16]) of
            true ->
                [AttrId | TmpList];
            false ->
                TmpList
        end
        end,
    lists:foldl(F, [], AttrList).

%% 该部位洗练所有的属性
get_wash_pos_attr(PosId) ->
    case lists:member(PosId, [?EQUIP_WEAPON, ?EQUIP_NECKLACE, ?EQUIP_AMULET, ?EQUIP_BRACELET, ?EQUIP_RING]) of
        true ->
            [1, 3, 5, 7, 15];
        false ->
            [2, 4, 6, 8, 16]
    end.



%% 修复旧号的每条属性值
fix_wash_attr([], _EquipPos, _NewDuan, _LegalAttr, NewAttr) ->
    lists:reverse(NewAttr);

fix_wash_attr([{PosId, Color, AttrId, AttrVal} | AttrList], EquipPos, NewDuan, LegalAttr, NewAttr) ->
    case lists:member(AttrId, [19, 20, 21, 22, 23, 24]) of
        true ->
            WashPosAttr = get_wash_pos_attr(EquipPos),
            NewAttrId = urand:list_rand(WashPosAttr -- LegalAttr),
            OldRating = lib_equip:get_wash_attr_base_rating(AttrId),
            NewRating = lib_equip:get_wash_attr_base_rating(NewAttrId),
            NewAttrVal = util:floor(OldRating * AttrVal / NewRating),
            #equip_wash_attr_cfg{
                attr_green = [{_, [GreenLow, GreenHigh]}],
                attr_blue = [{_, [BlueLow, BlueHigh]}],
                attr_purple = [{_, [PurpleLow, PurpleHigh]}],
                attr_orange = [{_, [OrangeLow, OrangeHigh]}],
                attr_red = [{_, [RedLow, RedHigh]}]} =
                data_equip:get_wash_attr_cfg(EquipPos, NewDuan, NewAttrId),
            {NewColor, LastAttrVal} =
                case NewAttrVal of
                    NewAtVal when NewAtVal < GreenLow ->
                        {?GREEN, GreenLow};
                    NewAtVal when (GreenLow =< NewAtVal andalso GreenHigh >= NewAtVal) ->
                        {?GREEN, NewAtVal};
                    NewAtVal when (BlueLow =< NewAtVal andalso BlueHigh >= NewAtVal) ->
                        {?BLUE, NewAtVal};
                    NewAtVal when (PurpleLow =< NewAtVal andalso PurpleHigh >= NewAtVal) ->
                        {?PURPLE, NewAtVal};
                    NewAtVal when (OrangeLow =< NewAtVal andalso OrangeHigh >= NewAtVal) ->
                        {?ORANGE, NewAtVal};
                    NewAtVal when (RedLow =< NewAtVal andalso RedHigh >= NewAtVal) ->
                        {?RED, NewAtVal};
                    NewAtVal when NewAtVal > RedHigh ->
                        {?RED, RedHigh};
                    Error ->
                        ?ERR("equip error:~p", [Error]),
                        {0, 0}
                end,
%%            ?PRINT("OldRating, AttrVal, NewRating, NewColor, LastAttrVal :~w~n", [[OldRating, AttrVal, NewRating, NewColor, LastAttrVal]]),
            fix_wash_attr(AttrList, EquipPos, NewDuan, [NewAttrId | LegalAttr], [{PosId, NewColor, NewAttrId, LastAttrVal} | NewAttr]);
        false ->
            fix_wash_attr(AttrList, EquipPos, NewDuan, LegalAttr, [{PosId, Color, AttrId, AttrVal} | NewAttr])
    end.


init_equip_other_info(GoodsStatus, EquipList) ->
    #goods_status{dict = Dict} = GoodsStatus,
    F = fun(GoodsInfo, {OldDict, List}) ->
        #goods{other = Other} = GoodsInfo,
        Stren = data_goods:get_equip_real_stren_level(GoodsStatus, GoodsInfo),
        Refine = data_goods:get_equip_real_refine_level(GoodsStatus, GoodsInfo),
        %?PRINT("init_equip_other_info ~p~n", [{Stren, Refine}]),
        NewGoodsInfo = GoodsInfo#goods{other = Other#goods_other{stren = Stren, refine = Refine}},
        NewDict = lib_goods_dict:add_dict_goods(NewGoodsInfo, OldDict),
        {NewDict, [NewGoodsInfo|List]}
    end,
    {LastDict, LastEquipList} = lists:foldl(F, {Dict, []}, EquipList),
    {GoodsStatus#goods_status{dict = LastDict}, LastEquipList}.

init_seal_other_info(GoodsStatus, SealEquip, SealLeveList) ->
    #goods_status{dict = Dict} = GoodsStatus,
    F = fun(GoodsInfo, OldDict) ->
        #goods{other = Other, subtype = Subtype} = GoodsInfo,
        case lists:keyfind(Subtype, 1, SealLeveList) of
            {Subtype, Stren} ->skip;
            _ ->Stren = 0
        end,
        NewGoodsInfo = GoodsInfo#goods{other = Other#goods_other{stren = Stren}},
        NewDict = lib_goods_dict:add_dict_goods(NewGoodsInfo, OldDict),
        NewDict
        end,
    LastDict = lists:foldl(F, Dict, SealEquip),
    GoodsStatus#goods_status{dict = LastDict}.

init_draconic_other_info(GoodsStatus, DraconicEquip, DraconicLeveList) ->
    #goods_status{dict = Dict} = GoodsStatus,
    F = fun(GoodsInfo, OldDict) ->
        #goods{other = Other, subtype = Subtype} = GoodsInfo,
        case lists:keyfind(Subtype, 1, DraconicLeveList) of
            {Subtype, Stren} -> skip;
            _ -> Stren = 0
        end,
        NewGoodsInfo = GoodsInfo#goods{other = Other#goods_other{stren = Stren}},
        NewDict = lib_goods_dict:add_dict_goods(NewGoodsInfo, OldDict),
        NewDict
        end,
    LastDict = lists:foldl(F, Dict, DraconicEquip),
    GoodsStatus#goods_status{dict = LastDict}.

%% 幻饰加载强化数
init_dec_other_info(GoodsStatus, DecEquip, DecLevelList) ->
    #goods_status{dict = Dict} = GoodsStatus,
    F = fun(GoodsInfo, OldDict) ->
        #goods{other = Other, cell = Cell} = GoodsInfo,
        case lists:keyfind(Cell, 1, DecLevelList) of
            {Cell, Stren} -> skip;
            _ -> Stren = 0
        end,
        NewGoodsInfo = GoodsInfo#goods{other = Other#goods_other{stren = Stren}},
        NewDict = lib_goods_dict:add_dict_goods(NewGoodsInfo, OldDict),
        NewDict
    end,
    LastDict = lists:foldl(F, Dict, DecEquip),
    GoodsStatus#goods_status{dict = LastDict}.

change_equip_stone(PlayerId, EquipPos, StonePos, StoneId, Bind) ->
    Sql = io_lib:format(?SQL_EQUIP_STONE, [PlayerId, EquipPos, StonePos, StoneId, Bind]),
    db:execute(Sql).

unequip_stone(PlayerId, EquipPos, StonePos) ->
    Sql = io_lib:format(?SQL_UNEQUIP_STONE, [PlayerId, EquipPos, StonePos]),
    db:execute(Sql).

stone_refine(PlayerId, EquipPos, RefineLv, Exp) ->
    Sql = io_lib:format(?SQL_EQUIP_STONE_REFINE, [PlayerId, EquipPos, RefineLv, Exp]),
    db:execute(Sql).

%%取多条记录
get_list(Table, Sql) ->
	List = get_list(Sql),
	lists:flatmap(fun(GoodsInfo) -> make_info(Table, GoodsInfo) end, List).

get_list(Sql) ->
	List = (catch db:get_all(Sql)),
	case is_list(List) of
		true ->
			List;
		false ->
			[]
	end.

get_lv_model(PlayerId, Career, Sex, Turn, Lv) ->
    [
        {?MODEL_PART_WEAPON, get_model_id(?MODEL_PART_WEAPON, PlayerId, Career, Sex, Turn, Lv)},
        {?MODEL_PART_CLOTH, get_model_id(?MODEL_PART_CLOTH, PlayerId, Career, Sex, Turn, Lv)},
        {?MODEL_PART_HEAD, get_model_id(?MODEL_PART_HEAD, PlayerId, Career, Sex, Turn, Lv)}
    ].

get_model_id(Part, PlayerId, Career, Sex, Turn, Lv) ->
    GoodsTypeId = case Part of
        ?MODEL_PART_WEAPON -> get_equip_goods_id(PlayerId, ?EQUIP_WEAPON);
        ?MODEL_PART_CLOTH -> get_equip_goods_id(PlayerId, ?EQUIP_CLOTH);
        ?MODEL_PART_HEAD -> get_equip_goods_id(PlayerId, ?EQUIP_PILEUM)
    end,
    get_model_id_by_goods_id(GoodsTypeId, Part, Career, Sex, Turn, Lv).

get_model_id_by_goods_id(GoodsTypeId, Part, Career, Sex, Turn, Lv) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{model_id = ModelId}
            when GoodsTypeId=/=0 andalso ModelId =/= 0 -> ModelId;
        _ -> lib_player:get_model_id(?LV_MODEL, Part, Career, Sex, Turn, Lv, 0)
    end.

get_equip_goods_id(PlayerId, EquipType) ->
    Sql = io_lib:format(?SQL_GOODS_GET_EQUIP, [PlayerId, ?GOODS_LOC_EQUIP, ?GOODS_TYPE_EQUIP, EquipType]),
    case db:get_row(Sql) of
        [GoodsId|_] -> GoodsId;
        _ -> 0
    end.

%%-----------------------------------------------------
%% @doc 更改物品数量
%% -spec change_goods_num(GoodsInfo, Num) -> NewGoodsInfo
%% GoodsInfo | NewGoodsInfo     :: #goods{}     物品记录
%% Num                          :: integer()    物品新数量
%% @end
%% -------------------------------------------------------
change_goods_num(GoodsInfo, Num) ->
	Sql = io_lib:format(?SQL_GOODS_UPDATE_NUM, [Num, GoodsInfo#goods.id]),
	db:execute(Sql),
	GoodsInfo#goods{num = Num}.

%%-----------------------------------------------------
%% @doc 更改物品有效期
%% -spec change_goods_num(GoodsInfo, Num) -> NewGoodsInfo
%% GoodsInfo | NewGoodsInfo     :: #goods{}     物品记录
%% Num                          :: integer()    物品新数量
%% @end
%% -------------------------------------------------------
change_goods_expire_time(GoodsInfo, Time) ->
	Sql = io_lib:format(?SQL_GOODS_UPDATE_EXPIRE, [Time, GoodsInfo#goods.id]),
	db:execute(Sql),
    GoodsInfo#goods{expire_time = Time}.


%%------------------------------------------------------
%% @doc 扩充背包
%% -spce extend_bag(RoleId, NowCell, CellNum) -> AllCell
%%  when
%%      RoleId     :: 玩家Id
%%      NowCell    :: 玩家当前的背包数
%%      CellNum    :: 要增加的背包栏
%% @end
%% -----------------------------------------------------------
%% extend_bag(PlayerStatus, CellNum) ->
%% 	NewCellNum = PlayerStatus#player_status.cell_num + CellNum,
%% 	Sql = io_lib:format(?SQL_PLAYER_UPDATE_CELL, [NewCellNum, PlayerStatus#player_status.id]),
%% 	db:execute(Sql),
%% 	PlayerStatus#player_status{cell_num = NewCellNum}.

extend_bag(RoleId, NowCell, CellNum) ->
	AllCell = NowCell + CellNum,
	Sql = io_lib:format(?SQL_PLAYER_UPDATE_CELL, [AllCell, RoleId]),
	db:execute(Sql),
	AllCell.

%% ---------------------------------------------------------------------------------------
%% @doc 插入物品,三张表 goods,goods_low, goods_high
%% -spec add_goods(GoodsInfo) -> GoodsId
%% GoodsInfo   :: #goods{}         物品记录
%% GoodsId     :: #integer()        物品Id
%% @end
%%-----------------------------------------------------------------------------------------
add_goods(_GoodsInfo) ->
    GoodsInfo = _GoodsInfo,
    GoodsId = mod_id_create:get_new_id(?GOODS_ID_CREATE),
    Sql1 = io_lib:format(?SQL_GOODS_INSERT, [GoodsId, GoodsInfo#goods.player_id, GoodsInfo#goods.type,
											 GoodsInfo#goods.subtype, GoodsInfo#goods.price_type, GoodsInfo#goods.price,
											 GoodsInfo#goods.other#goods_other.suit_id, GoodsInfo#goods.other#goods_other.skill_id,
											 GoodsInfo#goods.expire_time, GoodsInfo#goods.lock_time]),
    db:execute(Sql1),
    OtherData = format_other_data(GoodsInfo),
    Sql2 = io_lib:format(?SQL_GOODS_LOW_INSERT, [GoodsId, GoodsInfo#goods.player_id, GoodsInfo#goods.goods_id,
												 GoodsInfo#goods.equip_type, GoodsInfo#goods.bind,
												 GoodsInfo#goods.trade, GoodsInfo#goods.sell,
 												 GoodsInfo#goods.level,
                                                 GoodsInfo#goods.color,
                                                 util:term_to_bitstring(GoodsInfo#goods.other#goods_other.addition),
                                                 util:term_to_bitstring(GoodsInfo#goods.other#goods_other.extra_attr),
                                                 util:term_to_bitstring(OtherData)
                                                 ]),
    db:execute(Sql2),
    Sql3 = io_lib:format(?SQL_GOODS_HIGHT_INSERT, [GoodsId, GoodsInfo#goods.player_id, GoodsInfo#goods.goods_id,
												   GoodsInfo#goods.guild_id, GoodsInfo#goods.location, GoodsInfo#goods.sub_location,
												   GoodsInfo#goods.cell, GoodsInfo#goods.num]),
    db:execute(Sql3),
    GoodsInfo#goods{id = GoodsId}.

%% 删除物品
delete_goods(GoodsId) ->
	Sql = io_lib:format(?SQL_GOODS_DELETE_BY_ID, [GoodsId]),
	db:execute(Sql).

%% 删除帮派物品
delete_goods_by_guild(GuildId) ->
    Sql = io_lib:format(?SQL_GOODS_DELETE_BY_GUILD, [GuildId]),
    db:execute(Sql),
    ok.

to_term(BinString) ->
	case util:bitstring_to_term(BinString) of
		undefined ->
			[];
		Term ->
			Term
	end.

%% 取物品类型信息
get_ets_info(Tab, Id) ->
	I = case is_integer(Id) of
			true ->
				ets:lookup(Tab, Id);
			false ->
				ets:match_object(Tab, Id)
		end,
	case I of
		[Info|_] ->
			Info;
		_ ->
			[]
	end.

get_ets_list(Tab, Pattern) ->
    ets:match_object(Tab, Pattern).

%%------------------------------------------------
%% 排序
%%------------------------------------------------
sort(GoodsList, Type) ->
	case Type of
		id -> F = fun(G1, G2) -> G1#goods.id < G2#goods.id end;
		cell -> F = fun(G1, G2) -> G1#goods.cell < G2#goods.cell end;
		bind -> F = fun(G1, G2) -> G1#goods.bind > G2#goods.bind end;
        goods_id -> F = fun(G1, G2) -> G1#goods.goods_id < G2#goods.goods_id end;
        bind_id ->
            F = fun(G1, G2) ->
                if
                    G1#goods.goods_id =:= G2#goods.goods_id ->
                        G1#goods.bind < G2#goods.bind;
                    true ->
                        G1#goods.goods_id < G2#goods.goods_id
                end
            end;
        bind_num ->
            F = fun(G1, G2) ->
                if
                    G1#goods.bind > G2#goods.bind -> true;
                    G1#goods.bind =:= G2#goods.bind andalso G1#goods.num < G2#goods.num -> true;
                    true -> false
                end
            end;
		_ -> F = fun(G1, G2) -> G1#goods.cell < G2#goods.cell end
		end,
	lists:sort(F, GoodsList).

%%====================================
%% 取机率总和
%% RatioList 包含概率的元组列表
%% N 概率值所在元组的位置
%%====================================
get_ratio_total(RatioList, N) ->
    F = fun(RatioInfo, Sum) ->
                element(N, RatioInfo) + Sum
        end,
    lists:foldl(F, 0, RatioList).

%%====================================
%% 查找匹配机率的值
%% InfoList 包含概率的元组列表，
%%如以100为基数[{goods1,10},{goods2,30},{goods3,100}]
%% Start    开始概率值，一般传0
%% Rand     随机值
%% N        概率值在元组的位置
%%=====================================
find_ratio([], _, _, _) -> null;
find_ratio(InfoList, Start, Rand, N) ->
    [Info | List] = InfoList,
    End = Start + element(N, Info),
    case Rand > Start andalso Rand =< End of
        true  -> Info;
        false -> find_ratio(List, End, Rand, N)
    end.

%% 取任务物品数量
%% @spec get_task_goods_num(PlayerId, GoodsTypeId, GoodsDict) -> interger()
get_task_goods_num(_PlayerId, GoodsTypeId, Dict) ->
    Dict1 = dict:filter(fun(_Key, [Value]) -> Value#goods.goods_id=:=GoodsTypeId end, Dict),
    DictList = dict:to_list(Dict1),
    GoodsList = lib_goods_dict:get_list(DictList, []),
    get_goods_totalnum(GoodsList).

%% 帮派仓库物品列表
%% get_guild_goods_list(GuildId) ->
%%     Sql = io_lib:format(?SQL_GOODS_LIST_BY_GUILD, [GuildId]),
%%     get_list(goods, Sql).

%% 判断是否未超过次数限制
check_lessthan_limit(_PlayerId, 0, _CounterId, _CounterType) -> true;
check_lessthan_limit(_PlayerId, _Module, 0, _CounterType) -> true;
check_lessthan_limit(_PlayerId, _Module, _CounterId, 0) -> true;
check_lessthan_limit(PlayerId, CounterModule, CounterId, ?COUNTER_DAILY) ->
    mod_daily:lessthan_limit(PlayerId, CounterModule, CounterId);
check_lessthan_limit(PlayerId, CounterModule, CounterId, ?COUNTER_WEEK) ->
    mod_week:lessthan_limit(PlayerId, CounterModule, CounterId);
check_lessthan_limit(PlayerId, CounterModule, CounterId, ?COUNTER_LIFETIME) ->
    mod_counter:lessthan_limit(PlayerId, CounterModule, CounterId);
check_lessthan_limit(_PlayerId, CounterModule, CounterId, CounterType) ->
    ?ERR("Unknown args :~p~n", [{CounterModule, CounterId, CounterType}]),
    true.

%% 判断是否未超过次数限制
%% @param UseCount 次数
check_lessthan_limit(_PlayerId, 0, _CounterId, _CounterType, _UseCount) -> true;
check_lessthan_limit(_PlayerId, _Module, 0, _CounterType, _UseCount) -> true;
check_lessthan_limit(_PlayerId, _Module, _CounterId, 0, _UseCount) -> true;
check_lessthan_limit(PlayerId, CounterModule, CounterId, ?COUNTER_DAILY, UseCount) ->
    Count = mod_daily:get_count(PlayerId, CounterModule, CounterId),
    Limit = lib_daily:get_count_limit(PlayerId, CounterModule, CounterId),
    Count+UseCount < Limit;
check_lessthan_limit(PlayerId, CounterModule, CounterId, ?COUNTER_WEEK, UseCount) ->
    Count = mod_week:get_count(PlayerId, CounterModule, CounterId),
    Limit = lib_week:get_count_limit(PlayerId, CounterModule, CounterId),
    Count+UseCount < Limit;
check_lessthan_limit(PlayerId, CounterModule, CounterId, ?COUNTER_LIFETIME, UseCount) ->
    Count = mod_counter:get_count(PlayerId, CounterModule, CounterId),
    Limit = lib_counter:get_count_limit(PlayerId, CounterModule, CounterId),
    Count+UseCount < Limit;
check_lessthan_limit(_PlayerId, CounterModule, CounterId, CounterType, UseCount) ->
    ?ERR("Unknown args :~p~n", [{CounterModule, CounterId, CounterType, UseCount}]),
    true.

%% 次数增加一
increment_counter(_PlayerId, 0, _CounterId, _CounterType) -> skip;
increment_counter(_PlayerId, _Module, 0, _CounterType) -> skip;
increment_counter(_PlayerId, _Module, _CounterId, 0) -> skip;
increment_counter(PlayerId, CounterModule, CounterId, ?COUNTER_DAILY) ->
    mod_daily:increment(PlayerId, CounterModule, CounterId);
increment_counter(PlayerId, CounterModule, CounterId, ?COUNTER_WEEK) ->
    mod_week:increment(PlayerId, CounterModule, CounterId);
increment_counter(PlayerId, CounterModule, CounterId, ?COUNTER_LIFETIME) ->
    mod_counter:increment(PlayerId, CounterModule, CounterId);
increment_counter(_PlayerId, _Module, _CounterId, _CounterType) -> skip.

%% 次数增加
plus_counter(_PlayerId, 0, _CounterId, _CounterType, _UseCount) -> skip;
plus_counter(_PlayerId, _Module, 0, _CounterType, _UseCount) -> skip;
plus_counter(_PlayerId, _Module, _CounterId, 0, _UseCount) -> skip;
plus_counter(PlayerId, CounterModule, CounterId, ?COUNTER_DAILY, UseCount) ->
    mod_daily:plus_count(PlayerId, CounterModule, CounterId, UseCount);
plus_counter(PlayerId, CounterModule, CounterId, ?COUNTER_WEEK, UseCount) ->
    mod_week:plus_count(PlayerId, CounterModule, CounterId, UseCount);
plus_counter(PlayerId, CounterModule, CounterId, ?COUNTER_LIFETIME, UseCount) ->
    mod_counter:plus_count(PlayerId, CounterModule, CounterId, UseCount);
plus_counter(_PlayerId, _Module, _CounterId, _CounterType, _UseCount) -> skip.

%% 是否加载物品额外记录
%% Type :: 物品类型
load_goods_other(Type) when is_integer(Type) ->
    lists:member(Type, ?GOODS_TYPE_LOAD_OTHER);
load_goods_other(#ets_goods_type{type = Type}) ->
    lists:member(Type, ?GOODS_TYPE_LOAD_OTHER);
load_goods_other(#goods{type = Type}) ->
    lists:member(Type, ?GOODS_TYPE_LOAD_OTHER).

%%--------------------------------------------------
%% 合并[{type, id, num}]类型的消耗列表
%% @param  CostList      [{type, id, num}]
%% @param  OtherCostList [{type, id, num}]
%% @return               [{type, id, num}]
%%--------------------------------------------------
goods_object_multiply_by(GoodsList, 1) -> GoodsList;
goods_object_multiply_by(GoodsList, X) ->
    [
        begin
            case Object of
                {Type, GTypeId, Num} ->
                    {Type, GTypeId, trunc(Num * X)};
                {Type, GTypeId, Num, AttrList} ->
                    {Type, GTypeId, trunc(Num * X), AttrList};
                {GTypeId, Num} ->
                    {GTypeId, trunc(Num*X)}
            end
        end || Object <- GoodsList
    ].

%%--------------------------------------------------
%% 获取空格子的数量
%% @param  Player #player_status{}
%% @return        [{location, NullCell}]
%%--------------------------------------------------
get_null_cell_num_list(Player) when is_record(Player, player_status) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{num_cells = NumCellsMap} = GoodsStatus,
    F = fun({Location, {UseNum, MaxNum}}, List) ->
            ?IF(MaxNum>0, [{Location, max(0, MaxNum-UseNum)}|List], List);
        ({_Location, _}, List) -> List
    end,
    lists:foldl(F, [], maps:to_list(NumCellsMap)).

%%--------------------------------------------------
%% 获取空格子的数量
%% @param  GoodsStatus #goods_status{}
%% @param  Location     description
%% @return              {NullCell, NewNullCellsMap}
%%--------------------------------------------------
get_null_cell_num(GoodsStatus, Location) ->
    #goods_status{num_cells = NumCells} = GoodsStatus,
    {UseNum, MaxNum} = maps:get(Location, NumCells, {0, 0}),
    ?IF(MaxNum == 0, 9999999, max(MaxNum - UseNum, 0)).

%%--------------------------------------------------
%% 判断背包是否还有空位置
%%--------------------------------------------------
bag_had_cell_num(NumCells, Location) ->
    case maps:get(Location, NumCells, {0, 0}) of
        {0, 0} -> true;
        {HadNum, MaxNum} -> HadNum < MaxNum
    end.

%%--------------------------------------------------
%% 获取背包空位置数量
%%--------------------------------------------------
get_bag_cell_num(GoodsStatus, Location) ->
    #goods_status{num_cells = NumCells} = GoodsStatus,
    maps:get(Location, NumCells, {0, 0}).

%%--------------------------------------------------
%% 消耗一个背包空格子
%%--------------------------------------------------
occupy_num_cells(GoodsStatus, Location) ->
    NewNumCells = occupy_num_cells(GoodsStatus#goods_status.num_cells, Location, 1),
    GoodsStatus#goods_status{num_cells = NewNumCells}.
occupy_num_cells(NumCells, Location, AddNum) ->
    case maps:get(Location, NumCells, {0, 0}) of
        {0, 0} -> NumCells;
        {HadNum, MaxNum} ->
            NewNumCells = maps:put(Location, {HadNum+AddNum, MaxNum}, NumCells),
            NewNumCells
    end.

%%--------------------------------------------------
%% 释放一个背包空格子
%%--------------------------------------------------
release_num_cells(GoodsStatus, Location) ->
    NumCells = GoodsStatus#goods_status.num_cells,
    NewNumCells = release_num_cells(NumCells, Location, 1),
    GoodsStatus#goods_status{num_cells = NewNumCells}.
release_num_cells(NumCells, Location, Num) ->
    case maps:get(Location, NumCells, {0, 0}) of
        {0, 0} -> NumCells;
        {HadNum, MaxNum} ->
            NewNumCells = maps:put(Location, {max(HadNum - Num, 0), MaxNum}, NumCells),
            NewNumCells
    end.
%%--------------------------------------------------
%% 背包最大容量扩容
%%--------------------------------------------------
expand_num_cells(GoodsStatus, Location, AllCellNum) ->
    NumCells = GoodsStatus#goods_status.num_cells,
    case maps:get(Location, NumCells, {0, 0}) of
        {0, 0} -> GoodsStatus;
        {HadNum, _MaxNum} ->
            NewNumCells = maps:put(Location, {HadNum, AllCellNum}, NumCells),
            GoodsStatus#goods_status{num_cells = NewNumCells}
    end.

%%--------------------------------------------------
%% 发放物品结果更新
%%--------------------------------------------------
update_reward_result(Key, GoodsTypeId, GoodsNum, RewardResult) ->
    OList = maps:get(Key, RewardResult, []),
    case lists:keyfind(GoodsTypeId, 2, OList) of
        {?TYPE_GOODS, GoodsTypeId, ONum} ->
            List = [{?TYPE_GOODS, GoodsTypeId, GoodsNum+ONum}|lists:keydelete(GoodsTypeId, 2, OList)];
        _ -> List = [{?TYPE_GOODS, GoodsTypeId, GoodsNum}|OList]
    end,
    maps:put(Key, List, RewardResult).

calc_random_rewards(Rewards) ->
     F = fun
        ({Key, Id, NumFormat}) ->
            Num
            = case NumFormat of
                Value when is_integer(Value) ->
                    Value;
                [Min, Max] when is_integer(Min) andalso is_integer(Max) ->
                    if
                        Min > Max ->
                            urand:rand(Max, Min);
                        true ->
                            urand:rand(Min, Max)
                    end;
                _ ->
                    urand:rand_with_weight(NumFormat)
            end,
            {Key, Id, Num}
    end,
    [Item || {_Key, _Id, Num} = Item <- [F(R) || R <- Rewards], Num > 0].

is_random_rewards(Rewards) ->
    lists:any(fun
        ({_, _, Num}) ->
            not is_number(Num)
    end, Rewards).

goods_to_bind_goods(ObjectList) ->
    [begin
        case Object of
            {?TYPE_GOODS, Id, Num} ->
                {?TYPE_BIND_GOODS, Id, Num};
            {?TYPE_ATTR_GOODS, Id, Num, AttrList} ->
                {?TYPE_ATTR_GOODS, Id, Num, lists:keystore(bind, 1, AttrList, {bind, ?BIND})};
            {Id, Num} when is_integer(Id) ->
                {?TYPE_BIND_GOODS, Id, Num};
            _ ->
                Object
        end
     end || Object <- ObjectList].

format_other_data(GoodsInfo) ->
    case GoodsInfo#goods.type of
        ?GOODS_TYPE_EUDEMONS ->
            lib_eudemons:format_other_data(GoodsInfo);
        ?GOODS_TYPE_PET_EQUIP ->
            lib_pet:format_other_data(GoodsInfo);
        ?GOODS_TYPE_MOUNT_EQUIP ->
            lib_mount_equip:format_other_data(GoodsInfo);
        ?GOODS_TYPE_MATE_EQUIP ->
            lib_mount_equip:format_other_data(GoodsInfo);
        ?GOODS_TYPE_COUNT_GIFT ->
            lib_gift_new:format_other_data(GoodsInfo);
        ?GOODS_TYPE_GIFT ->
            lib_gift_new:format_other_data(GoodsInfo);
        ?GOODS_TYPE_SEAL ->
            lib_seal:format_other_data(GoodsInfo);
        ?GOODS_TYPE_GOD_EQUIP ->
            lib_god_util:format_other_data(GoodsInfo);
        ?GOODS_TYPE_SOUL ->
            lib_soul:format_other_data(GoodsInfo);
        ?GOODS_TYPE_RUNE ->
            lib_rune:format_other_data(GoodsInfo);
        ?GOODS_TYPE_CONSTELLATION ->
            lib_constellation_equip:format_other_data(GoodsInfo);
        ?GOODS_TYPE_GUILD_GOD ->
            lib_guild_god_util:format_other_data(GoodsInfo);
        _ ->
            []
    end.

get_new_other_data(GoodsInfo, Key, Value) ->
    case GoodsInfo#goods.type of
        ?GOODS_TYPE_GIFT ->
            GoodsTypeId = GoodsInfo#goods.goods_id,
            OptionalData = GoodsInfo#goods.other#goods_other.optional_data,
            case Key of
                role_lv ->
                    IsLvGift = lib_gift_new:is_lv_gift(GoodsTypeId),
                    ?IF(IsLvGift, [{?GOODS_OTHER_SUBKEY_GIFT_LV, Value}|OptionalData], OptionalData);
                rune_lv ->
                    IsRuneGift = lib_gift_new:is_rune_gift(GoodsTypeId),
                    ?IF(IsRuneGift, [{?GOODS_OTHER_SUBKEY_GIFT_RUNE, Value} | OptionalData], OptionalData);
                open_day ->
                    IsOpenDayGift = lib_gift_new:is_open_day_gift(GoodsTypeId),
                    ?IF(IsOpenDayGift, [{?GOODS_OTHER_SUBKEY_GIFT_OPEN_DAY, util:get_open_day()} | OptionalData], OptionalData);
                _ -> OptionalData
            end;
        _ ->
            []
    end.

calc_diffrence_goods(GoodsList, []) -> GoodsList;

calc_diffrence_goods(GoodsList1, GoodsList2) ->
    List1 = [ {{Type, GoodsId}, Num} || {Type, GoodsId, Num} <- ulists:object_list_plus([[], GoodsList1])],
    List2 = [ {{Type, GoodsId}, Num} || {Type, GoodsId, Num} <- ulists:object_list_plus([[], GoodsList2])],
    calc_diffrence_objects(List1, List2).

calc_diffrence_objects(List, [{Key, Num}|T]) ->
    case lists:keytake(Key, 1, List) of
        {value, {_, Num1}, Others} ->
            if
                Num1 > Num ->
                    calc_diffrence_objects([{Key, Num1 - Num}|Others], T);
                true ->
                    calc_diffrence_objects(Others, T)
            end;
        _ ->
            calc_diffrence_objects(List, T)
    end;

calc_diffrence_objects(List, []) ->
    [{Type, Id, Num} || {{Type, Id}, Num} <- List].

spilt_object_list_by_num(ObjectList, SpiltNum) ->
    spilt_object_list_by_num(ObjectList, SpiltNum, [], []).

spilt_object_list_by_num([], _SpiltNum, L1, L2) -> {L1, L2};
spilt_object_list_by_num(ObjectList, 0, L1, L2) -> {L1, ObjectList++L2};
spilt_object_list_by_num([Item|ObjectList], SpiltNum, L1, L2) ->
    case Item of
        {?TYPE_GOODS, GoodsTypeId, Num} ->
            ?IF(Num =< SpiltNum,
                spilt_object_list_by_num(ObjectList, SpiltNum-Num, [Item|L1], L2),
                spilt_object_list_by_num(ObjectList, 0, [{?TYPE_GOODS, GoodsTypeId, SpiltNum}|L1], [{?TYPE_GOODS, GoodsTypeId, Num-SpiltNum}|L2])
            );
        {?TYPE_GOODS, GoodsTypeId, Num, Bind} ->
            ?IF(Num =< SpiltNum,
                spilt_object_list_by_num(ObjectList, SpiltNum-Num, [Item|L1], L2),
                spilt_object_list_by_num(ObjectList, 0, [{?TYPE_GOODS, GoodsTypeId, SpiltNum, Bind}|L1], [{?TYPE_GOODS, GoodsTypeId, Num-SpiltNum, Bind}|L2])
            );
        {?TYPE_BIND_GOODS, GoodsTypeId, Num} ->
            ?IF(Num =< SpiltNum,
                spilt_object_list_by_num(ObjectList, SpiltNum-Num, [Item|L1], L2),
                spilt_object_list_by_num(ObjectList, 0, [{?TYPE_BIND_GOODS, GoodsTypeId, SpiltNum}|L1], [{?TYPE_BIND_GOODS, GoodsTypeId, Num-SpiltNum}|L2])
            );
        {?TYPE_ATTR_GOODS, GoodsTypeId, Num, Attr} ->
            ?IF(Num =< SpiltNum,
                spilt_object_list_by_num(ObjectList, SpiltNum-Num, [Item|L1], L2),
                spilt_object_list_by_num(ObjectList, 0, [{?TYPE_ATTR_GOODS, GoodsTypeId, SpiltNum, Attr}|L1], [{?TYPE_ATTR_GOODS, GoodsTypeId, Num-SpiltNum, Attr}|L2])
            )
    end.


is_enough_currency(PS, CurrencyId, Num) ->
    case maps:find(CurrencyId, PS#player_status.currency_map) of
        {ok, Value} ->
            Value >= Num;
        _ ->
            false
    end.

load_currency(RoleId) ->
    SQL = io_lib:format(?LOAD_CURRENCY, [RoleId]),
    All = db:get_all(SQL),
    maps:from_list([{CurrencyId, Value} || [CurrencyId, Value|_] <- All]).

get_casting_spirit_list(PlayerId, EquipList) ->
    Sql = io_lib:format(?SQL_SELECT_EQUIP_CASTING_SPIRIT, [PlayerId]),
    List = db:get_all(Sql),
    F = fun([EquipPos, Stage, Lv], Acc) ->
        case lists:keyfind(EquipPos, #goods.cell, EquipList) of
            EquipInfo when is_record(EquipInfo, goods) -> skip;
            _ -> EquipInfo = #goods{}
        end,
        T = #equip_casting_spirit{pos = EquipPos, stage = Stage, lv = Lv},
        Rating = lib_equip:count_casting_spirit_rating(EquipInfo, T),
        lists:keystore(EquipPos, #equip_casting_spirit.pos, Acc, T#equip_casting_spirit{rating = Rating})
    end,
    lists:foldl(F, [], List).

get_equip_spirit(PlayerId) ->
    Sql = io_lib:format(?SQL_SELECT_EQUIP_SPIRIT, [PlayerId]),
    case db:get_row(Sql) of
        [Lv|_] ->
            #equip_spirit{lv = Lv};
        _ -> #equip_spirit{}
    end.

insert_casting_spirit(RoleId, EquipPos, Stage, Lv) ->
    db:execute(io_lib:format(?SQL_INSERT_EQUIP_CASTING_SPIRIT, [RoleId, EquipPos, Stage, Lv])).

update_casting_spirit(RoleId, EquipPos, Stage, Lv) ->
    db:execute(io_lib:format(?SQL_UPDATE_EQUIP_CASTING_SPIRIT, [Stage, Lv, RoleId, EquipPos])).

update_spirit(RoleId, Lv) ->
    db:execute(io_lib:format(?SQL_UPDATE_EQUIP_SPIRIT, [RoleId, Lv])).

get_euqip_awakening(PlayerId) ->
    Sql = io_lib:format(?SQL_SELECT_EQUIP_AWAKENING, [PlayerId]),
    List = db:get_all(Sql),
    F = fun([EquipPos, Lv], Acc) ->
        lists:keystore(EquipPos, #equip_awakening.pos, Acc, #equip_awakening{pos = EquipPos, lv = Lv})
    end,
    lists:foldl(F, [], List).

insert_awakening(RoleId, EquipPos, Lv) ->
    db:execute(io_lib:format(?SQL_INSERT_EQUIP_AWAKENING, [RoleId, EquipPos, Lv])).

update_awakening(RoleId, EquipPos, Lv) ->
    db:execute(io_lib:format(?SQL_UPDATE_EQUIP_AWAKENING, [Lv, RoleId, EquipPos])).

get_euqip_skill(PlayerId) ->
    Sql = io_lib:format(?SQL_SELECT_EQUIP_SKILL, [PlayerId]),
    List = db:get_all(Sql),
    F = fun([EquipPos, SkillId, SkillLv], Acc) ->
        lists:keystore(EquipPos, #equip_skill.pos, Acc, #equip_skill{pos = EquipPos, skill_id = SkillId, skill_lv = SkillLv})
    end,
    lists:foldl(F, [], List).

insert_equip_skill(RoleId, EquipPos, SkillId, SkillLv) ->
    db:execute(io_lib:format(?SQL_INSERT_EQUIP_SKILL, [RoleId, EquipPos, SkillId, SkillLv])).

update_equip_skill(RoleId, EquipPos, SkillId, SkillLv) ->
    db:execute(io_lib:format(?SQL_UPDATE_EQUIP_SKILL, [SkillId, SkillLv, RoleId, EquipPos])).

update_equip_skill_lv(RoleId, EquipPos, SkillLv) ->
    db:execute(io_lib:format(?SQL_UPDATE_EQUIP_SKILL_LV, [SkillLv, RoleId, EquipPos])).

delete_equip_skill(RoleId, EquipPos) ->
    db:execute(io_lib:format(?SQL_DELETE_EQUIP_SKILL, [RoleId, EquipPos])).

get_bag_fusion(RoleId) ->
    Sql = io_lib:format(?SQL_SELECT_EQUIP_FUSION, [RoleId]),
    case db:get_row(Sql) of
        [Lv, Exp] -> #rec_fusion{lv = Lv, exp = Exp};
        _ -> #rec_fusion{lv = 0, exp = 0}
    end.

get_bag_fusion_attr(RecFusion) ->
    case data_goods_decompose:get_fusion_cfg(RecFusion#rec_fusion.lv) of
        #base_equip_fusion_attr{attr_list = AttrList} -> AttrList;
        _ -> []
    end.

db_replace_equip_fusion(RoleId, RecFusion) ->
    #rec_fusion{lv = Lv, exp = Exp} = RecFusion,
    Sql = io_lib:format(?SQL_BATCH_REPLACE_EQUIP_FUSION, [RoleId, Lv, Exp]),
    db:execute(Sql).

make_goods_status_in_transaction(GoodsStatus, FilterConditions) ->
    #goods_status{dict = OldDict} = GoodsStatus,
    F = fun(Item, TmpDict) ->
        case Item of
            {gid_in, GTypeIdList} ->
                GoodsList = get_goods_list_by_type_ids(OldDict, GTypeIdList);
            {gid_key_in, Key, GTypeIdList} ->
                GoodsList = get_goods_list_by_type_ids(OldDict, Key, GTypeIdList);
            {id_in, IdList} ->
                GoodsList = get_goods_list_by_ids(OldDict, IdList);
            {location, LocationList} ->
                GoodsList = get_goods_list_by_location_list(OldDict, LocationList);
            {type, TypeList} ->
                GoodsList = get_goods_list_by_type_list(OldDict, TypeList)
        end,
        lib_goods_dict:add_goods_to_dict(TmpDict, GoodsList)
    end,
    RelativeDict = lists:foldl(F, dict:new(), FilterConditions),
    GoodsStatus#goods_status{dict = RelativeDict}.


restore_goods_status_out_transaction(GoodsStatusAfTrans, GoodsStatusBfTrans, GoodsStatusRaw) ->
    DictRaw = GoodsStatusRaw#goods_status.dict,
    DictBf = GoodsStatusBfTrans#goods_status.dict,
    DictAf = GoodsStatusAfTrans#goods_status.dict,
    %% 删除删掉的物品
    F1 = fun({Key, _}, List) -> ?IF(dict:is_key(Key, DictAf), List, [{del, goods, Key}|List]) end,
    List1 = lists:foldl(F1, [], dict:to_list(DictBf)),
    %% 增加或者修改的物品
    F2 = fun({_Key, [GoodsInfo]}, List) -> [{add, goods, GoodsInfo}|List] end,
    List2 = lists:foldl(F2, List1, dict:to_list(DictAf)),
    NewDict = lib_goods_dict:handle_item([List2], DictRaw),
    GoodsStatusAfTrans#goods_status{dict = NewDict}.

%%--------------------------------------------------
%% 如果合成后的物品需要特殊处理属性的写在这个接口里面 不能改变合成物品的id！！！！！
%% 不要在这里面做发奖励的逻辑！！！！！
%% @param  ComposeCfg            #goods_compose_cfg{}
%% @param  SpecifyGIdList        [{GoodsId, GoodsNum, GoodsType}]
%% @param  UpdateGoodsList       [#goods{}]
%% @return                       [{key,val}]
%%--------------------------------------------------
count_goods_compose_attr(_Ps, ComposeCfg, _SpecifyGIdList, UpdateGoodsList) ->
    #goods_compose_cfg{
        type = ComposeType,
        goods = GoodsList
    } = ComposeCfg,
    case GoodsList of
        [] ->
            AttrList = [];
        [{?TYPE_GOODS, GoodsTypeId, _GNum}|_] ->
            GoodsConInfo = data_goods_type:get(GoodsTypeId),
            case GoodsConInfo#ets_goods_type.type of
                ?GOODS_TYPE_RUNE ->
                    {Level, AwakeLvList} = lib_rune:get_rune_compose_level(GoodsConInfo, UpdateGoodsList),
                    AttrList = [{level, Level}, {optional_data, AwakeLvList}];
                ?GOODS_TYPE_SOUL ->
                    {Level, AwakeLvList} = lib_soul:calc_and_do_soul_compose(GoodsConInfo, UpdateGoodsList),
                    AttrList = [{level, Level}, {optional_data, AwakeLvList}];
                ?GOODS_TYPE_EUDEMONS ->
                    {Stren, Exp} = lib_eudemons:calc_strength(GoodsTypeId, UpdateGoodsList),
                    AttrList = [{stren, {Stren, Exp}}];
                ?GOODS_TYPE_MOUNT_EQUIP ->
                    SkillId = lib_mount_equip:compose_skill(GoodsTypeId, UpdateGoodsList),
                    AttrList = [{skill, SkillId}];
                ?GOODS_TYPE_EQUIP ->
                    SubType = GoodsConInfo#ets_goods_type.subtype,
                    case ComposeType == 10 andalso (SubType == ?EQUIP_BRACELET orelse SubType == ?EQUIP_RING) of
                        true ->
                            case [Goods ||#goods{type=?GOODS_TYPE_EQUIP, subtype=SubType1}=Goods <- UpdateGoodsList, SubType1 == ?EQUIP_BRACELET orelse SubType1 == ?EQUIP_RING] of
                                [EquipGoods|_] ->
                                    #goods{other = #goods_other{extra_attr = OldExtraAttr}} = EquipGoods,
                                    NewExtraAttr = lib_equip:gen_equip_extra_attr_by_types(GoodsConInfo, OldExtraAttr),
                                    AttrList = [{extra_attr, NewExtraAttr}];
                                _ ->
                                    AttrList = []
                            end;
                        _ ->
                            AttrList = []
                    end;
                ?GOODS_TYPE_BABY_EQUIP ->
                    SkillId = lib_baby:compose_skill(GoodsTypeId, UpdateGoodsList),
                    AttrList = [{skill, SkillId}];
                _ ->
                    AttrList = []
            end
    end,
    AttrList.

%%--------------------------------------------------
%% 获取一个空的格子id
%% @param  NullCellsMap #{location => NullCellsList}
%% @param  Location     description
%% @return              {NullCell, NewNullCellsMap}
%%--------------------------------------------------
% get_null_cell(NullCellsMap, Location) ->
%     case maps:get(Location, NullCellsMap, []) of
%         [NullCell|L] ->
%             NewNullCellsMap = maps:put(Location, L, NullCellsMap),
%             {NullCell, NewNullCellsMap};
%         _ -> {0, NullCellsMap}
%     end.

%%--------------------------------------------------
%% 获取空格子的数量
%% @param  Player #player_status{}
%% @return        [{location, NullCell}]
%%--------------------------------------------------
% get_null_cell_num_list(Player) when is_record(Player, player_status) ->
%     GoodsStatus = lib_goods_do:get_goods_status(),
%     #goods_status{null_cells = NullCellsMap} = GoodsStatus,
%     F = fun({Location, NullCellsList}) ->
%         {Location, length(NullCellsList)}
%     end,
%     lists:map(F, maps:to_list(NullCellsMap)).

%%--------------------------------------------------
%% 增加一个空的格子
%% @param  NullCellsMap #{location => NullCellsList}
%% @param  Location     description
%% @param  Cell         description
%% @return              NewNullCellsMap
%%--------------------------------------------------
% add_null_cell(NullCellsMap, Location, Cell) when is_integer(Cell) ->
%     add_null_cell(NullCellsMap, Location, [Cell]);
% add_null_cell(NullCellsMap, Location, CellList) when is_list(CellList) ->
%     L = maps:get(Location, NullCellsMap, []),
%     SortL = lists:sort(CellList ++ L),
%     maps:put(Location, SortL, NullCellsMap).

%%--------------------------------------------------
%% 移除一个空的格子
%% @param  NullCellsMap #{location => NullCellsList}
%% @param  Location     description
%% @param  Cell         description
%% @return              NewNullCellsMap
%%--------------------------------------------------
% remove_null_cell(NullCellsMap, Location, Cell) ->
%     L = maps:get(Location, NullCellsMap, []),
%     NewL = lists:delete(Cell, L),
%     maps:put(Location, NewL, NullCellsMap).

% update_null_cell(NullCellsMap, Location, CellList) ->
%     maps:put(Location, CellList, NullCellsMap).