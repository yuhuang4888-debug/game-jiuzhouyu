%% ---------------------------------------------------------------------------
%% @doc god_court

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/28
%% @deprecated  神庭头文件
%% ---------------------------------------------------------------------------
-define(COURT_KV(Key), data_god_court:get(Key)).

-define(POS_LIMIT, ?COURT_KV(2)).               %% 装备限制
-define(DAILY_ORIGIN_TIMES, ?COURT_KV(3)).      %% 神之所升橙领取次数
-define(ORIGIN_COLOR, ?COURT_KV(4)).            %% 橙色水晶
-define(CRYSTAL_COST, ?COURT_KV(5)).            %% 开启水晶消耗
-define(GOD_POS_LIST, ?COURT_KV(6)).            %% 纹章位置列表
-define(SPECIAL_OPEN_TIMES, ?COURT_KV(7)).      %% 每日前n次开水晶特殊处理
-define(SPECIAL_OPEN_REWARDS, ?COURT_KV(8)).    %% 每日前n次开水晶特殊处理的 随机奖池1 在该处进行抽奖

%% 特殊属性，在自己模块进行处理
-define(COURT_ATTR_ATT_327,     327). %% 神庭攻击总属性万分比
-define(COURT_ATTR_HP_328,      328). %% 神庭生命总属性万分比
-define(COURT_ATTR_WRECK_329,   329). %% 神庭破甲总属性万分比
-define(COURT_ATTR_DEF_330,     330). %% 神庭防御总属性万分比

-define(COURT_STAGE_ATTR_331,         331). %% 纹章基础属性万分比

%% 装备卓越属性链表（需特殊万分比处理）
-define(BRILLIANT_ATTR_LIST, [?COURT_ATTR_ATT_327, ?COURT_ATTR_HP_328, ?COURT_ATTR_WRECK_329, ?COURT_ATTR_DEF_330]).
%% 装备升阶特殊属性链表（需万分比处理）
-define(STAGE_SPECIAL_ATTR_LIST, [?COURT_STAGE_ATTR_331]).


%% 神庭已激活
-define(IS_ACTIVE, 1).

-define(NO_GET,     0).         %% 未领取
-define(CAN_GET,    1).         %% 可领取
-define(HAD_GET,    3).         %% 已领取

-record(god_court_status, {
    house_status = undefined,   %% 神之所状态
    god_court_list = [],        %% 神庭列表
    sum_attr = []               %% 属性汇总
}).

-record(god_court_item, {
    court_id = 0,
    is_active = 0,              %% 是否激活 0未激活 1激活
    lv = 0,                     %% 神庭等级
    lv_attr = [],               %% 等级属性
    equip_attr = [],            %% 装备属性
    equip_list = [],            %% [{equip_pos, goods_id, equip_id, equip_stage}|_]
    suit_list = [],             %% 套装状态
    stage_attr = [],            %% 阶数属性
    sum_attr = []               %% 属性汇总
}).

-record(god_house_status, {
    lv = 1,                     %% 神之所等级
    exp = 0,                    %% 神之所经验
    sum_num = 0,                %% 总升橙次数
    daily_num = 0,              %% 当日升橙次数
    crystal_color = 1,          %% 水晶品质
    grand_status = [],          %% [{times, status}|_]每日累计升橙领取状态
    reset_time = 0              %% 重置时间
}).



%% 神庭
-record(base_god_court, {
    id = 0,
    name = "",
    condition = [],             %% 解锁条件
    core_pos = 0                %% 核心槽位
}).
%% 神庭装备
-record(base_god_court_equip, {
    id = 0,
    base_attr = [],             %% 基础属性
    rare_attr = [],             %% 稀有属性
    brilliant_attr = []         %% 卓越属性
}).
%% 神庭强化
-record(base_god_court_strength, {
    lv = 0,                     %% 神庭等级
    cost = [],                  %% 升级消耗
    attr = []                   %% 属性
}).
%% 神庭升阶
-record(base_god_court_equip_stage, {
    stage = 0,                  %% 阶数
    cost = 0,                   %% 升阶消耗
    attr = [],                  %% 属性
    suit_attr = []              %% 所有位置的阶数达到当前stage解锁
}).
%% 神之所等级
-record(base_god_house_lv, {
    lv = 0,
    exp = 0
}).
%% 水晶品质
-record(base_god_house_crystal, {
    color = 0,
    weight = [],                %% 权重[{down,100},{up, 100}]掉品升品权重
    exp = 0,                    %% 提供的经验
    origin_cost = [],           %% 升橙品消耗
    must_reward = [],           %% 必得奖励
    random_reward = [],         %% 随机奖池
    random_reward2 = []         %% 随机奖池2
}).
%% 达到次数的随机奖池
-record(base_god_house_reward, {
    lv = 0,                     %% 奖励等级
    down_num = 0,               %% 次数下限
    up_num = 0,                 %% 次数上限
    reweard_pool = []            %% 奖池
}).

-define(sql_select_court, <<"select `court_id`, `is_active`, `lv` from `role_god_court` where `role_id` = ~p ">>).
-define(sql_select_court_equip, <<"select `pos`, `goods_id`, `equip_id`, `stage` from `role_god_court_equip` where `role_id` = ~p and `court_id` = ~p">>).
-define(sql_select_house, <<"select `lv`, `exp`, `sum_num`, `daily_num`, `crystal_color`, `grand_status`, `reset_time` from `role_god_house` where `role_id` = ~p">>).

-define(sql_save_court_item, <<"replace into `role_god_court` (`role_id`, `court_id`, `is_active`, `lv`) values (~p, ~p, ~p, ~p)">>).
-define(sql_save_court_item_equip, <<"replace into `role_god_court_equip` (`role_id`, `court_id`, `pos`, `goods_id`, `equip_id`, `stage`) values (~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_save_god_house, <<"replace into `role_god_house` (`role_id`, `lv`, `exp`, `sum_num`, `daily_num`, `crystal_color`, `grand_status`, `reset_time`) values (~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p)">>).