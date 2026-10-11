%% ---------------------------------------------------------------------------
%% @doc strong.hrl

%% @author  xlh
%% @email  
%% @since  2019-1-12
%% @deprecated 我要变强
%% ---------------------------------------------------------------------------

-record(to_be_strong_cfg, {
		id = 0,         %% id
		mod_id = 0,		%% 功能id
		type = 0,		%% 类型：1-我要经验，2-我要装备，3-我要绑钻
		lv = 0,	        %% 开启等级
		day_limit = 0	%% 是否每日限制 0否 1是
	}). 

-record(to_strong_status, {
		state_map = #{} %% key:id => #strong_state
	}).

-record(strong_state, {
		id = 0,
		state = 0, 				%% 0未完成 1完成
		time = 0,				%% 完成时间戳
		type = 0,				%% 类型（1=提升战力，2=我要经验，3=我要钻石，4=我要金币）
		lv = 0					%% 等级限制
	}).

%% 我要变强--经验获取途径
-define(DUN_EXP_ID, 	   1001).  	% 经验本
-define(TASK_GOLD_EXP_ID,  1002). 	% 赏金任务
-define(TASK_GUILD_EXP_ID, 1003).   % 公会任务
-define(PRAY_FOR_EXP_ID,   1005).   % 经验祈愿
-define(GUILD_FIR_EXP_ID,  1006).   % 公会篝火
-define(JJC_EXP_ID, 	   1008).   % 竞技场
-define(GUILD_WAR_EXP_ID,  1010).	% 公会战
-define(NINE_BAT_EXP_ID,   1011).   % 九魂圣殿
-define(SEA_TS_EXP_ID,     1012).   % 璀璨之海

%% 我要变强--绑钻获取途径
-define(GUILD_WAR_BGOLD_ID, 2001).  % 公会战
-define(NINE_BAT_BGOLD_ID,  2002).  % 九魂圣殿
-define(JJC_BGOLD_ID, 	    2003).  % 竞技场
-define(DIAMOND_BGOLD_ID, 	2006).  % 钻石大战
-define(SEA_TS_BGOLD_ID, 	2007).  % 璀璨之海

%% 我要变强--装备获取途径 
-define(PER_BOSS_EQUIP_ID,  3004).  % 专属boss
-define(FBD_BOSS_EQUIP_ID,  3005).  % 蛮荒boss
-define(GUILD_FIR_EQUIP_ID, 3006).  % 公会boss

-define(SQL_UPDATE, "replace into to_be_strong(role_id, id, state, time) values(~p, ~p, ~p, ~p)").
-define(SQL_SELECT, "select id, state, time from to_be_strong where role_id = ~p").