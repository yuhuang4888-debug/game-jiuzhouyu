%% ---------------------------------------------------------------------------
%% @doc lib_node_interval

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/2/8 0008
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_node_interval).

-behaviour(lib_behavior_node).

%% API
-export([enter/5, leave/5]).

-include("common.hrl").
-include("scene_object_btree.hrl").

enter(State, StateName, Args, BTree, Node) ->
    [NowTime|_] = Args,
    #interval_node{child_list = [ChildId|_], last_time = LastTime, interval = InterVal} = Node,
    {_, InterValMS} = ulists:keyfind(interval, 1, InterVal, {interval, 2000}),
    case NowTime >= LastTime + InterValMS of
        true ->
            lib_behavior_node:enter(State, StateName, Args, BTree, ChildId);
        _ ->
            {_, IsSucc} = ulists:keyfind(is_succ, 1, InterVal, {is_succ, 1}),
            Result = case IsSucc == 1 of true -> ?BTREESUCCESS; _ -> ?BTREEFAILURE end,
            lib_behavior_node:leave(State, StateName, Args, BTree#behavior_tree{result = Result}, Node)
    end.

leave(State, StateName, Args, BTree, Node) ->
    #interval_node{node_id = NodeId} = Node,
    [NowTime|_] = Args,
    NewNode = Node#interval_node{last_time = NowTime},
    NewNodes = (BTree#behavior_tree.nodes)#{NodeId => NewNode},
    ?INFO("lib_node_interval State ~p ~n", [State]),
    lib_behavior_node:leave(State, StateName, Args, BTree#behavior_tree{nodes = NewNodes}, Node).