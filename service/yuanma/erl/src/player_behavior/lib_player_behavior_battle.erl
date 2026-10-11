%% ---------------------------------------------------------------------------
%% @doc lib_player_behavior_battle

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/11/5 0005
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_player_behavior_battle).

%% API in PS
-export([
    get_battle_att/1,
    remove_battle_att/1,
    release_a_skill/4,
    object_battle_back/5,
    combo_battle_back/5,
    assist_battle_back/5,
    combo_assist_battle_back/5,
    end_transf_god/1
]).

%% API in Scene
-export([
    object_start_battle/8, object_combo_battle/6,
    object_start_assist/6, object_combo_assist/4
]).

-include("common.hrl").
-include("server.hrl").
-include("player_behavior.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("skill.hrl").
-include("battle.hrl").
-include("attr.hrl").
-include("game.hrl").
-include("god.hrl").

%% 获取攻击目标
get_battle_att(PS) ->
    #player_status{behavior_status = BehaviorStatus, x = X, y = Y} = PS,
    #player_behavior{att = Att, warning_range = WarningRange} = BehaviorStatus,
    {UserMap, ObjectMap} = lib_player_behavior:get_battle_obj_map(PS),
    NeedFindTar =
        case Att of
            #{id:=TargetId, sign:=TargetSign} ->
                Map = ?IF(TargetSign == ?BATTLE_SIGN_PLAYER, UserMap, ObjectMap),
                case maps:get(TargetId, Map, false) of
                    #scene_object{x = TargetX, y = TargetY} ->
                        umath:distance_pow({X, Y}, {TargetX, TargetY}) > WarningRange * WarningRange;
                    #ets_scene_user{x = TargetX, y = TargetY} ->
                        umath:distance_pow({X, Y}, {TargetX, TargetY}) > WarningRange * WarningRange;
                    _ ->
                        true
                end;
            _ -> true
        end,
    get_battle_att_core(PS, UserMap, ObjectMap, NeedFindTar).

get_battle_att_core(#player_status{behavior_status = BehaviorStatus} = PS, UserMap, ObjectMap, false) ->
    #player_behavior{att = Att} = BehaviorStatus,
    NewAtt =
        case Att of
            #{id:=TargetId, sign:=?BATTLE_SIGN_PLAYER} -> maps:get(TargetId, UserMap, false);
            #{id:=TargetId} -> maps:get(TargetId, ObjectMap, false);
            _ -> false
        end,
    ?IF(is_map(NewAtt), NewAtt, get_battle_att_core(PS, UserMap, ObjectMap, true));
get_battle_att_core(PS, UserMap, ObjectMap, true) ->
    #player_status{x = X, y = Y, scene = _SceneId} = PS,
    Args = lib_scene_calc:make_scene_calc_args(PS),
    %% TODO 后续看需求修改，暂时先优先攻击怪物
    MonList = [Mon||Mon<-maps:values(ObjectMap), not lib_mon_util:is_collect_mon(Mon#scene_object.mon)],
    case lib_scene_calc:get_object_for_battle(MonList, X, Y, Args, {closest, X, Y}) of
        #scene_object{id = Id, x = TX, y = TY, sign = Sign} ->
            #{id=>Id, x=>TX, y=>TY, sign=>Sign};
        _ ->
            case lib_scene_calc:get_object_for_battle(maps:values(UserMap), X, Y, Args, {closest, X, Y}) of
                #ets_scene_user{id = Id, x = TX, y = TY} ->
                    #{id=>Id, x=>TX, y=>TY, sign=>?BATTLE_SIGN_PLAYER};
                _ ->
                    false
            end
    end.

remove_battle_att(PS) ->
    #player_status{ behavior_status = BehaviorStatus } = PS,
    NewBehaviorStatus = BehaviorStatus#player_behavior{att = undefined},
    PS#player_status{ behavior_status = NewBehaviorStatus }.

%% 释放技能
release_a_skill(PS, NowTime, TickGap, Att) ->
    %GodPS = try_to_transf_god(PS, NowTime),
    GodPS = PS,
    #player_status{
        behavior_status = BehaviorStatus,
        %skill = #status_skill{can_active_skill = ActiveSkillL},
        scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId,
        x = X, y = Y, battle_attr = BA, id = RoleId
    } = GodPS,
    #player_behavior{battle = BehaviorStatusBattle} = BehaviorStatus,
    #player_behavior_battle{
        skill_cd = SkillCd, last_skill_id = LastSkillId, skill_link = SkillLinkInfo,
        release_skill_map = ReleaseSkillMap,
        selected_skill = SelSkillMap
    } = BehaviorStatusBattle,
    #{id:=TId, sign:=TSign, x:=TX, y:= TY} = Att,
    ActiveSkillL = get_active_skill(GodPS, BehaviorStatusBattle),
    case lib_scene_object_ai:role_select_a_skill(ActiveSkillL, SkillCd, [], [], LastSkillId, 0, SkillLinkInfo) of
        {SkillId, SkillLv, SkillDistance, SkillType, ReFindType, SpellTime, NSkillLinkInfo, IsNormal} when
            ?SKILL_TYPE_ACTIVE == SkillType; ?SKILL_TYPE_ASSIST == SkillType ->
            case lib_scene_object_ai:get_next_step(X, Y, SkillDistance, SceneId, CopyId, TX, TY, true) of
                attack ->
                    case lib_skill_buff:is_can_attack(BA#battle_attr.other_buff_list, IsNormal, NowTime) of
                        {false, _K, _AttWaitMs} ->
                            failure;
                        true ->
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
                                    mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, ?MODULE, object_start_battle, [RoleId, TSign, TId, ReFindType, SkillId, SkillLv, IsNormal]);
                                _ ->
                                    mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, ?MODULE, object_start_assist, [RoleId, ReFindType, SkillId, SkillLv, 0])
                            end,
                            #skill{lv_data = #skill_lv{cd = Cd}} = data_skill:get(SkillId, SkillLv),
                            NewBehaviorStatusBattle = BehaviorStatusBattle#player_behavior_battle{
                                skill_cd = lists:keystore(SkillId, 1, SkillCd, {SkillId, NowTime + Cd}),
                                skill_link = NSkillLinkInfo,
                                release_skill_map = NReleaseSkillLMap,
                                selected_skill = SelSkillMap#{SkillId => SelectedSkillInfo},
                                next_att_time = NewNextAttTime
                            },
                            NewBehaviorStatus = BehaviorStatus#player_behavior{battle = NewBehaviorStatusBattle},
                            NewPS = GodPS#player_status{behavior_status = NewBehaviorStatus},
                            {success, SkillId, NewPS, SpellTime + 100}
                    end;
                %% 移动
                {NextX, NextY} ->
                    #battle_attr{speed = Speed} = BA,
                    case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
                        {false, MoveWaitMs} when is_integer(MoveWaitMs) ->
                            {re_action, MoveWaitMs};
                        {false, _} ->
                            failure;
                        true ->
                            mod_scene_agent:cast_to_scene(SceneId, ScenePoolId, {'move', [CopyId, NextX, NextY, 0, X, Y, NextX, NextY, 0, 0, RoleId]}),
                            Dis = umath:distance({X, Y}, {NextX, NextY}),
                            MoveWaitMs = case Dis == 0 of
                                true  -> TickGap;
                                false -> round(Dis * 1000 / max(1,Speed))
                            end,
                            {re_action, MoveWaitMs, GodPS#player_status{x = NextX, y = NextY}}
                    end;
                _ ->
                    failure
            end;
        {false, NextSkillTime} ->
            {re_action, NextSkillTime};
        _ ->
            failure
    end.

%% 玩家进程 => 场景进程 释放主动技能
object_start_battle(RoleId, TSign, TId, _ReFindType, SkillId, SkillLv, _IsNormal, EtsScene) ->
    case lib_battle:object_start_battle(?BATTLE_SIGN_PLAYER, RoleId, {target, TSign, TId}, SkillId, SkillLv, 0, EtsScene) of
        #skill_return{} = SkillReturn ->
            #ets_scene_user{pid = Pid} = lib_scene_agent:get_user(RoleId),
            lib_player_behavior:behavior_msg(Pid, {'object_battle_back', SkillReturn});
        _O ->
            ok
    end.

%% 玩家进程收到技能释放信息，做后续处理
object_battle_back(PS, StateName, _NowTime, _TickGap, SkillReturn) ->
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
            object_battle_back_do(AfBAPs, StateName, SkillReturn, SelectSkillInfo, 0);
        true ->
            {failure, AfBAPs, StateName}
    end.

%% 玩家进程 => 场景进程 主动技能连技
object_combo_battle(RoleId, SkillId, SkillLv, Args, Radian, EtsScene) ->
    case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{id = Id, pid = Pid} ->
            case lib_battle:object_start_battle(?BATTLE_SIGN_PLAYER, Id, Args, SkillId, SkillLv, Radian, EtsScene) of
                #skill_return{} = SkillReturn ->
                    lib_player_behavior:behavior_msg(Pid, {combo_battle_back, SkillReturn});
                _O ->
                    ok
            end;
        _ -> skip
    end.

%% 玩家进程收到技能combo释放信息，做后续处理
combo_battle_back(PS, StateName, _NowTime, _TickGap, SkillReturn) ->
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
            combo_battle_back_do(AfBAPs, StateName, SkillReturn, SelectSkillInfo, 0);
        true ->
            {failure, AfBAPs, StateName}
    end.

%% 玩家进程 => 场景进程 释放辅助技能
object_start_assist(RoleId, _ReFindType, SkillId, SkillLv, _IsNormal, EtsScene) ->
    #ets_scene_user{pid = Pid} = User = lib_scene_agent:get_user(RoleId),
    CallBackArgs = lib_skill:make_skill_use_call_back(User, SkillId, SkillLv),
    case lib_battle:assist_to_anyone(RoleId, RoleId, 0, SkillId, SkillLv, CallBackArgs, EtsScene) of
        #skill_return{} = SkillReturn ->
            lib_player_behavior:behavior_msg(Pid, {assist_battle_back, SkillReturn});
        _ ->
            ok
    end.

assist_battle_back(PS, StateName, _NowTime, _TickGap, SkillReturn) ->
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
            object_battle_back_do(AfBAPs, StateName, SkillReturn, SelectSkillInfo, 1);
        true ->
            {failure, AfBAPs, StateName}
    end.

%% 玩家进程 => 场景进程 辅助技能连技
object_combo_assist(RoleId, _AttTarget, ComboArgs, EtsScene) ->
    case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{pid = Pid} = User ->
            {_OX, _OY, _X, _Y, SkillId, SkillLv, _OReFindType, _BulletDis, _OldRadian} = ComboArgs,
            CallBackArgs = lib_skill:make_skill_use_call_back(User, SkillId, SkillLv),
            case lib_battle:assist_to_anyone(RoleId, RoleId, 1, SkillId, SkillLv, CallBackArgs, EtsScene) of
                #skill_return{} = SkillReturn ->
                    lib_player_behavior:behavior_msg(Pid, {combo_assist_battle_back, SkillReturn});
                _ ->
                    ok
            end;
        _ -> skip
    end.

combo_assist_battle_back(PS, StateName, _NowTime, _TickGap, SkillReturn) ->
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
            combo_battle_back_do(AfBAPs, StateName, SkillReturn, SelectSkillInfo, 1);
        true ->
            {failure, AfBAPs, StateName}
    end.

%% 将神结束变身
end_transf_god(PS) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{battle = BehaviorStatusBattle} = BehaviorStatus,
    #player_behavior_battle{god_status = BehaviorGodStatus} = BehaviorStatusBattle,
    util:cancel_timer(BehaviorGodStatus#behavior_battle_god.god_ref),
    NewPS = lib_god_summon:do_switch_god(PS),
    pp_god:handle(44010, NewPS, []),
    #player_status{god = #status_god{summon = #god_summon{start_time = NextTime}}} = NewPS,
    NewBehaviorGodStatus = BehaviorGodStatus#behavior_battle_god{is_god = 0, next_time = NextTime},
    NewBehaviorStatusBattle = BehaviorStatusBattle#player_behavior_battle{god_status = NewBehaviorGodStatus},
    NewBehaviorStatus = BehaviorStatus#player_behavior{battle = NewBehaviorStatusBattle},
    NewPS#player_status{behavior_status = NewBehaviorStatus}.

%% ===================================== Inner Fun =====================================
%% 尝试变身将神
try_to_transf_god(PS, NowTime) ->
    #player_status{behavior_status = BehaviorStatus, god = GodStatus} = PS,
    #player_behavior{battle = BehaviorStatusBattle} = BehaviorStatus,
    #player_behavior_battle{god_status = BehaviorGodStatus} = BehaviorStatusBattle,
    case BehaviorGodStatus of
        #behavior_battle_god{is_god = 0, is_auto = 1, god_ref = Ref, next_time = NextTime} when NowTime > NextTime ->
            util:cancel_timer(Ref),
            #player_status{god = StatusGod} = PS,
            case lib_god_summon:check_switch_god(PS, StatusGod, [is_enter, is_cd, is_ban_status, is_last_seq, scnen_type]) of
                true ->
                    case lib_god_summon:switch_god(PS) of
                        {false, _E} ->
                            BehaviorGod = BehaviorGodStatus#behavior_battle_god{is_auto = 0, god_ref = undefined},
                            NewBehaviorStatusBattle = BehaviorStatusBattle#player_behavior_battle{god_status = BehaviorGod},
                            NewBehaviorStatus = BehaviorStatus#player_behavior{battle = NewBehaviorStatusBattle},
                            PS#player_status{behavior_status = NewBehaviorStatus};
                        NewPS ->
                            pp_god:handle(44010, NewPS, []),
                            NexTimeSec = lib_god_summon:get_summon_time(GodStatus),
                            NewRef = erlang:send_after(NexTimeSec * 1000 + 200, self(), {mod, ?MODULE, end_transf_god, []}),
                            BehaviorGod = #behavior_battle_god{is_auto = 1, is_god = 1, god_ref = NewRef},
                            NewBehaviorStatusBattle = BehaviorStatusBattle#player_behavior_battle{god_status = BehaviorGod},
                            NewBehaviorStatus = BehaviorStatus#player_behavior{battle = NewBehaviorStatusBattle},
                            NewPS#player_status{behavior_status = NewBehaviorStatus}
                    end;
                _ -> PS
            end;
        _ -> PS
    end.


get_select_skill_info(#player_status{behavior_status = BehaviorStatus}, SkillReturn) ->
    case BehaviorStatus of
        #player_behavior{battle = #player_behavior_battle{selected_skill = SelectSkillMap }} ->
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

object_battle_back_do(PS, StateName, SkillReturn, SelectSkillInfo, IsAssist) ->
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
            #player_behavior{battle = BehaviorBattle} = BehaviorStatus,
            BehaviorBattle1 = BehaviorBattle#player_behavior_battle{next_att_time = NextAttTime},
            case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
                false ->
                    % combo 释放完成了静待一开始设置的成功时间返回成功
                    BehaviorStatus1 = BehaviorStatus#player_behavior{battle = BehaviorBattle1},
                    PS#player_status{behavior_status = BehaviorStatus1};
                {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} ->
                    ComboArgs = {OX, OY, AttX, AttY, NextSkillId, NextSkillLv, ReFindType, BulletDis, Radian},
                    case IsAssist of
                        0 -> lib_player_behavior:behavior_msg(NextSkillTime, self(), {'role_combo', ComboArgs});
                        _ -> lib_player_behavior:behavior_msg(NextSkillTime, self(), {'role_assist_combo', ComboArgs})
                    end,
                    % 成功释放
                    ReleaseSkillMap = BehaviorBattle#player_behavior_battle.release_skill_map,
                    NewReleaseSkillMap =
                        case maps:get(MainSkillId, ReleaseSkillMap, []) of
                            [] -> ReleaseSkillMap;
                            RS -> maps:put(MainSkillId, RS#release_skill{is_ok = 1}, ReleaseSkillMap)
                        end,
                    LastBehaviorBattle = BehaviorBattle1#player_behavior_battle{release_skill_map = NewReleaseSkillMap},
                    % 前摇技能后面释放的技能能被打断，需要保存combo的定时器
                    LastBehaviorStatus = BehaviorStatus#player_behavior{battle = LastBehaviorBattle},
                    PS#player_status{behavior_status = LastBehaviorStatus}
            end;
        _ ->
            {failure, PS, StateName}
    end.

combo_battle_back_do(PS, StateName, SkillReturn, SelectSkillInfo, IsAssist) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #selected_skill{is_refind_t = ReFindType} = SelectSkillInfo,
    case SkillReturn of
        #skill_return{
            aer_info = [SkillCombo|_],
            rx = OX, ry = OY, tx = AttX, ty = AttY, radian = Radian,
            main_skill = MainSkillId,
            used_skill = _SkillId
        } ->
            #player_behavior{battle = BehaviorBattle} = BehaviorStatus,
            case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
                false ->
                    % combo 释放完成了静待一开始设置的成功时间返回成功
                    BehaviorStatus1 = BehaviorStatus#player_behavior{battle = BehaviorBattle},
                    PS#player_status{behavior_status = BehaviorStatus1};
                {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} ->
                    ComboArgs = {OX, OY, AttX, AttY, NextSkillId, NextSkillLv, ReFindType, BulletDis, Radian},
                    % 前摇技能后面释放的技能能被打断，需要保存combo的定时器
                    case IsAssist of
                        0 -> lib_player_behavior:behavior_msg(NextSkillTime, self(), {'role_combo', ComboArgs});
                        _ -> lib_player_behavior:behavior_msg(NextSkillTime, self(), {'role_assist_combo', ComboArgs})
                    end,
                    % 前摇技能后面释放的技能能被打断，需要保存combo的定时器
                    LastBehaviorBattle = BehaviorBattle,
                    LastBehaviorStatus = BehaviorStatus#player_behavior{battle = LastBehaviorBattle},
                    PS#player_status{behavior_status = LastBehaviorStatus}
            end;
        _ -> {failure, PS, StateName}
    end.

%% 数据回写
update_by_slim_back_data(
        #player_status{battle_attr = BA, behavior_status = BehaviorStatus} = PS,
        [Combo, Hp, HpLim, Cd, _SkillCdMap, _SkSkill, LastSkillId, _PubSkillCd, X, Y]
    ) ->
    #player_behavior{battle = BehaviorBattle} = BehaviorStatus,
    NewBehaviorBattle = BehaviorBattle#player_behavior_battle{
        skill_cd = Cd, last_skill_id = LastSkillId, skill_combo = Combo
    },
    NewBehaviorStatus = BehaviorStatus#player_behavior{battle = NewBehaviorBattle},
    PS#player_status{
        battle_attr = BA#battle_attr{hp = Hp, hp_lim = HpLim},
        x = X, y = Y, behavior_status = NewBehaviorStatus
    }.

get_active_skill(PS, _BehaviorStatusBattle) ->
    #player_status{god = StatusGod} = PS,
    #status_god{summon = #god_summon{god_id = GodId, initiative_skill = ISkill}} = StatusGod,
    %CompanionSkill = lib_companion_util:get_active_skill(PS),
    case GodId of
        0 -> lib_skill:make_scene_quickbar(PS);
        _ -> ISkill
    end.
    %CompanionSkill = lib_companion_util:get_active_skill(PS),
    %case BehaviorStatusBattle of
    %    #player_behavior_battle{god_status = #behavior_battle_god{is_god = 1}} ->
    %        #player_status{god = StatusGod} = PS,
    %        case StatusGod of
    %            #status_god{summon = #god_summon{initiative_skill = SkillL}} -> ok;
    %            _ -> SkillL = []
    %        end;
    %    _ -> SkillL = []
    %end,
    %case SkillL of
    %    [] -> CompanionSkill ++ lib_skill:make_scene_quickbar(PS);
    %    _ -> CompanionSkill ++ SkillL
    %end.

