%% ---------------------------------------------------------------------------
%% @doc parallel_node

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/29 0029
%% @desc    并行节点  所有子节点都会执行 结果根据（成功/失败 n 个节点返回 成功#个数根据配置
%%          当前的结构设计模式是不能满足 “一边做A事情，一遍做B事情”， 叶子节点在Running
%%          状态下会直接返回树，等待下次tick时由Running的树进行， 要实现"一边走路，一边发现目标"
%%          需要通过外部消息进入树的内部或者定制行为，比如lib_node_action的动作是walk每次re_action就去find_target
%% ---------------------------------------------------------------------------
-module(lib_node_parallel).

-behaviour(lib_behavior_node).

%% API
-export([enter/5, leave/5, update_parallel_children/5]).

-include("common.hrl").
-include("scene_object_btree.hrl").

enter(State, StateName, Args, BTree, Node) ->
    #parallel_node{child_list = [ChildId|T], node_id = NodeId, status = Status} = Node,
    case Status of
        #parallel_node_status{running_node = RunningNodeL, success_num = SuccessNum, failure_num = FailNum} ->
            #behavior_tree{nodes = NodeMap, tick_gap = TickGap} = BTree,
            F = fun(ChildNode, {AccState, AccStateName, AccNodeMap, AccNodeL, AccSuccessNum, AccFailNum}) ->
                #action_node{node_id = ChildNodeId} = ChildNode,
                case lib_node_action:parallel_enter(AccState, AccStateName, Args, TickGap, ChildNode) of
                    {?BTREERUNNING, NAccState, NAccStateName, NChildNode} ->
                        NewAccNodeL = [NChildNode|AccNodeL], NewAccSuccessNum = AccSuccessNum, NewAccFailNum = AccFailNum;
                    {?BTREESUCCESS, NAccState, NAccStateName, NChildNode} ->
                        NewAccNodeL = AccNodeL, NewAccSuccessNum = AccSuccessNum + 1, NewAccFailNum = AccFailNum;
                    {?BTREEFAILURE, NAccState, NAccStateName, NChildNode} ->
                        NewAccNodeL = AccNodeL, NewAccSuccessNum = AccSuccessNum, NewAccFailNum = AccFailNum + 1
                end,
                NewAccNodeMap = AccNodeMap#{ChildNodeId => NChildNode},
                {NAccState, NAccStateName, NewAccNodeMap, NewAccNodeL, NewAccSuccessNum, NewAccFailNum}
            end,
            {NewState, NewStateName,NewNodeMap, RunningNodeLTmp, NewSuccessNum, NewFailNum} =
                lists:foldl(F, {State, StateName, NodeMap, [], SuccessNum, FailNum}, RunningNodeL),
            NewRunningNodeL = lists:reverse(RunningNodeLTmp),
            NewStatus = Status#parallel_node_status{running_node = NewRunningNodeL, success_num = NewSuccessNum, failure_num = NewFailNum},
            NewNode = Node#parallel_node{status = NewStatus},
            {Result, LastNode} = calc_parallel_result(NewNode),
            NewBTree = BTree#behavior_tree{nodes = NewNodeMap#{NodeId => LastNode}, result = Result},
            case is_record(Result, parallel_node) of
                true -> {NewState, NewStateName, NewBTree};
                _ -> lib_behavior_node:leave(NewState, NewStateName, Args, NewBTree, LastNode)
            end;
        _ ->
            [_|EnterArgs] = Args,
            NewStatus = #parallel_node_status{traverse_child = T, enter_args = EnterArgs},
            NewNode = Node#parallel_node{status = NewStatus},
            NewBTree = BTree#behavior_tree{nodes = (BTree#behavior_tree.nodes)#{NodeId => NewNode}},
            lib_behavior_node:enter(State, StateName, Args, NewBTree, ChildId)
    end.

leave(State, StateName, Args, BTree, Node) ->
    #behavior_tree{result = ChildResult} = BTree,
    #parallel_node{status = Status, node_id = NodeId} = Node,
    #parallel_node_status{
        traverse_child = TraverseChild, success_num = OldSuccessNum,
        failure_num = OldFailureNum, running_node = RunningNodeL
    } = Status,
    case ChildResult of
        ?BTREESUCCESS -> NewRunningNodeL = RunningNodeL, SuccessNum = OldSuccessNum + 1, FailureNum = OldFailureNum;
        ?BTREEFAILURE -> NewRunningNodeL = RunningNodeL, SuccessNum = OldSuccessNum, FailureNum = OldFailureNum + 1;
        _ -> NewRunningNodeL = [ChildResult|RunningNodeL], SuccessNum = OldSuccessNum, FailureNum = OldFailureNum
    end,
    %?PRINT("ChildResult ~p ~n", [ChildResult]),
    NewStatusTmp = Status#parallel_node_status{running_node = NewRunningNodeL, success_num = SuccessNum, failure_num = FailureNum},
    case TraverseChild of
        % 子节点没有执行完，记录成功失败数继续执行
        [NextChildId|T] ->
            NewStatus = NewStatusTmp#parallel_node_status{traverse_child = T},
            NewNode = Node#parallel_node{status = NewStatus},
            NewBTree = BTree#behavior_tree{nodes = (BTree#behavior_tree.nodes)#{NodeId => NewNode}},
            lib_behavior_node:enter(State, StateName, Args, NewBTree, NextChildId);
        % 所有子节点执行完毕，根据情况返回成功或失败
        _ ->
            {Result, LastNode} = calc_parallel_result(Node#parallel_node{status = NewStatusTmp}),
            NewBTree = BTree#behavior_tree{
                result = Result,
                nodes = (BTree#behavior_tree.nodes)#{NodeId => LastNode}
            },
            %?PRINT("is_record(Result, parallel_node) ~p ~n", [is_record(Result, parallel_node)]),
            case is_record(Result, parallel_node) of
                true -> {State, StateName, NewBTree};
                _ -> lib_behavior_node:leave(State, StateName, Args, NewBTree, LastNode)
            end
    end.

%% 更新运行中的行为节点状态
update_parallel_children(State, StateName, BTree, Node, Msg) ->
    #parallel_node{status = Status, node_id = NodeId} = Node,
    #behavior_tree{nodes = NodeMap, tick_gap = TickGap} = BTree,
    #parallel_node_status{running_node = RunningNodeL, success_num = SuccessNum, failure_num = FailNum, enter_args = EnterArgs} = Status,
    NowTime = utime:longunixtime(),
    F = fun(ChildNode, {AccState, AccStateName, AccNodeMap, AccNodeL, AccSuccessNum, AccFailNum}) ->
        #action_node{node_id = ChildNodeId} = ChildNode,
        case lib_node_action:parallel_update_action_node(AccState, AccStateName, NowTime, TickGap, ChildNode, Msg) of
            {?BTREERUNNING, NAccState, NAccStateName, NChildNode} ->
                NewAccNodeL = [NChildNode|AccNodeL], NewAccSuccessNum = AccSuccessNum, NewAccFailNum = AccFailNum;
            {?BTREESUCCESS, NAccState, NAccStateName, NChildNode} ->
                NewAccNodeL = AccNodeL, NewAccSuccessNum = AccSuccessNum + 1, NewAccFailNum = AccFailNum;
            {?BTREEFAILURE, NAccState, NAccStateName, NChildNode} ->
                NewAccNodeL = AccNodeL, NewAccSuccessNum = AccSuccessNum, NewAccFailNum = AccFailNum + 1
        end,
        NewAccNodeMap = AccNodeMap#{ChildNodeId => NChildNode},
        {NAccState, NAccStateName, NewAccNodeMap, NewAccNodeL, NewAccSuccessNum, NewAccFailNum}
    end,
    {NewState, NewStateName, NewNodeMap, RunningNodeLTmp, NewSuccessNum, NewFailNum} =
        lists:foldl(F, {State, StateName, NodeMap, [], SuccessNum, FailNum}, RunningNodeL),
    NewRunningNodeL = lists:reverse(RunningNodeLTmp),
    NewStatus = Status#parallel_node_status{running_node = NewRunningNodeL, success_num = NewSuccessNum, failure_num = NewFailNum},
    NewNode = Node#parallel_node{status = NewStatus},
    {Result, LastNode} = calc_parallel_result(NewNode),
    NewBTree = BTree#behavior_tree{nodes = NewNodeMap#{NodeId => LastNode}, result = Result},
    %?PRINT("update_parallel_children NewRunningNodeL ~p ~n", [NewRunningNodeL]),
    %?PRINT("update_parallel_children Result ~p ~n", [Result]),
    case is_record(Result, parallel_node) of
        true -> {NewState, NewStateName, NewBTree};
        _ -> lib_behavior_node:leave(NewState, NewStateName, [NowTime|EnterArgs], NewBTree, LastNode)
    end.

calc_parallel_result(#parallel_node{status = #parallel_node_status{running_node = []} = Status, parallel_cfg = ParallelCfg} = Node) ->
    #parallel_node_status{success_num = SuccessNum, failure_num = FailureNum} = Status,
    Result =
        case ParallelCfg of
            [{success_num, NeedNum}] when SuccessNum >= NeedNum -> ?BTREESUCCESS;
            [{failure_num, NeedNum}] when FailureNum >= NeedNum -> ?BTREESUCCESS;
            _ -> ?BTREEFAILURE
        end,
    NewNode = Node#parallel_node{status = undefined},
    {Result, NewNode};
calc_parallel_result(Node) ->
    {Node, Node}.

