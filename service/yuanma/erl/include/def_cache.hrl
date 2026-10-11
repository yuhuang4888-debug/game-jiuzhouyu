%%%---------------------------------------------------------------------
%%% 全局缓存Key值定义
%%%---------------------------------------------------------------------

%% 全局缓存Key值定义
-define	(CACHE_KEY(Type, Key),  {Type, Key}).

%% 缓存刷新类型
-define (CACHE_REFRESH_HOT,     1). %% 缓存刷新类型：热更配置刷新
-define (CACHE_REFRESH_TWELVE,  2). %% 缓存刷新类型：24点刷新
%% -define (CACHE_REFRESH_THREE,   3). %% 缓存刷新类型：3点刷新
-define (CACHE_REFRESH_FOUR,    3). %% 缓存刷新类型：4点刷新

%%% Usage:
%%% 新增key_value缓存步骤
%%% 1. def_cache.hrl中定义一个缓存type类型
%%  需要刷新缓存的，继续步骤2,3；否则End.
%%% 2. ?CACHE_CALLBACK_LIST中添加刷新缓存回调函数 M:F()
%%% 3. 实现刷新缓存回调函数 M:F()
%%% End.

%%%---------------------------------------------------------------------
%%% 缓存type定义
%%%---------------------------------------------------------------------
-define (CACHE_PARTNER_RECRUIT,         1). %% 缓存类型：招募伙伴
-define (CACHE_TOTAL_RECHARGE,          2). %% 缓存类型：充值总额(元宝)
-define (CACHE_RECHARGE_DAILY_GIFT,     3). %% 缓存类型：充值活动-每日礼包列表
-define (CACHE_DAILY_RECHARGE,          4). %% 缓存类型：玩家每日充值金额
-define (CACHE_TOTAL_RMB,               5). %% 缓存类型：充值总额(金额)
-define (CACHE_DRUMWAR_GUESS,           6). %% 缓存类型：钻石大战临时数据

%%%---------------------------------------------------------------------
%%% 缓存刷新回调函数列表
%%%---------------------------------------------------------------------
-define (CACHE_CALLBACK_LIST,   [
    %% 基本格式(Format)
    %% {缓存type, data_module, M, F, 热更配置刷新(0否|1是), 24点刷新, 3点刷新}
    %% data_module :: atom() 配置模块名
    %% M|F         :: atom() 缓存刷新回调函数M:F()
    {?CACHE_PARTNER_RECRUIT, data_partner, lib_partner_util, update_partner_cache, 1, 0, 0},
    {?CACHE_RECHARGE_DAILY_GIFT, data_daily_gift, lib_daily_gift, update_daily_gift_cache, 0, 0, 1}
]).
