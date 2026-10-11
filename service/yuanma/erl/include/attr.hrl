%% ---------------------------------------------------------------------------
%% @doc attr.hrl
%% @author ming_up@foxmail.com
%% @since  2016-04-14
%% @deprecated 属性相关记录
%% ---------------------------------------------------------------------------
-define(DEF_ATTR_MAP, #{?ATT=>0, ?HP=>0, ?WRECK=>0, ?DEF=>0, ?HIT=>0, ?DODGE=>0, ?CRIT=>0, ?TEN=>0,
                        ?HURT_ADD_RATIO=>0, ?HURT_DEL_RATIO=>0, ?HIT_RATIO=>0, ?DODGE_RATIO=>0,
                        ?CRIT_RATIO=>0, ?UNCRIT_RATIO=>0, ?ELEM_ATT=>0, ?ELEM_DEF=>0, ?HEART_RATIO=>0, ?SPEED=>0,
                        ?ATT_ADD_RATIO=>0, ?HP_ADD_RATIO=>0, ?WRECK_ADD_RATIO=>0, ?DEF_ADD_RATIO=>0,
                        ?HIT_ADD_RATIO=>0, ?DODGE_ADD_RATIO=>0, ?TEN_ADD_RATIO=>0}).

-define(PARTIAL_TYPE, [
        ?PARTIAL_ATT_ADD_RATIO,
        ?PARTIAL_HP_ADD_RATIO,
        ?PARTIAL_WRECK_ADD_RATIO,
        ?PARTIAL_DEF_ADD_RATIO,
        ?PARTIAL_HIT_ADD_RATIO,
        ?PARTIAL_DODGE_ADD_RATIO,
        ?PARTIAL_CRIT_ADD_RATIO,
        ?PARTIAL_TEN_ADD_RATIO,
        ?PARTIAL_ELEM_ATT_ADD_RATIO,
        ?PARTIAL_ELEM_DEF_ADD_RATIO
    ]).

%% 注意:新增的属性过多,没有规则,不能简单根据差值来处理
%% 局部加成属性对应的全局属性
% -define(PARTIAL2GLOBAL_INTERVAL, 59). %% 局部属性映射到全局属性的差值
-define(PARTIAL2GLOBAL, 
    fun(Type) ->
        case Type of
            ?PARTIAL_ATT_ADD_RATIO -> ?ATT;
            ?PARTIAL_HP_ADD_RATIO -> ?HP;
            ?PARTIAL_WRECK_ADD_RATIO -> ?WRECK;
            ?PARTIAL_DEF_ADD_RATIO -> ?DEF;
            ?PARTIAL_HIT_ADD_RATIO -> ?HIT;
            ?PARTIAL_DODGE_ADD_RATIO -> ?DODGE;
            ?PARTIAL_CRIT_ADD_RATIO -> ?CRIT;
            ?PARTIAL_TEN_ADD_RATIO -> ?TEN;
            ?PARTIAL_ELEM_ATT_ADD_RATIO -> ?ELEM_ATT;
            ?PARTIAL_ELEM_DEF_ADD_RATIO -> ?ELEM_DEF;
            _ -> false
        end
    end).

%% 全局加成百分比属性
-define(GLOBAL_ADD_RATIO_TYPE, [
    ?ATT_ADD_RATIO
    , ?HP_ADD_RATIO
    , ?WRECK_ADD_RATIO
    , ?DEF_ADD_RATIO
    , ?HIT_ADD_RATIO
    , ?DODGE_ADD_RATIO
    , ?CRIT_ADD_RATIO
    , ?TEN_ADD_RATIO
    ]).

%% 装备加成百分比属性
-define(EQUIP_ADD_RATIO_TYPE, [
    ?WEAPON_ATT,
    ?WEAPON_WRECK,
    ?ARMOR_HP,
    ?ARMOR_DEF,
    ?ORNAMENT_ATT,
    ?ORNAMENT_WRECK
    ]).

%% 等级加成百分比基础
-define(LV_ADD_RATIO_TYPE, [
    ?LV_ATT_ADD_RATIO,
    ?LV_HP_ADD_RATIO,
    ?LV_WRECK_ADD_RATIO,
    ?LV_DEF_ADD_RATIO,
    ?LV_HIT_ADD_RATIO,
    ?LV_DODGE_ADD_RATIO,
    ?LV_CRIT_ADD_RATIO,
    ?LV_TEN_ADD_RATIO
    ]).

%% 百分比属性的比例系数
-define(RATIO_COEFFICIENT, 10000).  % 注意:概率也使用了
-define(ADD_PER_LV, 3).   % 默认每多少级增加属性

%% 基础的加固定值属性
-define(BASE_ATTR_LIST, [?ATT, ?HP, ?WRECK, ?DEF, ?HIT, ?DODGE, ?CRIT, ?TEN]).

%% 特殊玩家属性列表
-define(SP_ATTR_LIST, 
    [?SPEED_ADD_RATIO, ?HP_RESUME, ?BOSS_HURT_ADD, ?PVEP_HURT_DEL, ?PVE_SKILL_HURT, ?PVP_CRIT_ADD_RATIO]).
%% 特殊玩家属性Map(对应上面的List)
-define(SP_ATTR_MAP, 
    #{?SPEED_ADD_RATIO => 0, ?HP_RESUME => 0, ?BOSS_HURT_ADD => 0, ?PVEP_HURT_DEL => 0, ?PVE_SKILL_HURT => 0, ?PVP_CRIT_ADD_RATIO => 0}).

%% 注意：此版本属性较多，建议内存中保存属性列表，不建议保存attr{}
%% 属性对应的编号，对应数据库中的base_goods_attribute表中的数据，客户端可以根据编号读取到对应的中文
%% 在生成配置时尽量使用此编号
%% 如:生成属性列表[{1, 100}, {2, 50}, {3, 400}] 表示攻击100，属性攻击50，血量400，可以这个列表放到对应的功能record里面
%% 也可以可以通过lib_player_attr:list_to_record/1 转换为#attr{}
-define(ATT,       1).                  %% 攻击
-define(HP,        2).                  %% 气血
-define(WRECK,     3).                  %% 破甲
-define(DEF,       4).                  %% 防御
-define(HIT,       5).                  %% 命中
-define(DODGE,     6).                  %% 闪避
-define(CRIT,      7).                  %% 暴击
-define(TEN,       8).                  %% 坚韧
-define(HURT_ADD_RATIO,   9).           %% 伤害加深万分比
-define(HURT_DEL_RATIO,   10).          %% 伤害减免万分比
-define(HIT_RATIO,        11).          %% 命中几率
-define(DODGE_RATIO,      12).          %% 闪避几率
-define(CRIT_RATIO,       13).          %% 暴击几率
-define(UNCRIT_RATIO,     14).          %% 抗暴几率
-define(ELEM_ATT,         15).          %% 元素攻击
-define(ELEM_DEF,         16).          %% 元素防御
-define(HEART_RATIO,      17).          %% 会心几率
-define(SPEED,            18).          %% 移动速度
-define(ATT_ADD_RATIO,    19).          %% 攻击增加百分比
-define(HP_ADD_RATIO,     20).          %% 气血增加百分比
-define(WRECK_ADD_RATIO,  21).          %% 破甲增加百分比
-define(DEF_ADD_RATIO,    22).          %% 防御增加百分比
-define(HIT_ADD_RATIO,    23).          %% 命中增加百分比
-define(DODGE_ADD_RATIO,  24).          %% 闪避增加百分比
-define(CRIT_ADD_RATIO,   25).          %% 暴击增加百分比
-define(TEN_ADD_RATIO,    26).          %% 坚韧增加百分比
-define(SKILL_HURT_ADD_RATIO,     27).  %% 技能伤害加深百分比
-define(SKILL_HURT_DEL_RATIO,     28).  %% 受到技能伤害减免百分比
-define(ELEM_ATT_ADD_RATIO,       29).  %% 元素攻击增加百分比
-define(ELEM_DEF_ADD_RATIO,       30).  %% 元素攻击增加百分比
-define(AY_WRECK,                 31).  %% 暗影穿透(yy3d:目前没用)
-define(AY_DEF,                   32).  %% 暗影耐性(yy3d:目前没用)
-define(SS_WRECK,                 33).  %% 神圣穿透(yy3d:目前没用)
-define(SS_DEF,                   34).  %% 神圣耐性(yy3d:目前没用)
-define(HD_WRECK,                 35).  %% 混沌穿透(yy3d:目前没用)
-define(HD_DEF,                   36).  %% 混沌耐性(yy3d:目前没用)
-define(CRIT_HURT_ADD_RATIO,      37).  %% 暴伤加深百分比
-define(CRIT_HURT_DEL_RATIO,      38).  %% 暴伤减免百分比
-define(PARRY_RATIO,              39).  %% 格挡几率百分比
-define(OVERLOAD_RATIO,           40).  %% 过载几率(cd重置几率)
-define(PARRY,                    41).  %% 招架
-define(NEGLECT,                  42).  %% 忽视
-define(HEART_HURT_ADD_RATIO,     43).  %% 会心伤害
-define(HEART_HURT_DEL_RATIO,     44).  %% 会心免伤
-define(HEART_DOWN_RATIO,         45).  %% 抗会心几率
-define(ABS_ATT,                  46).  %% 绝对攻击
-define(ABS_DEF,                  47).  %% 绝对防御
-define(REBOUND_RATIO,            48).  %% 反弹受到伤害万分比
-define(PVP_BLOOD_RATIO,          49).  %% PVP吸取收到伤害万分比
-define(DRACONIC_SACRED,          50).  %% 神圣龙语
-define(DRACONIC_TSPACE,          51).  %% 时空龙语
-define(DRACONIC_ARRAY,           52).  %% 法则龙语
-define(EXC_RATIO,                53).  %% 卓越一击几率万分比   
-define(UNEXC_RATIO,              54).  %% 抗卓越一击几率万分比
-define(EXC_HURT_ADD_RATIO,       55).  %% 卓越一击伤害加深万分比
-define(EXC_HURT_DEL_RATIO,       56).  %% 卓越一击伤害减免万分比
-define(ARMOR,                    57).  %% 护甲
-define(UNDIZZY_RATIO,            58).  %% 抗眩晕万分比
-define(SPEED_ADD_RATIO,          59).  %% 移动速度增加百分比
%% 局部属性
-define(PARTIAL_ATT_ADD_RATIO,    60).  %% 局部攻击增加百分比(影响功能内部的基础属性)
-define(PARTIAL_HP_ADD_RATIO,     61).  %% 局部气血增加百分比(影响功能内部的基础属性)
-define(PARTIAL_WRECK_ADD_RATIO,  62).  %% 局部破甲增加百分比(影响功能内部的基础属性)
-define(PARTIAL_DEF_ADD_RATIO,    63).  %% 局部防御增加百分比(影响功能内部的基础属性)
-define(PARTIAL_HIT_ADD_RATIO,    64).  %% 局部命中增加百分比(影响功能内部的基础属性)
-define(PARTIAL_DODGE_ADD_RATIO,  65).  %% 局部闪避增加百分比(影响功能内部的基础属性)
-define(PARTIAL_CRIT_ADD_RATIO,   66).  %% 局部暴击增加百分比(影响功能内部的基础属性)
-define(PARTIAL_TEN_ADD_RATIO,    67).  %% 局部坚韧增加百分比(影响功能内部的基础属性)
-define(PARTIAL_WHOLE_ADD_RATIO,  68).  %% 局部全属性增加百分比(影响功能内部的基础属性)
%% 等级基础
-define(LV_ATT_ADD_RATIO,         69).  %% 等级攻击增加百分比(影响等级基础属性)
-define(LV_HP_ADD_RATIO,          70).  %% 等级气血增加百分比(影响等级基础属性)
-define(LV_WRECK_ADD_RATIO,       71).  %% 等级破甲增加百分比(影响等级基础属性)
-define(LV_DEF_ADD_RATIO,         72).  %% 等级防御增加百分比(影响等级基础属性)
-define(LV_HIT_ADD_RATIO,         73).  %% 等级命中增加百分比(影响等级基础属性)
-define(LV_DODGE_ADD_RATIO,       74).  %% 等级闪避增加百分比(影响等级基础属性)
-define(LV_CRIT_ADD_RATIO,        75).  %% 等级暴击增加百分比(影响等级基础属性)
-define(LV_TEN_ADD_RATIO,         76).  %% 等级坚韧增加百分比(影响等级基础属性)
%% 局部属性2
-define(PARTIAL_ELEM_ATT_ADD_RATIO, 77).    %% 局部元素攻击增加百分比(影响功能内部的基础属性)
-define(PARTIAL_ELEM_DEF_ADD_RATIO, 78).    %% 局部元素防御增加百分比(影响功能内部的基础属性)
%% 其他
-define(NEGLECT_DEF_RATIO,      79).    %% 忽视防御万分比
-define(PVP_HURT_ADD,               80).    %% pvp固定伤害加深
-define(PVP_HURT_DEL,               81).    %% pvp固定伤害减免
-define(PVE_HURT_ADD_RATIO,         82).    %% pve伤害增加万分比
-define(EXP_ADD_RATIO,              83).    %% 经验加成万分比##加经验统一处理
-define(PVP_HURT_ADD_RATIO,         84).    %% pvp伤害增加万分比
-define(PVP_HURT_DEL_RATIO_2,       85).    %% pvp伤害减免万分比
-define(PVP_REBOUND_RATIO,          86).    %% pvp反弹受到伤害万分比

%% buff特殊属性（特殊效果）
-define(SPBUFF_DIZZY,         101). %% 眩晕
-define(SPBUFF_SILENCE,       102). %% 沉默
-define(SPBUFF_IMMOBILIZE,    103). %% 定身:skill
-define(SPBUFF_SHIELD,        104). %% 护盾(时间)
-define(SPBUFF_SHIELDS,       105). %% 护盾(次数)
-define(SPBUFF_IMMUNE,        106). %% 无敌
-define(SPBUFF_UNHURT,        107). %% 免伤
-define(SPBUFF_SUPERARMOR,    108). %% 霸体
-define(SPBUFF_UNSPEED,       109). %% 减速免疫
-define(SPBUFF_UNDIZZY,       110). %% 眩晕免疫
-define(SPBUFF_UNBLEED,       111). %% 流血免疫
-define(SPBUFF_SPRINT,        112). %% 冲刺到敌方锁定目标位置|将敌方锁定目标拉到自己位置
-define(SPBUFF_FIXED_MOVE,    113). %% 移动固定距离
-define(SPBUFF_BLOOD,         114). %% 吸血
-define(SPBUFF_REBOUND,       115). %% 反弹
-define(SPBUFF_RESUME,        116). %% 回血
-define(SPBUFF_BLEED,         117). %% 流血
-define(SPBUFF_CLEAN_BUFF,    118). %% 清除所有buff
-define(SPBUFF_KILL,          119). %% 斩杀
-define(SPBUFF_RATIO_UNHURT,  120). %% 概率免伤
-define(SPBUFF_SLOW,          121). %% 减速
-define(SPBUFF_FIRING,        122). %% 灼烧
-define(SPBUFF_MINUS_CD,      123). %% 减CD
-define(SPBUFF_HP_LIM_HURT,   124). %% 血量伤害上限##Int+血量上限*Float
-define(SPBUFF_UNREUME,       125). %% 禁止回血
-define(SPBUFF_BAN_GOD,       126). %% 禁术天神
-define(SPBUFF_BAN_BLEED,     127). %% 禁术流血
-define(SPBUFF_MISS,          128). %% 躲避触发
-define(SPBUFF_BAN_GOD_TRIGGER, 129).       %% 天神下凡时触发
-define(SPBUFF_BAN_BLEED_TRIGGER, 130).     %% 流血制残时触发
-define(SPBUFF_SKILL,         131). %% 释放技能
-define(SPBUFF_MINUS_FIX_CD,  132). %% 减固定CD
-define(SPBUFF_TALENT_BLEED,  133). %% 天赋流血
-define(SPBUFF_FREE_DIE,      134). %% 免死##会受伤的
-define(SPBUFF_LOCK_HP,       135). %% 固定锁血

-define(SPBUFF_COMBO,          200).  %% 连击buff
% -define(SPBUFF_SKILL_HURT,     202).  %% 技能伤害

%% 特殊写死固定属性
-define(HP_RESUME,             201).  %% 血量恢复
-define(EXP_ADD,               202).  %% 经验加成##建议改成使用83,兼容保留本字段
-define(BOSS_HURT_ADD,         203).  %% 野外BOSS伤害加成(只有人物攻击)
-define(PVEP_HURT_DEL,         204).  %% PVE,PVP伤害减免
-define(PVE_SKILL_HURT,        205).  %% 对怪物伤害技能加深[受到三只怪物以上会加成](只有人物攻击)
-define(PVP_CRIT_ADD_RATIO,    206).  %% 提高暴击几率(只对人物生效, 且血量低于百分之25)
-define(FIRE_ICE_MINUS_CD,     207).  %% 怒火回音/破冰信语减少技能CD,单位是毫秒
-define(FIRE_ICE_ADD_SHIELD,   208).  %% 怒火回音/破冰信语增加护盾值,单位万分比
-define(HOPE_MINUS_CD,         209).  %% 不灭希望减少技能CD/增加被动概率,单位是毫秒
-define(RARE_GOODS_DROP_UP,    210).  %% 珍稀物品（紫色以上）掉率提高百分比

-define(WEAPON_ATT,            221).  %% 武器基础攻击增加百分比
-define(WEAPON_WRECK,          222).  %% 武器基础破甲增加百分比
-define(ARMOR_HP,              223).  %% 防具基础生命增加百分比
-define(ARMOR_DEF,             224).  %% 防具基础防御增加百分比
-define(ORNAMENT_ATT,          225).  %% 仙器基础攻击增加百分比
-define(ORNAMENT_WRECK,        226).  %% 仙器基础破甲增加百分比

%% 特殊属性[属性规则2]
-define(LV_ATT,         300).             %% 等级加攻击
-define(LV_HP,          301).             %% 等级加气血
-define(LV_WRECK,       302).             %% 等级加破甲
-define(LV_DEF,         303).             %% 等级加防御
-define(LV_HIT,         304).             %% 等级加命中
-define(LV_DODGE,       305).             %% 等级加闪避
-define(LV_CRIT,        306).             %% 等级加暴击
-define(LV_TEN,         307).             %% 等级加坚韧
-define(ATTR_ADD_COIN,  308).             %% 铜币增加
-define(ATTR_EQUIP_DROP_UP,   309).       %% 装备掉落概率

-define(MON_HURT_ADD,   310).             %% 增加人物对所有怪物伤害[万分比]
-define(PVP_HURT_DEL_RATIO,   311).       %% pvp减免自身伤害[万分比](只有被人物攻击)
-define(MATE_MON_HURT_ADD, 312).          %% 伙伴对怪物的伤害[万分比]
-define(ACHIV_PVP_HURT_ADD, 313).         %% 成就pvp伤害加成[万分比]

-define(EQUIP_STREN_ADD_RATIO, 314).      %% 装备强化属性增加比率
-define(EQUIP_REFINE_ADD_RATIO, 315).     %% 装备精炼属性增加比率

-define(SKILL_CD_MINUS, 316).           %% 技能cd减少##{316, 技能id, cd减少时间(毫秒)}
-define(SKILL_TRIGGER_PERMIL, 317).     %% 被动技能增加触发概率##{317, 技能id, 增加概率(满值是1000)}
-define(SKILL_SHIELD_HP, 318).          %% 增加血盾##{318, 技能id, 血盾值}
-define(SKILL_BUFF_COUNT, 319).         %% 增加次数##{319, Buffid, 次数}
-define(SKILL_BUFF_FLOAT, 320).         %% 增加小数##{320, Buffid, 万分比}
-define(SKILL_BUFF_PERMIL, 321).        %% 增加概率##{321, Buffid, 万分比概率}
-define(SKILL_BUFF_STACK, 322).         %% 增加层数##{322, Buffid, 增加层数}
-define(SKILL_BUFF_TIME, 323).          %% 增加时间##{322, Buffid, 增加时间(毫秒)}
-define(SKILL_CD_RATIO, 324).           %% 技能cd减少比例##{322, 技能id, 万分比},(固定cd-cd减少)*(1-技能cd万分比)


-define(FASHION_SUIT_POSITION_RATIO, 332).  %% 时装套装外显属性增强##{332， 万分比}


%% ================ 默认值 ================================
-define(SPEED_VALUE, 370).

%% 通用基本属性记录
%% 注意，字段位置要与上面的属性编号相关，即(#attr.att 等于 ?ATT + 1)， 方便使用setelement/3赋值
%% 仅使用在#player_status{}身上，其他地方使用自定义map
-record(attr, {
        %% 基础属性
        att = 0,                    %% 攻击
        hp = 0,                     %% 气血
        wreck  = 0,                 %% 破甲
        def = 0,                    %% 防御
        hit = 0,                    %% 命中
        dodge = 0,                  %% 闪避
        crit = 0,                   %% 暴击
        ten  = 0,                   %% 坚韧
        %% 系数千分比(即:放大了10000倍,计算的时候要除以10000)
        hurt_add_ratio = 0,         %% 伤害加深
        hurt_del_ratio = 0,         %% 伤害减免
        hit_ratio = 0,              %% 命中几率
        dodge_ratio = 0,            %% 闪避几率
        crit_ratio = 0,             %% 暴击几率
        uncrit_ratio = 0,           %% 抗暴几率
        elem_att = 0,               %% 元素攻击
        elem_def = 0,               %% 元素防御
        heart_ratio = 0,            %% 会心几率(伤害的1.2倍)
        speed = 0,                  %% 移动速度
        %% 基础属性增加系数千分比(即:放大了10000倍,计算的时候要除以10000)
        att_add_ratio = 0,          %% 攻击增加百分比
        hp_add_ratio = 0,           %% 气血增加百分比
        wreck_add_ratio  = 0,       %% 破甲增加百分比
        def_add_ratio = 0,          %% 防御增加百分比
        hit_add_ratio = 0,          %% 命中增加百分比
        dodge_add_ratio = 0,        %% 闪避增加百分比
        crit_add_ratio = 0,         %% 暴击增加百分比
        ten_add_ratio = 0,          %% 坚韧增加百分比
        skill_hurt_add_ratio = 0,   %% 技能伤害加深百分比
        skill_hurt_del_ratio = 0,   %% 技能伤害减免百分比
        elem_att_add_ratio = 0,     %% 元素攻击增加百分比
        elem_def_add_ratio = 0,     %% 元素防御增加百分比
        ay_wreck = 0,               %% 暗影穿透
        ay_def = 0,                 %% 暗影耐性
        ss_wreck = 0,               %% 神圣穿透
        ss_def = 0,                 %% 神圣耐性
        hd_wreck = 0,               %% 混沌穿透
        hd_def = 0,                 %% 混沌耐性
        crit_hurt_add_ratio = 0,    %% 暴伤加深百分比
        crit_hurt_del_ratio = 0,    %% 暴伤减免百分比
        parry_ratio = 0,            %% 格挡几率百分比
        overload_ratio = 0,         %% 过载几率(cd重置几率)
        parry = 0,                  %% 招架
        neglect = 0,                %% 忽视
        heart_hurt_add_ratio = 0,   %% 会心伤害
        heart_hurt_del_ratio = 0,   %% 会心免伤
        heart_down_ratio = 0        %% 抗会心几率
        , abs_att = 0               %% 绝对攻击
        , abs_def = 0               %% 绝对防御
        , rebound_ratio = 0         %% 反弹收到伤害万分比
        , pvp_blood_ratio = 0       %% PVP吸取造成伤害万分比
        , draconic_sacred = 0       %% 神圣龙语
        , draconic_tspace = 0       %% 时空龙语
        , draconic_array = 0        %% 法阵龙语
        , exc_ratio = 0             %% 卓越一击几率万分比
        , unexc_ratio = 0           %% 抗卓越一击几率万分比
        , exc_hurt_add_ratio = 0    %% 卓越一击伤害加深万分比
        , exc_hurt_del_ratio = 0    %% 卓越一击伤害减免万分比
        , armor = 0                 %% 护甲
        , undizzy_ratio = 0         %% 抗眩晕万分比
        , speed_add_ratio = 0       %% 移速加成
        %% 局部
        , partial_att_add_ratio = 0 %% 局部攻击增加百分比
        , partial_hp_add_ratio = 0  %% 局部气血增加百分比
        , partial_wreck_add_ratio = 0  %% 局部破甲增加百分比
        , partial_def_add_ratio = 0    %% 局部防御增加百分比
        , partial_hit_add_ratio = 0    %% 局部命中增加百分比
        , partial_dodge_add_ratio = 0  %% 局部闪避增加百分比
        , partial_crit_add_ratio = 0   %% 局部暴击增加百分比
        , partial_ten_add_ratio = 0    %% 局部坚韧增加百分比
        , partial_whole_add_ratio = 0  %% 局部全属性增加百分比
        %% 等级加成
        , lv_att_add_ratio = 0      %% 等级攻击增加百分比
        , lv_hp_add_ratio = 0       %% 等级气血增加百分比
        , lv_wreck_add_ratio = 0    %% 等级破甲增加百分比
        , lv_def_add_ratio = 0      %% 等级防御增加百分比
        , lv_hit_add_ratio = 0      %% 等级命中增加百分比
        , lv_dodge_add_ratio = 0    %% 等级闪避增加百分比
        , lv_crit_add_ratio = 0     %% 等级暴击增加百分比
        , lv_ten_add_ratio = 0      %% 等级坚韧增加百分比
        %% 局部2
        , partial_elem_att_add_ratio = 0    %% 局部元素攻击增加百分比(影响功能内部的基础属性)
        , partial_elem_def_add_ratio = 0    %% 局部元素防御增加百分比(影响功能内部的基础属性)
        %% 其他
        , neglect_def_ratio = 0     %% 忽视防御万分比
        , pvp_hurt_add = 0          %% pvp固定伤害加深
        , pvp_hurt_del = 0          %% pvp固定伤害减免
        , pve_hurt_add_ratio = 0    %% pve伤害增加万分比
        , exp_add_ratio = 0         %% 经验加成万分比
        , pvp_hurt_add_ratio = 0    %% pvp伤害增加万分比
        , pvp_hurt_del_ratio = 0    %% pvp伤害减免万分比
        , pvp_rebound_ratio = 0     %% pvp反弹受到伤害万分比
    }).

%% 战斗通用属性
-record(battle_attr, {
        hp = 200,                   %% 血量
        hp_lim = 200,               %% 血量上限
        anger = 0,                  %% 怒气
        anger_lim = 100,            %% 怒气上限
        energy = 0,                 %% 能量值##根据玩家需求增加能量,用于在玩法中释放技能
        attr = undefined,           %% 属性#attr{}
        sec_attr = #{},             %% 第二套属性
        pk = undefined,             %% #pk{}
        skill_effect = undefined,   %% 技能造成的中间属性 #skill_effect{}
        att_area = 1,               %% 攻击距离(格子)
        speed = ?SPEED_VALUE,       %% 移动速度(默认值)+飞行器修改+坐骑修改
        battle_speed = ?SPEED_VALUE,%% 战斗速度[去掉部分速度,战斗中切换的速度](人物才有效,为了计算减速加速去掉坐骑的速度)
        attr_buff_list = [],        %% 持续属性buff##[{K, BuffType, PerMil, AffectedParties, Int, Float, LastTime, Stack, EffectId}]
        other_buff_list = [],       %% 持续特殊状态buff##[{K, BuffType, PerMil, AffectedParties, Int, Float, LastTime, Stack, EffectId}]
        group = 0,                  %% 战斗分组
        ghost = 0,                  %% 是否幽灵(0:否，1是)
        hide = 0,                   %% 是否隐身(0:否, 1是)
        shield_hp = 0,              %% 血量护盾(血量叠加)
        combat_power = 0,           %% 战斗力
        hp_resume_time = 0,         %% 血量自动回复时间s
        hp_resume_add = 0,          %% 血量回复百分比
        boss_hurt_add = 0,          %% boss伤害加成万分比
        pvpe_hurt_del = 0,          %% 特殊被动伤害减免万分比(PvE,PvP)
        pve_skill_hurt_add = 0,     %% 怪物技能加深伤害万分比
        mon_hurt_add = 0,           %% 增加人物对所有怪物伤害[万分比]
        pvp_hurt_del_ratio = 0,     %% pvp减免自身伤害[万分比]
        mate_mon_hurt_add = 0,      %% 伙伴对怪物的伤害[万分比]
        achiv_pvp_hurt_add = 0,     %% 成就pvp伤害加成[万分比]
        pvp_crit_add_ratio = 0,     %% 血量低于百分之25,pvp提高暴击率
        fire_ice_minus_cd = 0,      %% 怒火回音/破冰信语减少技能CD,单位是毫秒
        fire_ice_add_shield = 0,    %% 怒火回音/破冰信语增加护盾万分比
        hope_minus_cd = 0,          %% 不灭希望减少CD,单位是毫秒
        fire_ref = [],              %% 灼烧定时器s(最多三个)
        bleed_ref = [],             %% 流血定时器
        skill_ref = [],             %% 技能释放定时器
        ban_bleed_list = [],        %% 禁术流血##[#ban_bleed{}]
        sprint_temp_xy = {0, 0}     %% 冲刺坐标参考点,不是最终的冲刺点(怪物和假人使用)
        , total_sec_attr = #{}      %% 汇总第二套属性##总第二套属性=#battle_attr.sec_attr+其他临时属性
        , is_hurt_mon = 1           %% 是否伤害怪物##0:不伤害怪物,1:伤害怪物
    }).


-define(RemovePkValue, 10800).        %% 12小时
-record(pk, {
        pk_status = 0,              %% pk状态
        pk_change_time = 0,         %% 上次切换和平状态的时间戳
        pk_value = 0,               %% 罪恶值
        pk_value_change_time = 0,   %% 罪恶值修改时间
        pk_value_ref = undefined,   %% 罪恶清理定时器
        pk_protect_time = 0         %% pk保护时间
        , protect_time = 0          %% 保护时间##有本结束时间,无法攻击,也无法被攻击
    }).

-record(revive_status, {
        is_revive = 1,              %% 0不能复活 1可以复活
        revive_time = 0             %% 下次复活的时间戳
    }).

%% [属性规则2] sec_attr
%% 备注：针对一些特殊的属性配置 [{Type(类型), Subtype(子类型,参数,任意值), Value(值)}]
%% Subtype：需要服务端定义,在attr.hrl中加上描述,尽量是整数
%% Value：可以扩展成其他格式,不一定是整数。
%% 配置：[{Type, Subtype, Value}]
%% 服务端: 
%%  (1)以#{Type => #{Subtype=>Value}}
%% 客户端：
%%  (1)发给客户端 "[{Type, Subtype, Value}]"

%% 描述
% (1)Subtype 等于等级，即 {Type, Lv, Value}, 计算结果=(玩家等级 div Lv) * Value
% -define(LV_ATT,         300).             %% 等级加攻击
% -define(LV_HP,          301).             %% 等级加气血
% -define(LV_WRECK,       302).             %% 等级加破甲
% -define(LV_DEF,         303).             %% 等级加防御
% -define(LV_HIT,         304).             %% 等级加命中
% -define(LV_DODGE,       305).             %% 等级加闪避
% -define(LV_CRIT,        306).             %% 等级加暴击
% -define(LV_TEN,         307).             %% 等级加坚韧
% (2)Subtype 设置成0，没有意义，即 {{Type, 0}, Value}, 
% -define(ATTR_ADD_COIN,  308).             %% 铜币增加
% -define(ATTR_EQUIP_DROP_UP,   309).       %% 装备掉落概率（10000表示100%）
% (3)技能 Subtype 等于 技能id
% -define(SKILL_CD_MINUS, 316).           %% 技能cd减少##{316, 技能id, cd减少时间}
% -define(SKILL_TRIGGER_PERMIL, 317).     %% 被动技能增加触发概率##{317, 技能id, 增加概率}
% -define(SKILL_SHIELD_HP, 318).          %% 增加血盾##{318, 技能id, 血盾值}


%% 根据通用 [{Key,Value}] 过滤属性, 需要在 lib_sec_player_attr:to_attr_map_help/2 中匹配对应的参数
-define(SEC_ATTR_LIST_FILTER, [
        ?LV_ATT, ?LV_HP, ?LV_WRECK, ?LV_DEF, ?LV_HIT, ?LV_DODGE, ?LV_CRIT, ?LV_TEN, ?ATTR_ADD_COIN,
        ?ATTR_EQUIP_DROP_UP, ?MON_HURT_ADD, ?PVP_HURT_DEL_RATIO, ?MATE_MON_HURT_ADD, ?ACHIV_PVP_HURT_ADD,
        ?SKILL_CD_MINUS, ?SKILL_TRIGGER_PERMIL, ?SKILL_SHIELD_HP
    ]).

%% 等级增加属性
-define(SEC_ATTR_LV_ADD_LIST, [?LV_ATT, ?LV_HP, ?LV_WRECK, ?LV_DEF, ?LV_HIT, ?LV_DODGE, ?LV_CRIT, ?LV_TEN]).