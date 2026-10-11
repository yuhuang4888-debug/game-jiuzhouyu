%%%-------------------------------------------------------------------
%%% @author lianghaihui
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% 跨服秘境Boss
%%% @end
%%% Created : 18. 11月 2022 16:43
%%%-------------------------------------------------------------------

-record(great_demon_boss_info, {
    boss_id = 0,
    mon_type = 0,
    scene = 0,
    x = 0, y = 0,
    rand_xy = [],
    num = 0,
    layers = 0,
    drop_lv = 0,
    reborn_time = 0,
    goods = [],
    ratio_goods = [],
    condition = [],
    open_day = 0,
    tired_add = 0
}).

-define(NORMAL_GREAT_DEMON,       0).  %% 普通怪物
-define(SPECIAL_GREAT_DEMON,      1).  %% 特殊大妖
-define(NORMAL_TREASURE_CHEST,    2).  %% 普通宝箱
-define(ADVANCED_TREASURE_CHEST,  3).  %% 高级宝箱

-define(IN_GROUPING,  1).       %% 分组分区期间
-define(NOT_IN_GROUPING, 0).    %% 不处于

%% 开启天数
-define(GREAT_DEMON_BOSS_OPEN_DAY,   data_key_value:get(4700001)).       %%
%% 需要记录的物品id
-define(KF_GREAT_DEMON__RECORD_GOODS_LIST,   data_key_value:get(4700005)).       %%

-define(SYNC_NO,             0).       %% 未同步
-define(SYNC_YES,            1).       %% 已同步

-define(FORCE_NO,            0).       %% 不强制同步更新
-define(FORCE_UP,            1).       %% 强制同步更新

%% 跨服进程
-record(kf_great_demon_state, {
    is_grouping = 0                %% 分组状态，分组时不允许玩家参战
    , role_map = #{}                 %% 所有场景内的玩家信息
    , boss_state_map = #{}          %% 所有分区的怪物信息 #{ZoneId, BossMap}
    , domain_lock = #{}              %% 秘境领域特殊怪复活 时间戳 #{ZoneId, Time}
    , scene_num = #{}
}).

%% 跨服上暂存的玩家信息(部分计算需要用到的玩家个人信息)
-record(kf_role_info, {
    role_id = 0,                 %% 玩家id
    name = <<>>,
    server_id = 0,
    plat_form = <<>>,
    server_num = 0,
    server_name = <<>>,          %% 玩家服务器名
    node = null,                 %% 玩家的节点
    bekill_count = [],
    scene = 0
}).

%% 怪物信息
-record(great_demon_boss_status, {
    boss_id = 0,
    mon_type = 0,
    num = 0,
    reborn_time = 0,
    kill_log = [],
    remind_list = [],
    pos_list = [],
    remind_ref = undefined,
    reborn_ref = undefined,
    optional_data = [],
    xy = []               %% 坐标信息
}).

%% 游戏节点进程
-record(local_great_demon_state, {
    is_grouping = 0          %% 分组标志位
    , role_info_map = #{}    %% 当前游戏节点所有正在参加玩法的玩家信息#{role_id => #role_info{}}
    , boss_state_map = #{}   %% 当前游戏节点的怪物信息
    , tired_map = #{}        %% 本服玩家的游戏疲劳值
    , stay_scene_map = #{}   %% 本服玩家进入玩家场景的开始时间#{role_id => time}
    , sync_flag = 0
    , demon_kill = []        %% 秘境领域杀怪记录 [#demon_boss_kill{}]
    , drop_list = []
}).

%% 玩家信息
-record(local_role_info, {
    role_id = 0,
    tried = 0,            %% 玩家场景内的疲劳值
    tried_ref = 0,        %% 玩家疲劳定时器
    end_time = 0          %% 倒计时退出时间点
    , ref_type = 0        %% 状态 0怒气增加阶段 1退出倒计时10s
}).

%% 秘境领域记录杀怪
-record(kf_domain_boss_kill, {
    role_id = 0,   % 玩家id
    kill_num = 0,  % 击杀boss数量
    get_list = []  % 领取列表  阶段id
}).

