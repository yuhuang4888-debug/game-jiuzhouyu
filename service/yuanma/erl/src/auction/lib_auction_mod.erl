%% ---------------------------------------------------------------------------
%% @doc 拍卖行
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------

-module (lib_auction_mod).
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
-compile(export_all).
-export ([
		init/0,
		timer_check/1,		
		start_auction_notice/2,
		start_system_auction/2,
		get_sys_goods/1,
		start_auction/2, 
		add_auction_goods_db_helper/2
]).
-export ([
		close_auction/2, 
		close_all_auction_gm/1
]).
-export ([
		pay_auction/2]).
-export ([daily_clear/2, quit_guild/2, trans_to_goods_list/1, trans_to_wlv_auction_goods/2]).
-export ([
		send_auction_catalog/2,
		send_auction_goods/2, 
		send_my_auction/2, 
		send_auction_log/2,
		send_auction_estimate_bonus/2
]).


%% ----------------------------- init function  %% ----------------------------
init() ->
	lib_auction_data:init().

%% ------------------------------ timer_check  %% -----------------------------

%% 每分钟轮询一次检测拍卖活动开始以及拍卖结束
timer_check(State) ->
	{ok, NewState}  = check_end(State),
	{ok, LastState} = check_start(NewState),
	{ok, LastState}.

check_end(State) -> 
	NowTime   = utime:unixtime(),
	#auction_state{
		auction_map 	= AuctionMap
	} = State,
	AuctionList = maps:to_list(AuctionMap),
	AuctionId = get_end_auction_id(AuctionList, NowTime),
	case AuctionId > 0 of
		true ->
			?PRINT("timer close auction : ~p~n", [AuctionId]),
			{ok, NewState} = close_auction(State, {AuctionId, 0, ?CLOSE_AUCTION_NORMAL}),
			{ok, NewState};
		false -> {ok, State}
	end.

check_start(State) -> 
	NowTime   = utime:unixtime(),
	CfgIdList = data_auction:get_time_ids(),
	BeforeSec = ?WORLD_NOTICE1_BEFORE,
	CfgId = get_start_cfg_id(CfgIdList, NowTime, BeforeSec),
	case CfgId > 0 of
		true -> start_system_auction(State, CfgId);
		false -> {ok, State}
	end.

get_end_auction_id([], _NowTime) -> 0;
get_end_auction_id([{AuctionId, Auction}|T], NowTime) ->
	EndTime = lib_auction_data:get_auction_endtime(Auction),
	case NowTime >=EndTime of
		true -> AuctionId;
		false -> get_end_auction_id(T, NowTime)
	end.

get_start_cfg_id([], _NowTime, _BeforeSec) -> 0;
get_start_cfg_id([Id|T], NowTime, BeforeSec) ->
	case data_auction:get_time(Id) of
		#base_auction_time{time = Time} ->
			%% 	预告时间：正式开始时间减去提前时长
			FormatTime = format_time(Time),
			NoticeTime = FormatTime - BeforeSec,
			DiffTime   = NowTime - NoticeTime,
			%% check_start每分钟轮询一次的，加上大于0小于60, 只取一次值
			case DiffTime >=0 andalso DiffTime<60 of
				true -> Id;
				false -> get_start_cfg_id(T, NowTime, BeforeSec)
			end;
		_ -> get_start_cfg_id(T, NowTime, BeforeSec)
	end.

%% 转成当天时间戳
format_time({H,M,_S}) ->
	utime:unixdate() + H*3600+ M*60;
format_time(_Time) ->
	utime:unixdate().

%% 开启系统物品拍卖（crontab触发）
start_system_auction(State, CfgId) ->
	case get_sys_goods(CfgId) of
		SysGoodsList when SysGoodsList=/=[] ->
			ModuleId       = 0,
			GuildIdList    = [0],
			GuildGoodsList = [{GuildId, SysGoodsList}||GuildId<-GuildIdList],
			start_auction(State, {?AUCTION_WORLD, ModuleId, 0, CfgId, GuildGoodsList});
		_ -> 
			?ERR("unkown system_auction id:~p", [CfgId]),
			{ok, State}
	end.

get_sys_goods(CfgId) ->
	WorldLv = util:get_world_lv(),
	F = fun({GoodsType, _Num}, List) -> 
		case data_auction:get_goods(GoodsType, WorldLv) of
			#base_auction_goods{} -> [{GoodsType, _Num, WorldLv}|List];
			_-> List
		end
	end,
	case data_auction:get_time(CfgId) of
		#base_auction_time{sys_goods = SysGoods} ->	
			lists:foldl(F, [], SysGoods);
		_ -> []
	end.

%% 拍卖预告
start_auction_notice(State, {AuctionType, AuctionId, ?AUCTION_STATUS_NOTICE1, ModuleId, GuildGoodsList}) ->
	% case AuctionType of
	% 	?AUCTION_GUILD -> Duration = ?GUILD_NOTICE1_BEFORE;
	% 	?AUCTION_WORLD -> Duration = ?WORLD_NOTICE1_BEFORE
	% end,
	#auction_state{auction_map = AuctionMap} = State,
	#auction{time = StartTime} = maps:get(AuctionId, AuctionMap),
	Duration = max(1, StartTime - utime:unixtime()),
	% ?PRINT("start_auction_notice#1 Duration : ~p~n", [Duration]),
	%NeedAuctionTv = need_send_world_tv(ModuleId, ?AUCTION_STATUS_NOTICE1),
	spawn(fun() -> send_auction_tv(AuctionType, ?AUCTION_STATUS_NOTICE1, Duration, ModuleId, GuildGoodsList) end),
	AuctionStatus = ?AUCTION_STATUS_NOTICE2,
	NewState	  = update_auction(State, {AuctionId, AuctionStatus}),
	timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, {
		mod_auction, start_auction_notice, [{AuctionType, AuctionId, AuctionStatus, ModuleId, GuildGoodsList}] }),
	{ok, NewState};

start_auction_notice(State, {AuctionType, AuctionId, ?AUCTION_STATUS_NOTICE2, ModuleId, GuildGoodsList}) ->
	case AuctionType of
		?AUCTION_GUILD -> Duration = ?GUILD_AUCTION_DURATION(ModuleId);
		?AUCTION_WORLD -> Duration = ?WORLD_AUCTION_DURATION(ModuleId)
	end,
	NeedAuctionTv = need_send_world_tv(ModuleId, ?AUCTION_STATUS_NOTICE2),
	NeedAuctionTv andalso spawn(fun() -> send_auction_tv(AuctionType, ?AUCTION_STATUS_NOTICE2, Duration, ModuleId, GuildGoodsList) end),
	AuctionStatus = ?AUCTION_STATUS_BEGIN,
	NewState	  = update_auction(State, {AuctionId, AuctionStatus}),
	%% 再次初始化活动参与记录，预防活动功能延迟调用参与记录接口的情况
	AuctionMap 	  = NewState#auction_state.auction_map,
	Auction 	  = maps:get(AuctionId, AuctionMap),
	NewJoinLogMap = lib_auction_data:init_join_log(Auction),
	NewAuctionMap = lib_auction_data:init_auction_join_num(Auction, AuctionMap, NewJoinLogMap),
	LastState     = NewState#auction_state{auction_map = NewAuctionMap},
	% ?PRINT("start_auction_notice#2 Duration : ~p~n", [Duration]),
	timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, {
		mod_auction, close_auction, [{AuctionId, 0, ?CLOSE_AUCTION_NORMAL}] }),
	{ok, LastState};

start_auction_notice(State, {AuctionType, AuctionId, AuctionStatus, _ModuleId, _GuildGoodsList}) ->
	?ERR("unkown auction_status: ~p, ~p, ~p", [AuctionType, AuctionId, AuctionStatus]),
	{ok, State}.

update_auction(State, {AuctionId, AuctionStatus}) ->
	NowTime		  = utime:unixtime(),
	AuctionMap 	  = State#auction_state.auction_map,
	Auction 	  = maps:get(AuctionId, AuctionMap, #auction{}),
	NewAuction 	  = Auction#auction{auction_status = AuctionStatus, last_time = NowTime},
	NewAuctionMap = maps:put(AuctionId, NewAuction, AuctionMap),
	lib_auction_data:update_auction_db([AuctionStatus, NowTime, AuctionId]),
	State#auction_state{auction_map = NewAuctionMap}.

send_auction_tv(?AUCTION_GUILD, AuctionStatus, Duration, ModuleId, GuildGoodsList) ->
	Minute 	   = Duration div 60,
	ModuleName = data_auction:get_module_name(ModuleId),
	case AuctionStatus of
		?AUCTION_STATUS_NOTICE1 ->
			{ok, Bin} = pt_154:write(15408, [?AUCTION_GUILD, ModuleId, 1]),
			F = fun({GuildId, GoodsList}) ->
				GoodsTypeList = trans_to_tv_goods(GoodsList),
				case length(GoodsTypeList) > 0 of 
					true ->	
						GoodsStr = util:pack_tv_goods(GoodsTypeList),
						% ?PRINT("send_auction_tv GoodsStr ~p~n", [GoodsStr]),
						lib_server_send:send_to_guild(GuildId, Bin),
						lib_chat:send_TV({guild, GuildId}, ?MOD_AUCTION, 1, [ModuleName, Minute, GoodsStr]);
					_ ->
						ok
				end
			end,
			lists:foreach(F, GuildGoodsList);
		?AUCTION_STATUS_NOTICE2 ->
			{ok, Bin} = pt_154:write(15408, [?AUCTION_GUILD, ModuleId, 2]),
			F = fun({GuildId, _GoodsList}) -> 
				lib_server_send:send_to_guild(GuildId, Bin),
				lib_chat:send_TV({guild, GuildId}, ?MOD_AUCTION, 2, [ModuleName])
			end,
			lists:foreach(F, GuildGoodsList);
		_ -> skip
	end;
send_auction_tv(?AUCTION_WORLD, AuctionStatus, Duration, ModuleId, GuildGoodsList) ->
	Minute 	   = Duration div 60,
	case AuctionStatus of
		?AUCTION_STATUS_NOTICE1 ->
			{ok, Bin} = pt_154:write(15408, [?AUCTION_WORLD, ModuleId, 1]),
			lib_server_send:send_to_all(Bin),
			F = fun({_GuildId, GoodsList}) -> 	
				GoodsTypeList = trans_to_tv_goods(GoodsList),	
				case length(GoodsTypeList) > 0 of 
					true ->		
						GoodsStr = util:pack_tv_goods(GoodsTypeList),
						?PRINT("send_auction_tv GoodsStr ~p~n", [GoodsStr]),				
						lib_chat:send_TV({all}, ?MOD_AUCTION, 3, [Minute, GoodsStr]);
					_ ->
						ok
				end
			end,
			lists:foreach(F, GuildGoodsList);
		?AUCTION_STATUS_NOTICE2 ->
			{ok, Bin} = pt_154:write(15408, [?AUCTION_WORLD, ModuleId, 2]),
			lib_server_send:send_to_all(Bin),
			lib_chat:send_TV({all}, ?MOD_AUCTION, 4, []);
		_ -> skip
	end;
send_auction_tv(_AuctionType, _AuctionStatus, _Duration, _ModuleId, _GoodsListArgs) -> skip.

trans_to_tv_goods(GoodsList) ->
	F = fun({GoodsType, Num, Wlv}, List) ->
		case data_auction:get_goods(GoodsType, Wlv) of 
			#base_auction_goods{gtype_id = GoodsTypeId, goods_num = GoodsNum, tv = Tv} when Tv > 0 ->
				[{?TYPE_GOODS, GoodsTypeId, GoodsNum*Num}|List];
			_ -> List
		end
	end,
	lists:foldl(F, [], GoodsList).

trans_to_goods_list(GoodsList) ->
	F = fun({GoodsType, Num, Wlv}, List) ->
		case lib_auction_data:get_real_goods(GoodsType, Wlv) of 
			{GoodsTypeId, GoodsNum} ->
				[{?TYPE_GOODS, GoodsTypeId, GoodsNum*Num}|List];
			_ -> List
		end
	end,
	lists:foldl(F, [], GoodsList).

trans_to_wlv_auction_goods(GuildGoodsList, Wlv) ->
	F = fun({GuildId, GoodsList}, List) ->
		F1 = fun(Item, List1) ->
			case Item of 
				{GoodsType, Num} -> [{GoodsType, Num, Wlv}|List1];
				{GoodsType, Num, Wlv1} -> [{GoodsType, Num, Wlv1}|List1];
				_Obj ->
					?ERR("start_auction unkown obj:~p~n", [_Obj]),
					List1
			end
		end,
		NewGoodsList = lists:foldl(F1, [], GoodsList),
		[{GuildId, NewGoodsList}|List]
	end,
	NewGuildGoodsList = lists:foldl(F, [], GuildGoodsList),
	NewGuildGoodsList.

%% 开启拍卖
start_auction(State, {AuctionType, ModuleId, AuthenticationId, CfgId, GuildGoodsList}) ->
	Wlv = util:get_world_lv(),
	StartTime = 0,
	start_auction(State, {AuctionType, ModuleId, AuthenticationId, StartTime, CfgId, GuildGoodsList, Wlv});
start_auction(State, {AuctionType, ModuleId, AuthenticationId, StartTime, CfgId, GuildGoodsList}) ->
	Wlv = util:get_world_lv(),
	start_auction(State, {AuctionType, ModuleId, AuthenticationId, StartTime, CfgId, GuildGoodsList, Wlv});
start_auction(State, {AuctionType, ModuleId, AuthenticationId, StartTime, CfgId, GuildGoodsList, Wlv}) ->
	NewGuildGoodsList = trans_to_wlv_auction_goods(GuildGoodsList, Wlv),
	{NewGuildGoodsList2, EmptyGuildList} = check_auction_list(NewGuildGoodsList),
	send_empty_auction_tv(ModuleId, EmptyGuildList),
	%CloseState = close_last_auction(State, {AuctionType, ModuleId}),
	do_start_auction(State, {AuctionType, ModuleId, AuthenticationId, StartTime, CfgId, NewGuildGoodsList2}).

%% 没有获得拍卖物消息
send_empty_auction_tv(ModuleId, EmptyGuildList) ->
	ModuleName = data_auction:get_module_name(ModuleId),
	F = fun(GuildId) ->				
		lib_chat:send_TV({guild, GuildId}, ?MOD_AUCTION, 5, [ModuleName])
	end,
	lists:foreach(F, EmptyGuildList).

do_start_auction(State, {AuctionType, ModuleId, AuthenticationId, StartTimeIn, _CfgId, GuildGoodsList}) when GuildGoodsList=/=[] ->
	?PRINT("start_auction ~p....~n", [{AuctionType, ModuleId}]),
	NowTime   			= utime:unixtime(),
	#auction_state{
		auction_map 	= AuctionMap,
		goods_map 		= GoodsMap,
		guild_map 		= GuildMap,
		world_map  		= WorldMap
	} = State,

	%% 添加一场拍卖记录
	AuctionStatus= ?AUCTION_STATUS_NOTICE1,
	StartTime 	= case AuctionType of   %% 开始时间需要加上预告时长		
		?AUCTION_GUILD -> lib_auction_data:get_guild_start_time(ModuleId, NowTime, StartTimeIn); 
		?AUCTION_WORLD -> lib_auction_data:get_world_start_time(ModuleId, NowTime, StartTimeIn) 
	end,
	LastTime    = NowTime,
	AuctionId   = mod_id_create:get_new_id(?AUCTION_ID_CREATE),
	AuctionArgs = [AuctionId, AuctionType, 0, 0, ModuleId, AuthenticationId, AuctionStatus, StartTime, LastTime],
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
	NewJoinLogMap = lib_auction_data:init_join_log(NewAuction),
	LastAuctionMap= lib_auction_data:init_auction_join_num(NewAuction, NewAuctionMap2, NewJoinLogMap),
	% ?PRINT("start_auction NewJoinLogMap ~p~n", [maps:to_list(NewJoinLogMap)]),
	print_goods_map(start_auction, NewGoodsMap),
	%% 重置拍卖目录
	{NewGuildMap, NewWorldMap} = lib_auction_data:reinit_goods_catalog(reinit_all, {NewGoodsMap, GuildMap, WorldMap}),
	%% 添加一个动态定时器，Duration赋值为1无特别含义
	Duration = 1,
	timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, {
		mod_auction, start_auction_notice, [{AuctionType, AuctionId, AuctionStatus, ModuleId, GuildGoodsList}] }),
	NewState = State#auction_state{
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

%% 公会拍卖需要先关闭上一场
close_last_auction(State, {AuctionType, ModuleId}) ->
	LastAuction = get_last_auction(State#auction_state.auction_map, ModuleId),
	if
		AuctionType == ?AUCTION_GUILD andalso LastAuction=/=[] ->
			#auction{auction_id = CloseAuctionId} = LastAuction,
			{ok, CloseState} = close_auction(State, {CloseAuctionId, 0, ?CLOSE_AUCTION_FORCE, 0});
		true -> CloseState = State
	end,
	CloseState.

add_auction_goods({GuildId, GoodsList}, {GoodsMap, Args, AddGoodsList}) ->
	F = fun({GoodsType, Num, Wlv}, {Map, AddList}) -> 
		add_auction_goods_helper({GuildId, GoodsType, Num, Wlv}, {Map, Args, AddList})
	end, 
	{NewGoodsMap, NewAddList} = lists:foldl(F, {GoodsMap, AddGoodsList}, GoodsList),
	{NewGoodsMap, Args, NewAddList}.

add_auction_goods_helper({_GuildId, _GoodsType, 0, _}, {GoodsMap, _Args, AddList}) -> {GoodsMap, AddList};
add_auction_goods_helper({GuildId, GoodsType, Num, Wlv}, {GoodsMap, Args, AddList}) ->
	[AuctionId, AuctionType, ModuleId, StartTime|_] = Args,
	GoodsId   	= mod_id_create:get_new_id(?AUCTION_GOODS_ID_CREATE),	
	InfoList    = [],
	Type 		= lib_auction_data:get_goods_type(GoodsType, Wlv),
	{NextPrice, NowPrice} = lib_auction_data:get_price(GoodsType, Wlv, InfoList),
	Elem 		= [GoodsId, AuctionId, GoodsType, Type, AuctionType, GuildId, ModuleId, ?GOODS_STATUS_SELL, 
					StartTime, Wlv, NextPrice, NowPrice, InfoList],
	AuctionGoods= lib_auction_data:make(auction_goods, Elem),
	NewGoodsMap = maps:put(GoodsId, AuctionGoods, GoodsMap),
	add_auction_goods_helper({GuildId, GoodsType, Num-1, Wlv}, {NewGoodsMap, Args, [AuctionGoods|AddList] }).

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
	#auction_state{auction_map = AuctionMap} = State,
	case maps:to_list(AuctionMap) of
		[{AuctionId, #auction{} }|_] ->
			spawn(fun() -> timer:sleep(500), mod_auction:close_all_auction_gm() end),
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
	case maps:get(AuctionId, State#auction_state.auction_map, []) of
		#auction{} = Auction -> 
			{ok, NewState} = do_close_auction(State, Auction, GuildId, CloseType, ClearJoin),
			#auction_state{auction_map = AuctionMap} = NewState,
			case maps:size(AuctionMap) of 
				0 -> 
					{ok, Bin} = pt_154:write(15411, [1]),
					lib_server_send:send_to_all(Bin);
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
	NewGoodsMap = NewState#auction_state.goods_map,
	NewAuctionMap = NewState#auction_state.auction_map,
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
			{ok, NewState#auction_state{auction_map = LastAuctionMap}}
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
	#auction_state{
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
	#auction_state{
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
	{LogList, MailList, ToWorldList, GuildMoneyMap, PlayerLogList} = AwardArgs,
	% ?PRINT("close_goods GuildMoneyMap:~p~n", [maps:to_list(GuildMoneyMap)]),
	{NewGuildLogMap, NewWorldLogList} = lists:foldl(
		fun(LogElem, {AccMap, AccList}) -> 
			lib_auction_data:init_auction_log(LogElem, {AccMap, AccList})
		end, {GuildLogMap, WorldLogList}, LogList),
	%% 添加个人拍卖记录
 	mod_auction:add_player_auction_log(PlayerLogList),
	NewState2 = NewState#auction_state{
		guild_log_map   = NewGuildLogMap, world_log_list  = NewWorldLogList},

	%% 清理物品数据，修改奖励状态	
	NewState3 = clear_close_goods(NewState2, CloseList),
	LastState = update_guild_award(NewState3, Auction, GuildMoneyMap),
	
	%% 发放拍卖物品，分红
	spawn(
		fun() -> 
			mail_auction_goods(MailList, ModuleId, AuctionType),
			mail_auction_bonus(State, {AuctionType, AuctionId, ModuleId, GuildMoneyMap}),
			lib_auction_data:add_auction_log_db_batch(LogList, 1)
		end
	),
	{ok, LastState, ToWorldList}.

%% 更新公会奖励状态
update_guild_award(State, Auction, GuildMoneyMap) ->
	NowTime = utime:unixtime(),
	#auction_state{
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
	LastState    = State#auction_state{auction_map = NewAuctionMap},

	AuctionEndTime= lib_auction_data:get_auction_endtime(Auction),
	case NowTime<AuctionEndTime of
		true ->
			Args = [[AuctionId, GuildId, AwardStatus, NowTime]||GuildId<-GuildIdList],
			spawn(fun() -> lib_auction_data:add_guild_award_db_batch(Args, 1) end);
		false -> skip
	end,
	LastState.

%% 清理拍卖场次
delete_auction(State, Auction, _CloseType, ClearJoin, ToWorldList) ->
	#auction_state{		
		auction_map 	= AuctionMap
	} = State,
	#auction{
		auction_id 		= AuctionId,
		module_id 		= ModuleId,
		authentication_id = AuthenticationId,
		auction_type 	= AuctionType
	} = Auction,

	NewAuctionMap= maps:remove(AuctionId, AuctionMap),
	% case AuctionType of
	% 	?AUCTION_GUILD when ClearJoin==1 -> 
	% 		lib_act_join_api:clear_module(ModuleId);
	% 	_ -> skip
	% end,
	case ClearJoin == 1 of 
		true ->
			case AuthenticationId == 0 of 
				true ->
					lib_act_join_api:clear_module(ModuleId);
				_ ->
					lib_act_join_api:clear_with_authentication_id(AuthenticationId, ModuleId)
			end;
		_ -> skip
	end,
	spawn(fun() -> lib_auction_data:delete_close_goods_db(AuctionId) end),
	NewState = State#auction_state{
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
	#auction_state{
		goods_map 	= GoodsMap,
		guild_map	= GuildMap,
		world_map	= WorldMap
	} = State,
	NewGoodsMap = lists:foldl(
		fun(#auction_goods{goods_id = GoodsId}, Map) ->	maps:remove(GoodsId, Map)
		end, GoodsMap, CloseList),
	{NewGuildMap, NewWorldMap} = lib_auction_data:reinit_goods_catalog(reinit_all, {NewGoodsMap, GuildMap, WorldMap}),
	State#auction_state{
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
			if
			%% 流入世界的，写入拍卖记录
				AuctionType == ?AUCTION_GUILD ->
					LogElem = [AuctionType, ModuleId, GuildId, GoodsType, Wlv, NowPrice, NowTime, 1],
					NewLogList =[LogElem|LogList];
				true -> NewLogList = LogList
			end,
			%Price 		 = round(lib_auction_data:get_base_price(GoodsType, Wlv) * ?NO_SELL_AWARD_RATIO),
			%AddMoneyList = [{?TYPE_BGOLD, 0, Price}],
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
			LastMailList = [{OwnerId, GuildId, GoodsId, NowPrice, GoodsList}]++MailList,
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
mail_auction_goods_helper([{PlayerId, GuildId, GoodsId, Price, ReturnList}|T], ModuleId, AuctionType, Num) ->
	case Num rem 20 of
		0 -> timer:sleep(300);
		_ -> skip
	end,
	case ReturnList of
		%% 拍得物品
		[{?TYPE_GOODS, GoodsType, _Num}|_] ->
			Args = [PlayerId, GuildId, ModuleId, AuctionType, GoodsId, Price, GoodsType, ReturnList],
			lib_auction_util:mail_auction_goods(Args);
		_ -> skip			
	end,
	mail_auction_goods_helper(T, ModuleId, AuctionType, Num+1).

%% 拍卖分红：公会拍卖才分红
%% GuildMoneyMap:: 各公会参与拍卖资金maps，用于计算分红 #{guild_id => [{?TYPE_BGOLD, 0, Num},{?TYPE_GOLD, 0, Num}]}
mail_auction_bonus(State, {?AUCTION_GUILD, AuctionId, ModuleId, GuildMoneyMap}) ->
	#auction_state{
		auction_map = AuctionMap,
		bonus_map = BonusMap
	} = State,
	Auction = maps:get(AuctionId, AuctionMap, #auction{}),
	GuildJoinNumMap = lib_auction_util:count_every_guild_join_num(Auction#auction.join_log_map),
	GuildBonusMap   = lib_auction_util:count_every_guild_bonus(GuildMoneyMap, GuildJoinNumMap),
	{GoldLimit, BGoldLimit} = lib_auction_data:get_module_bonus_limit(ModuleId),
	mail_bonus(Auction#auction.join_log_map, BonusMap, GoldLimit, BGoldLimit, GuildBonusMap, Auction#auction.module_id, Auction#auction.authentication_id),
	ok;
%% 世界拍卖分红
%% GuildMoneyMap:: 拍卖资金maps，用于计算分红 #{0 => [{?TYPE_BGOLD, 0, Num},{?TYPE_GOLD, 0, Num}]}
mail_auction_bonus(State, {?AUCTION_WORLD, AuctionId, ModuleId, GuildMoneyMap}) ->
	#auction_state{
		auction_map = AuctionMap,
		bonus_map = BonusMap
	} = State,
	Auction = maps:get(AuctionId, AuctionMap, #auction{}),
	NeedBonusModuleList = ?WORLD_BONUS_MODULE,
	% ?PRINT("mail_auction_bonus start : ~p~n", [ModuleId]),
	case lists:member(ModuleId, NeedBonusModuleList) of 
		true ->
			%% 世界拍卖得到的资金maps中，公会id是等于0的
			JoinLogMap = Auction#auction.join_log_map,
			NewJoinLogMap = maps:map(fun(_PlayerId, JoinLog) -> JoinLog#join_log{guild_id = 0} end, JoinLogMap),
			GuildJoinNumMap = lib_auction_util:count_every_guild_join_num(NewJoinLogMap),
			GuildBonusMap   = lib_auction_util:count_every_guild_bonus(GuildMoneyMap, GuildJoinNumMap),
			{GoldLimit, BGoldLimit} = lib_auction_data:get_module_bonus_limit(ModuleId),
			?PRINT("world bonus GuildJoinNumMap : ~p~n", [GuildJoinNumMap]),
			?PRINT("world bonus GuildBonusMap : ~p~n", [GuildBonusMap]),
			mail_bonus(NewJoinLogMap, BonusMap, GoldLimit, BGoldLimit, GuildBonusMap, Auction#auction.module_id, Auction#auction.authentication_id),
			ok;
		_ ->
			ok
	end;
mail_auction_bonus(_State, {_AuctionType, _AuctionId, _ModuleId, _MoneyList}) ->
	skip.

%% IdList 		:: [{PlayerId, GuildId}]
%% GuildBonusMap:: #{GuildId => {Gold, Bgold}}
mail_bonus(JoinLog, BonusMap, GoldLimit, BGoldLimit, GuildBonusMap, ModuleId, AuthenticationId) ->
	IdList = maps:to_list(JoinLog),
	NowTime = utime:unixtime(),
	mail_bonus_helper(IdList, BonusMap, GoldLimit, BGoldLimit, GuildBonusMap, ModuleId, AuthenticationId, NowTime, 0, []).

mail_bonus_helper([], BonusMap, GoldLimit, BGoldLimit, _GuildBonusMap, ModuleId, AuthenticationId, _NowTime, _Num, PlayerBonusList) -> 
	{BonusLogList, BonusList} = lib_auction_util:static_player_bonus_info(PlayerBonusList, BonusMap, GoldLimit, BGoldLimit),
	spawn(fun() -> 
		lib_auction_util:mail_bonus(ModuleId, AuthenticationId, BonusList, BonusLogList)
	end),
	ok;
mail_bonus_helper([{PlayerId, #join_log{guild_id = GuildId}}|T], BonusMap, GoldLimit, BGoldLimit, GuildBonusMap, ModuleId, AuthenticationId, NowTime, Num, PlayerBonusList) ->
	{Gold, Bgold} = maps:get(GuildId, GuildBonusMap, {0, 0}),
	case Gold > 0 orelse Bgold > 0 of
		true -> 
			NewPlayerBonusList = [[PlayerId, GuildId, ModuleId, Gold, Bgold, NowTime]|PlayerBonusList];
		false -> 
			NewPlayerBonusList = PlayerBonusList
	end,
	mail_bonus_helper(T, BonusMap, GoldLimit, BGoldLimit, GuildBonusMap, ModuleId, AuthenticationId, NowTime, Num+1, NewPlayerBonusList).

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
	PriceList = Info#auction_info.price_list,
	% case lib_player:is_online_global(PlayerId) of
	% 	true -> 
	% 		lib_goods_api:send_reward_by_id(PriceList, auction_fail, PlayerId);
	% 	false ->
	AuctionGoodsName = lib_auction_data:get_auction_goods_name(GoodsType, Wlv),	
	Title   = utext:get(?LAN_TITLE_AUCTION_FAIL),
	Content = utext:get(?LAN_CONTENT_AUCTION_FAIL, [AuctionGoodsName]),
	lib_mail_api:send_sys_mail([PlayerId], Title, Content, PriceList),
	% end,
	Bgold = get_gold_num(?TYPE_BGOLD, PriceList),
	Gold = get_gold_num(?TYPE_GOLD, PriceList),
	Args = [AuctionType, Type, ModuleId, GoodsId, GoodsType, Bgold, Gold],
	lib_server_send:send_to_uid(PlayerId, pt_154, 15404, Args),
	ok;
%% 之前没有玩家出价或者是加价类型，不用返还
return_auction_cost(_PriceType, _OldAuctionGoods) -> 
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
	#auction_state{
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

do_pay_auction(State, AuctionGoods, {PlayerId, ServerId, _Name, _Cmd, GoodsId, PriceType, Price, PriceList} = _Args) ->
	NowTime 	= utime:unixtime(),
	%% 计算竞拍物品最新价格，竞价详细列表
	{NewPrice, NewPriceList} = lib_auction_util:cacl_pay_auction_price(AuctionGoods, PriceType, Price, PriceList),
	%%%% 更新竞拍物品竞价，竞价详细列表
	UpdatePriceArgs = {PlayerId, ServerId, PriceType, NewPrice, NewPriceList, NowTime},
	{NewState, NewAuctionGoods} = update_pay_auction_price(State, AuctionGoods, UpdatePriceArgs),
	#auction_state{
		goods_map = GoodsMap, guild_map = GuildMap, world_map = WorldMap, guild_log_map = GuildLogMap, 
		world_log_list= WorldLogList} = NewState,
	#auction_goods{
		type = Type, goods_type = GoodsType, auction_type = AuctionType, goods_status = GoodsStatus,
		auction_id = AuctionId, module_id = ModuleId, guild_id = GuildId, wlv = Wlv} = NewAuctionGoods,
	%% 拍品对应的物品
	{GoodsTypeId, Num} = lib_auction_data:get_real_goods(GoodsType, Wlv),
	%% 物品拍出，更新拍卖记录，拍卖目录
	case GoodsStatus of
		?GOODS_STATUS_SELLOUT when AuctionType == ?AUCTION_GUILD ->
			CataLogArgs = {GoodsMap, GuildMap, WorldMap, GuildId, ModuleId, GoodsId},
			{NewGuildMap, NewWorldMap} = lib_auction_data:reinit_goods_catalog(reinit_guild, CataLogArgs),
			{NewGuildLogMap, NewWorldLogList} = update_auction_log(GuildLogMap, WorldLogList, NewAuctionGoods, 0);
		?GOODS_STATUS_SELLOUT when AuctionType == ?AUCTION_WORLD ->
			CataLogArgs = {GoodsMap, GuildMap, WorldMap, Type, GoodsId},
			{NewGuildMap, NewWorldMap} = lib_auction_data:reinit_goods_catalog(reinit_world, CataLogArgs),
			{NewGuildLogMap, NewWorldLogList} = update_auction_log(GuildLogMap, WorldLogList, NewAuctionGoods, 0);
		_ -> 
			NewGuildMap = GuildMap, NewWorldMap = WorldMap, NewGuildLogMap = GuildLogMap, NewWorldLogList = WorldLogList
	end,
	%% 玩家个人拍卖记录
	update_player_log(AuctionGoods, PlayerId, ServerId, PriceType, PriceList, NowTime),

	NewState2 = NewState#auction_state{
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
    		lib_log_api:log_auction_pay(PlayerId, GuildId, ModuleId, AuctionType, GoodsId, GoodsType, Wlv,
    			PriceType, PriceList, NewPrice),
    		%% 本公会的拍卖物品、本场次拍卖是否全部已拍出或结束(含定时器操作:是的话直接结束，跳过竞价延时判断)
			LastState = case is_all_sellout_or_endtime(GoodsMap, AuctionId, AuctionType, GuildId) of
				true -> NewState2;
				false -> pay_auction_delay(NewState2, NewAuctionGoods)			
			end,
			%% 发放拍卖物品
			MailList = [{PlayerId, GuildId, GoodsId, NewPrice, [{?TYPE_GOODS, GoodsTypeId, Num}]}],
			mail_auction_goods(MailList, ModuleId, AuctionType),
			?PRINT("pay_auction succ 111  :~p~n", [NewPrice]),
			{ok, LastState};
		true ->
			lib_auction_util:notify_goods_info_to_payer(PlayerId, NewAuctionGoods),
			lib_log_api:log_auction_pay(PlayerId, GuildId, ModuleId, AuctionType, GoodsId, GoodsType, Wlv,
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
	#auction_state{
		auction_map = AuctionMap, goods_map = GoodsMap
	} = State,
	NewAuctionGoods = lib_auction_util:update_pay_auction_price(AuctionGoods, Args),
	NewGoodsMap = maps:put(AuctionGoods#auction_goods.goods_id, NewAuctionGoods, GoodsMap),
	NewAuctionMap = lib_auction_util:recount_auction_estimate_bonus(AuctionGoods#auction_goods.auction_id, AuctionMap, AuctionGoods, NewPriceList),
	NewState = State#auction_state{goods_map = NewGoodsMap, auction_map = NewAuctionMap},
	{NewState, NewAuctionGoods}.

%% 更新拍卖记录
update_auction_log(GuildLogMap, WorldLogList, AuctionGoods, ToWorld) ->
	NowTime = utime:unixtime(),
	#auction_goods{		
		goods_type 	  = GoodsType,
		auction_type  = AuctionType,
		module_id 	  = ModuleId,
		guild_id 	  = GuildId,
		now_price     = NowPrice,
		wlv 		  = Wlv
	} = AuctionGoods,
	LogElem = [AuctionType, ModuleId, GuildId, GoodsType, Wlv, NowPrice, NowTime, ToWorld],
	lib_auction_data:init_auction_log(LogElem, {GuildLogMap, WorldLogList}).
	%% @reuturn {NewGuildLogMap, NewWorldLogList}

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
		 	mod_auction:add_player_auction_log(NewPlayerLog);
		_ ->
			ok
	end.
	
%% 竞价延时，通知拍卖物价格、最高出价者信息变化
pay_auction_delay(State, AuctionGoods) ->
	#auction_state{auction_map = AuctionMap, goods_map = GoodsMap} = State,
	{NewAuctionMap, NewGoodsMap} = lib_auction_util:pay_auction_delay(AuctionMap, GoodsMap, AuctionGoods),
	State#auction_state{
		goods_map = NewGoodsMap, 
		auction_map = NewAuctionMap
	}.

%% 1.本公会的拍卖物品是否全部拍出或者结束| 2.本场次拍卖是否全部已拍出或结束
is_all_sellout_or_endtime(GoodsMap, AuctionId, AuctionType, GuildId) -> 
	Duration = 2,
	NowTime = utime:unixtime(),
	GoodsList = case AuctionType of
		?AUCTION_GUILD ->
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
		true when AuctionType== ?AUCTION_GUILD -> 
			timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, 
				{mod_auction, close_auction, [{AuctionId, GuildId, ?CLOSE_AUCTION_NORMAL}] }),
			true;
		true ->	
			timer_quest:add(?UTIMER_ID(?TIMER_AUCTION, AuctionId), Duration, 0, 
				{mod_auction, close_auction, [{AuctionId, 0, ?CLOSE_AUCTION_NORMAL}] }),
			true;
		false -> false
	end.

%% 日清：拍卖记录，活动参与记录
daily_clear(State, {_DelaySec}) ->
	lib_auction_data:delete_auction_log_db(),
	case utime:day_of_week() of 
		1 ->
			lib_auction_data:delete_bonus_log_db(),
			lib_auction_data:delete_player_log_db(),
			{ok, State#auction_state{guild_log_map = #{}, world_log_list = [], bonus_log_map = #{}, bonus_map = #{}, player_log_map = #{}}};
		_ ->
			{ok, State#auction_state{guild_log_map = #{}, world_log_list = []}}
	end.
	
%% 退出公会，清除活动参与记录
quit_guild(State, {PlayerId}) ->
	#auction_state{auction_map = AuctionMap} = State,
	NewAuctionMap = maps:map(
		fun(_AuctionId, Auction) -> 
			#auction{auction_type = AcutionType, join_log_map = JoinLogMap} = Auction,
			case AcutionType of 
				?AUCTION_GUILD ->
					case maps:get(PlayerId, JoinLogMap, 0) of 
						#join_log{guild_id = GuildId} = JoinLog when GuildId > 0 ->
							NewJoinLogMap = maps:put(PlayerId, JoinLog#join_log{guild_id = 0}, JoinLogMap),
							Auction#auction{join_log_map = NewJoinLogMap};
						_ ->
							Auction
					end;
				_ ->
					Auction
			end
		end, 
		AuctionMap),
	{ok, State#auction_state{auction_map = NewAuctionMap}}.

gm_clear_auction_pay_record(State, RoleId) ->
	#auction_state{player_log_map = PlayerLogMap} = State,
	db:execute(io_lib:format(<<"delete from `player_auction_log` where player_id=~p ">>, [RoleId])),
	NewPlayerLogMap = maps:remove(RoleId, PlayerLogMap),
	{ok, State#auction_state{player_log_map = NewPlayerLogMap}}.
	
gm_clear_auction_bonus(State, RoleId) ->
	#auction_state{bonus_map = BonusMap, bonus_log_map = BonusLogMap} = State,
	db:execute(io_lib:format(<<"delete from `auction_bonus_log` where player_id=~p ">>, [RoleId])),
	NewBonusMap = maps:remove(RoleId, BonusMap),
	NewBonusLogMap = maps:remove(RoleId, BonusLogMap),
	{ok, State#auction_state{bonus_map = NewBonusMap, bonus_log_map = NewBonusLogMap}}.

%% -------------------------- pp handle function %% --------------------------

%% 获取拍卖菜单
send_auction_catalog(State, {Cmd, PlayerId, GuildId}) ->
	NowTime = utime:unixtime(),
	#auction_state{ 
		goods_map = GoodsMap,
		guild_map = GuildMap, 
		world_map = WorldMap} = State,
	ModuleList = maps:get(GuildId, GuildMap, []),
	WorldList  = maps:to_list(WorldMap),
	{PackModuleList, PackWorldList} = lib_auction_util:get_auction_catalog(ModuleList, WorldList, GoodsMap, NowTime),
	?PRINT("auction_catalog PackModuleList:~p~n", [PackModuleList]),
	?PRINT("auction_catalog PackWorldList:~p~n", [PackWorldList]),
	lib_server_send:send_to_uid(PlayerId, pt_154, Cmd, [PackModuleList, PackWorldList]),
	ok.

%% 获取拍卖物品
send_auction_goods(State, {Cmd, PlayerId, GuildId, AuctionType, Type, ModuleId})  ->
	#auction_state{ 
		auction_map = AuctionMap,
		goods_map 	= GoodsMap,
		guild_map 	= GuildMap, 
		world_map 	= WorldMap} = State,
	ZoneId = 0,
	GoodsList = lib_auction_util:get_auction_goods_list(AuctionMap, GoodsMap, GuildMap, WorldMap, PlayerId, GuildId, AuctionType, Type, ModuleId, ZoneId),
	?PRINT("auction_goods AuctionType:~p~n", [AuctionType]),
	?PRINT("auction_goods GoodsList:~p~n", [GoodsList]),
	Args = [AuctionType, GoodsList],
	lib_server_send:send_to_uid(PlayerId, pt_154, Cmd, Args),
	ok.

%% 获取上一场活动id为ModuleId的公会拍卖
get_last_auction(AuctionMap, ModuleId) ->
	FilterAuctionMap = maps:filter(
		fun(_K, #auction{module_id = Mid}) ->
			Mid==ModuleId end, AuctionMap),
	AuctionList = lists:sort(
		fun({AuctionIdA, _AuctionA}, {AuctionIdB, _AuctionB}) -> 
			AuctionIdA>AuctionIdB
		end, maps:to_list(FilterAuctionMap)),
	case AuctionList of
		[{_AuctionId, Auction}|_] -> Auction;
		_ -> []
	end.

get_last_guild_auction(AuctionMap, ModuleId, GuildId) ->
	FilterAuctionMap = maps:filter(
		fun(_K, #auction{module_id = Mid, act_join_num_map = ActJoinNumMap}) ->
			Mid==ModuleId andalso maps:get(GuildId, ActJoinNumMap, 0) > 0 end, AuctionMap),
	AuctionList = lists:sort(
		fun({AuctionIdA, _AuctionA}, {AuctionIdB, _AuctionB}) -> 
			AuctionIdA>AuctionIdB
		end, maps:to_list(FilterAuctionMap)),
	case AuctionList of
		[{_AuctionId, Auction}|_] -> Auction;
		_ -> []
	end.

%% 我的竞拍
send_my_auction(State, {Cmd, PlayerId, GuildId}) ->
	NowTime = utime:unixtime(),
	#auction_state{ 
		auction_map = AuctionMap,
		goods_map 		= GoodsMap} = State,
	GoodsList = lists:foldl(
		fun({_K, Goods}, Acc) -> 
			List = Goods#auction_goods.info_list,
			case lists:keyfind(PlayerId, #auction_info.player_id, List) of
				false -> Acc;
				_ -> [Goods|Acc]
			end
		end, [], maps:to_list(GoodsMap)),
	ZoneId = 0,
	{PackList, _, _} =	lists:foldl(
		fun(Goods, {Acc, BonusStatus, BlStatus}) -> lib_auction_util:pack_goods(NowTime, PlayerId, GuildId, ZoneId, Goods, AuctionMap, Acc, BonusStatus, BlStatus)
		end, {[], #{}, #{}}, GoodsList),
	lib_server_send:send_to_uid(PlayerId, pt_154, Cmd, [PackList]),
	ok.

%% 拍卖记录
send_auction_log(State, {Cmd, PlayerId, GuildId, AuctionType}) ->
	#auction_state{guild_log_map  = GuildLogMap, world_log_list = WorldLogList} = State,
	LogList = case AuctionType of 
		?AUCTION_GUILD -> maps:get(GuildId, GuildLogMap, []); 
		_ -> WorldLogList 
	end,
	List = [
		{Log#auction_log.module_id, Log#auction_log.time, Log#auction_log.goods_type, Log#auction_log.wlv,
		Log#auction_log.price, Log#auction_log.to_world }||Log<-LogList],
	lib_server_send:send_to_uid(PlayerId, pt_154, Cmd, [AuctionType, List]),
	ok.

%% 获取预计分红
send_auction_estimate_bonus(State, {Cmd, PlayerId, GuildId, Realm, AuctionType, ModuleId, ServerId, Node, Sid}) ->
	case AuctionType of 
		?AUCTION_KF_REALM ->
			ModuleBonusInfos = maps:get(PlayerId, State#auction_state.bonus_map, []),
			case lists:keyfind(ModuleId, #bonus_info.module_id, ModuleBonusInfos) of 
				#bonus_info{gold = GoldGot, bgold = BgoldGot} -> ok;
				_ ->
					GoldGot = 0, BgoldGot = 0
			end,
			mod_kf_auction:cast_kf_auction(send_auction_estimate_bonus, [{Cmd, PlayerId, Realm, AuctionType, ModuleId, GoldGot, BgoldGot, ServerId, Node, Sid}]);
		_ ->
			{AverageGold, AverageBgold} = get_auction_estimate_bonus_local(State, PlayerId, GuildId, AuctionType, ModuleId),
			?PRINT("estimate_bonus AverageBonus : ~p~n", [{AverageGold, AverageBgold}]),
			lib_server_send:send_to_uid(PlayerId, pt_154, Cmd, [AuctionType, ModuleId, AverageGold, AverageBgold]),
			ok
	end.

get_auction_estimate_bonus_local(State, PlayerId, GuildId, AuctionType, ModuleIdIn) ->
	#auction_state{
		auction_map = AuctionMap, bonus_map = BonusMap} = State,
	{AverageGold, AverageBgold} =  lists:foldl(
		fun({_AuctionId, #auction{auction_type = ?AUCTION_GUILD, join_log_map = JoinLogMap} = Auction}, {AccNum, AccNum1}) -> 
			case AuctionType == ?AUCTION_GUILD of 
				true ->
					#auction{
						module_id 			= AucModuleId,
						guild_award_map 	= GuildAwardMap,
						estimate_bonus_map 	= EstimateBonusMap, 
						act_join_num_map 	= JoinNumMap
					} = Auction,
					case (ModuleIdIn == 0 orelse AucModuleId == ModuleIdIn) of 
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
									{RGold, Rbgold} = lib_auction_data:get_player_real_bonus(PlayerId, AucModuleId, BonusMap, NewGold, NewBgold, GoldLimit, BGoldLimit),
									{RGold + AccNum, Rbgold + AccNum1};
								false -> {AccNum, AccNum1}
							end;
						_ ->
							{AccNum, AccNum1}
					end;
				_ ->
					{AccNum, AccNum1}
			end;
		({_AuctionId, #auction{auction_type = ?AUCTION_WORLD, join_log_map = JoinLogMap} = Auction}, {AccNum, AccNum1}) -> 
			case AuctionType == ?AUCTION_WORLD of 
				true ->
					#auction{
						module_id 			= AucModuleId,
						guild_award_map 	= GuildAwardMap,
						estimate_bonus_map 	= EstimateBonusMap, 
						act_join_num_map 	= _JoinNumMap
					} = Auction,
					case lists:member(AucModuleId, ?WORLD_BONUS_MODULE) andalso (ModuleIdIn == 0 orelse AucModuleId == ModuleIdIn) of 
						true ->
							NewGuildId    = 0,
							IsJoin 		  =	maps:get(PlayerId, JoinLogMap, []),	
							JoinNum       = length(maps:keys(JoinLogMap)), %% 
							EstimateBonus = maps:get(NewGuildId, EstimateBonusMap, 0),	
							{Gold, Bgold} = lib_auction_util:count_award_gold(EstimateBonus, 0, 0),		
							AwardStatus   = maps:get(NewGuildId, GuildAwardMap, 0),	
							?PRINT("get_auction_estimate_bonus_local : ~p~n", [{IsJoin, JoinNum, EstimateBonus, AwardStatus}]),
							case IsJoin=/=[] andalso JoinNum >0 andalso AwardStatus==0 of
								true -> 
									NewGold = round(Gold div JoinNum),
									NewBgold  = round((Bgold / JoinNum) + ((Gold / JoinNum) - NewGold)),
									{NewGold + AccNum, NewBgold + AccNum1};
								false -> {AccNum, AccNum1}
							end;
						_ -> {AccNum, AccNum1}
					end;
				_ ->
					{AccNum, AccNum1}
			end;
		({_AuctionId, _Auction}, {AccNum, AccNum1}) -> {AccNum, AccNum1}
		end, {0, 0}, maps:to_list(AuctionMap)),
	{round(AverageGold), round(AverageBgold)}.

%% 个人拍卖记录
send_player_auction_log(State, {Cmd, PlayerId, Sid}) ->
	#auction_state{player_log_map = PlayerLogMap} = State,
	PlayerAuctionLogList = maps:get(PlayerId, PlayerLogMap, []),
	SendList = [{OpType, ModuleId, PriceType, Gold, BGold, GoodsType, Wlv, Time} ||
		#player_auction_log{op_type = OpType, module_id = ModuleId, price_type = PriceType, gold = Gold, bgold = BGold, 
			goods_type = GoodsType, wlv = Wlv, time = Time} <- PlayerAuctionLogList],
	?PRINT("send_player_auction_log : ~p~n", [SendList]),	
	lib_server_send:send_to_sid(Sid, pt_154, Cmd, [SendList]),
	ok.

send_bonus_log(State, {Cmd, PlayerId, Sid}) ->
	#auction_state{bonus_log_map = BonusLogMap, bonus_map = BonusMap} = State,
	ModuleBonusInfos = maps:get(PlayerId, BonusLogMap, []),
	PlayerBonusInfos = maps:get(PlayerId, BonusMap, []),
	SendList = [{ModuleId, Gold, BGold, Time} ||
		#bonus_log{module_id = ModuleId, gold = Gold, bgold = BGold, time = Time} <- ModuleBonusInfos],
	SendList2 = [{ModuleId, GoldGot, BGoldGot} || 
		#bonus_info{module_id = ModuleId, gold = GoldGot, bgold = BGoldGot} <- PlayerBonusInfos],
	?PRINT("send_bonus_log : ~p~n", [SendList]),	
	?PRINT("send_bonus_log : ~p~n", [SendList2]),	
	lib_server_send:send_to_sid(Sid, pt_154, Cmd, [SendList, SendList2]),
	ok.

%% 个人拍卖记录增加
add_player_auction_log(State, PlayerLogList) ->
	#auction_state{
		player_log_map = PlayerLogMap
	} = State,
	%% 个人拍卖记录
	F = fun(Elem, Map) ->
 		[PlayerId1|_] = Elem,
 		PlayerAuctionLog = lib_auction_data:make(player_auction_log, Elem),
		PlayerAuctionLogList = maps:get(PlayerId1, Map, []),
		maps:put(PlayerId1, [PlayerAuctionLog|PlayerAuctionLogList], Map)
 	end,
 	NewPlayerLogMap = lists:foldl(F, PlayerLogMap, PlayerLogList),
 	spawn(
		fun() -> 
			[lib_auction_data:add_player_auction_log_db(Elem) ||Elem <- PlayerLogList]
		end
	),
	NewState = State#auction_state{player_log_map = NewPlayerLogMap},
	{ok, NewState}.

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

