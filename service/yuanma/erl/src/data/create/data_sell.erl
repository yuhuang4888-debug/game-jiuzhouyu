%%%---------------------------------------
%%% @Module  : data_sell
%%% @Description : 市场配置
%%%---------------------------------------
-module(data_sell).
-compile(export_all).
-include("rec_sell.hrl").


get_cfg(specify_sell_times_limit) ->15;
get_cfg(transaction_times_limit) ->0;
get_cfg(open_lv) ->90;
get_cfg(market_max_sell_num) ->8;
get_cfg(p2p_max_sell_num) ->3;
get_cfg(sell_expired_time_p2p) ->86400;
get_cfg(sell_expired_time_market) ->86400;
get_cfg(sell_record_expired_time) ->604800;
get_cfg(specify_sell_need_vip_lv) ->4;
get_cfg(seek_expired_time_market) ->86400;
get_cfg(up_percent) ->100;
get_cfg(down_percent) ->90;
get_cfg(seek_times_limit) ->6;
get_cfg(subtype_count) ->[[1,6],[2,7],[3,16],[4,11],[5,6],[6,4],[7,4],[8,10]];
get_cfg(sell_gold_max) ->[{0,10000},{300,10000}];
get_cfg(kf_open_day_min) ->30;
get_cfg(kf_open_day_max) ->40;
get_cfg(kf_open_lv) ->520;
get_cfg(public_shout_cd) ->30;
get_cfg(shout_goods_cd) ->60;
get_cfg(_Key) ->[].


get_sub_category(1)->[0,1,2,3,4,5,6];
get_sub_category(2)->[0,1,2,3,4,5,6,7];
get_sub_category(3)->[0,1,3,5,6,8,9,10,11,12,13,14,15,16];
get_sub_category(4)->[0,1,2,3,4,5,6,7,8,9,10,11];
get_sub_category(5)->[0,1,2,3,4,5,6];
get_sub_category(6)->[0,1,2,3,4];
get_sub_category(7)->[0,1,2,3,4];
get_sub_category(8)->[0,1,2,3,4,5,6,7,8,9,10];
get_sub_category(9)->[1,2,3,4];
get_sub_category(_Type) ->[].

