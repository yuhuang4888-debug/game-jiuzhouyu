%% ---------------------------------------------------------
%% Author:  xyao
%% Email:   jiexiaowen@gmail.com
%% Created: 2012-4-26
%% Description: 战斗,已经进入场景进程，不能使用call
%% --------------------------------------------------------
-module(lib_battle).
-export([
        start_battle/2, assist_to_anyone/7,
        object_start_battle/7, object_assist/4, assist_anything/7,
        battle_fail/3, battle_fail/4,
        obj_select_att_num_der/3,
        send_to_scene/5, send_to_scene_area/7, %% send_to_scene_area/7,
        timer_call_back/5, add_resume_timer/6, add_resume_timer/7, remove_resume_timer/1, begin_resume_timer/6,
        collect_mon/5, pick_mon/2, talk_to_mon/3,
        check_pk_and_safe/4,
        rpc_cast_to_node/4,
        do_partner_personlity/4,
        object_assist_cast/5,
        combo_assist_cast/5,
        object_battle_cast/8,
        combo_battle_cast/8,
        pet_object_start_battle/6,
        break_steath_force/3,
        interrupt_collect/2
        , rob_mon_bl/3
        , rob_mon_bl_battle/4
        , handle_hp_af_rob_mon_bl/6
        , skill_career_to_att_type/1
        , calc_real_sign/1
        , update_last_normal_skill/3
        , send_energy_info/1
        , interrupt_collect_force/1
        , send_collectors_of_mon/3
        , select_mon_list/2
        , calc_hurt_for_buff/5
        , send_hp_change_to_12036/6
        , combo_active_battle_set_args_radian/4
        ]).

-include("scene.hrl").
-include("skill.hrl").
-include("battle.hrl").
-include("attr.hrl").
-include("server.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("team.hrl").
-include("mount.hrl").
-include("def_fun.hrl").

%% 开始战斗(带客户端攻击对象)--场景进程中
start_battle(#battle_args{skill_id=SkillId, skill_lv=SkillLv, att_key=AttKey, mon_list=MonList, player_list=PlayerList, now_time=NowTime}=BattleArgs, EtsScene) ->
    case lib_battle_util:check_start_battle(AttKey, MonList, PlayerList, SkillId) of
        {true, AttUser, DerList, NotExistList} ->
            case NotExistList of
                [] -> skip;
                _  -> battle_fail(41, AttUser, #battle_status{}, NotExistList)
            end,
            case mod_battle:battle(BattleArgs#battle_args{att_user=AttUser, mon_list=[], player_list=[], der_list=DerList}, EtsScene) of
                {false, ErrCode, _Aer} ->
                    ?PRINT("SkillId:~p ErrCode:~p ~n", [SkillId, ErrCode]),
                    battle_fail(ErrCode, AttUser, #battle_status{});
                {true, Aer, _} ->
                    % ?PRINT("SkillId:~p ErrCode:~p ~n", [SkillId, ok]),
                    AerAfSkill = lib_battle_event:handle_af_use_skill_success(Aer, SkillId, SkillLv, BattleArgs#battle_args.skill_call_back),
                    #ets_scene_user{id = AerId, battle_attr = BA} = AerAfSkill,
                    % 反弹会导致攻击者掉血，重新计算一下回血
                    HpResumeRef = lib_battle:begin_resume_timer(AerAfSkill#ets_scene_user.hp_resume_ref, ?BATTLE_SIGN_PLAYER, AerId, BA, NowTime, 
                        BA#battle_attr.hp_resume_time*1000),
                    lib_scene_agent:put_user(AerAfSkill#ets_scene_user{hp_resume_ref=HpResumeRef}),
                    %% TODO 更新游戏节点信息
                    %% lib_player:update_player_info(Aer#ets_scene_user.id, [{skill_cd, Aer#ets_scene_user.skill_cd}]),
                    ok
            end;
        {false, AttUser} ->
            ?PRINT("SkillId:~p ErrCode:~p ~n", [SkillId, 3]),
            battle_fail(3, AttUser, #battle_status{});
        false ->
            ?PRINT("SkillId:~p ErrCode:~p ~n", [SkillId, skip]),
            skip
    end.

%% 开始战斗(带客户端攻击对象)--场景进程中
assist_to_anyone(AerKey, DerKey, IsCombo, SkillId, SkillLv, CallBackArgs, EtsScene) ->
    AerO = case lib_scene_agent:get_user(AerKey) of
               [] -> battle_fail(3, #battle_status{}, #battle_status{}), [];
               TmpAer -> TmpAer
           end,
    DerO = case lib_scene_agent:get_user(DerKey) of
               [] -> battle_fail(1, AerO, #battle_status{}), [];
               TmpDer -> TmpDer
           end,
    case [] == AerO orelse [] == DerO of
        true  -> {false, 0};
        false ->
            case mod_battle:assist(AerO, DerO, IsCombo, SkillId, SkillLv, EtsScene) of
                {false, ErrCode, _Aer} ->
                    battle_fail(ErrCode, AerO, #battle_status{}),
                    {false, ErrCode};
                {true, Aer, MainSkillId} ->
                    AerAfSkill = lib_battle_event:handle_af_use_skill_success(Aer, SkillId, SkillLv, CallBackArgs),
                    lib_scene_agent:put_user(AerAfSkill),
                    %% 处理某些特殊技能使用成功后的后续逻辑
                    #skill_return{aer_info = Aer, used_skill = SkillId, main_skill = MainSkillId}
                    % {true, Aer, MainSkillId}
            end
    end.

object_battle_cast(From, Sign, ObjectId, DerInfo, SkillId, SkillLv, OldRadian, EtsScene) ->
    From ! {'object_battle_back', object_start_battle(Sign, ObjectId, DerInfo, SkillId, SkillLv, OldRadian, EtsScene)}.

combo_battle_cast(From, Sign, ObjectId, DerInfo, SkillId, SkillLv, OldRadian, EtsScene) ->
    From ! {'combo_battle_back', object_start_battle(Sign, ObjectId, DerInfo, SkillId, SkillLv, OldRadian, EtsScene)}.

%% 场景对象使用主动技能
object_start_battle(Sign, ObjectId, DerInfo, SkillId, SkillLv, OldRadian, EtsScene) ->
    case data_skill:get(SkillId, SkillLv) of
        [] -> {false, 0};
        #skill{is_combo = IsCombo, refind_target = IsReFindT, mod = Mod, obj = AttObj, %% att_obj = AttObj,
                is_normal = IsNormal, combo = Combo, range = Range, lv_data=#skill_lv{distance = ThisSkillDis, area = Area}} ->
            %% 攻击者
            Object = case Sign of
                ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(ObjectId);
                _ -> lib_scene_object_agent:get_object(ObjectId)
            end,
            case Object of
                [] -> {false, 0};
                #scene_object{battle_attr = #battle_attr{hp = Hp}} when Hp=<0 -> {false, 0};
                #ets_scene_user{battle_attr = #battle_attr{hp = Hp}} when Hp=<0 -> {false, 0};
                _  ->
                    case Object of
                        #scene_object{sign=Sign, x=Xnow, y=Ynow, copy_id=CopyId, battle_attr=BA, skill_owner=SkillOwner, mon = Mon} -> ok;
                        #ets_scene_user{x=Xnow, y=Ynow, copy_id=CopyId, battle_attr=BA} -> Sign=?BATTLE_SIGN_PLAYER, SkillOwner=undefined, Mon = []
                    end,
                    case Mon of
                        #scene_mon{kind = MonKind} -> ok;
                        _ -> MonKind = 0
                    end,
                    {OwnerId, OwnerSign} = lib_scene_object_ai:get_skill_owner_args(SkillOwner),

                    {OX, OY, TX, TY, OneObjectL, Distance} = case DerInfo of
                        {target, ?BATTLE_SIGN_PLAYER, TId} ->
                            case lib_scene_agent:get_user(TId) of
                                #ets_scene_user{x=Xtmp, y=Ytmp} = User ->
                                    {Xnow, Ynow, Xtmp, Ytmp, [User], ThisSkillDis};
                                _ ->
                                    {Xnow, Ynow, Xnow, Ynow, [], ThisSkillDis}
                            end;

                        {target, _, TId} ->
                            case lib_scene_object_agent:get_object(TId) of
                                #scene_object{x=Xtmp, y=Ytmp} = BeAttObj ->
                                    {Xnow, Ynow, Xtmp, Ytmp, [BeAttObj], ThisSkillDis};
                                 _ ->
                                    {Xnow, Ynow, Xnow, Ynow, [], ThisSkillDis}
                            end;

                        {xy, Xrefer, Yrefer, Xatt, Yatt} ->
                            {Xrefer, Yrefer, Xatt, Yatt, [], ThisSkillDis};

                        {xy, Xrefer, Yrefer, Xatt, Yatt, BulletDis} -> %% {xy, 主技能参考点x, 主技能参考点y, 攻击点x, 攻击点y, 攻击弧度}
                            {Xrefer, Yrefer, Xatt, Yatt, [], BulletDis};

                        find_target -> %% 查找必须为自己为中心的椭圆
                            {Xnow, Ynow, Xnow+100, Ynow+100, [], ThisSkillDis}
                    end,

                    %% atan2算出来的是弧度
                    IsReCalcRadian = IsCombo == 0 orelse OldRadian == 0 orelse IsReFindT == 1,
                    Radian = ?IF(IsReCalcRadian, math:atan2(TY-OY, TX-OX), OldRadian),
                    Degree = umath:radian_to_360degree(Radian),
                    %?PRINT(Sign == ?BATTLE_SIGN_PLAYER, "BattleSign ~p ~n", [BattleSign]),
                    BattleArgs = #battle_args{att_key = ObjectId, att_user = Object, skill_id = SkillId,
                        skill_lv = SkillLv, now_time = utime:longunixtime(), att_angle = Degree, is_combo = IsCombo},

                    LastBattleArgs = if
                        IsCombo == 1 andalso Sign == ?BATTLE_SIGN_PLAYER ->
                            RX = OX, RY = OY,
                            SFun = fun({DerSign, DerId}, TL) ->
                                DerObject = case DerSign of
                                    ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(DerId);
                                    _ -> lib_scene_object_agent:get_object(DerId)
                                end,
                                case DerObject of
                                    [] -> TL;
                                    _ -> [DerObject|TL]
                                end
                            end,
                            NObjects = lists:foldl(SFun, [], Object#ets_scene_user.skill_combo_ders),
                            BattleArgs#battle_args{der_list = NObjects, att_x=OX, att_y=OY};
                        true ->
                            Args = #scene_calc_args{
                                group = BA#battle_attr.group, sign = Sign, id = ObjectId, owner_sign = OwnerSign, owner_id = OwnerId, kind = MonKind,
                                guild_id = lib_scene_object_ai:get_guild_id(Object),
                                pk_status = lib_scene_object_ai:get_pk_status(Object)
                                },
                            case Mod of
                                ?SKILL_MOD_SINGLE -> %% 单体攻击
                                    RX = OX, RY=OY,
                                    BattleArgs#battle_args{der_list=OneObjectL, att_x=TX, att_y=TY};
                                _ when Range==?SKILL_RANGE_CIRCLE -> %% 圆形 AttObj:攻击参照对象1:自己; 2:选取的目标
                                    RX = case AttObj of ?SKILL_OBJ_ME -> OX; _ -> TX end,
                                    RY = case AttObj of ?SKILL_OBJ_ME -> OY; _ -> TY end,
                                    Objects = lib_scene_calc:get_ellipse_object_for_battle(CopyId, RX, RY, Area, Args, EtsScene),
                                    CombObjects = combine_der_list(OneObjectL, Objects),
                                    NObjects = obj_select_att_num_der(CombObjects, SkillId, SkillLv),
                                    BattleArgs#battle_args{der_list = NObjects, att_x = RX, att_y = RY};

                                _ when Range==?SKILL_RANGE_LINE -> %% 矩形
                                    Objects = lib_scene_calc:get_rectangle_object_for_battle(CopyId, Distance, Area, OX, OY, Radian, Args, EtsScene),
                                    RX = OX, RY = OY,
                                    CombObjects = combine_der_list(OneObjectL, Objects),
                                    NObjects = obj_select_att_num_der(CombObjects, SkillId, SkillLv),
                                    BattleArgs#battle_args{der_list= NObjects, att_x=OX, att_y=OY};

                                _ when Range==?SKILL_RANGE_CROSS -> %% 十字形
                                    Objects = lib_scene_calc:get_cross_object_for_battle(CopyId, Distance, Area, OX, OY, Radian, Args, EtsScene),
                                    % ?MYLOG("hjh", "Objects:~p Radian:~p Degree:~p ~n", [length(Objects), Radian, Degree]),
                                    RX = OX, RY = OY,
                                    CombObjects = combine_der_list(OneObjectL, Objects),
                                    NObjects = obj_select_att_num_der(CombObjects, SkillId, SkillLv),
                                    BattleArgs#battle_args{der_list= NObjects, att_x=OX, att_y=OY};

                                _  -> %% 扇形
                                    Objects = lib_scene_calc:get_sector_object_for_battle(CopyId, OX, OY, TX, TY, Distance, Area, Args, EtsScene),
                                    RX = OX, RY = OY,
                                    CombObjects = combine_der_list(OneObjectL, Objects),
                                    NObjects = obj_select_att_num_der(CombObjects, SkillId, SkillLv),
                                    BattleArgs#battle_args{der_list=NObjects, att_x=RX, att_y=RY}
                            end
                    end,
                    % case Sign of
                    %     ?BATTLE_SIGN_PLAYER ->
                    %         ?IF(ObjectId == 4294967312, begin
                    %             MonitorF = fun(K) -> is_record(K, ets_scene_user) end,
                    %             {NPlayerList, NMonList} = lists:partition(MonitorF, LastBattleArgs#battle_args.der_list),
                    %             lib_player:gm_trigger_monitor(battlelen, {SkillId, length(NMonList), length(NPlayerList)})
                    %             end,
                    %             skip);
                    %     _ -> skip
                    % end,
                    case mod_battle:battle(LastBattleArgs, EtsScene) of
                        % _ when LastBattleArgs#battle_args.der_list == [] ->
                        %     {false, 0};
                        {false, ErrCode, _Aer} ->
                            {false, ErrCode};
                        {true, Aer, MainSkillId} ->
                            case Sign of
                                ?BATTLE_SIGN_PLAYER ->
                                    if
                                        % 1、非普通技能或者是普通技能但是有副技能列表
                                        % 2、不是副技能
                                        (IsNormal == 0 orelse (IsNormal == 1 andalso Combo =/= [])) andalso IsCombo == 0 ->
                                            Fun = fun(X, TL) ->
                                                case X of
                                                    #ets_scene_user{id = RId} -> [{?BATTLE_SIGN_PLAYER, RId}|TL];
                                                    #scene_object{id = ObjId} -> [{?BATTLE_SIGN_MON, ObjId}|TL];
                                                    _ -> TL
                                                end
                                            end,
                                            ComboDers = lists:foldl(Fun, [], LastBattleArgs#battle_args.der_list),
                                            NewAer = Aer#ets_scene_user{skill_combo_ders = ComboDers},
                                            lib_scene_agent:put_user(NewAer),
                                            #skill_return{
                                                aer_info = lib_battle_api:slim_back_data(NewAer, Sign),
                                                rx = RX, ry = RY, tx = TX, ty = TY, radian = Radian,
                                                used_skill = SkillId,
                                                main_skill = MainSkillId
                                            };
                                        true ->
                                            lib_scene_agent:put_user(Aer),
                                            #skill_return{
                                                aer_info = lib_battle_api:slim_back_data(Aer, Sign),
                                                rx = RX, ry = RY, tx = TX, ty = TY, radian = Radian,
                                                used_skill = SkillId,
                                                main_skill = MainSkillId
                                            }
                                    end;
                                _ ->
                                    lib_scene_object_agent:put_object(Aer),
                                    #skill_return{
                                        aer_info = lib_battle_api:slim_back_data(Aer, Sign),
                                        rx = RX, ry = RY, tx = TX, ty = TY, radian = Radian,
                                        used_skill = SkillId,
                                        main_skill = MainSkillId
                                    }
                            end

                    end
            end
    end.

%% 把 ObjectsA 合到 ObjectsB, 不存在就不合
combine_der_list(ObjectsA, ObjectsB) ->
    F = fun(Object, {AddObjects, TmpObjects}) ->
        case lists:member(Object, ObjectsB) of
            true -> {[Object|AddObjects], TmpObjects--[Object]};
            false -> {AddObjects, TmpObjects}
        end
    end,
    {AddObjects, NewObjectsB} = lists:foldl(F, {[], ObjectsB}, ObjectsA),
    lists:reverse(AddObjects) ++ NewObjectsB.

object_assist_cast(From, ObjectId, SkillId, SkillLv, EtsScene) ->
    From ! {'object_assist_back', object_assist(ObjectId, SkillId, SkillLv, EtsScene)}.

combo_assist_cast(From, ObjectId, SkillId, SkillLv, EtsScene) ->
    From ! {'combo_assist_back', object_assist(ObjectId, SkillId, SkillLv, EtsScene)}.

%% 场景对象释放辅助技能
object_assist(ObjectId, SkillId, SkillLv, EtsScene) ->
    case data_skill:get(SkillId, SkillLv) of
        [] -> {false, 0};
        #skill{is_combo=IsCombo} ->
            case lib_scene_object_agent:get_object(ObjectId) of
                [] -> {false, 0};
                #scene_object{sign = Sign} = Object ->
                    case mod_battle:assist(Object, Object, IsCombo, SkillId, SkillLv, EtsScene) of
                        {false, ErrCode, _Assister} ->
                            {false, ErrCode};
                        {true, Assister, MainSkillId} ->
                            lib_scene_object_agent:put_object(Assister),
                            #skill_return{
                                aer_info = lib_battle_api:slim_back_data(Assister, Sign),
                                % rx = RX, ry = RY, tx = TX, ty = TY, radian = Radian,
                                used_skill = SkillId,
                                main_skill = MainSkillId
                            }
                            % {true, lib_battle_api:slim_back_data(Assister), MainSkillId, SkillId}
                    end
            end
    end.

%% 释放辅助技能(不能包括副技能)
assist_anything(SignA, IdA, SignT, IdT, SkillId, SkillLv, EtsScene) ->
    case data_skill:get(SkillId, SkillLv) of
        #skill{is_combo=IsCombo} ->
            AObject = case SignA of
                          ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(IdA);
                          _ -> lib_scene_object_agent:get_object(IdA)
                      end,
            TObject = case SignT of
                          ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(IdT);
                          _ -> lib_scene_object_agent:get_object(IdT)
                      end,
            case [] =/= AObject andalso [] =/= TObject of
                true ->
                    case mod_battle:assist(AObject, TObject, IsCombo, SkillId, SkillLv, EtsScene) of
                        {false, _ErrCode, _Assister} -> false;
                        {true, _, _} -> true
                    end;
                false -> false
            end;
        _ -> false
    end.

pet_object_start_battle(RoleId, DerInfo, SkillId, SkillLv, OldRadian, EtsScene) ->
    case data_skill:get(SkillId, SkillLv) of
        [] -> {false, 0};
        #skill{is_combo = IsCombo, refind_target = IsReFindT, mod = Mod, obj = AttObj,
            is_normal = IsNormal, combo = Combo, range = Range, lv_data=#skill_lv{distance = ThisSkillDis, area = Area}
        } ->
            User = lib_scene_agent:get_user(RoleId),
            case User of
                [] -> {false, 0};
                #ets_scene_user{battle_attr = #battle_attr{hp = Hp}} when Hp=<0 -> {false, 0};
                _  ->
                    #ets_scene_user{x=Xnow, y=Ynow, copy_id=CopyId, battle_attr=BA} = User,
                    {OX, OY, TX, TY, OneObjectL, Distance} =
                        case DerInfo of
                            {target, ?BATTLE_SIGN_PLAYER, TId} ->
                                case lib_scene_agent:get_user(TId) of
                                    #ets_scene_user{x=Xtmp, y=Ytmp} = User -> {Xnow, Ynow, Xtmp, Ytmp, [User], ThisSkillDis};
                                    _ -> {Xnow, Ynow, Xnow, Ynow, [], ThisSkillDis}
                                end;
                            {target, _, TId} ->
                                case lib_scene_object_agent:get_object(TId) of
                                    #scene_object{x=Xtmp, y=Ytmp} = BeAttObj -> {Xnow, Ynow, Xtmp, Ytmp, [BeAttObj], ThisSkillDis};
                                    _ -> {Xnow, Ynow, Xnow, Ynow, [], ThisSkillDis}
                                end;
                            {xy, Xrefer, Yrefer, Xatt, Yatt} -> {Xrefer, Yrefer, Xatt, Yatt, [], ThisSkillDis};
                            {xy, Xrefer, Yrefer, Xatt, Yatt, BulletDis} ->  {Xrefer, Yrefer, Xatt, Yatt, [], BulletDis};
                            find_target ->  {Xnow, Ynow, Xnow+100, Ynow+100, [], ThisSkillDis}
                        end,
                    %% atan2算出来的是弧度
                    IsReCalcRadian = IsCombo == 0 orelse OldRadian == 0 orelse IsReFindT == 1,
                    Radian = ?IF(IsReCalcRadian, math:atan2(TY-OY, TX-OX), OldRadian),
                    Degree = umath:radian_to_360degree(Radian),
                    BattleArgs = #battle_args{
                        att_key = RoleId, att_user = User, skill_id = SkillId, sign = ?BATTLE_SIGN_COMPANION,
                        skill_lv = SkillLv, now_time = utime:longunixtime(), att_angle = Degree, is_combo = IsCombo
                    },
                    LastBattleArgs =
                        if
                            IsCombo == 1 ->
                                RX = OX, RY = OY,
                                SFun = fun({DerSign, DerId}, TL) ->
                                    DerObject = ?IF(DerSign == ?BATTLE_SIGN_PLAYER, lib_scene_agent:get_user(DerId), lib_scene_object_agent:get_object(DerId)),
                                    case DerObject of
                                        [] -> TL;
                                        _ -> [DerObject|TL]
                                    end
                                end,
                                NObjects = lists:foldl(SFun, [], User#ets_scene_user.skill_combo_ders),
                                BattleArgs#battle_args{der_list = NObjects, att_x=OX, att_y=OY};
                            true ->
                                Args = #scene_calc_args{
                                    group = BA#battle_attr.group, sign = ?BATTLE_SIGN_PLAYER, id = User,
                                    guild_id = lib_scene_object_ai:get_guild_id(User),
                                    pk_status = lib_scene_object_ai:get_pk_status(User)
                                },
                                case Mod of
                                    ?SKILL_MOD_SINGLE -> %% 单体攻击
                                        RX = OX, RY=OY,
                                        BattleArgs#battle_args{der_list=OneObjectL, att_x=TX, att_y=TY};
                                    _ when Range==?SKILL_RANGE_CIRCLE -> %% 圆形 AttObj:攻击参照对象1:自己; 2:选取的目标
                                        RX = case AttObj of ?SKILL_OBJ_ME -> OX; _ -> TX end,
                                        RY = case AttObj of ?SKILL_OBJ_ME -> OY; _ -> TY end,
                                        Objects = lib_scene_calc:get_ellipse_object_for_battle(CopyId, RX, RY, Area, Args, EtsScene),
                                        CombObjects = combine_der_list(OneObjectL, Objects),
                                        NObjects = obj_select_att_num_der(CombObjects, SkillId, SkillLv),
                                        BattleArgs#battle_args{der_list = NObjects, att_x = RX, att_y = RY};
                                    _ when Range==?SKILL_RANGE_LINE -> %% 矩形
                                        Objects = lib_scene_calc:get_rectangle_object_for_battle(CopyId, Distance, Area, OX, OY, Radian, Args, EtsScene),
                                        RX = OX, RY = OY,
                                        CombObjects = combine_der_list(OneObjectL, Objects),
                                        NObjects = obj_select_att_num_der(CombObjects, SkillId, SkillLv),
                                        BattleArgs#battle_args{der_list= NObjects, att_x=OX, att_y=OY};
                                    _ when Range==?SKILL_RANGE_CROSS -> %% 十字形
                                        Objects = lib_scene_calc:get_cross_object_for_battle(CopyId, Distance, Area, OX, OY, Radian, Args, EtsScene),
                                        RX = OX, RY = OY,
                                        CombObjects = combine_der_list(OneObjectL, Objects),
                                        NObjects = obj_select_att_num_der(CombObjects, SkillId, SkillLv),
                                        BattleArgs#battle_args{der_list= NObjects, att_x=OX, att_y=OY};
                                    _  -> %% 扇形
                                        Objects = lib_scene_calc:get_sector_object_for_battle(CopyId, OX, OY, TX, TY, Distance, Area, Args, EtsScene),
                                        RX = OX, RY = OY,
                                        CombObjects = combine_der_list(OneObjectL, Objects),
                                        NObjects = obj_select_att_num_der(CombObjects, SkillId, SkillLv),
                                        BattleArgs#battle_args{der_list=NObjects, att_x=RX, att_y=RY}
                                end
                        end,
                    case mod_battle:battle(LastBattleArgs, EtsScene) of
                        {false, ErrCode, _Aer} ->
                            {false, ErrCode};
                        {true, Aer, MainSkillId} ->
                            if
                                (IsNormal == 0 orelse (IsNormal == 1 andalso Combo =/= [])) andalso IsCombo == 0 ->
                                    Fun = fun(X, TL) ->
                                        case X of
                                            #ets_scene_user{id = RId} -> [{?BATTLE_SIGN_PLAYER, RId}|TL];
                                            #scene_object{id = ObjId} -> [{?BATTLE_SIGN_MON, ObjId}|TL];
                                            _ -> TL
                                        end
                                     end,
                                    ComboDers = lists:foldl(Fun, [], LastBattleArgs#battle_args.der_list),
                                    NewAer = Aer#ets_scene_user{skill_combo_ders = ComboDers},
                                    lib_scene_agent:put_user(NewAer),
                                    #skill_return{
                                        aer_info = lib_battle_api:slim_back_data(NewAer, ?BATTLE_SIGN_PLAYER),
                                        rx = RX, ry = RY, tx = TX, ty = TY, radian = Radian,
                                        used_skill = SkillId,
                                        main_skill = MainSkillId
                                    };
                                true ->
                                    lib_scene_agent:put_user(Aer),
                                    #skill_return{
                                        aer_info = lib_battle_api:slim_back_data(Aer, ?BATTLE_SIGN_PLAYER),
                                        rx = RX, ry = RY, tx = TX, ty = TY, radian = Radian,
                                        used_skill = SkillId,
                                        main_skill = MainSkillId
                                    }
                            end
                    end
            end
    end.

%% 采集怪物
%% MyKey:玩家id
%% SrcId:怪物自动id
%% MonCfgId:怪物配置id
%% Type:1开始采集 2结束采集 3中断采集
collect_mon(PlayerId, MonId, MonCfgId, Type, _ExtrArgs) ->
    User = lib_scene_agent:get_user(PlayerId),
    if
        not is_record(User, ets_scene_user) -> skip;
        true ->
            SceneObject = lib_scene_object_agent:get_object(MonId),
            if
                not is_record(SceneObject, scene_object) ->
                    Res = ?COLLECT_RES_FAILURE;
                SceneObject#scene_object.sign =/= ?BATTLE_SIGN_MON ->
                    Res = ?COLLECT_RES_FAILURE;
                true ->
                    #scene_object{mon = Mon} = SceneObject,
                    #scene_mon{kind = Kind} = Mon,
                    case lib_mon_util:is_collect_mon(Kind) of
                        true ->
                            Res = handle_collect_mon(User, SceneObject, MonCfgId, Type, _ExtrArgs);
                        _ ->
                            Res = ?COLLECT_RES_FAILURE
                    end
            end,
            {ok, BinData} = pt_200:write(20008, Res),
            rpc_cast_to_node(User#ets_scene_user.node, lib_server_send, send_to_uid, [PlayerId, BinData])
    end.

handle_collect_mon(User, SceneObject, Mid, Type, _ExtrArgs) when Type == ?COLLECT_STATR ->
    #scene_object{
        config_id = _CfgMonId,
        mon = Mon
    } = SceneObject,
    #scene_mon{next_collect_time = NextCollectTime} = Mon,
    % 幻兽之域boss
    % ClEudemons = lib_eudemons_land:check_eudemons_boss_cl(User, CfgMonId),
    %% 沧海遗珠
    % ClTreasureChest = lib_treasure_chest:check_collect(User, SceneObject, Type),
    %% 采集次数
    case SceneObject#scene_object.mon#scene_mon.has_cltimes of
        0 ->
            HasCollectTimeCode = ?COLLECT_RES_HAD_FINISHED; %% 已经被采集完
        {false, Code} ->
            HasCollectTimeCode = Code;
        _ ->
            HasCollectTimeCode = true
    end,
    NowTime = utime:unixtime(),
    CommonCheck = handle_collect_mon_check(User, SceneObject, Mid),
    if
        % 未到可被采集时间
        NowTime < NextCollectTime ->
            ?COLLECT_RES_IN_CD;
        HasCollectTimeCode =/= true ->
            HasCollectTimeCode;
        CommonCheck =/= true ->
            CommonCheck;
        % ClEudemons =/= true -> ClEudemons; %% 开始采集
        % ClTreasureChest =/= true -> ClTreasureChest;
        true ->
            case User#ets_scene_user.collect_pid of
                {OldObjectAid, OMid} when OldObjectAid =/= 0 orelse OMid =/= 0 -> %% 已经在采集其他的采集物了
                    case NowTime > User#ets_scene_user.collect_etime + 3 of
                        true -> %% 如果当前时间大于上次采集结束时间(5s后), 上次的采集视为失效, 允许进行新的采集
                            Res = ?COLLECT_RES_START_SUCCESS,
                            %% 如果原有的采集还有效的话, 通知之前的采集物玩家取消的采集
                            mod_mon_active:collect_mon(OldObjectAid, User, ?COLLECT_CANCEL);
                        _ -> Res = ?COLLECT_RES_DURATION
                    end;
                _ -> Res = ?COLLECT_RES_START_SUCCESS
            end,
            case Res of
                ?COLLECT_RES_START_SUCCESS ->
                    #ets_scene_user{figure = Figure, scene = SceneId, copy_id = CopyId, x = X, y = Y, id = RoleId} = User,
                    NewUser = User#ets_scene_user{
                        collect_pid={SceneObject#scene_object.aid, SceneObject#scene_object.mon#scene_mon.mid},
                        collect_etime = NowTime + Mon#scene_mon.collect_time,
                        figure = Figure#figure{is_collecting = 1}
                    },
                    lib_scene_user:broadcast_user_collect(SceneId, CopyId, X, Y, RoleId, 1),
                    lib_scene_agent:put_user(NewUser),
                    mod_mon_active:collect_mon(SceneObject#scene_object.aid, NewUser, Type);
                _ -> skip
            end,
            Res
    end;
handle_collect_mon(User, SceneObject, Mid, Type, _ExtrArgs) when Type == ?COLLECT_FINISH ->
    CommonCheck = handle_collect_mon_check(User, SceneObject, Mid),
    if
        CommonCheck =/= true ->
            CommonCheck;
        true ->
            NowTime = utime:unixtime(),
            case User#ets_scene_user.collect_pid of
                {OldObjectAid, OMid} when OldObjectAid =:= SceneObject#scene_object.aid, OMid =:= SceneObject#scene_object.mon#scene_mon.mid -> %% 玩家采集的是当前这个采集物
                    case NowTime >= User#ets_scene_user.collect_etime of
                        true ->
                            case NowTime =< User#ets_scene_user.collect_etime + 3 of
                                true -> %% 增加3s的误差时间, 玩家大于采集需要的时间为有效
                                    Res = ?COLLECT_RES_SUCCESS;
                                _ ->
                                    mod_mon_active:collect_mon(OldObjectAid, User, ?COLLECT_CANCEL),
                                    Res = ?COLLECT_RES_FAILURE
                            end;
                        _ -> Res = ?COLLECT_RES_TIME_ERR
                    end;
                _ -> Res = ?COLLECT_RES_FAILURE
            end,
            case Res of
                ?COLLECT_RES_SUCCESS ->
                    #ets_scene_user{figure = Figure, scene = SceneId, copy_id = CopyId, x = X, y = Y, id = RoleId} = User,
                    NewUser = User#ets_scene_user{collect_pid = {0, 0}, collect_etime = 0, figure = Figure#figure{is_collecting = 0}},
                    lib_scene_agent:put_user(NewUser),
                    lib_scene_user:broadcast_user_collect(SceneId, CopyId, X, Y, RoleId, 0),
                    mod_mon_active:collect_mon(SceneObject#scene_object.aid, NewUser, Type);
                _ -> skip
            end,
            Res
    end;
handle_collect_mon(User, SceneObject, _Mid, Type, _ExtrArgs) when Type == ?COLLECT_CANCEL ->
    case User#ets_scene_user.collect_pid of
        {OldObjectAid, OMid} when OldObjectAid =:= SceneObject#scene_object.aid,
                                  OMid =:= SceneObject#scene_object.mon#scene_mon.mid -> %% 玩家采集的是当前这个采集物
            #ets_scene_user{figure = Figure, scene = SceneId, copy_id = CopyId, x = X, y = Y, id = RoleId} = User,
            NewUser = User#ets_scene_user{collect_pid = {0, 0}, collect_etime = 0, figure = Figure#figure{is_collecting = 0}},
            lib_scene_agent:put_user(NewUser),
            lib_scene_user:broadcast_user_collect(SceneId, CopyId, X, Y, RoleId, 0),
            mod_mon_active:collect_mon(SceneObject#scene_object.aid, NewUser, Type),
            ?COLLECT_RES_CANCEL_SUCCESS;
        _ ->
            0
    end;
handle_collect_mon(_User, _SceneObject, _Mid, _Type, _ExtrArgs) -> ?COLLECT_RES_FAILURE.

handle_collect_mon_check(User, SceneObject, Mid) ->
    #ets_scene_user{battle_attr = #battle_attr{group = UserGroup}} = User,
    #scene_object{
        scene = Scene,
        battle_attr = #battle_attr{group = ObjGroup}
    } = SceneObject,
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} ->  SceneType;
        _ -> SceneType = 0
    end,
    if
        Mid =/= SceneObject#scene_object.mon#scene_mon.mid ->
            ?COLLECT_RES_CFG_ERR;
        SceneObject#scene_object.battle_attr#battle_attr.hp =< 0 orelse
            User#ets_scene_user.battle_attr#battle_attr.hp =< 0 ->
            ?COLLECT_RES_FAILURE;
        % 已被我方占领
        ObjGroup > 0 andalso UserGroup =:= ObjGroup ->
            ?COLLECT_RES_SELF_HAD_OCCUPY;
        % 距离太远
        abs(User#ets_scene_user.x - SceneObject#scene_object.x) > ?LENGTH_UNIT*3 %% 将格子范围调小
            orelse abs(User#ets_scene_user.y - SceneObject#scene_object.y > ?WIDTH_UNIT*3
            orelse User#ets_scene_user.copy_id /= SceneObject#scene_object.copy_id) ->
            ?COLLECT_RES_DISTANCE_ERR;
        SceneObject#scene_object.figure#figure.guild_id > 0 andalso
            User#ets_scene_user.figure#figure.guild_id =/= SceneObject#scene_object.figure#figure.guild_id ->
            ?COLLECT_RES_NOT_BELONG_GUILD;
        SceneType == ?SCENE_TYPE_SEACRAFT andalso SceneObject#scene_object.camp_id /= User#ets_scene_user.camp_id ->
            ?COLLECT_RES_NOT_SAME_CAMP;
        true -> true
    end.

%% 拾取型怪物
%% UserId : 玩家id
%% MonList : [怪物自增id, ...]
pick_mon(UserId, MonList) ->
    case lib_scene_agent:get_user(UserId) of
        [] -> skip;
        User ->
            #ets_scene_user{battle_attr=BA, copy_id = UserCopyId, x = UserX, y = UserY} = User,
            F = fun(SrcId) ->
                case lib_scene_object_agent:get_object(SrcId) of
                    #scene_object{sign=?BATTLE_SIGN_MON, aid=Aid, config_id = ConfigId, mon = #scene_mon{kind = Kind} } = Object ->
                        #mon{warning_range = WarningRange} = data_mon:get(ConfigId),
                        Res = if
                                BA#battle_attr.hp =< 0 -> 2;
                                Kind =/= ?MON_KIND_PICK -> 4;
                                UserCopyId /= Object#scene_object.copy_id -> 3;
                                % abs(UserX - Object#scene_object.x) > ?LENGTH_UNIT*3
                                % orelse abs(UserY - Object#scene_object.y) > ?WIDTH_UNIT*4 -> 3;
                                true ->
                                    Distance = umath:distance({UserX, UserY}, {Object#scene_object.x, Object#scene_object.y}),
                                    if
                                        Distance > WarningRange -> 3;
                                        true ->
                                            mod_mon_active:pick_mon(Aid, User),
                                            %% do something...
                                            1
                                    end
                              end,
                        {Res, SrcId};
                    _ ->
                        {2, SrcId}
                end
            end,
            ResList = [F(Id) || Id <- MonList],
            {ok, BinData} = pt_200:write(20010, ResList),
            rpc_cast_to_node(User#ets_scene_user.node, lib_server_send, send_to_uid, [UserId, BinData])
    end,
    ok.


%% 与赏金型怪物对话
%% UserId : 玩家id
talk_to_mon(UserId, MemberIdList, MonId) ->
    case lib_scene_agent:get_user(UserId) of
        #ets_scene_user{} = User ->
            NearLeader = lib_hunting_api:is_near_leader(MemberIdList, User),
            case lib_scene_object_agent:get_object(MonId) of
                %% #scene_object{sign=?BATTLE_SIGN_MON, aid=Aid, mon=#scene_mon{kind = ?MON_KIND_PRICE} } when NearLeader==true ->
                %%     mod_mon_active:talk_to_mon(Aid, User);
                _  when NearLeader==false ->
                    lib_server_send:send_to_uid(UserId, pt_200, 20011, [5]);
                _ -> skip
            end;
        _ -> skip
    end.

send_collectors_of_mon(PlayerId, MonId, _MonCfgId) ->
    User = lib_scene_agent:get_user(PlayerId),
    SceneObject = lib_scene_object_agent:get_object(MonId),
    if
        not is_record(User, ets_scene_user) -> skip;
        not is_record(SceneObject, scene_object) -> skip;
        SceneObject#scene_object.sign =/= ?BATTLE_SIGN_MON -> skip;
        true ->
            #scene_object{mon = Mon} = SceneObject,
            #scene_mon{kind = Kind} = Mon,
            case lib_mon_util:is_collect_mon(Kind) of
                true ->
                    mod_mon_active:send_collectors_of_mon(SceneObject#scene_object.aid, User#ets_scene_user.node, PlayerId);
                _ ->
                    skip
            end
    end.

%% 战斗失败
%% ErrCode =
%%          1 对方没血 2 出手太快 3 自己没血 4 距离太远 5 技能cd未到
%%          6 技能数据有误 7 坐骑不能战斗 8 安全区不能pk 9 对方处于护送保护时间
%%          10 怒气不足，不能释放技能 11 同等级段内的不能劫镖 12 巡游中不能攻击
%%          21 晕 22 沉默 23 恐惧 24 缠绕 25 点穴 26 你处于施法状态中
%%          27 mp值不足 28 无法攻击目标 29 对方处于和平保护状态 30 连招条件不足
%%          31 该玩家处于新手保护状态 32 身上有宝石,不能攻击该怪物 33 睡眠
%%          34 不能攻击队友 35 你处于新手保护状态 36 对方处于无敌状态
%%          37 飞行器上不能战斗 38 天命技能验证失败 39 红装技能只能在1vN使用
%%          40 城战主场景只能放形象技能 41 有怪物不存在 42 特殊Buff状态异常
%%          43 能量值不足 44 处于公共cd中 45 技能正在释放中,无法再释放下一个技能
battle_fail(ErrCode, Aer, Der) ->
    battle_fail(ErrCode, Aer, Der, []).
battle_fail(ErrCode, Aer, Der, InexistenceList) ->
    ErrData = pack_error_data(Aer, Der),
    send_battle_fail(ErrCode, ErrData, InexistenceList).

%% 打包错误信息
pack_error_data(Aer, _Der) when Aer#battle_status.sign == 1 orelse is_record(Aer, scene_object) -> [];
pack_error_data(Aer, Der) ->
    AerData = if
        is_record(Aer, battle_status) andalso is_record(Aer#battle_status.battle_attr, battle_attr) ->
            {2, Aer#battle_status.id, Aer#battle_status.battle_attr#battle_attr.hp,
           Aer#battle_status.x, Aer#battle_status.y, Aer#battle_status.node};
        is_record(Aer, ets_scene_user) ->
            {2, Aer#ets_scene_user.id, Aer#ets_scene_user.battle_attr#battle_attr.hp,
            Aer#ets_scene_user.x, Aer#ets_scene_user.y, Aer#ets_scene_user.node};
        is_record(Aer, player_status) ->
            {2, Aer#player_status.id, Aer#player_status.battle_attr#battle_attr.hp,
            Aer#player_status.x, Aer#player_status.y, none};
        true ->
            {2, 0, 0, 0, 0, none}
    end,

    DerData = if
        is_record(Der, battle_status) andalso is_record(Der#battle_status.battle_attr, battle_attr) ->
            {Der#battle_status.sign, Der#battle_status.id, Der#battle_status.battle_attr#battle_attr.hp,
            Der#battle_status.x, Der#battle_status.y};
        is_record(Der, ets_scene_user) ->
            {2, Der#ets_scene_user.id, Der#ets_scene_user.battle_attr#battle_attr.hp,
            Der#ets_scene_user.x, Der#ets_scene_user.y};
        is_record(Der, scene_object) ->
            {1, Der#scene_object.id, Der#scene_object.battle_attr#battle_attr.hp,
            Der#scene_object.x, Der#scene_object.y};
        true ->
            {0, 0, 0, 0, 0}
    end,
    [AerData, DerData].

%% 发送错误信息
send_battle_fail(State, [{Sign1, PlayerId1, Hp1, X1, Y1, Node}, {Sign2, PlayerId2, Hp2, X2, Y2}], NotExistList) ->
    ?PRINT("send_battle_fail ~w~n", [State]),
    {ok, BinData} = pt_200:write(20005, [State, Sign1, PlayerId1, Hp1, X1, Y1, Sign2, PlayerId2, Hp2, X2, Y2, NotExistList]),
    rpc_cast_to_node(Node, lib_server_send, send_to_uid, [PlayerId1, BinData]);
send_battle_fail(_, _R, _) -> skip.

%% 远程过程调用函数(跨服中心服->单服跨服节点)
rpc_cast_to_node(Node, M, F, A) ->
    case Node =:= none of
        true  -> erlang:apply(M, F, A);
        false -> rpc:cast(Node, M, F, A)
    end.

%% 广播战斗信息
send_to_scene(CopyId, X, Y, Broadcast, BattleBin) ->
    case Broadcast of
        ?BROADCAST_AREA -> lib_scene_agent:send_to_local_area_scene(CopyId, X, Y, BattleBin);
        ?BROADCAST_ALL  -> lib_scene_agent:send_to_local_scene(CopyId, BattleBin)
    end.

%% 战斗协议返回
send_to_scene_area(#ets_scene_user{id=Id, node=Node, sid=Sid, copy_id=CopyId, x=X, y=Y} = User, OldX, OldY, Move, Broadcast, BattleBin, EtsScene) ->
    case Broadcast of
        ?BROADCAST_AREA when Move > 0 ->
            {ok, BinData1} = pt_120:write(12004, Id),
            {ok, BinData2} = pt_120:write(12003, User),
            lib_scene_calc:move_broadcast(CopyId, X, Y, OldX, OldY, BattleBin, BinData1, BinData2, [Node, Sid], EtsScene);
        ?BROADCAST_AREA -> lib_scene_agent:send_to_local_area_scene(CopyId, X, Y, BattleBin);
        ?BROADCAST_ALL  -> lib_scene_agent:send_to_local_scene(CopyId, BattleBin)
    end;
send_to_scene_area(#scene_object{sign=Sign, id=Id, copy_id=CopyId, x=X, y=Y} = Object, OldX, OldY, Move, Broadcast, BattleBin, EtsScene) ->
    case Broadcast of
        ?BROADCAST_AREA when Move > 0 ->
            {ok, BinData1} = pt_120:write(12006, Id),
            {ok, BinData2} = case Sign of
                                 ?BATTLE_SIGN_MON -> pt_120:write(12007, Object);
                                 ?BATTLE_SIGN_PARTNER -> pt_120:write(12013, Object);
                                 ?BATTLE_SIGN_DUMMY -> pt_120:write(12015, Object)
                             end,
            lib_scene_calc:move_broadcast(CopyId, X, Y, OldX, OldY, BattleBin, BinData1, BinData2, [], EtsScene);
        ?BROADCAST_AREA -> lib_scene_agent:send_to_local_area_scene(CopyId, X, Y, BattleBin);
        ?BROADCAST_ALL  -> lib_scene_agent:send_to_local_scene(CopyId, BattleBin)
    end;
send_to_scene_area(_, _, _, _, _, _, _) -> skip.

%% 战斗定时器处理
timer_call_back(
        #ets_scene_user{
            id = Id, node = Node, scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = X,
            y = Y, battle_attr = BA, del_hp_each_time = DelHpEachTime
        } = User, EventId, Args, EtsScene, TimeRef) ->
    case EventId of

        ?HP_RESUME -> %% 自身回血
            #battle_attr{hp=Hp, hp_lim=HpLim, hp_resume_time=HpResumeTime, hp_resume_add=HpResumeAdd, other_buff_list = OtherL} = BA,
            NowTime = utime:longunixtime(),
            SE = calc_skill_effect(OtherL, NowTime, #skill_effect{}),
            % ?MYLOG("hjh", "Id:~p un_resume:~p ~n", [Id, SE#skill_effect.un_resume]),
            if
                Hp =< 0 orelse HpResumeAdd =< 0 ->
                    lib_scene_agent:put_user(User#ets_scene_user{hp_resume_ref = undefined});
                SE#skill_effect.un_resume == 1 ->
                    util:cancel_timer(User#ets_scene_user.hp_resume_ref),
                    HpReRef = add_resume_timer(undefined, Hp, HpLim, Id, NowTime, HpResumeTime*1000),
                    NewUser = User#ets_scene_user{hp_resume_ref = HpReRef},
                    lib_scene_agent:put_user(NewUser);
                true ->
                    AddHp = round(HpLim*HpResumeAdd/?RATIO_COEFFICIENT), %% 血量上限的百分比
                    NewHp = min(Hp+AddHp, HpLim),
                    {ok, BinData} = pt_120:write(12009, [Id, NewHp, HpLim]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    rpc_cast_to_node(Node, lib_player, update_player_info, [ Id, [{hp, NewHp}] ]),
                    util:cancel_timer(User#ets_scene_user.hp_resume_ref),
                    HpReRef = add_resume_timer(undefined, NewHp, HpLim, Id, NowTime, HpResumeTime*1000),
                    NewUser = User#ets_scene_user{battle_attr=BA#battle_attr{hp = NewHp}, hp_resume_ref = HpReRef},
                    %% 回血被动技能触发(走辅助技能施放)
                    case check_have_hp_rusme_skill(NewUser, NowTime) of
                        false -> lib_scene_agent:put_user(NewUser);
                        {ok, SkillId, SkillLv} -> %% 服务端触发被动技能
                            case mod_battle:assist(NewUser, NewUser, server, SkillId, SkillLv, EtsScene) of
                                {false, _ErrCode, _Aer} -> lib_scene_agent:put_user(NewUser);
                                {true, Aer, _MainSkillId} -> lib_scene_agent:put_user(Aer)
                            end
                    end
            end;

        ?SPBUFF_RESUME -> %% buff回血:回复固定值
            {GapTime, AddHp, Count} = Args,
            #battle_attr{hp = Hp, hp_lim = HpLim, other_buff_list = OtherL} = BA,
            NowTime = utime:longunixtime(),
            SE = calc_skill_effect(OtherL, NowTime, #skill_effect{}),
            if
                Hp =< 0 orelse Count =< 0 -> skip;
                SE#skill_effect.un_resume == 1 ->
                    NewCount = Count - 1,
                    if
                        NewCount =< 0 -> skip;
                        true ->
                            lib_scene_timer:add_timer(NowTime, GapTime, ?BATTLE_SIGN_PLAYER, Id, ?SPBUFF_RESUME, {GapTime, AddHp, NewCount})
                    end,
                    skip;
                true ->
                    NewHp = min(round(Hp+AddHp), HpLim),
                    {ok, BinData} = pt_120:write(12009, [Id, NewHp, HpLim]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    rpc_cast_to_node(Node, lib_player, update_player_info, [Id, [{hp, NewHp}]]),
                    NewCount = Count - 1,
                    if
                        NewCount =< 0 -> skip;
                        true -> lib_scene_timer:add_timer(NowTime, GapTime, ?BATTLE_SIGN_PLAYER, Id,
                                                          ?SPBUFF_RESUME, {GapTime, AddHp, NewCount})
                    end,
                    NewUser = User#ets_scene_user{battle_attr = BA#battle_attr{hp = NewHp}},
                    %% 回血被动技能触发(走辅助技能施放)
                    case check_have_hp_rusme_skill(NewUser, NowTime) of
                        false -> lib_scene_agent:put_user(NewUser);
                        {ok, SkillId, SkillLv} ->
                            case mod_battle:assist(NewUser, NewUser, server, SkillId, SkillLv, EtsScene) of
                                {false, _ErrCode, _Aer} -> lib_scene_agent:put_user(NewUser);
                                {true, Aer, _MainSkillId} -> lib_scene_agent:put_user(Aer)
                            end
                    end
            end;

        ?SPEED -> %% 速度恢复
            NowTime = utime:longunixtime(),
            [Float, Int] = lib_skill_buff:calc_speed_helper(BA#battle_attr.attr_buff_list++BA#battle_attr.other_buff_list, NowTime, [1.0, 0]),
            % Speed = round(BA#battle_attr.attr#attr.speed * Float+Int),
            Speed = round(BA#battle_attr.battle_speed * Float+Int),
            {ok, BinData} = pt_120:write(12082, [?BATTLE_SIGN_PLAYER, Id, Speed]),
            send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
            lib_scene_agent:put_user(User#ets_scene_user{battle_attr=BA#battle_attr{speed=Speed}});

        ?SPBUFF_FIRING ->
            {GapTime, FireHurt, Count, {AtterId, AttSign, _AttName} = ATTer} = Args,
            #battle_attr{hp = Hp, hp_lim = HpLim, fire_ref = OFireRefs} = BA,
            if
                Hp =< 1 -> %% 死亡清理掉所有的灼烧buff
                    [util:cancel_timer(FRef) || FRef <- OFireRefs],
                    NewUser = User#ets_scene_user{battle_attr = BA#battle_attr{fire_ref = []}},
                    lib_scene_agent:put_user(NewUser);
                Count =< 0 ->
                    NewFireRefs = lists:delete(TimeRef, OFireRefs),
                    NewUser = User#ets_scene_user{battle_attr = BA#battle_attr{fire_ref = NewFireRefs}},
                    lib_scene_agent:put_user(NewUser);
                true ->
                    NowTime = utime:longunixtime(),
                    HpAfLock = mod_battle:calc_hp_lock(User, Hp-FireHurt, Hp, NowTime),
                    NewHp = max(1, HpAfLock),
                    {ok, BinData} = pt_120:write(12036, [?BATTLE_SIGN_PLAYER, Id, NewHp, HpLim, 1, FireHurt, EventId, AttSign, AtterId]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    NewFireRefs = if
                        NewHp =< 1 -> %% 玩家被烫死
                            [util:cancel_timer(FRef) || FRef <- OFireRefs],
                            [];
                        Count - 1 =< 0 ->
                            lists:delete(TimeRef, OFireRefs);
                        true ->
                            FireRef = lib_scene_timer:add_timer(NowTime, GapTime, ?BATTLE_SIGN_PLAYER, Id,
                                ?SPBUFF_FIRING, {GapTime, FireHurt, Count-1, ATTer}),
                            [FireRef|lists:delete(TimeRef, OFireRefs)]
                    end,
                    % ?MYLOG("hjhskill", "NewFireRefs:~p Args:~p~n", [NewFireRefs, Args]),
                    NewUser = User#ets_scene_user{battle_attr = BA#battle_attr{hp = NewHp, fire_ref = NewFireRefs}},
                    lib_scene_agent:put_user(NewUser),
                    if
                        NewHp > 0 ->
                            rpc_cast_to_node(Node, lib_player, update_player_info, [Id, [{hp, NewHp}]]);
                        true ->
                            Atter = case AttSign of
                                ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(AtterId);
                                _ -> lib_scene_object_agent:get_object(AtterId)
                            end,
                            case Atter of
                                [] ->
                                    ?ERR("can not find atter:~p~n", [[ATTer]]),
                                    skip;
                                _  -> send_die_msg_to_object(NewUser, Atter, NewHp, FireHurt)
                            end
                    end
            end;

        ?SPBUFF_BLEED ->
            {GapTime, Bleed, Count, {AtterId, AttSign, _AttName} = ATTer} = Args,
            #battle_attr{hp = Hp, hp_lim = HpLim, bleed_ref = OBleedRefs} = BA,
            if
                Hp =< 1 orelse Count =< 0 -> skip;
                true ->
                    NowTime = utime:longunixtime(),
                    HpAfLock = mod_battle:calc_hp_lock(User, Hp-Bleed, Hp, NowTime),
                    NewHp = round(max(1, HpAfLock)),
                    {ok, BinData} = pt_120:write(12036, [?BATTLE_SIGN_PLAYER, Id, NewHp, HpLim, 1, Bleed, EventId, AttSign, AtterId]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    NewCount = Count - 1,
                    NewBleedRefs = if
                        NewHp =< 1 ->
                            [util:cancel_timer(FRef) || FRef <- OBleedRefs],
                            [];
                        NewCount =< 0 ->
                            lists:delete(TimeRef, OBleedRefs);
                        true ->
                            BleedRef = lib_scene_timer:add_timer(NowTime, GapTime, ?BATTLE_SIGN_PLAYER, Id, ?SPBUFF_BLEED,
                                {GapTime, Bleed, NewCount, ATTer}),
                            [BleedRef|lists:delete(TimeRef, OBleedRefs)]
                    end,
                    NewUser = User#ets_scene_user{battle_attr = BA#battle_attr{hp = NewHp, bleed_ref = NewBleedRefs}},
                    lib_scene_agent:put_user(NewUser),

                    if
                        NewHp > 0->
                            rpc_cast_to_node(Node, lib_player, update_player_info, [Id, [{hp, NewHp}]]);
                        true ->
                            Atter = case AttSign of
                                        ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(AtterId);
                                        _ -> lib_scene_object_agent:get_object(AtterId)
                                    end,
                            case Atter of
                                [] ->
                                    ?ERR("can not find atter:~p~n", [[ATTer]]),
                                    skip;
                                _  -> send_die_msg_to_object(NewUser, Atter, NewHp, Bleed)
                            end
                    end
            end;

         ?SPBUFF_TALENT_BLEED ->
            {GapTime, Bleed, Count, {AtterId, AttSign, _AttName} = ATTer} = Args,
            #battle_attr{hp = Hp, hp_lim = HpLim, bleed_ref = OBleedRefs} = BA,
            if
                Hp =< 1 orelse Count =< 0 -> skip;
                true ->
                    NowTime = utime:longunixtime(),
                    HpAfLock = mod_battle:calc_hp_lock(User, Hp-Bleed, Hp, NowTime),
                    NewHp = round(max(1, HpAfLock)),
                    {ok, BinData} = pt_120:write(12036, [?BATTLE_SIGN_PLAYER, Id, NewHp, HpLim, 1, Bleed, EventId,AttSign, AtterId]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    NewCount = Count - 1,
                    NewBleedRefs = if
                        NewHp =< 1 ->
                            [util:cancel_timer(FRef) || FRef <- OBleedRefs],
                            [];
                        NewCount =< 0 ->
                            lists:delete(TimeRef, OBleedRefs);
                        true ->
                            BleedRef = lib_scene_timer:add_timer(NowTime, GapTime, ?BATTLE_SIGN_PLAYER, Id, ?SPBUFF_TALENT_BLEED,
                                {GapTime, Bleed, NewCount, ATTer}),
                            [BleedRef|lists:delete(TimeRef, OBleedRefs)]
                    end,
                    NewUser = User#ets_scene_user{battle_attr = BA#battle_attr{hp = NewHp, bleed_ref = NewBleedRefs}},
                    lib_scene_agent:put_user(NewUser),

                    if
                        NewHp > 0->
                            rpc_cast_to_node(Node, lib_player, update_player_info, [Id, [{hp, NewHp}]]);
                        true ->
                            Atter = case AttSign of
                                        ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(AtterId);
                                        _ -> lib_scene_object_agent:get_object(AtterId)
                                    end,
                            case Atter of
                                [] ->
                                    ?ERR("can not find atter:~p~n", [[ATTer]]),
                                    skip;
                                _  -> send_die_msg_to_object(NewUser, Atter, NewHp, Bleed)
                            end
                    end
            end;

        ?SPBUFF_BAN_BLEED ->
            {GapTime, Bleed, Count, {AtterId, AttSign, _AttName} = ATTer} = Args,
            #battle_attr{hp = Hp, hp_lim = HpLim, ban_bleed_list = BanBleedL} = BA,
            case lists:keyfind(TimeRef, #ban_bleed.ref, BanBleedL) of
                false -> BanBleed = false;
                BanBleed -> ok
            end,
            if
                Hp =< 0 orelse BanBleed == false ->
                    [util:cancel_timer(BleedRef) || #ban_bleed{ref = BleedRef} <- BanBleedL],
                    NewUser = User#ets_scene_user{battle_attr = BA#battle_attr{ban_bleed_list = []}},
                    lib_scene_agent:put_user(NewUser);
                Count =< 0 ->
                    NewBanBleedL = lists:keydelete(TimeRef, #ban_bleed.ref, BanBleedL),
                    NewUser = User#ets_scene_user{battle_attr = BA#battle_attr{ban_bleed_list = NewBanBleedL}},
                    lib_scene_agent:put_user(NewUser);
                true ->
                    NowTime = utime:longunixtime(),
                    % 血量限制,并且重新赋值
                    BS = lib_battle_util:init_data(User),
                    if
                        DelHpEachTime == [] -> NewBleed = Bleed;
                        true ->
                            {MaxHurt, IsDelHpEachTime} = mod_battle:calc_del_hp_each_time(BS, NowTime),
                            if
                                IsDelHpEachTime ->
                                    case DelHpEachTime of
                                        [DelHp, DelHp|_] when is_integer(DelHp)-> NewBleed = DelHp;
                                        [MinDelHp, MaxDelHp|_] when is_integer(MinDelHp), is_integer(MaxDelHp), MinDelHp > 0, MaxDelHp > 0 ->
                                            DelHp = urand:rand(MinDelHp, MaxDelHp),
                                            NewBleed = DelHp;
                                        [MinDelHpP, MaxDelHpP|_] when is_float(MinDelHpP), is_float(MaxDelHpP), MinDelHpP > 0, MaxDelHpP > 0 ->
                                            MinDelHp = round(MinDelHpP*HpLim),
                                            MaxDelHp = round(MaxDelHpP*HpLim),
                                            DelHp = urand:rand(MinDelHp, MaxDelHp),
                                            NewBleed = DelHp;
                                        _ ->
                                            NewBleed = 1
                                    end;
                                is_integer(MaxHurt) == false ->
                                    NewBleed = Bleed;
                                true ->
                                    NewBleed = min(Bleed, MaxHurt)
                            end
                    end,
                    #battle_status{per_hurt = NewPerHurt, per_hurt_time = NewPerHurtTime} = mod_battle:calc_per_hurt(BS, NewBleed, NowTime),
                    HpAfLock = mod_battle:calc_hp_lock(User, Hp-NewBleed, Hp, NowTime),
                    NewHp = round(max(1, HpAfLock)),
                    {ok, BinData} = pt_120:write(12036, [?BATTLE_SIGN_PLAYER, Id, NewHp, HpLim, 1, Bleed, EventId, AttSign, AtterId]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    NewCount = Count - 1,
                    NewBanBleedL = if
                        NewHp =< 1 ->
                            [util:cancel_timer(BleedRef) || #ban_bleed{ref = BleedRef} <- BanBleedL],
                            [];
                        NewCount =< 0 ->
                            lists:keydelete(TimeRef, #ban_bleed.ref, BanBleedL);
                        true ->
                            BleedRef = lib_scene_timer:add_timer(NowTime, GapTime, ?BATTLE_SIGN_PLAYER, Id, ?SPBUFF_BAN_BLEED,
                                {GapTime, Bleed, NewCount, ATTer}),
                            NewBanBleed = BanBleed#ban_bleed{ref = BleedRef},
                            [NewBanBleed|lists:keydelete(TimeRef, #ban_bleed.ref, BanBleedL)]
                    end,
                    NewUser = User#ets_scene_user{
                        battle_attr = BA#battle_attr{hp = NewHp, ban_bleed_list = NewBanBleedL},
                        per_hurt = NewPerHurt, per_hurt_time = NewPerHurtTime
                        },
                    lib_scene_agent:put_user(NewUser),
                    if
                        NewHp > 0 ->
                            rpc_cast_to_node(Node, lib_player, update_player_info, [Id, [{hp, NewHp}]]);
                        true ->
                            Atter = case AttSign of
                                ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(AtterId);
                                _ -> lib_scene_object_agent:get_object(AtterId)
                            end,
                            case Atter of
                                [] ->
                                    ?ERR("can not find atter:~p~n", [[ATTer]]),
                                    skip;
                                _ -> send_die_msg_to_object(NewUser, Atter, NewHp, NewBleed)
                            end
                    end
            end;

        ?SKILL_BUFF_TRIGGER_HPRESUME -> %% 被动技能回血触发
            #battle_attr{hp = Hp} = BA,
            if
                Hp > 0 ->
                    NowTime = utime:longunixtime(),
                    %% 回血被动技能触发(走辅助技能施放)
                    case check_have_hp_rusme_skill(User, NowTime) of
                        false -> skip;
                        {ok, SkillId, SkillLv} ->
                            case mod_battle:assist(User, User, server, SkillId, SkillLv, EtsScene) of
                                {false, _ErrCode, _Aer} -> skip;
                                {true, Aer, _MainSkillId} -> lib_scene_agent:put_user(Aer)
                            end
                    end;
                true ->
                    skip
            end;

        ?SPBUFF_SKILL ->
            {GapTime, Count, Int, Float, {AtterId, AttSign, _AttName} = ATTer} = Args,
            #battle_attr{skill_ref = SkillRefs} = BA,
            if
                Count =< 0 -> skip;
                true ->
                    AttObject = case AttSign of
                        ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(AtterId);
                        _ -> lib_scene_object_agent:get_object(AtterId)
                    end,
                    case AttObject of
                        #scene_object{aid = Aid} ->
                            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, object_battle_cast,
                                [Aid, AttSign, AtterId, {target, ?BATTLE_SIGN_PLAYER, Id}, Int, Float, 0]);
                        #ets_scene_user{} ->
                            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, object_start_battle,
                                [AttSign, AtterId, {target, ?BATTLE_SIGN_PLAYER, Id}, Int, Float, 0]);
                        _ ->
                            skip
                    end
            end,
            % 定时器
            NewCount = Count - 1,
            NewSkillRefs = if
                Count =< 0 andalso NewCount =< 0 ->
                    lists:delete(TimeRef, SkillRefs);
                true ->
                    % 定时器
                    NowTime = utime:longunixtime(),
                    SkillRef = lib_scene_timer:add_timer(NowTime, GapTime, ?BATTLE_SIGN_PLAYER, Id, ?SPBUFF_SKILL,
                        {GapTime, NewCount, Int, Float, ATTer}),
                    [SkillRef|lists:delete(TimeRef, SkillRefs)]
            end,
            NewUser = User#ets_scene_user{battle_attr = BA#battle_attr{skill_ref = NewSkillRefs}},
            lib_scene_agent:put_user(NewUser);

        _ ->
            skip
    end;
timer_call_back(
        #scene_object{
            sign=Sign, id=Id, scene = SceneId, scene_pool_id = ScenePoolId, copy_id=CopyId, x=X, y=Y, battle_attr=BA,
            hp_time=HpTime, aid = Pid, del_hp_each_time = DelHpEachTime
            }=Object
        , EventId, Args, EtsScene, TimeRef) ->
    case EventId of
        ?HP_RESUME -> %% 自身回血
            #battle_attr{hp=Hp, hp_lim=HpLim, hp_resume_add=HpResumeAdd, other_buff_list = OtherL} = BA,
            NowTime = utime:longunixtime(),
            SE = calc_skill_effect(OtherL, NowTime, #skill_effect{}),
            if
                Hp =< 0 orelse HpResumeAdd =< 0 ->
                    util:cancel_timer(Object#scene_object.hp_resume_ref),
                    lib_scene_object_agent:put_object(Object#scene_object{hp_resume_ref = undefined});
                SE#skill_effect.un_resume == 1 ->
                    util:cancel_timer(Object#scene_object.hp_resume_ref),
                    NewHpRef = add_resume_timer(undefined, Hp, HpLim, Sign, Id, NowTime, HpTime),
                    lib_scene_object_agent:put_object(Object#scene_object{hp_resume_ref = NewHpRef});
                true ->
                    AddHp = round(HpLim*HpResumeAdd/?RATIO_COEFFICIENT), %% 血量上限的百分比
                    NewHp = min(Hp + AddHp, HpLim),
                    {ok, BinData} = pt_120:write(12081, [Id, NewHp]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    util:cancel_timer(Object#scene_object.hp_resume_ref),
                    NewHpRef = add_resume_timer(undefined, NewHp, HpLim, Sign, Id, NowTime, HpTime),
                    lib_scene_object_agent:change_attr_by_ids([Id], [{hp, NewHp}]),
                    lib_scene_object_agent:put_object(Object#scene_object{battle_attr=BA#battle_attr{hp = NewHp}, hp_resume_ref = NewHpRef})
            end;

        ?SPEED -> %% 速度
            NowTime = utime:longunixtime(),
            [Float, Int] = lib_skill_buff:calc_speed_helper(BA#battle_attr.attr_buff_list++BA#battle_attr.other_buff_list, NowTime, [1.0, 0]),
            % Speed = round(BA#battle_attr.attr#attr.speed * Float+Int),
            Speed = case Sign == ?BATTLE_SIGN_PLAYER of
                true -> round(BA#battle_attr.battle_speed * Float+Int);
                false -> round(BA#battle_attr.attr#attr.speed * Float+Int)
            end,
            {ok, BinData} = pt_120:write(12082, [Sign, Id, Speed]),
            send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
            lib_scene_object_agent:put_object(Object#scene_object{battle_attr=BA#battle_attr{speed=Speed}});

        ?SPBUFF_RESUME -> %% 技能Buff回血
            {GapTime, AddHp, Count} = Args,
            #battle_attr{hp = Hp, hp_lim = HpLim, other_buff_list = OtherL} = BA,
            NowTime = utime:longunixtime(),
            SE = calc_skill_effect(OtherL, NowTime, #skill_effect{}),
            if
                Hp =< 0 orelse Count =< 0 -> skip;
                SE#skill_effect.un_resume == 1 ->
                    NewCount = Count-1,
                    if
                        NewCount =< 0 -> skip;
                        true ->
                            lib_scene_timer:add_timer(NowTime, GapTime, Sign, Id, ?SPBUFF_RESUME, {GapTime, AddHp, NewCount})
                    end,
                    skip;
                true ->
                    %% Value1 = lib_skill_buff:calc_hp_resume(Object, Value, NowTime),
                    NewHp = min(round(Hp + AddHp), HpLim),
                    {ok, BinData} = pt_120:write(12009, [Id, NewHp, HpLim]),
                    % {ok, BinData} = pt_120:write(12036, [Sign, Id, NewHp, HpLim, 0, AddHp, 0]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    NewCount = Count-1,
                    if
                        NewCount =< 0 -> skip;
                        true ->
                            lib_scene_timer:add_timer(NowTime, GapTime, Sign, Id, ?SPBUFF_RESUME, {GapTime, AddHp, NewCount})
                    end,
                    lib_scene_object_agent:change_attr_by_ids([Id], [{hp, NewHp}]),
                    lib_scene_object_agent:put_object(Object#scene_object{battle_attr=BA#battle_attr{hp = NewHp}})
            end;

        ?SPBUFF_FIRING -> %% 灼烧
            {GapTime, FireHurt, Count, {AtterId, AttSign, _AttName}} = Args,
            #battle_attr{hp = Hp, hp_lim = HpLim, fire_ref = OFireRefs} = BA,
            if
                Hp =< 0->
                    [util:cancel_timer(FRef) || FRef <- OFireRefs],
                    NewOj = Object#scene_object{battle_attr = BA#battle_attr{fire_ref = []}},
                    lib_scene_object_agent:put_object(NewOj);
                Count =< 0 ->
                    NewFireRefs = lists:delete(TimeRef, OFireRefs),
                    NewOj = Object#scene_object{battle_attr = BA#battle_attr{fire_ref = NewFireRefs}},
                    lib_scene_object_agent:put_object(NewOj);
                true ->
                    NowTime = utime:longunixtime(),
                    HpAfLock = mod_battle:calc_hp_lock(Object, Hp-FireHurt, Hp, NowTime),
                    NewHp = max(1, HpAfLock), %% 怪物灼烧不致死
                    {ok, BinData} = pt_120:write(12036, [Sign, Id, NewHp, HpLim, 1, FireHurt, EventId, AttSign, AtterId]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    NewFireRefs = if
                        NewHp =< 1 -> %% 玩家被烫死
                            [util:cancel_timer(FRef) || FRef <- OFireRefs],
                            [];
                        Count - 1 =< 0 ->
                            lists:delete(TimeRef, OFireRefs);
                        true ->
                            FireRef = lib_scene_timer:add_timer(NowTime, GapTime, Sign, Id, ?SPBUFF_FIRING,
                                {GapTime, FireHurt, Count-1, {AtterId, AttSign, _AttName}}),
                            [FireRef|lists:delete(TimeRef, OFireRefs)]
                    end,
                    NewOj = Object#scene_object{battle_attr = BA#battle_attr{hp = NewHp, fire_ref = NewFireRefs}},
                    lib_scene_object_agent:put_object(NewOj),
                    if
                        NewHp > 0->
                            Pid ! {debuff_hurt, EventId, FireHurt, NewHp};
                            % lib_scene_object_agent:change_attr_by_ids([Id], [{hp, NewHp}]);
                        true ->
                            Atter = case AttSign of
                                        ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(AtterId);
                                        _ -> lib_scene_object_agent:get_object(AtterId)
                                    end,
                            case Atter of
                                [] -> skip;
                                _  -> send_die_msg_to_object(NewOj, Atter, NewHp, FireHurt)
                            end
                    end
            end;

        ?SPBUFF_BLEED -> %% 流血
            {GapTime, Bleed, Count, {AtterId, AttSign, _AttName} = ATTer} = Args,
            #battle_attr{hp = Hp, hp_lim = HpLim, bleed_ref = OBleedRefs} = BA,
            if
                Hp =< 0 orelse Count =< 0 -> skip;
                true ->
                    NowTime = utime:longunixtime(),
                    HpAfLock = mod_battle:calc_hp_lock(Object, Hp-Bleed, Hp, NowTime),
                    NewHp = round(max(1, HpAfLock)), %% 怪物流血不致死
                    {ok, BinData} = pt_120:write(12036, [Sign, Id, NewHp, HpLim, 1, Bleed, EventId, AttSign, AtterId]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    NewCount = Count - 1,
                    NewBleedRefs = if
                        NewHp =< 1 ->
                            [util:cancel_timer(TmpRef) || TmpRef <- OBleedRefs],
                            [];
                        NewCount =< 0 ->
                            lists:delete(TimeRef, OBleedRefs);
                        true ->
                            BleedRef = lib_scene_timer:add_timer(NowTime, GapTime, Sign, Id, ?SPBUFF_BLEED, {GapTime, Bleed, NewCount, ATTer}),
                            [BleedRef|lists:delete(TimeRef, OBleedRefs)]
                    end,
                    NewOj = Object#scene_object{battle_attr = BA#battle_attr{hp = NewHp, bleed_ref = NewBleedRefs}},
                    lib_scene_object_agent:put_object(NewOj),
                    if
                        NewHp > 0->
                            Pid ! {debuff_hurt, EventId, Bleed, NewHp};
                            % lib_scene_object_agent:change_attr_by_ids([Id], [{hp, NewHp}]);
                        true ->
                            Atter = case AttSign of
                                        ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(AtterId);
                                        _ -> lib_scene_object_agent:get_object(AtterId)
                                    end,
                            case Atter of
                                [] -> skip;
                                _  -> send_die_msg_to_object(NewOj, Atter, NewHp, Bleed)
                            end
                    end
            end;

        ?SPBUFF_TALENT_BLEED -> %% 流血
            {GapTime, Bleed, Count, {AtterId, AttSign, _AttName} = ATTer} = Args,
            #battle_attr{hp = Hp, hp_lim = HpLim, bleed_ref = OBleedRefs} = BA,
            if
                Hp =< 0 orelse Count =< 0 -> skip;
                true ->
                    NowTime = utime:longunixtime(),
                    HpAfLock = mod_battle:calc_hp_lock(Object, Hp-Bleed, Hp, NowTime),
                    NewHp = round(max(1, HpAfLock)), %% 怪物流血不致死
                    {ok, BinData} = pt_120:write(12036, [Sign, Id, NewHp, HpLim, 1, Bleed, EventId, AttSign, AtterId]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    NewCount = Count - 1,
                    NewBleedRefs = if
                        NewHp =< 1 ->
                            [util:cancel_timer(TmpRef) || TmpRef <- OBleedRefs],
                            [];
                        NewCount =< 0 ->
                            lists:delete(TimeRef, OBleedRefs);
                        true ->
                            BleedRef = lib_scene_timer:add_timer(NowTime, GapTime, Sign, Id, ?SPBUFF_TALENT_BLEED, {GapTime, Bleed, NewCount, ATTer}),
                            [BleedRef|lists:delete(TimeRef, OBleedRefs)]
                    end,
                    NewOj = Object#scene_object{battle_attr = BA#battle_attr{hp = NewHp, bleed_ref = NewBleedRefs}},
                    lib_scene_object_agent:put_object(NewOj),
                    if
                        NewHp > 0->
                            Pid ! {debuff_hurt, EventId, Bleed, NewHp};
                            % lib_scene_object_agent:change_attr_by_ids([Id], [{hp, NewHp}]);
                        true ->
                            Atter = case AttSign of
                                        ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(AtterId);
                                        _ -> lib_scene_object_agent:get_object(AtterId)
                                    end,
                            case Atter of
                                [] -> skip;
                                _  -> send_die_msg_to_object(NewOj, Atter, NewHp, Bleed)
                            end
                    end
            end;

        ?SPBUFF_BAN_BLEED -> %% 流血
            {GapTime, Bleed, Count, {AtterId, AttSign, _AttName} = ATTer} = Args,
            #battle_attr{hp = Hp, hp_lim = HpLim, ban_bleed_list = BanBleedL} = BA,
            case lists:keyfind(TimeRef, #ban_bleed.ref, BanBleedL) of
                false -> BanBleed = false;
                BanBleed -> ok
            end,
            if
                Hp =< 0 orelse BanBleed == false ->
                    [util:cancel_timer(BleedRef) || #ban_bleed{ref = BleedRef} <- BanBleedL],
                    NewOj = Object#scene_object{battle_attr = BA#battle_attr{ban_bleed_list = []}},
                    lib_scene_object_agent:put_object(NewOj);
                Count =< 0 ->
                    NewBanBleedL = lists:keydelete(TimeRef, #ban_bleed.ref, BanBleedL),
                    NewOj = Object#scene_object{battle_attr = BA#battle_attr{ban_bleed_list = NewBanBleedL}},
                    lib_scene_object_agent:put_object(NewOj);
                true ->
                    NowTime = utime:longunixtime(),
                    % 血量限制,并且重新赋值
                    BS = lib_battle_util:init_data(Object),
                    if
                        DelHpEachTime == [] -> NewBleed = Bleed;
                        true ->
                            {MaxHurt, IsDelHpEachTime} = mod_battle:calc_del_hp_each_time(BS, NowTime),
                            if
                                IsDelHpEachTime ->
                                    case DelHpEachTime of
                                        [DelHp, DelHp|_] when is_integer(DelHp)-> NewBleed = DelHp;
                                        [MinDelHp, MaxDelHp|_] when is_integer(MinDelHp), is_integer(MaxDelHp), MinDelHp > 0, MaxDelHp > 0 ->
                                            DelHp = urand:rand(MinDelHp, MaxDelHp),
                                            NewBleed = DelHp;
                                        [MinDelHpP, MaxDelHpP|_] when is_float(MinDelHpP), is_float(MaxDelHpP), MinDelHpP > 0, MaxDelHpP > 0 ->
                                            MinDelHp = round(MinDelHpP*HpLim),
                                            MaxDelHp = round(MaxDelHpP*HpLim),
                                            DelHp = urand:rand(MinDelHp, MaxDelHp),
                                            NewBleed = DelHp;
                                        _ ->
                                            NewBleed = 1
                                    end;
                                is_integer(MaxHurt) == false ->
                                    NewBleed = Bleed;
                                true ->
                                    NewBleed = min(Bleed, MaxHurt)
                            end
                    end,
                    #battle_status{per_hurt = NewPerHurt, per_hurt_time = NewPerHurtTime} = mod_battle:calc_per_hurt(BS, NewBleed, NowTime),
                    % ?MYLOG("hjhskill", "Bleed:~p NewBleed:~p DelHpEachTime:~p NewPerHurt:~p NewPerHurtTime:~p ~n",
                    %     [Bleed, NewBleed, DelHpEachTime, NewPerHurt, NewPerHurtTime]),
                    % 怪物流血不致死
                    HpAfLock = mod_battle:calc_hp_lock(Object, Hp-NewBleed, Hp, NowTime),
                    NewHp = round(max(1, HpAfLock)),
                    {ok, BinData} = pt_120:write(12036, [Sign, Id, NewHp, HpLim, 1, Bleed, EventId, AttSign, AtterId]),
                    send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
                    NewCount = Count - 1,
                    NewBanBleedL = if
                        NewHp =< 1 ->
                            [util:cancel_timer(BleedRef) || #ban_bleed{ref = BleedRef} <- BanBleedL],
                            [];
                        NewCount =< 0 ->
                            lists:keydelete(TimeRef, #ban_bleed.ref, BanBleedL);
                        true ->
                            BleedRef = lib_scene_timer:add_timer(NowTime, GapTime, Sign, Id, ?SPBUFF_BAN_BLEED, {GapTime, Bleed, NewCount, ATTer}),
                            NewBanBleed = BanBleed#ban_bleed{ref = BleedRef},
                            [NewBanBleed|lists:keydelete(TimeRef, #ban_bleed.ref, BanBleedL)]
                    end,
                    NewOj = Object#scene_object{
                        per_hurt = NewPerHurt, per_hurt_time = NewPerHurtTime,
                        battle_attr = BA#battle_attr{hp = NewHp, ban_bleed_list = NewBanBleedL}
                        },
                    lib_scene_object_agent:put_object(NewOj),
                    if
                        NewHp > 0->
                            Pid ! {debuff_hurt, EventId, NewBleed, NewHp};
                        true ->
                            Atter = case AttSign of
                                        ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(AtterId);
                                        _ -> lib_scene_object_agent:get_object(AtterId)
                                    end,
                            case Atter of
                                [] -> skip;
                                _  -> send_die_msg_to_object(NewOj, Atter, NewHp, NewBleed)
                            end
                    end
            end;

        ?SPBUFF_SKILL ->
            {GapTime, Count, Int, Float, {AtterId, AttSign, _AttName} = ATTer} = Args,
            #battle_attr{skill_ref = SkillRefs} = BA,
            if
                Count =< 0 -> skip;
                true ->
                    AttObject = case AttSign of
                        ?BATTLE_SIGN_PLAYER -> lib_scene_agent:get_user(AtterId);
                        _ -> lib_scene_object_agent:get_object(AtterId)
                    end,
                    case AttObject of
                        #scene_object{aid = Aid} ->
                            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, object_battle_cast,
                                [Aid, AttSign, AtterId, {target, Sign, Id}, Int, Float, 0]);
                        #ets_scene_user{} ->
                            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, object_start_battle,
                                [AttSign, AtterId, {target, Sign, Id}, Int, Float, 0]);
                        _ ->
                            skip
                    end
            end,
            % 定时器
            NewCount = Count - 1,
            NewSkillRefs = if
                Count =< 0 andalso NewCount =< 0 ->
                    lists:delete(TimeRef, SkillRefs);
                true ->
                    % 定时器
                    NowTime = utime:longunixtime(),
                    SkillRef = lib_scene_timer:add_timer(NowTime, GapTime, Sign, Id, ?SPBUFF_SKILL, {GapTime, NewCount, Int, Float, ATTer}),
                    [SkillRef|lists:delete(TimeRef, SkillRefs)]
            end,
            NewOj = Object#scene_object{battle_attr = BA#battle_attr{skill_ref = NewSkillRefs}},
            lib_scene_object_agent:put_object(NewOj);

        _ -> skip
    end;
timer_call_back(_, _, _, _, _) ->
    skip.

%% 计算特效buff
calc_skill_effect([], _Time, SE) -> SE;
calc_skill_effect([{K, _SkillId, _, _SkillLv, _Stack, _Int, _Float, T, _EffectId, _AttrId}=_E | Tail], Time, SE) ->
    case T > Time of
        true ->
            NewSE = case K of
                ?SPBUFF_UNREUME ->
                    SE#skill_effect{un_resume = 1};
                _ ->
                    SE
            end,
            calc_skill_effect(Tail, Time, NewSE);
        false ->
            calc_skill_effect(Tail, Time, SE)
    end;
calc_skill_effect([_T | Tail], Time, SE) ->
    calc_skill_effect(Tail, Time, SE).

add_resume_timer(Ref, Hp, HpLim, Id, NowTime, GapTime) ->
    add_resume_timer(Ref, Hp, HpLim, ?BATTLE_SIGN_PLAYER, Id, NowTime, GapTime).
add_resume_timer(Ref, Hp, HpLim, Sign, Id, NowTime, GapTime) ->
    if
        Hp >= HpLim orelse Hp == 0 orelse
        GapTime == 0 orelse is_reference(Ref) -> undefined;
        true -> lib_scene_timer:add_timer(NowTime, GapTime, Sign, Id, ?HP_RESUME, 0)
    end.

remove_resume_timer(_Id) -> skip.

%% %% 开启回血定时器
begin_resume_timer(Ref, Sign, Id, BA, NowTime, GapTime) ->
    #battle_attr{hp=Hp, hp_lim=HpLim, hp_resume_add = HpResumeAdd} = BA,
    if
        Hp =< 0 orelse Hp >= HpLim orelse HpResumeAdd =< 0 -> undefined;
        is_reference(Ref) -> Ref;
        true -> lib_scene_timer:add_timer(NowTime, max(3000, GapTime), Sign, Id, ?HP_RESUME, 0)
    end.

%% 检查pk状态
%% 12:在安全区域
%% check_pk_and_safe(_, _, _) -> true.
check_pk_and_safe(Aer, Der, EtsScene, NowTime) when is_record(Aer, battle_status), is_record(Der, battle_status) ->
    #battle_status{id=IdA, copy_id=CopyIdA, x=XA, y=YA, sign=AerSign, mid = _AMid, kind=AerKind, battle_attr=#battle_attr{pk=AerPk, group=GroupA, ghost=GhostA, is_hurt_mon = IsHurtMon},
                   team_id=TeamIdA, guild_id=GuildIdA, skill_owner=SkillOwnerA, in_sea = InSeaA, server_id = ServerIdA, camp_id = CampA,
                   boss_tired = BossTired, figure = #figure{vip_type = VipType, vip = VipLv}, assist_id = AssistId} = Aer,

    #battle_status{id=IdD, copy_id=CopyIdD, x=XD, y=YD, sign=DerSign, mid = DMid, battle_attr=#battle_attr{hp = DerHp, pk=DerPk, group=GroupD, ghost=GhostD},
                   team_id=TeamIdD, guild_id=GuildIdD, skill_owner=SkillOwnerD, is_be_atted=IsBeAttedD, in_sea = InSeaD, be_att_limit = BeAttLimitD,
                   server_id = ServerIdB, camp_id = CampB, assist_ids = AssistIds} = Der,
    BossMiss = if
        DerSign == ?BATTLE_SIGN_MON ->
            lib_battle_util:check_boss_missing(EtsScene#ets_scene.id, DMid, BossTired, VipType, VipLv, [AssistId, AssistIds]);
        true -> false
    end,
    Res = if
        CopyIdA =/= CopyIdD -> {false, 15}; %% 不在同个房间

        IsBeAttedD == 0 -> {false, 0};      %% 不允许被攻击

        BossMiss -> {false, 0};       %% 疲劳值满了无法攻击

        DerHp =< 0 -> {false, 0};      %% 没血不允许被攻击

        DerSign == ?BATTLE_SIGN_MON andalso IsHurtMon == 0 -> {false, 23};  % 不伤害怪物

        IdA ==  SkillOwnerD#skill_owner.id andalso AerSign == SkillOwnerD#skill_owner.sign -> {false, 14}; %% %% 不能攻击自己的下属

        SkillOwnerA#skill_owner.id > 0 andalso SkillOwnerA#skill_owner.id == IdD andalso SkillOwnerA#skill_owner.sign == DerSign -> {false, 1}; %% 不能攻击所属方

        SkillOwnerA#skill_owner.id > 0 andalso SkillOwnerA#skill_owner.id == SkillOwnerD#skill_owner.id
            andalso SkillOwnerA#skill_owner.sign == SkillOwnerD#skill_owner.sign -> {false, 2}; %% 不能攻击同所属方

        IdA == IdD andalso AerSign == DerSign -> {false, 3}; %% 不能攻击自己

        EtsScene#ets_scene.type =/= ?SCENE_TYPE_SEACRAFT andalso GroupA > 0 andalso GroupA == GroupD -> {false, 4}; %% 分组一样
        EtsScene#ets_scene.type == ?SCENE_TYPE_SEACRAFT andalso GroupA > 0 andalso GroupD > 0 andalso GroupA =/= GroupD -> {false, 25}; %% 船只类型不相同不可以攻击

        GroupA == 0 andalso GroupD == 0 andalso AerSign == ?BATTLE_SIGN_MON andalso DerSign == ?BATTLE_SIGN_MON -> {false, 15}; %% 分组为0，怪物不能互相攻击

        GhostA > 0 orelse GhostD > 0 -> {false, 5}; %% 是幽灵状态

        %% 和平和强制不能攻击同队伍和同帮派的玩家
        (is_record(AerPk, pk) == false orelse (AerPk#pk.pk_status /= ?PK_ALL andalso AerPk#pk.pk_status /= ?PK_GUILD)) andalso
            (TeamIdA > 0 andalso TeamIdA == TeamIdD andalso GroupA == 0 andalso ServerIdA == ServerIdB) -> {false, 6}; %% 同一队伍

        (is_record(AerPk, pk) == false orelse AerPk#pk.pk_status /= ?PK_ALL) andalso
            ((GuildIdA > 0 andalso GuildIdD > 0 andalso GuildIdA == GuildIdD andalso GroupA == 0)
            orelse (GuildIdA > 0 andalso SkillOwnerD#skill_owner.guild_id > 0 andalso
            GuildIdA == SkillOwnerD#skill_owner.guild_id andalso GroupA == 0)) ->  {false, 7}; %% 没分组，同一家族

        EtsScene#ets_scene.subtype == ?SCENE_SUBTYPE_SAFE -> {false, 8}; %% 安全场景不能pk

        EtsScene#ets_scene.type == ?SCENE_TYPE_GWAR andalso DerSign /= ?BATTLE_SIGN_PLAYER andalso is_list(BeAttLimitD) ->
            ?IF(lists:member(GuildIdA, BeAttLimitD), true, {false, 17}); %% 公会不在怪物的攻击受限列表中，不能攻击
        %% 怒海争霸/四海争霸 同阵营不可以互相攻击,玩家和怪物之间
        EtsScene#ets_scene.type == ?SCENE_TYPE_SEACRAFT   ->
            ?IF(CampA =/= CampB, true, {false, 24});
        % 不攻击人的进击怪
        AerSign == ?BATTLE_SIGN_MON andalso AerKind == ?MON_KIND_ATT_NOT_PLAYER andalso DerSign == ?BATTLE_SIGN_PLAYER -> {false, 19};

        % 其中一方不是玩家，则可以攻击
        (AerSign =/= ?BATTLE_SIGN_PLAYER andalso AerSign =/= ?BATTLE_SIGN_PET andalso
        AerSign =/= ?BATTLE_SIGN_BABY andalso AerSign =/= ?BATTLE_SIGN_HGHOST andalso
        AerSign =/= ?BATTLE_SIGN_MATE andalso AerSign =/= ?BATTLE_SIGN_FAIRY andalso
        AerSign =/= ?BATTLE_SIGN_DEMONS andalso AerSign=/= ?BATTLE_SIGN_COMPANION) orelse
        DerSign =/= ?BATTLE_SIGN_PLAYER ->
            % 指定场景,防守者在安全区域不能被攻击
            case EtsScene#ets_scene.type == ?SCENE_TYPE_ESCORT andalso lib_scene:is_safe(EtsScene#ets_scene.id, CopyIdD, XD, YD) of
                true -> {false, 12};
                false -> true
            end;

        %% 玩家部分（非玩家部分上面已经判断完，不会走到下面）
        EtsScene#ets_scene.subtype == ?SCENE_SUBTYPE_KILL_MON -> {false, 9}; %% 非pk场景不能攻击人

        NowTime < DerPk#pk.protect_time -> {false, 19}; %% 玩家攻击的保护时间:不能被打
        NowTime < AerPk#pk.protect_time -> {false, 20}; %% 玩家攻击的保护时间:不能打人

        %% 和平模式不能攻击任何人
        AerPk#pk.pk_status == ?PK_PEACE -> {false, 10};
        %% 防守方是和平模式，有保护时间
        DerPk#pk.pk_status == ?PK_PEACE andalso NowTime < DerPk#pk.pk_protect_time -> {false, 14}; %% 保护时间
        % AerPk#pk.pk_status == ?PK_PEACE_ULTIMATE -> {false, 15}; %% 攻击方终极和平模式，不能攻击任何人
        % DerPk#pk.pk_status == ?PK_PEACE_ULTIMATE -> {false, 16}; %% 防守方终极和平模式，不能任何人被攻击
        AerPk#pk.pk_status == ?PK_SERVER andalso ServerIdA == ServerIdB andalso GroupA == 0 -> {false, 18}; %% 无分组服模式,相同节点不攻击.
        %% AerPk#pk.pk_status == ?PK_GUILD andalso DerPk#pk.pk_status == ?PK_PEACE andalso GroupA == 0 -> {false, 11}; %% 无分组时家族模式不能攻击和平
        AerPk#pk.pk_status == ?PK_CAMP andalso CampA == CampB andalso GroupA == 0 -> {false, 18};
        true ->
            %% 先判断守方，，一般是守方在安全区
            case lib_scene:is_safe(EtsScene#ets_scene.id, CopyIdD, XD, YD) of
                true ->
                    case lib_kf_guild_war_api:is_kf_guild_war_scene(EtsScene#ets_scene.id) of
                        true -> IsInSafe = InSeaA =/= 1;
                        _ -> IsInSafe = true
                    end;
              _ ->
                case lib_scene:is_safe(EtsScene#ets_scene.id, CopyIdA, XA, YA) of
                    true ->
                        case lib_kf_guild_war_api:is_kf_guild_war_scene(EtsScene#ets_scene.id) of
                            true -> IsInSafe = InSeaD =/= 1;
                             _ -> IsInSafe = true
                        end;
                     _ -> IsInSafe = false
                end
            end,
            case IsInSafe of
                true ->
                    {false, 12}; %% 其中一方在安全区
                _ ->
                    if
                        EtsScene#ets_scene.type == ?SCENE_TYPE_SEACRAFT andalso GroupA > 0 andalso GroupD > 0 andalso GroupA == GroupD ->
                            true;
                        GroupA == 0 orelse GroupD == 0 orelse GroupA /= GroupD ->
                            true;
                        true ->
                            {false, 13}
                    end
                    % case GroupA == 0 orelse GroupD == 0 orelse GroupA /= GroupD of
                    %     true -> true;
                    %     false -> {false, 13}
                    % end
            end
    end,
    % ?PRINT("Res:~p~n",[Res]),
    % ?IF(IdA==4294968074,
    %     ?MYLOG("revive", "AerSign:~p AerKind:~p DerSign:~p TeamIdA:~p TeamId:~p DerHp:~p XD:~p, YD:~p Res:~p ~n",
    %         [AerSign, AerKind, DerSign, TeamIdA, TeamIdD, DerHp, XD, YD, Res]),
    %     skip),
    % ?PRINT("GroupA:~p, GroupD:~p, AerSign:~p AerKind:~p DerSign:~p TeamIdA:~p TeamId:~p Res:~p ~n",
    %     [GroupA, GroupD, AerSign, AerKind, DerSign, TeamIdA, TeamIdD, Res]),
    Res.
%check_pk_and_safe(Aer, Der, EtsScene, NowTime)
%    when is_record(Aer, scene_calc_args), is_record(Der, scene_calc_args_def) ->
%    #scene_calc_args{
%        id=IdA, sign=AerSign, kind=AerKind, battle_attr=#battle_attr{pk=AerPk, group=GroupA, ghost=GhostA, is_hurt_mon = IsHurtMon},
%        team_id=TeamIdA, guild_id=GuildIdA, skill_owner=SkillOwnerA, in_sea = InSeaA, server_id = ServerIdA, camp_id = CampA,
%        boss_tired = BossTired, figure = #figure{vip_type = VipType, vip = VipLv}, assist_id = AssistId
%    } = Aer,
%    #scene_calc_args_def{} = Der,
%    ok.


%% Type:1 被攻击, 2攻击
do_partner_personlity(1, [{_, Aid, Personality}|T], AtterSign, AtterId) when Personality == 1 orelse Personality == 3 ->
    mod_partner_active:master_be_atted(Aid, AtterSign, AtterId),
    do_partner_personlity(1, T, AtterSign, AtterId);
do_partner_personlity(2, [{_, Aid, _}|T], DerSign, DerId) ->
    mod_partner_active:master_att(Aid, DerSign, DerId),
    do_partner_personlity(2, T, DerSign, DerId);
do_partner_personlity(Type, [_|T], AtterSign, AtterId) -> do_partner_personlity(Type, T, AtterSign, AtterId);
do_partner_personlity(_, [], _, _) -> skip.

%% 强制打破隐身
break_steath_force(Sign, Id, EtsScene) ->
    case Sign of
        ?BATTLE_SIGN_PLAYER ->
            case lib_scene_agent:get_user(Id) of
                #ets_scene_user{copy_id=CopyId, x=X, y=Y, battle_attr=BA} = User when BA#battle_attr.hide==1->
                    lib_skill_buff:handle_steath_state(?BATTLE_SIGN_PLAYER, Id, CopyId,
                                                       X, Y, EtsScene#ets_scene.broadcast, 0, 0, 0),
                    lib_scene_agent:put_user(User#ets_scene_user{battle_attr=BA#battle_attr{hide=0}});
                _ -> skip
            end;
        _ ->
            case lib_scene_object_agent:get_object(Id) of
                #scene_object{copy_id=CopyId, x=X, y=Y, battle_attr=BA} = Object when BA#battle_attr.hide==1 ->
                    lib_skill_buff:handle_steath_state(Sign, Id,CopyId,
                                                       X, Y, EtsScene#ets_scene.broadcast, 0, 0, 0),
                    lib_scene_object_agent:put_object(Object#scene_object{battle_attr=BA#battle_attr{hide=0}});
                _ -> skip
            end
    end.

%% 发送死亡信息
send_die_msg_to_object(Object, Atter, Hpb, Hurt)->
    Aer = lib_battle_util:init_data(Atter),
    Der = lib_battle_util:init_data(Object),
    LastAerSign = lib_battle:calc_real_sign(Aer#battle_status.sign),
    [RetrunAtter, RetrunSign] = case Aer#battle_status.skill_owner of
        %% 父类属性
        #skill_owner{
                id=OwnerId, pid=OwnerPid, node=OwnerNode,
                guild_id = OwnerGuildId, team_id=OwnerTeamId, sign=OwnerSign} ->
            [#battle_return_atter{
                sign = OwnerSign, id = OwnerId, node = OwnerNode, mid = Aer#battle_status.mid,
                kind = Aer#battle_status.kind, pid = OwnerPid, team_id = OwnerTeamId, x = Aer#battle_status.x,
                y = Aer#battle_status.y, hide = Aer#battle_status.battle_attr#battle_attr.hide, guild_id = OwnerGuildId,
                real_id = Aer#battle_status.id, real_sign = Aer#battle_status.sign, real_name = Aer#battle_status.figure#figure.name,
                server_id = Aer#battle_status.server_id, server_num = Aer#battle_status.server_num, world_lv = Aer#battle_status.world_lv,
                server_name = Aer#battle_status.server_name, mod_level = Aer#battle_status.mod_level, camp_id = Aer#battle_status.camp_id,
                mask_id = Aer#battle_status.figure#figure.mask_id,
                assist_id = Aer#battle_status.assist_id
                }
                , OwnerSign];
        _ ->
            OwnerNode = Aer#battle_status.node,
            OwnerId = Aer#battle_status.id,
            [#battle_return_atter{
                sign = Aer#battle_status.sign, id = OwnerId, node = OwnerNode,
                mid = Aer#battle_status.mid, kind = Aer#battle_status.kind, pid = Aer#battle_status.pid,
                team_id = Aer#battle_status.team_id, x = Aer#battle_status.x, y = Aer#battle_status.y,
                hide = Aer#battle_status.battle_attr#battle_attr.hide, guild_id = Aer#battle_status.guild_id,
                real_id = Aer#battle_status.id, real_sign = LastAerSign, real_name = Aer#battle_status.figure#figure.name,
                server_id = Aer#battle_status.server_id, server_num = Aer#battle_status.server_num, world_lv = Aer#battle_status.world_lv,
                server_name = Aer#battle_status.server_name, mod_level = Aer#battle_status.mod_level, camp_id = Aer#battle_status.camp_id,
                mask_id = Aer#battle_status.figure#figure.mask_id,
                assist_id = Aer#battle_status.assist_id
                }
                , LastAerSign]
    end,
    %% 防守方信息
    #battle_status{id = DefId, node = DefNode, pid = DefPid, sign = DerSign, scene = SceneId} = Der,
    BattleReturn = #battle_return{
        hp = Hpb, hurt = Hurt, sign = RetrunSign, atter = RetrunAtter,
        attr_buff_list = Der#battle_status.battle_attr#battle_attr.attr_buff_list,
        other_buff_list = Der#battle_status.battle_attr#battle_attr.other_buff_list,
        real_hurt = Hurt},

    if
        DerSign == ?BATTLE_SIGN_PLAYER ->
            % 助攻列表
            case lib_scene_agent:get_user(DefId) of
                #ets_scene_user{hit_list = HitList} -> ok;
                _ -> HitList = []
            end,
            % 只有需要记录的场景才有助攻列表
            IsNeedScene = lib_battle_util:is_need_hit_list(SceneId),
            case RetrunSign == ?BATTLE_SIGN_PLAYER andalso IsNeedScene of
                true ->
                    #battle_return_atter{id = AtterId, node = AtterNode} = RetrunAtter,
                    NowTime = utime:longunixtime(),
                    Hit = #hit{id = AtterId, node = AtterNode, time = NowTime},
                    % 只保留12条
                    NewHitList = lists:sublist([Hit|lists:keydelete(AtterId, #hit.id, HitList)], 12);
                false ->
                    NewHitList = HitList
            end,
            mod_battle:send_to_node_pid(DefNode, DefPid, {'battle_info_die', BattleReturn#battle_return{hit_list = NewHitList}});
        true ->
            mod_battle:send_to_node_pid(DefNode, DefPid, {'battle_info', BattleReturn})
    end.

%% 检查是否有回血触发的天赋技能
check_have_hp_rusme_skill(User, NowTime)->
    #ets_scene_user{skill_cd = SkillCd, skill_passive = SkillPassive} = User,
    case lists:keyfind(?SP_SKILL_TLDEF10, 1, SkillPassive) of
        false -> false;
        {_, SkillLv} ->
            case lists:keyfind(?SP_SKILL_TLDEF10, 1, SkillCd) of
                {_, EndTime} when EndTime > NowTime -> false;
                _ -> {ok, ?SP_SKILL_TLDEF10, SkillLv}
            end
    end.

%% 选择攻击对象
%% @param Objects [#battle_status{}|#scene_object{}|#ets_scene_user{}]
%% @return Objects:根据参数的结构,返回对应的结构
obj_select_att_num_der(Objects, SkillId, SkillLv)->
    #skill{lv_data = #skill_lv{num = [PNum, MNum]}} = data_skill:get(SkillId, SkillLv),
    obj_select_att_num_der(Objects, PNum, MNum, [], 0, 0).

obj_select_att_num_der([], _PNum, _MNum, Ders, _PN, _MN) -> Ders;
obj_select_att_num_der([#ets_scene_user{}=Obj|Objects], PNum, MNum, Ders, PN, MN)->
    if
        PN < PNum -> obj_select_att_num_der(Objects, PNum, MNum, [Obj|Ders], PN+1, MN);
        true -> obj_select_att_num_der(Objects, PNum, MNum, Ders, PN, MN)
    end;
obj_select_att_num_der([#battle_status{sign = ?BATTLE_SIGN_PLAYER}=Obj|Objects], PNum, MNum, Ders, PN, MN)->
    if
        PN < PNum -> obj_select_att_num_der(Objects, PNum, MNum, [Obj|Ders], PN+1, MN);
        true -> obj_select_att_num_der(Objects, PNum, MNum, Ders, PN, MN)
    end;
obj_select_att_num_der([Obj|Objects], PNum, MNum, Ders, PN, MN)->
    if
        MN < MNum -> obj_select_att_num_der(Objects, PNum, MNum, [Obj|Ders], PN, MN+1);
        true -> obj_select_att_num_der(Objects, PNum, MNum, Ders, PN, MN)
    end.

interrupt_collect(#ets_scene_user{collect_pid = {Aid, _}, scene = SceneId} = User, StopperId) ->
    if
        is_pid(Aid) ->
            case lists:member(SceneId, ?INTERRUPT_COLLECT_SCENES) of
                true ->
                    #ets_scene_user{id = Id, node = Node} = User,
                    Aid ! {'stop_collect', Id, Node, StopperId},
                    User#ets_scene_user{collect_pid = {0, 0}};
                _ ->
                    User
            end;
        true ->
            User
    end.

interrupt_collect_force(#ets_scene_user{collect_pid = {Aid, _}} = User) ->
    if
        is_pid(Aid) ->
            #ets_scene_user{id = Id, node = Node} = User,
            Aid ! {'stop_collect', Id, Node, 0},
            User#ets_scene_user{collect_pid = {0, 0}};
        true ->
            User
    end.

%% 抢夺
rob_mon_bl(Node, RoleId, MonId) ->
    User = lib_scene_agent:get_user(RoleId),
    Object = lib_scene_object_agent:get_object(MonId),
    ErrCode = if
        not is_record(User, ets_scene_user) -> ?ERRCODE(err200_not_user);
        not is_record(Object, scene_object) -> ?ERRCODE(err200_not_mon);
        Object#scene_object.sign =/= ?BATTLE_SIGN_MON -> ?ERRCODE(err200_not_mon);
        true ->
            #ets_scene_user{copy_id = CopyId, scene = _SceneId} = User,
            #scene_object{copy_id = ObjectCopyId, aid = _Aid} = Object,
            % IsOutsideBoss = lib_boss:is_in_outside_boss(SceneId),
            % IsAbyssBoss = lib_boss:is_in_abyss_boss(SceneId),
            % IsForBoss = lib_boss:is_in_forbdden_boss(SceneId),
            if
                % 限制场景
                % not IsOutsideBoss andalso not IsAbyssBoss andalso not IsForBoss ->
                %     ?ERRCODE(err200_not_rob_this_mon_bl);
                CopyId =/= ObjectCopyId -> ?ERRCODE(err200_rob_mon_bl_must_same_scene);
                true ->
                    % 没有主动抢夺,屏蔽代码
                    % mod_mon_active:rob_mon_bl(Aid, Node, RoleId),
                    ?SUCCESS
            end
    end,
    case ErrCode == ?SUCCESS of
        true -> skip;
        false ->
            {ok, BinData} = pt_200:write(20020, [ErrCode, MonId]),
            lib_server_send:send_to_uid(Node, RoleId, BinData)
    end,
    ok.

%% 归属抢夺战斗
rob_mon_bl_battle(Node, RoleId, MonId, OwnerId) ->
    User = lib_scene_agent:get_user(RoleId),
    OwnUser = lib_scene_agent:get_user(OwnerId),
    Object = lib_scene_object_agent:get_object(MonId),
    ErrCode = if
        not is_record(User, ets_scene_user) -> ?ERRCODE(err200_not_user);
        not is_record(OwnUser, ets_scene_user) -> ?ERRCODE(err200_not_user);
        not is_record(Object, scene_object) -> ?ERRCODE(err200_not_mon);
        true ->
            #ets_scene_user{
                copy_id = CopyId, pid = Pid, node = UserNode, team = #status_team{team_id = TeamId},
                figure = #figure{lv = Lv, name = Name, mask_id = MaskId}, server_id = ServerId, server_num = ServerNum, world_lv = WorldLv,
                server_name = ServerName, mod_level = ModLevel, camp_id = Camp, assist_id = AssistId
                } = User,
            #ets_scene_user{copy_id = OwnCopyId} = OwnUser,
            #scene_object{copy_id = ObjectCopyId, aid = Aid} = Object,
            {WinCode, WinHp} = simulate_battle(User, OwnUser),
            % ?MYLOG("hjh", "WinCode:~p WinHp:~p ~n", [WinCode, WinHp]),
            if
                CopyId =/= ObjectCopyId orelse CopyId =/= OwnCopyId -> ?ERRCODE(err200_rob_mon_bl_must_same_scene);
                % WinCode == 2 -> ?ERRCODE(err200_rob_mon_bl_fail);
                true ->

                    MonAtter = #mon_atter{
                        id = RoleId, pid = Pid, node = UserNode, team_id = TeamId,
                        att_sign = ?BATTLE_SIGN_PLAYER, att_lv = Lv, server_id = ServerId,
                        server_num = ServerNum, name = Name, world_lv = WorldLv, server_name = ServerName,
                        mod_level = ModLevel, camp_id = Camp, mask_id = MaskId, assist_id = AssistId
                        },
                    mod_mon_active:rob_mon_bl_success(Aid, MonAtter, OwnerId, WinCode, WinHp),
                    ?SUCCESS
            end
    end,
    case ErrCode == ?SUCCESS of
        true -> skip;
        false ->
            {ok, BinData} = pt_200:write(20020, [ErrCode, MonId]),
            lib_server_send:send_to_uid(Node, RoleId, BinData)
    end,
    ok.

%% 处理血量
handle_hp_af_rob_mon_bl(RoleId, RobbedId, WinCode, WinHp, Mid, EtsScene) ->
    User = lib_scene_agent:get_user(RoleId),
    RobbedUser = lib_scene_agent:get_user(RobbedId),
    case WinCode == 1 of
        true -> WinUser = User, LoseUser = RobbedUser;
        false -> WinUser = RobbedUser, LoseUser = User
    end,
    lib_boss_api:rob_mon_bl(EtsScene, RoleId, RobbedId, Mid),
    % ?MYLOG("hjh", "handle_hp_af_rob_mon_bl3 {RoleId, RobbedId, WinCode, WinHp}: ~p ~n", [{RoleId, RobbedId, WinCode, WinHp}]),
    case is_record(WinUser, ets_scene_user) of
        true ->
            #ets_scene_user{id = WinId, scene = SceneId, copy_id = CopyId, x = X, y = Y, battle_attr=BA, node=Node} = WinUser,
            #battle_attr{hp=Hp, hp_lim=HpLim} = BA,
            NewHp = min(WinHp, Hp),
            {ok, BinData} = pt_120:write(12009, [WinId, NewHp, HpLim]),
            case data_scene:get(SceneId) of
                #ets_scene{broadcast = Broadcast} -> ok;
                _ -> Broadcast = 0
            end,
            send_to_scene(CopyId, X, Y, Broadcast, BinData),
            rpc_cast_to_node(Node, lib_player, update_player_info, [WinId, [{hp, NewHp}]]),
            lib_scene_agent:put_user(WinUser#ets_scene_user{battle_attr=BA#battle_attr{hp=NewHp}});
        false ->
            skip
    end,
    case is_record(WinUser, ets_scene_user) andalso is_record(LoseUser, ets_scene_user) of
        true ->
            #ets_scene_user{id = WinId2, node = WinNode} = WinUser,
            #ets_scene_user{
                id=LoseId, scene=LoseSceneId, node=LoseNode, pid=LosePid, battle_attr=LoseBA,
                copy_id=LoseCopyId, x = LoseX, y = LoseY, figure = #figure{name = Name}
                }=LoseUser,
            #battle_attr{hp_lim=LoseHpLim} = LoseBA,
            {ok, LoseBinData} = pt_200:write(20022, [WinId2, LoseId, 0, LoseHpLim]),
            case data_scene:get(LoseSceneId) of
                #ets_scene{broadcast = LoseBroadcast} -> ok;
                _ -> LoseBroadcast = 0
            end,
            send_to_scene(LoseCopyId, LoseX, LoseY, LoseBroadcast, LoseBinData),
            if
                % 抢夺失败
                WinCode == 2 ->
                    {ok, FailBinData} = lib_game:make_error_bin_data({?ERRCODE(err200_other_rob_my_mon_bl_fail), [Name]}),
                    lib_server_send:send_to_uid(WinNode, WinId2, FailBinData);
                true ->
                    skip
            end,
            BattleReturn = make_die_battle_return(WinUser, LoseUser),
            mod_battle:send_to_node_pid(LoseNode, LosePid, {'battle_info_die', BattleReturn});
        false ->
            skip
    end,
    ok.

%% 构造战斗返回
make_die_battle_return(Aer, Der) ->
    #ets_scene_user{battle_attr = BAA} = Aer,
    #ets_scene_user{battle_attr = BAD} = Der,
    RetrunAtter = #battle_return_atter{
        sign = ?BATTLE_SIGN_PLAYER,
        id = Aer#ets_scene_user.id,
        node = Aer#ets_scene_user.node,
        mid = 0,
        kind = 0,
        pid = Aer#ets_scene_user.pid,
        team_id = Aer#ets_scene_user.team#status_team.team_id,
        x = Aer#ets_scene_user.x,
        y = Aer#ets_scene_user.y,
        hide = BAA#battle_attr.hide,
        guild_id = Aer#ets_scene_user.figure#figure.guild_id,
        real_id = Aer#ets_scene_user.id,
        real_sign = ?BATTLE_SIGN_PLAYER,
        real_name = Aer#ets_scene_user.figure#figure.name,
        lv = Aer#ets_scene_user.figure#figure.lv,
        server_id = Aer#ets_scene_user.server_id,
        server_num = Aer#ets_scene_user.server_num,
        world_lv = Aer#ets_scene_user.world_lv,
        server_name = Aer#ets_scene_user.server_name,
        mod_level = Aer#ets_scene_user.mod_level
        , camp_id = Aer#ets_scene_user.camp_id
        , mask_id = Aer#ets_scene_user.figure#figure.mask_id
        , assist_id = Aer#ets_scene_user.assist_id
        },

    #battle_return{
        hp = 0,
        hurt = BAD#battle_attr.hp,
        shield = 0,
        sign = ?BATTLE_SIGN_PLAYER,
        atter = RetrunAtter,
        move_x = 0,
        move_y = 0,
        attr_buff_list = BAD#battle_attr.attr_buff_list,
        other_buff_list = BAD#battle_attr.other_buff_list,
        real_hurt = BAD#battle_attr.hp
        }.


%% 模拟战斗
%% {胜利方(1:攻击者 2:防守者), 胜利方的血量}
simulate_battle(Aer, Der) ->
    #ets_scene_user{battle_attr=BAA} = Aer,
    #battle_attr{hp=HpA} = BAA,
    #ets_scene_user{battle_attr=BAD} = Der,
    #battle_attr{hp=HpD} = BAD,
    ExpectA = get_simulate_battle_expect_hurt(Aer, Der),
    ExpectD = get_simulate_battle_expect_hurt(Der, Aer),
    TA = HpD/ExpectA,
    TD = HpA/ExpectD,
    % ?MYLOG("hjh", "ExpectA:~p ExpectD:~p HpD:~p HpA:~p TA:~p TD:~p ~n", [ExpectA, ExpectD, HpD, HpA, TA, TD]),
    case TA > TD of
        true -> {2, round(max(HpD-TD*ExpectA, 1))};
        false -> {1, round(max(HpA-TA*ExpectD, 1))}
    end.

get_simulate_battle_expect_hurt(Aer, Der) ->
    %% 攻击方
    #ets_scene_user{battle_attr=BAA} = Aer,
    #battle_attr{attr=AttrA} = BAA,
    #attr{
        att = AttA, hit = HitA, crit = CritA, wreck = WreckA, elem_att = ElemAttA,
        hurt_add_ratio = HurtAddRatioA, skill_hurt_add_ratio = SkillHurtAddRatio,
        % ay_wreck = AyWreckA, ss_wreck = SsWreckA, hd_wreck = HdWreckA,
        % ss_def = SsDefA, hd_def = HdDefA, ay_def = AyDefA,
        neglect = NeglectA, crit_hurt_add_ratio = CritHurtAddRatio,
        heart_hurt_add_ratio=HeartHurtAddRatio, crit_ratio = CritRatioA, hit_ratio = HitRatioA, heart_ratio = HeartRatioA, abs_att = AbsAttA} = AttrA,

    %% 防守方
    #ets_scene_user{battle_attr = BAD, figure = DerFigure} = Der,
    #figure{lv = LvD} = DerFigure,
    #battle_attr{attr = AttrD} = BAD,
    #attr{
        def = DefD, dodge = DodgeD, ten = TenD, elem_def = ElemDefD, hurt_del_ratio = HurtDelRatioD,
        skill_hurt_del_ratio = SkillHurtDelRatio,
        % ay_wreck = AyWreckD, ay_def = AyDefD, ss_wreck = SsWreckD,
        % ss_def = SsDefD, hd_wreck = HdWreckD, hd_def = HdDefD, parry_ratio = ParryRatioD,
        parry = ParryD, crit_hurt_del_ratio = CritHurtDelRatio,
        heart_hurt_del_ratio=HeartHurtDelRatio, dodge_ratio = DodgeRatioD, uncrit_ratio = UnCritRatioD, abs_def = AbsDefD} = AttrD,
    %% 技能比率
    HurtRatio = max(3+(SkillHurtAddRatio-SkillHurtDelRatio)/?RATIO_COEFFICIENT, 0.5),
    %% 绝对伤害
    ExtrHurt = max(ElemAttA-ElemDefD, 0),
    %% 伤害比率
    R = max(0.1, (1+(HurtAddRatioA*(1-ParryD/?RATIO_COEFFICIENT)-HurtDelRatioD*(1-NeglectA/?RATIO_COEFFICIENT))/?RATIO_COEFFICIENT)),
    %% 基础伤害值计算公式
    BaseHurt = if
        WreckA>=DefD-> (AttA+WreckA-DefD)*R+ExtrHurt;
        true-> %% A = 0.5, B = (1-A)
            (AttA*(0.5 + 0.5*max(WreckA,1)/max(DefD,1)))*R+ExtrHurt
    end,
    Hurt = BaseHurt * HurtRatio,

    RodgeRatio = round(DodgeD/(HitA+DodgeD+500+LvD*10)*0.2*?RATIO_COEFFICIENT + DodgeRatioD - HitRatioA),
    CritRatio = round(CritA/(TenD+CritA+1000+LvD*15)*0.3*?RATIO_COEFFICIENT + CritRatioA - UnCritRatioD),
    SumRatio = HeartRatioA + RodgeRatio + CritRatio,
    case SumRatio =< ?RATIO_COEFFICIENT of
        true -> HeartRatio2 = HeartRatioA/?RATIO_COEFFICIENT, RodgeRatio2 = RodgeRatio/?RATIO_COEFFICIENT, CritRatio2 = CritRatio/?RATIO_COEFFICIENT;
        false -> HeartRatio2 = HeartRatioA/SumRatio, RodgeRatio2 = RodgeRatio/SumRatio, CritRatio2 = CritRatio/SumRatio
    end,
    max(Hurt*(1+(
        HeartRatio2*(max(1.5+(HeartHurtAddRatio-HeartHurtDelRatio)/?RATIO_COEFFICIENT, 1.2)-1)-
        RodgeRatio2+
        CritRatio2*(1+CritHurtAddRatio/?RATIO_COEFFICIENT-CritHurtDelRatio/?RATIO_COEFFICIENT)
        )) + AbsAttA - AbsDefD, 1).

%% 技能用途转化成战斗类型
skill_career_to_att_type(?SKILL_CAREER_MATE) -> ?BATTLE_SIGN_MATE;
skill_career_to_att_type(?SKILL_CAREER_FAIRY) -> ?BATTLE_SIGN_FAIRY;
skill_career_to_att_type(?SKILL_CAREER_DEMONS) -> ?BATTLE_SIGN_DEMONS;
skill_career_to_att_type(?SKILL_CAREER_COMPANION) -> ?BATTLE_SIGN_COMPANION;
skill_career_to_att_type(_) -> 0.

%% 计算真实战斗对象(实际的攻击者)
calc_real_sign(Sign) ->
    case Sign of
        ?BATTLE_SIGN_PET -> ?BATTLE_SIGN_PLAYER;
        ?BATTLE_SIGN_BABY -> ?BATTLE_SIGN_PLAYER;
        ?BATTLE_SIGN_HOLY -> ?BATTLE_SIGN_PLAYER;
        ?BATTLE_SIGN_HGHOST -> ?BATTLE_SIGN_PLAYER;
        ?BATTLE_SIGN_MATE -> ?BATTLE_SIGN_PLAYER;
        ?BATTLE_SIGN_FAIRY -> ?BATTLE_SIGN_PLAYER;
        ?BATTLE_SIGN_DEMONS -> ?BATTLE_SIGN_PLAYER;
        ?BATTLE_SIGN_COMPANION -> ?BATTLE_SIGN_PLAYER;
        _Other -> _Other
    end.

%% 更新上一普通技能##改成任意技能
update_last_normal_skill(CurSkillId, _SkillLv, _LastSkillId) ->
    % case data_skill:get(CurSkillId, SkillLv) of
    %     #skill{is_normal = 1} -> CurSkillId;
    %     _ -> LastSkillId
    % end.
    CurSkillId.


%% 发送能量值
send_energy_info(Status) ->
    #player_status{sid=Sid, battle_attr = #battle_attr{energy = Energy}} = Status,
    {ok, BinData} = pt_200:write(20023, [Energy]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

%% 选怪物
select_mon_list(ObjectL, MonNumL) ->
    select_mon_list(ObjectL, MonNumL, []).

select_mon_list([], _MonNumL, Result) -> Result;
select_mon_list(_ObjectL, [], Result) -> Result;
select_mon_list([#scene_object{config_id = ConfigId, sign = ?BATTLE_SIGN_MON}=H|T], MonNumL, Result) ->
    case lists:keyfind(ConfigId, 1, MonNumL) of
        {ConfigId, Num} when Num =< 0 -> NewMonNumL = lists:keydelete(ConfigId, 1, MonNumL), NewResult = Result;
        {ConfigId, 1} -> NewMonNumL = lists:keydelete(ConfigId, 1, MonNumL), NewResult = [H|Result];
        {ConfigId, Num} -> NewMonNumL = lists:keystore(ConfigId, 1, MonNumL, {ConfigId, Num-1}), NewResult = [H|Result];
        _ -> NewMonNumL = MonNumL, NewResult = Result
    end,
    select_mon_list(T, NewMonNumL, NewResult);
select_mon_list([_H|T], MonNumL, Result) ->
    select_mon_list(T, MonNumL, Result).

% BaseHurt*Float*Stack + Int
calc_hurt_for_buff(Aer, Der, Int, Float, NowTime) ->
    #battle_attr{hp = HpD, hp_lim = HpLimD} = Der#battle_status.battle_attr,
    {MaxHurt, IsDelHpEachTime} = mod_battle:calc_del_hp_each_time(Der, NowTime),
    % RealHurtAfCalc = 显示属性真实打出的伤害(不一定是扣掉的血量,可能比扣掉的血量要高)
    {_HpAfCalc, HurtAfCalc, _RealHurtAfCalc} = if
        % %% 特殊状态，免疫伤害
        % HurtType == ?HURT_TYPE_IMMUE orelse HurtType == ?HURT_TYPE_SHIELD orelse
        %         HurtType == ?HURT_TYPE_MISS orelse HurtType == ?HURT_TYPE_NOTHING ->
        %     {Der#battle_status.battle_attr#battle_attr.hp, 0, 0};
        %% 固定伤害
        IsDelHpEachTime ->
            case Der#battle_status.del_hp_each_time of
                [DelHp, DelHp|_] when is_integer(DelHp)-> {max(0, HpD-DelHp), min(HpD, DelHp), DelHp};
                [MinDelHp, MaxDelHp|_] when is_integer(MinDelHp), is_integer(MaxDelHp), MinDelHp > 0, MaxDelHp > 0 ->
                    DelHp = urand:rand(MinDelHp, MaxDelHp),
                    {max(0, HpD-DelHp), min(HpD, DelHp), DelHp};
                [MinDelHpP, MaxDelHpP|_] when is_float(MinDelHpP), is_float(MaxDelHpP), MinDelHpP > 0, MaxDelHpP > 0 ->
                    MinDelHp = round(MinDelHpP*HpLimD),
                    MaxDelHp = round(MaxDelHpP*HpLimD),
                    DelHp = urand:rand(MinDelHp, MaxDelHp),
                    {max(0, HpD-DelHp), min(HpD, DelHp), DelHp};
                _ ->
                    {HpD-1, 1, 1}
            end;
        true ->
            calc_hurt_for_buff_core(Aer, Der, Int, Float, ?HURT_TYPE_NORMAL, ?HURT_TYPE_NORMAL, 1, MaxHurt)
    end,
    HurtAfCalc.

%% 技能
calc_hurt_for_buff_core(Aer, Der, Int, Float, HurtType, SecHurtType, PvpNo, MaxHurt) ->
    %% 攻击方
    #battle_status{battle_attr=BAA, sign = AerSign, boss = AerBoss, figure = AerFigure} = Aer,
    #battle_attr{
        attr=AttrA, mon_hurt_add = MonHurtAdd,
        mate_mon_hurt_add = MateMonHurtAdd, achiv_pvp_hurt_add = AchivPvpHurtAdd} = BAA,
    #attr{
        att = AttA, wreck = WreckA, elem_att = ElemAttA,
        hurt_add_ratio = HurtAddRatioA, skill_hurt_add_ratio = SkillHurtAddRatio,
        crit_hurt_add_ratio = CritHurtAddRatio, heart_hurt_add_ratio=HeartHurtAddRatio, abs_att = AbsAttA,
        exc_hurt_add_ratio = ExcHurtAddRatio, neglect_def_ratio = NeglectDefRatioA, pvp_hurt_add = PvpHurtAddA, armor = Armor} = AttrA,
    #figure{achiv_stage = AerAchivStage, god_id = GodIdA} = AerFigure,

    %% 防守方
    #battle_status{sign = DerSign, boss = DerBoss, battle_attr = BAD, figure = DerFigure, scene = SceneId} = Der,
    #battle_attr{hp = HpD, hp_lim = HpLimD, attr = AttrD, pvp_hurt_del_ratio = PvpHurtDelDRatio, skill_effect = SED} = BAD,
    #attr{
        att = AttD, wreck = WreckD,
        def = DefD, elem_def = ElemDefD, hurt_del_ratio = HurtDelRatioD,
        skill_hurt_del_ratio = SkillHurtDelRatio,
        crit_hurt_del_ratio = CritHurtDelRatio, heart_hurt_del_ratio=HeartHurtDelRatio,
        exc_hurt_del_ratio = ExcHurtDelRatio, abs_def = AbsDefD, pvp_hurt_del = PvpHurtDelD} = AttrD,
    #figure{achiv_stage = DerAchivStage} = DerFigure,
    #skill_effect{hp_lim_hurt = HpLimHurtD} = SED,

    % pvp减免自身受到的伤害
    NewPvpHurtDelD = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER, PvpHurtDelDRatio, 0),
    % 增加人物对所有怪物伤害
    NewMonHurtAdd = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_MON, MonHurtAdd, 0),
    % 伙伴对怪物的伤害
    NewMateMonHurtAdd = ?IF(AerSign==?BATTLE_SIGN_MATE andalso DerSign==?BATTLE_SIGN_MON, MateMonHurtAdd, 0),
    % 成就伤害加成
    NewAchivPvpHurtAdd = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER andalso AerAchivStage > DerAchivStage, AchivPvpHurtAdd, 0),
    % 伤害比率
    HurtRatio = max(0, 1+(HurtAddRatioA-HurtDelRatioD-NewPvpHurtDelD+NewMonHurtAdd+NewMateMonHurtAdd+NewAchivPvpHurtAdd)/?RATIO_COEFFICIENT),
    % 技能伤害比率
    TotalSHurtRatio = max(0, (SkillHurtAddRatio-SkillHurtDelRatio)/?RATIO_COEFFICIENT),
    % 随机比率
    RandRatio = urand:rand(9500, 10500)/?RATIO_COEFFICIENT,
    % 总比率
    TotalRatio = max(0.2, HurtRatio*TotalSHurtRatio)*RandRatio,
    % 元素伤害
    ElemHurt = max(ElemAttA-ElemDefD, 0),
    % 固定伤害
    BaseFixHurt = ElemHurt,
    % 基础伤害值计算公式
    BaseHurt = if
        WreckA >= DefD -> (AttA+WreckA-DefD*(1-NeglectDefRatioA/?RATIO_COEFFICIENT))*TotalRatio+BaseFixHurt;
        true -> AttA*(0.5 + 0.5*max(1, WreckA)/max(1, DefD*(1-NeglectDefRatioA/?RATIO_COEFFICIENT)))*TotalRatio+BaseFixHurt
    end,
    % 无视伤害
    AbsHurt = AbsAttA-AbsDefD,
    CritHurt = max(1, BaseHurt*(2+max(0, (CritHurtAddRatio-CritHurtDelRatio))/?RATIO_COEFFICIENT)+AbsHurt),
    ExcHurt = max(1, BaseHurt*(1+0.5*max(1, 1+(ExcHurtAddRatio-ExcHurtDelRatio)/?RATIO_COEFFICIENT))+AbsHurt),
    HeartHurt = BaseHurt*max(1, 1+(HeartHurtAddRatio-HeartHurtDelRatio)/?RATIO_COEFFICIENT)*0.2,

    % 伤害类型伤害值
    TypeHurt = if
        HurtType == ?HURT_TYPE_HEART -> HeartHurt+BaseHurt;
        HurtType == ?HURT_TYPE_CRIT -> CritHurt;
        HurtType == ?HURT_TYPE_EXC -> ExcHurt;
        HurtType == ?HURT_TYPE_CRIT_HEART -> CritHurt+HeartHurt;
        HurtType == ?HURT_TYPE_EXC_HEART -> ExcHurt+HeartHurt;
        true -> BaseHurt
    end,

    HurtAfBuff = TypeHurt*Float + Int,

    % 格挡
    HurtAfParry = ?IF(SecHurtType == ?HURT_TYPE_PARRY, HurtAfBuff*0.5, HurtAfBuff),

    RAerSign = lib_battle:calc_real_sign(AerSign),
    % 护甲
    HurtAfArmor = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER,
        HurtAfParry*(1-(Armor/(Armor+100)*0.3/?RATIO_COEFFICIENT))*0.6,
        HurtAfParry),
    % boss碾压伤害
    HurtAfBossCrush = mod_battle:calc_boss_crush_hurt(SceneId, RAerSign, DerSign, AerBoss, DerBoss, AerFigure#figure.lv, DerFigure#figure.lv, HurtAfArmor),
    % 降神伤害:对怪物增加100%的伤害
    HurtAfGod = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_MON andalso GodIdA > 0, HurtAfBossCrush*2, HurtAfBossCrush),
    % pvp溅射
    HurtAfSputter = mod_battle:calc_sputter(AerSign, DerSign, SceneId, PvpNo, HurtAfGod),
    % 伤害平衡
    HurtAfBalance = mod_battle:calc_hurt_balance(AerSign, DerSign, AttA, AttD, WreckA, WreckD, HurtAfSputter),
    % 固定伤害(pvp)
    PvpHurt = PvpHurtAddA - PvpHurtDelD,
    HurtAfPvp = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER, max(0, HurtAfBalance + PvpHurt), HurtAfBalance),

    % 血量上限最大伤害比例
    HurtAfHpLim = mod_battle:calc_hp_lim_hurt(AerSign, DerSign, HpLimD, HpLimHurtD, HurtAfPvp),

    % 龙语伤害
    {HurtAfDragon, LastMaxHurt} = lib_dragon_language_boss:calc_hurt(Aer, Der, HurtAfHpLim, MaxHurt),
    % 真实的伤害
    RealHurt = max(0, trunc(HurtAfDragon)),
    % 限制的伤害
    case is_integer(LastMaxHurt) of
        true -> HurtAfMax = min(HurtAfDragon, LastMaxHurt);
        false -> HurtAfMax = HurtAfDragon
    end,
    LastHurt = max(0, trunc(HurtAfMax)),
    {max(0, HpD - LastHurt), min(HpD, LastHurt), RealHurt}.




    % #battle_status{scene = SceneId} = Der,
    % #battle_attr{hp_lim = HpLimD} = Der#battle_status.battle_attr,
    % {MaxHurt, IsDelHpEachTime} = mod_battle:calc_del_hp_each_time(Der, NowTime),
    % if
    %     %% 怪物固定伤害
    %     Der#battle_status.sign == ?BATTLE_SIGN_MON andalso IsDelHpEachTime ->
    %         case Der#battle_status.del_hp_each_time of
    %             [DelHp, DelHp|_] when is_integer(DelHp)-> DelHp;
    %             [MinDelHp, MaxDelHp|_] when is_integer(MinDelHp), is_integer(MaxDelHp), MinDelHp > 0, MaxDelHp > 0 ->
    %                 DelHp = urand:rand(MinDelHp, MaxDelHp),
    %                 DelHp;
    %             [MinDelHpP, MaxDelHpP|_] when is_float(MinDelHpP), is_float(MaxDelHpP), MinDelHpP > 0, MaxDelHpP > 0 ->
    %                 MinDelHp = round(MinDelHpP*HpLimD),
    %                 MaxDelHp = round(MaxDelHpP*HpLimD),
    %                 DelHp = urand:rand(MinDelHp, MaxDelHp),
    %                 DelHp;
    %             _ ->
    %                 1
    %         end;
    %     true ->
    %         %% 攻击方
    %         #battle_status{battle_attr=BAA, sign = AerSign,
    %                    boss = AerBoss, figure = AerFigure} = Aer,
    %         #battle_attr{
    %             attr=AttrA, boss_hurt_add = BossHurtAdd, mon_hurt_add = MonHurtAdd,
    %             mate_mon_hurt_add = MateMonHurtAdd, achiv_pvp_hurt_add = AchivPvpHurtAdd} = BAA,
    %         #attr{
    %             att = AttA, wreck = WreckA, elem_att = ElemAttA,
    %             hurt_add_ratio = HurtAddRatioA, skill_hurt_add_ratio = SkillHurtAddRatio,
    %             ay_wreck = AyWreckA, ss_wreck = SsWreckA, hd_wreck = HdWreckA,
    %             ss_def = SsDefA, hd_def = HdDefA, ay_def = AyDefA,
    %             neglect = NeglectA, abs_att = AbsAttA} = AttrA,
    %         #figure{achiv_stage = AerAchivStage, god_id = GodIdA} = AerFigure,

    %         %% 防守方
    %         #battle_status{sign = DerSign, boss = DerBoss, battle_attr = BAD, figure = DerFigure} = Der,
    %         #battle_attr{attr = AttrD, pvpe_hurt_del = PeHurtDelD, pvp_hurt_del = PvpHurtDelD, skill_effect = SED} = BAD,
    %         #attr{
    %             att = AttD, wreck = WreckD,
    %             def = DefD, elem_def = ElemDefD, hurt_del_ratio = HurtDelRatioD,
    %             skill_hurt_del_ratio = SkillHurtDelRatio,
    %             ay_wreck = AyWreckD, ay_def = AyDefD, ss_wreck = SsWreckD,
    %             ss_def = SsDefD, hd_wreck = HdWreckD, hd_def = HdDefD,
    %             parry = ParryD, parry_ratio = _ParryRatioD,
    %             abs_def = AbsDefD} = AttrD,
    %         #figure{achiv_stage = DerAchivStage} = DerFigure,
    %         #skill_effect{hp_lim_hurt = HpLimHurtD} = SED,

    %         % 保底防止伤害减免过大导致没有伤害
    %         HurtRatio = max(0.2, (SkillHurtAddRatio-SkillHurtDelRatio)/?RATIO_COEFFICIENT),

    %         RAerSign = lib_battle:calc_real_sign(AerSign),

    %         %% 绝对伤害
    %         ExtrHurt = max(ElemAttA-ElemDefD, 0),
    %         %% 特殊被动伤害减免万分比(PvE,PvP)
    %         PVPEDel = if
    %             RAerSign==?BATTLE_SIGN_PLAYER -> PeHurtDelD*2;
    %             true-> PeHurtDelD
    %         end,
    %         %% pvp减免自身受到的伤害
    %         NewPvpHurtDelD = if
    %             AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER -> PvpHurtDelD;
    %             true -> 0
    %         end,
    %         %% 增加人物对所有怪物伤害
    %         NewMonHurtAdd = if
    %             AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_MON -> MonHurtAdd;
    %             true -> 0
    %         end,
    %         %% 伙伴对怪物的伤害
    %         NewMateMonHurtAdd = if
    %             AerSign==?BATTLE_SIGN_MATE andalso DerSign==?BATTLE_SIGN_MON -> MateMonHurtAdd;
    %             true -> 0
    %         end,
    %         %% boss伤害加成
    %         NewBossHurtAdd = if
    %             AerSign==?BATTLE_SIGN_PLAYER andalso
    %             (DerBoss == ?MON_LOCAL_BOSS orelse DerBoss == ?MON_CLUSTER_BOSS orelse
    %                 DerBoss == ?MON_ACTIVE_BOSS orelse DerBoss == ?MON_DUN_BOSS orelse
    %                 DerBoss == ?MON_TASK_BOSS)-> BossHurtAdd;
    %             true -> 0
    %         end,
    %         %% 成就伤害加成
    %         NewAchivPvpHurtAdd = if
    %             AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER andalso AerAchivStage > DerAchivStage -> AchivPvpHurtAdd;
    %             true -> 0
    %         end,
    %         %% 伤害比率
    %         R = max(0.1, (1+(
    %             HurtAddRatioA*(1-ParryD/?RATIO_COEFFICIENT)-
    %             HurtDelRatioD*(1-NeglectA/?RATIO_COEFFICIENT)-
    %             PVPEDel-NewPvpHurtDelD+NewMonHurtAdd+NewMateMonHurtAdd+NewBossHurtAdd+NewAchivPvpHurtAdd)/?RATIO_COEFFICIENT)),

    %         %% 基础伤害值计算公式
    %         BaseHurt = if
    %             WreckA>=DefD-> (AttA+WreckA-DefD)*R+ExtrHurt;
    %             true-> %% A = 0.5, B = (1-A)
    %                 (AttA*(0.5 + 0.5*max(WreckA,1)/DefD))*R+ExtrHurt
    %         end,
    %         %% 倍率伤害
    %         Hurt = if
    %             RAerSign==?BATTLE_SIGN_PLAYER -> BaseHurt*HurtRatio;
    %             true-> BaseHurt
    %         end,
    %         %% 伤害类型伤害值
    %         TypeHurt = Hurt * (urand:rand(-100, 100)+1000)/1000,
    %         %% buff的伤害
    %         HurtAfBuff = TypeHurt*Float + Int,

    %         %% 绝对伤害
    %         AbsHurt = max(HurtAfBuff + AbsAttA - AbsDefD, 1),

    %         %% 圣印伤害值
    %         HolySealHurt = if
    %             RAerSign =:= ?BATTLE_SIGN_MON andalso (AyWreckA > 0 orelse SsWreckA > 0 orelse HdWreckA > 0 orelse AyDefA > 0 orelse SsDefA > 0 orelse HdDefA > 0)
    %             orelse DerSign =:= ?BATTLE_SIGN_MON andalso (AyWreckD > 0 orelse SsWreckD > 0 orelse HdWreckD > 0 orelse AyDefD > 0 orelse SsDefD > 0 orelse HdDefD > 0) ->
    %                 CTR = min((AyWreckA+1)/(AyDefD+1),1) * min((SsWreckA+1)/(SsDefD+1),1) * min((HdWreckA+1)/(HdDefD+1),1),
    %                 trunc(AbsHurt * CTR);
    %             true ->
    %                 AbsHurt
    %         end,
    %         %% 格挡几率
    %         HurtAfParry = HolySealHurt,

    %         %% 特殊boss类型的减伤和加伤：根据等级条件
    %         case data_scene:get(SceneId) of
    %             #ets_scene{type = SceneType} -> skip;
    %             _ -> SceneType = 0
    %         end,
    %         if
    %             SceneType == ?SCENE_TYPE_SANCTUM andalso DerBoss == ?MON_CLUSTER_BOSS -> %% ?MON_SYS_BOSS_TYPE_SANCTUM
    %                 HurtAfLvHurt = HurtAfParry;
    %             DerSign == ?BATTLE_SIGN_MON andalso RAerSign == ?BATTLE_SIGN_PLAYER andalso
    %             (DerBoss == ?MON_LOCAL_BOSS orelse DerBoss == ?MON_CLUSTER_BOSS) ->
    %                 SpanLv = AerFigure#figure.lv - DerFigure#figure.lv,
    %                 BossType = mod_battle:calc_boss_type(SceneId, DerBoss, SpanLv),
    %                 case data_mon_type:get_lv_hurt(DerBoss, BossType, SpanLv) of
    %                     #mon_type_lv_hurt{role_add_hurt = RoleLvAddHurt} ->
    %                         HurtAfLvHurt = trunc(HurtAfParry*(1 + RoleLvAddHurt));
    %                     _R ->
    %                         HurtAfLvHurt = HurtAfParry
    %                 end;

    %             RAerSign == ?BATTLE_SIGN_MON andalso DerSign == ?BATTLE_SIGN_PLAYER andalso
    %             (AerBoss == ?MON_LOCAL_BOSS orelse AerBoss == ?MON_CLUSTER_BOSS)->
    %                 SpanLv = DerFigure#figure.lv - AerFigure#figure.lv,
    %                 BossType = mod_battle:calc_boss_type(SceneId, AerBoss, SpanLv),
    %                 case data_mon_type:get_lv_hurt(AerBoss, BossType, SpanLv) of
    %                     #mon_type_lv_hurt{mon_add_hurt = MonLvAddHurt} ->
    %                         HurtAfLvHurt = trunc(HurtAfParry*(1 + MonLvAddHurt));
    %                     _R ->
    %                         HurtAfLvHurt = HurtAfParry
    %                 end;
    %             true ->
    %                 HurtAfLvHurt = HurtAfParry
    %         end,
    %         % 降神伤害
    %         HurtAfGod = if
    %             % 降神对怪物增加100%的伤害
    %             AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_MON andalso GodIdA > 0 -> HurtAfLvHurt*2;
    %             true -> HurtAfLvHurt
    %         end,
    %         % 伤害平衡
    %         HurtAfBalance = if
    %             % pvp生效
    %             AerSign=/=?BATTLE_SIGN_PLAYER orelse DerSign=/=?BATTLE_SIGN_PLAYER -> HurtAfGod;
    %             % 攻击者的攻击和破甲大于防守者,衰减
    %             (AttD+WreckD) =/= 0 andalso (AttA+WreckA) >= (AttD+WreckD)*1.1 ->
    %                 % 平衡系数
    %                 BalanceR = (AttA+WreckA) / (AttD+WreckD),
    %                 if
    %                     BalanceR < 1.1 -> HurtAfGod;
    %                     % 0.5-0.5/(DecayR-0.1) 不会是负数,但是防止上面的参数变化[(AttA+WreckA) >= (AttD+WreckD)*1.1]导致负数容错一下
    %                     true -> max(0, HurtAfGod*(1-(0.8-0.8/(BalanceR-0.1))))
    %                 end;
    %             % 防守者的攻击和破甲大于攻击者,增伤
    %             (AttA+WreckA) =/= 0 andalso (AttD+WreckD) >= (AttA+WreckA)*1.1 ->
    %                 % 平衡系数
    %                 BalanceR = (AttD+WreckD) / (AttA+WreckA),
    %                 if
    %                     BalanceR < 1.1 -> HurtAfGod;
    %                     true -> max(0, HurtAfGod*(1+(0.8-0.8/(BalanceR-0.1))))
    %                 end;
    %             true ->
    %                 HurtAfGod
    %         end,

    %         % 血量上限最大伤害比例
    %         HurtAfHpLim = if
    %             AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER ->
    %                 % 最大伤害值=Int+血量上限*Float
    %                 case HpLimHurtD of
    %                     {0, 0} -> HurtAfBalance;
    %                     {HpLimHurtDInt, HpLimHurtDFloat} -> min(HurtAfBalance, HpLimHurtDInt+HpLimD*HpLimHurtDFloat);
    %                     _ -> HurtAfBalance
    %                 end;
    %             true ->
    %                 HurtAfBalance
    %         end,
    %         % 龙语伤害限制
    %         {HurtAfDragon, LastMaxHurt} = lib_dragon_language_boss:calc_hurt(Aer, Der, HurtAfHpLim, MaxHurt),
    %         % 限制的伤害
    %         case is_integer(LastMaxHurt) of
    %             true -> HurtAfMax = min(HurtAfDragon, LastMaxHurt);
    %             false -> HurtAfMax = HurtAfDragon
    %         end,
    %         LastHurt = trunc(HurtAfMax),
    %         LastHurt
    % end.

%% 发送血量变换
send_hp_change_to_12036(Sign, CopyId, X, Y, Broadcast, BinData) ->
    if
        % 只有部分才通知
        Sign == ?BATTLE_SIGN_PLAYER orelse Sign == ?BATTLE_SIGN_MON orelse Sign == ?BATTLE_SIGN_DUMMY ->
            lib_battle:send_to_scene(CopyId, X, Y, Broadcast, BinData);
        true ->
            skip
    end,
    ok.

%% 主动技能连技选择攻击参数角度
%% NOTE: 辅助技能目前没有目标，AttTarget 要特殊处理一下
combo_active_battle_set_args_radian(AttTarget, SelfX, SelfY, ComboArgs) ->
    {OX, OY, X, Y, SkillId, SkillLv, _IsReFindT, BulletDis, OldRadian} = ComboArgs,
    case data_skill:get(SkillId, SkillLv) of
        #skill{type=?SKILL_TYPE_ACTIVE, is_combo=1, refind_target=IsReFindT, mod=Mod,
            bullet_spd=BulletSpd, bullet_att_time=BulletAttTime, lv_data=#skill_lv{distance=Dis}
        } = SkillR ->
            if
                Mod == ?SKILL_MOD_SINGLE ->
                    Args = case AttTarget of
                        #{sign:=TSign, id:=Tid} -> {target, TSign, Tid};
                        _ -> {xy, OX, OY, X, Y}
                    end,
                    Radian = OldRadian;
                IsReFindT == 1 ->
                    Args = case AttTarget of
                        #{sign:=TSign, id:=Tid} -> {target, TSign, Tid};
                        _ -> {xy, SelfX, SelfY, X, Y}
                    end,
                    Radian = 0;
                BulletDis == 0 andalso BulletSpd > 0 andalso BulletAttTime > 0->
                    Count = max( 1, util:ceil(Dis*1000/(BulletSpd*BulletAttTime)) ),
                    EathDis = util:ceil(Dis/Count),
                    Args = {xy, OX, OY, X, Y, EathDis},
                    Radian = OldRadian;
                BulletDis > 0 ->
                    %% Radian = math:atan2(Y-OY, X-OX),
                    Args = {xy, round(OX+BulletDis*math:cos(OldRadian)), round(OY+BulletDis*math:sin(OldRadian)), X, Y, BulletDis},
                    Radian = OldRadian;
                true ->
                    Args = {xy, OX, OY, X, Y},
                    Radian = OldRadian
            end,
            {SkillR, Args, Radian};
        #skill{type=?SKILL_TYPE_ASSIST, is_combo=1} = SkillR ->
            {SkillR, combo};
        _ -> false
    end.
