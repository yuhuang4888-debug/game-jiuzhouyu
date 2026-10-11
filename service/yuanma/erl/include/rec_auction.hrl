%%%---------------------------------------------------------------------
%%% 拍卖行相关record定义
%%%---------------------------------------------------------------------

%% 拍卖配置
-record (base_auction_goods, {
	no          = 0,                    %% 序号 (客户端做主键用)
	goods_id	= 0, 					%% 拍品id
	server_lv   = 0,
	name        = "",                   %% 拍品名字
	wlv1        = 0,					%% 世界等级1
	wlv2        = 0,                    %% 世界等级2
	type 		= 0,            		%% 商品大类
	gold_type 	= 0,					%% 消耗钻石类型
	gtype_id    = 0,                    %% 物品id
	goods_num   = 0,                    %% 物品数量
	base_price  = 0,                    %% 起拍价
	add_price   = 0,                    %% 一次加价
	one_price   = 0,                    %% 一口价
	unsold_price = [],                  %% 流拍价格
	tv = 0                              %% 是否传闻
}).

%% 系统拍卖时间配置
-record (base_auction_time, {
	id 			= 0,					%% 系统id
	time 		= {0,0,0}, 				%% 开始时间{小时,分钟,秒}
	sys_goods 	= [] 					%% 系统物品[{拍品id,数量}...]
}).

%% 拍卖限制
-record(base_auction_produce_limit, {
		mod_id = 0,						%% 模块id
		id = 0,							%% 物品类型id
		day_limit = 0,					%% 间隔天数
		num_limit = 0					%% 间隔天数内最大数量限制
	}).

%% -------------------------------- %% --------------------------------

%% 拍卖场次
-record (auction, {
	auction_id 	= 0,  					%% 拍卖会场次
	auction_type= 0,					%% 拍卖类型
	module_id 	= 0,					%% 功能id
	is_cls = 0,                         %% 是否跨服拍卖
	authentication_id = 0,              %% 认证id(由发起拍卖的功能带过来，用于确认参与该场次拍卖的玩家)
	zone_id = 0,              			%% 区域id(只有跨服拍卖才有效)
	auction_status=0, 					%% 拍卖会状态
	time 		= 0, 					%% 拍卖会开始时间戳
	last_time   = 0, 					%% 场次更新时间    
	guild_award_map = #{},				%% 公会奖励信息 				#{guild_id => award_status}
	delay_guild_map = #{}, 				%% 竞价延时的帮派               #{guild_id => {delay_num, endtime} }
	to_world_list 	= [], 				%% 延时流入世界的物品（同一场拍卖不同时间结束的未拍卖物品，统一流入世界）
	estimate_bonus_map= #{}, 			%% 各公会预计分红总额 			#{guild_id => estimate_bonus }
	join_log_map  = #{}, 				%% 活动参与日志 #{player_id => #join_log{}}   	注：会日清
	act_join_num_map= #{} 				%% 对应活动开启时各公会参与人数 #{guild_id => join_num }
}).
	
%% 拍卖物品
-record (auction_goods, {
	goods_id 	= 0,					%% 拍卖物唯一id
	auction_id 	= 0,  					%% 拍卖会场次
	goods_type  = 0, 					%% 拍卖品id
	guild_id    = 0, 					%% 公会id
	auction_type= 0,					%% 拍卖类型 	:1公会拍卖，2世界拍卖
	type 		= 0, 					%% 物品类目	    :用于客户端分类显示，如装备、称号
	module_id 	= 0, 					%% 功能id	    :0为系统拍卖功能id，公会拍卖不为0
	goods_status= 0,		 			%% 拍卖物状态   :1拍卖中，2已拍出
	next_price  = 0,					%% 下一次竞价   :无人竞价时，读取交易基准价
	now_price   = 0,					%% 当前竞价 	:也即当前拍得最高竞价
	start_time	= 0,					%% 开始拍卖时间
	wlv			= 0,                    %% 世界等级
	info_list 	= [],					%% 拍卖详细记录 [#auction_info{}|...]
	delay_num 	= 0 					%% 延时次数
}).

%% 拍卖详细记录
-record (auction_info, {
	player_id 	= 0, 					%% 竞拍人id
	server_id   = 0,                    %% 竞拍人服务器id
	price_type  = 0, 					%% 竞拍类型
	price  		= 0, 					%% 竞价 
	price_list  = [], 					%% 竞价详细 [{?TYPE_BGOLD, 0, Num},{?TYPE_GOLD, 0, Num}]
	time 		= 0 					%% 更新时间
}).

%% 拍卖记录
-record (auction_log, {
	module_id 	= 0,					%% 功能id
	goods_type  = 0, 					%% 物品类型id
	wlv 		= 0,					%% 世界等级
	price  		= 0, 					%% 竞价 
	time 		= 0, 					%% 更新时间
	to_world 	= 0 					%% 是否流拍至世界：0否，1是
}).

%% 分红记录
-record (bonus_log, {
	module_id 	= 0,					%% 功能id
	gold        = 0,                    %% 分红钻石
	bgold  		= 0, 					%% 分红绑钻 
	time 		= 0 					%% 更新时间
}).

%% 活动参与记录
-record (join_log, {
	player_id 	= 0,					%% 
	guild_id    = 0,                
	server_id  	= 0					
}).

%% 分红信息
-record (bonus_info, {
	module_id 	= 0,					%% 功能id
	gold        = 0,                    %% 分红总钻石
	bgold  		= 0 					%% 分红总绑钻 
}).

%% 个人拍卖记录
-record (player_auction_log, {
	server_id   = 0,                    %% 服务器id
	op_type     = 0,                    %% 1 竞拍 2 竞拍失败返还
	module_id 	= 0,					%% 功能id
	price_type  = 0,                    %% 竞价类型
	gold        = 0,                    %% 钻石
	bgold       = 0,                    %% 绑钻
	goods_type  = 0, 					%% 物品类型id
	wlv 		= 0,					%% 世界等级
	time 		= 0 					%% 更新时间
}).


%% 拍卖状态数据
-record (auction_state, {
	auction_map = #{}, 					%% 拍卖会场次 	#{ auction_id => #auction{} }	
	goods_map   = #{}, 					%% 拍卖物品		#{ goods_id   => #auction_goods{} }
	guild_map 	= #{}, 					%% 公会拍卖目录 #{ guild_id   => [{module_id, [goods_id] } |...] }
	world_map 	= #{}, 					%% 世界拍卖目录 #{ type       => [goods_id|...] }
	guild_log_map = #{}, 				%% 公会拍卖记录 #{ guild_id   => [#auction_log{}|...] } 		注：会日清(已不用)
	world_log_list= [], 				%% 世界拍卖记录 [ #auction_log{}|...] 							注：会日清(已不用)
	player_log_map = #{},               %% 个人交易记录 #{player_id => [#player_auction_log{}]}
	bonus_log_map = #{},           	   %% 玩家分红记录 #{player_id => [#bonus_log{}]}               注：周一4点清
	bonus_map = #{}                    %% 玩家分红信息(从bonus_record汇总得到) #{player_id => [#bonus_info{}]}
}).

-record(static_state, { 
        static_map = #{}                %% 拍卖统计 mod => [#static_record{}]
    }).

-record(static_record, {
        mod = 0,                        %% 模块id
        goods_type = 0,                 %% 物品类型id
        produce_time = 0,               %% 第一次产出时间
        num = 0                         %% 产出数量
    }).

%%% 跨服拍卖record
%% 为了兼容本服的拍卖，guild在跨服中可表示为阵营
-record (kf_auction_state, {
	kf_server_id = 0,
	auction_map = #{}, 					%% 拍卖会场次 	#{ auction_id => #auction{} }	
	goods_map   = #{}, 					%% 拍卖物品		#{ goods_id   => #auction_goods{} }
	guild_map 	= #{}, 					%% 公会/阵营拍卖目录 #{ guild_id   => [{module_id, [goods_id] } |...] }
	world_map 	= #{}, 					%% 世界拍卖目录 #{ type       => [goods_id|...] }
	guild_log_map = #{}, 				%% 公会/阵营拍卖记录 #{ guild_id   => [#auction_log{}|...] } 		注：会日清(已不用)
	world_log_list= [] 				    %% 世界拍卖记录 [ #auction_log{}|...] 							注：会日清(已不用)
}).

%% --------------------------------- %% ---------------------------------
%%% @comment DEBUG_CFG
%% --------------------------------- %% ---------------------------------
%%-define(DEBUG_CFG, true).

-ifdef(DEBUG_CFG).
-define(GUILD_NOTICE1_BEFORE,   1*60). 		%% 公会拍卖预告提前时间(秒)
-define(WORLD_NOTICE1_BEFORE,   1*60). 		%% 世界拍卖预告提前时间(秒)
-define(GUILD_AUCTION_DURATION(ModuleId),	data_auction:get_guild_auction_duration(ModuleId)).   	%% 公会拍卖时长(秒)
-define(WORLD_AUCTION_DURATION(ModuleId),	data_auction:get_world_auction_duration(ModuleId)).	%% 世界拍卖时长(秒)
-else.
-define(GUILD_NOTICE1_BEFORE,   5*60). 		%% 公会拍卖预告提前时间(秒)
-define(WORLD_NOTICE1_BEFORE,   5*60). 	  	%% 世界拍卖预告提前时间(秒)
-define(GUILD_AUCTION_DURATION(ModuleId),	data_auction:get_guild_auction_duration(ModuleId)).   	%% 公会拍卖时长(秒)
-define(WORLD_AUCTION_DURATION(ModuleId),	data_auction:get_world_auction_duration(ModuleId)).	%% 世界拍卖时长(秒)
-endif.

%% ------------------------------- 常量配置  %% -------------------------------

-define(PRICE_ADD_RATIO, 		  0.05).%% 竞拍加价百分比
-define(NO_SELL_AWARD_RATIO,	  1). %% 未拍出的分红：物品基础价格的80%
-define(ONE_PRICE_RATIO, 	      2.5). %% 一口价是物品基础价格的2.5倍

-define(CLOSE_AUCTION_NORMAL, 	   1).  %% 关闭类型：时间到正常结束
-define(CLOSE_AUCTION_FORCE, 	   2).  %% 关闭类型：秘籍强制结束

%% ----------------------------- auction_type  %% -----------------------------
-define(AUCTION_GUILD, 1). 				%% 拍卖会类型：公会拍卖
-define(AUCTION_WORLD, 2). 				%% 拍卖会类型：世界拍卖
-define(AUCTION_KF_REALM, 3). 			%% 拍卖会类型：跨服阵营拍卖

%% ----------------------- #auction_info.price_type  %% -----------------------
-define(PRICE_TYPE_AUCTION,       1).   %% 竞拍价格类型：普通竞价
-define(PRICE_TYPE_ONE_PRICE,     2).   %% 竞拍价格类型：一口价
-define(PRICE_TYPE_ADD_PRICE,     3).   %% 竞拍价格类型：加价    注:当前是出价最高者才可以发加价类型

%% ------------------------ #auction.auction_status  %% -----------------------
-define(AUCTION_STATUS_NOTICE1,   1). 	%% 拍卖会状态：第一轮预告
-define(AUCTION_STATUS_NOTICE2,   2).	%% 拍卖会状态：第二轮预告
% -define(AUCTION_STATUS_NOTICE3,   3).	%% 拍卖会状态：第三轮预告
-define(AUCTION_STATUS_BEGIN,     4).   %% 拍卖会状态：开拍

%% ---------------------- #auction_goods.goods_status  %% ---------------------
-define(GOODS_STATUS_SELL,		  1). 	%% 拍卖物状态：待拍出
-define(GOODS_STATUS_SELLOUT,	  2). 	%% 拍卖物状态：已拍出

%% ------------------------  #auction.cfg_id %% -------------------------------
-define(DEFAULT_CFG_ID, 		   0).  %% 默认cfg_id为0

%% ------------------------  世界分红的功能id列表 -------------------------------
-define(WORLD_BONUS_MODULE, 		   data_auction:get_world_bonus_modules(1)).  %% 

-define (SQL_AUCTION_SELECT,			<<"select `auction_id`, `auction_type`, `is_cls`, `zone_id`, `module_id`, `authentication_id`, `auction_status`, `time`, `last_time` from `auction` where 1=1">>).
-define (SQL_AUCTION_INFO_SELECT, 		<<"select `goods_id`, `player_id`, `server_id`, `price_type`, `price`, `price_list`, `time` from `auction_info` where 1=1">>).
-define (SEL_AUCTION_GOODS_SELECT,		<<"select `goods_id`, `auction_id`, `goods_type`, `type`, `auction_type`, `guild_id`, `module_id`, `goods_status`, `start_time`, `wlv` from `auction_goods` where 1=1">>).
-define (SQL_AUCTION_LOG_SELECT, 		<<"select `auction_type`, `module_id`, `guild_id`, `goods_type`, `wlv`, `price`, `time`, `to_world` from `auction_log` where 1=1">>).
-define (SQL_AUCTION_GUILD_AWARD_SELECT,<<"select `auction_id`, `guild_id`, `award_status` from `auction_guild_award` where 1=1">>).
-define (SQL_AUCTION_BONUS_LOG_SELECT,  <<"select `player_id`, `module_id`, `gold`, `bgold`, `time` from `auction_bonus_log` where 1=1">>).
-define (SQL_PLAYER_LOG_SELECT, 		<<"select `player_id`, `server_id`, `op_type`, `module_id`, `price_type`, `gold`, `bgold`, `goods_type`, `wlv`, `time` from `player_auction_log` where 1=1">>).
-define (SQL_PLAYER_JOIN_LOG_SELECT, 		<<"select `auction_id`, `player_id`, `guild_id`, `server_id` from `auction_join_log` where 1=1">>).

-define (SQL_AUCTION_INSERT,			<<"insert into `auction`(`auction_id`, `auction_type`, `is_cls`, `zone_id`, `module_id`, `authentication_id`, `auction_status`, `time`, `last_time`) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).
-define (SEL_AUCTION_GOODS_INSERT,		<<"insert into `auction_goods`(`goods_id`, `auction_id`, `goods_type`, `type`, `auction_type`, `guild_id`, `module_id`, `goods_status`, `start_time`, `wlv`) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).
-define (SQL_AUCTION_INFO_INSERT, 		<<"insert into `auction_info`(`goods_id`, `auction_id`, `player_id`, `server_id`, `price_type`, `price`, `price_list`, `time`) values(~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p)">>).
-define (SQL_AUCTION_LOG_INSERT,		<<"insert into `auction_log`(`auction_type`, `module_id`, `guild_id`, `goods_type`, `wlv`, `price`, `time`, `to_world`) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).
-define (SQL_AUCTION_GUILD_AWARD_INSERT,<<"insert into `auction_guild_award`(`auction_id`, `guild_id`, `award_status`, `time`) values(~p, ~p, ~p, ~p) ">>).
-define (SQL_PLAYER_LOG_INSERT,		<<"insert into `player_auction_log`(`player_id`, `server_id`, `op_type`, `module_id`, `price_type`, `gold`, `bgold`, `goods_type`, `wlv`, `time`) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define (SQL_AUCTION_UPDATE,			<<"update `auction` set `auction_status`=~p, `last_time` =~p where `auction_id` = ~p">>).
-define (SQL_AUCTION_GOODS_UPDATE,		<<"update `auction_goods` set `goods_status`=~p, `time` =~p where `goods_id` = ~p">>).

-define (SQL_AUCTION_DELETE, 			<<"delete from `auction` where `auction_id` = ~p">>).
-define (SQL_AUCTION_INFO_DELETE, 		<<"delete from `auction_info` where `auction_id` = ~p">>).
-define (SEL_AUCTION_GOODS_DELETE, 		<<"delete from `auction_goods` where `auction_id` = ~p">>).
-define (SQL_AUCTION_LOG_TRUNCATE, 		<<"truncate table auction_log">>).
-define (SQL_AUCTION_GUILD_AWARD_DELETE,<<"delete from `auction_guild_award` where `auction_id` = ~p">>).
-define (SQL_AUCTION_JOIN_LOG_DELETE,<<"delete from `auction_join_log` where `auction_id` = ~p">>).

-define (SQL_JOIN_LOG_SELECT, 			<<"select `player_id`, `guild_id` from `join_log` where `module_id` = ~p">>).
-define (SQL_JOIN_LOG_TRUNCATE, 		<<"truncate table `join_log`">>).
-define (SQL_JOIN_LOG_DELETE_GUILD, 	<<"delete from `join_log` where guild_id =~p">>).
-define (SQL_JOIN_LOG_DELETE_MODULE,	<<"delete from `join_log` where `module_id` = ~p">>).
-define (SQL_JOIN_LOG_DELETE_PLAYER, 	<<"delete from `join_log` where player_id =~p">>).
-define (SQL_BONUS_LOG_TRUNCATE, 		<<"truncate table `auction_bonus_log`">>).
-define (SQL_PLAYER_LOG_TRUNCATE, 		<<"truncate table `player_auction_log`">>).

-define(SQL_SELECT_RECORD,  			<<"SELECT `mod`, `gtype_id`, `stime`, `num` FROM auction_static">>).
-define(SQL_UPDATE_RECORD,  			<<"REPLACE `auction_static` set `stime`=~p, `num` =~p where `mod` = ~p and `gtype_id` = ~p">>).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

