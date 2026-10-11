%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%% 精灵
%%% @end
%%% Created : 07. 十二月 2018 16:11
%%%-------------------------------------------------------------------
-author("whao").


%% 精灵形象配置
-record(fairy_info_cfg, {    % base_fairy_info
    fairy_id = 0,            % 外形类型id
    name = [],               % 名字
    figure_id = 0 ,          % 精灵形象
    unlock_skill = []        % 技能列表 [{技能id, 解锁阶数}]  (客户端显示)
}).


%% 精灵升阶配置
-record(fairy_stage_cfg, {   % base_fairy_stage
    fairy_id = 0,            % 精灵类型id
    stage = 0,               % 阶数
    attr = [],               % 属性
    cost = [],               % 消耗道具
    skill_list = []          % 技能列表
}).

%% 精灵经验道具
-record(fairy_prop_cfg, {% base_fairy_prop
    goods_id = 0,        % 物品ID
    exp = 0              % 经验值
}).


%% 精灵升级配置
-record(fairy_level_cfg, {  % base_fairy_level
    fairy_id = 0,           % 精灵类型id
    level = 0,              % 等级
    attr = [],              % 属性
    exp = 0                 % 经验值
}).

%% 总精灵的数据
-record(fairy, {
    battle_id = 0,         % 出战 id
    attr = [],             % 总属性
    power = 0,             % 主动技能的战力
    fairy_list = []        % [#fairy_sub{}]
}).


%% 单个精灵的数据
-record(fairy_sub, {
    fairy_id = 0,            % 精灵类型id
    stage = 0,               % 阶数
    level = 0,               % 等级
    exp = 0,                 % 经验值
    combat = 0,              % 属性战力
    skill_list = [],         % 技能列表  skill_id 技能id
    attr_list = []           % 属性列表  {属性类型, 属性值}  总属性 = 阶级属性 + 技能属性 (主动技能加战力值  )+ 等级属性
}).

-define(STAGE_INIT, 0). % 初始阶段
-define(LEVEL_INIT, 0). % 初始等级
-define(EXP_INIT, 0). % 初始经验

%%------------- 数据库处理 ---------------
%% 获取精灵数据
-define(sql_select_fairy,
    <<"select battle_id, attr from player_fairy where role_id = ~p">>).

%% 获取精灵的出站id
-define(sql_select_fairy_battle_id,
    <<"select battle_id from player_fairy where role_id = ~p">>).

%% 更新精灵数据
-define(sql_replace_fairy,
    <<"replace into player_fairy(role_id, battle_id, attr) values(~p, ~p, '~s')">>).

%% 更新出站精灵
-define(sql_update_fairy_battle_id,
    <<"update player_fairy set battle_id = ~p where role_id = ~p">>).



%% 获取精灵id数据
-define(sql_select_all_fairy_sub,
    <<"select fairy_id, stage, level, exp, combat, skill_list, attr_list from player_fairy_sub where role_id = ~p">>).

%% 更新精灵id数据
-define(sql_replace_fairy_sub,
    <<"replace into player_fairy_sub(role_id, fairy_id, stage, level, exp, combat, skill_list, attr_list) values(~p, ~p, ~p, ~p, ~p, ~p, '~s', '~s')">>).

%% 更新精灵
-define(sql_update_fairy_sub_lev,
    <<"update player_fairy_sub set level = ~p where role_id = ~p and fairy_id =~p ">>).









