%%%---------------------------------------------------------------------
%%% 功能id定义（建议与协议号段Id保持一致）
%%%---------------------------------------------------------------------

-define(MOD_0,                  0).             %% 无
-define(MOD_BASE,               102).           %% 游戏基础功能
-define(MOD_CHAT,               110).           %% 聊天系统模块
-define(MOD_WX,               	113).           %% 微信分享
-define(MOD_PLAYER,             130).           %% 玩家功能管理
-define(MOD_ONHOOK,             132).           %% 离线挂机
-define(MOD_ENCHANTMENT_GUARD,  133).           %% 结界守护
-define(MOD_MEDAL,              134).           %% 勋章
-define(MOD_NINE,               135).           %% 九天斗法
-define(MOD_DRUMWAR,            137).           %% 钻石大战
-define(MOD_RELA,               140).           %% 社交系统模块
-define(MOD_BACK_DECORATION,    141).           %% 背饰
-define(MOD_COMPANION,          142).           %% 伙伴（新
-define(MOD_DRAGON_BALL,        143).           %% 龙珠
-define(MOD_FAIRY,              148).           %% 精灵
-define(MOD_DECORATION,         149).           %% 幻饰
-define(MOD_GOODS,              150).           %% 物品背包
-define(MOD_SELL,               151).           %% 市场
-define(MOD_EQUIP,              152).           %% 装备系统
-define(MOD_SHOP,               153).           %% 商城系统
-define(MOD_AUCTION,            154).           %% 拍卖系统
-define(MOD_HOLY_SEAL,          155).           %% 圣印功能
-define(MOD_ACTIVITY,           157).           %% 活动日历
-define(MOD_RECHARGE,           158).           %% 充值
-define(MOD_RECHARGE_ACT,       159).           %% 充值活动
-define(MOD_MOUNT,              160).           %% 坐骑
-define(MOD_WING,               161).           %% 翅膀
-define(MOD_AWAKENING,          164).           %% 天命觉醒
-define(MOD_PET,                165).           %% 宠物
-define(MOD_JUEWEI,             166).           %% 爵位
-define(MOD_RUNE,               167).           %% 符文
-define(MOD_TALISMAN,           168).           %% 法宝
-define(MOD_GODWEAPON,          169).           %% 神兵
-define(MOD_SOUL,               170).           %% 聚魂
-define(MOD_ARTIFACT,           171).           %% 神器
-define(MOD_MARRIAGE,           172).           %% 婚姻
-define(MOD_EUDEMONS,           173).           %% 幻兽
-define(MOD_NOON_QUIZ,          174).           %% 中午答题
-define(MOD_LOGIN_REWARD,       175).           %% 七天登录
-define(MOD_LIMIT_SHOP,         176).           %% 神秘限购
-define(MOD_HOUSE,              177).           %% 家园
-define(MOD_MOUNT_EQUIP,        178).           %% 坐骑装备
-define(MOD_BONUS_MONDAY,       179).           %% 周一大奖
-define(MOD_DRAGON,             181).           %% 龙纹
-define(MOD_BABY,               182).           %% 宝宝
-define(MOD_DEMONS,             183).           %% 使魔
-define(MOD_ESCORT,             185).           %% 矿石护送
-define(MOD_SEACRAFT,           186).           %% 怒海争霸
-define(MOD_SEACRAFT_DAILY,     187).           %% 怒海日常
-define(MOD_BOSS_FIRST_BLOOD_PLUS,188).         %% 新版boss首杀
-define(MOD_SEA_TREASURE,       189).           %% 璀璨之海
-define(MOD_MAIL,               190).           %% 邮件系统模块
-define(MOD_ACT_ONHOOK,         192).           %% 活动托管
-define(MOD_FIESTA,             194).           %% 祭典
-define(MOD_LOOK_OVER_PLAYER_INFO,   195).      %% 新查看玩家信息
-define(MOD_BATTLE,             200).           %% 战斗
-define(MOD_TREASURE_MAP,       203).           %% 藏宝图
-define(MOD_CHRONO_RIFT,        204).           %% 时空裂缝
-define(MOD_NIGHT_GHOST,        206).           %% 百鬼夜行
-define(MOD_SKILL,              210).           %% 技能
-define(MOD_ARCANA,             211).           %% 远古奥术
-define(MOD_SOUL_DUNGEON,       215).           %% 聚魂本
-define(MOD_MAGIC_CIRCLE,       216).           %% 魔法阵
-define(MOD_ATTR_MEDICAMENT,    217).           %% 属性药剂
-define(MOD_HOLY_SPIRIT_BATTLEFIELD,  218).           %% 圣灵战场
-define(MOD_RANK,               221).           %% 排行榜
-define(MOD_TITLE,              222).           %% 头衔
-define(MOD_FLOWER,             223).           %% 花语鲜花
-define(MOD_FLOWER_RANK_ACT,    224).           %% 鲜花榜活动
-define(MOD_RUSH_RANK,          225).           %% 开服冲榜活动
-define(MOD_CYCLE_RANK,         227).           %% 循环冲榜
-define(MOD_CONSTELLATION,      232).           %% 星宿
-define(MOD_GOD_COURT,          233).           %% 神庭
-define(MOD_TEAM,               240).           %% 队伍
-define(MOD_BEINGS_GATE,        241).           %% 众生之门
-define(MOD_KF_SANCTUM,         279).           %% 永恒圣殿
-define(MOD_JJC,                280).           %% 竞技场
-define(MOD_TOPPK,              281).           %% 巅峰竞技
-define(MOD_SANCTUARY,          283).           %% 圣域
-define(MOD_C_SANCTUARY,        284).           %% 跨服圣域
-define(MOD_MIDDAY_PARTY,       285).           %% 午间派对
-define(MOD_REVELATION_EQUIP,   286).           %% 天启装备
-define(MOD_RESONANCE_POWER,    287).           %% 共鸣系统(装备套装系统)
-define(MOD_TASK,			    300).			%% 任务系统
-define(MOD_AC_CUSTOM,          331).           %% 定制活动
-define(MOD_AC_CUSTOM_OTHER,    332).           %% 其他定制活动
-define(MOD_RACE_ACT,           338).           %% 竞榜活动
-define(MOD_RED_ENVELOPES,      339).           %% 红包
-define(MOD_INVITE,             340).           %% 邀请
-define(MOD_GUESS,              342).           %% 竞猜
-define(MOD_GUILD,              400).           %% 公会系统
-define(MOD_GUILD_DEPOT,        401).           %% 公会仓库
-define(MOD_GUILD_ACT,          402).           %% 公会活动
-define(MOD_GUILD_DAILY,        403).           %% 公会宝箱
-define(MOD_GUILD_ASSIST,       404).           %% 公会协助
-define(MOD_GUILD_GOD,          405).           %% 公会神像
-define(MOD_ACHIEVEMENT,        409).           %% 成就
-define(MOD_DESIGNATION,        411).           %% 称号系统
-define(MOD_PARTNER,            412).           %% 伙伴
-define(MOD_FASHION,            413).           %% 时装
-define(MOD_TREASURE_CHEST,     414).           %% 青云夺宝
-define(MOD_PRAY,               415).           %% 祈愿
-define(MOD_TREASURE_HUNT,      416).           %% 寻宝
-define(MOD_WELFARE,            417).           %% 福利
-define(MOD_BEACH,              418).           %% 魅力沙滩
-define(MOD_RESOURCE_BACK,      419).           %% 资源找回
-define(MOD_INVESTMENT,         420).           %% 投资活动
%%-define(MOD_TSMAPS,             421).           %% 藏宝图
-define(MOD_STAR_MAP,           422).           %% 星图
-define(MOD_ETERNAL_VALLEY,     424).           %% 永恒碑谷
-define(MOD_ADVENTURE_BOOK,     425).           %% 冒险之书
-define(MOD_RENAME,             426).           %% 改名
-define(MOD_TEMPLE_AWAKEN,      429).           %% 神殿觉醒
-define(MOD_ADVENTURE,          427).           %% 天天冒险
-define(MOD_KF_GUILD_WAR,       437).           %% 跨服公会战
-define(MOD_GOD,                440).           %% 降神
-define(MOD_MON_PIC,   		    442).           %% 怪物图鉴
-define(MOD_VIP,                450).           %% VIP
-define(MOD_SUPVIP,             451).           %% 至尊vip
-define(MOD_WEEKLY_CARD,        452).           %% 周卡
-define(MOD_BOSS,               460).           %% 本服BOSS
-define(MOD_EUDEMONS_BOSS,      470).           %% 幻兽之域BOSS
-define(MOD_DECORATION_BOSS,    471).           %% 幻饰boss
-define(MOD_SURPRISE_GIFT,      490).           %% 惊喜礼包
-define(MOD_HUSONG,             500).           %% 护送
-define(MOD_GUILD_BATTLE,       505).           %% 公会争霸
-define(MOD_TERRITORY_WAR,       506).           %% 领地战
-define(MOD_WEEK_DUNGEON,       508).           %% 周副本
-define(MODULE_BOSS_ROTARY,       510).           %% boss转盘
-define(MODULE_CLOUD_BUY,       512).           %% 跨服云购
-define(MODULE_FAIRY_BUY,       513).           %% 仙灵直购
-define(MOD_VOID_FAM,           600).           %% 虚空秘境
-define(MOD_KF_HEGEMONY,        601).           %% 跨服服战
-define(MOD_THREE_ARMIES_BATTLE,602).           %% 三军之战
-define(MOD_EUDEMONS_ATTACK,    603).           %% 幻兽入侵
-define(MOD_DIAMOND_LEAGUE,     604).           %% 星钻联盟
-define(MOD_PET_AIRCRAFT,       605).           %% 精灵飞行器（为支持技能属性而加的模块id，协议在165模块）
-define(MOD_HOLY_GHOST,         606).           %% 圣灵
-define(MOD_SAINT,              607).           %% 圣者殿
-define(MOD_DUNGEON,            610).           %% 副本
-define(MOD_PET_WING,           611).           %% 精灵翅膀（为支持技能属性而加的模块id，协议在165模块）
-define(MOD_LEVEL,              612).           %% 等级
-define(MOD_TO_BE_STRONG,       618).           %% 我要变强
-define(MOD_PK_LOG,             619).           %% PK记录
-define(MOD_DRACONIC,           620).           %% 龙语
-define(MOD_KF_1VN,             621).           %% 跨服1vn
-define(MOD_KF_3V3,             650).           %% 跨服3v3
-define(MOD_DRAGON_LANGUAGE_BOSS,651).          %% 龙语boss
-define(MOD_GLADITOR,           653).           %% 决斗场
-define(MOD_TERRITORY,          652).			%% 领地夺宝
-define(MOD_SEAL,               654).           %% 圣印

%%%---------------------------------------------------------------------
%%% 功能子id定义
%%%---------------------------------------------------------------------

%% ----------------------------------------------------
%% @doc 社交系统MOD_BASE: 102 游戏基础功能
%% ----------------------------------------------------

-define(MOD_BASE_EXP,  1).  %% 子类型 - 经验
-define(MOD_BASE_COIN, 2).  %% 子类型 - 金币

%% 计数器配置
-define(MOD_BASE_DAILY_DEAD,        1). % 玩家一天的的死亡次数
-define(MOD_BASE_DAILY_ONLINE_TIME, 2). % 玩家一天在线时间

%% ----------------------------------------------------
%% @doc 聊天MOD_CHAT: 110 聊天
%% ----------------------------------------------------

-define(MOD_CHAT_ROBOT, 3).  %% 子类型 - 假人聊天

%% ----------------------------------------------------
%% @doc 社交系统MOD_RELA: 140专用的子类型宏定义
%% ----------------------------------------------------

-define(MOD_RELA_INTIMACY_PRESENT, 1).  %% 子类型 - 好友赠送物品

%% ----------------------------------------------------
%% @doc 活动日历MOD_GOODS: 150专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_GOODS_DROP, 		  1).   %% 子类型 - 单个物品掉落次数
-define(MOD_GOODS_GIFT,           2).   %% 子类型 - 单个礼包的每日使用上限
-define(MOD_GOODS_EXCHANGE,       3).   %% 子类型 - 物品兑换(通用)
-define(MOD_GOODS_COMPOSE,        4).   %% 子类型 - 合成
-define(MOD_GOODS_DROP_RATIO,     5).   %% 子类型 - 比率掉落规则id次数,不命中一直加
-define(MOD_GOODS_DROP_RATIO_HIT, 6).   %% 子类型 - 比率掉落规则id命中
-define(MOD_GOODS_DAILY_GET,      7).   %% 子类型 - 单日获得货币数量
-define(MOD_GOODS_DAILY_CONSUME,  8).   %% 子类型 - 单日消费货币数量
-define(MOD_GOODS_PGIFT_ROUND,    9).   %% 子类型 - 奖池礼包当前轮次
-define(MOD_GOODS_PGIFT_FAIL,    10).   %% 子类型 - 奖池礼包当前轮次失败次数

%% ----------------------------------------------------
%% @doc 装备系统 MOD_EQUIP : 152专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_EQUIP_SUIT, 		  7).   %% 子类型 - 套装

%% ----------------------------------------------------
%% @doc 商城系统 MOD_SHOP : 153专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_SHOP_GOODS,           1).   %% 子类型 - 原物品次数id
-define(MOD_SHOP_NEW_GOODS,       2).   %% 子类型 - 新物品键值id
-define(MOD_SHOP_PRE_GOODS,    1001).   %% 子类型 - 前置物品购买次数



%% ----------------------------------------------------
%% @doc 圣印: 155专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_HOLY_SEAL_DRESS,      1).   %% 子类型 - 圣印镶嵌
-define(MOD_HOLY_SEAL_STREN,      2).   %% 子类型 - 圣印强化
-define(MOD_HOLY_SEAL_SOUL,       3).   %% 子类型 - 圣印圣魂

%% ----------------------------------------------------
%% @doc 活动日历MOD_ACTIVITY: 157专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_ACTIVITY_NUM, 1).           %% 子类型 - 活动完成次数
-define(MOD_ACTIVITY_LIVE_REWARD, 2).   %% 子类型 - 活跃度奖励
-define(MOD_ACTIVITY_LIVE_NUM,    3).      %% 子类型 - 已经完成活动所获得的活跃度，但是没有领取的部分
-define(MOD_ACTIVITY_LIVE_YET_GET_NUM,    4).%% 子类型 - 活动已经领取的活跃度数量
-define(MOD_ACTIVITY_WEEK_NUM, 5).           %% 子类型 - 周活动完成次数


%% ----------------------------------------------------
%% @doc 充值活动 MOD_RECHARGE_ACT : 159专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_RECHARGE_ACT_WEAFARE,   1).                     %% 福利卡
-define(MOD_RECHARGE_ACT_CUMULATION,    2).                 %% 每日累充
-define(MOD_RECHARGE_ACT_BUY_DAILY,   6).                   %% 购买每日礼包
-define(MOD_RECHARGE_ACT_GET_WEAFARE_REWARD,   7).          %% 领取7日或30日礼包

%% ----------------------------------------------------
%% @doc 周一大奖 MOD_RECHARGE_ACT : 179专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_BONUS_MONDAY_FIRST,  1).

%% ----------------------------------------------------
%% @doc 活动托管 MOD_ACT_ONHOOK : 192专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_ACT_ONHOOK_COIN_DAILY_GET,      1). % 每日托管值获取量
-define(MOD_ACT_ONHOOK_COIN_DAILY_CONSUME,  2). % 每日托管值消耗量

%% ----------------------------------------------------
%% @doc 任务 MOD_TASK : 300专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_TASK_DAILY_TASK,      1). %% 悬赏任务
-define(MOD_TASK_GUILD_WEEK_TASK, 2). %% 公会周任务

%% ----------------------------------------------------
%% @doc 任务 MOD_AC_CUSTOM : 331专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_AC_CUSTOM_COLWORD,    4).  %% 开服集字子功能
-define(MOD_AC_CUSTOM_BONUS_DRAW, 58). %% 赛博夺宝
-define(MOD_AC_CUSTOM_FEAST_SHOP, 59). %% 节日抢购商城
-define(MOD_AC_CUSTOM_BUY,        68). %% 节日抢购商城
-define(MOD_AC_CUSTOM_RUSH_BUY,   114).%% 冲榜抢购
%% ----------------------------------------------------
%% @doc 红包 MOD_RED_ENVELOPES : 339专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_RED_ENVELOPES_TRIGGER,      1). %% 触发式红包
-define(MOD_RED_ENVELOPES_GOODS,        2). %% 物品红包
-define(MOD_RED_ENVELOPES_ACT_GOODS,    3). %% 物品红包
-define(MOD_RED_ENVELOPES_VIP,          4). %% VIP公会红包

%% ----------------------------------------------------
%% @doc 公会活动 MOD_GUILD_ACT : 402专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_GUILD_ACT_BOSS,     1).          %% 子类型 - 公会boss
-define(MOD_GUILD_ACT_PARTY,    2).          %% 子类型 - 公会聚会
-define(MOD_GUILD_ACT_GUARD,    3).          %% 子类型 - 守卫公会
-define(MOD_GUILD_ACT_GWAR,     4).          %% 子类型 - 公会争霸

%% ----------------------------------------------------
%% @doc 寻宝: 416专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_TREASURE_HUNT_TYPE_EUQIP,   1).  %% 子类型 - 装备寻宝
-define(MOD_TREASURE_HUNT_TYPE_PEAK,    2).  %% 子类型 - 传奇寻宝
-define(MOD_TREASURE_HUNT_TYPE_EXTREME, 3).  %% 子类型 - 至尊寻宝


%% ----------------------------------------------------
%% @doc 天天冒险: 427专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_ADVENTURE_RESET_TIME,   42701).           %% 子类型 - vip冒险次数


%% ----------------------------------------------------
%% @doc vipMOD_VIP: 450专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_VIP_PRESENT, 1).                %% 子类型 - 特权礼包

%% ----------------------------------------------------
%% @doc 周卡: 452专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_WEEKLY_CARD_DAILY_GIFT, 1).     %% 子类型 - 每日获取周卡资源礼包

-define(MOD_WEEKLY_CARD_BUY_COUNT, 1).      %% 永久计数 - 周卡购买次数


%% ----------------------------------------------------
%% @doc 璀璨之星 MOD_SEA_TREASURE : 189专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_SEA_TREASURE_ROB,       1).     %% 掠夺
-define(MOD_SEA_TREASURE_SHIP,      2).     %% 巡航

%% ----------------------------------------------------
%% @doc 本服boss MOD_BOSS : 460专用的子类型宏定义
%% ----------------------------------------------------

%% 一万以内的子类型留给boss
%%-define(MOD_SUB_WORLD_BOSS,   1).   %% 世界boss
%%-define(MOD_SUB_HOME_BOSS,    2).   %% boss之家
%%-define(MOD_SUB_PERSON_BOSS,  3).   %% 个人boss
%%-define(MOD_SUB_FBD_BOSS,     4).   %% 蛮荒禁地
%%-define(MOD_SUB_OLDTIME_BOSS, 5).   %% 上古神迹
%%-define(MOD_SUB_OUTSIDE_BOSS, 6).   %% 野外Boss
%%-define(MOD_SUB_ABYSS_BOSS,   7).   %% 深渊Boss
%%-define(MOD_SUB_FAIRYLAND_BOSS, 9). %% 秘境boss
%%-define(MOD_SUB_PHANTOM_BOSS, 10).  %% 幻兽领boss

-define(MOD_SUB_WORLD_BOSS,          1).   %% 世界Boss
-define(MOD_SUB_VIP_PERSONAL_BOSS,   2).   %% vip个人Boss
-define(MOD_SUB_HOME_BOSS,           3).   %% Boss之家
-define(MOD_SUB_FBD_BOSS,            4).   %% 蛮荒禁地
-define(MOD_SUB_TEMPLE_BOSS,         5).   %% 遗忘神庙
-define(MOD_SUB_OUTSIDE_BOSS,        6).   %% 野外Boss
-define(MOD_SUB_ABYSS_BOSS,          7).   %% 深渊Boss
-define(MOD_SUB_PERSON_BOSS,         8).   %% 个人boss
-define(MOD_SUB_FAIRYLAND_BOSS,      9).   %% 秘境boss
-define(MOD_SUB_PHANTOM_BOSS,        10).  %% 幻兽领boss
-define(MOD_SUB_FEAST_BOSS ,         11).  %% 节日boss
-define(MOD_SUB_NEW_OUTSIDE_BOSS,    12).   %% 野外Boss

-define(MOD_BOSS_ENTER,     10000). %% 进入本服boss的次数, 次数id是boss类型
-define(MOD_BOSS_TIRE,      10001). %% 进入boss的疲劳值, 次数id是boss类型
-define(MOD_BOSS_COLLECT,   10002). %% 采集次数, 次数id是boss类型
-define(MOD_SUB_BOSS_FIRST_REWARD, 10003).  %% boss首次奖励,次数id是bossid
-define(MOD_SUB_BOSS_OUTSID_KILL, 10004). %% 击杀野外特殊层boss次数,次数id是bossid

%% ----------------------------------------------------
%% @doc 护送 MOD_HUSONG : 500专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_SUB_HUSONG_ANGEL,      0).           %% 天使护送
-define(MOD_SUB_HUSONG_DOUBLE,     1).           %% 双倍护送

%% ----------------------------------------------------
%% @doc 副本MOD_DUNGEON: 610专用的子类型宏定义
%% ----------------------------------------------------

-define(MOD_DUNGEON_ENTER, 1).              %% 子类型 - 副本进入
-define(MOD_DUNGEON_HELP, 2).               %% 子类型 - 副本协助
-define(MOD_DUNGEON_SUCCESS, 3).            %% 子类型 - 副本挑战胜利(只有部分才写入,副本结算设置)
-define(MOD_DUNGEON_BUY, 4).                %% 子类型 - VIP购买次数
-define(MOD_DUNGEON_RESET, 5).              %% 子类型 - 副本重置次数
-define(MOD_DUNGEON_HELP_AWARD, 6).         %% 子类型 - 副本协助奖励次数
-define(MOD_DUNGEON_EXTRA_REWARD_NORAML, 7).%% 子类型 - 额外普通奖励
-define(MOD_DUNGEON_EXTRA_REWARD_TOP, 8).   %% 子类型 - 额外顶级奖励
-define(MOD_DUNGEON_EXTRA_REWARD_FIRST, 9). %% 子类型 - 额外首次通关奖励
-define(MOD_DUNGEON_ADD_COUNT, 10).         %% 子类型 - 增加副本次数[通过物品等等,不受限制增加]
-define(MOD_RESOURCE_DUNGEON_CHALLENGE, 11).    %% 子类型 - 增加资源副本的挑战次数
-define(MOD_RESOURCE_DUNGEON_SWEEP, 12).    %% 子类型 - 增加资源副本的扫荡次数

-define(MOD_DUNGEON_TYPE(X), 10000 + X).    %% 子类型 - 副本类型子模块[用于副本类型的主键配置使用]

%% %% ----------------------------------------------------
%% %% @doc 冒险之旅 MOD_ADVENTURE_TOUR : 420专用的子类型宏定义
%% %% ----------------------------------------------------

%% -define(MOD_SUB_ADVENTURE_TOUR,     1).           %% 冒险之旅



%% -define(MOD_SUB_TASK_OUTDOOR,     1).           %% 野外修炼


%% ----------------------------------------------------
%% @doc 投资活动 MOD_INVESTMENT : 420专用的子类型宏定义
%% ----------------------------------------------------
-define(MOD_INVESTMENT_SHOW, 2).            %% 子类型 - 投资活动是否展示

-define(MOD_INVESTMENT_MONTHLY_CARD_BUY_COUNT, 1).     %% 永久计数 - 月卡购买次数

%% ----------------------------------------------------
%% @doc 160:坐骑  前1000 用于定义坐骑类型
%% ----------------------------------------------------
-define(MOD_MOUNT_SUB_MOUNT, 1).            %% 子类型 - 坐骑类型
-define(MOD_MOUNT_SUB_MATE, 2).             %% 子类型 - 伙伴类型
-define(MOD_MOUNT_SUB_FLY, 3).              %% 子类型 - 翅膀类型
-define(MOD_MOUNT_SUB_ARTIFACT, 4).         %% 子类型 - 神器类型(yyhx:圣器)
-define(MOD_MOUNT_SUB_HOLYORGAN, 5).        %% 子类型 - 圣器类型(yyhx:神兵)
-define(MOD_MOUNT_SUB_SPIRIT, 6).           %% 子类型 - 精灵类型
-define(MOD_MOUNT_SUB_PET, 7).              %% 子类型 - 宠物类型

%% ----------------------------------------------------
%% @doc 508 子类
%% ----------------------------------------------------
-define(MOD_WDUNGEON_SUCC, 1).            %% 子类型 - 周本通关
-define(MOD_WDUNGEON_KILL_BOSS, 2).            %% 子类型 - 周本击杀boss
-define(MOD_WDUNGEON_HELP, 3).            %% 子类型 - 周本助战

%% 登录登出日志需要记录战力的模块(从大到小排序以方便比较)
-define(LOG_POWER_MODULES, [
    ?MOD_SEAL, ?MOD_MON_PIC, ?MOD_DRAGON,
    ?MOD_RUNE, ?MOD_MOUNT, ?MOD_EQUIP, ?MOD_COMPANION, ?MOD_MEDAL
]).
