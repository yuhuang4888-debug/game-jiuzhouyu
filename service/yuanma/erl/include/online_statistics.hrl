
-record(online_state, {
		user_map = #{}      	%%key:{server, role_id} => #online_user 统计所有在线玩家
		,lv_num = #{}    	    %%key:{Lv1, Lv2} => Num      Lv1/Lv2表示对应转生等级上下限 
		,clear_ref = undefined	%%清里定时器
		,clear_time = 0			%%下次清理时间
	}).

-record(online_user,{
		role_id = 0,		
		role_lv = 0,		
		online_sign = 0
	}).

-define(ONLINE,    1).
-define(OFFLINE,   0).
-define(LV_GAP,    5).

-define(sql_online_select,  <<"SELECT min_lv, max_lv, num FROM online_user_statistics">>).
-define(sql_online_replace, <<"REPLACE INTO online_user_statistics (min_lv, max_lv, num) VALUES (~p,~p,~p)">>).
-define(sql_online_truncate,<<"TRUNCATE TABLE online_user_statistics">>).