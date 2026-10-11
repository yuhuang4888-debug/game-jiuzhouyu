%% ---------------------------------------------------------------------------
%% @doc decoration_boss.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-13
%% @deprecated 幻饰boss
%% ---------------------------------------------------------------------------

%% 注意：
%%  copy_id 就是 bossid

-define(DECORATION_BOSS_KV(Key), data_decoration_boss:get_kv(Key)). 

-define(DECORATION_BOSS_KV_LV, ?DECORATION_BOSS_KV(1)).             % 开启等级
-define(DECORATION_BOSS_KV_SBOSS_ID, ?DECORATION_BOSS_KV(2)).       % 特殊bossid
-define(DECORATION_BOSS_KV_SBOSS_SCENE, ?DECORATION_BOSS_KV(3)).    % 特殊boss场景
-define(DECORATION_BOSS_KV_SBOSS_ROLE_NUM, ?DECORATION_BOSS_KV(4)). % 特殊boss人数限制
-define(DECORATION_BOSS_KV_SBOSS_KILL_COUNT, ?DECORATION_BOSS_KV(5)).   % 特殊boss击杀数量限制
-define(DECORATION_BOSS_KV_SBOSS_TIME, ?DECORATION_BOSS_KV(6)).     % 特殊boss时间##[{H,M},{H,M},...],在某一时间判断是否触发特殊boss
-define(DECORATION_BOSS_KV_SBOSS_REWARD_NUM, ?DECORATION_BOSS_KV(7)).   % 获得奖励的数量##{Min排名, Max排名, Num}
-define(DECORATION_BOSS_KV_SBOSS_RANK_WEIGHT, ?DECORATION_BOSS_KV(8)).  % 获得奖励的排名权重##[{MinRank, MinRank, Weight}, ...}
-define(DECORATION_BOSS_KV_OPEN_DAY, ?DECORATION_BOSS_KV(9)).       % 开服天数##必须大于等于2,第一天没有划分区域
-define(DECORATION_BOSS_KV_BUY_COST, ?DECORATION_BOSS_KV(10)).      % 购买消耗##[{Type,GoodsTypeId,Num}]
-define(DECORATION_BOSS_KV_QUIT_TIME, ?DECORATION_BOSS_KV(11)).     % 击杀怪物后退出时间##秒
-define(DECORATION_BOSS_KV_SBOSS_XY, ?DECORATION_BOSS_KV(12)).      % 特殊boss场景的坐标##{X,Y}
-define(DECORATION_BOSS_KV_SBOSS_JOIN_REWARD, ?DECORATION_BOSS_KV(13)).   % 特殊boss参与奖励##[{Type, GoodsTypeId, Num}]
-define(DECORATION_BOSS_KV_SBOSS_DIE_TIME, ?DECORATION_BOSS_KV(14)).    % 特殊boss玩家死亡复活保留时间
-define(DECORATION_BOSS_KV_DROP_LOG_LIST, ?DECORATION_BOSS_KV(15)). % 掉落日志##[GoodsTypeId,...]
-define(DECORATION_BOSS_KV_DROP_LOG_LEN, ?DECORATION_BOSS_KV(16)).  % 掉落长度
-define(DECORATION_BOSS_KV_TV_LIST, ?DECORATION_BOSS_KV(17)).       % 传闻里列表##传闻参数跟{460(模块),1(传闻id)}一致
-define(DECORATION_BOSS_KV_BOSS_DIE_TIME, ?DECORATION_BOSS_KV(18)). % 普通boss玩家死亡原地复活时间
-define(DECORATION_BOSS_KV_ASSIS_REWARD, ?DECORATION_BOSS_KV(19)).  % 普通boss协助奖励##[{Type, GoodsTypeId, Num}]
-define(DECORATION_BOSS_KV_SBOSS_OPEN, ?DECORATION_BOSS_KV(22)).  % 特殊Boss开关

-define(DECORATION_BOSS_ACT_STATUS_OPEN, 0).        % 开启
-define(DECORATION_BOSS_ACT_STATUS_ALLOCATE, 1).    % 分配中

-define(SYNC_TIME_REF, 30 * 1000).       %% 游戏服定时请求跨服同步数据时间间隔
-define(NOT_INIT,       0).       %% 未同步数据
-define(IS_INIT,        1).       %% 已同步数据

%% 幻饰boss的状态
-record(status_decoration_boss, {
        unfollow_list = []      % 不关注列表
        , in_buff = 0           % 双倍Buff
        , buff_etime = 0        % 双倍Buff结束时间
    }).

%% 幻饰boss中心
-record(decoration_boss_center, {
        act_status = ?DECORATION_BOSS_ACT_STATUS_OPEN          % 活动状态
        , zone_map = #{}        % 区域
        , role_map = #{}        % 玩家map
        , sboss_ref = none      % 特殊boss定时器检查
    }).

-record(decoration_boss_zone, {
        zone_id = 0             % 区域id
        , boss_map = #{}        % bossmap## #{boss_id => #decoration_boss{}}
        , kill_log = []         % 击杀记录##暂时不使用
        , sboss_id = 0          % 特殊bossid
        , sboss_scene_id = 0    % 特殊bossid场景id
        , sboss_hurt_list = []  % 伤害列表
        , shp = 0               % 血量
        , shp_lim = 0           % 血量上限
        , sleave_ref = none     % 特殊boss离开定时器
        , kill_count = 0        % 击杀数量
        , is_alive = 0          % 是否存活
        , role_num = 0          % 人数
        , drop_log_list = []    % 掉落日志列表
    }).

%% 幻饰boss本服
-record(decoration_boss_local, {
        is_gm_stop = 0          % 应急设置，运营调用 ，一般是0
        , act_status = ?DECORATION_BOSS_ACT_STATUS_OPEN          % 活动状态
        , is_init = ?NOT_INIT
        , init_def = undefined
        , boss_map = #{}        % bossmap## #{boss_id => #decoration_boss{}}
        , kill_log = []         % 击杀记录##暂时不使用
        , sboss_id = 0          % 特殊bossid
        , sboss_scene_id = 0    % 特殊bossid场景id
        , sboss_hurt_list = []  % 伤害列表##暂时不使用
        , shp = 0               % 血量
        , shp_lim = 0           % 血量上限
        , kill_count = 0        % 击杀数量
        , is_alive = 0          % 是否存活
        , role_num = 0          % 人数
        , drop_log_list = []    % 掉落日志列表
        % 其他
        , role_map = #{}        % 玩家map
    }).

-define(DECORATION_BOSS_ENTER_TYPE_NORMAL, 1).  %% 正常
-define(DECORATION_BOSS_ENTER_TYPE_ASSIST, 2).  %% 协助
-define(DECORATION_BOSS_ENTER_TYPE_GUILD_ASSIST, 3).    % 公会协助进入(无视进入次数，不发助战奖励)

-define(BOSS_TYPE_PLUNDER,      1).     %% 掠夺boss
-define(BOSS_TYPE_SHARE,        2).     %% 共享boss

-define(ASSISTING,              0).     %% 协助中
-define(ASSISTED,               1).     %% 协助完成
-define(ASSISTED2,              2).     %% 协助完成,且发放奖励

-define(IsInBuff,               1).     %% 双倍产出Buff
-define(IsNotInBuff,            0).     %% 无Buff

%% 玩家id
-record(decoration_boss_role, {
        role_id = 0             % 玩家id
        , boss_id = 0           % 怪物id
        , cls_type = 0          % 跨服
        , enter_type = 0        % 进入类型
        , scene_id = 0          % 场景id
        , x = 0                 % x
        , y = 0                 % y
        , server_id = 0         % server_id
        , zone_id = 0           % 区域id
        , die_ref = none        % 死亡定时器
        , hurt = 0              % 当前进入伤害
        , success_assist = 0    % 是否成功助战
    }).

%% boss
-record(decoration_boss, {
        boss_id = 0             % 怪物id
        , scene_id = 0          % 场景id
        , cls_type = 0          % 跨服
        , reborn_time = 0       % 重生时间戳##0没死
        , hp = 0                % 血量
        , hp_lim = 0            % 血量上限
        , hurt_list = []        % 伤害列表
        , assist_list = []      % 协助的玩家id##[{RoleId, ServerId}]
        , own_id = 0            % 拥有者id##首次攻击,暂时不使用
        , role_num = 0          % 人数
        , leave_ref = none      % 离开定时器
        , reborn_ref = none     % 复活定时器#游戏服中跨服boss不会有定时器
    }).

%% boss伤害
-record(decoration_boss_hurt, {
        role_id = 0             % 玩家id
        , name = ""             % 玩家名字
        , server_id = 0         % 服id
        , server_num = 0        % 服数
        , server_name = ""      % 服名字
        , hurt = 0              % 伤害
        , time = 0              % 时间
    }).

%% 幻饰boss配置
-record(base_decoration_boss, {
        boss_id = 0             % 怪物id
        , scene_id = 0          % 场景id##会根据是否跨服场景获取数据
        , cls_type = 0          % 跨服标识##跟场景一致,给客户端使用
        , boss_type = 1         % boss类型##1掠夺boss，2共享boss
        , x = 0                 % x坐标
        , y = 0                 % y坐标
        , role_num = 0          % 人数限制
        , revive_time = 0       % boss复活时间##秒
        , condition = []        % 条件##[{lv, Lv}, {decoration_rating(饰品总评分), Rating}]
        , buff_double_ids = []  % buff卡双倍掉落物品ID
    }).

%% 玩家信息
-define(sql_role_decoration_boss_select, <<"SELECT `unfollow_list`, `in_buff`, `buff_etime` FROM role_decoration_boss WHERE role_id = ~p">>).
-define(sql_role_decoration_boss_follow_update, <<"update `role_decoration_boss` set `unfollow_list` = '~s' where `role_id` = ~p">>).
-define(sql_role_decoration_boss_buff_update, <<"replace into `role_decoration_boss` (`role_id`, `in_buff`, `buff_etime`, `unfollow_list`) values (~p, ~p, ~p, '~s')">>).

%% 幻饰boss区域信息
-define(sql_decoration_boss_zone_select, <<"SELECT kill_count, world_lv, is_alive FROM decoration_boss_zone WHERE zone_id=~p">>).
-define(sql_decoration_boss_zone_replace, <<"REPLACE INTO decoration_boss_zone(zone_id, kill_count, world_lv, is_alive) VALUES(~p, ~p, ~p, ~p)">>).
-define(sql_decoration_boss_zone_delete, <<"TRUNCATE TABLE `decoration_boss_zone`">>).