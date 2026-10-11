%% state
-record(soul, {
    soul_point = 0,                     % 聚魂经验
    equip_add_ratio_attr = []           % 装备增加的属性加成
}).

%% 聚魂槽位
-record(soul_pos_con, {
    soul_pos = 0,                       % 槽位
    condition = [],                     % 条件
    type = 0                            % 类型（1：高级 2：普通）
}).

%% 聚魂数值
-record(soul_attr_num_con, {
    sub_type = 0,                       % 子类型
    lv= 0,                              % 等级
    attr_num_list = [],                 % 属性数值列表
    lv_up_num= 0                        % 升级经验数值
}).

%% 聚魂系数
-record(soul_attr_coefficient_con, {
    sub_type = 0,                       % 子类型
    quality= 0,                         % 品质
    kind= 0,                            % 灵魂种类 ( 1：高级 2：普通 )
    attr_coefficient_list = [],         % 属性数值列表
    lv_up_coefficient = 0 ,             % 升级系数
    attr_num = 0                        % 属性数量
}).

%%  聚魂觉醒拆解配置表
-record(soul_awake_con,{
    quality = 0,        % 品质
    attr_id = 0,        % 属性id
    lv = 0,             % 觉醒等级
    cost = [],          % 觉醒消耗
    back_cost = [],     % 拆解返还
    attr_list = []      % 加成属性
}).


%% 更新玩家id 聚魂经验
-define(ReplaceSoulSql,
    <<"replace into `soul_player` (`role_id`, `soul_point`) values (~p, ~p)">>).

%% 选择玩家id 聚魂经验
-define(SelectSoulSql,
    <<"select `role_id`, `soul_point` from `soul_player` WHERE `role_id` = ~p">>).