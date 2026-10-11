%% ---------------------------------------------------------------------------
%% @doc companion

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/4/28
%% @deprecated  伙伴(新)头文件
%% ---------------------------------------------------------------------------
-define(KV(Key), data_companion:get_value(Key)).
-define(LIMIT_LV,   ?KV(1)).
-define(LIMIT_DAY,  ?KV(2)).
-define(UPGRADE_PERCENT(Blessing), round(Blessing * (?KV(3)/100) )).
-define(MIN_STAGE_,  ?KV(4)).
-define(MIN_STAR_,   ?KV(5)).
-define(MAX_STAGE_,  ?KV(6)).
-define(MAX_STAR_,   ?KV(7)).
-define(DEFAULT_COMPANION_ID, ?KV(8)).          %% 默认(初始)伙伴ID
-define(TMPACTIVEDUNID, ?KV(9)).                %% 临时激活默认伙伴的特殊副本ID
-define(OPENFUNNEEDTASKS, ?KV(10)).             %% 功能开启所需的完成的任务列表（激活默认伙伴所需完成的任务列表）
-define(SPECIAL_COMPANION_ID, ?KV(11)).         %% 特殊激活的伙伴ID
-define(SPECIAL_COMPANION_GOLD, ?KV(12)).       %% 特殊激活的伙伴所需条件
-define(ACTIVE_STAR_, ?KV(13)).                 %% 刚刚激活伙伴的星数

% 是否临时伙伴
-define(NotTmp,     0).
-define(IsTmp,      1).

-define(C_ACTIVE,     1).
-define(DIS_C_ACTIVE, 0).

-define(IS_FIGHT,   1).
-define(NOT_FIGHT,  0).

-define(SKILL_ACTIVE,  0). %主动技能 / 辅助技能  （能释放的技能）
-define(SKILL_PASSIVE, 1). %被动技能

-define(FigureType, 10).    %% 外形id 占用坐骑位置mount.hrl，直接放到figure mount_figure,方便figure读取


%伙伴模块状态
-record(status_companion, {
     companion_list = []    %伙伴列表 [#companion_item{}|_]
    ,sum_attr       = []    %属性
    ,skill_list     = []    %技能
    ,fight_id       = 0     %出战伙伴ser
    ,is_tmp         = 0     %当前伙伴是否临时的（主线任务需求）
}).

%单个伙伴状态
-record(companion_item, {
     companion_id   = 0     %伙伴Id
    ,stage          = 0     %阶数
    ,star           = 0     %星数
    ,biography      = []    %当前伙伴传记解锁等级列表
    ,blessing       = 0     %祝福值
    ,is_fight       = 0     %是否出站
    ,train_num      = 0     %使用培养丹数量
    ,stage_attr     = []    %阶数提供的属性
    ,train_attr     = []    %培养丹提供的属性
    ,skill          = []    %技能（只有 is_fight = 1 的时候生效）
}).

% 伙伴配置
-record(base_companion, {
     id             = 0     %伙伴id
    ,name           = []    %伙伴名称
    ,figure_id      = 0     %外形id
    ,goods_id       = 0     %激活/升阶 所需物品id
    ,goods_num      = 0     %激活所需数量
    ,single_exp     = 0     %单个物品id给当前伙伴升级所提供的经验值
    ,skill_list     = []    %伙伴所有技能列表（客户端显示用）
    ,condition      = []    %当前伙伴的获取条件
    ,jump           = 0     %跳转id
    ,train_goods_id = 0     %培养所需道具id(精华id)
    ,train_attr     = []    %精华属性加成
    ,train_limit    = 0     %精华使用限制
    ,attack_skill   = 0     %普通攻击技能ID
}).

% 伙伴技能配置
-record(base_companion_skill, {
    companion_id    = 0     %伙伴Id
    ,skill_id       = 0     %技能Id
    ,skill_type     = 0     %技能类型
    ,main_skill_lv  = 0     %开启当前技能后主动技能的等级
    ,unlock_stage   = 0     %解锁条件（所需阶数）
}).

% 伙伴阶数配置
-record(base_companion_stage, {
    companion_id    = 0     %伙伴id
    ,stage          = 0     %阶数
    ,star           = 0     %星
    ,biography      = 0     %可解锁传记等级
    ,need_blessing  = 0     %所需祝福值
    ,attr           = []    %当前 {Stage， Star}所提供的属性
    ,other          = []    %其它阶数相关
}).

-define(sql_update_companion_fight, <<"update `player_companion` set `is_fight` = ~p where `role_id` = ~p and `companion_id` = ~p">>).
-define(sql_replace_companion, <<"replace into `player_companion` (`role_id`, `companion_id`, `stage`, `star`, `biography`, `blessing`, `is_fight`, `train_num`)
    values (~p, ~p, ~p, ~p, '~s', ~p, ~p, ~p)">>).

-define(sql_select_companion, <<"select `companion_id`, `stage`, `star`, `biography`, `blessing`, `is_fight`, `train_num` from `player_companion` where `role_id` = ~p">>).