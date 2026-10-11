%%%---------------------------------------------------------------------
%%% 每日次数id定义
%%%---------------------------------------------------------------------

%% 背包物品
%% -define(DAILY_GOODS_DROP, 	1). 		%% 物品掉落上限
-define(DAILY_COIN_DROP, 	2). 		%% 金币掉落上限

%% 聊天系统
-define(DAILY_CHAT_WORLD, 1001).        %% 世界聊天

%% 邮件系统
-define(DAILY_SEND_MAIL, 1).            %% 发送邮件
-define(DAILY_SEND_GUILD_MAIL, 2).      %% 发送公会邮件

%% 社交系统

%% 公会系统
-define(DAILY_GUILD_DONATE, 1).         %% 公会捐赠
-define(DAILY_GUILD_GIFT_EXCHANGE, 2).  %% 公会礼包兑换

%% 公会活动

%% 公会宝箱
-define(DAILY_GUILD_DAILY_REWARD,   1). %% 每日公会宝箱领取

%% 英灵殿
%% -define(DAILY_VALHALLA_BOSS_FIRST_ATT, 1).   %% 首次攻击

%% 卢币兑换
-define(DAILY_FREE_EXCHANGE, 1).         %% 免费兑换
-define(DAILY_EXPENSE_EXCHANGE, 2).  	%% 付费兑换

%% 野外Boss
-define(DAILY_OUTSIDE_BOSS_FIRST_ATT, 1).   %% 首次攻击
-define(DAILY_OUTSIDE_BOSS_DROP_NUM, 2).    %% 每天掉落的次数

%% 签到
-define(DAILY_CHECKIN_FIRST_LOGIN, 1).   %% 七天签到：当天是否是首次登陆
-define(DAILY_CHECKIN_IS_CHECKED,  2).   %% 月签到：当天是否已签到
-define(DAILY_CHECKIN_IS_ADD,      4).   %% 月签到：当天是否因活跃度增加过补签次数

%% 伙伴
%-define(DAILY_RECRUIT_TIMES, 		1).   %% 招募每天限制

%% 商会任务
-define(DAILY_COMMERCE_FIN, 			1).   %% 商会任务 今天是否已完成
-define(DAILY_COMMERCE_SEEK_ASSIST, 	2).   %% 商会任务 求助次数
-define(DAILY_COMMERCE_ASSIST, 			3).   %% 商会任务 帮助次数
-define(DAILY_COMMERCE_TRIGGER, 		4).   %% 商会任务 今天是否已触发

%% 天空战场
-define(DAILY_SKY_PARTAKE_TIMES, 		1).   %% 天空战场 当天参与次数
-define(DAILY_SKY_APPLY_GOODS, 			2).   %% 天空战场 次数道具服用次数

%% 活动日历
-define(ACTIVITY_LIVE_DAILY, 1).           	%% 活跃度

%% 护送
-define(DAILY_ATTACK_HUSONG, 1). 			%% 打劫车队

%% 充值活动
-define(RECHARGE_WELFARE,   1).             %% 福利卡
-define(RECHARGE_GROWUP,    2).             %% 成长基金

%% 恶魔狩猎
-define(HUNTING_AWARD,   	1).             %% 恶魔狩猎固定奖励次数

%% 英雄战场
-define(HERO_WAR_ATTACK,   	1).             %% 英雄战场挑战次数

%% 藏宝图
-define(TSMAP_MYSTICAL_HELP, 1).            %% 神秘宝藏帮助次数
-define(TSMAP_FINE_HELP,    2).             %% 精致宝藏帮助次数
-define(TSMAP_DUN_HELP,     3).             %% 协助神秘洞穴次数

%% 五芒星副本
%% -define(DAILY_DUNGEON_PENTACLE_ENTER, 1).   %% 副本进入
%% -define(DAILY_DUNGEON_PENTACLE_HELP, 2).    %% 副本协助

%% 冒险副本
%% -define(DAILY_DUNGEON_RISK_ENTER, 1).       %% 副本进入
%% -define(DAILY_DUNGEON_RISK_HELP, 2).        %% 副本协助

%% 遗忘之境副本
%% -define(DAILY_DUNGEON_OBLIVION_ENTER, 1).   %% 副本进入
%% -define(DAILY_DUNGEON_OBLIVION_HELP, 2).    %% 副本协助

%% 抢滩登陆(公会战)
%% -define(DAILY_WAR_GUILD_ENTER, 1).            %% 参与次数

%% 公会红包
-define(DAILY_LUCK_RED_PACKET, 1).          %% 子类型 - 幸运红包
-define(DAILY_LUCK_RED_PIRATE_PACKET, 2).   %% 子类型 - 抢幸运红包

%% 340:邀请
%% 领取次数
-define(DAILY_INVITE_BOX_COUNT, 1).         %% 宝箱领取次数
-define(DAILY_INVITE_UPLOAD_COUNT, 2).      %% 邀请上传的次数
-define(DAILY_INVITE_REQUEST_COUNT, 3).     %% 邀请数据请求次数

%% 幻饰boss 471
-define(DAILY_DECORATION_BOSS_COUNT, 1).        %% 幻饰boss进入次数
-define(DAILY_DECORATION_BOSS_ASSIST_COUNT, 2). %% 幻饰boss协助进入次数
-define(DAILY_DECORATION_BOSS_BUY_COUNT, 3).    %% 幻饰boss购买次数
-define(DAILY_DECORATION_BOSS_ADD_COUNT, 4).    %% 幻饰boss增加进入次数