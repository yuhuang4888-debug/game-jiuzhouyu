%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%% 幻饰
%%% @end
%%% Created : 03. 十二月 2018 10:40
%%%-------------------------------------------------------------------
-author("whao").

-define(TOTAL_CELL_NUM, 6).             %% 总的装备格子数

-record(decoration,{
    level_list = [],                    %  {pos, level}     {部位， 强化等级}
    pos_goods = [] ,                    %  {pos, goods_id}  {部位， 物品id}
    attr = [],                          %  属性
    unlock_cell_list = []               %  解锁部位
}).


%%  键值表
-record(dec_kv_cfg,{    % base_decoration_kv
    key = 0,            % 键
    value = 0,          % 值
    desc = []           % 描述
}).

%% 幻饰装备属性
-record(dec_attr_cfg,{      % base_decoration_attr   参数： goods_id
    goods_id = 0,           % 物品类型id
    stage = 0,              % 装备阶数
    star = 0,               % 装备星级    (客户端)
    base_rating = 0,        % 基础装备评分(客户端)
    recommend_attr = [],    % 推荐属性    (客户端)
    color_attr = []         % 颜色属性列表 [{颜色,数量,[{权重,属性类型,属性值,评分}]}]
}).

%% 幻饰强化上限配置
-record(dec_level_max_cfg,{ % base_decoration_level_max   参数：  pos  stage color
    pos = 0,                % 部位
    stage = 0,              % 阶数
    color = 0,              % 颜色
    limit_level = 0         % 强化上限
}).

%% 幻饰强化属性配置
-record(dec_level_cfg,{ % base_decoration_level   参数： pos   level
    pos = 0,            % 部位
    level = 0,          % 强化等级
    cost = [] ,         % 升级消耗
    attr = []           % 属性
}).

%% 幻饰进阶上限
-record(dec_stage_max_cfg, {  % base_decoration_stage_max   参数 player_lv
    player_level = 0,         % 角色等级
    limit_stage = 0           % 可穿戴阶数上限
}).

%% 幻饰进阶配置
-record(dec_stage_cfg, {    % base_decoration_stage    参数 : goods_id
    goods_id = 0 ,          % 物品id
    cost = [],              % 物品消耗
    new_goods_id = 0        % 进阶物品id
}).

%% 幻饰部位的数量
-define(DECORATION_CELL_NUM , 6).

-define(SELET_DECORATION_LEVEL_LIST,
    <<"select pos, level from  decoration_level where player_id = ~p">>).

-define(REPLACE_DECORATION_LEVEL,
    <<"replace into decoration_level(player_id, pos, level) values(~p, ~p, ~p)">>).

-define(SELECT_DECORATION_UNLOCK_CELL,
    <<"select unlock_list from  decoration_unlock_cell where role_id = ~p">>).

-define(REPLACE_DECORATION_UNLOCK_CELL,
    <<"replace into decoration_unlock_cell(role_id, unlock_list) values(~p, '~s')">>).

%%-define(ReplaceRuneSql,
%%    <<"replace into `rune_player` (`role_id`, `rune_point`, `rune_chip`) values (~p, ~p, ~p)">>).

%%-define(SelectRuneSql,
%%    <<"select `role_id`, `rune_point`, `rune_chip` from `rune_player` WHERE `role_id` = ~p">>).
%%
%%
%%

















