-record(base_guild_daily, {
        task_id = 0,            %% 任务id
        key = [],               %% 条件
        max_num = 0,            %% 可发放最大次数
        reward = []             %% 奖励
        ,persist = 0            %% 持续时间
    }).

-record(guild_daily_state, {
        task = #{}              %% role_id => [#task_item{}]
        ,reward_status = #{}    %% guild => [#reward_info{}] 
        ,log = #{}              %% guild => [#send_log{}]
        ,need_save_list = []    %% [id]
    }).

-record(task_item, {
        task_id = 0,            %% 任务id
        num = 0                 %% 已发放次数
        ,stime = 0              %% 时间
    }).

-record(reward_info, {
        id = 0,                 %% id
        task_id = 0,            %% 任务id
        bl = 0,                 %% 归属玩家id
        bl_name = <<>>,         %% 归属名字
        time = 0,               %% 生成时间
        end_ref = undefined,    %% 结束定时器
        record = []             %% [{role_id, reward}...]
    }).

-record(send_log, {
        task_id = 0,
        role_id = 0,
        role_name = <<>>,
        time = 0
    }).

-define(RECORD_LENGTH,  60).    %% 公会记录长度

-define(SELECT_GUILD_DAILY, <<"SELECT `id`, `guild`, `task_id`, `bl`, `bl_name`, `time` FROM `guild_daily`">>).
-define(UPDATE_GUILD_DAILY, <<"REPLACE INTO `guild_daily`(`id`, `guild`, `task_id`, `bl`, `bl_name`, `time`) VALUES (~p, ~p, ~p, ~p, '~s', ~p)">>).
-define(DELETE_GUILD_DAILY, <<"DELETE FROM `guild_daily` WHERE `id` = ~p">>).

-define(SELECT_GUILD_DAILY_RECIEVE, <<"SELECT `id`, `guild`, `role_id`, `reward`, `stime` FROM `guild_daily_recieve`">>).
-define(UPDATE_GUILD_DAILY_RECIEVE, <<"REPLACE INTO `guild_daily_recieve`(`id`, `guild`, `role_id`, `reward`, `stime`) VALUES (~p, ~p, ~p, '~s', ~p)">>).
-define(DELETE_GUILD_DAILY_RECIEVE, <<"DELETE FROM `guild_daily_recieve` WHERE `id` = ~p">>).

-define(SELECT_GUILD_RECORD, <<"SELECT `guild`, `record_list`FROM `guild_daily_record`">>).
-define(UPDATE_GUILD_RECORD, <<"REPLACE INTO `guild_daily_record`(`guild`, `record_list`) VALUES (~p, '~s')">>).

-define(SELECT_GUILD_TASK,  <<"SELECT `role_id`, `task_id`, `num`, `stime` FROM `guild_daily_task`">>).
-define(UPDATE_GUILD_TASK,  <<"REPLACE INTO `guild_daily_task`(`role_id`, `task_id`, `num`, `stime`) VALUES (~p, ~p, ~p, ~p)">>).
-define(DELETE_GUILD_TASK,  <<"DELETE FROM `guild_daily_task` WHERE `role_id` = ~p">>).
-define(TRUNCATE_GUILD_TASK,<<"TRUNCATE TABLE guild_daily_task">>).