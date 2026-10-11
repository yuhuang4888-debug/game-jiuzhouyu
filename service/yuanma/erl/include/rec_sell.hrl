%%%---------------------------------------------------------------------
%%% 交易相关record定义
%%%---------------------------------------------------------------------

%% 出售的商品信息
-record(sell_goods, {
    id              = 0,            %% 交易id
    player_id       = 0,            %% 出售玩家id
    sell_type       = 0,            %% 出售类型 1:市场出售 2:指定交易
    specify_id      = 0,            %% 指定交易玩家id 市场出售为0 指定交易为玩家id
    category        = 0,            %% 商品大类
    sub_category    = 0,            %% 商品子类
    gtype_id        = 0,            %% 物品类型id
    goods_num       = 0,            %% 出售数量
    unit_price      = 0,            %% 出售单价
    other           = [],           %% #goods_other{}
    time            = 0             %% 上架时间戳
}).


%% 出售的商品信息
-record(sell_goods_kf, {
    id              = 0,            %% 交易id
    server_id       = 0,            %% 出售玩家服务器id
    server_num      = 0,            %% PlayerServerNum
    vip_type        = 0,
    vip_lv          = 0,
    player_id       = 0,            %% 出售玩家id
    role_name       = "",           %% 出售玩家名字
    sell_type       = 0,            %% 出售类型 1:市场出售 2:指定交易
    specify_server  = 0,            %% 指定交易玩家服务器 市场出售为0 指定交易为玩家id
    specify_id      = 0,            %% 指定交易玩家id 市场出售为0 指定交易为玩家id
    category        = 0,            %% 商品大类
    sub_category    = 0,            %% 商品子类
    gtype_id        = 0,            %% 物品类型id
    goods_num       = 0,            %% 出售数量
    unit_price      = 0,            %% 出售单价
    other           = [],           %% #goods_other{}
    time            = 0             %% 上架时间戳
}).

-record(sell_record, {
    player_id       = 0,            %% 出售玩家id
    buyer_id        = 0,            %% 购买者玩家id
    sell_type       = 0,            %% 出售类型 1:市场出售 2:指定交易
    gtype_id        = 0,            %% 物品类型id
    goods_num       = 0,            %% 出售数量
    unit_price      = 0,            %% 出售单价
    tax             = 0,            %% 交易税(交易成功卖方扣除的)
    other           = [],           %% #goods_other{}
    time            = 0             %% 出售完成时间
}).

-record(sell_record_kf, {
    server_id       = 0             %% 出售玩家serverId
    ,server_num     = 0,            %% 出售玩家 serverNum
    player_id       = 0,            %% 出售玩家id
    buyer_server_id = 0 ,
    buyer_server_num = 0,
    buyer_id        = 0,            %% 购买者玩家id
    sell_type       = 0,            %% 出售类型 1:市场出售 2:指定交易
    gtype_id        = 0,            %% 物品类型id
    goods_num       = 0,            %% 出售数量
    unit_price      = 0,            %% 出售单价
    tax             = 0,            %% 交易税(交易成功卖方扣除的)
    other           = [],           %% #goods_other{}
    time            = 0             %% 出售完成时间
}).



-record(sell_price, {
    gtype_id        = 0,            %% 物品类型id
    unit_price      = 0,            %% 出售单价
    time            = 0             %% 出售完成时间
}).

%% 求购的商品信息
-record(seek_goods_kf, {
    id              = 0,            %% 交易id
    server_id       = 0,            %% 求购玩家serverId
    server_num      = 0,
    player_id       = 0,            %% 求购玩家id
    role_name       = <<>>,         %% 玩家名
    category        = 0,            %% 商品大类
    sub_category    = 0,            %% 商品子类
    gtype_id        = 0,            %% 物品类型id
    goods_num       = 0,            %% 出售数量
    unit_price      = 0,            %% 出售单价
    time            = 0             %% 上架时间戳
}).

%% 求购的商品信息
-record(seek_goods, {
    id              = 0,            %% 交易id
    player_id       = 0,            %% 求购玩家id
    role_name       = <<>>,         %% 玩家名
    category        = 0,            %% 商品大类
    sub_category    = 0,            %% 商品子类
    gtype_id        = 0,            %% 物品类型id
    goods_num       = 0,            %% 出售数量
    unit_price      = 0,            %% 出售单价
    time            = 0             %% 上架时间戳
}).

%% 交易进程状态
-record(sell_state, {
    p2p_sell_map            = #{},              %% 指定玩家出售的商品数据              #{player_id => [#sell_goods{}]}
    market_sell_map         = #{},              %% 市场在售的商品数据                  #{type => #{subtype => [#sell_goods{}]}}
    player_market_sell_map  = #{},              %% 玩家在市场出售的商品信息            #{player_id => [#sell_goods{}]} copy的一份数据 方便查找，后期如果占用内存过大需要删掉改成直接查找market_sell_map
    sell_record_list        = [],               %% 物品成交记录                        [#sell_record{}]
    sell_price_map          = #{},               %% 物品7天出售单价最高前五条数据Map    #{gtype_id => [#sell_price{}]}
    category_change         = #{},              %% #{category=>true|false}
    seek_map                = #{},              %% 求购map
    seek_ids                = [],               %% 求购id列表，按求购时间排序
    player_seek_map         = #{},              %% playerid => 求购id列表
    min_expire_time         = 0                 %% 记录下一个要过期的上架商品(减少每分钟去遍历检查过期商品的次数)
    ,kf_status              = 0                 %% 0 未开启 1 开启
    ,kf_open_time           = 0                 %% 开启时间
    ,open_kf_ref            = []                %%  开启定时器
}).


%% 交易进程状态用区域划分
-record(sell_state_zone, {
    zone = 0 ,
    p2p_sell_map            = #{},              %% 指定玩家出售的商品数据              #{player_id => [#sell_goods{}]}
    market_sell_map         = #{},              %% 市场在售的商品数据                  #{type => #{subtype => [#sell_goods{}]}}
    player_market_sell_map  = #{},              %% 玩家在市场出售的商品信息            #{player_id => [#sell_goods{}]} copy的一份数据 方便查找，后期如果占用内存过大需要删掉改成直接查找market_sell_map
    sell_record_list        = [],               %% 物品成交记录                        [#sell_record{}]
    sell_price_map          = #{},               %% 物品7天出售单价最高前五条数据Map    #{gtype_id => [#sell_price{}]}
    category_change         = #{},              %% #{category=>true|false}
    seek_map                = #{},              %% 求购map
    seek_ids                = [],               %% 求购id列表，按求购时间排序
    player_seek_map         = #{}              %% playerid => 求购id列表
%%    min_expire_time         = 0                 %% 记录下一个要过期的上架商品(减少每分钟去遍历检查过期商品的次数)
}).



%% 交易进程状态用区域划分
-record(sell_state_kf, {
    zone_map                 = #{}                %% #{zone_id => #sell_state_zone{}}
    ,min_expire_time          = 0                 %% 记录下一个要过期的上架商品(减少每分钟去遍历检查过期商品的次数)
    ,connect_servers = []                         %% 连接上的服，包括合服的数据
}).

%% 系统出售配置
-record(base_sys_sell, {
    goods_id = 0
    , open_day1 = 0
    , open_day2 = 0
    , price = 0
    , group_num = 0
    , num = []   
    , replenish = 0              
}).


%% 市场(玩家身上)
-record(status_sell, {
    public_cd = 0,        %% 公共CD
    goods_cd_maps = #{},  %% 市场物品cd  #{ sell_id => {SellId, LastTime}}
    goods_cd = #{}        %% 上架物品CD  #{ goods_id => {GoodsId, LastTime}}
}).

-define(SHOUT_TV_ID, 3).  %% 喊话ID

%% --------------------------------- %% ---------------------------------
-define (SELL_TYPE_MARKET,  1).                     %% 出售类型: 市场出售
-define (SELL_TYPE_P2P,     2).                     %% 出售类型: 指定交易
-define (SELL_TYPE_SEEK,     3).                     %% 出售类型: 求购交易

%% --------------------------------- %% ---------------------------------
-define(LOG_DOWN_TYPE_MANUAL,       1).                      %% 下架日志类型: 手动下架
-define(LOG_DOWN_TYPE_AUTO,         2).                      %% 下架日志类型: 自动下架
-define(LOG_DOWN_TYPE_SELL,         3).                      %% 下架日志类型: 商品出售完毕下架

-define(SELL_PRICE_REFER_NUM, 5).                   %% 计算物品出售价格需要多少条出售记录数据参考
-define(SELL_PRICE_REFER_EXPIRED_TIME, 86400 * 7).  %% 计算物品出售价格参考什么时间内的成交记录

% -define(SELL_EXPIRED_TIME_MARKET,   3600).          %% 市场上架商品的有效时间 读后台配置
% -define(SELL_EXPIRED_TIME_P2P,      3600).          %% 指定玩家出售商品的有效时间 读后台配置

-define(MARKET_SELL_MAX_NUM, 8).
-define(P2P_SELL_MAX_NUM, 5).

-define(REFRESH_TIME, 4 * 3600).                    %% 每天凌晨4天刷新市场的相关数据

-define(FILTER_TYPE_KEY_WORDS, 1).                  %% 通过物品名字筛选物品
-define(FILTER_TYPE_STAGE_AND_STAR, 2).             %% 通过物品星阶数筛选物品
-define(FILTER_TYPE_GOODS_TYPE_ID, 3).              %% 通过物品类型id筛选物品
-define(FILTER_TYPE_SUBCATEGORY_STAGE_AND_STAR, 3). %% 通过物品类型出售子类+星阶数筛选物品

%% 打包商品出售列表的类型
-define(PACK_TYPE_MARKET,           1).             %% 市场
-define(PACK_TYPE_SELL_TO_ME,       2).             %% 指定出售给自己
-define(PACK_TYPE_SELL_TO_OTHER,    3).             %% 指定出售给其他人

%% 交易记录目前除了展示以及计算当天指定玩家交易次数暂无它用
% -define(SELL_RECORD_EXPIRED_TIME, 86400).         %% 交易记录过期时间 读后台配置
%% --------------------------------- %% ---------------------------------

-define(sql_sell_insert,
    <<"insert into `sell_list`(`id`, `player_id`, `sell_type`, `specify_id`, `gtype_id`, `category`, `sub_category`,
        `goods_num`, `unit_price`, `extra_attr`, `time`) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p)">>).
-define(sql_sell_select,
    <<"select `id`, `player_id`, `sell_type`, `specify_id`, `gtype_id`, `category`, `sub_category`, `goods_num`, `unit_price`,
        `extra_attr`, `time` from `sell_list`">>).
-define(sql_sell_record_insert,
    <<"insert into `sell_record`(`player_id`, `buyer_id`, `sell_type`, `gtype_id`, `goods_num`, `unit_price`,
        `tax`, `extra_attr`, `time`) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p)">>).
-define(sql_sell_record_select,
     <<"select `player_id`, `buyer_id`, `sell_type`, `gtype_id`, `goods_num`, `unit_price`,
        `tax`, `extra_attr`, `time` from `sell_record`">>).
-define(sql_sell_num_update,     <<"update `sell_list` set `goods_num` = ~p where `id` = ~p">>).
-define(sql_sell_delete,         <<"delete from `sell_list` where `id` = ~p">>).
-define(sql_sell_delete_more,    <<"delete from `sell_list` where `id` in (~s)">>).
-define(sql_clean_sell_record,   <<"delete from `sell_record` where `time` < ~p">>).
-define(sql_reset_all_sell_time, <<"update `sell_list` set `time` = 0">>).


-define(sql_seek_insert,
    <<"insert into `seek_list`(`id`, `player_id`, `role_name`, `gtype_id`, `category`, `sub_category`,
        `goods_num`, `unit_price`, `time`) values(~p, ~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_seek_select,
    <<"select `id`, `player_id`, `role_name`, `gtype_id`, `category`, `sub_category`, `goods_num`, `unit_price`,
        `time` from `seek_list`">>).
-define(sql_seek_num_update,     <<"update `seek_list` set `goods_num` = ~p where `id` = ~p">>).
-define(sql_seek_delete,         <<"delete from `seek_list` where `id` = ~p">>).
-define(sql_seek_delete_more,    <<"delete from `seek_list` where `id` in (~s)">>).
-define(sql_reset_all_seek_time, <<"update `seek_list` set `time` = 0">>).

%%=========================================kf=========================================================================

-define(GLOBAL_151_KF_AUCTION_ID, 2).
-define(GLOBAL_151_KF_IS_OPEN,   1).

%%  `vip_type` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '玩家vip类型',
%%	 `vip_lv` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '玩家vip等级',
-define(sql_sell_insert_kf,
    <<"insert into `sell_list_kf`(`id`, `server_id`,`server_num`,`player_id`, `role_name`,`vip_type`, `vip_lv`, `sell_type`,
    `specify_server`,`specify_id`, `gtype_id`, `category`, `sub_category`,
        `goods_num`, `unit_price`, `extra_attr`, `time`) values(~p, ~p, ~p, ~p, '~s', ~p, ~p,~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p)">>).
-define(sql_sell_select_kf,
    <<"select `id`, `server_id`,`server_num`,`player_id`, `role_name`, `vip_type`, `vip_lv`, `sell_type`, `specify_server`,`specify_id`, `gtype_id`, `category`, `sub_category`, `goods_num`, `unit_price`,
        `extra_attr`, `time` from `sell_list_kf`">>).
-define(sql_sell_record_insert_kf ,
    <<"insert into `sell_record_kf`(`server_id`, `server_num`, `player_id`, `buyer_server_id`,`buyer_server_num`,
    `buyer_id`, `sell_type`, `gtype_id`, `goods_num`, `unit_price`,
        `tax`, `extra_attr`, `time`) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p)">>).
-define(sql_sell_record_select_kf,
    <<"select `server_num`, `server_id`, `player_id`, `buyer_server_id`,`buyer_server_num`, `buyer_id`, `sell_type`, `gtype_id`, `goods_num`, `unit_price`,
        `tax`, `extra_attr`, `time` from `sell_record_kf`">>).
-define(sql_sell_num_update_kf,     <<"update `sell_list_kf` set `goods_num` = ~p where `id` = ~p">>).
-define(sql_sell_delete_kf,         <<"delete from `sell_list_kf` where `id` = ~p">>).
-define(sql_sell_delete_more_kf,    <<"delete from `sell_list_kf` where `id` in (~s)">>).
-define(sql_clean_sell_record_kf,   <<"delete from `sell_record_kf` where `time` < ~p">>).
-define(sql_reset_all_sell_time_kf, <<"update `sell_list_kf` set `time` = 0">>).


-define(sql_seek_insert_kf,
    <<"insert into `seek_list_kf`(`id`, `server_id`, `server_num`,`player_id`, `role_name`, `gtype_id`, `category`, `sub_category`,
        `goods_num`, `unit_price`, `time`) values(~p, ~p, ~p, ~p,'~s', ~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_seek_select_kf,
    <<"select `id`, `server_id`, `server_num`,`player_id`, `role_name`, `gtype_id`, `category`, `sub_category`, `goods_num`, `unit_price`,
        `time` from `seek_list_kf`">>).
-define(sql_seek_num_update_kf,     <<"update `seek_list_kf` set `goods_num` = ~p where `id` = ~p">>).
-define(sql_seek_delete_kf,         <<"delete from `seek_list_kf` where `id` = ~p">>).
-define(sql_seek_delete_more_kf,    <<"delete from `seek_list_kf` where `id` in (~s)">>).
-define(sql_reset_all_seek_time_kf, <<"update `seek_list_kf` set `time` = 0">>).