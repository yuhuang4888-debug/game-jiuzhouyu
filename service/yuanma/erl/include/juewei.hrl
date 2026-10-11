%%%--------------------------------------
%%% @Module  : juewei
%%% @Author  : huyihao
%%% @Created : 2017.10.24
%%% @Description:  爵位
%%%--------------------------------------

-define(OpenLv, 1).
-define(PlateGoodsId, 38040003).

-record(juewei_con, {
    juewei_lv = 0,
    juewei_name = [],
    need_power = 0,
    goods_list = [],
    attr_list = [],
    color = 0
}).

-define(SelectJueWeiSql, <<"select `juewei_lv` from `juewei_player` where `role_id` = ~p">>).
-define(ReplaceJueWeiSql, <<"replace into `juewei_player` (`role_id`, `juewei_lv`) values (~p, ~p)">>).