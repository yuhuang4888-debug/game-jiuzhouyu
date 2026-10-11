%%-----------------------------------------------------------------------------
%% @Module:  lib_limit_shop
%%% @Author: huyihao
%%% @Created: 2018.04.08
%%% @Description:  神秘限购
%%%--------------------------------------
-module(lib_limit_shop).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("common_rank.hrl").
-include("attr.hrl").
-include("limit_shop.hrl").

-export([
    handle_event/2,
    set_limit_shop_close_timer/1,
    limit_shop_close/1,
    gm_reset/1,
    get_open_lv_from_cfg/0
    ,gm_reset_not_buy/1
    ,gm_reset_not_buy/2
    ,gm_reset_not_buy_core/1
]).

%% 登录
handle_event(Ps, #event_callback{type_id = ?EVENT_LOGIN_CAST}) when is_record(Ps, player_status) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        limit_shop = LimitShopStatus1
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    %% 区分离线登录和挂机登录
    case is_record(LimitShopStatus1, limit_shop_status) of
        false ->
            ReSql1 = io_lib:format(?SelectLimitShopSellSql, [RoleId]),
            case db:get_all(ReSql1) of
                [] ->
                    SellList1 = [];
                SellSqlList ->
                    SellList1 = [begin
                        [_RoleId1, SellId1, StartTime1, BuyNum1] = SellSqlInfo,
                        #limit_shop_sell{
                            sell_id = SellId1,
                            start_time = StartTime1,
                            buy_num = BuyNum1
                        }
                    end||SellSqlInfo <- SellSqlList]
            end,
            LimitShopStatus = #limit_shop_status{
                role_id = RoleId,
                sell_list = SellList1
            };
        true ->
            LimitShopStatus = LimitShopStatus1
    end,
    NewLimitShopStatus = get_new_sell_list(LimitShopStatus, RoleId, Lv),
    NewPs1 = Ps#player_status{
        limit_shop = NewLimitShopStatus
    },
    NewPs = set_limit_shop_close_timer(NewPs1),
    {ok, NewPs};

%% 升级
handle_event(Ps, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Ps, player_status) ->
    #player_status{
        id = RoleId,
        online = Online,
        figure = Figure,
        limit_shop = LimitShopStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    case Online of
        1 ->
            SellLvList = data_limit_shop:get_ls_sell_lv_list(),
            case lists:member(Lv, SellLvList) of
                false ->
                    NewPs = Ps;
                true ->
                    NewLimitShopStatus = get_new_sell_list(LimitShopStatus, RoleId, Lv),
                    NewPs1 = Ps#player_status{
                        limit_shop = NewLimitShopStatus
                    },
                    NewPs = set_limit_shop_close_timer(NewPs1),
                    SellIdList = data_limit_shop:get_ls_sell_id(Lv),
                    {ok, Bin} = pt_176:write(17602, [SellIdList]),
                    pp_limit_shop:handle(17600, NewPs, []),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end;
        _ ->
            NewPs = Ps
    end,
    {ok, NewPs};

handle_event(Ps, _EventCallback) ->
    {ok, Ps}.

get_new_sell_list(LimitShopStatus, RoleId, Lv) ->
    #limit_shop_status{
        sell_list = SellList
    } = LimitShopStatus,
    SellLvList1 = data_limit_shop:get_ls_sell_lv_list(),
    SellLvList = lists:sort(SellLvList1),
    NowTime = utime:unixtime(),
    %% 登录时激活可开放购买的商品（配置新增或离线挂机期间升级）
    F = fun(SellLv, {NewSellList1, SqlList1}) ->
        case Lv >= SellLv of
            false ->
                {NewSellList1, SqlList1};
            true ->
                SellConIdList = data_limit_shop:get_ls_sell_id(SellLv),
                F1 = fun(SellConId, {NewSellList2, SqlList2}) ->
                    case lists:keyfind(SellConId, #limit_shop_sell.sell_id, NewSellList2) of
                        false ->
                            LimitShopSellInfo = #limit_shop_sell{
                                sell_id = SellConId,
                                start_time = NowTime
                            },
                            SqlInfo = io_lib:format("(~p, ~p, ~p, ~p)", [RoleId, SellConId, NowTime, 0]),
                            {[LimitShopSellInfo|NewSellList2], [SqlInfo|SqlList2]};
                        _ ->
                            {NewSellList2, SqlList2}
                    end
                end,
                lists:foldl(F1, {NewSellList1, SqlList1}, SellConIdList)
        end
    end,
    {NewSellList, SqlList} = lists:foldl(F, {SellList, []}, SellLvList),
    case SqlList of
        [] ->
            skip;
        _ ->
            SqlStrListStr = ulists:list_to_string(SqlList, ","),
            ReSql = io_lib:format(?ReplaceLimitShopSellAllSql, [SqlStrListStr]),
            db:execute(ReSql)
    end,
    NewLimitShopStatus = LimitShopStatus#limit_shop_status{
        sell_list = NewSellList
    },
    NewLimitShopStatus.

set_limit_shop_close_timer(Ps) ->
    #player_status{
        limit_shop = LimitShopStatus
    } = Ps,
    #limit_shop_status{
        sell_list = SellList,
        close_timer = OldCloseTimer
    } = LimitShopStatus,
    util:cancel_timer(OldCloseTimer),
    NowTime = utime:unixtime(),
    F = fun(SellInfo, EndTime1) ->
        #limit_shop_sell{
            sell_id = SellId,
            start_time = StartTime,
            buy_num = BuyNum
        } = SellInfo,
        SellCon = data_limit_shop:get_ls_sell_con_info(SellId),
        case SellCon of
            #limit_shop_sell_con{limit_time = LimitTime,limit_num = LimitNum} ->
                CostTime = NowTime-StartTime,
                case BuyNum < LimitNum andalso CostTime < LimitTime of
                    true ->
                        case (LimitTime-CostTime) > EndTime1 of
                            true ->
                                LimitTime-CostTime;
                            false ->
                                EndTime1
                        end;
                    false ->
                        EndTime1
                end;
            _ ->
                EndTime1
        end
    end,
    EndTime = lists:foldl(F, 0, SellList),
    case EndTime of
        0 ->
            NewCloseTimer = 0;
        _ ->
            NewCloseTimer = erlang:send_after(EndTime*1000, self(), {'mod', lib_limit_shop, limit_shop_close, []})
    end,
    NewLimitShopStatus = LimitShopStatus#limit_shop_status{
        close_timer = NewCloseTimer
    },
    NewPs = Ps#player_status{
        limit_shop = NewLimitShopStatus
    },
    NewPs.

limit_shop_close(Ps) ->
    #player_status{
        limit_shop = LimitShopStatus
    } = Ps,
    #limit_shop_status{
        close_timer = OldCloseTimer
    } = LimitShopStatus,
    util:cancel_timer(OldCloseTimer),
    NewLimitShopStatus = LimitShopStatus#limit_shop_status{
        close_timer = 0
    },
    NewPs = Ps#player_status{
        limit_shop = NewLimitShopStatus
    },
    pp_limit_shop:handle(17600, NewPs, []),
    NewPs.

gm_reset(Ps) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        limit_shop = LimitShopStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    db:execute(io_lib:format(?DeleteLimitShopSellSql, [RoleId])),
    SellLvList1 = data_limit_shop:get_ls_sell_lv_list(),
    SellLvList = lists:sort(SellLvList1),
    NowTime = utime:unixtime(),
    %% 登录时激活可开放购买的商品（配置新增或离线挂机期间升级）
    F = fun(SellLv, {NewSellList1, SqlList1}) ->
        case Lv >= SellLv of
            false ->
                {NewSellList1, SqlList1};
            true ->
                SellConIdList = data_limit_shop:get_ls_sell_id(SellLv),
                F1 = fun(SellConId, {NewSellList2, SqlList2}) ->
                    case lists:keyfind(SellConId, #limit_shop_sell.sell_id, NewSellList2) of
                        false ->
                            LimitShopSellInfo = #limit_shop_sell{
                                sell_id = SellConId,
                                start_time = NowTime
                            },
                            SqlInfo = io_lib:format("(~p, ~p, ~p, ~p)", [RoleId, SellConId, NowTime, 0]),
                            {[LimitShopSellInfo|NewSellList2], [SqlInfo|SqlList2]};
                        _ ->
                            {NewSellList2, SqlList2}
                    end
                end,
                lists:foldl(F1, {NewSellList1, SqlList1}, SellConIdList)
        end
    end,
    {NewSellList, SqlList} = lists:foldl(F, {[], []}, SellLvList),
    case SqlList of
        [] ->
            skip;
        _ ->
            SqlStrListStr = ulists:list_to_string(SqlList, ","),
            ReSql = io_lib:format(?ReplaceLimitShopSellAllSql, [SqlStrListStr]),
            db:execute(ReSql)
    end,
    NewLimitShopStatus = LimitShopStatus#limit_shop_status{
        sell_list = NewSellList
    },
    NewPs1 = Ps#player_status{
        limit_shop = NewLimitShopStatus
    },
    NewPs = set_limit_shop_close_timer(NewPs1),
    pp_limit_shop:handle(17600, NewPs, []),
    NewPs.

get_open_lv_from_cfg() ->
    AllLvList = data_limit_shop:get_ls_sell_lv_list(),
    NewList = lists:sort(AllLvList),
    case NewList of
        [MinLv|_] ->skip;
        _ ->
            ?ERR("WRONG CFG! AllLvList:~p~n",[AllLvList]), 
            MinLv = 1
    end,
    MinLv.

gm_reset_not_buy(0, _RoleId) ->
    gm_reset_not_buy(0);
gm_reset_not_buy(_, RoleId) ->
    gm_reset_not_buy(RoleId).

gm_reset_not_buy(RoleId) when is_integer(RoleId) andalso RoleId =/= 0 ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_limit_shop, gm_reset_not_buy_core, []);
gm_reset_not_buy(_) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() -> [
        begin
            timer:sleep(1000),
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_limit_shop, gm_reset_not_buy_core, [])
        end
        || E <- OnlineRoles] end).

gm_reset_not_buy_core(Ps) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        limit_shop = LimitShopStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    case LimitShopStatus of
        #limit_shop_status{sell_list = SellList} ->
            NowTime = utime:unixtime(),
            F = fun(SellInfo, SendList1) ->
                #limit_shop_sell{
                    sell_id = SellId,
                    start_time = StartTime
                } = SellInfo,
                [{SellId, StartTime, 0}|SendList1]
            end,
            SendList = lists:foldl(F, [], SellList),
            {ok, OBin} = pt_176:write(17600, [1, SendList]),
            lib_server_send:send_to_uid(RoleId, OBin),
            Sql = io_lib:format(<<"SELECT `sell_id` FROM `log_limit_shop_buy` WHERE `role_id` = ~p">>, [RoleId]),
            List = db:get_all(Sql),
            SellIdList = [SellId || [SellId] <- List],
            ?PRINT("SellIdList:~p~n, SendList:~p~n",[SellIdList,SendList]),
            SellLvList1 = data_limit_shop:get_ls_sell_lv_list(),
            SellLvList = lists:sort(SellLvList1),
            NowTime = utime:unixtime(),
            %% 登录时激活可开放购买的商品（配置新增或离线挂机期间升级）
            F1 = fun(SellLv, {NewSellList1, SqlList1, SqlList2}) ->
                case Lv >= SellLv of
                    false ->
                        {NewSellList1, SqlList1, SqlList2};
                    true ->
                        SellConIdList = data_limit_shop:get_ls_sell_id(SellLv),
                        F2 = fun(SellConId, {NewSellList2, TemSqlList1, TemSqlList2}) ->
                            HasBuy = lists:member(SellConId, SellIdList),
                            case lists:keyfind(SellConId, #limit_shop_sell.sell_id, NewSellList2) of
                                false when HasBuy == false ->
                                    LimitShopSellInfo = #limit_shop_sell{
                                        sell_id = SellConId,
                                        start_time = NowTime
                                    },
                                    SqlInfo = [RoleId, SellConId, NowTime, 0],
                                    NewList2 = [SellConId|lists:delete(SellConId, TemSqlList2)],
                                    {[LimitShopSellInfo|NewSellList2], [SqlInfo|TemSqlList1], NewList2};
                                _ ->
                                    {NewSellList2, TemSqlList1, TemSqlList2}
                            end
                        end,
                        lists:foldl(F2, {NewSellList1, SqlList1, SqlList2}, SellConIdList)
                end
            end,
            {NewSellList, ReplaceList, DeleteList} = lists:foldl(F1, {[], [], []}, SellLvList),

            % ?PRINT("NewSellList:~p~n",[NewSellList]),

            DeleteList =/= [] andalso db:execute(
                io_lib:format(
                    list_to_binary(
                        "delete from `limit_shop_sell` " ++ usql:condition({sell_id, in, DeleteList}) ++ " and `role_id` = ~p"
                    ), 
                [RoleId])
            ),
            ReplaceList =/= [] andalso db:execute(
                    usql:replace(limit_shop_sell, [role_id, sell_id, start_time, buy_num], ReplaceList)
            ),

            NewLimitShopStatus = LimitShopStatus#limit_shop_status{
                sell_list = NewSellList
            };
        _ ->
            NewLimitShopStatus = LimitShopStatus
    end,
    NewPs1 = Ps#player_status{
        limit_shop = NewLimitShopStatus
    },
    {ok, Bin} = pt_176:write(17600, [0, []]),
    lib_server_send:send_to_uid(RoleId, Bin),
    NewPs = set_limit_shop_close_timer(NewPs1),
    pp_limit_shop:handle(17600, NewPs, []),
    {ok, NewPs}.