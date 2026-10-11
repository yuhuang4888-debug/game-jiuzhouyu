%% ---------------------------------------------------------------------------
%% @doc lib_player_behavior_battle_pet

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/6/2
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_player_behavior_battle_pet).

%% API
-export([
    pet_release_a_skill/3,
    pet_object_start_battle/8,
    pet_object_combo_battle/6,
    pet_object_start_assist/6,
    pet_object_combo_assist/4,
    pet_object_battle_back/5,
    pet_combo_battle_back/5,
    pet_assist_battle_back/5,
    pet_combo_assist_battle_back/5
]).

-include("common.hrl").
-include("server.hrl").
-include("player_behavior.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("skill.hrl").
-include("battle.hrl").
-include("attr.hrl").


get_companion_skill(PS) ->
    lib_companion_util:get_active_skill(PS).


pet_release_a_skill(PS, NowTime, Att) ->
    #player_status{
        behavior_status = BehaviorStatus,
        scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId,
        x = X, y = Y, id = RoleId
    } = PS,
    #player_behavior{pet_battle = BehaviorStatusBattle} = BehaviorStatus,
    #pet_behavior_battle{
        skill_cd = SkillCd, skill_link = SkillLinkInfo,
        release_skill_map = ReleaseSkillMap,
        selected_skill = SelSkillMap
    } = BehaviorStatusBattle,
    #{id:=TId, sign:=TSign, x:=TX, y:= TY} = Att,
    ActiveSkillL = get_companion_skill(PS),
    case lib_scene_object_ai:select_a_skill(ActiveSkillL, SkillCd, [], [], 0, 0, SkillLinkInfo, 1) of
        {SkillId, SkillLv, _SkillDistance, SkillType, ReFindType, SpellTime, NSkillLinkInfo, IsNormal} when
            ?SKILL_TYPE_ACTIVE == SkillType; ?SKILL_TYPE_ASSIST == SkillType ->
            % 给他一个远一点的攻击距离
            case lib_scene_object_ai:get_next_step(X, Y, 800, SceneId, CopyId, TX, TY, true) of
                attack ->
                    GapAttTime = 100,   % 攻击间隔时间
                    % 每个技能释放间隔0.1s
                    NewNextAttTime = max(GapAttTime + NowTime, SpellTime + NowTime),
                    SelectedSkillInfo = #selected_skill{
                        att_time = NewNextAttTime,
                        skill_id = SkillId,
                        spell_time = SpellTime,
                        link_info = NSkillLinkInfo,
                        normal = IsNormal,
                        is_refind_t = ReFindType
                    },
                    ReleaseSkill = #release_skill{
                        skill_id = SkillId,
                        spell_time = SpellTime, end_time = NowTime+SpellTime
                    },
                    NReleaseSkillLMap = ReleaseSkillMap#{SkillId => ReleaseSkill},
                    %% cast到场景出释放技能
                    case SkillType of
                        ?SKILL_TYPE_ACTIVE ->
                            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, ?MODULE, pet_object_start_battle, [RoleId, TSign, TId, ReFindType, SkillId, SkillLv, IsNormal]);
                        _ ->
                            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, ?MODULE, pet_object_start_assist, [RoleId, ReFindType, SkillId, SkillLv, 0])
                    end,
                    #skill{lv_data = #skill_lv{cd = Cd}} = data_skill:get(SkillId, SkillLv),
                    NewBehaviorStatusBattle = BehaviorStatusBattle#pet_behavior_battle{
                        skill_cd = lists:keystore(SkillId, 1, SkillCd, {SkillId, NowTime + Cd}),
                        skill_link = NSkillLinkInfo,
                        release_skill_map = NReleaseSkillLMap,
                        selected_skill = SelSkillMap#{SkillId => SelectedSkillInfo},
                        next_att_time = NewNextAttTime
                    },
                    NewBehaviorStatus = BehaviorStatus#player_behavior{pet_battle = NewBehaviorStatusBattle},
                    NewPS = PS#player_status{behavior_status = NewBehaviorStatus},
                    {success, NewPS, SpellTime + 100};
                _ ->
                    failure
            end;
        _ ->
            failure
    end.


%% 玩家进程 => 场景进程 释放主动技能
pet_object_start_battle(RoleId, TSign, TId, _ReFindType, SkillId, SkillLv, _IsNormal, EtsScene) ->
    case lib_battle:pet_object_start_battle(RoleId, {target, TSign, TId}, SkillId, SkillLv, 0, EtsScene) of
        #skill_return{} = SkillReturn ->
            #ets_scene_user{pid = Pid} = lib_scene_agent:get_user(RoleId),
            lib_player_behavior:behavior_msg(Pid, {'pet_object_battle_back', SkillReturn});
        _O ->
            ok
    end.

%% 玩家进程收到技能释放信息，做后续处理
pet_object_battle_back(PS, StateName, _NowTime, _TickGap, SkillReturn) ->
    #skill_return{
        aer_info = BackUser
        % move_effect_list = MoveEffectList
    }=SkillReturn,
    SelectSkillInfo = get_select_skill_info(PS, SkillReturn),
    AfDataPs = #player_status{battle_attr = BA} = update_by_slim_back_data(PS, BackUser),
    NewBA = BA,
    AfBAPs = AfDataPs#player_status{battle_attr = NewBA},
    if
        is_record(SelectSkillInfo, selected_skill) ->
            pet_object_battle_back_do(AfBAPs, StateName, SkillReturn, SelectSkillInfo, 0);
        true ->
            {failure, AfBAPs, StateName}
    end.

%% 玩家进程 => 场景进程 主动技能连技
pet_object_combo_battle(RoleId, SkillId, SkillLv, Args, Radian, EtsScene) ->
    case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{id = Id, pid = Pid} ->
            case lib_battle:pet_object_start_battle(Id, Args, SkillId, SkillLv, Radian, EtsScene) of
                #skill_return{} = SkillReturn ->
                    lib_player_behavior:behavior_msg(Pid, {pet_combo_battle_back, SkillReturn});
                _O ->
                    ok
            end;
        _ -> skip
    end.

%% 玩家进程收到技能combo释放信息，做后续处理
pet_combo_battle_back(PS, StateName, _NowTime, _TickGap, SkillReturn) ->
    #skill_return{
        aer_info = BackUser
        % move_effect_list = MoveEffectList
    }=SkillReturn,
    SelectSkillInfo = get_select_skill_info(PS, SkillReturn),

    AfDataPs = #player_status{battle_attr = BA} = update_by_slim_back_data(PS, BackUser),
    NewBA = BA,
    AfBAPs = AfDataPs#player_status{battle_attr = NewBA},
    if
        is_record(SelectSkillInfo, selected_skill) ->
            pet_combo_battle_back_do(AfBAPs, StateName, SkillReturn, SelectSkillInfo, 0);
        true ->
            {failure, AfBAPs, StateName}
    end.

%% 玩家进程 => 场景进程 释放辅助技能
pet_object_start_assist(RoleId, _ReFindType, SkillId, SkillLv, _IsNormal, EtsScene) ->
    #ets_scene_user{pid = Pid} = User = lib_scene_agent:get_user(RoleId),
    CallBackArgs = lib_skill:make_skill_use_call_back(User, SkillId, SkillLv),
    case lib_battle:assist_to_anyone(RoleId, RoleId, 0, SkillId, SkillLv, CallBackArgs, EtsScene) of
        #skill_return{} = SkillReturn ->
            lib_player_behavior:behavior_msg(Pid, {pet_assist_battle_back, SkillReturn});
        _ ->
            ok
    end.

pet_assist_battle_back(PS, StateName, _NowTime, _TickGap, SkillReturn) ->
    #skill_return{
        aer_info = BackUser0
        % move_effect_list = MoveEffectList
    }=SkillReturn,
    BackUser = lib_battle_api:slim_back_data(BackUser0, ?BATTLE_SIGN_PLAYER),
    SelectSkillInfo = get_select_skill_info(PS, SkillReturn),
    AfDataPs = #player_status{battle_attr = BA} = update_by_slim_back_data(PS, BackUser),
    NewBA = BA,
    AfBAPs = AfDataPs#player_status{battle_attr = NewBA},
    if
        is_record(SelectSkillInfo, selected_skill) ->
            pet_object_battle_back_do(AfBAPs, StateName, SkillReturn, SelectSkillInfo, 1);
        true ->
            {failure, AfBAPs, StateName}
    end.

%% 玩家进程 => 场景进程 辅助技能连技
pet_object_combo_assist(RoleId, _AttTarget, ComboArgs, EtsScene) ->
    case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{pid = Pid} = User ->
            {_OX, _OY, _X, _Y, SkillId, SkillLv, _OReFindType, _BulletDis, _OldRadian} = ComboArgs,
            CallBackArgs = lib_skill:make_skill_use_call_back(User, SkillId, SkillLv),
            case lib_battle:assist_to_anyone(RoleId, RoleId, 1, SkillId, SkillLv, CallBackArgs, EtsScene) of
                #skill_return{} = SkillReturn ->
                    lib_player_behavior:behavior_msg(Pid, {pet_combo_assist_battle_back, SkillReturn});
                _ ->
                    ok
            end;
        _ -> skip
    end.

pet_combo_assist_battle_back(PS, StateName, _NowTime, _TickGap, SkillReturn) ->
    #skill_return{
        aer_info = BackUser
        % move_effect_list = MoveEffectList
    }=SkillReturn,
    SelectSkillInfo = get_select_skill_info(PS, SkillReturn),
    AfDataPs = #player_status{battle_attr = BA} = update_by_slim_back_data(PS, BackUser),
    NewBA = BA,
    AfBAPs = AfDataPs#player_status{battle_attr = NewBA},
    if
        is_record(SelectSkillInfo, selected_skill) ->
            pet_combo_battle_back_do(AfBAPs, StateName, SkillReturn, SelectSkillInfo, 1);
        true ->
            {failure, AfBAPs, StateName}
    end.

get_select_skill_info(#player_status{behavior_status = BehaviorStatus}, SkillReturn) ->
    case BehaviorStatus of
        #player_behavior{pet_battle = #pet_behavior_battle{selected_skill = SelectSkillMap }} ->
            case SkillReturn of
                #skill_return{used_skill = SkillId} ->
                    case maps:find(SkillId, SelectSkillMap) of
                        {ok, SelectedSkillInfo} when is_record(SelectedSkillInfo, selected_skill) ->
                            SelectedSkillInfo;
                        _ ->
                            false
                    end;
                _ ->
                    false
            end;
        _ ->
            tool:back_trace_to_file(),
            false
    end.

%% 数据回写
update_by_slim_back_data(
        #player_status{battle_attr = BA, behavior_status = BehaviorStatus} = PS,
        [Combo, Hp, HpLim, Cd, _SkillCdMap, _SkSkill, _LastSkillId, _PubSkillCd, X, Y]
) ->
    #player_behavior{pet_battle = BehaviorBattle} = BehaviorStatus,
    NewBehaviorBattle = BehaviorBattle#pet_behavior_battle{
        skill_cd = Cd, skill_combo = Combo
    },
    NewBehaviorStatus = BehaviorStatus#player_behavior{pet_battle = NewBehaviorBattle},
    PS#player_status{
        battle_attr = BA#battle_attr{hp = Hp, hp_lim = HpLim},
        x = X, y = Y, behavior_status = NewBehaviorStatus
    }.

pet_object_battle_back_do(PS, StateName, SkillReturn, SelectSkillInfo, IsAssist) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #selected_skill{
        is_refind_t = ReFindType,
        skill_id = SkillId,
        att_time = NextAttTime
    } = SelectSkillInfo,
    case SkillReturn of
        #skill_return{
            aer_info = [SkillCombo|_],
            rx = OX, ry = OY, tx = AttX, ty = AttY, radian = Radian,
            main_skill = MainSkillId,
            used_skill = SkillId
        } ->
            #player_behavior{pet_battle = BehaviorBattle} = BehaviorStatus,
            BehaviorBattle1 = BehaviorBattle#pet_behavior_battle{next_att_time = NextAttTime},
            case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
                false ->
                    % combo 释放完成了静待一开始设置的成功时间返回成功
                    BehaviorStatus1 = BehaviorStatus#player_behavior{pet_battle = BehaviorBattle1},
                    PS#player_status{behavior_status = BehaviorStatus1};
                {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} ->
                    ComboArgs = {OX, OY, AttX, AttY, NextSkillId, NextSkillLv, ReFindType, BulletDis, Radian},
                    case IsAssist of
                        0 -> lib_player_behavior:behavior_msg(NextSkillTime, self(), {'role_pet_combo', ComboArgs});
                        _ -> lib_player_behavior:behavior_msg(NextSkillTime, self(), {'role_pet_assist_combo', ComboArgs})
                    end,
                    % 成功释放
                    ReleaseSkillMap = BehaviorBattle#pet_behavior_battle.release_skill_map,
                    NewReleaseSkillMap =
                        case maps:get(MainSkillId, ReleaseSkillMap, []) of
                            [] -> ReleaseSkillMap;
                            RS -> maps:put(MainSkillId, RS#release_skill{is_ok = 1}, ReleaseSkillMap)
                        end,
                    LastBehaviorBattle = BehaviorBattle1#pet_behavior_battle{release_skill_map = NewReleaseSkillMap},
                    % 前摇技能后面释放的技能能被打断，需要保存combo的定时器
                    LastBehaviorStatus = BehaviorStatus#player_behavior{pet_battle = LastBehaviorBattle},
                    PS#player_status{behavior_status = LastBehaviorStatus}
            end;
        _ ->
            {failure, PS, StateName}
    end.

pet_combo_battle_back_do(PS, StateName, SkillReturn, SelectSkillInfo, IsAssist) ->
    #selected_skill{is_refind_t = ReFindType} = SelectSkillInfo,
    case SkillReturn of
        #skill_return{
            aer_info = [SkillCombo|_],
            rx = OX, ry = OY, tx = AttX, ty = AttY, radian = Radian,
            main_skill = MainSkillId,
            used_skill = _SkillId
        } ->
            case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
                false -> skip;
                {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} ->
                    ComboArgs = {OX, OY, AttX, AttY, NextSkillId, NextSkillLv, ReFindType, BulletDis, Radian},
                    % 前摇技能后面释放的技能能被打断，需要保存combo的定时器
                    case IsAssist of
                        0 -> lib_player_behavior:behavior_msg(NextSkillTime, self(), {'role_pet_combo', ComboArgs});
                        _ -> lib_player_behavior:behavior_msg(NextSkillTime, self(), {'role_pet_assist_combo', ComboArgs})
                    end
            end,
            PS;
        _ -> {failure, PS, StateName}
    end.

