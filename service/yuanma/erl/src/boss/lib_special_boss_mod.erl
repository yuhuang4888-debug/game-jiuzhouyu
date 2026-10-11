-module(lib_special_boss_mod).

-include("boss.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("rec_event.hrl").
-include("scene.hrl").

-export([
        enter/6,
        boss_init/4
        ,boss_reborn/4
        ,boss_remind/4
        ,exit/6
        ,boss_remind_op/5
        ,boss_be_kill/11
        ,boss_data_remove/4
        ,get_boss_info/14
        ,boss_reborn_on_scene/4
        ,refresh_boss/4
        ,refresh_boss_one/6
        ,reconnect/5
        ,lv_up/3
        ,get_boss_by_rolelv/2
        ,gm_refresh_boss/3
    ]).

get_all_boss(BossType) -> %% 获取该类型的所有boss
	SceneList =case data_boss:get_boss_type_scene(BossType) of
		List when is_list(List) ->List;
		_ -> []
	end,
	Fun = fun(Scene, Acc) ->
		case data_boss:get_boss_by_scene(BossType, Scene) of
			[{_BossId, Layer}|_] = T -> [{Layer, T}|Acc];
			_ -> Acc
		end
	end,
	lists:foldl(Fun, [], SceneList).

get_same_layer_boss(BossType, BossId) -> %% 依据bossid获取同一层所有boss
	AllBoss = get_all_boss(BossType),
	Fun = fun({Layer, T}, Acc) ->
		case lists:keyfind(BossId, 1, T) of
			{BossId, _} -> Layer;
			_ -> Acc
		end
	end,
	RLayer = lists:foldl(Fun, 0, AllBoss),
	case data_boss:get_boss_same_layers(BossType, RLayer) of
		BossIds when is_list(BossIds) -> BossIds;
		_ -> []
	end.

get_same_scene_boss(BossType, Scene) ->
	case data_boss:get_boss_by_scene(BossType, Scene) of
		BossIds when is_list(BossIds) -> BossIds;
		_ -> BossIds = []
	end,
	Fun = fun({BossId, _Layer}, Acc) ->
		[BossId|Acc]
	end,
	lists:foldl(Fun, [], BossIds).

get_boss_by_rolelv(BossType, RoleLv) -> %% 获取所有等级小于等于玩家等级的bossid
	AllBoss = get_all_boss(BossType),
	Fun = fun({Layer, [{BossId,_}|_]}, Acc) ->
		case data_boss:get_boss_cfg(BossId) of
			#boss_cfg{condition = Condition} ->
				case lists:keyfind(lv, 1, Condition) of
					{lv, LvLimit} when RoleLv >= LvLimit -> [Layer|Acc];
					_ -> Acc
				end;
			_ -> Acc
		end
	end,
	RLayers = lists:foldl(Fun, [], AllBoss),
	F = fun(Layer, Acc) ->
		case data_boss:get_boss_same_layers(BossType, Layer) of
			BossIds when is_list(BossIds) -> BossIds ++ [];
			_ -> Acc
		end
	end,
	lists:foldl(F, [], RLayers).

%% 生成怪物
create_special_boss_1(RoleId, RoleLv, BossType, Scene, BossMap, OnlineNumMap) ->
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] ->
			AllBossIds = get_boss_by_rolelv(BossType, RoleLv),
			SpecialBossMap = init_boss_map(AllBossIds, RoleId, BossType, OnlineNumMap);
		SpecialBossMap ->
			BossIds = get_same_scene_boss(BossType, Scene),
			% 先清怪物
			lib_mon:clear_scene_mon_by_mids(Scene, 0, RoleId, 1, BossIds),
			Fun = fun
				(TemBossId) when BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER; TemBossId == 3400001 ->
					case maps:get(TemBossId, SpecialBossMap, []) of
						#special_boss{reborn_time = RebornTime} when RebornTime == 0 ->
							BossCfg = data_boss:get_boss_cfg(TemBossId),
							case BossCfg of
								#boss_cfg{scene = Scene, x = X, y = Y} ->
									% %% 先清怪物
									% lib_mon:clear_scene_mon_by_mids(Scene, 0, RoleId, 1, [TemBossId]),
									lib_scene_object:async_create_object(?BATTLE_SIGN_MON, TemBossId, Scene, 0, X, Y, 1, RoleId, 1, []);
								_ -> ?ERR("error cfg BossType:~p,BossId:~p~n",[BossType, TemBossId]), skip
							end;
						_ ->
							skip
					end;
				(_) -> skip
			end,
			lists:foreach(Fun, BossIds)
	end,
	maps:put({BossType, RoleId}, SpecialBossMap, BossMap).

%% 生成怪物
create_special_boss(RoleId, RoleLv, BossType, BossId, BossMap, OnlineNumMap) ->
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] ->
			AllBossIds = get_boss_by_rolelv(BossType, RoleLv),
			SpecialBossMap = init_boss_map(AllBossIds, RoleId, BossType, OnlineNumMap);
		SpecialBossMap ->
			BossIds = get_same_layer_boss(BossType, BossId),
			Fun = fun
				(TemBossId) when BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER; TemBossId == 3400001 ->
					case maps:get(TemBossId, SpecialBossMap, []) of
						#special_boss{reborn_time = RebornTime} when RebornTime == 0 ->
							BossCfg = data_boss:get_boss_cfg(TemBossId),
							case BossCfg of
								#boss_cfg{scene = Scene, x = X, y = Y} ->
									%% 先清怪物
									lib_mon:clear_scene_mon_by_mids(Scene, 0, RoleId, 1, [TemBossId]),
									lib_scene_object:async_create_object(?BATTLE_SIGN_MON, TemBossId, Scene, 0, X, Y, 1, RoleId, 1, []);
								_ -> ?ERR("error cfg BossType:~p,BossId:~p~n",[BossType, TemBossId]), skip
							end;
						_ ->
							skip
					end;
				(_) -> skip
			end,
			lists:foreach(Fun, BossIds)
	end,
	maps:put({BossType, RoleId}, SpecialBossMap, BossMap).

%% 更新state
update_state_state(RoleId, SpecialBoss, BossType, BossId, State) ->
	#special_boss_state{boss_map = BossMap} = State,
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] -> State;
		SpecialBossMap ->
			NewSpecialBossMap = maps:put(BossId, SpecialBoss, SpecialBossMap),
			NewBossMap = maps:put({BossType, RoleId}, NewSpecialBossMap, BossMap),
			State#special_boss_state{boss_map = NewBossMap}
	end.

%% 获取信息
get_special_boss_info(State, RoleId, BossType, BossId) ->
	#special_boss_state{boss_map = BossMap} = State,
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] -> {false, 0};
		SpecialBossMap ->
			case maps:get(BossId, SpecialBossMap, []) of
				#special_boss{} = OldSpecialBoss ->
					{ok, BossMap, SpecialBossMap, OldSpecialBoss};
				_ ->
					{false, 0}
			end
	end.

%% 计算怪物提醒定时器
calc_boss_remind_ref(_RoleId, _BossType, #special_boss{reborn_time = 0, remind_ref = OldRef} = Boss) ->
    util:cancel_timer(OldRef),
    Boss#special_boss{remind_ref = undefined};
calc_boss_remind_ref(RoleId, BossType, Boss) ->
    #special_boss{boss_id = BossId, reborn_time = RebornTime, remind_ref = OldRef} = Boss,
    RebornSpanTime = RebornTime - utime:unixtime(),
    util:cancel_timer(OldRef),
    RemindTime = lib_boss_mod:calc_remind_time(BossType, RebornSpanTime),
    RemindRef = ?IF(RemindTime == undefined, undefined,
        util:send_after(OldRef, RemindTime * 1000, self(), {'boss_remind', RoleId, BossType, BossId})),
    Boss#special_boss{remind_ref = RemindRef}.

%% 计算怪物重生定时器
calc_boss_reborn_ref(_RoleId, _BossType, #special_boss{reborn_time = 0, reborn_ref = OldRef} = Boss) ->
    util:cancel_timer(OldRef),
    Boss#special_boss{reborn_ref = undefined};
calc_boss_reborn_ref(RoleId, BossType, Boss) ->
    #special_boss{boss_id = BossId, reborn_time = RebornTime, reborn_ref = OldRef} = Boss,
    RebornSpanTime = max(1, RebornTime - utime:unixtime()),
    RebornRef = util:send_after(OldRef, RebornSpanTime * 1000, self(), {'boss_reborn', RoleId, BossType, BossId}),
    Boss#special_boss{reborn_ref = RebornRef}.

%% 计算怪物重生定时器
calc_boss_reborn_ref(enter, _RoleId, _BossType, #special_boss{reborn_time = 0, reborn_ref = OldRef} = Boss) ->
    util:cancel_timer(OldRef),
    Boss#special_boss{reborn_ref = undefined};
calc_boss_reborn_ref(enter, RoleId, BossType, Boss) ->
    #special_boss{boss_id = BossId, reborn_time = RebornTime, reborn_ref = OldRef} = Boss,
    RebornSpanTime = max(0, RebornTime - utime:unixtime()),
    RebornRef = util:send_after(OldRef, RebornSpanTime * 1000, self(), {'boss_reborn_on_scene', RoleId, BossType, BossId}),
    Boss#special_boss{reborn_ref = RebornRef}.

refresh_boss(State, BossType, RoleId, Scene) ->
	BossIds = data_boss:get_boss_by_type(BossType),
	Fun = fun(BossId, TemState) -> refresh_boss_one(TemState, BossType, BossId, RoleId, Scene, false) end,
	RealState = lists:foldl(Fun, State, BossIds),
	db:execute(io_lib:format(?sql_special_boss_truncate, [])),
	RealState.

refresh_boss_one(State, BossType, BossId, RoleId, Scene, IsDel) ->
	case get_special_boss_info(State, RoleId, BossType, BossId) of
		{false, _ErrCode} -> State;
		{ok, _TBossMap, _SpecialBossMap, #special_boss{reborn_ref = RebornRef, remind_ref = RemindRef, remind = Remind} = OldSpecialBoss} ->
			util:cancel_timer(RebornRef),
			util:cancel_timer(RemindRef),
			BossCfg = data_boss:get_boss_cfg(BossId),
			case BossCfg of
				#boss_cfg{scene = SceneCfg, x = X, y = Y} when Scene == SceneCfg ->
					if
						Remind == 1 ->
							lib_server_send:send_to_uid(RoleId, pt_460, 46016, [BossType, BossId]);
						true ->
							skip
					end,
					%% 先清怪物
					lib_mon:clear_scene_mon_by_mids(Scene, 0, RoleId, 1, [BossId]),
					lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, RoleId, 1, []);
				_ ->
					skip
			end,
			SpecialBoss = OldSpecialBoss#special_boss{reborn_time = 0, reborn_ref = undefined},
			IsDel andalso db:execute(io_lib:format(?sql_special_boss_delete, [BossId, BossType, BossId])),
			update_state_state(RoleId, SpecialBoss, BossType, BossId, State)
	end.

enter(RoleId, RoleLv, BossType, BossId, NeedOut, State) ->
	#special_boss_state{boss_map = BossMap, other_map = OtherMap, online_num_map = OnlineNumMap} = State,
	NowTime = utime:unixtime(),
	BossCfg = data_boss:get_boss_cfg(BossId),
	case BossCfg of
		#boss_cfg{scene = Scene} ->
			NewOtherMap = maps:put({enter_time, BossType, Scene, RoleId}, NowTime, OtherMap),
			NewBossMap = create_special_boss(RoleId, RoleLv, BossType, BossId, BossMap, OnlineNumMap),
			NewState = change_reborn_ref(enter, RoleId, BossType, State),
			lib_scene:player_change_scene(RoleId, Scene, 0, RoleId, NeedOut, [{group, 0}]);
		_ ->
			NewOtherMap = OtherMap, NewState = State, NewBossMap = BossMap,
			?ERR("error cfg BossType:~p,BossId:~p~n",[BossType, BossId]), skip
	end,
	NewState#special_boss_state{other_map = NewOtherMap, boss_map = NewBossMap}.

reconnect(RoleId, RoleLv, Scene, BossType, State) ->
	#special_boss_state{boss_map = BossMap, other_map = OtherMap, online_num_map = OnlineNumMap} = State,
	NewBossMap = create_special_boss_1(RoleId, RoleLv, BossType, Scene, BossMap, OnlineNumMap),
	NewState = change_reborn_ref(enter, RoleId, BossType, State),
	NowTime = utime:unixtime(),
	NewOtherMap = maps:put({enter_time, BossType, Scene, RoleId}, NowTime, OtherMap),
	% lib_scene:player_change_scene(RoleId, Scene, 0, RoleId, true, [{group, 0},{change_scene_hp_lim, 100},{ghost, 0}]),
	NewState#special_boss_state{other_map = NewOtherMap, boss_map = NewBossMap}.

exit(RoleId, BossType, Scene, OldX, OldY, State) when BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
	#special_boss_state{other_map = OtherMap} = State,
	NowTime = utime:unixtime(),
	StayTime = case maps:get({enter_time, BossType, Scene, RoleId}, OtherMap, false) of
                   EnterTime when is_integer(EnterTime) andalso EnterTime > 0 -> NowTime - EnterTime;
                   _ErrCode -> ?ERR("_ErrCode:~p ,in boss_state other_map~n", [_ErrCode]), 0
               end,
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_boss, add_exit_log, [BossType, 1, Scene, OldX, OldY, StayTime]),
	lib_scene:clear_scene_room(Scene, 0, RoleId),
	NewState = change_reborn_ref(exit, RoleId, BossType, State),
	NewState;

exit(_,_,_,_, _,State) -> State.

boss_data_remove(RoleId, RoleLv, BossType, State) ->
	#special_boss_state{boss_map = BossMap} = State,
	AllBossIds = get_boss_by_rolelv(BossType, RoleLv),
	Fun = fun(BossId) ->
		case get_special_boss_info(State, RoleId, BossType, BossId) of
			{false, _ErrCode} -> skip;
			{ok, _TBossMap, _SpecialBossMap, #special_boss{reborn_ref = RebornRef, remind_ref = RemindRef} = _OldSpecialBoss} ->
				util:cancel_timer(RebornRef),
				util:cancel_timer(RemindRef)
		end
	end,
	lists:foreach(Fun, AllBossIds),
	% lib_scene:player_change_scene(RoleId, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 1}]),
	NewBossMap = maps:remove({BossType, RoleId}, BossMap),
	State#special_boss_state{boss_map = NewBossMap}.

boss_init(RoleId, RoleLv, BossType, State) ->
	AllBossId = lists:sort(data_boss:get_boss_by_type(BossType)),
	AllBossIds = get_boss_by_rolelv(BossType, RoleLv),
	SortID = lists:sort(AllBossIds),
	#special_boss_state{boss_map = BossMap, online_num_map = OnlineNumMap} = State,
	Mapget = maps:get({BossType, RoleId}, BossMap, #{}),
	case AllBossIds =/= [] andalso (SortID =/= AllBossId orelse Mapget == #{}) of
		true ->
			RealSpecialBossMap = init_boss_map(AllBossIds, RoleId, BossType, OnlineNumMap),
			NewBossMap = maps:put({BossType, RoleId}, RealSpecialBossMap, BossMap);
		_ ->
			NewBossMap = BossMap
	end,
	State#special_boss_state{boss_map = NewBossMap}.

%% 玩家在场景怪物复活需要生成怪物
boss_reborn_on_scene(RoleId, BossType, BossId, State) ->
	#special_boss_state{boss_map = BossMap, online_num_map = OnlineNumMap} = State,
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] -> NewState = State;
		SpecialBossMap ->
		case maps:get(BossId, SpecialBossMap, []) of
			#special_boss{reborn_ref = RebornRef, remind = Remind} = OldSpecialBoss when BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER; BossId == 3400001 ->
				util:cancel_timer(RebornRef),
				#boss_cfg{scene = Scene, x = X, y = Y} = data_boss:get_boss_cfg(BossId),
				%% 先清怪物
				lib_mon:clear_scene_mon_by_mids(Scene, 0, RoleId, 1, [BossId]),
				lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, RoleId, 1, []),
				SpecialBoss = OldSpecialBoss#special_boss{reborn_time = 0, reborn_ref = undefined},
				{ok, Bin} = pt_460:write(46009, [BossType, BossId, 0, 1]),
				lib_server_send:send_to_uid(RoleId, Bin),
				db:execute(io_lib:format(?sql_special_boss_replace, [RoleId, BossType, BossId, 0, Remind])),
				NewState = update_state_state(RoleId, SpecialBoss, BossType, BossId, State);
			%% todo 策划要求只复活一个boss其他的只是循环显示cd
			#special_boss{reborn_ref = RebornRef, remind = Remind, remind_ref = Ref} = OldSpecialBoss ->
	    		NowTime = utime:unixtime(),
	    		RebornEndTime = calc_reborn_time(NowTime, OnlineNumMap, BossType, BossId),
				util:cancel_timer(RebornRef),
				util:cancel_timer(Ref),
				SpecialBoss = OldSpecialBoss#special_boss{reborn_time = RebornEndTime, remind_ref = undefined},
				{ok, Bin} = pt_460:write(46009, [BossType, BossId, RebornEndTime, 0]),
    			lib_server_send:send_to_uid(RoleId, Bin),
	    		NewSpecialBoss = calc_boss_reborn_ref(RoleId, BossType, SpecialBoss),
				db:execute(io_lib:format(?sql_special_boss_replace, [RoleId, BossType, BossId, RebornEndTime, Remind])),
				NewState = update_state_state(RoleId, NewSpecialBoss, BossType, BossId, State);
			_ ->
				NewState = State
		end
	end,
	NewState.

gm_refresh_boss(State, RoleId, BossType) ->
	#special_boss_state{boss_map = BossMap, online_num_map = OnlineNumMap} = State,
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] -> NewState = State;
		SpecialBossMap ->
		List = maps:values(SpecialBossMap),
		Fun = fun
			(#special_boss{boss_id = BossId, reborn_ref = RebornRef, remind = Remind} = OldSpecialBoss, Acc) when BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER; BossId == 3400001 ->
				util:cancel_timer(RebornRef),
				SpecialBoss = OldSpecialBoss#special_boss{reborn_time = 0, reborn_ref = undefined},
				db:execute(io_lib:format(?sql_special_boss_replace, [RoleId, BossType, BossId, 0, Remind])),
				update_state_state(RoleId, SpecialBoss, BossType, BossId, Acc);
			%% todo 策划要求只复活一个boss其他的只是循环显示cd
			(#special_boss{boss_id = BossId, reborn_ref = RebornRef, remind = Remind, remind_ref = Ref} = OldSpecialBoss, Acc) ->
	    		NowTime = utime:unixtime(),
	    		RebornEndTime = calc_reborn_time(NowTime, OnlineNumMap, BossType, BossId),
				util:cancel_timer(RebornRef),
				util:cancel_timer(Ref),
				SpecialBoss = OldSpecialBoss#special_boss{reborn_time = RebornEndTime, remind_ref = undefined},
	    		NewSpecialBoss = calc_boss_reborn_ref(RoleId, BossType, SpecialBoss),
				db:execute(io_lib:format(?sql_special_boss_replace, [RoleId, BossType, BossId, RebornEndTime, Remind])),
				update_state_state(RoleId, NewSpecialBoss, BossType, BossId, Acc);
			(_, Acc) -> Acc
		end,
		NewState = lists:foldl(Fun, State, List)
	end,
	NewState.

boss_reborn(RoleId, BossType, BossId, State) ->
	#special_boss_state{boss_map = BossMap, online_num_map = OnlineNumMap} = State,
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] -> NewState = State;
		SpecialBossMap ->
			case maps:get(BossId, SpecialBossMap, []) of
				#special_boss{reborn_ref = RebornRef, remind = Remind} = OldSpecialBoss when BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER; BossId == 3400001 ->
					util:cancel_timer(RebornRef),
					SpecialBoss = OldSpecialBoss#special_boss{reborn_time = 0, reborn_ref = undefined},
					db:execute(io_lib:format(?sql_special_boss_replace, [RoleId, BossType, BossId, 0, Remind])),
					NewState = update_state_state(RoleId, SpecialBoss, BossType, BossId, State);
				%% todo 策划要求只复活一个boss其他的只是循环显示cd
				#special_boss{reborn_ref = RebornRef, remind = Remind, remind_ref = Ref} = OldSpecialBoss ->
		    		NowTime = utime:unixtime(),
		    		RebornEndTime = calc_reborn_time(NowTime, OnlineNumMap, BossType, BossId),
					util:cancel_timer(RebornRef),
					util:cancel_timer(Ref),
					SpecialBoss = OldSpecialBoss#special_boss{reborn_time = RebornEndTime, remind_ref = undefined},
		    		NewSpecialBoss = calc_boss_reborn_ref(RoleId, BossType, SpecialBoss),
					db:execute(io_lib:format(?sql_special_boss_replace, [RoleId, BossType, BossId, RebornEndTime, Remind])),
					NewState = update_state_state(RoleId, NewSpecialBoss, BossType, BossId, State);
				_ ->
					NewState = State
			end
	end,
	NewState.

change_reborn_ref(enter, RoleId, BossType, State) ->
	#special_boss_state{boss_map = BossMap} = State,
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] -> NewState = State;
		SpecialBossMap ->
			SpecialBossList = maps:to_list(SpecialBossMap),
			Fun = fun({BossId, Boss}, AccMap) ->
				NewSpecialBoss = calc_boss_reborn_ref(enter, RoleId, BossType, Boss),
				maps:put(BossId, NewSpecialBoss, AccMap)
			end,
			NewSpecialBossMap = lists:foldl(Fun, SpecialBossMap, SpecialBossList),
			NewBossMap = maps:put({BossType, RoleId}, NewSpecialBossMap, BossMap),
			NewState = State#special_boss_state{boss_map = NewBossMap}
	end,
	NewState;

change_reborn_ref(exit, RoleId, BossType, State) ->
	#special_boss_state{boss_map = BossMap} = State,
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] -> NewState = State;
		SpecialBossMap ->
			SpecialBossList = maps:to_list(SpecialBossMap),
			Fun = fun({BossId, #special_boss{} = Boss}, AccMap) ->
				NewSpecialBoss = calc_boss_reborn_ref(RoleId, BossType, Boss),
				maps:put(BossId, NewSpecialBoss, AccMap)
			end,
			NewSpecialBossMap = lists:foldl(Fun, SpecialBossMap, SpecialBossList),
			NewBossMap = maps:put({BossType, RoleId}, NewSpecialBossMap, BossMap),
			NewState = State#special_boss_state{boss_map = NewBossMap}
	end,
	NewState.

boss_remind(RoleId, BossType, BossId, State) ->
	#special_boss_state{boss_map = BossMap} = State,
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] -> NewState = State;
		SpecialBossMap ->
		case maps:get(BossId, SpecialBossMap, []) of
			#special_boss{reborn_time = RebornTime, remind_ref = OldRemindRef, remind = Remind} = OldSpecialBoss ->
				RebornSpanTime = RebornTime - utime:unixtime(),
			    util:cancel_timer(OldRemindRef),
			    if
			    	Remind == 1 ->
			    		RemindTime = lib_boss_mod:calc_remind_time(BossType, RebornSpanTime),
					    RemindRef = ?IF(RemindTime == undefined, undefined,
					    	util:send_after(OldRemindRef, RemindTime * 1000,self(), {'boss_remind', RoleId, BossType, BossId})),
						SpecialBoss = OldSpecialBoss#special_boss{remind_ref = RemindRef},
                        lib_server_send:send_to_uid(RoleId, pt_460, 46016, [BossType, BossId]);
					true ->
						SpecialBoss = OldSpecialBoss#special_boss{remind_ref = undefined}
			    end,
				NewState = update_state_state(RoleId, SpecialBoss, BossType, BossId, State);
			_ ->
				NewState = State
		end
	end,
	NewState.

boss_remind_op(State, RoleId, BossType, BossId, Remind) when BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
    % FBossType = ?BOSS_TYPE_NEW_OUTSIDE, %% 该boss类型是新野外boss的特殊boss玩法
    % RemindNum = mod_counter:get_count(RoleId, ?MOD_BOSS, FBossType),
    case get_special_boss_info(State, RoleId, BossType, BossId) of
        {false, ErrCode} ->
            lib_server_send:send_to_uid(RoleId, pt_460, 46007, [ErrCode, BossType, BossId, Remind, 0]),
            State;
        {ok, _BossMap, _SpecialBossMap, #special_boss{reborn_time = RebornTime, remind = OldRemind} = SpecialBoss} ->
            {Code, NewRemind}
                = if
                      Remind == ?REMIND andalso OldRemind == ?REMIND ->
                          {?ERRCODE(err460_no_remind), Remind};
                      Remind =/= ?REMIND andalso OldRemind =/= ?REMIND ->
                          {?ERRCODE(err460_no_unremind), Remind};
                      Remind == ?REMIND -> %% replace
                          db:execute(io_lib:format(?sql_special_boss_replace, [RoleId, BossType, BossId, RebornTime, Remind])),
                          {?SUCCESS, Remind};
                      true -> %% delete
                          db:execute(io_lib:format(?sql_special_boss_replace, [RoleId, BossType, BossId, RebornTime, Remind])),
                          {?SUCCESS, Remind}
                  end,
            lib_server_send:send_to_uid(RoleId, pt_460, 46007, [Code, BossType, BossId, Remind, 0]),
            NewSpecialBoss = SpecialBoss#special_boss{remind = NewRemind},
            NewState = update_state_state(RoleId, NewSpecialBoss, BossType, BossId, State),
            NewState
    end;
boss_remind_op(State, _, _, _, _) -> State.

boss_be_kill(State, _ScenePoolId, BossType, BossId, AttrId, _AttrName, BLWhos, _DX, _DY, _FirstAttr, _MonArgs)
    when BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER
    ->
    #special_boss_state{online_num_map = OnlineNumMap} = State,
	case get_special_boss_info(State, AttrId, BossType, BossId) of
        {false, _ErrCode} -> State;
        {ok, _BossMap, _SpecialBossMap, #special_boss{remind = OldRemind} = SpecialBoss} ->
        	NowTime = utime:unixtime(),
            mod_boss_first_blood:boss_be_killed(BossId, BLWhos),
%%	        mod_boss:handle_activitycalen_kill([], AttrId, BLWhos, ?BOSS_TYPE_NEW_OUTSIDE),
            #boss_cfg{reborn_time = RebornTimes} = data_boss:get_boss_cfg(BossId),
    		TemRebornTime = mod_boss:get_reborn_time(RebornTimes),
    		% Discount = lib_boss:calc_online_user(OnlineNumMap, BossType, BossId),
    		% RebornTime = TemRebornTime * Discount div 100,
    		RebornTime_2 = lib_boss:calc_online_user(OnlineNumMap, BossType, BossId),
            if
                RebornTime_2 == 0 ->
                    RebornTime = TemRebornTime;
                true ->
                    RebornTime = RebornTime_2
            end,
    		RebornEndTime = NowTime + RebornTime,
    		% ?PRINT("RebornEndTime:~p ~n",[RebornEndTime]),
            NewBoss = SpecialBoss#special_boss{reborn_time = RebornEndTime},
            BossAfRemind = calc_boss_remind_ref(AttrId, BossType, NewBoss),
    		NewSpecialBoss = calc_boss_reborn_ref(enter, AttrId, BossType, BossAfRemind),
    		NewState = update_state_state(AttrId, NewSpecialBoss, BossType, BossId, State),
    		mod_boss:handle_activitycalen_kill([], AttrId, BLWhos, BossType),
    		if
    			BossId == 402 orelse BossId == 403 ->
    				mod_counter:increment(AttrId, ?MOD_BOSS, ?MOD_SUB_BOSS_OUTSID_KILL, BossId);
    			true -> skip
    		end,
            db:execute(io_lib:format(?sql_special_boss_replace, [AttrId, BossType, BossId, RebornEndTime, OldRemind])),
            {ok, Bin} = pt_460:write(46009, [BossType, BossId, RebornEndTime, 0]),
    		lib_server_send:send_to_uid(AttrId, Bin),
            %% 事件触发
            CallBackData = #callback_boss_kill{boss_type = BossType, boss_id = BossId},
			[lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_KILL, CallBackData)||#mon_atter{id = RoleId}<-BLWhos],
    		%% 成就触发
    		lib_player:apply_cast(AttrId, ?APPLY_CAST_STATUS, lib_achievement_api, boss_achv_finish, [BossType, BossId]),
            % 掉落通知 %%走掉落
            NewState
    end;
boss_be_kill(State, _, _, _, _, _, _, _DX, _DY, _, _) ->
	State.

get_boss_info(State, RoleId, RoleLv, Sid, LastTaskId, BossType, LessCount, AllCount, LessTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes) ->
    #special_boss_state{boss_map = BossMap, online_num_map = OnlineNumMap} = State,
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] ->
			if
				LastTaskId > ?SPECIAL_BOSS_TASK_ID -> %% 任务id限制下
					BossInfos = [], NewBossMap = BossMap;
				true ->
					AllBossIds = get_boss_by_rolelv(BossType, RoleLv),
					SpecialBossMap = init_boss_map(AllBossIds, RoleId, BossType, OnlineNumMap),
					BossInfos = gen_send_info(SpecialBossMap),
					NewBossMap = maps:put({BossType, RoleId}, SpecialBossMap, BossMap)
			end;
		SpecialBossMap ->
			BossInfos = gen_send_info(SpecialBossMap),
            NewBossMap = BossMap
	end,
	lib_server_send:send_to_sid(Sid, pt_460, 46000, [BossType, LessCount, AllCount, LessTired, AllTired, Vit, LastVitTime, LCollectTimes, AllCollectTimes, BossInfos]),
	State#special_boss_state{boss_map = NewBossMap}.

gen_send_info(SpecialBossMap) ->
	Fun = fun(BossId, #special_boss{reborn_time = RebornTime, remind = Remind}, TL) ->
            [{BossId, 1, RebornTime, Remind, ?AUTO_REMIND} | TL]
    end,
    maps:fold(Fun, [], SpecialBossMap).

%% 等级提升
lv_up(State, RoleId, Lv) ->
	#special_boss_state{boss_map = BossMap} = State,
	BossType = ?BOSS_TYPE_SPECIAL,
	case maps:get({BossType, RoleId}, BossMap, []) of
		[] -> NewMap = BossMap;
		SpecialBossMap ->
	        F2 = fun(BossId, Boss) ->
	            #special_boss{remind = Remind, reborn_time = RebornTime} = Boss,
	            #boss_cfg{condition = Condition} = data_boss:get_boss_cfg(BossId),
	            % 取消关注的等级
	            % UnRemindLv = Lv - 100,
	            case lists:keyfind(lv, 1, Condition) of
	                {lv, Lv} ->
	                    case Remind of
	                        ?REMIND -> RemindAfLv = Remind;
	                        _ ->
	                            spawn(fun() -> db:execute(io_lib:format(?sql_special_boss_replace,
	                            		[RoleId, BossType, BossId, RebornTime, ?REMIND])) end),
	                            RemindAfLv = ?REMIND
	                    end;
	                _ ->
	                    RemindAfLv = Remind
	            end,
	            % 最大等级也取消关注
	            case lists:keyfind(max_lv, 1, Condition) of
	                {max_lv, MaxLv} when Lv > MaxLv ->
	                    case Remind of
	                        ?REMIND ->
	                            spawn(fun() -> db:execute(io_lib:format(?sql_special_boss_replace,
	                            		[RoleId, BossType, BossId, RebornTime, 0])) end),
	                            RemindAfMaxLv = 0;
	                        _ ->
	                            RemindAfMaxLv = RemindAfLv
	                    end;
	                _ ->
	                    RemindAfMaxLv = RemindAfLv
	            end,
	            Boss#special_boss{remind = RemindAfMaxLv}
	        end,
	        NewSpecialBossMap = maps:map(F2, SpecialBossMap),
	        NewMap = maps:put({BossType, RoleId}, NewSpecialBossMap, BossMap)
	end,
	State#special_boss_state{boss_map = NewMap}.

calc_reborn_time(NowTime, _, BossType, BossId) when BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
    #boss_cfg{reborn_time = RebornTimes} = data_boss:get_boss_cfg(BossId),
    RebornTime = mod_boss:get_reborn_time(RebornTimes),
    NowTime + RebornTime;
calc_reborn_time(NowTime, OnlineNumMap, BossType, BossId) ->
	#boss_cfg{reborn_time = RebornTimes} = data_boss:get_boss_cfg(BossId),
	TemRebornTime = mod_boss:get_reborn_time(RebornTimes),
	RebornTime_2 = lib_boss:calc_online_user(OnlineNumMap, BossType, BossId),
    if
        RebornTime_2 == 0 ->
            RebornTime = TemRebornTime;
        true ->
            RebornTime = RebornTime_2
    end,
	NowTime + RebornTime.

init_boss_map(AllBossIds, RoleId, BossType, OnlineNumMap) ->
	List = db:get_all(io_lib:format(?sql_special_boss_select, [RoleId, BossType])),
	Fun = fun([_, _, BossId, RebornTime, Remind], {SpecialBossMap, AddedBossId}) ->
		case lists:member(BossId, AllBossIds) of
			true ->
				RebornSpanTime = max(1, RebornTime - utime:unixtime()),
				RemindTime = max(0, RebornSpanTime - ?REMIND_TIME),
		        RemindRef = ?IF(RemindTime =< 0, undefined, erlang:send_after(RemindTime * 1000, self(), {'boss_remind', RoleId, BossType, BossId})),
		        RebornRef = erlang:send_after(RebornSpanTime * 1000, self(), {'boss_reborn', RoleId, BossType, BossId}),
				TemSpecialBoss = #special_boss{boss_id = BossId, reborn_time = RebornTime, remind_ref = RemindRef, reborn_ref = RebornRef, remind = Remind},
				NewSpecialBossMap = maps:put(BossId, TemSpecialBoss, SpecialBossMap),
				{NewSpecialBossMap, [BossId|AddedBossId]};
			false ->
				spawn(fun() ->
					db:execute(io_lib:format(?sql_special_boss_delete, [RoleId, BossType, BossId]))
				end),
				{SpecialBossMap, AddedBossId}
		end
	end,
	{NSpBossMap, NABossId} = lists:foldl(Fun, {#{}, []}, List),
	LeftBossId = lists:subtract(AllBossIds, NABossId),
	NowTime = utime:unixtime(),
	F = fun
		(BossId, TemMap) when BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER; BossId == 3400001 ->
			TemBoss = #special_boss{boss_id = BossId, reborn_time = 0, remind_ref = undefined, reborn_ref = undefined, remind = 0},
			% db:execute(io_lib:format(?sql_special_boss_replace, [RoleId, BossType, BossId, 0, 0])),
            maps:put(BossId, TemBoss, TemMap);
		(BossId, TemMap) ->
			RebornEndTime = calc_reborn_time(NowTime, OnlineNumMap, BossType, BossId),
			RebornRef = erlang:send_after(max(0, RebornEndTime-NowTime) * 1000, self(), {'boss_reborn', RoleId, BossType, BossId}),
			TemBoss = #special_boss{
				boss_id = BossId, reborn_time = RebornEndTime,
				remind_ref = undefined, reborn_ref = RebornRef, remind = 0},
            db:execute(io_lib:format(?sql_special_boss_replace, [RoleId, BossType, BossId, RebornEndTime, 0])),
            maps:put(BossId, TemBoss, TemMap)
	end,
	lists:foldl(F, NSpBossMap, LeftBossId).