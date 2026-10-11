%% ---------------------------------------------------------------------------
%% @doc lib_node_patrol

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/8/12 0012
%% @desc   巡逻在往指定路线移动同时，寻找目标
%% ---------------------------------------------------------------------------
-module(lib_node_patrol).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").
-include("attr.hrl").

-define(NEAR_DISTANCE_SQUARE,   150 * 150).

%% TODO 待优化
%% 1.设定路径
%% 2.判断是否有目标，有目标判断目标距离再确定是否打断巡逻#无目标则先寻找是否有目标目标
action(State, _StateName, Node, Now, TickGap) when is_record(State, ob_act) ->
    #ob_act{object = SceneObject, att = Att, path = OldPath} = State,
    #scene_object{
        x = X, y = Y, scene = SceneId, scene_pool_id = ScenePoolId,
        aid = Aid, copy_id = CopyId
    } = SceneObject,
    #action_node{args = ActionArgs} = Node,
    case Att of
        #{id:=Id, sign:=Sign} ->
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, get_trace_info_cast, [Aid, Sign, Id, []]),
            NewNode = lib_node_action:wait_cast_back(Node, Now),
            {State, ?BTREERUNNING, NewNode};
        _ ->
            case OldPath of
                [] -> Path = create_walk_path(TickGap, ActionArgs, SceneObject);
                _ -> Path = OldPath
            end,
            AfPathState = State#ob_act{path = Path},
            {_, WarningRange} = ulists:keyfind(waring_range, 1, ActionArgs, 500),
            Args = lib_scene_calc:make_scene_calc_args(SceneObject),
            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_scene_calc, get_any_for_trace_cast,
                [Aid, CopyId, X, Y, WarningRange, Args, undefined]),
            NewNode = lib_node_action:wait_cast_back(Node, Now),
            {AfPathState, ?BTREERUNNING, NewNode}
    end.

re_action(State, StateName, Node,  Now, TickGap) ->
    action(State, StateName, Node,  Now, TickGap).


%% 成功找到目标#判断目标距离是否停止巡逻
action_call_back(State, StateName, _Node, _NowTime, _TickGap, {'get_for_trace', {Sign, TargetId, TargetPid, TargetX, TargetY}}) when is_record(State, ob_act) ->
    Target = #{id=>TargetId, sign=>Sign, pid=>TargetPid, x=>TargetX, y=>TargetY},
    NState = State#ob_act{att = Target, path = []},
    {finish, NState, StateName};
%% 无目标#开始巡逻
action_call_back(State, StateName, Node, NowTime, _TickGap, {'get_for_trace', false}) ->
    do_walk(State, StateName, Node, NowTime);
%% 最终目标已经不在场景
action_call_back(State, StateName, Node, NowTime, TickGap, {'trace_info_back', false})  when is_record(State, ob_act) ->
    #action_node{args = ActionArgs} = Node,
    Path = create_walk_path(TickGap, ActionArgs, State#ob_act.object),
    AfPathState = State#ob_act{path = Path},
    NewNode = lib_node_action:set_time_re_action(Node,  NowTime, TickGap),
    do_walk(AfPathState, StateName, NewNode, NowTime);
action_call_back(State, StateName, Node, NowTime, TickGap, {'trace_info_back', [_TargetId, TargetX, TargetY, _|_] = _TargetInfo})  when is_record(State, ob_act) ->
    #ob_act{object = #scene_object{x = X, y = Y} = SceneObject, path = OldPath} = State,
    #action_node{args = ActionArgs} = Node,
    {_, WaringRange} = ulists:keyfind(waring_range, 1, ActionArgs, 500),
    IsSatisfy = umath:distance_pow({X, Y}, {TargetX, TargetY}) =< WaringRange * WaringRange,
    if
        IsSatisfy ->
            Target = #{x=>TargetX, y=>TargetY},
            NState = State#ob_act{att = Target, path = []},
            {finish, NState, StateName};
        true ->
            case OldPath of
                [] -> Path = create_walk_path(TickGap, ActionArgs, SceneObject);
                _ -> Path = OldPath
            end,
            AfPathState = State#ob_act{path = Path},
            NewNode = lib_node_action:set_time_re_action(Node,  NowTime, TickGap),
            do_walk(AfPathState, StateName, NewNode, NowTime)
    end;
action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.

do_walk(State, StateName, Node, NowTime) ->
    #ob_act{path = WalkPath, object = SceneObject} = State,
    [{NextX, NextY}|RemainPath] = WalkPath,
    #scene_object{battle_attr = BA, x = X, y = Y} = SceneObject,
    #battle_attr{speed=Speed} = BA,
    % TODO 移动过程中是否寻找目标,这个看实际需求
    % if
    %     Kind =:= ?MON_KIND_ATT orelse Kind =:= ?MON_KIND_ATT_NOT_PLAYER orelse Kind =:= ?MON_KIND_ATT_TO_PLAYER ->
    %         find_target_cast(Minfo);
    %     true ->
    %         ok
    % end,
    case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
        {false, MoveWaitMs} when is_integer(MoveWaitMs) ->
            {update, State, Node};
        {false, _} ->
            {update, State, Node};
        true ->
            case lib_scene_object_ai:move(NextX, NextY, SceneObject, Speed, false) of
                block ->
                    {failure, State#ob_act{path=[]}, StateName};
                {true, NewSceneObject, _Time} ->
                    lib_mon_event:move(NewSceneObject),
                    NewState = State#ob_act{object=NewSceneObject, path=RemainPath, o_point = {X, Y}, w_point = {NextX, NextY}},
                    {update, NewState, Node}
            end
    end.

create_walk_path(TickGap, ActionArgs, SceneObject) ->
    {_, PointS} = lists:keyfind(path_point, 1, ActionArgs),
    case PointS of
        [{TargetX, TargetY}] ->
            #scene_object{
                x = X, y = Y,
                battle_attr = #battle_attr{speed = Speed},
                mon = #scene_mon{d_x = BornX, d_y = BornY}
            } = SceneObject,
            Path1 = lib_scene_object_ai:dest_path_speed(X, Y, TargetX, TargetY, TickGap, Speed),
            Path2 = lib_scene_object_ai:dest_path_speed(TargetX, TargetY, BornX, BornY, TickGap, Speed),
            Path = Path1 ++ Path2,
            Path;
        % 其余情况待处理
        _ ->
            []
    end.
