%% ---------------------------------------------------------------------------
%% @doc 拍卖行
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------

-module (lib_auction_api).
-include ("common.hrl").
-include ("rec_auction.hrl").
-include ("server.hrl").
-include ("def_id_create.hrl").
-include ("def_timer_quest.hrl").

-export ([
	start_guild_auction/2, 
	start_guild_auction/3, 
	start_guild_auction/4,
	start_guild_auction_with_bonus_players/3,
	start_guild_auction_with_bonus_players/4,
	start_world_auction/3, 
	start_world_auction/4, 
	start_world_auction_with_bonus_players/3,
	start_world_auction_with_bonus_players/4,
	start_kf_realm_auction/5,
	start_guild_auction_gm/3,
	gm_start_realm_auction/5]).
-export ([quit_guild/1, trans_to_goods_list/1]).

%% ---------------------------------------------------------------------------
%% @doc 开启公会拍卖
-spec start_guild_auction(ModuleId, GuildGoodsList) -> Res when
	ModuleId  		:: integer(), 				%% 功能id
	GuildGoodsList	:: [{GuildId, ObjectList}],	%% 公会物品列表
	GuildId 		:: integer(), 				%% 公会id
	ObjectList 		:: [{Type::integer(), GoodsId::integer(), Num::integer()}],
	Res 			:: ok.
%% ---------------------------------------------------------------------------
%% 不带AuthenticationId的接口：
%% 由mod_act_join进程获取某个时间段参与该功能的玩家列表(只能获取某个时间段的玩家)
start_guild_auction(ModuleId, GuildGoodsList) ->	
	mod_auction:start_guild_auction({ModuleId, GuildGoodsList}),
	ok.

%% 带AuthenticationId的接口：建议使用，使用步骤
%%     1.AuthenticationId是功能内部，通过调用 mod_id_create:get_new_id(?AUTHENTICATION_ID_CREATE) 得到认证id
%%     2.功能内部自己统计哪些玩家参与这个场次的拍卖, 然后调用 lib_act_join_api:add_authentication_player接口，将参与这次拍卖的玩家与AuthenticationId对应起来
%%     3.调用start_guild_auction开启这次拍卖
start_guild_auction(ModuleId, AuthenticationId, GuildGoodsList) ->	
	mod_auction:start_guild_auction({ModuleId, AuthenticationId, GuildGoodsList}),
	ok.

%% 公会拍卖，由功能带入开始拍卖时间
start_guild_auction(ModuleId, AuthenticationId, StartTime, GuildGoodsList) ->	
	mod_auction:start_guild_auction({ModuleId, AuthenticationId, StartTime, GuildGoodsList}),
	ok.

%% 建议使用：公会拍卖，带分红人员列表(封装 start_guild_auction(ModuleId, AuthenticationId, GuildGoodsList) 函数而已)
%%      ModuleId: 拍卖模块id, 见 auction_module.hrl 
%%      GuildGoodsList: 拍卖品 [{GuildId, ObjectList}], ObjectList: [{拍品id,数量}|{拍品id,数量,世界等级}]
%%      BonusPlayerList：分红者 [{PlayerId, GuildId}]
start_guild_auction_with_bonus_players(ModuleId, GuildGoodsList, BonusPlayerList) -> 
	start_guild_auction_with_bonus_players(ModuleId, 0, GuildGoodsList, BonusPlayerList).

%% StartTime: 开拍时间, 0：用配置值
start_guild_auction_with_bonus_players(ModuleId, StartTime, GuildGoodsList, BonusPlayerList) ->
	AuthenticationId = mod_id_create:get_new_id(?AUTHENTICATION_ID_CREATE),
    InAuctionPlayerList = [{AuthenticationId, PlayerId, GuildId, ModuleId}||{PlayerId, GuildId} <- BonusPlayerList],
    lib_act_join_api:add_authentication_player(InAuctionPlayerList),
    start_guild_auction(ModuleId, AuthenticationId, StartTime, GuildGoodsList).

%% ---------------------------------------------------------------------------
%% @doc 开启世界拍卖拍卖
%% GoodsList: [{拍品id,数量,世界等级}|{拍品id,数量}]
%% AuthenticationId同上
start_world_auction(ModuleId, AuthenticationId, GoodsList) ->	
	mod_auction:start_world_auction({ModuleId, AuthenticationId, GoodsList}),
	ok.

%% 世界拍卖，由功能带入开始拍卖时间
start_world_auction(ModuleId, AuthenticationId, StartTime, GoodsList) ->	
	mod_auction:start_world_auction({ModuleId, AuthenticationId, StartTime, GoodsList}),
	ok.

%% 建议使用：世界拍卖，带分红人员列表
%%      ModuleId: 拍卖模块id, 见 auction_module.hrl 
%%      GoodsList: [{拍品id,数量}|{拍品id,数量,世界等级}]
%%      BonusPlayerList：分红者 [PlayerId]，世界拍卖不需要公会id，默认公会id是0
start_world_auction_with_bonus_players(ModuleId, GoodsList, BonusPlayerList) ->
	start_world_auction_with_bonus_players(ModuleId, 0, GoodsList, BonusPlayerList).

start_world_auction_with_bonus_players(ModuleId, StartTime, GoodsList, BonusPlayerList) ->
	AuthenticationId = mod_id_create:get_new_id(?AUTHENTICATION_ID_CREATE),
	InAuctionPlayerList = [{AuthenticationId, PlayerId, 0, ModuleId}||PlayerId <- BonusPlayerList],
	lib_act_join_api:add_authentication_player(InAuctionPlayerList),
	start_world_auction(ModuleId, AuthenticationId, StartTime, GoodsList).

%% ------------------------------------------------------------------------------
%% 开启跨服阵营拍卖
%% GuildGoodsList: [{阵营,[{GoodsType(拍品id), Num, Wlv}]}]
%% BonusPlayerList: [{PlayerId, GuildId(阵营), ServerId}]
start_kf_realm_auction(ZoneId, ModuleId, StartTime, GuildGoodsList, BonusPlayerList) ->
	mod_kf_auction:start_kf_realm_auction({ZoneId, ModuleId, StartTime, GuildGoodsList, BonusPlayerList}).

%% ---------------------------------------------------------------------------
%% @doc 开启公会拍卖（GM使用）
%% ---------------------------------------------------------------------------
start_guild_auction_gm(Time, ModuleId, GuildGoodsList) ->
	Duration = Time - utime:unixtime(),
	do_start_guild_auction_gm(Duration, ModuleId, GuildGoodsList).

do_start_guild_auction_gm(Duration, ModuleId, GuildGoodsList) when Duration> 0 ->
	QuestArgs = {lib_auction_api, start_guild_auction, [ModuleId, GuildGoodsList]},
	timer_quest:delete(?UTIMER_ID(?TIMER_AUCTION_GM, ModuleId)),
	timer_quest:add(?UTIMER_ID(?TIMER_AUCTION_GM, ModuleId), Duration, 0, QuestArgs),
	ok;
do_start_guild_auction_gm(Duration, ModuleId, GuildGoodsList) ->
	?ERR("start_guild_auction_gm error duration:~p~n", [{Duration, ModuleId, GuildGoodsList}]),
	error.

gm_start_realm_auction(PlayerId, ServerId, Realm, ModuleId, GoodsList) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	start_kf_realm_auction(ZoneId, ModuleId, 0, [{Realm, GoodsList}], [{PlayerId, Realm, ServerId}]).

%% ---------------------------------------------------------------------------
%% @doc 退出公会，清除活动参与记录
%% ---------------------------------------------------------------------------
quit_guild(PlayerId) ->
	mod_auction:quit_guild({PlayerId}),
	mod_kf_auction:cast_kf_auction(quit_guild, [{PlayerId}]),
	ok.

%% ---------------------------------------------------------------------------
%% @doc 拍品列表转换为物品列表
%% ---------------------------------------------------------------------------
trans_to_goods_list(GoodsList) ->
	Wlv = util:get_world_lv(),
	[{_, NewGoodsList}] = lib_auction_mod:trans_to_wlv_auction_goods([{0, GoodsList}], Wlv),
	lib_auction_mod:trans_to_goods_list(NewGoodsList).