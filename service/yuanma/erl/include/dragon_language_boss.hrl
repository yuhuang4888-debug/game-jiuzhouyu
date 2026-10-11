%%%-----------------------------------
%%% @Module      : dragon_language_boss
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 九月 2019 17:28
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-author("cym").

-define(mon_live, 1).  %% 怪物存在
-define(mon_dead, 2).  %% 怪物死亡

-define(mon_type_small, 1). %% 小怪
-define(mon_type_boss, 2).  %% boss
-define(delay_time,  10).   %% 延迟退出时间

-define(reborn_time,  10).  %% 5秒
%% copy 用区域id来做

%% scene: 地图场景 pool_id:map_id（地图id） copy_id :区域id zone_id

-record(dragon_language_boss_state, {
	boss_refresh_ref = [],          %% boss刷新定时器
	drop_log = [],                  %% 掉落记录
	zone_list = []                  %% 区信息
}).


-record(dragon_language_boss_zone, {
	zone_id = 0                 %% zone_id, 同copy_id
	, mon_map = #{}             %% #map_id => [#mon_msg{}]
	, role_list = []            %% 玩家信息
	, server_info_list = []     %% 服务器信息，[#server_info{}|...]
}).


-record(role_msg, {
	server_id = 0    %% 服务器id
	, server_num = 0
	, scene_id  = 0
	, pool_id = 0     %% 同地图id
	, copy_id = 0
	, role_id = 0
	, role_name = ""
	, left_time = 0   %% 剩余时间
	, ref = []        %% 超时定时器
}).


-record(mon_msg, {
	scene_id = 0, %%
	pool_id = 0,  %% 同地图id
	copy_id = 0,  %% 同区域id
	map_id = 0,   %% 地图id
	mon_id = 0    %% 怪物的类型id
	,x = 0
	,y = 0
	,status = 0   %% 状态
	,reborn_time = 0 %% 复活时间戳
	,ref = []     %% 复活定时器
	
}).

-record(base_dragon_language_boss_map, {
    map_id = 0,  %% '地图id',
	map_name = "", %%'地图名称',
    scene = 0,   %% '场景',
    time = 0,    %% '进图时间',
	cost = [],   %% '消耗',
    lv = 0       %% '等级',
	,mon_list = []  %% 怪物[{mon_id, {x, y}}]
	,attr_list = [] %% 推荐属性
	,show_mon_list = [] %% 展示怪物列表
}).

-record(base_dragon_language_boss_mon, {
	mon_id = 0        %% '怪物id',
	,type = 0         %% '类型 1 小怪 2 boss',
    ,refresh_time = 0 %% '刷新间隔',
	,cost_tme = 0     %% '击杀消耗时间',
    ,preview_reward = [] %% '掉落预览',
	,xy = []          %%  '坐标',
}).


%% boss记录
-record(drop_log, {
	role_id = 0
	, server_id = 0
	, server_num = 0
	, name = ""
	, boss_type = 0
	, boss_id = 0
	, goods_id = 0
	, num = 0                   %% 物品数量
	, rating = 0                %% 评分
	, equip_extra_attr = []     %% 装备附加属性##[{Color,TypeId,AttrId,AttrVal,PlusInterVal,PlusUnit}]
	, is_top = 0                %% 是否置顶
	, time = 0                  %% 时间
}).

%% 服务器信息
-record(server_info, {
	server_id = 0,              %% 服务器id
	server_num = 0
}).




















