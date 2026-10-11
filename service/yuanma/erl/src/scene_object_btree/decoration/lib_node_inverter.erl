%% ---------------------------------------------------------------------------
%% @doc inverter_node

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/29 0029
%% @desc       反转节点
%% ---------------------------------------------------------------------------
-module(lib_node_inverter).

-behaviour(lib_behavior_node).

%% API
-export([enter/5, leave/5]).

-include("common.hrl").
-include("scene_object_btree.hrl").

enter(State, StateName, Args, BTree, Node) ->
    #inverter_node{child_list = [ChildId|_]} = Node,
    lib_behavior_node:enter(State, StateName, Args, BTree, ChildId).

leave(State, StateName, Args, BTree, Node) ->
    NewResult = case BTree#behavior_tree.result of
        ?BTREESUCCESS -> ?BTREEFAILURE;
        ?BTREEFAILURE -> ?BTREESUCCESS
    end,
    lib_behavior_node:leave(State, StateName, Args, BTree#behavior_tree{result = NewResult}, Node).
