%%% ------------------------------------------------------------------------------------------------
%%% @doc            night_ghost.hrl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-04-01
%%% @modified
%%% @description    百鬼夜行头文件
%%% ------------------------------------------------------------------------------------------------

%%% ======================================= variable macros ========================================

%% kv
-define(NG_KV(Key),  data_night_ghost:get(Key)).

-define(NG_LV_LIMIT,        ?NG_KV(1)). % 等级限制
-define(NG_ACT_DURATION,    ?NG_KV(2)). % 活动持续时间(单位:s)
% -define(NG_MIN_HURT,        ?NG_KV(3)). % 获取奖励最小造成伤害
-define(NG_LEFT_BOSS_TV,    ?NG_KV(5)). % 剩余boss传闻时间间隔(单位:s)
-define(NG_COUNTDOWN_TV,    ?NG_KV(6)). % 活动结束倒计时传闻(单位:s)
-define(NG_LIVENESS_DAY1,   ?NG_KV(7)). % 本服首日活跃度
-define(NG_BC_BOSS_REWARD,  ?NG_KV(8)). % 本服召集boss奖励

%% 活动开启状态
-define(NG_ACT_CLOSE,   0). % 关闭
-define(NG_ACT_OPEN,    1). % 开启

%% 缓存数据
-define(CACHE_NG_ACT_INFO,  20601). % 活动信息数据(20601)
-define(CACHE_NG_BOSS_INFO, 20602). % boss信息数据(20602)

%% 参与形式
-define(NG_ROLE, 1). % 以单人形式参加
-define(NG_TEAM, 2). % 以组队形式参加

%% 奖励类型
-define(NG_REWARD_TYPE_RANK,   1). % 按伤害值排行
-define(NG_REWARD_TYPE_KILLER, 2). % 按尾刀
-define(NG_REWARD_TYPE_BC_BOSS,3). % boss召集奖励

%% boss状态信息
-define(NG_BOSS_BORN, 1). % 出生
-define(NG_BOSS_DEAD, 2). % 死亡

%%% ======================================== config records ========================================

%% boss配置
-record(base_night_ghost_boss, {
    ser_mod         = 0,    % 区服模式
    mon_id          = 0,    % 怪物id
    scene_id        = 0,    % 场景id
    loc_list        = [],   % 生成位置列表 [{{X, Y}, 坐标名},...]
    liveness_num    = []    % 活跃度关联boss数量 [{{最小活跃度, 最大活跃度}, 生成数量},...]
}).

%% 奖励配置
-record(base_night_ghost_reward, {
    type            = 0,    % 奖励类型
    highest_rank    = 0,    % 最高排名
    lowest_rank     = 0,    % 最低排名
    min_opday       = 0,    % 最小开服天数
    max_opday       = 0,    % 最大开服天数
    reward          = []    % 奖励
}).

%%% ======================================== general records =======================================

%% 百鬼夜行本地进程状态
-record(night_ghost_state_local, {
    state       = 0,        % 活动开启状态
    zone_id     = 0,        % 分区id
    group_id    = 0,        % 分组id
    ser_mod     = 1,        % 区服模式
    servers     = [],       % 同组游戏服 [#zone_base{},...]
    scene_info  = #{},      % 各场景信息 #{场景id => #scene_info{}}
    act_info    = undefined % 其它活动信息 #act_info{}
}).

%% 百鬼夜行跨服进程状态
-record(night_ghost_state_kf, {
    state      = 0,         % 活动开启状态
    group_map  = #{},       % 区服映射 #{zone_id => {Server2ModGroup, Group2Server, Group2Mod}}
                            % Server2ModGroup :: #{server_id => {ser_mod, group_id}} 游戏服与其跨服模式、分组映射
                            % Group2Server :: #{group_id => [#zone_base{},...]} 跨服模式、分组与对应的游戏服列表
                            % Group2Mod :: #{group_id => ser_mod}
    scene_info = #{},       % 各区场景信息 #{{zone_id, group_id} => #{场景id => #scene_info{}}}
    act_info   = undefined  % 其它活动信息 #act_info{}
}).

%% 场景信息
-record(scene_info, {
    scene_id    = 0,    % 场景id
    boss_info   = []    % boss信息 [#boss_info{},...]
}).

%% boss信息
-record(boss_info, {
    boss_uid    = 0,        % boss唯一id
    boss_id     = 0,        % bossid
    x           = 0,        % 坐标x
    y           = 0,        % 坐标y
    is_alive    = false,    % 是否存活
    bc_player   = []        % 广播boss坐标的玩家 [{server_id, role_id},...]
}).

%% 活动信息
-record(act_info, {
    stime    = 0,         % 开始时间
    etime    = 0,         % 结束时间
    end_ref  = undefined, % 结束定时器
    boss_ref = undefined, % 剩余boss数量提示定时器
    cd_ref   = undefined  % 活动关闭倒计时定时器
}).

%% 排名信息
-record(rank_info, {
    rank        = 0,         % 排名
    key         = undefined, % {sign, id}
    sign        = 0,         % 参与形式标志
    id          = 0,         % 个人id/队伍id
    role_list   = [],        % 玩家列表 [#mon_atter{},...]
    hurt        = 0          % 总伤害值
}).

%%% ========================================== sql macros ==========================================
