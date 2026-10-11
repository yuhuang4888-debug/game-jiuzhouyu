%%%-----------------------------------
%%% @Module  : gsrv_clusters_base
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2012.10.25
%%% @Description: 跨服线路
%%%-----------------------------------
-module(gsrv_clusters_base).
-export([start/0, stop/0]).
-include("common.hrl").
-include("watchdog.hrl").

start() ->
    NowTime = utime:unixtime(),
    inets:start(),
    %% 跨服公用服务启动
    case config:get_cls_type() of
        1 ->
            %% 只在跨服中心启动
            application:set_env(kernel, dist_auto_connect, never), %% 设置跨服中心不能自动连接游戏节点
            cls_center();
        _ ->
            %% 只在跨服节点启动
            cls_node()
    end,
    ok = lib_game:log_server_open(?SERVER_STATUS_STARTED, ?NODE_CENTER, NowTime),
    lib_watchdog_api:add_monitor(?WATCHDOD_SERVER_STATUS, ?SERVER_STATUS_STARTED),
    ok.

% %% mod_clusters_center 启动之前
% start_bf_center() ->
%     %% 跨服公用服务启动
%     case config:get_cls_type() of
%         1 ->
%             %% 只在跨服中心启动
%             application:set_env(kernel, dist_auto_connect, never), %% 设置跨服中心不能自动连接游戏节点
%             ok = start_normal_processes(init_modules_func_bf_center());
%         _ ->
%             skip
%     end,
%     ok.

%% 只在跨服中心启动
cls_center() ->
    ok = start_normal_processes(init_modules_func_center()),
    ok.

%% 只在跨服节点启动
cls_node() ->
    ok = start_normal_processes(init_modules_func_node()),
    ok.

%% 节点关闭时
stop() ->
    NowTime = utime:unixtime(),
    % log_server_open 位于mod_log:stop/1前
    lib_game:log_server_open(?SERVER_STATUS_CLOSE, ?NODE_CENTER, NowTime),
    mod_sanctuary_cluster_mgr:process_stop(),
    case config:get_cls_type() of
        1 -> %% 只在跨服中心启动
            mod_log:stop(),
            init:stop();
        _ -> %% 只在跨服节点启动
            mod_log:stop(),
            init:stop()
    end,
    ok.

start_normal_processes([{Mod, _, _}=H|T]) ->
    {ok, _} = supervisor:start_child(gsrv_sup, {Mod, H, permanent, 10000, worker, [Mod]}),
    start_normal_processes(T);
start_normal_processes([_H|T]) ->
    ?PRINT("[Error]:init_modules_func bad format: ~p~n", [_H]),
    start_normal_processes(T);
start_normal_processes([]) -> ok.

% %% mod_clusters_center 启动之前
% %% TODO:还没处理
% init_modules_func_bf_center() ->
%     [
%         {mod_log, start_link, []}
%         , {mod_zone_mgr, start_link, []}              %% 跨服区域管理
%         , {mod_watchdog, start_link, []}               %% 看门狗服务
%     ].

%% mod_clusters_center 启动之后
init_modules_func_center() ->
    [
    {mod_log, start_link, []}
    , {mod_zone_mgr, start_link, []}                %% 跨服区域管理
    , {mod_watchdog, start_link, []}                %% 看门狗服务
    , {mod_game_error, start_link, []}
    %, {mod_eudemons_land_zone, start_link, []}        %% 幻兽区域
    , {mod_scene_npc, start_link,[]}                  %% 场景npc进程
    , {mod_scene_object_create, start_link, []}       %% 创建场景对象进程
    , {mod_scene_init, start_link,[]}                 %% 场景进程
    , {mod_scene_line, start_link, []}                %% 场景线路
    , {mod_change_scene_cls_center, start_link, []}   %% 跨服排队进程
    , {mod_team_create, start_link, []}               %% 组队id进程
    , {mod_team_enlist, start_link, []}               %% 组队招募平台
    , {mod_drop, start_link, []}                      %% 掉落包进程
    , {mod_crontab, start_link,[]}                    %% cron服务进程
    , {mod_id_create_cls, start_link, []}             %% 自增Id
    , {timer_quest, start_link, []}                   %% 动态定时器
    , {timer_min, start_link,[]}
    , {timer_hour, start_link,[]}
    , {timer_midnight, start_link,[]}
    , {timer_4_clock, start_link,[]}
    , {timer_custom_kf, start_link, []}
    , {mod_online, start_link, []}                    %% 在线统计(此进程必须在mod_chat_agent之后启动)
    , {mod_custom_act_kf, start_link, []}
    , {mod_global_counter, start_link, []}            %% 单服计数器
    , {mod_void_fam, start_link, []}                  %% 虚空秘境
    , {mod_top_pk_match_room, start_link, []}         %% 巅峰竞技匹配
    , {mod_eudemons_land, start_link, []}             %% 幻兽之域
    , {mod_top_pk_rank_kf, start_link, []}            %% 巅峰竞技排行榜
    , {mod_kf_flower_act, start_link, []}             %% 跨服鲜花榜
    , {mod_cloud_buy_mgr, start_link, []}             %% 众仙云购
    , {lib_diamond_league, launch, []}                %% 星钻联赛
    , {mod_race_act, start_link, []}                  %%竞榜活动
    , {mod_rush_treasure_kf, start_link, []}          %% 冲榜夺宝
    , {mod_php, start_link, []}                       %% php对接
%%    , {mod_3v3_center, start_link, []}                %% 跨服3v3
%%    , {mod_3v3_rank, start_link, []}                  %% 跨服3v3
    , {mod_kf_1vN, start_link, []}                    %% 跨服1vn
    , {mod_kf_1vN_mgr, start_link, []}                %% 跨服1vn
    , {mod_kf_1vN_auction, start_link, []}            %% 跨服1vn
    %, {mod_saint, start_link, []}                     %% 圣者殿
    %, {mod_kf_guild_war, start_link, []}              %% 跨服公会战
    , {mod_nine_center, start_link, []}             %% 九魂圣殿
    , {mod_beings_gate_kf, start_link, []}          %% 众生之门
    , {mod_drumwar_mgr, start_link, []}             %% 钻石大战
    , {mod_glad_center, start_link, []}             %% 决斗场
    , {mod_kf_chat, start_link, []}                 %% 跨服聊天
    , {mod_online_statistics, start_link, []}       %% 在线人数统计
    , {mod_feast_cost_rank_clusters, start_link, []}   %% 跨服节日消费排行榜
    , {mod_kf_draw_record, start_link, []}          %% 跨服抽奖记录
    , {mod_chat_cache, start_link, []}              %% 聊天缓存
    , {mod_cluster_luckey_value, start_link, []}    %% 跨服幸运值（装备寻宝）
    , {mod_dun_dragon_rank_cluster, start_link, []}
%%    , {mod_3v3_champion, start_link, []}            %%  3v3冠军赛
    , {mod_kf_sanctum, start_link, []}              %% 永恒圣殿
    , {mod_decoration_boss_center, start_link, []}  %% 幻饰boss
    , {mod_territory_war, start_link, []}       %% 领地战
    , {mod_kf_rank_dungeon, start_link, []}       %% 个人排行本
%%    , {mod_3v3_team, start_link, []}                %% 3v3战队
    , {mod_dragon_language_boss, start_link, []}    %% 龙语boss
    , {mod_week_dun_rank, start_link, []}       %% 周常本排行
    , {mod_luckey_wheel_kf, start_link, []}         %% 幸运抽奖
    , {mod_activation_draw_kf, start_link, []}      %% 活跃转盘
    , {mod_holy_spirit_battlefield, start_link, []} %% 圣灵战场
    , {mod_enchantment_guard_rank,start_link, []}   %% 结界守护排位进程
    , {mod_cycle_rank, start_link, []}   %% 循环冲榜
    , {mod_kf_cloud_buy, start_link, []} %% 跨服云购
    , {mod_kf_group_buy, start_link, []} %% 跨服团购
    , {mod_kf_chrono_rift, start_link, []}  %% 时空裂缝
    , {mod_kf_chrono_rift_scramble_rank, start_link, []}  %% 时空裂缝排行榜
    , {mod_kf_chrono_rift_goal, start_link, []}
    % , {mod_escort_kf, start_link, []}               %% 矿石护送
    , {mod_kf_seacraft, start_link, []}             %% 怒海争霸 %%暂时屏蔽
    , {mod_kf_seacraft_daily, start_link, []}       %% 国战日常
    , {mod_kf_auction, start_link, []}                 %% 拍卖行(跨服)
    , {mod_kf_sell, start_link, []}                 %% 市场(跨服)
    , {mod_drop_statistics, start_link, []}         %% 掉落统计
    , {mod_sanctuary_cluster_mgr, start_link, []}
    , {mod_kf_guild_feast_topic, start_link, []}
    %, {mod_beta_recharge_return, start_link, []}   %% 封测数据统计
    , {mod_sea_treasure_kf, start_link, []}         %% 璀璨之海
    , {mod_night_ghost_kf, start_link, []}   %% 百鬼夜行
    , {mod_great_demon, start_link, []}      %% 跨服秘境大妖
    , {mod_sys_sell, start_link, []}         %% 系统出售
    , {mod_zone_mod, start_link, []}         %% 确认链接
    , {mod_kf_confirm_conn, start_link, []}         %% 确认链接
    ].

init_modules_func_node() -> [].
