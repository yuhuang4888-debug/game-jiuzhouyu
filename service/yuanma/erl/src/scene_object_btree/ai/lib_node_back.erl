%% ---------------------------------------------------------------------------
%% @doc lib_node_back

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/8/12 0012
%% @desc
%% ---------------------------------------------------------------------------
-module(lib_node_back).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").
-include("attr.hrl").

action(State, StateName, Node, NowTime, _TickGap) when is_record(State, ob_act) ->
    #ob_act{object = SceneObject} = State,
    #scene_object{sign = Sign, x = X, y = Y, mon=#scene_mon{d_x = Dx, d_y = Dy}, battle_attr = BA} = SceneObject,
    case Sign == ?BATTLE_SIGN_BTREE_MON orelse Sign == ?BATTLE_SIGN_MON of
        true when {X, Y} == {Dx, Dy} ->
            {State, idle, ?BTREESUCCESS};
        true ->
            BackPath = lib_scene_object_ai:dest_path(X, Y, Dx, Dy, BA#battle_attr.speed),
            AfPathState = State#ob_act{back_dest_path = BackPath, att = undefined},
            do_back_walk(AfPathState, StateName, Node, NowTime);
        _ ->
            {State, StateName , ?BTREEFAILURE}
    end.

re_action(State, StateName, Node, NowTime, _TickGap) ->
    do_back_walk(State, StateName, Node, NowTime).

action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.

do_back_walk(State, _StateName, Node, NowTime) ->
    #ob_act{back_dest_path = BackDestPath, object = SceneObject, check_block = CheckBlock} = State,
    case BackDestPath of
        [{NextX, NextY}|RemainPath] ->
            #scene_object{battle_attr = BA} = SceneObject,
            #battle_attr{speed=Speed} = BA,
            case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
                {false, MoveWaitMs} when is_integer(MoveWaitMs) ->
                    {State, ?BTREERUNNING, Node};
                {false, _} ->
                    {State, ?BTREERUNNING, Node};
                true ->
                    case lib_scene_object_ai:move(NextX, NextY, SceneObject, Speed, CheckBlock) of
                        block ->
                            {State#ob_act{path=[]}, idle, ?BTREEFAILURE};
                        {true, NewSceneObject, WSTime} ->
                            lib_mon_event:move(NewSceneObject),
                            NewState = State#ob_act{object=NewSceneObject, back_dest_path=RemainPath},
                            NewNode = lib_node_action:set_time_re_action(Node, NowTime, WSTime),
                            {NewState, ?BTREERUNNING, NewNode}
                    end
            end;
        _ ->
            % 走回了原点，闲置状态
            {State#ob_act{att = undefined}, idle, ?BTREESUCCESS}
    end.