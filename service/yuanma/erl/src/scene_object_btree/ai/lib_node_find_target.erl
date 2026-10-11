%% ---------------------------------------------------------------------------
%% @doc lib_node_find_target

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/4/27 0027
%% @desc
%% ---------------------------------------------------------------------------
-module(lib_node_find_target).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").
-include("player_behavior.hrl").

action(State, StateName, Node, NowTime, _TickGap) when is_record(State, ob_act) ->
    #ob_act{object = Object, att = Att} = State,
    case Att of
        undefined ->
            #scene_object{
                aid = Aid,
                scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId,
                x=ObjectX, y=ObjectY,
                warning_range=WarningRange
            } = Object,
            Args = lib_scene_calc:make_scene_calc_args(Object),
            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_scene_calc, get_any_for_trace_cast,
                [Aid, CopyId, ObjectX, ObjectY, WarningRange, Args, {closest, ObjectX, ObjectY}]),
            NewNode = lib_node_action:wait_cast_back(Node, NowTime),
            {State, ?BTREERUNNING, NewNode};
        _ -> {State, StateName, ?BTREESUCCESS}
    end;
    %#scene_object{
    %    aid = Aid,
    %    scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId,
    %    x=ObjectX, y=ObjectY,
    %    warning_range=WarningRange
    %} = Object,
    %Args = lib_scene_calc:make_scene_calc_args(Object),
    %mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_scene_calc, get_any_for_trace_cast,
    %    [Aid, CopyId, ObjectX, ObjectY, WarningRange, Args, undefined]),
    %{State, ?BTREERUNNING, Node}.
action(PS, StateName, _Node, _NowTime, _TickGap) when is_record(PS, player_status) ->
    #player_status{ behavior_status = BehaviorStatus } = PS,
    case lib_player_behavior_battle:get_battle_att(PS) of
        Att when is_map(Att) ->
            NewBehaviorStatus = BehaviorStatus#player_behavior{att = Att},
            PS1 = PS#player_status{ behavior_status = NewBehaviorStatus },
            {PS1, StateName, ?BTREESUCCESS};
        _ ->
            {PS, StateName, ?BTREEFAILURE}
    end.


re_action(State, StateName, _Node, _Now, _TickGap) ->
    {State, StateName, ?BTREEFAILURE}.

%% 成功找到目标
action_call_back(State, StateName, _Node, _NowTime, _TickGap, {'get_for_trace', {Sign, TargetId, TargetPid, TargetX, TargetY}}) when is_record(State, ob_act) ->
    Target = #{id=>TargetId, sign=>Sign, pid=>TargetPid, x=>TargetX, y=>TargetY},
    NState = State#ob_act{att = Target},
    {finish, NState, StateName};
action_call_back(State, StateName, _Node, _NowTime, _TickGap, {'get_for_trace', false}) when is_record(State, ob_act) ->
    #ob_act{object = #scene_object{sign = _Sign}} = State,
    % 找不到目标都统一发呆两秒
    {failure, State#ob_act{att = undefined}, StateName, 2000};
    %case Sign of
    %    ?BATTLE_SIGN_DUMMY ->
    %        {failure, State#ob_act{att = undefined}, StateName, 2000};
    %    _ ->
    %        {failure, State#ob_act{att = undefined}, StateName}
    %end;
action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.
