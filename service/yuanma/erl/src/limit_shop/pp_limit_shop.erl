%%%--------------------------------------
%%% @Module  : pp_limit_shop
%%% @Author  : huyihao
%%% @Created : 2018.04.08
%%% @Description:  神秘限购
%%%--------------------------------------
-module(pp_limit_shop).

-export([handle/3]).

-include("server.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("limit_shop.hrl").

handle(17600, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        limit_shop = LimitShopStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    % OpenLv = lib_module:get_open_lv(?MOD_LIMIT_SHOP, 1),
    OpenLv = lib_limit_shop:get_open_lv_from_cfg(),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            SendList = [];
        true ->
            case LimitShopStatus of
                #limit_shop_status{sell_list = SellList} ->
                    NowTime = utime:unixtime(),
                    F = fun(SellInfo, SendList1) ->
                        #limit_shop_sell{
                            sell_id = SellId,
                            start_time = StartTime,
                            buy_num = BuyNum
                        } = SellInfo,
                        SellCon = data_limit_shop:get_ls_sell_con_info(SellId),
                        case SellCon of
                            #limit_shop_sell_con{ limit_time = LimitTime, limit_num = LimitNum}->
                                CostTime = NowTime-StartTime,
                                case BuyNum < LimitNum andalso CostTime < LimitTime of
                                    true ->
                                        LessNum = max(0, (LimitNum-BuyNum)),
                                        [{SellId, StartTime, LessNum}|SendList1];
                                    false ->
                                        SendList1
                                end;
                            _ ->
                                SendList1
                        end
                    end,
                    SendList = lists:foldl(F, [], SellList),
                    case SendList of
                        [] ->
                            Code = ?FAIL;
                        _ ->
                            Code = ?SUCCESS
                    end;
                _ ->
                    SendList = [],
                    Code = ?FAIL
            end     
    end,
    {ok, Bin} = pt_176:write(17600, [Code, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin);

handle(17601, Ps, [SellId, BuyNum]) ->
    % ?MYLOG("xlh", "SellId:~p,BuyNum:~p~n",[SellId,BuyNum]),
    % ?PRINT("SellId:~p,BuyNum:~p~n",[SellId,BuyNum]),
    #player_status{
        id = RoleId,
        figure = Figure,
        limit_shop = LimitShopStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    % OpenLv = lib_module:get_open_lv(?MOD_LIMIT_SHOP, 1),
    OpenLv = lib_limit_shop:get_open_lv_from_cfg(),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            NewPs = Ps;
        true ->
            #limit_shop_status{
                sell_list = SellList
            } = LimitShopStatus,
            case lists:keyfind(SellId, #limit_shop_sell.sell_id, SellList) of
                false ->
                    Code = ?ERRCODE(err176_not_sell),
                    NewPs = Ps;
                SellInfo ->
                    #limit_shop_sell{
                        start_time = StartTime,
                        buy_num = NowBuyNum
                    } = SellInfo,
                    SellCon = data_limit_shop:get_ls_sell_con_info(SellId),
                    case SellCon of
                        #limit_shop_sell_con{limit_time = LimitTime,limit_num = LimitNum,
                            discount = Discount,cost_list = CostList1,goods_list = GoodsList1}->
                        CostTime = utime:unixtime()-StartTime,
                        if
                            NowBuyNum >= LimitNum ->
                                Code = ?ERRCODE(err176_out_num_all),
                                NewPs = Ps;
                            NowBuyNum + BuyNum > LimitNum ->
                                Code = ?ERRCODE(err176_out_num),
                                NewPs = Ps;
                            CostTime >= LimitTime ->
                                Code = ?ERRCODE(err176_out_time),
                                NewPs = Ps;
                            true ->
                                [{GoodsType, GoodsTypeId, GoodsNum}|_] = GoodsList1,
                                NewGoodsNum = GoodsNum*BuyNum,
                                GoodsList = [{GoodsType, GoodsTypeId, NewGoodsNum}],
                                case lib_goods_api:can_give_goods(Ps, GoodsList) of
                                    true ->
                                        [{CostType, CostId, CostNum}|_] = CostList1,
                                        % ?PRINT("CostList1:~p~n",[CostList1]),
                                        % NewCostNum = round(CostNum*BuyNum*Discount/100), %% TODO 策划说折扣只是给客户端显示用的~~
                                        NewCostNum = round(CostNum*BuyNum),
                                        CostList = [{CostType, CostId, NewCostNum}],
                                        case lib_goods_api:cost_object_list_with_check(Ps, CostList, limit_shop_buy, "") of
                                            {true, NewPs1} ->
                                                Code = ?SUCCESS,
                                                NewPs2 = lib_goods_api:send_reward(NewPs1, GoodsList, limit_shop_buy, 0),
                                                NewBuyNum = NowBuyNum + BuyNum,
                                                NewSellInfo = SellInfo#limit_shop_sell{
                                                    buy_num = NewBuyNum
                                                },
                                                SqlInfo = io_lib:format("(~p, ~p, ~p, ~p)", [RoleId, SellId, StartTime, NewBuyNum]),
                                                ReSql = io_lib:format(?ReplaceLimitShopSellAllSql, [SqlInfo]),
                                                db:execute(ReSql),
                                                NewSellList = lists:keyreplace(SellId, #limit_shop_sell.sell_id, SellList, NewSellInfo),
                                                NewLimitShopStatus = LimitShopStatus#limit_shop_status{
                                                    sell_list = NewSellList
                                                },
                                                NewPs3 = NewPs2#player_status{
                                                    limit_shop = NewLimitShopStatus
                                                },
                                                NewPs = lib_limit_shop:set_limit_shop_close_timer(NewPs3),
                                                SCostList = util:term_to_string(CostList),
                                                SGoodsList = util:term_to_string(GoodsList),
                                                lib_log_api:log_limit_shop_buy(RoleId, SellId, BuyNum, SCostList, SGoodsList, Discount, StartTime);
                                            {false, Code, NewPs} ->
                                                skip
                                        end;
                                    {false, ErrorCode} ->
                                        Code = ErrorCode,
                                        NewPs = Ps
                                end
                        end;
                    _ ->
                        Code = ?ERRCODE(err176_out_time),
                        NewPs = Ps
                end  
            end
    end,
    % ?PRINT("Code:~p,SellId:~p~n",[Code, SellId]),
    {ok, Bin} = pt_176:write(17601, [Code, SellId, BuyNum]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

handle(_Code, Ps, []) ->
    ?PRINT("ERR : ~p~n", [[?MODULE, _Code]]),
    {ok, Ps}.