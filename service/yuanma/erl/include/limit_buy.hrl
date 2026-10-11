%%-----------------------------------------------------------------------------
%% @Module  :       limit_buy.hrl
%% @Author  :       huyihao
%% @Email   :       huyihao@suyougame.com
%% @Created :       2018-3-2
%% @Description:    特惠商城
%%-----------------------------------------------------------------------------

-record(limit_buy_state, {
    limit_buy_list = []
}).

-record(limit_buy_info, {
    subtype = 0,
    grade_num_list = []
}).

-record(limit_buy_num, {
    grade_id = 0,
    grade_num = 0,
    player_num_list = []
}).

-define(SelectLimitBuyDailyNumALLSql,
    <<"SELECT `subtype`, `grade`, `daily_get_num` FROM `limit_buy_daily_num`">>).
-define(ReplaceLimitBuyDailyNumSql,
    <<"REPLACE INTO `limit_buy_daily_num` (`subtype`, `grade`, `daily_get_num`) VALUES (~p, ~p, ~p)">>).
-define(DeleteLimitBuyDailyNumAllSql,
    <<"TRUNCATE TABLE `limit_buy_daily_num`">>).

-define(SelectLimitBuyDailyPlayerALLSql,
    <<"SELECT `subtype`, `grade`, `role_id`, `buy_num` FROM `limit_buy_daily_player`">>).
-define(ReplaceLimitBuyDailyPlayerAllSql,
    <<"REPLACE INTO `limit_buy_daily_player` (`subtype`, `grade`, `role_id`, `buy_num`) VALUES ~s">>).
-define(DeleteLimitBuyDailyPlayerAllSql,
    <<"TRUNCATE TABLE `limit_buy_daily_player`">>).