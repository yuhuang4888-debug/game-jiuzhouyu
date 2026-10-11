
%%%%%%%%%% 活动key
-define(TERRI_KEY_1,     1).   %% 活动开启时间
-define(TERRI_KEY_2,     2).   %% 活动准备时长
-define(TERRI_KEY_3,     3).   %% 活动时长
-define(TERRI_KEY_4,     4).   %% 每轮间隔时长
-define(TERRI_KEY_5,     5).   %% 每轮战斗时长
-define(TERRI_KEY_7,     7).   %% 每日奖励领取资格
-define(TERRI_KEY_8,     8).   %% 霸主会长buff
-define(TERRI_KEY_9,     9).   %% 杀人积分
-define(TERRI_KEY_10,     10).   %% 攻击王者据点积分
-define(TERRI_KEY_11,     11).   %% 攻击普通据点积分
-define(TERRI_KEY_12,     12).   %% 归属公会加积分间隔
-define(TERRI_KEY_13,     13).   %% 提前结束积分
-define(TERRI_KEY_14,     14).   %% 开服天数控制
-define(TERRI_KEY_15,     15).   %% 加分系数

%%%%%%%%%% 活动状态
-define(WAR_STATE_PRE_READY,     1).   %% 准备前
-define(WAR_STATE_READY,     2).   %% 准备
-define(WAR_STATE_START,     3).   %% 开始
-define(WAR_STATE_END,     4).   %% 结束

%%%%%%%%%% 活动阶段
-define(WAR_ROUND_1,     1).   %% 第一轮 8进4
-define(WAR_ROUND_2,     2).   %% 第一轮 4进2
-define(WAR_ROUND_3,     3).   %% 第一轮 2进1

%%%%%%%%%% 战场类型
-define(WAR_TYPE_1,     1).   %% 推塔
-define(WAR_TYPE_2,     2).   %% 占塔

%%%%%%%%%% 阵营类型
-define(CAMP_1,     1).   %% 阵营1
-define(CAMP_2,     2).   %% 阵营2

%%%%%%%%%% 战塔类型
-define(KING_TYPE,     1).   %% 王者据点
-define(NORMAL_TYPE,     2).   %% 普通据点

%%%%%%%%%% 分服模式数
-define(MODE_NUM_1,   1).   %% 
-define(MODE_NUM_2,     2).   %%
-define(MODE_NUM_4,   4).   %% 
-define(MODE_NUM_8,     8).   %% 

%% ----------------------- 传闻定义 -----------------------
-define(TERRI_WAR_LANGUAGE_1, 1).		%%传闻1
-define(TERRI_WAR_LANGUAGE_2, 2).		%%传闻2
-define(TERRI_WAR_LANGUAGE_3, 3).		%%传闻3
-define(TERRI_WAR_LANGUAGE_4, 4).		%%传闻4
-define(TERRI_WAR_LANGUAGE_5, 5).		%%传闻5
-define(TERRI_WAR_LANGUAGE_6, 6).		%%传闻6
-define(TERRI_WAR_LANGUAGE_7, 7).		%%传闻7
-define(TERRI_WAR_LANGUAGE_8, 8).		%%传闻8
-define(TERRI_WAR_LANGUAGE_9, 9).		%%传闻9
-define(TERRI_WAR_LANGUAGE_10, 10).   	%%传闻10
-define(TERRI_WAR_LANGUAGE_11, 11).		%%传闻11
-define(TERRI_WAR_LANGUAGE_12, 12).		%%传闻12

%%%%%%%%%% 其他定义
-define(SYNC_INFO_TIME,     4).   %% 没4秒广播一下数据
-define(REF_LANGUAGE_TIME,     22).   %% 循环传闻

-define(KILL_PLAYER_LIMIT,  3). 
-define(MON_INIT_GUILD,  1).     %% 据点的初始公会(分组)

%-define(DEBUG_CFG, true).
-ifdef(DEBUG_CFG).
-define(SYNC_GUILD_TIME,   1*60). 		%% 每分钟向游戏服获取公会信息
-define(SYNC_GUILD_COUNT,   10). 		%% 最大次数
-define(SYNC_SERVER_DATA_TIME,     60).   %% 同步服务器数据时间
-else.
-define(SYNC_GUILD_TIME,   5*60). 		%% 每5分钟向游戏服获取公会信息
-define(SYNC_GUILD_COUNT,   10). 		%% 最大次数
-define(SYNC_SERVER_DATA_TIME,     300).   %% 同步服务器数据时间
-endif.

%% 
-record(terri_status,{
	territory_id = 0
	, camp = 0
	, own = []
	, buff_id = 0
	, revive_state = 0
}).

%% 
-record(terri_state,{
	  is_init = 0				%% 是否初始化了, 使用异步初始化 yy25dlaya新增
	, acc_group = 0
	, acc_war_id = 0
	, round = 0
	, war_state = 0
	, is_cls = 0
	, ready_time = 0
	, start_time = 0             %% 活动开启时间
	, end_time = 0               %% 活动结束
	, round_start_time = 0
	, round_end_time = 0
	, server_map = #{}
	, guild_map = #{}
	, group_map = #{}
	, ref_state = none
	, ref_stage = none
	, history = []
	, consecutive_win = none
	, sync_state = 0
	, qualify_guilds = []		%% 有资格的公会列表 #游戏服 奖励找回使用，每次活动开启替换
}).

%% 
-record(terri_fight_state,{
	terri_war = undefined
	, mode_num = 0
	, is_cls = false
	, fight_type = 0            %% 1:推塔 2：占据点
	, scene = 0
	, pool_id = 0
	, copy_id = 0
	, start_time = 0
	, end_time = 0
	, guild_list = []           %% #tfight_guild{}
	, role_map = #{}
	, mon_list = []
	, language = 0
	, ref_lan = none
	, ref_state = undefined
	, ref_info = undefined
}).

%% 
-record(terri_server,{
	server_id = 0,            		%% 
 	server_num = 0,              		%% 
 	server_name = <<>>,
	zone_id = 0,             			%% 区域id
	open_time = 0,				%% 开服时间戳
	world_lv = 0, 				 %% 世界等级
	mode = 0,                   %% 模式 2服/4服...
	group = 0,					%% 服务器分组
	guild_list = []            %% 公会列表
}).


-record(terri_guild,{
	guild_id = 0,                  %% 公会id
	guild_name = <<>>,
	server_id = 0,            		%% 
 	server_num = 0,              		%% 
 	choose_terri_id = 0,
	win_num = 0
	
}).

-record(terri_group,{
	group_id = 0,                  %% 分组id
	mode_num = 1,
	group_round = 0,
	winner_server = 0,
	winner_guild = 0,
	win_num = 0,
	server_list = [],
	war_list = []	
	
}).

-record(terri_war,{
	group = 0,                   %% 所在分组id
	war_id = 0,                  %% 战场id
	round = 0,
	territory_id = 0,            %% 争夺的领地id
	a_guild = 0,
	a_server = 0,
	a_server_num = 0,
	a_guild_name = <<>>,
	b_guild = 0,
	b_server = 0,
	b_server_num = 0,
	b_guild_name = <<>>,
	winner = 0,
	fight_pid = 0
}).

-record(tfight_guild,{
	guild_id = 0,                  %% 公会id
	guild_name = <<>>,
	server_id = 0,            		%% 
 	server_num = 0,              		%% 
 	role_list = [],
	score = 0,
	camp = 0,			%% 阵营 %%
	own = []			%% 占据据点id
}).

-record(tfight_mon,{
	id = 0,                  %% 怪物id
	mon_id = 0,
	mon_type = 0,
	x = 0,
	y = 0,
	hp = 1,
	hp_lim = 1,
	alive = 1,               %% 1：存活 0：死亡
	guild_id = 0,				%% 属于公会id
	unlock_mon = 0,           %% 解锁怪物
	ref = none
}).

%% 战斗人员
-record(tfight_role, {
		role_id = 0,
		sid = 0,
		guild_id = 0,
		name = <<>>,			%% 玩家名字
		twar_figure = undefined,
	    node = undefined,           %% 队员所在节点
	    server_id = 0,
	    enter_time = 0,				%% 参加时间
	    score = 0, 					%% 积分
	    total_kill_num = 0,			%% 累积杀人数
	    kill_num = 0,				%% 击杀人数(被杀会重置)
	    be_kill_num = 0,			%% 被杀次数
	    role_rank = 0,
	    got_reward = [],			%% 已领取的奖励	
	    up_score = 0,				%% 
	    is_leave = 0 				%% 是否已离开战场
	}).

%% 战斗形象
-record(twar_figure, {
		sex = 0,
		realm = 0,
		career = 0,
		lv = 1,
		picture = "",
		picture_ver = 0,
		turn = 0
	}).

-record(twar_history, {
		date_id = 0,    %% 日期
		group_map = #{}
	}).

-record(consecutive_win, {
		winner = 0,						%% 当前霸主
		win_server = 0,                 %% 霸主服务器id
		win_server_num = 0,             %% 
		win_guild_name = <<>>,          %% 霸主公会名   
		win_num = 0,					%% 连续赢的场数
		last_winner = 0, 				%% 上一次霸主
		last_server = 0,                %% 上一次霸主的服务器id
		last_server_num = 0,            %% 
		last_guild_name = <<>>,         %% 上一次霸主的服务器id
		reward_type = 0, 				%% 0 无 1 连胜 2 终结
		reward_key = 0, 				%% 连胜奖励键(即连胜次数)
		reward_owner = 0, 				%% 连胜奖励分配者
		date_id = 0
	}).



%%%%%%%%%%%%%%%%% center
-define(SQL_TERRITORY_SERVER_SELECT, 		<<"select server_id, server_num, server_name, zone_id, open_time, wlv, mode, group_id from `territory_server`">>).
-define(SQL_TERRITORY_GUILD_SELECT, 		<<"select guild_id, guild_name, server_id, server_num, choose_terri_id, win_num from `territory_guild`">>).
-define(SQL_TERRITORY_HISTORY_SELECT, 		<<"select date_id, group_id, winner_server, winner_guild, win_num, server_list from `territory_history`">>).
-define(SQL_TERRITORY_HISTORY_WARLIST_SELECT, <<"select date_id, group_id, war_id, round, territory_id, a_guild, a_server, a_server_num, a_guild_name,
												b_guild, b_server, b_server_num, b_guild_name, winner from `territory_history_warlist`">>).

-define(SQL_TERRITORY_SERVER_REPLACE, 		<<"replace `territory_server` set server_id=~p, server_num=~p, server_name='~s', zone_id=~p, open_time=~p, wlv=~p, mode=~p, group_id=~p ">>).
-define(SQL_TERRITORY_GUILD_REPLACE, 		<<"replace `territory_guild` set guild_id=~p, guild_name=~p, server_id=~p, server_num=~p, choose_terri_id=~p, win_num=~p ">>).


-define(SQL_TERRITORY_SERVER_TRUNCATE, 		<<"truncate table `territory_server`">>).
-define(SQL_TERRITORY_GUILD_TRUNCATE, 		<<"truncate table `territory_guild`">>).
-define(SQL_TERRITORY_HISTORY_TRUNCATE, 		<<"truncate table `territory_history`">>).
-define(SQL_TERRITORY_HISTORY_WARLIST_TRUNCATE, 		<<"truncate table `territory_history_warlist`">>).

-define(SQL_TERRITORY_SERVER_ID_DELETE, 		<<"delete from `territory_server` where server_id in (~s)">>).
-define(SQL_TERRITORY_GUILD_ID_DELETE, 		<<"delete from `territory_guild` where guild_id in (~s)">>).

%%%%%%%%%%%%%%%%% local
-define(SQL_LOCAL_TERRITORY_SERVER_SELECT, 		<<"select server_id, server_num, server_name, zone_id, open_time, wlv, mode, group_id from `territory_server_local`">>).
-define(SQL_LOCAL_TERRITORY_GUILD_SELECT, 		<<"select guild_id, guild_name, server_id, server_num, choose_terri_id, win_num from `territory_guild_local`">>).
-define(SQL_LOCAL_TERRITORY_HISTORY_SELECT, 		<<"select date_id, group_id, winner_server, winner_guild, win_num, server_list from `territory_history_local`">>).
-define(SQL_LOCAL_TERRITORY_HISTORY_WARLIST_SELECT, <<"select date_id, group_id, war_id, round, territory_id, a_guild, a_server, a_server_num, a_guild_name,
												b_guild, b_server, b_server_num, b_guild_name, winner from `territory_history_warlist_local`">>).

-define(SQL_LOCAL_CONSECUTIVE_WIN_SELECT, 		<<"select winner, win_server, win_server_num, win_guild_name, win_num, last_winner, last_server, last_server_num, last_guild_name, reward_type, reward_key, reward_owner, date_id from `consecutive_win_local`">>).

-define(SQL_LOCAL_TERRITORY_SERVER_REPLACE, 		<<"replace `territory_server_local` set server_id=~p, server_num=~p, server_name='~s', zone_id=~p, open_time=~p, wlv=~p, mode=~p, group_id=~p ">>).
-define(SQL_LOCAL_TERRITORY_GUILD_REPLACE, 		<<"replace `territory_guild_local` set guild_id=~p, guild_name=~p, server_id=~p, server_num=~p, choose_terri_id=~p, win_num=~p ">>).
-define(SQL_LOCAL_CONSECUTIVE_WIN_INSERT, 		<<"insert into `consecutive_win_local` (winner, win_server, win_server_num, win_guild_name, win_num, last_winner, last_server, last_server_num, last_guild_name, reward_type, reward_key, reward_owner, date_id) 
													values (~p, ~p, ~p, '~s', ~p, ~p, ~p, ~p, '~s', ~p, ~p, ~p, ~p) ">>).

-define(SQL_LOCAL_TERRITORY_SERVER_TRUNCATE, 		<<"truncate table `territory_server_local`">>).
-define(SQL_LOCAL_TERRITORY_GUILD_TRUNCATE, 		<<"truncate table `territory_guild_local`">>).
-define(SQL_LOCAL_TERRITORY_HISTORY_TRUNCATE, 		<<"truncate table `territory_history_local`">>).
-define(SQL_LOCAL_TERRITORY_HISTORY_WARLIST_TRUNCATE, <<"truncate table `territory_history_warlist_local`">>).
-define(SQL_LOCAL_CONSECUTIVE_WIN_TRUNCATE,         <<"truncate table `consecutive_win_local`">>).

%%%%%%%%%%%%%%%%% 配置
%% 模式
-record(base_territory_mode, {
		mode_num = 0,
		mode_name = <<>>,
		start_round = 0,
		guild_num = 0,
		wlv = 0,
		open_day = 0
	}).

%% 领地
-record(base_territory, {
		territory_id = 0,
		territory_name = <<>>,
		round = 0,             %% 归属轮次
		war_type = 0,         %% 战场类型 1：推塔 2：占塔
		next_territory_id = 0,
		scene = [],            %% 场景id [单服的场景, 跨服的场景]
		camp_born = [],        %% 阵营初始出生地 [{camp, x, y, range}]
		resource = ""
	}).

-record(base_terri_mon, {
		mon_id = 0,
		territory_id = 0,
		camp = 0,         %% 阵营
		mon_type = 0,      
		x = 0,        %% 
		y = 0,
		range = 0,
		revive_priority = 0,   %% 复活点优先级 
		kill_score = 0,        %% 击杀后个人所得积分
		guild_score = 0,       %% 击杀后公会所得积分
		condition = []
	}).