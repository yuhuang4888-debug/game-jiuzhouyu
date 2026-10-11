%% ---------------------------------------------------------------------------
%% @doc lib_node_attack

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/5/12 0012
%% @desc    随机释放技能
%% ---------------------------------------------------------------------------
-module(lib_node_attack).

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

%%
action(State, StateName, Node, NowTime, _TickGap) when is_record(State, ob_act) ->
    #ob_act{att = Att, object = SceneObject} = State,
    case Att of
        % #{id:=Id, x:=TargetX, y:=TargetY, sign:=_Sign} ->
        %     case action_call_back(State, Node, NowTime, TickGap, {'trace_info_back', [Id, TargetX, TargetY, []]}) of
        %         {failure, NewState} -> {NewState, ?BTREEFAILURE};
        %         {update, NewState, NewNode} -> {NewState, ?BTREERUNNING, NewNode};
        %         {finish, NewState} -> {NewState, ?BTREESUCCESS}
        %     end;
        #{id:=Id, sign:=Sign} ->
            #scene_object{aid = Aid, scene = SceneId, scene_pool_id = ScenePoolId} = SceneObject,
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent,
                get_trace_info_cast, [Aid, Sign, Id, []]),
            NewNode = lib_node_action:wait_cast_back(Node, NowTime),
            {State, ?BTREERUNNING, NewNode};
        _ -> {State, StateName, ?BTREEFAILURE}
    end;
action(PS, StateName, Node, NowTime, TickGap) when is_record(PS, player_status) ->
    #player_status{ behavior_status = BehaviorStatus } = PS,
    #player_behavior{att = Att} = BehaviorStatus,
    if
        is_map(Att) ->
            case lib_player_behavior_battle:release_a_skill(PS, NowTime, TickGap, Att) of
                {success, SkillId, NewPS, SuccessMs} ->
                    LastPS = lib_fake_client_api:use_skill_succ(NewPS, SkillId),
                    NewNode = lib_node_action:set_time_success(Node, NowTime, SuccessMs),
                    {LastPS, ?BTREERUNNING, NewNode};
                {re_action, WaitMs, NewPS} ->
                    NewNode = lib_node_action:set_time_re_action(Node, NowTime, WaitMs),
                    {NewPS, ?BTREERUNNING, NewNode};
                {re_action, WaitMs} ->
                    NewNode = lib_node_action:set_time_re_action(Node, NowTime, WaitMs),
                    {PS, ?BTREERUNNING, NewNode};
                _ ->
                    FailPS = lib_player_behavior_battle:remove_battle_att(PS),
                    {FailPS, StateName, ?BTREEFAILURE}
            end;
        true ->
            FailPS = lib_player_behavior_battle:remove_battle_att(PS),
            {FailPS, StateName, ?BTREEFAILURE}
    end.
%% 该方法模仿怪物进程一样cast到场景寻找信息寻找，现在使用玩家进程接受协议解包存在自身进程，不跨进程处理
% action(State, Node, _NowTime, _TickGap) when is_record(State, player_status) ->
%     #player_status{
%         btree_status = #player_btree_status{att = Att}, pid = Pid, scene = SceneId,
%         scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y
%     } = State,
%     case Att of
%         #{id:=Id, sign:=Sign} ->
%             mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, role_get_trace_info_cast, [Pid, Sign, Id, []]),
%             {State, ?BTREERUNNING, Node};
%         _ ->
%             WarningRange = 800,
%             Args = lib_scene_calc:make_scene_calc_args(State),
%             mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_scene_calc, role_get_any_for_trace_cast,
%                 [Pid, CopyId, X, Y, WarningRange, Args, undefined]),
%             {State, ?BTREERUNNING, Node}
%     end.

re_action(State, StateName, Node, Now, TickGap) ->
    action(State, StateName, Node, Now, TickGap).

action_call_back(State, StateName, _Node, _NowTime, _TickGap, {'trace_info_back', false})  when is_record(State, ob_act) ->
    {failure, State#ob_act{att = undefined}, StateName};
action_call_back(#ob_act{att = #{id := TId}} = State, StateName, _Node, _NowTime, _TickGap, {'trace_info_back', [TargetId|_]}) when TId =/= TargetId ->
    {failure, State#ob_act{att = undefined}, StateName};
action_call_back(State, StateName, Node0, NowTime, TickGap, {'trace_info_back', [TargetId, TargetX, TargetY, []|_]
    = _TargetInfo})  when is_record(State, ob_act) ->
    Node = lib_node_action:cast_back_success(Node0),
    #ob_act{
        object = SceneObject, att = Att, skill_link_info=SkillLinkInfo,
        next_att_time = NextAttTime, check_block = CheckBlock
    } = State,
    #scene_object{
        sign = ObjectSign, id = ObjectId, aid = Aid,
        scene = SceneId, scene_pool_id = ScenePoolId, x = X, y = Y, copy_id = CopyId,
        battle_attr = BA, att_time = GapAttTime,
        skill = SkillL, temp_skill = TempSkillL, skill_cd = SkillCd, pub_skill_cd_cfg = PubSkillCdCfg, pub_skill_cd = PubSkillCd,
        last_skill_id = LastSkillId, striking_distance = StrikingDistance, att_type = AttType
    } = SceneObject,
    #{sign := TargetSign} = Att,
    NewAtt = Att#{x=>TargetX, y=>TargetY},
    SelectSkillL = TempSkillL++SkillL,
    % 无需跟lib_scene_object_ai 一样判断正在释放的技能
    case lib_scene_object_ai:select_a_skill(SelectSkillL, SkillCd, PubSkillCdCfg, PubSkillCd, LastSkillId, StrikingDistance, SkillLinkInfo, AttType) of
        {false, NextSelectTime} ->
            NewNode = lib_node_action:set_time_re_action(Node, NowTime, NextSelectTime),
            {update, State#ob_act{att = NewAtt}, NewNode};
        {SkillId, SkillLv, _, ?SKILL_TYPE_ASSIST, IsReFindT, SpellTime, _, _} ->
            SelectedSkillInfo
                = #selected_skill{
                att_time = NowTime+GapAttTime,
                skill_id = SkillId,
                spell_time = SpellTime,
                is_refind_t = IsReFindT
            },
            ReleaseSkillInfo = #release_skill{skill_id = SkillId, spell_time = SpellTime, end_time = NowTime+SpellTime},
            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, object_assist_cast, [Aid, ObjectId, SkillId, SkillLv]),
            NewState = lib_scene_object_ai:set_ac_state([{selected_skill, {SkillId, SelectedSkillInfo}}, {release_skill, ReleaseSkillInfo}], State#ob_act{att = NewAtt}),
            NewNode = lib_node_action:set_time_success(Node, NowTime, SpellTime),
            {update, NewState, NewNode};
        %% 主动技能
        {SkillId, SkillLv, SkillDistance0, ?SKILL_TYPE_ACTIVE, IsReFindT, SpellTime, SkillLinkInfo1, IsNormal} ->
            %% 判断是否可以攻击
            SkillDistance = ?IF(ObjectSign == ?BATTLE_SIGN_DUMMY, min(SkillDistance0, 125), SkillDistance0),
            case lib_scene_object_ai:get_next_step(X, Y, SkillDistance, SceneId, CopyId, TargetX, TargetY, CheckBlock) of
                attack when NowTime > NextAttTime ->
                    case lib_skill_buff:is_can_attack(BA#battle_attr.other_buff_list, IsNormal, NowTime) of
                        {false, _K, _AttWaitMs} ->
                            {failure, State#ob_act{att = undefined}, StateName};
                        true ->
                            SelectedSkillInfo
                                = #selected_skill{
                                att_time = max(NowTime+GapAttTime, NowTime+SpellTime),
                                skill_id = SkillId,
                                spell_time = SpellTime,
                                is_refind_t = IsReFindT,
                                link_info = SkillLinkInfo1,
                                normal = IsNormal
                            },
                            ReleaseSkillInfo = #release_skill{skill_id = SkillId, spell_time = SpellTime, end_time = NowTime+SpellTime},
                            BattleArgs = {target, TargetSign, TargetId},
                            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, object_battle_cast, [Aid, ObjectSign, ObjectId, BattleArgs, SkillId, SkillLv, 0]),
                            NewState = lib_scene_object_ai:set_ac_state([{selected_skill, {SkillId, SelectedSkillInfo}}, {release_skill, ReleaseSkillInfo}], State#ob_act{att = NewAtt}),
                            NewNode = lib_node_action:set_time_success(Node, NowTime, SpellTime),
                            {update, NewState, NewNode}
                    end;

                %% 没有到出手时间
                attack ->
                    NewNode = lib_node_action:set_time_re_action(Node, NowTime, NextAttTime-NowTime),
                    {update, State#ob_act{att = NewAtt}, NewNode};

                %% 移动
                {NextX, NextY} ->
                    #battle_attr{speed = Speed} = BA,
                    IsContinueTrace = lib_node_check:is_continue_trace(TargetX, TargetY, SceneObject),
                    % IsContinueTrace = true,
                    case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
                        _ when not IsContinueTrace ->
                            {failure, State#ob_act{att = undefined}, StateName};
                        {false, MoveWaitMs} ->
                            NewNode = lib_node_action:set_time_re_action(Node, NowTime, MoveWaitMs),
                            {update, State#ob_act{att = NewAtt}, NewNode};
                        false -> %% 本身速度为0：一般为策划填错配置，本身可反击或主动，但是移动速度为0
                            {failure, State#ob_act{att = undefined}, StateName};
                        true ->
                            case lib_scene_object_ai:move(NextX, NextY, SceneObject, round(Speed / TickGap * 1000), false) of
                                block ->
                                    {failure, State#ob_act{att = undefined}, StateName};
                                {true, NewObj, Time} ->
                                    NewNode = lib_node_action:set_time_re_action(Node, NowTime, Time),
                                    ObaArgs = [{obj, NewObj}, {move_begin_time, NowTime}, {each_move_time, Time}, {o_point, {X, Y}}, {back_dest_path, null}],
                                    NewState = lib_scene_object_ai:set_ac_state(ObaArgs, State#ob_act{att = NewAtt}),
                                    {update, NewState, NewNode}
                            end
                    end
            end;
        _R ->
            {failure, State#ob_act{att = NewAtt}, StateName}
    end;
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
    end;

action_call_back(PS, StateName, _Node, NowTime, TickGap, {'object_battle_back', SkillReturn}) when is_record(PS, player_status) ->
    lib_player_behavior_battle:object_battle_back(PS, StateName, NowTime, TickGap, SkillReturn);

action_call_back(PS, StateName, _Node, _NowTime, _TickGap, {'role_combo', ComboArgs}) when is_record(PS, player_status) ->
    #player_status{
        scene = SceneId, scene_pool_id = PoolId, id = RoleId,
        behavior_status = BehaviorStatus, x = XNow, y = YNow
    } = PS,
    #player_behavior{att = AttTarget, battle = BehaviorBattle} = BehaviorStatus,
    #player_behavior_battle{selected_skill = SelectSkillMap} = BehaviorBattle,
    %% 需要把 select_skill存进去SelectSkillMap
    {_OX, _OY, _X, _Y, SkillId, SkillLv, _OldReFindT, _OldRadian, _TrackTarget} = ComboArgs,
    case lib_battle:combo_active_battle_set_args_radian(AttTarget, XNow, YNow, ComboArgs) of
        {_SkillR, Args, Radian} ->
            SelectedSkillInfo = #selected_skill{skill_id = SkillId},
            NewSelectSkillMap = SelectSkillMap#{SkillId => SelectedSkillInfo},
            NewBehaviorBattle = BehaviorBattle #player_behavior_battle{selected_skill = NewSelectSkillMap},
            NewBehaviorStatus = BehaviorStatus#player_behavior{battle = NewBehaviorBattle},
            mod_scene_agent:apply_cast_with_state(SceneId, PoolId, lib_player_behavior_battle, object_combo_battle, [RoleId, SkillId, SkillLv, Args, Radian]),
            PS#player_status{behavior_status = NewBehaviorStatus};
        _ ->
            {failure, PS, StateName}
    end;

action_call_back(PS, StateName, _Node, NowTime, TickGap, {'combo_battle_back', SkillReturn}) when is_record(PS, player_status) ->
    lib_player_behavior_battle:combo_battle_back(PS, StateName, NowTime, TickGap, SkillReturn);

action_call_back(PS, StateName, _Node, NowTime, TickGap, {'assist_battle_back', SkillReturn}) when is_record(PS, player_status) ->
    lib_player_behavior_battle:assist_battle_back(PS, StateName, NowTime, TickGap, SkillReturn);

action_call_back(PS, _StateName, _Node, _NowTime, _TickGap, {'role_assist_combo', ComboArgs}) when is_record(PS, player_status) ->
    #player_status{scene = SceneId, scene_pool_id = PoolId, id = RoleId, behavior_status = #player_behavior{att = AttTarget}} = PS,
    mod_scene_agent:apply_cast_with_state(SceneId, PoolId, lib_player_behavior_battle, object_combo_assist, [RoleId, AttTarget, ComboArgs]),
    PS;

action_call_back(PS, StateName, _Node, NowTime, TickGap, {'combo_assist_battle_back', SkillReturn}) when is_record(PS, player_status) ->
    lib_player_behavior_battle:combo_assist_battle_back(PS, StateName, NowTime, TickGap, SkillReturn);
action_call_back(_, _, _, _, _, _) ->
    skip.

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



