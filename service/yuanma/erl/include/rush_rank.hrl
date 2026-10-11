%%%------------------------------------
%%% @Module  : rush_rank.hrl
%%% @Author  : hejiahua
%%% @Created : 2015-12-18
%%% @Description: 开服冲榜
%%%------------------------------------

%%(冲榜)
%% --------------------#common_rank_role.rank_type 类型---------------------
-define(RANK_TYPE_LV_RUSH,           1).                     %% 等级排行榜
-define(RANK_TYPE_MOUNT_RUSH,        2).                     %% 坐骑排行榜
-define(RANK_TYPE_SPIRIT_RUSH,      3).                      %% 精灵排行榜
-define(RANK_TYPE_RECHARGE_RUSH,     4).                     %% 今日充值排行榜
-define(RANK_TYPE_STONE_RUSH,        5).                     %% 宝石排行榜
-define(RANK_TYPE_COMBAT_RUSH,       6).                     %% 战力排行榜
-define(RANK_TYPE_AIRCRAFT_RUSH,     7).                     %% 飞行器排名
-define(RANK_TYPE_SUIT_RUSH,     8).                         %% 套装达人
-define(RANK_TYPE_SOUL_RUSH,       9).                       %% 源力排行榜
-define(RANK_TYPE_WING_RUSH,         10).                     %% 翅膀排行榜
-define(RANK_TYPE_EQUIPMENT_STRENGTHEN_RUSH, 11).             %% 强化
-define(RANK_TYPE_PET_RUSH,          12).                     %% 宠物排行榜
-define(RANK_TYPE_DRAGON,          13).                     %% 龙纹排行榜
-define(RANK_TYPE_RUNE,             14).                    %% 御魂排行榜（符文）

%% 需要开启的排行榜列表, 当需要去除或者开启增加一个类型排行榜时,需要修改这里
-define(RANK_TYPE_LIST, [
    ?RANK_TYPE_LV_RUSH
    ,?RANK_TYPE_SPIRIT_RUSH
    ,?RANK_TYPE_MOUNT_RUSH
    ,?RANK_TYPE_STONE_RUSH
    ,?RANK_TYPE_DRAGON
    ,?RANK_TYPE_COMBAT_RUSH
    ,?RANK_TYPE_RUNE
]).

%% 20220506之前的版本,部分排行榜排行数值是特殊计算的
%% 如坐骑榜，排行数值是阶数+星级级来计算的
%% 20220519 坐骑榜等不再计算阶级，单纯读取战力
-define(RUSH_RANK_SPECIAL_STAR, []).

-define(STAGE_ADD,                  1000).          %% 换算星阶

-define(NOT_REWARD,                   0).           %% 不可领状态
-define(HAVE_REWARD,                  1).           %% 可领奖励状态
-define(FINISH,                       2).           %% 完成状态


-define(RUSH_RANK_NOTIFY_TYPE_0, 0).    % 排名被超过
-define(RUSH_RANK_NOTIFY_TYPE_1, 1).    % 进入下一次阶段
-define(RUSH_RANK_NOTIFY_TYPE_2, 2).    % 登临榜首
-define(RUSH_RANK_NOTIFY_TYPE_3, 3).    % 到达阈值条件
-define(RUSH_RANK_NOTIFY_TYPE_4, 4).    % 第二名超过条件

-define(close_day , 9).                             %% 活动关闭天数

-define(NOT_SHOW_COMBAT, 0).              %% 显示阶数
-define(IS_SHOW_COMBAT,  1).              %% 显示战力

%% 冲榜活动配置
-record(base_rush_rank, {
       id               = 0,            % 活动id
       name             = "",           % 活动名称
       start_day        = 0,            % 开服第几天开始
       clear_day        = 0,            % 开服第几天结算
       max_len          = 0,            % 榜单长度
       limit            = [],            % 上榜阈值
       new_limit        = [],           % 新上榜阈值
       figure_id        = 0,            % 第一名额外奖励展示资源
       scale            = 0,            % 缩放比例
       angle            = 0,             % 角度
       open_start_time  = "",           % 服开始时间戳##闭区间
       open_end_time    = "",            % 服结束时间戳##闭区间
       open_day_list    = []            % 使用新规则的开服天数列表
       }).

%% 冲榜排行奖励配置
-record(base_rush_rank_reward, {
       id               = 0,            % 排行榜类型Id
       reward_id        = 0,            % 奖励Id
       rank_min         = 0,            % 排名上限
       rank_max         = 0,            % 排名下限
       limit_val        = 0,            % 上榜阈值
       new_limit_val    = 0,            % 新上榜阈值
       reward           = []            % 奖励
       }).

%% 冲榜目标奖励配置
-record(base_rush_goal_reward, {
       id               = 0,            % 活动id
       reward_id        = 0,            % 奖励Id
       goal_value       = [],            % 目标值
       reward           = []            % 奖励
       }).

%% 冲榜获取途径跳转配置
-record(base_rush_rank_jump, {
       jump_id          = 0,           % 跳转id
       module_id        = 0,           % 模块id
       type_id          = 0,           % 类型id
       sub_id           = 0,           % 子id
       label            = 0,           % 0代表无标识，1代表超值，2代表必买（必买为限时途径）
       desc             = ""           % 描述
    }).

%% 冲榜榜单的角色信息
-record(rush_rank_role, {
        role_key        = undefined,    % 玩家的唯一键 {RankType, SubType, RoleId},
        accid           = 0,            % 玩家账号id
        accname         = [],           % 玩家账号
        rank_type       = 0,            % 榜单类型
        sub_type        = 0,            % 在定制活动里配置，一般都会是1
        role_id         = 0,            % 角色Id
        value           = 0,            % 值
        time            = 0,            % 时间
        rank            = 0,            % 名次
        get_reward_status= ?NOT_REWARD  % 排行榜获取状态
        }).

%% 通用榜单的进程状态
-record(rush_rank_state, {
        rank_maps = maps:new(),         % Key:{RankType,SubType} Value:[#rush_rank_role{}|...]
        rank_limit = maps:new(),        % #{{RankType, SubType} => Limit}
        goal_maps = maps:new()          %% 目标奖励信息 {RankType, SubType, RoleId} => [{GoalId, RewardState}]
        ,all_rank_maps = maps:new()         %% 所有在排位玩家的排位值，为了不增加榜单的长度，另外加   {RankType, SubType, RoleId} => {value}
        ,role_send_time_limit = maps:new()  %% 玩家发送排名变化信息的时间限制  RankType => #{ RoleId => TimeLimit }
        }).

-define(sql_rush_rank_role_select, <<"
    SELECT
        rank_type, sub_type, player_id, value, time, get_reward_status
    FROM rush_rank_role">>).

-define(sql_rush_rank_goal_select, <<"
    SELECT
        rank_type, sub_type, player_id, goal_list
    FROM rush_rank_goal">>).

-define(sql_rush_rank_role_save, <<"
    replace into rush_rank_role(
        rank_type, sub_type, player_id, value, time, get_reward_status
    ) values(~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_rush_rank_goal_save, <<"
    replace into rush_rank_goal(
        rank_type, sub_type, player_id, goal_list
    ) values(~p, ~p, ~p, ~p)">>).

-define(sql_rush_rank_role_delete_by_role_id, <<"delete from rush_rank_role
            where rank_type = ~p and sub_type = ~p and player_id = ~p">>).

-define(sql_rush_rank_role_delete_by_role_ids, <<"delete from rush_rank_role
             ~s and rank_type = ~p and sub_type = ~p ">>).

-define(sql_rush_rank_role_delete_by_value, <<"delete from rush_rank_role
             where rank_type = ~p and sub_type = ~p and value < ~p ">>).
-define(slq_rush_rank_role_update_rewardStatus,
    <<"UPDATE   rush_rank_role  set  get_reward_status  = ~p  where rank_type = ~p and  sub_type = ~p">>).

-define(sql_rush_rank_all_role, <<"
    SELECT
        rank_type, sub_type, player_id, value
    FROM rush_rank_all_role">>).

-define(sql_rush_rank_all_role_save, <<"
    replace into rush_rank_all_role(
        rank_type, sub_type, player_id, value
    ) values(~p, ~p, ~p, ~p)">>).

-define(del_rush_rank_all_role, <<"TRUNCATE TABLE  `rush_rank_all_role`">>).
-define(del_rush_rank_role, <<"TRUNCATE TABLE  `rush_rank_role`">>).
-define(del_rush_rank_goal, <<"TRUNCATE TABLE `rush_rank_goal`">>).