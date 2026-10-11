%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%% 角斗场
%%% @end
%%% Created : 26. 十二月 2018 19:28
%%%-------------------------------------------------------------------
-author("whao").

-record(glad_kv_cfg, {   % base_gladiator_kv
    key = 0,             % 键
    value = 0,           % 值
    desc = []            % 备注
}).


-record(glad_power_cfg, { % base_gladiator_power
    medal = 0,            % 勋章等级
    point_power = [],     % 积分战力
    point_weight = []     % 积分权重
}).


-record(glad_robot_attr_cfg, { % base_gladiator_robot_attr
    type = 0,                  % 类型属性
    value = 0                  % 数值
}).


-record(glad_robot_name_cfg, { % base_gladiator_robot_name
    id = 0,                    % 序号
    name = []                  % 名
}).


-record(glad_robot_cfg, {   % base_gladiator_robot
    sex = 0,                % 性别
    role_m = [],            % 角色模型
    weapon_m = [],          % 武器模型
    mount_m = [],           % 坐骑模型
    partner_m = [],         % 伙伴模型
    wing_m = [],            % 翅膀模型
    head_m = []             % 头像资源
}).

-record(glad_ratio, {       % base_gladiator_ratio
    medal = 0,              % 勋章等级
    ratio = 0               % 调整系数
}).

-record(glad_stage_reward, { % base_gladiator_stage_reward
    openday = 0,             % 最小开服天数
    point = 0,               % 积分
    stage_reward = []        % 阶段奖励
}).

-record(glad_rank_reward, { % base_gladiator_rank_reward
    rank =0,                % 排名
    rank_reward=[]          % 阶段奖励
}).


%% state
-record(glad_state, {
    state_type = 0,     %% 进程类型##本服 | 跨服
    status = 0,         %% 状态
    cls_type = 0,       %% 服类型##本服 | 跨服
    stime = 0,          %% 开始时间
    etime = 0,          %% 结束时间
    zone_map = #{},     %% 区域Map Key:ZoneId Value:glad_zone
    role_map = #{},     %% 玩家map Key:RoleId Value:ZoneId
    battle_status_maps = #{}, %% 是否战斗状态中 RoleId => Status
    ref = none,         %% 定时器##结束定时器
    rank_ref = none     %% 榜单定时器
%%    power_ref = none    %% 战力排行榜定时器
}).

%% 区域
-record(glad_zone, {
    zone_id = 0,        %% 区域id
    ranks  = []  ,      %% 榜单数据  #glad_rank
    rank_list = []      %% 排名榜单
}).

%%  玩家榜单
-record(glad_rank,{
    rank = 0,           %% 榜单
    role_id = 0,        %% 玩家id
    server_id = 0,      %% 服id
    zone_id = 0,        %% 区域id
    server_name = "",   %% 平台
    server_num = 0,     %% 服号
    combat_power = 0,   %% 战力
    score = 0,          %% 积分
    stage_reward = [],  %% 阶段奖励 [{状态，阶段}]
    reward = []  ,      %% 积分奖励
    figure = undefined  %% 形象 #figure{}
}).

%%  刷新对手的信息
-record(glad_image_role, {
    role_id      = 0,        %% 玩家ID
    figure       = undefined,%% #figure{}
    hp           = 0,        %% 血量(客户端显示)
    combat       = 0,        %% 战力
    score        = 0,        %% 积分
    honor        = 0         %% 声望
}).

%% 挑战用record
-record(glad_challenge_role, {
    role_id      = 0,        %% 角色id
%%    role_name    = "",       %% 角色名称
    score        = 0,        %% 积分
    role_lv      = 0,        %% 角色等级
    self_figure  = undefined,%% 自己形象
    self_combat  = 0,        %% 自己的战力
    self_rank    = 0,        %% 自己的排名
    rival_id     = 0,        %% 对手id
    rival_figure = undefined,%% 对手形象
    rival_rank   = 0,        %% 对手排名
    rival_combat = 0         %% 对手战力
}).

%% 搜索排名战斗的波动范围
-define(GLAD_SEARCH_RANGE, 4).

%% 活动开放
-define(GLAD_STATE_CLOSE,    0).         %% 未开放
-define(GLAD_STATE_OPEN,     1).         %% 开放期间

%% 排名状态
-define(GLAD_RANK_STAY,          0).            %% 排名没变化
-define(GLAD_RANK_UP,            1).            %% 排名上升
-define(GLAD_RANK_DOWN,          2).            %% 排名下降

%% 领取状态
-define(GLAD_HAVE_NOT_REWARD,0).            %% 不可领
-define(GLAD_HAVE_REWARD,    1).            %% 可领奖励
-define(GLAD_HAD_REWARD,     2).            %% 已经可领

%% 战斗状态
-define(GLAD_BATTLE_STATUS,      1).             %% 战斗中
-define(GLAD_NOT_BATTLE_STATUS,  0).             %% 不在战斗中

%% 战斗结果
-define(GLAD_WIN,            1).            %% 胜利
-define(GLAD_FAIL,           0).            %% 失败

%%  计数器
-define(GLAD_BUY_NUM,        1).            %% vip购买次数
-define(GLAD_USE_NUM,        2).            %%  已挑战次数
-define(GLAD_CHALLENGE_NUM,  4).            %% 剩余挑战次数

-define(GLAD_CLI_SHOW_RANK, 20 ).           %% 玩家显示的排名

%% k-v 表
-define(GLAD_KV(Key), data_gladiator:base_gladiator_kv(Key)).

-define(GLAD_KV_NUM_MAX,                ?GLAD_KV(1)).   %% 初始挑战次数
-define(GLAD_KV_EXTRA_NUM_COST,         ?GLAD_KV(2)).   %% 额外够买次数及消耗
-define(GLAD_KV_RESUME_TIME,            ?GLAD_KV(3)).   %% 挑战次数恢复时间(单位秒)
-define(GLAD_KV_SCORE_GOODS,            ?GLAD_KV(4)).   %% 积分道具
-define(GLAD_KV_OPEN_LV,                ?GLAD_KV(5)).   %% 决斗场开放等级
-define(GLAD_KV_SCENE_ID,               ?GLAD_KV(6)).   %% 决斗场场景id
-define(GLAD_KV_SCENE_XY,               ?GLAD_KV(7)).   %% 场景出生坐标列表
-define(GLAD_KV_PARP_BATTLE_TIME,       ?GLAD_KV(8)).   %% 战斗开始前准备时间
-define(GLAD_KV_BATTLE_LAST_TIME,       ?GLAD_KV(9)).   %% 战斗持续时间
-define(GLAD_KV_REAL_MAN_XY,            ?GLAD_KV(10)).  %% 真人坐标
-define(GLAD_KV_SHOW_LAST_TIME,         ?GLAD_KV(11)).  %% 结算界面持续时间
-define(GLAD_KV_REFRESH_COLD,           ?GLAD_KV(12)).  %% 刷新对手按钮冷却时间
-define(GLAD_KV_CLS_OPEN_DAY,           ?GLAD_KV(13)).  %% 转换成跨服活动的开服天数
-define(GLAD_KV_RANK_REFRESH_TIME,      ?GLAD_KV(14)).  %% 榜单刷新时间
-define(GLAD_KV_VICTORY,                ?GLAD_KV(15)).  %% 挑战胜利奖励，[{积分1,奖励1},...]
-define(GLAD_KV_LOSE,                   ?GLAD_KV(16)).  %% 挑战失败奖励，[{积分1,奖励1},...]
-define(GLAD_KV_HONOR_ID,               ?GLAD_KV(17)).  %% 声望道具
-define(GALD_KV_MAX_RANK,               ?GLAD_KV(18)).  %% 最低排名
-define(GALD_KV_SCORE_ON_RANK,          ?GLAD_KV(19)).  %% 最低上榜积分要求
%%-define(GALD_KV_KF_LITTLE_DAY,          ?GLAD_KV(20)).  %% 开启跨服的最低天数

%% 更新阶段奖励
-define(SQL_INSERT_ROLE_GLAD,
    <<"replace into role_glad (role_id, rank, stage_reward) values (~p, ~p, ~ts)">>).

%%  repalce  glad_rank
-define(SQL_REPLACE_ROLE_GLAD,
    <<"REPLACE INTO role_glad (`zone_id`,`role_id`,`server_id`,`server_name`,`server_num`,`combat_power`,`score`, `stage_reward`) VALUES  (~w, ~w, ~w,'~s', ~w, ~w, ~w,'~s')">>).

-define(SQL_UPDATE_ROLE_GLAD,
    <<"update role_glad set stage_reward = '~s' where role_id = ~p">>).

%% 批量处理
-define(SQL_ROLE_GLAD_VALUES, "(~w,~w,~w,'~s',~w,~w,~w)").
-define(SQL_ROLE_GLAD_BATCH, <<"REPLACE INTO role_glad (`zone_id`,`role_id`,`server_id`,`server_name`,`server_num`,`combat_power`,`score`) VALUES ~ts">>).


%% 获取数据库
-define(SQL_ROLE_GLAD_GET, <<"SELECT `zone_id`,`role_id`,`server_id`,`server_name`,`server_num`,`combat_power`,`score`,`stage_reward`,`figure`  FROM `role_glad`">>).
-define(SQL_ROLE_GLAD_GET_BY_ID, <<"select `zone_id`,`role_id`,`server_id`,`server_name`,`server_num`,`combat_power`,`score`,`stage_reward`,`figure` from `role_glad` where role_id = ~p">>).


%% 清空数据库
-define(SQL_ROLE_GLAD_TRUNCATE, <<"TRUNCATE TABLE role_glad">>).
















