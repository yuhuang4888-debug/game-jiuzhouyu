%% ---------------------------------------------------------------------------
%% @doc 拍卖行(跨服)
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------

-module (lib_kf_auction_mod).
-include ("common.hrl").
-include ("rec_auction.hrl").
-include ("server.hrl").
-include ("def_fun.hrl").
-include ("def_module.hrl").
-include ("def_id_create.hrl").
-include ("def_timer_quest.hrl").
-include ("errcode.hrl").
-include ("predefine.hrl").
-include ("language.hrl").
-include ("def_event.hrl").
-include ("auction_module.hrl").
-include ("counter_global.hrl").
-include ("clusters.hrl").
-compile(export_all).
-export ([
		init/0,
		timer_check/1,		
		start_auction_notice/2,
		start_auction/2, 
		add_auction_goods_db_helper/2
]).
-export ([
		close_auction/2, 
		close_all_auction_gm/1
]).
-export ([
		pay_auction/2]).

-export ([
		send_auction_catalog/2,
		send_auction_goods/2, 
		send_auction_estimate_bonus/2
]).

%% ----------------------------- init function  %% ----------------------------
init() ->
	lib_auction_data:init_kf().

%% ------------------------------ timer_check  %% -----------------------------

%% 每分钟轮询一次检测拍卖活动开始以及拍卖结束
timer_check(State) ->
	{ok, NewState}  = check_end(State),
	%{ok, LastState} = check_start(NewState),
	{ok, NewState}.

check_end(State) -> 
	NowTime   = utime:unixtime(),
	#kf_auction_state{
		auction_map 	= AuctionMap
	} = State,
	AuctionList = maps:to_list(AuctionMap),
	AuctionId = get_end_auction_id(AuctionList, NowTime),
	case AuctionId > 0 of
		true ->
			{ok, NewState} = close_auction(State, {AuctionId, 0, ?CLOSE_AUCTION_NORMAL}),
			{ok, NewState};
		false -> {ok, State}
	end.

% check_start(State) -> 
% 	NowTime   = utime:unixtime(),
% 	CfgIdList = data_auction:get_time_ids(),
% 	BeforeSec = ?WORLD_NOTICE1_BEFORE,
% 	CfgId = get_start_cfg_id(CfgIdList, NowTime, BeforeSec),
% 	case CfgId > 0 of
% 		true -> start_system_auction(State, CfgId);
% 		false -> {ok, State}
% 	end.

get_end_auction_id([], _NowTime) -> 0;
get_end_auction_id([{AuctionId, Auction}|T], NowTime) ->
	EndTime = lib_auction_data:get_auction_endtime(Auction),
	case NowTime >=EndTime of
		true -> AuctionId;
		false -> get_end_auction_id(T, NowTime)
	end.

% get_start_cfg_id([], _NowTime, _BeforeSec) -> 0;
% get_start_cfg_id([Id|T], NowTime, BeforeSec) ->
% 	case data_auction:get_time(Id) of
% 		#base_auction_time{time = Time} ->
% 			%% 	预告时间：正式开始时间减去提前时长
% 			FormatTime = format_time(Time),
% 			NoticeTime = FormatTime - BeforeSec,
% 			DiffTime   = NowTime - NoticeTime,
% 			%% check_start每分钟轮询一次的，加上大于0小于60, 只取一次值
% 			case DiffTime >=0 andalso DiffTime<60 of
% 				true -> Id;
% 				false -> get_start_cfg_id(T, NowTime, BeforeSec)
% 			end;
% 		_ -> get_start_cfg_id(T, NowTime, BeforeSec)
% 	end.

%% 转成当天时间戳
format_time({H,M,_S}) ->
	utime:unixdate() + H*3600+ M*60;
format_time(_Time) ->
	utime:unixdate().

get_auction_id(_State) ->
	mod_id_create_cls:get_new_id(?AUCTION_ID_CREATE_CLS).
	% #kf_auction_state{kf_server_id = KfServerId} = State,
	% Id = mod_global_counter:get_count(?MOD_AUCTION, ?GLOBAL_154_KF_AUCTION_ID),
	% <<AutoId:48>> = <<KfServerId:16, Id:32>>,
	% mod_global_counter:increment(?MOD_AUCTION, ?GLOBAL_154_KF_AUCTION_ID),
	% AutoId.

get_auction_goods_id(_AuctionId) ->
	mod_id_create_cls:get_new_id(?AUCTION_GOODS_ID_CREATE_CLS).
	% <<KfServerId:16, _Id:32>> = <<AuctionId:48>>,
	% GoodsId = mod_global_counter:get_count(?MOD_AUCTION, ?GLOBAL_154_KF_GOODS_ID),
	% mod_global_counter:increment(?MOD_AUCTION, ?GLOBAL_154_KF_GOODS_ID),
	% NewGoodsId = GoodsId + 1,
	% <<AutoId:48>> = <<KfServerId:16, NewGoodsId:32>>,
	% AutoId.

%% 拍卖预告
start_auction_notice(State, {AuctionType, AuctionId, ?AUCTION_STATUS_NOTICE1, ModuleId, GuildGoodsList}) ->
	#kf_auction_state{auction_map = AuctionMap} = State,
	#auction{time = StartTime} = Auction = maps:get(AuctionId, AuctionMap),
	Duration = max(1, StartTime - utime:unixtime()),
	% ?PRINT("start_auction_notice#1 Duration : ~p~n", [Duration]),
	spawn(fun() -> send_auction_tv(Auction, AuctionType, ?AUCTION_STATUS_NOTICE1, Duration, ModuleId, GuildGoodsList) end),
	AuctionStatus = ?AUCTION_STATUS_NOTICE2,
	NewState	  = update_auction(State, {AuctionId, AuctionStatus}),
	timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, {
		mod_kf_auction, start_auction_notice, [{AuctionType, AuctionId, AuctionStatus, ModuleId, GuildGoodsList}] }),
	{ok, NewState};

start_auction_notice(State, {AuctionType, AuctionId, ?AUCTION_STATUS_NOTICE2, ModuleId, GuildGoodsList}) ->
	%% 再次初始化活动参与记录，预防活动功能延迟调用参与记录接口的情况
	AuctionMap 	  = State#kf_auction_state.auction_map,
	Duration = ?GUILD_AUCTION_DURATION(ModuleId),
	Auction 	  = maps:get(AuctionId, AuctionMap),
	NeedAuctionTv = need_send_world_tv(ModuleId, ?AUCTION_STATUS_NOTICE2),
	NeedAuctionTv andalso spawn(fun() -> send_auction_tv(Auction, AuctionType, ?AUCTION_STATUS_NOTICE2, Duration, ModuleId, GuildGoodsList) end),
	AuctionStatus = ?AUCTION_STATUS_BEGIN,
	NewState	  = update_auction(State, {AuctionId, AuctionStatus}),
	 ?PRINT("start_auction_notice#2 Duration : ~p~n", [Duration]),
	timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, {
		mod_kf_auction, close_auction, [{AuctionId, 0, ?CLOSE_AUCTION_NORMAL}] }),
	{ok, NewState};

start_auction_notice(State, {AuctionType, AuctionId, AuctionStatus, _ModuleId, _GuildGoodsList}) ->
	?ERR("unkown auction_status: ~p, ~p, ~p", [AuctionType, AuctionId, AuctionStatus]),
	{ok, State}.

update_auction(State, {AuctionId, AuctionStatus}) ->
	NowTime		  = utime:unixtime(),
	AuctionMap 	  = State#kf_auction_state.auction_map,
	Auction 	  = maps:get(AuctionId, AuctionMap, #auction{}),
	NewAuction 	  = Auction#auction{auction_status = AuctionStatus, last_time = NowTime},
	NewAuctionMap = maps:put(AuctionId, NewAuction, AuctionMap),
	lib_auction_data:update_auction_db([AuctionStatus, NowTime, AuctionId]),
	State#kf_auction_state{auction_map = NewAuctionMap}.


send_auction_tv(Auction, ?AUCTION_KF_REALM = AuctionType, AuctionStatus, Duration, ModuleId, GuildGoodsList) ->
	#auction{zone_id = ZoneId, join_log_map = JoinLogMap} = Auction,
	_GuildList = [GuildId || #join_log{guild_id = GuildId} <- maps:values(JoinLogMap)],
	GuildList = ulists:removal_duplicate(_GuildList),
	Minute 	   = Duration div 60,
	case AuctionStatus of
		?AUCTION_STATUS_NOTICE1 ->
			{ok, Bin} = pt_154:write(15408, [?AUCTION_KF_REALM, ModuleId, 1]),
			send_bin_to_zone(ZoneId, GuildList, AuctionType, Bin),
			F = fun({GuildId, GoodsList}) -> 	
				GoodsTypeList = lib_auction_mod:trans_to_tv_goods(GoodsList),	
				case length(GoodsTypeList) > 0 of 
					true ->		
						GoodsStr = util:pack_tv_goods(GoodsTypeList),
						?PRINT("send_auction_tv GoodsStr ~p~n", [GoodsStr]),
						BinData = lib_chat:make_tv(?MOD_AUCTION, 7, [Minute, GoodsStr]),	
						send_bin_to_zone(ZoneId, [GuildId], AuctionType, BinData);
					_ ->
						ok
				end
			end,
			lists:foreach(F, GuildGoodsList);
		?AUCTION_STATUS_NOTICE2 ->
			{ok, Bin} = pt_154:write(15408, [?AUCTION_KF_REALM, ModuleId, 2]),
			send_bin_to_zone(ZoneId, GuildList, AuctionType, Bin),
			BinData = lib_chat:make_tv(?MOD_AUCTION, 8, []),	
			send_bin_to_zone(ZoneId, GuildList, AuctionType, BinData);
		_ -> skip
	end;
send_auction_tv(_Auction, _AuctionType, _AuctionStatus, _Duration, _ModuleId, _GoodsListArgs) -> skip.

send_bin_to_zone(0, GuildList, AuctionType, Bin) ->
	mod_clusters_center:apply_to_all_node(?MODULE, send_bin_to_zone_local, [AuctionType, GuildList, Bin]);
send_bin_to_zone(ZoneId, GuildList, AuctionType, Bin) ->
	mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, ?MODULE, send_bin_to_zone_local, [AuctionType, GuildList, Bin]).

send_bin_to_zone_local(AuctionType, GuildIdList, Bin) ->
	%% 目前跨服拍卖是以阵营来的，即GuildId指的是阵营id
	AuctionType == ?AUCTION_KF_REALM andalso [lib_server_send:send_to_camp(GuildId, Bin) ||GuildId <- GuildIdList].

%% 开启跨服拍卖
start_auction(State, {AuctionType, ZoneId, ModuleId, StartTime, CfgId, GuildGoodsList, BonusPlayerList}) ->
	{NewGuildGoodsList2, EmptyGuildList} = check_auction_list(GuildGoodsList),
	send_empty_auction_tv(ZoneId, AuctionType, ModuleId, EmptyGuildList),
	do_start_auction(State, {AuctionType, ZoneId, ModuleId, StartTime, CfgId, NewGuildGoodsList2, BonusPlayerList}).

%% 没有获得拍卖物消息
send_empty_auction_tv(ZoneId, AuctionType, ModuleId, EmptyGuildList) ->
	ModuleName = data_auction:get_module_name(ModuleId),
	F = fun(GuildId) ->		
		BinData = lib_chat:make_tv(?MOD_AUCTION, 9, [ModuleName]),	
		send_bin_to_zone(ZoneId, [GuildId], AuctionType, BinData)
	end,
	lists:foreach(F, EmptyGuildList).

do_start_auction(State, {AuctionType, ZoneId, ModuleId, StartTimeIn, _CfgId, GuildGoodsList, BonusPlayerList}) when GuildGoodsList=/=[] ->
	?PRINT("start_auction ~p....~n", [{AuctionType, ZoneId}]),
	NowTime   			= utime:unixtime(),
	#kf_auction_state{
		auction_map 	= AuctionMap,
		goods_map 		= GoodsMap,
		guild_map 		= GuildMap,
		world_map  		= WorldMap
	} = State,

	%% 添加一场拍卖记录
	AuctionStatus= ?AUCTION_STATUS_NOTICE1,
	StartTime 	= lib_auction_data:get_guild_start_time(ModuleId, NowTime, StartTimeIn),
	LastTime    = NowTime,
	AuctionId   = get_auction_id(State),
	AuctionArgs = [AuctionId, AuctionType, 1, ZoneId, ModuleId, 0, AuctionStatus, StartTime, LastTime],
	Auction     = lib_auction_data:make(auction, AuctionArgs),
	NewAuctionMap = maps:put(AuctionId, Auction, AuctionMap),
	lib_auction_data:add_auction_db(AuctionArgs),

	%% 给拍卖场次添加拍卖物品
	Args = [AuctionId, AuctionType, ModuleId, StartTime],
	{NewGoodsMap, _Args, AddGoodsList} = lists:foldl(
			fun add_auction_goods/2, {GoodsMap, Args, []}, GuildGoodsList),
	spawn(fun() -> util:multiserver_delay(0, lib_auction_mod, add_auction_goods_db_helper, [AddGoodsList, 1]) end),
	lib_log_api:log_auction_produce(ModuleId, AuctionType, GuildGoodsList),

	%% 初始化活动参与记录，计算预计分红总额
	NewAuctionMap2= lib_auction_data:init_auction_estimate_bonus(AddGoodsList, NewAuctionMap),
	NewAuction    = maps:get(AuctionId, NewAuctionMap2),
	%% 玩家参与记录
	lib_auction_data:add_auction_join_log_db(AuctionId, BonusPlayerList),
	NewJoinLogMap = lib_auction_data:init_kf_auction_join_log(BonusPlayerList),
	LastAuctionMap= lib_auction_data:init_auction_join_num(NewAuction, NewAuctionMap2, NewJoinLogMap),
	print_goods_map(start_auction, NewGoodsMap),
	%% 重置拍卖目录
	{NewGuildMap, NewWorldMap} = lib_auction_data:reinit_goods_catalog(reinit_all, {NewGoodsMap, GuildMap, WorldMap}),
	%% 添加一个动态定时器，Duration赋值为1无特别含义
	Duration = 1,
	timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, {
		mod_kf_auction, start_auction_notice, [{AuctionType, AuctionId, AuctionStatus, ModuleId, GuildGoodsList}] }),

	 ?PRINT("start_auction NewGuildMap ~p~n", [maps:to_list(NewGuildMap)]),
	NewState = State#kf_auction_state{
		auction_map = LastAuctionMap,
		goods_map 	= NewGoodsMap,
		guild_map 	= NewGuildMap,
		world_map 	= NewWorldMap
	},
	{ok, NewState};
do_start_auction(State, Args) ->
	?INFO("start_auction info:~p", [Args]),
	{ok, State}.

%% return {AccList, EmptyGuildList}
%% AccList :: [{GuildId, GoodsList}]  公会产出拍卖物品
%% EmptyGuildList :: [GuildId]   	  无拍卖物产出的公会列表
check_auction_list(GuildGoodsList) ->
	F1 = fun
	({GoodsType, _Num, Wlv} = Object, {GuildId, AccList}) -> 
		case data_auction:get_goods(GoodsType, Wlv) of
			#base_auction_goods{} -> {GuildId, [Object|AccList] };
			_ ->
				?ERR("unkown goods_type id:~p", [{GoodsType, Wlv}]),
				{GuildId, AccList}
		end;
	(Object, {GuildId, AccList}) ->
		?ERR("unkown ObjectType:~p", [{GuildId, Object}]), 
		{GuildId, AccList}
	end, 
	F2 = fun({GuildId, GoodsList}, {AccList, EmptyGuildList}) ->
		{GuildId, NewGoodsList} = lists:foldl(F1, {GuildId, []}, GoodsList),
		AccList2 = [{GuildId, NewGoodsList} | AccList],
		AccList3 = ?IF(NewGoodsList=/=[], AccList2, AccList),
		EmptyGuildList3 = ?IF(NewGoodsList==[], [GuildId|EmptyGuildList], EmptyGuildList),
		{AccList3, EmptyGuildList3}
	end,
	lists:foldl(F2, {[], []}, GuildGoodsList).

add_auction_goods({GuildId, GoodsList}, {GoodsMap, Args, AddGoodsList}) ->
	AllGoodsNum = lists:sum([Num ||{GoodsType, Num, Wlv} <- GoodsList]),
	GoodsIdList = mod_id_create_cls:get_new_id(?AUCTION_GOODS_ID_CREATE_CLS, AllGoodsNum),
	F = fun({GoodsType, Num, Wlv}, {Map, IdList, AddList}) -> 
		add_auction_goods_helper({GuildId, GoodsType, Num, Wlv}, {Map, IdList, Args, AddList})
	end, 
	{NewGoodsMap, _, NewAddList} = lists:foldl(F, {GoodsMap, GoodsIdList, AddGoodsList}, GoodsList),
	{NewGoodsMap, Args, NewAddList}.

add_auction_goods_helper({_GuildId, _GoodsType, 0, _}, {GoodsMap, IdList, _Args, AddList}) -> {GoodsMap, IdList, AddList};
add_auction_goods_helper({GuildId, GoodsType, Num, Wlv}, {GoodsMap, IdList, Args, AddList}) ->
	[AuctionId, AuctionType, ModuleId, StartTime|_] = Args,
	case IdList of 
		[GoodsId|NewIdList] -> ok;
		_ -> 
			GoodsId   	= get_auction_goods_id(AuctionId),
			NewIdList = []
	end,
	InfoList    = [],
	Type 		= lib_auction_data:get_goods_type(GoodsType, Wlv),
	{NextPrice, NowPrice} = lib_auction_data:get_price(GoodsType, Wlv, InfoList),
	Elem 		= [GoodsId, AuctionId, GoodsType, Type, AuctionType, GuildId, ModuleId, ?GOODS_STATUS_SELL, 
					StartTime, Wlv, NextPrice, NowPrice, InfoList],
	AuctionGoods= lib_auction_data:make(auction_goods, Elem),
	NewGoodsMap = maps:put(GoodsId, AuctionGoods, GoodsMap),
	add_auction_goods_helper({GuildId, GoodsType, Num-1, Wlv}, {NewGoodsMap, NewIdList, Args, [AuctionGoods|AddList] }).

add_auction_goods_db_helper([], _Num) -> skip;
add_auction_goods_db_helper([Elem|T], Num) ->
	case Num rem 20 of
		0 -> timer:sleep(300);
		_ -> skip
	end,
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
		wlv 			= Wlv
	} = Elem,
	ArgList	= [GoodsId, AuctionId, GoodsType, Type, AuctionType, GuildId, ModuleId, GoodsStatus, StartTime, Wlv],
	lib_auction_data:add_auction_goods_db(ArgList),
	add_auction_goods_db_helper(T, Num+1).

%% 结束：关闭所有拍卖
close_all_auction_gm(State) ->
	#kf_auction_state{auction_map = AuctionMap} = State,
	case maps:to_list(AuctionMap) of
		[{AuctionId, #auction{} }|_] ->
			spawn(fun() -> timer:sleep(500), mod_kf_auction:close_all_auction_gm() end),
			close_auction(State, {AuctionId, 0, ?CLOSE_AUCTION_FORCE});
		_ -> {ok, State}
	end.

%% 关闭拍卖
close_auction(State, {AuctionId, GuildId, CloseType}) ->
	close_auction(State, {AuctionId, GuildId, CloseType, 0});

%% 关闭拍卖
%% @param GuildId   公会id
%% @param CloseType 1时间到正常结束|2秘籍强制结束
%% @param ClearJoin 是否清除参与记录 0否|1是
%%        旧：开启某活动新一场公会拍卖时，若上一场未结束的（一般GM秘籍开启的），需要关闭，但不清除参与记录
%%        现在默认不清参与记录，因为现在允许同个活动同时开启多场拍卖
close_auction(State, {AuctionId, GuildId, CloseType, ClearJoin}) ->
	?PRINT("close_auction ~p....~n", [{AuctionId, GuildId}]),
	timer_quest:delete(?UTIMER_ID(?TIMER_AUCTION, AuctionId)),
	case maps:get(AuctionId, State#kf_auction_state.auction_map, []) of
		#auction{zone_id = ZoneId} = Auction -> 
			{ok, NewState} = do_close_auction(State, Auction, GuildId, CloseType, ClearJoin),
			#kf_auction_state{auction_map = AuctionMap} = NewState,
			IsAllAuctionClose = [1 || #auction{zone_id = ZoneId1} <- maps:values(AuctionMap), ZoneId1 == ZoneId] == [],
			case IsAllAuctionClose of 
				true -> 
					{ok, Bin} = pt_154:write(15411, [1]),
					ZoneId > 0 andalso mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, lib_server_send, send_to_all, [Bin]);
				_ -> skip
			end,
			{ok, NewState};
		_ -> {ok, State}
	end.

do_close_auction(State, Auction, GuildId, CloseType, ClearJoin) ->
	NowTime = utime:unixtime(), 
	#auction{auction_id = AuctionId} = Auction,
	IsAuctionEnd = NowTime>=lib_auction_data:get_auction_endtime(Auction),
	CloseList = get_close_goods(State, Auction, GuildId, CloseType, NowTime, IsAuctionEnd),
	{ok, NewState, ToWorldList1} = close_goods(State, Auction, CloseList),
	% ?PRINT("close_auctio closelist:~p~n", [length(CloseList)]),
	% ?PRINT("close_auctio ToWorldList1:~p~n", [ToWorldList1]),
	NewGoodsMap = NewState#kf_auction_state.goods_map,
	NewAuctionMap = NewState#kf_auction_state.auction_map,
	NewAuction = maps:get(Auction#auction.auction_id, NewAuctionMap),
	ToWorldList = ToWorldList1 ++ NewAuction#auction.to_world_list,
	IsAllSellOut = lib_auction_util:is_all_sellout(NewGoodsMap, AuctionId),
	% ?PRINT("close_auctio state:~p~n", [{IsAuctionEnd, CloseType, GuildId}]),
	case {IsAuctionEnd, CloseType, GuildId} of
		%% 如果此时是公会延时的，关闭拍卖场次时同时关闭剩余其他公会拍卖
		{true, ?CLOSE_AUCTION_NORMAL, GuildId} when GuildId=/=0 ->
			CloseList2 = get_close_goods(NewGoodsMap, AuctionId, CloseList),
			{ok, NewState2, ToWorldList2} = close_goods(NewState, NewAuction, CloseList2),
			ToWorldList3 = ToWorldList ++ ToWorldList2,
			delete_auction(NewState2, NewAuction, CloseType, ClearJoin, ToWorldList3);
		{true, ?CLOSE_AUCTION_NORMAL, _} ->
			delete_auction(NewState, NewAuction, CloseType, ClearJoin, ToWorldList);
		{true, _, _} ->
			delete_auction(NewState, NewAuction, CloseType, ClearJoin, ToWorldList);
		{false, _, _} when IsAllSellOut == true ->
			case GuildId > 0 of 
				true -> %% 关闭公会拍卖，已经计算过分红，不需要重新计算
					delete_auction(NewState, NewAuction, CloseType, ClearJoin, ToWorldList);
				_ -> %% 世界拍卖提前结束, 计算分红，关闭拍卖
					CloseList2 = get_close_goods(NewGoodsMap, AuctionId, CloseList),
					%?PRINT("close_auctio again CloseList2 :~p~n", [length(CloseList2)]),
					{ok, NewState2, ToWorldList2} = close_goods(NewState, NewAuction, CloseList2),
					ToWorldList3 = ToWorldList ++ ToWorldList2,
					delete_auction(NewState2, NewAuction, CloseType, ClearJoin, ToWorldList3)
			end;
		{false, ?CLOSE_AUCTION_FORCE, _} ->
			delete_auction(NewState, NewAuction, CloseType, ClearJoin, ToWorldList);
		_ ->
			LastNewAuction = NewAuction#auction{to_world_list = ToWorldList},
			LastAuctionMap = maps:put(AuctionId, LastNewAuction, NewAuctionMap),
			{ok, NewState#kf_auction_state{auction_map = LastAuctionMap}}
	end.

%% 从GoodsMap获取符合AuctionId且排除SkipList的待关闭物品列表
get_close_goods(GoodsMap, AuctionId, SkipList) ->
	F = fun
	(#auction_goods{
		goods_id = GoodsId, auction_id = Id} = AuctionGoods, AccList) when Id==AuctionId->
		case lists:keymember(GoodsId, #auction_goods.goods_id, SkipList) of
			false -> [AuctionGoods|AccList];
			_ -> AccList
		end;
	(_, AccList) -> AccList
	end,
	lists:foldl(F, [], maps:values(GoodsMap)).

get_close_goods(State, Auction, GuildId, CloseType, NowTime, IsAuctionEnd) ->
	#kf_auction_state{
		goods_map 		= GoodsMap
	} = State,
	#auction{
		auction_id 		= AuctionId,
		delay_guild_map = DelayGuildMap
	} = Auction,
	case CloseType of
		%正常关闭某帮派的拍卖物品
		?CLOSE_AUCTION_NORMAL when GuildId=/=0 -> 
			[
				AuctionGoods||#auction_goods{auction_id = Id, guild_id = Gid} 
					= AuctionGoods<-maps:values(GoodsMap), Id==AuctionId, Gid == GuildId
			];
		%%正常关闭，且整场拍卖时间结束
		?CLOSE_AUCTION_NORMAL when IsAuctionEnd==true ->
			[
				AuctionGoods||#auction_goods{auction_id = Id} = 
					AuctionGoods<-maps:values(GoodsMap), Id==AuctionId
			];
		%正常关闭，关闭没延时且已结束的拍卖物品
		?CLOSE_AUCTION_NORMAL ->
			F = fun
			(#auction_goods{auction_id = Id} = AuctionGoods, AccList) when Id==AuctionId -> 
				Gid = AuctionGoods#auction_goods.guild_id,
				IsGoodsEnd = NowTime >= lib_auction_data:get_goods_endtime(AuctionGoods),
				case maps:get(Gid, DelayGuildMap, {0,0}) of
					{0,0} when IsGoodsEnd==true -> [AuctionGoods|AccList];
					_ -> AccList
				end;
			(_AuctionGoods, AccList) -> AccList
			end,
			lists:foldl(F, [], maps:values(GoodsMap));
		%强制关闭整场拍卖
		?CLOSE_AUCTION_FORCE ->  
			[
				AuctionGoods||#auction_goods{auction_id = Id} = 
					AuctionGoods<-maps:values(GoodsMap), Id==AuctionId
			]
	end.

%% 关闭列表中的拍卖物品
close_goods(State, Auction, CloseList) ->
	#kf_auction_state{
		guild_log_map   = GuildLogMap,
		world_log_list  = WorldLogList
	} = State,
	#auction{
		auction_id 		= AuctionId,
		module_id 		= ModuleId,
		auction_type 	= AuctionType
	} = Auction,
	%% 计算发放拍卖物品，分红数量
	{NewState, AwardArgs} = calc_auction_goods_award(CloseList, State, Auction),
	{_LogList, MailList, ToWorldList, GuildMoneyMap, PlayerLogList} = AwardArgs,
	% ?PRINT("close_goods GuildMoneyMap:~p~n", [maps:to_list(GuildMoneyMap)]),
	%% 这个拍卖记录已经不用，先屏蔽
	{NewGuildLogMap, NewWorldLogList} = lists:foldl(
		fun(LogElem, {AccMap, AccList}) -> 
			lib_auction_data:init_auction_log(LogElem, {AccMap, AccList})
		end, {GuildLogMap, WorldLogList}, []),

	NewState2 = NewState#kf_auction_state{
		guild_log_map   = NewGuildLogMap, world_log_list  = NewWorldLogList},

	%% 添加个人拍卖记录
	F = fun(Item, PlayerLogMap) ->
		[_PlayerId, ServerId|_] = Item,
		maps:put(ServerId, [Item|maps:get(ServerId, PlayerLogMap, [])], PlayerLogMap)
	end,
	PlayerLogMap = lists:foldl(F, #{}, PlayerLogList),
 	[mod_clusters_center:apply_cast(ServerId, mod_auction, add_player_auction_log, [List]) || {ServerId, List} <- maps:to_list(PlayerLogMap)],

	%% 清理物品数据，修改奖励状态	
	NewState3 = clear_close_goods(NewState2, CloseList),
	LastState = update_guild_award(NewState3, Auction, GuildMoneyMap),
	
	%% 发放拍卖物品，分红
	spawn(
		fun() -> 
			mail_auction_goods(MailList, ModuleId, AuctionType),
			mail_auction_bonus(State, {AuctionType, AuctionId, ModuleId, GuildMoneyMap})
			%% 这个拍卖记录已经不用，先屏蔽
			%lib_auction_data:add_auction_log_db_batch(LogList, 1)
		end
	),
	{ok, LastState, ToWorldList}.

%% 更新公会奖励状态
update_guild_award(State, Auction, GuildMoneyMap) ->
	NowTime = utime:unixtime(),
	#kf_auction_state{
		auction_map 	= AuctionMap
	} = State,
	#auction{
		auction_id 		= AuctionId,
		guild_award_map = GuildAwardMap
	} = Auction,
	AwardStatus	 = 1,
	GuildIdList  =  maps:keys(GuildMoneyMap),
	NewGuildAwardMap = lists:foldl(
		fun(GuildId, AccMap) -> maps:put(GuildId, AwardStatus, AccMap)
		end, GuildAwardMap, GuildIdList),
	NewAuction   = Auction#auction{guild_award_map = NewGuildAwardMap},
	NewAuctionMap= maps:put(AuctionId, NewAuction, AuctionMap),
	LastState    = State#kf_auction_state{auction_map = NewAuctionMap},

	AuctionEndTime= lib_auction_data:get_auction_endtime(Auction),
	case NowTime<AuctionEndTime of
		true ->
			Args = [[AuctionId, GuildId, AwardStatus, NowTime]||GuildId<-GuildIdList],
			spawn(fun() -> lib_auction_data:add_guild_award_db_batch(Args, 1) end);
		false -> skip
	end,
	LastState.

%% 清理拍卖场次
delete_auction(State, Auction, _CloseType, _ClearJoin, ToWorldList) ->
	#kf_auction_state{		
		auction_map 	= AuctionMap
	} = State,
	#auction{
		auction_id 		= AuctionId,
		module_id 		= _ModuleId,
		authentication_id = _AuthenticationId,
		auction_type 	= AuctionType
	} = Auction,

	NewAuctionMap= maps:remove(AuctionId, AuctionMap),
	spawn(fun() -> lib_auction_data:delete_close_goods_db(AuctionId) end),
	NewState = State#kf_auction_state{
		auction_map  = NewAuctionMap},

	%% 公会拍卖未拍出物品，流入世界拍卖
	LastState = trans_to_world(NewState, Auction, AuctionType, ToWorldList),
	{ok,  LastState}.

%% 流入世界拍卖
trans_to_world(State, _OldAuction, _AuctionType, []) -> State;
trans_to_world(State, OldAuction, ?AUCTION_GUILD, ToWorldList) ->
	%% 开启新一轮世界拍卖
	#auction{module_id = ModuleId} = OldAuction,
	NewModuleId 	  = ModuleId,    %% 从公会流拍到世界的，功能id设为0，可以避免到世界拍卖后再次进行世界的分红
	AuthenticationId = 0,   %% 从公会流拍到世界的，设置认证id=0，可以避免到世界拍卖后再次进行世界的分红
	GoodsListArgs = [{0, ToWorldList}],
	{ok, NewState} = start_auction(State, {?AUCTION_WORLD, NewModuleId, AuthenticationId, ?DEFAULT_CFG_ID, GoodsListArgs}),
	NewState;
trans_to_world(State, _OldAuction, _AuctionType, _ToList) -> State.
	
clear_close_goods(State,  CloseList) ->
	#kf_auction_state{
		goods_map 	= GoodsMap,
		guild_map	= GuildMap,
		world_map	= WorldMap
	} = State,
	NewGoodsMap = lists:foldl(
		fun(#auction_goods{goods_id = GoodsId}, Map) ->	maps:remove(GoodsId, Map)
		end, GoodsMap, CloseList),
	{NewGuildMap, NewWorldMap} = lib_auction_data:reinit_goods_catalog(reinit_all, {NewGoodsMap, GuildMap, WorldMap}),
	State#kf_auction_state{
		goods_map 	= NewGoodsMap,
		guild_map	= NewGuildMap,
		world_map	= NewWorldMap
	}.

calc_auction_goods_award(CloseList, State, Auction) ->
	NowTime = utime:unixtime(),
	CloseArgs = {[], [], [], #{}, []},
	calc_auction_goods_award_helper(CloseList, State, Auction, NowTime, CloseArgs).

%% @return {State, {LogList, MailList, ToWorldList, GuildMoneyMap}}
%% MailList 	:: 竞拍物品附件    [{OwnerId, GoodsType, [{?TYPE_GOODS, GoodsType, 1}] }|...]
%% ToWorldList  :: 流入世界拍卖物品	[{GoodsType, 1}]
%% GuildMoneyMap:: 各公会参与拍卖资金maps，用于计算分红 #{guild_id => [{?TYPE_BGOLD, 0, Num},{?TYPE_GOLD, 0, Num}]}
calc_auction_goods_award_helper([], State, _Auction, _NowTime, CloseArgs) -> 
	{State, CloseArgs};
calc_auction_goods_award_helper([AuctionGoods|T], State, Auction, NowTime, CloseArgs) ->
	{LogList, MailList, ToWorldList, GuildMoneyMap, PlayerLogList} = CloseArgs,
	#auction{
		guild_award_map = GuildAwardMap
	} = Auction,
	#auction_goods{
		goods_id 	  = GoodsId,
		guild_id  	  = GuildId,
		goods_type 	  = GoodsType,
		auction_type  = AuctionType,
		module_id 	  = ModuleId,
		goods_status  = GoodsStatus,
		now_price     = NowPrice,
		wlv           = Wlv,
		info_list     = InfoList
	} = AuctionGoods,
	MoneyList = maps:get(GuildId, GuildMoneyMap, []),
	AwardStatus = maps:get(GuildId, GuildAwardMap, 0),
	if
		%% 物品未拍出
		AwardStatus == 0 andalso InfoList == [] ->
			%%%%% 跨服拍卖没有流入世界的逻辑，先屏蔽
			NewLogList = LogList,
			AddMoneyList = lib_auction_data:get_unsold_bonus_list(ModuleId, GoodsType, Wlv),
			NewMoneyList = ulists:object_list_plus([AddMoneyList, MoneyList]),
			NewGuildMoneyMap = maps:put(GuildId, NewMoneyList, GuildMoneyMap),
			ToWorldGoodsList = [{GoodsType, 1, Wlv}],
			NewToWorldList 	 = ToWorldGoodsList ++ ToWorldList,
			NewCloseArgs = {NewLogList, MailList, NewToWorldList, NewGuildMoneyMap, PlayerLogList},
			calc_auction_goods_award_helper(T, State, Auction, NowTime, NewCloseArgs);
		%% 物品未拍出：当一个公会拍卖结束发放了奖励，但有其它公会拍卖未结束时重启了服务器，
		%%             且所有公会都结束拍卖时，统一计算需要流入世界拍卖的物品会执行到这里
		%% 注：服务器重启后内存中的ToWorldList需要重新计算
		InfoList == [] ->
			ToWorldGoodsList = [{GoodsType, 1, Wlv}],
			NewToWorldList 	 = ToWorldGoodsList ++ ToWorldList,
			NewCloseArgs = {LogList, MailList, NewToWorldList, GuildMoneyMap, PlayerLogList},
			calc_auction_goods_award_helper(T, State, Auction, NowTime, NewCloseArgs);
		%% 已拍出
		AwardStatus == 0 andalso GoodsStatus == ?GOODS_STATUS_SELLOUT->
			Info = lists:keyfind(NowPrice, #auction_info.price, InfoList),
			AddMoneyList = Info#auction_info.price_list,
			NewMoneyList = ulists:object_list_plus([AddMoneyList, MoneyList]),
			NewGuildMoneyMap = maps:put(GuildId, NewMoneyList, GuildMoneyMap),
			NewCloseArgs = {LogList, MailList, ToWorldList, NewGuildMoneyMap, PlayerLogList},
			calc_auction_goods_award_helper(T, State, Auction, NowTime, NewCloseArgs);
		%% 未达到一口价，最后竞拍者获得物品
		AwardStatus == 0 ->
			{OwnerId, ServerId} = lib_auction_data:get_top_player(NowPrice, InfoList),
			Info = lists:keyfind(NowPrice, #auction_info.price, InfoList),
			#auction_info{
				player_id = PlayerId, price_type = PriceType, price_list = AddMoneyList
			} = Info,
			{Gold, Bgold} = lib_auction_util:count_award_gold(AddMoneyList, 0, 0),
			LogElem = [AuctionType, ModuleId, GuildId, GoodsType, Wlv, NowPrice, NowTime, 0],
			NewLogList =[LogElem|LogList], 
			%% 个人拍卖记录
			PlayerLogElem = [PlayerId, ServerId, 1, ModuleId, PriceType, Gold, Bgold, GoodsType, Wlv, NowTime],
			PlayerFailLogList = lib_auction_data:get_pay_fail_player_log(InfoList, AuctionGoods, [PlayerId], []),
			NewPlayerLogList =  PlayerLogList ++ [PlayerLogElem|PlayerFailLogList],
			case lib_auction_data:get_real_goods(GoodsType, Wlv) of 
				{GoodsTypeId, Num} -> 
					GoodsList = [{?TYPE_GOODS, GoodsTypeId, Num}];
				_ -> 
					GoodsList = AddMoneyList
			end,
			LastMailList = [{OwnerId, ServerId, GuildId, GoodsId, NowPrice, GoodsList}]++MailList,
			NewMoneyList = ulists:object_list_plus([AddMoneyList, MoneyList]),
			NewGuildMoneyMap = maps:put(GuildId, NewMoneyList, GuildMoneyMap),
			NewCloseArgs = {NewLogList, LastMailList, ToWorldList, NewGuildMoneyMap, NewPlayerLogList},
			calc_auction_goods_award_helper(T, State, Auction, NowTime, NewCloseArgs);
		true ->	
			NewCloseArgs = {LogList, MailList, ToWorldList, GuildMoneyMap, PlayerLogList},
			calc_auction_goods_award_helper(T, State, Auction, NowTime, NewCloseArgs)
	end.

mail_auction_goods(MailList, ModuleId, AuctionType) ->
	mail_auction_goods_helper(MailList, ModuleId, AuctionType, 1).

%% @param ReturnList 返回格式 :: [{object_type, goods_id, num}
mail_auction_goods_helper([], _ModuleId, _AuctionType, _Num) -> skip;
mail_auction_goods_helper([{PlayerId, ServerId, GuildId, GoodsId, Price, ReturnList}|T], ModuleId, AuctionType, Num) ->
	case Num rem 20 of
		0 -> timer:sleep(300);
		_ -> skip
	end,
	case ReturnList of
		%% 拍得物品
		[{?TYPE_GOODS, GoodsType, _Num}|_] ->
			Args = [PlayerId, GuildId, ModuleId, AuctionType, GoodsId, Price, GoodsType, ReturnList],
			mod_clusters_center:apply_cast(ServerId, lib_auction_util, mail_auction_goods, [Args]);
		_ -> skip			
	end,
	mail_auction_goods_helper(T, ModuleId, AuctionType, Num+1).

%% 拍卖分红：公会拍卖才分红
%% GuildMoneyMap:: 各公会参与拍卖资金maps，用于计算分红 #{guild_id => [{?TYPE_BGOLD, 0, Num},{?TYPE_GOLD, 0, Num}]}
mail_auction_bonus(State, {AuctionType, AuctionId, ModuleId, GuildMoneyMap}) 
	when AuctionType == ?AUCTION_KF_REALM orelse AuctionType == ?AUCTION_GUILD ->
	#kf_auction_state{
		auction_map = AuctionMap
	} = State,
	Auction = maps:get(AuctionId, AuctionMap, #auction{}),
	GuildJoinNumMap = lib_auction_util:count_every_guild_join_num(Auction#auction.join_log_map),
	GuildBonusMap   = lib_auction_util:count_every_guild_bonus(GuildMoneyMap, GuildJoinNumMap),
	{GoldLimit, BGoldLimit} = lib_auction_data:get_module_bonus_limit(ModuleId),
	mail_bonus(Auction#auction.join_log_map, GoldLimit, BGoldLimit, GuildBonusMap, Auction#auction.module_id, Auction#auction.authentication_id),
	ok;
mail_auction_bonus(_State, {_AuctionType, _AuctionId, _ModuleId, _MoneyList}) ->
	skip.

%% IdList 		:: [{PlayerId, GuildId}]
%% GuildBonusMap:: #{GuildId => {Gold, Bgold}}
mail_bonus(JoinLog, GoldLimit, BGoldLimit, GuildBonusMap, ModuleId, AuthenticationId) ->
	IdList = maps:to_list(JoinLog),
	NowTime = utime:unixtime(),
	spawn(fun() -> mail_bonus_helper(IdList, GoldLimit, BGoldLimit, GuildBonusMap, ModuleId, AuthenticationId, NowTime, 0, []) end).

mail_bonus_helper([], _GoldLimit, _BGoldLimit, _GuildBonusMap, ModuleId, AuthenticationId, _NowTime, _Num, ServerList) -> 
	F = fun({ServerId, PlayerBonusList}) ->
		mod_clusters_center:apply_cast(ServerId, ?MODULE, mail_bonus_local, [ModuleId, AuthenticationId, PlayerBonusList])
	end,
	lists:foreach(F, ServerList),
	ok;
mail_bonus_helper([{PlayerId, #join_log{guild_id = GuildId, server_id = ServerId}}|T], GoldLimit, BGoldLimit, GuildBonusMap, ModuleId, AuthenticationId, NowTime, Num, ServerList) ->
	{Gold, Bgold} = maps:get(GuildId, GuildBonusMap, {0, 0}),
	case Gold > 0 orelse Bgold > 0 of
		true -> 
			{_, OL} = ulists:keyfind(ServerId, 1, ServerList, {ServerId, []}),
			NewOL = [[PlayerId, GuildId, ModuleId, Gold, Bgold, NowTime]|OL],
			NewServerList = lists:keystore(ServerId, 1, ServerList, {ServerId, NewOL});
		false -> 
			NewServerList = ServerList
	end,
	mail_bonus_helper(T, GoldLimit, BGoldLimit, GuildBonusMap, ModuleId, AuthenticationId, NowTime, Num+1, NewServerList).

mail_bonus_local(ModuleId, AuthenticationId, PlayerBonusList) ->
	case catch mod_auction:get_bonus_map() of 
		{ok, BonusMap} -> ok;
		_ -> BonusMap = #{}
	end,
	{GoldLimit, BGoldLimit} = lib_auction_data:get_module_bonus_limit(ModuleId),
	{BonusLogList, BonusList} = lib_auction_util:static_player_bonus_info(PlayerBonusList, BonusMap, GoldLimit, BGoldLimit),
	spawn(fun() -> 
		lib_auction_util:mail_bonus(ModuleId, AuthenticationId, BonusList, BonusLogList)
	end),
	ok.

%% 其它玩家出价更高，竞价失败，自动返还竞价的钻石
%% 注：加价不需要返还
return_auction_cost(PriceType, #auction_goods{info_list = InfoList} = OldAuctionGoods) 
	when PriceType=/=?PRICE_TYPE_ADD_PRICE andalso InfoList=/=[] ->
	#auction_goods{
		goods_id 	= GoodsId,
		auction_type= AuctionType,
		type 		= Type,
		goods_type  = GoodsType,
		now_price  = NowPrice,
		wlv        = Wlv,
		module_id 	= ModuleId
	} = OldAuctionGoods,

	Info = lists:keyfind(NowPrice, #auction_info.price, InfoList),
	PlayerId  = Info#auction_info.player_id,
	ServerId = Info#auction_info.server_id,
	PriceList = Info#auction_info.price_list,
	Args = [AuctionType, Type, ModuleId, GoodsId, PlayerId, GoodsType, Wlv, PriceList],
	mod_clusters_center:apply_cast(ServerId, ?MODULE, return_auction_cost_local, Args),
	ok;
%% 之前没有玩家出价或者是加价类型，不用返还
return_auction_cost(_PriceType, _OldAuctionGoods) -> 
	ok.

return_auction_cost_local(AuctionType, Type, ModuleId, GoodsId, PlayerId, GoodsType, Wlv, PriceList) ->
	AuctionGoodsName = lib_auction_data:get_auction_goods_name(GoodsType, Wlv),	
	Title   = utext:get(?LAN_TITLE_AUCTION_FAIL),
	Content = utext:get(?LAN_CONTENT_AUCTION_FAIL, [AuctionGoodsName]),
	lib_mail_api:send_sys_mail([PlayerId], Title, Content, PriceList),
	% end,
	Bgold = get_gold_num(?TYPE_BGOLD, PriceList),
	Gold = get_gold_num(?TYPE_GOLD, PriceList),
	Args = [AuctionType, Type, ModuleId, GoodsId, GoodsType, Bgold, Gold],
	lib_server_send:send_to_uid(PlayerId, pt_154, 15404, Args),
	ok.

get_gold_num(Type, PriceList) ->
	case lists:keyfind(Type, 1, PriceList) of
		{Type, _GoodsId, Gold} -> Gold;
		_ -> 0
	end.

%% ------------------------------- 竞拍操作 %% -------------------------------

pay_auction(State, {Cmd, PlayerId, ServerId, Name, GuildId, GoodsId, PriceType, PriceList}) ->
	{_TypeList, _goodsList, NumList} = lists:unzip3(PriceList),
	Price = lists:sum(NumList),
	#kf_auction_state{
		auction_map = AuctionMap,
		goods_map = GoodsMap} = State,
	AuctionGoods = maps:get(GoodsId, GoodsMap, false),
	CheckList  = [
			{pay_auction, PlayerId, ServerId, AuctionGoods, PriceType, Price, PriceList},
			{check_pay_right, PlayerId, ServerId, GuildId, AuctionGoods, PriceType, AuctionMap}
	],
	Args = {PlayerId, ServerId, Name, Cmd, GoodsId, PriceType, Price, PriceList},
	case lib_auction_util:checklist(CheckList) of
		true -> 
			case do_pay_auction(State, AuctionGoods, Args) of
				{ok, NewState} ->
					%% 注：下面返还AuctionGoods为旧的AuctionGoods，不从NewState新取值
					return_auction_cost(PriceType, AuctionGoods),
					{true, NewState};
				{false, Res} -> ?PRINT("pay_auction Res11 :~p~n", [{Res, PriceType, PriceList}]), {{false, Res}, State}
			end;
		{false, Res} -> ?PRINT("pay_auction Res :~p~n", [{Res, PriceType, PriceList}]), {{false, Res}, State}
	end.

do_pay_auction(State, AuctionGoods, {PlayerId, ServerId, Name, _Cmd, GoodsId, PriceType, Price, PriceList} = _Args) ->
	NowTime 	= utime:unixtime(),
	%% 计算竞拍物品最新价格，竞价详细列表
	{NewPrice, NewPriceList} = lib_auction_util:cacl_pay_auction_price(AuctionGoods, PriceType, Price, PriceList),
	%%%% 更新竞拍物品竞价，竞价详细列表
	UpdatePriceArgs = {PlayerId, ServerId, PriceType, NewPrice, NewPriceList, NowTime},
	{NewState, NewAuctionGoods} = update_pay_auction_price(State, AuctionGoods, UpdatePriceArgs),
	#kf_auction_state{
		goods_map = GoodsMap, guild_map = GuildMap, world_map = WorldMap, guild_log_map = GuildLogMap, 
		world_log_list= WorldLogList} = NewState,
	#auction_goods{
		type = _Type, goods_type = GoodsType, auction_type = AuctionType, goods_status = GoodsStatus,
		auction_id = AuctionId, module_id = ModuleId, guild_id = GuildId, wlv = Wlv} = NewAuctionGoods,
	%% 拍品对应的物品
	{GoodsTypeId, Num} = lib_auction_data:get_real_goods(GoodsType, Wlv),
	%% 物品拍出，更新拍卖记录，拍卖目录
	case GoodsStatus of
		?GOODS_STATUS_SELLOUT when AuctionType == ?AUCTION_KF_REALM ->
			CataLogArgs = {GoodsMap, GuildMap, WorldMap, GuildId, ModuleId, GoodsId},
			{NewGuildMap, NewWorldMap} = lib_auction_data:reinit_goods_catalog(reinit_guild, CataLogArgs),
			NewGuildLogMap = GuildLogMap, NewWorldLogList = WorldLogList;
		_ -> 
			NewGuildMap = GuildMap, NewWorldMap = WorldMap, NewGuildLogMap = GuildLogMap, NewWorldLogList = WorldLogList
	end,
	%% 玩家个人拍卖记录
	update_player_log(AuctionGoods, PlayerId, ServerId, PriceType, PriceList, NowTime),

	NewState2 = NewState#kf_auction_state{
		guild_map = NewGuildMap, world_map = NewWorldMap, guild_log_map = NewGuildLogMap, world_log_list= NewWorldLogList
	},

	F = fun() -> 
		InfoDbArgs = [GoodsId, AuctionId, PlayerId, ServerId, PriceType, NewPrice, util:term_to_bitstring(NewPriceList), NowTime],
		case GoodsStatus of
			?GOODS_STATUS_SELLOUT ->
				lib_auction_data:update_auction_goods_db([GoodsStatus, NowTime, GoodsId]),
				lib_auction_data:add_auction_log_db([AuctionType, ModuleId, GuildId, GoodsType, Wlv, NewPrice, NowTime, 0]),
				lib_auction_data:add_auction_info_db(InfoDbArgs);
			_ -> 
				lib_auction_data:add_auction_info_db(InfoDbArgs)
		end,
		true
    end,
    case catch db:transaction(F) of
    	true when GoodsStatus == ?GOODS_STATUS_SELLOUT->
    		lib_auction_util:notify_goods_info_to_payer(PlayerId, NewAuctionGoods), 
    		lib_log_api:log_auction_pay_kf(PlayerId, Name, GuildId, ModuleId, AuctionType, GoodsId, GoodsType, Wlv,
    			PriceType, PriceList, NewPrice),
    		%% 本公会的拍卖物品、本场次拍卖是否全部已拍出或结束(含定时器操作:是的话直接结束，跳过竞价延时判断)
			LastState = case is_all_sellout_or_endtime(GoodsMap, AuctionId, AuctionType, GuildId) of
				true -> NewState2;
				false -> pay_auction_delay(NewState2, NewAuctionGoods)			
			end,
			%% 发放拍卖物品
			MailList = [{PlayerId, ServerId, GuildId, GoodsId, NewPrice, [{?TYPE_GOODS, GoodsTypeId, Num}]}],
			mail_auction_goods(MailList, ModuleId, AuctionType),
			?PRINT("pay_auction succ 111  :~p~n", [NewPrice]),
			{ok, LastState};
		true ->
			lib_auction_util:notify_goods_info_to_payer(PlayerId, NewAuctionGoods),
			lib_log_api:log_auction_pay_kf(PlayerId, Name, GuildId, ModuleId, AuctionType, GoodsId, GoodsType, Wlv,
				PriceType, PriceList, NewPrice),
			%% 处理竞价延时，含定时器操作
			LastState = pay_auction_delay(NewState2, NewAuctionGoods),
			?PRINT("pay_auction succ 222  :~p~n", [NewPrice]),
			{ok, LastState};
    	Error ->
    		?ERR("do_pay_auction Error:~p~n", [Error]), 
    		{false, ?FAIL}
    end.

%%% 更新竞拍物品竞价，竞价详细列表
update_pay_auction_price(State, AuctionGoods, {_PlayerId, _ServerId, _PriceType, _NewPrice, NewPriceList, _NowTime}=Args) ->
	#kf_auction_state{
		auction_map = AuctionMap, goods_map = GoodsMap
	} = State,
	NewAuctionGoods = lib_auction_util:update_pay_auction_price(AuctionGoods, Args),
	NewGoodsMap = maps:put(AuctionGoods#auction_goods.goods_id, NewAuctionGoods, GoodsMap),
	NewAuctionMap = lib_auction_util:recount_auction_estimate_bonus(AuctionGoods#auction_goods.auction_id, AuctionMap, AuctionGoods, NewPriceList),
	NewState = State#kf_auction_state{goods_map = NewGoodsMap, auction_map = NewAuctionMap},
	{NewState, NewAuctionGoods}.

%% 跟新玩家个人交易记录
update_player_log(OldAuctionGoods, PlayerId, ServerId, PriceType, PriceList, NowTime) ->
	#auction_goods{
		goods_type = GoodsType, module_id = ModuleId, wlv = Wlv, now_price = _NowPrice, info_list = InfoList
	} = OldAuctionGoods,
	case PriceType of 
		?PRICE_TYPE_ONE_PRICE ->
			{Gold, Bgold} = lib_auction_util:count_award_gold(PriceList, 0, 0),
			PayElem = [PlayerId, ServerId, 1, ModuleId, PriceType, Gold, Bgold, GoodsType, Wlv, NowTime],
		 	FaliLog = lib_auction_data:get_pay_fail_player_log(InfoList, OldAuctionGoods, [PlayerId], []),
		 	NewPlayerLog = [PayElem|FaliLog],
		 	%% 添加个人拍卖记录
			F = fun(Item, PlayerLogMap) ->
				[_PlayerId1, ServerId1|_] = Item,
				maps:put(ServerId1, [Item|maps:get(ServerId1, PlayerLogMap, [])], PlayerLogMap)
			end,
			PlayerLogMap = lists:foldl(F, #{}, NewPlayerLog),
 			[mod_clusters_center:apply_cast(ServerId1, mod_auction, add_player_auction_log, [List]) || {ServerId1, List} <- maps:to_list(PlayerLogMap)];
		_ ->
			ok
	end.

%% 竞价延时，通知拍卖物价格、最高出价者信息变化
pay_auction_delay(State, AuctionGoods) ->
	#kf_auction_state{auction_map = AuctionMap, goods_map = GoodsMap} = State,
	{NewAuctionMap, NewGoodsMap} = lib_auction_util:pay_auction_delay(AuctionMap, GoodsMap, AuctionGoods),
	State#kf_auction_state{
		goods_map = NewGoodsMap, 
		auction_map = NewAuctionMap
	}.

%% 1.本公会的拍卖物品是否全部拍出或者结束| 2.本场次拍卖是否全部已拍出或结束
is_all_sellout_or_endtime(GoodsMap, AuctionId, AuctionType, GuildId) -> 
	Duration = 2,
	NowTime = utime:unixtime(),
	GoodsList = case AuctionType of
		?AUCTION_KF_REALM ->
			[AuctionGoods||#auction_goods{auction_id = Id, guild_id = Gid} = AuctionGoods
				<-maps:values(GoodsMap), Id==AuctionId, Gid==GuildId];
		_ ->
			[AuctionGoods||#auction_goods{auction_id = Id} = AuctionGoods
				<-maps:values(GoodsMap), Id==AuctionId]
	end,
	SellOutList = [
		AuctionGoods||#auction_goods{goods_status = GoodsStatus} = AuctionGoods<- GoodsList, 
		GoodsStatus==?GOODS_STATUS_SELLOUT orelse NowTime>=lib_auction_data:get_goods_endtime(AuctionGoods)],
	case length(SellOutList) == length(GoodsList) of
		true when AuctionType== ?AUCTION_KF_REALM -> 
			timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, 
				{mod_kf_auction, close_auction, [{AuctionId, GuildId, ?CLOSE_AUCTION_NORMAL}] }),
			true;
		true ->	
			timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, 
				{mod_kf_auction, close_auction, [{AuctionId, 0, ?CLOSE_AUCTION_NORMAL}] }),
			true;
		false -> false
	end.

zone_change(State, {OldZone, NewZone}) ->
	#kf_auction_state{auction_map = AuctionMap} = State,
	NewAuctionMap = maps:map(
		fun(AuctionId, Auction) -> 
			#auction{auction_type = AcutionType, zone_id = AuctionZoneId} = Auction,
			if
			 	AcutionType == ?AUCTION_KF_REALM andalso AuctionZoneId > 0 ->
					case get({auction_zone, AuctionId}) of 
						true -> %% 一个拍卖只能更改一次
							Auction;
						_ ->
							case AuctionZoneId == OldZone of 
								true ->
									db:execute(io_lib:format(<<"update `auction` set `zone_id`=~p where `auction_id` = ~p">>, [NewZone, AuctionId])),
									put({auction_zone, AuctionId}, true),
									Auction#auction{zone_id = NewZone};
								_ ->
									Auction
							end
					end;
				true ->
					Auction
			end
		end, 
		AuctionMap),
	{ok, State#kf_auction_state{auction_map = NewAuctionMap}}.

%% -------------------------- pp handle function %% --------------------------

%% 获取拍卖菜单
send_auction_catalog(State, {Cmd, _PlayerId, GuildId, Node, Sid}) ->
	NowTime = utime:unixtime(),
	#kf_auction_state{ 
		goods_map = GoodsMap,
		guild_map = GuildMap, 
		world_map = WorldMap} = State,
	ModuleList = maps:get(GuildId, GuildMap, []),
	WorldList  = maps:to_list(WorldMap),
	{PackModuleList, PackWorldList} = lib_auction_util:get_auction_catalog(ModuleList, WorldList, GoodsMap, NowTime),
	{ok, Bin} = pt_154:write(Cmd, [PackModuleList, PackWorldList]),
	lib_server_send:send_to_sid(Node, Sid, Bin),
	ok.

%% 获取拍卖物品
send_auction_goods(State, {Cmd, PlayerId, GuildId, AuctionType, Type, ModuleId, ServerId, Node, Sid})  ->
	#kf_auction_state{ 
		auction_map = AuctionMap,
		goods_map 	= GoodsMap,
		guild_map 	= GuildMap, 
		world_map 	= WorldMap} = State,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	GoodsList = lib_auction_util:get_auction_goods_list(AuctionMap, GoodsMap, GuildMap, WorldMap, PlayerId, GuildId, AuctionType, Type, ModuleId, ZoneId),
	%print_goods_map(aa, GoodsMap),
	?PRINT("kf auction_goods AuctionType:~p~n", [AuctionType]),
	?PRINT("kf auction_goods GoodsList:~p~n", [GoodsList]),
	Args = [AuctionType, GoodsList],
	{ok, Bin} = pt_154:write(Cmd, Args),
	lib_server_send:send_to_sid(Node, Sid, Bin),
	ok.

%% 获取预计分红
send_auction_estimate_bonus(State, {Cmd, PlayerId, GuildId, AuctionType, ModuleId, GoldGot, BgoldGot, ServerId, Node, Sid}) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	{AverageGold, AverageBgold} = get_auction_estimate_bonus_center(State, PlayerId, GuildId, AuctionType, ModuleId, ZoneId, GoldGot, BgoldGot),
	?PRINT("estimate_bonus AverageBonus : ~p~n", [{AverageGold, AverageBgold}]),
	{ok, Bin} = pt_154:write(Cmd, [AuctionType, ModuleId, AverageGold, AverageBgold]),
	lib_server_send:send_to_sid(Node, Sid, Bin),
	ok.

get_auction_estimate_bonus_center(State, PlayerId, GuildId, AuctionType, ModuleIdIn, ZoneId, GoldGot, BgoldGot) ->
	#kf_auction_state{auction_map = AuctionMap} = State,
	{AverageGold, AverageBgold} =  lists:foldl(
		fun({_AuctionId, #auction{auction_type = AuctionType1, join_log_map = JoinLogMap} = Auction}, {AccNum, AccNum1}) -> 
			case AuctionType1 == AuctionType of 
				true ->
					#auction{
						module_id 			= AucModuleId,
						zone_id = AuctionZoneId,
						guild_award_map 	= GuildAwardMap,
						estimate_bonus_map 	= EstimateBonusMap, 
						act_join_num_map 	= JoinNumMap
					} = Auction,
					case (ModuleIdIn == 0 orelse AucModuleId == ModuleIdIn) andalso (AuctionZoneId == 0 orelse (AuctionZoneId == ZoneId)) of 
						true ->
							IsJoin 		  =	maps:get(PlayerId, JoinLogMap, []),		
							JoinNum       = maps:get(GuildId, JoinNumMap, 0),
							EstimateBonus = maps:get(GuildId, EstimateBonusMap, []),	
							{Gold, Bgold} = lib_auction_util:count_award_gold(EstimateBonus, 0, 0),				
							AwardStatus   = maps:get(GuildId, GuildAwardMap, 0),
							case IsJoin=/=[] andalso JoinNum >0 andalso AwardStatus==0 of
								true -> 
									NewGold = round(Gold div JoinNum),
									NewBgold  = round((Bgold / JoinNum) + ((Gold / JoinNum) - NewGold)),
									{GoldLimit, BGoldLimit} = lib_auction_data:get_module_bonus_limit(AucModuleId),
									{RGold, Rbgold} = lib_auction_data:get_real_bonus(AucModuleId, GoldLimit, BGoldLimit, GoldGot, BgoldGot, NewGold, NewBgold),
									{RGold + AccNum, Rbgold + AccNum1};
								false -> {AccNum, AccNum1}
							end;
						_ ->
							{AccNum, AccNum1}
					end;
				_ ->
					{AccNum, AccNum1}
			end
		end, {0, 0}, maps:to_list(AuctionMap)),
	{round(AverageGold), round(AverageBgold)}.

quit_guild(State, {PlayerId}) ->
	#kf_auction_state{auction_map = AuctionMap} = State,
	NewAuctionMap = maps:map(
		fun(_AuctionId, Auction) -> 
			#auction{auction_type = AcutionType, join_log_map = JoinLogMap} = Auction,
			if
			 	AcutionType == ?AUCTION_GUILD orelse AcutionType == ?AUCTION_KF_REALM ->
					case maps:get(PlayerId, JoinLogMap, 0) of 
						#join_log{guild_id = GuildId} = JoinLog when GuildId > 0 ->
							NewJoinLogMap = maps:put(PlayerId, JoinLog#join_log{guild_id = 0}, JoinLogMap),
							Auction#auction{join_log_map = NewJoinLogMap};
						_ ->
							Auction
					end;
				true ->
					Auction
			end
		end, 
		AuctionMap),
	{ok, State#kf_auction_state{auction_map = NewAuctionMap}}.

need_send_world_tv(ModuleId, AuctionStatus) ->
	NowTime = utime:unixtime(),
	case get({tv, ModuleId, AuctionStatus}) of 
		OldTime when is_integer(OldTime) andalso NowTime < OldTime + 3 -> %% 3秒内同一个功能开了多个拍卖，只发一个传闻
			false;
		_R ->
			put({tv, ModuleId, AuctionStatus}, NowTime),
			true
	end.

print_goods_map(_Type, _NewGoodsMap) -> ok.
	% ?PRINT("goods_list ............. Type:~p~n", [Type]),
	% F = fun(_, AuctionGoods, Acc) ->
	% 	#auction_goods{goods_id = GoodsId, auction_id = AuctionId, auction_type = AuctionType, guild_id = GuildId, goods_type = GoodsType, wlv = Wlv, module_id = ModuleId, info_list = InfoList, goods_status = GoodsStatus} = AuctionGoods,
	% 	?PRINT("AuctionId:~p,GoodsId:~p,AuctionType:~p,GuildId:~p,GoodsType:~p,Wlv:~p,ModuleId:~p,endtime:~p,InfoList:~p,GoodsStatus:~p,~n", [AuctionId, GoodsId, AuctionType, GuildId, GoodsType, Wlv, ModuleId, lib_auction_data:get_goods_endtime(AuctionGoods), length(InfoList), GoodsStatus]),
	% 	Acc
	% end,
	% maps:fold(F, 1, NewGoodsMap).

