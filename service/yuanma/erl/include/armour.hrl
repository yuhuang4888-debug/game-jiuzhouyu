%%% ---------------------------------------------------------------------------
%%% @doc            armour.hrl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @since          2021-03-08
%%% @description    战甲头文件
%%% ---------------------------------------------------------------------------

%%% ================================ 宏变量 ================================

%% 战甲类型
-define(ARMOUR_INSPIRE,     1).     % 启源战甲
-define(ARMOUR_SAINT,       2).     % 圣遗战甲

%% 激活/打造状态
-define(UN_ACTIVATED,       0).     % 未激活(套装)/未打造(部位)
-define(ACTIVATED,          1).     % 已激活(套装)/已打造(部位)

%% kv值
-define(ARMOUR_KV(Key),     data_armour:get(Key)).
-define(ARMOUR_INSPIRE_POS, ?ARMOUR_KV(1)).     % 启源战甲部位列表
-define(ARMOUR_SAINT_POS,   ?ARMOUR_KV(2)).     % 圣遗战甲部位列表

%%% ================================ 配置数据record ================================

%% 战甲套装配置
-record(base_armour_suit, {
    stage       = 0         % 战甲阶数
    ,type       = 0         % 战甲类型 1 启源 2 圣遗
    ,open_lv    = 0         % 开放等级
    ,attr       = []        % 套装属性
}).

%% 战甲套装部位配置
-record(base_armour_equipment, {
    id          = 0         % 装备部位物品id
    ,stage      = 0         % 战甲阶数
    ,type       = 0         % 战甲类型 1 启源 2 圣遗
    ,pos        = 0         % 装备位置
    ,pre_stage  = 0         % 前置阶数
    ,consume    = []        % 激活消耗
    ,attr       = []        % 装备基础属性
}).

%%% ================================ 普通数据record ================================

%% 玩家战甲状态
-record(armour, {
    armour_map  = #{}       % 战甲打造状态 #{{stage, type} => [Pos...]} Pos :: integer()
    ,attr       = []        % 战甲累积属性
}).

%%% ================================ sql宏定义 ================================

%% armour表
-define(SQL_ARMOUR_SELECT,
    <<" select stage, type, pos_list
        from armour
        where player_id=~p">>).
-define(SQL_ARMOUR_REPLACE,
    <<" replace into armour
        (player_id, stage, type, pos_list)
        values (~p, ~p, ~p, '~s')">>).