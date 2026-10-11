%% ---------------------------------------------------------------------------
%% @doc condition_node

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/29 0029
%% @desc       条件节点
%% ---------------------------------------------------------------------------
-module(lib_node_condition).

%% API
-export([enter/5]).

-include("common.hrl").
-include("scene_object_btree.hrl").

enter(State, StateName, Args, BTree, Node) ->
    Module = lib_node_check,
    #condition_node{condition = Condition} = Node,
    Result =  Module:check_condition(State, Condition),
    %Result = ?BTREESUCCESS,
    NewBTree = BTree#behavior_tree{result = Result},
    lib_behavior_node:leave(State, StateName, Args, NewBTree, Node).

