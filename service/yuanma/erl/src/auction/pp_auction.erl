%% ---------------------------------------------------------------------------
%% @doc 交易
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------
-module (pp_auction).
-export ([handle/3]).
-include("server.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("rec_auction.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("figure.hrl").

%% 获取拍卖菜单
handle(Cmd = 15400, PS, []) ->
	#player_status{id = PlayerId, guild = #status_guild{id = GuildId, realm = Realm}} = PS,
	mod_auction:send_auction_catalog({Cmd, PlayerId, GuildId}),
	?PRINT("15400 realm :~p~n", [Realm]),
	ok;

%% 获取拍卖物品
handle(Cmd = 15401, PS, [AuctionType, Type, ModuleId]) when AuctionType == ?AUCTION_GUILD orelse AuctionType == ?AUCTION_WORLD orelse AuctionType == ?AUCTION_KF_REALM ->
	#player_status{id = PlayerId, sid = Sid, server_id = ServerId, guild = #status_guild{id = GuildId, realm = Realm}} = PS,
	case AuctionType of 
		?AUCTION_KF_REALM ->
			Node = node(),
			mod_kf_auction:cast_kf_auction(send_auction_goods, [{Cmd, PlayerId, Realm, AuctionType, Type, ModuleId, ServerId, Node, Sid}]);
		_ ->
			mod_auction:send_auction_goods({Cmd, PlayerId, GuildId, AuctionType, Type, ModuleId})
	end,
	ok;

%% 竞拍商品
handle(Cmd = 15403, PS, [AuctionType, GoodsId, PriceType, BGold, Gold]) ->
	#player_status{
		id = PlayerId, sid = Sid, server_id = ServerId, guild = #status_guild{id = GuildId}, bgold = BGoldHad,
		figure = #figure{name = Name}} = PS,
	BGoldList = case BGold > 0 of 
		true ->
			?IF(BGold =< BGoldHad, [{?TYPE_BGOLD, 0, BGold}], ?IF(BGoldHad == 0, [{?TYPE_GOLD, 0, BGold}], [{?TYPE_BGOLD, 0, BGoldHad}, {?TYPE_GOLD, 0, BGold - BGoldHad}]));
		_ -> []
	end,
	GoldList = ?IF(Gold>0,  [{?TYPE_GOLD, 0, Gold}], []),
	PriceList  = BGoldList ++ GoldList,
	case lib_auction:pay_auction(PS, {Cmd, AuctionType, PlayerId, ServerId, Name, GuildId, GoodsId, PriceType, PriceList}) of
		{true, NewPS} ->
			lib_server_send:send_to_sid(Sid, pt_154, Cmd, [?SUCCESS, PriceType]),
			{ok, NewPS};
		{false, Res} -> 
			%?ERR_MSG(Cmd, Res),
			lib_server_send:send_to_sid(Sid, pt_154, Cmd, [Res, PriceType]);
		_ -> skip
	end;

%% 我的竞拍
% handle(Cmd = 15405, PS, []) ->
% 	#player_status{id = PlayerId, guild = #status_guild{id = GuildId}} = PS,
% 	mod_auction:send_my_auction({Cmd, PlayerId, GuildId}),
% 	ok;

% %% 拍卖记录
% handle(Cmd = 15406, PS, [AuctionType]) ->
% 	#player_status{id = PlayerId, guild = #status_guild{id = GuildId}} = PS,
% 	mod_auction:send_auction_log({Cmd, PlayerId, GuildId, AuctionType}),
% 	ok;

%% 预计分红
handle(Cmd = 15407, PS, [AuctionType, ModuleId]) ->
	#player_status{id = PlayerId, sid = Sid, server_id = ServerId, guild = #status_guild{id = GuildId, realm = Realm}} = PS,
	Node = node(),
	mod_auction:send_auction_estimate_bonus({Cmd, PlayerId, GuildId, Realm, AuctionType, ModuleId, ServerId, Node, Sid}),
	ok;

%% 个人拍卖记录
handle(Cmd = 15409, PS, []) ->
	#player_status{id = PlayerId, sid = Sid} = PS,
	mod_auction:send_player_auction_log({Cmd, PlayerId, Sid}),
	ok;

%% 分红记录
handle(Cmd = 15410, PS, []) ->
	#player_status{id = PlayerId, sid = Sid} = PS,
	mod_auction:send_bonus_log({Cmd, PlayerId, Sid}),
	ok;

handle(_Cmd, _PS, _Data) ->
    ?PRINT("no match :~p~n", [{_Cmd, _Data}]),
    {error, "pp_auction no match"}.
