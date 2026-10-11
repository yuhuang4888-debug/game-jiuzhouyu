%%%-----------------------------------
%%% @Module      : guild_god
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 十二月 2019 16:32
%%% @Description : 公会神像
%%%-----------------------------------


%% API
-compile(export_all).

-author("carlos").


-define(pos_list, [1,2 ,3, 4, 5,6]).
-define(log_type1, 1).  %% 激活（升品）
-define(log_type2, 2).  %% 觉醒
-define(log_type3, 3).  %% 激活组合
-define(log_type4, 4).  %% 激活大师铭文

-define(pos_length, 6).


-record(guild_god_in_ps, {
	god_list = []      %%
}).

-record(guild_god, {
	id = 0 ,
	color   = 0         %% 颜色
	,lv = 0             %% 觉醒等级
	,rune_list = []     %% 符文等级
	,combo_id = 0       %% 现在的combo Id
	,achievement = []   %% 铭文大师成就id
	,last_combo_tv = 0  %% 上次传闻时间
}).



-record(guild_god_rune, {
	pos = 0
	,auto_id =   0
	,goods_type_id = 0
}).


-record(guild_god_combo_cfg, {
	god_id = 0,
	combo_id = 0,
	condition = [],
	attr_skill = []
}).

-record(guild_rune_cfg, {
	goods_id = 0,
	cost = [],
	attr = [],
	new_goods_id  = 0
	,lv = 0
}).



-define(select_guild_god_role, <<"select  god_id, combo_id, achievement, color, lv from  guild_god_role where role_id = ~p">>).
-define(save_guild_god_role, <<"REPLACE into  guild_god_role(role_id, god_id, color, lv, combo_id, achievement)  values(~p, ~p, ~p, ~p, ~p, '~s')">>).