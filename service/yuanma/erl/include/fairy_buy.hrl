%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%         仙灵直购系统
%%% @end
%%% Created : 12. 7月 2022 9:32
%%%-------------------------------------------------------------------

-define(not_activate,   0).     %% 未激活
-define(activate,       1).     %% 已激活

%% 直购礼包配置
-record(fairy_buy_cfg, {    % base_fairy
    id = 0,                  % 仙灵直购id
    name = [],               % 名字
    shape = 0 ,              % 仙灵直购模型id
    open_lv = 0,             % 开启等级
    open_day = 0,            % 开启天数
    price = 0,               % 价格
    module = 0,              % 模块id
    recharge_id = 0,         % 充值id
    show_price = 0           % 折扣假价格


}).

%% 直购礼包节点配置
-record(fairy_buy_node_cfg, {
    fairy_id = 0,       %% 仙灵直购id
    fairy_lv = 0,       %% 仙灵直购等级
    condition = [],     %% 激活条件
    type = 0,           %% 节点类型
    attr = [],          %% 节点属性
    skill = []          %% 节点技能
}).

%% 直购礼包玩家数据
-record(status_fairy_buy, {
    fairy_id = 0,       %% 仙灵id
    node_list = [],     %% 激活的节点列表
    attr = [],          %% 属性
    skill = []          %% 技能
}).

%% ---------------------------- sql --------------------------
-define(sql_fairy_buy_select, <<"select fairy_id, node_list from player_fairy_buy where role_id = ~p">>).
-define(sql_fairy_buy_replace, <<"replace into player_fairy_buy(role_id, fairy_id, node_list) values(~p,~p, '~s')">>).