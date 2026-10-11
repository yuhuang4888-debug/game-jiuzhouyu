%%%------------------------------------
%%% @Module  : lucky_cat.hrl
%%% @Author  : zengzy
%%% @Created : 2017-07-17
%%% @Description: 招财猫
%%%------------------------------------

-define(MAX_INPUT_SHOW,    50).

-define(RETURN_GOLD_TYPE,   1).
-define(RETURN_BGOLD_TYPE,  2).

%%ps记录
-record(lucky_cat, {
		input_num = 0            %%投入次数
    }).

%%招财猫进程记录
-record(lucky_cat_state, {
		role_map = [],			  %%投入记录列表，格式#role_input
		% role_input_num = #{},	  %%投入次数，格式 RoleId => Num
		ref_end = undefined,	  %%结束定时器
		end_time = 0              %%活动结束时间
    }).

%%消耗配置
-record(input_cost, {
		id    =   0,				%%次数
		cost  =   0 				%%消耗元宝
    }).

%%返回配置
-record(input_return, {
		id = 0,
		cost_id  =  0,				%%次数id
		times    =  0,				%%倍数
		ratio	 =  0,				%%概率
		money_type = 0 				%%返回元宝类型
    }).

%%玩家投入记录
-record(role_input, {
		% key   =   0,				%%序号
		role_id	   = 0,				%%玩家id
		role_name  = 0,			    %%玩家名字
		% num   =   0,				%%第几次
		cost  =   0,				%%元宝数量
		times =   0,				%%倍数
		sum   =   0, 				%%返回元宝数量
		time
    }).

%%投入记录查询
-define(sql_lucky_cat_select, " SELECT role_id,cost,times,sum,time FROM `lucky_cat_input` order by time desc ").
%%投入次数查询
-define(sql_lucky_cat_count_select, " SELECT count(id) FROM `lucky_cat_input` where role_id=~p ").
-define(sql_lucky_cat_insert, "insert into `lucky_cat_input` (role_id, cost, times, sum, time) values (~p, ~p, '~s', ~p, ~p)" ).
%%情况记录
-define(sql_lucky_cat_delete, "delete from `lucky_cat_input` " ).