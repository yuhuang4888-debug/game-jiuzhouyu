%% ---------------------------------------------------------------------------
%% @doc lib_node_other

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/2/8 0008
%% @desc    其余行为
%% ---------------------------------------------------------------------------
-module(lib_node_other).


-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").

action(State, StateName, Node, _Now, _TickGap) when is_record(State, ob_act) ->
    #action_node{args = Args} = Node,
    {NewStateName, NewState} = do_action(Args, StateName, State),
    {NewState, NewStateName, ?BTREESUCCESS}.

re_action(State, StateName, _Node, _Now, _TickGap) ->
    {State,StateName , ?BTREESUCCESS}.

action_call_back(_State, _StateName, _Node, _NowTime, _, _) ->
    skip.

do_action([], StateName, State) -> {StateName, State};
do_action([H|T], StateName, State) ->
    {NewStateName, NewState} =
        case H of
            {model_id, ModelId} ->
                #ob_act{object = SceneObj} = State,
                NewSceneObj = lib_scene_object_ai:change_model(SceneObj, ModelId),
                lib_scene_object:insert(NewSceneObj),
                {StateName, State#ob_act{object = NewSceneObj}};
            {skill, SkillL} ->
                #ob_act{object = SceneObj} = State,
                NewSceneObj = SceneObj#scene_object{skill=SkillL},
                {StateName, State#ob_act{object = NewSceneObj}};
            % 技能公共cd配置
            {pub_skill_cd_cfg, CdCfg} ->
                #ob_act{object = SceneObj} = State,
                #scene_object{pub_skill_cd_cfg=OldCdCfg} = SceneObj,
                OldCdCfg =/= CdCfg andalso lib_scene_object:update(SceneObj, [{pub_skill_cd_cfg, CdCfg}]),
                NewSceneObj = SceneObj#scene_object{pub_skill_cd_cfg=CdCfg},
                {StateName, State#ob_act{object = NewSceneObj}};
            {clear_scene_mon, MonIds} ->
                #ob_act{object = #scene_object{scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId}} = State,
                lib_mon:clear_scene_mon_by_mids(SceneId, ScenePoolId, CopyId, 1, MonIds),
                {StateName, State};
            _ ->
                {StateName, State}
        end,
    do_action(T, NewStateName, NewState).
