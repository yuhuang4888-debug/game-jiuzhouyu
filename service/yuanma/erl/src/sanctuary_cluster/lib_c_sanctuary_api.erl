%%%-----------------------------------
%%% @Module      : lib_c_sanctuary_api 跨服圣域
%%% @Author      : xlh
%%% @Email       : 1593315047@qq.com
%%% @Created     : 2018
%%% @Description : 跨服圣域接口模块
%%%-----------------------------------
-module(lib_c_sanctuary_api).

-compile(export_all).

-include("cluster_sanctuary.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("battle.hrl").
-include("attr.hrl").

%% -----------------------------------------------------------------
%% 发消息给玩家
%% -----------------------------------------------------------------
send_to_role(Node,Rid,Bin) when is_integer(Rid)->
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Rid,Bin]);
send_to_role(Node,RoleIds,Bin) when is_list(RoleIds)->
    mod_clusters_center:apply_cast(Node, ?MODULE, send_to_role_local, [RoleIds,Bin]);
send_to_role(Node,Sid,Bin)->
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_sid, [Sid,Bin]).

send_to_all(ServerId, Type, Value, Bin) ->
	mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_all, [Type, Value, Bin]).

send_to_role_local(RoleIds, Bin) ->
    F = fun(RoleId) ->
        if
            is_integer(RoleId) -> lib_server_send:send_to_uid(RoleId, Bin);
            is_pid(RoleId) -> 
                misc:is_process_alive(RoleId) andalso
                lib_server_send:send_to_sid(RoleId, Bin);
            true -> ok
        end
    end,
    lists:foreach(F, RoleIds).

%% -----------------------------------------------------------------
%% 活动开启通知服所有客户端活动时间
%% -----------------------------------------------------------------
notify_client_act_time(StartTime, EndTime) ->
	Type = all_lv,
	case data_cluster_sanctuary:get_san_value(open_lv) of
		LimitLv when is_integer(LimitLv) ->
			Value = {LimitLv, 999};
		_-> Value = {200, 999}
	end,
	{ok, BinData} = pt_284:write(28410, [StartTime, EndTime]),
	lib_server_send:send_to_all(Type, Value, BinData).

%% -----------------------------------------------------------------
%% boss刷新通知服所有客户端活动时间
%% -----------------------------------------------------------------
notify_client_boss_refresh() ->
	Type = all_lv,
	case data_cluster_sanctuary:get_san_value(open_lv) of
		LimitLv when is_integer(LimitLv) ->
			Value = {LimitLv, 999};
		_-> Value = {200, 999}
	end,
	{ok, BinData} = pt_284:write(28413, [1]),
	lib_server_send:send_to_all(Type, Value, BinData).

%% -----------------------------------------------------------------
%% 活动关闭通知服所有客户端活动时间
%% -----------------------------------------------------------------
send_act_end_tv(Value) ->
	Type = all_lv,
	case data_cluster_sanctuary:get_san_value(open_lv) of
		LimitLv when is_integer(LimitLv) ->
			Min = LimitLv, Max = 999;
		_-> Min = 200, Max = 999
	end,
	lib_chat:send_TV({Type, Min, Max}, ?MOD_C_SANCTUARY, 3, [Value]).

%% -----------------------------------------------------------------
%% 怪物被击杀
%% -----------------------------------------------------------------
mon_be_killed(BLWhos, Klist, SceneId, ScenePoolId, CopyId, ServerId, Mid, AtterId, AtterName) ->
	case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
        	mod_c_sanctuary:mon_be_killed(BLWhos, Klist, SceneId, ScenePoolId, CopyId, ServerId, Mid, AtterId, AtterName);
        _ ->
        	skip
    end.

%% -----------------------------------------------------------------
%% 怪物被攻击
%% -----------------------------------------------------------------
mon_be_hurt(Minfo, Atter, Hurt) ->
    #battle_return_atter{server_id = ServerId, server_num = ServerNum, id = RoleId, real_name = Name} = Atter,
    #scene_object{scene = Scene, scene_pool_id = PoolId, copy_id = CopyId, config_id = Monid} = Minfo,
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
            mod_c_sanctuary:mon_hurt(Scene, PoolId, CopyId, ServerId, ServerNum, Monid, RoleId, Name, Hurt);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 击杀玩家
%% -----------------------------------------------------------------
kill_player(SceneId, CopyId, ServerId, Attacker, HitList) ->
    #battle_return_atter{server_id = AttrServerId, server_num = ServerNum, id = AttrRoleId, real_name = _AttrName} = Attacker,
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY andalso ServerId =/= AttrServerId ->
            mod_c_sanctuary:kill_player(SceneId, CopyId, AttrServerId, ServerNum, AttrRoleId, _AttrName, [HitId||#hit{id=HitId}<- HitList]);
        _ ->
            skip
    end.

% get_camp_from_db() ->
%     case db:get_row(?SQL_SELECT_SANTYPE_CAMP) of
%         Camp when is_integer(Camp) -> Camp;
%         _ -> 0
%     end.

%% 玩家切回游戏取消复活定时器
cancel_timer_kf_sanctuary(Ps) ->
    #player_status{kf_sanctuary_info = KfSanInfo, scene = SceneId} = Ps,
    #ets_scene{type = SceneType} = data_scene:get(SceneId),
    if
        SceneType == ?SCENE_TYPE_KF_SANCTUARY ->
            case KfSanInfo of
                #kf_sanctuary_info{reborn_ref = Ref} ->
                    util:cancel_timer(Ref),
                    NewKfSanInfo = KfSanInfo#kf_sanctuary_info{reborn_ref = undefined};
                _ ->
                    NewKfSanInfo = KfSanInfo
            end;
        true ->
            NewKfSanInfo = KfSanInfo
    end,
    Ps#player_status{kf_sanctuary_info = NewKfSanInfo}.

%% 玩家死亡后定时检测是否复活
handle_revive_check_in_sanctuary(#player_status{kf_sanctuary_info = KfSanInfo} = Ps, Scene, Time) when is_record(KfSanInfo, kf_sanctuary_info) ->
    #kf_sanctuary_info{reborn_ref = Ref} = KfSanInfo,
    RebornRef = util:send_after(Ref, Time * 1000, self(), %%下一次复活
        {'mod', lib_c_sanctuary_api, handle_revive_check_in_sanctuary, [Scene]}),
    Ps#player_status{kf_sanctuary_info = KfSanInfo#kf_sanctuary_info{reborn_ref = RebornRef}};
handle_revive_check_in_sanctuary(Ps, _, _) -> Ps.

handle_revive_check_in_sanctuary(Ps, Scene) ->
    #player_status{x = X1, y = Y1, scene = SceneId, battle_attr = BA, kf_sanctuary_info = KfSanInfo} = Ps,
    #battle_attr{hp = Hp} = BA,
    #ets_scene{x = X, y = Y, type = SceneType} = data_scene:get(SceneId),
    #kf_sanctuary_info{die_time = DieTime, reborn_ref = Ref, die_time_list = DieList} = KfSanInfo,
    util:cancel_timer(Ref),
    NewPs = if
        Hp > 0 -> Ps;
        Scene =/= SceneId -> Ps;
        SceneType =/= ?SCENE_TYPE_KF_SANCTUARY -> Ps;
        % {X1, Y1} == {X, Y} -> Ps; %% 回到出生点不处理
        true ->
            DieTimes = erlang:length(DieList),
            {RebornTime, MinTimes} =lib_c_sanctuary:count_die_wait_time(DieTimes, DieTime),
            %% 死亡后多久复活成幽灵
            case data_cluster_sanctuary:get_san_value(revive_point_gost) of
                TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                _ -> TimeCfg2 = 20
            end,
            NowTime = utime:unixtime(),
            if
                {X1, Y1} == {X, Y} andalso NowTime < RebornTime -> 
                    RebornRef = util:send_after([], max((RebornTime - NowTime+3) * 1000, 500), self(), %%下一次复活
                        {'mod', lib_c_sanctuary_api, handle_revive_check_in_sanctuary, [Scene]}),
                    Ps#player_status{kf_sanctuary_info = KfSanInfo#kf_sanctuary_info{reborn_ref = RebornRef}}; %% 搬运回尸体
                DieTimes > MinTimes andalso (DieTime + TimeCfg2) < NowTime andalso NowTime < RebornTime -> %%不是自动复活时间，而是搬运幽灵时间
                    RebornRef = util:send_after([], max((RebornTime - NowTime+3) * 1000, 500), self(), %%下一次复活
                        {'mod', lib_c_sanctuary_api, handle_revive_check_in_sanctuary, [Scene]}),
                    {_, Player1} = lib_revive:revive(Ps, ?REVIVE_ASHES),
                    Player1#player_status{kf_sanctuary_info = KfSanInfo#kf_sanctuary_info{reborn_ref = RebornRef}};
                true -> %% 直接复活
                    {_, Player1} = lib_revive:revive(Ps, ?REVIVE_ORIGIN),
                    Player1
            end
    end,
    {ok, NewPs}.