%% ---------------------------------------------------------------------------
%% @doc mod_sanctuary_cluster

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/9/3 0003
%% @desc
%% ---------------------------------------------------------------------------
-module(mod_sanctuary_cluster).

-behaviour(gen_server).

%% API
-export([
      start_link/4
    , update_info/2
    , center_connected/2
    , fix_merge_server_data/4
    , server_info_change/2
    , zone_change/4
    , act_start/4
    , act_end/1
    , mon_reborn/2
    , enter/6
    , quit/4
    , get_bl_reward/4
    , mon_be_killed/8
    , kill_player/7
    , process_stop/1
]).

-export([call/2, cast/2, info/2]).

%% gen_server callbacks

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-include("common.hrl").
-include("clusters.hrl").
-include("def_fun.hrl").
-include("def_gen_server.hrl").
-include("cluster_sanctuary.hrl").

%% ===========================
%%  Function Need Export
%% ===========================
start_link(ZoneId, ServerInfos, GroupInfo, ZoneGSceneMap) ->
    ProcessName = lib_sanctuary_cluster_util:get_process_name(ZoneId),
    Pid = whereis(ProcessName),
    case misc:is_process_alive(Pid) of
        true ->
            gen_server:cast(Pid, {'reload', ZoneId, ServerInfos, GroupInfo, ZoneGSceneMap}),
            {ok, Pid};
        _ ->
            gen_server:start_link({local, ProcessName}, ?MODULE, [ZoneId, ServerInfos, GroupInfo, ZoneGSceneMap], [])
    end.

update_info(Pid, Args) ->
    gen_server:cast(Pid, {'update_info', Args}).

% 游戏服成功连接跨服中心，信息再次同步，确保一致
center_connected(ZoneId, ServerId) ->
    Pid = lib_sanctuary_cluster_util:get_process(ZoneId),
    case misc:is_process_alive(Pid) of
        true ->
            gen_server:cast(Pid, {'center_connected', ServerId});
        _ ->
            skip
    end.

% 修正合服后的数据
fix_merge_server_data(SecZoneId, SecSerId, MainZoneId, MainSerId) ->
    cast(SecZoneId, {'fix_merge_server_data', SecSerId, MainZoneId, MainSerId}).

% 服务器信息更改# 开服第一天时会pid会不存在，不走通用cast避免输出错误
server_info_change(ServerId, Args) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    Pid = lib_sanctuary_cluster_util:get_process(ZoneId),
    case misc:is_process_alive(Pid) of
        true ->
            gen_server:cast(Pid, {'server_info_change', ServerId, Args});
        _ ->
            skip
    end.

% 分区改变, 重置对应的分区的活动情况
zone_change(OldZoneId, OZoneGroupInfo, NewZoneId, NZoneGroupInfo) ->
    cast(OldZoneId, {'zone_change', OZoneGroupInfo}),
    cast(NewZoneId, {'zone_change', NZoneGroupInfo}).

%% 活动开始
act_start(Pid, StartTime, EndTime, MonRebornTime) ->
    gen_server:cast(Pid, {'act_start', StartTime, EndTime, MonRebornTime}).

act_end(Pid) ->
    gen_server:cast(Pid, 'act_end').

mon_reborn(Pid, NextRebornTime) ->
    gen_server:cast(Pid, {'mon_reborn', NextRebornTime}).

%% 进入场景
enter(ZoneId, ServerId, RoleId, SceneId, NeedOut, OldSceneId) ->
    cast(ZoneId, {'enter', ServerId, RoleId, SceneId, NeedOut, OldSceneId}).

quit(ZoneId, ServerId, RoleId, SceneId) ->
    cast(ZoneId, {'quit', ServerId, RoleId, SceneId}).

get_bl_reward(ZoneId, ServerId, RoleId, SceneId) ->
    cast(ZoneId, {'get_bl_reward', ServerId, RoleId, SceneId}).

mon_be_killed(ZoneId, ServerId, BLWhos, KList, SceneId, Mid, _AtterId, _AtterName) ->
    cast(ZoneId, {'mon_be_killed', ServerId, BLWhos, KList, SceneId, Mid}).

%% 击杀了敌对玩家
kill_player(SceneId, ScenePId, AttrServerId, AttrRoleId, AttrName, RoleScore, RoleKillNum) ->
    cast(ScenePId, {'kill_player', SceneId, ScenePId, AttrServerId, AttrRoleId, AttrName, RoleScore, RoleKillNum}).

process_stop(Pid) ->
    gen_server:call(Pid, {'process_stop'}, 2000).

call(ZoneId, Msg) ->
    Pid = lib_sanctuary_cluster_util:get_process(ZoneId),
    case misc:is_process_alive(Pid) of
        true ->
            gen_server:call(Pid, Msg);
        _ ->
            ?ERR("call to mod_sanctuary_cluster occor a error, ZoneId: ~p ; Msg ~p ~n", [ZoneId, Msg]),
            skip
    end.

cast(ZoneId, Msg) ->
    Pid = lib_sanctuary_cluster_util:get_process(ZoneId),
    case misc:is_process_alive(Pid) of
        true ->
            gen_server:cast(Pid, Msg);
        _ ->
            ?ERR("cast to mod_sanctuary_cluster occor a error, ZoneId: ~p ; Msg ~p ~n", [ZoneId, Msg]),
            skip
    end.

info(ZoneId, Msg) ->
    Pid = lib_sanctuary_cluster_util:get_process(ZoneId),
    case misc:is_process_alive(Pid) of
        true ->
            Pid ! Msg;
        _ ->
            ?ERR("info to mod_sanctuary_cluster occor a error, ZoneId: ~p ; Msg ~p ~n", [ZoneId, Msg]),
            skip
    end.


%% ===========================
%% gen_server callbacks temples
%% ===========================
init(Args) ->
    %% process_flag(trap_exit, true), 改用mod_sanctuary_cluster_mgr:process_stop()来调用
    ?DO_INIT(Args).
handle_call(Request, From, State) ->
    ?DO_HANDLE_CALL(Request, From, State).
handle_cast(Msg, State) ->
    ?DO_HANDLE_CAST(Msg, State).
handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State).
terminate(Reason, State) ->
    ?DO_TERMINATE(Reason, State).
code_change(OldVsn, State, Extra) ->
    ?DO_CODE_CHANGE(OldVsn, State, Extra).

%% =============================
%% gen_server callbacks
%% =============================

do_init([ZoneId, ServerInfos, GroupInfo, ZoneGSceneMap]) ->

    List = db:get_all(io_lib:format(?SQL_SELECT_SERVER_BL, [ZoneId])),
    SceneBlSerMap = maps:from_list([
        {{GroupId, SceneId},
            {BlSerId, util:bitstring_to_term(MonIdL), LastStopTime, util:bitstring_to_term(ServerScoreL),  util:bitstring_to_term(RoleReceives), LastBlServer}
        }||[GroupId, SceneId, BlSerId, MonIdL, LastStopTime, ServerScoreL, RoleReceives, LastBlServer] <- List]),

    %% 个人积分榜单数据
    BaseRankInfoL = db:get_all(io_lib:format(?sql_select_player_score_rank_info, [ZoneId])),
    AllRankInfoMap = lib_sanctuary_cluster_util:make_sanctuary_kf_role_rank_info(BaseRankInfoL, []),

    #zone_group_info{server_group_map = ServerGroupMap, group_mod_servers = GroupModServers} = GroupInfo,
    % 初始化GroupStateMap
    F = fun(#zone_mod_group_data{mod = Mod, server_ids = ServerIds, group_id = GroupId}, {AccStateMap, ReplaceArgs}) ->
        case Mod of
            1 -> {AccStateMap, ReplaceArgs};
            _ ->
                SanType = case Mod of 2 ->?SANTYPE_1; 4 -> ?SANTYPE_2; 8 -> ?SANTYPE_3 end,
                ServerZones = [Server||Server<-ServerInfos, lists:member(Server#zone_base.server_id, ServerIds)],

                {LastSerIds, LastSceneMap, Time} = maps:get({ZoneId, GroupId}, ZoneGSceneMap, {[], #{}, 0}),
                % 获取上次的出生点状态，如果分组服务器没有变化，分配时间小于配置时间，则不重新分配出生点
                Day = data_cluster_sanctuary_m:get_san_value(random_time),
                NowTime = utime:unixtime(),
                case ServerIds == LastSerIds of
                    true when NowTime - Time < Day * ?ONE_DAY_SECONDS ->
                        IsReset = false,
                        NewReplaceArgs = ReplaceArgs,
                        BeginSceneMap = LastSceneMap;
                    _ ->
                        IsReset = true,
                        BeginSceneL = data_cluster_sanctuary_m:get_begin_scene(SanType),
                        F2 = fun(SerId, {[Scene|H], AccMap}) -> {H, AccMap#{SerId => Scene}} end,
                        {_, BeginSceneMap} = lists:foldl(F2, {ulists:list_shuffle(BeginSceneL), #{}}, ServerIds),
                        NewReplaceArgs = [[ZoneId, GroupId, util:term_to_string(ServerIds), util:term_to_string(BeginSceneMap), NowTime]|ReplaceArgs]
                end,

                SceneList = lib_sanctuary_cluster_util:get_scenes_by_santype(SanType),
                F = fun(SceneId) ->
                    BuildType = lib_sanctuary_cluster_util:get_building_type_by_scene(SceneId),
                    case IsReset of
                        true ->
                            SortRoleRankMap = #{}, BlSerId = 0, LastMonIdL = [], NewLastBlSerId = 0, ServerScoreMap = #{}, LastRoleReceives = [];
                        _ ->
                            {BaseBlSerId, MonIdL, LastStopTime, ServerScoreL, RoleReceives, LastBlServer} = maps:get({GroupId, SceneId}, SceneBlSerMap, {0, [], 0, [], [], 0}),
                            LastRefreshTime = lib_sanctuary_cluster_util:calc_next_mon_time(LastStopTime),
                            case NowTime >= LastRefreshTime orelse LastStopTime == 0 of
                                true ->
                                    NewLastBlSerId = BaseBlSerId, SortRoleRankMap = #{}, BlSerId = 0,
                                    LastRoleReceives = [], ServerScoreMap = #{},
                                    LastMonIdL = data_cluster_sanctuary:get_mon_by_scene(SceneId);
                                _ ->
                                    RoleRankList = maps:get({GroupId, SceneId}, AllRankInfoMap, []),
                                    RoleRankMap = ulists:group(#sanctuary_kf_role_rank_info.server_id, RoleRankList),
                                    SortRoleRankMap = lib_sanctuary_cluster_util:sort_score_rank_map(RoleRankMap),
                                    ServerScoreMap = maps:from_list(ServerScoreL),
                                    LastRoleReceives = RoleReceives, NewLastBlSerId = LastBlServer,
                                    LastMonIdL = MonIdL, BlSerId = BaseBlSerId
                            end
                    end,
                    #sanctuary_building_state{
                        scene_id = SceneId, building_type = BuildType, bl_server = BlSerId, server_score_map = ServerScoreMap,
                        score_rank_map = SortRoleRankMap, mon_ids = LastMonIdL, last_bl_server = NewLastBlSerId, role_receives = LastRoleReceives
                    }
                end,
                BuildingL = lists:map(F, SceneList),

                GroupState = #sanctuary_group_state{
                    group_id = GroupId, san_type = SanType, building_list = BuildingL,
                    server_zone = ServerZones, begin_scene_map = BeginSceneMap, is_reboot_reset = IsReset
                },

                Args = [{server_zones, ServerZones}, {group_state, GroupState}, {zone_id, ZoneId}],
                [mod_clusters_center:apply_cast(SerId, mod_sanctuary_cluster_local, update_info, [Args])||SerId <- ServerIds],

                NewAccStateMap = AccStateMap#{GroupId => GroupState},
                {NewAccStateMap, NewReplaceArgs}
        end
    end,
    {GroupStateMap, ReplaceParams} = lists:foldl(F, {#{}, []}, GroupModServers),
    % 保存每次初始地信息
    Sql = usql:replace(sanctuary_kf_begin_scene, [zone_id, group_id, server_ids, server_scene_map, time], ReplaceParams),
    Sql =/= [] andalso db:execute(Sql),

    State = #sanctuary_cls_state{
        zone_id = ZoneId, server_group_map = ServerGroupMap,
        group_state_map = GroupStateMap, server_infos = ServerInfos
    },
    {ok, State}.

do_handle_call({'process_stop'}, _From, State) ->
    NowTime = utime:unixtime(),
    #sanctuary_cls_state{zone_id = ZoneId, group_state_map = GroupStateMap} = State,
    Fun = fun(GroupId, GroupState, AccDbParams) ->
        #sanctuary_group_state{building_list = BuildingL} = GroupState,
        MonFun = fun(BuildInfo) ->
            #sanctuary_building_state{
                scene_id = SceneId, bl_server = OBlSerId, mons_state = MonStateL,
                server_score_map = ServerScoreMap, role_receives = RoleReceives, last_bl_server = Lbs
            } = BuildInfo,
            SaveMonIdL = [MonState#sanctuary_mon_state.mon_id
                || MonState <- MonStateL, MonState#sanctuary_mon_state.reborn_time =< 0],
            ServerScoreL = maps:to_list(ServerScoreMap),
            [ZoneId, GroupId, SceneId, OBlSerId, util:term_to_bitstring(SaveMonIdL), NowTime,
                util:term_to_bitstring(ServerScoreL), util:term_to_bitstring(RoleReceives), Lbs]
                 end,
        AddDbParams = lists:map(MonFun, BuildingL),
        AddDbParams ++ AccDbParams
    end,
    DbParams = maps:fold(Fun, [], GroupStateMap),
    %% ?INFO("GroupStateMap:~p", [DbParams]),
    Sql = usql:replace(sanctuary_kf_construction, [zone_id, copy_id, scene_id, bl_server, mon_ids, last_stop_time, server_score_list, role_receives, last_bl_server], DbParams),
    Sql =/= [] andalso db:execute(Sql),
    {reply, ok, State};

do_handle_call(_Request, _From, _State) ->
    no_match.

do_handle_cast({'reload', _ZoneId, ServerInfos, GroupInfo, ZoneGSceneMap}, State) ->
    #sanctuary_cls_state{
        zone_id = ZoneId,
        group_state_map = GroupStateMap
    } = State,
    #zone_group_info{group_mod_servers = GroupModServers, server_group_map = ServerGroupMap} = GroupInfo,

    F = fun(#zone_mod_group_data{mod = Mod, server_ids = ServerIds, group_id = GroupId}, {AccStateMap, ReplaceArgs}) ->
        case Mod of
            1 -> {AccStateMap, ReplaceArgs};
            _ ->
                SanType = case Mod of 2 ->?SANTYPE_1; 4 -> ?SANTYPE_2; 8 -> ?SANTYPE_3 end,
                ServerZones = [Server||Server<-ServerInfos, lists:member(Server#zone_base.server_id, ServerIds)],
                {LastSerIds, LastSceneMap, Time} = maps:get({ZoneId, GroupId}, ZoneGSceneMap, {[], #{}, 0}),
                % 获取上次的出生点状态，如果分组服务器没有变化，分配时间小于配置时间，则不重新分配出生点
                Day = data_cluster_sanctuary_m:get_san_value(random_time),
                NowTime = utime:unixtime(),
                case ServerIds == LastSerIds of
                    true when NowTime - Time < Day * ?ONE_DAY_SECONDS ->
                        NewReplaceArgs = ReplaceArgs,
                        GroupState0 = maps:get(GroupId, GroupStateMap),
                        GroupState = GroupState0#sanctuary_group_state{
                            server_zone = ServerZones, begin_scene_map = LastSceneMap
                        };
                    _ ->
                        BeginSceneL = data_cluster_sanctuary_m:get_begin_scene(SanType),
                        F2 = fun(SerId, {[Scene|H], AccMap}) -> {H, AccMap#{SerId => Scene}} end,
                        {_, BeginSceneMap} = lists:foldl(F2, {ulists:list_shuffle(BeginSceneL), #{}}, ServerIds),
                        NewReplaceArgs = [[ZoneId, GroupId, util:term_to_string(ServerIds), util:term_to_string(BeginSceneMap), NowTime]|ReplaceArgs],
                        GroupState = #sanctuary_group_state{
                            group_id = GroupId, san_type = SanType,
                            server_zone = ServerZones, begin_scene_map = BeginSceneMap
                        }
                end,
                Args = [{server_zones, ServerZones}, {group_state, GroupState}, {zone_id, ZoneId}],
                [mod_clusters_center:apply_cast(SerId, mod_sanctuary_cluster_local, update_info, [Args])||SerId <- ServerIds],
                NewAccStateMap = AccStateMap#{GroupId => GroupState},
                {NewAccStateMap, NewReplaceArgs}
        end
    end,
    {NewGroupStateMap, ReplaceParams} = lists:foldl(F, {#{}, []}, GroupModServers),
    % 保存每次初始地信息
    Sql = usql:replace(sanctuary_kf_begin_scene, [zone_id, group_id, server_ids, server_scene_map, time], ReplaceParams),
    Sql =/= [] andalso db:execute(Sql),
    NewState = State#sanctuary_cls_state{
        server_group_map = ServerGroupMap,
        group_state_map = NewGroupStateMap, server_infos = ServerInfos
    },
    {noreply, NewState};

do_handle_cast({'zone_change', {ServerInfos, GroupInfo}}, State) ->
    {ok, NewState} = do_init([State#sanctuary_cls_state.zone_id, ServerInfos, GroupInfo, #{}]),
    {noreply, NewState};

do_handle_cast({'update_info', Args}, State) ->
    NewState = lib_sanctuary_cluster_mod:update_info(State, Args),
    {noreply, NewState};

do_handle_cast({'center_connected', ServerId}, State) ->
    lib_sanctuary_cluster_mod:center_connected(State, ServerId),
    {noreply, State};

do_handle_cast({'fix_merge_server_data', SecSerId, MainZoneId, MainSerId}, State) ->
    NewState = lib_sanctuary_cluster_mod:fix_merge_server_data(State, SecSerId, MainZoneId, MainSerId),
    {noreply, NewState};

do_handle_cast({'server_info_change', ServerId, Args}, State) ->
    NewState = lib_sanctuary_cluster_mod:server_info_change(State, ServerId, Args),
    {noreply, NewState};


do_handle_cast({'act_start', StartTime, EndTime, MonRebornTime}, State) ->
    NewState = lib_sanctuary_cluster_mod:act_start(State, StartTime, EndTime, MonRebornTime),
    {noreply, NewState};

do_handle_cast('act_end', State) ->
    NewState = lib_sanctuary_cluster_mod:act_end(State),
    {noreply, NewState};

do_handle_cast({'mon_reborn', NextRebornTime}, State) ->
    NewState = lib_sanctuary_cluster_mod:mon_reborn(State, NextRebornTime),
    {noreply, NewState};

do_handle_cast({'enter', ServerId, RoleId, SceneId, NeedOut, OldSceneId}, State) ->
    NewState = lib_sanctuary_cluster_mod:enter(State, ServerId, RoleId, SceneId, NeedOut, OldSceneId),
    {noreply, NewState};

do_handle_cast({'quit', ServerId, RoleId, SceneId}, State) ->
    NewState = lib_sanctuary_cluster_mod:quit(State, ServerId, RoleId, SceneId),
    {noreply, NewState};

do_handle_cast({'get_bl_reward', ServerId, RoleId, SceneId}, State) ->
    NewState = lib_sanctuary_cluster_mod:get_bl_reward(State, ServerId, RoleId, SceneId),
    {noreply, NewState};

do_handle_cast({'mon_be_killed', ServerId, BLWhos, KList, SceneId, Mid}, State) ->
    NewState = lib_sanctuary_cluster_mod:mon_be_killed(State, ServerId, BLWhos, KList, SceneId, Mid),
    {noreply, NewState};

do_handle_cast({'kill_player', SceneId, ZoneId, AttrServerId, AttrRoleId, AttrName, RoleScore, RoleKillNum}, State) ->
    NewState = lib_sanctuary_cluster_mod:kill_player(SceneId, ZoneId, AttrServerId, AttrRoleId, AttrName, RoleScore, RoleKillNum, State),
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info({'clear_role', GroupId, NeedClearSceneL, BelongSerId}, State) ->
    NewState = lib_sanctuary_cluster_mod:clear_role(State, GroupId, NeedClearSceneL, BelongSerId),
    {noreply, NewState};

do_handle_info({'peace_mon_reborn', GroupId, SceneId, MonId}, State) ->
    NewState = lib_sanctuary_cluster_mod:peace_mon_reborn(State, GroupId, SceneId, MonId),
    {noreply, NewState};

do_handle_info(_Info, State) ->
    {noreply, State}.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

% %% 划分服务器
% split_servers(?SANTYPE_1, [], _Index, ServerGroupMap, AccGroupStateMap) ->
%     {ServerGroupMap, AccGroupStateMap};
%
% split_servers(?SANTYPE_1, [H1], Index, ServerGroupMap, AccGroupStateMap) ->
%     GroupId = ?SANTYPE_1 * 100 + Index,
%     NewServerGroupMap = ServerGroupMap#{H1#zone_base.server_id => GroupId},
%     NewAccGroupStateMap = AccGroupStateMap#{GroupId => #sanctuary_group_state{group_id = GroupId, san_type = ?SANTYPE_1, server_zone = [H1]}},
%     {NewServerGroupMap, NewAccGroupStateMap};
%
% split_servers(?SANTYPE_1, [H1, H2|ServerL], Index, ServerGroupMap, AccGroupStateMap) ->
%     GroupId = ?SANTYPE_1 * 100 + Index,
%     NewServerGroupMap = ServerGroupMap#{H1#zone_base.server_id => GroupId, H2#zone_base.server_id => GroupId},
%     NewAccGroupStateMap = AccGroupStateMap#{GroupId => #sanctuary_group_state{group_id = GroupId, san_type = ?SANTYPE_1, server_zone = [H1, H2]}},
%     split_servers(?SANTYPE_1, ServerL, Index + 1, NewServerGroupMap, NewAccGroupStateMap);
%
% split_servers(?SANTYPE_2, ServerL, Index, ServerGroupMap, AccGroupStateMap) ->
%     F = fun(ZoneBase, {GroupId, AccGroupMap}) ->
%         NewAccGroupMap = AccGroupMap#{ZoneBase#zone_base.server_id => GroupId},
%         {GroupId, NewAccGroupMap}
%     end,
%     case length(ServerL) > 4 of
%         true ->
%             {ServerL1, ServerL2} = lists:split(4, ServerL),
%             GroupId1 = ?SANTYPE_2 * 100 + Index, GroupId2 = GroupId1 + 1,
%             {_, NewServerGroupMap0} = lists:foldl(F, {GroupId1, ServerGroupMap}, ServerL1),
%             {_, NewServerGroupMap} = lists:foldl(F, {GroupId1, NewServerGroupMap0}, ServerL2),
%             NewAccGroupMap = AccGroupStateMap#{
%                 GroupId1 => #sanctuary_group_state{group_id = GroupId1, san_type = ?SANTYPE_2, server_zone = ServerL1},
%                 GroupId2 => #sanctuary_group_state{group_id = GroupId2, san_type = ?SANTYPE_2, server_zone = ServerL2}
%             },
%             {NewServerGroupMap, NewAccGroupMap};
%         _ ->
%             GroupId = ?SANTYPE_2 * 100 + Index,
%             {_, NewServerGroupMap} = lists:foldl(F, {GroupId, ServerGroupMap}, ServerL),
%             NewAccGroupStateMap = AccGroupStateMap#{GroupId => #sanctuary_group_state{group_id = GroupId, san_type = ?SANTYPE_2, server_zone = ServerL}},
%             {NewServerGroupMap, NewAccGroupStateMap}
%     end;
%
% split_servers(?SANTYPE_3, ServerL, Index, ServerGroupMap, AccGroupStateMap) ->
%     F = fun(ZoneBase, {GroupId, AccGroupMap}) ->
%         NewAccGroupMap = AccGroupMap#{ZoneBase#zone_base.server_id => GroupId},
%         {GroupId, NewAccGroupMap}
%     end,
%     GroupId = ?SANTYPE_3 * 100 + Index,
%     {_, NewServerGroupMap} = lists:foldl(F, {GroupId, ServerGroupMap}, ServerL),
%     NewAccGroupStateMap = AccGroupStateMap#{GroupId => #sanctuary_group_state{group_id = GroupId, san_type = ?SANTYPE_3, server_zone = ServerL}},
%     {NewServerGroupMap, NewAccGroupStateMap}.