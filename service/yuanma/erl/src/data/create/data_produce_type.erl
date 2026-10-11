%%%---------------------------------------
%%% module      : data_produce_type
%%% description : 产出消耗配置
%%%
%%%---------------------------------------
-module(data_produce_type).
-compile(export_all).




get_produce(unkown) ->
0;


get_produce(mon_drop) ->
1;


get_produce(mail_attachment) ->
2;


get_produce(achievement) ->
3;


get_produce(gm) ->
4;


get_produce(task) ->
5;


get_produce(sell_goods) ->
6;


get_produce(recharge) ->
7;


get_produce(recharge_card) ->
8;


get_produce(mail) ->
9;


get_produce(dungeon) ->
10;


get_produce(shop_normal) ->
11;


get_produce(gift) ->
12;


get_produce(ac_custom_random) ->
13;


get_produce(send_flower) ->
14;


get_produce(goods_use) ->
15;


get_produce(ac_custom_sum_recharge) ->
16;


get_produce(optional_gift) ->
17;


get_produce(receive_guild_salary) ->
18;


get_produce(guild_depot_exchange) ->
19;


get_produce(red_envelopes) ->
20;


get_produce(use_designtion_good) ->
21;


get_produce(goods_compose) ->
22;


get_produce(goods_decompose) ->
23;


get_produce(equip_suit_take_off) ->
24;


get_produce(fashion_resolve) ->
25;


get_produce(shop_week) ->
26;


get_produce(shop_bgold) ->
27;


get_produce(shop_fashion) ->
28;


get_produce(guild_feast) ->
29;


get_produce(guild_feast_grand_total) ->
30;


get_produce(dungeon_count_sweep_rewards) ->
31;


get_produce(rune_exchange) ->
32;


get_produce(dungeon_drop_auto_pick) ->
33;


get_produce(equip_stone_return) ->
34;


get_produce(void_fam) ->
35;


get_produce(sell_down) ->
36;


get_produce(pay_sell) ->
37;


get_produce(jjc_challenge_reward) ->
38;


get_produce(jjc_break_reward) ->
39;


get_produce(jjc_rank_reward) ->
40;


get_produce(finish_daily_task) ->
41;


get_produce(finish_guild_task) ->
42;


get_produce(daily_checkin) ->
43;


get_produce(total_checkin) ->
44;


get_produce(top_pk_daily_honor) ->
45;


get_produce(top_pk_daily_count_reward) ->
46;


get_produce(top_pk_grade_reward) ->
47;


get_produce(sell_up_hedge) ->
48;


get_produce(top_pk_battle_reward) ->
49;


get_produce(guild_war_reward) ->
50;


get_produce(guild_war_salary_paul) ->
51;


get_produce(gift_card) ->
52;


get_produce(noon_quiz_rank_reward) ->
53;


get_produce(noon_quiz_answer) ->
54;


get_produce(wedding_danmu) ->
55;


get_produce(eudemons_boss_cl) ->
56;


get_produce(treasure_hunt) ->
57;


get_produce(investment_reward) ->
58;


get_produce(goods_exchange) ->
59;


get_produce(clusters_mon_drop) ->
62;


get_produce(pray) ->
63;


get_produce(activity_live_reward) ->
64;


get_produce(resource_back) ->
65;


get_produce(wedding_fires) ->
66;


get_produce(wedding_kill_trouble) ->
67;


get_produce(treasure_chest) ->
68;


get_produce(eat_wedding_food) ->
69;


get_produce(eat_wedding_candies) ->
71;


get_produce(dog_food) ->
72;


get_produce(achv_reward) ->
73;


get_produce(arbitrate_fail_return) ->
74;


get_produce(husong_best) ->
75;


get_produce(husong_finish_first) ->
76;


get_produce(husong_finish_last) ->
77;


get_produce(rush_giftbag) ->
78;


get_produce(dungeon_evil_daily_reward) ->
79;


get_produce(rush_goal_reward) ->
80;


get_produce(login_reward) ->
81;


get_produce(eternal_valley_stage_reward) ->
82;


get_produce(col_world_act) ->
83;


get_produce(ac_recharge_cumulation) ->
84;


get_produce(down_load_gift) ->
85;


get_produce(guild_rename_fail) ->
86;


get_produce(recharge_gift_award) ->
87;


get_produce(achievement_reward) ->
88;


get_produce(treasure_hunt_fail) ->
89;


get_produce(share_reward) ->
90;


get_produce(show_love) ->
91;


get_produce(custom_act) ->
92;


get_produce(night_welfare) ->
93;


get_produce(smashed_egg) ->
94;


get_produce(smashed_egg_cumulate_reward) ->
95;


get_produce(cloud_buy_error) ->
96;


get_produce(cloud_buy_happy) ->
97;


get_produce(exchange_act) ->
98;


get_produce(gboss_mat_donate_reward) ->
99;


get_produce(shop_honour) ->
100;


get_produce(walfare_reward) ->
101;


get_produce(wedding_aura) ->
102;


get_produce(th_armies_battle) ->
103;


get_produce(boss_first_blood) ->
104;


get_produce(guild_create_act_reward) ->
105;


get_produce(hi_points) ->
106;


get_produce(eudemons_attack_hurt_step) ->
107;


get_produce(eudemons_act_reward) ->
108;


get_produce(fireworks_act) ->
109;


get_produce(buy_goods) ->
110;


get_produce(lucky_turntable_rewards) ->
111;


get_produce(version_upgradebag) ->
112;


get_produce(limit_shop_buy) ->
113;


get_produce(peak_treasure_hunt) ->
114;


get_produce(extreme_treasure_hunt) ->
115;


get_produce(rune_treasure_hunt) ->
116;


get_produce(treasure_evaluation) ->
117;


get_produce(quick_buy) ->
118;


get_produce(collect_put_s) ->
119;


get_produce(collect_put_n) ->
120;


get_produce(remove_equip_skill_return_cost) ->
121;


get_produce(diamond_league_guess_reward) ->
122;


get_produce(diamond_league_result) ->
123;


get_produce(login_return_reward_buy) ->
124;


get_produce(login_return_reward_return) ->
125;


get_produce(kf_cloud_buy_rand_reward) ->
126;


get_produce(kf_cloud_buy_return_cost) ->
127;


get_produce(kf_cloud_buy_draw_reward) ->
128;


get_produce(overflow_gift_act) ->
129;


get_produce(spec_sell_act) ->
130;


get_produce(kf_3v3) ->
131;


get_produce(shop_3v3) ->
132;


get_produce(kf_3v3_wincount) ->
133;


get_produce(lucky_flop) ->
134;


get_produce(holy_ghost) ->
135;


get_produce(kf_3v3_daily) ->
136;


get_produce(mount_equip) ->
137;


get_produce(guess_reward) ->
138;


get_produce(kf_1vn_race_2) ->
139;


get_produce(kf_1vn_race_1_score_rank) ->
140;


get_produce(kf_1vn_auction_fail) ->
141;


get_produce(kf_gwar_daily_reward) ->
142;


get_produce(kf_gwar_donate_reward) ->
143;


get_produce(kf_gwar_stage_reward) ->
144;


get_produce(declare_war_return) ->
145;


get_produce(cancel_declare_war) ->
146;


get_produce(daily_turntable) ->
147;


get_produce(kf_gwar_return_gfunds_in_confirm) ->
148;


get_produce(saint) ->
149;


get_produce(garden_product) ->
150;


get_produce(garden_wish) ->
151;


get_produce(wish_daily_free) ->
152;


get_produce(guard_sweep_rewards) ->
153;


get_produce(onhook_reward) ->
154;


get_produce(guard_boss_rewards) ->
155;


get_produce(guard_seal_reward) ->
156;


get_produce(vip_present) ->
157;


get_produce(vip_reward) ->
158;


get_produce(vip_weekly_reward) ->
159;


get_produce(vip_card_award) ->
160;


get_produce(mon_pic) ->
161;


get_produce(role_donate) ->
162;


get_produce(get_activity_gift) ->
163;


get_produce(upgrade_fashion_pos) ->
164;


get_produce(liveness_back) ->
165;


get_produce(dungeon_extra_reward) ->
166;


get_produce(shop_diamond) ->
167;


get_produce(worship_reward) ->
168;


get_produce(onhook_offline_reward) ->
169;


get_produce(seek_goods) ->
170;


get_produce(sell_seek_goods) ->
171;


get_produce(jjc_challenge_break_reward) ->
172;


get_produce(guild_feast_fire) ->
173;


get_produce(guild_feast_question) ->
174;


get_produce(world_boss_reward) ->
175;


get_produce(world_boss_killreward) ->
176;


get_produce(mystery_shop) ->
177;


get_produce(guild_battle) ->
178;


get_produce(guild_feast_boss) ->
179;


get_produce(role_nine) ->
180;


get_produce(guild_dun_challenge) ->
181;


get_produce(guild_score_gift) ->
182;


get_produce(treasure_score_shop) ->
183;


get_produce(rush_rank) ->
184;


get_produce(online_reward) ->
185;


get_produce(hire_act) ->
186;


get_produce(investment_buy) ->
187;


get_produce(fashion_act) ->
188;


get_produce(invite_box) ->
189;


get_produce(invite_reward) ->
190;


get_produce(race_act) ->
191;


get_produce(phantom_boss) ->
192;


get_produce(custom_act_gwar) ->
193;


get_produce(invite_lv_reward_pos) ->
194;


get_produce(invite_lv_reward_once) ->
195;


get_produce(soul_dungeon_reward) ->
196;


get_produce(enchantment_guard_stage_reward) ->
197;


get_produce(invite_red_packet) ->
198;


get_produce(eudemons_boss) ->
199;


get_produce(shake) ->
200;


get_produce(kf_1vn_bet) ->
201;


get_produce(exchange_act_new) ->
202;


get_produce(other_drop) ->
203;


get_produce(drumwar_sign) ->
204;


get_produce(drumwar) ->
205;


get_produce(boss_first_award) ->
206;


get_produce(count_gift) ->
207;


get_produce(bonus_tree) ->
208;


get_produce(feast_boss_box_reward) ->
209;


get_produce(change_pos) ->
210;


get_produce(mon_invade) ->
211;


get_produce(open_module) ->
212;


get_produce(task_drop) ->
213;


get_produce(glad_challenge_reward) ->
214;


get_produce(move_goods) ->
215;


get_produce(glad_stage_reward) ->
216;


get_produce(glad_rank_reward) ->
217;


get_produce(make_equip_suit) ->
218;


get_produce(fairyland_boss_draw) ->
219;


get_produce(use_gift) ->
220;


get_produce(rush_shop) ->
221;


get_produce(top_pk_battle_honor) ->
222;


get_produce(top_pk_season_reward) ->
223;


get_produce(love_gift) ->
224;


get_produce(propose) ->
225;


get_produce(shop_glory) ->
226;


get_produce(territory_hurt) ->
228;


get_produce(custom_act_liveness_commit) ->
229;


get_produce(custom_act_liveness) ->
230;


get_produce(task_func_drop) ->
231;


get_produce(sanctuary_kill_reward) ->
232;


get_produce(task_stage_func_drop) ->
233;


get_produce(cloud_buy_stage) ->
234;


get_produce(shop_seal) ->
235;


get_produce(kf_sanctuary_hurt_rank) ->
236;


get_produce(kf_sanctuary_con_bl) ->
237;


get_produce(kf_sanctuary_score) ->
238;


get_produce(custom_act_mount_turntable) ->
239;


get_produce(combine_stone) ->
240;


get_produce(shop_medal) ->
241;


get_produce(summon_card_reward) ->
242;


get_produce(draw_reward_special) ->
243;


get_produce(midday_party) ->
244;


get_produce(feast_shop) ->
245;


get_produce(monday_draw) ->
246;


get_produce(guild_quiz_rank_reward) ->
247;


get_produce(kf_3v3_battle_reward) ->
248;


get_produce(surprise_gift) ->
249;


get_produce(luckey_egg) ->
250;


get_produce(compensate_exp) ->
251;


get_produce(dungeon_wave_stage) ->
252;


get_produce(shop_figure) ->
253;


get_produce(dragon_decompose) ->
254;


get_produce(dragon_down_pos_lv) ->
255;


get_produce(dragon_beckon) ->
256;


get_produce(god_active) ->
257;


get_produce(sanctuary_belong_reward) ->
258;


get_produce(sanctuary_participant_reward) ->
259;


get_produce(god_lv_update) ->
260;


get_produce(god_stage) ->
261;


get_produce(praise_baby) ->
262;


get_produce(level_act_shop) ->
263;


get_produce(dun_dragon_jump_wave_reward) ->
264;


get_produce(boss_domain) ->
265;


get_produce(fest_investment) ->
266;


get_produce(adventure_throw) ->
267;


get_produce(adventure_reset) ->
268;


get_produce(festival_recharge_reward) ->
269;


get_produce(baby_treasure_hunt) ->
270;


get_produce(soul_dun_stage_reward) ->
271;


get_produce(adven_shop) ->
272;


get_produce(holy_summon_draw) ->
273;


get_produce(holy_stage_reward) ->
274;


get_produce(rush_buy) ->
275;


get_produce(demons_painting) ->
276;


get_produce(revelation_equip_swallow) ->
277;


get_produce(dragon_count_award) ->
278;


get_produce(vip_gift_buy) ->
279;


get_produce(soul_dismantle_awake) ->
280;


get_produce(custom_act_pray) ->
281;


get_produce(luckey_egg_cumulate_reward) ->
282;


get_produce(recharge_one_reward) ->
283;


get_produce(demons_shop) ->
284;


get_produce(shop_supvip) ->
285;


get_produce(eudemons_boss_score) ->
286;


get_produce(supvip_return_currency) ->
287;


get_produce(supvip_currency_task) ->
288;


get_produce(supvip_skill_task) ->
289;


get_produce(supvip_right_reward) ->
290;


get_produce(select_pool_draw) ->
291;


get_produce(select_stage_reward) ->
292;


get_produce(shop_eudemons) ->
293;


get_produce(guess_3v3_reward) ->
294;


get_produce(rune_dismantle_awake) ->
295;


get_produce(level_act_help_gift) ->
296;


get_produce(pic_decompose) ->
297;


get_produce(decoration_boss_assist) ->
298;


get_produce(decoration_boss_join) ->
299;


get_produce(decoration_boss_bl) ->
300;


get_produce(decoration_sboss_join) ->
301;


get_produce(decoration_sboss_bl) ->
302;


get_produce(treasure_map) ->
303;


get_produce(bonus_pool) ->
304;


get_produce(terri_war) ->
305;


get_produce(gboss) ->
306;


get_produce(dungeon_count_drop) ->
307;


get_produce(kf_rank_dungeon) ->
308;


get_produce(shop_rdungeon) ->
309;


get_produce(week_dungeon) ->
310;


get_produce(luckey_wheel) ->
311;


get_produce(activation_draw) ->
312;


get_produce(activation_reward) ->
313;


get_produce(recharge_draw) ->
314;


get_produce(recharge_reward) ->
315;


get_produce(spirit_rotary) ->
316;


get_produce(envelopes_rain) ->
317;


get_produce(wx_share) ->
318;


get_produce(boss_rotary) ->
319;


get_produce(shop_draconic) ->
320;


get_produce(guild_daily) ->
321;


get_produce(holy_spirit_battlefield_exp) ->
322;


get_produce(holy_spirit_battlefield_point_reward) ->
323;


get_produce(holy_spirit_battlefield_reward) ->
324;


get_produce(kf_cloud_buy) ->
325;


get_produce(kf_group_buy) ->
326;


get_produce(fortune_cat_rewards) ->
327;


get_produce(bonus_tree_shop) ->
328;


get_produce(shop_lucky) ->
329;


get_produce(arcana_reset) ->
330;


get_produce(real_info) ->
331;


get_produce(contract_challenge) ->
332;


get_produce(god_house_crytal) ->
333;


get_produce(day_chrono_rift_reward) ->
334;


get_produce(chrono_rift_goal_reward) ->
335;


get_produce(escort_reward) ->
336;


get_produce(shop_god_court) ->
337;


get_produce(shop_prestige) ->
338;


get_produce(wx_collect) ->
339;


get_produce(guild_assist) ->
340;


get_produce(star_trek_rewards) ->
342;


get_produce(seacraft_reward) ->
343;


get_produce(afk_trigger) ->
344;


get_produce(afk_off) ->
345;


get_produce(unequip_stone) ->
346;


get_produce(first_blood_plus_boss) ->
347;


get_produce(dun_partner_stage_reward) ->
348;


get_produce(dun_partner_sweep_reward) ->
349;


get_produce(first_blood_plus_dun) ->
350;


get_produce(special_gift_act) ->
351;


get_produce(destiny_turnable) ->
352;


get_produce(custom_act_treasure_task) ->
353;


get_produce(custom_treasure) ->
354;


get_produce(up_power_rank_stage_reward) ->
355;


get_produce(guild_act_buy_food) ->
356;


get_produce(err402_yet_buy_food) ->
357;


get_produce(common_draw) ->
358;


get_produce(rank_power_gift) ->
359;


get_produce(first_pass_rune_dun) ->
360;


get_produce(pass_rune_dun) ->
361;


get_produce(dungeon_reward) ->
362;


get_produce(sea_rob_reward) ->
363;


get_produce(sea_rob_back_reward) ->
364;


get_produce(sea_rback_reward) ->
365;


get_produce(sea_treasure_reward) ->
366;


get_produce(fin_task_cost) ->
367;


get_produce(temple_awake_chapter) ->
368;


get_produce(temple_awake_chapter_stage) ->
369;


get_produce(buy_push_gift) ->
370;


get_produce(exchange_onhook_coin) ->
371;


get_produce(shop_zen_soul) ->
372;


get_produce(ql_draw) ->
373;


get_produce(sea_craft_daily_defend_reward) ->
374;


get_produce(sea_craft_daily_kill_reward) ->
375;


get_produce(sea_craft_carry_brick_reward) ->
376;


get_produce(sea_craft_daily_task_reward) ->
377;


get_produce(new_player_gift) ->
378;


get_produce(lv_block) ->
379;


get_produce(advertisement_reward) ->
380;


get_produce(fiesta) ->
381;


get_produce(first_challenge_vip_boss) ->
382;


get_produce(rune_dun_daily_reward) ->
383;


get_produce(rush_special_package) ->
384;


get_produce(rush_to_buy) ->
385;


get_produce(custom_act_daily_direct_buy) ->
386;


get_produce(combat_welfare_reward) ->
387;


get_produce(grow_welfare) ->
388;


get_produce(rush_treasure) ->
389;


get_produce(activitycalen) ->
390;


get_produce(envelope_rebate) ->
391;


get_produce(limit_tower_big_reward) ->
392;


get_produce(custom_the_carnival) ->
393;


get_produce(weekly_card) ->
394;


get_produce(cycle_rank_reach_reward) ->
395;


get_produce(one_click_sweep_reward) ->
396;


get_produce(one_click_gage_reward) ->
397;


get_produce(custom_act_sale) ->
398;


get_produce(custom_act_recharge_polite) ->
399;


get_produce(shop_night_ghost) ->
400;


get_produce(first_day_benefits) ->
401;


get_produce(night_ghost) ->
402;


get_produce(cycle_rank_accumulated) ->
403;


get_produce(cycle_rank_single_recharge) ->
404;


get_produce(week_overview) ->
405;


get_produce(act_wish_draw) ->
406;


get_produce(custom_act_figure_buy) ->
407;


get_produce(sanctuary_kill_player_reward) ->
408;


get_produce(companion_biog) ->
409;


get_produce(pool_gift) ->
410;


get_produce(hero_halo_reward) ->
411;


get_produce(star_nuclear_buy) ->
412;

get_produce(_Type) ->
	0.


get_produce_content(unkown) ->
<<"未知类型"/utf8>>;


get_produce_content(mon_drop) ->
<<"怪物掉落"/utf8>>;


get_produce_content(mail_attachment) ->
<<"邮件附件"/utf8>>;


get_produce_content(achievement) ->
<<"达成成就"/utf8>>;


get_produce_content(gm) ->
<<"秘籍获取"/utf8>>;


get_produce_content(task) ->
<<"任务奖励"/utf8>>;


get_produce_content(sell_goods) ->
<<"出售物品"/utf8>>;


get_produce_content(recharge) ->
<<"充值"/utf8>>;


get_produce_content(recharge_card) ->
<<"充值卡"/utf8>>;


get_produce_content(mail) ->
<<"邮件"/utf8>>;


get_produce_content(dungeon) ->
<<"副本"/utf8>>;


get_produce_content(shop_normal) ->
<<"常用道具商城"/utf8>>;


get_produce_content(gift) ->
<<"礼包"/utf8>>;


get_produce_content(ac_custom_random) ->
<<"定制活动随机奖励"/utf8>>;


get_produce_content(send_flower) ->
<<"花语鲜花"/utf8>>;


get_produce_content(goods_use) ->
<<"背包使用"/utf8>>;


get_produce_content(ac_custom_sum_recharge) ->
<<"累冲奖励"/utf8>>;


get_produce_content(optional_gift) ->
<<"自选宝箱"/utf8>>;


get_produce_content(receive_guild_salary) ->
<<"公会工资"/utf8>>;


get_produce_content(guild_depot_exchange) ->
<<"公会仓库兑换"/utf8>>;


get_produce_content(red_envelopes) ->
<<"红包"/utf8>>;


get_produce_content(use_designtion_good) ->
<<"使用已有称号的激活物品直接产出价格的货币"/utf8>>;


get_produce_content(goods_compose) ->
<<"物品合成"/utf8>>;


get_produce_content(goods_decompose) ->
<<"物品分解"/utf8>>;


get_produce_content(equip_suit_take_off) ->
<<"装备套装解散返还消耗"/utf8>>;


get_produce_content(fashion_resolve) ->
<<"时装道具分解"/utf8>>;


get_produce_content(shop_week) ->
<<"每周限购商城"/utf8>>;


get_produce_content(shop_bgold) ->
<<"绑钻商城"/utf8>>;


get_produce_content(shop_fashion) ->
<<"时装外形商城"/utf8>>;


get_produce_content(guild_feast) ->
<<"公会晚宴采集奖励"/utf8>>;


get_produce_content(guild_feast_grand_total) ->
<<"公会晚宴累计奖励"/utf8>>;


get_produce_content(dungeon_count_sweep_rewards) ->
<<"副本扫荡奖励"/utf8>>;


get_produce_content(rune_exchange) ->
<<"符文兑换"/utf8>>;


get_produce_content(dungeon_drop_auto_pick) ->
<<"副本掉落自动拾取"/utf8>>;


get_produce_content(equip_stone_return) ->
<<"卸下多余的宝石"/utf8>>;


get_produce_content(void_fam) ->
<<"虚空秘境"/utf8>>;


get_produce_content(sell_down) ->
<<"市场商品下架"/utf8>>;


get_produce_content(pay_sell) ->
<<"市场购买商品"/utf8>>;


get_produce_content(jjc_challenge_reward) ->
<<"竞技主动挑战奖励"/utf8>>;


get_produce_content(jjc_break_reward) ->
<<"竞技排名突破奖励"/utf8>>;


get_produce_content(jjc_rank_reward) ->
<<"竞技排名奖励"/utf8>>;


get_produce_content(finish_daily_task) ->
<<"完成悬赏任务奖励"/utf8>>;


get_produce_content(finish_guild_task) ->
<<"完成公会周任务奖励"/utf8>>;


get_produce_content(daily_checkin) ->
<<"每日签到签到奖励"/utf8>>;


get_produce_content(total_checkin) ->
<<"每日签到的累计签到奖励"/utf8>>;


get_produce_content(top_pk_daily_honor) ->
<<"巅峰竞技日常荣誉"/utf8>>;


get_produce_content(top_pk_daily_count_reward) ->
<<"决战之巅参与次数奖励"/utf8>>;


get_produce_content(top_pk_grade_reward) ->
<<"巅峰对决段位奖励"/utf8>>;


get_produce_content(sell_up_hedge) ->
<<"市场上架出错自动退还物品"/utf8>>;


get_produce_content(top_pk_battle_reward) ->
<<"决战之巅比赛结果奖励"/utf8>>;


get_produce_content(guild_war_reward) ->
<<"公会争霸比赛奖励"/utf8>>;


get_produce_content(guild_war_salary_paul) ->
<<"主宰公会俸禄"/utf8>>;


get_produce_content(gift_card) ->
<<"使用礼包卡"/utf8>>;


get_produce_content(noon_quiz_rank_reward) ->
<<"中午答题结算排行奖励"/utf8>>;


get_produce_content(noon_quiz_answer) ->
<<"中午答题单题结算"/utf8>>;


get_produce_content(wedding_danmu) ->
<<"婚礼弹幕"/utf8>>;


get_produce_content(eudemons_boss_cl) ->
<<"幻兽之域采集获得"/utf8>>;


get_produce_content(treasure_hunt) ->
<<"装备寻宝"/utf8>>;


get_produce_content(investment_reward) ->
<<"投资活动回报"/utf8>>;


get_produce_content(goods_exchange) ->
<<"物品兑换"/utf8>>;


get_produce_content(clusters_mon_drop) ->
<<"跨服怪物掉落"/utf8>>;


get_produce_content(pray) ->
<<"祈愿"/utf8>>;


get_produce_content(activity_live_reward) ->
<<"日常活跃度奖励"/utf8>>;


get_produce_content(resource_back) ->
<<"资源找回"/utf8>>;


get_produce_content(wedding_fires) ->
<<"放烟花"/utf8>>;


get_produce_content(wedding_kill_trouble) ->
<<"杀死捣蛋鬼"/utf8>>;


get_produce_content(treasure_chest) ->
<<"鸣海遗珠"/utf8>>;


get_produce_content(eat_wedding_food) ->
<<"吃喜宴"/utf8>>;


get_produce_content(eat_wedding_candies) ->
<<"吃喜糖"/utf8>>;


get_produce_content(dog_food) ->
<<"婚姻-撒狗粮"/utf8>>;


get_produce_content(achv_reward) ->
<<"达成成就奖励"/utf8>>;


get_produce_content(arbitrate_fail_return) ->
<<"投票中断返还消耗"/utf8>>;


get_produce_content(husong_best) ->
<<"护送最高品质天使额外奖励"/utf8>>;


get_produce_content(husong_finish_first) ->
<<"护送完成第一阶段"/utf8>>;


get_produce_content(husong_finish_last) ->
<<"护送完成最后阶段"/utf8>>;


get_produce_content(rush_giftbag) ->
<<"冲级礼包奖励"/utf8>>;


get_produce_content(dungeon_evil_daily_reward) ->
<<"诛邪战场每日积分奖励"/utf8>>;


get_produce_content(rush_goal_reward) ->
<<"冲榜目标奖励"/utf8>>;


get_produce_content(login_reward) ->
<<"七天登录"/utf8>>;


get_produce_content(eternal_valley_stage_reward) ->
<<"永恒碑谷阶段奖励"/utf8>>;


get_produce_content(col_world_act) ->
<<"开服集字产出"/utf8>>;


get_produce_content(ac_recharge_cumulation) ->
<<"累充活动奖励"/utf8>>;


get_produce_content(down_load_gift) ->
<<"下载礼包"/utf8>>;


get_produce_content(guild_rename_fail) ->
<<"公会重命名失败返还"/utf8>>;


get_produce_content(recharge_gift_award) ->
<<"首冲奖励礼包"/utf8>>;


get_produce_content(achievement_reward) ->
<<"成就奖励"/utf8>>;


get_produce_content(treasure_hunt_fail) ->
<<"寻宝失败退还"/utf8>>;


get_produce_content(share_reward) ->
<<"分享有礼"/utf8>>;


get_produce_content(show_love) ->
<<"秀恩爱"/utf8>>;


get_produce_content(custom_act) ->
<<"定制活动通用"/utf8>>;


get_produce_content(night_welfare) ->
<<"夜间福利"/utf8>>;


get_produce_content(smashed_egg) ->
<<"砸蛋"/utf8>>;


get_produce_content(smashed_egg_cumulate_reward) ->
<<"砸蛋累计奖励"/utf8>>;


get_produce_content(cloud_buy_error) ->
<<"众仙云购失败"/utf8>>;


get_produce_content(cloud_buy_happy) ->
<<"众仙云购小奖"/utf8>>;


get_produce_content(exchange_act) ->
<<"活动兑换"/utf8>>;


get_produce_content(gboss_mat_donate_reward) ->
<<"公会Boss兽魂兑换"/utf8>>;


get_produce_content(shop_honour) ->
<<"荣誉商城"/utf8>>;


get_produce_content(walfare_reward) ->
<<"福利礼包奖励"/utf8>>;


get_produce_content(wedding_aura) ->
<<"婚礼气氛值奖励"/utf8>>;


get_produce_content(th_armies_battle) ->
<<"三军之战"/utf8>>;


get_produce_content(boss_first_blood) ->
<<"boss首杀"/utf8>>;


get_produce_content(guild_create_act_reward) ->
<<"勇者盟约奖励"/utf8>>;


get_produce_content(hi_points) ->
<<"嗨点活动"/utf8>>;


get_produce_content(eudemons_attack_hurt_step) ->
<<"幻兽入侵阶段伤害奖励"/utf8>>;


get_produce_content(eudemons_act_reward) ->
<<"幻兽入侵结算奖励"/utf8>>;


get_produce_content(fireworks_act) ->
<<"烟花活动"/utf8>>;


get_produce_content(buy_goods) ->
<<"购买物品"/utf8>>;


get_produce_content(lucky_turntable_rewards) ->
<<"幸运转盘抽中奖励"/utf8>>;


get_produce_content(version_upgradebag) ->
<<"领取版本礼包"/utf8>>;


get_produce_content(limit_shop_buy) ->
<<"神秘限购购买"/utf8>>;


get_produce_content(peak_treasure_hunt) ->
<<"巅峰寻宝"/utf8>>;


get_produce_content(extreme_treasure_hunt) ->
<<"至尊寻宝"/utf8>>;


get_produce_content(rune_treasure_hunt) ->
<<"符文寻宝"/utf8>>;


get_produce_content(treasure_evaluation) ->
<<"幸运鉴宝"/utf8>>;


get_produce_content(quick_buy) ->
<<"快速购买"/utf8>>;


get_produce_content(collect_put_s) ->
<<"提交收集活动物品累计奖励"/utf8>>;


get_produce_content(collect_put_n) ->
<<"提交收集活动物品普通奖励"/utf8>>;


get_produce_content(remove_equip_skill_return_cost) ->
<<"拆除唤魔技能返回材料"/utf8>>;


get_produce_content(diamond_league_guess_reward) ->
<<"星钻联赛竞猜奖励"/utf8>>;


get_produce_content(diamond_league_result) ->
<<"星钻联赛比赛奖励"/utf8>>;


get_produce_content(login_return_reward_buy) ->
<<"0元豪礼"/utf8>>;


get_produce_content(login_return_reward_return) ->
<<"0元豪礼返利"/utf8>>;


get_produce_content(kf_cloud_buy_rand_reward) ->
<<"跨服云购随机奖励"/utf8>>;


get_produce_content(kf_cloud_buy_return_cost) ->
<<"跨服云购失败返还"/utf8>>;


get_produce_content(kf_cloud_buy_draw_reward) ->
<<"跨服云购开奖"/utf8>>;


get_produce_content(overflow_gift_act) ->
<<"超值礼包活动"/utf8>>;


get_produce_content(spec_sell_act) ->
<<"精品特卖"/utf8>>;


get_produce_content(kf_3v3) ->
<<"跨服3v3结算"/utf8>>;


get_produce_content(shop_3v3) ->
<<"3v3商城"/utf8>>;


get_produce_content(kf_3v3_wincount) ->
<<"跨服3v3胜利N场奖励"/utf8>>;


get_produce_content(lucky_flop) ->
<<"幸运翻牌"/utf8>>;


get_produce_content(holy_ghost) ->
<<"圣灵"/utf8>>;


get_produce_content(kf_3v3_daily) ->
<<"3v3今日段位奖励"/utf8>>;


get_produce_content(mount_equip) ->
<<"坐骑装备"/utf8>>;


get_produce_content(guess_reward) ->
<<"竞猜奖励"/utf8>>;


get_produce_content(kf_1vn_race_2) ->
<<"跨服1vN挑战赛奖励"/utf8>>;


get_produce_content(kf_1vn_race_1_score_rank) ->
<<"跨服1vN海选赛积分排行奖励"/utf8>>;


get_produce_content(kf_1vn_auction_fail) ->
<<"1vn拍卖发生错误返还"/utf8>>;


get_produce_content(kf_gwar_daily_reward) ->
<<"跨服公会战日常奖励"/utf8>>;


get_produce_content(kf_gwar_donate_reward) ->
<<"跨服公会战捐赠奖励"/utf8>>;


get_produce_content(kf_gwar_stage_reward) ->
<<"跨服公会战阶段奖励"/utf8>>;


get_produce_content(declare_war_return) ->
<<"跨服公会战宣战失败返还"/utf8>>;


get_produce_content(cancel_declare_war) ->
<<"跨服公会战取消宣战"/utf8>>;


get_produce_content(daily_turntable) ->
<<"每日活跃转盘"/utf8>>;


get_produce_content(kf_gwar_return_gfunds_in_confirm) ->
<<"跨服公会战确认期宣战失败返还"/utf8>>;


get_produce_content(saint) ->
<<"圣者殿"/utf8>>;


get_produce_content(garden_product) ->
<<"庭院产出"/utf8>>;


get_produce_content(garden_wish) ->
<<"家园庭院许愿"/utf8>>;


get_produce_content(wish_daily_free) ->
<<"家园庭院许愿币每日领取"/utf8>>;


get_produce_content(guard_sweep_rewards) ->
<<"主线副本扫荡奖励"/utf8>>;


get_produce_content(onhook_reward) ->
<<"野外挂机奖励"/utf8>>;


get_produce_content(guard_boss_rewards) ->
<<"主线副本通关奖励"/utf8>>;


get_produce_content(guard_seal_reward) ->
<<"结界守护封印奖励"/utf8>>;


get_produce_content(vip_present) ->
<<"vip礼包"/utf8>>;


get_produce_content(vip_reward) ->
<<"vip等级礼包"/utf8>>;


get_produce_content(vip_weekly_reward) ->
<<"vip周礼包"/utf8>>;


get_produce_content(vip_card_award) ->
<<"vip特权激活奖励"/utf8>>;


get_produce_content(mon_pic) ->
<<"怪物图鉴"/utf8>>;


get_produce_content(role_donate) ->
<<"公会捐献"/utf8>>;


get_produce_content(get_activity_gift) ->
<<"公会活跃度礼包"/utf8>>;


get_produce_content(upgrade_fashion_pos) ->
<<"时装升级"/utf8>>;


get_produce_content(liveness_back) ->
<<"活跃度找回"/utf8>>;


get_produce_content(dungeon_extra_reward) ->
<<"副本额外奖励"/utf8>>;


get_produce_content(shop_diamond) ->
<<"钻石商城"/utf8>>;


get_produce_content(worship_reward) ->
<<"膜拜奖励"/utf8>>;


get_produce_content(onhook_offline_reward) ->
<<"离线挂机产出奖励"/utf8>>;


get_produce_content(seek_goods) ->
<<"商品求购"/utf8>>;


get_produce_content(sell_seek_goods) ->
<<"求购成功"/utf8>>;


get_produce_content(jjc_challenge_break_reward) ->
<<"竞技场突破奖励"/utf8>>;


get_produce_content(guild_feast_fire) ->
<<"公会篝火点击火苗奖励"/utf8>>;


get_produce_content(guild_feast_question) ->
<<"公会答题奖励"/utf8>>;


get_produce_content(world_boss_reward) ->
<<"世界boss奖励"/utf8>>;


get_produce_content(world_boss_killreward) ->
<<"世界boss最后一击奖励"/utf8>>;


get_produce_content(mystery_shop) ->
<<"神秘商店"/utf8>>;


get_produce_content(guild_battle) ->
<<"公会争霸"/utf8>>;


get_produce_content(guild_feast_boss) ->
<<"公会晚宴远古巨龙奖励"/utf8>>;


get_produce_content(role_nine) ->
<<"九魂圣殿产出"/utf8>>;


get_produce_content(guild_dun_challenge) ->
<<"公会挑战副本"/utf8>>;


get_produce_content(guild_score_gift) ->
<<"公会副本积分奖励"/utf8>>;


get_produce_content(treasure_score_shop) ->
<<"寻宝积分商城"/utf8>>;


get_produce_content(rush_rank) ->
<<"开服冲榜"/utf8>>;


get_produce_content(online_reward) ->
<<"在线奖励"/utf8>>;


get_produce_content(hire_act) ->
<<"神兵租借"/utf8>>;


get_produce_content(investment_buy) ->
<<"投资购买"/utf8>>;


get_produce_content(fashion_act) ->
<<"时装盛典"/utf8>>;


get_produce_content(invite_box) ->
<<"邀请宝箱"/utf8>>;


get_produce_content(invite_reward) ->
<<"邀请累计"/utf8>>;


get_produce_content(race_act) ->
<<"竞榜奖励"/utf8>>;


get_produce_content(phantom_boss) ->
<<"幻兽领"/utf8>>;


get_produce_content(custom_act_gwar) ->
<<"公会争霸活动"/utf8>>;


get_produce_content(invite_lv_reward_pos) ->
<<"邀请等级奖励位置"/utf8>>;


get_produce_content(invite_lv_reward_once) ->
<<"等级奖励一次性"/utf8>>;


get_produce_content(soul_dungeon_reward) ->
<<"聚魂本通关奖励"/utf8>>;


get_produce_content(enchantment_guard_stage_reward) ->
<<"主线副本阶段奖励"/utf8>>;


get_produce_content(invite_red_packet) ->
<<"邀请红包"/utf8>>;


get_produce_content(eudemons_boss) ->
<<"圣兽领"/utf8>>;


get_produce_content(shake) ->
<<"摇摇乐"/utf8>>;


get_produce_content(kf_1vn_bet) ->
<<"1vn竞猜"/utf8>>;


get_produce_content(exchange_act_new) ->
<<"节日兑换活动"/utf8>>;


get_produce_content(other_drop) ->
<<"额外掉落"/utf8>>;


get_produce_content(drumwar_sign) ->
<<"报名钻石大战"/utf8>>;


get_produce_content(drumwar) ->
<<"钻石大战"/utf8>>;


get_produce_content(boss_first_award) ->
<<"boss首次攻击"/utf8>>;


get_produce_content(count_gift) ->
<<"次数礼包"/utf8>>;


get_produce_content(bonus_tree) ->
<<"摇钱树活动"/utf8>>;


get_produce_content(feast_boss_box_reward) ->
<<"怪物攻城宝箱奖励"/utf8>>;


get_produce_content(change_pos) ->
<<"更改背包位置"/utf8>>;


get_produce_content(mon_invade) ->
<<"异兽入侵"/utf8>>;


get_produce_content(open_module) ->
<<"功能开启"/utf8>>;


get_produce_content(task_drop) ->
<<"任务掉落"/utf8>>;


get_produce_content(glad_challenge_reward) ->
<<"决斗场战斗奖励"/utf8>>;


get_produce_content(move_goods) ->
<<"物品转移"/utf8>>;


get_produce_content(glad_stage_reward) ->
<<"竞技场阶段奖励"/utf8>>;


get_produce_content(glad_rank_reward) ->
<<"竞技场排名奖励"/utf8>>;


get_produce_content(make_equip_suit) ->
<<"套装制造"/utf8>>;


get_produce_content(fairyland_boss_draw) ->
<<"秘境boss宝箱"/utf8>>;


get_produce_content(use_gift) ->
<<"使用礼包"/utf8>>;


get_produce_content(rush_shop) ->
<<"抢购商城"/utf8>>;


get_produce_content(top_pk_battle_honor) ->
<<"巅峰竞技战斗结果荣誉"/utf8>>;


get_produce_content(top_pk_season_reward) ->
<<"巅峰竞技赛季奖励"/utf8>>;


get_produce_content(love_gift) ->
<<"真爱礼包"/utf8>>;


get_produce_content(propose) ->
<<"求婚"/utf8>>;


get_produce_content(shop_glory) ->
<<"荣耀商城"/utf8>>;


get_produce_content(territory_hurt) ->
<<"领地夺宝伤害排名"/utf8>>;


get_produce_content(custom_act_liveness_commit) ->
<<"节日奖励提交"/utf8>>;


get_produce_content(custom_act_liveness) ->
<<"节日奖励领取"/utf8>>;


get_produce_content(task_func_drop) ->
<<"功能任务掉落"/utf8>>;


get_produce_content(sanctuary_kill_reward) ->
<<"圣域击杀固定奖励"/utf8>>;


get_produce_content(task_stage_func_drop) ->
<<"任务功能阶段掉落"/utf8>>;


get_produce_content(cloud_buy_stage) ->
<<"云购阶段奖励"/utf8>>;


get_produce_content(shop_seal) ->
<<"领地商城"/utf8>>;


get_produce_content(kf_sanctuary_hurt_rank) ->
<<"伤害排名"/utf8>>;


get_produce_content(kf_sanctuary_con_bl) ->
<<"跨服圣域建筑归属"/utf8>>;


get_produce_content(kf_sanctuary_score) ->
<<"跨服圣域积分奖励"/utf8>>;


get_produce_content(custom_act_mount_turntable) ->
<<"定制活动54坐骑转盘"/utf8>>;


get_produce_content(combine_stone) ->
<<"宝石合成"/utf8>>;


get_produce_content(shop_medal) ->
<<"勋章商城"/utf8>>;


get_produce_content(summon_card_reward) ->
<<"公会晚宴召唤卡"/utf8>>;


get_produce_content(draw_reward_special) ->
<<"赛博夺宝"/utf8>>;


get_produce_content(midday_party) ->
<<"午间派对产出"/utf8>>;


get_produce_content(feast_shop) ->
<<"节日抢购商城"/utf8>>;


get_produce_content(monday_draw) ->
<<"周一大奖"/utf8>>;


get_produce_content(guild_quiz_rank_reward) ->
<<"公会晚宴答题奖励"/utf8>>;


get_produce_content(kf_3v3_battle_reward) ->
<<"跨服3v3战斗胜利奖励"/utf8>>;


get_produce_content(surprise_gift) ->
<<"惊喜礼包"/utf8>>;


get_produce_content(luckey_egg) ->
<<"惊喜扭蛋"/utf8>>;


get_produce_content(compensate_exp) ->
<<"离线挂机"/utf8>>;


get_produce_content(dungeon_wave_stage) ->
<<"龙纹副本波数奖励"/utf8>>;


get_produce_content(shop_figure) ->
<<"外形商城"/utf8>>;


get_produce_content(dragon_decompose) ->
<<"龙纹分解"/utf8>>;


get_produce_content(dragon_down_pos_lv) ->
<<"龙纹槽位降级"/utf8>>;


get_produce_content(dragon_beckon) ->
<<"龙纹熔炉"/utf8>>;


get_produce_content(god_active) ->
<<"降神激活"/utf8>>;


get_produce_content(sanctuary_belong_reward) ->
<<"圣域归属奖励"/utf8>>;


get_produce_content(sanctuary_participant_reward) ->
<<"参与奖励"/utf8>>;


get_produce_content(god_lv_update) ->
<<"降神升级"/utf8>>;


get_produce_content(god_stage) ->
<<"降神升阶"/utf8>>;


get_produce_content(praise_baby) ->
<<"点赞宝宝"/utf8>>;


get_produce_content(level_act_shop) ->
<<"等级抢购商城"/utf8>>;


get_produce_content(dun_dragon_jump_wave_reward) ->
<<"龙纹本跳关奖励"/utf8>>;


get_produce_content(boss_domain) ->
<<"秘境领域boss"/utf8>>;


get_produce_content(fest_investment) ->
<<"节日投资"/utf8>>;


get_produce_content(adventure_throw) ->
<<"天天冒险投骰子"/utf8>>;


get_produce_content(adventure_reset) ->
<<"天天冒险重置骰子"/utf8>>;


get_produce_content(festival_recharge_reward) ->
<<"节日首冲奖励"/utf8>>;


get_produce_content(baby_treasure_hunt) ->
<<"宝宝寻宝"/utf8>>;


get_produce_content(soul_dun_stage_reward) ->
<<"聚魂本阶段奖励"/utf8>>;


get_produce_content(adven_shop) ->
<<"冒险商城"/utf8>>;


get_produce_content(holy_summon_draw) ->
<<"神圣召唤抽奖"/utf8>>;


get_produce_content(holy_stage_reward) ->
<<"神圣召唤阶段奖励"/utf8>>;


get_produce_content(rush_buy) ->
<<"精彩活动之抢购"/utf8>>;


get_produce_content(demons_painting) ->
<<"使魔上卷"/utf8>>;


get_produce_content(revelation_equip_swallow) ->
<<"天启装备吞噬"/utf8>>;


get_produce_content(dragon_count_award) ->
<<"龙纹熔炉召唤奖励"/utf8>>;


get_produce_content(vip_gift_buy) ->
<<"vip特惠礼包"/utf8>>;


get_produce_content(soul_dismantle_awake) ->
<<"聚魂拆解觉醒"/utf8>>;


get_produce_content(custom_act_pray) ->
<<"神佑祈愿"/utf8>>;


get_produce_content(luckey_egg_cumulate_reward) ->
<<"惊喜扭蛋累积奖励"/utf8>>;


get_produce_content(recharge_one_reward) ->
<<"一元礼包"/utf8>>;


get_produce_content(demons_shop) ->
<<"使魔商店"/utf8>>;


get_produce_content(shop_supvip) ->
<<"至尊vip商城"/utf8>>;


get_produce_content(eudemons_boss_score) ->
<<"圣兽领积分奖励"/utf8>>;


get_produce_content(supvip_return_currency) ->
<<"至尊vip充值返还"/utf8>>;


get_produce_content(supvip_currency_task) ->
<<"至尊币任务"/utf8>>;


get_produce_content(supvip_skill_task) ->
<<"至尊vip技能任务"/utf8>>;


get_produce_content(supvip_right_reward) ->
<<"至尊vip特权奖励"/utf8>>;


get_produce_content(select_pool_draw) ->
<<"自选奖池抽奖奖励"/utf8>>;


get_produce_content(select_stage_reward) ->
<<"自选奖池阶段奖励"/utf8>>;


get_produce_content(shop_eudemons) ->
<<"圣兽商店"/utf8>>;


get_produce_content(guess_3v3_reward) ->
<<"3v3竞猜产出"/utf8>>;


get_produce_content(rune_dismantle_awake) ->
<<"符文拆解"/utf8>>;


get_produce_content(level_act_help_gift) ->
<<"助力礼包"/utf8>>;


get_produce_content(pic_decompose) ->
<<"分解怪物图鉴所得怪物碎片"/utf8>>;


get_produce_content(decoration_boss_assist) ->
<<"怨灵封印协助"/utf8>>;


get_produce_content(decoration_boss_join) ->
<<"怨灵封印参与"/utf8>>;


get_produce_content(decoration_boss_bl) ->
<<"怨灵封印归属"/utf8>>;


get_produce_content(decoration_sboss_join) ->
<<"怨灵封印特殊大妖参与"/utf8>>;


get_produce_content(decoration_sboss_bl) ->
<<"怨灵封印特殊大妖归属"/utf8>>;


get_produce_content(treasure_map) ->
<<"藏宝图抽奖"/utf8>>;


get_produce_content(bonus_pool) ->
<<"许愿池"/utf8>>;


get_produce_content(terri_war) ->
<<"领地战"/utf8>>;


get_produce_content(gboss) ->
<<"公会boss"/utf8>>;


get_produce_content(dungeon_count_drop) ->
<<"副本多次数掉落"/utf8>>;


get_produce_content(kf_rank_dungeon) ->
<<"试炼副本"/utf8>>;


get_produce_content(shop_rdungeon) ->
<<"试炼商店"/utf8>>;


get_produce_content(week_dungeon) ->
<<"周常副本"/utf8>>;


get_produce_content(luckey_wheel) ->
<<"幸运抽奖"/utf8>>;


get_produce_content(activation_draw) ->
<<"活跃转盘"/utf8>>;


get_produce_content(activation_reward) ->
<<"活跃度奖励"/utf8>>;


get_produce_content(recharge_draw) ->
<<"充值转盘"/utf8>>;


get_produce_content(recharge_reward) ->
<<"充值转盘阶段"/utf8>>;


get_produce_content(spirit_rotary) ->
<<"精灵转盘"/utf8>>;


get_produce_content(envelopes_rain) ->
<<"红包雨"/utf8>>;


get_produce_content(wx_share) ->
<<"微信分享"/utf8>>;


get_produce_content(boss_rotary) ->
<<"boss转盘"/utf8>>;


get_produce_content(shop_draconic) ->
<<"龙语商城"/utf8>>;


get_produce_content(guild_daily) ->
<<"公会宝箱"/utf8>>;


get_produce_content(holy_spirit_battlefield_exp) ->
<<"圣灵战场经验"/utf8>>;


get_produce_content(holy_spirit_battlefield_point_reward) ->
<<"圣灵战场个人积分奖励"/utf8>>;


get_produce_content(holy_spirit_battlefield_reward) ->
<<"圣灵战场阵营奖励"/utf8>>;


get_produce_content(kf_cloud_buy) ->
<<"跨服云购"/utf8>>;


get_produce_content(kf_group_buy) ->
<<"跨服团购"/utf8>>;


get_produce_content(fortune_cat_rewards) ->
<<"招财猫转盘奖励"/utf8>>;


get_produce_content(bonus_tree_shop) ->
<<"许愿树商城"/utf8>>;


get_produce_content(shop_lucky) ->
<<"幸运商店"/utf8>>;


get_produce_content(arcana_reset) ->
<<"远古奥术重置"/utf8>>;


get_produce_content(real_info) ->
<<"信息验证奖励"/utf8>>;


get_produce_content(contract_challenge) ->
<<"契约挑战奖励"/utf8>>;


get_produce_content(god_house_crytal) ->
<<"神之所水晶"/utf8>>;


get_produce_content(day_chrono_rift_reward) ->
<<"时空圣痕每日奖励"/utf8>>;


get_produce_content(chrono_rift_goal_reward) ->
<<"时空圣痕任务奖励"/utf8>>;


get_produce_content(escort_reward) ->
<<"矿石护送"/utf8>>;


get_produce_content(shop_god_court) ->
<<"神庭商城"/utf8>>;


get_produce_content(shop_prestige) ->
<<"声望商店"/utf8>>;


get_produce_content(wx_collect) ->
<<"微信收藏"/utf8>>;


get_produce_content(guild_assist) ->
<<"公会协助"/utf8>>;


get_produce_content(star_trek_rewards) ->
<<"星际旅行登船奖励"/utf8>>;


get_produce_content(seacraft_reward) ->
<<"怒海争霸"/utf8>>;


get_produce_content(afk_trigger) ->
<<"挂机收益"/utf8>>;


get_produce_content(afk_off) ->
<<"挂机离线获得"/utf8>>;


get_produce_content(unequip_stone) ->
<<"卸下宝石"/utf8>>;


get_produce_content(first_blood_plus_boss) ->
<<"新boss首杀"/utf8>>;


get_produce_content(dun_partner_stage_reward) ->
<<"伙伴副本阶段奖励"/utf8>>;


get_produce_content(dun_partner_sweep_reward) ->
<<"伙伴副本扫荡奖励"/utf8>>;


get_produce_content(first_blood_plus_dun) ->
<<"副本首杀奖励"/utf8>>;


get_produce_content(special_gift_act) ->
<<"超值特惠礼包"/utf8>>;


get_produce_content(destiny_turnable) ->
<<"天命转盘奖励"/utf8>>;


get_produce_content(custom_act_treasure_task) ->
<<"幸运寻宝"/utf8>>;


get_produce_content(custom_treasure) ->
<<"幸运鉴宝"/utf8>>;


get_produce_content(up_power_rank_stage_reward) ->
<<"战力升榜阶段奖励"/utf8>>;


get_produce_content(guild_act_buy_food) ->
<<"购买公会晚宴菜肴奖励"/utf8>>;


get_produce_content(err402_yet_buy_food) ->
<<"公会晚宴购买菜肴奖励"/utf8>>;


get_produce_content(common_draw) ->
<<"契灵扭蛋产出"/utf8>>;


get_produce_content(rank_power_gift) ->
<<"助力礼包"/utf8>>;


get_produce_content(first_pass_rune_dun) ->
<<"首通符文本"/utf8>>;


get_produce_content(pass_rune_dun) ->
<<"通关符文本个人奖励"/utf8>>;


get_produce_content(dungeon_reward) ->
<<"副本通用奖励"/utf8>>;


get_produce_content(sea_rob_reward) ->
<<"璀璨之星掠夺"/utf8>>;


get_produce_content(sea_rob_back_reward) ->
<<"璀璨之星复仇"/utf8>>;


get_produce_content(sea_rback_reward) ->
<<"璀璨之星夺回奖励"/utf8>>;


get_produce_content(sea_treasure_reward) ->
<<"璀璨之星巡航"/utf8>>;


get_produce_content(fin_task_cost) ->
<<"任务完成消耗"/utf8>>;


get_produce_content(temple_awake_chapter) ->
<<"神殿觉醒章节奖励"/utf8>>;


get_produce_content(temple_awake_chapter_stage) ->
<<"神殿觉醒子章节阶段任务奖励"/utf8>>;


get_produce_content(buy_push_gift) ->
<<"推送礼包"/utf8>>;


get_produce_content(exchange_onhook_coin) ->
<<"托管币兑换"/utf8>>;


get_produce_content(shop_zen_soul) ->
<<"战魂商城"/utf8>>;


get_produce_content(ql_draw) ->
<<"契灵抽奖"/utf8>>;


get_produce_content(sea_craft_daily_defend_reward) ->
<<"海战日常守卫奖励"/utf8>>;


get_produce_content(sea_craft_daily_kill_reward) ->
<<"海域日常杀人奖励"/utf8>>;


get_produce_content(sea_craft_carry_brick_reward) ->
<<"海域日常板砖奖励"/utf8>>;


get_produce_content(sea_craft_daily_task_reward) ->
<<"海域日常任务奖励"/utf8>>;


get_produce_content(new_player_gift) ->
<<"新手礼包"/utf8>>;


get_produce_content(lv_block) ->
<<"等级弹窗奖励"/utf8>>;


get_produce_content(advertisement_reward) ->
<<"广告奖励"/utf8>>;


get_produce_content(fiesta) ->
<<"祭典"/utf8>>;


get_produce_content(first_challenge_vip_boss) ->
<<"首次挑战VIP个人BOSS"/utf8>>;


get_produce_content(rune_dun_daily_reward) ->
<<"符文本每日奖励"/utf8>>;


get_produce_content(rush_special_package) ->
<<"冲榜特惠礼包"/utf8>>;


get_produce_content(rush_to_buy) ->
<<"冲榜抢购"/utf8>>;


get_produce_content(custom_act_daily_direct_buy) ->
<<"每日直购活动奖励"/utf8>>;


get_produce_content(combat_welfare_reward) ->
<<"战力福利抽奖奖励"/utf8>>;


get_produce_content(grow_welfare) ->
<<"成长福利奖励"/utf8>>;


get_produce_content(rush_treasure) ->
<<"冲榜夺宝"/utf8>>;


get_produce_content(activitycalen) ->
<<"活动日历"/utf8>>;


get_produce_content(envelope_rebate) ->
<<"红包返利"/utf8>>;


get_produce_content(limit_tower_big_reward) ->
<<"限时爬塔关卡大奖"/utf8>>;


get_produce_content(custom_the_carnival) ->
<<"全民狂欢奖励"/utf8>>;


get_produce_content(weekly_card) ->
<<"周卡"/utf8>>;


get_produce_content(cycle_rank_reach_reward) ->
<<"循环冲榜达标目标奖励"/utf8>>;


get_produce_content(one_click_sweep_reward) ->
<<"一键扫荡奖励(资源副本)"/utf8>>;


get_produce_content(one_click_gage_reward) ->
<<"一键挑战奖励(资源副本)"/utf8>>;


get_produce_content(custom_act_sale) ->
<<"超值礼包"/utf8>>;


get_produce_content(custom_act_recharge_polite) ->
<<"累充有礼奖励"/utf8>>;


get_produce_content(shop_night_ghost) ->
<<"百鬼夜行商城"/utf8>>;


get_produce_content(first_day_benefits) ->
<<"首日福利奖励"/utf8>>;


get_produce_content(night_ghost) ->
<<"百鬼夜行"/utf8>>;


get_produce_content(cycle_rank_accumulated) ->
<<"循环冲榜累计充值活动奖励"/utf8>>;


get_produce_content(cycle_rank_single_recharge) ->
<<"循环冲榜单笔充值活动奖励"/utf8>>;


get_produce_content(week_overview) ->
<<"节日活动总览"/utf8>>;


get_produce_content(act_wish_draw) ->
<<"绑玉祈愿"/utf8>>;


get_produce_content(custom_act_figure_buy) ->
<<"幻形直购"/utf8>>;


get_produce_content(sanctuary_kill_player_reward) ->
<<"跨服圣域击杀玩家奖励"/utf8>>;


get_produce_content(companion_biog) ->
<<"伙伴传记"/utf8>>;


get_produce_content(pool_gift) ->
<<"奖池礼包"/utf8>>;


get_produce_content(hero_halo_reward) ->
<<"主角光环"/utf8>>;


get_produce_content(star_nuclear_buy) ->
<<"星核直购"/utf8>>;

get_produce_content(_Type) ->
	"".


get_consume(unkown) ->
0;


get_consume(goods_use) ->
1;


get_consume(equip_wash) ->
2;


get_consume(equip_stren) ->
3;


get_consume(stren_break) ->
4;


get_consume(offline_exp) ->
5;


get_consume(shop_normal) ->
6;


get_consume(goods_compose) ->
7;


get_consume(change_name) ->
8;


get_consume(open_lv_gift) ->
10;


get_consume(create_guild) ->
11;


get_consume(mount_add_exp_cost) ->
12;


get_consume(send_flower) ->
13;


get_consume(enabled_dress) ->
14;


get_consume(awakening) ->
15;


get_consume(extend_bag) ->
16;


get_consume(modify_announce) ->
17;


get_consume(revive) ->
18;


get_consume(red_name_be_kill) ->
19;


get_consume(gskill_research_cost) ->
20;


get_consume(gskill_learn_cost) ->
21;


get_consume(mount_upgrade_star) ->
22;


get_consume(pet_upgrade_star) ->
23;


get_consume(pet_upgrade_lv) ->
24;


get_consume(goods_decompose) ->
25;


get_consume(equip_upgrade_stage) ->
26;


get_consume(depot_donate) ->
27;


get_consume(equip_unlock_wash_pos) ->
28;


get_consume(dungeon_enter_cost) ->
29;


get_consume(dungeon_count_buy_cost) ->
30;


get_consume(equip_upgrade_division) ->
31;


get_consume(dungeon_count_sweep_cost) ->
32;


get_consume(juewei) ->
33;


get_consume(equip_stone_refine) ->
34;


get_consume(goods_renew) ->
35;


get_consume(fashion_active) ->
36;


get_consume(mount_active_figure) ->
37;


get_consume(fly_shoes) ->
38;


get_consume(pet_active_figure) ->
39;


get_consume(mount_figure_upgrade_stage) ->
40;


get_consume(pet_figure_upgrade_stage) ->
41;


get_consume(fashion_color) ->
42;


get_consume(fashion_star) ->
43;


get_consume(make_equip_suit) ->
44;


get_consume(dungeon_encourage) ->
45;


get_consume(shop_week) ->
46;


get_consume(shop_bgold) ->
47;


get_consume(shop_fashion) ->
48;


get_consume(wing_active_figure) ->
49;


get_consume(wing_upgrade_lv) ->
50;


get_consume(wing_upgrade_star) ->
51;


get_consume(talent_skill_reset) ->
52;


get_consume(boss_home) ->
53;


get_consume(boss_forbidden) ->
54;


get_consume(fashion_resolve) ->
55;


get_consume(gboss_mat_turn_in) ->
56;


get_consume(vip_turn_on) ->
57;


get_consume(vip_renew) ->
58;


get_consume(finish_task) ->
59;


get_consume(wing_use_feather) ->
60;


get_consume(personals_send) ->
61;


get_consume(artifact_enchant) ->
62;


get_consume(ring_polish) ->
63;


get_consume(ring_pray) ->
64;


get_consume(eudemons_double_strength_cost) ->
66;


get_consume(eudemons_strength_material) ->
67;


get_consume(sell_up) ->
68;


get_consume(talisman_active_figure) ->
69;


get_consume(talisman_upgrade_lv) ->
70;


get_consume(talisman_upgrade_star) ->
71;


get_consume(talisman_use_feather) ->
72;


get_consume(godweapon_active_figure) ->
73;


get_consume(godweapon_upgrade_lv) ->
74;


get_consume(godweapon_upgrade_star) ->
75;


get_consume(godweapon_use_feather) ->
76;


get_consume(propose) ->
77;


get_consume(break_up) ->
78;


get_consume(divorce) ->
79;


get_consume(eudemons_buy_fight_location) ->
80;


get_consume(jjc_buy_num) ->
81;


get_consume(shop_honour) ->
82;


get_consume(finish_daily_task) ->
83;


get_consume(finish_guild_task) ->
84;


get_consume(show_love) ->
85;


get_consume(send_goods_red_envelopes) ->
86;


get_consume(top_pk_buy_cost) ->
87;


get_consume(pay_sell) ->
88;


get_consume(wedding_order) ->
89;


get_consume(wedding_buy_guest_max) ->
90;


get_consume(wedding_fires) ->
91;


get_consume(wedding_candies) ->
92;


get_consume(treasure_hunt) ->
93;


get_consume(investment_buy) ->
94;


get_consume(goods_exchange) ->
95;


get_consume(baby_aptitude) ->
96;


get_consume(baby_active) ->
97;


get_consume(baby_knowledge_pray) ->
98;


get_consume(baby_image_active) ->
99;


get_consume(baby_image_pray) ->
100;


get_consume(pray) ->
101;


get_consume(use_gift) ->
102;


get_consume(holy_seal_strength) ->
103;


get_consume(holy_seal_soul) ->
104;


get_consume(equip_casting_spirit) ->
105;


get_consume(equip_upgrade_spirit) ->
106;


get_consume(red_envelopes) ->
107;


get_consume(resource_back) ->
108;


get_consume(husong_reflesh) ->
109;


get_consume(retro_checkin) ->
110;


get_consume(upgrade_dress) ->
111;


get_consume(upgrade_illu) ->
112;


get_consume(col_world_act) ->
113;


get_consume(jjc_inspire) ->
114;


get_consume(equip_awakening) ->
115;


get_consume(guild_rename) ->
116;


get_consume(artifact_active) ->
117;


get_consume(artifact_upgrade) ->
118;


get_consume(marriage_life_train) ->
119;


get_consume(shop_bglod) ->
120;


get_consume(goods_timeout) ->
121;


get_consume(chat) ->
122;


get_consume(upgrade_guild) ->
123;


get_consume(limit_buy) ->
124;


get_consume(smashed_egg) ->
125;


get_consume(smashed_egg_refresh) ->
126;


get_consume(cloud_buy) ->
127;


get_consume(exchange_act) ->
128;


get_consume(red_name_cost) ->
129;


get_consume(redemption_exp) ->
130;


get_consume(buy_gift_times) ->
131;


get_consume(eudemons_attack_encourage) ->
132;


get_consume(fireworks_act) ->
133;


get_consume(buy_goods) ->
134;


get_consume(star_active) ->
135;


get_consume(limit_shop_buy) ->
136;


get_consume(peak_treasure_hunt) ->
137;


get_consume(extreme_treasure_hunt) ->
138;


get_consume(rune_treasure_hunt) ->
139;


get_consume(transfer) ->
140;


get_consume(pay_tax) ->
141;


get_consume(treasure_evaluation) ->
142;


get_consume(quick_buy) ->
143;


get_consume(advance_payment) ->
144;


get_consume(propose_answer_aa) ->
145;


get_consume(dungeon_slown_mons) ->
146;


get_consume(diamond_league_apply_cost) ->
147;


get_consume(boss_temple) ->
148;


get_consume(collect_put) ->
149;


get_consume(add_equip_skill) ->
150;


get_consume(remove_equip_skill) ->
151;


get_consume(upgrade_equip_skill) ->
152;


get_consume(aircraft_active) ->
153;


get_consume(aircraft_stage) ->
154;


get_consume(diamond_league_buy_life) ->
155;


get_consume(diamond_league_guess) ->
156;


get_consume(login_return_reward_buy) ->
157;


get_consume(diamond_league_skill) ->
158;


get_consume(kf_cloud_buy) ->
159;


get_consume(overflow_gift_act) ->
160;


get_consume(spec_sell_act) ->
161;


get_consume(kf_hegemony_sign_up) ->
162;


get_consume(buy_house) ->
163;


get_consume(buy_house_aa) ->
164;


get_consume(answer_buy_house_aa) ->
165;


get_consume(upgrade_house) ->
166;


get_consume(upgrade_house_aa) ->
167;


get_consume(auto_buy_goods) ->
168;


get_consume(lucky_flop_refresh) ->
169;


get_consume(lucky_flop_cost) ->
170;


get_consume(holy_ghost) ->
171;


get_consume(kf_temple_ticket) ->
172;


get_consume(shop_3v3) ->
173;


get_consume(kf_temple_energy) ->
174;


get_consume(guess) ->
175;


get_consume(mount_equip) ->
176;


get_consume(saint_inspire) ->
178;


get_consume(house_send_gift) ->
180;


get_consume(kf_1vn_auction) ->
181;


get_consume(kf_gwar_donate) ->
182;


get_consume(kf_1vn_bet) ->
183;


get_consume(sky_soul_active) ->
184;


get_consume(sky_soul_lv) ->
185;


get_consume(sky_soul_stage) ->
186;


get_consume(sky_soul_attach) ->
187;


get_consume(pet_wing_active) ->
188;


get_consume(pet_wing_stage) ->
189;


get_consume(pet_wing_add_time) ->
190;


get_consume(pet_equip_upgrade_pos) ->
191;


get_consume(pet_equip_polish) ->
192;


get_consume(kf_gwar_exchange_props) ->
193;


get_consume(daily_turntable) ->
194;


get_consume(upgrade_garden) ->
195;


get_consume(upgrade_garden_aa) ->
196;


get_consume(garden_product) ->
197;


get_consume(product_cost_time) ->
198;


get_consume(garden_wish) ->
199;


get_consume(skill) ->
200;


get_consume(guard_sweep_cost) ->
201;


get_consume(guard_seal_cost) ->
202;


get_consume(equip_refine) ->
203;


get_consume(medal_upgrade_lv) ->
204;


get_consume(designation_upgrade_order) ->
205;


get_consume(designation_active) ->
206;


get_consume(vip_present) ->
207;


get_consume(buy_vip) ->
208;


get_consume(mon_pic) ->
209;


get_consume(role_donate) ->
210;


get_consume(get_activity_gift) ->
211;


get_consume(upgrade_fashion_pos) ->
212;


get_consume(liveness_back) ->
213;


get_consume(mystery_shop) ->
214;


get_consume(seek_goods) ->
215;


get_consume(sell_seek_goods) ->
216;


get_consume(dragon_spirit) ->
217;


get_consume(worldboss_encourage) ->
218;


get_consume(guild_battle) ->
219;


get_consume(guild_dun_challenge) ->
220;


get_consume(guild_score_gift) ->
221;


get_consume(treasure_score_shop) ->
222;


get_consume(hire_act) ->
223;


get_consume(fashion_act) ->
224;


get_consume(race_act) ->
225;


get_consume(shop_diamond) ->
226;


get_consume(shop_figure) ->
227;


get_consume(shop_life) ->
228;


get_consume(soul_dungeon_create_boss) ->
229;


get_consume(magic_circle_cost) ->
230;


get_consume(skill_stren) ->
231;


get_consume(eudemons_boss) ->
232;


get_consume(shake) ->
233;


get_consume(exchange_act_new) ->
234;


get_consume(achv_up_stage) ->
235;


get_consume(fairy_activation) ->
236;


get_consume(fairy_stage_up) ->
237;


get_consume(fairy_level_up) ->
238;


get_consume(bonus_tree) ->
239;


get_consume(drumwar_sign) ->
240;


get_consume(drumwar) ->
241;


get_consume(dec_level_up) ->
242;


get_consume(count_gift) ->
243;


get_consume(drumwar_live) ->
244;


get_consume(secret_up_star) ->
245;


get_consume(secret_up_lv) ->
246;


get_consume(secret_sp_wash) ->
247;


get_consume(secret_cm_wash) ->
248;


get_consume(secret_enchant) ->
249;


get_consume(goods_fusion) ->
250;


get_consume(boss_result) ->
251;


get_consume(boss_abyss) ->
252;


get_consume(boss_outside) ->
253;


get_consume(attr_medicament) ->
254;


get_consume(arbitrament) ->
255;


get_consume(glad_buy_num) ->
256;


get_consume(move_goods) ->
257;


get_consume(fairyland_boss_draw) ->
258;


get_consume(rush_shop) ->
259;


get_consume(task_stuff) ->
260;


get_consume(dress_up) ->
261;


get_consume(limit_gift_cost) ->
262;


get_consume(love_gift) ->
263;


get_consume(onhook_redemption_exp) ->
264;


get_consume(shop_glory) ->
265;


get_consume(husong) ->
266;


get_consume(seal_stren ) ->
267;


get_consume(custom_act_liveness_commit) ->
268;


get_consume(seal_pill) ->
269;


get_consume(sanctuary_clear_medal) ->
270;


get_consume(shop_seal) ->
271;


get_consume(kf_sanctuary_satge) ->
272;


get_consume(custom_act_mount_turntable) ->
273;


get_consume(shop_medal) ->
274;


get_consume(dragon_summon) ->
275;


get_consume(draw_reward_special) ->
276;


get_consume(feast_shop) ->
277;


get_consume(combine_stone) ->
278;


get_consume(monday_draw) ->
279;


get_consume(ring_unlock) ->
280;


get_consume(surprise_gift) ->
281;


get_consume(kf_3v3_season_end) ->
282;


get_consume(luckey_egg) ->
283;


get_consume(dec_stage_up) ->
284;


get_consume(dragon_decompose) ->
285;


get_consume(dragon_up_lv) ->
286;


get_consume(baby_unlock) ->
287;


get_consume(upgrade_equip) ->
288;


get_consume(engrave_equip) ->
289;


get_consume(active_figure) ->
290;


get_consume(baby_name) ->
291;


get_consume(add_devour) ->
292;


get_consume(dragon_beckon) ->
293;


get_consume(dragon_up_pos_lv) ->
294;


get_consume(mount_figure_star) ->
295;


get_consume(god_active) ->
296;


get_consume(god_lv_update) ->
297;


get_consume(baby_stage_up) ->
298;


get_consume(god_equip_strength) ->
299;


get_consume(level_act_shop) ->
300;


get_consume(fest_investment) ->
301;


get_consume(boss_domain) ->
302;


get_consume(adventure_throw) ->
303;


get_consume(adventure_reset) ->
304;


get_consume(baby_treasure_hunt) ->
305;


get_consume(god_equip_compose) ->
306;


get_consume(adven_shop) ->
307;


get_consume(holy_summon_draw_reward) ->
308;


get_consume(rush_buy) ->
309;


get_consume(active_demons) ->
310;


get_consume(upgrade_demons) ->
311;


get_consume(vip_gift_buy) ->
312;


get_consume(upgrade_demons_skill) ->
313;


get_consume(revelation_equip_swallow) ->
314;


get_consume(buy_vip_up) ->
315;


get_consume(soul_awake) ->
316;


get_consume(soul_dismantle_awake) ->
317;


get_consume(custom_act_pray) ->
318;


get_consume(create_3v3_team) ->
319;


get_consume(demons_slot_skill) ->
320;


get_consume(demons_shop) ->
321;


get_consume(demons_shop_refresh) ->
322;


get_consume(medal_clear) ->
323;


get_consume(god) ->
324;


get_consume(shop_supvip) ->
325;


get_consume(shop_eudemons) ->
326;


get_consume(change_name_cost) ->
327;


get_consume(supvip_buy_forever) ->
328;


get_consume(supvip_buy_ex) ->
329;


get_consume(select_pool_rest) ->
330;


get_consume(select_pool_draw) ->
331;


get_consume(supvip_clear_currency) ->
332;


get_consume(guess_3v3_cost) ->
333;


get_consume(pay_auction) ->
334;


get_consume(rune_dismantle_awake) ->
335;


get_consume(level_act_help_gift) ->
336;


get_consume(treasure_map) ->
337;


get_consume(bonus_pool) ->
338;


get_consume(title_upgrade_star) ->
339;


get_consume(shop_rdungeon) ->
340;


get_consume(enter_dragon_boss) ->
341;


get_consume(draconic_stren) ->
342;


get_consume(dragon_language_boss_count) ->
343;


get_consume(luckey_wheel) ->
344;


get_consume(back_decoration_active) ->
345;


get_consume(back_decoration_upgrade_stage) ->
346;


get_consume(activation_draw) ->
347;


get_consume(recharge_draw) ->
348;


get_consume(spirit_rotary) ->
349;


get_consume(boss_rotary) ->
350;


get_consume(arcana_lv) ->
351;


get_consume(arcana_break_lv) ->
352;


get_consume(boss_cost_reborn) ->
353;


get_consume(shop_draconic) ->
354;


get_consume(decoration_boss_buy) ->
355;


get_consume(constellation_compose) ->
356;


get_consume(constellation_attr) ->
357;


get_consume(constellation_decompose) ->
358;


get_consume(constellation_forge) ->
359;


get_consume(cost_fortune_goods) ->
360;


get_consume(kf_group_buy) ->
361;


get_consume(bonus_tree_shop) ->
362;


get_consume(shop_lucky) ->
363;


get_consume(arcana_reset) ->
364;


get_consume(god_court) ->
365;


get_consume(god_house_crytal) ->
366;


get_consume(escort_cost) ->
367;


get_consume(shop_god_court) ->
368;


get_consume(shop_prestige) ->
370;


get_consume(guild_god_upgrade_color) ->
371;


get_consume(guild_god_upgrade_awake_lv) ->
372;


get_consume(cost_star_trek) ->
373;


get_consume(guild_god_rune_upgrade) ->
374;


get_consume(mount_upgrade_stage) ->
375;


get_consume(mount_figure_color) ->
376;


get_consume(afk_back) ->
377;


get_consume(equip_stone) ->
378;


get_consume(dun_partner_sweep_cost) ->
379;


get_consume(vip_lv_reward_cost) ->
380;


get_consume(special_gift_act) ->
381;


get_consume(guild_act_buy_food) ->
382;


get_consume(custom_treasure) ->
383;


get_consume(companion_upgrade) ->
384;


get_consume(companion_train) ->
385;


get_consume(companion_active) ->
386;


get_consume(common_draw) ->
387;


get_consume(sea_shipping_up_level) ->
388;


get_consume(buy_push_gift) ->
389;


get_consume(fin_task_cost) ->
390;


get_consume(shop_zen_soul) ->
391;


get_consume(ql_draw) ->
392;


get_consume(dragon_ball) ->
393;


get_consume(equip_refinement) ->
394;


get_consume(god_stren) ->
395;


get_consume(sea_daily_up_brick) ->
396;


get_consume(gm_cost) ->
397;


get_consume(make_armour) ->
398;


get_consume(fiesta) ->
399;


get_consume(rush_special_package) ->
400;


get_consume(rush_to_buy) ->
401;


get_consume(mount_upgrade_cost) ->
402;


get_consume(buy_gift) ->
403;


get_consume(active_enchantment_soap) ->
404;


get_consume(one_click_sweep_cost) ->
405;


get_consume(shop_night_ghost) ->
406;


get_consume(custom_act_sale) ->
407;


get_consume(find_back_vit) ->
408;


get_consume(rush_treasure) ->
409;


get_consume(act_wish_draw) ->
410;


get_consume(custom_act_figure_buy) ->
411;


get_consume(buy_one_gift) ->
412;


get_consume(fashion_suit_upgrade) ->
413;


get_consume(kf_great_demon_boss) ->
414;

get_consume(_Type) ->
	0.

