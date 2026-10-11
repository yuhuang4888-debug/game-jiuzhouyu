-module(lib_kf_sanctum_mod).

-include("kf_sanctum.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("server.hrl").
-include("clusters.hrl").

-export([
        init/0
        ,notify_player_act_start/2
        ,update_zone_map/3
        ,act_start/1
        ,boss_reborn/7
        ,boss_be_killed/7
        ,act_end/1
        ,enter/6
        ,exit/4
        ,reconect/5
        ,gm_start_act/2

        ,quit_timeout/1
        ,clear_scene_palyer/1
        ,clear_scene_palyer/2
        ,update_all_server/3
        ,calc_next_open_time/0
        ,gm_clear_server_user/2
        ,clear_scene_palyer_helper/1
    ]).

init() ->
    NowTime = utime:unixtime(),
    {NextOpenTimeDis, NextEndTimeDis} = calc_next_open_time(NowTime),
    case data_sanctum:get_value(limit_enter_time) of
        Mintue when is_integer(Mintue) ->Mintue;
        _ -> Mintue = 4
    end,
    case data_sanctum:get_value(notify_before_start) of
        BefMintue when is_integer(BefMintue) ->BefMintue;
        _ -> BefMintue = 5
    end,
    LimitTime = NowTime + NextOpenTimeDis + Mintue*60,
    if
        NextOpenTimeDis > BefMintue*60 ->
            NotifyRef = erlang:send_after((NextOpenTimeDis - BefMintue*60)*1000, self(), {'notify_player_act_start', BefMintue});
        NextOpenTimeDis =< BefMintue*60 ->
            NotifyRef = erlang:send_after(1000, self(), {'notify_player_act_start', 0})
    end,
    mod_zone_mgr:kf_sanctum_init(),
    #kf_sanctum_state{
        zone_map = #{},                                         %% zone_id => [ServerId,...]
        server_info = [],                                       %% [{ServerId,Optime, WorldLv, ServerNum, ServerName}...]
        scene_info = #{},                                       %% zone_id => [#sanctum_scene_info{}]
        scene_bl_server = [],                                   %% {zone_id, [serverid, ...]} 拥有高级场景进入权限的服务器id
        enter_time_limit = LimitTime,                           %% 最后可进入活动时间戳
        notify_player_ref = NotifyRef,                          %% 活动开启前通知
        act_start_time = NextOpenTimeDis + NowTime,             %% 活动开启时间戳
        act_start_ref = undefined,                              %% 活动开启定时器
        act_end_time = NextEndTimeDis + NowTime,                %% 活动结束时间戳
        act_end_ref = undefined                                 %% 活动结束定时器
    }.

gm_start_act(State, Min) ->
    NowTime = utime:unixtime(),
    #kf_sanctum_state{notify_player_ref = NotifyRef} = State,
    util:cancel_timer(NotifyRef),
    case data_sanctum:get_value(limit_enter_time) of
        Mintue when is_integer(Mintue) ->Mintue;
        _ -> Mintue = 4
    end,
    Ref = erlang:send_after(1000, self(), {'notify_player_act_start', 1}),
    State#kf_sanctum_state{notify_player_ref = Ref, act_start_time = NowTime, enter_time_limit = NowTime + Mintue*60, act_end_time = NowTime+Min*60}.

notify_player_act_start(State, BefMintue) ->
    #kf_sanctum_state{
        zone_map = ZoneMap,
        notify_player_ref = NotifyRef,
        act_start_time = ActOpenTime,
        enter_time_limit = LimitTime,
        act_end_time = ActEndTime,
        act_start_ref = StartRef,
        server_info = ServerInfo,
        max_world_lv_map = WorldLvMap
        } = State,
    util:cancel_timer(StartRef),
    util:cancel_timer(NotifyRef),
    List = maps:to_list(ZoneMap),
    NowTime = utime:unixtime(),
    SceneInfo = calc_scene_info(List, ServerInfo, WorldLvMap, BefMintue, #{}),
    if
        BefMintue > 0 ->
            spawn(fun() ->
                Fun = fun({_ZoneId, ServerIds}) ->
                    timer:sleep(50),
                    SceneInfoList = maps:get(_ZoneId, SceneInfo, []),
                    SendUpSceneInfoL =
                        [begin
                             NewMons = [M#sanctum_mon_info{reborn_ref = undefined} || M <- Mons],
                             T#sanctum_scene_info{mon = NewMons}
                        end|| #sanctum_scene_info{mon = Mons} = T <- SceneInfoList],
                    Fun1 = fun(ServerId) ->
                        lib_kf_sanctum:send_tv_to_all(ServerId, 1, [BefMintue]),
                        mod_clusters_center:apply_cast(ServerId, mod_kf_sanctum_local, update_info, [time, [ActOpenTime, ActEndTime, LimitTime, SendUpSceneInfoL]])
                    end,
                    lists:foreach(Fun1, ServerIds)
                end,
                lists:foreach(Fun, List)
            end);
        true ->
            skip
    end,
    NextOpenTimeDis = max(1, ActOpenTime - NowTime),
    NewStartRef = erlang:send_after(NextOpenTimeDis*1000, self(), {'act_start'}),
    State#kf_sanctum_state{notify_player_ref = undefined, act_start_ref = NewStartRef, scene_bl_server = [], scene_info = SceneInfo}.

act_start(State) ->
    #kf_sanctum_state{
        zone_map = ZoneMap,
        act_start_time = _ActOpenTime,
        act_start_ref = StartRef,
        enter_time_limit = LimitTime,
        act_end_time = ActEndTime,
        act_end_ref = EndRef
        } = State,
    util:cancel_timer(StartRef),
    util:cancel_timer(EndRef),
    List = maps:to_list(ZoneMap),
    case data_sanctum:get_value(limit_enter_time) of
        Mintue when is_integer(Mintue) ->Mintue;
        _ -> Mintue = 4
    end,
    case data_sanctum:get_value(open_lv) of
        OpenLv when is_integer(OpenLv) -> skip;
        _ -> OpenLv = 480
    end,
    {ok, BinData} = pt_279:write(27900, [_ActOpenTime, LimitTime, ActEndTime]),
    %% 活动截止参与时间广播
    spawn(fun() ->
        Fun = fun({_ZoneId, ServerIds}) ->
            timer:sleep(50),
            [begin
                lib_kf_sanctum:send_tv_to_all(ServerId, 2, [Mintue]),
                lib_kf_sanctum:send_to_all(ServerId, all_lv, {OpenLv, 9999}, BinData)
            end || ServerId <- ServerIds]
        end,
        lists:foreach(Fun, List)
    end),
    NowTime = utime:unixtime(),
    DisTime = max(1, ActEndTime - NowTime),
    NewEndRef = erlang:send_after(DisTime * 1000, self(), {'act_end'}),
    State#kf_sanctum_state{act_end_ref = NewEndRef, act_start_ref = undefined}.

update_zone_map(State, ServerInfo, Z2SMap) ->
    ZoneMapList = maps:to_list(Z2SMap),
    case data_sanctum:get_value(open_day_limit) of
        OpenDayLimit when is_integer(OpenDayLimit) andalso OpenDayLimit > 1 ->OpenDayLimit;
        _ -> OpenDayLimit = 15
    end,
    {ZoneMap, WorldLvMap} = calc_real_zone_map(ZoneMapList, ServerInfo, #{}, #{}, OpenDayLimit),
    State#kf_sanctum_state{zone_map = ZoneMap, server_info = ServerInfo, max_world_lv_map = WorldLvMap}.

boss_reborn(State, CopyId, Scene, MonType, MonName, BossId, SanMontype) -> %% copyid == zoneid
    #kf_sanctum_state{
        zone_map = ZoneMap,
        server_info = _ServerInfo,
        scene_info = SceneInfo} = State,
    SceneInfoList = maps:get(CopyId, SceneInfo, []),
    case lists:keyfind(Scene, #sanctum_scene_info.scene, SceneInfoList) of
        #sanctum_scene_info{mon = Mons} = SanSceneInfo ->
            case lists:keyfind(BossId, #sanctum_mon_info.mon_id, Mons) of
                #sanctum_mon_info{mon_id = BossId, sanctum_mon_type = SanMontype, mon_lv = WorldLv, reborn_ref = RebornRef, x = X, y = Y} = Mon ->
                    util:cancel_timer(RebornRef),
                    %% 先清怪物
                    lib_mon:clear_scene_mon_by_mids(Scene, 0, CopyId, 1, [BossId]),
                    lib_mon:async_create_mon(BossId, Scene, 0, X, Y, MonType,
                            CopyId, 1, [{auto_lv, WorldLv}, {type, MonType}]),
                    NewMon = Mon#sanctum_mon_info{reborn_time = 0, reborn_ref = undefined, rank_list = []},
                    update_zone(ZoneMap, CopyId, mon_reborn, [{mon, Scene, NewMon}]),
                    {ok, Bin} = pt_279:write(27907, [BossId]),
                    lib_server_send:send_to_scene(Scene, 0, CopyId, Bin),
                    if
                        SanMontype == ?SANMONTYPE_BOSS ->
                            lib_kf_sanctum:send_tv_to_scene(Scene, 0, CopyId, 6, [MonName, MonName]);
                        true ->
                            skip
                    end,
                    NewMons = lists:keystore(BossId, #sanctum_mon_info.mon_id, Mons, NewMon);
                _ ->
                    NewMons = Mons
            end,
            NewSanSceneInfo = SanSceneInfo#sanctum_scene_info{mon = NewMons},
            NewSceneInfoList = lists:keystore(Scene, #sanctum_scene_info.scene, SceneInfoList, NewSanSceneInfo);
        _ ->
            NewSceneInfoList = SceneInfoList
    end,
    NewSceneInfo = maps:put(CopyId, NewSceneInfoList, SceneInfo),
    State#kf_sanctum_state{scene_info = NewSceneInfo}.

boss_be_killed(State, BLWhos, Klist, Scene, _ScenePoolId, CopyId, BossId) ->
    #kf_sanctum_state{
        zone_map = ZoneMap,
        server_info = _ServerInfo,
        scene_bl_server = SceneBlserverList,
        scene_info = SceneInfo} = State,
    SceneInfoList = maps:get(CopyId, SceneInfo, []),
    NowTime = utime:unixtime(),
    ServerIdList = maps:get(CopyId, ZoneMap, []),
    case data_mon:get(BossId) of
        [] -> BossName = <<>>, MonType = 1;
        #mon{name = BossName, type = MonType} -> skip
    end,
    SortList = lists:reverse(lists:keysort(#mon_atter.hurt, Klist)), %% 由大到小
    Fun = fun(P, {Acc, TemRank, Acc1}) ->
        #mon_atter{id = TRoleId, server_id = TServerId, server_name = ServerName, name = TRoleName, hurt = Hurt, server_num = ServerNum} = P,
        case data_sanctum:get_hurt_reward(TemRank+1, BossId) of
            Rewards when is_list(Rewards) andalso Rewards =/= [] ->
                lib_log_api:log_sanctum_rank(Scene, BossId, TemRank+1, TServerId, TRoleId, TRoleName, Rewards),
                % lib_kf_sanctum:send_rank_rewards(TServerId, TRoleId, BossName, TemRank+1, Rewards);
                NewAcc1 = [{TServerId, TRoleId, BossName, TemRank+1, Rewards}|Acc1];
            _ ->
                NewAcc1 = Acc1
        end,
        {[{TServerId, ServerNum, ServerName, TRoleId, TRoleName, Hurt, TemRank+1}|Acc], TemRank+1, NewAcc1}
    end,
    {RankList, _Total, RewardArgList} = lists:foldl(Fun, {[], 0, []}, SortList), %%伤害由大到小的列表
    spawn(fun() -> [begin timer:sleep(50), lib_kf_sanctum:send_rank_rewards(TServerId, TRoleId, TBossName, TemRank, Rewards) end
        || {TServerId, TRoleId, TBossName, TemRank, Rewards}<-RewardArgList] end),

    case lists:keyfind(Scene, #sanctum_scene_info.scene, SceneInfoList) of
        #sanctum_scene_info{mon = Mons, bl_server = OldBlserver, bl_server_num = OldBlserverNum, bl_server_name = OldBlServerName} = SanSceneInfo ->
            case lists:keyfind(BossId, #sanctum_mon_info.mon_id, Mons) of
                #sanctum_mon_info{mon_id = BossId, sanctum_mon_type = SanMontype, mon_lv = _WorldLv, reborn_ref = RebornRef} = Mon ->
                    util:cancel_timer(RebornRef),
                    case data_sanctum:get_mon_type(SanMontype) of
                        #base_sanctum_montype{reborn_time = RefreshTime} when is_integer(RefreshTime) andalso RefreshTime > 0 ->
                            BlserverId = OldBlserver, BlServerNum = OldBlserverNum, BlServerName = OldBlServerName,
                            NRebornRef = erlang:send_after(RefreshTime*1000, self(), {'boss_reborn', CopyId, Scene, MonType, BossName, BossId, SanMontype}),
                            RebornTime = RefreshTime + NowTime,
                            {ok, Bin} = pt_279:write(27908, [BossId, RebornTime, BlserverId, BlServerNum, BlServerName]),
                            lib_server_send:send_to_scene(Scene, 0, CopyId, Bin),
                            NewMon = Mon#sanctum_mon_info{reborn_time = RebornTime, reborn_ref = NRebornRef, rank_list = RankList};

                        #base_sanctum_montype{} when SanMontype == ?SANMONTYPE_BOSS ->
                            {BlserverId, BlServerNum, BlServerName} = calc_bl_server(BLWhos, SanMontype, BossName, Scene, ServerIdList),
                            lib_log_api:log_sanctum_boss(Scene, BossId, BlserverId),
                            % ?PRINT("========= {BossId,BlserverId}:~p,BLWhos:~p~n",[{BossId,BlserverId}, BLWhos]),
                            {ok, Bin} = pt_279:write(27908, [BossId, 0, BlserverId, BlServerNum, BlServerName]),
                            lib_server_send:send_to_scene(Scene, 0, CopyId, Bin),
                            NewMon = Mon#sanctum_mon_info{reborn_time = 0, reborn_ref = undefined, rank_list = RankList};
                        _ ->
                            BlserverId = OldBlserver, BlServerNum = OldBlserverNum, BlServerName = OldBlServerName, NewMon = Mon
                    end,
                    UpdateMonList = [{mon, Scene, NewMon#sanctum_mon_info{reborn_ref = undefined}}],
                    NewMons = lists:keystore(BossId, #sanctum_mon_info.mon_id, Mons, NewMon);
                _ ->
                    UpdateMonList = [], NewMons = Mons, BlserverId = OldBlserver,
                    BlServerNum = OldBlserverNum, BlServerName = OldBlServerName
            end,
            case lists:keyfind(CopyId, 1, SceneBlserverList) of
                {_, ServerIdS} ->
                    case lists:member(BlserverId, ServerIdS) of
                        false ->
                            if
                                BlserverId =/= 0 ->
                                    NewLsit = lists:keystore(CopyId, 1, SceneBlserverList, {CopyId, [BlserverId|ServerIdS]});
                                true ->
                                    NewLsit = SceneBlserverList
                            end;
                        _ ->
                            NewLsit = SceneBlserverList
                    end;
                _ ->
                    if
                        BlserverId =/= 0 ->
                            NewLsit = lists:keystore(CopyId, 1, SceneBlserverList, {CopyId, [BlserverId]});
                        true ->
                            NewLsit = SceneBlserverList
                    end
            end,
            % ?PRINT("======= BlserverId:~p,NewLsit:~p~n",[BlserverId,NewLsit]),
            NewSanSceneInfo = SanSceneInfo#sanctum_scene_info{mon = NewMons, bl_server = BlserverId, bl_server_name = BlServerName, bl_server_num = BlServerNum},
            UpdateList = [{bl_server, Scene, BlserverId, BlServerName, BlServerNum}|UpdateMonList],
            NewSceneInfoList = lists:keystore(Scene, #sanctum_scene_info.scene, SceneInfoList, NewSanSceneInfo);
        _ ->
            NewSceneInfoList = SceneInfoList, NewLsit = SceneBlserverList, UpdateList = []
    end,
    case lists:keyfind(CopyId, 1, NewLsit) of
        {_, BlServerIdL} -> skip;
        _ -> BlServerIdL = []
    end,
    NewSceneInfo = maps:put(CopyId, NewSceneInfoList, SceneInfo),
    update_zone(ZoneMap, CopyId, scene_bl, [UpdateList, BlServerIdL]),
    State#kf_sanctum_state{scene_info = NewSceneInfo, scene_bl_server = NewLsit}.

act_end(State) ->
    #kf_sanctum_state{
        zone_map = ZoneMap,
        scene_info = SceneInfo,
        act_end_ref = EndRef
        } = State,
    util:cancel_timer(EndRef),
    NowTime = utime:unixtime(),
    {NextOpenTimeDis, NextEndTimeDis} = calc_next_open_time(NowTime),
    case data_sanctum:get_value(limit_enter_time) of
        Mintue when is_integer(Mintue) ->Mintue;
        _ -> Mintue = 4
    end,
    case data_sanctum:get_value(notify_before_start) of
        BefMintue when is_integer(BefMintue) ->BefMintue;
        _ -> BefMintue = 5
    end,
    LimitTime = NowTime + NextOpenTimeDis + Mintue*60,
    if
        NextOpenTimeDis > BefMintue ->
            NotifyRef = erlang:send_after((NextOpenTimeDis - BefMintue*60)*1000, self(), {'notify_player_act_start', BefMintue});
        true ->
            NotifyRef = erlang:send_after(1000, self(), {'notify_player_act_start', 0})
    end,
    List = maps:to_list(ZoneMap),
    %% 清理玩家
    spawn(fun() ->
        F = fun({ZoneId, SceneInfoList}) ->
            timer:sleep(20),
            [begin
                 mod_scene_agent:apply_cast(Scene, 0, lib_kf_sanctum_mod, clear_scene_palyer, [ZoneId]),
                 lib_mon:clear_scene_mon(Scene, 0, ZoneId, 0)
             end || #sanctum_scene_info{scene = Scene} <- SceneInfoList]
        end,
        lists:foreach(F, maps:to_list(SceneInfo))
    end),
    case data_sanctum:get_value(open_lv) of
        OpenLv when is_integer(OpenLv) -> skip;
        _ -> OpenLv = 480
    end,
    {ok, BinData} = pt_279:write(27900, [NextOpenTimeDis + NowTime, LimitTime, NextEndTimeDis + NowTime]),
    Fun = fun({_ZoneId, ServerIds}) ->
        Fun1 = fun(ServerId) ->
            lib_kf_sanctum:send_tv_to_all(ServerId, 5, []),
            lib_kf_sanctum:send_to_all(ServerId, all_lv, {OpenLv, 9999}, BinData),
            mod_clusters_center:apply_cast(ServerId, mod_kf_sanctum_local, update_info, [time, [NextOpenTimeDis + NowTime, NextEndTimeDis + NowTime, LimitTime, []]])
        end,
        lists:foreach(Fun1, ServerIds)
    end,
    lists:foreach(Fun, List),
    State#kf_sanctum_state{
        scene_info = #{},
        scene_bl_server = [],
        enter_time_limit = LimitTime,
        notify_player_ref = NotifyRef,
        act_start_time = NextOpenTimeDis + NowTime,
        act_end_time = NextEndTimeDis + NowTime,
        act_end_ref = undefined,
        scene_user = #{},
        reborn_point = #{}
    }.

enter(State, ServerId, Node, RoleId, Scene, RoleScene) ->
    #kf_sanctum_state{
        zone_map = ZoneMap,
        scene_user = SceneUser,
        reborn_point = RebornPoint} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    case data_scene:get(RoleScene) of
        #ets_scene{type = ?SCENE_TYPE_SANCTUM} ->
            RoleSceneType = ?SCENE_TYPE_SANCTUM;
        _ -> RoleSceneType = skip
    end,
    SceneUserList = maps:get(ZoneId, SceneUser, []),
    case lists:keyfind(Scene, 1, SceneUserList) of
        {_, UserList} ->
            skip;
        _ ->
            UserList = []
    end,
    {ok, BinData} = pt_279:write(27902, [1]),
    {NewSceneUser, NewRebornPoint} =
        enter_core(UserList, SceneUserList, ZoneMap, ZoneId, RebornPoint, SceneUser, Scene, ServerId, RoleId, Node, RoleSceneType),
    lib_kf_sanctum:send_to_role(Node, RoleId, BinData),
    State#kf_sanctum_state{scene_user = NewSceneUser, reborn_point = NewRebornPoint}.

exit(State, ServerId, RoleId, Scene) ->
    #kf_sanctum_state{
        zone_map = ZoneMap,
        scene_user = SceneUser} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    SceneUserList = maps:get(ZoneId, SceneUser, []),
    case lists:keyfind(Scene, 1, SceneUserList) of
        {_, UserList} ->
            skip;
        _ ->
            UserList = []
    end,
    NewUserList = lists:delete(RoleId, UserList),
    NewSceneUserList = lists:keystore(Scene, 1, SceneUserList, {Scene, NewUserList}),
    update_zone(ZoneMap, ZoneId, join, [Scene, RoleId]),
    NewSceneUser = maps:put(ZoneId, NewSceneUserList, SceneUser),
    State#kf_sanctum_state{scene_user = NewSceneUser}.

reconect(State, ServerId, RoleId, _Scene, {Args, Args2}) ->
    #kf_sanctum_state{
        act_end_time = ActEndTime,
        act_start_time = ActOpenTime} = State,
    NowTime = utime:unixtime(),
    if
        ActOpenTime =< NowTime andalso ActEndTime > NowTime ->
            if
                Args =/= [] andalso Args2 =/= [] ->
                    PlayerArgs = [RoleId, ?APPLY_CAST_STATUS, lib_kf_sanctum, notify_re_login, [Args, Args2]],
                    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, PlayerArgs);
                true ->
                    mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_relogin_scene,[RoleId, []])
            end,
            State;
        true ->
            mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_default_scene,
                            [RoleId, [{recalc_attr, 0}, {change_scene_hp_lim, 100},{ghost, 0},{pk, {?PK_PEACE, true}}]]),
            State
    end.

gm_clear_server_user(State, ServerId) ->
    #kf_sanctum_state{
        scene_info = SceneInfo
        } = State,
    %% 清理玩家
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    SceneInfoList = maps:get(ZoneId, SceneInfo, []),
    [
        mod_scene_agent:apply_cast(Scene, 0, ?MODULE, clear_scene_player, [ZoneId, ServerId])
        || #sanctum_scene_info{scene = Scene} <- SceneInfoList
    ],
    State.
%%  ================================分割线=====================================
calc_next_open_time() ->
    calc_next_open_time(utime:unixtime()).

calc_next_open_time(NowTime) ->
    Day = utime:day_of_week(NowTime),
    {OpenList, OpenDayList} = get_cfg_list(),
    [{{Sh, Sm}, {Eh, Em}} | _] = OpenList,
    {Date, _Time} = utime:unixtime_to_localtime(NowTime),
    DisTime = get_next_open_time(Day, 0, OpenDayList),
    case lists:member(Day, OpenDayList) of
        true ->
            {_, {NowSH, NowSM, _}} = utime:unixtime_to_localtime(NowTime),
            case get_next_time({NowSH, NowSM}, OpenList) of %%获取开启时间段中第一个开启时间大于nowtime的时间
                {ok, {{SH, SM}, {EH, EM}}} ->
                    TemStartT = utime:unixtime({Date, {SH, SM, 0}}),
                    TemEndT = utime:unixtime({Date, {EH, EM, 0}}),
                    {TemStartT - NowTime, TemEndT - NowTime};
                _ ->
                    {Date1, _Time1} = utime:unixtime_to_localtime(NowTime + DisTime),
                    TemEndT = utime:unixtime({Date1, {Eh, Em, 0}}),
                    RealStartT = utime:unixtime({Date1, {Sh, Sm, 0}}),
                    {RealStartT - NowTime, TemEndT - NowTime}
            end;
        false ->
            {Date1, _Time1} = utime:unixtime_to_localtime(NowTime + DisTime),
            RealStartT = utime:unixtime({Date1, {Sh, Sm, 0}}),
            TemEndT = utime:unixtime({Date1, {Eh, Em, 0}}),
            {RealStartT - NowTime, TemEndT - NowTime}
    end.

get_cfg_list() ->
    case data_sanctum:get_value(act_open_list) of
        OpenList when is_list(OpenList) ->
            case lists:keyfind(day, 1, OpenList) of
                {_, DayList} when is_list(DayList) -> DayList;
                _ -> DayList = []
            end,
            case lists:keyfind(time, 1, OpenList) of
                {_, TimeList} when is_list(TimeList) -> TimeList;
                _ -> TimeList = [{{21,0},{21,20}}]
            end;
        _ ->
            DayList = [2,4],TimeList = [{{21,0},{21,20}}]
    end,
    {TimeList, DayList}.

get_next_open_time(Day, TempTime, OpenDayList) -> %%距离下一个开放日的时间差距（s）
    case Day + 1 =< 7 of
        true ->
            case lists:member(Day + 1, OpenDayList) of
                true ->
                    TempTime + 86400;
                false ->
                    get_next_open_time(Day + 1, TempTime + 86400, OpenDayList)
            end;
        false ->
            get_next_open_time(0, TempTime, OpenDayList)
    end.

get_next_time({TemSH, TemSM}, OpenList) ->
    Tem = TemSH * 60 + TemSM,
    Fun = fun({{SH, SM}, _}) ->
        Tem < SH * 60 + SM
          end,
    ulists:find(Fun, OpenList).%%返回第一个比TemS大的活动开启时间(如果存在)

calc_server_openday(Optime) ->
    Now = utime:unixtime(),
    Day = (Now - Optime) div 86400,
    Day + 1.

calc_real_zone_map([], _, NewMap, NewWorldLvMap, _) -> {NewMap, NewWorldLvMap};
calc_real_zone_map([{ZoneId, ServerIds}|ZoneMapList], ServerInfo, Map, WorldLvMap, OpenDayLimit) ->
    Fun = fun(ServerId, {Acc, TemWorldLv}) ->
        case lists:keyfind(ServerId, 1, ServerInfo) of
            {ServerId, Optime, WorldLv, _ServerNum, _ServerName} ->
                OpenDay = calc_server_openday(Optime),
                if
                    TemWorldLv < WorldLv ->
                        NewWorldLv = WorldLv;
                    true ->
                        NewWorldLv = TemWorldLv
                end,
                if
                    OpenDay >= OpenDayLimit ->
                        {[ServerId|Acc], NewWorldLv};
                    true ->
                        {Acc, TemWorldLv}
                end;
            _ ->
                {Acc, TemWorldLv}
        end
    end,
    {NewServerIds, MaxWorldLv} = lists:foldl(Fun, {[], 0}, ServerIds),
    NewMap = maps:put(ZoneId, NewServerIds, Map),
    NewWorldLvMap = maps:put(ZoneId, MaxWorldLv, WorldLvMap),
    calc_real_zone_map(ZoneMapList, ServerInfo, NewMap, NewWorldLvMap, OpenDayLimit).

calc_scene_info([], _ServerInfo, _WorldLvMap, _BefMintue, NewMap) -> NewMap;
calc_scene_info([{ZoneId, _}|ZoneMapList], ServerInfo, WorldLvMap, BefMintue, SceneInfo) ->
    SceneList = data_sanctum:get_all_scene(),
    WorldLv = maps:get(ZoneId, WorldLvMap, 0),
    SceneInfoList = calc_scene_info_helper(BefMintue, SceneList, WorldLv, ZoneId, []),
    NewMap = maps:put(ZoneId, SceneInfoList, SceneInfo),
    calc_scene_info(ZoneMapList, ServerInfo, WorldLvMap, BefMintue, NewMap).

calc_scene_info_helper(_, [], _WorldLv, _ZoneId, SceneInfoList) -> SceneInfoList;
calc_scene_info_helper(BefMintue, [Scene|SceneList], WorldLv, ZoneId, SceneInfoList) ->
    SanMontypes = data_sanctum:get_scene_montype(Scene),
    lib_mon:clear_scene_mon(Scene, 0, ZoneId, 0),
    F = fun(SanMontype, Acc) ->
        case data_sanctum:get_mon_type(SanMontype) of
            #base_sanctum_montype{refresh = RefreshRule} ->
                case lists:keyfind(time, 1, RefreshRule) of
                    {_, Mintue} when is_integer(Mintue) andalso Mintue > 0 ->
                        Mintue;
                    _ ->
                        Mintue = 0
                end,
                #base_sanctum_scene{mon = MonInfo} = data_sanctum:get_scene_mon_info(Scene, SanMontype),
                calc_scene_info_core(MonInfo, Scene, ZoneId, WorldLv, BefMintue, Mintue, SanMontype, Acc);
            _ ->
                Acc
        end
    end,
    Mons = lists:foldl(F, [], SanMontypes),
    SanctumScene = #sanctum_scene_info{zone_id = ZoneId, scene = Scene, bl_server = 0, mon = Mons},
    calc_scene_info_helper(BefMintue, SceneList, WorldLv, ZoneId, [SanctumScene|SceneInfoList]).

calc_scene_info_core([], _Scene, _CopyId, _WorldLv, _, _Mintue, _SanMontype, Mons) -> Mons;
calc_scene_info_core([{BossId, X, Y}|MonInfo], Scene, CopyId, WorldLv, BefMintue, Mintue, SanMontype, Mons) when SanMontype =/= ?SANMONTYPE_MONSTER ->
    case data_mon:get(BossId) of
        [] -> MonType = 1, BossName = <<>>;
        #mon{type = MonType, name = BossName} -> ok
    end,
    if
        Mintue == 0 ->
            % %% 先清怪物
            % lib_mon:clear_scene_mon_by_mids(Scene, 0, CopyId, 1, [BossId]),
            lib_mon:async_create_mon(BossId, Scene, 0, X, Y, MonType,
                    CopyId, 1, [{auto_lv, WorldLv}, {type, MonType}]),
            RebornRef = undefined, RebornTime = 0;
        true ->
            % %% 先清怪物
            % lib_mon:clear_scene_mon_by_mids(Scene, 0, CopyId, 1, [BossId]),
            RebornRef = erlang:send_after((Mintue+BefMintue)*60*1000, self(), {'boss_reborn', CopyId, Scene, MonType, BossName, BossId, SanMontype}),
            RebornTime = (Mintue+BefMintue)*60 + utime:unixtime()
    end,
    Mon = #sanctum_mon_info{mon_id = BossId, sanctum_mon_type = SanMontype, mon_lv = WorldLv,
            reborn_ref = RebornRef, reborn_time = RebornTime, rank_list = [], x = X, y = Y},
    calc_scene_info_core(MonInfo, Scene, CopyId, WorldLv, BefMintue, Mintue, SanMontype, [Mon|Mons]);
calc_scene_info_core([{BossId, X, Y}|MonInfo], Scene, CopyId, WorldLv, BefMintue, Mintue, SanMontype, Mons) when SanMontype == ?SANMONTYPE_MONSTER ->
    case data_mon:get(BossId) of
        [] -> MonType = 1;
        #mon{type = MonType} -> ok
    end,
    lib_mon:async_create_mon(BossId, Scene, 0, X, Y, MonType, CopyId, 1, [{auto_lv, WorldLv}, {type, MonType}]),
    calc_scene_info_core(MonInfo, Scene, CopyId, WorldLv, BefMintue, Mintue, SanMontype, Mons).

calc_bl_server([], _, _, _, _) -> {0, 0, <<>>};
calc_bl_server([#mon_atter{name = RoleName, server_id = ServerId, server_num = ServerNum, server_name = ServerName}|_], SanMontype, MonName, Scene, ServerIdList) when SanMontype == ?SANMONTYPE_BOSS ->
    case data_sanctum:get_value(high_sence) of
        HScene when HScene == Scene ->
            MsgId = 4;
        _ ->
            MsgId = 3
    end,
    spawn(fun() ->
        if
            MsgId == 4 ->
                [mod_clusters_center:apply_cast(TServerId, mod_kf_sanctum_local, send_tv_to_act_user, [MsgId, [ServerNum, ServerName, MonName]])|| TServerId <- ServerIdList];
            true ->
                case data_scene:get(Scene) of
                    #ets_scene{name = SceneName} ->
                        skip;
                    _ ->
                        SceneName = <<>>
                end,
                %% 服务器名字是个二进制数据，将其转换后才能在传闻里使用
                ServerNameF = unicode:characters_to_list(ServerName),
                TvArgs = [ServerNum, RoleName, SceneName, MonName, ServerId, ServerNameF],
                [mod_clusters_center:apply_cast(TServerId, mod_kf_sanctum_local, send_tv_to_act_user, [7, TvArgs]) || TServerId <- ServerIdList, TServerId =/= ServerId],
                mod_clusters_center:apply_cast(ServerId, mod_kf_sanctum_local, send_tv_to_act_user, [MsgId, TvArgs])
        end
    end),
    {ServerId, ServerNum, ServerName};
calc_bl_server(_, _, _, _, _) -> {0, 0, <<>>}.

update_all_server(ZoneMap, Type, Args) ->
    ZoneMapList = maps:to_list(ZoneMap),
    Fun = fun(_ZoneId, ServerIds) ->
        [mod_clusters_center:apply_cast(ServerId, mod_kf_sanctum_local, update_info, [Type, Args])|| ServerId <- ServerIds]
    end,
    lists:foreach(Fun, ZoneMapList).

update_zone(ZoneMap, ZoneId, Type, Args) ->
    ServerIds = maps:get(ZoneId, ZoneMap, []),
    [mod_clusters_center:apply_cast(ServerId, mod_kf_sanctum_local, update_info, [Type, Args])|| ServerId <- ServerIds].

%% 清理玩家
clear_scene_palyer(CopyId) ->
    UserList = lib_scene_agent:get_scene_user(CopyId),
    HandList = make_data_for_clear(UserList),
    [begin
        mod_clusters_center:apply_cast(ServerId, lib_kf_sanctum_mod, clear_scene_palyer_helper, [RoleIdList])
    end|| {ServerId, RoleIdList}<-HandList].

clear_scene_palyer(CopyId, SerId) ->
    UserList = lib_scene_agent:get_scene_user(CopyId),
    HandList = make_data_for_clear(UserList),
    [begin
        mod_clusters_center:apply_cast(ServerId, lib_kf_sanctum_mod, clear_scene_palyer_helper, [RoleIdList])
    end|| {ServerId, RoleIdList}<-HandList, SerId == ServerId].

clear_scene_palyer_helper(RoleIdList) ->
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_kf_sanctum_mod, quit_timeout, [])|| RoleId <- RoleIdList].

quit_timeout(Ps)->
    case lib_kf_sanctum:is_in_kf_sanctum(Ps#player_status.scene) of
        false -> skip;
        true ->
            NewPs = lib_scene:change_scene(Ps, 0, 0, 0, 0, 0, true, [{group, 0}, {recalc_attr, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
            {ok, NewPs}
    end.

make_data_for_clear(UserList) ->
    Fun = fun(#ets_scene_user{server_id = ServerId, id = RoleId}, Acc) ->
        case lists:keyfind(ServerId, 1, Acc) of
            {ServerId, List} ->
                NewList = [RoleId|lists:delete(RoleId, List)],
                lists:keystore(ServerId, 1, Acc, {ServerId, NewList});
            _ ->
                lists:keystore(ServerId, 1, Acc, {ServerId, [RoleId]})
        end
    end,
    lists:foldl(Fun, [], UserList).

divide_reborn_point(ServerPoint, ServerId, Scene) ->
    case lists:keyfind(ServerId, 1, ServerPoint) of
        {ServerId, {X, Y}} ->
            {ServerPoint, X, Y};
        _ ->
            case data_sanctum:get_scene_point(Scene) of
                PointList when is_list(PointList) andalso PointList =/= [] ->
                    {X, Y} = divide_reborn_point_helper(ServerPoint, PointList),
                    {[{ServerId, {X, Y}}|ServerPoint], X, Y};
                _ ->
                    case data_scene:get(Scene) of
                        #ets_scene{x = X, y = Y} ->
                            {[{ServerId, {X, Y}}|ServerPoint], X, Y};
                        _ ->
                            ?ERR("MISS SCENE CONFIG scene:~p~n",[Scene]),
                            {ServerPoint, 0, 0}
                    end
            end
    end.

divide_reborn_point_helper(ServerPoint, PointList) ->
    Fun = fun({_, Elem}, {Acc, TAcc}) ->
        case lists:keyfind(Elem, 1, Acc) of
            {Elem, Num} ->
                {lists:keystore(Elem, 1, Acc, {Elem, Num+1}), TAcc};
            _ ->
                {[{Elem, 1}|Acc], [Elem|TAcc]}
        end
    end,
    {List, UsedPoint} = lists:foldl(Fun, {[], []}, ServerPoint),
    F1 = fun(Point, Acc1) ->
        case lists:member(Point, UsedPoint) of
            false ->
                [Point|Acc1];
            _ ->
                Acc1
        end
    end,
    case lists:foldl(F1, [], PointList) of
        [Elem1|_] ->
            Elem1;
        _ ->
            [{NeedElem, _}|_] = lists:keysort(2, List),
            NeedElem
    end.

enter_core(UserList, SceneUserList, ZoneMap, ZoneId, RebornPoint, SceneUser, Scene, ServerId, RoleId, Node, RoleSceneType) ->
    case lists:member(RoleId, UserList) of
        true ->
            NewSceneUserList = SceneUserList;
        _ ->
            NewSceneUserList = lists:keystore(Scene, 1, SceneUserList, {Scene, [RoleId|UserList]})
    end,
    PointList = maps:get(ZoneId, RebornPoint, []),
    case lists:keyfind(Scene, 1, PointList) of
        {_, ServerPoint} ->
            skip;
        _ ->
            ServerPoint = []
    end,
    {NewServerPoint, X, Y} = divide_reborn_point(ServerPoint, ServerId, Scene),
    update_zone(ZoneMap, ZoneId, join, [Scene, RoleId, {X, Y}]),
    % ?PRINT("enter_point  ================ {X, Y}:~p~n",[{X, Y}]),
    NewPointList = lists:keystore(Scene, 1, PointList, {Scene, NewServerPoint}),
    NewSceneUser = maps:put(ZoneId, NewSceneUserList, SceneUser),
    NewRebornPoint = maps:put(ZoneId, NewPointList, RebornPoint),
    NeedOut = if
        RoleSceneType == ?SCENE_TYPE_SANCTUM ->
            false;
        true ->
            true
    end,
    mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene,
                    [RoleId, Scene, 0, ZoneId, X, Y, NeedOut, [{group, 0}, {recalc_attr, 0}, {change_scene_hp_lim, 100}, {pk, {?PK_SERVER, true}}]]),
    {NewSceneUser, NewRebornPoint}.
