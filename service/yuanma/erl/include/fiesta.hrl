%%% ------------------------------------------------------------------------------------------------
%%% @doc            fiesta.hrl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-12-03
%%% @modified
%%% @description    祭典头文件
%%% ------------------------------------------------------------------------------------------------

%%% ======================================= variable macros ========================================

%% kv
-define(FIESTA_KV(Key),  data_fiesta:get(Key)).

-define(UNCYCLE_ACTS,            ?FIESTA_KV(0)). % 不循环活动配置 [{活动id,创角天数,持续天数}]
-define(CYCLE_ACTS,              ?FIESTA_KV(1)). % 循环活动配置 [{活动id,创角天数,持续天数}]

%% 祭典开通类型
-define(NORMAL_FIESTA,     0). % 普通版
-define(PREMIUM_FIESTA,    1). % 豪华版
-define(PREMIUM_FIESTA2,   2). % 至尊版

%% 奖励状态
-define(NOT_ACHIEVE, 0). % 未达成
-define(NOT_RECEIVE, 1). % 已完成未领取
-define(HAS_RECEIVE, 2). % 已领取

%% 任务类型
-define(DAILY_TASK,  1). % 每日任务
-define(WEEKLY_TASK, 2). % 每周任务
-define(SEASON_TASK, 3). % 赛季任务

%% 直接设值的任务
-define(DIRECT_SET_TASKS, [liveness]).

%% 传闻
-define(ACTIVATE_PREMIUM_LAN, 1). % 激活高级祭典传闻

%% 邮件
-define(UNRECEIVE_REWARD_TITLE,     1940001). % 未领取奖励邮件
-define(UNRECEIVE_REWARD_CONTENT,   1940002).

%%% ======================================== config records ========================================

%% 祭典活动配置
-record(base_fiesta_act, {
    id               = 0  % 祭典唯一id
    ,act_id          = 0  % 活动id
    ,act_name        = "" % 活动名称
    ,min_lv          = 0  % 开启最小等级
    ,max_lv          = 0  % 开启最大等级
    ,duration        = 0  % 持续天数
    ,content1        = [] % 豪华版祭典内容
    ,content2        = [] % 至尊版祭典内容
    ,link_id         = 0  % 进阶页面链接id
}).

%% 祭典等级配置表
-record(base_fiesta_lv_exp, {
    id              = 0  % 祭典唯一id
    ,act_id         = 0  % 活动id
    ,lv             = 0  % 祭典等级
    ,exp            = 0  % 累计经验
    ,reward         = [] % 普通奖励
    ,premium_reward = [] % 豪华奖励
}).

%% 祭典活动任务配置表
-record(base_fiesta_act_task, {
    id         = 0  % 祭典唯一id
    ,act_id    = 0  % 活动id
    ,type      = 0  % 任务类型
    ,task_list = [] % 任务id列表
}).

%% 祭典任务配置表
-record(base_fiesta_task, {
    id          = 0  % 任务id
    ,content    = '' % 任务内容
    ,desc       = "" % 任务描述
    ,open_day   = 0  % 任务开启天数
    ,open_lv    = 0  % 任务开启等级
    ,times      = 0  % 可完成次数
    ,target_num = 0  % 任务目标数值
    ,exp        = 0  % 祭典经验奖励值
}).

%%% ======================================== general records =======================================

%% 玩家祭典状态
-record(fiesta, {
    fiesta_id      = 0   % 祭典唯一id
    ,act_id        = 0   % 活动id
    ,type          = 0   % 祭典开通类型
    ,lv            = 0   % 当前祭典等级
    ,exp           = 0   % 当前累计经验
    ,begin_time    = 0   % 开始时间戳
    ,expired_time  = 0   % 过期时间戳
    ,reward_m      = #{} % 奖励状态信息 #{祭典等级 => #fiesta_reward{}}
    ,task_m        = #{} % 任务状态信息 #{任务类型 => [#fiesta_task{},...]}
    ,drefresh_time = 0   % 每日任务刷新时间
    ,wrefresh_time = 0   % 每周任务刷新时间
}).

%% 玩家祭典奖励状态信息
-record(fiesta_reward, {
    lv       = 0 % 祭典等级
    ,status1 = 0 % 普通奖励领取状态
    ,status2 = 0 % 高级奖励领取状态
}).

%% 玩家祭典任务状态信息
-record(fiesta_task, {
    task_id       = 0 % 任务id
    ,finish_times = 0 % 已完成次数(领取了奖励才算完成)
    ,cur_num      = 0 % 当前单任务进度
    ,status       = 0 % 经验奖励状态
    ,acc_times    = 0 % 累积未领取的次数
}).

%%% ========================================== sql macros ==========================================

%% fiesta

-define(SELECT_FIESTA,
    <<
        "select fiesta_id, act_id, type, lv, exp, begin_time, expired_time
        from fiesta
        where role_id=~p"
    >>).

-define(DELETE_FIESTA,
    <<
        "delete from fiesta
        where role_id=~p"
    >>).

-define(REPLACE_FIESTA,
    <<
        "replace into fiesta
        (role_id, fiesta_id, act_id, type, lv, exp, begin_time, expired_time)
        values (~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)"
    >>).

-define(SELECT_FIESTA_EXPIRED,
    <<
        "select a.role_id, a.fiesta_id, a.type, b.lv, b.status1, b.status2
        from fiesta a inner join fiesta_reward b
        on a.role_id=b.role_id
        where a.expired_time<=~p and (b.status1=~p or b.status2=~p)"
    >>).

%% fiesta_reward

-define(SELECT_FIESTA_REWARD,
    <<
        "select lv, status1, status2
        from fiesta_reward
        where role_id=~p"
    >>).

-define(DELETE_FIESTA_REWARD,
    <<
        "delete from fiesta_reward
        where role_id=~p"
    >>).

-define(REPLACE_FIESTA_REWARD,
    <<
        "replace into fiesta_reward
        (role_id, lv, status1, status2)
        values (~p, ~p, ~p, ~p)"
    >>).

%% fiesta_task

-define(SELECT_FIESTA_TASK,
    <<
        "select type, task_id, finish_times, cur_num, status, acc_times
        from fiesta_task
        where role_id=~p"
    >>).

-define(DELETE_FIESTA_TASK,
    <<
        "delete from fiesta_task
        where role_id=~p"
    >>).

-define(DELETE_FIESTA_TASK_TYPE,
    <<
        "delete from fiesta_task
        where role_id=~p and type=~p"
    >>).

-define(REPLACE_FIESTA_TASK,
    <<
        "replace into fiesta_task
        (role_id, type, task_id, finish_times, cur_num, status, acc_times)
        values (~p, ~p, ~p, ~p, ~p, ~p, ~p)"
    >>).