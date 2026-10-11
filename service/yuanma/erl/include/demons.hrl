%% 使魔

%%%%%%%%%%%%%%%%%%%%%%%%%%% 键值
-define(demons_open_lv, data_demons:get_key(1)).    %% 使魔开启等级
-define(upgrade_demons_goods, data_demons:get_key(2)).  %% 使魔升级道具
-define(painting_star, data_demons:get_key(3)).     %% 上卷星数
-define(demons_skill_cd, data_demons:get_key(4)).   %% 使魔技能cd
-define(demons_id_free, data_demons:get_key(5)).    %% 免费使魔id
-define(shop_cost, data_demons:get_key(6)).         %% 商城刷新消耗
-define(shop_num, data_demons:get_key(8)).          %% 商城刷新商品数量
-define(skill_slot_unlock3, data_demons:get_key(10)). %% 槽位解锁条件

%%%%%%%%%%%%%%%%%%%%%%%%%%%  使魔属性分类
-define(ATTR_TYPE_DEMONS, 1).       %% 使魔自身属性
-define(ATTR_TYPE_FETTERS, 2).      %% 羁绊属性
-define(ATTR_TYPE_SKILL, 3).        %% 技能属性
-define(ATTR_TYPE_PAINTING, 4).     %% 上卷属性
-define(ATTR_TYPE_SLOT_SKILL, 5).   %% 天赋技能

%%%%%%%%%%%%%%%%%%%%%%%%%%%  使魔技能分类
-define(DEMONS_SKILL_TYPE_LIFE, 1).  %% 生活技能
-define(DEMONS_SKILL_TYPE_BATTLE, 2).  %% 战斗
-define(DEMONS_SKILL_TYPE_PASSIVE, 3).  %% 被动

%%%%%%%%%%%%%%%%%%%%%%%%%% 使魔天赋技能
-define(DEMONS_SLOT_BEGIN,      1).     %% 初始槽位数量

%%%%%%%%%%%%%%%%%%%%%%%%%%%  sql
%% 使魔信息
-define(sql_select_demons_all, 
	<<"SELECT demons_id, level, exp, star, slot_num FROM `role_demons` where `role_id` = ~p ">>).  %% 
-define(sql_replace_demons, 
	<<"replace into `role_demons` (`role_id`, `demons_id`, `level`, `exp`, `star`, `slot_num`) 
	values (~p, ~p, ~p, ~p, ~p, ~p)">>).  %% 
-define(sql_update_demons_level, 
	<<"update `role_demons` set `level`=~p, `exp`=~p where `role_id` = ~p and `demons_id` = ~p ">>).  %% 
-define(sql_update_demons_star, 
	<<"update `role_demons` set `star`=~p where `role_id` = ~p and `demons_id` = ~p ">>).  %% 
-define(sql_update_demons_battle_state, 
	<<"update `role_demons` set `in_battle`=~p where `role_id` = ~p and `demons_id` = ~p ">>).  %% 

-define(sql_select_demons_role_msg, 
	<<"SELECT demons_id, painting_list FROM `role_demons_msg` where `role_id` = ~p ">>).  %% 
-define(sql_replace_demons_role_msg, 
	<<"replace into `role_demons_msg` (`role_id`, `demons_id`, `painting_list`) 
	values (~p, ~p, '~s')">>).  %% 

%% 使魔技能
-define(sql_select_demons_skill, 
    <<"SELECT demons_id, skill_id, level, process, is_active FROM `role_demons_skill` where `role_id` = ~p ">>).  %% 
-define(sql_replace_demons_skill, 
    <<"replace into `role_demons_skill` (`role_id`, `demons_id`, `skill_id`, `level`, `process`, `is_active`) 
    values (~p, ~p, ~p, ~p, ~p, ~p)">>).  %% 

-define(sql_select_demons_slot,
    <<"SELECT demons_id, skill_id, slot, level FROM `demons_slot_skill` where `role_id` = ~p">>).
-define(sql_replace_demons_slot, 
    <<"replace into `demons_slot_skill` (`role_id`, `demons_id`, `skill_id`, `slot`, `level`) values (~p, ~p, ~p, ~p, ~p)">>). 
-define(sql_delete_demons_slot, 
    <<"delete from `demons_slot_skill` where `role_id` = ~p and `demons_id` = ~p and `skill_id` = ~p">>). 

-define(sql_select_demons_shop,
    <<"SELECT refresh_times, shop, stime FROM `demons_shop` where `role_id` = ~p">>).
-define(sql_replace_demons_shop,
    <<"replace into `demons_shop` (`role_id`, `refresh_times`, `shop`, `stime`) values (~p, ~p, '~s', ~p)">>). 

-record(status_demons, {
    demons_id = 0      %% 上阵使魔id
    , painting_list = []
    , painting_num = 0
    , demons_list = []  %% 使魔列表 #demons{}
    , fetters_list = [] %% 羁绊
    , attr_list = []
    , total_attr = []
    , skill_power = 0
    , skill_passive = []  %% 作用于玩家的被动技能列表
    , slot_skill = []   %% 所有天赋技能[id, lv]
    , slot_skill_power = 0 %% 部分无法计算技能战力
    , skill_use_time = 0
    , demons_shop = undefined
}).

-record(demons, {
    demons_id = 0      %% 上阵使魔id
    , level = 0
    , exp = 0
    , star = 0
    , skill_list = []
    , attr_list = []
    , power = 0
    , skill_for_demons = [] %% 归属使魔的技能
    , skill_for_role = []   %% 归属玩家的技能
    , slot_list = []        %% 天赋技能 #slot_skill
    , slot_num = 0          %% 已解锁槽位数量
}).

-record(demons_skill, {
    skill_id = 0      %% 技能id
    , level = 0
    , sk_type = 0
    , process = 0     %% 技能进度(生活技能)
    , is_active = 1   %% 是否激活(默认已激活)
}).

-record(slot_skill, {
        skill_id = 0        %% 技能id
        , slot = 0          %% 槽位
        , level = 0         %% 等级
        , quality = 0       %% 品质
        , sort = 0          %% 种类  
    }).

-record(demons_shop, {
        refresh_times = 0   %% 刷新次数
        , stime = 0         %% 上次刷新时间
        , goods = []        %% {id, buy_times}
        , is_dirty = 0      %% 是否脏数据
    }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 配置
-record(base_demons, {
    demons_id = 0      %% 上阵使魔id
    , demons_name = ""
    , realm = 0
    , color = 0
    , cost = []
    , fetters = []
    , froms = ""
    , jump_id = 0
    , resource = 0
}).

-record(base_demons_level, {
    demons_id = 0      %% 上阵使魔id
    , level = 0
    , exp = 0
    , attr = []
}).

-record(base_demons_star, {
    demons_id = 0      %% 上阵使魔id
    , star = 0
    , cost = []
    , attr = []
}).

-record(base_demons_skill, {
    demons_id = 0      %% 上阵使魔id
    , skill_id = 0
    , unlock_star = 0   %% 解锁星数
    , sk_type = 0       %% 类型 生活/战斗/其他
    , usage = []        %% 额外配置
}).

-record(base_demons_skill_upgrade, {
    skill_id = 0
    , level = 0   %% 技能等级
    , cost = []   %% 消耗
    , usage = []        %% 用途
}).

-record(base_demons_skill_map, {
    skill_id = 0
    , skill_follow = 0   %% 使魔跟随时生效的技能
    , skill_unfollow = 0   %% 不跟随时生效的技能
}).

-record(base_demons_fetters, {
    fetters_id = 0      %% 羁绊id
    , fetters_name = ""
    , demons_ids = []   %% 使魔列表
    , attr = []       %% 效果
    , desc = ""        %% 
}).

-record(base_demons_painting, {
    painting_id = 0      %% 羁绊id
    , painting_num = 0
    , attr = []       %% 效果
    , reward = []        %% 
}).

-record(base_demons_skill_add, {
        skill_id = 0,       %% 技能id
        goods_id = 0,       %% 物品类型id
        quality = 0,        %% 品质
        sort = 0            %% 种类
    }).

-record(base_demons_shop, {
        id = 0,             %% 商品id
        min_times = 0,      %% 刷新次数下限
        max_times = 0,      %% 刷新次数上限
        goods_id = 0,       %% 物品类型id
        num = 0,            %% 数量
        price = 0,          %% 价格类型
        cost_num = 0,       %% 原价
        discount = 0,       %% 折扣（9折=90）
        weight = 0          %% 权重
    }).
  