%%%-----------------------------------
%%% @Module      : lib_dragon_language_boss_mod
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 九月 2019 19:57
%%% @Description : 
%%%-----------------------------------
-module(lib_dragon_language_boss_mod).
-compile(export_all).

-include("common.hrl").
-include("dragon_language_boss.hrl").
-include("errcode.hrl").
-include("clusters.hrl").
-include("def_module.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("scene.hrl").


%%----------------------- 龙语boss初始化 -------------------------
init() ->
	%% 获取所有的分区
	AllZone = mod_zone_mgr:get_all_zone(),
	ZoneList = init_zone(AllZone),
	#dragon_language_boss_state{zone_list = ZoneList}.


init_zone(AllZone) ->
	AllMapIds = data_dragon_language_boss:get_all_map_id(),
	F = fun(#zone_base{zone = ZoneId, server_id = ServerId, server_num = ServerNum}, ZoneList) ->
		case lists:keyfind(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList) of
			#dragon_language_boss_zone{server_info_list = ServerInfoList} = Zone ->
				ServerInfo = #server_info{server_id = ServerId, server_num = ServerNum},
				NewServerInfoList = lists:keystore(ServerId, #server_info.server_id, ServerInfoList, ServerInfo),
				NewZone = Zone#dragon_language_boss_zone{server_info_list = NewServerInfoList},
				lists:keystore(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList, NewZone);
			_ ->
				MonMap = init_mon(ZoneId, AllMapIds),
				ServerInfo = #server_info{server_id = ServerId, server_num = ServerNum},
				Zone = #dragon_language_boss_zone{mon_map = MonMap, zone_id = ZoneId, server_info_list = [ServerInfo]},
				[Zone | ZoneList]
		end
	end,
	lists:foldl(F, [], AllZone).

init_mon(ZoneId, AllMapIds) ->
	F = fun(MapId, Map) ->
		MonList = init_mon2(ZoneId, MapId),
		maps:put(MapId, MonList, Map)
	end,
	lists:foldl(F, #{}, AllMapIds).

init_mon2(ZoneId, MapId) ->
	case data_dragon_language_boss:get_map(MapId) of
		#base_dragon_language_boss_map{mon_list = MonList, scene = SceneId} ->
			MonMsgList = [#mon_msg{map_id = MapId, mon_id = MonId, status = ?mon_live, copy_id = ZoneId,
				reborn_time = 0, scene_id = SceneId, pool_id = MapId, x = X, y = Y} || {MonId, {X, Y}} <- MonList],
			create_mon(MonMsgList), %% 创建小怪
			[];
		_ ->
			[]
	end.

create_mon(MonList) ->
	F = fun(#mon_msg{scene_id = Scene, pool_id = PoolId, mon_id = MonId, copy_id = CopyId, x = X, y = Y}) ->
		case data_mon:get(MonId) of
            #mon{type=Type} ->
				lib_mon:async_create_mon(MonId, Scene, PoolId, X, Y, Type, CopyId, 1, []);
            _ -> skip
        end
	end,
	lists:foreach(F, MonList).
 
%%----------------------- 龙语boss初始化end -------------------------


get_info(ServerId, AllCount, LastCount, RoleId, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#dragon_language_boss_state{zone_list = ZoneList} = State,
	case lists:keyfind(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList) of
		#dragon_language_boss_zone{mon_map = MapMap, role_list = RoleList} ->
			PackList = pack_map_list(MapMap, ZoneId, RoleList),
			{ok, Bin} = pt_651:write(65101, [LastCount, AllCount, PackList]),
			send_to_uid(ServerId, RoleId, Bin),
			State;
		_ ->  %% 没有该区域，要初始化该区域
			if
				ZoneId =/= 0 ->
				    AllMapIds = data_dragon_language_boss:get_all_map_id(),
					MonMap = init_mon(ZoneId, AllMapIds),
					Zone = #dragon_language_boss_zone{mon_map = MonMap, zone_id = ZoneId},
					PackList = pack_map_list(MonMap, ZoneId, Zone#dragon_language_boss_zone.role_list),
					{ok, Bin} = pt_651:write(65101, [LastCount, AllCount, PackList]),
					send_to_uid(ServerId, RoleId, Bin),  %% 通知客户端
					NewZoneList = lists:keystore(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList, Zone),
					State#dragon_language_boss_state{zone_list = NewZoneList};
				true ->
					?ERR("error ZoneId ~p ServerId ~p ~n", [ZoneId, ServerId]),
					State
			end
	end.

%% 进入boss
enter(ServerId, ServerNum, RoleId, RoleName, MapId, MonId, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#dragon_language_boss_state{zone_list = ZoneList} = State,
	case lists:keyfind(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList) of
		#dragon_language_boss_zone{role_list = OldRoleList, server_info_list = ServerInfoList} = Zone ->
			ServerInfo = #server_info{server_id = ServerId, server_num = ServerNum},
			NewSerInfoList = lists:keystore(ServerId, #server_info.server_id, ServerInfoList, ServerInfo),
			Role = init_role(ServerNum, ServerId, RoleId, RoleName, MapId, ZoneId),  %% 初始化
			NewRoleList = lists:keystore(RoleId, #role_msg.role_id, OldRoleList, Role),
			NewZone = Zone#dragon_language_boss_zone{role_list = NewRoleList, server_info_list = NewSerInfoList},
			[mod_clusters_node:apply_cast(mod_dragon_language_boss, get_left_time, [ListServerId, ListRoleId]) || #role_msg{server_id = ListServerId, role_id = ListRoleId}  <- NewRoleList], 
			NewZoneList = lists:keystore(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList, NewZone),  %% 组装数据
			{ok, Bin} = pt_651:write(65102, [MapId, MonId]),
			send_to_uid(ServerId, RoleId, Bin),  %% 通知客户端
			%%拉玩家进入场景
			pull_role_in_map(Role),
			%% 增加次数
			mod_clusters_center:apply_cast(ServerId, lib_local_chrono_rift_act,
				role_success_finish_act, [RoleId, ?MOD_DRAGON_LANGUAGE_BOSS, 0, 1]),
			mod_clusters_center:apply_cast(ServerId, mod_daily, increment_offline, [RoleId, ?MOD_DRAGON_LANGUAGE_BOSS, 1]),
			State#dragon_language_boss_state{zone_list = NewZoneList};
		_ ->
			if
				ZoneId =/= 0 ->
					AllMapIds = data_dragon_language_boss:get_all_map_id(),
					MonList = init_mon(ZoneId, AllMapIds),
					ServerInfo = #server_info{server_id = ServerId, server_num = ServerNum},
					Zone = #dragon_language_boss_zone{mon_map = MonList, zone_id = ZoneId, server_info_list = [ServerInfo]},
					Role = init_role(ServerNum, ServerId, RoleId, RoleName, MapId, ZoneId),  %% 初始化
					NewRoleList = lists:keystore(RoleId, #role_msg.role_id, [], Role),
					NewZone = Zone#dragon_language_boss_zone{role_list = NewRoleList},
					[mod_clusters_node:apply_cast(mod_dragon_language_boss, get_left_time, [ListServerId, ListRoleId]) || #role_msg{server_id = ListServerId, role_id = ListRoleId} <- NewRoleList], 
					NewZoneList = lists:keystore(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList, NewZone),  %% 组装数据
					{ok, Bin} = pt_651:write(65102, [MapId, MonId]),
					send_to_uid(ServerId, RoleId, Bin),  %% 通知客户端
					%%拉玩家进入场景
					pull_role_in_map(Role),
					%% 增加次数
					mod_clusters_center:apply_cast(ServerId, lib_dragon_language_boss, enter_success, [RoleId]),
					State#dragon_language_boss_state{zone_list = NewZoneList};
				true ->
					?ERR("error ZoneId ~p ServerId ~p ~n", [ZoneId, ServerId]),
					State
			end

	end.

send_to_uid(ServerId, RoleId, Bin) ->
	mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]).

pack_map_list(MapMap, ZoneId, RoleList) ->
	List = maps:to_list(MapMap),
	F = fun({MapId, MonMsgList}, AccList) ->
		RoleNum = get_role_num(MapId, ZoneId, RoleList),
		MonList = [{ModId, RebornTime} || #mon_msg{mon_id = ModId, reborn_time = RebornTime} <- MonMsgList],
		[{MapId, RoleNum, MonList} | AccList]
	    end,
	lists:foldl(F, [], List).

init_role(ServerNum, ServerId, RoleId, RoleName, MapId, ZoneId) ->
	case data_dragon_language_boss:get_map(MapId) of
		#base_dragon_language_boss_map{time = Time, scene = SceneId} ->
			Ref = util:send_after([], (Time + ?delay_time) * 1000, self(), {role_time_out, ZoneId, RoleId}),
			#role_msg{left_time = utime:unixtime() + Time + ?delay_time, role_id = RoleId, scene_id = SceneId, pool_id = MapId,
				copy_id = ZoneId, role_name = RoleName, server_id = ServerId, server_num = ServerNum, ref = Ref};
		_ ->
			#role_msg{}
	end.

pull_role_in_map(Role) ->
	#role_msg{server_id = ServerId, scene_id = SceneId, pool_id = PoolId, copy_id = CopyId, role_id = RoleId} = Role,
	mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, [RoleId, SceneId, PoolId, CopyId, true,
		[{group, 0}, {change_scene_hp_lim, 100}]]).

%% 玩家超时，离开场景
role_time_out(ZoneId, RoleId, State) ->
	#dragon_language_boss_state{zone_list = ZoneList} = State,
	case lists:keyfind(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList) of
		#dragon_language_boss_zone{role_list = RoleList} = Zone ->
			case lists:keyfind(RoleId, #role_msg.role_id, RoleList) of
				#role_msg{} = Role ->
					NewRoleList = lists:keydelete(RoleId, #role_msg.role_id, RoleList),
					NewZone = Zone#dragon_language_boss_zone{role_list = NewRoleList},
					NewZoneList = lists:keystore(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList, NewZone),
					put_role_out(Role), %% 返回野外
					State#dragon_language_boss_state{zone_list = NewZoneList};
				_ ->
					State
			end;
		_ ->
			State
	end.


put_role_out(Role) ->
	#role_msg{server_id = ServerId, role_id = RoleId} = Role,
	mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, [RoleId, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100}]]).


quit(ServerId, RoleId, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#dragon_language_boss_state{zone_list = ZoneList} = State,
	case lists:keyfind(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList) of
		#dragon_language_boss_zone{role_list = OldRoleList} = Zone ->
			case lists:keyfind(RoleId, #role_msg.role_id, OldRoleList) of
				#role_msg{ref = Ref} ->
					%% 取消定时器
					util:cancel_timer(Ref),
					NewRoleList = lists:keydelete(RoleId, #role_msg.role_id, OldRoleList),
					NewZone = Zone#dragon_language_boss_zone{role_list = NewRoleList},					
					NewZoneList = lists:keystore(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList, NewZone),
					NewState = State#dragon_language_boss_state{zone_list = NewZoneList};
				_ ->
                    %% 处理特殊情况，玩家在场景中进行了分区
                    NewZoneList = lib_dragon_language_boss_util:clear_role_msg(RoleId, ZoneList),
					NewState = State#dragon_language_boss_state{zone_list = NewZoneList}
			end,
			#dragon_language_boss_zone{role_list = LastRoleList} = ulists:keyfind(ZoneId, #dragon_language_boss_zone.zone_id, NewZoneList, #dragon_language_boss_zone{role_list = []}),
			[mod_clusters_node:apply_cast(mod_dragon_language_boss, get_left_time, [ListServerId, ListRoleId]) || #role_msg{server_id = ListServerId, role_id = ListRoleId}  <- LastRoleList];
		_ ->
			NewState = State
	end,
	
	mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, [RoleId, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100}]]),
	NewState.

%% 怪物被杀
mon_be_killed(PoolId, CopyId, MonCfgId, State) ->
	#dragon_language_boss_state{zone_list = ZoneList} = State,
	case lists:keyfind(CopyId, #dragon_language_boss_zone.zone_id, ZoneList) of  %% copy_id 就是区域id
		#dragon_language_boss_zone{mon_map = MonMap} = Zone ->
			case maps:get(PoolId, MonMap, []) of
				[_ | _] = MonList ->
					case lists:keyfind(MonCfgId, #mon_msg.mon_id, MonList) of
						#mon_msg{ref = OldRef} = Mon ->
							case data_dragon_language_boss:get_mon(MonCfgId) of
								#base_dragon_language_boss_mon{refresh_time = Time, type = ?mon_type_small} -> %%小怪逻辑
									%%定时器
									Ref = util:send_after(OldRef, Time * 1000, self(), {reborn, PoolId, CopyId, MonCfgId}),
									NewMon = Mon#mon_msg{ref = Ref, reborn_time = utime:unixtime() + Time, status = ?mon_dead},
									NewMonList = lists:keystore(MonCfgId, #mon_msg.mon_id, MonList, NewMon),
									NewMap = maps:put(PoolId, NewMonList, MonMap),
									NewZone = Zone#dragon_language_boss_zone{mon_map = NewMap},
									NewZoneList = lists:keystore(CopyId, #dragon_language_boss_zone.zone_id, ZoneList, NewZone),
									State#dragon_language_boss_state{zone_list = NewZoneList};
								#base_dragon_language_boss_mon{type = ?mon_type_boss} -> %%boss逻辑
									State;
								_ ->
									State
							end;
						_ ->
							State
					end;
				_ ->
					State
			end;
		_ ->
			State
	end.


get_left_time(ServerId, RoleId, State) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	#dragon_language_boss_state{zone_list = ZoneList} = State,
	case lists:keyfind(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList) of
		#dragon_language_boss_zone{role_list = RoleList, mon_map = MonMap} ->
			case lists:keyfind(RoleId, #role_msg.role_id, RoleList) of
				#role_msg{left_time = LeftTime, pool_id = PoolId, copy_id = CopyId} = Role ->
					MonList = get_mon_list(Role, MonMap),
					Num = get_role_num(PoolId, CopyId, RoleList),
					{ok, Bin} = pt_651:write(65105, [PoolId, MonList, Num, LeftTime - ?delay_time]),
					send_to_uid(ServerId, RoleId, Bin);
				_ ->
					ok
			end;
		_ ->
			ok
	end.

%% 增加在场景的时间
add_time(ServerId, RoleId, AddTime, AllCount, LeftCount, Cost, State) ->
	#dragon_language_boss_state{zone_list = ZoneList} = State,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	OldZoneId = lib_dragon_language_boss_util:get_zone_id_by_role_id(RoleId, ZoneList),
	case lists:keyfind(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList) of
		#dragon_language_boss_zone{role_list = OldRoleList} = Zone when ZoneId == OldZoneId ->
			case lists:keyfind(RoleId, #role_msg.role_id, OldRoleList)  of
				#role_msg{left_time = LeftTime, ref = OldRef} = OldRole ->
					Now = utime:unixtime(),
					NewLeftTime = LeftTime + AddTime,
					%% 重新设置定时器
					NewRef = util:send_after(OldRef, max(NewLeftTime - Now, 1) * 1000,  self(), {role_time_out, ZoneId, RoleId}),
					Role = OldRole#role_msg{left_time = NewLeftTime, ref = NewRef},
					NewRoleList = lists:keystore(RoleId, #role_msg.role_id, OldRoleList, Role),
					NewZone = Zone#dragon_language_boss_zone{role_list = NewRoleList},
					NewZoneList = lists:keystore(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList, NewZone),  %% 组装数据
					{ok, Bin} = pt_651:write(65107, [LeftCount, AllCount, NewLeftTime - ?delay_time]),
					send_to_uid(ServerId, RoleId, Bin),  %% 通知客户端
					State#dragon_language_boss_state{zone_list = NewZoneList};
				_ ->
					State
			end;
		#dragon_language_boss_zone{} when ZoneId =/= OldZoneId -> %% 特殊情况：玩家在场景里刚好改变分区,补偿回被扣除的东西
            case lists:keyfind(OldZoneId, #dragon_language_boss_zone.zone_id, ZoneList) of
                #dragon_language_boss_zone{role_list = OldZoneRoleList} ->
        			case lists:keyfind(RoleId, #role_msg.role_id, OldZoneRoleList) of
        				#role_msg{left_time = LeftTime} ->
        					mod_clusters_center:apply_cast(ServerId, lib_dragon_language_boss_util, in_scene_zone_change, [add_time, [RoleId, Cost, LeftCount + 1, AllCount, LeftTime]]);
        				_ -> skip
        			end;
                _ ->
                    skip
            end,
			State;
		_ ->
			?ERR("error ZoneId ~p ServerId ~p ~n", [ZoneId, ServerId]),
			State
	end.

%%获取怪物信息  目前不用，没有boss
get_mon_list(_Role, _MonMap) ->
	[].

get_role_num(PoolId, CopyId, RoleList) ->
	get_role_num(PoolId, CopyId, RoleList, 0).

get_role_num(_PoolId, _CopyId, [], Num) ->
	Num;
get_role_num(PoolId, CopyId, [#role_msg{pool_id = Pool2, copy_id = CopyId2} | T], Num) ->
	if
		PoolId == Pool2 andalso CopyId == CopyId2 ->
			get_role_num(PoolId, CopyId, T, Num + 1);
		true ->
			get_role_num(PoolId, CopyId, T, Num)
	end.



get_create_mon_list([{MonId, MinX, MaxX, MinY, MaxY, Num} | T], AccList) ->
	NewAccList = get_create_mon_list2(MonId, MinX, MaxX, MinY, MaxY, Num, []),
	get_create_mon_list(T, AccList ++ NewAccList);
get_create_mon_list([], AccList) ->
	AccList.

get_create_mon_list2(_MonId, _MinX, _MaxX, _MinY, _MaxY, 0, AccList) ->
	AccList;
get_create_mon_list2(MonId, MinX, MaxX, MinY, MaxY, Num, AccList) ->
	X =  hd(ulists:list_shuffle(lists:seq(MinX, MaxX))),
	Y =  hd(ulists:list_shuffle(lists:seq(MinY, MaxY))),
	case lists:member({MonId, {X, Y}}, AccList) of
		true ->
			get_create_mon_list2(MonId, MinX, MaxX, MinY, MaxY, Num, AccList);
		false ->
			get_create_mon_list2(MonId, MinX, MaxX, MinY, MaxY, Num - 1, [{MonId, {X, Y}} |AccList])
	end.

repair_mon(_State) ->
	AllMapIds = data_dragon_language_boss:get_all_map_id(),
	[lib_scene:clear_scene(46001, MapId) || MapId <- AllMapIds],
	AllZone = mod_zone_mgr:get_all_zone(),
	ZoneList = init_zone(AllZone),
	#dragon_language_boss_state{zone_list = ZoneList}.


repair_on_line_num(State) ->
	#dragon_language_boss_state{zone_list = ZoneList} = State,
	Now = utime:unixtime(),
	F = fun(#dragon_language_boss_zone{role_list = RoleList} = Zone, AccList) ->
			NewRoleList = [Role || #role_msg{left_time = LeftTimes} = Role <- RoleList, LeftTimes >= Now],
			[Zone#dragon_language_boss_zone{role_list = NewRoleList} | AccList]
		end,
	NewZoneList = lists:foldl(F, [], ZoneList),
	State#dragon_language_boss_state{zone_list = NewZoneList}.

%% 暂停玩法
%% 注意，因为是执行所有服，所以这里只针对调用服处理即可
gm_clear_user(ReqServerId, State) ->
	#dragon_language_boss_state{zone_list = ZoneList} = State,
	ZoneId = lib_clusters_center_api:get_zone(ReqServerId),
	ZoneData = lists:keyfind(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList), 
	case ZoneData of
		#dragon_language_boss_zone{role_list = RoleList} ->
			F2 = fun(Role, FunRoleList) ->
				#role_msg{server_id = ServerId, role_id = RoleId, ref = Ref} = Role,
				case ReqServerId == ServerId of 
					true ->
						util:cancel_timer(Ref),
						mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, [RoleId, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100}]]),
						FunRoleList;
					false ->
						[Role | FunRoleList]
				end
			end,
			NewRoleList = lists:foldl(F2, [], RoleList),
			NewZoneData = ZoneData#dragon_language_boss_zone{role_list = NewRoleList},
			NewZoneList = lists:keystore(ZoneId, #dragon_language_boss_zone.zone_id, ZoneList, NewZoneData),
			State#dragon_language_boss_state{zone_list = NewZoneList};
		_ -> 
			State
	end.

%% 调整分区
zone_change(ServerId, OldZone, NewZone, State) ->
	#dragon_language_boss_state{zone_list = ZoneList} = State,
    %% 清理旧数据
	NewZoneList = case lists:keyfind(OldZone, #dragon_language_boss_zone.zone_id, ZoneList) of
		#dragon_language_boss_zone{server_info_list = ServerInfoList} = OldZoneData ->
			NewSerInfoList = lists:keydelete(ServerId, #server_info.server_id, ServerInfoList),
			OldZoneData2 = OldZoneData#dragon_language_boss_zone{server_info_list = NewSerInfoList},
			lists:keystore(OldZone, #dragon_language_boss_zone.zone_id, ZoneList, OldZoneData2);
		_ -> %% 不存在不进行操作
            ZoneList
	end,
    %% 创建新分区数据
    case lists:keyfind(NewZone, #dragon_language_boss_zone.zone_id, NewZoneList) of 
        #dragon_language_boss_zone{}  ->
            State#dragon_language_boss_state{zone_list = NewZoneList};
        _ -> %% 不存在则创建新分区
            AllMapIds = data_dragon_language_boss:get_all_map_id(),
            MonMap = init_mon(NewZone, AllMapIds),
            NewZoneData = #dragon_language_boss_zone{mon_map = MonMap, zone_id = NewZone},
            LastZoneList = lists:keystore(NewZone, #dragon_language_boss_zone.zone_id, NewZoneList, NewZoneData),
            State#dragon_language_boss_state{zone_list = LastZoneList}
    end.

