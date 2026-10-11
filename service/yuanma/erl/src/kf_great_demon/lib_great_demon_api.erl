%%%-------------------------------------------------------------------
%%% @author lianghaihui
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% 跨服秘境Boss - kf => game 回调游戏节点的函数
%%% @end
%%% Created : 19. 11月 2022 19:52
%%%-------------------------------------------------------------------
-module(lib_great_demon_api).

-include("common.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("boss.hrl").
-include("scene.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("server.hrl").
-include("kf_great_demon.hrl").
-include("mon_pic.hrl").

%% API
-compile(export_all).

%% 玩家成功进入场景回调
handle_enter_success(RoleId, BossId, BinData) when is_integer(RoleId) ->
    BossType = ?BOSS_TYPE_KF_GREAT_DEMON,
    lib_server_send:send_to_uid(RoleId, BinData),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, handle_enter_success, [BossType, BossId]);
handle_enter_success(Ps, BossType, BossId) ->
    #player_status{ id = RoleId } = Ps,
    lib_guild_daily:enter_forbidden_boss(BossType, RoleId),
    lib_boss_api:enter_event(RoleId, Ps#player_status.figure#figure.lv, BossType),
    mod_boss:handle_activitycalen_enter(RoleId, BossType),
    lib_supreme_vip_api:enter_boss(RoleId, BossType, BossId),
    %% 我要变强
    StrongPs = lib_to_be_strong:update_data_boss(Ps, BossType),
    {ok, StrongPs}.

%% 玩家击杀怪物后的回调
handle_boss_be_kill(RoleId, BossType, BossId, BossLv, KillAutoId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, ?MODULE, handle_boss_be_kill, [BossType, BossId, BossLv, KillAutoId]);
handle_boss_be_kill(PS, _MonType, BossId, BossLevel, _KillAutoId) ->
    #player_status{id = RoleId } = PS,
    BossType = ?BOSS_TYPE_KF_GREAT_DEMON,
    %% 攻击者的成就触发
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_achievement_api, boss_achv_finish, [BossType, BossId]),
    mod_boss:handle_activitycalen_kill([], RoleId, [], BossType),
    CallBackData = #callback_boss_kill{boss_type = BossType, boss_id = BossId},
    lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_KILL, CallBackData),
    %% boss击杀任务
    lib_task_api:kill_boss(RoleId, BossType, BossLevel),
    lib_baby_api:boss_be_kill(RoleId, BossType, BossId),
    lib_demons_api:boss_be_kill(RoleId, BossType, BossId),
    {ok, LastPs} = lib_supreme_vip_api:kill_boss(PS, BossType, BossLevel),
    %% 更新玩家的场景内的个人疲劳值
    mod_great_demon_local:update_role_tired_in_scene(BossId, RoleId),
    {ok, LastPs}.

%% 玩家拾取掉落物回调
handle_event(Ps, #event_callback{ type_id = ?EVENT_DROP_CHOOSE, data = Data}) when is_record(Ps, player_status) ->
    #player_status{
        id = RoleId, server_id = ServerId, server_num = ServerNum, scene = SceneId,
        figure = #figure{ name = RoleName }
    } = Ps,
    case lib_boss:is_in_kf_great_demon_boss(SceneId) of
        true ->
            #{goods := DropReward, mon_id := BossId} = Data,
            case DropReward of
                [{_, GoodsTypeId, _}|_]  ->
                    case data_kf_great_demon:get_great_demon_boss_cfg(BossId) of
                        #great_demon_boss_info{layers = Layer} ->
                            NowTime = utime:unixtime(),
                            case lists:member(GoodsTypeId, ?BOSS_TYPE_KV_LOG_GOODS_LIST(?BOSS_TYPE_GLOBAL)) of
                                true ->
                                    ExtraAttr = maps:get(extra_attr, Data, []),
                                    Rating = maps:get(rating, Data, 0),
                                    RoleName = lib_player:get_wrap_role_name(Ps),
                                    RecordList = [{RoleId, ServerId, ServerNum, RoleName, BossId, Layer, GoodsTypeId, Rating, ExtraAttr, NowTime}],
                                    mod_clusters_node:apply_cast(mod_great_demon, boss_add_drop_log, [ServerId, RecordList]);
                                _ ->
                                    skip
                            end;
                        _ ->
                            skip
                    end;
                _ ->
                    skip
            end;
        _ ->
            skip
    end,
    {ok, Ps};
handle_event(Ps, _) ->
    {ok, Ps}.

%% 修复次数问题
gm_fix_great_demon_times(FixType, StartTime, EndTime) ->

    if
        FixType > 0 ->
            spawn(fun() ->
                %% 单独修复某个玩家
                Sql = <<"select boss_id from log_eudemons_land_boss where kill_id = ~p and time > ~p and time < ~p">>,
                List = db:get_all(io_lib:format(Sql, [FixType, StartTime, EndTime])),
                case List of
                    [] ->
                        skip;
                    AllBossId ->
                        ServerId = mod_player_create:get_serid_by_id(FixType),
                        Filter = [BId || [BId] <- AllBossId, is_great_demon_boss(BId) == true],
                        ?PRINT("11:~p~n", [ServerId]),
                        mod_clusters_center:apply_cast(ServerId, ?MODULE, game_fix_great_demon_times, [FixType, Filter])
                end
            end);
        true ->
            spawn(fun() ->
                %% 单独修复某个玩家
                Sql2 = <<"select kill_id, boss_id from log_eudemons_land_boss where time > ~p and time < ~p">>,
                List2 = db:get_all(io_lib:format(Sql2, [StartTime, EndTime])),
                case List2 of
                    [] ->
                        skip;
                    AllRoleList ->
                        Fun = fun([RoleId, KillBossId], TemMap) ->
                            case is_great_demon_boss(KillBossId) of
                                true ->
                                    RoleKillAll = maps:get(RoleId, TemMap, []),
                                    maps:put(RoleId, [KillBossId|RoleKillAll], TemMap);
                                _ ->
                                    TemMap
                            end
                        end,
                        FixMap = lists:foldl(Fun, #{}, AllRoleList),
                        Fun2 = fun(RoleId, AllBIds) ->
                            ServerId = mod_player_create:get_serid_by_id(RoleId),
                            mod_clusters_center:apply_cast(ServerId, lib_great_demon_api, game_fix_great_demon_times, [RoleId, AllBIds])
                        end,
                        maps:map(Fun2, FixMap)
                end
            end)
    end.

game_fix_great_demon_times(RoleId, FixBossIds) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, ?MODULE, role_fix_great_demon_times, [FixBossIds]).

is_great_demon_boss(BossId) ->
    case data_kf_great_demon:get_all_great_demon_boss_id() of
        [] ->
            false;
        All ->
            lists:member(BossId, All)
    end.

role_fix_great_demon_times(Ps, AllBossId) ->
    #player_status{ id = RoleId } = Ps,
    BossType = ?BOSS_TYPE_KF_GREAT_DEMON,
    Fun = fun(BossId, TemPs) ->
        #mon{ lv = BossLevel } = data_mon:get(BossId),
        %% 攻击者的成就触发
        lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_achievement_api, boss_achv_finish, [BossType, BossId]),
        mod_boss:handle_activitycalen_kill([], RoleId, [], BossType),
        CallBackData = #callback_boss_kill{boss_type = BossType, boss_id = BossId},
        lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_KILL, CallBackData),
        %% boss击杀任务
        lib_task_api:kill_boss(RoleId, BossType, BossLevel),
        lib_baby_api:boss_be_kill(RoleId, BossType, BossId),
        lib_demons_api:boss_be_kill(RoleId, BossType, BossId),
        {ok, NewTemPs} = lib_supreme_vip_api:kill_boss(TemPs, BossType, BossLevel),
        NewTemPs
    end,
    NewPs = lists:foldl(Fun, Ps, AllBossId),
    %% 获取进去次数
    {EnterTimes, _Other} = lib_daily:get_count_and_other_from_db(RoleId, 460, 10000, 20),
    Fun2 = fun(_Times, TPs) ->
        lib_boss_api:enter_event(RoleId, Ps#player_status.figure#figure.lv, BossType),
        mod_boss:handle_activitycalen_enter(RoleId, BossType),
        {ok, Tps0} = lib_supreme_vip_api:enter_boss(TPs, BossType, 0),
        %% 我要变强
        lib_to_be_strong:update_data_boss(Tps0, BossType)
    end,
    LastPs = ?IF(EnterTimes > 0, lists:foldl(Fun2, NewPs, lists:seq(0, EnterTimes)), NewPs),
    {ok, LastPs}.
