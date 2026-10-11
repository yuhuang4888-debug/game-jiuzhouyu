%% ---------------------------------------------------------------------------
%% @doc action_node

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/29 0029
%% @desc       行为节点
%% ---------------------------------------------------------------------------
-module(lib_node_action).

%% API
-export([
    enter/5,
    parallel_enter/5,
    update_action_node/5,
    parallel_update_action_node/6,
    set_time_re_action/3,
    set_no_re_action/1,
    set_time_success/3,
    wait_cast_back/2,
    cast_back_success/1
]).

-include("common.hrl").
-include("scene_object_btree.hrl").
-include("scene.hrl").
-include("server.hrl").

-type btree_state() :: #ob_act{}|#player_status{}.

%% 行为执行函数， 行为执行的入口
%% 当树本轮Tick首次进入时，执行该函数
-callback action(State, StateName, Node, NowTime, TickGap) ->
    % 行为执行 成功/失败, 一般是瞬时行为直接返回结果，比如增加buff、死亡、创建怪物
    {NewState, NewStateName, ?BTREESUCCESS | ?BTREEFAILURE}
    % 返回运行装填，指的是当前的行为执行完成需要一定的时间（或者是异步），比如攻击、巡逻、走路
    % 次数可能需要设置成功时间或者re_action或者进程间的消息回调搭配完成
    | {NewState, ?BTREERUNNING, NewNode}
    when
    State :: btree_state(), StateName :: atom(), Node :: #action_node{}, NowTime :: integer(), TickGap :: integer(),
    NewState ::  btree_state(), NewStateName :: atom(), NewNode :: #action_node{}.

%% 再次执行行为
%% 一些持续行的行为可能会走到此处，比如 根据路径移动的行为
%% 需要划分多次执行移动
%% 返回信息与action/5一致
-callback re_action(State, StateName, Node, NowTime, TickGap) ->
      {NewState, NewStateName, result_code()}
    | {NewState, result_code(), NewNode}
    when
    State :: btree_state(), StateName :: atom(), Node :: #action_node{}, NowTime :: integer(), TickGap :: integer(),
    NewState :: btree_state(), NewStateName :: atom(), NewNode :: #action_node{}.

%% 行为节点执行行为过程中的的消息回调
%% 持续性行为有效
%% 由回调的消息得到行为 更新/完成/失败 时，需要重新定时Tick（像是一些异步行为，比如寻找目标，会把next_tick时间设置比较长，节省性能，
%% 这时需要回调充值定时器）
-callback action_call_back(State, StateName, Node, NowTime, TickGap, Msg) ->
    % 行为完成，比如异步行为寻找场景的目标, 会受到目标信息，此时当前行为完成
      {finish, NewState, NewStateName}
    % 行为还在继续，更新了运行信息，比如释放技能的返回，需要设置信息
    | {update, NewState, ActionNode}
    % 行为执行失败，比如找不到目标
    % 前三个返回都会重置定时器，一些异步的行为开始会设置5000ms的延时，收到回调消息需要重置定时器
    | {failure, NewState, NewStateName}
    % 行为执行失败，比如找不到目标，NextGapTime顺带设置下次遍历时间（出于性能考虑）
    | {failure, NewState, NewStateName, NextGapTime}
    % 仅更新内存值状态，比如技能combo返回
    |NewState
    % 容错
    | term()
    when
    State :: btree_state(), StateName :: atom(), Node :: #action_node{}, NowTime :: integer(), TickGap :: integer(), Msg :: term(),
    NewState :: btree_state(), NewStateName :: atom(), ActionNode :: #action_node{}, NextGapTime :: integer().


enter(State, StateName, Args, BTree, Node) ->
    [Now|EnterArgs] = Args,
    #behavior_tree{nodes = NodeMap, tick_gap = TickGap} = BTree,
    #action_node{
        action_status = ActionStatus, time_limit = TimeLimit,
        node_id = NodeId, module = Module
    } = Node,
    %?PRINT("Module ~p ~n", [Module]),
    if
        % 首次执行该行为
        not is_record(ActionStatus, action_node_status) ->
            %% 进入参数需要保存起来，后续的tick的leave需要使用
            NodeTmp = Node#action_node{action_status = #action_node_status{action_time = Now, enter_args = EnterArgs}},
            IsParallelParent = is_parallel_parent(Node, BTree),
            case Module:action(State, StateName, NodeTmp, Now, TickGap) of
                {NewState, ?BTREERUNNING, NewNode} when IsParallelParent ->
                    NewNodeMap = NodeMap#{NodeId => NewNode},
                    NewBtree = BTree#behavior_tree{result = NewNode, nodes = NewNodeMap},
                    lib_behavior_node:leave(NewState, StateName, Args, NewBtree, NewNode);
                {NewState, ?BTREERUNNING, NewNode} ->
                    NewNodeMap = NodeMap#{NodeId => NewNode},
                    {NewState, StateName, BTree#behavior_tree{result = NewNode, nodes = NewNodeMap}};
                {NewState, NewStateName, Result} ->
                    NewNode = Node#action_node{action_status = undefined},
                    NewNodeMap = NodeMap#{NodeId => NewNode},
                    NewBtree = BTree#behavior_tree{result = Result, nodes = NewNodeMap},
                    lib_behavior_node:leave(NewState, NewStateName, Args, NewBtree, NewNode)
            end;
        Now > ActionStatus#action_node_status.success_time,
        ActionStatus#action_node_status.success_time =/= 0 ->
            NewNode = Node#action_node{action_status = undefined},
            NewNodeMap = NodeMap#{NodeId => NewNode},
            NewBtree = BTree#behavior_tree{result = ?BTREESUCCESS, nodes = NewNodeMap},
            %?PRINT("===== ~p success ~n", [Module]),
            lib_behavior_node:leave(State, StateName, Args, NewBtree, NewNode);
        % 部分行为需要持续多次执行#释放技能/追踪
        % 下次执行时间不等于〇， 且当前时间大于下次执行时间
        Now > ActionStatus#action_node_status.next_action_time,
        ActionStatus#action_node_status.next_action_time =/= 0 ->
            case Module:re_action(State, StateName, Node, Now, TickGap) of
                {NewState, ?BTREERUNNING, NewNode} ->
                    NewNodeMap = NodeMap#{NodeId => NewNode},
                    {NewState, StateName, BTree#behavior_tree{result = NewNode, nodes = NewNodeMap}};
                {NewState, NewStateName, Result} ->
                    NewNode = Node#action_node{action_status = undefined},
                    NewNodeMap = NodeMap#{NodeId => NewNode},
                    NewBtree = BTree#behavior_tree{result = Result, nodes = NewNodeMap},
                    lib_behavior_node:leave(NewState, NewStateName, Args, NewBtree, NewNode)
            end;
        true ->
            #action_node_status{action_time = ActionTime} = ActionStatus,
            if
                TimeLimit == infinity ->
                    {State, StateName, BTree};
                Now >= ActionTime + TimeLimit,
                ActionStatus#action_node_status.success_time == 0 ->
                    %?PRINT("ActionStatus ~p ~n", [ActionStatus]),
                    %?PRINT("nononononononoo ~n", []),
                    NewNode = Node#action_node{action_status = undefined},
                    NewNodeMap = NodeMap#{NodeId => NewNode},
                    NewBtree = BTree#behavior_tree{result = ?BTREEFAILURE, nodes = NewNodeMap},
                    %% TODO 处理超时失败事件
                    lib_behavior_node:leave(State, StateName, Args, NewBtree, Node);
                true ->
                    {State, StateName, BTree}
            end
    end.

parallel_enter(State, StateName, Args, TickGap, Node) ->
    [Now|_] = Args,
    #action_node{
        action_status = ActionStatus, time_limit = TimeLimit, module = Module
    } = Node,
    % ?PRINT("parallel_enter Module ~p ~n", [Module]),
    if
        Now > ActionStatus#action_node_status.success_time,
        ActionStatus#action_node_status.success_time =/= 0 ->
            NewNode = Node#action_node{action_status = undefined},
            {?BTREESUCCESS, State, StateName, NewNode};
        Now > ActionStatus#action_node_status.next_action_time,
        ActionStatus#action_node_status.next_action_time =/= 0 ->
            case Module:re_action(State, StateName, Node, Now, TickGap) of
                {NewState, ?BTREERUNNING, NewNode} ->
                    {?BTREERUNNING, NewState, StateName, NewNode};
                {NewState, NewStateName, Result} ->
                    NewNode = Node#action_node{action_status = undefined},
                    {Result, NewState, NewStateName, NewNode}
            end;
        true ->
            #action_node_status{action_time = ActionTime} = ActionStatus,
            if
                TimeLimit == infinity ->
                    {?BTREERUNNING, State, StateName,Node};
                Now >= ActionTime + TimeLimit,
                ActionStatus#action_node_status.success_time == 0 ->
                    NewNode = Node#action_node{action_status = undefined},
                    {?BTREEFAILURE, State, StateName, NewNode};
                true ->
                    {?BTREERUNNING, State, StateName,Node}
            end
    end.

%% 更新运行中的行为节点状态
update_action_node(State, StateName, BTree, Node, Msg) ->
    #action_node{module = Module, node_id = NodeId, action_status = ActionStatus} = Node,
    #behavior_tree{nodes = NodeMap, tick_gap = TickGap} = BTree,
    #action_node_status{enter_args = EnterArgs} = ActionStatus,
    %is_tuple(Msg) andalso ?PRINT("Msg ~p ~n", [element(1, Msg)]),
    NowTime = utime:longunixtime(),
    case Module:action_call_back(State, StateName, Node, NowTime, TickGap, Msg) of
        {finish, NewState, NewStateName} ->
            % ?PRINT("===== ~p finish ~n", [Module]),
            NewNode = Node#action_node{action_status = undefined},
            NewNodeMap = NodeMap#{NodeId => NewNode},
            NewBtree = BTree#behavior_tree{result = ?BTREESUCCESS, nodes = NewNodeMap},
            {LastState, LastStateName, LastBtree} =
                lib_behavior_node:leave(NewState, NewStateName, [NowTime|EnterArgs], NewBtree, NewNode),
            {LastState, LastStateName, LastBtree, TickGap};
        {update, NewState, NewNode} ->
            % ?PRINT("===== ~p update ~n", [Module]),
            NewNodeMap = NodeMap#{NodeId => NewNode},
            NewBtree = BTree#behavior_tree{nodes = NewNodeMap, result = NewNode},
            {NewState, StateName, NewBtree, TickGap};
        {failure, NewState, NewStateName} ->
            %?PRINT("===== ~p failure ~n", [Module]),
            NewNode = Node#action_node{action_status = undefined},
            NewNodeMap = NodeMap#{NodeId => NewNode},
            NewBtree = BTree#behavior_tree{result = ?BTREEFAILURE, nodes = NewNodeMap},
            {LastState, LastStateName, LastBtree} =
                lib_behavior_node:leave(NewState, NewStateName, [NowTime|EnterArgs], NewBtree, NewNode),
            {LastState, LastStateName, LastBtree, TickGap};
        {failure, NewState, NewStateName, NextTickGap} ->
            NewNode = Node#action_node{action_status = undefined},
            NewNodeMap = NodeMap#{NodeId => NewNode},
            NewBtree = BTree#behavior_tree{result = ?BTREEFAILURE, nodes = NewNodeMap},
            {LastState, LastStateName, LastBtree} =
                lib_behavior_node:leave(NewState, NewStateName, [NowTime|EnterArgs], NewBtree, NewNode),
            {LastState, LastStateName, LastBtree, NextTickGap};
        NewState when is_record(NewState, ob_act); is_record(NewState, player_status) ->
            {NewState, StateName, BTree};
        _ ->
            {State, StateName, BTree}
    end.

parallel_update_action_node(State, StateName, NowTime, TickGap, Node, Msg) ->
    #action_node{module = Module} = Node,
    case Module:action_call_back(State, StateName, Node, NowTime, TickGap, Msg) of
        {finish, NewState, NewStateName} ->
            NewNode = Node#action_node{action_status = undefined},
            {?BTREESUCCESS, NewState, NewStateName, NewNode};
        {update, NewState, NewNode} ->
            {?BTREERUNNING, NewState, StateName, NewNode};
        {failure, NewState, NewStateName} ->
            NewNode = Node#action_node{action_status = undefined},
            {?BTREEFAILURE, NewState, NewStateName, NewNode};
        {failure, NewState, NewStateName, _NextTickGap} ->
            NewNode = Node#action_node{action_status = undefined},
            {?BTREEFAILURE, NewState, NewStateName, NewNode};
        NewState when is_record(NewState, ob_act); is_record(NewState, player_status) ->
            {?BTREERUNNING, NewState, StateName, Node};
        _ ->
            {?BTREERUNNING, State, StateName, Node}
    end.

%% 判断父节点是否并行节点
is_parallel_parent(Node, BTree) ->
    #behavior_tree{nodes = NodeMap} = BTree,
    #action_node{parent_id = ParentId} = Node,
    case maps:get(ParentId, NodeMap, false) of
        #parallel_node{} -> true;
        _ -> false
    end.


%% 设置re_action 时间
set_time_re_action(Node, NowTime, WaitMS) ->
    #action_node{action_status = ActionStatus} = Node,
    NewActionStatus = ActionStatus#action_node_status{next_action_time = NowTime + WaitMS},
    Node#action_node{action_status = NewActionStatus}.

%% 清空re_action时间
set_no_re_action(Node) ->
    #action_node{action_status = ActionStatus} = Node,
    NewActionStatus = ActionStatus#action_node_status{next_action_time = 0},
    Node#action_node{action_status = NewActionStatus}.

%% 设置节点成功时间#技能释放使用
set_time_success(Node, NowTime, SuccessMs) ->
    #action_node{action_status = ActionStatus} = Node,
    NewActionStatus = ActionStatus#action_node_status{success_time = NowTime + SuccessMs, next_action_time = 0},
    Node#action_node{action_status = NewActionStatus}.

%% 等待cast返回
%% 执行行为时比如 寻找场景目标 会cast到场景寻找，异步执行
%% 这时候把下次行为时间放宽到5s，一般来说场景在毫秒级别会返回信息执行 Action:action_call_back/6
%% 这时候再调用 cast_back_success 将time_re_action设置为空，同时还要取消之前的定时器
wait_cast_back(Node, NowTime) ->
    set_time_re_action(Node, NowTime, 5000).

%% 异步消息返回处理
cast_back_success(Node) ->
    set_no_re_action(Node).
