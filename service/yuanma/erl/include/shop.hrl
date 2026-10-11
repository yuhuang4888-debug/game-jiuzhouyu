%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%% 商城
%%% @end
%%% Created :  3 Nov 2017 by root <root@localhost.localdomain>

-define(SHOP_WEEK,    1).        %% 每周限购商城
-define(SHOP_DIAMOND, 2).        %% 钻石商城
-define(SHOP_BGOLD,   3).        %% 绑钻商城
-define(SHOP_FIGURE,  4).        %% 外观
-define(SHOP_NORMAL,  5).        %% 常用道具
-define(SHOP_GLORY,   6).        %% 荣耀商城
-define(SHOP_SEAL,    7).        %% 领地商城
-define(SHOP_MEDAL,   8).        %% 勋章商城
-define(SHOP_3V3,     9).        %% 3v3商城
-define(SHOP_SUPVIP, 10).        %% 至尊vip商城
-define(SHOP_EUDEMONS, 11).        %% 圣兽领商店
-define(SHOP_RDUNGEON, 12).        %% 跟人排行本商店
-define(SHOP_LUCKY, 13).        %% 幸运商店
-define(SHOP_DRACONIC, 14).        %% 龙语商店
-define(SHOP_GOD_COURT, 15).        %% 神庭商店
-define(SHOP_PRESITIGE, 16).        %% 声望商店
-define(SHOP_ZEN_SOUL, 17).         %% 战魂商城
-define(SHOP_NIGHT_GHOST, 18).      %% 百鬼夜行

% 商店类型列表
-define(SHOP_TYPE_LIST, [
    ?SHOP_WEEK, ?SHOP_DIAMOND, ?SHOP_BGOLD, ?SHOP_FIGURE, ?SHOP_NORMAL,
    ?SHOP_GLORY, ?SHOP_SEAL, ?SHOP_MEDAL, ?SHOP_3V3, ?SHOP_SUPVIP,
    ?SHOP_EUDEMONS, ?SHOP_RDUNGEON, ?SHOP_LUCKY, ?SHOP_DRACONIC, ?SHOP_GOD_COURT,
    ?SHOP_PRESITIGE, ?SHOP_ZEN_SOUL, ?SHOP_NIGHT_GHOST
]).


-define(QUATO_TYPE_NONE,      0).   %% 无限购
-define(QUATO_TYPE_DAILY,     1).   %% 每日限购
-define(QUATO_TYPE_WEEK,      2).   %% 每周限购
-define(QUATO_TYPE_LIFE,      3).   %% 终生限购
-define(QUATO_TYPE_TIME,      4).   %% 时间限购


%% 折扣基数
-define(BASE_DISCOUNT, 100).

%%商店表
-record(shop, {            %% base_shop
    key_id,                %% 自增ID 唯一ID
    shop_type=0,           %% 商店类型， 1-每周限购，2-常用道具，3-绑定元宝，4-时装外形，5-终生商城
    shop_subtype_list=[],  %% 商品子标签列表
    career = [],           %% 职业可见
    rank=0,                %% 排序ID 道具显示在商城界面的顺序，由小到大显示，可重复
    goods_id=0,            %% 物品类型ID
    num = 0,               %% 单次出售个数 默认1
    ctype = 0,             %% 价格类型：1-钻石，2-绑定钻石，其他待定  23-荣耀点
    price=0,               %% 出售价格
    discount=0,            %% 折扣：默认100
    quota_type = 0,        %% 限购类型 0：无， 1：每日限购，2：每周限购，3：终生限购
    quota_num = 0,         %% 限购数量
    on_sale = 0,           %% 该道具在商城出售的开始出售的开服天数
    halt_sale = 0,         %% 该道具在商城出售的结束出售的开服天数
    wlv_sale = 0,          %% 默认是0,0为不限制，若有则为到该等级开始出售
    wlv_unsale = 0,        %% 默认是0,0为不限制，若有则为到该等级停止出售
    condition = [],        %% 否买条件：不限时默认[]，根据需求填条件[{lv,122,123},{vip,3}],可同时填多个
    bind = 0,              %% 是否绑定：默认是0,0为不绑定，1为绑定
    %% reset = 0,             %% 默认是0不限制购买，1-每周一0点重置，2-每天0点重置，3-终生不重置(暂时不用)
    counter_module = 0,    %% 模块id
    counter_id = 0,        %% 次数id(由商店类型+模块id=确定)(根据配置这个在哪里计数器类型来重置)
    turn = []              %% 限制##不仅仅是转生,用于判断是否显示{turn,Turn}:转生{trigger_task, TaskId}:正在接取的任务
}).


%% -------------------------- 神秘商店宏定义 ---------------------------
%%-define(SELL_NUM,	 8).	%%上架商品数量
%%-define(REFRESH,	 7200). %%系统刷新时间 (s)

-define(SHOP_TYPE_DEMON,  1).	%%使魔商店类型
-define(SHOP_TYPE_DRAGON, 2).	%%龙纹商店类型

%%分职业的商店类型
-define(SHOP_TYPE_CAREER, [?SHOP_TYPE_DEMON,?SHOP_TYPE_DRAGON]).

-define(MUST, 1).               % 必然出现
-define(RANDOM, 2).             % 随机

-define(DISCOUNT,	      1).	%%有折扣
-define(NOT_DISCOUNT,     2).	%%无折扣

-define(NOT_BUY,1).             % 未购买
-define(HAS_BUY,2).             % 已购买

%%玩家功能内商店记录  pS
-record(status_func,{
    func_list = []		%%格式 [{商店类型Type,手动刷新次数,最后刷新时间}]
}).

-record(status_shop,{
    shop_goods = [],	%%格式 #shop_goods{}
    role_hit = #{},     %%玩家手动刷新，格式  type => [{配置id,折扣,消耗]
    role_buy = #{}		%%玩家当轮购买记录  type => [ {roleid ,[{id,num}]} ]
}).

-record(shop_goods,{
    key = 0,			%% 键 {type,career}
    type = 0,
    career = 0,
    sell_list = [],	    %% {配置id,折扣,消耗}
    last_sell_time = 0,	%% 上架时间
    ref = undefined	    %% 刷新定时器

}).

%%商品配置
-record(base_shop_good,{    % base_mystery_shop_good
    id = 0,                 % 配置id
    type = 0,               % 类型
    career = 0,             % 职业
    goods = [],             % 商品
    price_type = 0,         % 购买类型
    old_price = 0,          % 原价
    weight = 0,             % 权重
    discount= [] ,          % 折扣价
    show_type = 0 ,         % 出现类型 1：出现 2：随机
    reborn = [] ,           % 转生
    day = [],               % 开服天数
    role_lv= [],            % 角色等级
    server_lv = [],         % 服务器等级
    limit = 0               % 数量限制
}).



-define(sql_mystery_shop_role_select, " SELECT type,hit_num,time FROM `mystery_shop_role` where role_id=~p ").
-define(sql_mystery_shop_role_replace, "replace into `mystery_shop_role` (role_id, type, hit_num, time) values (~p,~p,~p,~p) ").

%%商店
-define(sql_mystery_shop_goods_select, " SELECT type,career,sell_list,last_sell_time FROM `mystery_shop_goods` ").
-define(sql_mystery_shop_goods_replace, "replace into `mystery_shop_goods` (type, career, sell_list, last_sell_time) values (~p,~p,'~s',~p) ").
-define(sql_mystery_shop_buy_select, " SELECT role_id, type, sell_list, buy_list FROM `mystery_shop_buy` where role_id=~p").
-define(sql_mystery_shop_buy_replace, "replace into `mystery_shop_buy` (role_id,type,sell_list,buy_list) values (~p,~p,'~s','~s') ").
