
-define(decompose_key, 1670000). %%全局kv  分解系数

-define(awake_color_limit, 4).   %%觉醒品质限定

-define(rune_skill_id, 7000001).   %%觉醒品质限定

-define(special_rune_sub_type, [26, 27]).


-record(rune, {
    rune_point = 0,                     %% 符文经验
    rune_chip = 0,                      %% 符文碎片
    equip_add_ratio_attr = []           %% 对装备加成的百分比属性
    ,skill_lv = 0                       %% 技能等级
    ,power     = 0                      %% 总战力
    ,skill = []                         %% 技能列表 [{skill_id, lv}]
    ,skill_attr = []                    %% 技能属性
}).

-record(rune_pos_con, {
    rune_pos = 0,
    condition = []
}).

-record(rune_exchange_con, {
    id = 0,
    goods_list = [],            %%符文列表
    rune_chip_num = 0,          %%所需符文碎片数量
    condition = []              %%爬塔层数条件
}).

-record(rune_attr_num_con, {
    sub_type = 0,              %%子类型
    lv= 0,                     %%等级
    attr_num_list = [],        %%属性列表
    lv_up_num= 0               %%升级经验值
}).

-record(rune_attr_coefficient_con, {
    sub_type = 0,
    quality= 0,
    attr_coefficient_list = [],
    lv_up_coefficient = 0
}).

-record(wear_rune_skill, {
    sub_type = 0,              %% 子类型
    skill_id = 0,               %% 技能id
    attr_id = 0                 %% 属性id
}).

-define(ReplaceRuneSql,
    <<"replace into `rune_player` (`role_id`, `rune_point`, `rune_chip`, `skill_lv`) values (~p, ~p, ~p, ~p)">>).

-define(ReplaceRuneSkillSql,
    <<"replace into `rune_player` (`role_id`, `rune_point`, `rune_chip`, `skill_lv`, `awake_skill`) values (~p, ~p, ~p, ~p, '~s')">>).

-define(SelectRuneSql,
    <<"select `role_id`, `rune_point`, `rune_chip`, `skill_lv`, `awake_skill` from `rune_player` WHERE `role_id` = ~p">>).