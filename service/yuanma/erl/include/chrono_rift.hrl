%%% ------------------------------------------------------------------------------------------------
%%% @doc            chrono_rift.hrl
%%% @author         chenyiming
%%% @email          chenyiming@suyougame.com
%%% @created        2019-11-27
%%% @modified       2021-11-12 by kyd
%%% @description    时空圣痕头文件
%%% ------------------------------------------------------------------------------------------------

%%% ======================================= variable macros ========================================

%% kv
-define(CHRONO_RIFT_KV(Key),  data_chrono_rift:get_kv(Key)).

-define(CR_GOAL_LV_LIST, ?CHRONO_RIFT_KV(goal_lv_list)).     % 目标难度列表 [{最佳排名, 最差排名, 难度}]
-define(CR_ROLE_LV,      ?CHRONO_RIFT_KV(lv_limit)).         % 玩家等级限制
-define(CR_WORLD_LV,     ?CHRONO_RIFT_KV(need_world_lv)).    % 世界等级限制
-define(CR_OPEN_DAY,     ?CHRONO_RIFT_KV(open_day)).         % 开服时间限制(天)
-define(CR_RANK_LEN,     ?CHRONO_RIFT_KV(rank_length)).      % 争夺值排行榜长度
-define(CR_RANK_VALUE,   ?CHRONO_RIFT_KV(rank_value_limit)). % 争夺值排行榜上榜限制(弃用)

%% 活动开启状态
-define(act_open,  1). % 开启
-define(act_close, 0). % 关闭

%% 据点占领状态
-define(is_occupy,  1). % 已占领
-define(not_occupy, 0). % 未占领

%% 基地据点相关
-define(base_castle_id,    [1, 2, 3, 4, 5, 6, 7, 8]). % 基地据点id
-define(base_castle_ratio, 2).                        % 基地据点争夺值比率

%% 据点目标
-define(goal1, 1). % 占领据点
-define(goal2, 2). % 夺回丢失一个据点,兼容goal1
-define(goal3, 3). % 钻石争夺值达到多少
-define(goal4, 4). % 守住某等级据点12个小时
-define(goal5, 5). % 抢夺据点数量排名前2服务器的据点,兼容goal1,goal2
-define(goal_default_list, [{1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}]).

%%% ======================================== config records ========================================

%% 据点配置
-record(cfg_chrono_rift_castle, {
    id              = 0  % 据点id
    ,lv             = 0  % 据点等级
    ,connect_castle = [] % 相连接的据点
    ,occupa_add     = 0  % 占领增量
}).

%% 时空裂痕争夺值任务活动
-record(chrono_act_cfg, {
    mod        = 0 % 功能模块id
    ,sub_mod   = 0 % 功能子模块id
    ,count     = 0 % 任务达成数值
    ,value     = 0 % 任务达成争夺值
    ,max_value = 0 % 获取争夺值上限(通过该任务)
    ,type      = 0 % 任务类型
}).

%%% ======================================== general records =======================================

%% 时空裂缝状态
-record(chrono_rift_state, {
    castle_map  = #{} % 跨服区域据点状态 #{ZoneId => [#chrono_rift_castle{}, ...]}
    ,zone_state = []  % 跨服区域状态 [#zone_msg{}, ...]
    ,end_ref    = 0   % 赛季结束定时器
}).

%% 据点状态
-record(chrono_rift_castle, {
    id                   = 0
    ,zone_id             = 0
    ,lv                  = 0
    ,connect_castle      = []
    ,current_server_id   = 0
    ,current_server_num  = 0
    ,current_server_name = ""
    ,scramble_value      = [] % 争夺值[#castle_server_msg{}, ...],
    ,timer_ref           = [] % 12小时定时器
    ,time                = 0  % 占领12小时结束定时器
    ,occupy_count        = 0  % 被占领次数
    ,role_list           = []
    ,base_server_id      = 0
    ,have_servers        = [] % 占领过的服务器
}).

%% 跨服区域状态
-record(zone_msg, {
    zone_id = 0          % 区域id
    ,all_lv = 0
    ,num    = 0
    ,status = ?act_close % 区域活动开启状态
 }).

%% 服务器在据点的信息
-record(castle_server_msg, {
    server_id    = 0  % 游戏服id
    ,server_name = "" % 游戏服名
    ,server_num  = 0  % 游戏服号
    ,value       = 0  % 当前争夺值
}).

%% 玩家据点信息
-record(castle_role_msg, {
    role_id         = 0  % 玩家id
    ,role_name      = "" % 玩家名
    ,castle_id      = 0
    ,server_id      = 0  % 所属游戏服id
    ,server_name    = "" % 所属游戏服名
    ,server_num     = 0  % 所属游戏服号
    ,scramble_value = 0  % 注入的争夺值(转化后)
    ,is_occupy      = 0  % 是否驻扎
    ,zone_id        = 0  % 所属跨服区域
}).

%% 玩家时空裂缝活动信息
-record(chrono_rift_in_ps, {
    scramble_value      = 0  % 总争夺值
    , act_list          = [] % 争夺值任务情况 [{{模块id, 子模块id}, 争夺值}]
    , today_value       = 0  % 今日争夺值
    , castle_id         = 0  % 当前驻扎据点id
    , today_reward_list = [] % 今日奖励状态 [{阶段, 领取状态}] 领取状态 :: 0 未领取 2 已经领取
    , season_reward     = [] % 赛季奖励 [{类型, 领取状态}] 领取状态 :: 0 未领取 2 已经领取
}).

%% 时空裂缝排行榜状态
-record(chrono_rift_rank_state, {
    role_map   = #{} % 玩家信息 #{RoleId => #rank_role_msg{}}
    ,zone_list = []  % 区域列表
}).

%% 玩家排行榜信息(被#castle_role_msg{}覆盖)
-record(rank_role_msg, {
    role_id         = 0  % 玩家id
    ,role_name      = "" % 玩家名
    ,server_id      = 0  % 所属游戏服id
    ,server_name    = "" % 所属游戏服名
    ,server_num     = 0  % 所属游戏服号
    ,scramble_value = 0  % 注入的争夺值(转化前)
}).

%% 时空裂缝据点目标状态
-record(server_goal_state, {
	server_list = []
}).

%% 时空裂缝游戏服据点目标信息
-record(server_goal, {
    server_id    = 0  % 游戏服id
    ,server_name = "" % 游戏服名
    ,server_num  = 0  % 游戏服号
    ,goal_list   = [] % [{type, 数值}]
    ,last_rank   = 0  % type + last_rank 决定id
}).

%%% ========================================== sql macros ==========================================

%% chrono_rift_castle

-define(select_chrono_rift_castle,
	<<
        "select current_server, current_server_num, current_server_name, scramble_value,
                time, occupy_count, base_server_id, have_occupy_server
        from chrono_rift_castle
        where id = ~p and zone_id = ~p"
    >>).

-define(save_castle,
    <<
        "replace into chrono_rift_castle
        (id, zone_id, current_server, current_server_num, current_server_name, scramble_value,
        occupy_count, base_server_id, time, have_occupy_server)
        values(~p, ~p, ~p, ~p, '~s', '~s', ~p, ~p, ~p, '~s')"
    >>).

%% chrono_rift_castle_role

-define(select_chrono_rift_castle_role,
	<<
        "select role_id, role_name, server_id, server_num, server_name, scramble_value, is_occupy
        from chrono_rift_castle_role
        where castle_id = ~p and zone_id = ~p"
    >>).

-define(save_castle_role,
    <<
        "replace into chrono_rift_castle_role
        (role_id, role_name, castle_id, server_id, server_name, server_num, scramble_value,
        is_occupy, zone_id)
        values(~p, '~s', ~p, ~p, '~s', ~p, ~p, ~p, ~p)"
    >>).

%% chrono_rift_kf_role

-define(select_chrono_rift_role_rank,
	<<
        "select role_id, role_name, server_id, server_num, server_name, scramble_value
        from chrono_rift_kf_role"
    >>).

-define(save_chrono_rift_role_rank,
	<<
        "replace into chrono_rift_kf_role
        (role_id, role_name, server_id, server_num, server_name, scramble_value)
        values(~p, '~s', ~p, ~p, '~s', ~p)"
    >>).

-define(delete_chrono_rift_role_rank,
	<<
        "truncate chrono_rift_kf_role"
    >>).

%% chrono_rift_role

-define(select_chrono_rift_role,
    <<
        "select scramble_value, act_list, today_scramble_value, castle_id, today_reward_list,
        season_reward
        from chrono_rift_role
        where role_id = ~p"
    >>).

-define(save_chrono_rift_role,
    <<
        "replace into chrono_rift_role
        (role_id, scramble_value, today_scramble_value, act_list, castle_id, today_reward_list,
        season_reward)
        values(~p, ~p, ~p, '~s', ~p, '~s', '~s')"
    >>).

%% chrono_rift_kf_goal

-define(select_chrono_rift_kf_goal,
	<<
        "select server_id, server_name, server_num, goal_list, last_rank
        from chrono_rift_kf_goal"
    >>).

-define(set_chrono_rift_kf_goal,
	<<
        "update chrono_rift_kf_goal
        set goal_list = '[]'"
    >>).

-define(save_chrono_rift_kf_goal,
	<<
        "replace into chrono_rift_kf_goal
        (server_id, server_name, server_num, goal_list, last_rank)
        values(~p, '~s', ~p, '~s', ~p)"
    >>).