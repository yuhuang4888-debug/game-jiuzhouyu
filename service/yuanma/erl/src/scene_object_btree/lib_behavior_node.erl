%% ---------------------------------------------------------------------------
%% @doc behavior_node

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/29 0029
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_behavior_node).

%% API
-export([
    enter/5,
    leave/5,
    get_running_node/1
]).

-include("common.hrl").
-include("scene.hrl").
-include("server.hrl").
-include("scene_object_btree.hrl").

-type btree_state() :: #ob_act{}|#player_status{}.

-callback enter(State :: btree_state(), StateName :: atom(), Args :: term(), BTree :: btree(), Node :: btree_node()) ->
    {NewState :: btree_state(), NewStateName :: atom(), NewBTree :: btree()}.

-callback leave(State :: btree_state(), StateName :: atom(), Args :: term(), BTree :: btree(), Node :: btree_node()) ->
    {NewState :: btree_state(), NewStateName :: atom(), NewBTree :: btree()}.

%% 进入当前节点
%% @param State 怪物进程状态 #obj{}
%% @param Args 额外参数# 目前只有时间，后续可添加
enter(State, StateName, Args, BTree, NodeId) when is_integer(NodeId) ->
    enter(State, StateName, Args, BTree, maps:get(NodeId, BTree#behavior_tree.nodes));
enter(State, StateName, Args, BTree, Node) ->
    Executor = get_node_executor(Node),
    %?PRINT("enter Executor ~p NodeId ~p ~n", [Executor, get_node_id(Node)]),
    Executor:enter(State, StateName, Args, BTree, Node).

%% 离开当前节点
leave(State, StateName, Args, BTree, Node) ->
    case get_node_parent(Node) of
        undefined -> {State, StateName, BTree}; %% 遍历完成
        0 -> {State, StateName, BTree}; %% 遍历完成
        ParentId ->
            ParentNode = maps:get(ParentId, BTree#behavior_tree.nodes),
            Executor = get_node_executor(ParentNode),
            %?PRINT("leave Executor ~p StateName ~p NodeId ~p ~n", [Executor, StateName, get_node_id(Node)]),
            Executor:leave(State, StateName, Args, BTree, ParentNode)
    end.

%% 判断当前树的某个节点属于运行状态# 循环节点循环中也会被判断是运行状态
get_running_node(BTree)->
    #behavior_tree{result = Result} = BTree,
    case Result of
        #repeat_node{} -> Result;
        #action_node{} -> Result;
        #parallel_node{} -> Result;
        _ -> false
    end.

%% 过去节点执行器
get_node_executor(Node) ->
    case Node of
        #parallel_node{executor     = Executor} -> Executor;
        #random_node{executor       = Executor} -> Executor;
        #selector_node{executor     = Executor} -> Executor;
        #sequence_node{executor     = Executor} -> Executor;
        #counter_node{executor      = Executor} -> Executor;
        #event_node{executor        = Executor} -> Executor;
        #inverter_node{executor     = Executor} -> Executor;
        #interval_node{executor     = Executor} -> Executor;
        #repeat_node{executor       = Executor} -> Executor;
        #success_node{executor      = Executor} -> Executor;
        #action_node{executor       = Executor} -> Executor;
        #condition_node{executor    = Executor} -> Executor;
        _ -> throw(node_type_exception)
    end.

get_node_parent(Node) ->
    case Node of
        #parallel_node{parent_id    = ParentId} -> ParentId;
        #random_node{parent_id      = ParentId} -> ParentId;
        #selector_node{parent_id    = ParentId} -> ParentId;
        #sequence_node{parent_id    = ParentId} -> ParentId;
        #counter_node{parent_id     = ParentId} -> ParentId;
        #event_node{parent_id       = ParentId} -> ParentId;
        #inverter_node{parent_id    = ParentId} -> ParentId;
        #interval_node{parent_id    = ParentId} -> ParentId;
        #repeat_node{parent_id      = ParentId} -> ParentId;
        #success_node{parent_id     = ParentId} -> ParentId;
        #action_node{parent_id      = ParentId} -> ParentId;
        #condition_node{parent_id   = ParentId} -> ParentId;
        _ -> throw(node_type_exception)
    end.

get_node_id(Node) ->
    case Node of
        #parallel_node{node_id      = NodeId} -> NodeId;
        #random_node{node_id        = NodeId} -> NodeId;
        #selector_node{node_id      = NodeId} -> NodeId;
        #sequence_node{node_id      = NodeId} -> NodeId;
        #counter_node{node_id       = NodeId} -> NodeId;
        #event_node{node_id         = NodeId} -> NodeId;
        #inverter_node{node_id      = NodeId} -> NodeId;
        #interval_node{node_id      = NodeId} -> NodeId;
        #repeat_node{node_id        = NodeId} -> NodeId;
        #success_node{node_id       = NodeId} -> NodeId;
        #action_node{node_id        = NodeId} -> NodeId;
        #condition_node{node_id     = NodeId} -> NodeId;
        _ -> throw(node_type_exception)
    end.
