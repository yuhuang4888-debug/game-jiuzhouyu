%% 循环类型
-define (LOOP_UNLIMIT, -1). 	%% 循环类型：无限循环
-define (LOOP_LIMIT,    0). 	%% 循环类型：不循环

%% 定时器id定义
-define	(UTIMER_ID(Type, Id),  {Type, Id}).

%%%---------------------------------------------------------------------
%%% 定时器type定义
%%%---------------------------------------------------------------------

-define (TIMER_WANTED, 				1). %% 定时器类型：通缉定时器
-define (TIMER_AUCTION, 			2).	%% 定时器类型：拍卖行，状态定时器
-define (TIMER_AUCTION_DELAY, 		3).	%% 定时器类型：拍卖行，延时定时器
-define (TIMER_AUCTION_GM, 			4).	%% 定时器类型：拍卖行，状态定时器（gm专用，用于指定时间额外开场公会拍卖）
-define (TIMER_WAR_GOD,		    	5).	%% 定时器类型：荣耀战神，活动结束定时器
-define (TIMER_WAR_GOD_BROADCAST,	6).	%% 定时器类型：荣耀战神，广播阶段定时器
-define (TIMER_WAR_GOD_BATTLE, 		7).	%% 定时器类型：荣耀战神，战斗定时器
-define (TIMER_WAR_GOD_RANK, 		8).	%% 定时器类型：荣耀战神，积分排行定时器
-define (TIMER_ADVENTURE_FIND_DIFF,	9). %% 定时器类型：冒险之旅  找茬定时器
-define (TIMER_HERO_WAR_BATTLE,    10).	%% 定时器类型：英雄战场，战斗定时器
-define (TIMER_HERO_WAR_BROADCAST, 11).	%% 定时器类型：英雄战场，广播定时器
-define (TIMER_HUSONG_EXP, 		   12).	%% 定时器类型：护送，经验定时器
-define (TIMER_FLOWER_CLEAR, 	   13).	%% 定时器类型：鲜花，清除缓存定时器
-define (TIMER_LUCKY_CAT, 	   	   14).	%% 定时器类型：招财猫，延迟广播
