%% ---------------------------------------------------------------------------
%% @doc selector_node

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/29 0029
%% @desc      选择节点（任意子节点执行成功，则返回成功#有执行顺序，任一成功则返回
%% ---------------------------------------------------------------------------
-module(lib_node_selector).

-behaviour(lib_behavior_node).

%% API
-export([enter/5, leave/5]).

-include("common.hrl").
-include("scene_object_btree.hrl").

enter(State, StateName, Args, BTree, Node) ->
    #selector_node{child_list = [ChildId|T], node_id = NodeId} = Node,
    NewNode = Node#selector_node{traverse_child = T},
    NewBTree = BTree#behavior_tree{nodes = (BTree#behavior_tree.nodes)#{NodeId => NewNode}},
    lib_behavior_node:enter(State, StateName, Args, NewBTree, ChildId).

%% 任意返回成功返回成功推出当前节点
leave(State, StateName, Args, BTree, Node) when BTree#behavior_tree.result == ?BTREESUCCESS ->
    NewNode = Node#selector_node{traverse_child = []},
    NewBTree = BTree#behavior_tree{
        nodes = (BTree#behavior_tree.nodes)#{Node#selector_node.node_id => NewNode},
        result = ?BTREESUCCESS
    },
    lib_behavior_node:leave(State, StateName, Args, NewBTree, Node);
leave(State, StateName, Args, BTree, Node) when BTree#behavior_tree.result == ?BTREEFAILURE ->
    #selector_node{node_id = NodeId, traverse_child = TraverseChild} = Node,
    case TraverseChild of
        %% all failure
        [] ->
            NewNode = Node#selector_node{traverse_child = []},
            NewBTree = BTree#behavior_tree{
                nodes = (BTree#behavior_tree.nodes)#{Node#selector_node.node_id => NewNode},
                result = ?BTREEFAILURE
            },
            lib_behavior_node:leave(State, StateName, Args, NewBTree, Node);
        [NextChildId|T] ->
            NewNode = Node#selector_node{traverse_child = T},
            NewBTree = BTree#behavior_tree{nodes = (BTree#behavior_tree.nodes)#{NodeId => NewNode}},
            lib_behavior_node:enter(State, StateName, Args, NewBTree, NextChildId)
    end.


