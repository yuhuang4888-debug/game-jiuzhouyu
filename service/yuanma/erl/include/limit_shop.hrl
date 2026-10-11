%%%--------------------------------------
%%% @Module  : limit_shop.hrl
%%% @Author  : huyihao
%%% @Created : 2018.04.08
%%% @Description:  神秘限购
%%%--------------------------------------

-record(limit_shop_status, {
    role_id = 0,
    sell_list = [],
    close_timer = []
}).

-record(limit_shop_sell, {
    sell_id = 0,
    start_time = 0,
    buy_num = 0
}).

-record(limit_shop_sell_con, {
    sell_id = 0,
    goods_list = [],
    sell_name = "",
    cost_list = [],
    discount = 0,
    limit_num = 0,
    limit_time = 0,
    start_lv = 0
}).

-define(SelectLimitShopSellSql,
    <<"SELECT `role_id`, `sell_id`, `start_time`, `buy_num` FROM `limit_shop_sell` WHERE `role_id` = ~p">>).
-define(ReplaceLimitShopSellAllSql,
    <<"REPLACE INTO `limit_shop_sell` (`role_id`, `sell_id`, `start_time`, `buy_num`) values ~s">>).
-define(DeleteLimitShopSellSql,
    <<"DELETE FROM `limit_shop_sell` WHERE `role_id`= ~p">>).