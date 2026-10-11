%% ---------------------------------------------------------------------------
%% @doc timer_custom.erl

%% @author hjh
%% @since  2016-09-22
%% @deprecated 定时器定制
%% ---------------------------------------------------------------------------

% ------------------- 时间类型 --------------------
-define(TC_TIME_TYPE_START, 1).         % 开启
-define(TC_TIME_TYPE_END, 2).           % 结束
-define(TC_TIME_TYPE_CLEAR, 3).         % 清理

% ------------------- Info类型 --------------------
-define(TC_TYPE_ACT, act).

% --------------------- 其他 ----------------------
-define(TC_DEF_DELAY, 20).              % 默认延迟

%% 时间定制
-record(timer_custom, {
        key = undefined                 % Key值 {type, subtype, time_type}
        , type = undefined              % 类型
        , subtype = undefined           % 次类型
        , time_type = 0                 % 时间类型
        , time = 0                      % 时间
        , delay = 0                     % 延迟处理时间
        , other_data = #{}              % 其他数据
    }).