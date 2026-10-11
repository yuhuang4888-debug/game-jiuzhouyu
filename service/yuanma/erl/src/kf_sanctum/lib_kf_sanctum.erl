-module(lib_kf_sanctum).

-include("def_module.hrl").
-include("scene.hrl").
-include("server.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("kf_sanctum.hrl").
-include("def_event.hrl").
-include("predefine.hrl").
-include("rec_event.hrl").

-export([
        send_to_all/4
        ,send_to_role/3
        ,send_rank_rewards/5
        ,send_tv_to_all/3
        ,re_login/2
        ,get_revive_cost/0
        ,is_in_kf_sanctum/1
        ,login/1
        ,logout/1
        ,delay_stop/1
        ,player_reborn/1
        ,handle_event/2
        ,notify_re_login/3
        ,sanctum_mon_be_kill/6
        ,handle_rank_list/1
        ,send_tv_to_scene/5
        ,count_die_wait_time/2
        ,do_close_act/2
        ,handle_revive_check_in_sanctuam/2
        ,handle_revive_check_in_sanctuam/3
    ]).

is_in_kf_sanctum(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SANCTUM ->
            true;
        _ -> false
    end.

send_to_role(Node,Rid,Bin) when is_integer(Rid)->
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Rid,Bin]);
send_to_role(Node,RoleIds,Bin) when is_list(RoleIds)->
    mod_clusters_center:apply_cast(Node, ?MODULE, send_to_role_local, [RoleIds,Bin]);
send_to_role(Node,Sid,Bin)->
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_sid, [Sid,Bin]).

sanctum_mon_be_kill(BLWhos, Klist, Scene, _ScenePoolId, CopyId, BossId) ->
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SANCTUM ->
            mod_kf_sanctum:boss_be_killed(BLWhos, Klist, Scene, _ScenePoolId, CopyId, BossId);
        _ ->
            skip
    end.


get_revive_cost() ->
    case data_sanctum:get_value(revive_point_gost) of
        Cost when is_list(Cost) -> Cost;
        _ -> [{2,0,20}]
    end.

send_to_all(ServerId, Type, Value, Bin) ->
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_all, [Type, Value, Bin]).

send_tv_to_all(ServerId, MsgId, Args) ->
    case data_sanctum:get_value(open_lv) of
        OpenLv when is_integer(OpenLv) -> OpenLv;
        _ -> OpenLv = 400
    end,
    mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV, [{all_lv, OpenLv, 999}, ?MOD_KF_SANCTUM, MsgId, Args]).

send_tv_to_scene(SceneId, ScenePoolId, CopyId, MsgId, Args) ->
    % spawn(fun() ->
        lib_chat:send_TV({scene, SceneId, ScenePoolId, CopyId}, ?MOD_KF_SANCTUM, MsgId, Args).
    % end).

send_rank_rewards(ServerId, RoleID, BossName, Rank, Rewards) ->
    mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleID], utext:get(2790001), utext:get(2790002, [BossName, Rank]), Rewards]).
    % lib_mail_api:send_sys_mail([RoleID], utext:get(2790001), utext:get(2790002, [BossName, Rank]), Rewards).

login(Player) ->
    #player_status{id = RoleId} = Player,
    Sql = io_lib:format(?SQL_SELECT_PLAYER_DIE, [RoleId]),
    ListD = db:get_all(Sql),
    Fun = fun([Mod, DieTime, ODieList], TemMap) ->
        DieList = util:bitstring_to_term(ODieList),
        if
            Mod == ?MOD_KF_SANCTUM ->
                case data_sanctum:get_value(player_die_times) of
                    TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
                    _ -> TimeCfg = 300
                end;
            true ->
                TimeCfg = 300
        end,
        ModDieInfo = #mod_player_die{mod = Mod, die_time_list = DieList, die_time = DieTime, buff_end = DieTime+TimeCfg, reborn_ref = undefined},
        maps:put(Mod, ModDieInfo, TemMap)
    end,
    PlayerDieInfo = lists:foldl(Fun, #{}, ListD),
    Player#player_status{player_die = PlayerDieInfo}.

logout(Player) ->
    #player_status{id = RoleId, scene = Scene, server_id = ServerId} = Player,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_SANCTUM} ->
            lib_scene:player_change_default_scene(RoleId, [{pk,{?PK_PEACE,true}}, {change_scene_hp_lim, 100}]),
            mod_kf_sanctum_local:exit(ServerId, RoleId, Scene),
            mod_kf_sanctum:exit(ServerId, RoleId, Scene);
        _ ->
            skip
    end,
    Player.

delay_stop(Player) ->
    #player_status{scene = Scene, battle_attr = BA, player_die = PlayerDieInfo} = Player,
    ModDieInfo = maps:get(?MOD_KF_SANCTUM, PlayerDieInfo, []),
    #battle_attr{hp = Hp} = BA,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_SANCTUM} ->
            if
                Hp =< 0 ->
                    NowTime = utime:unixtime(),
                    case ModDieInfo of
                        [] ->
                            DieList = [], DieTime = 0, Ref = undefined;
                        _ ->
                            #mod_player_die{die_time_list = DieList, die_time = DieTime, reborn_ref = Ref} = ModDieInfo
                    end,
                    util:cancel_timer(Ref),
                    case data_sanctum:get_value(revive_point_gost_time) of
                        TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                        _ -> TimeCfg2 = 20
                    end,

                    DieTimes = erlang:length(DieList),
                    {RebornTime, _MinTimes} = count_die_wait_time(DieTimes, DieTime),
                    ReviveTime = max(0, RebornTime - NowTime),
                    GostTime = max(0, DieTime + TimeCfg2 - NowTime),
                    NewRef = util:send_after([], min(ReviveTime, GostTime) * 1000,self(),
                            {'mod', lib_kf_sanctum, player_reborn, []}),
                    case ModDieInfo of
                        [] ->
                            NewModDieInfo = #mod_player_die{mod = ?MOD_KF_SANCTUM, die_time_list = [], die_time = 0, buff_end = 0, reborn_ref = NewRef};
                        _ ->
                            NewModDieInfo = ModDieInfo#mod_player_die{reborn_ref = NewRef}
                    end,
                    NewPlayerDieInfo = maps:put(?MOD_KF_SANCTUM, NewModDieInfo, PlayerDieInfo),
                    NewPlayer = Player#player_status{player_die = NewPlayerDieInfo};
                true ->
                    NewPlayer = Player
            end;
        _ ->
            NewPlayer = Player
    end,
    NewPlayer.

player_reborn(Player) ->
    #player_status{scene = Scene, battle_attr = BA, player_die = PlayerDieInfo} = Player,
    ModDieInfo = maps:get(?MOD_KF_SANCTUM, PlayerDieInfo, []),
    #battle_attr{hp = Hp} = BA,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_SANCTUM, x = X, y = Y} ->
            if
                Hp =< 0 ->
                    NowTime = utime:unixtime(),
                    case ModDieInfo of
                        [] ->
                            DieList = [], DieTime = 0, Ref = undefined;
                        _ ->
                            #mod_player_die{die_time_list = DieList, die_time = DieTime, reborn_ref = Ref} = ModDieInfo
                    end,
                    util:cancel_timer(Ref),
                    % case data_cluster_sanctuary:get_san_value(auto_revive_after_limit) of
                    %     TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
                    %     _ -> TimeCfg = 15
                    % end,
                    DieTimes = erlang:length(DieList),
                    {RebornTime, _MinTimes} = count_die_wait_time(DieTimes, DieTime),
                    Time = max(RebornTime - NowTime, 0),
                    if
                        Time > 0 ->
                            NewRef = util:send_after([], max(Time * 1000, 500), self(), %%下一次复活
                                {'mod', lib_kf_sanctum, player_reborn, []}),
                            Player1 = lib_scene:change_relogin_scene(Player#player_status{x = X, y = Y}, [{ghost, 1}]);
                        true ->
                            NewRef = undefined,
                            Player1 = lib_scene:change_relogin_scene(Player#player_status{x = X, y = Y},
                                    [{change_scene_hp_lim, 100}, {ghost, 0}])
                    end,
                    case ModDieInfo of
                        [] ->
                            NewModDieInfo = #mod_player_die{mod = ?MOD_KF_SANCTUM, die_time_list = [], die_time = 0, buff_end = 0, reborn_ref = NewRef};
                        _ ->
                            NewModDieInfo = ModDieInfo#mod_player_die{reborn_ref = NewRef}
                    end,
                    NewPlayerDieInfo = maps:put(?MOD_KF_SANCTUM, NewModDieInfo, PlayerDieInfo),
                    NewPlayer = Player1#player_status{player_die = NewPlayerDieInfo};
                true ->
                    NewPlayer = Player
            end;
        _ ->
            NewPlayer = Player
    end,
    NewPlayer.


% re_login(Player, ?NORMAL_LOGIN) ->
%     #player_status{id = RoleId, scene = Scene} = Player,
%     case data_scene:get(Scene) of
%         #ets_scene{type = ?SCENE_TYPE_SANCTUM} ->
%             lib_scene:player_change_default_scene(RoleId, [{recalc_attr, 0}, {change_scene_hp_lim, 100},{ghost, 0},{pk, {?PK_PEACE, true}}]),
%             {ok, Player};
%         _ ->
%             {next, Player}
%     end;

re_login(Player, LoginType) ->
    #player_status{server_id = ServerId, id = RoleId, scene = Scene, battle_attr = BA, player_die = PlayerDieInfo, copy_id = CopyId} = Player,
    ModDieInfo = maps:get(?MOD_KF_SANCTUM, PlayerDieInfo, []),
    #battle_attr{hp = Hp} = BA,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_SANCTUM} ->
            if
                LoginType == ?NORMAL_LOGIN andalso CopyId == 0 ->
                    NewCopyId = mod_kf_sanctum:updata_role_info(ServerId);
                true ->
                    NewCopyId = CopyId
            end,
            if
                Hp =< 0 ->
                    case ModDieInfo of
                        [] ->
                            DieList = [], DieTime = 0, BuffEndTime = 0, Ref = undefined;
                        _ ->
                            #mod_player_die{die_time_list = DieList, die_time = DieTime, buff_end = BuffEndTime, reborn_ref = Ref} = ModDieInfo
                    end,
                    util:cancel_timer(Ref),
                    % NewPlayer = lib_scene:change_relogin_scene(Player, []),
                    {Sign, KillerName, KillId} = lib_boss:get_last_kill_msg(Player),
                    % lib_server_send:send_to_uid(RoleId, pt_200, 20013, [Sign, KillerName, 0, 0, 0, 0, KillId]),
                    case data_sanctum:get_value(revive_point_gost_time) of
                        TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                        _ -> TimeCfg2 = 20
                    end,
                    DieTimes = erlang:length(DieList),
                    {RebornTime, MinTimes} = count_die_wait_time(DieTimes, DieTime),
                    if
                        DieTimes > MinTimes ->
                            PointTime = DieTime + TimeCfg2;
                        true ->
                            PointTime = 0
                            % lib_server_send:send_to_uid(RoleId, pt_284, 28415, [DieTimes, RebornTime, BuffEndTime, PointTime])
                    end,
                    % NewPlayer = lib_scene:change_relogin_scene(Player, []),
                    Args = [DieTimes, RebornTime, BuffEndTime, PointTime],
                    Args2 = [Sign, KillerName, 0, 0, 0, 0, KillId],
                    mod_kf_sanctum:reconect(ServerId, RoleId, Scene, {Args, Args2}),
                    NewPlayer = Player;
                true ->
                    mod_kf_sanctum:reconect(ServerId, RoleId, Scene, {[], []}),
                    NewPlayer = Player
            end,
            case ModDieInfo of
                [] ->
                    NewModDieInfo = #mod_player_die{mod = ?MOD_KF_SANCTUM, die_time_list = [], die_time = 0, buff_end = 0, reborn_ref = undefined};
                _ ->
                    NewModDieInfo = ModDieInfo#mod_player_die{reborn_ref = undefined}
            end,
            {ok, NewPlayer1} = pp_scene:handle(12002, NewPlayer, ok),
            NewPlayerDieInfo = maps:put(?MOD_KF_SANCTUM, NewModDieInfo, PlayerDieInfo),
            {ok, NewPlayer1#player_status{player_die = NewPlayerDieInfo, copy_id = NewCopyId}};
        _ ->
            {next, Player}
    end.

handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = _Data}) when is_record(Player, player_status) ->
    #player_status{id = DieId, scene = SceneId, player_die = PlayerDieInfo}=Player,
    OldModDieInfo = maps:get(?MOD_KF_SANCTUM, PlayerDieInfo, []),
    case OldModDieInfo of
        [] ->
            DieList = [],
            ModDieInfo = #mod_player_die{mod = ?MOD_KF_SANCTUM, die_time_list = [], die_time = 0, buff_end = 0, reborn_ref = undefined};
        _ ->
            #mod_player_die{die_time_list = DieList} = OldModDieInfo,
            ModDieInfo = OldModDieInfo
    end,
    % #{attersign := AtterSign, atter := Atter, hit := _HitList} = Data,
    % #battle_return_atter{real_id = AtterId, real_name = AtterName, guild_id = AtterGuildId} = Atter,
    NowTime = utime:unixtime(),
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_SANCTUM ->
            case data_sanctum:get_value(player_die_times) of
                TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
                _ -> TimeCfg = 300
            end,
            case data_sanctum:get_value(revive_point_gost_time) of
                TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                _ -> TimeCfg2 = 20
            end,
            NewList = lib_c_sanctuary:get_real_die_time_list_2(DieList, TimeCfg, NowTime),
            DieTimes = erlang:length([NowTime|NewList]),
            {RebornTime, MinTimes} = count_die_wait_time(DieTimes, NowTime),
            if
                DieTimes > MinTimes ->
                    lib_server_send:send_to_uid(DieId, pt_279, 27906, [DieTimes, RebornTime, NowTime + TimeCfg, NowTime + TimeCfg2]);
                true ->
                    lib_server_send:send_to_uid(DieId, pt_279, 27906, [DieTimes, RebornTime, NowTime + TimeCfg, 0])
            end,
            NewModDieInfo = ModDieInfo#mod_player_die{mod = ?MOD_KF_SANCTUM, die_time_list = [NowTime|NewList],
                    die_time = NowTime, buff_end = NowTime + TimeCfg},
            RealList = util:term_to_string([NowTime|NewList]),
            db:execute(io_lib:format(?SQL_REPLACE_PLAYER_DIE, [?MOD_KF_SANCTUM, DieId, NowTime, RealList])),
            NewPlayerDieInfo = maps:put(?MOD_KF_SANCTUM, NewModDieInfo, PlayerDieInfo),
            {ok, Player#player_status{player_die = NewPlayerDieInfo}};
        _ ->
            {ok, Player}
    end;
handle_event(Player, _EventCallback) ->
    {ok, Player}.

notify_re_login(#player_status{id = RoleId} = Player, Args, Args2) ->
    NewPlayer = lib_scene:change_relogin_scene(Player, []),
    lib_server_send:send_to_uid(RoleId, pt_200, 20013, Args2),
    lib_server_send:send_to_uid(RoleId, pt_279, 27906, Args),
    {ok, NewPlayer}.

handle_rank_list(RankList) ->
    F1 = fun({_, _, _, _, _, H, _}, Sum) ->
        Sum + H
    end,
    Sum = lists:foldl(F1, 0, RankList),
    Fun = fun({S, SN, Sm, R, N, H, _}, Acc) ->
        Num = (H*10000) div Sum,
        lists:keystore(R, 3, Acc, {S,SN,Sm,R,N,Num})
        % [{S,SN,R,N,Num}|Acc]
    end,
    lists:foldl(Fun, [], RankList).

%% 依据死亡次数以及当前时间计算死亡等待时间
count_die_wait_time(DieTimes, NowTime) ->
    case data_sanctum:get_value(die_wait_time) of
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

do_close_act(Mod, _SubMod) when Mod == ?MOD_KF_SANCTUM ->
    ServerId = config:get_server_id(),
    mod_kf_sanctum:gm_clear_server_user(ServerId);
do_close_act(_, _) -> skip.

handle_revive_check_in_sanctuam(Ps, SceneId, Time) ->
    #player_status{player_die = PlayerDieInfo}=Ps,
    OldModDieInfo = maps:get(?MOD_KF_SANCTUM, PlayerDieInfo, []),
    case OldModDieInfo of
        [] ->
            Ref = undefined,
            ModDieInfo = #mod_player_die{mod = ?MOD_KF_SANCTUM, die_time_list = [], die_time = 0, buff_end = 0, reborn_ref = Ref};
        _ ->
            #mod_player_die{reborn_ref = Ref} = OldModDieInfo,
            ModDieInfo = OldModDieInfo
    end,
    RebornRef = util:send_after(Ref, Time * 1000, self(), %%下一次复活
        {'mod', lib_kf_sanctum, handle_revive_check_in_sanctuam, [SceneId]}),
    NewModDieInfo = ModDieInfo#mod_player_die{reborn_ref = RebornRef},
    NewPlayerDieInfo = maps:put(?MOD_KF_SANCTUM, NewModDieInfo, PlayerDieInfo),
    Ps#player_status{player_die = NewPlayerDieInfo}.

handle_revive_check_in_sanctuam(Ps, Scene) ->
    #player_status{x = PX, y = PY, scene = SceneId, battle_attr = BA, player_die = PlayerDieInfo} = Ps,
    #battle_attr{hp = Hp} = BA,
    #ets_scene{x = Sx, y = Sy, type = SceneType} = data_scene:get(SceneId),
    #mod_player_die{die_time = DieTime, reborn_ref = Ref, die_time_list = DieList} = ModDieInfo
        = maps:get(?MOD_KF_SANCTUM, PlayerDieInfo, #mod_player_die{}),
    util:cancel_timer(Ref),
    NewPs = if
        Hp > 0 -> Ps;
        Scene =/= SceneId -> Ps;
        SceneType =/= ?SCENE_TYPE_SANCTUM -> Ps;
        % {X1, Y1} == {X, Y} -> Ps; %% 回到出生点不处理
        true ->
            DieTimes = erlang:length(DieList),
            {RebornTime, MinTimes} = count_die_wait_time(DieTimes, DieTime),
            %% 死亡后多久复活成幽灵
            case data_sanctum:get_value(revive_point_gost_time) of
                TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
                _ -> TimeCfg2 = 20
            end,
            case data_sanctum:get_value(auto_revive_after_limit) of
                TimeVal when is_integer(TimeVal) -> TimeVal;
                _ -> TimeVal = 15
            end,
            NowTime = utime:unixtime(),
            case catch mod_kf_sanctum_local:get_reborn_point() of
                {X, Y} when is_integer(X) andalso is_integer(Y) -> ok; _ -> X = Sx, Y = Sy
            end,
            if
                {X, Y} == {PX, PY} andalso NowTime < (RebornTime + TimeVal + 3) ->
                    RebornRef = util:send_after([], max((RebornTime + TimeVal - NowTime+3) * 1000, 500), self(), %%下一次复活
                        {'mod', lib_kf_sanctum, handle_revive_check_in_sanctuam, [Scene]}),
                    NewModDieInfo = ModDieInfo#mod_player_die{reborn_ref = RebornRef},
                    NewPlayerDieInfo = maps:put(?MOD_KF_SANCTUM, NewModDieInfo, PlayerDieInfo),
                    Ps#player_status{player_die = NewPlayerDieInfo}; %% 搬运回尸体
                DieTimes > MinTimes andalso (DieTime + TimeCfg2 + 3) =< NowTime andalso NowTime < (RebornTime + TimeVal + 3) -> %%不是自动复活时间，而是搬运幽灵时间
                    RebornRef = util:send_after([], max((RebornTime + TimeVal - NowTime+3) * 1000, 500), self(), %%下一次复活
                        {'mod', lib_kf_sanctum, handle_revive_check_in_sanctuam, [Scene]}),
                    {_, Player1} = lib_revive:revive(Ps, ?REVIVE_ASHES),
                    NewModDieInfo = ModDieInfo#mod_player_die{reborn_ref = RebornRef},
                    NewPlayerDieInfo = maps:put(?MOD_KF_SANCTUM, NewModDieInfo, PlayerDieInfo),
                    Player1#player_status{player_die = NewPlayerDieInfo};
                true -> %% 直接复活
                    {_, Player1} = lib_revive:revive(Ps, ?REVIVE_ORIGIN),
                    Player1
            end
    end,
    {ok, NewPs}.