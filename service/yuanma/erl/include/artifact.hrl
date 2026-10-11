%%-----------------------------------------------------------------------------
%% @Module  :       artifat.hrl
%% @Author  :       Fwx
%% @Created :       2017-11-08
%% @Description:    神器
%%-----------------------------------------------------------------------------
-define(ARTIFACT_MIN_LV,   1).                             %% 神器最低等级              
-define(ARTIFACT_MIN_TIME, 0).                             %% 神器最低附灵次数    
-define(ARTIFACT_MIN_PERCENT, []).                         %% 神器附灵百分比    

%% 神器激活配置
-record(artifact_active_cfg, {
    id        = 0,           %% 神器ID
    name      = "",          %% 神器名称
    icon_id   = 0,           %% 神器图标
    figure_id = 0,           %% 模型资源
    condition = [],          %% 激活条件
    ench_cost = [],          %% 附灵消耗物品
    quality   = 0            %% 品质
    }).

%% 神器强化配置
-record(artifact_upgrate_cfg, {
    id   = 0,           %% 神器ID
    name = "",          %% 神器名称
    lv   = 0,           %% 强化等级
    attr = [],          %% 强化属性
    cost = []           %% 强化消耗
    }).       

%% 神器天赋配置
-record(artifact_gift_cfg , {
    gift_id   = 0,      %% 天赋id
    gift_name = "",     %% 天赋名称
    id        = 0,      %% 神器ID
    name      = "",     %% 神器名称
    need_lv   = 0,      %% 所需强化等级
    attr      = []      %% 属性加成
    }).

%% 神器附灵配置
-record(artifact_enchant_cfg, {
    id            = 0,  %% 神器ID
    name          = "", %% 神器名称
    attr_id       = 0,  %% 属性ID
    attr          = [], %% 附灵属性
    base_percent  = 0,  %% 初始附灵百分比 
    active_weight = 0   %% 激活权值
    }).

%% 附灵属性激活概率配置p
-record(enchant_chance_cfg,{
    time   = 0,         %% 附魔次数
    chance = 0          %% 激活概率
    }).

%% 附灵提升总百分比配置
-record(enchant_percent_cfg,{
    id            = 0,  %% 神器ID
    percent_range = []  %% 附灵提升的百分比区间
    }).

-record(enchant_points,{
    blue_points   = 0,
    purple_points = 0,
    orange_points = 0
    }).

-record(status_artifact, {
    artifact_list = [],               %% 已激活的神器列表（#artifact_info{}）
    attr          = [],               %% 总的加成属性 
    ench_points   = #enchant_points{} %% 强化积分
    }).

-record(artifact_info, {
    id           = 0,         %% 神器ID
    up_lv        = 0,         %% 神器强化等级
    attr         = [],        %% 单个神器总属性
    lv_attr      = [],        %% 强化属性
    gift         = [],        %% 强化解锁天赋id
    gift_attr    = [],        %% 天赋属性（不在全属性加成范围之内）
    ench_time    = 0,         %% 附灵次数
    ench_percent = [],        %% 附灵属性百分比列表 例如[{1, 20}, {2, 40}] 
    ench_attr    = [],        %% 附灵属性(乘以百分比之后)
    combat       = 0
    }).


%% ------------------------------------------------------


-define(sql_player_artifact_select, 
    <<"select id, up_lv, ench_time, ench_percent 
    from player_artifact where role_id = ~p">>).

-define(sql_update_artifat_lv, 
    <<"update player_artifact set up_lv = ~p 
    where role_id = ~p and id = ~p">>).

 -define(sql_update_artifact_enchant, 
    <<"update player_artifact set ench_time = ~p, ench_percent = ~p 
    where role_id = ~p and id = ~p">>).

-define(sql_update_artifact_info, 
    <<"replace into player_artifact
    (role_id, id, up_lv, ench_time, ench_percent) values(~p, ~p, ~p, ~p, ~p)">>).
