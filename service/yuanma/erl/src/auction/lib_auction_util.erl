%% ---------------------------------------------------------------------------
%% @doc 拍卖行
%% @author liuxl
%% @since  
%% @deprecated 
%% ---------------------------------------------------------------------------

-module (lib_auction_util).
-include ("common.hrl").
-include ("rec_auction.hrl").
-include ("def_timer_quest.hrl").
-include ("auction_module.hrl").
-include ("def_fun.hrl").
-include ("language.hrl").
-include ("predefine.hrl").
-include ("def_event.hrl").
-include ("errcode.hrl").
-include ("clusters.hrl").
-compile (export_all).

%% 竞价延时，重置定时器
pay_auction_delay(AuctionMap, GoodsMap, AuctionGoods) ->
	NowTime = utime:unixtime(),
	#auction_goods{delay_num = DelayNum} = AuctionGoods,
	NewDelayNum = DelayNum + 1,
	GoodsEndTime = lib_auction_data:get_goods_endtime(AuctionGoods),	
	DiffTime= max(GoodsEndTime - NowTime, 0),
	case lib_auction_data:get_delay_time(DiffTime, NewDelayNum) of
		DelayTime when DelayTime > 0 ->
			AuctionEndTime = GoodsEndTime + DelayTime,
			NewAuctionGoods = AuctionGoods#auction_goods{delay_num  = NewDelayNum},
			{NewAuctionMap, NewGoodsMap} = do_pay_delay_core(AuctionMap, GoodsMap, 
				NewAuctionGoods, AuctionEndTime, NowTime),
			notify_goods_info_to_all(NewAuctionMap, NewAuctionGoods);
		_ -> {NewAuctionMap, NewGoodsMap} = {AuctionMap, GoodsMap}
	end,
	{NewAuctionMap, NewGoodsMap}.

%% 竞价延时
%% @return {AuctionMap, AuctionGoods}
do_pay_delay_core(AuctionMap, GoodsMap, AuctionGoods, AuctionEndTime, NowTime) ->
	#auction_goods{
		goods_id = GoodsId, auction_id = AuctionId, 
		guild_id = GuildId, delay_num = GoodsDelayNum} = AuctionGoods,
	Auction = maps:get(AuctionId, AuctionMap),
	DelayGuildMap = Auction#auction.delay_guild_map,
	{DelayNum, _EndTime} = maps:get(GuildId, DelayGuildMap, {0, 0}),
	case GoodsDelayNum > DelayNum of
		true ->	
			NewDelayGuildMap = maps:put(GuildId, {GoodsDelayNum, AuctionEndTime}, DelayGuildMap),
			NewAuction = Auction#auction{delay_guild_map = NewDelayGuildMap},
			start_auction_delay_timer(Auction, GuildId, AuctionEndTime, NowTime);
		false -> NewAuction = Auction
	end,
	NewAuctionMap = maps:put(AuctionId, NewAuction, AuctionMap),
	NewGoodsMap   = maps:put(GoodsId, AuctionGoods, GoodsMap),
	{NewAuctionMap, NewGoodsMap}.

%% 开启延时定时器
start_auction_delay_timer(Auction, GuildId, AuctionEndTime, NowTime) ->
	AuctionId= Auction#auction.auction_id,
	IsClsAuction = Auction#auction.is_cls,
	Duration = max(AuctionEndTime - NowTime, 0),
	AuctionType = Auction#auction.auction_type,
	if	
		%% 公会拍卖，延时该公会拍卖物品
		AuctionType == ?AUCTION_GUILD orelse AuctionType == ?AUCTION_KF_REALM ->
			timer_quest:delete(?UTIMER_ID(?TIMER_AUCTION_DELAY, {AuctionId, GuildId})),
			Mod = ?IF(IsClsAuction == 1, mod_kf_auction, mod_auction),
			timer_quest:add(?UTIMER_ID(?TIMER_AUCTION_DELAY, {AuctionId, GuildId}), Duration, 0, {Mod, close_auction, [{AuctionId, GuildId, ?CLOSE_AUCTION_NORMAL}]});
		%% 世界拍卖，则直接重置场次结束定时器
		true ->
			% ModuleId = Auction#auction.module_id,
			% if
			% 	ModuleId == ?AUCTION_MOD_C_SANCTUARY ->
			% 		mod_c_sanctuary_local:delay_auction(AuctionEndTime);
			% 	true ->
			% 		skip
			% end,
			restart_close_auction_timer(Auction, Duration)
	end.

%% 重置场次结束定时器
restart_close_auction_timer(AuctionMap) ->
	NowTime = utime:unixtime(),
	lists:foreach(
		fun({_AuctionId, #auction{auction_status = _AuctionStatus, time = StarTime} = Auction }) ->
			case NowTime < StarTime of 
				true ->
					Duration = StarTime - NowTime,
					restart_notice_auction_timer(Auction, Duration);
				_ ->
					AuctionEndTime = lib_auction_data:get_auction_endtime(Auction),			
					Duration = max(AuctionEndTime - NowTime, 0),
					restart_close_auction_timer(Auction, Duration)
			end
		end, maps:to_list(AuctionMap)),
	ok.

%% 重置场次结束定时器
restart_close_auction_timer(Auction, Duration) ->
	?PRINT("restart_close_auction_timer Duration : ~p~n", [Duration]),
	AuctionId = Auction#auction.auction_id,	
	IsClsAuction = Auction#auction.is_cls,
	Mod = ?IF(IsClsAuction == 1, mod_kf_auction, mod_auction),
	timer_quest:delete(?UTIMER_ID(?TIMER_AUCTION, AuctionId)),
	timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, 
		{Mod, close_auction, [{AuctionId, 0, ?CLOSE_AUCTION_NORMAL}] }),
	ok.

restart_notice_auction_timer(Auction, Duration) ->
	?PRINT("restart_notice_auction_timer Duration : ~p~n", [Duration]),
	AuctionId = Auction#auction.auction_id,
	AuctionType = Auction#auction.auction_type,
	ModuleId = Auction#auction.module_id,
	IsClsAuction = Auction#auction.is_cls,
	Mod = ?IF(IsClsAuction == 1, mod_kf_auction, mod_auction),
	timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, {
		Mod, start_auction_notice, [{AuctionType, AuctionId, ?AUCTION_STATUS_NOTICE2, ModuleId, []}] }),
	ok.

%% 邮件物品
mail_auction_goods(Args) ->
	[PlayerId, GuildId, ModuleId, AuctionType, GoodsId, Price, GoodsType, ReturnList] = Args,
	Title   = ?LAN_MSG(?LAN_TITLE_AUCTION_SUCCESS),
	Content = uio:format(?LAN_MSG(?LAN_CONTENT_AUCTION_SUCCESS), [data_goods_type:get_name(GoodsType)]),
	lib_mail_api:send_sys_mail([PlayerId], Title, Content, ReturnList),
	lib_player_event:async_dispatch(PlayerId, ?HAND_OFFLINE, ?EVENT_AUCTION_SUCCESS, []),
	lib_log_api:log_auction_award(PlayerId, GuildId, ModuleId, AuctionType, GoodsId, GoodsType, Price),
	ok.
	
%% 统计分红信息
static_player_bonus_info(PlayerBonusList, BonusMap, GoldLimit, BGoldLimit) ->
	F = fun([PlayerId, GuildId, ModuleId, Gold, Bgold, NowTime], {BonusLogList, BonusList}) ->
		{RGold, Rbgold} = lib_auction_data:get_player_real_bonus(PlayerId, ModuleId, BonusMap, Gold, Bgold, GoldLimit, BGoldLimit),
		GoodsList = if
			RGold >0 andalso Rbgold > 0  -> 
				[{?TYPE_BGOLD, 0, Rbgold}, {?TYPE_GOLD, 0, RGold}];
			RGold >0 ->
				[{?TYPE_GOLD, 0, RGold}];
			Rbgold > 0 ->
				[{?TYPE_BGOLD, 0, Rbgold}];		
			true ->
				[]
		end,
		case GoodsList=/=[] of
			true -> 
				NewBonusLogList = [[PlayerId, ModuleId, RGold, Rbgold, NowTime]|BonusLogList],
				NewBonusList = [[PlayerId, GuildId, ModuleId, GoodsList]|BonusList];
			false -> 
				NewBonusLogList = BonusLogList,
				NewBonusList = BonusList
		end,
		{NewBonusLogList, NewBonusList}
	end,
	lists:foldl(F, {[], []}, PlayerBonusList).


%% 邮件分红
mail_bonus(ModuleId, _AuthenticationId, BonusList, BonusLogList) ->
	% case ModuleId of
	% 	?AUCTION_MOD_C_SANCTUARY -> %% 功能模块自己发分红
	% 		mod_c_sanctuary_local:role_auction_divident(AuthenticationId, BonusList),
	% 		SendBonus = false;
	% 	_ ->
	% 		mod_auction:add_bonus_log(BonusLogList),
	% 		SendBonus = true
	% end,
	mod_auction:add_bonus_log(BonusLogList),
	SendBonus = true,
	Title   = ?LAN_MSG(?LAN_TITLE_AUCTION_AWARD),
	Content = uio:format(?LAN_MSG(?LAN_CONTENT_AUCTION_AWARD), [data_auction:get_module_name(ModuleId)]),
	F = fun([PlayerId, GuildId, _ModuleId, GoodsList], Acc) ->
		case Acc rem 20 of
			0 -> timer:sleep(300);
			_ -> skip
		end,
		SendBonus == true andalso lib_mail_api:send_sys_mail([PlayerId], Title, Content, GoodsList),
		lib_log_api:log_auction_bonus(PlayerId, GuildId, ModuleId, GoodsList),
		Acc + 1
	end,
	lists:foldl(F, 1, BonusList),
	ok.

%% 计算公会参与人数
count_every_guild_join_num(JoinLog) ->
	count_every_guild_join_num_helper(maps:to_list(JoinLog), #{}).

count_every_guild_join_num_helper([], GuildJoinNumMap) -> GuildJoinNumMap;
count_every_guild_join_num_helper([{_PlayerId, JoinLog}|T], GuildJoinNumMap) ->
	#join_log{guild_id = GuildId} = JoinLog,
	Num = maps:get(GuildId, GuildJoinNumMap, 0),
	count_every_guild_join_num_helper(T, maps:put(GuildId, Num + 1, GuildJoinNumMap)).

%% GuildMoneyMap   :: #{guild_id => [{?TYPE_BGOLD, 0, Num},{?TYPE_GOLD, 0, Num}]}
%% GuildJoinNumMap :: #{guild_id => Num}
%% return          :: #{GuildId => {Gold, Bgold}}
count_every_guild_bonus(GuildMoneyMap, GuildJoinNumMap) ->
	maps:fold(
		fun(GuildId, Num, GuildBonusMap) when Num>0 -> 
			MoneyList = maps:get(GuildId, GuildMoneyMap, []),
			{Gold, Bgold} = count_award_gold(MoneyList, 0, 0),	
			%% 钻石分红只取整数部分，小数部分流入绑钻四舍五入
			NewGold = round(Gold div Num),
			NewBgold  = round((Bgold / Num) + ((Gold / Num) - NewGold)),
			maps:put(GuildId, {NewGold, NewBgold}, GuildBonusMap);
		(_GuildId, _Num, GuildBonusMap) -> GuildBonusMap
		end, #{}, GuildJoinNumMap).

count_award_gold([], Gold, Bgold) -> {Gold, Bgold};
count_award_gold([{ObjectType, _GoodsId, Num}|T], Gold, Bgold) ->
	case ObjectType of
		?TYPE_GOLD  -> count_award_gold(T, Num, Bgold);
		?TYPE_BGOLD -> count_award_gold(T, Gold, Num);
		_ -> count_award_gold(T, Gold, Bgold)
	end.

%% 计算竞拍物品最新价格，竞价详细列表
cacl_pay_auction_price(AuctionGoods, PriceType, Price, PriceList) ->
	case PriceType == ?PRICE_TYPE_ADD_PRICE of
		true -> 	
			NowPrice      = AuctionGoods#auction_goods.now_price,
			InfoList      = AuctionGoods#auction_goods.info_list,
			AuctionInfo   = lists:keyfind(NowPrice, #auction_info.price, InfoList),
			OldPriceList  = AuctionInfo#auction_info.price_list,
			{Gold, Bgold} = lib_auction_util:count_award_gold(OldPriceList, 0, 0),
			NewPrice      = Price + Bgold + Gold,
			NewPriceList  = ulists:object_list_plus([PriceList, OldPriceList]);
		false ->
			NewPrice 	  = Price, NewPriceList = PriceList
	end,
	{NewPrice, NewPriceList}.

%%% 更新竞拍物品竞价，竞价详细列表
update_pay_auction_price(AuctionGoods, {PlayerId, ServerId, PriceType, NewPrice, NewPriceList, NowTime}) ->
	#auction_goods{
		goods_type = GoodsType, auction_id = _AuctionId, wlv = Wlv, info_list = InfoList
	} = AuctionGoods,
	MaxPrice 	= NewPrice>=lib_auction_data:get_one_price(GoodsType, Wlv),
	GoodsStatus = ?IF(MaxPrice, ?GOODS_STATUS_SELLOUT, ?GOODS_STATUS_SELL),
	Info 		= lib_auction_data:make(auction_info, [PlayerId, ServerId, PriceType, NewPrice, NewPriceList, NowTime]),
	NewAuctionGoods = AuctionGoods#auction_goods{
		goods_status 	= GoodsStatus,
		next_price      = lib_auction_data:get_next_price(GoodsType, Wlv, NewPrice),
		now_price  		= NewPrice,
		info_list  		= [Info|InfoList]
	},
	NewAuctionGoods.

%% 重新计算预计分红总额
recount_auction_estimate_bonus(AuctionId, AuctionMap, OldAuctionGoods, NewPriceList) ->
	GuildId 	  = OldAuctionGoods#auction_goods.guild_id,
	OldPrice 	  = OldAuctionGoods#auction_goods.now_price,
	InfoList      = OldAuctionGoods#auction_goods.info_list,
	GoodsType     = OldAuctionGoods#auction_goods.goods_type,
	Wlv           = OldAuctionGoods#auction_goods.wlv,
	ModuleId      = OldAuctionGoods#auction_goods.module_id,
	Auction  	  = maps:get(AuctionId, AuctionMap),
	EstimateBonusMap = Auction#auction.estimate_bonus_map,
	EstimateBonus    = maps:get(GuildId, EstimateBonusMap, []),
	{TotalGold, TotalBgold} = lib_auction_util:count_award_gold(EstimateBonus, 0, 0),	

	case OldAuctionGoods#auction_goods.info_list of
		[] -> 
			OldPriceList = lib_auction_data:get_unsold_bonus_list(ModuleId, GoodsType, Wlv);
		_ -> 
			case lists:keyfind(OldPrice, #auction_info.price, InfoList) of 
				#auction_info{price_list = OldPriceList} -> ok;
				_ -> OldPriceList = lib_auction_data:get_unsold_bonus_list(ModuleId, GoodsType, Wlv)
			end
	end,
	{OldGold, OldBgold} = lib_auction_util:count_award_gold(OldPriceList, 0, 0),	
	{AddGold, AddBgold} = lib_auction_util:count_award_gold(NewPriceList, 0, 0),	
	{NewTotalGold, NewTotalBgold} = {max(TotalGold - OldGold + AddGold, 0), max(TotalBgold - OldBgold + AddBgold, 0)},
	NewEstimateBonus = [{?TYPE_GOLD, 0, NewTotalGold}, {?TYPE_BGOLD, 0, NewTotalBgold}],
	NewEstimateBonusMap = maps:put(GuildId, NewEstimateBonus, EstimateBonusMap),
	NewAuction 	        = Auction#auction{estimate_bonus_map = NewEstimateBonusMap},
	maps:put(AuctionId, NewAuction, AuctionMap).

%% pp相关
notify_goods_info_to_all(AuctionMap, AuctionGoods) ->
	#auction_goods{auction_id = AuctionId, auction_type = AuctionType} = AuctionGoods,
	Auction = maps:get(AuctionId, AuctionMap),
	{ok, Bin} = pack_notify_goods(AuctionGoods),
	if
	 	AuctionType == ?AUCTION_KF_REALM andalso Auction#auction.zone_id > 0 ->
	 		mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, Auction#auction.zone_id, lib_server_send, send_to_all, [Bin]);
	 	AuctionType == ?AUCTION_KF_REALM andalso Auction#auction.zone_id == 0 -> 
	 		mod_clusters_center:apply_to_all_node(lib_server_send, send_to_all, [Bin]);
		true ->
			lib_server_send:send_to_all(Bin)
	end.

notify_goods_info_to_payer(PlayerId, AuctionGoods) ->
	#auction_goods{
		goods_id 	= GoodsId,
		auction_type = AuctionType,
		goods_status= GoodsStatus,
		module_id  = ModuleId,
		now_price 	= NowPrice,
		next_price 	= NextPrice,
		info_list	= InfoList,
		delay_num	= DelayNum} = AuctionGoods,
	EndTime = lib_auction_data:get_goods_endtime(AuctionGoods),
	TopPlayerId = PlayerId,
	IsDelay = is_delay(DelayNum),
	IdList  = lists:foldl(
		fun(#auction_info{player_id = Pid, server_id = ServerId}, IdList) -> 
			?IF(lists:keymember(Pid, 1, IdList)==true, IdList, [{Pid, ServerId}|IdList])
		end, [], InfoList),
	[notify_goods_info(Pid, ServerId, [GoodsId, ModuleId, AuctionType, NowPrice, NextPrice, EndTime, TopPlayerId, IsDelay, GoodsStatus])||{Pid, ServerId}<-IdList].

notify_goods_info(PlayerId, ServerId, AuctionGoods) ->
	{ok, Bin} = pack_notify_goods(AuctionGoods),
	case AuctionGoods of 
		#auction_goods{auction_type = AuctionType} -> ok;
		[_GoodsId, _ModuleId, AuctionType|_] -> ok
	end,
	case AuctionType == ?AUCTION_KF_REALM of 
		true -> %% 跨服拍卖
			mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [PlayerId, Bin]);
		_ ->
			lib_server_send:send_to_uid(PlayerId, Bin)
	end.

pack_notify_goods(AuctionGoods) when is_record(AuctionGoods, auction_goods)->
	#auction_goods{
		goods_id 	= GoodsId,
		auction_type = AuctionType,
		goods_status= GoodsStatus,
		module_id 	= ModuleId,
		now_price 	= NowPrice,
		next_price 	= NextPrice,
		info_list	= InfoList,
		delay_num	= DelayNum} = AuctionGoods,
	EndTime 	= lib_auction_data:get_goods_endtime(AuctionGoods),
	{TopPlayerId, _} = lib_auction_data:get_top_player(NowPrice, InfoList),
	IsDelay     = is_delay(DelayNum),
	Args = [GoodsId, ModuleId, AuctionType, NowPrice, NextPrice, EndTime, TopPlayerId, IsDelay, GoodsStatus],
	pack_notify_goods(Args);
pack_notify_goods(AuctionGoods) when is_list(AuctionGoods) ->
	pt_154:write(15402, AuctionGoods).

get_auction_catalog(ModuleList, WorldList, GoodsMap, NowTime) ->
	PackModuleList = lists:foldl(
		%% 物品数量不具体计算，客户端用不上，便于扩展，暂设为1
		fun({ModuleId, GoodsList}, AccList) when GoodsList=/=[] -> 
			case get_catalog_goods(GoodsList, GoodsMap, [], NowTime) of
				[] -> AccList;
				_ -> [{ModuleId, 1}|AccList]
			end;			
		({_ModuleId, _GoodsList}, AccList) -> AccList
		end, [], ModuleList),

	PackWorldList = lists:foldl(
		fun({Type, GoodsList}, AccList) when GoodsList=/=[] -> 		
			case get_catalog_goods(GoodsList, GoodsMap, [], NowTime) of
				[] -> AccList;
				_ -> [{Type, 1}|AccList]
			end;
		({_Type, _GoodsList}, AccList) -> AccList
		end, [], WorldList),
	{PackModuleList, PackWorldList}.

get_catalog_goods([], _GoodsMap, GoodsList, _NowTime) -> GoodsList;
get_catalog_goods([GoodsId|T], GoodsMap, GoodsList, NowTime) ->
	case maps:get(GoodsId, GoodsMap, false) of
		#auction_goods{
			auction_type 	= AuctionType,
			start_time 		= StartTime,	
			goods_status 	= GoodsStatus
		} = AuctionGoods when GoodsStatus ==?GOODS_STATUS_SELL ->
			EndTime  = lib_auction_data:get_goods_endtime(AuctionGoods),
			%% 公会拍卖物品列表筛选条件：物品待拍出，未到结束时间
			%% 世界拍卖物品列表筛选条件：物品待拍出，到了开始时间且未到结束时间
			case (AuctionType == ?AUCTION_GUILD andalso NowTime < EndTime) orelse
				 (AuctionType == ?AUCTION_KF_REALM andalso NowTime < EndTime) orelse
				 (AuctionType == ?AUCTION_WORLD andalso NowTime < EndTime andalso NowTime>StartTime)
			of
				true -> get_catalog_goods(T, GoodsMap, [GoodsId|GoodsList], NowTime);
				false -> get_catalog_goods(T, GoodsMap, GoodsList, NowTime)
			end;
		_ -> get_catalog_goods(T, GoodsMap, GoodsList, NowTime)
	end.

get_auction_goods_list(AuctionMap, GoodsMap, GuildMap, WorldMap, PlayerId, GuildId, AuctionType, Type, ModuleId, ZoneId) ->
	NowTime = utime:unixtime(),
	GoodsIdList= if
		%% ModuleId为0表示获取该公会拍卖全部拍卖物
		(AuctionType == ?AUCTION_GUILD orelse AuctionType == ?AUCTION_KF_REALM) andalso ModuleId == 0 ->
			ModuleList = maps:get(GuildId, GuildMap, []),
			lists:foldl(
				fun({_ModuleId, L}, AccList) -> L ++ AccList
				end, [], ModuleList);
		(AuctionType == ?AUCTION_GUILD orelse AuctionType == ?AUCTION_KF_REALM) -> 
			ModuleList = maps:get(GuildId, GuildMap, []),
			case lists:keyfind(ModuleId, 1, ModuleList) of
				false -> [];
				{ModuleId, L} -> L
			end;
		%% Type为0表示获取世界拍卖全部拍卖物
		AuctionType == ?AUCTION_WORLD andalso Type == 0 ->
			maps:fold(
				fun(_Type, List, AccList) -> List ++ AccList
				end, [], WorldMap);
		AuctionType == ?AUCTION_WORLD ->
			maps:get(Type, WorldMap, [])
	end, 

	{GoodsList, _, _} =	lists:foldl(
		fun(GoodsId, {Acc, BonusStatus, BlStatus}) -> 
			case maps:get(GoodsId, GoodsMap, false) of
				false -> {Acc, BonusStatus, BlStatus};
				Goods -> 
					pack_goods(NowTime, PlayerId, GuildId, ZoneId, Goods, AuctionMap, Acc, BonusStatus, BlStatus)
			end 
		end, {[], #{}, #{}}, GoodsIdList),
	GoodsList.

pack_goods(NowTime, PlayerId, GuildId, ZoneId, #auction_goods{
		goods_status = GoodsStatus} = AuctionGoods, AuctionMap, Acc, BonusStatus, BlStatus) when GoodsStatus ==?GOODS_STATUS_SELL ->
	#auction_goods{
		goods_id 		= GoodsId,
		auction_id      = AuctionId,
		goods_type 		= GoodsType, 
		auction_type 	= AuctionType,
		module_id       = ModuleId,
		start_time 		= StartTime,	
		wlv 			= Wlv,	
		next_price 		= NextPrice,
		now_price 		= NowPrice,
		info_list     	= InfoList,
		delay_num		= DelayNum
	} = AuctionGoods,
	EndTime  = lib_auction_data:get_goods_endtime(AuctionGoods),

	%% 公会拍卖物品列表筛选条件：物品待拍出，未到结束时间
	%% 世界拍卖物品列表筛选条件：物品待拍出
	case NowTime < EndTime of
		true ->
			Price    = lib_auction_data:get_one_price(GoodsType, Wlv),
			{TopPlayerId, _} = lib_auction_data:get_top_player(NowPrice, InfoList),
			IsDelay  = lib_auction_util:is_delay(DelayNum),
			%% 判断物品是不是该区域归属
			case maps:get(AuctionId, BlStatus, []) of 
				[] ->
					#auction{
						zone_id 	= AuctionZone
					} = maps:get(AuctionId, AuctionMap),
					%% 拍卖的zone=0或者拍卖zone==玩家zone，玩家可以看见该拍品
					case AuctionZone == 0 orelse (AuctionZone == ZoneId) of 
						true -> IsZoneBl = 1; _ -> IsZoneBl = 0
					end,
					NewBlStatus = maps:put(AuctionId, IsZoneBl, BlStatus);
				IsZoneBl ->
					NewBlStatus = BlStatus
			end,
			case IsZoneBl of 
				1 ->
					%% 判断该物品有无分红
					case maps:get(AuctionId, BonusStatus, []) of 
						[] ->
							#auction{
								guild_award_map 	= GuildAwardMap,
								join_log_map 		= JoinLogMap
							} = maps:get(AuctionId, AuctionMap),
							NewGuildId = ?IF(AuctionType == ?AUCTION_WORLD, 0, GuildId),
							IsJoin 		  =	maps:get(PlayerId, JoinLogMap, []),					
							AwardStatus   = maps:get(NewGuildId, GuildAwardMap, 0),
							case IsJoin=/=[] andalso AwardStatus==0 of
								true -> HadBonus = 1;
								false -> HadBonus = 0
							end,
							NewBonusStatus = maps:put(AuctionId, HadBonus, BonusStatus);
						HadBonus -> 
							NewBonusStatus = BonusStatus
					end,
					NewAcc = [{GoodsId, ModuleId, GoodsType, Wlv, NowPrice, NextPrice, Price, StartTime, EndTime, TopPlayerId, IsDelay, HadBonus}|Acc];
				_ ->
					NewAcc = Acc,
					NewBonusStatus = BonusStatus
			end,
			{NewAcc, NewBonusStatus, NewBlStatus};
		false -> {Acc, BonusStatus, BlStatus}
	end;
pack_goods(_NowTime, _PlayerId, _GuildId, _ZoneId, _AuctionGoods, _AuctionMap, Acc, BonusStatus, BlStatus) -> {Acc, BonusStatus, BlStatus}.

is_delay(DelayNum) when DelayNum>0 -> 1;
is_delay(_DelayNum)  -> 0.

%% 本场次拍卖是否全部已拍出或结束，是的话提前结束
is_all_sellout(GoodsMap, AuctionId) ->
	GoodsList = [AuctionGoods||#auction_goods{auction_id = Id} = AuctionGoods
		<-maps:values(GoodsMap), Id==AuctionId],
	SellOutList = [AuctionGoods||#auction_goods{goods_status = GoodsStatus} = AuctionGoods
		<- GoodsList, GoodsStatus==?GOODS_STATUS_SELLOUT],	
	length(SellOutList) == length(GoodsList).

%% ---------------------------- check function %% ----------------------------
check({pay_auction, PlayerId, ServerId, AuctionGoods, PriceType, Price, PriceList}) ->
	BaseGoods = lib_auction_data:get_goods_config(AuctionGoods),
	F = fun({Type, _GoodsId, _Num}) -> Type == ?TYPE_GOLD end,
	IsAllGold = lists:all(F, PriceList),
	if
		AuctionGoods==false ->
			%% 改物品拍卖已关闭
			{false, ?ERRCODE(err154_goods_closed)};
		BaseGoods == [] -> 
			%% 缺失物品配置
			{false, ?ERRCODE(err154_missing_config)};
		BaseGoods#base_auction_goods.gold_type == ?TYPE_GOLD andalso 
			IsAllGold =/= true ->
			%% 本商品只能使用钻石参与拍卖
			{false, ?ERRCODE(err154_only_pay_by_gold)};
		AuctionGoods#auction_goods.goods_status == ?GOODS_STATUS_SELLOUT ->
			%% 物品已拍出
			{false, ?ERRCODE(err154_goods_sellout)};
		Price == 0 ->			
			%% 价格参数错误
			{false, ?ERRCODE(err154_error_price)};		
		true -> 
			check({pay_auction_extra, PlayerId, ServerId, AuctionGoods, PriceType, Price})
	end;

check({pay_auction_extra, PlayerId, ServerId, AuctionGoods, PriceType, Price}) ->
	NowTime   = utime:unixtime(),
	#auction_goods{		
		goods_type  	= GoodsType,
		now_price 		= NowPrice,		
		next_price 		= NextPrice,
		start_time 		= StartTime,
		wlv 			= Wlv,
		info_list 		= InfoList
		} = AuctionGoods,
	EndTime  = lib_auction_data:get_goods_endtime(AuctionGoods),
	BasePrice = lib_auction_data:get_base_price(GoodsType, Wlv),
	AddPrice = lib_auction_data:get_add_price(GoodsType, Wlv),
	OnePrice = lib_auction_data:get_one_price(GoodsType, Wlv),

	case lists:keyfind(NowPrice, #auction_info.price, InfoList) of
		#auction_info{} = AuctionInfo ->
			TopPlayerId   = AuctionInfo#auction_info.player_id,
			PriceList 	  = AuctionInfo#auction_info.price_list,
			{Bgold, Gold} = lib_auction_util:count_award_gold(PriceList, 0, 0),
			OldPrice = Bgold + Gold;
		_ -> TopPlayerId = 0, OldPrice = 0
	end,

	if	
		PriceType == ?PRICE_TYPE_AUCTION andalso
		( (Price - NextPrice) < 0 orelse    %% 价格比下次竞拍最低价要低--有问题
		  (Price < OnePrice andalso (Price - BasePrice) rem AddPrice =/= 0) orelse  %% 在价格低于一口价情况下：普通竞价的价格一定是加价的整数倍
		  (Price > OnePrice)  %% 价格超过一口价--有问题
		) -> 
			notify_goods_info(PlayerId, ServerId, AuctionGoods),
			%% 竞价已发生变化
			{false, ?ERRCODE(err154_price_change)};	

		PriceType == ?PRICE_TYPE_ONE_PRICE andalso 
		Price =/= OnePrice  ->
			%% 价格参数错误
			{false, ?ERRCODE(err154_error_price)};

		%% 加价：竞价已发生变化，您不是当前最高出价者
		PriceType == ?PRICE_TYPE_ADD_PRICE andalso 
		PlayerId =/= TopPlayerId ->
			notify_goods_info(PlayerId, ServerId, AuctionGoods),
			{false, ?ERRCODE(err154_price_change)};

		%% 加价： 竞价已发生变化，加价数额不对
		PriceType == ?PRICE_TYPE_ADD_PRICE andalso 	
		( (OldPrice + Price - NextPrice) < 0 orelse       %% 加价后比下次竞拍价要低--有问题
		  (OldPrice + Price < OnePrice andalso (OldPrice + Price - BasePrice) rem AddPrice =/= 0) orelse %% 低于一口价情况下：竞价的价格一定是加价的整数倍
		  (OldPrice + Price > OnePrice)  %% 价格超过一口价--有问题
		) ->
			notify_goods_info(PlayerId, ServerId, AuctionGoods),
			{false, ?ERRCODE(err154_price_change)};	

		NowTime > EndTime ->
			%% 改物品拍卖已关闭
			{false, ?ERRCODE(err154_goods_closed)};
		NowTime < StartTime ->
			%% 拍卖未开启，请稍加等待
			{false, ?ERRCODE(err154_auction_not_start)};
		true -> true
	end;

check({check_pay_right, _PlayerId, ServerId, GuildId, AuctionGoods, _PriceType, AuctionMap}) ->	
	CheckList  = [
		% @common 策划新需求：自己是最高竞价也是可以继续加价的
		% {check_top_price, PlayerId, AuctionGoods, PriceType},
		{check_guild, GuildId, ServerId, AuctionGoods, AuctionMap}
	],
	checklist(CheckList);

check({check_top_price, PlayerId, AuctionGoods, ?PRICE_TYPE_AUCTION}) ->
	#auction_goods{
		now_price = NowPrice,
		info_list = InfoList
	} = AuctionGoods,
	case lists:keyfind(NowPrice, #auction_info.price , InfoList) of
		#auction_info{player_id = PlayerId} ->
			%% 你当前已是最高竞价者
			{false, ?ERRCODE(err154_player_top_price)};
		_ -> true
	end;
check({check_top_price, _PlayerId, _AuctionGoods, ?PRICE_TYPE_ONE_PRICE}) ->
	true;

check({check_guild, GuildId, ServerId, AuctionGoods, AuctionMap}) ->
	#auction_goods{
		auction_id = AuctionId,
		guild_id = Gid
	} = AuctionGoods,
	Auction = maps:get(AuctionId, AuctionMap, false),
	if
		(Gid=/=0 andalso Gid=/=GuildId) orelse (Auction == false) -> 
			%% 不是你所在公会物品
			{false, ?ERRCODE(err154_error_guild_id)};
		true -> 
			#auction{zone_id = AuctionZoneId} = Auction,
			case AuctionZoneId == 0 orelse (AuctionZoneId == lib_clusters_center_api:get_zone(ServerId)) of 
				true -> true;
				_ -> 
					{false, ?ERRCODE(err154_error_guild_id)}
			end
	end;

check(_) ->
    {false, ?FAIL}.

checklist([]) -> true;
checklist([H|T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.