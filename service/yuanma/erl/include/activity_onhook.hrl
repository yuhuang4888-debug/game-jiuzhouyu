%% ---------------------------------------------------------------------------
%% @doc 
%% @author lxl
%% @since  
%% @deprecated 活动托管数据
%% ---------------------------------------------------------------------------
-define(sql_values_onhook_coin, "(~p, ~p, ~p, ~p)").
-define(sql_select_onhook_coin_all, <<"select role_id,onhook_coin,exchange_left,coin_utime from role_activity_onhook_coin">>).
-define(sql_batch_replace_onhook_coin, 
  <<"replace into role_activity_onhook_coin (role_id, onhook_coin, exchange_left, coin_utime) values ~s">>).


-define(sql_select_onhook_modules_all, <<"select role_id,module_id,sub_module,select_time from role_activity_onhook_modules">>).
-define(sql_replace_onhook_modules, 
  <<"replace into role_activity_onhook_modules (role_id, module_id,sub_module,select_time) values (~p, ~p, ~p, ~p)">>).
-define(sql_delete_onhook_modules, 
  <<"delete from role_activity_onhook_modules where role_id=~p and module_id=~p and sub_module=~p ">>).

-define(sql_select_onhook_modules_behaviour_all, <<"select role_id,module_id,sub_module,behaviour_id,select_time,times from role_activity_onhook_modules_behaviour">>).
-define(sql_replace_onhook_modules_behaviour,
  <<"replace into role_activity_onhook_modules_behaviour (role_id, module_id,sub_module,behaviour_id,select_time,times) values (~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_delete_onhook_modules_bahaviour,
  <<"delete from role_activity_onhook_modules_behaviour where role_id=~p and module_id=~p and sub_module=~p ">>).
-define(sql_delete_onhook_modules_bahaviour2, 
  <<"delete from role_activity_onhook_modules_behaviour where role_id=~p and module_id=~p and sub_module=~p and behaviour_id=~p ">>).

-define(sql_values_onhook_record, "(~p, ~p, ~p, ~p, ~p, ~p, ~p)").
-define(sql_select_onhook_modules_record, <<"select role_id,module_id,sub_module,onhook_time,result,cost_coin,time from role_activity_onhook_modules_record">>).
-define(sql_replace_onhook_modules_record, 
  <<"replace into role_activity_onhook_modules_record (role_id,module_id,sub_module,onhook_time,result,cost_coin,time) values (~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_batch_replace_onhook_modules_record, 
  <<"replace into role_activity_onhook_modules_record (role_id,module_id,sub_module,onhook_time,result,cost_coin,time) values ~s">>).

%% 挂机准备中，有可能会挂机失败
-define(ACTIVITY_ONHOOK_READY, 1).
-define(ACTIVITY_ONHOOK_START, 2). %% 挂机开始(表示玩家已经成功进入活动)
-define(ACTIVITY_ONHOOK_END, 3).

%% 进程state
-record(activity_onhook_state, {
		role_map = #{}
    }).

-record(activity_onhook_role, {
        role_id = 0
        , onhook_coin = 0      %% 当前托管值
        , exchange_left = 0  %% 换算剩余值
        , coin_utime = 0     %% 托管值更新时间
        , is_dirty_coin = 0  %% 是否脏数据
        , join_module = 0      %% 当前正在托管进行的功能 见：def_module.hrl
        , join_sub_module = 0  %% 当前正在托管进行的子功能
        , cost_coin = 0    %% 活动开始后累计消耗托管值
        , onhook_start_time = 0 %% 开始托管时间
        , onhook_state = 0      %% 挂机状态
        , onhook_module_list = []  %% 托管列表
        , onhook_record_list = []   %% 托管记录
    }).

-record(onhook_module, {
        key = 0              %% {mod, submod}
        , module_id = 0 
        , sub_module = 0
        , select_time = 0     %% 选择时间
        , sub_behaviour_list = []   %% 可选行为
    }).

-record(sub_behaviour, {
        behaviour_id = 0      %% 行为id
        , select_time = 0     %% 选择时间
        , times = 0
    }).

-record(onhook_record, {
        module_id = 0 
        , sub_module = 0
        , onhook_time = 0    %% 托管时长
        , result = 0         %% 结果
        , cost_coin = 0
        , time = 0
    }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 配置
-record(base_activity_onhook_module, {
        module_id = 0 
        , sub_module = 0
        , name = <<>>
        , cost_min = 0
        , condition = []       %% 各种条件
    }).

-record(base_activity_onhook_module_behaviour, {
        module_id = 0 
        , sub_module = 0
        , behaviour_id = 0
        , name = <<>>
        , behaviour_list = []       %% 各种行为
    }).

