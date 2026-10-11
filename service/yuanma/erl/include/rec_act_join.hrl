%%%---------------------------------------------------------------------
%%% 活动参与记录服务相关record定义
%%%---------------------------------------------------------------------

-record (join_player, {
	player_id	= 0, 					%% 玩家id
	guild_id 	= 0, 					%% 公会id
	module_id 	= 0, 					%% 模块id
	time 		= 0 					%% 参与时间
}).

-record (authentication_player, {
	authentication_id = 0,                 %% 认证id
	player_id	= 0, 					%% 玩家id
	guild_id 	= 0, 					%% 公会id
	module_id 	= 0, 					%% 模块id
	time 		= 0 					%% 参与时间
}).

-record (act_join_state, {
	join_map 	= #{}, 					%% 参与记录 #{module_id => #{player_id => #join_player{}} }
	authentication_map = #{},           %% 参与记录 #{authentication_id => [#authentication_player{}]}
	ref 		= [], 					%% 定时器引用
	add_num 	= 0, 					%% 待入库数量
	add_list 	= [],  					%% 待入库列表 [#join_player{}|...]
	add_list2   = []                    %% 待入库列表 [#authentication_player{}|...]
}).

-define (SQL_JOIN_LOG_SELECT, 			<<"select `player_id`, `guild_id`, `module_id`, `time` from `join_log` where 1=1">>).
-define (SQL_JOIN_LOG_REPLACE, 			<<"replace into `join_log`(`player_id`, `guild_id`, `module_id`, `time`)
											values(~p, ~p, ~p, ~p) " >>).
-define (SQL_JOIN_LOG_DELETE_LOG, 		<<"delete from `join_log` where `time`<~p" >>).
-define (SQL_JOIN_LOG_DELETE_PLAYER, 	<<"delete from `join_log` where player_id =~p">>).
-define (SQL_JOIN_LOG_DELETE_MODULE,	<<"delete from `join_log` where `module_id` = ~p">>).
-define (SQL_JOIN_LOG_TRUNCATE, 		<<"truncate table `join_log`">>).

-define (SQL_AUTHENTICATION_LOG_SELECT, 			<<"select `authentication_id`, `player_id`, `guild_id`, `module_id`, `time` from `authentication_log` where 1=1">>).
-define (SQL_AUTHENTICATION_LOG_REPLACE, 			<<"replace into `authentication_log`(`authentication_id`, `player_id`, `guild_id`, `module_id`, `time`)
											values(~p, ~p, ~p, ~p, ~p) " >>).
-define (SQL_AUTHENTICATION_LOG_DELETE_LOG, 		<<"delete from `authentication_log` where `time`<~p" >>).
-define (SQL_AUTHENTICATION_LOG_DELETE, 	<<"delete from `authentication_log` where authentication_id =~p">>).
%-define (SQL_AUTHENTICATION_LOG_DELETE_MODULE,	<<"delete from `authentication_log` where `module_id` = ~p">>).
-define (SQL_AUTHENTICATION_LOG_TRUNCATE, 		<<"truncate table `authentication_log`">>).