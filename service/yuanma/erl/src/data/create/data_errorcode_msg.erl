%%%---------------------------------------
%%% module      : data_errorcode_msg
%%% description : 错误码描述配置
%%%
%%%---------------------------------------
-module(data_errorcode_msg).
-compile(export_all).
-include("common.hrl").



get(0) ->
	#errorcode_msg{type = fail,about = <<"失败"/utf8>>};

get(1) ->
	#errorcode_msg{type = success,about = <<"成功"/utf8>>};

get(2) ->
	#errorcode_msg{type = empty_error,about = <<""/utf8>>};

get(1001) ->
	#errorcode_msg{type = gold_not_enough,about = <<"您的勾玉余额不足"/utf8>>};

get(1002) ->
	#errorcode_msg{type = coin_not_enough,about = <<"您的铜币不足"/utf8>>};

get(1003) ->
	#errorcode_msg{type = goods_not_enough,about = <<"物品不足"/utf8>>};

get(1004) ->
	#errorcode_msg{type = money_not_enough,about = <<"您的金额不足"/utf8>>};

get(1005) ->
	#errorcode_msg{type = missing_config,about = <<"缺失配置"/utf8>>};

get(1006) ->
	#errorcode_msg{type = bgold_not_enough,about = <<"您的绑玉余额不足"/utf8>>};

get(1007) ->
	#errorcode_msg{type = player_add_exp,about = <<"经验 +{1}"/utf8>>};

get(1008) ->
	#errorcode_msg{type = not_enough_length,about = <<"长度为4-12个字符"/utf8>>};

get(1009) ->
	#errorcode_msg{type = name_exist,about = <<"该名称已存在"/utf8>>};

get(1010) ->
	#errorcode_msg{type = illegal_character,about = <<"非法字符"/utf8>>};

get(1011) ->
	#errorcode_msg{type = not_have_free_card,about = <<"改名卡数量不足"/utf8>>};

get(1012) ->
	#errorcode_msg{type = lv_limit,about = <<"等级不足，功能暂未开放"/utf8>>};

get(1013) ->
	#errorcode_msg{type = vip_limit,about = <<"专属等级不够"/utf8>>};

get(1014) ->
	#errorcode_msg{type = cannot_transferable_scene,about = <<"当前场景不能进入！"/utf8>>};

get(1015) ->
	#errorcode_msg{type = cannot_transferable_area,about = <<"非安全区不能进入！"/utf8>>};

get(1016) ->
	#errorcode_msg{type = err_config,about = <<"配置出错"/utf8>>};

get(1017) ->
	#errorcode_msg{type = figure_actived,about = <<"形象已激活"/utf8>>};

get(1018) ->
	#errorcode_msg{type = data_error,about = <<"数据异常，请稍后再试！"/utf8>>};

get(1019) ->
	#errorcode_msg{type = cell_beyond,about = <<"格子超出上限！"/utf8>>};

get(1020) ->
	#errorcode_msg{type = player_add_exp_extra,about = <<"经验 +{1}（+{2}%）"/utf8>>};

get(1021) ->
	#errorcode_msg{type = player_lv_less,about = <<"您的等级小于{1}"/utf8>>};

get(1022) ->
	#errorcode_msg{type = player_lv_large,about = <<"您的等级大于{1}"/utf8>>};

get(1023) ->
	#errorcode_msg{type = operation_too_quickly,about = <<"您的操作过快"/utf8>>};

get(1024) ->
	#errorcode_msg{type = system_busy,about = <<"系统繁忙，请稍后再操作"/utf8>>};

get(1025) ->
	#errorcode_msg{type = honour_not_enough,about = <<"您的荣誉值不足"/utf8>>};

get(1026) ->
	#errorcode_msg{type = in_forbid_pk_status,about = <<"玩家当前状态不能释放技能"/utf8>>};

get(1027) ->
	#errorcode_msg{type = player_die,about = <<"人物已死亡"/utf8>>};

get(1028) ->
	#errorcode_msg{type = reward_is_got,about = <<"奖励已领取"/utf8>>};

get(1029) ->
	#errorcode_msg{type = what_not_enough,about = <<"{1}不足"/utf8>>};

get(1030) ->
	#errorcode_msg{type = server_no_zone,about = <<"服务器未进行跨服分区,无法获取跨服数据!"/utf8>>};

get(1031) ->
	#errorcode_msg{type = kf_server_allot,about = <<"跨服分配中，活动未开启，请稍后再来！"/utf8>>};

get(1032) ->
	#errorcode_msg{type = error_count_limit,about = <<"次数不足"/utf8>>};

get(1033) ->
	#errorcode_msg{type = over_max,about = <<"超出上限"/utf8>>};

get(1034) ->
	#errorcode_msg{type = player_lv_less_to_open,about = <<"您的等级小于{1}，未开启"/utf8>>};

get(1035) ->
	#errorcode_msg{type = player_lv_large_to_end,about = <<"您的等级大于{1}，已关闭"/utf8>>};

get(1036) ->
	#errorcode_msg{type = open_begin_less_to_open,about = <<"开服天数小于{1}，未开启"/utf8>>};

get(1037) ->
	#errorcode_msg{type = open_end_large_to_end,about = <<"开服天数大于{1}，已关闭"/utf8>>};

get(1038) ->
	#errorcode_msg{type = merge_begin_less_to_open,about = <<"合服天数小于{1}，未开启"/utf8>>};

get(1039) ->
	#errorcode_msg{type = merge_end_large_to_end,about = <<"合服天数大于{1}，已关闭"/utf8>>};

get(1040) ->
	#errorcode_msg{type = currency_not_enough,about = <<"货币不足"/utf8>>};

get(1041) ->
	#errorcode_msg{type = not_open,about = <<"功能未开放"/utf8>>};

get(1042) ->
	#errorcode_msg{type = err_gm_stop,about = <<"活动异常修复中，请等待后续通知"/utf8>>};

get(1043) ->
	#errorcode_msg{type = rune,about = <<"御魂"/utf8>>};

get(1044) ->
	#errorcode_msg{type = rune_goods,about = <<"御魂精华"/utf8>>};

get(1020001) ->
	#errorcode_msg{type = err102_setting_key_not_exist,about = <<"游戏设置类型不存在"/utf8>>};

get(1020002) ->
	#errorcode_msg{type = err102_too_frequent,about = <<"玩家当前操作太频繁，请{1}秒后再重新操作"/utf8>>};

get(1100001) ->
	#errorcode_msg{type = err110_voice_lose_efficacy,about = <<"语音已经失效"/utf8>>};

get(1100002) ->
	#errorcode_msg{type = err110_lv_limit,about = <<"您未达到此频道开放等级！"/utf8>>};

get(1100003) ->
	#errorcode_msg{type = err110_unknow_channel,about = <<"未知频道，不能发送信息！"/utf8>>};

get(1100004) ->
	#errorcode_msg{type = err110_in_cd,about = <<"聊天冷却冷却中！"/utf8>>};

get(1100005) ->
	#errorcode_msg{type = err110_content_repeat,about = <<"内容重复不能发送！"/utf8>>};

get(1100006) ->
	#errorcode_msg{type = err110_no_report_times,about = <<"每个玩家每日最多举报5次"/utf8>>};

get(1100007) ->
	#errorcode_msg{type = err110_channel_cd_not_enough,about = <<"本频道每次发言需间隔{1}秒"/utf8>>};

get(1100008) ->
	#errorcode_msg{type = err110_can_not_add_goods_to_kf_chat,about = <<"无法上传物品到跨服"/utf8>>};

get(1100009) ->
	#errorcode_msg{type = err110_max_msg_length,about = <<"消息长度过长"/utf8>>};

get(1100010) ->
	#errorcode_msg{type = err_110_sea_muted,about = <<"当前海域被海域之王禁言，禁言时长{1}分钟"/utf8>>};

get(1100011) ->
	#errorcode_msg{type = err_110_no_camp,about = <<"请加入海域！"/utf8>>};

get(1100012) ->
	#errorcode_msg{type = err110_update_chat_system,about = <<"聊天系统升级中"/utf8>>};

get(1120001) ->
	#errorcode_msg{type = err112_dress_not_exist,about = <<"装扮不存在"/utf8>>};

get(1120002) ->
	#errorcode_msg{type = err112_dress_has_enabled,about = <<"装扮已激活"/utf8>>};

get(1120003) ->
	#errorcode_msg{type = err112_dress_not_enabled,about = <<"装扮未激活"/utf8>>};

get(1120004) ->
	#errorcode_msg{type = err112_dress_not_used,about = <<"未使用装扮不需要卸下"/utf8>>};

get(1120005) ->
	#errorcode_msg{type = err112_dress_max_level,about = <<"装扮已经达到最高等级"/utf8>>};

get(1120006) ->
	#errorcode_msg{type = err112_debrisnum_illegal,about = <<"碎片数量必须大于零！"/utf8>>};

get(1120007) ->
	#errorcode_msg{type = err112_dress_arg_empty,about = <<"没有提供升级的碎片"/utf8>>};

get(1120008) ->
	#errorcode_msg{type = err112_dress_id_used,about = <<"已使用"/utf8>>};

get(1130001) ->
	#errorcode_msg{type = err113_wx_share_source_not_right,about = <<"该平台无法领取分享奖励"/utf8>>};

get(1130002) ->
	#errorcode_msg{type = err113_wx_share_count_max,about = <<"已经达到领取上限"/utf8>>};

get(1130003) ->
	#errorcode_msg{type = err113_wx_not_collect,about = <<"请先收藏微信"/utf8>>};

get(1130004) ->
	#errorcode_msg{type = err113_receive_wx_collect_reward,about = <<"已领取奖励"/utf8>>};

get(1130005) ->
	#errorcode_msg{type = err113_wx_can_not_collect,about = <<"不能进行收藏"/utf8>>};

get(1130006) ->
	#errorcode_msg{type = err113_already_collect,about = <<"已收藏"/utf8>>};

get(1200001) ->
	#errorcode_msg{type = err120_cannot_transfer_scene,about = <<"当前场景不能进入！"/utf8>>};

get(1200002) ->
	#errorcode_msg{type = err120_cannot_transfer_not_in_safe,about = <<"非安全区不能进入！"/utf8>>};

get(1200003) ->
	#errorcode_msg{type = err120_cannot_transfer_pre_scene_time,about = <<"切换场景时间不足，请再次切换场景！"/utf8>>};

get(1200004) ->
	#errorcode_msg{type = err120_cannot_transfer_change_scene_sign,about = <<"排队换线中，请稍后再切换场景！"/utf8>>};

get(1200005) ->
	#errorcode_msg{type = err120_cannot_transfer_scene_not_exist,about = <<"目标场景数据不存在！"/utf8>>};

get(1200006) ->
	#errorcode_msg{type = err120_cannot_transfer_lv_not_reach,about = <<"等级不足，不能切换到目标场景！"/utf8>>};

get(1200007) ->
	#errorcode_msg{type = err120_cannot_transfer_in_dungeon,about = <<"副本地图无法传送！"/utf8>>};

get(1200008) ->
	#errorcode_msg{type = err120_same_line,about = <<"已在当前线路"/utf8>>};

get(1200009) ->
	#errorcode_msg{type = err120_to_many_people,about = <<"此线路玩家太多，请选择另外的线路"/utf8>>};

get(1200010) ->
	#errorcode_msg{type = err120_is_on_battle,about = <<"正在寻路安全区，或者脱离战斗再参加"/utf8>>};

get(1200011) ->
	#errorcode_msg{type = err120_cannot_transfer_on_battle,about = <<"处于战斗状态无法传送"/utf8>>};

get(1200012) ->
	#errorcode_msg{type = err120_scene_loading,about = <<"当前场景还没有加载完，请稍后！"/utf8>>};

get(1200013) ->
	#errorcode_msg{type = err120_is_near,about = <<"您已经在附近，不需要飞行！"/utf8>>};

get(1200014) ->
	#errorcode_msg{type = err120_no_fly_shoes,about = <<"成为贵族，海阔天空自由飞！"/utf8>>};

get(1200015) ->
	#errorcode_msg{type = err120_cannot_battle_change_scene_sign,about = <<"正在切换场景，不能进行攻击"/utf8>>};

get(1200016) ->
	#errorcode_msg{type = err120_max_user,about = <<"场景人数已达上限，无法进入！"/utf8>>};

get(1200017) ->
	#errorcode_msg{type = err120_transtype,about = <<"暂时不能使用小飞鞋！"/utf8>>};

get(1200018) ->
	#errorcode_msg{type = err120_already_in_scene,about = <<"已经在当前场景，无须再次进入！"/utf8>>};

get(1200019) ->
	#errorcode_msg{type = err120_cannot_transfer_to_target_scene,about = <<"目标场景不可直接传送，请手动进入"/utf8>>};

get(1300001) ->
	#errorcode_msg{type = err130_change_pk_change_line,about = <<"换线中，不能切换战斗状态"/utf8>>};

get(1300002) ->
	#errorcode_msg{type = err130_change_pk_cd,about = <<"和平状态切换正在冷却中"/utf8>>};

get(1300003) ->
	#errorcode_msg{type = err130_user_cant_change_pk,about = <<"此场景不能手动切换战斗模式"/utf8>>};

get(1300004) ->
	#errorcode_msg{type = err130_change_pk_lv_lim,about = <<"低于20级不能切换pk状态"/utf8>>};

get(1300005) ->
	#errorcode_msg{type = err130_no_peace,about = <<"此场景不能切换和平模式"/utf8>>};

get(1300006) ->
	#errorcode_msg{type = err130_not_change,about = <<"当前不能切换战斗状态"/utf8>>};

get(1300007) ->
	#errorcode_msg{type = err130_no_peace_ultimate,about = <<"不能切换此模式"/utf8>>};

get(1300008) ->
	#errorcode_msg{type = err130_transfer_lv_limit,about = <<"{1}级后开启转职"/utf8>>};

get(1300009) ->
	#errorcode_msg{type = err130_transfer_sex_limit,about = <<"非单身的玩家需离婚或分手后才可转变为其他性别性别"/utf8>>};

get(1300010) ->
	#errorcode_msg{type = err130_transfer_career_same_limit,about = <<"已经是本性别，不需要进行性别"/utf8>>};

get(1300011) ->
	#errorcode_msg{type = err130_transfer_cd_limit,about = <<"处于冷却期内，无法转职"/utf8>>};

get(1300012) ->
	#errorcode_msg{type = err130_transfer_career_err,about = <<"职业数据错误"/utf8>>};

get(1300013) ->
	#errorcode_msg{type = err130_user_cant_change_this_pk,about = <<"此场景不能切换该战斗模式"/utf8>>};

get(1300014) ->
	#errorcode_msg{type = err130_picture_active,about = <<"头像已激活"/utf8>>};

get(1300015) ->
	#errorcode_msg{type = err130_cannot_recareer_inteam,about = <<"请先退出队伍再转职！"/utf8>>};

get(1300016) ->
	#errorcode_msg{type = err130_cannot_recareer_inactivity,about = <<"活动或大妖场景中无法进行转职，请在野外场景使用"/utf8>>};

get(1300017) ->
	#errorcode_msg{type = err130_no_picture,about = <<"没有此头像"/utf8>>};

get(1300018) ->
	#errorcode_msg{type = err130_picture_limit,about = <<"你已被管理员禁止设置头像"/utf8>>};

get(1300019) ->
	#errorcode_msg{type = err130_has_uploaded_daily,about = <<"今天已经换过头像了，请明天再试~"/utf8>>};

get(1300020) ->
	#errorcode_msg{type = err130_escape_not_change_scene,about = <<"非野外场景不能切回出生点"/utf8>>};

get(1310001) ->
	#errorcode_msg{type = err131_reply_error,about = <<"回复参数错误"/utf8>>};

get(1310002) ->
	#errorcode_msg{type = err131_player_die,about = <<"人物死亡，无法回复"/utf8>>};

get(1310003) ->
	#errorcode_msg{type = err131_hp_max,about = <<"气血已满，无需回复"/utf8>>};

get(1310004) ->
	#errorcode_msg{type = err131_time_error,about = <<"回复时间未到"/utf8>>};

get(1310005) ->
	#errorcode_msg{type = err131_scene_limit,about = <<"场景限制"/utf8>>};

get(1310006) ->
	#errorcode_msg{type = err131_sit_down_first,about = <<"请先打坐，方可按打坐方式回复"/utf8>>};

get(1320001) ->
	#errorcode_msg{type = err132_no_redemption_exp,about = <<"没有离线经验可赎回"/utf8>>};

get(1320002) ->
	#errorcode_msg{type = err132_not_enough,about = <<"没有次数可找回"/utf8>>};

get(1320003) ->
	#errorcode_msg{type = err132_no_left_back_exp,about = <<"没有可找回的经验"/utf8>>};

get(1320004) ->
	#errorcode_msg{type = err132_over_max_back_count,about = <<"超过最大找回次数"/utf8>>};

get(1320005) ->
	#errorcode_msg{type = err132_not_enough_afk_unit_time,about = <<"还没有到触发的时间"/utf8>>};

get(1320006) ->
	#errorcode_msg{type = err132_no_afk_left_time,about = <<"没有挂机时间"/utf8>>};

get(1320007) ->
	#errorcode_msg{type = err132_in_afk_stop_et,about = <<"处于禁止挂机内"/utf8>>};

get(1320008) ->
	#errorcode_msg{type = err132_bag_full_not_to_get_afk_goods,about = <<"背包已满，无法获得挂机掉落"/utf8>>};

get(1330001) ->
	#errorcode_msg{type = err133_max_gate,about = <<"已达到最大关卡"/utf8>>};

get(1330002) ->
	#errorcode_msg{type = err133_err_gate,about = <<"错误关卡"/utf8>>};

get(1330003) ->
	#errorcode_msg{type = err133_no_exist_sweep,about = <<"Ps中不存在扫荡信息"/utf8>>};

get(1330004) ->
	#errorcode_msg{type = err133_max_sweep_times,about = <<"已达到最大扫荡次数"/utf8>>};

get(1330005) ->
	#errorcode_msg{type = err133_not_single,about = <<"玩家当前是组队模式"/utf8>>};

get(1330006) ->
	#errorcode_msg{type = err133_no_enough_wave,about = <<"野怪波数不足够"/utf8>>};

get(1330007) ->
	#errorcode_msg{type = err133_err_rank_type,about = <<"错误的排行榜访问类型"/utf8>>};

get(1330008) ->
	#errorcode_msg{type = err133_not_enough_spirit,about = <<"精魄不足"/utf8>>};

get(1330009) ->
	#errorcode_msg{type = err133_err_config,about = <<"配置错误"/utf8>>};

get(1330010) ->
	#errorcode_msg{type = err133_not_enough_seal_times,about = <<"封印次数不够"/utf8>>};

get(1330011) ->
	#errorcode_msg{type = err133_err_stage_gate,about = <<"该阶段奖励不可领取"/utf8>>};

get(1330012) ->
	#errorcode_msg{type = err133_active_pre_soap,about = <<"请先激活前面的法器"/utf8>>};

get(1330013) ->
	#errorcode_msg{type = err133_active_pre_debris,about = <<"请先激活前面的法器碎片"/utf8>>};

get(1340000) ->
	#errorcode_msg{type = err134_max_lv,about = <<"境界已达到最大等级"/utf8>>};

get(1340001) ->
	#errorcode_msg{type = err134_power_not_enough,about = <<"战力不足"/utf8>>};

get(1340002) ->
	#errorcode_msg{type = err134_have_not_finish_dun,about = <<"未通关副本"/utf8>>};

get(1340003) ->
	#errorcode_msg{type = lv_not_enougth,about = <<"等级不足"/utf8>>};

get(1340004) ->
	#errorcode_msg{type = title_is_not_exists,about = <<"该神喻不存在"/utf8>>};

get(1340005) ->
	#errorcode_msg{type = max_title_star,about = <<"该神喻达到最大星级"/utf8>>};

get(1340006) ->
	#errorcode_msg{type = title_is_not_active,about = <<"天境暂未激活"/utf8>>};

get(1340007) ->
	#errorcode_msg{type = title_is_not_equip,about = <<"未幻化头衔，不要重复取消"/utf8>>};

get(1350001) ->
	#errorcode_msg{type = err135_not_open,about = <<"活动没有开启"/utf8>>};

get(1350002) ->
	#errorcode_msg{type = err135_can_not_change_scene_in_nine,about = <<"在九魂妖塔活动中，无法进入"/utf8>>};

get(1370001) ->
	#errorcode_msg{type = err137_not_sign_state,about = <<"非报名阶段"/utf8>>};

get(1370002) ->
	#errorcode_msg{type = err137_has_sign,about = <<"已报名"/utf8>>};

get(1370003) ->
	#errorcode_msg{type = err137_tool_not_enough,about = <<"道具不足"/utf8>>};

get(1370004) ->
	#errorcode_msg{type = err137_lv_not_enough,about = <<"未达到参赛等级"/utf8>>};

get(1370005) ->
	#errorcode_msg{type = err137_buy_limit,about = <<"已达购买上限"/utf8>>};

get(1370006) ->
	#errorcode_msg{type = err137_not_sign,about = <<"您没有报名，无法进入"/utf8>>};

get(1370007) ->
	#errorcode_msg{type = err137_not_prepare_state,about = <<"非准备阶段"/utf8>>};

get(1370008) ->
	#errorcode_msg{type = err137_is_in_prepare,about = <<"已在准备区"/utf8>>};

get(1370009) ->
	#errorcode_msg{type = err137_not_allow_select_same,about = <<"不可重复选同个候选人"/utf8>>};

get(1370010) ->
	#errorcode_msg{type = err137_cfg_error,about = <<"参数错误"/utf8>>};

get(1370011) ->
	#errorcode_msg{type = err137_not_need_to_leave,about = <<"非擂台赛场景,不需退出"/utf8>>};

get(1370012) ->
	#errorcode_msg{type = err137_not_guess_state,about = <<"非竞猜阶段"/utf8>>};

get(1370013) ->
	#errorcode_msg{type = err137_not_guess_zone_role,about = <<"非可选战区候选人"/utf8>>};

get(1370014) ->
	#errorcode_msg{type = err137_not_guess_act_role,about = <<"非可选战场候选人"/utf8>>};

get(1370015) ->
	#errorcode_msg{type = err137_not_select_empty_role,about = <<"轮空玩家不可选"/utf8>>};

get(1370016) ->
	#errorcode_msg{type = err137_not_select_same_plat,about = <<"不可同时选同台候选人"/utf8>>};

get(1370017) ->
	#errorcode_msg{type = err137_skill_cd,about = <<"技能未冷却"/utf8>>};

get(1370018) ->
	#errorcode_msg{type = err137_fight_allow_use,about = <<"技能擂台中可使用"/utf8>>};

get(1370019) ->
	#errorcode_msg{type = err137_error_skill,about = <<"非法技能"/utf8>>};

get(1370020) ->
	#errorcode_msg{type = err137_not_in_prepare,about = <<"不在准备区中"/utf8>>};

get(1370021) ->
	#errorcode_msg{type = err137_be_kill_not_buy,about = <<"已被击杀，不可购买"/utf8>>};

get(1370022) ->
	#errorcode_msg{type = err137_power_out,about = <<"战力跌出4096名，失去比赛资格"/utf8>>};

get(1370023) ->
	#errorcode_msg{type = err137_in_drum_war,about = <<"正在勾玉大战中，禁止切换场景"/utf8>>};

get(1370024) ->
	#errorcode_msg{type = err137_guess_reward_get,about = <<"您已领取竞猜奖励"/utf8>>};

get(1370025) ->
	#errorcode_msg{type = err137_guees_fail,about = <<"竞猜失败，不能领取奖励"/utf8>>};

get(1370026) ->
	#errorcode_msg{type = err137_no_guess,about = <<"您没有进行竞猜"/utf8>>};

get(1370027) ->
	#errorcode_msg{type = err137_had_guess_act,about = <<"本轮次已竞猜"/utf8>>};

get(1370028) ->
	#errorcode_msg{type = err137_open_day_limit,about = <<"开服天数不足"/utf8>>};

get(1380001) ->
	#errorcode_msg{type = err138_had_reward,about = <<"已领取奖励"/utf8>>};

get(1380002) ->
	#errorcode_msg{type = err138_not_open,about = <<"未开启"/utf8>>};

get(1390001) ->
	#errorcode_msg{type = err139_no_loop_times,about = <<"没有转盘次数"/utf8>>};

get(1390002) ->
	#errorcode_msg{type = err139_had_equip,about = <<"已佩戴"/utf8>>};

get(1390003) ->
	#errorcode_msg{type = err139_not_active,about = <<"武器未激活"/utf8>>};

get(1400001) ->
	#errorcode_msg{type = err140_1_myself_friend_num_limit,about = <<"本人好友人数已达上限"/utf8>>};

get(1400002) ->
	#errorcode_msg{type = err140_2_other_friend_num_limit,about = <<"对方好友人数已达上限"/utf8>>};

get(1400003) ->
	#errorcode_msg{type = err140_3_role_no_exist,about = <<"玩家不存在"/utf8>>};

get(1400004) ->
	#errorcode_msg{type = err140_4_is_friend,about = <<"对方已经是您的好友"/utf8>>};

get(1400005) ->
	#errorcode_msg{type = err140_5_not_reply_myself_ask,about = <<"不可添加自己为好友"/utf8>>};

get(1400006) ->
	#errorcode_msg{type = err140_6_not_friend,about = <<"对方不是您的好友"/utf8>>};

get(1400007) ->
	#errorcode_msg{type = err140_7_not_exist_by_type,about = <<"非对应关系"/utf8>>};

get(1400009) ->
	#errorcode_msg{type = err140_9_exist_rela,about = <<"已经添加过了~"/utf8>>};

get(1400010) ->
	#errorcode_msg{type = err140_10_not_enemy,about = <<"不是仇人~"/utf8>>};

get(1400012) ->
	#errorcode_msg{type = err140_12_present_max,about = <<"赠送礼物次数已达上限"/utf8>>};

get(1400013) ->
	#errorcode_msg{type = err140_13_intimacy_max,about = <<"亲密度已达上限"/utf8>>};

get(1400014) ->
	#errorcode_msg{type = err140_14_not_online,about = <<"该玩家不在线"/utf8>>};

get(1400019) ->
	#errorcode_msg{type = err140_19_no_ask_to_be_friend,about = <<"暂时没有好友申请"/utf8>>};

get(1400020) ->
	#errorcode_msg{type = err140_20_no_friend_ask,about = <<"无申请信息"/utf8>>};

get(1400021) ->
	#errorcode_msg{type = err140_21_name_is_wrongful,about = <<"名字不合法"/utf8>>};

get(1400022) ->
	#errorcode_msg{type = err140_22_not_scene,about = <<"在主城或安全区才能进行该操作"/utf8>>};

get(1400025) ->
	#errorcode_msg{type = err140_25_in_blacklist,about = <<"该玩家已被你拉入黑名单，无法添加。"/utf8>>};

get(1400026) ->
	#errorcode_msg{type = err140_26_recommended_too_often,about = <<"推荐太频繁了，休息下再来"/utf8>>};

get(1400027) ->
	#errorcode_msg{type = err140_27_myself_black_list_num_limit,about = <<"黑名单人数已达上限"/utf8>>};

get(1400028) ->
	#errorcode_msg{type = err140_28_in_another_blacklist,about = <<"您在对方的黑名单中，无法添加好友"/utf8>>};

get(1400029) ->
	#errorcode_msg{type = err140_29_not_same_server_player,about = <<"不是同服玩家暂时不能查看"/utf8>>};

get(1400030) ->
	#errorcode_msg{type = err140_in_another_blacklist_to_do_sth,about = <<"你已被对方拉入黑名单"/utf8>>};

get(1400031) ->
	#errorcode_msg{type = err140_cannot_del_lover,about = <<"不能删除姻缘"/utf8>>};

get(1400032) ->
	#errorcode_msg{type = err140_cannot_pull_black_lover,about = <<"不能拉黑姻缘"/utf8>>};

get(1410001) ->
	#errorcode_msg{type = err_141_no_decoration,about = <<"当前背饰没激活"/utf8>>};

get(1410002) ->
	#errorcode_msg{type = err_141_had_illusion,about = <<"当前背饰已幻化"/utf8>>};

get(1410003) ->
	#errorcode_msg{type = err_141_had_no_illusion,about = <<"当前背饰未幻化"/utf8>>};

get(1410004) ->
	#errorcode_msg{type = err_141_had_active,about = <<"背饰已激活"/utf8>>};

get(1410005) ->
	#errorcode_msg{type = err_141_error_cfg,about = <<"没有当前背饰配置"/utf8>>};

get(1410006) ->
	#errorcode_msg{type = err_141_max_stage,about = <<"背饰达到最大等级"/utf8>>};

get(1410007) ->
	#errorcode_msg{type = err_141_had_no_active,about = <<"背饰未激活"/utf8>>};

get(1410008) ->
	#errorcode_msg{type = err_141_stage_not_match,about = <<"背饰等级不匹配"/utf8>>};

get(1420001) ->
	#errorcode_msg{type = err142_no_active,about = <<"未激活当前神巫"/utf8>>};

get(1420002) ->
	#errorcode_msg{type = err142_had_active,about = <<"当前神巫已激活"/utf8>>};

get(1420003) ->
	#errorcode_msg{type = err142_had_fight,about = <<"当前神巫已出战"/utf8>>};

get(1420004) ->
	#errorcode_msg{type = err142_max_stage,about = <<"已达最大等级"/utf8>>};

get(1420005) ->
	#errorcode_msg{type = err142_train_limit,about = <<"培养丹使用已达上限"/utf8>>};

get(1420007) ->
	#errorcode_msg{type = err142_recharge_not_enough,about = <<"充值额度不够，无法激活当前神巫"/utf8>>};

get(1420008) ->
	#errorcode_msg{type = err142_no_finish_task,about = <<"完成神巫任务方可解锁哦~"/utf8>>};

get(1420009) ->
	#errorcode_msg{type = err142_biog_had_unlock,about = <<"当前传记已解锁"/utf8>>};

get(1420010) ->
	#errorcode_msg{type = err142_stage_star_not_enough,about = <<"神巫等级不足"/utf8>>};

get(1430001) ->
	#errorcode_msg{type = err143_had_active,about = <<"该龙珠已激活"/utf8>>};

get(1430002) ->
	#errorcode_msg{type = err143_max_lv,about = <<"已达最大等级~"/utf8>>};

get(1430003) ->
	#errorcode_msg{type = err143_no_active,about = <<"请先激活~"/utf8>>};

get(1430004) ->
	#errorcode_msg{type = err143_statue_not_active,about = <<"神龙雕像未激活"/utf8>>};

get(1430005) ->
	#errorcode_msg{type = err143_figure_not_active,about = <<"该套装未激活"/utf8>>};

get(1430006) ->
	#errorcode_msg{type = err143_same_figure,about = <<"正在穿戴该套装"/utf8>>};

get(1430007) ->
	#errorcode_msg{type = err143_figure_not_wear,about = <<"未穿戴该类型套装"/utf8>>};

get(1430008) ->
	#errorcode_msg{type = err143_had_active_figure,about = <<"该套装已激活"/utf8>>};

get(1430009) ->
	#errorcode_msg{type = err143_last_figure_not_active,about = <<"上一件套装未激活"/utf8>>};

get(1430010) ->
	#errorcode_msg{type = err143_figure_not_enough_balls,about = <<"龙玉等级未达标"/utf8>>};

get(1440001) ->
	#errorcode_msg{type = err144_param_error,about = <<"参数错误"/utf8>>};

get(1440002) ->
	#errorcode_msg{type = err144_lv_not_enough,about = <<"等级不足"/utf8>>};

get(1440003) ->
	#errorcode_msg{type = err144_pre_stage_not_made,about = <<"需先打造上一阶装备"/utf8>>};

get(1440004) ->
	#errorcode_msg{type = err144_pos_has_made,about = <<"当前装备部位已打造"/utf8>>};

get(1450001) ->
	#errorcode_msg{type = err145_1_role_no_exist,about = <<"玩家不存在"/utf8>>};

get(1450002) ->
	#errorcode_msg{type = err145_2_word_is_sensitive,about = <<"存在敏感词"/utf8>>};

get(1480000) ->
	#errorcode_msg{type = err148_not_exist_fairy,about = <<"没有该侍魂"/utf8>>};

get(1480001) ->
	#errorcode_msg{type = err148_stage_limit,about = <<"侍魂星级达到上限"/utf8>>};

get(1480002) ->
	#errorcode_msg{type = err148_level_limit,about = <<"侍魂等级达到上限"/utf8>>};

get(1480003) ->
	#errorcode_msg{type = err148_fairy_not_active,about = <<"该侍魂没有激活"/utf8>>};

get(1490000) ->
	#errorcode_msg{type = err149_equip_stage_limit,about = <<"玩家等级不足，无法装备该阶装备"/utf8>>};

get(1490001) ->
	#errorcode_msg{type = err149_err_dec,about = <<"物品不是灵饰"/utf8>>};

get(1490002) ->
	#errorcode_msg{type = err149_stage_max,about = <<"灵饰已经满阶"/utf8>>};

get(1490003) ->
	#errorcode_msg{type = err149_level_max,about = <<"灵饰已经满级"/utf8>>};

get(1490004) ->
	#errorcode_msg{type = err149_stage_cost,about = <<"升阶灵饰物品不足"/utf8>>};

get(1490005) ->
	#errorcode_msg{type = err149_level_cost,about = <<"强化灵饰，物品不足"/utf8>>};

get(1490006) ->
	#errorcode_msg{type = err149_lev_not_enough,about = <<"强化没有到上限，不能升阶"/utf8>>};

get(1490007) ->
	#errorcode_msg{type = err149_cell_lock_limit,about = <<"{1}部位在装备总阶数达{2}阶解锁"/utf8>>};

get(1500000) ->
	#errorcode_msg{type = err150_fail,about = <<"物品操作失败"/utf8>>};

get(1500001) ->
	#errorcode_msg{type = err150_no_goods,about = <<"物品不存在"/utf8>>};

get(1500002) ->
	#errorcode_msg{type = err150_no_money,about = <<"金额不足"/utf8>>};

get(1500003) ->
	#errorcode_msg{type = err150_no_cell,about = <<"容量不足，请先清理背包"/utf8>>};

get(1500004) ->
	#errorcode_msg{type = err150_npc_far,about = <<"离npc太远"/utf8>>};

get(1500005) ->
	#errorcode_msg{type = err150_in_sell,about = <<"正在交易中"/utf8>>};

get(1500006) ->
	#errorcode_msg{type = err150_price_err,about = <<"物品价格错误"/utf8>>};

get(1500007) ->
	#errorcode_msg{type = err150_palyer_err,about = <<"物品所有者错误"/utf8>>};

get(1500008) ->
	#errorcode_msg{type = err150_location_err,about = <<"物品位置错误"/utf8>>};

get(1500009) ->
	#errorcode_msg{type = err150_not_sell,about = <<"物品不可出售"/utf8>>};

get(1500010) ->
	#errorcode_msg{type = err150_num_err,about = <<"物品数量错误"/utf8>>};

get(1500011) ->
	#errorcode_msg{type = err150_cell_max,about = <<"背包空间已达上限"/utf8>>};

get(1500012) ->
	#errorcode_msg{type = err150_type_err,about = <<"物品类型错误"/utf8>>};

get(1500013) ->
	#errorcode_msg{type = err150_require_err,about = <<"条件不符"/utf8>>};

get(1500014) ->
	#errorcode_msg{type = err150_attrition_full,about = <<"无磨损"/utf8>>};

get(1500015) ->
	#errorcode_msg{type = err150_no_goods_type,about = <<"物品类型不存在"/utf8>>};

get(1500016) ->
	#errorcode_msg{type = err150_in_cd,about = <<"冷却时间"/utf8>>};

get(1500017) ->
	#errorcode_msg{type = err150_lv_err,about = <<"物品等级限制"/utf8>>};

get(1500018) ->
	#errorcode_msg{type = err150_player_die,about = <<"人物已死亡"/utf8>>};

get(1500019) ->
	#errorcode_msg{type = err150_not_trhow,about = <<"物品不可销毁"/utf8>>};

get(1500020) ->
	#errorcode_msg{type = err150_no_drop,about = <<"该掉落已被拾取"/utf8>>};

get(1500021) ->
	#errorcode_msg{type = err150_no_drop_per,about = <<"不是您的掉落，请稍后在拾取"/utf8>>};

get(1500022) ->
	#errorcode_msg{type = err150_time_not_start,about = <<"时间还未到"/utf8>>};

get(1500023) ->
	#errorcode_msg{type = err150_time_end,about = <<"时间已经结束"/utf8>>};

get(1500024) ->
	#errorcode_msg{type = err150_gift_unactive,about = <<"礼包未生效"/utf8>>};

get(1500025) ->
	#errorcode_msg{type = err150_no_rule,about = <<"规则不存在"/utf8>>};

get(1500026) ->
	#errorcode_msg{type = err150_rule_unactive,about = <<"规则未生效"/utf8>>};

get(1500027) ->
	#errorcode_msg{type = err150_shop_time_limit,about = <<"限时物品一天只能购买一次"/utf8>>};

get(1500028) ->
	#errorcode_msg{type = err150_goods_num_zero,about = <<"物品已经卖完"/utf8>>};

get(1500029) ->
	#errorcode_msg{type = err150_gift_got,about = <<"礼包已领取"/utf8>>};

get(1500030) ->
	#errorcode_msg{type = err150_num_limit,about = <<"次数已达上限"/utf8>>};

get(1500031) ->
	#errorcode_msg{type = err150_storage_no_cell,about = <<"仓库空间不足"/utf8>>};

get(1500032) ->
	#errorcode_msg{type = err150_scene_wrong,about = <<"本场景无法使用"/utf8>>};

get(1500033) ->
	#errorcode_msg{type = err150_npc_type_err,about = <<"npc类型错误"/utf8>>};

get(1500034) ->
	#errorcode_msg{type = err150_hp_mp_full,about = <<"使用量超出上限，无法使用"/utf8>>};

get(1500035) ->
	#errorcode_msg{type = err150_num_over,about = <<"次数超出每天上限"/utf8>>};

get(1500036) ->
	#errorcode_msg{type = err150_skill_fail,about = <<"技能学习失败"/utf8>>};

get(1500037) ->
	#errorcode_msg{type = err150_fashion_expire,about = <<"装备已经过期，不可穿戴"/utf8>>};

get(1500038) ->
	#errorcode_msg{type = err150_scene_pos,about = <<"使用地图坐标不正确"/utf8>>};

get(1500039) ->
	#errorcode_msg{type = err150_not_event,about = <<"无触发事件"/utf8>>};

get(1500040) ->
	#errorcode_msg{type = err150_nothing,about = <<"物品使用后什么都没有"/utf8>>};

get(1500041) ->
	#errorcode_msg{type = err150_cannot_replace_mid,about = <<"当前增益状态不能替换中级增益状态"/utf8>>};

get(1500042) ->
	#errorcode_msg{type = err150_cannot_replace_big,about = <<"当前增益状态不能替换高级增益状态"/utf8>>};

get(1500043) ->
	#errorcode_msg{type = err150_no_guild,about = <<"没有帮派"/utf8>>};

get(1500044) ->
	#errorcode_msg{type = err150_num_single_limit,about = <<"单个物品次数已达上限"/utf8>>};

get(1500045) ->
	#errorcode_msg{type = err150_num_single_over,about = <<"单个物品兑换数量超过每天上限"/utf8>>};

get(1500046) ->
	#errorcode_msg{type = err150_distance,about = <<"距离掉落包过远"/utf8>>};

get(1500047) ->
	#errorcode_msg{type = err150_vip_coin,about = <<"贵族铜币道具小于等于该等级的贵族不能使用"/utf8>>};

get(1500048) ->
	#errorcode_msg{type = err150_lv_goods,about = <<"无法使用等级道具"/utf8>>};

get(1500049) ->
	#errorcode_msg{type = err150_num_notmatch,about = <<"自选物品数量异常"/utf8>>};

get(1500050) ->
	#errorcode_msg{type = err150_seqlist_notmatch,about = <<"找不到自选礼包奖励内容"/utf8>>};

get(1500051) ->
	#errorcode_msg{type = err150_no_gift_type,about = <<"打开宝箱配置不存在"/utf8>>};

get(1500052) ->
	#errorcode_msg{type = err150_goods_expired,about = <<"物品已过有效期"/utf8>>};

get(1500053) ->
	#errorcode_msg{type = err150_no_career_gift,about = <<"职业不符，无法打开"/utf8>>};

get(1500054) ->
	#errorcode_msg{type = err150_exper_error,about = <<"剩余历练次数不足"/utf8>>};

get(1500055) ->
	#errorcode_msg{type = err150_compose_goods_not_enough,about = <<"资源不足，无法合成"/utf8>>};

get(1500056) ->
	#errorcode_msg{type = err150_goods_id_err,about = <<"物品类型id有误"/utf8>>};

get(1500057) ->
	#errorcode_msg{type = err150_exper_time_more_than_7hour,about = <<"智慧药水最多累积7小时"/utf8>>};

get(1500058) ->
	#errorcode_msg{type = err150_gift_cfg_missing,about = <<"礼包数据不存在"/utf8>>};

get(1500059) ->
	#errorcode_msg{type = err150_gift_status_error,about = <<"礼包状态为无效"/utf8>>};

get(1500060) ->
	#errorcode_msg{type = err150_gift_nobegin,about = <<"未到领取礼包时间"/utf8>>};

get(1500061) ->
	#errorcode_msg{type = err150_gift_overtime,about = <<"已过了领取礼包时间"/utf8>>};

get(1500062) ->
	#errorcode_msg{type = err150_gift_data_error,about = <<"礼包数据错误"/utf8>>};

get(1500063) ->
	#errorcode_msg{type = err150_gift_fetch_error,about = <<"领取礼包失败"/utf8>>};

get(1500064) ->
	#errorcode_msg{type = err150_gift_card_err_len,about = <<"礼包卡长度错误"/utf8>>};

get(1500065) ->
	#errorcode_msg{type = err150_gift_card_not_exist,about = <<"卡号错误"/utf8>>};

get(1500066) ->
	#errorcode_msg{type = err150_gift_card_no_gift_type,about = <<"卡号没有绑定礼包"/utf8>>};

get(1500067) ->
	#errorcode_msg{type = err150_gift_card_platform_error,about = <<"平台不对"/utf8>>};

get(1500068) ->
	#errorcode_msg{type = err150_gift_card_has_trigger,about = <<"卡号已经被领取"/utf8>>};

get(1500069) ->
	#errorcode_msg{type = err150_gift_card_nobegin,about = <<"未到领取卡号时间"/utf8>>};

get(1500070) ->
	#errorcode_msg{type = err150_gift_card_overtime,about = <<"卡号过期"/utf8>>};

get(1500071) ->
	#errorcode_msg{type = err150_gift_card_has_use_same_card,about = <<"已经使用过同类卡号"/utf8>>};

get(1500072) ->
	#errorcode_msg{type = err150_gift_card_gift_not_exist,about = <<"礼包数据不存在"/utf8>>};

get(1500073) ->
	#errorcode_msg{type = err150_lv_gfit_cfg_err,about = <<"等级不足，暂时无法使用"/utf8>>};

get(1500074) ->
	#errorcode_msg{type = err150_good_in_expire,about = <<"物品还未过期"/utf8>>};

get(1500075) ->
	#errorcode_msg{type = err150_pk_value_0,about = <<"红名值值为0，不需要使用洗恶卡"/utf8>>};

get(1500076) ->
	#errorcode_msg{type = err150_not_compose_mat,about = <<"所选物品不属于合成资源"/utf8>>};

get(1500077) ->
	#errorcode_msg{type = err150_no_cell_to_compose,about = <<"背包容量不足，无法合成"/utf8>>};

get(1500078) ->
	#errorcode_msg{type = err150_no_money_to_compose,about = <<"物品不足，无法合成"/utf8>>};

get(1500079) ->
	#errorcode_msg{type = err150_not_satisfy_compose_lv,about = <<"角色等级不够，无法合成"/utf8>>};

get(1500080) ->
	#errorcode_msg{type = err150_compose_success,about = <<"合成成功"/utf8>>};

get(1500081) ->
	#errorcode_msg{type = err150_compose_fail,about = <<"合成失败"/utf8>>};

get(1500082) ->
	#errorcode_msg{type = err150_no_null_cell_decompose_fail,about = <<"背包空位不足，拆解失败"/utf8>>};

get(1500083) ->
	#errorcode_msg{type = err150_user_use_dsgt,about = <<"称号已经激活，返还{1}金币"/utf8>>};

get(1500084) ->
	#errorcode_msg{type = err150_renew_cf_miss,about = <<"物品续费配置缺失"/utf8>>};

get(1500085) ->
	#errorcode_msg{type = err150_bag_location_fail,about = <<"背包类型配置错误"/utf8>>};

get(1500086) ->
	#errorcode_msg{type = err150_compose_type_lock,about = <<"该合成方式未解锁"/utf8>>};

get(1500087) ->
	#errorcode_msg{type = err150_notin_drop_scene,about = <<"场景不同，不能拾取"/utf8>>};

get(1500088) ->
	#errorcode_msg{type = err150_not_drop_copyid,about = <<"房间不同，不能拾取"/utf8>>};

get(1500089) ->
	#errorcode_msg{type = err150_drop_no_hp,about = <<"您已经死亡，不能拾取"/utf8>>};

get(1500090) ->
	#errorcode_msg{type = err150_no_hurt_drop,about = <<"您没有对大妖造成伤害，暂时不能拾取该掉落"/utf8>>};

get(1500091) ->
	#errorcode_msg{type = err150_drop_overlv,about = <<"您的等级超过大妖等级100级，无法获得掉落"/utf8>>};

get(1500092) ->
	#errorcode_msg{type = err150_no_boss_tired,about = <<"您的大妖疲劳值还未消耗，无须使用该物品"/utf8>>};

get(1500093) ->
	#errorcode_msg{type = err150_no_drop_boss_tired,about = <<"您的大妖疲劳已满不能拾取掉落"/utf8>>};

get(1500094) ->
	#errorcode_msg{type = err150_gift_reward_miss,about = <<"礼包奖励内容不存在"/utf8>>};

get(1500095) ->
	#errorcode_msg{type = err150_lv_not_enough,about = <<"等级不足，玩法使用！"/utf8>>};

get(1500096) ->
	#errorcode_msg{type = err150_decompose_wear,about = <<"不能拆解已经穿戴的物品"/utf8>>};

get(1500097) ->
	#errorcode_msg{type = err150_currency_not_enough,about = <<"{1}数量不足"/utf8>>};

get(1500098) ->
	#errorcode_msg{type = err150_day_not_enough,about = <<"再登录{1}天可开启哦!{2}"/utf8>>};

get(1500099) ->
	#errorcode_msg{type = err150_soul_bag_full,about = <<"源力背包已满"/utf8>>};

get(1500100) ->
	#errorcode_msg{type = err150_onhook_time_enough,about = <<"您的离线挂机时间已满，无需再使用离线时间卡！"/utf8>>};

get(1500101) ->
	#errorcode_msg{type = err150_eudemonds_bag_nocell,about = <<"蜃妖背包空间不足"/utf8>>};

get(1500102) ->
	#errorcode_msg{type = err150_seal_bag_nocell,about = <<"圣纹背包不足，请及时清理"/utf8>>};

get(1500103) ->
	#errorcode_msg{type = err150_mount_equip_bag_nocell,about = <<"坐骑装备背包已满"/utf8>>};

get(1500104) ->
	#errorcode_msg{type = err150_mount_equip_bag_full,about = <<"坐骑背包空间不足"/utf8>>};

get(1500105) ->
	#errorcode_msg{type = err150_card_ok_send,about = <<"礼包卡兑换成功，请到邮件查收！"/utf8>>};

get(1500106) ->
	#errorcode_msg{type = err150_rune_bag_no_cell,about = <<"御魂背包已满，请先清理背包"/utf8>>};

get(1500107) ->
	#errorcode_msg{type = err150_soul_bag_no_cell,about = <<"源力背包已满，请先清理背包"/utf8>>};

get(1500108) ->
	#errorcode_msg{type = err150_eudemons_bag_no_cell,about = <<"幻兽背包已满，请先清理背包"/utf8>>};

get(1500109) ->
	#errorcode_msg{type = err150_not_god_equip,about = <<"不是神装装备不能移入保护箱"/utf8>>};

get(1500110) ->
	#errorcode_msg{type = err150_god_bag_prot_limit,about = <<"保护箱已满"/utf8>>};

get(1500111) ->
	#errorcode_msg{type = err150_sex_limit,about = <<"性别不符"/utf8>>};

get(1500112) ->
	#errorcode_msg{type = err150_no_cell_equip_bag,about = <<"装备背包空间不足"/utf8>>};

get(1500113) ->
	#errorcode_msg{type = err150_no_cell_god_equip_bag,about = <<"神装背包空间不足"/utf8>>};

get(1500114) ->
	#errorcode_msg{type = err150_not_picture_goods,about = <<"不是头像物品"/utf8>>};

get(1500115) ->
	#errorcode_msg{type = err150_gift_no_count,about = <<"开启次数已用完"/utf8>>};

get(1500116) ->
	#errorcode_msg{type = err150_gift_in_freeze,about = <<"冷却中"/utf8>>};

get(1500117) ->
	#errorcode_msg{type = err150_no_fusion_equip,about = <<"当前无可消耗的装备"/utf8>>};

get(1500118) ->
	#errorcode_msg{type = err150_goods_cannt_fusion,about = <<"物品不能吞噬"/utf8>>};

get(1500119) ->
	#errorcode_msg{type = err150_gift_card_channel_can_not_use,about = <<"该渠道不能使用"/utf8>>};

get(1500120) ->
	#errorcode_msg{type = err150_custom_price_invalid,about = <<"无效价格"/utf8>>};

get(1500121) ->
	#errorcode_msg{type = err150_start_pick_drop,about = <<"开始拾取"/utf8>>};

get(1500122) ->
	#errorcode_msg{type = err150_other_picking,about = <<"其他人在拾取"/utf8>>};

get(1500123) ->
	#errorcode_msg{type = err150_pick_time_not_enough,about = <<"拾取时间不足"/utf8>>};

get(1500124) ->
	#errorcode_msg{type = err150_drop_timeout,about = <<"掉落物品已经过期无法拾取"/utf8>>};

get(1500125) ->
	#errorcode_msg{type = err150_lv_err_2,about = <<"需要达到{1}级才可使用"/utf8>>};

get(1500126) ->
	#errorcode_msg{type = err150_drop_overlv_with_args,about = <<"您的等级超过大妖等级{1}级，无法获得掉落"/utf8>>};

get(1500127) ->
	#errorcode_msg{type = err150_drop_not_enough_hurt,about = <<"造成伤害不足{1},无法拾取奖励"/utf8>>};

get(1500128) ->
	#errorcode_msg{type = err150_drop_server_diff,about = <<"本掉落只能归属服的玩家才能拾取"/utf8>>};

get(1500129) ->
	#errorcode_msg{type = err150_hurt_ratio,about = <<"最少造成{1}%伤害才可拾取奖励"/utf8>>};

get(1500130) ->
	#errorcode_msg{type = err150_mate_equip_bag_full,about = <<"伙伴装备背包空间不足"/utf8>>};

get(1500131) ->
	#errorcode_msg{type = err150_decoration_no_cell,about = <<"灵饰背包空间不足"/utf8>>};

get(1500132) ->
	#errorcode_msg{type = err150_seal_no_cell,about = <<"影装背包空间不足"/utf8>>};

get(1500133) ->
	#errorcode_msg{type = err150_mount_equip_no_cell,about = <<"坐骑背包空间不足"/utf8>>};

get(1500134) ->
	#errorcode_msg{type = err150_mate_equip_no_cell,about = <<"伙伴背包空间不足"/utf8>>};

get(1500135) ->
	#errorcode_msg{type = err150_demons_skill_no_cell,about = <<"精怪技能背包空间不足"/utf8>>};

get(1500136) ->
	#errorcode_msg{type = err150_drop_camp_diff,about = <<"本掉落只能归属阵营的玩家才能拾取"/utf8>>};

get(1500137) ->
	#errorcode_msg{type = err150_constellation_no_cell,about = <<"圣衣背包空间不足"/utf8>>};

get(1500138) ->
	#errorcode_msg{type = err150_not_enough_run_dun,about = <<"御魂塔层不足"/utf8>>};

get(1500139) ->
	#errorcode_msg{type = err150_gift_card_length_illegal,about = <<"卡号长度不符合规则"/utf8>>};

get(1500140) ->
	#errorcode_msg{type = err150_cannt_use_goods_over_exp,about = <<"经验已满"/utf8>>};

get(1500141) ->
	#errorcode_msg{type = err150_can_not_storge,about = <<"该物品类型不能存放于仓库！"/utf8>>};

get(1500142) ->
	#errorcode_msg{type = err150_lv_not_enough_gift,about = <<"兑换等级不足"/utf8>>};

get(1500143) ->
	#errorcode_msg{type = err150_gift_card_racharge_not_enough,about = <<"充值金额不足"/utf8>>};

get(1500144) ->
	#errorcode_msg{type = err150_gift_card_use_count_not_enough,about = <<"卡号使用次数不足"/utf8>>};

get(1500145) ->
	#errorcode_msg{type = err150_drop_guild_diff,about = <<"本掉落只能归属结社的玩家才能拾取"/utf8>>};

get(1510001) ->
	#errorcode_msg{type = err151_not_sell_category,about = <<"该类型物品不允许出售"/utf8>>};

get(1510002) ->
	#errorcode_msg{type = err151_sell_times_limit,about = <<"今日购买次数已满！"/utf8>>};

get(1510003) ->
	#errorcode_msg{type = err151_specify_sell_times_limit,about = <<"您与该玩家交易太过频繁，无法再进行交易。"/utf8>>};

get(1510004) ->
	#errorcode_msg{type = err151_max_sell_up_num,about = <<"已达到商品上架上限"/utf8>>};

get(1510005) ->
	#errorcode_msg{type = err151_goods_info_err,about = <<"商品信息有误，请重新打开界面"/utf8>>};

get(1510006) ->
	#errorcode_msg{type = err151_goods_not_exist,about = <<"该商品已下架"/utf8>>};

get(1510007) ->
	#errorcode_msg{type = err151_not_seller,about = <<"该商品不属于你"/utf8>>};

get(1510008) ->
	#errorcode_msg{type = err151_no_null_cells,about = <<"背包已满，请先清理背包"/utf8>>};

get(1510009) ->
	#errorcode_msg{type = err151_specify_role_lv_not_enough,about = <<"对方未达到交易等级"/utf8>>};

get(1510010) ->
	#errorcode_msg{type = err151_can_not_buy_self_goods,about = <<"不能购买自己出售的商品"/utf8>>};

get(1510011) ->
	#errorcode_msg{type = err151_not_specify_role,about = <<"您不是改商品的指定购买者"/utf8>>};

get(1510012) ->
	#errorcode_msg{type = err151_bind_cannot_sell,about = <<"绑定物品不能出售"/utf8>>};

get(1510013) ->
	#errorcode_msg{type = err151_not_enough_gold,about = <<"勾玉不足"/utf8>>};

get(1510014) ->
	#errorcode_msg{type = err151_goods_sell_down,about = <<"商品已经下架，请重新刷新界面"/utf8>>};

get(1510015) ->
	#errorcode_msg{type = err151_vip_lv_not_enough,about = <<"贵族4及以上才可以发起指定交易哦"/utf8>>};

get(1510016) ->
	#errorcode_msg{type = err151_min_unit_price_lim,about = <<"{1}当前单价上限为{2}钻"/utf8>>};

get(1510017) ->
	#errorcode_msg{type = err151_max_unit_price_lim,about = <<"{1}当前单价下限为{2}钻"/utf8>>};

get(1510018) ->
	#errorcode_msg{type = err151_sell_up_once_num_lim,about = <<"{1}单次最多上架{2}个"/utf8>>};

get(1510019) ->
	#errorcode_msg{type = err151_seller_not_match,about = <<"商品出售者有误"/utf8>>};

get(1510020) ->
	#errorcode_msg{type = err151_seek_goods_info_err,about = <<"求购商品信息有误，请重新打开界面"/utf8>>};

get(1510021) ->
	#errorcode_msg{type = err151_can_not_sell_self_goods,about = <<"不能出售自己的求购商品"/utf8>>};

get(1510022) ->
	#errorcode_msg{type = err151_buyer_times_limit,about = <<"对方今日购买次数已满"/utf8>>};

get(1510023) ->
	#errorcode_msg{type = err151_no_seek_goods,about = <<"没有此求购商品"/utf8>>};

get(1510024) ->
	#errorcode_msg{type = err151_not_my_goods,about = <<"不是你的求购商品"/utf8>>};

get(1510025) ->
	#errorcode_msg{type = err151_seek_times_err,about = <<"最多同时能发起6个求购"/utf8>>};

get(1510026) ->
	#errorcode_msg{type = err151_cannot_seek_err,about = <<"今日购买次数已满，无法求购"/utf8>>};

get(1510027) ->
	#errorcode_msg{type = err151_today_got_max_gold,about = <<"此价格将会超过你今天市场交易额度上限"/utf8>>};

get(1510028) ->
	#errorcode_msg{type = err151_seller_today_got_max_gold,about = <<"卖家今天市场交易额度已使用完毕"/utf8>>};

get(1510029) ->
	#errorcode_msg{type = err151_shout_id_cd,about = <<"喊话冷却时间未到，请稍后再试！"/utf8>>};

get(1520001) ->
	#errorcode_msg{type = err152_expire_err,about = <<"装备已过有效期"/utf8>>};

get(1520002) ->
	#errorcode_msg{type = err152_lv_err,about = <<"未达到装备使用等级"/utf8>>};

get(1520003) ->
	#errorcode_msg{type = err152_location_err,about = <<"所在位置不符合"/utf8>>};

get(1520004) ->
	#errorcode_msg{type = err152_type_err,about = <<"物品类型不符"/utf8>>};

get(1520014) ->
	#errorcode_msg{type = err152_stren_limit,about = <<"已满级,替换高阶高品质装备可继续强化"/utf8>>};

get(1520017) ->
	#errorcode_msg{type = err152_missing_cfg,about = <<"缺失配置"/utf8>>};

get(1520019) ->
	#errorcode_msg{type = err152_equip_pos_err,about = <<"装备位置参数错误"/utf8>>};

get(1520020) ->
	#errorcode_msg{type = err152_stone_part_err,about = <<"该宝石不能镶嵌在本部位"/utf8>>};

get(1520024) ->
	#errorcode_msg{type = err152_pos_no_stone,about = <<"未镶嵌宝石"/utf8>>};

get(1520025) ->
	#errorcode_msg{type = err152_pos_no_equip,about = <<"请先穿戴装备"/utf8>>};

get(1520026) ->
	#errorcode_msg{type = err152_career_error,about = <<"职业不合适,不能穿戴"/utf8>>};

get(1520029) ->
	#errorcode_msg{type = err152_equip_type_error,about = <<"未知装备类型"/utf8>>};

get(1520035) ->
	#errorcode_msg{type = err152_has_stren_cant_unequip,about = <<"已强化过的装备无法卸下"/utf8>>};

get(1520036) ->
	#errorcode_msg{type = err152_max_stage,about = <<"装备已达最高阶"/utf8>>};

get(1520037) ->
	#errorcode_msg{type = err152_not_upgrade_stage_quality,about = <<"穿戴装备的品质或阶数不足"/utf8>>};

get(1520038) ->
	#errorcode_msg{type = err152_not_upgrade_stage_pos,about = <<"该部位装备不能进阶"/utf8>>};

get(1520039) ->
	#errorcode_msg{type = err152_not_enough_upgrade_stage_cost,about = <<"资源不足，无法进阶"/utf8>>};

get(1520040) ->
	#errorcode_msg{type = err152_not_equip_cannot_upgrade_stage,about = <<"未穿戴装备，不能进阶"/utf8>>};

get(1520041) ->
	#errorcode_msg{type = err152_has_unlock_wash_pos,about = <<"属性槽已经开启，不能重复开启"/utf8>>};

get(1520042) ->
	#errorcode_msg{type = err152_no_equip_cannot_wash,about = <<"穿戴装备后才可洗炼"/utf8>>};

get(1520043) ->
	#errorcode_msg{type = err152_wash_pos_locked,about = <<"属性槽未开启，不能进行洗炼"/utf8>>};

get(1520044) ->
	#errorcode_msg{type = err152_can_not_lock_all,about = <<"至少有一条属性未锁定时才可洗炼"/utf8>>};

get(1520045) ->
	#errorcode_msg{type = err152_has_wash_cant_unequip,about = <<"已洗炼过的装备无法卸下"/utf8>>};

get(1520046) ->
	#errorcode_msg{type = err152_wash_normal_cost_not_enough,about = <<"洗炼石不足，无法洗炼"/utf8>>};

get(1520047) ->
	#errorcode_msg{type = err152_wash_extra_cost_not_enough,about = <<"勾玉不足，无法洗炼"/utf8>>};

get(1520048) ->
	#errorcode_msg{type = err152_role_lv_not_satisfy_wash_lv,about = <<"该部位未解锁"/utf8>>};

get(1520049) ->
	#errorcode_msg{type = err152_attr_num_not_satisfy_division,about = <<"4条属性槽均开启后可升段，升段后洗炼属性范围提高！"/utf8>>};

get(1520050) ->
	#errorcode_msg{type = err152_no_equip_can_not_upgrade_division,about = <<"穿戴装备后才可神铸"/utf8>>};

get(1520051) ->
	#errorcode_msg{type = err152_rating_not_satisfy_division,about = <<"洗炼评分低于升段评分，无法升段"/utf8>>};

get(1520052) ->
	#errorcode_msg{type = err152_max_division,about = <<"已达最高段位"/utf8>>};

get(1520053) ->
	#errorcode_msg{type = err152_stone_pos_lock,about = <<"宝石孔未解锁"/utf8>>};

get(1520054) ->
	#errorcode_msg{type = err152_max_refine_lv,about = <<"已雕刻至最高等级"/utf8>>};

get(1520055) ->
	#errorcode_msg{type = err152_has_refine_cant_unequip,about = <<"已进行宝石精炼的装备无法卸下"/utf8>>};

get(1520056) ->
	#errorcode_msg{type = err152_make_suit_error,about = <<"共鸣打造条件不足"/utf8>>};

get(1520057) ->
	#errorcode_msg{type = err152_casting_spirit_pos_lock,about = <<"该部位未解锁"/utf8>>};

get(1520059) ->
	#errorcode_msg{type = err152_casting_spirit_lv_lim,about = <<"已达到本阶等级上限"/utf8>>};

get(1520060) ->
	#errorcode_msg{type = err152_casting_spirit_equip_stage_not_enough,about = <<"装备阶数不足，无法铸灵"/utf8>>};

get(1520061) ->
	#errorcode_msg{type = err152_casting_spirit_max_lv,about = <<"铸灵达到满级"/utf8>>};

get(1520062) ->
	#errorcode_msg{type = err152_casting_spirit_material_not_enough,about = <<"资源不足，铸灵失败"/utf8>>};

get(1520063) ->
	#errorcode_msg{type = err152_spirit_max_lv,about = <<"已达满级，不能继续培养"/utf8>>};

get(1520064) ->
	#errorcode_msg{type = err152_upgrade_spirit_material_not_enough,about = <<"资源不足，提升护灵等级失败"/utf8>>};

get(1520065) ->
	#errorcode_msg{type = err152_has_awakening_cant_unequip,about = <<"觉醒后的装备不能卸下"/utf8>>};

get(1520066) ->
	#errorcode_msg{type = err152_not_awakening_equip,about = <<"9阶2星橙装以上可觉醒"/utf8>>};

get(1520067) ->
	#errorcode_msg{type = err152_awakening_lv_lim,about = <<"已达当前觉醒上限"/utf8>>};

get(1520068) ->
	#errorcode_msg{type = err152_awakening_cost_not_enough,about = <<"资源不足，无法觉醒"/utf8>>};

get(1520069) ->
	#errorcode_msg{type = err152_sex_error,about = <<"性别不合适，不能穿戴"/utf8>>};

get(1520070) ->
	#errorcode_msg{type = err152_turn_error,about = <<"未达对应转生，不能穿戴"/utf8>>};

get(1520071) ->
	#errorcode_msg{type = err152_equip_skill_awakening_lim,about = <<"已觉醒装备才可附加唤魔技能"/utf8>>};

get(1520072) ->
	#errorcode_msg{type = err152_equip_skill_has_skill,about = <<"该装备已附加唤魔技能，请先拆解技能"/utf8>>};

get(1520073) ->
	#errorcode_msg{type = err152_equip_skill_cfg_err,about = <<"唤魔技能配置有误"/utf8>>};

get(1520074) ->
	#errorcode_msg{type = err152_equip_skill_skill_type_lim,about = <<"当前装备部位无法附加此类型技能"/utf8>>};

get(1520075) ->
	#errorcode_msg{type = err152_equip_skill_no_cost_to_add_skill,about = <<"资源不足，附加技能失败"/utf8>>};

get(1520076) ->
	#errorcode_msg{type = err152_equip_skill_no_skill_to_remove,about = <<"该装备未附加唤魔技能"/utf8>>};

get(1520077) ->
	#errorcode_msg{type = err152_equip_skill_no_cost_to_remove,about = <<"金币不足，拆解技能失败"/utf8>>};

get(1520078) ->
	#errorcode_msg{type = err152_equip_skill_no_cost_upgrade,about = <<"资源不足，提升失败"/utf8>>};

get(1520079) ->
	#errorcode_msg{type = err152_equip_skill_no_skill_to_upgrade,about = <<"该装备未附加唤魔技能"/utf8>>};

get(1520080) ->
	#errorcode_msg{type = err152_equip_skill_skill_lv_lim,about = <<"当前技能等级已达上限"/utf8>>};

get(1520081) ->
	#errorcode_msg{type = err152_refine_limit,about = <<"精炼等级上限"/utf8>>};

get(1520082) ->
	#errorcode_msg{type = err152_stone_max_lv,about = <<"宝石已达最大等级"/utf8>>};

get(1520083) ->
	#errorcode_msg{type = err152_stone_not_enough,about = <<"宝石不足"/utf8>>};

get(1520084) ->
	#errorcode_msg{type = err152_equip_stren_wrong,about = <<"一键强化失败"/utf8>>};

get(1520085) ->
	#errorcode_msg{type = err152_equip_refine_wrong,about = <<"一键精炼失败"/utf8>>};

get(1520086) ->
	#errorcode_msg{type = err152_stone_refine_limit,about = <<"精炼条件不满足"/utf8>>};

get(1520087) ->
	#errorcode_msg{type = err152_no_order,about = <<"槽位没有按顺序开启"/utf8>>};

get(1520088) ->
	#errorcode_msg{type = err152_suit_stage_max,about = <<"当前已达最大阶数"/utf8>>};

get(1520089) ->
	#errorcode_msg{type = err152_not_make_suit,about = <<"还没打造共鸣"/utf8>>};

get(1520090) ->
	#errorcode_msg{type = err152_stren_no_goods,about = <<"铜币不足"/utf8>>};

get(1520091) ->
	#errorcode_msg{type = err152_refine_no_goods,about = <<"精炼物品不足"/utf8>>};

get(1520092) ->
	#errorcode_msg{type = err152_suit_stage_max_2,about = <<"请更换高阶装备继续打造~"/utf8>>};

get(1520093) ->
	#errorcode_msg{type = err152_cannot_equip_lower_suit_equip,about = <<"你已激活共鸣，不能替换品质低于共鸣激活的装备"/utf8>>};

get(1520094) ->
	#errorcode_msg{type = err152_god_equip_max_lv,about = <<"神装达到满阶，无法继续升阶"/utf8>>};

get(1520095) ->
	#errorcode_msg{type = err152_not_equip_anything,about = <<"请先穿戴装备"/utf8>>};

get(1520096) ->
	#errorcode_msg{type = err152_equip_stage_star_limit,about = <<"{1}阶及以上并且星数大于{2}的装备才可以打造"/utf8>>};

get(1520097) ->
	#errorcode_msg{type = err152_no_wash_free_times,about = <<"没有洗炼免费次数"/utf8>>};

get(1520098) ->
	#errorcode_msg{type = err152_not_clt_stage,about = <<"激活数量错误"/utf8>>};

get(1520099) ->
	#errorcode_msg{type = err152_suit_clt_is_active,about = <<"当前阶段已激活"/utf8>>};

get(1520100) ->
	#errorcode_msg{type = err152_suit_clt_turn_err,about = <<"转生等级不足"/utf8>>};

get(1520101) ->
	#errorcode_msg{type = err152_equip_not_enough,about = <<"装备不满足条件"/utf8>>};

get(1520102) ->
	#errorcode_msg{type = err152_fashion_weared,about = <<"外观已穿戴"/utf8>>};

get(1520103) ->
	#errorcode_msg{type = err152_fashion_unweared,about = <<"外观未穿戴"/utf8>>};

get(1520104) ->
	#errorcode_msg{type = err152_no_such_suit_lv,about = <<"非法共鸣类型！"/utf8>>};

get(1520105) ->
	#errorcode_msg{type = err152_pre_suit_not_activate,about = <<"请先激活前置共鸣！"/utf8>>};

get(1530000) ->
	#errorcode_msg{type = err153_goods_not_on_sale,about = <<"商品不在架上"/utf8>>};

get(1530001) ->
	#errorcode_msg{type = err153_goods_sold_out,about = <<"该道具已售空，请耐心等待补货。"/utf8>>};

get(1530002) ->
	#errorcode_msg{type = err153_goods_not_equal,about = <<"数据错误"/utf8>>};

get(1530003) ->
	#errorcode_msg{type = err153_bag_not_enough,about = <<"您拥有的背包空间不足，请清理后再来。"/utf8>>};

get(1530004) ->
	#errorcode_msg{type = err153_give_goods_failure,about = <<"派送物品失败"/utf8>>};

get(1530005) ->
	#errorcode_msg{type = err153_not_enough_goods_to_buy,about = <<"购买数量超过上限"/utf8>>};

get(1530006) ->
	#errorcode_msg{type = err153_money_type_wrong,about = <<"不能用此金钱支付"/utf8>>};

get(1530007) ->
	#errorcode_msg{type = err153_send_error,about = <<"请求错误"/utf8>>};

get(1530008) ->
	#errorcode_msg{type = err153_not_enough_world_lv,about = <<"世界等级未到达购买要求！"/utf8>>};

get(1530009) ->
	#errorcode_msg{type = err153_not_enough_server_time,about = <<"开服天数未达到购买要求！"/utf8>>};

get(1530010) ->
	#errorcode_msg{type = err153_not_enough_lv,about = <<"您的等级不符合购买要求！"/utf8>>};

get(1530011) ->
	#errorcode_msg{type = err153_qb_not_right_money,about = <<"不能用这种货币购买"/utf8>>};

get(1530012) ->
	#errorcode_msg{type = err153_price_err,about = <<"价格错误"/utf8>>};

get(1530013) ->
	#errorcode_msg{type = err153_missing_config,about = <<"商品没有配置"/utf8>>};

get(1530014) ->
	#errorcode_msg{type = err153_out_config,about = <<"未达到购买要求"/utf8>>};

get(1530015) ->
	#errorcode_msg{type = err153_enough_turn_stage,about = <<"转生阶级不符合要求"/utf8>>};

get(1530016) ->
	#errorcode_msg{type = err153_top_pk_grade,about = <<"巅峰竞技的段位未达要求"/utf8>>};

get(1530017) ->
	#errorcode_msg{type = err153_must_buy_pre_shop,about = <<"必须先购买前置物品"/utf8>>};

get(1530018) ->
	#errorcode_msg{type = err153_supvip_right_not_to_buy,about = <<"需激活至尊vip才可购买"/utf8>>};

get(1530019) ->
	#errorcode_msg{type = err153_kf_rank_level_err,about = <<"天境试炼层数不足"/utf8>>};

get(1530020) ->
	#errorcode_msg{type = err153_attr_not_enougth,about = <<"当前神祭属性不足，无法兑换"/utf8>>};

get(1530021) ->
	#errorcode_msg{type = err153_attr_constellation_not_active,about = <<"请先激活{1}装备页"/utf8>>};

get(1530022) ->
	#errorcode_msg{type = err153_god_pool_lv,about = <<"当前奖池等级不足，无法购买"/utf8>>};

get(1530023) ->
	#errorcode_msg{type = err153_guild_lv,about = <<"结社等级不足"/utf8>>};

get(1540001) ->
	#errorcode_msg{type = err154_error_pricetype,about = <<"非法竞价类型"/utf8>>};

get(1540002) ->
	#errorcode_msg{type = err154_missing_config,about = <<"缺失物品配置"/utf8>>};

get(1540003) ->
	#errorcode_msg{type = err154_goods_sellout,about = <<"物品已拍出"/utf8>>};

get(1540004) ->
	#errorcode_msg{type = err154_price_change,about = <<"竞价已发生变化"/utf8>>};

get(1540005) ->
	#errorcode_msg{type = err154_error_price,about = <<"价格参数错误"/utf8>>};

get(1540006) ->
	#errorcode_msg{type = err154_goods_closed,about = <<"该物品已结束拍卖~"/utf8>>};

get(1540007) ->
	#errorcode_msg{type = err154_player_top_price,about = <<"你当前已是最高竞价者"/utf8>>};

get(1540008) ->
	#errorcode_msg{type = err154_error_guild_id,about = <<"不是你所在结社物品"/utf8>>};

get(1540009) ->
	#errorcode_msg{type = err154_auction_not_start,about = <<"拍卖未开启，请稍加等待"/utf8>>};

get(1540010) ->
	#errorcode_msg{type = err154_only_pay_by_gold,about = <<"本商品只能使用勾玉参与拍卖"/utf8>>};

get(1540011) ->
	#errorcode_msg{type = err154_error_args,about = <<"操作无效，参数错误"/utf8>>};

get(1540012) ->
	#errorcode_msg{type = err154_error_goods,about = <<"物品已上架拍卖"/utf8>>};

get(1540013) ->
	#errorcode_msg{type = err154_in_init,about = <<"请稍后再试，数据初始化中"/utf8>>};

get(1540014) ->
	#errorcode_msg{type = err154_daily_count_over,about = <<"该拍品今日购买次数已用完！"/utf8>>};

get(1540015) ->
	#errorcode_msg{type = err154_week_count_over,about = <<"该拍品本周购买次数已用完！"/utf8>>};

get(1550001) ->
	#errorcode_msg{type = err155_cannot_takeoff_stren,about = <<"已强化过的圣纹无法卸下"/utf8>>};

get(1550002) ->
	#errorcode_msg{type = err155_stren_stage_limit,about = <<"强化等级超过当前装备强化上限"/utf8>>};

get(1550003) ->
	#errorcode_msg{type = err155_stren_no_equip,about = <<"需要穿戴圣纹才能强化"/utf8>>};

get(1550004) ->
	#errorcode_msg{type = err150_soul_count_limit,about = <<"当前使用次数已达上限"/utf8>>};

get(1570001) ->
	#errorcode_msg{type = err157_1_live_not_enough,about = <<"活跃度不够"/utf8>>};

get(1570002) ->
	#errorcode_msg{type = err157_2_live_aready_get,about = <<"不能重复领取"/utf8>>};

get(1570003) ->
	#errorcode_msg{type = err157_3_bag_not_enough,about = <<"背包不足"/utf8>>};

get(1570004) ->
	#errorcode_msg{type = err157_4_lv_not_enough,about = <<"等级不足，无法打开活动日历"/utf8>>};

get(1570005) ->
	#errorcode_msg{type = err157_5_cfg_err,about = <<"配置错误"/utf8>>};

get(1570006) ->
	#errorcode_msg{type = err157_6_live_not_enough,about = <<"完成日常任务可获得活跃度！"/utf8>>};

get(1570007) ->
	#errorcode_msg{type = err157_7_max_lv,about = <<"活跃度等级已达最高"/utf8>>};

get(1570008) ->
	#errorcode_msg{type = err157_8_live_lv_limit,about = <<"形象暂未激活"/utf8>>};

get(1570009) ->
	#errorcode_msg{type = err157_9_open_day_limit,about = <<"开服天数不足"/utf8>>};

get(1570010) ->
	#errorcode_msg{type = err157_act_not_open,about = <<"活动未开启"/utf8>>};

get(1570011) ->
	#errorcode_msg{type = err157_figure_already,about = <<"已幻化当前形象"/utf8>>};

get(1570012) ->
	#errorcode_msg{type = err157_open_lv,about = <<"角色等级不够"/utf8>>};

get(1570013) ->
	#errorcode_msg{type = err157_no_res_act,about = <<"没有这个活动"/utf8>>};

get(1570014) ->
	#errorcode_msg{type = err157_no_more_times,about = <<"找回次数不够"/utf8>>};

get(1570015) ->
	#errorcode_msg{type = err157_same_figure_id,about = <<"形象幻化中"/utf8>>};

get(1570016) ->
	#errorcode_msg{type = err157_not_have_get_live,about = <<"没有可以领取的活跃度"/utf8>>};

get(1570017) ->
	#errorcode_msg{type = err157_error_act,about = <<"该活动不能报名"/utf8>>};

get(1570018) ->
	#errorcode_msg{type = err157_act_open,about = <<"活动开启中"/utf8>>};

get(1570019) ->
	#errorcode_msg{type = err157_have_sign_up,about = <<"已经报名该活动"/utf8>>};

get(1580001) ->
	#errorcode_msg{type = err158_time_error,about = <<"该充值商品暂未开启"/utf8>>};

get(1580002) ->
	#errorcode_msg{type = err158_condition_error,about = <<"您不符合该充值商品使用条件"/utf8>>};

get(1580003) ->
	#errorcode_msg{type = err158_product_error,about = <<"该充值商品缺失基础配置"/utf8>>};

get(1580004) ->
	#errorcode_msg{type = err158_product_ctrl_error,about = <<"该充值商品缺失控制信息配置"/utf8>>};

get(1580005) ->
	#errorcode_msg{type = err158_recharge_return_error,about = <<"该充值商品缺失返利配置"/utf8>>};

get(1580006) ->
	#errorcode_msg{type = err158_product_type_error,about = <<"未知充值商品类型"/utf8>>};

get(1580007) ->
	#errorcode_msg{type = err158_already_buy,about = <<"已购买该充值商品"/utf8>>};

get(1580008) ->
	#errorcode_msg{type = err158_not_open,about = <<"该充值商品暂未开放，敬请期待！"/utf8>>};

get(1580009) ->
	#errorcode_msg{type = err158_not_enough_world_lv,about = <<"世界等级未到达购买要求！"/utf8>>};

get(1590001) ->
	#errorcode_msg{type = err159_daily_type_err,about = <<"每日礼包类型错误!"/utf8>>};

get(1590002) ->
	#errorcode_msg{type = err159_daily_purchased,about = <<"今天礼包已经被购买~"/utf8>>};

get(1590003) ->
	#errorcode_msg{type = err159_daily_cfg_err,about = <<"礼包配置错误~"/utf8>>};

get(1590004) ->
	#errorcode_msg{type = err159_daily_not_purchase,about = <<"礼包未购买,领取失败~"/utf8>>};

get(1590005) ->
	#errorcode_msg{type = err159_daily_is_get,about = <<"礼包已经领取,无法再次领取~"/utf8>>};

get(1590006) ->
	#errorcode_msg{type = err159_1_not_welfare,about = <<"非福利卡"/utf8>>};

get(1590007) ->
	#errorcode_msg{type = err159_2_welfare_timeout,about = <<"福利卡已过期"/utf8>>};

get(1590008) ->
	#errorcode_msg{type = err159_3_not_buy,about = <<"未购买相关产品"/utf8>>};

get(1590009) ->
	#errorcode_msg{type = err159_4_already_get,about = <<"已领取"/utf8>>};

get(1590010) ->
	#errorcode_msg{type = err159_5_bag_not_enough,about = <<"背包已满"/utf8>>};

get(1590012) ->
	#errorcode_msg{type = err159_vip_not_enough,about = <<"贵族等级不足！"/utf8>>};

get(1590013) ->
	#errorcode_msg{type = err159_not_the_time,about = <<"领取时间未到"/utf8>>};

get(1590014) ->
	#errorcode_msg{type = err159_5_not_reach_openday,about = <<"开服天数未达到条件"/utf8>>};

get(1600003) ->
	#errorcode_msg{type = err160_3_figure_inactive,about = <<"外形未激活"/utf8>>};

get(1600008) ->
	#errorcode_msg{type = err160_8_mount_scene_limit,about = <<"当前场景不可骑乘坐骑"/utf8>>};

get(1600009) ->
	#errorcode_msg{type = err160_9_config_err,about = <<"配置错误"/utf8>>};

get(1600010) ->
	#errorcode_msg{type = err160_10_exp_max,about = <<"已满级"/utf8>>};

get(1600011) ->
	#errorcode_msg{type = err160_figure_has_sel,about = <<"幻化中，不能重复操作"/utf8>>};

get(1600012) ->
	#errorcode_msg{type = err160_max_goods_use_times,about = <<"已达提升上限"/utf8>>};

get(1600013) ->
	#errorcode_msg{type = err160_max_star,about = <<"已达满星级，无法继续升星"/utf8>>};

get(1600014) ->
	#errorcode_msg{type = err160_not_enough_cost,about = <<"资源不足，无法提升"/utf8>>};

get(1600015) ->
	#errorcode_msg{type = err160_figure_not_active,about = <<"坐骑形象未激活"/utf8>>};

get(1600016) ->
	#errorcode_msg{type = err160_figure_max_stage,about = <<"已达满阶，无法继续提升"/utf8>>};

get(1600017) ->
	#errorcode_msg{type = err160_equip_stage_limit,about = <<"坐骑未达指定阶数"/utf8>>};

get(1600018) ->
	#errorcode_msg{type = err160_equip_stren_stage_limit,about = <<"需升阶"/utf8>>};

get(1600019) ->
	#errorcode_msg{type = err160_equip_stren_no_equip,about = <<"未穿戴装备"/utf8>>};

get(1600020) ->
	#errorcode_msg{type = err160_equip_not_enough_lv,about = <<"需升级"/utf8>>};

get(1600021) ->
	#errorcode_msg{type = err160_equip_stren_max_stage,about = <<"已满阶"/utf8>>};

get(1600022) ->
	#errorcode_msg{type = err160_equip_engrave_color_limit,about = <<"品质限制"/utf8>>};

get(1600023) ->
	#errorcode_msg{type = err160_pet_lv_limit,about = <<"未达到激活条件"/utf8>>};

get(1600024) ->
	#errorcode_msg{type = err160_typeid_wrong,about = <<"外形类型错误"/utf8>>};

get(1600025) ->
	#errorcode_msg{type = err160_figure_id_wrong,about = <<"外形的幻化类型错误"/utf8>>};

get(1600026) ->
	#errorcode_msg{type = err160_figure_already_active,about = <<"外形已激活"/utf8>>};

get(1600027) ->
	#errorcode_msg{type = err160_temp_figure,about = <<"临时幻型不可升阶"/utf8>>};

get(1600028) ->
	#errorcode_msg{type = err160_not_enough_turn,about = <<"转生等级不足"/utf8>>};

get(1600029) ->
	#errorcode_msg{type = err160_equip_not,about = <<"不是外形装备"/utf8>>};

get(1600030) ->
	#errorcode_msg{type = err160_equip_not_pos,about = <<"没有该形象的装备部位"/utf8>>};

get(1600031) ->
	#errorcode_msg{type = err160_equip_not_right_pos,about = <<"不是对应外形装备部位"/utf8>>};

get(1600032) ->
	#errorcode_msg{type = err160_equip_not_wear_con,about = <<"未达到装备穿戴条件"/utf8>>};

get(1600033) ->
	#errorcode_msg{type = err160_devour_max_lv,about = <<"外形吞噬已达最大等级"/utf8>>};

get(1600034) ->
	#errorcode_msg{type = err160_on_battle_status_not_to_ride,about = <<"处于战斗状态无法骑乘"/utf8>>};

get(1600035) ->
	#errorcode_msg{type = err160_bgold_zero,about = <<"绑玉余额不足"/utf8>>};

get(1600036) ->
	#errorcode_msg{type = err160_gold_zero,about = <<"勾玉余额不足"/utf8>>};

get(1600037) ->
	#errorcode_msg{type = err160_stage_up_first,about = <<"等级达到当前阶最大等级"/utf8>>};

get(1600038) ->
	#errorcode_msg{type = err160_up_star_first,about = <<"星数/等级未达到升阶要求"/utf8>>};

get(1600039) ->
	#errorcode_msg{type = err160_more_blessing_need,about = <<"经验值未达到等级上限"/utf8>>};

get(1600040) ->
	#errorcode_msg{type = err160_figure_color_cfg_missing,about = <<"颜色配置缺失"/utf8>>};

get(1600041) ->
	#errorcode_msg{type = err160_figure_color_not_active,about = <<"该颜色未达到使用等级"/utf8>>};

get(1600042) ->
	#errorcode_msg{type = err160_figure_color_level_max,about = <<"已经达到最大等级，无须再次染色了"/utf8>>};

get(1600043) ->
	#errorcode_msg{type = err160_not_exp_goods,about = <<"非经验道具无法使用"/utf8>>};

get(1600044) ->
	#errorcode_msg{type = err160_no_goods_upgrade,about = <<"道具不足，无法升级"/utf8>>};

get(1600045) ->
	#errorcode_msg{type = err160_no_skill_can_upgrade,about = <<"不满足技能升级升级条件"/utf8>>};

get(1600046) ->
	#errorcode_msg{type = err160_skill_no_exist,about = <<"不存在该技能"/utf8>>};

get(1610001) ->
	#errorcode_msg{type = err161_already_active,about = <<"已经激活！"/utf8>>};

get(1610002) ->
	#errorcode_msg{type = err161_figure_unactive,about = <<"羽翼形象未激活"/utf8>>};

get(1610003) ->
	#errorcode_msg{type = err161_not_enough_cost,about = <<"资源不足"/utf8>>};

get(1610004) ->
	#errorcode_msg{type = err161_max_goods_use_times,about = <<"达到次数上限"/utf8>>};

get(1610005) ->
	#errorcode_msg{type = err161_max_lv,about = <<"已达满级"/utf8>>};

get(1610006) ->
	#errorcode_msg{type = err161_max_star,about = <<"化形到达满星"/utf8>>};

get(1610007) ->
	#errorcode_msg{type = err161_not_turn,about = <<"未到达转生数"/utf8>>};

get(1610008) ->
	#errorcode_msg{type = err161_figure_not_active,about = <<"尚未激活，无法幻化"/utf8>>};

get(1620001) ->
	#errorcode_msg{type = err162_figure_unactive,about = <<"形象未激活"/utf8>>};

get(1620002) ->
	#errorcode_msg{type = err162_up_ride,about = <<"已佩戴"/utf8>>};

get(1620003) ->
	#errorcode_msg{type = err162_not_up_ride,about = <<"已卸下"/utf8>>};

get(1620004) ->
	#errorcode_msg{type = err162_already_active,about = <<"形象已激活"/utf8>>};

get(1630001) ->
	#errorcode_msg{type = err163_already_active,about = <<"已经激活~"/utf8>>};

get(1630002) ->
	#errorcode_msg{type = err163_cfg_err,about = <<"配置出错~"/utf8>>};

get(1630003) ->
	#errorcode_msg{type = err163_exp_not_enough,about = <<"经验不足"/utf8>>};

get(1630004) ->
	#errorcode_msg{type = err163_max_lv,about = <<"已达最大等级"/utf8>>};

get(1630005) ->
	#errorcode_msg{type = err163_not_active,about = <<"未激活！"/utf8>>};

get(1630006) ->
	#errorcode_msg{type = err163_career_not_match,about = <<"职业不匹配"/utf8>>};

get(1640001) ->
	#errorcode_msg{type = err164_cant_active_repeat,about = <<"不能重复点亮命格"/utf8>>};

get(1640002) ->
	#errorcode_msg{type = err164_consume_not_enough,about = <<"道具不足，无法点亮"/utf8>>};

get(1640003) ->
	#errorcode_msg{type = err164_pre_not_active,about = <<"上一个命格未点亮"/utf8>>};

get(1640004) ->
	#errorcode_msg{type = err164_not_trigger_task,about = <<"请先接取任务"/utf8>>};

get(1650000) ->
	#errorcode_msg{type = err165_figure_not_active,about = <<"侍魂形象未激活"/utf8>>};

get(1650001) ->
	#errorcode_msg{type = err165_max_goods_use_times,about = <<"已达提升上限"/utf8>>};

get(1650002) ->
	#errorcode_msg{type = err165_max_star,about = <<"已达满星级，无法继续升星"/utf8>>};

get(1650003) ->
	#errorcode_msg{type = err165_figure_has_sel,about = <<"幻化中，不能重复操作"/utf8>>};

get(1650004) ->
	#errorcode_msg{type = err165_sel_null_goods,about = <<"未选择吞噬的资源"/utf8>>};

get(1650005) ->
	#errorcode_msg{type = err165_max_lv,about = <<"已达满级，无法吞噬"/utf8>>};

get(1650006) ->
	#errorcode_msg{type = err165_not_enough_cost,about = <<"资源不足，无法提升"/utf8>>};

get(1650007) ->
	#errorcode_msg{type = err165_not_cost_res,about = <<"该资源不能吞噬"/utf8>>};

get(1650008) ->
	#errorcode_msg{type = err165_figure_max_stage,about = <<"已达满阶，无法继续提升"/utf8>>};

get(1650009) ->
	#errorcode_msg{type = err165_pet_aircraft_not_active,about = <<"该飞行器未激活"/utf8>>};

get(1650010) ->
	#errorcode_msg{type = err165_pet_aircraft_play,about = <<"该侍魂飞行器正在使用中"/utf8>>};

get(1650011) ->
	#errorcode_msg{type = err165_pet_aircraft_not_pass,about = <<"指定飞行器的阶数不够，无法进行激活"/utf8>>};

get(1650012) ->
	#errorcode_msg{type = err165_pet_wing_not_active,about = <<"该侍魂羽翼未激活"/utf8>>};

get(1650013) ->
	#errorcode_msg{type = err165_pet_wing_play,about = <<"该侍魂羽翼正在使用中"/utf8>>};

get(1650014) ->
	#errorcode_msg{type = err165_pet_wing_not_pass,about = <<"指定侍魂羽翼的阶数不够，无法进行激活"/utf8>>};

get(1650015) ->
	#errorcode_msg{type = err165_pet_equip_not,about = <<"不是侍魂装备"/utf8>>};

get(1650016) ->
	#errorcode_msg{type = err165_pet_equip_not_pos,about = <<"没有该侍魂装备部位"/utf8>>};

get(1650017) ->
	#errorcode_msg{type = err165_pet_equip_not_right_pos,about = <<"不是对应的侍魂装备部位"/utf8>>};

get(1650018) ->
	#errorcode_msg{type = err165_pet_equip_not_already_wear,about = <<"未达侍魂装备穿戴条件"/utf8>>};

get(1650019) ->
	#errorcode_msg{type = err165_pet_equip_not_right_cost,about = <<"消耗品不正确"/utf8>>};

get(1650020) ->
	#errorcode_msg{type = err165_pet_equip_lv_max,about = <<"已达到当前最大强化等级"/utf8>>};

get(1650021) ->
	#errorcode_msg{type = err165_pet_equip_cost_not,about = <<"消耗品不存在"/utf8>>};

get(1650022) ->
	#errorcode_msg{type = err165_pet_equip_bag_full,about = <<"伙伴背包已满"/utf8>>};

get(1650023) ->
	#errorcode_msg{type = err165_pet_equip_stage_max,about = <<"已达最高阶"/utf8>>};

get(1650024) ->
	#errorcode_msg{type = err165_pet_equip_star_max,about = <<"已达最高星"/utf8>>};

get(1660001) ->
	#errorcode_msg{type = err166_juewei_max,about = <<"爵位已达上限"/utf8>>};

get(1660002) ->
	#errorcode_msg{type = err166_juewei_power_max,about = <<"战力未达到"/utf8>>};

get(1670002) ->
	#errorcode_msg{type = err167_not_rune,about = <<"该物品不是御魂"/utf8>>};

get(1670003) ->
	#errorcode_msg{type = err167_have_wear,about = <<"该御魂已经穿戴"/utf8>>};

get(1670004) ->
	#errorcode_msg{type = err167_cant_wear,about = <<"该御魂不能被镶嵌"/utf8>>};

get(1670005) ->
	#errorcode_msg{type = err167_not_pos,about = <<"没有该部位"/utf8>>};

get(1670006) ->
	#errorcode_msg{type = err167_pos_not_active,about = <<"该部位未被激活"/utf8>>};

get(1670007) ->
	#errorcode_msg{type = err167_subtype_have_wear,about = <<"已经装备该子类型"/utf8>>};

get(1670008) ->
	#errorcode_msg{type = err167_level_max,about = <<"御魂等级已达上限"/utf8>>};

get(1670009) ->
	#errorcode_msg{type = err167_exp_not_enough,about = <<"御魂经验不足"/utf8>>};

get(1670010) ->
	#errorcode_msg{type = err167_exchange_not_open,about = <<"该物品未开启兑换"/utf8>>};

get(1670011) ->
	#errorcode_msg{type = err167_runechip_not_enough,about = <<"碎片不足"/utf8>>};

get(1670012) ->
	#errorcode_msg{type = err167_goods_fail,about = <<"物品不存在,或者不是御魂"/utf8>>};

get(1670013) ->
	#errorcode_msg{type = err167_err_rune_subtype,about = <<"该御魂不能镶嵌在该孔位"/utf8>>};

get(1670014) ->
	#errorcode_msg{type = err167_attr_conflict,about = <<"已镶嵌该属性类型御魂"/utf8>>};

get(1670015) ->
	#errorcode_msg{type = err167_not_cost_self_to_awake,about = <<"不能消耗本身的源力去觉醒"/utf8>>};

get(1670016) ->
	#errorcode_msg{type = err167_not_cost_awake_rune,about = <<"不能消耗觉醒的御魂"/utf8>>};

get(1670017) ->
	#errorcode_msg{type = err167_awake_cost_color_limit,about = <<"只有橙色以上的品质才能吞噬"/utf8>>};

get(1670018) ->
	#errorcode_msg{type = err167_awake_color_limit,about = <<"只有橙色以上的品质才能觉醒"/utf8>>};

get(1670019) ->
	#errorcode_msg{type = err167_attr_different,about = <<"属性不同"/utf8>>};

get(1670020) ->
	#errorcode_msg{type = err167_no_awake_single_attr_not_to_dismantle,about = <<"没有觉醒的单属性源力无法拆解"/utf8>>};

get(1670021) ->
	#errorcode_msg{type = err167_multi_attr_num_not_to_decompose,about = <<"多属性无法分解"/utf8>>};

get(1670022) ->
	#errorcode_msg{type = err167_awake_not_to_decompose,about = <<"觉醒的无法分解"/utf8>>};

get(1670023) ->
	#errorcode_msg{type = err167_max_skill_lv,about = <<"御魂技能等级已经最大"/utf8>>};

get(1670024) ->
	#errorcode_msg{type = err167_can_not_up_rune_skill,about = <<"激活条件不满足"/utf8>>};

get(1680001) ->
	#errorcode_msg{type = err168_already_active,about = <<"已经激活！"/utf8>>};

get(1680002) ->
	#errorcode_msg{type = err168_figure_unactive,about = <<"法宝形象未激活"/utf8>>};

get(1680003) ->
	#errorcode_msg{type = err168_not_enough_cost,about = <<"资源不足"/utf8>>};

get(1680004) ->
	#errorcode_msg{type = err168_max_goods_use_times,about = <<"达到次数上限"/utf8>>};

get(1680005) ->
	#errorcode_msg{type = err168_max_lv,about = <<"已达满级"/utf8>>};

get(1680006) ->
	#errorcode_msg{type = err168_max_star,about = <<"化形到达满星"/utf8>>};

get(1680007) ->
	#errorcode_msg{type = err168_not_turn,about = <<"未到达转生数"/utf8>>};

get(1680008) ->
	#errorcode_msg{type = err168_figure_not_active,about = <<"尚未激活，无法幻化"/utf8>>};

get(1690001) ->
	#errorcode_msg{type = err169_already_active,about = <<"已经激活！"/utf8>>};

get(1690002) ->
	#errorcode_msg{type = err169_figure_unactive,about = <<"神兵形象未激活"/utf8>>};

get(1690003) ->
	#errorcode_msg{type = err169_not_enough_cost,about = <<"资源不足"/utf8>>};

get(1690004) ->
	#errorcode_msg{type = err169_max_goods_use_times,about = <<"达到次数上限"/utf8>>};

get(1690005) ->
	#errorcode_msg{type = err169_max_lv,about = <<"已达满级"/utf8>>};

get(1690006) ->
	#errorcode_msg{type = err169_max_star,about = <<"化形到达满星"/utf8>>};

get(1690007) ->
	#errorcode_msg{type = err169_not_turn,about = <<"未到达转生数"/utf8>>};

get(1690008) ->
	#errorcode_msg{type = err169_figure_not_active,about = <<"尚未激活，无法幻化"/utf8>>};

get(1700001) ->
	#errorcode_msg{type = err170_not_exist,about = <<"该源力不存在"/utf8>>};

get(1700002) ->
	#errorcode_msg{type = err170_not_soul,about = <<"该物品不是源力"/utf8>>};

get(1700003) ->
	#errorcode_msg{type = err170_have_wear,about = <<"该源力已穿戴"/utf8>>};

get(1700004) ->
	#errorcode_msg{type = err170_cant_wear,about = <<"该御魂不能被镶嵌"/utf8>>};

get(1700005) ->
	#errorcode_msg{type = err170_not_pos,about = <<"没有该部位"/utf8>>};

get(1700006) ->
	#errorcode_msg{type = err170_pos_not_active,about = <<"该部位未激活"/utf8>>};

get(1700007) ->
	#errorcode_msg{type = err170_have_subtype_wear,about = <<"已经装备该子类型"/utf8>>};

get(1700008) ->
	#errorcode_msg{type = err170_pos_type_wrong,about = <<"源力物品槽位类型不正确"/utf8>>};

get(1700009) ->
	#errorcode_msg{type = err170_level_max,about = <<"已达上限"/utf8>>};

get(1700010) ->
	#errorcode_msg{type = err170_exp_not_enough,about = <<"源力经验不足"/utf8>>};

get(1700011) ->
	#errorcode_msg{type = err170_goods_fail,about = <<"物品不存在"/utf8>>};

get(1700012) ->
	#errorcode_msg{type = err170_multi_attr_num_not_to_decompose,about = <<"多属性无法分解"/utf8>>};

get(1700013) ->
	#errorcode_msg{type = err170_awake_not_to_decompose,about = <<"觉醒的无法分解"/utf8>>};

get(1700014) ->
	#errorcode_msg{type = err170_no_awake_single_attr_not_to_dismantle,about = <<"没有觉醒的单属性源力无法拆解"/utf8>>};

get(1700015) ->
	#errorcode_msg{type = err170_not_cost_awake_soul,about = <<"不能消耗觉醒的源力"/utf8>>};

get(1700016) ->
	#errorcode_msg{type = err170_not_cost_self_to_awake,about = <<"不能消耗本身的源力去觉醒"/utf8>>};

get(1710001) ->
	#errorcode_msg{type = err171_not_active,about = <<"未激活"/utf8>>};

get(1710002) ->
	#errorcode_msg{type = err171_max_lv,about = <<"已达最高等级"/utf8>>};

get(1710003) ->
	#errorcode_msg{type = err171_not_enough_points,about = <<"强化积分不足"/utf8>>};

get(1710004) ->
	#errorcode_msg{type = err171_max_enchant,about = <<"附灵属性已满"/utf8>>};

get(1710005) ->
	#errorcode_msg{type = err171_pre_lv,about = <<"等级不足"/utf8>>};

get(1710006) ->
	#errorcode_msg{type = err171_already_active,about = <<"已激活"/utf8>>};

get(1720001) ->
	#errorcode_msg{type = err172_ring_not_polish,about = <<"不是打磨的物品"/utf8>>};

get(1720002) ->
	#errorcode_msg{type = err172_marriage_max,about = <<"已达上限"/utf8>>};

get(1720003) ->
	#errorcode_msg{type = err172_marriage_not_pray,about = <<"不是祝福消耗品"/utf8>>};

get(1720004) ->
	#errorcode_msg{type = err172_personals_send_cd,about = <<"请求冷却中"/utf8>>};

get(1720005) ->
	#errorcode_msg{type = err172_couple_self_not_single,about = <<"自己非单身"/utf8>>};

get(1720006) ->
	#errorcode_msg{type = err172_couple_other_not_single,about = <<"对方非单身"/utf8>>};

get(1720007) ->
	#errorcode_msg{type = err172_couple_intimacy_not_enough,about = <<"亲密度不足"/utf8>>};

get(1720008) ->
	#errorcode_msg{type = err172_couple_not_same_sex,about = <<"性别一样"/utf8>>};

get(1720009) ->
	#errorcode_msg{type = err172_couple_not_biaobai_twice,about = <<"不能重复表白"/utf8>>};

get(1720010) ->
	#errorcode_msg{type = err172_fouple_have_not_biaobai,about = <<"对方没有向你表白"/utf8>>};

get(1720011) ->
	#errorcode_msg{type = err172_couple_not_self,about = <<"不能向自己求婚"/utf8>>};

get(1720012) ->
	#errorcode_msg{type = err172_couple_single,about = <<"单身中"/utf8>>};

get(1720013) ->
	#errorcode_msg{type = err172_couple_not_lover,about = <<"对方不是你的姻缘"/utf8>>};

get(1720014) ->
	#errorcode_msg{type = err172_couple_have_marry,about = <<"你们已经结婚"/utf8>>};

get(1720015) ->
	#errorcode_msg{type = err172_couple_not_propose_twice,about = <<"您已向TA发起求婚"/utf8>>};

get(1720016) ->
	#errorcode_msg{type = err172_marriage_life_not_marry,about = <<"未结婚"/utf8>>};

get(1720017) ->
	#errorcode_msg{type = err172_love_num_not_enough,about = <<"恩爱值不足"/utf8>>};

get(1720018) ->
	#errorcode_msg{type = err172_personals_not_player,about = <<"没有这个玩家"/utf8>>};

get(1720019) ->
	#errorcode_msg{type = err172_personals_cant_follow,about = <<"不能关注这个玩家"/utf8>>};

get(1720020) ->
	#errorcode_msg{type = err172_personals_not_following,about = <<"没有在关注这个玩家"/utf8>>};

get(1720021) ->
	#errorcode_msg{type = err172_couple_other_biaobai,about = <<"对方已向你表白"/utf8>>};

get(1720022) ->
	#errorcode_msg{type = err172_couple_other_propose,about = <<"对方已向你求婚"/utf8>>};

get(1720023) ->
	#errorcode_msg{type = err172_wedding_have_order,about = <<"婚礼已预约"/utf8>>};

get(1720024) ->
	#errorcode_msg{type = err172_wedding_over_day,about = <<"预约天数太后"/utf8>>};

get(1720025) ->
	#errorcode_msg{type = err172_wedding_not_time,about = <<"没有这个婚礼时间段"/utf8>>};

get(1720026) ->
	#errorcode_msg{type = err172_wedding_time_have_order,about = <<"该时间已经被预约"/utf8>>};

get(1720027) ->
	#errorcode_msg{type = err172_wedding_start,about = <<"婚礼已经开始"/utf8>>};

get(1720028) ->
	#errorcode_msg{type = err172_wedding_not_order,about = <<"还没预约婚礼"/utf8>>};

get(1720029) ->
	#errorcode_msg{type = err172_wedding_have_invite,about = <<"已经邀请过"/utf8>>};

get(1720030) ->
	#errorcode_msg{type = err172_wedding_guest_num_max,about = <<"宾客数量达到上限"/utf8>>};

get(1720031) ->
	#errorcode_msg{type = err172_wedding_guest_have_answer,about = <<"已经回复过"/utf8>>};

get(1720032) ->
	#errorcode_msg{type = err172_wedding_order_time_pass,about = <<"预订的时间已过"/utf8>>};

get(1720033) ->
	#errorcode_msg{type = err172_wedding_invite_success,about = <<"姻缘成功邀请了宾客"/utf8>>};

get(1720034) ->
	#errorcode_msg{type = err172_wedding_order_success,about = <<"姻缘成功预约了婚礼"/utf8>>};

get(1720035) ->
	#errorcode_msg{type = err172_wedding_buy_max_num_max,about = <<"邀请函已达最大购买上限"/utf8>>};

get(1720036) ->
	#errorcode_msg{type = err172_wedding_buy_max_num_success,about = <<"姻缘成功购买邀请函上限"/utf8>>};

get(1720037) ->
	#errorcode_msg{type = err172_wedding_not_start,about = <<"婚礼还没有开始"/utf8>>};

get(1720038) ->
	#errorcode_msg{type = err172_wedding_is_guest,about = <<"已经被邀请"/utf8>>};

get(1720039) ->
	#errorcode_msg{type = err172_wedding_already_ask,about = <<"已经索要过请柬"/utf8>>};

get(1720040) ->
	#errorcode_msg{type = err172_wedding_not_ask_invite,about = <<"玩家未索要请柬"/utf8>>};

get(1720041) ->
	#errorcode_msg{type = err172_wedding_not_guest,about = <<"你不是婚礼的宾客"/utf8>>};

get(1720042) ->
	#errorcode_msg{type = err172_wedding_not_scene,about = <<"不在婚礼场景里"/utf8>>};

get(1720043) ->
	#errorcode_msg{type = err172_wedding_not_owner,about = <<"你不是婚礼主人"/utf8>>};

get(1720044) ->
	#errorcode_msg{type = err172_wedding_not_invite_self,about = <<"不能邀请自己"/utf8>>};

get(1720045) ->
	#errorcode_msg{type = err172_wedding_not_have_solve,about = <<"要用{1}才能哄好{2}喔"/utf8>>};

get(1720046) ->
	#errorcode_msg{type = err172_wedding_tm_solve_success,about = <<"成功哄好{1}，获得{2}"/utf8>>};

get(1720047) ->
	#errorcode_msg{type = err172_wedding_mon_not_exist,about = <<"怪物不存在"/utf8>>};

get(1720048) ->
	#errorcode_msg{type = err172_wedding_not_scene_mon,about = <<"目标不在场景里"/utf8>>};

get(1720049) ->
	#errorcode_msg{type = err172_wedding_not_anime,about = <<"不在婚礼仪式期间"/utf8>>};

get(1720050) ->
	#errorcode_msg{type = err172_baby_have_active,about = <<"宝宝已经被激活"/utf8>>};

get(1720051) ->
	#errorcode_msg{type = err172_baby_not_image,about = <<"没有这个幻形"/utf8>>};

get(1720052) ->
	#errorcode_msg{type = err172_baby_not_active,about = <<"宝宝未激活"/utf8>>};

get(1720053) ->
	#errorcode_msg{type = err172_baby_image_have_active,about = <<"幻形已激活"/utf8>>};

get(1720054) ->
	#errorcode_msg{type = err172_baby_image_not_active,about = <<"幻形未激活"/utf8>>};

get(1720055) ->
	#errorcode_msg{type = err172_baby_have_not_resource,about = <<"该形象未获得"/utf8>>};

get(1720056) ->
	#errorcode_msg{type = err172_baby_already_resource,about = <<"已经装备改形象"/utf8>>};

get(1720057) ->
	#errorcode_msg{type = err172_baby_not_resource,about = <<"未装备宝宝形象"/utf8>>};

get(1720058) ->
	#errorcode_msg{type = err172_wedding_can_not_open_order,about = <<"婚礼已预约"/utf8>>};

get(1720059) ->
	#errorcode_msg{type = err172_wedding_can_not_order_same,about = <<"不能预约同一个时间"/utf8>>};

get(1720060) ->
	#errorcode_msg{type = err172_wedding_already_eat,about = <<"已经吃过"/utf8>>};

get(1720061) ->
	#errorcode_msg{type = err172_wedding_ask_invite_agree,about = <<"姻缘操作了索要请柬"/utf8>>};

get(1720062) ->
	#errorcode_msg{type = err172_df_cant_get,about = <<"不能拿本人发的狗粮"/utf8>>};

get(1720063) ->
	#errorcode_msg{type = err172_df_get_success,about = <<"成功领取狗粮，获得{1}金币"/utf8>>};

get(1720064) ->
	#errorcode_msg{type = err_df_have_get,about = <<"已经拿过这份狗粮"/utf8>>};

get(1720065) ->
	#errorcode_msg{type = err172_df_max,about = <<"这份狗粮已被分完"/utf8>>};

get(1720066) ->
	#errorcode_msg{type = err172_personals_is_fans,about = <<"已经是粉丝"/utf8>>};

get(1720067) ->
	#errorcode_msg{type = err172_personals_cant_follow_self,about = <<"不能关注自己"/utf8>>};

get(1720068) ->
	#errorcode_msg{type = err172_marriage_partner_lv_limit,about = <<"对方等级不足"/utf8>>};

get(1720069) ->
	#errorcode_msg{type = err172_wedding_not_invite,about = <<"没有被邀请"/utf8>>};

get(1720070) ->
	#errorcode_msg{type = err172_marriage_ask_lv_limit,about = <<"等级达到130才能参加婚礼喔"/utf8>>};

get(1720071) ->
	#errorcode_msg{type = err172_wedding_fires_success,about = <<"成功点燃{1}"/utf8>>};

get(1720072) ->
	#errorcode_msg{type = err172_wedding_candies_success,about = <<"恭喜获得{1}({2}/{3})"/utf8>>};

get(1720073) ->
	#errorcode_msg{type = err172_wedding_tm_limit,about = <<"本次安抚小捣蛋次数已满"/utf8>>};

get(1720074) ->
	#errorcode_msg{type = err172_wedding_nc_limit,about = <<"本次食用普通喜糖次数已满"/utf8>>};

get(1720075) ->
	#errorcode_msg{type = err172_wedding_sc_limit,about = <<"本次食用豪华喜糖次数已满"/utf8>>};

get(1720076) ->
	#errorcode_msg{type = err172_please_order_wedding,about = <<"请先举行婚礼"/utf8>>};

get(1720077) ->
	#errorcode_msg{type = err172_cant_wedding_twice,about = <<"不能重复举行婚礼"/utf8>>};

get(1720078) ->
	#errorcode_msg{type = err172_divorce_lover_not_online,about = <<"姻缘不在线，无法协商离婚"/utf8>>};

get(1720079) ->
	#errorcode_msg{type = err172_love_dsgt_active,about = <<"恩爱称号已激活"/utf8>>};

get(1720080) ->
	#errorcode_msg{type = err172_love_gift_type_err,about = <<"礼包不存在"/utf8>>};

get(1720081) ->
	#errorcode_msg{type = err172_love_gift_get,about = <<"礼包已领取"/utf8>>};

get(1720082) ->
	#errorcode_msg{type = err172_love_gift_not_buy,about = <<"没购买礼包"/utf8>>};

get(1720083) ->
	#errorcode_msg{type = err172_love_gift_expire,about = <<"礼包已过期"/utf8>>};

get(1720084) ->
	#errorcode_msg{type = err172_sex_limit,about = <<"不能邀请同性别玩家"/utf8>>};

get(1720085) ->
	#errorcode_msg{type = err172_ask_for_divorce,about = <<"已申请离婚"/utf8>>};

get(1720086) ->
	#errorcode_msg{type = err172_other_money_not_enough,about = <<"对方勾玉不足"/utf8>>};

get(1720087) ->
	#errorcode_msg{type = err172_in_marriaage_dun_match,about = <<"正在匹配情缘副本中"/utf8>>};

get(1720088) ->
	#errorcode_msg{type = err172_dun_intimacy_not_enough,about = <<"亲密度不足"/utf8>>};

get(1720089) ->
	#errorcode_msg{type = err172_wedding_order_times_err,about = <<"没有婚礼次数"/utf8>>};

get(1720090) ->
	#errorcode_msg{type = err172_wedding_not_invite_lover,about = <<"不能邀请姻缘"/utf8>>};

get(1720091) ->
	#errorcode_msg{type = err172_ring_unlock,about = <<"戒指已解锁"/utf8>>};

get(1720092) ->
	#errorcode_msg{type = err172_wedding_feast_success,about = <<"恭喜获得{1}"/utf8>>};

get(1720093) ->
	#errorcode_msg{type = err172_in_wedding_scene,about = <<"在婚宴中不能切场景"/utf8>>};

get(1720094) ->
	#errorcode_msg{type = err172_please_order_next_time,about = <<"请预约下一场次的婚礼,当前场次已准备开始！"/utf8>>};

get(1720095) ->
	#errorcode_msg{type = err172_only_one_times_in_day,about = <<"简约婚礼每天只可预约一次"/utf8>>};

get(1720096) ->
	#errorcode_msg{type = err172_in_team_dungeon,about = <<"组队状态不能进入副本哦！"/utf8>>};

get(1720097) ->
	#errorcode_msg{type = err172_other_in_team_dungeon,about = <<"对方在队伍中，不能邀请！"/utf8>>};

get(1720098) ->
	#errorcode_msg{type = err172_gift_no_in_get_time,about = <<"礼包未到可领取的时间"/utf8>>};

get(1720099) ->
	#errorcode_msg{type = err172_gift_no_expire,about = <<"当前已有生效的礼包，请勿重复购买"/utf8>>};

get(1730001) ->
	#errorcode_msg{type = err173_equip_condition_error,about = <<"条件不足，无法穿戴"/utf8>>};

get(1730002) ->
	#errorcode_msg{type = err173_fight_location_limit,about = <<"出战槽位已达上限"/utf8>>};

get(1730003) ->
	#errorcode_msg{type = err173_strength_double_error,about = <<"强化过的装备无法使用双倍强化"/utf8>>};

get(1730004) ->
	#errorcode_msg{type = err173_strength_level_limit,about = <<"强化等级已达上限"/utf8>>};

get(1730005) ->
	#errorcode_msg{type = err173_equip_error,about = <<"该物品不能装备"/utf8>>};

get(1730006) ->
	#errorcode_msg{type = err173_eudemons_bag_full,about = <<"幻兽背包位置不足"/utf8>>};

get(1730007) ->
	#errorcode_msg{type = err173_strength_cfg_error,about = <<"强化配置出错，请您联系客服！"/utf8>>};

get(1730008) ->
	#errorcode_msg{type = err173_fight_limit,about = <<"蜃妖助战数量已达上限"/utf8>>};

get(1730009) ->
	#errorcode_msg{type = err173_system_business,about = <<"系统繁忙，请稍后！"/utf8>>};

get(1730010) ->
	#errorcode_msg{type = err173_wrong_num,about = <<"资源不足"/utf8>>};

get(1730011) ->
	#errorcode_msg{type = err173_wrong_material,about = <<"该资源无法合成该物品"/utf8>>};

get(1730012) ->
	#errorcode_msg{type = err173_error_type,about = <<"强化类型错误!"/utf8>>};

get(1730013) ->
	#errorcode_msg{type = err173_lv_limit,about = <<"等级不足，无法增加额外出战槽位"/utf8>>};

get(1740001) ->
	#errorcode_msg{type = err174_act_not_open,about = <<"活动未开启"/utf8>>};

get(1740002) ->
	#errorcode_msg{type = err174_no_enough_lv_join,about = <<"等级不足"/utf8>>};

get(1740003) ->
	#errorcode_msg{type = err174_on_noon_quiz,about = <<"答题活动中"/utf8>>};

get(1740004) ->
	#errorcode_msg{type = err174_not_in_act,about = <<"不在活动中"/utf8>>};

get(1740005) ->
	#errorcode_msg{type = err174_not_scene,about = <<"不在答题场景中"/utf8>>};

get(1740006) ->
	#errorcode_msg{type = err174_not_answering,about = <<"不在答题阶段中"/utf8>>};

get(1750001) ->
	#errorcode_msg{type = err175_login_reward_closed,about = <<"七天登录活动已关闭"/utf8>>};

get(1750002) ->
	#errorcode_msg{type = err175_today_already_get,about = <<"今日已经领取"/utf8>>};

get(1750003) ->
	#errorcode_msg{type = err175_the_day_already_get,about = <<"已领取过该奖励"/utf8>>};

get(1750004) ->
	#errorcode_msg{type = err175_can_not_get,about = <<"不能领取"/utf8>>};

get(1760001) ->
	#errorcode_msg{type = err176_not_sell,about = <<"该商品没有在销售"/utf8>>};

get(1760002) ->
	#errorcode_msg{type = err176_out_time,about = <<"超过限时"/utf8>>};

get(1760003) ->
	#errorcode_msg{type = err176_out_num,about = <<"超过数量"/utf8>>};

get(1760004) ->
	#errorcode_msg{type = err176_out_num_all,about = <<"已卖完"/utf8>>};

get(1770001) ->
	#errorcode_msg{type = err177_house_not_furniture,about = <<"家具库中暂无该家具"/utf8>>};

get(1770002) ->
	#errorcode_msg{type = err177_furniture_not_enough,about = <<"家具不足（暂不使用）"/utf8>>};

get(1770003) ->
	#errorcode_msg{type = err177_house_furniture_max,about = <<"家具库数量已达上限"/utf8>>};

get(1770004) ->
	#errorcode_msg{type = err177_house_none,about = <<"拥有房子后才能进行该操作"/utf8>>};

get(1770005) ->
	#errorcode_msg{type = err177_house_lock,about = <<"该房子已上锁"/utf8>>};

get(1770006) ->
	#errorcode_msg{type = err177_house_not_own,about = <<"不是自己的房子无法进行该操作"/utf8>>};

get(1770007) ->
	#errorcode_msg{type = err177_house_not_in,about = <<"不在家园场景中无法进行该操作"/utf8>>};

get(1770008) ->
	#errorcode_msg{type = err177_house_have,about = <<"无法重复购买房子"/utf8>>};

get(1770009) ->
	#errorcode_msg{type = err177_house_be_asked_aa,about = <<"请先回应您对象的请求"/utf8>>};

get(1770010) ->
	#errorcode_msg{type = err177_house_asking_aa,about = <<"请耐心等待对方回应"/utf8>>};

get(1770011) ->
	#errorcode_msg{type = err177_house_house_exist,about = <<"该房子已出售，请另外选择"/utf8>>};

get(1770012) ->
	#errorcode_msg{type = err177_house_not_ask,about = <<"平分买房请求已失效"/utf8>>};

get(1770013) ->
	#errorcode_msg{type = err177_house_have_order,about = <<"该房子已被预定，请另外选择"/utf8>>};

get(1770014) ->
	#errorcode_msg{type = err177_house_refuse,about = <<"已成功拒绝"/utf8>>};

get(1770015) ->
	#errorcode_msg{type = err177_house_lv_max,about = <<"房子已达最大规模"/utf8>>};

get(1770016) ->
	#errorcode_msg{type = err177_house_point_not_enough,about = <<"规模升级所需繁荣度不足"/utf8>>};

get(1770017) ->
	#errorcode_msg{type = err177_house_upgrade_aa,about = <<"请耐心等待对方回应"/utf8>>};

get(1770018) ->
	#errorcode_msg{type = err177_house_furniture_put_max,about = <<"家具库中暂无该家具"/utf8>>};

get(1770019) ->
	#errorcode_msg{type = err177_house_not_inside,about = <<"场景里没有这个家具"/utf8>>};

get(1770020) ->
	#errorcode_msg{type = err177_house_not_in_scene,about = <<"不在家园场景里（暂不使用）"/utf8>>};

get(1770021) ->
	#errorcode_msg{type = err177_house_choose,about = <<"请先选择你们的婚房"/utf8>>};

get(1770022) ->
	#errorcode_msg{type = err177_house_not_choose,about = <<"现在不能选择房子"/utf8>>};

get(1770023) ->
	#errorcode_msg{type = err177_house_bag_full,about = <<"家园背包已满"/utf8>>};

get(1770024) ->
	#errorcode_msg{type = err177_house_text_too_long,about = <<"留言过长，请修改"/utf8>>};

get(1770025) ->
	#errorcode_msg{type = err177_house_choose_refuse,about = <<"已成功拒绝"/utf8>>};

get(1770026) ->
	#errorcode_msg{type = err177_house_floor_not_back,about = <<"地板无法收回家具库中"/utf8>>};

get(1770027) ->
	#errorcode_msg{type = err177_house_choose_waiting,about = <<"请耐心等待对方回应"/utf8>>};

get(1770028) ->
	#errorcode_msg{type = err177_house_furniture_location_wrong,about = <<"家具不在家具背包里"/utf8>>};

get(1770029) ->
	#errorcode_msg{type = err177_house_answer,about = <<"请先回复对方"/utf8>>};

get(1770030) ->
	#errorcode_msg{type = err177_house_not_exist,about = <<"房子不存在"/utf8>>};

get(1770031) ->
	#errorcode_msg{type = err177_house_wish_word_too_long,about = <<"祝福语过长"/utf8>>};

get(1770032) ->
	#errorcode_msg{type = err177_house_gift_over_limit,about = <<"今日该礼物已送完"/utf8>>};

get(1770033) ->
	#errorcode_msg{type = err177_house_garden_not_in_garden,about = <<"不在庭院里"/utf8>>};

get(1770034) ->
	#errorcode_msg{type = err177_house_garden_not_garden_own,about = <<"不是自己的庭院"/utf8>>};

get(1770035) ->
	#errorcode_msg{type = err177_house_garden_lv_limit,about = <<"庭院等级不足"/utf8>>};

get(1770036) ->
	#errorcode_msg{type = err177_house_garden_not_product,about = <<"没有正在培养的物品"/utf8>>};

get(1770037) ->
	#errorcode_msg{type = err177_house_garden_not_use_pos,about = <<"暂无可用槽位"/utf8>>};

get(1770038) ->
	#errorcode_msg{type = err177_house_garden_over_product_num,about = <<"超出产出数上限"/utf8>>};

get(1770039) ->
	#errorcode_msg{type = err177_house_garden_product_not_time_out,about = <<"产出时间未到"/utf8>>};

get(1770040) ->
	#errorcode_msg{type = err177_house_garden_done,about = <<"已完成"/utf8>>};

get(1770041) ->
	#errorcode_msg{type = err177_house_cell_max,about = <<"家园背包已满"/utf8>>};

get(1770042) ->
	#errorcode_msg{type = err177_house_garden_wish_free_max,about = <<"已经超出许愿币上限"/utf8>>};

get(1770043) ->
	#errorcode_msg{type = err177_house_garden_has_got,about = <<"已经领取了今天的许愿币"/utf8>>};

get(1770044) ->
	#errorcode_msg{type = err177_house_garden_goods_success,about = <<"许愿成功，获得{1}"/utf8>>};

get(1770045) ->
	#errorcode_msg{type = err177_house_garden_lv_success,about = <<"许愿成功，升级至{1}"/utf8>>};

get(1770046) ->
	#errorcode_msg{type = err177_house_garden_same_loc,about = <<"移动后同一个位置"/utf8>>};

get(1780001) ->
	#errorcode_msg{type = err178_max_enchant_count,about = <<"最大附魔次数"/utf8>>};

get(1780002) ->
	#errorcode_msg{type = err178_max_sp_wash_count,about = <<"最大特殊凝练次数"/utf8>>};

get(1780003) ->
	#errorcode_msg{type = err178_max_page_skill_active_star,about = <<"最大激活技能等级"/utf8>>};

get(1780004) ->
	#errorcode_msg{type = err178_must_page_all_glyph_active,about = <<"必须所有雕纹激活"/utf8>>};

get(1780005) ->
	#errorcode_msg{type = err178_max_lv,about = <<"达到最大等级"/utf8>>};

get(1780006) ->
	#errorcode_msg{type = err178_must_active_star,about = <<"必须激活星数才能升级"/utf8>>};

get(1780007) ->
	#errorcode_msg{type = err178_max_star,about = <<"达到最大星数"/utf8>>};

get(1790001) ->
	#errorcode_msg{type = err179_role_lv_limit,about = <<"等级不足"/utf8>>};

get(1790002) ->
	#errorcode_msg{type = err179_not_in_draw_time,about = <<"不在抽奖开放时间内"/utf8>>};

get(1790003) ->
	#errorcode_msg{type = err179_has_recieve,about = <<"奖励已领取"/utf8>>};

get(1790004) ->
	#errorcode_msg{type = err179_not_achieve,about = <<"未达到领取条件"/utf8>>};

get(1790005) ->
	#errorcode_msg{type = err179_miss_config,about = <<"缺失配置"/utf8>>};

get(1790006) ->
	#errorcode_msg{type = err179_pool_is_null,about = <<"奖池为空"/utf8>>};

get(1790007) ->
	#errorcode_msg{type = has_same_type,about = <<"不能重复添加"/utf8>>};

get(1790008) ->
	#errorcode_msg{type = err179_type_length_error,about = <<"奖池数量异常"/utf8>>};

get(1790009) ->
	#errorcode_msg{type = err179_error_goods_in_pool,about = <<"奖池已存在相同物品"/utf8>>};

get(1800001) ->
	#errorcode_msg{type = err180_equip_condition_err,about = <<"佩戴条件不足"/utf8>>};

get(1800002) ->
	#errorcode_msg{type = err180_anima_id_err,about = <<"灵器库错误"/utf8>>};

get(1800003) ->
	#errorcode_msg{type = err180_equip_pos_err,about = <<"佩戴位置错误"/utf8>>};

get(1800004) ->
	#errorcode_msg{type = err180_not_equip,about = <<"当前位置没有佩戴灵器"/utf8>>};

get(1810001) ->
	#errorcode_msg{type = err181_not_goods_exist,about = <<"物品不存在"/utf8>>};

get(1810002) ->
	#errorcode_msg{type = err181_not_dragon_equip,about = <<"不是神纹物品"/utf8>>};

get(1810003) ->
	#errorcode_msg{type = err181_max_dragon_lv,about = <<"已达到最大等级"/utf8>>};

get(1810004) ->
	#errorcode_msg{type = err181_not_right_equip_career,about = <<"神纹装备职业不符"/utf8>>};

get(1810005) ->
	#errorcode_msg{type = err181_not_pos_permiss,about = <<"该神纹不能镶嵌在该槽位"/utf8>>};

get(1810006) ->
	#errorcode_msg{type = err181_not_enough_dragon_lv,about = <<"神纹等级不满足槽位等级需求"/utf8>>};

get(1810007) ->
	#errorcode_msg{type = err181_not_unique_kind,about = <<"已镶嵌同类型神纹"/utf8>>};

get(1810008) ->
	#errorcode_msg{type = err181_not_on_equip,about = <<"不需要重复镶嵌"/utf8>>};

get(1810009) ->
	#errorcode_msg{type = err181_must_on_bag_to_decompose,about = <<"只有在背包的神纹才能分解"/utf8>>};

get(1810010) ->
	#errorcode_msg{type = err181_not_decompose_cfg,about = <<"缺失神纹分解配置"/utf8>>};

get(1810011) ->
	#errorcode_msg{type = err181_not_beckon_cfg,about = <<"熔炉配置不存在"/utf8>>};

get(1810012) ->
	#errorcode_msg{type = err181_crucible_not_open,about = <<"熔炉未开启"/utf8>>};

get(1810013) ->
	#errorcode_msg{type = err181_not_count_reward_cfg,about = <<"熔炉奖励配置缺失"/utf8>>};

get(1810014) ->
	#errorcode_msg{type = err181_can_have_get,about = <<"奖励已领取"/utf8>>};

get(1810015) ->
	#errorcode_msg{type = err181_can_not_get,about = <<"不满足领取条件"/utf8>>};

get(1810016) ->
	#errorcode_msg{type = err181_pos_not_active,about = <<"槽位未激活"/utf8>>};

get(1810017) ->
	#errorcode_msg{type = err181_not_dragon_pos_cfg,about = <<"槽位配置缺失"/utf8>>};

get(1810018) ->
	#errorcode_msg{type = err181_max_dragon_pos_lv,about = <<"槽位等级上限"/utf8>>};

get(1810019) ->
	#errorcode_msg{type = err181_not_dragon_pos_lv_cfg,about = <<"槽位等级配置缺失"/utf8>>};

get(1810020) ->
	#errorcode_msg{type = err181_min_dragon_pos_lv,about = <<"槽位等级限制"/utf8>>};

get(1810021) ->
	#errorcode_msg{type = err181_stage_reward_unrecieve,about = <<"您还有未领取的阶段奖励"/utf8>>};

get(1810022) ->
	#errorcode_msg{type = err181_bag_not_enough,about = <<"神纹背包不足"/utf8>>};

get(1820001) ->
	#errorcode_msg{type = err182_max_stage,about = <<"已达最大阶数"/utf8>>};

get(1820002) ->
	#errorcode_msg{type = err182_figure_in_use,about = <<"形象已在使用中"/utf8>>};

get(1820003) ->
	#errorcode_msg{type = err182_not_active,about = <<"请先激活宝宝"/utf8>>};

get(1820004) ->
	#errorcode_msg{type = err182_figure_not_use,about = <<"形象没在使用"/utf8>>};

get(1820005) ->
	#errorcode_msg{type = err182_had_praise_back,about = <<"已经回赞"/utf8>>};

get(1820006) ->
	#errorcode_msg{type = err182_stage_not_enough,about = <<"宝宝阶数不足"/utf8>>};

get(1820007) ->
	#errorcode_msg{type = err182_equip_pos_err,about = <<"佩戴位置错误"/utf8>>};

get(1820008) ->
	#errorcode_msg{type = err182_not_equip,about = <<"当前无佩戴装备"/utf8>>};

get(1820009) ->
	#errorcode_msg{type = err182_skill_had_active,about = <<"技能已激活"/utf8>>};

get(1820010) ->
	#errorcode_msg{type = err182_raise_lv_not_enough,about = <<"未达养育开放等级"/utf8>>};

get(1820011) ->
	#errorcode_msg{type = err182_baby_is_active,about = <<"宝宝已经激活"/utf8>>};

get(1820012) ->
	#errorcode_msg{type = err182_task_not_finish,about = <<"任务未完成"/utf8>>};

get(1820013) ->
	#errorcode_msg{type = err182_task_reward_get,about = <<"任务奖励已领取"/utf8>>};

get(1820014) ->
	#errorcode_msg{type = err182_player_not_active_baby,about = <<"对方还没激活宝宝"/utf8>>};

get(1830001) ->
	#errorcode_msg{type = err183_demons_not_active,about = <<"精怪未激活"/utf8>>};

get(1830002) ->
	#errorcode_msg{type = err183_demons_is_follow,about = <<"精怪已跟随"/utf8>>};

get(1830003) ->
	#errorcode_msg{type = err183_cannot_receive,about = <<"领取条件不足"/utf8>>};

get(1830004) ->
	#errorcode_msg{type = err183_is_receive,about = <<"奖励已领取"/utf8>>};

get(1830005) ->
	#errorcode_msg{type = err183_demons_skill_not_active,about = <<"精怪技能未激活"/utf8>>};

get(1830006) ->
	#errorcode_msg{type = err183_demons_slot_not_active,about = <<"天赋技能槽位未解锁"/utf8>>};

get(1830007) ->
	#errorcode_msg{type = err183_demons_goods_not_skill,about = <<"该物品不是天赋技能升级资源！"/utf8>>};

get(1830008) ->
	#errorcode_msg{type = err183_same_slot_skill_sort,about = <<"已经镶嵌过同品质同种类的技能"/utf8>>};

get(1830009) ->
	#errorcode_msg{type = err183_demons_shop_no_goods,about = <<"该物品暂不出售！"/utf8>>};

get(1830010) ->
	#errorcode_msg{type = err183_demons_error_slot_skill,about = <<"没有学习该技能！"/utf8>>};

get(1830011) ->
	#errorcode_msg{type = err183_demons_slot_skill_have,about = <<"该精怪已经学习过此技能"/utf8>>};

get(1830012) ->
	#errorcode_msg{type = err183_demons_slot_skill_not_have,about = <<"该槽位没有可被升级或替换的技能"/utf8>>};

get(1830013) ->
	#errorcode_msg{type = err183_demons_skill_active,about = <<"精怪技能已激活"/utf8>>};

get(1830014) ->
	#errorcode_msg{type = err183_demons_skill_not_complete,about = <<"精怪技能未完成"/utf8>>};

get(1850001) ->
	#errorcode_msg{type = err185_enter_cluster,about = <<"点击过快！"/utf8>>};

get(1850002) ->
	#errorcode_msg{type = err185_guild_position_limit,about = <<"只有会长或副会长才能开启护送！"/utf8>>};

get(1850003) ->
	#errorcode_msg{type = err185_has_create_mon,about = <<"结社已经选择过护送水晶！"/utf8>>};

get(1850004) ->
	#errorcode_msg{type = err185_not_in_scene,about = <<"不在场景内无法获取数据！"/utf8>>};

get(1850005) ->
	#errorcode_msg{type = err185_time_out,about = <<"未到活动开启时间~"/utf8>>};

get(1850006) ->
	#errorcode_msg{type = err185_cant_quit_guild_when_act_open,about = <<"矿石护送期间，无法退出结社/踢出结社成员"/utf8>>};

get(1850007) ->
	#errorcode_msg{type = err185_disband_when_act_open,about = <<"矿石护送活动期间，不能解散结社"/utf8>>};

get(1850008) ->
	#errorcode_msg{type = err185_create_mon_first,about = <<"先选择水晶才能召集结社成员"/utf8>>};

get(1850009) ->
	#errorcode_msg{type = err185_cant_reborn_in_scene,about = <<"此场景无法护送该类型水晶"/utf8>>};

get(1850010) ->
	#errorcode_msg{type = err185_open_day_limit,about = <<"开服天数不符！"/utf8>>};

get(1860001) ->
	#errorcode_msg{type = err186_join_a_camp,about = <<"请先加入一个势力！"/utf8>>};

get(1860002) ->
	#errorcode_msg{type = err186_not_guild_chief,about = <<"没有操作权限"/utf8>>};

get(1860003) ->
	#errorcode_msg{type = err186_error_data,about = <<"数据异常"/utf8>>};

get(1860004) ->
	#errorcode_msg{type = err186_has_join,about = <<"已经加入了禁卫"/utf8>>};

get(1860005) ->
	#errorcode_msg{type = err186_has_apply,about = <<"已经申请过了，耐心等待审批"/utf8>>};

get(1860006) ->
	#errorcode_msg{type = err186_be_limit,about = <<"未达到限制要求"/utf8>>};

get(1860007) ->
	#errorcode_msg{type = err186_not_apply,about = <<"没有申请"/utf8>>};

get(1860008) ->
	#errorcode_msg{type = err186_job_num_limit,about = <<"禁卫总数量达到限制"/utf8>>};

get(1860009) ->
	#errorcode_msg{type = err186_job_limit,about = <<"该职位数量达到上限"/utf8>>};

get(1860010) ->
	#errorcode_msg{type = err186_already_same_type,about = <<"已经是该类型战舰了"/utf8>>};

get(1860011) ->
	#errorcode_msg{type = err186_not_in_scene,about = <<"不在活动场景无法切换船只类型"/utf8>>};

get(1860012) ->
	#errorcode_msg{type = err186_has_divide,about = <<"该奖励已分配"/utf8>>};

get(1860013) ->
	#errorcode_msg{type = err186_not_camp_job,about = <<"非官员无法获得连胜奖励"/utf8>>};

get(1860014) ->
	#errorcode_msg{type = err186_has_join_a_camp,about = <<"已经加入过势力了！"/utf8>>};

get(1860015) ->
	#errorcode_msg{type = err186_cant_exit_now,about = <<"当前无法退出势力"/utf8>>};

get(1860016) ->
	#errorcode_msg{type = err186_act_will_start_today,about = <<"活动开启当天无法加入或退出势力"/utf8>>};

get(1860017) ->
	#errorcode_msg{type = err186_cant_recieve_before_act_start,about = <<"海域之王未确定情况下无法领取每日福利"/utf8>>};

get(1860018) ->
	#errorcode_msg{type = err186_has_recieve,about = <<"奖励已领取"/utf8>>};

get(1860019) ->
	#errorcode_msg{type = err186_wait_for_master_come,about = <<"海域之王产生后才可以开始申请"/utf8>>};

get(1860020) ->
	#errorcode_msg{type = err186_cant_quit_guild_when_act_open,about = <<"四海争霸期间无法退出结社/踢出结社成员！"/utf8>>};

get(1860021) ->
	#errorcode_msg{type = err186_cant_appoint_chief_when_act_open,about = <<"四海争霸期间无法转让会长"/utf8>>};

get(1860022) ->
	#errorcode_msg{type = err186_cant_disband_when_act_open,about = <<"四海争霸活动期间/海王所在结社无法解散"/utf8>>};

get(1860023) ->
	#errorcode_msg{type = err186_enter_cluster,about = <<"不要重复请求"/utf8>>};

get(1860024) ->
	#errorcode_msg{type = err186_not_in_act_time,about = <<"不在活动时间内"/utf8>>};

get(1860025) ->
	#errorcode_msg{type = err186_cant_enter,about = <<"只有获得参赛资格的结社方可参与战斗"/utf8>>};

get(1860026) ->
	#errorcode_msg{type = err186_cant_enter_act,about = <<"只有海域之主和禁卫成员可进入争夺"/utf8>>};

get(1860027) ->
	#errorcode_msg{type = err186_change_ship_time_limit,about = <<"冷却中，稍后重试！"/utf8>>};

get(1860028) ->
	#errorcode_msg{type = err186_act_is_running,about = <<"争霸战开启中，无法更改职位"/utf8>>};

get(1860029) ->
	#errorcode_msg{type = err186_act_scene_cant_enter,about = <<"当前活动无法进入"/utf8>>};

get(1860030) ->
	#errorcode_msg{type = err186_no_privilege,about = <<"您没有执行此操作的权限~"/utf8>>};

get(1860031) ->
	#errorcode_msg{type = err186_had_option,about = <<"请勿重复操作~"/utf8>>};

get(1860032) ->
	#errorcode_msg{type = err186_no_times,about = <<"次数不足"/utf8>>};

get(1870001) ->
	#errorcode_msg{type = err187_not_have_sea,about = <<"未加入海域"/utf8>>};

get(1870002) ->
	#errorcode_msg{type = err187_error_brick_color,about = <<"砖块品质错误"/utf8>>};

get(1870003) ->
	#errorcode_msg{type = err187_not_carry_brick,about = <<"当前状态不是搬砖"/utf8>>};

get(1870004) ->
	#errorcode_msg{type = err187_carrying,about = <<"玩家处于搬砖中"/utf8>>};

get(1870005) ->
	#errorcode_msg{type = err187_not_in_scene,about = <<"不在场景中"/utf8>>};

get(1870006) ->
	#errorcode_msg{type = err187_finish_fail,about = <<"完成搬砖失败"/utf8>>};

get(1870007) ->
	#errorcode_msg{type = err187_not_enter_sea,about = <<"未加入海域"/utf8>>};

get(1870008) ->
	#errorcode_msg{type = err187_same_sea,about = <<"自己海域不能搬运"/utf8>>};

get(1870009) ->
	#errorcode_msg{type = err187_in_scene,about = <<"在国战日常中"/utf8>>};

get(1870010) ->
	#errorcode_msg{type = err187_not_have_sea_king,about = <<"报名及海战期间无法进入"/utf8>>};

get(1870011) ->
	#errorcode_msg{type = err187_not_finish_task,about = <<"未完成任务"/utf8>>};

get(1870012) ->
	#errorcode_msg{type = err187_yet_get_reward,about = <<"已经领取奖励"/utf8>>};

get(1870013) ->
	#errorcode_msg{type = err187_in_sea,about = <<"已在当前场景"/utf8>>};

get(1870014) ->
	#errorcode_msg{type = err187_carrying2,about = <<"请先卸下砖块再提升品质"/utf8>>};

get(1870015) ->
	#errorcode_msg{type = err187_sea_retret,about = <<"该海域已被封边"/utf8>>};

get(1870016) ->
	#errorcode_msg{type = err187_cant_quit_guild_when_in_sea_daily,about = <<"在国战日常中不能退出结社"/utf8>>};

get(1870017) ->
	#errorcode_msg{type = err187_err_length,about = <<"距离NPC过远"/utf8>>};

get(1870018) ->
	#errorcode_msg{type = err187_max_carry_count,about = <<"已经达到最大搬运次数"/utf8>>};

get(1890001) ->
	#errorcode_msg{type = err189_do_not_have_check,about = <<"未进行数据检测，无法进行下一步操作！"/utf8>>};

get(1890002) ->
	#errorcode_msg{type = err189_get_before_reward_first,about = <<"请先领取上次巡航奖励！"/utf8>>};

get(1890003) ->
	#errorcode_msg{type = err189_on_sea_treasure_scene,about = <<"璀璨之海掠夺/复仇/助战中"/utf8>>};

get(1890004) ->
	#errorcode_msg{type = err189_has_be_robered,about = <<"已经被掠夺过一次，没有可掠夺物品了"/utf8>>};

get(1890005) ->
	#errorcode_msg{type = err189_cant_rob_self,about = <<"无法掠夺/协助自己"/utf8>>};

get(1890006) ->
	#errorcode_msg{type = err189_end_time_limit,about = <<"巡航已结束"/utf8>>};

get(1890007) ->
	#errorcode_msg{type = err189_cfg_delete,about = <<"配置丢失，请反馈客服，感谢您的配合"/utf8>>};

get(1890008) ->
	#errorcode_msg{type = err189_shipping_type_wrong,about = <<"船只档次异常"/utf8>>};

get(1890009) ->
	#errorcode_msg{type = err189_be_rob_back,about = <<"已夺回全部奖励"/utf8>>};

get(1890010) ->
	#errorcode_msg{type = err189_cant_rback_self,about = <<"无法助战被自己掠夺的对象"/utf8>>};

get(1890011) ->
	#errorcode_msg{type = err189_cant_rback_not_be_robed,about = <<"只能助战被掠夺记录"/utf8>>};

get(1890012) ->
	#errorcode_msg{type = err189_day_times_max,about = <<"当日掠夺/巡航次数达到上限"/utf8>>};

get(1890013) ->
	#errorcode_msg{type = err189_has_recieve,about = <<"没有可领取的奖励"/utf8>>};

get(1890014) ->
	#errorcode_msg{type = err189_be_robbing,about = <<"对方正在战斗中"/utf8>>};

get(1890015) ->
	#errorcode_msg{type = err189_already_in_scene,about = <<"正在玩法场景中，无法协助"/utf8>>};

get(1890016) ->
	#errorcode_msg{type = err189_rback_get_reward,about = <<"协助获得过奖励无法再次协助"/utf8>>};

get(1890017) ->
	#errorcode_msg{type = err189_log_is_not_exist,about = <<"掠夺记录不存在"/utf8>>};

get(1890018) ->
	#errorcode_msg{type = err189_shipping_type_max,about = <<"已升至最高档次"/utf8>>};

get(1890019) ->
	#errorcode_msg{type = err189_ship_end,about = <<"巡航已结束"/utf8>>};

get(1890020) ->
	#errorcode_msg{type = err189_not_in_sea_treasure_scene,about = <<"不在璀璨之海场景，无法退出"/utf8>>};

get(1890021) ->
	#errorcode_msg{type = err189_server_has_down,about = <<"对方服务器调整中，请稍候再试"/utf8>>};

get(1890022) ->
	#errorcode_msg{type = err189_cant_rback_simo,about = <<"已有玩家协助，无法进入"/utf8>>};

get(1900001) ->
	#errorcode_msg{type = err190_no_mail,about = <<"没有邮件"/utf8>>};

get(1900002) ->
	#errorcode_msg{type = err190_read_mail_content_fail,about = <<"读取邮件失败"/utf8>>};

get(1900003) ->
	#errorcode_msg{type = err190_no_mail_attachment,about = <<"当前没有附件可领取"/utf8>>};

get(1900004) ->
	#errorcode_msg{type = err190_no_mail_to_delete,about = <<"没有邮件可以删除"/utf8>>};

get(1900005) ->
	#errorcode_msg{type = err190_have_attachment_not_to_delete,about = <<"无法删除带附件的邮件"/utf8>>};

get(1900006) ->
	#errorcode_msg{type = err190_bag_full,about = <<"背包已满,无法领取剩余附件"/utf8>>};

get(1900007) ->
	#errorcode_msg{type = err190_mail_timeout_to_delete,about = <<"邮件已经失效，无法删除"/utf8>>};

get(1900008) ->
	#errorcode_msg{type = err190_mail_timeout_to_extract_attachment,about = <<"邮件已经失效，无法领取"/utf8>>};

get(1900009) ->
	#errorcode_msg{type = err190_mail_title_len,about = <<"邮件标题过长"/utf8>>};

get(1900010) ->
	#errorcode_msg{type = err190_mail_title_sensitive,about = <<"邮件标题含有敏感字"/utf8>>};

get(1900011) ->
	#errorcode_msg{type = err190_mail_content_len,about = <<"邮件内容过长"/utf8>>};

get(1900012) ->
	#errorcode_msg{type = err190_mail_content_sensitive,about = <<"邮件内容含有敏感字"/utf8>>};

get(1900013) ->
	#errorcode_msg{type = err190_send_guild_mail_count_not_enough,about = <<"发送邮件次数不足"/utf8>>};

get(1900014) ->
	#errorcode_msg{type = err190_must_on_guild_to_send_guild_mail,about = <<"必须在结社才能发结社邮件"/utf8>>};

get(1900015) ->
	#errorcode_msg{type = err190_not_permisssion_to_send_guild_mail,about = <<"没有权限发结社邮件"/utf8>>};

get(1900016) ->
	#errorcode_msg{type = err190_on_feedback_cd,about = <<"您的操作太快，请稍后再试"/utf8>>};

get(1900017) ->
	#errorcode_msg{type = err190_feedback_not_valid,about = <<"反馈内容过长或者存在敏感字"/utf8>>};

get(1900018) ->
	#errorcode_msg{type = err190_have_receive_attachment,about = <<"附件已领取"/utf8>>};

get(1910001) ->
	#errorcode_msg{type = err191_gift_not_active,about = <<"礼包未激活"/utf8>>};

get(1910002) ->
	#errorcode_msg{type = err191_gift_is_buy,about = <<"已购买"/utf8>>};

get(1910003) ->
	#errorcode_msg{type = err191_gift_is_expired,about = <<"礼包已过期"/utf8>>};

get(1920001) ->
	#errorcode_msg{type = err192_no_qualification,about = <<"无参加资格"/utf8>>};

get(1920002) ->
	#errorcode_msg{type = err192_logout,about = <<"登出"/utf8>>};

get(1920003) ->
	#errorcode_msg{type = err192_enter_fail,about = <<"进入活动失败"/utf8>>};

get(1920004) ->
	#errorcode_msg{type = err192_onhook_coin_not_enough,about = <<"托管币不足"/utf8>>};

get(1940001) ->
	#errorcode_msg{type = err194_fiesta_activated,about = <<"已激活过高级祭典"/utf8>>};

get(2000001) ->
	#errorcode_msg{type = err200_robbed_not_mon_bl,about = <<"被抢夺的玩家没有归属"/utf8>>};

get(2000002) ->
	#errorcode_msg{type = err200_not_rob_my_mon_bl,about = <<"不能抢夺自己的归属"/utf8>>};

get(2000003) ->
	#errorcode_msg{type = err200_this_mon_not_bl_to_rob,about = <<"怪物没有归属无法抢夺"/utf8>>};

get(2000004) ->
	#errorcode_msg{type = err200_rob_mon_bl_fail,about = <<"抢夺失败"/utf8>>};

get(2000005) ->
	#errorcode_msg{type = err200_rob_mon_bl_must_same_scene,about = <<"抢夺必须在同一场景"/utf8>>};

get(2000006) ->
	#errorcode_msg{type = err200_not_rob_this_mon_bl,about = <<"无法抢夺本怪物的归属"/utf8>>};

get(2000007) ->
	#errorcode_msg{type = err200_not_mon,about = <<"不存在怪物"/utf8>>};

get(2000008) ->
	#errorcode_msg{type = err200_not_user,about = <<"不存在玩家"/utf8>>};

get(2000009) ->
	#errorcode_msg{type = err200_other_rob_my_mon_bl_fail,about = <<"{1}尝试抢夺你的归属，但是失败了"/utf8>>};

get(2020001) ->
	#errorcode_msg{type = err202_no_protect_time,about = <<"没有保护时间"/utf8>>};

get(2020002) ->
	#errorcode_msg{type = err202_max_use_count,about = <<"每天使用达到上限"/utf8>>};

get(2020003) ->
	#errorcode_msg{type = err202_have_left_safe_time,about = <<"还有剩余的保护时间"/utf8>>};

get(2020004) ->
	#errorcode_msg{type = err202_this_scene_not_to_protect,about = <<"本场景无法开启保护"/utf8>>};

get(2020005) ->
	#errorcode_msg{type = err202_had_close_protect,about = <<"已经关闭了保护"/utf8>>};

get(2020006) ->
	#errorcode_msg{type = err202_this_scene_type_not_to_close,about = <<"与保护的场景类型不对应无法关闭"/utf8>>};

get(2020007) ->
	#errorcode_msg{type = err202_this_scene_not_to_close,about = <<"与本场景类型不对应无法关闭"/utf8>>};

get(2030001) ->
	#errorcode_msg{type = err203_not_teasure_map,about = <<"不是藏宝图"/utf8>>};

get(2030002) ->
	#errorcode_msg{type = err203_not_have_coordinate,about = <<"缺失坐标"/utf8>>};

get(2030003) ->
	#errorcode_msg{type = er203_map_type_error,about = <<"藏宝图类型错误"/utf8>>};

get(2030004) ->
	#errorcode_msg{type = err203_distance_error,about = <<"挖宝距离太远"/utf8>>};

get(2030005) ->
	#errorcode_msg{type = er203_scene_error,about = <<"场景错误"/utf8>>};

get(2040001) ->
	#errorcode_msg{type = err204_act_close,about = <<"活动未开启"/utf8>>};

get(2040002) ->
	#errorcode_msg{type = err204_err_castle_id,about = <<"错误的据点id"/utf8>>};

get(2040003) ->
	#errorcode_msg{type = err204_illegal_castle_id,about = <<"不能驻扎该据点"/utf8>>};

get(2040004) ->
	#errorcode_msg{type = err204_error_stage,about = <<"阶段错误"/utf8>>};

get(2040005) ->
	#errorcode_msg{type = err204_not_enough_scramble_value,about = <<"不够争夺值"/utf8>>};

get(2040006) ->
	#errorcode_msg{type = err204_yet_get_reward,about = <<"已经领取奖励"/utf8>>};

get(2040007) ->
	#errorcode_msg{type = err204_error_goal_id,about = <<"任务id错误"/utf8>>};

get(2040008) ->
	#errorcode_msg{type = err204_goal_not_finish,about = <<"任务没有完成"/utf8>>};

get(2060001) ->
	#errorcode_msg{type = err206_not_enough_lv,about = <<"等级不足"/utf8>>};

get(2060002) ->
	#errorcode_msg{type = err206_scene_not_exist,about = <<"场景不存在"/utf8>>};

get(2060003) ->
	#errorcode_msg{type = err206_not_ng_scene,about = <<"当前场景不属于百鬼夜行"/utf8>>};

get(2060004) ->
	#errorcode_msg{type = err206_ng_boss_bc_reward_msg,about = <<"您第一个分享BOSS坐标,获得额外奖励"/utf8>>};

get(2100001) ->
	#errorcode_msg{type = err210_skill_max_lv,about = <<"该技能已经达到最大等级"/utf8>>};

get(2100002) ->
	#errorcode_msg{type = err210_skill_error,about = <<"技能配置错误"/utf8>>};

get(2100003) ->
	#errorcode_msg{type = err210_lv_not_enough,about = <<"人物等级不足，无法升级技能"/utf8>>};

get(2100004) ->
	#errorcode_msg{type = err210_coin_not_enough,about = <<"铜币不足"/utf8>>};

get(2100005) ->
	#errorcode_msg{type = err210_no_pre_skill,about = <<"前置技能未学习"/utf8>>};

get(2100006) ->
	#errorcode_msg{type = err210_no_pre_skill_lv,about = <<"前置技能等级不足，无法学习"/utf8>>};

get(2100007) ->
	#errorcode_msg{type = err210_point_not_enough,about = <<"技能点不足，无法升级技能"/utf8>>};

get(2100008) ->
	#errorcode_msg{type = err210_no_pre_skill_point,about = <<"技能投入点不足，无法学习或升级技能"/utf8>>};

get(2100009) ->
	#errorcode_msg{type = err210_no_learn_talent_skill,about = <<"未学习天赋技能，不能重置"/utf8>>};

get(2100010) ->
	#errorcode_msg{type = err210_not_mycarrer_talent_skill,about = <<"不能学习非本职业天赋技能"/utf8>>};

get(2100011) ->
	#errorcode_msg{type = err210_no_satisfy_turn,about = <<"人物转生次数不足，无法学习该技能"/utf8>>};

get(2100012) ->
	#errorcode_msg{type = err210_goods_not_enough,about = <<"物品不足，无法升级技能"/utf8>>};

get(2100013) ->
	#errorcode_msg{type = err210_skill_erro,about = <<"技能操作异常"/utf8>>};

get(2100014) ->
	#errorcode_msg{type = err210_not_enough_turn_to_stren_skill,about = <<"转生次数不足无法强化"/utf8>>};

get(2100015) ->
	#errorcode_msg{type = err210_not_enough_lv_to_stren_skill,about = <<"等级不足无法强化"/utf8>>};

get(2100016) ->
	#errorcode_msg{type = err210_max_skill_stren,about = <<"已经是最大强化数"/utf8>>};

get(2100017) ->
	#errorcode_msg{type = err210_not_this_skill_to_stren,about = <<"未解锁的技能无法进行强化"/utf8>>};

get(2100018) ->
	#errorcode_msg{type = err210_no_finish_task_id,about = <<"任务没有完成无法学习"/utf8>>};

get(2100019) ->
	#errorcode_msg{type = err210_skill_stren_can_not_gt_lv,about = <<"强化数不能超过玩家等级"/utf8>>};

get(2100020) ->
	#errorcode_msg{type = err210_no_satisfy_career,about = <<"指定职业才能学习该技能"/utf8>>};

get(2110001) ->
	#errorcode_msg{type = err211_had_select_core,about = <<"已经选择了核心类型"/utf8>>};

get(2110002) ->
	#errorcode_msg{type = err211_core_type_not_same,about = <<"本技能无法学习"/utf8>>};

get(2110003) ->
	#errorcode_msg{type = err211_must_finish_pre_skill,about = <<"必须学习前置技能"/utf8>>};

get(2110004) ->
	#errorcode_msg{type = err211_arcana_total_lv_not_enough,about = <<"远古奥术总等级不足"/utf8>>};

get(2110005) ->
	#errorcode_msg{type = err211_this_arcana_lv_not_enough,about = <<"指定的远古奥术等级不足"/utf8>>};

get(2110006) ->
	#errorcode_msg{type = err211_core_type_error,about = <<"选择的核心类型出错"/utf8>>};

get(2110007) ->
	#errorcode_msg{type = err211_open_day_not_enough,about = <<"开服天数不足"/utf8>>};

get(2110008) ->
	#errorcode_msg{type = err211_lv_not_enough,about = <<"等级不足"/utf8>>};

get(2110009) ->
	#errorcode_msg{type = err211_without_reset,about = <<"不需要重置"/utf8>>};

get(2150001) ->
	#errorcode_msg{type = err215_not_in_soul_scene,about = <<"玩家不在聚魂场景"/utf8>>};

get(2150002) ->
	#errorcode_msg{type = err215_yet_create_boss,about = <<"已经召唤了大妖"/utf8>>};

get(2150003) ->
	#errorcode_msg{type = err215_not_enough_power,about = <<"能量不足"/utf8>>};

get(2150004) ->
	#errorcode_msg{type = err215_skill_not_exist,about = <<"技能不存在"/utf8>>};

get(2150005) ->
	#errorcode_msg{type = err215_err_sweep_boss_num,about = <<"扫荡召唤大妖数量错误"/utf8>>};

get(2150006) ->
	#errorcode_msg{type = err215_sweep_never_finish,about = <<"需要完整通关后方可扫荡"/utf8>>};

get(2150007) ->
	#errorcode_msg{type = err215_not_enough_sweep_goods,about = <<"扫荡卷不足"/utf8>>};

get(2150008) ->
	#errorcode_msg{type = err215_not_finish_dun,about = <<"未完成副本"/utf8>>};

get(2150009) ->
	#errorcode_msg{type = err215_yet_got_reward,about = <<"已经领取奖励"/utf8>>};

get(2150010) ->
	#errorcode_msg{type = err215_not_finish_dun2,about = <<"需要完整通关后方可领取"/utf8>>};

get(2160001) ->
	#errorcode_msg{type = err216_not_enough_lv,about = <<"等级不足，无法召唤魔法阵"/utf8>>};

get(2160002) ->
	#errorcode_msg{type = err216_yet_open,about = <<"该魔法阵已召唤成功"/utf8>>};

get(2160003) ->
	#errorcode_msg{type = err216_not_have_free_times,about = <<"没有免费体验次数"/utf8>>};

get(2160004) ->
	#errorcode_msg{type = err216_free_time,about = <<"魔法阵体验期间无法召唤高级魔法阵"/utf8>>};

get(2160005) ->
	#errorcode_msg{type = err216_show,about = <<"请勿频繁操作。"/utf8>>};

get(2160006) ->
	#errorcode_msg{type = err216_have_higher,about = <<"已经激活永久的神龛"/utf8>>};

get(2170001) ->
	#errorcode_msg{type = err217_max_day_used_times,about = <<"今天已达最大使用次数"/utf8>>};

get(2170002) ->
	#errorcode_msg{type = err217_max_used_times,about = <<"已达最大使用次数"/utf8>>};

get(2180001) ->
	#errorcode_msg{type = err218_not_enough_day,about = <<"开服天数不足"/utf8>>};

get(2180002) ->
	#errorcode_msg{type = err218_act_close,about = <<"活动未开启"/utf8>>};

get(2180003) ->
	#errorcode_msg{type = err218_in_act,about = <<"在阴阳战场活动中"/utf8>>};

get(2180004) ->
	#errorcode_msg{type = err218_not_enough_point,about = <<"积分不足"/utf8>>};

get(2180005) ->
	#errorcode_msg{type = err218_yet_get_point_reward,about = <<"已经获取了该积分奖励"/utf8>>};

get(2180006) ->
	#errorcode_msg{type = err650_not_in_act,about = <<"不在阴阳战场活动中"/utf8>>};

get(2220001) ->
	#errorcode_msg{type = err222_goods_not_enough,about = <<"物品不够"/utf8>>};

get(2220002) ->
	#errorcode_msg{type = err222_combat_not_enough,about = <<"战力不够"/utf8>>};

get(2220003) ->
	#errorcode_msg{type = err222_title_not_equel,about = <<"职称与服务器不对应"/utf8>>};

get(2220004) ->
	#errorcode_msg{type = err222_title_config_error,about = <<"配置出错"/utf8>>};

get(2220005) ->
	#errorcode_msg{type = err222_deduction_goods_error,about = <<"扣除物品失败"/utf8>>};

get(2220006) ->
	#errorcode_msg{type = err222_6_not_enough_server_day,about = <<"开服天数不够"/utf8>>};

get(2220007) ->
	#errorcode_msg{type = err222_title_lv_max,about = <<"头衔等级已达最高"/utf8>>};

get(2230001) ->
	#errorcode_msg{type = err223_num_not_enough,about = <<"砸蛋次数不足"/utf8>>};

get(2230002) ->
	#errorcode_msg{type = err223_lv_not_enough,about = <<"等级不足"/utf8>>};

get(2230003) ->
	#errorcode_msg{type = err223_vip_not_enough,about = <<"贵族等级不足"/utf8>>};

get(2230004) ->
	#errorcode_msg{type = err223_shop_not_provide,about = <<"商城没有出售该商品"/utf8>>};

get(2230005) ->
	#errorcode_msg{type = err223_reset_time,about = <<"当前为重置时间"/utf8>>};

get(2230006) ->
	#errorcode_msg{type = err223_dissatisfy_send_gift_condition,about = <<"未达到赠送条件"/utf8>>};

get(2230007) ->
	#errorcode_msg{type = err223_receiver_lv_not_enough,about = <<"未达到赠送条件"/utf8>>};

get(2240001) ->
	#errorcode_msg{type = err224_not_same_zone,about = <<"不能赠送非相同跨服的玩家"/utf8>>};

get(2240002) ->
	#errorcode_msg{type = err224_others_stop_server,about = <<"对方处于停服当中，不能送花！"/utf8>>};

get(2250001) ->
	#errorcode_msg{type = err255_err_rank_type,about = <<"错误的榜单类型"/utf8>>};

get(2250002) ->
	#errorcode_msg{type = err225_not_on_rank,about = <<"没有上榜"/utf8>>};

get(2250003) ->
	#errorcode_msg{type = err225_rank_not_end,about = <<"该排行榜没有结算"/utf8>>};

get(2250004) ->
	#errorcode_msg{type = err255_err_reward_id,about = <<"排行榜档次错误"/utf8>>};

get(2250005) ->
	#errorcode_msg{type = err225_the_rank_not_start,about = <<"该排行榜还没开始"/utf8>>};

get(2320001) ->
	#errorcode_msg{type = err232_no_cfg,about = <<"没有当前配置"/utf8>>};

get(2320002) ->
	#errorcode_msg{type = err232_strength_max,about = <<"已达最大强化等级"/utf8>>};

get(2320003) ->
	#errorcode_msg{type = err232_strength_master_no,about = <<"当前强化等级不足，无法点亮"/utf8>>};

get(2320004) ->
	#errorcode_msg{type = err232_evolution_max,about = <<"已经达最大进化等级"/utf8>>};

get(2320005) ->
	#errorcode_msg{type = err232_evolution_color,about = <<"拥有2条及以上卓越属性的装备方可进化~"/utf8>>};

get(2320006) ->
	#errorcode_msg{type = err232_no_dress,about = <<"只能进化穿在身上的装备哦~"/utf8>>};

get(2320007) ->
	#errorcode_msg{type = err232_enchantment_max,about = <<"已达最大觉醒等级"/utf8>>};

get(2320008) ->
	#errorcode_msg{type = err232_had_spirit,about = <<"已经启灵过了哦~"/utf8>>};

get(2320009) ->
	#errorcode_msg{type = err232_evolution_euqip_point,about = <<"该装备不能提供额外成功率~"/utf8>>};

get(2320010) ->
	#errorcode_msg{type = err232_not_active,about = <<"装备页未解锁"/utf8>>};

get(2320011) ->
	#errorcode_msg{type = err232_can_not_equip,about = <<"装备不满足穿戴要求"/utf8>>};

get(2320012) ->
	#errorcode_msg{type = err232_equip_condition_error,about = <<"未达到激活要求"/utf8>>};

get(2320013) ->
	#errorcode_msg{type = err232_max_decompose_level,about = <<"吞噬等级达到上限"/utf8>>};

get(2320014) ->
	#errorcode_msg{type = err232_has_stren_up,about = <<"请不要重复升级"/utf8>>};

get(2320015) ->
	#errorcode_msg{type = err232_star_not_enougth,about = <<"星数未达到升级要求"/utf8>>};

get(2320016) ->
	#errorcode_msg{type = err232_wrong_data,about = <<"数据异常"/utf8>>};

get(2320017) ->
	#errorcode_msg{type = err232_wrong_material,about = <<"该资源无法用于当前合成规则"/utf8>>};

get(2320018) ->
	#errorcode_msg{type = err232_has_active,about = <<"该装备页已解锁！"/utf8>>};

get(2320019) ->
	#errorcode_msg{type = err232_active_before_level,about = <<"请先激活之前等级！"/utf8>>};

get(2320020) ->
	#errorcode_msg{type = err232_enchantment_master_no,about = <<"没有可激活的觉醒大师~"/utf8>>};

get(2320021) ->
	#errorcode_msg{type = err232_wrong_num,about = <<"数量不足"/utf8>>};

get(2320022) ->
	#errorcode_msg{type = err232_has_star_attr,about = <<"已经有卓越星级属性了"/utf8>>};

get(2320023) ->
	#errorcode_msg{type = err232_material_not_enougth,about = <<"资源不足，无法合成"/utf8>>};

get(2320024) ->
	#errorcode_msg{type = err232_star_not_enougth_to_translate,about = <<"橙色以上装备才可被转移属性"/utf8>>};

get(2320025) ->
	#errorcode_msg{type = err232_color_not_enougth_to_translate,about = <<"同品质无法进行转移"/utf8>>};

get(2330001) ->
	#errorcode_msg{type = err233_had_active,about = <<"已激活该神纹~~"/utf8>>};

get(2330002) ->
	#errorcode_msg{type = err233_no_cfg,about = <<"没有当前配置~~"/utf8>>};

get(2330003) ->
	#errorcode_msg{type = err233_lv_limit,about = <<"神祈等级不足无法解锁"/utf8>>};

get(2330004) ->
	#errorcode_msg{type = err233_no_active,about = <<"未激活当前神纹~~"/utf8>>};

get(2330005) ->
	#errorcode_msg{type = err233_pos,about = <<"非该神纹的核心装备不能进行穿戴"/utf8>>};

get(2330006) ->
	#errorcode_msg{type = err233_max_stage,about = <<"已达最大阶数~~"/utf8>>};

get(2330007) ->
	#errorcode_msg{type = err233_max_lv,about = <<"神纹已达最大等级~~"/utf8>>};

get(2330008) ->
	#errorcode_msg{type = err233_no_condition,about = <<"未达到领取条件~~"/utf8>>};

get(2330009) ->
	#errorcode_msg{type = err233_had_get,about = <<"奖励已领取~~"/utf8>>};

get(2330010) ->
	#errorcode_msg{type = err233_no_reward,about = <<"没有当前奖励~~"/utf8>>};

get(2330011) ->
	#errorcode_msg{type = err_233_had_origin,about = <<"当前已是橙色品质无需再提升~"/utf8>>};

get(2330012) ->
	#errorcode_msg{type = err233_pos_equip_origin,about = <<"8个纹章部位穿戴橙色及以上品质后方可装备"/utf8>>};

get(2330013) ->
	#errorcode_msg{type = err_233_max_color,about = <<"当前已是最高品质无需再提升~"/utf8>>};

get(2330014) ->
	#errorcode_msg{type = err233_bag_not_enough,about = <<"神社背包不足"/utf8>>};

get(2400001) ->
	#errorcode_msg{type = err240_in_team,about = <<"您已经有队伍"/utf8>>};

get(2400002) ->
	#errorcode_msg{type = err240_changing_scene,about = <<"您正在切换场景"/utf8>>};

get(2400003) ->
	#errorcode_msg{type = err240_no_team,about = <<"该玩家没有队伍"/utf8>>};

get(2400004) ->
	#errorcode_msg{type = err240_kick_himself,about = <<"您不能踢除您自己"/utf8>>};

get(2400005) ->
	#errorcode_msg{type = err240_max_member,about = <<"队伍人数已满"/utf8>>};

get(2400006) ->
	#errorcode_msg{type = err240_not_leader,about = <<"您不是队长"/utf8>>};

get(2400007) ->
	#errorcode_msg{type = err240_not_kick_leader,about = <<"不能踢队长"/utf8>>};

get(2400008) ->
	#errorcode_msg{type = err240_leader_reject,about = <<"对方拒绝您的加入"/utf8>>};

get(2400009) ->
	#errorcode_msg{type = err240_other_offline,about = <<"对方不在线"/utf8>>};

get(2400010) ->
	#errorcode_msg{type = err240_other_in_team,about = <<"对方已经有队伍"/utf8>>};

get(2400011) ->
	#errorcode_msg{type = err240_team_disappear,about = <<"该队伍已解散"/utf8>>};

get(2400012) ->
	#errorcode_msg{type = err240_offline,about = <<"对方已经下线"/utf8>>};

get(2400013) ->
	#errorcode_msg{type = err240_arbitrate_timeout,about = <<"入场投票超时"/utf8>>};

get(2400014) ->
	#errorcode_msg{type = err240_arbitrate_refuse,about = <<"{1}拒绝进入"/utf8>>};

get(2400015) ->
	#errorcode_msg{type = err240_not_current_aribirate_req,about = <<"投票已经过期"/utf8>>};

get(2400017) ->
	#errorcode_msg{type = err240_not_on_arbitrate_req_to_vote,about = <<"没有投票"/utf8>>};

get(2400018) ->
	#errorcode_msg{type = err240_not_leader_to_arbitrate_req,about = <<"只有队长可以发起入场投票"/utf8>>};

get(2400019) ->
	#errorcode_msg{type = err240_not_arbitrate_req_in_dungeon,about = <<"在副本中无法发起入场投票"/utf8>>};

get(2400020) ->
	#errorcode_msg{type = err240_not_again_arbitrate_req,about = <<"不能重复发起入场投票"/utf8>>};

get(2400021) ->
	#errorcode_msg{type = err240_not_team_dungeon,about = <<"不是队伍副本"/utf8>>};

get(2400022) ->
	#errorcode_msg{type = err240_join_team,about = <<"您加入了新的队伍"/utf8>>};

get(2400023) ->
	#errorcode_msg{type = err240_new_member,about = <<"{1}加入队伍"/utf8>>};

get(2400024) ->
	#errorcode_msg{type = err240_self_out_team,about = <<"您离开了队伍"/utf8>>};

get(2400025) ->
	#errorcode_msg{type = err240_out_team,about = <<"{1}离开了队伍"/utf8>>};

get(2400026) ->
	#errorcode_msg{type = err240_self_shot_of_team,about = <<"您被请出了队伍"/utf8>>};

get(2400027) ->
	#errorcode_msg{type = err240_shot_of_team,about = <<"{1}被请出了队伍"/utf8>>};

get(2400028) ->
	#errorcode_msg{type = err240_no_member_follow,about = <<"当前没有队员跟战"/utf8>>};

get(2400029) ->
	#errorcode_msg{type = err240_cancel_follow_success,about = <<"取消队员跟战成功"/utf8>>};

get(2400030) ->
	#errorcode_msg{type = err240_change_state_to_interrput_arbitrate,about = <<"队伍状态改变,投票中断"/utf8>>};

get(2400031) ->
	#errorcode_msg{type = err240_on_dungeon_not_to_do,about = <<"队伍处于副本中无法进行操作"/utf8>>};

get(2400032) ->
	#errorcode_msg{type = err240_not_on_team,about = <<"不在队伍中，无法操作"/utf8>>};

get(2400033) ->
	#errorcode_msg{type = err240_this_team_on_dungeon,about = <<"本队伍处于副本中，无法加入"/utf8>>};

get(2400034) ->
	#errorcode_msg{type = err240_34_no_invite_role,about = <<"无邀请对象"/utf8>>};

get(2400035) ->
	#errorcode_msg{type = err240_agree_to_enter_safety_scene,about = <<"{1}同意,正玩命赶回安全区."/utf8>>};

get(2400036) ->
	#errorcode_msg{type = err240_not_enough_lv_to_create_team,about = <<"等级不足，无法创建队伍"/utf8>>};

get(2400037) ->
	#errorcode_msg{type = err240_not_enough_lv_to_join_team,about = <<"等级不足，无法加入队伍"/utf8>>};

get(2400038) ->
	#errorcode_msg{type = err240_not_enough_lv_to_enter_target,about = <<"没有达到进入该目标的等级"/utf8>>};

get(2400039) ->
	#errorcode_msg{type = err240_not_enough_lv_to_enter_target_with_name,about = <<"{1}没有达到进入该目标的等级"/utf8>>};

get(2400040) ->
	#errorcode_msg{type = err240_not_enough_lv_to_create_target,about = <<"您没有达到目标的最低等级，无法创建"/utf8>>};

get(2400047) ->
	#errorcode_msg{type = err240_not_on_safe_scene_to_outdoor_by_other,about = <<"{1}所在场景无法进入"/utf8>>};

get(2400048) ->
	#errorcode_msg{type = err240_choose_lv_error,about = <<"等级范围不合法"/utf8>>};

get(2400049) ->
	#errorcode_msg{type = err240_auto_pair_limit,about = <<"该目标不可匹配"/utf8>>};

get(2400050) ->
	#errorcode_msg{type = err240_change_when_matching,about = <<"正在自动匹配中，请先取消自动匹配"/utf8>>};

get(2400051) ->
	#errorcode_msg{type = err240_all_for_help_other,about = <<"全员均助战，无法进入副本"/utf8>>};

get(2400052) ->
	#errorcode_msg{type = err240_teammates_offline,about = <<"{1}不在线"/utf8>>};

get(2400053) ->
	#errorcode_msg{type = err240_cost_error,about = <<"{1}物品不足"/utf8>>};

get(2400054) ->
	#errorcode_msg{type = err240_help_type_setup_limit,about = <<"该副本类型不能设置助战"/utf8>>};

get(2400055) ->
	#errorcode_msg{type = err240_too_many_members,about = <<"队伍人数超过新目标限定人数"/utf8>>};

get(2400056) ->
	#errorcode_msg{type = err240_team_create_unfinished,about = <<"正在创建队伍中，请勿进行其它操作"/utf8>>};

get(2400057) ->
	#errorcode_msg{type = err240_cls_type_error,about = <<"请先把队伍目标改成{1}"/utf8>>};

get(2400058) ->
	#errorcode_msg{type = err240_in_arbitrate,about = <<"当前正在队伍投票中，无法操作"/utf8>>};

get(2400059) ->
	#errorcode_msg{type = err240_me_to_other,about = <<"{1}{2}"/utf8>>};

get(2400060) ->
	#errorcode_msg{type = err240_evil_smashing_matching,about = <<"当前正在诛邪战场匹配中"/utf8>>};

get(2400061) ->
	#errorcode_msg{type = err240_local_team_with_other_serv,about = <<"队伍里有跨服成员无法切换成本服队伍"/utf8>>};

get(2400062) ->
	#errorcode_msg{type = err240_this_team_matching,about = <<"该队伍正在匹配诛邪战场，无法加入"/utf8>>};

get(2400063) ->
	#errorcode_msg{type = err240_arbitrate_vote_repeat,about = <<"您已经投过票了"/utf8>>};

get(2400064) ->
	#errorcode_msg{type = err240_invite_diff_target_error,about = <<"队员无法邀请别人进队"/utf8>>};

get(2400065) ->
	#errorcode_msg{type = err240_no_teams_for_match,about = <<"没有可匹配的队伍"/utf8>>};

get(2400066) ->
	#errorcode_msg{type = err240_choose_target_first,about = <<"请先选择组队目标"/utf8>>};

get(2400067) ->
	#errorcode_msg{type = err610_dungeon_leader_help_type_limit,about = <<"队长不能助战"/utf8>>};

get(2400068) ->
	#errorcode_msg{type = err240_team_target_changed,about = <<"该队伍的目标已改变"/utf8>>};

get(2400069) ->
	#errorcode_msg{type = err240_team_starting,about = <<"队伍正在准备进入活动中"/utf8>>};

get(2400070) ->
	#errorcode_msg{type = err240_invite_res_has_team,about = <<"{1}已经有队伍"/utf8>>};

get(2400071) ->
	#errorcode_msg{type = err240_invite_res_check_fail,about = <<"{1}条件不足，无法加入队伍"/utf8>>};

get(2400072) ->
	#errorcode_msg{type = err240_invite_res_ok,about = <<"邀请{1}成功"/utf8>>};

get(2400073) ->
	#errorcode_msg{type = err240_not_join_type,about = <<"错误的进入类型"/utf8>>};

get(2400074) ->
	#errorcode_msg{type = err240_ugre_open_act,about = <<"{1}队员催促你赶紧开车"/utf8>>};

get(2400075) ->
	#errorcode_msg{type = err240_teammates_offline_to_cancel_match,about = <<"{1}离线，终止匹配"/utf8>>};

get(2400076) ->
	#errorcode_msg{type = err240_my_cost_error_exp,about = <<"宝库入场券不足，请到商城购买"/utf8>>};

get(2400077) ->
	#errorcode_msg{type = err240_teammates_offline_to_cancel_arbitrate,about = <<"{1}离线，终止投票"/utf8>>};

get(2400078) ->
	#errorcode_msg{type = err240_not_enough_join_value_to_enter_target_with_name,about = <<"没有达到进入该目标的资格"/utf8>>};

get(2400079) ->
	#errorcode_msg{type = err240_no_qualification,about = <<"没达到入队资格"/utf8>>};

get(2400080) ->
	#errorcode_msg{type = err240_invite_res_in_assist,about = <<"{1}正在结社协助中"/utf8>>};

get(2400081) ->
	#errorcode_msg{type = err204_in_guild_assist,about = <<"正在结社协助中，不能组队！"/utf8>>};

get(2790001) ->
	#errorcode_msg{type = err279_act_not_open,about = <<"当前活动暂未开启"/utf8>>};

get(2790002) ->
	#errorcode_msg{type = err279_act_end,about = <<"活动已结束"/utf8>>};

get(2790003) ->
	#errorcode_msg{type = err279_act_enter_limit,about = <<"活动进入截止时间已过"/utf8>>};

get(2790004) ->
	#errorcode_msg{type = err279_act_scene_user_limit,about = <<"场景人数已达到上限！"/utf8>>};

get(2790005) ->
	#errorcode_msg{type = err279_get_normal_scence_bl,about = <<"请先占领一个结界场景后方可进入"/utf8>>};

get(2790006) ->
	#errorcode_msg{type = err279_lv_limit,about = <<"等级小于开启神意之地最低等级！"/utf8>>};

get(2790007) ->
	#errorcode_msg{type = err279_openday_limit,about = <<"开服天数小于开启神意之地最低需求！"/utf8>>};

get(2800001) ->
	#errorcode_msg{type = err280_over_max_buy_num,about = <<"超出可购买次数"/utf8>>};

get(2800002) ->
	#errorcode_msg{type = err280_inspire_max,about = <<"已达最大鼓舞次数"/utf8>>};

get(2800003) ->
	#errorcode_msg{type = err280_jjc_num,about = <<"挑战次数错误"/utf8>>};

get(2800004) ->
	#errorcode_msg{type = err280_none_reward,about = <<"没有奖励"/utf8>>};

get(2800005) ->
	#errorcode_msg{type = err280_already_receive_reward,about = <<"已领取奖励"/utf8>>};

get(2800006) ->
	#errorcode_msg{type = err280_rival_rank_change,about = <<"对手排名已改变"/utf8>>};

get(2800007) ->
	#errorcode_msg{type = err280_self_rank_change,about = <<"自己排名已改变"/utf8>>};

get(2800008) ->
	#errorcode_msg{type = err280_jjc_num_not_enough,about = <<"挑战次数不足"/utf8>>};

get(2800009) ->
	#errorcode_msg{type = err280_lv_not_enough,about = <<"等级不足"/utf8>>};

get(2800010) ->
	#errorcode_msg{type = err280_on_battle_state,about = <<"该玩家正在战斗中，请稍后"/utf8>>};

get(2800011) ->
	#errorcode_msg{type = err280_jjc_inspire_max,about = <<"最大鼓舞"/utf8>>};

get(2800012) ->
	#errorcode_msg{type = err280_rank_limit_not_to_battle,about = <<"进入前十名才能挑战前三名玩家"/utf8>>};

get(2800013) ->
	#errorcode_msg{type = err280_not_battle_myslef,about = <<"不能挑战自己"/utf8>>};

get(2800014) ->
	#errorcode_msg{type = err280_can_not_direct_battle,about = <<"无法直接结算"/utf8>>};

get(2800015) ->
	#errorcode_msg{type = err280_have_not_reward,about = <<"不能领取"/utf8>>};

get(2800016) ->
	#errorcode_msg{type = err280_had_reward,about = <<"已经领取"/utf8>>};

get(2810001) ->
	#errorcode_msg{type = err281_award_is_got,about = <<"奖励已经领取"/utf8>>};

get(2810002) ->
	#errorcode_msg{type = err281_daily_enter_count_error,about = <<"参与次数不足"/utf8>>};

get(2810003) ->
	#errorcode_msg{type = err281_buy_count_limit,about = <<"您的可购买次数不足"/utf8>>};

get(2810004) ->
	#errorcode_msg{type = err281_match_repeat,about = <<"您已经在匹配中"/utf8>>};

get(2810005) ->
	#errorcode_msg{type = err281_on_matching_state,about = <<"当前正在巅峰竞技匹配中"/utf8>>};

get(2810006) ->
	#errorcode_msg{type = err281_not_on_match_state,about = <<"当前不在匹配状态中"/utf8>>};

get(2810007) ->
	#errorcode_msg{type = err281_on_battle_state,about = <<"当前正在参与巅峰竞技中"/utf8>>};

get(2810008) ->
	#errorcode_msg{type = err281_grade_limit,about = <<"您的段位不足"/utf8>>};

get(2810009) ->
	#errorcode_msg{type = err281_no_honor_reward,about = <<"没有可领取的荣誉值"/utf8>>};

get(2810010) ->
	#errorcode_msg{type = err281_enemy_is_late,about = <<"由于您的对手不能及时到场，您获得胜利"/utf8>>};

get(2830001) ->
	#errorcode_msg{type = err283_act_not_open,about = <<"8:00-19:30和21:30-2:00为活动时间"/utf8>>};

get(2830002) ->
	#errorcode_msg{type = err283_act_not_open2,about = <<"开服第4天19:30活动结束"/utf8>>};

get(2830003) ->
	#errorcode_msg{type = err283_act_not_open3,about = <<"开服第2天开放异域活动"/utf8>>};

get(2830004) ->
	#errorcode_msg{type = err283_act_not_open4,about = <<"8:00-19:30为活动时间"/utf8>>};

get(2840001) ->
	#errorcode_msg{type = scene_error,about = <<"场景数据异常"/utf8>>};

get(2840002) ->
	#errorcode_msg{type = can_not_enter,about = <<"进入条件不满足"/utf8>>};

get(2840003) ->
	#errorcode_msg{type = can_not_enter_scene,about = <<"请占领前置场景"/utf8>>};

get(2840004) ->
	#errorcode_msg{type = has_recieve,about = <<"您已领取过该奖励"/utf8>>};

get(2840005) ->
	#errorcode_msg{type = not_achieve,about = <<"不满足领取条件"/utf8>>};

get(2840006) ->
	#errorcode_msg{type = error_data,about = <<"配置数据异常"/utf8>>};

get(2840007) ->
	#errorcode_msg{type = lv_limit_san,about = <<"等级不足"/utf8>>};

get(2840008) ->
	#errorcode_msg{type = time_limit,about = <<"不在活动开启时间"/utf8>>};

get(2840009) ->
	#errorcode_msg{type = has_unlocked,about = <<"您已解锁后续奖励"/utf8>>};

get(2840010) ->
	#errorcode_msg{type = already_in_scene,about = <<"已在蜃气楼场景！"/utf8>>};

get(2840011) ->
	#errorcode_msg{type = err284_enter_cluster,about = <<"正在排队进入蜃气楼中!"/utf8>>};

get(2850001) ->
	#errorcode_msg{type = err285_act_closed,about = <<"活动未开启"/utf8>>};

get(2850002) ->
	#errorcode_msg{type = err285_can_not_change_scene_in_midday_party,about = <<"当前场景无法进入"/utf8>>};

get(2850003) ->
	#errorcode_msg{type = err285_low_box_collect_limit,about = <<"普通宝箱采集已达上限"/utf8>>};

get(2850004) ->
	#errorcode_msg{type = err285_high_box_collect_limit,about = <<"高级宝箱采集已达上限"/utf8>>};

get(2860001) ->
	#errorcode_msg{type = err286_err_pos,about = <<"位置错误"/utf8>>};

get(2860002) ->
	#errorcode_msg{type = err286_err_exp_not_enough,about = <<"经验不足"/utf8>>};

get(2860003) ->
	#errorcode_msg{type = err286_err_max_lv,about = <<"最大等级"/utf8>>};

get(2860004) ->
	#errorcode_msg{type = err_286_max_skill_lv,about = <<"需先提升聚灵等级"/utf8>>};

get(2860005) ->
	#errorcode_msg{type = err_286_err_gathering,about = <<"聚灵等级不符合"/utf8>>};

get(2860006) ->
	#errorcode_msg{type = err_286_err_skill_id,about = <<"技能id错误"/utf8>>};

get(2860007) ->
	#errorcode_msg{type = err286_same_figure_id,about = <<"已经是当前形象"/utf8>>};

get(2860008) ->
	#errorcode_msg{type = err286_not_have_figure,about = <<"未拥有形象"/utf8>>};

get(3000001) ->
	#errorcode_msg{type = err300_task_trigger,about = <<"此任务已接取"/utf8>>};

get(3000002) ->
	#errorcode_msg{type = err300_task_config_null,about = <<"任务配置错误（无此任务）"/utf8>>};

get(3000003) ->
	#errorcode_msg{type = err300_lv_not_enough,about = <<"等级不足，无法接取任务"/utf8>>};

get(3000004) ->
	#errorcode_msg{type = err300_not_guild,about = <<"请加入帮派后再接取此任务"/utf8>>};

get(3000005) ->
	#errorcode_msg{type = err300_realm_diff,about = <<"阵营不符，无法接取"/utf8>>};

get(3000006) ->
	#errorcode_msg{type = err300_career_diff,about = <<"职业不符，无法接取"/utf8>>};

get(3000007) ->
	#errorcode_msg{type = err300_prev_not_fin,about = <<"前置任务未完成"/utf8>>};

get(3000008) ->
	#errorcode_msg{type = err300_fin,about = <<"任务已完成"/utf8>>};

get(3000009) ->
	#errorcode_msg{type = err300_condition_err,about = <<"条件不满足，无法接取（暂定提示）"/utf8>>};

get(3000010) ->
	#errorcode_msg{type = err300_not_enough_cell,about = <<"背包空间不足，请清理后再完成"/utf8>>};

get(3000011) ->
	#errorcode_msg{type = err300_turn_diff,about = <<"转生次数不符，无法领取"/utf8>>};

get(3000012) ->
	#errorcode_msg{type = err300_daily_task_finished,about = <<"今日日常任务已全部完成"/utf8>>};

get(3000013) ->
	#errorcode_msg{type = err300_guild_task_finished,about = <<"结社周任务已全部完成"/utf8>>};

get(3000014) ->
	#errorcode_msg{type = err300_no_task_trigger,about = <<"此任务未领取"/utf8>>};

get(3000015) ->
	#errorcode_msg{type = err300_task_no_finish,about = <<"任务没有完成"/utf8>>};

get(3000016) ->
	#errorcode_msg{type = err300_lv_no_task,about = <<"您的等级段没有相应的任务"/utf8>>};

get(3000017) ->
	#errorcode_msg{type = err300_task_cost_not_enough,about = <<"完成任务所需提交的物品不足，无法完成任务"/utf8>>};

get(3310001) ->
	#errorcode_msg{type = err331_act_closed,about = <<"活动未开启"/utf8>>};

get(3310002) ->
	#errorcode_msg{type = err331_no_act_reward_cfg,about = <<"没有活动奖励配置"/utf8>>};

get(3310003) ->
	#errorcode_msg{type = err331_act_can_not_get,about = <<"条件不足,不能领取"/utf8>>};

get(3310004) ->
	#errorcode_msg{type = err331_already_get_reward,about = <<"奖励已领取"/utf8>>};

get(3310005) ->
	#errorcode_msg{type = err331_fs_already_evaluate,about = <<"已经评价过"/utf8>>};

get(3310006) ->
	#errorcode_msg{type = err331_act_time_out,about = <<"奖励超时"/utf8>>};

get(3310007) ->
	#errorcode_msg{type = err331_smashed_egg_refresh_fail,about = <<"刷新失败，您今天的砸蛋次数已用完"/utf8>>};

get(3310008) ->
	#errorcode_msg{type = err331_smashed_egg_times_lim,about = <<"本日勾玉砸蛋次数已达到上限"/utf8>>};

get(3310009) ->
	#errorcode_msg{type = err331_limit_buy_daily_num_max,about = <<"本日数量已卖完"/utf8>>};

get(3310010) ->
	#errorcode_msg{type = err331_egg_has_smashed,about = <<"这个金蛋已经被砸过了"/utf8>>};

get(3310011) ->
	#errorcode_msg{type = err331_cloud_buy_end,about = <<"购买时间已结束，下次请早"/utf8>>};

get(3310012) ->
	#errorcode_msg{type = err331_cloud_buy_order_unfinished,about = <<"上一订单尚未完成"/utf8>>};

get(3310013) ->
	#errorcode_msg{type = err331_cloud_buy_personal_limit,about = <<"当前个人限购次数已达上限"/utf8>>};

get(3310014) ->
	#errorcode_msg{type = err331_cloud_buy_not_enough,about = <<"当前剩余份数不足十份"/utf8>>};

get(3310015) ->
	#errorcode_msg{type = err331_act_boss_scene_tips,about = <<"无法获悉大妖的入侵地点，请小心搜索"/utf8>>};

get(3310016) ->
	#errorcode_msg{type = err331_act_boss_scene_people_lim,about = <<"该场景已满人，建议到别处剿灭大妖"/utf8>>};

get(3310017) ->
	#errorcode_msg{type = err331_act_boss_scene_no_boss,about = <<"该场景内的大妖已全部被击退，建议到别处继续剿灭"/utf8>>};

get(3310018) ->
	#errorcode_msg{type = err331_act_mission_complete,about = <<"本轮活动已完成"/utf8>>};

get(3310019) ->
	#errorcode_msg{type = err331_count_limit,about = <<"奖励已被领完"/utf8>>};

get(3310020) ->
	#errorcode_msg{type = err331_only_president_reward,about = <<"只有会长才能领取该奖励"/utf8>>};

get(3310021) ->
	#errorcode_msg{type = err331_ticket_limit,about = <<"抽奖券不足"/utf8>>};

get(3310022) ->
	#errorcode_msg{type = err331_limit_buy_daily_player_max,about = <<"该商品本日个人次数已买完"/utf8>>};

get(3310023) ->
	#errorcode_msg{type = err331_not_in_buy_day,about = <<"不在活动购买期间内"/utf8>>};

get(3310024) ->
	#errorcode_msg{type = err331_login_return_reward_has_buy,about = <<"不能重复购买"/utf8>>};

get(3310025) ->
	#errorcode_msg{type = err331_act_data_err,about = <<"活动数据有误，请重新打开界面"/utf8>>};

get(3310026) ->
	#errorcode_msg{type = err331_pls_wait_for_next_act,about = <<"敬请期待下次活动"/utf8>>};

get(3310027) ->
	#errorcode_msg{type = err331_kf_cloud_buy_product_id_err,about = <<"商品无效"/utf8>>};

get(3310028) ->
	#errorcode_msg{type = err331_kf_cloud_buy_total_buy_num_lim,about = <<"商品剩余份数不足"/utf8>>};

get(3310029) ->
	#errorcode_msg{type = err331_kf_cloud_buy_personal_buy_num_lim,about = <<"达到个人购买份数上限"/utf8>>};

get(3310030) ->
	#errorcode_msg{type = err331_kf_cloud_buy_drawing,about = <<"开奖中，敬请期待"/utf8>>};

get(3310036) ->
	#errorcode_msg{type = err331_flop_reward_has_obtain,about = <<"已经翻过这张牌了"/utf8>>};

get(3310037) ->
	#errorcode_msg{type = err331_flop_times_lim,about = <<"已达本日翻牌次数上限"/utf8>>};

get(3310038) ->
	#errorcode_msg{type = err331_pls_open_first,about = <<"请先展开牌组"/utf8>>};

get(3310039) ->
	#errorcode_msg{type = err331_cloud_buy_not_ennough,about = <<"今日云购大奖已卖完！"/utf8>>};

get(3310040) ->
	#errorcode_msg{type = err331_login_times_limit,about = <<"活动期间累计登陆次数/充值金额不足！"/utf8>>};

get(3310041) ->
	#errorcode_msg{type = err331_shake_not_enough,about = <<"抽奖次数不足"/utf8>>};

get(3310042) ->
	#errorcode_msg{type = err331_error_data,about = <<"数据出错，请重新抽奖！"/utf8>>};

get(3310043) ->
	#errorcode_msg{type = err331_lv_not_enougth,about = <<"等级不足！"/utf8>>};

get(3310044) ->
	#errorcode_msg{type = err331_has_recieve,about = <<"领取过该奖励！"/utf8>>};

get(3310046) ->
	#errorcode_msg{type = err331_reward_preparing,about = <<"大奖筹备中，请等待下次云购！"/utf8>>};

get(3310047) ->
	#errorcode_msg{type = err331_error_send_data,about = <<"兑换数量异常，请重新输入！"/utf8>>};

get(3310048) ->
	#errorcode_msg{type = err331_reset_times_not_enougth,about = <<"本次活动已完成，请期待下次活动"/utf8>>};

get(3310049) ->
	#errorcode_msg{type = err331_has_buy,about = <<"您已购买过该商品"/utf8>>};

get(3310050) ->
	#errorcode_msg{type = err331_reward_cfg_is_null,about = <<"该阶段无可购买奖励"/utf8>>};

get(3310051) ->
	#errorcode_msg{type = err331_not_open_hour_list,about = <<"不在抽奖时间内"/utf8>>};

get(3310052) ->
	#errorcode_msg{type = err331_reset_before_choose,about = <<"请先将活动重置，再选择奖池"/utf8>>};

get(3310053) ->
	#errorcode_msg{type = err331_max_reset_num,about = <<"已达到活动最大重置次数"/utf8>>};

get(3310054) ->
	#errorcode_msg{type = err331_pool_is_null,about = <<"奖池为空，不能进行抽奖！"/utf8>>};

get(3310055) ->
	#errorcode_msg{type = err331_pool_has_draw,about = <<"奖池奖励均已被抽取，请重置！"/utf8>>};

get(3310056) ->
	#errorcode_msg{type = err331_stage_not_achieve,about = <<"未达到领取条件！"/utf8>>};

get(3310057) ->
	#errorcode_msg{type = err331_stage_has_recieve,about = <<"领取过该奖励！"/utf8>>};

get(3310058) ->
	#errorcode_msg{type = err331_rare_normal_num_not_enougth,about = <<"稀有奖池奖励数量不符合条件！"/utf8>>};

get(3310059) ->
	#errorcode_msg{type = err331_rare_special_num_not_enougth,about = <<"史诗奖池奖励数量不符合条件！"/utf8>>};

get(3310060) ->
	#errorcode_msg{type = err331_rare_rare_num_not_enougth,about = <<"传说奖池奖励数量不符合条件！"/utf8>>};

get(3310061) ->
	#errorcode_msg{type = err331_has_same_grade,about = <<"不能选择相同奖励！"/utf8>>};

get(3310062) ->
	#errorcode_msg{type = err331_act_close,about = <<"活动已结束！"/utf8>>};

get(3310063) ->
	#errorcode_msg{type = stage_reward_not_recieve,about = <<"有未领取的阶段奖励！"/utf8>>};

get(3310064) ->
	#errorcode_msg{type = err331_rare_reward_has_draw,about = <<"大奖已抽完请重置"/utf8>>};

get(3310065) ->
	#errorcode_msg{type = err331_rare_reward_not_draw,about = <<"抽完大奖后才可以重置"/utf8>>};

get(3310066) ->
	#errorcode_msg{type = err331_act_activation_not_enougth,about = <<"活跃度不足!"/utf8>>};

get(3310067) ->
	#errorcode_msg{type = err331_can_not_recieve,about = <<"未达成领取条件"/utf8>>};

get(3310068) ->
	#errorcode_msg{type = err331_rare_draw_times_not_enougth,about = <<"稀有抽奖次数不足"/utf8>>};

get(3310069) ->
	#errorcode_msg{type = err331_not_send_time,about = <<"时间未到"/utf8>>};

get(3310070) ->
	#errorcode_msg{type = err331_receive_red_envelopes,about = <<"已领取红包"/utf8>>};

get(3310071) ->
	#errorcode_msg{type = err331_wave_red_envelopes_num_over,about = <<"红包已发完"/utf8>>};

get(3310072) ->
	#errorcode_msg{type = err331_exchange_limit,about = <<"兑换数量达到上限！"/utf8>>};

get(3310073) ->
	#errorcode_msg{type = err331_score_not_enougth,about = <<"积分不足"/utf8>>};

get(3310074) ->
	#errorcode_msg{type = err331_cannot_get_reward_out_wlv,about = <<"不能领取奖励(不在世界等级范围内)"/utf8>>};

get(3310075) ->
	#errorcode_msg{type = err331_reward_not_bl_act,about = <<"不是活动奖励"/utf8>>};

get(3310076) ->
	#errorcode_msg{type = err331_need_recharge,about = <<"请完成一次充值，再进行领取"/utf8>>};

get(3320001) ->
	#errorcode_msg{type = err322_today_is_hire,about = <<"今天已租借"/utf8>>};

get(3320002) ->
	#errorcode_msg{type = err322_no_need_hire,about = <<"已永久拥有，不需再次租借"/utf8>>};

get(3320003) ->
	#errorcode_msg{type = err322_figure_not_open,about = <<"开启御守功能后才可进行租借。"/utf8>>};

get(3320004) ->
	#errorcode_msg{type = err322_already_active,about = <<"神兵已激活，无需租借"/utf8>>};

get(3320005) ->
	#errorcode_msg{type = err332_invest_buy_expire,about = <<"已过购买时间"/utf8>>};

get(3320006) ->
	#errorcode_msg{type = err332_invest_is_buy,about = <<"投资已购买"/utf8>>};

get(3320007) ->
	#errorcode_msg{type = err332_invest_not_buy,about = <<"还未购买"/utf8>>};

get(3320008) ->
	#errorcode_msg{type = err332_invest_login_days,about = <<"登陆天数不足"/utf8>>};

get(3320009) ->
	#errorcode_msg{type = err332_vip_discount_set,about = <<"礼包折扣已经设置"/utf8>>};

get(3320010) ->
	#errorcode_msg{type = err332_vip_discount_not_set,about = <<"请先设置折扣"/utf8>>};

get(3320011) ->
	#errorcode_msg{type = err332_not_in_first_time,about = <<"非订购阶段"/utf8>>};

get(3320012) ->
	#errorcode_msg{type = err332_not_in_tail_time,about = <<"未到付尾款阶段"/utf8>>};

get(3320013) ->
	#errorcode_msg{type = err332_not_buy_count,about = <<"购买次数用完"/utf8>>};

get(3320014) ->
	#errorcode_msg{type = err332_no_tail_count,about = <<"没有尾款可付"/utf8>>};

get(3320015) ->
	#errorcode_msg{type = err331_not_buy,about = <<"未订购"/utf8>>};

get(3320016) ->
	#errorcode_msg{type = err332_rebate_withdrawal_ing,about = <<"提现中，请稍等"/utf8>>};

get(3320017) ->
	#errorcode_msg{type = err332_rebate_no_money,about = <<"余额不足"/utf8>>};

get(3320018) ->
	#errorcode_msg{type = err332_rebate_no_in_day,about = <<"未在提现时间"/utf8>>};

get(3320019) ->
	#errorcode_msg{type = err332_rebate_dev_cant,about = <<"非审核正式服不能提现"/utf8>>};

get(3320020) ->
	#errorcode_msg{type = err332_rebate_withdrawal_limit,about = <<"提现人数已满"/utf8>>};

get(3320021) ->
	#errorcode_msg{type = err332_question_type_error,about = <<"问卷类型异常"/utf8>>};

get(3320022) ->
	#errorcode_msg{type = err332_question_had_finish,about = <<"本问卷已经完成"/utf8>>};

get(3380001) ->
	#errorcode_msg{type = err338_act_not_open,about = <<"不在活动时间内"/utf8>>};

get(3380002) ->
	#errorcode_msg{type = err338_not_this_choice,about = <<"没有该抽奖次数"/utf8>>};

get(3380003) ->
	#errorcode_msg{type = err338_end_buy,about = <<"结束购买,等待零点结算"/utf8>>};

get(3380004) ->
	#errorcode_msg{type = err338_has_got,about = <<"已领取"/utf8>>};

get(3390000) ->
	#errorcode_msg{type = err339_split_max_num_err,about = <<"红包个数不能超过结社人数上限"/utf8>>};

get(3390001) ->
	#errorcode_msg{type = err339_split_min_num_err,about = <<"红包个数不能小于最小数量限制"/utf8>>};

get(3390002) ->
	#errorcode_msg{type = err339_not_exist,about = <<"红包不存在"/utf8>>};

get(3390003) ->
	#errorcode_msg{type = err339_has_expired,about = <<"红包已过期"/utf8>>};

get(3390004) ->
	#errorcode_msg{type = err339_not_send,about = <<"红包为未发送状态，不能领取"/utf8>>};

get(3390005) ->
	#errorcode_msg{type = err339_daily_times_no_enough,about = <<"今天该红包的发送次数已用完"/utf8>>};

get(3390006) ->
	#errorcode_msg{type = err339_not_join_guild,about = <<"没有加入结社，不能发红包"/utf8>>};

get(3390007) ->
	#errorcode_msg{type = err339_not_owner,about = <<"该红包不属于你，不能发送"/utf8>>};

get(3390008) ->
	#errorcode_msg{type = err339_vip_lv_not_enough,about = <<"需要贵族4才能发送贵族红包"/utf8>>};

get(3390009) ->
	#errorcode_msg{type = err339_cannot_send_again,about = <<"红包已被发出，不能重复发送"/utf8>>};

get(3390010) ->
	#errorcode_msg{type = err339_msg_too_long,about = <<"描述太长"/utf8>>};

get(3390011) ->
	#errorcode_msg{type = err339_feast_boss_err,about = <<"没有参与击杀,无法领取红包"/utf8>>};

get(3390012) ->
	#errorcode_msg{type = err339_vip_send_succ,about = <<"发送成功，今日剩余{1}次"/utf8>>};

get(3390013) ->
	#errorcode_msg{type = err339_gold_to_much,about = <<"单次发送金额不能超过{1}勾玉"/utf8>>};

get(3400001) ->
	#errorcode_msg{type = err340_had_get,about = <<"已经领取了"/utf8>>};

get(3400002) ->
	#errorcode_msg{type = err340_can_not_get,about = <<"不能领取"/utf8>>};

get(3400003) ->
	#errorcode_msg{type = err340_touch_invite_on_cd,about = <<"宝箱奖励处于冷却时间内"/utf8>>};

get(3400004) ->
	#errorcode_msg{type = err340_must_to_get_box_reward,about = <<"必须先领取完宝箱奖励"/utf8>>};

get(3400005) ->
	#errorcode_msg{type = err340_not_enough_daily_num_to_touch,about = <<"今天领取的宝箱奖励达到上限"/utf8>>};

get(3400006) ->
	#errorcode_msg{type = err340_invitee_recharge_had_receive,about = <<"已经领取完了"/utf8>>};

get(3400007) ->
	#errorcode_msg{type = err340_invitee_not_recharge,about = <<"本玩家没有充值"/utf8>>};

get(3420001) ->
	#errorcode_msg{type = err342_guess_act_close,about = <<"活动未开启"/utf8>>};

get(3420002) ->
	#errorcode_msg{type = err342_guess_bet_times_lim,about = <<"超过押注次数上限"/utf8>>};

get(3420003) ->
	#errorcode_msg{type = err342_guess_not_in_bet_time,about = <<"不在下注时间"/utf8>>};

get(3420004) ->
	#errorcode_msg{type = err342_guess_group_is_lose,about = <<"该队伍已被淘汰，不能继续下注"/utf8>>};

get(3420005) ->
	#errorcode_msg{type = err342_guess_has_result,about = <<"比赛已出结果，不能继续下注"/utf8>>};

get(3420006) ->
	#errorcode_msg{type = err342_guess_reward_has_receive,about = <<"奖励已经领取过了"/utf8>>};

get(3420007) ->
	#errorcode_msg{type = err342_guess_cant_receive,about = <<"条件不足，无法领取奖励"/utf8>>};

get(3420008) ->
	#errorcode_msg{type = err342_guess_lv_lim,about = <<"玩家等级不足"/utf8>>};

get(3420009) ->
	#errorcode_msg{type = err342_guess_cant_receive_cuz_no_result,about = <<"比赛未出结果，无法领取奖励"/utf8>>};

get(3990001) ->
	#errorcode_msg{type = err399_note_crash_too_late,about = <<"您来的太晚了，无法进行消消乐挑战~"/utf8>>};

get(4000001) ->
	#errorcode_msg{type = err400_guild_name_len,about = <<"结社名字过长"/utf8>>};

get(4000002) ->
	#errorcode_msg{type = err400_guild_name_sensitive,about = <<"结社名字含有敏感字"/utf8>>};

get(4000003) ->
	#errorcode_msg{type = err400_tenet_len,about = <<"结社宣言过长"/utf8>>};

get(4000004) ->
	#errorcode_msg{type = err400_tenet_sensitive,about = <<"结社宣言含有敏感字"/utf8>>};

get(4000005) ->
	#errorcode_msg{type = err400_on_guild_not_to_create,about = <<"您已经有结社了~"/utf8>>};

get(4000006) ->
	#errorcode_msg{type = err400_create_guild_cfg,about = <<"创建结社出错"/utf8>>};

get(4000007) ->
	#errorcode_msg{type = err400_not_station_scene_to_leave,about = <<"无法退出结社驻地"/utf8>>};

get(4000008) ->
	#errorcode_msg{type = err400_announce_sensitive,about = <<"公告有敏感字"/utf8>>};

get(4000009) ->
	#errorcode_msg{type = err400_announce_len,about = <<"公告过长"/utf8>>};

get(4000010) ->
	#errorcode_msg{type = err400_not_on_guild_to_modify_announce,about = <<"没有结社无法修改公告"/utf8>>};

get(4000011) ->
	#errorcode_msg{type = err400_auto_approve_power_error,about = <<"输入自动加入战力错误"/utf8>>};

get(4000012) ->
	#errorcode_msg{type = err400_auto_approve_lv_error,about = <<"输入自动加入等级错误"/utf8>>};

get(4000013) ->
	#errorcode_msg{type = err400_approve_type_error,about = <<"设置审批类型出错"/utf8>>};

get(4000014) ->
	#errorcode_msg{type = err400_this_scene_not_to_enter_station,about = <<"本场景无法进入结社驻地"/utf8>>};

get(4000015) ->
	#errorcode_msg{type = err400_not_on_guild_to_station,about = <<"无结社无法进入结社驻地"/utf8>>};

get(4000016) ->
	#errorcode_msg{type = err400_on_guild_not_to_apply,about = <<"处于结社中无法申请加入结社"/utf8>>};

get(4000017) ->
	#errorcode_msg{type = err400_not_permission_to_clean_apply,about = <<"您没有权限~"/utf8>>};

get(4000018) ->
	#errorcode_msg{type = err400_not_on_guild_to_clean_apply,about = <<"不在结社无法清理结社申请"/utf8>>};

get(4000019) ->
	#errorcode_msg{type = err400_can_not_modify_other_permission,about = <<"不能修改对方的权限"/utf8>>};

get(4000020) ->
	#errorcode_msg{type = err400_not_on_guild_to_modify_permission,about = <<"不在结社无法修改权限"/utf8>>};

get(4000021) ->
	#errorcode_msg{type = err400_not_right_is_allow_on_modify_permission,about = <<"发送的权限修改参数出错"/utf8>>};

get(4000022) ->
	#errorcode_msg{type = err400_not_modifiable_permission,about = <<"该权限不能被修改"/utf8>>};

get(4000023) ->
	#errorcode_msg{type = err400_not_modified_permission_pos,about = <<"本职位不能被修改权限"/utf8>>};

get(4000024) ->
	#errorcode_msg{type = err400_not_guild_apply,about = <<"没有向该结社申请"/utf8>>};

get(4000025) ->
	#errorcode_msg{type = err400_not_permission_to_rename_position,about = <<"没有权限设置称谓"/utf8>>};

get(4000026) ->
	#errorcode_msg{type = err400_not_on_guild_to_rename_position,about = <<"不在结社无法设置称谓"/utf8>>};

get(4000027) ->
	#errorcode_msg{type = err400_not_modified_name_pos,about = <<"本职位名字不能被修改"/utf8>>};

get(4000028) ->
	#errorcode_msg{type = err400_position_name_sensitive,about = <<"输入称谓含有敏感字"/utf8>>};

get(4000029) ->
	#errorcode_msg{type = err400_position_name_len,about = <<"输入称谓过长"/utf8>>};

get(4000030) ->
	#errorcode_msg{type = err400_this_position_can_not_kick_member,about = <<"你的权限不足"/utf8>>};

get(4000031) ->
	#errorcode_msg{type = err400_not_permission_to_kick,about = <<"没有权限踢除玩家"/utf8>>};

get(4000032) ->
	#errorcode_msg{type = err400_not_same_guild_to_kick,about = <<"只能踢出本结社的玩家"/utf8>>};

get(4000033) ->
	#errorcode_msg{type = err400_not_on_guild_to_kicked,about = <<"对方不在结社无法被踢出"/utf8>>};

get(4000034) ->
	#errorcode_msg{type = err400_not_on_guild_to_kick,about = <<"不在结社无法踢除玩家"/utf8>>};

get(4000035) ->
	#errorcode_msg{type = err400_this_position_can_not_resign,about = <<"本职位无法辞退"/utf8>>};

get(4000036) ->
	#errorcode_msg{type = err400_not_on_guild_to_resign_position,about = <<"不在结社不能辞退"/utf8>>};

get(4000037) ->
	#errorcode_msg{type = err400_not_permission_to_modify_announce,about = <<"只有会长可以修改公告"/utf8>>};

get(4000038) ->
	#errorcode_msg{type = err400_not_on_guild_to_modify_tenet,about = <<"不在结社无法修改宣言"/utf8>>};

get(4000039) ->
	#errorcode_msg{type = err400_not_permission_to_modify_tenet,about = <<"没有权限修改宣言"/utf8>>};

get(4000040) ->
	#errorcode_msg{type = err400_not_permission_to_modify_approve_setting,about = <<"没有权限修改审批设置"/utf8>>};

get(4000041) ->
	#errorcode_msg{type = err400_not_on_guild_to_modify_approve_setting,about = <<"不在结社无法审批设置"/utf8>>};

get(4000042) ->
	#errorcode_msg{type = err400_chief_not_to_quit,about = <<"会长不能退出结社"/utf8>>};

get(4000043) ->
	#errorcode_msg{type = err400_not_on_guild_to_quit,about = <<"不在结社无法退出结社"/utf8>>};

get(4000044) ->
	#errorcode_msg{type = err400_guild_name_same_not_to_create,about = <<"结社名字相同无法创建"/utf8>>};

get(4000045) ->
	#errorcode_msg{type = err400_this_position_full,about = <<"本职位已经满人"/utf8>>};

get(4000046) ->
	#errorcode_msg{type = err400_chief_not_exist,about = <<"会长不存在"/utf8>>};

get(4000048) ->
	#errorcode_msg{type = err400_not_allow_appoint,about = <<"不允许任命"/utf8>>};

get(4000049) ->
	#errorcode_msg{type = err400_must_have_chief,about = <<"必须要有会长哦"/utf8>>};

get(4000051) ->
	#errorcode_msg{type = err400_same_target_position,about = <<"任命新职位相同"/utf8>>};

get(4000052) ->
	#errorcode_msg{type = err400_not_same_guild_to_appoint,about = <<"只能任命同结社"/utf8>>};

get(4000053) ->
	#errorcode_msg{type = err400_guild_not_exist,about = <<"结社不存在"/utf8>>};

get(4000054) ->
	#errorcode_msg{type = err400_not_on_guild_to_appointed,about = <<"对方不在结社不能被任命"/utf8>>};

get(4000056) ->
	#errorcode_msg{type = err400_not_on_guild_to_appoint,about = <<"不在结社无法任命"/utf8>>};

get(4000057) ->
	#errorcode_msg{type = err400_not_permission_to_approve,about = <<"没有权限审批"/utf8>>};

get(4000058) ->
	#errorcode_msg{type = err400_not_apply,about = <<"没有该结社申请"/utf8>>};

get(4000059) ->
	#errorcode_msg{type = err400_approver_not_on_guild,about = <<"申请人不在结社"/utf8>>};

get(4000061) ->
	#errorcode_msg{type = err400_can_not_join,about = <<"不能加入结社"/utf8>>};

get(4000062) ->
	#errorcode_msg{type = err400_guild_apply_len_limit,about = <<"结社申请列表已满"/utf8>>};

get(4000063) ->
	#errorcode_msg{type = err400_member_enough,about = <<"结社人数已满"/utf8>>};

get(4000064) ->
	#errorcode_msg{type = err400_apply_realm_not_same,about = <<"申请的结社阵营不同"/utf8>>};

get(4000065) ->
	#errorcode_msg{type = err400_this_guild_not_exist_to_apply,about = <<"无法申请不存在的结社"/utf8>>};

get(4000066) ->
	#errorcode_msg{type = err400_is_apply_this_guild,about = <<"已经申请过本结社"/utf8>>};

get(4000083) ->
	#errorcode_msg{type = err400_not_config,about = <<"缺失配置"/utf8>>};

get(4000094) ->
	#errorcode_msg{type = err400_not_on_guild_to_modify_approve,about = <<"不在结社无法处理请求"/utf8>>};

get(4000095) ->
	#errorcode_msg{type = err400_not_allow_appoint_again,about = <<"不能重复任命"/utf8>>};

get(4000096) ->
	#errorcode_msg{type = err400_appoint_position_to_leader_only,about = <<"只允许任命一个领袖"/utf8>>};

get(4000097) ->
	#errorcode_msg{type = err400_not_allow_appoint_to_chief_again,about = <<"不能重复任命哦~"/utf8>>};

get(4000098) ->
	#errorcode_msg{type = err400_appoint_position_to_chief_only,about = <<"只允许任命一个会长"/utf8>>};

get(4000101) ->
	#errorcode_msg{type = err400_other_have_guild_not_to_join,about = <<"对方已有结社，无法加入"/utf8>>};

get(4000106) ->
	#errorcode_msg{type = err400_invitee_having_on_guild,about = <<"被邀请者已经在结社"/utf8>>};

get(4000107) ->
	#errorcode_msg{type = err400_not_enough_lv_to_apply_join_guild,about = <<"等级不足，无法加入结社"/utf8>>};

get(4000108) ->
	#errorcode_msg{type = err400_not_enough_lv_to_create_guild,about = <<"等级不足，无法创建结社"/utf8>>};

get(4000109) ->
	#errorcode_msg{type = err400_not_find_guild,about = <<"未找到结社"/utf8>>};

get(4000110) ->
	#errorcode_msg{type = err400_refuse_apply,about = <<"对方拒绝了你的申请"/utf8>>};

get(4000111) ->
	#errorcode_msg{type = err400_guild_name_null,about = <<"结社名不能为空"/utf8>>};

get(4000112) ->
	#errorcode_msg{type = err400_no_permission,about = <<"您没有权限"/utf8>>};

get(4000113) ->
	#errorcode_msg{type = err400_guild_full_lv,about = <<"结社已满级"/utf8>>};

get(4000114) ->
	#errorcode_msg{type = err400_not_satisfy_upgrade_guild_condition,about = <<"不满足升级结社条件"/utf8>>};

get(4000115) ->
	#errorcode_msg{type = err400_has_receive_salary,about = <<"已经领取过本日工资，不能重复领取"/utf8>>};

get(4000116) ->
	#errorcode_msg{type = err400_not_join_guild,about = <<"没有加入结社"/utf8>>};

get(4000117) ->
	#errorcode_msg{type = err400_not_peimission_research,about = <<"您没有权限研究结社技能"/utf8>>};

get(4000118) ->
	#errorcode_msg{type = err400_gskill_locked,about = <<"结社技能未解锁"/utf8>>};

get(4000119) ->
	#errorcode_msg{type = err400_gfunds_not_enough,about = <<"结社资金不足"/utf8>>};

get(4000120) ->
	#errorcode_msg{type = err400_guild_lv_not_satisfy_research,about = <<"结社等级不满足技能研究要求"/utf8>>};

get(4000121) ->
	#errorcode_msg{type = err400_max_research_lv,about = <<"技能研究已满级"/utf8>>};

get(4000122) ->
	#errorcode_msg{type = err400_research_lv_limit,about = <<"已达结社研究上限，无法学习"/utf8>>};

get(4000123) ->
	#errorcode_msg{type = err400_role_lv_not_satisfy_learn,about = <<"玩家等级不满足技能学习要求"/utf8>>};

get(4000124) ->
	#errorcode_msg{type = err400_gdonate_not_satisfy_learn,about = <<"结社贡献值不足，无法学习"/utf8>>};

get(4000125) ->
	#errorcode_msg{type = err400_approve_success,about = <<"批准成功"/utf8>>};

get(4000126) ->
	#errorcode_msg{type = err400_apply_refuse,about = <<"拒绝成功"/utf8>>};

get(4000127) ->
	#errorcode_msg{type = err400_dominator_guild_can_not_disband,about = <<"王者结社不能解散"/utf8>>};

get(4000128) ->
	#errorcode_msg{type = err400_no_guild,about = <<"玩家未加入结社"/utf8>>};

get(4000129) ->
	#errorcode_msg{type = err400_guild_name_same,about = <<"和当前结社名相同，请重新输入"/utf8>>};

get(4000130) ->
	#errorcode_msg{type = err400_guild_name_repeat,about = <<"和其他结社名重复了哦，请重新输入"/utf8>>};

get(4000131) ->
	#errorcode_msg{type = err400_donate_max,about = <<"超出每日捐献次数"/utf8>>};

get(4000132) ->
	#errorcode_msg{type = err400_already_get_daily_gift,about = <<"已领取活跃度礼包"/utf8>>};

get(4000133) ->
	#errorcode_msg{type = err400_not_donate_today,about = <<"今日还没捐献"/utf8>>};

get(4000134) ->
	#errorcode_msg{type = err400_activity_not_enough,about = <<"结社活跃度不足"/utf8>>};

get(4000135) ->
	#errorcode_msg{type = err400_chief_not_to_disband,about = <<"非会长不能解散结社"/utf8>>};

get(4000136) ->
	#errorcode_msg{type = err400_apply_condition_err,about = <<"不满足申请条件，无法申请"/utf8>>};

get(4000137) ->
	#errorcode_msg{type = err400_guild_lv_dun,about = <<"2级开放"/utf8>>};

get(4000138) ->
	#errorcode_msg{type = err400_already_get_score_gift,about = <<"已领取结社副本奖励"/utf8>>};

get(4000139) ->
	#errorcode_msg{type = err400_dun_role_score_not_enough,about = <<"个人副本积分不足"/utf8>>};

get(4000140) ->
	#errorcode_msg{type = err400_dun_score_not_enough,about = <<"结社副本积分不足"/utf8>>};

get(4000141) ->
	#errorcode_msg{type = err400_no_challenge_times,about = <<"没有挑战结社副本次数"/utf8>>};

get(4000142) ->
	#errorcode_msg{type = err400_in_guild_dun,about = <<"在结社副本中"/utf8>>};

get(4000143) ->
	#errorcode_msg{type = err400_no_notify_times,about = <<"没有通风报信次数"/utf8>>};

get(4000144) ->
	#errorcode_msg{type = err400_cant_quit_guild_when_in_guild_dun,about = <<"在结社探索中，不能退出结社"/utf8>>};

get(4000145) ->
	#errorcode_msg{type = err400_dont_kid_myself,about = <<"何苦调戏自己~"/utf8>>};

get(4000146) ->
	#errorcode_msg{type = err400_cant_quit_guild_when_in_sanctuary,about = <<"异域中不能退出结社"/utf8>>};

get(4000147) ->
	#errorcode_msg{type = err400_cant_disband_guild_when_in_sanctuary,about = <<"在异域中不能解散结社"/utf8>>};

get(4000148) ->
	#errorcode_msg{type = err400_can_not_join_in_sanctuary,about = <<"在异域中不能加入结社"/utf8>>};

get(4000149) ->
	#errorcode_msg{type = err400_onekey_apply_condition_err,about = <<"暂无满足条件的结社"/utf8>>};

get(4000150) ->
	#errorcode_msg{type = err400_prestige_limit_today,about = <<"已达今日善缘获取上限(凌晨4点重置)"/utf8>>};

get(4000151) ->
	#errorcode_msg{type = err400_guild_level_not_enough,about = <<"结社等级需要达到4级方可修改公告~"/utf8>>};

get(4000152) ->
	#errorcode_msg{type = err400_announce_times,about = <<"结社公告每天仅可修改1次~"/utf8>>};

get(4000153) ->
	#errorcode_msg{type = err400_announce_forbid_gm,about = <<"当前公告禁止修改，请联系客服"/utf8>>};

get(4000154) ->
	#errorcode_msg{type = err400_rename_frequent,about = <<"改名过于频繁"/utf8>>};

get(4000155) ->
	#errorcode_msg{type = err400_merge_over_capacity,about = <<"结社人数过多，无法合并"/utf8>>};

get(4000156) ->
	#errorcode_msg{type = err400_merge_requested_other,about = <<"无法同时向多个结社同时发出合并邀请"/utf8>>};

get(4000157) ->
	#errorcode_msg{type = err400_merge_agree_other,about = <<"存在公会已同意其它公会的合并请求"/utf8>>};

get(4000158) ->
	#errorcode_msg{type = err400_merge_req_not_exist,about = <<"申请不存在"/utf8>>};

get(4000159) ->
	#errorcode_msg{type = err400_merge_target_guild_applied,about = <<"对方结社已向您结社发出合并申请，请去合并申请内查看~"/utf8>>};

get(4010000) ->
	#errorcode_msg{type = err401_not_in_depot,about = <<"仓库已满，无法继续捐献"/utf8>>};

get(4010001) ->
	#errorcode_msg{type = err401_goods_not_in_depot,about = <<"该道具不在结社仓库里面"/utf8>>};

get(4010002) ->
	#errorcode_msg{type = err401_goods_can_not_add_to_depot,about = <<"该道具不能捐献"/utf8>>};

get(4010003) ->
	#errorcode_msg{type = err401_depot_score_not_enough,about = <<"仓库积分不足，无法兑换"/utf8>>};

get(4010004) ->
	#errorcode_msg{type = err401_bag_cell_not_enough,about = <<"背包空间不足，无法兑换"/utf8>>};

get(4010005) ->
	#errorcode_msg{type = err401_exchange_num_err,about = <<"兑换数量错误"/utf8>>};

get(4010006) ->
	#errorcode_msg{type = err401_no_permission_to_destory,about = <<"您没有权限销毁仓库的物品"/utf8>>};

get(4020000) ->
	#errorcode_msg{type = err402_no_in_act_scene,about = <<"不在活动场景"/utf8>>};

get(4020001) ->
	#errorcode_msg{type = err402_no_join_guild,about = <<"您未加入结社，不能进入活动场景"/utf8>>};

get(4020002) ->
	#errorcode_msg{type = err402_no_enough_lv_join,about = <<"等级不足，无法参与活动"/utf8>>};

get(4020003) ->
	#errorcode_msg{type = err402_act_close,about = <<"暂未开启，【日常-限时活动】中可查看开启时间"/utf8>>};

get(4020004) ->
	#errorcode_msg{type = err402_cant_quit_guild_when_act_open,about = <<"结社晚宴开启期间不能退出结社/踢除结社成员"/utf8>>};

get(4020005) ->
	#errorcode_msg{type = err402_cant_appoint_chief_when_act_open,about = <<"结社晚宴开启期间不能任命会长"/utf8>>};

get(4021006) ->
	#errorcode_msg{type = err402_gboss_has_open,about = <<"活动大妖已经开启"/utf8>>};

get(4021007) ->
	#errorcode_msg{type = err402_gboss_open_no_permission,about = <<"没有开启活动的权限"/utf8>>};

get(4021008) ->
	#errorcode_msg{type = err402_gboss_open_no_mat,about = <<"神兽诱饵不足，请完成结社周任务进行补充"/utf8>>};

get(4021009) ->
	#errorcode_msg{type = err402_not_in_act_cfg_open_time,about = <<"不在活动时间，不能开启活动"/utf8>>};

get(4021010) ->
	#errorcode_msg{type = err402_chief_can_drum_up,about = <<"会长/副会长才能设置自动召唤"/utf8>>};

get(4021011) ->
	#errorcode_msg{type = err402_drum_up_cd,about = <<"召集冷却中，请稍后再试"/utf8>>};

get(4021012) ->
	#errorcode_msg{type = err402_cant_disband_when_gboss_open,about = <<"结社大妖活动开启期间不能解散结社"/utf8>>};

get(4021013) ->
	#errorcode_msg{type = err402_no_challenge_times,about = <<"挑战次数不足"/utf8>>};

get(4021014) ->
	#errorcode_msg{type = err402_guild_guard_end,about = <<"您所在结社的守卫活动已结束"/utf8>>};

get(4021015) ->
	#errorcode_msg{type = err402_not_battle_stage,about = <<"战斗尚未开启"/utf8>>};

get(4021016) ->
	#errorcode_msg{type = err402_gwar_no_qualification,about = <<"所属结社没有参与资格"/utf8>>};

get(4021017) ->
	#errorcode_msg{type = err402_can_not_change_scene_in_gwar,about = <<"玩家正处于最强结社活动，不能参加其他活动"/utf8>>};

get(4021018) ->
	#errorcode_msg{type = err402_gwar_battle_end,about = <<"战斗已结束"/utf8>>};

get(4021019) ->
	#errorcode_msg{type = err402_join_in_guild_not_enough_time,about = <<"加入结社超过24小时的成员才可参与"/utf8>>};

get(4021020) ->
	#errorcode_msg{type = err402_can_not_join_action_this_scene,about = <<"当前场景无法进入活动"/utf8>>};

get(4021021) ->
	#errorcode_msg{type = err402_not_dominator,about = <<"您的结社不是冠军结社"/utf8>>};

get(4021022) ->
	#errorcode_msg{type = err402_join_in_guild_not_enough_time_can_not_receive,about = <<"加入结社时间不足24小时，无法领取"/utf8>>};

get(4021023) ->
	#errorcode_msg{type = err402_has_receive_salary_paul,about = <<"今天已领取过俸禄"/utf8>>};

get(4021024) ->
	#errorcode_msg{type = err402_no_null_cell_receive_salary_paul,about = <<"背包已满，请整理后再来领取"/utf8>>};

get(4021025) ->
	#errorcode_msg{type = err402_not_in_guild,about = <<"该玩家和您不在同一个结社"/utf8>>};

get(4021026) ->
	#errorcode_msg{type = err402_unacommpolished_streak_times,about = <<"未达成连胜条件"/utf8>>};

get(4021027) ->
	#errorcode_msg{type = err402_reward_has_allot,about = <<"奖励已经分配过了"/utf8>>};

get(4021028) ->
	#errorcode_msg{type = err402_no_permission_allot,about = <<"职位权限不够，无法分配"/utf8>>};

get(4021029) ->
	#errorcode_msg{type = err402_unacommpolished,about = <<"未达成奖励条件"/utf8>>};

get(4021030) ->
	#errorcode_msg{type = err402_cant_quit_guild_when_gwar_open,about = <<"最强结社期间不能退出结社/踢除结社成员"/utf8>>};

get(4021031) ->
	#errorcode_msg{type = err402_cant_appoint_chief_when_gwar_open,about = <<"最强结社开启期间不能任命会长"/utf8>>};

get(4021032) ->
	#errorcode_msg{type = err402_cant_disband_when_gwar_open,about = <<"最强结社开启期间不能解散结社"/utf8>>};

get(4021033) ->
	#errorcode_msg{type = err402_gwar_role_num_lim,about = <<"战场人数已满"/utf8>>};

get(4021034) ->
	#errorcode_msg{type = err402_can_not_change_scene_in_gfeast,about = <<"玩家正处于结社晚宴活动，不能参加其他活动"/utf8>>};

get(4021035) ->
	#errorcode_msg{type = err402_no_exist_fire,about = <<"你手慢啦！"/utf8>>};

get(4021036) ->
	#errorcode_msg{type = err402_hava_fire,about = <<"本轮已经获得火苗"/utf8>>};

get(4021037) ->
	#errorcode_msg{type = err402_error_stage,about = <<"结社晚宴错误阶段"/utf8>>};

get(4021038) ->
	#errorcode_msg{type = err402_guild_lv,about = <<"结社等级不够"/utf8>>};

get(4021039) ->
	#errorcode_msg{type = err402_enter_guild_time,about = <<"入会时间不足24小时"/utf8>>};

get(4021040) ->
	#errorcode_msg{type = err402_not_enough_dragon,about = <<"神兽诱饵不够， 无法召唤八岐大蛇"/utf8>>};

get(4021041) ->
	#errorcode_msg{type = err402_had_answer,about = <<"已经回答过本题"/utf8>>};

get(4021042) ->
	#errorcode_msg{type = err402_cant_disband_when_act_open,about = <<"结社活动开启期间不能解散结社"/utf8>>};

get(4021043) ->
	#errorcode_msg{type = err402_summon_dragon_yet,about = <<"请先击杀当前大妖后再进行召唤"/utf8>>};

get(4021044) ->
	#errorcode_msg{type = err402_not_have_summon_card,about = <<"召唤卡不足"/utf8>>};

get(4021045) ->
	#errorcode_msg{type = err402_summon_time_limit,about = <<"召唤大妖阶段剩余不足1分钟，召唤失败"/utf8>>};

get(4021046) ->
	#errorcode_msg{type = err402_boss_not_drum_up,about = <<"八岐大蛇未召集"/utf8>>};

get(4021047) ->
	#errorcode_msg{type = err402_please_enter_feast,about = <<"请先进入晚宴"/utf8>>};

get(4021048) ->
	#errorcode_msg{type = err402_guild_boss_close,about = <<"八岐大蛇未开启"/utf8>>};

get(4021049) ->
	#errorcode_msg{type = err402_not_drum_time,about = <<"没到召唤时间，请稍候！"/utf8>>};

get(4021050) ->
	#errorcode_msg{type = err402_yet_buy_food,about = <<"已经购买菜肴"/utf8>>};

get(4021051) ->
	#errorcode_msg{type = buy_grade_food_limit,about = <<"每次活动中，一个结社只能购买一份极品菜肴哦~"/utf8>>};

get(4030001) ->
	#errorcode_msg{type = err403_join_a_guild,about = <<"请先加入结社！"/utf8>>};

get(4030002) ->
	#errorcode_msg{type = err403_has_recieved,about = <<"当前没有宝箱可以领取哦~"/utf8>>};

get(4030003) ->
	#errorcode_msg{type = err403_max_recieve_num,about = <<"当天领取宝箱次数已达上限"/utf8>>};

get(4040001) ->
	#errorcode_msg{type = err404_no_guild,about = <<"请先加入结社"/utf8>>};

get(4040002) ->
	#errorcode_msg{type = err404_not_same_guild,about = <<"非同一个结社"/utf8>>};

get(4040003) ->
	#errorcode_msg{type = err404_had_assist,about = <<"正在协助状态中"/utf8>>};

get(4040004) ->
	#errorcode_msg{type = err404_please_wait_a_second,about = <<"请稍候"/utf8>>};

get(4040005) ->
	#errorcode_msg{type = err404_no_assist,about = <<"协助已不存在"/utf8>>};

get(4040006) ->
	#errorcode_msg{type = err404_cannt_cancel_in_dungeon,about = <<"副本中无法取消协助"/utf8>>};

get(4040007) ->
	#errorcode_msg{type = err404_no_tired,about = <<"无法击杀更多的大妖"/utf8>>};

get(4040008) ->
	#errorcode_msg{type = err404_please_create_team,about = <<"请先创建队伍"/utf8>>};

get(4040009) ->
	#errorcode_msg{type = err404_move_to_boss,about = <<"请先走到大妖附近"/utf8>>};

get(4040010) ->
	#errorcode_msg{type = err404_param_err,about = <<"参数错误"/utf8>>};

get(4040011) ->
	#errorcode_msg{type = err404_no_dun_times,about = <<"副本次数不足"/utf8>>};

get(4040012) ->
	#errorcode_msg{type = err404_please_leave_team,about = <<"请先离开队伍"/utf8>>};

get(4040013) ->
	#errorcode_msg{type = err404_no_launch_assist,about = <<"没有此协助"/utf8>>};

get(4040014) ->
	#errorcode_msg{type = err404_no_target,about = <<"目标错误"/utf8>>};

get(4040015) ->
	#errorcode_msg{type = err404_cannt_assist_in_decoration_boss,about = <<"已经在灵饰大妖中，不能协助"/utf8>>};

get(4040016) ->
	#errorcode_msg{type = err404_assist_fail,about = <<"协助失败"/utf8>>};

get(4040017) ->
	#errorcode_msg{type = err404_please_assist_again,about = <<"请重新进行协助"/utf8>>};

get(4040018) ->
	#errorcode_msg{type = err404_enter_team_fail,about = <<"入队失败"/utf8>>};

get(4040019) ->
	#errorcode_msg{type = err404_had_launch_assist,about = <<"已发起求助"/utf8>>};

get(4040020) ->
	#errorcode_msg{type = err404_cant_quit_guild_when_in_assist,about = <<"协助状态中,无法退出结社"/utf8>>};

get(4040021) ->
	#errorcode_msg{type = err404_cannt_join_team_in_assist,about = <<"正在协助中，无法进行组队"/utf8>>};

get(4040022) ->
	#errorcode_msg{type = err404_boss_cannt_assist,about = <<"该大妖不可以协助"/utf8>>};

get(4040023) ->
	#errorcode_msg{type = err404_cannt_assist_type,about = <<"助战状态不能协助"/utf8>>};

get(4040024) ->
	#errorcode_msg{type = err404_need_outside_assist,about = <<"请在野外场景发起协助"/utf8>>};

get(4040025) ->
	#errorcode_msg{type = err404_other_assist,about = <<"已有其他结社成员进行协助"/utf8>>};

get(4040026) ->
	#errorcode_msg{type = err404_limit_times,about = <<"今天斩妖结社求助次数已用完"/utf8>>};

get(4040027) ->
	#errorcode_msg{type = err404_in_cd,about = <<"斩妖协助CD中"/utf8>>};

get(4040028) ->
	#errorcode_msg{type = err404_not_finish_guard,about = <<"您未成功挑战{1}关斩妖，无法进行协助"/utf8>>};

get(4040029) ->
	#errorcode_msg{type = err404_not_satisfy,about = <<"{1}结社协助将在开服第{2}天且玩家{3}级时开启~"/utf8>>};

get(4050001) ->
	#errorcode_msg{type = err405_not_awake,about = <<"武魂未解锁"/utf8>>};

get(4050002) ->
	#errorcode_msg{type = err405_max_color,about = <<"武魂已经达到最高品质"/utf8>>};

get(4050003) ->
	#errorcode_msg{type = err405_max_awake_lv,about = <<"武魂已经达到最高觉醒等级"/utf8>>};

get(4050004) ->
	#errorcode_msg{type = err405_error_god_id,about = <<"结社武魂id错误"/utf8>>};

get(4050005) ->
	#errorcode_msg{type = err405_error_loc,about = <<"御魂背包位置错误"/utf8>>};

get(4050006) ->
	#errorcode_msg{type = err405_error_pos,about = <<"御魂孔位错误"/utf8>>};

get(4050007) ->
	#errorcode_msg{type = err405_not_guilld_god_rune,about = <<"非结社武魂铭文"/utf8>>};

get(4050008) ->
	#errorcode_msg{type = err405_open_day_limit,about = <<"开服天数限制"/utf8>>};

get(4050009) ->
	#errorcode_msg{type = err405_lv_limit,about = <<"等级限制"/utf8>>};

get(4050010) ->
	#errorcode_msg{type = err405_can_not_awake_combo,about = <<"组合条件不符合"/utf8>>};

get(4050011) ->
	#errorcode_msg{type = err405_not_ward_rune,about = <<"该孔位没有装备御魂"/utf8>>};

get(4050012) ->
	#errorcode_msg{type = err405_error_achievement_lv,about = <<"大师铭文等级错误"/utf8>>};

get(4050013) ->
	#errorcode_msg{type = err405_yet_awake,about = <<"已经激活"/utf8>>};

get(4050014) ->
	#errorcode_msg{type = err405_rune_lv_limit,about = <<"铭文等级不够"/utf8>>};

get(4050015) ->
	#errorcode_msg{type = err405_rune_max_lv,about = <<"铭文已经达到最高等级"/utf8>>};

get(4090001) ->
	#errorcode_msg{type = err409_not_finish,about = <<"成就未达成，无法领取奖励"/utf8>>};

get(4090002) ->
	#errorcode_msg{type = err409_has_received,about = <<"已经领取过奖励"/utf8>>};

get(4090003) ->
	#errorcode_msg{type = err409_error_data,about = <<"操作过快，请稍后再试"/utf8>>};

get(4110001) ->
	#errorcode_msg{type = err411_current_not_exist,about = <<"当前使用的称号不存在"/utf8>>};

get(4110002) ->
	#errorcode_msg{type = err411_not_need_change,about = <<"切换的是当前使用的称号，不需切换"/utf8>>};

get(4110003) ->
	#errorcode_msg{type = err411_hide_error,about = <<"隐藏称号错误"/utf8>>};

get(4110004) ->
	#errorcode_msg{type = err411_change_error,about = <<"称号未激活，切换称号失败"/utf8>>};

get(4110005) ->
	#errorcode_msg{type = err411_is_expired,about = <<"称号已过期"/utf8>>};

get(4110006) ->
	#errorcode_msg{type = err411_already_exist,about = <<"[称号已拥有，无需再次激活]"/utf8>>};

get(4110007) ->
	#errorcode_msg{type = err411_dsgt_not_active,about = <<"称号未激活，进阶失败"/utf8>>};

get(4110008) ->
	#errorcode_msg{type = err411_dsgt_max_order,about = <<"已达称号最大阶数"/utf8>>};

get(4110009) ->
	#errorcode_msg{type = err411_goods_not_enough,about = <<"道具数量不足，进阶失败"/utf8>>};

get(4120001) ->
	#errorcode_msg{type = err412_cfg_not_exist,about = <<"配置不存在"/utf8>>};

get(4120002) ->
	#errorcode_msg{type = err412_goods_not_exist,about = <<"物品不存在"/utf8>>};

get(4120003) ->
	#errorcode_msg{type = err412_learn_sk_err1,about = <<"没有可用技能位置"/utf8>>};

get(4120004) ->
	#errorcode_msg{type = err412_learn_sk_err2,about = <<"学习技能的位置超出范围"/utf8>>};

get(4120005) ->
	#errorcode_msg{type = err412_learn_sk_err3,about = <<"学习的技能已存在"/utf8>>};

get(4120006) ->
	#errorcode_msg{type = err412_replace_sk_err1,about = <<"被替换的位置不存在技能"/utf8>>};

get(4120007) ->
	#errorcode_msg{type = err412_no_sk_book,about = <<"没有合适的技能书"/utf8>>};

get(4120008) ->
	#errorcode_msg{type = err412_recruit_not_free,about = <<"非免费招募"/utf8>>};

get(4120009) ->
	#errorcode_msg{type = err412_partner_not_exist,about = <<"伙伴不存在"/utf8>>};

get(4120010) ->
	#errorcode_msg{type = err412_wash_goods_err1,about = <<"洗髓物品不足"/utf8>>};

get(4120011) ->
	#errorcode_msg{type = err412_partner_state_err,about = <<"伙伴状态不对"/utf8>>};

get(4120012) ->
	#errorcode_msg{type = err412_upgrade_lv_err,about = <<"升级错误,伙伴等级已大于等于玩家等级"/utf8>>};

get(4120013) ->
	#errorcode_msg{type = err412_wash_replace_err,about = <<"洗髓的伙伴内存中不存在"/utf8>>};

get(4120014) ->
	#errorcode_msg{type = err412_break_err,about = <<"突破等级有错"/utf8>>};

get(4120015) ->
	#errorcode_msg{type = err412_promote_err,about = <<"资质提升错误,已超出上限"/utf8>>};

get(4120016) ->
	#errorcode_msg{type = err412_battle_err1,about = <<"没有可上阵的位置"/utf8>>};

get(4120017) ->
	#errorcode_msg{type = err412_battle_err2,about = <<"上阵错误,玩家等级不足"/utf8>>};

get(4120018) ->
	#errorcode_msg{type = err412_embattle_err1,about = <<"布阵错误,原位置没有伙伴"/utf8>>};

get(4120019) ->
	#errorcode_msg{type = err412_embattle_err2,about = <<"布阵错误,目标位置超出范围"/utf8>>};

get(4120020) ->
	#errorcode_msg{type = err412_weapon_err1,about = <<"激活专属,已激活"/utf8>>};

get(4120021) ->
	#errorcode_msg{type = err412_weapon_err2,about = <<"专属激活,伙伴没招募过"/utf8>>};

get(4120022) ->
	#errorcode_msg{type = err412_disband_err,about = <<"伙伴遣散,伙伴上阵无法遣散"/utf8>>};

get(4120023) ->
	#errorcode_msg{type = err412_callback_err,about = <<"以前没招募过"/utf8>>};

get(4120024) ->
	#errorcode_msg{type = err412_battle_err3,about = <<"上阵位置错误"/utf8>>};

get(4120025) ->
	#errorcode_msg{type = err412_recruit_err1,about = <<"非保底招募,没找到候选伙伴"/utf8>>};

get(4120026) ->
	#errorcode_msg{type = err412_recruit_err2,about = <<"保底招募,没找到候选伙伴"/utf8>>};

get(4120027) ->
	#errorcode_msg{type = err412_partner_is_battle,about = <<"已经有相同伙伴出战"/utf8>>};

get(4130001) ->
	#errorcode_msg{type = err413_fashion_not_pos,about = <<"没有该外观部位"/utf8>>};

get(4130002) ->
	#errorcode_msg{type = err413_fashion_not_fashion,about = <<"该外观未激活"/utf8>>};

get(4130003) ->
	#errorcode_msg{type = err413_fashion_not_same_color,about = <<"不能重复染同一种颜色"/utf8>>};

get(4130004) ->
	#errorcode_msg{type = err413_fashion_color_not_active,about = <<"颜色未激活"/utf8>>};

get(4130005) ->
	#errorcode_msg{type = err413_fashion_not_color,about = <<"颜色不存在"/utf8>>};

get(4130006) ->
	#errorcode_msg{type = err413_fashion_wear,about = <<"当前外观正在穿着"/utf8>>};

get(4130007) ->
	#errorcode_msg{type = err413_fashion_not_wear,about = <<"身上穿着不是这件外观"/utf8>>};

get(4130008) ->
	#errorcode_msg{type = err413_fashion_active,about = <<"外观已激活"/utf8>>};

get(4130009) ->
	#errorcode_msg{type = err413_fashion_max_lv,about = <<"外观部位已满级"/utf8>>};

get(4130010) ->
	#errorcode_msg{type = err413_fashion_not_enough_point,about = <<"外观精华不足"/utf8>>};

get(4130011) ->
	#errorcode_msg{type = err413_fashion_not_resolve,about = <<"该道具不能分解"/utf8>>};

get(4130012) ->
	#errorcode_msg{type = err413_fashion_max_star,about = <<"星级已满级"/utf8>>};

get(4130013) ->
	#errorcode_msg{type = err413_fashion_not_max_star,about = <<"星级未满级"/utf8>>};

get(4130014) ->
	#errorcode_msg{type = err413_fashion_color_active,about = <<"颜色已激活"/utf8>>};

get(4130015) ->
	#errorcode_msg{type = err413_upgrade_not_conform,about = <<"不满足进阶条件"/utf8>>};

get(4130016) ->
	#errorcode_msg{type = err413_suit_not_conform,about = <<"未达到激活条件"/utf8>>};

get(4130017) ->
	#errorcode_msg{type = err413_upgrade_max,about = <<"星级已满级"/utf8>>};

get(4140001) ->
	#errorcode_msg{type = err414_has_receive,about = <<"已经领取过奖励"/utf8>>};

get(4150001) ->
	#errorcode_msg{type = err415_no_enough_times,about = <<"祈愿次数不足"/utf8>>};

get(4150002) ->
	#errorcode_msg{type = err415_not_reward_cfg,about = <<"没有奖励配置"/utf8>>};

get(4160000) ->
	#errorcode_msg{type = err416_no_null_cell,about = <<"背包已满,无法继续寻宝"/utf8>>};

get(4160001) ->
	#errorcode_msg{type = err416_bag_no_null_cell,about = <<"背包已满，请先清理背包"/utf8>>};

get(4160002) ->
	#errorcode_msg{type = err401_score_not_enough,about = <<"积分不足，无法兑换"/utf8>>};

get(4160003) ->
	#errorcode_msg{type = err416_rune_bag_full,about = <<"御魂背包已满，请先清理御魂背包"/utf8>>};

get(4160004) ->
	#errorcode_msg{type = err416_equip_htimes_lim,about = <<"您已达到本日装备寻宝次数上限"/utf8>>};

get(4160005) ->
	#errorcode_msg{type = err416_peak_htimes_lim,about = <<"您已达到本日巅峰寻宝次数上限"/utf8>>};

get(4160006) ->
	#errorcode_msg{type = err416_extreme_htimes_lim,about = <<"您已达到本日至尊寻宝次数上限"/utf8>>};

get(4160007) ->
	#errorcode_msg{type = err416_rune_htimes_lim,about = <<"您已达到本日御魂寻宝次数上限"/utf8>>};

get(4160008) ->
	#errorcode_msg{type = err416_box_id_err,about = <<"未达到该阶段"/utf8>>};

get(4160009) ->
	#errorcode_msg{type = err416_box_already_have,about = <<"已领取"/utf8>>};

get(4160010) ->
	#errorcode_msg{type = err416_lv_not_enougth,about = <<"当前等级无法兑换此商品"/utf8>>};

get(4160011) ->
	#errorcode_msg{type = err416_gold_not_enougth,about = <<"勾玉不足"/utf8>>};

get(4160012) ->
	#errorcode_msg{type = err416_goods_not_enougth,about = <<"抽奖道具不足"/utf8>>};

get(4160013) ->
	#errorcode_msg{type = err416_hunt_task_not_finish,about = <<"任务未完成"/utf8>>};

get(4160014) ->
	#errorcode_msg{type = err416_hunt_task_is_got,about = <<"不能重复领取"/utf8>>};

get(4160015) ->
	#errorcode_msg{type = err416_baby_htimes_lim,about = <<"宝宝夺宝次数不足"/utf8>>};

get(4170001) ->
	#errorcode_msg{type = err417_level_illegal,about = <<"未设置该等级对应签到类型！"/utf8>>};

get(4170002) ->
	#errorcode_msg{type = err417_not_set_match_rewards,about = <<"签到类型没有对应奖励配置！"/utf8>>};

get(4170003) ->
	#errorcode_msg{type = err417_total_level_illegal,about = <<"还没有累计签到类型配置！"/utf8>>};

get(4170004) ->
	#errorcode_msg{type = err417_total_typedays_not_match,about = <<"累计签到类型没有对应的奖励配置！"/utf8>>};

get(4170005) ->
	#errorcode_msg{type = err417_cannot_retro_fulture_day,about = <<"那是未来的日子哦~"/utf8>>};

get(4170006) ->
	#errorcode_msg{type = err417_checkin_day_not_current,about = <<"签到只能是当天操作~"/utf8>>};

get(4170007) ->
	#errorcode_msg{type = err417_checkin_today_has_checked,about = <<"您已经领取过这天的奖励了哦！"/utf8>>};

get(4170008) ->
	#errorcode_msg{type = err417_daily_illeagal_day,about = <<"您累计签到的天数还不够哦！"/utf8>>};

get(4170009) ->
	#errorcode_msg{type = err417_not_reach_open_lv,about = <<"您还没达到签到开放的等级！"/utf8>>};

get(4170010) ->
	#errorcode_msg{type = err417_total_rewards_empty,about = <<"奖励配置错误，请联系GM！"/utf8>>};

get(4170011) ->
	#errorcode_msg{type = err417_checkin_gift_has_received,about = <<"您已经领取过这个奖励咯~"/utf8>>};

get(4170012) ->
	#errorcode_msg{type = err417_no_guild,about = <<"还没加入结社，不能求助~"/utf8>>};

get(4170013) ->
	#errorcode_msg{type = err417_has_received,about = <<"已经领取"/utf8>>};

get(4170014) ->
	#errorcode_msg{type = err417_not_share,about = <<"未分享，不能领取奖励"/utf8>>};

get(4170015) ->
	#errorcode_msg{type = err417_has_receive_share_reward,about = <<"已经领取过奖励"/utf8>>};

get(4170016) ->
	#errorcode_msg{type = err417_night_welfare_not_reward,about = <<"领取时间未到，每天20点至24点可领取"/utf8>>};

get(4170017) ->
	#errorcode_msg{type = err417_night_welfare_already_reward,about = <<"奖励已领取，请明天再来"/utf8>>};

get(4170018) ->
	#errorcode_msg{type = err417_lv_not_enougth,about = <<"等级不符"/utf8>>};

get(4170019) ->
	#errorcode_msg{type = err417_online_time_not_enougth,about = <<"累计在线时间不足"/utf8>>};

get(4170020) ->
	#errorcode_msg{type = err417_checkin_kvcfg_error,about = <<"配置错误，请联系GM！"/utf8>>};

get(4170021) ->
	#errorcode_msg{type = err417_checkin_retro_limit,about = <<"补签次数达到上限！"/utf8>>};

get(4170022) ->
	#errorcode_msg{type = err417_no_retro_day,about = <<"没有可以补签的日期"/utf8>>};

get(4170023) ->
	#errorcode_msg{type = err417_retro_times_not_enougth,about = <<"剩余补签次数不足！"/utf8>>};

get(4170024) ->
	#errorcode_msg{type = err417_limit_to_get,about = <<"条件不符·无法领取"/utf8>>};

get(4170025) ->
	#errorcode_msg{type = err417_not_enough_combat,about = <<"战力不足!"/utf8>>};

get(4180001) ->
	#errorcode_msg{type = err418_not_in_scene,about = <<"您不在魅力海滩场景中！"/utf8>>};

get(4180002) ->
	#errorcode_msg{type = err418_not_open,about = <<"活动未开始！"/utf8>>};

get(4180003) ->
	#errorcode_msg{type = err418_basic_exp_not_set,about = <<"经验配置错误！"/utf8>>};

get(4180004) ->
	#errorcode_msg{type = err418_gift_props_not_exists,about = <<"不存在该道具！"/utf8>>};

get(4180005) ->
	#errorcode_msg{type = err418_getter_not_join,about = <<"对方没有参加魅力海滩活动，不能赠送给他（她）！"/utf8>>};

get(4180006) ->
	#errorcode_msg{type = err418_gift_times_not_enougth,about = <<"您的赠送次数已经用完，请购买赠送次数后继续赠送！"/utf8>>};

get(4180007) ->
	#errorcode_msg{type = err418_send_to_self,about = <<"不能给自己赠送礼物！"/utf8>>};

get(4180008) ->
	#errorcode_msg{type = err418_no_partner,about = <<"您还没有对象呢！"/utf8>>};

get(4180009) ->
	#errorcode_msg{type = err418_not_join_act,about = <<"您还未参加魅力海滩活动！"/utf8>>};

get(4180010) ->
	#errorcode_msg{type = err418_opp_has_engaged,about = <<"对方已经在约会状态中，请邀请其他玩家！"/utf8>>};

get(4180011) ->
	#errorcode_msg{type = err418_cfg_fault,about = <<"魅力海滩活动配置错误！"/utf8>>};

get(4180012) ->
	#errorcode_msg{type = err418_lv_invalid,about = <<"您未达到开放等级，不能参加活动"/utf8>>};

get(4180013) ->
	#errorcode_msg{type = err418_has_in_scene,about = <<"您已经在场景中了！"/utf8>>};

get(4180014) ->
	#errorcode_msg{type = err418_has_on_engaged,about = <<"您已经在约会中，不能再邀请其他人咯！"/utf8>>};

get(4180015) ->
	#errorcode_msg{type = err418_add_exp_cd,about = <<"增加经验频率不对哦！"/utf8>>};

get(4180016) ->
	#errorcode_msg{type = err418_invite_cd,about = <<"邀请玩家频率太高了，稍后继续邀请！"/utf8>>};

get(4190001) ->
	#errorcode_msg{type = err419_no_res_act,about = <<"奖励找回中没有此活动"/utf8>>};

get(4190002) ->
	#errorcode_msg{type = err419_no_more_times,about = <<"次数不足"/utf8>>};

get(4190003) ->
	#errorcode_msg{type = err419_no_dun_finish,about = <<"没有通关副本"/utf8>>};

get(4200001) ->
	#errorcode_msg{type = err420_need_buy_greater,about = <<"不能选择比原来低档次的投资"/utf8>>};

get(4200002) ->
	#errorcode_msg{type = err420_no_investment,about = <<"您没有投资该项目"/utf8>>};

get(4200003) ->
	#errorcode_msg{type = err420_need_more_day,about = <<"投资{1}天后可以领取该奖励"/utf8>>};

get(4200004) ->
	#errorcode_msg{type = err420_reward_is_got,about = <<"该投资回报已经领取"/utf8>>};

get(4200005) ->
	#errorcode_msg{type = err420_need_more_logins_day,about = <<"登录天数不足，需要{1}天登录才能领取"/utf8>>};

get(4200006) ->
	#errorcode_msg{type = err420_can_only_get_it_once_a_day,about = <<"每天只能领取一次"/utf8>>};

get(4200007) ->
	#errorcode_msg{type = err420_must_finish_last_reward_id,about = <<"必须领取完上一奖励"/utf8>>};

get(4200008) ->
	#errorcode_msg{type = err420_can_not_greater,about = <<"本投资无法升档"/utf8>>};

get(4210001) ->
	#errorcode_msg{type = err421_1_have_not_goods,about = <<"不存在该藏宝图"/utf8>>};

get(4210002) ->
	#errorcode_msg{type = err421_2_not_xy,about = <<"未到达藏宝地点"/utf8>>};

get(4210003) ->
	#errorcode_msg{type = err421_3_collec_wrong,about = <<"采集失败"/utf8>>};

get(4210004) ->
	#errorcode_msg{type = err421_4_team_num_err,about = <<"队伍人数不够2人"/utf8>>};

get(4210005) ->
	#errorcode_msg{type = err421_5_clue_not_enough,about = <<"线索不够"/utf8>>};

get(4210006) ->
	#errorcode_msg{type = err421_6_not_team,about = <<"需2人以上组队前往"/utf8>>};

get(4210007) ->
	#errorcode_msg{type = err421_7_not_num,about = <<"需2人以上组队前往"/utf8>>};

get(4210008) ->
	#errorcode_msg{type = err421_8_lv_not,about = <<"等级不够"/utf8>>};

get(4210009) ->
	#errorcode_msg{type = err421_9_not_scene,about = <<"当前位置没发现线索"/utf8>>};

get(4210010) ->
	#errorcode_msg{type = err421_10_not_same_time,about = <<"不在同一支队伍中"/utf8>>};

get(4210011) ->
	#errorcode_msg{type = err421_11_not_same_guild,about = <<"不在同一个帮会中"/utf8>>};

get(4210012) ->
	#errorcode_msg{type = err421_12_already_get,about = <<"该线索已被发掘，请寻找其他线索"/utf8>>};

get(4210013) ->
	#errorcode_msg{type = err421_13_not_guild,about = <<"请加入一个结社"/utf8>>};

get(4210014) ->
	#errorcode_msg{type = err421_14_not_clue,about = <<"当前位置没发现线索"/utf8>>};

get(4210016) ->
	#errorcode_msg{type = err421_16_max_help,about = <<"您今天的神秘术图帮助奖励已到上限"/utf8>>};

get(4210017) ->
	#errorcode_msg{type = err421_17_not_same_guild,about = <<"您与宝藏发布者不在同一个结社"/utf8>>};

get(4210018) ->
	#errorcode_msg{type = err421_18_collecting,about = <<"{1}正在挖宝，眼睛变成卢币形状"/utf8>>};

get(4210019) ->
	#errorcode_msg{type = err421_19_not_xy_extra,about = <<"{1}不在附近，无法挖宝"/utf8>>};

get(4210020) ->
	#errorcode_msg{type = err421_20_lv_not_extra,about = <<"{1}等级不足"/utf8>>};

get(4210021) ->
	#errorcode_msg{type = err421_21_fine_max_help,about = <<"您今天的精致宝图帮助奖励已到上限"/utf8>>};

get(4210022) ->
	#errorcode_msg{type = err421_22_not_safe_scene,about = <<"非安全区域不能进入神秘洞穴"/utf8>>};

get(4210023) ->
	#errorcode_msg{type = err421_23_team_spill,about = <<"队伍已满"/utf8>>};

get(4210024) ->
	#errorcode_msg{type = err421_24_not_enter_again,about = <<"不能再次进入神秘洞穴"/utf8>>};

get(4210025) ->
	#errorcode_msg{type = err421_25_dun_num_limit,about = <<"洞窟帮助次数已达上限"/utf8>>};

get(4210026) ->
	#errorcode_msg{type = err421_26_dun_level,about = <<"当前副本阶段禁止进入"/utf8>>};

get(4210027) ->
	#errorcode_msg{type = err421_27_tsmap_dun_end,about = <<"副本已结束"/utf8>>};

get(4210028) ->
	#errorcode_msg{type = err421_28_response_success,about = <<"回应成功"/utf8>>};

get(4220001) ->
	#errorcode_msg{type = err422_level_invalid,about = <<"未达到星图开放等级"/utf8>>};

get(4220002) ->
	#errorcode_msg{type = err422_has_acti,about = <<"您已经激活了该星点！"/utf8>>};

get(4220003) ->
	#errorcode_msg{type = err422_last_star,about = <<"已经激活了所有星点了！"/utf8>>};

get(4220004) ->
	#errorcode_msg{type = err422_cant_acti,about = <<"必须先激活前一个星点才能激活下一个哦！"/utf8>>};

get(4220005) ->
	#errorcode_msg{type = err422_starvalue_not_enough,about = <<"星力值不够哦！"/utf8>>};

get(4220006) ->
	#errorcode_msg{type = err422_bad_check,about = <<"激活失败了！"/utf8>>};

get(4220007) ->
	#errorcode_msg{type = err422_cfg_not_exists,about = <<"后台配置好像出错了..."/utf8>>};

get(4230001) ->
	#errorcode_msg{type = err423_already_active,about = <<"已激活"/utf8>>};

get(4230002) ->
	#errorcode_msg{type = err423_not_active,about = <<"未激活"/utf8>>};

get(4230003) ->
	#errorcode_msg{type = err423_max_lv,about = <<"已达最高等级"/utf8>>};

get(4230004) ->
	#errorcode_msg{type = err423_stage_not_enough_lv,about = <<"未达所需级数"/utf8>>};

get(4230005) ->
	#errorcode_msg{type = err423_max_stage,about = <<"已满阶"/utf8>>};

get(4230006) ->
	#errorcode_msg{type = err423_not_enough_cost,about = <<"物品不足"/utf8>>};

get(4230007) ->
	#errorcode_msg{type = err423_attach_max_times,about = <<"已达魂附上限"/utf8>>};

get(4230008) ->
	#errorcode_msg{type = err423_attach_need_active,about = <<"激活任一天魂后才可使用"/utf8>>};

get(4240001) ->
	#errorcode_msg{type = err424_chapter_lock,about = <<"该玩法尚未解锁"/utf8>>};

get(4240002) ->
	#errorcode_msg{type = err424_has_receive_reward,about = <<"奖励已经领取过了"/utf8>>};

get(4240003) ->
	#errorcode_msg{type = err424_progress_not_finish,about = <<"当前阶段目标未完成"/utf8>>};

get(4250001) ->
	#errorcode_msg{type = err425_not_finish,about = <<"未完成不能激活"/utf8>>};

get(4250002) ->
	#errorcode_msg{type = err425_last_book_not_active,about = <<"请先激活{1}"/utf8>>};

get(4250003) ->
	#errorcode_msg{type = err425_book_lock,about = <<"请先解锁"/utf8>>};

get(4260001) ->
	#errorcode_msg{type = err426_rename_today,about = <<"今天已改名"/utf8>>};

get(4260002) ->
	#errorcode_msg{type = err426_update_rename_system,about = <<"改名系统升级中"/utf8>>};

get(4270001) ->
	#errorcode_msg{type = err427_act_not_open,about = <<"活动没有开放"/utf8>>};

get(4270002) ->
	#errorcode_msg{type = err427_times_not_enough,about = <<"没有次数"/utf8>>};

get(4270003) ->
	#errorcode_msg{type = err427_no_reset_times,about = <<"没有重置次数"/utf8>>};

get(4270004) ->
	#errorcode_msg{type = err427_not_last_loc,about = <<"没有到最后格子不能充重置"/utf8>>};

get(4270005) ->
	#errorcode_msg{type = err427_time_not_enough,about = <<"0点活动重置中,请稍后"/utf8>>};

get(4270006) ->
	#errorcode_msg{type = err427_shop_has_buy,about = <<"商品已经购买"/utf8>>};

get(4270007) ->
	#errorcode_msg{type = err427_shop_no_goods,about = <<"本轮没有该物品"/utf8>>};

get(4290001) ->
	#errorcode_msg{type = err429_lock_sub_chapter,about = <<""/utf8>>};

get(4290002) ->
	#errorcode_msg{type = err429_had_complete,about = <<""/utf8>>};

get(4290003) ->
	#errorcode_msg{type = err429_had_unware,about = <<""/utf8>>};

get(4290004) ->
	#errorcode_msg{type = err429_had_ware,about = <<""/utf8>>};

get(4290005) ->
	#errorcode_msg{type = err429_no_finish,about = <<""/utf8>>};

get(4290006) ->
	#errorcode_msg{type = err429_had_got,about = <<""/utf8>>};

get(4290007) ->
	#errorcode_msg{type = err429_no_complete,about = <<""/utf8>>};

get(4290008) ->
	#errorcode_msg{type = err429_lock_temple,about = <<""/utf8>>};

get(4370001) ->
	#errorcode_msg{type = err437_has_receive_daily_reward,about = <<"已经领取过奖励"/utf8>>};

get(4370002) ->
	#errorcode_msg{type = err437_no_daily_reward,about = <<"没有奖励可以领取"/utf8>>};

get(4370003) ->
	#errorcode_msg{type = err437_cant_donate_in_err_stage,about = <<"当前阶段不能捐赠物资"/utf8>>};

get(4370004) ->
	#errorcode_msg{type = err437_donate_times_lim,about = <<"达到捐赠次数上限"/utf8>>};

get(4370005) ->
	#errorcode_msg{type = err437_no_qualifications,about = <<"您所在结社没有资格参与活动"/utf8>>};

get(4370006) ->
	#errorcode_msg{type = err437_cant_change_scene_in_kf_gwar,about = <<"玩家正处于跨服结社战活动，不能参加其他活动"/utf8>>};

get(4370007) ->
	#errorcode_msg{type = err437_kf_gwar_role_num_lim,about = <<"战场人数已满"/utf8>>};

get(4370008) ->
	#errorcode_msg{type = err437_no_in_act_scene,about = <<"不在活动场景"/utf8>>};

get(4370009) ->
	#errorcode_msg{type = err437_no_enough_score_to_exchange_ship,about = <<"个人积分不足"/utf8>>};

get(4370010) ->
	#errorcode_msg{type = err437_guild_pos_lim_to_exchange_ship,about = <<"仅会长或副会长可以使用高级战船"/utf8>>};

get(4370011) ->
	#errorcode_msg{type = err437_less_than_min_bid,about = <<"当前岛屿最小宣战资金为{1}"/utf8>>};

get(4370012) ->
	#errorcode_msg{type = err437_not_occupy_island_cant_set_min_bid,about = <<"本结社未占领该岛屿"/utf8>>};

get(4370013) ->
	#errorcode_msg{type = err437_cant_bid_self_island,about = <<"无法宣战本结社占领的岛屿"/utf8>>};

get(4370014) ->
	#errorcode_msg{type = err437_already_bid_island,about = <<"已经发起了一个宣战，取消宣战之后才能更改宣战对象"/utf8>>};

get(4370015) ->
	#errorcode_msg{type = err437_no_bid_this_island,about = <<"本结社没有对当前岛屿进行宣战"/utf8>>};

get(4370016) ->
	#errorcode_msg{type = err437_guild_pos_lim_cant_use_props,about = <<"仅会长或副会长可以使用"/utf8>>};

get(4370017) ->
	#errorcode_msg{type = err437_props_can_only_use_on_land,about = <<"该物资只可在陆地上使用"/utf8>>};

get(4370018) ->
	#errorcode_msg{type = err437_props_can_only_use_on_sea,about = <<"该物资只可在海域上使用"/utf8>>};

get(4370019) ->
	#errorcode_msg{type = err437_props_num_not_enough,about = <<"战备物资不足"/utf8>>};

get(4370020) ->
	#errorcode_msg{type = err437_props_use_times_lim,about = <<"该类型战备物资已达到使用上限"/utf8>>};

get(4370021) ->
	#errorcode_msg{type = err437_guild_pos_lim_cant_exchange_props,about = <<"需要会长或副会长才能兑换战备物资"/utf8>>};

get(4370022) ->
	#errorcode_msg{type = err437_date_lim_cant_exchange_props,about = <<"活动当前才能兑换战备物资"/utf8>>};

get(4370023) ->
	#errorcode_msg{type = err437_score_lim_cant_exchange_props,about = <<"战备资源不足，无法兑换"/utf8>>};

get(4370024) ->
	#errorcode_msg{type = err437_cant_enter_scene_not_in_battle_stage,about = <<"不在战斗期，无法进入场景"/utf8>>};

get(4370025) ->
	#errorcode_msg{type = err437_cant_enter_scene_no_qualifications,about = <<"本结社没有参战资格，无法进入战场"/utf8>>};

get(4370026) ->
	#errorcode_msg{type = err437_not_enough_gfunds_to_declare_war,about = <<"结社资金不足"/utf8>>};

get(4370027) ->
	#errorcode_msg{type = err437_guild_lim_cant_declare_war,about = <<"本服结社排名前2的结社会长或副会长才能进行宣战"/utf8>>};

get(4370028) ->
	#errorcode_msg{type = err437_declare_war_stage_err,about = <<"宣战期才能宣战"/utf8>>};

get(4370029) ->
	#errorcode_msg{type = err437_cant_disband_when_kfgwar_open,about = <<"跨服结社战期间无法解散结社"/utf8>>};

get(4370030) ->
	#errorcode_msg{type = err437_cant_appoint_chief_when_kfwar_open,about = <<"跨服结社战期间无法转让会长"/utf8>>};

get(4370031) ->
	#errorcode_msg{type = err437_cant_declare_war_cuz_has_island,about = <<"本结社已占领1个据点无法宣战"/utf8>>};

get(4370032) ->
	#errorcode_msg{type = err437_reborn_point_err,about = <<"复活点异常"/utf8>>};

get(4370033) ->
	#errorcode_msg{type = err437_guild_lim_cant_cancel_declare_war,about = <<"结社会长或副会长才能取消宣战"/utf8>>};

get(4370034) ->
	#errorcode_msg{type = err437_guild_lim_cant_exchange_props,about = <<"本服结社排名前2的结社会长或副会长才能兑换战备物资"/utf8>>};

get(4370035) ->
	#errorcode_msg{type = err437_not_act_server,about = <<"本服暂未开启跨服结社战功能"/utf8>>};

get(4400001) ->
	#errorcode_msg{type = err440_active_lv,about = <<"激活等级不足"/utf8>>};

get(4400002) ->
	#errorcode_msg{type = err440_max_lv,about = <<"已经达到最大等级"/utf8>>};

get(4400003) ->
	#errorcode_msg{type = err440_not_enough_cost,about = <<"升级资源不足"/utf8>>};

get(4400004) ->
	#errorcode_msg{type = err440_not_active,about = <<"降神未激活"/utf8>>};

get(4400005) ->
	#errorcode_msg{type = err440_max_stage,about = <<"已达到最大阶数"/utf8>>};

get(4400006) ->
	#errorcode_msg{type = err440_not_exist_god_id,about = <<"不存在降神Id"/utf8>>};

get(4400007) ->
	#errorcode_msg{type = err440_color_limit,about = <<"装备类型不符"/utf8>>};

get(4400008) ->
	#errorcode_msg{type = err440_equip_not_enough,about = <<"装备不足"/utf8>>};

get(4400009) ->
	#errorcode_msg{type = err440_max_star,about = <<"已达到最大星级"/utf8>>};

get(4400010) ->
	#errorcode_msg{type = err440_trans_not_handle,about = <<"变身中不能替换"/utf8>>};

get(4400011) ->
	#errorcode_msg{type = err440_in_same_pos,about = <<"已在该上阵位置上"/utf8>>};

get(4400012) ->
	#errorcode_msg{type = err440_empty_battle_god,about = <<"没有出战的降神"/utf8>>};

get(4400013) ->
	#errorcode_msg{type = err440_cd_not_end,about = <<"降神冷却中"/utf8>>};

get(4400014) ->
	#errorcode_msg{type = err440_cannot_switch_status,about = <<"当前状态不能降神"/utf8>>};

get(4400015) ->
	#errorcode_msg{type = err440_last_seq,about = <<"变身中"/utf8>>};

get(4400016) ->
	#errorcode_msg{type = err440_has_active,about = <<"已激活"/utf8>>};

get(4400017) ->
	#errorcode_msg{type = err440_not_god_equip,about = <<"非降神装备"/utf8>>};

get(4400018) ->
	#errorcode_msg{type = err440_lv_not_enough,about = <<"等级不足"/utf8>>};

get(4400019) ->
	#errorcode_msg{type = err440_forbid_scene_type,about = <<"当前场景不能变身"/utf8>>};

get(4400020) ->
	#errorcode_msg{type = err440_err_equip_pos,about = <<"装备部位错误"/utf8>>};

get(4400021) ->
	#errorcode_msg{type = err440_god_all_lv,about = <<"降神的总等级不满足"/utf8>>};

get(4400022) ->
	#errorcode_msg{type = err440_compose_location_err,about = <<"合成物品位置错误"/utf8>>};

get(4400023) ->
	#errorcode_msg{type = err440_compose_target_null,about = <<"合成物品为空"/utf8>>};

get(4420001) ->
	#errorcode_msg{type = err442_has_active,about = <<"图谱已激活"/utf8>>};

get(4420002) ->
	#errorcode_msg{type = err442_condition_not_enough,about = <<"条件不足"/utf8>>};

get(4420003) ->
	#errorcode_msg{type = err442_lv_not_enough,about = <<"等级不足"/utf8>>};

get(4420004) ->
	#errorcode_msg{type = err442_cfg_fail,about = <<"配置不存在"/utf8>>};

get(4420005) ->
	#errorcode_msg{type = err442_not_active,about = <<"未激活该图谱"/utf8>>};

get(4420006) ->
	#errorcode_msg{type = err442_has_max_lv,about = <<"已达满级"/utf8>>};

get(4500001) ->
	#errorcode_msg{type = err450_1_vip_lv_not_enough,about = <<"专属等级不够"/utf8>>};

get(4500002) ->
	#errorcode_msg{type = err450_2_present_one_time,about = <<"礼包只能购买一次"/utf8>>};

get(4500003) ->
	#errorcode_msg{type = err450_3_bag_not_enough,about = <<"背包不够"/utf8>>};

get(4500004) ->
	#errorcode_msg{type = err450_4_config_err,about = <<"配置错误"/utf8>>};

get(4500005) ->
	#errorcode_msg{type = err450_card_not_exist,about = <<"特权卡不存在"/utf8>>};

get(4500006) ->
	#errorcode_msg{type = err450_expire_type_error,about = <<"特权卡有效期类型错误"/utf8>>};

get(4500007) ->
	#errorcode_msg{type = err450_already_enable_and_viplv_max,about = <<"使用失败，已有永久特权卡，且vip等级已满！"/utf8>>};

get(4500008) ->
	#errorcode_msg{type = err450_has_notbuy,about = <<"未购买vip，不能使用本vip道具"/utf8>>};

get(4500009) ->
	#errorcode_msg{type = err450_goods_onlyuse_one,about = <<"每次只能使用一张特权卡"/utf8>>};

get(4500010) ->
	#errorcode_msg{type = err450_vip_goods_cfg_error,about = <<"vip道具配置缺失"/utf8>>};

get(4500011) ->
	#errorcode_msg{type = err450_first_award_error,about = <<"购买失败,奖励配置错误"/utf8>>};

get(4500012) ->
	#errorcode_msg{type = err450_buy_low_card,about = <<"您已激活更高等级的特权卡"/utf8>>};

get(4500013) ->
	#errorcode_msg{type = err450_vip_lv,about = <<"没有该vip等级"/utf8>>};

get(4500014) ->
	#errorcode_msg{type = err450_had_free_card,about = <<"已经领取该卡"/utf8>>};

get(4500015) ->
	#errorcode_msg{type = err450_have_not_cond,about = <<"不满足条件领取该卡"/utf8>>};

get(4510001) ->
	#errorcode_msg{type = err451_had_get,about = <<"已经领取"/utf8>>};

get(4510002) ->
	#errorcode_msg{type = err451_can_not_get,about = <<"不可领取"/utf8>>};

get(4510003) ->
	#errorcode_msg{type = err451_first_buy_ex,about = <<"先购买至尊vip体验"/utf8>>};

get(4510004) ->
	#errorcode_msg{type = err451_not_enough_vip_to_buy_ex,about = <<"达到vip6即可购买至尊VIP"/utf8>>};

get(4510005) ->
	#errorcode_msg{type = err451_not_enough_lv_to_buy_ex,about = <<"达到160级即可购买至尊VIP"/utf8>>};

get(4510006) ->
	#errorcode_msg{type = err451_had_buy_ex,about = <<"已激活体验至尊vip特权"/utf8>>};

get(4510007) ->
	#errorcode_msg{type = err451_not_enough_open_day,about = <<"开服天数不足无法提交"/utf8>>};

get(4510008) ->
	#errorcode_msg{type = err451_had_commit,about = <<"已经提交"/utf8>>};

get(4510009) ->
	#errorcode_msg{type = err451_no_finish,about = <<"没有完成,无法提交"/utf8>>};

get(4510010) ->
	#errorcode_msg{type = err451_this_supvip_type_not_to_commit,about = <<"需要激活至尊vip才可以提交"/utf8>>};

get(4600001) ->
	#errorcode_msg{type = err460_no_boss_cfg,about = <<"大妖配置错误！"/utf8>>};

get(4600002) ->
	#errorcode_msg{type = err460_no_boss_type,about = <<"大妖类型错误！"/utf8>>};

get(4600003) ->
	#errorcode_msg{type = err460_tried_max,about = <<"疲劳值已满！"/utf8>>};

get(4600004) ->
	#errorcode_msg{type = err460_count_max,about = <<"进入次数已用完！"/utf8>>};

get(4600005) ->
	#errorcode_msg{type = err460_no_lv,about = <<"您的等级不足！"/utf8>>};

get(4600006) ->
	#errorcode_msg{type = err460_no_remind,about = <<"您已经关注了，无需重复关注"/utf8>>};

get(4600007) ->
	#errorcode_msg{type = err460_no_unremind,about = <<"您还没有关注，无所需取消关注"/utf8>>};

get(4600008) ->
	#errorcode_msg{type = err460_no_lv_to_free,about = <<"等级不足无法免费进入"/utf8>>};

get(4600009) ->
	#errorcode_msg{type = err460_no_vip_to_free,about = <<"vip不足无法免费进入"/utf8>>};

get(4600010) ->
	#errorcode_msg{type = err460_no_vip,about = <<"您的VIP等级不足"/utf8>>};

get(4600011) ->
	#errorcode_msg{type = err460_not_enough_vit_to_enter,about = <<"体力不足无法进入"/utf8>>};

get(4600012) ->
	#errorcode_msg{type = err460_not_enough_ticket_to_result,about = <<"门票不足无法结算"/utf8>>};

get(4600013) ->
	#errorcode_msg{type = err460_max_lv,about = <<"您的等级过高"/utf8>>};

get(4600014) ->
	#errorcode_msg{type = err460_lv_not_enought_enter,about = <<"需达到180级可进入大妖之境"/utf8>>};

get(4600015) ->
	#errorcode_msg{type = err460_no_cfg,about = <<"配置出错"/utf8>>};

get(4600016) ->
	#errorcode_msg{type = err460_max_inspire,about = <<"该类型已达最大鼓舞次数"/utf8>>};

get(4600017) ->
	#errorcode_msg{type = err460_boss_die,about = <<"大妖已死亡，下次及时参与"/utf8>>};

get(4600018) ->
	#errorcode_msg{type = err460_not_open,about = <<"不在开放时间内"/utf8>>};

get(4600019) ->
	#errorcode_msg{type = err460_turn_not_enought_enter,about = <<"您的转生等级不符"/utf8>>};

get(4600020) ->
	#errorcode_msg{type = err460_had_on_boss,about = <<"已经在大妖场景中"/utf8>>};

get(4600021) ->
	#errorcode_msg{type = err460_not_boss_buy,about = <<"没有物品购买价格"/utf8>>};

get(4600022) ->
	#errorcode_msg{type = err460_remind_max,about = <<"您的大妖关注数量已达上限！"/utf8>>};

get(4600023) ->
	#errorcode_msg{type = err460_not_enough_bag,about = <<"装备空间不足无法进入"/utf8>>};

get(4600024) ->
	#errorcode_msg{type = err460_not_in_server_openday_range,about = <<"当前开服天数不满足！"/utf8>>};

get(4600025) ->
	#errorcode_msg{type = err460_no_vip_type_to_free,about = <<"需先激活特权卡"/utf8>>};

get(4600026) ->
	#errorcode_msg{type = not_blong_you,about = <<"非归属者不可打开宝箱"/utf8>>};

get(4600027) ->
	#errorcode_msg{type = time_out,about = <<"宝箱消失"/utf8>>};

get(4600028) ->
	#errorcode_msg{type = max_draw_times,about = <<"开启宝箱次数达到上限"/utf8>>};

get(4600029) ->
	#errorcode_msg{type = feast_boss_box_game_over,about = <<"已参加过本轮活动"/utf8>>};

get(4600030) ->
	#errorcode_msg{type = err460_debuff,about = <<"虚弱状态无法进入场景"/utf8>>};

get(4600031) ->
	#errorcode_msg{type = err460_domain_no_lv,about = <<"玩家等级不够"/utf8>>};

get(4600032) ->
	#errorcode_msg{type = err460_domain_no_kill_num,about = <<"击杀数量不足"/utf8>>};

get(4600033) ->
	#errorcode_msg{type = err460_domain_had_reward,about = <<"已经领取过奖励"/utf8>>};

get(4600034) ->
	#errorcode_msg{type = err460_no_die_to_cost_reborn,about = <<"大妖存活下无法使用复活令"/utf8>>};

get(4600035) ->
	#errorcode_msg{type = err460_no_cost_reborn,about = <<"不能复活"/utf8>>};

get(4600036) ->
	#errorcode_msg{type = err460_use_success,about = <<"使用成功，当前体力加1"/utf8>>};

get(4700001) ->
	#errorcode_msg{type = err470_boss_not_open,about = <<"蜃气楼未开启"/utf8>>};

get(4700002) ->
	#errorcode_msg{type = err470_no_zone,about = <<"没找到分区"/utf8>>};

get(4700003) ->
	#errorcode_msg{type = err470_is_resetting,about = <<"正在分区中"/utf8>>};

get(4700004) ->
	#errorcode_msg{type = err470_in_eudemons_boss,about = <<"在幻兽岛中，不能切换场景"/utf8>>};

get(4700005) ->
	#errorcode_msg{type = err470_doing_cost_reborn,about = <<"正在复活"/utf8>>};

get(4700006) ->
	#errorcode_msg{type = err470_ready_reborn_not_to_cost_reborn,about = <<"准备复活中"/utf8>>};

get(4700007) ->
	#errorcode_msg{type = err470_this_boss_not_to_cost_reborn,about = <<"本大妖不能主动复活"/utf8>>};

get(4700008) ->
	#errorcode_msg{type = err470_in_team,about = <<"该大妖不能组队"/utf8>>};

get(4710001) ->
	#errorcode_msg{type = err471_no_guild_to_ask_help,about = <<"没有结社无法请求援助"/utf8>>};

get(4710002) ->
	#errorcode_msg{type = err471_max_role_num,about = <<"达到最大人数上限"/utf8>>};

get(4710003) ->
	#errorcode_msg{type = err471_boss_die_not_to_enter,about = <<"大妖死亡无法进入"/utf8>>};

get(4710004) ->
	#errorcode_msg{type = err471_zone_allocate,about = <<"区域在分配中"/utf8>>};

get(4710005) ->
	#errorcode_msg{type = err471_no_zone,about = <<"区域不存在"/utf8>>};

get(4710006) ->
	#errorcode_msg{type = err471_act_status_zone_allocate,about = <<"状态处于区域分配"/utf8>>};

get(4710007) ->
	#errorcode_msg{type = err471_no_boss_cfg,about = <<"大妖配置缺失"/utf8>>};

get(4710008) ->
	#errorcode_msg{type = err471_buy_count_not_enough,about = <<"购买次数不足"/utf8>>};

get(4710009) ->
	#errorcode_msg{type = err471_not_decoration_boss_scene,about = <<"不是幻域大妖场景"/utf8>>};

get(4710010) ->
	#errorcode_msg{type = err471_decoration_rating_not_enough,about = <<"灵饰评分不足"/utf8>>};

get(4710011) ->
	#errorcode_msg{type = err471_lv_not_enough,about = <<"等级不足"/utf8>>};

get(4710012) ->
	#errorcode_msg{type = err471_enter_boss_assist_count_not_enough,about = <<"大妖协助次数不足"/utf8>>};

get(4710013) ->
	#errorcode_msg{type = err471_open_day_not_enough,about = <<"开放天数不足"/utf8>>};

get(4710014) ->
	#errorcode_msg{type = err471_enter_boss_count_not_enough,about = <<"进入大妖次数不足"/utf8>>};

get(4710015) ->
	#errorcode_msg{type = err471_not_change_scene_on_decoration_boss,about = <<"在幻域场景中无法切换"/utf8>>};

get(4710016) ->
	#errorcode_msg{type = err471_constellation_suit_not_enough,about = <<"指定的圣衣共鸣数量不足"/utf8>>};

get(4800001) ->
	#errorcode_msg{type = err480_no_zone,about = <<"服务器暂未分区，请稍后再试！"/utf8>>};

get(4800002) ->
	#errorcode_msg{type = err480_no_invasion_zone_data,about = <<"分区数据未初始化，请稍后再试！"/utf8>>};

get(4800003) ->
	#errorcode_msg{type = err480_no_invasion_ser_data,about = <<"服务器数据暂未同步，请稍后再试！"/utf8>>};

get(4800004) ->
	#errorcode_msg{type = err480_already_invasion,about = <<"您已经在跨服入侵活动中，请先退出当前入侵服再操作！"/utf8>>};

get(4800005) ->
	#errorcode_msg{type = err480_client_data_error,about = <<"客户端请求数据异常，请及时联系技术大大！"/utf8>>};

get(4800006) ->
	#errorcode_msg{type = err480_invasion_close,about = <<"跨服入侵活动已关闭！"/utf8>>};

get(4800007) ->
	#errorcode_msg{type = err480_no_reach_open,about = <<"您所在服暂未达到跨服入侵开启条件！"/utf8>>};

get(4800008) ->
	#errorcode_msg{type = err480_no_same_zone,about = <<"不同区的服，无法入侵，请选择其他可以入侵的服！"/utf8>>};

get(4800009) ->
	#errorcode_msg{type = err480_role_buyond,about = <<"该服入侵玩家人数已满，请稍后再进！"/utf8>>};

get(4900001) ->
	#errorcode_msg{type = err490_full_draw,about = <<"已经全部抽完"/utf8>>};

get(4900002) ->
	#errorcode_msg{type = err490_no_draw_times,about = <<"抽奖次数已经用完"/utf8>>};

get(4900003) ->
	#errorcode_msg{type = err490_already_back,about = <<"已经领取返利奖励了"/utf8>>};

get(4900004) ->
	#errorcode_msg{type = err490_not_buy_all,about = <<"请购买所有的礼包"/utf8>>};

get(4900005) ->
	#errorcode_msg{type = err490_not_buy,about = <<"没有购买礼包"/utf8>>};

get(5000001) ->
	#errorcode_msg{type = err500_husong_start,about = <<"正在护送中"/utf8>>};

get(5000002) ->
	#errorcode_msg{type = err500_husong_end,about = <<"今日护送已全部完成~"/utf8>>};

get(5000003) ->
	#errorcode_msg{type = err500_husong_unfinish_last_stage,about = <<"未完成上一个阶段"/utf8>>};

get(5000004) ->
	#errorcode_msg{type = err500_husong_quality_max,about = <<"品质已达上限"/utf8>>};

get(5000005) ->
	#errorcode_msg{type = err500_husong_cant_change_scene,about = <<"开始了护送无法切换场景"/utf8>>};

get(5000006) ->
	#errorcode_msg{type = err500_husong_not_start,about = <<"护送还没开始"/utf8>>};

get(5000007) ->
	#errorcode_msg{type = err500_husong_stage_wrong,about = <<"护送阶段不正确"/utf8>>};

get(5000008) ->
	#errorcode_msg{type = err500_husong_ask_cd,about = <<"求助冷却中"/utf8>>};

get(5000009) ->
	#errorcode_msg{type = err500_husong_help_offline,about = <<"求助玩家已下线"/utf8>>};

get(5000010) ->
	#errorcode_msg{type = err500_husong_help_end,about = <<"求助玩家护送已结束"/utf8>>};

get(5000011) ->
	#errorcode_msg{type = err500_husong_help_same_scene,about = <<"求助玩家和你在同一场景"/utf8>>};

get(5000012) ->
	#errorcode_msg{type = err500_husong_not_now_scene_packup,about = <<"不是当前场景接取护送任务"/utf8>>};

get(5000013) ->
	#errorcode_msg{type = err500_husong_not_right_target_id,about = <<"目标天使id错误"/utf8>>};

get(5000014) ->
	#errorcode_msg{type = err500_husong_take_num_max,about = <<"拦截奖励次数已达上限，无法继续获得奖励"/utf8>>};

get(5000015) ->
	#errorcode_msg{type = err500_husong_take_success,about = <<"拦截成功"/utf8>>};

get(5000016) ->
	#errorcode_msg{type = err500_husong_invincible_max,about = <<"庇护已用完"/utf8>>};

get(5000017) ->
	#errorcode_msg{type = err500_husong_reflesh_fail,about = <<"提升失败，天使品质不变"/utf8>>};

get(5000018) ->
	#errorcode_msg{type = err500_husong_reflesh_success,about = <<"提升成功，获得<color={1}>{2}</color>天使"/utf8>>};

get(5000019) ->
	#errorcode_msg{type = err500_husong_cost,about = <<"共消耗{1}个天使令，{2}绑玉，{3}勾玉"/utf8>>};

get(5000020) ->
	#errorcode_msg{type = err500_husong_time,about = <<"护送时间不足"/utf8>>};

get(5000021) ->
	#errorcode_msg{type = err500_times_not_enough,about = <<"今日护送已全部完成~"/utf8>>};

get(5010001) ->
	#errorcode_msg{type = err501_please_join_guild,about = <<"请先加入结社，再来参加活动！"/utf8>>};

get(5010002) ->
	#errorcode_msg{type = err501_cannot_attack_friend,about = <<"请勿抢夺好友积分！"/utf8>>};

get(5010003) ->
	#errorcode_msg{type = err501_act_close,about = <<"荣耀战神活动已结束！"/utf8>>};

get(5010004) ->
	#errorcode_msg{type = err501_in_attack_cd,about = <<"冷却未冷却！"/utf8>>};

get(5010005) ->
	#errorcode_msg{type = err501_player_not_exist,about = <<"缺失玩家数据"/utf8>>};

get(5010006) ->
	#errorcode_msg{type = err501_oppplayer_not_exist,about = <<"对方玩家数据异常"/utf8>>};

get(5010007) ->
	#errorcode_msg{type = err501_in_protect_cd,about = <<"对方处于抢夺保护时间"/utf8>>};

get(5010008) ->
	#errorcode_msg{type = err501_cannot_attack,about = <<"请勿抢夺比自己名次差距太大的玩家"/utf8>>};

get(5010009) ->
	#errorcode_msg{type = err501_not_in_attack_idel,about = <<"请等当前战斗结束后，再来操作！"/utf8>>};

get(5010010) ->
	#errorcode_msg{type = err501_cannot_attack_self,about = <<"请勿抢夺你自己"/utf8>>};

get(5010011) ->
	#errorcode_msg{type = err501_cannot_transferable,about = <<"在主城和安全区才能参加活动！"/utf8>>};

get(5010012) ->
	#errorcode_msg{type = err501_lv_not_enough,about = <<"等级不足20级，暂不能参加荣耀战神活动！"/utf8>>};

get(5030001) ->
	#errorcode_msg{type = err503_cannot_transferable,about = <<"在主城和安全区才能参与活动！"/utf8>>};

get(5030002) ->
	#errorcode_msg{type = err503_lv_error,about = <<"您未达到活动开启等级！"/utf8>>};

get(5030003) ->
	#errorcode_msg{type = err503_rival_not_enough,about = <<"英雄战场对手不足，暂时无法开启！"/utf8>>};

get(5030004) ->
	#errorcode_msg{type = err503_init_rival_error,about = <<"对手数据初始化异常"/utf8>>};

get(5030005) ->
	#errorcode_msg{type = err503_client_init_rival_error,about = <<"请刷新，客户端获取的对手数据不是最新的！"/utf8>>};

get(5030006) ->
	#errorcode_msg{type = err503_finish_all_attack,about = <<"您已挑战完所有对手！"/utf8>>};

get(5030007) ->
	#errorcode_msg{type = err503_in_battle_status,about = <<"您当前处于挑战状态，请先挑战！"/utf8>>};

get(5030008) ->
	#errorcode_msg{type = err503_no_award,about = <<"无可领取的奖励！"/utf8>>};

get(5030009) ->
	#errorcode_msg{type = err503_not_enough_attack_count,about = <<"剩余挑战次数不足！"/utf8>>};

get(5030010) ->
	#errorcode_msg{type = err503_reset_status,about = <<"英雄战场正在重置，无法挑战"/utf8>>};

get(5030011) ->
	#errorcode_msg{type = err503_missing_award_cfg,about = <<"领取失败，缺失奖励配置"/utf8>>};

get(5030012) ->
	#errorcode_msg{type = err503_settlement_plase_wait,about = <<"结算中，请稍后退出！"/utf8>>};

get(5030013) ->
	#errorcode_msg{type = err503_not_in_hero_war,about = <<"退出失败，不在英雄战场中！"/utf8>>};

get(5050001) ->
	#errorcode_msg{type = err505_reward_is_got,about = <<"奖励已领取"/utf8>>};

get(5050002) ->
	#errorcode_msg{type = err505_in_guild_battle,about = <<"正在结社战中，无法切换场景"/utf8>>};

get(5050003) ->
	#errorcode_msg{type = err505_is_not_open,about = <<"活动未开启"/utf8>>};

get(5050004) ->
	#errorcode_msg{type = err505_cfg_error,about = <<"配置出错"/utf8>>};

get(5050005) ->
	#errorcode_msg{type = err505_not_in_battle,about = <<"不在活动内"/utf8>>};

get(5050006) ->
	#errorcode_msg{type = err505_lv_not_enough,about = <<"等级不足"/utf8>>};

get(5050007) ->
	#errorcode_msg{type = err505_no_guild,about = <<"请先加入结社"/utf8>>};

get(5050008) ->
	#errorcode_msg{type = err505_condition_not_enough,about = <<"领取条件不足"/utf8>>};

get(5050009) ->
	#errorcode_msg{type = err505_resource_not_enough,about = <<"资源不足"/utf8>>};

get(5050010) ->
	#errorcode_msg{type = err505_ac_enough_role,about = <<"参加人数已满"/utf8>>};

get(5050011) ->
	#errorcode_msg{type = err505_guild_enough_role,about = <<"结社参战人数已满"/utf8>>};

get(5050012) ->
	#errorcode_msg{type = err505_war_is_openning,about = <<"正在活动中，不能分配"/utf8>>};

get(5050013) ->
	#errorcode_msg{type = err505_not_winner,about = <<"非胜利方"/utf8>>};

get(5050014) ->
	#errorcode_msg{type = err505_reward_is_alloc,about = <<"奖励已分配"/utf8>>};

get(5050015) ->
	#errorcode_msg{type = err505_no_alloc_reward,about = <<"没有奖励可分配"/utf8>>};

get(5050016) ->
	#errorcode_msg{type = err505_join_in_guild_not_enough_time_can_not_receive,about = <<"加入结社不足24小时，无法领取"/utf8>>};

get(5060001) ->
	#errorcode_msg{type = err506_in_battle,about = <<"在领地战中，不能切换场景！"/utf8>>};

get(5060002) ->
	#errorcode_msg{type = err506_war_not_start,about = <<"活动未开启"/utf8>>};

get(5060003) ->
	#errorcode_msg{type = err506_war_end,about = <<"活动已结束"/utf8>>};

get(5060004) ->
	#errorcode_msg{type = err506_fight_end,about = <<"下轮领地战暂未开启，请耐心等待..."/utf8>>};

get(5060005) ->
	#errorcode_msg{type = err506_no_qualification,about = <<"你结社没有参赛资格"/utf8>>};

get(5060006) ->
	#errorcode_msg{type = err506_no_qualification_2,about = <<"没有参赛资格"/utf8>>};

get(5060007) ->
	#errorcode_msg{type = err506_choose_time_err,about = <<"已经过了选领地时间"/utf8>>};

get(5060008) ->
	#errorcode_msg{type = err506_had_choose,about = <<"已经选了其他领地"/utf8>>};

get(5060009) ->
	#errorcode_msg{type = err506_had_be_choose,about = <<"同一领地最多只能有两个结社宣战"/utf8>>};

get(5060010) ->
	#errorcode_msg{type = err506_choose_err_id,about = <<"该领地不能选择"/utf8>>};

get(5060011) ->
	#errorcode_msg{type = err506_not_in_battle,about = <<"不在战场中"/utf8>>};

get(5060012) ->
	#errorcode_msg{type = err506_only_chief_choose,about = <<"只有会长能选择领地哦！"/utf8>>};

get(5060013) ->
	#errorcode_msg{type = err506_not_winner,about = <<"不是霸主结社"/utf8>>};

get(5060014) ->
	#errorcode_msg{type = err506_reward_is_got,about = <<"奖励已领取"/utf8>>};

get(5060015) ->
	#errorcode_msg{type = err506_join_in_guild_not_enough_time_can_not_receive,about = <<"加入结社不足24小时，无法领取"/utf8>>};

get(5060016) ->
	#errorcode_msg{type = err506_not_chief_alloc,about = <<"会长才能分配奖励"/utf8>>};

get(5060017) ->
	#errorcode_msg{type = err506_not_same_guild_alloc,about = <<"非同结社成员"/utf8>>};

get(5060018) ->
	#errorcode_msg{type = err506_war_is_openning,about = <<"活动开启中"/utf8>>};

get(5060019) ->
	#errorcode_msg{type = err506_reward_is_alloc,about = <<"奖励已分配"/utf8>>};

get(5060020) ->
	#errorcode_msg{type = err506_no_alloc_reward,about = <<"没有奖励可分配"/utf8>>};

get(5060021) ->
	#errorcode_msg{type = err506_no_qualification_3,about = <<"你结社已被淘汰！"/utf8>>};

get(5070001) ->
	#errorcode_msg{type = err507_pre_level_not_pass,about = <<"前置层数未通关"/utf8>>};

get(5070002) ->
	#errorcode_msg{type = err507_level_too_low,about = <<"不能挑战更低层的副本哦"/utf8>>};

get(5070003) ->
	#errorcode_msg{type = err507_no_reward,about = <<"没有奖励可领"/utf8>>};

get(5070004) ->
	#errorcode_msg{type = err507_reward_got,about = <<"奖励已领取"/utf8>>};

get(5070005) ->
	#errorcode_msg{type = err507_no_dungeon_times,about = <<"挑战次数不足"/utf8>>};

get(5080001) ->
	#errorcode_msg{type = err508_single_dun_not_succ,about = <<"请先通关单人试炼"/utf8>>};

get(5080002) ->
	#errorcode_msg{type = err508_single_dun_not_succ_by_other,about = <<"{1}没通关单人试炼"/utf8>>};

get(5100001) ->
	#errorcode_msg{type = err510_all_got,about = <<"奖励已全部领取"/utf8>>};

get(5100002) ->
	#errorcode_msg{type = err510_had_abandon,about = <<"已放弃，不能再领奖励"/utf8>>};

get(5100003) ->
	#errorcode_msg{type = err510_no_rotary,about = <<"转盘没激活"/utf8>>};

get(5120001) ->
	#errorcode_msg{type = err512_act_close,about = <<"活动已关闭"/utf8>>};

get(5120002) ->
	#errorcode_msg{type = err512_end_buy,about = <<"已截止购买"/utf8>>};

get(5120003) ->
	#errorcode_msg{type = err512_no_times_in_restriction,about = <<"当前剩余限购次数不足"/utf8>>};

get(5120004) ->
	#errorcode_msg{type = err512_stage_count_err,about = <<"阶段错误"/utf8>>};

get(5120005) ->
	#errorcode_msg{type = err512_stage_reward_got,about = <<"阶段奖励已领取"/utf8>>};

get(5120006) ->
	#errorcode_msg{type = err512_stage_count_less,about = <<"累积次数不足"/utf8>>};

get(5120007) ->
	#errorcode_msg{type = err512_no_draw_reward,about = <<"请先云购大奖"/utf8>>};

get(5120008) ->
	#errorcode_msg{type = err512_grade_end,about = <<"当前云购活动已结束"/utf8>>};

get(5120009) ->
	#errorcode_msg{type = err512_no_grade_times,about = <<"当前云购剩余份数不足"/utf8>>};

get(5120010) ->
	#errorcode_msg{type = err512_no_such_grade,about = <<"没有该大奖"/utf8>>};

get(5130001) ->
	#errorcode_msg{type = err513_not_buy,about = <<"未购买该系统"/utf8>>};

get(5130002) ->
	#errorcode_msg{type = err513_low_lv,about = <<"等级不足"/utf8>>};

get(6000000) ->
	#errorcode_msg{type = err600_not_open,about = <<"活动未开启"/utf8>>};

get(6000001) ->
	#errorcode_msg{type = err600_is_pass,about = <<"您已通关虚空秘境，无法进入"/utf8>>};

get(6000002) ->
	#errorcode_msg{type = err600_can_not_change_scene_in_void_fam,about = <<"玩家正处于虚空秘境活动，不能参加其他活动"/utf8>>};

get(6010001) ->
	#errorcode_msg{type = err601_not_kf_hegemony_server,about = <<"玩家所在服务器不满足服战参与条件"/utf8>>};

get(6010002) ->
	#errorcode_msg{type = err601_be_appoint_ser_id_not_vaild,about = <<"对方服务器不存在，不能进行约战"/utf8>>};

get(6010003) ->
	#errorcode_msg{type = err601_has_appoint_server,about = <<"您所在的服务器已有约战在身，无法继续约战"/utf8>>};

get(6010004) ->
	#errorcode_msg{type = err601_appoint_server_cd,about = <<"该服处于约战冷却状态，请5分钟后再试"/utf8>>};

get(6010005) ->
	#errorcode_msg{type = err601_not_enough_score,about = <<"本服积分不足，无法约战"/utf8>>};

get(6010006) ->
	#errorcode_msg{type = err601_player_not_qualified,about = <<"您没有参赛资格，无法入场"/utf8>>};

get(6010007) ->
	#errorcode_msg{type = err601_battlefield_has_end,about = <<"该战场已分出胜负，快去别的战场杀敌吧"/utf8>>};

get(6010008) ->
	#errorcode_msg{type = err601_not_in_battle_stage,about = <<"战斗期内才可入场"/utf8>>};

get(6010009) ->
	#errorcode_msg{type = err601_reach_max_people_lim,about = <<"战场内本方人数已达上限"/utf8>>};

get(6010010) ->
	#errorcode_msg{type = err601_has_sign_up,about = <<"您已经报名，无需重复报名"/utf8>>};

get(6010011) ->
	#errorcode_msg{type = err601_cant_sign_up_because_stage_err,about = <<"活动未处于约战期，无法报名"/utf8>>};

get(6010012) ->
	#errorcode_msg{type = err601_cant_change_scene_in_kf_hegemony,about = <<"玩家正处于跨服服战活动，不能参加其他活动"/utf8>>};

get(6010013) ->
	#errorcode_msg{type = err601_battle_room_not_exist,about = <<"房间不存在"/utf8>>};

get(6010014) ->
	#errorcode_msg{type = err601_not_in_act_scene,about = <<"不在活动场景"/utf8>>};

get(6010015) ->
	#errorcode_msg{type = err601_lv_lim,about = <<"跨服服战{1}级开启"/utf8>>};

get(6010016) ->
	#errorcode_msg{type = err601_has_in_scene,about = <<"已在活动场景"/utf8>>};

get(6010017) ->
	#errorcode_msg{type = err601_not_dominator,about = <<"您不是本服约战人"/utf8>>};

get(6020001) ->
	#errorcode_msg{type = err602_act_close,about = <<"活动未开启"/utf8>>};

get(6020002) ->
	#errorcode_msg{type = err602_cant_change_scene_in_th_armies_battle,about = <<"玩家正处于三军之战活动，不能参加其他活动"/utf8>>};

get(6020003) ->
	#errorcode_msg{type = err602_not_in_act_scene,about = <<"不在活动场景"/utf8>>};

get(6020004) ->
	#errorcode_msg{type = err602_no_enough_lv_join,about = <<"等级不足，无法参加活动"/utf8>>};

get(6020005) ->
	#errorcode_msg{type = err602_max_people_num_lim,about = <<"场景人数已满"/utf8>>};

get(6030001) ->
	#errorcode_msg{type = err603_in_battle,about = <<"当前正在幻兽入侵活动中"/utf8>>};

get(6040001) ->
	#errorcode_msg{type = err604_apply_power_limit,about = <<"历史最高战力不足"/utf8>>};

get(6040002) ->
	#errorcode_msg{type = err604_apply_repeat,about = <<"您已经报名"/utf8>>};

get(6040003) ->
	#errorcode_msg{type = err604_not_competitor,about = <<"您不是入选选手"/utf8>>};

get(6040004) ->
	#errorcode_msg{type = err604_in_the_act,about = <<"您当前正在参加星钻联赛"/utf8>>};

get(6040005) ->
	#errorcode_msg{type = err604_not_enter_state,about = <<"当前阶段不可进入"/utf8>>};

get(6040006) ->
	#errorcode_msg{type = err604_skill_cd,about = <<"技能正在冷却中"/utf8>>};

get(6040007) ->
	#errorcode_msg{type = err604_life_num_max,about = <<"复活次数已达上限，无法购买"/utf8>>};

get(6040008) ->
	#errorcode_msg{type = err604_buy_life_cost,about = <<"星钻入场券和勾玉不足，购买失败"/utf8>>};

get(6040009) ->
	#errorcode_msg{type = err604_has_fail,about = <<"您已经被淘汰"/utf8>>};

get(6040010) ->
	#errorcode_msg{type = err604_guess_reward_is_got,about = <<"竞猜奖励已领取"/utf8>>};

get(6040011) ->
	#errorcode_msg{type = err604_guess_reward_error,about = <<"您没有获得该奖励"/utf8>>};

get(6040012) ->
	#errorcode_msg{type = err604_not_guess_time,about = <<"当前不是竞猜时间"/utf8>>};

get(6040013) ->
	#errorcode_msg{type = err604_guest_modify,about = <<"竞猜修改成功"/utf8>>};

get(6040014) ->
	#errorcode_msg{type = err604_guest_role_error,about = <<"竞猜选择有误"/utf8>>};

get(6040015) ->
	#errorcode_msg{type = err604_guess_no_change,about = <<"竞猜选择没有变化"/utf8>>};

get(6040016) ->
	#errorcode_msg{type = err604_any_guess_not_choosed,about = <<"请选择好所有的竞猜项"/utf8>>};

get(6040017) ->
	#errorcode_msg{type = err604_battle_end,about = <<"本场战斗已结束"/utf8>>};

get(6040018) ->
	#errorcode_msg{type = err604_visitor_num_limit,about = <<"本场观战人数已达上限"/utf8>>};

get(6040019) ->
	#errorcode_msg{type = err604_competitor_cannot_visit,about = <<"参赛选手不能观战"/utf8>>};

get(6060001) ->
	#errorcode_msg{type = err606_lv_limit,about = <<"未达开放等级"/utf8>>};

get(6060002) ->
	#errorcode_msg{type = err606_not_enough_cost,about = <<"物品不足"/utf8>>};

get(6060003) ->
	#errorcode_msg{type = err606_already_active,about = <<"已激活"/utf8>>};

get(6060004) ->
	#errorcode_msg{type = err606_max_stage,about = <<"已达最高阶"/utf8>>};

get(6060005) ->
	#errorcode_msg{type = err606_not_active,about = <<"未激活"/utf8>>};

get(6060006) ->
	#errorcode_msg{type = err606_max_lv,about = <<"已达最高觉醒等级"/utf8>>};

get(6060007) ->
	#errorcode_msg{type = err606_relic_max_times,about = <<"已达上限"/utf8>>};

get(6060008) ->
	#errorcode_msg{type = err606_already_illu,about = <<"已出战"/utf8>>};

get(6070001) ->
	#errorcode_msg{type = err607_not_enter_times,about = <<"挑战次数不足"/utf8>>};

get(6070002) ->
	#errorcode_msg{type = err607_fighting,about = <<"战斗中"/utf8>>};

get(6070003) ->
	#errorcode_msg{type = err607_cd,about = <<"冷却中"/utf8>>};

get(6070004) ->
	#errorcode_msg{type = err607_fight_self,about = <<"不能挑战自己"/utf8>>};

get(6070005) ->
	#errorcode_msg{type = err607_sainting,about = <<"正在圣者殿中"/utf8>>};

get(6070006) ->
	#errorcode_msg{type = err607_saint_lv_limit,about = <<"你不能挑战称号等级比你低的对手"/utf8>>};

get(6070007) ->
	#errorcode_msg{type = err607_inspire_num_limit,about = <<"鼓舞次数上限"/utf8>>};

get(6100001) ->
	#errorcode_msg{type = err610_dungeon_role_not_exist,about = <<"副本玩家不存在"/utf8>>};

get(6100002) ->
	#errorcode_msg{type = err610_dungeon_team_args_error,about = <<"副本的队伍参数错误"/utf8>>};

get(6100003) ->
	#errorcode_msg{type = err610_not_on_safe_scene_to_enter_dungeon,about = <<"你不在安全区域无法进去副本"/utf8>>};

get(6100004) ->
	#errorcode_msg{type = err610_not_on_safe_scene_to_enter_dungeon_by_other,about = <<"{1}所在场景无法进入副本"/utf8>>};

get(6100005) ->
	#errorcode_msg{type = err610_not_enough_lv_to_enter_dungeon_by_other,about = <<"{1}等级不足无法进入副本"/utf8>>};

get(6100006) ->
	#errorcode_msg{type = err610_dungeon_count_daily_help_by_other,about = <<"{1}助战次数不足"/utf8>>};

get(6100007) ->
	#errorcode_msg{type = err610_dungeon_count_permanent_by_other,about = <<"{1}副本次数不足，终生最多进去{2}次"/utf8>>};

get(6100008) ->
	#errorcode_msg{type = err610_dungeon_count_week_by_other,about = <<"{1}副本次数不足，每周最多进去{2}次"/utf8>>};

get(6100009) ->
	#errorcode_msg{type = err610_dungeon_count_daily_by_other,about = <<"{1}副本次数不足"/utf8>>};

get(6100010) ->
	#errorcode_msg{type = err610_dungeon_not_open,about = <<"副本没有开启"/utf8>>};

get(6100011) ->
	#errorcode_msg{type = err610_just_once_finish,about = <<"副本已经通关，不能重复挑战"/utf8>>};

get(6100012) ->
	#errorcode_msg{type = err610_need_finish_dun_id,about = <<"需要完整通关前一难度副本"/utf8>>};

get(6100013) ->
	#errorcode_msg{type = err610_not_enough_lv_to_enter_dungeon,about = <<"等级不足，无法进入副本"/utf8>>};

get(6100014) ->
	#errorcode_msg{type = err610_dungeon_num_not_satisfy,about = <<"人数不足，无法进入副本"/utf8>>};

get(6100015) ->
	#errorcode_msg{type = err610_dungeon_count_cfg_error,about = <<"副本配置出错"/utf8>>};

get(6100016) ->
	#errorcode_msg{type = err610_dungeon_count_daily_help,about = <<"副本次数不足"/utf8>>};

get(6100017) ->
	#errorcode_msg{type = err610_dungeon_count_permanent,about = <<"副本已经通关，不能重复挑战"/utf8>>};

get(6100018) ->
	#errorcode_msg{type = err610_dungeon_count_week,about = <<"副本次数不足"/utf8>>};

get(6100019) ->
	#errorcode_msg{type = err610_dungeon_count_daily,about = <<"副本次数不足"/utf8>>};

get(6100020) ->
	#errorcode_msg{type = err610_cls_team_not_enter_dungeon,about = <<"跨服队伍无法进入本副本"/utf8>>};

get(6100021) ->
	#errorcode_msg{type = err610_on_dungeon,about = <<"玩家已经在副本中"/utf8>>};

get(6100022) ->
	#errorcode_msg{type = err610_dungeon_not_exist,about = <<"副本不存在"/utf8>>};

get(6100029) ->
	#errorcode_msg{type = err610_not_on_enter_scene,about = <<"你不在副本进入所需场景"/utf8>>};

get(6100030) ->
	#errorcode_msg{type = err610_not_on_enter_scene_by_other,about = <<"{1}不在副本进入所需场景"/utf8>>};

get(6100031) ->
	#errorcode_msg{type = err610_dungeon_error,about = <<"副本异常,请联系GM"/utf8>>};

get(6100032) ->
	#errorcode_msg{type = err610_dungeon_scene_not_exist,about = <<"副本场景不存在"/utf8>>};

get(6100033) ->
	#errorcode_msg{type = err610_had_on_dungeon,about = <<"已经在副本"/utf8>>};

get(6100034) ->
	#errorcode_msg{type = err610_cannot_join_act_on_battle,about = <<"脱离战斗状态才能进入副本"/utf8>>};

get(6100035) ->
	#errorcode_msg{type = err610_cannot_join_act_on_battle_with_name,about = <<"{1}同意，正在脱离战斗，前往安全位置"/utf8>>};

get(6100038) ->
	#errorcode_msg{type = err610_have_no_count_to_enter_target_with_name,about = <<"{1}的次数为0，无法进入目标"/utf8>>};

get(6100039) ->
	#errorcode_msg{type = err610_have_no_count_to_enter_target,about = <<"您的次数为0，无法进入目标"/utf8>>};

get(6100040) ->
	#errorcode_msg{type = err610_have_no_count_to_create_target,about = <<"您的次数为0，无法创建目标"/utf8>>};

get(6100041) ->
	#errorcode_msg{type = err610_enter_cost_error,about = <<"您的门票不足，无法进入副本"/utf8>>};

get(6100042) ->
	#errorcode_msg{type = err610_buy_cost_error,about = <<"您的勾玉余额不足，无法购买次数"/utf8>>};

get(6100043) ->
	#errorcode_msg{type = err610_buy_vip_error,about = <<"提升vip等级可购买更多次数"/utf8>>};

get(6100044) ->
	#errorcode_msg{type = err610_buy_limit_error,about = <<"今日购买次数已达上限"/utf8>>};

get(6100045) ->
	#errorcode_msg{type = err610_sweep_limit_error,about = <<"该副本不能扫荡"/utf8>>};

get(6100046) ->
	#errorcode_msg{type = err610_sweep_lv_limit,about = <<"扫荡该副本需要角色达到{1}级"/utf8>>};

get(6100047) ->
	#errorcode_msg{type = err610_sweep_never_finish,about = <<"需要通关副本才能扫荡"/utf8>>};

get(6100048) ->
	#errorcode_msg{type = err610_dungeon_count_daily_sweep,about = <<"剩余次数不足"/utf8>>};

get(6100049) ->
	#errorcode_msg{type = err610_dungeon_count_weekly_sweep,about = <<"周次数不足"/utf8>>};

get(6100050) ->
	#errorcode_msg{type = err610_dungeon_count_permanent_sweep,about = <<"终生次数不足"/utf8>>};

get(6100051) ->
	#errorcode_msg{type = err610_help_times_left,about = <<"助战奖励已发送到背包，今日还可获得{1}次助战奖励"/utf8>>};

get(6100052) ->
	#errorcode_msg{type = err610_encourage_count_limit,about = <<"鼓舞次数已达上限"/utf8>>};

get(6100053) ->
	#errorcode_msg{type = err610_encourage_coin_count_limit,about = <<"铜币鼓舞次数已达上限"/utf8>>};

get(6100054) ->
	#errorcode_msg{type = err610_reset_count_limit,about = <<"重置次数不足"/utf8>>};

get(6100055) ->
	#errorcode_msg{type = err610_nothing_reset,about = <<"没有可重置的关卡"/utf8>>};

get(6100056) ->
	#errorcode_msg{type = err610_nothing_sweep,about = <<"当前无可扫荡的副本"/utf8>>};

get(6100057) ->
	#errorcode_msg{type = err610_help_reward_time_limit,about = <<"今日助战次数已用完，无法再获得助战奖励"/utf8>>};

get(6100058) ->
	#errorcode_msg{type = err610_too_many_members,about = <<"该副本进入人数不能超过{1}人"/utf8>>};

get(6100059) ->
	#errorcode_msg{type = err610_dungeon_is_end,about = <<"当前已经结算，无法进入"/utf8>>};

get(6100060) ->
	#errorcode_msg{type = err610_buy_count_error,about = <<"该副本不能购买次数"/utf8>>};

get(6100061) ->
	#errorcode_msg{type = err610_only_couple_enter,about = <<"该副本只能互为异性或者情侣夫妻才可进入"/utf8>>};

get(6100067) ->
	#errorcode_msg{type = err610_choose_same_partner_group_id,about = <<"必须选择伙伴同一组别"/utf8>>};

get(6100068) ->
	#errorcode_msg{type = err610_on_choose_partner_group_cd,about = <<"选择伙伴组别的冷却时间不足"/utf8>>};

get(6100069) ->
	#errorcode_msg{type = err610_not_right_group_id,about = <<"不是正确的伙伴组别"/utf8>>};

get(6100070) ->
	#errorcode_msg{type = err610_can_not_choose_partner_group,about = <<"不能选择伙伴组别"/utf8>>};

get(6100071) ->
	#errorcode_msg{type = err610_encourage_gold_count_limit,about = <<"勾玉鼓舞次数已达上限"/utf8>>};

get(6100072) ->
	#errorcode_msg{type = err610_not_enough_turn_to_enter_dungeon,about = <<"未达到转生阶段"/utf8>>};

get(6100073) ->
	#errorcode_msg{type = err610_must_pass_to_receive_reward,about = <<"必须通关副本才能领取奖励"/utf8>>};

get(6100074) ->
	#errorcode_msg{type = err610_had_receive_reward,about = <<"每日奖励已领取，请明天再来吧！"/utf8>>};

get(6100075) ->
	#errorcode_msg{type = err610_not_reward,about = <<"没有奖励配置"/utf8>>};

get(6100076) ->
	#errorcode_msg{type = err610_must_had_reward_to_enter,about = <<"必须领取奖励才能进入副本"/utf8>>};

get(6100077) ->
	#errorcode_msg{type = err610_not_enough_vip_type_to_enter_dungeon,about = <<"开通特权卡可享Vip特权"/utf8>>};

get(6100078) ->
	#errorcode_msg{type = err610_not_enough_vip_lv_to_enter_dungeon,about = <<"vip等级不足无法进入"/utf8>>};

get(6100079) ->
	#errorcode_msg{type = err610_value_not_enougth,about = <<"您的神龛值不足，击杀异兽可以获得大量神龛值！"/utf8>>};

get(6100080) ->
	#errorcode_msg{type = err610_mon_not_refresh,about = <<"异兽还未刷新"/utf8>>};

get(6100081) ->
	#errorcode_msg{type = err610_not_enough_cd,about = <<"冷却时间不足"/utf8>>};

get(6100082) ->
	#errorcode_msg{type = err610_invitting_other_to_dun,about = <<"正在邀请副本中"/utf8>>};

get(6100083) ->
	#errorcode_msg{type = err610_invite_timeout,about = <<"邀请已超时"/utf8>>};

get(6100084) ->
	#errorcode_msg{type = err610_not_invite_dun,about = <<"没有邀请玩家"/utf8>>};

get(6100085) ->
	#errorcode_msg{type = err610_buy_not_marriage,about = <<"请先结婚"/utf8>>};

get(6100086) ->
	#errorcode_msg{type = err610_single_dungeon_must_quit_team,about = <<"单人副本需要退出队伍才能进入"/utf8>>};

get(6100087) ->
	#errorcode_msg{type = err610_not_enough_quick_create_mon_count,about = <<"没有快速刷怪次数"/utf8>>};

get(6100088) ->
	#errorcode_msg{type = err610_on_quick_create_mon_cd,about = <<"处于快速刷怪冷却时间内"/utf8>>};

get(6100089) ->
	#errorcode_msg{type = err610_skill_error_in_ghost,about = <<"处于幽灵状态，不能使用技能"/utf8>>};

get(6100090) ->
	#errorcode_msg{type = err610_help_can_not_collect,about = <<"助战不能采集宝箱"/utf8>>};

get(6100091) ->
	#errorcode_msg{type = err610_not_finish_task,about = <<"没有完成任务，不能挑战"/utf8>>};

get(6100092) ->
	#errorcode_msg{type = err610_not_tigger_task,about = <<"没有接本任务，不能挑战"/utf8>>};

get(6100093) ->
	#errorcode_msg{type = err610_can_not_again_enter_dungeon,about = <<"已经在副本，无法再次挑战"/utf8>>};

get(6100094) ->
	#errorcode_msg{type = err610_need_finish_dun_id2,about = <<"需要完整通关前一难度副本"/utf8>>};

get(6100095) ->
	#errorcode_msg{type = err610_not_exist_demon,about = <<"精怪不存在"/utf8>>};

get(6100096) ->
	#errorcode_msg{type = err610_dun_demon_low_dun,about = <<"精怪副本层数太低，不能扫荡"/utf8>>};

get(6100097) ->
	#errorcode_msg{type = err650_too_many_demon,about = <<"精怪太多"/utf8>>};

get(6100098) ->
	#errorcode_msg{type = err610_is_on_dungeon_not_to_setting,about = <<"在副本中无法设置"/utf8>>};

get(6100099) ->
	#errorcode_msg{type = err610_setting_count_error,about = <<"设置次数异常"/utf8>>};

get(6100100) ->
	#errorcode_msg{type = err610_setting_open_error,about = <<"设置是否开放异常"/utf8>>};

get(6100101) ->
	#errorcode_msg{type = err610_dungeon_count_error,about = <<"副本次数异常"/utf8>>};

get(6100102) ->
	#errorcode_msg{type = err610_merge_count_error,about = <<"合并次数异常"/utf8>>};

get(6100103) ->
	#errorcode_msg{type = err610_partner_max_score,about = <<"伙伴副本已达到三星"/utf8>>};

get(6100104) ->
	#errorcode_msg{type = err610_not_pass_rune,about = <<"尚未通关符文本"/utf8>>};

get(6100105) ->
	#errorcode_msg{type = err610_rune_dun_level_limit,about = <<"未达到相应解锁层级"/utf8>>};

get(6100106) ->
	#errorcode_msg{type = err610_not_pass_first_dup,about = <<"请先通过首关"/utf8>>};

get(6100107) ->
	#errorcode_msg{type = err610_not_pass_last_dup,about = <<"未通过上一关"/utf8>>};

get(6100108) ->
	#errorcode_msg{type = err610_limit_tower_round_over,about = <<"活动数据已更新"/utf8>>};

get(6100109) ->
	#errorcode_msg{type = err610_not_pass_all_dup,about = <<"未通过所有关卡"/utf8>>};

get(6100110) ->
	#errorcode_msg{type = err610_limit_tower_not_update,about = <<"活动数据未更新，请稍后再试"/utf8>>};

get(6100111) ->
	#errorcode_msg{type = err610_no_dun_gata_or_sweep,about = <<"尚未通关任何副本"/utf8>>};

get(6100112) ->
	#errorcode_msg{type = err610_no_active_weekly_card,about = <<"未激活周卡特权"/utf8>>};

get(6120001) ->
	#errorcode_msg{type = err612_time_out,about = <<"活动已结束"/utf8>>};

get(6120002) ->
	#errorcode_msg{type = err612_goods_null,about = <<"当前批次商品已售完，敬请期待下批！"/utf8>>};

get(6210001) ->
	#errorcode_msg{type = err621_in_kf_1vn,about = <<"正在王者之巅活动中"/utf8>>};

get(6210002) ->
	#errorcode_msg{type = err621_is_signed,about = <<"您已经报名"/utf8>>};

get(6210003) ->
	#errorcode_msg{type = err621_no_sign,about = <<"您没有报名"/utf8>>};

get(6210004) ->
	#errorcode_msg{type = err621_not_in_race_2,about = <<"您不在挑战赛名单上"/utf8>>};

get(6210005) ->
	#errorcode_msg{type = err621_has_betted,about = <<"您已经押过注"/utf8>>};

get(6210006) ->
	#errorcode_msg{type = err621_no_enter,about = <<"您没有进入活动中"/utf8>>};

get(6210007) ->
	#errorcode_msg{type = err621_no_bet_self,about = <<"不能押注自己"/utf8>>};

get(6210008) ->
	#errorcode_msg{type = err621_not_battle,about = <<"找不到本场战斗"/utf8>>};

get(6210009) ->
	#errorcode_msg{type = err621_battle_is_end,about = <<"战斗已经结束"/utf8>>};

get(6210010) ->
	#errorcode_msg{type = err621_not_bet_stage,about = <<"当前阶段不可竞猜"/utf8>>};

get(6210011) ->
	#errorcode_msg{type = err621_has_battle,about = <<"选手不可观战"/utf8>>};

get(6210012) ->
	#errorcode_msg{type = err621_watch_max_num,about = <<"已到达最大观战人数"/utf8>>};

get(6210013) ->
	#errorcode_msg{type = err621_goods_not_enough,about = <<"道具不足"/utf8>>};

get(6210014) ->
	#errorcode_msg{type = err621_turn_not_enough,about = <<"未达到相应轮次"/utf8>>};

get(6210015) ->
	#errorcode_msg{type = err621_not_kf_1vN_challenger,about = <<"您不是挑战者"/utf8>>};

get(6210016) ->
	#errorcode_msg{type = err621_not_match_yet,about = <<"暂未匹配到对手，请耐心等待"/utf8>>};

get(6210017) ->
	#errorcode_msg{type = err621_had_get_bet_reward,about = <<"已经领取"/utf8>>};

get(6210018) ->
	#errorcode_msg{type = err621_not_result_to_get_bet_reward,about = <<"还没有结果无法领取"/utf8>>};

get(6210019) ->
	#errorcode_msg{type = err621_bet_turn_error,about = <<"竞猜轮数异常"/utf8>>};

get(6210020) ->
	#errorcode_msg{type = err621_had_bet_this_battle,about = <<"已经竞猜过本次战斗"/utf8>>};

get(6210021) ->
	#errorcode_msg{type = err621_max_bet_count,about = <<"已经达到最大竞猜数"/utf8>>};

get(6210022) ->
	#errorcode_msg{type = err621_no_battle,about = <<"战斗不存在"/utf8>>};

get(6210023) ->
	#errorcode_msg{type = err621_bet_opt_error,about = <<"押注选项不存在"/utf8>>};

get(6220001) ->
	#errorcode_msg{type = err622_not_be_suit,about = <<"该装备无法形成共鸣"/utf8>>};

get(6220002) ->
	#errorcode_msg{type = err622_bag_not_enough,about = <<"神祭背包不足"/utf8>>};

get(6400000) ->
	#errorcode_msg{type = err640_goods_not_on_sale,about = <<"商品不在架上"/utf8>>};

get(6470001) ->
	#errorcode_msg{type = err647_lv_not_enough,about = <<"结社等级不足"/utf8>>};

get(6470002) ->
	#errorcode_msg{type = err647_not_has_guild,about = <<"你没有参加任何结社"/utf8>>};

get(6470003) ->
	#errorcode_msg{type = err647_activity_not_open,about = <<"结社试炼活动还没开始"/utf8>>};

get(6470004) ->
	#errorcode_msg{type = err647_not_in_safe_area,about = <<"主城和安全区才可以前往活动"/utf8>>};

get(6470005) ->
	#errorcode_msg{type = err647_not_in_guild_war,about = <<"不在结社试炼中"/utf8>>};

get(6470006) ->
	#errorcode_msg{type = err647_in_guild_war,about = <<"已在活动中"/utf8>>};

get(6470007) ->
	#errorcode_msg{type = err647_forbid_enter_again,about = <<"活动期间不能以新结社再次进入"/utf8>>};

get(6470008) ->
	#errorcode_msg{type = err647_self_guild_is_over,about = <<"您结社的试炼活动已经结束"/utf8>>};

get(6500001) ->
	#errorcode_msg{type = err650_kf_3v3_in_kill_scene,about = <<"杀戮战场不能进入3v3"/utf8>>};

get(6500002) ->
	#errorcode_msg{type = err650_kf_3v3_not_conn,about = <<"连接不上跨服中心"/utf8>>};

get(6500003) ->
	#errorcode_msg{type = err650_kf_3v3_lack_wincount,about = <<"未达领取条件"/utf8>>};

get(6500004) ->
	#errorcode_msg{type = err650_kf_3v3_lack_reward,about = <<"无奖励可领取"/utf8>>};

get(6500005) ->
	#errorcode_msg{type = err650_kf_3v3_is_packed,about = <<"已领取奖励"/utf8>>};

get(6500006) ->
	#errorcode_msg{type = err650_kf_3v3_kick_self,about = <<"不能踢出自己"/utf8>>};

get(6500007) ->
	#errorcode_msg{type = err650_kf_3v3_long_pasm,about = <<"密码长度超长"/utf8>>};

get(6500008) ->
	#errorcode_msg{type = err650_kf_3v3_come_to_end,about = <<"活动即将结束不可进入战斗"/utf8>>};

get(6500009) ->
	#errorcode_msg{type = err650_kf_3v3_watting,about = <<"等待回复"/utf8>>};

get(6500010) ->
	#errorcode_msg{type = err650_kf_3v3_not_start,about = <<"活动还未开始"/utf8>>};

get(6500011) ->
	#errorcode_msg{type = err650_kf_3v3_delete_team,about = <<"删除单个队伍"/utf8>>};

get(6500012) ->
	#errorcode_msg{type = err650_kf_3v3_update_team,about = <<"刷新单个队伍"/utf8>>};

get(6500013) ->
	#errorcode_msg{type = err650_kf_3v3_update_teamlist,about = <<"刷新队列"/utf8>>};

get(6500014) ->
	#errorcode_msg{type = err650_kf_3v3_low_power,about = <<"战力不足"/utf8>>};

get(6500015) ->
	#errorcode_msg{type = err650_kf_3v3_low_lv,about = <<"等级不足"/utf8>>};

get(6500016) ->
	#errorcode_msg{type = err650_kf_3v3_wrong_pswd,about = <<"密码不对"/utf8>>};

get(6500017) ->
	#errorcode_msg{type = err650_kf_3v3_no_member,about = <<"该玩家不在队伍中"/utf8>>};

get(6500018) ->
	#errorcode_msg{type = err650_kf_3v3_war_end,about = <<"战争已结束"/utf8>>};

get(6500019) ->
	#errorcode_msg{type = err650_kf_3v3_not_joined,about = <<"未加入队伍"/utf8>>};

get(6500020) ->
	#errorcode_msg{type = err650_kf_3v3_cannot_reset_ready,about = <<"队长不能取消准备"/utf8>>};

get(6500021) ->
	#errorcode_msg{type = err650_kf_3v3_not_ready,about = <<"有玩家未准备好"/utf8>>};

get(6500022) ->
	#errorcode_msg{type = err650_kf_3v3_matching,about = <<"正在匹配"/utf8>>};

get(6500023) ->
	#errorcode_msg{type = err650_kf_3v3_lack_member,about = <<"人数不足，无法开始"/utf8>>};

get(6500024) ->
	#errorcode_msg{type = err650_kf_3v3_fighting,about = <<"战斗中，不能取消"/utf8>>};

get(6500025) ->
	#errorcode_msg{type = err650_kf_3v3_not_captain,about = <<"不是队长，没有权限开始匹配"/utf8>>};

get(6500026) ->
	#errorcode_msg{type = err650_kf_3v3_no_team,about = <<"队伍已解散"/utf8>>};

get(6500027) ->
	#errorcode_msg{type = err650_kf_3v3_full_member,about = <<"队伍已满员"/utf8>>};

get(6500028) ->
	#errorcode_msg{type = err650_kf_3v3_in_team,about = <<"已有队伍"/utf8>>};

get(6500029) ->
	#errorcode_msg{type = err650_in_kf_3v3_act,about = <<"正在进行3v3匹配中，当前无法进入"/utf8>>};

get(6500030) ->
	#errorcode_msg{type = err650_kf_3v3_lack_count,about = <<"战队成员次数不足"/utf8>>};

get(6500031) ->
	#errorcode_msg{type = err650_tier_not_enough,about = <<"3v3段位不足，无法兑换"/utf8>>};

get(6500032) ->
	#errorcode_msg{type = err650_hornor_limit,about = <<"声望不足，参加3V3可以获得更多声望哦"/utf8>>};

get(6500033) ->
	#errorcode_msg{type = err650_fame_yet_get,about = <<"声望奖励已经领取"/utf8>>};

get(6500034) ->
	#errorcode_msg{type = err650_kf_3v3_match_limt,about = <<"匹配次数达到上限"/utf8>>};

get(6500035) ->
	#errorcode_msg{type = err650_err_name,about = <<"战队名字不合法"/utf8>>};

get(6500037) ->
	#errorcode_msg{type = err650_team_max_member,about = <<"战队满人"/utf8>>};

get(6500038) ->
	#errorcode_msg{type = err650_have_team,about = <<"已经拥有战队"/utf8>>};

get(6500039) ->
	#errorcode_msg{type = err650_err_team_id,about = <<"该战队已解散"/utf8>>};

get(6500040) ->
	#errorcode_msg{type = err650_err_role_id,about = <<"玩家id错误"/utf8>>};

get(6500041) ->
	#errorcode_msg{type = err650_not_leader,about = <<"只有战队的队长才能开启匹配哦"/utf8>>};

get(6500042) ->
	#errorcode_msg{type = err650_can_not_kick_leader,about = <<"不能踢队长"/utf8>>};

get(6500043) ->
	#errorcode_msg{type = err650_role_off_line,about = <<"玩家不在线"/utf8>>};

get(6500044) ->
	#errorcode_msg{type = err650_not_have_team,about = <<"请先加入一支战队"/utf8>>};

get(6500045) ->
	#errorcode_msg{type = err650_voto_repeat,about = <<"重复投票"/utf8>>};

get(6500046) ->
	#errorcode_msg{type = err286_vote_over_time,about = <<"投票已经结束"/utf8>>};

get(6500047) ->
	#errorcode_msg{type = err650_vote_over_time,about = <<"投票超时"/utf8>>};

get(6500048) ->
	#errorcode_msg{type = err650_team_in_match,about = <<"队伍已经在匹配中"/utf8>>};

get(6500049) ->
	#errorcode_msg{type = err650_team_not_matching,about = <<"队伍不在匹配中"/utf8>>};

get(6500050) ->
	#errorcode_msg{type = err650_can_not_vote,about = <<"此时不能发起投票"/utf8>>};

get(6500051) ->
	#errorcode_msg{type = err650_team_err_length,about = <<"战队名称最多5个字"/utf8>>};

get(6500052) ->
	#errorcode_msg{type = err650_can_not_handle_in_act,about = <<"活动期间不能进行此操作"/utf8>>};

get(6500053) ->
	#errorcode_msg{type = err650_champion_pk_close,about = <<"冠军赛未开启"/utf8>>};

get(6500054) ->
	#errorcode_msg{type = err650_not_in_champion_scene,about = <<"不在冠军赛场景"/utf8>>};

get(6500055) ->
	#errorcode_msg{type = err650_have_guess_in_one_turn,about = <<"本轮已经参加过竞猜"/utf8>>};

get(6500056) ->
	#errorcode_msg{type = err650_not_guess_opt,about = <<"没有这个选项"/utf8>>};

get(6500057) ->
	#errorcode_msg{type = err650_err_guess_turn,about = <<"竞猜轮次错误"/utf8>>};

get(6500058) ->
	#errorcode_msg{type = err650_guess_cost_type_err,about = <<"竞猜押注类型错误"/utf8>>};

get(6500059) ->
	#errorcode_msg{type = err650_guess_cost_num_err,about = <<"竞猜押注数量错误"/utf8>>};

get(6500060) ->
	#errorcode_msg{type = err650_not_guess_stage,about = <<"当前阶段无法竞猜"/utf8>>};

get(6500061) ->
	#errorcode_msg{type = err650_not_have_guess_record,about = <<"没有这条竞猜记录"/utf8>>};

get(6500062) ->
	#errorcode_msg{type = err650_can_not_get_guess_reward,about = <<"不能领取该竞猜奖励"/utf8>>};

get(6500063) ->
	#errorcode_msg{type = err650_have_got_guess_reward,about = <<"已经领取竞猜奖励"/utf8>>};

get(6500064) ->
	#errorcode_msg{type = err650_have_teammate_offline,about = <<"队友必须都在线"/utf8>>};

get(6500065) ->
	#errorcode_msg{type = err650_no_in_pk,about = <<"队伍不在战队中"/utf8>>};

get(6500066) ->
	#errorcode_msg{type = err650_yet_in_3v3_scene,about = <<"已经在3v3场景中"/utf8>>};

get(6500067) ->
	#errorcode_msg{type = err650_not_in_3v3_scene,about = <<"不在3v3场景内"/utf8>>};

get(6500068) ->
	#errorcode_msg{type = err650_not_16_team,about = <<"不是16强队伍"/utf8>>};

get(6500069) ->
	#errorcode_msg{type = err650_can_not_cut,about = <<"现在到冠军赛期间不能进行战队减员"/utf8>>};

get(6500070) ->
	#errorcode_msg{type = err650_in_pk,about = <<"战队处于pk中或者匹配中"/utf8>>};

get(6500071) ->
	#errorcode_msg{type = err650_chanpion_can_not_change_team,about = <<"冠军赛期间不能进行队员变更"/utf8>>};

get(6500072) ->
	#errorcode_msg{type = err650_in_kf_3v3_act_single,about = <<"正在进行3v3匹配单人匹配中，当前无法进入"/utf8>>};

get(6510001) ->
	#errorcode_msg{type = err651_not_enough_count,about = <<"进入次数不足"/utf8>>};

get(6510002) ->
	#errorcode_msg{type = err651_in_scene,about = <<"已经在场景中"/utf8>>};

get(6510003) ->
	#errorcode_msg{type = err651_not_in_scene,about = <<"不在神祭大妖场景中"/utf8>>};

get(6510004) ->
	#errorcode_msg{type = err651_err_buy_count,about = <<"购买次数错误"/utf8>>};

get(6510005) ->
	#errorcode_msg{type = err651_not_change_scene_on_dragon_boss,about = <<"在神祭大妖中"/utf8>>};

get(6510006) ->
	#errorcode_msg{type = err651_add_time,about = <<"添加神祭大妖时间"/utf8>>};

get(6510007) ->
	#errorcode_msg{type = err651_zone_change_can_not_add_time,about = <<"分区中，延时无效，请注意查收邮件"/utf8>>};

get(6510008) ->
	#errorcode_msg{type = err651_zone_change_time_can_not_join,about = <<"玩法维护中，请稍后再试"/utf8>>};

get(6520001) ->
	#errorcode_msg{type = err652_lv_not_enough,about = <<"160级可参与"/utf8>>};

get(6520002) ->
	#errorcode_msg{type = err652_time_out_of_rang,about = <<"当前时间不在开放范围内"/utf8>>};

get(6520003) ->
	#errorcode_msg{type = err652_open_day_limit,about = <<"不在开放时间范围内"/utf8>>};

get(6520004) ->
	#errorcode_msg{type = err652_error_cfg,about = <<"配置出错！"/utf8>>};

get(6520005) ->
	#errorcode_msg{type = act_end,about = <<"活动已结束"/utf8>>};

get(6520006) ->
	#errorcode_msg{type = err652_dunid_wrong,about = <<"活动期间更换结社，不允许再次进入！"/utf8>>};

get(6530001) ->
	#errorcode_msg{type = err653_not_enough_score,about = <<"没有足够的积分"/utf8>>};

get(6530002) ->
	#errorcode_msg{type = err653_had_stage_reward,about = <<"已经领取该阶段奖励"/utf8>>};

get(6530003) ->
	#errorcode_msg{type = err653_not_find_robot,about = <<"没有找到对手"/utf8>>};

get(6530004) ->
	#errorcode_msg{type = err653_not_in_rank,about = <<"玩家未上榜"/utf8>>};

get(6530005) ->
	#errorcode_msg{type = err653_nobody_rank,about = <<"没有玩家上榜"/utf8>>};

get(6530006) ->
	#errorcode_msg{type = err653_cant_get_stage,about = <<"不可领取阶段奖励"/utf8>>};

get(6540001) ->
	#errorcode_msg{type = err654_strength_level_limit,about = <<"达到当前蜃核强化等级上限"/utf8>>};

get(6540002) ->
	#errorcode_msg{type = err654_pill_lv_limit,about = <<"蜃灵珠丹使用达到当前等级上限"/utf8>>};

get(6540003) ->
	#errorcode_msg{type = err654_has_equiped,about = <<"该装备已穿戴，无须重复穿戴！"/utf8>>};

get(6540004) ->
	#errorcode_msg{type = err654_wrong_data,about = <<"数据异常"/utf8>>};

get(18800001) ->
	#errorcode_msg{type = err188_not_kill_boss,about = <<"没有击杀大妖"/utf8>>};

get(18800002) ->
	#errorcode_msg{type = err188_not_bl,about = <<"不是击杀玩家"/utf8>>};

get(18800003) ->
	#errorcode_msg{type = err188_has_get_reward,about = <<"已获取奖励"/utf8>>};

get(24100001) ->
	#errorcode_msg{type = err241_in_beings_gate,about = <<"已在众生之门场景中"/utf8>>};

get(24100002) ->
	#errorcode_msg{type = err241_no_in_beings_gate,about = <<"不在众生之门场景中"/utf8>>};

get(24100003) ->
	#errorcode_msg{type = err241_no_portal_id,about = <<"该传送门已消失"/utf8>>};

get(_Id) ->
	[].

