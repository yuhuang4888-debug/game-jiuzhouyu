%%-----------------------------------------------------------------------------
%% @Module  :       team_enlist.hrl
%% @Author  :
%% @Email   :
%% @Created :
%% @Description:    队伍招募
%%-----------------------------------------------------------------------------

-record(state, {
        team_maps = #{}
        , activity_maps = #{}       %% 活动 Key:{ActivityId, SubTypeId} Value:[TeamId,...]
        , match_roles_map = #{}
        , module_group_map = #{}     %% #{Module => #{ZoneId => #{SerId => {Mod, GroupId}}}}
}).

%% 队伍目标类型
-define(TARGET_TYPE_NONE, 0).       %% 无目标
-define(TARGET_TYPE_DUNGEON, 1).    %% 副本

-define(MEMBER_MAX, 3).        %% 队伍最大人数

%% 匹配时间
-define(TEAM_MATCH_END_TIME, 60).   %% 匹配结束时间(没有次数的玩家匹配超时会取消匹配)

%% 队伍信息
-record(team_enlist_info, {
        team_id,
        num,
        max_num = ?MEMBER_MAX,
        leader_id,
        activity_id,
        scene_id,
        target_type = ?TARGET_TYPE_NONE,
        dungeon_type = 0 ,
        matching = 0 ,      %% 是否为自动匹配状态
        lv_limit_min = 0,         %% 等级下限
        lv_limit_max = 0,         %% 等级上限
        join_con_value = 0,

        subtype_id = 0,
        members = []
        , join_type         %% 加入状态
}).

%% 匹配的玩家
-record(matching_role, {
        node = undefined,
        role_id,            %% 玩家id
        activity_list,      %% 想匹配的活动
        waiting_team_ids,   %% 可以匹配的队伍id列表
        match_time = 0,     %% 执行匹配的时间
        lv = 0,             %% 玩家等级
        join_value_list = [], %% 入队参数
        ref = 0             %% 本次匹配的标识
        , match_end_ref = none  %% 结束匹配定时器
}).
