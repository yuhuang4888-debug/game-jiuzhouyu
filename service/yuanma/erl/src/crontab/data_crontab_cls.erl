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

%% 跨服中心crontab配置
-module(data_crontab_cls).
-export([get_config/0]).

get_config() ->
    [
        %% 每分钟输出crontab
        %% {{"*/1", "*", "*", "*", "*"}, {io, format, ["crontab~n"]}}
        
        %% 每10分钟清理一次过期掉落
        {{"*/10", "*", "*", "*", "*"}, {mod_drop, clean_drop, []}},

        %% 定制活动开启
        {{"*/1", "*", "*", "*", "*"}, {mod_custom_act_kf, apply_cast, [timer_check, []]}}

        %% 1vn
        , {{"*", "*/1", "*", "*", "*"}, {mod_kf_1vN_mgr, check_open, []}}
        %% 周日凌晨4点结算圣兽领榜单
        , {{0, 4, "*", "*", 1}, {mod_eudemons_land, settlement_rank, []}}

        %% 每个小时检查云购活动
        , {{0, "*/1", "*", "*", "*"}, {mod_kf_cloud_buy, timer_check, []}},

        %% 每分钟检查过期没关闭的拍卖会
        {{"*/1", "*", "*", "*", "*"}, {mod_kf_auction, timer_check, []}}

        %% 每个小时同步分区分组世界等级
        , {{0, "*/1", "*", "*", "*"}, {mod_zone_mgr, sync_mod_wordlv, []}}
        %% 每10分钟上报
        , {{"*/10", "*", "*", "*", "*"}, {lib_game, report_port_limit, []}}
        %% 每天0点30检查定时器是否执行完成
        , {{30, 0, "*", "*", "*"}, {lib_game, monitor_midnight_timer, []}}
        %% 每天4点30检查定时器是否执行完成
        , {{30, 4, "*", "*", "*"}, {lib_game, monitor_4_timer, []}}
        %% 每天23点30检查定时器是否执行完成
        , {{57, 23, "*", "*", "*"}, {mod_cycle_rank, calc_daily_act_info, []}}
    ].
