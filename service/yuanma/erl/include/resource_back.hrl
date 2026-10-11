-define(TODAY, 		0).        % 今天
-define(YESTERDAY, 	1).        % 昨天
-define(B_YESTERDAY, 2).        % 前天
-define(RESOURCE_BACK_OPEN_LV, 	20).        % 开放等级

-define(STATE_NOT_FIND, 0).        % 未找回
-define(STATE_FIND, 	1).        % 已找回
-define(STATE_FINISHED, 	2).        % 已完成

%% 资源找回配置
-record(base_res_act, {
		act_id = 0,			% 模块id
		act_sub = 0,		% 模块子id
		level = 0,			% 等级需求
		task_id = 0,        % 任务id
		name = "",			% 名字
		dun_id = 0,			% 副本id(副本类型找回 需通关的副本id)
		guild_limit = 0,    % 公会限制（1：需要公会 0：不需要）
		coin_per = [],		% 金币消耗
		coin_goods = [],	% 金币对应奖励
		gold_per = [],		% 绑钻消耗
		gold_goods = []		% 绑钻对应奖励
		,vip_type = 0       % 额外找回vip类型
		,fixation_count = 0 % 固定次数
		,fixation_vip_type = 0 %% 固定找回vip类型
	    ,other_cost = []    % 额外消耗
	}).

-record(resource_back, {
		cleartime = 0,			%% 结算时间
		res_act_map = #{}	    %% #{?DayType => #{actid => #res_act{} }}
	}).

-record(res_act, {
		act_id = 0,				%% 模块id
		act_sub = 0,			%% 模块子id
		lefttimes = 0,			%% 剩余次数  vip固定 + 普通 + 购买
		max = 0,				%% 最大次数
		state = ?STATE_NOT_FIND %% 状态
		,vip_buy_time = 0       %% vip购买次数  vip购买了多少次
		,max_vip_buy_time = 0   %% vip最大购买次数
		,max_vip_fixation_times=0 %% 普通最大次数 和vip挂钩  vip固定 + 普通
	}).


-define(SQL_BATCH_REPLACE_RES_BACK,         "replace into `resource_back`(player_id, cleartime, daytype, act_list) values").
-define(SQL_BATCH_REPLACE_VALUES,         <<"(~p, ~p, ~p, '~s') ">>).
-define(SQL_SELECT_RES_BACK,         "select cleartime,daytype,act_list from `resource_back` where player_id=~p ").