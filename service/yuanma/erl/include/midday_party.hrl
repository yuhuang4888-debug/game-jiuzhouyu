%%%-----------------------------------
%%% @Module      : midday_party
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 22. 四月 2019 14:23
%%% @Description : 文件摘要
%%%-----------------------------------
-author("chenyiming").

-define(midday_party_close, 0). %%关闭
-define(midday_party_open,  1). %%开启

-define(midday_party_pool_id, 0). %%场景默认进程id
-define(midday_party_sub_id, 1).  %%功能子id

-define(midday_party_low_box_count_id,  1).  %%普通宝箱计数器id
-define(midday_party_high_box_count_id, 2).  %%高级宝箱计数器id
-define(MIDDAY_JOIN,                    3).  %%当日是否参加活动

-define(copy_num, 50).                       %%房间人数上限

-record(midday_party_state, {
	exp_ref = [],                       %%经验定时器
	exp_map = #{},                      %%经验信息 role_id =>exp
	refresh_box_map = #{},              %%刷新宝箱存的map role =>[mon_id]
	status  =   ?midday_party_close,    %%状态
	act_ref = [],                       %%活动超时定时器
	end_time = 0,                       %%活动结束时间戳
	copy_msg = [],                      %% [#copy_msg{}]
	role_list = []                      %%玩家信息
	,copy_max_num = ?copy_num           %%房间人数
	,max_copy = 0                       %%递增
}).

-record(role_midday_part, {
	role_id = 0,                %%玩家id
	lv      = 0,                %%玩家等级
	copy_id  = 0,                %%副本id
	refresh_ref = []            %%宝箱刷新定时器
}).

-record(copy_msg, {
	copy_id = 0,                %%房间id
	box_map         = #{},      %%击杀产生宝箱 role =>[mon_id]
	mon_reborn_ref = [],        %%宝箱怪物重生定时器
	mon_reborn_time = 0,        %%怪物重生时间
	role_list = []              %%玩家id列表
}).