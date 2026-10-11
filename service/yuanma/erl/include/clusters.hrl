%%%------------------------------------------------
%%% File    : clusters.hrl
%%% Author  : xyao
%%% Created : 2011-06-13
%%% Description: 集群record
%%%------------------------------------------------

%% =========================跨服中心========================
-record(clusters_center, {
        node_list=[]                 %% 跨服节点列表
    }).

%% 路由信息表
-define(ROUTE, route).
-record(route, {
        server_id=0,
        node=undefined
    }).

%% 区域路由信息表
-record(clusters_zone, {
        server_id=0,
        zone=0,
        world_lv=0
    }).

%% 分区序号
-define(ZONE_TYPE_1, 1).    %% 8服分区

%% 区服模式
-define(ZONE_MOD_1, 1). % 本服模式
-define(ZONE_MOD_2, 2). % 2服模式
-define(ZONE_MOD_4, 4). % 4服模式
-define(ZONE_MOD_8, 8). % 8服模式

%% 分区服信息
-record(zone_base, {
    server_id = 0       %% 每一个服的id(主服)
    , zone = 0          %% 区id
    , time = 0          %% 开服时间
    , combat_power = 0  %% 排名前10玩家的战力总和
    , merge_ids = []    %% 每一个服的所有合服id##不包括主服id
    , server_num = 0    %% ServerNum
    , server_name = ""  %% 服名字
    , world_lv = 0      %% 世界等级
    , active_type = 1
}).

%% 分区信息
-record(zone_data, {
      zones = []        %% 所有的分区(只保存主服的server_id信息) [#zone_base{}, ...]
    , next = 1          %% 下一个分区id
    , is_zone = 0       %% 是否已经分区
    , z2s_map = #{}     %% 各个区域包含的服务器 #{zone_id => [server_id,...], ...}
}).


%% 跨服中心进程中游戏节点的信息
-record(game_node, {
        node=undefined,
        m_ref=undefined,
        server_id=0,    % 主服id
        merge_ids=[]    % 主服所有合服id(包括主服id)
    }).

%% 区域信息
%% 以 zone_id 作为主键
-record(ets_main_zone, {
        zone_id = 0     %% 区域id
        , world_lv = 0  %% 区域最大世界等级
    }).

%% =========================跨服节点========================

%% 重连跨服服务器间隔时间 （30秒）
-define(CONNECT_CENTER_TIME, 30000).

%% 跨服节点
-record(clusters_node, {
        center_node=none,           %% 跨服中心节点
        link = 0,                   %% 是否连通(1连通，0不连通)
        m_ref = undefined,          %% 监控
        server_id = 0,              %% 服唯一id
        merge_server_ids = [],      %% 合服ids
        optime=0,                   %% 本服开服时间
        server_num = 0,             %% 服数
        server_name = "",           %% 服名字
        active_type = 1
    }).

%% =========================分区内分组相关========================


%% 分区服的分组信息
-record(zone_mod_data, {
      zone_id = 0
    , avg_lv = 0
    , module_map = #{}         % #{ModuleId => #zone_group_info{}}
    , servers = []              % [#zone_base{}]
}).

-record(zone_group_info, {
      module_id = 0
    , group_mod_servers = []    % [#zone_mod_group_data{}]
    , server_group_map = #{}    % #{ServerId => GroupId}
}).

-record(zone_mod_group_data, {
      group_id
    , mod = 1
    , server_ids = []
    , avg_lv = 0
    , next_server_ids = []
    , next_avg_lv = 0
}).

% 跨服分区分组配置
-record(base_zone_mod_group, {
      module_id
    , mod = 0         %% '1：本服模式、2:2服模式、4：4服模式、8：8服模式',
    , name = ""      %% '服务器模式名称',
    , min_world_lv   %%'最小世界等级',
    , max_world_lv   %%'最大世界等级',
    , open_day       %% '开服天数',
    , max_open_day
}).

-record(add_node_msg, {
    game_node = undefined
    , game_conn_pid = undefined
    , server_id = 0
    , open_time = 0
    , merge_server_ids = []
    , server_num = 0
    , server_name = []
    , c_server_msg = []
    , world_lv = 0
    , server_combat_power = 0
    , active_type = 1
}).
