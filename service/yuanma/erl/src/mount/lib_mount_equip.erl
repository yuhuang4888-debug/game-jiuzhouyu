%%-----------------------------------------------------------------------------
%% @Module  :       lib_mount_equip.erl
%% @Author  :       fwx
%% @Created :       2018-5-26
%% @Description:    坐骑装备
%%-----------------------------------------------------------------------------

-module(lib_mount_equip).
-include("mount.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_goods.hrl").
-include("def_module.hrl").
-include("rec_offline.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("sql_goods.hrl").
-include("pet.hrl").

-compile(export_all).


%% 物品生成时，计算物品的极品属性
gen_equip_dynamic_attr(GoodsTypeInfo, #goods_other{skill_id = OSkill} = GoodsOther) ->
    #ets_goods_type{goods_id = GoodsId} = GoodsTypeInfo,
    case data_mount_equip:get_equip(GoodsId) of
        #base_mount_equip{skill_id = SkillId, gen_weight = GenRatio} ->
            ExtraAttr = [],
            BaseRating = cal_equip_rating(GoodsTypeInfo, ExtraAttr),
            NewSkillId = case OSkill =:= 0 of
                             true ->
                                 ?IF(urand:rand(1, 10000) =< GenRatio, SkillId, 0);
                             _ ->
                                 OSkill
                         end,
            GoodsOther#goods_other{rating = BaseRating, extra_attr = ExtraAttr, skill_id = NewSkillId};
        _ ->
            GoodsOther
    end.

%% 合成获得技能概率
compose_skill(GoodsTypeId, UpdateGoodsList) ->
    case data_mount_equip:get_equip(GoodsTypeId) of
        #base_mount_equip{skill_id = SkillId, com_weight = WeightL, gen_weight = GenRatio} ->
            ComSkillNum = length([TmpSkill || #goods{other = #goods_other{skill_id = TmpSkill}} <- UpdateGoodsList, TmpSkill =/= 0]),
            case lists:keyfind(ComSkillNum, 1, WeightL) of
                {_, TmpRatio} ->
                    %% 换算概率（万分比）
                    ComRatio = round(max(TmpRatio - GenRatio, 0) / (10000 - GenRatio)),
                    ?IF(urand:rand(1, 10000) =< ComRatio, SkillId, 0);
                _ ->
                    0
            end;
        _ ->
            0
    end.

%% 计算装备的评分
cal_equip_rating(GoodsTypeInfo, EquipExtraAttr) when is_record(GoodsTypeInfo, ets_goods_type) ->
    #ets_goods_type{base_attrlist = BaseAttr} = GoodsTypeInfo,
    Rating = lists:foldl(fun
                             (OneExtraAttr, RatingTmp) ->
                                 case OneExtraAttr of
                                     {OneAttrId, OneAttrVal} ->
                                         %% 策划说这里固定写死阶来算百分比属性
                                         OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                                         RatingTmp + OneAttrRating * OneAttrVal;
                                     {_Color, OneAttrId, OneAttrVal} ->
                                         %% 策划说这里固定写死阶来算百分比属性
                                         OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                                         RatingTmp + OneAttrRating * OneAttrVal;
                                     _ -> RatingTmp
                                 end
                         end, 0, BaseAttr ++ EquipExtraAttr),
    round(Rating);
cal_equip_rating(_, _) -> 0.


%% 初始化坐骑装备信息
get_stren_list(RoleId) ->
    SQL = io_lib:format("SELECT `pos`, `lv`, `exp`, `stage` FROM `mount_equip` WHERE `role_id` = ~p", [RoleId]),
    [{Pos, #equip_mount{lv = Lv, exp = Exp, stage = Stage}} || [Pos, Lv, Exp, Stage] <- db:get_all(SQL)].

%% 初始化坐骑装备信息
login_init(PS) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    InfoList = get_stren_list(PS#player_status.id),
    NewGoodsStatus = GoodsStatus#goods_status{mount_equip_list = InfoList},
    lib_goods_do:set_goods_status(NewGoodsStatus),
    ME = reset_total_attrs(PS, NewGoodsStatus, 1),
    PS#player_status{mount_equip = ME}.

%% 离线加载
off_login_init(PS) ->
    #player_status{off = Off} = PS,
    #status_off{goods_status = GoodsStatus} = Off,
    InfoList = get_stren_list(PS#player_status.id),
    NewGoodsStatus = GoodsStatus#goods_status{mount_equip_list = InfoList},
    ME = reset_total_attrs(PS, NewGoodsStatus, 1),
    NewOff = Off#status_off{goods_status = NewGoodsStatus},
    PS#player_status{mount_equip = ME, off = NewOff}.


%% 检测是否可以穿戴
check_equip(PS, GTypeId, _GS) ->
    #player_status{status_mount = #status_mount{stage = MountStage}} = PS,
    %#goods_status{mount_equip_list = InfoL} = GS,
    case data_mount_equip:get_equip(GTypeId) of
        #base_mount_equip{pos = _Pos, stage_limit = StageLim} -> %% 坐骑阶数限制
            case MountStage >= StageLim of
                true ->
                    true;
                _ ->
                    {false, ?ERRCODE(err160_equip_stage_limit)}
            end;
        _ ->
            {false, ?ERRCODE(err_config)}
    end.


%% 装备基础属性 强化属性
update_mount_equip_change(PS) ->
    #player_status{mount_equip = ME} = PS,
    GoodsStatus = lib_goods_do:get_goods_status(),
    NewME = reset_total_attrs(PS, GoodsStatus, ME),
    PS1 = PS#player_status{mount_equip = NewME},
    PS2 = lib_player:count_player_attribute(PS1),
    lib_player:send_attribute_change_notify(PS2, ?NOTIFY_ATTR),
    %%    send_attr_change(PS2),
    PS2.

%% 刷新属性值
reset_total_attrs(PS, GoodsStatus, _N) ->
    PosAttrL = [{Pos, pos_attr(GoodsStatus, Pos)} || Pos <- data_mount_equip:get_pos_list()],
    F = fun
            ({_, Attr}, Acc) -> Attr ++ Acc
        end,
    TotalAttr = util:combine_list(lists:foldl(F, [], PosAttrL)),
    Skills = own_skills(GoodsStatus),
    %?PRINT("~p~n", [Skills]),
    case lib_skill_api:divide_passive_skill(Skills) of
        [] -> PassiveSkills = [];
        PassiveSkills ->
            mod_scene_agent:update(PS, [{passive_skill, PassiveSkills}])
    end,
    SkillCombat = get_skills_combat(Skills),
    #mount_equip{total_attr = TotalAttr, pos_attr = PosAttrL, skills = Skills, passive_skills = PassiveSkills, skill_combat = SkillCombat}.

own_skills(#goods_status{dict = Dict, player_id = RoleId}) ->
    GoodList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MOUNT_EQUIP, Dict),
    [Skill || #goods{other = #goods_other{skill_id = Skill}} <- GoodList, Skill =/= 0].

pos_attr(GS, Pos) ->
    #goods_status{dict = Dict, player_id = RoleId, mount_equip_list = MEList} = GS,
    GoodList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MOUNT_EQUIP, Dict),
    case lists:keyfind(Pos, #goods.subtype, GoodList) of
        #goods{goods_id = GTypeId, other = #goods_other{skill_id = SKillId}} ->
            case data_goods_type:get(GTypeId) of
                #ets_goods_type{base_attrlist = BaseList} ->
                    GoodAttr = BaseList;
                _ ->
                    GoodAttr = []
            end,
            case lists:keyfind(Pos, 1, MEList) of
                {_, #equip_mount{lv = Lv, stage = Stage}} ->
                    case data_mount_equip:get_stren_attr(Pos, Stage, Lv) of
                        #base_mount_equip_attr{attr = LvAttr} -> skip;
                        _ -> LvAttr = []
                    end;
                _ ->
                    LvAttr = [], Stage = 0
            end,
            SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_MOUNT_EQUIP, [SKillId]),
            case data_mount_equip:get_stage(Stage) of
                #base_mount_equip_stage{percent = Per} -> skip;
                _ -> Per = 0
            end,
            [{AId, round(AVal * (1 + (Per / 100)))} || {AId, AVal} <- GoodAttr ++ LvAttr ++ SkillAttr];
        _ ->
            []
    end.

%%取当阶锻造等级上限
get_lv_max_by_stage(Pos, Stage) ->
    case data_mount_equip:get_lvs_by_stage(Pos, Stage) of
        [] -> ?ERR("config err!~n", []), 0;
        L -> lists:max(L)
    end.


%% 保存强化
save_stren(RoleId, Pos, Lv, Exp, Stage) ->
    SQL = io_lib:format("REPLACE INTO `mount_equip` (`role_id`, `pos`, `lv`, `exp`, `stage`) VALUES (~p, ~p, ~p, ~p, ~p)", [RoleId, Pos, Lv, Exp, Stage]),
    db:execute(SQL).

calc_lv(Pos, Stage, Lv, Exp, ExpPlus, MaxExp) ->
    case Exp + ExpPlus >= MaxExp of
        true ->
            NextLv = Lv + 1,
            NextExp = Exp + ExpPlus - MaxExp,
            case data_mount_equip:get_stren_attr(Pos, Stage, NextLv) of
                #base_mount_equip_attr{exp = NextMaxExp} ->
                    %% 能再升下一级的情况
                    case NextExp >= NextMaxExp of
                        true -> calc_lv(Pos, Stage, NextLv, 0, NextExp, NextMaxExp);
                        _ -> {NextLv, NextExp}
                    end;
                _ -> {Lv, Exp + ExpPlus}
            end;
        false -> {Lv, Exp + ExpPlus}
    end.

%% 计算铭刻概率
get_engrave_prob(Color, GoodList) ->
    F = fun
            ({GTypeId, Num}, Acc) ->
                case data_mount_equip:get_engrave(Color, GTypeId, Num) of
                    #base_mount_equip_engrave{prob = Prob} ->
                        Acc + Prob;
                    _ ->
                        Acc
                end
        end,
    min(lists:foldl(F, 0, GoodList), 10000).

%% 修改物品信息缓存
change_goods_info(#goods{goods_id = GTypeId, other = Other} = GoodsInfo) ->
    case data_mount_equip:get_equip(GTypeId) of
        #base_mount_equip{skill_id = SkillId} ->
            GoodsInfo#goods{other = Other#goods_other{skill_id = SkillId}};
        _ ->
            GoodsInfo
    end.

%% 修改物品信息db
change_goods_other_db(#goods{id = Id, other = #goods_other{skill_id = SkillId}}) ->
    SQL = io_lib:format(?SQL_GOODS_UPDATE_SKILL, [SkillId, Id]),
    db:execute(SQL).

get_skills_combat(Skills) ->
    F = fun(SkillId, Acc) ->
        Acc + lib_skill_api:get_skill_power(SkillId, 1)
        end,
    lists:foldl(F, 0, Skills).




%%------------------------- 精灵装备 -------------------------------


%% 总经验， 部位，阶段， 外形id ->  部位等级， 剩余经验
get_figure_equip_pos_lv(AllPoint, Pos, PEStage, TypeId) ->
    #pet_equip_stage_con{limit_pos_lv = LimitPosLv} =
        data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, PEStage),
    PosLvList = data_pet_equip:get_pet_equip_pos_lv_list(TypeId, Pos),
    PosLv1 = get_pet_equip_pos_lv_1(PosLvList, AllPoint, Pos, 0, 0, TypeId),
    PosLv =
        case PosLv1 > LimitPosLv of
            true -> LimitPosLv;
            false -> PosLv1
        end,
    NowPoint =
        case PosLv == 0 of
            true -> 0;
            false -> get_now_point(0, PosLv - 1, Pos, 0, TypeId)
        end,
    PosPoint = max(0, (AllPoint - NowPoint)),
    %%    ?PRINT("AllPoint, Pos, PEStage, TypeId, PosLv,PosPoint,  NowPoint:~w~n", [[AllPoint, Pos, PEStage, TypeId, PosLv, PosPoint, NowPoint]]),
    {PosLv, PosPoint}.


%% 获得装备部位等级
get_pet_equip_pos_lv(AllPoint, Pos, PEStage, TypeId) ->
     LimitPosLv=
        case data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, PEStage) of
            #pet_equip_stage_con{limit_pos_lv = LimPosLv} ->
                LimPosLv;
            _ -> 0
        end,
    PosLvList = data_pet_equip:get_pet_equip_pos_lv_list(TypeId, Pos),
    PosLv1 = get_pet_equip_pos_lv_1(PosLvList, AllPoint, Pos, 0, 0, TypeId),
    case PosLv1 > LimitPosLv of
        true ->
            IfMax = 1,
            PosLv = LimitPosLv;
        false ->
            IfMax = 0,
            PosLv = PosLv1
    end,
    NowPoint = get_now_point(0, PosLv, Pos, 0, TypeId),
    PosPoint = max(0, (AllPoint - NowPoint)),
    {PosLv, PosPoint, IfMax}.

%% 到下一级的时，所需经验
get_now_point(PosLv, PosLv, Pos, NowPoint, TypeId) ->
    #pet_equip_pos_lv_con{exp = Exp} =
        data_pet_equip:get_pet_equip_pos_lv_con(TypeId, Pos, PosLv),
    NowPoint + Exp;
get_now_point(PosLv1, PosLv, Pos, NowPoint, TypeId) ->
    #pet_equip_pos_lv_con{exp = Exp} =
        data_pet_equip:get_pet_equip_pos_lv_con(TypeId, Pos, PosLv1),
    get_now_point(PosLv1 + 1, PosLv, Pos, NowPoint + Exp, TypeId).

get_pet_equip_pos_lv_1([T | G], AllPoint, Pos, _PosLv, NowPoint, TypeId) ->
    #pet_equip_pos_lv_con{exp = Exp} =
        data_pet_equip:get_pet_equip_pos_lv_con(TypeId, Pos, T),
    NewNowPoint = NowPoint + Exp,
    %%    ?PRINT("get_pet_equip_pos_lv_1 TypeId, Pos, T, NewNowPoint  NowPoint Exp AllPoint:~w~n", [[TypeId, Pos, T, NewNowPoint, NowPoint, Exp, AllPoint]]),
    case AllPoint >= NewNowPoint of
        false ->
            T;
        true ->
            get_pet_equip_pos_lv_1(G, AllPoint, Pos, T, NewNowPoint, TypeId)
    end;
get_pet_equip_pos_lv_1([], _AllPoint, _Pos, PosLv, _NowPoint, _TypeId) ->
    PosLv.


%% 获取装备
get_pet_equip(StatuType, Ps, GS, TypeId) ->
    %%    ?PRINT("get_pet_equip T:~n", []),
    #player_status{id = RoleId, status_mount = StatuMount} = Ps,
    #status_mount{figure_equip = PetEquip} = StatuType,
    #goods_status{dict = Dict, mount_equip_pos_list = MountEquipPosList, mate_equip_pos_list = MateEquipPosList} = GS,
    {EquipPosList, GoodLocal} =
        case TypeId of
            ?MOUNT_ID -> {MountEquipPosList, ?GOODS_LOC_MOUNT_EQUIP};
            ?MATE_ID -> {MateEquipPosList, ?GOODS_LOC_MATE_EQUIP}
        end,
    PetEquipWearList = lib_goods_util:get_goods_list(RoleId, GoodLocal, Dict),
    PetEquipAttr = get_pet_equip_attr(PetEquipWearList, EquipPosList, [], 0, 0, 0, TypeId),
    NewPetEquip = PetEquip#figure_equip{equip_attr = PetEquipAttr},
    NewStatuType = StatuType#status_mount{figure_equip = NewPetEquip},
    NewStatuMount = lists:keyreplace(TypeId, #status_mount.type_id, StatuMount, NewStatuType),
    Ps#player_status{status_mount = NewStatuMount}.

get_pet_equip_attr([T | G], PetEquipPosList, AttrList, ALLPosLv, AllStage, AllStar, TypeId) ->
    %%    ?PRINT("get_pet_equip_attr T:~p~n", [T]),
    case T of
        #goods{cell = PosTmp, other = #goods_other{optional_data = []}} ->
            Pos = PosTmp, PEStage = 0, PEStar = 0;
        _ ->
            case TypeId of
                ?MOUNT_ID ->
                    #goods{cell = Pos, other = #goods_other{optional_data = [?GOODS_OTHER_KEY_MOUNT_EQUIP, PEStage, PEStar]}} = T;
                ?MATE_ID ->
                    #goods{cell = Pos, other = #goods_other{optional_data = [?GOODS_OTHER_KEY_MATE_EQUIP, PEStage, PEStar]}} = T
            end
    end,
    AllPoint =
        case lists:keyfind(Pos, #figure_equip_pos.pos, PetEquipPosList) of
            false -> 0;
            #figure_equip_pos{equip_point = AllPt} -> AllPt
        end,
    {PosLv, _Point, _IfMax} = get_pet_equip_pos_lv(AllPoint, Pos, PEStage, TypeId),
    AttrListPosLv =
        case data_pet_equip:get_pet_equip_pos_lv_con(TypeId, Pos, PosLv) of
            #pet_equip_pos_lv_con{attr_list = AtListPosLv} ->
                AtListPosLv;
            _ -> []
        end,

    AttrListStage =
        case data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, PEStage) of
            #pet_equip_stage_con{attr_list = AttrListStg} ->
                AttrListStg;
            _ -> []
        end,

    AttrListStar =
        case data_pet_equip:get_pet_equip_star_con(TypeId, Pos, PEStar) of
            #pet_equip_star_con{attr_list = AttrListSr} ->
                AttrListSr;
            _ -> []
        end,
    get_pet_equip_attr(G, PetEquipPosList, [AttrListPosLv, AttrListStage, AttrListStar | AttrList], ALLPosLv + PosLv, AllStage + PEStage, AllStar + PEStar, TypeId);
get_pet_equip_attr([], _PetEquipPosList, AttrList, ALLPosLv, AllStage, AllStar, TypeId) ->
    %% 计算全身额外属性加成
    case TypeId of % 外形id分类
        ?MOUNT_ID ->
            TotalPosLvAttr = lib_equip:get_12_equip_award(ALLPosLv, ?WHOLE_AWARD_MOUNT_EQUIP_POS_LV),
            TotalStageAttr = lib_equip:get_12_equip_award(AllStage, ?WHOLE_AWARD_MOUNT_EQUIP_STAGE),
            TotalStarAttr = lib_equip:get_12_equip_award(AllStar, ?WHOLE_AWARD_MOUNT_EQUIP_STAR),
%%            ?PRINT("MOUNT_ID ALLPosLv:~p, AllStage :~p, AllStar:~p TotalPosLvAttr: ~p, TotalStageAttr:~p, TotalStarAttr :~p~n",[ALLPosLv, AllStage, AllStar, TotalPosLvAttr, TotalStageAttr, TotalStarAttr]),
            lib_player_attr:add_attr(list, [TotalPosLvAttr, TotalStageAttr, TotalStarAttr | AttrList]);
        ?MATE_ID ->
            TotalPosLvAttr = lib_equip:get_12_equip_award(ALLPosLv, ?WHOLE_AWARD_MATE_EQUIP_POS_LV),
            TotalStageAttr = lib_equip:get_12_equip_award(AllStage, ?WHOLE_AWARD_MATE_EQUIP_STAGE),
            TotalStarAttr = lib_equip:get_12_equip_award(AllStar, ?WHOLE_AWARD_MATE_EQUIP_STAR),
%%            ?PRINT("MATE_ID TotalPosLvAttr: ~p, TotalStageAttr:~p, TotalStarAttr :~p~n",[TotalPosLvAttr, TotalStageAttr, TotalStarAttr]),
            lib_player_attr:add_attr(list, [TotalPosLvAttr, TotalStageAttr, TotalStarAttr | AttrList])
    end.




get_pos_lv_upgrade_cost_list([T | G], NowLimitPoint, PetEquipBagList, PEGoodsTypeIdList, AllPoint, CostList, AddPoint, TypeId, Pos, PEStage) ->
    case lists:keyfind(T, #goods.id, PetEquipBagList) of
        false ->
            get_pos_lv_upgrade_cost_list(G, NowLimitPoint, PetEquipBagList, PEGoodsTypeIdList, AllPoint, CostList, AddPoint, TypeId, Pos, PEStage);
        GoodsInfo1 ->
            #goods{
                goods_id = GoodsTypeId1,
                subtype = SubType1,
                other = GoodsOther1,
                num = GoodsNum1
            } = GoodsInfo1,
            case lists:member(GoodsTypeId1, PEGoodsTypeIdList) of
                false ->
                    get_pos_lv_upgrade_cost_list(G, NowLimitPoint, PetEquipBagList, PEGoodsTypeIdList, AllPoint, CostList, AddPoint, TypeId, Pos, PEStage);
                true ->
                    #goods_other{optional_data = [_GoodsOther, PEStage1, PEStar1]} = GoodsOther1,
                    #pet_equip_stage_con{exp = AddExpStage} = data_pet_equip:get_pet_equip_stage_con(TypeId, SubType1, PEStage1),
                    #pet_equip_star_con{exp = AddExpStar} = data_pet_equip:get_pet_equip_star_con(TypeId, SubType1, PEStar1),
                    NewAddPoint = AddExpStage + AddExpStar + AddPoint,
                    NewAllPoint = AllPoint + NewAddPoint,
                    {_OldPosLv, _PosPoint, IfMax} = lib_mount_equip:get_pet_equip_pos_lv(AddPoint + AllPoint, Pos, PEStage, TypeId),
                    ?PRINT("NewAddPoint AllPoint NowLimitPoint IfMax :~w~n", [[NewAddPoint, AllPoint, NowLimitPoint, IfMax]]),

                    case NewAllPoint >= NowLimitPoint andalso IfMax == 0 of
                        true ->
                            {[{GoodsInfo1, GoodsNum1} | CostList], NewAddPoint};
                        false ->
                            get_pos_lv_upgrade_cost_list(G, NowLimitPoint, PetEquipBagList, PEGoodsTypeIdList, AllPoint, [{GoodsInfo1, GoodsNum1} | CostList], NewAddPoint, TypeId, Pos, PEStage)
                    end
            end
    end;
get_pos_lv_upgrade_cost_list([], _NowLimitPoint, _PetEquipBagList, _PEGoodsTypeIdList, _AllPoint, CostList, AddPoint, _TypeId, _Pos, _PEStage) ->
    {CostList, AddPoint}.




get_cost_num_stage_star(PETypeMax, PETypeMax, _Pos, _GoodsNum, _Type, CostNum, _TypeId) ->
    CostNum;
get_cost_num_stage_star(PEType, PETypeMax, Pos, GoodsNum, Type, CostNum, TypeId) ->
    case Type of
        1 ->
            #pet_equip_stage_con{
                cost_list = [{_GoodsType, _StageGoodsTypeId, CostNum1} | _]
            } = data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, PEType);
        _ ->
            #pet_equip_star_con{
                cost_list = [{_GoodsType, _StageGoodsTypeId, CostNum1} | _]
            } = data_pet_equip:get_pet_equip_star_con(TypeId, Pos, PEType)
    end,
    case GoodsNum >= CostNum + CostNum1 of
        false ->
            CostNum;
        true ->
            get_cost_num_stage_star(PEType + 1, PETypeMax, Pos, GoodsNum, Type, CostNum + CostNum1, TypeId)
    end.


%% 计算装备的分数
cal_figure_equip_rating(Pos, OptionalData, TypeId) ->
    case OptionalData of
        [_, PEStage, PEStar] ->
            AttrListStage =
                case data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, PEStage) of
                    #pet_equip_stage_con{attr_list = AttrListStageTmp} ->
                        AttrListStageTmp;
                    _ -> []
                end,

            AttrListStar =
                case data_pet_equip:get_pet_equip_star_con(TypeId, Pos, PEStar) of
                    #pet_equip_star_con{attr_list = AttrListStarTmp} ->
                        AttrListStarTmp;
                    _ -> []
                end,
            AttrList = AttrListStage ++ AttrListStar,
            Rating = cal_pet_equip_rating(AttrList, PEStage, 0),
            round(Rating);
        _ ->
            0
    end.

cal_pet_equip_rating([T | G], PEStage, RatingTmp) ->
    NewRatingTmp = case T of
                       {OneAttrId, OneAttrVal} ->
                           OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, PEStage),
                           RatingTmp + OneAttrRating * OneAttrVal;
                       {_Color, OneAttrId, OneAttrVal} ->
                           OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, PEStage),
                           RatingTmp + OneAttrRating * OneAttrVal;
                       _ ->
                           RatingTmp
                   end,
    cal_pet_equip_rating(G, PEStage, NewRatingTmp);
cal_pet_equip_rating([], _PEStage, NewRatingTmp) ->
    NewRatingTmp.



%% 物品装备登录
figure_euip_pos_list_login(RoleId, TypeId) ->
    ReSql = io_lib:format(?sql_figure_equip_pos_select, [RoleId, TypeId]),
    case db:get_all(ReSql) of
        [] ->
            PetEquipPosList = [];
        SqlList ->
            PetEquipPosList =
                [begin
                     [_RoleId, Pos, PetEquipPosPoint] = SqlInfo,
                     #figure_equip_pos{
                         pos = Pos,
                         equip_point = PetEquipPosPoint
                     }
                 end || SqlInfo <- SqlList]
    end,
    PetEquipPosList.





%% 更改物品额外数据
change_goods_other(#goods{id = Id} = GoodsInfo) ->
    lib_goods_util:change_goods_other(Id, format_other_data(GoodsInfo)).

format_other_data(#goods{type = ?GOODS_TYPE_MOUNT_EQUIP, other = Other}) ->
    #goods_other{optional_data = T} = Other,
    T;
format_other_data(#goods{type = ?GOODS_TYPE_MATE_EQUIP, other = Other}) ->
    #goods_other{optional_data = T} = Other,
    T;
format_other_data(_) -> [].



init_other_data(#goods{type = ?GOODS_TYPE_MOUNT_EQUIP, other = Other}) ->
    #goods_other{optional_data = _T} = Other,
    [?GOODS_OTHER_KEY_MOUNT_EQUIP, 1, 1];
init_other_data(#goods{type = ?GOODS_TYPE_MATE_EQUIP, other = Other}) ->
    #goods_other{optional_data = _T} = Other,
    [?GOODS_OTHER_KEY_MATE_EQUIP, 1, 1];
init_other_data(_) -> [].



%%  计算综合装备评分 lib_equip
calc_over_all_rating(GoodsStatus, GoodsInfo, TypeId) ->
    #goods_status{
        mount_equip_pos_list = MountEquipPosList,
        mate_equip_pos_list = MateEquipPosList
    } = GoodsStatus,
    #goods{
        cell = Pos,
        goods_id = GoodsTypeId,
        other = #goods_other{
            optional_data = OptionalData
        }
    } = GoodsInfo,
    case OptionalData of
        [_, PEStage, PEStar] -> skip;
        _ -> 
            case data_pet_equip:get_pet_equip_goods(GoodsTypeId) of
                #pet_equip_goods_con{stage = PEStage, star = PEStar} -> skip;
                _ ->  PEStage = 0, PEStar = 0
            end
    end,
    EquipPosList =
        case TypeId of
            ?MOUNT_ID -> MountEquipPosList;
            ?MATE_ID -> MateEquipPosList
        end,
    AllPoint =
        case lists:keyfind(Pos, #figure_equip_pos.pos, EquipPosList) of
            false -> 0;
            #figure_equip_pos{equip_point = APoint} -> APoint
        end,
    {PosLv, _Point, _IfMax} = get_pet_equip_pos_lv(AllPoint, Pos, PEStage, TypeId),
    #pet_equip_pos_lv_con{
        attr_list = AttrListPosLv
    } = data_pet_equip:get_pet_equip_pos_lv_con(TypeId, Pos, PosLv),
    #pet_equip_stage_con{
        attr_list = AttrListStage
    } = data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, PEStage),
    #pet_equip_star_con{
        attr_list = AttrListStar
    } = data_pet_equip:get_pet_equip_star_con(TypeId, Pos, PEStar),
    AttrList = AttrListPosLv ++ AttrListStage ++ AttrListStar,
    Rating = cal_pet_equip_rating(AttrList, PEStage, 0),
    round(Rating).


%% 计算基础评分
calc_over_base_rating(_GoodsStatus, GoodsInfo, TypeId) ->
    #goods{cell = Pos} = GoodsInfo,
    #pet_equip_pos_lv_con{
        attr_list = AttrListPosLv
    } = data_pet_equip:get_pet_equip_pos_lv_con(TypeId, Pos, ?INIT_EQUIP_POS_LV),
    #pet_equip_stage_con{
        attr_list = AttrListStage
    } = data_pet_equip:get_pet_equip_stage_con(TypeId, Pos, ?INIT_EQUIP_STAGE),
    #pet_equip_star_con{
        attr_list = AttrListStar
    } = data_pet_equip:get_pet_equip_star_con(TypeId, Pos, ?INIT_EQUIP_STAR),
    AttrList = AttrListPosLv ++ AttrListStage ++ AttrListStar,
    Rating = cal_pet_equip_rating(AttrList, ?INIT_EQUIP_STAGE, 0),
    round(Rating).





%% 装备登录
pet_equip_login(RoleId, GoodsStatus, TypeId) ->
    #goods_status{
        dict = Dict,
        mount_equip_pos_list = MountEquipPosList,
        mate_equip_pos_list = MateEquipPosList
    } = GoodsStatus,
    PetEquip =
        case TypeId of
            ?MOUNT_ID ->
                PetEquipWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MOUNT_EQUIP, Dict),
                PetEquipAttr = get_pet_equip_attr(PetEquipWearList, MountEquipPosList, [], 0, 0, 0, TypeId),
                #figure_equip{
                    role_id = RoleId,
                    equip_attr = PetEquipAttr
                };
            ?MATE_ID ->
                PetEquipWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MATE_EQUIP, Dict),
                PetEquipAttr = get_pet_equip_attr(PetEquipWearList, MateEquipPosList, [], 0, 0, 0, TypeId),
                #figure_equip{
                    role_id = RoleId,
                    equip_attr = PetEquipAttr
                };
            _ ->
                #figure_equip{
                    role_id = RoleId,
                    equip_attr = []
                }
        end,
    PetEquip.




pet_equip_new_goods(GoodsInfo, TypeId) ->
    #goods{
        goods_id = GoodsTypeId,
        subtype = SubType,
        other = GoodsOther
    } = GoodsInfo,
    GoodsOtherKey =
        case TypeId of
            ?MOUNT_ID ->
                ?GOODS_OTHER_KEY_MOUNT_EQUIP;
            ?MATE_ID ->
                ?GOODS_OTHER_KEY_MATE_EQUIP
        end,
    case data_pet_equip:get_pet_equip_goods(GoodsTypeId) of
        [] ->
            GoodsOther;
        #pet_equip_goods_con{stage = PEStage, star = PEStar} ->
            GoodsOther#goods_other{
                rating = cal_figure_equip_rating(SubType, [GoodsOtherKey, PEStage, PEStar], TypeId),
                optional_data = [GoodsOtherKey, PEStage, PEStar]
            }
    end.



get_pet_equip_stage_star(GoodsInfo) ->
    #goods{
        goods_id = GoodsTypeId,
        type = Type,
        other = #goods_other{
            optional_data = OptionalData
        }
    } = GoodsInfo,
    case lists:member(Type, [?GOODS_TYPE_MOUNT_EQUIP, ?GOODS_TYPE_MATE_EQUIP]) of
        true ->
            case data_pet_equip:get_pet_equip_goods(GoodsTypeId) of
                [] ->
                    PEStage = 0,
                    PEStar = 0;
                _ ->
                    [_, PEStage, PEStar] = OptionalData
            end;
        false ->
            PEStage = 0,
            PEStar = 0
    end,
    {PEStage, PEStar}.


get_figure_power(RoleId, TypeId) ->
    % 获取物品
    GS = lib_goods_do:get_goods_status(),
    #goods_status{dict = Dict} = GS,
    % 取装备位置上的物品
    {EquipWearList, EquipPosList} =
        case TypeId of
            ?MOUNT_ID ->
                MountGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MOUNT_EQUIP, Dict),
                {MountGoodsList, GS#goods_status.mount_equip_pos_list};
            ?MATE_ID ->
                MateGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MATE_EQUIP, Dict),
                {MateGoodsList, GS#goods_status.mate_equip_pos_list}
        end,
    EquipAttrList = get_pet_equip_attr(EquipWearList, EquipPosList, [], 0, 0, 0, TypeId),
    EquipAttr = lib_player_attr:to_attr_record(EquipAttrList),
    CombatPower = lib_player:calc_all_power(EquipAttr), % 计算战力
    CombatPower.



get_figure_equip_attr(PlayerId, MountEquipPos, MateEquipPos, Dict) ->
    % 取装备位置上的物品
    MountGoodsList = lib_goods_util:get_goods_list(PlayerId, ?GOODS_LOC_MOUNT_EQUIP, Dict),
    MateGoodsList = lib_goods_util:get_goods_list(PlayerId, ?GOODS_LOC_MATE_EQUIP, Dict),
    EquipAttrList1 = get_pet_equip_attr(MountGoodsList, MountEquipPos, [], 0, 0, 0, ?MOUNT_ID),
    EquipAttrList2 = get_pet_equip_attr(MateGoodsList, MateEquipPos, [], 0, 0, 0, ?MATE_ID),
    EquipAttrList1 ++ EquipAttrList2.


%% pp_goods api
get_figure_equip_power(RoleId, TypeId, GS) ->
    % 获取物品
    #goods_status{dict = Dict} = GS,
    % 取装备位置上的物品
    {EquipWearList, EquipPosList} =
        case TypeId of
            ?MOUNT_ID ->
                MountGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MOUNT_EQUIP, Dict),
                {MountGoodsList, GS#goods_status.mount_equip_pos_list};
            ?MATE_ID ->
                MateGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_MATE_EQUIP, Dict),
                {MateGoodsList, GS#goods_status.mate_equip_pos_list}
        end,
    EquipAttrList = get_pet_equip_attr(EquipWearList, EquipPosList, [], 0, 0, 0, TypeId),
    EquipAttr = lib_player_attr:to_attr_record(EquipAttrList),
    CombatPower = lib_player:calc_all_power(EquipAttr), % 计算战力
    CombatPower.

