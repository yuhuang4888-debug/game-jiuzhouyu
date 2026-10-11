%%------------------------------------------------------------------------------
%% @Module  : tsmaps
%% @Author  : cym
%% @Created : 2019/09/03
%% @Description: 藏宝图
%%------------------------------------------------------------------------------


-define(mysterious_map, 1). %% 神秘藏宝图
-define(legend_map, 2).     %% 传说藏宝图

-define(is_rare, 1).        %% 稀有奖励
-define(is_rare2, 2).        %% 稀有奖励2
-define(is_poor, 3).        %% 稀有奖励2
-define(not_rare, 0).       %% 不是稀有奖励

-define(all_world_tv, 1).    %% 世界传闻
-define(all_server_tv, 2).   %% 全跨服传闻
-define(not_tv, 0).          %% 没有传闻
-define(tv_delay, 20 * 1000). %%  传闻最多延迟 20秒

-record(base_reward_map, {
	id = 0,
	type = 0,  %% 1 神秘藏宝图  2 传说藏宝图
	reward_list = [] %%
	, weight = 0
	, min_lv = 0
	, max_lv = 0
	, rare = 0
	, tv = 0
	, vip_lv = 0
}).



%% 神秘宝藏地图表
-record(base_tsmaps, {
	id = 0,
	lv = [],
	maps = []
}).

%% 藏宝图触发事件配置表
-record(base_tsmaps_event, {
	id = 0,
	map_type = 0,               %% 藏宝图类型    1普通，2精致，3神秘
	event = [],                 %% 触发事件      1奖励，2洞穴，3怪物；[{编号，权重}]
	holder_lv = 0,              %% 持有者等级
	holder_reward = [],         %% 持有者奖励    [{奖励品级,权重,奖励列表},{}...]
	help_reward = [],           %% 帮助者奖励    [{奖励品级,奖励列表},{}...]
	hole = [],                  %% 神秘洞穴      [{权重,[副本1,副本2]},{权重,[副本1]}]
	mon = [],                   %% 怪物          [{权重,怪物id,数量},{}...]
	holder_mon_reward = [],     %% 持有者杀怪奖励
	help_mon_reward = []        %% 帮助者杀怪奖励
}).

-record(tsmap,{
	subtype = 0,                %% 藏宝图类型
	scene = 0,
	pos = [],                   %% 藏宝图坐标  [{id,x,y,role_id, name}]
	produce_time = 0,
	time = 0                    %% 开始挖取的时间戳
}).

-record(status_tsmaps, {
	tsmap_maps = maps:new(),
	hole=[],
	goods_num = maps:new()
}).

%% ========================2022 02 25 新版本藏宝图 ===================================
%% 增加新需求，当挖宝到一定次数时，直接获得一份奖励
-define(TSMAPS_TYPE, [data_treasure_map:get_kv(map1), data_treasure_map:get_kv(map2)]).

-define(DO_TSMAPS_TYPE_TIMES, 1).  %% 藏宝图功能的挖宝次数 不清零
-record(trmaps_times_reward, {
	  type = 0,        %% 挖宝类型
	  times = 0,       %% 达标次数
	  rewards = []      %% 奖励
}).

