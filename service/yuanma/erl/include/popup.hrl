%%% ------------------------------------------------------------------------------------------------
%%% @doc            popup.hrl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-01-25
%%% @modified
%%% @description    功能弹窗头文件
%%% ------------------------------------------------------------------------------------------------

%%% ======================================= variable macros ========================================

%% kv
% -define(POPUP_KV(Key),  data_popup:get(Key)).

%% 登录触发类型
-define(LOGIN_TRIGGER_FIRST,  1). % 每日首次登录
-define(LOGIN_TRIGGER_ANY,    2). % 任意时间登录
-define(LOGIN_TRIGGER_COND,   3). % 任意时间登录且符合条件

%% 条件触发类型
-define(COND_TRIGGER_INTERVAL,    1). % 固定时间间隔
-define(COND_TRIGGER_TEMPLE_TASK, 2). % 神殿觉醒任务

%%% ======================================== config records ========================================

%% 功能弹窗配置
-record(base_popup, {
    id            = 0   % 唯一id
,   mod_id        = 0   % 模块id
,   sub_id        = 0   % 子模块id
,   login_trigger = 0   % 登录触发
,   cond_trigger  = []  % 条件触发
,   content       = ""  % 弹窗内容
}).

%%% ======================================== general records =======================================

%% 玩家功能弹窗信息
-record(popup, {
    popup_map = #{} % 弹窗信息映射 #{{模块id, 子模块id} => term()}
}).

%%% ========================================== sql macros ==========================================
