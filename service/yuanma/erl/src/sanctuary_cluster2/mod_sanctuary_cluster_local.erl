%% ---------------------------------------------------------------------------
%% @doc mod_sanctuary_cluster_local

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/9/3 0003
%% @desc  
%% ---------------------------------------------------------------------------
-module(mod_sanctuary_cluster_local).

-behaviour(gen_server).

%% API
-export([
      start_link/0
    , send_normal_info/1
    , send_building_info/2
    , send_boss_hurt_rank/3
    , enter/4
    , quit/2
    , get_bl_reward/2
    , send_act_time/1
    , send_kill_log/3
    , update_info/1
    , kill_player/7
    , get_role_sanctuary_rank_info/4
]).

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
-include("def_gen_server.hrl").
-include("cluster_sanctuary.hrl").
-include("clusters.hrl").
-include("def_fun.hrl").

%% ===========================
%%  Function Need Export
%% ===========================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

send_normal_info(RoleId) ->
    gen_server:cast(?MODULE, {'send_normal_info', RoleId}).

send_building_info(RoleId, SceneId) ->
    gen_server:cast(?MODULE, {'send_building_info', RoleId, SceneId}).

send_boss_hurt_rank(RoleId, SceneId, MonId) ->
    gen_server:cast(?MODULE, {'send_boss_hurt_rank', RoleId, SceneId, MonId}).

enter(RoleId, SceneId, NeedOut, OldSceneId) ->
    gen_server:cast(?MODULE, {'enter', RoleId, SceneId, NeedOut, OldSceneId}).

quit(RoleId, SceneId) ->
    gen_server:cast(?MODULE, {'quit', RoleId, SceneId}).

get_bl_reward(RoleId, SceneId) ->
    gen_server:cast(?MODULE, {'get_bl_reward', RoleId, SceneId}).

send_act_time(RoleId) ->
    gen_server:cast(?MODULE, {'send_act_time', RoleId}).

send_kill_log(RoleId, SceneId, MonId) ->
    gen_server:cast(?MODULE, {'send_kill_log', RoleId, SceneId, MonId}).

update_info(Args) ->
    gen_server:cast(?MODULE, {'update_info', Args}).

kill_player(SceneId, ScenePId, AttrServerId, AttrRoleId, AttrName, RoleScore, RoleKillNum) ->
    gen_server:cast(?MODULE, {'kill_player', SceneId, ScenePId, AttrServerId, AttrRoleId, AttrName, RoleScore, RoleKillNum}).

get_role_sanctuary_rank_info(RoleId, SceneId, PersonScore, KillScore) ->
    gen_server:cast(?MODULE, {'get_role_sanctuary_rank_info', RoleId, SceneId, PersonScore, KillScore}).

%% ===========================
%% gen_server callbacks temples
%% ===========================
init(Args) ->
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

do_init([]) -> {ok, #sanctuary_local_state{}}.

do_handle_call(_Request, _From, _State) ->
    no_match.

do_handle_cast({'send_normal_info', RoleId}, State) ->
    #sanctuary_local_state{
        san_type = SanType, server_zones = ServerZoneL,
        begin_scene_map = BeginSceneMap
    } = State,
    F = fun(ServerZone, AccL) ->
        #zone_base{server_id = ServerId, server_num = ServerNum, server_name = ServerName, time = Time} = ServerZone,
        OpenDay = util:get_open_day(Time),
        BeginScene = maps:get(ServerId, BeginSceneMap, 0),
        [{ServerId, ServerNum, ServerName, OpenDay, BeginScene}|AccL]
    end,
    SendL = lists:foldl(F, [], ServerZoneL),
    {ok, BinData} = pt_284:write(28400, [SanType, SendL]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'send_building_info', RoleId, SceneId}, State) ->
    #sanctuary_local_state{building_list = BuildingL, begin_scene_map = BeginSceneMap, server_zones = ServerZones} = State,
    SerId = config:get_server_id(),
    case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL) of
        false -> skip;
        BuildingState ->
            #sanctuary_building_state{
                join_map = JoinMap, score_rank_map = RankMap,
                building_type = BuildingType, bl_server = BlSerId, last_bl_server = LastBlSerId,
                role_receives = RoleReceiveL, mons_state = MonsState, server_score_map = SerScoreMap
            } = BuildingState,
            ScoreList = maps:to_list(SerScoreMap),
            IsMember = lists:member(RoleId, RoleReceiveL),
            ReceiveStatus = if
                IsMember -> ?HAS_RECIEVE;
                true -> ?IF(BlSerId == SerId, ?HAS_ACHIEVE, ?NOT_ACHIEVE)
            end,
            JoinNum = length(maps:get(SerId, JoinMap, [])),
            SendMonL = [{MonId, MonType, MonLv, RebornTime}||
                #sanctuary_mon_state{mon_id = MonId, mon_type = MonType, mon_lv = MonLv, reborn_time = RebornTime}<-MonsState],
            SendScoreList = [{maps:get(SId, BeginSceneMap, 0), Score}||{SId, Score}<-ScoreList],
            BlScene = maps:get(BlSerId, BeginSceneMap, 0),
            LastBlScene = maps:get(LastBlSerId, BeginSceneMap, 0),
            RankList = maps:get(BlSerId, RankMap, []),
            case RankList == [] of
                true ->
                    SendRankList = [];
                _ ->
                    SendRankFun = fun(RankInfo) ->
                        #sanctuary_kf_role_rank_info{
                            player_id = TemPlayerId, player_name = TemPlayerName, server_id = TemServerId,
                            score = TemScore, kill_num = TemKillNum, rank = TemRank
                        } = RankInfo,
                        #zone_base{ server_num = TemServerNum } = lists:keyfind(TemServerId, #zone_base.server_id, ServerZones),
                        {TemPlayerId, TemPlayerName, TemServerId, TemServerNum, TemScore, TemKillNum, TemRank}
                    end,
                    SendRankList = lists:map(SendRankFun, RankList)
            end,
            {ok, BinData} = pt_284:write(28401, [SceneId, BuildingType, BlScene, LastBlScene, SendScoreList, ReceiveStatus, JoinNum, SendMonL, SendRankList]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State};

do_handle_cast({'send_boss_hurt_rank', RoleId, SceneId, MonId}, State) ->
    #sanctuary_local_state{building_list = BuildList} = State,
    case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildList) of
        false -> skip;
        BuildState ->
            #sanctuary_building_state{mons_state = MonsState} = BuildState,
            #sanctuary_mon_state{rank_list = RankList} = ulists:keyfind(MonId, #sanctuary_mon_state.mon_id, MonsState, #sanctuary_mon_state{}),
            SubNum = data_cluster_sanctuary_m:get_san_value(kill_log_num),
            SendL = lists:sublist(RankList, SubNum),
            {ok, BinData} = pt_284:write(28403, [MonId, SendL]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State};

do_handle_cast({'enter', RoleId, SceneId, NeedOut, OldSceneId}, State) ->
    #sanctuary_local_state{zone_id = ZoneId} = State,
    SerId = config:get_server_id(),
    mod_clusters_node:apply_cast(mod_sanctuary_cluster, enter, [ZoneId, SerId, RoleId, SceneId, NeedOut, OldSceneId]),
    {noreply, State};

do_handle_cast({'quit', RoleId, SceneId}, State) ->
    #sanctuary_local_state{zone_id = ZoneId} = State,
    SerId = config:get_server_id(),
    mod_clusters_node:apply_cast(mod_sanctuary_cluster, quit, [ZoneId, SerId, RoleId, SceneId]),
    {noreply, State};

do_handle_cast({'get_bl_reward', RoleId, SceneId}, State) ->
    #sanctuary_local_state{zone_id = ZoneId} = State,
    SerId = config:get_server_id(),
    mod_clusters_node:apply_cast(mod_sanctuary_cluster, get_bl_reward, [ZoneId, SerId, RoleId, SceneId]),
    {noreply, State};

do_handle_cast({'send_act_time', RoleId}, State) ->
    #sanctuary_local_state{start_time = StartTime, end_time = EndTime} = State,
    {ok, BinData} = pt_284:write(28410, [StartTime, EndTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'send_kill_log', RoleId, SceneId, MonId}, State) ->
    #sanctuary_local_state{building_list = BuildingL} = State,
    case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL) of
        false -> skip;
        #sanctuary_building_state{mons_state = MonLState} ->
            #sanctuary_mon_state{kill_log = KillLog} = ulists:keyfind(MonId, #sanctuary_mon_state.mon_id, MonLState,
                #sanctuary_mon_state{}),
            {ok, BinData} = pt_284:write(28412, [SceneId, MonId, KillLog]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State};

do_handle_cast({'update_info', Args}, State) ->
    NewState = update_info(Args, State),
    {noreply, NewState};

do_handle_cast({'kill_player', SceneId, _ScenePId, AttrServerId, AttrRoleId, AttrName, RoleScore, RoleKillNum}, State) ->
    #sanctuary_local_state{zone_id = ZoneId} = State,
    mod_clusters_node:apply_cast(mod_sanctuary_cluster, kill_player, [SceneId, ZoneId, AttrServerId, AttrRoleId, AttrName, RoleScore, RoleKillNum]),
    {noreply, State};

do_handle_cast({'get_role_sanctuary_rank_info', RoleId, SceneId, PersonScore, KillScore}, State) ->
    #sanctuary_local_state{building_list = BuildingL} = State,
    SerId = config:get_server_id(),
    case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL) of
        false -> skip;
        BuildingState ->
            #sanctuary_building_state{score_rank_map = RankMap, bl_server = BlSerId } = BuildingState,
            RankList = maps:get(SerId, RankMap, []),
            case RankList == [] orelse SerId =/= BlSerId of
                true ->
                    Rank = 0;
                _ ->
                    case lists:keyfind(RoleId, #sanctuary_kf_role_rank_info.player_id, RankList) of
                        #sanctuary_kf_role_rank_info{ rank = Rank } -> ok;
                        _ -> Rank = 0
                    end
            end,
            {ok, BinData} = pt_284:write(28422, [SceneId, Rank, PersonScore, KillScore]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Info, State) ->
    {noreply, State}.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

update_info([], State) -> State;

update_info([{zone_id, ZoneId}|H], State) ->
    update_info(H, State#sanctuary_local_state{zone_id = ZoneId});

update_info([{act_time, {StartTime, EndTime}}|H], State) ->
    NewState = State#sanctuary_local_state{
        start_time = StartTime, end_time = EndTime
    },
    {ok, BinData} = pt_284:write(28410, [StartTime, EndTime]),
    lib_server_send:send_to_all(BinData),
    update_info(H, NewState);

update_info([{act_time, {IsOpen, StartTime, EndTime}}|H], State) ->
    NewState = State#sanctuary_local_state{
        is_open = IsOpen, start_time = StartTime, end_time = EndTime
    },
    {ok, BinData} = pt_284:write(28410, [StartTime, EndTime]),
    lib_server_send:send_to_all(BinData),
    update_info(H, NewState);

update_info([{server_zone, ServerZone}|H], State) ->
    #sanctuary_local_state{server_zones = ServerZones} = State,
    NewState = State#sanctuary_local_state{
        server_zones = [ServerZone|lists:keydelete(ServerZone#zone_base.server_id, #zone_base.server_id, ServerZones)]
    },
    update_info(H, NewState);

update_info([{server_zones, ServerZones}|H], State) ->
    NewState = State#sanctuary_local_state{
        server_zones =ServerZones
    },
    update_info(H, NewState);

update_info([{group_state, GroupState}|H], State) ->
    #sanctuary_group_state{
        san_type = SanType, server_zone = ServerZones,
        begin_scene_map = BeginSceneMap, building_list = BuildingL
    } = GroupState,
    NewState = State#sanctuary_local_state{
        server_zones = ServerZones, begin_scene_map = BeginSceneMap,
        building_list = BuildingL, san_type = SanType
    },
    update_info(H, NewState);

update_info([{building_list, BuildingL}|H], State) ->
    update_info(H, State#sanctuary_local_state{building_list = BuildingL});

update_info([{begin_scene_map, BeginSceneMap}|H], State) ->
    update_info(H, State#sanctuary_local_state{begin_scene_map = BeginSceneMap});

update_info([{bl_server, {SceneId, BlSerId}}|H], State) ->
    #sanctuary_local_state{building_list = BuildingL} = State,
    case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL) of
        false ->
            update_info(H, State);
        BuildingState ->
            NewBuildingState= BuildingState#sanctuary_building_state{bl_server = BlSerId, last_bl_server = 0},
            NewBuildingL = lists:keystore(SceneId, #sanctuary_building_state.scene_id, BuildingL, NewBuildingState),
            NewState = State#sanctuary_local_state{building_list = NewBuildingL},
            update_info(H, NewState)
    end;

update_info([{score_map, {SceneId, ScoreMap}}|H], State) ->
    #sanctuary_local_state{building_list = BuildingL} = State,
    case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL) of
        false ->
            update_info(H, State);
        BuildingState ->
            NewBuildingState= BuildingState#sanctuary_building_state{server_score_map = ScoreMap},
            NewBuildingL = lists:keystore(SceneId, #sanctuary_building_state.scene_id, BuildingL, NewBuildingState),
            NewState = State#sanctuary_local_state{building_list = NewBuildingL},
            update_info(H, NewState)
    end;

update_info([{mon, {SceneId, MonState}}|H], State) ->
    #sanctuary_local_state{building_list = BuildingL} = State,
    #sanctuary_local_state{building_list = BuildingL} = State,
    case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL) of
        false ->
            update_info(H, State);
        BuildingState ->
            #sanctuary_building_state{mons_state = MonStateL} = BuildingState,
            NewMonStateL = lists:keystore(MonState#sanctuary_mon_state.mon_id, #sanctuary_mon_state.mon_id, MonStateL, MonState),
            NewBuildingState= BuildingState#sanctuary_building_state{mons_state = NewMonStateL},
            NewBuildingL = lists:keystore(SceneId, #sanctuary_building_state.scene_id, BuildingL, NewBuildingState),
            NewState = State#sanctuary_local_state{building_list = NewBuildingL},
            update_info(H, NewState)
    end;

update_info([{role_receives, {SceneId, RoleReceiveL}}|H], State) ->#sanctuary_local_state{building_list = BuildingL} = State,
    case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL) of
        false ->
            update_info(H, State);
        BuildingState ->
            NewBuildingState= BuildingState#sanctuary_building_state{role_receives = RoleReceiveL},
            NewBuildingL = lists:keystore(SceneId, #sanctuary_building_state.scene_id, BuildingL, NewBuildingState),
            NewState = State#sanctuary_local_state{building_list = NewBuildingL},
            update_info(H, NewState)
    end;

update_info([{join_map, {SceneId, JoinMap}}|H], State) ->
    #sanctuary_local_state{building_list = BuildingL} = State,
    case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL) of
        false ->
            update_info(H, State);
        BuildingState ->
            NewBuildingState= BuildingState#sanctuary_building_state{join_map = JoinMap},
            NewBuildingL = lists:keystore(SceneId, #sanctuary_building_state.scene_id, BuildingL, NewBuildingState),
            NewState = State#sanctuary_local_state{building_list = NewBuildingL},
            update_info(H, NewState)
    end;

update_info([{score_rank_map, {SceneId, RankMap}}|H], State) ->
    #sanctuary_local_state{building_list = BuildingL} = State,
    case lists:keyfind(SceneId, #sanctuary_building_state.scene_id, BuildingL) of
        false ->
            update_info(H, State);
        BuildingState ->
            NewBuildingState= BuildingState#sanctuary_building_state{score_rank_map = RankMap},
            NewBuildingL = lists:keystore(SceneId, #sanctuary_building_state.scene_id, BuildingL, NewBuildingState),
            NewState = State#sanctuary_local_state{building_list = NewBuildingL},
            update_info(H, NewState)
    end;


update_info([_|H], State) -> update_info(H, State).