%%%-----------------------------------
%%% @Module      : holy_summon
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 18. 六月 2019 14:52
%%% @Description : 文件摘要 神圣召唤
%%%-----------------------------------

-define(HAS_RECIEVE,  2).  %已领取
-define(HAS_ACHIEVE,  1).  %已完成未领取
-define(CAN_NOT_RECIEVE, 0).  %未完成


-record(role_holy_summon, {
	act_list = []   %%活动列表
	
}).

-record(role_act_holy_summon, {
	key = [],           %%{type, sub_type}
	type = 0            %%活动主类型
	,sub_type = 0       %%活动次类型
	,draw_times = 0     %%抽奖次数
	,reward_status = [] %%领取状态  [{次数， 状态}]  0 未领取      2已经领取
    ,rare_draw = 0      %%稀有抽奖次数
    ,act_rare_draw = 0  %%活动期间稀有抽奖次数
}).


-define(save_into_role_act_holy_summon,
	<<"REPLACE INTO   role_act_holy_summon(role_id, type, sub_type, draw_times, reward_status, rare_draw, act_rare_draw)  
        VALUES(~p, ~p, ~p , ~p, '~s', ~p, ~p)">>).

-define(select_role_act_holy_summon,
	<<"select  type, sub_type, draw_times, reward_status, rare_draw, act_rare_draw from  role_act_holy_summon where role_id = ~p">>).