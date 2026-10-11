%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_scene_event.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本场景事件处理
%% ---------------------------------------------------------------------------
-module(lib_dungeon_scene_event).
-export([]).

-compile(export_all).

-include("dungeon.hrl").
-include("common.hrl").

%% 执行事件
execute(State, CommonEvent) ->
    #dungeon_common_event{args = Args} = CommonEvent,
    NewState = execute_args(Args, CommonEvent, State),
    NewState.

%% 执行参数
%% 注意:CommonEvent修改后要重新赋值,否则使用的时候数据出现异常
execute_args([], _CommonEvent, State) -> State;
% 复活
execute_args([{revive, X, Y}|T], #dungeon_common_event{scene_id = SceneId} = CommonEvent, State) ->
    #dungeon_state{role_list = RoleList, revive_map = ReviveMap} = State,
    NewReviveMap = maps:put(SceneId, {X, Y}, ReviveMap),
    NewState = State#dungeon_state{revive_map = NewReviveMap},
    [mod_server_cast:set_data([{status_dungeon, [{revive_map, NewReviveMap}]}], RoleId)||#dungeon_role{id = RoleId}<-RoleList],
    execute_args(T, CommonEvent, NewState);
% 动态特效的处理
execute_args([{dynamic_eff, EffChangeValues}|T], #dungeon_common_event{scene_id = SceneId} = CommonEvent, State) ->
    #dungeon_state{scene_pool_id = ScenePoolId} = State,
    lib_scene:change_dynamic_eff(SceneId, ScenePoolId, self(), EffChangeValues),
    execute_args(T, CommonEvent, State);
% 传送点
execute_args([{transfer_point, {SceneId, X, Y}, {TargetSceneId, TargetX, TargetY}}|T], CommonEvent, State) ->
    #dungeon_state{transfer_point_map = TransferPointMap} = State,
    NewTransferPointMap = maps:put({SceneId, X, Y}, {TargetSceneId, TargetX, TargetY}, TransferPointMap),
    NewState = State#dungeon_state{transfer_point_map = NewTransferPointMap},
    execute_args(T, CommonEvent, NewState);

% 增加副本时间
execute_args([{add_dun_time, Time}|T],  #dungeon_common_event{scene_id = EventSceneId} = CommonEvent, State) ->
    #dungeon_state{now_scene_id = SceneId, end_time = OldEndTime, start_time = StartTime, start_time_ms = StartTimeMs,
        wave_num = WaveNum, owner_id = OwnerId, level = Level, level_end_time = LevelEndTime, role_list = RoleList} = State,
%%    ?PRINT("add_dun_time, ~p~n", [Time]),
    if
        SceneId == EventSceneId ->
            NewState = State#dungeon_state{end_time = OldEndTime + Time},
            %%通知客户端时间变更
            {ok, BinData} = pt_610:write(61004, [StartTime, StartTimeMs, OldEndTime + Time, Level, LevelEndTime, OwnerId, WaveNum]),
            [lib_dungeon_mod:send_to_uid(DungeonRole#dungeon_role.node, DungeonRole#dungeon_role.id, BinData) || DungeonRole <- RoleList],
            execute_args(T, CommonEvent, NewState);
        true ->
            execute_args(T, CommonEvent, State)
    end;
   
    
% 清理怪物
execute_args([{clear_mon, MonIdList}|T], #dungeon_common_event{scene_id = SceneId} = CommonEvent, State) ->
    #dungeon_state{scene_pool_id = ScenePoolId} = State,
    lib_mon:clear_scene_mon_by_mids(SceneId, ScenePoolId, self(), 1, MonIdList),
    execute_args(T, CommonEvent, State).