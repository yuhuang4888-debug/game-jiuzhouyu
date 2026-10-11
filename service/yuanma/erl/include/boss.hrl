%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%% 本服所有boss
%%% @end
%%% Created : 27 Oct 2017 by root <root@localhost.localdomain>

-define(BOSS_TYPE_KV(BossType, Key), data_boss:get_boss_type_kv(BossType, Key)).

-define(BOSS_TYPE_KV_ADD_VIT_MAX(BossType), ?BOSS_TYPE_KV(BossType, add_vit_max)).   % 体力每日可恢复上限值
-define(BOSS_TYPE_KV_ADD_VIT_TIME(BossType), ?BOSS_TYPE_KV(BossType, add_vit_time)). % 体力恢复1点所需时间（单位秒）
-define(BOSS_TYPE_KV_BACK_VIT_MAX(BossType), ?BOSS_TYPE_KV(BossType, back_vit_max)). % 每天可找回最大体力值
-define(BOSS_TYPE_KF_BACK_VIT_COST(BossType), ?BOSS_TYPE_KV(BossType, back_vit_cost)). % 找回一点体力花费
-define(BOSS_TYPE_KV_COST_TICKET(BossType), ?BOSS_TYPE_KV(BossType, cost_ticket)).   % 进入一次boss所需门票##[{Type,GoodsTypeId,Num}]
-define(BOSS_TYPE_KV_COST_VIT(BossType), ?BOSS_TYPE_KV(BossType, cost_vit)).         % 进入一次boss所需体力
-define(BOSS_TYPE_KV_FEVER_REVIVE_RATIO(BossType), ?BOSS_TYPE_KV(BossType, fever_revive_ratio)).   % 复活时间倍率
-define(BOSS_TYPE_KV_FEVER_TIME_PRE(BossType), ?BOSS_TYPE_KV(BossType, fever_time_pre)).   % 预热时间（秒）
-define(BOSS_TYPE_KV_FEVER_TIME_RANGE(BossType), ?BOSS_TYPE_KV(BossType, fever_time_range)). % 狂欢时间段##[{{时，分}，{时，分}}]
-define(BOSS_TYPE_KV_INIT_VIT(BossType), ?BOSS_TYPE_KV(BossType, init_vit)).         % 玩家初始体力
-define(BOSS_TYPE_KV_LV_FOR_INIT_VIT(BossType), ?BOSS_TYPE_KV(BossType, lv_for_init_vit)).  % 玩家初始体力的等级
-define(BOSS_TYPE_KV_MAX_VIT(BossType), ?BOSS_TYPE_KV(BossType, max_vit)).           % 体力正常上限
-define(BOSS_TYPE_KV_MIN_EQUIP_BAG_CELL(BossType), ?BOSS_TYPE_KV(BossType, min_equip_bag_cell)).    % 装备背包最少空格
-define(BOSS_TYPE_KV_MIN_GOD_BAG_CELL(BossType), ?BOSS_TYPE_KV(BossType, min_god_bag_cell)).   % 神装背包最少空格
-define(BOSS_TYPE_KV_REVIVE_TV_LIST(BossType), ?BOSS_TYPE_KV(BossType, revive_tv_list)).       % 复活传闻提示列表##[{boss复活前多少秒,传闻id}]
-define(BOSS_TYPE_KV_END_OUT_TIME(BossType), ?BOSS_TYPE_KV(BossType, end_out_time)).  % 结束离开的时间
-define(BOSS_TYPE_KV_LOG_GOODS_LIST(BossType), ?BOSS_TYPE_KV(BossType, log_goods_list)).  % 日志物品列表
-define(BOSS_TYPE_KV_LOG_GOODS_LEN(BossType), ?BOSS_TYPE_KV(BossType, log_goods_len)).  % 日志物品列表长度
-define(BOSS_TYPE_KV_TOPLOG_GOODS_LEN(BossType), ?BOSS_TYPE_KV(BossType, top_log_goods_len)).  % 日志物品列表长度
-define(BOSS_TYPE_KV_LOG_GOODS_TOP_LIST(BossType), ?BOSS_TYPE_KV(BossType, log_goods_top_list)).  % 日志物品置顶列表
-define(BOSS_TYPE_KV_BOSS_REVIVE_CD(BossType), ?BOSS_TYPE_KV(BossType, boss_revive_cd)).  % 特殊怪物复活冷却时间
-define(BOSS_TYPE_KV_BEKILL_ANGER_ADD(BossType),?BOSS_TYPE_KV(BossType, be_kill_anger_add)). % 玩家死亡增加疲劳值
-define(BOSS_TYPE_KV_GOODS_ADD_VIT(BossType), ?BOSS_TYPE_KV(BossType, goods_add_vit_list)). % 物品使用增加体力值

%% vip_one_touch_sweep vip一键扫荡
%% vip_type_one_touch_sweep  vip专属一键扫荡

%%-------------------------------------------------
%%  BOSS系统的类型
%%-------------------------------------------------
%% (1)添加boss类型，需要在 scene.hrl 中对 #mon.mon_sys 定义，值要一一对应
%% (2)#mon.mon_sys 怪物系统类型优先级更大,有些类型不是本boss系统的,不能占用其值.
-define(BOSS_TYPE_GLOBAL,       0).     %% 全局配置##方便配置,不能配出现本类型的boss
-define(BOSS_TYPE_WORLD,        1).     %% 世界Boss(旧)
-define(BOSS_TYPE_VIP_PERSONAL, 2).     %% vip个人Boss
-define(BOSS_TYPE_HOME,         3).     %% Boss之家
-define(BOSS_TYPE_FORBIDDEN,    4).     %% 蛮荒禁地
-define(BOSS_TYPE_TEMPLE,       5).     %% 遗忘神庙
-define(BOSS_TYPE_OUTSIDE,      6).     %% 野外Boss
-define(BOSS_TYPE_ABYSS,        7).     %% 深渊Boss  --- 现在的boss之家
-define(BOSS_TYPE_PERSONAL,     8).     %% 个人boss
-define(BOSS_TYPE_FAIRYLAND,    9).     %% 秘境boss
-define(BOSS_TYPE_PHANTOM,      10).    %% 幻兽领boss
-define(BOSS_TYPE_FEAST,        11).    %% 节日boss
-define(BOSS_TYPE_NEW_OUTSIDE,  12).    %% 新野外boss/世界boss
-define(BOSS_TYPE_SPECIAL,      13).    %% 特殊boss(单人野外场景boss)
-define(BOSS_TYPE_SANCTUARY,    14).    %% 圣域boss
-define(BOSS_TYPE_DRAGON,       15).    %% 龙纹副本boss
-define(BOSS_TYPE_DOMAIN,       16).    %% 秘境领域boss
-define(BOSS_TYPE_DECORATION_BOSS, 17). %% 幻饰boss
-define(BOSS_TYPE_PHANTOM_PER,  18).    %% 幻兽领个人无限层boss(逻辑上和特殊boss差不多,但是击杀后会有经验积分)
-define(BOSS_TYPE_WORLD_PER,    19).    %% 世界boss个人无限层
-define(BOSS_TYPE_KF_GREAT_DEMON, 20).  %% 跨服秘境大妖

-define(BOSS_TYPE_KF_SANCTUARY, 99).    %% 跨服圣域boss

%%-------------------------------------------------
%%  其他
%%-------------------------------------------------

-define(FORBIDDEN_OUT_DELAY, 1).       %% 雷霆之怒倒计时类型
-define(FORBIDDEN_OUT_TIME,  2).       %% 踢出场景倒计时类型

-define(REMIND_TIME,         0).        %% 重生提醒时间
-define(REMIND,              1).        %% 是否提醒 1:提醒
-define(NO_AUTO_REMIND,      0).        %% 自动关注 0:不触发自动关注
-define(AUTO_REMIND,         1).        %% 自动关注 1:可以触发自动关注
-define(ANGER_TIME,         60).       %% 怒气值增加间隔
-define(ANGER_DELAY_TIME,   30).       %% 雷霆之怒倒计时30s
-define(ANGER_OUT_TIME,     10).       %% 倒计时10踢出场景

-define(INSPIRE_SKILL_ID, 21000002).   %% 鼓舞技能id
-define(INSPIRE_TYPE1,       1).       %% 鼓舞类型1
-define(INSPIRE_TYPE2,       2).       %% 鼓舞类型2

-define(GM_BOSSTYPE_LIST, [?BOSS_TYPE_NEW_OUTSIDE, ?BOSS_TYPE_ABYSS, ?BOSS_TYPE_FORBIDDEN, ?BOSS_TYPE_FAIRYLAND]). %% BOSS类型复活秘籍

-define(LOGOUT_BOSS_TYPE,            [?BOSS_TYPE_FEAST]).   %%登出的时候，根据boss类型特殊处理

-define(DEF_ROLE_BATTLE_GROUP, 99).    %% 玩家默认分组

-define(WLDBOSS_RANKREWARD_MAIL_TITLE,   4600001).    %世界boss排行奖励邮件
-define(WLDBOSS_RANKREWARD_MAIL_CONTENT, 4600002).
-define(WLDBOSS_KILLREWARD_MAIL_TITLE,   4600003).    %世界boss最后一击奖励邮件
-define(WLDBOSS_KILLREWARD_MAIL_CONTENT, 4600004).
-define(FAIRYLAND_MAIL_TITLE,            4600005).
-define(FAIRYLAND_MAIL_CONTENT,          4600006).
-define(FORBIDDEN_MAIL_TITLE,            4600007).
-define(FORBIDDEN_MAIL_CONTENT,          4600008).
-define(WLDBOSS_ENTER_ICON_TIME,            300).   %世界boss入口图标提前300s出现

-define(BOSS_COPY_CLOSE,                            1).  %房间关闭状态
-define(BOSS_COPY_OPEN,                             0).  %房间开启状态

%%节日boss
-define(FEAST_BOSS_MAX_COPY_ID,             30).      %% 节日boss最大房间ID 1 ~ 10
-define(FEAST_BOSS_COPY_ROLE_NUM,           50).      %% 节日boss房间容纳最大人数
-define(FEAST_BOSS_SCENE,                   data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST,  feast_boss_scene)).       %% 节日boss场景
-define(FEAST_BOSS_CRYSTAL_COORD,           data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST,  crystal_mon_coord)).      %% 水晶怪物坐标
-define(FEAST_BOSS_CRYSTAL_MON_ID,          data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST,  crystal_mon_id)).         %% 水晶怪物id
-define(feast_boss_refresh_time,            data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST,  feast_boss_reborn_time)). %% 节日boss刷新间隔（秒）
-define(SKIP_MON_DROP_RULE,                 data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE,  skip_mon_drop_rule)). %% 新野外boss不掉落道具的怪物Id
-define(USE_STAMINA_ELIXIR,                 data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE,  use_stamina_elixir)). %% 返回码需要特殊处理的秘药
-define(feast_boss_other_mon_wave_refresh_time,
    data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST,  feast_boss_other_mon_wave_refresh_time)). %%节日boss其他小怪波数刷新间隔（秒）
-define(feast_boss_other_mon_refresh_time,
    data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST,  feast_boss_other_mon_refresh_time)). %%节日boss其他小怪刷新间隔（秒）
-define(feast_boss_other_mon_num,
    data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST,  feast_boss_other_mon_num)). %%节日boss其他小怪一波小怪数量
-define(feast_boss_other_mon_list,
    data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST,  feast_boss_other_mon_list)). %%节日boss其他小怪id列表
-define(FEAST_BOSS_DIRECTION_LIST,          [1, 2, 3, 4]).   %%方位列表
-define(feast_def_scene_pool_id,             0).   %%场景进程id
-define(feast_boss_max_copy_id,              max_copy_id).    %%key    节日boss房间最大Id
-define(feast_boss_wave,                     wave).           %%key    节日boss房间当前波数
-define(feast_boss_wave_refresh_time,        feast_boss_wave_refresh_time).  %%key    节日boss下一波时间戳
-define(feast_boss_copy_start_time,          feast_boss_copy_start_time).  %%key      房间开始时间
-define(feast_boss_from,                     feast_boss_from).%%key    节日boss刷新来源
-define(feast_boss_box,                      feast_boss_box). %%key    节日boss宝箱
-define(feast_boss_role_collection,          feast_boss_role_collection). %%key    节日boss宝箱玩家搜集信息
-define(feast_boss_over_role,                feast_boss_over_role).       %%key     就是参加过活动的，但是进去后，水晶爆的玩家, 或则是击杀了最后一个boss时在房间的所有玩家
-define(feast_boss_collect_reward,           feast_boss_collect_reward).  %%key     节日boss采集奖励
-define(max_feast_boss_num,                  max_feast_boss_num).         %%key     节日boss总数量
-define(kill_feast_boss_num,                 kill_feast_boss_num).        %%key     节日boss击杀数量
-define(feast_boss_push_settle,              feast_boss_push_settle).     %%key     节日boss 是否推送结算信息
-define(feast_boss_push_settle_yes,          1).                          %%        节日boss 要推送结算信息
-define(feast_boss_push_settle_no,           0).                          %%        节日boss 不用推送结算信息

-define(feast_boss_copy_time_limit,  15).

-define(BOSS_LOG_LEN, 100).     % boss日志长度

-define(feast_boss_copy_enter_time_limit,           4 * 60).                          %%节日boss进入的时间限制 ，必须在五分钟内


-define(LV_GAP, 5).

%% 秘境领域
-define(DOMAIN_SPECIAL_BOSS,    1).  % 特殊怪
-define(DOMAIN_COLLECT_BOSS,    2).  % 宝箱
-define(DOMAIN_SP_COLLECT_BOSS, 3).  % 高级宝箱


-define(NEW_OUTSIDE_BOSS_VIP_VALUE, 4601201). %% vip特权 12类型 boss 体力值上限
-define(SPECIAL_BOSS_TASK_ID,  101200).       %% 新手boss(bosstype 13)任务id

%% 说明
%% 1、 ?BOSS_TYPE_OUTSIDE
%%   (1) 狂热时间
%%   (2) 关注/取消关注
%%   (3) 活动结束,把玩家送离开场景并且扣体力或者物品，并且走怪物掉落
%%   (4) boss死亡定时退出去
%%   (5) 伤害的血量处理

%% 2、 ?BOSS_TYPE_ABYSS
%%   (1) 狂热时间
%%   (2) 关注/取消关注
%%   (3) 活动结束,并且走怪物掉落
%%   (4) boss死亡定时退出去
%%   (5) 伤害的血量处理

%% 3、 ?BOSS_TYPE_PERSONAL
%%   (1) 走副本流程


%% boss 玩家信息
-record(status_boss, {
          reborn_ref = [],         %% 重生定时器，主要用于延迟登出，重连的处理
          check_revive_ref = undefined, %% 复活检测定时器 （主要用来检测玩家死亡是否复活，玩家切后台不会发协议复活）
          boss_map = #{}           %% Key:BossType Value:#role_boss{}
     }).

%% 玩家boss信息
-record(role_boss, {
          boss_type = 0            %% Boss类型
          , vit = 0                %% 体力值
          , vit_add_today = 0      %% 当天恢复的体力值数(因为世界boss的体力值有找回的需求,故不使用每日计数器的方案)
          , vit_can_back = 0       %% 当天可找回的体力值数(隔天登录时进行初始化设值)
          , last_vit_time = 0      %% 上次记录的体力值
          , buy_count = 0          %% 购买的次数/体力值
          , extra_count = 0        %% 使用道具增加的次数/体力值
          , stime = 0              %% 上次使用道具/购买次数时间
          , die_time = 0           %% 上次死亡时间
          , die_times = 0          %% 死亡次数
          , next_enter_time = 0    %% 下次可进入该boss场景时间(新野外boss5分钟内死亡次数过多限制进入)
     }).

%% 场景的boss疲劳值
-record(scene_boss_tired, {
        boss_type = 0               %% boss类型
        , tired = 0                 %% 当前疲劳值/体力值
        , max_tired = 0             %% 最大疲劳值/体力值
    }).

%% boss记录
-record(boss_drop_log, {
        role_id = 0
        , name = ""
        , boss_type = 0
        , boss_id = 0
        , goods_id = 0
        , num = 0                   %% 物品数量
        , rating = 0                %% 评分
        , equip_extra_attr = []     %% 装备附加属性##[{Color,TypeId,AttrId,AttrVal,PlusInterVal,PlusUnit}]
        , is_top = 0                %% 是否置顶
        , time = 0                  %% 时间
  }).

%% boss state
%% 建议使用 common_status_map 来增加boss类型
-record(boss_state, {                    %% Boss进程状态
          boss_world_map = #{},
          boss_personal_map = #{},
          boss_home_map = #{},
          boss_forbidden_map = #{},
          boss_domain_map = #{},         %% 秘境领域map
          boss_temple_map = #{},
          boss_phantom_map = #{},
          common_status_map = #{},       %% boss 通用map  key::bossType  value::#boss_common_status{}
          boss_drop_log = [],
          boss_role_anger = [],          %% 玩家怒气定时器列表
          temple_tv_ref = undefined,
          world_boss_rankmap= #{},       %%key:bossid  value:ranklist
          world_boss_inspire = #{},      %%key:roleid  value:[{1,num},{2,num}]货币一与货币二鼓舞次数
          online_num_map = #{},          %%Key:{MinLv, MaxLv} Value: Num  所有服不同等级段的玩家日活跃数量
          other_map = #{},               %%key:{enter_time,bosstype,scene, roleid}  value:进入时间戳,用来统计玩家停留时间.
          domain_lock = 0,               %% 秘境领域特殊怪复活 时间戳
          domain_kill = []               %% 秘境领域杀怪记录 [#domain_boss_kill{}]

}).

%% 秘境领域记录杀怪
-record(domain_boss_kill, {
    role_id = 0,   % 玩家id
    kill_num = 0,  % 击杀boss数量
    get_list = []  % 领取列表  阶段id
}).




%% boss 通用状态
-record(boss_common_status, {
          boss_type = 0                 %% boss类型
          , boss_map = #{}              %% Key:#boss_status.boss_id Value:#boss_status{}
          , fever_ref = undefined       %% 狂热定时器
          , copy_msg  = []              %% 房间信息 #copy_msg
          %% 用于各种boss的特殊数据
          %% 节日boss房间最大id           {max_copy_id => id}   %%房间号为 0 则活动没有开启
          %% 节日boss进入黑名单           {feast_boss_over_role => [RoleId]} 就是参加过活动的，但是进去后，水晶爆的玩家
          , other_map = #{}
     }).

-record(boss_status, {
          boss_id = 0,
          copy    = 0,                  %% 所属房间    没有房间区分默认为0
          boss_auto_id = 0,             %% boss唯一id, 没有保存则默认为0
          reborn_time = 0,              %% 重生时间戳
          num = 0,
          hp = 0,                       %% 血量
          hp_lim = 0,                   %% 血量上限
          kill_log = [],                %% [{NowTime, AttrId, AttrName},...]
          remind_list = [],             %% 关注列表##[RoleId,...]
          no_auto_remind_list = [],     %% 不自动关注列表 [RoleId,...]
          remind_ref = undefined,       %% 重生提醒时间定时器
          reborn_ref = undefined,       %% 复活定时器
          timeout_ref = undefined,      %% 超时定时器（世界boss超时，清理玩家出场景）
          xy = [],
          other_map = #{},              %% 扩展字段     %% 节日boss 刷新信息      {feast_boss_from => {方位, 波数}}
                                                        %% 秘境boss宝箱          {fairyland_boss => #fairyland_boss_data{}}
          optional_data = []
     }).

%% -record(boss_kill_log, {
%%           role_id = 0,
%%           time = 0
%%          }).

%% -record(boss_drop_log, {
%%           role_id = 0,
%%           boss_id = 0,
%%           good_id = 0,
%%           time = 0
%%          }).

%% 玩家信息
-record(boss_role_anger, {
          role_id = 0,             %% 玩家id
          boss_type = 0,           %% Boss类型
          boss_id = 0,             %% BossId
          anger = 0,
          dkill = 0,               %% 连杀数量
          step = 0,                %%  状态 0怒气增加阶段 1雷神之怒30s 2退出倒计时10s
          time = 0,                %%  1和2每个状态结束时间点
          anger_ref = undefined    %%  step 的定时器
          ,reward_type             %%  奖励类型
          ,reward = #{}            %%  奖励  #{奖励来源 => 奖励列表}
          ,hurt = 0                %% 对怪物的伤害
          ,rob_count = 0           %% 抢夺次数
          ,robbed_count = 0        %% 被抢夺次数
          ,bekill_count = []       %% 被击杀时间 [死亡时间]
          ,add_anger = 0           %% 额外增加的怒气值
          ,weekly_card_status = undefined %% 周卡记录
         }).

%% boss配置
-record(boss_cfg, {
          boss_id = 0,
          type = 0,              %% boss类型
          scene = 0,             %% boss出生场景id
          x = 0,
          y = 0,
          rand_xy = [],          %% 随机坐标
          layers = 0,            %% 层数
          num = 0,               %% 生成上限
          drop_lv = 0,           %% 掉落等级
          reborn_time = [],      %% 重生时间[{开服时间, 重生间隔}...]
          goods = [],            %% 固定掉落
          ratio_goods = [],      %% 随机掉落
          cost = [],             %% 单个boss进入消耗 ##[{Type, GoodsTypeId, Num}]|[{UseCount, [{Type, GoodsTypeId, Num}]}]
          condition = [],        %% 进入条件
          free_condition = [],   %% 该类型boss的免费进入条件 [{vip, Vip等级}, {lv, Lv玩家等级}]
          dun_id = 0,            %% 个人boss对应的副本id
          kill_award = []        %% 击杀（最后一击）奖励[{{Type, GoodsTypeId, Num},weight}]
          ,sign = 0              %% 是否和平
          ,open_day =[]          %% 开服天数[1,10]限制条件
          ,first_award = []      %% 首次额外奖励##{奖励类型, [ {主键, [{Type, GoodsTypeId, Num}]}, ...] }
          ,mon_type = 0          %% 怪物类型
          ,hurt_limit = 0        %% 伤害百分比 玩家伤害达到总伤害的一定百分比才能获得奖励（共享掉落boss生效,分配方式伤害均等）
          ,tired_add = 0         %% 击杀减少体力值
}).

%%
-record(boss_reward_cfg, {
          boss_id = 0,           %% 世界bossId
          award_id = 0,          %% 奖励id
          stage_max = 0,         %% 名次上限
          stage_min = 0,         %% 名次下限
          reward = []            %% 奖励列表
     }).

%% boss类型配置
%% free_condition 等字段只有boss使用
-record(boss_type, {
          boss_type = 0,         %% Boss类型
          bossname = "",
          count = 0,             %% 每天限制次数
          max_anger = 0,         %% 最大怒气值
          tired = 0,             %% 最大疲劳值
          cost = [],             %% 该类型boss的进入消耗 [{0, goods_id, num}, {1, num}] 0|1在货币类型查找
          condition = [],        %% 该类型boss的进入条件 [{vip, Vip等级}, {lv, Lv玩家等级}]
          module = 0,            %% 功能id
          daily_id = 0,          %% 日常次数id
          mon_ids = [],          %% 蛮荒禁地的小怪id
          refresh_time = []      %% 定时刷新时间点 [{Hour, Minute}...]
          , reborn_cost = []     %% 重生消耗##[{Type, GoodsTypeId, Num}], 为空不生效
         }).


%%boss房间信息
-record(copy_msg, {
    copy_id       =  0 ,           %% 房间id
    scene_id      =  0 ,           %% 场景id
    scene_pool_id =  0             %% 场景进程id
    ,role_list    = []             %% 玩家id列表
    ,role_num     = 0              %% 玩家人数
    ,status       = ?BOSS_COPY_OPEN     %% 房间状态   0可以进去 1不可以进去
    ,boss_list    = []             %% 房间内的怪物信息   [#boss_status{}]
    ,ref          = []             %% 房间内刷怪定时器
    ,collect_map  = #{}            %% 玩家采集信息   节日boss  key:feast_boss_collect_reward=> {roleId => [{Type, GoodId, Num}]}
    %% 用于各种boss的特殊数据
    %% 节日boss                   {wave => 当前波数}
    %% 节日boss                   {max_feast_boss_num =>  boss总数量}
    %% 节日boss                   {kill_feast_boss_num => 击杀boss数量}
    %% 节日boss宝箱信息            {feast_boss_box => [#feast_boss_box{}]}
    %% 节日boss玩家采集信息         {feast_boss_role_collection => [#feast_boss_role_collection{}]}
    %% 节日boss小怪刷新定时器，     {feast_boss_other_mon_ref => ref}
    ,other_map    = #{}            %% 扩展字段
    ,start_time = 0                %% 房间开始时间
}).



%%节日boss宝箱记录
-record(feast_boss_box, {
    auto_id        = 0,          %% 采集怪唯一id
    refresh_direct = 0           %% 刷新方位
    ,wave          = 0           %% 波数
    ,mon_cfg_id    = 0           %% 采集怪配置id
    ,collect_limit = 0           %% 采集上限
}).


%%节日boss玩家采集记录
-record(feast_boss_role_collection, {
    key            = {},         %% {refresh_direct, wave, role_id}
    refresh_direct = 0           %% 刷新方位
    ,wave          = 0           %% 波数
    ,role_id       = 0           %% 玩家id
    ,collect_count = 0           %% 当前采集次数
    ,collect_limit = 0           %% 采集上限
}).



%%节日boss采集怪配置
-record(feast_boss_role_collection_cfg, {
     mon_id = 0,         %% 'bossID'
     min_role_num = 0 ,  %% '人数下限',
     max_role_num = 0 ,  %% '人数上限',
     fixation_list = [], %% '必掉采集怪列表',
     random_list = [],   %% '随机采集怪列表',
     collect_max = 0     %% '采集上限'
}).

%% 秘境boss宝箱 数据
-record(fairyland_boss_data,{
      times = 0,          %% 抽奖次数
      role_id = 0,        %%归属者id
      time = 0            %%结束时间戳
  }).

%% 秘境boss宝箱奖池
-record(fairy_boss_draw_reward_cfg, {
      pool_id = 0,      %%奖池id
      grade_id = 0,     %%奖励id
      times = 0,        %%次数
      bweight = 0,      %%绑钻抽奖权重
      weight = 0,       %%钻石抽奖额外加成权重
      reward = [],      %%奖励列表
      extra = []        %%额外条件{is_tv,0|1}0表示无传闻1表示有
  }).

-record(base_boss_kill_reward,{
      boss_type = 0,      %% Boss类型
      boss_id  = 0,
      normal_reward = [], %% 普通奖池
      special_reward = [],%% 特殊奖池
      rare_reward = [],   %% 稀有奖池
      other = []          %% 其他
  }).

-record(special_boss_state, {
      boss_map = #{}    %% key:{BossType, RoleId} => #special_boss_map{}
      ,online_num_map = #{}
      ,other_map = #{}  %% {enter_time,bosstype,scene RoleId} => EnterTime
  }).

-record(special_boss_map, {
      special_boss = #{}  %% key:bossid => #special_boss{}

  }).

-record(special_boss,{
      boss_id = 0,
      reborn_time = 0,
      remind = 0,              %% 是否关注 0否1是
      remind_ref = undefined,
      reborn_ref = undefined
  }).
%% 数据库
-define(sql_role_boss_select, <<"SELECT boss_type, vit, vit_add_today, vit_can_back, last_vit_time, buy_count, extra_count, stime, next_enter_time, die_time, die_times FROM role_boss WHERE role_id = ~p and boss_type = ~p ">>).
-define(sql_role_boss_replace, <<"REPLACE INTO role_boss(role_id, boss_type, vit, vit_add_today, vit_can_back, last_vit_time, buy_count, extra_count, stime, next_enter_time, die_time, die_times) VALUES(~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p)">>).
-define(sql_role_boss_update, <<"UPDATE role_boss SET buy_count = ~p, extra_count = ~p, stime = ~p WHERE role_id = ~p and boss_type = ~p ">>).

-define(sql_fairyland_draw_select, <<"SELECT role_id, times, time FROM fairyland_boss_draw WHERE boss_id = ~p">>).
-define(sql_fairyland_draw_replace, <<"REPLACE INTO fairyland_boss_draw(boss_id, role_id, times, time) VALUES(~p, ~p, ~p, ~p)">>).

-define(sql_special_boss_select, <<"SELECT role_id, boss_type, boss_id, reborn_time, remind FROM special_boss_info WHERE role_id = ~p and boss_type = ~p">>).
-define(sql_special_boss_replace, <<"REPLACE INTO special_boss_info(role_id, boss_type, boss_id, reborn_time, remind) VALUES(~p, ~p, ~p, ~p, ~p)">>).
-define(sql_special_boss_delete, <<"delete from special_boss_info where role_id = ~p AND boss_type = ~p and boss_id = ~p ">>).
-define(sql_special_boss_truncate, <<" truncate table special_boss_info">>).