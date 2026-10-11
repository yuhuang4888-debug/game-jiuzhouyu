%%%-----------------------------------
%%% @Module      : feast_cost_rank
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 07. 十二月 2018 17:05
%%% @Description : 文件摘要
%%%-----------------------------------
-author("chenyiming").


-define(feast_cost_rank_length, data_key_value:get(3310048)).
-define(feast_cost_rank_limit_cost,  data_key_value:get(3310049)).
-define(feast_cost_rank_sub_type,  48).  %%活动子类型


-record(feast_cost_state, {
	rank_list  = []           %% #role_rank{}
	,min_cost  = 0,           %% 排行榜最小值
	length     = 0,           %% 长度
    limit_cost = 0            %% 阀值
}).


-record(role_rank,  {
	role_name  = ""           %% 玩家名字
	,role_id   = 0            %% 玩家id
	,cost      = 0            %% 花费
	,rank      = 0            %% 排行
	,refresh_time = 0         %% 刷新时间
	,lv           = 0         %% 玩家等级
}).



%%-----------------------sql-----------------------------------
-define(save_feast_cost_rank,   <<"REPLACE into  role_feast_cost_rank  VALUES(~p, '~s', ~p, ~p, ~p)">>).
-define(delete_feast_cost_rank, <<"DELETE   from  role_feast_cost_rank">>).
-define(select_feast_cost_rank_all,
	<<"select   role_id, role_name, cost, refresh_time , lv from  role_feast_cost_rank   where  lv >= ~p and  cost >= ~p  ORDER BY  cost   desc, refresh_time  ASC   LIMIT  ~p ">>).
-define(select_feast_cost_rank,
	<<"select   role_id, role_name, cost, refresh_time , lv from  role_feast_cost_rank   where  role_id = ~p">>).


%%=====================================================跨服的==============================================
-record(feast_cost_clusters_state, {
	rank_map   = #{}          %% #{zone_id => #feast_cost_zone_state{}]}
}).

-record(feast_cost_zone_state, {
	rank_list  = []           %% #role_rank_clusters{}
	,min_cost  = 0,           %% 排行榜最小值
	length     = 0,           %% 长度
	limit_cost = 0            %% 阀值
}).

-record(role_rank_clusters,  {
	role_name       = ""        %% 玩家名字
	,role_id        = 0         %% 玩家id
	,cost           = 0         %% 花费
	,rank           = 0         %% 排行
	,refresh_time   = 0         %% 刷新时间
	,lv             = 0         %% 玩家等级
	,server_id      = 0         %% 服务器id
	,server_num     = 0         %%
	,server_name    = ""
	,server_zone_id = 0         %% 区域id  废弃，现在用的是大跨服
}).




-define(save_feast_cost_rank_clusters,   <<"REPLACE into  role_feast_cost_rank_clusters  VALUES(~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p, '~s')">>).
-define(delete_feast_cost_rank_clusters, <<"DELETE   from  role_feast_cost_rank_clusters">>).
-define(select_feast_cost_rank_all_clusters,
	<<"select   role_id, role_name, cost, refresh_time , lv, server_id, server_zone_id, server_num, server_name from  role_feast_cost_rank_clusters   where  lv >= ~p and  cost >= ~p
	and server_zone_id = ~p ORDER BY  cost   desc, refresh_time  ASC   LIMIT  ~p">>).
-define(select_feast_cost_rank_clusters,
	<<"select   role_id, role_name, cost, refresh_time , lv, server_id, server_zone_id, server_num, server_name from  role_feast_cost_rank_clusters   where  role_id = ~p">>).
-define(select_feast_cost_rank_clusters_zone,
	<<"select distinct server_zone_id from   role_feast_cost_rank_clusters">>).
-define(update_feast_cost_rank_clusters_zone,
	<<"update role_feast_cost_rank_clusters set server_zone_id = ~p where server_id = ~p">>).

-define(select_all_role,
	<<"select  server_id, role_id, cost from   role_feast_cost_rank_clusters">>).



%%-----------------------sql-----------------------------------