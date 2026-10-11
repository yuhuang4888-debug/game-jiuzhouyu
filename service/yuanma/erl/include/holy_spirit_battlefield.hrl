%%%-----------------------------------
%%% @Module      : holy_spirit_battlefield
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 十月 2019 15:08
%%% @Description : 圣灵战场
%%%-----------------------------------


%% API
-compile(export_all).

-author("chenyiming").

-define(camp_num, 3). %% 阵营数量
-define(group_server_num, 8). %% 8个服为一个小组


-define(close, 0).
-define(wait, 1).  %% 等待中
-define(pk, 2).    %% pk中

-define(not_in_act, 0).  %% 不在活动中
-define(in_act, 1).  %% 在活动中

-define(max_mod, 8).

-define(send_time, 3).  %% 广播时间间隔 怪物广播

-define(sort_time, 5).  %%  5秒排序一次

-record(mod_cfg, {
	mod = 0         %% '1：本服模式、2:2服模式、4：4服模式、8：8服模式',
	, name = ""      %% '服务器模式名称',
	, min_world_lv   %%'最小世界等级',
	, max_world_lv   %%'最大世界等级',
	, open_day       %% '开服天数',
	, room_num       %%'房间人数',
}).

-record(holy_spirit_battle_state, {
	  is_init = 0
	, zone_map = #{}
	, max_copy_id = 0
	, ref = []
	, end_time = 0     %% 活动结束时间
	, exp_map = #{}    %% role_id => exp
	, exp_ref = []
	, status = ?close
	, calc_ref = []
}).

-record(server_group, {
	zone_id = 0,
	server_list = [] %% [#server_msg{}]
	, max_mod = 0     %% 最大的分服模式
	, num = 0         %% 分组内的服务器数量
	, battlefield_list = []   %% [#battlefield_msg{}]
}).

-record(battlefield_msg, {
	battlefield_id = 0  %% 战场id  = 服的模式 * 100 +  ceil(排名 / 模式)向上取证  , 排名最大8 ，现在的小跨服，最多服是8个
	, zone_id = 0
	, server_list = [] %%
	, role_list = [] %% 玩家信息， 如果是在等待场景，退出，则role信息直接删除，如果是pk场景，则将role信息保留，设置在线信息
	, copy_list = []
}).


-record(server_msg, {
	server_id = 0       %% 每一个服的id(主服)
	, mod_id = 1           %% 模式id
	, zone_id = 0          %% 区id  同场景进程
	, time = 0          %% 开服时间
	, merge_ids = []    %% 每一个服的所有合服id
	, server_num = 0    %% ServerNum
	, server_name = ""  %% 服名字
	, world_lv = 0      %% 世界等级
	, rank = 0          %% 排行第几  在小跨服里, 以开服天数来排名，
	, battlefield_id = 0%% 战场id
}).

-record(role_msg, {
	role_id = 0,
	role_name = ""
	, server_id = 0,
	copy_id = 0
	, pk_pid = []  %% 战斗进程
	, status = 0
	, power = 0
	, server_num = 0
	, rank = 0        %%排名，用于分配，暂时用下，不可靠数据
	, lv = 0
	, picture_id = 0
	, picture = ""
	, turn = 0       %%转生
	, career = 0 %% 职业
}).

-record(copy_msg, {
	copy_id = 0,
	pk_pid = [],
	num = 0         %%房间人数的数量
}).

-record(battle_state, {
	role_list = []    %%
	, copy_id = 0
	, zone_id = 0
	, group_list = []
	, mod = 0    %% 模式
	, tower_list = []  %% 塔信息  实际是怪物
	, end_ref = []
	, scene_point_ref = []  %% 场景积分定时器
	, end_time = 0
	, send_ref = []        %%
	, battle_msg_ref = []
	, point_pid = []
}).

-record(battle_group, {
	group_id = 0
	, point = 0   %% 积分
	, num = 0     %% 人数 ,可增不可减， 为了让出去的人进来
%%	, tower_list = [] %% 占林塔的信息
	, rank = 0   %% 不保存 ，只是用暂用
	, power = 0  %% 不保存
}).

-record(tower, {
	mon_id = 0  %% 怪物配置id %% 目前不用， 所以后面都是异步创建怪物的
	, aid = 0    %% 进程id
	, group = 0  %% 所属分组， 默认是0
	, x = 0
	, y = 0
	, mon_list = []   %% 怪物列表 [{分组， 怪物id}]
}).

-record(role_pk_msg, {
	role_id = 0
	, role_name = ""
	, server_id = 0
	, copy_id = 0
	, pk_pid = []  %% 战斗进程
	, status = 0
	, power = 0
	, group = 0   %% 阵营 分为1 2， 3
	, continue_kill = 0  %% 连杀
	, kill_num = 0      % 击杀数量
	, assist = 0         %助攻
	, point = 0          % 积分   %% 不在用了
	, buff_list = []     %% buff_lists
	, rank = 0   %%排名，用于分配，暂时用下，不可靠数据
	, anger = 0  %% 怒气
	, server_num = 0
	, anger_end = 0   %% 狂怒结束时间戳
	, lv = 0
	, picture_id = 0
	, picture = ""
	, turn = 0
	, career = 0
}).

-record(role_point, {
	role_id = 0
	, role_name = ""
	, server_id = 0
%%	, copy_id = 0
%%	, pk_pid = []  %% 战斗进程
	, group = 0   %% 阵营 分为1 2， 3
	, point = 0          % 积分
	, rank = 0   %%排名，用于分配，暂时用下，不可靠数据
	, server_num = 0
	, kill_num = 0      % 击杀数量
	, assist = 0         %助攻
	, anger = 0
	, anger_end = 0
	, buff_list = []
}).


-record(role_holy_spirit_battlefield, {
	mod = 1,  %% 默认是模式一， 如果不是模式1的话，是请求不了协议数据的
	point = 0,
	reward = []  %%
	,buff_list = []
	,buff_time = 0    %%buff超时时间
	,battle_pid = []
}).

-record(holy_battle_point, {
	role_list = [],
	
	sort_ref = []       %% 排序定时器
	,mod = 0
	,group_list = [{1, 0, 1}, {2, 0, 2}, {3, 0, 3}]  %%  3个阵营   {阵营id， 积分， 排名}
	,group_map = #{}    %%  group =>
}).

-record(group_point, {
	group_id = 0,
	point = 0       %% 阵营的积分
	,role_list = [] %% 阵营玩家列表列表
	,rank = 0       %% 阵营排名
	,tower_num = 0  %% 不保存
}).


%%%% 模式信息
%%-record(mod_msg, {
%%	mod_id = 0          %% 模式 1 本服模式 2服模式 4  4服模式  8 8服模式  同进程id
%%	, max_copy = 0      %% 战场房间id
%%	,battlefield_list = []  %% [#battlefield_msg{}]
%%}).


-define(select_max_mod, <<"select max_mod from holy_spirit_battlefield_zone_mod where zone_id = ~p">>).
-define(save_max_mod, <<"replace into holy_spirit_battlefield_zone_mod values(~p, ~p)">>).


-define(select_role_msg, <<"select  `mod`, point, reward   from   role_holy_spirit_battlefield where   role_id = ~p">>).
-define(save_role_msg, <<"replace into  role_holy_spirit_battlefield  values(~p, ~p, ~p, '~s')">>).

-define(set_role_msg, <<"update  role_holy_spirit_battlefield set point = 0 , reward = '[]'">>).




