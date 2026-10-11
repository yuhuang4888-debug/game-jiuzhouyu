%%% 充值标志位
%%% 注: 如同时达成首充和添加有礼金额,标志位会是 2#01 bor 2#10 = 2#11 = 10#3
%%%     往后如有另外类似首充金额的扩展需求可以直接扩展标志位位数,目前数据库字段支持8位
-define(RECHARGE_FIRST,  1). % 首充金额达成 2#01
-define(RECHARGE_FIRST2, 2). % 添加有礼金额达成 2#10

%%%---------------------------------------------------------------------
%%% 充值相关record定义
%%%---------------------------------------------------------------------
-record (recharge_status, {
        return_data     = #{},             %% 充值返利#{{product_id, return_type} => time}
        % first_data      = {0,0}            %% {礼包状态, 操作时间} 注：首充礼包状态 0未购买，1购买未领取，2已领取
        first_data      = undefined        %% #recharge_first_data{} 注：首充礼包状态 0未购买，1购买未领取，2已领取
        }).

%% 首充
-record(recharge_first_data, {
        is_buy = 0              % 是否购买##0:没有充值;大于0就是充值
        , time = 0              % 操作时间
        , index_list = []       % 领取列表##[]
        , login_days = 0        % 登录天数
        , days_utime = 0        % 登录天数更新时间
    }).

%% 玩家充值统计
% TODO-TA:实现充值金额统计
-record(role_recharge_statistic, {
        total_money = 0         % 总金额
        , recency = 0           % 评级：充值间隔   last_pay_time与登录时间戳相差的天数区间
        , frequency = 0         % 评级：充值频率   最近30天内的充值次数
        , monetary = 0          % 评级：历史总充值
        , top = 0               % 评级：最高额充值
    }).

%%%------------------------------配置相关------------------------------
%% 充值商品配置
-record (base_recharge_product, {
        product_id       = 0,              %% 商品id(0:特殊商品id：0任意充值的的额度)
        product_name     = "",             %% 商品名称
        product_type     = 0,              %% 商品大类:1常规充值 2福利卡 3每日礼包 4首冲礼包 99审核专用
        product_subtype  = 0,              %% 商品子类
        money            = 0,              %% 商品价格
        associate_list   = [],             %% 关联商品 [{商品大类,商品子类}]
        about            = "",             %% 描述
        show_condition   = []              %% 展示条件
    }).

%% 充值商品控制台配置
-record (base_recharge_product_ctrl, {
        product_id       = 0,              %% 商品id
        start_time       = 0,              %% 活动开始时间
        end_time         = 0,              %% 活动结束时间
        week_time_list   = [],             %% 周几开启
        month_time_list  = [],             %% 每月第几天开启
        open_begin       = 0,              %% 开服开始天数
        open_end         = 0,              %% 开服结束天数
        merge_begin      = 0,              %% 合服开始天数
        merge_end        = 0,              %% 合服结束天数
        serv_lv_begin    = 0,              %% 服务器等级开始
        serv_lv_end      = 0,              %% 服务器等级结束
        condition        = []              %% 其它条件 []
    }).

-record (base_recharge_return, {
        product_id       = 0,              %% 商品id
        return_type      = 0,              %% 返利类型 0:无返利、1:终生首次、2:活动时间返利
        gold             = 0,              %% 基础钻石
        return_gold      = 0               %% 返利钻石
    }).

-record (daily_recharge, {
    zero_time,      %% 0点时间戳
    total_gold,     %% 这一天的总元宝
    total_rmb,      %% 这一天的总金额
    detail = []     %% 详细 [[时间戳, 元宝, 金额]]
    }).
