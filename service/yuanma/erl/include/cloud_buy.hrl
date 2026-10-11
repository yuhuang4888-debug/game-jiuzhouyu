%%-----------------------------------------------------------------------------
%% @Module  :       cloud_buy.hrl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-09-21
%% @Description:    众仙云购
%%-----------------------------------------------------------------------------

-record(cloud_buy_kf_mgr_state, {
    subtype_list = [],
    check_timer = 0
}).

-record(subtype_info, {
    subtype = 0,
    sub_pid = 0
}).

-record(cloud_buy_kf_state, {
    custom_act_type = 0,
    custom_act_subtype = 0,
    start_time = 0,
    end_time = 0,
    award_time = 0,
    unlimited_time = 0,
    done_orders = [],
    unfinished_orders = [],
    big_award_id = 0,
    award_open_ref = [],
    unlimited_ref = [],
    clear_unfinished_ref = [],
    last_lucky_orders = [],
    last_big_award_id = 0,
    order_record = [],                %% 云购订单记录 只保留3天内的
    cur_count = 0,                    %% 当前云购总的购买次数   
    join_num = 0,                     %% 参与人数
    cloud_end_flag = 0,               %% 云购卖完标识
    last_award_time = 0               %% 上次中奖时间
    }).

-record (cloud_order, {
    order_id = 0,
    big_award_id = 0,
    customer_uid = "",
    customer_name = "",
    platform = "",
    server = 0,
    state = 0,
    count = 1,
    time = 0,
    goods_type_id = [],              %% 购买奖励 物品类型id列表
    award_time = 0
    }).

-record (cloud_award_config, {
    id,
    rewards,
    resouce_id,
    total_count,
    cost,
    award_count,
    happy_awards
    }).
 
%% --------------------限时云购配置----------------------
-record(big_award_cfg,{
        id = 0,             %% 大奖id
        reward = [],        %% 具体的大奖内容配置
        num = 1,            %% 总的份数
        cost = [],          %% 购买消耗
        value = 0,          %% 价值
        reward_pool = 0,    %% 对应奖池id
        award_num = 0
    }).

-record(reward_pool_cfg,{
        id = 0,             %% 奖池id
        reward_id = 0,      %% 奖励id
        begin_times = 0,    %% 开始次数（在这个区间使用特殊权重计算）
        end_times = 0,      %% 结束次数
        weight = 0,         %% 正常权重
        special_weight = 0, %% 特殊权重
        reward = []         %% 奖励
    }).
%% -----------------------------------------------------

-record (cloud_buy_reward_con, {
    reward_id,
    reward_list
    }).

-record (cloud_buy_status, {
    subtype = 0,
    big_award_id = 0,
    award_time = 0, 
    cur_order = undfined,
    req_times = 0,
    stage_reward = []               %% 阶段奖励 [{StageBuyTimes, StageState}...]
    ,buy_times = 0                  %% 本次大奖购买次数
    }).

-define(STAGE_NONE,       0).   %% 不满足
-define(STAGE_GETTED,     2).   %% 已领取

-define (ORDER_STATE_NONE, 0).
-define (ORDER_STATE_PAID, 1).
-define (ORDER_STATE_AWARD, 2).
-define (ORDER_STATE_LOSE, 3).
-define (ORDER_STATE_FAIL, 4).

-define(sql_select_stage,  <<"select role_id, subtype, state, buy_times, big_award_id from cloud_buy_stage_reward where role_id = ~p">>).
-define(sql_replace_stage, <<"replace into cloud_buy_stage_reward (role_id, subtype, state, buy_times, big_award_id) values(~p,~p,'~s',~p,~p)">>).