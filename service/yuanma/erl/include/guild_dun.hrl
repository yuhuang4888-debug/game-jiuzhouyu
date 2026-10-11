%%%------------------------------------
%%% @Module  : guild_dun.hrl
%%% @Author  : liuxl
%%% @Created : 2018-10-17
%%% @Description: 公会副本
%%%------------------------------------

%% ----------------------- 配置定义 -----------------------




%% ----------------------- 宏定义 -----------------------
%% 公会副本层数定义
-define(DUN_LEVEL_LIST, data_guild_dun:get_all_guild_dun_level()).
-define(MAX_LEVEL, data_guild_dun:get_level_max()).
%% 每层入口定义
-define(DOOR_LIST, [1, 2, 3]). 
-define(MAX_DOOR, 3). 

%% 玩家状态
-define(ROLE_STATE_FREE, 0). 
-define(ROLE_STATE_FIGHT, 1).

%% 战斗状态
-define(BATTLE_STATE_START, 1). 
-define(BATTLE_STATE_END, 2).

%% 初始挑战次数
-define(INIT_CHALLENGE_TIMES, 3).


%% 管理进程state
-record(guild_dun_state,{
	init_state = 0  		%% 0 未初始化完毕 1 初始化完毕
	, level_map = #{}       %% level => #level_info{}
	, guild_map = #{}
	, role_map = #{}
}).

-record(level_info,{
	level = 0
	, challenge_type = []    %% [{入口,挑战类型}], 挑战类型 1 宝箱 2 挑战怪物 3 挑战玩家镜像
	, challenge_info = #{}  %% 类型3时生效：#{battle_attr => #battle_attr{}, skill => skilllist}
}).

-record(guild_info,{
	guild_id = 0
	, dun_score = 0 		%% 0
	%, role_map = #{}
	, record_list = []
	, create_time = 0
}).


-record(role_info,{
	role_id = 0
	, guild_id = 0
	, role_name = <<>>
	, role_state = 0 		%% 0
	, level = 0    %% 
	, choose_door = 0  %% 
	, challenge_times = 0
	, notify_times = 0
	, dun_score = []
	, fight_pid = none
	, create_time = 0
}).

-record(record_info,{
	id = 0
	, role_id = 0
	, role_name = <<>> 		%% 0
	, level = 0    %% 
	, door = 0  %% 
	, type = 0
	, time = 0
}).

%% 战场进程状态state
-record(guild_dun_fight_state,{ 		
	data = #{}
	, ref_end = none
}).



%% ----------------------- 配置 -----------------------

-record(base_guild_dun_type, { 		
	type = 0                     %% 挑战类型 1 宝箱 2 挑战怪物 3 挑战玩家镜像
	, name = ""  				%% 名字
	, scene = 0  				%% 场景id 
	, location = [] 			%% 出生点 [{x1, y1}, {x2, y2}]
}).

-record(base_guild_dun_level_challenge, { 		
	level = 0                     %% 
	, mon_id = 0
	, rank = []                    %% 
	, reward = []
	, score_add = 0
}).

-record(base_guild_dun_mon_coef, { 		
	open_day_1 = 0                     %% 
	, open_day_2 = 0                     %% 
	, coef = 0
}).

-record(base_guild_dun_score_reward, { 		
	id = 0                    % 
    , score = 0
    , reward = []
    , icon = 0
}).

%% ----------------------- sql -----------------------
-define(sql_guild_info_select, <<"select guild_id, guild_dun_score, create_time from `guild_dun_guild`">>).
-define(sql_guild_info_replace, <<"replace into `guild_dun_guild` set guild_id = ~p, guild_dun_score=~p, create_time = ~p ">>).
-define(sql_guild_info_delete_all, <<"truncate table `guild_dun_guild`">>).
-define(sql_guild_info_delete_expire, <<"delete from `guild_dun_guild` where create_time < ~p">>).

-define(sql_role_info_select, <<"select role_id, guild_id, level, challenge_times, notify_times, dun_score, create_time, nickname from `guild_dun_role` left join `player_low` pl on role_id=pl.id ">>).
-define(sql_role_info_replace, <<"replace into `guild_dun_role` set role_id = ~p, guild_id=~p, level=~p, challenge_times=~p, notify_times=~p, dun_score='~s', create_time=~p ">>).
-define(sql_role_info_delete_all, <<"truncate table `guild_dun_role`">>).
-define(sql_role_info_delete_expire, <<"delete from `guild_dun_role` where create_time < ~p">>).