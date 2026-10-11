%% 键值
-define(ARBITRAMENT_LOOP_TIMES_MAX, 3). %%转盘次数
-define(ARBITRAMENT_MAX_SCORE, 5). %%转盘最大分值



%%
-record(arbitrament_status,{
	skill_from = 0			%% 技能所属的武器id
	, loop_list = [] 		%% 转盘信息
	, arbitrament_list = []
	, attr_list = []
	, passive_skills = []
}).


-record(arbitrament,{
	weapon_id = 0
	, lv = 0
	, score = 0
	, state = 0      %% 0 没有使用 1 使用中
}).

-record(arbitrament_loop,{
	weapon_id = 0
	, loop_times = 0 		%% 转盘次数
	, utime = 0 			%% 转盘时间
	, loop_no = 0 			%% 当前转盘转出的序号
	, loop_score = 0 		%% 当前转盘转出的分值
	, open_max = 0 			%% 最大分值是否已出现
}).

%% 配置
-record(base_arbitrament,{
	weapon_id = 0 		%% 
	, name = ""
	, lv = 0
	, cost_type = 0 	%% 0 普通物品消耗 1 积分消耗
	, cost = []
	, attr = []
	, skill = []
}).

-record(base_arbitrament_score,{
	no = 0 		%% 
	, score = 0
	, weight = 0 	%% 权重
}).