%%-----------------------------------------------------------------------------
%% @Module  :       bonus_monday.hrl
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2019-4-26
%% @Description:    周一大奖
%%-----------------------------------------------------------------------------

-record(base_monday_bonus, {
       id = 0               %% 奖励类型
       ,num = 0             %% 奖励数量
       ,display = []        %% 默认奖池
       ,choose_list = 0     %% 选择列表[{Type, Gtypeid, Num}]
       ,weight = 0          %% 权重 1.integer 2{MinTimes, MaxTimes, Weight, SpecialWeight}
       ,tv_id = []          %% 传闻[{modid,tvid}]
    }).
%{MinTimes, MaxTimes, Weight, SpecialWeight}:在最小最大次数区间使用特殊权重SpecialWeight，其他情况使用Weight 

-record(base_monday_bonus_task, {
        id = 0,             %% 任务id
        reward = []         %% 奖励
        ,condition = []     %% 条件
    }).

-record(monday_bonus_data, {
        draw_times = 0,     %% 抽奖次数
        now_pool = [],      %% 奖池[{奖励类型, [奖励]}]
        task_state = []     %% 任务状态{task_id, State}
        , record = []       %% 玩家抽奖记录
        , utime = 0         %% 任务状态改变时间
    }).

-define(NOT_ACHIEVE, 0).
-define(HAS_ACHIEVE, 1).
-define(HAS_RECIEVE, 2).

-define(RECHARGE_TASK, 100). %% 每日首充
-define(LOGIN_TASK,    101). %% 每日登陆
-define(LIVNESS_TASK,  102). %% 每日活跃

-define(COUNTER_RECHARGE,   1).%% 每日充值计数器


-define(SQL_PERSON_INSERT, <<"INSERT INTO `monday_draw_record` (`role_id`, `type`, `goods_pool_id`, `utime`, `picture`, `picture_ver`,`creer`) VALUES (~p, ~p, ~p, ~p, '~s', ~p, ~p)">>).
-define(SQL_PERSON_SELECT,  <<"SELECT `role_id`, `type`, `goods_pool_id`, `utime`, `picture`, `picture_ver`, `creer` FROM `monday_draw_record` WHERE `role_id` = ~p">>).
-define(SQL_PERSON_DELETE, <<"DELETE FROM `monday_draw_record` WHERE `utime` < ~p AND `role_id` = ~p">>).
-define(SQL_PERSON_TRUNCATE, <<"TRUNCATE TABLE `monday_draw_record`">>).

-define(SQL_SELECT_DATA,   <<"SELECT `draw_times`,`task_state`, `pool`, `utime` FROM `monday_draw_data` WHERE `role_id` = ~p">>).
-define(SQL_REPLACE_DATA,  <<"REPLACE INTO `monday_draw_data`(`role_id`, `draw_times`, `task_state`, `pool`, `utime`) VALUES (~p,~p,'~s','~s',~p)">>).
-define(SQL_TRUNCATE_DATA, <<"TRUNCATE TABLE `monday_draw_data`">>).