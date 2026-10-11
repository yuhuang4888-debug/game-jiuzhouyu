%%%-----------------------------------
%%% @Module      : mod_kf_seacraft_daily
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 19. 一月 2020 17:14
%%% @Description : 海战日常
%%%-----------------------------------


%% API
-compile(export_all).

-module(mod_kf_seacraft_daily).
-author("carlos").
-include("common.hrl").
-include("seacraft_daily.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("scene.hrl").


-define(MOD_STATE, sea_craft_daily_state).

%% API
-export([]).




start_link() ->
	gen_server:start_link({local, mod_kf_seacraft_daily}, mod_kf_seacraft_daily, [], []).


init([]) ->
	State = lib_kf_seacraft_daily_mod:init(),
	{ok, State}.

kill_mon(SceneId, Atter, Klist, Minfo) ->
	gen_server:cast(?MODULE, {kill_mon, SceneId, Atter, Klist, Minfo}).

gm_restart_ref() ->
	gen_server:cast(?MODULE, {gm_restart_ref}).



player_be_kill(CarryStatus, RoomId, DefServerId, DefServerNum, DefRoleId, DefSeaId, Node, AtterId) ->
%%	lib_player:apply_cast(AtterId, ?APPLY_CAST_SAVE, lib_seacraft_daily, player_be_kill, [RoomId]),
	mod_clusters_center:apply_cast(Node, lib_player, apply_cast,
		[AtterId, ?APPLY_CAST_SAVE, lib_seacraft_daily, player_be_kill, [CarryStatus, RoomId, DefServerId, DefServerNum, DefRoleId, DefSeaId]]).


%%  4点的时候重新计算 结算
day_trigger() ->
	gen_server:cast(?MODULE, {day_trigger}).

get_exp_attr(ServerId, RoleId, SeaId) ->
	gen_server:cast(?MODULE, {get_exp_attr, ServerId, RoleId, SeaId}).

start_carry_brick(ServerId, RoleId, SeaId, BrickColor) ->
	gen_server:cast(?MODULE, {start_carry_brick,ServerId, RoleId, SeaId, BrickColor}).



get_info(ServerId, RoleId, BrickColor) ->
	gen_server:cast(?MODULE, {get_info, ServerId, RoleId, BrickColor}).


enter_daily(ServerId, ServerNum, RoleId, RoleName, SeaId, JobId, BrickColor, EnterSeaId, Power) ->
	gen_server:cast(?MODULE, {enter_daily, ServerId, ServerNum, RoleId, RoleName, SeaId, JobId, BrickColor, EnterSeaId, Power}).

get_scene_msg(ServerId, RoleId, SeaId, CarryCount, DefendCount) ->
	gen_server:cast(?MODULE, {get_scene_msg, ServerId, RoleId, SeaId, CarryCount, DefendCount}).


get_daily_rank(SeaId, ServerId, RoleId, RoleName, JobId, Power) ->
	gen_server:cast(?MODULE, {get_daily_rank, SeaId, ServerId, RoleId, RoleName, JobId, Power}).

get_sea_daily_all_rank(SeaId, ServerId, RoleId, RoleName, JobId, Power) ->
	gen_server:cast(?MODULE, {get_sea_daily_all_rank, SeaId, ServerId, RoleId, RoleName, JobId, Power}).



end_carry_brick(ServerId, RoleId, SeaId, MySeaId) ->
	gen_server:cast(?MODULE, {end_carry_brick, ServerId, RoleId, SeaId, MySeaId}).


quit_sea(ServerId, RoleId, SeaId) ->
	gen_server:cast(?MODULE, {quit_sea, ServerId, RoleId, SeaId}).

finish_carry(ServerId, RoleId, SeaId, MySeaId) ->
	gen_server:cast(?MODULE, {finish_carry, ServerId, RoleId, SeaId, MySeaId}).

boss_reborn() ->
	gen_server:cast(?MODULE, {boss_reborn}).

zone_change(ServerId, OldZone, NewZone) ->
	gen_server:cast(?MODULE, {zone_change, ServerId, OldZone, NewZone}).


gm_add_sea_brick(ServerId, SeaId, Num) ->
	gen_server:cast(?MODULE, {gm_add_sea_brick, ServerId, SeaId, Num}).


zone_reset_start() ->
	gen_server:cast(?MODULE, {zone_reset_start}).

end_recalc_all_zone() ->
	gen_server:cast(?MODULE, {end_recalc_all_zone}).


%%设置状态
set_status(Status) ->
	gen_server:cast(?MODULE, {set_status, Status}).

%%设置状态
boss_reborn(BossType, ZoneId, SeaId) ->
	gen_server:cast(?MODULE, {boss_reborn, BossType, ZoneId, SeaId}).




hurt_mon(Minfo, Atter) ->
	#scene_object{scene = Scene, scene_pool_id = Pool} = Minfo,
	case lib_seacraft_daily:is_scene(Scene) of
		true ->
			gen_server:cast(?MODULE, {hurt_mon, Minfo, Atter, Pool});
		_ ->
			skip
	end.




handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		ok -> {noreply, State};
		{ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		Reason ->
			?ERR("~p cast error: ~p, Reason:=~p~n", [?MODULE, Msg, Reason]),
			{noreply, State}
	end.



handle_info(Info, State) ->
	case catch do_handle_info(Info, State) of
		ok -> {noreply, State};
		{ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		{noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
		Reason ->
			?ERR("~p info error: ~p, Reason:=~p~n", [?MODULE, Info, Reason]),
			{noreply, State}
	end.

do_handle_cast({gm_restart_ref}, _State) ->
	#sea_craft_daily_state{ref = OldRef} = _State,
	Ref = lib_kf_seacraft_daily_mod:calc_ref(OldRef),
	State = _State#sea_craft_daily_state{ref = Ref},
	{noreply, State};


do_handle_cast({end_recalc_all_zone}, State) ->
	NewState = lib_kf_seacraft_daily_mod:end_recalc_all_zone(State),
	{noreply, NewState};



do_handle_cast({zone_reset_start}, State) ->
	NewState = lib_kf_seacraft_daily_mod:zone_reset_start(State),
%%	?MYLOG("cym", "NewState ~p~n", [State]),
	{noreply, NewState};


do_handle_cast({gm_add_sea_brick, ServerId, SeaId, Num}, State) ->
	NewState = lib_kf_seacraft_daily_mod:gm_add_sea_brick(ServerId, SeaId, Num, State),
	{noreply, NewState};


do_handle_cast({zone_change, ServerId, OldZone, NewZone}, State) ->
	NewState = lib_kf_seacraft_daily_mod:zone_change(ServerId, OldZone, NewZone, State),
	{noreply, NewState};



do_handle_cast({hurt_mon, Minfo, Atter, ZoneId}, State) ->
	NewState = lib_kf_seacraft_daily_mod:hurt_mon(Minfo, Atter, ZoneId, State),
	{noreply, NewState};




do_handle_cast({day_trigger}, State) ->
	NewState = lib_kf_seacraft_daily_mod:day_trigger(State),
	{noreply, NewState};



do_handle_cast({boss_reborn}, State) ->
%%	NewState = lib_kf_seacraft_daily_mod:boss_reborn(State),
	%% 如果是12点则重置 砖块数量
	LastState= lib_kf_seacraft_daily_mod:handle_reset_brick_num(State),
	{noreply, LastState};

do_handle_cast({start_carry_brick,ServerId, RoleId, SeaId, BrickColor}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	NewState = lib_kf_seacraft_daily_mod:start_carry_brick(ZoneId, ServerId, RoleId, SeaId, BrickColor, State),
	{noreply, NewState};

do_handle_cast({get_exp_attr, ServerId, RoleId, SeaId}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	lib_kf_seacraft_daily_mod:get_exp_attr(ZoneId,  ServerId, RoleId, SeaId, State),
	{noreply, State};

do_handle_cast({finish_carry, ServerId, RoleId, SeaId, MySeaId}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	NewState = lib_kf_seacraft_daily_mod:finish_carry(ZoneId, SeaId, MySeaId, ServerId, RoleId, State),
	{noreply, NewState};


do_handle_cast({quit_sea, ServerId, RoleId, SeaId}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	NewState = lib_kf_seacraft_daily_mod:quit_sea(ZoneId, SeaId, ServerId, RoleId, State),
	{noreply, NewState};



do_handle_cast({end_carry_brick, ServerId, RoleId, SeaId, MySeaId}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	NewState = lib_kf_seacraft_daily_mod:end_carry_brick(ZoneId, SeaId, MySeaId, ServerId, RoleId, State),
	{noreply, NewState};


do_handle_cast({get_sea_daily_all_rank, SeaId, ServerId, RoleId, RoleName, JobId, Power}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	lib_kf_seacraft_daily_mod:get_sea_daily_all_rank(ZoneId, SeaId, ServerId, RoleId, RoleName, JobId, Power, State),
	{noreply, State};


do_handle_cast({get_daily_rank, SeaId, ServerId, RoleId, RoleName, JobId, Power}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	lib_kf_seacraft_daily_mod:get_daily_rank(ZoneId, SeaId, ServerId, RoleId, RoleName, JobId, Power, State),
	{noreply, State};

do_handle_cast({get_scene_msg, ServerId, RoleId, SeaId, CarryCount, DefendCount}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	lib_kf_seacraft_daily_mod:get_scene_msg(ZoneId, ServerId, RoleId, SeaId, CarryCount, DefendCount, State),
	{noreply, State};

do_handle_cast({enter_daily, ServerId, ServerNum, RoleId, RoleName, SeaId, JobId, BrickColor, EnterSeaId, Power}, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	RoleMsg = #role_msg{
		zone_id = ZoneId,
		server_id = ServerId,
		server_num = ServerNum,
		role_id = RoleId,
		role_name = RoleName,
		sea_id = SeaId,
		job_id = JobId,
		brick_color = BrickColor
		,power = Power
	},
	NewState = lib_kf_seacraft_daily_mod:enter_daily(RoleMsg, EnterSeaId, State),
	{noreply, NewState};

do_handle_cast({get_info, ServerId, RoleId, BrickColor}, State) ->
	lib_kf_seacraft_daily_mod:get_info(ServerId, RoleId, BrickColor, State),
	{noreply, State};



do_handle_cast({kill_mon, SceneId, Atter, Klist, Minfo}, State) ->
%%	?MYLOG("mon", "Atter  ~p  Klist~p ~n", [Atter, Klist]),
	NewState = lib_kf_seacraft_daily_mod:kill_mon(SceneId, Atter, Klist, Minfo, State),
	{noreply, NewState};


do_handle_cast({set_status, Status}, State) ->
%%	?PRINT("+++++++++++++ ~p~n", [Status]),
	{noreply, State#sea_craft_daily_state{status = Status}};


do_handle_cast({boss_reborn, BossType, ZoneId, SeaId}, State) ->
	?PRINT("+++++++++++++ ~p~n", [{BossType, ZoneId, SeaId}]),
	LastState= lib_kf_seacraft_daily_mod:boss_reborn(BossType, ZoneId, SeaId, State),
	{noreply, LastState};

do_handle_cast(_Request, State) ->
	{noreply, State}.

do_handle_info({BossType, ZoneId, SeaId}, State) ->
    LastState= lib_kf_seacraft_daily_mod:boss_reborn(BossType, ZoneId, SeaId, State),
    {noreply, LastState};

do_handle_info({boss_reborn}, State) ->
%%	NewState = lib_kf_seacraft_daily_mod:boss_reborn(State),
	%% 如果是12点则重置 砖块数量
	LastState= lib_kf_seacraft_daily_mod:handle_reset_brick_num(State),
	{noreply, LastState};






do_handle_info(_Request, State) ->
	{noreply, State}.



