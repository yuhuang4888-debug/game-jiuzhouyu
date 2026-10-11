%% ---------------------------------------------------------------------------
%% @doc event_node

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/29 0029
%% @desc           事件节点：监听事件，事件触发强制执行该节点下的内容#
%%                  每次tick 执行其他节点前都会进入该节点(如果被挂载)
%%                  满足当前事件节点执行条件时，RUNNING状态也会被中断
%%                  父节点都必须是以及计数节点，并且只有一次#tick到此处只会执行挂载
%% ---------------------------------------------------------------------------
-module(lib_node_event).

-behaviour(lib_behavior_node).

%% API
-export([enter/5, leave/5]).

-include("common.hrl").
-include("scene_object_btree.hrl").
-include("def_fun.hrl").

enter(State, StateName, Args, BTree, Node) ->
    #behavior_tree{nodes = NodeMap} = BTree,
    [Now|_] = Args,
    Module = lib_node_check,
    #event_node{
        node_id = NodeId, event_condition = EventCondition,
        child_list = [ChildId|_], event_status = OldEventStatus
    } = Node,
    case OldEventStatus of
        #event_node_status{is_lock = true} ->
            {State, StateName, BTree};
        _ ->
            case Module:check_condition(State, EventCondition) of
                ?BTREEFAILURE ->
                    {State, StateName, BTree};
                ?BTREESUCCESS ->
                    #event_node_status{execute_times = ExecuteTimes, next_event_time = NextEventTime} = Node#event_node.event_status,
                    NoInCd = ?IF(is_integer(NextEventTime), Now >= NextEventTime, true),
                    HaveTimes = ?IF(is_integer(ExecuteTimes), ExecuteTimes >= 1, true),
                    if
                        NoInCd, HaveTimes ->    %% cd 外 且 还有执行次数，允许执行事件
                            %?PRINT("event success ~n", []),
                            %% TODO 事件节点进入执行是需要加锁，防止在一轮RUNNING状态中触发多次
                            NewEventStatus = OldEventStatus#event_node_status{is_lock = true},
                            NewNode = Node#event_node{event_status = NewEventStatus},
                            NewNodeMap = NodeMap#{NodeId => NewNode},
                            NewBTree = BTree#behavior_tree{nodes = NewNodeMap},
                            lib_behavior_node:enter(State, StateName, Args, NewBTree, ChildId);
                        true ->
                            %?PRINT("had event ~n", []),
                            {State, StateName, BTree}
                    end
            end
    end.
    % EventKey = NodeId,
    % case maps:is_key(EventKey, EventMap) of
    %     false -> %% 首次挂载事件
    %         NewEventMap = EventMap#{EventKey => Event},
    %         ExecuteTimes = EventTimes,
    %         NextEventTime = ?IF(is_integer(EventCd), 0, EventCd),
    %         EventStatus = #event_node_status{execute_times = ExecuteTimes, next_event_time = NextEventTime},
    %         NewNode = Node#event_node{event_status = EventStatus},
    %         NewNodeMap = NodeMap#{NodeId => NewNode},
    %         NewBTree = BTree#behavior_tree{normal_event = NewEventMap, result = ?BTREESUCCESS, nodes = NewNodeMap},
    %         lib_behavior_node:leave(State, StateName, Args, NewBTree, Node);
    %     true when OldEventStatus#event_node_status.is_lock ->
    %         %% 此时的时间节点正在执行
    %         %% TODO 暂时不支持交叉挂载多个时间 当前数据结构的is_lock 不能及时清除，待优化
    %         {State, StateName, BTree};
    %     true -> %% 该事件已经挂载
    %         case Module:check_condition(State, EventCondition) of
    %             ?BTREEFAILURE ->
    %                 {State, StateName, BTree};
    %             ?BTREESUCCESS ->
    %                 #event_node_status{execute_times = ExecuteTimes, next_event_time = NextEventTime} = Node#event_node.event_status,
    %                 NoInCd = ?IF(is_integer(NextEventTime), Now >= NextEventTime, true),
    %                 HaveTimes = ?IF(is_integer(ExecuteTimes), ExecuteTimes >= 1, true),
    %                 if
    %                     NoInCd, HaveTimes ->    %% cd 外 且 还有执行次数，允许执行事件
    %                         %?PRINT("event success ~n", []),
    %                         %% TODO 事件节点进入执行是需要加锁，防止在一轮RUNNING状态中触发多次
    %                         NewEventStatus = OldEventStatus#event_node_status{is_lock = true},
    %                         NewNode = Node#event_node{event_status = NewEventStatus},
    %                         NewNodeMap = NodeMap#{NodeId => NewNode},
    %                         NewBTree = BTree#behavior_tree{nodes = NewNodeMap},
    %                         lib_behavior_node:enter(State, StateName, Args, NewBTree, ChildId);
    %                     true ->
    %                         %?PRINT("had event ~n", []),
    %                         {State, StateName, BTree}
    %                 end
    %         end
    % end.

leave(State, StateName, _Args, BTree, Node) when BTree#behavior_tree.result == ?BTREEFAILURE ->
    % {State, BTree}
    #behavior_tree{nodes = NodeMap} = BTree,
    #event_node{event_status = EventStatus, node_id = NodeId} = Node,
    NewEventStatus = EventStatus#event_node_status{is_lock = false},
    NewNode = Node#event_node{event_status = NewEventStatus},
    NewNodeMap = NodeMap#{NodeId => NewNode},
    % 事件节点都已成功来处理
    NewBTree = BTree#behavior_tree{result = ?BTREESUCCESS, nodes = NewNodeMap},
    %lib_behavior_node:leave(State, Args, NewBTree, Node);
    {State, StateName, NewBTree};
leave(State, StateName, Args, BTree, Node) when BTree#behavior_tree.result == ?BTREESUCCESS ->
    #behavior_tree{nodes = NodeMap} = BTree,
    #event_node{event_status = EventStatus, node_id = NodeId, event_cd = EventCd} = Node,
    #event_node_status{next_event_time = NextEventTime, execute_times = ExecutesTime} = EventStatus,
    [Now|_] = Args,
    NewNextEventTime = ?IF(is_integer(NextEventTime), Now + EventCd, NextEventTime),
    NewExecutesTime = ?IF(is_integer(ExecutesTime), ExecutesTime - 1, ExecutesTime),
    NewEventStatus = EventStatus#event_node_status{next_event_time = NewNextEventTime, execute_times = NewExecutesTime, is_lock = false},
    NewNode = Node#event_node{event_status = NewEventStatus},
    NewNodeMap = NodeMap#{NodeId => NewNode},
    NewBTree = BTree#behavior_tree{result = ?BTREESUCCESS, nodes = NewNodeMap},
    {State, StateName, NewBTree}.




