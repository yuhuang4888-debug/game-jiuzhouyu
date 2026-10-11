%% 功能提供额外buff定义


-define(TREASURE_HUNT_CD_BUFF, 1).  %% 寻宝cd减免
-define(OFFLINE_ONHOOK_TIME_BUFF, 2).  %% 离线挂机时长buff
%%-define(PRAY_CRIT_BUFF, 3).  %% 祈愿暴击几率buff
-define(LIVENESS_REWARD_BUFF, 4).  %% 活跃礼包额外奖励
-define(DRUM_WAR_LIVE_BUFF, 5).  %% 钻石大战生命增加buff
-define(EQUIP_COMPOSE_BUFF, 6).  %% 装备合成概率增加buff
-define(EQUIP_DUNGEON_DROP_BUFF, 7).  %% 装备副本掉落率增加
%-define(EXP_DUNGEON_BUFF, 8).  %% 经验副本经验加成
% -define(SAMCTUM_HP_LIM_BUFF, 9).  %% 永恒圣殿血量上限加成
% -define(KF_1VN_SKILL_BUFF, 10).  %% 1vn技能buff
-define(RACE_ACT_REWARD_BUFF, 8).  %% 竞榜结算增加万分比
-define(ACTIVITY_ATTR_BUFF, 9).  %% 限制活动玩法增加buff


-record(module_buff, {
    key = 0      %% 
    , data = undefined
}).