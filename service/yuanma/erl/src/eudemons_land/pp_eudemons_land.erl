%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 27 Oct 2017 by root <root@localhost.localdomain>

-module(pp_eudemons_land).

-export([handle/3]).
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("vip.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("dungeon.hrl").
-include("eudemons_land.hrl").
-include("boss.hrl").
-include("team.hrl").

%% 幻兽之域信息 pt_47000_[1]
handle(47000, Ps, [BossType]) ->
    case data_eudemons_land:get_eudemons_boss_type(BossType) of
        #eudemons_boss_type{tired = MaxTired} ->
            #player_status{id = RoleId, sid = Sid, server_id = ServerId} = Ps,
            [LTired, LTiredMax, CollectList] =
                if
                BossType == ?BOSS_TYPE_EUDEMONS ->
                    {NormalCount, RareCount, CrystalCount} = data_eudemons_boss_m:get_boss_collect_max(BossType),
                    {TiredMod, TiredSubMod, TiredCounterId} = data_eudemons_boss_m:get_counter_module(BossType, tired),
                    {CollMod, CollSubMod, CollCounterIdNormal} = data_eudemons_boss_m:get_counter_module(BossType, {collect, ?MON_CL_NORMAL}),
                    {CollMod, CollSubMod, CollCounterIdRare} = data_eudemons_boss_m:get_counter_module(BossType, {collect, ?MON_CL_RARE}),
                    {CollMod, CollSubMod, CollCounterIdCrystal} = data_eudemons_boss_m:get_counter_module(BossType, {collect, ?MON_CL_CRYSTAL}),
                    DailyCountList = [
                        {TiredMod, TiredSubMod, TiredCounterId},
                        {CollMod, CollSubMod, CollCounterIdNormal},
                        {CollMod, CollSubMod, CollCounterIdRare},
                        {CollMod, CollSubMod, CollCounterIdCrystal}
                    ],
                    [{_, Tired}, {_, CollectTimesNormal}, {_, CollectTimesRare}, {_, CollectTimesCrystal}] = mod_daily:get_count(RoleId, DailyCountList),
                    %Tired = mod_daily:get_count(RoleId, TiredMod, TiredSubMod, TiredCounterId),
                    %CollectTimesNormal = mod_daily:get_count(RoleId, CollMod, CollSubMod, CollCounterIdNormal),
                    %CollectTimesRare = mod_daily:get_count(RoleId, CollMod, CollSubMod, CollCounterIdRare),
                    %CollectTimesRare = mod_daily:get_count(RoleId, CollMod, CollSubMod, CollCounterIdRare),
                    CollectCountList = [
                        {?MON_CL_NORMAL, CollectTimesNormal, NormalCount},
                        {?MON_CL_RARE, CollectTimesRare, RareCount},
                        {?MON_CL_CRYSTAL, CollectTimesCrystal, CrystalCount}
                    ],
                    ?PRINT("47000 ~p~n", [CollectCountList]),
                    NewMaxTired = MaxTired + lib_eudemons_land:get_extra_times(Ps),
                    [Tired, NewMaxTired, CollectCountList];
                true ->
                    [0, 0, []]
            end,
            mod_eudemons_land_local:get_eudemons_boss_info(ServerId, RoleId, Sid, BossType, [LTired, LTiredMax, CollectList]);
        _ ->
            skip
    end;

%% boss的击杀情况 pt_47001_[1,1502201]
handle(47001, Ps, [BossType, BossId]) ->
    mod_eudemons_land_local:get_boss_kill_log(Ps#player_status.sid, BossType, BossId);

%% boss掉落的情况
handle(47002, Ps, []) ->
    mod_eudemons_land_local:get_boss_drop_log(Ps#player_status.sid);

%% 进入幻兽boss场景 pt_47003_[1,1501001]
handle(47003, Ps, [BossType, BossId]) ->
    case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
        [] ->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_470, 47003, [?ERRCODE(err460_no_boss_cfg)]);
        #eudemons_boss_cfg{scene = ConfScene} when ConfScene == Ps#player_status.scene->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_470, 47003, [?ERRCODE(err120_already_in_scene)]);
        _ ->
            case lib_player_check:check_list(Ps, [action_free]) of
                {false, Code} ->
                    lib_server_send:send_to_sid(Ps#player_status.sid, pt_470, 47003, [Code]);
                true->
                    case lib_boss:chang_other_mod_scene(Ps) of
                        {false, Code} ->
                            lib_server_send:send_to_sid(Ps#player_status.sid, pt_470, 47003, [Code]);
                        _ ->
                            case check_enter_eudemons_boss(Ps, BossType, BossId) of
                                {false, Code} ->
                                    ?PRINT("enter Code ~p~n", [Code]),
                                    lib_server_send:send_to_sid(Ps#player_status.sid, pt_470, 47003, [Code]);
                                {true, Scene, X, Y} ->
                                    NeedOut =lib_boss:is_in_outside_scene(Ps#player_status.scene),
                                    %% 进入幻兽之域
                                    EudemonsBoss = lib_eudemons_land:make_record(eudemons_boss, Ps),
                                    mod_clusters_node:apply_cast(mod_eudemons_land, enter_eudemons_land,
                                                                 [EudemonsBoss, BossType, BossId, Scene, X, Y, NeedOut])
                            end
                    end
            end
    end;

%% 离开boss场景 pt_47004_[1]
handle(47004, Ps, [_BossType]) ->
    case lib_eudemons_land:is_in_eudemons_boss(Ps#player_status.scene) of
        false -> skip;
        true ->
            case lib_scene:is_transferable_out(Ps) of
                {true, _} ->
                    ?PRINT("47004 47004 ~n", []),
                    #player_status{id = RoleId, scene = Scene, server_id = ServerId} = Ps,
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_eudemons_land, leave_eudemons_land, [Node, RoleId, Scene, ServerId]);
                {false, Res} ->
                    lib_server_send:send_to_sid(Ps#player_status.sid, pt_470, 47004, [Res])
            end
    end;

%% BOSS关注操作 pt_47005_[1,1201001,1]
handle(47005, Ps, [BossType, BossId, Remind]) ->
    mod_eudemons_land_local:boss_remind_op(Ps#player_status.id, BossType, BossId, Remind);

%%
handle(47019, Ps, []) ->
    lib_eudemons_land:send_eudemons_level(Ps);

%% BOSS重生提醒47006

%% BOSS被击杀信息40007

%%% 榜单信息
handle(47021, Ps, []) ->
    lib_eudemons_land:send_rank_info(Ps);


%%%
handle(47034, PS, []) ->
    #player_status{id = RoleId, status_boss = #status_boss{boss_map = TmpMap}} = PS,
    case data_boss:get_boss_type_kv(?BOSS_TYPE_PHANTOM, player_die_times) of
        TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
        _ -> TimeCfg = 300
    end, %% 更新死亡debuff
    case data_boss:get_boss_type_kv(?BOSS_TYPE_PHANTOM, revive_point_gost) of
        TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
        _ -> TimeCfg2 = 20
    end,
    case data_boss:get_boss_type_kv(?BOSS_TYPE_PHANTOM, die_wait_time) of
        [{min_times, MinTimes},_,_]  -> skip;
        _ -> MinTimes = 0
    end,
    case maps:get(?BOSS_TYPE_PHANTOM, TmpMap, []) of
        #role_boss{die_time = DieTime, die_times = DieTimes, next_enter_time = NextEnterTime} ->
            ?PRINT("47034 RoleBoss ~p~n", [{NextEnterTime, DieTime, DieTimes}]),
            if
                DieTimes > MinTimes ->
                    lib_server_send:send_to_uid(RoleId, pt_470, 47034, [DieTimes, NextEnterTime, DieTime + TimeCfg, DieTime + TimeCfg2]);
                true ->
                    lib_server_send:send_to_uid(RoleId, pt_470, 47034, [DieTimes, NextEnterTime, DieTime + TimeCfg, 0])
            end;
        _ ->
            ?PRINT("47034 RoleBoss ~p~n", [{0, 0, 0}]),
            lib_server_send:send_to_uid(RoleId, pt_470, 47034, [0, 0, 0, 0])
    end,
    {ok, PS};

%% 复活boss
handle(47035, Ps, [BossType, BossId]) ->
    lib_eudemons_land:cost_reborn(Ps, BossType, BossId);

%% 默认匹配
handle(_Cmd, Ps, _Data) ->
    io:format("~p ~p boss _Cmd, _Data:~w~n", [?MODULE, ?LINE, [_Cmd, _Data]]),
    {ok, Ps}.


%% ================================= private fun =================================
%% 检查进入Boss场景
check_enter_eudemons_boss(Ps, BossType, BossId) ->
    BossOpen = lib_eudemons_land:eudemons_boss_open(),
    case data_eudemons_land:get_eudemons_boss_type(BossType) of
        [] -> {false, ?ERRCODE(err460_no_boss_type)};
        _ when BossOpen == false ->
            {false, ?ERRCODE(err470_boss_not_open)};
        _ ->
            case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
                [] -> {false, ?ERRCODE(err460_no_boss_cfg)};
                #eudemons_boss_cfg{condition = BossCondition} = BossCfg ->
                    case check_condition(BossCondition, Ps) of
                        true ->
                            case Ps#player_status.team of
                                #status_team{team_id = TeamId} when TeamId > 0 ->
                                    {false, ?ERRCODE(err470_in_team)};
                                _ ->
                                    #eudemons_boss_cfg{scene = Scene} = BossCfg,
                                    #ets_scene{x = TX, y = TY} = data_scene:get(Scene),
                                    {true, Scene, TX, TY}
                            end;
                        ErrorRes ->
                            ErrorRes
                    end
            end
    end.

check_condition([], _Ps) -> true;
check_condition([{lv, NeedLv}|Condition], Ps) ->
    #figure{lv = Lv} = Ps#player_status.figure,
    if
        Lv >= NeedLv -> check_condition(Condition, Ps);
        true -> {false, ?ERRCODE(err460_no_lv)}
    end.
