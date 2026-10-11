

-define(ROTARY_KEY_1,  1).   %% 低级抽奖1次消耗
-define(ROTARY_KEY_2,  2).   %% 高级抽奖1次消耗
-define(ROTARY_KEY_3,  3).    %% 低级抽奖10次消耗
-define(ROTARY_KEY_4,  4).  %% 高级抽奖10次消耗
-define(ROTARY_KEY_5,  5).  %% 低级抽奖加的祝福值
-define(ROTARY_KEY_6,  6).   %% 高级抽奖加的祝福值
-define(ROTARY_KEY_7,  7).   %% 初始祝福值
%% 
-record(spirit_rotary_status,{
	bless_value = 100
	, acc_count = 0               %% 抽奖总次数
}).


%% 配置
-record(base_spirit_rotary,{
	bless_value_1 = 0         %% 祝福值1
	, bless_value_2 = 0         %% 祝福值2
	, reward_pool = []
	, high_reward_pool = []
	, shows = []
}).