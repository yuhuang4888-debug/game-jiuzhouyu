%%%---------------------------------------
%%% module      : data_error_code
%%% description : 错误码配置
%%%
%%%---------------------------------------
-module(data_error_code).
-compile(export_all).
-include("common.hrl").




get(fail) ->
0;


get(success) ->
1;


get(empty_error) ->
2;


get(gold_not_enough) ->
1001;


get(coin_not_enough) ->
1002;


get(goods_not_enough) ->
1003;


get(money_not_enough) ->
1004;


get(missing_config) ->
1005;


get(bgold_not_enough) ->
1006;


get(player_add_exp) ->
1007;


get(not_enough_length) ->
1008;


get(name_exist) ->
1009;


get(illegal_character) ->
1010;


get(not_have_free_card) ->
1011;


get(lv_limit) ->
1012;


get(vip_limit) ->
1013;


get(cannot_transferable_scene) ->
1014;


get(cannot_transferable_area) ->
1015;


get(err_config) ->
1016;


get(figure_actived) ->
1017;


get(data_error) ->
1018;


get(cell_beyond) ->
1019;


get(player_add_exp_extra) ->
1020;


get(player_lv_less) ->
1021;


get(player_lv_large) ->
1022;


get(operation_too_quickly) ->
1023;


get(system_busy) ->
1024;


get(honour_not_enough) ->
1025;


get(in_forbid_pk_status) ->
1026;


get(player_die) ->
1027;


get(reward_is_got) ->
1028;


get(what_not_enough) ->
1029;


get(server_no_zone) ->
1030;


get(kf_server_allot) ->
1031;


get(error_count_limit) ->
1032;


get(over_max) ->
1033;


get(player_lv_less_to_open) ->
1034;


get(player_lv_large_to_end) ->
1035;


get(open_begin_less_to_open) ->
1036;


get(open_end_large_to_end) ->
1037;


get(merge_begin_less_to_open) ->
1038;


get(merge_end_large_to_end) ->
1039;


get(currency_not_enough) ->
1040;


get(not_open) ->
1041;


get(err_gm_stop) ->
1042;


get(rune) ->
1043;


get(rune_goods) ->
1044;


get(err102_setting_key_not_exist) ->
1020001;


get(err102_too_frequent) ->
1020002;


get(err110_voice_lose_efficacy) ->
1100001;


get(err110_lv_limit) ->
1100002;


get(err110_unknow_channel) ->
1100003;


get(err110_in_cd) ->
1100004;


get(err110_content_repeat) ->
1100005;


get(err110_no_report_times) ->
1100006;


get(err110_channel_cd_not_enough) ->
1100007;


get(err110_can_not_add_goods_to_kf_chat) ->
1100008;


get(err110_max_msg_length) ->
1100009;


get(err_110_sea_muted) ->
1100010;


get(err_110_no_camp) ->
1100011;


get(err110_update_chat_system) ->
1100012;


get(err112_dress_not_exist) ->
1120001;


get(err112_dress_has_enabled) ->
1120002;


get(err112_dress_not_enabled) ->
1120003;


get(err112_dress_not_used) ->
1120004;


get(err112_dress_max_level) ->
1120005;


get(err112_debrisnum_illegal) ->
1120006;


get(err112_dress_arg_empty) ->
1120007;


get(err112_dress_id_used) ->
1120008;


get(err113_wx_share_source_not_right) ->
1130001;


get(err113_wx_share_count_max) ->
1130002;


get(err113_wx_not_collect) ->
1130003;


get(err113_receive_wx_collect_reward) ->
1130004;


get(err113_wx_can_not_collect) ->
1130005;


get(err113_already_collect) ->
1130006;


get(err120_cannot_transfer_scene) ->
1200001;


get(err120_cannot_transfer_not_in_safe) ->
1200002;


get(err120_cannot_transfer_pre_scene_time) ->
1200003;


get(err120_cannot_transfer_change_scene_sign) ->
1200004;


get(err120_cannot_transfer_scene_not_exist) ->
1200005;


get(err120_cannot_transfer_lv_not_reach) ->
1200006;


get(err120_cannot_transfer_in_dungeon) ->
1200007;


get(err120_same_line) ->
1200008;


get(err120_to_many_people) ->
1200009;


get(err120_is_on_battle) ->
1200010;


get(err120_cannot_transfer_on_battle) ->
1200011;


get(err120_scene_loading) ->
1200012;


get(err120_is_near) ->
1200013;


get(err120_no_fly_shoes) ->
1200014;


get(err120_cannot_battle_change_scene_sign) ->
1200015;


get(err120_max_user) ->
1200016;


get(err120_transtype) ->
1200017;


get(err120_already_in_scene) ->
1200018;


get(err120_cannot_transfer_to_target_scene) ->
1200019;


get(err130_change_pk_change_line) ->
1300001;


get(err130_change_pk_cd) ->
1300002;


get(err130_user_cant_change_pk) ->
1300003;


get(err130_change_pk_lv_lim) ->
1300004;


get(err130_no_peace) ->
1300005;


get(err130_not_change) ->
1300006;


get(err130_no_peace_ultimate) ->
1300007;


get(err130_transfer_lv_limit) ->
1300008;


get(err130_transfer_sex_limit) ->
1300009;


get(err130_transfer_career_same_limit) ->
1300010;


get(err130_transfer_cd_limit) ->
1300011;


get(err130_transfer_career_err) ->
1300012;


get(err130_user_cant_change_this_pk) ->
1300013;


get(err130_picture_active) ->
1300014;


get(err130_cannot_recareer_inteam) ->
1300015;


get(err130_cannot_recareer_inactivity) ->
1300016;


get(err130_no_picture) ->
1300017;


get(err130_picture_limit) ->
1300018;


get(err130_has_uploaded_daily) ->
1300019;


get(err130_escape_not_change_scene) ->
1300020;


get(err131_reply_error) ->
1310001;


get(err131_player_die) ->
1310002;


get(err131_hp_max) ->
1310003;


get(err131_time_error) ->
1310004;


get(err131_scene_limit) ->
1310005;


get(err131_sit_down_first) ->
1310006;


get(err132_no_redemption_exp) ->
1320001;


get(err132_not_enough) ->
1320002;


get(err132_no_left_back_exp) ->
1320003;


get(err132_over_max_back_count) ->
1320004;


get(err132_not_enough_afk_unit_time) ->
1320005;


get(err132_no_afk_left_time) ->
1320006;


get(err132_in_afk_stop_et) ->
1320007;


get(err132_bag_full_not_to_get_afk_goods) ->
1320008;


get(err133_max_gate) ->
1330001;


get(err133_err_gate) ->
1330002;


get(err133_no_exist_sweep) ->
1330003;


get(err133_max_sweep_times) ->
1330004;


get(err133_not_single) ->
1330005;


get(err133_no_enough_wave) ->
1330006;


get(err133_err_rank_type) ->
1330007;


get(err133_not_enough_spirit) ->
1330008;


get(err133_err_config) ->
1330009;


get(err133_not_enough_seal_times) ->
1330010;


get(err133_err_stage_gate) ->
1330011;


get(err133_active_pre_soap) ->
1330012;


get(err133_active_pre_debris) ->
1330013;


get(err134_max_lv) ->
1340000;


get(err134_power_not_enough) ->
1340001;


get(err134_have_not_finish_dun) ->
1340002;


get(lv_not_enougth) ->
1340003;


get(title_is_not_exists) ->
1340004;


get(max_title_star) ->
1340005;


get(title_is_not_active) ->
1340006;


get(title_is_not_equip) ->
1340007;


get(err135_not_open) ->
1350001;


get(err135_can_not_change_scene_in_nine) ->
1350002;


get(err137_not_sign_state) ->
1370001;


get(err137_has_sign) ->
1370002;


get(err137_tool_not_enough) ->
1370003;


get(err137_lv_not_enough) ->
1370004;


get(err137_buy_limit) ->
1370005;


get(err137_not_sign) ->
1370006;


get(err137_not_prepare_state) ->
1370007;


get(err137_is_in_prepare) ->
1370008;


get(err137_not_allow_select_same) ->
1370009;


get(err137_cfg_error) ->
1370010;


get(err137_not_need_to_leave) ->
1370011;


get(err137_not_guess_state) ->
1370012;


get(err137_not_guess_zone_role) ->
1370013;


get(err137_not_guess_act_role) ->
1370014;


get(err137_not_select_empty_role) ->
1370015;


get(err137_not_select_same_plat) ->
1370016;


get(err137_skill_cd) ->
1370017;


get(err137_fight_allow_use) ->
1370018;


get(err137_error_skill) ->
1370019;


get(err137_not_in_prepare) ->
1370020;


get(err137_be_kill_not_buy) ->
1370021;


get(err137_power_out) ->
1370022;


get(err137_in_drum_war) ->
1370023;


get(err137_guess_reward_get) ->
1370024;


get(err137_guees_fail) ->
1370025;


get(err137_no_guess) ->
1370026;


get(err137_had_guess_act) ->
1370027;


get(err137_open_day_limit) ->
1370028;


get(err138_had_reward) ->
1380001;


get(err138_not_open) ->
1380002;


get(err139_no_loop_times) ->
1390001;


get(err139_had_equip) ->
1390002;


get(err139_not_active) ->
1390003;


get(err140_1_myself_friend_num_limit) ->
1400001;


get(err140_2_other_friend_num_limit) ->
1400002;


get(err140_3_role_no_exist) ->
1400003;


get(err140_4_is_friend) ->
1400004;


get(err140_5_not_reply_myself_ask) ->
1400005;


get(err140_6_not_friend) ->
1400006;


get(err140_7_not_exist_by_type) ->
1400007;


get(err140_9_exist_rela) ->
1400009;


get(err140_10_not_enemy) ->
1400010;


get(err140_12_present_max) ->
1400012;


get(err140_13_intimacy_max) ->
1400013;


get(err140_14_not_online) ->
1400014;


get(err140_19_no_ask_to_be_friend) ->
1400019;


get(err140_20_no_friend_ask) ->
1400020;


get(err140_21_name_is_wrongful) ->
1400021;


get(err140_22_not_scene) ->
1400022;


get(err140_25_in_blacklist) ->
1400025;


get(err140_26_recommended_too_often) ->
1400026;


get(err140_27_myself_black_list_num_limit) ->
1400027;


get(err140_28_in_another_blacklist) ->
1400028;


get(err140_29_not_same_server_player) ->
1400029;


get(err140_in_another_blacklist_to_do_sth) ->
1400030;


get(err140_cannot_del_lover) ->
1400031;


get(err140_cannot_pull_black_lover) ->
1400032;


get(err_141_no_decoration) ->
1410001;


get(err_141_had_illusion) ->
1410002;


get(err_141_had_no_illusion) ->
1410003;


get(err_141_had_active) ->
1410004;


get(err_141_error_cfg) ->
1410005;


get(err_141_max_stage) ->
1410006;


get(err_141_had_no_active) ->
1410007;


get(err_141_stage_not_match) ->
1410008;


get(err142_no_active) ->
1420001;


get(err142_had_active) ->
1420002;


get(err142_had_fight) ->
1420003;


get(err142_max_stage) ->
1420004;


get(err142_train_limit) ->
1420005;


get(err142_recharge_not_enough) ->
1420007;


get(err142_no_finish_task) ->
1420008;


get(err142_biog_had_unlock) ->
1420009;


get(err142_stage_star_not_enough) ->
1420010;


get(err143_had_active) ->
1430001;


get(err143_max_lv) ->
1430002;


get(err143_no_active) ->
1430003;


get(err143_statue_not_active) ->
1430004;


get(err143_figure_not_active) ->
1430005;


get(err143_same_figure) ->
1430006;


get(err143_figure_not_wear) ->
1430007;


get(err143_had_active_figure) ->
1430008;


get(err143_last_figure_not_active) ->
1430009;


get(err143_figure_not_enough_balls) ->
1430010;


get(err144_param_error) ->
1440001;


get(err144_lv_not_enough) ->
1440002;


get(err144_pre_stage_not_made) ->
1440003;


get(err144_pos_has_made) ->
1440004;


get(err145_1_role_no_exist) ->
1450001;


get(err145_2_word_is_sensitive) ->
1450002;


get(err148_not_exist_fairy) ->
1480000;


get(err148_stage_limit) ->
1480001;


get(err148_level_limit) ->
1480002;


get(err148_fairy_not_active) ->
1480003;


get(err149_equip_stage_limit) ->
1490000;


get(err149_err_dec) ->
1490001;


get(err149_stage_max) ->
1490002;


get(err149_level_max) ->
1490003;


get(err149_stage_cost) ->
1490004;


get(err149_level_cost) ->
1490005;


get(err149_lev_not_enough) ->
1490006;


get(err149_cell_lock_limit) ->
1490007;


get(err150_fail) ->
1500000;


get(err150_no_goods) ->
1500001;


get(err150_no_money) ->
1500002;


get(err150_no_cell) ->
1500003;


get(err150_npc_far) ->
1500004;


get(err150_in_sell) ->
1500005;


get(err150_price_err) ->
1500006;


get(err150_palyer_err) ->
1500007;


get(err150_location_err) ->
1500008;


get(err150_not_sell) ->
1500009;


get(err150_num_err) ->
1500010;


get(err150_cell_max) ->
1500011;


get(err150_type_err) ->
1500012;


get(err150_require_err) ->
1500013;


get(err150_attrition_full) ->
1500014;


get(err150_no_goods_type) ->
1500015;


get(err150_in_cd) ->
1500016;


get(err150_lv_err) ->
1500017;


get(err150_player_die) ->
1500018;


get(err150_not_trhow) ->
1500019;


get(err150_no_drop) ->
1500020;


get(err150_no_drop_per) ->
1500021;


get(err150_time_not_start) ->
1500022;


get(err150_time_end) ->
1500023;


get(err150_gift_unactive) ->
1500024;


get(err150_no_rule) ->
1500025;


get(err150_rule_unactive) ->
1500026;


get(err150_shop_time_limit) ->
1500027;


get(err150_goods_num_zero) ->
1500028;


get(err150_gift_got) ->
1500029;


get(err150_num_limit) ->
1500030;


get(err150_storage_no_cell) ->
1500031;


get(err150_scene_wrong) ->
1500032;


get(err150_npc_type_err) ->
1500033;


get(err150_hp_mp_full) ->
1500034;


get(err150_num_over) ->
1500035;


get(err150_skill_fail) ->
1500036;


get(err150_fashion_expire) ->
1500037;


get(err150_scene_pos) ->
1500038;


get(err150_not_event) ->
1500039;


get(err150_nothing) ->
1500040;


get(err150_cannot_replace_mid) ->
1500041;


get(err150_cannot_replace_big) ->
1500042;


get(err150_no_guild) ->
1500043;


get(err150_num_single_limit) ->
1500044;


get(err150_num_single_over) ->
1500045;


get(err150_distance) ->
1500046;


get(err150_vip_coin) ->
1500047;


get(err150_lv_goods) ->
1500048;


get(err150_num_notmatch) ->
1500049;


get(err150_seqlist_notmatch) ->
1500050;


get(err150_no_gift_type) ->
1500051;


get(err150_goods_expired) ->
1500052;


get(err150_no_career_gift) ->
1500053;


get(err150_exper_error) ->
1500054;


get(err150_compose_goods_not_enough) ->
1500055;


get(err150_goods_id_err) ->
1500056;


get(err150_exper_time_more_than_7hour) ->
1500057;


get(err150_gift_cfg_missing) ->
1500058;


get(err150_gift_status_error) ->
1500059;


get(err150_gift_nobegin) ->
1500060;


get(err150_gift_overtime) ->
1500061;


get(err150_gift_data_error) ->
1500062;


get(err150_gift_fetch_error) ->
1500063;


get(err150_gift_card_err_len) ->
1500064;


get(err150_gift_card_not_exist) ->
1500065;


get(err150_gift_card_no_gift_type) ->
1500066;


get(err150_gift_card_platform_error) ->
1500067;


get(err150_gift_card_has_trigger) ->
1500068;


get(err150_gift_card_nobegin) ->
1500069;


get(err150_gift_card_overtime) ->
1500070;


get(err150_gift_card_has_use_same_card) ->
1500071;


get(err150_gift_card_gift_not_exist) ->
1500072;


get(err150_lv_gfit_cfg_err) ->
1500073;


get(err150_good_in_expire) ->
1500074;


get(err150_pk_value_0) ->
1500075;


get(err150_not_compose_mat) ->
1500076;


get(err150_no_cell_to_compose) ->
1500077;


get(err150_no_money_to_compose) ->
1500078;


get(err150_not_satisfy_compose_lv) ->
1500079;


get(err150_compose_success) ->
1500080;


get(err150_compose_fail) ->
1500081;


get(err150_no_null_cell_decompose_fail) ->
1500082;


get(err150_user_use_dsgt) ->
1500083;


get(err150_renew_cf_miss) ->
1500084;


get(err150_bag_location_fail) ->
1500085;


get(err150_compose_type_lock) ->
1500086;


get(err150_notin_drop_scene) ->
1500087;


get(err150_not_drop_copyid) ->
1500088;


get(err150_drop_no_hp) ->
1500089;


get(err150_no_hurt_drop) ->
1500090;


get(err150_drop_overlv) ->
1500091;


get(err150_no_boss_tired) ->
1500092;


get(err150_no_drop_boss_tired) ->
1500093;


get(err150_gift_reward_miss) ->
1500094;


get(err150_lv_not_enough) ->
1500095;


get(err150_decompose_wear) ->
1500096;


get(err150_currency_not_enough) ->
1500097;


get(err150_day_not_enough) ->
1500098;


get(err150_soul_bag_full) ->
1500099;


get(err150_onhook_time_enough) ->
1500100;


get(err150_eudemonds_bag_nocell) ->
1500101;


get(err150_seal_bag_nocell) ->
1500102;


get(err150_mount_equip_bag_nocell) ->
1500103;


get(err150_mount_equip_bag_full) ->
1500104;


get(err150_card_ok_send) ->
1500105;


get(err150_rune_bag_no_cell) ->
1500106;


get(err150_soul_bag_no_cell) ->
1500107;


get(err150_eudemons_bag_no_cell) ->
1500108;


get(err150_not_god_equip) ->
1500109;


get(err150_god_bag_prot_limit) ->
1500110;


get(err150_sex_limit) ->
1500111;


get(err150_no_cell_equip_bag) ->
1500112;


get(err150_no_cell_god_equip_bag) ->
1500113;


get(err150_not_picture_goods) ->
1500114;


get(err150_gift_no_count) ->
1500115;


get(err150_gift_in_freeze) ->
1500116;


get(err150_no_fusion_equip) ->
1500117;


get(err150_goods_cannt_fusion) ->
1500118;


get(err150_gift_card_channel_can_not_use) ->
1500119;


get(err150_custom_price_invalid) ->
1500120;


get(err150_start_pick_drop) ->
1500121;


get(err150_other_picking) ->
1500122;


get(err150_pick_time_not_enough) ->
1500123;


get(err150_drop_timeout) ->
1500124;


get(err150_lv_err_2) ->
1500125;


get(err150_drop_overlv_with_args) ->
1500126;


get(err150_drop_not_enough_hurt) ->
1500127;


get(err150_drop_server_diff) ->
1500128;


get(err150_hurt_ratio) ->
1500129;


get(err150_mate_equip_bag_full) ->
1500130;


get(err150_decoration_no_cell) ->
1500131;


get(err150_seal_no_cell) ->
1500132;


get(err150_mount_equip_no_cell) ->
1500133;


get(err150_mate_equip_no_cell) ->
1500134;


get(err150_demons_skill_no_cell) ->
1500135;


get(err150_drop_camp_diff) ->
1500136;


get(err150_constellation_no_cell) ->
1500137;


get(err150_not_enough_run_dun) ->
1500138;


get(err150_gift_card_length_illegal) ->
1500139;


get(err150_cannt_use_goods_over_exp) ->
1500140;


get(err150_can_not_storge) ->
1500141;


get(err150_lv_not_enough_gift) ->
1500142;


get(err150_gift_card_racharge_not_enough) ->
1500143;


get(err150_gift_card_use_count_not_enough) ->
1500144;


get(err150_drop_guild_diff) ->
1500145;


get(err151_not_sell_category) ->
1510001;


get(err151_sell_times_limit) ->
1510002;


get(err151_specify_sell_times_limit) ->
1510003;


get(err151_max_sell_up_num) ->
1510004;


get(err151_goods_info_err) ->
1510005;


get(err151_goods_not_exist) ->
1510006;


get(err151_not_seller) ->
1510007;


get(err151_no_null_cells) ->
1510008;


get(err151_specify_role_lv_not_enough) ->
1510009;


get(err151_can_not_buy_self_goods) ->
1510010;


get(err151_not_specify_role) ->
1510011;


get(err151_bind_cannot_sell) ->
1510012;


get(err151_not_enough_gold) ->
1510013;


get(err151_goods_sell_down) ->
1510014;


get(err151_vip_lv_not_enough) ->
1510015;


get(err151_min_unit_price_lim) ->
1510016;


get(err151_max_unit_price_lim) ->
1510017;


get(err151_sell_up_once_num_lim) ->
1510018;


get(err151_seller_not_match) ->
1510019;


get(err151_seek_goods_info_err) ->
1510020;


get(err151_can_not_sell_self_goods) ->
1510021;


get(err151_buyer_times_limit) ->
1510022;


get(err151_no_seek_goods) ->
1510023;


get(err151_not_my_goods) ->
1510024;


get(err151_seek_times_err) ->
1510025;


get(err151_cannot_seek_err) ->
1510026;


get(err151_today_got_max_gold) ->
1510027;


get(err151_seller_today_got_max_gold) ->
1510028;


get(err151_shout_id_cd) ->
1510029;


get(err152_expire_err) ->
1520001;


get(err152_lv_err) ->
1520002;


get(err152_location_err) ->
1520003;


get(err152_type_err) ->
1520004;


get(err152_stren_limit) ->
1520014;


get(err152_missing_cfg) ->
1520017;


get(err152_equip_pos_err) ->
1520019;


get(err152_stone_part_err) ->
1520020;


get(err152_pos_no_stone) ->
1520024;


get(err152_pos_no_equip) ->
1520025;


get(err152_career_error) ->
1520026;


get(err152_equip_type_error) ->
1520029;


get(err152_has_stren_cant_unequip) ->
1520035;


get(err152_max_stage) ->
1520036;


get(err152_not_upgrade_stage_quality) ->
1520037;


get(err152_not_upgrade_stage_pos) ->
1520038;


get(err152_not_enough_upgrade_stage_cost) ->
1520039;


get(err152_not_equip_cannot_upgrade_stage) ->
1520040;


get(err152_has_unlock_wash_pos) ->
1520041;


get(err152_no_equip_cannot_wash) ->
1520042;


get(err152_wash_pos_locked) ->
1520043;


get(err152_can_not_lock_all) ->
1520044;


get(err152_has_wash_cant_unequip) ->
1520045;


get(err152_wash_normal_cost_not_enough) ->
1520046;


get(err152_wash_extra_cost_not_enough) ->
1520047;


get(err152_role_lv_not_satisfy_wash_lv) ->
1520048;


get(err152_attr_num_not_satisfy_division) ->
1520049;


get(err152_no_equip_can_not_upgrade_division) ->
1520050;


get(err152_rating_not_satisfy_division) ->
1520051;


get(err152_max_division) ->
1520052;


get(err152_stone_pos_lock) ->
1520053;


get(err152_max_refine_lv) ->
1520054;


get(err152_has_refine_cant_unequip) ->
1520055;


get(err152_make_suit_error) ->
1520056;


get(err152_casting_spirit_pos_lock) ->
1520057;


get(err152_casting_spirit_lv_lim) ->
1520059;


get(err152_casting_spirit_equip_stage_not_enough) ->
1520060;


get(err152_casting_spirit_max_lv) ->
1520061;


get(err152_casting_spirit_material_not_enough) ->
1520062;


get(err152_spirit_max_lv) ->
1520063;


get(err152_upgrade_spirit_material_not_enough) ->
1520064;


get(err152_has_awakening_cant_unequip) ->
1520065;


get(err152_not_awakening_equip) ->
1520066;


get(err152_awakening_lv_lim) ->
1520067;


get(err152_awakening_cost_not_enough) ->
1520068;


get(err152_sex_error) ->
1520069;


get(err152_turn_error) ->
1520070;


get(err152_equip_skill_awakening_lim) ->
1520071;


get(err152_equip_skill_has_skill) ->
1520072;


get(err152_equip_skill_cfg_err) ->
1520073;


get(err152_equip_skill_skill_type_lim) ->
1520074;


get(err152_equip_skill_no_cost_to_add_skill) ->
1520075;


get(err152_equip_skill_no_skill_to_remove) ->
1520076;


get(err152_equip_skill_no_cost_to_remove) ->
1520077;


get(err152_equip_skill_no_cost_upgrade) ->
1520078;


get(err152_equip_skill_no_skill_to_upgrade) ->
1520079;


get(err152_equip_skill_skill_lv_lim) ->
1520080;


get(err152_refine_limit) ->
1520081;


get(err152_stone_max_lv) ->
1520082;


get(err152_stone_not_enough) ->
1520083;


get(err152_equip_stren_wrong) ->
1520084;


get(err152_equip_refine_wrong) ->
1520085;


get(err152_stone_refine_limit) ->
1520086;


get(err152_no_order) ->
1520087;


get(err152_suit_stage_max) ->
1520088;


get(err152_not_make_suit) ->
1520089;


get(err152_stren_no_goods) ->
1520090;


get(err152_refine_no_goods) ->
1520091;


get(err152_suit_stage_max_2) ->
1520092;


get(err152_cannot_equip_lower_suit_equip) ->
1520093;


get(err152_god_equip_max_lv) ->
1520094;


get(err152_not_equip_anything) ->
1520095;


get(err152_equip_stage_star_limit) ->
1520096;


get(err152_no_wash_free_times) ->
1520097;


get(err152_not_clt_stage) ->
1520098;


get(err152_suit_clt_is_active) ->
1520099;


get(err152_suit_clt_turn_err) ->
1520100;


get(err152_equip_not_enough) ->
1520101;


get(err152_fashion_weared) ->
1520102;


get(err152_fashion_unweared) ->
1520103;


get(err152_no_such_suit_lv) ->
1520104;


get(err152_pre_suit_not_activate) ->
1520105;


get(err153_goods_not_on_sale) ->
1530000;


get(err153_goods_sold_out) ->
1530001;


get(err153_goods_not_equal) ->
1530002;


get(err153_bag_not_enough) ->
1530003;


get(err153_give_goods_failure) ->
1530004;


get(err153_not_enough_goods_to_buy) ->
1530005;


get(err153_money_type_wrong) ->
1530006;


get(err153_send_error) ->
1530007;


get(err153_not_enough_world_lv) ->
1530008;


get(err153_not_enough_server_time) ->
1530009;


get(err153_not_enough_lv) ->
1530010;


get(err153_qb_not_right_money) ->
1530011;


get(err153_price_err) ->
1530012;


get(err153_missing_config) ->
1530013;


get(err153_out_config) ->
1530014;


get(err153_enough_turn_stage) ->
1530015;


get(err153_top_pk_grade) ->
1530016;


get(err153_must_buy_pre_shop) ->
1530017;


get(err153_supvip_right_not_to_buy) ->
1530018;


get(err153_kf_rank_level_err) ->
1530019;


get(err153_attr_not_enougth) ->
1530020;


get(err153_attr_constellation_not_active) ->
1530021;


get(err153_god_pool_lv) ->
1530022;


get(err153_guild_lv) ->
1530023;


get(err154_error_pricetype) ->
1540001;


get(err154_missing_config) ->
1540002;


get(err154_goods_sellout) ->
1540003;


get(err154_price_change) ->
1540004;


get(err154_error_price) ->
1540005;


get(err154_goods_closed) ->
1540006;


get(err154_player_top_price) ->
1540007;


get(err154_error_guild_id) ->
1540008;


get(err154_auction_not_start) ->
1540009;


get(err154_only_pay_by_gold) ->
1540010;


get(err154_error_args) ->
1540011;


get(err154_error_goods) ->
1540012;


get(err154_in_init) ->
1540013;


get(err154_daily_count_over) ->
1540014;


get(err154_week_count_over) ->
1540015;


get(err155_cannot_takeoff_stren) ->
1550001;


get(err155_stren_stage_limit) ->
1550002;


get(err155_stren_no_equip) ->
1550003;


get(err150_soul_count_limit) ->
1550004;


get(err157_1_live_not_enough) ->
1570001;


get(err157_2_live_aready_get) ->
1570002;


get(err157_3_bag_not_enough) ->
1570003;


get(err157_4_lv_not_enough) ->
1570004;


get(err157_5_cfg_err) ->
1570005;


get(err157_6_live_not_enough) ->
1570006;


get(err157_7_max_lv) ->
1570007;


get(err157_8_live_lv_limit) ->
1570008;


get(err157_9_open_day_limit) ->
1570009;


get(err157_act_not_open) ->
1570010;


get(err157_figure_already) ->
1570011;


get(err157_open_lv) ->
1570012;


get(err157_no_res_act) ->
1570013;


get(err157_no_more_times) ->
1570014;


get(err157_same_figure_id) ->
1570015;


get(err157_not_have_get_live) ->
1570016;


get(err157_error_act) ->
1570017;


get(err157_act_open) ->
1570018;


get(err157_have_sign_up) ->
1570019;


get(err158_time_error) ->
1580001;


get(err158_condition_error) ->
1580002;


get(err158_product_error) ->
1580003;


get(err158_product_ctrl_error) ->
1580004;


get(err158_recharge_return_error) ->
1580005;


get(err158_product_type_error) ->
1580006;


get(err158_already_buy) ->
1580007;


get(err158_not_open) ->
1580008;


get(err158_not_enough_world_lv) ->
1580009;


get(err159_daily_type_err) ->
1590001;


get(err159_daily_purchased) ->
1590002;


get(err159_daily_cfg_err) ->
1590003;


get(err159_daily_not_purchase) ->
1590004;


get(err159_daily_is_get) ->
1590005;


get(err159_1_not_welfare) ->
1590006;


get(err159_2_welfare_timeout) ->
1590007;


get(err159_3_not_buy) ->
1590008;


get(err159_4_already_get) ->
1590009;


get(err159_5_bag_not_enough) ->
1590010;


get(err159_vip_not_enough) ->
1590012;


get(err159_not_the_time) ->
1590013;


get(err159_5_not_reach_openday) ->
1590014;


get(err160_3_figure_inactive) ->
1600003;


get(err160_8_mount_scene_limit) ->
1600008;


get(err160_9_config_err) ->
1600009;


get(err160_10_exp_max) ->
1600010;


get(err160_figure_has_sel) ->
1600011;


get(err160_max_goods_use_times) ->
1600012;


get(err160_max_star) ->
1600013;


get(err160_not_enough_cost) ->
1600014;


get(err160_figure_not_active) ->
1600015;


get(err160_figure_max_stage) ->
1600016;


get(err160_equip_stage_limit) ->
1600017;


get(err160_equip_stren_stage_limit) ->
1600018;


get(err160_equip_stren_no_equip) ->
1600019;


get(err160_equip_not_enough_lv) ->
1600020;


get(err160_equip_stren_max_stage) ->
1600021;


get(err160_equip_engrave_color_limit) ->
1600022;


get(err160_pet_lv_limit) ->
1600023;


get(err160_typeid_wrong) ->
1600024;


get(err160_figure_id_wrong) ->
1600025;


get(err160_figure_already_active) ->
1600026;


get(err160_temp_figure) ->
1600027;


get(err160_not_enough_turn) ->
1600028;


get(err160_equip_not) ->
1600029;


get(err160_equip_not_pos) ->
1600030;


get(err160_equip_not_right_pos) ->
1600031;


get(err160_equip_not_wear_con) ->
1600032;


get(err160_devour_max_lv) ->
1600033;


get(err160_on_battle_status_not_to_ride) ->
1600034;


get(err160_bgold_zero) ->
1600035;


get(err160_gold_zero) ->
1600036;


get(err160_stage_up_first) ->
1600037;


get(err160_up_star_first) ->
1600038;


get(err160_more_blessing_need) ->
1600039;


get(err160_figure_color_cfg_missing) ->
1600040;


get(err160_figure_color_not_active) ->
1600041;


get(err160_figure_color_level_max) ->
1600042;


get(err160_not_exp_goods) ->
1600043;


get(err160_no_goods_upgrade) ->
1600044;


get(err160_no_skill_can_upgrade) ->
1600045;


get(err160_skill_no_exist) ->
1600046;


get(err161_already_active) ->
1610001;


get(err161_figure_unactive) ->
1610002;


get(err161_not_enough_cost) ->
1610003;


get(err161_max_goods_use_times) ->
1610004;


get(err161_max_lv) ->
1610005;


get(err161_max_star) ->
1610006;


get(err161_not_turn) ->
1610007;


get(err161_figure_not_active) ->
1610008;


get(err162_figure_unactive) ->
1620001;


get(err162_up_ride) ->
1620002;


get(err162_not_up_ride) ->
1620003;


get(err162_already_active) ->
1620004;


get(err163_already_active) ->
1630001;


get(err163_cfg_err) ->
1630002;


get(err163_exp_not_enough) ->
1630003;


get(err163_max_lv) ->
1630004;


get(err163_not_active) ->
1630005;


get(err163_career_not_match) ->
1630006;


get(err164_cant_active_repeat) ->
1640001;


get(err164_consume_not_enough) ->
1640002;


get(err164_pre_not_active) ->
1640003;


get(err164_not_trigger_task) ->
1640004;


get(err165_figure_not_active) ->
1650000;


get(err165_max_goods_use_times) ->
1650001;


get(err165_max_star) ->
1650002;


get(err165_figure_has_sel) ->
1650003;


get(err165_sel_null_goods) ->
1650004;


get(err165_max_lv) ->
1650005;


get(err165_not_enough_cost) ->
1650006;


get(err165_not_cost_res) ->
1650007;


get(err165_figure_max_stage) ->
1650008;


get(err165_pet_aircraft_not_active) ->
1650009;


get(err165_pet_aircraft_play) ->
1650010;


get(err165_pet_aircraft_not_pass) ->
1650011;


get(err165_pet_wing_not_active) ->
1650012;


get(err165_pet_wing_play) ->
1650013;


get(err165_pet_wing_not_pass) ->
1650014;


get(err165_pet_equip_not) ->
1650015;


get(err165_pet_equip_not_pos) ->
1650016;


get(err165_pet_equip_not_right_pos) ->
1650017;


get(err165_pet_equip_not_already_wear) ->
1650018;


get(err165_pet_equip_not_right_cost) ->
1650019;


get(err165_pet_equip_lv_max) ->
1650020;


get(err165_pet_equip_cost_not) ->
1650021;


get(err165_pet_equip_bag_full) ->
1650022;


get(err165_pet_equip_stage_max) ->
1650023;


get(err165_pet_equip_star_max) ->
1650024;


get(err166_juewei_max) ->
1660001;


get(err166_juewei_power_max) ->
1660002;


get(err167_not_rune) ->
1670002;


get(err167_have_wear) ->
1670003;


get(err167_cant_wear) ->
1670004;


get(err167_not_pos) ->
1670005;


get(err167_pos_not_active) ->
1670006;


get(err167_subtype_have_wear) ->
1670007;


get(err167_level_max) ->
1670008;


get(err167_exp_not_enough) ->
1670009;


get(err167_exchange_not_open) ->
1670010;


get(err167_runechip_not_enough) ->
1670011;


get(err167_goods_fail) ->
1670012;


get(err167_err_rune_subtype) ->
1670013;


get(err167_attr_conflict) ->
1670014;


get(err167_not_cost_self_to_awake) ->
1670015;


get(err167_not_cost_awake_rune) ->
1670016;


get(err167_awake_cost_color_limit) ->
1670017;


get(err167_awake_color_limit) ->
1670018;


get(err167_attr_different) ->
1670019;


get(err167_no_awake_single_attr_not_to_dismantle) ->
1670020;


get(err167_multi_attr_num_not_to_decompose) ->
1670021;


get(err167_awake_not_to_decompose) ->
1670022;


get(err167_max_skill_lv) ->
1670023;


get(err167_can_not_up_rune_skill) ->
1670024;


get(err168_already_active) ->
1680001;


get(err168_figure_unactive) ->
1680002;


get(err168_not_enough_cost) ->
1680003;


get(err168_max_goods_use_times) ->
1680004;


get(err168_max_lv) ->
1680005;


get(err168_max_star) ->
1680006;


get(err168_not_turn) ->
1680007;


get(err168_figure_not_active) ->
1680008;


get(err169_already_active) ->
1690001;


get(err169_figure_unactive) ->
1690002;


get(err169_not_enough_cost) ->
1690003;


get(err169_max_goods_use_times) ->
1690004;


get(err169_max_lv) ->
1690005;


get(err169_max_star) ->
1690006;


get(err169_not_turn) ->
1690007;


get(err169_figure_not_active) ->
1690008;


get(err170_not_exist) ->
1700001;


get(err170_not_soul) ->
1700002;


get(err170_have_wear) ->
1700003;


get(err170_cant_wear) ->
1700004;


get(err170_not_pos) ->
1700005;


get(err170_pos_not_active) ->
1700006;


get(err170_have_subtype_wear) ->
1700007;


get(err170_pos_type_wrong) ->
1700008;


get(err170_level_max) ->
1700009;


get(err170_exp_not_enough) ->
1700010;


get(err170_goods_fail) ->
1700011;


get(err170_multi_attr_num_not_to_decompose) ->
1700012;


get(err170_awake_not_to_decompose) ->
1700013;


get(err170_no_awake_single_attr_not_to_dismantle) ->
1700014;


get(err170_not_cost_awake_soul) ->
1700015;


get(err170_not_cost_self_to_awake) ->
1700016;


get(err171_not_active) ->
1710001;


get(err171_max_lv) ->
1710002;


get(err171_not_enough_points) ->
1710003;


get(err171_max_enchant) ->
1710004;


get(err171_pre_lv) ->
1710005;


get(err171_already_active) ->
1710006;


get(err172_ring_not_polish) ->
1720001;


get(err172_marriage_max) ->
1720002;


get(err172_marriage_not_pray) ->
1720003;


get(err172_personals_send_cd) ->
1720004;


get(err172_couple_self_not_single) ->
1720005;


get(err172_couple_other_not_single) ->
1720006;


get(err172_couple_intimacy_not_enough) ->
1720007;


get(err172_couple_not_same_sex) ->
1720008;


get(err172_couple_not_biaobai_twice) ->
1720009;


get(err172_fouple_have_not_biaobai) ->
1720010;


get(err172_couple_not_self) ->
1720011;


get(err172_couple_single) ->
1720012;


get(err172_couple_not_lover) ->
1720013;


get(err172_couple_have_marry) ->
1720014;


get(err172_couple_not_propose_twice) ->
1720015;


get(err172_marriage_life_not_marry) ->
1720016;


get(err172_love_num_not_enough) ->
1720017;


get(err172_personals_not_player) ->
1720018;


get(err172_personals_cant_follow) ->
1720019;


get(err172_personals_not_following) ->
1720020;


get(err172_couple_other_biaobai) ->
1720021;


get(err172_couple_other_propose) ->
1720022;


get(err172_wedding_have_order) ->
1720023;


get(err172_wedding_over_day) ->
1720024;


get(err172_wedding_not_time) ->
1720025;


get(err172_wedding_time_have_order) ->
1720026;


get(err172_wedding_start) ->
1720027;


get(err172_wedding_not_order) ->
1720028;


get(err172_wedding_have_invite) ->
1720029;


get(err172_wedding_guest_num_max) ->
1720030;


get(err172_wedding_guest_have_answer) ->
1720031;


get(err172_wedding_order_time_pass) ->
1720032;


get(err172_wedding_invite_success) ->
1720033;


get(err172_wedding_order_success) ->
1720034;


get(err172_wedding_buy_max_num_max) ->
1720035;


get(err172_wedding_buy_max_num_success) ->
1720036;


get(err172_wedding_not_start) ->
1720037;


get(err172_wedding_is_guest) ->
1720038;


get(err172_wedding_already_ask) ->
1720039;


get(err172_wedding_not_ask_invite) ->
1720040;


get(err172_wedding_not_guest) ->
1720041;


get(err172_wedding_not_scene) ->
1720042;


get(err172_wedding_not_owner) ->
1720043;


get(err172_wedding_not_invite_self) ->
1720044;


get(err172_wedding_not_have_solve) ->
1720045;


get(err172_wedding_tm_solve_success) ->
1720046;


get(err172_wedding_mon_not_exist) ->
1720047;


get(err172_wedding_not_scene_mon) ->
1720048;


get(err172_wedding_not_anime) ->
1720049;


get(err172_baby_have_active) ->
1720050;


get(err172_baby_not_image) ->
1720051;


get(err172_baby_not_active) ->
1720052;


get(err172_baby_image_have_active) ->
1720053;


get(err172_baby_image_not_active) ->
1720054;


get(err172_baby_have_not_resource) ->
1720055;


get(err172_baby_already_resource) ->
1720056;


get(err172_baby_not_resource) ->
1720057;


get(err172_wedding_can_not_open_order) ->
1720058;


get(err172_wedding_can_not_order_same) ->
1720059;


get(err172_wedding_already_eat) ->
1720060;


get(err172_wedding_ask_invite_agree) ->
1720061;


get(err172_df_cant_get) ->
1720062;


get(err172_df_get_success) ->
1720063;


get(err_df_have_get) ->
1720064;


get(err172_df_max) ->
1720065;


get(err172_personals_is_fans) ->
1720066;


get(err172_personals_cant_follow_self) ->
1720067;


get(err172_marriage_partner_lv_limit) ->
1720068;


get(err172_wedding_not_invite) ->
1720069;


get(err172_marriage_ask_lv_limit) ->
1720070;


get(err172_wedding_fires_success) ->
1720071;


get(err172_wedding_candies_success) ->
1720072;


get(err172_wedding_tm_limit) ->
1720073;


get(err172_wedding_nc_limit) ->
1720074;


get(err172_wedding_sc_limit) ->
1720075;


get(err172_please_order_wedding) ->
1720076;


get(err172_cant_wedding_twice) ->
1720077;


get(err172_divorce_lover_not_online) ->
1720078;


get(err172_love_dsgt_active) ->
1720079;


get(err172_love_gift_type_err) ->
1720080;


get(err172_love_gift_get) ->
1720081;


get(err172_love_gift_not_buy) ->
1720082;


get(err172_love_gift_expire) ->
1720083;


get(err172_sex_limit) ->
1720084;


get(err172_ask_for_divorce) ->
1720085;


get(err172_other_money_not_enough) ->
1720086;


get(err172_in_marriaage_dun_match) ->
1720087;


get(err172_dun_intimacy_not_enough) ->
1720088;


get(err172_wedding_order_times_err) ->
1720089;


get(err172_wedding_not_invite_lover) ->
1720090;


get(err172_ring_unlock) ->
1720091;


get(err172_wedding_feast_success) ->
1720092;


get(err172_in_wedding_scene) ->
1720093;


get(err172_please_order_next_time) ->
1720094;


get(err172_only_one_times_in_day) ->
1720095;


get(err172_in_team_dungeon) ->
1720096;


get(err172_other_in_team_dungeon) ->
1720097;


get(err172_gift_no_in_get_time) ->
1720098;


get(err172_gift_no_expire) ->
1720099;


get(err173_equip_condition_error) ->
1730001;


get(err173_fight_location_limit) ->
1730002;


get(err173_strength_double_error) ->
1730003;


get(err173_strength_level_limit) ->
1730004;


get(err173_equip_error) ->
1730005;


get(err173_eudemons_bag_full) ->
1730006;


get(err173_strength_cfg_error) ->
1730007;


get(err173_fight_limit) ->
1730008;


get(err173_system_business) ->
1730009;


get(err173_wrong_num) ->
1730010;


get(err173_wrong_material) ->
1730011;


get(err173_error_type) ->
1730012;


get(err173_lv_limit) ->
1730013;


get(err174_act_not_open) ->
1740001;


get(err174_no_enough_lv_join) ->
1740002;


get(err174_on_noon_quiz) ->
1740003;


get(err174_not_in_act) ->
1740004;


get(err174_not_scene) ->
1740005;


get(err174_not_answering) ->
1740006;


get(err175_login_reward_closed) ->
1750001;


get(err175_today_already_get) ->
1750002;


get(err175_the_day_already_get) ->
1750003;


get(err175_can_not_get) ->
1750004;


get(err176_not_sell) ->
1760001;


get(err176_out_time) ->
1760002;


get(err176_out_num) ->
1760003;


get(err176_out_num_all) ->
1760004;


get(err177_house_not_furniture) ->
1770001;


get(err177_furniture_not_enough) ->
1770002;


get(err177_house_furniture_max) ->
1770003;


get(err177_house_none) ->
1770004;


get(err177_house_lock) ->
1770005;


get(err177_house_not_own) ->
1770006;


get(err177_house_not_in) ->
1770007;


get(err177_house_have) ->
1770008;


get(err177_house_be_asked_aa) ->
1770009;


get(err177_house_asking_aa) ->
1770010;


get(err177_house_house_exist) ->
1770011;


get(err177_house_not_ask) ->
1770012;


get(err177_house_have_order) ->
1770013;


get(err177_house_refuse) ->
1770014;


get(err177_house_lv_max) ->
1770015;


get(err177_house_point_not_enough) ->
1770016;


get(err177_house_upgrade_aa) ->
1770017;


get(err177_house_furniture_put_max) ->
1770018;


get(err177_house_not_inside) ->
1770019;


get(err177_house_not_in_scene) ->
1770020;


get(err177_house_choose) ->
1770021;


get(err177_house_not_choose) ->
1770022;


get(err177_house_bag_full) ->
1770023;


get(err177_house_text_too_long) ->
1770024;


get(err177_house_choose_refuse) ->
1770025;


get(err177_house_floor_not_back) ->
1770026;


get(err177_house_choose_waiting) ->
1770027;


get(err177_house_furniture_location_wrong) ->
1770028;


get(err177_house_answer) ->
1770029;


get(err177_house_not_exist) ->
1770030;


get(err177_house_wish_word_too_long) ->
1770031;


get(err177_house_gift_over_limit) ->
1770032;


get(err177_house_garden_not_in_garden) ->
1770033;


get(err177_house_garden_not_garden_own) ->
1770034;


get(err177_house_garden_lv_limit) ->
1770035;


get(err177_house_garden_not_product) ->
1770036;


get(err177_house_garden_not_use_pos) ->
1770037;


get(err177_house_garden_over_product_num) ->
1770038;


get(err177_house_garden_product_not_time_out) ->
1770039;


get(err177_house_garden_done) ->
1770040;


get(err177_house_cell_max) ->
1770041;


get(err177_house_garden_wish_free_max) ->
1770042;


get(err177_house_garden_has_got) ->
1770043;


get(err177_house_garden_goods_success) ->
1770044;


get(err177_house_garden_lv_success) ->
1770045;


get(err177_house_garden_same_loc) ->
1770046;


get(err178_max_enchant_count) ->
1780001;


get(err178_max_sp_wash_count) ->
1780002;


get(err178_max_page_skill_active_star) ->
1780003;


get(err178_must_page_all_glyph_active) ->
1780004;


get(err178_max_lv) ->
1780005;


get(err178_must_active_star) ->
1780006;


get(err178_max_star) ->
1780007;


get(err179_role_lv_limit) ->
1790001;


get(err179_not_in_draw_time) ->
1790002;


get(err179_has_recieve) ->
1790003;


get(err179_not_achieve) ->
1790004;


get(err179_miss_config) ->
1790005;


get(err179_pool_is_null) ->
1790006;


get(has_same_type) ->
1790007;


get(err179_type_length_error) ->
1790008;


get(err179_error_goods_in_pool) ->
1790009;


get(err180_equip_condition_err) ->
1800001;


get(err180_anima_id_err) ->
1800002;


get(err180_equip_pos_err) ->
1800003;


get(err180_not_equip) ->
1800004;


get(err181_not_goods_exist) ->
1810001;


get(err181_not_dragon_equip) ->
1810002;


get(err181_max_dragon_lv) ->
1810003;


get(err181_not_right_equip_career) ->
1810004;


get(err181_not_pos_permiss) ->
1810005;


get(err181_not_enough_dragon_lv) ->
1810006;


get(err181_not_unique_kind) ->
1810007;


get(err181_not_on_equip) ->
1810008;


get(err181_must_on_bag_to_decompose) ->
1810009;


get(err181_not_decompose_cfg) ->
1810010;


get(err181_not_beckon_cfg) ->
1810011;


get(err181_crucible_not_open) ->
1810012;


get(err181_not_count_reward_cfg) ->
1810013;


get(err181_can_have_get) ->
1810014;


get(err181_can_not_get) ->
1810015;


get(err181_pos_not_active) ->
1810016;


get(err181_not_dragon_pos_cfg) ->
1810017;


get(err181_max_dragon_pos_lv) ->
1810018;


get(err181_not_dragon_pos_lv_cfg) ->
1810019;


get(err181_min_dragon_pos_lv) ->
1810020;


get(err181_stage_reward_unrecieve) ->
1810021;


get(err181_bag_not_enough) ->
1810022;


get(err182_max_stage) ->
1820001;


get(err182_figure_in_use) ->
1820002;


get(err182_not_active) ->
1820003;


get(err182_figure_not_use) ->
1820004;


get(err182_had_praise_back) ->
1820005;


get(err182_stage_not_enough) ->
1820006;


get(err182_equip_pos_err) ->
1820007;


get(err182_not_equip) ->
1820008;


get(err182_skill_had_active) ->
1820009;


get(err182_raise_lv_not_enough) ->
1820010;


get(err182_baby_is_active) ->
1820011;


get(err182_task_not_finish) ->
1820012;


get(err182_task_reward_get) ->
1820013;


get(err182_player_not_active_baby) ->
1820014;


get(err183_demons_not_active) ->
1830001;


get(err183_demons_is_follow) ->
1830002;


get(err183_cannot_receive) ->
1830003;


get(err183_is_receive) ->
1830004;


get(err183_demons_skill_not_active) ->
1830005;


get(err183_demons_slot_not_active) ->
1830006;


get(err183_demons_goods_not_skill) ->
1830007;


get(err183_same_slot_skill_sort) ->
1830008;


get(err183_demons_shop_no_goods) ->
1830009;


get(err183_demons_error_slot_skill) ->
1830010;


get(err183_demons_slot_skill_have) ->
1830011;


get(err183_demons_slot_skill_not_have) ->
1830012;


get(err183_demons_skill_active) ->
1830013;


get(err183_demons_skill_not_complete) ->
1830014;


get(err185_enter_cluster) ->
1850001;


get(err185_guild_position_limit) ->
1850002;


get(err185_has_create_mon) ->
1850003;


get(err185_not_in_scene) ->
1850004;


get(err185_time_out) ->
1850005;


get(err185_cant_quit_guild_when_act_open) ->
1850006;


get(err185_disband_when_act_open) ->
1850007;


get(err185_create_mon_first) ->
1850008;


get(err185_cant_reborn_in_scene) ->
1850009;


get(err185_open_day_limit) ->
1850010;


get(err186_join_a_camp) ->
1860001;


get(err186_not_guild_chief) ->
1860002;


get(err186_error_data) ->
1860003;


get(err186_has_join) ->
1860004;


get(err186_has_apply) ->
1860005;


get(err186_be_limit) ->
1860006;


get(err186_not_apply) ->
1860007;


get(err186_job_num_limit) ->
1860008;


get(err186_job_limit) ->
1860009;


get(err186_already_same_type) ->
1860010;


get(err186_not_in_scene) ->
1860011;


get(err186_has_divide) ->
1860012;


get(err186_not_camp_job) ->
1860013;


get(err186_has_join_a_camp) ->
1860014;


get(err186_cant_exit_now) ->
1860015;


get(err186_act_will_start_today) ->
1860016;


get(err186_cant_recieve_before_act_start) ->
1860017;


get(err186_has_recieve) ->
1860018;


get(err186_wait_for_master_come) ->
1860019;


get(err186_cant_quit_guild_when_act_open) ->
1860020;


get(err186_cant_appoint_chief_when_act_open) ->
1860021;


get(err186_cant_disband_when_act_open) ->
1860022;


get(err186_enter_cluster) ->
1860023;


get(err186_not_in_act_time) ->
1860024;


get(err186_cant_enter) ->
1860025;


get(err186_cant_enter_act) ->
1860026;


get(err186_change_ship_time_limit) ->
1860027;


get(err186_act_is_running) ->
1860028;


get(err186_act_scene_cant_enter) ->
1860029;


get(err186_no_privilege) ->
1860030;


get(err186_had_option) ->
1860031;


get(err186_no_times) ->
1860032;


get(err187_not_have_sea) ->
1870001;


get(err187_error_brick_color) ->
1870002;


get(err187_not_carry_brick) ->
1870003;


get(err187_carrying) ->
1870004;


get(err187_not_in_scene) ->
1870005;


get(err187_finish_fail) ->
1870006;


get(err187_not_enter_sea) ->
1870007;


get(err187_same_sea) ->
1870008;


get(err187_in_scene) ->
1870009;


get(err187_not_have_sea_king) ->
1870010;


get(err187_not_finish_task) ->
1870011;


get(err187_yet_get_reward) ->
1870012;


get(err187_in_sea) ->
1870013;


get(err187_carrying2) ->
1870014;


get(err187_sea_retret) ->
1870015;


get(err187_cant_quit_guild_when_in_sea_daily) ->
1870016;


get(err187_err_length) ->
1870017;


get(err187_max_carry_count) ->
1870018;


get(err189_do_not_have_check) ->
1890001;


get(err189_get_before_reward_first) ->
1890002;


get(err189_on_sea_treasure_scene) ->
1890003;


get(err189_has_be_robered) ->
1890004;


get(err189_cant_rob_self) ->
1890005;


get(err189_end_time_limit) ->
1890006;


get(err189_cfg_delete) ->
1890007;


get(err189_shipping_type_wrong) ->
1890008;


get(err189_be_rob_back) ->
1890009;


get(err189_cant_rback_self) ->
1890010;


get(err189_cant_rback_not_be_robed) ->
1890011;


get(err189_day_times_max) ->
1890012;


get(err189_has_recieve) ->
1890013;


get(err189_be_robbing) ->
1890014;


get(err189_already_in_scene) ->
1890015;


get(err189_rback_get_reward) ->
1890016;


get(err189_log_is_not_exist) ->
1890017;


get(err189_shipping_type_max) ->
1890018;


get(err189_ship_end) ->
1890019;


get(err189_not_in_sea_treasure_scene) ->
1890020;


get(err189_server_has_down) ->
1890021;


get(err189_cant_rback_simo) ->
1890022;


get(err190_no_mail) ->
1900001;


get(err190_read_mail_content_fail) ->
1900002;


get(err190_no_mail_attachment) ->
1900003;


get(err190_no_mail_to_delete) ->
1900004;


get(err190_have_attachment_not_to_delete) ->
1900005;


get(err190_bag_full) ->
1900006;


get(err190_mail_timeout_to_delete) ->
1900007;


get(err190_mail_timeout_to_extract_attachment) ->
1900008;


get(err190_mail_title_len) ->
1900009;


get(err190_mail_title_sensitive) ->
1900010;


get(err190_mail_content_len) ->
1900011;


get(err190_mail_content_sensitive) ->
1900012;


get(err190_send_guild_mail_count_not_enough) ->
1900013;


get(err190_must_on_guild_to_send_guild_mail) ->
1900014;


get(err190_not_permisssion_to_send_guild_mail) ->
1900015;


get(err190_on_feedback_cd) ->
1900016;


get(err190_feedback_not_valid) ->
1900017;


get(err190_have_receive_attachment) ->
1900018;


get(err191_gift_not_active) ->
1910001;


get(err191_gift_is_buy) ->
1910002;


get(err191_gift_is_expired) ->
1910003;


get(err192_no_qualification) ->
1920001;


get(err192_logout) ->
1920002;


get(err192_enter_fail) ->
1920003;


get(err192_onhook_coin_not_enough) ->
1920004;


get(err194_fiesta_activated) ->
1940001;


get(err200_robbed_not_mon_bl) ->
2000001;


get(err200_not_rob_my_mon_bl) ->
2000002;


get(err200_this_mon_not_bl_to_rob) ->
2000003;


get(err200_rob_mon_bl_fail) ->
2000004;


get(err200_rob_mon_bl_must_same_scene) ->
2000005;


get(err200_not_rob_this_mon_bl) ->
2000006;


get(err200_not_mon) ->
2000007;


get(err200_not_user) ->
2000008;


get(err200_other_rob_my_mon_bl_fail) ->
2000009;


get(err202_no_protect_time) ->
2020001;


get(err202_max_use_count) ->
2020002;


get(err202_have_left_safe_time) ->
2020003;


get(err202_this_scene_not_to_protect) ->
2020004;


get(err202_had_close_protect) ->
2020005;


get(err202_this_scene_type_not_to_close) ->
2020006;


get(err202_this_scene_not_to_close) ->
2020007;


get(err203_not_teasure_map) ->
2030001;


get(err203_not_have_coordinate) ->
2030002;


get(er203_map_type_error) ->
2030003;


get(err203_distance_error) ->
2030004;


get(er203_scene_error) ->
2030005;


get(err204_act_close) ->
2040001;


get(err204_err_castle_id) ->
2040002;


get(err204_illegal_castle_id) ->
2040003;


get(err204_error_stage) ->
2040004;


get(err204_not_enough_scramble_value) ->
2040005;


get(err204_yet_get_reward) ->
2040006;


get(err204_error_goal_id) ->
2040007;


get(err204_goal_not_finish) ->
2040008;


get(err206_not_enough_lv) ->
2060001;


get(err206_scene_not_exist) ->
2060002;


get(err206_not_ng_scene) ->
2060003;


get(err206_ng_boss_bc_reward_msg) ->
2060004;


get(err210_skill_max_lv) ->
2100001;


get(err210_skill_error) ->
2100002;


get(err210_lv_not_enough) ->
2100003;


get(err210_coin_not_enough) ->
2100004;


get(err210_no_pre_skill) ->
2100005;


get(err210_no_pre_skill_lv) ->
2100006;


get(err210_point_not_enough) ->
2100007;


get(err210_no_pre_skill_point) ->
2100008;


get(err210_no_learn_talent_skill) ->
2100009;


get(err210_not_mycarrer_talent_skill) ->
2100010;


get(err210_no_satisfy_turn) ->
2100011;


get(err210_goods_not_enough) ->
2100012;


get(err210_skill_erro) ->
2100013;


get(err210_not_enough_turn_to_stren_skill) ->
2100014;


get(err210_not_enough_lv_to_stren_skill) ->
2100015;


get(err210_max_skill_stren) ->
2100016;


get(err210_not_this_skill_to_stren) ->
2100017;


get(err210_no_finish_task_id) ->
2100018;


get(err210_skill_stren_can_not_gt_lv) ->
2100019;


get(err210_no_satisfy_career) ->
2100020;


get(err211_had_select_core) ->
2110001;


get(err211_core_type_not_same) ->
2110002;


get(err211_must_finish_pre_skill) ->
2110003;


get(err211_arcana_total_lv_not_enough) ->
2110004;


get(err211_this_arcana_lv_not_enough) ->
2110005;


get(err211_core_type_error) ->
2110006;


get(err211_open_day_not_enough) ->
2110007;


get(err211_lv_not_enough) ->
2110008;


get(err211_without_reset) ->
2110009;


get(err215_not_in_soul_scene) ->
2150001;


get(err215_yet_create_boss) ->
2150002;


get(err215_not_enough_power) ->
2150003;


get(err215_skill_not_exist) ->
2150004;


get(err215_err_sweep_boss_num) ->
2150005;


get(err215_sweep_never_finish) ->
2150006;


get(err215_not_enough_sweep_goods) ->
2150007;


get(err215_not_finish_dun) ->
2150008;


get(err215_yet_got_reward) ->
2150009;


get(err215_not_finish_dun2) ->
2150010;


get(err216_not_enough_lv) ->
2160001;


get(err216_yet_open) ->
2160002;


get(err216_not_have_free_times) ->
2160003;


get(err216_free_time) ->
2160004;


get(err216_show) ->
2160005;


get(err216_have_higher) ->
2160006;


get(err217_max_day_used_times) ->
2170001;


get(err217_max_used_times) ->
2170002;


get(err218_not_enough_day) ->
2180001;


get(err218_act_close) ->
2180002;


get(err218_in_act) ->
2180003;


get(err218_not_enough_point) ->
2180004;


get(err218_yet_get_point_reward) ->
2180005;


get(err650_not_in_act) ->
2180006;


get(err222_goods_not_enough) ->
2220001;


get(err222_combat_not_enough) ->
2220002;


get(err222_title_not_equel) ->
2220003;


get(err222_title_config_error) ->
2220004;


get(err222_deduction_goods_error) ->
2220005;


get(err222_6_not_enough_server_day) ->
2220006;


get(err222_title_lv_max) ->
2220007;


get(err223_num_not_enough) ->
2230001;


get(err223_lv_not_enough) ->
2230002;


get(err223_vip_not_enough) ->
2230003;


get(err223_shop_not_provide) ->
2230004;


get(err223_reset_time) ->
2230005;


get(err223_dissatisfy_send_gift_condition) ->
2230006;


get(err223_receiver_lv_not_enough) ->
2230007;


get(err224_not_same_zone) ->
2240001;


get(err224_others_stop_server) ->
2240002;


get(err255_err_rank_type) ->
2250001;


get(err225_not_on_rank) ->
2250002;


get(err225_rank_not_end) ->
2250003;


get(err255_err_reward_id) ->
2250004;


get(err225_the_rank_not_start) ->
2250005;


get(err232_no_cfg) ->
2320001;


get(err232_strength_max) ->
2320002;


get(err232_strength_master_no) ->
2320003;


get(err232_evolution_max) ->
2320004;


get(err232_evolution_color) ->
2320005;


get(err232_no_dress) ->
2320006;


get(err232_enchantment_max) ->
2320007;


get(err232_had_spirit) ->
2320008;


get(err232_evolution_euqip_point) ->
2320009;


get(err232_not_active) ->
2320010;


get(err232_can_not_equip) ->
2320011;


get(err232_equip_condition_error) ->
2320012;


get(err232_max_decompose_level) ->
2320013;


get(err232_has_stren_up) ->
2320014;


get(err232_star_not_enougth) ->
2320015;


get(err232_wrong_data) ->
2320016;


get(err232_wrong_material) ->
2320017;


get(err232_has_active) ->
2320018;


get(err232_active_before_level) ->
2320019;


get(err232_enchantment_master_no) ->
2320020;


get(err232_wrong_num) ->
2320021;


get(err232_has_star_attr) ->
2320022;


get(err232_material_not_enougth) ->
2320023;


get(err232_star_not_enougth_to_translate) ->
2320024;


get(err232_color_not_enougth_to_translate) ->
2320025;


get(err233_had_active) ->
2330001;


get(err233_no_cfg) ->
2330002;


get(err233_lv_limit) ->
2330003;


get(err233_no_active) ->
2330004;


get(err233_pos) ->
2330005;


get(err233_max_stage) ->
2330006;


get(err233_max_lv) ->
2330007;


get(err233_no_condition) ->
2330008;


get(err233_had_get) ->
2330009;


get(err233_no_reward) ->
2330010;


get(err_233_had_origin) ->
2330011;


get(err233_pos_equip_origin) ->
2330012;


get(err_233_max_color) ->
2330013;


get(err233_bag_not_enough) ->
2330014;


get(err240_in_team) ->
2400001;


get(err240_changing_scene) ->
2400002;


get(err240_no_team) ->
2400003;


get(err240_kick_himself) ->
2400004;


get(err240_max_member) ->
2400005;


get(err240_not_leader) ->
2400006;


get(err240_not_kick_leader) ->
2400007;


get(err240_leader_reject) ->
2400008;


get(err240_other_offline) ->
2400009;


get(err240_other_in_team) ->
2400010;


get(err240_team_disappear) ->
2400011;


get(err240_offline) ->
2400012;


get(err240_arbitrate_timeout) ->
2400013;


get(err240_arbitrate_refuse) ->
2400014;


get(err240_not_current_aribirate_req) ->
2400015;


get(err240_not_on_arbitrate_req_to_vote) ->
2400017;


get(err240_not_leader_to_arbitrate_req) ->
2400018;


get(err240_not_arbitrate_req_in_dungeon) ->
2400019;


get(err240_not_again_arbitrate_req) ->
2400020;


get(err240_not_team_dungeon) ->
2400021;


get(err240_join_team) ->
2400022;


get(err240_new_member) ->
2400023;


get(err240_self_out_team) ->
2400024;


get(err240_out_team) ->
2400025;


get(err240_self_shot_of_team) ->
2400026;


get(err240_shot_of_team) ->
2400027;


get(err240_no_member_follow) ->
2400028;


get(err240_cancel_follow_success) ->
2400029;


get(err240_change_state_to_interrput_arbitrate) ->
2400030;


get(err240_on_dungeon_not_to_do) ->
2400031;


get(err240_not_on_team) ->
2400032;


get(err240_this_team_on_dungeon) ->
2400033;


get(err240_34_no_invite_role) ->
2400034;


get(err240_agree_to_enter_safety_scene) ->
2400035;


get(err240_not_enough_lv_to_create_team) ->
2400036;


get(err240_not_enough_lv_to_join_team) ->
2400037;


get(err240_not_enough_lv_to_enter_target) ->
2400038;


get(err240_not_enough_lv_to_enter_target_with_name) ->
2400039;


get(err240_not_enough_lv_to_create_target) ->
2400040;


get(err240_not_on_safe_scene_to_outdoor_by_other) ->
2400047;


get(err240_choose_lv_error) ->
2400048;


get(err240_auto_pair_limit) ->
2400049;


get(err240_change_when_matching) ->
2400050;


get(err240_all_for_help_other) ->
2400051;


get(err240_teammates_offline) ->
2400052;


get(err240_cost_error) ->
2400053;


get(err240_help_type_setup_limit) ->
2400054;


get(err240_too_many_members) ->
2400055;


get(err240_team_create_unfinished) ->
2400056;


get(err240_cls_type_error) ->
2400057;


get(err240_in_arbitrate) ->
2400058;


get(err240_me_to_other) ->
2400059;


get(err240_evil_smashing_matching) ->
2400060;


get(err240_local_team_with_other_serv) ->
2400061;


get(err240_this_team_matching) ->
2400062;


get(err240_arbitrate_vote_repeat) ->
2400063;


get(err240_invite_diff_target_error) ->
2400064;


get(err240_no_teams_for_match) ->
2400065;


get(err240_choose_target_first) ->
2400066;


get(err610_dungeon_leader_help_type_limit) ->
2400067;


get(err240_team_target_changed) ->
2400068;


get(err240_team_starting) ->
2400069;


get(err240_invite_res_has_team) ->
2400070;


get(err240_invite_res_check_fail) ->
2400071;


get(err240_invite_res_ok) ->
2400072;


get(err240_not_join_type) ->
2400073;


get(err240_ugre_open_act) ->
2400074;


get(err240_teammates_offline_to_cancel_match) ->
2400075;


get(err240_my_cost_error_exp) ->
2400076;


get(err240_teammates_offline_to_cancel_arbitrate) ->
2400077;


get(err240_not_enough_join_value_to_enter_target_with_name) ->
2400078;


get(err240_no_qualification) ->
2400079;


get(err240_invite_res_in_assist) ->
2400080;


get(err204_in_guild_assist) ->
2400081;


get(err279_act_not_open) ->
2790001;


get(err279_act_end) ->
2790002;


get(err279_act_enter_limit) ->
2790003;


get(err279_act_scene_user_limit) ->
2790004;


get(err279_get_normal_scence_bl) ->
2790005;


get(err279_lv_limit) ->
2790006;


get(err279_openday_limit) ->
2790007;


get(err280_over_max_buy_num) ->
2800001;


get(err280_inspire_max) ->
2800002;


get(err280_jjc_num) ->
2800003;


get(err280_none_reward) ->
2800004;


get(err280_already_receive_reward) ->
2800005;


get(err280_rival_rank_change) ->
2800006;


get(err280_self_rank_change) ->
2800007;


get(err280_jjc_num_not_enough) ->
2800008;


get(err280_lv_not_enough) ->
2800009;


get(err280_on_battle_state) ->
2800010;


get(err280_jjc_inspire_max) ->
2800011;


get(err280_rank_limit_not_to_battle) ->
2800012;


get(err280_not_battle_myslef) ->
2800013;


get(err280_can_not_direct_battle) ->
2800014;


get(err280_have_not_reward) ->
2800015;


get(err280_had_reward) ->
2800016;


get(err281_award_is_got) ->
2810001;


get(err281_daily_enter_count_error) ->
2810002;


get(err281_buy_count_limit) ->
2810003;


get(err281_match_repeat) ->
2810004;


get(err281_on_matching_state) ->
2810005;


get(err281_not_on_match_state) ->
2810006;


get(err281_on_battle_state) ->
2810007;


get(err281_grade_limit) ->
2810008;


get(err281_no_honor_reward) ->
2810009;


get(err281_enemy_is_late) ->
2810010;


get(err283_act_not_open) ->
2830001;


get(err283_act_not_open2) ->
2830002;


get(err283_act_not_open3) ->
2830003;


get(err283_act_not_open4) ->
2830004;


get(scene_error) ->
2840001;


get(can_not_enter) ->
2840002;


get(can_not_enter_scene) ->
2840003;


get(has_recieve) ->
2840004;


get(not_achieve) ->
2840005;


get(error_data) ->
2840006;


get(lv_limit_san) ->
2840007;


get(time_limit) ->
2840008;


get(has_unlocked) ->
2840009;


get(already_in_scene) ->
2840010;


get(err284_enter_cluster) ->
2840011;


get(err285_act_closed) ->
2850001;


get(err285_can_not_change_scene_in_midday_party) ->
2850002;


get(err285_low_box_collect_limit) ->
2850003;


get(err285_high_box_collect_limit) ->
2850004;


get(err286_err_pos) ->
2860001;


get(err286_err_exp_not_enough) ->
2860002;


get(err286_err_max_lv) ->
2860003;


get(err_286_max_skill_lv) ->
2860004;


get(err_286_err_gathering) ->
2860005;


get(err_286_err_skill_id) ->
2860006;


get(err286_same_figure_id) ->
2860007;


get(err286_not_have_figure) ->
2860008;


get(err300_task_trigger) ->
3000001;


get(err300_task_config_null) ->
3000002;


get(err300_lv_not_enough) ->
3000003;


get(err300_not_guild) ->
3000004;


get(err300_realm_diff) ->
3000005;


get(err300_career_diff) ->
3000006;


get(err300_prev_not_fin) ->
3000007;


get(err300_fin) ->
3000008;


get(err300_condition_err) ->
3000009;


get(err300_not_enough_cell) ->
3000010;


get(err300_turn_diff) ->
3000011;


get(err300_daily_task_finished) ->
3000012;


get(err300_guild_task_finished) ->
3000013;


get(err300_no_task_trigger) ->
3000014;


get(err300_task_no_finish) ->
3000015;


get(err300_lv_no_task) ->
3000016;


get(err300_task_cost_not_enough) ->
3000017;


get(err331_act_closed) ->
3310001;


get(err331_no_act_reward_cfg) ->
3310002;


get(err331_act_can_not_get) ->
3310003;


get(err331_already_get_reward) ->
3310004;


get(err331_fs_already_evaluate) ->
3310005;


get(err331_act_time_out) ->
3310006;


get(err331_smashed_egg_refresh_fail) ->
3310007;


get(err331_smashed_egg_times_lim) ->
3310008;


get(err331_limit_buy_daily_num_max) ->
3310009;


get(err331_egg_has_smashed) ->
3310010;


get(err331_cloud_buy_end) ->
3310011;


get(err331_cloud_buy_order_unfinished) ->
3310012;


get(err331_cloud_buy_personal_limit) ->
3310013;


get(err331_cloud_buy_not_enough) ->
3310014;


get(err331_act_boss_scene_tips) ->
3310015;


get(err331_act_boss_scene_people_lim) ->
3310016;


get(err331_act_boss_scene_no_boss) ->
3310017;


get(err331_act_mission_complete) ->
3310018;


get(err331_count_limit) ->
3310019;


get(err331_only_president_reward) ->
3310020;


get(err331_ticket_limit) ->
3310021;


get(err331_limit_buy_daily_player_max) ->
3310022;


get(err331_not_in_buy_day) ->
3310023;


get(err331_login_return_reward_has_buy) ->
3310024;


get(err331_act_data_err) ->
3310025;


get(err331_pls_wait_for_next_act) ->
3310026;


get(err331_kf_cloud_buy_product_id_err) ->
3310027;


get(err331_kf_cloud_buy_total_buy_num_lim) ->
3310028;


get(err331_kf_cloud_buy_personal_buy_num_lim) ->
3310029;


get(err331_kf_cloud_buy_drawing) ->
3310030;


get(err331_flop_reward_has_obtain) ->
3310036;


get(err331_flop_times_lim) ->
3310037;


get(err331_pls_open_first) ->
3310038;


get(err331_cloud_buy_not_ennough) ->
3310039;


get(err331_login_times_limit) ->
3310040;


get(err331_shake_not_enough) ->
3310041;


get(err331_error_data) ->
3310042;


get(err331_lv_not_enougth) ->
3310043;


get(err331_has_recieve) ->
3310044;


get(err331_reward_preparing) ->
3310046;


get(err331_error_send_data) ->
3310047;


get(err331_reset_times_not_enougth) ->
3310048;


get(err331_has_buy) ->
3310049;


get(err331_reward_cfg_is_null) ->
3310050;


get(err331_not_open_hour_list) ->
3310051;


get(err331_reset_before_choose) ->
3310052;


get(err331_max_reset_num) ->
3310053;


get(err331_pool_is_null) ->
3310054;


get(err331_pool_has_draw) ->
3310055;


get(err331_stage_not_achieve) ->
3310056;


get(err331_stage_has_recieve) ->
3310057;


get(err331_rare_normal_num_not_enougth) ->
3310058;


get(err331_rare_special_num_not_enougth) ->
3310059;


get(err331_rare_rare_num_not_enougth) ->
3310060;


get(err331_has_same_grade) ->
3310061;


get(err331_act_close) ->
3310062;


get(stage_reward_not_recieve) ->
3310063;


get(err331_rare_reward_has_draw) ->
3310064;


get(err331_rare_reward_not_draw) ->
3310065;


get(err331_act_activation_not_enougth) ->
3310066;


get(err331_can_not_recieve) ->
3310067;


get(err331_rare_draw_times_not_enougth) ->
3310068;


get(err331_not_send_time) ->
3310069;


get(err331_receive_red_envelopes) ->
3310070;


get(err331_wave_red_envelopes_num_over) ->
3310071;


get(err331_exchange_limit) ->
3310072;


get(err331_score_not_enougth) ->
3310073;


get(err331_cannot_get_reward_out_wlv) ->
3310074;


get(err331_reward_not_bl_act) ->
3310075;


get(err331_need_recharge) ->
3310076;


get(err322_today_is_hire) ->
3320001;


get(err322_no_need_hire) ->
3320002;


get(err322_figure_not_open) ->
3320003;


get(err322_already_active) ->
3320004;


get(err332_invest_buy_expire) ->
3320005;


get(err332_invest_is_buy) ->
3320006;


get(err332_invest_not_buy) ->
3320007;


get(err332_invest_login_days) ->
3320008;


get(err332_vip_discount_set) ->
3320009;


get(err332_vip_discount_not_set) ->
3320010;


get(err332_not_in_first_time) ->
3320011;


get(err332_not_in_tail_time) ->
3320012;


get(err332_not_buy_count) ->
3320013;


get(err332_no_tail_count) ->
3320014;


get(err331_not_buy) ->
3320015;


get(err332_rebate_withdrawal_ing) ->
3320016;


get(err332_rebate_no_money) ->
3320017;


get(err332_rebate_no_in_day) ->
3320018;


get(err332_rebate_dev_cant) ->
3320019;


get(err332_rebate_withdrawal_limit) ->
3320020;


get(err332_question_type_error) ->
3320021;


get(err332_question_had_finish) ->
3320022;


get(err338_act_not_open) ->
3380001;


get(err338_not_this_choice) ->
3380002;


get(err338_end_buy) ->
3380003;


get(err338_has_got) ->
3380004;


get(err339_split_max_num_err) ->
3390000;


get(err339_split_min_num_err) ->
3390001;


get(err339_not_exist) ->
3390002;


get(err339_has_expired) ->
3390003;


get(err339_not_send) ->
3390004;


get(err339_daily_times_no_enough) ->
3390005;


get(err339_not_join_guild) ->
3390006;


get(err339_not_owner) ->
3390007;


get(err339_vip_lv_not_enough) ->
3390008;


get(err339_cannot_send_again) ->
3390009;


get(err339_msg_too_long) ->
3390010;


get(err339_feast_boss_err) ->
3390011;


get(err339_vip_send_succ) ->
3390012;


get(err339_gold_to_much) ->
3390013;


get(err340_had_get) ->
3400001;


get(err340_can_not_get) ->
3400002;


get(err340_touch_invite_on_cd) ->
3400003;


get(err340_must_to_get_box_reward) ->
3400004;


get(err340_not_enough_daily_num_to_touch) ->
3400005;


get(err340_invitee_recharge_had_receive) ->
3400006;


get(err340_invitee_not_recharge) ->
3400007;


get(err342_guess_act_close) ->
3420001;


get(err342_guess_bet_times_lim) ->
3420002;


get(err342_guess_not_in_bet_time) ->
3420003;


get(err342_guess_group_is_lose) ->
3420004;


get(err342_guess_has_result) ->
3420005;


get(err342_guess_reward_has_receive) ->
3420006;


get(err342_guess_cant_receive) ->
3420007;


get(err342_guess_lv_lim) ->
3420008;


get(err342_guess_cant_receive_cuz_no_result) ->
3420009;


get(err399_note_crash_too_late) ->
3990001;


get(err400_guild_name_len) ->
4000001;


get(err400_guild_name_sensitive) ->
4000002;


get(err400_tenet_len) ->
4000003;


get(err400_tenet_sensitive) ->
4000004;


get(err400_on_guild_not_to_create) ->
4000005;


get(err400_create_guild_cfg) ->
4000006;


get(err400_not_station_scene_to_leave) ->
4000007;


get(err400_announce_sensitive) ->
4000008;


get(err400_announce_len) ->
4000009;


get(err400_not_on_guild_to_modify_announce) ->
4000010;


get(err400_auto_approve_power_error) ->
4000011;


get(err400_auto_approve_lv_error) ->
4000012;


get(err400_approve_type_error) ->
4000013;


get(err400_this_scene_not_to_enter_station) ->
4000014;


get(err400_not_on_guild_to_station) ->
4000015;


get(err400_on_guild_not_to_apply) ->
4000016;


get(err400_not_permission_to_clean_apply) ->
4000017;


get(err400_not_on_guild_to_clean_apply) ->
4000018;


get(err400_can_not_modify_other_permission) ->
4000019;


get(err400_not_on_guild_to_modify_permission) ->
4000020;


get(err400_not_right_is_allow_on_modify_permission) ->
4000021;


get(err400_not_modifiable_permission) ->
4000022;


get(err400_not_modified_permission_pos) ->
4000023;


get(err400_not_guild_apply) ->
4000024;


get(err400_not_permission_to_rename_position) ->
4000025;


get(err400_not_on_guild_to_rename_position) ->
4000026;


get(err400_not_modified_name_pos) ->
4000027;


get(err400_position_name_sensitive) ->
4000028;


get(err400_position_name_len) ->
4000029;


get(err400_this_position_can_not_kick_member) ->
4000030;


get(err400_not_permission_to_kick) ->
4000031;


get(err400_not_same_guild_to_kick) ->
4000032;


get(err400_not_on_guild_to_kicked) ->
4000033;


get(err400_not_on_guild_to_kick) ->
4000034;


get(err400_this_position_can_not_resign) ->
4000035;


get(err400_not_on_guild_to_resign_position) ->
4000036;


get(err400_not_permission_to_modify_announce) ->
4000037;


get(err400_not_on_guild_to_modify_tenet) ->
4000038;


get(err400_not_permission_to_modify_tenet) ->
4000039;


get(err400_not_permission_to_modify_approve_setting) ->
4000040;


get(err400_not_on_guild_to_modify_approve_setting) ->
4000041;


get(err400_chief_not_to_quit) ->
4000042;


get(err400_not_on_guild_to_quit) ->
4000043;


get(err400_guild_name_same_not_to_create) ->
4000044;


get(err400_this_position_full) ->
4000045;


get(err400_chief_not_exist) ->
4000046;


get(err400_not_allow_appoint) ->
4000048;


get(err400_must_have_chief) ->
4000049;


get(err400_same_target_position) ->
4000051;


get(err400_not_same_guild_to_appoint) ->
4000052;


get(err400_guild_not_exist) ->
4000053;


get(err400_not_on_guild_to_appointed) ->
4000054;


get(err400_not_on_guild_to_appoint) ->
4000056;


get(err400_not_permission_to_approve) ->
4000057;


get(err400_not_apply) ->
4000058;


get(err400_approver_not_on_guild) ->
4000059;


get(err400_can_not_join) ->
4000061;


get(err400_guild_apply_len_limit) ->
4000062;


get(err400_member_enough) ->
4000063;


get(err400_apply_realm_not_same) ->
4000064;


get(err400_this_guild_not_exist_to_apply) ->
4000065;


get(err400_is_apply_this_guild) ->
4000066;


get(err400_not_config) ->
4000083;


get(err400_not_on_guild_to_modify_approve) ->
4000094;


get(err400_not_allow_appoint_again) ->
4000095;


get(err400_appoint_position_to_leader_only) ->
4000096;


get(err400_not_allow_appoint_to_chief_again) ->
4000097;


get(err400_appoint_position_to_chief_only) ->
4000098;


get(err400_other_have_guild_not_to_join) ->
4000101;


get(err400_invitee_having_on_guild) ->
4000106;


get(err400_not_enough_lv_to_apply_join_guild) ->
4000107;


get(err400_not_enough_lv_to_create_guild) ->
4000108;


get(err400_not_find_guild) ->
4000109;


get(err400_refuse_apply) ->
4000110;


get(err400_guild_name_null) ->
4000111;


get(err400_no_permission) ->
4000112;


get(err400_guild_full_lv) ->
4000113;


get(err400_not_satisfy_upgrade_guild_condition) ->
4000114;


get(err400_has_receive_salary) ->
4000115;


get(err400_not_join_guild) ->
4000116;


get(err400_not_peimission_research) ->
4000117;


get(err400_gskill_locked) ->
4000118;


get(err400_gfunds_not_enough) ->
4000119;


get(err400_guild_lv_not_satisfy_research) ->
4000120;


get(err400_max_research_lv) ->
4000121;


get(err400_research_lv_limit) ->
4000122;


get(err400_role_lv_not_satisfy_learn) ->
4000123;


get(err400_gdonate_not_satisfy_learn) ->
4000124;


get(err400_approve_success) ->
4000125;


get(err400_apply_refuse) ->
4000126;


get(err400_dominator_guild_can_not_disband) ->
4000127;


get(err400_no_guild) ->
4000128;


get(err400_guild_name_same) ->
4000129;


get(err400_guild_name_repeat) ->
4000130;


get(err400_donate_max) ->
4000131;


get(err400_already_get_daily_gift) ->
4000132;


get(err400_not_donate_today) ->
4000133;


get(err400_activity_not_enough) ->
4000134;


get(err400_chief_not_to_disband) ->
4000135;


get(err400_apply_condition_err) ->
4000136;


get(err400_guild_lv_dun) ->
4000137;


get(err400_already_get_score_gift) ->
4000138;


get(err400_dun_role_score_not_enough) ->
4000139;


get(err400_dun_score_not_enough) ->
4000140;


get(err400_no_challenge_times) ->
4000141;


get(err400_in_guild_dun) ->
4000142;


get(err400_no_notify_times) ->
4000143;


get(err400_cant_quit_guild_when_in_guild_dun) ->
4000144;


get(err400_dont_kid_myself) ->
4000145;


get(err400_cant_quit_guild_when_in_sanctuary) ->
4000146;


get(err400_cant_disband_guild_when_in_sanctuary) ->
4000147;


get(err400_can_not_join_in_sanctuary) ->
4000148;


get(err400_onekey_apply_condition_err) ->
4000149;


get(err400_prestige_limit_today) ->
4000150;


get(err400_guild_level_not_enough) ->
4000151;


get(err400_announce_times) ->
4000152;


get(err400_announce_forbid_gm) ->
4000153;


get(err400_rename_frequent) ->
4000154;


get(err400_merge_over_capacity) ->
4000155;


get(err400_merge_requested_other) ->
4000156;


get(err400_merge_agree_other) ->
4000157;


get(err400_merge_req_not_exist) ->
4000158;


get(err400_merge_target_guild_applied) ->
4000159;


get(err401_not_in_depot) ->
4010000;


get(err401_goods_not_in_depot) ->
4010001;


get(err401_goods_can_not_add_to_depot) ->
4010002;


get(err401_depot_score_not_enough) ->
4010003;


get(err401_bag_cell_not_enough) ->
4010004;


get(err401_exchange_num_err) ->
4010005;


get(err401_no_permission_to_destory) ->
4010006;


get(err402_no_in_act_scene) ->
4020000;


get(err402_no_join_guild) ->
4020001;


get(err402_no_enough_lv_join) ->
4020002;


get(err402_act_close) ->
4020003;


get(err402_cant_quit_guild_when_act_open) ->
4020004;


get(err402_cant_appoint_chief_when_act_open) ->
4020005;


get(err402_gboss_has_open) ->
4021006;


get(err402_gboss_open_no_permission) ->
4021007;


get(err402_gboss_open_no_mat) ->
4021008;


get(err402_not_in_act_cfg_open_time) ->
4021009;


get(err402_chief_can_drum_up) ->
4021010;


get(err402_drum_up_cd) ->
4021011;


get(err402_cant_disband_when_gboss_open) ->
4021012;


get(err402_no_challenge_times) ->
4021013;


get(err402_guild_guard_end) ->
4021014;


get(err402_not_battle_stage) ->
4021015;


get(err402_gwar_no_qualification) ->
4021016;


get(err402_can_not_change_scene_in_gwar) ->
4021017;


get(err402_gwar_battle_end) ->
4021018;


get(err402_join_in_guild_not_enough_time) ->
4021019;


get(err402_can_not_join_action_this_scene) ->
4021020;


get(err402_not_dominator) ->
4021021;


get(err402_join_in_guild_not_enough_time_can_not_receive) ->
4021022;


get(err402_has_receive_salary_paul) ->
4021023;


get(err402_no_null_cell_receive_salary_paul) ->
4021024;


get(err402_not_in_guild) ->
4021025;


get(err402_unacommpolished_streak_times) ->
4021026;


get(err402_reward_has_allot) ->
4021027;


get(err402_no_permission_allot) ->
4021028;


get(err402_unacommpolished) ->
4021029;


get(err402_cant_quit_guild_when_gwar_open) ->
4021030;


get(err402_cant_appoint_chief_when_gwar_open) ->
4021031;


get(err402_cant_disband_when_gwar_open) ->
4021032;


get(err402_gwar_role_num_lim) ->
4021033;


get(err402_can_not_change_scene_in_gfeast) ->
4021034;


get(err402_no_exist_fire) ->
4021035;


get(err402_hava_fire) ->
4021036;


get(err402_error_stage) ->
4021037;


get(err402_guild_lv) ->
4021038;


get(err402_enter_guild_time) ->
4021039;


get(err402_not_enough_dragon) ->
4021040;


get(err402_had_answer) ->
4021041;


get(err402_cant_disband_when_act_open) ->
4021042;


get(err402_summon_dragon_yet) ->
4021043;


get(err402_not_have_summon_card) ->
4021044;


get(err402_summon_time_limit) ->
4021045;


get(err402_boss_not_drum_up) ->
4021046;


get(err402_please_enter_feast) ->
4021047;


get(err402_guild_boss_close) ->
4021048;


get(err402_not_drum_time) ->
4021049;


get(err402_yet_buy_food) ->
4021050;


get(buy_grade_food_limit) ->
4021051;


get(err403_join_a_guild) ->
4030001;


get(err403_has_recieved) ->
4030002;


get(err403_max_recieve_num) ->
4030003;


get(err404_no_guild) ->
4040001;


get(err404_not_same_guild) ->
4040002;


get(err404_had_assist) ->
4040003;


get(err404_please_wait_a_second) ->
4040004;


get(err404_no_assist) ->
4040005;


get(err404_cannt_cancel_in_dungeon) ->
4040006;


get(err404_no_tired) ->
4040007;


get(err404_please_create_team) ->
4040008;


get(err404_move_to_boss) ->
4040009;


get(err404_param_err) ->
4040010;


get(err404_no_dun_times) ->
4040011;


get(err404_please_leave_team) ->
4040012;


get(err404_no_launch_assist) ->
4040013;


get(err404_no_target) ->
4040014;


get(err404_cannt_assist_in_decoration_boss) ->
4040015;


get(err404_assist_fail) ->
4040016;


get(err404_please_assist_again) ->
4040017;


get(err404_enter_team_fail) ->
4040018;


get(err404_had_launch_assist) ->
4040019;


get(err404_cant_quit_guild_when_in_assist) ->
4040020;


get(err404_cannt_join_team_in_assist) ->
4040021;


get(err404_boss_cannt_assist) ->
4040022;


get(err404_cannt_assist_type) ->
4040023;


get(err404_need_outside_assist) ->
4040024;


get(err404_other_assist) ->
4040025;


get(err404_limit_times) ->
4040026;


get(err404_in_cd) ->
4040027;


get(err404_not_finish_guard) ->
4040028;


get(err404_not_satisfy) ->
4040029;


get(err405_not_awake) ->
4050001;


get(err405_max_color) ->
4050002;


get(err405_max_awake_lv) ->
4050003;


get(err405_error_god_id) ->
4050004;


get(err405_error_loc) ->
4050005;


get(err405_error_pos) ->
4050006;


get(err405_not_guilld_god_rune) ->
4050007;


get(err405_open_day_limit) ->
4050008;


get(err405_lv_limit) ->
4050009;


get(err405_can_not_awake_combo) ->
4050010;


get(err405_not_ward_rune) ->
4050011;


get(err405_error_achievement_lv) ->
4050012;


get(err405_yet_awake) ->
4050013;


get(err405_rune_lv_limit) ->
4050014;


get(err405_rune_max_lv) ->
4050015;


get(err409_not_finish) ->
4090001;


get(err409_has_received) ->
4090002;


get(err409_error_data) ->
4090003;


get(err411_current_not_exist) ->
4110001;


get(err411_not_need_change) ->
4110002;


get(err411_hide_error) ->
4110003;


get(err411_change_error) ->
4110004;


get(err411_is_expired) ->
4110005;


get(err411_already_exist) ->
4110006;


get(err411_dsgt_not_active) ->
4110007;


get(err411_dsgt_max_order) ->
4110008;


get(err411_goods_not_enough) ->
4110009;


get(err412_cfg_not_exist) ->
4120001;


get(err412_goods_not_exist) ->
4120002;


get(err412_learn_sk_err1) ->
4120003;


get(err412_learn_sk_err2) ->
4120004;


get(err412_learn_sk_err3) ->
4120005;


get(err412_replace_sk_err1) ->
4120006;


get(err412_no_sk_book) ->
4120007;


get(err412_recruit_not_free) ->
4120008;


get(err412_partner_not_exist) ->
4120009;


get(err412_wash_goods_err1) ->
4120010;


get(err412_partner_state_err) ->
4120011;


get(err412_upgrade_lv_err) ->
4120012;


get(err412_wash_replace_err) ->
4120013;


get(err412_break_err) ->
4120014;


get(err412_promote_err) ->
4120015;


get(err412_battle_err1) ->
4120016;


get(err412_battle_err2) ->
4120017;


get(err412_embattle_err1) ->
4120018;


get(err412_embattle_err2) ->
4120019;


get(err412_weapon_err1) ->
4120020;


get(err412_weapon_err2) ->
4120021;


get(err412_disband_err) ->
4120022;


get(err412_callback_err) ->
4120023;


get(err412_battle_err3) ->
4120024;


get(err412_recruit_err1) ->
4120025;


get(err412_recruit_err2) ->
4120026;


get(err412_partner_is_battle) ->
4120027;


get(err413_fashion_not_pos) ->
4130001;


get(err413_fashion_not_fashion) ->
4130002;


get(err413_fashion_not_same_color) ->
4130003;


get(err413_fashion_color_not_active) ->
4130004;


get(err413_fashion_not_color) ->
4130005;


get(err413_fashion_wear) ->
4130006;


get(err413_fashion_not_wear) ->
4130007;


get(err413_fashion_active) ->
4130008;


get(err413_fashion_max_lv) ->
4130009;


get(err413_fashion_not_enough_point) ->
4130010;


get(err413_fashion_not_resolve) ->
4130011;


get(err413_fashion_max_star) ->
4130012;


get(err413_fashion_not_max_star) ->
4130013;


get(err413_fashion_color_active) ->
4130014;


get(err413_upgrade_not_conform) ->
4130015;


get(err413_suit_not_conform) ->
4130016;


get(err413_upgrade_max) ->
4130017;


get(err414_has_receive) ->
4140001;


get(err415_no_enough_times) ->
4150001;


get(err415_not_reward_cfg) ->
4150002;


get(err416_no_null_cell) ->
4160000;


get(err416_bag_no_null_cell) ->
4160001;


get(err401_score_not_enough) ->
4160002;


get(err416_rune_bag_full) ->
4160003;


get(err416_equip_htimes_lim) ->
4160004;


get(err416_peak_htimes_lim) ->
4160005;


get(err416_extreme_htimes_lim) ->
4160006;


get(err416_rune_htimes_lim) ->
4160007;


get(err416_box_id_err) ->
4160008;


get(err416_box_already_have) ->
4160009;


get(err416_lv_not_enougth) ->
4160010;


get(err416_gold_not_enougth) ->
4160011;


get(err416_goods_not_enougth) ->
4160012;


get(err416_hunt_task_not_finish) ->
4160013;


get(err416_hunt_task_is_got) ->
4160014;


get(err416_baby_htimes_lim) ->
4160015;


get(err417_level_illegal) ->
4170001;


get(err417_not_set_match_rewards) ->
4170002;


get(err417_total_level_illegal) ->
4170003;


get(err417_total_typedays_not_match) ->
4170004;


get(err417_cannot_retro_fulture_day) ->
4170005;


get(err417_checkin_day_not_current) ->
4170006;


get(err417_checkin_today_has_checked) ->
4170007;


get(err417_daily_illeagal_day) ->
4170008;


get(err417_not_reach_open_lv) ->
4170009;


get(err417_total_rewards_empty) ->
4170010;


get(err417_checkin_gift_has_received) ->
4170011;


get(err417_no_guild) ->
4170012;


get(err417_has_received) ->
4170013;


get(err417_not_share) ->
4170014;


get(err417_has_receive_share_reward) ->
4170015;


get(err417_night_welfare_not_reward) ->
4170016;


get(err417_night_welfare_already_reward) ->
4170017;


get(err417_lv_not_enougth) ->
4170018;


get(err417_online_time_not_enougth) ->
4170019;


get(err417_checkin_kvcfg_error) ->
4170020;


get(err417_checkin_retro_limit) ->
4170021;


get(err417_no_retro_day) ->
4170022;


get(err417_retro_times_not_enougth) ->
4170023;


get(err417_limit_to_get) ->
4170024;


get(err417_not_enough_combat) ->
4170025;


get(err418_not_in_scene) ->
4180001;


get(err418_not_open) ->
4180002;


get(err418_basic_exp_not_set) ->
4180003;


get(err418_gift_props_not_exists) ->
4180004;


get(err418_getter_not_join) ->
4180005;


get(err418_gift_times_not_enougth) ->
4180006;


get(err418_send_to_self) ->
4180007;


get(err418_no_partner) ->
4180008;


get(err418_not_join_act) ->
4180009;


get(err418_opp_has_engaged) ->
4180010;


get(err418_cfg_fault) ->
4180011;


get(err418_lv_invalid) ->
4180012;


get(err418_has_in_scene) ->
4180013;


get(err418_has_on_engaged) ->
4180014;


get(err418_add_exp_cd) ->
4180015;


get(err418_invite_cd) ->
4180016;


get(err419_no_res_act) ->
4190001;


get(err419_no_more_times) ->
4190002;


get(err419_no_dun_finish) ->
4190003;


get(err420_need_buy_greater) ->
4200001;


get(err420_no_investment) ->
4200002;


get(err420_need_more_day) ->
4200003;


get(err420_reward_is_got) ->
4200004;


get(err420_need_more_logins_day) ->
4200005;


get(err420_can_only_get_it_once_a_day) ->
4200006;


get(err420_must_finish_last_reward_id) ->
4200007;


get(err420_can_not_greater) ->
4200008;


get(err421_1_have_not_goods) ->
4210001;


get(err421_2_not_xy) ->
4210002;


get(err421_3_collec_wrong) ->
4210003;


get(err421_4_team_num_err) ->
4210004;


get(err421_5_clue_not_enough) ->
4210005;


get(err421_6_not_team) ->
4210006;


get(err421_7_not_num) ->
4210007;


get(err421_8_lv_not) ->
4210008;


get(err421_9_not_scene) ->
4210009;


get(err421_10_not_same_time) ->
4210010;


get(err421_11_not_same_guild) ->
4210011;


get(err421_12_already_get) ->
4210012;


get(err421_13_not_guild) ->
4210013;


get(err421_14_not_clue) ->
4210014;


get(err421_16_max_help) ->
4210016;


get(err421_17_not_same_guild) ->
4210017;


get(err421_18_collecting) ->
4210018;


get(err421_19_not_xy_extra) ->
4210019;


get(err421_20_lv_not_extra) ->
4210020;


get(err421_21_fine_max_help) ->
4210021;


get(err421_22_not_safe_scene) ->
4210022;


get(err421_23_team_spill) ->
4210023;


get(err421_24_not_enter_again) ->
4210024;


get(err421_25_dun_num_limit) ->
4210025;


get(err421_26_dun_level) ->
4210026;


get(err421_27_tsmap_dun_end) ->
4210027;


get(err421_28_response_success) ->
4210028;


get(err422_level_invalid) ->
4220001;


get(err422_has_acti) ->
4220002;


get(err422_last_star) ->
4220003;


get(err422_cant_acti) ->
4220004;


get(err422_starvalue_not_enough) ->
4220005;


get(err422_bad_check) ->
4220006;


get(err422_cfg_not_exists) ->
4220007;


get(err423_already_active) ->
4230001;


get(err423_not_active) ->
4230002;


get(err423_max_lv) ->
4230003;


get(err423_stage_not_enough_lv) ->
4230004;


get(err423_max_stage) ->
4230005;


get(err423_not_enough_cost) ->
4230006;


get(err423_attach_max_times) ->
4230007;


get(err423_attach_need_active) ->
4230008;


get(err424_chapter_lock) ->
4240001;


get(err424_has_receive_reward) ->
4240002;


get(err424_progress_not_finish) ->
4240003;


get(err425_not_finish) ->
4250001;


get(err425_last_book_not_active) ->
4250002;


get(err425_book_lock) ->
4250003;


get(err426_rename_today) ->
4260001;


get(err426_update_rename_system) ->
4260002;


get(err427_act_not_open) ->
4270001;


get(err427_times_not_enough) ->
4270002;


get(err427_no_reset_times) ->
4270003;


get(err427_not_last_loc) ->
4270004;


get(err427_time_not_enough) ->
4270005;


get(err427_shop_has_buy) ->
4270006;


get(err427_shop_no_goods) ->
4270007;


get(err429_lock_sub_chapter) ->
4290001;


get(err429_had_complete) ->
4290002;


get(err429_had_unware) ->
4290003;


get(err429_had_ware) ->
4290004;


get(err429_no_finish) ->
4290005;


get(err429_had_got) ->
4290006;


get(err429_no_complete) ->
4290007;


get(err429_lock_temple) ->
4290008;


get(err437_has_receive_daily_reward) ->
4370001;


get(err437_no_daily_reward) ->
4370002;


get(err437_cant_donate_in_err_stage) ->
4370003;


get(err437_donate_times_lim) ->
4370004;


get(err437_no_qualifications) ->
4370005;


get(err437_cant_change_scene_in_kf_gwar) ->
4370006;


get(err437_kf_gwar_role_num_lim) ->
4370007;


get(err437_no_in_act_scene) ->
4370008;


get(err437_no_enough_score_to_exchange_ship) ->
4370009;


get(err437_guild_pos_lim_to_exchange_ship) ->
4370010;


get(err437_less_than_min_bid) ->
4370011;


get(err437_not_occupy_island_cant_set_min_bid) ->
4370012;


get(err437_cant_bid_self_island) ->
4370013;


get(err437_already_bid_island) ->
4370014;


get(err437_no_bid_this_island) ->
4370015;


get(err437_guild_pos_lim_cant_use_props) ->
4370016;


get(err437_props_can_only_use_on_land) ->
4370017;


get(err437_props_can_only_use_on_sea) ->
4370018;


get(err437_props_num_not_enough) ->
4370019;


get(err437_props_use_times_lim) ->
4370020;


get(err437_guild_pos_lim_cant_exchange_props) ->
4370021;


get(err437_date_lim_cant_exchange_props) ->
4370022;


get(err437_score_lim_cant_exchange_props) ->
4370023;


get(err437_cant_enter_scene_not_in_battle_stage) ->
4370024;


get(err437_cant_enter_scene_no_qualifications) ->
4370025;


get(err437_not_enough_gfunds_to_declare_war) ->
4370026;


get(err437_guild_lim_cant_declare_war) ->
4370027;


get(err437_declare_war_stage_err) ->
4370028;


get(err437_cant_disband_when_kfgwar_open) ->
4370029;


get(err437_cant_appoint_chief_when_kfwar_open) ->
4370030;


get(err437_cant_declare_war_cuz_has_island) ->
4370031;


get(err437_reborn_point_err) ->
4370032;


get(err437_guild_lim_cant_cancel_declare_war) ->
4370033;


get(err437_guild_lim_cant_exchange_props) ->
4370034;


get(err437_not_act_server) ->
4370035;


get(err440_active_lv) ->
4400001;


get(err440_max_lv) ->
4400002;


get(err440_not_enough_cost) ->
4400003;


get(err440_not_active) ->
4400004;


get(err440_max_stage) ->
4400005;


get(err440_not_exist_god_id) ->
4400006;


get(err440_color_limit) ->
4400007;


get(err440_equip_not_enough) ->
4400008;


get(err440_max_star) ->
4400009;


get(err440_trans_not_handle) ->
4400010;


get(err440_in_same_pos) ->
4400011;


get(err440_empty_battle_god) ->
4400012;


get(err440_cd_not_end) ->
4400013;


get(err440_cannot_switch_status) ->
4400014;


get(err440_last_seq) ->
4400015;


get(err440_has_active) ->
4400016;


get(err440_not_god_equip) ->
4400017;


get(err440_lv_not_enough) ->
4400018;


get(err440_forbid_scene_type) ->
4400019;


get(err440_err_equip_pos) ->
4400020;


get(err440_god_all_lv) ->
4400021;


get(err440_compose_location_err) ->
4400022;


get(err440_compose_target_null) ->
4400023;


get(err442_has_active) ->
4420001;


get(err442_condition_not_enough) ->
4420002;


get(err442_lv_not_enough) ->
4420003;


get(err442_cfg_fail) ->
4420004;


get(err442_not_active) ->
4420005;


get(err442_has_max_lv) ->
4420006;


get(err450_1_vip_lv_not_enough) ->
4500001;


get(err450_2_present_one_time) ->
4500002;


get(err450_3_bag_not_enough) ->
4500003;


get(err450_4_config_err) ->
4500004;


get(err450_card_not_exist) ->
4500005;


get(err450_expire_type_error) ->
4500006;


get(err450_already_enable_and_viplv_max) ->
4500007;


get(err450_has_notbuy) ->
4500008;


get(err450_goods_onlyuse_one) ->
4500009;


get(err450_vip_goods_cfg_error) ->
4500010;


get(err450_first_award_error) ->
4500011;


get(err450_buy_low_card) ->
4500012;


get(err450_vip_lv) ->
4500013;


get(err450_had_free_card) ->
4500014;


get(err450_have_not_cond) ->
4500015;


get(err451_had_get) ->
4510001;


get(err451_can_not_get) ->
4510002;


get(err451_first_buy_ex) ->
4510003;


get(err451_not_enough_vip_to_buy_ex) ->
4510004;


get(err451_not_enough_lv_to_buy_ex) ->
4510005;


get(err451_had_buy_ex) ->
4510006;


get(err451_not_enough_open_day) ->
4510007;


get(err451_had_commit) ->
4510008;


get(err451_no_finish) ->
4510009;


get(err451_this_supvip_type_not_to_commit) ->
4510010;


get(err460_no_boss_cfg) ->
4600001;


get(err460_no_boss_type) ->
4600002;


get(err460_tried_max) ->
4600003;


get(err460_count_max) ->
4600004;


get(err460_no_lv) ->
4600005;


get(err460_no_remind) ->
4600006;


get(err460_no_unremind) ->
4600007;


get(err460_no_lv_to_free) ->
4600008;


get(err460_no_vip_to_free) ->
4600009;


get(err460_no_vip) ->
4600010;


get(err460_not_enough_vit_to_enter) ->
4600011;


get(err460_not_enough_ticket_to_result) ->
4600012;


get(err460_max_lv) ->
4600013;


get(err460_lv_not_enought_enter) ->
4600014;


get(err460_no_cfg) ->
4600015;


get(err460_max_inspire) ->
4600016;


get(err460_boss_die) ->
4600017;


get(err460_not_open) ->
4600018;


get(err460_turn_not_enought_enter) ->
4600019;


get(err460_had_on_boss) ->
4600020;


get(err460_not_boss_buy) ->
4600021;


get(err460_remind_max) ->
4600022;


get(err460_not_enough_bag) ->
4600023;


get(err460_not_in_server_openday_range) ->
4600024;


get(err460_no_vip_type_to_free) ->
4600025;


get(not_blong_you) ->
4600026;


get(time_out) ->
4600027;


get(max_draw_times) ->
4600028;


get(feast_boss_box_game_over) ->
4600029;


get(err460_debuff) ->
4600030;


get(err460_domain_no_lv) ->
4600031;


get(err460_domain_no_kill_num) ->
4600032;


get(err460_domain_had_reward) ->
4600033;


get(err460_no_die_to_cost_reborn) ->
4600034;


get(err460_no_cost_reborn) ->
4600035;


get(err460_use_success) ->
4600036;


get(err470_boss_not_open) ->
4700001;


get(err470_no_zone) ->
4700002;


get(err470_is_resetting) ->
4700003;


get(err470_in_eudemons_boss) ->
4700004;


get(err470_doing_cost_reborn) ->
4700005;


get(err470_ready_reborn_not_to_cost_reborn) ->
4700006;


get(err470_this_boss_not_to_cost_reborn) ->
4700007;


get(err470_in_team) ->
4700008;


get(err471_no_guild_to_ask_help) ->
4710001;


get(err471_max_role_num) ->
4710002;


get(err471_boss_die_not_to_enter) ->
4710003;


get(err471_zone_allocate) ->
4710004;


get(err471_no_zone) ->
4710005;


get(err471_act_status_zone_allocate) ->
4710006;


get(err471_no_boss_cfg) ->
4710007;


get(err471_buy_count_not_enough) ->
4710008;


get(err471_not_decoration_boss_scene) ->
4710009;


get(err471_decoration_rating_not_enough) ->
4710010;


get(err471_lv_not_enough) ->
4710011;


get(err471_enter_boss_assist_count_not_enough) ->
4710012;


get(err471_open_day_not_enough) ->
4710013;


get(err471_enter_boss_count_not_enough) ->
4710014;


get(err471_not_change_scene_on_decoration_boss) ->
4710015;


get(err471_constellation_suit_not_enough) ->
4710016;


get(err480_no_zone) ->
4800001;


get(err480_no_invasion_zone_data) ->
4800002;


get(err480_no_invasion_ser_data) ->
4800003;


get(err480_already_invasion) ->
4800004;


get(err480_client_data_error) ->
4800005;


get(err480_invasion_close) ->
4800006;


get(err480_no_reach_open) ->
4800007;


get(err480_no_same_zone) ->
4800008;


get(err480_role_buyond) ->
4800009;


get(err490_full_draw) ->
4900001;


get(err490_no_draw_times) ->
4900002;


get(err490_already_back) ->
4900003;


get(err490_not_buy_all) ->
4900004;


get(err490_not_buy) ->
4900005;


get(err500_husong_start) ->
5000001;


get(err500_husong_end) ->
5000002;


get(err500_husong_unfinish_last_stage) ->
5000003;


get(err500_husong_quality_max) ->
5000004;


get(err500_husong_cant_change_scene) ->
5000005;


get(err500_husong_not_start) ->
5000006;


get(err500_husong_stage_wrong) ->
5000007;


get(err500_husong_ask_cd) ->
5000008;


get(err500_husong_help_offline) ->
5000009;


get(err500_husong_help_end) ->
5000010;


get(err500_husong_help_same_scene) ->
5000011;


get(err500_husong_not_now_scene_packup) ->
5000012;


get(err500_husong_not_right_target_id) ->
5000013;


get(err500_husong_take_num_max) ->
5000014;


get(err500_husong_take_success) ->
5000015;


get(err500_husong_invincible_max) ->
5000016;


get(err500_husong_reflesh_fail) ->
5000017;


get(err500_husong_reflesh_success) ->
5000018;


get(err500_husong_cost) ->
5000019;


get(err500_husong_time) ->
5000020;


get(err500_times_not_enough) ->
5000021;


get(err501_please_join_guild) ->
5010001;


get(err501_cannot_attack_friend) ->
5010002;


get(err501_act_close) ->
5010003;


get(err501_in_attack_cd) ->
5010004;


get(err501_player_not_exist) ->
5010005;


get(err501_oppplayer_not_exist) ->
5010006;


get(err501_in_protect_cd) ->
5010007;


get(err501_cannot_attack) ->
5010008;


get(err501_not_in_attack_idel) ->
5010009;


get(err501_cannot_attack_self) ->
5010010;


get(err501_cannot_transferable) ->
5010011;


get(err501_lv_not_enough) ->
5010012;


get(err503_cannot_transferable) ->
5030001;


get(err503_lv_error) ->
5030002;


get(err503_rival_not_enough) ->
5030003;


get(err503_init_rival_error) ->
5030004;


get(err503_client_init_rival_error) ->
5030005;


get(err503_finish_all_attack) ->
5030006;


get(err503_in_battle_status) ->
5030007;


get(err503_no_award) ->
5030008;


get(err503_not_enough_attack_count) ->
5030009;


get(err503_reset_status) ->
5030010;


get(err503_missing_award_cfg) ->
5030011;


get(err503_settlement_plase_wait) ->
5030012;


get(err503_not_in_hero_war) ->
5030013;


get(err505_reward_is_got) ->
5050001;


get(err505_in_guild_battle) ->
5050002;


get(err505_is_not_open) ->
5050003;


get(err505_cfg_error) ->
5050004;


get(err505_not_in_battle) ->
5050005;


get(err505_lv_not_enough) ->
5050006;


get(err505_no_guild) ->
5050007;


get(err505_condition_not_enough) ->
5050008;


get(err505_resource_not_enough) ->
5050009;


get(err505_ac_enough_role) ->
5050010;


get(err505_guild_enough_role) ->
5050011;


get(err505_war_is_openning) ->
5050012;


get(err505_not_winner) ->
5050013;


get(err505_reward_is_alloc) ->
5050014;


get(err505_no_alloc_reward) ->
5050015;


get(err505_join_in_guild_not_enough_time_can_not_receive) ->
5050016;


get(err506_in_battle) ->
5060001;


get(err506_war_not_start) ->
5060002;


get(err506_war_end) ->
5060003;


get(err506_fight_end) ->
5060004;


get(err506_no_qualification) ->
5060005;


get(err506_no_qualification_2) ->
5060006;


get(err506_choose_time_err) ->
5060007;


get(err506_had_choose) ->
5060008;


get(err506_had_be_choose) ->
5060009;


get(err506_choose_err_id) ->
5060010;


get(err506_not_in_battle) ->
5060011;


get(err506_only_chief_choose) ->
5060012;


get(err506_not_winner) ->
5060013;


get(err506_reward_is_got) ->
5060014;


get(err506_join_in_guild_not_enough_time_can_not_receive) ->
5060015;


get(err506_not_chief_alloc) ->
5060016;


get(err506_not_same_guild_alloc) ->
5060017;


get(err506_war_is_openning) ->
5060018;


get(err506_reward_is_alloc) ->
5060019;


get(err506_no_alloc_reward) ->
5060020;


get(err506_no_qualification_3) ->
5060021;


get(err507_pre_level_not_pass) ->
5070001;


get(err507_level_too_low) ->
5070002;


get(err507_no_reward) ->
5070003;


get(err507_reward_got) ->
5070004;


get(err507_no_dungeon_times) ->
5070005;


get(err508_single_dun_not_succ) ->
5080001;


get(err508_single_dun_not_succ_by_other) ->
5080002;


get(err510_all_got) ->
5100001;


get(err510_had_abandon) ->
5100002;


get(err510_no_rotary) ->
5100003;


get(err512_act_close) ->
5120001;


get(err512_end_buy) ->
5120002;


get(err512_no_times_in_restriction) ->
5120003;


get(err512_stage_count_err) ->
5120004;


get(err512_stage_reward_got) ->
5120005;


get(err512_stage_count_less) ->
5120006;


get(err512_no_draw_reward) ->
5120007;


get(err512_grade_end) ->
5120008;


get(err512_no_grade_times) ->
5120009;


get(err512_no_such_grade) ->
5120010;


get(err513_not_buy) ->
5130001;


get(err513_low_lv) ->
5130002;


get(err600_not_open) ->
6000000;


get(err600_is_pass) ->
6000001;


get(err600_can_not_change_scene_in_void_fam) ->
6000002;


get(err601_not_kf_hegemony_server) ->
6010001;


get(err601_be_appoint_ser_id_not_vaild) ->
6010002;


get(err601_has_appoint_server) ->
6010003;


get(err601_appoint_server_cd) ->
6010004;


get(err601_not_enough_score) ->
6010005;


get(err601_player_not_qualified) ->
6010006;


get(err601_battlefield_has_end) ->
6010007;


get(err601_not_in_battle_stage) ->
6010008;


get(err601_reach_max_people_lim) ->
6010009;


get(err601_has_sign_up) ->
6010010;


get(err601_cant_sign_up_because_stage_err) ->
6010011;


get(err601_cant_change_scene_in_kf_hegemony) ->
6010012;


get(err601_battle_room_not_exist) ->
6010013;


get(err601_not_in_act_scene) ->
6010014;


get(err601_lv_lim) ->
6010015;


get(err601_has_in_scene) ->
6010016;


get(err601_not_dominator) ->
6010017;


get(err602_act_close) ->
6020001;


get(err602_cant_change_scene_in_th_armies_battle) ->
6020002;


get(err602_not_in_act_scene) ->
6020003;


get(err602_no_enough_lv_join) ->
6020004;


get(err602_max_people_num_lim) ->
6020005;


get(err603_in_battle) ->
6030001;


get(err604_apply_power_limit) ->
6040001;


get(err604_apply_repeat) ->
6040002;


get(err604_not_competitor) ->
6040003;


get(err604_in_the_act) ->
6040004;


get(err604_not_enter_state) ->
6040005;


get(err604_skill_cd) ->
6040006;


get(err604_life_num_max) ->
6040007;


get(err604_buy_life_cost) ->
6040008;


get(err604_has_fail) ->
6040009;


get(err604_guess_reward_is_got) ->
6040010;


get(err604_guess_reward_error) ->
6040011;


get(err604_not_guess_time) ->
6040012;


get(err604_guest_modify) ->
6040013;


get(err604_guest_role_error) ->
6040014;


get(err604_guess_no_change) ->
6040015;


get(err604_any_guess_not_choosed) ->
6040016;


get(err604_battle_end) ->
6040017;


get(err604_visitor_num_limit) ->
6040018;


get(err604_competitor_cannot_visit) ->
6040019;


get(err606_lv_limit) ->
6060001;


get(err606_not_enough_cost) ->
6060002;


get(err606_already_active) ->
6060003;


get(err606_max_stage) ->
6060004;


get(err606_not_active) ->
6060005;


get(err606_max_lv) ->
6060006;


get(err606_relic_max_times) ->
6060007;


get(err606_already_illu) ->
6060008;


get(err607_not_enter_times) ->
6070001;


get(err607_fighting) ->
6070002;


get(err607_cd) ->
6070003;


get(err607_fight_self) ->
6070004;


get(err607_sainting) ->
6070005;


get(err607_saint_lv_limit) ->
6070006;


get(err607_inspire_num_limit) ->
6070007;


get(err610_dungeon_role_not_exist) ->
6100001;


get(err610_dungeon_team_args_error) ->
6100002;


get(err610_not_on_safe_scene_to_enter_dungeon) ->
6100003;


get(err610_not_on_safe_scene_to_enter_dungeon_by_other) ->
6100004;


get(err610_not_enough_lv_to_enter_dungeon_by_other) ->
6100005;


get(err610_dungeon_count_daily_help_by_other) ->
6100006;


get(err610_dungeon_count_permanent_by_other) ->
6100007;


get(err610_dungeon_count_week_by_other) ->
6100008;


get(err610_dungeon_count_daily_by_other) ->
6100009;


get(err610_dungeon_not_open) ->
6100010;


get(err610_just_once_finish) ->
6100011;


get(err610_need_finish_dun_id) ->
6100012;


get(err610_not_enough_lv_to_enter_dungeon) ->
6100013;


get(err610_dungeon_num_not_satisfy) ->
6100014;


get(err610_dungeon_count_cfg_error) ->
6100015;


get(err610_dungeon_count_daily_help) ->
6100016;


get(err610_dungeon_count_permanent) ->
6100017;


get(err610_dungeon_count_week) ->
6100018;


get(err610_dungeon_count_daily) ->
6100019;


get(err610_cls_team_not_enter_dungeon) ->
6100020;


get(err610_on_dungeon) ->
6100021;


get(err610_dungeon_not_exist) ->
6100022;


get(err610_not_on_enter_scene) ->
6100029;


get(err610_not_on_enter_scene_by_other) ->
6100030;


get(err610_dungeon_error) ->
6100031;


get(err610_dungeon_scene_not_exist) ->
6100032;


get(err610_had_on_dungeon) ->
6100033;


get(err610_cannot_join_act_on_battle) ->
6100034;


get(err610_cannot_join_act_on_battle_with_name) ->
6100035;


get(err610_have_no_count_to_enter_target_with_name) ->
6100038;


get(err610_have_no_count_to_enter_target) ->
6100039;


get(err610_have_no_count_to_create_target) ->
6100040;


get(err610_enter_cost_error) ->
6100041;


get(err610_buy_cost_error) ->
6100042;


get(err610_buy_vip_error) ->
6100043;


get(err610_buy_limit_error) ->
6100044;


get(err610_sweep_limit_error) ->
6100045;


get(err610_sweep_lv_limit) ->
6100046;


get(err610_sweep_never_finish) ->
6100047;


get(err610_dungeon_count_daily_sweep) ->
6100048;


get(err610_dungeon_count_weekly_sweep) ->
6100049;


get(err610_dungeon_count_permanent_sweep) ->
6100050;


get(err610_help_times_left) ->
6100051;


get(err610_encourage_count_limit) ->
6100052;


get(err610_encourage_coin_count_limit) ->
6100053;


get(err610_reset_count_limit) ->
6100054;


get(err610_nothing_reset) ->
6100055;


get(err610_nothing_sweep) ->
6100056;


get(err610_help_reward_time_limit) ->
6100057;


get(err610_too_many_members) ->
6100058;


get(err610_dungeon_is_end) ->
6100059;


get(err610_buy_count_error) ->
6100060;


get(err610_only_couple_enter) ->
6100061;


get(err610_choose_same_partner_group_id) ->
6100067;


get(err610_on_choose_partner_group_cd) ->
6100068;


get(err610_not_right_group_id) ->
6100069;


get(err610_can_not_choose_partner_group) ->
6100070;


get(err610_encourage_gold_count_limit) ->
6100071;


get(err610_not_enough_turn_to_enter_dungeon) ->
6100072;


get(err610_must_pass_to_receive_reward) ->
6100073;


get(err610_had_receive_reward) ->
6100074;


get(err610_not_reward) ->
6100075;


get(err610_must_had_reward_to_enter) ->
6100076;


get(err610_not_enough_vip_type_to_enter_dungeon) ->
6100077;


get(err610_not_enough_vip_lv_to_enter_dungeon) ->
6100078;


get(err610_value_not_enougth) ->
6100079;


get(err610_mon_not_refresh) ->
6100080;


get(err610_not_enough_cd) ->
6100081;


get(err610_invitting_other_to_dun) ->
6100082;


get(err610_invite_timeout) ->
6100083;


get(err610_not_invite_dun) ->
6100084;


get(err610_buy_not_marriage) ->
6100085;


get(err610_single_dungeon_must_quit_team) ->
6100086;


get(err610_not_enough_quick_create_mon_count) ->
6100087;


get(err610_on_quick_create_mon_cd) ->
6100088;


get(err610_skill_error_in_ghost) ->
6100089;


get(err610_help_can_not_collect) ->
6100090;


get(err610_not_finish_task) ->
6100091;


get(err610_not_tigger_task) ->
6100092;


get(err610_can_not_again_enter_dungeon) ->
6100093;


get(err610_need_finish_dun_id2) ->
6100094;


get(err610_not_exist_demon) ->
6100095;


get(err610_dun_demon_low_dun) ->
6100096;


get(err650_too_many_demon) ->
6100097;


get(err610_is_on_dungeon_not_to_setting) ->
6100098;


get(err610_setting_count_error) ->
6100099;


get(err610_setting_open_error) ->
6100100;


get(err610_dungeon_count_error) ->
6100101;


get(err610_merge_count_error) ->
6100102;


get(err610_partner_max_score) ->
6100103;


get(err610_not_pass_rune) ->
6100104;


get(err610_rune_dun_level_limit) ->
6100105;


get(err610_not_pass_first_dup) ->
6100106;


get(err610_not_pass_last_dup) ->
6100107;


get(err610_limit_tower_round_over) ->
6100108;


get(err610_not_pass_all_dup) ->
6100109;


get(err610_limit_tower_not_update) ->
6100110;


get(err610_no_dun_gata_or_sweep) ->
6100111;


get(err610_no_active_weekly_card) ->
6100112;


get(err612_time_out) ->
6120001;


get(err612_goods_null) ->
6120002;


get(err621_in_kf_1vn) ->
6210001;


get(err621_is_signed) ->
6210002;


get(err621_no_sign) ->
6210003;


get(err621_not_in_race_2) ->
6210004;


get(err621_has_betted) ->
6210005;


get(err621_no_enter) ->
6210006;


get(err621_no_bet_self) ->
6210007;


get(err621_not_battle) ->
6210008;


get(err621_battle_is_end) ->
6210009;


get(err621_not_bet_stage) ->
6210010;


get(err621_has_battle) ->
6210011;


get(err621_watch_max_num) ->
6210012;


get(err621_goods_not_enough) ->
6210013;


get(err621_turn_not_enough) ->
6210014;


get(err621_not_kf_1vN_challenger) ->
6210015;


get(err621_not_match_yet) ->
6210016;


get(err621_had_get_bet_reward) ->
6210017;


get(err621_not_result_to_get_bet_reward) ->
6210018;


get(err621_bet_turn_error) ->
6210019;


get(err621_had_bet_this_battle) ->
6210020;


get(err621_max_bet_count) ->
6210021;


get(err621_no_battle) ->
6210022;


get(err621_bet_opt_error) ->
6210023;


get(err622_not_be_suit) ->
6220001;


get(err622_bag_not_enough) ->
6220002;


get(err640_goods_not_on_sale) ->
6400000;


get(err647_lv_not_enough) ->
6470001;


get(err647_not_has_guild) ->
6470002;


get(err647_activity_not_open) ->
6470003;


get(err647_not_in_safe_area) ->
6470004;


get(err647_not_in_guild_war) ->
6470005;


get(err647_in_guild_war) ->
6470006;


get(err647_forbid_enter_again) ->
6470007;


get(err647_self_guild_is_over) ->
6470008;


get(err650_kf_3v3_in_kill_scene) ->
6500001;


get(err650_kf_3v3_not_conn) ->
6500002;


get(err650_kf_3v3_lack_wincount) ->
6500003;


get(err650_kf_3v3_lack_reward) ->
6500004;


get(err650_kf_3v3_is_packed) ->
6500005;


get(err650_kf_3v3_kick_self) ->
6500006;


get(err650_kf_3v3_long_pasm) ->
6500007;


get(err650_kf_3v3_come_to_end) ->
6500008;


get(err650_kf_3v3_watting) ->
6500009;


get(err650_kf_3v3_not_start) ->
6500010;


get(err650_kf_3v3_delete_team) ->
6500011;


get(err650_kf_3v3_update_team) ->
6500012;


get(err650_kf_3v3_update_teamlist) ->
6500013;


get(err650_kf_3v3_low_power) ->
6500014;


get(err650_kf_3v3_low_lv) ->
6500015;


get(err650_kf_3v3_wrong_pswd) ->
6500016;


get(err650_kf_3v3_no_member) ->
6500017;


get(err650_kf_3v3_war_end) ->
6500018;


get(err650_kf_3v3_not_joined) ->
6500019;


get(err650_kf_3v3_cannot_reset_ready) ->
6500020;


get(err650_kf_3v3_not_ready) ->
6500021;


get(err650_kf_3v3_matching) ->
6500022;


get(err650_kf_3v3_lack_member) ->
6500023;


get(err650_kf_3v3_fighting) ->
6500024;


get(err650_kf_3v3_not_captain) ->
6500025;


get(err650_kf_3v3_no_team) ->
6500026;


get(err650_kf_3v3_full_member) ->
6500027;


get(err650_kf_3v3_in_team) ->
6500028;


get(err650_in_kf_3v3_act) ->
6500029;


get(err650_kf_3v3_lack_count) ->
6500030;


get(err650_tier_not_enough) ->
6500031;


get(err650_hornor_limit) ->
6500032;


get(err650_fame_yet_get) ->
6500033;


get(err650_kf_3v3_match_limt) ->
6500034;


get(err650_err_name) ->
6500035;


get(err650_team_max_member) ->
6500037;


get(err650_have_team) ->
6500038;


get(err650_err_team_id) ->
6500039;


get(err650_err_role_id) ->
6500040;


get(err650_not_leader) ->
6500041;


get(err650_can_not_kick_leader) ->
6500042;


get(err650_role_off_line) ->
6500043;


get(err650_not_have_team) ->
6500044;


get(err650_voto_repeat) ->
6500045;


get(err286_vote_over_time) ->
6500046;


get(err650_vote_over_time) ->
6500047;


get(err650_team_in_match) ->
6500048;


get(err650_team_not_matching) ->
6500049;


get(err650_can_not_vote) ->
6500050;


get(err650_team_err_length) ->
6500051;


get(err650_can_not_handle_in_act) ->
6500052;


get(err650_champion_pk_close) ->
6500053;


get(err650_not_in_champion_scene) ->
6500054;


get(err650_have_guess_in_one_turn) ->
6500055;


get(err650_not_guess_opt) ->
6500056;


get(err650_err_guess_turn) ->
6500057;


get(err650_guess_cost_type_err) ->
6500058;


get(err650_guess_cost_num_err) ->
6500059;


get(err650_not_guess_stage) ->
6500060;


get(err650_not_have_guess_record) ->
6500061;


get(err650_can_not_get_guess_reward) ->
6500062;


get(err650_have_got_guess_reward) ->
6500063;


get(err650_have_teammate_offline) ->
6500064;


get(err650_no_in_pk) ->
6500065;


get(err650_yet_in_3v3_scene) ->
6500066;


get(err650_not_in_3v3_scene) ->
6500067;


get(err650_not_16_team) ->
6500068;


get(err650_can_not_cut) ->
6500069;


get(err650_in_pk) ->
6500070;


get(err650_chanpion_can_not_change_team) ->
6500071;


get(err650_in_kf_3v3_act_single) ->
6500072;


get(err651_not_enough_count) ->
6510001;


get(err651_in_scene) ->
6510002;


get(err651_not_in_scene) ->
6510003;


get(err651_err_buy_count) ->
6510004;


get(err651_not_change_scene_on_dragon_boss) ->
6510005;


get(err651_add_time) ->
6510006;


get(err651_zone_change_can_not_add_time) ->
6510007;


get(err651_zone_change_time_can_not_join) ->
6510008;


get(err652_lv_not_enough) ->
6520001;


get(err652_time_out_of_rang) ->
6520002;


get(err652_open_day_limit) ->
6520003;


get(err652_error_cfg) ->
6520004;


get(act_end) ->
6520005;


get(err652_dunid_wrong) ->
6520006;


get(err653_not_enough_score) ->
6530001;


get(err653_had_stage_reward) ->
6530002;


get(err653_not_find_robot) ->
6530003;


get(err653_not_in_rank) ->
6530004;


get(err653_nobody_rank) ->
6530005;


get(err653_cant_get_stage) ->
6530006;


get(err654_strength_level_limit) ->
6540001;


get(err654_pill_lv_limit) ->
6540002;


get(err654_has_equiped) ->
6540003;


get(err654_wrong_data) ->
6540004;


get(err188_not_kill_boss) ->
18800001;


get(err188_not_bl) ->
18800002;


get(err188_has_get_reward) ->
18800003;


get(err241_in_beings_gate) ->
24100001;


get(err241_no_in_beings_gate) ->
24100002;


get(err241_no_portal_id) ->
24100003;

get(_Type) ->
	?PRINT("_Type:~p ~n", [_Type]),0.

