%% 颜色
-define(FASHION_WHITE,              0). % 落雪白
-define(FASHION_RED,                1). % 喜庆红
-define(FASHION_ORANGE,             2). % 果粒橙
-define(FASHION_YELLOW,             3). % 无忧黄
-define(FASHION_BALCK,              4). % 五十度黑
-define(FASHION_GOLD,               5). % 土豪金

%% 使用状态
-define(UN_USED,           0). % 未使用
-define(USED,              1). % 使用中

%% 位置
-define(POS_CLOTH,          1).     % 衣服
-define(POS_WEAPON,         2).     % 武器
-define(POS_HEAD,           3).     % 头部
-define(POS_FOOT,           4).     % 足部

-define(SUIT_POST_FASHION,     1).   % 时装
-define(SUIT_POST_MOUNT,       2).   % 幻化

-define(OpenLv, 1).

-record(fashion_suit,{
    suit_data = []          %% 套装激活情况 #fashion_suit_data{}
    , attr = []             %% 属性
    , skill = []            %% 技能
}).

-record(fashion, {
    position_list = []
    , suit_list = #fashion_suit{}
}).

-record(fashion_suit_data, {
    id = 0
    , lv = 0
    , active_num = 0       %% 已激活套装位置数量
    , conform_num = 0      %% 可激活套装数量
}).


-record(fashion_pos,{
    pos_id = 0,
    pos_lv = 0,
    pos_upgrade_num = 0,
    wear_fashion_id = 0,
    wear_color_id = 0,
    fashion_list = []
}).

-record(fashion_info, {
    pos_id = 0,
    fashion_id = 0,
    color_id = 0,
    fashion_star_lv = 0,
    color_list = []        % 玩家在该时装所拥有的颜色与对应星数的映射[{color_id, star_lv}]
}).

%% base_fashion
%% 时装的升星消耗属性配置
-record(fashion_con, {
    pos_id = 0,
    fashion_id = 0,
    star_lv = 0,
    active_cost = [],
    star_cost = [],
    attr_list = [],
    power = 0
}).

%% base_fashion_pos
%% 时装的部位强化消耗属性配置
-record(fashion_pos_con, {
    pos_id = 0,
    pos_lv = 0,
    cost = 0,
    attr_add_list = []
}).

%% base_fashion_color
%% 时装染色配置
-record(fashion_color_con, {
    pos_id = 0,
    fashion_id = 0,
    color_id = 0,
    star_lv = 0,
    active_cost = [],
    star_cost = [],
    attr_list = []
}).

%% base_fashion_model
%% 时装吞噬经验配置
-record(fashion_model_con, {
    pos_id = 0,
    name = "",
    fashion_id = 0,
    color_id = 0,
    show_color = 0,
    career = 0,
    sex = 0,
    model_id = 0,
    exp = 0                 %% 吞噬经验
}).

-record(fashion_resolve_con, {
    goods_type_id = 0,
    pos_id = 0,
    pos_upgrade_num = 0
}).

%% base_fashion_color_logo
-record(fashion_color_logo_con, {
    pos_id = 0,
    fashion_id = 0,
    sex = 0,
    fashion_name = "",
    color_list = []
}).

-record(base_fashion_suit, {
    id = 0
    , name = ""
    , condition = []
    , attr = []
    , skill = []
    , ratio = ""
}).

-record(base_fashion_suit_star, {
    suit_id = 0
    , star_id = 0
    , attr = []
    , skill = []
    , condition = []
    , desc = ""
    , cost = []
}).

-define(ReplaceFashionPosSql, <<"REPLACE INTO `fashion_pos` (`role_id`, `pos_id`, `pos_lv`, `pos_upgrade_num`, `wear_fashion_id`, `wear_color_id`) VALUES (~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(ReplaceFashionPosAllSql, <<"REPLACE INTO `fashion_pos` (`role_id`, `pos_id`, `pos_lv`, `pos_upgrade_num`, `wear_fashion_id`, `wear_color_id`) VALUES ~s">>).

-define(SelectFashionPosSql, <<"SELECT `role_id`, `pos_id`, `pos_lv`, `pos_upgrade_num`, `wear_fashion_id`, `wear_color_id` FROM `fashion_pos` WHERE `role_id` = ~p">>).

-define(ReplaceFahsionInfoSql, <<"REPLACE INTO `fashion_info` (`role_id`, `pos_id`, `fashion_id`, `color_id`, `color_list`, `fashion_star_lv`) VALUES (~p, ~p, ~p, ~p, '~s', ~p)">>).

-define(ReplaceFahsionInfoAllSql, <<"REPLACE INTO `fashion_info` (`role_id`, `pos_id`, `fashion_id`, `color_id`, `color_list`, `fashion_star_lv`) VALUES ~s">>).

-define(SelectFashionInfoSql, <<"SELECT `role_id`, `pos_id`, `fashion_id`, `color_id`, `color_list`, `fashion_star_lv` FROM `fashion_info` WHERE `role_id` = ~p">>).

-define(SelectFashionSuitSql, <<"SELECT `suit_id`, `lv`, `active_num` FROM `role_fashion_suit` WHERE `role_id` = ~p">>).

-define(ReplaceFashionSuitSql, <<"REPLACE INTO `role_fashion_suit` (`role_id`, `suit_id`, `lv`, `active_num`) VALUES (~p, ~p, ~p, ~p)">>).