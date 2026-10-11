%%-----------------------------------------------------------------------------
%% @Module  :       hi_point.hrl
%% @Author  :       Fwx
%% @Created :       2018-3-6
%% @Description:    嗨点(狂欢活动)
%%-----------------------------------------------------------------------------
-define(ACT_NAME, utext:get(3330001)).
-define(OPEN_LV, 100).
-define(CAN_PLUS, 0).
-define(CAN_NOT_PLUS, 1).
-define(SUB_ID, 0).
-define(PERSON_SUBTYPE, 0). % 个人嗨点活动SubType
-define(RECHARG_MOD, 158). % 充值时候的mod
-define(COST_MOD, 159). % 消费时候的mod
-define(SINGLE, single). % 每次任务就能获取嗨点的类型

-define(HI_GOODS_ID, 38350001). %% 嗨点之灵id 用于添加嗨点值的物品

-record(base_hi_point, {
    mod_id = 0,             %% 模块id
    sub_id = 0,             %% 子id  (模块id和子id确定唯一功能)
    name = "",              %% 功能名称
    one_points = 0,         %% 单次可得狂欢值
    max_points = 0,         %% 可得狂欢值上限
    min_lv = 0,             %% 最低等级
    max_lv = 0,             %% 最高等级
    order_id = 0,           %% 排序Id
    jump_id = 0,            %% 跳转id
    about = "" ,            %% 备注
    icon_type = "",         %% 模块图片
    reward_condition = [],  %% 奖励条件
    is_process = 0,          %% 是否显示进度
    show_id = 0,          %% 展示id
    sub_type = 0,          %% 子类型
    is_single = 0     %% 是否单独
}).

-record(hi_points, {
    key = undefined,        %% {mod_id, sub_id, condition_type}
    count = 0,              %% 参与次数/充值钻石/消耗钻石 [num] / 升级状态 {4 ,1}4星1阶
    is_plus = 0,            %% 控制重复增加
    utime =  0,             %% 数据更新时间
    point = 0               %% 点数
}).

-record(role_info, {
    sum_points = 0,         %% 总狂欢值
    points_list = [],       %% 各模块对应狂欢值列表 [#hi_points{}]
    reward_status = [],    %%  [{GradeId, Status}]  0:不可领 1；可领 2：已领
    utime = 0,              %% 更新时间
    stime = 0,
    etime = 0
}).

-record(act_state, {
    act_maps = #{}          %% #{SubType => #{role_id => #role_info{} } }
}).

-define(select_hi_points_per_status,
    <<"select stime, etime from hi_point_per_status where role_id = ~p">>).

-define(select_hi_points,
    <<"select role_id, sub_type, mod_id, sub_id, condition_type, count, is_plus, utime from hi_points_act">>).

-define(select_hi_points_reward,
    <<"select role_id, sub_type, grade, reward_state, utime from hi_points_reward">>).

-define(replace_hi_points,
    <<"replace into hi_points_act(role_id, sub_type, mod_id, sub_id, condition_type,  count, is_plus, utime)
    values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(replace_hi_points_per_status,
    <<"replace into hi_point_per_status(role_id, stime, etime)
    values(~p, ~p, ~p)">>).

-define(replace_hi_points_reward,
    <<"replace into hi_points_reward(role_id, sub_type, grade, reward_state, utime)
    values(~p, ~p, ~p, ~p, ~p)">>).

-define(delete_hi_points,
    <<"delete from hi_points_act where sub_type = ~p">>).

-define(delete_hi_points_reward,
    <<"delete from hi_points_reward where sub_type = ~p">>).