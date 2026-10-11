%%%-----------------------------------
%%% @Module      : soul_dungeon
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 18. 十一月 2018 4:37
%%% @Description : 文件摘要
%%%-----------------------------------
-author("chenyiming").



-record(soul_dungeon, {
	role_dungeon_list = []      %% [#role_soul_dungeon]
}).

-define(boss_create_status,  boss_create_status).   %%副本中type_data 的key, value是当前boss的召唤状态

-define(boss_can_create ,  1).     %%boss可以召唤， 默认是可以召唤
-define(boss_can_not_create ,  2). %%boss不可以可以召唤



-record(role_soul_dungeon, {
	role_id   =  undefine       %% 玩家id
	,kill_mon =  0              %% 击杀怪物数量
	,power    =  0              %% 当前能量
	,max_kill =  0              %% 最大击杀
	,reward_status = []         %% 奖励状态      [{副本id, 状态}] 0  不能领取  1：可以领取  2 已经领取
%%	,skill_list = []            %% 技能列表      [{技能id, 所需能量}]
}).

-record(soul_dungeon_ps, {
	role_dungeon_list = []      %% [#soul_dungeon_ps_sub]
}).

-record(soul_dungeon_ps_sub, {
	dun_id = 0,                 %% 副本id
	status = 0,                 %% 领取状态  0 未领取  1 可以领取  2 已经领取
	max_wave = 0                %% 最大波数
}).



-record(soul_dungeon_reward, {
	dun_id  = 0,                %% 副本id
	grade   =  0                %% 档次   1:C, 2:B, 3:A, 4:S, 5:SS , 6:SSS
	,kill_min  =  0             %% 怪物击杀下限
	,kill_max =  0              %% 怪物击杀上限
	,reward_list    =  []       %% 通关奖励
	,sweep_reward_list = []     %% 扫荡奖励(单次)
	,boss_rewrad_list  = []     %% boss扫荡奖励(单个)
	,sweep_reward_draw_list = []%% 扫荡抽奖列表 [{列表id, 抽奖次数}]
	,boss_reward_draw_list = [] %% boss扫荡抽奖列表
}).

-define(select_from_soul_dungeon_ps_sub, <<"select  dun_id, status, max_wave from  soul_dungeon_ps_sub where  role_id  = ~p">>).

-define(save_soul_dungeon_ps_sub, <<"replace into soul_dungeon_ps_sub(role_id, dun_id, `status`, max_wave)  VALUES(~p, ~p,~p,~p)">>).




















