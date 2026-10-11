%%%------------------------------------
%%% @Module  : flower.hrl
%%% @Author  : zengzy
%%% @Created : 2017-06-30
%%% @Description: 花语和鲜花
%%%------------------------------------

-define(FLOWER_RECORD_NUM_LIMIT,    80).            %% 送花记录保存上限
-define(RECORD_VAILD_TIME,          3 * 86400).     %% 送花记录有效期

%% 鲜花礼物配置
-record(flower_gift_cfg, {
    goods_id = 0,
    intimacy = 0,
    charm = 0,
    fame = 0,
    need_lv = 0,
    need_vip = 0,
    is_sell = 0,
    is_tv = 0,
    effect_type = 0,
    effect = undefined
    }).

-record(fame_lv_cfg, {
    lv = 0,
    color = 0,
    name = "",
    fame = 0,
    attr = []
    }).

-record(flower, {
    flower_num = 0,         %% 鲜花数量
    charm = 0,              %% 魅力值
    fame = 0,               %% 名誉
    attr = []               %% 属性
    }).

%%鲜花榜
-record(flower_rank, {
    id = 0,
    rank = 0,
    sex = 0,
    goods_reward = [],
    name_reward = 0,
    red_packet_reward = 0,
    guild_reward = []
    }).

%%花语等级记录
-record(flower_level, {
    grade_id = 0,
    color = undefined,
    flower_name = undefined,
    % need_value_min = 0,
    need_value_max = 0,
    attr_list = [],
    add_power = 0
    }).

%% 赠送鲜花礼物记录
-record(flower_gift_record, {
    id = 0,
    role_id = 0,
    sender_id = 0,
    sender_name = <<>>,
    sender_serid = 0,
    sender_sernum = 0,
    goods_id = 0,
    goods_num = 0,
    anonymous = 0,
    is_thanks = 0,
    time = 0
    }).

%%查询语句
-define(sql_get_gift_record, <<"select id, role_id, sender_id, sender_name, sender_serid, sender_sernum, goods_id, goods_num, anonymous, is_thanks, time from flower_gift_record where role_id = ~p order by id asc">>).
-define(sql_sel_role_flower_data, <<"select charm, fame, flower_num from `flower` where role_id = ~p limit 1">>).
-define(sql_get_gift_record_count, <<"select count(id) from flower_gift_record where role_id = ~p">>).
-define(sql_get_gift_record_min_id, <<"select min(id) from flower_gift_record where role_id = ~p">>).
%%删除语句
-define(sql_del_gift_record_by_id, <<"delete from `flower_gift_record` where id = ~p">>).
-define(sql_del_gift_record_out_time, <<"delete from `flower_gift_record` where time <= ~p">>).
%%更新语句
-define(sql_insert_flower_gift_record, <<"insert into `flower_gift_record` (id, role_id, sender_id, sender_name, sender_serid, sender_sernum, goods_id, goods_num, anonymous, is_thanks, time) values (~p, ~p, ~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_update_flower_thanks_record, <<"update `flower_gift_record` set is_thanks=~p where id=~p">>).
-define(sql_insert_flower, <<"insert into `flower` (role_id, charm, fame, flower_num) values(~p, ~p, ~p, ~p)">>).
-define(sql_update_flower_data, <<"update `flower` set charm = ~p, fame = ~p, flower_num = ~p where role_id = ~p">>).
-define(sql_update_charm, <<"update `flower` set charm = ~p where role_id = ~p">>).
-define(sql_update_fame, <<"update `flower` set fame = ~p where role_id = ~p">>).