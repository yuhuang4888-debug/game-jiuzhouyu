-module(lib_escort_mod).

-include("escort.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("def_module.hrl").

-export([
        reset/3                     %% 凌晨计算活动时间/更新分区数据
        ,zone_change/4              %% 分区改变
        ,center_connected/4         %% 合服处理/服务器连接跨服中心处理

        ,enter_scene/10             %% 进入场景
        ,exit/4                     %% 退出
        ,reconnect/4                %% 重连
        ,mon_reborn/14              %% 召唤水晶
        ,mon_hurt/14                %% 攻击水晶
        ,mon_be_killed/13           %% 击杀水晶
        ,mon_stop/11                %% 护送完成（水晶自我终结）
        ,walk_check_back/8          %% 护送检测
        ,mon_move/11                %% 护送
        ,local_init/2               %% 更新本地数据

        ,act_start/1                %% 活动开启
        ,act_start/2                %% 定制活动开启
        ,act_end/1                  %% 活动结束
        ,custom_act_end/1           %% 定制活动结束
        ,gm_start/1                 %% 秘籍开启
    ]).

%% -----------------------------------------------------------------
%% 凌晨重新计算活动时间
%% -----------------------------------------------------------------
reset(State, ZoneMap, ServerInfo) ->
    #kf_escort_state{act_ref = OldRef, custom_time_list = TimeList} = State,
    if
        TimeList == [] -> %% 定制活动未开启
            NowTime = utime:unixtime(),
            {StartTime, EndTime} = lib_escort:calc_act_time(NowTime - 60), %%延时1分钟 
            util:cancel_timer(OldRef),
            NewRef = ?IF(StartTime =/= 0, erlang:send_after(max(StartTime - NowTime, 1)* 1000, self(), {'act_start'}), undefined),
            StartTime =/= 0 andalso update_all_local_info(ZoneMap, StartTime, EndTime),
            State#kf_escort_state{start_time = StartTime, end_time = EndTime, zone_map = ZoneMap, server_info = ServerInfo, act_ref = NewRef};
        true -> %% 定制活动开启中
            State#kf_escort_state{zone_map = ZoneMap, server_info = ServerInfo}
    end.
    

%% -----------------------------------------------------------------
%% 改变分区
%% -----------------------------------------------------------------
zone_change(State, ServerId, 0, _NewZone) -> 
    local_init(State, ServerId);
zone_change(State, ServerId, OldZone, NewZone) when OldZone =/= 0 ->
    #kf_escort_state{zone_map = ZoneMap, first_guild = FirstGuildMap} = State,
    %% 重新计算分区数据
    NewZMap = calc_zone_map_merge(OldZone, NewZone, ServerId, ZoneMap),
    %% 重新计算排行榜第一名
    NewFirstGuildMap = calc_first_guild_map_merge(OldZone, NewZone, ServerId, FirstGuildMap),
    %% 更新本地排行榜第一名数据
    List = maps:get(NewZone, NewFirstGuildMap, []),
    SendFirst = case List of
        [{SerId, GuildId}|_] -> {SerId, GuildId};
        _ -> {0,0}
    end,
    update_local_info(ServerId, [{server, maps:get(NewZone, NewZMap, [])}, {first, SendFirst}]),
    
    State#kf_escort_state{zone_map = NewZMap, first_guild = NewFirstGuildMap}.

%% -----------------------------------------------------------------
%% 本地连接上跨服中心
%% -----------------------------------------------------------------
center_connected(State, ServerId, ServerNum, MergeSerIds) ->
    #kf_escort_state{zone_map = ZoneMap, first_guild = FirstGuildMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    Fun = fun(TemServerId, {Acc1, Acc2}) when ServerId =/= TemServerId ->
        TemZoneId = lib_clusters_center_api:get_zone(ServerId),
        %% 更新区服务器列表
        Serverids = maps:get(TemZoneId, Acc1, []),
        Info = maps:get(TemZoneId, Acc2, []),

        case lists:keyfind(TemServerId, 1, Info) of
            {_, _, GuildId, GuildName} when ZoneId == TemZoneId ->
                db:execute(io_lib:format(?SQL_REPLACE_ESCORT, [ZoneId, ServerId, ServerNum, GuildId, GuildName])),
                NewInfo = lists:keystore(GuildId, 3, Info, {ServerId, ServerNum, GuildId, GuildName});
            _ ->
                NewInfo = Info
        end,
        NewServerids = lists:delete(TemServerId, Serverids),
        NewAcc1 = maps:put(TemZoneId, NewServerids, Acc1),
        NewAcc2 = maps:put(TemZoneId, NewInfo, Acc2),
        {NewAcc1, NewAcc2};
        (_, Acc) -> Acc
    end,
    
    {NewZoneMap, NewFirstGuildMap} = lists:foldl(Fun, {ZoneMap, FirstGuildMap}, MergeSerIds),
    NewState = State#kf_escort_state{zone_map = NewZoneMap, first_guild = NewFirstGuildMap},
    %% 更新本地数据
    local_init(NewState, ServerId),
    NewState.

%% -----------------------------------------------------------------
%% 进入
%% -----------------------------------------------------------------
enter_scene(State, ServerNum, ServerId, GuildId, GuildName, Position, RoleId, RoleName, Scene, NeedOut) ->
    #kf_escort_state{join_list = JoinList, start_time = StartTime, end_time = EndTime, 
        server_guild = ServerGuildMap, role_rank = RoleRankMap} = State,
    NowTime = utime:unixtime(),
    if
        NowTime >= StartTime andalso NowTime =< EndTime ->
            ZoneId = lib_clusters_center_api:get_zone(ServerId),
            %% 参与统计
            Key = {ZoneId, ServerId, GuildId},
            {_, JoinNum} = ulists:keyfind(Key, 1, JoinList, {Key, 0}),
            NewJoinList = lists:keystore(Key, 1, JoinList, {Key, JoinNum+1}),
            %% 参与公会统计
            ServerGuildIdList = maps:get(ZoneId, ServerGuildMap, []),
            {_, OldList} = ulists:keyfind(ServerId, 1, ServerGuildIdList, {ServerId, []}),
            NewServerGuildIdList = lists:keystore(ServerId, 1, ServerGuildIdList, {ServerId, [{ServerNum, GuildId, GuildName}|lists:keydelete(GuildId, 2, OldList)]}),
            NewServerGMap = maps:put(ZoneId, NewServerGuildIdList, ServerGuildMap),
            %% 玩家数据收集
            RoleRank = maps:get({ServerId, GuildId}, RoleRankMap, []),
            {_, _, _, RoleRobScore, EscortScore} = ulists:keyfind(RoleId, 1, RoleRank, {RoleId, Position, RoleName, 0, 0}),
            NewRoleRank = lists:keystore(RoleId, 1, RoleRank, {RoleId, Position, RoleName, RoleRobScore, EscortScore}),
            NewRoleRankMap = maps:put({ServerId, GuildId}, NewRoleRank, RoleRankMap),
            %% 更新本地数据
            SendJoinList = calc_send_join_list(NewJoinList, ServerId),
            update_local_info(ServerId, [{join, SendJoinList}]),
            {ok, BinData} = pt_185:write(18502, [1]),
            % ?PRINT("enter_scene {StartTime, EndTime}~p~n",[{StartTime, EndTime}]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            %% 进入场景取消进入之前设置的"锁"
            mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, [RoleId, Scene, 0, ZoneId, 
                NeedOut, [{group, 0}, {pk, {?PK_GUILD, true}}, {change_scene_hp_lim, 100}, {action_free, ?ERRCODE(err185_enter_cluster)}]]);
        true ->
            NewJoinList = JoinList,
            {ok, BinData} = pt_185:write(18502, [?ERRCODE(err185_time_out)]),
            % ?PRINT("err185_time_out StartTime:~p,EndTime:~p~n",[StartTime, EndTime]),
            NewServerGMap = ServerGuildMap,
            NewRoleRankMap = RoleRankMap,
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData])
    end,

    State#kf_escort_state{join_list = NewJoinList, server_guild = NewServerGMap, role_rank = NewRoleRankMap}.

%% -----------------------------------------------------------------
%% 退出
%% -----------------------------------------------------------------                            
exit(State, ServerId, GuildId, _RoleId) ->
    #kf_escort_state{join_list = JoinList} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    %% 参与统计
    Key = {ZoneId, ServerId, GuildId},
    {_, JoinNum} = ulists:keyfind(Key, 1, JoinList, {Key, 0}),
    NewJoinList = lists:keystore(Key, 1, JoinList, {Key, max(JoinNum-1, 0)}),
    %% 更新本地数据
    SendJoinList = calc_send_join_list(NewJoinList, ServerId),
    update_local_info(ServerId, [{join, SendJoinList}]),

    State#kf_escort_state{join_list = NewJoinList}.

%% -----------------------------------------------------------------
%% 重连
%% -----------------------------------------------------------------
reconnect(State, ServerId, GuildId, _RoleId) ->
    #kf_escort_state{join_list = JoinList} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    %% 参与统计
    Key = {ZoneId, ServerId, GuildId},
    {_, JoinNum} = ulists:keyfind(Key, 1, JoinList, {Key, 0}),
    NewJoinList = lists:keystore(Key, 1, JoinList, {Key, JoinNum+1}),
    %% 更新本地数据
    SendJoinList = calc_send_join_list(NewJoinList, ServerId),
    update_local_info(ServerId, [{join, SendJoinList}]),

    State#kf_escort_state{join_list = NewJoinList}.

%% -----------------------------------------------------------------
%% 召唤怪物
%% -----------------------------------------------------------------
mon_reborn(State, ServerId, ServerNum, GuildId, GuildName, _MonType, Scene, X, Y, MonId, RoleId, RoleName, Position, Cost) ->
    #kf_escort_state{guild_mon = GuildMonMap, server_guild = ServerGuildMap, zone_map = ZoneMap, server_info = ServerInfo} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    case maps:get({ServerId, GuildId}, GuildMonMap, []) of
        [] -> %% 没有召唤过水晶
            ServerIdList = maps:get(ZoneId, ZoneMap, []),
            Wlv = lib_escort:calc_zone_wlv(ServerIdList, ServerInfo),
            case data_scene:get(Scene) of
                #ets_scene{name = SceneName} -> skip;     
                _ -> SceneName = <<>>
            end,
            #base_escort_mon{name = MonName} = data_escort:get_mon_type(_MonType),
            %% 发送召唤传闻
            [lib_escort:send_tv_to_all(SerId, 1, [ServerNum, GuildName, SceneName, MonName])|| SerId <- ServerIdList],
            % ?PRINT("MonId:~p, Scene:~p, X:~p, Y:~p, ZoneId:~p,GuildId:~p, GuildName:~ts~n", [MonId, Scene, X, Y, ZoneId, GuildId, GuildName]),
            %% 同步创建怪物
            MonAutoId = lib_mon:sync_create_mon(MonId, Scene, 0, X, Y, 0, ZoneId, 1, [{guild_name,GuildName},{server_num,ServerNum},{guild_id, GuildId}, {auto_lv, Wlv}]),
            %% 发送公会传闻
            TvArgs = lib_escort:get_tv_args(Position, RoleId, RoleName, Cost, _MonType, Scene),
            % ?PRINT("TvArgs:~p~n",[TvArgs]),
            mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV, [{guild, GuildId}, ?MOD_ESCORT, 3, TvArgs]),
            %% 日志
            lib_log_api:log_escort_boss_born(ServerId, RoleId, RoleName, GuildId, GuildName, Position, _MonType, Scene, Cost),
            %% 数据更新
            HpMax = lib_escort:get_mon_max_hp(MonId, Wlv),
            % ?PRINT("HpMax:~p~n",[HpMax]),
            NewMap = maps:put({ServerId, GuildId}, {MonAutoId, _MonType, Wlv, ?RES_ESCORT, Scene, X, Y, HpMax, HpMax}, GuildMonMap),
            ServerGuildIdList = maps:get(ZoneId, ServerGuildMap, []), %% 公会召唤水晶统计
            {_, OldList} = ulists:keyfind(ServerId, 1, ServerGuildIdList, {ServerId, []}),
            %% 公会数据再次更新
            NewServerGuildIdList = lists:keystore(ServerId, 1, ServerGuildIdList, {ServerId, [{ServerNum, GuildId, GuildName}|lists:keydelete(GuildId, 2, OldList)]}),
            NewServerGMap = maps:put(ZoneId, NewServerGuildIdList, ServerGuildMap),
            % ?PRINT("NewServerGMap:~p ~n",[NewServerGMap]),
            %% 更新本地数据
            {LocalGuildMon, _} = calc_send_escort_map(#{}, NewMap, ServerIdList),
            {ok, BinData} = pt_185:write(18504, [1]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            update_local_info(ServerIdList, [{guild_info, NewServerGuildIdList}, {mon, LocalGuildMon, Scene, ZoneId, GuildId}]),
            State#kf_escort_state{guild_mon = NewMap, server_guild = NewServerGMap};
        _ ->
            {ok, BinData} = pt_185:write(18504, [?ERRCODE(err185_has_create_mon)]),
            % ?PRINT("err185_has_create_mon ~n",[]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State
    end.

%% -----------------------------------------------------------------
%% 攻击怪物
%% -----------------------------------------------------------------
mon_hurt(State, _Scene, _PoolId, CopyId, ServerNum, ServerId, AttrGuildId, GuildId, _MonId, RoleId, RoleName, Hurt, MonAutoId, Hp) ->
    #kf_escort_state{
        mon_hurt = HurtMap, 
        zone_map = ZoneMap,
        server_guild = ServerGuildMap, 
        role_rank = RoleRankMap, 
        guild_mon = GuildMonMap, 
        move_time = MoveTimeMap} = State,
    %% 玩家伤害数据统计
    MonHurtInfoL = maps:get(CopyId, HurtMap, []),
    case lists:keyfind(MonAutoId, #mon_hurt_info.mon_id, MonHurtInfoL) of
        #mon_hurt_info{hurt_list = HurtList} = HurtInfo -> skip;
        _ -> 
            HurtList = [], 
            HurtInfo = #mon_hurt_info{mon_id = MonAutoId, hurt_list = HurtList}
    end,
    ServerGuildIdList = maps:get(CopyId, ServerGuildMap, []),
    {_, OldList} = ulists:keyfind(ServerId, 1, ServerGuildIdList, {ServerId, []}),
    case lists:keyfind(AttrGuildId, 2, OldList) of
        {_, _, AttrGuildName} -> skip; 
        _ -> AttrGuildName = <<>>
    end,
    RoleRank = maps:get({ServerId, AttrGuildId}, RoleRankMap, []),
    case lists:keyfind(RoleId, 1, RoleRank) of
        {RoleId, Position, _, _, _} -> skip;
        _ -> Position = 3
    end,
    NewHurtList = case lists:keyfind(RoleId, 6, HurtList) of
        {_, _, _, _, _, _, _, OldHurt} -> 
            lists:keystore(RoleId, 6, HurtList, {ServerNum, ServerId, AttrGuildName, AttrGuildId, Position, RoleId, RoleName, Hurt+OldHurt});
        _ -> lists:keystore(RoleId, 6, HurtList, {ServerNum, ServerId, AttrGuildName, AttrGuildId, Position, RoleId, RoleName, Hurt})
    end,
    NewHurtInfo = HurtInfo#mon_hurt_info{hurt_list = NewHurtList},
    NewMonHurtInfoL = lists:keystore(MonAutoId, #mon_hurt_info.mon_id, MonHurtInfoL, NewHurtInfo),
    NewMap = maps:put(CopyId, NewMonHurtInfoL, HurtMap),
    %% 更新怪物血量
    {MonServerId, _, _, _} = get_mon_server(CopyId, ServerGuildMap, GuildId),
    case maps:get({MonServerId, GuildId}, GuildMonMap, []) of
        {_, MonType, MonLv, Res, Scene, X, Y, _, HpMax} ->
            NewGuildMonMap = maps:put({MonServerId, GuildId}, {MonAutoId, MonType, MonLv, Res, Scene, X, Y, Hp, HpMax}, GuildMonMap);
        _ ->
            NewGuildMonMap = GuildMonMap
    end,
    %% 定时更新本地数据，攻击怪物触发频繁不要实时更新，
    NowTime = utime:unixtime(),
    LastTime = maps:get(MonServerId, MoveTimeMap, 0),
    CFG = ?UP_POSITION_TIME,
    ServerIdList = maps:get(CopyId, ZoneMap, []),
    if
        NowTime - LastTime >= CFG ->
            {LocalGuildMon, _} = calc_send_escort_map(#{}, NewGuildMonMap, ServerIdList),
            update_local_info(ServerIdList, [{mon_move, _Scene, CopyId, LocalGuildMon}]),
            NewMoveTimeMap = maps:put(ServerId, NowTime, MoveTimeMap);
        true ->
            NewMoveTimeMap = MoveTimeMap
    end,
    
    State#kf_escort_state{mon_hurt = NewMap, guild_mon = NewGuildMonMap, move_time = NewMoveTimeMap}.

%% -----------------------------------------------------------------
%% 击杀怪物（被掠夺）
%% -----------------------------------------------------------------
mon_be_killed(State, Scene, ScenePoolId, CopyId, X, Y, _AtterServerId, MonId, MonAutoId, MonLv, GuildId, AtterId, _AtterName) ->
    #kf_escort_state{
        zone_map = ZoneMap,
        mon_hurt = HurtMap, 
        score_rank = ScoreMap, 
        role_rank = RoleRankMap, 
        rob_map = RobMap, 
        escort_map = EscortMap,
        guild_mon = GuildMonMap,
        server_guild = ServerGuildMap} = State,
    %% 确定怪物属于哪个服哪个公会的哪种boss
    {ServerId, ServerNum, _, GuildName} = get_mon_server(CopyId, ServerGuildMap, GuildId),
    MonType = lib_escort:get_mon_type(MonId),
    %% 掠夺结算
    MonHurtInfoL = maps:get(CopyId, HurtMap, []),
    case lists:keyfind(MonAutoId, #mon_hurt_info.mon_id, MonHurtInfoL) of
        #mon_hurt_info{hurt_list = HurtList} -> skip;
        _ -> 
            HurtList = []
    end,
    RobRewardCfg = data_escort:get_rob_reward(MonType),
    ScoreRank = maps:get(CopyId, ScoreMap, []),
    {NewRobMap, NewScoreRank1, NewRoleRankMap1} = 
        rob_resoult(HurtList, Scene, ScenePoolId, CopyId, X, Y, AtterId, RobMap, ScoreRank, RoleRankMap, RobRewardCfg, #{}),
    % ?PRINT("HurtList:~p, NewScoreRank1:~p~n",[HurtList, NewScoreRank1]),
    %% 护送结算
    EscortList = maps:get(MonAutoId, EscortMap, []),
    {NewScoreRank, NewRoleRankMap, _} = escort_resoult(MonLv, MonType, 0, EscortList, ServerId, ServerNum, GuildId, GuildName, NewScoreRank1, NewRoleRankMap1),
    case data_escort:get_mon_type(MonType) of
        #base_escort_mon{name = Name} -> skip;
        _ -> Name = <<>>
    end,
    % ?PRINT("RoleRankMap:~p, NewRoleRankMap1:~p, NewRoleRankMap:~p~n",[RoleRankMap, NewRoleRankMap1, NewRoleRankMap]),
    mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV, [{scene_guild, Scene, CopyId, GuildId}, ?MOD_ESCORT, 6, [Name]]),
    %% 更新怪物血量数据
    NewScoreMap = maps:put(CopyId, NewScoreRank, ScoreMap),
    HpMax = lib_escort:get_mon_max_hp(MonId, MonLv),
    NewGuildMonMap = maps:put({ServerId, GuildId}, {MonAutoId, MonType, MonLv, ?RES_FAIL, Scene, X, Y, 0, HpMax}, GuildMonMap),
    %% 更新到本地
    ServerIdList = maps:get(CopyId, ZoneMap, []),
    LocalRobMap = calc_send_rob_map(NewRobMap, ServerIdList),
    {LocalGuildMon, _} = calc_send_escort_map(#{}, NewGuildMonMap, ServerIdList),
    LocalRoleRank = calc_send_map(NewRoleRankMap, ServerIdList),
    update_local_info(ServerIdList, [{mon, LocalGuildMon, Scene, CopyId, GuildId}, {rank, NewScoreRank, Scene, CopyId}, {rob, LocalRobMap}, {role_rank, LocalRoleRank}]),

    State#kf_escort_state{rob_map = NewRobMap, score_rank = NewScoreMap, role_rank = NewRoleRankMap, guild_mon = NewGuildMonMap}.

%% -----------------------------------------------------------------
%% AI结束（护送完成）
%% -----------------------------------------------------------------
mon_stop(State, _Scene, _ScenePoolId, CopyId, MonId, MonAutoId, MonLv, Hp, GuildId, X, Y) ->
    % ?PRINT("AI end ~n",[]),
    % ?MYLOG("XLH","State:~p~n",[State]),
    #kf_escort_state{
        start_time = StartTime,
        end_time = EndTime,
        zone_map = ZoneMap,
        score_rank = ScoreMap, 
        escort_map = EscortMap,
        guild_mon = GuildMonMap,
        role_rank = RoleRankMap, 
        server_guild = ServerGuildMap} = State,
    NowTime = utime:unixtime(),
    if
        NowTime >= StartTime andalso NowTime =< EndTime ->
            %% 确定怪物属于哪个服哪个公会的哪种boss
            {ServerId, ServerNum, _, GuildName} = get_mon_server(CopyId, ServerGuildMap, GuildId),
            MonType = lib_escort:get_mon_type(MonId),
            %% 护送结算
            EscortList = maps:get(MonAutoId, EscortMap, []),
            ScoreRank = maps:get(CopyId, ScoreMap, []),
            {NewScoreRank, NewRoleRankMap, EscortCfg} = escort_resoult(MonLv, MonType, Hp, EscortList, ServerId, ServerNum, GuildId, GuildName, ScoreRank, RoleRankMap),
            NewScoreMap = maps:put(CopyId, NewScoreRank, ScoreMap),
            %% 怪物数据更新
            #base_escort_reward{escort_type = EscortType, escort_name = EscortName} = EscortCfg,
            Res = ?IF(EscortType == ?PERFECT_ESCORT, ?RES_PERFECT, ?RES_NORMAL),
            HpMax = lib_escort:get_mon_max_hp(MonId, MonLv),
            NewGuildMonMap = maps:put({ServerId, GuildId}, {MonAutoId, MonType, MonLv, Res, _Scene, X, Y, Hp, HpMax}, GuildMonMap),
            %% 通知公会玩家护送结束
            case data_escort:get_mon_type(MonType) of
                #base_escort_mon{name = Name} -> skip;
                _ -> Name = <<>>
            end,
            % ?PRINT("Scene, CopyId, GuildId:~p, Res:~p~n",[{_Scene, CopyId, GuildId}, Res]),
            mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV, [{scene_guild, _Scene, CopyId, GuildId}, ?MOD_ESCORT, 5, [EscortName,Name]]),
            %% 更新本地数据
            ServerIdList = maps:get(CopyId, ZoneMap, []),
            {LocalGuildMon, _} = calc_send_escort_map(#{}, NewGuildMonMap, ServerIdList),
            LocalRoleRank = calc_send_map(NewRoleRankMap, ServerIdList),
            update_local_info(ServerIdList, [{mon, LocalGuildMon, _Scene, CopyId, GuildId}, {rank, NewScoreRank, _Scene, CopyId}, {role_rank, LocalRoleRank}]),
            % ?PRINT("LocalGuildMon:~p~n, NewScoreRank:~p~n, LocalRoleRank:~p~n",[LocalGuildMon,NewScoreRank,LocalRoleRank]),
            % ?MYLOG("XLH","NewScoreMap:~p, NewRoleRankMap:~p, NewGuildMonMap:~p~n",[NewScoreMap, NewRoleRankMap, NewGuildMonMap]),
            State#kf_escort_state{score_rank = NewScoreMap, role_rank = NewRoleRankMap, guild_mon = NewGuildMonMap};
        true ->
            State
    end.
    
%% -----------------------------------------------------------------
%% 护送检测（护送确定附近是否有公会玩家，无则不移动）
%% -----------------------------------------------------------------
walk_check_back(State, _Scene, _PoolId, CopyId, _Monid, MonAutoId, GuildId, UserList) ->
    #kf_escort_state{
        server_guild = ServerGuildMap,
        escort_map = EscortMap,
        zone_map = ZoneMap,
        update_time = UpMap} = State,
    EscortList = maps:get(MonAutoId, EscortMap, []),
    {ServerId, _ServerNum, _, _GuildName} = get_mon_server(CopyId, ServerGuildMap, GuildId),
    NowTime = utime:unixtime(),%% {Uid, USerId, Uname, Upos}
    %% 护送时长统计
    Fun = fun({RoleId, TemServerId, RoleName, Position}, Acc) -> %{TemServerId, RoleId, Position, RoleName, _Time, _}
        case lists:keyfind(RoleId, 2, Acc) of
            {_, _, _, _, SumTime, Time} -> 
                lists:keystore(RoleId, 2, Acc, {TemServerId, RoleId, Position, RoleName, SumTime+max(NowTime-Time, 0), NowTime});
            _ ->
                lists:keystore(RoleId, 2, Acc, {TemServerId, RoleId, Position, RoleName, 0, NowTime})
        end
    end,
    NewEscortList = lists:foldl(Fun, EscortList, UserList),
    NewMap = maps:put(MonAutoId, NewEscortList, EscortMap),
    %% 定时更新本地数据
    LastTime = maps:get(ServerId, UpMap, 0),
    ServerIdList = maps:get(CopyId, ZoneMap, []),
    CFG = ?UPDATE_TIME,
    if
        NowTime - LastTime >= CFG ->
            {_, SendEscortMap} = calc_send_escort_map(EscortMap, #{}, ServerIdList),
            update_local_info(ServerId, [{escort, SendEscortMap}]),
            NewUpMap = maps:put(ServerId, NowTime, UpMap);
        true ->
            NewUpMap = UpMap
    end,
    % ?PRINT("walk_check_back _Scene:~p~n",[_Scene]),
    State#kf_escort_state{escort_map = NewMap, update_time = NewUpMap}.

%% -----------------------------------------------------------------
%% 水晶移动（护送）
%% -----------------------------------------------------------------
mon_move(State, Scene, _PoolId, CopyId, _Monid, MonAutoId, GuildId, X, Y, Hp, _HpMax) ->
    % ?PRINT("Hp, HpMax:~p~n",[{Hp, _HpMax}]),
    #kf_escort_state{
        server_guild = ServerGuildMap,
        move_time = MoveTimeMap,
        zone_map = ZoneMap,
        guild_mon = GuildMonMap} = State,

    {ServerId, _ServerNum, _, _GuildName} = get_mon_server(CopyId, ServerGuildMap, GuildId),
    %% 更新水晶坐标
    case maps:get({ServerId, GuildId}, GuildMonMap, []) of
        {_, MonType, MonLv, Res, _, _, _, _, HpMax} ->
            % ?PRINT("Hp, HpMax:~p~n",[{Hp, _HpMax, MonLv}]),
            NewGuildMonMap = maps:put({ServerId, GuildId}, {MonAutoId, MonType, MonLv, Res, Scene, X, Y, Hp, HpMax}, GuildMonMap);
        _ ->
            NewGuildMonMap = GuildMonMap
    end,
    %% 定时更新本地水晶坐标
    NowTime = utime:unixtime(),
    LastTime = maps:get(ServerId, MoveTimeMap, 0),
    CFG = ?UP_POSITION_TIME,
    ServerIdList = maps:get(CopyId, ZoneMap, []),
    if
        NowTime - LastTime >= CFG ->
            {LocalGuildMon, _} = calc_send_escort_map(#{}, NewGuildMonMap, ServerIdList),
            update_local_info(ServerIdList, [{mon_move, Scene, CopyId, LocalGuildMon}]),
            NewMoveTimeMap = maps:put(ServerId, NowTime, MoveTimeMap);
        true ->
            NewMoveTimeMap = MoveTimeMap
    end,
    State#kf_escort_state{guild_mon = NewGuildMonMap, move_time = NewMoveTimeMap}.

%% -----------------------------------------------------------------
%% 活动定时开启
%% -----------------------------------------------------------------
act_start(State) ->
    #kf_escort_state{
        start_time = _StartTime,
        end_time = EndTime,
        act_ref = OldRef,
        zone_map = ZoneMap
    } = State,
    util:cancel_timer(OldRef),
    NowTime = utime:unixtime(),
    %% 清理数据库
    db:execute(?SQL_TRUNCATE_ESCORT),
    % ServerIdList = maps:get(CopyId, ZoneMap, []),
    ZoneMapList = maps:to_list(ZoneMap),
    %% 定时结束
    NewRef = erlang:send_after(max(EndTime - NowTime, 1)* 1000, self(), {'act_end'}),
    Fun = fun({_ZoneId, ServerIdList}) ->
        % ?PRINT("=================== ~p~n",[ServerIdList]),
        [lib_escort:send_tv_to_all(ServerId, 7, []) || ServerId <- ServerIdList]
    end,
    lists:foreach(Fun, ZoneMapList),
    %% 清空所有活动数据
    State#kf_escort_state{
        act_ref = NewRef
        ,server_guild = #{}
        ,score_rank = #{}
        ,role_rank = #{}
        ,rob_map = #{}
        ,guild_mon = #{}
        ,join_list = []
        ,mon_hurt = #{}
        ,escort_map = #{}
        ,update_time = #{}
        ,move_time = #{}
    }.

%% -----------------------------------------------------------------
%% 定制活动开启
%% -----------------------------------------------------------------
act_start(State, TimeList) -> %% 定制活动控制， 手动关闭活动
    #kf_escort_state{act_ref = OldRef, custom_time_list = OldTimeList, zone_map = ZoneMap} = State,
    if
        OldTimeList == TimeList andalso OldRef =/= undefined -> %% 服务器重启会多次通知活动开启，通知过不在处理
            State;
        true -> %% 第一次通知活动开启
            util:cancel_timer(OldRef),
            NowTime = utime:unixtime(),
            %% 计算下次开启时间，当前时间在开启时间范围内不开启活动
            {Stime, Etime} = lib_escort:calc_act_time(NowTime, TimeList),
            %% 通知所有服活动开启时间
            mod_clusters_center:apply_to_all_node(mod_escort_local, update_info, [[{time, Stime, Etime}, {clear}]]),
            %% 清理数据库
            db:execute(?SQL_TRUNCATE_ESCORT),
            ZoneMapList = maps:to_list(ZoneMap),
            Fun = fun({_ZoneId, ServerIdList}) ->
                % ?PRINT("=================== ~p~n",[ServerIdList]),
                [lib_escort:send_tv_to_all(ServerId, 7, []) || ServerId <- ServerIdList]
            end,
            spawn(fun() -> timer:sleep(max(0, Stime - NowTime)*1000), lists:foreach(Fun, ZoneMapList) end),
            %% 定时关闭
            NewRef = erlang:send_after(max(Etime - NowTime, 1)* 1000, self(), {'act_end'}),
            % ?PRINT("custom Etime:~p,Stime:~p, NowTime:~p~n",[Etime,Stime, NowTime]),
            State#kf_escort_state{
                act_ref = NewRef
                ,start_time = Stime
                ,end_time = Etime
                ,custom_time_list = TimeList
                ,server_guild = #{}
                ,score_rank = #{}
                ,role_rank = #{}
                ,rob_map = #{}
                ,guild_mon = #{}
                ,join_list = []
                ,mon_hurt = #{}
                ,escort_map = #{}
                ,update_time = #{}
                ,move_time = #{}
            }
    end.
    
%% -----------------------------------------------------------------
%% 定制活动结束
%% -----------------------------------------------------------------
custom_act_end(State) ->
    %% 移除开启时间列表
    State#kf_escort_state{custom_time_list = []}.

%% -----------------------------------------------------------------
%% 秘籍开启活动
%% -----------------------------------------------------------------
gm_start(State) ->
    #kf_escort_state{act_ref = OldRef, start_time = StartTime, end_time = EndTime} = State,
    NowTime = utime:unixtime(),
    if
        NowTime < StartTime orelse NowTime >= EndTime -> %%活动未开启
            util:cancel_timer(OldRef),
            NewRef = erlang:send_after(1000, self(), {'act_start'}),
            mod_clusters_center:apply_to_all_node(mod_escort_local, update_info, [[{time, NowTime, NowTime+900}, {clear}]]),
            State#kf_escort_state{start_time = NowTime, end_time = NowTime+900, act_ref = NewRef};
            % act_start(State, [{{13,47,00},{22,00,00}}]);
        true -> %% 开启中
            State
    end.
    
%% -----------------------------------------------------------------
%% 活动结束
%% -----------------------------------------------------------------
act_end(State) ->
    #kf_escort_state{
        act_ref = OldRef,
        custom_time_list = TimeList,
        score_rank = ScoreMap, 
        escort_map = EscortMap,
        guild_mon = GuildMonMap,
        role_rank = RoleRankMap,
        first_guild = FirstGuildMap,
        zone_map = ZoneMap,
        server_guild = ServerGuildMap} = State,
    %% 清除所有玩家
    SceneList = data_escort:get_all_scene(),
    spawn(fun() -> 
        F = fun({ZoneId, _}) ->
            timer:sleep(20),
            [begin
                 mod_scene_agent:apply_cast(Scene, 0, lib_escort, clear_scene_palyer, [ZoneId]),
                 lib_mon:clear_scene_mon(Scene, 0, ZoneId, 0)
             end || Scene <- SceneList]
        end,
        lists:foreach(F, maps:to_list(ZoneMap))
    end),

    util:cancel_timer(OldRef),
    %% 结算所有未完成护送，按护送失败算
    List = maps:to_list(GuildMonMap),
    Fun = fun({{ServerId, GuildId}, {MonAutoId, MonType, MonLv, IsEscort, _Scene, _X, _Y, _, _}}, {AccMap, AccRankMap}) when IsEscort == ?RES_ESCORT ->
        ZoneId = lib_clusters_center_api:get_zone(ServerId),
        %% 护送结算
        {_, ServerNum, _, GuildName} = get_mon_server(ZoneId, ServerGuildMap, GuildId),
        EscortList = maps:get(MonAutoId, EscortMap, []),
        ScoreRank = maps:get(ZoneId, AccMap, []),
        {NewScoreRank, NewRoleRankMap1, _} = escort_resoult(MonLv, MonType, 0, EscortList, ServerId, ServerNum, GuildId, GuildName, ScoreRank, AccRankMap),
        {maps:put(ZoneId, NewScoreRank, AccMap), NewRoleRankMap1};
        (_, Acc) -> Acc
    end,
    {NewScoreMap, NewRoleRankMap} = lists:foldl(Fun, {ScoreMap, RoleRankMap}, List),
    %% 排行榜结算
    ScoreList = maps:to_list(NewScoreMap),
    Fun1 = fun({ZoneId, UnSortList}, AccMap) -> % {ServerId, GuildId, OldScore+AddScore}
        {_, NewAccMap} = rank_resoult(ZoneId, UnSortList, NewRoleRankMap, AccMap),

        ServerIdList = maps:get(ZoneId, ZoneMap, []),
        TemList = maps:get(ZoneId, NewAccMap, []),
        SendFirst = case TemList of
            [{SerId, ServerNum, GuildId, GuildName}|_] -> {SerId, ServerNum, GuildId, GuildName};
            _ -> {0,0,0,""}
        end,
        update_local_info(ServerIdList, [{first, SendFirst}]),

        NewAccMap
    end,
    NewFirstGuildMap = lists:foldl(Fun1, FirstGuildMap, ScoreList),

    NowTime = utime:unixtime(),
    if
        TimeList =/= [] -> %% 优先定制活动
            {StartTime, EndTime} = lib_escort:calc_act_time(NowTime, TimeList);
        true ->
            {StartTime, EndTime} = lib_escort:calc_act_time(NowTime - 60) %%延时1分钟 
    end,
    % ?PRINT("act_end {StartTime, EndTime}:~p~n",[{StartTime, EndTime}]),
    NewRef = ?IF(StartTime =/= 0,  erlang:send_after(max(StartTime - NowTime, 1)* 1000, self(), {'act_start'}), undefined),
    mod_clusters_center:apply_to_all_node(mod_escort_local, update_info, [[{time, StartTime, EndTime}, {clear}]]),

    State#kf_escort_state{
        start_time = StartTime
        ,end_time = EndTime
        ,act_ref = NewRef
        ,first_guild = NewFirstGuildMap
        ,server_guild = #{}
        ,score_rank = #{}
        ,role_rank = #{}
        ,rob_map = #{}
        ,guild_mon = #{}
        ,join_list = []
        ,mon_hurt = #{}
        ,escort_map = #{}
        ,update_time = #{}
        ,move_time = #{}}.

%% -----------------------------------------------------------------
%% 本地数据更新
%% -----------------------------------------------------------------
local_init(State, ServerId) ->
    #kf_escort_state{
        start_time = StartTime,
        end_time = EndTime,
        zone_map = ZoneMap,
        score_rank = ScoreMap, 
        guild_mon = GuildMonMap,
        role_rank = RoleRankMap,
        join_list = JoinList,
        first_guild = FirstGuildMap,
        rob_map = RobMap, 
        server_guild = ServerGuildMap,
        escort_map = EscortMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    ServerIdList = maps:get(ZoneId, ZoneMap, []),
    ScoreRank = maps:get(ZoneId, ScoreMap, []),

    FirstList = maps:get(ZoneId, FirstGuildMap, []),
    SendFirst = case FirstList of
        [{FirstSerId, FirstGuild}|_] -> {FirstSerId, FirstGuild};
        _ -> {0,0}
    end,

    ServerGuildIdList = maps:get(ZoneId, ServerGuildMap, []),
    LocalRoleRank = calc_send_map(RoleRankMap, ServerIdList),
    {LocalGuildMon, SendEscortMap} = calc_send_escort_map(EscortMap, GuildMonMap, ServerIdList),
    SendJoinList = calc_send_join_list(JoinList, ServerId),

    LocalRobMap = calc_send_rob_map(RobMap, ServerIdList),

    mod_clusters_center:apply_cast(ServerId, mod_escort_local, local_init, 
        [StartTime, EndTime, ServerIdList, ScoreRank, LocalGuildMon, LocalRoleRank, SendJoinList, SendFirst, SendEscortMap, ServerGuildIdList, LocalRobMap]),
    State.

%%=========================================================================
%% 内部方法
%%=========================================================================

%% -----------------------------------------------------------------
%% 合服处理排行榜第一数据
%% -----------------------------------------------------------------
calc_first_guild_map_merge(OldZone, _NewZone, ServerId, FirstGuildMap) ->
    Info = maps:get(OldZone, FirstGuildMap, []),
    case lists:keyfind(ServerId, 1, Info) of
        {ServerId, _ServerNum, _GuildId, _GuildName} ->
            db:execute(io_lib:format(?SQL_DELETE_ESCORT, [OldZone])),
            NewInfo = lists:keydelete(ServerId, 1, Info);
        _ ->
            NewInfo = Info
    end,
    maps:put(OldZone, NewInfo, FirstGuildMap).

%% -----------------------------------------------------------------
%% 合服处理分区数据
%% -----------------------------------------------------------------
calc_zone_map_merge(OldZone, NewZone, ServerId, ZoneMap) ->
    ServerIdList = maps:get(OldZone, ZoneMap, []),
    NewServerIdList = lists:delete(ServerId, ServerIdList),
    NewZoneMap = maps:put(OldZone, NewServerIdList, ZoneMap),
    ServerIdL = maps:get(NewZone, NewZoneMap, []),
    maps:put(NewZone, [ServerId|lists:delete(ServerId, ServerIdL)], NewZoneMap).

%% -----------------------------------------------------------------
%% 获取公会数据
%% -----------------------------------------------------------------
get_mon_server(ZoneId, ServerGuildMap, TGuildId) ->
    ServerGuildIdList = maps:get(ZoneId, ServerGuildMap, []),
    {ServerId, ServerNum, GuildId, GuildName} = get_mon_server_helper(ServerGuildIdList, TGuildId),
    {ServerId, ServerNum, GuildId, GuildName}.

get_mon_server_helper([], _GuildId) -> {0,0,0,""};
get_mon_server_helper([{ServerId, GuildIdList}|ServerGuildIdList], GuildId) ->
    case lists:keyfind(GuildId, 2, GuildIdList) of
        {ServerNum, GuildId, GuildName} ->
            {ServerId, ServerNum, GuildId, GuildName};
        _ ->
            get_mon_server_helper(ServerGuildIdList, GuildId)
    end.

%% -----------------------------------------------------------------
%% 计算服参与数据
%% -----------------------------------------------------------------
calc_send_join_list(JoinList, ServerId) ->
    Fun1 = fun
        ({{TemZoneId, _, _}, _} = H, Acc) when TemZoneId == ServerId ->
            [H|Acc];
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun1, [], JoinList).

%% -----------------------------------------------------------------
%% 同分区数据筛选
%% -----------------------------------------------------------------
calc_send_map(Map, ServerIdList) ->
    Fun = fun({{TemServerId, _} = Key, Value}, Acc) ->
        case lists:member(TemServerId, ServerIdList) of
            true -> maps:put(Key, Value, Acc);
            _ -> Acc
        end
    end,
    List = maps:to_list(Map),
    lists:foldl(Fun, #{}, List).

%% -----------------------------------------------------------------
%% 发送到本地的护送数据
%% -----------------------------------------------------------------
calc_send_escort_map(EscortMap, GuildMonMap, ServerIdList) ->
    Fun = fun({{TemServerId, _} = Key, {MonAutoId, _, _, _, _, _, _, _, _} = Value}, {Acc, Acc1}) ->
        case lists:member(TemServerId, ServerIdList) of
            true -> 
                EscortList = maps:get(MonAutoId, EscortMap, []),
                {maps:put(Key, Value, Acc), maps:put(MonAutoId, EscortList, Acc1)};
            _ -> {Acc,Acc1}
        end
    end,

    List = maps:to_list(GuildMonMap),
    lists:foldl(Fun, {#{}, #{}}, List).

%% -----------------------------------------------------------------
%% 发送到本地的掠夺数据
%% -----------------------------------------------------------------
calc_send_rob_map(RobMap, ServerIdList) ->
    List = maps:to_list(RobMap),
    Fun = fun({{ServerId, RoleId}, Value}, Map) ->
        case lists:member(ServerId, ServerIdList) of
            true ->
                maps:put({ServerId, RoleId}, Value, Map);
            _ ->
                Map
        end
    end,
    lists:foldl(Fun, #{}, List).

%% -----------------------------------------------------------------
%% 掠夺结算
%% -----------------------------------------------------------------
rob_resoult([], Scene, ScenePoolId, CopyId, X, Y, _AtterId, RobMap, ScoreRank, RoleRankMap, RobRewardCfg, MailRoleMap) ->
    #base_escort_rob_reward{
        type = MonType, 
        guild_reward = _GuildReward, %% 暂时不处理公会奖励
        person_reward = PerReward} = RobRewardCfg,
    % mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_escort, send_escort_reward, [CopyId, X, Y, MonType, MailRoleMap, PerReward, Scene]),
    case mod_scene_agent:apply_call(Scene, ScenePoolId, lib_escort, send_escort_reward, [CopyId, X, Y, MonType, MailRoleMap, PerReward, Scene]) of
        RoleIdRobList when is_list(RoleIdRobList) -> %% 需要更新这些玩家掠夺数据等
            MaxTimes = lib_escort:get_rob_max_times(),
            Fun = fun
                ({TemServerNum, TemServerId, GuildName, GuildId, RoleId, RoleName, Position, RestTimes, AddScore}, {RankList, RankMap, AccRobMap}) ->
                    %% 排行榜
                    {_, _, _, _, OldScore, Time} = ulists:keyfind(GuildId, 4, RankList, {TemServerNum, TemServerId, GuildName, GuildId, 0, utime:unixtime()}),
                    NewScoreRank = lists:keystore(GuildId, 4, RankList, {TemServerNum, TemServerId, GuildName, GuildId, OldScore+AddScore, Time}),
                    %% 公会内部排行
                    RoleRank = maps:get({TemServerId, GuildId}, RankMap, []),
                    {_, _, _, RoleRobScore, EscortScore} = ulists:keyfind(RoleId, 1, RoleRank, {RoleId, Position, RoleName, 0, 0}),
                    NewRoleRank = lists:keystore(RoleId, 1, RoleRank, {RoleId, Position, RoleName, RoleRobScore+AddScore, EscortScore}),
                    NewRoleRankMap = maps:put({TemServerId, GuildId}, NewRoleRank, RankMap),

                    {NewScoreRank, NewRoleRankMap, maps:put({TemServerId, RoleId}, MaxTimes - RestTimes, AccRobMap)};
                (_, Acc) -> Acc
            end,
            {NewRankList, NewRankMap, NewRobMap} = lists:foldl(Fun, {ScoreRank, RoleRankMap, RobMap}, RoleIdRobList);
        _ ->
            NewRankList = ScoreRank, 
            NewRankMap = RoleRankMap,
            NewRobMap = RobMap
    end,
    {NewRobMap, NewRankList, NewRankMap};
rob_resoult([{TemServerNum, TemServerId, GuildName, GuildId, Position, RoleId, RoleName, Hurt}|HurtList], _Scene, _ScenePoolId, CopyId, X, Y, AtterId, RobMap, ScoreRank, RoleRankMap, RobRewardCfg, MailRoleMap) ->
    case maps:get({TemServerId, RoleId}, RobMap, []) of
        Times when is_integer(Times) -> Times;
        _ -> Times = 0
    end,
    MaxTimes = lib_escort:get_rob_max_times(),
    #base_escort_rob_reward{kill_score = KillScoreCfg, score = Score} = RobRewardCfg,
    KillScore = ?IF(RoleId == AtterId, KillScoreCfg, 0),
    MailRoleList = maps:get(TemServerId, MailRoleMap, []),
    %% 组装数据筛选获得奖励玩家
    NewRoleList = [{TemServerNum, RoleId, RoleName, Position, GuildId, GuildName, Hurt, max(MaxTimes-Times, 0), Score, KillScore}|lists:keydelete(RoleId, 2, MailRoleList)],
    rob_resoult(HurtList, _Scene, _ScenePoolId, CopyId, X, Y, AtterId, RobMap, ScoreRank, RoleRankMap, RobRewardCfg, maps:put(TemServerId, NewRoleList, MailRoleMap)).

%% -----------------------------------------------------------------
%% 护送结算
%% -----------------------------------------------------------------
escort_resoult(MonLv, MonType, Hp, EscortList, ServerId, ServerNum, GuildId, GuildName, ScoreRank, RoleRankMap) ->
    MonId = lib_escort:get_mon_id(MonType),
    %% 计算护送档次
    HpPercent = lib_escort:get_mon_hp_percent(MonId, Hp, MonLv),
    EscortCfg = data_escort:get_escort_reward(MonType, HpPercent),
    #base_escort_reward{score = AddScore, person_reward = PerReward, guild_reward = Reward, escort_type = EscortType} = EscortCfg,
    %% 日志
    lib_log_api:log_escort_guild(ServerId, GuildId, GuildName, MonType, EscortType, Reward),
    %% 公会内部排行榜
    RoleRank = maps:get({ServerId, GuildId}, RoleRankMap, []),
    Fun = fun({TemServerId, RoleId, Position, RoleName, _SumTime, _Time}, {Acc, AccRank}) ->
        List = maps:get(TemServerId, Acc, []),
        {_,_,_, RoleRobScore, OScore} = ulists:keyfind(RoleId, 1, AccRank, {RoleId, Position, RoleName, 0, 0}),
        NewAccRank = lists:keystore(RoleId, 1, AccRank, {RoleId, Position, RoleName, RoleRobScore, OScore+AddScore}),

        lib_log_api:log_escort_role(TemServerId, RoleId, RoleName, GuildId, GuildName, MonType, _SumTime, PerReward),
        {maps:put(TemServerId, [RoleId|lists:delete(RoleId, List)], Acc), NewAccRank}
    end,
    {MailRoleMap, NewRoleRank} = lists:foldl(Fun, {#{}, RoleRank}, EscortList),
    %% 公会排行榜
    {_, _, _, _, OldScore, Time} = ulists:keyfind(GuildId, 4, ScoreRank, {ServerNum, ServerId, GuildName, GuildId, 0, utime:unixtime()}),
    NewScoreRank = lists:keystore(GuildId, 4, ScoreRank, {ServerNum, ServerId, GuildName, GuildId, OldScore+AddScore, Time}),
    % ?PRINT("MailRoleMap:~p, HpPercent:~p,MonType:~p~n",[MailRoleMap, HpPercent, MonType]),
    %% 发送护送奖励
    lib_escort:send_escort_reward(MailRoleMap, EscortCfg),
    NewRoleRankMap = maps:put({ServerId, GuildId}, NewRoleRank, RoleRankMap),
    {NewScoreRank, NewRoleRankMap, EscortCfg}.

%% -----------------------------------------------------------------
%% 排行榜结算
%% -----------------------------------------------------------------
rank_resoult(ZoneId, UnSortList, RoleRankMap, Map) -> 
    % SortList = lists:reverse(lists:keysort(5, UnSortList)),
    SortList = lib_escort:sort_score_rank(UnSortList),
    % ?PRINT("SortList:~p~n",[SortList]),
    Fun = fun({ServerNum, ServerId, GuildName, GuildId, _Score, _}, {Rank, AccMap}) ->
        RoleRank = maps:get({ServerId, GuildId}, RoleRankMap, []),
        #base_escort_rank_reward{guild_reward = _GuildReward, person_reward = PerReward} = data_escort:get_rank_reward(Rank),
        % ?PRINT("Rank:~p, PerReward:~p~n",[Rank, PerReward]),
        %% 公会奖励暂时不发
        (PerReward =/= [] orelse _GuildReward =/= []) andalso 
            lib_escort:send_rank_reward(ServerId, Rank, RoleRank, PerReward, GuildId, GuildName, _GuildReward),
        %% 保存排行榜第一数据
        if
            Rank == 1 ->
                db:execute(io_lib:format(?SQL_REPLACE_ESCORT, [ZoneId, ServerId, ServerNum, GuildId, GuildName])),
                NewMap = maps:put(ZoneId, [{ServerId, ServerNum, GuildId, GuildName}], AccMap);
            true ->
                NewMap = AccMap
        end,
        {Rank+1, NewMap}
    end,
    lists:foldl(Fun, {1, Map}, SortList).

%% -----------------------------------------------------------------
%% 更新本地数接口
%% -----------------------------------------------------------------
update_local_info(ServerId, Data) when is_integer(ServerId) ->
    mod_clusters_center:apply_cast(ServerId, mod_escort_local, update_info, [Data]);
update_local_info(ServerIdList, Data) when is_list(ServerIdList) ->
    [mod_clusters_center:apply_cast(ServerId, mod_escort_local, update_info, [Data]) || ServerId <- ServerIdList];
update_local_info(_, _) -> ok.

update_all_local_info(ZoneMap, StartTime, EndTime) ->
    ZoneList = maps:to_list(ZoneMap),
    Fun = fun({_, ServerIdList}) ->
        update_local_info(ServerIdList, {server, ServerIdList})
    end,
    lists:foreach(Fun, ZoneList),
    mod_clusters_center:apply_to_all_node(mod_escort_local, update_info, [[{time, StartTime, EndTime}]]).