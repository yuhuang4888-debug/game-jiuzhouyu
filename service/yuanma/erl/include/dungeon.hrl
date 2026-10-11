%% ---------------------------------------------------------
%% Author:  HHL
%% Created: 2014-6-7
%% Description: 副本纪录
%% --------------------------------------------------------

%% 注意事件: 结算、退出副本都会根据副本类型匹配的。需要自己处理
%% (1)事件添加:
%%      (1)添加事件到内存 lib_dungeon_common_event:make_group_map_help
%%      (2)处理事件 lib_dungeon_common_event:handle_event
%% (2)副本id和副本类型范围
%%  副本类型不能等于副本id:因为可能用于日常判断
%%  副本类型范围:0~1000
%%  副本id范围:大于1000
%% (3)任务处理
%%      lib_dungeon_api:get_task_dungeon_num/2

%% --------------------------------------------------------
%% 配置宏
%% --------------------------------------------------------

%% ----------------------- 副本类型 -----------------------

%% 新增类型注意可否设置助战状态
-define(DUNGEON_TYPE_NORMAL, 0).            % 普通副本.
-define(DUNGEON_TYPE_ZHUXIANTA, 1).         % 诛仙塔
-define(DUNGEON_TYPE_COIN, 2).              % 铜币副本
-define(DUNGEON_TYPE_PET, 3).               % 宠物副本
-define(DUNGEON_TYPE_EXP, 4).               % 经验副本(组队)
-define(DUNGEON_TYPE_EQUIP, 5).             % 装备副本##yyhx
-define(DUNGEON_TYPE_5XING, 6).             % 五行副本
-define(DUNGEON_TYPE_TD, 7).                % 塔防副本
-define(DUNGEON_TYPE_RUNE, 8).              % 聚魂副本##yyhx
-define(DUNGEON_TYPE_GUILD_BOSS, 9).        % 公会boss
-define(DUNGEON_TYPE_VIP_PER_BOSS,  10).    % vip个人boss##yyhx
-define(DUNGEON_TYPE_GUILD_GUARD,  11).     % 守卫公会
-define(DUNGEON_TYPE_RUNE2,  12).           % 符文副本##yyhx
-define(DUNGEON_TYPE_COUPLE,  13).          % 情缘副本
-define(DUNGEON_TYPE_EVIL,  14).            % 诛邪战场
-define(DUNGEON_TYPE_TRAIN,  15).           % 试炼副本
-define(DUNGEON_TYPE_TURN,  16).            % 转生副本##yyhx:完成转生任务的
-define(DUNGEON_TYPE_WAKE,  17).            % 觉醒副本

%% yyhx 新增副本
-define(DUNGEON_TYPE_SPRITE_MATERIAL, 18).            % 精灵副本(材料副本) yyhx_3d的精灵本
-define(DUNGEON_TYPE_PARTNER, 19).          % 伙伴副本(材料副本)
-define(DUNGEON_TYPE_EXP_SINGLE, 20).       % 单人经验副本
-define(DUNGEON_TYPE_ENCHANTMENT_GUARD, 21). % 主线副本-结界守护
-define(DUNGEON_TYPE_WING, 22).             % 翅膀副本(材料副本)
-define(DUNGEON_TYPE_PER_BOSS, 23).         % 个人boss
-define(DUNGEON_TYPE_TOWER, 24).            % 爬塔副本
-define(DUNGEON_TYPE_SEVEN , 25).           % 开服挑战
-define(DUNGEON_TYPE_MAGIC_ORNAMENTS , 26). % 幻饰副本
-define(DUNGEON_TYPE_MON_INVADE, 27).       % 异兽入侵
-define(DUNGEON_TYPE_MON_MATERIALS, 28).    % 材料副本，用于活动日历的配置，实际没这个副本
-define(DUNGEON_TYPE_BOSS_GUIDE, 29).       % boss引导(副本id)
-define(DUNGEON_TYPE_BOSS_GUIDE2, 30).      % boss引导2
-define(DUNGEON_TYPE_DEVIL_INSIDE, 31).     % 心魔副本##技能
-define(DUNGEON_TYPE_DRAGON, 32).           % 龙纹副本
-define(DUNGEON_TYPE_PET2,   33).           % 使魔副本
-define(DUNGEON_TYPE_HIGH_EXP, 34).         % 高级经验副本
-define(DUNGEON_TYPE_RANK_KF, 35).         % 跨服个人排行副本
-define(DUNGEON_TYPE_WEEK_DUNGEON, 36).         % 周常副本
-define(DUNGEON_TYPE_LIMIT_TOWER, 40).      % 限时爬塔(荒川之途)
-define(DUNGEON_TYPE_BEINGS_GATE, 41).      % 众生之门副本
-define(DUNGEON_TYPE_MOUNT_MATERIAL, 42).   % 坐骑材料副本
-define(DUNGEON_TYPE_WING_MATERIAL,  43).   % 羽翼材料副本
-define(DUNGEON_TYPE_AMULET_MATERIAL,44).   % 御守材料副本
-define(DUNGEON_TYPE_WEAPON_MATERIAL,45).   % 神兵材料副本
-define(DUNGEON_TYPE_BACK_ACCESSORIES,46).  % 背饰材料副本

%% yy3d  新增副本
-define(DUNGEON_TYPE_PARTNER_NEW, 37).      % 伙伴副本
-define(DUNGEON_TYPE_DAILY, 38).            % 日常副本
-define(DUNGEON_TYPE_MAIN,  39).            % 主线副本
-define(DUNGEON_TYPE_STORY, 40).            % 故事副本 (yy25d废弃)

%% 34:高级经验副本
%% 波数配置

%% 重新进入副本的列表[只有部分副本允许]
-define(DUNGEON_AGAIN_LIST, [
        ?DUNGEON_TYPE_SPRITE_MATERIAL
        , ?DUNGEON_TYPE_PARTNER
        , ?DUNGEON_TYPE_RUNE2
        , ?DUNGEON_TYPE_WING
        , ?DUNGEON_TYPE_TOWER
        , ?DUNGEON_TYPE_COIN
        , ?DUNGEON_TYPE_SEVEN
        , ?DUNGEON_TYPE_PET2
        , ?DUNGEON_TYPE_RANK_KF
        , ?DUNGEON_TYPE_LIMIT_TOWER
        , ?DUNGEON_TYPE_MOUNT_MATERIAL
        , ?DUNGEON_TYPE_AMULET_MATERIAL
        , ?DUNGEON_TYPE_WEAPON_MATERIAL
        , ?DUNGEON_TYPE_WING_MATERIAL
        , ?DUNGEON_TYPE_BACK_ACCESSORIES
    ]).

-define(IS_AGAIN_DUN(DunType), lists:member(DunType, ?DUNGEON_AGAIN_LIST)).

-define (HELP_DUNGEON_TYPES, [
    % ?DUNGEON_TYPE_EXP
    ?DUNGEON_TYPE_EQUIP,
    ?DUNGEON_TYPE_DRAGON,
    ?DUNGEON_TYPE_WEEK_DUNGEON,
    ?DUNGEON_TYPE_BEINGS_GATE
    ]).

-define(dungeon_materials_list, [
        ?DUNGEON_TYPE_WING,
        ?DUNGEON_TYPE_SPRITE_MATERIAL,
        ?DUNGEON_TYPE_PARTNER,
        ?DUNGEON_TYPE_COIN
]).  %%材料副本  用于活动日历的配置

-define(DUNGEON_NEW_VERSION_MATERIEL_LIST, [
        ?DUNGEON_TYPE_COIN, ?DUNGEON_TYPE_SPRITE_MATERIAL, ?DUNGEON_TYPE_MOUNT_MATERIAL,
        ?DUNGEON_TYPE_WING_MATERIAL, ?DUNGEON_TYPE_AMULET_MATERIAL, ?DUNGEON_TYPE_WEAPON_MATERIAL,
        ?DUNGEON_TYPE_BACK_ACCESSORIES
]).

%% 根据副本类型公用进入次数和助战次数:需要在副本次数增加和判断的函数里，根据副本类型做特殊处理
%% ?DUNGEON_TYPE_PENTACLE
%% ?DUNGEON_TYPE_RISK
%% ?DUNGEON_TYPE_OBLIVION

%% ----------------------- 副本创建类型 -----------------------
-define(DUN_CREATE, 0).            % 创建
-define(DUN_AGAIN, 1).             % 重新进入

%% ----------------------- 是否原地进入 -----------------------
-define(DUN_IS_IN_SITU_NO, 0).              % 不是原地进入
-define(DUN_IS_IN_SITU_YES, 1).             % 原地进入

%% ----------------------- 次数扣除 -----------------------
-define(DUN_COUNT_DEDUCT_ENTER,     1).     % 进入扣除
-define(DUN_COUNT_DEDUCT_SUCCESS,   2).     % 通关扣除
-define(DUN_COUNT_DEDUCT_FAIL,      3).     % 失败扣除
-define(DUN_COUNT_DEDUCT_END,       4).     % 结束扣除
-define(DUN_COUNT_DEDUCT_REWARD,    5).     % 发奖扣除

%% ----------------------- 副本复活类型 -----------------------
-define(DUN_REVIVE_TYPE_NO, 0).                 % 不允许复活
-define(DUN_REVIVE_TYPE_TIME_OVERLAY,    1).    % 复活时间叠加
-define(DUN_REVIVE_TYPE_TIME_OVERLAY_NO, 2).    % 复活时间不叠加

%% ----------------------- 副本复活类型 -----------------------
-define(DUN_COUNT_COND_DAILY,       1).         % 日常次数
-define(DUN_COUNT_COND_WEEK,        2).         % 周次数
-define(DUN_COUNT_COND_PERMANENT,   3).         % 永久次数
-define(DUN_COUNT_COND_DAILY_HELP,  4).         % 日常助战次数(与日常次数是与或的关系)
-define(DUN_COUNT_COND_DAILY_REWARD,5).         % 日常次数 领奖的时候加

%% ----------------------- 事件触发 -----------------------
-define(DUN_EVENT_TYPE_ID_TIME, 1).                         % 时间事件.EventData:EventTime
-define(DUN_EVENT_TYPE_ID_KILL_MON, 2).                     % 击杀怪物.EventData:[MonKey, MonId]
-define(DUN_EVENT_TYPE_ID_MON_EVENT_ID_KILL_ALL_MON, 3).    % 对应刷怪事件配置ID的怪全部被杀死.EventData:KillMonEventId
-define(DUN_EVENT_TYPE_ID_MON_EVENT_ID_FINISH, 4).          % 对应刷怪事件配置ID的触发元素全部触发.EventData:TargetMonEventId
-define(DUN_EVENT_TYPE_ID_ROLE_HP, 5).                      % 玩家血量事件.EventData:[HpRate,...]
-define(DUN_EVENT_TYPE_ID_ROLE_XY, 6).                      % 玩家坐标事件.EventData:[SceneId, X, Y]
-define(DUN_EVENT_TYPE_ID_MON_HP, 7).                       % 怪物血量事件.EventData:[MonId, [HpRate,...]]
-define(DUN_EVENT_TYPE_ID_STORY_ID_FINISH, 8).              % 完成剧情id事件.EventData:StoryId
-define(DUN_EVENT_TYPE_ID_SKIP_DUNGEON, 9).                 % 跳过副本
-define(DUN_EVENT_TYPE_ID_ACTIVE_QUIT, 10).                 % 主动退出
-define(DUN_EVENT_TYPE_ID_LOGOUT, 11).                      % 登出
-define(DUN_EVENT_TYPE_ID_DELAY_LOGOUT, 12).                % 延迟登出
-define(DUN_EVENT_TYPE_ID_DUNGEON_TIMEOUT, 13).             % 副本超时
-define(DUN_EVENT_TYPE_ID_LEVEL_TIMEOUT, 14).               % 关卡超时
-define(DUN_EVENT_TYPE_ID_WAVE_SUBTYPE_REFRESH, 15).        % 副本波数子类型刷出
-define(DUN_EVENT_TYPE_ID_DIE_COUNT, 16).                   % 死亡次数
-define(DUN_EVENT_TYPE_ID_WAVE_TIMEOUT, 17).                % 波数超时
-define(DUN_EVENT_TYPE_ID_DIE_WITHOUT_REVIVE, 18).          % 玩家死亡并没有复活次数

%% 副本记录键定义
-define (DUNGEON_REC_PASSTIME, 1).      %% 通关时间
-define (DUNGEON_REC_SCORE, 2).         %% 评价等级
-define (DUNGEON_REC_MAX_SCORE, 3).         %% 历史最佳
-define (DUNGEON_REC_DAILY_MAX_SCORE, 4).         %% 每日最佳
-define (DUNGEON_REC_UPDATE_TIME, 5).         %% 更新时间
-define (DUNGEON_REC_LAST_EXP_GET, 6).        %% 上次获取的经验值

-define (DUNGEON_REC_EVIL_REWARD, 256).         %% 特殊记录 诛神战场每日奖励领取状态

%% 副本结算自定义键
-define (DUNGEON_RES_KEY_EVIL_DAILY_SCORE, 1).  %% 诛神战场今日最高
-define (DUNGEON_RES_KEY_EVIL_MAX_SCORE, 2).    %% 诛神战场历史最高
-define (DUNGEON_RES_KEY_EVIL_NOW_SCORE, 3).    %% 诛神战场本场积分

%% 副本state类型特殊数据key定义
% -define (DUN_STATE_SPCIAL_KEY_MON_ADD_ATT, "mon_event_born_attr").
-define (DUN_STATE_SPCIAL_KEY_REPLACE_MON, "mon_event_replace_mon").
-define (DUN_STATE_SPCIAL_KEY_MON_BORN_TIME, "mon_event_born_time").    % [{怪物事件id, 出生时间戳}]
-define (DUN_STATE_SPCIAL_KEY_EQUIP_SCORE, "equip_dungeon_score").
-define (DUN_STATE_SPCIAL_KEY_GUILD_ID, "guild_id").
-define (DUN_STATE_SPCIAL_KEY_MON_DIE, "mon_die").
-define (DUN_STATE_SPCIAL_KEY_DIE_MON_COUNT, "die_mon_count").
-define (DUN_STATE_SPCIAL_KEY_HURT_RANK, "hurt_rank").
-define (DUN_STATE_SPCIAL_KEY_HP_LIST, "hp_list").
-define (DUN_STATE_SPCIAL_KEY_COMMON_DUNR, "common_dun_r").
-define (DUN_STATE_SPCIAL_KEY_MON_REVIVE, "mon_revive").
-define (DUN_STATE_SPCIAL_KEY_CHANGE_SEX_MON, "change_sex_mon").
-define (DUN_STATE_SPCIAL_KEY_WAVE_INFO, "wave_info").
-define (DUN_STATE_SPECIAL_KEY_ADD_EXP_LIST, "add_exp_list"). %%
-define (DUN_STATE_SPECIAL_KEY_DRAGON_JUMP_WAVE, "dragon_jump_wave").  %% 龙纹本跳关波数
-define (DUN_STATE_SPECIAL_KEY_REVIVE_COUNT, "revive_count").  %% 复活次数信息
-define (DUN_STATE_SPECIAL_KEY_PARTNER_KILL_MSG, "partner_kill_msg").  %%  伙伴副本击杀怪物信息

%% 玩家的key值
-define (DUN_ROLE_SPECIAL_KEY_ENCOURAGE, "encourage").              % 鼓舞次数
-define (DUN_ROLE_SPECIAL_KEY_SLOWDOWN_TIME, "slowdown_time").
-define (DUN_ROLE_SPECIAL_KEY_SKIP_MON_NUM, "skip_mon_num").
-define (DUN_ROLE_SPECIAL_KEY_MON_COMMON_EVENT_ID, "mon_common_event_id"). %% 当前的刷怪事件Id
-define (DUN_ROLE_SPECIAL_KEY_CREATE_MON, "create_mon").   %% 在下一波中加入特定怪物
-define (DUN_ROLE_SPECIAL_KEY_BOSS_STATUS, "boss_create_status").   % %聚魂副本boss创建状态
-define (DUN_ROLE_SPECIAL_KEY_ENCHANTMENT_GUARD_GATE, "guard_gate"). %% 主线副本的关卡
-define (DUN_ROLE_SPECIAL_KEY_MON_DIE, "mon_die"). %% 怪物死亡数量##Value:怪物数量
-define (DUN_ROLE_SPECIAL_KEY_ADD_EXP, "add_exp"). %% 经验加成
-define (DUN_ROLE_SPECIAL_KEY_WAVE_REWARD, "wave_reward").  %% 波数奖励
-define (DUN_ROLE_SPECIAL_KEY_SETTING, "setting").  %% 副本设置参数
-define (DUN_ROLE_SPECIAL_KEY_EXP_LIST, "exp_list").%% 经验基础##[{Ratio, Exp},...], Ratio为主键
-define (DUN_ROLE_SPECIAL_PARTNER_RECORD, "partner_record").%% 伙伴副本记录
-define (DUN_ROLE_SPECIAL_KEY_EXP_RECORD, "get_exp_recrod").%% 经验记录
-define (DUN_ROLE_SPECIAL_KEY_ENTER_EXP_INFO, "enter_exp_info").%% 进入时经验信息
-define (DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_NEXT_TIME, "trigger_exp_next_time").%% 下次触发经验本时间

-define (ENCOURAGE_COST_TYPE_COIN, 1).
-define (ENCOURAGE_COST_TYPE_GOLD, 2).

-define (RUNE_DAILY_REWARD_MAX_NUM, 15).        %% 符文副本日常奖励最多领取天数

-define (WAKE_DUNGEON_SLOWDOWN_COST (Price), [{?TYPE_BGOLD, 0, Price}]).

-define(DUNGEON_PUSH_SETTLE_NO,  0). %%玩家没有推送奖励
-define(DUNGEON_PUSH_SETTLE_YES, 1). %%玩家已经推送奖励


-define(DUNGEON_FORCE_PUSH_SETTLE_NO,  0). %%玩家不强制推送
-define(DUNGEON_FORCE_PUSH_SETTLE_YES, 1). %%玩家强制推送奖励 针对玩家退出，副本进程stop， 所以在玩家进程进行推送奖励

%%副本结算时，额外奖励类型，
-define(DUNGEON_PUSH_SETTLE_MULTIPLE_REWARD, 1).  %%多倍奖励

-define(dragon_dun_preparation_time, 10).         %%龙纹副本准备时间

%% TODO:事件data的记录

%% 时间事件1
-record(dun_callback_time, {
        event_time = 0          % 时间
    }).

%% 击杀怪物1
-record(dun_callback_kill_mon, {
        create_key = undefined  % 怪物创建key
        , mon_id = 0            % 怪物id
        % , die_info = []         % 死亡信息 [{killer, PlayerId}|T] T为初始化传给怪物的{die_info, V}对应的值，详细见mod_mon_active:set_mon/6和lib_mon_event:get_die_data/3
    }).

%% 对应刷怪事件配置ID的怪全部被杀死1
-record(dun_callback_mon_event_id_kill_all_mon, {
        kill_mon_event_id = 0   % 被击杀的怪物事件id
    }).

%% 对应刷怪事件配置ID的触发元素全部触发1
-record(dun_callback_mon_event_id_finish, {
        mon_event_id = 0        % 怪物事件id
    }).

%% 玩家血量百分比达到HpRate1
-record(dun_callback_role_hp, {
        hp_rate_list = []       % [Hp,...]
    }).

%% 到达位置1
-record(dun_callback_role_xy, {
        scene_id = 0
        , x = 0
        , y = 0
    }).

%% 某种类型怪物的血量百分比达到HpRate1
-record(dun_callback_mon_hp_rate, {
        mon_id = 0
        , hp_rate_list = []
    }).

%% 剧情结束1
-record(dun_callback_story_id_finish, {
        story_id = 0            % 剧情id
        , sub_story_id = 0      % 子剧情id
        , start_time = 0        % 剧情开启时间     毫米级别
    }).

%% 延迟登出
-record(dun_callback_delay_logout, {
        role_id = 0                 % 玩家id
        , delay_logout_time = 0     % 延迟登出时间
    }).

%% 延迟登出定时器
-record(dun_callback_delay_logout_ref, {
        role_id = 0                 % 玩家id
        , delay_logout_time = 0     % 延迟登出的时间
        , event_time = 0            % 时间触发
    }).

%% 副本波数子类型刷出
-record(dun_callback_wave_subtype_refresh, {
        mon_event_id = 0            % 怪物事件id
        , wave_subtype = 0          % 波数子类型
    }).


%% 死亡次数
-record(dun_callback_die, {
	role_id = 0                 % 死亡
}).


%% ----------------------- 结果 -----------------------
-define(DUN_SETTLEMENT_TYPE_DIRECT_END, 0).     % 直接结算
-define(DUN_SETTLEMENT_TYPE_LEVEL_END, 1).      % 只推送结算信息(关卡等结算)

%% ----------------------- 副本关卡是否结束 -----------------------
-define(DUN_LEVEL_CHANGE_TYPE_NO,   0).    % 无
-define(DUN_LEVEL_CHANGE_TYPE_RAND, 1).    % 读取随机关卡
-define(DUN_LEVEL_CHANGE_TYPE_ORDER,    2).% 按关卡序号

%% ----------------------- 结算推送类型 -----------------------
-define(PUSH_SETTLEMENT_TYPE_WHEN_OUT, 0).      % 退出副本推结算
-define(PUSH_SETTLEMENT_TYPE_WHEN_FINISH, 1).   % 完成副本推结算

%% ----------------------- 额外奖励类型#手动领取 -----------------------
-define(DUN_EXTRA_REWARD_TYPE_NORAML, 1).       % 普通 => [{1:普通, [{Type, GoodsTypeId, Num},..]}]
-define(DUN_EXTRA_REWARD_TYPE_TOP, 2).          % 顶级 => [{2:顶级, [{Type, GoodsTypeId, Num},..]}]
-define(DUN_EXTRA_REWARD_TYPE_FIRST, 3).        % 首次 => [{3:首次, 参考奖励格式(?REWARD_TYPE_NORMAL,..)},...]

%% ----------------------- 战力碾压类型:读取推荐战力 -----------------------
-define(DUN_POWER_CRUSH_TYPE_NO,    0).     % 无
-define(DUN_POWER_CRUSH_TYPE_BASE,  1).     % 副本主配置
-define(DUN_POWER_CRUSH_TYPE_LEVEL, 2).     % 副本关卡配置
-define(DUN_POWER_CRUSH_TYPE_WAVE_HELPER,  3).  % 副本波数辅助配置

-define(DUN_HAD_LOAD,   1).  %% 副本已经加载了
-define(DUN_NOT_LOAD,   0).  %% 副本没有加载

-define(DELAY_LOAD_MAX_TIME, 10).  %%延迟加载最大时间限制（秒）
-define(DELAY_DUN_LIST, [
    ?DUNGEON_TYPE_RUNE2, ?DUNGEON_TYPE_PARTNER_NEW, ?DUNGEON_TYPE_EQUIP, ?DUNGEON_TYPE_DRAGON
    , ?DUNGEON_TYPE_RANK_KF
    ]).  %% 延迟加载副本类型列表


%% --------------------------------- 基本副本 ----------------------------------
%% 副本配置数据
-record(dungeon, {
        id = 1                          % 副本id
        , name = <<"">>                 % 副本名称
        , type = 0                      % 副本类型
        , npc_id = 0                    % npc_id入口
        , cost = []                     % 进入消耗(门票)##[{Type, GoodsType, Num}] 或者 [{X,Y,[{Type, GoodsType, Num}]}]：取X <= 目标次数 <= Y 的消耗
        , is_auto_buy_sweep = 0         % 是否自动购买扫荡消耗##0:否；1：是。如果根据副本类型扫荡的话也要配置(data_dungeon_special 中的 is_auto_buy_sweep )
        , sweep_lv = 0                  % 扫荡等级## 0：不可以扫荡，>0的等级就可以扫荡
        , sweep_cost = []               % 扫荡消耗##[{Type, GoodsType, Num},...]
        , level_change_type = 0         % 关卡切换类型
        , diff_lv = 0                   % 副本难度##0:无,1:普通,2:困难,3:地狱

        , scene_id = 0                  % 场景id
        , scene_list = []               % 场景id列表
        , scene_out = []                % 退出场景和坐标[Sid, X, Y]
        %% , is_in_situ = 0                % 是否原地进入(0:无;1:原地进入)
        %% , parnter_battle_type = 0       % 伙伴战斗类型(0:无出战;1:允许出战伙伴)
        , count_deduct = 0              % 次数扣除(1:进入扣除;2:通关扣除;3:失败扣除;4:结束扣除)
        , revive_type = 0               % 复活类型(0:不允许复活;1:复活时间叠加;2:复活时间不叠加)
        , revive_count = 0              % 复活次数(复活类型为1和2时,复活次数为0,则表示无限)
        , revive_time = 0               % 复活秒数
        , wave_num = 0                  % 副本波数
        , time = 0                      % 副本时间
        , count_cond = []               % 次数条件 [{类型(1:日次数;2:周次数;3:终身次数), 次数上限}]
        , condition = []                % 进入条件 见 lib_dungeon:check_dungeon_condition
        , open_begin = 0                % 开服时段开始天数
        , open_end = 0                  % 开服时段结束天数
        , start_time = 0                % 活动开始时间
        , end_time = 0                  % 活动结束时间
        , week_list = []                % 星期开放列表
        , mon_event = []                % 刷怪事件 [{事件场景ID,
                                        %           [
                                        %             {事件编号ID1, 波数类型1, 参数列表, [{触发元素1},{触发元素2},...]},
                                        %             {事件编号ID2, 波数类型2, 参数列表, [{触发元素3},{触发元素4},...]},
                                        %             ...
                                        %           ]
                                        %          }]
        , story_event = []              % 剧情事件 [{事件场景ID,
                                        %           [
                                        %             {事件编号ID1, [剧情配置ID1, 剧情子类型], 参数列表, [{触发元素1},{触发元素2},...]},
                                        %             {事件编号ID2, [剧情配置ID2, 剧情子类型], 参数列表, [{触发元素3},{触发元素4},...]},
                                        %             ...
                                        %           ]
                                        %          }]
        , zone_event = []               % 区域事件 [{事件场景ID,
                                        %           [
                                        %             {事件编号ID1, {[{区域配置ID1, 切换状态(0可行走 1障碍区, 5安全区)},...], [{特效编号ID1, 特效修改(0删除,1增加)},..]}, [{触发元素1},{触发元素2},...]},
                                        %             {事件编号ID2, {[{区域配置ID2, 切换状态(0可行走 1障碍区, 5安全区)},...], [{特效编号ID2, 特效修改(0删除,1增加)},..]], [{触发元素3},{触发元素4},...]},
                                        %             ...
                                        %           ]
                                        %          }]
        , scene_event = []              % 场景事件 [{事件场景ID,
                                        %           [
                                        %             {事件编号ID1, 参数列表, [{触发元素1},{触发元素2},...]},
                                        %             {事件编号ID2, 参数列表, [{触发元素3},{触发元素4},...]},
                                        %             ...
                                        %           ]
                                        %          }]
        , success_event = []            % 通关事件 [{事件场景ID,
                                        %           [
                                        %             {类型(0:直接结算,1:只推送结算信息), 参数列表, [{触发元素1},{触发元素2},...]},
                                        %             {类型, 参数列表, [{触发元素3},{触发元素4},...]}
                                        %           ]
                                        %          }]
        , fail_event = []               % 失败事件 [{事件场景ID,
                                        %           [
                                        %             {类型(0:直接结算,1:只推送结算信息), 参数列表, [{触发元素1},{触发元素2},...]},
                                        %             {类型, 参数列表, [{触发元素3},{触发元素4},...]}
                                        %           ]
                                        %          }]
        , push_settlement_type = 0      % 推结算类型##需要配合 {quit_time,Time} 使用,来处理退出的结算
        , dynamic_attr = []             % 动态属性 生成怪物属性
        , recommend_power = 0           % 推荐战力
        % , is_use_power_crush = 0        % 是否使用战力碾压(0:无,1:是)##后面会删掉这个
        , power_crush_type = 0          % 战力碾压类型
        , buy_count_cost = []           % 次数购买消耗##没有表示不能购买,[{次数,铜币数}]
        , extra_reward = []             % 额外奖励##格式:[{奖励类型(1:普通 2:顶级 3:首次), [{Type, GoodsTypeId, Num},..]|参考奖励格式(?REWARD_TYPE_NORMAL,..) }]
                                        % 1:通关后手动领取,只能领取一次的奖励=> [{1:普通, [{Type, GoodsTypeId, Num},..]}]
                                        % 2:通关处理=> [{2:顶级, [{Type, GoodsTypeId, Num},..]}]
                                        % 3:首次奖励=> [{3:首次, 参考奖励格式(?REWARD_TYPE_NORMAL,..)},...]
    }).

%% ----------------------- 随机数量类型 -----------------------
-define(DUN_RAND_TYPE_NORMAL,   0).         % 普通随机
-define(DUN_RAND_TYPE_SAME, 1).             % 随机出相同怪物
-define(DUN_RAND_TYPE_SAME_CYCLE_XY, 2).    % 随机出相同怪物id后,坐标按怪物信息字段的坐标顺序循环生成
-define(DUN_RAND_TYPE_SEQUENCE, 3).         % 按顺序刷出怪物,按配置怪物列表顺序循环生成怪物数量
-define(DUN_RAND_TYPE_GROUP, 10).           % 随机出相同组的怪物

%% ----------------------- 刷新类型 -----------------------
-define(DUN_WAVE_CREATE_TYPE_CYCLE, 0).             % 循环刷新
-define(DUN_WAVE_CREATE_TYPE_MON_DIE, 1).           % 怪物死亡刷新
-define(DUN_WAVE_CREATE_TYPE_MAX_CYCLE_GAP, 2).     % 死亡和循环混合时间(最大刷新是循环时间,死亡间隔和循环时间一起使用,最大的刷新时间是循环间隔)
-define(DUN_WAVE_CREATE_TYPE_RAND, 3).              % 子类型不放回随机

%% 副本怪物波数配置数据
-record(dungeon_wave, {
        dun_id = 0                      % 副本id
        , scene_id = 0                  % 场景id
        , type = 0                      % 波数类型
        , subtype = 0                   % 波数子类型
        , rand_num = []                 % 随机数量 <br>[{Num, Weight, Type},...] | [] Weight:权重,Num:数量,<br>Type:<br>0普通随机怪物(使用怪物信息字段);<br>1随机出相同怪物(使用怪物信息字段);<br>2:随机出相同怪物id后,坐标按怪物信息字段的坐标顺序循环生成(使用怪物信息字段);<br>3:按顺序刷出怪物,按配置怪物列表顺序循环生成怪物数量(使用怪物信息字段);<br>10:根据权重随机出组怪物信息字段的怪物(使用组怪物信息字段)。<br>为空全部生成怪物信息字段的怪物,不会生成组怪物等字段的怪物
        , mon_list = []                 % 怪物信息 [{MonId, X, Y, Weight, AttrList},...] Weight:权重,MonId:怪物id,[X,Y]:坐标,AttrList:属性列表(默认填[])
        , group_mon_list = []           % 组怪物信息##[{GroupWeight(组权重), [{MonId, X, Y, MonWeight, AttrList},...]},...] MonWeight:权重,怪物MonId:怪物id,[X,Y]:坐标,AttrList:属性列表(默认填[])
        , xy_range = []                 % 坐标波动 [XRange, YRange] | [] XRange:X坐标波动,YRange:Y坐标波动;[]:不波动
        , refresh_time = 0              % 刷怪时间(毫秒)
        , create_type = 0               % 生成怪物类型
        , cycle_num = 0                 % 循环次数
        , cycle_gap = 0                 % 循环间隔
        , die_gap = 0                   % 死亡间隔
        , msg_time = 0                  % 消息推送时间(毫秒)
        , msg_stay_time = 0             % 消息停留时间(毫秒)
        , msg = ""                      % 消息
    }).

%% 副本评分配置
-record(dungeon_grade, {
        dun_id = 0              % 副本id
        , grade = 0             % 等级
        , min_score = 0         % 最小分数
        , max_score = 0         % 最大分数
        , draw_list = []        % 抽奖列表    eg:  [{列表id, 抽奖次数}]
        % 如果draw_list 为 [] 则 奖励列表##[{Type, GoodsTypeId, Num}(奖励列表)|{Type, GoodsTypeId, [MinNum, MaxNum]}(随机数量的奖励列表)],
        % 如果draw_list不为 [],   则 reward =   [{列表id, 奖池列表}]    奖池列表: [{{Type, GoodId, Num}, 权重}]
        , reward = []
        , tv_goods_list = []    % 需要传闻的物品id
    }).

-record (dungeon_dynamic_grade, {
        dun_id = 0
        , grade = 0
        , min_lv = 0
        , max_lv = 0
        , reward = []
        , reward2 = []
    }).

%% 副本加分配置
-record(dungeon_score, {
        dun_id = 0                  % 副本id
        , same_guild_score = 0      % 同公会加分
        , friend_score = 0          % 好友加分
        , intimacy_score_list = []  % 亲密度加分##[{最小亲密度等级,最大亲密度等级,加分}]
        , time_score_list = []      % 时间加分##[{耗时开始时间,耗时结束时间,加分}]
        , mon_score_list = []       % 怪物加分##[{怪物id,加分}]
    }).

%% 副本关卡加分配置
-record(dungeon_level_score, {
        dun_id = 0                  % 副本id
        , min_time_ratio = 0        % 时间比例上限##百分比
        , max_time_ratio = 0        % 时间比例下限##百分比
        , score = 0                 % 分数
        , base_score = 0            % 基础值
    }).

-record (dungeon_level_grade, {
    dun_id,
    level,
    score_min,
    score_max,
    grade,
    rewards
    }).

%% 副本关卡配置
-record(dungeon_level, {
        dun_id = 0                  % 副本id
        , scene_id = 0              % 副本场景id
        , serial_no = 0             % 序号
        , name = ""                 % 名字
        , desc = ""                 % 描述
        , time = 0                  % 时间
        , wave_num = 0              % 副本波数
        , mon_event = []            % 刷怪事件 [ {事件编号ID1, 波数类型1, 参数列表, [{触发元素1},{触发元素2},...}]}, {事件编号ID2, 波数类型2, 参数列表, [{触发元素3},{触发元素4},...}]},...]
        , story_event = []          % 剧情事件 [ {事件编号ID1, [剧情配置ID1, 剧情子类型], [{触发元素1},{触发元素2},...}]}, {事件编号ID2, [剧情ID配置2, 剧情子类型], [{触发元素3},{触发元素4},...}]},...]
        , zone_event = []           % 区域事件 [ {事件编号ID1, {[{区域配置ID1, 切换状态(0可行走 1障碍区, 5安全区)},...], [{特效编号ID1, 特效修改(0删除,1增加)},..]}, [{触发元素1},{触发元素2},...}]}, {事件编号ID2, [[{区域配置ID2, 切换状态(0可行走 1障碍区, 5安全区)},...], [{特效编号ID2, 特效修改(0删除,1增加)},..]], [{触发元素3},{触发元素4},...}]},...]
        , scene_event = []          % 场景事件 [ {事件编号ID1, 参数列表, [{触发元素1},{触发元素2},...}]}, {事件编号ID2, 场景id, 参数列表, [{触发元素3},{触发元素4},...}]} }] },...]
        , success_event = []        % 通关事件 [ {类型(0:直接结算,1:只推送结算信息), 参数列表, [{触发元素1},{触发元素2},...}]}, {类型, 参数列表, [{触发元素3},{触发元素4},...}]},...]
        , fail_event = []           % 失败事件 [ {类型(0:直接结算,1:只推送结算信息), 参数列表, [{触发元素1},{触发元素2},...}]}, {类型, 参数列表, [{触发元素3},{触发元素4},...}]},...]
    }).

% %% 副本技能配置(数据库结构)
% -record(dungeon_skill_cfg, {
%         mon_id = 0              % 怪物id
%         , skill_id = 0          % 技能id
%     }).

%% 副本清理配置
-record(dungeon_clear_cfg, {
        dun_id = 0              % 副本id
        , scene_id = 0          % 场景id(场景id在某些副本意味着是玩法)
        , wave_list = []        % 对应波数,[{波数类型, 波数子类型}]
        , clear_mon_list = []   % 清理的怪物列表,[MonId,...]
    }).

-record (dungeon_killeff_cfg, {
     dun_type
    ,title_id
    ,kill_count
    ,is_serial
    ,skill_id
    ,skill_lv
    ,skill_way
    }).

%% -----------------------------------------------------------------
%% 事件定义
%% -----------------------------------------------------------------

%% ----------------------- 是否允许触发 -----------------------
-define(DUN_ALLOW_TYPE_NO, 0).          % 不允许触发
-define(DUN_ALLOW_TYPE_YES, 1).         % 允许触发

%% ----------------------- 是否触发 -----------------------
-define(DUN_EVENT_TRIGGER_NO, 0).       % 否
-define(DUN_EVENT_TRIGGER_YES, 1).      % 是

%% ----------------------- 副本结束类型 -----------------------

-define(DUN_RESULT_TYPE_NO, 0).         % 没有结算
-define(DUN_RESULT_TYPE_SUCCESS, 1).    % 挑战成功
-define(DUN_RESULT_TYPE_FAIL, 2).       % 挑战失败

% 子类型
-define(DUN_RESULT_SUBTYPE_NO, 0).                  % 无
-define(DUN_RESULT_SUBTYPE_TIMEOUT, 1).             % 副本超时
-define(DUN_RESULT_SUBTYPE_DELAY_LOGOUT, 2).        % 玩家延迟登出
-define(DUN_RESULT_SUBTYPE_SKIP_DUNGEON, 3).        % 跳过副本
-define(DUN_RESULT_SUBTYPE_ACTIVE_QUIT, 4).         % 副本主动退出
-define(DUN_RESULT_SUBTYPE_LOGOUT, 5).              % 玩家登出
-define(DUN_RESULT_SUBTYPE_PASSIVE_FORCE_QUIT, 6).  % 被动强制退出
-define(DUN_RESULT_SUBTYPE_PASSIVE_FLOW_QUIT, 7).   % 被动流程退出

%% ----------------------- 回调类型 -----------------------
-define(DUN_CALLBACK_TYPE_NORAML, 0).   % 正常执行
-define(DUN_CALLBACK_TYPE_RESULT, 1).   % 触发结算(接下来所有的事件都不执行)

%% ----------------------- 事件归属 -----------------------
-define(DUN_EVENT_BELONG_TYPE_MON, 1).      % 刷怪事件
-define(DUN_EVENT_BELONG_TYPE_STORY, 2).    % 剧情事件
-define(DUN_EVENT_BELONG_TYPE_ZONE, 3).     % 区域事件
-define(DUN_EVENT_BELONG_TYPE_SCENE, 4).    % 场景事件
-define(DUN_EVENT_BELONG_TYPE_RESULT, 5).   % 结果事件




%% 通用事件 scene_id,id
%% ?DUN_EVENT_BELONG_TYPE_MON:使用 args,wave_type,mon_list,create_time_list,create_ref,allow_type
%% ?DUN_EVENT_BELONG_TYPE_STORY:使用 story_data,allow_type
%% ?DUN_EVENT_BELONG_TYPE_ZONE:使用 zone_id,zone_type
%% ?DUN_EVENT_BELONG_TYPE_SCENE:使用 args,allow_type
%% ?DUN_EVENT_BELONG_TYPE_RESULT:使用 args,result_type,settlement_type,allow_type
-record(dungeon_common_event, {
        id = 0                          % 事件编号ID
        , scene_id = 0                  % 事件场景ID
        , belong_type = 0               % 归属
        , event_list = []               % 触发元素列表 [#dungeon_event{}]
        , args = []                     % 参数列表
        , story_data = []               % 剧情数据. [StoryId, SubStoryId]
        , zone_data = {}                % 区域数据. { [{区域配置ID1, 切换状态(0可行走 1障碍区, 5安全区)},..], [{特效配置ID1, 特效修改(0删除,1增加)},...] }
        , result_type = 0               % 结果
        , settlement_type = 0           % 结算类型
        , wave_type = 0                 % 波数类型
        , wave_subtype_map = #{}        % 子波数Map. Key:子类型 Value:#dungeon_wave_subtype{}
        % 动态
        , result_subtype = 0            % 结果
        , create_ref = none             % 产怪定时器
        , allow_type = ?DUN_ALLOW_TYPE_YES  % 是否允许再次触发
        , first_time = 0                % 首次触发时间##目前只有一次触发,等改规则需要处理这个首次触发时间的记录.
    }).

%% 子波数刷出记录
-record(dungeon_wave_subtype, {
        subtype = 0                     % 波数子类型
        , type = 0                      % 波数类型
        , mon_map = #{}                 % 怪物Map. Key:循环次数 Value: #dungeon_wave_mon{}
        , cycle_num = 0                 % 循环次数
        , create_time = 0               % 第一次产怪时间戳(毫秒)
    }).

%% 副本波数怪物
-record(dungeon_wave_mon, {
        cycle_id = 0                    % 循环id
        , mon_list = []                 % 怪物列表 [{MonKey, MonId, IsDie}], MonKey:{mon_event, CommonEventId, WaveSubtype, CycleId, MonAutoId}
        , refresh_time = 0              % 怪物刷新时间
        , die_time = 0                  % 全部死亡时间(毫秒)
    }).

%% 触发元素
-record(dungeon_event, {
        id = 0                          % 触发元素ID
        , type = undefined              % 事件
        , args = undefined              % 参数(计算值,不是配置)   %% story_start_time  副本剧情开始时间
        , is_trigger = 0                % 是否触发
    }).


-define(STORY_FINISH,     1).     %% 副本剧情完成
-define(STORY_NOT_FINISH, 0).     %% 副本未完成

%% 剧情播放记录
-record(story_player_record, {
        is_end = ?STORY_NOT_FINISH                     %% 是否完成剧情
        ,ref    = []                                   %% 剧情完成定时器
        ,start_time = 0                                %% 剧情开始时间  毫秒级别
}).

%% -----------------------------------------------------------------
%% 副本通用的宏定义
%% -----------------------------------------------------------------

-define(CREATE_ROLE_DUN, 1011).         % 新人副本
-define(CREATE_ROLE_DUN_SCENE, 1011).   % 新人副本场景

-define(DUN_DEF_GROUP, 99).             % 默认分组

%% 副本partner
-record(dungeon_partner, {
        auto_id = 0                     % 生成怪物的唯一id.死亡和切换伙伴组会重置
        , id = 0                        % 伙伴唯一id
        , partner_id = 0                % 伙伴id
        , pos = 0                       % 上阵位置
        , hp = 0                        % 血量
        , hp_lim = 0                    % 血量上限
        , partner = undefined           % #partner{}
    }).

%% 副本中玩家的关系
-record(dungeon_role_rela, {
        id = 0                          % 玩家id
        , rela_type = 0                 % 好友关系 见 relationship.hrl
        , intimacy = 0                  % 亲密度
        , is_ask_add = 0                % 是否请求加好友(0:无;1:是)
        , is_invite_guild = 0           % 是否邀请他进入公会(0:无;1:是)
    }).

%% ----------------------- 在线情况( #dungeon_role.online ) -----------------------
-define(DUN_ONLINE_NO,              0).         % 不在线
-define(DUN_ONLINE_YES,             1).         % 在线
-define(DUN_ONLINE_DELAY,           2).         % 延迟登出状态

%% ----------------------- 是否副本结束退出( #dungeon_role.is_end_out ) -----------------------
-define(DUN_IS_END_OUT_NO,          0).         % 没有副本结束退出
-define(DUN_IS_END_OUT_YES,         1).         % 是副本结束退出

%% ----------------------- 是否领取了奖励( #dungeon_role.is_reward ) -----------------------
-define(DUN_IS_REWARD_NO,           0).         % 没有领取奖励
-define(DUN_IS_REWARD_YES,          1).         % 已经领取奖励
-define(DUN_IS_REWARD_CANNOT,       2).         % 不能领取奖励

%% 副本玩家的关卡信息
-record(dungeon_role_level, {
        level = 0                       % 关卡
        , is_reward = ?DUN_IS_REWARD_NO % 是否领取奖励
        , reward_list = []              % 奖励
    }).

%% 副本玩家信息
-record(dungeon_role, {
        id = 0                          % 玩家id
        , node = undefined              % 玩家节点
        , server_num = 0                % 玩家服务器num
        , server_id = 0                 % 玩家服务器id
        , figure = undefined            % figure
        , combat_power = 0              % 战力
        , hp = 0                        % 玩家血量(玩家死亡,复活,登出)
        , hp_lim = 0                    % 玩家血量上限
        , pid = 0                       % 玩家服务进程
        , online = ?DUN_ONLINE_YES      % 在线情况
        % , delay_logout_time = 0         % 延迟登出的时间
        % , delay_logout_ref = none       % 延迟登出定时器
        , scene = 0                     % 原场景id
        , scene_pool_id = 0             % 原场景进程id
        , copy_id = 0                   % 原CopyId
        , x = 0                         % 原x坐标
        , y = 0                         % 原y坐标
        , team_id = 0                   % 玩家所在的队伍
        , team_position = 0             % 队伍位置
        , dead_time = 0                 % 死亡时间(复活重置为0)
        , revive_count = 0              % 复活的次数
        , revive_ref = []               % 复活定时器
        , help_type = 0                 % 助战类型(0:无;1:助战)
%%        , help_count = 0                % 助战次数
        % , partner_battle_type = 0       % 伙伴战斗类型
        % , partner_group = 0             % 伙伴组(1:一组 2:二组)
        % , partner_choice_time = 0       % 上次选择的时间
        % , partner_map = #{}             % 伙伴列表 Key:GroupId Value:PartnerList
        , is_end_out = 0                % 是否副本结束领取奖励后退出
        , is_reward = 0                 % 是否领取了奖励
        , drop_list = []                % 掉落列表 未捡起
        , drop_reward_list = []         % 掉落奖励列表,掉落获得的奖励列表
        , calc_reward_list = []         % 计算好的奖励列表 结算奖励
        , reward_map       = #{}        % 奖励来源 #{来源 => 奖励}  奖励 eg:[{GoodType, GoodId, Num, AutoId}]
        , level_list = []               % 关卡列表 [#dungeon_role_level{},...]
        , rela_list = []                % 关系列表
        , drop_times_args = []          % 结算倍数
        , is_first_reward = 0           % 是否有首次奖励
        , data_before_enter = #{}       % #status_dungeon{}的数据,可重连副本使用
        , is_push_settle = ?DUNGEON_PUSH_SETTLE_NO %%  是否已经推送结算， 避免重复推送
        , typical_data = #{}            % 与副本类型相关的数据，由各个副本类型相关逻辑自行处理
        , reward_ratio = 0              % 奖励加成
        , is_push_settle_in_ps = ?DUNGEON_FORCE_PUSH_SETTLE_NO  %%是否在玩家进程中推送奖励
        , quick_count = 0               % 加速次数
        , skill_list = []               % 临时技能列表 [{skill_id, num::可使用次数}] 注:默认skill_lv为1
        , pass_time_list = []           % 波数最佳通过时间[{Wave,Time(秒)}] 注:特定波数才需要记录
        , history_wave = 0              % 历史最高波数##进入时的最高波数,本次副本不会修改
        , location     = 0              % 队伍中的位置
        , setting_list = []             % 设置列表##[#dungeon_setting{}]
        , count = 1                     % 进入消耗次数##注意这个要同步好,默认一次
        , setting = #{}                 % 设置
        , portal_id = 0                 % 传送门Id
        , auto_lv = 0                   % 动态生成怪物等级
        , weekly_card_status = undefined % 周卡状态
    }).

%% 副本场景辅助信息
-record(dungeon_scene_helper, {
        hp_rate_list = []               % 血量比例,只触发一次就抛弃
    }).

%% 怪物辅助信息
-record(dungeon_mon_helper, {
        hp_rate_map = #{}               % 血量比例,只触发一次就抛弃
    }).

%% 关卡结果
-record(dungeon_level_result, {
        level = 0                       % 关卡
        , scene_id = 0                  % 场景id
        , start_time = 0                % 开始时间
        , end_time = 0                  % 结束时间
        , result_time = 0               % 结果时间
        , result_type = 0               % 结果
        , is_level_end = 0              % 是否已经结算
    }).

%% ----------------------- 副本是否结束 -----------------------
-define(DUN_IS_END_NO,           0).         % 没有结束
-define(DUN_IS_END_YES,          1).         % 已经结束

%% ----------------------- 副本关卡是否结束 -----------------------
-define(DUN_IS_LEVEL_END_NO,     0).         % 没有结束
-define(DUN_IS_LEVEL_END_YES,    1).         % 已经结束

%% 副本进程状态数
-record(dungeon_state, {
        dun_id = 0                      % 副本id
        , dun_type = 0                  % 副本类型
        , level_change_type = 0         % 副本关卡切换
        , begin_scene_id = 0            % 第一次进来的场景id
        , now_scene_id = 0              % 当前场景id
        , scene_list = []               % 场景id列表
        , scene_pool_id = 0             % 场景进程id
        , open_scene_list = []          % 开启过的场景id列表 目前只用在副本关闭后清理场景用
        , team_id = 0                   % 队伍id##TODO(还没做):如果大于0是组队副本,等于0是其他,队伍id只能去取玩家身上的队伍id
        , enter_lv = 0                  % 进入时的等级(用于生怪:单人副本就取自己;组队就取队长)
        , start_time = 0                % 副本开始时间
        , start_time_ms = 0             % 副本开始时间(毫秒)
        , end_time = 0                  % 结束时间戳
        , role_list = []                % 角色列表 [#dungeon_role{}]
        % 波数
        , wave_num = 0                  % 波数
        , wave_start_time = 0           % 波数开始时间##根据wave_no来设置和取消波数
        , wave_end_time = 0             % 波数结束时间
        , wave_close_ref = none         % 波数结束定时器
        % 事件
        , mon_auto_id = 1               % 怪物的自增id
        , common_event_map = #{}        % 通用事件 Key:{BelongType, CommonEventId} Value:事件
        , group_map = #{}               % 分类 {SceneId, EventTypeId} => [{BelongType, CommonEventId, EventId},...] 列表
        , scene_helper = #dungeon_scene_helper{}    % 副本场景辅助信息
        , mon_helper = #dungeon_mon_helper{}        % 怪物辅助信息
        , time_list = []                % 时间列表.以该事件为当前时间,防止定时器提前或者延后执行导致时间不对应
        , ref = none                    % 定时器(检查事件)
        , close_ref = none              % 结束定时器
        , callback_type = 0             % 回调类型(事件处理完要清理):所有触发事件触发都要判断该字段
        , callback_args = undefined     % 回调参数
        , is_end = 0                    % 是否结束副本(结束副本后不做任何处理)
        , result_type = 0               % 结束类型
        , result_subtype = 0            % 结束子类型
        , result_time = 0               % 结束时间
        , force_quit_ref = 0            % 强制被动退出定时器
        , flow_quit_ref = 0             % 流程被动退出定时器
        , owner_id = 0                  % 副本创建者Id。默认为创建时role_list第一个
        , mon_score = 0                 % 怪物加分
        % 关卡
        , level = 0                     % 关卡
        , level_result_list = []        % 关卡结果列表
        , level_close_ref = none        % 关卡结束定时器
        , level_change_ref = none       % 关卡切换定时器
        , level_start_time = 0          % 关卡的开始时间
        , level_end_time = 0            % 关卡的结束时间
        , is_level_end = 0              % 是否关卡结束
        % 离线客户端数据存储
        , story_map = #{}               % 剧情列表##最多1000条防止客户端乱发,K:{StoryId, SubStoryId}    {V,  Ref}   V:IsEnd, IsEnd:是否结束(0:没有结束;1:结束), 播放剧情超时定时器
        , xy_map = #{}                  % 坐标Map##K:SceneId V:[{X, Y},...]
        % 场景数据处理
        , revive_map = #{}              % 场景复活点 K:SceneId V:{X,Y}
        , transfer_point_map = #{}      % 传送点 K:{SceneId, X, Y}, V:{TargetSceneId, TargetX, TargetY}
        , typical_data = #{}            % 副本类型相关数据 在各自类型模块的文件里定义和说明
        , next_wave_time = []           % 下一波的触发时间[WaveNum, Time]
        , rand_mon_map = #{}            % 不放回的随机列表
        , quick_count = 0               % 加速的次数
        , last_quick_time = 0           % 上次加速的时间戳
        , finish_wave_list = []         % 整波怪物全部被杀死的波数列表
        % 其他
        , load_status = ?DUN_HAD_LOAD   % 副本是否已经加载
        , load_time = 0                 % 副本加载时间戳
        , load_ref = []                 % 定时加载定时定时器
        , load_args = undefined         % 副本加载参数
        , dummy_args_list = []          % 创建假人参数，用于延迟加载
        , story_play_time_mi = 0        % 剧情播放总时长， 毫米级别
        , wave_mon_map = #{}            % 记录每波生成怪物以及击杀的怪物 #{wave => {SumMon, DeadMon}} 用于重连副本
    }).

%% 副本退出记录[副本结算可以塞一些东西进去,传给玩家处理]
-record(dungeon_out, {
        scene = 0                       % 原场景id
        , scene_pool_id = 0             % 原场景进程id
        , copy_id = 0                   % 原CopyId
        , x = 0                         % 原x坐标
        , y = 0                         % 原y坐标
        , is_again = 0                  % 是否重新使用退出记录,用于断线重连(0:无 1:是)
    }).

%% 玩家进程的副本信息
%% 注意：增加字段时，看看进入副本和离开副本，是否需要重新赋值
-record(status_dungeon, {
        dun_id = 0                      % 副本id
        , dun_type = 0                  % 副本类型
        , is_end = 0                    % 副本结束
        , dead_time = 0                 % 死亡时间(复活重置为0)
        , revive_count = 0              % 复活的次数
        , revive_map = #{}              % 复活Map
        , out = #dungeon_out{}          % 退出记录
        , help_type = 0                 % 当前副本的助战状态
        , data_before_enter = #{}       % 一些进入前的数据. #{lv_before => Lv, exp_before => Exp}
        , count = 1                     % 副本次数##默认一次
        % 玩家数据
        , wave_map = #{}                % Key:DunId, Value:#role_dungeon_wave{}
        % 副本设置
        , setting_map = #{}         % 副本设置 #{dun_id|dun_type => [#dungeon_setting{}]}
    }).

%% 副本管理记录.
-record(dungeon_record, {
        role_id = 0                     % 角色id
        , dun_pid = 0                   % 副本进程pid
        , dun_id = 0                    % 副本id
        , end_time = 0                  % 结束时间
    }).

%% 副本技能状态
-record(status_dungeon_skill, {
        skill_list = []                 % 技能列表
        , skill_attr = []               % 属性列表
        , skill_power = 0               % 战力
        , passive_skill_list = []       % 被动技能列表
        , passive_share_skill_list = [] % 被动分享技能列表
    }).

%% 副本信息 61020用
-record (dungeon_info, {
    id,                                 % 副本id
    daily_count,                        % 每日次数
    weekly_count,                       % 每周次数
    permanent_count,                    % 终身次数
    reset_count = 0,                    % 重置次数
    buy_count = 0,                      % 购买次数
    add_count = 0,                      % 增加次数
    success_count = 0,                  % 通关次数
    is_rec = 0,                         % 是否有记录
    data = [],                          %
    is_first_challenge = 0
    }).

%% -----------------------------------------------------------------
%% 副本设置
%% -----------------------------------------------------------------

% 副本设置
-define(DUNGEON_SETTING_TYPE_MERGE, 1).             % 合并次数
-define(DUNGEON_SETTING_TYPE_ENCOURAGE_GOLD, 2).    % 元宝鼓舞次数
-define(DUNGEON_SETTING_TYPE_EXP_GOODS, 3).         % 药水使用
-define(DUNGEON_SETTING_TYPE_ENCOURAGE_COIN, 4).    % 铜币鼓舞次数

%% 副本设置
-record(dungeon_setting, {
        dun_key = 0                     % 副本key##副本id或副本类型
        , type = 0                      % 设置类型
        , select_type = 0               % 选择类型
        , is_open = 0                   % 开启
        , count = 0                     % 次数
        , other_data = []               % 其他参数##一定要备注好
    }).

%% 副本设置
-record(base_dungeon_setting, {
        dun_key = 0                     % 副本key##副本id或副本类型
        , type = 0                      % 设置类型
        , select_type = 0               % 选择类型
        , cost = []                     % 消耗
    }).

%% ----------------------- 日志宏 -----------------------
-define(DUN_CREATE_PARTNER_POS_1, 1).   % 副本创建怪物的位置1
-define(DUN_CREATE_PARTNER_POS_2, 2).   % 副本创建怪物的位置2

%% ----------------------- 日志宏 -----------------------
-define(DUN_LOG_TYPE_NORMAL, 0).        % 无
-define(DUN_LOG_TYPE_RESULT, 1).        % 结算
-define(DUN_LOG_TYPE_HALFWAY_QUIT, 2).  % 中途退出
-define(DUN_LOG_TYPE_QUIT, 3).          % 退出操作
-define(DUN_LOG_TYPE_ROLE_OUT, 4).      % 玩家离开
-define(DUN_LOG_TYPE_AGAIN_OUT, 5).     % 再进入副本操作
-define(DUN_LOG_TYPE_ENTER, 6).         % 进入副本

%% -----------------------------------------------------------------
%% 成长试炼
%% -----------------------------------------------------------------

%% 成长试炼配置
-record(dungeon_grow, {
        dun_id = 0              % 副本id
        , sort_id = 0           % 排序id
        , mon_id = 0            % 怪物id
        , reward = []           % 奖励列表
    }).

%% -----------------------------------------------------------------
%% data_dungeon_special:get(DunId, Data) 格式说明
%% -----------------------------------------------------------------

%% encourage_data : {鼓舞的技能id,钻石次数,铜币次数,元宝消耗,铜币消耗}技能效果为叠加类型
%% mon_all_die_result : {怪物事件1,秒数,被替换的怪物id,替换的怪物id}
%% is_auto_buy_sweep : 是否自动购买扫荡(0:否 1:是)
%% score_replace_mon : [{积分,被替换的怪物id,替换的怪物id}]

%% base_level
%% data_dungeon_special:get(DunId, Data) 格式说明

%% -----------------------------------------------------------------
%% 异兽入侵
%% -----------------------------------------------------------------
-record(mon_invade_cfg, {
    lv = 0,
    day = 0,       % 开服天数
    reward = [],   % 奖励
    num = 0,       % 奖励份数
    is_repeat = 0  % 是否重复 0 不重复 1 重复
    }).


-record(dungeon_transport_msg, {
        produce = [],          %产出
        base_reward =  [],     %基础奖励
        first_reward = [],     %首次奖励
        multiple_reward = 0    %多倍奖励
        ,weekly_card_reward = [] % 周卡奖励
        ,is_push_settle = 0    %是否在玩家进程中推送奖励
        ,dun_id         = 0    %副本id
        ,dun_type       = 0    %副本类型
        ,now_scene_id   = 0    %场景id
        ,result_type    = 0    %结果类型
        ,result_subtype = 0    %结果子类型
        ,role_list      = []   %玩家列表
        ,start_time     = 0    %开始时间
        ,end_time       = 0    %结束时间
        ,result_time    = 0    %结算时间
        ,mon_score      = 0
        ,level_result_list = [] %关卡列表
        ,finish_wave_list =  [] %完成波数列表

}).

%% 副本波数辅助配置
-record(dungeon_wave_helper, {
        dun_id = 0              % 副本id
        , wave = 0              % 波数
        , scene_id = 0          % 场景id
        , xy = {0, 0}           % 坐标
        , time = 0              % 时间
        , reward = []           % 奖励
        , first_reward = []     % 首次奖励
        , stage_reward = []     % 阶段奖励
        , recommend_power = 0   % 推荐战力
}).

%% 波数
-record(role_dungeon_wave, {
        dun_id = 0                      % 副本id
        , cur_wave = 0                  % 当前波数
        , history_wave = 0              % 历史最高波数
        , get_list = []                 % 获得奖励的列表#[Wave,...]
        , pass_time_list = []           % 波数最佳通过时间[{Wave,Time(秒)}] 注:特定波数才需要记录
}).

%% 副本结束信息(传的参数过多,用record来记录)
-record(dungeon_end_info, {
        help_type = 0                   % 助战类型
        , dun_pid = 0                   % 副本pid
        , dun_id = 0                    % 副本id
        , dun_type = 0                  % 副本类型
        , team_id = 0                   % 队伍id
        , result_type = 0               % 结果类型
        , result_subtype = 0            % 结果子类型
        , battle_wave = 0               % 战斗的波数
        , finish_wave = 0               % 怪物全部被杀死的最大波数，取#dungeon_state.finish_wave_list最大值
        , reward = []                   % 奖励
        , show_tip_type = 0             % 奖励提示类型
        , is_halfway_out = 0            % 是否半途离开
        , history_wave = 0              % 历史最高波数
        , pass_time_list = []           % 波数最佳通过时间[{Wave,Time(秒)}] 注:特定波数才需要记录
        , start_time = 0                % 活动开始时间
        , is_accelerate = 0             % 是否加速0:不是1:是(目前多人副本在用)
}).

-record(partner_dun_chapter, {
        chapter  = 0                        % 章节id
        ,stage_reward = []                   % 阶段奖励  [{评分， 状态}]  0 未领取 2 已经领取
}).

%% 副本通用奖励配置
-record(base_dun_reward, {
        dun_id  = 0                         % 副本id
        , dun_type = 0                      % 副本类型
        , reward_type = 0                   % 奖励类型
        , reward_format = 0                 % 奖励格式
        , reward = []                       % 奖励
        , desc = []                         % 描述
}).

-record(dun_rune_daily_reward, {
        last_receive_time = 0              % 上一次奖励领取事件
        , update_time     = 0             % store_unreceived更新时间 注：因每日奖励改版，该字段已无用
        , store_list = []            % 未领取的层数
}).

%% ================= 限时爬塔 =========================
-define(SQL_SELECT_LIMIT_TOWER_DATA,
        <<"select `round`, `over_time`, `pass_list`, `reward_mode` from player_limit_tower where role_id = ~p">>).

%% 更新限时爬塔数据
-define(SQL_UPDATE_LIMIT_POWER_DATA,
        <<"REPLACE INTO `player_limit_tower`(`role_id`,`round`,`over_time`,`pass_list`,`reward_mode`)VALUES(~p,~p,~p,'~s',~p)">>).

%% 更新关卡大奖状态
-define(SQL_UPDATE_LIMIT_TOWER_REWARD,
        <<"update `player_limit_tower` set `reward_mode` = ~p where `role_id` = ~p">>).

%% 更新关卡通过状态
-define(SQL_UPDATE_LIMIT_TOWER_PASS_LIST,
        <<"update `player_limit_tower` set `pass_list` = ~p, `reward_mode` = ~p where `role_id` = ~p">>).


-record(base_limit_tower_round, {
        round = 0,        %% 轮次
        begin_day = 0,    %% 开始日
        over_day = 0,     %% 结束
        dup_list = [],    %% 大奖条件
        big_reward = [],  %% 具体大奖奖励
        name = ""         %% 轮次名称
}).

-record(status_limit_tower, {
        round = 0,       %% 轮次
        over_time = 0,   %% 结束时间
        reward_mode = 0, %% 大奖状态
        pass_id = []     %% 已通关的副本
}).