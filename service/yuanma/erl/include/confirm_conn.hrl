%% ---------------------------------------------------------------------------
%% @doc confirm_conn.hrl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-07-20
%% @deprecated 确认链接
%% ---------------------------------------------------------------------------

%% 是否链接
-define(CONFIRM_CONN_NO,    0).     % 没链接
-define(CONFIRM_CONN_YES,   1).     % 链接

-define(CONFIRM_CONN_TIME, 30000).  % 确认链接时间(毫秒)

%% 本服状态
-record(bf_confirm_conn_state, {
        is_conn = ?CONFIRM_CONN_NO  % 是否链接
        , conn_ref = none           % 链接定时器
        , server_id = 0             % 服唯一id
        , merge_server_ids = []     % 合服ids
        , optime = 0                % 本服开服时间
        , server_num = 0            % 服数
        , server_name = ""          % 服名字
        , merge_day = 0             % 合服天数
    }).

%% 跨服状态
-record(kf_confirm_conn_state, {
    }).