%% ---------------------------------------------------------------------------
%% @doc lib_object_btree

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/19 0019
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_object_btree).

%% API
-export([
      init_btree/1            %%  初始化
    , tick_tree/3           %%  尝试执行一次树的遍历
    , dead_tick/3           %%
    , handle_info/4         %%  执行节点更新
]).

-export([
      test_dummy_100_every_scene/1
    , tess_create_100_every_scene/0
    , test_create_10_every_pool_scene/0
    , test_create_1_every_copy_scene/0
    , test_1_scene_100_pid/0
]).

-include("common.hrl").
-include("server.hrl").
-include("scene_object_btree.hrl").
-include("scene.hrl").

init_btree(TreeId) ->
    BTree = data_behavior_tree:get_btree(TreeId),
    BTree#behavior_tree{result = ?BTREEFAILURE, force_status = #behavior_force_status{}}.

%% =====================================
%% 遍历树
tick_tree(State, StateName, BTree) ->
    case catch utime:longunixtime() of
        {'EXIT', _R} -> {State, back, BTree};
        LongNowTime ->
            {NewState, NewStateName, NewBTree} = do_tick_tree(State, StateName, BTree, LongNowTime),
            case get_next_gap_time(NewBTree, LongNowTime) of
                NextGapTime when is_integer(NextGapTime) ->
                    {NewState, NewStateName, NewBTree, NextGapTime};
                _ ->
                    {NewState, NewStateName, NewBTree}
            end
    end.

do_tick_tree(State, StateName, BTree, LongNowTime) ->
    #behavior_tree{root_node_id = RootNodeId, event_map = EventMap} = BTree,
    Args = [LongNowTime],
    F_event = fun(NodeId, Event, {AccState, AccStateName, AccBTree}) ->
        event_execute(NodeId, AccStateName, Event, Args, AccBTree, AccState)
    end,
    {AfEventState, AfEventStateName, AfEventBTree} = maps:fold(F_event, {State, StateName, BTree}, EventMap),
    {ForceState, ForceBTree} = lib_object_btree_force:common_check(AfEventState, AfEventBTree, Args),
    case lib_behavior_node:get_running_node(AfEventBTree) of
        _ when is_record(ForceBTree#behavior_tree.force_status, behavior_force_status) ->
            lib_object_btree_force:do_force_event(ForceState, AfEventStateName, ForceBTree, Args);
        false ->
            lib_behavior_node:enter(ForceState, AfEventStateName, Args, ForceBTree, RootNodeId);
        RunningNode ->
            %% 只有行为节点或循环节点有可能执行当前
            lib_behavior_node:enter(ForceState, AfEventStateName, Args, ForceBTree, RunningNode)
    end.

%% ============================================
%% 执行事件节点
event_execute(NodeId, StateName, _Event, Args, AccBTree, State) ->
    lib_behavior_node:enter(State, StateName, Args, AccBTree, NodeId).

%% ============================================
%% 死亡事件
dead_tick(State, StateName, BTree) ->
    case catch utime:longunixtime() of
        {'EXIT', _R} -> {State, back, BTree};
        LongNowTime ->
            #behavior_tree{event_map = BornEventMap} = BTree,
            Args = [LongNowTime],
            F_event = fun(NodeId, Event, {AccState, AccStateName, AccBTree}) ->
                event_execute(NodeId, AccStateName, Event, Args, AccBTree, AccState)
            end,
            maps:fold(F_event, {State, StateName, BTree}, BornEventMap)
    end.

%% 判断当前的行为是否有挂载事件，如果没有挂载事件tick_gap可以变动
%% 一般来说。为了保证行为树的灵活性，tick_gap不应当变动，因为存在事件可能会打断行为
%% 当确定没有挂载事件时可以根据本次行为执行所需时间来动态改变tick_gap提高性能
get_next_gap_time(BTree, LongNowTime) ->
    case BTree of
        #behavior_tree{result = #action_node{
            action_status = #action_node_status{
                success_time = SuccessTime, next_action_time = ReActionTime
            }}, event_map = #{}} ->
            NextGapTime = max(SuccessTime - LongNowTime, ReActionTime - LongNowTime),
            case NextGapTime > 200 of
                true -> NextGapTime;
                _ -> null
            end;
        _ -> null
    end.

%% 行为节点执行后  消息回调处理
handle_info(State, StateName, BTree, Msg) ->
    case lib_behavior_node:get_running_node(BTree) of
        #action_node{} = ActionNode ->
            lib_node_action:update_action_node(State, StateName, BTree, ActionNode, Msg);
        #parallel_node{} = ParallelNode ->
            lib_node_parallel:update_parallel_children(State, StateName, BTree, ParallelNode, Msg);
        _ ->
            lib_object_btree_force:handle_info(State, StateName, BTree, Msg)
    end.

%% ======================== 测试 =========================
% 每个场景创建10个假人 default_dummy 行为
% 对比状态机和行为状态机的调度与内存
test_dummy_100_every_scene(RoleId) ->
    %% 改下mod_scene_object_create 里面的初始化Module
    FakerInfo = lib_faker:create_faker_by_role(RoleId),
    SceneIdL = data_scene:get_id_list(),
    F = fun(SceneId) ->
        case data_scene:get(SceneId) of
            #ets_scene{cls_type = 0, x = X, y = Y} ->
                [lib_scene_object:async_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, 0, X, Y, 1, 0, 1, [{faker_info, FakerInfo}, {find_target, 1000}])||_<-lists:seq(1, 100)];
            _ ->
                skip
        end
        end,
    lists:foreach(F, SceneIdL),
    ok.

%% 每个场景进程创建100个
%% 存在lib_node_patrol的行为吃不消
%% IO与内存直飙，0.2s 的tick 吃不消
%% 当前lib_node_patrol 每次都会移动且cast到场景寻找目标
tess_create_100_every_scene() ->
    SceneIdL = data_scene:get_id_list(),
    F = fun(SceneId) ->
        case data_scene:get(SceneId) of
            #ets_scene{cls_type = 0, x = X, y = Y} ->
                [lib_scene_object:async_create_object(test, 12001, SceneId, 0, X, Y, 1, 0, 1, [{group, 1}])||_<-lists:seq(1, 100)];
            _ ->
                skip
        end
    end,
    lists:foreach(F, SceneIdL),
    ok.

%% 每个场景分10个进程，每个进程创建10个
%% IO与内存只都会上去
%% 由于每个进程的场景怪物数减少
%% cast 消息较少，能撑得住
test_create_10_every_pool_scene() ->
    SceneIdL = data_scene:get_id_list(),
    F = fun(SceneId) ->
        case data_scene:get(SceneId) of
            #ets_scene{cls_type = 0, x = X, y = Y} ->
                [begin
                     [lib_scene_object:async_create_object(test, 12001, SceneId, PoolId, X, Y, 1, 0, 1, [{group, 1}])||_<-lists:seq(1, 10)]
                 end||PoolId<-[0|lists:seq(1, 9)]];
            _ ->
                skip
        end
        end,
    lists:foreach(F, SceneIdL),
    ok.

%% 每个场景分10个进程，每个进程再分10个房间，每个房间一个
%% IO与内存只都会上去，但是IO明显比不分房间下降
%% 由于每个进程的场景怪物数减少
%% cast 消息较少，能撑得住
test_create_1_every_copy_scene() ->
    SceneIdL = data_scene:get_id_list(),
    F = fun(SceneId) ->
        case data_scene:get(SceneId) of
            #ets_scene{cls_type = 0, x = X, y = Y} ->
                [begin
                     [
                         lib_scene_object:async_create_object(test, 12001, SceneId, PoolId, X, Y, 1, CopyId, 1, [{group, 1}])||CopyId<-[0|lists:seq(1, 9)]
                     ]
                 end||PoolId<-[0|lists:seq(1, 9)]
                ];
            _ ->
                skip
        end
        end,
    lists:foreach(F, SceneIdL),
    ok.

%% 测试一个场景100个，不分进程不分房间
test_1_scene_100_pid() ->
    SceneId = 1001,
    case data_scene:get(SceneId) of
        #ets_scene{cls_type = 0, x = X, y = Y} ->
            [lib_scene_object:async_create_object(test, 12001, SceneId, 0, X, Y, 1, 0, 1, [{group, 1}])||_<-lists:seq(1, 100)];
        _ ->
            skip
    end.

