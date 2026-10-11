%% ---------------------------------------------------------------------------
%% @doc lib_sanctuary_cluster_api

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/9/3 0003
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_sanctuary_cluster_api).

%% API
-export([
      mon_be_killed/9
    , mon_be_hurt/3
    , kill_player/6
    , handle_event/2
]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_fun.hrl").
-include("cluster_sanctuary.hrl").

%% -----------------------------------------------------------------
%% 怪物被击杀
%% -----------------------------------------------------------------
mon_be_killed(BLWhos, KList, SceneId, ScenePoolId, _CopyId, ServerId, Mid, AtterId, AtterName) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
            mod_sanctuary_cluster:mon_be_killed(ScenePoolId, ServerId, BLWhos, KList, SceneId, Mid, AtterId, AtterName);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 怪物被攻击
%% @deprecated 拍卖被cut掉，不再需要统计
%% -----------------------------------------------------------------
mon_be_hurt(_Minfo, _Atter, _Hurt) -> skip.
    % #battle_return_atter{server_id = ServerId, server_num = ServerNum, id = RoleId, real_name = Name} = Atter,
    % #scene_object{scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, config_id = Monid} = Minfo,
    % case data_scene:get(Scene) of
    %     #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
    %         mod_sanctuary_cluster:mon_hurt(Scene, PoolId, CopyId, ServerId, ServerNum, Monid, RoleId, Name, Hurt);
    %     _ ->
    %         skip
    % end.

%% -----------------------------------------------------------------
%% 击杀玩家
%% @deprecated 拍卖被cut掉，不再需要统计
%% 20220801版本 修改击杀敌对玩家会累加积分,但仅限于计算累计积分
%% -----------------------------------------------------------------
kill_player(SceneId, ScenePId, _ServerId, Attacker, RoleScore, RoleKillNum) ->
    #battle_return_atter{server_id = AttrServerId, id = AttrRoleId, real_name = AttrName} = Attacker,
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY  ->
            mod_sanctuary_cluster_local:kill_player(SceneId, ScenePId, AttrServerId, AttrRoleId, AttrName, RoleScore, RoleKillNum);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 玩家死亡事件，计算复活buff
%% -----------------------------------------------------------------
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = _Data}) when is_record(Player, player_status) ->
    #player_status{id = DieId, scene = SceneId, sanctuary_cluster = StatusSanCluster}=Player,
    NowTime = utime:unixtime(),
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
            %% 玩家连续死亡间隔时间，在这个值内会被记录
            LogDieInterval = data_cluster_sanctuary_m:get_san_value(player_die_times),
            %% 死亡后多久复活成幽灵
            BTGhostSec = data_cluster_sanctuary_m:get_san_value(revive_point_gost),

            #status_sanctuary_cluster{last_die_time = LastDieTime, die_times = DieTimes} = StatusSanCluster,
            NewDieTimes = ?IF(NowTime > LastDieTime + LogDieInterval, 0, DieTimes + 1),

            {CanReviveTime, MinTimes} = lib_sanctuary_cluster_util:calc_revive_time(NewDieTimes, NowTime),
            % 通知客户端下次复活时间及其他相关信息
            if
                NewDieTimes > MinTimes ->
                    lib_server_send:send_to_uid(DieId, pt_284, 28415, [NewDieTimes, CanReviveTime, NowTime + LogDieInterval, NowTime + BTGhostSec]);
                true ->
                    lib_server_send:send_to_uid(DieId, pt_284, 28415, [NewDieTimes, CanReviveTime, NowTime + LogDieInterval, 0])
            end,
            NStatusSanCluster = StatusSanCluster #status_sanctuary_cluster{last_die_time = NowTime, die_times = NewDieTimes},
            {ok, Player#player_status{sanctuary_cluster = NStatusSanCluster}};
        _ ->
            {ok, Player}
    end;
handle_event(Player, _EventCallback) ->
    {ok, Player}.

