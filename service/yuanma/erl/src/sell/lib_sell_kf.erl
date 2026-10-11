%% ---------------------------------------------------------------------------
%% @doc 交易
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------
-module (lib_sell_kf).
-include ("common.hrl").
-include ("rec_sell.hrl").
-include ("server.hrl").
-include ("figure.hrl").
-include ("predefine.hrl").
-include ("goods.hrl").
-include ("def_fun.hrl").
-include ("def_module.hrl").
-include ("errcode.hrl").
-include("clusters.hrl").

-export([
    sell_up/4
    , sell_up/5
    , sell_down/5
    , pay_sell/7
    , count_on_sell_num/1
    , count_goods_num/1
    , is_expired/1
    , is_expired/2
    , get_expired_time/1
    , get_record_expired_time/0
    , seek_goods/4
    , sell_seek_goods/5
    , send_role_sell_times/3
    , send_role_sell_times/1
    , get_daily_get_gold_max/1
    , gm_restore_sell_equip_info/0
    , send_TV/2
    ]).

sell_up(PS, GoodsId, GoodsNum, UnitPrice) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_sell_check:sell_up(?SELL_TYPE_MARKET, PS, GoodsStatus, GoodsId, GoodsNum, UnitPrice, 0) of
        {ok, GoodsInfo} ->
            do_sell_up(PS, GoodsStatus, ?SELL_TYPE_MARKET, GoodsInfo, GoodsNum, UnitPrice, 0);
        {fail, Res} ->
            {fail, Res, PS}
    end.

%% 指定玩家出售
sell_up(PS, GoodsId, GoodsNum, UnitPrice, SpecifyId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_sell_check:sell_up(?SELL_TYPE_P2P, PS, GoodsStatus, GoodsId, GoodsNum, UnitPrice, SpecifyId) of
        {ok, GoodsInfo} ->
            do_sell_up(PS, GoodsStatus, ?SELL_TYPE_P2P, GoodsInfo, GoodsNum, UnitPrice, SpecifyId);
        {fail, Res} ->
            {fail, Res, PS}
    end.

do_sell_up(PS, GoodsStatus, SellType, GoodsInfo, GoodsNum, UnitPrice, SpecifyId) ->
    #player_status{id = PlayerId} = PS,
    #goods{id = GoodsId, goods_id = GTypeId, other = GoodsOther} = GoodsInfo,
    #ets_goods_type{sell_category = SellCategory, sell_subcategory = SellSubCategory} = data_goods_type:get(GTypeId),
    SellArgs = [0, PlayerId, SellType, SpecifyId, GTypeId, SellCategory, SellSubCategory, GoodsNum, UnitPrice, GoodsOther, 0],
    SellGoods = lib_sell_mod:make_record(sell_goods, SellArgs),
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        {ok, NewStatus} = lib_goods:delete_goods_list(GoodsStatus, [{GoodsInfo, GoodsNum}]),
        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
        NewStatus2 = NewStatus#goods_status{dict = Dict},
        lib_log_api:log_throw(sell_up, PlayerId, GoodsId, GTypeId, GoodsNum, 0, 0),
        {ok, NewStatus2, GoodsL}
    end,
    case lib_goods_util:transaction(F) of
        {ok, NewStatus, UpdateGoodsList} ->
            lib_goods_do:set_goods_status(NewStatus),
            lib_goods_api:notify_client_num(PlayerId, UpdateGoodsList),
            lib_task_api:handle_task_goods_reduce(PS, [{GTypeId, GoodsNum}]),
            do_sell_up_core(PS, SellGoods);
        Error ->
            ?ERR("sell_up error:~p", [Error]),
            {fail, ?FAIL, PS}
    end.

do_sell_up_core(PS, SellGoods) ->
    #sell_goods{gtype_id = GTypeId, goods_num = GoodsNum, other = GoodsOther} = SellGoods,
    #goods_other{extra_attr = ExtraAttr} = GoodsOther,
    case ExtraAttr == [] of
        true -> AttrArgs = [];
        false -> AttrArgs = [{extra_attr, ExtraAttr}]
    end,
    GoodsList = [{?TYPE_ATTR_GOODS, GTypeId, GoodsNum, AttrArgs}],
    IsKfOpen = mod_global_counter:get_count(?MOD_SELL, 1),  %% 大于1则是开启了跨服市场
    if
        IsKfOpen >= 1 ->
%%            mod_kf_sell:sell_up(SellGoods)
            KfSellGoods = lib_sell_mod_kf:make_record(sell_goods,[
                SellGoods#sell_goods.id,
                config:get_server_id(),
                config:get_server_num(),
                SellGoods#sell_goods.player_id,
                SellGoods#sell_goods.sell_type,
                0,
                SellGoods#sell_goods.specify_id,
                SellGoods#sell_goods.gtype_id,
                SellGoods#sell_goods.category,
                SellGoods#sell_goods.sub_category,
                SellGoods#sell_goods.goods_num,
                SellGoods#sell_goods.unit_price,
                SellGoods#sell_goods.other,
                SellGoods#sell_goods.time
            ]),
            case catch mod_clusters_node:apply_call(mod_kf_sell, sell_up, [KfSellGoods]) of
                Res when Res == 1 ->
                    {ok, ?SUCCESS, PS};
                Error ->
                    ?ERR("sell_up error:~p", [Error]),
                    NewPS = lib_goods_api:send_reward(PS, GoodsList, sell_up_hedge, 0),
                    {fail, ?ERRCODE(system_busy), NewPS}
            end;
        true ->
            case catch mod_sell:sell_up(SellGoods) of
                Res when Res == 1 ->
                    {ok, ?SUCCESS, PS};
                Error ->
                    ?ERR("sell_up error:~p", [Error]),
                    NewPS = lib_goods_api:send_reward(PS, GoodsList, sell_up_hedge, 0),
                    {fail, ?ERRCODE(system_busy), NewPS}
            end
    end.
    

%% 商品下架
sell_down(PS, SellType, Id, GTypeId, GoodsNum) ->
    case lib_sell_check:sell_down(GTypeId, GoodsNum) of
        ok ->
            do_sell_down(PS, SellType, Id, GTypeId, GoodsNum);
        {fail, Res} ->
            {fail, Res}
    end.

do_sell_down(PS, SellType, Id, GTypeId, GoodsNum) ->
    #player_status{id = PlayerId} = PS,
    case catch mod_sell:sell_down(PlayerId, SellType, Id, GTypeId, GoodsNum) of
        {ok, SellGoods} ->
            #sell_goods_kf{other = #goods_other{extra_attr = ExtraAttr}} = SellGoods,
            case ExtraAttr == [] of
                true -> AttrArgs = [];
                false -> AttrArgs = [{extra_attr, ExtraAttr}]
            end,
            NewPS = lib_goods_api:send_reward(PS, [{?TYPE_ATTR_GOODS, GTypeId, GoodsNum, AttrArgs}], sell_down, 0),
            {ok, ?SUCCESS, NewPS};
        Res when is_integer(Res) -> {fail, Res};
        R ->
            ?ERR("sell_down error:~p", [R]),
            {fail, ?ERRCODE(system_busy)}
    end.

%% 购买商品
pay_sell(PS, SellType, Id, SellerId, GTypeId, GoodsNum, UnitPrice) ->
    case lib_sell_check:pay_sell(PS, SellerId, GTypeId, GoodsNum, UnitPrice) of
        {ok, RemainTimes} ->
            do_pay_sell(PS, SellType, Id, SellerId, GTypeId, GoodsNum, UnitPrice, RemainTimes);
        {fail, Res} -> {fail, Res}
    end.

do_pay_sell(PS, SellType, Id, SellerId, GTypeId, GoodsNum, UnitPrice, RemainTimes) ->
    #player_status{id = PlayerId} = PS,
    case catch mod_sell:pay_sell(PlayerId, SellType, Id, SellerId, GTypeId, GoodsNum, UnitPrice) of
        {ok, SellGoods, Tax} ->
            #sell_goods{other = #goods_other{extra_attr = ExtraAttr}} = SellGoods,
            NewPS = lib_goods_util:cost_money(PS, max(0, UnitPrice - Tax), ?GOLD, pay_sell, ""),
            case Tax > 0 of
                true ->
                    LastPS = lib_goods_util:cost_money(NewPS, Tax, ?GOLD, pay_tax, "");
                _ ->
                    LastPS = NewPS
            end,
            case ExtraAttr == [] of
                true -> Reward = [{?TYPE_GOODS, GTypeId, GoodsNum}]; 
                false -> Reward = [{?TYPE_ATTR_GOODS, GTypeId, GoodsNum, [{extra_attr, ExtraAttr}]}]
            end,
            case data_goods_type:get(GTypeId) of
                #ets_goods_type{goods_name = GoodsName, color = Color} -> skip;
                _ -> GoodsName = "???", Color = ?GREEN
            end,
            Title   = utext:get(6),
            Content = utext:get(7, [UnitPrice, Color, GoodsName, GoodsNum]),
            lib_mail_api:send_sys_mail([PlayerId], Title, Content, Reward),  
            %% 买家每日消耗累积
            mod_daily:plus_count_offline(PlayerId, ?MOD_SELL, 3, UnitPrice),
            %% 出售者成就 
            lib_achievement_api:sell_sell_event(SellerId, round(UnitPrice-Tax)),
            % lib_achievement_api:async_event(SellerId, lib_achievement_api, sell_sell_event, round(UnitPrice-Tax)), 
            %% 购买者成就  
            lib_achievement_api:sell_cost_event(PlayerId, UnitPrice),
            % lib_achievement_api:async_event(PlayerId, lib_achievement_api, sell_cost_event, UnitPrice),   
            {ok, SellGoods, LastPS, max(0, RemainTimes - 1)};
        Res when is_integer(Res) -> {fail, Res};
        Error ->
            ?ERR("pay_sell error:~p", [Error]),
            {fail, ?ERRCODE(system_busy)}
    end.

%% 求购商品
seek_goods(PS, GTypeId, GoodsNum, UnitPrice) ->
    case lib_sell_check:seek_goods(PS, GTypeId, GoodsNum, UnitPrice) of
        ok ->
            do_seek_goods(PS, GTypeId, GoodsNum, UnitPrice);
        {fail, Res} ->
            {fail, Res}
    end.

do_seek_goods(PS, GTypeId, GoodsNum, UnitPrice) ->
    #player_status{id = PlayerId, figure = #figure{name = RoleName}} = PS,
    #ets_goods_type{sell_category = SellCategory, sell_subcategory = SellSubCategory} = data_goods_type:get(GTypeId),
    SeekArgs = [0, PlayerId, RoleName, GTypeId, SellCategory, SellSubCategory, GoodsNum, UnitPrice, 0],
    SeekGoods = lib_sell_mod:make_record(seek_goods, SeekArgs),
    Price = UnitPrice,
    MoneyCost = [{?TYPE_GOLD, 0, round(Price)}],
    case lib_goods_api:cost_object_list_with_check(PS, MoneyCost, seek_goods, "") of 
        {true, PS1} ->
            case catch mod_sell:seek_goods(SeekGoods) of 
                {ok, NewSeekGoods} ->
                    lib_chat:send_TV({all}, ?MOD_SELL, 2, [RoleName, Price, GoodsNum, GTypeId]),
                    {ok, ?SUCCESS, NewSeekGoods, PS1};
                _Err ->
                    ?ERR("seek_goods error:~p", [_Err]),
                    NPS = lib_goods_api:send_reward(PS1, MoneyCost, seek_goods_fail, 0),
                    {ok, ?ERRCODE(system_busy), SeekGoods, NPS}
            end;
        {false, Res, _} -> {fail, Res}
    end.
   
sell_seek_goods(PS, Id, BuyerId, GTypeId, GoodsNum) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_sell_check:sell_seek_goods(PS, GoodsStatus, BuyerId, GTypeId, GoodsNum, 0) of
        {ok, CostGoodsInfoList, ExtraAttr, Rating} ->
            do_sell_seek_goods(PS, GoodsStatus, Id, BuyerId, GTypeId, GoodsNum, CostGoodsInfoList, ExtraAttr, Rating);
        {fail, Res} ->
            {fail, Res}
    end.

do_sell_seek_goods(PS, GoodsStatus, Id, BuyerId, GTypeId, GoodsNum, CostGoodsInfoList, ExtraAttr, Rating) ->
    #player_status{id = PlayerId, figure = #figure{vip = VipLv, vip_type = VipType}} = PS,
    case catch mod_sell:sell_seek_goods(PlayerId, VipType, VipLv, Id, BuyerId, GTypeId, GoodsNum, ExtraAttr, Rating) of
        {ok, MoneyReturn, Tax, RemainNum} ->
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                {ok, NewStatus} = lib_goods:delete_goods_list(GoodsStatus, CostGoodsInfoList),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
                NewStatus2 = NewStatus#goods_status{dict = Dict},
                [ 
                    lib_log_api:log_throw(sell_seek_goods, PlayerId, GoodsInfo#goods.id, GTypeId, Num, 0, 0) 
                    || {GoodsInfo, Num} <- CostGoodsInfoList
                ],
                {ok, NewStatus2, GoodsL}
            end,
            case lib_goods_util:transaction(F) of
                {ok, NewStatus, UpdateGoodsList} ->
                    lib_goods_do:set_goods_status(NewStatus),
                    lib_goods_api:notify_client_num(PlayerId, UpdateGoodsList),
                    MoneyGot = max(0, MoneyReturn - Tax),
                    MoneyReward = [{?TYPE_GOLD, 0, MoneyGot}],
                    %% 邮件
                    case data_goods_type:get(GTypeId) of
                        #ets_goods_type{goods_name = GoodsName, color = Color} -> skip;
                        _ -> GoodsName = "???", Color = ?GREEN
                    end,
                    Title = utext:get(1510005),
                    Content = utext:get(1510006, [Color, util:make_sure_binary(GoodsName), GoodsNum, Tax, MoneyGot]),
                    lib_mail_api:send_sys_mail([PlayerId], Title, Content, MoneyReward),
                    %% 出售者增加出售金额
                    mod_daily:plus_count_offline(PlayerId, ?MOD_SELL, 2, MoneyGot),
                    %% 出售者成就 
                    lib_achievement_api:sell_sell_event(PlayerId, MoneyGot),
                    % lib_achievement_api:async_event(PlayerId, lib_achievement_api, sell_sell_event, MoneyGot), 
                    %% 购买者成就 
                    lib_achievement_api:sell_cost_event(BuyerId, MoneyReturn), 
                    % lib_achievement_api:async_event(BuyerId, lib_achievement_api, sell_cost_event, MoneyReturn), 
                    {ok, RemainNum, PS};
                Error ->
                    ?ERR("sell_up error:~p", [Error]),
                    {fail, ?FAIL}
            end;
        {fail, Res} ->
            {fail, Res};
        _Err ->
           ?ERR("sell_seek_goods error:~p", [_Err]), 
           {fail, ?ERRCODE(system_busy)}
    end.

%% 统计正在出售的商品个数
count_on_sell_num(L) ->
    do_count_on_sell_num(L, 0, utime:unixtime()).

do_count_on_sell_num([], Num, _NowTime) -> Num;
do_count_on_sell_num([T|L], Num, NowTime) ->
    case is_expired(T, NowTime) of
        false ->
            do_count_on_sell_num(L, Num + 1, NowTime);
        true ->
            do_count_on_sell_num(L, Num, NowTime)
    end.

%% 统计列表中物品的总数量
count_goods_num(L) ->
    do_count_goods_num(L, 0, utime:unixtime()).

do_count_goods_num([], Num, _NowTime) -> Num;
do_count_goods_num([T|L], Num, NowTime) ->
    case is_expired(T, NowTime) of
        false ->
            do_count_goods_num(L, Num + T#sell_goods_kf.goods_num, NowTime);
        true ->
            do_count_goods_num(L, Num, NowTime)
    end.


send_role_sell_times(PlayerId) ->
    #figure{vip_type = VipType, vip = VipLv} = lib_role:get_role_figure(PlayerId),
    send_role_sell_times(PlayerId, VipType, VipLv).
send_role_sell_times(PlayerId, VipType, VipLv) ->
    SellTimes = mod_daily:get_count_offline(PlayerId, ?MOD_SELL, 1),
    SellLimit = data_sell:get_cfg(transaction_times_limit) + lib_vip_api:get_vip_privilege(?MOD_SELL, 2, VipType, VipLv),
    ?PRINT("send_role_sell_times ~p~n", [{SellTimes, SellLimit}]),
    {ok, Bin} = pt_151:write(15114, [[{1, SellTimes, SellLimit}]]),
    lib_server_send:send_to_uid(PlayerId, Bin).

%% 商品是否已经过期
is_expired(SellGoods) ->
    NowTime = utime:unixtime(),
    is_expired(SellGoods, NowTime).

is_expired(SellGoods, NowTime) when is_record(SellGoods, sell_goods_kf) ->
    #sell_goods_kf{sell_type = SellType, time = SellTime} = SellGoods,
    ExpiredTime = get_expired_time(SellType),
    NowTime - SellTime >= ExpiredTime;
is_expired(SeekGoods, NowTime) when is_record(SeekGoods, seek_goods_kf) ->
    #seek_goods_kf{time = SeekTime} = SeekGoods,
    ExpiredTime = get_expired_time(?SELL_TYPE_SEEK),
    NowTime - SeekTime >= ExpiredTime;
is_expired(_, _) -> true.

get_expired_time(SellType) ->
    ExpiredTime = case SellType of
        ?SELL_TYPE_MARKET -> data_sell:get_cfg(sell_expired_time_market);
        ?SELL_TYPE_SEEK -> data_sell:get_cfg(seek_expired_time_market);
        _ -> data_sell:get_cfg(sell_expired_time_p2p)
    end,
    MinExpiredTime = 10 * 60,
    case is_integer(ExpiredTime) of
        true ->
            max(ExpiredTime, MinExpiredTime);
        false ->
            MinExpiredTime
    end.

get_record_expired_time() ->
    ExpiredTime = data_sell:get_cfg(sell_record_expired_time),
    MinExpiredTime = 5 * 60,
    case is_integer(ExpiredTime) of
        true ->
            max(ExpiredTime, MinExpiredTime);
        false ->
            MinExpiredTime
    end.

gm_restore_sell_equip_info() ->
    mod_sell:lock_refresh(true),
    Sql1 = io_lib:format(<<"select id, gtype_id, category, sub_category from `sell_list` where category = ~p">>, [1]),
    Sql2 = io_lib:format(<<"select id, gtype_id, category, sub_category from `seek_list` where category = ~p">>, [1]),
    case db:get_all(Sql1) of 
        [] -> ok;
        List1 ->
            F = fun([Id, GTypeId, Category, SubCategory]) ->
                case data_goods_type:get(GTypeId) of 
                    #ets_goods_type{sell_category = CategoryCon, sell_subcategory = SubCategoryCon} ->
                        case Category == CategoryCon andalso SubCategory == SubCategoryCon of 
                            true -> ?PRINT("sell Id :~p, same ~n", [Id]),skip;
                            _ -> 
                                ?PRINT("sell Id :~p, Category:~p, SubCategory:~p ~n", [Id, {Category, CategoryCon}, {SubCategory, SubCategoryCon}]),
                                SqlUp = usql:update(sell_list, [{category, CategoryCon}, {sub_category, SubCategoryCon}], [{id, Id}]),
                                db:execute(SqlUp)
                        end;
                    _ -> skip
                end
            end,
            lists:foreach(F, List1)
    end,
    case db:get_all(Sql2) of 
        [] -> ok;
        List2 ->
            F2 = fun([Id, GTypeId, Category, SubCategory]) ->
                case data_goods_type:get(GTypeId) of 
                    #ets_goods_type{sell_category = CategoryCon, sell_subcategory = SubCategoryCon} ->
                        case Category == CategoryCon andalso SubCategory == SubCategoryCon of 
                            true -> skip;
                            _ -> 
                                ?PRINT("seek Id :~p, Category:~p, SubCategory:~p ~n", [Id, {Category, CategoryCon}, {SubCategory, SubCategoryCon}]),
                                SqlUp = usql:update(seek_list, [{category, CategoryCon}, {sub_category, SubCategoryCon}], [{id, Id}]),
                                db:execute(SqlUp)
                        end;
                    _ -> skip
                end
            end,
            lists:foreach(F2, List2)
    end,
    mod_sell:reload(),
    ok.

get_daily_get_gold_max(RoleLv) ->
    LevelGoldsList = data_sell:get_cfg(sell_gold_max),
    get_daily_get_gold_max(lists:reverse(lists:keysort(1, LevelGoldsList)), RoleLv).

get_daily_get_gold_max([], _RoleLv) -> 99999999;
get_daily_get_gold_max([{LevelUpper, GoldLimit}|LevelGoldsList], RoleLv) ->
    case RoleLv >= LevelUpper of 
        true -> GoldLimit;
        _ -> get_daily_get_gold_max(LevelGoldsList, RoleLv)
    end.

% get_sell_goods_price(GTypeId, GoodsNum, UnitPrice) ->
%     IsCustomPriceGoods = data_goods:is_custom_price_goods(GTypeId),
%     Price = ?IF(IsCustomPriceGoods == true, UnitPrice, GoodsNum * UnitPrice),
%     Price.


send_TV(ServerId, [_ServerNum, RoleName, Price, GoodsNum, GTypeId]) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    ServerList = mod_zone_mgr:get_all_zone(),
    [mod_clusters_center:apply_cast(ServerTemp, lib_chat, send_TV, [{all}, ?MOD_SELL, 2, [RoleName, Price, GoodsNum, GTypeId]]) || #zone_base{server_id = ServerTemp, zone = ZoneIdTemp}<-ServerList, ZoneId == ZoneIdTemp].

