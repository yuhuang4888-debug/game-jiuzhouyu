%% ---------------------------------------------------------------------------
%% @doc data_log
%% @author ming_up@foxmail.com
%% @since  2016-08-25
%% @deprecated  data_log
%% ---------------------------------------------------------------------------
-module(data_log).

-export([get_log/1]).

%% get_log(Type) -> {表名，字段}.
get_log(log_consume_coin) ->
    {"log_consume_coin", "time, consume_type, player_id, goods_id, goods_num, cost_coin, remain_coin, about, lv"};

get_log(log_consume_gcoin) ->
    {"log_consume_gcoin", "time, consume_type, player_id, guild_id, goods_id, goods_num, cost_gcoin, remain_gcoin, about, lv"};

get_log(log_consume_gold) ->
    {"log_consume_gold", "time, consume_type, player_id, goods_id, goods_num, cost_gold, cost_bgold, remain_gold, remain_bgold, about, lv"};

get_log(log_produce_coin) ->
    {"log_produce_coin", "time, produce_type, player_id, got_coin, remain_coin, about"};

get_log(log_produce_gcoin) ->
    {"log_produce_gcoin", "time, produce_type, player_id, guild_id, got_gcoin, remain_gcoin, about"};

get_log(log_produce_gold) ->
    {"log_produce_gold", "time, produce_type, player_id, got_gold, got_bgold, remain_gold, remain_bgold, about"};

get_log(log_throw) ->
    {"log_throw" , "`time`, `type`, `pid`, `gid`, `goods_id`, `goods_num`"};

get_log(log_goods) ->
    {"log_goods", "time, type, subtype, goods_id, goods_num, player_id, remark"};

get_log(log_send_reward_result) ->
    {"log_send_reward_result", "role_id, produce_id, list, rescode, time"};

get_log(log_move_goods) ->
    {"log_move_goods", "role_id, from_loc, to_loc, succ_goods, fail_goods, time"};

get_log(log_produce_currency) ->
    {"log_produce_currency", "time, type, player_id, currency_id, got_value, remain_value, remark"};

get_log(log_gift) ->
    {"log_gift",  "time, pid, gid, goods_id, gift_id, use_num"};

get_log(log_gift_about) ->
    {"log_gift_about", "time, pid, gift_id, goods_id, goods_num"};

get_log(log_title) ->
    {"log_title", "pid, pre_title_id, title_id, cost, combat_power, time"};

get_log(log_act_reward) ->
    {"log_act_reward", "time, role_id, type, subtype, reward_id, count, ctime, utime"};

get_log(log_achv) ->
    {"log_achv", "player_id, lv, achv_id, achv_point, time"};

get_log(log_active_dsgt) ->
    {"log_active_dsgt", "player_id, dsgt_id, opr, time, expire_time, end_time"};

get_log(log_dsgt_order) ->
    {"log_dsgt_order", "player_id, dsgt_id, pre_order, new_order, cost, time"};

get_log(log_common_rank_role) ->
    {"log_common_rank_role", "role_id, rank_type, rank, value, sec_role_id, sec_value, time"};

get_log(log_common_rank_guild) ->
    {"log_common_rank_guild", "guild_id, rank, value, sec_guild_id, sec_value, time"};

get_log(log_mail_get) ->
    {"log_mail_get", "mail_id, sid, rid, title, cm_attachment, timestamp, time"};

get_log(log_mail_send) ->
    {"log_mail_send", "mail_id, sid, rid, title, cm_attachment, time"};

get_log(join_log) ->
    {"join_log", "player_id, guild_id, module_id, time"};

get_log(log_join) ->
    {"log_join", "player_id, guild_id, module_id, time"};

get_log(log_activity_live) ->
    {"log_activity_live", "role_id, ac_id, ac_sub, ac_name, live, old_live, new_live, time"};

get_log(log_shop) ->
    {"log_shop", "role_id, shop_type, goods_id, num, buy_num, money_type, sum, time"};

get_log(log_partner_break) ->
    {"log_partner_break", "role_id, partner_id, attr_before, attr_after, time"};

get_log(log_partner_equip) ->
    {"log_partner_equip", "role_id, partner_id, quality, objectlist, combat_power, time"};

get_log(log_auction_produce) ->
    {"log_auction_produce", "guild_id, module_id, auction_type, goods_list, time"};

get_log(log_auction_pay) ->
    {"log_auction_pay", "player_id, guild_id, module_id, auction_type, goods_id, type_id, wlv, pay_type, price_list, price, time"};

get_log(log_auction_pay_kf) ->
    {"log_auction_pay_kf", "player_id, name, guild_id, module_id, auction_type, goods_id, type_id, wlv, pay_type, price_list, price, time"};

get_log(log_auction_award) ->
    {"log_auction_award", "player_id, guild_id, module_id, auction_type, goods_id, type_id, price, time"};

get_log(log_auction_bonus) ->
    {"log_auction_bonus", "player_id, guild_id, module_id, money_list, time"};

get_log(log_husong_pickup) ->
    {"log_husong_pickup", "player_id, guild_id, color, line, time"};

get_log(log_husong_upgrade) ->
    {"log_husong_upgrade", "player_id, guild_id, color, cost, time"};

get_log(log_husong_driving) ->
    {"log_husong_driving", "player_id, guild_id, drive_type, time"};

get_log(log_husong_finish) ->
    {"log_husong_finish", "guild_id, finish_type, time"};

get_log(log_husong_player) ->
    {"log_husong_player", "player_id, guild_id, time"};

get_log(log_husong_attack) ->
    {"log_husong_attack", "player_id, guild_id, hp_ratio, award_list, time"};

get_log(log_ac_start) ->
    {"log_ac_start", "module, module_sub, ac_sub, state, time"};

get_log(log_custom_act) ->
    {"log_custom_act", "type, subtype, wlv, stime, etime, state, time"};

get_log(log_daily_gift) ->
    {"log_daily_gift", "player_id, produce_type, goods_id, time"};

get_log(log_resource_back) ->
    {"log_resource_back", "player_id, act_id, act_sub, cost, times, lefttimes, reward, time"};

get_log(log_tsmap) ->
    {"log_tsmap", "role_id, lv, sub_type, event_id, status, help_id, help_num, time"};

get_log(log_welfare) ->
    {"log_welfare", "role_id, type, num, op, left_count, time"};

get_log(log_fashion_collection) ->
    {"log_fashion_collection", "player_id, fashion_id, equip_id, money_cost, time"};

get_log(log_fashion_stain) ->
    {"log_fashion_stain", "player_id, fashion_id, color_had, color_id, cost, reward, time"};

get_log(log_uplv) ->
    {"log_uplv", "`pid`, `lv`, `fr`, `add_exp`, `combat_power`, `scene_id`, `time`"};

get_log(log_login) ->
    {"log_login", "`player_id`, `ip`, `time`, `accid`, `accname`, `login_type`, `combat_power`, `module_power`, `scene`, `x`, `y`, `wx_scene`"};

get_log(log_partner_learn_sk) ->
    {"log_partner_learn_sk", "player_id, partner_id, quality, skill_id, objectlist, combat_power, time"};

get_log(log_partner_promote) ->
    {"log_partner_promote", "player_id, partner_id, quality, objectlist, attr_before, attr_after, combat_power, time"};

get_log(log_partner_disband) ->
    {"log_partner_disband", "player_id, partner_info, apti_take, sk_learn, reward, time"};

get_log(log_partner_add_exp) ->
    {"log_partner_add_exp", "player_id, partner_id, quality, objectlist, old_lv, new_lv, time"};

get_log(log_partner_wash) ->
    {"log_partner_wash", "player_id, partner_id, quality, lv, objectlist, reward, attr_bf, attr_af, power_ch, sk_ch, prodigy_ch, is_replace, time"};

get_log(log_partner_recruit) ->
    {"log_partner_recruit", "player_id, log_recruit_type, objectlist, reward, partner_id, quality, combat_power, attr_str, sk_list, prodigy, time"};

get_log(log_coin_exchange) ->
    {"log_coin_exchange", "player_id, vip_lv, exchanged, left_exchanged, gold_cost, coin_get, time"};

get_log(log_daily_checkin) ->
    {"log_daily_checkin", "player_id, vip_lv, retro, day, rewards_output, time"};

get_log(log_online_reward) ->
    {"log_online_reward","role_id, get_time, reward, online_time"};

get_log(log_total_checkin) ->
    {"log_total_checkin", "player_id, days, rewards_output, time"};

get_log(log_equip_stren) ->
    {"log_equip_stren", "role_id, equip_pos, cost, pre_lv, cur_lv, time"};

get_log(log_equip_refine) ->
    {"log_equip_refine", "role_id, equip_pos, cost, pre_lv, cur_lv, time"};

get_log(log_goods_compose) ->
    {"log_goods_compose", "role_id, rule_id, specify_material_list, material_list, cost_list, is_success, goods_list, time"};

get_log(log_goods_sell) ->
    {"log_goods_sell", "player_id, goods_type_list, goods_id_list, object_list, time"};

get_log(log_single_dungeon) ->
    {"log_single_dungeon", "role_id, lv, combat_power, dun_id, dun_type, reward_list, result_type, result_subtype, `count`, kill_mon, log_type, time"};

get_log(log_multi_dungeon) ->
    {"log_multi_dungeon", "role_id, lv, combat_power, guild_id, dun_id, dun_type, diff_lv, team_id, help_type, role_id1, role_id2, role_id3, reward_list, grade, score, level_score_list, intimacy_score_list, rela_score_list, guild_score_list, time_score_list, mon_score, result_type, result_subtype, `count`, log_type, time"};

get_log(log_growup) ->
    {"log_growup", "role_id, type, lv, reward, get_time, buy_time"};

get_log(log_consume_gfunds) ->
    {"log_consume_gfunds", "role_id, guild_id, consume_type, cost_gfunds, remain_gfunds, time"};

get_log(log_produce_gfunds) ->
    {"log_produce_gfunds", "role_id, guild_id, produce_type, got_gfunds, remain_gfunds, time"};

% get_log(log_produce_reputation) ->
%     {"log_produce_reputation", "role_id, guild_id, guild_name, produce_type, got_reputation, remain_reputation, time"};

get_log(log_guild_member) ->
    {"log_guild_member", "guild_id, guild_name, event_type, role_id, event_param, time"};

get_log(log_recharge_first) ->
    {"log_recharge_first", "player_id, recharge_time, fetch_time, status, object_list"};

get_log(log_recharge_return) ->
    {"log_recharge_return", "player_id, product_id, return_type, gold, return_gold, time"};

get_log(log_ban) ->
    {"log_ban", "type, object, description, time, admin"};

get_log(log_throw_dice) ->
    {"log_throw_dice", "player_id, move_step, grid_type, time"};

get_log(log_trigger_event) ->
    {"log_trigger_event", "player_id, event_id, succ, reward, time"};

get_log(log_unlock_box) ->
    {"log_unlock_box", "player_id, type_id, time"};

get_log(log_rename) ->
    {"log_rename", "player_id, old_name, new_name, lv, cost, time"};

get_log(log_player_guild_equip_hit) ->
    {"log_player_guild_equip_hit", "role_id, equip_type, goods_id, count, hit_pos, is_hit, get_goods_id, time"};

%% 玩家下线日志表
get_log(log_offline) ->
    {"log_offline", "player_id, offline_type, power, module_power, scene_id, x, y, time"};

%% 离线挂机记录
get_log(log_onhook) ->
    {"log_onhook", "role_id, type, onhook_time, time"};

get_log(log_onhook_result) ->
    {"log_onhook_result", "role_id, lv, exp, pet_exp, cost_time, devour_equips, pick_equips, time"};

get_log(log_gift_card_list) ->
    {"log_gift_card_list", "player_id, card_no, gift_type, award_list, time"};

get_log(log_rush_giftbag) ->
    {"log_rush_giftbag", "player_id, player_lv, sex, bag_lv, gift_num, rewards_output, time"};

get_log(log_version_upgradebag) ->
    {"log_version_upgradebag", "player_id, version_code, rewards_output, time"};

get_log(log_top_pk) ->
    {"log_top_pk", "role_id, fight_role_id, fight_role_name, is_fake, platform, server_num, res, rank_before, point_before, rank_after, point_after, time"};

%%get_log(log_vip_status) ->
%%    {"log_vip_status", "player_id, vip_lv, props_id, vip_status, end_time, time"};
%%
%%get_log(log_vip_upgrade) ->
%%    {"log_vip_upgrade", "player_id, vip_lv, vip_exp, diamond_exp, login_exp, time"};

get_log(log_consume_currency) ->
    {"log_consume_currency", "player_id, type, currency_id, value, remain_value, remark, time"};

get_log(log_talk_report) ->
    {"log_talk_report", "from_id, to_id, msg, time"};

get_log(log_husong_end) ->
    {"log_husong_end", "role_id, angel_id, start_time, end_stage, end_type, if_double, goods_list, time"};

get_log(log_husong_reflesh) ->
    {"log_husong_reflesh", "role_id, old_angel_id, new_angel_id, cost_list, time"};

get_log(log_husong_take) ->
    {"log_husong_take", "take_role_id, be_taken_role_id, time"};

get_log(log_treasure_chest_reward) ->
    {"log_treasure_chest_reward", "role_id, grade, time"};

get_log(log_eudemons_operation) ->
    {"log_eudemons_operation", "player_id, eudemons_id, op, time"};

get_log(log_eudemons_strength) ->
    {"log_eudemons_strength", "player_id, equip_id, equip_type_id, cost_exp, stren0, exp0, stren1, exp1, time"};

get_log(log_login_reward_day) ->
    {"log_login_reward_day", "role_id, day_id, get_date, reward_list, time"};

get_log(log_equip_suit_operation) ->
    {"log_equip_suit_operation", "player_id, equip_id, equip_type_id, suit_type, suit_lv, suit_slv, suit_num, op, time"};

get_log(log_reincarnation) ->
    {"log_reincarnation", "role_id, turn_type, turn, time"};

get_log(log_awakening) ->
    {"log_awakening", "role_id, cell, cost, time"};

get_log(log_stone_inlay) ->
    {"log_stone_inlay", "role_id, ctrl_type, equip_pos, cell, pre_stone, af_stone, extra, time"};

get_log(log_stone_refine) ->
    {"log_stone_refine", "role_id, equip_pos, pre_lv, cur_lv, cost, time"};

get_log(log_combine_stone) ->
    {"log_combine_stone", "role_id, combine_type, cost_list, reward_list, time"};

get_log(log_void_fam) ->
    {"log_void_fam", "role_id, type, floor, score, time"};

get_log(log_equip_upgrade_stage) ->
    {"log_equip_upgrade_stage", "role_id, goods_id, ogtype_id, cost, ngtype_id, time"};

get_log(log_equip_wash) ->
    {"log_equip_wash", "role_id, equip_pos, duan, cost, pre_attr, cur_attr, pre_rating, cur_rating, ratio_plus, time"};

get_log(log_equip_upgrade_division) ->
    {"log_equip_upgrade_division", "role_id, equip_pos, cost, pre_division, cur_division, time"};

get_log(log_eternal_valley_reward) ->
    {"log_eternal_valley_reward", "role_id, chapter, stage, reward, time"};

get_log(log_boss) ->
    {"log_boss", "boss_type, boss_id, kill_id, bl_id, time"};

get_log(log_eudemons_land_boss) ->
    {"log_eudemons_land_boss", "zone_id, boss_id, kill_id, kill_name, kill_platform, kill_server_name, bl_who_1, bl_who_2, bl_who_3, time"};

get_log(log_eudemons_land_level) ->
    {"log_eudemons_land_level", "role_id, lv, exp, new_lv, new_exp, exp_add, time"};

get_log(log_eudemons_land_rank_center) ->
    {"log_eudemons_land_rank_center", "zone_id, role_id, role_name, server_id, rank_type, value, rank, time"};

get_log(log_eudemons_land_rank_local) ->
    {"log_eudemons_land_rank_local", "role_id, rank_type, rank, value, rewards, time"};

get_log(log_eudemons_land_score) ->
    {"log_eudemons_land_score", "role_id, role_name, zone_id, ser_id, ser_num, add_score, add_kill, score, kill_num, total_score, time"};

get_log(log_marriage_ring_polish) ->
    {"log_marriage_ring_polish", "role_id, old_polish_list, new_polish_list, cost_list, time"};

get_log(log_marriage_ring_upgrade) ->
    {"log_marriage_ring_upgrade", "role_id, old_stage, old_star, old_pray_num, new_stage, new_star, new_pray_num, cost_list, time"};

get_log(log_marriage_baby_knowledge_upgrade) ->
    {"log_marriage_baby_knowledge_upgrade", "role_id, old_stage, old_star, old_pray_num, new_stage, new_star, new_pray_num, cost_list, time"};

get_log(log_marriage_baby_aptitude_upgrade) ->
    {"log_marriage_baby_aptitude_upgrade", "role_id, old_aptitude_lv, new_aptitude_lv, cost_list, time"};

get_log(log_marriage_baby_image_upgrade) ->
    {"log_marriage_baby_image_upgrade", "role_id, image_id, old_stage, old_pray_num, new_stage, new_pray_num, cost_list, time"};

get_log(log_baby_raise_up) ->
    {"log_baby_raise_up", "role_id, task_id, add_raise_exp, raise_lv, raise_exp, new_raise_lv, new_raise_exp, time"};

get_log(log_baby_upgrade_stage) ->
    {"log_baby_upgrade_stage", "role_id, stage, stage_lv, stage_exp, new_stage, new_stage_lv, new_stage_exp, costlist, time"};

get_log(log_baby_active_figure) ->
    {"log_baby_active_figure", "role_id, baby_id, active_type, star, new_star, costlist, time"};

get_log(log_baby_praise) ->
    {"log_baby_praise", "praiser_id, role_id, praise_count, rewards, time"};

get_log(log_baby_praise_rank) ->
    {"log_baby_praise_rank", "role_id, rank, praise_count, rewards, time"};

get_log(log_baby_equip_goods) ->
    {"log_baby_equip_goods", "role_id, pos_id, old_id, old_typeid, old_skill, new_id, new_typeid, new_skill, time"};

get_log(log_baby_equip_stage_up) ->
    {"log_baby_equip_stage_up", "role_id, pos_id, opr_type, stage, stage_lv, stage_exp, new_stage, new_stage_lv, new_stage_exp, costlist, time"};

get_log(log_baby_equip_engrave) ->
    {"log_baby_equip_engrave", "role_id, goods_id, type_id, is_succ, ratio, skill_id, costlist, time"};

get_log(log_sell_up) ->
    {"log_sell_up", "seller_id, sell_type, sell_id, goods_id, goods_num, unit_price, specifyer_id, extra, time"};

get_log(log_sell_up_kf) ->
    {"log_sell_up_kf", "seller_server_id, seller_server_num, seller_id, sell_type, sell_id, goods_id, goods_num, unit_price, specifyer_id, extra, time"};


get_log(log_sell_pay) ->
    {"log_sell_pay", "sell_type, sell_id, goods_id, goods_num, unit_price, tax, seller_id, buyer_id, extra, time"};

get_log(log_sell_pay_kf) ->
    {"log_sell_pay_kf", "sell_type, sell_id, goods_id, goods_num, unit_price, tax, seller_server_id, seller_server_num, seller_id, buyer_server_id, buyer_server_num, buyer_id, extra, time"};


get_log(log_sell_down) ->
    {"log_sell_down", "sell_id, goods_id, goods_num, seller_id, down_type, extra, time"};

get_log(log_sell_down_kf) ->
    {"log_sell_down_kf", "sell_id, goods_id, goods_num, seller_server_id, seller_server_num, seller_id, down_type, extra, time"};

get_log(log_seek_up) ->
    {"log_seek_up", "seek_id, player_id, gtype_id, goods_num, unit_price, time"};

get_log(log_seek_up_kf) ->
    {"log_seek_up_kf", "seek_id, server_id, server_num, player_id, gtype_id, goods_num, unit_price, time"};


get_log(log_seek_down) ->
    {"log_seek_down", "seek_id, player_id, down_type, gtype_id, goods_num, unit_price, money_return, time"};

get_log(log_seek_down_kf) ->
    {"log_seek_down_kf", "seek_id,  server_id, server_num, player_id, down_type, gtype_id, goods_num, unit_price, money_return, time"};


%% 头像日志
get_log(log_picture) ->
    {"log_picture", "role_id, picture, picture_ver, time"};

get_log(log_eternal_valley_stage) ->
    {"log_eternal_valley_stage", "role_id, chapter, stage, `condition`, time"};

get_log(log_soul_compose) ->
    {"log_soul_compose", "role_id, goods_list, new_goods_type_id, new_soul_lv, new_awake_lv_list, old_soul_point, new_soul_point, time"};

get_log(log_rune_compose) ->
    {"log_rune_compose", "role_id, goods_list, new_goods_type_id, new_rune_lv, old_rune_point, new_rune_point, time"};

get_log(log_soul_wear) ->
    {"log_soul_wear", "role_id, pos_id, goods_type_id, color, lv, time"};

get_log(log_rune_wear) ->
    {"log_rune_wear", "role_id, pos_id, goods_type_id, color, lv, time"};

get_log(log_rune_level_up) ->
    {"log_rune_level_up", "role_id, goods_type_id, old_lv, new_lv, cost, time"};

get_log(log_soul_level_up) ->
    {"log_soul_level_up", "role_id, goods_type_id, old_lv, new_lv, cost, time"};

get_log(log_rune_exchange) ->
    {"log_rune_exchange", "role_id, old_rune_chip, new_rune_chip, goods_list, time"};

get_log(log_fashion_color) ->
    {"log_fashion_color", "role_id, pos_id, fashion_id, color_id, type, cost_list, time"};

get_log(log_fashion_star) ->
    {"log_fashion_star", "role_id, pos_id, fashion_id, type, old_star_lv, new_star_lv, cost_list, time"};

get_log(log_fashion_pos) ->
    {"log_fashion_pos", "role_id, pos_id, old_pos_lv, new_pos_lv, cost, time"};

get_log(log_fashion_upgrade) ->
    {"log_fashion_upgrade", "role_id, pos_id, old_pos_lv, old_exp, new_pos_lv, exp, cost, time"};

get_log(log_juewei_level_up) ->
    {"log_juewei_level_up", "role_id, old_juewei_lv, new_juewei_lv, time"};

get_log(log_jjc_buy_times) ->
    {"log_jjc_buy_times", "role_id, pre_gold, pre_bgold, pre_coin, buy_times, after_gold, after_bgold, after_coin, time"};

get_log(log_jjc_inspire) ->
    {"log_jjc_inspire", "role_id, pre_gold, pre_bgold, pre_coin, pre_combat, inspire_times, after_gold, after_bgold, after_coin, after_combat, time"};

get_log(log_jjc_break_rank) ->
    {"log_jjc_break_rank", "role_id, break_id, break_rank, reward, time"};

get_log(log_jjc_clear) ->
    {"log_jjc_clear", "role_id, rank, reward, time"};

get_log(log_jjc) ->
    {"log_jjc", "role_id, rank, rival_id, rival_rank, result, after_rank, time"};

get_log(log_dress_star) ->
    {"log_dress_star", "role_id, dress_type, dress_id, dress_star, exp, cost, time"};

get_log(log_dress_illu_lv) ->
    {"log_dress_illu_lv", "role_id, pre_lv, pre_exp, after_lv, after_exp, cost, time"};

get_log(log_active_dress_up) ->
    {"log_active_dress_up", "role_id, dress_type, dress_id, old_lv, new_lv, cost, time"};

get_log(log_marriage_propose) ->
    {"log_marriage_propose", "role_id_1, cost_list1, role_id_2, cost_list2, type, wedding_type, time"};

get_log(log_wing_lv) ->
    {"log_wing_lv", "role_id, pre_lv, pre_exp, after_lv, after_exp, cost, skills, time"};

get_log(log_wing_illusion) ->
    {"log_wing_illusion", "role_id, illusion_id, opt, pre_star, after_star, cost, time"};

get_log(log_wing_develop) ->
    {"log_wing_develop", "role_id, good_id, use_num, max_num, pre_attr, after_attr, time"};

get_log(log_talisman_lv) ->
    {"log_talisman_lv", "role_id, pre_lv, pre_exp, after_lv, after_exp, cost, skills, time"};

get_log(log_talisman_illusion) ->
    {"log_talisman_illusion", "role_id, illusion_id, opt, pre_star, after_star, cost, time"};

get_log(log_talisman_develop) ->
    {"log_talisman_develop", "role_id, good_id, use_num, max_num, pre_attr, after_attr, time"};

get_log(log_godweapon_lv) ->
    {"log_godweapon_lv", "role_id, pre_lv, pre_exp, after_lv, after_exp, cost, skills, time"};

get_log(log_godweapon_illusion) ->
    {"log_godweapon_illusion", "role_id, illusion_id, opt, pre_star, after_star, cost, time"};

get_log(log_godweapon_develop) ->
    {"log_godweapon_develop", "role_id, good_id, use_num, max_num, pre_attr, after_attr, time"};

get_log(log_treasure_hunt) ->
    {"log_treasure_hunt", "role_id, htype, ctype, auto_buy, cost, reward, lucky_val, time, new_lucky_val"};

get_log(log_goods_exchange) ->
    {"log_goods_exchange", "role_id, type, cost, reward, time"};

get_log(log_pray) ->
    {"log_pray", "role_id, role_lv, type, times, free, crit, cost, reward, time"};

get_log(log_marriage_answer) ->
    {"log_marriage_answer", "role_id_1, role_id_2, answer_type, type, propose_type, reward_s, reward_o, return_reward, time"};

get_log(log_marriage_wedding_order) ->
    {"log_marriage_wedding_order", "role_id_m, role_id_w, order_time, wedding_type, order_type, time"};

get_log(log_marriage_wedding_end) ->
    {"log_marriage_wedding_end", "role_id_m, role_id_w, man_in, woman_in, end_type, enter_role_id_list, time"};

get_log(log_artifact_active) ->
    {"log_artifact_active", "role_id, arti_id, cost, time"};

get_log(log_artifact_lv) ->
    {"log_artifact_lv", "role_id, arti_id, lv, gift_id, gift_attr, cost, time"};

get_log(log_artifact_enchant) ->
    {"log_artifact_enchant", "role_id, arti_id, ench_pec, ench_attr, new_attr, cost, time"};

get_log(log_marriage_wedding_aura) ->
    {"log_marriage_wedding_aura", "role_id_m, role_id_w, role_id, type, old_aura, new_aura, time"};

get_log(log_marriage_life_train) ->
    {"log_marriage_life_train", "role_id, old_stage, old_heart, old_love_num, new_stage, new_heart, new_love_num, time"};

get_log(log_marriage_divorse) ->
    {"log_marriage_divorse", "role_id_m, role_id_w, role_id, type, cost_list, time"};

get_log(log_buy_love_gift) ->
    {"log_buy_love_gift", "role_id, role_id_o, type, cost_list, love_gift_time_s, love_gift_time_o, reward, time"};

get_log(log_rename_guild) ->
    {"log_rename_guild", "guild_id, player_id, old_name, new_name, type, time"};

get_log(log_liveness_up) ->
    {"log_liveness_up", "role_id, pre_lv, liveness, after_lv, time"};

get_log(log_produce_honour) ->
    {"log_produce_honour", "player_id, type, old_value, new_value, got_value, remark, time"};

get_log(log_cost_honour) ->
    {"log_cost_honour", "player_id, type, old_value, new_value, cost_value, remark, time"};

get_log(log_rush_rank_reward) ->
    {"log_rush_rank_reward", "role_id, rank_type, rank, value, reward, time"};

get_log(log_rush_goal_reward) ->
    {"log_rush_goal_reward", "role_id, rank_type, goal_id, value, reward, time"};

get_log(log_flower_rank_local) ->
    {"log_flower_rank_local", "role_id, sex, rank, value, reward, time"};

get_log(log_flower_rank_kf) ->
    {"log_flower_rank_kf", "role_id, name, server_id, platform, server_num, sex, rank, value, reward, time"};

get_log(log_wed_rank) ->
    {"log_wed_rank", "role_id, sec_id, rank, book_time, reward, time"};

get_log(log_share_times) ->
    {"log_share_times", "role_id, times, time"};

get_log(log_mail_clear) ->
    {"log_mail_clear", "rid, title, cm_attachment, state, effect_st, time"};

get_log(log_rela) ->
    {"log_rela", "role_id, other_rid, pre_rela, ctype, rela, time"};

get_log(log_intimacy) ->
    {"log_intimacy", "role_id, other_rid, pre_intimacy, way, intimacy, extra, time"};

get_log(log_pet_upgrade_lv) ->
    {"log_pet_upgrade_lv", "role_id, pre_lv, pre_exp, exp_plus, vip_plus_ratio, cur_lv, cur_exp, cost, time"};

get_log(log_pet_upgrade_star) ->
    {"log_pet_upgrade_star", "role_id, pre_stage, pre_star, pre_blessing, blessing_plus, cur_stage, cur_star, cur_blessing, cost, time"};

get_log(log_pet_figure_upgrade_stage) ->
    {"log_pet_figure_upgrade_stage", "role_id, figure_id, type, pre_stage, pre_blessing, blessing_plus, cur_stage, cur_blessing, cost, time"};

get_log(log_pet_goods_use) ->
    {"log_pet_goods_use", "role_id, goods_id, use_times, times_lim, pre_attr, cur_attr, time"};

get_log(log_active_demons) ->
    {"log_active_demons", "role_id, demons_id, cost_list, time"};

get_log(log_up_star_demons) ->
    {"log_up_star_demons", "role_id, demons_id, old_star, new_star, cost_list, time"};

get_log(log_up_level_demons) ->
    {"log_up_level_demons", "role_id, demons_id, old_lv, old_exp, new_lv, new_exp, cost_list, time"};

get_log(log_demons_painting_reward) ->
    {"log_demons_painting_reward", "role_id, painting_id, painting_num, reward_list, time"};

get_log(log_upgrade_demons_skill) ->
    {"log_upgrade_demons_skill", "role_id, demons_id, skill_id, skill_lv, cost_list, time"};

get_log(log_mount_upgrade_star) ->
    {"log_mount_upgrade_star", "role_id, type_id, pre_stage, pre_star, pre_blessing, blessing_plus, cur_stage, cur_star, cur_blessing, cost, time, clear_time"};

get_log(log_mount_figure_upgrade_stage) ->
    {"log_mount_figure_upgrade_stage", "role_id, type_id, figure_id, type, pre_stage, cur_stage, cost, bless_plus, blessing, time"};

get_log(log_mount_goods_use) ->
    {"log_mount_goods_use", "role_id, type_id, goods_id, use_times, times_lim, pre_attr, cur_attr, time"};

get_log(log_produce_gdonate) ->
    {"log_produce_gdonate", "role_id, produce_type, add_donate, remain_donate, historical_donate, extra, time"};

get_log(log_consume_gdonate) ->
    {"log_consume_gdonate", "role_id, consume_type, cost_donate, remain_donate, extra, time"};

get_log(log_produce_growth) ->
    {"log_produce_growth", "guild_id, role_id, produce_type, add_growth, remain_growth, time"};

get_log(log_consume_growth) ->
    {"log_consume_growth", "guild_id, role_id, consume_type, cost_growth, remain_growth, extra, time"};

get_log(log_gboss_mat) ->
    {"log_gboss_mat", "guild_id, role_id, type, gbossmat, new_gbossmat, extra, time"};

get_log(log_guild) ->
    {"log_guild", "guild_id, guild_name, type, extra, time"};

get_log(log_red_envelopes) ->
    {"log_red_envelopes", "`red_envelopes_id`, `ownership_type`, `ownership_id`, `owner_id`, `status`, `type`, `extra`, time"};

get_log(log_red_envelopes_recipients) ->
    {"log_red_envelopes_recipients", "role_id, red_envelopes_id, reward, time"};

get_log(log_guild_depot) ->
    {"log_guild_depot", "role_id, type, unique_id, goods_id, pre_score, cur_score, time"};

get_log(log_guild_skill) ->
    {"log_guild_skill", "guild_id, guild_name, role_id, type, skill_id, cost, pre_lv, cur_lv, time"};

get_log(log_guild_daily_gift) ->
    {"log_guild_daily_gift", "role_id, reward, time"};

get_log(log_guild_donate_gift) ->
    {"log_guild_donate_gift", "role_id, grade_id, reward, time"};

get_log(log_guild_dun_result) ->
    {"log_guild_dun_result", "role_id, guild_id, level, door, type, is_win, reward, score, challenge_times, time"};

get_log(log_guild_boss) ->
    {"log_guild_boss", "guild_id, status, time"};

get_log(log_guild_war_division) ->
    {"log_guild_war_division", "`stage`, `guild_id`, `guild_name`, `division`, `ranking`, `time`"};

get_log(log_guild_war_battle) ->
    {"log_guild_war_battle", "`red_gid`, `red_gname`, `blue_gid`, `blue_gname`, `round`, `winner_group`, `winner_reward`, `loser_reward`, `time`"};

get_log(log_guild_war_scene) ->
    {"log_guild_war_scene", "`role_id`, `type`, `extra`, `time`"};

get_log(log_guild_war_reward) ->
    {"log_guild_war_reward", "`guild_id`, `guild_name`, `reward_type`, `reward`, `extra`, `time`"};

get_log(log_guild_war_allot_reward) ->
    {"log_guild_war_allot_reward", "`guild_id`, `guild_name`, `role_id`, `allot_type`, `reward_type`, `reward`, `time`"};

get_log(log_smashed_egg) ->
    {"log_smashed_egg", "`role_id`, `smashed_type`, `smashed_num`, `index`, `use_free_times`, `auto_buy`, `cost`, `reward`, `time`"};

get_log(log_luckey_egg) ->
    {"log_luckey_egg", "`role_id`, `type`, `subtype`, `free_times_use`, `total_times_use`, `times`, `is_free`, `auto_buy`, `cost`, `reward`, `time`"};

get_log(log_cloud_buy_kf) ->
    {"log_cloud_buy_kf", "`order_id`, `role_uid`, `role_name`, `platform`, `server_num`, `count`, `event`, `subtype`, `time`"};

get_log(log_act_boss) ->
    {"log_act_boss", "`platform`, `server_id`, `avg_online_num`, `boss_num`, `kill_num`, `extra`, `time`"};

get_log(log_eudemons_attack) ->
    {"log_eudemons_attack", "act_id, role_id, rank, room_id, boss_killer, hurt, hurt_percent, rewards, time"};

get_log(log_fireworks) ->
    {"log_fireworks", "role_id, use_num, reward, all_use_num, time"};

get_log(log_hi_points) ->
    {"log_hi_points", "sub_type, role_id, mod_id, sub_id, before_pots, after_pots, time"};

get_log(log_limit_shop_buy) ->
    {"log_limit_shop_buy", "role_id, sell_id, buy_num, cost_list, goods_list, discount, start_time, time"};

get_log(log_transfer) ->
    {"log_transfer", "role_id, old_career, old_sex, new_career, new_sex, old_equips, new_equips, time"};

get_log(log_treasure_evaluation) ->
    {"log_treasure_evaluation", "role_id, type, old_lucky_num, new_lucky_num, cost_list, reward_list, time"};

get_log(log_equip_casting_spirit) ->
    {"log_equip_casting_spirit", "role_id, equip_pos, cost, pre_stage, pre_lv, cur_stage, cur_lv, time"};

get_log(log_equip_upgrade_spirit) ->
    {"log_equip_upgrade_spirit", "role_id, cost, pre_lv, cur_lv, time"};

get_log(log_collect_put) ->
    {"log_collect_put", "subtype, all_reward_id, all_reward_type, new_all_point, role_id, put_type, self_reward_id, self_reward_type, new_self_point, time"};

get_log(log_equip_awakening) ->
    {"log_equip_awakening", "role_id, equip_pos, cost, pre_lv, cur_lv, time"};

get_log(log_equip_skill) ->
    {"log_equip_skill", "role_id, equip_pos, skill_id, ctrl_type, cost, pre_lv, cur_lv, extra, time"};

get_log(log_recharge_rank_act) ->
    {"log_recharge_rank_act", "role_id, rank, value, reward, time"};

get_log(log_consume_rank_act) ->
    {"log_consume_rank_act", "role_id, rank, value, reward, time"};

get_log(log_login_return_reward) ->
    {"log_login_return_reward", "role_id, subtype, grade, status, cost, reward, time"};

get_log(log_diamond_league_apply) ->
    {"log_diamond_league_apply", "role_id, role_name, server_name, power, time, rank"};

get_log(log_diamond_league_battle) ->
    {"log_diamond_league_battle", "round_name, winner_id, winner_name, winner_serv, winner_die_count, winner_life, loser_id, loser_name, loser_serv, loser_die_count, time"};

get_log(log_diamond_league_guess) ->
    {"log_diamond_league_guess", "role_id, round_name, guess_info, op, time"};

get_log(log_pet_aircraft_stage) ->
    {"log_pet_aircraft_stage", "role_id, aircraft_id, old_stage, new_stage, cost_list, time"};

get_log(log_flower_act_send_kf) ->
    {"log_flower_act_send_kf", "sid, sname, sserid, rid, rname, rserid, oldcharm, newcharm, goodid, time"};

get_log(log_send_flower) ->
    {"log_send_flower", "sender_id, receiver_id, cost, is_friend, time"};

get_log(log_fame) ->
    {"log_fame", "role_id, pre_val, val, extra, time"};

get_log(log_charm) ->
    {"log_charm", "role_id, pre_val, val, extra, time"};

get_log(log_3v3_pk_room) ->
    {"log_3v3_pk_room", "`scene_id`, `scene_pool_id`, `room_id`, `tower_data`, `pk_id`, `result`, `blue_name1`, `blue_name2`, `blue_name3`, `blue_score`, `blue_tower_num`, `red_name1`, `red_name2`, `red_name3`, `red_score`, `red_tower_num`, `time`"};

get_log(log_3v3_pk_team) ->
    {"log_3v3_pk_team", "`pk_id`, `team_id`, `group`, `score`, `kill`, `killed`, `assist`, `result`, `time`"};

get_log(log_3v3_rank_reward) ->
    {"log_3v3_rank_reward", "`rank_id`, `role_id`, `nickname`, `tier`, `star`, `reward`, `time`"};

get_log(log_3v3) ->
    {"log_3v3", "`role_id`, `type`, `old_tier`, `old_star`, `new_tier`, `new_star`, `result`, `honor`, `other_msg`,  `time`"};

get_log(log_3v3_pk_role) ->
    {"log_3v3_pk_role", "`pk_id`, `role_id`, `name`, `group`, `old_tier`, `old_star`, `old_continued_win`, `new_tier`, `new_star`, `new_continued_win`, `kill`, `killed`, `collect`, `assist`, `honor`, `is_mvp`, `result`, `time`"};

get_log(log_dungeon_exp_gain) ->
    {"log_dungeon_exp_gain", "`role_id`, `dun_id`, `lv_before`, `lv_after`, `exp`, `mon_exp`, `ratio1`, `ratio2`, `quit_type`, `score`, `time`"};

get_log(log_lucky_flop_refresh) ->
    {"log_lucky_flop_refresh", "`role_id`, `refresh_times`, `is_free`, `cost`, `reward`, `time`"};

get_log(log_lucky_flop_reward) ->
    {"log_lucky_flop_reward", "`role_id`, `use_times`, `cost`, `reward`, `time`"};

get_log(log_holy_ghost_active) ->
    {"log_holy_ghost_active", "`role_id`, `name`, `cost`, `time`"};

get_log(log_holy_ghost_stage) ->
    {"log_holy_ghost_stage", "`role_id`, `name`, `cost`, `stage`, `exp`, `new_stage`, `new_exp`, `time`"};

get_log(log_holy_ghost_awake) ->
    {"log_holy_ghost_awake", "`role_id`, `name`, `cost`, `lv`, `new_lv`, `time`"};

get_log(log_holy_ghost_illu_active) ->
    {"log_holy_ghost_illu_active", "`role_id`, `name`, `op`, `cost`, `time`"};

get_log(log_holy_ghost_fight) ->
    {"log_holy_ghost_fight", "`role_id`, `name`, `time`"};

get_log(log_holy_ghost_relic) ->
    {"log_holy_ghost_relic", "`role_id`, `name`, `cost`, `time`"};

get_log(log_house_buy_upgrade) ->
    {"log_house_buy_upgrade", "`ask_role_id`, `answer_role_id`, `role_id_1`, `role_id_2`, `old_house_lv`, `new_house_lv`, `ask_cost_list`, `answer_cost_list`, `old_house_point`, `new_house_point`, `time`"};

get_log(log_house_divorce) ->
    {"log_house_divorce", "`role_id`, `lover_role_id`, `before_block_id`, `before_house_id`, `before_house_lv`, `after_block_id`, `after_house_id`, `after_house_lv`, `time`"};

get_log(log_house_choose) ->
    {"log_house_choose", "`role_id_1`, `role_id_2`, `block_id`, `house_id`, `house_lv`, `type`, `answer_type`, `time`"};

get_log(log_house_add_furniture) ->
    {"log_house_add_furniture", "`role_id`, `goods_id`, `goods_type_id`, `goods_num`, `time`"};

get_log(log_mount_equip_lv) ->
    {"log_mount_equip_lv", "`role_id`, `pos`, `pre_lv`, `pre_exp`, `new_lv`, `new_exp`, `cost`, `time`"};

get_log(log_mount_equip_stage) ->
    {"log_mount_equip_stage", "`role_id`, `pos`, `pre_stage`, `new_stage`, `cost`, `time`"};

get_log(log_mount_equip_engrave) ->
    {"log_mount_equip_engrave", "`role_id`, `good_id`, `type_id`, `is_success`, `skill_id`, `cost`, `time`"};

get_log(log_single_guess_bet) ->
    {"log_single_guess_bet", "`role_id`, `game_type`, `subtype`, `cfg_id`, `total_times`, `times`, `odds`, `sel_result`, `cost`, `time`"};

get_log(log_group_guess_bet) ->
    {"log_group_guess_bet", "`role_id`, `game_type`, `cfg_id`, `total_times`, `times`, `odds`, `cost`, `time`"};

get_log(log_guess_reward) ->
    {"log_guess_reward", "`role_id`, `game_type`, `type`, `cfg_id`, `receive_type`, `reward`, `time`"};

get_log(log_talent_skill)->
    {"log_talent_skill", "`role_id`, `type`, `skill_id`, `skill_lv`, `old_power`, `power`, `time`"};

get_log(log_investment_reward) ->
    {"log_investment_reward", "`role_id`, `type`, `lv`, `condition`, `rewards`, `bgold0`, `bgold1`, `op`, `time`"};

get_log(log_investment_buy) ->
    {"log_investment_buy", "`role_id`, `type`, `lv0`, `lv1`, `cost`, `gold0`, `gold1`, `time`"};

get_log(log_kf_1vn_auction) ->
    {"log_kf_1vn_auction", "`auction_id`, `role_id`, `server_id`, `server_num`, `name`, `price_add`, `price`, `voucher`, `time`"};

get_log(log_kf_1vn_race_1) ->
    {"log_kf_1vn_race_1", "`area`, `win_id`, `win_server_id`, `win_server_num`, `win_name`, `win_cp`, `win_score`, `lose_id`, `lose_server_id`, `lose_server_num`, `lose_name`, `lose_cp`, `lose_score`, `win_type`, `time`"};

get_log(log_kf_1vn_race_2) ->
    {"log_kf_1vn_race_2", "`area`, `turn`, `battle_id`, `player_id`, `server_id`, `server_num`, `name`, `cp`, `def_type`, `win`, `win_type`, `status`, `time`"};

get_log(log_kf_1vn_sign) ->
    {"log_kf_1vn_sign", "`player_id`, `name`, `server_id`, `lv`, `time`"};

get_log(log_pet_wing_stage) ->
    {"log_pet_wing_stage", "role_id, wing_id, old_stage, new_stage, cost_list, time"};

get_log(log_house_gift) ->
    {"log_house_gift", "block_id, house_id, role_id_1, role_id_2, role_id, gift_id, old_popularity, new_popularity, time"};

get_log(log_kf_saint_challenge) ->
    {"log_kf_saint_challenge", "zone_id, saint_id, role_server_name, role_id, role_name, saint_server_name, saint_role_id, saint_role_name, res, dsgt_id, time"};

get_log(log_kf_saint_fight) ->
    {"log_kf_saint_fight", "saint_id, role_id, role_name, turn_attr_id, inspire_id, inspire_num, time"};

get_log(log_pet_wing_add_time) ->
    {"log_pet_wing_add_time", "role_id, wing_id, old_end_time, new_end_time, cost_list, time"};

get_log(log_pet_wing_time_out) ->
    {"log_pet_wing_time_out", "role_id, wing_id, old_show_id, new_show_id, time"};

get_log(log_boss_drop) ->
    {"log_boss_drop", "scene, boss_id, boss_type, role_id, bl_ids,  goods, team_id, time"};

get_log(log_mount_equip_wear) ->
    {"log_mount_equip_wear", "role_id, pos, old_good_id, old_type_id, old_skill, new_good_id, new_type_id, new_skill, time"};

get_log(log_pet_equip_pos_upgrade) ->
    {"log_pet_equip_pos_upgrade", "role_id, type_id, pos, goods_type_id, old_pos_lv, old_pos_point, new_pos_lv, new_pos_point, cost_list, time"};

get_log(log_pet_equip_goods_upgrade) ->
    {"log_pet_equip_goods_upgrade", "role_id, type_id, pos, goods_type_id, cost_goods_type_id, old_stage, old_star, old_pos_lv, old_all_point, new_stage, new_star, new_pos_lv, new_all_point, time"};

get_log(log_house_merge) ->
    {"log_house_merge", "block_id, house_id, server_id_A, server_id_B, role_id_1_A, role_id_2_A, role_id_1_B, role_id_2_B, return_list_1_A, return_list_2_A, return_list_1_B, return_list_2_B, time"};

get_log(log_kf_1vn_bet) ->
    {"log_kf_1vn_bet", "`role_id`, `role_name`, `turn`, `battle_id`, `bet_opt`, `cost`, `time`"};

get_log(log_kf_1vn_bet_result) ->
    {"log_kf_1vn_bet_result", "`role_id`, `role_name`, `turn`, `battle_id`, bet_time, `battle_result`, `hp`, hp_lim, live_num, bet_cost_type, bet_opt, bet_result, `time`"};

get_log(log_kf_1vn_bet_receive) ->
    {"log_kf_1vn_bet_receive", "`role_id`, `turn`, `battle_id`, bet_time, `battle_result`, bet_cost_type, bet_opt, bet_result, reward, `time`"};

get_log(log_daily_turntable) ->
    {"log_daily_turntable", "role_id, sub_type, op_type, is_auto_buy, cost, reward, time"};

get_log(log_kf_guild_war_bid) ->
    {"log_kf_guild_war_bid", "ser_id, ser_name, guild_id, guild_name, role_id, role_name, island_id, island_name, type, extra, time"};

get_log(log_kf_guild_war_ranking_reward) ->
    {"log_kf_guild_war_ranking_reward", "ser_id, ser_name, role_id, role_name, kill_num, max_combo, kill_ranking, kill_reward, guild_ranking, guild_reward, time"};

get_log(log_kf_guild_war_props) ->
    {"log_kf_guild_war_props", "guild_id, guild_name, role_id, type, props_name, pre_num, cur_num, extra, time"};

get_log(log_kf_guild_war_resource) ->
    {"log_kf_guild_war_resource", "guild_id, role_id, type, pre_num, cur_num, extra, time"};

get_log(log_kf_guild_war_season_reward) ->
    {"log_kf_guild_war_season_reward", "ser_id, ser_name, guild_id, guild_name, score, ranking, reward, time"};

get_log(log_kf_guild_war_battle) ->
    {"log_kf_guild_war_battle", "ser_id, ser_name, guild_id, guild_name, tag, island_id, island_name, ranking, pre_island_id, cur_island_id, time"};

get_log(log_skill_lv_up) ->
    {"log_skill_lv_up", "role_id, skill_id, skill_lv, skill_up_lv, uptype, consume, time"};

get_log(log_enchantment_guard_battle) ->
    {"log_enchantment_guard_battle", "role_id, gate, reward_list, time"};

get_log(log_enchantment_guard_seal) ->
    {"log_enchantment_guard_seal", "role_id, seal_times, gate, reward_list, time"};

get_log(log_enchantment_guard_sweep) ->
    {"log_enchantment_guard_sweep", "role_id,sweep_times, gate, reward_list, time"};

get_log(log_boss_cost) ->
    {"log_boss_cost", "role_id, team_id, vip_lv, `type`, boss_type, boss_id, before_vit, before_last_vit_time, vit, last_vit_time, cost, time"};

get_log(log_vip_buy) ->
    {"log_vip_buy", "role_id, vip_type, costs, first_buy, award_list, vip_exp, forever, end_time, time"};

get_log(log_vip_goods) ->
    {"log_vip_goods", "role_id, goods_id, vip_type, vip_exp, forever, end_time, time"};

get_log(log_vip_lv) ->
    {"log_vip_lv", "role_id, vip_lv1, vip_lv2, time"};

get_log(log_vip_exp) ->
    {"log_vip_exp", "role_id, source, vip_type, goods_id, vip_lv1, vip_exp1, vip_lv2, vip_exp2, time"};

get_log(log_mon_pic_lv) ->
    {"log_mon_pic_lv", "role_id, pic_id, lv, cost, time"};

get_log(log_mystery_shop_bag) ->
    {"log_mystery_shop_bag", "role_id, cfg_id, cost, good_list, time"};

get_log(log_guild_battle_role) ->
    {"log_guild_battle_role", "role_id, guild_id, score, reward, time"};

get_log(log_guild_battle_rank) ->
    {"log_guild_battle_rank", "role_id, guild_id, reward, time"};

get_log(log_guild_battle) ->
    {"log_guild_battle", "guild_id, join_num, score, rank, time"};

get_log(log_terri_war_result) ->
    {"log_terri_war_result", "group_id, war_id, territory_id, round, winner, a_guild, a_guild_name, a_server, a_server_num, a_score, a_camp, b_guild, b_guild_name, b_server, b_server_num, b_score, b_camp, time"};

get_log(log_terri_war_allot_reward) ->
    {"log_terri_war_allot_reward", "guild_id, guild_name, role_id, alloc_type, reward_type, win_num, rewards, time"};

get_log(log_terri_war_battle_reward) ->
    {"log_terri_war_battle_reward", "role_id, territory_id, is_win, rewards, time"};

get_log(log_nine) ->
    {"log_nine", "role_id, name, score, layer_id, `type`, min_grade, max_grade, reward, time"};

get_log(log_holyorgan_hire) ->
    {"log_holyorgan_hire", "role_id, type, subtype, acc_hire_times, hire_cost, end_time, time"};

get_log(log_invite_box_reward) ->
    {"log_invite_box_reward", "role_id, daily_count, total_count, reward, time"};

get_log(log_invite_reward) ->
    {"log_invite_reward", "role_id, reward_type, reward_id, reward, time"};

get_log(log_race_act_cost) ->
    {"log_race_act_cost", "role_id, lv, type, subtype, cost, time"};

get_log(log_race_act_produce) ->
    {"log_race_act_produce", "role_id, type, subtype, reward, ptype, world_lv, time"};

get_log(log_race_act_rank) ->
    {"log_race_act_rank", "role_id, name, type, subtype, score, rank, zone, server_id, time"};

get_log(log_race_act) ->
    {"log_race_act", "server_id, type, subtype, open, time"};

get_log(log_race_act_score_cost) ->
    {"log_race_act_score_cost", "role_id, lv, type, subtype, handletype, oscore, cost, nscore, time"};

get_log(log_shake) ->
    {"log_shake" , "role_id, subtype, ctype, auto_buy, cost, grade_id, award, time"};

get_log(log_decoration_stage_up) ->
    {"log_decoration_stage_up", "role_id, goods_id, ogtype_id, cost, ngtype_id, time"};

get_log(log_decoration_level_up) ->
    {"log_decoration_level_up", "role_id, equip_pos, cost, pre_lv, cur_lv, time"};

get_log(log_fairy_stage) ->
    {"log_fairy_stage", "role_id, fairy_id, pre_stage, cur_stage, cost, time"};

get_log(log_fairy_level) ->
    {"log_fairy_level", "role_id, fairy_id, pre_level, pre_bless, cur_level, cur_bless, cost, time"};

get_log(log_spirit_rotary) ->
    {"log_spirit_rotary", "role_id, rotary_id, count, bless_value, new_bless_value, cost_list, reward_list, time"};

get_log(log_bonus_tree) ->
    {"log_bonus_tree", "role_id, type, subtype, draw_times, auto_buy, cost, grades, reward, utime"};

get_log(log_drum_sign) ->
    {"log_drum_sign", "name, role_id, lv, time"};

get_log(log_drum_cost) ->
    {"log_drum_cost", "role_id, type, cost, time"};

get_log(log_drum_refuce) ->
    {"log_drum_refuce", "node, role_id, sid, power, time"};

get_log(log_drum_refuce_mail) ->
    {"log_drum_refuce_mail", "role_id, time"};

get_log(log_drum_war) ->
    {"log_drum_war", "drum, zone, war, wid, wname, wsid, wform, wnum, wlive, wpower, fid, fname, fsid, fform, fnum, flive, fpower, result, time"};

get_log(log_drumwar_enter_scene) ->
    {"log_drumwar_enter_scene", "role_id, action, act_group, oscene, scene, time"};

get_log(log_glad_buy_times) ->
    {"log_glad_buy_times", "role_id, pre_gold, pre_bgold, buy_times, after_gold, after_bgold, time"};

get_log(log_glad_stage) ->
    {"log_glad_stage", "role_id, score, stage_reward, time"};

get_log(log_glad) ->
    {"log_glad", "role_id, rank, rival_id, rival_rank, result, after_rank, reward, time"};

get_log(log_glad_rank) ->
    {"log_glad_rank", "role_id, rank, score, reward, time"};

get_log(log_ugrade_arbitrament) ->
    {"log_ugrade_arbitrament", "role_id, weapon_id, olv, oscore, nlv, nscore, cost, time"};

get_log(log_loop_arbitrament) ->
    {"log_loop_arbitrament", "role_id, weapon_id, olooptimes, nlooptimes, scoreadd, time"};

get_log(log_role_guild_feast_fire) ->
    {"log_role_guild_feast_fire", "role_id, color, fire_wave, reward, dragon_spirit, guild_id, time"};

get_log(log_role_guild_feast_quiz) ->
    {"log_role_guild_feast_quiz", "role_id, stage, point, dragon_spirit, rank, reward, guild_id, no, tid, time"};

get_log(log_role_guild_feast_dragon) ->
    {"log_role_guild_feast_dragon", "role_id, reward, guild_id, time"};

get_log(log_wldboss_kill) ->
    {"log_wldboss_kill", "role_id, role_name, boss_id, type, rank, reward, time"};

get_log(log_custom_act_gwar) ->
    {"log_custom_act_gwar", "role_id, grade_id, reward, time"};

get_log(log_role_medal) ->
    {"log_role_medal", "role_id, cost, old_medal_lv, new_medal_lv, time"};

get_log(log_role_star_map) ->
    {"log_role_star_map", "role_id, cost, old_star_id, new_star_id, time"};

get_log(log_role_other_drop) ->
    {"log_role_other_drop", "role_id, mon_id, reward, time"};

get_log(log_role_attr_medicament) ->
    {"log_role_attr_medicament", "role_id, cost, lv, time"};
get_log(log_custom_act_reward) ->
    {"log_custom_act_reward", "player_id, type, subtype, reward_id, reward, time"};

get_log(log_custom_act_cost) ->
    {"log_custom_act_cost", "player_id, type, subtype, costlist, otherargs, time"};

get_log(log_goods_fusion) ->
    {"log_goods_fusion", "role_id, olv, oexp, nlv, nexp, fusion_list, time"};

get_log(log_enter_or_exit_boss) ->
    {"log_enter_or_exit_boss", "role_id, role_name, lv, stage, boss_id, boss_type, boss_name, stype, cost, stay_time, old_scene, x, y, team_id, stime"};

get_log(log_boss_kill) ->
    {"log_boss_kill", "role_id, role_name, lv, stage, boss_type, boss_id, boss_name, reward, team_id, stime"};

get_log(log_top_pk_enter_reward) ->
    {"log_top_pk_enter_reward", "role_id, count, reward, time"};

get_log(log_top_pk_stage_reward) ->
    {"log_top_pk_stage_reward", "role_id, rank_lv, reward, time"};

get_log(log_top_pk_season_reward) ->
    {"log_top_pk_season_reward", "server_num, role_id, role_name, rank, reward, time"};

get_log(log_seal_stren) ->
    {"log_seal_stren", "role_id, role_name, pos, goods_id, stren, new_stren, cost, stime"};

get_log(log_seal_pill) ->
    {"log_seal_pill","role_id, role_name, goods_id, num, new_num, cost, stime"};

get_log(log_draconic_stren) ->
    {"log_draconic_stren", "role_id, role_name, pos, goods_id, stren, new_stren, cost, stime"};

get_log(log_territory_reward) ->
    {"log_territory_reward", "role_id, role_name, dun_id, mon_id, reward, stime"};

get_log(log_territory_rank) ->
    {"log_territory_rank", "guild_id, guild_name, role_id, role_name, hurt, rank, reward, stime"};

get_log(log_custom_act_liveness) ->
    {"log_custom_act_liveness", "role_id, type, subtype, draw_times, cost, grades, reward, time"};

get_log(log_custom_act_liveness_ser_reward) ->
    {"log_custom_act_liveness_ser_reward", "type, subtype, grade_id, trigger_type, about, time"};

get_log(log_sanctuary_kill) ->
    {"log_sanctuary_kill", "role_id, mon_id, be_kill_role_id, reward_list, time"};

get_log(log_sanctuary_point) ->
    {"log_sanctuary_point", "role_id, mon_id, get_point_sanctuary_id, reduce_point_sanctuary_id, point, time"};

get_log(log_sanctuary_belong) ->
    {"log_sanctuary_belong", "sanctuary_id, belong_id, time"};

get_log(log_sanctuary_designation) ->
    {"log_sanctuary_designation", "sanctuary_id, belong_id, role_id, designation_id, time"};

get_log(log_kf_score_reward) ->
    {"log_kf_score_reward", "server_id,server_num,role_id,role_name,score,paid,reward,stime"};

get_log(log_cluster_sanctuary_occupy) ->
    {"log_cluster_sanctuary_occupy", "`zone_id`, `server_id`, `scene_id`, `time`"};

get_log(log_kf_san_construction_reward)->
    {"log_kf_san_construction_reward","san_type,scene,con_type,bl_server,server_id,server_num,role_id,role_name,reward,stime"};

get_log(log_kf_san_medal) ->
    {"log_kf_san_medal","server_id,server_num,role_id,rol_name,scene,monid,reward,stime"};

get_log(log_kf_san_kill_log) ->
    {"log_kf_san_kill_log","role_id,name,scene,construct,mon_id,mon_type,old_anger,new_anger,stime"};

get_log(log_buy_surprise_gift) ->
    {"log_buy_surprise_gift","role_id, gift_id, cost, reward_list, time"};

get_log(log_draw_surprise_gift) ->
    {"log_draw_surprise_gift","role_id, reward_list, draw_times, time"};

get_log(log_back_surprise_gift) ->
    {"log_back_surprise_gift","role_id, gift_id, back_day, reward_list, time"};

get_log(log_single_dungeon_sweep) ->
    {"log_single_dungeon_sweep","role_id,lv,combat_power,dun_id,dun_type,auto_num, cost, reward_list,time"};

get_log(log_monday_draw) ->
    {"log_monday_draw","role_id,role_name,cost,reward,draw_times,utime"};

get_log(log_eudemons_compose) ->
    {"log_eudemons_compose","role_id,role_name,cost_list,reward,utime"};

get_log(log_guild_guard_dungeon) ->
    {"log_guild_guard_dungeon","guild_id, result_type, challenge_guard, cycle_num, time"};

get_log(log_compensate_exp) ->
    {"log_compensate_exp", "`role_id`,`onhook_time`,`onhook_exp`,`lv`,`add_exp`,`new_lv`,`reward`,`time`"};

get_log(log_dragon_lv) ->
    {"log_dragon_lv", "role_id, goods_id, goods_type_id, lv_type, cost, old_lv, new_lv, old_show_lv, new_show_lv, old_quality, new_quality, time"};

get_log(log_dragon_equip) ->
    {"log_dragon_equip", "role_id, goods_id, goods_type_id, old_pos, new_pos, type, time"};

get_log(log_dragon_decompose) ->
    {"log_dragon_decompose", "role_id, goods_id, goods_type_id, lv, show_lv, quality, decompose_list, time"};

get_log(log_dragon_crucible_beckon) ->
    {"log_dragon_crucible_beckon", "role_id, start_time, end_time, crucible_id, cost, reward, old_count, new_count, time"};

get_log(log_dragon_crucible_reward) ->
    {"log_dragon_crucible_reward", "role_id, start_time, end_time, count, crucible_id, count_cfg, reward, time"};

get_log(log_dragon_pos_lv) ->
    {"log_dragon_pos_lv", "role_id, pos, old_lv, new_lv, type, time"};
get_log(log_bonus_draw) ->
    {"log_bonus_draw","type, subtype, role_id, role_name, wave, draw_times, cost, reward_type, reward, utime"};

get_log(log_dungeon_dragon_awards) ->
    {"log_dungeon_dragon_awards", "role_id, dun_id, wave, rewards, time"};

get_log(log_mount_figure_upgrade_star) ->
    {"log_mount_figure_upgrade_star", "role_id, type_id, fig_id, pre_star, cur_star, cost, time"};

get_log(log_3v3_today_reward) ->
    {"log_3v3_today_reward", "role_id, yesterday_tier, reward, time"};

get_log(log_god_equip_level) ->
    {"log_god_equip_level","role_id ,role_name ,pos ,old_level ,new_level ,cost ,stime"};

get_log(log_god_active) ->
    {"log_god_active", "role_id, god_id, time"};

get_log(log_god_lv_up) ->
    {"log_god_lv_up", "role_id, god_id, olv, nlv, old_exp, new_exp, cost, time"};

get_log(log_god_grade_up) ->
    {"log_god_grade_up", "role_id, god_id, ograde, ngrade, cost, time"};

get_log(log_god_up_star) ->
    {"log_god_up_star", "role_id, god_id, old_star, new_star, cost, time"};

get_log(log_god_stren) ->
    {"log_god_stren", "role_id, god_type, oldlevel, oldexp, level, exp, cost_list, time"};

get_log(log_adventure_throw) ->
    {"log_adventure", "role_id, stage, cost, ocircle, olocation, ncircle, nlocation, step, reward, time"};

get_log(log_adventure_shop) ->
    {"log_adventure_shop", "role_id, action, cost, reward, time"};

get_log(log_level_act) ->
    {"log_level_act", "rold_id, role_name, type, subtype, grade, cost, reward, stime"};

get_log(log_god_equip_goods) ->
    {"log_god_equip_goods", "role_id, god_id, pos_id, old_id, old_typeid, new_id, new_typeid, time"};

get_log(log_magic_circle) ->
    {"log_magic_circle", "role_id, magic_circle_id, cost, type, time, end_time"};

get_log(log_attr) ->
    {"log_attr", "role_id, old_combat_power, combat_power, attr, time"};

get_log(log_sanctum_boss) ->
    {"log_sanctum_boss", "scene, monid, server, stime"};

get_log(log_sanctum_rank) ->
    {"log_sanctum_rank", "scene, mon, rank, server_id, role_id, role_name, reward, stime"};

get_log(log_soul_awake) ->
    {"log_soul_awake", "`role_id`,`goods_id`,`goods_type_id`,`cost`,`cost_info_list`,`old_awake_lv_list`,`new_awake_lv_list`,old_lv,new_lv,old_soul_point,new_soul_point,`time`"};

get_log(log_soul_dismantle_awake) ->
    {"log_soul_dismantle_awake", "`role_id`,`goods_id`,`goods_type_id`,`awake_lv_list`,`return_goods_list`,`time`"};

get_log(log_act_pray) ->
    {"log_act_pray", "role_id, role_name, type, subtype, draw_type, cost, reward, stime"};

get_log(log_revelation_equip_goods) ->
    {"log_revelation_equip_goods", "`role_id`,`pos_id`,`old_id`,`old_typeid`,`new_id`,`new_typeid`,`time`"};

get_log(log_revelation_equip_swallow) ->
    {"log_revelation_equip_swallow", "`role_id`,`pos_id`,`cost`,`add_exp`,`last_exp`,`time`"};

get_log(log_revelation_equip_gathering) ->
    {"log_revelation_equip_gathering", "`role_id`,`lv`,`new_lv`,`cost_exp`,`last_exp`,`time`"};

get_log(log_revelation_equip_suit) ->
    {"log_revelation_equip_suit", "`role_id`,`suit`,`time`"};

get_log(log_demons_slot_skill) ->
    {"log_demons_slot_skill", "`role_id`, `role_name`, `demons_id`, `slot`, `bf_skill_id`, `bf_skill_lv`, `skill_id`, `skill_lv`, `cost`, `stime`"};

get_log(log_demons_shop_refresh) ->
    {"log_demons_shop_refresh", "`role_id`, `role_name`, `refresh_times`, `cost`, `stime`"};

get_log(log_protect) ->
    {"log_protect", "`role_id`,`type`,`value`,`scene_type`,`protect_time`,`use_count`,`time`"};

get_log(log_select_pool_rest) ->
    {"log_select_pool_rest", "`role_id`, `role_name`, `type`, `subtype`, `reward`, `reset`, `cost`, `stime`"};

get_log(log_supvip_active) ->
    {"log_supvip_active", "`role_id`,`type`,`cost`,`supvip_type`,`supvip_time`,`time`"};

get_log(log_supvip_skill_task) ->
    {"log_supvip_skill_task", "`role_id`,`stage`,`sub_stage`,`task_id`,`reward`,`time`"};

get_log(log_supvip_currency_task) ->
    {"log_supvip_currency_task", "`role_id`,`task_id`,`reward`,`time`"};

get_log(log_game_error) ->
    {"log_game_error", "`role_id`,`type`,`about`,`time`"};

get_log(log_rune_awake) ->
    {"log_rune_awake", "`role_id`,`goods_id`,`goods_type_id`,`cost`,`cost_info_list`,`old_awake_lv_list`,`new_awake_lv_list`,old_lv,new_lv,old_rune_point,new_rune_point,`time`"};

get_log(log_rune_dismantle_awake) ->
    {"log_rune_dismantle_awake", "`role_id`,`goods_id`,`goods_type_id`,`awake_lv_list`,`return_goods_list`,`time`"};

get_log(log_rune_skill_up) ->
    {"log_rune_skill_up", "`role_id`,`old_lv`,`new_lv`, `time`"};

get_log(log_cluster_auction_produce) ->
    {"log_cluster_auction_produce", "`type`,`produce_id`,`reward`, `role_list`, `stime`"};

get_log(log_cluster_point_rank) ->
    {"log_cluster_point_rank", "`role_id`,`role_name`,`server_num`, `point`, `time`"};

get_log(log_level_gift_send) ->
    {"log_level_gift_send", "`type`, `subtype`, `grade`, `role_id`, `role_name`, `role_lv`, `vip_exp`, `reward`, `stime`"};

get_log(log_3v3_team_member) ->
    {"log_3v3_team_member", "team_id, team_name, event_type, role_id, event_param, time"};

get_log(log_3v3_guess) ->
    {"log_3v3_guess", "role_id, turn, pk_res, opt, reward, cost, time"};

get_log(log_decoration_boss_enter) ->
    {"log_decoration_boss_enter", "`role_id`,`enter_type`,`is_had_assist`,`boss_id`,`time`"};

get_log(log_decoration_boss_reward) ->
    {"log_decoration_boss_reward", "`role_id`,`enter_type`,`boss_id`,`is_belong`,`reward`,`time`"};

get_log(log_decoration_sboss_hurt) ->
    {"log_decoration_sboss_hurt", "`role_id`,`name`,`server_id`,`zone_id`,`hurt`,`rank_no`,`is_belong`,`time`"};

get_log(log_decoration_sboss_reward) ->
    {"log_decoration_sboss_reward", "`role_id`,`is_belong`,`reward_type`,`reward`,`time`"};

get_log(log_beta_login_record) ->
    {"log_beta_login_record", "`accid`, `accname`, `role_id`, `old_lv`, `platform`, `stime`"};

get_log(log_beta_login_reward) ->
    {"log_beta_login_reward", "`accid`, `accname`, `role_id`, `platform`, `stime`"};

get_log(log_bonus_pool) ->
    {"log_bonus_pool", "`role_id`, `role_name`, `type`, `subtype`, `draw_times`, `cost`, `reward`, `stime`"};

get_log(log_treasure_map) ->
    {"log_treasure_map", "`role_id`, `type`, `scene_id`, `scene_xy`, `reward`, `time`"};

get_log(log_back_decoration) ->
    {"log_back_decoration", "`role_id`, `role_name`, `back_decoration_id`, `option_type`, `old_stage`, `now_stage`, `cost`, `time`"};

get_log(log_change_scene) ->
    {"log_change_scene", "`role_id`,`scene_id`,`dun_id`,`dun_type`,`remark`,`time`"};

get_log(log_title_info) ->
    {"log_title_info", "`role_id`, `role_name`,`title_id`, `old_star`, `star`, `cost`, `stime`"};

get_log(log_rank_dungeon_challengers) ->
    {"log_rank_dungeon_challengers", "`role_id`,`role_name`,`server_id`,`server_num`,`level`,`go_time`,`time`"};

get_log(log_rdungeon_challengers_reward) ->
    {"log_rdungeon_challengers_reward", "`role_id`,`level`,`rewards`,`time`"};

get_log(log_rdungeon_success) ->
    {"log_rdungeon_success", "`role_id`,`level`,`go_time`,`time`"};

get_log(log_bugle) ->
    {"log_bugle", "`role_id`, `type`, `msg`, `cost`, `stime`"};

get_log(log_pk) ->
    {"log_pk", "`server`, `role_id`, `role_name`, `enemy_server`, `enemy_id`, `enemy_name`, `type`, `scene`, `scene_type`, `stime`"};

get_log(log_role_wx_share) ->
    {"log_role_wx_share", "`role_id`,`count`,`reward`,`time`"};

get_log(log_week_dungeon_rank) ->
    {"log_week_dungeon_rank", "`dun_id`, `rank`, `pass_time`, `owners`, `time`"};

get_log(log_week_dungeon_settlement) ->
    {"log_week_dungeon_settlement", "`role_id`, `dun_id`, `sett_type`, `pass_time`, `help_type`, `succ_rewards`, `boss_rewards`, `time`"};

get_log(log_guild_daily_send) ->
    {"log_guild_daily_send", "`guild`, `guild_name`, `role`, `role_name`, `task_id`, `auto_id`, `num`, `stime`"};

get_log(log_guild_daily_recieve) ->
    {"log_guild_daily_recieve", "`guild`, `guild_name`, `role`, `role_name`, `task_id`, `auto_id`, `reward`, `stime`"};

get_log(log_boss_rotary_event) ->
    {"log_boss_rotary_event", "`role_id`, `opr`, `rotary_id`, `boss_type`, `boss_reward_lv`, `wlv`, `boss_id`, `reward_get`, `time`"};

get_log(log_boss_rotary_reward) ->
    {"log_boss_rotary_reward", "`role_id`, `rotary_id`, `boss_type`, `boss_reward_lv`, `wlv`, `pool_id`, `reward_id`, `costlist`, `rewards`, `time`"};

get_log(log_boss_cost_reborn) ->
    {"log_boss_cost_reborn", "`role_id`,`scene_id`,`x`,`y`,`boss_type`,`boss_id`,`cost`,`time`"};

get_log(log_role_wx_share_touch) ->
    {"log_role_wx_share_touch", "`role_id`,`time`"};

get_log(log_race_act_zone) ->
    {"log_race_act_zone", "`zone_id`,`type`,`subtype`,`world_lv`,`time`"};

get_log(log_race_act_rank_reward) ->
    {"log_race_act_rank_reward", "`role_id`,`name`,`zone_id`,`server_id`,`type`,`subtype`,`score`,`rank`,`reward`,`world_lv`,`time`"};

get_log(log_holy_battle_pk_group) ->
    {"log_holy_battle_pk_group", "`zone_id`,`copy_id`,`mod`,`result`,`time`"};


get_log(log_holy_battle_pk_role) ->
    {"log_holy_battle_pk_role","`role_id`,`server_num`,`server_id`,`zone_id`,`copy_id`,`point`,`time`"};


get_log(log_holy_battle_pk_point_reward) ->
    {"log_holy_battle_pk_point_reward","`role_id`,`mod`,`stage`,`result`,`time`"};

get_log(log_constellation_forge) ->
    {"log_constellation_forge","`role_id`,`role_name`,`equip_type`,`pos`,`option_type`,`old_stage`,`now_stage`,`cost`,`time`"};

get_log(log_constellation_evolution) ->
    {"log_constellation_evolution","`role_id`,`role_name`,`is_success`,`equip_id`,`goods_id`,
    `equip_type`,`old_stage`,`now_stage`,`cost`,`add_attr`,`time`"};

get_log(log_constellation_master) ->
    {"log_constellation_master","`role_id`,`role_name`,`equip_type`,`master_type`,`light_lv`,
    `equip_status`,`master_attr`,`time`"};

get_log(log_fortune_cat) ->
    {"log_fortune_cat","`role_id`,`role_name`,`type`,`sub_type`, `turn`,`reward`, `time`"};

get_log(log_kf_cloud_buy_act_start) ->
    {"log_kf_cloud_buy_act_start", "`type`,`subtype`,`start_type`,`start_time`,`end_time`, `time`"};

get_log(log_kf_cloud_buy_act_reset) ->
    {"log_kf_cloud_buy_act_reset", "`type`,`subtype`,`zone_list`,`time`"};

get_log(log_kf_cloud_buy_reward) ->
    {"log_kf_cloud_buy_reward", "`role_id`,`server_id`,`role_name`,`type`,`subtype`,`grade_id`,`buy_times`,`self_count`,`grade_count`,`reward_list`,`time`"};

get_log(log_kf_cloud_buy_stage_reward) ->
    {"log_kf_cloud_buy_stage_reward", "`role_id`,`role_name`,`type`,`subtype`,`stage_count`,`wlv`,`reward_list`,`time`"};

get_log(log_constellation_attr_change) ->
    {"log_constellation_attr_change", "`role_id`,`name`,`before_goods`,`attr`,`goods`,`target_attr`,`after_attr`,`stime`"};

get_log(log_constellation_decompose) ->
    {"log_constellation_decompose", "`role_id`,`name`,`decompose_list`,`level`,`old_exp`,`new_level`,`new_exp`,`stime`"};

get_log(log_constellation_star) ->
    {"log_constellation_star", "`role_id`,`name`,`op`,`star`,`old_level`,`level`,`max_level`,`stime`"};

get_log(log_constellation_compose) ->
    {"log_constellation_compose", "`role_id`,`name`,`compose_id`,`regular`,`irregular`,`point_list`,`cost`,`success`,`reward`,`stime`"};

get_log(log_kf_group_buy_compensate) ->
    {"log_kf_group_buy_compensate", "`role_id`,`type`,`subtype`,`grade_id`,`reward_list`,`time`"};

get_log(log_arcana_lv) ->
    {"log_arcana_lv", "`role_id`,`arcana_id`,`lv`,`cost`,`time`"};

get_log(log_arcana_break) ->
    {"log_arcana_break", "`role_id`,`arcana_id`,`break_lv`,`cost`,`time`"};

get_log(log_arcana_core) ->
    {"log_arcana_core", "`role_id`,`core_type`,`time`"};

get_log(log_real_info) ->
    {"log_real_info", "`role_id`,`role_name`,`type`,`phone`,`name`,`person_id`,`reward`,`time`"};

get_log(log_medal_stren) ->
    {"log_medal_stren", "`role_id`,`medal_lv`,`pre_stren_lv`,`pre_stren_exp`, `af_stren_lv`,`af_stren_exp`,`cost`,`time`"};

get_log(log_contract_challenge_task) ->
    {"log_contract_challenge_task", "`sub_type`, `role_id`, `role_name`, `task_id`, `grand_num`, `time`"};

get_log(log_contract_challenge_point) ->
    {"log_contract_challenge_point", "`sub_type`, `role_id`, `role_name`, `task_id`, `old_point`, `now_point`, `time`"};

get_log(log_god_court_strength) ->
    {"log_god_court_strength", "`role_id`, `role_name`, `court_id`, `old_lv`, `now_lv`, `cost`, `time`"};

get_log(log_god_court_equip_stage) ->
    {"log_god_court_equip_stage", "`role_id`, `role_name`, `court_id`, `pos`, `old_stage`, `now_stage`, `cost`, `time`"};

get_log(log_god_house_crystal) ->
    {"log_god_house_crystal", "`role_id`, `role_name`, `old_color`, `now_color`, `old_lv`, `old_exp` ,`now_lv`, `now_exp`, `cost`, `reward`, `time`"};

get_log(log_god_house_origin) ->
    {"log_god_house_origin", "`role_id`, `role_name`, `old_color`, `cost`, `daily_count`, `sum_count`, `time`"};

get_log(log_god_house_reward) ->
    {"log_god_house_reward", "`role_id`, `role_name`, `trigger_count`, `daily_count`, `reard_lv`, `reward`, `time`"};

get_log(log_sweep_bounty_task) ->
    {"log_sweep_bounty_task", "`role_id`, `count`, `reward`, `extra_reward`, `time`"};

get_log(log_sweep_guild_task) ->
    {"log_sweep_guild_task", "`role_id`, `count`, `reward`, `extra_reward`, `time`"};

get_log(log_chrono_rift_stage_reward) ->
    {"log_chrono_rift_stage_reward", "`role_id`, `stage_id`, `day_value`, `reward`, `time`"};

get_log(log_chrono_rift_goal_reward) ->
    {"log_chrono_rift_goal_reward", "`role_id`, `goal_id`, `reward`, `time`"};

get_log(log_chrono_rift_rank_reward) ->
    {"log_chrono_rift_rank_reward", "`role_id`, `server_id`, `server_num`, `zone_id`, `rank`, `reward`,`time`"};

get_log(log_chrono_rift_castle_reward) ->
    {"log_chrono_rift_castle_reward", "`role_id`, `castle_msg`, `reward`, `time`"};

get_log(log_chrono_rift_act) ->
    {"log_chrono_rift_act", "`role_id`, `mod`, `sub_mod`, `act_value` , `add_value`, `curr_day_value`, `curr_value`, `ratio`, `time`"};

get_log(log_chrono_rift_castle_add_value) ->
    {"log_chrono_rift_castle_add_value", "`role_id`, `zone_id`, `server_id`, `server_num` ,
    `castle_id`, `count`, `castle_server_id`, `af_castle_server_id`, `pre_server_list`, `af_server_list`, `value`, `af_value`, `time`"};

get_log(log_escort_boss_born) ->
    {"log_escort_boss_born", "`server_id`, `role_id`, `role_name`, `guild_id`, `guild_name` , `position`, `mon_type`, `scene`, `cost`, `stime`"};

get_log(log_escort_role) ->
    {"log_escort_role", "`server_id`, `role_id`, `role_name`, `guild_id`, `guild_name` , `mon_type`, `sum`, `reward`, `stime`"};

get_log(log_escort_guild) ->
    {"log_escort_guild", "`server_id`, `guild_id`, `guild_name` , `mon_type`, `res`, `reward`, `stime`"};

get_log(log_escort_rob) ->
    {"log_escort_rob", "`server_id`, `role_id`, `role_name`, `guild_id`, `guild_name` , `mon_type`, `scene`, `hurt`, `reward`, `stime`"};

get_log(log_escort_rank) ->
    {"log_escort_rank", "`server_id`, `role_id`, `role_name`, `guild_id`, `guild_name` , `score`, `rank`, `reward`, `guild_reward`, `stime`"};

get_log(log_sign_up_msg) ->
    {"log_sign_up_msg", "`role_id`, `mod_id`, `sub_mod_id`, `act_id`, `type` , `time`"};

get_log(log_dragon_language_boss) ->
    {"log_dragon_language_boss", "`server_id`, `role_id`, `cost`, `type` , `time`"};

get_log(log_guild_god) ->
    {"log_guild_god", "`role_id`, `god_id`, `type`, `color` , `lv`, `combo_id`, `achievement`, `new_color` ,
     `new_lv`, `new_combo_id`, `new_achievement` , `time`"};

get_log(log_guild_god_equip_rune) ->
    {"log_guild_god_equip_rune", "role_id, god_id, pos_id, old_id, old_typeid, new_id, new_typeid, time"};

get_log(log_guild_god_rune_upgrade) ->
    {"log_guild_god_rune_upgrade", "role_id, god_id, pos_id, old_id, old_typeid, new_id, new_typeid, time"};

get_log(log_launch_guild_assist) ->
    {"log_launch_guild_assist", "assist_id, role_id, type, sub_type, target_cfg_id, time"};

get_log(log_guild_assist_operation) ->
    {"log_guild_assist_operation", "role_id, assist_id, opr_type, extra_args, end_type, time"};

get_log(log_degrade_guild_title) ->
    {"log_degrade_guild_title", "role_id, week_got, prestige, new_prestige, time"};

get_log(log_seacraft_job) ->
    {"log_seacraft_job", "`camp`, `server_id`, `role_id`, `role_name`, `old_job_id`, `job_id`, `time`"};

get_log(log_seacraft_daily) ->
    {"log_seacraft_daily", "`camp`, `guild_id`, `guild_name`, `role_id`, `role_name`, `job_id`, `reward`, `time`"};

get_log(log_seacraft_reward) ->
    {"log_seacraft_reward", "`camp`, `guild_id`, `guild_name`, `act_type`, `role_id`, `role_name`, `rank`, `score`, `reward1`, `reward2`, `time`"};

get_log(log_seacraft_extra_reward) ->
    {"log_seacraft_extra_reward", "`act_type`, `camp`, `guild_id`, `guild_name`, `role_id`, `role_name`, `reward`, `time`"};

get_log(log_seacraft_result) ->
    {"log_seacraft_result", "`act_type`, `guild_id`, `guild_name`, `res`, `time`"};

get_log(log_equip_refinement_promote) ->
    {"log_equip_refinement_promote", "`role_id`, `equip_pos`, `refine_lv`, `costlist`, `time`"};

get_log(log_sea_craft_daily_carry_brick) ->
    {"log_sea_craft_daily_carry_brick", "`role_id`,`role_sea_id`,`carry_sea_id`,`my_sea_num`,
    `carry_sea_num`,`brick_num`,`brick_color`, `type`, `reward`,`time`"};

get_log(log_sea_craft_daily_upgrade_brick) ->
    {"log_sea_craft_daily_upgrade_brick", "`role_id`,`role_sea_id`,`brick_now_color`,`brick_af_color`,
    `cost`,`time`"};

get_log(log_sea_craft_daily_task) ->
    {"log_sea_craft_daily_task", "`role_id`,`task_id`,`now_count`,`af_count`,`time`"};

get_log(log_sea_craft_daily_defend) ->
    {"log_sea_craft_daily_defend", "`role_id`,`carry_server_id`,`carry_server_num`,`carry_role_id`,`defend_count`,`reward`,`time`"};

get_log(log_sea_craft_daily_rank_settle) ->
    {"log_sea_craft_daily_rank_settle", "`type`,`sea_id`,`role_id`,`server_id`, `server_num`,`brick_num`,`rank`,`reward`,`time`"};

get_log(log_seacraft_exploit) ->
    {"log_seacraft_exploit", "`role_id`, `role_name`, `add_exploit`,`exploit`,`produce`,`time` "};

get_log(log_seacraft_privilege_option) ->
    {"log_seacraft_privilege_option","`zone`, `camp`, `server_id`, `role_id`, `role_name`,
     `privilege_id`, `option`, `times`, `effect_time`, `time`"};

get_log(log_en_zero_gift) ->
    {"log_en_zero_gift","`role_id`, `gift_status`, `time`"};

get_log(log_god_auto_compose) ->
    {"log_god_auto_compose","`role_id`, `cost_mat`, `compose_equip`, `time`"};

get_log(log_afk_back) ->
    {"log_afk_back", "`role_id`,`count`,`cost`,`add_exp`,`time`"};

get_log(log_afk) ->
    {"log_afk", "`role_id`,`type`,`afk_left_time_bf`,`afk_left_time_af`,`afk_utime_bf`,`afk_utime_af`,`day_bgold_bf`,`day_bgold_af`,`multi`,`cost_afk_time`,`reward_list`,`time`"};
get_log(log_afk_off) ->
    {"log_afk_off", "`role_id`,`every_date`,`multi`,`ratio`,`player_ratio`,`lv`,`cp`,`new_lv`,`add_exp`,`add_coin`,`add_bgold`,`every_bgold`,`drop_list`,`time`"};

get_log(log_boss_first_blood_plus_boss) ->
    {"log_boss_first_blood_plus_boss", "`type`, `sub_type`,`boss_id`,`boss_scene_name`,`role_id`,`is_whole_first_blood`,`time`"};

get_log(log_boss_first_blood_plus_reward) ->
    {"log_boss_first_blood_plus_reward", "`type`,`sub_type`,`role_id`,`boss_id`,`reward`,`time`"};

get_log(log_companion_stage) ->
    {"log_companion_stage", "`role_id`,`companion_id`,`before_stage`,`before_star`,`before_blessing`,`after_stage`,`after_star`,`after_blessing`,`cost`,`time`"};

get_log(log_companion_train) ->
    {"log_companion_train", "`role_id`,`companion_id`,`train_num`,`cost`,`before_attr`,`after_attr`,`time`"};

get_log(log_custom_treasure) ->
    {"log_custom_treasure", "`role_id`, `role_name`, `type`, `subtype`, `turn`, `draw_times`, `lucky_value`, `reward`, `grade_list`, `time`"};

get_log(log_get_beta_recharge_reward) ->
    {"log_get_beta_recharge_reward", "`role_id`, `gold`, `return_gold`, `login_days`, `time`"};

get_log(log_dec_unlock_cell) ->
    {"log_dec_unlock_cell", "`role_id`, `unlock_list`, `time`"};

get_log(log_zone_change) ->
    {"log_zone_change", "`server_id`, `newzone`, `oldzone`, `time`"};

get_log(log_server_open) ->
    {"log_server_open", "server_status, server_type, node, server_id, server_num, platform, begin_time, end_time, cost_time, time"};

get_log(log_server_daily_clear) ->
    {"log_server_daily_clear", "log_type, begin_time, end_time, cost_time, time"};

get_log(log_server_hot) ->
    {"log_server_hot", "module_list, begin_time, end_time, cost_time, time"};

get_log(log_server_memory) ->
    {"log_server_memory", "memory_total, memory_processes, memory_atom, memory_binary, memory_code, memory_ets, process_cnt, ets_cnt, port_cnt, time"};

get_log(log_server_interface) ->
    {"log_server_interface", "`m`, `f`, `a`, result, cost_time, time"};

get_log(log_active_push_gift) ->
    {"log_active_push_gift", "role_id, gift_id, sub_id, active_time, end_time"};

get_log(log_buy_push_gift) ->
    {"log_buy_push_gift", "role_id, gift_id, sub_id, grade_id, costlist, rewards, time"};

get_log(log_sea_treasure_up) ->
    {"log_sea_treasure_up", "role_id, role_name, ship_id, ship_value, new_ship_id, new_ship_value, free_times, log_type, cost, time"};

get_log(log_sea_treasure) ->
    {"log_sea_treasure", "auto_id, ship_id, ser_id, role_id, role_name, log_type, rober_sid, rober_id, rober_name, reward, time"};

get_log(log_sea_treasure_rob) ->
    {"log_sea_treasure_rob", "ser_id, role_id, role_name, auto_id, ship_id, rober_sid, rober_id, rober_name, res, reward, time"};

get_log(log_sea_treasure_rback) ->
    {"log_sea_treasure_rback", "ser_id, role_id, helper_id, helper_name, auto_id, ship_id, rober_sid, rober_id,
        rober_name, res, rb_reward, reward, time"};

get_log(log_temple_awaken_chapter) ->
    {"log_temple_awaken_chapter", "role_id, chapter_id, status, time"};

get_log(log_temple_awaken_chapter_sub) ->
    {"log_temple_awaken_chapter_sub", "role_id, chapter_id, sub_chapter, status, time"};

get_log(log_temple_awaken_chapter_stage) ->
    {"log_temple_awaken_chapter_stage", "role_id, chapter_id, sub_chapter, stage, process, status, time"};

get_log(log_role_drop_ratio) ->
    {"log_role_drop_ratio", "`role_id`,`ratio_id`,`count`,`is_hit`,`time`"};

get_log(log_escape_stuck) ->
    {"log_escape_stuck", "role_id, scene_id, coordinate, time"};

get_log(log_suit_clt) ->
    {"log_suit_clt", "role_id, role_name, suit_id, clt_stage, time"};

get_log(log_boss_vit_change) ->
    {"log_boss_vit_change", "role_id, role_name, old_vit, last_time, cost, mon_id, vit, new_last_time, max_vit, add_vit, time"};

get_log(log_activity_onhook) ->
    {"log_activity_onhook", "role_id, startorend, module_id, sub_module, code, onhook_time, cost_coin, time"};

get_log(log_auto_forbid_chat) ->
    {"log_auto_forbid_chat", "`platform`, `ser_id`, `ser_name`, `role_id`, `name`, `role_lv`, `role_vip`, `reason`, `time`"};

get_log(log_dragon_ball) ->
    {"log_dragon_ball", "`role_id`, `ball_id`, `old_lv`, `new_lv`, `cost`, `time`"};

get_log(log_setting) ->
    {"log_setting", "`player_id`, `setting_list`, `time`"};

get_log(log_armour) ->
    {"log_armour", "player_id, player_name, stage, type, pos, equip_id, consume, equip_list, time"};

get_log(log_role_advertisement) ->
    {"log_role_advertisement", "role_id, mod_id, mod_sub_id, advertisement_id, time, count, reward, grade_id"};

get_log(log_gm_use) ->
    {"log_gm_use", "`role_id`, `name`, `content`, `time`"};

get_log(log_fiesta) ->
    {"log_fiesta", "role_id, reg_day, role_lv, fiesta_id, act_id, type, begin_time, expired_time, time"};

get_log(log_fiesta_task_progress) ->
    {"log_fiesta_task_progress", "role_id, task_type, task_id, progress, finish_times, status, acc_times, time"};

get_log(log_fiesta_task_reward) ->
    {"log_fiesta_task_reward", "role_id, task_id, oexp, nexp, time"};

get_log(log_fiesta_reward) ->
    {"log_fiesta_reward", "role_id, fiesta_id, lv, rewards, time"};

get_log(log_dungeon_rune_daily_reward) ->
    {"log_dungeon_rune_daily_reward", "role_id, level, level_list, reward_list, time"};

get_log(log_grow_welfare_task_process) ->
    {"log_grow_welfare_task_process", "`role_id`,`task_id`, `process`, `status`, `time`"};

get_log(log_combat_welfare_times) ->
    {"log_combat_welfare_times", "`role_id`,`role_name`, `power`, `times`, `time`"};

get_log(log_rush_treasure_rank) ->
    {"log_rush_treasure_rank", "role_id, name, type, subtype, rank_type, score, rank, zone, server_id, time"};

get_log(log_rush_treasure_rank_reward) ->
    {"log_rush_treasure_rank_reward", "`role_id`,`name`,`zone_id`,`server_id`,`type`,`subtype`, rank_type, `score`,`rank`,`reward`,`world_lv`,`time`"};

get_log(log_mount_upgrade_sys) ->
    {"log_mount_upgrade_sys", "`role_id`,`type_id`,`pre_level`,`pre_exp`,`exp_plus`,`cur_level`, `cur_exp`, `cost`,`time`"};get_log(log_envelope_rebate_reward) ->
    {"log_envelope_rebate_reward", "`type`,`sub_type`,`role_id`,`envelope_type`,`envelope_id`,`envelope_value`,`envelope_sum`,`time`"};

get_log(log_envelope_rebate_withdrawal) ->
    {"log_envelope_rebate_withdrawal", "`type`,`sub_type`,`role_id`,`envelope_type`,`envelope_ids`,`envelope_value`,`status`,`time`"};

get_log(log_beings_gate_activity) ->
    {"log_beings_gate_activity", "`server_id`,`yesterday_activity`,`portal_list`,`activity_time`,`time`"};

get_log(log_beings_gate_activity_cls) ->
    {"log_beings_gate_activity_cls", "`zone_id`,`group_id`,`mod`,`yesterday_activity`,`activity_time`,`portal_list`,`time`"};

get_log(log_combat_welfare_reward_info) ->
    {"log_combat_welfare_reward_info", "`role_id`,`role_name`, `round`, `reward_id`, `reward`, `time`"};

get_log(log_enchantment_guard_soap_debris) ->
    {"log_enchantment_guard_soap_debris", "`role_id`,`soap_id`, `debris_id`, `time`"};

get_log(log_weekly_card_open) ->
    {"log_weekly_card_open", "`role_id`,`open_lv`, `expired_time`, `open_time`"};

get_log(log_weekly_card_info) ->
    {"log_weekly_card_info", "`role_id`,`old_lv`, `new_lv`, `old_exp`, `new_exp`, `old_can_num`,`new_can_num`, `old_sum_num`, `new_sum_num`, `reward_list`, `time`"};

get_log(log_cycle_rank_role_score) ->
    {"log_cycle_rank_role_score", "`role_id`,`name`,`type`,`subtype`,`handletype`,`cost`,`oscore`,`add_score`,`nscore`,`time`"};

get_log(log_cycle_rank_reach) ->
    {"log_cycle_rank_reach", "`role_id`,`name`,`type`,`subtype`,`reward_id`,`reward`,`ptype`,`time`"};

get_log(log_cycle_rank_time) ->
    {"log_cycle_rank_time", "`server_id`,`type`,`subtype`,`open`,`time`"};

get_log(log_cycle_rank_rank) ->
    {"log_cycle_rank_rank", "`role_id`,`name`,`type`,`subtype`,`score`,`rank`,`server_id`,`time`"};

get_log(log_cycle_rank_rank_reward) ->
    {"log_cycle_rank_rank_reward", "`role_id`,`name`,`server_id`,`type`,`subtype`,`score`,`rank`,`reward`,`time`"};

get_log(log_night_ghost_boss) ->
    {"log_night_ghost_boss", "zone_id, group_id, scene_id, boss_id, x, y, type, time"};

get_log(log_night_ghost_rank) ->
    {"log_night_ghost_rank", "zone_id, group_id, scene_id, boss_id, sign, sign_id, ser_id, role_id, rank, hurt, time"};

get_log(log_night_ghost_killer) ->
    {"log_night_ghost_killer", "zone_id, group_id, scene_id, boss_id, ser_id, team_id, role_id, time"};

get_log(log_night_ghost_reward) ->
    {"log_night_ghost_reward", "role_id, type, rank, rewards, time"};

get_log(log_treasure_hunt_imitate) ->
    {"log_treasure_hunt_imitate", "simulation_id, hunt_type, times, lucky_value, reward_id, rewards, time, reward_type, is_rare"};

get_log(log_midnight_common_rank) ->
    {"log_midnight_common_rank", "player_id, player_name, rank_type, rank, value, second_value, third_value, time"};

get_log(log_level_act_open) ->
    {"log_level_act_open", "role_id, type, subtype, start_time, end_time"};

get_log(log_great_demon_boss_kf) ->
    {"log_great_demon_boss_kf", "zone_id, boss_id, kill_id, kill_name, kill_platform, kill_server_name, bl_who_1, bl_who_2, bl_who_3, time"};


get_log(_) ->
    {"log_test", "`type`, `time`"}.
