%%%-----------------------------------------------------------------------------
%%%	@Module  : lib_partner_util
%%% @Author  : liuxl
%%% @Email   : liuxingli@suyougame.com
%%% @Created : 2016-12-13
%%% @Description : 伙伴
%%%-----------------------------------------------------------------------------

-module(lib_partner_util).
% -include("server.hrl").
% -include("skill.hrl").
% -include("partner.hrl").
% -include("common.hrl").
% -include ("def_fun.hrl").
% -include ("attr.hrl").
% -include ("def_cache.hrl").
% -include ("scene.hrl").

% -compile(export_all).

% %% 初始化 #partner{}
% make_base_record(PartnerCfg, PlayerId, Id) ->
%     Personality = PartnerCfg#base_partner.personality,
%     AttackSk = PartnerCfg#base_partner.attack_skill,
%     AssistSk = PartnerCfg#base_partner.assist_skill,
%     TalentSk = PartnerCfg#base_partner.talent_skill,
%     SkList = [{AttackSk, 1, ?COM_ATTACK}, {AssistSk, 1, ?ASSIST}, {TalentSk, 1, ?TALENT}],
%     SkillCd = [{AttackSk, 0}, {AssistSk, 0}, {TalentSk, 0}],
%     #partner{
%        id = Id,
%        player_id = PlayerId,
%        partner_id = PartnerCfg#base_partner.partner_id,	% 伙伴id
%        quality = PartnerCfg#base_partner.quality,				% 品质
%        career = PartnerCfg#base_partner.career,				% 伙伴五行属性
%        personality = Personality,			% 伙伴个性
%        state = ?STATE_SLEEP,					% 状态 是否出战
%        break = [],
%        lv = 1,						% 等级
%        grow_up = PartnerCfg#base_partner.grow_up,				% 成长
%        skill = #partner_skill{skill_list = SkList, skill_cd = SkillCd},
%        equip = #partner_equip{}
%       }.

% %% 初始化 #partner{}
% make_record({Id, PlayerId, PartnerId, Lv, Exp, BreakSt, Break, State, Pos, AttrQuality, TotalAttr, Prodigy, AptiTake, SkLearn, SkList, WeaponSt}, PartnerCfg) ->
%     SkillCd = lists:foldl(fun({SkId, _, _},List) -> [{SkId, 0}|List] end, [], SkList),
%     AttrMap = get_passive_skill_attr(SkList),
%     SkPower = get_skill_power(SkList, 0),
%     Personality = PartnerCfg#base_partner.personality,
%     #partner{
%        id = Id,
%        player_id = PlayerId,
%        partner_id = PartnerId,
%        quality = PartnerCfg#base_partner.quality,
%        career = PartnerCfg#base_partner.career,				% 伙伴五行属性
%        personality = Personality,
%        state = State,					% 状态 是否上阵
%        pos = Pos,
%        break_st = BreakSt,
%        break = Break,
%        lv = Lv,
%        exp = Exp,
%        grow_up = PartnerCfg#base_partner.grow_up,
%        apti_take = AptiTake,
%        skill_learn = SkLearn,
%        attr_quality = AttrQuality,
%        total_attr = TotalAttr,
%        skill = #partner_skill{skill_attr = AttrMap, skill_list = SkList, skill_cd = SkillCd, sk_power = SkPower},
%        equip = #partner_equip{weapon_st = WeaponSt},
%        prodigy = Prodigy
%       }.

% conver_to_rec_embattle(_PartnerMap, [], List) -> List;
% conver_to_rec_embattle(PartnerMap, [H|Embattle], List) ->
%     case H of
%         {Pos, Type, Id, PartnerId, Lv} when Type == ?BATTLE_SIGN_PLAYER ->
%             conver_to_rec_embattle(PartnerMap, Embattle, [#rec_embattle{key={Type,Id}, pos=Pos, type=Type, id=Id, partner_id=PartnerId, lv=Lv}|List]);
%         {Pos, Type, Id, _, _} when Type == ?BATTLE_SIGN_PARTNER ->
%             case maps:get(Id, PartnerMap, 0) of
%                 #partner{partner_id = PartnerId, lv = Lv, combat_power = CombatPower} ->
%                     conver_to_rec_embattle(PartnerMap, Embattle, [#rec_embattle{key={Type,Id}, pos=Pos, type=Type, id=Id, partner_id=PartnerId, lv=Lv, combat_power = CombatPower}|List]);
%                 _ -> conver_to_rec_embattle(PartnerMap, Embattle, List)
%             end;
%         _ -> conver_to_rec_embattle(PartnerMap, Embattle, List)
%     end.

% conver_to_embattle_list([], List) -> List;
% conver_to_embattle_list([H|RecEmbattle], List) ->
%     #rec_embattle{pos=Pos, type=Type, id=Id, partner_id=PartnerId, lv=Lv} = H,
%     conver_to_embattle_list(RecEmbattle, [{Pos, Type, Id, PartnerId, Lv}|List]).


% %% 获取 保底/非保底 招募的伙伴列表
% get_partner_by_guaran(Guarantee, RecruitType) ->
%     CacheKey = ?CACHE_KEY(?CACHE_PARTNER_RECRUIT, {Guarantee, RecruitType}),
%     Result = mod_cache:get(CacheKey),
%     case Result of
%         undefined ->
%             RecruitL = get_recruit_list(Guarantee, RecruitType),
%             mod_cache:put(CacheKey, RecruitL),
%             RecruitL;
%         Data ->
%             Data
%     end.

% %% 更新招募缓存
% update_partner_cache() ->
%     AllGuarantee = [?NOT_GUARANTEE, ?GUARANTEE],
%     AllRecuit    = data_partner:get_all_recuit(),

%     F1 = fun(RecruitType, Guarantee) ->
%                  CacheKey = ?CACHE_KEY(?CACHE_PARTNER_RECRUIT, {Guarantee, RecruitType}),
%                  RecruitL = get_recruit_list(Guarantee, RecruitType),
%                  mod_cache:put(CacheKey, RecruitL),
%                  Guarantee
%          end,
%     F2 = fun(Guarantee) -> lists:foldl(F1, Guarantee, AllRecuit) end,
%     lists:foreach(F2, AllGuarantee).

% get_recruit_list(Guarantee, RecruitType) ->
%     PnList = data_partner:get_all_partner(),
%     Fun = fun({PartnerId, Quality, RecruitList}, RepList) ->
%                   case RecruitList of
%                       [{Type1, Guaran1, Num1}|Recruit2] ->
%                           [{Type2, Guaran2, Num2}] = ?IF(Recruit2 == [], [{?RECRUIT_TYPE_INVALID, 0, 0}], Recruit2),
%                           if
%                               Type1 == RecruitType, Guarantee == Guaran1 ->
%                                   [{PartnerId, Quality, Num1}|RepList];
%                               Type2 == RecruitType, Guarantee == Guaran2 ->
%                                   [{PartnerId, Quality, Num2}|RepList];
%                               true ->
%                                   RepList
%                           end;
%                       _ -> RepList
%                   end
%           end,
%     lists:foldl(Fun, [], PnList).

% %% 通过上阵位置 获取伙伴
% get_partner_by_pos(PartnerSt, Pos) ->
%     PartnerMap = PartnerSt#partner_status.partners,
%     F = fun(_K, V, Acc) ->
%                 case V#partner.state == ?STATE_BATTLE andalso V#partner.pos == Pos of
%                     true -> V;
%                     false -> Acc
%                 end
%         end,
%     maps:fold(F, none, PartnerMap).

% %% 获取伙伴partnerid = PartnerId 的伙伴列表
% get_partner_by_id(PartnerSt, PartnerId) ->
%     PartnerMap = PartnerSt#partner_status.partners,
%     F = fun(_Id, Partner) -> Partner#partner.partner_id =:= PartnerId end,
%     FilterMap = maps:filter(F, PartnerMap),
%     maps:values(FilterMap).

% add_partnet(Partner) ->
%     lib_partner_do:add_partner(Partner).

% %% 计算伙伴的四围总属性
% calc_partner_total_attr(AttrList, Partner, QualityList) ->
%     #partner{quality = Quality, grow_up = GrowUp, lv = Lv, break = BreakedL} = Partner,
%     UpgradeAttr = get_upgrade_attr(GrowUp, Lv-1),
%     BreakAttr = get_break_attr(Quality, BreakedL, QualityList, GrowUp),
%     TemList = keyadd(UpgradeAttr, BreakAttr),
%     keyadd(TemList, AttrList).

% %% 获取升级带来的属性
% get_upgrade_attr(_GrowUp, _DValue) -> [].
% %% get_upgrade_attr(_, DValue) when DValue =< 0 ->
% %%  [];
% %% get_upgrade_attr(GrowUp, DValue) ->
% %%  Physique = lists:nth(1, GrowUp) * DValue,
% %%  Agile = lists:nth(2, GrowUp) * DValue,
% %%  Forza = lists:nth(3, GrowUp) * DValue,
% %%  Dexterous = lists:nth(4, GrowUp) * DValue,
% %%  [{?PHYSIQUE,Physique,Physique},{?AGILE,Agile,Agile},{?FORZA,Forza,Forza},{?DEXTEROUS,Dexterous,Dexterous}].

% %% 获取突破带来的属性
% get_break_attr(Quality, BreakedL, QualityList, GrowUp) ->
%     F = fun(Lv, {Sum, List}) ->
%                 case data_partner:get_break(Quality, Lv) of
%                     #base_partner_break{attr_val = AttrAdd, loss_coef = LossCoef} ->
%                         %%AttrL = get_break_attr_upper(GrowUp, QualityList, BreakCfg),
%                         %%NewList = keyadd(List, AttrL),
%                         %%NewList;
%                         {Sum+AttrAdd, LossCoef};
%                     _ -> {Sum, List}
%                 end
%         end,
%     {TotalAttr, LossCoefL} = lists:foldl(F, {0, []}, BreakedL),
%     get_break_attr_upper(TotalAttr, GrowUp, QualityList, LossCoefL).

% get_break_attr_upper(_TotalAttr, GrowUp, _AttrQuality, _LossCoefL) ->
%     _Total = lists:sum(GrowUp),
%     %% 计算四围上限增加的值
%     %% Physique = lists:nth(1, GrowUp) * TotalAttr / Total * (1 - get_attr_loss_coef(AttrQuality, ?PHYSIQUE, LossCoefL)),
%     %% Agile = lists:nth(2, GrowUp) * TotalAttr / Total * (1 - get_attr_loss_coef(AttrQuality, ?AGILE, LossCoefL)),
%     %% Forza = lists:nth(3, GrowUp) * TotalAttr / Total * (1 - get_attr_loss_coef(AttrQuality, ?FORZA, LossCoefL)),
%     %% Dexterous = lists:nth(4, GrowUp) * TotalAttr / Total * (1 - get_attr_loss_coef(AttrQuality, ?DEXTEROUS, LossCoefL)),
%     %% [{?PHYSIQUE, 0, Physique}, {?AGILE, 0, Agile}, {?FORZA, 0, Forza}, {?DEXTEROUS, 0, Dexterous}].
%     [].
% %% 获取属性品质的损耗系数
% get_attr_loss_coef(AttrQuality, Type, LossCoefL) ->
%     {Type, Quality} = lists:keyfind(Type, 1, AttrQuality),
%     case lists:keyfind(Quality, 1, LossCoefL) of
%         false -> 0;
%         {Quality, Coef} -> Coef
%     end.

% %% 属性相加函数
% keyadd(List, AttrL) ->
%     F = fun({Type, CurVal, UpperVal}, Return) ->
%                 case lists:keyfind(Type, 1, Return) of
%                     false -> [{Type, CurVal, UpperVal}|Return];
%                     {Type, Val1, Val2} -> lists:keyreplace(Type, 1, Return, {Type, CurVal+Val1, UpperVal+Val2})
%                 end
%         end,
%     lists:foldl(F, List, AttrL).

% %% 伙伴遣散时 获取技能的遣散配置
% sk_convert_disband(SkId, {List, State}) ->
%     case data_partner:get_skill_by_skid(SkId) of
%         [{_, Color, _, _}|_T] ->
%             case data_partner:get_disband_by_quality(?TYPE_SK, Color) of
%                 DisbandCfg when is_record(DisbandCfg, base_partner_disband) ->
%                     {[DisbandCfg|List], State};
%                 _ -> {List, false}
%             end;
%         _ -> {List, false}
%     end.

% %% 伙伴遣散时 获取伙伴的遣散配置
% partner_convert_disband(#partner{quality = Quality}, {List, State}) ->
%     case data_partner:get_disband_by_quality(?TYPE_PAR, Quality) of
%         DisbandCfg when is_record(DisbandCfg, base_partner_disband) ->
%             {[DisbandCfg|List], State};
%         _ -> {List, false}
%     end.

% %% 设置伙伴信息
% set_partner_value(Partner, ValueList) ->
%     case ValueList of
%         [{attr_quality, QualityList}|T] ->
%             NewPartner = Partner#partner{attr_quality = QualityList},
%             set_partner_value(NewPartner, T);
%         [{apti_take, ObjectList}|T] ->
%             NewPartner = set_apti_take(Partner, ObjectList),
%             set_partner_value(NewPartner, T);
%         [{total_attr, TotalAttr}|T] ->
%             NewPartner = count_partner(total_attr, {TotalAttr, Partner}),
%             set_partner_value(NewPartner, T);
%         [{break_state, BreakList, BreakSt}|T] ->
%             NewPartner = Partner#partner{break_st = BreakSt, break = BreakList},
%             set_partner_value(NewPartner, T);
%         [{attribute}|T] ->
%             NewPartner = count_partner(attribute, Partner),
%             set_partner_value(NewPartner, T);
%         [{combat_power}|T] ->
%             NewPartner = count_partner(combat_power, Partner),
%             set_partner_value(NewPartner, T);
%         [{prodigy, WashCfg, AttrList, NewSkList}|T] ->
%             NewPartner = count_partner(prodigy, {Partner, WashCfg, AttrList, NewSkList}),
%             set_partner_value(NewPartner, T);
%         [{com_skill_list, SkList, CdList}|T] ->
%             NewPartner = set_partner_skill(Partner, SkList, CdList),
%             set_partner_value(NewPartner, T);
%         [{skill_learn, SkillId}|T] ->
%             SkLearne = Partner#partner.skill_learn,
%             NewSkLearn = [SkillId|SkLearne],
%             NewPartner = Partner#partner{skill_learn = NewSkLearn},
%             set_partner_value(NewPartner, T);
%         [{skill_replace, SkillId, RepalceId}|T] ->
%             SkLearne = Partner#partner.skill_learn,
%             SkLearne1 = lists:delete(RepalceId, SkLearne),
%             NewSkLearn = [SkillId|SkLearne1],
%             NewPartner = Partner#partner{skill_learn = NewSkLearn},
%             set_partner_value(NewPartner, T);
%         [{equip_weapon, WeaponSt}|T] ->
%             Equip = Partner#partner.equip,
%             NewEquip = Equip#partner_equip{weapon_st = WeaponSt},
%             NewPartner = Partner#partner{equip = NewEquip},
%             set_partner_value(NewPartner, T);
%         [_NoMatched|T] ->
%             set_partner_value(Partner, T);
%         [] ->
%             Partner
%     end.

% %% 设置伙伴的技能列表
% set_partner_skill(Partner, SkList, CdList) ->
%     SkStatus = Partner#partner.skill,
%     AttrMap = get_passive_skill_attr(SkList),
%     SkPower = get_skill_power(SkList, 0),
%     NewSkStatus = SkStatus#partner_skill{skill_attr = AttrMap, skill_list = SkList, skill_cd = CdList, sk_power = SkPower},
%     Partner#partner{skill = NewSkStatus}.

% %% 设置伙伴的资质丹服用列表
% set_apti_take(Partner, []) ->
%     Partner;
% set_apti_take(Partner, [Goods|T]) ->
%     case Goods of
%         {?TYPE_GOODS, GoodsTypeId, Num} ->
%             case lists:keyfind(GoodsTypeId, 1, Partner#partner.apti_take) of
%                 false ->
%                     NewList = [{GoodsTypeId, Num}|Partner#partner.apti_take],
%                     NewPartner = Partner#partner{apti_take = NewList},
%                     set_apti_take(NewPartner, T);
%                 {GoodsTypeId, Num1} ->
%                     NewList = lists:keyreplace(GoodsTypeId, 1, Partner#partner.apti_take, {GoodsTypeId, Num+Num1}),
%                     NewPartner = Partner#partner{apti_take = NewList},
%                     set_apti_take(NewPartner, T)
%             end;
%         _ ->
%             set_apti_take(Partner, T)
%     end.

% %% 获取被动技能带来的属性
% %% 技能属性有改动过!!!!!! 后期用到这个接口要做相应改动 详细参考技能里面的attr和base_attr
% get_passive_skill_attr(SkillList) ->
%     F = fun({SkillId, SkillLv, Pos}, Result) ->
%             case data_skill:get(SkillId, SkillLv) of
%                 [] -> Result;
%                 #skill{type=?SKILL_TYPE_PASSIVE, lv_data=LvData} when Pos < 6 ->
%                     LvData#skill_lv.attr ++ Result;
%                 _ -> Result
%             end
%         end,
%     AttrData = lists:foldl(F, [], SkillList),
%     tranc_skill_attr(AttrData, ?PARTNER_SKILL_BUFF).

% %% 获取普通技能带来的战力加成
% get_skill_power([], Sum) ->
%     Sum;
% get_skill_power([{Id, _, Pos}|T], Sum) ->
%     CombatPower = case data_partner:get_skill_by_skid(Id) of
%                       [{_, _, Power, _}|_L] -> Power;
%                       _ -> 0
%                   end,
%     case Pos < 6 of
%         true -> get_skill_power(T, Sum+CombatPower);
%         false -> get_skill_power(T, Sum)
%     end.

% %% 获取护主技能 给玩家带来的属性加成
% get_assist_skill_attr(SkillList) ->
%     F = fun({SkillId, SkillLv}, Result) ->
%                 case data_skill:get(SkillId, SkillLv) of
%                     [] -> Result;
%                     #skill{lv_data=LvData} -> LvData#skill_lv.attr ++ Result;
%                     _ -> Result
%                 end
%         end,
%     AttrData = lists:foldl(F, [], SkillList),
%     tranc_skill_attr(AttrData, ?PARTNER_SKILL_BUFF).

% %% 获取上阵伙伴的护主技能列表
% get_battle_partner_assist(PartnerSt) ->
%     PartnerMap = PartnerSt#partner_status.partners,
%     PartnerMap1 = maps:filter(fun(_, Partner) -> Partner#partner.state =:= ?STATE_BATTLE end, PartnerMap),
%     Fun = fun({_, Value}, List) ->
%                   {SkId, Lv} = get_assist_skill(Value),
%                   case lists:keyfind(SkId, 1, List) of
%                       false ->
%                           [{SkId, Lv}|List];
%                       {SkId, Lv1} when Lv1 < Lv ->
%                           lists:keyreplace(SkId, 1, List, {SkId, Lv});
%                       _ -> List
%                   end
%           end,
%     MapList = maps:to_list(PartnerMap1),
%     lists:foldl(Fun, [], MapList).

% get_battle_partner_power(PartnerSt) ->
%     PartnerMap = PartnerSt#partner_status.partners,
%     PartnerMap1 = maps:filter(fun(_, Partner) -> Partner#partner.state =:= ?STATE_BATTLE end, PartnerMap),
%     Fun = fun({_, Value}, Acc) ->
%                   PartPower = Value#partner.combat_power,
%                   Acc + round(PartPower)
%           end,
%     MapList = maps:to_list(PartnerMap1),
%     lists:foldl(Fun, 0, MapList).

% get_battle_partner_quality_list(PartnerSt, _QualityLevel) ->
%     PartnerMap = PartnerSt#partner_status.partners,
%     PartnerMap1 = maps:filter(fun(_, Partner) -> Partner#partner.state =:= ?STATE_BATTLE end, PartnerMap),
%     Fun = fun({_, Value}, List) ->
%                   [{Value#partner.partner_id, Value#partner.quality}|List]
%           end,
%     MapList = maps:to_list(PartnerMap1),
%     lists:foldl(Fun, [], MapList).

% %% 获取还没使用的上阵位置
% get_unused_battle_slot(PartnerSt) ->
%     MaxList = lists:seq(1, ?MAX_BATTLE),
%     PartnerMap = PartnerSt#partner_status.partners,
%     PartnerMap1 = maps:filter(fun(_, Partner) -> Partner#partner.state =:= ?STATE_BATTLE end, PartnerMap),
%     Fun = fun({_, Value}, List) ->
%                   case lists:member(Value#partner.pos, List) of
%                       true -> lists:delete(Value#partner.pos, List);
%                       false -> List
%                   end
%           end,
%     MapList = maps:to_list(PartnerMap1),
%     lists:foldl(Fun, MaxList, MapList).

% get_unused_skill_pos(Partner) ->
%     MaxList = lists:seq(1, 5),
%     Fun = fun(I, List) ->
%                   case lists:keymember(I, 3, Partner#partner.skill#partner_skill.skill_list) of
%                       true -> lists:delete(I, List);
%                       false -> List
%                   end
%           end,
%     lists:foldl(Fun, MaxList, MaxList).

% %% 获取 护主技能
% get_assist_skill(Partner) ->
%     SkList = Partner#partner.skill#partner_skill.skill_list,
%     {SkId, Lv, _} = lists:keyfind(?ASSIST, 3, SkList),
%     {SkId, Lv}.

% %% 计算伙伴的二级属性
% count_partner(attribute, Partner) ->
%     %% PartnerCfg = data_partner:get_partner_by_id(Partner#partner.partner_id),
%     %% TotalAttr = Partner#partner.total_attr,
%     %% %% {BaseHp, Physique, Agile, Forza, Dexterous, CritHurt, Speed, AttSpeed} = base_attr(TotalAttr, PartnerCfg),
%     %% BaseHp = 1,
%     %% ComSkAttr = Partner#partner.skill#partner_skill.skill_attr,
%     %% #{
%     %%    %% ?HP_RATIO:=HpRatio1,
%     %%    ?HP:=Hp1, %% ?ALL_RESIS:=AllResis1,
%     %%    ?DODGE:=Dodge1, ?ATT:=Att1,
%     %%    %% ?METAL_ATT:=MetalAtt1, ?WOOD_ATT:=WoodAtt1, ?WATER_ATT:=WaterAtt1, ?FIRE_ATT:=FireAtt1,
%     %%    %% ?EARTH_ATT:=EarthAtt1, ?METAL_RESIS:=MetalResis1, ?WOOD_RESIS:=WoodResis1, ?WATER_RESIS:=WaterResis1,
%     %%    %% ?FIRE_RESIS:=FireResis1, ?EARTH_RESIS:=EarthResis1, ?ALL_RESIS_DEL:=AllResisDel1, ?DODGE_DEL:=DodgeDel1,
%     %%    ?CRIT:=Crit1, %% ?CRIT_HURT:=CritHurt1, ?CRIT_DEL:=CritDel1, ?CRIT_HURT_DEL:=CritHurtDel1,
%     %%    %% ?HP_RESUME:=HpResume1, ?HP_RESUME_ADD:=HpResumeAdd1, ?SUCK_BLOOD:=SuckBlood1,
%     %%    %% ?ATT_SPEED:=AttSpeed1,
%     %%    ?SPEED:=Speed1
%     %%  } = ComSkAttr,
%     %% EquipAttr = get_equip_attr(Partner#partner.equip, Partner#partner.partner_id),
%     %% #{?HP:=Hp2, ?DODGE:=Dodge2, ?ATT:=Att2} = EquipAttr,
%     %% %% #{?CRIT_DEL:=CritDel3} = get_attr_by_personality(Partner#partner.personality),

%     %% %% =============================== 汇总 ====================
%     %% %% LastForza = round(Forza),
%     %% %% LastPhysique = round(Physique),
%     %% %% LastAgile = round(Agile),
%     %% %% LastDexterous = round(Dexterous),
%     %% LastHp = round(BaseHp + Hp1 + Hp2),
%     %% %% LastHpRatio = round(HpRatio1 + HpRatio2),
%     %% LastAtt = round(Att1 + Att2) ,
%     %% LastDodge = round(Dodge1 + Dodge2),
%     %% %% LastAllResis = round(AllResis1 + AllResis2),
%     %% %% LastCritDel = CritDel1 + CritDel3,
%     %% %% LastCritHurt = CritHurt + CritHurt1,
%     %% %% LastMetalAtt = MetalAtt1,
%     %% %% LastWoodAtt = WoodAtt1,
%     %% %% LastWaterAtt = WaterAtt1,
%     %% %% LastFireAtt = FireAtt1,
%     %% %% LastEarthAtt = EarthAtt1,
%     %% %% LastMetalResis = MetalResis1,
%     %% %% LastWoodResis = WoodResis1,
%     %% %% LastWaterResis = WaterResis1,
%     %% %% LastFireResis = FireResis1,
%     %% %% LastEarthResis = EarthResis1,
%     %% %% LastAllResisDel = AllResisDel1,
%     %% %% LastDodgeDel = DodgeDel1,
%     %% LastCrit = Crit1,
%     %% %% LastCritHurtDel = CritHurtDel1,
%     %% %% LastHpResume = HpResume1,
%     %% %% LastHpResumeAdd = HpResumeAdd1,
%     %% %% LastSuckBlood = SuckBlood1,
%     %% %% LastAttSpeed = AttSpeed + AttSpeed1,
%     %% LastSpeed = Speed + Speed1,
%     %% AttrR = #{
%     %%   ?ATT => LastAtt,
%     %%   ?HP => LastHp,
%     %%   %% ?HP_RATIO => LastHpRatio,
%     %%   %% ?PHYSIQUE => LastPhysique,
%     %%   %% ?AGILE => LastAgile,
%     %%   %% ?FORZA => LastForza,
%     %%   %% ?DEXTEROUS => LastDexterous,
%     %%   ?DODGE => LastDodge,
%     %%   %% ?ALL_RESIS => LastAllResis,
%     %%   %% ?CRIT_DEL => LastCritDel,
%     %%   %% ?CRIT_HURT => LastCritHurt,
%     %%   %% ?METAL_ATT => LastMetalAtt,
%     %%   %% ?WOOD_ATT => LastWoodAtt,
%     %%   %% ?WATER_ATT => LastWaterAtt,
%     %%   %% ?FIRE_ATT => LastFireAtt,
%     %%   %% ?EARTH_ATT => LastEarthAtt,
%     %%   %% ?METAL_RESIS => LastMetalResis,
%     %%   %% ?WOOD_RESIS => LastWoodResis,
%     %%   %% ?WATER_RESIS => LastWaterResis,
%     %%   %% ?FIRE_RESIS => LastFireResis,
%     %%   %% ?EARTH_RESIS => LastEarthResis,
%     %%   %% ?ALL_RESIS_DEL => LastAllResisDel,
%     %%   %% ?DODGE_DEL => LastDodgeDel,
%     %%   ?CRIT => LastCrit,
%     %%   %% ?CRIT_HURT_DEL => LastCritHurtDel,
%     %%   %% ?HP_RESUME => LastHpResume,
%     %%   %% ?HP_RESUME_ADD => LastHpResumeAdd,
%     %%   %% ?SUCK_BLOOD => LastSuckBlood,
%     %%   %% ?ATT_SPEED => LastAttSpeed,
%     %%   ?SPEED => LastSpeed
%     %%  },
%     %% Partner#partner{battle_attr = AttrR};
%     Partner;
% %% 计算伙伴的战力
% count_partner(combat_power, Partner) ->
%     %% 计算伙伴战力
%     CombatPower = calc_combat_power(Partner),
%     NewPartner = Partner#partner{combat_power = CombatPower},
%     %% 更新护主技能等级
%     PartnerCfg = data_partner:get_partner_by_id(Partner#partner.partner_id),
%     update_assist_skill(NewPartner, PartnerCfg);
% %% 计算伙伴是否是奇才
% count_partner(prodigy, {Partner, WashCfg, AttrList, NewSkList}) ->
%     CombatPower = calc_base_combat_power(Partner, AttrList, NewSkList),
%     #base_partner_wash{prodigy = ProdigyCond} = WashCfg,
%     Fun = fun({Lower,Upper,Weight}, Num) ->
%                   case CombatPower >= Lower andalso CombatPower =< Upper of
%                       true -> Weight;
%                       false -> Num
%                   end
%           end,
%     Weight1 = lists:foldl(Fun, 0, ProdigyCond),
%     RandNum = urand:rand(1,1000),
%     Prodigy = if
%                   Weight1 >= RandNum -> 1;
%                   true -> 0
%               end,
%     Partner#partner{prodigy = Prodigy};
% %% 计算伙伴的总属性(保留小数两位)
% count_partner(total_attr, {TotalAttr, Partner}) ->
%     F = fun({Type, Cur, Upper}) -> {Type, util:float_sub(Cur,2), util:float_sub(Upper,2)} end,
%     NewAttr = lists:map(F, TotalAttr),
%     Partner#partner{total_attr = NewAttr}.


% %% 基础属性
% base_attr(_TotalAttr, _PartnerCfg) ->
%     %% {_,Physique,_} = lists:keyfind(?PHYSIQUE, 1, TotalAttr),
%     %% {_,Agile,_} = lists:keyfind(?AGILE, 1, TotalAttr),
%     %% {_,Forza,_} = lists:keyfind(?FORZA, 1, TotalAttr),
%     %% {_,Dexterous,_} = lists:keyfind(?DEXTEROUS, 1, TotalAttr),

%     %% [BaseHp|_T] = PartnerCfg#base_partner.born_attr,
%     %% CritHurt = 180,
%     %% {BaseHp, Physique, Agile, Forza, Dexterous, CritHurt, ?SPEED_VALUE, ?ATT_SPEED_VALUE}.
%     {0, 0, 0, 0, 0, 0, ?SPEED_VALUE, 0}.

% %% 计算伙伴战力 战力计算待修改
% calc_combat_power(Partner) ->
%     #partner{lv = Lv, grow_up = GrowUp, total_attr = TotalAttr} = Partner,
%     AttrSum = lists:foldl(fun({_Type, Cur, _Upper}, Sum) -> Sum + Cur end, 0, TotalAttr),
%     UpgradeAttr = lists:sum(GrowUp)*(Lv-1),
%     EquipPower = get_equip_power(Partner#partner.equip, Partner#partner.partner_id),
%     SkPower = Partner#partner.skill#partner_skill.sk_power,
%     {Coef, IgnorePower} = case data_partner:get_power_coef(Partner#partner.quality) of
%                               [{Val1, Val2}|_T] -> {Val1, Val2};
%                               _ -> {0, 0}
%                           end,
%     Power = (AttrSum - UpgradeAttr - IgnorePower)*Coef + EquipPower + SkPower,
%     max(1, Power).

% %% 计算伙伴基础战力，只在洗髓和招募完的时候调用
% calc_base_combat_power(Partner, AttrList, SkList) ->
%     BaseAttrSum = lists:foldl(fun({_Type, Cur, _Upper}, Sum) -> Sum + Cur end, 0, AttrList),
%     SkPower = get_skill_power(SkList, 0),
%     {Coef, IgnorePower} = case data_partner:get_power_coef(Partner#partner.quality) of
%                               [{Val1, Val2}|_T] -> {Val1, Val2};
%                               _ -> {0, 0}
%                           end,
%     Power = (BaseAttrSum - IgnorePower)*Coef + SkPower,
%     max(1, Power).

% %% 更新护主技能等级
% update_assist_skill(Partner, PartnerCfg) when is_record(PartnerCfg, base_partner) ->
%     CombatPower = Partner#partner.combat_power,
%     SkList = Partner#partner.skill#partner_skill.skill_list,
%     {AssistSkId, Lv, _} = lists:keyfind(?ASSIST, 3, SkList),
%     AssistCond = PartnerCfg#base_partner.assist_condition,
%     Fun = fun({Lower, Upper, Lv1}, Return) ->
%                   case CombatPower >= Lower andalso CombatPower =< Upper of
%                       true -> Lv1;
%                       false -> Return
%                   end
%           end,
%     NewLv = lists:foldl(Fun, Lv, AssistCond),
%     NewSkList = lists:keystore(?ASSIST, 3, SkList, {AssistSkId, NewLv, ?ASSIST}),
%     NewSkill = Partner#partner.skill#partner_skill{skill_list = NewSkList},
%     Partner#partner{skill = NewSkill};
% update_assist_skill(Partner, _PartnerCfg) ->
%     Partner.

% %% 获取专属武器加成属性
% get_equip_attr(Equip, PartnerId) when is_record(Equip, partner_equip) ->
%     AttrMaps = #{?HP=>0, ?DODGE=>0, ?ATT=>0},
%     case Equip#partner_equip.weapon_st =/= ?PARTNER_EQUIP_UNACTIVE of
%         true ->
%             case data_partner:get_weapon_by_partnerid(PartnerId) of
%                 [{AttrList, _}|_T] ->
%                     lib_player_attr:list_add_to_attr(AttrList, AttrMaps);
%                 _ -> AttrMaps
%             end;
%         false -> AttrMaps
%     end;
% get_equip_attr(_Equip, _PartnerId) ->
%     #{?HP=>0,  ?DODGE=>0, ?ATT=>0}.

% %% 获取专属武器战力
% get_equip_power(Equip, PartnerId) when is_record(Equip, partner_equip) ->
%     case Equip#partner_equip.weapon_st =/= ?PARTNER_EQUIP_UNACTIVE of
%         true ->
%             case data_partner:get_weapon_by_partnerid(PartnerId) of
%                 [{_, CombatPower}|_T] -> CombatPower;
%                 _ -> 0
%             end;
%         false -> 0
%     end;
% get_equip_power(_Equip, _PartnerId) -> 0.

% %% 转换技能附加属性为#{}
% tranc_skill_attr([{AttrId, _BufType, _Per, _To, Int, _Float, _Time, _Count, _Effect}|T], AttrMaps) ->
%     case maps:is_key(AttrId, AttrMaps) of
%         false -> tranc_skill_attr(T, AttrMaps#{AttrId => Int});
%         true  -> tranc_skill_attr(T, AttrMaps#{AttrId => Int+maps:get(AttrId, AttrMaps)})
%     end;
% tranc_skill_attr([], AttrMaps) -> AttrMaps.

% %% 更新玩家的招募次数和免费招募时间戳
% update_partner_recruit_tms(PartnerSt, RecuitCfg, CurRecruits, IsFree) ->
%     NowTime = utime:unixtime(),
%     #base_partner_recruit{recruit_type = RecruitType, free_cd = FreeCd} = RecuitCfg,
%     {_, CoinEt} = PartnerSt#partner_status.recruit_type1,
%     {_, GoldEt} = PartnerSt#partner_status.recruit_type2,
%     NewPartnerSt = if
%                        RecruitType == ?RECRUIT_TYPE1 andalso IsFree == true ->
%                            PartnerSt#partner_status{recruit_type1 = {CurRecruits, NowTime + FreeCd}};
%                        RecruitType == ?RECRUIT_TYPE1 andalso IsFree == false ->
%                            PartnerSt#partner_status{recruit_type1 = {CurRecruits, CoinEt}};
%                        RecruitType == ?RECRUIT_TYPE2 andalso IsFree == true ->
%                            PartnerSt#partner_status{recruit_type2 = {CurRecruits, NowTime + FreeCd}};
%                        RecruitType == ?RECRUIT_TYPE2 andalso IsFree == false ->
%                            PartnerSt#partner_status{recruit_type2 = {CurRecruits, GoldEt}};
%                        true ->
%                            PartnerSt
%                    end,
%     %%?PRINT("recruit_tms : ~p~n", [{NewPartnerSt#partner_status.recruit_type1, NewPartnerSt#partner_status.recruit_type2}]),
%     NewPartnerSt.


% get_attr_by_personality(Personality) ->
%     case Personality of
%         %%?PERSONALITY_1 ->
%         %% ?PERSONALITY_2 -> #{?CRIT_DEL=>400};
%         _ -> #{}
%     end.

% %% 四围属性颜色值
% get_attr_coef(1) -> 4;
% get_attr_coef(2) -> 3;
% get_attr_coef(3) -> 2;
% get_attr_coef(4) -> 1;
% get_attr_coef(5) -> 0.

% %% 伙伴品质潜质系数
% get_quality_coef(1) -> 2;
% get_quality_coef(2) -> 1;
% get_quality_coef(3) -> 2;
% get_quality_coef(4) -> 4;
% get_quality_coef(5) -> 2.

% %% 伙伴品质
% get_quality_string(5) -> "SS";
% get_quality_string(4) -> "S";
% get_quality_string(3) -> "A";
% get_quality_string(2) -> "B";
% get_quality_string(1) -> "C";
% get_quality_string(_) -> "C".

% %% 伙伴品质颜色
% get_quality_color(5) -> 5;
% get_quality_color(4) -> 3;
% get_quality_color(3) -> 2;
% get_quality_color(2) -> 1;
% get_quality_color(1) -> 0;
% get_quality_color(_) -> 0.
