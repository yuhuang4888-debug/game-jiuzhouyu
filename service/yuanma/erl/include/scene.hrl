%%%------------------------------------------------
%%% File    : scene.hrl
%%% Author  : xyao
%%% Created : 2011-07-15
%%% Description: 场景管理器
%%%------------------------------------------------

-define(ETS_SCENE, ets_scene).                       %% 场景
-define(ETS_SCENE_POPULATION, ets_scene_population). %% 场景旧线路管理
-define(ETS_SCENE_LINES,           ets_scene_lines). %% 场景线路管理

-define(BROADCAST_0, 0).  %% 不广播
-define(BROADCAST_1, 1).  %% 广播

%% 战斗对象定义
-define(BATTLE_SIGN_MON,        1). %% 怪
-define(BATTLE_SIGN_PLAYER,     2). %% 人
-define(BATTLE_SIGN_PARTNER,    3). %% 伙伴
%-define(BATTLE_SIGN_TOTEM,      4). %% 图腾(无效)
-define(BATTLE_SIGN_BTREE_MON,  4). %% 行为怪
-define(BATTLE_SIGN_DUMMY,      5). %% 假人
-define(BATTLE_SIGN_MATE,       6). %% 伙伴(培养系统)
-define(BATTLE_SIGN_PET,        7). %% 宠物(无效)
-define(BATTLE_SIGN_FAIRY,      8). %% 精灵
-define(BATTLE_SIGN_DEMONS,     9). %% 使魔
-define(BATTLE_SIGN_BABY,      15). %% 宝宝(无效)
-define(BATTLE_SIGN_HOLY,      16). %% 圣物(无效)
-define(BATTLE_SIGN_HGHOST,    19). %% 圣灵(无效)
-define(BATTLE_SIGN_COMPANION, 20). %% 伙伴(新)
-define(BATTLE_SIGN_GUARD,     28). %% 守卫[无战斗]

-define(BATTLE_SIGN_FAKE,     100). %% 100: 伪造的攻击对象(只在战斗使用)

%% 怪物类型定义
-define(MON_KIND_NORMAL,        0). %% 普通怪
-define(MON_KIND_COLLECT,       1). %% 采集怪
-define(MON_KIND_TASK_COLLECT,  2). %% 任务采集怪
-define(MON_KIND_PICK,          4). %% 拾取怪
-define(MON_KIND_ATT,           6). %% 进击怪
-define(MON_KIND_TOWER_DEF,     7). %% 塔防怪
-define(MON_KIND_UNDIE_COLLECT, 8). %% 不死采集怪
-define(MON_KIND_COUNT_COLLECT, 9). %% 不死采集怪(有次数限制的不死采集怪)##(目前没写,先占位)
-define(MON_KIND_ATT_NOT_PLAYER,   10). %% 不攻击人进击怪
% -define(MON_KIND_INFINITE_COLLECT,  11).    %% 无限采集怪(目前没写,先占位)
-define(MON_KIND_ATT_TO_PLAYER, 12).%% 追人进击怪

%% 怪物Boss定义
-define(MON_NORMAL,             0). %% 普通怪
-define(MON_NORMAL_OUSIDE,      1). %% 普通野外怪
-define(MON_ELITE,              2). %% 精英怪物
-define(MON_LOCAL_BOSS,         3). %% 本服BOSS
-define(MON_CLUSTER_BOSS,       4). %% 跨服BOSS
-define(MON_ACTIVE_BOSS,        5). %% 活动BOSS
-define(MON_DUN_BOSS,           6). %% 副本BOSS
-define(MON_TASK_BOSS,          7). %% 任务BOSS
-define(MON_DEMON,              8). %% 使魔怪

%% 怪物系统类型定义##用于判断怪物对应的玩法，处理成就任务等
%% (1)增加怪物系统宏，php后台也需要定义。
-define(MON_SYS_BOSS_TYPE_WORLD,      1).      %% 世界Boss
-define(MON_SYS_BOSS_TYPE_VIP_PERSONAL,  2).   %% vip个人Boss
-define(MON_SYS_BOSS_TYPE_HOME,       3).      %% Boss之家
-define(MON_SYS_BOSS_TYPE_FORBIDDEN,  4).      %% 蛮荒禁地
-define(MON_SYS_BOSS_TYPE_TEMPLE,     5).      %% 遗忘神庙
-define(MON_SYS_BOSS_TYPE_OUTSIDE,    6).      %% 野外Boss
-define(MON_SYS_BOSS_TYPE_ABYSS,      7).      %% 深渊Boss
-define(MON_SYS_BOSS_TYPE_PERSONAL,   8).      %% 个人boss
-define(MON_SYS_BOSS_TYPE_FAIRYLAND,  9).      %% 秘境boss
-define(MON_SYS_BOSS_TYPE_PHANTOM,   10).      %% 幻兽领boss
-define(MON_SYS_BOSS_TYPE_FEAST,     11).      %% 节日boss
-define(MON_SYS_BOSS_TYPE_NEW_OUTSIDE, 12).    %% 新野外boss
-define(MON_SYS_BOSS_TYPE_SPECIAL,     13).    %% 特殊boss(单人野外场景boss)
-define(MON_SYS_BOSS_TYPE_SANCTUARY,   14).    %% 圣域boss
-define(MON_SYS_BOSS_TYPE_DRAGON,  15).      %% 龙纹副本boss
-define(MON_SYS_BOSS_TYPE_DOMAIN,  16).      %% 秘境领域boss
-define(MON_SYS_BOSS_TYPE_DECORATION, 17).   %% 幻饰boss
-define(MON_SYS_BOSS_TYPE_SEA_STATUE,  18).   %% 海战日常雕像
-define(MON_SYS_BOSS_TYPE_SEA_GUARD,   19).   %% 海战日常守卫

-define(MON_SYS_BOSS_TYPE_SANCTUM, 98).        %% 跨服永恒圣殿boss
-define(MON_SYS_BOSS_TYPE_KF_SANCTUARY, 99).   %% 跨服圣域boss

%% 掉落归属显示的boss
-define(IS_DROP_BOSS(X),
     X == ?MON_LOCAL_BOSS orelse X == ?MON_CLUSTER_BOSS).
%% 是不是boss
-define(IS_BOSS(X),
     X == ?MON_LOCAL_BOSS orelse  X == ?MON_CLUSTER_BOSS orelse
     X == ?MON_ACTIVE_BOSS orelse X == ?MON_DUN_BOSS orelse X == ?MON_TASK_BOSS).


-define(LENGTH_UNIT, 60).                    %% 一个logic坐标的x长度(px)
-define(WIDTH_UNIT,  30).                    %% 一个logic坐标的y长度(px)
-define(LENGTH, (6  * ?LENGTH_UNIT)).        %% 一个九宫格的长度(px)
-define(WIDTH,  (18 * ?WIDTH_UNIT)).         %% 一个九宫格的长度(px)
-define(MAP_LENGTH, 50).                     %% 地图长度 可支持长度小于等于像素 ?LENGTH * ?MAP_LENGTH 的的地图 即长度为10800像素的地图 宽度不限

%% 地图原点类型##yy3d都是左下,php和服务端都不根据场景原点坐标判断
%% 目前含义是否2d和3d场景
-define(MAP_ORIGIN_LU, 0).         %% 2d场景(旧:坐标点左上)
-define(MAP_ORIGIN_LD, 1).         %% 3d场景(旧:坐标点左下)

%% 2d场景
%% {0, 0} 在左上角
-define(LU_MAP_LENGTH_M, 0).                      %% 九宫格中间格子编号
-define(LU_MAP_LENGTH_R, 1).                      %% 九宫格右边格子编号
-define(LU_MAP_LENGTH_L, -1).                     %% 九宫格左边格子编号
-define(LU_MAP_LENGTH_U, -?MAP_LENGTH).           %% 九宫格上边格子编号
-define(LU_MAP_LENGTH_D, ?MAP_LENGTH).            %% 九宫格下边格子编号
-define(LU_MAP_LENGTH_LU, -(?MAP_LENGTH+1)).      %% 九宫格左上边格子编号
-define(LU_MAP_LENGTH_LD, (?MAP_LENGTH-1)).       %% 九宫格左下边格子编号
-define(LU_MAP_LENGTH_RU, -(?MAP_LENGTH-1)).      %% 九宫格右上边格子编号
-define(LU_MAP_LENGTH_RD, ?MAP_LENGTH+1).         %% 九宫格右下边格子编号

%% 2d场景
-define(LU_LENGTH_UNIT, 60).                      %% 一个logic坐标的x长度(px)
-define(LU_WIDTH_UNIT,  30).                      %% 一个logic坐标的y长度(px)

%% 3d场景
%% {0, 0} 在左下角
% -define(LD_MAP_LENGTH_M, 0).                      %% 九宫格中间格子编号
% -define(LD_MAP_LENGTH_R, 1).                      %% 九宫格右边格子编号
% -define(LD_MAP_LENGTH_L, -1).                     %% 九宫格左边格子编号
% -define(LD_MAP_LENGTH_U, ?MAP_LENGTH).            %% 九宫格上边格子编号
% -define(LD_MAP_LENGTH_D, -?MAP_LENGTH).           %% 九宫格下边格子编号
% -define(LD_MAP_LENGTH_LU, (?MAP_LENGTH-1)).       %% 九宫格左上边格子编号
% -define(LD_MAP_LENGTH_LD, -(?MAP_LENGTH+1)).      %% 九宫格左下边格子编号
% -define(LD_MAP_LENGTH_RU, (?MAP_LENGTH+1)).       %% 九宫格右上边格子编号
% -define(LD_MAP_LENGTH_RD, -?MAP_LENGTH+1).        %% 九宫格右下边格子编号

%% 场景类型定义.(特殊的活动最好新加场景类型)
%% 主类型-影响生成逻辑，客户端ui, 对应#ets_scene.type
-define(SCENE_TYPE_NORMAL,          0).     %% 主城(普通场景)
-define(SCENE_TYPE_OUTSIDE,         1).     %% 野外场景(客户端挂机)
-define(SCENE_TYPE_DUNGEON,         2).     %% 副本场景
-define(SCENE_TYPE_BOSS,            3).     %% BOSS场景(将分出若干个功能场景：10 11 12 15 21 22)
-define(SCENE_TYPE_GUILD,           4).     %% 公会场景
-define(SCENE_TYPE_ACTIVE,          5).     %% 活动场景(通用)
-define(SCENE_TYPE_VOID_FAM,        6).     %% 虚空秘境
-define(SCENE_TYPE_TOPPK,           7).     %% 巅峰竞技
-define(SCENE_TYPE_GWAR,            8).     %% 公会争霸
-define(SCENE_TYPE_WAITING,         9).     %% 活动等待场景
-define(SCENE_TYPE_WORLD_BOSS,     10).     %% 世界BOSS场景
-define(SCENE_TYPE_TEMPLE_BOSS,    11).     %% 遗忘神庙BOSS场景
-define(SCENE_TYPE_EUDEMONS_BOSS,  12).     %% 幻兽之域BOSS场景
-define(SCENE_TYPE_HOUSE,          13).     %% 家园场景
-define(SCENE_TYPE_KF_HEGEMONY,    14).     %% 跨服服战场景
-define(SCENE_TYPE_HOME_BOSS,      15).     %% 首领之家BOSS场景
-define(SCENE_TYPE_FORBIDDEB_BOSS, 16).     %% 蛮荒BOSS场景
-define(SCENE_TYPE_KF_TEMPLE,      17).     %% 跨服圣殿
-define(SCENE_TYPE_KF_1VN_BATTLE,  18).     %% 跨服1VN
-define(SCENE_TYPE_SAINT,          19).     %% 圣者殿
-define(SCENE_TYPE_KF_GWAR,        20).     %% 跨服公会战场景
-define(SCENE_TYPE_OUTSIDE_BOSS,   21).     %% 野外boss场景
-define(SCENE_TYPE_ABYSS_BOSS,     22).     %% 深渊boss场景
-define(SCENE_TYPE_STORY,          23).     %% 新手剧情场景
-define(SCENE_TYPE_JJC,            24).     %% 竞技场景
-define(SCENE_TYPE_SUIT_BOSS,      25).     %% 待定
-define(SCENE_TYPE_GUILD_FEAST,    26).     %% 公会晚宴场景
-define(SCENE_TYPE_NINE,           27).     %% 九魂圣殿
-define(SCENE_TYPE_FAIRYLAND_BOSS, 28).     %% 秘境boss
-define(SCENE_TYPE_GUILD_DUN,      29).     %% 公会秘境
-define(SCENE_TYPE_PHANTOM_BOSS,   30).     %% 幻兽领
-define(SCENE_TYPE_DRUMWAR,        31).     %% 钻石大战
-define(SCENE_TYPE_FEAST_BOSS,     32).     %% 节日boss
-define(SCENE_TYPE_GLADIATOR,      33).     %% 决斗场
-define(SCENE_TYPE_NEW_OUTSIDE_BOSS, 34).   %% 新野外boss场景
-define(SCENE_TYPE_SPECIAL_BOSS,   35).     %% 新野外boss(单人boss)场景
-define(SCENE_TYPE_SANCTUARY,      36).     %% 圣域场景
-define(SCENE_TYPE_TERRITORY,      37).     %% 领地夺宝场景
-define(SCENE_TYPE_KF_SANCTUARY,   38).     %% 跨服圣域场景
-define(SCENE_TYPE_WEDDING,        39).     %% 婚宴场景
-define(SCENE_TYPE_MAIN_DUN,       40).     %% 主线本（结界守护）
-define(SCENE_TYPE_MIDDAY_PARTY,   41).     %% 午间派对
-define(SCENE_TYPE_KF_3v3,         42).     %% 跨服3v3
-define(SCENE_TYPE_DOMAIN_BOSS,    43).     %% 秘境领域BOSS场景
-define(SCENE_TYPE_SANCTUM,        44).     %% 永恒圣殿场景
-define(SCENE_TYPE_DECORATION_BOSS,45).     %% 幻饰BOSS场景
-define(SCENE_TYPE_DRAGON_LANGUAGE_BOSS, 46).   %%  龙语boss场景
-define(SCENE_TYPE_HOLY_SPIRIT_BATTLE, 47).   %%  圣灵战场
-define(SCENE_TYPE_ESCORT,         48).     %% 矿石护送场景
-define(SCENE_TYPE_SEACRAFT,       49).     %% 怒海争霸
-define(SCENE_TYPE_SEACRAFT_DAILY, 50).     %% 海战日常
-define(SCENE_TYPE_SEA_TREASURE,   51).     %% 璀璨之海
-define(SCENE_TYPE_TEMPLE_AWAKEN,  53).     %% 神殿觉醒
-define(SCENE_TYPE_PHANTOM_BOSS_PER, 54).   %% 幻兽领个人无限层场景
-define(SCENE_TYPE_BEINGS_GATE,    55).     %% 众生之门场景
-define(SCENE_TYPE_WORLD_BOSS_PER, 56).     %% 世界boss无限层场景
-define(SCENE_TYPE_NIGHT_GHOST,    57).     %% 百鬼夜行场景
-define(SCENE_TYPE_KF_GREAT_DEMON, 58).     %% 跨服秘境BOSS

-define(SCENE_SHENHE_IOS,          99).     %% 审核服专用场景

%% 次类型：按场景的对角色的影响而分,对应 #ets_scene.subtype
-define(SCENE_SUBTYPE_KILL_MON,     0).     %% 场景次类型-非pk场景，只能攻击怪物
-define(SCENE_SUBTYPE_SAFE,         1).     %% 场景次类型-安全场景
-define(SCENE_SUBTYPE_PK,           2).     %% 场景次类型-强制切换pk状态场景,切换pk状态查看pk_state字段,入场后不能切换pk状态
-define(SCENE_SUBTYPE_NORMAL,       3).     %% 场景次类型-自由切换PK模式场景(读取requirement中pksate作为默认值)（包括需要战斗分组的所有战场）
-define(SCENE_SUBTYPE_SELECT,       4).     %% 场景次类型-选择切换pk模式场景(读取requirement中pksate作为默认值,pksate_list作为pksate可选列表)

%% 场景所在节点类型 #ets_scene.cls_type
-define(SCENE_CLS_TYPE_GAME, 0).            %% 非跨服场景
-define(SCENE_CLS_TYPE_CENTER, 1).          %% 跨服场景

%% 场景所在节点类型 #ets_scene.broadcast
-define(BROADCAST_AREA, 0).                 %% 九宫格广播
-define(BROADCAST_ALL,  1).                 %% 全场景广播

%% 需要动态创建分线的场景类型
%% 能够切换分线的场景类型限制为 SCENE_TYPE_NORMAL和SCENE_TYPE_OUTSIDE 见12040和12041协议
-define(SCENE_TYPE_NEED_SUB_LINE, [
     % ?SCENE_TYPE_NORMAL,
     ?SCENE_TYPE_OUTSIDE
     % ?SCENE_TYPE_VOID_FAM
     % ?SCENE_TYPE_WAITING
     ]).

%% 怪物不需要清理设定范围之外伤害数值的场景
-define(SCENE_TYPE_NO_HURT_REMOVE, [
]).

%% 非掉落怪物也需要清理设定范围外伤害的场景
-define(SCENE_TYPE_NOT_DROP_HURT_REMOVE, [
    ?SCENE_TYPE_NIGHT_GHOST
]).

%% 保持坐骑骑乘状态的场景(以#ets_scene.mount字段配置为前提)
-define(SCENE_TYPE_KEEP_MOUNT_STATUS, [
    ?SCENE_TYPE_MAIN_DUN
]).

%% 场景mark类型
-define(SCENE_MASK_NORMAL,  0).
-define(SCENE_MASK_BLOCK,  -1).
-define(SCENE_MASK_SAFE,   -2).

%% 伙伴战斗类型
-define(PARTNER_BATTLE_TYPE_NO,      0).    %% 不出战
-define(PARTNER_BATTLE_TYPE_GROUP,   1).    %% 伙伴组出战(位置1、2为一组,位置3、4为一组)
-define(PARTNER_BATTLE_TYPE_DIE_SHIFT,  2). %% 死亡切换(默认出两个)
-define(PARTNER_BATTLE_TYPE_ROBOT_ALL,  3). %% 机器人的伙伴

%% 复活类型
-define(REVIVE_GOLD,        1).             %% 元宝原地复活##优先扣绑定钻石
-define(REVIVE_GHOST,       6).             %% 客户端请求变成幽灵状
-define(REVIVE_ONHOOK,      8).             %% 挂机复活
-define(REVIVE_DUNGEON,     9).             %% 副本复活
-define(REVIVE_ROUND,       10).            %% 新回合复活
-define(REVIVE_KF_3V3,      11).            %% 跨服3v3
-define(REVIVE_KF_GWAR,     12).            %% 跨服公会战复活
-define(REVIVE_WORLD_BOSS,  13).            %% 世界boss复活类型(消耗，原地复活)
-define(REVIVE_GUILD_BATTLE,     14).       %% 公会战复活
-define(REVIVE_WLDBOSS_POINT,    15).       %% 世界boss复活类型(不消耗货币，场景出生点复活)
-define(REVIVE_NINE,        16).            %% 九魂圣殿复活
-define(REVIVE_NINE_GOLD,   17).            %% 九魂圣殿钻石复活
-define(REVIVE_SOUL_DUNGEON,   18).         %% 聚魂副本复活
-define(REVIVE_DRUMWAR,   19).              %% 钻石大战复活
-define(REVIVE_BOSS,        20).            %% 本服boss复活，安全区变幽灵/尸体
-define(REVIVE_ASHES,       21).            %% 复活为尸体
-define(REVIVE_ORIGIN,      22).            %% 出生点复活
-define(REVIVE_INPLACE,     23).            %% 原地复活
-define(REVIVE_HOLY_SPIRIT_BATTLE,     24). %% 圣灵战场复活
-define(REVIVE_HOLY_SEA_CRAFT_DAILY,    25). %% 海战日常回城复活


%% 脱离战斗时间(s)
-define(ESCAPE_ATT_TIME,    5).

-define(EXP_SHARE_ALL_TO_ATTACKER, 0).     %% 所有伤害者获得所有经验
-define(EXP_SHARE_PART_TO_ATTACKER, 1).    %% 按照伤害比例分配经验
-define(EXP_SHARE_TO_SCENE, 2).            %% 同场景的玩家获得经验 比例按动态经验和个人等级挂钩
-define(EXP_SHARE_ALL_TO_ATTACKER_DYNAMIC, 3).  %% 所有伤害者获得所有经验 比例按动态经验和个人等级挂钩

%% 禁止通过12005协议传送进入的场景id列表
-define(FORBID_SCENE_IDS, [4101, 4301, 4302, 4600]).

-define (HIDE_TYPE_VISITOR, 1).

-define(INTERRUPT_COLLECT_SCENES, [3300, 2101, 2102, 2103]).

%% 采集操作类型
-define(COLLECT_STATR,        1).       %% 开始采集
-define(COLLECT_FINISH,       2).       %% 结束采集
-define(COLLECT_CANCEL,       3).       %% 取消采集

-define(CAN_NOT_STOP_SCENE_WHEN_COLLECT, [?SCENE_TYPE_MIDDAY_PARTY]).

%% 场景对象非常用属性
-define(SCENE_OB_COLLECT_TIME,  1).
-define(SCENE_OB_TEAM_ID,       2).
-define(SCENE_OB_CAN_BE_ATKED,  3).
-define(SCENE_OB_CAN_BE_PITED,  4).
-define(SCENE_OB_HP,            5).

%% 场景进程字典
%% Key:{dungeon_hp_rate, CopyId}, Value:HpRateList. 副本辅助信息,CopyId:副本id

%% 怪物进程字典
%% Key:dungeon_hp_rate, Value:HpRateList. 副本血量额外触发

%% 场景数据结构
-record(ets_scene, {
          id = 0,                     %% 场景ID包括资源id
          pool_id=0,                  %% 场景进程id
          bpid = 0,                   %% 广播进程pid
          name = <<>>,                %% 场景名称
          type = 0,                   %% 场景主类型(参考上面定义)
          subtype = 0,                %% 场景次类型(参考上面定义)
          cls_type = 0,               %% 所在节点(参考上面定义)
          broadcast = 0,              %% 广播类型(参考上面定义)
          origin_type = 0,            %% 原点类型##目前的含义是:2d和3d场景
          x = 0,                      %% 默认开始点
          y = 0,                      %% 默认开始点
          elem=[],                    %% 传送阵坐标
          requirement = [],           %% 进入需求## 场景进入条件:[{lv, [{服务器等级、开启等级、玩家等级},..]}]
          mask = "",                  %% 障碍点数据
          npc = [],                   %% npc数据##[[NpcId, X, Y, Anima]]
          mon = [],                   %% 默认怪物数据
          jump = [],                  %% 跳跃点配置
          width = 0,                  %% 场景资源宽度px
          height = 0,                 %% 场景资源长度px
          is_have_safe_area = 0,      %% 是否有安全区(0没有, 1有)
          is_have_minimap = 0,        %% 是否有小地图(0:无;1:有小地图)
          is_client_battle = 0,       %% 是否客户端战斗场景(0:否, 1是)
          mount = 0,                  %% 是否可以上坐骑（0不能，1可以）
          parnter_battle_type = 0,    %% 伙伴战斗类型
          fuhuoscene = 0,             %% 复活场景
          reborn_xys = []             %% 复活坐标列表
          , is_stay_pk_status         %% 是否保留pk状态##(0没有, 1有)
     }).

%% 场景配置中npc位置信息
-record(ets_scene_npc, { scene_id=0, x=0, y=0, anima=""}).

%% 场景旧线路管理
%% -record(ets_scene_population, {
%%           scene = 0,                  %% 场景id
%%           scene_pool_id = 0,          %% 场景进程id
%%           num = 0,                    %% 当前场景poolid进程的人数
%%           max_copy_id = 0,            %% 最大房间id
%%           num_maps = #{}              %% 非副本场景不同分线(copy_id)人数 #{CopyId => {Num, ChangTime}}
%%          }).

%% 场景线路相关
-define(MAX_PEPOLE,   15).
-define(MAX_ONE_ROOM, 10).  %% 0-9
-define(MAX_POOLID,    2).  %% 0-2
-define(MAX_ALL_ROOM, 30).
-record(ets_scene_lines, {
          scene = 0,                  %% 场景id
          pool_id = 0,                %% 场景进程id
          max_copy_id = 0,            %% 最大房间id
          num = 0,                    %% 当前场景poolid进程的人数
          lines = #{}                 %% 非副本场景不同分线(copy_id)人数 #{CopyId => {Num, Ids, ChangTime}}
         }).

%% 场景其他属性
-record(ets_scene_other, {
          id = 0,                  %% 场景id
          room_max_people = 100    %% 房间最大人数
          , is_pvp_sputter = 1     %% 是否有pvp溅射##默认是1,没有配置默认是溅射.首个玩家100%的伤害,其他玩家25%伤害
         }).

%% 场景用户数据
%% 只保留场景所需的信息
-record(ets_scene_user, {
          id = 0,                        %% 角色id
          scene = 0,                     %% 场景id
          scene_pool_id=0,               %% 场景进程id
          copy_id = 0,                   %% 副本id
          x = 0,                         %% X坐标
          y = 0,                         %% Y坐标
          server_id = 0,                 %% 来自的服务器独立唯一标识
          node=none,                     %% 来自节点
          platform = "",                 %% 平台标示
          server_num = 0,                %% 所在的服标示
          server_name = <<>>,            %% 选择服务器的名字
          sid = undefined,               %% 玩家发送消息进程
          pid = undefined,               %% 玩家进程
          figure=undefined,              %% #figure{} (figure.hrl)
          battle_attr=undefined,         %% #battle_attr{} (attr.hrl)
          skill_list = [],               %% 技能列表
          skill_cd = [],                 %% 技能cd
          skill_cd_map = #{},            %% 技能cdMap##{编号=>结束时间(毫秒)}
          skill_combo = [],              %% 技能连技（切换场景清空）
          skill_combo_ders = [],         %% 连技受击者(combo技能不重新选择攻击目标)[{Sign, Id}]
          shaking_skill = 0,             %% 正在前摇的技能id
          last_skill_id = 0,             %% 上一技能id
          pub_skill_cd_cfg = [],         %% 公共的cd配置##[{SkillId, No, Cd}],同一编号cd最好要一致,方便服务端取数据.（目前怪物支持）
          pub_skill_cd = [],             %% 公共的cd##[{No, 释放时间}]
          main_skill = {0, 0},           %% 连技中主技能
          skill_link = [],               %% 连接技能
          skill_passive = [],            %% 被动技能的汇总(人物的被动=人被+天赋+xxx...)
          skill_passive_share = [],      %% 被动技能共享的汇总
          tmp_attr_skill = [],           %% 临时属性技能##[{skillId,Lv}],会计算第二属性
          skill_pet_passive = [],        %% 宠物独立战斗的被动技能列表
          att_list = [],                 %% 正在攻击我的怪物列表
          collect_pid = {0, 0},          %% 正在采集的目标
          collect_etime = 0,             %% 采集结束时间
          hp_resume_ref = undefined,     %% 回血定时器
          onhook_btime = 0,              %% 开始挂机的时间点
          onhook_sxy = {0, 0, 0, 0},     %% 挂机推荐坐标
          onhook_path = undefined,       %% 挂机路径
          onhook_target = undefined,     %% 挂机追踪
          follow_target_xy={0,0},        %% 跟随目标xy坐标
          online = 1,                    %% 是否真实在线
          team = 0,                      %% 组队 #status_team{} (team.hrl)
          scene_partner = [],            %% 伙伴实体
          pet_passive_skill = [],        %% 宠物被动技能
          pet_battle_attr = undefined,   %% 宠物战斗属性
          quickbar = [],                 %% 技能快捷栏
          change_scene_sign = 0,         %% 排队换线标志
          leave_scene_sign = 0,          %% 离开场景标志(某些活动在进入排队前就已经切换成离开场景标识)
          boss_tired = 0,                %% 世界boss疲劳值
          temple_boss_tired = 0,         %% 神庙boss疲劳值
          marriage_type = 0,             %% 婚姻状态：0单身 1恋爱 2已婚
          lover_role_id = 0,             %% 伴侣玩家id
          bl_who = 0,                    %% boss归属标识：0：不显示；1：显示
          bl_who_list = [],              %% 归属列表##[Id,...],场景对象id
          eudemons_boss_tired = 0,       %% 幻兽之域boss疲劳
          eudemons_cl_info = [],         %% 幻兽之域采集信息
          treasure_chest = undefined,    %% 青云夺宝数据#player_treasure_chest{}
          baby_battle_attr = undefined,  %% 宝宝战斗属性
          talisman_battle_attr = undefined, %% 法宝战斗属性
          holyghost_battle_attr = undefined, %% 圣灵战斗属性
          mate_role_id = 0               %% 配对玩家id 目前是海滩约会对象的id 默认为0
          ,hide_type = 0                 %% 隐藏类型 0不隐藏 ？HIDE_TYPE_VISITOR
          ,cls_monitor_ref = undefined   %% 跨服监控
          ,in_sea = 0                    %% 是否在海里 0: 不在 1: 在(跨服公会战使用)
          ,ship_id = 0                   %% 跨服公会战中玩家的船id
          ,train_object = #{}            %% 其他培养系统属性列表  #{AttSign => #scene_train_object{}}
          ,fairyland_tired = 0           %% 秘境boss疲劳值
          ,phantom_tired = 0             %% 幻兽领疲劳值
          ,combat_power = 0              %% 战力
          ,dun_type = 0                  %% 副本类型
          ,boss_tired_map = #{}          %% boss疲劳值##Key:BossType Value:#scene_boss_tired{}
          ,world_lv = 0                  %% 世界等级##用于计算跨服掉落
          ,hit_list = []                 %% 助攻列表 [#hit{},...]
          ,mod_level = 0                 %% 功能等级##计算掉落等级
          ,camp_id = 0                   %% 阵营id
          ,assist_id = 0
          ,del_hp_each_time = []         %% 伤害值区间##跟怪物定义一致
          , per_hurt = 0
          , per_hurt_time = 0
          , halo_privilege = []          %% 主角光环特权
         }).

%% 命中列表
-record(hit, {
          id = 0,             %% 玩家id
          node = 0,           %% 节点
          time = 0            %% 时间(毫秒)
    }).

%% 场景怪物(用于在告诉客户端怪物在哪个场景)
-record(ets_scene_mon, {
          id = 0,              %% 怪物ID
          scene = 0,           %% 场景
          name = <<>>,         %% 场景名称
          mname = <<>>,        %% 怪物名字
          kind = 0,            %% 怪物类型
          x = 0,               %% X坐标
          y = 0,               %% Y坐标
          lv = 0,              %% 怪物等级
          out = 0              %% 是否挂机
     }).

%% del_hp_each_time 字段参数
-define(DEL_HP_EACH_TIME_MAX_HURT, max_hurt).     %% 最大伤害
-define(DEL_HP_EACH_TIME_PER_HURT, per_hurt).     %% 每X秒的最大伤害

%% #mon.drop_lv_type 掉落等级类型
-define(MON_DROP_LV_TYPE_MON_LV, 0).    %% 怪物等级
-define(MON_DROP_LV_TYPE_WORLD_LV, 1).  %% 世界等级
-define(MON_DROP_LV_TYPE_ROLE_LV, 2).   %% 玩家等级
-define(MON_DROP_LV_TYPE_EUDEMONS_LV, 3).   %% 圣兽领等级

%% 怪物配置
-record(mon, {
          id = 0,                    %% 怪物配置id
          name = "",                 %% 怪物名字
          kind = 0,                  %% 怪物类型 0:怪物、1:采集怪、2:任务采集怪、3:护送车队、4:拾取型、5:赏金怪、6:进击怪、7:塔防怪、8:不死采集怪
          boss = 0,                  %% BOSS类型: 0普通怪 1普通野外怪 2精英怪物，3本服BOSS 4跨服BOSS 5活动BOSS 6副本BOSS
          mon_sys = 0,               %% 怪物系统类型##用于判断怪物对应的玩法，处理成就任务等(如果是复用怪物,生成怪物时也可以更新改值)
          type = 0,                  %% 战斗斗类型(0被动，1主动)
          tree_id = default_mon,     %% AI行为树ID
          career = 0,                %% 职业0,没职业
          color = 0,                 %% 颜色(0白,1绿,2蓝,3紫,4橙,5红,6粉) ,
          auto = 0,                  %% 0-读怪物表属性，1-服务器等级，2-队伍平均等级，3-队长等级（无组队时默认是队长），需要读怪物动态属性表
          icon = 0,                  %% 资源id
          icon_effect = "",          %% 怪物资源特效
          icon_texture = 0,          %% 贴图id
          weapon_id = 0,             %% 武器模型id
          icon_scale = 0,            %% 资源缩放[1.0-]
          foot_icon = 0,             %% 脚下资源id
          desc = [],                 %% 默认对话[怪物说话的时间间隔, {怪物说的话1,概率},...]
          lv = 0,                    %% 等级
          hp_lim =0,                 %% 血上限
          att = 0,                   %% 攻击
          def = 0,                   %% 防御
          hit = 0,                   %% 命中
          dodge = 0,                 %% 躲闪
          crit = 0,                  %% 暴击
          ten = 0,                   %% 坚韧
          wreck = 0,                 %% 破甲
          resist  = 0,               %% 抗性
          special_attr = [],         %% 特定属性[{AttrType, AttrValue}] = [{属性类型,属性值}]
          resum = 0,                 %% <br>回血配置,[回血模式,回复量,时间]回血模式:0不回血;1脱离战斗状态立刻回满血;2战斗中持续回复;3脱离战斗后持续回复
                                     %% <br>回复量：整数是血量=当前血量+回复量;小数是血量=当前血量+血量上限*回复量
          striking_distance = 0,     %% 攻击距离(像素)
          tracing_distance = 0,      %% 跟踪距离(像素)
          warning_range = 0,         %% 警戒范围(像素)
          hate_range = 0,            %% 仇恨范围(像素)：表示玩家离开某区域后，怪物不追踪，清空伤害列表，不填表示没有仇恨范围
          speed = 0,                 %% 速度(每秒移动的像素)
          skill = [],                %% 技能列表[{技能id,技能等级},...]
          retime = 0,                %% 重生时间(毫秒)
          att_time = 0,              %% 攻击间隔(毫秒)
          att_type = 0,              %% 0近攻，1远程攻击
          drop = 0,                  %% 掉落方式
          exp = 0,                   %% 经验
          out = 0,                   %% 挂机设置 0|1,是否玩家自动挂机可以攻击的目标
          collect_time = 0,          %% 采集时间(秒)
          collect_count = 0,         %% 可采集次数（每次都会有掉落）
          is_fight_back = 1,         %% 是否会反击 ，默认为1
          is_be_atted = 1,           %% 是否可攻击 ，默认为1
          is_be_clicked = 1,         %% 是否可被点击，默认为1
          is_armor = 0,              %% 是否霸体，默认为0 ,
          del_hp_each_time = [],     %%
                                     %% <br>[Min,Max]:怪物受到的每次伤害值区间,整数,小数为百分比：1:默认:[];2:Min=<hurt=<Max;3怪物Hp的百分比:Hp*Min=<Hurt=<Hp*Max
                                     %% <br>[max_hurt,Max] 最大伤害:整数,小数为百分比; 1:Hurt小于等于Max 2:Hurt小于等于HpLim*Max
                                     %% <br>[per_hurt,PerS,PerHurt] 每PerS毫秒的伤害。1:PerHurt整数,Hurt小于等于PerHurt 2:PerHurt小数为百分比,Hurt小于等于HpLim*PerHurt
          figure_visible = 0,        %% 是否显示形象（默认1，1：显示；0：不显示
          mon_state = 0,             %% 怪物出生特殊状态(特效展示),0：代表无特效，客户端使用
          mon_die_state = "",        %% 怪物死亡特殊状态(特效展示),0：代表无特效，客户端使用
          is_hide_hp = 0,            %% 是否隐藏血条(0|1)
          is_hit_ac = 0,             %% 是否播放受击动作
          exp_share_type = 0,        %% 经验分享类型  0所有伤害者都获得全部经验 1按伤害比例分配 2场景内共享
          anger = 0                  %% 杀怪玩家增加的怒气值(boss玩法：蛮荒禁地 上古神庙)
          % , is_have_bl = 0           %% 是否有归属
          , drop_lv_type = 0       %% 掉落等级类型
         }).


-record(ets_npc, {
          id = 0,           %% 唯一id
          func = 0,         %% 功能
          icon = 0,         %% 场景模型资源id
          image = 0,        %% 头像
          title = "",       %% 称谓
          name = "",        %% npc名字
          scene = 0,        %% npc所在场景
          copy_id = 0,      %% npc所在房间
          show = 1,         %% 默认是否显示 1显示 0不显示(默认显示)
          anima = "",       %% 模型动作和角度参数
          sname = "",
          x,
          y,
          talk,
          realm = 0,
          icon_scale = 0
         }).


%% 怪物召唤
-record(mon_call, {
          goods_id = 0,
          boss_id = 0,
          call_scene = 0,
          call_x_rand = 0,
          call_y_rand = 0,
          born_x_y = 0,
          livingtime=0
         }).

%% 攻击怪物的人
-record(mon_atter, {
          id = 0,                    %% 玩家id
          pid = undefined,           %% 玩家进程pid
          node = none,               %% 玩家节点##跨服场景才有值,本服场景值等于none
          team_id = 0,               %% 玩家队伍id
          hurt = 0,                  %% 伤害值
          att_sign = 0,              %% 攻击者类型
          att_lv = 0,                %% 攻击者等级
          server_id = 0,             %% 攻击者服务器id
          server_num = 0,            %% 服数
          name = "",                 %% 玩家名字
          career = 0                 %% 职业
          , world_lv = 0             %% 世界等级
          , server_name = ""         %% 服名字
          , mod_level = 0            %% 功能等级##计算掉落等级
          , camp_id                  %% 玩家阵营
          , mask_id = 0              %% 玩家面具
          , assist_id = 0            %% 协助id
          , assist_ex_id = 0         %% 协助额外id
          , guild_id = 0             %% 公会ID
          , halo_privilege = []      %% 主角光环特权
         }).

%% 走路类型
-define(WALK_TYPE_GUILD, 1).            %% 如果存在同公会的玩家才走路,否则不走

%% 场景对象活动进程state
-record(ob_act, {
          att = undefined,           %% 攻击对象#{Key, Pid, AttType, X, Y} AttType: 1怪物; 2玩家
          first_att = [],            %% 第一个攻击该怪物的玩家信息#mon_atter{} | []
          follow = [],               %% 跟随参数
          object = [],               %% #scene_object{}
          next_att_time = 0,         %% 下次允许攻击时间
          next_move_time = 0,        %% 下次允许移动时间
          klist = [],                %% 伤害列表[#mon_atter{}...],伤害有可能为0
          hate = [],                 %% 仇恨列表
          clist = [],                %% 采集列表
          bl_who = [],               %% 怪物归属[#mon_atter{}...]
          bl_who_ref = [],           %% 怪物归属定时移除[{RoleId, Timer}]
          bl_who_die_ref = [],       %% 怪物归属定时死亡移除[{RoleId, Timer}]
          %% cref_map = [],             %% 连续技能定时器
          ref = [],                  %% 普通定时器引用
          eref = [],                 %% 事件定时器引用
          frenzy_ref = [],           %% 狂暴定时器引用
          hurt_ref = [],             %% 伤害定时器引用:广播伤害列表
          hurt_remove_ref = [],      %% 定时移除离开boss范围的玩家的伤害列表
          ai_event = [],             %% ai事件
          check_block = true,       %% 走路是否检测障碍
          path = [],                 %% 预定义路径
          path_ai_no = 0,            %% 路径结束的ai事件id
          back_dest_path = null,     %% back状态回复到出生点
          walk_type = 0,             %% 检查走路类型
          walk_ref = [],             %% 检查走路定时器
          walk_time = 0,             %% 检查走路时间
          can_walk = true,           %% 是否能走路
          handle_time = 0,           %% 伙伴个性事件处理时刻
          handle_ref = [],           %% 伙伴个性事件定时器
          skill_link_info = [],      %% 链接技能信息
          each_move_time = 0,        %% 每次移动的总时间
          o_point = {0, 0},          %% 每次移动的原点
          w_point = {0, 0},          %% 移动路径上一个点
          move_begin_time = 0,       %% 移动的开始时间
          hp_change_handler = [],    %% 血量变化监听器
          born_handler = [],         %% 出生监听器
          die_handler = []           %% 死亡监听器
          , collected_handler = []   %% 被采集监听器
          , selected_skill = #{}     %% 放出去的技能## #{ skill_id = #selected_skill{} }
          , release_skill = undefined%% 正在释放的技能## #release_skill{} 要把所有副技能全部释放完才能放下一个技能
          , revive_time = 0          %% 复活时间
          , assist_list = []         %% 求助组列表[#assist_data{}]
          , bl_who_assist = []       %% 归属者的协助者列表[#mon_atter{}...]
          , tree_id = undefined
          , sub_mons = []
    }).

%% 培养系统
%% ?BATTLE_SIGN_COMPANION 使用玩家的基础属性
-record(scene_train_object, {
        att_sign = 0                %% 培养对象类型 ?BATTLE_SIGN_PET | ?BATTLE_SIGN_ELF
        , battle_attr = undefined   %%
        , passive_skill = []
    }).

%% 场景对象
-record(scene_object, {
          %% 公共属性
          id = 0,                    %% id须由mod_scene_object_create获得
          config_id = 0,             %% 各场景对象配置id
          sign = 0,                  %% 类型?BATTLE_SIGN_MON|?BATTLE_SIGN_PARTNER ...
          scene = 0,
          scene_pool_id = 0,
          copy_id = 0,
          x = 0,
          y = 0,
          d_x = 0,                   %% 警戒区中心点x坐标
          d_y = 0,                   %% 警戒区中心点y坐标
          angle = 0,                 %% 默认角度(1-360)
          figure = undefined,        %% 公共形象
          server_id = 1,             %% 服id
          server_num = 1,            %% 所在的服标示
          color = 0,                 %% 颜色
          icon_effect = "",          %% 特效
          icon_texture = 0,          %% 贴图
          weapon_id = 0,             %% 武器id
          pos = 0,                   %% 阵法位置
          type = 0,                  %% 怪物战斗类型（0被动，1主动）
          battle_attr = undefined,   %% 战斗必要属性
          aid = undefined,           %% 活动进程id
          att_type = 0,              %% 攻击类型
          attr_type = 0,             %% 五行属性
          striking_distance = 0,     %% 攻击距离(px)
          tracing_distance = 0,      %% 追踪距离(px)
          warning_range = 0,         %% 警戒范围(px)
          att_time = 0,              %% 攻击间距(s)
          skill = [],                %% 技能[{skillid, skilllv}]
          temp_skill = [],           %% 临时技能列表，优先选取此技能
          skill_owner = [],          %% 表示怪物属于技能触发（召唤追踪类技能），当此怪物杀死对方时，与施法方杀死对方效果同等 #skill_owner{}
          skill_cd = [],             %% 存放怪物释放过技能的cd
          skill_cd_map = #{},        %% 技能cdMap##{编号=>结束时间(毫秒)}
          skill_combo = [],          %% 技能combo状态
          shaking_skill = 0,         %% 正在前摇的技能id##大于0,不能动也无法释放其他技能
          last_skill_id = 0,         %% 上一技能id
          pub_skill_cd_cfg = [],     %% 公共的cd配置##[{SkillId, No, Cd}],同一编号cd最好要一致,方便服务端取数据.
          pub_skill_cd = [],         %% 公共的cd##[{No, 释放时间}]
          is_fight_back = 1,         %% 是否会反击
          is_be_atted   = 1,         %% 是否可攻击
          is_be_clicked = 1,         %% 是否可被点击
          is_armor = 0,              %% 是否霸体
          no_battle_hp_ex = 0,       %% 非战斗状态额外回复量##回复量：整数是血量=当前血量+回复量;小数是血量=当前血量+血量上限*回复量
          hp_time = 0,               %% 血量回复时间间隔(ms)
          hp_resume_ref = undefined, %% 血量回复定时器
          del_hp_each_time = [],     %% %% [Min,Max]:怪物受到的每次伤害值区间,整数,小数为百分比：1:默认:[];2:Min=<hurt=<Max;3怪物Hp的百分比:Hp*Min=<Hurt=<Hp*Max
          per_hurt = 0,              %% 本段时间的伤害
          per_hurt_time = 0,         %% 上一次清理伤害的时间
          mod_args = [],             %% 功能参数，用于抛出事件时，各功能可以进行判断，尽可能保持短小
          is_hit_ac = 0,             %% 是否播放受击动作
          %% 场景对象自有属性
          mon = undefined,           %% 怪物私有属性 #scene_mon{}
          partner = undefined,       %% 伙伴私有属性
          dummy   = undefined,       %% 假人私有属性 #scene_dummy{}
          die_info = [],             %% 死亡后传给相关处理逻辑的参数
          hurt_check = [],           %% 受击检查器
          be_att_limit = none        %% none:不生效 List：存放能攻击scene_object的攻击对象id
          , bl_role_id = 0           %% 所属玩家id##目前用于客户端显示
          , frenzy_enter_time = 0    %% 进入狂暴时间戳(秒)
          , assist_ids = []          %% 求助id列表
          , camp_id = 0              %% 阵营id
         }).

%% 动态属性类型
-define(MON_AUTO_WORLD_LV, 1).     % 1世界等级## max(1, util:get_world_lv())
-define(MON_AUTO_AUTO_LV, 2).      % 2动态等级## #scene_mon.auto_lv

%% create_key(功能生成的Key值)
%%  {mon_event, CommonEventId, MonAutoId}
-record(scene_mon, {
          mid = 0,                %% 配置id
          kind = 0,               %% 0怪物，1采集怪，2任务采集怪，3护送车队，4拾取型怪物
          boss = 0,               %% BOSS类型: 0普通怪 1普通野外怪 2精英怪物，3本服BOSS 4跨服BOSS 5活动BOSS 6副本BOSS
          mon_sys = 0,            %% 怪物系统类型##用于判断怪物对应的玩法，处理成就任务等
          d_x = 0,                %% 默认出生X
          d_y = 0,                %% 默认出生y
          auto = 0,               %% 0读取默认属性，1世界等级(跨服怪不能填这个,可以填2,需要通知程序做处理)，2动态等级
          ctime = 0,              %% 怪物创建时间
          retime=1,               %% 重生时间(s)
          %% drop = 0,               %% 掉落方式(0:最大伤害;1:最后伤害;2:最先伤害;3:以组队单位计算贡献伤害)
          %% drop_num = 0,           %% 掉落计算次数
          exp = 0,                %% 击杀经验
          exp_share_type = 0,     %% 经验分配方式
          out = 0,                %% 是否挂机
          collect_time = 0,       %% 采集怪物的采集时间
          collect_count = 0,      %% 采集怪物的可采集次数
          collect_times = 0,      %% 已经被采集次数
          next_collect_time = 0,  %% 下次可被采集时间
          create_key = undefined, %% 功能生成的Key值,保证唯一,就能对怪物进行操作[防止call怪物获得的唯一键,主要用于频繁生成怪物并且需要对怪物操作的进程].如 {dungeon, Id}
          auto_lv = 1,            %% 动态生成怪物参数，一般为玩家等级，由副本带入赋值
          dun_r = 1,              %% 副本属性系数
          dun_crush_r = 1,        %% 副本碾压战力系数
          hp_re = 0,              %% 非战斗情况下额外的回血
          hp_re_time = 0,         %% 非战斗情况下额外回血量
          is_collecting = 0,      %% 采集怪是否正在被采集 0: 否 1: 是
          has_cltimes = 1         %% 采集怪是否还有剩余采集次数 0: 否 1: 有
         }).

%% 怪物动态属性配置
-record(mon_dynamic, {
          id = 0,                 %% 怪物id
          lv  = 0,                %% 等级
          hp = 0,                 %% 血量
          att = 0,                %% 攻击
          exp = 0                 %% 经验
         }).

%% 副本怪物动态属性
-record(dungeon_mon_dynamic, {
          id = 0,                 %% 怪物id
          dun_id = 0,             %% 副本id
          level = 0,              %% 层数
          ratio = 0               %% 难度系数
         }).

-record(scene_dummy, {
          partner = [],
          team_id = 0
         }).

%% 怪物类型伤害加成
-record(mon_type_lv_hurt, {
          mon_type = 0,           %% 怪物类型
          boss_type = 0,          %% 本服boss对应的boss类型
          blv = 0,                %% 开始等级(带符号)(玩家-怪物的等级=加成等级)
          elv = 0,                %% 结束等级(带符号)
          role_add_hurt = 0,      %% 玩家伤害加成(带符号小数点)
          mon_add_hurt = 0        %% 怪物伤害加成(带符号小数点)
         }).

%% 协助信息
-record(assist_data, {
          assist_id = 0,           %% 协助id
          mon_atter = []
         }).


%%移动时广播给怪物记录
-record(move_transport_to_mon, {
    ob_id = 0,             %% 对象id
    ob_pid = undefined,    %% 进程pid
    target_x = 0           %% 对象x坐标
    ,target_y = 0          %% 对象y坐标
    ,sign = ?BATTLE_SIGN_PLAYER        %% 对象类型, 默认玩家
    ,team_id = 0           %% 队伍id
    ,group_id = 0          %% 分组id
    ,guild_id = 0          %% 公会id
}).

%% 场景对象创建state
-record(object_create_state, {
     auto_id = 0         % 自增id
     , cnt = 0           % 数量统计
     }).