%% ---------------------------------------------------------------------------
%% @doc lib_sanctuary_cluster_mod

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/9/3 0003
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_sanctuary_cluster_mod).

%% API
-export([
      sync_zone_group/2
    , update_info/2
    , center_connected/2
    , fix_merge_server_data/4
    , server_info_change/3
    , act_start/4
    , act_end/1
    , mon_reborn/2
    , enter/6
    , quit/4
    , get_bl_reward/4
    , mon_be_killed/6
    , clear_role/4
    , peace_mon_reborn/4
    , kill_player/8
]).

-include("common.hrl").
-include("server.hrl").
-include("clusters.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("cluster_sanctuary.hrl").
-include("def_module.hrl").

%% 获取GroupState
%% @return #sanctuary_group_state{} | false
get_group_state(ServerId, State) ->
    #sanctuary_cls_state{server_group_map = ServerGroupMap, group_state_map = GroupStateMap} = State,
    GroupId = maps:get(ServerId, ServerGroupMap, 0),
    maps:get(GroupId, GroupStateMap, false).

%% 保存GroupState
%% @return #ssanctuary_cls_state{}
save_group_state(GroupState, State) ->
    #sanctuary_cls_state{group_state_map = GroupStateMap} = State,
    #sanctuary_group_state{group_id = GroupId} = GroupState,
    NewGroupStateMap = GroupStateMap#{GroupId => GroupState},
    State#sanctuary_cls_state{group_state_map = NewGroupStateMap}.

%% 更新同步信息
sync_game_state(#sanctuary_cls_state{group_state_map = GroupStateMap}, Args) ->
    [sync_game_state(GroupState, Args)||GroupState<-maps:values(GroupStateMap)];
sync_game_state(GroupState, Args) ->
    #sanctuary_group_state{server_zone = ServerZones} = GroupState,
    [mod_clusters_center:apply_cast(SerId, mod_sanctuary_cluster_local, update_info, [Args])||#zone_base{server_id = SerId} <- ServerZones].


%% -----------------------------------------------------------------
%%  同步分组信息,同时异步初始化信息
%% -----------------------------------------------------------------
sync_zone_group(State, InfoList) ->
    NowTime = utime:unixtime(),
    NowDate = utime:unixdate(),
    RoleClearTime = lib_sanctuary_cluster_util:calc_role_clear_time(NowTime),
    {StartTime0, EndTime0} = lib_sanctuary_cluster_util:calc_act_open_time(NowDate),

    if
        (NowTime >= StartTime0 andalso NowTime < EndTime0);
        NowTime < StartTime0 ->
            StartTime = StartTime0,EndTime = EndTime0;
        true ->
            {StartTime, EndTime} = lib_sanctuary_cluster_util:calc_act_open_time(NowDate+?ONE_DAY_SECONDS)
    end,

    MonRebornTime0 = lib_sanctuary_cluster_util:calc_next_mon_time(NowTime),
    case MonRebornTime0 < StartTime of
        true -> MonRebornTime = lib_sanctuary_cluster_util:calc_next_mon_time(MonRebornTime0 + 10);
        _ -> MonRebornTime = MonRebornTime0
    end,

    NotifyLastMin = data_cluster_sanctuary_m:get_san_value(tip_notify_user_act_end),

    NotifyRef = erlang:send_after(max(EndTime-NotifyLastMin * 60,1)*1000, self(), {'tips_act_end', NotifyLastMin}),

    % 特殊处理， 如果活动开始的倒计时小于创建怪物的倒计时。怪物创建倒计时必须在活动开启之后
    StartCountDown = max(1, (StartTime - NowTime)),
    if
        (MonRebornTime - NowTime) =< StartCountDown ->
            LastMonRebornTime = MonRebornTime,
            CreateCountDown = StartCountDown + 10;
        true ->
            %% 如果刷新时间在配置的NotifyLastMin内，则走正常刷怪的逻辑
            StartNotifyTime = max(MonRebornTime - NotifyLastMin * 60, 1),
            case NowTime < StartNotifyTime of
                true ->
                    LastMonRebornTime = NowTime + 10,
                    CreateCountDown = 10;    %% 修改为停机更新(即重启服务器时, 该进程完成初始化后10s刷新怪物信息)
                _ ->
                    CreateCountDown = MonRebornTime - NowTime,
                    LastMonRebornTime = MonRebornTime
            end
    end,

    ClearRef    = util:send_after(State#sanctuary_mgr_state.role_anger_ref, max((RoleClearTime-NowTime)*1000, 1000), self(), 'role_anger_clear'),
    StartRef    = util:send_after(State#sanctuary_mgr_state.start_ref, StartCountDown * 1000, self(), 'act_start'),
    EndRef      = util:send_after(State#sanctuary_mgr_state.end_ref, max(1000, (EndTime - NowTime) * 1000), self(), 'act_end'),
    MonBornRef  = util:send_after(State#sanctuary_mgr_state.mon_reborn_ref, CreateCountDown * 1000, self(), 'mon_reborn'),

    %% ?INFO("MonRebornTime:~p//NowTime:~p//StartTime:~p//StartCountDown:~p//EndTime:~p//NotifyLastMin:~p",[LastMonRebornTime, NowTime, StartTime, StartCountDown, EndTime, NotifyLastMin]),

    % 处理分组信息
    List = db:get_all(?SQL_SELECT_SERVER_BEGIN_SCENE),
    MapList = [{ {ZoneId, GroupId}, {util:bitstring_to_term(ServerIdsStr), util:bitstring_to_term(ServerSceneMapStr), Time}}
        ||[ZoneId, GroupId, ServerIdsStr, ServerSceneMapStr, Time]<-List],
    ZoneGSceneMap = maps:from_list(MapList),

    F = fun({ZoneId, {Servers, GroupInfo}}, {AccServers, AccZSMap, AccPidL}) ->
        NewAccServers = Servers ++ AccServers,
        NewAccZSMap = AccZSMap#{ZoneId => Servers},
        {ok, Pid} = mod_sanctuary_cluster:start_link(ZoneId, Servers, GroupInfo, ZoneGSceneMap),
        mod_sanctuary_cluster:update_info(Pid, [{act_time, {StartTime, EndTime}},{mon_reborn_time, MonRebornTime}]),
        NewAccPidL = [Pid|AccPidL],
        {NewAccServers, NewAccZSMap, NewAccPidL}
    end,
    {AllZones, ZoneServerMap, ZoneDivision} = lists:foldl(F, {[], #{}, []}, InfoList),

    NewState = State#sanctuary_mgr_state{
          zone_division = ZoneDivision
        , zone_server_map = ZoneServerMap
        , all_zone_server = AllZones
        , mon_reborn_time = LastMonRebornTime
        , mon_reborn_ref = MonBornRef
        , role_anger_ref = ClearRef
        , start_ref = StartRef
        , end_ref = EndRef
        , start_time = StartTime
        , end_time = EndTime
        , act_tv_ref = NotifyRef
    },
    handle_message_queue(NewState).

%% 异步处理消息
handle_message_queue(State) ->
    MessQueue = State#sanctuary_mgr_state.message_queue,
    F = fun(Msg, AccState) ->
        case mod_sanctuary_cluster_mgr:handle_cast(Msg, AccState) of
            {noreply, NewAccState} when is_record(NewAccState, sanctuary_mgr_state) ->
                NewAccState;
            NewAccState when is_record(NewAccState, sanctuary_mgr_state) ->
                NewAccState;
            _ ->
                AccState
        end
    end,
    lists:foldl(F, State#sanctuary_mgr_state{is_init = 1, message_queue = []}, MessQueue).

%% -----------------------------------------------------------------
%%  更新信息
%% -----------------------------------------------------------------
update_info(State, Args) ->
    F = fun({Key, Value}, AccState) ->
        case Key of
            act_time ->
                case Value of
                    {StartTime, EndTime} ->
                        AccState#sanctuary_cls_state{start_time = StartTime, end_time = EndTime};
                    {IsOpen, StartTime, EndTime} ->
                        AccState#sanctuary_cls_state{is_open = IsOpen, start_time = StartTime, end_time = EndTime}
                end;
            mon_reborn_time -> AccState#sanctuary_cls_state{mon_reborn_time = Value};
            _ -> AccState
        end
    end,
    NewState = lists:foldl(F, State, Args),
    sync_game_state(NewState, Args),
    NewState.

%% -----------------------------------------------------------------
%%  游戏服连接上跨服中心，同步对应的信息
%% -----------------------------------------------------------------
center_connected(State, ServerId) ->
    #sanctuary_cls_state{is_open = IsOpen, start_time = StartTime, end_time = EndTime} = State,
    case get_group_state(ServerId, State) of
        false -> skip;
        GroupState ->
            ZoneId = lib_clusters_center_api:get_zone(ServerId),
            Args = [{group_state, GroupState}, {act_time, {IsOpen, StartTime, EndTime}}, {zone_id, ZoneId}],
            mod_clusters_center:apply_cast(ServerId, mod_sanctuary_cluster_local, update_info, [Args])
    end.

%% -----------------------------------------------------------------
%%  修复合服后的数据|移除被合走的服信息
%% -----------------------------------------------------------------
fix_merge_server_data(State0, SecSerId, _MainZoneId, _MainSerId) ->
    case get_group_state(SecSerId, State0) of
        false ->
            State0;
        GroupState ->
            #sanctuary_cls_state{server_infos = ServerInfos, server_group_map = ServerGroupMap} = State0,
            State = State0#sanctuary_cls_state{
                server_infos = lists:keydelete(SecSerId, #zone_base.server_id, ServerInfos),
                server_group_map = maps:remove(SecSerId, ServerGroupMap)
            },
            #sanctuary_group_state{
                server_zone = ServerZones, building_list = BuildingL,
                begin_scene_map = BeginSceneMap
            } = GroupState,
            NewServerZones = lists:keydelete(SecSerId, #zone_base.server_id, ServerZones),
            NBeginSceneMap = maps:remove(SecSerId, BeginSceneMap),
            F = fun(Building) ->
                case Building of
                    #sanctuary_building_state{last_bl_server = SecSerId} ->
                        Building#sanctuary_building_state{last_bl_server = 0};
                    #sanctuary_building_state{bl_server = SecSerId} ->
                        Building#sanctuary_building_state{bl_server = 0};
                    _ ->
                        Building
                end
            end,
            NewBuildingL = lists:map(F, BuildingL),
            NewGroupState = GroupState#sanctuary_group_state{
                server_zone = NewServerZones, building_list = NewBuildingL,
                begin_scene_map = NBeginSceneMap
            },
            save_group_state(NewGroupState, State)
    end.

%% -----------------------------------------------------------------
%%  服务器信息改变
%% -----------------------------------------------------------------
server_info_change(State, ServerId, Args) ->
    #sanctuary_cls_state{server_infos = ServerInfos} = State,
    F = fun({Key, Val}, ZoneBase) ->
        case Key of
            world_lv -> ZoneBase#zone_base{world_lv = Val};
            open_time -> ZoneBase#zone_base{time = Val};
            server_name -> ZoneBase#zone_base{server_name = Val};
            _ -> ZoneBase
        end
    end,
    F2 = fun(ZoneBase) ->
        ?IF(
            ZoneBase#zone_base.server_id == ServerId,
            lists:foldl(F, ZoneBase, Args),
            ZoneBase
        )
    end,
    NewServerInfos = lists:map(F2, ServerInfos),

    case get_group_state(ServerId, State) of
        false -> State;
        GroupState ->
            #sanctuary_group_state{server_zone = ServerZones} = GroupState,
            NewServerZones = lists:map(F2, ServerZones),
            NewGroupState = GroupState#sanctuary_group_state{server_zone = NewServerZones},
            sync_game_state(NewGroupState, [{zone_bases, NewServerZones}]),
            save_group_state(NewGroupState, State#sanctuary_cls_state{server_infos = NewServerInfos})
    end.

%% -----------------------------------------------------------------
%%  活动开始## 初始化建筑数据与怪物
%% -----------------------------------------------------------------
act_start(State, StartTime, EndTime, MonRebornTime) ->
    #sanctuary_cls_state{group_state_map = GroupStateMap} = State,
    NewGroupStateMap = maps:map(fun(K, V) -> init_group_state(K, V, MonRebornTime) end, GroupStateMap),
    sync_game_state(State, [{act_time, {1, StartTime, EndTime}}]),
    State#sanctuary_cls_state{
        group_state_map = NewGroupStateMap, is_open = 1,
        start_time = StartTime, end_time = EndTime,
        mon_reborn_time = MonRebornTime
    }.

init_group_state(_GroupId, GroupState, MonRebornTime) ->
    #sanctuary_group_state{san_type = Type, building_list = OBuildingL, server_zone = ServerZoneL} = GroupState,
    WorldLv = ulists:tuple_list_avg(9, ServerZoneL),
    SceneList = lib_sanctuary_cluster_util:get_scenes_by_santype(Type),
    F = fun(SceneId, AccBuildingL) ->
        BuildType = lib_sanctuary_cluster_util:get_building_type_by_scene(SceneId),
        case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, AccBuildingL) of
            false ->
                BuildType = lib_sanctuary_cluster_util:get_building_type_by_scene(SceneId),
                MonIdL = data_cluster_sanctuary:get_mon_by_scene(SceneId),
                MonStateL = lib_sanctuary_cluster_util:create_mon_init(MonIdL, WorldLv, MonRebornTime),
                [#sanctuary_building_state{ scene_id = SceneId, building_type = BuildType, mons_state = MonStateL }|AccBuildingL];
            BuildingState ->
                case BuildingState#sanctuary_building_state.mons_state of
                    [] ->
                        MonIdL = data_cluster_sanctuary:get_mon_by_scene(SceneId),
                        MonStateL = lib_sanctuary_cluster_util:create_mon_init(MonIdL, WorldLv, MonRebornTime);
                    MonStateL ->
                        skip
                end,
                [BuildingState#sanctuary_building_state{mons_state = MonStateL}|lists:keydelete(SceneId, #sanctuary_building_state.scene_id, AccBuildingL)]
        end
    end,
    BuildingL = lists:foldl(F, OBuildingL, SceneList),
    sync_game_state(GroupState, [{building_list, BuildingL}]),
    GroupState#sanctuary_group_state{building_list = BuildingL}.

%% -----------------------------------------------------------------
%%  活动结束，清空玩家
%% -----------------------------------------------------------------
act_end(State) ->
    #sanctuary_cls_state{zone_id = ZoneId, group_state_map = GroupStateMap} = State,
    F = fun(GroupId, GroupState) ->
        #sanctuary_group_state{building_list = BuildingL} = GroupState,
        F_clear =
            fun(BuildState) ->
                #sanctuary_building_state{clear_role_ref = Ref, scene_id = SceneId, join_map = JoinMap} = BuildState,
                lib_scene:clear_scene_room(SceneId, ZoneId, GroupId),
                util:cancel_timer(Ref),
                [mod_clusters_center:apply_cast(SerId, lib_sanctuary_cluster, clear_role, [RoleL, SceneId])||{SerId, RoleL}<-maps:to_list(JoinMap)],
                BuildState#sanctuary_building_state{clear_role_ref = [], join_map = #{}}
            end,
        NewBuildingL = lists:map(F_clear, BuildingL),
        GroupState#sanctuary_group_state{building_list = NewBuildingL}
    end,
    NewGroupStateMap = maps:map(F, GroupStateMap),
    State#sanctuary_cls_state{group_state_map = NewGroupStateMap}.

%% -----------------------------------------------------------------
%%  怪物复活
%% -----------------------------------------------------------------
mon_reborn(State, NextRebornTime) ->
    #sanctuary_cls_state{zone_id = ZoneId, group_state_map = GroupStateMap, server_group_map = ServerGroupMap} = State,
    NewGroupStateMap =
        maps:map(
            fun(GroupId, GroupState) ->
                do_mon_reborn(ZoneId, GroupId, GroupState, NextRebornTime)
            end,
            GroupStateMap),
    % 通知怪物刷新
    {ok, BinData} = pt_284:write(28413,[1]),
    LimitLv = data_cluster_sanctuary_m:get_san_value(open_lv),
    TvArgs = [all_lv, {LimitLv, 999}, BinData],
    F = fun(SerId, GId) ->
        case maps:get(GId, GroupStateMap, none) of
            #sanctuary_group_state{ is_reboot_reset = true} ->
                mod_clusters_center:apply_cast(SerId, lib_sanctuary_cluster, clear_round_score_after_mon_reborn, [TvArgs]);
            #sanctuary_group_state{ is_reboot_reset = false} ->
                mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_all, [all_lv, {LimitLv, 999}, BinData]);
            _ ->
                skip
        end
    end,
    [F(SerId, GId)||{SerId, GId}<-maps:to_list(ServerGroupMap)],

    SceneFun = fun(_GroupId, GroupState) ->
        #sanctuary_group_state{building_list = OBuildingL} = GroupState,
        case OBuildingL of
            [] ->
                GroupState;
            _ ->
                SceneFun2 = fun(BuildingState) ->
                    #sanctuary_building_state{ join_map = JoinMap} = BuildingState,
                    [mod_clusters_center:apply_cast(SerId, lib_sanctuary_cluster, notify_role_in_scene, [SceneRIds]) || {SerId, SceneRIds}<-maps:to_list(JoinMap)]
                end,
                lists:foreach(SceneFun2, OBuildingL),
                GroupState
        end
    end,
    spawn(
        fun() ->
            timer:sleep(1000),
            maps:map(SceneFun, NewGroupStateMap)
        end
    ),

    State#sanctuary_cls_state{
        group_state_map = NewGroupStateMap, is_open = 1,
        mon_reborn_time = NextRebornTime
    }.

do_mon_reborn(ZoneId, GroupId, GroupState0, NextRebornTime) ->
    #sanctuary_group_state{building_list = OBuildingL} = GroupState0,
    GroupState = ?IF(OBuildingL == [], init_group_state(GroupId, GroupState0, utime:unixtime()), GroupState0),
    #sanctuary_group_state{server_zone = ServerZoneL, building_list = BuildingL, is_reboot_reset = IsReset} = GroupState,
    WorldLv = ulists:tuple_list_avg(#zone_base.world_lv, ServerZoneL),
    F = fun(BuildingState) ->
        #sanctuary_building_state{
            scene_id = SceneId, bl_server = OBlSerId, last_bl_server = OLastBlSerId, mon_ids = LastMonIdL
        } = BuildingState,
        BuildType = lib_sanctuary_cluster_util:get_building_type_by_scene(SceneId),
        MonIdL = data_cluster_sanctuary:get_mon_by_scene(SceneId),
        case IsReset of
            true ->
                %% 此处
                db:execute(io_lib:format(?sql_delete_sanctuary_kf_role_rank_info, [ZoneId, SceneId, GroupId])),
                db:execute(io_lib:format(?SQL_DELETE_SERVER_BL, [ZoneId, SceneId, GroupId])),
                lib_mon:clear_scene_mon_by_mids(SceneId, ZoneId, GroupId, 1, MonIdL),
                MonStateL = lib_sanctuary_cluster_util:create_mon(MonIdL, SceneId, ZoneId, GroupId, WorldLv),
                LastBlSerId = ?IF(OBlSerId == 0, OLastBlSerId, OBlSerId),
                BuildingState#sanctuary_building_state{
                    building_type = BuildType, mons_state = MonStateL,
                    role_receives = [], server_score_map = #{},
                    bl_server = 0, last_bl_server = LastBlSerId, score_rank_map = #{}
                };
            _ ->
                %% 每次重新生成怪物后都清掉改段信息，因为按正常流程关闭服务时候，会再一次存储最新的形象到DB
                db:execute(io_lib:format(?SQL_DELETE_SERVER_BL, [ZoneId, SceneId, GroupId])),
                lib_mon:clear_scene_mon_by_mids(SceneId, ZoneId, GroupId, 1, LastMonIdL),
                NoLiveMonIdL = MonIdL -- LastMonIdL,   %% 已击杀的，初始化未未击杀
                NoLiveMonStateL = lib_sanctuary_cluster_util:create_mon_init(NoLiveMonIdL, WorldLv, NextRebornTime),
                LiveMonStateL = lib_sanctuary_cluster_util:create_mon(LastMonIdL, SceneId, ZoneId, GroupId, WorldLv),
                MonStateL = NoLiveMonStateL ++ LiveMonStateL,
                BuildingState#sanctuary_building_state{
                    building_type = BuildType, mons_state = lists:reverse(lists:keysort(#sanctuary_mon_state.mon_id, MonStateL))
                }
        end
    end,
    NewBuildingL = lists:map(F, BuildingL),
    sync_game_state(GroupState, [{building_list, NewBuildingL}]),
    GroupState#sanctuary_group_state{building_list = NewBuildingL, is_reboot_reset = true}.


%% -----------------------------------------------------------------
%%  玩家进入圣域场景
%% -----------------------------------------------------------------
enter(State, ServerId, RoleId, EnterSceneId, NeedOut, OldSceneId) ->
    #sanctuary_cls_state{is_open = IsOpen, zone_id = ZoneId} = State,
    case get_group_state(ServerId, State) of
        _ when IsOpen =/= 1 ->
            lib_sanctuary_cluster_util:send_error(ServerId, RoleId, ?ERRCODE(time_limit)),
            State;
        false ->
            State;
        GroupState ->
            #sanctuary_group_state{group_id = GroupId, begin_scene_map = BeginSceneMap, building_list = BuildList0} = GroupState,
            case can_enter(EnterSceneId, ServerId, BeginSceneMap, BuildList0) of
                false ->
                    lib_sanctuary_cluster_util:send_error(ServerId, RoleId, ?ERRCODE(can_not_enter)),
                    State;
                true ->
                    % 旧场景处理
                    case data_scene:get(OldSceneId) of
                        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} ->
                            OldSceneBuildingState = ulists:keyfind(OldSceneId, #sanctuary_building_state.scene_id, BuildList0, #sanctuary_building_state{}),
                            OldSceneJoinMap = remove_join_map(ServerId, RoleId, OldSceneBuildingState),
                            BuildList = lists:keystore(OldSceneId, #sanctuary_building_state.scene_id, BuildList0, OldSceneBuildingState#sanctuary_building_state{join_map = OldSceneJoinMap});
                        _ ->
                            BuildList = BuildList0
                    end,
                    ChangeSceneArgs = [RoleId, EnterSceneId, ZoneId, GroupId, NeedOut, [{group, 0},{pk, {?PK_SERVER, true}}, {camp, ServerId}, {action_free, ?ERRCODE(err284_enter_cluster)}]],
                    mod_clusters_center:apply_cast(ServerId, lib_sanctuary_cluster, player_change_scene, [RoleId, ChangeSceneArgs]),
                    BuildingState = ulists:keyfind(EnterSceneId, #sanctuary_building_state.scene_id, BuildList, #sanctuary_building_state{}),
                    #sanctuary_building_state{join_map = JoinMap} = BuildingState,
                    OldSerJoinL = maps:get(ServerId, JoinMap, []),
                    SerJoinL = [RoleId|lists:delete(RoleId, OldSerJoinL)],
                    NewJoinMap = JoinMap#{ServerId => SerJoinL},
                    NewBuildList = lists:keystore(EnterSceneId, #sanctuary_building_state.scene_id, BuildList,
                        BuildingState#sanctuary_building_state{join_map = NewJoinMap}),
                    NewGroupState = GroupState#sanctuary_group_state{building_list = NewBuildList},
                    sync_game_state(NewGroupState, [{join_map, {EnterSceneId, NewJoinMap}}]),
                    NewState = save_group_state(NewGroupState, State),
                    NewState
            end
    end.

can_enter(EnterSceneId, ServerId, BeginSceneMap, BuildList) ->
    F = fun(#sanctuary_building_state{bl_server = BlSerId, last_bl_server = LastBlSerId, scene_id = SceneId}, AccSceneL) ->
        case BlSerId == ServerId orelse (LastBlSerId == ServerId andalso BlSerId == 0) of
            true -> [data_cluster_sanctuary:get_can_enter_scenes(SceneId)] ++ AccSceneL;
            _ -> AccSceneL
        end
    end,
    BeginScene = maps:get(ServerId, BeginSceneMap, 0),
    CanSceneL = data_cluster_sanctuary:get_can_enter_scenes(BeginScene) ++
        lists:foldl(F, [], BuildList),
    lists:member(EnterSceneId, lists:flatten(CanSceneL)).

%% -----------------------------------------------------------------
%%  退出
%% -----------------------------------------------------------------
quit(State, ServerId, RoleId, QuitSceneId) ->
    case get_group_state(ServerId, State) of
        false -> State;
        GroupState ->
            #sanctuary_group_state{building_list = BuildList} = GroupState,
            case lists:keyfind(QuitSceneId, #sanctuary_building_state.scene_id, BuildList) of
                false -> State;
                BuildingState ->
                    NewJoinMap = remove_join_map(ServerId, RoleId, BuildingState),
                    NewBuildingState = BuildingState#sanctuary_building_state{join_map = NewJoinMap},
                    NewBuildL = lists:keystore(QuitSceneId, #sanctuary_building_state.scene_id, BuildList, NewBuildingState),
                    NewGroupState = GroupState#sanctuary_group_state{building_list = NewBuildL},
                    sync_game_state(NewGroupState, [{join_map, {QuitSceneId, NewJoinMap}}]),
                    NewState = save_group_state(NewGroupState, State),
                    NewState
            end
    end.

remove_join_map(ServerId, RoleId, BuildingState) ->
    #sanctuary_building_state{join_map = JoinMap} = BuildingState,
    RoleL = maps:get(ServerId, JoinMap, []),
    NRoleL = lists:delete(RoleId, RoleL),
    JoinMap#{ServerId => NRoleL}.


%% -----------------------------------------------------------------
%%  领取归属奖励
%% -----------------------------------------------------------------
get_bl_reward(State, ServerId, RoleId, SceneId) ->
    case get_group_state(ServerId, State) of
        false -> State;
        GroupState ->
            #sanctuary_group_state{building_list = BuildList, server_zone = ServerZoneL, san_type = SanType} = GroupState,
            case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildList) of
                false ->
                    lib_sanctuary_cluster_util:send_error(ServerId, RoleId, ?ERRCODE(not_achieve)),
                    State;
                BuildingState ->
                    #sanctuary_building_state{role_receives = RoleReceiveL, bl_server = BlSerId, building_type = BuildingType} = BuildingState,
                    HadRec = lists:member(RoleId, RoleReceiveL),
                    if
                        BlSerId =/= ServerId ->
                            lib_sanctuary_cluster_util:send_error(ServerId, RoleId, ?ERRCODE(not_achieve)),
                            State;
                        HadRec ->
                            lib_sanctuary_cluster_util:send_error(ServerId, RoleId, ?ERRCODE(has_recieve)),
                            State;
                        true ->
                            NRoleReceiveL = [RoleId|RoleReceiveL],
                            NewBuildingState = BuildingState#sanctuary_building_state{role_receives = NRoleReceiveL},
                            NewBuildL = lists:keystore(SceneId, #sanctuary_building_state.scene_id, BuildList, NewBuildingState),
                            NewGroupState = GroupState#sanctuary_group_state{building_list = NewBuildL},
                            sync_game_state(NewGroupState, [{role_receives, {SceneId, NRoleReceiveL}}]),
                            % 发送奖励
                            #zone_base{world_lv = WorldLv} = ulists:keyfind(ServerId, #zone_base.server_id, ServerZoneL, #zone_base{}),
                            Reward = data_cluster_sanctuary:get_reward_world_lv(WorldLv, BuildingType),
                            RewardArgs = [SanType, SceneId, BuildingType, BlSerId],
                            mod_clusters_center:apply_cast(ServerId, lib_sanctuary_cluster, role_send_bl_reward, [RoleId, Reward, RewardArgs]),

                            NewState = save_group_state(NewGroupState, State),
                            NewState
                    end
            end
    end.


%% -----------------------------------------------------------------
%%  怪物被击杀
%% -----------------------------------------------------------------
mon_be_killed(State, ServerId, BLWhoL, KList, SceneId, MonId) ->
    #sanctuary_cls_state{mon_reborn_time = MonRebornTime, zone_id = ZoneId} = State,
    case get_group_state(ServerId, State) of
        GroupState when is_record(GroupState, sanctuary_group_state) ->
            #sanctuary_group_state{building_list = BuildingL} = GroupState,
            case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL) of
                false -> State;
                BuildingState ->
                    NewGroupState = do_mon_be_killed(ZoneId, GroupState, BuildingState, BLWhoL, KList, SceneId, MonId, MonRebornTime),
                    NewState = save_group_state(NewGroupState, State),
                    NewState
            end;
        _ ->
            State
    end.

do_mon_be_killed(ZoneId, GroupState, BuildingState, BLWhoL, KList, SceneId, MonId, MonRebornTime) ->
    #sanctuary_group_state{
        building_list = BuildingL, group_id = GroupId, begin_scene_map = BeginSceneMap, server_zone = ServerZones
    } = GroupState,
    #sanctuary_building_state{
        mons_state = MonLState, building_type = BuildingType, bl_server = OBlServer,
        server_score_map = SerScoreMap, score_rank_map = RankMap
    } = BuildingState,
    #sanctuary_mon_state{mon_type = MonType} = MonState =
        ulists:keyfind(MonId, #sanctuary_mon_state.mon_id, MonLState, #sanctuary_mon_state{}),
    % 根据伤害排序
    % 1.伤害排序 2。 伤害汇总 （计算奖励需要判断当前伤害占总伤害的比例）
    HurtRoleL0 = lists:keysort(#mon_atter.hurt, KList),
    Fun = fun(Att, {Acc, TemTotal}) ->
        #mon_atter{id = TRoleId, server_id = TServerId, name = TRoleName, hurt = Hurt, server_num = ServerNum} = Att,
        {[{TServerId, ServerNum, TRoleId, TRoleName, Hurt}|Acc], Hurt+TemTotal}
    end,
    {HurtRoleL, TotalHurt} = lists:foldl(Fun, {[], 0}, HurtRoleL0),

    #base_san_mon_type{san_score = SanScore} = SanMonTypeCfg = data_cluster_sanctuary_m:get_mon_type(MonType, BuildingType),

    % 圣域积分归属
    [#mon_atter{server_id = BlSerId}|_] = BLWhoL,
    OldSanScore = maps:get(BlSerId, SerScoreMap, 0),
    NewSerScoreMap = SerScoreMap#{BlSerId => OldSanScore + SanScore},

    % 玩家击杀Boss回调，添加积分与奖励
    AngerLogArgs = [SceneId, BuildingType, MonId, MonType],
    RewardArgs = [SceneId, MonId],
    {NewRankMap, ChangeList} = role_kill_event(BLWhoL, HurtRoleL, TotalHurt, SanMonTypeCfg, {AngerLogArgs, RewardArgs}, RankMap, SceneId, OBlServer),

    % 计算怪物状态|重生时间，记录击杀日志
    NMonState = calc_mon_state(HurtRoleL, MonState, MonRebornTime, GroupId, SceneId),
    NewMonLState = lists:keystore(MonId, #sanctuary_mon_state.mon_id, MonLState, NMonState),

    SyncArgs0 = [{mon, {SceneId, NMonState}}, {score_map, {SceneId, NewSerScoreMap}}],

    NewBuildingState = BuildingState#sanctuary_building_state{mons_state = NewMonLState, server_score_map = NewSerScoreMap, score_rank_map = NewRankMap},
    case calc_building_belong_status(NewBuildingState) of
        {true, BelongSerId} ->
            SyncArgs = [{bl_server, {SceneId, BelongSerId}}|SyncArgs0],
            %% after 会有一个入库操作
            {NewBuildingL, LastRankMap} = after_occupy_building(ZoneId, GroupId, BuildingL, NewBuildingState, BelongSerId, BeginSceneMap, ServerZones, BeginSceneMap),
            LastSyncArgs = [{score_rank_map, {SceneId, LastRankMap}}|SyncArgs];
        _ ->
            LastSyncArgs = [{score_rank_map, {SceneId, NewRankMap}}|SyncArgs0],
            BelongSerId = 0,
            ChangeList =/= [] andalso lib_sanctuary_cluster_util:db_save_role_rank_info_list(ChangeList, ZoneId, GroupId, SceneId),
            NewBuildingL = lists:keystore(SceneId, #sanctuary_building_state.scene_id, BuildingL, NewBuildingState)
    end,
    %% 同步信息到游戏服
    sync_game_state(GroupState, LastSyncArgs),

    % 通知归属服占领信息
    LimitLv = data_cluster_sanctuary_m:get_san_value(open_lv),
    {ok, BinData2} = pt_284:write(28423, [SceneId]),
    ?IF(BelongSerId > 0, mod_clusters_center:apply_cast(BelongSerId, lib_server_send, send_to_all, [all_lv, {LimitLv, 9999}, BinData2]), ok),

    {ok, Bin} = pt_284:write(28416, [MonId, MonRebornTime]),
    lib_server_send:send_to_scene(SceneId, ZoneId, GroupId, Bin),

    GroupState#sanctuary_group_state{building_list = NewBuildingL}.

%% 玩家击杀/归属事件
%% 1. 满足伤害比例者添加积分
%% 2. 归属方添加怒气
%% 3，所有参与伤害着获取勋章奖励
role_kill_event(BLWhoL, HurtRoleL, TotalHurt, SanMonTypeCfg, {AngerLogArgs, RewardArgs}, RankMap, SceneId, OBlServer) ->
    #base_san_mon_type{score = MaxRScore, min_score = MinRScore, anger = RAnger, medal = MedalR} = SanMonTypeCfg,
    {RoleAddScoreMap, NewRankMap, ChangeList} = calc_role_add_score(HurtRoleL, TotalHurt, MaxRScore, MinRScore, RankMap, utime:unixtime(), [], OBlServer),
    F = fun({SerId, RoleScoreL}) -> mod_clusters_center:apply_cast(SerId, lib_sanctuary_cluster, role_add_score, [RoleScoreL, SceneId]) end,
    lists:foreach(F, maps:to_list(RoleAddScoreMap)),
    F2 = fun(#mon_atter{server_id = BlSerId, id = BlRId}, AccMap) ->
        L = [BlRId|maps:get(BlSerId, AccMap, [])],
        AccMap#{BlSerId => L}
    end,
    maps:map(
        fun(BlSerId, RIdL) ->
            mod_clusters_center:apply_cast(BlSerId, lib_sanctuary_cluster, role_add_anger_kill_event, [RIdL, RAnger, AngerLogArgs])
        end,
    lists:foldl(F2, #{}, BLWhoL)),

    F3 = fun({SerId, _SerNum, RId, _RName, _RHurt}, AccMap) ->
        L = [RId|maps:get(SerId, AccMap, [])],
        AccMap#{SerId => L}
    end,
    maps:map(
        fun(SerId, RIdL) ->
            mod_clusters_center:apply_cast(SerId, lib_sanctuary_cluster, role_send_medal, [RIdL, MedalR, RewardArgs])
        end,
    lists:foldl(F3, #{}, HurtRoleL)),
    {NewRankMap, ChangeList}.

% 计算每个参与伤害的玩家积分获取
calc_role_add_score(_HurtRoleL, 0, _MaxRScore, _MinRScore, RankMap, _Time, ChangeList, _OBlServer) ->
    {{}, RankMap, ChangeList};
calc_role_add_score(HurtRoleL, TotalHurt, MaxRScore, MinRScore, RankMap, Time, ChangeList, OBlServer) ->
    NeedRatio = data_cluster_sanctuary_m:get_san_value(min_score_get_hurt_limit) * 100,
    F = fun({SerId, _SerNum, RId, RName, RHurt}, {AccMap, AccRankMap, AccChangeList}) ->
        HurtRatio = RHurt / TotalHurt * 10000,
        if
            HurtRatio > NeedRatio ->
                AddScore = round(max(MinRScore, HurtRatio * MaxRScore / 10000)),
                RScoreL = [{RId, AddScore}|maps:get(SerId, AccMap, [])],
                NewAccMap = AccMap#{SerId => RScoreL},
                case OBlServer > 0 of
                    false ->
                        %% 更新个人积分榜单数据
                        SerRoleList = maps:get(SerId, AccRankMap, []),
                        case lists:keyfind(RId, #sanctuary_kf_role_rank_info.player_id, SerRoleList) of
                            #sanctuary_kf_role_rank_info{ score = OldScore } = RankInfo ->
                                NewRoleInfo = RankInfo#sanctuary_kf_role_rank_info{score = OldScore + AddScore, last_time = Time};
                            _ ->
                                NewRoleInfo = #sanctuary_kf_role_rank_info{
                                    player_id = RId, player_name = RName, server_id = SerId, score = AddScore, last_time = Time
                                }
                        end,
                        NewSerRoleList = lists:keystore(RId, #sanctuary_kf_role_rank_info.player_id, SerRoleList, NewRoleInfo),
                        NewAccRankMap = AccRankMap#{SerId => NewSerRoleList},
                        NewAccChangeList = [NewRoleInfo|AccChangeList];
                    true ->
                        NewAccChangeList = AccChangeList,
                        NewAccRankMap = AccRankMap
                end,
                {NewAccMap, NewAccRankMap, NewAccChangeList};
            true ->
                {AccMap, AccRankMap, AccChangeList}
        end
    end,
    lists:foldl(F, {#{}, RankMap, ChangeList}, HurtRoleL).

%% 计算怪物重生时间
calc_mon_state(HurtRoleL, MonState, MonRebornTime, GroupId, SceneId) ->
    #sanctuary_mon_state{mon_type = MonType, mon_id = MonId, kill_log = KillLog} = MonState,
    KillNum = data_cluster_sanctuary_m:get_san_value(kill_log_num),
    % 取伤害最高的玩家作为击杀者记录
    [{KSerId, KSerName, KRId, KRName, _}|_] = HurtRankL = lists:sublist(HurtRoleL, KillNum),

    NewKillLog = [{KSerId, KSerName, KRId, KRName, utime:unixtime()}|KillLog],

    % 和平怪有自己的复活倒计时
    case lists:member(MonType, ?PEACE_MON_TYPE_L) of
        true ->
            #base_san_mon{reborn = RebornS} = data_cluster_sanctuary:get_mon_cfg(MonId),
            NewRebornTime = utime:unixtime() + RebornS,
            Ref = util:send_after(MonState#sanctuary_mon_state.reborn_ref, max(RebornS * 1000, 100), self(), {'peace_mon_reborn', GroupId, SceneId, MonId}),
            NMonState = MonState#sanctuary_mon_state{reborn_ref = Ref, reborn_time = NewRebornTime, rank_list = HurtRankL, kill_log = NewKillLog};
        _ ->
            NMonState = MonState#sanctuary_mon_state{reborn_time = MonRebornTime, rank_list = HurtRankL, kill_log = NewKillLog}
    end,

    NMonState.

%% 根据剩余未获取的积分
calc_building_belong_status(BuildingState) when BuildingState#sanctuary_building_state.bl_server =/= 0 ->
    false;
calc_building_belong_status(BuildingState) ->
    #sanctuary_building_state{server_score_map = ServerScoreMap, mons_state = MonStateL, building_type = BuildingType} = BuildingState,
    RankScoreL = lists:reverse(lists:keysort(2, maps:to_list(ServerScoreMap))),
    case RankScoreL of
        [{SerId1, Score1}] -> Score2 = 0;
        [{SerId1, Score1}, {_, Score2}|_] -> ok
    end,
    % 获取圣域未获取的积分
    F = fun(#sanctuary_mon_state{reborn_time = RebornTime, mon_type = MonType}, AccScore) ->
        case RebornTime of
            0 ->
                #base_san_mon_type{san_score = SanScore} = data_cluster_sanctuary_m:get_mon_type(MonType, BuildingType),
                AccScore + SanScore;
            _ ->
                AccScore
        end
    end,
    RemainScore = lists:foldl(F, 0, MonStateL),
    case Score1 - Score2 >= RemainScore of
        true ->  {true, SerId1};
        _ -> false
    end.

%% 建筑占领后的后续处理
%% 注意：A（要塞） -> B（城堡） -> C（圣域） 是上次占领的话。假如C （圣域）一开始就占领了， 后续B（城堡）被人占领也会踢C（圣域）,且不能进入
after_occupy_building(ZoneId, GroupId, BuildingL, BuildingState, BelongSerId, BeginSceneMap, ServerZones, BeginSceneMap) ->
    #sanctuary_building_state{
        scene_id = SceneId, score_rank_map = RankMap, mons_state = MonStateL, server_score_map = ServerScoreMap,
        clear_role_ref = ORef, building_type = BuildingType, join_map = JoinMap, role_receives = RoleReceives, last_bl_server = Lbs
    } = BuildingState,
    util:cancel_timer(ORef),
    % 通知归属服占领信息
    _LimitLv = data_cluster_sanctuary_m:get_san_value(open_lv),
    {ok, BinData} = pt_284:write(28411, [SceneId, BuildingType]),
    %% 20220905, 客户端要求28411只发给场景内的玩家
    %% mod_clusters_center:apply_cast(BelongSerId, lib_server_send, send_to_all, [all_lv, {LimitLv, 9999}, BinData]),、
    [mod_clusters_center:apply_cast(SerId, lib_sanctuary_cluster, send_28411_bin_data, [ClearRIds, BinData])||
        {SerId, ClearRIds}<-maps:to_list(JoinMap)],
    {NeedClearSceneL, Ref} = calc_clear_info(GroupId, BuildingL, BuildingState, BelongSerId),

    SaveMonIdL = [MonState#sanctuary_mon_state.mon_id
        || MonState <- MonStateL, MonState#sanctuary_mon_state.reborn_time =< 0],
    ServerScoreL = maps:to_list(ServerScoreMap),
    db:execute(io_lib:format(?SQL_REPLACE_SERVER_BL, [ZoneId, GroupId, SceneId, BelongSerId,
          util:term_to_bitstring(SaveMonIdL), 0, util:term_to_bitstring(ServerScoreL), util:term_to_bitstring(RoleReceives), Lbs])),

    lib_log_api:log_cluster_sanctuary_occupy(ZoneId, BelongSerId, SceneId),

    Sec = data_cluster_sanctuary_m:get_san_value(clear_role_after_scene_bl),
    %% 被占领后，剔除非占领服的榜单数据
    BaseRankList = lib_sanctuary_cluster_util:sort_score_rank_list(lists:sublist(maps:get(BelongSerId, RankMap, []), 5)),
    RankList = lists:keysort(#sanctuary_kf_role_rank_info.rank, BaseRankList),
    %% 补充：清理数据内非占领服的玩家排名数据
    lib_sanctuary_cluster_util:db_save_role_rank_info_list(RankList, ZoneId, GroupId, SceneId),
    db:execute(io_lib:format(?sql_delete_no_right_player_score_rank_info, [ZoneId, SceneId, GroupId, BelongSerId])),

    NewBuildingState = BuildingState#sanctuary_building_state{
        clear_role_ref = Ref, bl_server = BelongSerId, last_bl_server = 0, score_rank_map = #{BelongSerId => RankList}
    },
    NewBuildingL = lists:keystore(SceneId, #sanctuary_building_state.scene_id, BuildingL, NewBuildingState),

    %% 给同一组的其他服务器发布公告
    case RankList of
        [] ->
            skip;
        _ ->
            case lists:keyfind(1, #sanctuary_kf_role_rank_info.rank, RankList) of
                #sanctuary_kf_role_rank_info{ score = HdScore, player_name = HdPlayerName, server_id = HdServerId } ->
                    #zone_base{ server_name = HdServerName, server_num = _HdServerNum } = lists:keyfind(HdServerId, #zone_base.server_id, ServerZones),
                    #base_san_cons{name = BuildName } = data_cluster_sanctuary:get_construction_info(BuildingType),
                    Args = [HdPlayerName, HdScore, HdServerName, BuildName],
                    TvArgs = [{all}, ?MOD_C_SANCTUARY, 4, Args],
                    [mod_clusters_center:apply_cast(TvServerId, lib_chat, send_TV, TvArgs)|| #zone_base{ server_id = TvServerId } <- ServerZones];
                _ ->
                    skip
            end
    end,

    %% 给场景内的玩家推送榜单信息
    SendRankFun = fun(RankInfo) ->
        #sanctuary_kf_role_rank_info{
            player_id = PlayerId, player_name = PlayerName, server_id = ServerId,
            score = Score, kill_num = KillNum, rank = Rank
        } = RankInfo,
        #zone_base{ server_num = ServerNum } = lists:keyfind(ServerId, #zone_base.server_id, ServerZones),
        {PlayerId, PlayerName, ServerId, ServerNum, Score, KillNum, Rank}
    end,
    SendRankList = lists:map(SendRankFun, RankList),
    BlScene = maps:get(BelongSerId, BeginSceneMap, 0),
    {ok, BinData2} = pt_284:write(28421, [SceneId, BlScene, SendRankList]),
    %% ?INFO("28421:~p~n~p~n~p", [SceneId, JoinMap, RankList]),
    [mod_clusters_center:apply_cast(SerId, lib_sanctuary_cluster, notify_score_rank_list, [ClearRIds, BinData2])||
        {SerId, ClearRIds}<-maps:to_list(JoinMap)],

    % 通知玩家将被提出场景
    F = fun(ClearSId) ->
        #sanctuary_building_state{join_map = ClearJoinMap} =
            ulists:keyfind(ClearSId, #sanctuary_building_state.scene_id, BuildingL, #sanctuary_building_state{}),
        [mod_clusters_center:apply_cast(SerId, lib_sanctuary_cluster, notify_clear_scene, [ClearRIds, Sec])||
            {SerId, ClearRIds}<-maps:to_list(ClearJoinMap), SerId =/= BelongSerId andalso
            not can_enter(ClearSId, SerId, BeginSceneMap, NewBuildingL)]
    end,
    lists:foreach(F, NeedClearSceneL),

    {NewBuildingL, #{BelongSerId => RankList}}.

calc_clear_info(GroupId, BuildingL, BuildingState, BelongSerId) ->
    #sanctuary_building_state{
        last_bl_server = LastBlSerId, scene_id = SceneId,
        clear_role_ref = ORef
    } = BuildingState,
    Sec = data_cluster_sanctuary_m:get_san_value(clear_role_after_scene_bl),
    if
        BelongSerId =/= LastBlSerId ->
            %% 特殊处理，存在两个圣域能互通的情况，如果两个互通的圣域被同一个服务器占领了
            %% 旧的配置格式有点拉胯，特殊处理，如果这块代码看不懂去找策划对对逻辑
            case lib_sanctuary_cluster_util:get_link_enter_scenes(SceneId) of
                [] ->
                    case data_cluster_sanctuary:get_can_enter_scenes(SceneId) of
                        [ClearScene] ->
                            #sanctuary_building_state{bl_server = OtherBlSerId, last_bl_server = OtherLastBlSerId} = ulists:keyfind(ClearScene,
                                #sanctuary_building_state.scene_id, BuildingL, #sanctuary_building_state{}),
                            IsSatisfy = OtherBlSerId == BelongSerId orelse OtherLastBlSerId == BelongSerId,
                            case lib_sanctuary_cluster_util:get_building_type_by_scene(ClearScene) of
                                ?CONS_TYPE_3 when IsSatisfy ->
                                    NeedClearSceneL = [ClearScene],
                                    Ref = util:send_after(ORef, Sec * 1000, self(), {'clear_role', GroupId, NeedClearSceneL, BelongSerId});
                                _ ->
                                    NeedClearSceneL = [], Ref = []
                            end;
                        _ ->
                            NeedClearSceneL = [], Ref = []
                    end;
                NeedClearSceneL ->
                    Ref = util:send_after(ORef, Sec * 1000, self(), {'clear_role', GroupId, NeedClearSceneL, BelongSerId})
            end;
        true ->
            NeedClearSceneL = [], Ref = []
    end,
    {NeedClearSceneL, Ref}.


%% -----------------------------------------------------------------
%%  清理玩家
%% -----------------------------------------------------------------
clear_role(State, GroupId, NeedClearSceneL, BelongSerId) ->
    #sanctuary_cls_state{group_state_map = GroupStateMap} = State,
    case maps:get(GroupId, GroupStateMap, false) of
        false -> State;
        GroupState ->
            #sanctuary_group_state{building_list = BuildingL, begin_scene_map = BeginSceneMap} = GroupState,
            F_filter = fun({SerId, _RoleL}) -> SerId =/= BelongSerId end,
            F = fun(BuildingState) ->
                #sanctuary_building_state{join_map = JoinMap, scene_id = SceneId} = BuildingState,
                case lists:member(SceneId, NeedClearSceneL) of
                    true ->
                        {LeaveJoinMapL, NewJoinMapL} = lists:partition(F_filter, maps:to_list(JoinMap)),
                        F_clear = fun({SerId, RoleL}) ->
                            can_enter(SceneId, SerId, BeginSceneMap, BuildingL) == false andalso
                                mod_clusters_center:apply_cast(SerId, lib_sanctuary_cluster, clear_role, [RoleL, SceneId])
                        end,
                        lists:foreach(F_clear, LeaveJoinMapL),
                        NewJoinMap = maps:from_list(NewJoinMapL),
                        BuildingState#sanctuary_building_state{join_map = NewJoinMap};
                    _ ->
                        BuildingState
                end
            end,
            NewBuildingL = lists:map(F, BuildingL),
            NewGroupState = GroupState#sanctuary_group_state{building_list = NewBuildingL},
            save_group_state(NewGroupState, State)
    end .

%% -----------------------------------------------------------------
%%  和平怪复活
%% -----------------------------------------------------------------
peace_mon_reborn(State, GroupId, SceneId, MonId) ->
    #sanctuary_cls_state{group_state_map = GroupStateMap, zone_id = ZoneId, server_infos = ServerZoneL} = State,
    case maps:get(GroupId, GroupStateMap, false) of
        false -> State;
        GroupState ->
            #sanctuary_group_state{building_list = BuildingL} = GroupState,
            BuildingState = lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL),
            #sanctuary_building_state{mons_state = MonStateL} = BuildingState,
            case lists:keyfind(MonId, #sanctuary_mon_state.mon_id, MonStateL) of
                false -> State;
                MonState ->
                    #sanctuary_mon_state{reborn_ref = RebornRef} = MonState,
                    util:cancel_timer(RebornRef),
                    WorldLv = ulists:tuple_list_avg(9, ServerZoneL),
                    #base_san_mon{type = MonType, x = X, y = Y} = data_cluster_sanctuary:get_mon_cfg(MonId),
                    lib_mon:sync_create_mon(MonId, SceneId, ZoneId, X, Y, 0, GroupId, 1, [{auto_lv, WorldLv}, {type, MonType}]),
                    NMonState = MonState#sanctuary_mon_state{reborn_ref = [], reborn_time = 0},

                    {ok, Bin} = pt_284:write(28416, [MonId, 0]),
                    lib_server_send:send_to_scene(SceneId, ZoneId, GroupId, Bin),

                    NMonStateL = lists:keystore(MonId, #sanctuary_mon_state.mon_id, MonStateL, NMonState),
                    NBuildingState = BuildingState#sanctuary_building_state{mons_state = NMonStateL},
                    NewBuildingL = lists:keystore(SceneId, #sanctuary_building_state.scene_id, BuildingL, NBuildingState),
                    NewGroupState = GroupState#sanctuary_group_state{building_list = NewBuildingL},
                    save_group_state(NewGroupState, State)
            end
    end .

%% 击杀敌对玩家
kill_player(SceneId, ZoneId, AttrServerId, AttrRoleId, AttrName, RoleScore, RoleKillNum, State) ->
    #sanctuary_cls_state{zone_id = ZoneId} = State,
    case get_group_state(AttrServerId, State) of
        GroupState when is_record(GroupState, sanctuary_group_state) ->
            #sanctuary_group_state{building_list = BuildingL} = GroupState,
            case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL) of
                false -> State;
                BuildingState ->
                    NewGroupState = do_kill_player(GroupState, BuildingState, AttrRoleId, AttrName, SceneId, AttrServerId, ZoneId, RoleScore, RoleKillNum),
                    NewState = save_group_state(NewGroupState, State),
                    NewState
            end;
        _ ->
            State
    end.

do_kill_player(GroupState, BuildingState, AttrRoleId, AttrName, SceneId, AttrServerId, ZoneId, RoleScore, RoleKillNum) ->
    #sanctuary_group_state{building_list = BuildingL, group_id = GroupId} = GroupState,
    #sanctuary_building_state{ score_rank_map = RankMap } = BuildingState,
    KillPlayerScore = data_cluster_sanctuary_m:get_san_value(auction_kill_player_add),
    %% 计算累加的个人积分，并进行回调
    mod_clusters_center:apply_cast(AttrServerId, lib_sanctuary_cluster, kill_player, [[{AttrRoleId, KillPlayerScore}], SceneId]),
    %% 更新榜单数据
    RankList = maps:get(AttrServerId, RankMap, []),
    case lists:keyfind(AttrRoleId, #sanctuary_kf_role_rank_info.player_id, RankList) of
        #sanctuary_kf_role_rank_info{ score = OldScore, kill_num = OldKillNum } = RankInfo ->
            NewRankInfo = RankInfo#sanctuary_kf_role_rank_info{
                score = OldScore + KillPlayerScore, kill_num = OldKillNum + 1, last_time = utime:unixtime()
            };
        _ ->
            NewRankInfo = #sanctuary_kf_role_rank_info{
                player_id = AttrRoleId, player_name = AttrName, server_id = AttrServerId,
                score = RoleScore + KillPlayerScore, last_time = utime:unixtime(), kill_num = RoleKillNum + 1
            }
    end,
    NewRankList = lists:keystore(AttrRoleId, #sanctuary_kf_role_rank_info.player_id, RankList, NewRankInfo),
    lib_sanctuary_cluster_util:db_save_role_rank_info_list([NewRankInfo], ZoneId, GroupId, SceneId),
    NewRankMap = RankMap#{ AttrServerId => NewRankList},
    NewBuildingState = BuildingState#sanctuary_building_state{ score_rank_map = NewRankMap},
    NewBuildingL = lists:keystore(SceneId, #sanctuary_building_state.scene_id, BuildingL, NewBuildingState),
    SyncArgs = [{score_rank_map, {SceneId, NewRankMap}}],
    %% 同步信息到游戏服
    sync_game_state(GroupState, SyncArgs),
    GroupState#sanctuary_group_state{building_list = NewBuildingL}.

