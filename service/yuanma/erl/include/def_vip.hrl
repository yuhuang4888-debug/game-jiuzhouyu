%%%---------------------------------------------------------------------
%%% vip定义
%%%---------------------------------------------------------------------
%% ------------------ VIP特权子类型定义 ------------------
%% ------------------ VIP特权子类型定义 ------------------
%% 
%% get_num_by_vip(ModuleId, SubclassId， VipType, Vip).

%% VIP特权子类型定义
%% SubclassId

%% 聊天系统  110
-define(NBV_CHANNEL_WORLD,          1).      %% 世界聊天
-define(NBV_CHANNEL_WORLD_INTERVAL, 2).      %% 世界频道发言间隔


%% 社交系统 140
-define(NBV_FRIEND_NUM_MAX,         1).      %% 好友上限
-define(NBV_INTIMACY_SPEED,         2).      %% 亲密度提升效增加百分比

%% 充值活动 159
-define(NBV_RECHARGE_GIFT_ONE,      1).      %% 可购买1元礼包
-define(NBV_RECHARGE_GIFT_THREE,    2).      %% 可购买3元礼包
-define(NBV_RECHARGE_GIFT_SIX,      3).      %% 可购买5元礼包

%% 竞技场 280
-define(NBV_JJC_NUM,                1).      %% 竞技场购买次数


%%　公会红包　339

%% 公会系统 400
-define(NBV_GUILD_DONATE_ADD,       1).      %% 公会捐献加成
-define(NBV_GUILD_DONATE_REWARD,    2).      %% 公会捐献奖励增加百分比

%% 公会活动 402

%% 离线经验
-define(NBV_OFFLINE_EXP_ADD,        1).      %% 离线经验增加百分比
-define(NBV_OFFLINE_EXP_START,      2).      %% 开启神效丸离线托管

%% 招财猫
-define(NBV_LUCKY_CAT,              1).      %% 招财猫使用次数

%% 本服Boss 460
-define(VIP_BOSS_ENTER(X), 1000000 + X).    %% Boss进入次数
-define(VIP_BOSS_TIRE(X),  2000000 + X).    %% Boss疲劳

%% 副本 610
%% X值:可能是副本id或者副本类型
-define(VIP_DUNGEON_BUY_RIGHT_ID (X),   4000000 + X).  %% 副本购买次数  %% 根据策划要求，这当X为资源副本类型时，这里表示的是该名玩家当天总可扫荡的次数上限
-define(VIP_DUNGEON_ENTER_RIGHT_ID (X), 1000000 + X).  %% 副本免费进入次数  %% 根据策划要求，当X为资源副本类型时，这里表示当天可免费挑战资源副本的上限
-define(VIP_DUNGEON_SWEEP_RIGHT_ID (X), 2000000 + X).  %% 副本扫荡次数和  副本购买次数分离情况 例如伙伴副本

-define(TOPPK_BUY_COUNT_RIGHT_ID, 1).   %% 巅峰竞技次数购买权限

-define(KT_TEMPLE_DAILY_COUNT, 1). %% 跨服圣殿每日进入次数上限

-define(VIP_SEA_TREASURE_UP,      1).   %% 璀璨之星每日免费升级船只次数
-define(VIP_SEA_TREASURE_ROB,     2).   %% 璀璨之星每日掠夺次数