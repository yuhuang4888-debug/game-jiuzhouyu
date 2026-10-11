%% ---------------------------------------------------------------------------
%% @doc 看门狗服务宏定义
%% @author hek
%% @since  2018-05-24
%% @deprecated 守家护院就靠watchdog啦，值得信赖的伙伴
%% ID编号规则： 2位监控大类+3位编号，Usage：10001
%% ---------------------------------------------------------------------------

-record(watchdog_state, {
    is_tick = 0                         %% 是否执行tick
    , tick_ref = 0                      %% tick定时器引用
    , monitor_map = #{}                 %% 监控选项 #{id => #monitor_item{}}
}).

-record(monitor_item, {                   
    id      = 0                         %% 监控ID
    , value   = undefined               %% 监控VALUE
}).

-define(SQL_REPLACE_INTO_SERVER_DOG,        <<"replace into `server_watchdog`(`id`, `value`) values">>).
-define(SQL_INSERT_LOG_SERVER_DOG,          <<"insert  into `log_server_watchdog`(`time`, `log_list`) values (~p, '~s')">>).
-define(SQL_REPLACE_INTO_TOP_N_PROCESSES,   <<"replace into `server_top_n_processes`(`id`, `top_type`, `pid`, `attr_value`, `registered_name`, `current_function`, `initial_call`) values">>).

-define(CTRL_TYPE_ADD,  1).             %% 监控操作: 累加
-define(CTRL_TYPE_SET,  2).             %% 监控操作: 设值
-define(TICK_TIME,  10*60).             %% TICK超时时间(s)


%% ================================= 监控分类 ================================

-define(WATCHDOG_SERVER_INFO,               10).        %% 服务器信息
-define(WATCHDOG_ERLANG_INFO,               11).        %% erlang信息
-define(WATCHDOG_CLUSTER_INFO,              12).        %% 跨服信息
-define(WATCHDOG_CENTER_INFO,               13).        %% 跨服中心信息
-define(WATCHDOG_SCENE_INFO,                14).        %% 场景信息
-define(WATCHDOG_SOFTHARD_WARE_INFO,        15).        %% 软硬件信息

%% ----------------------------------------------------------------------------
%% @doc 服务器信息?WATCHDOG_SERVER_INFO:10专用的监控ID宏定义
%% ----------------------------------------------------------------------------
-define(WATCHDOD_SERVER_NODE,               10000).     %% 服务器节点
-define(WATCHDOD_SERVER_TYPE,               10001).     %% 服务器类型
-define(WATCHDOD_SERVER_ID,                 10002).     %% 服务器id
-define(WATCHDOD_NODE_START_TIME,           10003).     %% 节点启动时间
-define(WATCHDOD_NODE_CLOSE_TIME,           10004).     %% 节点关闭时间
-define(WATCHDOD_SERVER_STATUS,             10005).     %% 服务器状态   
-define(WATCHDOD_NOW_SYNC_TIME,             10006).     %% 当前状态同步时间
-define(WATCHDOD_NEXT_SYNC_TIME,            10007).     %% 下次状态同步时间
-define(WATCHDOD_SERVER_VERSION,            10008).     %% 服务器版本
-define(WATCHDOD_SERVER_VERSION_TIME,       10009).     %% 版本更新时间
-define(WATCHDOD_SERVER_OPEN_TIME,          10010).     %% 开服时间
-define(WATCHDOD_SERVER_OPEN_DAY,           10011).     %% 开服天数
-define(WATCHDOD_SERVER_MERGE_TIME,         10012).     %% 合服时间
-define(WATCHDOD_SERVER_MERGE_DAY,          10013).     %% 合服天数
-define(WATCHDOD_SERVER_MERGE_CNT,          10014).     %% 合服次数
-define(WATCHDOD_WORLD_LV,                  10015).     %% 当前世界等级
-define(WATCHDOD_OPENNING_ACT_LIST,         10016).     %% 当前活动列表
-define(WATCHDOG_GAME_ERR_CNT,              10017).     %% 当前错误次数
-define(WATCHDOG_GAME_ERR_OVERFLOW,         10018).     %% 错误日志是否超过阀值
-define(WATCHDOG_GAME_ERR_RESUME_CNT,       10019).     %% 日志服务恢复次数
-define(WATCHDOG_MIDNIGHT_CLEAR,            10020).     %% 0点日清时间
-define(WATCHDOG_FOUR_CLEAR,                10021).     %% 4点日清时间
-define(WATCHDOG_DB_CONN_CNT,               10022).     %% db连接数
-define(WATCHDOG_DB_OVERFLOW_CNT,           10023).     %% db扩容数量
-define(WATCHDOG_DB_TABLE_NUM,              10024).     %% 数据库表数量
-define(WATCHDOG_DB_GC_NUM,                 10025).     %% db内存回收次数

%% ----------------------------------------------------------------------------
%% @doc erlang信息?WATCHDOG_ERLANG_INFO:11专用的监控ID宏定义
%% ----------------------------------------------------------------------------
-define(WATCHDOG_IS_OPEN_SMP,               11000).     %% 是否开启SMP
-define(WATCHDOG_SCHEDULER_ONLINE,          11001).     %% 调度器数量
-define(WATCHDOG_RUN_QUEUE_CNT,             11002).     %% 调度器就绪队列
-define(WATCHDOG_MEMORY_TOTAL,              11003).     %% 内存total(M)
-define(WATCHDOG_MEMORY_PROCESSES,          11004).     %% 内存processes(M)
-define(WATCHDOG_MEMORY_ATOM,               11005).     %% 内存atom(M)
-define(WATCHDOG_MEMORY_BINARY,             11006).     %% 内存binary(M)
-define(WATCHDOG_MEMORY_CODE,               11007).     %% 内存code(M)
-define(WATCHDOG_MEMORY_ETS,                11008).     %% 内存ets(M)
-define(WATCHDOG_PROCESS_CNT,               11009).     %% 使用数量process
-define(WATCHDOG_ETS_CNT,                   11010).     %% 使用数量ets
-define(WATCHDOG_PORT_CNT,                  11011).     %% 使用数量port
-define(WATCHDOG_PROCESS_LIMIT,             11012).     %% 使用限制process
-define(WATCHDOG_ETS_LIMIT,                 11013).     %% 使用限制ets
-define(WATCHDOG_PORT_LIMIT,                11014).     %% 使用限制port

%% ----------------------------------------------------------------------------
%% @doc 跨服信息?WATCHDOG_CLUSTER_INFO:12专用的监控ID宏定义
%% ----------------------------------------------------------------------------
-define(WATCHDOG_CLUSTER_LINK_STATUS,      12000).      %% 跨服连接状态
-define(WATCHDOG_CLUSTER_CENTER_NODE,      12001).      %% 跨服中心节点

%% ----------------------------------------------------------------------------
%% @doc 跨服中心信息?WATCHDOG_CENTER_INFO:13专用的监控ID宏定义
%% ----------------------------------------------------------------------------
-define(WATCHDOG_GAME_NODE_CONN_CNT,       13001).      %% 游戏服连接数
-define(WATCHDOG_ZONE_MGR_GROUP,           13002).      %% 小跨服分组情况

%% ----------------------------------------------------------------------------
%% @doc 场景信息?WATCHDOG_SCENE_INFO:14专用的监控ID宏定义
%% ----------------------------------------------------------------------------
-define(WATCHDOG_ONLINE_PLAYER_CNT,        14001).      %% 在线人数
-define(WATCHDOG_ONLINE_OBJECT_CNT,        14002).      %% 场景对象数量
-define(WATCHDOG_LOGIN_PLAYER_CNT,         14003).      %% 上线人数
-define(WATCHDOG_LOGOUT_PLAYER_CNT,        14004).      %% 下线人数

%% ----------------------------------------------------------------------------
%% @doc 软硬件信息?WATCHDOG_SOFTHARD_WARE_INFO:15专用的监控ID宏定义
%% ----------------------------------------------------------------------------
-define(WATCHDOG_CENTOS_VERSION,           15001).      %% centos版本
-define(WATCHDOG_ERLANG_VERSION,           15002).      %% erlang版本
-define(WATCHDOG_MYSQL_VERSION,            15003).      %% mysql版本
-define(WATCHDOG_SYS_USED_MEMORY,          15004).      %% 系统已用内存(G)
-define(WATCHDOG_SYS_TOTAL_MEMORY,         15005).      %% 系统总内存(G)
-define(WATCHDOG_SYS_USED_HARD_DISK,       15006).      %% 系统已用硬盘(G)
-define(WATCHDOG_SYS_TOTAL_HARD_DISK,      15007).      %% 系统总硬盘(G)
-define(WATCHDOG_CPU_VERSION,              15008).      %% cpu类型
-define(WATCHDOG_CPU_CORE,                 15009).      %% cpu核心数量

%% ================================= TOP_N分类 ===============================
-define(TOP_N_TYPE_MEMORY,                    1).       %% 内存total前N的进程
-define(TOP_N_TYPE_BINARY_MEMORY,             2).       %% 内存binary_memory前N的进程
-define(TOP_N_TYPE_REDUCTIONS,                3).       %% CPU前N的进程
-define(TOP_N_TYPE_MSG_QUEUE_LEM,             4).       %% 消息队列长度前N的进程
-define(TOP_N_NAME(Type), 
    case Type of
        ?TOP_N_TYPE_MEMORY -> memory;
        ?TOP_N_TYPE_BINARY_MEMORY -> binary_memory;
        ?TOP_N_TYPE_REDUCTIONS -> reductions;
        ?TOP_N_TYPE_MSG_QUEUE_LEM -> message_queue_len
    end
).
-define(TOP_N,                               20).       %% TOP_N数值
