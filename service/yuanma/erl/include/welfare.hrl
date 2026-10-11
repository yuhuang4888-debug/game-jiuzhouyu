%%-----------------------------------------------------------------------------
%% @Module  :       welfare
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-29
%% @Description:    福利(各种福利活动)
%%-----------------------------------------------------------------------------

%% 排名奖励配置
-record(base_welfare_night_reward, {
    id = 0,
    lv_region = [],             %% 等级区间 [{min_lv, max_lv}]
    reward = []                 %% 奖励
}).

-record(base_combat_welfare_reward, {
	round = 0,
	reward_id = 0,
	weight = [],
	reward = [],
	tv_id = []
}).

-record(base_grow_welfare_info, {
	task_id = 0,
	task_type = 0,
	condition = [],
	reward = [],
	desc = [],
	open_day = 0
}).

%% 在线奖励配置
-record(online_reward_cfg,{
	id = 0,					    %% 在线奖励礼包id
	online_time = 0,		    %% 在线时长（s）
	lv_min = 0,                 %% 最小等级
	lv_max = 0,					%% 最大等级
	world_lv_min = 0, 			%% 最小世界等级
	world_lv_max = 0,			%% 最大世界等级
	reward = []                 %% 奖励[{id, 0/1/2}] 未达成/已完成未领取/已领取
}).

%% 分享有礼
-record(status_share, {
    times = 0,                  %% 分享总次数
    status = 0,                 %% 0:未分享 1:已分享未领取奖励 2:已经领取奖励
    last_receive_time = 0       %% 最后一次领取奖励时间
    }).

%% 在线奖励
-record(status_online_reward,{
	login_time = 0,             %% 本次登陆时间
	online_time = 0,			%% 累计在线时间
	time = 0,                   %% 时间
	reward = []					%% 奖励状态[{id, 0/1/2}] 未达成/已完成未领取/已领取
	}).

-define(DEFAULT_RESET_TIME,  86400). %% 默认重置时间

-define(DEFAULT_OPEN_LV,  30). %% 默认开启等级

-define(SHARE_STATUS_NO,     0). %% 未分享
-define(SHARE_STATUS_FIN,    1). %% 已分享未领取奖励
-define(SHARE_STATUS_REC,    2). %% 已经领取奖励

%% 福利类型
-define(WELFARE_DAILY_CHECKIN,  1). % 每日签到

-define(sql_select_share, <<"select `times`, `status`, `last_receive_time` from `share_gift` where `role_id` = ~p">>).
-define(sql_insert_share, <<"insert into `share_gift` (`role_id`, `times`, `status`, `last_receive_time`) values(~p, ~p, ~p, ~p)">>).
-define(sql_update_share_times, <<"update `share_gift` set `times` = ~p, `status` = ~p where `role_id` = ~p">>).
-define(sql_update_share_reward_time, <<"update `share_gift` set `last_receive_time` = ~p, `status` = ~p where `role_id` = ~p">>).

-define(sql_select_online, <<"select `reward_state`, `time_online`, `utime` from `online_reward` where `roleid` = ~p">>).
% -define(sql_insert_online, <<"insert into `online_reward` (`roleid`, `reward_state`, `time_online`) values(~p, ~p, ~p)">>).
-define(sql_update_online, <<"update `online_reward` set `reward_state` = ~p, `time_online` = ~p, `utime` = ~p where `roleid` = ~p">>).
-define(sql_replace_online, <<"replace into `online_reward` (`reward_state`, `time_online`,`roleid`, `utime`) values(~p, ~p, ~p, ~p)">>).
-define(sql_refresh_online, <<"truncate `online_reward`">>).

%% ====================== 成长福利 =========================
%% 玩家内存信息 server.hrl
-record(status_grow_welfare, {
	task_list = []				%% 任务列表 grow_welfare_task{}
}).

%% 成长任务详情
-record(grow_welfare_task, {
	task_id = 0,
	status = 0,
	process = 0
}).

-define(GROW_WELFARE_CANT_RECEIVE, 	0).			% 奖励不可领取
-define(GROW_WELFARE_CAN_RECEIVE, 	1).			% 奖励可领取
-define(GROW_WELFARE_HAD_RECEIVE, 	2).			% 奖励已领取

-define(sql_select_grow_welfare, <<"select `task_id`, `process`, `status` from `role_grow_welfare_task` where role_id = ~p">>).
-define(sql_replace_grow_welfare, <<"replace into `role_grow_welfare_task` (`role_id`, `task_id`, `process`, `status`) values (~p, ~p, ~p, ~p)">>).

%% ================== 战力福利 ================================

-define(SQL_GET_COMBAT_WELFARE, <<"select `round`, `times`, `index`, `reward_list` from combat_welfare where player_id = ~p">>).
-define(SAVE_COMBAT_WELFARE_DATA, <<"REPLACE INTO `combat_welfare`(`player_id`,`round`, `times`, `index`, `reward_list`)VALUES(~p,~p,~p,~p,'~s')">>).

-record(status_combat_welfare, {
	round = 0,        %% 当前轮数
	times = 0,        %% 当前剩余抽奖次数d
	index = 0,        %% 上一次带来抽奖次数的下标
	reward_list = []  %% 当轮已抽取的奖励Id
}).

