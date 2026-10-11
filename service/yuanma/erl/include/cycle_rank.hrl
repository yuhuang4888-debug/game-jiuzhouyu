%%---------------------------------------------------------------------------
%% @doc:        cycle_rank
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-3月-21. 11:38
%% @deprecated: 循环冲榜
%%---------------------------------------------------------------------------


%% ================================================
%% 配置头文件定义
%% ================================================

-record(base_cycle_rank_info, {
    id = {0, 0},
    type = 0,
    sub_type = 0,
    name = "",
    open_day = 0,
    open_over = 0,
    start_time = 0,
    end_time = 0,
    banned_time = 0,
    show_id = 0,
    show_type = 0
}).

-record(base_reach_reward_info, {
    type = 0,
    sub_type = 0,
    reward_id = 0,
    need = 0,
    rewards = []
}).

-record(base_cycle_rank_reward, {
    type = 0,
    sub_type = 0,
    reward_id = 0,
    rank_min = 0,
    rank_max = 0,
    limit_val = 0,
    rewards = [],
    reward = ""
}).

%% =========================================
%% 功能数据结构
%% =========================================

%% 中心进程的记录
-record(cluster_rank_status, {
    all_cycle_rank = [],         %% 所有符合时间段要求的循环冲榜活动信息
    opening_act = [],            %% 开启中的活动 [#base_race_act_info{}]
    show_act_info = [],          %% 处于展示期间的活动信息 [#base_race_act_info{}]
    start_timer = 0,             %% 定时关闭活动的定时器
    end_timer = 0,               %% 定时开启活动的定时器
    show_timer = 0,              %% 定时关闭展示活动的定时器
    rank_list = [],              %% 活动榜单，格式[#rank_type{}]
    role_send_time_limit = maps:new()  %% 玩家发送排名变化信息的时间限制  RankType => #{ RoleId => TimeLimit }
}).

-record(game_rank_status, {
    all_act = [],                %% 所有活动消息
    opening_act = [],            %% 开启中的活动 [#base_race_act_info{}]
    showing_act = [],            %% 处于展示期的的活动 [#base_race_act_info{}]
    rank_list = [],              %% 活动榜单，格式[#rank_type{}]
    ref = 0,                     %% 请求同步定时器
    role_send_time_limit = #{}   %% 玩家发送距离上榜弹窗的时间限制  RankType => #{ RoleId => TimeLimit }
}).

%% 上榜时玩家的信息
-record(rank_role, {
    id = 0              %% 玩家id
    ,server_id = 0      %% 服务器id
    ,platform = []      %% 平台
    ,server_num = 0     %% 服务器数
    ,node = none        %% 所在节点
    ,score = 0          %% 分数
    ,rank = 0           %% 排名
    ,figure = undefined
    ,last_time = 0      %% 上榜时间
}).

%% 指定类型排行
-record(rank_type, {
    id = {0,0},                 %% 主键，格式{type,subtype}
    type = 0,                   %% 主类型
    subtype = 0,                %% 次类型
    rank_role_list = [],        %% 格式[#rank_role{}]
    score_limit = 0             %% 最后一名分数
}).

%% 玩家循环冲榜数据
-record(status_cycle_rank_info, {
    id = {0, 0},           %% 主键
    type = 0,              %% 主类型
    sub_type = 0,          %% 子类型
    score = 0,             %% 个人积分
    reward_state = [],     %% 达成未领取的奖励
    reward_got = [],       %% 达成已领取的奖励
    end_time = 0,          %% 活动结束时间
    other = []             %% 其他(备用)
}).

%% #status_cycle_rank_info{} 中other的主键
-define(ACT_SHOW_END_TIME,       1).  %% 该活动结束展示的时间，展示时间过期后，才会清除本条数据
-define(ACT_REACH_REWARD_EMAIL,  2).  %% 该次活动是否已经补发过邮件奖励

%% 达标奖励的领取状态
-define(REWARD_NOT_GET,      1).   %% 未领取
-define(REWARD_HAS_GET,      2).   %% 已领取
-define(REWARD_NOT_REACH,    3).   %% 条件未达成

%% 排名变化类型
-define(CYCLE_RANK_NOTIFY_TYPE_0, 0).    % 0. 登录榜首
-define(CYCLE_RANK_NOTIFY_TYPE_1, 1).    % 1. 则显示玩家提高xx分可领取目标奖励
-define(CYCLE_RANK_NOTIFY_TYPE_2, 2).    % 2. 若与排名积分比较接近, 则每次显示玩家提升xx分可超过下一阶段最后一名。
-define(CYCLE_RANK_NOTIFY_TYPE_3, 3).    % 3. 当排名被超过时，显示"冲榜排名已被/其他玩家超越"

%% 是否在跨服上需要重新排序
-define(NOT_NEED_TO_BE_REORDERED,   0).    %% 不需要重新排行，只需更新最新的值即可
-define(NEED_TO_BE_REORDERED,       1).    %% 需要更新排行


%% =====================================================
%% SQL
%% =====================================================

%% ================ 玩家循环冲榜数据 =====================
%% 获取role_id 所有存在的活动数据
-define(sql_select_player_cycle_info,
    <<"SELECT `role_id`,`type`, `subtype`, `score`,`reward_list`,`score_reward`,`other`, `end_time` FROM player_cycle_rank_role where role_id = ~p">>).

-define(sql_select_player_cycle_info_by_type,
    <<"SELECT `role_id`,`type`, `subtype`, `score`,`reward_list`,`score_reward`,`other`, FROM player_cycle_rank_role where role_id = ~p and type = ~p and sub_type = ~p">>).

-define(sql_delete_player_cycle_info_by_type,
    <<"delete from `player_cycle_rank_role` where role_id = ~p and type = ~p and subtype = ~p">>).

-define(sql_update_player_cycle_rank_reward,
    <<"update player_cycle_rank_role set reward_list = ~p, score_reward = ~p where role_id = ~p and type = ~p and subtype = ~p">>).

-define(sql_update_player_cycle_rank_state,
    <<"update player_cycle_rank_role set reward_list = ~p, score = ~p where role_id = ~p and type = ~p and subtype = ~p">>).

-define(sql_replace_player_cycle_rank_info,
    <<"replace into `player_cycle_rank_role`(`role_id`, `type`, `subtype`, `score`, `reward_list`,`score_reward`, `other`, `end_time`)values(~p, ~p, ~p, ~p, '~s', '~s', '~s', ~p)">>).

-define(sql_update_player_cycle_rank_other,
    <<"update player_cycle_rank_role set reward_list = ~p, score_reward = ~p, other = ~p where role_id = ~p and type = ~p and subtype = ~p">>).


%% ================= 榜单玩家数据库操作 ================

-define(sql_select_all_cycle_rank_info,
    <<"SELECT
       `role_id`,`type`, `subtype`,`server_id`,`platform`,`server_num`,`name`, `score`,`time`
       FROM cycle_rank_role_info order by score desc">>).

-define(sql_delete_cycle_rank_info,
    <<"delete from `cycle_rank_role_info` where type = ~p and subtype = ~p">>).

-define(sql_cycle_rank_role_replace,
    <<"replace into `cycle_rank_role_info`(`role_id`,`type`, `subtype`,`server_id`,`platform`,`server_num`,`name`, `score`,`time`)values(~p, ~p, ~p, ~p, '~s',~p, '~s', ~p, ~p)">>).

-define(sql_delete_cycle_rank_info_by_role_id,
    <<"delete from `cycle_rank_role_info` where type=~p and subtype=~p and role_id=~p">>).