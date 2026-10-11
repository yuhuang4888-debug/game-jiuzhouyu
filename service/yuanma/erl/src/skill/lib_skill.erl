%%%-----------------------------------
%%% @Module  : lib_skill
%%% @Author  : zzm
%%% @Created : 2013.12.2
%%% @Description: 技能
%%%-----------------------------------
-module(lib_skill).
-include("common.hrl").
-include("server.hrl").
-include("skill.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("attr.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_fun.hrl").
-include("buff.hrl").
-include("guild.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("wing.hrl").
-include("mount.hrl").
-include("eudemons.hrl").
-include("pet.hrl").
-include("arbitrament.hrl").
-include("rec_dress_up.hrl").
-include("reincarnation.hrl").
-include("dragon.hrl").
-include("dungeon.hrl").
-include("back_decoration.hrl").
-include("arcana.hrl").
-include("task.hrl").
-include("team.hrl").

-export([
        handle_event/2,
        create_role_full_skill/1,
        clear_role_full_skill/1,
        skill_online/4,
        recalc_quickbar/1,
        recalc_quickbar_help/4,
        ensure_fixed_quickbar/1,
        get_my_skill_list/1,
        get_skill_passive/1,
        get_passive_share_skill_list/1,
        send_passive_share_skill_list/1,

        %% 技能强化
        send_skill_stren_info/1,
        stren_skill/2,
        onekey_stren_skill/1,
        get_skill_stren/2,
        get_skill_stren_for_battle/2,

        upgrade_skill/2,
        immediate_upgrade_skill/2,
        auto_learn_skill/2,
        add_tmp_skill_list/3,
        add_tmp_skill_list/2,
        del_tmp_skill_list/2,
        get_ori_normal_skill/2,  %% 获取角色创建角色时候的普攻技能
        divide_passive_skill/1,
        divide_passive_share_skill/2,
        divide_team_passive_share_skill/1,
        is_normal_skill_without_combo/1,
        is_normal_skill/1,
        get_skill_attr2mod/3,
        count_skill_attr_with_mod_id/2,
        get_passive_skill_attr/1,
        get_passive_skill_sec_attr/1,
        update_skill_attribute_for_ps/1,
        reset_talent_skill/1,
        make_scene_quickbar/1,
        replace_skill_level/3,
        is_open_all_career_skill/1,
        get_open_skill_lv/2
       ,get_all_talent_skill/1
       ,transfer_talent_skill/1
        ,transfer_dungeon_skill/1
    ]).

-export([
        get_talent_skill_type_info/1,
        check_talent_skill_learn/7,
        get_talent_type_use_point/2,
        give_def_talent_skill_point/1
        , get_talent_extra_attr/2
    ]).

-export([
    make_skill_use_call_back/3
    , handle_af_use_skill_success/1
    , add_energy/2
    , del_energy/2
    , set_energy/2
    ]).

%% 处理玩家事件
handle_event(PS, #event_callback{type_id=?EVENT_LV_UP}) ->
    #player_status{figure=#figure{lv=Lv}} = PS,
    auto_learn_skill(PS, {lv, Lv});
handle_event(PS, _) -> {ok, PS}.

%% 增加临时技能
add_tmp_skill_list(PS, SkillId, SkillLv) ->
    #player_status{skill=Skill} = PS,
    {ok, PS#player_status{skill=Skill#status_skill{tmp_skill_list=[{SkillId, SkillLv}|Skill#status_skill.tmp_skill_list]}}}.

add_tmp_skill_list(PS, SkillList) ->
    #player_status{skill=Skill} = PS,
    {ok, PS#player_status{skill=Skill#status_skill{tmp_skill_list=SkillList++Skill#status_skill.tmp_skill_list}}}.

%% 移除临时技能
del_tmp_skill_list(PS, SkillId) when is_integer(SkillId) ->
    #player_status{skill=Skill} = PS,
    {ok, PS#player_status{skill=Skill#status_skill{tmp_skill_list=lists:keydelete(SkillId, 1, Skill#status_skill.tmp_skill_list)}}};
del_tmp_skill_list(PS, SkillList) ->
    #player_status{skill=Skill} = PS,
    {ok, PS#player_status{skill=Skill#status_skill{tmp_skill_list=Skill#status_skill.tmp_skill_list--SkillList}}}.

%% 创建角色时给满技能(测试时期暂时去掉)
create_role_full_skill(PS) ->
    #player_status{skill = StatusSkill, figure = Figure} = PS,
    Skills = lib_skill_api:get_career_skill_ids(Figure#figure.career, Figure#figure.sex),
    F = fun({SkillId, MaxLv}, List) ->
        case data_skill:get(SkillId, MaxLv) of
            #skill{type=Type, is_combo=0, lv_data = LvData}
              when (Type == ?SKILL_TYPE_ACTIVE orelse Type == ?SKILL_TYPE_ASSIST) andalso LvData#skill_lv.condition == [] ->
                [{SkillId, MaxLv}|List];
            _ -> List
        end
    end,
    SkillList = lists:foldl(F, [], Skills),
    PS#player_status{skill=StatusSkill#status_skill{skill_list=SkillList}}.

%% 重新整理角色技能(读取数据库，谨慎使用)
clear_role_full_skill(#player_status{id=Id, skill=Sk} = PS) ->
    SkillList = get_all_skill(Id),
    PS#player_status{skill=Sk#status_skill{skill_list=SkillList}}.

%% 玩家登录加载技能数据
skill_online(RoleId, _Career, _Lv, AllPoint) ->
    %% 职业技能初始化
    SkillList = get_all_skill(RoleId),
    SkillAttr = get_passive_skill_attr(SkillList),
    CarreerSkillStatus = #status_skill{
        skill_list = SkillList,
        skill_passive = divide_passive_skill(SkillList),
        skill_attr = SkillAttr
    },
    %% 天赋技能初始化
    SkillTalentList = get_all_talent_skill(RoleId),
    {UsePoint, SkillPower, _L} = get_talent_skill_type_info(SkillTalentList),
    SkillTalentAttr = get_passive_skill_attr(SkillTalentList),
    StrenList = get_role_skill_stren_list(RoleId),
    TalentSkillStatus = CarreerSkillStatus#status_skill{
        skill_talent_list = SkillTalentList,
        skill_talent_passive = divide_passive_skill(SkillTalentList),
        skill_talent_attr = SkillTalentAttr,
        skill_talent_sec_attr = get_passive_skill_sec_attr(SkillTalentList),
        point = AllPoint,
        skill_power = SkillPower,
        use_point = UsePoint
        , stren_list = StrenList
        , stren_power = calc_stren_power(StrenList)
    },
    TalentSkillStatus.

%% 重新计算快捷栏
recalc_quickbar(Player) ->
    #player_status{id = RoleId, figure = #figure{career = Career}, skill = StatusSkill, quickbar = Quickbar} = Player,
    #status_skill{skill_list = SkillL} = StatusSkill,
    if
        Quickbar == [] ->
            FixedQuickbar = data_skill_m:get_fixed_quickbar(Career),
            F = fun({_, _, SkillId, _}=T, {TmpFixedQuickbar, LeftSkillL}) ->
                NewTmpFixedQuickbar = case lists:keymember(SkillId, 1, SkillL) of
                    true -> [T|TmpFixedQuickbar];
                    false -> TmpFixedQuickbar
                end,
                NewLeftSkillL = lists:keydelete(SkillId, 1, LeftSkillL),
                {NewTmpFixedQuickbar, NewLeftSkillL}
            end,
            {NewFixedQuickbar, LeftSkillL} = lists:foldl(F, {[], SkillL}, lists:reverse(FixedQuickbar)),
            OtherQuickbarPosL = ?QUICKBAR -- data_skill_m:get_fixed_quickbar_pos_list(),
            OtherQuickbar = recalc_quickbar_help(OtherQuickbarPosL, lists:keysort(1, LeftSkillL), Career, []),
            NewQuickbar = NewFixedQuickbar ++ OtherQuickbar,
            NewPlayer = Player#player_status{quickbar = NewQuickbar};
        true ->
            NewPlayer = ensure_fixed_quickbar(Player)
    end,
    {_IsChange, PlayerAfRe} = lib_arcana:re_quickbar(NewPlayer),
    #player_status{quickbar = NewQuickbar2} = PlayerAfRe,
    case NewQuickbar2 == Quickbar of
        true -> skip;
        false -> lib_player:db_save_quickbar(RoleId, Quickbar)
    end,
    NewPlayer.

recalc_quickbar_help([], _QuickSkillL, _Career, QuickBar) -> lists:reverse(QuickBar);
recalc_quickbar_help(_PosL, [], _Career, QuickBar) -> lists:reverse(QuickBar);
recalc_quickbar_help([Pos|LeftPosL] = PosL, [{SkillId, Lv}|SkillL], Career, QuickBar) ->
    case data_skill:get(SkillId, Lv) of
        #skill{career = Career, is_combo = 0} ->
            NewQuickBar = [{Pos, ?QUICKBAR_TYPE_SKILL, SkillId, 1}|QuickBar],
            recalc_quickbar_help(LeftPosL, SkillL, Career, NewQuickBar);
        _ ->
            recalc_quickbar_help(PosL, SkillL, Career, QuickBar)
    end.

%% 确保固定技能列表
ensure_fixed_quickbar(Player) ->
    #player_status{figure = #figure{career = Career}, skill = StatusSkill, quickbar = Quickbar} = Player,
    #status_skill{skill_list = SkillL} = StatusSkill,
    FixedQuickbar = data_skill_m:get_fixed_quickbar(Career),
    F = fun({Pos, Type, SkillId, Auto}, TmpQuickbar) ->
        case lists:keymember(SkillId, 1, SkillL) of
            true -> 
                ReskillId = lib_arcana:get_high_reskill_id(Player, SkillId),
                case lists:keyfind(Pos, 1, Quickbar) of
                    false -> [{Pos, Type, ReskillId, Auto}|TmpQuickbar];
                    _ -> lists:keystore(Pos, 1, TmpQuickbar, {Pos, Type, ReskillId, Auto})
                end;
            false -> 
                TmpQuickbar
        end
    end,
    NewQuickbar = lists:foldl(F, Quickbar, FixedQuickbar),
    Player#player_status{quickbar = NewQuickbar}.

%% 发送技能列表
get_my_skill_list(#player_status{figure = #figure{career = Career, sex = Sex}} = PS) ->
    Sk = PS#player_status.skill,
    All = lib_skill_api:get_career_all_skill_ids(Career, Sex),
    F = fun({SkillId, _OldLv}, TmpSkillList) -> 
        case lists:keyfind(SkillId, 1, Sk#status_skill.skill_list) of
            false -> [{SkillId, 0}|TmpSkillList];
            {_, SkillLv} -> [{SkillId, SkillLv}|TmpSkillList]
        end
    end,
    F2 = fun({SkillId, SkillLv}, TmpSkillList) ->
        case data_skill:get(SkillId, SkillLv) of
            #skill{is_combo = 0, combo = Combo} ->
                F3 = fun({TmpSkillId, _, _}, TmpSkillList2) -> lists:keystore(TmpSkillId, 1, TmpSkillList2, {TmpSkillId, SkillLv}) end,
                lists:foldl(F3, TmpSkillList, Combo);
            _ ->
                TmpSkillList
        end
    end,
    % 远古奥术的技能列表
    ArcanaSkill = lib_arcana:get_active_skill(PS),
    % 伙伴（新 技能
    CompanionSkill = lib_companion_util:get_active_skill(PS),
    List = lists:foldl(F, [], All) ++ ArcanaSkill ++ CompanionSkill,
    ListWithCombo = lists:foldl(F2, List, List),
    {ok, BinData} = pt_210:write(21002, [ListWithCombo]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData).

%% TODO: hjh
% %% 获取总技能列表，包括其他系统技能
% %% 排除了其他战斗单位的技能
% get_sum_skill(PS) ->
%     case data_scene:get(PS#player_status.scene) of 
%         #ets_scene{type=SceneType} -> ok;
%         _ -> SceneType = 0
%     end,
%     if
%         SceneType == ?SCENE_TYPE_KFSUR andalso is_record(PS#player_status.kfsur_status, kfsur_status) ->
%             get_sum_skill(PS, kfsur);
%         true ->
%             get_sum_skill(PS, battle)
%     end.
    
% get_sum_skill(PS = #player_status{skill = #status_skill{skill_list = SkillList}}, kfsur) ->
%     DragonSkillLvList = lib_dragon_api:get_skill_list(PS),
%     KfSurSkillLvList = lib_kf_survival:get_skill_list(PS),
%     GodSkillList = lib_god_api:get_god_skill(PS),
%     %?PRINT("GodSkillList ~w ~n DragonSkillLvList ~w ~n", [GodSkillList, DragonSkillLvList]),
%     KfSurSkillLvList ++ DragonSkillLvList ++ GodSkillList ++ SkillList;

% get_sum_skill(PS = #player_status{skill = #status_skill{skill_list = SkillList}}, _Type) ->
%     ArtifactSkillIdLvList = lib_artifact_api:get_artifact_battle_skill(PS),
%     TrainSkillIdLvList    = lib_role_train:get_skills(0, PS),
%     DemonSkillIdLvList    = lib_demons_api:get_demon_battle_skill(PS),
%     HuanhuaSkillIdLvList  = lib_huanhua:get_huanhua_skill(PS),
%     TrainSkillList = filter_train_skill(TrainSkillIdLvList, 0),
%     DemonSkillList = filter_train_skill(DemonSkillIdLvList, 0),
%     DragonSkillLvList = lib_dragon_api:get_skill_list(PS),
%     GodSkillList = lib_god_api:get_god_skill(PS),
%     KfInvadeList = lib_kf_invade_api:calc_skill_list(PS),
%     StarSkillList = lib_star:get_skill_list(PS),
%     RoleHomeSkillList = lib_role_home:get_role_home_skill(PS),
%     %?PRINT("Artifact ~w, Train ~w, role ~w~n", [ArtifactSkillIdLvList, TrainSkillIdLvList, SkillList]),

%     AllSkillList =  HuanhuaSkillIdLvList ++ ArtifactSkillIdLvList ++ TrainSkillList ++ DemonSkillList ++ DragonSkillLvList 
%         ++ GodSkillList ++ KfInvadeList ++ SkillList ++ StarSkillList ++ RoleHomeSkillList,
%     % ?INFO("ArtifactSkillIdLvList:~p, TrainSkillIdLvList:~p DemonSkillIdLvList:~p HuanhuaSkillIdLvList:~p TrainSkillList:~p 
%     %         DemonSkillList:~p DragonSkillLvList:~p GodSkillList:~p KfInvadeList:~p AllSkillList:~w ~n", 
%     %     [ArtifactSkillIdLvList, TrainSkillIdLvList, DemonSkillIdLvList, HuanhuaSkillIdLvList, TrainSkillList, 
%     %         DemonSkillList, DragonSkillLvList, GodSkillList, KfInvadeList, AllSkillList]),
%     AllSkillList.

%% 计算被动技能
get_skill_passive(PS) ->
    %% 被动技能(各种被动累加的技能列表)
    case get_skill_passive_from_special_module(PS) of 
        week_dungeon ->
            lib_week_dungeon:get_skill_passive(PS);
        sea_daily ->  % sea_daily
            [];
        _ ->
            #status_skill{skill_passive = SkillPassive,
                          skill_talent_passive = SkillTalentPassive} = PS#player_status.skill,
            MountPassiveSkill = lib_mount:get_all_passive_skills(PS),    % 外形类总属性
            %% FairyPassiveSkill = lib_fairy:get_all_passive_skill_attr(PS),
            #status_wing{passive_skills = WingPassiveSkill} = PS#player_status.status_wing,
            #mount_equip{passive_skills = MountEquipPassiveSkill} = PS#player_status.mount_equip,
            #eudemons_status{passive_skills = EudemonsSkills} = PS#player_status.eudemons,
            #status_pet{
                pet_aircraft = #pet_aircraft{aircraft_skills = AircraftSkills},
                pet_wing = #pet_wing{wing_skills = WingSkills}
            } = PS#player_status.status_pet,
            #arbitrament_status{passive_skills = ArbitramentSkillList} = PS#player_status.arbitrament_status,
            #status_dress_up{skill = DressSkillList} = PS#player_status.dress_up,
            #status_dragon{skill_list = DragonSkillList} = PS#player_status.dragon,
            GodSkill = lib_god:get_god_passive_skill(PS),
            RuneSkill = lib_rune:get_rune_passive_skill(PS),
            #status_dungeon_skill{skill_list = DunSkillList} = PS#player_status.dungeon_skill,
            BabySkillList = lib_baby:get_baby_skills(PS),
            RevelationEquipList = lib_revelation_equip:get_skill(PS),
            DemonsSkill = lib_demons:get_demons_skill(PS),
            SupVipSkill = lib_supreme_vip_api:get_passive_skill(PS),
            ModBuffSkill = lib_module_buff:get_passive_skill(PS),
            #back_decoration_status{skills = BackDecoraSkill} = PS#player_status.back_decoration_status,
            CompanionSkill = lib_companion_util:get_passive_skill(PS),
            ArcanaSkill = lib_arcana:get_passive_skill(PS),
            DsgtSkill = lib_designation:get_dsgt_passive_skill(PS),
            DragonBallSkill = lib_dragon_ball:get_passive_skills(PS),
            FairyBuySkill = lib_fairy_buy:get_passive_skill(PS),
            SkillPassive ++ MountPassiveSkill ++ WingPassiveSkill ++ SkillTalentPassive ++ EudemonsSkills ++
            ModBuffSkill ++ AircraftSkills ++ WingSkills ++ MountEquipPassiveSkill ++ ArbitramentSkillList ++
            DressSkillList ++ DragonSkillList ++ DunSkillList ++ BabySkillList ++ GodSkill ++
            RevelationEquipList ++ DemonsSkill ++ SupVipSkill ++ RuneSkill ++ BackDecoraSkill ++
            ArcanaSkill ++ CompanionSkill ++ DsgtSkill ++ DragonBallSkill ++ FairyBuySkill
    end.

%% 获取共享技能列表
get_passive_share_skill_list(Player) ->
    #player_status{dungeon_skill = #status_dungeon_skill{passive_share_skill_list = ShareSkillL}} = Player,
    case get_skill_passive_from_special_module(Player) of 
        week_dungeon -> [];
        sea_daily -> [];
        _ -> ShareSkillL
    end.

%% 发送共享技能列表（非组队的发送）
send_passive_share_skill_list(#player_status{id = RoleId, team = #status_team{team_id = TeamId}} = Player) ->
    case TeamId > 0 of
        true ->
%%	        ?MYLOG("dunskill", "TeamId:~p ~n", [TeamId]),
	        skip;
        false ->
            PassivShareSkillL = lib_skill:get_passive_share_skill_list(Player),
%%            ?MYLOG("dunskill", "PassivShareSkillL:~p ~n", [PassivShareSkillL]),
            {ok, BinData} = pt_120:write(12093, [PassivShareSkillL]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    ok.

filter_auto_learn_skill(Career, Sex, Event) ->
    case Event of
        login ->
            SkillIds = lib_skill_api:get_career_all_skill_ids(Career, Sex),
            %% 不检查需要转生才能学习的技能
            FilterF = fun(T) ->
                case T of
                    % {turn, _Turn} -> false;
                    _ -> true
                end
            end;
        {lv, RoleLv} ->
            SkillIds = lib_skill_api:get_career_all_skill_ids(Career, Sex),
            FilterF = fun(T) ->
                case T of
                    {lv, TRoleLv} when TRoleLv =/= RoleLv -> false;
                    _ -> true
                end
            end;
        {finish_dun, DunId} ->
            SkillIds = lib_skill_api:get_career_all_skill_ids(Career, Sex),
            FilterF = fun(T) ->
                case T of
                    {finish_dun, TDunId} when TDunId =/= DunId -> false;
                    _ -> true
                end
            end;
        {eternal_valley, ChapterId} ->
            SkillIds = lib_skill_api:get_career_all_skill_ids(Career, Sex),
            FilterF = fun(T) ->
                case T of
                    {yhbg, TChapterId} when TChapterId =/= ChapterId -> false;
                    _ -> true
                end
            end;
        {turn, Turn, _ReSkillList} ->
            SkillIds = lib_skill_api:get_career_all_skill_ids(Career, Sex),
            FilterF = fun(T) ->
                case T of
                    {turn, TTurn} when TTurn =/= Turn -> false;
                    _ -> true
                end
            end;
        {transfer, _ReSkillList} ->
            SkillIds = lib_skill_api:get_career_skill_ids(Career, Sex),
            FilterF = fun(T) ->
                case T of
                    _ -> true
                end
            end;
        {achiv_stage, AchivStage} ->
            SkillIds = lib_skill_api:get_career_all_skill_ids(Career, Sex),
            FilterF = fun(T) ->
                case T of
                    {achiv_stage, TAchivStage} when TAchivStage =/= AchivStage -> false;
                    _ -> true
                end
            end;
        {task_id, TaskId} ->
            SkillIds = lib_skill_api:get_career_all_skill_ids(Career, Sex),
            FilterF = fun(T) ->
                case T of
                    {task_id, TTaskId} when TTaskId =/= TaskId -> false;
                    _ -> true
                end
            end;
        _ -> SkillIds = [], FilterF = []
    end,
    F = fun({SkillId, _}, Acc) ->
        case data_skill:get(SkillId, ?DEFAULT_SKILL_LV) of
            #skill{is_combo = 0, lv_data = LvData} = SkillData ->
                case lists:all(FilterF, LvData#skill_lv.condition) of
                    true -> [SkillData|Acc];
                    false -> Acc
                end;
            _ -> Acc
        end
    end,
    case SkillIds =/= [] of
        true ->
            lists:foldl(F, [], SkillIds);
        false -> []
    end.

af_auto_learn_skill(RoleId, Career, Sex, Turn, QuickBar, AddSkillIds, Event) ->
    case Event of
        {turn, _Turn, ReSkillList} ->
            F = fun(T) ->
                lists:keyfind(T, 2, ReSkillList) == false
            end,
            LastAddSkillIds = lists:filter(F, AddSkillIds),
            F1 = fun(T) ->
                case T of
                    {QLocal, QType, QSId, QSAutoTag} when QType == ?QUICKBAR_TYPE_SKILL ->
                        case lists:keyfind(QSId, 1, ReSkillList) of
                            {QSId, NQSId} -> {QLocal, QType, NQSId, QSAutoTag};
                            _ -> {QLocal, QType, QSId, QSAutoTag}
                        end;
                    _Other -> _Other
                end
            end,
            %% 快捷栏替换掉旧的转生技能
            NewQuickBar = lists:map(F1, QuickBar);
        {transfer, ReSkillList} ->
            F = fun(T) ->
                lists:keyfind(T, 1, ReSkillList) == false
            end,
            LastAddSkillIds = lists:filter(F, AddSkillIds),
            F1 = fun(T) ->
                case T of
                    {QLocal, QType, QSId, QSAutoTag} when QType == ?QUICKBAR_TYPE_SKILL ->
                        case lists:keyfind(QSId, 1, ReSkillList) of
                            {QSId, NQSId} -> {QLocal, QType, NQSId, QSAutoTag};
                            _ -> {QLocal, QType, QSId, QSAutoTag}
                        end;
                    _Other -> _Other
                end
            end,
            %% 快捷栏替换掉旧的转生技能
            TmpBarL = lists:map(F1, QuickBar),
            %% 玩家没有设置普通技能自动帮玩家设置
            NewQuickBar = TmpBarL;
        login ->
            %% 如果避免转生自动学技能的时候出错，玩家登录的时候技能快捷栏增加自动修复，对于不符合当前转生等级技能自动移除
            LastAddSkillIds = AddSkillIds,
            F = fun(TmpTurn, Acc) ->
                data_reincarnation:get_reincarnation_reskill(Career, Sex, TmpTurn) ++ Acc
            end,
            ReSkillList = lists:foldl(F, [], lists:seq(0, Turn)),
            F1 = fun(T) ->
                case T of
                    {QLocal, QType, QSId, QSAutoTag} when QType == ?QUICKBAR_TYPE_SKILL ->
                        case lists:keyfind(QSId, 1, ReSkillList) of
                            {QSId, NQSId} -> {QLocal, QType, NQSId, QSAutoTag};
                            _ -> {QLocal, QType, QSId, QSAutoTag}
                        end;
                    _Other -> _Other
                end
            end,
            NewQuickBar = lists:map(F1, QuickBar);
        _ ->
            LastAddSkillIds = AddSkillIds,
            NewQuickBar = QuickBar
    end,
    %% 有空的快捷栏要替换上新学的技能
    LastQuickBar = auto_equip_quick_bar(?QUICKBAR, LastAddSkillIds, Career, NewQuickBar),
    lib_player:db_save_quickbar(RoleId, LastQuickBar),
    LastQuickBar.

%% IndexList 有锁的要放在前面
auto_equip_quick_bar(IndexList, SkillList, Career, Quickbar) ->
    F = fun(Index) -> lists:member(Index, data_skill_m:get_fixed_quickbar_pos_list()) end,
    {Satisfying, NotSatisfying} = lists:partition(F, IndexList),
    auto_equip_quick_bar_help(Satisfying++NotSatisfying, lists:sort(SkillList), Career, Quickbar).

auto_equip_quick_bar_help([], _, _Career, Quickbar) -> Quickbar;
auto_equip_quick_bar_help(_, [], _Career, Quickbar) -> Quickbar;
auto_equip_quick_bar_help([Index|IndexT], [SkillId|SkillT]=SkillList, Career, Quickbar) ->
    IsMember = lists:keymember(Index, 1, Quickbar),
    FixedQuickbarPosL = data_skill_m:get_fixed_quickbar_pos_list(),
    IsFixed = lists:member(Index, FixedQuickbarPosL),
    if
        IsMember -> auto_equip_quick_bar_help(IndexT, SkillList, Career, Quickbar);
        IsFixed ->
            FixedQuickbar = data_skill_m:get_fixed_quickbar(Career),
            case lists:keyfind(Index, 1, FixedQuickbar) of
                {Index, _, TmpSkillId, _} ->
                    case lists:member(TmpSkillId, SkillList) of
                        true ->
                            NewSkillList = lists:delete(TmpSkillId, SkillList),
                            NewQuickbar = lists:keystore(Index, 1, Quickbar, {Index, ?QUICKBAR_TYPE_SKILL, TmpSkillId, 1});
                        false ->
                            NewSkillList = SkillList,
                            NewQuickbar = Quickbar
                    end,
                    auto_equip_quick_bar_help(IndexT, NewSkillList, Career, NewQuickbar);
                _ ->
                    auto_equip_quick_bar_help(IndexT, SkillList, Career, Quickbar)
            end;
        true ->
            case data_skill:get(SkillId, ?DEFAULT_SKILL_LV) of
                % 连接技能中非主技能不能进入快捷栏
                #skill{career = Career, skill_link = [TmpSkillId|_]} when SkillId =/= TmpSkillId -> NewQuickbar = Quickbar;
                #skill{career = Career, is_combo = 0} ->
                    case lists:keyfind(SkillId, 3, Quickbar) of
                        false ->
                            NewQuickbar = lists:keystore(Index, 1, Quickbar, {Index, ?QUICKBAR_TYPE_SKILL, SkillId, 1});
                        _ -> 
                            NewQuickbar = Quickbar
                    end;
                _ ->
                    NewQuickbar = Quickbar
            end,
            auto_equip_quick_bar_help(IndexT, SkillT, Career, NewQuickbar)
    end.

%%--------------------------------------------------
%% 自动学习技能
%% @param  PS    #player_status{}
%% @param  Event login|{lv,玩家等级}|{turn,玩家转生数,技能替换列表}|{eternal_valley,永恒碑谷完成章节id}|{finish_dun,完成副本id}|{transfes, 技能替换列表}
%% @return       description
%%--------------------------------------------------
auto_learn_skill(PS, Event) ->
    #player_status{id=RoleId, figure=#figure{career=Career, sex = Sex, name = Name, turn = Turn}, skill=Sk, quickbar = QuickBar} = PS,
    case filter_auto_learn_skill(Career, Sex, Event) of
        CandidateList when CandidateList =/= [] ->
            F = fun(SkillData, {PassiveSkill, SkillListTmp, AddSkillIdsTmp}) ->
                #skill{id=SkillId, type=Type, is_normal = IsNormal, is_combo=0, skill_link = SkillLink, lv_data=LvData} = SkillData,
                case lists:keyfind(SkillId, 1, Sk#status_skill.skill_list) of
                    false ->
                        case check_upgrade(PS, LvData#skill_lv.condition, [0, [], 0]) of
                            {true, [0, [], _Point]} -> %% 满足条件没有学,并且没有消耗
                                NPassiveSkill = ?IF(Type == ?SKILL_TYPE_PASSIVE, [SkillId|PassiveSkill], PassiveSkill),
                                db_update_skill(RoleId, SkillId, 1, 0),
                                lib_log_api:log_skill_lv_up(RoleId, SkillId, 0, 1, 1, [], utime:unixtime()),
                                case IsNormal == 1 andalso SkillLink =/= [] andalso hd(SkillLink) =/= SkillId of
                                    true ->
                                        {NPassiveSkill, [{SkillId, 1}|SkillListTmp], AddSkillIdsTmp};
                                    _ when Type == ?SKILL_TYPE_PASSIVE -> %% 被动不用新学习的列表
                                        {NPassiveSkill, [{SkillId, 1}|SkillListTmp], AddSkillIdsTmp};
                                    _ ->
                                        {NPassiveSkill, [{SkillId, 1}|SkillListTmp], [SkillId|AddSkillIdsTmp]}
                                end;
                            _ -> %% 不满足条件
                                {PassiveSkill, SkillListTmp, AddSkillIdsTmp}
                        end;
                    _ -> %% 已经学习了这个技能
                        {PassiveSkill, SkillListTmp, AddSkillIdsTmp}
                end
            end,
            {AddPassiveSkills, NewSkillList, AddSkillIds} = lists:foldl(F, {[], Sk#status_skill.skill_list, []}, CandidateList),
            NewQuickBar = af_auto_learn_skill(RoleId, Career, Sex, Turn, QuickBar, AddSkillIds, Event),
            NewPS = PS#player_status{quickbar = NewQuickBar, skill = Sk#status_skill{skill_list = NewSkillList}},
            if
                Event =/= login andalso (AddSkillIds =/= [] orelse AddPassiveSkills =/= []) ->
                    get_my_skill_list(NewPS),
                    case AddPassiveSkills =/= [] of
                        true ->
                            case Event of
                                {finish_dun, DunId} ->
                                    [PSkillId|_] = AddPassiveSkills,
                                    DunName = lib_dungeon_api:get_dungeon_name(DunId),
                                    DunLv = lib_dungeon_api:get_dungeon_condition_lv(DunId),
                                    lib_chat:send_TV(all, ?MOD_SKILL, 1, [Name, RoleId, DunLv, DunName, PSkillId]);
                                _ ->
                                    skip
                            end,
                            {ok, TipsBinData} = pt_130:write(13020, [AddPassiveSkills]),
                            lib_server_send:send_to_sid(PS#player_status.sid, TipsBinData),
                            LastPS = case lists:member(?SP_SKILL_KILLING, AddPassiveSkills) of
                                false -> update_skill_attribute_for_ps(NewPS);
                                true ->
                                    NewPS1 = lib_goods_buff:add_goods_temp_buff(NewPS, ?BUFF_TEAM_SHOW, [{?SPBUFF_REBOUND, 1}], 0),
                                    lib_goods_buff:send_buff_notice(NewPS1),
                                    update_skill_attribute_for_ps(NewPS1)
                            end,
                            case Event of
                                login -> {ok, LastPS};
                                {lv, _} -> {ok, LastPS};
                                _ -> %% 不需要重新计算人物属性的要在上面匹配过滤掉
                                    {ok, lib_player:count_player_attribute(LastPS)}
                            end;
                        false -> {ok, NewPS}
                    end;
                true -> {ok, NewPS}
            end;
        _ -> {ok, PS}
    end.

%% 升级技能
%% CheckUpgrade 是否检查升级条件 0否|1是；不检查情况用于升级自动学习技能
upgrade_skill(Status, SkillId) ->
    case check_skill_upgrade(Status, SkillId) of
        {false, ErrCode}->
            {ok, BinData} = pt_210:write(21001, [ErrCode, SkillId]),
            lib_server_send:send_to_sid(Status#player_status.sid, BinData),
            Status;
        {true, Coin, GoodsNumL, Data, Lv0, OldLv, Type} ->
            %% 扣金币
            {_, Status1} = ?IF(Coin > 0, lib_goods_api:cost_money(Status, Coin, coin, skill, uio:format("{1},{2}", [SkillId, Lv0])), {0, Status}),
            %% 扣物品
            ?IF(GoodsNumL =/= [], lib_goods_api:goods_delete_type_list(Status1, GoodsNumL, skill), skip),
            Status2 = update_status_skill(Status1, SkillId, Lv0, Data#skill.skill_link, Type),
            %% 被动技能属性加成
            Status3 = ?IF(Data#skill.type == ?SKILL_TYPE_PASSIVE, update_skill_attribute_for_ps(Status2), Status2),
            %% 人物属性计算
            NewStatus = lib_player:count_player_attribute(Status3),
            {ok, BinData} = pt_210:write(21001, [?SUCCESS, SkillId]),
            lib_server_send:send_to_sid(NewStatus#player_status.sid, BinData),
            mod_scene_agent:update(NewStatus, [{battle_attr, NewStatus#player_status.battle_attr}]),
            lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_ATTR),
            lib_log_api:log_skill_lv_up(NewStatus#player_status.id, SkillId, OldLv, Lv0, 2, [{?TYPE_GOODS, GoodsTypeId, Num} || {GoodsTypeId, Num} <- GoodsNumL], utime:unixtime()),
            NewStatus
    end.

%% 直接升级技能
%% CheckUpgrade 是否检查升级条件 0否|1是；不检查情况用于升级自动学习技能
%% @return {IsSuccess, #player_status{}}
immediate_upgrade_skill(Status, SkillId) ->
    case check_skill_upgrade(Status, SkillId) of
        {false, _ErrCode} -> {false, Status};
        {true, Coin, GoodsNumL, Data, Lv0, OldLv, Type} ->
            %% 扣金币
            {_, Status1} = ?IF(Coin > 0, lib_goods_api:cost_money(Status, Coin, coin, skill, uio:format("{1},{2}", [SkillId, Lv0])), {0, Status}),
            %% 扣物品
            ?IF(GoodsNumL =/= [], lib_goods_api:goods_delete_type_list(Status1, GoodsNumL, skill), skip),
            Status2 = update_status_skill(Status1, SkillId, Lv0, Data#skill.skill_link, Type),
            %% 被动技能属性加成
            Status3 = ?IF(Data#skill.type == ?SKILL_TYPE_PASSIVE, update_skill_attribute_for_ps(Status2), Status2),
            %% 人物属性计算
            NewStatus = lib_player:count_player_attribute(Status3),
            mod_scene_agent:update(NewStatus, [{battle_attr, NewStatus#player_status.battle_attr}]),
            lib_player:send_attribute_change_notify(NewStatus, ?NOTIFY_ATTR),
            lib_log_api:log_skill_lv_up(NewStatus#player_status.id, SkillId, OldLv, Lv0, 2, [{?TYPE_GOODS, GoodsTypeId, Num} || {GoodsTypeId, Num} <- GoodsNumL], utime:unixtime()),
            {ok, NewStatus}
    end.

%% 更换技能等级 (转职用到)
replace_skill_level(Status, SkillId, SkillLv) ->
    #player_status{figure = Figure, skill = Sk} = Status,
    #figure{career = Career, sex = Sex} = Figure,
    case lists:keyfind(SkillId, 1, lib_skill_api:get_career_all_skill_ids(Career, Sex)) of
        false ->
            Status;
        {_, MaxLv} ->
            {Data, Lv0, OldLv, Type} = 
                case lists:keyfind(SkillId, 1, Sk#status_skill.skill_list) of
                    false -> {data_skill:get(SkillId, SkillLv), SkillLv, 1, 0};
                    {_, Lv} -> {data_skill:get(SkillId, SkillLv), SkillLv, Lv, 1}
                end,
            if
                Lv0 > MaxLv -> Status;
                Data == [] -> Status;
                Data#skill.is_combo == 1 -> Status;
                true ->
                    Status2 = update_status_skill(Status, SkillId, Lv0, Data#skill.skill_link, Type),
                    %% 被动技能属性加成
                    NewStatus = ?IF(Data#skill.type == ?SKILL_TYPE_PASSIVE, update_skill_attribute_for_ps(Status2), Status2),
                    lib_log_api:log_skill_lv_up(NewStatus#player_status.id, SkillId, OldLv, Lv0, 3, [], utime:unixtime()),
                    NewStatus
            end
    end.

%% ================================= 技能属性操作  =================================


%%--------------------------------------------------
%% 获取玩家技能加成的永久增益属性
%% @param  SkillList 玩家技能列表[{SkillId, SkillLv}]
%% @return           {基础属性map, 特殊属性map}
%%--------------------------------------------------
get_passive_skill_attr(SkillList) ->
    F = fun({SkillId, SkillLv}, Result) ->
        case data_skill:get(SkillId, SkillLv) of
            [] -> Result;
            #skill{type=Type, lv_data = LvData} when 
                    Type == ?SKILL_TYPE_PASSIVE; Type == ?SKILL_TYPE_PERMANENT_GAIN;
                    Type == ?SKILL_TYPE_TALENT_ATT; Type == ?SKILL_TYPE_TALENT_DEF; 
                    Type == ?SKILL_TYPE_TALENT_COMMON; Type == ?SKILL_TYPE_TALENT_ABS ->
                BaseAttr = [{AttrId, AttrVal}|| {TmpMonId, AttrId, AttrVal} <- LvData#skill_lv.base_attr, TmpMonId == 0],
                % ?PRINT("get_passive_skill_attr ~p:~p~n", [{SkillId, SkillLv}, BaseAttr]),
                BaseAttr ++ Result;
            _ ->
                Result
        end
    end,
    %% AttrData = lists:foldl(F, [], SkillList),
    %% tranc_skill_attr(AttrData, #{}, #{}).
    lists:foldl(F, [], SkillList).

%%--------------------------------------------------
%% 获取玩家技能加成的永久增益第二属性
%% @param  SkillList 玩家技能列表[{SkillId, SkillLv}]
%% @return           {基础属性map, 特殊属性map}
%%--------------------------------------------------
get_passive_skill_sec_attr(SkillList) ->
    F = fun({SkillId, SkillLv}, Result) ->
        case data_skill:get(SkillId, SkillLv) of
            [] -> Result;
            #skill{type=Type, lv_data = LvData} when 
                    Type == ?SKILL_TYPE_PASSIVE;
                    Type == ?SKILL_TYPE_TALENT_ATT; Type == ?SKILL_TYPE_TALENT_DEF; 
                    Type == ?SKILL_TYPE_TALENT_COMMON; Type == ?SKILL_TYPE_TALENT_ABS ->
                BaseAttr = [{AttrId, SubType, AttrVal}|| {AttrId, SubType, AttrVal} <- LvData#skill_lv.sec_attr],
                BaseAttr ++ Result;
            _ ->
                Result
        end
    end,
    lib_sec_player_attr:to_attr_map(lists:foldl(F, [], SkillList)).
    
%%--------------------------------------------------
%% 计算功能自己相关技能加成的属性
%% @param ModId   功能模块id 0:表示全局的 | {ModId, SubModId} 功能和子模块id
%% @param  SkillList 功能解锁的技能列表[{SkillId, SkillLv}|SkillId]
%% @return           [{AttrId, AttrVal}]
%%--------------------------------------------------
count_skill_attr_with_mod_id(Key, SkillList) ->
    F = fun(Tmp, AccList) ->
        case Tmp of
            {SkillId, SkillLv} -> skip;
            SkillId -> SkillLv = 1
        end,
        case data_skill:get(SkillId, SkillLv) of
            [] -> AccList;
            #skill{type=Type, lv_data = LvData} when 
                    Type == ?SKILL_TYPE_PASSIVE; Type == ?SKILL_TYPE_PERMANENT_GAIN;
                    Type == ?SKILL_TYPE_TALENT_ATT; Type == ?SKILL_TYPE_TALENT_DEF; 
                    Type == ?SKILL_TYPE_TALENT_COMMON; Type == ?SKILL_TYPE_TALENT_ABS ->
                Attr = LvData#skill_lv.base_attr,
                BaseAttr = [{AttrId, AttrVal}|| {TmpKey, AttrId, AttrVal} <- Attr, TmpKey == Key],
                BaseAttr ++ AccList;
            _ -> AccList
        end
    end,
    lists:foldl(F, [], SkillList).

%%--------------------------------------------------
%% 获取技能对其他模块加成的属性列表
%% @param  ModId   功能模块id 0:表示全局的 | {ModId, SubModId} 功能和子模块id 
%% @param  SkillId 技能id
%% @param  SkillLv 技能等级
%% @return         description
%%--------------------------------------------------
get_skill_attr2mod(Key, SkillId, SkillLv) ->
    case data_skill:get(SkillId, SkillLv) of
        #skill{type = Type, lv_data = LvData} when 
                Type == ?SKILL_TYPE_PASSIVE; Type == ?SKILL_TYPE_PERMANENT_GAIN;
                Type == ?SKILL_TYPE_TALENT_ATT; Type == ?SKILL_TYPE_TALENT_DEF; 
                Type == ?SKILL_TYPE_TALENT_COMMON; Type == ?SKILL_TYPE_TALENT_ABS ->
            #skill_lv{base_attr = BaseAttr} = LvData,
            [{AttrId, AttrVal} || {TmpKey, AttrId, AttrVal} <- BaseAttr, TmpKey == Key];
        _ ->
            []
    end.

%% 重新计算技能属性
%% 返回 : #player_status
update_skill_attribute_for_ps(PS) ->
    Sk = PS#player_status.skill,
    %% {SkillAttr, SkillAttrOhter} = get_passive_skill_attr(Sk#status_skill.skill_list),
    %% PS#player_status{skill = Sk#status_skill{skill_attr = SkillAttr, skill_attr_other = SkillAttrOhter}}.
    SkillAttr = get_passive_skill_attr(Sk#status_skill.skill_list),
    PS#player_status{skill = Sk#status_skill{skill_attr = SkillAttr}}.

%% 属性列表转化map
%% tranc_skill_attr([{AttrId, AttrVal}|T], AttrMaps, OtherMaps) ->
%%     if
%%         AttrId == ?SPEED_ADD_RATIO orelse AttrId == ?HP_RESUME orelse AttrId == ?EXP_ADD orelse
%%         AttrId == ?BOSS_HURT_ADD orelse AttrId == ?PVEP_HURT_DEL orelse AttrId == ?PVE_SKILL_HURT orelse
%%         AttrId == ?PVP_CRIT_ADD_RATIO orelse AttrId == ?FIRE_ICE_MINUS_CD orelse AttrId == ?FIRE_ICE_ADD_SHIELD orelse
%%         AttrId == ?HOPE_MINUS_CD ->
%%             tranc_skill_attr(T, AttrMaps, OtherMaps#{AttrId => AttrVal+maps:get(AttrId, OtherMaps, 0)});
%%         true ->
%%             tranc_skill_attr(T, AttrMaps#{AttrId => AttrVal+maps:get(AttrId, AttrMaps, 0)}, OtherMaps)
%%     end;
%% tranc_skill_attr([_H|T], AttrMaps, OtherMaps) -> tranc_skill_attr(T, AttrMaps, OtherMaps);
%% tranc_skill_attr([], AttrMaps, OtherMaps) -> {AttrMaps, OtherMaps}.

%% 获取角色创建角色时候的普攻技能
get_ori_normal_skill(Career, Sex) ->
    AllIds = data_skill:get_ids(Career, Sex),
    NormalIds = lists:filter(fun({Id, _Lv}) -> is_normal_skill_without_combo(Id) end, AllIds),
    case NormalIds of
        [] -> 0;
        NormalIds ->
            {MinId, _} = lists:min(NormalIds),
            MinId
    end.

%% 普功技能（不算副技能）
is_normal_skill_without_combo(Id) ->
    case data_skill:get(Id, 1) of
        #skill{is_normal = 1, is_combo = 0} -> true;
        _ -> false
    end.

%% 普功技能
is_normal_skill(Id) ->
    case data_skill:get(Id, 1) of
        #skill{is_normal = 1} -> true;
        _ -> false
    end.

%% 分离出战斗计算的被动
divide_passive_skill(SkillList)->
    F = fun({SkillId, SkillLv}, PassiveSkill) ->
        case data_skill:get(SkillId, SkillLv) of
            #skill{is_passive = ?SKILL_IS_PASSIVE_YES} -> [{SkillId, SkillLv}|PassiveSkill];
            #skill{type=Type, lv_data = LvData} when
                    Type == ?SKILL_TYPE_PASSIVE; Type == ?SKILL_TYPE_TALENT_ATT;
                    Type == ?SKILL_TYPE_TALENT_DEF; Type == ?SKILL_TYPE_TALENT_COMMON; Type == ?SKILL_TYPE_TALENT_ABS ->
                case LvData#skill_lv.base_attr of
                    [] -> [{SkillId, SkillLv}|PassiveSkill];
                    _ -> PassiveSkill
                end;
            _ -> PassiveSkill
        end
    end,
    lists:foldl(F, [], SkillList).

%% 分离出被动共享技能
%% @param ShareType 执行分享类型的被动
divide_passive_share_skill(SkillList, ShareType) ->
    F = fun({SkillId, SkillLv}, PassiveSkill) ->
        case data_skill:get(SkillId, SkillLv) of
            #skill{is_passive = ?SKILL_IS_PASSIVE_YES, share_type=ShareType} -> [{SkillId, SkillLv}|PassiveSkill];
            #skill{type=Type, share_type=ShareType, lv_data = LvData} when
                    Type == ?SKILL_TYPE_PASSIVE; Type == ?SKILL_TYPE_TALENT_ATT;
                    Type == ?SKILL_TYPE_TALENT_DEF; Type == ?SKILL_TYPE_TALENT_COMMON; Type == ?SKILL_TYPE_TALENT_ABS ->
                case LvData#skill_lv.base_attr of
                    [] -> [{SkillId, SkillLv}|PassiveSkill];
                    _ -> PassiveSkill
                end;
            _ -> PassiveSkill
        end
    end,
    lists:foldl(F, [], SkillList).

%% 分离出被动共享技能
divide_team_passive_share_skill(SkillList) ->
    divide_passive_share_skill(SkillList, ?SKILL_SHARE_TYPE_TEAM).

%% 获得额外的技能属性（根据base_skill_attr）
get_extra_skill_attr(SkillL, Player, ModKey) ->
    F = fun({SkillId, SkillLv}, Attr) ->
        case data_skill_attr:get_skill_attr(SkillId, SkillLv) of
            [] -> Attr;
            #base_skill_attr{condition = Condition, base_attr = BaseAttr} ->
                case check_extra_skill_attr_cond(Condition, Player) of
                    {true, Times} when Times =/= 0 ->
%%                        AddAttr = [{TalentType, AttrId, AttrVal} || {TmpKey, AttrId, AttrVal} <- BaseAttr, TmpKey == ModKey],
                        AddAttr = [{AttrId, AttrVal * Times} || {TmpKey, AttrId, AttrVal} <- BaseAttr, TmpKey == ModKey],
                        AddAttr ++ Attr;
                    _ ->
                        Attr
                end
        end
    end,
    util:combine_list(lists:foldl(F, [], SkillL)).

check_extra_skill_attr_cond([], _Player) -> false;
% 坐骑模块类型形象
check_extra_skill_attr_cond([{figure_id_list, TypeId, FigureIdL}|_], Player) ->
    #player_status{status_mount = StatusMountL} = Player,
    case lists:keyfind(TypeId, #status_mount.type_id, StatusMountL) of
        false -> false;
        #status_mount{figure_list = FigureList} ->
            F = fun(FlyId) -> lists:keymember(FlyId, #mount_figure.id, FigureList) end,
            SatisfyList = lists:filter(F, FigureIdL),
            {true, length(SatisfyList) + 1}
    end;
% 坐骑模块类型阶数
check_extra_skill_attr_cond([{stage, TypeId, NeedStage}|_], Player) ->
    #player_status{status_mount = StatusMountL} = Player,
    case lists:keyfind(TypeId, #status_mount.type_id, StatusMountL) of
        #status_mount{stage = Stage} when Stage >= NeedStage -> {true, 1};
        _ -> false
    end;
check_extra_skill_attr_cond(_, _Player) ->
    false.

%% ================================= 天赋技能  =================================
%% 天赋技能类型统计
get_talent_skill_type_info(SkillTalentList)->
    Fun = fun({SkillId, SkillLv}, {Point, Power, TList}) ->
        case data_skill:get(SkillId, SkillLv) of
            #skill{type = TalentType, lv_data=#skill_lv{power = DefPower, condition = _Condition}} when
                TalentType == ?SKILL_TYPE_TALENT_ATT; TalentType == ?SKILL_TYPE_TALENT_DEF; TalentType == ?SKILL_TYPE_TALENT_COMMON; TalentType == ?SKILL_TYPE_TALENT_ABS ->
                NewTList = case lists:keyfind(TalentType, 1, TList) of
                    false ->
                        [{TalentType, SkillLv, [{SkillId, SkillLv}]}|TList];
                    {TalentType, OPoint, TypeList} ->
                        E = {TalentType, OPoint+SkillLv, [{SkillId, SkillLv}|TypeList]},
                        lists:keystore(TalentType, 1, TList, E)
                end,
                {Point+SkillLv, Power+DefPower, NewTList};
            _ ->
                {Point, Power, TList}
        end
    end,
    lists:foldl(Fun, {0, 0, []}, SkillTalentList).

%% 获取技能类型的投入的天赋点
get_talent_type_use_point(TalentType, SkillTalentList)->
    Fun = fun({SkillId, SkillLv}, UsePoint) ->
        case data_skill:get(SkillId, SkillLv) of
            #skill{type = TalentType} ->  UsePoint + SkillLv;
            _ -> UsePoint
        end
    end,
    lists:foldl(Fun, 0, SkillTalentList).

%% 天赋技能开启默认技能点
give_def_talent_skill_point(Ps) ->
    #player_status{id = RoleId, figure = #figure{turn = Turn}, skill = SkillStatus} = Ps,
    if
        Turn < ?DEF_TURN_4 ->  Ps;
        true ->
            NewSkillStatus = SkillStatus#status_skill{point = ?DEF_SKILL_POINT},
            db:execute(io_lib:format(?sql_update_talent_skill_point, [?DEF_SKILL_POINT, RoleId])),
            Ps#player_status{skill = NewSkillStatus}
    end.

%% 获取天赋技能的额外属性（特殊处理）
% 激活3转及以上圣器幻化时，提升圣器总属性的3%(只包括圣器或者幻化的 升星属性,不包括 属性丹、技能、幻化)
% 激活3转及以上翅膀幻化时，提升翅膀总属性的3%(只包括翅膀或者幻化的 升星属性,不包括 属性丹、技能、幻化)
% 坐骑进化到5阶以上时，提升坐骑属性10%（仅升级和属性丹，幻化不计入）
% 统一只算星级属性，不包括幻形星级和属性丹
get_talent_extra_attr(Player, ModKey) ->
    #player_status{skill = #status_skill{skill_talent_list = SkillTalentList}} = Player,
    get_extra_skill_attr(SkillTalentList, Player, ModKey).

%% ================================= private fun =================================
%% 获取所有技能主被动技能
get_all_skill(Id) ->
    SkillList = db:get_all(io_lib:format(?sql_get_all_skill, [Id])),
    F = fun([SkillId, SkillLv], L) ->
                case data_skill:get(SkillId, SkillLv) of
                    #skill{is_combo=0} -> [{SkillId, SkillLv}|L];
                    _ -> L
                end
        end,
    lists:foldl(F, [], SkillList).

%% 所有的天赋技能
get_all_talent_skill(RoleId)->
    SkillList = db:get_all(io_lib:format(?sql_get_all_talent_skill, [RoleId])),
    [{SkillId, SkillLv} || [SkillId, SkillLv] <- SkillList].

%% 更新技能列表
update_status_skill(Status, SkillId, SkillLv, SkillLink, Type) ->
    Sk = Status#player_status.skill,
    F = fun(TmpSkillId, SkillList) -> [{TmpSkillId, SkillLv}|lists:keydelete(TmpSkillId, 1, SkillList)] end,
    NewSkillList = lists:foldl(F, Sk#status_skill.skill_list, [SkillId|SkillLink]),
    SaveIdList = [SkillId|SkillLink],
    [db_update_skill(Status#player_status.id, Id, SkillLv, Type) || Id <- SaveIdList],
    Status#player_status{skill = Sk#status_skill{skill_list=NewSkillList}}.

%% 更新数据库
db_update_skill(Id, SkillId, Lv, Type) ->
    case Type of
        0 -> db:execute(io_lib:format(?sql_insert_skill, [Id, SkillId, Lv]));
        _ -> db:execute(io_lib:format(?sql_update_skill_lv, [Lv, Id, SkillId]))
    end.

%% ================================= 技能强化 =================================

%% 技能强化信息
send_skill_stren_info(Player) ->
    #player_status{skill = SkillStatus} = Player,
    #status_skill{stren_list = StrenL} = SkillStatus,
    {SumCost, Cost, _UpStrenL} = calc_onekey_stren_skill_info(Player),
    % ?PRINT("StrenL:~p SumCost:~p Cost:~p _UpStrenL:~p ~n", [StrenL, SumCost, Cost, _UpStrenL]),
    {ok, BinData} = pt_210:write(21003, [SumCost, Cost, StrenL]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 技能强化
stren_skill(#player_status{id = RoleId} = Player, SkillId) ->
    case check_stren_skill(Player, SkillId) of
        {false, ErrCode} -> PlayerAfAttr = Player;
        {true, Cost, NewStren} ->
            About = lists:concat(["SkillId:", SkillId, ",NewStren:", NewStren]),
            case lib_goods_api:cost_object_list_with_check(Player, Cost, skill_stren, About) of
                {false, ErrCode, PlayerAfAttr} -> ok;
                {true, PlayerAfCost} ->
                    ErrCode = ?SUCCESS,
                    db_role_skill_stren_replace(RoleId, SkillId, NewStren),
                    #player_status{id = RoleId, skill = SkillStatus} = PlayerAfCost,
                    #status_skill{stren_list = StrenList} = SkillStatus,
                    NewStrenList = lists:keystore(SkillId, 1, StrenList, {SkillId, NewStren}),
                    NewSkillStatus = SkillStatus#status_skill{stren_list = NewStrenList, stren_power = calc_stren_power(NewStrenList)},
                    PlayerAfStren = PlayerAfCost#player_status{skill = NewSkillStatus},
                    PlayerAfAttr = lib_player:count_player_attribute(PlayerAfStren),
                    StrenSum = lists:sum([Stren || {_SkillId, Stren} <- NewStrenList]),
                    lib_task_api:skill_stren(Player, StrenSum),
                    lib_player:send_attribute_change_notify(PlayerAfAttr, ?NOTIFY_ATTR)
            end
    end,
    {ok, BinData} = pt_210:write(21004, [ErrCode, SkillId]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, PlayerAfAttr}.

check_stren_skill(Player, SkillId) ->
    #player_status{skill = SkillStatus, figure = #figure{lv = Lv}} = Player,
    #status_skill{skill_list = SkillList, stren_list = StrenList} = SkillStatus,
    CheckHaving = lists:keymember(SkillId, 1, SkillList),
    case lists:keyfind(SkillId, 1, StrenList) of
        false -> Stren = 0;
        {SkillId, Stren} -> ok
    end,
    NewStren = Stren + 1,
    BaseStren = data_skill_stren:get_stren(SkillId, NewStren),
    if
        CheckHaving == false -> {false, ?ERRCODE(err210_not_this_skill_to_stren)};
        is_record(BaseStren, base_skill_stren) == false -> {false, ?ERRCODE(err210_max_skill_stren)};
        NewStren > Lv -> {false, ?ERRCODE(err210_skill_stren_can_not_gt_lv)};
        true ->
            #base_skill_stren{condition = Condition} = BaseStren,
            Cost = calc_skill_stren_cost(NewStren, BaseStren),
            CheckCond = check_stren_skill_cond(Condition, Player),
            % CheckCost = lib_goods_api:check_object_list(Player, Cost),
            if
                CheckCond =/= true -> CheckCond;
                % CheckCost =/= true -> CheckCost;
                true -> {true, Cost, NewStren}
            end
    end.

%% 计算技能强化消耗
calc_skill_stren_cost(Stren, BaseStren) ->
    #base_skill_stren{min_stren = MinStren, cost = Cost, per_cost = PerCost} = BaseStren,
    Diff = max(Stren - MinStren, 0),
    SumPerCost = [{Type, GoodsTypeId, Num*Diff}||{Type, GoodsTypeId, Num}<-PerCost],
    lib_goods_api:make_reward_unique(Cost ++ SumPerCost).

check_stren_skill_cond([], _Player) -> true;
check_stren_skill_cond([{lv, NeedLv}|T], Player) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    case Lv >= NeedLv of
        true -> check_stren_skill_cond(T, Player);
        false -> {false, ?ERRCODE(err210_not_enough_lv_to_stren_skill)}
    end;
check_stren_skill_cond([{turn, NeedTurn}|T], Player) ->
    #player_status{figure = #figure{turn = Turn}} = Player,
    case Turn >= NeedTurn of
        true -> check_stren_skill_cond(T, Player);
        false -> {false, ?ERRCODE(err210_not_enough_turn_to_stren_skill)}
    end.

%% 技能一键强化
onekey_stren_skill(#player_status{id = RoleId} = Player) ->
    {SumCost, Cost, UpStrenL} = calc_onekey_stren_skill_info(Player),
    if
        SumCost == [] -> PlayerAfAttr = Player, SendUpStrenL= [], ErrCode = ?ERRCODE(err210_max_skill_stren);
        Cost == [] -> PlayerAfAttr = Player, SendUpStrenL= [], ErrCode = ?COIN_NOT_ENOUGH;
        true ->
            About = lists:concat(["UpStrenL:", util:term_to_string(UpStrenL)]),
            case lib_goods_api:cost_object_list(Player, Cost, skill_stren, About) of
                {false, ErrCode, PlayerAfAttr} -> SendUpStrenL = [];
                {true, PlayerAfCost} ->
                    ErrCode = ?SUCCESS,
                    SendUpStrenL = UpStrenL,
                    db_role_skill_stren_batch(RoleId, UpStrenL),
                    #player_status{id = RoleId, skill = SkillStatus} = PlayerAfCost,
                    #status_skill{stren_list = StrenList} = SkillStatus,
                    F = fun({SkillId, Stren}, TmpStrenList) -> lists:keystore(SkillId, 1, TmpStrenList, {SkillId, Stren}) end,
                    NewStrenList = lists:foldl(F, StrenList, UpStrenL),
                    NewSkillStatus = SkillStatus#status_skill{stren_list = NewStrenList, stren_power = calc_stren_power(NewStrenList)},
                    PlayerAfStren = PlayerAfCost#player_status{skill = NewSkillStatus},
                    PlayerAfAttr = lib_player:count_player_attribute(PlayerAfStren),
                    StrenSum = lists:sum([Stren || {_SkillId, Stren} <- NewStrenList]),
                    lib_task_api:skill_stren(Player, StrenSum),
                    lib_player:send_attribute_change_notify(PlayerAfAttr, ?NOTIFY_ATTR)
            end
    end,
    {ok, BinData} = pt_210:write(21005, [ErrCode, SendUpStrenL]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, PlayerAfAttr}.

%% 计算一键强化信息
%% @return {SumCost(所有消耗), Cost(能消耗的), UpStrenL(获得需要修改的列表)}
calc_onekey_stren_skill_info(Player) ->
    #player_status{skill = SkillStatus, figure = #figure{career = Career, sex = Sex}} = Player,
    #status_skill{stren_list = StrenList} = SkillStatus,
    F = fun({SkillId, _Lv}, SeqKvList) ->
        case lists:keyfind(SkillId, 1, StrenList) of
            false -> [{SkillId, 0}|SeqKvList];
            {SkillId, Stren} -> [{SkillId, Stren}|SeqKvList]
        end
    end,
    KvList = lists:reverse(lists:foldl(F, [], data_skill:get_ids(Career, Sex))),
    SortKvList = lists:keysort(2, KvList),
    calc_onekey_stren_skill_info_help(SortKvList, Player, [], [], []).

calc_onekey_stren_skill_info_help([], _Player, SumCost, Cost, UpStrenL) -> {SumCost, Cost, UpStrenL};
calc_onekey_stren_skill_info_help([{SkillId, _Stren}|T], Player, SumCost, Cost, UpStrenL) ->
    case check_stren_skill(Player, SkillId) of
        {false, _ErrCode} -> calc_onekey_stren_skill_info_help(T, Player, SumCost, Cost, UpStrenL);
        {true, StrenCost, NewStren} ->
            NewCost = lib_goods_api:make_reward_unique(StrenCost++Cost),
            case lib_goods_api:check_object_list(Player, NewCost) of
                {false, _ErrCode} -> calc_onekey_stren_skill_info_help(T,  Player, StrenCost++SumCost, Cost, UpStrenL);
                true -> 
                    StrenKv = {SkillId, NewStren},
                    NewUpStrenL = lists:keystore(SkillId, 1, UpStrenL, StrenKv),
                    calc_onekey_stren_skill_info_help(T, Player, StrenCost++SumCost, NewCost, NewUpStrenL)
            end 
    end.

%% 计算强化战力
calc_stren_power(StrenList) ->
    F = fun({SkillId, Stren}, SumPower) ->
        case data_skill_stren:get_stren(SkillId, Stren) of
            [] -> SumPower;
            #base_skill_stren{min_stren = MinStren, power = Power, per_power = PerPower} -> SumPower+Power+PerPower*max(Stren-MinStren, 0)
        end
    end,
    lists:foldl(F, 0, StrenList).

get_skill_stren_for_battle(Player, SkillId) ->
    case get_skill_passive_from_special_module(Player) of 
        week_dungeon -> 0;
        sea_daily -> 0;
        _ ->
            get_skill_stren(Player, SkillId)
    end.

%% 获得技能强化
get_skill_stren(Player, SkillId) ->
    #player_status{skill = SkillStatus} = Player,
    #status_skill{stren_list = StrenList} = SkillStatus,
    case lists:keyfind(SkillId, 1, StrenList) of
        false -> 0;
        {SkillId, Stren} -> Stren
    end.

get_role_skill_stren_list(RoleId) ->
    [list_to_tuple(T)||T<-db_role_skill_stren_select(RoleId)].

db_role_skill_stren_select(RoleId) ->
    db:get_all(io_lib:format(?sql_role_skill_stren_select, [RoleId])).

db_role_skill_stren_replace(RoleId, SkillId, Stren) ->
    db:execute(io_lib:format(?sql_role_skill_stren_replace, [RoleId, SkillId, Stren])).

%% 保存技能强化(批量存储)
db_role_skill_stren_batch(RoleId, StrenL) ->
    SubSQL = splice_role_skill_stren_sql(StrenL, RoleId, []),
    case SubSQL == [] of
        true -> skip;
        false ->
            SQL = string:join(SubSQL, ", "),
            NSQL = io_lib:format(?sql_role_skill_stren_batch, [SQL]),
            db:execute(NSQL)
    end,
    ok.

splice_role_skill_stren_sql([], _RoleId, UpdateSQL) -> UpdateSQL;
splice_role_skill_stren_sql([{SkillId, Stren} | Rest], RoleId, UpdateSQL) ->
    SQL = io_lib:format(?sql_role_skill_stren_values, [RoleId, SkillId, Stren]),
    splice_role_skill_stren_sql(Rest, RoleId, [SQL | UpdateSQL]).

%% ================================= 技能条件检查 =================================
%% 学习天赋进程检查
check_talent_skill_learn(SkillId, SkillLv, UsePoint, AllPoint, SkillTalentList, Career, Turn)->
    if
        AllPoint - UsePoint =< 0 ->
            {fail, ?ERRCODE(err210_point_not_enough)};
        true ->
            CareerSkillList = data_skill:get_ids(?SKILL_CAREER_TALENT),
            case lists:keyfind(SkillId, 1, CareerSkillList) of
                false -> {fail, ?ERRCODE(err210_not_mycarrer_talent_skill)};
                {_SkillId, SkillMaxLv} ->
                    if
                        SkillLv > SkillMaxLv ->
                            {fail, ?ERRCODE(err210_skill_max_lv)};
                        true ->
                            case data_skill:get(SkillId, SkillLv) of
                                #skill{lv_data=#skill_lv{condition = Condition}} ->
                                    check_talent_skill_learn_cond(Condition, SkillTalentList, Career, Turn);
                                _ ->
                                    {fail, ?MISSING_CONFIG}
                            end
                    end
            end
    end.

check_talent_skill_learn_cond([], _SkillTalentList, _Career, _Turn) -> true;
check_talent_skill_learn_cond([H|Condition], SkillTalentList, Career, Turn) ->
    case H of
        {point, SkillType, NeedPoint} ->
            case get_talent_type_use_point(SkillType, SkillTalentList) >= NeedPoint of
                true -> check_talent_skill_learn_cond(Condition, SkillTalentList, Career, Turn);
                _ -> {fail, ?ERRCODE(err210_no_pre_skill_point)}
            end;
        {pre_skill, SkillId, SkillLv} ->
            case lists:keyfind(SkillId, 1, SkillTalentList) of
                false -> {fail, ?ERRCODE(err210_no_pre_skill)};
                {_, OSkillLv} when OSkillLv < SkillLv -> {fail, ?ERRCODE(err210_no_pre_skill_lv)};
                _ -> check_talent_skill_learn_cond(Condition, SkillTalentList, Career, Turn)
            end;
        {pre_skill2, SkillList} ->
            case check_pre_skill2(SkillList, SkillTalentList) of
                true -> check_talent_skill_learn_cond(Condition, SkillTalentList, Career, Turn);
                Result -> Result
            end;
        {turn, NeedTurn} ->
            case Turn >= NeedTurn of
                true ->
                    check_talent_skill_learn_cond(Condition, SkillTalentList, Career, Turn);
                _ ->
                    {fail, ?ERRCODE(err210_no_satisfy_turn)}
            end;
        {career, NeedCareer} ->
            case Career == NeedCareer of
                true ->
                    check_talent_skill_learn_cond(Condition, SkillTalentList, Career, Turn);
                _ ->
                    {fail, ?ERRCODE(err210_no_satisfy_career)}
            end;
        _R ->
            ?ERR("error talent skill learn condition:~p~n", [_R]),
            {fail, ?ERRCODE(err210_skill_erro)}
    end.

check_pre_skill2([], _SkillTalentList) -> true;
check_pre_skill2([{SkillId, SkillLv}|T], SkillTalentList) ->
    case lists:keyfind(SkillId, 1, SkillTalentList) of
        false -> {fail, ?ERRCODE(err210_no_pre_skill)};
        {_, OSkillLv} when OSkillLv < SkillLv -> {fail, ?ERRCODE(err210_no_pre_skill_lv)};
        _ -> check_pre_skill2(T, SkillTalentList)
    end.

%% 技能升级检查
check_skill_upgrade(Status, SkillId) ->
    #player_status{figure = Figure, skill = Sk} = Status,
    #figure{career = Career, sex = Sex} = Figure,
    case lists:keyfind(SkillId, 1, lib_skill_api:get_career_all_skill_ids(Career, Sex)) of
        false ->
            {false, ?MISSING_CONFIG};
        {_, MaxLv} ->
            {Data, Lv0, OldLv, Type} = 
                case lists:keyfind(SkillId, 1, Sk#status_skill.skill_list) of
                    false -> {data_skill:get(SkillId, 1), 1, 1, 0};
                    {_, Lv} -> {data_skill:get(SkillId, Lv+1), Lv+1, Lv, 1}
                end,
            if
                Lv0 > MaxLv -> {false, ?ERRCODE(err210_skill_max_lv)};
                Data == [] -> {false, ?ERRCODE(err210_skill_error)};
                Data#skill.is_combo == 1 -> {false, ?ERRCODE(err210_skill_error)};
                true ->
                    case check_upgrade(Status, Data#skill.lv_data#skill_lv.condition, [0, [], 0]) of
                        {true, [Coin, GoodsNumL, _Point]} -> {true, Coin, GoodsNumL, Data, Lv0, OldLv, Type};
                        Res -> Res
                    end
            end
    end.

%% 技能升级条件检查
check_upgrade(_, [], List) -> {true, List};
check_upgrade(Status, [H | T], [Coin, GoodsNumL, Point]=List) ->
    case H of
        {lv, V} -> %% 等级需求
            case Status#player_status.figure#figure.lv < V of
                true  -> {false, ?ERRCODE(err210_lv_not_enough)};
                false -> check_upgrade(Status, T, List)
            end;
        {coin, V} -> %% 铜币需求
            case Status#player_status.coin < V of
                true  -> {false, ?ERRCODE(err210_coin_not_enough)};
                false -> check_upgrade(Status, T, [Coin+V, GoodsNumL, Point])
            end;
        {goods, GoodsTypeId, Num} -> 
            case lib_goods_api:check_goods_num(Status, [{GoodsTypeId, Num}]) of
                1 -> check_upgrade(Status, T, [Coin, [{GoodsTypeId, Num}|GoodsNumL], Point]);
                _ -> {false, ?ERRCODE(err210_goods_not_enough)}
            end;
        {point, V} -> %% 技能点
            #player_status{skill=Skill} = Status,
            case Skill#status_skill.point < Skill#status_skill.use_point + V of
                true  -> {false, ?ERRCODE(err210_point_not_enough)};
                false -> check_upgrade(Status, T, [Coin, GoodsNumL, Point+V])
            end;
        {turn, V} -> %% 转生
            #player_status{figure=#figure{turn=Turn}} = Status,
            case Turn >= V of
                false -> {false, ?FAIL};
                true -> check_upgrade(Status, T, List)
            end;
        {yhbg, V} -> %% 永恒碑谷
            #player_status{eternal_valley = RoleEternalValley} = Status,
            case lib_eternal_valley:check_chapter_is_finish(RoleEternalValley, V) of
                true ->
                    check_upgrade(Status, T, List);
                false ->
                    {false, ?FAIL}
            end;
        {finish_dun, V} ->
            case lib_dungeon_api:check_ever_finish(Status, V) of
                true ->
                    check_upgrade(Status, T, List);
                false ->
                    {false, ?FAIL}
            end;
        {pre_skill, Id, Lv} ->
            Sk = Status#player_status.skill,
            case lists:keyfind(Id, 1, Sk#status_skill.skill_list) of
                false ->  {false, ?ERRCODE(err210_no_pre_skill)};
                {_, Lv0} when Lv0 < Lv -> {false, ?ERRCODE(err210_no_pre_skill_lv)};
                _ -> check_upgrade(Status, T, List)
            end;
        {task_id, TaskId} ->
            #player_status{tid = Tid} = Status,
            case catch mod_task:is_finish_task_id(Tid, TaskId) of
                true -> check_upgrade(Status, T, List);
                _ -> {false, ?ERRCODE(err210_no_finish_task_id)}
            end;
        _ ->
            check_upgrade(Status, T, [Coin, GoodsNumL, Point])
    end;
check_upgrade(_Status, _Condition, _List) ->  
    {false, ?FAIL}.

%% 重置天赋技能：返回Ps
reset_talent_skill(Ps)->
    #player_status{id = RoleId, skill = SkillStatus, figure = Figure} = Ps,
    if
        Figure#figure.turn < 4 ->
            Ps;
        true ->
            db:execute(io_lib:format(?sql_reset_talent_skill, [RoleId])),
            NewSkillStatus = SkillStatus#status_skill{use_point = 0, skill_power = 0,
                                                      skill_talent_list = [], skill_talent_passive = [],
                                                      skill_talent_attr = #{}, skill_talent_attr_other = #{}},
            Ps#player_status{skill = NewSkillStatus}
    end.

%% 场景快捷栏
make_scene_quickbar(Player) ->
    #player_status{quickbar = Quickbar} = Player,
    F = fun({_, _, SkillId, _}, List) ->
        BfSkillId = lib_arcana:get_before_reskill_id(Player, SkillId),
        case lists:keyfind(BfSkillId, 1, Player#player_status.skill#status_skill.skill_list) of
            {BfSkillId, Lv} when Lv > 0 -> [{SkillId, Lv}|List];
            _ -> 
                case lists:keyfind(SkillId, 1, lib_arcana:get_active_skill(Player)) of
                    {SkillId, Lv} when Lv > 0 -> [{SkillId, Lv}|List];
                    _ -> List
                end
        end
    end,
    lists:reverse(lists:foldl(F, [], lists:keysort(1, Quickbar))).

make_skill_use_call_back(UserData, 28000005 = SkillId, SkillLv) when is_record(UserData, player_status) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId, x = X, y = Y, guild = Guild} = UserData,
    #status_guild{id = GuildId} = Guild,
    IsInKfGWarScene = lib_kf_guild_war_api:is_kf_guild_war_scene(SceneId),
    if
        IsInKfGWarScene ->
            ArgsMap = #{pos => {X, Y}},
            #call_back_skill_use{
                skill_id = SkillId,
                skill_lv = SkillLv,
                mfa = {lib_kf_guild_war_api, use_skill, [CopyId, GuildId, RoleId, SkillId, ArgsMap]}
            };
        true -> []
    end;
make_skill_use_call_back(UserData, 28000005 = _SkillId, _SkillLv) when is_record(UserData, ets_scene_user) -> [];
make_skill_use_call_back(_UserData, _SkillId, _SkillLv) -> [].

%% 某些技能使用成功之后要处理的后续逻辑
handle_af_use_skill_success(#call_back_skill_use{skill_id = 28000005} = CallBack) ->
    #call_back_skill_use{
        mfa = {M, F, A}
    } = CallBack,
    apply(M, F, A);
handle_af_use_skill_success(_) -> skip.

%% 增加能量值
add_energy(Player, AddEnergy) ->
    #player_status{battle_attr = BA} = Player,
    #battle_attr{energy = Energy} = BA,
    % TODO: 功能里面要判断最大值
    NewEnergy = Energy+AddEnergy,
%%    ?PRINT("Energy:~p Old:~p ~n", [NewEnergy, Energy]),
%%    ?MYLOG("cym", "Energy:~p Old:~p ~n", [NewEnergy, Energy]),
    NewPlayer = Player#player_status{battle_attr = BA#battle_attr{energy = NewEnergy}},
    lib_battle:send_energy_info(NewPlayer),
    mod_scene_agent:update(NewPlayer, [{energy, NewEnergy}]),
    {ok, NewPlayer}.

%% 减少能量值
del_energy(Player, DelEnergy) ->
    #player_status{battle_attr = BA} = Player,
    #battle_attr{energy = Energy} = BA,
    NewEnergy = max(Energy-DelEnergy,0),
%%    ?PRINT("Energy:~p Old:~p ~n", [NewEnergy, Energy]),
    NewPlayer = Player#player_status{battle_attr = BA#battle_attr{energy = NewEnergy}},
    lib_battle:send_energy_info(NewPlayer),
    mod_scene_agent:update(NewPlayer, [{energy, NewEnergy}]),
    {ok, NewPlayer}.

%% 设置能量值
set_energy(Player, Energy) ->
    #player_status{battle_attr = BA} = Player,
    NewPlayer = Player#player_status{battle_attr = BA#battle_attr{energy = Energy}},
%%    ?PRINT("Energy:~p Old:~p ~n", [Energy, BA#battle_attr.energy]),
    lib_battle:send_energy_info(NewPlayer),
    mod_scene_agent:update(NewPlayer, [{energy, Energy}]),
    {ok, NewPlayer}.
    
%% 是否从某些特殊功能获取被动技能
get_skill_passive_from_special_module(PS) ->
    #player_status{dungeon = StatusDungeon} = PS,
    DunType = ?IF(is_record(StatusDungeon, status_dungeon), StatusDungeon#status_dungeon.dun_type, 0),
    IsCarryBrick = lib_seacraft_daily:is_carry(PS),
    if
        DunType == ?DUNGEON_TYPE_WEEK_DUNGEON -> week_dungeon;
        IsCarryBrick == true -> sea_daily;  %% 国战日常搬砖状态
        true ->
            normal
    end.

%% 是否开启所有玩家技能
is_open_all_career_skill(#player_status{last_task_id = LastTaskId}) ->
    is_open_all_career_skill(?TASK_KV_OPEN_SKILL_TASK_ID_LIST, LastTaskId).

is_open_all_career_skill([], _LastTaskId) -> false;
is_open_all_career_skill([{StatTaskId, EndTaskId}|_T], LastTaskId) when LastTaskId >= StatTaskId andalso LastTaskId =< EndTaskId -> true;
is_open_all_career_skill([_H|T], LastTaskId) -> is_open_all_career_skill(T, LastTaskId).

%% 是否技能开放本技能
%% return {IsOpen, Lv}
get_open_skill_lv(#player_status{figure = #figure{career = Career}} = Player, SkillId) ->
    case is_open_all_career_skill(Player) of
        true -> 
            SkillkvL = data_skill:get_ids(Career),
            case lists:keymember(SkillId, 1, SkillkvL) of
                true -> {true, ?DEFAULT_SKILL_LV};
                false -> {false, 0}
            end;
        false ->
            {false, 0}
    end.

%% 转职
transfer_talent_skill(Player) ->
    #player_status{
        id = RoleId, figure = Figure, skill = SkillStatus
    } = Player,
    #figure{career = NewCareer, lv = RoleLv} = Figure,
    #status_skill{skill_talent_list = TalentList} = SkillStatus,
    %% 删除玩家的旧技能
    F = fun({FunSkillId, FunLv}, {AccTalentList, DeleteList, NewList}) ->
            case data_transfer:get_transfer_talent_skill(FunSkillId, NewCareer) of
                NewFunSkillId when NewFunSkillId =/= 0 -> %% 如果不为0 则需要替换为对应职业的技能
                    {[{NewFunSkillId, FunLv} | AccTalentList], [FunSkillId | DeleteList], [{NewFunSkillId, FunLv} |NewList]};
                _ ->
                    {[{FunSkillId, FunLv} | AccTalentList], DeleteList, NewList}
            end
        end,
    {NewSkillTalentList, SkillDeleteList, InsertSkillList}  = lists:foldl(F, {[], [], []}, TalentList),
%%    ?MYLOG("transfer", "old ~p~n", [TalentList]),
%%    ?MYLOG("transfer", "~p~n", [{NewSkillTalentList, SkillDeleteList, InsertSkillList}]),
    if
        SkillDeleteList =/= [] ->
            db:execute(io_lib:format(<<"delete from talent_skill where role_id = ~p and skill_id in (~s)">>, [RoleId, util:link_list(SkillDeleteList)]));
        true ->
            skip
    end,
    [db:execute(io_lib:format(?sql_replace_talent_skill, [RoleId, InsertSkillId, InsertLv])) || {InsertSkillId, InsertLv}<- InsertSkillList],
    %% 重新学习技能
    %% 清理被动技能， buff到场景
    %% 添加新的被动到 场景中
    TalentAttr = lib_skill:get_passive_skill_attr(NewSkillTalentList),
    NewSkillTalentPassive = lib_skill:divide_passive_skill(NewSkillTalentList),
    {_NewUsePoint, Power, _TypeSkillList} = lib_skill:get_talent_skill_type_info(NewSkillTalentList),
    NewSkillStatus = SkillStatus#status_skill{
        skill_talent_list = NewSkillTalentList, skill_talent_passive = NewSkillTalentPassive,
        skill_talent_attr = TalentAttr, skill_power = Power,
        skill_talent_sec_attr = lib_skill:get_passive_skill_sec_attr(NewSkillTalentList)},
    %% 计算天赋技能对其它功能的属性影响
    NewPs = Player#player_status{skill = NewSkillStatus},
    NewPS1 = lib_player:count_player_attribute(NewPs),
    #player_status{battle_attr = BA} = NewPS1,
    %%   删除天赋对坐骑的属性会产生变化吗 , 目前是通用的，所以替换的天赋技能不会包含对坐骑的影响
%%    MountPs = lib_mount_api:talent_skill_update(NewPS, SkillId, SkillLv),
%%    NewStatus = lib_player:count_player_attribute(MountPs),
    lib_player:send_attribute_change_notify(NewPS1, ?NOTIFY_ATTR),
    NewAllPoint = max(0, RoleLv - ?DEF_TURN_4_LV+?DEF_SKILL_POINT),
    mod_scene_agent:update(NewPS1, [{battle_attr, BA}, {delete_passive_skill, TalentList}, {passive_skill, NewSkillTalentList}]),
    {UsePoint, _Power, PackSkillList} = lib_skill:get_talent_skill_type_info(NewSkillTalentList),
    {ok, Bin} = pt_210:write(21010, [max(0, NewAllPoint-UsePoint), PackSkillList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    NewPS1.
%%    {ok, battle_attr, NewStatus};


transfer_dungeon_skill(Player) ->
    #player_status{id = _RoleId, dungeon_skill = StatusDunSkill, figure = Figure} = Player,
    #status_dungeon_skill{skill_list = SkillList, passive_skill_list = OldPassiveSkill} = StatusDunSkill,
    #figure{career = NewCareer} = Figure,
    %% 删除玩家的旧技能
    F = fun({FunSkillId, FunLv}, {AccTalentList, DeleteList, NewList}) ->
        case data_transfer:get_transfer_talent_skill(FunSkillId, NewCareer) of  %% 被动技能也一起放在天赋技能里了
            NewFunSkillId when NewFunSkillId =/= 0 -> %% 如果不为0 则需要替换为对应职业的技能
                {[{NewFunSkillId, FunLv} | AccTalentList], [FunSkillId | DeleteList], [{NewFunSkillId, FunLv} |NewList]};
            _ ->
                {[{FunSkillId, FunLv} | AccTalentList], DeleteList, NewList}
        end
        end,
    {NewSkillTalentList, SkillDeleteList, _InsertSkillList}  = lists:foldl(F, {[], [], []}, SkillList),
    [lib_skill_buff:clean_buff(Player, CleanSkillId) ||CleanSkillId <- SkillDeleteList],
%%    ?MYLOG("transfer", "old ~p~n", [SkillList]),
%%    ?MYLOG("transfer", "~p~n", [{NewSkillTalentList, SkillDeleteList, InsertSkillList}]),
%%    db:execute(io_lib:format(<<"delete from talent_skill where role_id = ~p and skill_id in (~s)">>, [RoleId, util:link_list(SkillDeleteList)])),
%%    [db:execute(io_lib:format(?sql_replace_talent_skill, [RoleId, InsertSkillId, InsertLv])) || {InsertSkillId, InsertLv}<- InsertSkillList],
    SkillAttr = lib_skill:get_passive_skill_attr(NewSkillTalentList),
    SkillPower = lib_skill_api:get_skill_power(NewSkillTalentList),
    PassiveSkillL = lib_skill:divide_passive_skill(NewSkillTalentList),
    PassiveShareSkillL = lib_skill:divide_team_passive_share_skill(NewSkillTalentList),
    NewStatusDunSkill = StatusDunSkill#status_dungeon_skill{
        skill_list = NewSkillTalentList, skill_attr = SkillAttr, skill_power = SkillPower,
        passive_skill_list = PassiveSkillL, passive_share_skill_list = PassiveShareSkillL
    },
    PlayerAfSave = Player#player_status{dungeon_skill = NewStatusDunSkill},
    NewPlayer = lib_player:count_player_attribute(PlayerAfSave),
    #player_status{battle_attr = BattleAttr} = NewPlayer,
    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
    mod_scene_agent:update(NewPlayer, [{battle_attr, BattleAttr}, {delete_passive_skill, OldPassiveSkill}, {passive_skill, PassiveSkillL}]),
    % 队伍处理
%%    ChangePassiveShareSkillL = lib_skill:divide_team_passive_share_skill(NewSkillTalentList),
%%    lib_team_api:update_team_mb(NewPlayer, [{del_share_skill_list, []}, {add_share_skill_list, ChangePassiveShareSkillL}]),
    lib_skill:send_passive_share_skill_list(NewPlayer),
    % ?MYLOG("dunskill", "RoleId:~p StatusDunSkill:~p NewStatusDunSkill:~p ~n", [Player#player_status.id, StatusDunSkill, NewStatusDunSkill]),
    lib_dungeon_learn_skill:send_info(NewPlayer),
    NewPlayer.
    