%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2019 0:30
%%%-------------------------------------------------------------------
-author("whao").

%%  base_adventure_info  开启配置
-record(adventure_info_cfg, {
    stage = 0,                          %% 期数
    open_day = [],                      %% 开服开始与结束时间
    merge_day = [],                     %% 合服开始与结束时间
    start_time = 0,                     %% 开始时间
    end_time = 0                        %% 结束时间
}).

%%  base_adventure_rand   骰子点数
-record(adventure_rand_cfg, {
    low_point = 0,                      %% 下限骰子点数
    high_point = 0,                     %% 上限骰子点数
    cost = [],                          %% 消耗
    weight = []                         %% 点数权重
}).


%%  base_adventure_loc  格子奖励配置
-record(adventure_loc_cfg, {
    stage = 0,                          %% 期数
    up_turn = 0,                        %% 轮数上限
    down_turn = 0,                      %% 轮数下限
    location = 0,                       %% 格子位置
    type = 0                            %% 宝箱种类
}).


%%  base_adventure_reward  宝箱奖励
-record(adventure_reward_cfg, {
    id = 0,                             %% id
    stage = 0,                          %% 期数
    type = 0,                           %% 宝箱种类
    weigh = 0,                          %% 权重
    reward = []                         %% 奖励列表
}).

%%  base_adventure_kv   kv 配置
-record(adventure_kv_cfg, {
    key = 0,                          %% 期数
    name = [],                        %% 命名
    value = [],                       %% 值
    desc = ""                         %% 描述
}).

%% base_adventure_shop  冒险商城配置
-record(adventure_shop_cfg, {
    id = 0,         %% 奖励id
    type = 0 ,      %% 奖励类型 0：免费 1：随机
    reward = [],    %% 奖励列表
    show_price = 0, %% 原价
    price = 0,      %% 现价
    weight = [],    %% 权重
    over_cheap = 0  %% 是否超值
}).


%% base_adventure_shop_refresh  商城刷新配置
-record(adventure_shop_refresh_cfg,{
    low_refresh = 0,     %% 刷新次数下限
    high_refresh = 0,    %% 刷新次数上限
    cost = []            %% 消耗
}).


%% 天天冒险玩家记录
-record(status_adventure,{
    stage = 0,				% 当前期数
    circle = 1,				% 当前圈数
    location = 0,			% 当前位置
    gain_list = [],   		% 当轮圈已获得的奖励 (下圈清)
    shop_goods = [],        % 商品的状态 [{goods_id, state}]  state: 0没有购买 1： 已经购买
    last_time               % 最近的商城操作时间
}).



-define(MAX_LOCATION,   30).  % 最大格子数
-define(INIT_CIRCLE,    1).   % 初始圈数
-define(INIT_LOCATION,  0).   % 初始位置


-define(ADVEN_RESET_NUM, 1).  % 计数器每日重置次数
-define(ADVEN_THROW_NUM, 2).  % 计数器每日投掷次数
-define(ADVEN_SHOP_RESET_NUM, 3).  % 商城每日重置次数
-define(ADVEN_FREE_RESET_NUM, 4).  % 计数器每日免费重置次数
-define(ADVEN_FREE_THROW_NUM, 5).  % 额外免费投掷次数



-define(ADVEN_SHOP_NOT_BUY, 0) .    % 没有购买状态
-define(ADVEN_SHOP_HAS_BUY, 1) .    % 已经购买状态

%% ---------------------------------------------------------------------------
%% sql定义
%% ---------------------------------------------------------------------------
-define(sql_adventure_select, <<
    "select `stage`,`circle`,`location`, `gain_lucky`, `shop_goods`, `last_time` from adventure_role where role_id= ~p ">>).

-define(sql_adventure_replace, <<
    "replace into adventure_role(`role_id`,`stage`,`circle`,`location`,`gain_lucky`, `shop_goods`, `last_time`)  values(~p, ~p, ~p, ~p,'~s', '~s', ~p)">>).
