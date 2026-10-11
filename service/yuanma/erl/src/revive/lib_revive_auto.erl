%% ---------------------------------------------------------------------------
%% @doc lib_revive_auto

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/9/9 0009
%% @desc    部分功能在玩家挂后台时需要自动复活（）
%% ---------------------------------------------------------------------------
-module(lib_revive_auto).

%% API
-export([
    handle_event/2
]).

-include("common.hrl").
-include("server.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("scene.hrl").
-include("boss.hrl").

%% TODO 感觉用处不大，代码整理先搬过来，后续看策划需求是否删掉
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE}) when is_record(Player, player_status) ->
    #player_status{scene = SceneId, status_boss = StatusBoss} = Player,
    #ets_scene{type = SceneType} = data_scene:get(SceneId),
    ReviveTime = calc_check_revive_time(SceneType),
    InBoss = lib_boss:is_in_boss(SceneId),
    if
        ReviveTime =< 0 ->
            NewPlayer = Player;
        InBoss andalso is_record(StatusBoss, status_boss) ->
            #status_boss{check_revive_ref = OldRef} = StatusBoss,
            Msg = {'mod', lib_boss_api, handle_revive_check_in_boss, [SceneId]},
            NewRef = util:send_after(OldRef, max(ReviveTime * 1000, 1), self(), Msg),
            NewPlayer = Player#player_status{status_boss = StatusBoss#status_boss{check_revive_ref = NewRef}};
        % SceneType == ?SCENE_TYPE_KF_SANCTUARY ->
        %     NewPlayer = lib_c_sanctuary_api:handle_revive_check_in_sanctuary(Player, SceneId, ReviveTime);
        SceneType == ?SCENE_TYPE_SANCTUM ->
            NewPlayer = lib_kf_sanctum:handle_revive_check_in_sanctuam(Player, SceneId, ReviveTime);
        true ->
            NewPlayer = Player
    end,
    {ok, NewPlayer};
handle_event(Player, _) -> {ok, Player}.

%% 定时复活时间计算，正常时间的基础上加延时3s处理
calc_check_revive_time(SceneType) ->
    if
        SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS orelse SceneType == ?SCENE_TYPE_SPECIAL_BOSS ->
            case data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE, revive_point_gost) of
                TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                _ -> TimeCfg2 = 20
            end,
            TimeCfg2 + 3;  %% 搬运尸体时间
        SceneType == ?SCENE_TYPE_ABYSS_BOSS ->
            case data_boss:get_boss_type_kv(?BOSS_TYPE_ABYSS, end_out_time) of
                TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
                _ -> TimeCfg = 20
            end,
            TimeCfg + 3;
        SceneType == ?SCENE_TYPE_FORBIDDEB_BOSS ->
            6;
        SceneType == ?SCENE_TYPE_DOMAIN_BOSS ->
            13;
        SceneType == ?SCENE_TYPE_KF_GREAT_DEMON ->
            13;
        SceneType == ?SCENE_TYPE_KF_SANCTUARY ->
            case data_cluster_sanctuary:get_san_value(revive_point_gost) of
                TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                _ -> TimeCfg2 = 20
            end,
            TimeCfg2+3;
        SceneType == ?SCENE_TYPE_SANCTUM ->
            case data_sanctum:get_value(revive_point_gost_time) of
                TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                _ -> TimeCfg2 = 20
            end,
            TimeCfg2+3;
        true -> 0
    end.

