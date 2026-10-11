%%%------------------------------------
%%% @Module  : mod_battle
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2010.05.18
%%% @Description: 战斗
%%%------------------------------------
-module(mod_battle).
-compile(export_all).
-include("scene.hrl").
-include("server.hrl").
-include("skill.hrl").
-include("battle.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("career.hrl").
-include("team.hrl").
-include("boss.hrl").
-include("eudemons_land.hrl").
-include("def_fun.hrl").
-include("husong.hrl").
-include("role.hrl").
-include("def_module.hrl").
-include("god.hrl").

%% @spec -> {true, #ets_scene_user | #scene_object } | {false, ErrCode, #ets_scene_user | #scene_object}
%% 玩家和怪物发起攻击
%% @end
battle(BattleExtraArgs, EtsScene) ->
    #battle_args{
        att_user = OriginalAer,         %% 场景上的玩家或者怪物数据
        der_list = DerList,
        is_combo = IsCombo,
        skill_id = SkillId,
        skill_lv = SkillLv,
        now_time = NowTime,
        att_x    = AttX,
        att_y    = AttY,
        att_angle = AttAngle,
        sign     = Sign} = BattleExtraArgs,
    %% 将场景上的玩家或者怪物数据转成#battle_status{}必要的战斗数据
    case lib_battle_util:trans_to_real_atter(OriginalAer, Sign) of
        false ->
            % ?PRINT("SkillId:~p Sign:~p ~n", [SkillId, Sign]),
            {false, 0, OriginalAer};
        #battle_status{last_skill_id = OLastSkillId} = Aer ->
            % ?MYLOG(Aer#battle_status.mid==3602101, "hjhaibattle22", "battle SkillId:~p SkillLv:~p ~n", [SkillId, SkillLv]),
            %% 判断玩家是不是处理特殊状态
            case lib_battle_util:check_use_skill(Aer, IsCombo, SkillId, SkillLv, NowTime, Sign) of
                {true, AfterEffAer, #skill{is_shake_pre=1}=_SkillR, _} ->
                    %% AfHideAer = break_steath(Aer, AfterEffAer#battle_status{shaking_skill=SkillId}, SkillR, EtsScene),
                    AfShakeAer = AfterEffAer, %AfterEffAer#battle_status{shaking_skill=SkillId},
                    LastSkillId = lib_battle:update_last_normal_skill(SkillId, SkillLv, OLastSkillId),
                    EtsAer = lib_battle_util:back_data(AfShakeAer#battle_status{last_skill_id=LastSkillId}, OriginalAer),
                    send_active_msg(AfShakeAer, EtsAer, [], SkillId, SkillLv, AttX, AttY, AttAngle,
                        Aer#battle_status.x, Aer#battle_status.y, EtsScene#ets_scene.broadcast, NowTime, EtsScene),
                    {true, EtsAer, SkillId};

                {true, AfterEffAer, #skill{is_att=0}=_SkillR, MainSkillId} ->
                    LastSkillId = lib_battle:update_last_normal_skill(SkillId, SkillLv, OLastSkillId),
                    EtsAer = lib_battle_util:back_data(AfterEffAer#battle_status{last_skill_id=LastSkillId}, OriginalAer),
                    InitDerList = [lib_battle_util:init_data(Der) || Der <- DerList],
                    NoHurtDerList = [[DSign, XId, DHp, 0, 0, 0, 0, 0, DX, DY, 0, 0,
                        lib_skill_buff:pack_buff(DAttrBuffL ++ DOBuffL, NowTime, [])]||
                        #battle_status{
                            sign = DSign, id = XId,  x = DX, y = DY,
                            battle_attr = #battle_attr{hp = DHp, attr_buff_list = DAttrBuffL, other_buff_list = DOBuffL}
                        }<-InitDerList],
                    send_active_msg(AfterEffAer, EtsAer, NoHurtDerList, SkillId, SkillLv, AttX, AttY, AttAngle,
                        Aer#battle_status.x, Aer#battle_status.y, EtsScene#ets_scene.broadcast, NowTime, EtsScene),
                    {true, EtsAer, MainSkillId};

                {true, AfterEffAer, SkillR, MainSkillId} ->
                    %% 攻击触发采取初始化防守者
                    InitDerList = [lib_battle_util:init_data(Der) || Der <- DerList],
                    NewBattleExtraArgs = BattleExtraArgs#battle_args{der_list=InitDerList},
                    {AfBattleAer, DefList} = skill(AfterEffAer, NewBattleExtraArgs, SkillR, MainSkillId, EtsScene),
                    %% 玩家发起攻击触发圣灵等额外主动技能的触发，玩家受击触发在battle_info消息下面触发
                    if
                        Sign =/= ?BATTLE_SIGN_PLAYER -> skip;
                        true ->
                            %% 在触发条件下面判断各种其他技能的触发条件
                            send_to_node_pid(Aer#battle_status.node, Aer#battle_status.pid, {'trigger_special_active_skill'})
                    end,
                    LastSkillId = lib_battle:update_last_normal_skill(SkillId, SkillLv, OLastSkillId),
                    EtsAer = lib_battle_util:back_data(AfBattleAer#battle_status{last_skill_id=LastSkillId}, OriginalAer),
                    send_active_msg(AfBattleAer, EtsAer, DefList, SkillId, SkillLv, AttX, AttY, AttAngle,
                        Aer#battle_status.x, Aer#battle_status.y, EtsScene#ets_scene.broadcast, NowTime, EtsScene),
                    {true, EtsAer, MainSkillId};

                {false, ErrCode, AfterEffAer} ->
                    % ?MYLOG(Aer#battle_status.mid==3602101 andalso (SkillId == 3602021 orelse SkillId == 3602022),
                    %     "hjhaibattle1", "battle false SkillId:~p SkillLv:~p ErrCode:~p ~n", [SkillId, SkillLv, ErrCode]),
                    % ?PRINT("SkillId:~p ErrCode:~p ~n", [SkillId, ErrCode]),
                    % ?MYLOG(SkillId==100101, "hjhaibattle", "battle SkillId:~p ErrCode:~p~n",
                    %     [SkillId, ErrCode]),
                    ?MYLOG(ErrCode==45, "skill", "Id:~p Sign:~p SkillId:~p longunixtime:~p, ErrCode:~p ~n",
                        [Aer#battle_status.id, Aer#battle_status.sign, SkillId, NowTime, ErrCode]),
                    {false, ErrCode, AfterEffAer}
            end
    end.

%% 辅助技能释放
assist(OriginalAer, OriginalDer, IsCombo, SkillId, SkillLv, EtsScene) ->
    NowTime = utime:longunixtime(),
    %% 初始数据
    Aer = lib_battle_util:init_data(OriginalAer),
    Der = lib_battle_util:init_data(OriginalDer),
    case lib_battle_util:check_use_skill(Aer, IsCombo, SkillId, SkillLv, NowTime, Aer#battle_status.sign) of
        {false, ErrCode, AfterEffAer} ->
            {false, ErrCode, AfterEffAer};

        {true, AfterEffAer, #skill{is_shake_pre=1}=_SkillR, MainSkillId} ->
            DBuffList = lib_skill_buff:pack_buff(
                AfterEffAer#battle_status.battle_attr#battle_attr.attr_buff_list++AfterEffAer#battle_status.battle_attr#battle_attr.other_buff_list,
                NowTime, []),
            AssistList = [[AfterEffAer#battle_status.sign, AfterEffAer#battle_status.id, AfterEffAer#battle_status.battle_attr#battle_attr.hp, DBuffList]],
            send_assist_msg(Aer#battle_status.sign, Aer#battle_status.id, SkillId, SkillLv, AssistList,
                Aer#battle_status.copy_id, Aer#battle_status.x, Aer#battle_status.y, EtsScene#ets_scene.broadcast),
            %% 打破隐身
            %% AfHideAer = break_steath(Aer, AfterEffAer, SkillR, EtsScene),
            #battle_status{last_skill_id = OLastSkillId} = AfterEffAer,
            LastSkillId = lib_battle:update_last_normal_skill(SkillId, SkillLv, OLastSkillId),
            {true, lib_battle_util:back_data(AfterEffAer#battle_status{shaking_skill=SkillId,last_skill_id=LastSkillId}, OriginalAer), MainSkillId};

        {true, AfterEffAer, #skill{is_att=0}=_SkillR, MainSkillId} ->
            DBuffList = lib_skill_buff:pack_buff(
                AfterEffAer#battle_status.battle_attr#battle_attr.attr_buff_list++AfterEffAer#battle_status.battle_attr#battle_attr.other_buff_list,
                NowTime, []),
            AssistList = [[AfterEffAer#battle_status.sign, AfterEffAer#battle_status.id, AfterEffAer#battle_status.battle_attr#battle_attr.hp, DBuffList]],
            send_assist_msg(Aer#battle_status.sign, Aer#battle_status.id, SkillId, SkillLv, AssistList,
                Aer#battle_status.copy_id, Aer#battle_status.x, Aer#battle_status.y, EtsScene#ets_scene.broadcast),
            %% 打破隐身
            %% AfHideAer = break_steath(Aer, AfterEffAer, SkillR, EtsScene),
            #battle_status{last_skill_id = OLastSkillId} = AfterEffAer,
            LastSkillId = lib_battle:update_last_normal_skill(SkillId, SkillLv, OLastSkillId),
            {true, lib_battle_util:back_data(AfterEffAer#battle_status{shaking_skill=SkillId,last_skill_id=LastSkillId}, OriginalAer), MainSkillId};

        {true, AfterEffAer, SkillR, MainSkillId} ->
            AssistAer = assist_skill(AfterEffAer, Der, SkillR, NowTime, EtsScene),
            #battle_status{last_skill_id = OLastSkillId} = AssistAer,
            LastSkillId = lib_battle:update_last_normal_skill(SkillId, SkillLv, OLastSkillId),
            %% AfHideAer = break_steath(Aer, AssistAer, SkillR, EtsScene),
            {true, lib_battle_util:back_data(AssistAer#battle_status{last_skill_id=LastSkillId}, OriginalAer), MainSkillId}
    end.

%% 需要计算的弹道才需要统计
get_combo_hurt_list([], _SkillId) -> [];
get_combo_hurt_list([#skill_combo{main_skill_id=_MainSkillId, hurt_list = HurtList, bullet_type=?SKILL_BULLET_TYPE_ATT_NUM, combo_list=[{SkillId, _, _}|_]}=_ComboR |_T], SkillId) ->
    HurtList;
get_combo_hurt_list([_H|T], SkillId) ->
    get_combo_hurt_list(T, SkillId).

check_combo_hurt_list(HurtList, Der) ->
    #battle_status{sign = Sign, id = Id} = Der,
    case lists:keyfind(Sign, 1, HurtList) of
        false -> false;
        {Sign, IdList} ->
            % ?MYLOG("hjhcombo", "Sign:~p Id:~p IdList:~p ~n", [Sign, Id, IdList]),
            lists:member(Id, IdList)
    end.

%% 弹道技能结束
set_combo_skill_af_battle([], _SkillId, _DerList, Result, Aer) -> Aer#battle_status{skill_combo=Result};
set_combo_skill_af_battle([#skill_combo{count=Count, main_skill_id=MainSkillId, hurt_list = HurtList, bullet_type=?SKILL_BULLET_TYPE_ATT_NUM, combo_list=[{SkillId, _, _}|_]}=ComboR |T],
        SkillId, DerList, Result, Aer) ->
    % Count 本身减了1的
    F = fun(#battle_status{sign = Sign, id = Id}, {Num, TmpHurtList}) ->
        case Id > 0 of
            true ->
                case lists:keyfind(Sign, 1, TmpHurtList) of
                    false -> NewTmpHurtList = [{Sign, [Id]}|TmpHurtList];
                    {Sign, IdList} ->
                        NewTmpHurtList = lists:keystore(Sign, 1, TmpHurtList, {Sign, [Id|lists:delete(Id, IdList)]})
                end,
                {Num+1, NewTmpHurtList};
            false ->
                {Num, TmpHurtList}
        end
    end,
    {Num, NewHurtList} = lists:foldl(F, {0, HurtList}, DerList),
    NewCount = Count - max(Num - 1, 0),
    % ?MYLOG("hjhcombo", "check_combo_skill 2 SkillId:~p NewCount:~p Num:~p NewHurtList:~p ~n", [SkillId, NewCount, Num, NewHurtList]),
    case NewCount > 0 of
        true ->
            NewResult = [ComboR#skill_combo{count = NewCount, hurt_list = NewHurtList}|Result]++T,
            Aer#battle_status{skill_combo=NewResult};
        false ->
            NewResult = Result++T,
            #battle_status{battle_attr=#battle_attr{other_buff_list=OtherBuffL}=BA} = Aer,
            NewOtherBuff = lib_skill_buff:del_combo_buff(OtherBuffL, MainSkillId),
            Aer#battle_status{battle_attr=BA#battle_attr{other_buff_list=NewOtherBuff}, skill_combo = NewResult}
    end;
set_combo_skill_af_battle([H|T], SkillId, DerList, Result, Aer) ->
    set_combo_skill_af_battle(T, SkillId, DerList, [H|Result], Aer).

%%发送消息
send_active_msg(Aer, EtsAer, DefList, SkillId, SkillLv, AttX, AttY, AttAngle, AerOX, AerOY, Broadcast, NowTime, EtsScene) ->
    #battle_status{
        id = Id,
        x = X,
        y = Y,
        scene = _Scene,
        sign = Sign,
        battle_attr=BA,
        trigger_skill = TriggerSkillL
    } = Aer,
    #battle_attr{hp=Hp, attr_buff_list=AttrBuffList, other_buff_list=OtherBuffList, skill_effect=#skill_effect{move=Move}} = BA,
    AerBuffList = lib_skill_buff:pack_buff(AttrBuffList++OtherBuffList, NowTime, []),
    {ok, BinData}  = pt_200:write(20001, [Sign, Id, Hp, 0, Move, SkillId, SkillLv, X, Y, AttX, AttY, AttAngle, AerBuffList, TriggerSkillL, DefList]),
    lib_battle:send_to_scene_area(EtsAer, AerOX, AerOY, Move, Broadcast, BinData, EtsScene),
    ok.

%% 发送辅助技能信息
send_assist_msg(Sign, Id, SkillId, SkillLv, AssistList, CopyId, X, Y, Broadcast) ->
    {ok, BinData} = pt_200:write(20006, [Sign, Id, SkillId, SkillLv, 0, AssistList]),
    lib_battle:send_to_scene(CopyId, X, Y, Broadcast, BinData).

%% 施放辅助技能
assist_skill(AfterEffAer, User, SkillR, NowTime, EtsScene) ->
    #battle_status{sign=Sign, id=Id, copy_id=CopyId, x=X, y=Y, team_id=TeamId, battle_attr=BA, skill_owner=SkillOwner, kind = MonKind} = AfterEffAer,
    #battle_attr{group=Group} = BA,
    #skill{id=SkillId, lv=SkillLv, mod=Mod, obj=Obj, lv_data=LvData} = SkillR,
    #skill_lv{area=Area, assist_mon_list = AssistMonList} = LvData,
    {OwnerSign, OwnerId} = lib_scene_object_ai:get_skill_owner_args(SkillOwner),
    Args = #scene_calc_args{
        group = Group, sign = Sign, id = Id, owner_sign = OwnerSign, owner_id = OwnerId, kind = MonKind,
        guild_id = lib_scene_object_ai:get_guild_id(AfterEffAer),
        pk_status = lib_scene_object_ai:get_pk_status(AfterEffAer)
        },
    Assisters = case Mod of
        % 只对指定怪物
        _ when Obj == ?SKILL_OBJ_ASSIGN_MON ->
            EtsList = lib_scene_calc:get_scene_mon_for_assist(CopyId, X, Y, Area, TeamId, Args),
            ShuffleList = ulists:list_shuffle(EtsList),
            [lib_battle_util:init_data(E) || E <- lib_battle:select_mon_list(ShuffleList, AssistMonList)];
        % 多人
        ?SKILL_MOD_DOUBLE when Obj == ?SKILL_OBJ_ENEMY ->
            % 默认椭圆
            AssistersAfCalc = [lib_battle_util:init_data(E) || E<-lib_scene_calc:get_ellipse_object_for_battle(CopyId, X, Y, Area, Args, EtsScene)],
            AssistersAfCk = [E || E <- AssistersAfCalc, lib_battle:check_pk_and_safe(AfterEffAer, E, EtsScene, NowTime) == true],
            [E || E <- lib_battle:obj_select_att_num_der(AssistersAfCk, SkillId, SkillLv)];
        % 多人
        ?SKILL_MOD_DOUBLE when TeamId > 0 orelse Group > 0 ->
            EtsList = lib_scene_calc:get_scene_object_for_assist(CopyId, X, Y, Area, TeamId, Args),
            TmpL = [lib_battle_util:init_data(E)||E<-EtsList],
            case Obj == ?SKILL_OBJ_OTHER of
                true -> TmpL;
                false -> [AfterEffAer|TmpL]
            end;
        ?SKILL_MOD_DOUBLE when Sign == ?BATTLE_SIGN_MON ->  %%怪物的辅助群体技能
            EtsList = lib_scene_calc:get_scene_mon_for_assist(CopyId, X, Y, Area, TeamId, Args),
            TmpL = [ lib_battle_util:init_data(E) || E <- EtsList],
            [AfterEffAer|TmpL];
        ?SKILL_MOD_DOUBLE -> %% 群体没队伍
            [AfterEffAer];
        % 单人
        ?SKILL_MOD_SINGLE when Obj == ?SKILL_OBJ_ME ->
            [AfterEffAer]; %% 单体buff，buff作用放必须是自己，则被施法者为空
        ?SKILL_MOD_SINGLE when Obj == ?SKILL_OBJ_HP_MIN_MB -> %% 血量最少的人员
            EtsList = lib_scene_calc:get_scene_object_for_assist(CopyId, X, Y, Area, TeamId, Args),
            Fminhp = fun(#battle_status{battle_attr=#battle_attr{hp=Hp1, hp_lim=HpLim1}}, #battle_status{battle_attr=#battle_attr{hp=Hp2, hp_lim=HpLim2}}) ->
                Hp1/HpLim1  =< Hp2/HpLim2
            end,
            case EtsList of
                [] -> [AfterEffAer]; %% 周围没队友，给自己加
                [Elem] ->
                    [MinHpElem|_] = lists:sort(Fminhp, [AfterEffAer, lib_battle_util:init_data(Elem)]),
                    [MinHpElem];
                _ ->
                    [MinHpElem|_] = lists:sort(Fminhp, [AfterEffAer|[lib_battle_util:init_data(E)||E<-EtsList]]),
                    [MinHpElem]
            end;
        ?SKILL_MOD_SINGLE when User#battle_status.sign /= Sign orelse User#battle_status.id /= Id -> %% 客户端选择的是非自己
            [User];
        _ ->
            []
    end,

    AssistersAfCond = lib_skill_buff:filter_assist(SkillR, Assisters),
    AssistersAfAttr = lib_skill_buff:assist_add_attr_buff(LvData#skill_lv.attr, AfterEffAer, AssistersAfCond, NowTime, SkillId, SkillLv, EtsScene#ets_scene.broadcast),
    AssistersAfEff = lib_skill_buff:assist_add_effect_buff(LvData#skill_lv.effect, AfterEffAer, AssistersAfAttr, NowTime, SkillId, SkillLv, EtsScene#ets_scene.broadcast),
    % ?MYLOG(SkillId == 8102205 orelse SkillId == 702,
    %     "skill", "Assisters:~p LvData#skill_lv.attr:~p, LvData#skill_lv.effect:~p ~n",
    %     [Assisters, LvData#skill_lv.attr, LvData#skill_lv.effect]),
    F = fun(EUser, [TmpAer, DerList]) ->
        #battle_status{id=EId, node=ENode, pid=EPid, sign=ESign} = EUser,
        %% 更新战斗状态
        case ESign of
            ?BATTLE_SIGN_PLAYER ->
                case lib_scene_agent:get_user(EId) of
                    #ets_scene_user{} = EtsUser -> lib_scene_agent:put_user(lib_battle_util:back_data(EUser, EtsUser));
                    _ -> skip
                end;
            _ ->
                case lib_scene_object_agent:get_object(EId) of
                    #scene_object{} = Object -> lib_scene_object_agent:put_object(lib_battle_util:back_data(EUser, Object));
                    _ -> skip
                end
        end,
        % ?MYLOG(SkillId == 8102205,
        %     "skill", "EId:~p DBuffList:~p ~n",
        %     [EId,  EUser#battle_status.battle_attr#battle_attr.attr_buff_list ++ EUser#battle_status.battle_attr#battle_attr.other_buff_list]),
        send_to_node_pid(ENode, EPid, {'buff', EUser#battle_status.battle_attr#battle_attr.attr_buff_list,
            EUser#battle_status.battle_attr#battle_attr.other_buff_list}),

        %% 打包buff列表
        %% DBuffList = lib_skill_buff:pack_buff(EUser#battle_status.battle_attr#battle_attr.attr_buff_list
        %%   ++EUser#battle_status.battle_attr#battle_attr.other_buff_list, NowTime, []),
        DBuffList = lib_skill_buff:pack_buff(EUser#battle_status.battle_attr#battle_attr.other_buff_list, NowTime, []),
        TmpAer1 = case EId == Id andalso Sign == ESign of
            true  -> EUser;
            false -> TmpAer
        end,
        [TmpAer1, [[ESign, EId, EUser#battle_status.battle_attr#battle_attr.hp, DBuffList]|DerList] ]
    end,

    [AfAssistAer, BrocastAssisters] = lists:foldl(F, [AfterEffAer, []], AssistersAfEff),

    send_assist_msg(Sign, Id, SkillId, SkillLv, BrocastAssisters, CopyId, X, Y, EtsScene#ets_scene.broadcast),
    AfAssistAer.


%% 使用技能
skill(Aer, BattleExtraArgs, SkillR, MainSkillId, EtsScene) ->
    {AerAfBattle, DerList} = double_active_skill(Aer, BattleExtraArgs, SkillR, MainSkillId, EtsScene),
    {AerAfBattle, DerList}.

%% 群攻
double_active_skill(Aer, BattleExtraArgs, SkillR, MainSkillId, EtsScene) ->
    #battle_args{der_list = DerList, now_time = NowTime, att_x = AttX, att_y = AttY, att_angle = AttAngle, skill_stren = SkillStren} = BattleExtraArgs,
    #battle_status{id = Id, scene = Scene, scene_pool_id = ScenePoolId, sign = AerSign, battle_attr = BA, att_list = AttList} = Aer,
    %% 正在攻击我的怪物数量
    AttMonList = [{AttId, Time}||{AttId, Time} <- AttList, NowTime-Time < 3000],
    %% 持续效果
    AfAttrEffBA  = lib_skill_buff:calc_attr_last_effect(BA#battle_attr.attr_buff_list, NowTime, BA#battle_attr.attr, BA, BA#battle_attr.attr, BA, []),
    AfOtherEffBA = lib_skill_buff:calc_other_last_effect(AfAttrEffBA#battle_attr.other_buff_list, NowTime, MainSkillId, SkillR#skill.id, AfAttrEffBA#battle_attr.attr,
        AfAttrEffBA, AfAttrEffBA#battle_attr.attr, BA, []),
    AfAttrEffAer = Aer#battle_status{battle_attr=AfOtherEffBA, att_list = AttMonList},
    %% 群攻
    Fcalc = fun(Der, {TmpAer, DefList, IsFirstDer, PvpNo}) ->
        case AerSign == ?BATTLE_SIGN_PLAYER andalso Der#battle_status.sign == ?BATTLE_SIGN_PLAYER of
            true -> NewPvpNo = PvpNo + 1;
            false -> NewPvpNo = PvpNo
        end,
        {TmpAfCoreAer, AfCDer} = do_core_battle(TmpAer, Der, NowTime, SkillR, SkillStren, IsFirstDer, AttX, AttY, AttAngle, EtsScene, NewPvpNo),
        %% 可继承的属性:每一次攻击都是用玩家的持续属性,保存上一次触发的技能cd
        TmpBA = TmpAfCoreAer#battle_status.battle_attr,
        NewTmpAer = TmpAer#battle_status{
            battle_attr = TmpBA#battle_attr{
                attr=BA#battle_attr.attr      %% 基础属性不能变更
                },
            skill_cd = TmpAfCoreAer#battle_status.skill_cd,
            x = TmpAfCoreAer#battle_status.x,
            y = TmpAfCoreAer#battle_status.y,
            trigger_skill = TmpAfCoreAer#battle_status.trigger_skill
            },
        {NewTmpAer, [AfCDer|DefList], false, NewPvpNo}
    end,
    %% 可攻击对象过滤
    CheckPkSafeTime = utime:unixtime(),
    % 副技能是否攻击过
    ComboHurtList = get_combo_hurt_list(Aer#battle_status.skill_combo, SkillR#skill.id),
    % --------------------- 断点1开始 ----------------------------------
    % !!!!!! 不能同步到体验
    dungeon_breakpoint(Aer, DerList, NowTime, ComboHurtList, EtsScene, CheckPkSafeTime),
    % --------------------- 断点1结束 ----------------------------------
    DListAll = case [CanAttDer || CanAttDer <- DerList,
            lib_battle:check_pk_and_safe(Aer, CanAttDer, EtsScene, CheckPkSafeTime) == true andalso
            check_combo_hurt_list(ComboHurtList, CanAttDer) == false] of
        [] ->
            [#battle_status{x=AttX, y=AttY, sign=?BATTLE_SIGN_FAKE, figure=#figure{},
                battle_attr=#battle_attr{attr=#attr{}, skill_effect=#skill_effect{}}}];
        Other -> Other
    end,
    {AerAfCalcHurt, DerListAfCalcHurt, _, _} = lists:foldl(Fcalc, {AfAttrEffAer, [], true, 0}, DListAll),
    % 弹道技能
    AerAfCombo = set_combo_skill_af_battle(AerAfCalcHurt#battle_status.skill_combo, SkillR#skill.id, DListAll, [], AerAfCalcHurt),
    % 攻击方
    RealSign = lib_battle:calc_real_sign(AerSign),
    % 辅助技能触发
    #skill{lv_data = #skill_lv{assist_skill_list = AssistSkillList}} = SkillR,
    [lib_battle_api:assist_anything(Scene, ScenePoolId, RealSign, Id, RealSign, Id, TmpSkillId, TmpSkillLv)||{TmpSkillId, TmpSkillLv}<-AssistSkillList],
    {AerAfCombo, DerListAfCalcHurt}.

%% 战斗核心计算
do_core_battle(Aer, Der, NowTime, SkillR, SkillStren, IsFirstDer, AttX, AttY, AttAngle, EtsScene, PvpNo) ->
    #skill{id = SkillId, calc = Calc, lv = SkillLv, lv_data = #skill_lv{attr = AttrList0, effect = EffectList0, trigger = Trigger, recalc_effect = RecalcEffect}} = SkillR,
    #ets_scene{broadcast = Broadcast} = EtsScene,

    %% 计算防守方持续buff
    #battle_status{battle_attr = DerBA} = Der,
    AfAtlBuffDerBA = lib_skill_buff:calc_attr_last_effect(DerBA#battle_attr.attr_buff_list, NowTime, DerBA#battle_attr.attr, DerBA, DerBA#battle_attr.attr, DerBA, []),

    AfOthBuffDerBA = lib_skill_buff:calc_other_last_effect(AfAtlBuffDerBA#battle_attr.other_buff_list, NowTime, 0, SkillId,
                                                           AfAtlBuffDerBA#battle_attr.attr, AfAtlBuffDerBA, AfAtlBuffDerBA#battle_attr.attr, AfAtlBuffDerBA, []),
    AfOthBuffDer = Der#battle_status{battle_attr=AfOthBuffDerBA},

    %% 计算伤害类型
    HurtType = calc_hurt_type(Aer, AfOthBuffDer, Calc),
    SecHurtType = calc_sec_hurt_type(AfOthBuffDer),

    %% 计算攻击玩家被动技能(攻击者攻击前触发)
    AerBfBAPassiveArgs = #battle_passive_args{
        aer = Aer, der = AfOthBuffDer, trigger_time = ?SKILL_BUFF_TG_TIME_ATTBF,
        hp = Aer#battle_status.battle_attr#battle_attr.hp, hurt_type = HurtType, sec_hurt_type = SecHurtType, battle_skill_id = SkillId, skill_calc_hurt = Calc},
    {AttAfPassiveAer, AttAfPassiveDer}
        = lib_skill_buff:calc_aer_passive_skill(Aer, AfOthBuffDer, Aer, Der, NowTime, IsFirstDer, AttX, AttY, AttAngle, Broadcast, AerBfBAPassiveArgs),

    %% 计算防守玩家被动技能(防守者被攻击前触发)(防守者为主动触发方,所以二者位置互换)
    DerBfBAPassiveArgs = #battle_passive_args{
        aer = Aer, der = AfOthBuffDer, trigger_time = ?SKILL_BUFF_TG_TIME_DEFBF,
        hp = AttAfPassiveDer#battle_status.battle_attr#battle_attr.hp, hurt_type = HurtType, sec_hurt_type = SecHurtType, battle_skill_id = SkillId, skill_calc_hurt = Calc},
    {DefAfPassiveDer, DefAfPassiveAer, _} = lib_skill_buff:calc_der_passive_skill(AttAfPassiveDer, AttAfPassiveAer, Der, Aer, NowTime,
        IsFirstDer, AttX, AttY, AttAngle, Broadcast, DerBfBAPassiveArgs),

    %% 重新计算buff列表
    {AttrList, EffectList} = lib_skill_buff:recalc_effect(RecalcEffect, DefAfPassiveAer, DefAfPassiveDer, AttrList0, EffectList0),

    %% 主技能效果
    {AfAtAer, AfAtDer}  = lib_skill_buff:calc_active_attr_effect(AttrList, Trigger, DefAfPassiveAer, DefAfPassiveDer,
        DefAfPassiveAer#battle_status.battle_attr#battle_attr.attr_buff_list,
        DefAfPassiveDer#battle_status.battle_attr#battle_attr.attr_buff_list,
        NowTime, SkillId, SkillLv, Aer, Der, IsFirstDer, Broadcast),
    {AfBuffAer1, AfBuffDer1}  = lib_skill_buff:calc_active_other_effect(EffectList, Trigger, AfAtAer, AfAtDer,
        AfAtAer#battle_status.battle_attr#battle_attr.other_buff_list,
        AfAtDer#battle_status.battle_attr#battle_attr.other_buff_list,
        NowTime, SkillId, SkillLv, Aer, Der, IsFirstDer, AttX, AttY, AttAngle, Broadcast),

    %% 重新计算伤害类型
    HurtTypeAfReCal = calc_hurt_type(AfBuffAer1, AfBuffDer1, Calc),
    SecHurtTypeAfReCal = calc_sec_hurt_type(AfBuffDer1),
    %% 计算伤害
    {Hpb1, Hurt1, RealHurt} = calc_hurt(AfBuffAer1, AfBuffDer1, SkillR, SkillStren, HurtTypeAfReCal, SecHurtTypeAfReCal, NowTime, PvpNo),
    %% 计算每X秒伤害的防守者
    AfPerHurtDer = calc_per_hurt(AfBuffDer1, Hurt1, NowTime),
    %% 计算血量护盾
    {NewHpb, Hurt, NewDerBA} = calc_shield_hp(Hpb1, Hurt1, AfPerHurtDer#battle_status.battle_attr),
    %% 血量赋值
    HpDerBA = NewDerBA#battle_attr{hp = NewHpb},

    %% 计算攻击玩家被动技能(攻击方攻击后触发):判断造成的伤害类型
    AerAfBAPassiveArgs = #battle_passive_args{
        aer = Aer, der = AfOthBuffDer, trigger_time = ?SKILL_BUFF_TG_TIME_ATTAF,
        hp = AfBuffAer1#battle_status.battle_attr#battle_attr.hp, hurt_type = HurtTypeAfReCal, sec_hurt_type = SecHurtTypeAfReCal, hurt = Hurt, battle_skill_id = SkillId, skill_calc_hurt = Calc},
    {AfBuffAer2, AfBuffDer2} = lib_skill_buff:calc_aer_passive_skill(AfBuffAer1, AfPerHurtDer#battle_status{battle_attr = HpDerBA},
        Aer, Der, NowTime, IsFirstDer, AttX, AttY, AttAngle, Broadcast, AerAfBAPassiveArgs),
    %% 计算防守玩家被动技能(防守者被攻击后触发)
    %% [Aer, AfOthBuffDer, ?SKILL_BUFF_TG_TIME_DEFAF, NewHpb, HurtType, Hurt]
    DerAfBAPassiveArgs = #battle_passive_args{
        aer = Aer, der = AfOthBuffDer, trigger_time = ?SKILL_BUFF_TG_TIME_DEFAF,
        hp = AfBuffDer2#battle_status.battle_attr#battle_attr.hp,
        hurt_type = HurtTypeAfReCal, sec_hurt_type = SecHurtTypeAfReCal, hurt = Hurt, battle_skill_id = SkillId, skill_calc_hurt = Calc},
    {AfBuffDer, AfBuffAer, AfBuffHpb} = lib_skill_buff:calc_der_passive_skill(AfBuffDer2, AfBuffAer2, Der, Aer, NowTime, IsFirstDer,
        AttX, AttY, AttAngle, Broadcast, DerAfBAPassiveArgs),
    %% 计算锁血
    AfLockHpb = calc_hp_lock(AfBuffDer, AfBuffHpb, DerBA#battle_attr.hp),
    %% 计算免死
    Hpb = calc_free_die(AfBuffDer, AfLockHpb),
    %% 计算反弹伤害
    {AfReBAer, AfReBAerHurt} = calc_rebound_hurt(AfBuffAer, AfBuffDer, Hurt1, Broadcast, NowTime),
    %% 计算吸血
    AfSuBAer = calc_suck_blood(AfReBAer, AfReBAer#battle_status.battle_attr#battle_attr.skill_effect, AfBuffDer, Hurt1, Broadcast),
    %% 处理是否破隐身
    %% AfHideAer = break_steath(Aer, AfSuBAer, SkillR, EtsScene),
    %% 最后统一赋值
    LastAer = AfSuBAer,
    %% 攻击方
    LastAerSign = lib_battle:calc_real_sign(LastAer#battle_status.sign),

    [RetrunAtter, RetrunSign] = lib_battle_util:make_return_atter(LastAer, LastAerSign),

    % 显示属性真实打出的伤害(不一定是扣掉的血量,可能比扣掉的血量要高)
    RealHurt1 = RealHurt + Hurt1 - Hurt,

    BattleReturn = #battle_return{
        hp_lim = AfBuffDer#battle_status.battle_attr#battle_attr.hp_lim, hp = Hpb, hurt = Hurt, shield = 0, sign = RetrunSign, atter = RetrunAtter,
        move_x = case AfBuffDer#battle_status.battle_attr#battle_attr.skill_effect#skill_effect.move == 1 of
                   true -> AfBuffDer#battle_status.x;
                   false -> 0
               end,
        move_y = case AfBuffDer#battle_status.battle_attr#battle_attr.skill_effect#skill_effect.move == 1 of
                   true -> AfBuffDer#battle_status.y;
                   false -> 0
               end,
        attr_buff_list = AfBuffDer#battle_status.battle_attr#battle_attr.attr_buff_list,
        other_buff_list = AfBuffDer#battle_status.battle_attr#battle_attr.other_buff_list,
        real_hurt = RealHurt1
        },

    %% 更新防守方数据
    if
        not is_pid(Der#battle_status.pid) -> skip;
        Der#battle_status.sign == ?BATTLE_SIGN_PLAYER -> %% 防守方是玩家
            case Der#battle_status.sign == ?BATTLE_SIGN_PLAYER andalso Hpb == 0 andalso
                (EtsScene#ets_scene.type == ?SCENE_TYPE_NORMAL orelse EtsScene#ets_scene.type == ?SCENE_TYPE_OUTSIDE) of %% 野外非pk场景击杀玩家
                true  ->
                    if
                        RetrunSign == ?BATTLE_SIGN_PLAYER andalso %% 攻击方是人
                        Der#battle_status.battle_attr#battle_attr.pk#pk.pk_value == 0 andalso %% 击杀非红名玩家+1
                        Der#battle_status.scene =/= ?HuSongScene -> %% 不在护送场景
                            send_to_node_pid(Aer#battle_status.node, Aer#battle_status.pid, {'change_pk_value', Der#battle_status.figure#figure.name, 1});
                        true ->
                            skip
                    end;
                false ->
                    skip
            end,
            BA = AfBuffDer#battle_status.battle_attr,
            if
                Aer#battle_status.sign == ?BATTLE_SIGN_MON -> %% 记录被怪物攻击数量
                    %% 只保留最新的5个
                    NewAttList1 = [{Aer#battle_status.id, NowTime}|
                                   lists:keydelete(Aer#battle_status.id, 1, AfBuffDer#battle_status.att_list)],
                    NewAttList = lists:sublist(NewAttList1, 5);
                true ->
                    NewAttList = AfBuffDer#battle_status.att_list
            end,
            if
                AfBuffDer#battle_status.be_trigger_skill =/= [] -> %% 防御者触发了被动
                    {ok, BinData} = pt_200:write(20028, [AfBuffDer#battle_status.be_trigger_skill]),
                    lib_server_send:send_to_uid(Der#battle_status.node, Der#battle_status.id, BinData);
                true -> skip
            end,
            %% 更新防守玩家信息
            der_update_scene_info(AfBuffDer#battle_status{att_list = NewAttList, battle_attr=BA#battle_attr{hp=Hpb, attr=DerBA#battle_attr.attr}},
                                  BattleReturn, RetrunAtter, NowTime);

        Der#battle_status.sign == ?BATTLE_SIGN_MON orelse Der#battle_status.sign == ?BATTLE_SIGN_DUMMY ->
            send_to_node_pid(Der#battle_status.node, Der#battle_status.pid, {'battle_info', BattleReturn}),
            BA = AfBuffDer#battle_status.battle_attr,
            NewDer = AfBuffDer#battle_status{battle_attr=BA#battle_attr{hp=Hpb, attr=DerBA#battle_attr.attr}},
            Object = lib_scene_object_agent:get_object(Der#battle_status.id),
            lib_scene_object_agent:put_object(lib_battle_util:back_data(NewDer, Object));
        true ->
            skip
    end,

    %% 处理反弹
    [AerRetrunAtter, AerRetrunSign] = lib_battle_util:make_return_atter(Der, Der#battle_status.sign),

    AerBattleReturn = #battle_return{
        hurt = AfReBAerHurt, sign = AerRetrunSign, atter = AerRetrunAtter,
        attr_buff_list = LastAer#battle_status.battle_attr#battle_attr.attr_buff_list,
        other_buff_list = LastAer#battle_status.battle_attr#battle_attr.other_buff_list,
        hp = LastAer#battle_status.battle_attr#battle_attr.hp,
        hp_lim = LastAer#battle_status.battle_attr#battle_attr.hp_lim
    },
    if
        not is_pid(Aer#battle_status.pid) -> skip;
        AfReBAerHurt =< 0 -> skip;
        Aer#battle_status.sign == ?BATTLE_SIGN_MON -> send_to_node_pid(Aer#battle_status.node, Aer#battle_status.pid, {'rebound_battle_info', AerBattleReturn});
        true -> skip
    end,

    %% 只发特殊效果buff
    LastDList = case Der#battle_status.sign of
        ?BATTLE_SIGN_FAKE -> [];
        _ ->
            DBuffList = lib_skill_buff:pack_buff(AfBuffDer#battle_status.battle_attr#battle_attr.attr_buff_list ++
                AfBuffDer#battle_status.battle_attr#battle_attr.other_buff_list, NowTime, []),
            [Der#battle_status.sign, Der#battle_status.id, Hpb, 0, 0,
                RealHurt1, HurtTypeAfReCal, SecHurtTypeAfReCal, AfBuffDer#battle_status.x, AfBuffDer#battle_status.y,
                AfBuffDer#battle_status.battle_attr#battle_attr.skill_effect#skill_effect.move,
                AfBuffDer#battle_status.battle_attr#battle_attr.skill_effect#skill_effect.interrupt, DBuffList]
    end,
    {LastAer, LastDList}.

%% -define(HURT_TYPE_NORMAL,   0). %% 普通
%% -define(HURT_TYPE_MISS,     1). %% 闪避
%% -define(HURT_TYPE_CRIT,     2). %% 暴击
%% -define(HURT_TYPE_IMMUE,    3). %% 免疫伤害(无敌)
%% -define(HURT_TYPE_HEART,    4). %% 会心
%% -define(HURT_TYPE_SHIELD,   5). %% 护盾免伤
%% 伤害类型计算
calc_hurt_type(Aer, Der, Calc) ->
    %% 攻击方
    #battle_status{battle_attr=BAA} = Aer,
    #battle_attr{attr=AttrA} = BAA,
    #attr{
        hit = HitA, crit = CritA, hit_ratio = HitRatioA, crit_ratio = CritRatioA, heart_ratio = HeartRatioA,
        exc_ratio = ExcRatioA
        } = AttrA,
    %% 防守方
    #battle_status{kind=Kind, battle_attr=BAD, figure = #figure{lv = LvD}} = Der,
    #battle_attr{attr=AttrD, skill_effect=SkillEffD} = BAD,
    #attr{
        dodge = DodgeD, ten = TenD, dodge_ratio = DodgeRatioD, uncrit_ratio = UnCritRatioD, heart_down_ratio=HeartDownRatioD,
        unexc_ratio = UnExcRatioD
        } = AttrD,
    if
        Kind == ?MON_KIND_COLLECT orelse Kind == ?MON_KIND_TASK_COLLECT orelse Calc == 0 -> ?HURT_TYPE_NOTHING;
        SkillEffD#skill_effect.immue == 1 -> ?HURT_TYPE_IMMUE;
        SkillEffD#skill_effect.shield == true -> ?HURT_TYPE_SHIELD;
        true ->

            OExcRatio = max(0, ExcRatioA - UnExcRatioD),
            ODodgeRatio = max(0, round(DodgeD/(HitA+DodgeD+500+LvD*10)*0.2*?RATIO_COEFFICIENT + DodgeRatioD - HitRatioA)),
            CritRatio = max(0, min(0.8*?RATIO_COEFFICIENT, round(CritA/(TenD+CritA+1000+LvD*15)*0.2*?RATIO_COEFFICIENT + CritRatioA - UnCritRatioD))),

            case OExcRatio+ODodgeRatio+CritRatio > ?RATIO_COEFFICIENT of
                true ->
                    ExcRatio = OExcRatio * (?RATIO_COEFFICIENT-CritRatio)/max(1, (ODodgeRatio+OExcRatio)),
                    DodgeRatio = ODodgeRatio * (?RATIO_COEFFICIENT-CritRatio)/max(1, (ODodgeRatio+OExcRatio));
                false ->
                    ExcRatio = OExcRatio,
                    DodgeRatio = ODodgeRatio
            end,
            HeartRatio = min(0.8*?RATIO_COEFFICIENT, HeartRatioA-HeartDownRatioD),
            HeartRatioRand = urand:rand(1, ?RATIO_COEFFICIENT),
            if
                HeartRatioRand =< HeartRatio -> IsHeart = true;
                true -> IsHeart = false
            end,
            Rand = urand:rand(1, ?RATIO_COEFFICIENT),
            if
                Rand =< ExcRatio -> ?IF(IsHeart, ?HURT_TYPE_EXC_HEART, ?HURT_TYPE_EXC);
                Rand =< ExcRatio+DodgeRatio -> ?HURT_TYPE_MISS;
                Rand =< ExcRatio+DodgeRatio+CritRatio -> ?IF(IsHeart, ?HURT_TYPE_CRIT_HEART, ?HURT_TYPE_CRIT);
                true -> ?IF(IsHeart, ?HURT_TYPE_HEART, ?HURT_TYPE_NORMAL)
            end
    end.

%% 伤害第二类型计算:跟伤害类型能同时触发
%% ?HURT_TYPE_PARRY 格挡
calc_sec_hurt_type(Der) ->
    #battle_status{battle_attr = BAD} = Der,
    #battle_attr{attr = AttrD} = BAD,
    #attr{parry_ratio = ParryRatioD} = AttrD,
    Rand = urand:rand(1, ?RATIO_COEFFICIENT),
    if
        Rand =< ParryRatioD -> ?HURT_TYPE_PARRY;
        true -> ?HURT_TYPE_NORMAL
    end.

%% 伤害计算
%% @return {HpAfCalc, HurtAfCalc, RealHurtAfCalc}
calc_hurt(Aer, Der, SkillR, SkillStren, HurtType, SecHurtType, NowTime, PvpNo) ->
    #battle_attr{hp = HpD, hp_lim = HpLimD} = Der#battle_status.battle_attr,
    {MaxHurt, IsDelHpEachTime} = calc_del_hp_each_time(Der, NowTime),
    % RealHurtAfCalc = 显示属性真实打出的伤害(不一定是扣掉的血量,可能比扣掉的血量要高)
    {HpAfCalc, HurtAfCalc, RealHurtAfCalc} = if
        %% 特殊状态，免疫伤害
        HurtType == ?HURT_TYPE_IMMUE orelse HurtType == ?HURT_TYPE_SHIELD orelse
                HurtType == ?HURT_TYPE_MISS orelse HurtType == ?HURT_TYPE_NOTHING ->
            {Der#battle_status.battle_attr#battle_attr.hp, 0, 0};
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
            calc_hurt_core(Aer, Der, SkillR, SkillStren, HurtType, SecHurtType, PvpNo, MaxHurt)
    end,
    % #skill_effect{free_die = FreeDie} = SED,
    % if
    %     % 免死情况下保留一滴血
    %     HpAfCalc == 0 andalso FreeDie == 1 -> {1, max(0, HpD-1), RealHurtAfCalc};
    %     true -> {HpAfCalc, HurtAfCalc, RealHurtAfCalc}
    % end.
    {HpAfCalc, HurtAfCalc, RealHurtAfCalc}.

%% 计算每一次伤害固定值
%% return {MaxHurt(false | integer()), IsDelHpEachTime(是否计算固定血量)}
calc_del_hp_each_time(Der, NowTime) ->
    #battle_status{per_hurt = PerHurtD, per_hurt_time = PerHurtTimeD} = Der,
    #battle_attr{hp_lim = HpLim} = Der#battle_status.battle_attr,
    % 最大伤害值
    case Der#battle_status.del_hp_each_time of
        [?DEL_HP_EACH_TIME_MAX_HURT, MaxHurt] when is_integer(MaxHurt) -> IsDelHpEachTime = false;
        [?DEL_HP_EACH_TIME_MAX_HURT, MaxHurt0] when is_float(MaxHurt0) -> MaxHurt = round(HpLim*MaxHurt0), IsDelHpEachTime = false;
        % 每X秒的伤害
        [?DEL_HP_EACH_TIME_PER_HURT, PerS, PerHurt] when is_integer(PerHurt) ->
            case NowTime - PerHurtTimeD > PerS of
                true -> MaxHurt = PerHurt;
                false -> MaxHurt = max(PerHurt - PerHurtD, 0)
            end,
            IsDelHpEachTime = false;
        [?DEL_HP_EACH_TIME_PER_HURT, PerS, PerHurt0] when is_float(PerHurt0) ->
            PerHurt = round(HpLim*PerHurt0),
            case NowTime - PerHurtTimeD > PerS of
                true -> MaxHurt = PerHurt;
                false -> MaxHurt = max(PerHurt - PerHurtD, 0)
            end,
            IsDelHpEachTime = false;
        [_|_] -> MaxHurt = false, IsDelHpEachTime = true;
        _ -> MaxHurt = false, IsDelHpEachTime = false
    end,
    {MaxHurt, IsDelHpEachTime}.
    %{999999999999, false}.
    %{1, true}.

%% 计算固定伤害值
%% @return {伤害值, 真实伤害值}
calc_del_hp_each_time(Der) ->
    #battle_attr{hp = HpD, hp_lim = HpLimD} = Der#battle_status.battle_attr,
    case Der#battle_status.del_hp_each_time of
        [DelHp, DelHp|_] when is_integer(DelHp)-> {min(HpD, DelHp), DelHp};
        [MinDelHp, MaxDelHp|_] when is_integer(MinDelHp), is_integer(MaxDelHp), MinDelHp > 0, MaxDelHp > 0 ->
            DelHp = urand:rand(MinDelHp, MaxDelHp),
            {min(HpD, DelHp), DelHp};
        [MinDelHpP, MaxDelHpP|_] when is_float(MinDelHpP), is_float(MaxDelHpP), MinDelHpP > 0, MaxDelHpP > 0 ->
            MinDelHp = round(MinDelHpP*HpLimD),
            MaxDelHp = round(MaxDelHpP*HpLimD),
            DelHp = urand:rand(MinDelHp, MaxDelHp),
            {min(HpD, DelHp), DelHp};
        _ ->
            {1, 1}
    end.

%% 技能
calc_hurt_core(Aer, Der, SkillR, _SkillStren, HurtType, SecHurtType, PvpNo, MaxHurt) ->
    #skill{lv_data=#skill_lv{hurt = SHurt, hurt_ratio = SHurtRatio}} = SkillR,

    %% 攻击方
    #battle_status{battle_attr=BAA, sign = AerSign, boss = AerBoss, figure = AerFigure} = Aer,
    #battle_attr{
        attr=AttrA, mon_hurt_add = MonHurtAdd, boss_hurt_add = BossHurtAdd,
        mate_mon_hurt_add = MateMonHurtAdd, achiv_pvp_hurt_add = AchivPvpHurtAdd} = BAA,
    #attr{
        att = AttA, wreck = WreckA, elem_att = ElemAttA,
        hurt_add_ratio = HurtAddRatioA, skill_hurt_add_ratio = SkillHurtAddRatio,
        crit_hurt_add_ratio = CritHurtAddRatio, heart_hurt_add_ratio=HeartHurtAddRatio, abs_att = AbsAttA,
        exc_hurt_add_ratio = ExcHurtAddRatio, neglect_def_ratio = NeglectDefRatioA, pvp_hurt_add = PvpHurtAddA, armor = Armor,
        pve_hurt_add_ratio = PveHurtAddRatio, pvp_hurt_add_ratio = PvpHurtAddRatioA} = AttrA,
    #figure{achiv_stage = AerAchivStage, god_id = GodIdA} = AerFigure,

    %% 防守方
    #battle_status{sign = DerSign, boss = DerBoss, battle_attr = BAD, figure = DerFigure, scene = SceneId} = Der,
    #battle_attr{hp = HpD, hp_lim = HpLimD, attr = AttrD, pvp_hurt_del_ratio = PvpHurtDelRatioD, skill_effect = SED} = BAD,
    #attr{
        att = AttD, wreck = WreckD,
        def = DefD, elem_def = ElemDefD, hurt_del_ratio = HurtDelRatioD,
        skill_hurt_del_ratio = SkillHurtDelRatio,
        crit_hurt_del_ratio = CritHurtDelRatio, heart_hurt_del_ratio=HeartHurtDelRatio,
        exc_hurt_del_ratio = ExcHurtDelRatio, abs_def = AbsDefD, pvp_hurt_del = PvpHurtDelD, pvp_hurt_del_ratio = AttrPvpHurtDelRatioD} = AttrD,
    #figure{achiv_stage = DerAchivStage} = DerFigure,
    #skill_effect{hp_lim_hurt = HpLimHurtD} = SED,

    % pvp增加/减免自身受到的伤害
    {NewPvpHurtAddRatioA, NewPvpHurtDelRatioD} = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER,
        {PvpHurtAddRatioA, PvpHurtDelRatioD+AttrPvpHurtDelRatioD}, {0, 0}),
    % 真实攻击对象
    RAerSign = lib_battle:calc_real_sign(AerSign),
    % 增加人物对所有怪物伤害
    NewMonHurtAdd = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_MON, MonHurtAdd, 0),
    %% boss伤害加成
    NewBossHurtAdd = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso (DerBoss == ?MON_LOCAL_BOSS orelse DerBoss == ?MON_CLUSTER_BOSS orelse
        DerBoss == ?MON_ACTIVE_BOSS orelse DerBoss == ?MON_DUN_BOSS orelse
        DerBoss == ?MON_TASK_BOSS), BossHurtAdd, 0),
    % pve增加伤害比率
    NewPveHurtAddRatio = ?IF(RAerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_MON, PveHurtAddRatio, 0),
    % 伙伴对怪物的伤害
    NewMateMonHurtAdd = ?IF(AerSign==?BATTLE_SIGN_MATE andalso DerSign==?BATTLE_SIGN_MON, MateMonHurtAdd, 0),
    % 成就伤害加成
    NewAchivPvpHurtAdd = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER andalso AerAchivStage > DerAchivStage, AchivPvpHurtAdd, 0),
    % 伤害比率
    HurtRatio = max(0, 1+(HurtAddRatioA-HurtDelRatioD+NewPvpHurtAddRatioA-NewPvpHurtDelRatioD+NewMonHurtAdd+NewBossHurtAdd+NewPveHurtAddRatio+
        NewMateMonHurtAdd+NewAchivPvpHurtAdd)/?RATIO_COEFFICIENT),
    % 技能伤害比率
    TotalSHurtRatio = max(0, (SHurtRatio+SkillHurtAddRatio-SkillHurtDelRatio)/?RATIO_COEFFICIENT),
    % 随机比率
    RandRatio = urand:rand(9500, 10500)/?RATIO_COEFFICIENT,
    % 总比率
    TotalRatio = max(0.2, HurtRatio*TotalSHurtRatio)*RandRatio,
    % 元素伤害
    ElemHurt = max(ElemAttA-ElemDefD, 0),
    % 固定伤害
    BaseFixHurt = SHurt + ElemHurt,
    % 基础伤害值计算公式
    BaseHurt = if
        WreckA >= DefD*(1-NeglectDefRatioA/?RATIO_COEFFICIENT) -> (AttA+WreckA-max(DefD*(1-NeglectDefRatioA/?RATIO_COEFFICIENT), 0))*TotalRatio+BaseFixHurt;
        true -> AttA*(0.5 + 0.5*max(1, WreckA)/max(1, DefD*(1-NeglectDefRatioA/?RATIO_COEFFICIENT)))*TotalRatio+BaseFixHurt
    end,
    % ?PRINT(AerSign==?BATTLE_SIGN_PLAYER andalso SkillR#skill.id == 100201,
    %     "SkillId:~p HurtAddRatioA:~p HurtRatio:~p TotalSHurtRatio:~p TotalRatio:~p ~n",
    %     [SkillR#skill.id, HurtAddRatioA, HurtRatio, TotalSHurtRatio, TotalRatio]),
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

    % 格挡
    HurtAfParry = ?IF(SecHurtType == ?HURT_TYPE_PARRY, TypeHurt*0.5, TypeHurt),

    % 护甲
    HurtAfArmor = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER,
        HurtAfParry*(1-(Armor/(Armor+100)*0.3/?RATIO_COEFFICIENT))*1,
        HurtAfParry),
    % boss碾压伤害
    HurtAfBossCrush = calc_boss_crush_hurt(SceneId, RAerSign, DerSign, AerBoss, DerBoss, AerFigure#figure.lv, DerFigure#figure.lv, HurtAfArmor),
    % 降神伤害:对怪物增加100%的伤害
    HurtAfGod = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_MON andalso GodIdA > 0, HurtAfBossCrush*2, HurtAfBossCrush),
    % pvp溅射
    HurtAfSputter = calc_sputter(AerSign, DerSign, SceneId, PvpNo, HurtAfGod),
    % 伤害平衡
    HurtAfBalance = calc_hurt_balance(AerSign, DerSign, AttA, AttD, WreckA, WreckD, HurtAfSputter),
    % 固定伤害(pvp)
    PvpHurt = PvpHurtAddA - PvpHurtDelD,
    HurtAfPvp = ?IF(AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER, max(0, HurtAfBalance + PvpHurt), HurtAfBalance),

    % 血量上限最大伤害比例
    HurtAfHpLim = calc_hp_lim_hurt(AerSign, DerSign, HpLimD, HpLimHurtD, HurtAfPvp),

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
    % ?PRINT(AerSign==?BATTLE_SIGN_PLAYER andalso SkillR#skill.id == 100102,
    %     "SkillId:~p BaseHurt:~p TypeHurt:~p HurtAfArmor:~p RealHurt:~p LastHurt:~p ~n",
    %     [SkillR#skill.id, BaseHurt, TypeHurt, HurtAfArmor, RealHurt, LastHurt]),
    {max(0, HpD - LastHurt), min(HpD, LastHurt), RealHurt}.

%% boss碾压伤害
calc_boss_crush_hurt(SceneId, RAerSign, DerSign, AerBoss, DerBoss, LvA, LvD, Hurt) ->
    % 特殊boss类型的减伤和加伤：根据等级条件
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} -> skip;
        _ -> SceneType = 0
    end,
    if
        SceneType == ?SCENE_TYPE_SANCTUM andalso DerBoss == ?MON_CLUSTER_BOSS ->
            Hurt;

        DerSign == ?BATTLE_SIGN_MON andalso RAerSign == ?BATTLE_SIGN_PLAYER andalso
                (DerBoss == ?MON_LOCAL_BOSS orelse DerBoss == ?MON_CLUSTER_BOSS) ->
            SpanLv = LvA - LvD,
            BossType = lib_battle_util:calc_boss_type(SceneId, DerBoss, SpanLv),
            case data_mon_type:get_lv_hurt(DerBoss, BossType, SpanLv) of
                #mon_type_lv_hurt{role_add_hurt = RoleLvAddHurt} -> Hurt*(1 + RoleLvAddHurt);
                _ -> Hurt
            end;

        RAerSign == ?BATTLE_SIGN_MON andalso DerSign == ?BATTLE_SIGN_PLAYER andalso
                (AerBoss == ?MON_LOCAL_BOSS orelse AerBoss == ?MON_CLUSTER_BOSS) ->
            SpanLv = LvD - LvA,
            BossType = lib_battle_util:calc_boss_type(SceneId, AerBoss, SpanLv),
            case data_mon_type:get_lv_hurt(AerBoss, BossType, SpanLv) of
                #mon_type_lv_hurt{mon_add_hurt = MonLvAddHurt} -> Hurt*(1 + MonLvAddHurt);
                _ -> Hurt
            end;
        true ->
            Hurt
    end.

%% 计算溅射
calc_sputter(AerSign, DerSign, SceneId, PvpNo, Hurt) ->
    if
        % pvp伤害:首个玩家100%的伤害,其他玩家25%伤害.默认溅射
        AerSign == ?BATTLE_SIGN_PLAYER andalso DerSign == ?BATTLE_SIGN_PLAYER ->
            case data_scene_other:get(SceneId) of
                #ets_scene_other{is_pvp_sputter = 0} -> Hurt;
                _ ->
                    if
                        PvpNo == 1 -> Hurt;
                        true -> Hurt*0.25
                    end
            end;
        true ->
            Hurt
    end.

%% 计算伤害平衡
calc_hurt_balance(AerSign, DerSign, AttA, AttD, WreckA, WreckD, Hurt) ->
    if
        % pvp生效
        AerSign=/=?BATTLE_SIGN_PLAYER orelse DerSign=/=?BATTLE_SIGN_PLAYER -> Hurt;
        % 攻击者的攻击和破甲大于防守者,衰减
        (AttD+WreckD) =/= 0 andalso (AttA+WreckA) >= (AttD+WreckD)*1.1 ->
            % 平衡系数
            BalanceR = (AttA+WreckA) / (AttD+WreckD),
            if
                BalanceR < 1.1 -> Hurt;
                % 0.5-0.5/(DecayR-0.1) 不会是负数,但是防止上面的参数变化[(AttA+WreckA) >= (AttD+WreckD)*1.1]导致负数容错一下
                true -> max(0, Hurt*(1-(0.8-0.8/(BalanceR-0.1))))
            end;
        % 防守者的攻击和破甲大于攻击者,增伤
        (AttA+WreckA) =/= 0 andalso (AttD+WreckD) >= (AttA+WreckA)*1.1 ->
            % 平衡系数
            BalanceR = (AttD+WreckD) / (AttA+WreckA),
            if
                BalanceR < 1.1 -> Hurt;
                true -> max(0, Hurt*(1+(0.8-0.8/(BalanceR-0.1))))
            end;
        true ->
            Hurt
    end.

%% 血量上限最大伤害比例
calc_hp_lim_hurt(AerSign, DerSign, HpLimD, HpLimHurtD, HurtAfFix) ->
    if
        AerSign==?BATTLE_SIGN_PLAYER andalso DerSign==?BATTLE_SIGN_PLAYER ->
            % 最大伤害值=Int+血量上限*Float
            case HpLimHurtD of
                {0, 0} -> HurtAfFix;
                {HpLimHurtDInt, HpLimHurtDFloat} -> min(HurtAfFix, HpLimHurtDInt+HpLimD*HpLimHurtDFloat);
                _ -> HurtAfFix
            end;
        true ->
            HurtAfFix
    end.

%% 计算每X秒伤害的防守者
calc_per_hurt(Der, Hurt, NowTime) ->
    #battle_status{per_hurt = PerHurt, per_hurt_time = PerHurtTime} = Der,
    % 最大伤害值
    case Der#battle_status.del_hp_each_time of
        % 每X秒的伤害
        [?DEL_HP_EACH_TIME_PER_HURT, PerS, _PerHurt] when PerS > 0 ->
            if
                PerHurtTime == 0  ->
                    NewPerHurtTime = NowTime, NewPerHurt = Hurt;
                NowTime - PerHurtTime > PerS ->
                    NewPerHurtTime = NowTime - ((NowTime - PerHurtTime) rem PerS),
                    NewPerHurt = Hurt;
                true ->
                    NewPerHurtTime = PerHurtTime, NewPerHurt = PerHurt+Hurt
            end,
            Der#battle_status{per_hurt = NewPerHurt, per_hurt_time = NewPerHurtTime};
        _ ->
            Der
    end.

%% 计算锁血
calc_hp_lock(Der, Hpb, HpO, NowTime) ->
    case Der of
        #ets_scene_user{battle_attr = #battle_attr{other_buff_list = OtherBuffList} = BA} -> ok;
        #scene_object{battle_attr = #battle_attr{other_buff_list = OtherBuffList} = BA} -> ok;
        _ -> BA = #battle_attr{}, OtherBuffList = []
    end,
    F = fun
            ({?SPBUFF_LOCK_HP, _SkillId, _, _SkillLv, _Stack, Int, Float, T, _EffectId, _AttrId}, AccBA) when T > NowTime ->
                NewSkillEffect =
                    case AccBA#battle_attr.skill_effect of
                        #skill_effect{} = SkillEffect -> SkillEffect#skill_effect{hp_lock = {Int, Float}};
                        _ -> #skill_effect{hp_lock = {Int, Float}}
                    end,
                AccBA#battle_attr{skill_effect = NewSkillEffect};
            (_, AccBA) -> AccBA
        end,
    NewBA = lists:foldl(F, BA, OtherBuffList),
    calc_hp_lock(NewBA, Hpb, HpO).
%% 计算锁血
calc_hp_lock(Der, Hpb, HpO) when is_record(Der, battle_status) ->
    calc_hp_lock(Der#battle_status.battle_attr, Hpb, HpO);
calc_hp_lock(#battle_attr{skill_effect = SkillEffD, hp_lim = HpLim}, Hpb, HpO) ->
    case SkillEffD of
        #skill_effect{hp_lock = {MinHp, MinHpPercent}} when MinHp /= 0 orelse MinHpPercent /=0 ->
            Hp = max(max(MinHpPercent * HpLim, Hpb), MinHp),
            % 不能比受伤前的的hp大，不然就成回血了
            round(min(Hp, HpO));
        _ ->
            Hpb
    end;
calc_hp_lock(_, Hpb, _HpO) -> Hpb.

%% 计算免死
calc_free_die(Der, Hpb) ->
    #battle_attr{skill_effect = SkillEffD} = Der#battle_status.battle_attr,
    #skill_effect{free_die = FreeDie} = SkillEffD,
    if
        Hpb == 0 andalso FreeDie == 1 -> 1;
        true -> Hpb
    end.

%% 计算血量护盾
calc_shield_hp(Hpb, Hurt, DerBA) ->
    #battle_attr{shield_hp = ShieldHp} = DerBA,
    if
        Hurt =< 0 orelse ShieldHp =< 0 -> {Hpb, Hurt, DerBA};
        true ->
            NewHurt = max(0, Hurt-ShieldHp),
            NewShieldHp = max(0, ShieldHp-Hurt),
            NewHpb = if
                ShieldHp >= Hurt -> Hpb + Hurt;
                true -> Hpb + ShieldHp
            end,
            if
                NewShieldHp > 0 ->
                    {NewHpb, NewHurt, DerBA#battle_attr{shield_hp = NewShieldHp}};
                true ->
                    NewOtBuff = lists:keydelete(?SPBUFF_SHIELD, 1, DerBA#battle_attr.other_buff_list),
                    {NewHpb, NewHurt, DerBA#battle_attr{shield_hp = NewShieldHp, other_buff_list = NewOtBuff}}
            end
    end.

%% 计算反弹伤害
%% @return {Aer, ReboundHurt}
%% calc_rebound_hurt(#battle_status{kind=?MON_KIND_IMMUNE}=Aer, _, _) -> {Aer, 0};
calc_rebound_hurt(Aer, Der, Hurt, Broadcast, NowTime) ->
    #battle_status{
        id = AId, copy_id=CopyId, x=X, y=Y, scene = Scene, scene_pool_id = ScenePoolId,
        battle_attr=#battle_attr{hp=Hp, hp_lim=HpLim}=BA, sign = ASign, mid = AMid,
        assist_ids = AssistIds} = Aer,
    #battle_status{
        id = DId, battle_attr = DerBA, sign = DSign, boss_tired = DBossTired, figure = #figure{vip_type = DVipType, vip = DVip}, assist_id = AssistId
    } = Der,
    #battle_attr{attr = #attr{rebound_ratio = ReboundRatio, pvp_rebound_ratio = PvpReboundRatioD}, skill_effect = SkillEffD} = DerBA,
    BossMiss = if
        ASign == ?BATTLE_SIGN_MON andalso DSign == ?BATTLE_SIGN_PLAYER ->
            lib_battle_util:check_boss_missing(Scene, AMid, DBossTired, DVipType, DVip, [AssistId, AssistIds]);
        true ->
            false
    end,
    case SkillEffD#skill_effect.rebound of
        {Int, Float} -> ok;
        _ -> Int = 0, Float = 0
    end,
    PvpReboundRatio = ?IF(ASign == ?BATTLE_SIGN_PLAYER andalso DSign == ?BATTLE_SIGN_PLAYER, PvpReboundRatioD, 0),
    % 原反弹值
    ReboundHurt0 = util:ceil(Hurt * (Float+(ReboundRatio+PvpReboundRatio)/?RATIO_COEFFICIENT) + Int),
    if
        % 只判断
        ReboundHurt0 == 0 -> {Aer, 0};
        BossMiss -> {Aer, 0};
        ASign == ?BATTLE_SIGN_COMPANION ->
            % AerUser = lib_scene_agent:get_user(AId),
            % calc_rebound_hurt_to_user(AerUser, ReboundHurt0, Aer),
            mod_scene_agent:apply_cast_with_state(Scene, ScenePoolId, mod_battle, calc_rebound_hurt_to_user, [AId, ReboundHurt0, DSign, DId]),
            {Aer, 0};
        true ->
            % 计算固定伤害机制
            {MaxHurt, IsDelHpEachTime} = calc_del_hp_each_time(Aer, NowTime),
            % 根据固定伤害机制，计算真实反弹值
            ReboundHurt = if
                is_integer(MaxHurt) ->
                    min(MaxHurt, ReboundHurt0);
                IsDelHpEachTime ->
                    {FixHurt, _} = calc_del_hp_each_time(Aer),
                    FixHurt;
                true ->
                    ReboundHurt0
            end,
            case Hp > ReboundHurt of
                true -> NewHp = Hp-ReboundHurt, AerHurt = ReboundHurt;
                false -> NewHp = 1, AerHurt = Hp-1
            end,
            LastHp = calc_hp_lock(Aer, NewHp, Hp),
            NewAer = Aer#battle_status{battle_attr=BA#battle_attr{hp=LastHp}},
            case LastHp =/= Hp of
                true ->
                    {ok, BinData} = pt_120:write(12036, [ASign, AId, LastHp, HpLim, 1, ReboundHurt, ?SPBUFF_REBOUND, DSign, DId]),
                    % lib_battle:send_to_scene(CopyId, X, Y, Broadcast, BinData);
                    lib_battle:send_hp_change_to_12036(ASign, CopyId, X, Y, Broadcast, BinData);
                false ->
                    skip
            end,
            % 计算每X秒伤害
            AfPerHurtAer = calc_per_hurt(NewAer, AerHurt, NowTime),
            {AfPerHurtAer, AerHurt}
    end.

%% 如果攻击方是伙伴，对玩家造成反弹
calc_rebound_hurt_to_user(RoleId, ReboundHurt0, DSign, DId, #ets_scene{broadcast = Broadcast} = _EtsScene) ->
    User = lib_scene_agent:get_user(RoleId),
    if
        is_record(User, ets_scene_user) == false -> skip;
        % 血量小于0不处理
        User#ets_scene_user.battle_attr#battle_attr.hp =< 0 -> skip;
        true ->
            Aer = lib_battle_util:trans_to_real_atter(User, ?BATTLE_SIGN_PLAYER),
            #battle_status{
                id = AId, copy_id=CopyId, x=X, y=Y,
                battle_attr=#battle_attr{hp=Hp, hp_lim=HpLim}=BA, sign = ASign
                } = Aer,
            NowTime = utime:longunixtime(),
            % 计算固定伤害机制
            {MaxHurt, IsDelHpEachTime} = calc_del_hp_each_time(Aer, NowTime),
            % 根据固定伤害机制，计算真实反弹值
            ReboundHurt = if
                is_integer(MaxHurt) ->
                    min(MaxHurt, ReboundHurt0);
                IsDelHpEachTime ->
                    {FixHurt, _} = calc_del_hp_each_time(Aer),
                    FixHurt;
                true ->
                    ReboundHurt0
            end,
            case Hp > ReboundHurt of
                true -> NewHp = Hp-ReboundHurt, AerHurt = ReboundHurt;
                false -> NewHp = 1, AerHurt = Hp-1
            end,
            % 使用 ets_scene_user 计算锁血，因为 skill_effect 没有计算的
            LastHp = calc_hp_lock(User, NewHp, Hp, NowTime),
            case LastHp =/= Hp of
                true ->
                    {ok, BinData} = pt_120:write(12036, [ASign, AId, LastHp, HpLim, 1, ReboundHurt, ?SPBUFF_REBOUND, DSign, DId]),
                    lib_battle:send_hp_change_to_12036(ASign, CopyId, X, Y, Broadcast, BinData);
                false ->
                    skip
            end,
            NewAer = Aer#battle_status{battle_attr=BA#battle_attr{hp=LastHp}},
            % 计算每X秒伤害
            AfPerHurtAer = calc_per_hurt(NewAer, AerHurt, NowTime),
            EtsAer = lib_battle_util:back_data(AfPerHurtAer, User),
            % 重新计算回血定时器
            HpResumeRef = lib_battle:begin_resume_timer(User#ets_scene_user.hp_resume_ref, ?BATTLE_SIGN_PLAYER, AId, BA, NowTime,
                BA#battle_attr.hp_resume_time*1000),
            % ?MYLOG("battle", "HpResumeRef:~p Hp:~p ReboundHurt0:~p ReboundHurt:~p, NewHp:~p LastHp:~p ~n",
            %     [HpResumeRef, Hp, ReboundHurt0, ReboundHurt, NewHp, LastHp]),
            lib_scene_agent:put_user(EtsAer#ets_scene_user{hp_resume_ref = HpResumeRef})
    end,
    ok.

%% 计算吸血伤害
calc_suck_blood(Aer, SkillEffA, Der, Hurt, Broadcast) ->
    #battle_status{id = Id, sign = Sign, copy_id=CopyId, x=X, y=Y, battle_attr=#battle_attr{hp=Hp, hp_lim=HpLim, attr = Attr}=BA} = Aer,
    #attr{pvp_blood_ratio = PvpBloodRatio} = Attr,
    #battle_status{sign = DerSign, id = DerId} = Der,
    case SkillEffA#skill_effect.suck_blood of
        {Int, Float} -> ok;
        _ -> Int = 0, Float = 0
    end,
    NewPvpBloodRatio = if
        DerSign == ?BATTLE_SIGN_PLAYER -> PvpBloodRatio;
        true -> 0
    end,
    AddHp = round(Hurt * (Float + NewPvpBloodRatio/?RATIO_COEFFICIENT) + Int),
    NewHp = min(HpLim, Hp + AddHp),
    case NewHp =/= Hp of
        true ->
            {ok, BinData} = pt_120:write(12036, [Sign, Id, NewHp, HpLim, 0, AddHp, ?SPBUFF_BLOOD, DerSign, DerId]),
            % lib_battle:send_to_scene(CopyId, X, Y, Broadcast, BinData);
            lib_battle:send_hp_change_to_12036(Sign, CopyId, X, Y, Broadcast, BinData);
        false ->
            skip
    end,
    Aer#battle_status{battle_attr=BA#battle_attr{hp=NewHp}}.

%% 破隐
%% break_steath(Aer, NewAer, SkillR, EtsScene) ->
%%     case SkillR#skill.is_combo==0 andalso
%%         Aer#battle_status.battle_attr#battle_attr.hide == 1 andalso
%%         NewAer#battle_status.battle_attr#battle_attr.skill_effect#skill_effect.hide == 0 of
%%         true ->
%%             BA = NewAer#battle_status.battle_attr,
%%             lib_skill_buff:handle_steath_state(Aer#battle_status.sign, Aer#battle_status.id, Aer#battle_status.copy_id,
%%                                                NewAer#battle_status.x, NewAer#battle_status.y, EtsScene#ets_scene.broadcast, 0, 0, 0),
%%             NewAer#battle_status{battle_attr=BA#battle_attr{hide=0}};
%%         false ->
%%             NewAer
%%     end.

%% 计算怒气
add_anger(Aer) ->
    #battle_attr{anger=Anger, anger_lim=AngerLim} = BA = Aer#battle_status.battle_attr,
    Aer#battle_status{battle_attr=BA#battle_attr{anger=min(Anger+1, AngerLim)}}.

clear_anger(Aer) ->
    BA = Aer#battle_status.battle_attr,
    Aer#battle_status{battle_attr=BA#battle_attr{anger=0}}.

%% 防守方数据更新(玩家)
der_update_scene_info(Der, BattleReturn, RetrunAtter, NowTime) ->
    %% 防守方信息
    #battle_status{id = DefId, node = DefNode, pid = DefPid, att_list = AttList, scene = SceneId, battle_attr = BA} = Der,

    %% 防守方需更新的信息
    #battle_return{hp = Hp, move_x = MoveX, move_y = MoveY} = BattleReturn,
    #battle_return_atter{sign = AerSign, id = AtterId, node = AtterNode} = RetrunAtter,

    User = #ets_scene_user{hit_list = HitList} = lib_scene_agent:get_user(DefId),

    % 只有需要记录的场景才有助攻列表
    IsNeedScene = lib_battle_util:is_need_hit_list(SceneId),
    case AerSign == ?BATTLE_SIGN_PLAYER andalso IsNeedScene of
        true ->
            Hit = #hit{id = AtterId, node = AtterNode, time = NowTime},
            % 只保留12条
            NewHitList = lists:sublist([Hit|lists:keydelete(AtterId, #hit.id, HitList)], 12);
        false ->
            NewHitList = HitList
    end,

    Msg = case Hp > 0 of
        true -> {'battle_info', BattleReturn};
        false -> {'battle_info_die', BattleReturn#battle_return{hit_list = NewHitList}}
    end,

    send_to_node_pid(DefNode, DefPid, Msg),

    Ref1 = lib_battle:begin_resume_timer(User#ets_scene_user.hp_resume_ref, ?BATTLE_SIGN_PLAYER,
        DefId, BA, NowTime, BA#battle_attr.hp_resume_time*1000),

    NewUser = User#ets_scene_user{
        x = case MoveX == 0 of true -> User#ets_scene_user.x; false -> MoveX end,
        y = case MoveY == 0 of true -> User#ets_scene_user.y; false -> MoveY end,
        battle_attr = BA#battle_attr{hp=Hp, attr=User#ets_scene_user.battle_attr#battle_attr.attr}, %% 基础属性不能改
        att_list = AttList,
        skill_cd = Der#battle_status.skill_cd,
        skill_combo = Der#battle_status.skill_combo,
        shaking_skill = Der#battle_status.shaking_skill,
        hp_resume_ref = Ref1,
        hit_list = NewHitList
        },

    %% 打断采集怪物
    NewUser1 = lib_battle:interrupt_collect(NewUser, AtterId),
    lib_scene_agent:put_user(NewUser1),
    ok.

%% 发送消息
send_to_node_pid(Node, Pid, Msg) ->
    if
        Node =:= none andalso Pid =:= none -> skip; %% 打空的时候,两个参数都是none
        Node =:= none -> Pid ! Msg;
        true -> rpc:cast(Node, erlang, send, [Pid, Msg])
    end.

%% 远程过程调用函数(跨服中心服->单服跨服节点)
rpc_cast_to_node(Node, M, F, A) ->
    case Node =:= none of
        true  -> erlang:apply(M, F, A);
        false -> rpc:cast(Node, M, F, A)
    end.

%% 测试战斗公式
%% AttrKvLA [{1,1000},{2,1000},{3,1000}]
%% AttrKvLB [{1,1000},{2,1000},{3,1000}]
ts_battle_formula() ->
    AttrKvLA = [{1,1000},{2,1000},{3,1000}],
    AttrKvLB = [{1,1000},{2,1000},{3,1000}],
    ts_battle_formula(1, AttrKvLA, 100, AttrKvLB, 50, 200201, 1).

ts_battle_formula(Num, AttrKvLA, LvA, AttrKvLB, LvB, SkillId, SkillLv) ->
    BAA = lib_player_attr:set_battle_attr(#battle_attr{attr = #attr{}, skill_effect = #skill_effect{}}, AttrKvLA),
    BAD = lib_player_attr:set_battle_attr(#battle_attr{attr = #attr{}, skill_effect = #skill_effect{}}, AttrKvLB),
    Aer = #battle_status{figure = #figure{lv = LvA}, battle_attr=BAA},
    Der = #battle_status{figure = #figure{lv = LvB}, battle_attr=BAD},
    SkillR = data_skill:get(SkillId, SkillLv),
    List = ts_battle_formula_help(Num, Aer, Der, SkillR, []),
    ?MYLOG("battleformula", "[{HurtType, SecHurtType, Hpb1, Hurt1, RealHurt}]:~p ~n", [List]),
    List.

ts_battle_formula_help(0, _Aer, _Der, _SkillR, List) -> List;
ts_battle_formula_help(Num, Aer, Der, SkillR, List) ->
    % 计算伤害类型
    HurtType = calc_hurt_type(Aer, Der, 1),
    SecHurtType = calc_sec_hurt_type(Der),
    {Hpb1, Hurt1, RealHurt} = calc_hurt(Aer, Der, SkillR, 0, HurtType, SecHurtType, utime:longunixtime(), 1),
    ts_battle_formula_help(Num-1, Aer, Der, SkillR, [{HurtType, SecHurtType, Hpb1, Hurt1, RealHurt}|List]).

-ifdef(DEV_SERVER).
%% 检查副本断点
%% TODO:测试完要处理掉
dungeon_breakpoint(#battle_status{sign = AerSign} = Aer, DerList, NowTime, ComboHurtList, EtsScene, CheckPkSafeTime) ->
    % 副本场景特殊处理
    if
        AerSign == ?BATTLE_SIGN_PLAYER andalso EtsScene#ets_scene.type == ?SCENE_TYPE_DUNGEON
                andalso EtsScene#ets_scene.cls_type == ?SCENE_CLS_TYPE_GAME
                % 精灵副本和经验副本
                andalso (EtsScene#ets_scene.id == 2025 orelse EtsScene#ets_scene.id == 2002)->
            CheckPkF = fun(CanAttDer, {PkSatisfying, PkNotSatisfying}) ->
                CheckPk = lib_battle:check_pk_and_safe(Aer, CanAttDer, EtsScene, CheckPkSafeTime),
                CheckCombo = check_combo_hurt_list(ComboHurtList, CanAttDer),
                case CheckPk == true andalso CheckCombo == false of
                    true -> {[CanAttDer|PkSatisfying], PkNotSatisfying};
                    false -> {PkSatisfying, [{CheckPk, CheckCombo, CanAttDer}|PkNotSatisfying]}
                end
            end,
            {PkSatisfying, PkNotSatisfying} = lists:foldl(CheckPkF, {[], []}, DerList),
            case DerList =/= [] andalso PkNotSatisfying == [] of
                true -> skip;
                false ->
                    #battle_status{
                        id=IdA, x = X, y = Y,
                        battle_attr=#battle_attr{pk=AerPk, group=GroupA, ghost=GhostA, is_hurt_mon = IsHurtMon},
                        team_id=TeamIdA, guild_id=GuildIdA, skill_owner=_SkillOwnerA, in_sea = _InSeaA, server_id = _ServerIdA, camp_id = _CampA,
                        boss_tired = _BossTired, figure = #figure{vip_type = _VipType, vip = _VipLv}, assist_id = _AssistId
                    } = Aer,
                    AerInfo = {AerPk, GroupA, GhostA, IsHurtMon, TeamIdA, GuildIdA, X, Y},
                    case get(dungeon_breakpoint) of
                        % 同一个玩家持有90秒
                        {IdA, Count, StTime} when NowTime =< StTime + 90*1000 andalso
                                (Count == 19 orelse Count == 39) ->
                            case PkNotSatisfying of
                                [{CheckPk, CheckCombo, NoCanAttDer}|_] ->
                                    #battle_status{
                                        mid = DMid, battle_attr=#battle_attr{hp = DerHp, pk=DerPk, group=GroupD, ghost=GhostD},
                                        team_id=TeamIdD, guild_id=GuildIdD, skill_owner=_SkillOwnerD, is_be_atted=IsBeAttedD, in_sea = _InSeaD, be_att_limit = BeAttLimitD,
                                        server_id = _ServerIdB, camp_id = _CampB, assist_ids = _AssistIds
                                    } = NoCanAttDer,
                                    DerInfo = {CheckPk, CheckCombo, {DMid, DerHp, DerPk, GroupD, GhostD, TeamIdD, GuildIdD, IsBeAttedD, BeAttLimitD}};
                                _ ->
                                    DerInfo = []
                            end,
                            About = lists:concat([
                                "SceneId:", EtsScene#ets_scene.id,
                                "AerInfo-{AerPk, GroupA, GhostA, IsHurtMon, TeamIdA, GuildIdA, X, Y}:", util:term_to_string(AerInfo),
                                ",DerInfo-CheckPk, CheckCombo, {DMid, DerHp, DerPk, GroupD, GhostD, TeamIdD, GuildIdD, IsBeAttedD, BeAttLimitD}}:", util:term_to_string(DerInfo),
                                ",Count:", Count, ",StTime:", StTime, "
                                ,Num:", util:term_to_string({length(PkSatisfying), length(PkNotSatisfying)})
                                ]),
                            lib_log_api:log_game_error(IdA, 1, About),
                            put(dungeon_breakpoint, {IdA, Count+1, StTime});
                        {IdA, Count, StTime} when NowTime =< StTime + 90*1000 ->
                            put(dungeon_breakpoint, {IdA, Count+1, StTime});
                        % 其他玩家不处理
                        {_RoleId, _Count, StTime} when NowTime =< StTime + 90*1000 ->
                            skip;
                        _ ->
                            put(dungeon_breakpoint, {IdA, 1, NowTime})
                    end
            end;
        true ->
            skip
    end,
    ok.
-else.
dungeon_breakpoint(_, _, _, _, _, _) ->
    skip.
-endif.
