%% ---------------------------------------------------------------------------
%% @doc 交易
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------
-module(lib_sell_mod_kf).

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
-include("clusters.hrl").


-export([init/0, init/1, make_record/2]).

-export([
	list_category_sell_num/4
	, list_sub_category_sell_goods/8
	, filter_goods/5
	, send_sell_up_view_info/5
	, check_sell_up_goods/6
    , sell_up/3
	, sell_down/7
	, pay_sell/10
	, auto_sell_down/1
	, pack_sell_goods_list/3
	, pack_sell_record_list/3
	, daily_timer/1
	, check_seek_goods/6
	, seek_goods/2
	, delete_seek/4
	, sell_seek_goods/12
	, send_self_seek_list/4
	, send_seek_list/6
	, calc_world_lv/0  %% 计算世界等级，是否开启跨服市场
	, get_auction_id/0
	, send_to_uid_kf/3
	, handle_new_merge_server_ids/7
	, gm_repair_seek/0
	, is_connect/2
    , market_shout/2
    , send_bin_to_zone_local/1
]).

make_record(sql_sell_goods, [Id, PlayerServerId, PlayerServerNum, PlayerId, RoleName, VipType, VipLv, SellType, SpecifyServerId, SpecifyId, GTypeId, Category, SubCategory, GoodsNum, UnitPrice, ExtraAttrStr, Time]) ->
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
	make_record(sell_goods, [Id, PlayerServerId, PlayerServerNum, PlayerId, RoleName, VipType, VipLv, SellType, SpecifyServerId, SpecifyId, GTypeId, Category, SubCategory, GoodsNum, UnitPrice, GoodsOther, Time]);
make_record(sell_goods, [Id, PlayerServerId, PlayerServerNum, PlayerId, RoleName, VipType, VipLv, SellType, SpecifyServerId, SpecifyId, GTypeId, Category, SubCategory, GoodsNum, UnitPrice, GoodsOther, Time]) ->
	#sell_goods_kf{
		id = Id,
		server_id = PlayerServerId,
		server_num = PlayerServerNum,
		player_id = PlayerId,
		sell_type = SellType,
		specify_server = SpecifyServerId,
		specify_id = SpecifyId,
		gtype_id = GTypeId,
		category = Category,
		sub_category = SubCategory,
		goods_num = GoodsNum,
		unit_price = UnitPrice,
		other = GoodsOther,
		vip_lv = VipLv,
		vip_type = VipType,
		role_name = RoleName,
		time = Time
	};
make_record(sql_sell_record, [ServerId, ServerNum, PlayerId, BuyerServerId, BuyerServerNum, BuyerId, SellType, GTypeId, GoodsNum, UnitPrice, Tax, ExtraAttrStr, Time]) ->
	ExtraAttr = util:bitstring_to_term(ExtraAttrStr),
	GoodsOther = case data_goods_type:get(GTypeId) of
		             GoodsTypeInfo when is_record(GoodsTypeInfo, ets_goods_type) ->
			             Rating = lib_equip:cal_equip_rating(GoodsTypeInfo, ExtraAttr),
			             #goods_other{rating = Rating, extra_attr = ExtraAttr};
		             _ -> #goods_other{}
	             end,
	make_record(sell_record, [ServerId, ServerNum, PlayerId, BuyerServerId, BuyerServerNum, BuyerId, SellType, GTypeId, GoodsNum, UnitPrice, Tax, GoodsOther, Time]);
make_record(sell_record, [ServerId, ServerNum, PlayerId, BuyerServerId, BuyerServerNum, BuyerId, SellType, GTypeId, GoodsNum, UnitPrice, Tax, GoodsOther, Time]) ->
	#sell_record_kf{
		server_id = ServerId,
		server_num = ServerNum,
		buyer_server_id = BuyerServerId,
		buyer_server_num = BuyerServerNum,
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
make_record(seek_goods, [Id, ServerId, ServerNum, PlayerId, RoleName, GTypeId, Category, SubCategory, GoodsNum, UnitPrice, Time]) ->
	#seek_goods_kf{
		id = Id,
		server_id = ServerId,
		server_num = ServerNum,
		player_id = PlayerId,
		role_name = RoleName,
		gtype_id = GTypeId,
		category = Category,
		sub_category = SubCategory,
		goods_num = GoodsNum,
		unit_price = UnitPrice,
		time = Time
	};
make_record(_, _) -> no_match.

init() ->
	clear_time_out_record_db(),
%%    case util:get_merge_day() of  跨服不需要
%%        1 -> %% 合服第一天重置上架时间为0，自动下架所有商品
%%            db:execute(io_lib:format(?sql_reset_all_sell_time, [])),
%%            db:execute(io_lib:format(?sql_reset_all_seek_time, []));
%%        _ -> skip
%%    end,
	ZoneMap = get_zone_map(),
	SellRecordList = db:get_all(io_lib:format(?sql_sell_record_select_kf, [])),  %% 交易记录
	SellList = db:get_all(io_lib:format(?sql_sell_select_kf, [])),  %%出售列表
	SeekList = db:get_all(io_lib:format(?sql_seek_select_kf, [])),  %%求购列表
	
	{SellZoneList, MinExpiredTime} = init_goods_sell_map(SellList, ZoneMap, [], 0),
	{SeekZoneList, NewMinExpiredTime} = init_seek_map(SeekList, ZoneMap, MinExpiredTime),
	ZoneRecordList = init_sell_record_list(SellRecordList, ZoneMap, []),
	% ?PRINT("init ~p~n", [SeekMap]),
	% ?PRINT("init ~p~n", [SeekIds]),
	% ?PRINT("init ~p~n", [PlayerSeekMap]),
	F1 = fun({ZoneId, MarketSellMap, P2PSellMap, PlayerSellMap}, AccSellZoneMap) ->
		OldSellStateZone = maps:get(ZoneId, AccSellZoneMap, #sell_state_zone{}),
		SellStateZone = OldSellStateZone#sell_state_zone{zone = ZoneId, market_sell_map = MarketSellMap,
			p2p_sell_map = P2PSellMap, player_market_sell_map = PlayerSellMap},
		maps:put(ZoneId, SellStateZone, AccSellZoneMap)
	     end,
	SellZoneMap1 = lists:foldl(F1, #{}, SellZoneList),
	F2 = fun({ZoneId, SeekMap, PlayerSeekMap, SeekIds}, AccSellZoneMap) ->
		OldSellStateZone = maps:get(ZoneId, AccSellZoneMap, #sell_state_zone{}),
		SellStateZone = OldSellStateZone#sell_state_zone{seek_map = SeekMap,
			player_seek_map = PlayerSeekMap, seek_ids = SeekIds},
		maps:put(ZoneId, SellStateZone, AccSellZoneMap)
	     end,
	SellZoneMap2 = lists:foldl(F2, SellZoneMap1, SeekZoneList),
	F3 = fun({ZoneId, SellRecordListFun, PriceMap}, AccSellZoneMap) ->
		OldSellStateZone = maps:get(ZoneId, AccSellZoneMap, #sell_state_zone{}),
		SellStateZone = OldSellStateZone#sell_state_zone{sell_record_list = SellRecordListFun, sell_price_map = PriceMap},
		maps:put(ZoneId, SellStateZone, AccSellZoneMap)
	     end,
	SellZoneMap3 = lists:foldl(F3, SellZoneMap2, ZoneRecordList),
%%	?MYLOG("sell", "SellZoneMap3 ~p~n", [SellZoneMap3]),
	#sell_state_kf{
		zone_map = SellZoneMap3,
		min_expire_time = NewMinExpiredTime
	}.
%%    #sell_state_zone{
%%        p2p_sell_map = P2PSellMap,
%%        market_sell_map = MarketSellMap,
%%        player_market_sell_map = PlayerSellMap,
%%        sell_record_list = RealSellRecordList,
%%        sell_price_map = PriceMap,
%%        seek_map = SeekMap,
%%        player_seek_map = PlayerSeekMap,
%%        seek_ids = SeekIds,
%%        min_expire_time = NewMinExpiredTime
%%    }.


init(ConnectServerIds) ->
	clear_time_out_record_db(),
%%    case util:get_merge_day() of  跨服不需要
%%        1 -> %% 合服第一天重置上架时间为0，自动下架所有商品
%%            db:execute(io_lib:format(?sql_reset_all_sell_time, [])),
%%            db:execute(io_lib:format(?sql_reset_all_seek_time, []));
%%        _ -> skip
%%    end,
	ZoneMap = get_zone_map(),
	SellRecordList = db:get_all(io_lib:format(?sql_sell_record_select_kf, [])),  %% 交易记录
	SellList = db:get_all(io_lib:format(?sql_sell_select_kf, [])),  %%出售列表
	SeekList = db:get_all(io_lib:format(?sql_seek_select_kf, [])),  %%求购列表
	
	{SellZoneList, MinExpiredTime} = init_goods_sell_map(SellList, ZoneMap, [], 0),
	{SeekZoneList, NewMinExpiredTime} = init_seek_map(SeekList, ZoneMap, MinExpiredTime),
	ZoneRecordList = init_sell_record_list(SellRecordList, ZoneMap, []),
	% ?PRINT("init ~p~n", [SeekMap]),
	% ?PRINT("init ~p~n", [SeekIds]),
	% ?PRINT("init ~p~n", [PlayerSeekMap]),
	F1 = fun({ZoneId, MarketSellMap, P2PSellMap, PlayerSellMap}, AccSellZoneMap) ->
		OldSellStateZone = maps:get(ZoneId, AccSellZoneMap, #sell_state_zone{}),
		SellStateZone = OldSellStateZone#sell_state_zone{zone = ZoneId, market_sell_map = MarketSellMap,
			p2p_sell_map = P2PSellMap, player_market_sell_map = PlayerSellMap},
		maps:put(ZoneId, SellStateZone, AccSellZoneMap)
	     end,
	SellZoneMap1 = lists:foldl(F1, #{}, SellZoneList),
	F2 = fun({ZoneId, SeekMap, PlayerSeekMap, SeekIds}, AccSellZoneMap) ->
		OldSellStateZone = maps:get(ZoneId, AccSellZoneMap, #sell_state_zone{}),
		SellStateZone = OldSellStateZone#sell_state_zone{seek_map = SeekMap,
			player_seek_map = PlayerSeekMap, seek_ids = SeekIds},
		maps:put(ZoneId, SellStateZone, AccSellZoneMap)
	     end,
	SellZoneMap2 = lists:foldl(F2, SellZoneMap1, SeekZoneList),
	F3 = fun({ZoneId, SellRecordListFun, PriceMap}, AccSellZoneMap) ->
		OldSellStateZone = maps:get(ZoneId, AccSellZoneMap, #sell_state_zone{}),
		SellStateZone = OldSellStateZone#sell_state_zone{sell_record_list = SellRecordListFun, sell_price_map = PriceMap},
		maps:put(ZoneId, SellStateZone, AccSellZoneMap)
	     end,
	SellZoneMap3 = lists:foldl(F3, SellZoneMap2, ZoneRecordList),
%%	?MYLOG("sell", "SellZoneMap3 ~p~n", [SellZoneMap3]),
	#sell_state_kf{
		zone_map = SellZoneMap3,
		min_expire_time = NewMinExpiredTime
		,connect_servers = ConnectServerIds
	}.
	

init_goods_sell_map([], _ZoneMap, ZoneSellList, _MinExpiredTime) ->
	{ZoneSellList, _MinExpiredTime};
init_goods_sell_map([T | L], ZoneMap, ZoneSellList, MinExpiredTime) ->
	SellGoods = make_record(sql_sell_goods, T),
	#sell_goods_kf{player_id = PlayerId, sell_type = SellType, category = Category, sub_category = SubCategory, time = SellTime, server_id = ServerId} = SellGoods,
	SellExpiredTime = ?IF(SellTime > 0, lib_sell:get_expired_time(SellType) + SellTime, 0),
	ZoneId = maps:get(ServerId, ZoneMap, 0),
	NewMinExpireTime = ?IF(MinExpiredTime == 0 orelse SellExpiredTime < MinExpiredTime, SellExpiredTime, MinExpiredTime),
	case lists:keyfind(ZoneId, 1, ZoneSellList) of
		{ZoneId, MarketSellMap, P2PSellMap, PlayerSellMap} ->
			skip;
		_ ->
			MarketSellMap = #{},
			P2PSellMap = #{},
			PlayerSellMap = #{}
	end,
	case SellType of
		?SELL_TYPE_MARKET ->
			CategorySellMap = maps:get(Category, MarketSellMap, #{}),
			List = maps:get(SubCategory, CategorySellMap, []),
			NewCategorySellMap = maps:put(SubCategory, [SellGoods | List], CategorySellMap),
			NewMarketSellMap = maps:put(Category, NewCategorySellMap, MarketSellMap),
			PlayerSellList = maps:get(PlayerId, PlayerSellMap, []),
			NewPlayerSellMap = maps:put(PlayerId, [SellGoods | PlayerSellList], PlayerSellMap),
			NewZoneSellList = lists:keystore(ZoneId, 1, ZoneSellList,
				{ZoneId, NewMarketSellMap, P2PSellMap, NewPlayerSellMap}),
			init_goods_sell_map(L, ZoneMap, NewZoneSellList, NewMinExpireTime);
		?SELL_TYPE_P2P ->
			List = maps:get(PlayerId, P2PSellMap, []),
			NewP2PSellMap = maps:put(PlayerId, [SellGoods | List], P2PSellMap),
			NewZoneSellList = lists:keystore(ZoneId, 1, ZoneSellList,
				{ZoneId, MarketSellMap, NewP2PSellMap, PlayerSellMap}),
			init_goods_sell_map(L, ZoneMap, NewZoneSellList, NewMinExpireTime);
		_ ->
			init_goods_sell_map(L, ZoneMap, ZoneSellList, NewMinExpireTime)
	end.


init_sell_record_list([], _ZoneMap, ZoneRecordList) ->
	%% 只保留需要计算的参考价格的有效成交价格记录
	F1 = fun({ZoneId, SellRecordList, PriceMap}, AccZoneList) ->
		F = fun(_GTypeId, PriceRecordList) ->
			sort_price_list(PriceRecordList, 1, ?SELL_PRICE_REFER_NUM, [])
		    end,
		NewPriceMap = maps:map(F, PriceMap),
%%        {SellRecordList, NewPriceMap},
		[{ZoneId, SellRecordList, NewPriceMap} | AccZoneList]
	     end,
	lists:foldl(F1, [], ZoneRecordList);
init_sell_record_list([T | L], ZoneMap, ZoneRecordList) ->
	SellRecord = make_record(sql_sell_record, T),
	#sell_record_kf{gtype_id = GTypeId, unit_price = UnitPrice, time = Time, server_id = ServerId} = SellRecord,
	ZoneId = maps:get(ServerId, ZoneMap, 0),
	case lists:keyfind(ZoneId, 1, ZoneRecordList) of
		{ZoneId, SellRecordList, PriceMap} ->
			skip;
		_ ->
			SellRecordList = [],
			PriceMap = #{}
	end,
	PriceRecord = make_record(sell_price, [GTypeId, UnitPrice, Time]),
	PriceList = maps:get(GTypeId, PriceMap, []),
	NewPriceMap = maps:put(GTypeId, [PriceRecord | PriceList], PriceMap),
	ZoneRecordListNew = lists:keystore(ZoneId, 1, ZoneRecordList,
		{ZoneId, [SellRecord | SellRecordList], NewPriceMap}),
	init_sell_record_list(L, ZoneMap, ZoneRecordListNew).

init_seek_map(SeekList, ZoneMap, MinExpiredTime) ->
	F = fun([_, _, _, _, _, _, _, _, _, _, TimeA], [_, _, _, _, _, _, _, _, _, _, TimeB]) -> TimeA < TimeB end,
	SortSeekList = lists:sort(F, SeekList),
	init_seek_map_do(SortSeekList, ZoneMap, [], MinExpiredTime).

init_seek_map_do([], _ZoneMap, SeekZoneList, MinExpiredTime) ->
	{SeekZoneList, MinExpiredTime};
init_seek_map_do([Item | SortSeekList], ZoneMap, SeekZoneList, MinExpiredTime) ->
	[Id, ServerId, ServerNum, PlayerId, RoleName, GTypeId, Category, SubCategory, GoodsNum, UnitPrice, Time] = Item,
	SeekGoods = #seek_goods_kf{
		id = Id, player_id = PlayerId, role_name = RoleName, category = Category, sub_category = SubCategory,
		gtype_id = GTypeId, goods_num = GoodsNum, unit_price = UnitPrice, time = Time, server_id = ServerId, server_num = ServerNum
	},
	ZoneId = maps:get(ServerId, ZoneMap, 0),
	SeekExpiredTime = ?IF(Time > 0, lib_sell:get_expired_time(?SELL_TYPE_SEEK) + Time, 0),
	NewMinExpireTime = ?IF(MinExpiredTime == 0 orelse SeekExpiredTime < MinExpiredTime, SeekExpiredTime, MinExpiredTime),
	case lists:keyfind(ZoneId, 1, SeekZoneList) of
		{ZoneId, SeekMap, PlayerSeekMap, SeekIds} ->
			skip;
		_ ->
			SeekMap = #{},
			PlayerSeekMap = #{},
			SeekIds = []
	end,
	NewSeekMap = maps:put(Id, SeekGoods, SeekMap),
	NewSeekIds = [{Id, Time} | SeekIds],
	SeekIdList = maps:get(PlayerId, PlayerSeekMap, []),
	NewPlayerSeekMap = maps:put(PlayerId, [Id | SeekIdList], PlayerSeekMap),
	NewSeekZoneList = lists:keystore(ZoneId, 1, SeekZoneList,
		{ZoneId, NewSeekMap, NewPlayerSeekMap, NewSeekIds}),
	init_seek_map_do(SortSeekList, ZoneMap, NewSeekZoneList, NewMinExpireTime).


%% 物品出售记录单价排序
sort_price_list([], _Len, _MaxLen, AccList)                 -> AccList;
sort_price_list(_L, Len, MaxLen, AccList) when Len > MaxLen -> AccList;
sort_price_list([T | L], Len, MaxLen, AccList) ->
	{MaxItem, List} = get_max(L, T, []),
	NewAccList = [MaxItem | AccList],
	sort_price_list(List, Len + 1, MaxLen, NewAccList).

get_max([], Max, AccList) -> {Max, AccList};
get_max([T | L], Max, AccList) ->
	#sell_price{unit_price = TmpPrice, time = TmpUtime} = T,
	#sell_price{unit_price = MaxPrice, time = MaxUtime} = Max,
	if
		TmpPrice > MaxPrice ->
			get_max(L, T, [Max | AccList]);
		TmpPrice == MaxPrice ->
			case TmpUtime =< MaxUtime of
				true ->
					get_max(L, T, [Max | AccList]);
				false ->
					get_max(L, T, [T | AccList])
			end;
		true ->
			get_max(L, T, [T | AccList])
	end.

list_category_sell_num(State, ServerId, PlayerId, Category) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{category_change = CategoryChangeMap} = ZoneMsg,
	IsChange = maps:get(Category, CategoryChangeMap, true),
	%NowTime = utime:unixtime(),
	%?PRINT("SellNumList Category ~p~n", [Category]),
	case get({?MODULE, category_sell_num, ZoneId, Category}) of
		{_CalcTime, SellNumList} when IsChange == false ->
			%?PRINT("SellNumList old ~p~n", [SellNumList]),
			NewCategoryChangeMap = CategoryChangeMap;
		_ ->
			NewCategoryChangeMap = maps:put(Category, false, CategoryChangeMap),
			SellNumList = list_category_sell_num_helper(ZoneMsg, Category)
%%            ?PRINT("SellNumList new ~p~n", [SellNumList])
	end,
	{ok, Bin} = pt_151:write(15101, [Category, SellNumList]),
	send_to_uid_kf(ServerId, PlayerId, Bin),
%%    lib_server_send:send_to_uid(PlayerId, pt_151, 15101, [Category, SellNumList]),
	ZoneMsgNew = ZoneMsg#sell_state_zone{category_change = NewCategoryChangeMap},
	ZoneMapNew = maps:put(ZoneId, ZoneMsgNew, ZoneMap),
%%	?MYLOG("sell", "ZoneMapNew~p~n", [ZoneMapNew]),
	State#sell_state_kf{zone_map = ZoneMapNew}.

list_category_sell_num_helper(State, Category) ->
	#sell_state_zone{market_sell_map = MartSellMap, zone = ZoneId} = State,
	CategorySellMap = maps:get(Category, MartSellMap, #{}),
	F = fun(SubCategory, OnSellList, AccL) ->
		OnSellNum = lib_sell_kf:count_goods_num(OnSellList),
		[{SubCategory, OnSellNum} | AccL]
	    end,
	SellNumList = maps:fold(F, [], CategorySellMap),
	SubCategoryList = data_sell:get_sub_category(Category),
	case SellNumList =/= [] andalso lists:member(0, SubCategoryList) of
		true -> %% 统计当前大类下所有出售物品的数量
			F1 = fun({_Key, Val}, Acc) -> Acc + Val end,
			SumNum = lists:foldl(F1, 0, SellNumList),
			LastSellNumL = [{0, SumNum} | SellNumList];
		false ->
			LastSellNumL = SellNumList
	end,
	put({?MODULE, category_sell_num, ZoneId, Category}, {utime:unixtime(), LastSellNumL}),
	LastSellNumL.

list_sub_category_sell_goods(State, ServerId, PlayerId, Category, SubCategory, Stage, Star, Color) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{market_sell_map = MarketSellMap} = ZoneMsg,
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
%%    ?PRINT("list goods ~p~n", [PackList]),
	{ok, Bin} = pt_151:write(15102, [Category, SubCategory, PackList]),
	send_to_uid_kf(ServerId, PlayerId, Bin).
%%    lib_server_send:send_to_uid(PlayerId, pt_151, 15102, [Category, SubCategory, PackList]).

filter_goods(State, ServerId, PlayerId, Args, Cmd) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{market_sell_map = MarketSellMap} = ZoneMsg,
	MarketSellL = maps:to_list(MarketSellMap),
	List = do_filter_goods(MarketSellL, Args),
	PackList = pack_sell_goods_list(List, ?PACK_TYPE_MARKET, []),
	{ok, Bin} = pt_151:write(Cmd, [PackList]),
	send_to_uid_kf(ServerId, PlayerId, Bin).
%%    lib_server_send:send_to_uid(PlayerId, pt_151, Cmd, [PackList]).

do_filter_goods(SellL, [?FILTER_TYPE_SUBCATEGORY_STAGE_AND_STAR, FilterStage, FilterStar, FilterColor]) ->
	F = fun(T) ->
		case T of
			#sell_goods_kf{gtype_id = GTypeId} ->
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
			#sell_goods_kf{gtype_id = GTypeId} ->
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
					#sell_goods_kf{gtype_id = GTypeId} ->
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
			#sell_goods_kf{gtype_id = GTypeId} -> true;
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

send_sell_up_view_info(State, ServerId, PlayerId, GoodsId, GTypeId) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{market_sell_map = _MarketSellMap, sell_price_map = SellPriceMap} = ZoneMsg,
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
	{ok, Bin} = pt_151:write(15105, [GoodsId, PriceType, Price]),
	send_to_uid_kf(ServerId, PlayerId, Bin).
%%    lib_server_send:send_to_uid(PlayerId, pt_151, 15105, [GoodsId, PriceType, Price]).

check_sell_up_goods(State, ?SELL_TYPE_MARKET, ServerId, PlayerId, _PlayerVipLv, _SpecifyId) ->
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{player_market_sell_map = PlayerMarketSellMap} = ZoneMsg,
	PlayerSellGoodsL = maps:get(PlayerId, PlayerMarketSellMap, []),
	OnSellNum = lib_sell_kf:count_on_sell_num(PlayerSellGoodsL),
	%% 检测是否达到上架最大数量上限
	case OnSellNum < data_sell:get_cfg(market_max_sell_num) of
		true -> ok;
		false -> {fail, ?ERRCODE(err151_max_sell_up_num)}
	end;
check_sell_up_goods(State, ?SELL_TYPE_P2P, ServerId, PlayerId, _PlayerVipLv, SpecifyId) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{p2p_sell_map = P2PSellMap, sell_record_list = SellRecordList} = ZoneMsg,
	PlayerSellList = maps:get(PlayerId, P2PSellMap, []),
	OnSellNum = lib_sell_kf:count_on_sell_num(PlayerSellList),
	%% 检测是否达到上架最大数量上限
	case OnSellNum < data_sell:get_cfg(p2p_max_sell_num) of
		true ->
			RefreshTime = get_refresh_time(),
			F = fun(T, Acc) ->
				case T of
					#sell_record_kf{
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
check_sell_up_goods(_, _, _, _, _, _) -> {fail, ?FAIL}.

sell_up(State, SellGoods, IsShout) ->
	NowTime = utime:unixtime(),
	Id = get_auction_id(),
	#sell_goods_kf{
		server_id = ServerId,
		server_num = ServerNum,
		player_id = PlayerId,
		role_name = RoleName,
		vip_type = VipType,
		vip_lv = VipLv,
		sell_type = SellType,
		specify_server = SpecifyServer,
		specify_id = SpecifyId,
		category = Category,
		sub_category = SubCategory,
		gtype_id = GTypeId,
		goods_num = GoodsNum,
		unit_price = UnitPrice,
		other = #goods_other{extra_attr = ExtraAttr}
	} = SellGoods,
	db:execute(io_lib:format(?sql_sell_insert_kf,
		[Id, ServerId, ServerNum, PlayerId, RoleName, VipType, VipLv, SellType, SpecifyServer, SpecifyId,
			GTypeId, Category, SubCategory, GoodsNum, UnitPrice, util:term_to_bitstring(ExtraAttr), NowTime])),
	%% 商品上架日志
	lib_log_api:log_sell_up_kf(ServerId, ServerNum, PlayerId, SellType, Id, GTypeId, GoodsNum, UnitPrice, SpecifyId, ExtraAttr),  %%   增加跨服上架日志
	
	%% 上架玩家商品
	NewSellGoods = SellGoods#sell_goods_kf{id = Id, time = NowTime},
    case IsShout == 1 andalso SellType =/= ?SELL_TYPE_SEEK of
        true ->
            Args = [PlayerId, ?APPLY_CAST_STATUS, lib_sell, market_shout, [Id, IsShout]],
            mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args);
        _ ->
            skip
    end,
	NewState = do_sell_up(SellType, State, NewSellGoods),
	{?SUCCESS, NewState}.

do_sell_up(?SELL_TYPE_MARKET, State, SellGoods) ->
	#sell_goods_kf{player_id = PlayerId, category = Category, sub_category = SubCategory, time = SellTime, server_id = ServerId} = SellGoods,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap, min_expire_time = MinExpiredTime} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{market_sell_map = MarketSellMap, player_market_sell_map = PlayerSellMap, category_change = CategoryChangeMap} = ZoneMsg,
	SellExpiredTime = SellTime + lib_sell_kf:get_expired_time(?SELL_TYPE_MARKET),
	CategorySellMap = maps:get(Category, MarketSellMap, #{}),
	SubCategorySellL = maps:get(SubCategory, CategorySellMap, []),
	NewCategorySellMap = maps:put(SubCategory, [SellGoods | SubCategorySellL], CategorySellMap),
	NewMarketSellMap = maps:put(Category, NewCategorySellMap, MarketSellMap),
	PlayerSellList = maps:get(PlayerId, PlayerSellMap, []),
	NewPlayerSellMap = maps:put(PlayerId, [SellGoods | PlayerSellList], PlayerSellMap),
	NewMinExpireTime = ?IF(MinExpiredTime == 0 orelse SellExpiredTime < MinExpiredTime, SellExpiredTime, MinExpiredTime),
	NewCategoryChangeMap = maps:put(Category, true, CategoryChangeMap),
	NewZoneMsg = ZoneMsg#sell_state_zone{market_sell_map = NewMarketSellMap,
		player_market_sell_map = NewPlayerSellMap, category_change = NewCategoryChangeMap},
	NewZoneMap = maps:put(ZoneId, NewZoneMsg, ZoneMap),
	State#sell_state_kf{zone_map = NewZoneMap, min_expire_time = NewMinExpireTime};
do_sell_up(?SELL_TYPE_P2P, State, SellGoods) ->
	#sell_goods_kf{player_id = PlayerId, time = SellTime, server_id = ServerId} = SellGoods,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap, min_expire_time = MinExpiredTime} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{p2p_sell_map = P2PSellMap} = ZoneMsg,
	SellExpiredTime = SellTime + lib_sell_kf:get_expired_time(?SELL_TYPE_P2P),
	PlayerSellList = maps:get(PlayerId, P2PSellMap, []),
	NewP2PSellMap = maps:put(PlayerId, [SellGoods | PlayerSellList], P2PSellMap),
	NewMinExpireTime = ?IF(MinExpiredTime == 0 orelse SellExpiredTime < MinExpiredTime, SellExpiredTime, MinExpiredTime),
	NewZoneMsg = ZoneMsg#sell_state_zone{p2p_sell_map = NewP2PSellMap},
	NewZoneMap = maps:put(ZoneId, NewZoneMsg, ZoneMap),
	State#sell_state_kf{zone_map = NewZoneMap, min_expire_time = NewMinExpireTime}.

%% 下架
sell_down(State, ServerId, PlayerId, ?SELL_TYPE_MARKET, Id, GTypeId, GoodsNum) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{
		market_sell_map = MarketSellMap,
		player_market_sell_map = PlayerSellMap,
		category_change = CategoryChangeMap
	} = ZoneMsg,
	case data_goods_type:get(GTypeId) of
		#ets_goods_type{
			sell_category = Category,
			sell_subcategory = SubCategory
		} -> skip;
		_ -> Category = 0, SubCategory = 0
	end,
	CategorySellMap = maps:get(Category, MarketSellMap, #{}),
	SubCategorySellL = maps:get(SubCategory, CategorySellMap, []),
	SellGoods = lists:keyfind(Id, #sell_goods_kf.id, SubCategorySellL),
	if
		SellGoods == false -> {?ERRCODE(err151_goods_not_exist), State};
		SellGoods#sell_goods_kf.player_id =/= PlayerId -> {?ERRCODE(err151_not_seller), State};
		SellGoods#sell_goods_kf.gtype_id =/= GTypeId -> {?ERRCODE(err151_goods_info_err), State};
		SellGoods#sell_goods_kf.goods_num =/= GoodsNum -> {?ERRCODE(err151_goods_info_err), State};
		true ->
			db:execute(io_lib:format(?sql_sell_delete_kf, [Id])),
			NewSubCategorySellL = lists:keydelete(Id, #sell_goods_kf.id, SubCategorySellL),
			NewCategorySellMap = maps:put(SubCategory, NewSubCategorySellL, CategorySellMap),
			NewMarketSellMap = maps:put(Category, NewCategorySellMap, MarketSellMap),
			PlayerSellList = maps:get(PlayerId, PlayerSellMap, []),
			NewPlayerSellList = lists:keydelete(Id, #sell_goods_kf.id, PlayerSellList),
			NewPlayerSellMap = maps:put(PlayerId, NewPlayerSellList, PlayerSellMap),
			NewCategoryChangeMap = maps:put(Category, true, CategoryChangeMap),
			%% 下架日志
			add_down_log([SellGoods], ?LOG_DOWN_TYPE_MANUAL),
			NewZoneMsg = ZoneMsg#sell_state_zone{
				market_sell_map = NewMarketSellMap,
				player_market_sell_map = NewPlayerSellMap,
				category_change = NewCategoryChangeMap
			},
			NewZoneMap = maps:put(ZoneId, NewZoneMsg, ZoneMap),
			NewState = State#sell_state_kf{zone_map = NewZoneMap},
			{{ok, SellGoods}, NewState}
	end;
sell_down(State, ServerId, PlayerId, ?SELL_TYPE_P2P, Id, GTypeId, GoodsNum) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{p2p_sell_map = P2PSellMap} = ZoneMsg,
	PlayerSellList = maps:get(PlayerId, P2PSellMap, []),
	SellGoods = lists:keyfind(Id, #sell_goods_kf.id, PlayerSellList),
	if
		SellGoods == false -> {?ERRCODE(err151_goods_not_exist), State};
		SellGoods#sell_goods_kf.player_id =/= PlayerId -> {?ERRCODE(err151_not_seller), State};
		SellGoods#sell_goods_kf.gtype_id =/= GTypeId -> {?ERRCODE(err151_goods_info_err), State};
		SellGoods#sell_goods_kf.goods_num =/= GoodsNum -> {?ERRCODE(err151_goods_info_err), State};
		true ->
			db:execute(io_lib:format(?sql_sell_delete_kf, [Id])),
			NewPlayerSellList = lists:keydelete(Id, #sell_goods_kf.id, PlayerSellList),
			NewP2PSellMap = maps:put(PlayerId, NewPlayerSellList, P2PSellMap),
			%% 下架日志
			add_down_log([SellGoods], ?LOG_DOWN_TYPE_MANUAL),
%%            %% 更新对方指定交易小红点信息  无指定交易了
%%            case misc:is_process_alive(misc:get_player_process(SellGoods#sell_goods.specify_id)) of
%%                true ->
%%                    mod_sell:send_p2p_red_point(SellGoods#sell_goods.specify_id);
%%                _ ->
%%                    skip
%%            end,
			NewZoneMsg = ZoneMsg#sell_state_zone{p2p_sell_map = NewP2PSellMap},
			NewZoneMap = maps:put(ZoneId, NewZoneMsg, ZoneMap),
			NewState = State#sell_state_kf{zone_map = NewZoneMap},
			{{ok, SellGoods}, NewState}
	end.

%% 购买商品
pay_sell(State, ServerId, ServerNum, PlayerId, ?SELL_TYPE_MARKET, Id, SellerId, GTypeId, GoodsNum, UnitPrice) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{
		market_sell_map = MarketSellMap,
		player_market_sell_map = PlayerSellMap,
		sell_record_list = SellRecordList,
		sell_price_map = SellPriceMap,
		category_change = CategoryChangeMap
	} = ZoneMsg,
	case data_goods_type:get(GTypeId) of
		#ets_goods_type{
			sell_category = Category,
			sell_subcategory = SubCategory
		} -> skip;
		_ -> Category = 0, SubCategory = 0
	end,
	CategorySellMap = maps:get(Category, MarketSellMap, #{}),
	SubCategorySellL = maps:get(SubCategory, CategorySellMap, []),
	SellGoods = lists:keyfind(Id, #sell_goods_kf.id, SubCategorySellL),
	AllNodeList = mod_clusters_center:get_all_node(),
	if
		SellGoods == false -> {?ERRCODE(err151_goods_not_exist), State};
		SellGoods#sell_goods_kf.player_id == PlayerId -> {?ERRCODE(err151_can_not_buy_self_goods), State};
		SellGoods#sell_goods_kf.gtype_id =/= GTypeId -> {?ERRCODE(err151_goods_info_err), State};
		SellGoods#sell_goods_kf.goods_num =/= GoodsNum -> {?ERRCODE(err151_goods_info_err), State};
		SellGoods#sell_goods_kf.unit_price =/= UnitPrice -> {?ERRCODE(err151_goods_info_err), State};
		SellGoods#sell_goods_kf.player_id =/= SellerId -> {?ERRCODE(err151_seller_not_match), State};
		true ->
			IsExpired = lib_sell_kf:is_expired(SellGoods),
			IsConnect = is_connect(SellGoods#sell_goods_kf.server_id, AllNodeList),
			if
				IsExpired == true -> {?ERRCODE(err151_goods_sell_down), State};
				IsConnect == false   -> {?ERRCODE(system_busy), State};
				true ->
					RemainNum = SellGoods#sell_goods_kf.goods_num - GoodsNum,
					PlayerSellList = maps:get(SellerId, PlayerSellMap, []),
					case RemainNum > 0 of
						true ->
							db:execute(io_lib:format(?sql_sell_num_update_kf, [RemainNum, Id])),
							NewSellGoods = SellGoods#sell_goods_kf{goods_num = RemainNum},
							NewSubCategorySellL = lists:keyreplace(Id, #sell_goods_kf.id, SubCategorySellL, NewSellGoods),
							NewPlayerSellList = lists:keyreplace(Id, #sell_goods_kf.id, PlayerSellList, NewSellGoods);
						false ->
							db:execute(io_lib:format(?sql_sell_delete_kf, [Id])),
							NewSubCategorySellL = lists:keydelete(Id, #sell_goods_kf.id, SubCategorySellL),
							NewPlayerSellList = lists:keydelete(Id, #sell_goods_kf.id, PlayerSellList)
					end,
					NewCategorySellMap = maps:put(SubCategory, NewSubCategorySellL, CategorySellMap),
					NewMarketSellMap = maps:put(Category, NewCategorySellMap, MarketSellMap),
					NewPlayerSellMap = maps:put(SellerId, NewPlayerSellList, PlayerSellMap),
					{Tax, NewSellRecordList} = add_sell_record(SellRecordList, SellGoods, GoodsNum, ServerId, ServerNum, PlayerId),
					NewSellPriceMap = refresh_sell_price(SellPriceMap, SellGoods),
					NewCategoryChangeMap = maps:put(Category, true, CategoryChangeMap),
					%% 物品出售成功
					sell_success(SellGoods, ServerId, ServerNum, PlayerId, GoodsNum, Tax),
					
					case RemainNum == 0 of
						true ->
							%% 商品出售完毕下架日志
							add_down_log([SellGoods], ?LOG_DOWN_TYPE_SELL);
						false -> skip
					end,
					
					NewZoneMsg = ZoneMsg#sell_state_zone{
						market_sell_map = NewMarketSellMap,
						player_market_sell_map = NewPlayerSellMap,
						sell_record_list = NewSellRecordList,
						sell_price_map = NewSellPriceMap,
						category_change = NewCategoryChangeMap
					},
					NewZoneMap = maps:put(ZoneId, NewZoneMsg, ZoneMap),
					{{ok, SellGoods, Tax}, State#sell_state_kf{zone_map = NewZoneMap}}
			end
	end;
pay_sell(State, ServerId, ServerNum, PlayerId, ?SELL_TYPE_P2P, Id, SellerId, GTypeId, GoodsNum, UnitPrice) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{
		p2p_sell_map = P2PSellMap,
		sell_record_list = SellRecordList,
		sell_price_map = SellPriceMap
	} = ZoneMsg,
	PlayerSellList = maps:get(SellerId, P2PSellMap, []),
	SellGoods = lists:keyfind(Id, #sell_goods_kf.id, PlayerSellList),
	if
		SellGoods == false -> {?ERRCODE(err151_goods_not_exist), State};
		SellGoods#sell_goods_kf.specify_id =/= PlayerId -> {?ERRCODE(err151_not_specify_role), State};
		SellGoods#sell_goods_kf.gtype_id =/= GTypeId -> {?ERRCODE(err151_goods_info_err), State};
		SellGoods#sell_goods_kf.goods_num =/= GoodsNum -> {?ERRCODE(err151_goods_info_err), State};
		SellGoods#sell_goods_kf.unit_price =/= UnitPrice -> {?ERRCODE(err151_goods_info_err), State};
		true ->
			IsExpired = lib_sell_kf:is_expired(SellGoods),
			if
				IsExpired == true -> {?ERRCODE(err151_goods_sell_down), State};
				true ->
					db:execute(io_lib:format(?sql_sell_delete_kf, [Id])),
					NewPlayerSellList = lists:keydelete(Id, #sell_goods_kf.id, PlayerSellList),
					NewP2PSellMap = maps:put(SellerId, NewPlayerSellList, P2PSellMap),
					{Tax, NewSellRecordList} = add_sell_record(SellRecordList, SellGoods, GoodsNum, ServerId, ServerNum, PlayerId),
					NewSellPriceMap = refresh_sell_price(SellPriceMap, SellGoods),
					sell_success(SellGoods, ServerId, ServerNum, PlayerId, GoodsNum, Tax),
					
					%% 商品出售完毕下架日志
					add_down_log([SellGoods], ?LOG_DOWN_TYPE_SELL),
					
					NewZoneMsg = ZoneMsg#sell_state_zone{
						p2p_sell_map = NewP2PSellMap,
						sell_record_list = NewSellRecordList,
						sell_price_map = NewSellPriceMap
					},
					NewZoneMap = maps:put(ZoneId, NewZoneMsg, ZoneMap),
					{{ok, SellGoods, Tax}, State#sell_state_kf{zone_map = NewZoneMap}}
			end
	end.

check_seek_goods(State, ServerId, PlayerId, _PlayerVipLv, SellTimes, LimitTimes) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{player_seek_map = PlayerSeekMap} = ZoneMsg,
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
	Id = get_auction_id(),
	#seek_goods_kf{
		player_id = PlayerId,
		role_name = RoleName,
		category = Category,
		sub_category = SubCategory,
		gtype_id = GTypeId,
		goods_num = GoodsNum,
		unit_price = UnitPrice
		, server_id = ServerId
		, server_num = ServerNum
	} = SeekGoods,
	db:execute(io_lib:format(?sql_seek_insert_kf,
		[Id, ServerId, ServerNum, PlayerId, util:fix_sql_str(RoleName), GTypeId, Category, SubCategory, GoodsNum, UnitPrice, NowTime])),
	%% 商品上架日志
	lib_log_api:log_seek_up_kf(Id, ServerId, ServerNum, PlayerId, GTypeId, GoodsNum, UnitPrice), %%   添加日志
	%% 上架玩家商品
	NewSeekGoods = SeekGoods#seek_goods_kf{id = Id, time = NowTime},
	NewState = do_seek_goods(State, NewSeekGoods),
	{{ok, NewSeekGoods}, NewState}.

do_seek_goods(State, SeekGoods) ->
	#seek_goods_kf{id = Id, player_id = PlayerId, time = SeekTime, server_id = ServerId} = SeekGoods,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap, min_expire_time = MinExpiredTime} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{player_seek_map = PlayerSeekMap, seek_map = SeekMap, seek_ids = SeekIds} = ZoneMsg,
	%% 更新总的求购信息
	NewSeekMap = maps:put(Id, SeekGoods, SeekMap),
	%% 更新玩家求购列表
	SeekIdList = maps:get(PlayerId, PlayerSeekMap, []),
	NewPlayerSeekMap = maps:put(PlayerId, [Id | SeekIdList], PlayerSeekMap),
	%% 更新排序的求购id列表
	NewSeekIds = [{Id, SeekTime} | SeekIds],
	%% 更新过期时间戳
	SeekExpiredTime = SeekTime + lib_sell_kf:get_expired_time(?SELL_TYPE_SEEK),
	NewMinExpireTime = ?IF(MinExpiredTime == 0 orelse SeekExpiredTime < MinExpiredTime, SeekExpiredTime, MinExpiredTime),
	NewZoneMsg = ZoneMsg#sell_state_zone{player_seek_map = NewPlayerSeekMap,
		seek_map = NewSeekMap, seek_ids = NewSeekIds},
	ZoneMapNew = maps:put(ZoneId, NewZoneMsg, ZoneMap),
	State#sell_state_kf{zone_map = ZoneMapNew, min_expire_time = NewMinExpireTime}.

delete_seek(State, ServerId, PlayerId, Id) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{player_seek_map = PlayerSeekMap, seek_map = SeekMap, seek_ids = SeekIds} = ZoneMsg,
	SeekGoods = maps:get(Id, SeekMap, 0),
	if
		is_record(SeekGoods, seek_goods_kf) == false -> ErrorCode = ?ERRCODE(err151_no_seek_goods), NewState = State;
		SeekGoods#seek_goods_kf.player_id =/= PlayerId -> ErrorCode = ?ERRCODE(err151_not_my_goods), NewState = State;
		true ->
			#seek_goods_kf{gtype_id = GTypeId, goods_num = GoodsNum, unit_price = UnitPrice,
				server_num = SeekServerNum, server_id = SeekServerId} = SeekGoods,
			ErrorCode = ?SUCCESS,
			db:execute(io_lib:format(?sql_seek_delete_kf, [Id])),
			%% 发放保管费非玩家
			Price = UnitPrice,
			MoneyReturn = [{?TYPE_GOLD, 0, round(Price)}],
			%% 邮件发送
			Title = utext:get(1510003),
			Content = utext:get(1510004),
			mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[PlayerId], Title, Content, MoneyReturn]),
%%            lib_mail_api:lib_mail_api([PlayerId], Title, Content, MoneyReturn),
			%% 日志
			lib_log_api:log_seek_down_kf(Id, SeekServerId, SeekServerNum, PlayerId, ?LOG_DOWN_TYPE_MANUAL, GTypeId, GoodsNum, UnitPrice, MoneyReturn),  %%   添加跨服日志
			NewSeekMap = maps:remove(Id, SeekMap),
			NewSeekIds = lists:keydelete(Id, 1, SeekIds),
			SeekIdList = maps:get(PlayerId, PlayerSeekMap, []),
			NewSeekIdList = lists:delete(Id, SeekIdList),
			NewPlayerSeekMap = maps:put(PlayerId, NewSeekIdList, PlayerSeekMap),
			ZoneMsgNew = ZoneMsg#sell_state_zone{player_seek_map = NewPlayerSeekMap, seek_map = NewSeekMap, seek_ids = NewSeekIds},
			ZoneMapNew = maps:put(ZoneId, ZoneMsgNew, ZoneMap),
			NewState = State#sell_state_kf{zone_map = ZoneMapNew}
	end,
	{ok, Bin} = pt_151:write(15116, [ErrorCode, Id]),
	send_to_uid_kf(ServerId, PlayerId, Bin),
%%    lib_server_send:send_to_uid(PlayerId, pt_151, 15116, [ErrorCode, Id]),
	NewState.

sell_seek_goods(State, ServerId, ServerNum, PlayerId, VipType, VipLv, Id, BuyerId, GTypeId, GoodsNum, ExtraAttr, Rating) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{
		sell_record_list = SellRecordList, sell_price_map = SellPriceMap,
		player_seek_map = PlayerSeekMap, seek_map = SeekMap, seek_ids = SeekIds
	} = ZoneMsg,
	SeekGoods = maps:get(Id, SeekMap, 0),
	AllNodeList = mod_clusters_center:get_all_node(),
	if
		is_record(SeekGoods, seek_goods_kf) == false -> {{fail, ?ERRCODE(err151_no_seek_goods)}, State};
		SeekGoods#seek_goods_kf.player_id == PlayerId -> {{fail, ?ERRCODE(err151_can_not_sell_self_goods)}, State};
		SeekGoods#seek_goods_kf.player_id =/= BuyerId -> {{fail, ?ERRCODE(err151_seek_goods_info_err)}, State};
		SeekGoods#seek_goods_kf.gtype_id =/= GTypeId -> {{fail, ?ERRCODE(err151_seek_goods_info_err)}, State};
		SeekGoods#seek_goods_kf.goods_num =/= GoodsNum -> {{fail, ?ERRCODE(err151_seek_goods_info_err)}, State};
%%		IsConnect == false -> {{fail, ?ERRCODE(system_busy)}, State};
		true ->
			BuyerSerId = SeekGoods#seek_goods_kf.server_id,
			IsConnect = is_connect(BuyerSerId, AllNodeList),
			if
				IsConnect == false -> {{fail, ?ERRCODE(system_busy)}, State} ;
				true ->
					RemainNum = SeekGoods#seek_goods_kf.goods_num - GoodsNum,
					Price = SeekGoods#seek_goods_kf.unit_price,
					case RemainNum == 0 of
						true ->
							%?PRINT("sell_seek_goods RemainNum 00 :~p~n", [0]),
							db:execute(io_lib:format(?sql_seek_delete_kf, [Id])),
							NewSeekMap = maps:remove(Id, SeekMap),
							NewSeekIds = lists:keydelete(Id, 1, SeekIds),
							SeekIdList = maps:get(BuyerId, PlayerSeekMap, []),
							NewSeekIdList = lists:delete(Id, SeekIdList),
							NewPlayerSeekMap = maps:put(BuyerId, NewSeekIdList, PlayerSeekMap);
						_ ->
							%?PRINT("sell_seek_goods RemainNum 11 :~p~n", [RemainNum]),
							db:execute(io_lib:format(?sql_seek_num_update_kf, [RemainNum, Id])),
							NewSeekGoods = SeekGoods#seek_goods_kf{goods_num = RemainNum},
							NewSeekMap = maps:put(Id, NewSeekGoods, SeekMap),
							NewSeekIds = SeekIds,
							NewPlayerSeekMap = PlayerSeekMap
					end,
					%% 计算钻石所得
					{Tax, NewSellRecordList} = sell_seek_goods_succ(SellRecordList, SeekGoods, GoodsNum, ExtraAttr, Rating, ServerId, ServerNum, PlayerId, VipType, VipLv),
					MoneyReturn = round(Price),
					%% 邮件发送 求购成功信息
					case ExtraAttr == [] of
						true -> RewardList = [{?TYPE_GOODS, GTypeId, GoodsNum}];
						false -> RewardList = [{?TYPE_ATTR_GOODS, GTypeId, GoodsNum, [{extra_attr, ExtraAttr}]}]
					end,
					GoodsName = data_goods_type:get_name(GTypeId),
					Title = utext:get(1510001),
					Content = utext:get(1510002, [GoodsNum, util:make_sure_binary(GoodsName)]),
					mod_clusters_center:apply_cast(BuyerSerId, lib_mail_api, send_sys_mail,
						[[BuyerId], Title, Content, RewardList]),
%%                  lib_mail_api:send_sys_mail([BuyerId], Title, Content, RewardList),
					%% 买家每日消耗累积
					mod_clusters_center:apply_cast(BuyerSerId, mod_daily, plus_count_offline, [BuyerId, ?MOD_SELL, 3, MoneyReturn]),
%%                  mod_daily:plus_count_offline(BuyerId, ?MOD_SELL, 3, MoneyReturn),
					%% 日志
					case RemainNum == 0 of
						true ->
							lib_log_api:log_seek_down_kf(Id, BuyerSerId, SeekGoods#seek_goods_kf.server_num,
								BuyerId, ?LOG_DOWN_TYPE_SELL, GTypeId, 0, Price, []);  %%  添加日志
						_ -> ok
					end,
					%% 增加买方的交易次数
					mod_clusters_center:apply_cast(BuyerSerId, mod_daily, increment_offline, [BuyerId, ?MOD_SELL, 1]),
%%                   mod_daily:increment_offline(BuyerId, ?MOD_SELL, 1),
					mod_clusters_center:apply_cast(BuyerSerId, lib_sell, send_role_sell_times, [BuyerId]),
					%% 更新价格
					NewSellPriceMap = refresh_sell_price(SellPriceMap, GTypeId, max(1, round(Price / GoodsNum))),
					NewZoneMsg = ZoneMsg#sell_state_zone{
						sell_record_list = NewSellRecordList, sell_price_map = NewSellPriceMap,
						player_seek_map = NewPlayerSeekMap, seek_map = NewSeekMap, seek_ids = NewSeekIds
					},
					NewZoneMap = maps:put(ZoneId, NewZoneMsg, ZoneMap),
					NewState = State#sell_state_kf{zone_map = NewZoneMap},
					{{ok, BuyerSerId, MoneyReturn, Tax, RemainNum}, NewState}
			end
	end.

sell_seek_goods_succ(SellRecordList, SeekGoods, GoodsNum, ExtraAttr, Rating, SellerServerId, SellerServerNum, SellerId, VipType, VipLv) ->
	#seek_goods_kf{
		id = SeekId, player_id = BuyerId, gtype_id = GTypeId, category = Category, sub_category = SubCategory,
		goods_num = SeekGoodsNum, unit_price = UnitPrice, server_id = BuyerServerId, server_num = BuyerServerNum
	} = SeekGoods,
	GoodsOther = #goods_other{extra_attr = ExtraAttr, rating = Rating},
	Tax = count_tax(GTypeId, GoodsNum, UnitPrice, VipType, VipLv),
	NowTime = utime:unixtime(),
	Args = [SellerServerId, SellerServerNum, SellerId, BuyerServerId, BuyerServerNum,
		BuyerId, ?SELL_TYPE_SEEK, GTypeId, GoodsNum, UnitPrice, Tax, util:term_to_bitstring(ExtraAttr), NowTime],
	db:execute(io_lib:format(?sql_sell_record_insert_kf, Args)),
	SellRecord = make_record(sell_record, [SellerServerId, SellerServerNum, SellerId, BuyerServerId, BuyerServerNum, BuyerId, ?SELL_TYPE_SEEK, GTypeId, GoodsNum, UnitPrice, Tax, GoodsOther, NowTime]),
	lib_log_api:log_sell_pay_kf(?SELL_TYPE_SEEK, SeekId, GTypeId, GoodsNum, UnitPrice, Tax, SellerServerId, SellerServerNum, SellerId, BuyerServerId, BuyerServerNum, BuyerId, ExtraAttr),  %%添加日志
	%% 通知购买方商品已消失
	case SeekGoodsNum == GoodsNum of
		true ->
			{ok, Bin} = pt_151:write(15120, [?SELL_TYPE_SEEK, Category, SubCategory, SeekId]),
			send_to_uid_kf(BuyerServerId, BuyerId, Bin);
%%            lib_server_send:send_to_uid(BuyerId, Bin);
		_ -> ok
	end,
	{Tax, [SellRecord | SellRecordList]}.

send_self_seek_list(State, ServerId, PlayerId, Cmd) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{player_seek_map = PlayerSeekMap, seek_map = SeekMap} = ZoneMsg,
	SeekIdList = maps:get(PlayerId, PlayerSeekMap, []),
	F = fun(Id, List) ->
		case maps:get(Id, SeekMap, 0) of
			#seek_goods_kf{player_id = PlayerId, gtype_id = GTypeId, goods_num = GoodsNum, unit_price = UnitPrice, time = SeekTime} ->
				[{Id, GTypeId, GoodsNum, UnitPrice, SeekTime} | List];
			_ -> List
		end
	    end,
	PackSeekList = lists:foldl(F, [], SeekIdList),
	%?PRINT("send_self_seek_list PackSeekList :~p~n", [PackSeekList]),
	{ok, Bin} = pt_151:write(Cmd, [PackSeekList]),
	send_to_uid_kf(ServerId, PlayerId, Bin).
%%	lib_server_send:send_to_uid(PlayerId, pt_151, Cmd, [PackSeekList]).

send_seek_list(State, ServerId, PlayerId, Cmd, PageNo, PageSize) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#sell_state_kf{zone_map = ZoneMap} = State,
	ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
	#sell_state_zone{seek_ids = SeekIds, seek_map = SeekMap} = ZoneMsg,
%%	?MYLOG("sell", "SeekIds ~p~n", [SeekIds]),
	SortSeekIds = lists:reverse(SeekIds),
	{PageTotal, StartPos, ThisPageSize} = util:calc_page_cache(length(SortSeekIds), PageSize, PageNo),
	SubSeekIds = lists:sublist(SortSeekIds, StartPos, ThisPageSize),
	F = fun({Id, _}, List) ->
		case maps:get(Id, SeekMap, 0) of
			#seek_goods_kf{player_id = BuyerId, server_id = ServerId1, server_num = ServerNum1, role_name = RoleName, gtype_id = GTypeId, goods_num = GoodsNum, unit_price = UnitPrice, time = SeekTime} ->
				[{Id, ServerId1, ServerNum1, BuyerId, RoleName, GTypeId, GoodsNum, UnitPrice, SeekTime} | List];
			_ -> List
		end
	    end,
	PackSeekList = lists:foldl(F, [], SubSeekIds),
	{ok, Bin} = pt_151:write(Cmd, [PageTotal, PageNo, PageSize, PackSeekList]),
	send_to_uid_kf(ServerId, PlayerId, Bin).
%?PRINT("send_seek_list PackSeekList :~p~n", [PackSeekList]),
%%    lib_server_send:send_to_uid(PlayerId, pt_151, Cmd, [PageTotal, PageNo, PageSize, PackSeekList]).

%% 增加新的出售记录
add_sell_record(SellRecordList, SellGoods, GoodsNum, BuyerServerId, BuyerServerNum, BuyerId) ->
	#sell_goods_kf{
		server_id = SellServerId,
		server_num = SellServerNum,
		player_id = SellerId,
		sell_type = SellType,
		gtype_id = GTypeId,
		unit_price = UnitPrice,
		vip_type = SellerVipType,
		vip_lv = SellerVipLv,
		other = GoodsOther
	} = SellGoods,
	#goods_other{extra_attr = ExtraAttr} = GoodsOther,
%%	{SellerVipType, SellerVipLv} = lib_role:get_role_vip(SellerId),
	Tax = count_tax(GTypeId, GoodsNum, UnitPrice, SellerVipType, SellerVipLv),
	NowTime = utime:unixtime(),
	Args = [SellServerId, SellServerNum, SellerId, BuyerServerId, BuyerServerNum, BuyerId, SellType, GTypeId, GoodsNum, UnitPrice, Tax, util:term_to_bitstring(ExtraAttr), NowTime],
	Sql = io_lib:format(?sql_sell_record_insert_kf, Args),
	?MYLOG("sell", "'~s'~n", [Sql]),
	db:execute(Sql),
	SellRecord = make_record(sell_record, [SellServerId, SellServerNum, SellerId, BuyerServerId, BuyerServerNum, BuyerId, SellType, GTypeId, GoodsNum, UnitPrice, Tax, GoodsOther, NowTime]),
	{Tax, [SellRecord | SellRecordList]}.

%% 刷新物品的交易价格
refresh_sell_price(SellPriceMap, SellGoods) ->
	#sell_goods_kf{gtype_id = GTypeId, unit_price = UnitPrice, goods_num = GoodsNum} = SellGoods,
	refresh_sell_price(SellPriceMap, GTypeId, max(1, round(UnitPrice / GoodsNum))).

refresh_sell_price(SellPriceMap, GTypeId, UnitPrice) ->
	NowTime = utime:unixtime(),
	SellPriceR = make_record(sell_price, [GTypeId, UnitPrice, NowTime]),
	GTypeSellPriceL = maps:get(GTypeId, SellPriceMap, []),
	NewGTypeSellPriceL = sort_price_list([SellPriceR | GTypeSellPriceL], 1, ?SELL_PRICE_REFER_NUM, []),
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
sell_success(SellGoods, BuyerServerId, _BuyerServerNum, BuyerId, GoodsNum, Tax) ->
	#sell_goods_kf{
		id = SellId,
		sell_type = SellType,
		category = Category,
		sub_category = SubCategory,
		server_id = SellServerId,
		server_num = SellServerNum,
		player_id = SellerId,
		gtype_id = GTypeId,
		unit_price = UnitPrice,
		other = GoodsOther
	} = SellGoods,
	#goods_other{extra_attr = ExtraAttr} = GoodsOther,
	%% 增加买方的交易次数
%%    mod_daily:increment_offline(BuyerId, ?MOD_SELL, 1),
	mod_clusters_center:apply_cast(BuyerServerId, mod_daily, increment_offline, [BuyerId, ?MOD_SELL, 1]),
	mod_clusters_center:apply_cast(BuyerServerId, lib_sell, send_role_sell_times, [BuyerId]),
	case data_goods_type:get(GTypeId) of
		#ets_goods_type{goods_name = GoodsName, color = Color} -> skip;
		_ -> GoodsName = "???", Color = ?GREEN
	end,
	%% 交易日志
	lib_log_api:log_sell_pay_kf(SellType, SellId, GTypeId, GoodsNum, UnitPrice, Tax, SellServerId, SellServerNum, SellerId, BuyerServerId, _BuyerServerNum, BuyerId, ExtraAttr),  %% 增加交易日志
	case SellerId > 0 of 
		true ->
			Price = UnitPrice,
			SellPrice = max(0, Price - Tax),
			Title = utext:get(4),
			Content = utext:get(5, [Color, GoodsName, GoodsNum, Tax, SellPrice]),
			mod_clusters_center:apply_cast(SellServerId, lib_mail_api, send_sys_mail, [[SellerId], Title, Content, [{?TYPE_GOLD, 0, SellPrice}]]),
			mod_clusters_center:apply_cast(SellServerId, mod_daily, plus_count_offline, [SellerId, ?MOD_SELL, 2, SellPrice]),
			%% 告诉出售方 该商品已被购买
			{ok, Bin} = pt_151:write(15120, [SellType, Category, SubCategory, SellId]),
			send_to_uid_kf(SellServerId, SellerId, Bin);
		_ ->
			ok
	end.


%% 自动下架：下架超过48小时未出售商品
auto_sell_down(State) ->
	NowTime = utime:unixtime(),
	#sell_state_kf{min_expire_time = MinExpiredTime, zone_map = ZoneMap, connect_servers = ConnectServers} = State,
	case MinExpiredTime =< NowTime of
		true ->
			%% 设置一个进程字典临时存储过期的商品
			put(expired_goods_map, #{}),
			put(expired_goods_ids, []),
			put(min_expire_time, 0),
			put(expired_seek_list, []),
			put(expired_seek_ids, []),
			ZoneList = maps:to_list(ZoneMap),
			F1 = fun({ZoneId, ZoneMsg}, AccList) ->
				ZoneMsgNew = auto_do_sell_down(?SELL_TYPE_MARKET, ZoneMsg, NowTime, ConnectServers),
				[{ZoneId, ZoneMsgNew} | AccList]
			     end,
			ZoneList1 = lists:foldl(F1, [], ZoneList),
			F2 = fun({ZoneId, ZoneMsg}, AccList) ->
				ZoneMsgNew = auto_do_sell_down(?SELL_TYPE_P2P, ZoneMsg, NowTime, ConnectServers),
				[{ZoneId, ZoneMsgNew} | AccList]
			     end,
			ZoneList2 = lists:foldl(F2, [], ZoneList1),
			F3 = fun({ZoneId, ZoneMsg}, AccList) ->
				ZoneMsgNew = auto_do_sell_down(?SELL_TYPE_SEEK, ZoneMsg, NowTime, ConnectServers),
				[{ZoneId, ZoneMsgNew#sell_state_zone{category_change = #{}}} | AccList]
			     end,
			ZoneList3 = lists:foldl(F3, [], ZoneList2),
			NewZoneMap = maps:from_list(ZoneList3),
%%			NewState = auto_do_sell_down(?SELL_TYPE_MARKET, State, NowTime),
%%			NewState1 = auto_do_sell_down(?SELL_TYPE_P2P, NewState, NowTime),
%%			NewState2 = auto_do_sell_down(?SELL_TYPE_SEEK, NewState1, NowTime),
			NewMinExpireTime = get(min_expire_time),
			do_auto_sell_down_core(),
			State#sell_state_kf{zone_map = NewZoneMap, min_expire_time = NewMinExpireTime};
		_ ->
			%?PRINT("not refresh sell goods ============ ~n", []),
			State
	end.

auto_do_sell_down(?SELL_TYPE_MARKET, StateZone, NowTime, _ConnectServers) ->
	#sell_state_zone{
		market_sell_map = MarketSellMap,
		player_market_sell_map = PlayerMarketSellMap
	} = StateZone,
%%	%% 设置一个进程字典临时存储过期的商品
%%	put(expired_goods_map, #{}),
%%	put(expired_goods_ids, []),
%%	put(min_expire_time, 0),
	AllNodeList = mod_clusters_center:get_all_node(),
	F = fun(T) ->
		#sell_goods_kf{server_id = GoodsServerId} = T,
		IsExpired = lib_sell_kf:is_expired(T, NowTime),
%%		IsConnect = lists:member(GoodsServerId, ConnectServers),
		IsConnect = is_connect(GoodsServerId, AllNodeList),
%%		IsConnect = true,
		if
			IsExpired andalso IsConnect ->
				TmpExpiredMap = get(expired_goods_map),
				TmpL = maps:get(T#sell_goods_kf.player_id, TmpExpiredMap, []),
				NewTmpExpiredMap = maps:put(T#sell_goods_kf.player_id, [T | TmpL], TmpExpiredMap),
				put(expired_goods_map, NewTmpExpiredMap),
				TmpExpiredIds = get(expired_goods_ids),
				put(expired_goods_ids, [T#sell_goods_kf.id | TmpExpiredIds]),
				false;
			true ->
				#sell_goods_kf{sell_type = SellType, time = SellTime} = T,
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
		[T || T <- SellL, lists:member(T#sell_goods_kf.id, ExpiredList) == false]
	     end,
	NewPlayerMarketSellMap = maps:map(F3, PlayerMarketSellMap),
	StateZone#sell_state_zone{
		market_sell_map = NewMarketSellMap,
		player_market_sell_map = NewPlayerMarketSellMap
	};
auto_do_sell_down(?SELL_TYPE_P2P, StateZone, NowTime, _ConnectServers) ->
	#sell_state_zone{p2p_sell_map = P2PSellMap} = StateZone,
	AllNodeList = mod_clusters_center:get_all_node(),
	F = fun(T) ->
		#sell_goods_kf{server_id = GoodsServerId} = T,
		IsExpired = lib_sell_kf:is_expired(T, NowTime),
%%		IsConnect = lists:member(GoodsServerId, ConnectServers),
		IsConnect = is_connect(GoodsServerId, AllNodeList),
		if
			IsExpired andalso IsConnect ->
				TmpExpiredMap = get(expired_goods_map),
				TmpL = maps:get(T#sell_goods_kf.player_id, TmpExpiredMap, []),
				NewTmpExpiredMap = maps:put(T#sell_goods_kf.player_id, [T | TmpL], TmpExpiredMap),
				put(expired_goods_map, NewTmpExpiredMap),
				TmpExpiredIds = get(expired_goods_ids),
				put(expired_goods_ids, [T#sell_goods_kf.id | TmpExpiredIds]),
				false;
			true ->
				#sell_goods_kf{sell_type = SellType, time = SellTime} = T,
				SellExpiredTime = lib_sell_kf:get_expired_time(SellType) + SellTime,
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
	StateZone#sell_state_zone{p2p_sell_map = NewP2PSellMap};
auto_do_sell_down(?SELL_TYPE_SEEK, StateZone, NowTime, _ConnectServers) ->
	#sell_state_zone{
		seek_map = SeekMap
	} = StateZone,
%%	%% 设置一个进程字典临时存储过期的商品
%%	put(expired_seek_list, []),
%%	put(expired_seek_ids, []),
	AllNodeList = mod_clusters_center:get_all_node(),
	F2 = fun(Id, SeekGoods, {TmpSeekMap, TmpPlayerSeekMap, TmpSeekIds}) ->
		#seek_goods_kf{server_id = GoodsServerId} = SeekGoods,
		IsExpired = lib_sell_kf:is_expired(SeekGoods, NowTime),
%%		IsConnect = is_connect(GoodsServerId),
		IsConnect = is_connect(GoodsServerId, AllNodeList),
%%		IsConnect = true,
		if
			IsExpired andalso IsConnect ->
				TmpExpiredList = get(expired_seek_list),
				put(expired_seek_list, [SeekGoods | TmpExpiredList]),
				TmpExpiredIds = get(expired_seek_ids),
				put(expired_seek_ids, [Id | TmpExpiredIds]),
				{TmpSeekMap, TmpPlayerSeekMap, TmpSeekIds};
			true ->
				#seek_goods_kf{player_id = PlayerId, time = SeekTime} = SeekGoods,
				SeekExpiredTime = lib_sell_kf:get_expired_time(?SELL_TYPE_SEEK) + SeekTime,
				OMinExpireTime = get(min_expire_time),
				NMinExpireTime = ?IF(OMinExpireTime == 0 orelse SeekExpiredTime < OMinExpireTime, SeekExpiredTime, OMinExpireTime),
				put(min_expire_time, NMinExpireTime),
				NewTmpSeekMap = maps:put(Id, SeekGoods, TmpSeekMap),
				NewTmpSeekIds = [{Id, SeekTime} | TmpSeekIds],
				NewTmpPlayerSeekMap = maps:put(PlayerId, [Id | maps:get(PlayerId, TmpPlayerSeekMap, [])], TmpPlayerSeekMap),
				{NewTmpSeekMap, NewTmpPlayerSeekMap, NewTmpSeekIds}
		end
	     end,
	{NewSeekMap, NewPlayerSeekMap, SeekIds} = maps:fold(F2, {#{}, #{}, []}, SeekMap),
	NewSeekIds = lists:sort(fun({_, TimeA}, {_, TimeB}) -> TimeA > TimeB end, SeekIds),
%%	NewMinExpireTime = get(min_expire_time),
	StateZone#sell_state_zone{
		seek_map = NewSeekMap,
		player_seek_map = NewPlayerSeekMap,
		seek_ids = NewSeekIds
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
			db:execute(io_lib:format(?sql_sell_delete_more_kf, [Args])),
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
			db:execute(io_lib:format(?sql_seek_delete_more_kf, [Args2])),
			%% 在子进程发自动下架的邮件
			spawn(fun() ->
				%% 自动下架日志
				F = fun(SeekGoods) ->
					#seek_goods_kf{id = Id, player_id = PlayerId, gtype_id = GTypeId, goods_num = GoodsNum, unit_price = UnitPrice,
						server_id = SeekServerId, server_num = SeekServerNum} = SeekGoods,
					MoneyReturn = [{?TYPE_GOLD, 0, round(UnitPrice)}],
					lib_log_api:log_seek_down_kf(Id, SeekServerId, SeekServerNum, PlayerId, ?LOG_DOWN_TYPE_AUTO, GTypeId, GoodsNum, UnitPrice, MoneyReturn),  %%   添加日志
					ok
				    end,
				lists:foreach(F, ExpiredSeekList),
				send_auto_seek_down_mail(ExpiredSeekList, 1)
			      end);
		_ -> skip
	end.

send_auto_sell_down_mail([], _) -> ok;
send_auto_sell_down_mail([{_RoleId, SellDownGoodsL} | L], HasSendNum) ->
	NewHasSendNum = do_send_auto_sell_down_mail(SellDownGoodsL, HasSendNum),
	send_auto_sell_down_mail(L, NewHasSendNum).

do_send_auto_sell_down_mail([], HasSendNum) -> HasSendNum;
do_send_auto_sell_down_mail([T | L], HasSendNum) ->
	case T of
		#sell_goods_kf{
			server_id = ServerId,
			player_id = PlayerId,
			sell_type = SellType,
			gtype_id = GTypeId,
			goods_num = GoodsNum,
			other = GoodsOther
		} when PlayerId > 0->
			#goods_other{extra_attr = ExtraAttr} = GoodsOther,
			case data_goods_type:get(GTypeId) of
				#ets_goods_type{goods_name = GoodsName, color = Color} -> skip;
				_ -> GoodsName = "???", Color = ?GREEN
			end,
			ExpiredTime = lib_sell_kf:get_expired_time(SellType),
			{H, _, _} = utime:time_to_hms(ExpiredTime),
			Title = utext:get(2),
			Content = utext:get(3, [Color, GoodsName, H]),
			case data_goods_type:get(GTypeId) of
				#ets_goods_type{type = ?GOODS_TYPE_EQUIP, equip_type = EquipType} when EquipType > 0 -> %% 目前只有装备是带属性的
					List = [{?TYPE_ATTR_GOODS, GTypeId, GoodsNum, [{extra_attr, ExtraAttr}]}];
				_ ->
					List = [{?TYPE_GOODS, GTypeId, GoodsNum}]
			end,
			mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[PlayerId], Title, Content, List]),
%%			lib_mail_api:send_sys_mail([PlayerId], Title, Content, List),
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
send_auto_seek_down_mail([T | ExpiredSeekList], HasSendNum) ->
	case T of
		#seek_goods_kf{
			server_id = ServerId,
			player_id = PlayerId,
			gtype_id = GTypeId,
			goods_num = GoodsNum,
			unit_price = UnitPrice
		} ->
			MoneyReturn = [{?TYPE_GOLD, 0, round(UnitPrice)}],
			GoodsName = data_goods_type:get_name(GTypeId),
			Title = utext:get(1510007),
			Content = utext:get(1510008, [util:make_sure_binary(GoodsName), GoodsNum]),
			mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[PlayerId], Title, Content, MoneyReturn]),
%%			lib_mail_api:send_sys_mail([PlayerId], Title, Content, MoneyReturn),
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
add_down_log([T | L], LogType) ->
	case T of
		#sell_goods_kf{
			id = SellId,
			player_id = SellerId,
			server_id = ServerId,
			server_num = ServerNum,
			gtype_id = GTypeId,
			goods_num = GoodsNum,
			other = GoodsOther
		} ->
			#goods_other{extra_attr = ExtraAttr} = GoodsOther,
			lib_log_api:log_sell_down_kf(SellId, GTypeId, GoodsNum, ServerId, ServerNum, SellerId, LogType, ExtraAttr),  %%  下架日志
			add_down_log(L, LogType);
		_ ->
			add_down_log(L, LogType)
	end.

daily_timer(State) ->
	#sell_state_kf{zone_map = ZoneMap} = State,
	NowTime = utime:unixtime(),
	ZoneList = maps:to_list(ZoneMap),
	FF = fun({ZoneId, ZoneMsg}, AccList) ->
		#sell_state_zone{
			sell_record_list = SellRecordList
		} = ZoneMsg,
		CleanTime = lib_sell_kf:get_record_expired_time(),
		F = fun(T, Acc) ->
			case T of
				#sell_record_kf{
					time = TmpTime
				} when NowTime - TmpTime < CleanTime ->
					[T | Acc];
				_ -> Acc
			end
		    end,
		NewSellRecordL = lists:foldl(F, [], SellRecordList),
		ZoneMsgNew = ZoneMsg#sell_state_zone{sell_record_list = NewSellRecordL},
		[{ZoneId, ZoneMsgNew} | AccList]
	     end,
	ZoneListNew = lists:foldl(FF, [], ZoneList),
	ZoneMapNew = maps:from_list(ZoneListNew),
	clear_time_out_record_db(NowTime),
	State#sell_state_kf{zone_map = ZoneMapNew}.


pack_sell_goods_list([], _PackType, PackList) -> PackList;
pack_sell_goods_list([T | L], PackType, PackList) ->
	case lib_sell_kf:is_expired(T) of
		false ->
			Tmp = pack_sell_goods(PackType, T),
			pack_sell_goods_list(L, PackType, [Tmp | PackList]);
		true ->
			pack_sell_goods_list(L, PackType, PackList)
	end.

pack_sell_goods(PackType, SellGoods) ->
	#sell_goods_kf{
		id = Id,
		sell_type = SellType,
		player_id = PlayerId,
		role_name = RoleName,
		specify_id = _SpecifyId,
		gtype_id = GTypeId,
		goods_num = GoodsNum,
		unit_price = UnitPrice,
		other = GoodsOther,
		time = _Time
	} = SellGoods,
	#goods_other{rating = Rating, extra_attr = ExtraAttr} = GoodsOther,
	PackAttrList = data_attr:unified_format_extra_attr(ExtraAttr, []),
	case SellType of
		?SELL_TYPE_MARKET ->
			{Id, PlayerId, GTypeId, GoodsNum, Rating, Rating, UnitPrice, SellType, PackAttrList};
		_ ->
			case PackType of
				?PACK_TYPE_SELL_TO_ME ->
					Name = RoleName;
				_ ->
					Name = ""
			end,
			{Id, PlayerId, GTypeId, GoodsNum, Rating, Rating, UnitPrice, SellType, PackAttrList, Name}
	end.

pack_sell_record_list([], _PlayerId, PackList) -> PackList;
pack_sell_record_list([T | L], PlayerId, PackList) ->
	Tmp = pack_sell_record(PlayerId, T),
	pack_sell_record_list(L, PlayerId, [Tmp | PackList]).

pack_sell_record(PlayerId, SellRecord) ->
	#sell_record_kf{
		player_id = SellerId,
		sell_type = SellType,
		buyer_id = _BuyerId,
		gtype_id = GTypeId,
		goods_num = GoodsNum,
		unit_price = UnitPrice,
		tax = Tax,
		other = GoodsOther,
		time = Time
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
	db:execute(io_lib:format(?sql_clean_sell_record_kf, [NowTime-CleanTime])).


get_zone_map() ->
	ServerList = mod_zone_mgr:get_all_zone(),
	F = fun(#zone_base{server_id = ServerId, zone = ZoneId}, Map) ->
		maps:put(ServerId, ZoneId, Map)
	    end,
	lists:foldl(F, #{}, ServerList).


send_to_uid_kf(ServerId, PlayerId, Bin) ->
	mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [PlayerId, Bin]).


calc_world_lv() ->
%%	?MYLOG("sell", "calc_world_lv ++++++++++++~n", []),
	AllServerList = mod_zone_mgr:get_all_zone(),
%%	?MYLOG("sell", "calc_world_lv ++++++++++++  ~p~n", [AllServerList]),
	NeedLv = data_sell:get_cfg(kf_open_lv),
	F = fun(#zone_base{zone = ZoneId, world_lv = Lv}, AccList) ->
		if
			Lv >= NeedLv ->
				[ZoneId | lists:delete(ZoneId, AccList)];
			true ->
				AccList
		end
	    end,
	EnoughZoneIds = lists:foldl(F, [], AllServerList),
%%	?MYLOG("sell", "calc_world_lv ++++++++++++ EnoughZoneIds ~p~n", [EnoughZoneIds]),
	[mod_clusters_center:apply_cast(ServerId, mod_sell, set_kf_status, [1])
		|| #zone_base{zone = TempZoneId, server_id = ServerId} <- AllServerList, lists:member(TempZoneId, EnoughZoneIds)].


get_auction_id() ->
	mod_id_create_cls:get_new_id(?SELL_ID_CREATE_CLS).
% 	KfServerId = erlang:phash2(node(), 16#FFFF),
% 	Id = mod_global_counter:get_count(?MOD_SELL, ?GLOBAL_151_KF_AUCTION_ID),
% %%	?MYLOG("cym", "get_auction_id ~p~n", [Id]),
% 	<<AutoId:48>> = <<KfServerId:16, Id:32>>,
% %%	?MYLOG("cym", "AutoId ~p~n", [AutoId]),
% 	mod_global_counter:increment(?MOD_SELL, ?GLOBAL_151_KF_AUCTION_ID),
% 	AutoId.


handle_new_merge_server_ids(State, ServerId, ServerNum, _ServerName, _WorldLv, _Time, NewMergeSerIds) ->
	#sell_state_kf{connect_servers = ConnectServerIds} = State,
	if
		NewMergeSerIds =/= [] ->
			Args1 = util:link_list(NewMergeSerIds),
			Sql1 = io_lib:format(<<"UPDATE  sell_list_kf set server_id = ~p , server_num = ~p  where server_id in (~s)">>, [ServerId, ServerNum, Args1]),
			db:execute(Sql1),
			Args2 = util:link_list(NewMergeSerIds),
			Sql2 = io_lib:format(<<"UPDATE  seek_list_kf set server_id = ~p , server_num = ~p  where server_id in (~s)">>, [ServerId, ServerNum, Args2]),
			db:execute(Sql2),
			init(ConnectServerIds);
		true ->
			State
	end.



gm_repair_seek() ->
	Sql = io_lib:format("select   server_num , player_id , money_return  from  log_seek_down_kf   where  down_type = 1   and   time < 1584499977", []),
	List = db:get_all(Sql),
%%	?MYLOG("cym", "List ~p~n", [List]),
	Title = utext:get(1510003),
	Content = utext:get(1510004),
	[begin
		 timer:sleep(100),
		 mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[Id], Title, Content, util:bitstring_to_term(Money)])
	 end
		
		|| [ServerId, Id, Money] <- List].


is_connect(ServerId, NodeList) ->
	case lib_clusters_center:get_node(ServerId) of
		undefined ->
			false;
		ReceiveNode ->
			case lists:keymember(ReceiveNode, #game_node.node, NodeList) of
				true ->
					true;
				_ ->
					false
			end
	end.
%% 市场喊话
market_shout(Args, State) ->
    [ServerId, SellId, PlayerId, IsSellUp, IsMark|_] = Args,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    #sell_state_kf{zone_map = ZoneMap} = State,
    ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
    #sell_state_zone{player_market_sell_map = PlayerSellMap} = ZoneMsg,
    PlayerSellList = maps:get(PlayerId, PlayerSellMap, []),
    case lists:keyfind(SellId, #sell_goods_kf.id, PlayerSellList) of
        #sell_goods_kf{ gtype_id = GTypeId, role_name = Name, unit_price = Price, category = Type, sub_category = SubType} ->
            ok;
        _ ->
            GTypeId = 0, Name = "", Price = 0, Type = 0, SubType = 0
    end,
    case GTypeId of
        0 ->
            skip;
        _ ->
            TvId = ?IF(IsMark, 4, 3),
            case TvId of
                3 ->
                    BinData = lib_chat:make_tv(?MOD_SELL, TvId, [Name, PlayerId, Price, GTypeId, Type, SubType, SellId]);
                _ ->
                    BinData = lib_chat:make_tv(?MOD_SELL, TvId, [Price, GTypeId, Type, SubType, SellId])
            end,
            send_bin_to_zone(ZoneId, BinData)
    end,
    CastBackArgs = [PlayerId, ?APPLY_CAST_SAVE, lib_sell, market_shout_cast_back, [SellId, GTypeId, IsSellUp]],
    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, CastBackArgs).

send_bin_to_zone(0, BinData) ->
    mod_clusters_center:apply_to_all_node(?MODULE, send_bin_to_zone_local, [BinData]);
send_bin_to_zone(ZoneId, BinData) ->
    mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, ?MODULE, send_bin_to_zone_local, [BinData]).

send_bin_to_zone_local(BinData) ->
    IsKfOpen = mod_global_counter:get_count(?MOD_SELL, 1),  %% 大于1则是开启了跨服市场
    case IsKfOpen >= 1 of
        true -> 
            %% 只有开了跨服市场的服才可以收到传闻
            mod_chat_agent:send_msg([{all, BinData}]);
        false ->
            skip
    end.            
    