%%%--------------------------------------
%%% @Module  : house.hrl
%%% @Author  : huyihao
%%% @Created : 2018.05.17
%%% @Description:  家园
%%%--------------------------------------

-define(AALimitTime, 12*60*60).
-define(CheckAATime, 60).
-define(HouseFirstTextId, 1770101).
-define(HouseTextLen, 60). %% 默认长度(服务器放宽,1汉字=2单位长度,1数字字母=1单位长度)
-define(DefaultFloorGoodsTypeId, 45050001).
-define(RecommendListLen, 5).
-define(GiftLogMax, 30).
-define(GiftWishWordLen, 60).

-record(house_state, {
    house_list = [],
    aa_list = [],
    check_aa_timer = [],
    answer_list = []
}).

-record(house_status, {
    home_id = {0, 0},        %% {小区id, 房子id},
    house_lv = 0,
    choose_house = {0, 0},
    furniture_attr = [],
    house_attr = []
}).

-record(house_answer_info, {
    ask_role_id = 0,
    answer_role_id = 0,
    type = 0,           %% 类型：1买房子 2升级
    answer_type = 0,    %% 类型：1答应 2拒绝
    home_id = {0, 0},
    house_lv = 0
}).

-record(aa_ask_info, {
    home_id = {0, 0},
    server_id = 0,
    house_lv = 0,
    ask_role_id = 0,
    answer_role_id = 0,
    ask_time = 0,
    type = 0,
    cost_key = "",
    ask_cost_list = [],
    answer_cost_list = []
}).

-record(house_info,{
    home_id = 0,        %% {小区id, 房子id}
    server_id = 0,      %% 服务器id
    role_id_1 = 0,      %% 拥有者1(正在拥有的人)
    name_1 = "",
    role_id_2 = 0,      %% 拥有者2
    name_2 = "",
    lv = 0,             %% 房子等级
    lock = 0,           %% 是否被锁定（锁定后不加属性）0否 1是
    marriage_start_lv = 0,      %% 结婚时房子等级
    furniture_list_1 = [],      %% 家具列表1#furniture_info{}
    furniture_list_2 = [],      %% 家具列表2#furniture_info{}
    inside_list = [],           %% 放置家具数据#furniture_inside_info{}
    cost_log = [],              %% 升级消耗记录 例：{2, [玩家id]}玩家把房子升级到2级花费的玩家id
    buy_time = 0,               %% 购买日期
    if_init_furniture = 0,      %% 是否初始化家具列表（拥有者拜访或查看繁华值显示）玩家1初始化1为1，玩家2初始化为2 全部完成为3
    choose_house = {0, 0},      %% 选择房子
    text = "",                  %% 房子留言
    popularity = 0,             %% 人气值
    gift_log_list = [],             %% 获得礼物列表
    if_sql = 0                  %% 是否需存盘 0否 1是
}).

-record(furniture_info, {
    role_id = 0,
    goods_id = 0,           %% 默认地板为0
    goods_type_id = 0,
    goods_num = 0,
    put_num = 0
}).

-record(furniture_inside_info, {
    loc_id = 0,
    goods_id = 0,
    goods_type_id = 0,
    x = 0,
    y = 0,
    face = 0,
    map_id = 0
}).

-record(house_gift_log_info, {
    role_id = 0,
    gift_id = 0,
    wish_word = "",
    time = 0
}).

-record(house_location_con, {
    block_id = 0,
    house_id = 0,
    location = 0
}).

-record(house_lv_con, {
    house_lv = 0,
    house_name = "",
    scene_id = 0,
    attr_list = [],
    need_point = 0,
    point = 0,
    cost_list = [],
    resource = "",
    up_res = ""
}).

-record(house_furniture_con, {
    goods_type_id = 0,
    furniture_name = "",
    furniture_type = 0,
    point = 0,
    attr_list = [],
    map_id = 0,
    max_num = 0,
    logo = "",
    area = "",
    offset_x = "",
    offset_y = "",
    offset_h = "",
    text = ""
}).

-record(house_block_con, {
    block_id = 0,
    block_name = "",
    block_introduce = "",
    open_num = 0,
    location = 0,
    resource = "",
    logo = ""
}).

-record(house_theme_con, {
    theme_id = 0,
    theme_name = "",
    furniture_id_list = []
}).

-record(house_gift_con, {
    gift_id = 0,
    goods_list = [],
    add_fame = 0,
    add_intimacy = 0,
    add_popularity = 0,
    daily_max = 0,
    counter_id = 0,
    wish_word = "",
    se_name = "",
    if_send_tv = 0
}).

-define(SelectHouseInfoAllSql,
    <<"SELECT `block_id`, `house_id`, `server_id`, `role_id_1`, `role_id_2`, `lv`, `lock`, `marrige_start_lv`, `choose_block_id`, `choose_house_id`, `cost_log`, `text`, `buy_time`, `popularity` FROM `house_info`">>).
-define(SelectHouseInfoSql,
    <<"SELECT `block_id`, `house_id`, `server_id`, `lv`, `lock` FROM `house_info` WHERE `role_id_1` = ~p or `role_id_2` = ~p">>).
-define(ReplaceHouseInfoAllSql,
    <<"REPLACE INTO `house_info` (`block_id`, `house_id`, `server_id`, `role_id_1`, `role_id_2`, `lv`, `lock`, `marrige_start_lv`, `choose_block_id`, `choose_house_id`, `cost_log`, `text`, `buy_time`, `popularity`) VALUES ~s">>).
-define(DeleteHouseInfoSql,
    <<"DELETE FROM `house_info` WHERE `block_id` = ~p and `house_id` = ~p and `server_id` = ~p">>).
-define(DeleteHouseInfoAllSql,
    <<"DELETE FROM `house_info` WHERE ~s">>).

-define(SelectHouseFurnitureLocAllSql,
    <<"SELECT `loc_id`, `block_id`, `house_id`, `goods_id`, `goods_type_id`, `x`, `y`, `face`, `map_id` FROM `house_furniture_location`">>).
-define(ReplaceHouseFurnitureLocAllSql,
    <<"REPLACE INTO `house_furniture_location` (`loc_id`, `block_id`, `house_id`, `goods_id`, `goods_type_id`, `x`, `y`, `face`, `map_id`) VALUES ~s">>).
-define(DeleteHouseFurnitureLocSql,
    <<"DELETE FROM `house_furniture_location` WHERE `loc_id` = ~p ">>).
-define(DeleteHouseFurnitureLocAllSql,
    <<"DELETE FROM `house_furniture_location` WHERE `loc_id` IN (~s) ">>).

-define(SelectHouseHouseAAInfoAllSql,
    <<"SELECT `block_id`, `house_id`, `server_id`, `house_lv`, `ask_role_id`, `answer_role_id`, `ask_time`, `type`, `cost_key`, `ask_cost_list`, `answer_cost_list` FROM `house_aa_info`">>).
-define(ReplaceHouseHouseAAInfoSql,
    <<"REPLACE INTO `house_aa_info` (`block_id`, `house_id`, `server_id`, `house_lv`, `ask_role_id`, `answer_role_id`, `ask_time`, `type`, `cost_key`, `ask_cost_list`, `answer_cost_list`) VALUES (~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', '~s', '~s')">>).
-define(DeleteHouseHouseAAInfoSql,
    <<"DELETE FROM `house_aa_info` WHERE ~s">>).