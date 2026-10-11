%% ---------------------------------------------------------------------------
%% @doc task.hrl
%% @author ming_up@foxmail.com
%% @since  2016-12-03
%% @deprecated  任务相关定义
%% ---------------------------------------------------------------------------

%% 任务类型type
-define(TASK_TYPE_MAIN,         1). %% 主线任务(不能重复接)
-define(TASK_TYPE_AWAKE,        2). %% 唤醒任务(不能重复接)
-define(TASK_TYPE_TURN,         3). %% 转生任务(不能重复接)
-define(TASK_TYPE_CHAPTER,      4). %% 章节任务(不能重复接)
-define(TASK_TYPE_SIDE,         5). %% 支线任务(不能重复接)
-define(TASK_TYPE_GUILD,        6). %% 公会周任务
-define(TASK_TYPE_DAILY,        7). %% 日常支线任务(悬赏任务) 赏金任务
-define(TASK_TYPE_DAY,          8). %% 日常任务(悬赏任务)
-define(TASK_TYPE_DAILY_EUDEMONS,9). %% 日常支线任务(圣兽领任务)
-define(TASK_TYPE_SANCTUARY_KF, 10). %% 跨服圣域的阶段任务

%% 任务种类kind
-define(TASK_KIND_TALK,         0). %% 对话任务
-define(TASK_KIND_KILL,         1). %% 杀怪任务
-define(TASK_KIND_COLLECT,      2). %% 采集任务
-define(TASK_KIND_ITEM,         3). %% 收集任务
-define(TASK_KIND_ESCORT,       4). %% 护送任务
-define(TASK_KIND_ENTER_SCENE,  5). %% 探索任务
-define(TASK_KIND_DUN,          6). %% 副本任务
-define(TASK_KIND_ITEM_BACK,    7). %% 收集回收任务
-define(TASK_KIND_STREN,        8). %% 装备强化任务
-define(TASK_KIND_RUNE_DUN,     9). %% 符文副本任务
-define(TASK_KIND_EXP_DUN,     10). %% 发条密室任务

%% 任务内容类型定义，参考后台任务配置-任务内容配置
-define(TASK_CONTENT_KILL,              1).    %% 杀怪
-define(TASK_CONTENT_KILL_BOSS,         2).    %% 杀boss：具体到boss类型
-define(TASK_CONTENT_ITEM,              3).    %% 收集物品：杀怪
-define(TASK_CONTENT_COLLECT,           4).    %% 怪物采集
-define(TASK_CONTENT_TALK,              5).    %% npc对话
-define(TASK_CONTENT_START_TALK,        6).    %% 开始npc对话
-define(TASK_CONTENT_END_TALK,          7).    %% 结束npc对话
-define(TASK_CONTENT_STREN,             8).    %% 装备强化
-define(TASK_CONTENT_DUNGEON_TYPE,      9).    %% 完成某类副本
-define(TASK_CONTENT_MAIN_DUNGEON,     10).    %% 通过主线副本（数量填关卡数）
-define(TASK_CONTENT_DUNGEON,          11).    %% 某个副本
-define(TASK_CONTENT_EQUIP,            12).    %% 穿戴N件装备（数量填件数）
-define(TASK_CONTENT_ADD_FRIEND,       13).    %% 添加好友
-define(TASK_CONTENT_JOIN_GUILD,       14).    %% 加入公会
-define(TASK_CONTENT_REFINE_EQUIP,     15).    %% 精炼装备（id填+N,数量填件数）
-define(TASK_CONTENT_GUILD_ACTIVITY,   16).    %% 公会活动
-define(TASK_CONTENT_GUILD_EQ_DONATE,  17).    %% 公会装备捐献
-define(TASK_CONTENT_FUSION_EQUIP,     18).    %% 熔炼装备（数量填熔炼等级）
-define(TASK_CONTENT_BUY_FROM_TRADING, 19).    %% 从市场购买
-define(TASK_CONTENT_TRADING_PUTAWAY,  20).    %% 物品上架市场
-define(TASK_CONTENT_GOODS_COMPOSE,    21).    %% 物品合成
-define(TASK_CONTENT_FIN_TASK,         22).    %% 完成任务(id填任务id)
-define(TASK_CONTENT_TRAIN_MOUNT,      23).    %% 培养坐骑（id填阶数，数量填星数）
-define(TASK_CONTENT_TRAIN_WING,       24).    %% 培养翅膀（id填阶数，数量填星数）
-define(TASK_CONTENT_TRAIN_PARTNER,    25).    %% 培养伙伴（id填阶数，数量填星数）
-define(TASK_CONTENT_UPGRADE_MEDAL,    26).    %% 升级勋章（数量填阶数）
-define(TASK_CONTENT_LV,               27).    %% 到达等级
-define(TASK_CONTENT_AWAKENING,        28).    %% 天命觉醒N次
-define(TASK_CONTENT_ACHV_AWARD,       29).    %% 领取成就奖励
-define(TASK_CONTENT_ACTIVE_DSG,       30).    %% 激活称号数量
-define(TASK_CONTENT_STREN_SUM,        31).    %% 全身强化数
-define(TASK_CONTENT_REFINE_SUM,       32).    %% 全身精炼数
-define(TASK_CONTENT_RUNE_NUM,         33).    %% 全身镶嵌符文数量
-define(TASK_CONTENT_EQUIP_STAGE,      34).    %% 全身装备阶数数量
-define(TASK_CONTENT_JOIN_JJC,         35).    %% 参加排位赛次数
-define(TASK_CONTENT_COMBATPOWER,      36).    %% 战力
-define(TASK_CONTENT_WELCOME,          37).    %% 进入游戏欢迎界面
-define(TASK_CONTENT_ACTIVE_MOUNT,     38).    %% 激活坐骑
-define(TASK_CONTENT_ACTIVE_WING,      39).    %% 激活翅膀
-define(TASK_CONTENT_ACTIVE_PARTNER,   40).    %% 激活伙伴
-define(TASK_CONTENT_TRAIN_HOLYORGAN,  41).    %% 培养神兵
-define(TASK_CONTENT_ACTIVE_HOLYORGAN, 42).    %% 激活神兵
-define(TASK_CONTENT_FIN_MAIN_TASK,    43).    %% 完成主线任务
-define(TASK_CONTENT_ACTIVE_DSG_ID,    44).    %% 激活某个称号(判断id)
-define(TASK_CONTENT_ONHOOK_WAVE,      45).    %% 击杀挂机波数
-define(TASK_CONTENT_UPGRADE_SKILL_STREN, 46). %% 强化技能一次
-define(TASK_CONTENT_SKILL_STREN_SUM,  47).    %% 技能强化总数
-define(TASK_CONTENT_EQUIP_STONE_SUM,  48).    %% 宝石强化总等级(数量填总等级)
-define(TASK_CONTENT_RUNE_LV,          49).    %% 符文强化达到X级N个（id填X,数量填N）
-define(TASK_CONTENT_RUNE_LV_SUM,      50).    %% 符文强化总等级（数量填总等级）
-define(TASK_CONTENT_ACHV_LV,          51).    %% 职称等级达到N级（数量填N）
-define(TASK_CONTENT_KILL_BOSS_LV,     52).    %% 击杀X等级bossN只（id填x，数量填N）
-define(TASK_CONTENT_ACTIVITY_LV,      53).    %% 活跃度
-define(TASK_CONTENT_AWARD_LV_GIFT,    54).    %% 领取一次等级礼包
-define(TASK_CONTENT_AWARD_ETERNAL_VALLEY, 55).%% 领取一次头契约之书奖励
-define(TASK_CONTENT_FIN_RUNE_HURT,    56).    %% 完成符文寻宝
-define(TASK_CONTENT_DUNGEON_LEVEL,    57).    %% 副本关卡
-define(TASK_CONTENT_ACTIVITY_ACC,     58).    %% 活跃度累计
-define(TASK_CONTENT_FIN_GLAD,         59).    %% 完成一次决斗场
-define(TASK_CONTENT_EQUIP_COLOR,      60).    %% 穿戴N件*色以上装备（id填颜色类型）
-define(TASK_CONTENT_COST_STUFF,       61).    %% 消耗材料
-define(TASK_CONTENT_KILL_LV,          62).    %% 击杀某个等级的普通怪物
-define(TASK_CONTENT_KILL_BOSS_ID,     63).    %% 击败bossN次(id填怪物id)
-define(TASK_CONTENT_AWARD_7DAY,       64).    %% 领取七日奖励
-define(TASK_CONTENT_AWARD_DAILY,      65).    %% 领取每日签到奖励
-define(TASK_CONTENT_FIN_TASK_DAILY,   66).    %% 完成赏金任务N次
-define(TASK_CONTENT_OUTSIDE_KILL_V,   67).    %% 击杀野外场景某个等级（包含）及以上的普通怪物（id填等级）
-define(TASK_CONTENT_FIN_TASK_GUILD,   68).    %% 完成公会周任务N次
-define(TASK_CONTENT_FIN_HUSONG,       69).    %% 完成n次护送任务
-define(TASK_CONTENT_KILL_VIP_BOSS,    70).    %% 挑战n次专属boss
-define(TASK_CONTENT_KILL_SANCTUARY_BOSS,  71).%% 参与击败n次圣域boss
-define(TASK_CONTENT_SEAL_SET_NUM,     72).    %% 镶嵌n个圣印
-define(TASK_CONTENT_RAD_EQUIP_COMBINE,73).    %% 红装合成N次
-define(TASK_CONTENT_ACTIVE_RAD_SUIT,  74).    %% 激活N件红装加成
-define(TASK_CONTENT_ACTIVE_SUIT,      75).    %% 激活N件套装加成
-define(TASK_CONTENT_ACTIVE_GOD,       76).    %% 激活降神
-define(TASK_CONTENT_ACTIVE_DUN_EXP,   77).    %% 单次经验本达到XX经验
-define(TASK_CONTENT_ACTIVE_JJC_RANK,  78).    %% 竞技场挑战达到前XXX名
-define(TASK_CONTENT_LOGIN_DAY,        79).    %% 累计登录天数
-define(TASK_CONTENT_COIN,             80).    %% 金币
-define(TASK_CONTENT_OPEN_FUNCTION,    81).    %% 开启指定模块功能的任务
-define(TASK_CONTENT_COST_GOODS,       82).    %% 扣除物品
-define(TASK_CONTENT_FAKE_CLIENT,      83).    %% 托管次数
-define(TASK_CONTENT_SUIT_CLT,         84).    %% 套装收集
-define(TASK_CONTENT_ENTER_SANCTUM,    85).    %% 进入永恒圣殿N次
-define(TASK_CONTENT_ENTER_DRANLAN,    86).    %% 进入龙语BOssN次
-define(TASK_CONTENT_CHRONO_VALUE,     87).    %% 时空圣痕争夺值达到xx
-define(TASK_CONTENT_BOSS_ASSIST,      88).    %% 完成N次Boss协助
-define(TASK_CONTENT_ACTIVE_SOAP,      89).    %% 激活指定古宝
-define(TASK_CONTENT_MOUNT_LEVEL,      90).    %% 坐骑相关等级
-define(TASK_CONTENT_AFK_RECEIVE_TIMES,91).    %% 领取挂机收益次数
-define(TASK_CONTENT_TRAIN_ARTIFACT,   92).    %% 培养圣器/御守（id填阶数，数量填星数）
-define(TASK_CONTENT_EQUIP_ORANGE,     93).    %% 穿戴N件M阶橙色以上装备（id填阶数， 数量填件数）
-define(TASK_CONTENT_EXCG_GUILD_DEPOT, 94).    %% 公会仓库兑换
-define(TASK_CONTENT_ITEM2,            95).    %% 收集物品,物品减少不影响进度
-define(TASK_CONTENT_KF_SANCTUARY_PERSON_SCORE, 96). %% 接到任务后个人积分增加N
-define(TASK_CONTENT_KILL_KF_SANCTUARY_PLAYER,  97). %% 击杀N名跨服玩家


-define(AWAKENING_TASK_TASK_GOODS, #{}).%#{16 => 38110007, 17 => 38110008, 19 => 38110009, 21 => 38110010}).   %% 天命觉醒任务掉落物品

-define(EXTRA_REWARD_COUNT, 10).

-record(task_args, {
    id=0,                       %% 玩家id
    scene = 0,                  %% 场景id
    last_task_id = 0,           %% 玩家当前最后一个主线任务id
    sid=undefined,              %% 玩家广播进程
    figure=undefined,           %% 基本形象参数
    npc_info=[],                %% 玩家npc信息
    coin=0,                     %% 金币数量
    login_days=0,               %% 累计登录天数
    gs_dict = undefined,        %% 物品数据
    stren_award_list = [],      %% 强化列表
    refine_award_list = [],     %% 精炼列表
    stage_award_list = [],      %% 装备阶数列表
    equip_info = [],            %% 装备情况[{Color, Stage, Star}]
    train_star_list = [],       %% 培养系统星数
    medal_lv = 0,               %% 勋章等级
    fusion_lv = 0,              %% 熔炼等级
    chapter = 0,                %% 主线副本关卡数
    dsg_num = 0,                %% 称号数量
    dsg_map = #{},              %% 称号
    combat_power = 0,           %% 战力
    skill_stren_sum = 0,        %% 技能强化等级总数
    jjc_daily_num = 0,          %% 排位赛每日进入次数
    achv_fin_num = 0,           %% 完成成就数量
    achv_ids = [],              %% 完成成就ids
    activity_lv = 0,            %% 活跃度等级
    activity_liveness = 0,      %% 当前活跃度
    stone_award_list = [],      %% 宝石等级列表
    color_award_list = [],      %% 装备颜色数量列表
    rune_num = 0,               %% 镶嵌符文数量
    rune_lv_list = [],          %% 镶嵌符文等级
    dun_level_map = #{},        %% 副本关卡##主键:副本类型 值:关卡数
    rush_bag_lv_list=[],        %% 冲级礼包等级列表
    re_red_equip_award_list = [], %% 红装加成数量列表
    suit_num_list=[],           %% 套装数量列表
    awakening_active_ids = [],  %% 觉醒id
    seal_equip_list = [],
    soap_map = #{},
    friend_num = 0              %%  好友数据
}).


%% ================================= 配置记录 =================================
%% 任务数据
-record(task, {
        id = 0                     %% 任务id
        ,role_id=0
        ,name = ""                 %% 任务名称
        ,desc = ""                 %% 描述
        ,class = 0                 %% 任务分类，0普通任务，1运镖任务，2帮会任务
        ,type = 0                  %% 类型(1主线，2支线，3转生，4章节限时，6公会周，7日常...)
        ,kind = 0                  %% 种类(0对话，1打怪，2采集，3收集，4护送，5探索，6副本，7采集回收(悬赏和公会任务动态采用)，8装备强化任务，9符文副本任务，10发条密室任务)
        ,level = 1                 %% 可接的最低等级
        ,level_max = 0             %% 可接的最大等级
        ,repeat = 0                %% 重复次数
        ,clear_type = 0            %% 清理类型(0不清理 1每日清理 2每周清理)
        ,realm = 0                 %% 阵营限制
        ,career = 0                %% 职业限制
        ,turn = 0                  %% 转生限制
        ,prev = 0                  %% 上一个必须完成的任务id
        ,next = 0                  %% 下一个任务id
        ,dun_id = 0                %% 副本id|采集怪物id
        ,start_item = []           %% 开始获得物品{ItemId, Number}
        ,end_item = []             %% 结束回收物品
        ,start_npc = 0             %% 开始npcid
        ,end_npc = 0               %% 结束npcid
        ,start_talk = 0            %% 开始对话
        ,end_talk = 0              %% 结束对话
        ,unfinished_talk = 0       %% 未完成对话
        ,start_guide = 0           %% 是否有接任务引导
        ,end_guide = 0             %% 是否有完成任务引导
        ,trigger_pathfind = 0      %% 是否需要寻路触发
        ,finish_pathfind = 0       %% 是否需要寻路完成
        ,condition = []            %% 条件内容 [{task, 任务id}, {item, 物品id, 物品数量}]
        ,content = []              %% 任务内容 [{#task_content.stage, #task_content.cid},...]  根据这个列表获取#task_content列表
        ,state = 0                 %% 完成任务需要的状态值 state = length(content)
        ,award_list=[]             %% 奖励列表
        ,attr_reward =[]           %% 属性奖励
        ,special_goods_list=[]     %% 特殊职业性别物品[{Career, Sex, GoodsId, Num}]=[{职业,性别,物品id,数量}]:当职业不区分的时候=0;当性别不区分的时候=0;
        ,guild_exp = 0
        ,next_cue = 0
        ,npc_show = []             %% NPC 动态信息[{任务状态(0领取,1可完成,2完成),[{NpcId,Npc状态(0不显示，1显示),场景Id,X,Y}]}]
        ,chapter = 0               %% 主线章节 主线任务才会有值
    }).

%% 内容记录
-record(task_content, {
    stage = 0,                  %% 所属阶段
    cid = 0,                    %% 该阶段内容id
    ctype = 0,                  %% 任务内容类型
    id = 0,                     %% id（怪物，物品等id）
    need_num = 0,               %% 完成任务所需数量
    desc = <<>>,                %% 任务内容文字描述
    display_num= 0,             %% 显示所需数量 (0:显示need_num 1:显示1)
    is_guide = 0,               %% 是否需要引导
    scene_id = 0,               %% 任务寻路场景id
    x = 0,                      %% 任务寻路场景x坐标
    y = 0,                      %% 任务寻路场景y坐标
    talk_id = 0,                %% 任务内容对话id
    path_find = 0,              %% 任务是否需要寻路完成
    fin = 0,                    %% 是否已经完成
    now_num = 0                 %% 当前数量
}).

%% 任务条件数据
-record(task_condition, {
        id
        ,type = 0
        ,kind = 0
        ,level = 1                  %% 可接的最低等级
        ,level_max = 0              %% 可接的最大等级
        ,repeat = 0                 %% 可否重复
        ,realm = 0                  %% 阵营
        ,career = 0                 %% 职业限制
        ,turn = 0                   %% 转生限制
        ,prev = 0                   %% 上一个必须完成的任务id
        ,condition = []             %% 扩充条件 TODO 具体描述日后再加
    }).

%% 任务类型配置
-record(task_type, {
        type = 0,
        count = 0,
        module_id = 0,
        counter_id = 0,
        finish_cost = []
    }).

%% 等级动态任务id
-record(task_lv_dynamic_id, {
        type = 0,                   %% 任务类型
        slv = 0,                  %% 开始等级
        elv = 0,                  %% 结束等级
        task_ids = []             %% 任务id,纯随机[id1,id2, ...]
    }).

%% 动态等级任务内容
-record(task_lv_dynamic_content, {
        task_id = 0,              %% 任务id
        slv = 0,                  %% 开始等级
        elv = 0,                  %% 结束等级
        start_npc = 0,            %% 开始npc
        end_npc = 0,              %% 结束npc
        scene = 0,                %% 场景id
        x = 0,                    %% X
        y = 0,                    %% Y
        content_type = 0,         %% 任务内容类型
        id = 0,                   %% id(MonId|DunId|GoodId), 怪物id|副本id|物品id
        num = 0                   %% 完成次数|采集数|收集数
    }).

%% ================================= 功能记录 =================================
%% 角色任务记录
-record(role_task, {
        role_id = 0,
        lv = 0,                     %% 接任务时候玩家的等级
        task_id = 0,
        type = 0,
        kind = 0,
        write_db = 0,               %% 是否需要写数据库
        trigger_time = 0,
        state = 0,
        end_state = 0,
        mark = []                   %% 任务记录器格式##[#task_content{}]
    }).

%% 角色任务历史记录
-record(role_task_log, {
        role_id=0,
        task_id=0,
        type = 0,
        trigger_time=0,
        finish_time=0,
        count = 1                   %% 完成的次数
    }).

%% 任务接取类型
-define(TASK_STATE_NO, 0).            %% 无
-define(TASK_STATE_TRIGGER, 1).       %% 触发
-define(TASK_STATE_FIN, 2).           %% 完成

%% =================================
%% 配置记录
%% =================================

-define(TASK_KV(Key), data_task_attach:get_value(Key)).
-define(TASK_KV_OPEN_SKILL_TASK_ID_LIST, ?TASK_KV(1)).       % 开启所有技能的任务id范围##[{StartTaskId, EndTaskId}]