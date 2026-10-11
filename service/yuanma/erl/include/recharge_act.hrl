%% ---------------------------------------------------------------------------
%% @doc recharge_act.hrl
%% @author xiaoxiang
%% @since  2017-04-07
%% @deprecated 充值活动
%% ---------------------------------------------------------------------------
%% err159_1_not_welfare      非福利卡
%% err159_2_welfare_timeout  福利卡已过期
%% err159_3_not_buy          未购买相关产品
%% err159_4_already_get      已领取
%% err159_5_bag_not_enough   背包已满
%% err159_6_not_request      不满足要求
%%------------------------------------------------------------
%% 后台福利卡配置
-record(recharge_welfare, {
          product_id = 0,
          days = 0,
          reward = [],
          double_week = [],
          buy_reward =[]       %% 购买立马获得
         }).

-record(recharge_growup, {
          product_id = 0,
          rank = 0,
          request = [],
          reward = [],
          double_week = []
         }).

-record(recharge_goods, {
          product_id = 0,
          time = 0,       %% 领取时间
          left_count = 0  %% 剩余可领取次数
         }).

-record(recharge_act_status,{
          welfare = [],
          growup = [],
          cumulation = #{}
         }).


%% 充值活动进程state
-record(recharge_act_state, {
          daily_gift = #{}     %% 每日礼包 {playerid, product_id} => #ps_daily{}
         }).

%%---------------------------------------- 每日礼包 --------------------------------------
-define(DAILY_STATE_NOT_PURCHASE,  0).         %% 每日礼包 未购买
-define(DAILY_STATE_NOT_GET,       1).         %% 每日礼包 已购买未领取
-define(DAILY_STATE_GET,           2).         %% 每日礼包 已领取


-define(DAILY_GIFT_TITLE,         78).         %% 每日礼包 标题
-define(DAILY_GIFT_CONTENT,       79).         %% 每日礼包 内容


-define(DAILY_GIFT_NAME1,        139).         %% 每日礼包 1元礼包
-define(DAILY_GIFT_NAME2,        140).         %% 每日礼包 3元礼包
-define(DAILY_GIFT_NAME3,        141).         %% 每日礼包 6元礼包

-record(ps_daily, {
          player_id = 0,
          product_id = 0,
          state = 0
         }).

%% 每日礼包配置
-record(base_recharge_daily_gift, {
          product_id = 0,
          level = 0,
          value = 0,
          reward = []
         }).

-define(SQL_DAILY_GIFT_SELECT_ALL,   <<"select player_id,product_id,state from `recharge_daily_gift` ">>).
-define(SQL_DAILY_GIFT_UPDATE,       <<"replace into `recharge_daily_gift` set player_id=~p,product_id=~p,state=~p ">>).
-define(SQL_DAILY_GIFT_CLEAR,        <<"truncate table `recharge_daily_gift` ">>).

%%---------------------------------------- 每日礼包 end --------------------------------------

%% recharge_custom_act_data里面key的定义
%% 每日累充
-define (KEY_OF_REWARD, 1).   %% 每日充值满多少可以获得奖励 [{reward_id, state, time}]
-define (KEY_OF_CYCLE_TIME, 3).     %% 周期起点 一个时间戳

%% 多倍充值活动
-record(recharge_rebate, {
        rebate_times = 0        %% 返利次数
        , utime = 0             %% 时间
    }).