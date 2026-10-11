%%%-----------------------------------
%%% @Module      : lib_dragon_language_boss
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 26. 九月 2019 15:00
%%% @Description : 
%%%-----------------------------------

-module(lib_dragon_language_boss).
-author("carlos").
-include("vip.hrl").
-include("dragon_language_boss.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_event.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("battle.hrl").
-include("attr.hrl").
-include("rec_event.hrl").
-include("errcode.hrl").

%% API
-compile(export_all).

%% ==================== 事件处理 ===================
handle_event(Player, #event_callback{type_id = ?EVENT_DROP_CHOOSE, data = Data}) when is_record(Player, player_status) ->
	#player_status{id = RoleId, scene = SceneId, figure = #figure{name = Name}, server_id = ServerId, server_num = ServerNum} = Player,
	#{goods := _DropReward, see_reward := SeeRewardList, up_goods_list := UpGoodsList, mon_id := MonId} = Data,
	InBoss = lib_dragon_language_boss_util:is_in_dragon_language_boss(SceneId),
	{IsRare, NewSeeRewardList} = is_rare(SeeRewardList),
	if
		InBoss == true andalso IsRare == true ->
			add_drop_log(ServerId, ServerNum, RoleId, Name, SceneId, MonId, NewSeeRewardList, UpGoodsList);
		true ->
			skip
	end,
	{ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = _Data}) when is_record(Player, player_status) ->
	#player_status{scene = SceneId, player_die = PlayerDieInfo}=Player,
	OldModDieInfo = maps:get(?MOD_DRAGON_LANGUAGE_BOSS, PlayerDieInfo, []),
	case OldModDieInfo of
		[] ->
			OldRef = [],
			ModDieInfo = #mod_player_die{mod = ?MOD_DRAGON_LANGUAGE_BOSS, reborn_ref = undefined};
		_ ->
			#mod_player_die{reborn_ref = OldRef} = OldModDieInfo,
			ModDieInfo = OldModDieInfo
	end,
	case data_scene:get(SceneId) of
		#ets_scene{type = Type} when Type == ?SCENE_TYPE_DRAGON_LANGUAGE_BOSS ->
			Ref = util:send_after(OldRef, ?reborn_time *  1000, self(), {'mod', lib_dragon_language_boss, reborn, []}),
			NewModDieInfo = ModDieInfo#mod_player_die{mod = ?MOD_DRAGON_LANGUAGE_BOSS, reborn_ref = Ref},
			NewPlayerDieInfo = maps:put(?MOD_DRAGON_LANGUAGE_BOSS, NewModDieInfo, PlayerDieInfo),
			{ok, Player#player_status{player_die = NewPlayerDieInfo}};
		_ ->
			{ok, Player}
	end;

handle_event(Player, #event_callback{type_id = ?EVENT_REVIVE, data = _Data}) when is_record(Player, player_status) ->
	#player_status{scene = SceneId, player_die = PlayerDieInfo}=Player,
	OldModDieInfo = maps:get(?MOD_DRAGON_LANGUAGE_BOSS, PlayerDieInfo, []),
	case OldModDieInfo of
		[] ->
			OldRef = [],
			ModDieInfo = #mod_player_die{mod = ?MOD_DRAGON_LANGUAGE_BOSS, reborn_ref = undefined};
		_ ->
			#mod_player_die{reborn_ref = OldRef} = OldModDieInfo,
			ModDieInfo = OldModDieInfo
	end,
	case data_scene:get(SceneId) of
		#ets_scene{type = Type} when Type == ?SCENE_TYPE_DRAGON_LANGUAGE_BOSS ->
			util:cancel_timer(OldRef),
			NewModDieInfo = ModDieInfo#mod_player_die{reborn_ref = []},
			NewPlayerDieInfo = maps:put(?MOD_DRAGON_LANGUAGE_BOSS, NewModDieInfo, PlayerDieInfo),
			{ok, Player#player_status{player_die = NewPlayerDieInfo}};
		_ ->
			{ok, Player}
	end;

handle_event(Player, _EventCallback) ->
	{ok, Player}.

is_rare(SeeRewardList) ->
	RareList = data_dragon_language_boss:get_kv(rare_goods_list),
	F = fun({Type, GoodsTypeId, Num, Id}, {Flag, AccList}) ->
		case lists:member(GoodsTypeId, RareList) of
			true ->
				{true, [{Type, GoodsTypeId, Num, Id} | AccList]};
			_ ->
				{Flag, AccList}
		end
	end,
	lists:foldl(F, {false, []}, SeeRewardList).

add_drop_log(ServerId, ServerNum, RoleId, Name, SceneId, MonId, SeeRewardL, UpGoodsL) ->
	F = fun({_Type, GoodsTypeId, Num, Id}, L) ->
		case lists:keyfind(Id, #goods.id, UpGoodsL) of
			#goods{other = #goods_other{rating = Rating, extra_attr = OExtraAttr}} ->
				ExtraAttr = data_attr:unified_format_extra_attr(OExtraAttr, []);
			_ ->
				Rating = 0, ExtraAttr = []
		end,
		case GoodsTypeId > 0 of
			true -> [{GoodsTypeId, Num, Rating, ExtraAttr} | L];
			false -> L
		end
	end,
	GoodsInfoL = lists:reverse(lists:foldl(F, [], SeeRewardL)),
	mod_clusters_node:apply_cast(mod_dragon_language_boss, add_drop_log,
		[ServerId, ServerNum, RoleId, Name, SceneId, MonId, GoodsInfoL]).

%% 暂时用不到
mon_be_killed(_Atter, Minfo) ->
	#scene_object{scene = SceneId, config_id = MonCfgId, scene_pool_id = PoolId, copy_id = CopyId} = Minfo,
	case lib_dragon_language_boss_util:is_in_dragon_language_boss(SceneId) of
		true ->
			mod_dragon_language_boss:mon_be_killed(PoolId, CopyId, MonCfgId);
		_ ->
			ok
	end.

%% 计算伤害
calc_hurt(Aer, Der, Hurt, MaxHurt) ->
	% 攻击者
	#battle_status{sign = SignA, battle_attr = AerBA} = Aer,
	#battle_attr{attr = AttrA} = AerBA,
	#attr{draconic_sacred = DraconicSacredA, draconic_tspace = DraconicTspaceA, draconic_array = DraconicArrayA} = AttrA,
	% 防守者
	#battle_status{sign = SignD, battle_attr = DerBA, scene = SceneId, id = _Id} = Der,
	#battle_attr{attr = AttrD} = DerBA,
	#attr{draconic_sacred = DraconicSacredADef, draconic_tspace = DraconicTspaceDef, draconic_array = DraconicArrayDef} = AttrD,
	
	IsDragonLanguageBossScene = lib_dragon_language_boss_util:is_in_dragon_language_boss(SceneId),
	DraconicSacredDiff = DraconicSacredA - DraconicSacredADef,
	DraconicTspaceDiff = DraconicTspaceA - DraconicTspaceDef,
	DraconicArrayDiff = DraconicArrayA - DraconicArrayDef,	
	if
		IsDragonLanguageBossScene == false ->
			{Hurt, MaxHurt};
		(SignA == ?BATTLE_SIGN_PLAYER orelse SignA == ?BATTLE_SIGN_PET orelse SignA == ?BATTLE_SIGN_PARTNER
			orelse SignA == ?BATTLE_SIGN_MATE orelse SignA == ?BATTLE_SIGN_COMPANION)
			andalso SignD == ?BATTLE_SIGN_MON ->
			[Ratio1, MaxHurt1] = data_dragon_language_boss:get_battle(?DRACONIC_SACRED, ?BATTLE_SIGN_PLAYER, DraconicSacredDiff),
			[Ratio2, MaxHurt2] = data_dragon_language_boss:get_battle(?DRACONIC_TSPACE, ?BATTLE_SIGN_PLAYER, DraconicTspaceDiff),
			[Ratio3, MaxHurt3] = data_dragon_language_boss:get_battle(?DRACONIC_ARRAY, ?BATTLE_SIGN_PLAYER, DraconicArrayDiff),
			{round(Hurt * lists:min([Ratio1, Ratio2, Ratio3])), round(lists:min([MaxHurt1, MaxHurt2, MaxHurt3]))};
		SignA == ?BATTLE_SIGN_MON andalso SignD == ?BATTLE_SIGN_PLAYER ->
			[Ratio1, MaxHurt1] = data_dragon_language_boss:get_battle(?DRACONIC_SACRED, ?BATTLE_SIGN_MON, DraconicSacredDiff),
			[Ratio2, MaxHurt2] = data_dragon_language_boss:get_battle(?DRACONIC_TSPACE, ?BATTLE_SIGN_MON, DraconicTspaceDiff),
			[Ratio3, MaxHurt3] = data_dragon_language_boss:get_battle(?DRACONIC_ARRAY, ?BATTLE_SIGN_MON, DraconicArrayDiff),
			{round(Hurt * lists:max([Ratio1, Ratio2, Ratio3])), round(lists:max([MaxHurt1, MaxHurt2, MaxHurt3]))};
		true ->
			{Hurt, MaxHurt}
	end.

reborn(PS) ->
	#player_status{battle_attr = BA} = PS,
	#battle_attr{hp = Hp} = BA,
	if
		Hp > 0 ->
			PS;
		true ->
			{_, NewPs} = lib_revive:revive(PS, 3),
			NewPs
	end.

%% 进入消耗
cost_bf_enter(MapCfg, EnterCountYet, Status, MapId, MonId, Auto) ->
	#player_status{id = RoleId, server_id = ServerId, server_num = ServerNum, figure = Figure} = Status,
	#base_dragon_language_boss_map{cost = CostList} = MapCfg,
	case lib_dragon_language_boss_util:get_cost(CostList, EnterCountYet + 1) of
		[{_, _, Num}] = Cost ->
		%% 扣除消耗
		Res =
			if
				Num =< 0 ->  %% 无消耗
					{true, Status};
				Auto == 1 -> %% 可以自动购买
					lib_goods_api:cost_objects_with_auto_buy(Status, Cost, enter_dragon_boss, "");
				true ->
					lib_goods_api:cost_object_list_with_check(Status, Cost, enter_dragon_boss, "")
			end,
		case Res of
			{true, NewPS} ->
				lib_log_api:log_dragon_language_boss(ServerId, RoleId, [], 0),
				LastPs = lib_player:soft_action_lock(NewPS, ?ERRCODE(err651_not_change_scene_on_dragon_boss), 3),
				lib_task_api:enter_dragon_lan(RoleId),
				mod_clusters_node:apply_cast(mod_dragon_language_boss, enter,
					[ServerId, ServerNum, RoleId, Figure#figure.name, MapId, MonId]),
				LastPs;
			{true, NewPS, RealCost} ->
				lib_log_api:log_dragon_language_boss(ServerId, RoleId, RealCost, 0),
				LastPs = lib_player:soft_action_lock(NewPS, ?ERRCODE(err651_not_change_scene_on_dragon_boss), 3),
				lib_task_api:enter_dragon_lan(RoleId),
				mod_clusters_node:apply_cast(mod_dragon_language_boss, enter,
					[ServerId, ServerNum, RoleId, Figure#figure.name, MapId, MonId]),
				LastPs;
			{false, Error, _} ->
				pp_dragon_language_boss:send_error(RoleId, Error)
		end;
		_ ->
			pp_dragon_language_boss:send_error(RoleId, ?MISSING_CONFIG)
	end.

%% 消耗物品增加时间
cost_bf_add_time(MapCfg, EnterCountYet, Ps, Auto, AllCount, LastCount) ->
	#player_status{id = RoleId, server_id = ServerId} = Ps,
	#base_dragon_language_boss_map{cost = CostList, time = AddTime} = MapCfg,
	case lib_dragon_language_boss_util:get_cost(CostList, EnterCountYet + 1) of
		[{_, _, Num}] = Cost ->
			%% 扣除消耗
			Res = if
				Num =< 0 ->  %% 无消耗
					{true, Ps};
				Auto == 1 -> %% 可以自动购买
					lib_goods_api:cost_objects_with_auto_buy(Ps, Cost, enter_dragon_boss, "");
				true ->
					lib_goods_api:cost_object_list_with_check(Ps, Cost, enter_dragon_boss, "")
			end,
			case Res of
				{true, NewPS} ->
					lib_log_api:log_dragon_language_boss(ServerId, RoleId, [], 1),
					mod_daily:increment_offline(RoleId, ?MOD_DRAGON_LANGUAGE_BOSS, 1),
					mod_clusters_node:apply_cast(mod_dragon_language_boss, add_time,
						[ServerId, RoleId, AddTime, AllCount, LastCount - 1, Cost]),
					NewPS;
				{true, NewPS, RealCost} ->
					lib_log_api:log_dragon_language_boss(ServerId, RoleId, RealCost, 1),
					mod_daily:increment_offline(RoleId, ?MOD_DRAGON_LANGUAGE_BOSS, 1),
					mod_clusters_node:apply_cast(mod_dragon_language_boss, add_time,
						[ServerId, RoleId, AddTime, AllCount, LastCount - 1, Cost]),
					NewPS;
				{false, Error, _} ->
					pp_dragon_language_boss:send_error(RoleId, Error)
			end;
		_ ->
			pp_dragon_language_boss:send_error(RoleId, ?MISSING_CONFIG)
	end.

enter_success(RoleId) when is_integer(RoleId) ->
    lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_DRAGON_LANGUAGE_BOSS, 0, 1),
    mod_daily:increment_offline(RoleId, ?MOD_DRAGON_LANGUAGE_BOSS, 1).

%% 特殊情况暂停功能
gm_clear_user(?MOD_DRAGON_LANGUAGE_BOSS, _) ->
	mod_clusters_node:apply_cast(mod_dragon_language_boss, gm_clear_user,
				[config:get_server_id()]);
gm_clear_user(_, _) ->
	skip.