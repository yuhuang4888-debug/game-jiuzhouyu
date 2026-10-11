%%%-----------------------------------
%%% @Module      : seacraft_daily
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 19. 一月 2020 17:22
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-author("carlos").

-define(die, 0).
-define(live, 1).

-define(not_get_reward, 0).
-define(got_reward, 1).

-define(carrying, 1).  %%搬运状态
-define(common,   0).  %%普通状态

-define(task_week,  2).
-define(task_daily, 1).

-define(zone_recalc, 1).

-record(sea_craft_daily_state, {
	zone_list = []
	, status = 0   %% 0 可以进入 1， 不能进入
	, ref = []  %% 整点定时器
}).



-record(zone_msg, {
	zone_id = 0,
	sea_list = []
}).

-record(sea_msg, {
	zone_id = 0,
	sea_id = 0, %% 海域id
	brick_num = 0 %%砖块数量
	, statue_id = 0  %%
	, guard_id = 0  %% 守卫id
	, statue_cd = 0  %% 广播cd时间
	, guard_cd = 0   %% 广播cd时间
	, statue_status = ?die %%雕像状态
	, guard_status = ?die   %%boss状态
    , statue_ref = []  %% 复活定时器
	, statue_reborn_time = 0  %% 复活时间戳
	, guard_ref = []   %% 复活定时器
	, guard_reborn_time = 0   %% %% 复活时间戳
	, rank_list = []
	, role_list = []   %% 不保存数据库
	, statue_small_list = []
	, guard_small_list = []
}).

-record(role_rank, {
	role_id = 0,
	sea_id = 0,
	server_id = 0
	, server_num = 0
	, server_name = ""
	, role_name = ""
	, power = 0
	, pos = 0
	, brick_num = 0 %%砖块数量
	, rank = 0
}).


-record(sea_daily_task_cfg, {
	id = 0
	, type = 0   %% '1:日常 2:周常',
	, count = 0  %% '完成次数',
	, reward     %%'奖励',
	, condition = []
}).


-record(role_sea_craft_daily, {
	task_list = [] %% [{task, count, status}]
	,week_task_list = []
	,attr = [] 		  %%不保存数据库 每次重连请求跨服，主要是经验
	,carry_count = 0  %%搬运次数
	,defend_count = 0 %%保卫次数
	,brick_color = 1  %%默认是1 ， 普通砖块
	,status = ?common
	,sea_brick_num = 0
}).

-record(role_msg, {
	role_id = 0,
	role_name = "",
	zone_id = 0
	,server_id = 0
	,server_num = 0
	,sea_id = 0    %%所属阵营
	,brick_color = 1
	,job_id = 6  %%职位
	,brick_num = 0 %%夺取数量
	,power = 0
	,status = ?common
}).


-record(brick_cfg, {
	id = 0               %%'砖头id'
	,cost = []           %%'升级消耗',
	,reward = []         %%'道具奖励',
	,exp_ratio = 0       %%'经验倍率',
	,snatch_ratio = 0    %%'夺取倍率',  [{等级, 夺取数量}]
	,attr = []           %%'人物属性',
}).


-define(select_role_local_msg, <<"select  task_list, carry_count, defend_count ,
 brick_color, week_task_list  from  role_sea_craft_daily where  role_id = ~p">>).

-define(save_role_local_msg, <<"REPLACE INTO  role_sea_craft_daily(role_id, task_list, carry_count, defend_count , brick_color, week_task_list)
 VALUES(~p, '~s', ~p, ~p, ~p, '~s')">>).


-define(select_sea_msg, <<"select  birck_num from  sea_craft_daily where  zone_id = ~p  and sea_id = ~p">>).
-define(save_sea_msg, <<"REPLACE INTO  sea_craft_daily(zone_id, sea_id, birck_num)  VALUES(~p, ~p, ~p)">>).


-define(select_role_rank, <<"select  role_id, sea_id, role_name, server_id, server_num, server_name, pos, birck_num, power   from   sea_craft_daily_rank">>).
-define(save_role_rank, <<"REPLACE INTO  sea_craft_daily_rank(role_id, sea_id, role_name, server_id, server_num, server_name, pos, birck_num, power)
 VALUES(~p, ~p, '~s', ~p, ~p, '~s', ~p, ~p, ~p)">>).





















