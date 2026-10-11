%%-----------------------------------------------------------------------------
%%
%% the crontab running in erlang
%%
%% 1. 基本格式(Format):
%% {{m,  h, dom, mon, dow}, {M, F, A}}.
%% {{分, 时, 日, 月, 周}, {M, F, A}}
%% M:F(A)在新建的一个独立临时进程运行
%%
%% 2. 字段取值范围(Field Range):
%%  field               allowed values
%%  -----               --------------
%%  m(minute)           0-59
%%  h(hour)             0-23
%%  dom(day of month)   1-31
%%  mon(month)          1-12
%%  dow(day of week)    1-7
%%
%% 3. 用例(Usage):
%% {{"*/1", "*", "*", "*", "*"}, {io, format, ["crontab~n"]}}.
%% 每分钟输出crontab
%%
%% {{"*", "*/1", "*", "*", "*"}, {io, format, ["crontab~n"]}}.
%% 每小时输出crontab
%%
%% {{0, 3, "*", "*", "*"}, {io, format, ["crontab~n"]}}.
%% 每天凌晨3:0输出crontab
%%
%% {{0, 3, "*", "*", 1}, {io, format, ["crontab~n"]}}.
%% 每周星期一凌晨3:0输出crontab
%%
%% {{0, 21, "1-3,26-28", "*", "*"}, {io, format, ["crontab~n"]}}.
%% 每月1-3号,26-28号的晚上21:00输出crontab
%%
%% {{0, "0-23/2", "*", "*", "*"}, {io, format, ["crontab~n"]}}.
%% 每天0-23小时每隔2小时,即(0,2,4,6,8 ...22)输出crontab
%%-----------------------------------------------------------------------------

%% 游戏服crontab配置
-module(data_crontab).
-export([get_config/0]).

get_config() ->
    [
     %% 每10分钟清理一次过期掉落
     {{"*/10", "*", "*", "*", "*"}, {mod_drop, clean_drop, []}},

     %% 每5分钟更新榜单
     {{"*/1", "*", "*", "*", "*"}, {lib_common_rank_api, timer_common_rank, []}},
     %% {{45, "*", "*", "*", "*"}, {lib_common_rank_api, timer_common_rank, []}},

     %% 邮件推送
     {{"*/1", "*", "*", "*", "*"}, {mod_pushmail, timer_check, []}},

     %% 活动开启
     {{"*/1", "*", "*", "*", "*"}, {mod_activitycalen, timer_check, []}},

     %% 每日21点01分清算竞技排行奖励
     {{1, 21, "*", "*", "*"}, {lib_jjc, timer_reward, []}},

     %% 每日12点刷新数据
     {{0, 12, "*", "*", "*"}, {mod_daily, midday_clear, []}},

     %% 每日 20点 24点 夜间福利状态
     {{0, 20, "*", "*", "*"}, {pp_welfare, send_night_reward_status, [add]}},
     {{0, 0, "*", "*", "*"}, {pp_welfare, send_night_reward_status, [cancel]}},

     %% 定制活动开启
     {{"*/1", "*", "*", "*", "*"}, {mod_custom_act, apply_cast, [timer_check, []]}},

     %% 每20分钟更新一次线路人数
     %% {{"*/20", "*", "*", "*", "*"}, {mod_scene_line, sync_scene_user_num, []}},

     %% 每天两点40分自动消耗玩家(自充)的钻石
%%     {{40, 2, "*", "*", "*"}, {lib_shop, auto_buy_goods, []}},

     % %% 6月18号23点55分发送一份充值奖励邮件
     % {{55, 23, 18, 6, "*"}, {lib_come_back, festival_gift_mail, []}},

     %% *:50分刷新公会战力
     {{50, "*/1", "*", "*", "*"}, {mod_guild, count_guild_combat_power, []}},

     %% 公会战开启
     %%{{"*/1", "*", "*", "*", "*"}, {mod_guild_battle, timer_check, []}},

     %% 每天1-23点2分刷新世界等级
     {{2, "1-23/1", "*", "*", "*"}, {lib_server_kv, timer_update_world_lv, []}},
     %% 每天3点获取登录情况，判断活跃玩家数量
     {{0, 3, "*", "*", "*"}, {lib_server_kv, timer_update_active, []}},
     %% vip特权卡
     {{"*/1", "*", "*", "*", "*"}, {lib_vip, timer_check, []}},

     %% 每一小时检查红包过期
     {{10, "*/1", "*", "*", "*"}, {mod_red_envelopes, daily_timer, [0]}},

     %% 每分钟检查是否要开启boss
     {{"*/1", "*", "*", "*", "*"}, {mod_guild_boss, timer_check, []}},

     %% 每天零点幻域boss
     {{0, 0, "*", "*", "*"}, {mod_decoration_boss_local, ask_sync_update, []}},

     %% 每分钟检查过期没关闭的拍卖会
     {{"*/1", "*", "*", "*", "*"}, {mod_auction, timer_check, []}}

     %% 每周周一4点检查公会头衔
     , {{0, 4, "*", "*", 1}, {mod_guild_prestige, week_reset, []}}

     %% 活动托管，每分钟扣除托管值
     , {{"*/1", "*", "*", "*", "*"}, {mod_activity_onhook, timer_del_coin, []}}
     %% 活动托管，删除过期记录
     , {{10, 2, "*", "*", "*"}, {mod_activity_onhook, clear_record, []}}
     %% 每10分钟上报
     , {{"*/10", "*", "*", "*", "*"}, {lib_game, report_port_limit, []}}
     %% 每天0点30检查定时器是否执行完成
     , {{30, 0, "*", "*", "*"}, {lib_game, monitor_midnight_timer, []}}
     %% 每天4点30检查定时器是否执行完成
     , {{30, 4, "*", "*", "*"}, {lib_game, monitor_4_timer, []}}

     % 每天5点进行公会合并操作
     , {{0, 5, "*", "*", "*"}, {mod_guild, guild_merge, []}}

     % TA数据上报刷新
     , {{59, 3, "*", "*", "*"}, {lib_role_api, ta_daily_refresh_four, []}}
     , {{59, 23, "*", "*", "*"}, {lib_role_api, ta_daily_refresh, []}}
     % 每10分钟执行一次在线人数上报到TA系统
     , {{"*/10", "*", "*", "*", "*"}, {ta_agent_fire, online_track, []}}
     % TA每日0点前上报虚拟的玩家登出数据
     , {{59, 23, "*", "*", "*"}, {ta_agent_fire, online_simu_logout, []}}
    ].
