%%-----------------------------------------------------------------------------
%% @Module  :       pet
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-10-12
%% @Description:    宠物
%%-----------------------------------------------------------------------------

-define(HIDE, 0).                               %% 隐藏状态
-define(DISPLAY, 1).                            %% 显示状态

-define(PET_MIN_STAGE, 1).                      %% 宠物最小阶数
-define(PET_MIN_STAR, 1).                       %% 宠物最小星数
-define(PET_MIN_LV, 1).                         %% 宠物最小等级

-define(PET_BASE_SKILL, 1).                      %% 坐骑基础技能
-define(PET_ILLUSION_SKILL, 2).                  %% 坐骑幻形技能

-define(BASE_PET_FIGURE, 1).                     %% 基础形象
-define(ILLUSION_PET_FIGURE, 2).                 %% 幻形激活的形象

%% 宠物阶数配置
-record(pet_stage_cfg, {
    stage = 0,
    name = "",
    figure = 0,
    max_star = 0,
    is_tv = 0}).

%% 宠物星级配置
-record(pet_star_cfg, {
    stage = 0,
    star = 0,
    max_blessing = 0,
    attr = [],
    combat = 0}).

%% 宠物等级配置
-record(pet_lv_cfg, {
    lv = 0,
    max_exp = 0,
    attr = [],
    combat = 0,
    is_tv = 0}).

%% 宠物培养道具配置
-record(pet_goods_cfg, {
    goods_id = 0,
    attr = [],
    combat = 0,
    max_times = 0}).

%% 道具吞噬配置
-record(pet_goods_exp_cfg, {
    stage = 0,                  %% 道具为 0
    color = 0,                  %% 道具为 0
    star = 0,                   %% 道具为 0
    goods_id = 0,               %% 装备类型为 0 道具类型则为物品id
    exp = 0}).

%% 宠物技能配置
-record(pet_skill_cfg, {
    skill_id = 0,               %% 技能id
    type = 0,                   %% 1: 基础技能 2: 幻形技能
    ownership_id = 0,           %% 归属id 幻形技能填所属的幻形id
    stage = 0                   %% 解锁阶段
    }).

%% 宠物幻形形象配置
-record(pet_figure_cfg, {
    id = 0,                     %% 幻形id
    name = "",                  %% 名字
    desc = "",                  %% 描述
    figure = 0,                 %% 形象资源id
    goods_id = 0,               %% 激活物品id
    goods_num = 0,              %% 激活物品数量
    goods_exp = 0,              %% 激活道具做培养材料时候提供的经验值
    stage_lim = 0,              %% 阶数限制 需要坐骑达到多少阶才能培养
    skill_list = [],            %% 拥有的技能列表(客户端使用)
    nskill_id = 0,              %% 普攻技能id
    is_tv = 0                   %% 激活传闻
    }).

%% 宠物幻形等阶配置
-record(pet_figure_stage_cfg, {
    id = 0,                     %% 幻形id
    stage = 0,                  %% 等阶
    blessing = 0,               %% 升阶所需祝福值
    attr = [],                  %% 当前阶属性
    combat = 0,                 %% 战力
    is_tv = 0                   %% 升阶传闻
    }).

-record(status_pet, {
    stage = 0,                  %% 宠物阶数
    star = 0,                   %% 宠物星级
    lv = 0,                     %% 等级
    blessing = 0,               %% 祝福值
    exp = 0,                    %% 经验值
    illusion_type = 0,          %% 幻化类型
    illusion_id = 0,            %% 幻形id
    figure_id = 0,              %% 当前使用的形象id
    figure_list = [],           %% 已激活的幻形形象列表[#pet_figure{}]
    base_attr = [],             %% 基础属性
    attr = [],                  %% 总的加成属性(基础属性+等阶属性+飞行器属性)
    figure_attr = [],           %% 幻形属性(等阶属性+技能属性)
    special_attr = #{},         %% 特殊属性
    skills = [],                %% 解锁的技能
    figure_skills = [],         %% 幻形解锁的技能
    passive_skills = [],        %% 被动技能
    base_combat = 0,            %% 基础属性战力
    combat = 0,                 %% 宠物战力(基础属性战力+星阶战力+等级战力)
    battle_attr = undefine,     %% 战宠战斗相关属性
    display_status = 0,         %% 0: 隐藏 1: 显示
    pet_aircraft = undefine,
    pet_wing = undefine,
    pet_equip = undefine
    }).

-record(pet_figure, {
    id = 0,                     %% 幻化形象id
    stage = 0,                  %% 幻化形象阶数
    blessing = 0,               %% 祝福值
    attr = [],                  %% 属性
    skills = [],                %% 解锁技能
    combat = 0                  %% 战力
    }).

-record(pet_aircraft, {
    role_id = 0,
    aircraft_list = [],
    aircraft_attr = [],
    add_pet_attr = [],           %% 增加给精灵的属性
    aircraft_skills = [],        %% 被动技能
    show_id = 0,                 %% 使用中的飞行器id
    perform_id = 0,              %% 飞行器资源id
    if_show = 0                  %% 是否显示 0不显示 1显示
    }).

-record(aircraft_info, {
    aircraft_id = 0,
    stage = 0
    }).

-record(pet_wing, {
    role_id = 0,
    wing_list = [],
    wing_attr = [],
    add_pet_attr = [],              %% 增加给精灵的属性
    wing_skills = [],               %% 被动技能
    show_id = 0,                    %% 使用中的翅膀id
    perform_id = 0,                 %% 翅膀资源id
    if_show = 0,                    %% 是否显示 0不显示 1显示
    limit_wing_id = 0,              %% 下一个限时精灵翅膀id
    limit_timer = 0                 %% 限时幻形计时器
}).

-record(wing_info, {
    wing_id = 0,
    stage = 0,
    end_time = 0                  %% 限时结束时间
}).

-record(pet_equip, {
    role_id = 0,
    pet_equip_attr = []
}).

-record(pet_equip_pos, {
    pos = 0,
    pet_equip_point = 0
}).

-record(pet_aircraft_info_con, {
    aircraft_id = 0,
    aircraft_name = "",
    active_cost = [],
    active_condition = [],
    image_id = 0,
    perform_id = 0,
    skill_list = [],
    type = 0
    }).

-record(pet_aircraft_stage_con, {
    aircraft_id = 0,
    stage = 0,
    cost_list = [],
    attr_list = [],
    if_send_tv = 0
    }).

-record(pet_wing_info_con, {
    wing_id = 0,
    wing_name = "",
    active_cost = [],
    active_condition = [],
    image_id = 0,
    perform_id = 0,
    skill_list = [],
    type = 0,
    time_limit = 0
}).

-record(pet_wing_stage_con, {
    wing_id = 0,
    stage = 0,
    cost_list = [],
    attr_list = [],
    if_send_tv = 0
}).

%% 精灵装备品质阶数配置表
-record(pet_equip_stage_con, {
    type_id = 0,            % 外形种类
    pos = 0,                % 部位
    stage = 0,              % 阶数
    attr_list = [],         % 属性列表
    color = 0,              % 颜色
    exp = 0,                % 消耗所得等级经验
    limit_pos_lv = [],      % 限制的部位等级上限
    cost_list = []          % 升级消耗
}).

%% 精灵装备星数配置表
-record(pet_equip_star_con, {
    type_id = 0,            % 外形种类
    pos = 0,                % 部位
    star = 0,               % 星数
    attr_list = [],         % 属性
    exp = 0,                % 消耗所得等级经验
    cost_list = []          % 升星消耗
}).

%% 精灵装备部位等级配置表
-record(pet_equip_pos_lv_con, {
    type_id = 0,            % 外形种类
    pos = 0,                % 部位
    pos_lv = 0,             % 部位等级
    attr_list = [],         % 属性列表
    exp = 0                 % 升级所需经验
}).

%% 精灵装备部位配置表
-record(pet_equip_pos_con, {
    type_id = 0,            % 外形种类
    pos = 0,                % 部位
    condition = []  ,       % 条件
    pos_name = []           % 名称
}).

%% 精灵装备物品配置表
-record(pet_equip_goods_con, {
    goods_type_id = 0,      % 物品id
    type_id = 0,            % 外形id
    pos = 0,                % 部位id
    stage = 0,              % 初始阶数
    star = 0,               % 星数
    player_lv_limit = 0,    % 玩家等级限制
    pet_stage_limit = 0     % 精灵阶数限制
}).


%% 外形装备全身奖励
-record(figure_whole_reward_con, {
    id = 0,                            %% 全身加成奖励id
    type_id = 0,                       % 外形id
    type = 0,                          %% 类型 1.强化 2.宝石
    need_lv = 0,                       %% 类型对应的总级别
    next_nlv = 0,                      %% 下一阶段需要的类型对应的总级别
    attr_list = []                     %% 属性列表[{属性类型,属性值}]
}).

%% ------------------------------------------------------

-define(sql_player_pet_select,
    <<"select stage, star, lv, blessing, exp, base_attr, illusion_type, illusion_id, display_status from player_pet where role_id = ~p">>).

-define(sql_player_pet_figure_select,
    <<"select id, stage, blessing from player_pet_figure where role_id = ~p">>).

-define(sql_player_pet_insert,
    <<"insert into player_pet (role_id, stage, star, lv, illusion_type, illusion_id, display_status) values (~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_update_pet_illusion_and_display,
    <<"update player_pet set illusion_type = ~p, illusion_id = ~p, display_status = ~p where role_id = ~p">>).

-define(sql_update_pet_display_status,
    <<"update player_pet set display_status = ~p where role_id = ~p">>).

-define(sql_update_pet_base_attr,
    <<"update player_pet set base_attr = '~s' where role_id = ~p">>).

-define(sql_update_pet_stage_and_star,
    <<"update player_pet set stage = ~p, star = ~p, blessing = ~p, illusion_id = ~p where role_id = ~p">>).

-define(sql_update_pet_lv,
    <<"update player_pet set lv = ~p, exp = ~p where role_id = ~p">>).

-define(sql_update_pet_illusion_info,
    <<"replace into player_pet_figure(role_id, id, stage, blessing) values(~p, ~p, ~p, ~p)">>).

-define(sql_pet_aircraft_player_select,
    <<"SELECT `role_id`, `show_id`, `if_show` FROM `pet_aircraft_player` WHERE `role_id` = ~p">>).
-define(sql_pet_aircraft_player_replace,
    <<"REPLACE INTO `pet_aircraft_player`(`role_id`, `show_id`, `if_show`) VALUES (~p, ~p, ~p)">>).

-define(sql_pet_aircraft_info_select,
    <<"SELECT `role_id`, `aircraft_id`, `stage` FROM `pet_aircraft_info` WHERE `role_id` = ~p">>).
-define(sql_pet_aircraft_info_replace,
    <<"REPLACE INTO `pet_aircraft_info`(`role_id`, `aircraft_id`, `stage`) VALUES ~s">>).

-define(sql_pet_wing_player_select,
    <<"SELECT `role_id`, `show_id`, `if_show` FROM `pet_wing_player` WHERE `role_id` = ~p">>).
-define(sql_pet_wing_player_replace,
    <<"REPLACE INTO `pet_wing_player`(`role_id`, `show_id`, `if_show`) VALUES (~p, ~p, ~p)">>).

-define(sql_pet_wing_info_select,
    <<"SELECT `role_id`, `wing_id`, `stage`, `end_time` FROM `pet_wing_info` WHERE `role_id` = ~p">>).
-define(sql_pet_wing_info_replace,
    <<"REPLACE INTO `pet_wing_info`(`role_id`, `wing_id`, `stage`, `end_time`) VALUES ~s">>).
-define(sql_pet_wing_info_delete,
    <<"DELETE FROM `pet_wing_info` WHERE `wing_id` = ~p">>).

-define(sql_pet_equip_pos_select,
    <<"SELECT `role_id`, `pos`, `pet_equip_point` FROM `pet_equip_pos` WHERE `role_id` = ~p">>).
-define(sql_pet_equip_pos_replace,
    <<"REPLACE INTO `pet_equip_pos`(`role_id`, `pos`, `pet_equip_point`) VALUES (~p, ~p, ~p)">>).