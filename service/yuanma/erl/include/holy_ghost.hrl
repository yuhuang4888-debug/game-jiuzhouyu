%%-----------------------------------------------------------------------------
%% @Module  :       holy_ghost.hrl
%% @Author  :       Fwx
%% @Created :       2018-5-28
%% @Description:    圣灵头文件
%%-----------------------------------------------------------------------------

-define(ACTIVE, 1).
-define(TIMEOUT, 0).

-define(HOLY_GHOST_DISPLAY, 1).
-define(HOLY_GHOST_HIDE, 0).

%% 圣灵配置
-record(base_holy_ghost, {
    id        = 0,          %% 圣灵id
    name      = "",         %% 名称
    active_cost = [],       %% 激活消耗
    stage_cost = [],        %% 升阶消耗列表 [{物品Id, 提供的升阶经验值}]
    fight_skill = [],       %% 出战技能 [{技能id, 技能等级}]
    trigger_type = 0,       %% 3 攻击者计算伤害后触发  4 防守者计算伤害后触发
    trigger_prob = 0,       %% 触发概率
    norm_skill = [],        %% 被动增益技能 [{技能id, 激活指定阶数}]
    attr      = [],         %% 当阶属性
    figure_id = 0           %% 形象Id
}).

%% 圣灵升阶配置
-record(base_holy_ghost_stage, {
    id        = 0,          %% 圣灵id
    stage     = 0,          %% 阶数
    exp       = 0,          %% 升阶所需经验
    is_tv     = 0,          %% 是否发传闻
    attr      = []          %% 当阶属性
    }).

%% 圣灵觉醒配置
-record(base_holy_ghost_awake, {
    id        = 0,          %% 圣灵id
    lv        = 0,          %% 觉醒等级
    cost      = [],         %% 觉醒到此等级的消耗
    fight_skill_lv = [],    %% 出战技能等级 [{SkillId, Lv}...]
    attr      = []          %% 当级属性
}).

%% 圣灵幻形配置
-record(base_holy_ghost_figure, {
    id        = 0,          %% 幻形id
    name      = "",         %% 名称
    active_cost = [],       %% 激活消耗
    effect_time = 0,        %% 时效 秒 0为永久
    skill     = [],         %% 替换的出战技能
    trigger_type = 0,       %% 3 攻击者计算伤害后触发  4 防守者计算伤害后触发
    trigger_prob = 0,       %% 触发概率
    attr      = [],         %% 属性
    figure_id = 0           %% 形象id
}).

%% 圣灵遗迹配置
-record(base_holy_ghost_relic, {
    good_id   = 0,          %% 遗迹物品Id
    id        = 0,          %% 遗迹id
    attr      = [],         %% 属性
    num_limit = []          %% 次数上限 [{人物等级下限, 人物等级上限, 次数}
}).

%% 圣灵遗迹开启配置
-record(base_holy_ghost_relic_open, {
    id        = 0,          %% 遗迹id
    name      = "",         %% 名称
    lv_limit  = 0,          %% 等级限制
    figure_id = 0           %% 资源Id
}).

%% 圣灵结界配置
-record(base_holy_ghost_bound, {
    id        = 0,          %% 条件id
    attr      = [],         %% 属性
    condition = []          %% 激活条件 [{Num, Stage}] 同时上阵Num个Stage阶的圣灵
}).

%% 圣灵结界技能配置
-record(base_holy_ghost_bound_skill, {
    id        = 0,          %% 条件id
    skill     = [],         %% 技能 [{技能id, 技能等级}]
    condition = []          %% 激活条件 [{圣灵id, 觉醒等级}...]上阵指定的圣灵组合 且达到指定的觉醒等级
}).


-record(status_holy_ghost, {
    ghost = [],             %% [#ghost{}] 基本圣灵列表
    ghost_illu = [],        %% [#ghost_illu{}] 拥有幻形列表
    bound_ids = [],         %% 结界 [{location, 圣灵id}]
    fight_id = 0,           %% 出战圣灵id
    illus_id = 0,           %% 幻形id
    fight_skill = [],       %% 出战技能 [{SkillId, SkillLv}]
    norm_skill = [],        %% 总普通增益技能 [{SkillId, SkillLv}]
    bound_skill = [],       %% 结界技能
    passive_skill = [],     %% 被动技能
    ghost_attr = [],        %% 基本圣灵属性
    illu_attr = [],         %% 幻形属性
    bound_attr = [],        %% 结界属性
    relic_attr = [],        %% 遗迹属性
    attr = [],              %% 总属性
    battle_attr = undefined,  %% 战斗相关属性
    figure_id = 0,          %% 当前形象id
    display = 1,            %% 显示/隐藏状态
    combat = 0              %% 战力
}).

-record(ghost, {
    id = 0,                  %% 圣灵id
    fight_skill = [],        %% 出战技能
    norm_skill = [],         %% 普通技能
    stage = 0,               %% 阶数
    exp = 0,                 %% 经验值
    lv = 0,                  %% 觉醒等级
    active_time = 0,         %% 激活时间戳
    attr = [],
    combat = 0
}).

-record(ghost_illu, {
    id = 0,                  %% 幻形id
    fight_skill = [],        %% 出战技能
    active_time = 0,         %% 激活时间戳
    effect_time = 0,         %% 生效时间
    attr = [],
    combat = 0
}).



%% ------------------------------------------------------

-define(sql_player_holy_ghost_select,
    <<"select fight_id, illu_id, display, bound
    from player_holy_ghost where role_id = ~p">>).

-define(sql_holy_ghost_select,
    <<"select id, stage, exp, lv, active_time
     from holy_ghost where role_id = ~p">>).

-define(sql_holy_ghost_illu_select,
    <<"select id, active_time, effect_time
     from holy_ghost_illu where role_id = ~p">>).

-define(sql_replace_holy_ghost,
    <<"replace into holy_ghost
    (role_id, id, stage, exp, lv, active_time) values(~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_replace_holy_ghost_illu,
    <<"replace into holy_ghost_illu
    (role_id, id, active_time, effect_time) values(~p, ~p, ~p, ~p)">>).

-define(sql_replace_player_holy_ghost,
    <<"replace into player_holy_ghost
    (role_id, fight_id, illu_id, display, bound) values(~p, ~p, ~p, ~p, ~p)">>).

-define(sql_delete_holy_ghost_illu,
    <<"delete from holy_ghost_illu where role_id = ~p and id = ~p">>).