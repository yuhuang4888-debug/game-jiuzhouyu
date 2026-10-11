%%%-----------------------------------
%%% @Module  : lib_skill_buff
%%% @Author  : zzm
%%% @Created : 2014.04.29
%%% @Description: 技能Buff
%%%-----------------------------------
-module(lib_skill_buff).
-compile(export_all).

-include("common.hrl").
-include("attr.hrl").
-include("skill.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_fun.hrl").

-define(DELAY_DEL_BUFF_TIME, 0).

%% 打包buff发送给客户端显示
pack_buff([{K, SkillId, _, SkillLv, Stack, Int, Float, T, EffectId, _}|TB], NowTime, Buff) ->
    LeftTime =  T - NowTime,
    case LeftTime > 0 of
        false -> pack_buff(TB, NowTime, Buff);
        true  ->
            Float1 = round(Float * 1000),
            NewBuff = [<<K:16, EffectId:16, SkillId:32, SkillLv:8, Stack:8, Int:32/signed, Float1:32/signed, T:64>>|Buff],
            pack_buff(TB, NowTime, NewBuff)
    end;
pack_buff([], _NowTime, Buff) ->
    L = length(Buff),
    Data = list_to_binary(Buff),
    <<L:16, Data/binary>>;
pack_buff([_|TB], NowTime, Buff) -> pack_buff(TB, NowTime, Buff).

unpack_buff(Bin) ->
    <<Len:16, Bin1/binary>> = Bin,
    unpack_buff(0, Len, Bin1, []).

unpack_buff(Len, Len, Bin, BuffList) -> {BuffList, Bin};
unpack_buff(Index, Len, Bin, BuffList) ->
    <<K:16, EffectId:16, SkillId:32, SkillLv:8, Stack:8, Int:32/signed, Float1:32/signed, T:64, Bin1/binary>> = Bin,
    Buf = {K, SkillId, {K, SkillId}, SkillLv, Stack, Int, Float1/1000, T, EffectId, 0},
    unpack_buff(Index+1, Len, Bin1, [Buf|BuffList]).

%% 设置连击buff
set_combo_buff(OtherBuffList, MainSkillId, MainSkillLv, EndTime) ->
    [{?SPBUFF_COMBO, MainSkillId, {?SPBUFF_COMBO, MainSkillId}, MainSkillLv, 0, 0, 0, EndTime, 0, 0}|lists:keydelete(?SPBUFF_COMBO, 1, OtherBuffList)].

del_combo_buff(OtherBuffList, MainSkillId) ->
    lists:keydelete({?SPBUFF_COMBO, MainSkillId}, 3, OtherBuffList).

del_all_combo_buff([{?SPBUFF_COMBO, _, _, _, _, _, _, _, _, _}|T], Result) ->
    del_all_combo_buff(T, Result);
del_all_combo_buff([H|T], Result) ->
    del_all_combo_buff(T, [H|Result]);
del_all_combo_buff([], Result) -> Result.

%% 添加buff
add_buff(#player_status{id=Id, scene=SceneId, scene_pool_id=ScenePoolId} = Player, SkillId, SkillLv) ->
    mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_skill_buff, add_buff, [Id, SkillId, SkillLv]),
    {ok, Player}.

add_buff(Id, SkillId, SkillLv, EtsScene) when is_integer(Id) ->
    case lib_scene_agent:get_user(Id) of
        #ets_scene_user{} = User ->
            User1 = add_buff(User, SkillId, SkillLv, EtsScene),
            lib_scene_agent:put_user(User1);
        _ -> skip
    end;

add_buff(User, SkillId, SkillLv, EtsScene) ->
    case mod_battle:assist(User, User, server, SkillId, SkillLv, EtsScene) of
        {false, _ErrCode, _Aer} -> User;
        {true, Aer, _MainSkillId} -> Aer
    end.

object_add_buff(MonId, SkillId, SkillLv, EtsScene) ->
    case lib_scene_object_agent:get_object(MonId) of
        #scene_object{} = Obj ->
            Obj1 = add_buff(Obj, SkillId, SkillLv, EtsScene),
            lib_scene_object_agent:put_object(Obj1);
        _ -> skip
    end.

mon_add_buff(SceneId, ScenePoolId, CopyId, Mid, SkillId, SkillLv) ->
    mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_skill_buff, mon_add_buff_in_scene_pro, [CopyId, Mid, SkillId, SkillLv]).

mon_add_buff_in_scene_pro(CopyId, Mid, SkillId, SkillLv, EtsScene) ->
    case lib_scene_object_agent:get_scene_mon_by_mids(CopyId, [Mid], all) of
        MonList when MonList =/= [] ->
            F = fun(MonObject) ->
                case MonObject of
                    #scene_object{id = Id} -> object_add_buff(Id, SkillId, SkillLv, EtsScene);
                    _ -> skip
                end
            end,
            lists:foreach(F, MonList);
        _ ->
            skip
    end.

add_buff(BuffList, K, BuffType, SkillId, SkillLv, Stack, Int, Float, LastTime, EffectId, AttrId, NowTime) ->
    {_, BuffList1} = calc_buff_swap(K, BuffType, Int, Float, LastTime, Stack, EffectId, AttrId, SkillId, SkillLv, NowTime, BuffList),
    BuffList1.

%% 清理buff
%% param SkillId | [SkillId,....]
clean_buff(#player_status{id=Id, scene=SceneId, scene_pool_id=ScenePoolId} = Player, SkillId) ->
    clean_buff(SceneId, ScenePoolId, Id, SkillId),
    {ok, Player}.

clean_buff(SceneId, ScenePoolId, RoleId, SkillId) ->
    mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_skill_buff, clean_buff, [RoleId, SkillId]),
    ok.

%% 清理技能buff
clean_buff(BattleInfo, SkillId, EtsScene) when is_integer(SkillId) ->
    do_clean_buff(BattleInfo, [SkillId], EtsScene);
clean_buff(BattleInfo, SkillIdList, EtsScene) ->
    do_clean_buff(BattleInfo, SkillIdList, EtsScene).

do_clean_buff(_BattleInfo, [], _EtsScene) -> skip;
do_clean_buff(Id, SkillIdL, EtsScene) when is_integer(Id) ->
    case lib_scene_agent:get_user(Id) of
        #ets_scene_user{} = User ->
            User1 = do_clean_buff(User, SkillIdL, EtsScene),
            lib_scene_agent:put_user(User1),
            ok;
        _ -> skip
    end;

do_clean_buff(#ets_scene_user{id = Id, node = Node, pid = Pid, battle_attr=BA, copy_id = CopyId, x = X, y = Y}=User, SkillIdL, EtsScene) ->
    {Result1, AttrBuffList} = clean_buff_helper(BA#battle_attr.attr_buff_list, SkillIdL, [], []),
    {Result2, OtherBuffList} = clean_buff_helper(BA#battle_attr.other_buff_list, SkillIdL, Result1, []),
    mod_battle:send_to_node_pid(Node, Pid, {'buff', AttrBuffList, OtherBuffList}),
    UserAfCalc = calc_buff_when_clean(Result2, User#ets_scene_user{battle_attr=BA#battle_attr{attr_buff_list=AttrBuffList, other_buff_list=OtherBuffList}}, EtsScene),
    % ?MYLOG("hjhbuff", "do_clean_buff SkillIdL:~p OldBuffList:~p OtherBuffList:~p　~n", [SkillIdL, BA#battle_attr.other_buff_list, OtherBuffList]),
    {ok, BinData} = pt_200:write(20007, [?BATTLE_SIGN_PLAYER, Id, Result2]),
    lib_battle:send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
    UserAfCalc;

do_clean_buff(#scene_object{id = Id, sign = Sign, battle_attr=BA, copy_id = CopyId, x = X, y = Y}=Obj, SkillIdL, EtsScene) ->
    {Result1, AttrBuffList} = clean_buff_helper(BA#battle_attr.attr_buff_list, SkillIdL, [], []),
    {Result2, OtherBuffList} = clean_buff_helper(BA#battle_attr.other_buff_list, SkillIdL, Result1, []),
    ObjAfCalc = calc_buff_when_clean(Result2, Obj#scene_object{battle_attr=BA#battle_attr{attr_buff_list=AttrBuffList, other_buff_list=OtherBuffList}}, EtsScene),
    {ok, BinData} = pt_200:write(20007, [Sign, Id, Result2]),
    lib_battle:send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
    ObjAfCalc.

object_clean_buff(MonId, SkillId, EtsScene) ->
    case lib_scene_object_agent:get_object(MonId) of
        #scene_object{} = Obj ->
            Obj1 = clean_buff(Obj, SkillId, EtsScene),
            lib_scene_object_agent:put_object(Obj1);
        _ -> skip
    end.

mon_clean_buff(SceneId, ScenePoolId, CopyId, Mid, SkillId) ->
    mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_skill_buff, mon_clean_buff_in_scene_pro, [CopyId, Mid, SkillId]).

mon_clean_buff_in_scene_pro(CopyId, Mid, SkillId, EtsScene) ->
    case lib_scene_object_agent:get_scene_mon_by_mids(CopyId, [Mid], all) of
        MonList when MonList =/= [] ->
            F = fun(MonObject) ->
                case MonObject of
                    #scene_object{} ->
                        NewMonObject = clean_buff(MonObject, SkillId, EtsScene),
                        lib_scene_object_agent:save_scene_object(NewMonObject);
                    _ ->
                        skip
                end
            end,
            lists:foreach(F, MonList);
        _ ->
            skip
    end.

%% 清理buff递归函数
clean_buff_helper([{K, SkillId, _, _, _, _, _, _, _, _}=H|T], SkillIdL, Dels, Buffs) ->
    case lists:member(SkillId, SkillIdL) of
        true -> clean_buff_helper(T, SkillIdL, [{K, SkillId}|Dels], Buffs);
        false -> clean_buff_helper(T, SkillIdL, Dels, [H|Buffs])
    end;
clean_buff_helper([H|T], SkillIdL, Dels, Buffs) ->
    clean_buff_helper(T, SkillIdL, Dels, [H|Buffs]);
clean_buff_helper([], _SkillIdL, Dels, Buffs) ->
    {Dels, Buffs}.

calc_buff_when_clean([{K, _SkillId}|T], #ets_scene_user{id=Id, copy_id=CopyId, x=X, y=Y, battle_attr=BA} = User, EtsScene) ->
    User1 = case K of
        ?SPEED ->
            NowTime = utime:longunixtime(),
            [Float, Int] = lib_skill_buff:calc_speed_helper(BA#battle_attr.attr_buff_list, NowTime, [1.0, 0]),
            Speed = round(BA#battle_attr.speed * Float+Int),
            {ok, BinData} = pt_120:write(12082, [?BATTLE_SIGN_PLAYER, Id, Speed]),
            lib_battle:send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
            User#ets_scene_user{battle_attr=BA#battle_attr{speed=Speed}};
        ?SPBUFF_SHIELD ->
            User#ets_scene_user{battle_attr=BA#battle_attr{shield_hp=0}};
        _ ->
            User
    end,
    calc_buff_when_clean(T, User1, EtsScene);
calc_buff_when_clean([{K, _SkillId}|T], #scene_object{id=Id, copy_id=CopyId, x=X, y=Y, battle_attr=BA, sign = Sign} = Obj, EtsScene) ->
    Obj1 = case K of
        ?SPEED ->
            NowTime = utime:longunixtime(),
            [Float, Int] = lib_skill_buff:calc_speed_helper(BA#battle_attr.attr_buff_list, NowTime, [1.0, 0]),
            Speed = round(BA#battle_attr.speed * Float+Int),
            {ok, BinData} = pt_120:write(12082, [Sign, Id, Speed]),
            lib_battle:send_to_scene(CopyId, X, Y, EtsScene#ets_scene.broadcast, BinData),
            Obj#scene_object{battle_attr=BA#battle_attr{speed=Speed}};
        ?SPBUFF_SHIELD ->
            Obj#scene_object{battle_attr=BA#battle_attr{shield_hp=0}};
        _ ->
            Obj
    end,
    calc_buff_when_clean(T, Obj1, EtsScene);
calc_buff_when_clean([], UserOrObj, _) -> UserOrObj.

%% 判断是否有不能移动的buff
is_can_move(_, 0, _) -> false;
is_can_move([{K, _, _, _, _, _, _, T, _, _}|Tail], Speed, NowTime) when T+100 > NowTime ->
    if
        K == ?SPBUFF_DIZZY orelse K == ?SPBUFF_IMMOBILIZE ->
            {false, T+100-NowTime};
        true -> is_can_move(Tail, Speed, NowTime)
    end;
is_can_move([_|Tail], Speed, NowTime) -> is_can_move(Tail, Speed, NowTime);
is_can_move([], _, _) -> true.

%% 判断是否有不能攻击的buff
%% @param IsNormal 是否普攻
is_can_attack([{K, _, _, _, _, _, _, T, _, _}|Tail], IsNormal, NowTime) when T+100 > NowTime ->
    if
        K == ?SPBUFF_DIZZY -> {false, K, T+100-NowTime};
        % 沉默下能释放普攻
        K == ?SPBUFF_SILENCE andalso IsNormal == 0 -> {false, K, T+100-NowTime};
        true -> is_can_attack(Tail, IsNormal, NowTime)
    end;
is_can_attack([_|Tail], IsNormal, NowTime) -> is_can_attack(Tail, IsNormal, NowTime);
is_can_attack([], _IsNormal, _) -> true.

%% 判断是否可浮空
%% is_airborne([{?SPBUFF_AIRBORNE, _, _, _, _, _, _, _, _, _}|_]) -> true;
%% is_airborne([_|Tail]) -> is_airborne(Tail);
%% is_airborne([]) -> false.

%% 是否有攻击buff
%% is_buff_att([{?SPBUFF_ATT_TIMES, _, _, _, _, Int, Float, T, _, AttrId}|_], NowTime)
%%   when T >= NowTime -> {true, AttrId, trunc(Float*1000), Int};
%% is_buff_att([_|Tail], NowTime) -> is_buff_att(Tail, NowTime);
is_buff_att(_, _) -> false.

assist_clean_timeout_buff([{_K, _SkillId, _, _SkillLv, _Stack, _Int, _Float, T, _EffectId, _}|TB], NowTime, Buff)
  when T >= NowTime+?DELAY_DEL_BUFF_TIME ->
    assist_clean_timeout_buff(TB, NowTime, Buff);
assist_clean_timeout_buff([E|TB], NowTime, Buff) ->
    assist_clean_timeout_buff(TB, NowTime, [E|Buff]);
assist_clean_timeout_buff([], _NowTime, Buff) -> Buff.

%% 过滤辅助技能作用方
filter_assist(#skill{lv_data = #skill_lv{trigger_cond = []}}, Assisters) -> Assisters;
filter_assist(#skill{lv_data = #skill_lv{trigger_cond = TriggerCond}}, Assisters) ->
    F = fun(Assister) -> filter_assist_help(TriggerCond, Assister) end,
    lists:filter(F, Assisters).

filter_assist_help([{der_sign, DerSign}|T], #battle_status{sign = DerSign} = Assister) -> filter_assist_help(T, Assister);
filter_assist_help([_H|_T], _Assister) -> false;
filter_assist_help([], _Assister) -> true.

%% 辅助技能buff处理
assist_add_attr_buff([{_K, _BuffType, _PerMil, _AffectedParties, _Int, _Float, _LastTime, _Stack, _EffectId} = H|T], User, Assisters,
        NowTime, SkillId, SkillLv, Broadcast) ->
    Assisters1 = [calc_assist_attr_effect(E, H, NowTime, SkillId, SkillLv, Broadcast) || E <- Assisters],
    assist_add_attr_buff(T, User, Assisters1, NowTime, SkillId, SkillLv, Broadcast);
assist_add_attr_buff([], _User, Assisters, _, _, _, _) -> Assisters.

calc_assist_attr_effect(User, {K, BuffType, PerMil, _AffectedParties, Int, Float, LastTime, Stack, EffectId}, NowTime, SkillId, SkillLv, Broadcast) ->
    case urand:ge_rand(1, ?SKILL_PROB_C, PerMil) andalso LastTime>0 of
        true  ->
            #battle_status{battle_attr=BA=#battle_attr{attr_buff_list=AttrBuffL}} = User,
            {IsSwap, NewAttrBuffL} = calc_buff_swap(K, BuffType, Int, Float, LastTime, Stack, EffectId, K, SkillId, SkillLv, NowTime, AttrBuffL),
            User1 = case K of
                        ?SPEED when IsSwap == true ->
                            calc_speed(User, User, NewAttrBuffL, LastTime, NowTime, Broadcast);
                        _ -> User
                    end,
            case IsSwap of
                true  -> User1#battle_status{battle_attr=BA#battle_attr{attr_buff_list=NewAttrBuffL}};
                false -> User1
            end;
        false ->
            User
    end.

%% 特殊效果
assist_add_effect_buff([H|T], User, Assisters, NowTime, SkillId, SkillLv, Broadcast) ->
    Assisters1 = [calc_assist_other_effect(User, E, H, NowTime, SkillId, SkillLv, Broadcast) || E <- Assisters],
    assist_add_effect_buff(T, User, Assisters1, NowTime, SkillId, SkillLv, Broadcast);
assist_add_effect_buff([], _User, Assisters, _, _, _, _) -> Assisters.

calc_assist_other_effect(User, Assister, {K, BuffType, PerMil, AffectedParties, Int, Float, AttrId, LastTime, Num, EffectId}=H, NowTime, SkillId, SkillLv, Broadcast) ->
    case urand:ge_rand(1, ?SKILL_PROB_C, PerMil) of
        true when LastTime > 0 ->
            #battle_status{battle_attr = BA =#battle_attr{other_buff_list=OtherBuffL}} = Assister,
            {IsSwap, OtherBuffL1} = calc_buff_swap(K, BuffType, Int, Float, LastTime, 0, EffectId, AttrId, SkillId, SkillLv, NowTime, OtherBuffL),
            case IsSwap of
                true  -> assist_calc_sp_effect(H, User, Assister#battle_status{battle_attr=BA#battle_attr{other_buff_list=OtherBuffL1}}, NowTime, Broadcast, SkillId);
                false -> Assister
            end;
        true ->
            case K of
                ?SPBUFF_CLEAN_BUFF ->
                    #battle_status{battle_attr = BA} = Assister,
                    #battle_attr{skill_effect = _SkillEffect, attr_buff_list = AttrBuffList, other_buff_list = OtherBuffList} = BA,
                    {AssisterAfAttr, NewAttrBuffList} = remove_type_buff(AttrBuffList, Assister, BuffType, []),
                    {AssisterAfOther, NewOtherBuffList} = remove_type_buff(OtherBuffList, AssisterAfAttr, BuffType, []),
                    #battle_status{battle_attr = BAAfOther} = AssisterAfOther,
                    NewBA = BAAfOther#battle_attr{attr_buff_list = NewAttrBuffList, other_buff_list = NewOtherBuffList},
                    AssisterAfOther#battle_status{battle_attr=NewBA};
                ?SPBUFF_RESUME -> %% 瞬间回血
                    #battle_status{sign = Sign, id = Id, battle_attr=#battle_attr{hp = Hp, hp_lim = HpLim, attr=Attr, skill_effect=SE}=BA, copy_id = CopyId, x=X, y=Y} = Assister,
                    if
                        % 禁止回血
                        SE#skill_effect.un_resume == 1 -> Assister;
                        true ->
                            AddHp = min(HpLim, value_cate(Int, Float, AttrId, Hp, lib_player_attr:get_value_by_id(AttrId, Attr))),
                            {ok, BinData} = pt_120:write(12009, [Id, AddHp, HpLim]),
                            lib_battle:send_to_scene(CopyId, X, Y, Broadcast, BinData),
                            %% 回血触发被动技能
                            lib_scene_timer:add_timer(NowTime, 0, Sign, Id, ?SKILL_BUFF_TRIGGER_HPRESUME, max(1, Num)),
                            Assister#battle_status{battle_attr=BA#battle_attr{hp=AddHp}}
                    end;
                ?SPBUFF_MINUS_CD ->
                    IsAffected = is_affected_parties(AffectedParties, User, Assister),
                    #battle_status{skill_cd = SkillCd, node = Node, sign = Sign, id = Id} = Assister,
                    case data_skill:get(Int, 1) of
                        #skill{lv_data = #skill_lv{cd = Cd}} when IsAffected == true ->
                            case lists:keyfind(Int, 1, SkillCd) of
                                {TmpSkillId, EndTime} when NowTime < EndTime -> 
                                    NewEndTime = max(0, umath:ceil(EndTime - Cd*Float)),
                                    RealSign = lib_battle:calc_real_sign(Sign),
                                    if
                                        RealSign == ?BATTLE_SIGN_PLAYER -> 
                                            {ok, BinData} = pt_200:write(20027, [TmpSkillId, NewEndTime]),
                                            lib_server_send:send_to_uid(Node, Id, BinData);
                                        true ->
                                            skip
                                    end,
                                    NewSkillCd = lists:keyreplace(TmpSkillId, 1, SkillCd, {TmpSkillId, NewEndTime});
                                _ -> 
                                    NewSkillCd = SkillCd
                            end;
                        _ ->
                            NewSkillCd = SkillCd
                    end,
                    Assister#battle_status{skill_cd = NewSkillCd};
                ?SPBUFF_MINUS_FIX_CD ->
                    IsAffected = is_affected_parties(AffectedParties, User, Assister),
                    #battle_status{skill_cd = SkillCd, node = Node, sign = Sign, id = Id} = Assister,
                    case data_skill:get(Int, 1) of
                        #skill{lv_data = #skill_lv{}} when IsAffected == true ->
                            case lists:keyfind(Int, 1, SkillCd) of
                                {TmpSkillId, EndTime} when NowTime < EndTime -> 
                                    NewEndTime = max(0, umath:ceil(EndTime - Float)),
                                    RealSign = lib_battle:calc_real_sign(Sign),
                                    if
                                        RealSign == ?BATTLE_SIGN_PLAYER -> 
                                            {ok, BinData} = pt_200:write(20027, [TmpSkillId, NewEndTime]),
                                            lib_server_send:send_to_uid(Node, Id, BinData);
                                        true ->
                                            skip
                                    end,
                                    NewSkillCd = lists:keyreplace(TmpSkillId, 1, SkillCd, {TmpSkillId, NewEndTime});
                                _ -> 
                                    NewSkillCd = SkillCd
                            end;
                        _ ->
                            NewSkillCd = SkillCd
                    end,
                    Assister#battle_status{skill_cd = NewSkillCd};
                _ ->
                    Assister
            end;
        false ->
            Assister
    end.

assist_calc_sp_effect({BuffKey, _BuffType, _PerMil, _AffectedParties, Int, Float, AttrId, LastTime, Num, _EffectId}, User, Assister, NowTime, _Broadcast, SkillId) ->
    case BuffKey of
        ?SPBUFF_RESUME -> %% 辅助技能回血都是定时器回血
            #battle_status{sign = Sign, id = Id, battle_attr=#battle_attr{hp_lim = HpLim, attr=Attr}} = Assister,
            Value =  min(HpLim, value_cate(Int, Float, AttrId, 0, lib_player_attr:get_value_by_id(AttrId, Attr))),
            GapTime = LastTime div max(1, Num),
            lib_scene_timer:add_timer(NowTime, 0, Sign, Id, ?SPBUFF_RESUME, {GapTime, Value, max(1, Num)}),
            Assister;
        ?SPBUFF_SHIELD -> %% 血量护盾
            #battle_status{battle_attr = #battle_attr{sec_attr=SecAttrMap} = BA} = Assister,
            NewFloat = if
                (SkillId == ?SP_SKILL_SHIELD) andalso BA#battle_attr.fire_ice_add_shield =/= 0 -> %% 施放技能6，看看被动加护盾
                    BA#battle_attr.fire_ice_add_shield/?RATIO_COEFFICIENT+Float;
                true ->
                    AddShield = lib_sec_player_attr:get_value_to_int(SecAttrMap, ?SKILL_SHIELD_HP, SkillId),
                    AddShield/?RATIO_COEFFICIENT+Float
            end,
            Value = round(Int + NewFloat*lib_player_attr:get_value_by_id(AttrId, BA#battle_attr.attr)),
            Assister#battle_status{battle_attr = BA#battle_attr{shield_hp = Value}};
        ?SPBUFF_BLEED ->
            #battle_status{id = Id, sign = Sign, battle_attr = AssisterBA, del_hp_each_time = DelHpEachTime} = Assister,
            #battle_attr{bleed_ref = BleedRefs} = AssisterBA,
            %% 面板基础属性
            if
                DelHpEachTime =/= [] -> Assister;
                true ->
                    if
                        AttrId == ?ATT orelse AttrId == ?WRECK orelse AttrId == ?ELEM_ATT -> %% 用攻击者的属性
                            Bleed = value_cate(Int, Float, AttrId, 0,
                                lib_player_attr:get_value_by_id(AttrId, User#battle_status.battle_attr#battle_attr.attr));
                        true ->
                            Bleed = value_cate(Int, Float, AttrId, 0,
                                lib_player_attr:get_value_by_id(AttrId, AssisterBA#battle_attr.attr))
                    end,
                    GapTime = LastTime div max(1, Num),
                    #battle_status{id = AtterId, sign = AttSign, figure = #figure{name = AttName}} = User,
                    BleedRef = lib_scene_timer:add_timer(NowTime, 0, Sign, Id, ?SPBUFF_BLEED,
                        {GapTime, Bleed, max(1, Num), {AtterId, AttSign, AttName}}),
                    NewBleedRefs = [BleedRef|BleedRefs],
                    Assister#battle_status{battle_attr=AssisterBA#battle_attr{bleed_ref = NewBleedRefs}}
            end;
        ?SPBUFF_TALENT_BLEED ->
            #battle_status{id = Id, sign = Sign, battle_attr = AssisterBA, del_hp_each_time = DelHpEachTime} = Assister,
            #battle_attr{bleed_ref = BleedRefs} = AssisterBA,
            %% 面板基础属性
            if
                DelHpEachTime =/= [] -> Assister;
                true ->
                    if
                        AttrId == ?ATT orelse AttrId == ?WRECK orelse AttrId == ?ELEM_ATT -> %% 用攻击者的属性
                            Bleed = value_cate(Int, Float, AttrId, 0,
                                lib_player_attr:get_value_by_id(AttrId, User#battle_status.battle_attr#battle_attr.attr));
                        true ->
                            Bleed = value_cate(Int, Float, AttrId, 0,
                                lib_player_attr:get_value_by_id(AttrId, AssisterBA#battle_attr.attr))
                    end,
                    GapTime = LastTime div max(1, Num),
                    #battle_status{id = AtterId, sign = AttSign, figure = #figure{name = AttName}} = User,
                    BleedRef = lib_scene_timer:add_timer(NowTime, 0, Sign, Id, ?SPBUFF_TALENT_BLEED,
                        {GapTime, Bleed, max(1, Num), {AtterId, AttSign, AttName}}),
                    NewBleedRefs = [BleedRef|BleedRefs],
                    Assister#battle_status{battle_attr=AssisterBA#battle_attr{bleed_ref = NewBleedRefs}}
            end;
        _ ->
            Assister
    end.

%% buff叠加/替换规则
calc_buff_swap(K, BuffType, Int, Float, LastTime, Stack, EffectId, AttrId, SkillId, SkillLv, NowTime, BuffList)
  when BuffType == ?SKILL_NORMAL_BUFF orelse BuffType == ?SKILL_BUFF orelse BuffType == ?SKILL_DEBUFF ->
    case lists:keyfind({K, SkillId}, 3, BuffList) of
        false ->
            {true, [{K, SkillId, {K, SkillId}, SkillLv, min(1, Stack), Int, Float, NowTime+LastTime, EffectId, AttrId}|BuffList]};
        {_, _, _, SkillLv0, Stack0, Int0, Float0, _, _, _} -> %% 普通叠加数替换
            if
                SkillLv0 < SkillLv -> %% 有等级更高的buff
                    {true, [{K, SkillId, {K, SkillId}, SkillLv, min(1, Stack), Int, Float, NowTime+LastTime, EffectId, AttrId}
                            | lists:keydelete({K, SkillId}, 3, BuffList)]};
                SkillLv0 == SkillLv andalso Stack > 0 andalso Stack0 < Stack  -> %% 有叠加，但是未达到最大叠加数目
                    {true, [{K, SkillId, {K, SkillId}, SkillLv0, Stack0 + 1, Int0 + Int, trunc(Float0*1000+Float*1000)/1000, NowTime+LastTime, EffectId, AttrId}
                            | lists:keydelete({K, SkillId}, 3, BuffList)]};
                SkillLv0 == SkillLv -> %% 等级相同，直接替换持续时间
                    {true, [{K, SkillId, {K, SkillId}, SkillLv0, Stack0, Int0, Float0, NowTime+LastTime, EffectId, AttrId}
                            | lists:keydelete({K, SkillId}, 3, BuffList)]};
                true ->
                    {false, BuffList}
            end
    end;
calc_buff_swap(K, BuffType, Int, Float, LastTime, _Stack, EffectId, AttrId, SkillId, SkillLv, NowTime, BuffList) ->
    case lists:keyfind(K, 1, BuffList) of
        false ->
            {true, [{K, SkillId, {K, SkillId}, SkillLv, 0, Int, Float, NowTime+LastTime, EffectId, AttrId}|BuffList]};
        {_, _, _, _, _, _, _, LastTime0, _, _} when BuffType == ?SKILL_CTRL_BUFF orelse BuffType == ?SKILL_SP_BUFF -> %% 控制buff
            if
                NowTime + LastTime > LastTime0 ->
                    {true, [{K, SkillId, {K, SkillId}, SkillLv, 0, Int, Float, NowTime+LastTime, EffectId, AttrId} | lists:keydelete({K, SkillId}, 3, BuffList)]};
                true ->
                    {false, BuffList}
            end;
        _ ->
            {false, BuffList}
    end.

%% 计算属性buff
calc_attr_last_effect([{K, _SkillId, _, _SkillLv, _Stack, Int, Float, T, _EffectId, _AttrId}=E | Tail], Time, Attr, BA, OldAttr, OldBA, CleanBuff) ->
    case T > Time of
        true ->
            %% 总属性=现在属性+基础属性的比列
            Value = value_cate(Int, Float, K, lib_player_attr:get_value_by_id(K, Attr), lib_player_attr:get_value_by_id(K, OldAttr)),
            Attr1 = lib_player_attr:set_value_by_id(K, Value, Attr),
            calc_attr_last_effect(Tail, Time, Attr1, BA, OldAttr, OldBA, [E|CleanBuff]);
        false when T+?DELAY_DEL_BUFF_TIME > Time ->
            calc_attr_last_effect(Tail, Time, Attr, BA, OldAttr, OldBA, [E|CleanBuff]);
        false ->
            calc_attr_last_effect(Tail, Time, Attr, BA, OldAttr, OldBA, CleanBuff)
    end;
calc_attr_last_effect([], _Time, Attr, BA, _OldAttr, _OldBA, CleanBuff) ->
    BA#battle_attr{attr = Attr, attr_buff_list = CleanBuff}.

%% 计算特效buff
calc_other_last_effect([{K, SkillId, _, SkillLv, Stack, Int, Float, T, EffectId, AttrId}=E | Tail], Time, MainSkillId, NowSkillId, Attr, BA, OldAttr, OldBA, CleanBuff) ->
    case T > Time of
        true ->
            SkillEff = BA#battle_attr.skill_effect,
            SkillEff1 = case K of
                ?SPBUFF_SUPERARMOR ->
                    SkillEff#skill_effect{superarmor = 1};
                ?SPBUFF_IMMUNE ->
                    SkillEff#skill_effect{immue = 1};
                ?SPBUFF_UNSPEED ->
                    SkillEff#skill_effect{un_speed = 1};
                ?SPBUFF_REBOUND ->
                    SkillEff#skill_effect{rebound = {Int, Float}};
                ?SPBUFF_BLOOD ->
                    SkillEff#skill_effect{suck_blood = {Int, Float}};
                ?SPBUFF_SHIELDS -> %% 次数盾
                    SkillEff#skill_effect{shield = true};
                ?SPBUFF_HP_LIM_HURT -> %% 血量伤害上限
                    SkillEff#skill_effect{hp_lim_hurt = {Int, Float}};
                ?SPBUFF_UNREUME ->
                    SkillEff#skill_effect{un_resume = 1};
                ?SPBUFF_BAN_GOD ->
                    SkillEff#skill_effect{ban_god = 1};
                ?SPBUFF_BAN_BLEED ->
                    SkillEff#skill_effect{ban_bleed = 1};
                ?SPBUFF_FREE_DIE ->
                    SkillEff#skill_effect{free_die = 1};
                ?SPBUFF_LOCK_HP ->
                    SkillEff#skill_effect{hp_lock = {Int, Float}};
                _ ->
                    SkillEff
            end,
            NewCleanBuff = case K of
                ?SPBUFF_SHIELDS when Int - 1 =< 0 -> CleanBuff; %% 有次数的护盾
                ?SPBUFF_SHIELDS  -> [{K, SkillId, {K, SkillId}, SkillLv, Stack, Int-1, Float, T, EffectId, AttrId}|CleanBuff];
                _ -> [E|CleanBuff]
            end,
            calc_other_last_effect(Tail, Time, MainSkillId, NowSkillId, Attr, BA#battle_attr{skill_effect=SkillEff1}, OldAttr, OldBA, NewCleanBuff);
        false when T + ?DELAY_DEL_BUFF_TIME > Time ->
            calc_other_last_effect(Tail, Time, MainSkillId, NowSkillId, Attr, BA, OldAttr, OldBA, [E|CleanBuff]);
        false ->
            case K of
                ?SPBUFF_SHIELD -> %% 血量护盾时间都做替换
                    calc_other_last_effect(Tail, Time, MainSkillId, NowSkillId, Attr, BA#battle_attr{shield_hp = 0}, OldAttr, OldBA, CleanBuff);
                _ ->
                    calc_other_last_effect(Tail, Time, MainSkillId, NowSkillId, Attr, BA, OldAttr, OldBA, CleanBuff)
            end
    end;
calc_other_last_effect([], _Time, _MainSkillId, _NowSkillId, _Attr, BA, _OldAttr, _OldBA, CleanBuff) ->
    BA#battle_attr{other_buff_list = CleanBuff}.

%% 计算属性
%% Sum是现有属性；Base是面板属性
value_cate(Int, Float, AttrId, Sum, Base) ->
    if
        AttrId == ?HURT_ADD_RATIO orelse AttrId == ?HURT_DEL_RATIO orelse
        AttrId == ?HIT_RATIO orelse AttrId == ?DODGE_RATIO  orelse
        AttrId == ?CRIT_RATIO orelse AttrId == ?UNCRIT_RATIO  orelse AttrId == ?HEART_RATIO orelse 
        AttrId == ?PVE_HURT_ADD_RATIO ->
            FloatValue = Base * Float,
            round(Sum + FloatValue + Int);
        true ->
            FloatValue = Base * Float,
            max(1, round(Sum + FloatValue + Int))
    end.

%% 重新计算效果##后续可以加条件处理,策划说填得麻烦,暂时这么处理
%% @param EffectType
%%  0:基础效果
%%  1:特殊效果
%% @param ReplaceType
%%  0:替换
%%  1:增加
recalc_effect([], _Aer, _Der, AttrList, EffectList) -> {AttrList, EffectList};
recalc_effect([{?SPBUFF_BAN_GOD_TRIGGER, EffectType, ReplaceType, NewEffectL}|T], Aer, Der, AttrList, EffectList) ->
    #battle_status{battle_attr = #battle_attr{other_buff_list = OtherBuffList}} = Aer,
    case lists:keymember(?SPBUFF_BAN_GOD, 1, OtherBuffList) of
        true -> 
            if
                EffectType == 0 andalso ReplaceType == 0 -> recalc_effect(T, Aer, Der, NewEffectL, EffectList);
                EffectType == 0 andalso ReplaceType == 1 -> recalc_effect(T, Aer, Der, NewEffectL++AttrList, EffectList);
                EffectType == 1 andalso ReplaceType == 0 -> recalc_effect(T, Aer, Der, AttrList, NewEffectL);
                EffectType == 1 andalso ReplaceType == 1 -> recalc_effect(T, Aer, Der, AttrList, NewEffectL++EffectList);
                true -> recalc_effect(T, Aer, Der, AttrList, EffectList)
            end;
        false ->
            recalc_effect(T, Aer, Der, AttrList, EffectList)
    end;
recalc_effect([{?SPBUFF_BAN_BLEED_TRIGGER, EffectType, ReplaceType, NewEffectL}|T], Aer, Der, AttrList, EffectList) ->
    #battle_status{battle_attr = #battle_attr{other_buff_list = OtherBuffList}} = Der,
    case lists:keymember(?SPBUFF_BAN_BLEED, 1, OtherBuffList) of
        true -> 
            if
                EffectType == 0 andalso ReplaceType == 0 -> recalc_effect(T, Aer, Der, NewEffectL, EffectList);
                EffectType == 0 andalso ReplaceType == 1 -> recalc_effect(T, Aer, Der, NewEffectL++AttrList, EffectList);
                EffectType == 1 andalso ReplaceType == 0 -> recalc_effect(T, Aer, Der, AttrList, NewEffectL);
                EffectType == 1 andalso ReplaceType == 1 -> recalc_effect(T, Aer, Der, AttrList, NewEffectL++EffectList);
                true -> recalc_effect(T, Aer, Der, AttrList, EffectList)
            end;
        false ->
            recalc_effect(T, Aer, Der, AttrList, EffectList)
    end;
recalc_effect([_H|T], Aer, Der, AttrList, EffectList) ->
    recalc_effect(T, Aer, Der, AttrList, EffectList).


%% 持续时间和叠加层数
calc_active_attr_effect([{K, BuffType, PerMil, AffectedParties, Int, Float, LastTime, Stack, EffectId}|T],
        Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, Broadcast) ->
    case urand:ge_rand(1, ?SKILL_PROB_C, PerMil) of
        true ->
            {User, UserBuffL, OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffList, Der, DerBuffList, OldAer, OldDer),
            case check_active_buff_effect_trigger(K, User, Trigger) of
                false ->
                    calc_active_attr_effect(T, Trigger, Aer, Der,  AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, Broadcast);
                true ->
                    {User2, UserBuffL2} = case K of
                    ?SPEED ->
                        case calc_buff_swap(K, BuffType, Int, Float, LastTime, Stack, EffectId, K, SkillId, SkillLv, NowTime, UserBuffL) of
                            {true, BuffList} ->
                                {calc_speed(User, OldUser, OldUser#battle_status.battle_attr#battle_attr.other_buff_list++BuffList, LastTime, NowTime, Broadcast), BuffList};
                            {false, _} ->
                                {User, UserBuffL}
                        end;
                     _ ->
                        UserBA = User#battle_status.battle_attr,
                        Value = value_cate(Int, Float, K, lib_player_attr:get_value_by_id(K, UserBA#battle_attr.attr),
                                           lib_player_attr:get_value_by_id(K, OldUser#battle_status.battle_attr#battle_attr.attr)),
                        Attr1 = lib_player_attr:set_value_by_id(K, Value, UserBA#battle_attr.attr),
                        User1 = User#battle_status{battle_attr=UserBA#battle_attr{attr=Attr1}},
                        case LastTime =< 0 of
                            true  -> {User1, UserBuffL};
                            false -> {_, TmpBuffL} = calc_buff_swap(K, BuffType, Int, Float, LastTime, Stack, EffectId, K, SkillId, SkillLv, NowTime, UserBuffL),
                                     {User1, TmpBuffL}
                        end
                    end,
                    {Aer2, AerBuffL2, Der2, DerBuffL2} = set_affected_parties(AffectedParties, Aer, AerBuffList, Der, DerBuffList, User2, UserBuffL2),
                    Aer3 = add_trigger_skill(Aer2, IsFirstDer, SkillId),
                    calc_active_attr_effect(T, Trigger, Aer3, Der2, AerBuffL2, DerBuffL2, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, Broadcast)
            end;
        false ->
            calc_active_attr_effect(T, Trigger, Aer, Der,  AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, Broadcast)
    end;
calc_active_attr_effect([_|T], Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, Broadcast) ->
    calc_active_attr_effect(T, Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, Broadcast);
calc_active_attr_effect([], _Trigger, Aer, Der, AerBuffList, DerBuffList, _NowTime, _SkillId, _SkillLv, _OldAer, _OldDer, _, _) ->
    AerBA = Aer#battle_status.battle_attr, DerBA = Der#battle_status.battle_attr,
    { Aer#battle_status{battle_attr=AerBA#battle_attr{attr_buff_list=AerBuffList}}, Der#battle_status{battle_attr=DerBA#battle_attr{attr_buff_list=DerBuffList}} }.

%% 计算主动技能的特殊效果
calc_active_other_effect([{K, BuffType, PerMil, AffectedParties, Int, Float, AttrId, LastTime, _Num, EffectId}=H|T],
        Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast) ->
    {User, UserBuffL, OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffList, Der, DerBuffList, OldAer, OldDer),
    UserBA = User#battle_status.battle_attr,
    UserSE = UserBA#battle_attr.skill_effect,
    Percent = calc_buff_percent(User, K, PerMil),
    % 1、不是免疫伤害 或 不是控制和不是减免
    % 2、不是控制或者 或 非霸体(技能)和非霸体(自身霸体)
    case ((UserSE#skill_effect.immue == 0) orelse (BuffType =/= ?SKILL_CTRL_BUFF andalso BuffType =/= ?SKILL_DEBUFF)) 
            andalso (BuffType/= ?SKILL_CTRL_BUFF orelse (UserSE#skill_effect.superarmor == 0 andalso User#battle_status.is_armor==0))
            andalso urand:ge_rand(1, ?SKILL_PROB_C, Percent) of
        true when LastTime > 0 ->
            {Int1, Float1}
                = if AttrId > 0 ->
                          {value_cate(Int, Float, AttrId, 0, lib_player_attr:get_value_by_id(AttrId, OldUser#battle_status.battle_attr#battle_attr.attr)), 0};
                     true ->
                          {Int, Float}
                  end,
            case calc_buff_swap(K, BuffType, Int1, Float1, LastTime, 0, EffectId, AttrId, SkillId, SkillLv, NowTime, UserBuffL) of
                {true, BuffList} ->
                    {CalcComboBuffUser, CalcComboBuffL} = case BuffType of
                        ?SKILL_CTRL_BUFF -> %% 控制技能
                            {User#battle_status{skill_combo=[], shaking_skill=0,
                                battle_attr=UserBA#battle_attr{skill_effect=UserSE#skill_effect{interrupt=User#battle_status.shaking_skill}}},
                                del_all_combo_buff(BuffList, [])};
                        _ ->
                            {User, BuffList}
                    end,
                    {Aer1, AerBuffL1, Der1, DerBuffL1} = set_affected_parties(AffectedParties, Aer, AerBuffList, Der, DerBuffList, CalcComboBuffUser, CalcComboBuffL),
                    BattlePassiveArgs = #battle_passive_args{skill_id = SkillId, aer = Aer},
                    {Aer2, AerBuffL2, Der2, DerBuffL2} = calc_sp_effect(H, Aer1, AerBuffL1, Der1, DerBuffL1, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, NowTime, Broadcast, BattlePassiveArgs),
                    Aer3 = add_trigger_skill(Aer2, IsFirstDer, SkillId),
                    calc_active_other_effect(T, Trigger, Aer3, Der2, AerBuffL2, DerBuffL2, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast);
                {false, _} ->
                    calc_active_other_effect(T, Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast)
            end;
        true ->
            BattlePassiveArgs = #battle_passive_args{skill_id = SkillId, aer = Aer},
            {Aer2, AerBuffL2, Der2, DerBuffL2} = calc_sp_effect(H, Aer, AerBuffList, Der, DerBuffList, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, NowTime, Broadcast, BattlePassiveArgs),
            calc_active_other_effect(T, Trigger, Aer2, Der2, AerBuffL2, DerBuffL2, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast);
        false ->
            calc_active_other_effect(T, Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast)
    end;

calc_active_other_effect([_|T], Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast) ->
    calc_active_other_effect(T, Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast);
calc_active_other_effect([], _Trigger, #battle_status{battle_attr=AerBA}=Aer, #battle_status{battle_attr=DerBA}=Der,
                         AerBuffList, DerBuffList, _NowTime, _SkillId, _SkillLv, _OldAer, _OldDer, _IsFirstDer, _AttX, _AttY, _AttAngle, _Broadcast) ->
    { Aer#battle_status{battle_attr = AerBA#battle_attr{other_buff_list=AerBuffList}},
      Der#battle_status{battle_attr = DerBA#battle_attr{other_buff_list=DerBuffList}} }.

%% 获取作用方
get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer) ->
    case AffectedParties of
        ?SKILL_AFFECT_MYSELF -> {Aer, AerBuffL, OldAer};
        _ -> {Der, DerBuffL, OldDer}
    end.

%% 替换作用方
set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, User, UserBuffL) ->
    case AffectedParties of
        ?SKILL_AFFECT_MYSELF -> {User, UserBuffL, Der, DerBuffL};
        _ -> {Aer, AerBuffL, User, UserBuffL}
    end.

%% 获取作用方和参照方
get_double_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer) ->
    case AffectedParties of
        ?SKILL_AFFECT_MYSELF -> {Aer, AerBuffL, OldAer, Der, DerBuffL, OldDer};
        _ -> {Der, DerBuffL, OldDer, Aer, AerBuffL, OldAer}
    end.

%% 替换作用方和参照方
set_double_affected_parties(AffectedParties, Affecter, AffecterBuffL, Refer, ReferBuffL) ->
    case AffectedParties of
        ?SKILL_AFFECT_MYSELF -> {Affecter, AffecterBuffL, Refer, ReferBuffL};
        _ -> {Refer, ReferBuffL, Affecter, AffecterBuffL}
    end.

%% 是否正确的作用方
is_affected_parties(AffectedParties, #battle_status{id=AId, sign=ASign}, #battle_status{id=DId, sign=DSign}) ->
    case AffectedParties of
        ?SKILL_AFFECT_MYSELF -> AId == DId andalso ASign == DSign;
        _ -> true
    end.

%% 计算特殊效果,不处理+buff
calc_sp_effect({BuffKey, BuffType, _PerMil, AffectedParties, Int, Float, AttrId, LastTime, Num, _EffectId}, Aer, AerBuffL,
               Der, DerBuffL, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, NowTime, Broadcast, BAPassiveArgs) ->
    case BuffKey of
        ?SPBUFF_SUPERARMOR -> %% 霸体
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr=#battle_attr{skill_effect=SE}=UserBA} = User,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL,
                                 User#battle_status{battle_attr=UserBA#battle_attr{skill_effect=SE#skill_effect{superarmor=1}}}, UserBuffL);

        ?SPBUFF_IMMUNE -> %% 无敌
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr=#battle_attr{skill_effect=SE}=UserBA} = User,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL,
                                 User#battle_status{battle_attr=UserBA#battle_attr{skill_effect=SE#skill_effect{immue=1}}}, UserBuffL);

        ?SPBUFF_REBOUND -> %% 反弹
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            if
                BAPassiveArgs#battle_passive_args.skill_id == ?SP_SKILL_KILLING andalso User#battle_status.team_id > 0 -> %% 特殊的队伍反弹伤害
                    #battle_status{team_skill = TeamSkillId, team_skill_num = TeamSkillNum, battle_attr = UserBA} = User,
                    #battle_attr{skill_effect = SE} = UserBA,
                    if
                        TeamSkillId == 0 -> BuffNum = min(TeamSkillNum+1, 3);
                        true -> BuffNum = max(TeamSkillNum, 1)
                    end,
                    NewUserBA = UserBA#battle_attr{skill_effect=SE#skill_effect{rebound={Int*BuffNum, Float*BuffNum}}},
                    NewUser = User#battle_status{battle_attr=NewUserBA},
                    set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, NewUser, UserBuffL);
                true -> %% 个人反弹
                    #battle_status{battle_attr=#battle_attr{skill_effect=SE, attr = Attr}=UserBA} = User,
                    if
                        AttrId > 0 ->
                            Value = round(Int + Float*lib_player_attr:get_value_by_id(AttrId, Attr)),
                            Rebound = {Value, 0};
                        true ->
                            Rebound = {Int, Float}
                    end,
                    set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL,
                                         User#battle_status{battle_attr=UserBA#battle_attr{skill_effect=SE#skill_effect{rebound=Rebound}}}, UserBuffL)
            end;

        ?SPBUFF_BLOOD -> %% 吸血
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr=#battle_attr{skill_effect=SE}=UserBA} = User,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL,
                                 User#battle_status{battle_attr=UserBA#battle_attr{skill_effect=SE#skill_effect{suck_blood={Int, Float}}}}, UserBuffL);

        ?SPBUFF_SLOW -> %% 减速
            {User, UserBuffL, OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr=#battle_attr{skill_effect=SE}} = User,
            if
                SE#skill_effect.un_speed == 1 -> User1 = User;
                true -> User1 = calc_speed(User, OldUser, OldUser#battle_status.battle_attr#battle_attr.attr_buff_list++UserBuffL, LastTime, NowTime, Broadcast)
            end,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, User1, UserBuffL);

        ?SPBUFF_UNSPEED -> %% 免疫减速
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr=#battle_attr{skill_effect=SE}=UserBA} = User,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL,
                                 User#battle_status{battle_attr=UserBA#battle_attr{skill_effect=SE#skill_effect{un_speed=1}}}, UserBuffL);

        ?SPBUFF_RESUME when LastTime > 0 -> %% 持续回血的方式
            {User, UserBuffL, OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            GapTime = LastTime div max(1, Num),
            #battle_status{id = Id, sign = Sign, battle_attr=#battle_attr{ hp_lim=HpLim}} = User,
            AddHp = min(HpLim, value_cate(Int, Float, AttrId, 0, lib_player_attr:get_value_by_id(AttrId, OldUser#battle_status.battle_attr#battle_attr.attr))),
            lib_scene_timer:add_timer(NowTime, 0, Sign, Id, ?SPBUFF_RESUME, {GapTime, AddHp, max(1, Num)}),
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, User, UserBuffL);

        ?SPBUFF_RESUME -> %% 攻击方,防守方:瞬间回血
            {User, UserBuffL, OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{id=Id, sign = Sign, copy_id=CopyId, x=X, y=Y, battle_attr=#battle_attr{hp = Hp, hp_lim=HpLim, skill_effect=SE}=UserBA} = User,
            if
                % 禁止回血
                SE#skill_effect.un_resume == 1 -> User1 = User;
                % 死亡且允许死亡的状态
                Hp =< 0 andalso SE#skill_effect.un_die == 0 andalso SE#skill_effect.free_die == 0 -> User1 = User;
                true ->
                    AddHp = min(HpLim, value_cate(Int, Float, AttrId, Hp, lib_player_attr:get_value_by_id(AttrId, OldUser#battle_status.battle_attr#battle_attr.attr))),
                    {ok, BinData} = pt_120:write(12009, [Id, AddHp, HpLim]),
                    lib_battle:send_to_scene(CopyId, X, Y, Broadcast, BinData),
                    User1 = User#battle_status{battle_attr=UserBA#battle_attr{hp=AddHp}},
                    %% 回血触发被动技能
                    lib_scene_timer:add_timer(NowTime, 0, Sign, Id, ?SKILL_BUFF_TRIGGER_HPRESUME, max(1, Num))
            end,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, User1, UserBuffL);

        ?SPBUFF_FIXED_MOVE when IsFirstDer orelse AffectedParties == ?SKILL_AFFECT_ENEMY -> %% 移动固定距离
            %% 获取影响双方
            {Affecter, AffecterBuffL, _OldAffecter, Refer, ReferBuffL, _OldRefer} = get_double_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            ReferOldX     = AttX,
            ReferOldY     = AttY,
            #battle_status{scene=SceneId, copy_id=CopyId, x=AffecterOldX, y=AffecterOldY, battle_attr=#battle_attr{skill_effect=SEA}=BA} = Affecter,
            MoveArea = Int,
            [X0, Y0] = case umath:distance({ReferOldX, ReferOldY}, {AffecterOldX, AffecterOldY}) + 10000 < math:pow(MoveArea, 2) of
                           true when Aer#battle_status.sign == ?BATTLE_SIGN_PLAYER, AffectedParties == ?SKILL_AFFECT_MYSELF ->
                               [ReferOldX, ReferOldY];
                           _ ->
                               Angle = umath:degree_to_radian(AttAngle),
                               [round(AffecterOldX+MoveArea*math:cos(Angle)), round(AffecterOldY+MoveArea*math:sin(Angle))]
                       end,
            %% ?PRINT("sprint Affecter ox,oy= ~w,attx,atty= ~w x0,y0=~w~n", [{AffecterOldX, AffecterOldY},{X0, Y0},{AttX, AttY}]),
            [AffecterX, AffecterY] = case lib_scene:can_be_moved(SceneId, CopyId, X0, Y0) of
                                         true  -> [X0, Y0];
                                         false ->  [AffecterOldX, AffecterOldY]
                                     end,
            NewAffecter = Affecter#battle_status{x = AffecterX, y = AffecterY, battle_attr=BA#battle_attr{skill_effect=SEA#skill_effect{move=1}}},
            set_double_affected_parties(AffectedParties, NewAffecter, AffecterBuffL, Refer, ReferBuffL);

        ?SPBUFF_SPRINT -> %% 冲刺
            %% 水平推移到一垂直线上，垂足为{TX, TY}
            %% AffectedParties：1是自己过去；2是自己不过去，敌人都会过去；3是所有人都过去
            %% 攻击方
            #battle_status{sign=Sign, scene=OSceneId, copy_id=OCopyId, x=OX, y=OY} = OldAer, %% 原生坐标
            #battle_status{battle_attr=AerBA=#battle_attr{skill_effect=SEA}} = Aer,
            %% 防守方
            #battle_status{x=PX, y=PY} = OldDer, %% 原生坐标
            #battle_status{battle_attr=DerBA=#battle_attr{skill_effect=SED}} = Der,
            %% 移动点选择
            MoveArea = Int,
            {TX, TY}
                = case AffectedParties of
                      ?SKILL_AFFECT_MYSELF when Sign == ?BATTLE_SIGN_PLAYER -> {AttX, AttY};
                      %% ?SKILL_AFFECT_MYSELF when Sign == ?BATTLE_SIGN_DUMMY  -> {AttX, AttY};
                      ?SKILL_AFFECT_MYSELF when Sign == ?BATTLE_SIGN_DUMMY -> calc_sprint_pos(OX, OY, AttX, AttY, 80);
                      _ -> %% (TODO 多次计算，待优化)
                          #battle_attr{sprint_temp_xy = SprintTempXy} = AerBA, %% 一次计算保存
                          case SprintTempXy of
                              {0, 0} ->
                                  Angle = umath:degree_to_radian(AttAngle),
                                  {round(OX+MoveArea*math:cos(Angle)), round(OY+MoveArea*0.5*math:sin(Angle))};
                              _ when IsFirstDer  ->
                                  Angle = umath:degree_to_radian(AttAngle),
                                  {round(OX+MoveArea*math:cos(Angle)), round(OY+MoveArea*0.5*math:sin(Angle))};
                              _ ->
                                  SprintTempXy
                          end
                  end,
            %% 第一个防守方的计算玩家的实际冲刺位置
            {UserX, UserY, Move}
                = case IsFirstDer of
                      true when AffectedParties == ?SKILL_AFFECT_MYSELF ->
                          {FX, FY} = get_foot_point(AttAngle, {TX, TY}, {OX, OY}),
                          case lib_scene:can_be_moved(OSceneId, OCopyId, FX, FY) of
                              true  -> {FX, FY, 1};
                              false -> {OX, OY, 1}
                          end;
                      _ ->
                          {OX, OY, AerBA#battle_attr.skill_effect#skill_effect.move}
                  end,
            %% 计算每一个防守方的改变位置
            {AffecterX, AffecterY, DerMove}
                = case AffectedParties of  %% 作用方是攻击方自己，防守方不变
                      ?SKILL_AFFECT_MYSELF -> {PX, PY, 0};
                      _ ->
                          {TmpAffecterX, TmpAffecterY} = get_foot_point(AttAngle, {TX, TY}, {PX, PY}),
                          case lib_scene:can_be_moved(OSceneId, OCopyId, TmpAffecterX, TmpAffecterY) of
                              true  -> {TmpAffecterX, TmpAffecterY, 1};
                              false -> {PX, PY, 0}
                          end
                  end,
            if
                Sign == ?BATTLE_SIGN_PLAYER orelse Sign == ?BATTLE_SIGN_DUMMY ->
                    {Aer#battle_status{x=UserX, y=UserY, battle_attr=AerBA#battle_attr{skill_effect=SEA#skill_effect{move=Move}}}, AerBuffL,
                     Der#battle_status{x=AffecterX, y=AffecterY, battle_attr=DerBA#battle_attr{skill_effect=SED#skill_effect{move=DerMove}}}, DerBuffL};
                true ->
                    case AerBA#battle_attr.sprint_temp_xy of
                        {TX, TY} ->
                            {Aer#battle_status{x=UserX, y=UserY, battle_attr=AerBA#battle_attr{skill_effect=SEA#skill_effect{move=Move}}}, AerBuffL,
                             Der#battle_status{x=AffecterX, y=AffecterY, battle_attr=DerBA#battle_attr{skill_effect=SED#skill_effect{move=DerMove}}}, DerBuffL};
                        _ ->
                            NewAerBA = AerBA#battle_attr{sprint_temp_xy = {TX, TY}, skill_effect=SEA#skill_effect{move=Move}},
                            {Aer#battle_status{x=UserX, y=UserY, battle_attr=NewAerBA}, AerBuffL,
                             Der#battle_status{x=AffecterX, y=AffecterY, battle_attr=DerBA#battle_attr{skill_effect=SED#skill_effect{move=DerMove}}}, DerBuffL}
                    end
            end;

        ?SPBUFF_SHIELD -> %% 血量护盾
            {User, UserBuffL, OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr = UserBA = #battle_attr{total_sec_attr=TotalSecAttrMap}} = User,
            NewFloat = if
                (BAPassiveArgs#battle_passive_args.skill_id == ?SP_SKILL_SHIELD) andalso
                User#battle_status.battle_attr#battle_attr.fire_ice_add_shield =/= 0 -> %% 施放技能6，看看被动加护盾
                    User#battle_status.battle_attr#battle_attr.fire_ice_add_shield/?RATIO_COEFFICIENT+Float;
                true ->
                    AddShield = lib_sec_player_attr:get_value_to_int(TotalSecAttrMap, ?SKILL_SHIELD_HP, BAPassiveArgs#battle_passive_args.skill_id),
                    AddShield/?RATIO_COEFFICIENT+Float
            end,
            Value = round(Int + NewFloat*lib_player_attr:get_value_by_id(AttrId, OldUser#battle_status.battle_attr#battle_attr.attr)),
            NewUser = User#battle_status{ battle_attr = UserBA#battle_attr{shield_hp = Value}},
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, NewUser, UserBuffL);

        ?SPBUFF_FIRING -> %% 灼烧
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{id=Id, sign=Sign, battle_attr = UserBA, del_hp_each_time = DelHpEachTime} = User,
            #battle_attr{fire_ref = FireRefs} = UserBA,
            if
                DelHpEachTime =/= [] ->
                    {Aer, AerBuffL, Der, DerBuffL};
                true ->
                    NewUser = case length(FireRefs) >= 3 of
                        true -> User;
                        false ->
                            #battle_passive_args{aer = Atter, hurt = Hurt} = BAPassiveArgs,
                            GapTime = LastTime div max(1, Num),
                            #battle_status{id = AtterId, sign = AttSign, figure = #figure{name = AttName}} = Atter,
                            FireHurt = round(Hurt * Float + Int),
                            FireRef = lib_scene_timer:add_timer(NowTime, 0, Sign, Id, ?SPBUFF_FIRING, 
                                {GapTime, FireHurt,  max(1, Num), {AtterId, AttSign, AttName}}),
                            NewFireRefs = [FireRef|FireRefs],
                            User#battle_status{battle_attr=UserBA#battle_attr{fire_ref = NewFireRefs}}
                    end,
                    set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, NewUser, UserBuffL)
            end;

        ?SPBUFF_BLEED -> %% 流血
            {User, UserBuffL, OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{id = Id, sign = Sign, battle_attr = UserBA, del_hp_each_time = DelHpEachTime} = User,
            #battle_attr{bleed_ref = BleedRefs} = UserBA,
            #battle_passive_args{aer = Atter} = BAPassiveArgs,
            %% 面板基础属性
            if
                DelHpEachTime =/= [] ->
                    {Aer, AerBuffL, Der, DerBuffL};
                true ->
                    if
                        AttrId == ?ATT orelse AttrId == ?WRECK orelse AttrId == ?ELEM_ATT -> %% 用攻击者的属性
                            Bleed = value_cate(Int, Float, AttrId, 0,
                                lib_player_attr:get_value_by_id(AttrId, OldAer#battle_status.battle_attr#battle_attr.attr));
                        true ->
                            Bleed = value_cate(Int, Float, AttrId, 0,
                                lib_player_attr:get_value_by_id(AttrId, OldUser#battle_status.battle_attr#battle_attr.attr))
                    end,
                    GapTime = LastTime div max(1, Num),
                    #battle_status{id = AtterId, sign = AttSign, figure = #figure{name = AttName}} = Atter,
                    BleedRef = lib_scene_timer:add_timer(NowTime, 0, Sign, Id, ?SPBUFF_BLEED,
                                                          {GapTime, Bleed, max(1, Num), {AtterId, AttSign, AttName}}),
                    NewBleedRefs = [BleedRef|BleedRefs],
                    NewUser = User#battle_status{battle_attr=UserBA#battle_attr{bleed_ref = NewBleedRefs}},
                    set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, NewUser, UserBuffL)
            end;

        ?SPBUFF_TALENT_BLEED -> %% 流血
            {User, UserBuffL, OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{id = Id, sign = Sign, battle_attr = UserBA, del_hp_each_time = DelHpEachTime} = User,
            #battle_attr{bleed_ref = BleedRefs} = UserBA,
            #battle_passive_args{aer = Atter} = BAPassiveArgs,
            %% 面板基础属性
            if
                DelHpEachTime =/= [] ->
                    {Aer, AerBuffL, Der, DerBuffL};
                true ->
                    if
                        AttrId == ?ATT orelse AttrId == ?WRECK orelse AttrId == ?ELEM_ATT -> %% 用攻击者的属性
                            Bleed = value_cate(Int, Float, AttrId, 0,
                                lib_player_attr:get_value_by_id(AttrId, OldAer#battle_status.battle_attr#battle_attr.attr));
                        true ->
                            Bleed = value_cate(Int, Float, AttrId, 0,
                                lib_player_attr:get_value_by_id(AttrId, OldUser#battle_status.battle_attr#battle_attr.attr))
                    end,
                    GapTime = LastTime div max(1, Num),
                    #battle_status{id = AtterId, sign = AttSign, figure = #figure{name = AttName}} = Atter,
                    BleedRef = lib_scene_timer:add_timer(NowTime, 0, Sign, Id, ?SPBUFF_TALENT_BLEED,
                                                          {GapTime, Bleed, max(1, Num), {AtterId, AttSign, AttName}}),
                    NewBleedRefs = [BleedRef|BleedRefs],
                    NewUser = User#battle_status{battle_attr=UserBA#battle_attr{bleed_ref = NewBleedRefs}},
                    set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, NewUser, UserBuffL)
            end;

        ?SPBUFF_UNDIZZY -> %% 眩晕免疫
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr = UserBA} = User,
            #battle_attr{skill_effect = SkillEffect} = UserBA,
            BuffList = if
                SkillEffect#skill_effect.current_un_dizzy == 1 -> %% 作用者可以免疫这次的造成的晕
                    lists:keydelete(?SPBUFF_DIZZY, 1, UserBuffL);
                true -> UserBuffL
            end,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, User, BuffList);

        ?SPBUFF_CLEAN_BUFF -> %% 清楚负面控制buff
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            {NewUser, NewUserBuffL} = remove_type_buff(UserBuffL, User, BuffType, []),
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, NewUser, NewUserBuffL);

        ?SPBUFF_HP_LIM_HURT -> %% 血量上限最大伤害比例
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr=#battle_attr{skill_effect=SE}=UserBA} = User,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL,
                User#battle_status{battle_attr=UserBA#battle_attr{skill_effect=SE#skill_effect{hp_lim_hurt={Int, Float}}}}, UserBuffL);

        ?SPBUFF_UNREUME -> %% 禁止回血
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr=#battle_attr{skill_effect=SE}=UserBA} = User,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL,
                                 User#battle_status{battle_attr=UserBA#battle_attr{skill_effect=SE#skill_effect{un_resume=1}}}, UserBuffL);

        ?SPBUFF_MINUS_CD ->
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{skill_cd = SkillCd, node = Node, sign = Sign, id = Id} = User,
            case data_skill:get(Int, 1) of
                #skill{lv_data = #skill_lv{cd = Cd}} ->
                    case lists:keyfind(Int, 1, SkillCd) of
                        {SkillId, EndTime} when NowTime < EndTime -> 
                            NewEndTime = max(0, umath:ceil(EndTime - Cd*Float)),
                            RealSign = lib_battle:calc_real_sign(Sign),
                            if
                                RealSign == ?BATTLE_SIGN_PLAYER -> 
                                    {ok, BinData} = pt_200:write(20027, [SkillId, NewEndTime]),
                                    lib_server_send:send_to_uid(Node, Id, BinData);
                                true ->
                                    skip
                            end,
                            NewSkillCd = lists:keyreplace(SkillId, 1, SkillCd, {SkillId, NewEndTime});
                        _ -> 
                            NewSkillCd = SkillCd
                    end;
                _ ->
                    NewSkillCd = SkillCd
            end,
            NewUser = User#battle_status{skill_cd = NewSkillCd},
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, NewUser, UserBuffL);

        ?SPBUFF_MINUS_FIX_CD ->
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{skill_cd = SkillCd, node = Node, sign = Sign, id = Id} = User,
            case data_skill:get(Int, 1) of
                #skill{lv_data = #skill_lv{}} ->
                    case lists:keyfind(Int, 1, SkillCd) of
                        {SkillId, EndTime} when NowTime < EndTime -> 
                            NewEndTime = max(0, umath:ceil(EndTime - Float)),
                            RealSign = lib_battle:calc_real_sign(Sign),
                            if
                                RealSign == ?BATTLE_SIGN_PLAYER -> 
                                    {ok, BinData} = pt_200:write(20027, [SkillId, NewEndTime]),
                                    lib_server_send:send_to_uid(Node, Id, BinData);
                                true ->
                                    skip
                            end,
                            NewSkillCd = lists:keyreplace(SkillId, 1, SkillCd, {SkillId, NewEndTime});
                        _ -> 
                            NewSkillCd = SkillCd
                    end;
                _ ->
                    NewSkillCd = SkillCd
            end,
            NewUser = User#battle_status{skill_cd = NewSkillCd},
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, NewUser, UserBuffL);

        ?SPBUFF_BAN_GOD -> %% 禁术天神
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr=#battle_attr{skill_effect=SE}=UserBA} = User,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL,
                                 User#battle_status{battle_attr=UserBA#battle_attr{skill_effect=SE#skill_effect{ban_god=1}}}, UserBuffL);

        ?SPBUFF_BAN_BLEED -> %% 禁术流血
            {User, UserBuffL, OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{id = Id, sign = Sign, battle_attr = UserBA} = User,
            #battle_attr{skill_effect=SE, ban_bleed_list = BanBleedL} = UserBA,
            #battle_passive_args{aer = Atter} = BAPassiveArgs,
            %% 面板基础属性
            #battle_status{battle_attr = #battle_attr{total_sec_attr = TotalSecAttrMap}} = Aer,
            #battle_status{id = AtterId, sign = AttSign, figure = #figure{name = AttName}} = Atter,
            case lists:keyfind({AtterId, AttSign}, #ban_bleed.key, BanBleedL) of
                false -> Stack = 1;
                #ban_bleed{ref = OldBanBleedRef, stack = OldStack} ->
                    util:cancel_timer(OldBanBleedRef),
                    AddStack = lib_sec_player_attr:get_value_to_int(TotalSecAttrMap, ?SKILL_BUFF_STACK, BuffKey),
                    Stack0 = max(1, OldStack + 1),
                    % TODO:目前写死3层,配置化需要改结构
                    Stack = min(Stack0, 3+AddStack)
            end,
            AddFloat = lib_sec_player_attr:get_value_to_int(TotalSecAttrMap, ?SKILL_BUFF_FLOAT, BuffKey) / ?RATIO_COEFFICIENT,
            NewFloat = AddFloat + Float,
            if
                AttrId == 0 ->
                    Bleed = lib_battle:calc_hurt_for_buff(Aer, Der, Int, NewFloat*Stack, NowTime);
                AttrId == ?ATT orelse AttrId == ?WRECK orelse AttrId == ?ELEM_ATT -> %% 用攻击者的属性
                    Bleed = value_cate(Int, Stack*NewFloat, AttrId, 0,
                        lib_player_attr:get_value_by_id(AttrId, OldAer#battle_status.battle_attr#battle_attr.attr));
                true ->
                    Bleed = value_cate(Int, Stack*NewFloat, AttrId, 0,
                        lib_player_attr:get_value_by_id(AttrId, OldUser#battle_status.battle_attr#battle_attr.attr))
            end,
            NewNum = max(1, Num),
            GapTime = LastTime div NewNum,
            NewNum2 = lib_sec_player_attr:get_value_to_int(TotalSecAttrMap, ?SKILL_BUFF_COUNT, BuffKey) + NewNum,
            BanBleedRef = lib_scene_timer:add_timer(NowTime, 0, Sign, Id, ?SPBUFF_BAN_BLEED,
                {GapTime, Bleed, max(1, NewNum2), {AtterId, AttSign, AttName}}),
            BanBleed = #ban_bleed{
                ref = BanBleedRef, atter_id = AtterId, sign = AttSign, key = {AtterId, AttSign}, 
                stack = Stack, int = Int, float = Float, attr_id = AttrId
                },
            NewBanBleedL = lists:keystore(AtterId, #ban_bleed.atter_id, BanBleedL, BanBleed),
            NewUser = User#battle_status{battle_attr=UserBA#battle_attr{skill_effect=SE#skill_effect{ban_bleed=1}, ban_bleed_list = NewBanBleedL}},
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, NewUser, UserBuffL);

        %% 技能释放buff(Int是技能id, Float是技能等级)
        ?SPBUFF_SKILL -> 
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{id = Id, sign = Sign, battle_attr = UserBA} = User,
            #battle_attr{skill_ref = SkillRefs} = UserBA,
            #battle_passive_args{aer = Atter} = BAPassiveArgs,
            #battle_status{id = AtterId, sign = AttSign, figure = #figure{name = AttName}} = Atter,
            NewNum = max(1, Num),
            GapTime = LastTime div NewNum,
            SkillRef = lib_scene_timer:add_timer(NowTime, GapTime, Sign, Id, ?SPBUFF_SKILL,
                {GapTime, NewNum, Int, Float, {AtterId, AttSign, AttName}}),
            NewSkillRefs = [SkillRef|SkillRefs],
            NewUser = User#battle_status{battle_attr=UserBA#battle_attr{skill_ref = NewSkillRefs}},
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, NewUser, UserBuffL);

        %% 免死
        ?SPBUFF_FREE_DIE ->
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr=#battle_attr{skill_effect=SE}=UserBA} = User,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL,
                User#battle_status{battle_attr=UserBA#battle_attr{skill_effect=SE#skill_effect{free_die=1}}}, UserBuffL);
        %% 锁血
        ?SPBUFF_LOCK_HP ->
            {User, UserBuffL, _OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL, OldAer, OldDer),
            #battle_status{battle_attr=#battle_attr{skill_effect=SE}=UserBA} = User,
            set_affected_parties(AffectedParties, Aer, AerBuffL, Der, DerBuffL,
                User#battle_status{battle_attr=UserBA#battle_attr{skill_effect=SE#skill_effect{hp_lock = {Int, Float}}}}, UserBuffL);
        _ ->
            {Aer, AerBuffL, Der, DerBuffL}
    end.

%% 处理隐身状态
handle_steath_state(Sign, Id, CopyId, X, Y, Broadcast, _NowTime, _LastTime, AddorDel) ->
    {ok, BinData} = pt_120:write(12070, [Sign, Id, AddorDel]),
    lib_battle:send_to_scene(CopyId, X, Y, Broadcast, BinData),
    case AddorDel of
        %% 1 -> lib_scene_timer:add_timer(NowTime, LastTime, Sign, Id, ?SPBUFF_STEALTH, 0);
        _ -> skip
    end.

%% 求P点在直线OT上经过T点的垂直相交的直线上的垂足
get_foot_point({OX, OY}, {TX, TY}, {PX, PY}) ->
    case OY == TY of
        true  -> {TX, PY};
        false ->
            K  = -(TX - OX) / (TY - OY), %% 垂直方向的直线方程斜率
            B  =  TY - K * TX,
            K2 = math:pow(K,2),
            {round((PX+K*PY-B*K)/(K2+1)), round((K*PX+PY*K2+B)/(K2+1))}
    end;
get_foot_point(AttAngle, {TX, TY}, {PX, PY}) when is_integer(AttAngle) ->
    case AttAngle==0 orelse AttAngle==180  of
        true  -> {TX, PY};
        false ->
            K = -1/math:tan(umath:degree_to_radian(AttAngle)), %% 垂直方向的直线方程斜率
            B  =  TY - K * TX,
            K2 = math:pow(K,2),
            {round((PX+K*PY-B*K)/(K2+1)), round((K*PX+PY*K2+B)/(K2+1))}
    end.

%% 计算速度
calc_speed(User, OldUser, BuffList, LastTime, NowTime, Broadcast) ->
    #battle_status{id=Id, sign=Sign, copy_id=CopyId, x=X, y=Y, battle_attr=BA} = User,
    % BaseSpeed = OldUser#battle_status.battle_attr#battle_attr.attr#attr.speed,
    BaseSpeed = case Sign == ?BATTLE_SIGN_PLAYER of
        true -> OldUser#battle_status.battle_attr#battle_attr.battle_speed;
        false -> OldUser#battle_status.battle_attr#battle_attr.attr#attr.speed
    end,
    [Float, Int] = calc_speed_helper(BuffList, NowTime, [1.0, 0]),
    Speed = max(0, round(BaseSpeed*Float+Int)),
    % ?PRINT("LastTime:~w BaseSpeed:~p CalcSpeed:~w~n", [LastTime, [[Float, Int], Speed]]),
    lib_scene_timer:add_timer(NowTime+500, LastTime, Sign, Id, ?SPEED, []),
    case Speed /= BA#battle_attr.speed of
        true  ->
            {ok, BinData} = pt_120:write(12082, [Sign, Id, Speed]),
            lib_battle:send_to_scene(CopyId, X, Y, Broadcast, BinData);
        false -> skip
    end,
    User#battle_status{battle_attr=BA#battle_attr{speed=Speed}}.

calc_speed_helper([{?SPEED, _, _, _, _, Int, Float, EndTime, _, _}|T], NowTime, [F, I]) when EndTime > NowTime ->
    calc_speed_helper(T, NowTime, [F*max(0, 1+Float), I+Int]);
calc_speed_helper([{?SPBUFF_SLOW, _, _, _, _, Int, Float, EndTime, _, _}|T], NowTime, [F, I]) when EndTime > NowTime ->
    calc_speed_helper(T, NowTime, [F*max(0, 1-Float), I-Int]);
calc_speed_helper([_|T], NowTime, [F, I]) -> calc_speed_helper(T, NowTime, [F, I]);
calc_speed_helper([], _, Result) -> Result.

%% 计算回复量
calc_hp_resume(User, Base, NowTime) ->
    case User of
        #ets_scene_user{battle_attr = BA} -> skip;
        #scene_object{battle_attr = BA} -> skip;
        #battle_status{battle_attr = BA} -> skip
    end,
    #battle_attr{other_buff_list = OtherL, attr_buff_list = AttrL} = BA,
    [Float, Int] = calc_hp_resume_helper(AttrL ++ OtherL, NowTime, [1.0, 0]),
    max(0, round(Base*Float+Int)).

calc_hp_resume_helper([_|T], NowTime, [F, I]) ->
    calc_hp_resume_helper(T, NowTime, [F, I]);
calc_hp_resume_helper([], _, Result) -> Result.

%% 删除bufftype的buff
remove_type_buff([], User, _BuffType, BuffList) -> {User, BuffList};
remove_type_buff([{BuffKey, _, _, _, _, _, _, _, _, _}=H|T], User, BuffType, BuffList) ->
    if
        BuffKey == ?SPBUFF_DIZZY orelse BuffKey == ?SPBUFF_SILENCE  orelse
                BuffKey == ?SPBUFF_IMMOBILIZE orelse BuffKey == ?SPBUFF_SLOW ->
            remove_type_buff(T, User, BuffType, BuffList);
        BuffKey == ?SPBUFF_BLEED orelse BuffKey == ?SPBUFF_TALENT_BLEED ->
            #battle_status{battle_attr = #battle_attr{bleed_ref = BleedRefs} = BA} = User,
            [util:cancel_timer(TmpRef) || TmpRef <- BleedRefs],
            NewBA = BA#battle_attr{bleed_ref = []},
            NewUser = User#battle_status{battle_attr = NewBA},
            remove_type_buff(T, NewUser, BuffType, BuffList);
        BuffKey == ?SPBUFF_FIRING ->
            #battle_status{battle_attr = #battle_attr{fire_ref = FireRefs} = BA} = User,
            [util:cancel_timer(TmpRef) || TmpRef <- FireRefs],
            NewBA = BA#battle_attr{fire_ref = []},
            NewUser = User#battle_status{battle_attr = NewBA},
            remove_type_buff(T, NewUser, BuffType, BuffList);
        true ->
            remove_type_buff(T, User, BuffType, [H|BuffList])
    end.

%% 计算出万分比
calc_buff_percent(User, K, PerMil) ->
    #battle_status{battle_attr = BA} = User,
    #battle_attr{attr = #attr{undizzy_ratio = UnDizzyRatio}} = BA,
    if
        K == ?SPBUFF_DIZZY -> PerMil - UnDizzyRatio; 
        true -> PerMil
    end.

%% 检查是否可以触发效果
check_active_buff_effect_trigger(K, User, [{_TgType, PerMil, _, _PTime, _Int, _Float, SBuffId, K}]) when SBuffId > 0 ->
    #battle_status{battle_attr = BA} = User,
    case urand:ge_rand(1, ?SKILL_PROB_C, PerMil) of
        true ->
            case lists:keyfind(SBuffId, 1, BA#battle_attr.attr_buff_list) of
                false ->
                    case lists:keyfind(SBuffId, 1, BA#battle_attr.other_buff_list) of
                        false -> false;
                        _Buff -> true
                    end;
                _Buff -> true
            end;
        false ->
            false
    end;
check_active_buff_effect_trigger(K, User, [_H|T])->
    check_active_buff_effect_trigger(K, User, T);
check_active_buff_effect_trigger(_K, _User, [])->
    true.

%% 攻击方被动技能触发
calc_aer_passive_skill(Aer, Der, OldAer, OldDer, NowTime, IsFirstDer, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs)->
    #battle_status{
        skill_passive = SkillPassive, skill_passive_share = SkillPassiveShare, tmp_skill_passive = TmpSkillPassive, 
        skill_cd = SkillCd
        } = Aer,
    if
        BAPassiveArgs#battle_passive_args.hurt_type == ?HURT_TYPE_IMMUE -> {Aer, Der};
        % TODO:检查一下是否需要特殊处理,目前所有对象的被动技能都生效
        % Aer#battle_status.sign /= ?BATTLE_SIGN_PLAYER -> {Aer, Der};
        SkillPassive == [] andalso SkillPassiveShare == [] andalso TmpSkillPassive == [] -> {Aer, Der};
        true ->
            SumSkillPassive = SkillPassive ++ SkillPassiveShare ++ TmpSkillPassive,
            NewSkillCd = [{SkillId, Time}|| {SkillId, Time} <- SkillCd, Time > NowTime],
            calc_passive_skill(SumSkillPassive, SumSkillPassive, Aer#battle_status{skill_cd = NewSkillCd}, Der,
                               OldAer, OldDer, NowTime, IsFirstDer, true, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs)
    end.

%% 受击方(Aer其实是受击方, Der其实是攻击方)
calc_der_passive_skill(Aer, Der, OldAer, OldDer, NowTime, IsFirstDer, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs) ->
    #battle_status{
        skill_passive = SkillPassive, skill_passive_share = SkillPassiveShare, tmp_skill_passive = TmpSkillPassive,
        skill_cd = SkillCd, team_skill = TeamSkill
        } = Aer,
    if
        BAPassiveArgs#battle_passive_args.hurt_type == ?HURT_TYPE_IMMUE ->
            {Aer, Der, BAPassiveArgs#battle_passive_args.hp};
        % TODO:检查一下是否需要特殊处理,目前所有对象的被动技能都生效
        % Aer#battle_status.sign /= ?BATTLE_SIGN_PLAYER ->
        %     {Aer, Der, BAPassiveArgs#battle_passive_args.hp};
        SkillPassive == [] andalso SkillPassiveShare == [] andalso TmpSkillPassive == [] andalso Aer#battle_status.team_skill == 0 ->
            {Aer, Der, BAPassiveArgs#battle_passive_args.hp};
        true ->
            SumSkillPassive = SkillPassive ++ SkillPassiveShare ++ TmpSkillPassive,
            NewSkillPassive = ?IF(TeamSkill == 0, SumSkillPassive, [{TeamSkill, 1}|SumSkillPassive]),
            NewSkillCd = [{SkillId, Time}|| {SkillId, Time} <- SkillCd, Time > NowTime],
            {NewAer, NewDer} = calc_passive_skill(NewSkillPassive, NewSkillPassive, Aer#battle_status{skill_cd = NewSkillCd}, Der,
                                                  OldAer, OldDer, NowTime, IsFirstDer, false, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs),
            #battle_status{battle_attr = NewBA} = NewAer,
            if
                % 1:计算buff的时候才禁止血量操作
                % 2:如果血量等于0且是允许死亡的状态,血量等于0
                BAPassiveArgs#battle_passive_args.hp == 0 andalso NewBA#battle_attr.skill_effect#skill_effect.un_die == 0 ->
                    {NewAer, NewDer, BAPassiveArgs#battle_passive_args.hp};
                true ->
                    {NewAer, NewDer, NewAer#battle_status.battle_attr#battle_attr.hp}
            end
    end.

%% @para 第二参数 SkillPassive : 计算的被动技能列表
calc_passive_skill([], _SkillPassive, Aer, Der, _OldAer, _OldDer, _NowTime, _IsFirstDer, _IsAtt, _AttX, _AttY, _AttAngle, _BroadCast, _BAPassiveArgs) ->
    {Aer, Der};
calc_passive_skill([{SkillId, SkillLv}|T], SkillPassive, Aer, Der, OldAer, OldDer, NowTime, IsFirstDer, IsAtt, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs) ->
    case data_skill:get(SkillId, SkillLv) of
        #skill{
                lv_data=#skill_lv{
                    cd = Cd, trigger_cond = TriggerCond, trigger = Trigger, attr = AttrList, effect = EffectList, 
                    assist_skill_list = AssistSkillList, relate_skill_list = RelateSkillList,  must_skill_list = MustSkillL}
                } ->
            case check_passive_skill([{cd}|TriggerCond], SkillId, Aer#battle_status.skill_cd, NowTime, BAPassiveArgs, Aer, Der) of
                false ->
                    calc_passive_skill(T, SkillPassive, Aer, Der, OldAer, OldDer, NowTime, IsFirstDer, IsAtt, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs);
                true ->
                    %% 属性计算
                    #battle_status{
                        id = Id, scene = Scene, scene_pool_id = ScenePoolId, sign = Sign, battle_attr=#battle_attr{attr_buff_list = AerBuffList}, 
                        tmp_skill_passive = TmpSkillPassive
                        } = Aer,
                    #battle_status{battle_attr=#battle_attr{attr_buff_list = DerBuffList}} = Der,
                    {NewAttrAer, NewAttrDer, AttrIsTrigger} = calc_passive_attr_effect(AttrList, Trigger, Aer, Der, AerBuffList, DerBuffList,
                        NowTime, SkillId, SkillLv, OldAer, OldDer, Broadcast, BAPassiveArgs),
                    %% 特殊效果计算
                    #battle_status{battle_attr=#battle_attr{attr_buff_list = _A, other_buff_list = AerEBL}} = NewAttrAer,
                    #battle_status{battle_attr=#battle_attr{attr_buff_list = _D, other_buff_list = DerEBL}} = NewAttrDer,
                    {NewEffectAer, NewEffectDer, EffIsTrigger} = calc_passive_other_effect(EffectList, Trigger, NewAttrAer, 
                        NewAttrDer, AerEBL, DerEBL, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs),
                    %(AttrIsTrigger == 1 orelse EffIsTrigger == 1) andalso ?PRINT(SkillId == 5501005, "AerId ~p AttrIsTrigger ~p EffIsTrigger ~p ~n", [Id, AttrIsTrigger, EffIsTrigger]),
                    %(AttrIsTrigger == 1 orelse EffIsTrigger == 1) andalso ?MYLOG(SkillId == 5501005, "zh_skill", "AerId ~p AttrIsTrigger ~p EffIsTrigger ~p ~n", [Id, AttrIsTrigger, EffIsTrigger]),

                    if
                        % 辅助技能触发
                        % 1: 属性和特殊效果任意触发
                        % 2: 属性和特效效果都是空,直接触发辅助技能
                        (AttrIsTrigger == 1 orelse EffIsTrigger == 1) orelse (AttrList == [] andalso EffectList == []) ->
                            RealSign = lib_battle:calc_real_sign(Sign),
                            % 辅助技能触发
                            [lib_battle_api:assist_anything(Scene, ScenePoolId, RealSign, Id, RealSign, 
                                Id, TmpSkillId, TmpSkillLv)||{TmpSkillId, TmpSkillLv}<-AssistSkillList],
                            % 成功触发的技能
                            #battle_passive_args{ok_passive_list = OkPassiveList} = BAPassiveArgs,
                            NewBAPassiveArgs = BAPassiveArgs#battle_passive_args{ok_passive_list = [SkillId|lists:delete(SkillId, OkPassiveList)]},
                            % 关联技能为空不处理
                            case RelateSkillList == [] of
                                true -> TAfRelate = T;
                                false ->
                                    F = fun(TmpSkillId, TmpL) -> lists:keydelete(TmpSkillId, 1, TmpL) end,
                                    DelRelateT = lists:foldl(F, T, RelateSkillList),
                                    F2 = fun(TmpSkillId, TmpL) -> 
                                        case lists:keyfind(TmpSkillId, 1, SkillPassive) of
                                            false -> TmpL;
                                            {TmpSkillId, TmpSkillLv} -> [{TmpSkillId, TmpSkillLv}|TmpL]
                                        end
                                    end,
                                    AddRelateT = lists:reverse(lists:foldl(F2, [], RelateSkillList)),
                                    TAfRelate = AddRelateT ++ DelRelateT
                            end,
                            % 必然触发技能
                            TAfMust = MustSkillL ++ TAfRelate,
                            F3 = fun({TmpSkillId, TmpSkillLv}, NewTmpSkillPassive) -> lists:keystore(TmpSkillId, 1, NewTmpSkillPassive, {TmpSkillId, TmpSkillLv}) end,
                            NewTmpSkillPassive = lists:foldl(F3, TmpSkillPassive, MustSkillL);
                        true ->
                            TAfMust = T,
                            NewBAPassiveArgs = BAPassiveArgs,
                            NewTmpSkillPassive = TmpSkillPassive
                    end,
                    if
                        % 设置cd
                        % 1:属性和特殊效果任意触发
                        % 2:属性和特效效果都是空,辅助技能不为空
                        % 3:并且cd大于0
                        ((AttrIsTrigger == 1 orelse EffIsTrigger == 1) orelse (AttrList == [] andalso EffectList == [] andalso AssistSkillList =/= [])) andalso Cd /= 0 ->
                            NewCd = lib_battle_util:change_new_cd(0, NewEffectAer, SkillId, Cd),
                            NewSkillCds = [{SkillId, NowTime+NewCd}| lists:keydelete(SkillId, 1, NewEffectAer#battle_status.skill_cd)];
                        true -> 
                            NewSkillCds = NewEffectAer#battle_status.skill_cd
                    end,
                    if
                        % 设置成功触发效果的技能
                        IsAtt andalso (AttrIsTrigger == 1 orelse EffIsTrigger == 1) ->
                            LastEffectAer = add_trigger_skill(NewEffectAer#battle_status{skill_cd = NewSkillCds, tmp_skill_passive = NewTmpSkillPassive}, IsFirstDer, SkillId);
                        IsAtt == false andalso (AttrIsTrigger == 1 orelse EffIsTrigger == 1) ->
                            LastEffectAer = add_be_trigger_skill(NewEffectAer#battle_status{skill_cd = NewSkillCds, tmp_skill_passive = NewTmpSkillPassive}, SkillId);
                        true ->
                            LastEffectAer = NewEffectAer#battle_status{skill_cd = NewSkillCds, tmp_skill_passive = NewTmpSkillPassive}
                    end,
                    %% io:format("~p ~p SkillCds, NewSkillCds:~w~n", [?MODULE, ?LINE, [SkillCds, NewSkillCds]]),
                    calc_passive_skill(TAfMust, SkillPassive, LastEffectAer, NewEffectDer, OldAer, OldDer, NowTime,
                        IsFirstDer, IsAtt, AttX, AttY, AttAngle, Broadcast, NewBAPassiveArgs)
            end;
        _ ->
            calc_passive_skill(T, SkillPassive, Aer, Der, OldAer, OldDer, NowTime, IsFirstDer, IsAtt, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs)
    end.

%% 计算被动属性技能效果
calc_passive_attr_effect([{K, BuffType, PerMil, AffectedParties, Int, Float, LastTime, Stack, EffectId}|T],
        Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, BroadCast, BAPassiveArgs)->
    case urand:ge_rand(1, ?SKILL_PROB_C, PerMil) of
        true ->
            case check_passive_buff_effect_trigger(K, AffectedParties, Aer, Der, Trigger, BAPassiveArgs) of
                false ->
                    calc_passive_attr_effect(T, Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, BroadCast, BAPassiveArgs);
                {true, Aer1, Der1} ->
                    {User10, UserBuffL, OldUser} = get_affected_parties(AffectedParties, Aer1, AerBuffList, Der1, DerBuffList, OldAer, OldDer),
                    {User2, UserBuffL2}
                        = case K of
                              ?SPEED ->
                                  case calc_buff_swap(K, BuffType, Int, Float, LastTime, Stack, EffectId, K, SkillId, SkillLv, NowTime, UserBuffL) of
                                      {true, BuffList} ->
                                          {calc_speed(User10, OldUser, OldUser#battle_status.battle_attr#battle_attr.attr_buff_list++BuffList,
                                                      LastTime, NowTime, BroadCast), BuffList};
                                      {false, _} -> {User10, UserBuffL}
                                  end;
                              _ ->
                                  UserBA = User10#battle_status.battle_attr,
                                  Value = value_cate(Int, Float, K, lib_player_attr:get_value_by_id(K, UserBA#battle_attr.attr),
                                                     lib_player_attr:get_value_by_id(K, OldUser#battle_status.battle_attr#battle_attr.attr)),
                                  Attr1 = lib_player_attr:set_value_by_id(K, Value, UserBA#battle_attr.attr),
                                  User1 = User10#battle_status{battle_attr=UserBA#battle_attr{attr=Attr1}},
                                  %% 加入属性buff列表
                                  case LastTime =< 0 of
                                      true  -> {User1, UserBuffL};
                                      false ->
                                          {_, TmpBuffL} = calc_buff_swap(K, BuffType, Int, Float, LastTime, Stack, EffectId, K, SkillId, SkillLv, NowTime, UserBuffL),
                                          {User1, TmpBuffL}
                                  end
                          end,
                    {Aer2, AerBuffL2, Der2, DerBuffL2} = set_affected_parties(AffectedParties, Aer1, AerBuffList, Der1, DerBuffList, User2, UserBuffL2),
                    NBAPassiveArgs = BAPassiveArgs#battle_passive_args{is_trigger = 1},
                    calc_passive_attr_effect(T, Trigger, Aer2, Der2, AerBuffL2, DerBuffL2, NowTime, SkillId, SkillLv, OldAer, OldDer, BroadCast, NBAPassiveArgs)
            end;
        _ ->
            calc_passive_attr_effect(T, Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, BroadCast, BAPassiveArgs)
    end;
calc_passive_attr_effect([_H|T], Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, BroadCast, BAPassiveArgs)->
    calc_passive_attr_effect(T, Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, BroadCast, BAPassiveArgs);
calc_passive_attr_effect([], _Trigger, Aer, Der, AerBuffList, DerBuffList, _NowTime, _SkillId, _SkillLv, _OldAer, _OldDer, _BroadCast, BAPassiveArgs)->
    AerBA = Aer#battle_status.battle_attr, DerBA = Der#battle_status.battle_attr,
    {Aer#battle_status{battle_attr=AerBA#battle_attr{attr_buff_list=AerBuffList}},
        Der#battle_status{battle_attr=DerBA#battle_attr{attr_buff_list=DerBuffList}},
        BAPassiveArgs#battle_passive_args.is_trigger}.


%% 计算被动的特殊效果
calc_passive_other_effect([{K, BuffType, PerMil, AffectedParties, Int, Float, AttrId, LastTime, _Num, EffectId}=H|T], Trigger, Aer, Der, AerBuffList,
        DerBuffList, NowTime, SkillId, SkillLv, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs) ->
    {User, UserBuffL, OldUser} = get_affected_parties(AffectedParties, Aer, AerBuffList, Der, DerBuffList, OldAer, OldDer),
    %% 检查触发条件
    case check_passive_buff_effect_trigger(K, AffectedParties, Aer, Der, Trigger, BAPassiveArgs) of
        false ->
            % ?IF(K ==124 andalso SkillId == 480111, ?PRINT("SkillId:~p Trigger:~p ~n", [SkillId, Trigger]), skip),
            calc_passive_other_effect(T, Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv,
                OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs);
        {true, AerAfCk, DerAfCk} ->
            % ?IF(K ==124 andalso SkillId == 480111, ?PRINT("=====SkillId:~p H:~p ~n", [SkillId, H]), skip),
            {User1, _UserBuffL, _OldUser} = get_affected_parties(AffectedParties, AerAfCk, AerBuffList, DerAfCk, DerBuffList, OldAer, OldDer),
            UserBA = User1#battle_status.battle_attr,
            UserSE = UserBA#battle_attr.skill_effect,
            #battle_passive_args{trigger_time = TriggerTime} = BAPassiveArgs,
            PerMilAfSkill = if
                SkillId == ?SP_SKILL_HOPE andalso TriggerTime == ?SKILL_BUFF_TG_TIME_DEFAF andalso %% 秘境技能5,防守者被攻击后触发 天赋技能提高概率
                    Aer#battle_status.battle_attr#battle_attr.hope_minus_cd =/= 0 -> PerMil + 1000;
                TriggerTime == ?SKILL_BUFF_TG_TIME_DEFAF ->
                    PerMil + lib_sec_player_attr:get_value_to_int(Aer#battle_status.battle_attr#battle_attr.sec_attr, ?SKILL_TRIGGER_PERMIL, SkillId);
                true -> PerMil
            end,
            PerMilAfBuff = PerMilAfSkill + lib_sec_player_attr:get_value_to_int(Aer#battle_status.battle_attr#battle_attr.sec_attr, ?SKILL_BUFF_PERMIL, K),
            NewPerMil = PerMilAfBuff,
            % 1:不是无敌触发;若处于无敌时,控制和减益buff不生效
            % 2:控制buff时,免疫控制和霸体不生效
            % 3:概率判断
            case ((UserSE#skill_effect.immue == 0) orelse (BuffType =/= ?SKILL_CTRL_BUFF andalso BuffType =/= ?SKILL_DEBUFF)) andalso
                (BuffType/= ?SKILL_CTRL_BUFF orelse (UserSE#skill_effect.superarmor == 0 andalso User#battle_status.is_armor==0))
                andalso urand:ge_rand(1, ?SKILL_PROB_C, NewPerMil) of
                true when LastTime > 0 ->
                    {Int1, Float1}
                        = if  AttrId > 0 ->
                                  {value_cate(Int, Float, AttrId, 0, lib_player_attr:get_value_by_id(AttrId, OldUser#battle_status.battle_attr#battle_attr.attr)), 0};
                              true -> {Int, Float}
                          end,
                    NewLastTime = LastTime + lib_sec_player_attr:get_value_to_int(Aer#battle_status.battle_attr#battle_attr.sec_attr, ?SKILL_BUFF_PERMIL, K),
                    case calc_buff_swap(K, BuffType, Int1, Float1, NewLastTime, 0, EffectId, AttrId, SkillId, SkillLv, NowTime, UserBuffL) of
                        {true, BuffList} ->
                            % ?IF(K ==104, ?PRINT("=====SkillId:~p H:~p BuffList:~p~n", [SkillId, H, BuffList]), skip),
                            {CalcComboBuffUser, CalcComboBuffL}
                                = case BuffType of
                                      ?SKILL_CTRL_BUFF -> %% 控制技能
                                          {User1#battle_status{skill_combo=[], shaking_skill=0,
                                                               battle_attr=UserBA#battle_attr{skill_effect=UserSE#skill_effect{interrupt=User#battle_status.shaking_skill}}},
                                           del_all_combo_buff(BuffList, [])};
                                      _ -> {User1, BuffList}
                                  end,
                            {Aer1, AerBuffL1, Der1, DerBuffL1} = set_affected_parties(AffectedParties, AerAfCk, AerBuffList, Der,
                                                                                      DerBuffList, CalcComboBuffUser, CalcComboBuffL),
                            NBAPassiveArgs = BAPassiveArgs#battle_passive_args{is_trigger = 1, skill_id = SkillId},
                            {Aer2, AerBuffL2, Der2, DerBuffL2}
                                = calc_sp_effect(H, Aer1, AerBuffL1, Der1, DerBuffL1, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, NowTime, Broadcast, NBAPassiveArgs),
                            calc_passive_other_effect(T, Trigger, Aer2, Der2, AerBuffL2, DerBuffL2, NowTime, SkillId,
                                                      SkillLv, OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast, NBAPassiveArgs);
                        {false, _} ->
                            % ?IF(K ==104, ?PRINT("=====SkillId:~p H:~p ~n", [SkillId, H]), skip),
                            calc_passive_other_effect(T, Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv,
                                                      OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs)
                    end;
                true ->
                    % ?IF(K ==104 andalso SkillId == 366321205, ?PRINT("=====SkillId:~p H:~p ~n", [SkillId, H]), skip),
                    {Aer1, AerBuffL1, Der1, DerBuffL1} = set_affected_parties(AffectedParties, AerAfCk, AerBuffList, DerAfCk, DerBuffList, User1, UserBuffL),
                    NBAPassiveArgs = BAPassiveArgs#battle_passive_args{is_trigger = 1, skill_id = SkillId},
                    {Aer2, AerBuffL2, Der2, DerBuffL2} = calc_sp_effect(H, Aer1, AerBuffL1, Der1, DerBuffL1, OldAer,
                                                                        OldDer, IsFirstDer, AttX, AttY, AttAngle, NowTime, Broadcast, NBAPassiveArgs),
                    calc_passive_other_effect(T, Trigger, Aer2, Der2, AerBuffL2, DerBuffL2, NowTime, SkillId, SkillLv,
                                              OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast, NBAPassiveArgs);
                false ->
                    % ?IF(K ==104, 
                        % ?PRINT("=====SkillId:~p H:~p immue:~p BuffType:~p superarmor:~p is_armor:~p ~n", 
                            % [SkillId, H, UserSE#skill_effect.immue, BuffType, UserSE#skill_effect.superarmor, User#battle_status.is_armor]), skip),
                    calc_passive_other_effect(T, Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv,
                                              OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs)
            end
    end;
calc_passive_other_effect([_|T], Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv,
                          OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs) ->
    calc_passive_other_effect(T, Trigger, Aer, Der, AerBuffList, DerBuffList, NowTime, SkillId, SkillLv,
                              OldAer, OldDer, IsFirstDer, AttX, AttY, AttAngle, Broadcast, BAPassiveArgs);
calc_passive_other_effect([], _Trigger, #battle_status{battle_attr=AerBA}=Aer, #battle_status{battle_attr=DerBA}=Der,
                          AerBuffList, DerBuffList, _NowTime, _SkillId, _SkillLv, _OldAer, _OldDer, _IsFirstDer, _AttX, _AttY, _AttAngle, _Broadcast, BAPassiveArgs) ->
    {Aer#battle_status{battle_attr = AerBA#battle_attr{other_buff_list=AerBuffList}},
     Der#battle_status{battle_attr = DerBA#battle_attr{other_buff_list=DerBuffList}},
     BAPassiveArgs#battle_passive_args.is_trigger}.

%% 被动技能触发检查
%% BfAttOrAfAtt:
%% TriggerTime:1攻击者计算伤害前触发; 2防守者计算伤害前触发; 3攻击者计算伤害后触发; 4防守者计算伤害后触发
check_passive_buff_effect_trigger(_K, _BuffAffectedParties, _Aer, _Der, [], _BAPassiveArgs) -> false;
check_passive_buff_effect_trigger(K, BuffAffectedParties, Aer, Der, [{TgType, PerMil, TriggerAffectedParties, TriggerTime, _, Float, SBuffId, K} = _H|T], BAPassiveArgs) ->
    % ?IF(K==116, %andalso BAPassiveArgs#battle_passive_args.battle_skill_id == 370004,
    %     ?PRINT("_H:~p TgType:~p, CfgTriggerTime:~p trigger_time:~p skill_id:~p~n", 
    %         [_H, TgType, TriggerTime, BAPassiveArgs#battle_passive_args.trigger_time, BAPassiveArgs#battle_passive_args.skill_id]), 
    %     skip),
    case TriggerAffectedParties == 0 of
        true -> AffectedParties = BuffAffectedParties;
        false -> AffectedParties = TriggerAffectedParties
    end,
    % 是否要算真实玩家
    {User, _, _} = get_affected_parties(AffectedParties, Aer, [], Der, [], [], []),
    case urand:ge_rand(1, ?SKILL_PROB_C, PerMil) of
        true ->
            Result = if
                % 特殊血量不分攻击前后触发
                TgType == ?SKILL_BUFF_TRIGGER_HP andalso TriggerTime == ?SKILL_BUFF_TG_TIME ->
                    #battle_status{battle_attr = BA} = User,
                    #battle_attr{hp = Hp, hp_lim = DerHpLim} = BA,
                    ?IF(Hp/DerHpLim =< Float, {true, User}, false);
                %
                TriggerTime == BAPassiveArgs#battle_passive_args.trigger_time ->
                    #battle_passive_args{aer = PassiveAer, der = PassiveDer, hurt_type = HurtType, sec_hurt_type = SecHurtType, hp = Hp} = BAPassiveArgs,
                    #battle_status{battle_attr = BA, sign = Sign, id = Id} = User,
                    %% #battle_status{sign = AttSign} = Aer,
                    %% #battle_status{sign = DerSign} = Der,
                    if
                        TgType == ?SKILL_BUFF_TRIGGER -> {true, User}; %% 无条件触发

                        TgType == ?SKILL_BUFF_TRIGGER_GET ->     %% 受到某个特殊效果触发
                            case PassiveDer of 
                                #battle_status{id = Id, sign = Sign} -> OldUser = PassiveDer;
                                _ -> OldUser = PassiveAer
                            end,
                            #battle_status{battle_attr = OBA} = OldUser,
                            BfHave = case lists:keymember(SBuffId, 1, OBA#battle_attr.attr_buff_list) of
                                true -> true;
                                false -> lists:keymember(SBuffId, 1, OBA#battle_attr.other_buff_list)
                            end,
                            AfHave = case lists:keymember(SBuffId, 1, BA#battle_attr.attr_buff_list) of
                                true -> true;
                                false -> lists:keymember(SBuffId, 1, BA#battle_attr.other_buff_list)
                            end,
                            % ?IF(K==117, ?PRINT("BfHave:~p AfHave:~p ~n", [BfHave, AfHave]), skip),
                            if
                                not BfHave andalso AfHave -> %% 没有,有
                                    if
                                        K == ?SPBUFF_UNDIZZY -> %%
                                            SkillEffect = BA#battle_attr.skill_effect,
                                            NewSkillEffect = SkillEffect#skill_effect{current_un_dizzy = 1},
                                            {true, User#battle_status{battle_attr = BA#battle_attr{skill_effect = NewSkillEffect}}};
                                        true ->
                                            {true, User}
                                    end;
                                true -> false
                            end;

                        TgType == ?SKILL_BUFF_TRIGGER_HAVE -> %% 身上有某种特殊效果触发
                            % ?IF(SBuffId==126 andalso K==123, ?PRINT("BfHave AfHave Id:~p=============== ~n", [User#battle_status.id]), skip),
                            case lists:keymember(SBuffId, 1, BA#battle_attr.attr_buff_list) of
                                true -> {true, User};
                                false -> ?IF(lists:keymember(SBuffId, 1, BA#battle_attr.other_buff_list), {true, User}, false)
                            end;

                        TgType == ?SKILL_BUFF_TRIGGER_HP -> %% 血量触发
                            #battle_attr{hp = DerHp, hp_lim = DerHpLim} = BA,
                            ?IF(DerHp/DerHpLim =< Float, {true, User}, false);
                            % {true, User};

                        TgType == ?SKILL_BUFF_TRIGGER_CRIT andalso HurtType == ?HURT_TYPE_CRIT -> %% 暴击时触发
                            % ?PRINT("_H:~p ~n", [_H]),
                            {true, User};

                        TgType == ?SKILL_BUFF_TRIGGER_HPRESUME -> %% 不会在这里处理回血触发的被动技能
                            false;

                        Hp =< 0 andalso TgType == ?SKILL_BUFF_TRIGGER_DIE -> %% 玩家死亡触发,免疫本次伤害
                            % ?IF(K==116, ?PRINT("ok====================~n", []), skip),
                            SkillEffect = BA#battle_attr.skill_effect,
                            NewSkillEffect = SkillEffect#skill_effect{un_die = 1},
                            case PassiveDer of 
                                #battle_status{id = Id, sign = Sign} -> OldUser = PassiveDer;
                                _ -> OldUser = PassiveAer
                            end,
                            #battle_attr{hp = UserHp, hp_lim = UserHpLim} = BA,
                            #battle_status{battle_attr = #battle_attr{hp = OldHp}} = OldUser,
                            % 免疫本次伤害,赋值之前的血量
                            case UserHp > 0 of
                                true -> NewHp = UserHp;
                                false -> NewHp = min(UserHpLim, max(1, OldHp))
                            end,
                            {true, User#battle_status{battle_attr = BA#battle_attr{hp = NewHp, skill_effect = NewSkillEffect}}};

                        TgType == ?SKILL_BUFF_TRIGGER_MISS andalso HurtType == ?HURT_TYPE_MISS -> %% 闪避时触发
                            {true, User};

                        %% Hp =/= null andalso AttSign == ?BATTLE_SIGN_MON andalso DerSign == ?BATTLE_SIGN_PLAYER->
                        %%     {true, User};

                        TgType == ?SKILL_BUFF_TRIGGER_PARRY andalso SecHurtType == ?HURT_TYPE_PARRY ->
                            % ?PRINT("_H:~p ~n", [_H]),
                            {true, User};

                        TgType == ?SKILL_BUFF_TRIGGER_HEART andalso HurtType == ?HURT_TYPE_HEART ->
                            {true, User};

                        true ->
                            false
                    end;
                true ->
                    cycle
                    % check_passive_buff_effect_trigger(K, User, Aer, Der, T, BAPassiveArgs)
            end,
            case Result of
                cycle -> check_passive_buff_effect_trigger(K, BuffAffectedParties, Aer, Der, T, BAPassiveArgs);
                false -> false;
                {true, NewUser} ->
                    {Aer2, _, Der2, _} = set_affected_parties(AffectedParties, Aer, [], Der, [], NewUser, []),
                    % ?IF(K==116, 
                    %     ?PRINT("AffectedParties:~p Aerid:~p Aer2id:~p Aer2:~p Derid:~p Der2id:~p Der2:~p userid:~p user2id:~p~n", 
                    %         [
                    %             AffectedParties,
                    %             Aer#battle_status.id,
                    %             Aer2#battle_status.id,
                    %             Aer2#battle_status.battle_attr#battle_attr.skill_effect#skill_effect.un_die, 
                    %             Der#battle_status.id,
                    %             Der2#battle_status.id,
                    %             Der2#battle_status.battle_attr#battle_attr.skill_effect#skill_effect.un_die,
                    %             User#battle_status.id,
                    %             NewUser#battle_status.id]),
                    %     skip
                    %     ),
                    {true, Aer2, Der2}
            end;
        false ->
            false
    end;
check_passive_buff_effect_trigger(K, BuffAffectedParties, Aer, Der, [_H|T], BAPassiveArgs) ->
    check_passive_buff_effect_trigger(K, BuffAffectedParties, Aer, Der, T, BAPassiveArgs).

%% 检查被动属性
check_passive_skill([{cd}|T], SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der) ->
    case lists:keyfind(SkillId, 1, SkillCds) of
        {_, EndTime} when EndTime > NowTime -> false;
        _ -> check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der)
    end;
check_passive_skill([{prob, Prob}|T], SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der) ->
    case urand:ge_rand(1, ?SKILL_PROB_C, Prob) of
        true -> check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
        false -> false
    end;
check_passive_skill([{aer_sign, AerSign}|T], SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der) ->
    #battle_passive_args{aer = PassiveAer} = BAPassiveArgs,
    case PassiveAer of
        #battle_status{sign = AerSign} -> check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
        _ -> false
    end;
check_passive_skill([{der_sign, DerSign}|T], SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der) ->
    #battle_passive_args{der = PassiveDer} = BAPassiveArgs,
    case PassiveDer of
        #battle_status{sign = DerSign} -> check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
        _ -> false
    end;
%% 指定攻击的技能才能触发
check_passive_skill([{skill_id_list, SkillIdList}|T], SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der) ->
    #battle_passive_args{battle_skill_id = BattleSkillId} = BAPassiveArgs,
    % ?PRINT("SkillId:~p SkillIdList:~p ~n", [BattleSkillId, SkillIdList]),
    case lists:member(BattleSkillId, SkillIdList) of
        true -> check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
        false -> false
    end;
%% 前置触发技能id
check_passive_skill([{pre_trigger_skill_id, PreSkillId}|T], SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der) -> 
    #battle_passive_args{ok_passive_list = OkPassiveList} = BAPassiveArgs,
    % ?PRINT("SkillId:~p SkillIdList:~p ~n", [BattleSkillId, SkillIdList]),
    % ?MYLOG("hjhskill", "PreSkillId:~p OkPassiveList:~p ~n", [PreSkillId, OkPassiveList]),
    case lists:member(PreSkillId, OkPassiveList) of
        true -> check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
        false -> false
    end;
%% 当前技能calc字段匹配
check_passive_skill([{skill_calc_hurt, SkillCalc}|T], SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der) ->
    #battle_passive_args{skill_calc_hurt = Calc} = BAPassiveArgs,
    case Calc == SkillCalc of
        true -> check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
        false -> false
    end;

%% 触发扩展[TODO-hjh:后续处理]
% check_passive_skill([{trigger, TriggerType, TriggerAffectedParties, TriggerTime, _Int, Float, SBuffId}|T], SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der) -> 
%     #battle_passive_args{aer = PassiveAer, der = PassiveDer, hurt_type = HurtType, sec_hurt_type = SecHurtType, hp = _Hp} = BAPassiveArgs,
%     {User, _, _} = get_affected_parties(TriggerAffectedParties, Aer, [], Der, [], [], []),
%     if
%         TriggerTime == BAPassiveArgs#battle_passive_args.trigger_time ->
%             #battle_status{battle_attr = BA, sign = Sign, id = Id} = User,
%             if
%                 TriggerType == ?SKILL_BUFF_TRIGGER -> check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);

%                 TriggerType == ?SKILL_BUFF_TRIGGER_GET ->     %% 受到某个特殊效果触发
%                     case PassiveDer of 
%                         #battle_status{id = Id, sign = Sign} -> OldUser = PassiveDer;
%                         _ -> OldUser = PassiveAer
%                     end,
%                     #battle_status{battle_attr = OBA} = OldUser,
%                     BfHave = case lists:keymember(SBuffId, 1, OBA#battle_attr.attr_buff_list) of
%                         true -> true;
%                         false -> lists:keymember(SBuffId, 1, OBA#battle_attr.other_buff_list)
%                     end,
%                     AfHave = case lists:keymember(SBuffId, 1, BA#battle_attr.attr_buff_list) of
%                         true -> true;
%                         false -> lists:keymember(SBuffId, 1, BA#battle_attr.other_buff_list)
%                     end,
%                     % ?IF(K==117, ?PRINT("BfHave:~p AfHave:~p ~n", [BfHave, AfHave]), skip),
%                     if
%                         not BfHave andalso AfHave -> %% 没有,有
%                             check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
%                         true -> 
%                             false
%                     end;

%                 TriggerType == ?SKILL_BUFF_TRIGGER_HAVE -> %% 身上有某种特殊效果触发
%                     % ?IF(SBuffId==101 andalso K==116, ?PRINT("BfHave AfHave Id:~p=============== ~n", [User#battle_status.id]), skip),
%                     case lists:keymember(SBuffId, 1, BA#battle_attr.attr_buff_list) of
%                         true -> check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
%                         false -> 
%                             ?IF(lists:keymember(SBuffId, 1, BA#battle_attr.other_buff_list), 
%                                 check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der), 
%                                 false)
%                     end;

%                 TriggerType == ?SKILL_BUFF_TRIGGER_HP -> %% 血量触发
%                     #battle_attr{hp = DerHp, hp_lim = DerHpLim} = BA,
%                     ?IF(DerHp/DerHpLim =< Float, check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der), false);

%                 TriggerType == ?SKILL_BUFF_TRIGGER_CRIT andalso HurtType == ?HURT_TYPE_CRIT ->  %% 暴击时触发
%                     check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
%                 TriggerType == ?SKILL_BUFF_TRIGGER_MISS andalso HurtType == ?HURT_TYPE_MISS ->  %% 闪避时触发
%                     check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
%                 TriggerType == ?SKILL_BUFF_TRIGGER_PARRY andalso SecHurtType == ?HURT_TYPE_PARRY -> %% 格挡时触发
%                     check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
%                 TriggerType == ?SKILL_BUFF_TRIGGER_HEART andalso HurtType == ?HURT_TYPE_HEART -> %% 会心时触发
%                     check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
%                 true ->
%                     false
%             end;
%         true ->
%             false
%     end;

check_passive_skill([{trigger, TriggerType, _TriggerAffectedParties, TriggerTime, _Int, _Float, _SBuffId}|T], SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der) -> 
    #battle_passive_args{hurt_type = HurtType, sec_hurt_type = SecHurtType} = BAPassiveArgs,
    if
        TriggerTime == BAPassiveArgs#battle_passive_args.trigger_time ->
            if
                TriggerType == ?SKILL_BUFF_TRIGGER -> check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
                TriggerType == ?SKILL_BUFF_TRIGGER_CRIT andalso HurtType == ?HURT_TYPE_CRIT ->  %% 暴击时触发
                    check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
                TriggerType == ?SKILL_BUFF_TRIGGER_MISS andalso HurtType == ?HURT_TYPE_MISS ->  %% 闪避时触发
                    check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
                TriggerType == ?SKILL_BUFF_TRIGGER_PARRY andalso SecHurtType == ?HURT_TYPE_PARRY -> %% 格挡时触发
                    check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
                TriggerType == ?SKILL_BUFF_TRIGGER_HEART andalso HurtType == ?HURT_TYPE_HEART -> %% 会心时触发
                    check_passive_skill(T, SkillId, SkillCds, NowTime, BAPassiveArgs, Aer, Der);
                true ->
                    false
            end;
        true ->
            false
    end;

check_passive_skill([_|_T], _SkillId, _SkillCds, _NowTime, _BAPassiveArgs, _Aer, _Der) -> 
    false;
check_passive_skill([], _SkillId, _SkillCds, _NowTime, _BAPassiveArgs, _Aer, _Der) -> 
    true.

%% 作为有图标的buff必须满足以下条件
%% 概率100%
%% 所有效果持续时间一致
skill_buff_to_goods_buff(SkillId, SkillLv) ->
    case data_skill:get_lv_data(SkillId, SkillLv) of
        % [{属性类型ID,buff类型,概率,作用方,整数值,小数值,持续时间,叠加层数,特效id},...]
        #skill_lv{attr = [{_, _, _, _, _, _, Time, _, _}|_] = Attr} ->
            F = fun
                ({AttrId, _, ?RATIO_COEFFICIENT, _, Int, _, _, _, _}, Acc) ->
                    case lists:keyfind(AttrId, 1, Acc) of
                        {_, V} ->
                            lists:keystore(AttrId, 1, Acc, {AttrId, V + Int});
                        _ ->
                            [{AttrId, Int}|Acc]
                    end;
                (_, Acc) -> Acc
            end,
            EffectList = lists:foldl(F, [], Attr),
            {SkillId, Time, EffectList};
        _ ->
            undefined
    end.

calc_sprint_pos(OX, OY, AttX, AttY, Offset) ->
    if
        OX == AttX -> {OX, AttY-80};
        OY == AttY -> {OX-80, AttY};
        true ->
            Distance = umath:distance({AttX, AttY}, {OX, OY}),
            if
                Distance =< Offset -> {OX, OY};
                true ->
                    Unit = 1/Distance*Offset,
                    {round(AttX - (AttX - OX)*Unit), round(AttY - (AttY - OY)*Unit)}
            end
    end.

% 添加本次触发正在使用过的技能
add_trigger_skill(#battle_status{trigger_skill = TriggerSkillL, sign = ?BATTLE_SIGN_PLAYER} = Aer, true, SkillId) ->
    case is_floating_skill(SkillId) of
        true  -> NewTriggerSkillL = [SkillId|lists:delete(SkillId, TriggerSkillL)];
        _ -> NewTriggerSkillL = TriggerSkillL
    end,
    Aer#battle_status{trigger_skill = NewTriggerSkillL};
add_trigger_skill(Aer, _, _SkillId) -> Aer.

% 添加本次触发正在使用过的技能
add_be_trigger_skill(#battle_status{be_trigger_skill = TriggerSkillL, sign = ?BATTLE_SIGN_PLAYER} = Der, SkillId) ->
    case is_floating_skill(SkillId) of
        true -> NewTriggerSkillL = [SkillId|lists:delete(SkillId, TriggerSkillL)];
        _ -> NewTriggerSkillL = TriggerSkillL
    end,
    Der#battle_status{be_trigger_skill = NewTriggerSkillL};
add_be_trigger_skill(Der, _) ->
    Der.

is_floating_skill(SkillId) ->
    SkillList = data_key_value:get(20001),
    is_list(SkillList) andalso lists:member(SkillId, SkillList).


