%% ---------------------------------------------------------------------------
%% @doc scene_object_btree

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/1/19 0019
%% @deprecated  对象行为树
%% ---------------------------------------------------------------------------
-define(BTREESUCCESS, success).
-define(BTREEFAILURE, failure).
-define(BTREERUNNING, running).

%% 动作节点最多可运行时间
-define(ACTION_LIMIT, 10 * 1000).

%% 行为强制类型
-define(BEHAVIOR_FORCE_MOVE,    1).
-define(BEHAVIOR_FORCE_TAUNT,   2).

%% 暂不使用
-record(object_btree, {
    root_node_id = 0,   %% 行为树根节点id
    module = none,      %% 树执行器#叶子节点执行函数的Module
    nodes = #{}         %% 所有节点信息 #{nodeId => #object_bnode{}}
}).
%% 暂不使用
-record(object_bnode, {
    node_id = 0,        %% 节点id
    parent_id = 0,      %% 父节点id
    type = none,
    child_list = [],    %% 子节点id列表
    attributes = []    %% 属性
}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(behavior_tree, {
    tree_id = 0,                %% 树ID
    title = <<>>,
    desc = <<>>,
    root_node_id = 0,           %% 行为树根节点id
    % ref = none,               %% 行为唯一标识
    nodes = #{},                %% 所有节点信息 #{nodeId => btreenode()} btreenode(): #selector_node{} | #random_node{} | ......
    result = failure,           %% 每次tick结果 ?BTREESUCCESS | ?BTREEFAILURE | ?BTREERUNNING.
    % status = #{},             %% 保存当前行为树某些状态
    event_map = #{},         %% 通用事件节点|血量、状态节点等
    tick_gap = 200,             %% 每次tick时间间隔
    force_status = []
}).

%% 行为强制状态
-record(behavior_force_status, {
    type = 1,                   %% 强制类型
    next_time = 0
}).


%% 选择节点
-record(selector_node, {
    executor = lib_node_selector
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , child_list = []
    , traverse_child = []       %% 待遍历处理的子节点
}).

%% 随机节点
-record(random_node, {
    executor = lib_node_random
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , child_list = []
    , weight_list = []
}).

%% 顺序节点
-record(sequence_node, {
    executor = lib_node_sequence
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , child_list = []
    , traverse_child = []       %% 待遍历处理的子节点
}).

%% 并行节点
-record(parallel_node, {
    executor = lib_node_parallel
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , child_list = []
    , parallel_cfg = {}
    , status = undefined
}).

-record(parallel_node_status, {
    traverse_child = []       %% 待遍历处理的子节点
    , success_num = 0
    , failure_num = 0
    , enter_args = []
    , running_node = []
}).

%% 计数节点
-record(counter_node, {
    executor = lib_node_counter
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , child_list = []
    , counter = {}
    , execute_num = 0
}).

%% 事件节点
-record(event_node, {
    executor = lib_node_event
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , child_list = []
    , event = {}
    , event_condition = []
    , event_cd = 0
    , event_times = 0
    , event_status = undefined
}).

%% 事件信息
-record(event_node_status, {
    next_event_time = 0   %% 下次能执行事件的时间    interger()/inifity
    , execute_times = 0     %% 剩余执行次数           interger()/inifity
    , is_lock = false
}).

%% 反转节点
-record(inverter_node, {
    executor = lib_node_inverter
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , child_list = []
}).

-record(interval_node, {
    executor = lib_node_interval
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , child_list = []
    , interval = []
    , last_time = 0
}).

%% 循环节点
-record(repeat_node, {
    executor = lib_node_repeat
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , child_list = []
    , repeat = infinity
    , repeat_status = undefined
}).

%% 循环节点
-record(success_node, {
    executor = lib_node_repeat
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , child_list = []
}).

%% 行为节点
-record(action_node, {
    executor = lib_node_action
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , module = undefined            % 行为节点的执行模块
    , args = []                     % 行为节点参数#如需要放指定的技能/移动到制定位置路径
    , time_limit = 5000             % 改节点执行最大时间#超过该时间会返回failure
    , action_status = undefined     % 保存当前行为节点一些执行信息
}).

-record(action_node_status, {
    action_time = 0       % 首次执行时间
    , next_action_time = 0  % 下次执行时间
    , success_time = 0      % 节点成功时间#用于技能释放#技能的是否有后摇时间，技能释放成功不能直接当作节点成功
    , next_action_args = [] % 下次执行时的一些参数
    , enter_args = []       % node leave 时需要
}).

%% 条件节点
-record(condition_node, {
    executor = lib_node_condition
    , desc = <<>>
    , node_id = 0
    , parent_id = 0
    , condition = []
}).

-type result_code() :: ?BTREESUCCESS | ?BTREEFAILURE |?BTREERUNNING.

-type btree() :: #behavior_tree{}.

-type btree_node() :: #selector_node{} | #random_node{} | #sequence_node{} | #parallel_node{}
                    | #counter_node{} | #event_node{} | #inverter_node{} | #repeat_node{}
                    | #success_node{} | #action_node{} | #condition_node{}.
