-define(ETS_OFFLINE_ACCESS, ets_offline_access).  	%% 离线玩家数据访问信息
-define(ETS_OFFLINE_PLAYER, ets_offline_player).	%% 离线玩家信息

-define(HOT_OFFLINE_COUNT,  1000). 					%% 热点数据总量
-define(ACCESS_TIME_FACTOR, 1). 					%% 最后访问时间因子
-define(ACCESS_REF_FACTOR,  10). 					%% 访问次数因子

%% 离线数据访问信息
-record (ets_offline, {
	id 				= 0,  							%% 玩家id
	access_time 	= 0,  							%% 离线数据最后访问时间
	access_ref 		= 0   							%% 离线数据访问次数	
}).

%% 离线数据
-record(status_off, {
    partner_status = undefined      %% 伙伴状态
    , goods_status = undefined      %% 物品            
}). 