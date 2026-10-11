%% ---------------------------------------------------------------------------
%% @doc lib_node_walk

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/7/30 0030
%% @desc
%% ---------------------------------------------------------------------------
-module(lib_node_walk).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").
-include("attr.hrl").
-include("def_fun.hrl").
-include("player_behavior.hrl").

-define(NEAR_DISTANCE_SQUARE,   150 * 150).

action(PS, StateName, Node, Now, TickGap) when is_record(PS, player_status) ->
    #action_node{args = NodeArgs} = Node,
    {_, WalkPoint} = ulists:keyfind(point, 1, NodeArgs, {point, []}),
    #player_status{behavior_status = BehaviorStatus} = PS,
    case lib_player_behavior:get_walk_path(PS, WalkPoint) of
        false ->
            {PS, StateName , ?BTREEFAILURE};
        PathOrPoint ->
            case PathOrPoint of
                {TargetX, TargetY} ->
                    NewBehaviorStatus = BehaviorStatus#player_behavior{walk_point = {TargetX, TargetY}};
                Path ->
                    NewBehaviorStatus = BehaviorStatus#player_behavior{walk_path = Path}
            end,
            NewPS = PS#player_status{behavior_status = NewBehaviorStatus},
            case lib_player_behavior:start_walk(NewPS, Now, TickGap) of
                success ->
                    {NewPS, StateName , ?BTREESUCCESS};
                {success, LastPS} ->
                    {LastPS, StateName , ?BTREESUCCESS};
                {re_action, MoveWaitMs} ->
                    NewNode = lib_node_action:set_time_re_action(Node, Now, MoveWaitMs),
                    {NewPS, ?BTREERUNNING, NewNode};
                {re_action, MoveWaitMs, LastPS} ->
                    NewNode = lib_node_action:set_time_re_action(Node, Now, MoveWaitMs),
                    {LastPS, ?BTREERUNNING, NewNode};
                _ ->
                    {NewPS, StateName , ?BTREEFAILURE}
            end
    end;
action(State, StateName, Node, Now, _TickGap) when is_record(State, ob_act) ->
    #ob_act{object = SceneObject} = State,
    #scene_object{x = X, y = Y, battle_attr = #battle_attr{speed = _Speed}} = SceneObject,
    #action_node{args = NodeArgs} = Node,
    {_, WalkPoint} = lists:keyfind(point, 1, NodeArgs),
    case WalkPoint of
        {TargetX, TargetY} ->
            IsReach = umath:distance_pow({TargetX, TargetY}, {X, Y}) =< ?NEAR_DISTANCE_SQUARE,
            if
                IsReach -> {State,StateName , ?BTREESUCCESS};
                true ->
                    %NewNode = lib_node_action:set_time_re_action(Node,  Now, TickGap),
                    %Path = lib_scene_object_ai:dest_path_speed(X, Y, TargetX, TargetY, TickGap, Speed),
                    Path = lib_scene_object_ai:dest_path(X, Y, TargetX, TargetY, _Speed),
                    do_walk(State#ob_act{path = Path}, StateName, Node, Now)
            end;
        Path when is_list(WalkPoint) ->
            %NewNode = lib_node_action:set_time_re_action(Node,  Now, TickGap),
            do_walk(State#ob_act{path = Path}, StateName, Node, Now);
        _ ->
            {State,StateName , ?BTREEFAILURE}
    end.

re_action(PS, StateName, Node,  Now, TickGap) when is_record(PS, player_status) ->
    case lib_player_behavior:start_walk(PS, Now, TickGap) of
        success ->
            {PS, StateName , ?BTREESUCCESS};
        {success, LastPS} ->
            {LastPS, StateName , ?BTREESUCCESS};
        {re_action, MoveWaitMs} ->
            NewNode = lib_node_action:set_time_re_action(Node, Now, MoveWaitMs),
            {PS, ?BTREERUNNING, NewNode};
        {re_action, MoveWaitMs, LastPS} ->
            NewNode = lib_node_action:set_time_re_action(Node, Now, MoveWaitMs),
            {LastPS, ?BTREERUNNING, NewNode};
        _ ->
            {PS, StateName , ?BTREEFAILURE}
    end;
re_action(State, StateName, Node,  Now, _TickGap) when is_record(State, ob_act) ->
    do_walk(State, StateName, Node, Now).

action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.

do_walk(State, StateName, Node, NowTime) ->
    #ob_act{path = WalkPath, object = SceneObject, can_walk = CanWalk, check_block = CheckBlock} = State,
    if
        CanWalk == false ->
            {State,StateName , ?BTREEFAILURE};
        WalkPath == [] ->
            {State,StateName , ?BTREESUCCESS};
        true ->
            #scene_object{battle_attr = BA, x = X, y = Y} = SceneObject,
            [{NextX, NextY}|RemainPath] = WalkPath,
            IsNext =
                case RemainPath of
                    [] -> true;
                    _ ->
                        [{DestX, DestY}|_] = lists:reverse(RemainPath),
                        not (umath:distance_pow({DestX, DestY}, {X, Y}) =< ?NEAR_DISTANCE_SQUARE)
                end,
            #battle_attr{speed=Speed} = BA,
            case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
                _ when not IsNext ->
                    {State,StateName , ?BTREESUCCESS};
                {false, MoveWaitMs} when is_integer(MoveWaitMs) ->
                    {State, ?BTREERUNNING, Node};
                {false, _} ->
                    {State, ?BTREERUNNING, Node};
                true ->
                    case lib_scene_object_ai:move(NextX, NextY, SceneObject, Speed, CheckBlock) of
                        block ->
                            {State#ob_act{path=[]},StateName , ?BTREEFAILURE};
                        {true, NewSceneObject, WSTime} ->
                            lib_mon_event:move(NewSceneObject),
                            NewState = State#ob_act{object=NewSceneObject, path=RemainPath, o_point = {X, Y}, w_point = {NextX, NextY}},
                            NewNode = lib_node_action:set_time_re_action(Node, NowTime, WSTime),
                            {NewState, ?BTREERUNNING, NewNode}
                    end
            end
    end.
