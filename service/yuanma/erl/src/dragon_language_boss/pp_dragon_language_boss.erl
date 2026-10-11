%%%-----------------------------------
%%% @Module      : pp_dragon_language_boss
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 26. 九月 2019 10:45
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(pp_dragon_language_boss).
-author("carlos").
-include("server.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("vip.hrl").
-include("dragon_language_boss.hrl").


%% 协议处理入口
handle(Cmd, Status, Args) ->
	#player_status{figure = Figure, id = RoleId} = Status,
	LvLimit = data_dragon_language_boss:get_kv(lv_limit),
	IsGmClose = lib_gm_stop:check_gm_close_act(?MOD_DRAGON_LANGUAGE_BOSS, 0),
	if
		Figure#figure.lv < LvLimit ->
			send_error(RoleId, ?ERRCODE(lv_limit)),
			{ok, Status};
		IsGmClose =/= true ->
			send_error(RoleId, ?ERR_GM_STOP),
			{ok, Status};
		true ->
			case do_handle(Cmd, Status, Args) of
				#player_status{} = NewPS ->
					{ok, NewPS};
				{ok, NewPS} ->
					{ok, NewPS};
				_ ->
					{ok, Status}
			end
	end.

%% 界面信息
do_handle(65101, Status, _Args) ->
	#player_status{vip = Vip, id = RoleId} = Status,
	{AllCount, _, LastCount} = lib_dragon_language_boss_util:get_all_count(RoleId, Vip),
	mod_clusters_node:apply_cast(mod_dragon_language_boss, get_info, [config:get_server_id(), AllCount, LastCount, RoleId]);


%% 进入boss
do_handle(65102, Status, [MapId, MonId, Auto]) ->
	#player_status{vip = Vip, id = RoleId, scene = SceneId} = Status,
	{_, EnterCountYet, LastCount} = lib_dragon_language_boss_util:get_all_count(RoleId, Vip),
	IsInMap = lib_dragon_language_boss_util:is_in_map(MapId, SceneId),
	CheckPlayer = lib_player_check:check_all(Status),
	MapCfg = data_dragon_language_boss:get_map(MapId),
	if
		LastCount =< 0 ->
			send_error(RoleId, ?ERRCODE(err651_not_enough_count));
		IsInMap == true ->
			send_error(RoleId, ?ERRCODE(err651_in_scene));
		CheckPlayer =/= true ->
			{false, Error} = CheckPlayer,
			send_error(RoleId, Error);
		not is_record(MapCfg, base_dragon_language_boss_map) ->
			send_error(RoleId, ?MISSING_CONFIG);
		true ->
			lib_dragon_language_boss:cost_bf_enter(MapCfg, EnterCountYet, Status, MapId, MonId, Auto)
	end;

%% 退出
do_handle(65103, Status, []) ->
	#player_status{id = RoleId, scene = Scene, server_id = ServerId} = Status,
	case data_scene:get(Scene) of
		#ets_scene{type = ?SCENE_TYPE_DRAGON_LANGUAGE_BOSS} ->
			lib_log_api:log_dragon_language_boss(ServerId, RoleId, [], 2),
			mod_clusters_node:apply_cast(mod_dragon_language_boss, quit,
				[ServerId, RoleId]);
		_ ->
			send_error(RoleId, ?ERRCODE(err651_not_in_scene))
	end;

%% vip购买次数
do_handle(65104, Status, [Count]) ->
	#player_status{id = RoleId, vip = Vip} = Status,
	#role_vip{vip_type = VipType, vip_lv = VipLv} = Vip,
	%% vip可以购买次数
	VipCount = lib_vip_api:get_vip_privilege(?MOD_DRAGON_LANGUAGE_BOSS, 1, VipType, VipLv),
	%% vip购买次数
	BuyCount = mod_daily:get_count_offline(RoleId, ?MOD_DRAGON_LANGUAGE_BOSS, 2),
	if
		Count =< 0 ->  %%
			send_error(RoleId, ?ERRCODE(err651_err_buy_count));
		BuyCount + Count > VipCount ->  %%次数已经使用完
			send_error(RoleId, ?ERRCODE(err651_err_buy_count));
		true ->
			CostNum= lib_vip_api:get_vip_privilege(?MOD_DRAGON_LANGUAGE_BOSS, 2, VipType, VipLv),
			Cost = [{?TYPE_BGOLD, 0, CostNum}] ,
			case lib_goods_api:cost_object_list_with_check(Status, Cost, dragon_language_boss_count, "") of
				{true, NewPs} ->
					mod_daily:plus_count_offline(RoleId, ?MOD_DRAGON_LANGUAGE_BOSS, 2, Count),  %% 增加购买次数
					{NewAllCount, _, LastCount} = lib_dragon_language_boss_util:get_all_count(RoleId, Vip),
					{ok, Bin} = pt_651:write(65104, [LastCount, NewAllCount]),
					lib_server_send:send_to_uid(RoleId, Bin),
					NewPs;
				{false, Error, _} ->
					send_error(RoleId, Error)
			end
	end;

%% 剩余时间
do_handle(65105, Status, []) ->
	#player_status{id = RoleId, server_id = ServerId, scene = Scene, scene_pool_id = _PoolId, copy_id = _CopyId} = Status,
	case lib_dragon_language_boss_util:is_in_dragon_language_boss(Scene) of
		true ->
			mod_clusters_node:apply_cast(mod_dragon_language_boss, get_left_time,
				[ServerId, RoleId]);
		_ ->
			send_error(RoleId, ?ERRCODE(err651_not_in_scene))
	end;


%% 掉落记录
do_handle(65106, Status, []) ->
	#player_status{id = RoleId, server_id = ServerId} = Status,
	mod_clusters_node:apply_cast(mod_dragon_language_boss, get_boss_drop_log, [ServerId, RoleId]);

%% 购买时间
do_handle(65107, Status, [MapId, Auto]) ->
	#player_status{vip = Vip, id = RoleId, scene = SceneId} = Status,
	{AllCount, EnterCountYet, LastCount} = lib_dragon_language_boss_util:get_all_count(RoleId, Vip),
	IsInMap = lib_dragon_language_boss_util:is_in_map(MapId, SceneId),
	MapCfg = data_dragon_language_boss:get_map(MapId),
	if
		LastCount =< 0 ->
			send_error(RoleId, ?ERRCODE(err651_not_enough_count));
		IsInMap == false ->
			send_error(RoleId, ?ERRCODE(err651_not_in_scene));
		not is_record(MapCfg, base_dragon_language_boss_map) ->
			send_error(RoleId, ?MISSING_CONFIG);
		true ->
			lib_dragon_language_boss:cost_bf_add_time(MapCfg, EnterCountYet, Status, Auto, AllCount, LastCount)
	end;

do_handle(_Cmd, _Status, _Args) ->
	?ERR("no match:~p", [_Cmd]),
	ok.

send_error(RoleId, Error) ->
	{ok, Bin} = pt_651:write(65100, [Error]),
	lib_server_send:send_to_uid(RoleId, Bin).




















