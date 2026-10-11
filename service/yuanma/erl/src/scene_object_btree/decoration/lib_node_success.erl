%% ---------------------------------------------------------------------------
%% @doc lib_node_success

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/8/12 0012
%% @desc   无论子节点是否成功返回成功
%% ---------------------------------------------------------------------------
-module(lib_node_success).

-behaviour(lib_behavior_node).

%% API
-export([enter/5, leave/5]).

-include("common.hrl").
-include("scene_object_btree.hrl").

enter(State, StateName, Args, BTree, Node) ->
    #success_node{child_list = [ChildId|_]} = Node,
    lib_behavior_node:enter(State, StateName, Args, BTree, ChildId).

leave(State, StateName, Args, BTree, Node) ->
    lib_behavior_node:leave(State, StateName, Args, BTree#behavior_tree{result = ?BTREESUCCESS}, Node).