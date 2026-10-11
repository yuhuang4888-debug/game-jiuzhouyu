%% ---------------------------------------------------------------------------
%% @doc lib_node_attack

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/6/01 0012
%% @desc    宠物随机释放技能
%% ---------------------------------------------------------------------------
-module(lib_node_pet_attack).

%-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).
%% player API
% -export([object_start_battle/8, object_combo_battle/4,
%     object_start_assist/6, object_combo_assist/4]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").
-include("attr.hrl").
-include("skill.hrl").
-include("battle.hrl").
-include("def_fun.hrl").
-include("player_behavior.hrl").

action(PS, StateName, Node, NowTime, _TickGap) when is_record(PS, player_status) ->
    #player_status{ behavior_status = BehaviorStatus } = PS,
    #player_behavior{att = Att} = BehaviorStatus,
    if
        is_map(Att) ->
            case lib_player_behavior_battle_pet:pet_release_a_skill(PS, NowTime, Att) of
                {success, NewPS, SuccessMs} ->
                    NewNode = lib_node_action:set_time_success(Node, NowTime, SuccessMs),
                    {NewPS, ?BTREERUNNING, NewNode};
                {re_action, WaitMs, NewPS} ->
                    NewNode = lib_node_action:set_time_re_action(Node, NowTime, WaitMs),
                    {NewPS, ?BTREERUNNING, NewNode};
                {re_action, WaitMs} ->
                    NewNode = lib_node_action:set_time_re_action(Node, NowTime, WaitMs),
                    {PS, ?BTREERUNNING, NewNode};
                _ ->
                    {PS, StateName, ?BTREEFAILURE}
            end;
        true ->
            {PS, StateName, ?BTREEFAILURE}
    end.

re_action(State, StateName, Node, Now, TickGap) ->
    action(State, StateName, Node, Now, TickGap).

action_call_back(PS, StateName, _Node, NowTime, TickGap, {'pet_object_battle_back', SkillReturn}) when is_record(PS, player_status) ->
    lib_player_behavior_battle_pet:pet_object_battle_back(PS, StateName, NowTime, TickGap, SkillReturn);

action_call_back(PS, StateName, _Node, _NowTime, _TickGap, {'role_pet_combo', ComboArgs}) when is_record(PS, player_status) ->
    #player_status{
        scene = SceneId, scene_pool_id = PoolId, id = RoleId,
        behavior_status = BehaviorStatus, x = XNow, y = YNow
    } = PS,
    #player_behavior{att = AttTarget, pet_battle = BehaviorBattle} = BehaviorStatus,
    #pet_behavior_battle{selected_skill = SelectSkillMap} = BehaviorBattle,
    %% 需要把 select_skill存进去SelectSkillMap
    {_OX, _OY, _X, _Y, SkillId, SkillLv, _OldReFindT, _OldRadian, _TrackTarget} = ComboArgs,
    case lib_battle:combo_active_battle_set_args_radian(AttTarget, XNow, YNow, ComboArgs) of
        {_SkillR, Args, Radian} ->
            SelectedSkillInfo = #selected_skill{skill_id = SkillId},
            NewSelectSkillMap = SelectSkillMap#{SkillId => SelectedSkillInfo},
            NewBehaviorBattle = BehaviorBattle#pet_behavior_battle{selected_skill = NewSelectSkillMap},
            NewBehaviorStatus = BehaviorStatus#player_behavior{pet_battle = NewBehaviorBattle},
            mod_scene_agent:apply_cast_with_state(SceneId, PoolId, lib_player_behavior_battle_pet, pet_object_combo_battle, [RoleId, SkillId, SkillLv, Args, Radian]),
            PS#player_status{behavior_status = NewBehaviorStatus};
        _ ->
            {failure, PS, StateName}
    end;

action_call_back(PS, StateName, _Node, NowTime, TickGap, {'pet_combo_battle_back', SkillReturn}) when is_record(PS, player_status) ->
    lib_player_behavior_battle_pet:pet_combo_battle_back(PS, StateName, NowTime, TickGap, SkillReturn);

action_call_back(PS, StateName, _Node, NowTime, TickGap, {'pet_assist_battle_back', SkillReturn}) when is_record(PS, player_status) ->
    lib_player_behavior_battle_pet:pet_assist_battle_back(PS, StateName, NowTime, TickGap, SkillReturn);

action_call_back(PS, _StateName, _Node, _NowTime, _TickGap, {'role_pet_assist_combo', ComboArgs}) when is_record(PS, player_status) ->
    #player_status{scene = SceneId, scene_pool_id = PoolId, id = RoleId, behavior_status = #player_behavior{att = AttTarget}} = PS,
    mod_scene_agent:apply_cast_with_state(SceneId, PoolId, lib_player_behavior_battle_pet, pet_object_combo_assist, [RoleId, AttTarget, ComboArgs]),
    PS;

action_call_back(PS, StateName, _Node, NowTime, TickGap, {'pet_combo_assist_battle_back', SkillReturn}) when is_record(PS, player_status) ->
    lib_player_behavior_battle_pet:pet_combo_assist_battle_back(PS, StateName, NowTime, TickGap, SkillReturn);
action_call_back(_, _, _, _, _, _) ->
    skip.



