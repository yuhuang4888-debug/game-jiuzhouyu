%% ---------------------------------------------------------------------------
%% @doc lib_node_skill

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/5/12 0012
%% @desc    释放指定技能
%% ---------------------------------------------------------------------------
-module(lib_node_skill).

-behaviour(lib_node_action).

%% API
-export([action/5, re_action/5, action_call_back/6]).
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").
-include("attr.hrl").
-include("skill.hrl").
-include("battle.hrl").
-include("def_fun.hrl").
-include("player_behavior.hrl").

%%
action(State, _StateName, Node, NowTime, _TickGap) when is_record(State, ob_act) ->
    #action_node{args = Args} = Node,
    {ac_skill, {SkillId, SkillLv}} = ulists:keyfind(ac_skill, 1, Args, {ac_skill, {1, 1}}),
    NewState = lib_scene_object_ai:object_ac_skill(State, SkillId, SkillLv),
    % 给个返回时间
    NewNode = lib_node_action:set_time_success(Node, NowTime, 2000),
    {NewState, ?BTREERUNNING, NewNode}.

re_action(State, StateName, Node, Now, TickGap) ->
    action(State, StateName, Node, Now, TickGap).

%% 主技能释放返回
action_call_back(State, StateName, Node, NowTime, _TickGap, {'object_battle_back', Res}) when is_record(State, ob_act) ->
    #ob_act{selected_skill = SelectSkillMap} = State,
    case Res of
        #skill_return{used_skill = SkillId} ->
            case maps:find(SkillId, SelectSkillMap) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    handle_battle_res(State, StateName, Node, NowTime, SelectedSkillInfo, Res);
                _ ->
                    {failure, State, StateName}
            end;
        _ ->
            {failure, State, StateName}
    end;
% 副技能释放返回#保存新的State节点运行状态设置在主技能返回时处理
action_call_back(State, StateName, _Node, _NowTime, _TickGap, {'combo_battle_back', Res}) when is_record(State, ob_act) ->
    case Res of
        #skill_return{used_skill = SkillId, aer_info = BackData} ->
            case maps:find(SkillId, State#ob_act.selected_skill) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    lib_scene_object_ai:battle_combo_res(SelectedSkillInfo, State, Res);
                _ ->
                    #ob_act{object = Object} = State,
                    BackObj = lib_battle_api:update_by_slim_back_data(Object, BackData),
                    NewState = State#ob_act{object = BackObj},
                    {failure, NewState, StateName}
            end;
        _ ->
            {failure, State, StateName}
    end;

action_call_back(State, StateName, Node, NowTime, _TickGap, {'object_assist_back', Res}) when is_record(State, ob_act) ->
    #ob_act{selected_skill = SelectSkillMap} = State,
    case Res of
        #skill_return{used_skill = SkillId} ->
            case maps:find(SkillId, SelectSkillMap) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    handle_assist_res(State, StateName, Node, NowTime, SelectedSkillInfo, Res);
                _ ->
                    {failure, State, StateName}
            end;
        _ ->
            {failure, State, StateName}
    end;

action_call_back(State, StateName, _Node, _NowTime, _TickGap, {'combo_assist_back', Res}) when is_record(State, ob_act) ->
    case Res of
        #skill_return{used_skill = SkillId, aer_info = BackData} ->
            case maps:find(SkillId, State#ob_act.selected_skill) of
                {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                    lib_scene_object_ai:assist_combo_res(SelectedSkillInfo, State, Res);
                _ ->
                    #ob_act{object = Object} = State,
                    BackObj = lib_battle_api:update_by_slim_back_data(Object, BackData),
                    NewState = State#ob_act{object = BackObj},
                    {failure, NewState, StateName}
            end;
        _ ->
            {failure, State, StateName}
    end.

%% ======================================== Inner Fuc ==============================================
handle_battle_res(State, StateName, Node, NowTime, SelectedSkillInfo, SkillReturn) ->
    #ob_act{release_skill = ReleaseSkill, object = SceneObject} = State,
    #selected_skill{
        att_time = AttTime,
        skill_id = SkillId,
        spell_time = SpellTime,
        is_refind_t = IsReFindT,
        link_info = SkillLinkInfo1,
        normal = IsNormal
    } = SelectedSkillInfo,
    #scene_object{aid = Aid, temp_skill = TempSkillL} = SceneObject,
    case SkillReturn of
        #skill_return{
            aer_info = BackData,
            rx = OX, ry = OY, tx = AttX, ty = AttY, radian = Radian,
            used_skill = SkillId,
            main_skill = MainSkillId
        } ->
            BackObj = lib_battle_api:update_by_slim_back_data(SceneObject, BackData),
            case lib_scene_object_ai:is_combo(MainSkillId, BackObj#scene_object.skill_combo) of
                false -> skip;
                {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} ->
                    ComboArgs = {OX, OY, AttX, AttY, NextSkillId, NextSkillLv, IsReFindT, BulletDis, Radian},
                    erlang:send_after(NextSkillTime, Aid, {'combo', ComboArgs})
            end,
            %% 技能施放时间
            SpellTime1 = ?IF(IsNormal == 1, max(200, SpellTime+100), SpellTime),
            TempSkillL1 = lists:keydelete(SkillId, 1, TempSkillL),
            % 成功释放
            case ReleaseSkill of
                #release_skill{is_ok = 0, skill_id = SkillId} -> ReleaseSkillL = [{release_skill, ReleaseSkill#release_skill{is_ok = 1}}];
                _ -> ReleaseSkillL = []
            end,
            ObaArgs = ReleaseSkillL ++ [{obj, BackObj#scene_object{temp_skill=TempSkillL1}},
                {skill_link_info, SkillLinkInfo1}, {att_time, AttTime}, {selected_skill, {SkillId, []}}],
            NewState = lib_scene_object_ai:set_ac_state(ObaArgs, State),
            NewNode = lib_node_action:set_time_success(Node, NowTime, SpellTime1),
            {update, NewState, NewNode};
        _ ->
            % 失败释放就去掉
            case ReleaseSkill of
                #release_skill{is_ok = 0, skill_id = SkillId} -> ReleaseSkillL = [{release_skill, undefined}];
                _ -> ReleaseSkillL = []
            end,
            ObaArgs = ReleaseSkillL ++ [{att_time, AttTime}, {selected_skill, {SkillId, []}}],
            NewState = lib_scene_object_ai:set_ac_state(ObaArgs, State),
            {failure, NewState, StateName}
    end.

handle_assist_res(State, StateName, Node, NowTime, SelectedSkillInfo, Res) ->
    #ob_act{release_skill = ReleaseSkill, object = SceneObject} = State,
    #scene_object{aid = Aid, x = X, y = Y, temp_skill = TempSkillL} = SceneObject,
    #selected_skill{
        att_time = AttTime,
        skill_id = SkillId,
        spell_time = SpellTime,
        is_refind_t = IsReFindT
    } = SelectedSkillInfo,
    case Res of
        #skill_return{
            aer_info = BackData,
            % rx = RX, ry = RY, tx = TX, ty = TY, radian = Radian,
            used_skill = SkillId,
            main_skill = MainSkillId
        } ->
            BackObj = lib_battle_api:update_by_slim_back_data(SceneObject, BackData),
            case lib_scene_object_ai:is_combo(MainSkillId, BackObj#scene_object.skill_combo) of
                false -> skip;
                {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} -> %% combo技能施放
                    ComboArgs = {X, Y, X, Y, NextSkillId, NextSkillLv, IsReFindT, BulletDis, 0},
                    erlang:send_after(NextSkillTime, Aid, {'combo', ComboArgs})
            end,
            TempSkillL1 = lists:keydelete(SkillId, 1, TempSkillL),
            SpellTime1 = max(200, SpellTime+100),
            % 成功释放
            case ReleaseSkill of
                #release_skill{is_ok = 0, skill_id = SkillId} -> ReleaseSkillL = [{release_skill, ReleaseSkill#release_skill{is_ok = 1}}];
                _ -> ReleaseSkillL = []
            end,
            ObaArgs = ReleaseSkillL ++ [{obj, BackObj#scene_object{temp_skill=TempSkillL1}}, {att_time, AttTime}, {selected_skill, {SkillId, []}}],
            NewState = lib_scene_object_ai:set_ac_state(ObaArgs, State),
            NewNode = lib_node_action:set_time_success(Node, NowTime, SpellTime1),
            {update, NewState, NewNode};
        _ ->
            % 失败释放就去掉
            case ReleaseSkill of
                #release_skill{is_ok = 0, skill_id = SkillId} -> ReleaseSkillL = [{release_skill, undefined}];
                _ -> ReleaseSkillL = []
            end,
            ObaArgs = ReleaseSkillL ++ [{att_time, AttTime}, {selected_skill, {SkillId, []}}],
            NewState = lib_scene_object_ai:set_ac_state(ObaArgs, State),
            {failure, NewState, StateName}
    end.




