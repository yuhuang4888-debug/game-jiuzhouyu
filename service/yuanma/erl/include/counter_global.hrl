%% ---------------------------------------------------------
%% Author:  xyao 
%% Email:   jiexiaowen@gmail.com
%% Created: 2012-5-4
%% Description: 手动变更
%% --------------------------------------------------------

-define(COUNTER_GLOBAL_KEY, "mod_global_counter").

-define(COUNTER_GLOBAL_DEFAULT_SUB_MODULE, 0).         %% 默认模块子id设为0
-define(COUNTER_GLOBAL_DEFAULT_OTHER,     []).         %% 默认other扩展数据

%% 终生次数记录
-record(ets_global_counter, {
          id              = {0,0},        %% {模块id, 模块子id, 类型}
          count           = 0,            %% 数量
          other           = [],           %% 扩展数据
          refresh_time    = 0,            %% 最后修改时间
          first_time      = 0             %% 第一次记录时间
         }).

-record(base_global_counter, {
          module          = 0,            %% 所属模块id
          sub_module      = 0,            %% 模块子id
          id              = 0,            %% 次数id
          limit           = 0,            %% 上限
          about           = ""            %% 描述
         }).

%% 终生次数记录
-define(sql_counter_global_sel_all, 
        <<"SELECT `module`, `sub_module`, `type`, `count`, `other`, `refresh_time`, `first_time` FROM `counter_global`">>).

-define(sql_counter_global_upd,
        <<"REPLACE INTO `counter_global` (`module`, `sub_module`, `type`, `count`, `other`, `refresh_time`, `first_time`) VALUES (~p, ~p, ~p, ~p, '~s', ~p, ~p)">>).

-define(sql_counter_global_clear, 
        <<"delete from `counter_global` WHERE module = ~p and sub_module = ~p and type = ~p">>).

-define(sql_counter_global_sel,
        <<"SELECT  `count`, `refresh_time`, `other`, `first_time` FROM `counter_global` WHERE module = ~p and sub_module = ~p and type = ~p">>).



%% 模块0:无
-define(GLOBAL_0_GM_WORLD_LV_OPEN, 1).  %% 世界等级不变的等级##测试使用,大于0就直接取值
-define(GLOBAL_HISTORY_WORLD_LV,   2).  %% 历史世界等级

%% 模块331:定制活动
-define(GLOBAL_331_RER_RAIN_ACTIVITY, 1).  %% 
-define(GLOBAL_331_RER_RAIN_RECHARGE, 2).  %%
-define(GLOBAL_331_ALL_RECHARGE_POLITE, 3).  %% 全服充值的人数

%% 模块154
-define(GLOBAL_154_KF_AUCTION_ID, 1).  %% 
-define(GLOBAL_154_KF_GOODS_ID, 2).  %% 