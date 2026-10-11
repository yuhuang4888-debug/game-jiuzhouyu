%% ---------------------------------------------------------------------------
%% @doc dragon_ball
%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/8/11
%% @modify  2022/10/31 by kuangyaode
%% @deprecated  龙珠头文件
%% ---------------------------------------------------------------------------

%%% ======================================= variable macros ========================================

%% kv
-define(DRAGON_BALL_KV(Key),  data_dragon_ball:get(Key)).

-define(DRAGON_STATUE_RECHARGE_ID, ?DRAGON_BALL_KV(3)). % 雕像商品Id
-define(DRAGON_STATUE_SKILLS,      ?DRAGON_BALL_KV(4)). % 雕像技能列表
-define(DRAGON_STATUE_ATTR,        ?DRAGON_BALL_KV(5)). % 雕像属性列表
-define(DRAGON_STATUE_OP_LV,       ?DRAGON_BALL_KV(6)). % 雕像开放等级
-define(DRAGON_STATUE_OP_DAY,      ?DRAGON_BALL_KV(7)). % 雕像开放开服天数

%% 龙珠激活状态
-define(UNACTIVE, 0).
-define(ACTIVE,   1).

%% 星核购买状态
-define(NO_BUY,         0).     %% 未购买
-define(ALREADY_BUY,    1).     %% 已购买

%% 龙珠套装操作
-define(TAKE_ON,  1). % 穿戴
-define(TAKE_OFF, 2). % 脱下
-define(NULL_FIGURE, 0). % 0套装类型，穿上等于脱下当前套装

%%% ======================================== config records ========================================

%% 龙珠基础配置
-record(base_dragon_ball, {
    id = 0,
    name = <<>>,
    lv = 0,
    cost = [],
    skill = [],
    attr = []
}).

%% 龙珠套装配置
-record(base_dragon_ball_figure, {
    id = 0, % 目前仅用以为每个套装赋予id并替代figure中的liveness字段，主要还是使用 {type, lv} 元组来进行套装的规则计算
    name = "",
    type = 0,
    lv = 0,
    conditions = [], % [{pre, Type, Lv} :: 前提条件(Type类型Lv等级的套装要先激活),
                     %  {dragon_ball, N, X} :: N个龙珠要达到X级]
    attr = []
}).

%%% ======================================== general records =======================================

%% 玩家龙珠状态
-record(status_dragon_ball, {
    statue = ?UNACTIVE, % 雕像激活状态
    attr = [],          % 属性 [{雕像属性-statue_attr, []}, {龙珠属性-ball_attr, []}, {神龙形象属性-figure_attr, []}]
    skill_power = 0,
    skill_attr = [],
    skills = [],        % 被动技能
    items = [],         % 龙珠状态 [{id, lv, power}|_]
    figure_type = 0,    % 当前神龙形象类型 - Type
    figure_list = [],    % 已激活的神龙形象列表 [{Type, Lv}, ...]
    nuclear_buy = []     % 星核直购购买 [id, state, time]
}).

%%% ======================================== general records =======================================

%% 玩家龙珠直购配置
-record(base_star_nuclear, {
    id = 0,             % 礼包id
    good_id = 0,        % 物品id
    name = [],          % 礼包名字
    open_lv = 0,        % 开启等级
    open_day = 0,       % 开启天数
    price = 0,          % 价格
    reward = [],        % 奖励
    recharge_id = 0,    % 充值id
    send_id = 0,        % 推送id
    times_limit = 0     % 购买次数限制
}).

%%% ========================================== sql macros ==========================================

%% role_dragon_ball_status

-define(sql_select_dragon_ball_statue, <<"
    select statue, figure_type, figure_list, nuclear_buy
    from role_dragon_ball_status
    where role_id=~p
">>).

-define(sql_replace_dragon_ball_statue, <<"
    replace into role_dragon_ball_status
    (role_id, statue, figure_type, figure_list, nuclear_buy)
    values (~p, ~p, ~p, '~s', '~s')
">>).


%% role_dragon_ball

-define(sql_load_dragon_ball, <<"
    SELECT `ball_id`, `ball_lv`
    FROM `role_dragon_ball`
    WHERE `role_id` = ~p"
>>).

-define(sql_replace_dragon_ball, <<"
    REPLACE INTO `role_dragon_ball`
    (`role_id`, `ball_id`, `ball_lv`)
    VALUES (~p, ~p, ~p)"
>>).
