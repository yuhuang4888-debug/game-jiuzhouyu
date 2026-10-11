%%%------------------------------------
%%% @Module  : guild_battle.hrl
%%% @Author  : liuxl
%%% @Created : 2018-09-25
%%% @Description: 公会战（大乱斗）
%%%------------------------------------

%% ----------------------- 配置定义 -----------------------
-define(FIGHT_TOP_NUM, data_guild_battle:get_cfg(1)).	%%战场上限人数
-define(GUILD_TOP_NUM, data_guild_battle:get_cfg(2)).	%%公会参加上限上数
-define(GUILD_BATTLE_ID,	   data_guild_battle:get_cfg(3)).	%% 场景id
-define(REF_START,     data_guild_battle:get_cfg(4)).	%% 提前X分钟预告
-define(ACT_TIME,	   data_guild_battle:get_cfg(5)).	%% 活动时间
-define(MON_NUM,       data_guild_battle:get_cfg(6)).	%% 刷怪只数
-define(SKILL_ID,      data_guild_battle:get_cfg(7)).	%%技能id
-define(SKILL_REDUCE,  data_guild_battle:get_cfg(8)).	%%使用技能消耗技能点
-define(REF_LANGUAGE_TIME, data_guild_battle:get_cfg(9)).	%%循环传闻定时器间隔
-define(KILL_MON_RESOURCE, data_guild_battle:get_cfg(10)).	%%杀怪增加的资源数
-define(OWN_ADD_TIME, data_guild_battle:get_cfg(11)).	%%占领据点增加间隔
-define(open_lv,      data_guild_battle:get_cfg(12)).	%%开发等级
-define(SKILL_BUFF_ID,      data_guild_battle:get_cfg(13)).	%%霸主技能buff
-define(DAILYREWARD_NEEDTIME,      data_guild_battle:get_cfg(15)).	%%加入公会3600秒后才能领取每日礼包

%% ----------------------- 传闻定义 -----------------------
-define(GUILD_BATTLE_LANGUAGE_1, 1).		%%传闻1
-define(GUILD_BATTLE_LANGUAGE_2, 2).		%%传闻2
-define(GUILD_BATTLE_LANGUAGE_3, 3).		%%传闻3
-define(GUILD_BATTLE_LANGUAGE_4, 4).		%%传闻4
-define(GUILD_BATTLE_LANGUAGE_5, 5).		%%传闻5
-define(GUILD_BATTLE_LANGUAGE_6, 6).		%%传闻6
-define(GUILD_BATTLE_LANGUAGE_7, 7).		%%传闻7
-define(GUILD_BATTLE_LANGUAGE_8, 8).		%%传闻8
-define(GUILD_BATTLE_LANGUAGE_9, 9).		%%传闻9
-define(GUILD_BATTLE_LANGUAGE_10, 10).   	%%传闻10
-define(GUILD_BATTLE_LANGUAGE_11, 11).		%%传闻11

%% ----------------------- 公会战宏定义 -----------------------
-define(KILL_PLAYER_NUM, [5,10,15,20]). 
-define(KILL_PLAYER_LIMIT, 3). 
-define(NOT_START, 0).  		%% 活动未开启
-define(START, 1).  			%% 活动开启
-define(REF_TIME, 5).			%%定时器间隔
-define(LAST_REWARD, [{0,994038,1}]).		%%被杀最多的称号奖励

-define(NORMAL_MON_TYPE,	  1).	%% 怪物
-define(OWN_MON_TYPE, 	  	  2).	%% 普通据点
-define(KING_MON_TYPE,	      3).	%% 王者据点
-define(PLAYER_TYPE,		  4).	%% 玩家类型
-define(HURT_OWN_TYPE,		  5).	%% 砍上普通据点
-define(HURT_KING_TYPE,		  6).	%% 砍上王者据点

-define(GROUP_MON,    2).   %% 怪物分组
-define(GROUP_ROLE,   1).   %% 玩家分组

-define(KING_TYPE,    2).   %% 王者据点类型
-define(OWN_TYPE,     1).  	%% 普通据点类型

-define(BIRTY_TYPE,   1).   %% 出生点类型
-define(MON_TYPE,     2).   %% 刷怪点类型

%玩家ps记录
-record(guild_battle_status,{
		winner = 0,
		win_num = 0,
		own_revive = [],	%%据点复活
		birth_revive = 0,	%%原始出生点
		buff_id = 0,
		revive_state = 0
	}).


%% 管理进程state
-record(guild_battle_state,{
	start_time = 0,            			%% 开始时间
 	end_time = 0,              			%% 结束时间
	state = 0,             			%% 活动状态
	winner = 0,						%% 当前霸主
	last_winner = 0, 				%% 上一次霸主
	win_num = 0,					%% 连续赢的场数
	reward_type = 0, 				%% 0 无 1 连胜 2 终结
	reward_key = 0, 				%% 连胜奖励键(即连胜次数)
	reward_owner = 0, 				%% 连胜奖励分配者
	guild_list = [],				%% 公会参加人数记录，格式{公会id，[玩家id]}
	room_pid = 0,					%% 战场id
	ref_end = none,         		%% 结束定时器
	role_list = [],					%% 所有参加玩家 #role{}
	leave_role = [],				%% 保留退出活动的玩家记录，#role{}
	rank_list = [],					%% 公会排名，
	rank_role = []					%% 玩家杀人排名
}).

%% 战场进程状态state
-record(guild_battle_fight_state,{ 		
	pool_id = 0,					%% 进程id
	end_time,                     	%% 结束时间
	guild_list = [],				%% 所有公会信息，格式 #guild_info
	rank_list = [],				    %% 排名公会信息,格式 #guild_info
	role_map=#{},					%% 参战队员#role列表
	leave_id_list = [],				%% 中途离开玩家id
	in_own = [],					%% 进入据点，格式{{RoleId,MonId},Time}
	ref_rank = undefined,			%% 公会排行榜广播定时器 
	ref_own = undefined,			%% 据点列表广播定时器
	ref_lanuage = undefined,		%% 循环传闻定时器 30s一次
	ref_in_own = undefined,			%% 进入据点去加积分定时器 1s一次
	language = 0,					%% 记录当前循环传闻 5,6,7,8
	own_list = []					%% 据点，格式#own{}
}).

%%据点状态
-record(own,{
		mon_id = 0,
		id = 0,
		hp = 1,
		hp_lim = 1,
		guild_id = 0,				%% 属于公会id
		ref = none
	}).

%% 公会信息
-record(guild_info,{
		id = 0,
		name = <<>>,
		chief_id = 0,
		group = 0,			%% 分组
		power_rank = 0, 	%% 公会战力排名
		rank = 0,
		score = 0,  		%% 积分
		birth = 0,			%% 出生点配置id
		own = [],			%% 占据据点id
		role_list = []		%% 该工会玩家id
	}).

%% 战斗人员
-record(role, {
		role_id = 0,
		sid = 0,
		guild_id = 0,
		guild_name = <<>>,
		group = 0,					%%分组id
		name = undefined,			%% 玩家名字
	    node = undefined,           %% 队员所在节点
	    platform="",                %% 平台
	    server_num=0,               %% 服数
	    war_figure = none,
	    enter_time = 0,				%% 参加时间
	    score = 0, 					%% 积分
	    total_kill_num = 0,			%% 累积杀人数
	    kill_num = 0,				%% 击杀人数(被杀会重置)
	    be_kill_num = 0,			%% 被杀次数
	    role_rank = 0,
	    got_reward = [],			%% 已领取的奖励	
	    resource = 0,				%% 资源数
	    has_send = [],				%% 可领取奖励已推送阶段id列表
	    is_leave = 0 				%% 是否已离开战场
	}).

%% 战斗形象
-record(war_figure, {
		sex = 0,
		realm = 0,
		career = 0,
		lv = 1,
		picture = "",
		picture_ver = 0
	}).

%%查询公会排名
-define(sql_guild_rank_select, " SELECT guild_id,rank,guild_name,chief_id,score,power_rank,own FROM `guild_battle_rank` ").
-define(sql_guild_rank_update_chief, " UPDATE  `guild_battle_rank` SET chief_id =~p where guild_id = ~p").
-define(sql_guild_rank_delete, " truncate table `guild_battle_rank`").

%%查询玩家排名
-define(sql_role_rank_select, " SELECT role_id,guild_id,score,kill_num,rank FROM `guild_battle_role_rank` ").
-define(sql_role_rank_delete, " truncate table `guild_battle_role_rank`").

%%公会争霸结果信息
-define(sql_guild_battle_result_select, " SELECT winner, last_winner, win_num, reward_type, reward_key, reward_owner FROM `guild_battle_result` ").
-define(sql_guild_battle_result_select_with_key, " SELECT winner, last_winner, win_num FROM `guild_battle_result` where winner = ~p ").
-define(sql_guild_battle_result_insert, " INSERT INTO `guild_battle_result` set winner=~p, last_winner=~p, win_num=~p, reward_type=~p, reward_key=~p, reward_owner=~p ").
-define(sql_guild_battle_result_delete, " truncate table `guild_battle_result`").

%% ------------------------------------- 配置
%% 出生点和刷怪配置
-record(base_guild_battle_birth,{
		cfg_id = 0,					%% 配置id
		type = 0,					%% 类型
		location = []				%% 坐标位置
	}).

%% 据点配置
-record(base_guild_battle_own,{
		mon_id = 0,					%% 怪物id
		type = 0,					%% 主类型（1为普通类型；2为王者类型）
		sub_type = 0,				%% 子类型
		location = [],				%% 坐标位置
		guild_add_score = 0,		%% 公会增加占领积分
		role_add_score = 0			%% 个人增加占领积分
	}).

