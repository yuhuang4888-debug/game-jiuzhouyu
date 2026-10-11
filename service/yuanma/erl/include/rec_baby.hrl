
%%%%%%%%%%%%%%%%%%%%%%%%%%%  常量配置
-define(active_level, (data_baby_new:get_key(1))).  %% 宝宝解锁等级
-define(active_cost, (data_baby_new:get_key(2))).  %% 宝宝解锁消耗
-define(stage_open_lv, (data_baby_new:get_key(3))).  %% 宝宝升阶解锁等级
-define(stage_exp_goods, (data_baby_new:get_key(4))).  %% 宝宝升阶经验道具
-define(praise_reward_times, (data_baby_new:get_key(5))). %% 点赞奖励次数
-define(praise_reward, (data_baby_new:get_key(6))). %% 点赞奖励
-define(rename_cost, (data_baby_new:get_key(7))). %% 宝宝改名消耗
-define(equip_exp_goods, (data_baby_new:get_key(8))).  %% 装备升阶经验材料

%%%%%%%%%%%%%%%%%%%%%%%%%%%  属性类型
-define(ATTR_TYPE_RAISE, 1).  %% 养育基础属性
-define(ATTR_TYPE_STAGE, 2).  %% 升阶基础属性
-define(ATTR_TYPE_EQUIP, 3).  %% 特长属性
-define(ATTR_TYPE_FIGURE, 4).  %% 幻化属性
-define(ATTR_TYPE_MATE, 5). %% 伴侣宝宝提供的属性


%%%%%%%%%%%%%%%%%%%%%%%%%%%  sql
%% 宝宝基本信息
-define(sql_select_baby_basic_all, 
	<<"SELECT `role_id`, `active_time`, `baby_id`, `baby_name`, `raise_lv`, `stage`, `stage_lv`, `power` FROM `role_baby_basic`">>).  %% 
-define(sql_select_baby_basic, 
	<<"SELECT `active_time`, `baby_id`, `baby_name`, `raise_lv`, `raise_exp`, `stage`, `stage_lv`, `stage_exp`, `power` FROM `role_baby_basic` where `role_id`=~p">>).  %% 
-define(sql_replace_baby_basic, 
	<<"replace into `role_baby_basic` (`role_id`, `active_time`, `baby_id`, `baby_name`, `raise_lv`, `raise_exp`, `stage`, `stage_lv`, `stage_exp`, `power`) 
	values (~p, ~p, ~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p)">>).  %% 
-define(sql_update_baby_basic_raise, 
	<<"update `role_baby_basic` set `raise_lv`=~p, `raise_exp`=~p where `role_id` = ~p">>).  %% 
-define(sql_update_baby_basic_stage, 
	<<"update `role_baby_basic` set `stage`=~p, `stage_lv`=~p,  `stage_exp`=~p where `role_id` = ~p">>).  %% 
-define(sql_update_baby_basic_baby_id, 
	<<"update `role_baby_basic` set `baby_id`=~p, `baby_name`='~s' where `role_id` = ~p">>).  %% 
-define(sql_update_baby_basic_power, 
	<<"update `role_baby_basic` set `power`=~p where `role_id` = ~p">>).  %% 

%% 宝宝装备
-define(sql_select_baby_equips, 
	<<"SELECT `pos_id`, `id`, `goods_id`, `stage`, `stage_lv`, `stage_exp`, `skill_id` FROM `role_baby_equip` where `role_id`=~p">>).
-define(sql_replace_baby_equip, 
	<<"replace into `role_baby_equip` (`role_id`, `pos_id`, `id`, `goods_id`, `stage`, `stage_lv`, `stage_exp`, `skill_id`) values (~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_update_baby_equip_stage, 
	<<"update `role_baby_equip` set `stage`=~p, `stage_lv`=~p, `stage_exp`=~p where `role_id`=~p and `pos_id`=~p ">>).
-define(sql_update_baby_equip_skill, 
	<<"update `role_baby_equip` set `skill_id`=~p where `role_id`=~p and `pos_id`=~p ">>).

%% 宝宝幻化
-define(sql_select_baby_figure, 
	<<"SELECT `baby_id`, `baby_star` FROM `role_baby_figure` where `role_id`=~p">>).
-define(sql_replace_baby_figure, 
	<<"replace into `role_baby_figure` (`role_id`, `baby_id`, `baby_star`) values (~p, ~p, ~p) ">>).

%% 宝宝养育任务
-define(sql_select_baby_task_all, 
	<<"SELECT `role_id`, `task_id`, `finish_num`, `finish_state` FROM `role_baby_task`">>).
-define(sql_select_baby_task, 
	<<"SELECT `task_id`, `finish_num`, `finish_state` FROM `role_baby_task` where `role_id`=~p">>).
-define(sql_replace_baby_task, 
	<<"replace into `role_baby_task` (`role_id`, `task_id`, `finish_num`, `finish_state`) values (~p, ~p, ~p, ~p)">>).
-define(sql_delete_baby_task, 
	<<"truncate table `role_baby_task`">>).

%% 宝宝点赞
-define(sql_select_baby_praise, 
	<<"SELECT `role_id`, `praiser_id`, `praise_name` FROM `role_baby_praise`">>).
-define(sql_replace_baby_praise, 
	<<"replace into `role_baby_praise` (`role_id`, `praiser_id`, `praise_name`) values (~p, ~p, '~s')">>).
-define(sql_delete_baby_praise, 
	<<"truncate table `role_baby_praise`">>).

%%%%%%%%%%%%%%%%%%%%%%%%%%% ets表
-define(ets_baby_basic, ets_baby_basic).

%% 存放在ets表中
-record(baby_basic, {
	role_id = 0        %% 玩家id
	, active_time = 0  %% 激活时间
    , baby_id = 0      %% 当前宝宝id
    , baby_name = ""
    , raise_lv = 1   %% 养育等级
    , stage = 1        %% 宝宝阶数
    , stage_lv = 0     %% 阶数等级
    , equip_list = []   %% 宝宝特长 [#baby_equip{}]
    , active_list = []  %% 激活列表 [#baby_figure{}]
    , total_power = 0
}).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% baby status 信息
-record(status_baby, {
    active_time = 0
    , baby_id = 0      %% 当前宝宝id
    , baby_name = ""
    , raise_lv = 0   %% 养育等级
    , raise_exp = 0  %% 养育经验
    , stage = 1        %% 宝宝阶数
    , stage_lv = 0     %% 阶数等级
    , stage_exp = 0    %% 阶数经验值
    , equip_list = []   %% 宝宝特长 [#baby_equip{}]
    , active_list = []  %% 激活列表 [#baby_figure{}]
    , attr_list = []   %% 属性列表
    , total_attr = []  %% 总属性
    , skill_power = 0
    , total_power = 0
}).

%% 宝宝幻化信息
-record(baby_figure, {
    baby_id = 0      %% 宝宝id
    , baby_star = 0    %% 星数
}).

%% 宝宝特长信息
-record(baby_equip, {
    pos_id = 0      %% 位置
    , id = 0            %% 物品id
    , goods_id = 0    %% 物品配置id
    , stage = 0    %% 阶数
    , stage_lv = 0  %% 等级
    , stage_exp = 0  %% 经验值
    , skill_id = 0   %% 技能id
}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  宝宝进程state 
%% 
-record(baby_state, {
    task_map = #{}      %% 宝宝任务 role_id => [#baby_task{}]
    ,  praise_map = #{}  %% 宝宝点赞 role_id => #praise_info{}
}).

%% 宝宝任务信息
-record(baby_task, {
    task_id = 0      %% 任务id
    , finish_num = 0    %% 完成数量
    , finish_state = 0    %% 完成状态
}).

%% 宝宝点赞信息
-record(praise_info, {
	role_id = 0
	, role_name = ""
	, fan_list = []  %% 点赞的玩家列表
}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 配置

%% 养育配置
-record(base_baby_raise, {
	task_id = 0
	, mod_id = 0		 %% 功能id
	, sub_mod = 0         %% 子功能id
	, open_lv = 0         %% 开启等级
	, desc = ""
	, num_con = 0
	, raise_exp = 0      %% 养育值
}).

%% 培养配置
-record(base_baby_stage, {
	type = 0             %% 类型 1 养育 2 升阶
	, stage = 0		 %% 阶数 
	, level = 0         %% 等级
	, exp_con = 0         %% 经验
	, base_attr = []      %% 基础属性
	, extra_attr = []      %% 额外属性(伴侣的属性)
}).

%% 宝宝装备配置
-record(base_baby_equip, {
	goods_id = 0             %% 特长id(对应物品id)
	, pos_id = 0		 %% 部位 
	, color = 0         %% 品质
	, equip_stage = 0     %% 穿戴阶数
	, skills = 0
	, gen_ratio = 0      %% 生成概率
	, compose_ratio = []      %% 合成概率
	, score = 0
}).

%% 装备升级
-record(base_baby_equip_stren, {
	pos_id = 0		 %% 部位 
	, stage = 0         %% 阶数
	, stage_lv = 0       %% 等级
	, point_con = 0         %% 所需知识点
	, base_attr = []      %% 基础属性
}).
%% 装备升阶
-record(base_baby_equip_stage, {
	stage = 0         %% 阶数
	, cost = []         %% 升阶消耗
	, base_attr = []      %% 基础属性
}).

%% 装备铭刻
-record(base_baby_equip_engrave, {
	color = 0
	, goods_id = 0         %% 道具id
	, num = 0         %% 消耗数量
	, ratio = 0     %% 激活概率
}).

%% 幻化
-record(base_baby_figure, {
	baby_id = 0		 %% 宝宝id
	, baby_name_con = 0         %% 名字
	, desc = ""         %% 
	, resource_id = 0   %% 资源
	, active_stage = 0
	, cost = []      %% 消耗
	, power = 0
}).

%% 幻化升星
-record(base_baby_figure_star, {
	baby_id = 0		 %% 宝宝id  
	, star = 0   %% 星数
	, cost = []      %% 消耗
	, base_attr = [] %% 属性
	, power = 0
}).

%% 点赞
-record(base_baby_praise, {
	rank1 = 0		 %% 排名上限
	, rank2 = 0   %% 排名下限
	, reward = []      %% 奖励
}).