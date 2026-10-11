%% ---------------------------------------------------------------------------
%% @doc protect.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-03
%% @deprecated 免战保护
%% ---------------------------------------------------------------------------

%% 免战状态
-record(status_protect, {
        protect_map = #{}   % 保护状态Map## #{ scene_type => #protect{} }
        , scene_type = 0    % 场景类型
        , end_time = 0      % 结束时间
    }).

%% 保护
-record(protect, {
        scene_type = 0      % 场景类型
        , protect_time = 0  % 保护时间
        , use_count = 0     % 今日使用次数
        , utime = 0         % 今日使用的更新时间
    }).

%% 免战配置
-record(base_protect, {
        scene_type = 0      % 场景类型
        , use_time = 0      % 每次使用消耗的时间
        , use_count = 0     % 每天使用次数
    }).

-define(sql_role_protect_select, <<"SELECT scene_type, protect_time, use_count, utime FROM role_protect WHERE role_id = ~p">>).
-define(sql_role_protect_replace, <<"REPLACE INTO role_protect(role_id, scene_type, protect_time, use_count, utime) VALUES(~p, ~p, ~p, ~p, ~p)">>).