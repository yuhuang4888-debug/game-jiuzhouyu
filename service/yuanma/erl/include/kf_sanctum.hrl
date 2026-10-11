%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%% @desc :永恒圣殿 头文件 kf_sanctum
%%%-------------------------------------------------------------------

-record(base_sanctum_scene, {
        scene = 0,          %% 场景
        montype = 0,        %% 怪物类型
        mon_num = 0,        %% 数量
        mon = []            %% 坐标
    }).

-record(base_sanctum_montype, {
        montype = 0,        %% 怪物类型
        refresh = [],       %% 刷新规则
        reborn_time =0     %% 复活时间
    }).

-define(SANMONTYPE_BOSS, 1).%% BOSS
-define(SANMONTYPE_MON,  2).%% 精英
-define(SANMONTYPE_MONSTER, 3). %% 小怪
-define(SCENE_TYPE_SPECIAL_SAN, 1).%% 高级场景  
-define(SCENE_TYPE_NORMAL_SAN, 2).%% 普通场景

-record(kf_sanctum_state, {
        zone_map = #{},                 %% zone_id => [ServerId,...]
        server_info = [],               %% [{ServerId,Optime, WorldLv, ServerNum, ServerName}...]
        max_world_lv_map = #{},         %% zone_id => MaxWorldLv
        scene_info = #{},               %% zone_id => [#sanctum_scene_info{}]
        scene_bl_server = [],           %% {zone_id, [serverid, ...]} 拥有高级场景进入权限的服务器id
        enter_time_limit = 0,           %% 最后可进入活动时间戳
        notify_player_ref = undefined,  %% 系统提示（开启前5分钟）
        act_start_time = 0,             %% 活动开启时间戳
        act_start_ref = undefined,      %% 活动开启定时器
        act_end_time = 0,               %% 活动结束时间戳
        act_end_ref = undefined         %% 活动结束定时器
        
        ,scene_user = #{}               %% zone_id => [{scene, [role_id]}]
        ,reborn_point = #{}             %% zone_id => [{scene, [{server_id, {x,y}},...]}....]
    }).

-record(sanctum_scene_info, {
        zone_id = 0,            %% 区id
        scene = 0,              %% 场景id
        bl_server = 0,          %% 归属id
        bl_server_name = <<>>,  %% 归属服务器名
        bl_server_num = 0,      %% 归属服务器服数
        mon = []                %% [#sanctum_mon_info{}]
    }).

-record(sanctum_mon_info, {
        mon_id = 0,             %% 怪物id
        sanctum_mon_type = 0,   %% 怪物类型
        mon_lv = 0,             %% 怪物等级
        reborn_ref = undefined, %% 复活定时器
        reborn_time = 0,        %% 下次复活时间
        rank_list = [],         %% 伤害排名
        x = 0,                  %% X坐标
        y = 0                   %% Y坐标
    }).

-record(sanctum_state, {
        join_list = [],         %% 本服参与人数 [{scene, [role_id]}]
        kf_join_list = [],      %% 跨服参与人数 [{scene, [role_id]}] 
        act_start_time = 0,     %% 活动开启时间戳
        enter_time_limit = 0,   %% 最后可进入活动时间戳
        act_end_time = 0,       %% 活动结束时间戳
        scene_bl_server = [],   %% [serverid, ...] 拥有高级场景进入权限的服务器id
        scene_info_list = []    %% [#sanctum_scene_info{}]
        ,reborn_point = {0, 0}  %% 出生点/复活点
    }).

-define(SQL_SELECT_PLAYER_DIE,
        <<"select mod_id, die_time, die_list from player_die_info where role_id = ~p">>).

-define(SQL_REPLACE_PLAYER_DIE,
        <<"replace into player_die_info(mod_id, role_id, die_time, die_list) values(~p,~p,~p,~p)">>).