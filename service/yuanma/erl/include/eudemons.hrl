%%-----------------------------------------------------------------------------
%% @Module  :       eudemons.hrl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-11-24
%% @Description:    幻兽
%%-----------------------------------------------------------------------------

-define (COUNTER_TYPE_EXTRA_LOCATION, 1).   %% 终生次数之幻兽槽位开启个数
% -define (DEFAULT_FIGHT_LOCATION_COUNT, 1).  %% 默认幻兽槽位个数
-define (EUDEMONS_STATE_FIGHT, 2).          %% 出战
-define (EUDEMONS_STATE_ACTIVE, 1).         %% 激活（未出战）
-define (EUDEMONS_STATE_SLEEP, 0).          %% 未激活

-record (base_eudemons_item, {
    id,                     %% 幻兽id
    name,                   %% 幻兽名
    base_att,               %% 基础属性
    skill_ids               %% 幻兽技能
    }).

-record (base_eudemons_equip_attr, {
    goods_id,               %% 装备物品id
    star,                   %% 星数
    blue_attr,              %% 蓝属 [{权重,属性}] 属性={属性id,值}
    bule_count,             %% 蓝属数量
    purple_attr,
    purple_count,
    orange_attr,
    orange_count,
    red_attr,
    red_count,
    base_exp                %% 强化基础经验值
    }).

-record (base_eudemons_strength, {
    pos,                %% 部位
    level,              %% 强化等级
    attr,               %% 强化属性
    exp                 %% 所需经验
    }).

-record (base_eudemons_equip_pos, {
    id,                 %% 幻兽id
    pos,                %% 部位
    conditions          %% 装备条件
    }).

-record(base_eudemons_compose,{
        id = 0,         %% 合成id
        material = [],  %% 材料列表 
        cnum = 0,       %% 消耗数量
        reward = [],    %% 合成列表 [{Weight, Gtypeids}...]
        num = 0         %% 合成数量
    }).

-record (eudemons_status, {
    fight_location_count = 0,       %% 出战槽位
    eudemons_list = [],             %% 幻兽列表, #eudemons_item{}
    all_base_attr = [],             %% 模块全基础属性 ?BASE_ATTR_LIST，没有局部属性加成的基础属性 
    total_attr = #{},               %% 全部属性
    passive_skills = []             %% 被动技能
    }).

-record (eudemons_item, {
    id = 0,                             %% 幻兽id
    state = ?EUDEMONS_STATE_SLEEP,      %% 状态 0休眠 1激活 2出战 
    score = 0,                          %% 评分
    equip_list = [],                    %% 装备列表
    equip_attr = []                     %% 装备属性
    }).


