%%-----------------------------------------------------------------------------
%% @Module  :       wing.hrl
%% @Author  :       Fwx
%% @Created :       2017-10-27
%% @Description:    翅膀
%%-----------------------------------------------------------------------------
-define(WING_HIDE,       0).                                 %% 隐藏状态
-define(WING_DISPLAY,    1).                                 %% 显示状态

-define(WING_SEL_FIGURE, 1).                                 %% 幻化操作

-define(WING_MIN_LV,     1).                                 %% 翅膀最低等级              
-define(WING_MIN_STAGE,  0).                                 %% 翅膀最低级数
-define(WING_MIN_STAR,   0).                                 %% 坐骑最低星数

-define(WING_LV_AUTO,    1).                                 %% 一键升级
-define(WING_LV_MANUAL,  0).                                 %% 手动一个

-define(WING_ACTIVE_LV, 40).                                 %% 翅膀解锁等级


%% 翅膀等级配置
-record(wing_lv_cfg, {
    lv        = 0,          %% 等级        
    max_exp   = 0,          %% 升级所需经验值
    attr      = [],         %% 属性
    attr_plus = [],         %% 属性增加
    combat    = 0,          %% 战力增加
    skills    = [],         %% 解锁技能
    is_tv     = 0           %% 是否公告
    }).        

%% 翅膀技能配置
-record(wing_skill_cfg, {
    skill_id  = 0,          %% 技能id
    lv        = 0           %% 解锁等级
    }).

%% 翅膀升级道具配置
-record(wing_goods_exp_cfg, {
    goods_id  = 0,          %% 道具物品id
    exp       = 0           %% 道具提供经验值  
    }).         

%% 仙羽提升道具配置
-record(wing_feather_cfg, {
    goods_id  = 0,          %% 仙羽物品id
    attr      = [],         %% 属性增加
    combat    = 0,          %% 战力增加
    max_times = 0           %% 提升次数上限
    }).       

%% 翅膀化形配置
-record(wing_stage_cfg, {
    id        = 0,           %% 化形id
    prop      = [],          %% 化形激活道具
    name      = "",          %% 名称
    turn      = 0,           %% 解锁所需转生数
    figure_id = 0,           %% 外观资源
    max_star  = 0            %% 最大星数
   }).

%% 化形升星配置
-record(wing_star_cfg, {
    id        = 0,           %% 化形id
    star      = 0,           %% 星级
    cost      = [],          %% 升星消耗  
    attr      = [],          %% 属性
    attr_plus = [],          %% 属性增加
    combat    = 0            %% 战力增加
    }).                       

-record(status_wing, {
    lv             = 0,      %% 当前等级
    exp            = 0,      %% 经验值
    illusion_id    = 0,      %% 幻化的化形id
    figure_list    = [],     %% 已激活的化形形象列表[#wing_figure{}]
    figure_attr    = [],     %% 化形属性
    base_attr      = [],     %% 基础属性(仙羽增加的)
    attr           = [],     %% 总的加成属性(基础属性+等级属性+技能属性+化形属性)
    special_attr  = #{},         %% 特殊属性
    skills         = [],     %% 解锁的技能
    passive_skills = [],     %% 被动技能
    base_combat    = 0,      %% 基础属性战力
    combat         = 0,      %% 翅膀总战力
    figure_id      = 0,      %% 当前使用的形象资源id
    display_status = 0       %% 0: 隐藏 1: 显示
    }).

-record(wing_figure, {
    id     = 0,              %% 幻形形象id
    star   = 0,              %% 幻化形象阶数
    attr   = [],             %% 属性
    combat = 0               %% 战力
    }).
%% ------------------------------------------------------

-define(sql_player_wing_select, 
    <<"select lv, exp, illusion_id, display_status 
    from player_wing where role_id = ~p">>).

-define(sql_player_wing_figure_select, 
    <<"select id, star
     from player_wing_figure where role_id = ~p">>).

-define(sql_player_wing_replace, 
    <<"replace into player_wing 
    (role_id, lv, illusion_id, display_status) values (~p, ~p, ~p, ~p)">>).

-define(sql_update_wing_illusion, 
    <<"update player_wing set illusion_id = ~p 
    where role_id = ~p">>).

-define(sql_update_wing_display_status, 
    <<"update player_wing set display_status = ~p 
    where role_id = ~p">>).

-define(sql_update_wing_lv, 
    <<"update player_wing set lv = ~p, exp = ~p 
    where role_id = ~p">>).

-define(sql_update_wing_illusion_info, 
    <<"replace into player_wing_figure
    (role_id, id, star) values(~p, ~p, ~p)">>).