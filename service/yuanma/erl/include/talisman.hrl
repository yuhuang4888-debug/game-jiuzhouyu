%%-----------------------------------------------------------------------------
%% @Module  :       talisman.hrl
%% @Author  :       Fwx
%% @Created :       2017-11.6
%% @Description:    法宝
%%-----------------------------------------------------------------------------
-define(TALISMAN_HIDE, 0).                                   %% 隐藏状态
-define(TALISMAN_DISPLAY, 1).                                %% 显示状态
-define(TALISMAN_SEL_FIGURE, 1).                             %% 幻化操作

-define(TALISMAN_MIN_LV, 1).                                 %%法宝最低等级              
-define(TALISMAN_MIN_STAGE, 0).                              %% 法宝最低级数
-define(TALISMAN_MIN_STAR, 0).                               %% 法宝最低星数

-define(TALISMAN_LV_AUTO, 1).                                 %% 一键升级
-define(TALISMAN_LV_MANUAL, 0).                                 %% 手动一个

-define(TALISMAN_LV,      110).                                 %% 法宝解锁等级

%% 法宝基础信息配置
-record(talisman_base_cfg, {
    type = 0,           %% 外观类型 
    name = "",          %% 名称
    figure_id = 0,      %% 默认形象ID
    att = [],           %% 基础属性
    combat = 0          %% 基础战力
    }).

%% 法宝等级配置
-record(talisman_lv_cfg, {
    type = 0,           %% 外观类型 
    lv = 0,
    max_exp = 0,        %% 升级所需经验值
    attr = [],          %% 属性
    attr_plus = [],     %% 属性增加
    combat = 0,         %% 战力增加
    skills = [],        %% 解锁技能
    is_tv = 0}).        %% 是否公告

%% 法宝技能配置
-record(talisman_skill_cfg, {
    skill_id = 0,       %% 技能id
    lv = 0              %% 解锁等级
    }).

%% 法宝升级道具配置
-record(talisman_goods_exp_cfg, {
    goods_id = 0,       %% 道具物品id
    exp = 0}).          %% 道具提供经验值   

%% 仙羽提升道具配置
-record(talisman_feather_cfg, {
    goods_id = 0,       %% 仙羽物品id
    type = 0,           %% 外观类型
    attr = [],          %% 属性增加
    combat = 0,         %% 战力增加
    max_times = 0}).    %% 提升次数上限

%% 法宝化形配置
-record(talisman_stage_cfg, {
    id   = 0,           %% 化形id
    type = 0,           %% 外观类型
    prop = [],          %% 化形激活道具
    name = "",          %% 名称
    turn = 0,           %% 解锁所需转生数
    % attr = [],        %% 激活默认属性 在星级配置配
    % combat = 0,       
    figure_id = 0,      %% 外观资源
    max_star = 0        %% 最大星数
   }).

%% 化形升星配置
-record(talisman_star_cfg, {
    id   = 0,           %% 化形id
    star = 0,           %% 星级
    cost = [],          %% 升星消耗  
    attr = [],          %% 属性
    attr_plus = [],     %% 属性增加
    combat = 0}).       %% 战力增加

-record(status_talisman, {
    lv = 0,                     %% 当前等级
    exp = 0,                    %% 经验值
    illusion_id = 0,            %% 幻化的化形id
    figure_list = [],           %% 已激活的化形形象列表[#talisman_figure{}]
    figure_attr = [],           %% 化形属性
    base_attr = [],             %% 基础属性
    attr = [],                  %% 总的加成属性(基础属性+等级属性+技能属性+化形属性)
    special_attr = #{},         %% 特殊属性s
    skills = [],                %% 解锁的技能
    passive_skills = [],        %% 被动技能
    base_combat = 0,            %% 基础属性战力
    combat = 0,                 %% 法宝战力(基础属性战力+化形战力+等级战力)
    battle_attr = undefine,     %% 法宝战斗相关属性
    figure_id = 0,              %% 当前使用的形象资源id
    display_status = 0          %% 0: 隐藏 1: 显示
    }).

-record(talisman_figure, {
    id = 0,                     %% 幻形形象id
    star = 0,                   %% 幻化形象阶数
    attr = [],                  %% 属性
    combat = 0                  %% 战力
    }).
%% ------------------------------------------------------

-define(sql_player_talisman_select, 
    <<"select lv, exp, illusion_id, display_status from player_talisman where role_id = ~p">>).

-define(sql_player_talisman_figure_select, 
    <<"select id, star from player_talisman_figure where role_id = ~p">>).

-define(sql_player_talisman_replace, 
    <<"replace into player_talisman (role_id, lv, illusion_id, display_status) values (~p, ~p, ~p, ~p)">>).

-define(sql_update_talisman_illusion, 
    <<"update player_talisman set illusion_id = ~p where role_id = ~p">>).

-define(sql_update_talisman_display_status, 
    <<"update player_talisman set display_status = ~p where role_id = ~p">>).

-define(sql_update_talisman_lv, 
    <<"update player_talisman set lv = ~p, exp = ~p where role_id = ~p">>).

-define(sql_update_talisman_illusion_info, 
    <<"replace into player_talisman_figure(role_id, id, star) values(~p, ~p, ~p)">>).