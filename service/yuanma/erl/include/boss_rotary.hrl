
-define(BOSS_ROTARY_KEY_1, 1).  %% boss转盘每日次数
-define(BOSS_ROTARY_KEY_2, 2).  %% boss转盘消耗
-define(BOSS_ROTARY_KEY_3, 3).  %% boss转盘触发等级


-record(boss_rotary, {
    rotary_list = []              %% 转盘列表
    }).

-record(rotary_info, {
	rotary_id = 0,                      %% 转盘id自增
    boss_type = 0,                        %% 
    boss_reward_lv = 0,               %% 奖励等级
    wlv = 0,
    boss_id = 0,
    is_abandon = 0,                   %% 客户端是否已经放弃该转盘
    reward_get = [],                  %% [{奖池id, 奖励id, 是否已领取}]
    reward_show = [],                  %% [{奖池id, 奖励id, 是否已领取}] 展示奖励
    time = 0                          %% 转盘生成时间
    }).

-record(base_boss_rotary, {
	boss_type = 0,                     
    boss_reward_lv = 0,          
    wlv = 0,                   %% 世界等级           
    pool_id = 0,               %% 奖池id
   	reward_id = 0,                  %% 奖励id
   	weight = 0,               %% 权重
    rewards = [],                  %% 奖励列表
    rare = 0,          %% 珍惜度
    is_tv = 0
    }).