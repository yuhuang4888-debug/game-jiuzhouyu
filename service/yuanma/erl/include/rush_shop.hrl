%% ---------------------------------------------------------------------------
%% @doc 抢购商城头文件.
%% @author zhaoyu
%% @since  2014-07-08
%% @update by ningguoqiang 2015-07-14
%% @update by wuhao 2019-03-01
%% ---------------------------------------------------------------------------

-define(RUSH_SHOP_BUY_LOG_SELECT, "SELECT `id`, `daily_times`, `time` from `player_rush_shop_buy_log` where `player_id`= '~w'").
-define(RUSH_SHOP_BUY_LOG_REPLACE_INTO, "REPLACE INTO `player_rush_shop_buy_log` (`player_id`, `id`, `daily_times`, `time`) values ('~w', '~w', '~w', '~w')").
-define(RUSH_SHOP_BUY_LOG_DELETE, "DELETE FROM `player_rush_shop_buy_log` WHERE `id` = '~w'").

-define(RUSH_SHOP_SELECT, <<"SELECT `id`, `sell_num`, `time` from `rush_shop`">>).
-define(RUSH_SHOP_REPLACE_INTO, "REPLACE INTO `rush_shop` (`id`, `sell_num`, `time`) values ('~w', '~w', '~w')").
-define(RUSH_SHOP_DELETE, "DELETE FROM `rush_shop` WHERE `id` = '~w'").

%% 抢购商城的物品配置
-record(rush_shop_goods, {
        id = 0                  %% 商品id
        ,goods_id = 0           %% 出售道具的ID
        ,default_num = 0        %% 默认购买数量
        ,price_type = gold      %% 价格类型：gold元宝、coin铜钱
        ,price = 0              %% 原价
        ,limit_price = 0        %% 抢购价
        ,refresh = 0            %% 是否重置每日出售数量 1:是
        ,daily_limit_num = 0    %% 玩家每日限购数量
        ,total_limit_num = 0    %% 全服限购数量
        ,open_begin = 0         %% 开服时段开始天数
        ,open_end = 0           %% 开服时段结束天数
        ,merge_begin = 0        %% 合服时段开始天数
        ,merge_end = 0          %% 合服时段结束天数
        ,act_begin = 0          %% 活动开始时间
        ,act_end = 0            %% 活动结束时间
        ,open_switch = 0        %% 开服的开关（1:开,0:关） - 如果是开服,且开,就用[open_begin,open_end,start_time,end_time]
        ,merge_switch = 0       %% 合服的开关（1:开,0:关） - 如果是合服,且开,就用[merge_begin,merge_end,start_time,end_time]
        ,expire_time = 0        %% 物品有效时间。为0时不是限时物品
}).

%% 抢购商城信息
-record(rush_shop, {
    selling = []                %% 上架商品信息
    ,wait = []                  %% 待上架商品
    ,add_timer = 0              %% 下一波商品上架定时器
    ,del_timer = 0              %% 下一波商品下架定时器
    ,refresh_timer = 0          %% 更新定时器
    ,old_records = []           %% 旧记录
    ,check_timer = 0            %% 检测定时器
    }).


%% 结构配置
-record(rush_info, {
    type = 0,                       %% 活动主类型
    subtype = 0,                    %% 活动子类型
    show_id = 0,                    %% 展示id
    name = "",                      %% 活动名字
    desc = "",                      %% 活动描述
    open_start_time = 0,            %% 服开始时间戳##闭区间
    open_end_time = 0,              %% 服结束时间戳##闭区间
    is_open = 0,                    %% 总开关标志位（1:开,0:关） - 无效开关
    open_switch = 0,                %% 开服的开关（1:开,0:关） - 如果是开服,且开,就用[open_begin,open_end,start_time,end_time]
    open_begin = 0,                 %% 开服时段开始天数
    open_end = 0,                   %% 开服时段结束天数
    merge_switch = 0,               %% 合服的开关（1:开,0:关） - 如果是合服,且开,就用[merge_begin,merge_end,start_time,end_time]
    merge_begin = 0,                %% 合服时段开始天数
    merge_end = 0,                  %% 合服时段结束天数
    act_time_switch = 0,            %% 活动时间的开关（1:开,0:关） - 无效开关
    start_time = 0,                 %% 活动开始时间
    end_time = 0,                   %% 活动结束时间
    condition = [],                 %% 条件 ,见 lib_custom_act_util底部
    clear_rule = []                 %% 清理规则 [{three_clock, Value(1:清理,0:不清理)}|{zero_clock, Value(1:清理,0:不清理)}]
}).