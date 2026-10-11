%% ---------------------------------------------------------
%% Author:  xyao 
%% Email:   jiexiaowen@gmail.com
%% Created: 2012-5-4
%% Description: 日 ,周,目标 ets
%% --------------------------------------------------------

-define(DAILY_KEY(Clock), lists:concat(["mod_daily_", Clock])). 
-define(TWELVE,24).                     %% 日常次数(凌晨12点)
-define(FOUR,   4).                     %% 日常次数(凌晨4点)

-define(DEFAULT_SUB_MODULE, 0).         %% 默认模块子id设为0
-define(DEFAULT_OTHER,     []).         %% 默认other扩展数据

%% 每天记录
-record(ets_daily, {
        id              = {0,0,0},      %% {模块id, 模块子id, 类型}
        count           = 0,            %% 数量
        other           = [],           %% 扩展数据
        refresh_time    = 0             %% 最后修改时间
    }).

-define(DAILY_KEY_DICT(RoleId), lists:concat(["mod_daily_dict_", RoleId])). 
-record(ets_daily_dict, {
        id              = {0,0,0,0},    %% {玩家id, 模块id, 模块子id, 类型}
        count           = 0,            %% 数量
        other           = [],           %% 扩展数据
        refresh_time    = 0             %% 最后修改时间
    }).

-record(base_daily, {
        module = 0,                     %% 模块id
        sub_module = 0,                 %% 模块子id
        id = 0,                         %% 次数id
        limit = 0,                      %% 上限
        clock = 0,                      %% 清理时间
        write_db = 1,                   %% 是否入库：1持久版，2缓存版(缓存版日清时间统一为凌晨4点)
        about=""                        %% 描述
    }).

%% 每天次数记录(凌晨12点)
-define(sql_daily_role_sel_all, <<"SELECT `module`, `sub_module`, `type`, `count`, `other`, `refresh_time` FROM `counter_daily_twelve` WHERE role_id=~p">>).
-define(sql_daily_role_upd,     <<"REPLACE INTO `counter_daily_twelve` (`role_id`,`module`,`sub_module`,`type`,`count`,`other`,`refresh_time`) VALUES (~p, ~p, ~p, ~p, ~p, '~s', ~p)">>).
-define(sql_daily_role_upd_batch,     <<"REPLACE INTO `counter_daily_twelve` (`role_id`,`module`,`sub_module`,`type`,`count`,`other`,`refresh_time`) VALUES ~s">>).
-define(sql_daily_role_clear,   <<"delete from `counter_daily_twelve` where `role_id` = ~p">>).
-define(sql_daily_clear,        <<"truncate table `counter_daily_twelve`">>).
-define(sql_daily_role_sel,     <<"SELECT `count`, `refresh_time`, `other` FROM `counter_daily_twelve` WHERE role_id = ~p AND `module` = ~p AND `sub_module` = ~p AND `type` = ~p">>).

-define(sql_daily_four_role_sel_all, <<"SELECT `module`, `sub_module`, `type`, `count`, `other`, `refresh_time` FROM `counter_daily_four` WHERE role_id=~p">>).
-define(sql_daily_four_role_upd,     <<"REPLACE INTO `counter_daily_four` (`role_id`,`module`,`sub_module`,`type`,`count`,`other`,`refresh_time`) VALUES (~p,~p,~p,~p,~p, '~s', ~p)">>).
-define(sql_daily_four_role_upd_batch,     <<"REPLACE INTO `counter_daily_four` (`role_id`,`module`,`sub_module`,`type`,`count`,`other`,`refresh_time`) VALUES ~s">>).
-define(sql_daily_four_role_clear,   <<"delete from `counter_daily_four` where `role_id` = ~p">>).
-define(sql_daily_four_clear,        <<"truncate table `counter_daily_four`">>).
-define(sql_daily_four_role_sel,     <<"SELECT `count`, `refresh_time`, `other` FROM `counter_daily_four` WHERE role_id = ~p AND `module` = ~p AND `sub_module` = ~p AND `type` = ~p">>).

-define(sql_daily_count_by_module_type,       <<"select sum(`count`) from `counter_daily_twelve` where `module` = ~p AND `sub_module` = ~p AND `type` = ~p">>).
-define(sql_daily_four_count_by_module_type,  <<"select sum(`count`) from `counter_daily_four` where `module` = ~p AND `sub_module` = ~p AND `type` = ~p">>).
