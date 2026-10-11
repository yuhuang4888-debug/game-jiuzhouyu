%%%------------------------------------
%%% @Module  : beings_gate
%%% @Author  : lwc
%%% @Created : 2022-02-28
%%% @Description: 众生之门
%%%------------------------------------

-define(LOCAL_SERVER, 1). % 本服
-define(CROSS_SERVER, 2). % 跨服

-define(STATE_CLOSE,    0). % 未开放
-define(STATE_OPEN,     1). % 开放期间

-define(KV(Key),        data_beings_gate:get_value(Key)).
-define(COORDINATES,    ?KV(beings_gate_coordinates)).
-define(DUNGEON_CENTER, ?KV(beings_gate_dungeon_center)).
-define(DUNGEON_LOCAL,  ?KV(beings_gate_dungeon_local)).
-define(SCENE_CENTER,   ?KV(beings_gate_scene_center)).
-define(SCENE_LOCAL,    ?KV(beings_gate_scene_local)).
-define(ENTER_LV,       ?KV(beings_gate_enter_lv)).
-define(FIRST_DAY,      ?KV(beings_gate_first_day)).

-record(beings_gate_status, {
        state_type      = 1  % 进程类型
        ,cls_type       = 0  % 服类型
        ,zone_id        = 0  % 区Id（本服用）
        ,group_id       = 0  % 分组Id（本服用）
        ,mod            = 1  % 分服模式（本服用）
        ,zone_base_list = [] % 服务器等级列表[#zone_base{},...]（本服用）
        ,status         = 0  % 活动开启状态
        ,end_time       = 0  % 结束时间
        ,end_ref        = 0  % 活动结束定时器
        ,activity_list  = [] % 所有服务器活跃度列表[#activity_data{},...]
        ,portal_map     = #{} % 传送门Map #{{ZoneId, GroupId, Mod} => [#portal_data{},...]}
        ,group_map      = #{} % 分组map #{ZoneId => {ServerMap(#{SerId => {Mod, GroupId}}), ModGroupMap(#{{Mod, GroupId} => ZoneBasesL})}}
}).

-record(portal_data, {
        portal_id    = 0 % 传送门Id
        ,x           = 0 % x坐标
        ,y           = 0 % y坐标
}).

-record(activity_data, {
        server_id  = 0 % 服务器Id
        ,yesterday = 0 % 昨日活跃度
        ,today     = 0 % 今日活跃度
        ,time      = 0 % 更新时间
}).

%% 传送门配置
-record(base_beings_gate, {
        mod           = 0 % 分服模式
        ,min_activity = 0 % 最小活跃度
        ,max_activity = 0 % 最大活跃度
        ,portal_num   = 0 % 传送门数量
}).

