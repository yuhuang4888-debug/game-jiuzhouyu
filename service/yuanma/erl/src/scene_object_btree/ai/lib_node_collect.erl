%% ---------------------------------------------------------------------------
%% @doc lib_node_collect

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/10/28 0028
%% @desc    采集怪物
%% ---------------------------------------------------------------------------
-module(lib_node_collect).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").
-include("attr.hrl").
-include("player_behavior.hrl").

action(PS, StateName, Node, NowTime, TickGap) when is_record(PS, player_status) ->
    #player_status{ behavior_status = BehaviorStatus } = PS,
    case lib_player_behavior:get_collect_att(PS) of
        CollectAtt when is_map(CollectAtt) ->
            NewBehaviorStatus = BehaviorStatus#player_behavior{collect_att = CollectAtt},
            PS1 = PS#player_status{ behavior_status = NewBehaviorStatus },
            case lib_player_behavior:start_collect(PS1, NowTime, TickGap, CollectAtt) of
                {re_action, WaitMs} ->
                    NewNode = lib_node_action:set_time_re_action(Node, NowTime, WaitMs),
                    {PS1, ?BTREERUNNING, NewNode};
                {re_action, WaitMs, NewPS} ->
                    NewNode = lib_node_action:set_time_re_action(Node, NowTime, WaitMs),
                    {NewPS, ?BTREERUNNING, NewNode};
                _ ->
                    FailPS = lib_player_behavior:remove_collect_att(PS1),
                    {FailPS, StateName , ?BTREEFAILURE}
            end;
        _ ->
            FailPS = lib_player_behavior:remove_collect_att(PS),
            {FailPS, StateName, ?BTREEFAILURE}
    end.
% action(PS, Node, _Now, _TickGap) when is_record(PS, player_status) ->
%     #player_status{
%         btree_status = PlayerBTreeStatus, scene = SceneId, scene_pool_id = ScenePoolId,
%         copy_id = CopyId, x = X, y = Y
%     } = PS,
%     #player_btree_status{collect_att = CollectAtt} = PlayerBTreeStatus,
%     case CollectAtt of
%         #{id:=Id, sign:=Sign} ->
%             mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, get_collect_info_cast,
%                 [self(), Sign, Id, []]),
%             {PS, ?BTREERUNNING, Node};
%         _ ->
%             Args = lib_scene_calc:make_scene_calc_args(PS),
%             WarningRange = 600,
%             mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_scene_calc, get_any_for_collect,
%                 [self(), CopyId, X, Y, WarningRange, Args, {closest, X, Y}]),
%             {PS, ?BTREERUNNING, Node}
%     end.

re_action(State, StateName, Node, Now, TickGap) ->
    action(State, StateName, Node, Now, TickGap).

%% 开始采集成功
action_call_back(PS, StateName, Node, _NowTime, _TickGap, 'start_collect_success')when is_record(PS, player_status) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{collect_att = CollectAtt} = BehaviorStatus,
    case CollectAtt of
        #{config_id := MonId} ->
            #mon{collect_time = CltTime} = data_mon:get(MonId),
            lib_player_behavior:behavior_msg(CltTime * 1000, self(), 'finish_collect'),
            {update, PS, Node};
        _ ->
            {failure, PS, StateName}
    end;
%% 发送采集成功协议
action_call_back(PS, StateName, Node, NowTime, _TickGap, 'finish_collect')when is_record(PS, player_status) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{collect_att = CollectAtt} = BehaviorStatus,
    case CollectAtt of
        #{config_id := MonId, id:= TId} ->
            pp_battle:handle(20008, PS, [TId, MonId, ?COLLECT_FINISH]),
            % 给个1s 保底时间
            NewNode = lib_node_action:set_time_success(Node, NowTime, 1000),
            {update, PS, NewNode};
        _ ->
            {failure, PS, StateName}
    end;
%% 采集成功
action_call_back(PS, StateName, _Node, _NowTime, _TickGap, 'end_collect_success')when is_record(PS, player_status) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    NewBehaviorStatus = BehaviorStatus#player_behavior{collect_att = undefined},
    {finish, PS#player_status{behavior_status = NewBehaviorStatus}, StateName};

%% 采集失败，重新寻找目标
action_call_back(PS, StateName, Node, NowTime, TickGap, 'collect_failure_1')when is_record(PS, player_status) ->
    case action(PS, StateName, Node, NowTime, TickGap) of
        {NewPS, ?BTREERUNNING, NewNode} ->
            {update, NewPS, NewNode};
        {PS, ?BTREEFAILURE} ->
            {failure, PS, StateName}
    end;

%% 采集失败，重新寻找目标(要排除旧目标)
action_call_back(PS, StateName, Node, NowTime, TickGap, 'collect_failure_2')when is_record(PS, player_status) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{collect_att = #{id := Id}} = BehaviorStatus,
    ObjectMap = lib_player_behavior:get_collect_map(PS),
    NewObjectMap = maps:remove(Id, ObjectMap),
    PS1 = PS#player_status{behavior_status = BehaviorStatus#player_behavior{collect_att = undefined}},
    PS2 = lib_player_behavior:set_collect_map(PS1, NewObjectMap),
    case action(PS2, StateName, Node, NowTime, TickGap) of
        {NewPS, ?BTREERUNNING, NewNode} ->
            {update, NewPS, NewNode};
        _ ->
            {failure, PS2, StateName}
    end;

%% 没有采集次数，停止采集相同的采集怪
action_call_back(PS, StateName, Node, NowTime, TickGap, 'collect_failure_3')when is_record(PS, player_status) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{collect_att = #{config_id := MonId}} = BehaviorStatus,
    ObjectMap = lib_player_behavior:get_collect_map(PS),
    NewObjectMap = maps:filter(fun(_Key, #scene_object{config_id = ConfigId}) -> ConfigId =/= MonId end, ObjectMap),
    PS1 = PS#player_status{behavior_status = BehaviorStatus#player_behavior{collect_att = undefined}},
    PS2 = lib_player_behavior:set_collect_map(PS1, NewObjectMap),
    case action(PS2, StateName, Node, NowTime, TickGap) of
        {NewPS, ?BTREERUNNING, NewNode} ->
            {update, NewPS, NewNode};
        _ ->
            {failure, PS2, StateName}
    end;

%% 采集被打断，返回失败
action_call_back(PS, StateName, _Node, _NowTime, _TickGap, 'collect_failure_4')when is_record(PS, player_status) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    NewBehaviorStatus = BehaviorStatus#player_behavior{collect_att = undefined},
    PS1 = PS#player_status{behavior_status = NewBehaviorStatus},
    {failure, PS1, StateName};
action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.
