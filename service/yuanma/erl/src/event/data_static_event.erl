%% ---------------------------------------------------------------------------
%% @doc 玩家事件管理器
%% @author hek
%% @since  2016-09-09
%% @deprecated 本模块管理玩家进程事件监听，移除，派发具体事件
%%
%% Note:
%% 每次都会触发的回调事件，不能进行移除操作
%% 添加暂时触发的事件，触发后可以移除
%% ---------------------------------------------------------------------------

-module (data_static_event).
-include ("def_event.hrl").
-export ([get_static_event/1]).

get_static_event(?EVENT_LV_UP) ->
    [
     {mod_chat_agent, handle_event, []}
    , {mod_scene_agent, handle_event, []}
    , {lib_common_rank_api, handle_event, []}
    , {lib_skill, handle_event, []}
    % , {lib_relationship_api, handle_event, []}
    , {lib_task_api, handle_event, []}
    , {lib_pushmail, handle_event, []}
    , {lib_guild_api, handle_event, []}
    % , {lib_team_api, handle_event, []}
    , {lib_role_api, handle_event, []}
    , {lib_mount, handle_event, []}
    , {lib_talisman, handle_event, []}
    , {lib_godweapon, handle_event, []}
    , {lib_equip, handle_event, []}
    , {lib_dungeon_api, handle_event, []}
    , {lib_rush_rank_api, handle_event, []}
    , {lib_module, handle_event, []}
    , {lib_limit_shop, handle_event, []}
    , {lib_overflow_gift, handle_event, []}
    , {lib_spec_sell_act, handle_event, []}
    , {lib_boss_api, handle_event, []}
    , {lib_treasure_hunt_data, handle_event, []}
    % , {lib_onhook, handle_event, []}
    , {lib_investment, handle_event, []}
    , {lib_custom_act_api, handle_event, []}
    , {lib_magic_circle, handle_event, []}
    , {lib_eudemons, handle_event, []}
    , {lib_feast_cost_rank, handle_event, []}
    , {lib_feast_cost_rank_clusters, handle_event, []}
    , {lib_goods_do, handle_event, []}
    , {lib_module_open, handle_event, []}
    , {lib_achievement_api, handle_event,[]}
    , {lib_online_statistics, handle_event, []}
    , {lib_chat, handle_event, []}
    , {lib_sanctuary, handle_event, []}
    , {lib_marriage, handle_event, []}
    , {lib_bonus_monday, handle_event, []}
    , {lib_level_act, handle_event, []}
    , {lib_demons, handle_event, []}
    , {lib_3v3_api, handle_event, []}
    , {lib_invite_api, handle_event, []}
    , {lib_level_mail, handle_event, []}
    , {lib_hi_point_api, handle_event, []}
    , {lib_seacraft, handle_event, []}
    , {lib_seacraft_extra_api, handle_event, []}
    , {lib_afk_api, handle_event, []}
    , {lib_eternal_valley_api, handle_event, []}
    , {lib_boss_first_blood_plus, handle_event, []}
    , {lib_temple_awaken_api, handle_event, []}
    , {lib_sea_treasure_api, handle_event, []}
    , {lib_push_gift_api, handle_event, []}
    , {lib_fiesta_api, handle_event, []}
    , {lib_combat_welfare, handle_event, []}
    , {lib_recharge_first, handle_event, []}
    , {lib_player_info_report, handle_event, []}
    , {lib_cycle_rank, handle_event, []}
    , {lib_custom_create_gift, handle_event, []}
    , {lib_dress_up, handle_event, []}
    ];

get_static_event(?EVENT_COMBAT_POWER) ->
    [
     {lib_common_rank_api, handle_event, []}
    % , {lib_relationship_api, handle_event, []}
    , {lib_player, handle_event, []}
    , {lib_guild_api, handle_event, []}
    , {lib_role_api, handle_event, []}
    , {lib_rush_rank_api, handle_event, []}
    , {lib_diamond_league, handle_event, []}
    , {lib_kf_1vN, handle_event, []}
    , {lib_achievement_api, handle_event,[]}
    , {lib_eternal_valley_api, handle_event, []}
    , {lib_3v3_api, handle_event, []}
    , {lib_seacraft, handle_event, []}
    , {lib_seacraft_extra_api, handle_event, []}
    , {lib_afk_api, handle_event, []}
    , {lib_up_power, handle_event, []}
    , {lib_sea_treasure_api, handle_event, []}
    , {lib_temple_awaken_api, handle_event, []}
    , {lib_player_info_report, handle_event, []}
    , {lib_combat_welfare, handle_event, []}
    ];

get_static_event(?EVENT_PICTURE_CHANGE) ->
    [
     % {lib_relationship_api, handle_event, []}
    {lib_guild_api, handle_event, []}
    , {lib_role_api, handle_event, []}
    , {lib_marriage, handle_event, []}
    , {lib_3v3_api, handle_event, []}
    , {lib_seacraft, handle_event, []}
    , {lib_kf_rank_dungeon, handle_event, []}
    ];

get_static_event(?EVENT_PLAYER_DIE) ->
    [
	    {lib_player, handle_event, []},
        {lib_dungeon_api, handle_event, []},
        {lib_3v3_api, handle_event, []}
        , {mod_scene_agent, handle_event, []}
        , {lib_nine_api, handle_event, []}
        , {lib_guild_dun, handle_event, []}
        , {lib_boss_api, handle_event, []}
        , {lib_revive_auto, handle_event, []}
        , {lib_pk_log, handle_event, []}
        , {lib_sanctuary, handle_event, []}
        , {lib_kf_sanctum, handle_event, []}
        , {lib_achievement_api, handle_event, []}
        , {lib_god_summon, handle_event, []}
        , {lib_decoration_boss_api, handle_event, []}
        , {lib_territory_war, handle_event, []}
        , {lib_dragon_language_boss, handle_event, []}
        , {lib_guild_feast, handle_event, []}
        , {lib_holy_spirit_battlefield, handle_event, []}
        , {lib_seacraft_daily,handle_event, [] }
        , {lib_fake_client_api, handle_event, []}
	    , {lib_push_gift_api, handle_event, []}
	    , {lib_sanctuary_cluster_api, handle_event, []}
        , {lib_player_behavior_api, handle_event, []}
    ];

get_static_event(?EVENT_GUILD_QUIT) ->
    [
     {lib_guild_api, handle_event, []}
    , {lib_designation_api, handle_event, []}
    , {lib_sanctuary, handle_event, []}
    ];

get_static_event(?EVENT_GUILD_DISBAND) ->
    [
     {lib_guild_api, handle_event, []}
    , {lib_designation_api, handle_event, []}
    , {lib_sanctuary, handle_event, []}
    ];

get_static_event(?EVENT_USE_BUFF_GOODS) ->
    [
        {lib_afk_api, handle_event, []}
    ];

get_static_event(?EVENT_PUSHMAIL_ARRIVE_TIME) ->
    [
     {lib_pushmail, handle_event, []}
    ];

%% Data:#{dun_id=DunId, dun_type=DunType, help_type=HelpType}
get_static_event(?EVENT_DUNGEON_ENTER) ->
    [
        {lib_hi_point_api, handle_event, []}
        ,{lib_contract_challenge_api, handle_event, []}
        ,{lib_player, handle_event, []}
        ,{lib_eternal_valley_api, handle_event, []}
        ,{lib_companion_api, handle_event, []}
        ,{lib_temple_awaken_api, handle_event, []}
        ,{lib_fiesta_api, handle_event, []}
        ,{lib_grow_welfare_api, handle_event, []}
    ];

get_static_event(?EVENT_DUNGEON_SUCCESS) ->
    [
     {lib_pushmail, handle_event, []}
    , {lib_dungeon_api, handle_event, []}
    , {lib_baby_api, handle_event, []}
    , {lib_kf_rank_dungeon, handle_event, []}
    , {lib_week_dungeon, handle_event, []}
    , {lib_hi_point_api, handle_event, []}
    , {lib_guild_assist, handle_event, []}
    , {lib_eternal_valley_api, handle_event, []}
    , {lib_companion_api, handle_event, []}
    , {lib_push_gift_api, handle_event, []}     %% 要放在 lib_dungeon_api 后面
    , {lib_temple_awaken_api, handle_event, []}
    , {lib_demons_api, handle_event, []}
    , {lib_fiesta_api, handle_event, []}
    , {lib_dungeon_rune, handle_event, []}
    , {lib_grow_welfare_api, handle_event, []}
    , {lib_custom_act_api, handle_event, []}
    , {lib_dungeon_limit_tower, handle_event, []}
    , {lib_weekly_card_api, handle_event, []}
    ];

get_static_event(?EVENT_DUNGEON_FAIL) ->
    [
        {lib_kf_rank_dungeon, handle_event, []}
        , {lib_week_dungeon, handle_event, []}
        , {lib_guild_assist, handle_event, []}
        , {lib_companion_api, handle_event, []}
    ];

get_static_event(?EVENT_PUSHMAIL_OPEN_DAY) ->
    [
     {lib_pushmail, handle_event, []}
    ];

%% 充值后会执行的操作  TODO:VIP临时改下
get_static_event(?EVENT_RECHARGE) ->
    [
     {lib_recharge_return, handle_event, []}
    , {lib_recharge_act, handle_event, []}
    , {lib_role_api, handle_event, []}
    , {lib_daily_gift, handle_event, []}
    , {lib_red_envelopes, handle_event, []}
    , {lib_recharge_cumulation, handle_event, []}
    , {lib_rush_rank_api, handle_event, []}  %%开服冲榜
    % , {lib_invite_api, handle_event, []}
    , {lib_achievement_api, handle_event, []}
    , {lib_bonus_monday, handle_event, []}
    , {lib_custom_act_api, handle_event, []}
    , {lib_supreme_vip_api, handle_event, []}
    , {lib_beta_recharge_return, handle_event, []}
    , {lib_activation_draw, handle_event, []}
    , {lib_red_envelopes_rain, handle_event, []}
    , {lib_guild_daily, handle_event, []}
    , {lib_hi_point_api, handle_event, []}
    , {lib_contract_challenge_api, handle_event, []}
    , {lib_local_chrono_rift_act, handle_event, []}
    , {lib_surprise_gift, handle_event, []}
    , {lib_en_zero_gift, handle_event, []}
    , {lib_demons_api, handle_event, []}
	, {lib_push_gift_api, handle_event, []}
	, {lib_vip_api, handle_event, []}
    , {lib_fiesta_api, handle_event, []}
     ,{lib_custom_daily_direct_buy, handle_event, []}
    ,{lib_investment, handle_event, []}
    ,{lib_level_act, handle_event, []}
    , {lib_destiny_turntable, handle_event, []}
    ,{lib_weekly_card_api, handle_event, []}
    , {lib_custom_act_recharge_polite, handle_event, []}
    ,{lib_custom_cycle_rank, handle_event, []}
    ,{lib_custom_cycle_rank_recharge, handle_event, []}
    , {lib_fairy_buy, handle_event, []}
    , {lib_english_super_vip, handle_event, []}
    , {lib_figure_buy_act, handle_event, []}
    , {lib_dragon_ball, handle_event, []}
    , {lib_hero_halo, handle_event, []}
    ];

%% data:OnlineFlag
%% 该事件修改PS无效
get_static_event(?EVENT_ONLINE_FLAG) ->
    [
        {lib_guild_api, handle_event, []}
        , {lib_relationship_api, handle_event, []}
        , {lib_role_api, handle_event, []}
        , {lib_watchdog_api, handle_event, []}
        , {lib_fairy_buy, handle_event, []}
    ];

get_static_event(?EVENT_VIP) ->
    [
     % {lib_relationship_api, handle_event, []}
    {lib_role_api, handle_event, []}
    , {lib_red_envelopes, handle_event, []}
    , {lib_eternal_valley_api, handle_event, []}
	, {lib_resource_back, handle_event, []}
    % , {lib_onhook, handle_event, []}
    , {lib_level_act, handle_event, []}
    , {lib_checkin, handle_event,[]}
    , {lib_goods_do, handle_event,[]}
    , {lib_seacraft_extra_api, handle_event, []}
    , {lib_push_gift_api, handle_event, []}
    , {lib_boss_api, handle_event, []}
    , {lib_recharge, handle_event, []}
    ];

get_static_event(?EVENT_SUPVIP) ->
    [
        {lib_role_api, handle_event, []}
        , {lib_guild_api, handle_event, []}
    ];

get_static_event(?EVENT_VIP_TIME_OUT) ->
    [
     {lib_equip, handle_event, []}
	 , {lib_resource_back, handle_event, []}
    ];

get_static_event(?EVENT_BUY_VIP) ->
    [
        {lib_resource_back, handle_event, []}
    ];

get_static_event(?EVENT_REVIVE) ->
    [
     {lib_dungeon_api, handle_event, []}
     , {lib_nine_api, handle_event, []}
    % , {lib_guild_battle_api, handle_event, []}
    , {lib_territory_war, handle_event, []}
     , {lib_decoration_boss_api, handle_event, []}
     , {lib_dragon_language_boss, handle_event, []}
     , {lib_guild_feast, handle_event, []}
     , {lib_holy_spirit_battlefield, handle_event, []}
     , {lib_fake_client_api, handle_event, []}
     , {lib_player_behavior_api, handle_event, []}
    ];

get_static_event(?EVENT_ADD_FRIEND) ->
    [
     {lib_guild_api, handle_event, []}
    ];

get_static_event(?EVENT_PARTICIPATE_ACT) ->
    [
     {lib_resource_back, handle_event, []}
     ,{lib_liveness, handle_event, []}
    ];

get_static_event(?EVENT_FIN_CHANGE_SCENE) ->
    [
        {lib_dungeon_api, handle_event, []}
        , {lib_territory_war, handle_event, []}
        , {lib_team_api, handle_event, []}
        % , {lib_guild_battle_api, handle_event, []}
    ];

get_static_event(?EVENT_GIVE_GOODS) ->
    [
     {lib_goods_do, handle_event, []}
    ];

get_static_event(?EVENT_GIVE_GOODS_LIST) ->
    [
     {lib_goods_do, handle_event, []}
    ];

get_static_event(?EVENT_ADD_LIVENESS) ->
    [
     {lib_guild_api, handle_event, []}
     ,  {lib_checkin, handle_event,[]}
     ,{lib_bonus_monday, handle_event, []}
     ,{lib_treasure_hunt_data, handle_event, []}
     ,{lib_activation_draw, handle_event, []}
     ,{lib_guild_daily, handle_event, []}
     ,{lib_fiesta_api, handle_event, []}
    ];

get_static_event(?EVENT_RENAME) ->
    [
     %{lib_common_rank_api, handle_event, []}
     % {lib_relationship_api, handle_event, []}
    {lib_guild_api, handle_event, []}
%%     , {lib_online_api, handle_event, []}
    % , {lib_team_api, handle_event, []}
    , {lib_role_api, handle_event, []}
    , {lib_marriage, handle_event, []}
    , {lib_offline_api, handle_event, []}
    , {lib_house, handle_event, []}
    , {lib_kf_rank_dungeon, handle_event, []}
    , {lib_3v3_api, handle_event, []}
    , {lib_seacraft, handle_event, []}
    , {lib_seacraft_extra_api, handle_event, []}
    , {lib_sea_treasure_api, handle_event, []}
    , {lib_cycle_rank, handle_event, []}
    , {lib_flower_act_api, handle_event, []}
    ];

get_static_event(?EVENT_EQUIP_MASK) ->
    [
    {lib_race_act_api, handle_event, []}
    ];

%% 穿戴装备
%% #event_callback.data :: #goods{}
get_static_event(?EVENT_EQUIP) ->
    [
     %%{lib_equip, handle_event, []}
    ];

get_static_event(?EVENT_UNEQUIP) ->
    [
     %%{lib_equip, handle_event, []}
    ];

%% 拾取掉落
%% #event_callback.data :: object_list
%% object_list          :: [{object_type, goods_id, goods_num}]
get_static_event(?EVENT_DROP_CHOOSE) ->
    [
     {lib_dungeon_api, handle_event, []}
     ,{lib_boss_api, handle_event, []}
     ,{lib_eudemons_land, handle_event, []}
     ,{lib_week_dungeon, handle_event, []}
     ,{lib_dragon_language_boss, handle_event, []}
     ,{lib_great_demon_api, handle_event, []}
    ];

%% 物品掉落
get_static_event(?EVENT_GOODS_DROP) ->
    [
         {lib_boss_api, handle_event, []},
         {lib_eudemons_land, handle_event, []}
    ];

get_static_event(?EVENT_AUCTION_SUCCESS) ->
    [
    ];

%% 交易行出售成功
%% #event_callback.data :: money
%% money                :: integer()
get_static_event(?EVENT_SELL_SUCCESS) ->
    [
    ];

%% 加入公会
get_static_event(?EVENT_JOIN_GUILD) ->
    [
     {lib_achievement_api, handle_event, [{handle_offline, 1}]}
     ,{lib_sanctuary, handle_event, []}
     ,{lib_eternal_valley_api, handle_event, []}
     ,{lib_grow_welfare_api, handle_event, []}
    ];

get_static_event(?EVENT_CREATE_GUILD) ->
    [
        {lib_grow_welfare_api, handle_event, []}
    ];

get_static_event(?EVENT_INTIMACY_LV) ->
    [
    ];

%% 公会捐献
get_static_event(?EVENT_GUILD_DONATE) ->
    [
     {lib_task_api, handle_event, []}
    ];

%% 发送公会邀请
% get_static_event(?EVENT_SEND_GUILD_INVITE) ->
%     [
%      {lib_dungeon_api, handle_event, []}
%     ];

%% 登录事件延后
get_static_event(?EVENT_LOGIN_CAST) ->
    [
     {lib_login, handle_event, []},
     {lib_equip, handle_event, []},
%%     {lib_vip_api, handle_event, []},  %TODO:VIP临时改下
     {lib_dungeon_api, handle_event, []},
     {lib_limit_shop, handle_event, []}
     %% {lib_come_back, handle_event, []},
     ,{lib_investment, handle_event, []}
     , {lib_3v3_api, handle_event, []}
     ,{lib_to_be_strong, handle_event, []}
     ,{lib_online_statistics, handle_event, []}
     ,{lib_bonus_monday, handle_event, []}
     ,{lib_festival_investment, handle_event, []}
     ,{lib_reincarnation, handle_event, []}
     ,{lib_arcana_api, handle_event, []}
     ,{lib_companion_api, handle_event, []}
     ,{lib_temple_awaken_api, handle_event, []}
     ,{lib_task_api, handle_event, []}
     ,{lib_achievement_api, handle_event, []}
     ,{lib_fiesta_api, handle_event, []}
     ,{lib_grow_welfare_api, handle_event, []}
     ,{lib_custom_act_api, handle_event, []}
     ,{lib_guild_assist, handle_event, []}
     ,{lib_delay_reward, handle_event, []}
     ,{lib_common_rank_api, handle_event, []}
     ,{lib_custom_act_sys_mail, handle_event, []}
    ];

%% 私聊
get_static_event(?EVENT_CHAT_PRIVATE) ->
    [
     {lib_relationship_api, handle_event, []}
    ];

%% 消耗金钱后执行事件
get_static_event(?EVENT_MONEY_CONSUME) ->
    [
     {lib_vip_api, handle_event, []}
     , {lib_custom_act_api, handle_event, []}
     , {lib_feast_cost_rank, handle_event, []}
     , {lib_feast_cost_rank_clusters, handle_event, []}
     , {lib_supreme_vip_api, handle_event, []}
     , {lib_hi_point_api, handle_event, []}
     , {lib_contract_challenge_api, handle_event, []}
     , {lib_local_chrono_rift_act, handle_event, []}
     , {lib_destiny_turntable, handle_event, []}
     , {lib_demons_api, handle_event, []}
     , {lib_fiesta_api, handle_event, []}
    ];

%% 特殊货币消耗
get_static_event(?EVENT_MONEY_CONSUME_CURRENCY) ->
    [
     {lib_push_gift_api, handle_event, []}
    ];

%% 转生成功
get_static_event(?EVENT_TURN_UP) ->
    [
        {lib_guild_api, handle_event, []}
        , {lib_role_api, handle_event, []}
        , {lib_player, handle_event, []}
        , {lib_supreme_vip_api, handle_event, []}
        , {lib_arcana_api, handle_event, []}
        , {lib_push_gift_api, handle_event, []}
        , {lib_temple_awaken_api, handle_event, []}
        , {lib_kf_rank_dungeon, handle_event, []}
        , {lib_fiesta_api, handle_event, []}
        , {lib_grow_welfare_api, handle_event, []}
        , {lib_module_open, handle_event, []}
    ];

%% 确定本账号下首个角色
get_static_event(?EVENT_ENSURE_ACC_FIRST) ->
    [
        {lib_custom_act_api, handle_event, []}
    ];

%% 客户端断开连接
get_static_event(?EVENT_DISCONNECT) ->
    [
        {lib_team_api, handle_event, []}
        , {lib_role_drum, handle_event, []}
        , {lib_3v3_api, handle_event, []}
        , {lib_boss_rotary, handle_event, []}
        , {lib_rush_rank_api, handle_event, []}
    ];

%% 客户端断开连接
get_static_event(?EVENT_DISCONNECT_HOLD_END) ->
    [
        {lib_team_api, handle_event, []}
        ,{lib_3v3_api, handle_event, []}
        ,{lib_rush_rank_api, handle_event, []}
    ];

%% 转职成功
get_static_event(?EVENT_TRANSFER) ->
    [
        {lib_guild_api, handle_event, []}
        , {lib_role_api, handle_event, []}
        , {lib_common_rank_api, handle_event, []}
        , {lib_flower_act_api, handle_event, []}
    ];

get_static_event(?EVENT_PREPARE_CHANGE_SCENE) ->
    [
        {lib_player, handle_event, []},
        {lib_god_summon, handle_event, []}
    ];

get_static_event(?EVENT_MOUNT_LVUP) ->
    [
        {lib_liveness, handle_event, []}
    ];
get_static_event(?EVENT_FLY_LVUP) ->
    [
        {lib_liveness, handle_event, []}
    ];

get_static_event(?EVENT_OTHERS_DROP) ->
[
    {lib_boss_api, handle_event, []},
    {lib_dungeon_api, handle_event, []}
];

get_static_event(?EVENT_TASK_DROP) ->
[
    {lib_boss_api, handle_event, []}
];

get_static_event(?EVENT_SEND_FLOWER) ->
[
    {lib_marriage, handle_event, []}
];

get_static_event(?EVENT_REFRESH_BUFF) ->
    [
        {lib_afk_api, handle_event, []}
    ];

get_static_event(?EVENT_FAKE_CLIENT) ->
    [
        {lib_task_api, handle_event, []}
    ];

get_static_event(?EVENT_BOSS_KILL) ->
    [
        {lib_fiesta_api, handle_event, []},
        {lib_eudemons_land, handle_event, []}
        , {lib_grow_welfare_api, handle_event, []}
        , {lib_custom_act_api, handle_event, []}
        , {lib_weekly_card_api, handle_event, []}
    ];

get_static_event(?EVENT_EQUIP_COMPOSE) ->
    [
        {lib_fiesta_api, handle_event, []}
        , {lib_grow_welfare_api, handle_event, []}
    ];

get_static_event(?EVENT_BOSS_DUNGEON_ENTER) ->
    [
        {lib_fiesta_api, handle_event, []}
    ];

get_static_event(?EVENT_JOIN_ACT) ->
    [
        {lib_fiesta_api, handle_event, []}
        , {lib_grow_welfare_api, handle_event, []}
    ];

get_static_event(?EVENT_DUNGEON_SWEEP) -> % 目前只有契灵副本(新伙伴)扫荡事件
    [
        {lib_fiesta_api, handle_event, []}
    ];

get_static_event(_Event) ->
    [].
