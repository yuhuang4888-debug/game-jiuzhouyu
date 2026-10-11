%% ---------------------------------------------------------------------------
%% @doc lib_node_trace

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/4/27 0027
%% @desc
%% ---------------------------------------------------------------------------
-module(lib_node_trace).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene_object_btree.hrl").
-include("scene.hrl").
-include("attr.hrl").

-define(TRACE_SUCCESS_DIS, 1000).        % 追踪到1000码内表示成功

%% TODO 追踪范围处理#追到制定距离失败，返回出生点
action(State, StateName, Node, NowTime, _TickGap) when is_record(State, ob_act) ->
    #ob_act{att = Att, object = SceneObject} = State,
    case Att of
        #{id:=Id, sign:=Sign} ->
            #scene_object{aid = Aid, scene = SceneId, scene_pool_id = ScenePoolId} = SceneObject,
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent,
                get_trace_info_cast, [Aid, Sign, Id, []]),
            % 等待5s，对性能好，防止做多余的tick，一般来说会迅速返回消息执行 action_call_back
            NewNode = lib_node_action:set_time_re_action(Node, NowTime, 5000),
            {State, ?BTREERUNNING, NewNode};
        _ -> {State,StateName , ?BTREEFAILURE}
    end.


re_action(State, StateName, _Node, Now, TickGap) ->
    action(State, StateName, _Node, Now, TickGap).


action_call_back(State, StateName, _Node, _NowTime, _TickGap, {'trace_info_back', false})  when is_record(State, ob_act) ->
    {failure, State#ob_act{att = undefined}, StateName};
action_call_back(State, StateName, Node, NowTime, _TickGap, {'trace_info_back', [TargetSign, TargetId, TargetX, TargetY, []|_] = _TargetInfo})  when is_record(State, ob_act) ->
    #ob_act{att = Att, object = SceneObject, ref = _Ref} = State,
    NewAtt = Att#{id=>TargetId, x=>TargetX, y=>TargetY, sign=>TargetSign},
    #scene_object{x = X, y = Y, scene = SceneId, copy_id = CopyId, battle_attr = BA} = SceneObject,
    IsContinueTrace = lib_node_check:is_continue_trace(TargetX, TargetY, SceneObject),
    % IsContinueTrace = true,
    #battle_attr{speed = Speed} = BA,
    IsCanMove = lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime),
    if
        not IsContinueTrace -> {failure, State#ob_act{att = undefined}, StateName};
        not IsCanMove -> {failure, State#ob_act{att = undefined}, StateName};
        true ->
            case lib_scene_object_ai:get_next_step(X, Y, ?TRACE_SUCCESS_DIS, SceneId, CopyId, TargetX, TargetY, true) of
                {NextX, NextY} ->
                    #battle_attr{speed = Speed, attr = _Attr} = BA,
                    case lib_scene_object_ai:move(NextX, NextY, SceneObject, Speed, false) of
                        block ->
                            {failure, State#ob_act{att = undefined}, StateName};
                        {true, NewSceneObject, NextMoveTime} ->
                            % TODO-lzh 当前移动实际定时触发移动一小步，在客户端显示可能会有卡顿状。
                            NewNode = lib_node_action:set_time_re_action(Node, NowTime, NextMoveTime),
                            NState = State#ob_act{att = NewAtt, object = NewSceneObject, next_move_time = NextMoveTime},
                            {update, NState, NewNode}
                    end;
                attack ->
                    {finish, State#ob_act{att = NewAtt}, StateName}
            end
    end;
action_call_back(_, _, _, _, _, _) ->
    skip.
