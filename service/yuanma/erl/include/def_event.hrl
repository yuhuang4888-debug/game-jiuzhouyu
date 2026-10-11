%%%---------------------------------------------------------------------
%%% 事件类型id定义
%%%---------------------------------------------------------------------

-define(EVENT_LV_UP,                1).         % 玩家升级
-define(EVENT_COMBAT_POWER,         2).         % 战力改变
-define(EVENT_MON_DIE,              3).         % 怪物死亡
-define(EVENT_PLAYER_DIE,           4).         % 玩家死亡
-define(EVENT_PICTURE_CHANGE,       5).         % 头像变化
-define(EVENT_GUILD_QUIT,           6).         % 公会退出
-define(EVENT_GUILD_DISBAND,        7).         % 公会解散
-define(EVENT_USE_BUFF_GOODS,       8).         % 使用buff物品
-define(EVENT_PUSHMAIL_ARRIVE_TIME, 9).         % 邮件推送到达特定时间
-define(EVENT_PUSHMAIL_OPEN_DAY,    10).        % 邮件推送开服天数
-define(EVENT_RECHARGE,             11).        % 充值
-define(EVENT_ONLINE_FLAG,          12).        % 上下线标识
-define(EVENT_REVIVE,               13).        % 复活
-define(EVENT_VIP,                  14).        % vip升级
-define(EVENT_PARTICIPATE_ACT,      15).        % 参加活动
-define(EVENT_FIN_CHANGE_SCENE,     16).        % 完成场景的切换
-define(EVENT_ASK_ADD_FRIEND,       17).        % 请求加好友
-define(EVENT_GIVE_GOODS,           18).        % 获得物品45
-define(EVENT_RENAME,               19).        % 修改昵称
-define(EVENT_DROP_CHOOSE,          20).        % 拣取掉落
-define(EVENT_UNEQUIP,              21).        % 卸下装备
-define(EVENT_DISCONNECT,           22).        % 客户端断开
-define(EVENT_DISCONNECT_HOLD_END,  23).        % 客户端断开保持结束 接下来是下线或者离线挂机
-define(EVENT_RECONNECT,            24).        % 客户端断开保持阶段重新连接
-define(EVENT_PREPARE_CHANGE_SCENE, 25).        % 准备切换场景
-define(EVENT_CLS_SHUTDOWN,         26).        % 跨服关闭
-define(EVENT_EQUIP_MASK,           27).        % 用面具
-define(EVENT_FAKE_CLIENT,          28).        % 完成托管
-define(EVENT_ENSURE_ACC_FIRST,     29).        % 确定本账号下首个角色

%% 公会活动类事件
-define(EVENT_HUSONG,               30).        % 护送镖车
-define(EVENT_HUSONG_ATTACK,        31).        % 打劫镖车

%% 日常活动类
-define(EVENT_DUNGEON_ENTER,         33).       % 副本进入
-define(EVENT_DUNGEON_SUCCESS,       34).       % 副本通关
-define(EVENT_DUNGEON_FAIL,          35).       % 副本失败
-define(EVENT_PARTICIPATE_JJC,       41).       % 参与竞技场
-define(EVENT_ADD_FRIEND,            42).       % 增加好友
-define(EVENT_INTIMACY_LV,           43).       % 亲密度等级
-define(EVENT_CHAT_WORLD_TEXT,       45).       % 玩家聊天：世界频道文字
-define(EVENT_CHAT_HORN,             46).       % 玩家聊天：喇叭
-define(EVENT_CHAT_VOICE,            47).       % 玩家聊天：语音
-define(EVENT_CHAT_PRIVATE,          48).       % 玩家聊天：私聊
-define(EVENT_JOIN_TEAM,             49).       % 加入队伍
-define(EVENT_JOIN_GUILD,            50).       % 加入公会
-define(EVENT_CREATE_GUILD,          51).       % 创建公会
-define(EVENT_GUILD_DONATE,          52).       % 公会贡献
-define(EVENT_MONEY_CONSUME,         53).       % 金钱消耗
-define(EVENT_EQUIP,                 54).       % 穿戴装备
-define(EVENT_STREN_EQUIP,           55).       % 强化装备
-define(EVENT_EQUIP_WASH,            56).       % 洗练装备
-define(EVENT_EQUIP_STONE,           57).       % 镶嵌装备
-define(EVENT_FASHION_EQUIP,         64).       % 时装穿戴
-define(EVENT_FASHION_STAIN,         65).       % 时装染色

%% 活跃类
-define(EVENT_CHECK_IN,              66).       % 签到
-define(EVENT_RESOURCE_BACK,         68).       % 奖励找回
-define(EVENT_OFFLINE_EXP,           69).       % 离线经验领取
-define(EVENT_ADD_LIVENESS,          70).       % 活跃度改变事件
-define(EVENT_AUCTION_SUCCESS,       71).       % 参与竞拍
-define(EVENT_SHOP_CONSUME,          72).       % 商城消费
-define(EVENT_USE_TSMAP,             73).       % 藏宝图使用
-define(EVENT_SELL_SUCCESS,          74).       % 交易行成功出售商品
-define(EVENT_SEND_GUILD_INVITE,     75).       % 发送公会邀请
-define(EVENT_LOGIN_CAST,            76).       % 玩家登录延后事件
-define(EVENT_TURN_UP,               77).       % 转生成功
-define(EVENT_VIP_TIME_OUT,          78).       % VIP过期
-define(EVENT_TRANSFER,              79).       % 转职成功
-define(EVENT_BUY_VIP,               80).       % 购买VIP卡
-define(EVENT_FREE_VIP,              81).       % 获取免费vip卡
% -define(EVENT_BABY_CLASS_UP,         105).      % 宝宝进阶
-define(EVENT_BABY_GET,              106).      % 获得宝宝
-define(EVENT_GOODS_DROP,            107).      % 物品掉落
-define(EVENT_OTHERS_DROP,           109).      % 额外掉落
-define(EVENT_TASK_DROP,             110).      % 任务掉落
-define(EVENT_SEND_FLOWER,           111).       % 赠送花朵
-define(EVENT_GIVE_GOODS_LIST,			112).		% 获得物品列表
-define(EVENT_SUPVIP,               113).       % 超级vip
-define(EVENT_REFRESH_BUFF,         114).       % 使用buff物品
-define(EVENT_MONEY_CONSUME_CURRENCY,  115).       % 消耗特殊货币


-define(EVENT_MOUNT_LVUP,            401).      % 坐骑类型升级
-define(EVENT_MATE_LVUP,             402).      % 伙伴类型升级
-define(EVENT_FLY_LVUP,              403).      % 翅膀类型升级
-define(EVENT_ARTIFACT_LVUP,         404).      % 神器类型升级
-define(EVENT_HOLYORGAN_LVUP,        405).      % 圣器类型升级
-define(EVENT_SPIRIT_LVUP,           406).      % 精灵类型升级
-define(EVENT_PET_LVUP,              407).      % 宠物类型升级



% -define(EVENT_ACHV_STAR_LEV,         79).       % 成就星级增加
% %% 伙伴培养
% -define(EVENT_WING_LV_UP,            80).       % 翅膀升级
% -define(EVENT_TALISMAN_LV_UP,        81).       % 法宝升级
% -define(EVENT_ACTI_TALIMAN_FIGURE,   82).       % 法宝幻化
% -define(EVENT_GODWEAPON_LV_UP,       83).       % 神兵升级
% -define(EVENT_ACTI_GODWEAPON_FIGURE, 84).       % 激活神兵幻化
% -define(EVENT_PET_LV_UP,             85).       % 宠物升级
% -define(EVENT_PET_CLASS_UP,          86).       % 宠物升阶
% -define(EVENT_MOUNT_ACTI_FIGURE,     87).       % 坐骑幻化
% -define(EVENT_MOUNT_CLASS_UP,        88).       % 坐骑升阶
% -define(EVENT_EUDEMONS_EQUIP_STREN,  89).       % 幻兽装备强化综合升级
% -define(EVENT_EUDEMONS_EXTEND,       90).       % 幻兽扩展
% -define(EVENT_EQUIP_SUIT_SYNTHESIS,  91).       % 合成套装
% -define(EVENT_ARTIFACT_LV_UP,        92).       % 神器升级
% -define(EVENT_ACTI_ARTIFACT,         93).       % 激活神器
% -define(EVENT_SET_HOLY_SEAL,         94).       % 圣印镶嵌
% -define(EVENT_ACTI_HOLY_SEAL,        95).       % 圣印套装激活
% -define(EVENT_TOP_PK_WIN,            96).       % 巅峰竞技挑战成功
% -define(EVENT_QUIZ_CORRECT,          97).       % 中午答题答对题目
% -define(EVENT_CHARM_BEACH_JOIN,      98).       % 参加温泉活动
% -define(EVENT_GUILD_TASK_FINISHED,   99).       % 完成公会任务
% %% 社交类
% -define(EVENT_GUILD_DINNER,          100).      % 参加公会晚宴
% -define(EVENT_GUILD_WAR_JOIN,        101).      % 参加公会战
% -define(EVENT_GUILD_RED_PACKET,      102).      % 发出公会红包
% -define(EVENT_GUILD_QUIZ,            103).      % 公会答题答对题目
% -define(EVENT_GET_MARRY,             104).      % 结婚
% -define(EVENT_RED_NAME_WASH,         107).      % 洗红名
% -define(EVENT_KILL_PLAYER,           108).      % 野外击杀玩家
% -define(EVENT_KILL_RED_NAME_PLAYER,  109).      % 击杀红名玩家
% -define(EVENT_FLOWER_GET,            111).       % 收到花朵
% -define(EVENT_COIN_GET,              112).      % 获得金币
% -define(EVENT_DUNGEON_SOUL,          113).      % 聚魂副本通关
% -define(EVENT_DUNGEON_RUNE,          114).      % 符文副本通关
% -define(EVENT_DUNGEON_EXP,           115).      % 经验副本通关
% -define(EVENT_DUNGEON_COIN,          116).      % 金币副本通关
% -define(EVENT_DUNGEON_EQUIP,         117).      % 装备副本通关
% -define(EVENT_WORLD_BOSS_KILL,       118).      % 击杀世界boss
% -define(EVENT_BOSS_HOME_KILL,        119).      % boss之家击杀boss
% -define(EVENT_ANIMAL_ILAND_KILL,     120).      % 幻兽之域击杀boss
% -define(EVENT_FORBIDDEN_KILL,        121).      % 蛮荒禁地击杀boss
% -define(EVENT_TRANFER,               122).       % 玩家转职
% -define(EVENT_ARTIFACT_ENCHANT,      123).      % 激活神器附灵属性
% -define(EVENT_BOUNTY_FINISHED,       124).      % 赏金任务：完成
% -define(EVENT_GUILD_WAR_END,         125).      % 公会战结束
% -define(EVENT_ANIMAL_ILAND_COLLECT,  126).      % 幻兽之域采集
% -define(EVENT_ANIMAL_ILAND_EQUIPBOX, 127).      % 使用幻兽之域装备宝箱
% -define(EVENT_VOID_FAM_KILL,         128).      % 虚空秘境击杀玩家
% -define(EVENT_LV_UP_ACHV,            129).      % 玩家升级成就
% -define(EVENT_PLAYER_DIE_ACHV,       130).      % 玩家死亡成就
% -define(EVENT_ADD_FRIEND_ACHV,       131).      % 玩家增加好友成就
% -define(EVENT_EQUIP_ACHV,            132).      % 穿戴装备成就
% -define(EVENT_PET_ACTI_FIGURE,       133).      % 宠物幻化激活
-define(EVENT_BOSS_KILL,             134).      % 击杀boss
-define(EVENT_BOSS_DUNGEON_ENTER,    135).      % boss副本进入
-define(EVENT_JOIN_ACT,              136).      % 参与活动
-define(EVENT_DUNGEON_SWEEP,         137).      % 副本扫荡
-define(EVENT_EQUIP_COMPOSE,         138).      % 合成装备
%% 个人成长
