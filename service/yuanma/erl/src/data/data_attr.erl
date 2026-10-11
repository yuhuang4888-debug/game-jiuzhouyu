%%-----------------------------------------------------------------------------
%% @Module  :       data_attr
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-08-25
%% @Description:
%%-----------------------------------------------------------------------------
-module(data_attr).

-include("attr.hrl").
-include("def_goods.hrl").

-compile([export_all]).

%% 获取属性的基础评分
get_attr_base_rating(AttrId, _Stage) ->
    %%映射表
    Stage = get_map_stage(_Stage),
    case AttrId of
        ?ATT                    -> 10;
        ?HP                     -> 0.5;
        ?WRECK                  -> 10;
        ?DEF                    -> 10;
        ?HIT                    -> 10;
        ?DODGE                  -> 10;
        ?CRIT                   -> 10;
        ?TEN                    -> 10;
        ?HURT_ADD_RATIO         -> Stage * 8;
        ?HURT_DEL_RATIO         -> Stage * 8;
        ?HIT_RATIO              -> Stage * 8;
        ?DODGE_RATIO            -> Stage * 8;
        ?CRIT_RATIO             -> Stage * 8;
        ?UNCRIT_RATIO           -> Stage * 8;
        ?ELEM_ATT               -> 10;
        ?ELEM_DEF               -> 10;
        ?HEART_RATIO            -> Stage * 2.4;
        ?ATT_ADD_RATIO          -> Stage * 4.8;
        ?HP_ADD_RATIO           -> Stage * 4.8;
        ?WRECK_ADD_RATIO        -> Stage * 2.4;
        ?DEF_ADD_RATIO          -> Stage * 2.4;
        ?HIT_ADD_RATIO          -> Stage * 1.2;
        ?DODGE_ADD_RATIO        -> Stage * 1.2;
        ?CRIT_ADD_RATIO         -> Stage * 1.2;
        ?TEN_ADD_RATIO          -> Stage * 1.2;
        ?SKILL_HURT_ADD_RATIO   -> Stage * 2.8;
        ?SKILL_HURT_DEL_RATIO   -> Stage * 2.8;
        ?CRIT_HURT_ADD_RATIO    -> Stage * 2;
        ?CRIT_HURT_DEL_RATIO    -> Stage * 2;
        ?PARRY_RATIO            -> Stage * 4;
        ?HEART_HURT_ADD_RATIO   -> Stage * 2.4;
        ?HEART_HURT_DEL_RATIO   -> Stage * 2.4;
        ?HEART_DOWN_RATIO       -> Stage * 2.4;
        ?ABS_ATT                -> 20;
        ?ABS_DEF                -> 20;
        ?EXC_RATIO              -> Stage * 4;
        ?UNEXC_RATIO            -> Stage * 4;
        ?EXC_HURT_ADD_RATIO     -> Stage * 1.6;
        ?EXC_HURT_DEL_RATIO     -> Stage * 1.6;
        ?ARMOR                  -> 2.4;
        ?PVP_HURT_ADD           -> 20;
        ?PVP_HURT_DEL           -> 20;

        ?LV_ATT                 -> Stage * 240;
        ?LV_HP                  -> Stage * 240;
        ?LV_WRECK               -> Stage * 240;
        ?LV_DEF                 -> Stage * 240;
        ?LV_HIT                 -> Stage * 240;
        ?LV_DODGE               -> Stage * 240;
        ?LV_CRIT                -> Stage * 240;
        ?LV_TEN                 -> Stage * 240;

        %% 目前没用,策划说暂时保留
        ?ATTR_ADD_COIN          -> 0;
        ?ATTR_EQUIP_DROP_UP     -> 0;  
        ?ELEM_ATT_ADD_RATIO     -> Stage * 0.5;
        ?ELEM_DEF_ADD_RATIO     -> Stage * 0.5;
        ?PARRY                  -> Stage * 0.35;
        ?NEGLECT                -> Stage * 0.35;
        ?REBOUND_RATIO          -> Stage * 6;
        ?PVP_BLOOD_RATIO        -> Stage * 6;
        _                       -> 0
    end.

get_attr_base_rating_help(AttrId, RoleLv, AttrVal) ->
    case AttrId of
         ?LV_ATT_ADD_RATIO       -> get_percent_rating(RoleLv, AttrVal, 1) * get_attr_base_rating(1, 1) ;
         ?LV_HP_ADD_RATIO        -> get_percent_rating(RoleLv, AttrVal, 2) * get_attr_base_rating(2, 1) ;
         ?LV_WRECK_ADD_RATIO     -> get_percent_rating(RoleLv, AttrVal, 3) * get_attr_base_rating(3, 1) ;
         ?LV_DEF_ADD_RATIO       -> get_percent_rating(RoleLv, AttrVal, 4) * get_attr_base_rating(4, 1) ;
         ?LV_HIT_ADD_RATIO       -> get_percent_rating(RoleLv, AttrVal, 5) * get_attr_base_rating(5, 1) ;
         ?LV_DODGE_ADD_RATIO     -> get_percent_rating(RoleLv, AttrVal, 6) * get_attr_base_rating(6, 1) ;
         ?LV_CRIT_ADD_RATIO      -> get_percent_rating(RoleLv, AttrVal, 7) * get_attr_base_rating(7, 1) ;
         ?LV_TEN_ADD_RATIO       -> get_percent_rating(RoleLv, AttrVal, 8) * get_attr_base_rating(8, 1)
    end.

get_percent_rating(RoleLv, AttrVal, AttrId) ->
    LvAttr = lib_player:base_lv_attr(RoleLv),
    {_AttrId ,AttrNum} = lists:keyfind(AttrId, 1, LvAttr),
    util:ceil(AttrNum / 10000 * AttrVal).


%% 特殊属性id, 属性值, 三个装备属性
get_attr_base_rating_equip(AttrId, AttrVal,EquipAttr) ->
    case AttrId of
        ?WEAPON_ATT     -> get_percent_rating1(EquipAttr, AttrVal, 1, 1) * get_attr_base_rating(1, 1) ;
        ?WEAPON_WRECK   -> get_percent_rating1(EquipAttr, AttrVal, 3, 1) * get_attr_base_rating(3, 1) ;
        ?ARMOR_HP       -> get_percent_rating1(EquipAttr, AttrVal, 2, 2) * get_attr_base_rating(2, 1) ;
        ?ARMOR_DEF      -> get_percent_rating1(EquipAttr, AttrVal, 4, 2) * get_attr_base_rating(4, 1) ;
        ?ORNAMENT_ATT   -> get_percent_rating1(EquipAttr, AttrVal, 1, 3) * get_attr_base_rating(1, 1) ;
        ?ORNAMENT_WRECK -> get_percent_rating1(EquipAttr, AttrVal, 3, 3) * get_attr_base_rating(3, 1)
    end.


get_percent_rating1(EquipAttr, AttrVal, AttrId, EquipAttrId) ->
    [WeaponAttr, ArmorAttr, OrnamentAttr] = EquipAttr,
    EquipIdAttr =
        case EquipAttrId of
            1 -> WeaponAttr;
            2-> ArmorAttr;
            3-> OrnamentAttr
        end,
    {_AttrId ,AttrNum} = lists:keyfind(AttrId, 1, EquipIdAttr),
    util:ceil(AttrNum / 10000 * AttrVal).






%% 获取铸灵属性的基础评分
get_attr_base_rating_ex(AttrId) ->
    case AttrId of
        ?ATT                    -> 10;
        ?HP                     -> 0.5;
        ?WRECK                  -> 10;
        ?DEF                    -> 10;
        ?HIT                    -> 2;
        ?DODGE                  -> 2;
        ?CRIT                   -> 2;
        ?TEN                    -> 2;
        ?HURT_ADD_RATIO         -> 0;
        ?HURT_DEL_RATIO         -> 0;
        ?HIT_RATIO              -> 0;
        ?DODGE_RATIO            -> 0;
        ?CRIT_RATIO             -> 0;
        ?UNCRIT_RATIO           -> 0;
        ?ELEM_ATT               -> 0;
        ?ELEM_DEF               -> 0;
        ?HEART_RATIO            -> 0;
        ?SKILL_HURT_ADD_RATIO   -> 0;
        ?SKILL_HURT_DEL_RATIO   -> 0;
        ?ATT_ADD_RATIO          -> 0;
        ?HP_ADD_RATIO           -> 0;
        ?WRECK_ADD_RATIO        -> 0;
        ?DEF_ADD_RATIO          -> 0;
        ?HIT_ADD_RATIO          -> 0;
        ?DODGE_ADD_RATIO        -> 0;
        ?CRIT_ADD_RATIO         -> 0;
        ?TEN_ADD_RATIO          -> 0;
        _                       -> 0
    end.

%% 成长属性转成实际增加的属性值
growth_attr2real_val(Lv, AttrBaseVal, AttrPlusInterval, AttrPlus) ->
    AttrBaseVal + util:floor(Lv / AttrPlusInterval) * AttrPlus.

%% 把装备极品属性的格式都统一成以下格式
%% {颜色, 属性类型,属性值,每X级成长一次,每次成长Y点}
unified_format_extra_attr([], Result) -> Result;
unified_format_extra_attr([{Color, AttrId, AttrVal}|ExtraAttr], Result) ->
    NewResult = Result ++ [{Color, 2, AttrId, AttrVal, 0, 0}],
    unified_format_extra_attr(ExtraAttr, NewResult);
unified_format_extra_attr([{Color, AttrId, AttrVal, AttrPlusInterval, AttrPlus}|ExtraAttr], Result) ->
    NewResult = Result ++ [{Color, 1, AttrId, AttrVal, AttrPlusInterval, AttrPlus}],
    unified_format_extra_attr(ExtraAttr, NewResult);
unified_format_extra_attr([_|ExtraAttr], Result) ->
    unified_format_extra_attr(ExtraAttr, Result).

unified_format_addition_attr(Addition, ?GOODS_TYPE_CONSTELLATION) ->
    [{AttrId, AttrVal, Color, AttrType} ||{AttrId, AttrVal, Level, PerAdd, Color, AttrType} <- Addition];
unified_format_addition_attr(Addition, _) ->
    Addition.

get_map_stage(1) -> 1;
get_map_stage(2) -> 2;
get_map_stage(3) -> 4;
get_map_stage(4) -> 8;
get_map_stage(5) -> 12;
get_map_stage(6) -> 12;
get_map_stage(7) -> 13;
get_map_stage(8) -> 14;
get_map_stage(9) -> 16;
get_map_stage(10) -> 18;
get_map_stage(11) -> 22;
get_map_stage(12) -> 28;
get_map_stage(13) -> 36;
get_map_stage(14) -> 50;
get_map_stage(15) -> 72;
get_map_stage(16) -> 100;
get_map_stage(Stage) -> Stage.

