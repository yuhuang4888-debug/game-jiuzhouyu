%% ---------------------------------------------------------
%% Author:  chenyiming
%% Created: 2018-8-13
%% Description: 结界守护
%% name      enchantment_guard
%% --------------------------------------------------------

%% --------------------------------------------------------
%% 配置宏
-define(ENCHANTMENT_GUAND,  133).     % 功能id
-define(SEAL_COUNT_ID,      1).       % 计数器封印次数id
-define(SWEEP_COUNT_ID,     2).       % 计数器扫荡次数id
-define(SWEEP_VIP_ID,       1).       % 扫荡最大次数特权子类
-define(ENCHANTMENT_GUAND_DUN_ID,50000). %%结界副本id.
-define(ENCHANTMENT_GUAND_AUTO, 0).     %%自动挑战
-define(ENCHANTMENT_GUAND_SWEEP_HOURS, 4).     %%扫荡相当于4小时的挂机收益  之前是8个小时，现在改为4个
-define(ENCHANTMENT_GUAND_LOG_BATTLE, log_enchantment_guard_battle).     %%挑战日志
-define(ENCHANTMENT_GUAND_LOG_SEAL, log_enchantment_guard_seal).         %%封印日志
-define(ENCHANTMENT_GUAND_LOG_SWEEP, log_enchantment_guard_sweep).         %%扫荡日志
-define(ENCHANTMENT_GUAND_WAVE_KEY, 1).         %%开启等级充满波数key值


-define(enchantment_guard_yet_get_stage_reward,  2).                        %%阶段奖励已经领取
-define(enchantment_guard_can_get_stage_reward,  1).                        %%阶段奖励可以领取
-define(enchantment_guard_no_stage_reward,  1).                             %%阶段奖励不能领取
%% --------------------------------------------------------



%%数据记录


%%结界守护奖励
-record(enchantment_guard_boss_reward,{
	id = 0                      %%关卡id
	,reward_list = []           %%掉落奖励列表
	,stage_reward_list = []     %%阶段奖励列表
}).



%%结界守护关卡boss属性
-record(enchantment_guard_boss,{
	gate          = 0 ,         %%'结束关卡',
	start_gate    =0,           %% 开始关卡
	boss_lv 	= 0,			%% boss等级
	attr		= [],			%% 属性
%%	attack_add  = 0,            %% '攻击力每关卡增加值',
%%	defend_add  = 0,            %% '防御力每关卡增加值',
%%	hp_add      = 0,            %% '气血每关卡增加值',
	attr_add    = 0,            %%  属性每关卡增加万分比
	coin        = 0,            %% '金币',
	coin_add    = 0,            %%  金币关卡增加值
	exp         = 0,            %% '经验',
	exp_add     = 0,            %%  经验关卡增加值
	goods_num   = [],           %% '装备掉落数量' ,  %%和名称有出入，因为后面需求变更，这里只是填装备了
	goods_pool  = [],           %% '装备库' ,
%%	stage_reward= [],           %% '阶段奖励' ,  %%弃用 ，阶段奖励放在 #enchantment_guard_stage_reward{}
	power       = 0,            %%  推荐战力
	power_add   = 0             %%  战力每关卡增加值万分比
	,other_reward_list = []     %%  固定奖励
	,other_goods_pool  = []     %%  道具库
	,add_exp_attr_ratio = 0     %%  杀怪增加经验万分比
}).

-record(rank,{
	play_id = 0     %%玩家id
	,rank = 0       %%排名
	,name = ""      %%名字
	,gate = 0       %%关卡
	,last_time = 0  %%最后更新时间。
}).

%%结界守护状态
-record(enchantment_guard_state,{
	rank_list =[]           %%排行榜 保留前20
	,min_gate = 0           %%排行版最小关数
}).




%%结界守护记录  ps信息
-record(enchantment_guard,{
	%% spirit= 0                          % 精魄   用于兑换奖励的货币 ，打野怪所得，不记录，放在特殊货币里
	wave  = 0                            % 当前刷野怪数量 ， 不再 是波数
	,gate  = 0                           % 当前关数
	,auto  = 1                           % 自动挑战是否启动 1关闭  0 开启
    % ,mon_id = 0                          % bossid
	,stage_reward_gate = 0               %  领取过的阶段奖励关卡  ，开始的时候 默认为0
	,sweep  ={}                          % 扫荡数据。
	, soap_status = undefined			 % 古宝状态 #enchantment_soap_status{}
	, node_id = 0
	, next_assist_time = 0				% 下次可协助次数（不入库）
}).

-record(enchantment_soap_status, {
	soap_map = #{}						 % 古宝列表 #{soap_id=>#enchantment_soap_item{}}
	, attr = []							 % 提供属性
}).

-record(enchantment_soap_item, {
	soap_id = 0,
	active_debris = [],						% 激活的碎片列表
	attr = [] 								% 提供属性
}).


%%扫荡信息
-record(sweep, {
	coin = 0,                            % 扫荡所得金币
	exp  = 0,                            % 扫荡所得经验
	equip_num = 0,                       % 所得装备数量
	reward_num =0                        % 固定道具奖励数量
	,reward_list = []                    % 奖励列表 固定奖励 + 装备奖励
	,cost = []                           % 消耗
	,gate = 0                            % 扫荡关卡，看看扫荡关卡有没有变化。
}).



%%结界阶段奖励
-record(enchantment_guard_stage_reward,{
	gate =[]           %%关卡
	,reward = []       %%固定奖励
    ,goods_pool = []   %%道具库
}).

%% 结界守护古宝配置
-record(base_enchantment_guard_soap, {
	soap_id = 0,
	soap_name = [],
	condition = [],
	tv_ids = []
}).

%% 结界守护古宝碎片配置
-record(base_enchantment_guard_soap_debris, {
	soap_id = 0,
	debris_id = 0,
	debris_name = [],
	cost = [],
	attr = [],
	condition = []
}).

-define(sql_select_enchantment_soap, <<"select `soap_id`, `debris_id` from player_enchantment_guard_soap where role_id = ~p">>).
-define(sql_replace_enchantment_soap, <<"replace into `player_enchantment_guard_soap` (`role_id`, `soap_id`, `debris_id`)
	values (~p, ~p, ~p)">>).

-define(RANK_LIMIT_NUM, 50).
%% 排行版玩家信息
-record(enchantment_role_rank, {
	role_id = 0,
	server_id = 0,
	server_num = 0,
	role_name = [],
	rank = 0,
	gate = 0,
	last_time = 0,
	combat = 0       %% 玩家进榜时候的战力
}).