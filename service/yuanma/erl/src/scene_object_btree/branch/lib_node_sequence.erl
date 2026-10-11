%% ---------------------------------------------------------------------------
%% @doc sequence_node

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/29 0029
%% @desc       序列节点 （所有子节点执行成功返回成功#拥有执行顺序
%% ---------------------------------------------------------------------------
-module(lib_node_sequence).

-behaviour(lib_behavior_node).

%% API
-export([enter/5, leave/5]).

-include("common.hrl").
-include("scene_object_btree.hrl").

enter(State, StateName, Args, BTree, Node) ->
    #sequence_node{child_list = [ChildId|T], node_id = NodeId} = Node,
    NewNode = Node#sequence_node{traverse_child = T},
    NewBTree = BTree#behavior_tree{nodes = (BTree#behavior_tree.nodes)#{NodeId => NewNode}},
    lib_behavior_node:enter(State, StateName, Args, NewBTree, ChildId).

leave(State, StateName, Args, BTree, Node) when BTree#behavior_tree.result == ?BTREESUCCESS ->
    #sequence_node{traverse_child = TraverseChild, node_id = NodeId} = Node,
    case TraverseChild of
        %% 子节点遍历完成且都成功，离开返回成功执行，离开当前节点
        [] ->
            NewNode = Node,
            NewBTree = BTree#behavior_tree{
                nodes = (BTree#behavior_tree.nodes)#{NodeId => NewNode},
                result = ?BTREESUCCESS
            },
            lib_behavior_node:leave(State, StateName, Args, NewBTree, Node);
        %% 继续遍历节点
        [NextChildId|T] ->
            NewNode = Node#sequence_node{traverse_child = T},
            NewBTree = BTree#behavior_tree{nodes = (BTree#behavior_tree.nodes)#{NodeId => NewNode}},
            lib_behavior_node:enter(State, StateName, Args, NewBTree, NextChildId)
    end;
leave(State, StateName, Args, BTree, Node) when BTree#behavior_tree.result == ?BTREEFAILURE ->
    NewNode = Node#sequence_node{traverse_child = []},
    NewBTree = BTree#behavior_tree{
        nodes = (BTree#behavior_tree.nodes)#{Node#sequence_node.node_id => NewNode},
        result = ?BTREEFAILURE
    },
    lib_behavior_node:leave(State, StateName, Args, NewBTree, Node);

leave(State, StateName, Args, BTree, Node) ->
    NewNode = Node#sequence_node{traverse_child = []},
    NewBTree = BTree#behavior_tree{
        nodes = (BTree#behavior_tree.nodes)#{Node#sequence_node.node_id => NewNode}
    },
    lib_behavior_node:leave(State, StateName, Args, NewBTree, Node).
