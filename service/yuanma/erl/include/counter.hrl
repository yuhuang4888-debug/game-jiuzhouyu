%% ---------------------------------------------------------
%% Author:  xyao
%% Email:   jiexiaowen@gmail.com
%% Created: 2012-5-4
%% Description: 日 ,周,目标 ets
%% --------------------------------------------------------

-define(COUNTER_KEY, "mod_counter").

-define(COUNTER_DEFAULT_SUB_MODULE, 0).         %% 默认模块子id设为0
-define(COUNTER_DEFAULT_OTHER,     []).         %% 默认other扩展数据

%% 终生次数记录
-record(ets_counter, {
        id              = {0,0},        %% {模块id, 模块子id, 类型}
        count           = 0,            %% 数量
        other           = [],           %% 扩展数据
        refresh_time    = 0             %% 最后修改时间
    }).

-record(base_counter, {
		module          = 0,            %% 所属模块id
        sub_module      = 0,            %% 模块子id
        id              = 0,            %% 次数id
        limit           = 0,            %% 上限
        about           =""             %% 描述
    }).

%% 终生次数记录
-define(sql_counter_role_sel_all,   <<"SELECT `module`, `sub_module`, `type`, `count`, `other`, `refresh_time` FROM `counter` WHERE role_id=~p">>).
-define(sql_counter_role_upd,       <<"REPLACE INTO `counter` (`role_id`, `module`, `sub_module`, `type`, `count`, `other`, `refresh_time`) VALUES (~p, ~p, ~p, ~p, ~p, '~s', ~p)">>).
-define(sql_counter_role_upd_batch, <<"REPLACE INTO `counter` (`role_id`, `module`, `sub_module`, `type`, `count`, `other`, `refresh_time`) VALUES ~s">>).
-define(sql_counter_role_clear,     <<"delete from `counter` where `role_id` = ~p">>).
-define(sql_counter_role_sel,       <<"SELECT  `count`, `refresh_time`, `other` FROM `counter` WHERE role_id=~p and  module = ~p and sub_module = ~p and type = ~p">>).
-define(sql_counter_role_sel_count, <<"SELECT `type`, `count` FROM `counter` WHERE role_id=~p and  module = ~p and sub_module = ~p and type in (~s)">>).
-define(sql_counter_role_clear_by_role_and_type_list, <<"DELETE FROM `counter` WHERE role_id=~p and module = ~p and sub_module = ~p and type in (~ts)">>).
-define(sql_counter_role_clear_by_type_list, <<"DELETE FROM `counter` WHERE module = ~p and sub_module = ~p and type in (~ts)">>).
%%%---------------------------------------------------------------------
%%% 常量定义
%%%---------------------------------------------------------------------

-define (COUNT_ID_417_DOWNLOAD_FIGT, 1).  %% 下载礼包
-define (COUNT_ID_417_NEW_PLAYER_GIF, 2). %% 新手礼包

%%-define (COUNT_ID_416_RUNE_COUNT, 1).   %% 符文寻宝次数
%%-define (COUNT_ID_416_FREE_RUNE_TIME, 2). %% 下次免费时间
-define (COUNT_ID_416_EQUIP_TIMES, 3). %% 装备寻宝次数
-define (COUNT_ID_416_EQUIP_CHOOSE, 5). %% 寻宝是否第一次打开装备自选界面