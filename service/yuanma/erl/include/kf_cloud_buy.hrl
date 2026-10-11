

-define(CLD_TV_RECORD_LEN, 100).		%%

%% 
-record(kf_cld_buy_state,{
	act_list = []
	, ref = []
}).

%% 
% -record(cld_buy_state,{
% 	act_list = []         %% 同步活动的时间信息到本服
% }).

%% 
% -record(cld_buy_act_little,{
% 	type = 0
% 	, subtype = 0
% 	, start_time = 0
% 	, end_time = 0
% 	, clear_time = 0
% 	, buy_endtime = 0
% }).

%% 
-record(cld_buy_act,{
	key = {0, 0}
	, type = 0
	, subtype = 0
	, start_time = 0
	, end_time = 0
	, reset_time = 0
	, buy_endtime = 0
	, zone_list = []      %% [#cld_zone{}]
	, role_map = #{}
	, ref = []
}).

%% 
-record(cld_zone,{
	zone_id = 0
	, type = 0
	, subtype = 0
	, wlv = 0
	, loop = 1
	, big_rewards = []     %% 大奖状态
	, tv_records = []
	, big_rewards_records = []
}).

%% 
-record(cld_buy_role,{
	role_id = 0
	, type = 0
	, subtype = 0
	, zone_id = 0
	, name = ""
	, server_id = 0
	, server_num = 0
	, big_rewards_count = []     %% 大奖抽奖次数
	, total_count = 0            %% 抽奖总次数
	, stage_rewards = []
}).

-record(big_rewards_record,{
	role_id = 0
	, type = 0
	, subtype = 0
	, zone_id = 0
	, name = ""
	, server_id = 0
	, server_num = 0
	, grade_id = 0
	, count = 0
	, time = 0
}).

-record(tv_record,{
	role_id = 0
	, type = 0
	, subtype = 0
	, zone_id = 0
	, name = ""
	, server_id = 0
	, server_num = 0
	, rewards = []
	, time = 0
}).

%% =========================================== 配置
-record(base_cld_buy_act,{
	type = 0
	, subtype = 0
	, start_time = 0
	, end_time = 0
	, op_days = []
	, merge_days = []
	, big_rewards = []     %% 大奖列表 [{wlv, [id]}]
	, reset_type = 2       %% 重置类型(一定有重置) 1：0点 2:4点
	, buy_endtime = []     %% [{23,0,0}] 23点结束购买
}).

-record(base_cld_buy_big_reward,{
	grade_id = 0              %% 大奖id
	, rewards = []
	, all_count = 0
	, costs = []
	, values = 0               %% 价值
	, pool_id = 0              %% 奖池id
	, rewards_show = []
}).

-record(base_cld_buy_reward_pool,{
	pool_id = 0              %% 奖池id
	, reward_id = 0          %% 奖励id
	, start_count = 0
	, end_count = 0
	, weight = 0               %% 权重
	, weight_extra = 0         %% 额外权重
	, rewards = []
}).

-record(base_cld_buy_stage_reward,{
	type = 0                 %% 活动类型
	, count = 0              %% 累积份数
	, wlv = 0
	, rewards = []
}).

