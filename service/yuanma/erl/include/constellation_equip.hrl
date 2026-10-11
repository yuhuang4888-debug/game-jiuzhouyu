%% ---------------------------------------------------------------------------
%% @doc constellation_equip
%% @author  
%% @email   
%% @since   2019/11/4
%% @deprecated  头文件
%% ---------------------------------------------------------------------------

-record(base_constellation_equip, {
        goods_id = 0,               %% 物品类型id
        compose_info = 0,           %% 合成成功率(提供进化点数)
        extra_attr = [],            %% 卓越属性
        extra_list = [],            %% 词缀属性 [{Attr, Value, 词缀id}]
        page = 0,                   %% 装备页
        is_suit = 0,                %% 是否可以激活套装
        decompose_exp = 0,          %% 吞噬获得经验
        extra_base_attr = []        %% 极品属性
    }).

-record(base_constellation_page, {
        page = 0,                   %% 装备页id
        condition = [],             %% 解锁条件  1. {constellation_num, ConstellationId, Num, Color} 
                                            %   2. {evolution_lv, ConstellationId, Level}
                                            %   3. {strength_lv,ConstellationId,  Level}
        normal_suit_attr = [],      %% 普通套装属性 [{穿戴数量,效果类型,值}...]   效果类型1:属性 2:技能
        normal_name = "",           %% 普通套装名
        special_suit_attr = []      %% 特殊套装属性 [{穿戴数量,效果类型,值}...]   效果类型1:属性 2:技能
        ,special_name = ""          %% 特殊套装名
    }).

-record(base_equip_star,   {
        id = 0,                     %% id
        star = 0,                   %% 星数
        attr = []                   %% 属性
    }).

-record(base_attr_desgt, {
        id = 0,                     %% 词缀id
        suit_attr = []              %% 套装属性
    }).

-record(base_constellation_decompose, {
        lv = 0,                     %% 吞噬等级
        exp = 0,                    %% 所需经验
        attr = []                   %% 总属性
    }). 

-record(base_constellation_compose, {
        id = 0,                     %% 合成id
        condition = [],             %% 条件
        regular_mat = [],           %% 固定材料 [{Type, GoodsTypeId, Num}]
        irregular_mat = [],         %% 不固定材料 [GoodsTypeId...]
        cost = [],                  %% 合成消耗 [{Type, GoodsTypeId, Num}]
        goods = [],                 %% 合成物品 [{normal, [{GoodsTypeId, Num}]}, {special, X, [{Gt, N}]} normal:正常合成奖励;special:每X次合成给予的奖励
        fail_goods = [],            %% 失败奖励 [{Type, GoodsTypeId, Num}]
        ratio_type = 0,             %% 概率类型 1 固定/ 2随机
        ratio = [],                 %% 概率 Weight / [{Num, Weight}...]
        bind_type = 0,              %% 绑定类型
        tv_type = 0                 %% 传闻
    }).

-define(NORMAL_SUIT,    1).         %% 普通套装
-define(SPECIAL_SUIT,   2).         %% 首饰套装

-define(ATTR,  1).                  %% 属性
-define(SKILL, 2).                  %% 技能

-define(UNACTIVE,     0).           %% 未激活
-define(ACTIVE,       1).           %% 激活

-define(COMPOSE_RATOP_TYPE_REGULAR, 1).%% 固定
-define(COMPOSE_RATOP_TYPE_RANG,    2).%% 随机

-record(constellation_status, {
        constellation_list = [],        %% 星宿列表
        total_attr = [],                %% 全部属性
        passive_skills = [],            %% 被动技能
        attr_star = undefined,          %% 星级大师
        decompose = undefined           %% 星宿装备吞噬
        ,compose = []                   %% 合成状态
    }).

-record(constellation_item, {
        id = 0,                             %% 星座id
        power = 0,                          %% 战力
        equip_attr = [],                    %% 装备基础属性+卓越属性汇总
        suit_attr = [],                     %% 套装属性
        dsgt_attr = [],                     %% 词缀属性汇总
        dsgt_suit_attr = [],                %% 词缀套装属性
        dsgt_suit = [],                     %% 词缀套装
        passive_skills = [],                %% 被动技能
        suit = [],                          %% 套装 [{Type, Num}...]
        pos_equip = [],                     %% 部位装备列表 [{pos, GoodsAutoId}]
        all_attr = [],                      %% 属性汇总 包含技能属性
        star = 0,                           %% 星数
        is_active = 0,                      %% 是否激活

        equip_list = [],                    %% 装备其他属性 #constellation_forge{}
        strength_attr = [],                 %强化属性
        evolution_attr = [],                %进化属性
        enchantment_attr = [],              %附魔属性
        spirit_attr = [],                   %启灵属性
        strength_master = [],               %% 强化大师状态[{lv, status}|...]
        strength_master_attr = [],          %% 强化大师附加属性
        strength_buff = 0,                  %% 强化加成状态
        strength_buff_attr = [],            %% 强化加成附加属性
        enchantment_master = [],            %% 强化大师状态[{lv, status}|...]
        enchantment_master_attr = []        %% 附魔大师附加属性
    }).

-record(decompose_status, {
        lv = 0,                             %% 吞噬等级
        exp = 0,                            %% 当前等级经验
        star = 0,                           %% 吞噬选择星数
        color = 0,                          %% 吞噬选择颜色
        power = 0                           %% 战力
    }).

-record(attr_star, {
        power = 0,                          %% 战力
        star_level = 0,                     %% 星级大师 当前等级
        max_level = 0,                      %% 历史最高等级
        star = 0                            %% 总星数
    }).

-define(SQL_SELECT_CONSTELLATION, <<"SELECT constellation, status FROM role_constellation_status where role_id = ~p">>).
-define(SQL_INSERT_CONSTELLATION, <<"INSERT INTO role_constellation_status (role_id, constellation, status) values (~p,~p,~p)">>).

-define(SQL_SELECT_CONSTELLATION_DECOMPOSE, <<"SELECT color, star, level, exp, max_level, star_level FROM role_constellation_decompose where role_id = ~p">>).
-define(SQL_REPLACE_CONSTELLATION_DECOMPOSE, <<"REPLACE INTO role_constellation_decompose (role_id, color, star, level, exp, max_level, star_level) 
            values (~p,~p,~p,~p,~p,~p,~p)">>).

-define(SQL_SELECT_COMPOSE,  <<"SELECT compose from role_constellation_compose where role_id = ~p">>).
-define(SQL_REPLACE_COMPOSE, <<"REPLACE INTO role_constellation_compose (role_id, compose) values (~p,'~s')">>).
