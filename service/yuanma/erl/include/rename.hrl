%% ---------------------------------------------------------------------------
%% @doc name
%% @author  zengzy
%% @since  2017-06-03
%% @deprecated 角色名
%% ---------------------------------------------------------------------------

%% 改名配置
-define(LV_TYPE,            1).
-define(CARD_TYPE,          2).
-define(GOLD_NUM_TYPE,      3).


-define(FREE, 				1). %%免费修改
-define(NOT_FREE, 			2). %%不能免费
-define(MAX_NAME, 			5). %%查看名字最多显示数


-define(GOLD_TYPE,          2). %%钻石
-define(CHANGE_CARD_TYPE,   3). %%改名卡


%%修改名字记录
-record(rename,{
		id,						%% 配置id
		lv_chance,				%% 免费等级
		use_goods               %% 消耗物品 
	}).


-define(SQL_SELECT_PLAYER_RENAME, "select old_name,c_rename_time from `player_rename` where role_id=~p order by c_rename_time desc limit 5 ").
%%修改角色名
-define(SQL_UPDATE_PLAYER_LOW_NAME, "update `player_low` set `nickname`='~s', `c_rename`=1, `c_rename_time`=~p where id=~p ").
%%插入曾用名表
-define(SQL_INSERT_PLAYER_RENAME, "insert into `player_rename` (role_id,old_name,c_rename_time) values (~p,'~s',~p) ").
%%修改钻石
-define(SQL_UPDATE_PLAYER_HIGH, "update `player_high` set ~p=~p where id=~p ").