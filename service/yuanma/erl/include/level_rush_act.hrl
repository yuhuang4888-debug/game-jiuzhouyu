%%-----------------------------------------------------------------------------
%% @Module  :       level_rush_act
%% @Author  :
%% @Email   :
%% @Created :       2018-05-25
%% @Description:    等级抢购活动
%%-----------------------------------------------------------------------------

%% 助力礼包活动类型
-define(LEVEL_HELP_GIFT, 66).

-define(LEVEL_ACT_TYPE_ROLE_LEVEL,  1). % 玩家等级控制类型
-define(LEVEL_ACT_TYPE_CUSTOM_ACT,  2). % 定制活动控制类型

-record(base_lv_act_open, {
        act_type = 0,               %% 活动类型
        act_subtype = 0,            %% 活动子类型
        act_name = <<>>,            %% 活动名
        open_lv = 0,                %% 开启等级
        continue_time = [],         %% 持续时间
        conditions = [],            %% 条件
        circuit = 0,                %% 活动开关
        clear_type = 0              %% 清理类型
    }).

-record(base_lv_act_reward, {
        act_type = 0,               %% 活动类型
        act_subtype = 0,            %% 活动子类型
        reward_name = <<>>,         %% 奖励名
        grade = 0,                  %% 档次
        normal_cost = [],           %% 原价
        cost = [],                  %% 现价
        string = <<>>,              %% 客户端用
        show = [],                  %% 客户端用
        reward = [],                %% 奖励
        condition = [],             %% 条件
        recharge_id = 0             %% 充值ID
    }).

-record(base_lv_gift_reward, {
        act_type = 0,               %% 活动类型
        act_subtype = 0,            %% 活动子类型
        reward_name = <<>>,         %% 奖励名
        grade = 0,                  %% 档次
        sort = 0,                   %% 种类
        recharge_id = 0,            %% 充值id
        lv_min = 0,                 %% 等级下限
        lv_max = 0,                 %% 等级上限
        vip_min = 0,                %% VIP经验下限
        vip_max = 0,                %% VIP经验上限
        open_day_min = 0,           %% 开服天数下限
        open_day_max = 0,           %% 开服天数上限
        circle = 0,                 %% 循环间隔 0表示不循环，进入循环开服天数上限失效
        discount = 0,               %% 折扣
        cost = [],                  %% 现价
        string = <<>>,              %% 客户端用
        show = [],                  %% 客户端用
        reward = []                 %% 奖励
        ,condition = []
    }).

-record(lv_act_state, {
        act_map = #{},              %% 活动数据 #{{Type, SubType} => #lv_act_data{}}
        act_reward_rec = #{},       %% 活动奖励记录{Type, SubType} => [{Grade, HasBuy, EndTime}]
        record_map = #{},           %% 活动参与记录 #{{Type, SubType} => HasJoin}
        cd_list = [],               %% 阻力礼包冷却时间
        cd_ref_list = [],           %% 冷却定时器
        circle_map = #{},           %% 循环推送列表 {Type, SubType} => [{Grade, Circle, optime:上次操作时间}]
        level_act_ref = undefined   %% 等级控制类型活动定时器
    }).

-record(lv_act_data, {
        key = {0,0}                 %% {act_type, act_subtype}
        ,end_time = 0               %% 结束时间戳
        ,status = []                %% [{Grade, State:是否购买}...]
        ,stime = 0                  %% 操作时间
        ,open_time = 0              %% 开启时间戳
        ,ref = undefined            %% 结束定时器
        ,open_times = 0             %% 开启次数
        ,old_status = []            %% 上一轮活动结束时的状态[{Grade, State:是否购买}...]
    }).

-define(MONEY_TYPE_GOLD,  1).        %% 钻石
-define(MONEY_TYPE_BGOLD, 2).        %% 绑定钻石
-define(MONEY_TYPE_MONEY, 3).        %% 真实货币

-define(HAS_BUY,        1).         %% 已购买
-define(NOT_BUY,        0).         %% 未购买
-define(TIME_END,       2).         %% 时间到未购买

-define(HAS_JOIN,       1).         %% 已参与过活动

-define(CLEAR_TYPE_ACT_END,   1).   %% 活动结束清理
-define(CLEAR_TYPE_ZERO,      2).   %% 0点清理
-define(CLEAR_TYPE_FOUR,      3).   %% 4点清理

-define(ACT_OPEN,             1).   %% 活动开启
-define(ACT_OFF,              0).   %% 活动关闭

-define(SQL_SELECT,     <<"SELECT `type`,`sub_type`,`open_time`,`end_time`,`status`,`utime`, `open_times`, `old_status` FROM `role_lv_act_data` WHERE `role_id` = ~p">>).
-define(SQL_REPLACE,    <<"REPLACE INTO `role_lv_act_data`(`role_id`,`type`,`sub_type`,`open_time`,`end_time`,`status`,`utime`, `open_times`, `old_status`) VALUES (~p, ~p, ~p, ~p, ~p, '~s', ~p, ~p, '~s')">>).
-define(SQL_DELETE,     <<"DELETE FROM `role_lv_act_data` WHERE `role_id` = ~p AND `type` = ~p AND`sub_type` = ~p">>).
-define(SQL_DELETE_ACT, <<"DELETE FROM `role_lv_act_data` WHERE `type` = ~p AND`sub_type` = ~p">>).

-define(SQL_SELECT_REC, <<"SELECT `act_type`,`act_subtype`,`stime` FROM `lv_act_join_data` WHERE `role_id` = ~p">>).
-define(SQL_REPLACE_REC, <<"REPLACE INTO `lv_act_join_data`(`role_id`,`act_type`,`act_subtype`,`stime`) VALUES (~p, ~p, ~p, ~p)">>).
-define(SQL_DELETE_REC,  <<"TRUNCATE TABLE `lv_act_join_data`">>).

-define(SQL_SELECT_GRADE,  <<"SELECT `type`,`subtype`,`grade`,`buy`,`stime` FROM `lv_act_grade_data` WHERE `role_id` = ~p">>).
-define(SQL_REPLACE_GRADE, <<"REPLACE INTO `lv_act_grade_data`(`role_id`,`type`,`subtype`,`grade`,`buy`,`stime`) VALUES (~p,~p,~p,~p,~p,~p)">>).