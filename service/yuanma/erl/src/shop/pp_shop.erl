%%%--------------------------------------
%%% @Module  : pp_shop
%%% @Author  : xiaoxiang
%%% @Created : 2017.1.3
%%% @Description:  商城模块
%%%--------------------------------------
-module(pp_shop).
-export([handle/3]).

-include("server.hrl").
-include("common.hrl").
-include("shop.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("def_fun.hrl").

%% 获得商品列表
handle(15301, Player, [Type]) ->
%%    ?PRINT("15301 ===================~n",[]),
    case lists:member(Type, ?SHOP_TYPE_LIST) of
        true -> lib_shop:get_goods_list(Player, Type);
        false -> skip
    end;

%% 购买商品
handle(15302, Player, [KeyId, Num]) ->
%%    ?PRINT("15302 ===================~n",[]),
    {Code, NewPS} = lib_shop:buy_goods_by_money_type(Player, KeyId, Num),
    lib_server_send:send_to_sid(Player#player_status.sid, pt_153, 15302, [Code, KeyId, Num]),
    {ok, NewPS};

%% 根据物品类型id购买物品
handle(15303, #player_status{sid = Sid} = Player, [GoodsId, Num]) when Num > 0 ->
    case data_goods:get_goods_buy_price(GoodsId) of  % 获取价格  {价格类型,价格} 价格类型:0:物品(一般物品出售不配为物品);1:钻石;2:绑定钻石;3金币
        {0, 0} ->
            lib_server_send:send_to_sid(Sid, pt_153, 15303, [?ERRCODE(err153_goods_sold_out), GoodsId, Num]);
        {PriceType, PriceValue} ->
            GoodsList = [{?TYPE_GOODS, GoodsId, Num}],
            case lib_goods_api:can_give_goods(Player, GoodsList) of   % 检查物品是否可以加入到背包
                true ->
                    Cost = [{PriceType, 0, PriceValue * Num}],
                    case lib_goods_api:cost_object_list_with_check(Player, Cost, buy_goods, lists:concat([GoodsId, "*", Num])) of
                        {true, CostPlayer} ->
                            Produce = #produce{type = buy_goods, reward = GoodsList, remark = util:term_to_string(Cost)},
                            NewPlayer = lib_goods_api:send_reward(CostPlayer, Produce),
                            lib_server_send:send_to_sid(Sid, pt_153, 15303, [?SUCCESS, GoodsId, Num]),
                            {ok, NewPlayer};
                        {false, Code, _} ->
                            lib_server_send:send_to_sid(Sid, pt_153, 15303, [Code, GoodsId, Num])
                    end;
                {false, ErrorCode} ->
                    lib_server_send:send_to_sid(Sid, pt_153, 15303, [ErrorCode, GoodsId, Num])
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_153, 15303, [?ERRCODE(err153_goods_sold_out), GoodsId, Num])
    end;

%% 根据物品类型id购买物品（快速购买）
handle(15304, Ps, [GoodsId, Num, BuyType]) ->
    #player_status{
        id = RoleId
    } = Ps,
    case data_quick_buy:get_quick_buy_price(GoodsId) of
        [] ->
            Code = ?MISSING_CONFIG,
            NewPs = Ps;
        QuickBuyPriceCon ->
            #quick_buy_price{
                gold_price = GoldPrice,
                bgold_price = BGoldPrice
            } = QuickBuyPriceCon,
            case BuyType =:= 2 andalso BGoldPrice =:= 0 of
                true ->
                    Code = ?ERRCODE(err153_qb_not_right_money),
                    NewPs = Ps;
                false ->
                    GoodsList =
                        case BuyType of
                            1 ->
                                [{?TYPE_GOODS, GoodsId, Num}];
                            _ ->
                                [{?TYPE_BIND_GOODS, GoodsId, Num}]
                        end,
                    case lib_goods_api:can_give_goods(Ps, GoodsList) of
                        {false, ErrorCode} ->
                            Code = ErrorCode,
                            NewPs = Ps;
                        true ->
                            case BuyType of
                                1 ->
                                    MoneyType = gold,
                                    Price = GoldPrice * Num;
                                _ ->
                                    MoneyType = bgold,
                                    Price = BGoldPrice * Num
                            end,
                            About = #cost_log_about{type = 4, data = [GoodsId, Num], remark = "quick buy"},
                            case lib_goods_api:cost_money(Ps, MoneyType, Price, quick_buy, About) of
                                {1, NewPs1} ->
                                    Code = ?SUCCESS,
                                    NewPs = lib_goods_api:send_reward(NewPs1, GoodsList, quick_buy, 0),
                                    CostType = ?IF(BuyType==1, ?TYPE_GOLD, ?TYPE_BGOLD),
                                    ta_agent_fire:role_shop_by(NewPs1, [quick_buy, 0, GoodsId, Num, CostType, Price]);
                                {_, NewPs} ->
                                    Code = ?ERRCODE(money_not_enough)
                            end
                    end
            end
    end,
    {ok, Bin} = pt_153:write(15304, [Code, GoodsId, Num, BuyType]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

%% 神秘商店
handle(15305, PlayerStatus, [Type]) ->
    case lists:member(Type, ?SHOP_TYPE_CAREER) of
        true -> lib_mystery_shop:shop_main_show(PlayerStatus,Type);
        false -> skip
    end;

% 手动刷新商店
handle(15306, PlayerStatus, [Type]) ->
%%    ?PRINT("15306 ===================~n",[]),
    #player_status{id=RoleId} = PlayerStatus,
    case lib_mystery_shop:hit_refresh(PlayerStatus,Type) of
        {true,NewPS} -> {ok,NewPS};
        {false, Errcode} ->
%%            ?PRINT("15306 Errcode~p~n",[Errcode]),
            {ok, BinData} = pt_153:write(15306, [Errcode]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end;

% 购买
handle(15307, PlayerStatus, [Type,Id,Price]) ->
    ?PRINT("15307 ===================~w~n",[[Type,Id,Price]]),
    #player_status{id=RoleId} = PlayerStatus,
    case lib_mystery_shop:role_buy_shop(PlayerStatus,Type,Id,Price) of
        {true,NewPS} -> {ok,NewPS};
        {false, Errcode} ->
            ?PRINT("15307 ~w~n",[[Errcode,Id,0]]),
            {ok, BinData} = pt_153:write(15307, [Errcode,Id,0]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end;


handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.
