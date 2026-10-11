%%%-----------------------------------
%%% @Module  : gsrv_server_base
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.12.08
%%% @Description: 游戏启动服务
%%%-----------------------------------
-module(gsrv_server_base).
-export([start/1, stop/0]).
-compile(export_all).
-include("record.hrl").
-include("common.hrl").
-include("watchdog.hrl").
-include("def_id_create.hrl").
-include("def_id_create_extra.hrl").

%% Line 线路(10,11...)
start(Line) ->
    NowTime = utime:unixtime(),
    inets:start(),
    ok = start_normal_processes(init_modules_func_bf_word()),
    mod_word:init(), %% 过滤词
    ok = start_create_mon(Line),
    ok = start_normal_processes(init_modules_func()),
    ok = lib_game:log_server_open(?SERVER_STATUS_STARTED, ?NODE_GAME, NowTime),
    lib_watchdog_api:add_monitor(?WATCHDOD_SERVER_STATUS, ?SERVER_STATUS_STARTED),
    ok.

%% 关闭服务器时需停止
stop() ->
    NowTime = utime:unixtime(),
    mod_ban:ban_all(),
    mod_login:server_stop_all(),
    mod_act_join:stop(),
    %mod_guild_boss:stop(),
    % log_server_open 位于mod_log:stop/1前
    lib_game:log_server_open(?SERVER_STATUS_CLOSE, ?NODE_GAME, NowTime),
    mod_mail_queue:stop(),
    mod_log:stop(),
    ?ERR("server close!", []),
    init:stop(),
    ok.

start_normal_processes([{Mod, _, _} = H | T]) ->
    {ok, _} = supervisor:start_child(gsrv_sup, {H, H, permanent, 10000, worker, [Mod]}),
    start_normal_processes(T);
start_normal_processes([_H | T]) ->
    ?PRINT("[Error]:init_modules_func bad format: ~p~n", [_H]),
    start_normal_processes(T);
start_normal_processes([]) -> ok.

init_modules_func_bf_word() ->
    [
        {mod_http_server, start_link, []}
    ].

init_modules_func() ->
    [
        {mod_watchdog, start_link, []}          %% 看门狗服务
        , {mod_game_error, start_link, []}
        , {mod_clusters_node, start_link, []}     %% 跨服客户端
        , {mod_mail_queue, start_link, []}      %% 邮件发送队列进程, 需要放在mod_log后面
        , {mod_log, start_link, []}             %% 日志系统
        , {ta_agent, start_link, []}            %% TA数据上报agent进程
        , {mod_scene_mon, start_link, []}       %% 场景npc进程
        , {mod_scene_npc, start_link, []}       %% 场景npc进程
        , {mod_scene_init, start_link, []}      %% 场景进程
        , {mod_scene_line, start_link, []}      %% 场景线路
        , {timer_quest, start_link, []}         %% 动态定时器
        , {mod_cache, start_link, []}           %% key_value缓存服务
        , {mod_activitycalen, start_link, []}   %% 活动日历
        , {mod_act_join, start_link, []}        %% 活动参与记录服务
        , {mod_id_create, start_link, [?GOODS_ID_CREATE]}               %% 物品自增Id
        , {mod_id_create, start_link, [?GUILD_ID_CREATE]}               %% 公会自增Id
        , {mod_id_create, start_link, [?AUCTION_ID_CREATE]}             %% 拍卖场次id
        , {mod_id_create, start_link, [?AUCTION_GOODS_ID_CREATE]}       %% 拍卖物品id
        , {mod_id_create, start_link, [?MAIL_ID_CREATE]}                %% 邮件自增id
        , {mod_id_create, start_link, [?PARTNER_ID_CREATE]}             %% 伙伴自增id
        , {mod_id_create, start_link, [?SELL_ID_CREATE]}                %% 交易自增id
        , {mod_id_create, start_link, [?CHARGE_PAY_NO_CREATE]}          %% 充值订单号(只用于秘籍)
        , {mod_id_create, start_link, [?FLOWER_GIFT_RECORD_ID_CREATE]}  %% 鲜花送礼记录id
        , {mod_id_create, start_link, [?GUILD_DEPOT_GOODS_ID_CREATE]}   %% 公会仓库物品自增id
        , {mod_id_create, start_link, [?RED_ENVELOPES_ID_CREATE]}       %% 红包自增id
        , {mod_id_create, start_link, [?LOC_ID_CREATE]}                 %% 家具位置唯一id
        , {mod_id_create, start_link, [?WEDDING_ID_CREATE]}             %% 婚礼唯一id
        , {mod_id_create, start_link, [?CONSUME_RECORD_ID_CREATE]}      %% 婚礼唯一id
        , {mod_id_create, start_link, [?TEAM_3V3_ID_CREATE]}            %% 3v3战队唯一id
        , {mod_id_create, start_link, [?AUTHENTICATION_ID_CREATE]}      %% 拍卖认证id
        , {mod_id_create, start_link, [?GUILD_DAILY_ID_CREATE]}         %% 公会宝箱id
        , {mod_id_create, start_link, [?ASSIST_ID_CREATE]}              %% 协助id
        , {mod_id_create, start_link, [?SHIPPING_ID_CREATE]}            %% 巡航船只唯一id
        , {mod_chat_agent, start_link, []}       %% 聊天
        , {mod_role_show, start_link, []}        %% 玩家展示ets同步进程
        , {mod_chat_voice, start_link, []}       %% 语音和图片
        , {mod_chat_forbid, start, []}           %% 禁言
        , {mod_chat_cache, start_link, []}       %% 聊天缓存
        , {mod_chat_bugle, start_link, []}       %% 喇叭
        , {chat_monitor_agent, start_link, []}   %% 聊天监控
        , {mod_daily_dict, start_link, []}       %% 日常次数（缓存版）
        , {mod_ban, start_link, []}              %% 封号
        , {mod_online, start_link, []}           %% 在线统计(此进程必须在mod_chat_agent之后启动)
        , {mod_change_scene, start_link, []}     %% 排队进入场景
        , {mod_player_create, start_link, []}    %% 玩家id
        , {mod_team_create, start_link, []}      %% 组队id
        , {mod_team_enlist, start_link, []}      %% 组队招募平台
        , {mod_crontab, start_link, []}          %% cron服务进程
        , {timer_min, start_link, []}            %% 分钟定时器
        , {timer_hour, start_link, []}           %% 小时定时器
        , {timer_midnight, start_link, []}       %% 晚上十二点
        , {timer_4_clock, start_link, []}        %% 凌晨4点
        , {mod_custom_act, start_link, []}       %% 定制活动
        , {mod_drop, start_link, []}             %% 物品掉落
        , {timer_custom, start_link, []}         %% 活动定时器
        , {mod_global_counter, start_link, []}   %% 单服计数器

        , {mod_guild_prestige, start_link, []}   %% 公会声望(要放在公会前)
        , {mod_sell, start_link, []}             %% 交易
        , {mod_offline_player, start_link, []}   %% 离线玩家
        , {mod_common_rank, start_link, []}      %% 排行榜
        , {mod_guild, start_link, []}            %% 公会
        , {mod_dungeon_agent, start_link, []}    %% 副本管理
        , {mod_pushmail, start_link, []}         %% 邮件推送
        , {mod_jjc, start_link, []}              %% 竞技场
        , {mod_recharge_act, start_link, []}     %% 充值活动(每日礼包)
        , {mod_red_envelopes, start_link, []}    %% 公会红包
        , {mod_guild_feast_mgr, start_link, []}  %% 公会晚宴
        , {mod_boss, start_link, []}             %% 本服boss
        , {mod_special_boss, start_link, []}     %% 本服特殊boss
        , {mod_guild_boss, start_link, []}       %% 公会Boss
        , {mod_void_fam_local, start_link, []}   %% 虚空秘境
        , {mod_guild_guard, start_link, []}      %% 守卫公会
        , {mod_marriage, start_link, []}         %% 婚姻
        , {mod_marriage_wedding_mgr, start_link, []}   %% 婚姻婚礼
        , {mod_baby_mgr, start_link, []}   %% 婚姻婚礼
        , {mod_top_pk_match_room, start_link, []}      %% 巅峰竞技匹配
        , {mod_guild_battle, start_link, []}              %% 单服公会战
        , {mod_eudemons_land_local, start_link, []}    %% 幻兽之域本服
        , {mod_top_pk_rank, start_link, []}            %% 巅峰竞技排行榜
        , {mod_treasure_hunt, start_link, []}          %% 寻宝
        , {mod_treasure_chest, start_link, []}         %% 青云夺宝
        , {mod_flower_act_local, start_link, []}       %% 鲜花结婚榜活动
        , {mod_rush_rank, start_link, []}              %% 开服冲榜
        , {mod_kf_flower_act_local, start_link, []}    %% 跨服鲜花榜本服
        , {mod_limit_buy, start_link, []}              %% 特惠商城
        , {mod_smashed_egg, start_link, []}            %% 砸蛋
        , {mod_luckey_egg, start_link, []}            %% 惊喜砸蛋
        , {mod_act_boss, start_link, []}               %% 活动boss
        , {mod_guild_create_act, start_link, []}       %% 勇者联盟
        , {mod_perfect_lover, start_link, []}          %% 完美恋人
        , {mod_boss_first_blood, start_link, []}       %% boss首杀
        , {mod_hi_point, start_link, []}               %% 嗨点
        , {mod_custom_act_gwar, start_link, []}        %% 公会争霸运营活动
        , {mod_eudemons_attack, start_link, []}        %% 幻兽入侵
        , {mod_lucky_turntable, start_link, []}        %% 幸运转盘
        , {mod_cloud_buy_local, start_link, []}        %% 众仙云购本地
        , {mod_cloud_buy_mgr, start_link, []}          %% 众仙云购
        , {mod_collect, start_link, []}                 %% 收集任务
        , {lib_diamond_league, local_launch, []}        %% 星钻联赛
        , {mod_consume_rank_act, start_link, []}        %% 充值消费排行
        , {mod_login_return_reward, start_link, []}     %% 0元豪礼
%%        , {mod_3v3_local, start_link, []}               %% 3v3
        %, {mod_house, start_link, []}                  %% 家园
        , {mod_lucky_flop, start_link, []}              %% 幸运翻牌
        , {mod_guess, start_link, []}                   %% 竞猜
        , {mod_kf_1vN_local, start_link, []}            %% 跨服1vn
        %, {mod_saint_local, start_link, []}            %% 圣者殿本地
        , {mod_gift_card, start_link, []}               %% 礼包管理进程
        %, {mod_kf_guild_war_local, start_link, []}     %% 跨服公会战本地进程
        , {mod_daily_turntable, start_link, []}         %% 每日活跃转盘
        , {mod_enchantment_guard_rank_local,start_link, []}%% 结界守护排位进程
        , {mod_cycle_rank_local, start_link, []}        %% 循环冲榜
        , {mod_mystery_shop, start_link, []}            %% 神秘商城
        , {mod_nine_local, start_link, []}              %% 九魂圣殿
        , {mod_beings_gate_local, start_link, []}       %% 众生之门
        , {mod_guild_dun_mgr, start_link, []}           %% 公会副本
        , {mod_race_act_local, start_link, []}          %% 竞榜活动
        , {mod_soul_dungeon, start_link, []}            %% 聚魂本管理进程
        , {mod_invite, start_link, []}                  %% 邀请
        , {mod_php, start_link, []}                     %% php对接
        , {mod_feast_cost_rank, start_link, []}         %% 节日消费排行榜
        , {mod_glad_local, start_link, []}              %% 决斗场
        , {mod_rush_shop, start_link, []}               %% 限购商城
        , {mod_marriage_match, start_link, []}          %% 婚姻
        , {mod_custom_act_liveness, start_link, []}     %% 节日活跃
        , {mod_territory_treasure, start_link, []}      %% 领地夺宝
        , {mod_sanctuary, start_link, []}               %% 圣域
        , {mod_shake, start_link, []}                   %% 摇摇乐日志
        , {mod_custom_act_record, start_link, []}       %% 定制活动记录
        , {mod_midday_party, start_link, []}            %% 午间派对
        , {mod_kf_sanctum_local, start_link, []}        %% 永恒圣殿本服数据管理
%%        , {mod_3v3_team, start_link, []}              %% 3v3战队
        , {mod_auction, start_link, []}                 %% 拍卖行(跟在 活动参与记录服务后面)
        , {mod_decoration_boss_local, start_link, []}   %% 幻饰boss
        , {mod_territory_war, start_link, []}           %% 领地战
        , {mod_kf_rank_dungeon_local, start_link, []}   %% 跨服个人本
        , {mod_luckey_wheel_local, start_link, []}      %% 本服幸运抽奖
        , {mod_level_draw_reward, start_link, []}       %% 等级抽奖
        , {mod_activation_draw, start_link, []}         %% 活跃转盘
        , {mod_first_kill, start_link, []}              %% 活动首杀
        , {mod_sanctuary_cluster_local, start_link, []} %% 跨服圣域
        , {mod_red_envelopes_rain, start_link, []}         %% 活跃转盘
        , {mod_guild_daily, start_link, []}
        , {mod_guild_assist, start_link, []}
        , {mod_subscribe, start_link, []}               %% 订阅
        , {mod_activity_onhook, start_link, []}         %% 活动托管
        , {mod_sys_sell, start_link, []}         %% 系统出售
        , {mod_night_ghost_local, start_link, []}          %% 百鬼夜行
        , {mod_great_demon_local, start_link, []}      %% 跨服秘境大妖
        , {mod_player_info_report, start_link, []}         %% 玩家信息上报

        %% 其他进程都放在这之前
        % , {mod_onhook_agent, start_link, []}          %% 离线挂机代理进程
        , {mod_fortune_cat, start_link, []}             %% 招财猫转盘
        , {mod_contract_challenge, start_link, []}      %% 契约挑战
        % , {mod_escort_local, start_link, []}            %% 矿石护送
        , {mod_seacraft_local, start_link, []}          %% 怒海争霸
        , {mod_boss_first_blood_plus, start_link, []}   %% 新版boss首杀
        , {mod_custom_act_task, start_link, []}
        , {mod_up_power_rank, start_link, []}            %% 战力升榜活动
        , {mod_sea_treasure_local, start_link, []}         %% 璀璨之海
        , {mod_holy_spirit_battlefield_local, start_link, []} %% 本服圣灵战场
        % , {mod_fix_ver, start_link, []}                 %% 补丁版本模块
        , {mod_bf_confirm_conn, start_link, []}         %% 确认链接
        , {mod_msg_cache_queue, start_link, []}         %% 缓存队列
    ].

start_create_mon(10) ->
    {ok, _} = supervisor:start_child(gsrv_sup,
        {mod_scene_object_create, {mod_scene_object_create, start_link, []},
            permanent, 10000, worker, [mod_scene_object_create]}),
    ok;
start_create_mon(_) -> ok.
