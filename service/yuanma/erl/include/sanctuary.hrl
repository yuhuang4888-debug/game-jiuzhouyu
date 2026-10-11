%%%-----------------------------------
%%% @Module      : sanctuary
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 01. 三月 2019 15:07
%%% @Description : 文件摘要
%%%-----------------------------------
-author("chenyiming").

-define(sanctuary_act_sub_id, 1).       %% 活动子id
-define(sanctuary_close, 0).            %% 关闭状态
-define(sanctuary_open,  1).            %% 开启状态
-define(sanctuary_yet_over, 2).         %% 永久结束状态


-define(sanctuary_result_time, {23, 00}). %%

-define(sanctuary_mon_dead,    0).        %% 死亡
-define(sanctuary_mon_live,    1).        %% 存活

%%=====================怪物类型=====================
-define(sanctuary_mon_type_guard, 1).     %%守卫
-define(sanctuary_mon_type_elite, 2).     %%精英
-define(sanctuary_mon_type_boss,  3).     %%boss


-define(sanctuary_scene_pool, 0).         %%场景进程池id
-define(sanctuary_copy_id,    0).         %%房间Id

-define(sanctuary_fatigue_time, 5).       %%疲劳时间(分钟)


%%============战斗模式==============
-define(sanctuary_battle_mode_force, 0).  %%强制模式
-define(sanctuary_battle_mode_all,   1).  %%全体模式

-define(sanctuary_id_list, [1, 2, 3]).    %%圣域id列表

%%====================关注功能===================
-define(sanctuary_mon_remind, 1).         %%关注
-define(sanctuary_mon_no_remind, 0).      %%没有关注

-define(sanctuary_preview_time, 5 * 60).  %%提前多少秒预告结算，


-define(sanctuary_default_point,          1000).   %%圣域有归属后的初始积分

-define(sanctuary_kill_log_len,             10).   %%击杀记录长度

-define(sanctuary_remind_first,             1).   %%默认关注记录器

-define(sanctuary_clear_day,                6).   %%数据清理天数

-define(send_protocol,                1).   %%发送关注协议
-define(not_send_protocol,            0).   %%不关注协议

-define(person_rank_time,            3600).   %%个人榜刷新时间（秒）

-define(sanctuary_pk,                  sanctuary_pk). %%圣域pk状态

-define(sanctuary_designation_lost,                  0). %%圣域称号丢失
-define(sanctuary_designation_change,                1). %%圣域称号改变
-define(sanctuary_designation_lost_belong,           2). %% 失去圣域领地归属导致的称号丢失

-define(sanctuary_reborn_time, 15).                      %%复活倒数时间

-define(sanctuary_last_person_rank_time, {20, 00}).      %%最后一天的个人榜单刷新时间

-define(sanctuary_boss_tired_daily_id,  3).              %%圣域boss疲劳计数器子id
-define(sanctuary_boss_tired_add,  10).                  %%击杀一个boss增加的疲劳值

-record(sanctuary_state, {
	act_end_ref = []                        %%关闭定时器
	,status     = ?sanctuary_close
	,preview_end_ref = []                   %%活动结束前预告
	,result_ref = []                        %%结算定时器
	,result_time = 0                        %%结算时间戳
	,act_end_time = 0                       %%活动结束时间戳
	,person_rank_ref = []                   %%个人排行榜结算定时器 整点后10秒结算
	,role_list  = []                        %%玩家信息
	,designation_map = #{}                  %%称号map   key: {SanctuaryId, GuildId} => [#sanctuary_designation{}]
	,last_time_designation = #{}            %%SanctuaryId => [#sanctuary_not_change_designation{}]
	,last_time_guild_rank_list = []         %% [#last_guild_rank{}]
	,sanctuary_map = #{}                    %%圣域列表  sanctuaryId => sanctuary_msg
}).


-record(sanctuary_msg, {
	sanctuary_id = 0                         %%圣域id
	,point       = 0                         %%积分
	,belong      = 0                         %%归属
	,belong_name = <<>>                      %%归属者名字
	,mon_msg     = []                        %%怪物列表
}).


-record(sanctuary_mon_msg, {
	cfg_id          = 0,                          %% 配置id
	reborn_time     = 0,                          %% 重生时间戳
	ref             = []                          %% 重生定时器
	,remind_list    = []                          %% 关注列表
	,kill_log       = []                          %% 击杀记录
	,remind_cd      = 0                           %% 提醒cd
	,status         = ?sanctuary_mon_live         %%
}).

-record(sanctuary_role, {
	role_id =  0,                                 %% 玩家id
	sanctuary_id = 0                              %% 圣域id
	,be_kill_time_list = []                       %% 被击杀的时间戳 [time]
}).


-record(sanctuary_designation, {
	role_id =  0                           %% 玩家id
	,designation = 0                       %% 称号
	,rank        = 0                       %% 排名
	,guild_id    = 0                       %% 公会id
}).

-record(sanctuary_not_change_designation, {
	role_id =  0                           %% 玩家id
	,role_name = <<>>                      %% 玩家名称
	,designation = 0                       %% 称号
	,rank        = 0                       %% 排名
	,power       = 0                       %% 战力
	,guild_id    = 0                       %% 公会id
}).

-record(sanctuary_kill_log, {
	role_id = 0                            %% 玩家id
	,role_name = <<>>                      %%
	,is_show = 0                           %% // 1 显示积分  0 不显示积分
	,diff_point = ""                       %% 减少分数
	,time       = 0                        %% 时间戳
}).

%%上一次公会排名
-record(last_guild_rank, {
	guild_id = 0                           %% 公会id
	,rank  = 0                             %% 排名
}).

-record(sanctuary_role_in_ps, {
	reborn_ref = [],                       %%复活定时器
	guild_rank = 0,                       %%公会排名
	person_rank = 0                       %%个人公会排行榜
}).
%%-record(role_sanctuary_msg, {
%%	 sanctuary_designation = 0                                                    %% 圣域称号
%%	 ,status               = ?sanctuary_designation_status_temp                   %% 称号状态
%%}).



%%===============================sql======================================================================================================================
-define(sql_replace_into_sanctuary_msg,
	<<"replace into  sanctuary_msg(sanctuary_id, point, belong, belong_name)  values(~p, ~p, ~p, '~s')">>).

-define(sql_replace_into_sanctuary_mon_kill_log,
	<<"replace into  sanctuary_mon_kill_log(mon_id, role_id, role_name, is_show, diff_point, time) values(~p, ~p, '~s', ~p, ~p, ~p)">>).

-define(sql_replace_into_sanctuary_mon_remind,
	<<"replace into  sanctuary_mon_remind(mon_id, role_list)   values(~p,'~s');">>).

-define(sql_replace_into_sanctuary_designation,
	<<"replace into  sanctuary_designation(sanctuary_id, guild_id, role_id, designation_id)   values(~p,~p,~p,~p)">>).

-define(delete_sanctuary_designation,
	<<"truncate  sanctuary_designation">>).


-define(sql_select_sanctuary_msg,
	<<"select   sanctuary_id, point, belong, belong_name from  sanctuary_msg">>).

-define(sql_select_sanctuary_remind_list,
	<<"select  role_list from  sanctuary_mon_remind where mon_id = ~p">>).

-define(sql_select_kill_log_list,
	<<"select  role_id , role_name , is_show, diff_point, time from  sanctuary_mon_kill_log  where mon_id = ~p  ORDER BY  time  desc  limit ~p">>).

-define(sql_select_designation_sanctuary_id_guild_id,
	<<"select  DISTINCT sanctuary_id , guild_id  from  sanctuary_designation">>).

-define(sql_select_designation,
	<<"select   role_id, designation_id  from  sanctuary_designation where  sanctuary_id = ~p and  guild_id = ~p">>).

-define(delete_sanctuary_last_time_designation,
	<<"truncate  sanctuary_last_time_designation">>).

-define(sql_replace_into_last_time_designation,
	<<"replace into  sanctuary_last_time_designation(sanctuary_id, guild_id, role_id, role_name, power, designation_id)   values(~p,~p,~p,'~s', ~p, ~p)">>).

-define(sql_select_last_time_designation,
	<<"select  guild_id, role_id, role_name, power, designation_id  from  sanctuary_last_time_designation   where  sanctuary_id = ~p">>).
-define(sql_clear_sanctuary_medal,
	<<"DELETE from  player_special_currency where currency_id = ~p">>).

-define(sql_select_sanctuary_role_msg,
	<<"select  guild_rank , person_rank from   sanctuary_role_in_ps where   role_id = ~p">>).

-define(sql_replace_into_sanctuary_role_msg_in_ps,
	<<"REPLACE into sanctuary_role_in_ps(role_id, guild_rank, person_rank)  VALUES(~p,~p,~p)">>).

-define(sql_delete_from_last_guild_rank,
	<<"truncate  last_guild_rank">>).

-define(sql_replace_into_last_guild_rank,
	<<"REPLACE into last_guild_rank(guild_id, rank)   VALUES(~p,~p)">>).

-define(sql_select_last_guild_rank,
	<<"select  guild_id, rank   from  last_guild_rank">>).

-define(sql_delete_sanctuary_msg,
	<<"truncate  sanctuary_msg">>).

-define(sql_delete_sanctuary_role_in_ps,
	<<"truncate  sanctuary_role_in_ps">>).

-define(sql_delete_sanctuary_mon_kill_log,
	<<"truncate  sanctuary_mon_kill_log">>).

-define(sql_delete_designation,
	<<"DELETE  from  designation  where id in ('306001', '306002', '306003','306004','306005', '306006', '306007', '306008','306009' )">>).

%%===============================sql======================================================================================================================