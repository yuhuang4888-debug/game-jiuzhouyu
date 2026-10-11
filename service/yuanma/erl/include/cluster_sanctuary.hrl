%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%% @desc :跨服圣域 头文件
%%%-------------------------------------------------------------------

-record(base_san_type, {
		type = 0,            	%% 类型id
		san_num = [],         	%% 圣域数量{Type(#base_san_cons.type), Num}
		city_num = [],        	%% 城堡数量{Type(#base_san_cons.type), Num}
		village_num = [],		%% 要塞数量{Type(#base_san_cons.type), Num}
		open_min = 0,			%% 最小开服天数
		open_max = 0,           %% 最大开服天数
		server_num = 0			%% 服务器数量
		, wlv = 0				%% 世界等级
	}).

-record(base_san_mon_type, {
		type = 0,				%% 怪物类型id
		con_type = 0,           %% 建筑类型
		san_score = 0,			%% 圣域积分（服务器）
		score = 0,				%% 个人积分
		min_score = 0,			%% 个人保底积分
		anger = 0,              %% 击杀增加到怒气值
		medal = []				%% 勋章奖励
	}).

-record(base_san_mon, {
		mon_id = 0,             %% 怪物id
  		type = 0,				%% 怪物类型id
		scene = 0,				%% 场景类型
		x = 0,					%% 出生X坐标
		y = 0,					%% 出生Y坐标
		reborn = []				%% 复活时间Time
	}).

-record(base_san_cons,{
		type = 0, 				%% 建筑类型
  		scene = 0,				%% 场景类型
  		refresh_time = [], 		%% 刷新(怪)时间
  		reward = [],			%% 归属奖励
      name = ""               %% 名称
	}).

-record(base_san_score, {
		id = 0,					%% id
		score = 0,              %% 积分
		reward = []				%% 奖励
	}).

-record(base_san_shop, {
		id = 0,					%% 商品id
  		open_day = 0,			%% 开服天数
		limit = 0,				%% 每日限制数量
		cost = [],				%% 消耗
		reward = []				%% 奖励
	}).

-record(base_c_sanctuary_point, {
		wlv_min = 0, 				%% 世界等级下限
		wlv_max = 0,				%% 世界等级上限
		hurt = 0,					%% boss伤害值,
		hurt_add = 0,   			%% 贡献值增量,
		kill_add = 0    			%% 击杀玩家增加贡献值
	}).

-record(base_c_sanctuary_auction_boss, {
		mon_id = 0, 				%% 怪物id
		wlv_min = 0, 				%% 世界等级下限
		wlv_max = 0, 				%% 世界等级上限
		worth = 0, 					%% 钻石产出价值基数
		produce = [],		 		%% 钻石产出 {AuctionId, _Weight, PercentNum, Sort}
		bgold_worth = 0,			%% 绑钻产出价值基数
		bgold_produce = []			%% 绑钻产出 {AuctionId, _Weight, PercentNum, Sort}
  	}).

-record(base_c_sanctuary_auction_scene, {
		scene = 0, 					%% 场景id
		wlv_min = 0, 				%% 世界等级下限
		wlv_max = 0, 				%% 世界等级上限
		worth = 0, 					%% 钻石产出价值基数
		ratio = 0,					%% 价值系数
		produce = [],		 		%% 钻石产出 {AuctionId, _Weight, PercentNum, Sort}
		bgold_worth = 0,			%% 绑钻产出价值基数
		bgold_ratio = 0,			%% 价值系数
		bgold_produce = []			%% 绑钻产出 {AuctionId, _Weight, PercentNum, Sort}
  	}).

-define(SANTYPE_1,    1). %% 简单模式
-define(SANTYPE_2,    2). %% 一般模式
-define(SANTYPE_3,    3). %% 困难模式
%% 下面两种模式弃用
-define(SANTYPE_4,    4). %% 2分区阵营模式
-define(SANTYPE_5, 	  5). %% 2分区阵营模式

-define(CONS_TYPE_1,    1). %% 要塞
-define(CONS_TYPE_2, 	2).	%% 城堡
-define(CONS_TYPE_3, 	3). %% 圣域

-define(MONTYPE_1,    1). %% 守卫
-define(MONTYPE_2,    2). %% 精英
-define(MONTYPE_3,    3). %% boss
-define(MONTYPE_4,	  4). %% 和平守卫
-define(MONTYPE_5,	  5). %% 和平精英
-define(MONTYPE_6,	  6). %% 和平boss

-define(PEACE_MON_TYPE_L, [?MONTYPE_4, ?MONTYPE_5, ?MONTYPE_6]).

-define(AUCTION_NORMAL, 0). %% 普通
-define(AUCTION_RARE,   1). %% 稀有

-define(TIME_BEFORE,  5). %% 活动结束后5分钟计算服务器的圣域模式
-define(TIME_INIT,   30). %% 启动后30s未初始化成功则再次执行初始化

-define(INIT_SUCCESS, 1). %% 初始化成功


-record(c_sanctuary_state, {
		zone_map = #{}         			%% 所有分区的服务器信息 zone_id => [serverid...]
		,server_info = []				%% [{serverid,optime...}...]
		,battle_map = #{}       		%% 分区服务器圣域模式 zone_id => {Type1, Type2, Type3}    阵营模式分配规则复制到各个分区
										%% 			TypeN:{?SANTYPE_N, List1(服务器id列表)}（按开服时间由小到大）
		,calc_battle_time = 0			%% 下次服务器圣域模式计算时间
		,calc_battle_ref = undefined	%% 服务器圣域模式计算定时器
		,san_state = #{}           		%% 状态 zoneid => [#c_san_state,...]
		,mon_reborn_ref = undefined		%% 怪物刷新定时器
		,reborn_time = 0				%% 下次复活时间
		,role_anger_ref = undefined     %% 清理玩家怒气值定时器
		,begin_scene_map = #{}          %% zonid => [{[Server, ], scene}...]
		,join_map = #{}                 %% {Camp, ServerId, Scene} => num
		,scene_user = #{}               %% {zoneid, serverid, sceneid} =>[userid ...]
		,act_start_ref = undefined      %% 开始计时器
		,act_end_ref = undefined        %% 结束计时器
		,act_start_time = 0				%% 开始时间
		,act_end_time = 0				%% 结束时间
		,old_con_map = #{}              %% {zoneid, serverid, sceneid} => camp
		,act_tv_ref = undefined         %% 活动结束前玩家提示定时器
		,auction_produce_time = 0		%% 拍卖物品产出截止时间
		,point_map = #{}				%% 总共的贡献值数据 {ZoneId, camp} -> [{RoleId, PlayerPoint, BossPoint, Total}...] todo
		,server_camp = []				%% 服务器进入阵营记录 [{server, is_camp}]
		,server_power = []				%% 服务器战力汇总
		,battle_zone = #{}				%% 对战分区 {zone => [zone...]}
	}).

-record(c_san_state, {
		san_type = 0,					%% 圣域模式
		cons_state = #{}                %% 圣域建筑状态 {zoneid, serverid/copyid} => [#c_cons_state,...]
		,auction_worth = []				%% 拍卖产出总价值 {serverid, Worth}
		,extra_state = []				%% {serverid, [{Worth, Status}]}
	}).

-record(c_cons_state, {
		scene_id = 0,					%% 场景id
		cons_type = 0,					%% 建筑类型
		pre_bl_server = 0,              %% 上次归属阵营id
		bl_server = 0,					%% 归属阵营id
		clear_role_ref = undefined,     %% 占领建筑30s后清理玩家
		role_recieve = [],              %% 领取归属奖励玩家{role_id, time}
		mon_state = []                  %% 怪物状态 [#c_mon_state]
		,san_score = #{}                %% {camp,scene} => score
		,auction_reward_role = []       %% 享受分红[RoleId...]
	}).

-record(c_mon_state,{
		mon_id = 0,						%% 怪物id
		mon_type = 0,					%% 怪物类型
		mon_lv = 0,						%% 怪物等级
		rank_list = [],					%% 伤害排名
		total_hurt = 0,                 %% 总伤害
		reborn_time = 0,				%% 为0表示活着，否则是个时间戳
		kill_log = [],                  %% 击杀记录
		reborn_ref = undefined,			%% 复活时间戳(主要是和平怪)
		mon_hurt_info = #{}, 			%% Server => [{Role, Hurt}....]
		update_point_time = 0			%% 更新贡献值时间戳
	}).

-record(kf_sanctuary_info,{
		paied = 0,                      %% 0未支付 1已支付
		score = 0,                      %% 个人积分
		score_status = [],              %% [{score, Status}...] 0未完成 1已完成未领取 2已领取
		anger = 0                       %% 怒气值
		,clear_time = 0					%% 上次怒气清理时间
		,die_time_list = []				%% 死亡统计[dietime,...]
		,die_time = 0                   %% 上次死亡时间
		,buff_end = 0                   %% buff结束时间
		,reborn_ref = undefined			%% 玩家死亡退出如果没有重连则开启定时器复活玩家
	}).

-record(sanctuary_state_local, {
		zone_id = 0
		,is_init = 0					%% 是否初始化
		,init_ref = undefined			%% 初始化定时器
		,san_list = []
		,san_type = 0                   %% 圣域模式
		,enemy_server = [] 				%% 对手服务器
		,begin_scene_list = []			%% 初始场景id
		,server_info = []
		,join_map = 0
		,act_start_time = 0
		,act_end_time = 0
		,point_rank = []				%% [{RoleId, PlayerPoint, BossPoint, Total}...]
		,auction_begin_time = 0			%% 开始拍卖时间
		,auction_info = []				%% {Producetype, AuctionId, RoleIdL, [{AuctionId, Num}]}
		,role_auction = []				%% 玩家分红[{Producetype, [{Roleid, GoodsList}]}]
		,auction_end_ref = undefined 	%% 拍卖结束发邮件计时器
	}).

-define(NOT_ACHIEVE, 0).
-define(HAS_ACHIEVE, 1).
-define(HAS_RECIEVE, 2).

% -define(SQL_SELECT_SERVER_INFO,
% 		<<"select serverid,open_time,world_lv from sanctuary_kf_info where serverid = ~p">>).

% -define(SQL_REPLACE_SERVER_INFO,
% 		<<"replace into sanctuary_kf_info(serverid,open_time,world_lv) values(~p,~p,~p)">>).

% -define(SQL_SELECT_ZONE_INFO,
% 		<<"select zone_id,server_ids from sacturay_kf_zone_info">>).

% -define(SQL_REPLACE_ZONE_INFO,
% 		<<"replace into sacturay_kf_zone_info(zone_id,server_ids) values(~p,~p)">>).

-define(SQL_SELECT_ROLE_INFO,
    <<"select paied, anger, score, clear_time, score_status, kill_score, is_task from sanctuary_kf_role where role_id = ~p">>).

-define(SQL_REPLACE_ROLE_INFO,
    <<"replace into sanctuary_kf_role(role_id, paied, anger, score, clear_time, score_status, kill_score, is_task) values(~p,~p,~p,~p,~p,'~s','~s',~p)">>).

-define(SQL_UPD_SCORE_ROLE_INFO,
    <<"update sanctuary_kf_role set score = ~p where role_id = ~p">>).

-define(SQL_UPD_AFTER_KILL_SCORE_ROLE_INFO,
    <<"update sanctuary_kf_role set score = ~p, kill_score = '~s', anger = ~p where role_id = ~p">>).

-define(SQL_UPD_ANGER_ROLE_INFO,
    <<"update sanctuary_kf_role set anger = ~p where role_id = ~p">>).

-define(SQL_UPD_PAIED_ROLE_INFO,
    <<"update sanctuary_kf_role set paied = ~p where role_id = ~p">>).

-define(SQL_UPD_SCORE_STATUS_ROLE_INFO,
    <<"update sanctuary_kf_role set score_status = '~s' where role_id = ~p">>).

-define(SQL_RESET_SCORE_ROLE_INFO,
	<<"update sanctuary_kf_role set score_status = '[]', score = 0, paied = 0, clear_time = ~p, kill_score = '[]' , is_task = 0 where role_id = ~p">>).

-define(SQL_UPDATE_DATA_AFTER_MON_REBORN,
    <<"update sanctuary_kf_role set kill_score = '[]', is_task = 0">>).

-define(SQL_UPDATE_TASK_STATUS,
    <<"update sanctuary_kf_role set is_task = ~p where role_id = ~p">>).

-define(SQL_CLEAR_ANGER_ROLE_INFO, <<"update sanctuary_kf_role set anger = 0, clear_time = ~p">>).

-define(SQL_SELECT_ROLE_DIE,
		<<"select die_time, die_list from sanctuary_kf_die where role_id = ~p">>).

-define(SQL_REPLACE_ROLE_DIE,
		<<"replace into sanctuary_kf_die(role_id, die_time, die_list) values(~p,~p,~p)">>).

-define(SQL_SELECT_SERVER_BL,
		<<"select copy_id, scene_id, bl_server, mon_ids, last_stop_time, server_score_list, role_receives, last_bl_server from sanctuary_kf_construction where zone_id = ~p">>).

-define(SQL_REPLACE_SERVER_BL,
		<<"replace into sanctuary_kf_construction(zone_id, copy_id, scene_id, bl_server, mon_ids, last_stop_time, server_score_list, role_receives, last_bl_server) values(~p,~p,~p,~p,'~s',~p,'~s','~s',~p)">>).

-define(SQL_DELETE_SERVER_BL,
    <<"delete from sanctuary_kf_construction where zone_id = ~p and scene_id = ~p and copy_id = ~p">>).

-define(SQL_TRUNCATE_SERVER_BL,
    <<"truncate table sanctuary_kf_construction">>).

-define(SQL_SELECT_SANTYPE_RECORD,
    <<"select server, camp from sanctuary_kf_server">>).
-define(SQL_REPLACE_SANTYPE_RECORD,
    <<"replace into sanctuary_kf_server (server, camp) values (~p, ~p)">>).
-define(SQL_TRUNCATE_SANTYPE_RECORD,
    <<"truncate table sanctuary_kf_server">>).

-define(SQL_SELECT_SERVER_BEGIN_SCENE,
    <<"select `zone_id`, `group_id`, `server_ids`, `server_scene_map`, `time` from `sanctuary_kf_begin_scene`">>).


-record(status_sanctuary_cluster, {
    is_pay = 0
    , score = 0
    , score_status = []					%% 积分奖励领取状态
    , anger = 0
    , last_die_time = 0 				%% 上次死亡时间
    , die_times = 0						%% 持续死亡次数（两次死亡小于配置的间隔时间将会累计， 当大于了间隔时间清零）
    , clear_time = 0
    , kill_score = []         %% 击杀玩家的积分加成
    , is_task = 0             %% 当前是否已接任务，0-表示未接任何任务
}).

-record(sanctuary_mgr_state, {
	  is_init = 0						%% 分区进程信息
	, message_queue = []				%% 待处理的消息列表
	, zone_division = []				%% 分区进程信息
	, zone_server_map = #{}				%%
	, all_zone_server = [] 				%%
	, mon_reborn_ref = undefined		%% 怪物刷新定时器
	, mon_reborn_time = 0				%% 下次复活时间
	, role_anger_ref = undefined     	%% 清理玩家怒气值定时器
	, start_ref = undefined      		%% 开始计时器
	, end_ref = undefined        		%% 结束计时器
	, start_time = 0					%% 开始时间
	, end_time = 0						%% 结束时间
	, act_tv_ref = undefined         	%% 活动结束前玩家提示定时器
}).

-record(sanctuary_cls_state, {
	  zone_id = 0
	, is_open = 0
	, server_infos = []
	, server_group_map = #{}				%% #{ServerId => GroupId}
	, group_state_map = #{}					%% #{GroupId => #sanctuary_camp_status{}}
	, start_time = 0
	, end_time = 0
	, mon_reborn_time = 0
}).

-record(sanctuary_local_state, {
	  zone_id = 0
	, san_type = 0
	, server_zones = []
	, begin_scene_map = []
	, building_list = []
	, start_time = 0
	, end_time = 0
	, is_open = 0
}).

-record(sanctuary_group_state, {
    group_id = 0
    , san_type = 0
    , server_zone = []
    , begin_scene_map = #{}
    , building_list = []
    , is_reboot_reset = true     %% 是否需要重新初始化所有怪物的标志位，默认true,表示初始化所有怪物
}).

-record(sanctuary_building_state, {
    scene_id = 0
    , building_type = 0
    , last_bl_server = 0
    , bl_server = 0
    , clear_role_ref = []
    , role_receives = []
    , mons_state = []				%% [#sanctuary_mon_state{}]
    , server_score_map = #{}
    , join_map = #{}				%% #{SerId => [RoleId|_]}
    , score_rank_map = #{}    %% #{ServerId => [{RoleId, RoleName, ServerId, Score, KillNum, Rank, Time}]} 一个服最多只会有五条数据
    , mon_ids = []     %% 停机更新前 旧的怪物ID信息
}).

-record(sanctuary_mon_state, {
	  mon_id = 0
	, mon_type = 0
	, mon_lv = 0
	, rank_list = []				%% 不会实时更新，当Boss被击杀后才会排序
	, reborn_time = 0
	, reborn_ref = []
	, kill_log = []
	, hurt_info = #{}				%% 无用，用于拍卖分工计算，拍卖已移除
}).

-record(sanctuary_kf_role_rank_info, {
    player_id = 0,
    player_name = <<>>,
    server_id = 0,      %% 服务器ID
    score = 0,          %% 积分
    kill_num = 0,       %% 击杀人数
    rank = 0,           %% 排名
    last_time = 0       %% 上次积分变化时间
}).


-define(SANCTUARY_KILL_PLAYER_ADD_SCORE, data_cluster_sanctuary_m:get_san_value(auction_kill_player_add)).

%% 新加数据库的语句
-define(sql_select_player_score_rank_info,
    <<"SELECT `player_id`, `copy_id`, `scene_id`, `player_name`, `server_id`, `score`, `kill_num`, `last_time` FROM sanctuary_kf_role_rank_info where zone_id = ~p">>).

-define(sql_delete_no_right_player_score_rank_info,
    <<"delete from sanctuary_kf_role_rank_info where zone_id = ~p and scene_id = ~p and copy_id = ~p and server_id != ~p">>).

%% 单条记录更新
-define(sql_cycle_rank_role_replace,
    <<"replace into `sanctuary_kf_role_rank_info`(`player_id`,`zone_id`, `copy_id`, `scene_id`, `player_name`, `server_id`, `score`, `kill_num`, `last_time`) values (~p, ~p, ~p, ~p, '~s',~p, ~p, ~p, ~p)">>).

%% 批量记录更新
-define(sql_update_some_sanctuary_kf_role_rank_info,
    <<"replace into `sanctuary_kf_role_rank_info`(`player_id`,`zone_id`, `copy_id`, `scene_id`, `player_name`, `server_id`, `score`, `kill_num`, `last_time`) values ~s">>).

-define(sql_update_sanctuary_kf_role_rank_info,
    <<"update sanctuary_kf_role_rank_info set score = ~p, kill_num = ~p, last_time = ~p where player_id = ~p and zone_id = ~p and scene_id = ~p and copy_id = ~p">>).

-define(sql_delete_sanctuary_kf_role_rank_info,
   <<"delete from sanctuary_kf_role_rank_info where zone_id = ~p and scene_id = ~p and copy_id = ~p">>).

-define(sql_truncate_sanctuary_kf_role_rank_info,
    <<"truncate table sanctuary_kf_role_rank_info">>).
