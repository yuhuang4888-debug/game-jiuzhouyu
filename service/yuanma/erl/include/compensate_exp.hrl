%% ---------------------------------------------------------------------------
%% @doc compensate_exp.hrl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-05-11
%% @deprecated 补偿经验
%% ---------------------------------------------------------------------------

-define(COMPENSATE_EXP_ONHOOK_TIME, (5*3600)).    %% 满足补偿经验丹的挂机时间

%% 补偿经验
% data_compenstate_exp:get_exp_ratio(StartDay, EndDay, MinLv, MaxLv) -> ExpRatio.
% -record(base_compensate_exp, {
%         start_day = 0       % 注册开始天数
%         , end_day = 0       % 注册结束天数
%         , min_lv = 0        % 最小等级
%         , max_lv = 0        % 最大等级
%         , exp_ratio = 0     % 经验加成##万分比
%     }).

%% 补偿经验物品
% data_compenstate_exp:get_exp_goods_reward(StartDay, EndDay, MinLv, MaxLv) -> Reward.
% -record(base_compensate_exp_goods, {
%         start_day = 0       % 注册开始天数
%         , end_day = 0       % 注册结束天数
%         , min_lv = 0        % 最小等级
%         , max_lv = 0        % 最大等级
%         , reward = []       % 奖励##[{Type, GoodsTypeId, Num}]
%     }).