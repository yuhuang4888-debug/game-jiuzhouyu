%% ---------------------------------------------------------------------------
%% @doc lib_node_opposite

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/8/13 0013
%% @desc   与目标进行对峙N秒， 对峙期间受到攻击立马反击， 如果超过对峙时间目标还在范围距离开始攻击
%% ---------------------------------------------------------------------------
-module(lib_node_opposite).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").

action(State, StateName, Node, NowTime, _TickGap) when is_record(State, ob_act) ->
    #ob_act{object = SceneObj, att = Att} = State,
    case Att of
        #{id:=_TargetId, sign:=_TargetSign, x:=TargetX, y:=TargetY} ->
            #action_node{args = ActionArgs, action_status = ActionStatus} = Node,
            {_, OppositeMS} = ulists:keyfind(opposite_ms, 1, ActionArgs, 1000),
            {_, OppositeDis} = ulists:keyfind(opposite_dis, 1, ActionArgs, 5000),
            #scene_object{x = X, y = Y} = SceneObj,
            IsSatisfy = umath:distance_pow({X, Y}, {TargetX, TargetY}) =< OppositeDis * OppositeDis,
            if
                not IsSatisfy -> {State,StateName , ?BTREEFAILURE};
                true ->
                    OppositeEndTime = NowTime + OppositeMS,
                    NewActionStatus = ActionStatus#action_node_status{next_action_args = OppositeEndTime},
                    NewNode = lib_node_action:wait_cast_back(Node#action_node{action_status = NewActionStatus}, NowTime),
                    {State, ?BTREERUNNING, NewNode}
            end;
        _ ->
            {State,StateName , ?BTREEFAILURE}
    end.

re_action(State, StateName, Node, NowTime, _TickGap) ->
    #ob_act{att = Att, object = SceneObject} = State,
    %?PRINT("re_action Att ~p ~n", [Att]),
    case Att of
        #{id:=Id, sign:=Sign} ->
            #scene_object{aid = Aid, scene = SceneId, scene_pool_id = ScenePoolId} = SceneObject,
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, get_trace_info_cast, [Aid, Sign, Id, []]),
            NewNode = lib_node_action:wait_cast_back(Node, NowTime),
            {State, ?BTREERUNNING, NewNode};
        _ ->
            {State,StateName , ?BTREEFAILURE}
    end.

%% 找不到目标
action_call_back(State, StateName, _Node, _NowTime, _TickGap, {'get_for_trace', false}) ->
    {failure, State, StateName};
%% 找到了目标
action_call_back(State, StateName, Node0, _NowTime, _TickGap, {'get_for_trace', {Sign, TargetId, TargetPid, TargetX, TargetY}}) when is_record(State, ob_act) ->
    Node = lib_node_action:cast_back_success(Node0),
    #ob_act{object = Object} = State,
    #action_node{args = ActionArgs} = Node,
    {_, OppositeDis} = ulists:keyfind(opposite_dis, 1, ActionArgs, 5000),
    #scene_object{x=ObjectX, y=ObjectY} = Object,
    IsSatisfy = umath:distance_pow({ObjectX, ObjectY}, {TargetX, TargetY}) =< OppositeDis * OppositeDis,
    if
        IsSatisfy ->
            Target = #{id=>TargetId, sign=>Sign, pid=>TargetPid, x=>TargetX, y=>TargetY},
            NState = State#ob_act{att = Target},
            {update, NState, Node};
        true ->
            {failure, State, StateName}
    end;
%% 首次对峙的目标无了,重新寻找目标
action_call_back(State, _StateName, Node0, _NowTime, _TickGap, {'trace_info_back', false})  when is_record(State, ob_act) ->
    Node = lib_node_action:cast_back_success(Node0),
    #ob_act{object = Object} = State,
    #scene_object{
        aid = Aid,
        scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId,
        x=ObjectX, y=ObjectY
    } = Object,
    Args = lib_scene_calc:make_scene_calc_args(Object),
    #action_node{args = ActionArgs} = Node,
    {_, OppositeDis} = ulists:keyfind(opposite_dis, 1, ActionArgs, 5000),
    mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_scene_calc, get_any_for_trace_cast,
        [Aid, CopyId, ObjectX, ObjectY, OppositeDis, Args, undefined]),
    {update, State, Node};
action_call_back(State, StateName, Node, NowTime, _TickGap, {'trace_info_back', [Sign, TargetId, TargetX, TargetY, []|_] = _TargetInfo})  when is_record(State, ob_act) ->
    #ob_act{object = Object} = State,
    #action_node{args = ActionArgs, action_status = #action_node_status{next_action_args = OppositeEndTime}} = Node,
    {_, OppositeDis} = ulists:keyfind(opposite_dis, 1, ActionArgs, 5000),
    #scene_object{
        aid = Aid, scene = SceneId, scene_pool_id = ScenePoolId,
        copy_id = CopyId, x=ObjectX, y=ObjectY
    } = Object,
    IsSatisfy = umath:distance_pow({ObjectX, ObjectY}, {TargetX, TargetY}) =< OppositeDis * OppositeDis,
    if
        IsSatisfy ->
            Target = #{id=>TargetId, sign=>Sign, x=>TargetX, y=>TargetY},
            NState = State#ob_act{att = Target},
            case NowTime >= OppositeEndTime of
                true -> {finish, NState, StateName};
                _ -> {update, NState, Node}
            end;
        true ->
            {_, OppositeDis} = ulists:keyfind(opposite_dis, 1, ActionArgs, 5000),
            Args = lib_scene_calc:make_scene_calc_args(Object),
            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_scene_calc, get_any_for_trace_cast,
                [Aid, CopyId, ObjectX, ObjectY, OppositeDis, Args, undefined]),
            {update, State, Node}
    end;
%对峙中被攻击，马上反击
action_call_back(State, StateName, _Node, _NowTime, _TickGap, {'battle_info', MonAtter}) ->
    #mon_atter{att_sign = Sign, id = Id} = MonAtter,
    Target = #{id=>Id, sign=>Sign},
    NState = State#ob_act{att = Target},
    {finish, NState, StateName};
action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.
