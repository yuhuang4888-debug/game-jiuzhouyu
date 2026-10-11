%% ---------------------------------------------------------------------------
%% @doc random_node

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/29 0029
%% @desc       概率节点（根据权重执行某一节点，并返回改节点执行结果
%% ---------------------------------------------------------------------------
-module(lib_node_random).

-behaviour(lib_behavior_node).

%% API
-export([enter/5, leave/5]).

-include("common.hrl").
-include("scene_object_btree.hrl").

enter(State, StateName, Args, BTree, Node) ->
    #random_node{weight_list = WeightList, child_list = ChildList} = Node,
    case WeightList of
        [] ->
            RandChildId = ulists:find_index(urand:rand(1, length(ChildList)), ChildList),
            IsChild = true;
        _ ->
            RandChildIndex = urand:rand_with_weight(WeightList),
            RandChildId = ulists:find_index(RandChildIndex, ChildList),
            IsChild = lists:member(RandChildId, ChildList)
    end,
    if
        IsChild -> lib_behavior_node:enter(State, StateName, Args, BTree, RandChildId);
        true -> throw(random_node_config_error)
    end.

leave(State, StateName, Args, BTree, Node) ->
    lib_behavior_node:leave(State, StateName, Args, BTree, Node).
