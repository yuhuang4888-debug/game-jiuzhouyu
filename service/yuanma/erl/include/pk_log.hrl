%%% @doc
%%% 玩家pk记录
%%% @end

-record(pk_status, {
		pk_log_map = #{}    %% #pk_log{}
	}).

-record(pk_log, {
		role_id = 0,	    %% 玩家id
		kill_log = []	    %% {sceneid, sign, time, anmy_name, anmy_id} sign:0击杀 1被杀
        ,kf_kill_log = []   %% {sceneid, sign, time, serverid, servernum, anmy_name, anmy_id} sign:0击杀 1被杀
	}).

-define(PK_KILL,    0).
-define(PK_BE_KILL, 1).

-define(sql_pk_log_select_1, 
	<<"SELECT role_id, scene_id, server_id, server_num, attr_name, attr_id, stime, sign FROM player_pk_log WHERE role_id = ~p">>).

-define(sql_pk_log_select_2, 
	<<"SELECT attr_name, stime, sign FROM player_pk_log WHERE role_id = ~p and scene_id = ~p">>).

-define(sql_pk_log_insert, 
	<<"INSERT INTO player_pk_log (role_id, scene_id, server_id, server_num, attr_name, attr_id, stime, sign) VALUES (~p,~p,~p,~p,'~s',~p,~p,~p)">>).

