%% ---------------------------------------------------------------------------
%% @doc repeat_node

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/29 0029
%% @desc       循环节点循环节点
%%                  1. 次数循环      tick 次数
%%                  2. util_success 执行成功后退出循环
%%                  3. util_failure 执行失败后退出循环
%%                  4. inifity (最好不要) 每次tick都执行
%% ---------------------------------------------------------------------------
-module(lib_node_repeat).

-behavior(lib_behavior_node).

%% API
-export([enter/5, leave/5]).

-include("common.hrl").
-include("scene_object_btree.hrl").

enter(State, StateName, Args, BTree, Node) ->
    #repeat_node{repeat = Repeat, repeat_status = RepeatStatus, node_id = NodeId, child_list = [ChildId|_]} = Node,
    case RepeatStatus of
        undefined ->
            NewNode = Node#repeat_node{repeat_status = Repeat},
            NewBTree = BTree#behavior_tree{nodes = (BTree#behavior_tree.nodes)#{NodeId => NewNode}},
            lib_behavior_node:enter(State, StateName, Args, NewBTree, ChildId);
        _ ->
            lib_behavior_node:enter(State, StateName, Args, BTree, ChildId)
    end.

leave(State, StateName, Args, BTree, Node) ->
    #behavior_tree{result = Result, nodes = Nodes} = BTree,
    #repeat_node{repeat_status = RepeatStatus, node_id = NodeId} = Node,
    {loop_count, LoopStatus} = RepeatStatus,
    if
        (LoopStatus == util_success andalso Result == ?BTREESUCCESS);
        (LoopStatus == util_fail andalso Result == ?BTREEFAILURE) ->
            NewNode = Node#repeat_node{repeat_status = undefined},
            NewBTree = BTree#behavior_tree{nodes = Nodes#{NodeId => NewNode}},%% 根据子节点结果
            lib_behavior_node:leave(State, StateName, Args, NewBTree, NewNode);
        LoopStatus == util_success; LoopStatus == util_fail; LoopStatus == inifity ->
            {State, StateName, BTree#behavior_tree{result = Node}};
        LoopStatus == 1 ->
            NewNode = Node#repeat_node{repeat_status = undefined},
            NewBTree = BTree#behavior_tree{nodes = Nodes#{NodeId => NewNode}},
            lib_behavior_node:leave(State, StateName, Args, NewBTree, NewNode);
        is_integer(LoopStatus) andalso LoopStatus > 1 ->
            NewNode = Node#repeat_node{repeat_status = {loop_count, LoopStatus - 1}},
            {State, StateName, BTree#behavior_tree{result = NewNode, nodes = Nodes#{NodeId => NewNode}}};
        true ->
            throw(repeat_node_config_error)
    end.
