%%-----------------------------------------------------------------------------
%% @Module  :       godweapon.hrl
%% @Author  :       Fwx
%% @Created :       2017-10-27
%% @Description:    神兵
%%-----------------------------------------------------------------------------
-define(GODWEAPON_HIDE, 0).                                   %% 隐藏状态
-define(GODWEAPON_DISPLAY, 1).                                %% 显示状态
-define(GODWEAPON_SEL_FIGURE, 1).                             %% 幻化操作

-define(GODWEAPON_MIN_LV, 1).                                 %%神兵最低等级              
-define(GODWEAPON_MIN_STAGE, 0).                              %% 神兵最低级数
-define(GODWEAPON_MIN_STAR, 0).                               %% 神兵最低星数

-define(GODWEAPON_LV_AUTO, 1).                                 %% 一键升级
-define(GODWEAPON_LV_MANUAL, 0).                                 %% 手动一个

-define(GODWEAPON_LV,     135).                                 %% 神兵解锁等级

%% 神兵基础信息配置
-record(godweapon_base_cfg, {
    type = 0,           %% 外观类型 1.翅膀;2.法宝;3.神兵
    name = "",          %% 名称
    figure_id = 0,      %% 默认形象ID
    att = [],           %% 基础属性
    combat = 0          %% 基础战力
    }).

%% 神兵等级配置
-record(godweapon_lv_cfg, {
    type = 0,           %% 外观类型 1.翅膀;2.法宝;3.神兵
    lv = 0,
    max_exp = 0,        %% 升级所需经验值
    attr = [],          %% 属性
    attr_plus = [],     %% 属性增加
    combat = 0,         %% 战力增加
    skills = [],        %% 解锁技能
    is_tv = 0}).        %% 是否公告

%% 神兵技能配置
-record(godweapon_skill_cfg, {
    skill_id = 0,       %% 技能id
    lv = 0              %% 解锁等级
    }).

%% 神兵升级道具配置
-record(godweapon_goods_exp_cfg, {
    goods_id = 0,       %% 道具物品id
    exp = 0}).          %% 道具提供经验值   

%% 仙羽提升道具配置
-record(godweapon_feather_cfg, {
    goods_id = 0,       %% 仙羽物品id
    type = 0,           %% 外观类型
    attr = [],          %% 属性增加
    combat = 0,         %% 战力增加
    max_times = 0}).    %% 提升次数上限

%% 神兵化形配置
-record(godweapon_stage_cfg, {
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
-record(godweapon_star_cfg, {
    id   = 0,           %% 化形id
    star = 0,           %% 星级
    cost = [],          %% 升星消耗  
    attr = [],          %% 属性
    attr_plus = [],     %% 属性增加
    combat = 0}).       %% 战力增加

-record(status_godweapon, {
    lv = 0,                     %% 当前等级
    exp = 0,                    %% 经验值
    illusion_id = 0,            %% 幻化的化形id
    figure_list = [],           %% 已激活的化形形象列表[#godweapon_figure{}]
    figure_attr = [],           %% 化形属性
    base_attr = [],             %% 基础属性
    attr = [],                  %% 总的加成属性(基础属性+等级属性+技能属性+化形属性)
    special_attr = #{},         %% 特殊属性
    skills = [],                %% 解锁的技能
    passive_skills = [],        %% 被动技能
    base_combat = 0,            %% 基础属性战力
    combat = 0,                 %% 神兵战力(基础属性战力+化形战力+等级战力)
    figure_id = 0,              %% 当前使用的形象资源id
    display_status = 0          %% 0: 隐藏 1: 显示
    }).

-record(godweapon_figure, {
    id = 0,                     %% 幻形形象id
    star = 0,                   %% 幻化形象阶数
    attr = [],                  %% 属性
    combat = 0                  %% 战力
    }).
%% ------------------------------------------------------

-define(sql_player_godweapon_select, 
    <<"select lv, exp, illusion_id, display_status from player_godweapon where role_id = ~p">>).

-define(sql_player_godweapon_figure_select, 
    <<"select id, star from player_godweapon_figure where role_id = ~p">>).

-define(sql_player_godweapon_replace, 
    <<"replace into player_godweapon (role_id, lv, illusion_id, display_status) values (~p, ~p, ~p, ~p)">>).

-define(sql_update_godweapon_illusion, 
    <<"update player_godweapon set illusion_id = ~p where role_id = ~p">>).

-define(sql_update_godweapon_display_status, 
    <<"update player_godweapon set display_status = ~p where role_id = ~p">>).

-define(sql_update_godweapon_lv, 
    <<"update player_godweapon set lv = ~p, exp = ~p where role_id = ~p">>).

-define(sql_update_godweapon_illusion_info, 
    <<"replace into player_godweapon_figure(role_id, id, star) values(~p, ~p, ~p)">>).