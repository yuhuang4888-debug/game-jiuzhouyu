%% ---------------------------------------------------------------------------
%% @doc counter_node

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/29 0029
%% @desc       计数节点 执行该节点n次后，强制返回false
%% ---------------------------------------------------------------------------
-module(lib_node_counter).

-behaviour(lib_behavior_node).

%% API
-export([enter/5, leave/5]).

-include("common.hrl").
-include("scene_object_btree.hrl").

enter(State, StateName, Args, BTree, Node) ->
    #counter_node{counter = CounterCfg, execute_num = ExecuteNum, child_list = [ChildId|_]} = Node,
    case CounterCfg of
        {_, util_success, Counter} when ExecuteNum >= Counter ->
            %NewBTree = BTree#behavior_tree{ result = ?BTREEFAILURE },
            NewBTree = BTree#behavior_tree{ result = ?BTREESUCCESS },
            lib_behavior_node:leave(State, StateName, Args, NewBTree, Node);
        {_, Counter} when ExecuteNum >= Counter ->
            %NewBTree = BTree#behavior_tree{ result = ?BTREEFAILURE },
            NewBTree = BTree#behavior_tree{ result = ?BTREESUCCESS },
            lib_behavior_node:leave(State, StateName, Args, NewBTree, Node);
        _ ->
            lib_behavior_node:enter(State, StateName, Args, BTree, ChildId)
    end.

leave(State, StateName, Args, BTree, Node) when BTree#behavior_tree.result == ?BTREESUCCESS ->
    #counter_node{execute_num = ExecuteNum, node_id = NodeId} = Node,
    NewNode = Node#counter_node{execute_num = ExecuteNum + 1},
    NewBTree = BTree#behavior_tree{
        nodes = (BTree#behavior_tree.nodes)#{NodeId => NewNode},
        result = ?BTREESUCCESS
    },
    lib_behavior_node:leave(State, StateName, Args, NewBTree, Node);
leave(State, StateName, Args, BTree, Node) when BTree#behavior_tree.result == ?BTREEFAILURE ->
    #counter_node{execute_num = ExecuteNum, node_id = NodeId, counter = CounterCfg} = Node,
    NewExecuteNum = case CounterCfg of
        {_, util_success, _} -> ExecuteNum;
        _ -> ExecuteNum + 1
    end,
    NewNode = Node#counter_node{execute_num = NewExecuteNum},
    NewBTree = BTree#behavior_tree{
        nodes = (BTree#behavior_tree.nodes)#{NodeId => NewNode},
        result = ?BTREESUCCESS
    },
    lib_behavior_node:leave(State, StateName, Args, NewBTree, Node).
