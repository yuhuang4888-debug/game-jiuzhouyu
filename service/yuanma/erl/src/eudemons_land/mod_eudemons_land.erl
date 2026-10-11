%%%-------------------------------------------------------------------
%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%% 幻兽之域
%%% @end
%%% Created : 27 Oct 2017 by root <root@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(mod_eudemons_land).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-compile(export_all).

-include("common.hrl").
-include("eudemons_land.hrl").
-include("eudemons_zone.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("boss.hrl").
-include("goods.hrl").
-include("drop.hrl").
-include("clusters.hrl").
-include("battle.hrl").
-include("figure.hrl").

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

reset_start() ->
    gen_server:cast(?MODULE, {'reset_start'}).

reset_end() ->
    gen_server:cast(?MODULE, {'reset_end'}).

add_new_zone(NewZoneId) ->
    gen_server:cast(?MODULE, {'add_new_zone', NewZoneId}).

%% 进入幻兽之域
enter_eudemons_land(RoleEudemonsBoss, BossType, BossId, Scene, X, Y, NeedOut)->
    gen_server:cast(?MODULE, {'enter_eudemons_land', RoleEudemonsBoss, BossType, BossId, Scene, X, Y, NeedOut}).

re_login(RoleEudemonsBoss, Scene, X, Y, Hp, HpLim) ->
    gen_server:cast(?MODULE, {'re_login', RoleEudemonsBoss, Scene, X, Y, Hp, HpLim}).

%% 离开幻兽之域
leave_eudemons_land(Node, RoleId, Scene, ServerId)->
    gen_server:cast(?MODULE, {'leave_eudemons_land', Node, RoleId, Scene, ServerId}).

exit_eudemons_land(Node, RoleId, Scene, ServerId)->
    gen_server:cast(?MODULE, {'exit', Node, RoleId, Scene, ServerId}).

player_die(AtterInfo, DerInfo, Scene, X, Y) ->
    gen_server:cast(?MODULE, {'player_die', AtterInfo, DerInfo, Scene, X, Y}).

%% 玩家下线
logout_eudemons_land(Node, RoleId, Scene, ServerId)->
    gen_server:cast(?MODULE, {'logout_eudemons_land', Node, RoleId, Scene, ServerId}).

%% 更新玩家幻兽之域的信息
update_role_eudemons_boss(Node, RoleEudemonsBoss) ->
    gen_server:cast(?MODULE, {'update_role_eudemons_boss', Node, RoleEudemonsBoss}).

%% boss被击杀
eudemons_boss_be_kill(Scene, PoolId, BossId, ServerId, ServerNum, AttrId, AttrName, FirstAttr, BLWho, MonArgs, Minfo)->
    Atter = #battle_return_atter{id = AttrId, real_name = AttrName},
    eudemons_boss_be_kill(Scene, PoolId, BossId, ServerId, ServerNum, Atter, FirstAttr, BLWho, MonArgs, Minfo).

eudemons_boss_be_kill(Scene, PoolId, BossId, ServerId, ServerNum, Atter, FirstAttr, BLWho, MonArgs, Minfo)->
    #battle_return_atter{id = AttrId, real_name = AttrName} = Atter,
    case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
        #eudemons_boss_cfg{scene = Scene1, type = BossType} ->
            if
                Scene1 =/= Scene ->
                    ?ERR("eudemons_boss_be_kill_error_scene:~p~n", [[Scene, PoolId, AttrId, ServerId]]);
                true ->
                    gen_server:cast(?MODULE, {'eudemons_boss_be_kill', Scene, PoolId, BossType, BossId, ServerId, ServerNum, Atter, FirstAttr, BLWho, MonArgs, Minfo})
            end;
        _ ->
            case lib_eudemons_land:is_in_eudemons_boss(Scene) of
                true -> %% 击杀小怪
                    small_mon_be_kill(Scene, PoolId, BossId, ServerId, ServerNum, AttrId, AttrName, FirstAttr, BLWho, MonArgs);
                _ ->
                    skip
            end
    end.

%% 掉落日志添加
boss_add_drop_log(ServerId, RecordList)->
    gen_server:cast(?MODULE, {'boss_add_drop_log', ServerId, RecordList}).

%% 同步幻兽boss信息到游戏服
%% FORCE:是否强制更新 0否;1是
sync_server_data(ServerId, OpTime) ->
    gen_server:cast(?MODULE, {'sync_server_data', ServerId, OpTime}).

sync_eudemons_boss_info(ServerId, Node, IsForce) ->
    gen_server:cast(?MODULE, {'sync_eudemons_boss_info', ServerId, Node, IsForce}).

zone_change(ServerId, OldZone, NewZone) ->
    gen_server:cast(?MODULE, {'zone_change', ServerId, OldZone, NewZone}).

settlement_rank() ->
    gen_server:cast(?MODULE, {'settlement_rank'}).

fin_task_daily(Args) ->
    gen_server:cast(?MODULE, {'fin_task_daily', Args}).

handle_boss_be_kill_succ(Args) ->
    gen_server:cast(?MODULE, {'handle_boss_be_kill_succ', Args}).

gm_add_score(Args) ->
    gen_server:cast(?MODULE, {'gm_add_score', Args}).

%% 查看state
show_state() ->
    gen_server:cast(?MODULE, {'show_state'}).

%% 消耗复活
cost_reborn(ServerId, RoleId, BossType, BossId, Cost) ->
    gen_server:cast(?MODULE, {'cost_reborn', ServerId, RoleId, BossType, BossId, Cost}).

ack_cost_reborn(ServerId, RoleId, BossType, BossId, ErrCode) ->
    gen_server:cast(?MODULE, {'ack_cost_reborn', ServerId, RoleId, BossType, BossId, ErrCode}).

%% 合服处理
handle_merge_server(ServerId, MergeSerIds) ->
    gen_server:cast(?MODULE, {'handle_merge_server', ServerId, MergeSerIds}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    process_flag(trap_exit, true),
    %erlang:send_after(100, self(), 'boss_init'),
    RefCleanKiller = util:send_after([], 3600*1000, self(), {clean_killer_info}),
    ScoreMap = init_score_map(),
    %?PRINT("init ScoreMap ~p~n", [ScoreMap]),
    {ok, #kf_eudemons_boss_state{score_map = ScoreMap, ref_clean_killer = RefCleanKiller}}.

init_score_map() ->
    case db_select_player_score() of
        [] -> #{};
        DbList ->
            F = fun([RoleId, RoleName, ServerId, ServerNum, Score, SK1, KillNum, SK2, TotalScore, SK3], Map) ->
                ZoneId = lib_clusters_center_api:get_zone(ServerId),
                PlayerScore = #player_score{
                    role_id = RoleId, role_name = RoleName, server_id = ServerId, server_num = ServerNum,
                    zone_id = ZoneId, score = Score, sort_key1 = SK1, kill_num = KillNum, sort_key2 = SK2, total_score = TotalScore, sort_key3 = SK3
                },
                PlayerScoreList = maps:get(ZoneId, Map, []),
                maps:put(ZoneId, [PlayerScore|PlayerScoreList], Map)
            end,
            lists:foldl(F, #{}, DbList)
    end.

handle_call(Req, From, State) ->
    case catch do_handle_call(Req, From, State) of
        {reply, Res, NewState} ->
            {reply, Res, NewState};
        Res ->
            ?ERR("Eudemons Land Call Error:~p~n", [[Req, Res]]),
            {reply, error, State}

    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Eudemons Land Cast Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Eudemons Land Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
do_handle_call(_Req, _From, State)->
    %?PRINT("_Req:~p~n", [_Req]),
    {reply, ok, State}.

do_handle_cast({'reset_start'}, State) ->
    #kf_eudemons_boss_state{role_info = RolesZoneDict, boss_eudemons_map = LineBossMap, score_map = OldScoreMap} = State,
    db:execute(<<"truncate table `eudemons_boss_kf`">>),
    clear_all_scene_boss(LineBossMap),
    leave_scene_force(RolesZoneDict),
    mod_clusters_center:apply_to_all_node(mod_eudemons_land_local, reset_start, []),
    NewState = #kf_eudemons_boss_state{act_status = 2, score_map = OldScoreMap},
    {noreply, NewState};

do_handle_cast({'reset_end'}, State)->
    NewState = reset_end(State),
    mod_clusters_center:apply_to_all_node(mod_eudemons_land_local, reset_end, []),
    %?PRINT("reset end ~p~n", [NewState]),
    {noreply, NewState};

% do_handle_cast({'add_new_zone', NewZoneId}, State)->
%     #kf_eudemons_boss_state{boss_eudemons_map = LineBossMap} = State,
%     AllBossIds = [{BossId, 0, []} || BossId <- data_eudemons_land:get_all_eudemons_boss_id()],
%     NowTime = utime:unixtime(),
%     EudemonsBoss = create_zone_boss(NewZoneId, AllBossIds, NowTime),
%     NewLineEudemonsBoss = LineBossMap#{NewZoneId => EudemonsBoss},
%     {noreply, State#kf_eudemons_boss_state{boss_eudemons_map = NewLineEudemonsBoss}};

%% 节点请求boss信息(节点连接服务器后同步信息)
do_handle_cast({'sync_server_data', ServerId, OpTime}, State)->
    case util:check_open_day_2(4, OpTime) of
        true ->
            #kf_eudemons_boss_state{
                act_status = ActStatus, reset_etime = _ResetETime,
                boss_eudemons_map = EudemonsBossMap, score_map = ScoreMap
            } = State,
            ZoneId = get_zone_id(ServerId),
            %?PRINT("sync_server_data ZoneId ~p~n", [ZoneId]),
            case ZoneId > 0 of
                true ->
                    case get_one_zone_boss_map(ZoneId, EudemonsBossMap) of
                        {ok, _ZoneId, ZoneBossMap, NewEudemonsBossMap} ->
                            PlayerScoreList = maps:get(ZoneId, ScoreMap, []),
                            FilterZoneBossMap = filter_zone_boss_map(ZoneBossMap),
                            mod_clusters_center:apply_cast(ServerId, mod_eudemons_land_local,
                                                           board_eudemos_boss_info, [ZoneId, ActStatus, 0, FilterZoneBossMap, PlayerScoreList]),
                            %?PRINT("sync_server_data ZoneBossMap ~p~n", [maps:size(FilterZoneBossMap)]),
                            NewState = State#kf_eudemons_boss_state{boss_eudemons_map = NewEudemonsBossMap};
                        _R ->
                            %% ?ERR("~p ~p sync_eudemos_boss_info :~p~n", [?MODULE, ?LINE, [ServerId, Node]]),
                            NewState = State
                    end;
                _ ->
                    NewState = State
            end,
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

%% 节点主动请求boss信息
do_handle_cast({'sync_eudemons_boss_info', ServerId, _Node, _IsForce}, State)->
    #kf_eudemons_boss_state{
        act_status = ActStatus, reset_etime = _ResetETime,
        boss_eudemons_map = EudemonsBossMap, score_map = ScoreMap
    } = State,
    IsResetting = check_is_resettine(State),
    case IsResetting of
        true ->
            mod_clusters_center:apply_cast(ServerId, mod_eudemons_land_local,
                                           board_eudemos_boss_info, [0, ActStatus, 0, #{}, []]),
            NewState = State;
        _ ->
            ZoneId = get_zone_id(ServerId),
            %?PRINT("sync_eudemons_boss_info ZoneId ~p~n", [ZoneId]),
            case get_one_zone_boss_map(ZoneId, EudemonsBossMap) of
                {ok, _ZoneId, ZoneBossMap, NewEudemonsBossMap} ->
                    PlayerScoreList = maps:get(ZoneId, ScoreMap, []),
                    FilterZoneBossMap = filter_zone_boss_map(ZoneBossMap),
                    mod_clusters_center:apply_cast(ServerId, mod_eudemons_land_local,
                                                   board_eudemos_boss_info, [ZoneId, ActStatus, 0, FilterZoneBossMap, PlayerScoreList]),
                    NewState = State#kf_eudemons_boss_state{boss_eudemons_map = NewEudemonsBossMap};
                _R ->
                    %% ?ERR("~p ~p sync_eudemos_boss_info :~p~n", [?MODULE, ?LINE, [ServerId, Node]]),
                    NewState = State
            end
    end,
    {noreply, NewState};

%% 进入幻兽之域
do_handle_cast({'enter_eudemons_land', RoleEudemonsBoss, BossType, BossId, Scene, X, Y, NeedOut}, State) ->
    #kf_eudemons_boss_state{role_info = RolesZoneDict, scene_num = SceneZoneMap} = State,
    IsResetting = check_is_resettine(State),
    #eudemons_boss{ role_id = RoleId, server_id = ServerId, node = Node} = RoleEudemonsBoss,
    ZoneId = get_zone_id(ServerId),
    Result = if
        IsResetting -> {false, ?ERRCODE(err470_is_resetting)};
        ZoneId == 0 -> {false, ?ERRCODE(err470_no_zone)};
        true -> true
    end,
    case Result of
        {false, Res} -> %%
            %?PRINT("enter Res ~p~n", [Res]),
            {ok, Bin} = pt_470:write(47003, [Res]),
            lib_clusters_center:send_to_uid(Node, RoleId, Bin),
            {noreply, State};
        true ->
            %% 分区里面的某个场景的人数
            SceneNum = maps:get({ZoneId, Scene}, SceneZoneMap, 0),
            #ets_scene_other{room_max_people = MaxNum} = data_scene_other:get(Scene),
            if
                SceneNum >= MaxNum ->
                    {ok, Bin} = pt_470:write(47003, [?ERRCODE(err120_max_user)]),
                    lib_clusters_center:send_to_uid(Node, RoleId, Bin),
                    {noreply, State};
                true ->
                    PoolId = get_pool_id(ZoneId),
                    case dict:find({ZoneId, RoleId}, RolesZoneDict) of
                        {ok, #eudemons_boss{scene = OldScene}} when OldScene == Scene ->
                            NewSceneNum = SceneNum;
                        _ -> NewSceneNum = SceneNum + 1
                    end,
                    NewSceneZoneMap = maps:put({ZoneId, Scene}, NewSceneNum, SceneZoneMap),
                    NewRoleEudemonsBoss = RoleEudemonsBoss#eudemons_boss{node = Node, scene = Scene},
                    NewRolesZoneDict = dict:store({ZoneId, RoleId}, NewRoleEudemonsBoss, RolesZoneDict),
                    mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene,
                                                   [RoleId, Scene, PoolId, ZoneId, X, Y, NeedOut, [{group, 0}, {collect_checker, {lib_eudemons_land, check_collect_times, [RoleId, BossType, BossId]}}]]),
                    send_collect_boss_info(ServerId, RoleId, Scene, State),
                    %?PRINT("enter ok ~p~n", [{Scene, PoolId, ZoneId}]),
                    {noreply, State#kf_eudemons_boss_state{role_info = NewRolesZoneDict, scene_num = NewSceneZoneMap}}
            end
    end;

do_handle_cast({'re_login', RoleEudemonsBoss, Scene, _X, _Y, _Hp, _HpLim}, State) ->
    #kf_eudemons_boss_state{role_info = RolesZoneDict} = State,
    IsResetting = check_is_resettine(State),
    #eudemons_boss{role_id = RoleId, server_id = ServerId, node = _Node} = RoleEudemonsBoss,
    ZoneId = get_zone_id(ServerId),
    Result = if
        IsResetting -> {false, ?ERRCODE(err470_is_resetting)};
        ZoneId == 0 -> {false, ?ERRCODE(err470_no_zone)};
        true -> true
    end,
    case Result of
        {false, _Res} -> %%
            mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_default_scene, [RoleId, []]),
            {noreply, State};
        true ->
            %PoolId = get_pool_id(ZoneId),
            case dict:find({ZoneId, RoleId}, RolesZoneDict) of
                error ->
                    mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_default_scene, [RoleId, []]),
                    {noreply, State};
                {ok, #eudemons_boss{}} ->
                    _BossType = ?BOSS_TYPE_EUDEMONS,
                    NewRoleEudemonsBoss = RoleEudemonsBoss#eudemons_boss{scene = Scene},
                    NewRolesZoneDict = dict:store({ZoneId, RoleId}, NewRoleEudemonsBoss, RolesZoneDict),
                    %KvList = [{action_lock, ?ERRCODE(err470_in_eudemons_boss)}, {group, 0}, {collect_checker, {lib_eudemons_land, check_collect_times, [RoleId, BossType, 0]}}],
                    %NewKvList = ?IF(Hp < round(HpLim * 0.03), [{hp, round(HpLim * 0.03)}, {ghost, 0}|KvList], KvList),
                    %mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene,
                    %                               [RoleId, Scene, PoolId, ZoneId, X, Y, false, NewKvList]),
                    %?PRINT("re_login ok ~p~n", [{Scene, PoolId, ZoneId}]),
                    send_collect_boss_info(ServerId, RoleId, Scene, State),
                    {noreply, State#kf_eudemons_boss_state{role_info = NewRolesZoneDict}}
            end
    end;

%% 离开幻兽之域
do_handle_cast({'leave_eudemons_land', Node, RoleId, Scene, ServerId}, State) ->
    #kf_eudemons_boss_state{role_info = RoleInfos, scene_num = SceneMap} = State,
    case get_zone_id(ServerId) of
        0 -> %% 该服暂未分区
            NewRoleInfos = RoleInfos, NewSceneMap = SceneMap;
        ZoneId ->
            case dict:find({ZoneId, RoleId}, RoleInfos) of
                error -> NewRoleInfos = RoleInfos, NewSceneMap = SceneMap;
                _ ->
                    %?PRINT("leave_eudemons_land find ~n", []),
                    NewRoleInfos = dict:erase({ZoneId, RoleId}, RoleInfos),
                    SceneNum = maps:get({ZoneId, Scene}, SceneMap, 0),
                    NewSceneNum = max(SceneNum-1, 0),
                    NewSceneMap = maps:put({ZoneId, Scene}, NewSceneNum, SceneMap)
            end
    end,
    %% 不走队列
    %?PRINT("leave_eudemons_land succ ~n", []),
    mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene,
                                   [RoleId, 0, 0, 0, 0, 0, true, [{collect_checker, undefined}, {pk, {?PK_PEACE, true}}]]),
    {noreply, State#kf_eudemons_boss_state{role_info = NewRoleInfos, scene_num = NewSceneMap}};

%% 清理玩家数据
do_handle_cast({'exit', _Node, RoleId, Scene, ServerId}, State) ->
    #kf_eudemons_boss_state{role_info = RoleInfos, scene_num = SceneMap} = State,
    case get_zone_id(ServerId) of
        0 -> %% 该服暂未分区
            NewRoleInfos = RoleInfos, NewSceneMap = SceneMap;
        ZoneId ->
            case dict:find({ZoneId, RoleId}, RoleInfos) of
                {ok, RoleEudemonsBoss} ->
                    % ?PRINT("leave_eudemons_land exit find ~n", []),
                    NewRoleInfos = dict:store({ZoneId, RoleId}, RoleEudemonsBoss#eudemons_boss{scene = 0}, RoleInfos),
                    SceneNum = maps:get({ZoneId, Scene}, SceneMap, 0),
                    NewSceneNum = max(SceneNum-1, 0),
                    NewSceneMap = maps:put({ZoneId, Scene}, NewSceneNum, SceneMap);
                _ ->
                    NewRoleInfos = RoleInfos, NewSceneMap = SceneMap
            end
    end,
    {noreply, State#kf_eudemons_boss_state{role_info = NewRoleInfos, scene_num = NewSceneMap}};

%% 玩家下线
do_handle_cast({'logout_eudemons_land', _Node, RoleId, Scene, ServerId}, State) ->
    #kf_eudemons_boss_state{role_info = RoleInfos, scene_num = SceneMap} = State,
    case get_zone_id(ServerId) of
        0 -> NewRoleInfos = RoleInfos, NewSceneMap = SceneMap;
        ZoneId ->
            case dict:find({ZoneId, RoleId}, RoleInfos) of
                error -> NewRoleInfos = RoleInfos, NewSceneMap = SceneMap;
                _ ->
                    NewRoleInfos = dict:erase({ZoneId, RoleId}, RoleInfos),
                    SceneNum = maps:get({ZoneId, Scene}, SceneMap, 0),
                    NewSceneNum = max(SceneNum-1, 0),
                    NewSceneMap = maps:put({ZoneId, Scene}, NewSceneNum, SceneMap)
            end
    end,
    {noreply, State#kf_eudemons_boss_state{role_info = NewRoleInfos, scene_num = NewSceneMap}};

%% 玩家死亡
do_handle_cast({'player_die', AtterInfo, DerInfo, Scene, X, Y}, State) ->
    [AUid, AttName, AttLv, AtterSign, AttGuildId, AttServerId, AttServerNum, AttMaskId] = AtterInfo,
    [DieId, DeadName, DeadLv, DeadGuildId, ServerId, ServerNum, DeadMaskId] = DerInfo,
    #kf_eudemons_boss_state{role_info = RoleInfos, score_map = ScoreMap, killer_map = KillerMap} = State,
    case get_zone_id(ServerId) of
        0 ->
            {noreply, State};
        ZoneId ->
            case dict:find({ZoneId, DieId}, RoleInfos) of
                error ->
                    {noreply, State};
                {ok, #eudemons_boss{node = Node, bekill_count = BeKillTime} = RoleEudemonsBoss} ->
                    %?PRINT("player_die ###### start ~n", []),
                    NowTime = utime:unixtime(),
                    %% 死亡复活时间buff
                    case data_boss:get_boss_type_kv(?BOSS_TYPE_PHANTOM, player_die_times) of
                        TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
                        _ -> TimeCfg = 300
                    end,
                    case data_boss:get_boss_type_kv(?BOSS_TYPE_PHANTOM, revive_point_gost) of
                        TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                        _ -> TimeCfg2 = 20
                    end,
                    NewList = lib_boss_mod:get_real_die_time_list_2(BeKillTime, TimeCfg, NowTime),
                    DieTimes = erlang:length([NowTime|NewList]),
                    {RebornTime, MinTimes} = count_die_wait_time(DieTimes, NowTime),
                    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, [DieId, ?APPLY_CAST_SAVE, lib_boss, update_role_boss, [?BOSS_TYPE_PHANTOM, RebornTime, NowTime, DieTimes]]),
                    if
                        DieTimes > MinTimes ->
                            {ok, Bin} = pt_470:write(47034, [DieTimes, RebornTime, NowTime + TimeCfg, NowTime + TimeCfg2]),
                            lib_clusters_center:send_to_uid(Node, DieId, Bin);
                        true ->
                            {ok, Bin} = pt_470:write(47034, [DieTimes, RebornTime, NowTime + TimeCfg, 0]),
                            lib_clusters_center:send_to_uid(Node, DieId, Bin)
                    end,
                    NewRoleEudemonsBoss = RoleEudemonsBoss#eudemons_boss{bekill_count = [NowTime|NewList]},
                    NewRoleInfos = dict:store({ZoneId, DieId}, NewRoleEudemonsBoss, RoleInfos),
                    %% 公会击杀传闻
                    case AtterSign == ?BATTLE_SIGN_PLAYER of
                        true ->
                            BossTypeName = data_boss:get_boss_type_name(?BOSS_TYPE_PHANTOM),
                            case lib_eudemons_land:get_one_boss_info_by_scene(Scene) of
                                #eudemons_boss_cfg{boss_id = BossId, layers = Layer} when DeadGuildId > 0 andalso DeadMaskId == 0 ->
                                    NewAttName =
                                        case ServerNum =/= AttServerNum of
                                            true ->
                                                list_to_binary([lists:concat(["S", AttServerNum, "."]), AttName]);
                                            _ -> AttName
                                        end,
                                    LastAttName = lib_player:get_wrap_role_name(NewAttName, [AttMaskId]),
                                    mod_clusters_center:apply_cast(ServerId,
                                        lib_chat, send_TV,
                                        [{guild, DeadGuildId}, ?MOD_BOSS, 14, [DeadName, util:make_sure_binary(BossTypeName), Layer, LastAttName, ?BOSS_TYPE_PHANTOM, BossId, Scene, X, Y]]);
                                _ ->
                                    skip
                            end,
                            case AttGuildId > 0 andalso AttMaskId == 0 of
                                true ->
                                    NewDeadName =
                                        case ServerNum =/= AttServerNum of
                                            true ->
                                                list_to_binary([lists:concat(["S", ServerNum, "."]), DeadName]);
                                            _ -> DeadName
                                        end,
                                    LastDeadName = lib_player:get_wrap_role_name(NewDeadName, [DeadMaskId]),
                                    mod_clusters_center:apply_cast(AttServerId,
                                        lib_chat, send_TV,
                                        [{guild, AttGuildId}, ?MOD_BOSS, 16, [AttName, util:make_sure_binary(BossTypeName), LastDeadName]]);
                                _ -> skip
                            end;
                        _ ->
                            skip
                    end,
                    %% 增加击杀者积分和击杀数量
                    case check_kill_is_valid(ZoneId, AtterInfo, DerInfo, KillerMap, NowTime) of
                        true ->
                            AddScore = lib_eudemons_land:get_kill_player_score(AttLv, DeadLv),
                            NewScoreMap = update_killer_kill_num(ZoneId, ScoreMap, [AUid, AttName, AttServerId, AttServerNum], AddScore),
                            NewKillerMap = update_killer_map(KillerMap, AtterInfo, DerInfo, NowTime),
                            add_score_info_to_local(ZoneId, AUid, ?SCORE_TYPE_1, AddScore, NewScoreMap);
                        _ ->
                            ?PRINT("check_kill_is_valid ###### false ~n", []),
                            NewScoreMap = ScoreMap, NewKillerMap = KillerMap
                    end,
                    NewState = State#kf_eudemons_boss_state{
                        role_info = NewRoleInfos,
                        score_map = NewScoreMap,
                        killer_map = NewKillerMap
                    },
                    {noreply, NewState}
            end
    end;

%% 更新玩家幻兽之域
do_handle_cast({'update_role_eudemons_boss', Node, RoleEudemonsBoss}, State) ->
    #kf_eudemons_boss_state{role_info = RoleInfos} = State,
    #eudemons_boss{ role_id = RoleId, server_id = ServerId} = RoleEudemonsBoss,
    case get_zone_id(ServerId) of
        0 ->
            NewRoleInfos = RoleInfos;
        ZoneId ->
            NewRoleEudemonsBoss = RoleEudemonsBoss#eudemons_boss{node = Node},
            NewRoleInfos = dict:store({ZoneId, RoleId}, NewRoleEudemonsBoss, RoleInfos)
    end,
    {noreply, State#kf_eudemons_boss_state{role_info = NewRoleInfos}};

%% 同步拾取掉落日志
do_handle_cast({'boss_add_drop_log', ServerId, RecordList}, State) ->
    case get_zone_id(ServerId) of
        0 ->
            skip;
        ZoneId ->
            %% 区域广播
            mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_eudemons_land_local, board_eudemos_boss_add_drop_log, [RecordList])
    end,
    {noreply, State};

%% boss被杀|采集怪采集
do_handle_cast({'eudemons_boss_be_kill', Scene, PoolId, BossType, BossId, ServerId1, ServerNum, Atter, FirstAttr, BLWhos, MonArgs, Minfo}, State) ->
    #kf_eudemons_boss_state{
        boss_eudemons_map = EudemonsBossMap, role_info = RoleInfos,
        score_map = ScoreMap
    } = State,
    IsResetting = check_is_resettine(State),
    case IsResetting of
        true -> {noreply, State};
        _ ->
            #battle_return_atter{id = AttrId, real_name = AttrName} = Atter,
            ServerId = if
               ServerId1 == 0 ->
                   ?ERR("AttrId:~p~n", [[AttrId, BossId, Scene, PoolId, BossType]]),
                   mod_player_create:get_serid_by_id(AttrId);
               true ->
                   ServerId1
           end,
           %?PRINT("eudemons_boss_be_kill ServerId ~p~n", [ServerId]),
            case get_zone_boss_map(ServerId, BossId, EudemonsBossMap) of
                {ZoneId, ZoneBossMap, Boss} ->
                    #eudemons_boss_status{boss_id = BossId} = Boss,
                    %% 获取玩家服务名字(一般都会存在)
                    case dict:find({ZoneId, AttrId}, RoleInfos) of
                        error -> SName = <<>>;
                        {ok, #eudemons_boss{server_name = SName}} -> skip
                    end,
                    %% 计算重生时间和提醒时间
                    BossCfg = data_eudemons_land:get_eudemons_boss_cfg(BossId),
                    %?PRINT("get_zone_boss_map  ~p~n", [{ZoneId, SName}]),
                    if
                        BossCfg#eudemons_boss_cfg.is_rare >= ?MON_CL_NORMAL -> %% 采集处理
                            KillerL = [{AttrId, AttrName, ServerId, ServerNum}],
                            %% 更新击杀者的积分信息
                            ScoreType = ?IF(BossCfg#eudemons_boss_cfg.is_rare >= ?MON_CL_NORMAL, ?SCORE_TYPE_3, ?SCORE_TYPE_2),
                            AddScore = lib_eudemons_land:get_kill_mon_score(BossId),
                            F = fun({KillerId, KillerName, KillerServerId, KillerServerNum}, ScoreMapTmp) ->
                                ScoreMapUp = update_role_score(ZoneId, ScoreMapTmp, [KillerId, KillerName, KillerServerId, KillerServerNum], ScoreType, AddScore),
                                add_score_info_to_local(ZoneId, KillerId, ScoreType, AddScore, ScoreMapUp),
                                ScoreMapUp
                            end,
                            NewScoreMap = lists:foldl(F, ScoreMap, KillerL),
                            NewBoss = boss_be_collect(ServerId, ZoneId, BossCfg, BossType, Boss, AttrId, AttrName, FirstAttr, BLWhos, MonArgs),
                            NewZoneBossMap = maps:put(BossId, NewBoss, ZoneBossMap),
                            NewEudemonsBossMap = maps:put(ZoneId, NewZoneBossMap, EudemonsBossMap);
                        true ->
                            NewScoreMap = ScoreMap,
                            NewBoss = do_boss_be_kill(ServerId, ZoneId, BossType, ZoneBossMap, Boss, Atter, FirstAttr, BLWhos, RoleInfos, MonArgs, Minfo),
                            NewZoneBossMap = maps:put(BossId, NewBoss, ZoneBossMap),
                            NewEudemonsBossMap = maps:put(ZoneId, NewZoneBossMap, EudemonsBossMap)
                    end,
                    %% 通知所有节点更新怪物数据和添加击杀信息(区域广播)
                    BossCfg#eudemons_boss_cfg.is_rare =/= ?MON_CL_TASK andalso
                        mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_eudemons_land_local, board_eudemos_boss_kill_and_log,
                                                    [BossType, BossId, NewBoss, AttrId, AttrName, SName]),
                    {noreply, State#kf_eudemons_boss_state{boss_eudemons_map = NewEudemonsBossMap, score_map = NewScoreMap}};
                _R ->
                    ?ERR("~p ~p server error ServerId:~w~n", [?MODULE, ?LINE, [ServerId, BossId, AttrId, _R]]),
                    {noreply, State}
            end
    end;

do_handle_cast({'handle_boss_be_kill_succ', Args}, State) ->
    #kf_eudemons_boss_state{score_map = ScoreMap} = State,
    [Res, RoleId, KillAutoId, ServerId, ServerNum, RoleName, _ServerId1, ScoreType, AddScore] = Args,
    ZoneId = get_zone_id(ServerId),
    case ZoneId > 0 andalso Res == 1 of
        true ->
            KillBossList = get_role_kill_boss_list(RoleId),
            case lists:keyfind(KillAutoId, 1, KillBossList) of
                {_, {Minfo, MonArgs, Atter, FirstAttr, BLWhos}} ->
                    delete_role_kill_boss_list(RoleId, KillAutoId),
                    lib_drop:cluster_mon_drop_do(Minfo, MonArgs, Atter, BLWhos, FirstAttr);
                _ ->
                    ?ERR("handle_boss_be_kill_succ lost kill info RoleId: ~p~n", [RoleId]),
                    skip
            end,
            NewScoreMap = update_role_score(ZoneId, ScoreMap, [RoleId, RoleName, ServerId, ServerNum], ScoreType, AddScore),
            add_score_info_to_local(ZoneId, RoleId, ScoreType, AddScore, NewScoreMap),
            {noreply, State#kf_eudemons_boss_state{score_map = NewScoreMap}};
        _ ->
            delete_role_kill_boss_list(RoleId, KillAutoId),
            %?ERR("handle_boss_be_kill_succ ERR: ~p~n", [[ZoneId|Args]]),
            {noreply, State}
    end;

do_handle_cast({'fin_task_daily', Args}, State)->
    #kf_eudemons_boss_state{
        score_map = ScoreMap
    } = State,
    [RoleId, RoleName, ServerId, ServerNum, AddScore] = Args,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    case ZoneId > 0 of
        true ->
            NewScoreMap = update_role_score(ZoneId, ScoreMap, [RoleId, RoleName, ServerId, ServerNum], ?SCORE_TYPE_4, AddScore),
            add_score_info_to_local(ZoneId, RoleId, ?SCORE_TYPE_4, AddScore, NewScoreMap),
            {noreply, State#kf_eudemons_boss_state{score_map = NewScoreMap}};
        _ ->
            {noreply, State}
    end;

do_handle_cast({'gm_add_score', Args}, State)->
    #kf_eudemons_boss_state{
        score_map = ScoreMap
    } = State,
    [RoleId, RoleName, ServerId, ServerNum, ScoreType, AddScore] = Args,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    case ZoneId > 0 of
        true ->
            NewScoreMap = update_role_score(ZoneId, ScoreMap, [RoleId, RoleName, ServerId, ServerNum], ScoreType, AddScore),
            add_score_info_to_local(ZoneId, RoleId, ?SCORE_TYPE_4, AddScore, NewScoreMap), %% 只加积分，不发特殊货币
            {noreply, State#kf_eudemons_boss_state{score_map = NewScoreMap}};
        _ ->
            {noreply, State}
    end;


do_handle_cast({'zone_change', ServerId, OldZone, NewZone}, State)->
    #kf_eudemons_boss_state{score_map = ScoreMap} = State,
    NewScoreMap = zone_change(ScoreMap, ServerId, OldZone, NewZone),
    NewPlayerScoreList = maps:get(NewZone, NewScoreMap, []),
    mod_zone_mgr:apply_cast_to_zone(1, NewZone, mod_eudemons_land_local, sync_score_info_to_server, [NewPlayerScoreList]),
    {noreply, State#kf_eudemons_boss_state{score_map = NewScoreMap}};

do_handle_cast({'settlement_rank'}, State)->
    #kf_eudemons_boss_state{score_map = ScoreMap} = State,
    spawn(fun() -> send_rank_reward(ScoreMap) end),
    F = fun(ZoneId, _PlayerScoreList) ->
        NewPlayerScoreList = [],
        mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_eudemons_land_local, sync_score_info_to_server, [NewPlayerScoreList]),
        NewPlayerScoreList
    end,
    NewScoreMap = maps:map(F, ScoreMap),
    db_delete_player_score(),
    {noreply, State#kf_eudemons_boss_state{score_map = NewScoreMap}};

do_handle_cast({'show_state'}, State)->
    ?PRINT("state ~p~n", [State]),
    {noreply, State};

do_handle_cast({'cost_reborn', ServerId, RoleId, BossType, BossId, Cost}, State) ->
    #kf_eudemons_boss_state{boss_eudemons_map = ZoneEudemonsBossMap} = State,
    case get_zone_boss_map(ServerId, BossId, ZoneEudemonsBossMap) of
        {ZoneId, ZoneBossMap, Boss} ->
            case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
                #eudemons_boss_cfg{is_rare = 0} -> IsCanReborn = true;
                _ -> IsCanReborn = false
            end,
            #eudemons_boss_status{reborn_time = RebornTime, click_reborn = ClickReborn} = Boss,
            NowTime = utime:unixtime(),
            Diff = RebornTime - NowTime,
            ClickDiff = ClickReborn - NowTime,
            Result = if
                IsCanReborn == false -> {false, ?ERRCODE(err470_this_boss_not_to_cost_reborn)};
                RebornTime == 0 -> {false, ?ERRCODE(err460_no_die_to_cost_reborn)};
                % 小于五秒不能消耗复活
                Diff =< 5 -> {false, ?ERRCODE(err470_ready_reborn_not_to_cost_reborn)};
                % 其他玩家正在操作
                ClickDiff > 0 andalso ClickDiff =< 5 -> {false, ?ERRCODE(err470_doing_cost_reborn)};
                true -> true
            end,
            case Result of
                {false, ErrCode} ->
                    {ok, BinData} = pt_470:write(47035, [ErrCode, BossType, BossId]),
                    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
                    {noreply, State};
                true ->
                    NewBoss = Boss#eudemons_boss_status{click_reborn = NowTime},
                    NewZoneBossMap = maps:put(BossId, NewBoss, ZoneBossMap),
                    NewZoneEudemonsBossMap = maps:put(ZoneId, NewZoneBossMap, ZoneEudemonsBossMap),
                    NewState = State#kf_eudemons_boss_state{boss_eudemons_map = NewZoneEudemonsBossMap},
                    PlayerArgs = [RoleId, ?APPLY_CAST_SAVE, lib_eudemons_land, ack_cost_reborn, [BossType, BossId, Cost]],
                    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, PlayerArgs),
                    {noreply, NewState}
            end;
        _ ->
            ?ERR("cost_reborn boss_reborn_error:~p~n", [[ServerId, RoleId, BossType, BossId, Cost]]),
            {noreply, State}
    end;

do_handle_cast({'ack_cost_reborn', ServerId, RoleId, BossType, BossId, RoleErrCode}, State) ->
    #kf_eudemons_boss_state{boss_eudemons_map = ZoneEudemonsBossMap} = State,
    case get_zone_boss_map(ServerId, BossId, ZoneEudemonsBossMap) of
        {ZoneId, ZoneBossMap, Boss} ->
            #eudemons_boss_status{reborn_time = RebornTime} = Boss,
            Result = if
                RebornTime == 0 -> {false, ?ERRCODE(err460_no_die_to_cost_reborn)};
                true -> true
            end,
            % 异常
            case Result of
                {false, _ErrCode} -> ?ERR("ack_cost_reborn_error:~p~n", [[ServerId, RoleId, BossType, BossId, _ErrCode, RoleErrCode]]);
                true -> skip
            end,
            % 只要成功都发送复活成功
            case RoleErrCode == ?SUCCESS of
                true ->
                    {ok, BinData} = pt_470:write(47035, [?SUCCESS, BossType, BossId]),
                    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]);
                false ->
                    skip
            end,
            case Result == true andalso RoleErrCode == ?SUCCESS of
                true ->
                    %% 广播刷新信息
                    {ok, BinData2} = pt_460:write(46042, [BossType, BossId]),
                    mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, lib_server_send, send_to_all, [BinData2]),
                    {noreply, NewState} = do_handle_info({'boss_reborn', ZoneId, BossType, BossId}, State),
                    {noreply, NewState};
                false ->
                    % 取消点击锁
                    NewBoss = Boss#eudemons_boss_status{click_reborn = 0},
                    NewZoneBossMap = maps:put(BossId, NewBoss, ZoneBossMap),
                    NewZoneEudemonsBossMap = maps:put(ZoneId, NewZoneBossMap, ZoneEudemonsBossMap),
                    NewState = State#kf_eudemons_boss_state{boss_eudemons_map = NewZoneEudemonsBossMap},
                    {noreply, NewState}
            end;
        _ ->
            ?ERR("ack_cost_reborn boss_reborn_error:~p~n", [[ServerId, RoleId, BossType, BossId, RoleErrCode]]),
            {noreply, State}
    end;

do_handle_cast({gm_refresh_cristal, ZoneId, BossId}, State)->
    #kf_eudemons_boss_state{
        boss_eudemons_map = EudemonsBossMap
    } = State,
    case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
        #eudemons_boss_cfg{type = BossType, scene = Scene, is_rare = IsRare} = BossCfg
            when IsRare == ?MON_CL_CRYSTAL orelse IsRare == ?MON_CL_NORMAL orelse IsRare == ?MON_CL_RARE orelse IsRare == ?MON_CL_TASK -> %% 采集怪
            case get_one_boss(ZoneId, EudemonsBossMap, BossId) of
                {ZoneId, ZoneBossMap, Boss} ->
                    #eudemons_boss_status{reborn_ref = RebornRef, remind_ref = RemindRef} = Boss,
                    util:cancel_timer(RemindRef),
                    util:cancel_timer(RebornRef),
                    PoolId = get_pool_id(ZoneId),
                    lib_mon:clear_scene_mon_by_mids(Scene, PoolId, ZoneId, 1, [BossId]),
                    NowTime = utime:unixtime(),
                    NewBoss = cl_boss_reborn(ZoneId, NowTime, BossCfg, 0, [], []),
                    NewZoneBossMap = maps:put(BossId, NewBoss, ZoneBossMap),
                    NewZoneEudemonsBossMap = maps:put(ZoneId, NewZoneBossMap, EudemonsBossMap),
                    %% 通知各节点boss重生(区域广播)
                    mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_eudemons_land_local, board_eudemos_boss_reborn, [BossType, BossId, NewBoss]),
                    {noreply, State#kf_eudemons_boss_state{boss_eudemons_map = NewZoneEudemonsBossMap}};
                _ ->
                    {noreply, State}
            end;
        #eudemons_boss_cfg{type = BossType} -> %% boss秘籍刷新
            {noreply, NewState} = do_handle_info({'boss_reborn', ZoneId, BossType, BossId}, State),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({'handle_merge_server', ServerId, MergeSerIds}, State) ->
    #kf_eudemons_boss_state{score_map = ScoreMap} = State,
    ChangeServerList = lists:delete(ServerId, MergeSerIds),
    NewScoreMap = merge_server(ScoreMap, ServerId, ChangeServerList),
    {noreply, State#kf_eudemons_boss_state{score_map = NewScoreMap}};

do_handle_cast(Msg, State)->
    ?ERR("Boss Cast No Match:~w~n", [Msg]),
    {noreply, State}.

%% info
%% boss初始化
% do_handle_info('boss_init', State) ->
%     case mod_eudemons_land_zone:get_zone_list() of
%         {true, in_reset, ResetETime} ->
%             {noreply, State#kf_eudemons_boss_state{reset_etime = ResetETime}};
%         {true, ZoneList, _NextResetTime} ->
%             NewState = init_boss_status(ZoneList, State),
%             {noreply, NewState};
%         _Err ->
%             {noreply, State}
%     end;

%% boss重生提醒
do_handle_info({'boss_remind', ZoneId, BossType, BossId}, State)->
    #kf_eudemons_boss_state{boss_eudemons_map = ZoneEudemonsBossMap} = State,
    case get_one_boss(ZoneId, ZoneEudemonsBossMap, BossId) of
        {ZoneId, ZoneBossMap, Boss} ->
            #eudemons_boss_status{remind_ref = RemindRef} = Boss,
            util:cancel_timer(RemindRef),
            %% 通知分区节点发送重生提醒
            mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_eudemons_land_local,
                                            board_eudemos_boss_remind, [BossType, BossId]),
            NewZoneBossMap = maps:put(BossId, Boss#eudemons_boss_status{remind_ref = undefined}, ZoneBossMap),
            NewZoneEudemonsBossMap = maps:put(ZoneId, NewZoneBossMap, ZoneEudemonsBossMap),
            {noreply, State#kf_eudemons_boss_state{boss_eudemons_map = NewZoneEudemonsBossMap}};
        _ ->
            {noreply, State}
    end;

%% boss重生
do_handle_info({'boss_reborn', ZoneId, BossType, BossId}, State)->
    %?PRINT("boss_reborn ~p~n", [{BossType, BossId}]),
    #kf_eudemons_boss_state{boss_eudemons_map = ZoneEudemonsBossMap} = State,
    case get_one_boss(ZoneId, ZoneEudemonsBossMap, BossId) of
        {ZoneId, ZoneBossMap, Boss} ->
            #eudemons_boss_status{reborn_ref = RebornRef, remind_ref = RemindRef, pos_list = OldPosList} = Boss,
            util:cancel_timer(RemindRef),
            util:cancel_timer(RebornRef),
            PoolId = get_pool_id(ZoneId),
            case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
                #eudemons_boss_cfg{scene = Scene, is_rare = IsRare} = BossCfg ->
                    NowTime = utime:unixtime(),
                     if
                         IsRare >= ?MON_CL_NORMAL -> %% 采集怪
                             NewBoss = cl_boss_reborn(ZoneId, NowTime, BossCfg, 0, [], OldPosList);
                         true -> %% boss
                            lib_mon:clear_scene_mon_by_mids(Scene, PoolId, ZoneId, 1, [BossId]),
                            NewBoss = boss_reborn(ZoneId, NowTime, BossCfg, 0)
                     end,
                    NewZoneBossMap = maps:put(BossId, NewBoss, ZoneBossMap),
                    NewZoneEudemonsBossMap = maps:put(ZoneId, NewZoneBossMap, ZoneEudemonsBossMap),
                    case IsRare == ?MON_CL_TASK of
                        true -> %% 任务采集怪不需要同步到游戏服
                            skip;
                        _ ->
                            %% 通知各节点boss重生(区域广播)
                            mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_eudemons_land_local, board_eudemos_boss_reborn, [BossType, BossId, NewBoss])
                    end,
                    {noreply, State#kf_eudemons_boss_state{boss_eudemons_map = NewZoneEudemonsBossMap}};
                _ ->
                    %% 通知所有节点发送删除某一个boss(区域广播)
                    ?ERR("boss_reborn_remove:~p~n", [[ZoneId, BossType, BossId]]),
                    mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_eudemons_land_local,
                                                    board_eudemos_boss_delete,
                                                    [BossType, BossId]),
                    NewZoneBossMap = maps:remove(BossId, ZoneBossMap),
                    NewZoneEudemonsBossMap = maps:put(ZoneId, NewZoneBossMap, ZoneEudemonsBossMap),
                    {noreply, State#kf_eudemons_boss_state{boss_eudemons_map = NewZoneEudemonsBossMap}}
            end;
        _ ->
            ?ERR("boss_reborn_error:~p~n", [[ZoneId, BossType, BossId]]),
            {noreply, State}
    end;

do_handle_info({clean_killer_info}, State) ->
    #kf_eudemons_boss_state{killer_map = KillerMap, ref_clean_killer = OldRefCleanKiller} = State,
    RefCleanKiller = util:send_after(OldRefCleanKiller, 3600*1000, self(), {clean_killer_info}),
    NowTime = utime:unixtime(),
    TimeGap = ?TIME_GAP_1,
    F = fun(_RoleId, DerList) ->
        [{DerId, KillTime} || {DerId, KillTime} <- DerList, (NowTime - KillTime) < TimeGap]
    end,
    NewKillMap = maps:map(F, KillerMap),
    {noreply, State#kf_eudemons_boss_state{killer_map = NewKillMap, ref_clean_killer = RefCleanKiller}};

do_handle_info(_Info, State) ->
    ?ERR("Boss Info No Match:~w~n", [_Info]),
    {noreply, State}.


%% ================================= private fun =================================
% init_boss_status(ZoneIdList, State) ->
%     AllBossIds = data_eudemons_land:get_all_eudemons_boss_id(),
%     NowTime = utime:unixtime(),
%     F = fun(ZoneId, LineBossMap) ->
%             %% boss init
%             DbList = get_boss_db_info(ZoneId, NowTime, AllBossIds),
%             EudemonsBoss = create_zone_boss(ZoneId, DbList, NowTime),
%             LineBossMap#{ZoneId => EudemonsBoss}
%     end,
%     LinesEudemonsBoss = lists:foldl(F, #{}, ZoneIdList),
%     State#kf_eudemons_boss_state{boss_eudemons_map = LinesEudemonsBoss}.

%% 重置完毕：1：重置所有区的boss， 2：同步个服信息
reset_end(State) ->
    % ZoneIdList = maps:keys(ZoneMap),
    % State1 = init_boss_status(ZoneIdList, State),
    % spawn(fun() -> sync_all_server_boss_info(ZoneIdList, NextResetTime, ZoneMap, ServerMap, State1) end),
    State#kf_eudemons_boss_state{act_status = 1}.

% sync_all_server_boss_info(ZoneIdList, _NextResetTime, ZoneMap, ServerMap, State) ->
%     #kf_eudemons_boss_state{boss_eudemons_map = LinesEudemonsBoss} = State,
%     F = fun(ZoneId) ->
%         case get_one_zone_boss_map(ZoneId, LinesEudemonsBoss) of
%             {ok, _ZoneId, ZoneBossMap} ->
%                 {Mod, Fun, Args} = {mod_eudemons_land_local, board_eudemos_boss_info, [ZoneId, 1, 0, ZoneBossMap]},
%                 broadcast_to_zone(ZoneId, ZoneMap, ServerMap, Mod, Fun, Args),
%                 %mod_eudemons_land_zone:apply_to_zone_cast_do(ZoneId, ZoneMap, ServerMap, Mod, Fun, Args),
%                 timer:sleep(200);
%             _R ->
%                 skip
%         end
%     end,
%     lists:foreach(F, ZoneIdList).

%% 获取boss信息
get_boss_db_info(ZoneId, NowTime, AllBossIds)->
    SQL = io_lib:format(<<" select boss_id, reborn_time, optional_data from eudemons_boss_kf where zone_id = ~p">>, [ZoneId]),
    {DbList, DelList, LessBossIds}
        = case db:get_all(SQL) of
              BossList when is_list(BossList)->
                  F = fun([BossId, RebornTime, OptionalDataB], {LefL, DelL, LessL})->
                                OptionalData = util:bitstring_to_term(OptionalDataB),
                              case lists:member(BossId, AllBossIds)  of
                                  false -> %% del
                                      {LefL, [BossId|DelL], lists:delete(BossId, LessL)};
                                  true ->
                                      NewRebornTime =  ?IF(RebornTime =< NowTime, 0, RebornTime),
                                      {[{BossId, NewRebornTime, OptionalData}|LefL], DelL, lists:delete(BossId, LessL)}
                              end
                      end,
                  lists:foldl(F, {[], [], AllBossIds}, BossList);
              _ ->
                  {[], [], AllBossIds}
          end,
    case length(DelList) > 0 of
        true ->
            IdString = util:link_list(DelList),
            DelbossSQL = io_lib:format("delete from eudemons_boss_kf where boss_id in (~s) and zone_id = ~p", [IdString, ZoneId]),
            db:execute(DelbossSQL);
        _ -> skip
    end,
    DbList ++ [ {LLBossId, 0, []} || LLBossId <- LessBossIds].

%% 更新幻兽之域boss疲劳
handle_boss_be_kill(_ZoneId, BossType, BossId, Atter, FirstAttr, BLWhos, MonArgs, Minfo)->
    F = fun({RId, RNode}) ->
        KillBossList = get_role_kill_boss_list(RId),
        NextKillId = get_next_kill_id(KillBossList),
        NewKillBossList = [{NextKillId, {Minfo, MonArgs, Atter, FirstAttr, BLWhos}}|KillBossList],
        mod_clusters_center:apply_cast(RNode, lib_eudemons_land, handle_boss_be_kill, [RId, BossType, BossId, Minfo#scene_object.figure#figure.lv, NextKillId]),
        update_role_kill_boss_list(RId, NewKillBossList)
    end,
    case BLWhos of
        [] -> skip;
        _ ->
            L = [{P#mon_atter.id, P#mon_atter.node} || P <- BLWhos],
            lists:foreach(F, L)
    end.

do_boss_be_kill(_ServerId, ZoneId, BossType, _BossMap, Boss, Atter, FirstAttr, BLWhos, RoleInfos, MonArgs, Minfo) ->
    #battle_return_atter{id = AttrId, real_name = AttrName} = Atter,
    NowTime = utime:unixtime(),
    PoolId = get_pool_id(ZoneId),
    #eudemons_boss_status{boss_id = BossId, remind_ref = RemindRef, reborn_ref = RebornRef, num = Num} = Boss,
    util:cancel_timer(RemindRef),
    util:cancel_timer(RebornRef),
    #eudemons_boss_cfg{scene = Scene, reborn_time = RebornTime} = data_eudemons_land:get_eudemons_boss_cfg(BossId),
    RebornEndTime = NowTime + RebornTime,
    %% 重生定时器
    NRebornRef = erlang:send_after(RebornTime*1000, self(),
                                   {'boss_reborn', ZoneId, BossType, BossId}),
    %% 提醒定时器
    RemindTime = max(0, RebornTime-?EUDEMONS_REMIND_TIME),
    NRemindRef = ?IF(RemindTime =< 0, undefined,
                     erlang:send_after(RemindTime *1000, self(),
                                       {'boss_remind', ZoneId, BossType, BossId})),
    %% 更新boss重生时间
    spawn(fun() -> update_boss_reborn_time(ZoneId, BossId, RebornEndTime, []) end),
    %% 击杀记录
    NewBoss = Boss#eudemons_boss_status{ reborn_time = RebornEndTime,
                                         remind_ref = NRemindRef, reborn_ref = NRebornRef},
    %% boss击杀处理
    handle_boss_be_kill(ZoneId, BossType, BossId, Atter, FirstAttr, BLWhos, MonArgs, Minfo),
    %% 广播boss死亡信息
    {ok, Bin} = pt_470:write(47007, [BossType, BossId, RebornEndTime, max(0, Num - 1)]),
    lib_server_send:send_to_scene(Scene, PoolId, ZoneId, Bin),
    %% 幻兽击杀日志
    spawn(fun() -> log_eudemons_land_boss(BossId, AttrId, AttrName, BLWhos, RoleInfos, ZoneId) end),
    % case [{P#mon_atter.id, P#mon_atter.node}|| P <- BLWhos] of
    %     [] ->
    %         skip;
    %     BLIds ->
    %         [begin
    %         %% boss击杀任务
    %         mod_clusters_center:apply_cast(BlNode, lib_task_api, kill_boss, [BlId, ?BOSS_TYPE_PHANTOM, MonArgs#mon_args.lv]),
    %         AchmArgs = [AttrId, ?APPLY_CAST_SAVE, lib_achievement_api, boss_achv_finish, [?BOSS_TYPE_PHANTOM, BossId]],
    %         mod_clusters_center:apply_cast(BlNode, lib_player, apply_cast, AchmArgs),
    %         %% 争夺值
    %         mod_clusters_center:apply_cast(BlNode, lib_local_chrono_rift_act, role_success_finish_act, [BlId, ?MOD_EUDEMONS_BOSS, BossType, 1]),
    %         %% 日常
    %         mod_clusters_center:apply_cast(BlNode, lib_activitycalen_api, role_success_end_activity, [BlId, ?MOD_EUDEMONS_BOSS, BossType])
    %         end || {BlId, BlNode} <- BLIds]
    % end,
    NewBoss.

boss_be_collect(ServerId, ZoneId, BossCfg, BossType, Boss, AttrId, _AttrName, FirstAttr, _BLWhos, MonArgs) ->
    #eudemons_boss_cfg{is_rare = IsRare, scene = Scene} = BossCfg,
    #eudemons_boss_status{boss_id = BossId, num = Num, pos_list = PosList, reborn_time = RebornTime} = Boss,
    case IsRare == ?MON_CL_TASK of
        true ->
            update_boss_collect_times(ServerId, BossType, BossId, AttrId, FirstAttr, MonArgs),
            Boss;
        _ ->
            #mon_args{id = _Id, collect_times = _CollectTimes, d_x = X, d_y = Y} = MonArgs,
            PoolId = get_pool_id(ZoneId),
            %NewOptionalData = lists:keystore({BossType, BossId}, 1, OptionalData, {{BossType, BossId}, CollectTimes}),
            NewOptionalData = [],
            NewPosList = lists:delete({X, Y}, PosList),
            NewBoss = Boss#eudemons_boss_status{num = max(0, Num-1), pos_list = NewPosList, optional_data = NewOptionalData},
            update_boss_reborn_time(ZoneId, BossId, RebornTime, NewOptionalData),
            update_boss_collect_times(ServerId, BossType, BossId, AttrId, [], []),
            {ok, Bin} = pt_470:write(47007, [BossType, BossId, RebornTime, max(0, Num-1)]),
            %SendPosList = [{X, Y} ||{_, X, Y} <- NewPosList],
            SendPosList = NewPosList,
            %?PRINT("boss_be_collect NewPosList ~p~n", [NewPosList]),
            {ok, Bin1} = pt_470:write(47018, [BossId, SendPosList]),
            lib_server_send:send_to_scene(Scene, PoolId, ZoneId, Bin),
            lib_server_send:send_to_scene(Scene, PoolId, ZoneId, Bin1),
            NewBoss
    end.

small_mon_be_kill(_Scene, _PoolId, MonId, ServerId, _ServerNum, AttrId, _AttrName, _FirstAttr, BLWhos, _MonArgs) ->
    F = fun({RId, SerId}) ->
            mod_clusters_center:apply_cast(SerId, lib_eudemons_land, small_mon_be_kill, [RId, MonId])
    end,
    case BLWhos of
        [] -> lists:foreach(F, [{AttrId, ServerId}]);
        _ ->
            L = [{P#mon_atter.id, P#mon_atter.server_id} || P <- BLWhos],
            lists:foreach(F, L)
    end.

update_boss_collect_times(ServerId, BossType, BossId, AttrId, FirstAttr, MonArgs) ->
    mod_clusters_center:apply_cast(ServerId, lib_eudemons_land, update_boss_collect_times, [BossType, BossId, AttrId, FirstAttr, MonArgs]).

%% 记录日志
log_eudemons_land_boss(BossId, AttrId, AttrName, BLWhos, RoleInfos, ZoneId)->
    NowTime = utime:unixtime(),
    case dict:find({ZoneId, AttrId}, RoleInfos) of
        error -> KPForm = "none", KSName = "none";
        {ok, KillRoleInfo} ->
            #eudemons_boss{plat_form = KPForm, server_name = KSName} = KillRoleInfo
    end,
    F = fun(#mon_atter{id = BlId}, BlList) ->
                if
                    AttrId == BlId -> [uio:format("{1}_{2}_{3}_{4}", [AttrId, AttrName, KPForm, KSName])|BlList];
                    true ->
                        case dict:find({ZoneId, BlId}, RoleInfos) of
                            error -> [uio:format("{1}_{2}_{3}_{4}", [BlId, none, none, none])|BlList];
                            {ok, #eudemons_boss{name = BlName, plat_form = BlPForm, server_name = BlSName}} ->
                                [uio:format("{1}_{2}_{3}_{4}", [BlId, BlName, BlPForm, BlSName])|BlList]
                        end
                end
        end,
    case lists:foldl(F, [], BLWhos) of
        [Bl1, Bl2, Bl3] -> skip;
        [Bl1, Bl2] -> Bl3 = "none";
        [Bl1] -> Bl2 = "none", Bl3 = "none";
        _ -> Bl1 = "none", Bl2 = "none", Bl3 = "none"
    end,
    lib_log_api:log_eudemons_land_boss(ZoneId, BossId, AttrId, AttrName, KPForm, KSName, Bl1, Bl2, Bl3, NowTime).

%% 更新幻兽之域采集怪物信息
% update_boss_cl_info(ZoneId, AttrId, RoleInfos, BossCfg, Scene, PoolId)->
%     case dict:find({ZoneId, AttrId}, RoleInfos) of
%         error -> RoleInfos;
%         {ok, RoleEudemonsBoss} ->
%             #eudemons_boss{node = Node, cl_boss_info = ClBossCountInfo} = RoleEudemonsBoss,
%             #eudemons_boss_cfg{boss_id = BossId, type = BossType, is_rare = IsRare,
%                                module_id = ModId, counter_id = CId} = BossCfg,
%             Key = {ModId, ?DEF_SUB_MOD, CId},
%             NewClBossCountInfo = case lists:keyfind(Key, 1, ClBossCountInfo) of
%                                      false -> ClBossCountInfo;
%                                      {_, ClCount} -> lists:keystore(Key, 1, ClBossCountInfo, {Key, ClCount+1})
%                                  end,
%             NewRoleEudemonsBoss = RoleEudemonsBoss#eudemons_boss{cl_boss_info = NewClBossCountInfo},
%             lib_eudemons_land:send_cl_tips(NewClBossCountInfo, Key, BossType, IsRare, Node, AttrId),
%             mod_clusters_center:apply_cast(Node, lib_player, update_player_info, [AttrId, [{eudemons_boss_clinfo, [BossId, NewClBossCountInfo]}]]),
%             mod_scene_agent:update(Scene, PoolId, AttrId, [{eudemons_boss_clinfo, NewClBossCountInfo}]),
%             AchmArgs = [AttrId, ?APPLY_CAST_SAVE, lib_achievement_api, eudemons_boss_collect_event, [BossId]],
%             mod_clusters_center:apply_cast(Node, lib_player, apply_cast, AchmArgs),
%             dict:store({ZoneId, AttrId}, NewRoleEudemonsBoss, RoleInfos)
%     end.

%% 采集怪刷新
cl_boss_reborn(ZoneId, NowTime, BossCfg, RebornTime, _OptionalData, OldPosList)->
    #eudemons_boss_cfg{boss_id = BossId, type = BossType, scene = Scene, is_rare = _IsRare,
                       num = Num, reborn_time = DefRebornTime, fixed_xy = _FixedXy, rand_xy = RandXy} = BossCfg,
    CreateNum = max(0, Num - length(OldPosList)),
    PoolId = get_pool_id(ZoneId),
    RebornSpanTime = max(0, RebornTime - NowTime),
    case RebornSpanTime > 0 of
        true ->
            NewRebornTime = RebornTime,
            NewReBornRef = erlang:send_after(RebornSpanTime * 1000, self(), {'boss_reborn', ZoneId, BossType, BossId}),
            ClMonArgs = [], NewOptionalData = [];
            % case lists:keyfind({BossType, BossId}, 1, OptionalData) of
            %     {_, CollectTimes} -> ClMonArgs = [], NewOptionalData = OptionalData;
            %     _ -> ClMonArgs = [], NewOptionalData = []
            % end;
        _ ->
            NewRebornTime = NowTime+DefRebornTime,
            NewReBornRef = erlang:send_after(DefRebornTime * 1000, self(), {'boss_reborn', ZoneId, BossType, BossId}),
            ClMonArgs = [], NewOptionalData = []
    end,
    %?PRINT(IsRare==3,"cl_boss_reborn  ~p~n", [{RebornSpanTime, DefRebornTime}]),
    case CreateNum > 0 of
        true ->
            NewRandXy = ulists:list_shuffle(RandXy),
            LastRandXy = NewRandXy -- OldPosList,
            F = fun(_I, {XyList, PosList}) ->
                [{X, Y}|LeftXyList] = XyList,
                lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, PoolId, X, Y, 1, ZoneId, 1, ClMonArgs),
                {LeftXyList, [{X, Y}|PosList]}
            end,
            {_, NewPosList} = lists:foldl(F, {LastRandXy, OldPosList}, lists:seq(1, CreateNum)),
            %?PRINT("cl_boss_reborn OldPosList ~p~n", [OldPosList]),
            %?PRINT("cl_boss_reborn NewPosList ~p~n", [NewPosList]),
            %?PRINT("cl_boss_reborn add pos ~p~n", [NewPosList--OldPosList]),
            %% 广播boss|采集怪物重生信息
            {ok, Bin} = pt_470:write(47008, [BossType, BossId, NewRebornTime, Num]),
            %% 广播采集怪坐标信息
            %SendPosList = [{X, Y} ||{_, X, Y} <- NewPosList],
            SendPosList = NewPosList,
            {ok, Bin2} = pt_470:write(47018, [BossId, SendPosList]),
            lib_server_send:send_to_scene(Scene, PoolId, ZoneId, Bin),
            lib_server_send:send_to_scene(Scene, PoolId, ZoneId, Bin2),
            lib_mon:get_scene_mon(Scene, PoolId, ZoneId, [#scene_object.config_id]),
            #eudemons_boss_status{boss_id = BossId, reborn_time = NewRebornTime, pos_list = NewPosList, reborn_ref = NewReBornRef, optional_data = NewOptionalData};
        _ ->
            #eudemons_boss_status{boss_id = BossId, reborn_time = NewRebornTime, pos_list = OldPosList, reborn_ref = NewReBornRef, optional_data = NewOptionalData}
    end.

%% boss重生
boss_reborn(ZoneId, NowTime, BossCfg, RebornTime)->
    #eudemons_boss_cfg{boss_id = BossId, type = BossType, scene = Scene, fixed_xy = FixedXy} = BossCfg,
    PoolId = get_pool_id(ZoneId),
    RebornSpanTime = max(0, RebornTime - NowTime),
    if
        RebornSpanTime > 0 ->
            RemindTime = max(1, RebornSpanTime-?EUDEMONS_REMIND_TIME),
            RemindRef = ?IF(RemindTime =< 0, undefined,
                            erlang:send_after(RemindTime *1000, self(), {'boss_remind', ZoneId, BossType, BossId})),
            RebornRef = erlang:send_after(RebornSpanTime*1000, self(),  {'boss_reborn', ZoneId, BossType, BossId}),
            #eudemons_boss_status{ boss_id = BossId, num = 1, reborn_time = RebornTime,
                                   remind_ref = RemindRef, reborn_ref = RebornRef};
        true ->
            [{X, Y}|_] = FixedXy,
            lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, PoolId, X, Y, 1, ZoneId, 1, []),
            %% 广播boss|采集怪物重生信息
            {ok, Bin} = pt_470:write(47008, [BossType, BossId, 0, 1]),
            lib_server_send:send_to_scene(Scene, PoolId, ZoneId, Bin),
            #eudemons_boss_status{boss_id = BossId, num = 1}
    end.

%% 小怪物初始化
%eudemons_small_mon_init(_ZoneId, [])-> skip;
eudemons_small_mon_init(ZoneId, _SceneIds)->
    PoolId = get_pool_id(ZoneId),
    #eudemons_boss_type{mon_ids = MonCreateList} = data_eudemons_land:get_eudemons_boss_type(?BOSS_TYPE_EUDEMONS),
    eudemons_small_mon_init_do(MonCreateList, PoolId, ZoneId).

eudemons_small_mon_init_do([], _PoolId, _ZoneId) -> ok;
eudemons_small_mon_init_do([{SceneId, MonList}|MonCreateList], PoolId, ZoneId) ->
    eudemons_small_mon_init_helper(SceneId, PoolId, ZoneId, MonList),
    eudemons_small_mon_init_do(MonCreateList, PoolId, ZoneId).

eudemons_small_mon_init_helper(_SceneId, _PoolId, _ZoneId, []) -> ok;
eudemons_small_mon_init_helper(SceneId, PoolId, ZoneId, [{MonId, XYList}|MonList]) ->
    CreateList = [[?BATTLE_SIGN_MON, MonId, X, Y, 1, []] || {X, Y} <- XYList],
    lib_scene_object:async_create_objects(SceneId, PoolId, ZoneId, 1, CreateList),
    eudemons_small_mon_init_helper(SceneId, PoolId, ZoneId, MonList).


    % case lib_eudemons_land:get_eudemons_scene_mon(SceneId) of
    %     [] ->
    %         eudemons_small_mon_init(ZoneId, SceneIds);
    %     MonList ->
    %         Fun = fun(X) ->
    %                       do_eudemons_small_mon_init(ZoneId, SceneId, X)
    %               end,
    %         lists:map(Fun, MonList),
    %         eudemons_small_mon_init(ZoneId, SceneIds)
    % end.

% do_eudemons_small_mon_init(ZoneId, SceneId, [MonId, Num, XyList])->
%     do_eudemons_create_small_mon(ZoneId, SceneId, MonId, Num, XyList);
% do_eudemons_small_mon_init(_ZoneId, _SceneId, _MonList) ->
%     skip.

% do_eudemons_create_small_mon(_ZoneId, _SceneId, _MonId, _Num, [])-> ok;
% do_eudemons_create_small_mon(_ZoneId, _SceneId, _MonId, 0, _XyList)-> ok;
% do_eudemons_create_small_mon(ZoneId, SceneId, MonId, Num, [{X,Y}|XyList])->
%     lib_scene_object:async_create_object(?BATTLE_SIGN_MON, MonId, SceneId, 0, X, Y, 1, ZoneId, 1, []),
%     do_eudemons_create_small_mon(ZoneId, SceneId, MonId, Num-1, XyList);
% do_eudemons_create_small_mon(ZoneId, SceneId, MonId, Num, [_|XyList]) ->
%     do_eudemons_create_small_mon(ZoneId, SceneId, MonId, Num-1, XyList).

create_zone_boss(ZoneId, BossList, NowTime) ->
    Fun = fun({BossId, RebornTime, OptionalData}, {BossMap, SceneIds}) ->
              case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
                  #eudemons_boss_cfg{is_rare = IsRare, scene = SceneId} = BossCfg->
                    Boss = case IsRare >= ?MON_CL_NORMAL of
                        true ->
                            cl_boss_reborn(ZoneId, NowTime, BossCfg, RebornTime, OptionalData, []);
                        _ ->
                            PoolId = get_pool_id(ZoneId),
                            lib_mon:clear_scene_mon_by_mids(SceneId, PoolId, ZoneId, 1, [BossId]),
                            boss_reborn(ZoneId, NowTime, BossCfg, RebornTime)
                    end,
                      NewBossMAp = BossMap#{BossId => Boss},
                      case lists:member(SceneId, SceneIds) of
                          true ->
                              {NewBossMAp, SceneIds};
                          false ->
                              {NewBossMAp, [SceneId|SceneIds]}
                      end;
                  _ ->
                      ?ERR("can't find boss cfg:~p~n", [BossId]),
                      {BossMap, SceneIds}
              end
      end,
    {EudemonsBoss, AllSceneIds} = lists:foldl(Fun, {#{}, []}, BossList),
    %% mon init
    %% 小怪初始化
    eudemons_small_mon_init(ZoneId, AllSceneIds),
    EudemonsBoss.

create_zone_boss(ZoneId) ->
    AllBossIds0 = data_eudemons_land:get_all_eudemons_boss_id(),
    F = fun(BossId) ->
        #eudemons_boss_cfg{layers = Layer} = data_eudemons_land:get_eudemons_boss_cfg(BossId),
        Layer > 0
    end,
    AllBossIds = lists:filter(F, AllBossIds0), % 过滤掉第0层(无限层)boss
    NowTime = utime:unixtime(),
    DbList = get_boss_db_info(ZoneId, NowTime, AllBossIds),
    EudemonsBoss = create_zone_boss(ZoneId, DbList, NowTime),
    EudemonsBoss.

leave_scene_force(RolesZoneDict) ->
    F = fun(_, Role, Acc) ->
        #eudemons_boss{role_id = RoleId, server_id = ServerId} = Role,
        mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
                                   [RoleId, 0, 0, 0, 0, 0, true, [{collect_checker, undefined}]]),
        Acc
    end,
    dict:fold(F, 0, RolesZoneDict).

clear_all_scene_boss(LineBossMap) ->
    SceneList = data_eudemons_land:get_eudemons_boss_type_scene(?BOSS_TYPE_EUDEMONS),
    F = fun(ZoneId, BossMap, Acc) ->
        FI = fun(_, #eudemons_boss_status{remind_ref = RemindRef, reborn_ref = RebornRef}, AccI) ->
            util:cancel_timer(RemindRef), util:cancel_timer(RebornRef), AccI
        end,
        maps:fold(FI, 0, BossMap),
        PoolId = get_pool_id(ZoneId),
        [PoolId|lists:delete(PoolId, Acc)]
    end,
    PoolList = maps:fold(F, [], LineBossMap),
    [lib_scene:clear_scene(SceneId, PoolId) || SceneId <- SceneList, PoolId <- PoolList].

get_pool_id(ZoneId) ->
    ZoneId rem 12 + 1.

%% 获取一个分区里面的数据{ZoneId, ZoneBossMap}
% get_one_zone_boss_map(ZoneId, LinesEudemonsBoss)->
%     case maps:get(ZoneId, LinesEudemonsBoss, false) of
%         false -> no_zone;
%         ZoneBossMap -> {ok, ZoneId, ZoneBossMap}
%     end.

get_one_zone_boss_map(ZoneId, LinesEudemonsBoss) when ZoneId>0 ->
    case maps:get(ZoneId, LinesEudemonsBoss, false) of
        false ->
            ZoneBossMap = create_zone_boss(ZoneId),
            NewLineEudemonsBoss = maps:put(ZoneId, ZoneBossMap, LinesEudemonsBoss),
            {ok, ZoneId, ZoneBossMap, NewLineEudemonsBoss};
        ZoneBossMap -> {ok, ZoneId, ZoneBossMap, LinesEudemonsBoss}
    end;
get_one_zone_boss_map(_ZoneId, _LinesEudemonsBoss) ->
    no_zone.

get_one_zone_score_map(ZoneId, ScoreMap) when ZoneId > 0 ->
    case maps:get(ZoneId, ScoreMap, false) of
        false ->
            NewScoreMap = maps:put(ZoneId, [], ScoreMap),
            {ok, ZoneId, [], NewScoreMap};
        PlayerScoreList -> {ok, ZoneId, PlayerScoreList, ScoreMap}
    end;
get_one_zone_score_map(_ZoneId, _ScoreMap) ->
    no_zone.

get_one_boss(ZoneId, LinesEudemonsBoss, BossId) ->
    case maps:get(ZoneId, LinesEudemonsBoss, false) of
        false -> no_zone;
        ZoneBossMap ->
            case maps:get(BossId, ZoneBossMap, false) of
                false -> no_zone;
                #eudemons_boss_status{} = Boss ->
                    {ZoneId, ZoneBossMap, Boss}
            end
    end.

%% 获取一个分区里面的数据{ZoneId, ZoneBossMap, Boss}
get_zone_boss_map(ServerId, BossId, LinesEudemonsBoss) ->
    case get_zone_id(ServerId) of
        0 ->
            no_zone;
        ZoneId ->
            get_one_boss(ZoneId, LinesEudemonsBoss, BossId)
    end.

get_zone_id(ServerId) ->
    lib_clusters_center_api:get_zone(ServerId).

check_is_resettine(State) ->
    #kf_eudemons_boss_state{act_status = ActStatus, reset_etime = _ResetETime} = State,
    ActStatus == 2 .

update_boss_reborn_time(ZoneId, BossId, RebornTime, OptionalData) ->
    SQL = <<"replace into `eudemons_boss_kf` set `zone_id` = ~p, `boss_id` = ~p, `reborn_time` = ~p, `optional_data` = '~s'">>,
    db:execute(io_lib:format(SQL, [ZoneId, BossId, RebornTime, util:term_to_bitstring(OptionalData)])).

broadcast_to_zone(ZoneId, ZoneMap, ServerMap, M, F, A) ->
    SerList = maps:get(ZoneId, ZoneMap, []),
    [begin
        case maps:get(SerId, ServerMap, false) of
            #eudemons_server{optime = OpTime} ->
                case util:check_open_day_2(?EUDEMONS_BOSS_OPEN_DAY, OpTime) of
                    true ->
                        mod_clusters_center:apply_cast(SerId, M, F, A);
                    _ -> skip
                end;
            _ -> skip
        end
    end || SerId <- SerList].

send_collect_boss_info(ServerId, RoleId, Scene, State) ->
    #kf_eudemons_boss_state{boss_eudemons_map = ZoneEudemonsBossMap} = State,
    ZoneId = get_zone_id(ServerId),
    case get_one_zone_boss_map(ZoneId, ZoneEudemonsBossMap) of
        {ok, _ZoneId, ZoneBossMap, _NewEudemonsBossMap} ->
            F = fun(BossId, #eudemons_boss_status{pos_list = PosList}, List) ->
                case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
                    #eudemons_boss_cfg{is_rare = IsRare, scene = Scene} when IsRare >= ?MON_CL_NORMAL ->
                        %SendPosList = [{X, Y} || {_Id, X, Y} <- PosList],
                        SendPosList = PosList,
                        [{BossId, SendPosList}|List];
                    _ ->
                        List
                end
            end,
            SendList = maps:fold(F, [], ZoneBossMap),
            %?PRINT("send_collect_boss_info SendList: ~p~n", [SendList]),
            {ok, Bin} = pt_470:write(47017, [SendList]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]),
            ok;
        _ ->
            ok
    end.

%% 依据死亡次数以及当前时间计算死亡等待时间
count_die_wait_time(DieTimes, NowTime) ->
    case data_boss:get_boss_type_kv(?BOSS_TYPE_PHANTOM, die_wait_time) of
        [{min_times, MinTimes},{special, SpecialList},{extra, WaitTime}]  ->
            RebornTime = if
                DieTimes =< MinTimes ->
                    NowTime;
                true ->
                    case lists:keyfind(DieTimes, 1, SpecialList) of
                        {DieTimes, WaitTime1} ->
                            NowTime + WaitTime1;
                        _ ->
                            NowTime + WaitTime
                    end
            end,
            RebornTime;
        _ -> MinTimes = 0, RebornTime = NowTime
    end,
    {RebornTime, MinTimes}.


check_kill_is_valid(_ZoneId, AtterInfo, DerInfo, KillerMap, NowTime) ->
    [AUid, _AttName, AttLv, AtterSign, _AttGuildId, AttServerId, _AttServerNum|_] = AtterInfo,
    [DieId, _DeadName, DeadLv, _DeadGuildId, ServerId, _ServerNum|_] = DerInfo,
    case AttServerId =/= ServerId andalso AtterSign == ?BATTLE_SIGN_PLAYER of
        true ->
            case AttLv - DeadLv >= ?LEVEL_GAP_1 of
                false ->
                    DerList = maps:get(AUid, KillerMap, []),
                    case lists:keyfind(DieId, 1, DerList) of
                        {DieId, DieTime} ->
                            case NowTime - DieTime >= ?TIME_GAP_1 of
                                true -> true;
                                _ ->
                                    false
                            end;
                        _ ->
                            true
                    end;
                _ ->
                    false
            end;
        _ ->
            false
    end.

update_killer_map(KillerMap, AtterInfo, DerInfo, NowTime) ->
    [AUid|_] = AtterInfo,
    [DieId|_] = DerInfo,
    DerList = maps:get(AUid, KillerMap, []),
    NewDerList = [{DieId, NowTime}|lists:keydelete(DieId, 1, DerList)],
    maps:put(AUid, NewDerList, KillerMap).

update_role_score(ZoneId, ScoreMap, AtterInfo, ScoreType, AddScore) ->
    %?PRINT("update_role_score ###### start ~p~n", [{ScoreType, AddScore}]),
    [AUid, AttName, AttServerId, AttServerNum] = AtterInfo,
    case get_one_zone_score_map(ZoneId, ScoreMap) of
        {ok, ZoneId, PlayerScoreList, ScoreMap1} when AddScore > 0 ->
            NowTime = utime:unixtime(),
            case lists:keyfind(AUid, #player_score.role_id, PlayerScoreList) of
                #player_score{score = OldScore, sort_key1 = SK1, total_score = OldTotalScore} = PlayerScore ->
                    {NewScore, NewSK1} = ?IF(ScoreType == ?SCORE_TYPE_2, {OldScore+AddScore, NowTime}, {OldScore, SK1}), %% 只有击杀boss才会增加score字段
                    NewPlayerScore = PlayerScore#player_score{
                        role_name = AttName, server_id = AttServerId, server_num = AttServerNum, zone_id = ZoneId,
                        score = NewScore, sort_key1 = NewSK1, total_score = OldTotalScore + AddScore, sort_key3 = NowTime
                    };
                _ ->
                    {NewScore, NewSK1} = ?IF(ScoreType == ?SCORE_TYPE_2, {AddScore, NowTime}, {0, 0}), %% 只有击杀boss才会增加score字段
                    NewPlayerScore = #player_score{
                        role_id = AUid, role_name = AttName, server_id = AttServerId, server_num = AttServerNum,
                        zone_id = ZoneId, score = NewScore, sort_key1 = NewSK1, total_score = AddScore, sort_key3 = NowTime
                    }
            end,
            db_replace_player_score(NewPlayerScore),
            log_eudemons_land_score(ZoneId, NewPlayerScore, AddScore, 0, NowTime),
            %?PRINT("NewPlayerScore : ~p ~n", [NewPlayerScore]),
            NewPlayerScoreList = lists:keystore(AUid, #player_score.role_id, PlayerScoreList, NewPlayerScore),
            maps:put(ZoneId, NewPlayerScoreList, ScoreMap1);
        _ ->
            ScoreMap
    end.

update_killer_kill_num(ZoneId, ScoreMap, AtterInfo, AddScore) ->
    %?PRINT("update_killer_kill_num ###### start ~n", []),
    [AUid, AttName, AttServerId, AttServerNum] = AtterInfo,
    case get_one_zone_score_map(ZoneId, ScoreMap) of
        {ok, ZoneId, PlayerScoreList, ScoreMap1} ->
            NowTime = utime:unixtime(),
            case lists:keyfind(AUid, #player_score.role_id, PlayerScoreList) of
                #player_score{kill_num = OldKillNum, total_score = OldTotalScore, sort_key3 = SK3} = PlayerScore ->
                    {NewTotalScore, NewSK3} = ?IF(AddScore>0, {OldTotalScore + AddScore, NowTime}, {OldTotalScore, SK3}),
                    NewPlayerScore = PlayerScore#player_score{
                        role_name = AttName, server_id = AttServerId, server_num = AttServerNum, zone_id = ZoneId,
                        kill_num = OldKillNum + 1, sort_key2 = NowTime, total_score = NewTotalScore, sort_key3 = NewSK3
                    };
                _ ->
                    {NewTotalScore, NewSK3} = ?IF(AddScore>0, {AddScore, NowTime}, {0, 0}),
                    NewPlayerScore = #player_score{
                        role_id = AUid, role_name = AttName, server_id = AttServerId, server_num = AttServerNum,
                        zone_id = ZoneId, kill_num = 1, sort_key2 = NowTime, total_score = NewTotalScore, sort_key3 = NewSK3
                    }
            end,
            db_replace_player_score(NewPlayerScore),
            log_eudemons_land_score(ZoneId, NewPlayerScore, AddScore, 1, NowTime),
            %?PRINT("NewPlayerScore : ~p ~n", [NewPlayerScore]),
            NewPlayerScoreList = lists:keystore(AUid, #player_score.role_id, PlayerScoreList, NewPlayerScore),
            maps:put(ZoneId, NewPlayerScoreList, ScoreMap1);
        _ ->
            ScoreMap
    end.

add_score_info_to_local(ZoneId, AUid, ScoreType, AddScore, ScoreMap) when AddScore>0 orelse ScoreType==?SCORE_TYPE_1 ->
    %?PRINT("add_score_info_to_local ###### start ~n", []),
    case maps:get(ZoneId, ScoreMap, false) of
        false -> ok;
        PlayerScoreList ->
            case lists:keyfind(AUid, #player_score.role_id, PlayerScoreList) of
                #player_score{} = PlayerScore ->
                     %?PRINT("add_score_info_to_local ###### do ~n", []),
                    mod_zone_mgr:apply_cast_to_zone(1, ZoneId, lib_eudemons_land, add_score_info_to_server, [PlayerScore, ScoreType, AddScore]),
                    ok;
                _ ->
                    ok
            end
    end;
add_score_info_to_local(_ZoneId, _AUid, _ScoreType, _AddScore, _ScoreMap) ->
    ok.

%% 区域更改
zone_change(ScoreMap, ServerId, OldZone, NewZone) ->
    case maps:get(OldZone, ScoreMap, false) of
        false -> ScoreMap;
        PlayerScoreList ->
            F = fun(PlayerScore) ->
                PlayerScore#player_score.server_id == ServerId orelse
                lib_clusters_center_api:get_zone(PlayerScore#player_score.server_id) == NewZone
            end,
            {Satisfying, NotSatisfying} = lists:partition(F, PlayerScoreList),
            case length(Satisfying) == 0 of
                true -> ScoreMap;
                _ ->
                    PlayerScoreList2 = maps:get(NewZone, ScoreMap, []),
                    ScoreMap1 = maps:put(OldZone, NotSatisfying, ScoreMap),
                    NewPlayerScoreList2 = Satisfying ++ PlayerScoreList2,
                    maps:put(NewZone, NewPlayerScoreList2, ScoreMap1)
            end
    end.

%% 合服处理
merge_server(ScoreMap, ServerId, ChangeServerList) ->
    F = fun(ZoneId, PlayerScoreList, {Map, UpdateList}) ->
        F2 = fun(PlayerScore, {PlayerScoreList2, UpdateList2}) ->
            case PlayerScore#player_score.server_id =/= ServerId andalso lists:member(PlayerScore#player_score.server_id, ChangeServerList) == true of
                true ->
                    {[PlayerScore#player_score{server_id = ServerId}|PlayerScoreList2], [{PlayerScore#player_score.role_id, ServerId}|UpdateList2]};
                _ -> {[PlayerScore|PlayerScoreList2], UpdateList2}
            end
        end,
        {NewPlayerScoreList, UpdateList2} = lists:foldl(F2, {[], []}, PlayerScoreList),
        case UpdateList2 == [] of
            true -> {Map, UpdateList};
            _ ->
                {maps:put(ZoneId, NewPlayerScoreList, Map), UpdateList2++UpdateList}
        end
    end,
    {NewScoreMap, UpdateList} = maps:fold(F, {ScoreMap, []}, ScoreMap),
    UpdateList =/= [] andalso spawn(fun() -> update_player_servers(UpdateList) end),
    NewScoreMap.

update_player_servers(UpdateList) ->
    F = fun({RoleId, ServerId}, Count) ->
        Count rem 20 == 0 andalso timer:sleep(1000),
        Sql = io_lib:format(<<"update eudemons_boss_player_score set server_id=~p where role_id=~p ">>, [ServerId, RoleId]),
        db:execute(Sql)
    end,
    lists:foldl(F, 1, UpdateList).

send_rank_reward(ScoreMap) ->
    F = fun(ZoneId, PlayerScoreList, ResultMap) ->
        {ResultSubMap1, LogList1} = get_result_rank_list(?RANK_TYPE_1, ZoneId, PlayerScoreList, #{}, []),
        {ResultSubMap2, LogList2} = get_result_rank_list(?RANK_TYPE_2, ZoneId, PlayerScoreList, ResultSubMap1, LogList1),
        {ResultSubMap3, LogList3} = get_result_rank_list(?RANK_TYPE_3, ZoneId, PlayerScoreList, ResultSubMap2, LogList2),
        lib_log_api:log_eudemons_land_rank_center(LogList3),
        maps:put(ZoneId, ResultSubMap3, ResultMap)
    end,
    ResultMap = maps:fold(F, #{}, ScoreMap),
    ?PRINT("send_rank_reward : ~p~n", [ResultMap]),
    F2 = fun(_ZoneId, ResultSubMap, Acc) ->
        F3 = fun(ServerId, ServerPlayerList, Acc3) ->
            mod_clusters_center:apply_cast(ServerId, lib_eudemons_land, send_rank_reward, [ServerPlayerList]),
            Acc3
        end,
        maps:fold(F3, 1, ResultSubMap),
        timer:sleep(200),
        Acc
    end,
    maps:fold(F2, 1, ResultMap).


get_result_rank_list(RankType, ZoneId, PlayerScoreList, ResultSubMap, LogList) ->
    NowTime = utime:unixtime(),
    PlayerScoreList1 = sort_rank_prepare(RankType, PlayerScoreList),
    SortPlayerList = sort_player_list(RankType, PlayerScoreList1),
    F = fun(PlayerScore, {AccRank, Map, List}) ->
        #player_score{role_id = RoleId, role_name = RoleName, server_id = ServerId, score = Score, kill_num = KillNum, total_score = TotalScore} = PlayerScore,
        ServerPlayerList = maps:get(ServerId, Map, []),
        Value = case RankType of
            ?RANK_TYPE_1 -> KillNum; ?RANK_TYPE_2 -> Score; ?RANK_TYPE_3 -> TotalScore; true -> TotalScore
        end,
        NewMap = maps:put(ServerId, [{RoleId, RankType, Value, AccRank}|ServerPlayerList], Map),
        NewList = [[ZoneId, RoleId, util:fix_sql_str(RoleName), ServerId, RankType, Value, AccRank, NowTime]|List],
        {AccRank+1, NewMap, NewList}
    end,
    {_, NewResultSubMap, NewLogList} = lists:foldl(F, {1, ResultSubMap, LogList}, SortPlayerList),
    {NewResultSubMap, NewLogList}.

sort_player_list(?RANK_TYPE_1, PlayerScoreList) ->
    F = fun(PlayerScore1, PlayerScore2) ->
        #player_score{kill_num = KillNum1, sort_key2 = SK21} = PlayerScore1,
        #player_score{kill_num = KillNum2, sort_key2 = SK22} = PlayerScore2,
        if
            KillNum1 > KillNum2 -> true;
            KillNum1 < KillNum2 -> false;
            true -> SK21 < SK22
        end
    end,
    lists:sort(F, PlayerScoreList);
sort_player_list(?RANK_TYPE_2, PlayerScoreList) ->
    F = fun(PlayerScore1, PlayerScore2) ->
        #player_score{score = Score1, sort_key1 = SK11} = PlayerScore1,
        #player_score{score = Score2, sort_key1 = SK12} = PlayerScore2,
        if
            Score1 > Score2 -> true;
            Score1 < Score2 -> false;
            true -> SK11 < SK12
        end
    end,
    lists:sort(F, PlayerScoreList);
sort_player_list(_, PlayerScoreList) ->
    F = fun(PlayerScore1, PlayerScore2) ->
        #player_score{total_score = TotalScore1, sort_key3 = SK31} = PlayerScore1,
        #player_score{total_score = TotalScore2, sort_key3 = SK32} = PlayerScore2,
        if
            TotalScore1 > TotalScore2 -> true;
            TotalScore1 < TotalScore2 -> false;
            true -> SK31 < SK32
        end
    end,
    lists:sort(F, PlayerScoreList).

sort_rank_prepare(?RANK_TYPE_1, PlayerScoreList) ->
    F = fun(#player_score{kill_num = Value}) -> Value > 0 end,
    lists:filter(F, PlayerScoreList);
sort_rank_prepare(?RANK_TYPE_2, PlayerScoreList) ->
    F = fun(#player_score{score = Value}) -> Value > 0 end,
    lists:filter(F, PlayerScoreList);
sort_rank_prepare(_, PlayerScoreList) ->
    F = fun(#player_score{total_score = Value}) -> Value > 0 end,
    lists:filter(F, PlayerScoreList).

%% 过滤一些不需要同步到游戏服的boss信息
filter_zone_boss_map(ZoneBossMap) ->
    F = fun(BossId, _Boss) ->
        #eudemons_boss_cfg{is_rare = IsRare} = data_eudemons_land:get_eudemons_boss_cfg(BossId),
        IsRare =/= ?MON_CL_TASK
    end,
    maps:filter(F, ZoneBossMap).

log_eudemons_land_score(ZoneId, PlayerScore, AddScore, AddKillNum, NowTime) ->
    #player_score{
        role_id = RoleId, role_name = RoleName, server_id = ServerId, server_num = ServerNum,
        score = Score, kill_num = KillNum, total_score = TotalScore
    } = PlayerScore,
    lib_log_api:log_eudemons_land_score(RoleId, util:fix_sql_str(RoleName), ZoneId, ServerId, ServerNum, AddScore, AddKillNum, Score, KillNum, TotalScore, NowTime).

%% 玩家击杀boss的临时数据
get_role_kill_boss_list(RoleId) ->
    case get({kill_boss, RoleId}) of
        List when is_list(List) -> List;
        _ -> []
    end.

get_next_kill_id(KillBossList) ->
    case KillBossList of
        [{KillAutoId, _}|_] -> KillAutoId+1;
        _ -> 1
    end.

update_role_kill_boss_list(RoleId, NewKillBossList) ->
    put({kill_boss, RoleId}, NewKillBossList).

delete_role_kill_boss_list(RoleId, KillAutoId) ->
    List = get_role_kill_boss_list(RoleId),
    NewList = lists:keydelete(KillAutoId, 1, List),
    update_role_kill_boss_list(RoleId, NewList).

%%%=========================================== db
db_replace_player_score(PlayerScore) ->
    #player_score{
        role_id = RoleId, role_name = RoleName, server_id = ServerId, server_num = ServerNum,
        zone_id = _ZoneId, score = Score, sort_key1 = SK1, kill_num = KillNum, sort_key2 = SK2, total_score = TotalScore, sort_key3 = SK3
    } = PlayerScore,
    Sql = io_lib:format(?sql_replace_player_score, [RoleId, util:fix_sql_str(RoleName), ServerId, ServerNum, Score, SK1, KillNum, SK2, TotalScore, SK3]),
    db:execute(Sql).

db_select_player_score() ->
    Sql = ?sql_select_player_score_all,
    db:get_all(Sql).

db_delete_player_score() ->
    db:execute("truncate table eudemons_boss_player_score").

%% 清掉水晶，重刷
gm_refresh_cristal(MonIdListStr, ZoneIdListStr) ->
    case config:get_cls_type() of
        ?NODE_CENTER ->
            gm_refresh_cristal_do(MonIdListStr, ZoneIdListStr);
        _ ->
            mod_clusters_node:apply_cast(mod_eudemons_land, gm_refresh_cristal_do, [MonIdListStr, ZoneIdListStr])
    end.

gm_refresh_cristal_do(MonIdListStr, ZoneIdListStr) ->
    MonIdList = util:string_to_term(MonIdListStr),
    ZoneList = util:string_to_term(ZoneIdListStr),
    RefreshList = [{ZoneId, MonId} || ZoneId <- ZoneList, MonId <- MonIdList],
    spawn(fun() ->
        [begin
            gen_server:cast(?MODULE, {'gm_refresh_cristal', ZId, MId}),
            timer:sleep(200)
        end||{ZId, MId} <- RefreshList]
    end),
    ok.
