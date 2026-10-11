%% ---------------------------------------------------------------------------
%% @doc 拍卖行
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------

-module (lib_auction_data).
-include ("common.hrl").
-include ("rec_auction.hrl").
-include ("def_fun.hrl").
-include ("def_timer_quest.hrl").
-include ("def_module.hrl").
-compile (export_all).

%% ------------------------------ init function %% ---------------------------

init() ->
	SqlAuction 		= io_lib:format(?SQL_AUCTION_SELECT, []),
	SqlAuctionInfo  = io_lib:format(?SQL_AUCTION_INFO_SELECT, []),
	SqlAuctionGoods = io_lib:format(?SEL_AUCTION_GOODS_SELECT, []),
	SqlAuctionLog 	= io_lib:format(?SQL_AUCTION_LOG_SELECT, []),
	SqlGuildAward  	= io_lib:format(?SQL_AUCTION_GUILD_AWARD_SELECT, []),
	SqlBonusLog     = io_lib:format(?SQL_AUCTION_BONUS_LOG_SELECT, []),
	SqlPlayerLog     = io_lib:format(?SQL_PLAYER_LOG_SELECT, []),
	AwardMap = lists:foldl(
		fun init_guild_award/2, #{}, db:get_all(SqlGuildAward)),
	{AuctionMap, _, _, _} = lists:foldl(
		fun init_auction_and_join_log/2, { #{}, #{}, AwardMap, #{}}, db:get_all(SqlAuction)),
	AuctionInfo = lists:foldl(
		fun init_goods_info/2, #{}, db:get_all(SqlAuctionInfo)),
	{GoodsMap, GuildMap, WorldMap, NewAuctionMap, _AuctionInfo} = lists:foldl(
		fun init_auction_goods/2, 
		{#{}, #{}, #{}, AuctionMap, AuctionInfo }, db:get_all(SqlAuctionGoods)),
	{BonusLogMap, BonusMap} = init_bonus_log(db:get_all(SqlBonusLog)),
	PlayerLogMap = lists:foldl(
		fun init_player_log/2, #{}, db:get_all(SqlPlayerLog)),
	%?PRINT("init PlayerLogMap:~p~n", [maps:values(PlayerLogMap)]),
	delete_overtime_guild_award_db(AwardMap, NewAuctionMap),
	{GuildLogMap, WorldLogList} = lists:foldl(
		fun init_auction_log/2, {#{}, []}, db:get_all(SqlAuctionLog)),
	lib_auction_util:restart_close_auction_timer(NewAuctionMap),
	make(auction_state, [NewAuctionMap, GoodsMap, GuildMap, WorldMap, GuildLogMap, WorldLogList, PlayerLogMap, BonusLogMap, BonusMap]).

init_kf() ->
	KfServerId = erlang:phash2(node(), 16#FFFF),
	SqlAuctionJoinLog 		= io_lib:format(?SQL_PLAYER_JOIN_LOG_SELECT, []),
	SqlGuildAward  	= io_lib:format(?SQL_AUCTION_GUILD_AWARD_SELECT, []),
	SqlAuction 		= io_lib:format(?SQL_AUCTION_SELECT, []),
	SqlAuctionInfo  = io_lib:format(?SQL_AUCTION_INFO_SELECT, []),
	SqlAuctionGoods = io_lib:format(?SEL_AUCTION_GOODS_SELECT, []),
	AllJoinLogMap = lists:foldl(
		fun init_kf_join_log_map/2, #{}, db:get_all(SqlAuctionJoinLog)),
	AwardMap = lists:foldl(
		fun init_guild_award/2, #{}, db:get_all(SqlGuildAward)),
	{AuctionMap, _, _, _} = lists:foldl(
		fun init_auction_and_join_log/2, { #{}, #{}, AwardMap, AllJoinLogMap}, db:get_all(SqlAuction)),
	AuctionInfo = lists:foldl(
		fun init_goods_info/2, #{}, db:get_all(SqlAuctionInfo)),
	{GoodsMap, GuildMap, WorldMap, NewAuctionMap, _AuctionInfo} = lists:foldl(
		fun init_auction_goods/2, 
		{#{}, #{}, #{}, AuctionMap, AuctionInfo}, db:get_all(SqlAuctionGoods)),
	lib_auction_util:restart_close_auction_timer(NewAuctionMap),
	make(kf_auction_state, [KfServerId, NewAuctionMap, GoodsMap, GuildMap, WorldMap]).

init_guild_award(Elem, Map) ->
	[AuctionId, GuildId, AwardStatus] = Elem,
	GuildMap = maps:get(AuctionId, Map, #{}),
	NewGuildMap = maps:put(GuildId, AwardStatus, GuildMap),
	maps:put(AuctionId, NewGuildMap, Map).

init_kf_join_log_map(Elem, Map) ->
	[AuctionId, PlayerId, GuildId, ServerId] = Elem,
	OJoinM = maps:get(AuctionId, Map, #{}),
	NewJoinM = maps:put(PlayerId, #join_log{player_id = PlayerId, guild_id = GuildId, server_id = ServerId}, OJoinM),
	maps:put(AuctionId, NewJoinM, Map).

init_auction_and_join_log(Elem, {AuctionMap, _JoinLogMap, AwardMap, AllJoinLogMap}) ->
	Auction = make(auction, Elem),
	AuctionId 	= Auction#auction.auction_id,
	IsClsAuction       = Auction#auction.is_cls,
	IsCls = util:is_cls(),
	if
		IsCls andalso IsClsAuction == 1 -> %% 跨服拍卖
			NewJoinLogMap = maps:get(AuctionId, AllJoinLogMap, #{}),
			GuildAwardMap =  maps:get(AuctionId, AwardMap, #{}),
			NewAuction    = Auction#auction{guild_award_map = GuildAwardMap},
			NewAuctionMap = init_auction_join_num(NewAuction, AuctionMap, NewJoinLogMap),
			{NewAuctionMap, _JoinLogMap, AwardMap, AllJoinLogMap};
		IsCls == false andalso IsClsAuction == 0 -> %% 本服拍卖
			NewJoinLogMap = init_join_log(Auction),
			GuildAwardMap =  maps:get(AuctionId, AwardMap, #{}),
			NewAuction    = Auction#auction{guild_award_map = GuildAwardMap},
			NewAuctionMap = init_auction_join_num(NewAuction, AuctionMap, NewJoinLogMap),
			{NewAuctionMap, _JoinLogMap, AwardMap, AllJoinLogMap};
		true ->
			{AuctionMap, _JoinLogMap, AwardMap, AllJoinLogMap}
	end.

init_join_log(Auction) ->
	#auction{
		module_id = ModuleId, authentication_id = AuthenticationId
	} = Auction,
	case AuthenticationId == 0 of 
		true ->
			LogList = lib_act_join_api:get_join(ModuleId);
		_ ->
			LogList = lib_act_join_api:get_authentication_player(AuthenticationId, ModuleId)
	end,
	F = fun({PlayerId, GuildId}, AccMap) -> 
		maps:put(PlayerId, #join_log{player_id = PlayerId, guild_id = GuildId}, AccMap)
	end,
	JoinLog = lists:foldl(F, #{}, LogList),
	JoinLog.

init_auction_join_num(Auction, AuctionMap, JoinLogMap) ->
	GuildJoinNumMap = lib_auction_util:count_every_guild_join_num(JoinLogMap),
	NewAuction = Auction#auction{join_log_map = JoinLogMap, act_join_num_map = GuildJoinNumMap},
	maps:put(NewAuction#auction.auction_id, NewAuction, AuctionMap).

init_goods_info([GoodsId, PlayerId, ServerId, PriceType, Price, PriceList, Time], Acc) ->
	AuctionInfo = make(auction_info, [PlayerId, ServerId, PriceType, Price, util:bitstring_to_term(PriceList), Time]),
	InfoList = maps:get(GoodsId, Acc, []),
	maps:put(GoodsId, [AuctionInfo|InfoList], Acc).

init_auction_goods(
	[GoodsId, AuctionId, GoodsType, Type, AuctionType, GuildId, ModuleId, GoodsStatus, StartTime, Wlv], 
	{GoodsMap, GuildMap, WorldMap, AuctionMap, InfoMap}) ->

	case maps:get(AuctionId, AuctionMap, false) of 
		false -> %% 没有拍卖不处理(由于用的同一张sql表，在开发服中本服拍卖和跨服拍卖的信息都放在了一起)
			{GoodsMap, GuildMap, WorldMap, AuctionMap, InfoMap};
		_ ->
			InfoList 	 = maps:get(GoodsId, InfoMap, []),
			{NextPrice, NowPrice} = get_price(GoodsType, Wlv, InfoList),
			Elem  		 = [GoodsId, AuctionId, GoodsType, Type, AuctionType, GuildId, ModuleId, GoodsStatus, StartTime, Wlv, NextPrice, NowPrice, InfoList],
			AuctionGoods = make(auction_goods, Elem),
			NewGoodsMap  = maps:put(GoodsId, AuctionGoods, GoodsMap),
			{NewGuildMap, NewWorldMap} = init_goods_catalog(GuildMap, WorldMap, AuctionGoods),
			NewAuctionMap = init_auction_estimate_bonus(AuctionGoods, AuctionMap),
			{NewGoodsMap, NewGuildMap, NewWorldMap, NewAuctionMap, InfoMap}
	end.

init_goods_catalog(GuildMap, WorldMap, #auction_goods{goods_status= GoodsStatus} = AuctionGoods) when GoodsStatus == ?GOODS_STATUS_SELL ->
	#auction_goods{
			goods_id 	= GoodsId,
			auction_type= AuctionType,
			type  		= Type,
			guild_id  	= GuildId,
			module_id 	= ModuleId
		} = AuctionGoods,
	case AuctionType of
		_ when AuctionType == ?AUCTION_GUILD orelse AuctionType == ?AUCTION_KF_REALM ->
			{GoodsList, ModuleList} = get_guild_module_goods(GuildId, GuildMap, ModuleId),
			NewGuildMap = update_guild_module_goods(GuildId, GuildMap, ModuleId, ModuleList, [GoodsId|GoodsList]), 
			NewWorldMap = WorldMap;
		?AUCTION_WORLD -> 
			GoodsList = maps:get(Type, WorldMap, []),
			NewGuildMap =  GuildMap, 
			NewWorldMap  = maps:put(Type, [GoodsId|GoodsList], WorldMap)
	end,
	{NewGuildMap, NewWorldMap};
init_goods_catalog(GuildMap, WorldMap, _AuctionGoods) ->
	{GuildMap, WorldMap}.

get_guild_module_goods(GuildId, GuildMap, ModuleId) ->
	ModuleList = maps:get(GuildId, GuildMap, []),
	Module     = lists:keyfind(ModuleId, 1, ModuleList),
	{ModuleId, GoodsList} = ?IF(Module==false, {ModuleId, []}, Module),
	{GoodsList, ModuleList}.

update_guild_module_goods(GuildId, GuildMap, ModuleId, ModuleList, GoodsList) ->
	ModuleList2 = lists:keystore(ModuleId, 1, ModuleList, {ModuleId, GoodsList} ),
	maps:put(GuildId, ModuleList2, GuildMap).

init_auction_estimate_bonus(AuctionGoodsList, AuctionMap) when is_list(AuctionGoodsList) ->
	lists:foldl(
		fun(AuctionGoods, Map) -> 
			init_auction_estimate_bonus(AuctionGoods, Map)
		end, AuctionMap, AuctionGoodsList);

init_auction_estimate_bonus(AuctionGoods, AuctionMap) ->
	#auction_goods{
			auction_id 	= AuctionId,
			auction_type= AuctionType,
			guild_id    = GuildId,
			module_id   = ModuleId
		} = AuctionGoods,
	if
	 	AuctionType == ?AUCTION_GUILD orelse AuctionType == ?AUCTION_KF_REALM -> 
			case maps:get(AuctionId, AuctionMap, 0) of 
				0 -> AuctionMap;
				Auction ->
					EstimateBonusMap = Auction#auction.estimate_bonus_map,
					OldEstimateBonus = maps:get(GuildId, EstimateBonusMap, []),
					EstimateBonus    = get_estimate_bonus(AuctionGoods),
					NewEstimateBonus = ulists:object_list_plus([EstimateBonus, OldEstimateBonus]),
					NewEstimateBonusMap = maps:put(GuildId, NewEstimateBonus, EstimateBonusMap),
					NewAuction = Auction#auction{estimate_bonus_map = NewEstimateBonusMap},
					maps:put(NewAuction#auction.auction_id, NewAuction, AuctionMap)
			end;
		true -> %% 世界拍卖也可能存在分红
			case lists:member(ModuleId, ?WORLD_BONUS_MODULE) of 
				true ->
					case maps:get(AuctionId, AuctionMap, 0) of
						0 ->
							AuctionMap; 
						Auction ->
							EstimateBonusMap = Auction#auction.estimate_bonus_map,
							OldEstimateBonus = maps:get(GuildId, EstimateBonusMap, []),
							EstimateBonus    = get_estimate_bonus(AuctionGoods),
							NewEstimateBonus = ulists:object_list_plus([EstimateBonus, OldEstimateBonus]),
							NewEstimateBonusMap = maps:put(GuildId, NewEstimateBonus, EstimateBonusMap),
							NewAuction = Auction#auction{estimate_bonus_map = NewEstimateBonusMap},
							maps:put(NewAuction#auction.auction_id, NewAuction, AuctionMap)
					end;
				_ ->
					AuctionMap
			end
	end.

init_bonus_log(DbBonusLogList) ->
	BonusLogClearTime = get_bonus_log_clear_time(),
	NewBonusLogMap = add_bonus_log_helper(#{}, DbBonusLogList),
	NewBonusMap = reinit_bonus_map(NewBonusLogMap, BonusLogClearTime),
	% ?PRINT("init_bonus_log ClearTime:~p~n", [utime:unixtime_to_localtime(BonusLogClearTime)]),
	% ?PRINT("init_bonus_log log_map:~p~n", [maps:values(NewBonusLogMap)]),
	% ?PRINT("init_bonus_log bonus_map:~p~n", [maps:values(NewBonusMap)]),
	{NewBonusLogMap, NewBonusMap}.

init_player_log([PlayerId, ServerId, OpType, ModuleId, PriceType, Gold, Bgold, GoodsType, Wlv, Time], Acc) ->
	PlayerAuctionLog = make(player_auction_log, [PlayerId, ServerId, OpType, ModuleId, PriceType, Gold, Bgold, GoodsType, Wlv, Time]),
	List = maps:get(PlayerId, Acc, []),
	maps:put(PlayerId, [PlayerAuctionLog|List], Acc).

%% 物品可以产出的分红
get_estimate_bonus(AuctionGoodsList) when is_list(AuctionGoodsList)->
	ulists:object_list_plus([get_estimate_bonus(AuctionGoods)||AuctionGoods<-AuctionGoodsList]);

get_estimate_bonus(AuctionGoods) ->
	#auction_goods{
			goods_type = GoodsType,
			auction_type= _AuctionType,
			module_id   = ModuleId,
			now_price   = NowPrice,
			wlv 		= Wlv,
			info_list   = InfoList
		} = AuctionGoods,
	case InfoList of
		[] -> 
			get_unsold_bonus_list(ModuleId, GoodsType, Wlv);
		_ -> 
			case lists:keyfind(NowPrice, #auction_info.price, InfoList) of 
				#auction_info{price_list = PriceList} -> PriceList;
				_ -> get_unsold_bonus_list(ModuleId, GoodsType, Wlv)
			end
	end.

init_auction_log([AuctionType, ModuleId, GuildId, GoodsType, Wlv, Price, Time, ToWorld], {GuildLogMap, WorldLogList}) ->
	AuctionLog = make(auction_log, [ModuleId, GoodsType, Wlv, Price, Time, ToWorld]),
	case AuctionType of
		?AUCTION_GUILD ->
			LogList = maps:get(GuildId, GuildLogMap, []),
			NewLogList = [AuctionLog|LogList],
			NewGuildLogMap = maps:put(GuildId, NewLogList, GuildLogMap),
			NewWorldLogList= WorldLogList;
		_ ->
			NewGuildLogMap = GuildLogMap,
			NewWorldLogList= [AuctionLog|WorldLogList]
	end,
	{NewGuildLogMap, NewWorldLogList}.

%% 重置全部目录
reinit_goods_catalog(reinit_all, {GoodsMap, _GuildMap, _WorldMap}) ->
	lists:foldl(
		fun({_K,  AuctionGoods}, {AccGuildMap, AccWorldMap}) ->
			init_goods_catalog(AccGuildMap, AccWorldMap, AuctionGoods)
		end, {#{}, #{}}, maps:to_list(GoodsMap));

%% 重置目录：公会拍卖拍出时
reinit_goods_catalog(reinit_guild, {_GoodsMap, GuildMap, WorldMap, GuildId, ModuleId, GoodsId}) ->
	ModuleGoodsList = maps:get(GuildId, GuildMap, []),
	Res = lists:keyfind(ModuleId, 1, ModuleGoodsList),
	{_ModuleId, GoodsList} = ?IF(Res == false, {ModuleId, []}, Res),
	NewGoodsList = [Id||Id<-GoodsList, Id=/=GoodsId],
	ModuleGoodsList2 =lists:keystore(ModuleId, 1, ModuleGoodsList, {ModuleId, NewGoodsList}),
	{maps:put(GuildId, ModuleGoodsList2, GuildMap), WorldMap};

%% 重置目录：世界拍卖拍出时
reinit_goods_catalog(reinit_world, {_GoodsMap, GuildMap, WorldMap, Type, GoodsId}) ->
	GoodsList = maps:get(Type, WorldMap, []),
	NewGoodsList = [Id||Id<-GoodsList, Id=/=GoodsId],
	{GuildMap, maps:put(Type, NewGoodsList, WorldMap)}.

reinit_bonus_map(BonusLogMap, BonusLogClearTime) ->
	F = fun(PlayerId, PlayerBonusLogs, Map) ->
		ModuleBonusInfos = reinit_module_bonus(lists:keysort(#bonus_log.module_id, PlayerBonusLogs), BonusLogClearTime, []),
		maps:put(PlayerId, ModuleBonusInfos, Map)
	end,
	BonusMap = maps:fold(F, #{}, BonusLogMap),
	BonusMap.

reinit_module_bonus([], _BonusLogClearTime, Return) -> Return;
reinit_module_bonus([#bonus_log{module_id = ModuleId, gold = Gold, bgold = BGold, time = Time}|PlayerBonusLogs], BonusLogClearTime, Return) ->
	case Time =< BonusLogClearTime of 
		false ->
			case Return of 
				[#bonus_info{module_id = ModuleId, gold = OldGold, bgold = OldBgold}|L] ->
					NewBonusInfo = #bonus_info{module_id = ModuleId, gold = OldGold+Gold, bgold = OldBgold+BGold},
					NewReturn = [NewBonusInfo|L];
				_ ->
					NewBonusInfo = #bonus_info{module_id = ModuleId, gold = Gold, bgold = BGold},
					NewReturn = [NewBonusInfo|Return]
			end,
			reinit_module_bonus(PlayerBonusLogs, BonusLogClearTime, NewReturn);
		_ ->
			reinit_module_bonus(PlayerBonusLogs, BonusLogClearTime, Return)
	end.

add_bonus_log(State, BonusLogList) ->
	#auction_state{bonus_log_map = BonusLogMap} = State,
	BonusLogClearTime = get_bonus_log_clear_time(),
	spawn(fun() -> db_add_bonus_log_batch(BonusLogList) end),
	NewBonusLogMap = add_bonus_log_helper(BonusLogMap, BonusLogList),
	NewBonusMap = reinit_bonus_map(NewBonusLogMap, BonusLogClearTime),
	% ?PRINT("add_bonus_log ClearTime:~p~n", [utime:unixtime_to_localtime(BonusLogClearTime)]),
	% ?PRINT("add_bonus_log log_map:~p~n", [maps:values(NewBonusLogMap)]),
	% ?PRINT("add_bonus_log bonus_map:~p~n", [maps:values(NewBonusMap)]),
	{ok, State#auction_state{bonus_log_map = NewBonusLogMap, bonus_map = NewBonusMap}}.

add_bonus_log_helper(BonusLogMap, BonusLogList) ->
	F = fun([PlayerId, ModuleId, Gold, BGold, Time], Map) ->
		BonusLog = make(bonus_log, [PlayerId, ModuleId, Gold, BGold, Time]),
		OldPlayerBonusLogs = maps:get(PlayerId, Map, []),
		maps:put(PlayerId, [BonusLog|OldPlayerBonusLogs], Map)
	end,
	NewBonusLogMap = lists:foldl(F, BonusLogMap, BonusLogList),
	NewBonusLogMap.

%% {next_price, now_price}
get_price(GoodsType, Wlv, InfoList) ->
	case lists:reverse(lists:keysort(#auction_info.price, InfoList)) of
		[#auction_info{price = Price}|_] -> 
			{get_next_price(GoodsType, Wlv, Price), Price};
		_ -> 
			BasePrice = get_base_price(GoodsType, Wlv),
			{BasePrice, BasePrice}
	end.

get_next_price(GoodsType, Wlv, TopPrice) ->
	BasePrice 	= get_base_price(GoodsType, Wlv),
	AddPrice    = get_add_price(GoodsType, Wlv),
	Price 		= AddPrice + TopPrice,
	OnePrice 	= get_one_price(GoodsType, Wlv),
	NewPrice 	= min(Price, OnePrice),
	max(BasePrice, NewPrice).

get_one_price(GoodsType, Wlv) ->
	case data_auction:get_goods(GoodsType, Wlv) of 
		#base_auction_goods{one_price = OnePrice} -> OnePrice;
		_ -> 10000
	end.

get_base_price(GoodsType, Wlv) ->
	case data_auction:get_goods(GoodsType, Wlv) of 
		#base_auction_goods{base_price = BasePrice} -> BasePrice;
		_ -> 100
	end.

get_add_price(GoodsType, Wlv) ->
	case data_auction:get_goods(GoodsType, Wlv) of 
		#base_auction_goods{add_price = AddPrice} -> AddPrice;
		_ -> 10
	end.

get_unsold_price(GoodsType, Wlv) ->
	case data_auction:get_goods(GoodsType, Wlv) of 
		#base_auction_goods{unsold_price = UnsoldPrice} -> 
			lists:sum([Num || {_, _, Num}<- UnsoldPrice]);
		_ -> 0
	end.

get_unsold_price_list(GoodsType, Wlv) ->
	case data_auction:get_goods(GoodsType, Wlv) of 
		#base_auction_goods{unsold_price = UnsoldPrice} -> 
			UnsoldPrice;
		_ -> []
	end.

get_unsold_bonus_list(ModuleId, GoodsType, Wlv) ->
	case lib_auction_data:unsold_need_bonus(ModuleId) of 
		true ->
			lib_auction_data:get_unsold_price_list(GoodsType, Wlv);
		_ ->
			[]
	end.

get_real_goods(GoodsType, Wlv) ->
	case data_auction:get_goods(GoodsType, Wlv) of 
		#base_auction_goods{gtype_id = GoodsTypeId, goods_num = GoodsNum} -> 
			{GoodsTypeId, GoodsNum};
		_ -> {}
	end.

get_auction_goods_name(GoodsType, Wlv) ->
	case data_auction:get_goods(GoodsType, Wlv) of 
		#base_auction_goods{name = Name} -> 
			util:make_sure_binary(Name);
		_ -> <<>>
	end.

get_top_player(NowPrice, InfoList) ->
	case lists:keyfind(NowPrice, #auction_info.price, InfoList) of
		#auction_info{player_id = TopPlayerId, server_id = ServerId} -> skip;
		_ -> TopPlayerId = 0, ServerId = 0
	end,
	{TopPlayerId, ServerId}.

get_guild_start_time(ModuleId, NowTime, StartTimeIn) ->
	case StartTimeIn > NowTime + 1 of 
		true -> StartTimeIn;
		_ ->
			case data_auction:get_guild_notice_duration(ModuleId) of 
				NoticeTime when NoticeTime > 0 ->
					NowTime + NoticeTime;
				NoticeTime when  NoticeTime < 0 -> %% 功能内部自己定义的开拍时间， 目前暂时没有这样的功能，先用默认值替代
					NowTime + ?GUILD_NOTICE1_BEFORE;
				_ -> %% 默认值
					NowTime + ?GUILD_NOTICE1_BEFORE
			end
	end.

get_world_start_time(ModuleId, NowTime, StartTimeIn) ->
	case StartTimeIn > NowTime + 1 of 
		true -> StartTimeIn;
		_ ->
			case data_auction:get_world_notice_duration(ModuleId) of 
				NoticeTime when NoticeTime > 0 ->
					NowTime + NoticeTime;
				NoticeTime when NoticeTime < 0 -> %% 功能内部自己定义的开拍时间， 目前暂时没有这样的功能，先用默认值替代
					NowTime + ?WORLD_NOTICE1_BEFORE;
				_ -> %% 默认值
					NowTime + ?WORLD_NOTICE1_BEFORE
			end
	end.

get_auction_endtime(Auction) ->
	#auction{
		auction_type 	= AuctionType,
		module_id       = ModuleId,
		time 		 	= StartTime,
		delay_guild_map = DelayGuildMap
	} = Auction,
	DelayList = maps:values(DelayGuildMap),
	case lists:reverse(lists:keysort(2, DelayList)) of
		[{_DelayNum, EndTime}|_] -> EndTime;
		_ -> get_endtime(ModuleId, AuctionType, StartTime)
	end.

get_goods_endtime(AuctionGoods) ->
	#auction_goods{ 
		auction_type	= AuctionType, 
		module_id       = ModuleId,
		start_time 		= StartTime, 
		delay_num 		= DelayNum
	} = AuctionGoods,
	DelayTime = get_total_delay_time(DelayNum),
	get_endtime(ModuleId, AuctionType, StartTime) + DelayTime.

get_endtime(ModuleId, AuctionType, StartTime) ->
	case AuctionType of
		?AUCTION_GUILD -> StartTime + ?GUILD_AUCTION_DURATION(ModuleId);
		?AUCTION_KF_REALM -> StartTime + ?GUILD_AUCTION_DURATION(ModuleId);
		?AUCTION_WORLD -> StartTime + ?WORLD_AUCTION_DURATION(ModuleId)
	end.

%% 根据延时次数获取总延时时间
get_total_delay_time(DelayNum) when DelayNum> 0->
	lists:sum([get_delay_time(0, Num)||Num<-lists:seq(1, DelayNum)]);
get_total_delay_time(_DelayNum) -> 0.

%% 获取功能分红上限
get_module_bonus_limit(ModuleId) ->
	case data_auction:get_bonus_limit(ModuleId) of 
		[{GoldLimit, BGoldLimit}] -> {GoldLimit, BGoldLimit};
		_ -> {0, 0}
	end.

get_player_real_bonus(PlayerId, ModuleId, BonusMap, Gold, Bgold, GoldLimit, BGoldLimit) ->
	ModuleBonusInfos = maps:get(PlayerId, BonusMap, []),
	case lists:keyfind(ModuleId, #bonus_info.module_id, ModuleBonusInfos) of 
		#bonus_info{gold = GoldGot, bgold = BgoldGot} ->
			ok;
		_ ->
			GoldGot = 0, BgoldGot = 0
	end,
	get_real_bonus(ModuleId, GoldLimit, BGoldLimit, GoldGot, BgoldGot, Gold, Bgold).

get_real_bonus(ModuleId, GoldLimit, BGoldLimit, GoldGot, BgoldGot, Gold, Bgold) ->
	{GoldOneTimes, BGoldOneTimes} = get_bonus_produce_one_times(ModuleId),
	NewGold = ?IF(GoldLimit =/= 0, min(Gold, max(GoldLimit-GoldGot, 0)), Gold),
	NewBgold = ?IF(BGoldLimit =/= 0, min(Bgold, max(BGoldLimit-BgoldGot, 0)), Bgold),
	LastGold = ?IF(GoldOneTimes =/= 0 andalso NewGold > GoldOneTimes, GoldOneTimes, NewGold),
	LastBgold = ?IF(BGoldOneTimes =/= 0 andalso NewBgold > BGoldOneTimes, BGoldOneTimes, NewBgold),
	{LastGold, LastBgold}.

unsold_need_bonus(ModuleId) ->
	if
		ModuleId == ?MOD_SEACRAFT -> false;
		true -> true
	end.

get_bonus_log_clear_time() ->
	NowTimeLogic = utime_logic:get_logic_day_start_time(),
	WeekDay = utime:day_of_week(NowTimeLogic),
	NowTimeLogic - (WeekDay - 1) * ?ONE_DAY_SECONDS.

get_bonus_produce_one_times(ModuleId) ->
	if
		ModuleId == ?MOD_SEACRAFT -> {100, 200};
		true -> {0, 0}
	end.

get_goods_type(GoodsType, Wlv) ->
	case data_auction:get_goods(GoodsType, Wlv) of
		#base_auction_goods{type = Type} -> Type;
		_ -> 0
	end.

get_pay_fail_player_log([], _AuctionGoods, _PlayerList, Return) ->
	Return;
get_pay_fail_player_log([AuctionInfo|InfoList], AuctionGoods, PlayerList, Return) ->
	#auction_info{player_id = PlayerId, server_id = ServerId, price_type = _PriceType, price_list = PriceList, time = Time} = AuctionInfo,
	case lists:member(PlayerId, PlayerList) of 
		true ->
			get_pay_fail_player_log(InfoList, AuctionGoods, PlayerList, Return);
		_ ->
			#auction_goods{
				goods_type = GoodsType, module_id = ModuleId, wlv = Wlv
			} = AuctionGoods,
			{ReturnGold, ReturnBgold} = lib_auction_util:count_award_gold(PriceList, 0, 0),
			Elem = [PlayerId, ServerId, 2, ModuleId, 0, ReturnGold, ReturnBgold, GoodsType, Wlv, Time],
			get_pay_fail_player_log(InfoList, AuctionGoods, [PlayerId|PlayerList], [Elem|Return])
	end.

init_kf_auction_join_log(BonusPlayerList) ->
	lists:foldl(fun({PlayerId, GuildId, ServerId}, Map) -> 
		maps:put(PlayerId, #join_log{player_id = PlayerId, guild_id = GuildId, server_id = ServerId}, Map) end, 
		#{}, BonusPlayerList).

get_goods_config(#auction_goods{goods_type = GoodsType, wlv = Wlv}) ->
	data_auction:get_goods(GoodsType, Wlv);
get_goods_config(_) -> [].

%% 竞价延时(秒)
%% Time 		:: 距离物品拍卖结束时间(s)
%% DelayNum 	:: 竞价延时次数
%% @return (秒)
get_delay_time(Time, DelayNum) when Time<30 ->
	if
		DelayNum=<1 -> 30;
		DelayNum=<2 -> 30;		
		true -> 10
	end;
get_delay_time(_Time, _DelayNum) -> 0.

%% ------------------------------ make function %% ---------------------------

make(auction_state, [AuctionMap, GoodsMap, GuildMap, WorldMap, GuildLogMap, WorldLogList, PlayerLogMap, BonusLogMap, BonusMap]) ->
	#auction_state{
		auction_map 	= AuctionMap,
		goods_map 		= GoodsMap,
		guild_map 		= GuildMap,
		world_map  		= WorldMap,
		guild_log_map 	= GuildLogMap,
		world_log_list 	= WorldLogList,
		player_log_map  = PlayerLogMap,
		bonus_log_map   = BonusLogMap,
		bonus_map       = BonusMap
	};
make(kf_auction_state, [KfServerId, AuctionMap, GoodsMap, GuildMap, WorldMap]) ->
	#kf_auction_state{
		kf_server_id    = KfServerId,
		auction_map 	= AuctionMap,
		goods_map 		= GoodsMap,
		guild_map 		= GuildMap,
		world_map  		= WorldMap
	};
make(auction, [AuctionId, AuctionType, IsCls, ZoneId, ModuleId, AuthenticationId, AuctionStatus, Time, LastTime]) ->
	#auction{
		auction_id 		= AuctionId,
		auction_type 	= AuctionType,
		module_id 		= ModuleId,
		is_cls = IsCls,
		authentication_id = AuthenticationId,
		zone_id = ZoneId,
		auction_status  = AuctionStatus,
		time 			= Time,
		last_time 		= LastTime
	};
make(auction_info, [PlayerId, ServerId, PriceType, Price, PriceList, Time]) ->
	#auction_info{
		player_id  		= PlayerId, 
		server_id       = ServerId,
		price_type 		= PriceType,
		price 			= Price,
		price_list 		= PriceList,
		time 			= Time
	};
make(auction_goods, [GoodsId, AuctionId, GoodsType, Type, AuctionType, 
		GuildId, ModuleId, GoodsStatus, StartTime, Wlv, NextPrice, NowPrice, InfoList]) ->
	#auction_goods{
		goods_id 		= GoodsId,
		auction_id 		= AuctionId,
		goods_type 		= GoodsType,
		type 			= Type,
		auction_type 	= AuctionType,
		guild_id 		= GuildId,
		module_id 		= ModuleId,
		goods_status 	= GoodsStatus,
		start_time 		= StartTime,
		wlv             = Wlv,
		next_price 		= NextPrice,
		now_price 		= NowPrice,
		info_list 		= InfoList
	};
make(auction_log, [ModuleId, GoodsType, Wlv, Price, Time, ToWorld]) ->
	#auction_log{
		module_id 		= ModuleId,
		goods_type 		= GoodsType,
		wlv  			= Wlv,
		price 			= Price, 
		time 			= Time,
		to_world 		= ToWorld
	};
make(bonus_log, [_PlayerId, ModuleId, Gold, BGold, Time]) ->
	#bonus_log{
		module_id = ModuleId,
		gold = Gold,
		bgold = BGold,
		time = Time
	};
make(player_auction_log, [_PlayerId, ServerId, OpType, ModuleId, PriceType, Gold, Bgold, GoodsType, Wlv, Time]) ->
	#player_auction_log{
		server_id   = ServerId,
		op_type     = OpType,                    
		module_id 	= ModuleId,				
		price_type  = PriceType,                 
		gold        = Gold,               
		bgold       = Bgold,                 
		goods_type  = GoodsType, 				
		wlv 		= Wlv,					
		time 		= Time 					
	};
make(_Atom, _Args) -> 
	?ERR("no_match:~p,~p", [_Atom, _Args]),
	no_match.


%% ------------------------------- db function %% ----------------------------

add_auction_db(Elem) ->
	SqlAuction  = io_lib:format(?SQL_AUCTION_INSERT, Elem),
	db:execute(SqlAuction),	
	ok.

add_auction_goods_db(Elem) ->
	SqlAuction  = io_lib:format(?SEL_AUCTION_GOODS_INSERT, Elem),
	db:execute(SqlAuction),	
	ok.

add_auction_info_db(Elem) ->
	SqlAuction  = io_lib:format(?SQL_AUCTION_INFO_INSERT, Elem),
	db:execute(SqlAuction),	
	ok.

%% 这个记录先屏蔽数据库操作，目前不需要这个信息，需要再开放
add_auction_log_db_batch([], _I) -> ok;
add_auction_log_db_batch(_, _I) -> ok.
% add_auction_log_db_batch([Elem|T], I) ->
% 	case I rem 20 of
% 		0 -> timer:sleep(300);
% 		_ -> skip
% 	end,
% 	add_auction_log_db(Elem),
% 	add_auction_log_db_batch(T, I+1).

add_auction_log_db(_Elem) ->
	% SqlAuction  = io_lib:format(?SQL_AUCTION_LOG_INSERT, Elem),
	% db:execute(SqlAuction),	
	ok.

add_player_auction_log_db(Elem) ->
	SqlAuction  = io_lib:format(?SQL_PLAYER_LOG_INSERT, Elem),
	db:execute(SqlAuction),	
	ok.

add_guild_award_db_batch([], _I) -> ok;
add_guild_award_db_batch([Elem|T], I) ->
	case I rem 20 of
		0 -> timer:sleep(300);
		_ -> skip
	end,
	add_guild_award_db(Elem),
	add_guild_award_db_batch(T, I+1).

add_guild_award_db(Elem) ->
	SqlAuction  = io_lib:format(?SQL_AUCTION_GUILD_AWARD_INSERT, Elem),
	db:execute(SqlAuction),	
	ok.

db_add_bonus_log([]) -> ok;
db_add_bonus_log(ElemList) ->
	Sql = usql:replace(auction_bonus_log, [player_id, module_id, gold, bgold, time], ElemList),
	db:execute(Sql),	
	ok.

db_add_bonus_log_batch([]) -> ok;
db_add_bonus_log_batch(BonusLogList) ->
	case length(BonusLogList) > 20 of 
		true ->
			{ElemList, LeftList} = lists:split(20, BonusLogList);
		_ -> 
			ElemList = BonusLogList,
			LeftList = []
	end,
	db_add_bonus_log(ElemList),
	timer:sleep(300),
	db_add_bonus_log_batch(LeftList).

add_auction_join_log_db(_AuctionId, []) -> ok;
add_auction_join_log_db(AuctionId, BonusPlayerList) ->
	ElemList = [[AuctionId, PlayerId, GuildId, ServerId] ||{PlayerId, GuildId, ServerId} <- BonusPlayerList],
	Sql = usql:replace(auction_join_log, [auction_id, player_id, guild_id, server_id], ElemList),
	db:execute(Sql),	
	ok.

update_auction_db(Elem) ->
	SqlAuction  = io_lib:format(?SQL_AUCTION_UPDATE, Elem),
	db:execute(SqlAuction),
	ok.

update_auction_goods_db(Elem) ->
	SqlAuction  = io_lib:format(?SQL_AUCTION_GOODS_UPDATE, Elem),
	db:execute(SqlAuction),
	ok.
	
delete_auction_db(Elem) ->
	SqlAuction  = io_lib:format(?SQL_AUCTION_DELETE, Elem),
	db:execute(SqlAuction),	
	ok.

delete_auction_goods_db(Elem) ->
	SqlAuction  = io_lib:format(?SEL_AUCTION_GOODS_DELETE, Elem),
	db:execute(SqlAuction),	
	ok.

delete_auction_info_db(Elem) ->
	SqlAuction  = io_lib:format(?SQL_AUCTION_INFO_DELETE, Elem),
	db:execute(SqlAuction),	
	ok.

delete_auction_log_db() ->
	SqlAuction  = io_lib:format(?SQL_AUCTION_LOG_TRUNCATE, []),
	db:execute(SqlAuction),	
	ok.	

delete_guild_award_db(Elem) ->
	SqlAuction  = io_lib:format(?SQL_AUCTION_GUILD_AWARD_DELETE, Elem),
	db:execute(SqlAuction),	
	ok.

delete_auction_join_log_db(Elem) ->
	SqlAuction  = io_lib:format(?SQL_AUCTION_JOIN_LOG_DELETE, Elem),
	db:execute(SqlAuction),	
	ok.

delete_overtime_guild_award_db(AwardMap, AuctionMap) ->
	AuctionIdList = maps:keys(AwardMap),
	F = fun(AuctionId) -> 
		case maps:get(AuctionId, AuctionMap, #{}) of
			#{} -> delete_guild_award_db([AuctionId]);
			_ -> skip
		end
	end,
	lists:foreach(F, AuctionIdList).
	
delete_close_goods_db(AuctionId) ->
	F = fun() -> 
		delete_auction_info_db([AuctionId]),
		delete_auction_goods_db([AuctionId]),
		delete_auction_db([AuctionId]),
		delete_guild_award_db([AuctionId]),
		delete_auction_join_log_db([AuctionId]),
		ok
	end,	
	case catch db:transaction(F) of
        ok  -> ok;
        Error -> ?ERR("delete_close_goods_db Error:~p~n", [Error])            
    end.

delete_bonus_log_db() ->
	Sql  = io_lib:format(?SQL_BONUS_LOG_TRUNCATE, []),
	db:execute(Sql),	
	ok.	

delete_player_log_db() ->
	Sql  = io_lib:format(?SQL_PLAYER_LOG_TRUNCATE, []),
	db:execute(Sql),	
	ok.

% reinit_auction_own_guilds(AuctionMap, GoodsMap) ->
% 	F = fun(_AuctionId, Auction) ->
% 		count_auction_own_guild(Auction, GoodsMap)
% 	end,
% 	maps:map(F, AuctionMap).

% count_auction_own_guild(Auction, GuildIdList) when is_list(GuildIdList) ->
% 	Auction#auction{own_guilds = GuildIdList};
% count_auction_own_guild(Auction, GoodsMap) when is_map(GoodsMap) ->
% 	#auction{auction_id = AuctionId, auction_type = AuctionType} = Auction,
% 	case AuctionType == ?AUCTION_GUILD of 
% 		true ->
% 			F = fun(_GoodsId, #auction_goods{auction_id = AuctionId1, guild_id = GuildId}, GuildIdList) ->
% 				case AuctionId1 == AuctionId of 
% 					true -> [GuildId|lists:delete(GuildId, GuildIdList)];
% 					_ -> GuildIdList
% 				end
% 			end,
% 			GuildIdList = maps:fold(F, [], GoodsMap),
% 			Auction#auction{own_guilds = GuildIdList};
% 		_ ->
% 			Auction#auction{own_guilds = [0]}
% 	end;
% count_auction_own_guild(Auction, _) ->
% 	Auction.