%% ---------------------------------------------------------------------------
%% @doc 交易
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------
-module (lib_sell_mod).

-include("common.hrl").
-include("rec_sell.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("language.hrl").
-include("def_event.hrl").
-include("def_id_create.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").

-export ([init/0, make_record/2]).

-export([
    list_category_sell_num/3
    , list_sub_category_sell_goods/7
    , filter_goods/4
    , send_sell_up_view_info/4
    , check_sell_up_goods/5
    , sell_up/3
    , sell_down/6
    , pay_sell/8
    , auto_sell_down/1
    , pack_sell_goods_list/3
    , pack_sell_record_list/3
    , daily_timer/1
    , check_seek_goods/5
    , seek_goods/2
    , delete_seek/3
    , sell_seek_goods/10
    , send_self_seek_list/3
    , send_seek_list/5
    , set_kf_status/2
    , daily_timer2/1
    , is_kf_open/1
    , market_shout/2
]).

make_record(sql_sell_goods, [Id, PlayerId, SellType, SpecifyId, GTypeId, Category, SubCategory, GoodsNum, UnitPrice, ExtraAttrStr, Time]) ->
    ExtraAttr = util:bitstring_to_term(ExtraAttrStr),
    GoodsOther = case data_goods_type:get(GTypeId) of
        GoodsTypeInfo when is_record(GoodsTypeInfo, ets_goods_type) ->
            case GoodsTypeInfo#ets_goods_type.type of 
                ?GOODS_TYPE_EQUIP ->
                    Rating = lib_equip:cal_equip_rating(GoodsTypeInfo, ExtraAttr);
                ?GOODS_TYPE_SEAL ->
                    Rating = lib_seal:cal_equip_rating(GoodsTypeInfo, ExtraAttr);
                _ ->
                    Rating = 0
            end,
            #goods_other{rating = Rating, extra_attr = ExtraAttr};
        _ -> #goods_other{}
    end,
    make_record(sell_goods, [Id, PlayerId, SellType, SpecifyId, GTypeId, Category, SubCategory, GoodsNum, UnitPrice, GoodsOther, Time]);
make_record(sell_goods, [Id, PlayerId, SellType, SpecifyId, GTypeId, Category, SubCategory, GoodsNum, UnitPrice, GoodsOther, Time]) ->
    #sell_goods{
        id              = Id,
        player_id       = PlayerId,
        sell_type       = SellType,
        specify_id      = SpecifyId,
        gtype_id        = GTypeId,
        category        = Category,
        sub_category    = SubCategory,
        goods_num       = GoodsNum,
        unit_price      = UnitPrice,
        other           = GoodsOther,
        time            = Time
    };
make_record(sql_sell_record, [PlayerId, BuyerId, SellType, GTypeId, GoodsNum, UnitPrice, Tax, ExtraAttrStr, Time]) ->
    ExtraAttr = util:bitstring_to_term(ExtraAttrStr),
    GoodsOther = case data_goods_type:get(GTypeId) of
        GoodsTypeInfo when is_record(GoodsTypeInfo, ets_goods_type) ->
            Rating = lib_equip:cal_equip_rating(GoodsTypeInfo, ExtraAttr),
            #goods_other{rating = Rating, extra_attr = ExtraAttr};
        _ -> #goods_other{}
    end,
    make_record(sell_record, [PlayerId, BuyerId, SellType, GTypeId, GoodsNum, UnitPrice, Tax, GoodsOther, Time]);
make_record(sell_record, [PlayerId, BuyerId, SellType, GTypeId, GoodsNum, UnitPrice, Tax, GoodsOther, Time]) ->
    #sell_record{
        player_id = PlayerId,
        buyer_id = BuyerId,
        sell_type = SellType,
        gtype_id = GTypeId,
        goods_num = GoodsNum,
        unit_price = UnitPrice,
        tax = Tax,
        other = GoodsOther,
        time = Time
    };
make_record(sell_price, [GTypeId, UnitPrice, Time]) ->
    #sell_price{
        gtype_id = GTypeId,
        unit_price = UnitPrice,
        time = Time
    };
make_record(seek_goods, [Id, PlayerId, RoleName, GTypeId, Category, SubCategory, GoodsNum, UnitPrice, Time]) ->
    #seek_goods{
        id              = Id,
        player_id       = PlayerId,
        role_name       = RoleName,
        gtype_id        = GTypeId,
        category        = Category,
        sub_category    = SubCategory,
        goods_num       = GoodsNum,
        unit_price      = UnitPrice,
        time            = Time
    };
make_record(_, _) -> no_match.

init() ->
    clear_time_out_record_db(),

    case util:get_merge_day() of
        1 -> %% 合服第一天重置上架时间为0，自动下架所有商品
            db:execute(io_lib:format(?sql_reset_all_sell_time, [])),
            db:execute(io_lib:format(?sql_reset_all_seek_time, []));
        _ -> skip
    end,

    SellRecordList = db:get_all(io_lib:format(?sql_sell_record_select, [])),
    SellList = db:get_all(io_lib:format(?sql_sell_select, [])),
    SeekList = db:get_all(io_lib:format(?sql_seek_select, [])),

    {MarketSellMap, P2PSellMap, PlayerSellMap, MinExpiredTime} = init_goods_sell_map(SellList, #{}, #{}, #{}, 0),
    {SeekMap, PlayerSeekMap, SeekIds, NewMinExpiredTime} = init_seek_map(SeekList, MinExpiredTime),
    {RealSellRecordList, PriceMap} = init_sell_record_list(SellRecordList, [], #{}),
    {Status, OpenTime} = get_kf_sell_open_msg(),
%%    Ref = get_kf_open_ref(Status, OpenTime),
     % ?PRINT("init ~p~n", [SeekMap]),
     % ?PRINT("init ~p~n", [SeekIds]),
     % ?PRINT("init ~p~n", [PlayerSeekMap]),
    
    State = #sell_state{
        p2p_sell_map = P2PSellMap,
        market_sell_map = MarketSellMap,
        player_market_sell_map = PlayerSellMap,
        sell_record_list = RealSellRecordList,
        sell_price_map = PriceMap,
        seek_map = SeekMap,
        player_seek_map = PlayerSeekMap,
        seek_ids = SeekIds,
        min_expire_time = NewMinExpiredTime
        ,kf_status = Status,
        kf_open_time = OpenTime
%%        open_kf_ref = Ref
    },
    case is_kf_open(State) of
        true ->
            spawn(fun() ->
                  timer:sleep(5000),
                  mod_global_counter:set_count(?MOD_SELL, 1, 1)  %% 5秒后，设置全服状态
                  end);
        _ ->
            skip
    end,
    State.

init_goods_sell_map([], MarketSellMap, P2PSellMap, PlayerSellMap, MinExpiredTime) ->
    {MarketSellMap, P2PSellMap, PlayerSellMap, MinExpiredTime};
init_goods_sell_map([T|L], MarketSellMap, P2PSellMap, PlayerSellMap, MinExpiredTime) ->
    SellGoods = make_record(sql_sell_goods, T),
    #sell_goods{player_id = PlayerId, sell_type = SellType, category = Category, sub_category = SubCategory, time = SellTime} = SellGoods,
    SellExpiredTime = ?IF(SellTime > 0, lib_sell:get_expired_time(SellType) + SellTime, 0),
    NewMinExpireTime = ?IF(MinExpiredTime == 0 orelse SellExpiredTime < MinExpiredTime, SellExpiredTime, MinExpiredTime),
    case SellType of
        ?SELL_TYPE_MARKET ->
            CategorySellMap = maps:get(Category, MarketSellMap, #{}),
            List = maps:get(SubCategory, CategorySellMap, []),
            NewCategorySellMap = maps:put(SubCategory, [SellGoods|List], CategorySellMap),
            NewMarketSellMap = maps:put(Category, NewCategorySellMap, MarketSellMap),
            PlayerSellList = maps:get(PlayerId, PlayerSellMap, []),
            NewPlayerSellMap = maps:put(PlayerId, [SellGoods|PlayerSellList], PlayerSellMap),
            init_goods_sell_map(L, NewMarketSellMap, P2PSellMap, NewPlayerSellMap, NewMinExpireTime);
        ?SELL_TYPE_P2P ->
            List = maps:get(PlayerId, P2PSellMap, []),
            NewP2PSellMap = maps:put(PlayerId, [SellGoods|List], P2PSellMap),
            init_goods_sell_map(L, MarketSellMap, NewP2PSellMap, PlayerSellMap, NewMinExpireTime);
        _ ->
            init_goods_sell_map(L, MarketSellMap, P2PSellMap, PlayerSellMap, NewMinExpireTime)
    end.

init_sell_record_list([], SellRecordList, PriceMap) ->
    %% 只保留需要计算的参考价格的有效成交价格记录
    F = fun(_GTypeId, PriceRecordList) ->
        sort_price_list(PriceRecordList, 1, ?SELL_PRICE_REFER_NUM, [])
    end,
    NewPriceMap = maps:map(F, PriceMap),
    {SellRecordList, NewPriceMap};
init_sell_record_list([T|L], SellRecordList, PriceMap) ->
    SellRecord = make_record(sql_sell_record, T),
    #sell_record{gtype_id = GTypeId, unit_price = UnitPrice, time = Time} = SellRecord,
    PriceRecord = make_record(sell_price, [GTypeId, UnitPrice, Time]),
    PriceList = maps:get(GTypeId, PriceMap, []),
    NewPriceMap = maps:put(GTypeId, [PriceRecord|PriceList], PriceMap),
    init_sell_record_list(L, [SellRecord|SellRecordList], NewPriceMap).

init_seek_map(SeekList, MinExpiredTime) ->
    F = fun([_,_,_,_,_,_,_,_,TimeA], [_,_,_,_,_,_,_,_,TimeB]) -> TimeA < TimeB end,
    SortSeekList = lists:sort(F, SeekList),
    init_seek_map_do(SortSeekList, #{}, #{}, [], MinExpiredTime).

init_seek_map_do([], SeekMap, PlayerSeekMap, SeekIds, MinExpiredTime) -> 
    {SeekMap, PlayerSeekMap, SeekIds, MinExpiredTime};
init_seek_map_do([Item|SortSeekList], SeekMap, PlayerSeekMap, SeekIds, MinExpiredTime) ->
    [Id, PlayerId, RoleName, GTypeId, Category, SubCategory, GoodsNum, UnitPrice, Time] = Item,
    SeekGoods = #seek_goods{
        id = Id, player_id = PlayerId, role_name = RoleName, category = Category, sub_category = SubCategory,
        gtype_id = GTypeId, goods_num = GoodsNum, unit_price = UnitPrice, time = Time
    },
    SeekExpiredTime = ?IF(Time > 0, lib_sell:get_expired_time(?SELL_TYPE_SEEK) + Time, 0),
    NewMinExpireTime = ?IF(MinExpiredTime == 0 orelse SeekExpiredTime < MinExpiredTime, SeekExpiredTime, MinExpiredTime),
    NewSeekMap = maps:put(Id, SeekGoods, SeekMap),
    NewSeekIds = [{Id, Time}|SeekIds],
    SeekIdList = maps:get(PlayerId, PlayerSeekMap, []),
    NewPlayerSeekMap = maps:put(PlayerId, [Id|SeekIdList], PlayerSeekMap),
    init_seek_map_do(SortSeekList, NewSeekMap, NewPlayerSeekMap, NewSeekIds, NewMinExpireTime).


%% 物品出售记录单价排序
sort_price_list([], _Len, _MaxLen, AccList) -> AccList;
sort_price_list(_L, Len, MaxLen, AccList) when Len > MaxLen -> AccList;
sort_price_list([T|L], Len, MaxLen, AccList) ->
    {MaxItem, List} = get_max(L, T, []),
    NewAccList = [MaxItem|AccList],
    sort_price_list(List, Len + 1, MaxLen, NewAccList).

get_max([], Max, AccList) -> {Max, AccList};
get_max([T|L], Max, AccList) ->
    #sell_price{unit_price = TmpPrice, time = TmpUtime} = T,
    #sell_price{unit_price = MaxPrice, time = MaxUtime} = Max,
    if
        TmpPrice > MaxPrice ->
            get_max(L, T, [Max|AccList]);
        TmpPrice == MaxPrice ->
            case TmpUtime =< MaxUtime of
                true ->
                    get_max(L, T, [Max|AccList]);
                false ->
                    get_max(L, T, [T|AccList])
            end;
        true ->
            get_max(L, T, [T|AccList])
    end.

list_category_sell_num(State, PlayerId, Category) ->
    #sell_state{category_change = CategoryChangeMap} = State,
    IsChange = maps:get(Category, CategoryChangeMap, true),
    %NowTime = utime:unixtime(),
    %?PRINT("SellNumList Category ~p~n", [Category]),
    case get({?MODULE, category_sell_num, Category}) of 
        {_CalcTime, SellNumList} when IsChange == false -> 
            %?PRINT("SellNumList old ~p~n", [SellNumList]),
            NewCategoryChangeMap = CategoryChangeMap;
        _ ->
            NewCategoryChangeMap = maps:put(Category, false, CategoryChangeMap),
            SellNumList = list_category_sell_num_helper(State, Category),
            ?PRINT("SellNumList new ~p~n", [SellNumList])
    end,
    lib_server_send:send_to_uid(PlayerId, pt_151, 15101, [Category, SellNumList]),
    State#sell_state{category_change = NewCategoryChangeMap}.

list_category_sell_num_helper(State, Category) ->
    #sell_state{market_sell_map = MartSellMap} = State,
    CategorySellMap = maps:get(Category, MartSellMap, #{}),
    F = fun(SubCategory, OnSellList, AccL) ->
        OnSellNum = lib_sell:count_goods_num(OnSellList),
        [{SubCategory, OnSellNum}|AccL]
    end,
    SellNumList = maps:fold(F, [], CategorySellMap),
    SubCategoryList = data_sell:get_sub_category(Category),
    case SellNumList =/= [] andalso lists:member(0, SubCategoryList) of
        true -> %% 统计当前大类下所有出售物品的数量
            F1 = fun({_Key, Val}, Acc) -> Acc + Val end,
            SumNum = lists:foldl(F1, 0, SellNumList),
            LastSellNumL = [{0, SumNum}|SellNumList];
        false ->
            LastSellNumL = SellNumList
    end,
    put({?MODULE, category_sell_num, Category}, {utime:unixtime(), LastSellNumL}),
    LastSellNumL.

list_sub_category_sell_goods(State, PlayerId, Category, SubCategory, Stage, Star, Color) ->
    #sell_state{market_sell_map = MarketSellMap} = State,
    CategorySellMap = maps:get(Category, MarketSellMap, #{}),
    case SubCategory == 0 of
        true ->
            SubCategoryList = data_sell:get_sub_category(Category),
            case lists:member(0, SubCategoryList) of
                true ->
                    List = maps:to_list(CategorySellMap),
                    F = fun({_, T}, Acc) -> T ++ Acc end,
                    SubCategorySellL = lists:foldl(F, [], List);
                false -> SubCategorySellL = []
            end;
        false ->
            SubCategorySellL = maps:get(SubCategory, CategorySellMap, [])
    end,
    FilterList = do_filter_goods(SubCategorySellL, [?FILTER_TYPE_SUBCATEGORY_STAGE_AND_STAR, Stage, Star, Color]),
    PackList = pack_sell_goods_list(FilterList, ?PACK_TYPE_MARKET, []),
    %?PRINT("list goods ~p~n", [PackList]),
    lib_server_send:send_to_uid(PlayerId, pt_151, 15102, [Category, SubCategory, PackList]).

filter_goods(State, PlayerId, Args, Cmd) ->
    #sell_state{market_sell_map = MarketSellMap} = State,
    MarketSellL = maps:to_list(MarketSellMap),
    List = do_filter_goods(MarketSellL, Args),
    PackList = pack_sell_goods_list(List, ?PACK_TYPE_MARKET, []),
    lib_server_send:send_to_uid(PlayerId, pt_151, Cmd, [PackList]).

do_filter_goods(SellL, [?FILTER_TYPE_SUBCATEGORY_STAGE_AND_STAR, FilterStage, FilterStar, FilterColor]) ->
    F = fun(T) ->
        case T of
            #sell_goods{gtype_id = GTypeId} ->
                {Stage, Star} = lib_equip:get_equip_stage_and_star(GTypeId),
                #ets_goods_type{color = Color} = data_goods_type:get(GTypeId),
                %% 99表示没有加入这个筛选条件
                (Stage == FilterStage orelse FilterStage == 99)
                andalso (Star == FilterStar orelse FilterStar == 99) andalso (Color == FilterColor orelse FilterColor == 99);
            _ -> false
        end
    end,
    lists:filter(F, SellL);
do_filter_goods(MarketSellL, [?FILTER_TYPE_STAGE_AND_STAR, FilterStage, FilterStar, FilterColor]) ->
    F = fun(T) ->
        case T of
            #sell_goods{gtype_id = GTypeId} ->
                {Stage, Star} = lib_equip:get_equip_stage_and_star(GTypeId),
                #ets_goods_type{color = Color} = data_goods_type:get(GTypeId),
                %% 99表示没有加入这个筛选条件
                (Stage == FilterStage orelse FilterStage == 99)
                andalso (Star == FilterStar orelse FilterStar == 99) andalso (Color == FilterColor orelse FilterColor == 99);
            _ -> false
        end
    end,
    do_filter_goods_core(MarketSellL, F);
do_filter_goods(MarketSellL, [?FILTER_TYPE_KEY_WORDS, KeyWords]) when is_list(KeyWords) ->
    case re:compile(KeyWords) of 
        {ok, MP} ->
            F = fun(T) ->
                case T of
                    #sell_goods{gtype_id = GTypeId} ->
                        GoodsName = data_goods_type:get_name(GTypeId),
                        GoodsNameBin = util:make_sure_binary(GoodsName),
                        GoodsNameStr = binary_to_list(GoodsNameBin),
                        case re:run(GoodsNameStr, MP, [{capture, none}]) of
                            match -> true;
                            _ -> false
                        end;
                    _ -> false
                end
            end,
            do_filter_goods_core(MarketSellL, F);
        _E ->
            ?ERR("do_filter_goods KeyWords err :~p~n", _E),
            []
    end;
do_filter_goods(MarketSellL, [?FILTER_TYPE_GOODS_TYPE_ID, GTypeId]) ->
    F = fun(T) ->
        case T of
            #sell_goods{gtype_id = GTypeId} -> true;
            _ -> false
        end
    end,
    do_filter_goods_core(MarketSellL, F);
do_filter_goods(_, _) -> [].

do_filter_goods_core(MarketSellL, FilterFunc) ->
    F = fun({_, List}, Acc) ->
        T = lists:filter(FilterFunc, List),
        T ++ Acc
    end,
    F1 = fun({_, SubCategorySellM}, Acc) ->
        SubCategorySellL = maps:to_list(SubCategorySellM),
        lists:foldl(F, Acc, SubCategorySellL)
    end,
    lists:foldl(F1, [], MarketSellL).

send_sell_up_view_info(State, PlayerId, GoodsId, GTypeId) ->
    #sell_state{market_sell_map = _MarketSellMap, sell_price_map = SellPriceMap} = State,
    SellPriceList = maps:get(GTypeId, SellPriceMap, []),
    NowTime = utime:unixtime(),
    F = fun(T, {AccPrice, AccNum}) ->
        case T of
            #sell_price{
                unit_price = UnitPrice,
                time = Time
            } when NowTime - Time < ?SELL_PRICE_REFER_EXPIRED_TIME ->
                {AccPrice + UnitPrice, AccNum + 1};
            _ -> {AccPrice, AccNum}
        end
    end,
    {SumUnitPrice, Num} = lists:foldl(F, {0, 0}, SellPriceList),
    case SumUnitPrice > 0 of
        true ->
            PriceType = 1,
            Price = round(SumUnitPrice / Num);
        false ->
            PriceType = 2,
            Price = data_goods:get_base_price(GTypeId)
    end,
    %MarketSellL = maps:to_list(MarketSellMap),
    %List = do_filter_goods(MarketSellL, [?FILTER_TYPE_GOODS_TYPE_ID, GTypeId]),
    %PackList = pack_sell_goods_list(List, ?PACK_TYPE_MARKET, []),
    lib_server_send:send_to_uid(PlayerId, pt_151, 15105, [GoodsId, PriceType, Price]).

check_sell_up_goods(State, ?SELL_TYPE_MARKET, PlayerId, _PlayerVipLv, _SpecifyId) ->
    #sell_state{player_market_sell_map = PlayerMarketSellMap} = State,
    PlayerSellGoodsL = maps:get(PlayerId, PlayerMarketSellMap, []),
    OnSellNum = lib_sell:count_on_sell_num(PlayerSellGoodsL),
    %% 检测是否达到上架最大数量上限
    case OnSellNum < data_sell:get_cfg(market_max_sell_num) of
        true -> ok;
        false -> {fail, ?ERRCODE(err151_max_sell_up_num)}
    end;
check_sell_up_goods(State, ?SELL_TYPE_P2P, PlayerId, _PlayerVipLv, SpecifyId) ->
    #sell_state{p2p_sell_map = P2PSellMap, sell_record_list = SellRecordList} = State,
    PlayerSellList = maps:get(PlayerId, P2PSellMap, []),
    OnSellNum = lib_sell:count_on_sell_num(PlayerSellList),
    %% 检测是否达到上架最大数量上限
    case OnSellNum < data_sell:get_cfg(p2p_max_sell_num) of
        true ->
            RefreshTime = get_refresh_time(),
            F = fun(T, Acc) ->
                case T of
                    #sell_record{
                        sell_type = ?SELL_TYPE_P2P,
                        player_id = TmpPlayerId,
                        buyer_id = TmpBuyerId,
                        time = TmpTime
                    } ->
                        case TmpTime >= RefreshTime of
                            true ->
                                case (TmpPlayerId == PlayerId andalso TmpBuyerId == SpecifyId) orelse
                                    (TmpPlayerId == SpecifyId andalso TmpBuyerId == TmpPlayerId) of
                                    true -> Acc + 1;
                                    false -> Acc
                                end;
                            false -> Acc
                        end;
                    _ -> Acc
                end
            end,
            Times = lists:foldl(F, 0, SellRecordList),
            TotalTimes = data_sell:get_cfg(specify_sell_times_limit),
            case Times < TotalTimes of
                true -> ok;
                false -> {fail, ?ERRCODE(err151_specify_sell_times_limit)}
            end;
        false -> {fail, ?ERRCODE(err151_max_sell_up_num)}
    end;
check_sell_up_goods(_, _, _, _, _) -> {fail, ?FAIL}.

sell_up(State, SellGoods, IsShout) ->
    NowTime = utime:unixtime(),
    Id = mod_id_create:get_new_id(?SELL_ID_CREATE),
    #sell_goods{
        player_id       = PlayerId,
        sell_type       = SellType,
        specify_id      = SpecifyId,
        category        = Category,
        sub_category    = SubCategory,
        gtype_id        = GTypeId,
        goods_num       = GoodsNum,
        unit_price      = UnitPrice,
        other           = #goods_other{extra_attr = ExtraAttr}
    } = SellGoods,
    db:execute(io_lib:format(?sql_sell_insert,
        [Id, PlayerId, SellType, SpecifyId, GTypeId, Category, SubCategory, GoodsNum, UnitPrice, util:term_to_bitstring(ExtraAttr), NowTime])),

    %% 商品上架日志
    lib_log_api:log_sell_up(PlayerId, SellType, Id, GTypeId, GoodsNum, UnitPrice, SpecifyId, ExtraAttr),

    %% 上架玩家商品
    NewSellGoods = SellGoods#sell_goods{id = Id, time = NowTime},
    NewState = do_sell_up(SellType, State, NewSellGoods),
    %% 上架喊话
    case IsShout == 1 andalso SellType =/= ?SELL_TYPE_SEEK of
        true ->
            lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_sell, market_shout, [Id, IsShout]);
        _ ->
            ok
    end,
    {?SUCCESS, NewState}.

do_sell_up(?SELL_TYPE_MARKET, State, SellGoods) ->
    #sell_state{market_sell_map = MarketSellMap, player_market_sell_map = PlayerSellMap, min_expire_time = MinExpiredTime, category_change = CategoryChangeMap} = State,
    #sell_goods{player_id = PlayerId, category = Category, sub_category = SubCategory, time = SellTime} = SellGoods,
    SellExpiredTime = SellTime + lib_sell:get_expired_time(?SELL_TYPE_MARKET),
    CategorySellMap = maps:get(Category, MarketSellMap, #{}),
    SubCategorySellL = maps:get(SubCategory, CategorySellMap, []),
    NewCategorySellMap = maps:put(SubCategory, [SellGoods|SubCategorySellL], CategorySellMap),
    NewMarketSellMap = maps:put(Category, NewCategorySellMap, MarketSellMap),
    PlayerSellList = maps:get(PlayerId, PlayerSellMap, []),
    NewPlayerSellMap = maps:put(PlayerId, [SellGoods|PlayerSellList], PlayerSellMap),
    NewMinExpireTime = ?IF(MinExpiredTime == 0 orelse SellExpiredTime < MinExpiredTime, SellExpiredTime,  MinExpiredTime),
    NewCategoryChangeMap = maps:put(Category, true, CategoryChangeMap),
    State#sell_state{market_sell_map = NewMarketSellMap, player_market_sell_map = NewPlayerSellMap, min_expire_time = NewMinExpireTime, category_change = NewCategoryChangeMap};
do_sell_up(?SELL_TYPE_P2P, State, SellGoods) ->
    #sell_state{p2p_sell_map = P2PSellMap, min_expire_time = MinExpiredTime} = State,
    #sell_goods{player_id = PlayerId, time = SellTime} = SellGoods,
    SellExpiredTime = SellTime + lib_sell:get_expired_time(?SELL_TYPE_P2P),
    PlayerSellList = maps:get(PlayerId, P2PSellMap, []),
    NewP2PSellMap = maps:put(PlayerId, [SellGoods|PlayerSellList], P2PSellMap),
    NewMinExpireTime = ?IF(MinExpiredTime == 0 orelse SellExpiredTime < MinExpiredTime, SellExpiredTime,  MinExpiredTime),
    State#sell_state{p2p_sell_map = NewP2PSellMap, min_expire_time = NewMinExpireTime}.

%% 下架
sell_down(State, PlayerId, ?SELL_TYPE_MARKET, Id, GTypeId, GoodsNum) ->
    #sell_state{
        market_sell_map = MarketSellMap,
        player_market_sell_map = PlayerSellMap,
        category_change = CategoryChangeMap
    } = State,
    case data_goods_type:get(GTypeId) of
        #ets_goods_type{
            sell_category = Category,
            sell_subcategory = SubCategory
        } -> skip;
        _ -> Category = 0, SubCategory = 0
    end,
    CategorySellMap = maps:get(Category, MarketSellMap, #{}),
    SubCategorySellL = maps:get(SubCategory, CategorySellMap, []),
    SellGoods = lists:keyfind(Id, #sell_goods.id, SubCategorySellL),
    if
        SellGoods == false -> {?ERRCODE(err151_goods_not_exist), State};
        SellGoods#sell_goods.player_id =/= PlayerId -> {?ERRCODE(err151_not_seller), State};
        SellGoods#sell_goods.gtype_id =/= GTypeId -> {?ERRCODE(err151_goods_info_err), State};
        SellGoods#sell_goods.goods_num =/= GoodsNum -> {?ERRCODE(err151_goods_info_err), State};
        true ->
            db:execute(io_lib:format(?sql_sell_delete, [Id])),
            NewSubCategorySellL = lists:keydelete(Id, #sell_goods.id, SubCategorySellL),
            NewCategorySellMap = maps:put(SubCategory, NewSubCategorySellL, CategorySellMap),
            NewMarketSellMap = maps:put(Category, NewCategorySellMap, MarketSellMap),
            PlayerSellList = maps:get(PlayerId, PlayerSellMap, []),
            NewPlayerSellList = lists:keydelete(Id, #sell_goods.id, PlayerSellList),
            NewPlayerSellMap = maps:put(PlayerId, NewPlayerSellList, PlayerSellMap),
            NewCategoryChangeMap = maps:put(Category, true, CategoryChangeMap),
            %% 下架日志
            add_down_log([SellGoods], ?LOG_DOWN_TYPE_MANUAL),
            NewState = State#sell_state{
                            market_sell_map = NewMarketSellMap,
                            player_market_sell_map = NewPlayerSellMap,
                            category_change = NewCategoryChangeMap
                        },
            {{ok, SellGoods}, NewState}
    end;
sell_down(State, PlayerId, ?SELL_TYPE_P2P, Id, GTypeId, GoodsNum) ->
    #sell_state{p2p_sell_map = P2PSellMap} = State,
    PlayerSellList = maps:get(PlayerId, P2PSellMap, []),
    SellGoods = lists:keyfind(Id, #sell_goods.id, PlayerSellList), 
    if
        SellGoods == false -> {?ERRCODE(err151_goods_not_exist), State};
        SellGoods#sell_goods.player_id =/= PlayerId -> {?ERRCODE(err151_not_seller), State};
        SellGoods#sell_goods.gtype_id =/= GTypeId -> {?ERRCODE(err151_goods_info_err), State};
        SellGoods#sell_goods.goods_num =/= GoodsNum -> {?ERRCODE(err151_goods_info_err), State};
        true ->
            db:execute(io_lib:format(?sql_sell_delete, [Id])),
            NewPlayerSellList = lists:keydelete(Id, #sell_goods.id, PlayerSellList),
            NewP2PSellMap = maps:put(PlayerId, NewPlayerSellList, P2PSellMap),
            %% 下架日志
            add_down_log([SellGoods], ?LOG_DOWN_TYPE_MANUAL),
            %% 更新对方指定交易小红点信息
            case misc:is_process_alive(misc:get_player_process(SellGoods#sell_goods.specify_id)) of
                true ->
                    mod_sell:send_p2p_red_point(SellGoods#sell_goods.specify_id);
                _ ->
                    skip
            end,
            NewState = State#sell_state{p2p_sell_map = NewP2PSellMap},
            {{ok, SellGoods}, NewState}
    end.

%% 购买商品
pay_sell(State, PlayerId, ?SELL_TYPE_MARKET, Id, SellerId, GTypeId, GoodsNum, UnitPrice) ->
    #sell_state{
        market_sell_map = MarketSellMap,
        player_market_sell_map = PlayerSellMap,
        sell_record_list = SellRecordList,
        sell_price_map = SellPriceMap,
        category_change = CategoryChangeMap
    } = State,
    case data_goods_type:get(GTypeId) of
        #ets_goods_type{
            sell_category = Category,
            sell_subcategory = SubCategory
        } -> skip;
        _ -> Category = 0, SubCategory = 0
    end,
    CategorySellMap = maps:get(Category, MarketSellMap, #{}),
    SubCategorySellL = maps:get(SubCategory, CategorySellMap, []),
    SellGoods = lists:keyfind(Id, #sell_goods.id, SubCategorySellL),
    if
        SellGoods == false -> {?ERRCODE(err151_goods_not_exist), State};
        SellGoods#sell_goods.player_id == PlayerId -> {?ERRCODE(err151_can_not_buy_self_goods), State};
        SellGoods#sell_goods.gtype_id =/= GTypeId -> {?ERRCODE(err151_goods_info_err), State};
        SellGoods#sell_goods.goods_num =/= GoodsNum -> {?ERRCODE(err151_goods_info_err), State};
        SellGoods#sell_goods.unit_price =/= UnitPrice -> {?ERRCODE(err151_goods_info_err), State};
        SellGoods#sell_goods.player_id =/= SellerId -> {?ERRCODE(err151_seller_not_match), State};
        true ->
            IsExpired = lib_sell:is_expired(SellGoods),
            if
                IsExpired == true -> {?ERRCODE(err151_goods_sell_down), State};
                true ->
                    RemainNum = SellGoods#sell_goods.goods_num - GoodsNum,
                    PlayerSellList = maps:get(SellerId, PlayerSellMap, []),
                    case RemainNum > 0 of
                        true ->
                            db:execute(io_lib:format(?sql_sell_num_update, [RemainNum, Id])),
                            NewSellGoods = SellGoods#sell_goods{goods_num = RemainNum},
                            NewSubCategorySellL = lists:keyreplace(Id, #sell_goods.id, SubCategorySellL, NewSellGoods),
                            NewPlayerSellList = lists:keyreplace(Id, #sell_goods.id, PlayerSellList, NewSellGoods);
                        false ->
                            db:execute(io_lib:format(?sql_sell_delete, [Id])),
                            NewSubCategorySellL = lists:keydelete(Id, #sell_goods.id, SubCategorySellL),
                            NewPlayerSellList = lists:keydelete(Id, #sell_goods.id, PlayerSellList)
                    end,
                    NewCategorySellMap = maps:put(SubCategory, NewSubCategorySellL, CategorySellMap),
                    NewMarketSellMap = maps:put(Category, NewCategorySellMap, MarketSellMap),
                    NewPlayerSellMap = maps:put(SellerId, NewPlayerSellList, PlayerSellMap),
                    {Tax, NewSellRecordList} = add_sell_record(SellRecordList, SellGoods, GoodsNum, PlayerId),
                    NewSellPriceMap = refresh_sell_price(SellPriceMap, SellGoods),
                    NewCategoryChangeMap = maps:put(Category, true, CategoryChangeMap),
                    %% 物品出售成功
                    sell_success(SellGoods, PlayerId, GoodsNum, Tax),

                    case RemainNum == 0 of
                        true ->
                            %% 商品出售完毕下架日志
                            add_down_log([SellGoods], ?LOG_DOWN_TYPE_SELL);
                        false -> skip
                    end,

                    NewState = State#sell_state{
                                    market_sell_map = NewMarketSellMap,
                                    player_market_sell_map = NewPlayerSellMap,
                                    sell_record_list = NewSellRecordList,
                                    sell_price_map = NewSellPriceMap,
                                    category_change = NewCategoryChangeMap
                                },
                    {{ok, SellGoods, Tax}, NewState}
            end
    end;
pay_sell(State, PlayerId, ?SELL_TYPE_P2P, Id, SellerId, GTypeId, GoodsNum, UnitPrice) ->
    #sell_state{
        p2p_sell_map = P2PSellMap,
        sell_record_list = SellRecordList,
        sell_price_map = SellPriceMap
    } = State,
    PlayerSellList = maps:get(SellerId, P2PSellMap, []),
    SellGoods = lists:keyfind(Id, #sell_goods.id, PlayerSellList),
    if
        SellGoods == false -> {?ERRCODE(err151_goods_not_exist), State};
        SellGoods#sell_goods.specify_id =/= PlayerId -> {?ERRCODE(err151_not_specify_role), State};
        SellGoods#sell_goods.gtype_id =/= GTypeId -> {?ERRCODE(err151_goods_info_err), State};
        SellGoods#sell_goods.goods_num =/= GoodsNum -> {?ERRCODE(err151_goods_info_err), State};
        SellGoods#sell_goods.unit_price =/= UnitPrice -> {?ERRCODE(err151_goods_info_err), State};
        true ->
            IsExpired = lib_sell:is_expired(SellGoods),
            if
                IsExpired == true -> {?ERRCODE(err151_goods_sell_down), State};
                true ->
                    db:execute(io_lib:format(?sql_sell_delete, [Id])),
                    NewPlayerSellList = lists:keydelete(Id, #sell_goods.id, PlayerSellList),
                    NewP2PSellMap = maps:put(SellerId, NewPlayerSellList, P2PSellMap),
                    {Tax, NewSellRecordList} = add_sell_record(SellRecordList, SellGoods, GoodsNum, PlayerId),
                    NewSellPriceMap = refresh_sell_price(SellPriceMap, SellGoods),
                    sell_success(SellGoods, PlayerId, GoodsNum, Tax),

                    %% 商品出售完毕下架日志
                    add_down_log([SellGoods], ?LOG_DOWN_TYPE_SELL),

                    NewState = State#sell_state{
                                    p2p_sell_map = NewP2PSellMap,
                                    sell_record_list = NewSellRecordList,
                                    sell_price_map = NewSellPriceMap
                                },
                    {{ok, SellGoods, Tax}, NewState}
            end
    end.

check_seek_goods(State, PlayerId, _PlayerVipLv, SellTimes, LimitTimes) ->
    #sell_state{player_seek_map = PlayerSeekMap} = State,
    TotalTimes = data_sell:get_cfg(seek_times_limit),
    SeekIdList = maps:get(PlayerId, PlayerSeekMap, []),
    SeekLength = length(SeekIdList),
    case SeekLength < TotalTimes of 
        true -> 
            case SeekLength + SellTimes >= LimitTimes of 
                true -> {{fail, ?ERRCODE(err151_cannot_seek_err)}, State};
                _ -> {ok, State}
            end;
        _ -> {{fail, ?ERRCODE(err151_seek_times_err)}, State}
    end.

seek_goods(State, SeekGoods) ->
    NowTime = utime:unixtime(),
    Id = mod_id_create:get_new_id(?SELL_ID_CREATE),
    #seek_goods{
        player_id       = PlayerId,
        role_name       = RoleName,
        category        = Category,
        sub_category    = SubCategory,
        gtype_id        = GTypeId,
        goods_num       = GoodsNum,
        unit_price      = UnitPrice
    } = SeekGoods,
    db:execute(io_lib:format(?sql_seek_insert,
        [Id, PlayerId, util:fix_sql_str(RoleName), GTypeId, Category, SubCategory, GoodsNum, UnitPrice, NowTime])),
    %% 商品上架日志
    lib_log_api:log_seek_up(Id, PlayerId, GTypeId, GoodsNum, UnitPrice),
    %% 上架玩家商品
    NewSeekGoods= SeekGoods#seek_goods{id = Id, time = NowTime},
    NewState = do_seek_goods(State, NewSeekGoods),
    {{ok, NewSeekGoods}, NewState}.

do_seek_goods(State, SeekGoods) ->
    #sell_state{player_seek_map = PlayerSeekMap, seek_map = SeekMap, seek_ids = SeekIds, min_expire_time = MinExpiredTime} = State,
    #seek_goods{id = Id, player_id = PlayerId, time = SeekTime} = SeekGoods,
    %% 更新总的求购信息
    NewSeekMap = maps:put(Id, SeekGoods, SeekMap),
    %% 更新玩家求购列表
    SeekIdList = maps:get(PlayerId, PlayerSeekMap, []),
    NewPlayerSeekMap = maps:put(PlayerId, [Id|SeekIdList], PlayerSeekMap),
    %% 更新排序的求购id列表
    NewSeekIds = [{Id, SeekTime}|SeekIds],
    %% 更新过期时间戳
    SeekExpiredTime = SeekTime + lib_sell:get_expired_time(?SELL_TYPE_SEEK),
    NewMinExpireTime = ?IF(MinExpiredTime == 0 orelse SeekExpiredTime < MinExpiredTime, SeekExpiredTime,  MinExpiredTime),
    State#sell_state{player_seek_map = NewPlayerSeekMap, seek_map = NewSeekMap, seek_ids = NewSeekIds, min_expire_time = NewMinExpireTime}.

delete_seek(State, PlayerId, Id) ->
    #sell_state{player_seek_map = PlayerSeekMap, seek_map = SeekMap, seek_ids = SeekIds} = State,
    SeekGoods = maps:get(Id, SeekMap, 0),
    if
        is_record(SeekGoods, seek_goods) == false -> ErrorCode = ?ERRCODE(err151_no_seek_goods), NewState = State;
        SeekGoods#seek_goods.player_id =/= PlayerId -> ErrorCode = ?ERRCODE(err151_not_my_goods), NewState = State;
        true ->
            #seek_goods{gtype_id = GTypeId, goods_num = GoodsNum, unit_price = UnitPrice} = SeekGoods,
            ErrorCode = ?SUCCESS,
            db:execute(io_lib:format(?sql_seek_delete, [Id])),
            %% 发放保管费非玩家
            Price = UnitPrice,
            MoneyReturn = [{?TYPE_GOLD, 0, round(Price)}],
            %% 邮件发送
            Title = utext:get(1510003),
            Content = utext:get(1510004),
            lib_mail_api:send_sys_mail([PlayerId], Title, Content, MoneyReturn),
            %% 日志
            lib_log_api:log_seek_down(Id, PlayerId, ?LOG_DOWN_TYPE_MANUAL, GTypeId, GoodsNum, UnitPrice, MoneyReturn),
            NewSeekMap = maps:remove(Id, SeekMap),
            NewSeekIds = lists:keydelete(Id, 1, SeekIds),
            SeekIdList = maps:get(PlayerId, PlayerSeekMap, []),
            NewSeekIdList = lists:delete(Id, SeekIdList),
            NewPlayerSeekMap = maps:put(PlayerId, NewSeekIdList, PlayerSeekMap),
            NewState = State#sell_state{player_seek_map = NewPlayerSeekMap, seek_map = NewSeekMap, seek_ids = NewSeekIds}
    end,
    lib_server_send:send_to_uid(PlayerId, pt_151, 15116, [ErrorCode, Id]),
    NewState.

sell_seek_goods(State, PlayerId, VipType, VipLv, Id, BuyerId, GTypeId, GoodsNum, ExtraAttr, Rating) ->
    #sell_state{
        sell_record_list = SellRecordList, sell_price_map = SellPriceMap,
        player_seek_map = PlayerSeekMap, seek_map = SeekMap, seek_ids = SeekIds
    } = State,
    SeekGoods = maps:get(Id, SeekMap, 0),
    if
        is_record(SeekGoods, seek_goods) == false -> {{fail, ?ERRCODE(err151_no_seek_goods)}, State};
        SeekGoods#seek_goods.player_id == PlayerId -> {{fail, ?ERRCODE(err151_can_not_sell_self_goods)}, State};
        SeekGoods#seek_goods.player_id =/= BuyerId -> {{fail, ?ERRCODE(err151_seek_goods_info_err)}, State};
        SeekGoods#seek_goods.gtype_id =/= GTypeId -> {{fail, ?ERRCODE(err151_seek_goods_info_err)}, State};
        SeekGoods#seek_goods.goods_num =/= GoodsNum -> {{fail, ?ERRCODE(err151_seek_goods_info_err)}, State};
        true ->
            RemainNum = SeekGoods#seek_goods.goods_num - GoodsNum,
            Price = SeekGoods#seek_goods.unit_price,
            case RemainNum == 0 of 
                true ->
                    %?PRINT("sell_seek_goods RemainNum 00 :~p~n", [0]),
                    db:execute(io_lib:format(?sql_seek_delete, [Id])),
                    NewSeekMap = maps:remove(Id, SeekMap),
                    NewSeekIds = lists:keydelete(Id, 1, SeekIds),
                    SeekIdList = maps:get(BuyerId, PlayerSeekMap, []),
                    NewSeekIdList = lists:delete(Id, SeekIdList),
                    NewPlayerSeekMap = maps:put(BuyerId, NewSeekIdList, PlayerSeekMap);
                _ ->
                    %?PRINT("sell_seek_goods RemainNum 11 :~p~n", [RemainNum]),
                    db:execute(io_lib:format(?sql_seek_num_update, [RemainNum, Id])),
                    NewSeekGoods = SeekGoods#seek_goods{goods_num = RemainNum},
                    NewSeekMap = maps:put(Id, NewSeekGoods, SeekMap),
                    NewSeekIds = SeekIds,
                    NewPlayerSeekMap = PlayerSeekMap
            end,
            %% 计算钻石所得
            {Tax, NewSellRecordList} = sell_seek_goods_succ(SellRecordList, SeekGoods, GoodsNum, ExtraAttr, Rating, PlayerId, VipType, VipLv),
            MoneyReturn = round(Price),
            %% 邮件发送 求购成功信息
            case ExtraAttr == [] of
                true -> RewardList = [{?TYPE_GOODS, GTypeId, GoodsNum}];
                false -> RewardList = [{?TYPE_ATTR_GOODS, GTypeId, GoodsNum, [{extra_attr, ExtraAttr}]}]
            end,
            GoodsName = data_goods_type:get_name(GTypeId),
            Title = utext:get(1510001),
            Content = utext:get(1510002, [GoodsNum, util:make_sure_binary(GoodsName)]),
            lib_mail_api:send_sys_mail([BuyerId], Title, Content, RewardList),
            %% 买家每日消耗累积
            mod_daily:plus_count_offline(BuyerId, ?MOD_SELL, 3, MoneyReturn),
            %% 日志
            case RemainNum == 0 of 
                true ->
                    lib_log_api:log_seek_down(Id, BuyerId, ?LOG_DOWN_TYPE_SELL, GTypeId, 0, Price, []);
                _ -> ok
            end,
            %% 增加买方的交易次数
            mod_daily:increment_offline(BuyerId, ?MOD_SELL, 1),
            lib_sell:send_role_sell_times(BuyerId),
            %% 更新价格
            NewSellPriceMap = refresh_sell_price(SellPriceMap, GTypeId, max(1, round(Price / GoodsNum))),
            NewState = State#sell_state{
                sell_record_list = NewSellRecordList, sell_price_map = NewSellPriceMap,
                player_seek_map = NewPlayerSeekMap, seek_map = NewSeekMap, seek_ids = NewSeekIds
            },
            {{ok, MoneyReturn, Tax, RemainNum}, NewState}
    end.

sell_seek_goods_succ(SellRecordList, SeekGoods, GoodsNum, ExtraAttr, Rating, SellerId, VipType, VipLv) ->
    #seek_goods{
        id = SeekId, player_id = BuyerId, gtype_id = GTypeId, category = Category, sub_category = SubCategory,
        goods_num = SeekGoodsNum, unit_price = UnitPrice
    } = SeekGoods,
    GoodsOther = #goods_other{extra_attr = ExtraAttr, rating = Rating},
    Tax = count_tax(GTypeId, GoodsNum, UnitPrice, VipType, VipLv),
    NowTime = utime:unixtime(),
    Args = [SellerId, BuyerId, ?SELL_TYPE_SEEK, GTypeId, GoodsNum, UnitPrice, Tax, util:term_to_bitstring(ExtraAttr), NowTime],
    db:execute(io_lib:format(?sql_sell_record_insert, Args)),
    SellRecord = make_record(sell_record, [SellerId, BuyerId, ?SELL_TYPE_SEEK, GTypeId, GoodsNum, UnitPrice, Tax, GoodsOther, NowTime]),
    lib_log_api:log_sell_pay(?SELL_TYPE_SEEK, SeekId, GTypeId, GoodsNum, UnitPrice, Tax, SellerId, BuyerId, ExtraAttr),
    %% 通知购买方商品已消失
    case SeekGoodsNum == GoodsNum of 
        true ->
            {ok, Bin} = pt_151:write(15120, [?SELL_TYPE_SEEK, Category, SubCategory, SeekId]),
            lib_server_send:send_to_uid(BuyerId, Bin);
        _ -> ok
    end,
    {Tax, [SellRecord|SellRecordList]}.

send_self_seek_list(State, PlayerId, Cmd) ->
    #sell_state{player_seek_map = PlayerSeekMap, seek_map = SeekMap} = State,
    SeekIdList = maps:get(PlayerId, PlayerSeekMap, []),
    F = fun(Id, List) ->
        case maps:get(Id, SeekMap, 0) of 
            #seek_goods{player_id = PlayerId, gtype_id = GTypeId, goods_num = GoodsNum, unit_price = UnitPrice, time = SeekTime} ->
                [{Id, GTypeId, GoodsNum, UnitPrice, SeekTime}|List];
            _ -> List
        end
    end,
    PackSeekList = lists:foldl(F, [], SeekIdList),
    %?PRINT("send_self_seek_list PackSeekList :~p~n", [PackSeekList]),
    lib_server_send:send_to_uid(PlayerId, pt_151, Cmd, [PackSeekList]).

send_seek_list(State, PlayerId, Cmd, PageNo, PageSize) ->
    #sell_state{seek_ids = SeekIds, seek_map = SeekMap} = State,
    SortSeekIds = lists:reverse(SeekIds),
    {PageTotal, StartPos, ThisPageSize} = util:calc_page_cache(length(SortSeekIds), PageSize, PageNo),
    SubSeekIds = lists:sublist(SortSeekIds, StartPos, ThisPageSize),
    F = fun({Id, _}, List) ->
        case maps:get(Id, SeekMap, 0) of 
            #seek_goods{player_id = BuyerId, role_name = RoleName, gtype_id = GTypeId, goods_num = GoodsNum, unit_price = UnitPrice, time = SeekTime} ->
                [{Id, config:get_server_id(), config:get_server_num(), BuyerId, RoleName, GTypeId, GoodsNum, UnitPrice, SeekTime}|List];
            _ -> List
        end
    end,
    PackSeekList = lists:foldl(F, [], SubSeekIds),
    %?PRINT("send_seek_list PackSeekList :~p~n", [PackSeekList]),
    lib_server_send:send_to_uid(PlayerId, pt_151, Cmd, [PageTotal, PageNo, PageSize, PackSeekList]).

%% 增加新的出售记录
add_sell_record(SellRecordList, SellGoods, GoodsNum, BuyerId) ->
    #sell_goods{
        player_id = SellerId,
        sell_type = SellType,
        gtype_id = GTypeId,
        unit_price = UnitPrice,
        other = GoodsOther
    } = SellGoods,
    #goods_other{extra_attr = ExtraAttr} = GoodsOther,
    {SellerVipType, SellerVipLv} = lib_role:get_role_vip(SellerId),
    Tax = count_tax(GTypeId, GoodsNum, UnitPrice, SellerVipType, SellerVipLv),
    NowTime = utime:unixtime(),
    Args = [SellerId, BuyerId, SellType, GTypeId, GoodsNum, UnitPrice, Tax, util:term_to_bitstring(ExtraAttr), NowTime],
    db:execute(io_lib:format(?sql_sell_record_insert, Args)),
    SellRecord = make_record(sell_record, [SellerId, BuyerId, SellType, GTypeId, GoodsNum, UnitPrice, Tax, GoodsOther, NowTime]),
    {Tax, [SellRecord|SellRecordList]}.

%% 刷新物品的交易价格
refresh_sell_price(SellPriceMap, SellGoods) ->
    #sell_goods{gtype_id = GTypeId, unit_price = UnitPrice, goods_num = GoodsNum} = SellGoods,
    refresh_sell_price(SellPriceMap, GTypeId, max(1, round(UnitPrice / GoodsNum))).

refresh_sell_price(SellPriceMap, GTypeId, UnitPrice) ->
    NowTime = utime:unixtime(),
    SellPriceR = make_record(sell_price, [GTypeId, UnitPrice, NowTime]),
    GTypeSellPriceL = maps:get(GTypeId, SellPriceMap, []),
    NewGTypeSellPriceL = sort_price_list([SellPriceR|GTypeSellPriceL], 1, ?SELL_PRICE_REFER_NUM, []),
    maps:put(GTypeId, NewGTypeSellPriceL, SellPriceMap).


%% 计算交易税
count_tax(_GTypeId, _GoodsNum, UnitPrice, SellerVipType, SellerVipLv) ->
    Price = UnitPrice,
    case Price > 1 of
        true ->
            TaxRatio = lib_vip_api:get_vip_privilege(?MOD_SELL, 1, SellerVipType, SellerVipLv),
            util:ceil(Price * TaxRatio / 100);
        false -> 0
    end.

%% 物品出售成功
sell_success(SellGoods, BuyerId, GoodsNum, Tax) ->
    #sell_goods{
        id = SellId,
        sell_type = SellType,
        category = Category,           
        sub_category = SubCategory,
        player_id = SellerId,
        gtype_id = GTypeId,
        unit_price = UnitPrice,
        other = GoodsOther
    } = SellGoods,
    #goods_other{extra_attr = ExtraAttr} = GoodsOther,
    %% 增加买方的交易次数
    mod_daily:increment_offline(BuyerId, ?MOD_SELL, 1),
    lib_sell:send_role_sell_times(BuyerId),
    case data_goods_type:get(GTypeId) of
        #ets_goods_type{goods_name = GoodsName, color = Color} -> skip;
        _ -> GoodsName = "???", Color = ?GREEN
    end,
    %% 交易日志
    lib_log_api:log_sell_pay(SellType, SellId, GTypeId, GoodsNum, UnitPrice, Tax, SellerId, BuyerId, ExtraAttr),
    case SellerId > 0 of 
        true ->
            Price = UnitPrice,
            SellPrice = max(0, Price - Tax),
            Title   = utext:get(4),
            Content = utext:get(5, [Color, GoodsName, GoodsNum, Tax, SellPrice]),
            lib_mail_api:send_sys_mail([SellerId], Title, Content, [{?TYPE_GOLD, 0, SellPrice}]),
            mod_daily:plus_count_offline(SellerId, ?MOD_SELL, 2, SellPrice),
            %% 告诉出售方 该商品已被购买
            {ok, Bin} = pt_151:write(15120, [SellType, Category, SubCategory, SellId]),
            lib_server_send:send_to_uid(SellerId, Bin);
        _ ->
            ok
    end.

%% 自动下架：下架超过48小时未出售商品
auto_sell_down(State) ->
    NowTime = utime:unixtime(),
    #sell_state{min_expire_time = MinExpiredTime} = State,
    case MinExpiredTime =< NowTime of 
        true ->
            NewState = auto_do_sell_down(?SELL_TYPE_MARKET, State, NowTime),
            NewState1 = auto_do_sell_down(?SELL_TYPE_P2P, NewState, NowTime),
            NewState2 = auto_do_sell_down(?SELL_TYPE_SEEK, NewState1, NowTime),
            do_auto_sell_down_core(),
            NewState2#sell_state{category_change = #{}};
        _ ->
            %?PRINT("not refresh sell goods ============ ~n", []),
            State
    end.

auto_do_sell_down(?SELL_TYPE_MARKET, State, NowTime) ->
    #sell_state{
        market_sell_map = MarketSellMap,
        player_market_sell_map = PlayerMarketSellMap
    } = State,
    %% 设置一个进程字典临时存储过期的商品
    put(expired_goods_map, #{}),
    put(expired_goods_ids, []),
    put(min_expire_time, 0),
    F = fun(T) ->
        case lib_sell:is_expired(T, NowTime) of
            true ->
                TmpExpiredMap = get(expired_goods_map),
                TmpL = maps:get(T#sell_goods.player_id, TmpExpiredMap, []),
                NewTmpExpiredMap = maps:put(T#sell_goods.player_id, [T|TmpL], TmpExpiredMap),
                put(expired_goods_map, NewTmpExpiredMap),
                TmpExpiredIds = get(expired_goods_ids),
                put(expired_goods_ids, [T#sell_goods.id|TmpExpiredIds]),
                false;
            false -> 
                #sell_goods{sell_type = SellType, time = SellTime} = T,
                SellExpiredTime = lib_sell:get_expired_time(SellType) + SellTime,
                OMinExpireTime = get(min_expire_time),
                NMinExpireTime = ?IF(OMinExpireTime == 0 orelse SellExpiredTime < OMinExpireTime, SellExpiredTime, OMinExpireTime),
                put(min_expire_time, NMinExpireTime),
                true
        end
    end,
    F1 = fun(SubCategory, SubCategoryList, {SubSellMap}) ->
        NewSubCategoryList = lists:filter(F, SubCategoryList),
        NewSubSellMap = maps:put(SubCategory, NewSubCategoryList, SubSellMap),
        {NewSubSellMap}
    end,
    F2 = fun(Category, CategorySellMap, {SellMap}) ->
        {NewCategorySellMap} = maps:fold(F1, {#{}}, CategorySellMap),
        NewSellMap = maps:put(Category, NewCategorySellMap, SellMap),
        {NewSellMap}
    end,
    {NewMarketSellMap} = maps:fold(F2, {#{}}, MarketSellMap),
    ExpiredList = get(expired_goods_ids),
    F3 = fun(_K, SellL) ->
        [T|| T <- SellL, lists:member(T#sell_goods.id, ExpiredList) == false]
    end,
    NewPlayerMarketSellMap = maps:map(F3, PlayerMarketSellMap),
    State#sell_state{
        market_sell_map = NewMarketSellMap,
        player_market_sell_map = NewPlayerMarketSellMap
    };
auto_do_sell_down(?SELL_TYPE_P2P, State, NowTime) ->
    #sell_state{p2p_sell_map = P2PSellMap} = State,
    F = fun(T) ->
        case lib_sell:is_expired(T, NowTime) of
            true ->
                TmpExpiredMap = get(expired_goods_map),
                TmpL = maps:get(T#sell_goods.player_id, TmpExpiredMap, []),
                NewTmpExpiredMap = maps:put(T#sell_goods.player_id, [T|TmpL], TmpExpiredMap),
                put(expired_goods_map, NewTmpExpiredMap),
                TmpExpiredIds = get(expired_goods_ids),
                put(expired_goods_ids, [T#sell_goods.id|TmpExpiredIds]),
                false;
            false -> 
                #sell_goods{sell_type = SellType, time = SellTime} = T,
                SellExpiredTime = lib_sell:get_expired_time(SellType) + SellTime,
                OMinExpireTime = get(min_expire_time),
                NMinExpireTime = ?IF(OMinExpireTime == 0 orelse SellExpiredTime < OMinExpireTime, SellExpiredTime, OMinExpireTime),
                put(min_expire_time, NMinExpireTime),
                true
        end
    end,
    F1 = fun(_K, SellL) ->
        lists:filter(F, SellL)
    end,
    NewP2PSellMap = maps:map(F1, P2PSellMap),
    State#sell_state{p2p_sell_map = NewP2PSellMap};
auto_do_sell_down(?SELL_TYPE_SEEK, State, NowTime) ->
    #sell_state{
        seek_map = SeekMap
    } = State,
    %% 设置一个进程字典临时存储过期的商品
    put(expired_seek_list, []),
    put(expired_seek_ids, []),
    F2 = fun(Id, SeekGoods, {TmpSeekMap, TmpPlayerSeekMap, TmpSeekIds}) ->
        case lib_sell:is_expired(SeekGoods, NowTime) of
            true ->
                TmpExpiredList = get(expired_seek_list),
                put(expired_seek_list, [SeekGoods|TmpExpiredList]),
                TmpExpiredIds = get(expired_seek_ids),
                put(expired_seek_ids, [Id|TmpExpiredIds]),
                {TmpSeekMap, TmpPlayerSeekMap, TmpSeekIds};
            _ ->
                #seek_goods{player_id = PlayerId, time = SeekTime} = SeekGoods,
                SeekExpiredTime = lib_sell:get_expired_time(?SELL_TYPE_SEEK) + SeekTime,
                OMinExpireTime = get(min_expire_time),
                NMinExpireTime = ?IF(OMinExpireTime == 0 orelse SeekExpiredTime < OMinExpireTime, SeekExpiredTime, OMinExpireTime),
                put(min_expire_time, NMinExpireTime),
                NewTmpSeekMap = maps:put(Id, SeekGoods, TmpSeekMap),
                NewTmpSeekIds = [{Id, SeekTime}|TmpSeekIds],
                NewTmpPlayerSeekMap = maps:put(PlayerId, [Id|maps:get(PlayerId, TmpPlayerSeekMap, [])], TmpPlayerSeekMap),
                {NewTmpSeekMap, NewTmpPlayerSeekMap, NewTmpSeekIds}
        end
    end,
    {NewSeekMap, NewPlayerSeekMap, SeekIds} = maps:fold(F2, {#{}, #{}, []}, SeekMap),
    NewSeekIds = lists:sort(fun({_, TimeA}, {_, TimeB}) -> TimeA > TimeB end, SeekIds),
    NewMinExpireTime = get(min_expire_time),
    State#sell_state{
        seek_map = NewSeekMap,
        player_seek_map = NewPlayerSeekMap,
        seek_ids = NewSeekIds, 
        min_expire_time = NewMinExpireTime
    }.

do_auto_sell_down_core() ->
    ExpiredMap = erase(expired_goods_map),
    ExpiredIds = erase(expired_goods_ids),
    erase(min_expire_time),
    ExpiredSeekList = erase(expired_seek_list),
    ExpiredSeekIds = erase(expired_seek_ids),
    ExpiredList = maps:to_list(ExpiredMap),
    %?PRINT("ExpiredSeekList ~p~n", [ExpiredSeekList]),
    %?PRINT("ExpiredSeekIds ~p~n", [ExpiredSeekIds]),
    case ExpiredIds =/= [] of
        true ->
            Args = util:link_list(ExpiredIds),
            db:execute(io_lib:format(?sql_sell_delete_more, [Args])),
            %% 在子进程发自动下架的邮件
            spawn(fun() ->
                %% 自动下架日志
                F = fun({_, SellDownGoodsL}) ->
                    add_down_log(SellDownGoodsL, ?LOG_DOWN_TYPE_AUTO)
                end,
                lists:foreach(F, ExpiredList),
                send_auto_sell_down_mail(ExpiredList, 1)
            end);
        false -> skip
    end,
    case ExpiredSeekIds =/= [] of 
        true ->
            Args2 = util:link_list(ExpiredSeekIds),
            db:execute(io_lib:format(?sql_seek_delete_more, [Args2])),
            %% 在子进程发自动下架的邮件
            spawn(fun() ->
                %% 自动下架日志
                F = fun(SeekGoods) ->
                    #seek_goods{id = Id, player_id = PlayerId, gtype_id = GTypeId, goods_num = GoodsNum, unit_price = UnitPrice} = SeekGoods,
                    MoneyReturn = [{?TYPE_GOLD, 0, round(UnitPrice)}],
                    lib_log_api:log_seek_down(Id, PlayerId, ?LOG_DOWN_TYPE_AUTO, GTypeId, GoodsNum, UnitPrice, MoneyReturn),
                    ok
                end,
                lists:foreach(F, ExpiredSeekList),
                send_auto_seek_down_mail(ExpiredSeekList, 1)
            end);
        _ -> skip
    end.

send_auto_sell_down_mail([], _) -> ok;
send_auto_sell_down_mail([{_RoleId, SellDownGoodsL}|L], HasSendNum) ->
    NewHasSendNum = do_send_auto_sell_down_mail(SellDownGoodsL, HasSendNum),
    send_auto_sell_down_mail(L, NewHasSendNum).

do_send_auto_sell_down_mail([], HasSendNum) -> HasSendNum;
do_send_auto_sell_down_mail([T|L], HasSendNum) ->
    case T of
        #sell_goods{
            player_id = PlayerId,
            sell_type = SellType,
            gtype_id = GTypeId,
            goods_num = GoodsNum,
            other = GoodsOther
        } when PlayerId > 0 ->
            #goods_other{extra_attr = ExtraAttr} = GoodsOther,
            case data_goods_type:get(GTypeId) of
                #ets_goods_type{goods_name = GoodsName, color = Color} -> skip;
                _ -> GoodsName = "???", Color = ?GREEN
            end,
            ExpiredTime = lib_sell:get_expired_time(SellType),
            {H, _, _} = utime:time_to_hms(ExpiredTime),
            Title   = utext:get(2),
            Content = utext:get(3, [Color, GoodsName, H]),
            case data_goods_type:get(GTypeId) of
                #ets_goods_type{type = ?GOODS_TYPE_EQUIP, equip_type = EquipType} when EquipType > 0 -> %% 目前只有装备是带属性的
                    List = [{?TYPE_ATTR_GOODS, GTypeId, GoodsNum, [{extra_attr, ExtraAttr}]}];
                _ ->
                    List = [{?TYPE_GOODS, GTypeId, GoodsNum}]
            end,
            lib_mail_api:send_sys_mail([PlayerId], Title, Content, List),
            %% 每发20封邮件休眠300毫秒
            case HasSendNum rem 20 of
                0 -> timer:sleep(300);
                _ -> skip
            end,
            do_send_auto_sell_down_mail(L, HasSendNum + 1);
        _ ->
            do_send_auto_sell_down_mail(L, HasSendNum)
    end.

send_auto_seek_down_mail([], HasSendNum) -> HasSendNum;
send_auto_seek_down_mail([T|ExpiredSeekList], HasSendNum) ->
    case T of
        #seek_goods{
            player_id = PlayerId,
            gtype_id = GTypeId,
            goods_num = GoodsNum,
            unit_price = UnitPrice
        } ->
            MoneyReturn = [{?TYPE_GOLD, 0, round(UnitPrice)}],
            GoodsName = data_goods_type:get_name(GTypeId),
            Title = utext:get(1510007),
            Content = utext:get(1510008, [util:make_sure_binary(GoodsName), GoodsNum]),
            lib_mail_api:send_sys_mail([PlayerId], Title, Content, MoneyReturn),
            %% 每发20封邮件休眠300毫秒
            case HasSendNum rem 20 of
                0 -> timer:sleep(300);
                _ -> skip
            end,
            send_auto_seek_down_mail(ExpiredSeekList, HasSendNum + 1);
        _ ->
            send_auto_seek_down_mail(ExpiredSeekList, HasSendNum)
    end.

add_down_log([], _) -> ok;
add_down_log([T|L], LogType) ->
    case T of
        #sell_goods{
            id = SellId,
            player_id = SellerId,
            gtype_id = GTypeId,
            goods_num = GoodsNum,
            other = GoodsOther
        } ->
            #goods_other{extra_attr = ExtraAttr} = GoodsOther,
            lib_log_api:log_sell_down(SellId, GTypeId, GoodsNum, SellerId, LogType, ExtraAttr),
            add_down_log(L, LogType);
        _ ->
            add_down_log(L, LogType)
    end.

daily_timer(State) ->
    #sell_state{
        sell_record_list = SellRecordList
    } = State,
    NowTime = utime:unixtime(),
    CleanTime = lib_sell:get_record_expired_time(),
    F = fun(T, Acc) ->
        case T of
            #sell_record{
                time = TmpTime
            } when NowTime - TmpTime < CleanTime ->
                [T|Acc];
            _ -> Acc
        end
    end,
    NewSellRecordL = lists:foldl(F, [], SellRecordList),
    NewState = State#sell_state{sell_record_list = NewSellRecordL},
    clear_time_out_record_db(NowTime),
    NewState.

pack_sell_goods_list([], _PackType, PackList) -> PackList;
pack_sell_goods_list([T|L], PackType, PackList) ->
    case lib_sell:is_expired(T) of
        false ->
            Tmp = pack_sell_goods(PackType, T),
            pack_sell_goods_list(L, PackType, [Tmp|PackList]);
        true ->
            pack_sell_goods_list(L, PackType, PackList)
    end.

pack_sell_goods(PackType, SellGoods) ->
    #sell_goods{
        id              = Id,
        sell_type       = SellType,
        player_id       = PlayerId,
        specify_id      = SpecifyId,
        gtype_id        = GTypeId,
        goods_num       = GoodsNum,
        unit_price      = UnitPrice,
        other           = GoodsOther,
        time            = _Time
    } = SellGoods,
    #goods_other{rating = Rating, extra_attr = ExtraAttr} = GoodsOther,
    PackAttrList = data_attr:unified_format_extra_attr(ExtraAttr, []),
    case SellType of
        ?SELL_TYPE_MARKET ->
            {Id, PlayerId, GTypeId, GoodsNum, Rating, Rating, UnitPrice, SellType, PackAttrList};
        _ ->
            case PackType of
                ?PACK_TYPE_SELL_TO_ME ->
                    Name = lib_role:get_role_name(PlayerId);
                _ ->
                    Name = lib_role:get_role_name(SpecifyId)
            end,
            {Id, PlayerId, GTypeId, GoodsNum, Rating, Rating, UnitPrice, SellType, PackAttrList, Name}
    end.

pack_sell_record_list([], _PlayerId, PackList) -> PackList;
pack_sell_record_list([T|L], PlayerId, PackList) ->
    Tmp = pack_sell_record(PlayerId, T),
    pack_sell_record_list(L, PlayerId, [Tmp|PackList]).

pack_sell_record(PlayerId, SellRecord) ->
    #sell_record{
        player_id       = SellerId,
        sell_type       = SellType,
        buyer_id        = _BuyerId,
        gtype_id        = GTypeId,
        goods_num       = GoodsNum,
        unit_price      = UnitPrice,
        tax             = Tax,
        other           = GoodsOther,
        time            = Time
    } = SellRecord,
    #goods_other{rating = Rating, extra_attr = ExtraAttr} = GoodsOther,
    PackAttrList = data_attr:unified_format_extra_attr(ExtraAttr, []),
    case SellerId == PlayerId of
        true -> %% 出售
            Type = 1;
        false -> %% 购买
            Type = ?IF(SellType == ?SELL_TYPE_MARKET, 2, 3)
    end,
    {GTypeId, GoodsNum, Rating, Rating, Type, Tax, UnitPrice - Tax, Time, PackAttrList}.

get_refresh_time() ->
    UnixDate = utime:unixdate(),
    UnixDate + ?REFRESH_TIME.

clear_time_out_record_db() ->
    NowTime = utime:unixtime(),
    spawn(fun() -> clear_time_out_record_db(NowTime) end),
    ok.

clear_time_out_record_db(NowTime) ->
    %% 把过期的交易记录清理掉
    CleanTime = lib_sell:get_record_expired_time(),
    db:execute(io_lib:format(?sql_clean_sell_record, [NowTime-CleanTime])).

%% 数据中获取跨服市场开启信息
get_kf_sell_open_msg() ->
    Sql = io_lib:format(<<"select `status`  ,  `open_time` from   sell_local_msg">>, []),
    case db:get_row(Sql) of
        [Status, OpenTime] ->
            {Status, OpenTime};
        _ ->
            {0, 0}
    end.

%%%% 获取跨服市场定时器
%%get_kf_open_ref(0, _OpenTime) ->  %% 世界等级不满足条件， 也不满足开服天数上限
%%    [];
%%get_kf_open_ref(1, OpenTime) ->  %% 世界等级满足条件， 或者满足开服天数上限
%%    Now = utime:unixtime(),
%%    if
%%        OpenTime < Now ->  %% 已经开启了
%%            [];
%%        true ->
%%            util:send_after([], max((OpenTime - Now), 1) * 1000, self(), {open_kf_sell})  %%todo  开启跨服市场
%%    end.

%% 设置跨服市场状态
set_kf_status(NewStatus, State) ->
    %%
    NeedOpenDay = data_sell:get_cfg(kf_open_day_min),
    OpenDay = util:get_open_day(),
    #sell_state{kf_status = OldStatus} = State,
%%    ?MYLOG("sell", "calc_world_lv OldStatus ~p  Status ~p ~n", [OldStatus, Status]),
    if
        NewStatus == 0 ->
            Sql1 = io_lib:format(<<"DELETE  from  sell_local_msg">>, []),
            db:execute(Sql1),
            mod_global_counter:set_count(?MOD_SELL, 1, 0),
            State#sell_state{kf_status = 0, kf_open_time = 0};
        OldStatus =/= NewStatus ->  %% 第一次触发，设置时间
            if
                OpenDay >= NeedOpenDay ->  %% 第二天开启
                    OpenTime = utime:unixdate() + ?ONE_DAY_SECONDS;
                true ->
                    OpenTime = utime:unixdate() + ?ONE_DAY_SECONDS * (NeedOpenDay  - OpenDay)
            end,
            save_kf_msg(NewStatus, OpenTime),
            %%  发送邮件
            send_open_kf_sell_mail(OpenTime),
            State#sell_state{kf_status = NewStatus, kf_open_time = OpenTime};
        true ->
            State
    end.

save_kf_msg(Status, OpenTime) ->
    Sql1 = io_lib:format(<<"truncate   sell_local_msg">>, []),
    db:execute(Sql1),
    Sql2 = io_lib:format(<<"INSERT  into   sell_local_msg  VALUES(~p, ~p, ~p)">>, [config:get_server_id(), Status, OpenTime]),
    db:execute(Sql2).


daily_timer2(State) ->
    #sell_state{kf_status = Status, kf_open_time = OldOpenTime, market_sell_map = MarkerSellMap, seek_map = SeekMap} = State,
    if
        Status == 0-> %% 未开启
            %% 开服天数，是否到达上限
            NeedMaxOpenDay = data_sell:get_cfg(kf_open_day_max),
            OpenDay = util:get_open_day(),
            if
                OpenDay >= NeedMaxOpenDay -> %% 满足开服天数上线，不用管世界等级直接第二天开启
                    NewStatus = 1,
                    OpenTime = utime:unixdate() + ?ONE_DAY_SECONDS,
                    save_kf_msg(NewStatus, OpenTime),
                    
                    send_open_kf_sell_mail(OpenTime),
                    State#sell_state{kf_status = NewStatus, kf_open_time = OpenTime};
                true ->  %%未开启
                    State
            end;
        true ->  %% 满足了世界等级，
            Now = utime:unixtime(),
            case utime:is_same_date(Now, OldOpenTime) of  %% 同一天则下架所有商品
                true ->
                    db:execute(io_lib:format(?sql_reset_all_sell_time, [])),
                    db:execute(io_lib:format(?sql_reset_all_seek_time, [])),
                    %%
                    erase(),
                    F1 = fun(SubCategory, SubCategoryList, {SubSellMap}) ->
                        NewSubCategoryList = [SellGoods#sell_goods{time = 0} || SellGoods<-SubCategoryList],
                        NewSubSellMap = maps:put(SubCategory, NewSubCategoryList, SubSellMap),
                        {NewSubSellMap}
                         end,
                    F2 = fun(Category, CategorySellMap, {SellMap}) ->
                        {NewCategorySellMap} = maps:fold(F1, {#{}}, CategorySellMap),
                        NewSellMap = maps:put(Category, NewCategorySellMap, SellMap),
                        {NewSellMap}
                         end,
                    {NewMarketSellMap} = maps:fold(F2, {#{}}, MarkerSellMap),
                    SeekMapList = maps:to_list(SeekMap),
                    NewSeekMapList = [{SeekId, SeekRecord#seek_goods{time = 0}}|| {SeekId, SeekRecord} <- SeekMapList],
                    mod_global_counter:set_count(?MOD_SELL, 1, 1),
                    %% 开启跨服市场
                    mod_sys_sell:open_kf_sell(),
                    State#sell_state{min_expire_time = 0, market_sell_map = NewMarketSellMap,
                        seek_map = maps:from_list(NewSeekMapList)};
                _ ->
                    State
            end
    end.

%%  发送通知邮件
send_open_kf_sell_mail(OpenTime) ->
    DiffDay = utime:diff_days(OpenTime, utime:unixtime()),
    Title = utext:get(1510009),
    Content = utext:get(1510010, [DiffDay]),
    NeedLv = data_sell:get_cfg(open_lv),
    Sql = io_lib:format(<<"select  id  from  player_low  where   lv >=  ~p">>, [NeedLv]),
    Ids = db:get_all(Sql),
    Ids2 = [Id || [Id] <- Ids],
    lib_mail_api:send_sys_mail(Ids2, Title, Content, []).

%% 是否开启跨服市场
is_kf_open(State) ->
    #sell_state{kf_status = Status, kf_open_time = Time} = State,
    Now = utime:unixtime(),
    if
        Status == 1 andalso Now >= Time ->  %% 等级满足，且开服天数满足  或者  满足最大开服天数
            true;
        true ->
            false
    end.

market_shout(Args, State) ->
    [SellId, PlayerId, PlayerName, IsSellUp, IsMask|_] = Args,
    #sell_state{player_market_sell_map = PlayerSellMap} = State,
    PlayerSellList = maps:get(PlayerId, PlayerSellMap, []),
    case lists:keyfind(SellId, #sell_goods.id, PlayerSellList) of
        #sell_goods{ gtype_id = GTypeId, unit_price = Price, category = Type, sub_category = SubType} ->
            ok;
        _ ->
            GTypeId = 0, Price = 0, Type = 0, SubType = 0
    end,
    case GTypeId of
        0 ->
            skip;
        _ ->
            TvId = ?IF(IsMask, 4, 3),
            case TvId of
                3 ->
                    BinData = lib_chat:make_tv(?MOD_SELL, TvId, [PlayerName, PlayerId, Price, GTypeId, Type, SubType, SellId]);
                _ ->
                    BinData = lib_chat:make_tv(?MOD_SELL, TvId, [Price, GTypeId, Type, SubType, SellId])
            end,
            mod_chat_agent:send_msg([{all, BinData}])
    end,
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_sell, market_shout_cast_back, [SellId, GTypeId, IsSellUp]).

