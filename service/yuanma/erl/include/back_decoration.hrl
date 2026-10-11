%% ---------------------------------------------------------------------------
%% @author  lzh
%% @email  lu13824949032@gmail.com
%% @since  2019-08-03
%% @deprecated 背饰
%% ---------------------------------------------------------------------------

-define(BACK_DECROTEION_TYPE_ID, 	9). 				 %% 背饰
-define(ISRIDE,						1).					 %% 骑乘
-define(NOTRIDE, 					0).					 %% 非骑乘
-define(UPGRADE_DEC, 				2).					 %% 日志记录 升阶
-define(ACTIVE_DEC, 				1).					 %% 日志记录 激活

-record(back_decoration, {
		back_decoration_id
		, stage = 0
		, state = 0      %% 0 没有使用 1 使用中
		, active_stage = 0
	}).

-record(back_decoration_status, {
		back_decoration_list = []
		, attr = []
		, skills = []
		, skill_combat = 0
	}).

-record(base_back_decoration, {
		back_decoration_id
		, stage = 0
		, skill = []
		, attr  = []
		, cost  = []
		, figure_id = 0
		, name  = ""
	}).

-define(sql_select_all_back_decocation, <<"select `back_decoration_id`, `stage`, `state`, `active_stage` from back_decoration_role where `role_id` = ~p">>).
-define(sql_upd_back_decocation, <<"replace into back_decoration_role(role_id, back_decoration_id, stage, state, `active_stage`) values(~p, ~p, ~p ,~p, ~p)">>).
-define(sql_insert_back_decocation, <<"insert into back_decoration_role(role_id, back_decoration_id, stage, state, `active_stage`) values(~p, ~p, ~p ,~p ,~p)">>).
-define(gm_sql_clear_back_decocation, <<"delete from back_decoration_role where `role_id` = ~p">>).
-define (sql_upd_simple, <<"update back_decoration_role set `stage` = ~p where `back_decoration_id` = ~p and `role_id` = ~p">>).


