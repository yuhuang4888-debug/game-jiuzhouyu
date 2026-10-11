%% ---------------------------------------------------------------------------
%% @doc constellation_forge

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/4
%% @deprecated  
%% ---------------------------------------------------------------------------
-define(CONSTELLATION_KV(Key), data_constellation_forge:get(Key)).
-define(STRENGTH_LV, ?CONSTELLATION_KV(1)).     %%强化开放等级
-define(EVOLUTION_LV, ?CONSTELLATION_KV(2)).    %%进化开发等级
-define(ENCHANTMENT_LV, ?CONSTELLATION_KV(3)).  %%附魔开放等级
-define(EVOLUTION_PERCENT_NEED_NUM, ?CONSTELLATION_KV(4)). %%进化装备卓越属性所需条数
-define(SPIRIT_LV, ?CONSTELLATION_KV(5)).       %%启灵开放等级
-define(NEED_PERCENT_ATTRS, ?CONSTELLATION_KV(10)).%%需要百分比加成的属性

-define(MASTER_NOACT,               0).         %% （强化/附魔）大师未激活
-define(MASTER_ACTIVE,              1).         %% （强化/附魔）大师可点亮
-define(MASTER_ACTIVED,             2).         %% （强化/附魔）大师已点亮

-define(EVOLUTION_FAIL,             0).         %% 进化失败
-define(EVOLUTION_SUCCESS,          1).         %% 进化成功

-define(NOT_AUTO,                   0).         %% 非自动购买
-define(AUTO_BUY,                   1).         %% 自动购买

-define(NO_SPIRIT,                  0).         %% 未启灵
-define(IS_SPIRIT,                  1).         %% 已启灵

-define(STRENGTH_OP,                1).         %% 强化操作
-define(ENCHANTMENT_OP,             2).         %% 附魔操作
-define(SPIRIT_OP,                  3).         %% 启灵

-define(STRENGTH_PERCENT_ATTR,      325).         %%星宿强化总属性百分比
-define(EVOLUTION_PERCENT_ATTR,     326).         %%星宿进化总属性百分比

-record(constellation_forge, {
    equip_id = 0,            %装备id
    pos = 0,                 %位置
    strength_lv = 0,         %强化等级
    strength_attr = [],      %强化属性
    evolution_lv = 0,        %进化等级
    evolution_attr = [],     %进化属性
    enchantment_lv = 0,      %附魔等级
    enchantment_attr = [],   %附魔属性
    is_spirit = 0,           %是否启灵
    spirit_attr = []         %启灵属性
}).


%% 强化配置
-record(base_constellation_strength, {
    equip_type = 0,
    pos = 0,
    lv = 0,
    cost = [],      %升到下一级所需要消耗的材料
    attr = [],
    special_attr = []   %特殊属性
}).

%% 强化大师配置
-record(base_constellation_strength_master, {
    equip_type = 0,
    lv = 0,
    satisfy_status = [],    %部位满足强化N级条件
    attr = []
}).

%% 进化配置
-record(base_constellation_evolution, {
    equip_type = 0,
    pos = 0,
    lv = 0,
    ev_point = 0, %dianshu 
    rate = 0,
    cost = [],      %升到下一级所需要消耗的材料
    attr = []
}).

%% 进化属性池子配置
-record(base_constellation_evolution_pool, {
    equip_type = 0,
    pos = 0,
    attr_pool = []      %% {}
}).

%% 附魔配置
-record(base_constellation_enchantment, {
    equip_type = 0,
    pos = 0,
    lv = 0,
    cost = [],      %升到下一级所需要消耗的材料
    attr = []
}).

%% 附魔大师配置
-record(base_constellation_enchantment_master, {
    equip_type = 0,
    lv = 0,
    satisfy_status = [],    %部位满足强化N级条件
    attr = []
}).

%% 启灵配置
-record(base_constellation_spirit, {
    equip_type = 0,
    pos = 0,
    cost = [],      %所需要消耗的材料
    attr = []
}).
