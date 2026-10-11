%% ---------------------------------------------------------
%% Author:  xyao 
%% Email:   jiexiaowen@gmail.com
%% Created: 2012-5-4
%% Description: 日 ,周,目标 ets
%% --------------------------------------------------------

-define(WEEK_KEY, "mod_week"). 

-define(DEFAULT_SUB_MODULE, 0).         %% 默认模块子id设为0
-define(DEFAULT_OTHER,     []).         %% 默认other扩展数据

%% 每天记录
-record(ets_week, {
        id              = {0,0,0},      %% {模块id, 模块子id, 类型}
        count           = 0,            %% 数量
        other           = [],           %% 扩展数据
        refresh_time    = 0             %% 最后修改时间
    }).

-record(base_week, {
		module          = 0,            %% 所属模块id
        sub_module      = 0,            %% 模块子id
        id              = 0,            %% 周常id
        limit           = 0,            %% 上限
        about           =""             %% 描述
    }).

%% 每周次数记录
-define(sql_week_role_sel_all,  <<"SELECT `module`, `sub_module`, `type`, `count`, `other`, `refresh_time` FROM `counter_week` WHERE role_id=~p">>).
-define(sql_week_role_upd,      <<"REPLACE INTO `counter_week` (`role_id`, `module`, `sub_module`,`type`, `count`, `other`, `refresh_time`) VALUES (~p, ~p, ~p, ~p, ~p, '~s', ~p)">>).
-define(sql_week_role_upd_beach,<<"REPLACE INTO `counter_week` (`role_id`, `module`, `sub_module`,`type`, `count`, `other`, `refresh_time`) VALUES ~s">>).
-define(sql_week_role_clear,    <<"delete from `counter_week` where `role_id` = ~p">>).
-define(sql_week_clear,         <<"truncate table `counter_week`">>).
-define(sql_week_role_sel,      <<"SELECT  `count`, `refresh_time`, `other` FROM `counter_week` WHERE role_id=~p and  module = ~p and sub_module = ~p and type = ~p">>).

%%%---------------------------------------------------------------------
%%% 常量定义
%%%---------------------------------------------------------------------
