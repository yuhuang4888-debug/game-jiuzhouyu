-define(DAILY_CHECK_OPEN, 1).               %% 功能处于开启
-define(DAILY_CHECK_CLOSE, 0).              %% 功能处于关闭

-define(GIFT_NOT_RECEIVED, 0).              %% 礼品未领取
-define(GIFT_RECEIVED, 1).                  %% 礼品已领取
-define(DAILY_CHECK_OPEN_LV, 1).            %% 每日签到：功能开启等级

-define(DAILY_CHECK_NOT_DID,  0).           %% 每日签到：当前未签到
-define(DAILY_CHECK_DID,      1).           %% 每日签到：当天已签到
-define(DAILY_CHECK_CAN_RETRO, 2).          %% 每日签到：可以补签
-define(DAILY_CHECK_CAN_CHECK, 3).          %% 每日签到可以领取

-define(DAILY_CHECK_REWARD_ONCE, 4).        %% 每日签到VIP等级提升，已签到后奖励补领
-define(DAILY_CHECK_TODAY,       5).        %% 当天签到的，用于判断当日vip提升后是否给与奖励

-define(DAILY_CHECK_RETRO,    1).           %% 每日签到补签
-define(DAILY_CHECK,          0).           %% 每日签到
-define(DAILY_CHECK_S,        2).           %% 特殊签到

-define(DAY_NUM_MONTH,       30).           %% 每个月30天
-define(MONTH_NUM_YEAR,      12).           %% 12月

-define(TOTAL_CHECKIN_TITLE,    4170001).
-define(TOTAL_CHECKIN_CONTENT,  4170002).

%% 签到状态信息
-record(checkin_status, {
        month = 0,                          %% 月份 
        total_state = undefined,            %% 累计签到状态
        daily_state = undefined,            %% 每日签到状态
        retroactive_times = 0,              %% 当月补签次数
        is_need_reward = 0,                 %% 是否可以再次领取签到奖励
        remain_times = 0                    %% 剩余补签次数
    }).
%%---------------------------------------------------------------
%% 签到配置相关记录
%%---------------------------------------------------------------

%% 每日签到 累计签到配置
-record(base_checkin_total_rewards, {
        total_type = 0,                     %% 签到类型
        days = 0,                           %% 累计签到天数
        rewards = []                        %% 累计奖励
    }).

%% 每日签到 签到类型配置
-record(base_checkin_type,{
        lv_limmit = 0,                      %% 等级下限
        lv_upper = 0,                       %% 等级上限
        month = 0,                          %% 月份
        daily_type = 0,                     %% 签到类型
        total_type = 0                      %% 累计签到类型
    }).

%% 每日签到 奖励配置
-record(base_checkin_daily_rewards, {
        daily_type = 0,                           %% 签到类型
        day = 0,                            %% 每月第几天
        rewards = [],                       %% 奖励
        vip_lv = [],                        %% vip等级以及vip特权类型
        vip_multiple = 0                    %% vip倍数
    }).

%% 补签配置
-record(base_checkin_daily_retroactive,{
        retro_times = 0,                    %% 补签次数
        money_type = 0,                     %% 货币类型
        price = 0                           %% 价格
    }).