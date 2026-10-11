%%-----------------------------------------------------------------------------
%% @Module  :       investment.hrl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-18
%% @Description:    投资活动
%%-----------------------------------------------------------------------------

%% 注意:
%%  当前类型的额度默认能升级
%%  领取奖励的时候会计算低档的奖励等级，进行补领

-record (base_investment_reward, {
      type
    , level
    , id
    , rewards
    , condition
    }).

-record (base_investment_type, {
    type
    , level
    , price
    , price_type
    , condition
    , is_up = 0             %% 是否能升档##低档变高档,扣除相差消耗,补发相应奖励
    , any_tv_id = 0         %% 任意档次传闻id##传闻模块默认是420,首次+升档。默认参数:名字,玩家id,价格
    , first_tv_id = 0       %% 首次传闻id##传闻模块默认是420。默认参数:名字,玩家id
    }).

%% 条件定义
% <br> {min_lv, MinLv}:最低等级
% <br> {max_lv, MaxLv}:最大等级
% <br> {open_begin, OpenBegin}:开服天数的开始
% <br> {open_end, OpenEnd}:开服天数的结束
% <br> {merge_begin, MergeBegin}:合服天数的开始
% <br> {merge_end, MergeEnd}:合服天数的结束
% <br> {vip, Vip}:vip等级
-record (base_investment_item, {
    type = 0                %% 投资类型
    , do_type = 0           %% 处理类型##逻辑公用的
    , show_id = 0           %% 展示id##客户端处理界面用的
    , condition = []        %% 条件
    , reset_type = 0        %% 重置类型
    }).

-record (investment, {
    type = 0,
    cur_lv = 0,
    reward_info = [],       %% [{RewardId, CurLv},...]
    buy_time = 0,
    get_time = 0,           %% 领取时间
    days_utime = 0,         %% 登录天数的更新时间
    login_days = 0          %% 登录天数
    }).

-define (RESET_TYPE_REWARD_FINISH, 1).      %% 奖励是否全部领取完

% -define (INVEST_TYPE_DIAMOND, 1).           %% 钻石投资R
% -define (INVEST_TYPE_MONTH_CARD, 2).        %% 月卡投资
% -define (INVEST_TYPE_EXTREME, 3).           %% 至尊投资

-define (INVEST_DO_TYPE_LV, 1).             %% 等级投资
-define (INVEST_DO_TYPE_MONTH_CARD, 2).     %% 月卡投资
-define (INVEST_DO_TYPE_VIP, 3).            %% vip投资
-define (INVEST_DO_TYPE_CUSTOM_ACT, 4).            %% 节日投资

%% ============= 月卡附加的特权 =========================
-define(MONTH_CARD_VIP_VIT_TIME, 1).       %% 月卡特权 - 世界BOSS的体力时间减少X比列
-define(MONTH_CARD_VIP_DOUBLE_REWARD, 2).  %% 月卡特权 - 在线奖励翻倍
%% 特殊处理这个时间点之前的月卡，全部补发奖励
-define(SPECIAL_TIME_POINT, data_key_value:get(14)).
%% 充值商品的ID
-define(MONTH_CARD_RECHARGE_ID, 108).     %% 月卡的商品ID
-define(WEEK_CARD_RECHARGE_ID, 107).     %% 月卡的商品ID

-define(MONTH_CARD_EFFECTIVE_TIME, erlang:length(data_investment:get_all_reward_id(?INVEST_DO_TYPE_MONTH_CARD, 1))).  %% 月卡的有效时长 这里从配置的天数奖励判断