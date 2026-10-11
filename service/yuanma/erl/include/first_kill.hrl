%%%-----------------------------------
%%% @Module      : first_kill
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 15. 十月 2019 14:21
%%% @Description : 
%%%-----------------------------------


-define(not_be_kill,  0).
-define(yet_be_kill,  1).
-record(first_kill_state, {
	act_list = []        %%
}).



%%首杀活动
-record(first_kill_act, {
	sub_type = 0        %% 子类型
	,scene_id = 0       %% 场景id
	,boss_id = 0        %% boss
	,status = 0         %% 状态
	,killer_id = 0      %% 击杀者id
	,killer_name = ""   %% 击杀者名字
	,end_time = 0       %% 结束时间
	,ref = []           %% 定时器
	,reward = []        %% 奖励
}).




-define(sql_select_first_kill, <<"select   sub_type, scene_id, boss_id, `status`, killer_id, killer_name  from    custom_act_first_kill">>).

-define(sql_save_first_kill,
	<<"replace into custom_act_first_kill(sub_type, scene_id, boss_id, `status`, killer_id, killer_name)  values(~p, ~p, ~p, ~p, ~p, '~s')">>).

-define(sql_delete_first_kill,
	<<"delete  from  custom_act_first_kill  where  sub_type = ~p">>).


