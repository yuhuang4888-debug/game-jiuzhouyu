%% ---------------------------------------------------------------------------
%% @doc contract_challenge

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/26
%% @deprecated  契约挑战
%% ---------------------------------------------------------------------------

%% 任务状态
-define(NO_OPEN,    0).
-define(HAD_OPEN,   1).

%% 领取状态
-define(NO_GET,     0).
-define(CAN_GET,    1).
-define(HAD_GET,    2).
%% 任務類型
-define(GRAND_TASK, 0).     %% 累计任务
-define(DAILY_TASK, 1).     %% 每日任务

-define(CONTRACT_COST, 0).  %% 契约挑战消费模块

-define(DAILY_TASK_NUM, 3). %% 每日任务个数
%% 是否传说契约
-define(NOT_LEGEND, 0).
-define(IS_LEGEND,  1).

-define(COST_MODULE,    0).%% 消费mod
-define(Default_subtype, 0).%% 默认SubType

-define(Default_buff_goods_id, 37060003).   %% 传说契约默认激活的buff物品id(buff图标需要物品id)

%% 传说契约buff
-record(contract_buff, {
    effect_time = 0,        %% 过期时间
    buff_attr = [],         %% 增益buff[{GoodsTypeId, Attr}]
    buff_other = []         %% 其他（比如指定模块的额外次数）[{{Module, SubModule}, {GoodsTypeId, Times}}]
}).

-record(challenge_status, {
    sub_type = 0,           %% 活动子类型
    open_day = 0,           %% 活动开启天数
    flush_time = 0,         %% 下次刷新每日活动时间
    role_map = #{},         %% 用户信息 #{RoleId -> #role_challenge{}}
    stime = 0,              %% 开始时间
    etime = 0,              %% 结束时间
    reward_grades = []      %% 活动奖励等级（活动奖励会根据世界等级变动，根据活动刚开始的世界等级保存起来即可）
}).

%% 用户契约状态
-record(role_challenge, {
    sum_point = 0,          %% 契约总点数
    is_legend = 0,          %% 是否激活传说契约
    challenge_list = [],    %% [#challenge_item{}|_]任务明细
    reward_status = [],     %% 奖励领取状态
    daily_recharge = 0,     %% 当天充值金额
    daily_cost = 0          %% 当天消费
}).

%% 任务明细
-record(challenge_item, {
    item_id = 0,            %% 任务id 自增，用于标识
    task_id = 0,            %% 任务类型id
    challenge_type = 0,     %% 任务类型 0累计，1每日
    module = 0,             %% 任务模块id
    sub_module = 0,         %% 任务子模块id
    grand_num = 0,          %% 完成进度
    is_get = 0,             %% 是否领取奖励 0未领取，1可领取，2已领取
    utime = 0               %% 更新时间
}).

-record(base_contract_challenge, {
    sub_type = 0,           %% 定制活动子类型
    task_id = 0,            %% 任务类型id
    challenge_type = 0,     %% 任务类型 0累计，1每日
    module = 0,             %% 模块id
    sub_module = 0,         %% 功能子id
    challenge_name = "",    %% 任务描述
    icon_type = "",         %% 模块图片
    point = 0,              %% 获得契约点
    grand_num = 0,          %% 累计完成次数/累计金额充值或消耗
    special_value = 0,      %% 特殊值（比如连续n天消费xxx或者连续n天消费xxx 的xx）
    open_day = 0,           %% 活动第几天开启
    jump_id = 0             %% 跳转id,客户端需要
}).

-define(SELECT_CONTRACT_ACT_INFO,
    <<"select `sub_type`, `role_id`, `sum_point`, `is_legend`, `reward_status`, `daily_recharge`, `daily_cost` from `contract_challenge_act` where `sub_type` = ~p">>).

-define(SELECT_CONTRACT_ACT_TASK_ITEM, <<"select `item_id`, `task_id`, `grand_num`, `is_get`, `utime`
        from contract_challenge_act_item where `sub_type` = ~p and `role_id` = ~p ">>).

-define(SELECT_ROLE_CONTRACT_BUFF,
    <<"select `effect_time`, `buff_attr`, `buff_other` from `role_contract_buff` where `role_id` = ~p ">>).

-define(DELETE_CONTRACT_ACT_INFO,
    <<"delete from `contract_challenge_act` where `sub_type` = ~p ">>).

-define(DELETE_CONTRACT_ACT_TASK_ITEM,
    <<"delete from `contract_challenge_act_item` where `sub_type` = ~p ">>).

%%-define(DELETE_ROLE_CONTRACT_BUFF,
%%    <<"delete from `role_contract_buff` where `sub_type` = ~p ">>).

-define(TRUNCATE_ROLE_CONTRACT_BUFF, <<"truncate table role_contract_buff">>).

-define(SAVE_CONTRACT_LEGEND_TIME,
    <<"replace into `contract_challenge_legend_time` (`role_id`, `contract_time`) values (~p, ~p) ">>).

-define(SAVE_CONTRACT_ACT_INFO,
    <<"replace into `contract_challenge_act` (`sub_type`, `role_id`, `sum_point`, `is_legend`, `reward_status`, `daily_recharge`, `daily_cost`) values (~p, ~p, ~p, ~p, '~s', ~p, ~p) ">>).

-define(SAVE_CONTRACT_ACT_TASK_ITEM,
    <<"replace into `contract_challenge_act_item` (`sub_type`, `role_id`, `item_id`, `task_id`, `grand_num`, `is_get`, `utime`) values (~p, ~p, ~p, ~p, ~p, ~p, ~p) ">>).

-define(SAVE_ROLE_CONTRACT_BUFF,
    <<"replace into `role_contract_buff` (`role_id`,`effect_time`, `buff_attr`, `buff_other`) values ( ~p , ~p, '~s', '~s') ">>).



