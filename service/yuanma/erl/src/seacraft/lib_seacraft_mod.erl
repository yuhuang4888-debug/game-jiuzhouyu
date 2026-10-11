%%%-----------------------------------
%%% @Module      : lib_seacraft_mod 
%%% @Author      : xlh
%%% @Email       : 1593315047@qq.com
%%% @Created     : 2020
%%% @Description : 怒海争霸数据处理
%%%-----------------------------------

-module(lib_seacraft_mod).

-include("seacraft.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("scene.hrl").

-export([
        init/0                      %% 初始化
        ,init_after/4               %% 初始化回调，从跨服中心获取数据
        ,local_init/2               %% 更新本地数据
        ,zone_change/4              %% 分区更改
        ,center_connected/6         %% 连接跨服中心
        ,act_start/1                %% 活动开始
        ,enter_scene/14             %% 进入活动场景
        ,four_clock/1               %% 4点执行 -- 赛季重置
        ,mon_be_hurt/12             %% 怪物受击
        ,mon_be_kill/10             %% 怪物击杀
        ,mon_be_revive/7            %% 怪物复活
        ,act_end/1                  %% 活动结束
        ,reconnect/7                %% 玩家重连
        ,kill_player/11             %% 击杀玩家
        ,set_join_limit/8           %% 海域之王设置加入海域限制
        ,apply_to_join/10           %% 申请加入海域禁卫
        ,agree_join_apply/7         %% 处理申请禁卫列表
        ,handle_job/7               %% 职位处理
        ,divide_win_reward/10       %% 分配连胜奖励（暂时没用）
        ,join_camp/14               %% 公会加入海域
        ,exit_camp/5                %% 退出海域
        ,gm_start_act/4             %% 秘籍开启活动
        ,exit_guild/5               %% 退出公会
        ,change_guild_info/4        %% 公会信息更改
        ,update_role_info/3         %% 玩家数据更改
        ,auto_join_camp/2           %% 自动为未加入海域公会分配
        ,divide_battle/1            %% 对战分配
        ,calc_auction_produce/5     %% 拍卖产出
        ,gm_repair_data/1
        ,gm_reset_act/1
        ,gm_init/0
        ,gm_remove_act_dsgt/2
    ]).

%% -----------------------------------------------------------------
%% 秘籍重置
%% -----------------------------------------------------------------
gm_reset_act(State) ->
    #kf_seacraft_state{
        zone_map = ZoneMap, camp_map = CampMap, zone_data = ZoneData, 
        guild_camp = GuildCampMap, act_info = ActInfoMap
    } = State,
    mod_kf_seacraft_daily:day_trigger(),
    ZoneIdList = maps:keys(ZoneMap),
    Fun = fun(ZoneId, {TemGuildCampMap, TemCampMap, TemZoneData, TemActInfoMap}) ->
        ServerIdList = maps:get(ZoneId, ZoneMap, []), 
        reset_act(true, ZoneId, ServerIdList, TemGuildCampMap, TemCampMap, TemZoneData, TemActInfoMap)
    end,
    {NewGuildCampMap, NewCampMap, NewZoneData, NewActInfoMap} = lists:foldl(Fun, {GuildCampMap, CampMap, ZoneData, ActInfoMap}, ZoneIdList),
    State#kf_seacraft_state{
        camp_map = NewCampMap, zone_data = NewZoneData, 
        guild_camp = NewGuildCampMap, act_info = NewActInfoMap
    }.

gm_init() ->
    SeaMaster = db:get_all(?SELECT_SEA_INFO),
    {CampMap, GuildCampMap} = calc_camp_map(),
    Fun1 = fun([Zone, Camp, Times], AccMap) ->
        maps:put(Zone, #zone_data{sea_master = {Camp, Times}}, AccMap)
    end,
    ZoneData = lists:foldl(Fun1, #{}, SeaMaster),
    ZoneActInfo = db:get_all(?SELECT_SEA_ACT),
    Fun = fun([ZoneId, ActType, Num, IsReset], AccMap) ->
        maps:put(ZoneId, {ActType, Num, IsReset}, AccMap)
    end,
    ActInfoMap = lists:foldl(Fun, #{}, ZoneActInfo),
    mod_zone_mgr:seacraft_init(3),
    #kf_seacraft_state{guild_camp = GuildCampMap, camp_map = CampMap, zone_data = ZoneData, act_info = ActInfoMap}.

gm_remove_act_dsgt(State, ServerId) ->
    #kf_seacraft_state{guild_camp = GuildCampMap, zone_map = ZoneMap, camp_map = CampMap, zone_data = ZoneData, act_info = ActInfoMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    case maps:get(ZoneId, ZoneMap, []) of
        [] -> 
            spawn(fun() -> 
                timer:sleep(20),
                db:execute(io_lib:format(?DELETE_SEA_GUILD_ZONE, [ZoneId])),
                timer:sleep(20),
                db:execute(io_lib:format(?DELETE_SEA_CAMP_ZONE, [ZoneId])),
                timer:sleep(20),
                db:execute(io_lib:format(?DELETE_SEA_JOB_ZONE, [ZoneId])),
                timer:sleep(20),
                db:execute(io_lib:format(?DELETE_SEA_APPY_ZONE, [ZoneId])),
                timer:sleep(20),
                db:execute(io_lib:format(?DELETE_SEA_INFO_ZONE, [ZoneId])),
                timer:sleep(20),
                db:execute(io_lib:format(?DELETE_SEA_MEMBER_ZONE, [ZoneId])),
                Sql = io_lib:format(<<"delete FROM `seacraft_act` where id = ~p">>, [ZoneId]),
                db:execute(Sql)
                end),
            GuildCampList = maps:get(ServerId, GuildCampMap, []),
            NewGuildCampMap = maps:remove(ServerId, GuildCampMap),
            mod_clusters_center:apply_cast(ServerId, lib_seacraft, do_after_change_camp, [GuildCampList]),
            NewZoneData = maps:remove(ZoneId, ZoneData),
            NewActInfoMap = maps:remove(ZoneId, ActInfoMap),
            CampList = data_seacraft:get_all_camp(),
            KeyList = [{ZoneId, Camp} || Camp <- CampList],
            Fun = fun(Key, AccMap) ->
                maps:remove(Key, AccMap)
            end,
            NewCampInfo = lists:foldl(Fun, CampMap, KeyList),
            State#kf_seacraft_state{guild_camp = NewGuildCampMap, camp_map = NewCampInfo, 
                zone_data = NewZoneData, act_info = NewActInfoMap};
        _ ->
            State
    end.

%% -----------------------------------------------------------------
%% 进程初始化
%% -----------------------------------------------------------------
init() ->
    SeaMaster = db:get_all(?SELECT_SEA_INFO),
    {CampMap, GuildCampMap} = calc_camp_map(),
    Fun1 = fun([Zone, Camp, Times], AccMap) ->
        maps:put(Zone, #zone_data{sea_master = {Camp, Times}}, AccMap)
    end,
    ZoneData = lists:foldl(Fun1, #{}, SeaMaster),
    ZoneActInfo = db:get_all(?SELECT_SEA_ACT),
    Fun = fun([ZoneId, ActType, Num, IsReset], AccMap) ->
        maps:put(ZoneId, {ActType, Num, IsReset}, AccMap)
    end,
    ActInfoMap = lists:foldl(Fun, #{}, ZoneActInfo),
    mod_zone_mgr:seacraft_init(?START_INIT),
    #kf_seacraft_state{guild_camp = GuildCampMap, camp_map = CampMap, zone_data = ZoneData, act_info = ActInfoMap}.

%% -----------------------------------------------------------------
%% 初始化回调 
%% -----------------------------------------------------------------
init_after(State, ZoneMap, ServerInfo, Type) when Type == ?START_INIT -> %% 初始化 0点执行
    #kf_seacraft_state{act_ref = Ref, act_info = ActInfoMap, guild_camp = GuildCampMap, camp_map = CampInfo, zone_data = ZoneData} = State,
    %% 同步刚满足条件的区服信息&&移除不满足活动的区服信息
    {NewZoneMap, ActInfoMap1} = calc_zone_map(ZoneMap, ServerInfo, ActInfoMap),
    %% 定时器刷新校验（可不做
    util:cancel_timer(Ref),
    Now = utime:unixtime(),
    {StartTime, EndTime} = lib_seacraft:calc_act_time(Now),
    TemTime = ?IF(StartTime-Now >= 1800, StartTime-Now-1800, 1),
    NewRef = ?IF(StartTime == 0, undefined, erlang:send_after(TemTime*1000, self(), {'divide_battle'})),
    %% 赛季重置处理
    {NewGuildCampMap, NewCampInfo, NewZoneData, NewActInfoMap} = 
        reset_act_core(Now, ZoneMap, GuildCampMap, CampInfo, ZoneData, ActInfoMap1, StartTime, EndTime),
    State#kf_seacraft_state{zone_map = NewZoneMap, server_info = ServerInfo, start_time = StartTime,
        end_time = EndTime, act_ref = NewRef, act_info = NewActInfoMap, guild_camp = NewGuildCampMap, 
        camp_map = NewCampInfo, zone_data = NewZoneData};

init_after(State, ZoneMap, ServerInfo, Type) when Type == 3 -> 
    #kf_seacraft_state{act_ref = Ref, act_info = ActInfoMap, guild_camp = GuildCampMap, camp_map = CampInfo, zone_data = ZoneData} = State,
    NewZoneMap = calc_zone_map(ZoneMap, ServerInfo),
    util:cancel_timer(Ref),
    Now = utime:unixtime(),
    {StartTime, EndTime} = lib_seacraft:calc_act_time(Now),
    TemTime = ?IF(StartTime-Now >= 1800, StartTime-Now-1800, 1),
    NewRef = ?IF(StartTime == 0, undefined, erlang:send_after(TemTime*1000, self(), {'divide_battle'})),
    {NewGuildCampMap, NewCampInfo, NewZoneData, NewActInfoMap} = 
        reset_act_core(Now, ZoneMap, GuildCampMap, CampInfo, ZoneData, ActInfoMap, StartTime, EndTime),
    NewState = State#kf_seacraft_state{zone_map = NewZoneMap, server_info = ServerInfo, start_time = StartTime,
        end_time = EndTime, act_ref = NewRef, act_info = NewActInfoMap, guild_camp = NewGuildCampMap, 
        camp_map = NewCampInfo, zone_data = NewZoneData},
    Fun = fun(SerId) ->
        local_init(NewState, SerId)
    end,
    lists:foreach(Fun, lists:flatten(maps:values(NewZoneMap))),
    NewState;

init_after(State, ZoneMap, ServerInfo, _Type) -> %% 重新划分小跨服
    #kf_seacraft_state{act_ref = Ref} = State,
    NewZoneMap = calc_zone_map(ZoneMap, ServerInfo),
    util:cancel_timer(Ref),
    Now = utime:unixtime(),
    db:execute(?TRUNCATE_SEA_GUILD),
    db:execute(?TRUNCATE_SEA_CAMP),
    db:execute(?TRUNCATE_SEA_JOB),
    db:execute(?TRUNCATE_SEA_APPLY),
    db:execute(?TRUNCATE_SEA_INFO),
    db:execute(?TRUNCATE_SEA_ACT),
    db:execute(?TRUNCATE_SEA_MEMBER_INFO),
    {StartTime, EndTime} = lib_seacraft:calc_act_time(Now),
    TemTime = ?IF(StartTime-Now >= 1800, StartTime-Now-1800, 1),
    NewRef = ?IF(StartTime == 0, undefined, erlang:send_after(TemTime*1000, self(), {'divide_battle'})),
    StartTime =/= 0 andalso mod_clusters_center:apply_to_all_node(mod_seacraft_local, update_local_info, 
            [[{act_info, StartTime, EndTime, {1, 0}}]]),
    ZoneList = maps:to_list(ZoneMap),
    Fun = fun({ZoneId, _}, AccMap) ->
        maps:put(ZoneId, {1,0,1}, AccMap)
    end,
    ActInfoMap = lists:foldl(Fun, #{}, ZoneList),
    NewState = #kf_seacraft_state{zone_map = NewZoneMap, server_info = ServerInfo, start_time = StartTime, 
        end_time = EndTime, act_ref = NewRef, act_info = ActInfoMap},
    Fun1 = fun(SerId) ->
        local_init(NewState, SerId)
    end,
    lists:foreach(Fun1, lists:flatten(maps:values(NewZoneMap))),
    NewState.

%% -----------------------------------------------------------------
%% 本地初始化回调,需要处理合服后的信息
%% -----------------------------------------------------------------
local_init(State, ServerId) when is_integer(ServerId) ->
    #kf_seacraft_state{camp_map = CampMap, zone_data = ZoneData, start_time = StartTime, end_time = EndTime, act_info = ActInfoMap} = State,
    Zone = lib_clusters_center_api:get_zone(ServerId),
    CampList = maps:to_list(CampMap),
    {ActType, Num, _} = maps:get(Zone, ActInfoMap, {1,0,0}),
    Fun = fun
              ({{ZoneId, Camp}, Value}, Map) when ZoneId == Zone ->
                  maps:put(Camp, Value#camp_info{member_list = []}, Map);
              (_, Map) -> Map
          end,
    LocalCampMap = lists:foldl(Fun, #{}, CampList),
    LocalZoneData = maps:get(Zone, ZoneData, #zone_data{}),
    mod_clusters_center:apply_cast(ServerId, mod_seacraft_local, local_init, [LocalCampMap, LocalZoneData, StartTime, EndTime, {ActType, Num}]),
    %% 同成员数据至游戏服
    lib_seacraft_extra:center_to_game_member_list(Zone, ServerId,maps:keys(LocalCampMap), CampMap),
    State;
local_init(State, ServerInfo) when is_tuple(ServerInfo) ->
    #kf_seacraft_state{
        camp_map = CampMap, guild_camp = GuildMap, zone_data = ZoneData,
        start_time = StartTime, end_time = EndTime, act_info = ActInfoMap,
        zone_map = ZoneMap
    } = State,
    {ServerId, ServerNum, _ServerName, MergeSerIds} = ServerInfo,
    Zone = lib_clusters_center_api:get_zone(ServerId),
    ServerIds = maps:get(Zone, ZoneMap, []),
    %% 处理合服后的信息
    Fun1 = fun
               (MSerId, {AccSIds, AccGMap}) when MSerId =/= ServerId ->
                   case maps:get(MSerId, AccGMap, []) of
                       [] -> NewAccGMap = AccGMap;
                       TemList ->
                           TemList2 = maps:get(ServerId, AccGMap, []),
                           F_combine = fun({GId, C}, AccL) ->  lists:keystore(GId, 1, AccL, {GId, C}) end,
                           NewList = lists:foldl(F_combine, TemList2, TemList),
                           NewAccGMap = maps:put(ServerId, NewList, AccGMap)
                   end,
                   {lists:delete(MSerId, AccSIds), maps:remove(MSerId, NewAccGMap)};
               (_, Acc) -> Acc
        end,
    {NewServerIds, NewGuildMap} = lists:foldl(Fun1, {ServerIds, GuildMap}, MergeSerIds),
    NewZoneMap = maps:put(Zone, NewServerIds, ZoneMap),
    % ServerIds与之前不同，代表了合服了，而且被合服的区，刚还在同一个Zone
    % IsMerge 为true时，需要处理内存数据，并且同步范围需要整个Zone同步
    % IsMerge = ServerIds =/= NewServerIds,
    IsMerge = true,
    Fun2 = fun
               ({ZoneId, Camp}, CampInfo, {AccMap, AccCampMap}) when ZoneId == Zone ->
                   case IsMerge of
                       true ->
                           #camp_info{guild_map = CampGuildMap, job_list = JobList, application_list = ApplyList, camp_master = Master, member_list = MemberList} = CampInfo,
                           NewCampGuildMap = handle_guild_map_merge(CampGuildMap, MergeSerIds, ServerId, ServerNum),
                           NewJobList = handle_job_list_merge(JobList, MergeSerIds, ServerId, ServerNum),
                           NewApplyList = handle_apply_list_merge(ApplyList, MergeSerIds, ServerId, ServerNum),
                           NewMemberList = handle_member_list_merge(MemberList, MergeSerIds, ServerId, Zone, Camp),
                           case Master of
                               [{SerId, GuildId}|_] ->
                                   NewMaster = ?IF(lists:member(SerId, MergeSerIds),[{ServerId, GuildId}], [{SerId, GuildId}]);
                               _ ->
                                   NewMaster = []
                           end,
                           NewCampInfo = CampInfo#camp_info{guild_map = NewCampGuildMap,
                               member_list = NewMemberList, job_list = NewJobList,
                               application_list = NewApplyList, camp_master = NewMaster
                           },
                           {maps:put(Camp, NewCampInfo, AccMap), maps:put({ZoneId, Camp}, NewCampInfo, AccCampMap)};
                       _ ->
                           {maps:put(Camp, CampInfo, AccMap), AccCampMap}
                   end;
               (_, _, Acc) -> Acc
           end,
    {SyncCampMap, NewCampMap} = maps:fold(Fun2, {#{}, CampMap}, CampMap),
    {ActType, Num, _} = maps:get(Zone, ActInfoMap, {1,0,0}),
    LocalZoneData = maps:get(Zone, ZoneData, #zone_data{}),
    %% 根据合服情况同步数据
    ?IF(IsMerge,
        mod_zone_mgr:apply_cast_to_zone2(1, Zone, mod_seacraft_local, local_init, [SyncCampMap, LocalZoneData, StartTime, EndTime, {ActType, Num}]),
        mod_clusters_center:apply_cast(ServerId, mod_seacraft_local, local_init, [SyncCampMap, LocalZoneData, StartTime, EndTime, {ActType, Num}])),
    %% 同成员数据至游戏服
    lib_seacraft_extra:center_to_game_member_list(Zone, ServerId,maps:keys(SyncCampMap), NewCampMap),
    State#kf_seacraft_state{camp_map = NewCampMap, zone_map = NewZoneMap, guild_camp = NewGuildMap};

local_init(State, _Info) ->
    ?ERR("seacraft local_init error ~p ~n", [_Info]),
    State.

%% -----------------------------------------------------------------
%% 分区更改
%% -----------------------------------------------------------------
zone_change(State, ServerId, 0, _NewZone) -> 
    #kf_seacraft_state{server_info = ServerInfo} = State,
    case lists:keyfind(ServerId, 1, ServerInfo) of
        {_ServerId, Optime, _WorldLv, _ServerNum, _ServerName} ->
            OpenDay = lib_c_sanctuary_mod:get_open_day(Optime);
        _ ->
            OpenDay = 0
    end,
    case data_seacraft:get_value(open_day) of
        LimitOpenDay when is_integer(LimitOpenDay) -> skip;
        _ -> LimitOpenDay = 50
    end,
    case OpenDay >= LimitOpenDay of
        true ->
            local_init(State, ServerId);
        _ ->
            State
    end;
zone_change(State, ServerId, OldZone, NewZone) ->
    #kf_seacraft_state{zone_map = ZoneMap, server_info = ServerInfo, act_info = ActInfoMap, 
        camp_map = CampMap, zone_data = ZoneData, guild_camp = GuildCampMap} = State,

    OServerIdL = maps:get(OldZone, ZoneMap, []),
    OServerIdList = lists:delete(ServerId, OServerIdL),
    NServerIdL = maps:get(NewZone, ZoneMap, []),
    NServerIdList = [ServerId|lists:delete(ServerId, NServerIdL)],
    NewGuildCampMap = maps:remove(ServerId, GuildCampMap),

    ZoneMap1 = maps:put(OldZone, OServerIdList, ZoneMap),
    ZoneMap2 = maps:put(NewZone, NServerIdList, ZoneMap1),
    NewZoneMap = calc_zone_map(ZoneMap2, ServerInfo),
    {ActInfoMap1, CampMap1, ZoneData1, GuildCampMap1} = 
        zone_reset(OldZone, OServerIdList, ActInfoMap, NewGuildCampMap, CampMap, ZoneData),
    {ActInfoMap2, NewCampMap, NewZoneData, NewGuildCampMap1} = 
        zone_reset(NewZone, NServerIdList, ActInfoMap1, GuildCampMap1, CampMap1, ZoneData1), 

    State#kf_seacraft_state{zone_map = NewZoneMap, act_info = ActInfoMap2, camp_map = NewCampMap, zone_data = NewZoneData, 
        guild_camp = NewGuildCampMap1}.

zone_reset(ZoneId, ServerIdList, ActInfoMap, GuildCampMap, CampMap, ZoneData) ->
    {_, _, IsReset} = maps:get(ZoneId, ActInfoMap, {1,0,0}),
    if
        IsReset == 0 ->
            {NewGuildCampMap1, NewCampMap, NewZoneData, ActInfoMap1} =
                reset_act(true, ZoneId, ServerIdList, GuildCampMap, CampMap, ZoneData, ActInfoMap),
            {ActInfoMap1, NewCampMap, NewZoneData, NewGuildCampMap1};
        true ->
            {ActInfoMap, CampMap, ZoneData, GuildCampMap}
    end.
    
%% -----------------------------------------------------------------
%% 改变分区合服先执行zone_change，再执行center_connected， 该函数被干掉了，初始化方式改了，不再执行
%% -----------------------------------------------------------------
center_connected(State, ServerId, _OpTime, ServerNum, _ServerName, MergeSerIds) ->
    #kf_seacraft_state{zone_map = ZoneMap, camp_map = CampMap, guild_camp = GuildCampMap, act_info = ActInfoMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    ServerIdL = maps:get(ZoneId, ZoneMap, []),
    OpenDay = lib_c_sanctuary_mod:get_open_day(_OpTime),
    case data_seacraft:get_value(open_day) of
        LimitOpenDay when is_integer(LimitOpenDay) -> skip;
        _ -> LimitOpenDay = 50
    end,
    case OpenDay >= LimitOpenDay of
        true ->
            F = fun
                (SerId, {Acc, AccMap}) when SerId =/= ServerId ->
                    case maps:get(SerId, AccMap, []) of
                        [] -> NewAccMap = AccMap;
                        TemList ->
                            TemList2 = maps:get(ServerId, AccMap, []),
                            NewAccMap = maps:put(ServerId, TemList ++ TemList2, AccMap)
                    end,
                    {lists:delete(SerId, Acc), maps:remove(SerId, NewAccMap)};
                (_, Acc) -> Acc
            end,
            {NewServerIdL, NewGuildCampMap} = lists:foldl(F, {ServerIdL, GuildCampMap}, MergeSerIds),
            NewZoneMap = maps:put(ZoneId, NewServerIdL, ZoneMap),

            CampList = maps:to_list(CampMap),
            Fun = fun
                ({{Zone, Camp}, Value}, Map) when ZoneId == Zone andalso MergeSerIds =/= [ServerId] ->
                    #camp_info{guild_map = GuildMap, job_list = JobList, application_list = ApplyList, camp_master = Master, member_list = MemberList} = Value,
                    NewGuildMap = handle_guild_map_merge(GuildMap, MergeSerIds, ServerId, ServerNum),
                    NewJobList = handle_job_list_merge(JobList, MergeSerIds, ServerId, ServerNum),
                    NewApplyList = handle_apply_list_merge(ApplyList, MergeSerIds, ServerId, ServerNum),
                    NewMemberList = handle_member_list_merge(MemberList, MergeSerIds, ServerId, Zone, Camp),
                    case Master of
                        [{SerId, GuildId}|_] ->
                            case lists:member(SerId, MergeSerIds) of
                                true ->
                                    NewMaster = [{ServerId, GuildId}];
                                _ ->
                                    NewMaster = [{SerId, GuildId}]
                            end;
                        _ ->
                            NewMaster = []
                    end,
                    maps:put({Zone, Camp}, Value#camp_info{guild_map = NewGuildMap, member_list = NewMemberList,
                        job_list = NewJobList, application_list = NewApplyList, camp_master = NewMaster}, Map);
                (_, Map) -> Map
            end,
            NewCampMap = lists:foldl(Fun, CampMap, CampList),
            NewState = State#kf_seacraft_state{zone_map = NewZoneMap, camp_map = NewCampMap, guild_camp = NewGuildCampMap},
            %% 预防重置的时候服务器没有连接上跨服导致没重置
            {ActType, Num, IsReset} = maps:get(ZoneId, ActInfoMap, {1,0,1}),
            ?PRINT("======== ActType:~p, Num:~p, IsReset:~p~n",[ActType, Num, IsReset]),
            spawn(fun() -> 
                timer:sleep(5000), 
                if
                    ActType == ?ACT_TYPE_SEA_PART andalso Num == 0 andalso IsReset == 1 -> %% 通知各个服赛季重置
                         mod_clusters_center:apply_cast(ServerId, mod_seacraft_local, reset_act, []);
                    true -> 
                        skip
                end
            end),
            local_init(NewState, ServerId);
        _ ->
            State
    end.

%% -----------------------------------------------------------------
%% 4点处理
%% -----------------------------------------------------------------
four_clock(State) ->
    #kf_seacraft_state{
        act_info = ActInfoMap, 
        zone_map = ZoneMap, 
        start_time = StartTime,
        end_time = EndTime,
        guild_camp = GuildCampMap,
        camp_map = CampMapTmp,
        zone_data = ZoneDataMap
    } = State,
    CampMap = lib_seacraft_extra:flush_privilege_status(CampMapTmp),
    NowTime = utime:unixtime(),
    case lib_seacraft:is_reset_day(StartTime, NowTime) of
        true ->
            {NewGuildCampMap, NewCampInfo, NewZoneData, NewActInfoMap} =
                reset_act_core(NowTime, ZoneMap, GuildCampMap, CampMap, ZoneDataMap, ActInfoMap, StartTime, EndTime),
            State#kf_seacraft_state{act_info = NewActInfoMap, guild_camp = NewGuildCampMap,
                camp_map = NewCampInfo, zone_data = NewZoneData};
        _ ->  State#kf_seacraft_state{camp_map = CampMap}
    end.

%% -----------------------------------------------------------------
%% 战斗分配
%% -----------------------------------------------------------------
divide_battle(State) ->
    #kf_seacraft_state{
        act_ref = Ref,
        act_info = ActInfoMap, 
        zone_map = ZoneMap,
        start_time = StartTime, 
        camp_map = CampMap, 
        zone_data = ZoneDataMap
    } = State,
    util:cancel_timer(Ref),
    NowTime = utime:unixtime(),
    NewRef = ?IF(StartTime == 0, undefined, erlang:send_after(max(1, StartTime-NowTime)*1000, self(), {'act_start'})),
    {NewCampMap, NewZoneDataMap} = divide_battle_list(ZoneMap, CampMap, ZoneDataMap, ActInfoMap),
    State#kf_seacraft_state{act_ref = NewRef, zone_data = NewZoneDataMap, camp_map = NewCampMap}.
      
%% -----------------------------------------------------------------
%% 活动开启
%% ----------------------------------------------------------------- 
act_start(State) ->
    #kf_seacraft_state{
        act_info = ActInfoMap, 
        zone_map = ZoneMap,
        server_info = ServersInfo,
        end_time = EndTime,
        start_time = StartTime, 
        act_ref = OldRef, 
        camp_map = CampMap, 
        zone_data = ZoneDataMap
    } = State,
    Now = utime:unixtime(),
    Ref = util:send_after(OldRef, max(1, EndTime-Now)*1000, self(), {'act_end'}),
    ZoneList = maps:to_list(ZoneMap),
    Fun = fun({ZoneId, Serverids}, {AccMap1, AccMap2}) ->
        {ActType, ActNum, _} = maps:get(ZoneId, ActInfoMap, {1,0, 1}),
        {Map1, Map2} = 
        if
            ActType == ?ACT_TYPE_SEA_PART ->
                SceneList = lib_seacraft:get_act_scene(ActType, []),
                CampList = maps:to_list(AccMap1),
                Fun1 = fun({{Zone, Camp}, Value}, Map) when Zone == ZoneId andalso is_record(Value, camp_info) ->
                        {_, Scene} = ulists:keyfind(Camp, 1, SceneList, {Camp, 49001}),
                        MonList = lib_seacraft:get_mon_list(Scene),
                        Realm = ?DEFENDER,
                        case Scene =/= 0 of
                            true ->
                                ServerIdList = maps:get(Zone, ZoneMap, []),
                                Wlv = lib_seacraft:calc_average_lv(ServerIdList, ServersInfo),
                                MonInfoList = lib_seacraft:mon_create(Scene, Zone, MonList, Realm, Wlv),
                                update_zone_info(Zone, ZoneMap, update_local_info, [{wlv, Wlv}, {camp_mon, Camp, MonInfoList}]);
                            _ -> 
                                MonInfoList = []  
                        end,
                        maps:put({Zone, Camp}, Value#camp_info{camp_mon = MonInfoList, collect_mon = []}, Map);
                    (_, Map) -> Map
                end,
                NewAccMap1 = lists:foldl(Fun1, AccMap1, CampList),
                [mod_clusters_center:apply_cast(ServerId, lib_seacraft, fun_send_tv, [1, []]) || ServerId <- Serverids],
                {NewAccMap1, AccMap2};
            true ->
                Scene = lib_seacraft:get_act_scene(ActType, 49001),
                ZoneData = maps:get(ZoneId, AccMap2, #zone_data{}),
                MonList = lib_seacraft:get_mon_list(Scene),
                Realm = ?DEFENDER,
                ServerIdList = maps:get(ZoneId, ZoneMap, []),
                Wlv = lib_seacraft:calc_average_lv(ServerIdList, ServersInfo),
                MonInfoList = lib_seacraft:mon_create(Scene, ZoneId, MonList, Realm, Wlv),
                update_zone_info(ZoneId, ZoneMap, update_local_zone_data, [{wlv, Wlv}, {sea_mon, MonInfoList}]),
                NewAccMap2 = maps:put(ZoneId, ZoneData#zone_data{sea_mon = MonInfoList, collect_mon = []}, AccMap2),
                [mod_clusters_center:apply_cast(ServerId, lib_seacraft, fun_send_tv, [2, []]) || ServerId <- Serverids],
                {AccMap1, NewAccMap2}
        end,
        [mod_clusters_center:apply_cast(ServerId, mod_seacraft_local, update_local_info, 
                [[{act_info, StartTime, EndTime, {ActType, ActNum}}]]) || ServerId <- Serverids],
        % mod_clusters_center:apply_to_all_node(mod_seacraft_local, update_local_info, [[{act_info, StartTime, EndTime, {ActType, Num+1}}]]),
        {Map1, Map2}
    end,
    {NewCampMap, NewZoneDataMap} = lists:foldl(Fun, {CampMap, ZoneDataMap}, ZoneList),
    State#kf_seacraft_state{camp_map = NewCampMap, zone_data = NewZoneDataMap, 
        act_ref = Ref, join_map = #{}}.

%% -----------------------------------------------------------------
%% 秘籍开启
%% -----------------------------------------------------------------
gm_start_act(State, _ServerId, ActType, Time) ->
    #kf_seacraft_state{start_time = StartTime, end_time = EndTime, act_info = ActInfoMap} = State,
    % ZoneId = lib_clusters_center_api:get_zone(ServerId),
    Now = utime:unixtime(),
    if
        Now >= StartTime andalso Now =< EndTime ->
            State;
        true ->
            NewActInfoMap = maps:map(fun(_K, _V) -> {ActType,0,1} end, ActInfoMap),
            % {_, _, IsReset} = maps:get(ZoneId, ActInfoMap, {1,0,1}),
            % NewActInfoMap = maps:put(ZoneId, {ActType, 0, IsReset}, ActInfoMap),
            NewState = divide_battle(State#kf_seacraft_state{act_info = NewActInfoMap, start_time = Now, end_time = Now+Time*60}),
            act_start(NewState)
    end.

%% -----------------------------------------------------------------
%% 进入场景
%% -----------------------------------------------------------------
enter_scene(State, ServerNum, ServerId, GuildId, _GuildName, RoleId, RoleName, RoleLv, Power, Picture, PictureVer, Scene, NeedOut, Camp) ->
    #kf_seacraft_state{
        act_info = ActInfoMap, 
        start_time = StartTime, 
        end_time = EndTime, 
        zone_data = ZoneDataMap, 
        camp_map = CampMap, 
        join_map = JoinMap,
        zone_map = ZoneMap
    } = State,
    Now = utime:unixtime(),
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {ActType, _, _} = maps:get(ZoneId, ActInfoMap, {1,0,1}),
    IsSceneRight = 
    case lib_seacraft:get_act_scene(ActType, []) of
        SceneList when is_list(SceneList) -> 
            {_, SceneCfg} = ulists:keyfind(Camp, 1, SceneList, {Camp, 49001}),
            SceneCfg == Scene;
        SceneCfg when is_integer(SceneCfg) -> SceneCfg == Scene;
        _ -> false
    end,               
    {Realm, DividePointId} = calc_act_realm(ActType, GuildId, RoleId, ZoneId, Camp, ZoneDataMap, CampMap),
    ?PRINT("Realm:~p,DividePointId:~p~n",[Realm, DividePointId]),
    if
        Now =< StartTime orelse Now >= EndTime ->
            NewJoinMap = JoinMap, 
            NewCampMap = CampMap, 
            NewZoneDataMap = ZoneDataMap,
            {ok, BinData} = pt_186:write(18613, [0, ?ERRCODE(err186_not_in_act_time)]);
            % lib_server_send:send_to_uid(RoleId, BinData);
        IsSceneRight == false ->
            NewJoinMap = JoinMap,
            NewCampMap = CampMap,
            NewZoneDataMap = ZoneDataMap,
            {ok, BinData} = pt_186:write(18613, [0, ?ERRCODE(err186_act_scene_cant_enter)]);
        Realm == 0 ->
            NewJoinMap = JoinMap,
            NewCampMap = CampMap,
            NewZoneDataMap = ZoneDataMap,
            Code = ?IF(ActType == ?ACT_TYPE_SEA_PART, ?ERRCODE(err186_cant_enter), ?ERRCODE(err186_cant_enter_act)),
            {ok, BinData} = pt_186:write(18613, [0, Code]);
        true ->
            {ok, BinData} = pt_186:write(18613, [?SHIP_TYPE_BATTLESHIP, 1]),
            {X, Y} = lib_seacraft:get_reborn_point(Scene, DividePointId),
            JoinList = maps:get({ServerId, GuildId}, JoinMap, []),
            ArgList = [ServerId, ServerNum, GuildId, RoleId, RoleName, RoleLv, Power, Picture, PictureVer, Camp],
            JoinMember = lib_seacraft:make_record(join_member, ArgList),
            NewJoinList = lists:keystore(RoleId, #join_member.role_id, JoinList, JoinMember),
            NewJoinMap = maps:put({ServerId, GuildId}, NewJoinList, JoinMap),
            PassiveSkill = data_seacraft:get_ship_skill(?SHIP_TYPE_BATTLESHIP), 
            if
                ActType == ?ACT_TYPE_SEA_PART ->
                    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
                    #camp_info{score_list = ScoreList, role_score_map = RoleScoreMap} = CampInfo,
                    {NewScoreList, NewRoleScoreMap, UpScoreList, UpRoleList} = calc_new_score_info(ScoreList, RoleScoreMap, ServerId, 
                            ServerNum, GuildId, RoleId, RoleName, 0),
                    NewCampInfo = CampInfo#camp_info{score_list = NewScoreList, role_score_map = NewRoleScoreMap},
                    NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
                    update_zone_info(ZoneId, ZoneMap, update_local_info, [{score_list, Camp, UpScoreList}, {role_score_map, Camp, UpRoleList}]),
                    NewZoneDataMap = ZoneDataMap;
                true ->
                    ZoneData = maps:get(ZoneId, ZoneDataMap, #zone_data{}),
                    #zone_data{score_list = ScoreList, role_score_map = RoleScoreMap} = ZoneData,
                    {NewScoreList, NewRoleScoreMap, UpScoreList, UpRoleList} = calc_new_score_info_zone(ScoreList, RoleScoreMap, ServerId, 
                            ServerNum, GuildId, RoleId, RoleName, 0, Camp),
                    NewZoneData = ZoneData#zone_data{score_list = NewScoreList, role_score_map = NewRoleScoreMap},
                    update_zone_info(ZoneId, ZoneMap, update_local_zone_data, [{role_score_map, UpRoleList}, {score_list, UpScoreList}]),
                    NewZoneDataMap = maps:put(ZoneId, NewZoneData, ZoneDataMap),
                    NewCampMap = CampMap
            end,
            %% 海域周常任务
            mod_clusters_center:apply_cast(ServerId, lib_seacraft_daily, finish_act, [RoleId, 4, 1]),
            %% 进入场景更新场景进程玩家阵营数据,取消进入之前设置的"锁"
            mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, 
                [RoleId, Scene, ZoneId, 0, X, Y, NeedOut, [{change_scene_hp_lim, 100}, {group, ?SHIP_TYPE_BATTLESHIP}, {camp, Realm}, {passive_skill, PassiveSkill}, {action_free, ?ERRCODE(err186_enter_cluster)}]])
    end,
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
    State#kf_seacraft_state{join_map = NewJoinMap, zone_data = NewZoneDataMap, camp_map = NewCampMap}.

%% -----------------------------------------------------------------
%% 重连
%% -----------------------------------------------------------------
reconnect(State, ServerId, GuildId, Scene, Camp, RoleId, ReloginKV) ->
    #kf_seacraft_state{
        act_info = ActInfoMap, 
        zone_data = ZoneDataMap, 
        camp_map = CampMap
    } = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {ActType, _, _} = maps:get(ZoneId, ActInfoMap, {1,0,1}),                                 
    {Realm, DividePointId} = calc_act_realm(ActType, GuildId, RoleId, ZoneId, Camp, ZoneDataMap, CampMap),
    {X, Y} = lib_seacraft:get_reborn_point(Scene, DividePointId),
    mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, [RoleId, Scene, ZoneId, 0, X, Y, false, ReloginKV++[{camp, Realm}]]),
    State.

%% -----------------------------------------------------------------
%% 攻击怪物，更新积分
%% -----------------------------------------------------------------
mon_be_hurt(State, Scene, PoolId, _CopyId, AtterServerNum, AtterServerId, AtterGuildId, Monid, AtterRoleId, AtterName, Hurt, Hp) ->
    #kf_seacraft_state{
        act_info = ActInfoMap, 
        camp_map = CampMap, 
        zone_data = ZoneDataMap,
        guild_camp = GuildCampMap,
        zone_map = ZoneMap,
        update_time = UpdateMap
    } = State,
    {ActType, _, _} = maps:get(PoolId, ActInfoMap, {1,0,1}),
    CampList = maps:get(AtterServerId, GuildCampMap, []),
    {_, Camp} = ulists:keyfind(AtterGuildId, 1, CampList, {AtterGuildId, 0}),
    if
        Camp == 0 ->
            State;
        ActType == ?ACT_TYPE_SEA_PART ->
            HurtAdd = lib_seacraft:get_hurt_mon_add_score(),
            CampInfo = maps:get({PoolId, Camp}, CampMap, #camp_info{}),
            {NewCampInfo, NewUpdateMap} = update_camp_score_info(CampInfo, HurtAdd, AtterServerId, AtterServerNum, 
                    AtterGuildId, AtterRoleId, AtterName, Scene, Monid, Hurt, Hp, UpdateMap, PoolId, ZoneMap, Camp),
            NewCampMap = maps:put({PoolId, Camp}, NewCampInfo, CampMap),
            State#kf_seacraft_state{camp_map = NewCampMap, update_time = NewUpdateMap};
        true ->
            HurtAdd = lib_seacraft:get_hurt_mon_add_score(),
            ZoneData = maps:get(PoolId, ZoneDataMap, #zone_data{}),
            {NewZoneData, NewUpdateMap} = update_zone_data(ZoneData, HurtAdd, AtterServerId, AtterServerNum, 
                    AtterGuildId, AtterRoleId, AtterName, Scene, Monid, Hurt, Camp, Hp, UpdateMap, PoolId, ZoneMap),
            NewZoneDataMap = maps:put(PoolId, NewZoneData, ZoneDataMap),
            State#kf_seacraft_state{zone_data = NewZoneDataMap, update_time = NewUpdateMap}
    end.

%% -----------------------------------------------------------------
%% 击杀怪物
%% -----------------------------------------------------------------
mon_be_kill(State, Scene, PoolId, CopyId, Monid, AtterServerId, AttrServerNum, AtterGuildId, AttrRoleId, AttrName) ->
    #kf_seacraft_state{
        act_info = ActInfoMap, 
        camp_map = CampMap, 
        zone_data = ZoneDataMap
        ,zone_map = ZoneMap
        ,server_info = ServersInfo
        ,guild_camp = GuildCampMap
    } = State,
    {ActType, _, _} = maps:get(PoolId, ActInfoMap, {1,0,1}),
    CampList = maps:get(AtterServerId, GuildCampMap, []),
    {_, Camp} = ulists:keyfind(AtterGuildId, 1, CampList, {AtterGuildId, 0}),
    case data_seacraft:get_value(act_final_boss_skill) of
        [FinalBoss, _] -> skip;
        _ -> FinalBoss = 4900107
    end,
    case data_seacraft:get_value(kill_mon_add_score) of
        KillAdd when is_integer(KillAdd) -> KillAdd;
        _ -> KillAdd = 100
    end,
    % ServerIdList = maps:get(CopyId, ZoneMap, []),
    case data_seacraft:get_mon_info(Monid, Scene) of
        #base_seacraft_construction{name = Name1, list = List, areamark_id = AreaMarkId} when Monid =/= FinalBoss -> 
            case List of
                [MId|_] -> 
                    #base_seacraft_construction{skill = SkillId} = data_seacraft:get_mon_info(MId, Scene),
                    lib_skill_buff:mon_clean_buff(Scene, PoolId, CopyId, MId, SkillId), %% 解除后一个怪物的无敌效果
                    lib_scene_object:change_attr_by_ids(Scene, PoolId, CopyId, [MId], [{is_be_atted, 1}]),
                    case data_seacraft:get_mon_info(MId, Scene) of
                        #base_seacraft_construction{name = Name2} -> 
                            lib_chat:send_TV({scene, Scene, PoolId, CopyId}, ?MOD_SEACRAFT, 4, [Name1, Name2]);
                        _ -> 
                            skip
                    end;
                _ -> MId = 0
            end,
            AreaMarkId =/= 0 andalso lib_scene:change_area_mark(Scene, PoolId, CopyId, [{AreaMarkId, 5}]), %% 删除动态障碍区
            
            NewState = if
                ActType == ?ACT_TYPE_SEA_PART ->
                    CampInfo = maps:get({PoolId, Camp}, CampMap, #camp_info{}),
                    #camp_info{score_list = ScoreList, role_score_map = RoleScoreMap, camp_mon = MonList, collect_mon = CollectMonList} = CampInfo,
                    NewCollectMonList = lib_seacraft:collect_mon_reborn(Scene, PoolId, Monid, ?DEFENDER, CollectMonList), %% 复活采集怪
                    {NewMonList, Value} = calc_new_mon_list(MonList, Monid, MId),
                    UpMonList = ?IF(Value == 0, [], [{camp_mon, Camp, Value}]),
                    {NewScoreList, NewRoleScoreMap, UpScoreList, UpRoleList} = calc_new_score_info(ScoreList, RoleScoreMap, AtterServerId,
                        AttrServerNum, AtterGuildId, AttrRoleId, AttrName, KillAdd),

                    NewCampInfo = CampInfo#camp_info{camp_mon = NewMonList, collect_mon = NewCollectMonList, 
                        score_list = NewScoreList, role_score_map = NewRoleScoreMap},
                    UpList = UpMonList ++[{score_list, Camp, UpScoreList}, {role_score_map, Camp, UpRoleList}],
                    update_zone_info(PoolId, ZoneMap, update_local_info, UpList),
                    NewCampMap = maps:put({PoolId, Camp}, NewCampInfo, CampMap),
                    State#kf_seacraft_state{camp_map = NewCampMap};
                true ->
                    ZoneData = maps:get(PoolId, ZoneDataMap, #zone_data{}),
                    #zone_data{score_list = ScoreList, role_score_map = RoleScoreMap, sea_mon = MonList, collect_mon = CollectMonList} = ZoneData,
                    NewCollectMonList = lib_seacraft:collect_mon_reborn(Scene, PoolId, Monid, ?DEFENDER, CollectMonList),
                    {NewMonList, Value} = calc_new_mon_list(MonList, Monid, MId),
                    UpMonList = ?IF(Value == 0, [], [{sea_mon, Value}]),
                    {NewScoreList, NewRoleScoreMap, UpScoreList, UpRoleList} = calc_new_score_info_zone(ScoreList, RoleScoreMap, AtterServerId, 
                        AttrServerNum, AtterGuildId, AttrRoleId, AttrName, KillAdd, Camp),
                    UpList = UpMonList ++ [{role_score_map, UpRoleList}, {score_list, UpScoreList}],
                    NewZoneData = ZoneData#zone_data{sea_mon = NewMonList, collect_mon = NewCollectMonList, 
                        score_list = NewScoreList, role_score_map = NewRoleScoreMap},
                    update_zone_info(PoolId, ZoneMap, update_local_zone_data, UpList),
                    NewZoneDataMap = maps:put(PoolId, NewZoneData, ZoneDataMap),
                    State#kf_seacraft_state{zone_data = NewZoneDataMap}
            end,
            {ok, BinData} = pt_186:write(18609, [NewMonList]),
            lib_server_send:send_to_scene(Scene, PoolId, CopyId, BinData),
            NewState;
        #base_seacraft_construction{} -> %% 攻守转换
            MonList = lib_seacraft:get_mon_list(Scene),
            Realm = ?DEFENDER,
            ServerIdList = maps:get(PoolId, ZoneMap, []),
            Wlv = lib_seacraft:calc_average_lv(ServerIdList, ServersInfo),
            MonInfoList = lib_seacraft:mon_create(Scene, PoolId, MonList, Realm, Wlv),
            NewState = if
                ActType == ?ACT_TYPE_SEA_PART ->
                    CampInfo = maps:get({PoolId, Camp}, CampMap, #camp_info{}),
                    #camp_info{score_list = ScoreList, role_score_map = RoleScoreMap, guild_map = GuildMap, att_def = AttDefList, hurt_list = HurtList, divide_point = DividePoint} = CampInfo,
                    {NewAttdefL, NewDividePoint} = calc_new_att_def(AttDefList, DividePoint, HurtList),
                    {NewScoreList, NewRoleScoreMap, UpScoreList, UpRoleList} = calc_new_score_info(ScoreList, RoleScoreMap, AtterServerId, 
                        AttrServerNum, AtterGuildId, AttrRoleId, AttrName, KillAdd),

                    NewCampInfo = CampInfo#camp_info{att_def = NewAttdefL, hurt_list = [], score_list = NewScoreList, role_score_map = NewRoleScoreMap,
                        divide_point = NewDividePoint, camp_mon = MonInfoList, collect_mon = []},
                    update_zone_info(PoolId, ZoneMap, update_local_info, 
                        [{divide_point, Camp, NewDividePoint},{att_def, Camp, NewAttdefL}, {camp_mon, Camp, MonInfoList}, {score_list, Camp, UpScoreList}, {role_score_map, Camp, UpRoleList}]),
                    {SendDefList, SendAttList} = lib_seacraft:data_for_client(?ACT_TYPE_SEA_PART, NewAttdefL, GuildMap),   
                    {ok, Bin} = pt_186:write(18617, [SendAttList, SendDefList]),

                    NewCampMap = maps:put({PoolId, Camp}, NewCampInfo, CampMap),
                    State#kf_seacraft_state{camp_map = NewCampMap};
                true ->
                    ZoneData = maps:get(PoolId, ZoneDataMap, #zone_data{}),
                    #zone_data{score_list = ScoreList, role_score_map = RoleScoreMap, att_def = AttDefList, hurt_list = HurtList, divide_point = DividePoint} = ZoneData,
                    {NewAttdefL, NewDividePoint} = calc_new_att_def(AttDefList, DividePoint, HurtList),
                    {NewScoreList, NewRoleScoreMap, UpScoreList, UpRoleList} = calc_new_score_info_zone(ScoreList, RoleScoreMap, AtterServerId, 
                        AttrServerNum, AtterGuildId, AttrRoleId, AttrName, KillAdd, Camp),
                    NewZoneData = ZoneData#zone_data{att_def = NewAttdefL, hurt_list = [], divide_point = NewDividePoint, 
                        sea_mon = MonInfoList, collect_mon = [], score_list = NewScoreList, role_score_map = NewRoleScoreMap},
                    update_zone_info(PoolId, ZoneMap, update_local_zone_data, 
                        [{divide_point, NewDividePoint},{att_def, NewAttdefL}, {sea_mon, MonInfoList}, {role_score_map, UpRoleList}, {score_list, UpScoreList}]),
                    {SendDefList, SendAttList} = lib_seacraft:data_for_client(2, NewAttdefL, #{}),   
                    {ok, Bin} = pt_186:write(18617, [SendAttList, SendDefList]),
                    NewZoneDataMap = maps:put(PoolId, NewZoneData, ZoneDataMap),
                    State#kf_seacraft_state{zone_data = NewZoneDataMap}
            end,
            {ok, BinData} = pt_186:write(18609, [MonInfoList]),
            lib_server_send:send_to_scene(Scene, PoolId, CopyId, BinData),
            lib_server_send:send_to_scene(Scene, PoolId, CopyId, Bin),
            %% 切换所有玩家坐标
            mod_scene_agent:apply_cast(Scene, PoolId, lib_seacraft, change_role_realm_and_pos, [NewAttdefL, NewDividePoint, Scene, PoolId]),
            NewState;
        _ ->
            State
    end.

%% -----------------------------------------------------------------
%% 击败玩家
%% -----------------------------------------------------------------
kill_player(State, _SceneId, PoolId, _DieId, _DieName, AtterServerId, AtterServerNum, AtterGuildId, AtterRoleId, AtterName, HitIdList) ->
    #kf_seacraft_state{
        act_info = ActInfoMap, 
        camp_map = CampMap, 
        zone_data = ZoneDataMap
        ,zone_map = ZoneMap
        ,guild_camp = GuildCampMap
        ,join_map = JoinMap
    } = State,
    {ActType, _, _} = maps:get(PoolId, ActInfoMap, {1,0,1}),
    HitInfoList = get_hid_list_info(PoolId, ZoneMap, JoinMap, HitIdList), %% 助攻数据
    Fun = fun({ServerId, ServerNum, GuildId, RoleId, RoleName, AttType}, {AccMap1, AccMap2, Acc1, Acc2, Acc3}) ->
        CampList = maps:get(ServerId, GuildCampMap, []),
        {_, Camp} = ulists:keyfind(GuildId, 1, CampList, {GuildId, 0}),
        HurtAdd = lib_seacraft:get_kill_player_add_score(AttType),
        if
            ActType == ?ACT_TYPE_SEA_PART ->
                CampInfo = maps:get({PoolId, Camp}, AccMap1, #camp_info{}),
                #camp_info{score_list = ScoreList, role_score_map = RoleScoreMap} = CampInfo,
                {NewScoreList, NewRoleScoreMap, TemUpScoreList, TemUpRoleList} = calc_new_score_info(ScoreList, RoleScoreMap, ServerId, 
                        ServerNum, GuildId, RoleId, RoleName, HurtAdd, AttType),
                NewCampInfo = CampInfo#camp_info{score_list = NewScoreList, role_score_map = NewRoleScoreMap},
                NewAccMap1 = maps:put({PoolId, Camp}, NewCampInfo, AccMap1),
                {NewAccMap1, AccMap2, lists:keystore(Camp, 2, Acc1, {PoolId, Camp}), TemUpScoreList++Acc2, TemUpRoleList++Acc3};
            true ->
                ZoneData = maps:get(PoolId, AccMap2, #zone_data{}),
                #zone_data{score_list = ScoreList, role_score_map = RoleScoreMap} = ZoneData,
                {NewScoreList, NewRoleScoreMap, TemUpScoreList, TemUpRoleList} = calc_new_score_info_zone(ScoreList, RoleScoreMap, ServerId, 
                        ServerNum, GuildId, RoleId, RoleName, HurtAdd, Camp, AttType),
                NewZoneData = ZoneData#zone_data{score_list = NewScoreList, role_score_map = NewRoleScoreMap},
                NewAccMap2 = maps:put(PoolId, NewZoneData, AccMap2),
                {AccMap1, NewAccMap2, Acc1, TemUpScoreList++Acc2, TemUpRoleList++Acc3}
        end
    end,
    {NewCampMap, NewZoneDataMap, List, UpScoreList, UpRoleList} = lists:foldl(Fun, {CampMap, ZoneDataMap, [], [], []}, 
            [{AtterServerId, AtterServerNum, AtterGuildId, AtterRoleId, AtterName, kill}|HitInfoList]),
    if
        ActType == ?ACT_TYPE_SEA_PART ->
            [begin
                update_zone_info(ZoneId, ZoneMap, update_local_info, [{score_list, Camp, UpScoreList}, {role_score_map, Camp, UpRoleList}])
            end || {ZoneId, Camp} <- List];
        true ->
            update_zone_info(PoolId, ZoneMap, update_local_zone_data, [{role_score_map, UpRoleList}, {score_list, UpScoreList}])
    end,
    State#kf_seacraft_state{camp_map = NewCampMap, zone_data = NewZoneDataMap}.

%% -----------------------------------------------------------------
%% 怪物复活
%% -----------------------------------------------------------------
mon_be_revive(State, ServerId, ServerNum, Scene, Monid, RoleId, RoleName) ->
    #kf_seacraft_state{
        act_info = ActInfoMap, 
        camp_map = CampMap, 
        zone_data = ZoneDataMap
        ,zone_map = ZoneMap
        ,server_info = ServersInfo
        ,guild_camp = GuildCampMap
        ,join_map = JoinMap
    } = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {ActType, _, _} = maps:get(ZoneId, ActInfoMap, {1,0,1}),
    CampList = maps:get(ServerId, GuildCampMap, []),
    GuildId = get_role_guild(ServerId, JoinMap, RoleId),
    {_, Camp} = ulists:keyfind(GuildId, 1, CampList, {GuildId, 0}),
    ReviveList = data_seacraft:get_value(can_be_revive_mon_list),
    % BeforeMonId = lib_seacraft:get_before_collect_id(ReviveList, 0, Monid),
    case data_seacraft:get_value(revive_mon_score) of
        ReviveAdd when is_integer(ReviveAdd) -> ReviveAdd;
        _ -> ReviveAdd = 1
    end,
    {_, [FirstMonId|_] = MonList} = ulists:keyfind(Monid, 1, ReviveList, {Monid, []}),
    case data_seacraft:get_value(act_final_boss_skill) of
        [FinalBoss, SpecialSkillId] -> 
            case data_seacraft:get_mon_info(FirstMonId, Scene) of
                #base_seacraft_construction{name = Name} -> skip;
                _ -> Name = <<>>
            end,
            lib_chat:send_TV({scene, Scene, ZoneId, 0}, ?MOD_SEACRAFT, 6, [RoleName, Name]),
            lib_skill_buff:mon_add_buff(Scene, ZoneId, 0, FinalBoss, SpecialSkillId, 1);
        _ -> skip
    end,
    % {_, BeforeMonList} = ulists:keyfind(BeforeMonId, 1, ReviveList, {BeforeMonId, []}),
    Fun = fun(MId, {Acc, Acc1}) ->
        case lists:keyfind(MId, 1, Acc) of
            {MId, Hp, HpMax, AttBeLimit, NextMon} when AttBeLimit == 1 andalso Hp > 0 ->
                #base_seacraft_construction{skill = SkillId} = data_seacraft:get_mon_info(MId, Scene),
                lib_skill_buff:mon_add_buff(Scene, ZoneId, 0, MId, SkillId, 1),
                lib_scene_object:change_attr_by_ids(Scene, ZoneId, 0, [MId], [{is_be_atted, 0}, {hp, HpMax}]),
                {lists:keystore(MId, 1, Acc, {MId, HpMax, HpMax, 0, NextMon}), lists:delete(MId, Acc1)};
            {MId, Hp, HpMax, _, NextMon} when FirstMonId == MId ->
                {lists:keystore(MId, 1, Acc, {MId, Hp, HpMax, 1, NextMon}), Acc1};
            _ ->
                {Acc, Acc1}
        end
    end,
    NowTime = utime:unixtime(),
    case data_seacraft:get_value(revive_boss_cd) of
        Cd when is_integer(Cd) -> Cd;
        _ -> Cd = 90
    end,
    ServerIdList = maps:get(ZoneId, ZoneMap, []),
    Wlv = lib_seacraft:calc_average_lv(ServerIdList, ServersInfo),
    if
        % BeforeMonId == 0 ->
        %     State;
        ActType == ?ACT_TYPE_SEA_PART ->
            CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
            #camp_info{
                score_list = ScoreList, 
                role_score_map = RoleScoreMap, 
                camp_mon = OldMonInfoList, 
                collect_mon = CollectMonList
            } = CampInfo,
            case lists:keyfind(Monid, 1, CollectMonList) of
                {Monid, IsAlive, _} when IsAlive == 1 ->
                    NewCollectMonList = lists:keystore(Monid, 1, CollectMonList, {Monid, 0, NowTime+Cd}),
                    %% 更新复活cd
                    lib_scene_object:change_attr_by_ids(Scene, ZoneId, 0, [Monid], [{next_collect_time, NowTime+Cd}]),
                    {MonInfoList, NewMonList} = lists:foldl(Fun, {OldMonInfoList, MonList}, MonList),
                    NewMonInfoList = lib_seacraft:mon_create_2(Scene, ZoneId, NewMonList, ?DEFENDER, MonInfoList, Wlv),
                    {NewScoreList, NewRoleScoreMap, UpScoreList, UpRoleList} = calc_new_score_info(ScoreList, RoleScoreMap, ServerId, 
                        ServerNum, GuildId, RoleId, RoleName, ReviveAdd),
                    NewCampInfo = CampInfo#camp_info{score_list = NewScoreList, role_score_map = NewRoleScoreMap, 
                        camp_mon = NewMonInfoList, collect_mon = NewCollectMonList},
                    update_zone_info(ZoneId, ZoneMap, update_local_info, [{camp_mon, Camp, NewMonInfoList}, 
                            {score_list, Camp, UpScoreList}, {role_score_map, Camp, UpRoleList}]),
                    NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
                    % lib_chat:send_TV({scene, Scene, 0, ZoneId}, ?MOD_SEACRAFT, 5, [Name1, Name2]),
                    {ok, BinData} = pt_186:write(18609, [NewMonInfoList]),
                    lib_server_send:send_to_scene(Scene, ZoneId, 0, BinData),
                    State#kf_seacraft_state{camp_map = NewCampMap};
                _ ->
                    State
            end;
        true ->
            ZoneData = maps:get(ZoneId, ZoneDataMap, #zone_data{}),
            #zone_data{
                score_list = ScoreList, 
                role_score_map = RoleScoreMap, 
                sea_mon = OldMonInfoList, 
                collect_mon = CollectMonList
            } = ZoneData,
            case lists:keyfind(Monid, 1, CollectMonList) of
                {Monid, IsAlive, _} when IsAlive == 1 ->
                    NewCollectMonList = lists:keystore(Monid, 1, CollectMonList, {Monid, 0, NowTime+Cd}),
                    lib_scene_object:change_attr_by_ids(Scene, ZoneId, 0, [Monid], [{next_collect_time, NowTime+Cd}]),
                    {MonInfoList, NewMonList} = lists:foldl(Fun, {OldMonInfoList, MonList}, MonList),
                    NewMonInfoList = lib_seacraft:mon_create_2(Scene, ZoneId, NewMonList, ?DEFENDER, MonInfoList, Wlv),
                    {NewScoreList, NewRoleScoreMap, UpScoreList, UpRoleList} = calc_new_score_info_zone(ScoreList, RoleScoreMap, ServerId, 
                            ServerNum, GuildId, RoleId, RoleName, ReviveAdd, Camp),
                    NewZoneData = ZoneData#zone_data{score_list = NewScoreList, role_score_map = NewRoleScoreMap, 
                        sea_mon = NewMonInfoList, collect_mon = NewCollectMonList},
                    update_zone_info(ZoneId, ZoneMap, update_local_zone_data, [{sea_mon, NewMonInfoList}, 
                            {role_score_map, UpRoleList}, {score_list, UpScoreList}]),
                    % lib_chat:send_TV({scene, Scene, 0, ZoneId}, ?MOD_SEACRAFT, 5, [Name1, Name2]),
                    NewZoneDataMap = maps:put(ZoneId, NewZoneData, ZoneDataMap),
                    {ok, BinData} = pt_186:write(18609, [NewMonInfoList]),
                    lib_server_send:send_to_scene(Scene, ZoneId, 0, BinData),
                    State#kf_seacraft_state{zone_data = NewZoneDataMap};
                _ ->
                    State
            end
    end.

%% -----------------------------------------------------------------
%% 活动结束
%% -----------------------------------------------------------------
act_end(State) ->
    #kf_seacraft_state{
        act_info = ActInfoMap, 
        zone_map = ZoneMap, 
        act_ref = OldRef, 
        camp_map = CampMap, 
        zone_data = ZoneDataMap,
        guild_camp = GuildCampMap,
        server_info = _ServersInfo,
        join_map = JoinMap,
        end_time = _EndTime
    } = State,
    util:cancel_timer(OldRef),
    ZoneList = maps:to_list(ZoneMap),
    Fun = fun({ZoneId, Serverids}, {AccMap1, AccMap2, AccMap3}) ->
        {ActType, ANum, _} = maps:get(ZoneId, AccMap3, {1,0,1}),
        {NewActType, NewActNum} = lib_seacraft:calc_act_type(ActType, ANum+1),
        if
            ActType == ?ACT_TYPE_SEA_PART ->
                Fun1 = fun
                    ({Zone, Camp}, CampInfo, {GrandCampMap1, GrandActInfoMap1}) when is_record(CampInfo, camp_info) andalso Zone == ZoneId ->
                        #camp_info{camp_master = [{OldMasterSerId, OldMasterGuildId}|_],
                            score_list = ScoreList, role_score_map = RoleScoreMap,
                            guild_map = GuildMap, att_def = AttDefList, win_reward = WinReward,
                            job_list = JobList, application_list = ApplyList, member_list = MemberList} = CampInfo,
                        %% 海王
                        {_, [{MasterSerId, MasterGuildId}|_] = MasterList} =
                            ulists:keyfind(?DEFENDER, 1, AttDefList, {?DEFENDER, [{OldMasterSerId, OldMasterGuildId}]}),
                        if
                            {MasterSerId, MasterGuildId} =/= {0, 0} -> %% 有公会参加
                                %% 活动奖励发放
                                send_normal_act_end_reward(ScoreList, RoleScoreMap, MasterGuildId, GuildMap, JoinMap, ActType, GuildCampMap, Serverids, Camp),
                                lib_seacraft:db_replace_join_limit(Zone, Camp, CampInfo#camp_info.join_limit, MasterList, WinReward),
                                %% 重新计算职位列表
                                {NewJobList, UpJobList} =
                                    calc_new_job_list(Zone, Camp, OldMasterGuildId, MasterSerId, MasterGuildId, GuildMap, JobList, JoinMap, AttDefList),
                                PrivilegeStatus = lib_seacraft_extra:init_privilege_status(Zone, Camp),
                                GuildList = maps:get(MasterSerId, GuildMap, []),
                                case lists:keyfind(MasterGuildId, #sea_guild.guild_id, GuildList) of
                                    #sea_guild{role_id = MasterRoleId} ->
                                        db:execute(io_lib:format(?DELETE_SEA_APPY, [MasterRoleId])),
                                        UpApplyList = [MasterRoleId],
                                        NewApplyList = lists:keydelete(MasterRoleId, #sea_apply.role_id, ApplyList),
                                        #sea_guild{role_id = OldMasterRoleId} = ulists:keyfind(OldMasterGuildId, #sea_guild.guild_id, GuildList, #sea_guild{}),
                                        NewMemberList = lib_seacraft_extra:update_sea_master(Zone, Camp, MemberList, MasterRoleId, OldMasterRoleId, PrivilegeStatus);
                                    _ ->
                                        NewApplyList = ApplyList, UpApplyList = [], NewMemberList = MemberList
                                end,
                                %% 更新活动数据
                                db:execute(io_lib:format(?REPLACE_SEA_ACT, [ZoneId, NewActType, NewActNum, 0])),
                                NewGrandActInfoMap1 = maps:put(ZoneId, {NewActType, NewActNum, 0}, GrandActInfoMap1),
                                update_zone_info(Zone, ZoneMap, update_local_info, [{camp_master, Camp, MasterList}, {job_list, Camp, UpJobList}, {application_list, Camp, UpApplyList}]),
                                [mod_clusters_center:apply_cast(ServerId, mod_seacraft_local, update_local_info,
                                    [[{act_info, {NewActType, NewActNum}}]]) || ServerId <- Serverids],

                                NewCampInfo = CampInfo#camp_info{
                                    camp_mon = [], att_def = [], hurt_list = [], job_list = NewJobList,
                                    member_list = NewMemberList, divide_point = [], camp_master = MasterList,
                                    role_score_map = #{}, score_list = [], application_list = NewApplyList,
                                    privilege_status = PrivilegeStatus
                                },
                                NewGrandCampMap1 = maps:put({Zone, Camp}, NewCampInfo, GrandCampMap1),
                                {NewGrandCampMap1, NewGrandActInfoMap1};
                            true ->
                                {GrandCampMap1, GrandActInfoMap1}
                        end;
                    (_, _, TemAcc) -> TemAcc
                end,
                {NewAccMap1, NewAccMap3} = maps:fold(Fun1, {AccMap1, AccMap3}, AccMap1),
                {NewAccMap1, NewAccMap2 = AccMap2, NewAccMap3};
            true ->
                ZoneData = maps:get(ZoneId, AccMap2, #zone_data{}),
                #zone_data{score_list = ScoreList, role_score_map = RoleScoreMap, att_def = AttDefList, sea_master = {MsCamp, Num}} = ZoneData,
                {_, [MasterCamp|_]} = ulists:keyfind(?DEFENDER, 1, AttDefList, {?DEFENDER, [MsCamp]}),
                case MasterCamp =/= 0 of
                    true ->
                        SeaMaster = if
                            MasterCamp == MsCamp ->
                                NewNum = Num+1,
                                {MasterCamp, NewNum};
                            true ->
                                NewNum = 1,
                                {MasterCamp, NewNum}
                        end,
                        lib_seacraft:db_replace_sea_info(ZoneId, MasterCamp, NewNum),
                        #camp_info{camp_master = [{MasterSerId, MasterGuildId}] = MasterList, guild_map = GuildMap, win_reward = WinList} = 
                            Value = maps:get({ZoneId, MasterCamp}, AccMap1, #camp_info{}),
                        send_normal_act_end_reward(ScoreList, RoleScoreMap, MasterCamp, GuildMap, JoinMap, ActType, GuildCampMap, Serverids, 0),
                        %% 计算连胜奖励
                        Reward = data_seacraft:get_win_more_reward(NewNum),
                        GuildList = maps:get(MasterSerId, GuildMap, []),
                        case lists:keyfind(MasterGuildId, #sea_guild.guild_id, GuildList) of
                            #sea_guild{role_id = MasterRoleId} -> 
                                send_extra_reward(MasterRoleId, MasterSerId);
                            _ -> skip
                        end,
                        % Wlv = lib_seacraft:calc_average_lv(Serverids, ServersInfo),
                        % %% 拍卖产出计算
                        % case calc_auction_produce(RoleScoreMap, AttDefList, ActType, Wlv, EndTime) of
                        %     {AuctionStartTime, BonusRoleList, AuctionList} ->
                        %         %% 拍卖
                        %         % ?MYLOG("xlh","{AuctionStartTime, BonusRoleList, AuctionList}:~p~n",[{AuctionStartTime, BonusRoleList, AuctionList}]),
                        %         lib_auction_api:start_kf_realm_auction(ZoneId, 186, AuctionStartTime, AuctionList, BonusRoleList);
                        %     _E -> skip
                        % end,
                        if
                            Reward =/= [] ->
                                Funcation = fun({_Num, {SerId, RId}}) -> SerId == 0 andalso RId == 0 end,
                                NewWinList = ?IF(MsCamp =/= MasterCamp, [{NewNum, {0,0}}], lists:keystore(NewNum, 1, lists:filter(Funcation, WinList), {NewNum, {0,0}})),
                                update_zone_info(ZoneId, ZoneMap, update_local_info, [{win_reward, MasterCamp, NewWinList}]);
                            true ->
                                NewWinList = ?IF(MsCamp =/= MasterCamp, [], WinList)
                        end,
                        NewAccMap2 = maps:put(ZoneId, ZoneData#zone_data{sea_mon = [], att_def = [], hurt_list = [], role_score_map = #{},
                                score_list = [], divide_point = [], sea_master = SeaMaster}, AccMap2),
                        update_zone_info(ZoneId, ZoneMap, update_local_zone_data, [{sea_master, SeaMaster}]),
                        lib_seacraft:db_replace_join_limit(ZoneId, MasterCamp, Value#camp_info.join_limit, MasterList, NewWinList),
                        db:execute(io_lib:format(?REPLACE_SEA_ACT, [ZoneId, NewActType, NewActNum, 0])),
                        NewAccMap3 = maps:put(ZoneId, {NewActType, NewActNum, 0}, AccMap3),
                        [mod_clusters_center:apply_cast(ServerId, mod_seacraft_local, update_local_info, 
                                    [[{act_info, {NewActType, NewActNum}}]]) || ServerId <- Serverids],
                        {NewAccMap1 = maps:put({ZoneId, MasterCamp}, Value#camp_info{win_reward = NewWinList}, AccMap1), NewAccMap2};
                    _ ->
                        NewAccMap1 = AccMap1, NewAccMap2 = AccMap2, NewAccMap3 = AccMap3
                end
        end,
        case lib_seacraft:get_act_scene(ActType, []) of
            SceneCfgList when is_list(SceneCfgList) -> 
                SceneList = [Scene || {_, Scene} <- SceneCfgList];
            SceneCfg when is_integer(SceneCfg) -> 
                SceneList = [SceneCfg];
            _ -> SceneList = []
        end,
        spawn(fun() -> 
            [begin
                mod_scene_agent:apply_cast(Scene, ZoneId, lib_seacraft, clear_scene_palyer, []),
                lib_mon:clear_scene_mon(Scene, ZoneId, 0, 0)
            end || Scene <- SceneList]
        end),
        {NewAccMap1, NewAccMap2, NewAccMap3}
    end,
    {NewCampMap, NewZoneDataMap, NewActInfoMap} = lists:foldl(Fun, {CampMap, ZoneDataMap, ActInfoMap}, ZoneList),
    State#kf_seacraft_state{camp_map = NewCampMap, zone_data = NewZoneDataMap, join_map = #{}, act_info = NewActInfoMap}.

%% -----------------------------------------------------------------
%% 加入禁卫限制设置
%% -----------------------------------------------------------------
set_join_limit(State, ServerId, GuildId, Camp, RoleId, LimitLv, LimitPower, Auto) ->
    #kf_seacraft_state{act_info = ActInfoMap, start_time = StartTime, end_time = EndTime, camp_map = CampMap, zone_map = ZoneMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
    #camp_info{camp_master = [{_, MasterGuildId}|_] = Master, application_list = ApplyList, job_list = JobList, win_reward = WinReward} = CampInfo,
    Now = utime:unixtime(), 
    {ActType, _, _} = maps:get(ZoneId, ActInfoMap, {1,0,1}),
    IsOpen = Now >= StartTime andalso Now =< EndTime,
    if
        ActType == ?ACT_TYPE_SEA andalso IsOpen == true ->
            {ok, BinData} = pt_186:write(18602, [?ERRCODE(err186_act_is_running)]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State;
        MasterGuildId =/= GuildId ->
            {ok, BinData} = pt_186:write(18602, [?ERRCODE(err186_not_guild_chief)]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State;
        true ->
            JoinLimit = {LimitLv, LimitPower, Auto},
            lib_seacraft:db_replace_join_limit(ZoneId, Camp, JoinLimit, Master, WinReward),
            {NewApplyList, NewJobList, UpApplyList, UpJobList} = auto_agree_apply(ZoneId, Camp, ApplyList, JoinLimit, JobList),
            NewCampInfo = CampInfo#camp_info{join_limit = JoinLimit, application_list = NewApplyList, job_list = NewJobList},
            update_zone_info(ZoneId, ZoneMap, update_local_info, 
                    [{application_list, Camp, UpApplyList}, {job_list, Camp, UpJobList}, {join_limit, Camp, JoinLimit}]),
            NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
            {ok, BinData} = pt_186:write(18602, [1]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State#kf_seacraft_state{camp_map = NewCampMap}
    end.

%% -----------------------------------------------------------------
%% 申请加入禁卫
%% -----------------------------------------------------------------
apply_to_join(State, Camp, ServerId, ServerNum, Picture, PictureVer, RoleLv, RoleId, RoleName, Power) ->
    #kf_seacraft_state{act_info = ActInfoMap, start_time = StartTime, end_time = EndTime, camp_map = CampMap, zone_map = ZoneMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {ActType, _, _} = maps:get(ZoneId, ActInfoMap, {1,0,1}),
    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
    #camp_info{camp_master = [{_, MasterGuildId}], join_limit = JoinLimit, 
        application_list = ApplyList, job_list = JobList, member_list = MemberList} = CampInfo,
    
    {LimitLv, LimitPower, Auto} = JoinLimit,
    case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
        #sea_job{} = Res ->
            ?PRINT("Res:~p~n",[Res]), 
            {ok, BinData} = pt_186:write(18603, [?ERRCODE(err186_has_join)]),
            NewState = State;
        _ ->
            case lists:keyfind(RoleId, #sea_apply.role_id, ApplyList) of
                #sea_apply{} -> 
                    {ok, BinData} = pt_186:write(18603, [?ERRCODE(err186_has_apply)]),
                    NewState = State;
                _ ->
                    LimitNum = data_seacraft:get_value(job_limit_num),
                    NowNum = erlang:length(JobList),
                    Now = utime:unixtime(),
                    IsOpen = Now >= StartTime andalso Now =< EndTime,
                    if
                        ActType == ?ACT_TYPE_SEA andalso IsOpen == true ->
                            {ok, BinData} = pt_186:write(18603, [?ERRCODE(err186_act_is_running)]),
                            NewState = State;
                        MasterGuildId == 0 ->
                            {ok, BinData} = pt_186:write(18603, [?ERRCODE(err186_wait_for_master_come)]),
                            NewState = State;
                        LimitNum =< NowNum ->
                            {ok, BinData} = pt_186:write(18603, [?ERRCODE(err186_job_num_limit)]),
                            NewState = State;
                        RoleLv >= LimitLv andalso Power >= LimitPower ->
                            ApplyArgList = [ServerId, ServerNum, Picture, PictureVer, RoleLv, RoleId, RoleName, Power],
                            ApplyMember = lib_seacraft:make_record(sea_apply, ApplyArgList),
                            if
                                Auto == 1 -> %% 自动同意
                                    NewApplyList = ApplyList,
                                    JobArgList = [ServerId, ServerNum, RoleId, RoleName, RoleLv, ?SEA_SOLDIER, Power, Picture, PictureVer],
                                    JobMember = lib_seacraft:make_record(sea_job, JobArgList),
                                    lib_seacraft:update_sea_job_info(ZoneId, Camp, JobMember),
                                    NewJobList = lists:keystore(RoleId, #sea_job.role_id, JobList, JobMember),
                                    lib_log_api:log_seacraft_job(Camp, ServerId, RoleId, RoleName, ?SEA_MEMBER, ?SEA_SOLDIER),
                                    lib_seacraft:active_role_dsgt([{ServerId, [{RoleId, ?SEA_SOLDIER}]}]),

                                    NewMemberList = lib_seacraft_extra:members_job_change(MemberList, [ApplyMember], Camp, 
                                        maps:keys(CampInfo#camp_info.guild_map)),

                                    update_zone_info(ZoneId, ZoneMap, update_local_info, [{job_list, Camp, [JobMember]}]);
                                true ->
                                    NewApplyList = lists:keystore(RoleId, #sea_apply.role_id, ApplyList, ApplyMember),
                                    lib_seacraft:update_sea_apply_info(ZoneId, Camp, ApplyMember),
                                    update_zone_info(ZoneId, ZoneMap, update_local_info, [{application_list, Camp, [ApplyMember]}]),
                                    NewJobList = JobList, NewMemberList = MemberList
                            end,
                            {ok, BinData} = pt_186:write(18603, [1]),
                            NewCampInfo = CampInfo#camp_info{application_list = NewApplyList, job_list = NewJobList, member_list = NewMemberList},
                            NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
                            NewState = State#kf_seacraft_state{camp_map = NewCampMap};
                        true ->
                            {ok, BinData} = pt_186:write(18603, [?ERRCODE(err186_be_limit)]),
                            NewState = State
                    end
            end
    end,
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
    NewState.

%% -----------------------------------------------------------------
%% 申请处理（一键）
%% -----------------------------------------------------------------
agree_join_apply(State, ServerId, GuildId, Camp, RoleId, Agree, _) when Agree == 2 orelse Agree == 3 ->
    #kf_seacraft_state{act_info = ActInfoMap, start_time = StartTime, end_time = EndTime, camp_map = CampMap, zone_map = ZoneMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
    #camp_info{member_list = MemberList, application_list = ApplyList, job_list = JobList, join_limit = JoinLimit, camp_master = [{_, MasterGuildId}|_]} = CampInfo,
    {LimitLv, LimitPower, _} = JoinLimit,
    LimitNum = data_seacraft:get_value(job_limit_num),
    NowNum = erlang:length(JobList),
    Now = utime:unixtime(),
    {ActType, _, _} = maps:get(ZoneId, ActInfoMap, {1,0,1}),
    IsOpen = Now >= StartTime andalso Now =< EndTime,
    if
        ActType == ?ACT_TYPE_SEA andalso IsOpen == true ->
            {ok, BinData} = pt_186:write(18605, [?ERRCODE(err186_act_is_running)]),
            NewMemberList = MemberList, NewApplyList = ApplyList, NewJobList = JobList;
        MasterGuildId =/= GuildId ->
            {ok, BinData} = pt_186:write(18605, [?ERRCODE(err186_not_guild_chief)]),
            NewMemberList = MemberList,NewApplyList = ApplyList, NewJobList = JobList;
        Agree == 2 -> %% 一键同意
            {ok, BinData} = pt_186:write(18605, [1]),
            Fun = fun
                (SeaApplyMember, {Acc1, Acc2, AccNum, Acc3, Acc4, Acc5}) when is_record(SeaApplyMember, sea_apply) ->
                    #sea_apply{server_id = SerId, server_num = SerNum, picture = Picture, picture_ver = PictureVer,
                        role_lv = RoleLv, role_id = RId, role_name = RName, combat_power = Power
                    } = SeaApplyMember,
                    case lists:keyfind(RId, #sea_job.role_id, Acc2) of
                        #sea_job{} -> {Acc1, Acc2, AccNum, Acc3, Acc4, Acc5};
                        _ ->
                            if %{serverid, server_num, role_id, role_name, role_lv, job_id, power, picture}
                                RoleLv >= LimitLv andalso Power >= LimitPower andalso AccNum < LimitNum ->
                                    db:execute(io_lib:format(?DELETE_SEA_APPY, [RId])),
                                    JobArgList = [SerId, SerNum, RId, RName, RoleLv, ?SEA_SOLDIER, Power, Picture, PictureVer],
                                    JobMember = lib_seacraft:make_record(sea_job, JobArgList),
                                    lib_seacraft:update_sea_job_info(ZoneId, Camp, JobMember),

                                    lib_log_api:log_seacraft_job(Camp, SerId, RId, RName, ?SEA_MEMBER, ?SEA_SOLDIER),
                                    NewAcc2 = lists:keystore(RId, #sea_job.role_id, Acc2, JobMember),
                                    NewAcc4 = lists:keystore(RId, #sea_job.role_id, Acc4, JobMember),

                                    NewAcc5 = calc_dsgt_list(SerId, Acc5, RId, ?SEA_SOLDIER),
                                    {lists:keydelete(RId, #sea_apply.role_id, Acc1), NewAcc2, AccNum+1, [RId|Acc3], NewAcc4, NewAcc5};
                                true ->
                                    {Acc1, Acc2, AccNum, Acc3, Acc4, Acc5}
                            end
                    end;
                (_, Acc) -> Acc
            end,
            {NewApplyList, NewJobList, _, UpApplyList, UpJobList, ActiveDsgtList} = lists:foldl(Fun, {ApplyList, JobList, NowNum, [], [], []}, ApplyList),
            ?PRINT("ApplyList:~p~n",[ApplyList]),
            lib_seacraft:active_role_dsgt(ActiveDsgtList),
            NewMemberList = lib_seacraft_extra:members_job_change(MemberList, ApplyList, Camp, maps:keys(CampInfo#camp_info.guild_map)),
            update_zone_info(ZoneId, ZoneMap, update_local_info, [{job_list, Camp, UpJobList}, {application_list, Camp, UpApplyList}]);
        Agree == 3 -> %% 一键拒绝
            {ok, BinData} = pt_186:write(18605, [1]),
            NewApplyList = [],
            db:execute(io_lib:format(?DELETE_SEA_APPY_CAMP, [ZoneId, Camp])),
            NewJobList = JobList,
            NewMemberList = MemberList,
            update_zone_info(ZoneId, ZoneMap, update_local_info, [{application_list, Camp, delete}]);
        true ->
            {ok, BinData} = pt_186:write(18605, [1]),
            NewApplyList = ApplyList, NewJobList = JobList, NewMemberList = MemberList
    end,
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
    NewCampInfo = CampInfo#camp_info{member_list = NewMemberList, application_list = NewApplyList, job_list = NewJobList},
    NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
    State#kf_seacraft_state{camp_map = NewCampMap};

%% -----------------------------------------------------------------
%% 申请处理
%% -----------------------------------------------------------------
agree_join_apply(State, ServerId, GuildId, Camp, RoleId, Agree, RId) ->
    #kf_seacraft_state{act_info = ActInfoMap, start_time = StartTime, end_time = EndTime, camp_map = CampMap, zone_map = ZoneMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
    {ActType, _, _} = maps:get(ZoneId, ActInfoMap, {1,0,1}),
    #camp_info{member_list = MemberList, application_list = ApplyList, job_list = JobList, camp_master = [{_, MasterGuildId}|_]} = CampInfo,
    case lists:keyfind(RId, #sea_job.role_id, JobList) of
        #sea_job{} -> 
            {ok, BinData} = pt_186:write(18605, [?ERRCODE(err186_has_join)]),
            NewState = State;
        _ ->
            LimitNum = data_seacraft:get_value(job_limit_num),
            NowNum = erlang:length(JobList),
            Now = utime:unixtime(),
            IsOpen = Now >= StartTime andalso Now =< EndTime,
            if
                ActType == ?ACT_TYPE_SEA andalso IsOpen == true ->
                    {ok, BinData} = pt_186:write(18605, [?ERRCODE(err186_act_is_running)]),
                    NewState = State;
                MasterGuildId =/= GuildId ->
                    {ok, BinData} = pt_186:write(18605, [?ERRCODE(err186_not_guild_chief)]),
                    NewState = State;
                LimitNum =< NowNum ->
                    {ok, BinData} = pt_186:write(18605, [?ERRCODE(err186_job_num_limit)]),
                    NewState = State;
                true ->
                    case lists:keyfind(RId, #sea_apply.role_id, ApplyList) of
                        #sea_apply{} = ApplyItem ->
                            #sea_apply{
                                server_id = SerId, server_num = ServerNum, 
                                picture = Picture, role_lv = RoleLv, role_id = RId, 
                                role_name = RName, combat_power = Power, picture_ver = PictureVer
                            } = ApplyItem,
                            if
                                Agree == 1 ->
                                    NewApplyList = lists:keydelete(RId, #sea_apply.role_id, ApplyList),
                                    JobArgList = [SerId, ServerNum, RId, RName, RoleLv, ?SEA_SOLDIER, Power, Picture, PictureVer],
                                    JobMember = lib_seacraft:make_record(sea_job, JobArgList),
                                    NewJobList = lists:keystore(RId, #sea_job.role_id, JobList, JobMember),
                                    lib_seacraft:update_sea_job_info(ZoneId, Camp, JobMember),
                                    lib_log_api:log_seacraft_job(Camp, SerId, RId, RName, ?SEA_MEMBER, ?SEA_SOLDIER),
                                    lib_seacraft:active_role_dsgt([{SerId, [{RId, ?SEA_SOLDIER}]}]),
                                    db:execute(io_lib:format(?DELETE_SEA_APPY, [RId])),
                                    NewMemberList = lib_seacraft_extra:members_job_change(MemberList, [ApplyItem], Camp, maps:keys(CampInfo#camp_info.guild_map)),
                                    update_zone_info(ZoneId, ZoneMap, update_local_info, [{job_list, Camp, [JobMember]}, {application_list, Camp, [RId]}]);
                                true ->
                                    NewApplyList = lists:keydelete(RId, #sea_apply.role_id, ApplyList),
                                    db:execute(io_lib:format(?DELETE_SEA_APPY, [RId])),
                                    NewJobList = JobList,
                                    NewMemberList = MemberList,
                                    update_zone_info(ZoneId, ZoneMap, update_local_info, [{application_list, Camp, [RId]}])
                            end,
                            {ok, BinData} = pt_186:write(18605, [1]),
                            NewCampInfo = CampInfo#camp_info{application_list = NewApplyList, job_list = NewJobList, member_list = NewMemberList},
                            NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
                            NewState = State#kf_seacraft_state{camp_map = NewCampMap};
                        _ ->
                            {ok, BinData} = pt_186:write(18605, [?ERRCODE(err186_not_apply)]),
                            NewState = State
                    end
            end
    end,
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
    NewState.

%% -----------------------------------------------------------------
%% 职位管理
%% -----------------------------------------------------------------
handle_job(State, ServerId, GuildId, Camp, RoleId, JobId, RoleIdList) ->
    #kf_seacraft_state{start_time = StartTime, end_time = EndTime, act_info = ActInfoMap, camp_map = CampMap, zone_map = ZoneMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
    #camp_info{job_list = JobList, camp_master = [{_, MasterGuildId}|_]} = CampInfo,
    Now = utime:unixtime(),
    {ActType, _, _} = maps:get(ZoneId, ActInfoMap, {1,0,1}),
    IsOpen = Now >= StartTime andalso Now =< EndTime,
    if
        ActType == ?ACT_TYPE_SEA andalso IsOpen == true ->
            {ok, BinData} = pt_186:write(18606, [?ERRCODE(err186_act_is_running)]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State;
        MasterGuildId =/= GuildId -> 
            {ok, BinData} = pt_186:write(18606, [?ERRCODE(err186_not_guild_chief)]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State;
        JobId == ?SEA_MEMBER ->
            Fun = fun
                (RId, {Acc, Acc1, Acc2, Acc3}) when RoleId =/= RId ->
                    case lists:keyfind(RId, #sea_job.role_id, Acc) of
                        #sea_job{server_id = SerId, role_name = RoleName, job_id = OldJobId} ->
                            {_, List} = ulists:keyfind(SerId, 1, Acc1, {SerId, []}),
                            NewAcc1 = lists:keystore(SerId, 1, Acc1, {SerId, [RId|lists:delete(RId, List)]}),
                            NewAcc = lists:keydelete(RId, #sea_job.role_id, Acc),
                            lib_log_api:log_seacraft_job(Camp, SerId, RId, RoleName, OldJobId, ?SEA_MEMBER),
                            db:execute(io_lib:format(?DELETE_SEA_JOB_ROLE, [RId])),
                            NewAcc3 = calc_dsgt_list(SerId, Acc3, RId, OldJobId),
                            {NewAcc, NewAcc1, [RId|Acc3], NewAcc3};
                        _ ->
                            {Acc, Acc1, Acc2, Acc3}
                    end;
                (_, Acc) -> Acc
            end,
            {NewJobList, ServerRoleIdList, UpJobList, RemoveList} = lists:foldl(Fun, {JobList, [], [], []}, RoleIdList),
            lib_seacraft:remove_role_dsgt(RemoveList),
            update_zone_info(ZoneId, ZoneMap, update_local_info, [{job_list, Camp, UpJobList}]),
            lib_seacraft:notify_server_be_remove(ServerRoleIdList),
            {ok, BinData} = pt_186:write(18606, [1]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            NewCampInfoTmp = CampInfo#camp_info{job_list = NewJobList},
            NewCampInfo = lib_seacraft_extra:update_member_job(Camp, NewCampInfoTmp, JobId, RoleIdList),
            NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
            State#kf_seacraft_state{camp_map = NewCampMap};
        true ->
            Fun1 = fun(#sea_job{server_id = SerId, role_id = RId, job_id = TemJobId} = JobMember, {Acc, Acc1, Acc2}) when RoleId =/= RId andalso TemJobId == JobId ->
                case lists:member(RId, RoleIdList) of
                    false -> %% 降职
                        #sea_job{role_name = RoleName} = JobMember,
                        Val = JobMember#sea_job{job_id = ?SEA_SOLDIER},
                        NewAcc = lists:keystore(RId, #sea_job.role_id, Acc, Val),
                        NewAcc1 = lists:keystore(RId, #sea_job.role_id, Acc1, Val),
                        lib_log_api:log_seacraft_job(Camp, SerId, RId, RoleName, TemJobId, ?SEA_SOLDIER),
                        lib_seacraft:update_sea_job_info(ZoneId, Camp, Val);
                    _ ->
                        NewAcc = Acc, NewAcc1 = Acc1
                end,
                NewAcc2 = calc_dsgt_list(SerId, Acc2, RId, ?SEA_SOLDIER),
                {NewAcc, NewAcc1, NewAcc2};
                (_, Acc) -> Acc
            end,

            {NewJobList1, UpJobList1, ActiveDsgtList1} = lists:foldl(Fun1, {JobList, [], []}, JobList),   
            Fun = fun(RId, {Acc, Acc1, Acc2}) ->
                case lists:keyfind(RId, #sea_job.role_id, Acc) of
                    #sea_job{server_id = SerId, role_name = RoleName, job_id = OldJobId} = OldJobMember when OldJobId =/= JobId  ->  %% 升职
                        JobMember = OldJobMember#sea_job{job_id = JobId},
                        NewAcc = lists:keystore(RId, #sea_job.role_id, Acc, JobMember),
                        NewAcc1 = lists:keystore(RId, #sea_job.role_id, Acc1, JobMember),
                        lib_log_api:log_seacraft_job(Camp, SerId, RId, RoleName, OldJobId, JobId),
                        lib_seacraft:update_sea_job_info(ZoneId, Camp, JobMember),
                        NewAcc2 = calc_dsgt_list(SerId, Acc2, RId, JobId),
                        {NewAcc, NewAcc1, NewAcc2};
                    _ ->
                        {Acc, Acc1, Acc2}
                end
            end,
            {NewJobList, UpJobList, ActiveDsgtList} = lists:foldl(Fun, {NewJobList1, UpJobList1, ActiveDsgtList1}, RoleIdList),
            lib_seacraft:active_role_dsgt(ActiveDsgtList),
            % ?PRINT("NewJobList:~p~n",[NewJobList]),
            update_zone_info(ZoneId, ZoneMap, update_local_info, [{job_list, Camp, UpJobList}]),
            {ok, BinData} = pt_186:write(18606, [1]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            NewCampInfoTmp = CampInfo#camp_info{job_list = NewJobList},
            NewCampInfo = lib_seacraft_extra:update_member_job(Camp, NewCampInfoTmp, JobId, RoleIdList),
            NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
            State#kf_seacraft_state{camp_map = NewCampMap}
    end.

%% -----------------------------------------------------------------
%% 连胜奖励分配
%% -----------------------------------------------------------------
divide_win_reward(State, ServerId, GuildId, GuildName, Camp, RoleId, RoleName, SerId, RId, Times) ->
    #kf_seacraft_state{act_info = ActInfoMap, camp_map = CampMap, zone_map = ZoneMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
    {ActType, _, _} = maps:get(ZoneId, ActInfoMap, {1,0,1}),
    #camp_info{job_list = JobList, camp_master = [{MasterSerId, MasterGuildId}|_] = Master, join_limit = JoinLimit, win_reward = WinReward} = CampInfo,
    {_, {_, SendRid}} = ulists:keyfind(Times, 1, WinReward, {Times, {0,0}}),
    Reward = data_seacraft:get_win_more_reward(Times),
    if
        MasterGuildId =/= GuildId ->
            {ok, BinData} = pt_186:write(18616, [?ERRCODE(err186_not_guild_chief)]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State;
        SendRid =/= 0 ->
            {ok, BinData} = pt_186:write(18616, [?ERRCODE(err186_has_divide)]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State;
        Reward == [] ->
            {ok, BinData} = pt_186:write(18616, [?ERRCODE(err186_error_data)]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State;
        true ->
            case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
                #sea_job{} -> 
                    NewWinList = lists:keystore(Times, 1, WinReward, {Times, {SerId, RId}}),
                    lib_seacraft:db_replace_join_limit(ZoneId, Camp, JoinLimit, Master, NewWinList),
                    update_zone_info(ZoneId, ZoneMap, update_local_info, [{win_reward, Camp, NewWinList}]),
                    NewCampInfo = CampInfo#camp_info{win_reward = NewWinList},
                    NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
                    {ok, BinData} = pt_186:write(18616, [1]),
                    lib_log_api:log_seacraft_extra_reward(ActType, Camp, GuildId, GuildName, RoleId, RoleName, Reward),
                    mod_clusters_center:apply_cast(MasterSerId, lib_seacraft, send_win_more_times_reward, [RoleId, RId, Reward, BinData]),
                    State#kf_seacraft_state{camp_map = NewCampMap};
                _ ->
                   {ok, BinData} = pt_186:write(18616, [?ERRCODE(err186_not_camp_job)]),
                    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
                    State
            end
    end.

%% -----------------------------------------------------------------
%% 加入海域
%% -----------------------------------------------------------------
join_camp(State, ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, Camp, RoleLv, Power, Picture, PictureVer) ->
    #kf_seacraft_state{start_time = StartTime, camp_map = CampMap, zone_map = ZoneMap, guild_camp = GuildCampMap} = State,
    IsSameDay = utime:is_same_day(StartTime, utime:unixtime()),
    if
        IsSameDay == true ->
            {ok, BinData} = pt_186:write(18619, [?ERRCODE(err186_act_will_start_today)]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State;
        true ->
            ZoneId = lib_clusters_center_api:get_zone(ServerId),
            CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
            #camp_info{guild_map = GuildMap} = CampInfo,
            GuildList = maps:get(ServerId, GuildMap, []),
            Val = [ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, RoleLv, Power, Picture, PictureVer],
            SeaGuildMember = lib_seacraft:make_record(sea_guild, Val),
            NewGuildList = lists:keystore(GuildId, #sea_guild.guild_id, GuildList, SeaGuildMember),
            NewGuildMap = maps:put(ServerId, NewGuildList, GuildMap),

            GuildCampList = maps:get(ServerId, GuildCampMap, []),
            NewGuildCampList = lists:keystore(GuildId, 1, GuildCampList, {GuildId, Camp}),
            NewGuildCampMap = maps:put(ServerId, NewGuildCampList, GuildCampMap),
            update_zone_info(ZoneId, ZoneMap, update_local_info, [{guild_map, Camp, [{ServerId, SeaGuildMember}]}]),
            lib_seacraft:update_sea_guild_info(ZoneId, Camp, SeaGuildMember),
            {ok, BinData} = pt_186:write(18619, [1]),
            mod_clusters_center:apply_cast(ServerId, lib_seacraft, do_after_change_camp, [RoleId, BinData, Camp, 0, GuildId]),
            NewCampInfo = CampInfo#camp_info{guild_map = NewGuildMap},
            NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
            State#kf_seacraft_state{camp_map = NewCampMap, guild_camp = NewGuildCampMap}
    end.

%% -----------------------------------------------------------------
%% 自动为未加入海域公会分配海域
%% -----------------------------------------------------------------
auto_join_camp(State, List) ->
    #kf_seacraft_state{camp_map = CampMap, zone_map = ZoneMap, guild_camp = GuildCampMap} = State,
    Fun = fun
        ({ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, Camp, RoleLv, Power, Picture, PictureVer}, AccTuple) ->
            {AccMap1, AccMap2, Acc} = AccTuple,
            ZoneId = lib_clusters_center_api:get_zone(ServerId),
            CampInfo = maps:get({ZoneId, Camp}, AccMap1, #camp_info{}),
            #camp_info{guild_map = GuildMap} = CampInfo,
            GuildList = maps:get(ServerId, GuildMap, []),
            ArgList = [ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, RoleLv, Power, Picture, PictureVer],
            SeaGuildMember = lib_seacraft:make_record(sea_guild, ArgList),
            NewGuildList = lists:keystore(GuildId, #sea_guild.guild_id, GuildList, SeaGuildMember),
            NewGuildMap = maps:put(ServerId, NewGuildList, GuildMap),

            GuildCampList = maps:get(ServerId, AccMap2, []),
            NewGuildCampList = lists:keystore(GuildId, 1, GuildCampList, {GuildId, Camp}),
            lib_seacraft:update_sea_guild_info(ZoneId, Camp, SeaGuildMember),
            {ok, BinData} = pt_186:write(18619, [1]),
            mod_clusters_center:apply_cast(ServerId, lib_seacraft, do_after_change_camp, [RoleId, BinData, Camp, 0, GuildId]),
            NewCampInfo = CampInfo#camp_info{guild_map = NewGuildMap},
            {maps:put({ZoneId, Camp}, NewCampInfo, AccMap1), maps:put(ServerId, NewGuildCampList, AccMap2), 
                [{ZoneId, Camp}|lists:delete({ZoneId, Camp}, Acc)]};
        ({ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, RoleLv, Power, Picture, PictureVer} = Tuple, AccTuple) ->
            {AccMap1, AccMap2, Acc} = AccTuple,
            {NewAccMap1, Camp} = divide_guild_camp(AccMap1, Tuple),
            ZoneId = lib_clusters_center_api:get_zone(ServerId),
            GuildCampList = maps:get(ServerId, AccMap2, []),
            NewGuildCampList = lists:keystore(GuildId, 1, GuildCampList, {GuildId, Camp}),
            db:execute(io_lib:format(?REPLACE_SEA_GUILD, [ZoneId, Camp, ServerId, ServerNum, GuildId, 
                    GuildName, GuildPower, RoleId, RoleName, GuildUserNum, RoleLv, Power, Picture, PictureVer])),
            {ok, BinData} = pt_186:write(18619, [1]),
            mod_clusters_center:apply_cast(ServerId, lib_seacraft, do_after_change_camp, [RoleId, BinData, Camp, 0, GuildId]),
            {NewAccMap1, maps:put(ServerId, NewGuildCampList, AccMap2), 
                [{ZoneId, Camp}|lists:delete({ZoneId, Camp}, Acc)]}
    end,
    {NewCampMap, NewGuildCampMap, UpdateList} = lists:foldl(Fun, {CampMap, GuildCampMap, []}, List),
    F1 = fun({ZoneId, Camp}, Acc) ->
        CampInfo = maps:get({ZoneId, Camp}, NewCampMap, #camp_info{}),
        #camp_info{guild_map = GuildMap} = CampInfo,
        case lists:keyfind(ZoneId, 1, Acc) of
            {ZoneId, TemList} -> NewTemList = lists:keystore(Camp, 1, TemList, {Camp, GuildMap});
            _ -> NewTemList = [{Camp, GuildMap}]
        end,
        lists:keystore(ZoneId, 1, Acc, {ZoneId, NewTemList})
    end,
    ZoneCampMapList = lists:foldl(F1, [], UpdateList),
    [update_zone_info(ZoneId, ZoneMap, update_local_info, [{guild_map, CampMapList}]) || {ZoneId, CampMapList} <- ZoneCampMapList],
    State#kf_seacraft_state{camp_map = NewCampMap, guild_camp = NewGuildCampMap}.


%% -----------------------------------------------------------------
%% 退出海域
%% -----------------------------------------------------------------
exit_camp(State, ServerId, GuildId, RoleId, Camp) ->
    #kf_seacraft_state{start_time = StartTime, camp_map = CampMap, zone_map = ZoneMap, guild_camp = GuildCampMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
    #camp_info{guild_map = GuildMap, camp_master = [{_, MasterGuildId}|_]} = CampInfo,
    IsSameDay = utime:is_same_day(StartTime, utime:unixtime()),
    if
        MasterGuildId =/= 0 ->
            {ok, BinData} = pt_186:write(18620, [?ERRCODE(err186_cant_exit_now)]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State;
        IsSameDay == true ->
            {ok, BinData} = pt_186:write(18620, [?ERRCODE(err186_act_will_start_today)]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
            State;
        true ->
            GuildList = maps:get(ServerId, GuildMap, []),
            NewGuildList = lists:keydelete(GuildId, #sea_guild.guild_id, GuildList),
            NewGuildMap = maps:put(ServerId, NewGuildList, GuildMap),

            GuildCampList = maps:get(ServerId, GuildCampMap, []),
            NewGuildCampList = lists:keydelete(GuildId, 1, GuildCampList),
            NewGuildCampMap = maps:put(ServerId, NewGuildCampList, GuildCampMap),

            update_zone_info(ZoneId, ZoneMap, update_local_info, [{guild_map, Camp, [{ServerId, GuildId}]}, {win_reward, Camp, []}]),
            db:execute(io_lib:format(?DELETE_SEA_GUILD, [GuildId])),
            {ok, BinData} = pt_186:write(18620, [1]),
            mod_clusters_center:apply_cast(ServerId, lib_seacraft, do_after_change_camp, [RoleId, BinData, 0, Camp, GuildId]),
            NewCampInfo = CampInfo#camp_info{guild_map = NewGuildMap},
            NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
            State#kf_seacraft_state{camp_map = NewCampMap, guild_camp = NewGuildCampMap}
    end.

%% -----------------------------------------------------------------
%% 退出公会处理
%% -----------------------------------------------------------------
exit_guild(State, ServerId, RoleIdList, Camp, InfoList) ->
    #kf_seacraft_state{camp_map = CampMap, zone_map = ZoneMap, zone_data = ZoneDataMap, guild_camp = GuildCampMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
    ZoneData = maps:get(ZoneId, ZoneDataMap, #zone_data{}),
    {NewCampInfo, NewZoneData, NewGuildCampMap} = exit_guild_helper(ZoneId, ZoneMap, Camp, ServerId, RoleIdList, InfoList, CampInfo, ZoneData, GuildCampMap),
    NewZoneDataMap = maps:put(ZoneId, NewZoneData, ZoneDataMap),
    NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
    State#kf_seacraft_state{camp_map = NewCampMap, zone_data = NewZoneDataMap, guild_camp = NewGuildCampMap}.


%% -----------------------------------------------------------------
%% 公会数据更改
%% -----------------------------------------------------------------
change_guild_info(State, ServerId, Camp, [{cheif, GuildId, RoleId, RoleName, RoleLv, Power, Picture, PictureVer}|T]) ->
    % ?PRINT("=========== InfoList:~p~n",[{cheif, GuildId, RoleId, RoleName, RoleLv, Power, Picture}]),
    #kf_seacraft_state{camp_map = CampMap, zone_data = ZoneDataMap, zone_map = ZoneMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
    #camp_info{camp_master = [{_, MasterGuildId}|_], guild_map = GuildMap, job_list = JobList, application_list = ApplyList, member_list = MemberList} = CampInfo,
    ZoneData = maps:get(ZoneId, ZoneDataMap, #zone_data{}),
    #zone_data{sea_master = {MasterCamp, _}} = ZoneData,
    GuildList = maps:get(ServerId, GuildMap, []),
    
    case lists:keyfind(GuildId, #sea_guild.guild_id, GuildList) of
        #sea_guild{server_id = SerId, guild_id = GuildId, server_num = SerNum,
        role_id = OldMasterRoleId, role_name = OldMasterRoleName} = OldGuildMember when GuildId == MasterGuildId ->
            SeaGuildMember = OldGuildMember#sea_guild{role_id = RoleId, role_name = RoleName, 
                role_lv = RoleLv, combat_power = Power, picture = Picture, picture_ver = PictureVer},

            lib_seacraft:update_sea_guild_info(ZoneId, Camp, SeaGuildMember),
            
            NewUpGuildList = [SeaGuildMember],
            NewGuildList = lists:keystore(GuildId, #sea_guild.guild_id, GuildList, SeaGuildMember),
            NewGuildMap = maps:put(ServerId, NewGuildList, GuildMap),
            
            db:execute(io_lib:format(?DELETE_SEA_JOB_ROLE, [OldMasterRoleId])),
            % db:execute(io_lib:format(?REPLACE_SEA_JOB, [ZoneId, Camp, SerId, SerNum, OPower, OldMasterRoleId, OldMasterRoleName, ORoleLv, ?SEA_MEMBER, OPicture])),
            lib_log_api:log_seacraft_job(Camp, SerId, OldMasterRoleId, OldMasterRoleName, ?SEA_MASTER, ?SEA_MEMBER),
            
            
            case data_seacraft:get_value(sea_master_dsgt_id) of
                DsgtId when is_integer(DsgtId) -> ok;
                _ -> DsgtId = 0
            end,

            NewList = [{OldMasterRoleId, ?SEA_MASTER}],
            RemoveList = [{SerId, NewList}],
            lib_seacraft:remove_role_dsgt(RemoveList),
            

            JobList1 = lists:keydelete(OldMasterRoleId, #sea_job.role_id, JobList),

            case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
                #sea_job{server_id = SerId1, job_id = OldJobId} = OldJobMember ->
                    JobMember = OldJobMember#sea_job{job_id = ?SEA_MASTER},
                    lib_seacraft:update_sea_job_info(ZoneId, Camp, JobMember),
                    lib_log_api:log_seacraft_job(Camp, SerId1, RoleId, RoleName, OldJobId, ?SEA_MASTER);
                _ ->
                    JobArgList = [SerId, SerNum, RoleId, RoleName, RoleLv, ?SEA_MASTER, Power, Picture, PictureVer],
                    JobMember = lib_seacraft:make_record(sea_job, JobArgList),
                    lib_seacraft:update_sea_job_info(ZoneId, Camp, JobMember),
                    lib_log_api:log_seacraft_job(Camp, SerId, RoleId, RoleName, ?SEA_MEMBER, ?SEA_MASTER)
            end,

            if
                MasterCamp == Camp andalso DsgtId =/= 0 ->
                    mod_clusters_center:apply_cast(SerId, lib_designation_api, remove_dsgt, [OldMasterRoleId,  DsgtId]),
                    mod_clusters_center:apply_cast(ServerId, lib_designation_api, active_dsgt_common, [RoleId,  DsgtId]);
                true ->
                    ActiveDsgtList = calc_dsgt_list(SerId, [], RoleId, ?SEA_MASTER),
                    lib_seacraft:active_role_dsgt(ActiveDsgtList)
            end,

            NewJobList = lists:keystore(RoleId, #sea_job.role_id, JobList1, JobMember),
            UpJobList = [OldMasterRoleId, JobMember],
            NewMemberList = lib_seacraft_extra:change_sea_master(ZoneId, Camp, MemberList, OldMasterRoleId, RoleId),
            NewApplyList = lists:keydelete(RoleId, #sea_apply.role_id, ApplyList),
            UpApplyList = [RoleId],
            UpLocalList = [{guild_map, Camp, NewUpGuildList}, {application_list, Camp, UpApplyList}, {job_list, Camp, UpJobList}],
            update_zone_info(ZoneId, ZoneMap, update_local_info, UpLocalList);
        #sea_guild{} = OldGuildMember ->
            SeaGuildMember = OldGuildMember#sea_guild{role_id = RoleId, role_name = RoleName, 
                role_lv = RoleLv, combat_power = Power, picture = Picture},

            lib_seacraft:update_sea_guild_info(ZoneId, Camp, SeaGuildMember),
            NewUpGuildList = [SeaGuildMember],
            NewGuildList = lists:keystore(GuildId, #sea_guild.guild_id, GuildList, SeaGuildMember),
            NewGuildMap = maps:put(ServerId, NewGuildList, GuildMap),
            UpLocalList = [{guild_map, Camp, NewUpGuildList}],
            update_zone_info(ZoneId, ZoneMap, update_local_info, UpLocalList),
            NewJobList = JobList, NewApplyList = ApplyList, NewMemberList = MemberList;
        _ ->
            NewJobList = JobList, NewApplyList = ApplyList, NewGuildMap = GuildMap, NewMemberList = MemberList
    end,
    NewCampInfo = CampInfo#camp_info{guild_map = NewGuildMap, job_list = NewJobList, application_list = NewApplyList, member_list = NewMemberList},
    NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
    NewState = State#kf_seacraft_state{camp_map = NewCampMap},
    change_guild_info(NewState, ServerId, Camp, T);

change_guild_info(State, ServerId, Camp, InfoList) ->
    #kf_seacraft_state{camp_map = CampMap, zone_map = ZoneMap, guild_camp = GuildCampMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
    #camp_info{guild_map = GuildMap} = CampInfo,
    GuildList = maps:get(ServerId, GuildMap, []),
    {NewGuildList, UpGuildList} = handle_guild_list(InfoList, ZoneId, Camp, ServerId, GuildList, []),
    case lists:keyfind(delete, 1, InfoList) of
        {_, GuildId} ->
            GuildCampList = maps:get(ServerId, GuildCampMap, []),
            NewGuildCampList = lists:keydelete(GuildId, 1, GuildCampList),
            NewGuildCampMap = maps:put(ServerId, NewGuildCampList, GuildCampMap);
        _ ->
            NewGuildCampMap = GuildCampMap
    end,
    NewGuildMap = maps:put(ServerId, NewGuildList, GuildMap),
    update_zone_info(ZoneId, ZoneMap, update_local_info, [{guild_map, Camp, UpGuildList}]),
    NewCampInfo = CampInfo#camp_info{guild_map = NewGuildMap},
    NewCampMap = maps:put({ZoneId, Camp}, NewCampInfo, CampMap),
    State#kf_seacraft_state{camp_map = NewCampMap, guild_camp = NewGuildCampMap}.

%% -----------------------------------------------------------------
%% 玩家数据更改
%% -----------------------------------------------------------------
update_role_info(State, ServerId, RoleInfo) ->
    #kf_seacraft_state{zone_map = ZoneMap, camp_map = CampMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    List = maps:to_list(RoleInfo),
    Fun = fun({Camp, RoleList}, TemMap) ->
        CampInfo = maps:get({ZoneId, Camp}, TemMap, #camp_info{}),
        #camp_info{job_list = JobList, application_list = ApplyList} = CampInfo,
        F = fun({RoleId, RoleName, RoleLv, Power, Picture, PictureVer}, {Acc1, Acc2, Acc3, Acc4}) ->
            NewAcc1 = case lists:keyfind(RoleId, #sea_apply.role_id, Acc1) of
                {SerId, SerNum, _, _, _, _, _} ->
                    ApplyArgList = [SerId, SerNum, Picture, PictureVer, RoleLv, RoleId, RoleName, Power],
                    ApplyMember = lib_seacraft:make_record(sea_apply, ApplyArgList),
                    lib_seacraft:update_sea_apply_info(ZoneId, Camp, ApplyMember),

                    NewAcc3 = lists:keystore(RoleId, #sea_apply.role_id, Acc3, ApplyMember),
                    lists:keystore(RoleId, #sea_apply.role_id, Acc1, ApplyMember);
                _ ->
                    NewAcc3 = Acc3, Acc1
            end,
            NewAcc2 = case lists:keyfind(RoleId, #sea_job.role_id, Acc2) of
                #sea_job{} = OldJobMember -> 
                    JobMember = OldJobMember#sea_job{role_name = RoleName, role_lv = RoleLv, combat_power = Power, picture = Picture},
                    lib_seacraft:update_sea_job_info(ZoneId, Camp, JobMember),
                    NewAcc4 = lists:keystore(RoleId, #sea_job.role_id, Acc4, JobMember),
                    lists:keystore(RoleId, #sea_job.role_id, Acc2, JobMember);
                _ ->
                    NewAcc4 = Acc4, Acc2
            end,
            {NewAcc1, NewAcc2, NewAcc3, NewAcc4}
        end,
        {NewApplyList, NewJobList, UpApplyList, UpJobList} = lists:foldl(F, {ApplyList, JobList, [], []}, RoleList),
        update_zone_info(ZoneId, ZoneMap, update_local_info, [{application_list, Camp, UpApplyList}, {job_list, Camp, UpJobList}]),
        NewCampInfo = CampInfo#camp_info{job_list = NewJobList, application_list = NewApplyList},
        maps:put({ZoneId, Camp}, NewCampInfo, TemMap)
    end,
    NewCampMap = lists:foldl(Fun, CampMap, List),
    State#kf_seacraft_state{camp_map = NewCampMap}.

%% -----------------------------------------------------------------
%% 秘籍修复数据--职位列表玩家id为0的情况处理
%% -----------------------------------------------------------------
gm_repair_data(State) ->
    #kf_seacraft_state{zone_map = ZoneMap, camp_map = CampMap} = State,
    db:execute(io_lib:format(?DELETE_SEA_JOB_ROLE, [0])),
    Fun = fun
        ({ZoneId, Camp}, Value) when is_record(Value, camp_info) ->
            #camp_info{guild_map = GuildMap, job_list = JobList, camp_master = [{MasterSerId, MasterGuildId}|_] = Master} = Value,
            GuildList = maps:get(MasterSerId, GuildMap, []),
            ?PRINT("{MasterSerId, MasterGuildId}:~p~n",[{MasterSerId, MasterGuildId}]),
            case lists:keyfind(MasterGuildId, #sea_guild.guild_id, GuildList) of
                #sea_guild{server_id = SerId, server_num = SerNum, role_id = RoleId, role_name = RoleName,
                    role_lv = RoleLv, combat_power = Power, picture = Picture, picture_ver = PictureVer} ->
                    case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
                        #sea_job{job_id = ?SEA_MASTER} ->
                            NewMaster = Master, NewJobList = JobList;
                            % UpList = [{job_list, Camp, NewJobList}, {camp_master, Camp, Master}];
                        _ ->
                            JobArgList = [SerId, SerNum, RoleId, RoleName, RoleLv, ?SEA_MASTER, Power, Picture, PictureVer],
                            JobMember = lib_seacraft:make_record(sea_job, JobArgList),
                            spawn(fun() -> 
                                timer:sleep(urand:rand(10, 100)),
                                lib_seacraft:active_role_dsgt([{SerId, [{RoleId, ?SEA_MASTER}]}]),
                                lib_seacraft:update_sea_job_info(ZoneId, Camp, JobMember),
                                lib_log_api:log_seacraft_job(Camp, SerId, RoleId, RoleName, 0, ?SEA_MASTER)
                            end),
                            NewMaster = Master,
                            NewJobList = [JobMember]
                            % UpList = [{job_list, Camp, NewJobList}]
                    end;
                _ ->
                    List = maps:values(GuildMap),
                    case get_guild_server(List, MasterGuildId) of
                        #sea_guild{server_id = SerId, server_num = SerNum, role_id = RoleId, role_name = RoleName, role_lv = RoleLv,
                            combat_power = Power, picture = Picture, picture_ver = PictureVer} ->
                            NewMaster = [{SerId, MasterGuildId}],
                            JobArgList = [SerId, SerNum, RoleId, RoleName, RoleLv, ?SEA_MASTER, Power, Picture, PictureVer],
                            JobMember = lib_seacraft:make_record(sea_job, JobArgList),
                            spawn(fun() -> 
                                timer:sleep(urand:rand(10, 100)),
                                lib_seacraft:active_role_dsgt([{SerId, [{RoleId, ?SEA_MASTER}]}]),
                                lib_log_api:log_seacraft_job(Camp, SerId, RoleId, RoleName, 0, ?SEA_MASTER),
                                db:execute(io_lib:format(?DELETE_SEA_JOB, [ZoneId, Camp])),
                                lib_seacraft:update_sea_job_info(ZoneId, Camp, JobMember),
                                lib_seacraft:db_replace_join_limit(ZoneId, Camp, Value#camp_info.join_limit, NewMaster, Value#camp_info.win_reward)
                            end),
                            NewJobList = [JobMember];
                            % UpList = [{job_list, Camp, NewJobList}, {camp_master, Camp, NewMaster}];
                        _ ->
                            RoleId = 0,
                            NewMaster = Master,
                            % UpList = [],
                            NewJobList = JobList
                    end
            end,

            F1 = fun
                (#sea_job{server_id = SId, role_id = RId, role_name = RName, job_id = Jid}, {Acc, Acc1, Acc3}) 
                when Jid == ?SEA_MASTER andalso RId =/= RoleId ->
                    case lists:keyfind(SId, 1, Acc) of
                        {_, List1} -> NewList = [{RId, Jid}|List1];
                        _ -> NewList = [{RId, Jid}]
                    end,
                    NewAcc = lists:keystore(SId, 1, Acc, {SId, NewList}),
                    db:execute(io_lib:format(?DELETE_SEA_JOB_ROLE, [RId])),
                    NewAcc1 = lists:keydelete(RId, #sea_job.role_id, Acc1),
                    lib_log_api:log_seacraft_job(Camp, SId, RId, RName, Jid, ?SEA_MEMBER),
                    {NewAcc, NewAcc1, [RId|Acc3]};
                (_, Acc) -> Acc
            end,
            {RemoveList, RealJoblist, _UpJobList} = lists:foldl(F1, {[], NewJobList, []}, JobList),
            lib_seacraft:remove_role_dsgt(RemoveList),
            % ?PRINT("RoleId:~p,UpList:~p,UpJobList:~p~n",[RoleId, UpList,UpJobList]),
            % NewUplist = case lists:keyfind(job_list, 1, UpList) of
            %     {_, OldUpjobList} -> 
            %         lists:keystore(job_list, 1, UpList, {job_list, Camp, OldUpjobList++UpJobList});
            %     _ ->
            %         lists:keystore(job_list, 1, UpList, {job_list, Camp, UpJobList})
            % end,

            % ?PRINT("NewUplist:~p,NewJobList:~p~n",[NewUplist,RealJoblist]),
            % NewUplist =/= [] andalso update_zone_info(ZoneId, ZoneMap, update_local_info, NewUplist),
            Value#camp_info{job_list = RealJoblist, camp_master = NewMaster};
        (_, Value) -> Value
    end,
    NewCampMap = maps:map(Fun, CampMap),
    NewState = State#kf_seacraft_state{camp_map = NewCampMap},
    Fun1 = fun(SerId) ->
        local_init(NewState, SerId)
    end,
    lists:foreach(Fun1, lists:flatten(maps:values(ZoneMap))),
    NewState.



get_guild_server(_, 0) -> 0;
get_guild_server([], _) -> 0;
get_guild_server([TemGuildList|T], MasterGuildId) ->
    case lists:keyfind(MasterGuildId, #sea_guild.guild_id, TemGuildList) of
        Value when is_record(Value, sea_guild) -> Value;
        _ -> get_guild_server(T, MasterGuildId)
    end.


exit_guild_helper(ZoneId, ZoneMap, Camp, ServerId, RoleIdList, InfoList, CampInfo, ZoneData, GuildCampMap) -> 
    #camp_info{guild_map = GuildMap, camp_master = [{_, MasterGuildId}|_], job_list = JobList, application_list = ApplyList} = CampInfo,
    #zone_data{sea_master = {MasterCamp, _}} = ZoneData,
    GuildList = maps:get(ServerId, GuildMap, []),
    case lists:keyfind(delete, 1, InfoList) of
        {_, GuildId} when GuildId == MasterGuildId ->
            spawn(fun() -> 
                    timer:sleep(20), %% 延时处理，防止操作大量数据导致机器负载飙升
                    db:execute(io_lib:format(?DELETE_SEA_GUILD_CAMP, [ZoneId, Camp])),
                    timer:sleep(20),
                    db:execute(io_lib:format(?DELETE_SEA_CAMP, [ZoneId, Camp])),
                    timer:sleep(20),
                    db:execute(io_lib:format(?DELETE_SEA_JOB, [ZoneId, Camp])),
                    timer:sleep(20),
                    db:execute(io_lib:format(?DELETE_SEA_APPY_CAMP, [ZoneId, Camp])),
                    timer:sleep(20),
                    db:execute(io_lib:format(?DELETE_SEA_INFO, [ZoneId, Camp])) 
            end),
            update_zone_info(ZoneId, ZoneMap, update_local_info, [{guild_map, [{Camp, #{}}]}, {win_reward, Camp, []}, 
                {application_list, Camp, delete}, {job_list, Camp, delete}, {join_limit, Camp, {0,0,0}}, {camp_master, [{0,0}]}]),

            Fun = fun(#sea_job{server_id = SerId, role_id = RId, job_id = TemJobId}, Acc) ->
                case lists:keyfind(SerId, 1, Acc) of
                    {_, List} -> NewList = lists:keystore(RId, 1, List, {RId, TemJobId});
                    _ -> NewList = [{RId, TemJobId}]
                end,
                lists:keystore(SerId, 1, Acc, {SerId, NewList})
            end,
            RemoveList = lists:foldl(Fun, [], JobList),
            lib_seacraft:remove_role_dsgt(RemoveList),

            GuildCampList = maps:get(ServerId, GuildCampMap, []),
            NewGuildCampList = lists:keydelete(GuildId, 1, GuildCampList),
            NewGuildCampMap = maps:put(ServerId, NewGuildCampList, GuildCampMap),
            if
                MasterCamp == Camp ->
                    NewZoneData = ZoneData#zone_data{sea_master = {0, 0}},
                    update_zone_info(ZoneId, ZoneMap, update_local_zone_data, [{sea_master, {0,0}}]);
                true ->
                    NewZoneData = ZoneData
            end,
            NewCampInfo = #camp_info{};
        _ ->
            {NewGuildList, UpGuildList} = handle_guild_list(InfoList, ZoneId, Camp, ServerId, GuildList, []),
            NewGuildMap = maps:put(ServerId, NewGuildList, GuildMap),
            Fun = fun(RoleId, {Acc1, Acc2, Acc3, Acc4}) ->
                NewAcc1 = lists:keydelete(RoleId, #sea_job.role_id, Acc1),
                case lists:keyfind(RoleId, #sea_job.role_id, Acc1) of
                    #sea_job{server_id = SerId, role_name = RoleName, job_id = JobId} ->
                        case lists:keyfind(SerId, 1, Acc4) of
                            {_, List} -> NewList = lists:keystore(RoleId, 1, List, {RoleId, JobId});
                            _ -> NewList = [{RoleId, JobId}]
                        end,
                        NewAcc4 = lists:keystore(SerId, 1, Acc4, {SerId, NewList}),
                        lib_log_api:log_seacraft_job(Camp, ServerId, RoleId, RoleName, JobId, 0);
                    _ ->
                        NewAcc4 = Acc4
                end,
                db:execute(io_lib:format(?DELETE_SEA_JOB_ROLE, [RoleId])),
                NewAcc2 = lists:keydelete(RoleId, #sea_apply.role_id, Acc2),
                db:execute(io_lib:format(?DELETE_SEA_APPY, [RoleId])),
                {NewAcc1, NewAcc2, [RoleId|Acc3], NewAcc4}
            end,
            NewGuildCampMap = GuildCampMap,
            {NewJobList, NewApplyList, UpList, RemoveList} = lists:foldl(Fun, {JobList, ApplyList, [], []}, RoleIdList),
            lib_seacraft:remove_role_dsgt(RemoveList),
            update_zone_info(ZoneId, ZoneMap, update_local_info, [{guild_map, Camp, UpGuildList}, 
                {application_list, Camp, UpList}, {job_list, Camp, UpList}]),
            NewZoneData = ZoneData,
            NewCampInfo = CampInfo#camp_info{guild_map = NewGuildMap, job_list = NewJobList, application_list = NewApplyList}
    end,
    {NewCampInfo, NewZoneData, NewGuildCampMap}.
    


handle_guild_list([], _, _, _, GuildList, UpGuildList) -> {GuildList, UpGuildList};
handle_guild_list([{delete, GuildId}|T], ZoneId, Camp, ServerId, GuildList, UpGuildList) ->
    NewGuildList = lists:keydelete(GuildId, #sea_guild.guild_id, GuildList),
    db:execute(io_lib:format(?DELETE_SEA_GUILD, [GuildId])),
    handle_guild_list(T, ZoneId, Camp, ServerId, NewGuildList, [{ServerId, GuildId}|lists:keydelete(GuildId, 2, UpGuildList)]);
handle_guild_list([{name, GuildId, GuildName}|T], ZoneId, Camp, ServerId, GuildList, UpGuildList) ->
    case lists:keyfind(GuildId, #sea_guild.guild_id, GuildList) of
        #sea_guild{} = OldGuildMember ->
            SeaGuildMember = OldGuildMember#sea_guild{guild_name = GuildName},
            lib_seacraft:update_sea_guild_info(ZoneId, Camp, SeaGuildMember),
            NewUpGuildList = lists:keystore(GuildId, #sea_guild.guild_id, UpGuildList, SeaGuildMember),
            NewGuildList = lists:keystore(GuildId, #sea_guild.guild_id, GuildList, SeaGuildMember);
        _ ->
            NewGuildList = GuildList, NewUpGuildList = UpGuildList
    end,
    handle_guild_list(T, ZoneId, Camp, ServerId, NewGuildList, NewUpGuildList);
handle_guild_list([{power, GuildId, NewGuildPower}|T], ZoneId, Camp, ServerId, GuildList, UpGuildList) ->
    case lists:keyfind(GuildId, #sea_guild.guild_id, GuildList) of
        #sea_guild{} = OldGuildMember ->
            SeaGuildMember = OldGuildMember#sea_guild{guild_power = NewGuildPower},
            lib_seacraft:update_sea_guild_info(ZoneId, Camp, SeaGuildMember),
            NewUpGuildList = lists:keystore(GuildId, #sea_guild.guild_id, UpGuildList, SeaGuildMember),
            NewGuildList = lists:keystore(GuildId, #sea_guild.guild_id, GuildList, SeaGuildMember);
        _ ->
            NewGuildList = GuildList, NewUpGuildList = UpGuildList
    end,
    handle_guild_list(T, ZoneId, Camp, ServerId, NewGuildList, NewUpGuildList);
handle_guild_list([{cheif, GuildId, RoleId, RoleName, RoleLv, Power, Picture}|T], ZoneId, Camp, ServerId, GuildList, UpGuildList) ->
    case lists:keyfind(GuildId, #sea_guild.guild_id, GuildList) of
        #sea_guild{} = OldGuildMember ->
            SeaGuildMember = OldGuildMember#sea_guild{role_id = RoleId, role_name = RoleName, 
                role_lv = RoleLv, combat_power = Power, picture = Picture},
            lib_seacraft:update_sea_guild_info(ZoneId, Camp, SeaGuildMember),
            NewUpGuildList = lists:keystore(GuildId, #sea_guild.guild_id, UpGuildList, SeaGuildMember),
            NewGuildList = lists:keystore(GuildId, #sea_guild.guild_id, GuildList, SeaGuildMember);
        _ ->
            NewGuildList = GuildList, NewUpGuildList = UpGuildList
    end,
    handle_guild_list(T, ZoneId, Camp, ServerId, NewGuildList, NewUpGuildList);
handle_guild_list([{num, GuildId, Num}|T], ZoneId, Camp, ServerId, GuildList, UpGuildList) ->
    case lists:keyfind(GuildId, #sea_guild.guild_id, GuildList) of
        #sea_guild{} = OldGuildMember ->
            SeaGuildMember = OldGuildMember#sea_guild{member_num = Num},
            lib_seacraft:update_sea_guild_info(ZoneId, Camp, SeaGuildMember),
            NewUpGuildList = lists:keystore(GuildId, #sea_guild.guild_id, UpGuildList, SeaGuildMember),
            NewGuildList = lists:keystore(GuildId, #sea_guild.guild_id, GuildList, SeaGuildMember);
        _ ->
            NewGuildList = GuildList, NewUpGuildList = UpGuildList
    end,
    handle_guild_list(T, ZoneId, Camp, ServerId, NewGuildList, NewUpGuildList).

calc_new_mon_list(MonList, Monid, MId) ->
    case lists:keyfind(Monid, 1, MonList) of
        {Monid, _, HpMax, _, NextMon} ->
            NMonList = lists:keystore(Monid, 1, MonList, {Monid, 0, HpMax, 0, NextMon}),
            case lists:keyfind(MId, 1, NMonList) of
                {MId, Hp, HpMax1, _, NextMon1} ->
                    {lists:keystore(MId, 1, NMonList, {MId, Hp, HpMax1, 1, NextMon1}), [{MId, Hp, HpMax1, 1, NextMon1}, {Monid, 0, HpMax, 0, NextMon}]};
                _ ->
                    {NMonList, [{Monid, 0, HpMax, 0, NextMon}]}
            end;
        _ ->
            {MonList, 0}
    end.

auto_agree_apply(Zone, Camp, ApplyList, JoinLimit, JobList) ->
    {LimitLv, LimitPower, Auto} = JoinLimit,
    LimitNum = data_seacraft:get_value(job_limit_num),
    NowNum = erlang:length(JobList),
    if
        Auto == 1 ->
            Fun = fun
                (ApplyMember, {Acc1, Acc2, AccNum, Acc3, Acc4, Acc5}) when is_record(ApplyMember, sea_apply) ->
                    #sea_apply{
                        server_id = ServerId, 
                        server_num = ServerNum, 
                        picture = Picture,
                        picture_ver = PictureVer,
                        role_lv = RoleLv, 
                        role_id = RoleId, 
                        role_name = RoleName,
                        combat_power = Power
                    } = ApplyMember,
                    if %{serverid, server_num, role_id, role_name, role_lv, job_id, power, picture}
                        RoleLv >= LimitLv andalso Power >= LimitPower andalso AccNum < LimitNum ->
                            db:execute(io_lib:format(?DELETE_SEA_APPY, [RoleId])),

                            JobArgList = [ServerId, ServerNum, RoleId, RoleName, RoleLv, ?SEA_SOLDIER, Power, Picture, PictureVer],
                            JobMember = lib_seacraft:make_record(sea_job, JobArgList),
                            lib_seacraft:update_sea_job_info(Zone, Camp, JobMember),

                            lib_log_api:log_seacraft_job(Camp, ServerId, RoleId, RoleName, ?SEA_MEMBER, ?SEA_SOLDIER),

                            NewAcc2 = lists:keystore(RoleId, #sea_job.role_id, Acc2, JobMember),
                            NewAcc4 = lists:keystore(RoleId, #sea_job.role_id, Acc4, JobMember),
                            case lists:keyfind(ServerId, 1, Acc5) of
                                {_, List} -> NewList = lists:keystore(RoleId, 1, List, {RoleId, ?SEA_SOLDIER});
                                _ -> NewList = [{RoleId, ?SEA_SOLDIER}]
                            end,
                            NewAcc5 = lists:keystore(ServerId, 1, Acc5, {ServerId, NewList}),
                            {lists:keydelete(RoleId, #sea_apply.role_id, Acc1), NewAcc2, AccNum+1, [RoleId|Acc3], NewAcc4, NewAcc5};
                        true ->
                            {Acc1, Acc2, AccNum, Acc3, Acc4, Acc5}
                    end;
                (_, Acc) -> Acc
            end,
            {NewApplyList, NewJobList, _, UpApplyList, UpJobList, ActiveDsgtList} = 
                lists:foldl(Fun, {ApplyList, JobList, NowNum, [], [], []}, ApplyList),
            lib_seacraft:active_role_dsgt(ActiveDsgtList);
        true ->
            Fun = fun(#sea_apply{role_lv = RoleLv, role_id = RoleId, combat_power = Power}, {Acc, Acc1}) ->
                if %{serverid, server_num, role_id, role_name, role_lv, job_id, power, picture}
                    RoleLv =< LimitLv orelse Power =< LimitPower ->
                        db:execute(io_lib:format(?DELETE_SEA_APPY, [RoleId])),
                        {lists:keydelete(RoleId, #sea_apply.role_id, Acc), [RoleId|Acc1]};
                    true ->
                        {Acc, Acc1}
                end
            end,
            {NewApplyList, UpApplyList} = lists:foldl(Fun, {ApplyList, []}, ApplyList),
            NewJobList = JobList, UpJobList = []
    end,
    {NewApplyList, NewJobList, UpApplyList, UpJobList}.
    
send_extra_reward(MasterRoleId, MasterSerId) ->
    WinReward = data_seacraft:get_value(sea_master_reward),
    mod_clusters_center:apply_cast(MasterSerId, lib_seacraft, send_winer_reward, [MasterRoleId, WinReward]).
    

send_normal_act_end_reward(ScoreList, RoleScoreMap, MasterId, GuildMap, JoinMap, ActType, GuildCampMap, ServerIdList, NowCamp) ->
    RoleScoreList = maps:to_list(RoleScoreMap),
    Fun = fun
        ({_, Value}, AccList) when Value =/= [] ->
            SortList = lib_seacraft:sort_score_rank(Value),
            F = fun(#sea_score{server_id = ServerId, role_id = RoleId, score = Score}, {Acc, Rank}) ->
                case data_seacraft:get_rank_reward(Rank, ActType) of
                    #base_seacraft_rank_reward{reward = Reward} -> 
                        {_, List} = ulists:keyfind(ServerId, 1, Acc, {ServerId, []}),
                        {_, _, _, _, OtherReward} = ulists:keyfind(RoleId, 1, List, {RoleId, Rank, Score, [], []}),
                        NewList = lists:keystore(RoleId, 1, List, {RoleId, Rank, Score, Reward, OtherReward}),
                        {lists:keystore(ServerId, 1, Acc, {ServerId, NewList}), Rank+1};
                    _ ->
                        {Acc, Rank+1}
                end
            end,
            {NewAcc, _} = lists:foldl(F, {AccList, 1}, SortList),
            NewAcc;
        (_, AccList) -> AccList
    end,
    ServerRoleList = lists:foldl(Fun, [], RoleScoreList),

    SortList = lib_seacraft:sort_score_rank(ScoreList),
    Fun2 = fun
        ({ServerId, GuildId, Score, _}, {Acc, Rank}) ->
            GuildList = maps:get(ServerId, GuildMap, []),
            case lists:keyfind(GuildId, #sea_guild.guild_id, GuildList) of
                #sea_guild{guild_name = GuildName} -> skip;
                _ -> GuildName = ""
            end,
            lib_log_api:log_seacraft_result(ActType, GuildId, GuildName, ?IF(GuildId == MasterId, 1, 0)),
            {[{ServerId, GuildId, Score, Rank}|Acc], Rank+1};
        ({Camp, Score, _}, {Acc, Rank}) ->
            case data_seacraft:get_camp_name(Camp) of
                Name when Name =/= [] -> Name;
                _ -> Name = ""
            end,
            lib_log_api:log_seacraft_result(ActType, Camp, Name, ?IF(Camp == MasterId, 1, 0)),
            {[{Camp, Score, Rank}|Acc], Rank+1}
    end,
    {RanList, _} = lists:foldl(Fun2, {[], 1}, SortList),

    JoinList = maps:to_list(JoinMap),
    case data_seacraft:get_act_reward(ActType) of
        #base_seacraft_reward{success_reward = SucessReward, fail_reward = FailReward} -> skip;
        _ -> SucessReward = [], FailReward = []
    end,
    Fun1 = fun({{ServerId, GuildId}, Value}, Acc) ->
        IsMember = lists:member(ServerId, ServerIdList),
        if
            IsMember == false ->
                Acc;
            ActType == ?ACT_TYPE_SEA_PART ->
                {_, _, _, GuildRank} = ulists:keyfind(GuildId, 2, RanList, {ServerId, GuildId, 0, 4}),
                {ActRes, Reward} = ?IF(GuildId == MasterId, {1, SucessReward}, {0, FailReward}),
                F = fun
                    (#join_member{server_id = SerId, role_id = RoleId, camp = TemCamp}, TemAcc) when TemCamp == NowCamp ->
                        {_, List1} = ulists:keyfind(SerId, 1, ServerRoleList, {SerId, []}),
                        {_, Rank, Score, RankReward, _} = ulists:keyfind(RoleId, 1, List1, {RoleId, 0, 0, [], []}),
                        {_, List} = ulists:keyfind(SerId, 1, TemAcc, {SerId, []}),
                        NewList = lists:keystore(RoleId, 1, List, {RoleId, GuildRank, Rank, Score, RankReward, Reward, ActRes}),
                        lists:keystore(SerId, 1, TemAcc, {SerId, NewList});
                    (_, TemAcc) -> TemAcc
                end,
                lists:foldl(F, Acc, Value);
            true ->
                CampList = maps:get(ServerId, GuildCampMap, []),
                {_, Camp} = ulists:keyfind(GuildId, 1, CampList, {GuildId, 0}),
                {_, _, GuildRank} = ulists:keyfind(Camp, 1, RanList, {Camp, 0, 4}),
                {ActRes, Reward} = ?IF(Camp == MasterId, {1, SucessReward}, {0, FailReward}),
                F = fun
                    (#join_member{server_id = SerId, role_id = RoleId}, TemAcc) ->
                        {_, List1} = ulists:keyfind(SerId, 1, ServerRoleList, {SerId, []}),
                        {_, Rank, Score, RankReward, _} = ulists:keyfind(RoleId, 1, List1, {RoleId, 0, 0, [], []}),
                        {_, List} = ulists:keyfind(SerId, 1, TemAcc, {SerId, []}),
                        NewList = lists:keystore(RoleId, 1, List, {RoleId, GuildRank, Rank, Score, RankReward, Reward, ActRes}),
                        lists:keystore(SerId, 1, TemAcc, {SerId, NewList});
                    (_, TemAcc) -> TemAcc
                end,
                lists:foldl(F, Acc, Value)
        end
    end,
    ServerRoleList1 = lists:foldl(Fun1, [], JoinList),
    [mod_clusters_center:apply_cast(ServerId, lib_seacraft, send_reward_helper, [ActType, List]) || {ServerId, List} <- ServerRoleList1].

    
calc_new_att_def(AttDefList, DividePoint, []) -> {AttDefList, DividePoint};
calc_new_att_def([{?DEFENDER, [{_SerId, OldId}|_]}, {?ATTACKER, List}] = AttDefList, DividePoint, HurtList) ->
    NewHurtList = lists:keydelete(OldId, 1, HurtList),
    case lists:reverse(lists:keysort(2, NewHurtList)) of
        [{Id, _}|_] ->
            {ServerId, _} = ulists:keyfind(Id, 2, List, {0, Id}),
            TemList = lists:keystore(?DEFENDER, 1, AttDefList, {?DEFENDER, [{ServerId, Id}]}),
            case lists:keyfind(OldId, 1, DividePoint) of
                {_, Point1} -> ok;
                _ -> Point1 = 1
            end,
            case lists:keyfind(Id, 1, DividePoint) of
                {_, Point2} -> ok;
                _ -> Point2 = 1
            end,
            DividePointL = lists:keystore(Id, 1, DividePoint, {Id, Point1}),
            NewDividePoint = lists:keystore(OldId, 1, DividePointL, {OldId, Point2}),
            NewList = lists:keystore(?ATTACKER, 1, TemList, {?ATTACKER, [{_SerId, OldId}|lists:keydelete(Id, 2, List)]}),
            {NewList, NewDividePoint};
        _ ->
            {AttDefList, DividePoint}
    end;
calc_new_att_def([{?DEFENDER, [OldId|_]}, {?ATTACKER, List}] = AttDefList, DividePoint, HurtList) ->
    NewHurtList = lists:keydelete(OldId, 1, HurtList),
    case lists:reverse(lists:keysort(2, NewHurtList)) of
        [{Id, _}|_] ->
            TemList = lists:keystore(?DEFENDER, 1, AttDefList, {?DEFENDER, [Id]}),
            case lists:keyfind(OldId, 1, DividePoint) of
                {_, Point1} -> ok;
                _ -> Point1 = 1
            end,
            case lists:keyfind(Id, 1, DividePoint) of
                {_, Point2} -> ok;
                _ -> Point2 = 1
            end,
            DividePointL = lists:keystore(Id, 1, DividePoint, {Id, Point1}),
            NewDividePoint = lists:keystore(OldId, 1, DividePointL, {OldId, Point2}),
            NewList = lists:keystore(?ATTACKER, 1, TemList, {?ATTACKER, [OldId|lists:delete(Id, List)]}),
            {NewList, NewDividePoint};
        _ ->
            {AttDefList, DividePoint}
    end.

calc_act_realm(ActType, GuildId, RoleId, ZoneId, Camp, ZoneDataMap, CampMap) ->
    CampInfo = maps:get({ZoneId, Camp}, CampMap, #camp_info{}),
    #camp_info{att_def = AttDefList, job_list = JobList, divide_point = DividePoint} = CampInfo,
    if
        ActType == ?ACT_TYPE_SEA_PART ->
            case lists:keyfind(GuildId, 1, DividePoint) of
                {GuildId, PointId} -> skip;
                _ -> PointId = 1
            end,
            {calc_act_realm_helper_1(AttDefList, GuildId), PointId};
        true ->
            ZoneData = maps:get(ZoneId, ZoneDataMap, #zone_data{}),
            #zone_data{att_def = ZoneAttDefList, divide_point = PointList} = ZoneData,
            case lists:keyfind(Camp, 1, PointList) of
                {_, PointId} -> skip;
                _ -> PointId = 1
            end,
            case lists:keyfind(RoleId, #sea_job.role_id, JobList) of
                #sea_job{job_id = JobId} when JobId =< ?SEA_SOLDIER ->
                    {calc_act_realm_helper_2(ZoneAttDefList, Camp), PointId};
                _ ->
                    {0, 1}
            end
    end.

calc_act_realm_helper_1([], _) -> 0;
calc_act_realm_helper_1([{Realm, List}|T], GuildId) ->
    case lists:keyfind(GuildId, 2, List) of
        {_, _} -> Realm;
        _ -> calc_act_realm_helper_1(T, GuildId)
    end.

calc_act_realm_helper_2([], _) -> 0;
calc_act_realm_helper_2([{Realm, List}|T], Camp) ->
    case lists:member(Camp, List) of
        true -> Realm;
        _ -> calc_act_realm_helper_2(T, Camp)
    end.

update_zone_data(ZoneData, HurtAdd, AtterServerId, AtterServerNum, AtterGuildId, AtterRoleId, AtterName, Scene, Monid, Hurt, Camp, Hp, UpdateMap, PoolId, ZoneMap) ->
    #zone_data{score_list = ScoreList, hurt_list = HurtList, role_score_map = RoleScoreMap, sea_mon = MonList} = ZoneData,
    
    NewMonList = case lists:keyfind(Monid, 1, MonList) of
        {Monid, _, HpMax, IsbeLimitAtt, NextMon} ->
            lists:keystore(Monid, 1, MonList, {Monid, Hp, HpMax, IsbeLimitAtt, NextMon});
        _ ->
            MonList
    end,

    {NewScoreList, NewRoleScoreMap, _, _} = calc_new_score_info_zone(ScoreList, RoleScoreMap, AtterServerId, 
            AtterServerNum, AtterGuildId, AtterRoleId, AtterName, HurtAdd, Camp),

    case data_seacraft:get_mon_info(Monid, Scene) of
        #base_seacraft_construction{list = List} -> 
            if
                List == [] -> %% 神像
                    NewHurtList = case lists:keyfind(Camp, 1, HurtList) of
                        {_, OHurt} -> 
                            lists:keystore(Camp, 1, HurtList, {Camp, Hurt+OHurt});
                        _ ->
                            lists:keystore(Camp, 1, HurtList, {Camp, Hurt})
                    end;
                true ->
                    NewHurtList = HurtList
            end;
        _ -> 
            NewHurtList = HurtList
    end,
    Now = utime:unixtime(),
    Time = maps:get(PoolId, UpdateMap, 0),
    case data_seacraft:get_value(role_score_change_time) of
        TimeCfg when is_integer(TimeCfg) -> TimeCfg;
        _ -> TimeCfg = 60
    end,
    if
        Now >= Time+TimeCfg ->
            update_zone_info(PoolId, ZoneMap, update_local_zone_data, 
                    [{sea_mon, NewMonList}, {role_score_map, NewRoleScoreMap}, {score_list, NewScoreList}]),
            {ok, BinData} = pt_186:write(18609, [NewMonList]),
            lib_server_send:send_to_scene(Scene, PoolId, 0, BinData),
            NewUpdateMap = maps:put(PoolId, Now, UpdateMap);
        true ->
            NewUpdateMap = UpdateMap
    end,
    {ZoneData#zone_data{score_list = NewScoreList, hurt_list = NewHurtList, role_score_map = NewRoleScoreMap, sea_mon = NewMonList}, NewUpdateMap}.

update_camp_score_info(CampInfo, HurtAdd, AtterServerId, AtterServerNum, AtterGuildId, AtterRoleId, AtterName, Scene, Monid, Hurt, Hp, UpdateMap, PoolId, ZoneMap, Camp) ->
    #camp_info{score_list = ScoreList, role_score_map = RoleScoreMap, hurt_list = HurtList, camp_mon = MonList} = CampInfo,
    
    NewMonList = case lists:keyfind(Monid, 1, MonList) of
        {Monid, _, HpMax, IsbeLimitAtt, NextMon} ->
            lists:keystore(Monid, 1, MonList, {Monid, Hp, HpMax, IsbeLimitAtt, NextMon});
        _ ->
            MonList
    end,

    {NewScoreList, NewRoleScoreMap, _, _} = calc_new_score_info(ScoreList, RoleScoreMap, AtterServerId, 
            AtterServerNum, AtterGuildId, AtterRoleId, AtterName, HurtAdd),

    case data_seacraft:get_mon_info(Monid, Scene) of
        #base_seacraft_construction{list = List} -> 
            if
                List == [] -> %% 神像
                    NewHurtList = case lists:keyfind(AtterGuildId, 1, HurtList) of
                        {_, OHurt} -> 
                            lists:keystore(AtterGuildId, 1, HurtList, {AtterGuildId, Hurt+OHurt});
                        _ ->
                            lists:keystore(AtterGuildId, 1, HurtList, {AtterGuildId, Hurt})
                    end;
                true ->
                    NewHurtList = HurtList
            end;
        _ -> 
            NewHurtList = HurtList
    end,
    Now = utime:unixtime(),
    Time = maps:get(PoolId, UpdateMap, 0),
    case data_seacraft:get_value(role_score_change_time) of
        TimeCfg when is_integer(TimeCfg) -> TimeCfg;
        _ -> TimeCfg = 60
    end,
    if
        Now >= Time + TimeCfg ->
            update_zone_info(PoolId, ZoneMap, update_local_info, 
                    [{score_list, Camp, NewScoreList}, {role_score_map, Camp, NewRoleScoreMap}, {camp_mon, Camp, NewMonList}]),
            {ok, BinData} = pt_186:write(18609, [NewMonList]),
            lib_server_send:send_to_scene(Scene, PoolId, 0, BinData),
            NewUpdateMap = maps:put(PoolId, Now, UpdateMap);
        true ->
            NewUpdateMap = UpdateMap
    end,
    {CampInfo#camp_info{score_list = NewScoreList, role_score_map = NewRoleScoreMap, hurt_list = NewHurtList, camp_mon = NewMonList}, NewUpdateMap}.

calc_zone_map(ZoneMap, ServerInfo, ActInfoMap) ->
    MapList = maps:to_list(ZoneMap),
    OpenDayLimit = data_seacraft:get_value(open_day),
    Fun = fun({Zone, ServerIdList}, {AccMap, ActAccMap}) ->
        NewServerIdL = calc_zone_map_core(OpenDayLimit, ServerInfo, ServerIdList),
        NewActInfoMap =
            case maps:get(Zone, ActAccMap, []) of
                {_, _, _} when NewServerIdL == [] -> %% 修复数据用，一般情况下不会执行这里
                    Sql = io_lib:format(<<"DELETE FROM `seacraft_act` WHERE `id` = ~p">>, [Zone]),
                    db:execute(Sql),
                    maps:remove(Zone, ActAccMap);
                _ ->
                    ActAccMap
            end,
        % maps:put(Zone, NewServerIdL, AccMap)
        %% 上面的修复是针对之前没有判断NewServerIdL是否为空导致的异常
        NewAccMap = ?IF(NewServerIdL =/= [], maps:put(Zone, NewServerIdL, AccMap), AccMap),
        {NewAccMap, NewActInfoMap}
    end,
    lists:foldl(Fun, {#{}, ActInfoMap}, MapList).

calc_zone_map(ZoneMap, ServerInfo) ->
    MapList = maps:to_list(ZoneMap),
    OpenDayLimit = data_seacraft:get_value(open_day),
    Fun = fun({Zone, ServerIdList}, AccMap) ->
        NewServerIdL = calc_zone_map_core(OpenDayLimit, ServerInfo, ServerIdList),
        % maps:put(Zone, NewServerIdL, AccMap)
        ?IF(NewServerIdL =/= [], maps:put(Zone, NewServerIdL, AccMap), AccMap)
    end,
    lists:foldl(Fun, #{}, MapList).

calc_zone_map_core(OpenDayLimit, ServerInfo, ServerIdList) ->
    F = fun(ServerId) ->
        case lists:keyfind(ServerId, 1, ServerInfo) of
            {_ServerId, Optime, _WorldLv, _ServerNum, _ServerName} ->
                OpenDay = lib_c_sanctuary_mod:get_open_day(Optime),
                OpenDay >= OpenDayLimit;
            _ ->
                false
        end
    end,
    lists:filter(F, ServerIdList).

calc_camp_map() ->
    calc_camp_map(#{}).

calc_camp_map(CampMap) ->
    GuildDbList = db:get_all(?SELECT_SEA_GUILD),
    SeaCampDbList = db:get_all(?SELECT_SEA_CAMP),
    JobDbList = db:get_all(?SELECT_SEA_JOB),
    ApplyDbList = db:get_all(?SELECT_SEA_APPLY),
    Fun1 = fun([Zone, Camp, ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, Num, RoleLv, Power, Picture, PictureVer], {AccMap, AccMap2}) ->
        CampInfo = maps:get({Zone, Camp}, AccMap, #camp_info{}),
        #camp_info{guild_map = GuildMap, member_list = MemberList} = CampInfo,
        List = maps:get(ServerId, GuildMap, []),
        ArgList = [ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, Num, RoleLv, Power, Picture, PictureVer],
        SeaGuildMember = lib_seacraft:make_record(sea_guild, ArgList),
        NewList = lists:keystore(GuildId, #sea_guild.guild_id, List, SeaGuildMember),
        NewGuildMap = maps:put(ServerId, NewList, GuildMap),

        GuildCampList = maps:get(ServerId, AccMap2, []),
        NewGuildCampList = lists:keystore(GuildId, 1, GuildCampList, {GuildId, Camp}),
        NewAccMap2 = maps:put(ServerId, NewGuildCampList, AccMap2),
        %% 2.0 加载成员信息
        FMList = db:get_all(io_lib:format(?SELECT_SEA_MEMBER_INFO, [Zone, ServerId, GuildId])),
        SMList = [lib_seacraft_extra:make_record(camp_member_info, {ServerId,GuildId,GuildName,Vip,RId,RName,Lv,JobId,Exploit,RPower})
            ||[Vip,RId,RName,Lv,JobId,Exploit,RPower]<-FMList],
        {maps:put({Zone, Camp}, CampInfo#camp_info{guild_map = NewGuildMap, member_list = MemberList ++ SMList}, AccMap), NewAccMap2}
    end,
    {CampMap1Tmp, GuildCampMap} = lists:foldl(Fun1, {CampMap, #{}}, GuildDbList),
    CampMap1 = lib_seacraft_extra:sort_camp_map_member(CampMap1Tmp),
    Fun2 = fun([Zone, Camp, JoinLimitDb, MasterDb, WinReward], AccMap) ->
        CampInfo = maps:get({Zone, Camp}, AccMap, #camp_info{}),
        JoinLimit = util:bitstring_to_term(JoinLimitDb),
        Master = util:bitstring_to_term(MasterDb),
        maps:put({Zone, Camp}, CampInfo#camp_info{join_limit = JoinLimit, camp_master = Master, win_reward = util:bitstring_to_term(WinReward)}, AccMap)
    end,
    CampMap2 = lists:foldl(Fun2, CampMap1, SeaCampDbList),

    Fun3 = fun([Zone, Camp, ServerId, ServerNum, RolePower, RoleId, RoleName, RoleLv, JobId, Picture, PictureVer], AccMap) ->
        CampInfo = maps:get({Zone, Camp}, AccMap, #camp_info{}),
        #camp_info{job_list = JobList} = CampInfo,
        JobArgList = [ServerId, ServerNum, RoleId, RoleName, RoleLv, JobId, RolePower, Picture, PictureVer],
        JobMember = lib_seacraft:make_record(sea_job, JobArgList),
        NewList = lists:keystore(RoleId, #sea_job.role_id, JobList, JobMember),
        maps:put({Zone, Camp}, CampInfo#camp_info{job_list = NewList}, AccMap)
    end,
    CampMap3 = lists:foldl(Fun3, CampMap2, JobDbList),

    Fun4 = fun([Zone, Camp, ServerId, ServerNum, RolePower, RoleId, RoleName, RoleLv, Picture, PictureVer], AccMap) ->
        CampInfo = maps:get({Zone, Camp}, AccMap, #camp_info{}),
        #camp_info{application_list = ApplyList} = CampInfo,
        ApplyArgList = [ServerId, ServerNum, Picture, PictureVer, RoleLv, RoleId, RoleName, RolePower],
        ApplyMember = lib_seacraft:make_record(sea_apply, ApplyArgList),
        NewList = lists:keystore(RoleId, #sea_apply.role_id, ApplyList, ApplyMember),
        maps:put({Zone, Camp}, CampInfo#camp_info{application_list = NewList}, AccMap)
    end,
    CampMap4 = lists:foldl(Fun4, CampMap3, ApplyDbList),
    CampMap5 =
        maps:map(
            fun({Zone, Camp}, CampInfo) ->
                %% 2.0 加载特权信息
                PrivilegeStatus = lib_seacraft_extra:load_privilege_status(Zone, Camp),
                CampInfo#camp_info{privilege_status = PrivilegeStatus}
            end
        ,CampMap4),
    {CampMap5, GuildCampMap}.

handle_guild_map_merge(GuildMap, MergeSerIds, ServerId, ServerNum) ->
    Fun = fun
        (SerId, Acc) when SerId =/= ServerId ->
            List = maps:get(SerId, Acc, []),
            OldList = maps:get(ServerId, Acc, []),
            NewList = [SeaGuildMember#sea_guild{server_id = ServerId, server_num = ServerNum} || 
                SeaGuildMember <- List, is_record(SeaGuildMember, sea_guild)],
            Map = maps:remove(SerId, Acc),
            maps:put(ServerId, OldList++NewList, Map);
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, GuildMap, MergeSerIds).

handle_job_list_merge(JobList, MergeSerIds, ServerId, ServerNum) ->
    Fun = fun(#sea_job{server_id = SerId} = OldJob, Acc) ->
        case lists:member(SerId, MergeSerIds) of
            true ->
                [OldJob#sea_job{server_id = ServerId, server_num = ServerNum}|Acc];
            _ ->
                [OldJob|Acc]
        end
    end,
    lists:foldl(Fun, [], JobList).

handle_apply_list_merge(ApplyList, MergeSerIds, ServerId, ServerNum) ->
    Fun = fun(#sea_apply{server_id = SerId} = ApplyMember, Acc) ->
        case lists:member(SerId, MergeSerIds) of
            true ->
                [ApplyMember#sea_apply{server_num = ServerNum, server_id = ServerId}|Acc];
            _ ->
                [ApplyMember|Acc]
        end
    end,
    lists:foldl(Fun, [], ApplyList).

%% {server_id, guild_id, guild_name, vip, role_id, role_name, lv, job_id, exploit, fright}
handle_member_list_merge(MemberList, MergeSerIds, ServerId, _Zone, _Camp) ->
    Fun = fun(MemberItem, Acc) ->
        case lists:member(MemberItem#camp_member_info.server_id, MergeSerIds) of
            true ->
                [MemberItem#camp_member_info{server_id = ServerId}|Acc];
            _ ->
                [MemberItem|Acc]
        end
          end,
    lists:reverse(lists:foldl(Fun, [], MemberList)).

sort_guild(GuildMap) ->
    List = maps:to_list(GuildMap),
    Fun = fun({_, Value}, Acc) ->
        Value++Acc
    end,
    UnsortList = lists:foldl(Fun, [], List),
    lists:reverse(lists:keysort(#sea_guild.guild_power, UnsortList)).

get_attacker_and_defender([#sea_guild{server_id = ServerId, guild_id = GuildId}|SortGuildList], Counter, Acc, Acc1) when Counter == 1 ->
    get_attacker_and_defender(SortGuildList, Counter+1, lists:keystore(?DEFENDER, 1, Acc, {?DEFENDER, [{ServerId, GuildId}]}),
        lists:keystore(GuildId, 1, Acc1, {GuildId, Counter}));
get_attacker_and_defender([#sea_guild{server_id = ServerId, guild_id = GuildId}|SortGuildList],Counter, Acc, Acc1) when Counter =< 4 ->
    {_, List} = ulists:keyfind(?ATTACKER, 1, Acc, {?ATTACKER, []}),
    NewList = lists:keystore(GuildId, 2, List, {ServerId, GuildId}),
    get_attacker_and_defender(SortGuildList, Counter+1, lists:keystore(?ATTACKER, 1, Acc, {?ATTACKER, NewList}), 
        lists:keystore(GuildId, 1, Acc1, {GuildId, Counter}));

get_attacker_and_defender([{_ServerId, _GuildId, _, Camp}|SortGuildList], Counter, Acc, Acc1) when Counter == 1 ->
    get_attacker_and_defender(SortGuildList, Counter+1, lists:keystore(?DEFENDER, 1, Acc, {?DEFENDER, [Camp]}),
        lists:keystore(Camp, 1, Acc1, {Camp, Counter}));
get_attacker_and_defender([{_ServerId, _GuildId, _, Camp}|SortGuildList], Counter, Acc, Acc1) when Counter =< 4 ->
    {_, List} = ulists:keyfind(?ATTACKER, 1, Acc, {?ATTACKER, []}),
    NewAcc = lists:keystore(?ATTACKER, 1, Acc, {?ATTACKER, [Camp|lists:delete(Camp, List)]}),
    get_attacker_and_defender(SortGuildList, Counter+1, NewAcc, lists:keystore(Camp, 1, Acc1, {Camp, Counter}));
get_attacker_and_defender(_, _, Acc, Acc1)-> {Acc, Acc1}.


get_master_info(_Camp, #camp_info{camp_master = []}) -> 0;
get_master_info(Camp, #camp_info{guild_map = GuildMap, camp_master = [{ServerId, GuildId}|_]}) ->
    List = maps:get(ServerId, GuildMap, []),
    case lists:keyfind(GuildId, #sea_guild.guild_id, List) of
        #sea_guild{server_id = ServerId, guild_id = GuildId, guild_power = GuildPower} ->
            {ServerId, GuildId, GuildPower, Camp};
        _ ->
            0
    end.

update_zone_info(ZoneId, ZoneMap, Fun, Args) ->
    ServerIdList = maps:get(ZoneId, ZoneMap, []),
    [mod_clusters_center:apply_cast(ServerId, mod_seacraft_local, Fun, [Args]) || ServerId <- ServerIdList].

calc_new_score_info(ScoreList, RoleScoreMap, AtterServerId, AtterServerNum, AtterGuildId, AtterRoleId, AtterName, HurtAdd) ->
    calc_new_score_info(ScoreList, RoleScoreMap, AtterServerId, AtterServerNum, AtterGuildId, AtterRoleId, AtterName, HurtAdd, ok).

calc_new_score_info(ScoreList, RoleScoreMap, AtterServerId, AtterServerNum, AtterGuildId, AtterRoleId, AtterName, HurtAdd, Type) ->
    NowTime = utime:unixtime(),
    NewScoreList = case lists:keyfind(AtterGuildId, 2, ScoreList) of
        {_, _, Score, _} -> 
            lists:keystore(AtterGuildId, 2, ScoreList, {AtterServerId, AtterGuildId, Score+HurtAdd, NowTime});
        _ ->
            Score = 0,
            lists:keystore(AtterGuildId, 2, ScoreList, {AtterServerId, AtterGuildId, HurtAdd, NowTime})
    end,
    UpScoreList = [{AtterServerId, AtterGuildId, Score+HurtAdd, NowTime}],
    RoleScoreList = maps:get({AtterServerId, AtterGuildId}, RoleScoreMap, []),
    NewRoleScoreList = case lists:keyfind(AtterRoleId, #sea_score.role_id, RoleScoreList) of
        #sea_score{kill_num = KillNum, score = TemScore} = OldSeaScoreMember -> 
            NewKillNum = ?IF(Type == kill, KillNum+1, KillNum),
            ScoreMember = OldSeaScoreMember#sea_score{kill_num = NewKillNum, score = TemScore+HurtAdd, time = NowTime},
            lists:keystore(AtterRoleId, #sea_score.role_id, RoleScoreList, ScoreMember);
        _ ->
            NewKillNum = ?IF(Type == kill, 1, 0),
            ScoreArgList = [AtterServerId, AtterServerNum, AtterRoleId, AtterName, NewKillNum, HurtAdd, NowTime],
            ScoreMember = lib_seacraft:make_record(sea_score, ScoreArgList),
            lists:keystore(AtterRoleId, #sea_score.role_id, RoleScoreList, ScoreMember)
    end,
    NewRoleScoreMap = maps:put({AtterServerId, AtterGuildId}, NewRoleScoreList, RoleScoreMap),
    UpRoleList = [{{AtterServerId, AtterGuildId}, ScoreMember}],
    {NewScoreList, NewRoleScoreMap, UpScoreList, UpRoleList}.

calc_new_score_info_zone(ScoreList, RoleScoreMap, AtterServerId, AtterServerNum, AtterGuildId, AtterRoleId, AtterName, HurtAdd, Camp) ->
    calc_new_score_info_zone(ScoreList, RoleScoreMap, AtterServerId, AtterServerNum, AtterGuildId, AtterRoleId, AtterName, HurtAdd, Camp, ok).

calc_new_score_info_zone(ScoreList, RoleScoreMap, AtterServerId, AtterServerNum, _AtterGuildId, AtterRoleId, AtterName, HurtAdd, Camp, Type) ->
    NowTime = utime:unixtime(),
    NewScoreList = case lists:keyfind(Camp, 1, ScoreList) of
        {_, Score, _} -> 
            lists:keystore(Camp, 1, ScoreList, {Camp, Score+HurtAdd, NowTime});
        _ ->
            Score = 0,
            lists:keystore(Camp, 1, ScoreList, {Camp, HurtAdd, NowTime})
    end,
    UpScoreList = [{Camp, Score+HurtAdd, NowTime}],
    RoleScoreList = maps:get(Camp, RoleScoreMap, []),
    NewRoleScoreList = case lists:keyfind(AtterRoleId, #sea_score.role_id, RoleScoreList) of
        #sea_score{kill_num = KillNum, score = TemScore} = OldSeaScoreMember -> 
            NewKillNum = ?IF(Type == kill, KillNum+1, KillNum),
            ScoreMember = OldSeaScoreMember#sea_score{kill_num = NewKillNum, score = TemScore+HurtAdd, time = NowTime},
            lists:keystore(AtterRoleId, #sea_score.role_id, RoleScoreList, ScoreMember);
        _ ->
            NewKillNum = ?IF(Type == kill, 1, 0),
            ScoreArgList = [AtterServerId, AtterServerNum, AtterRoleId, AtterName, NewKillNum, HurtAdd, NowTime],
            ScoreMember = lib_seacraft:make_record(sea_score, ScoreArgList),
            lists:keystore(AtterRoleId, #sea_score.role_id, RoleScoreList, ScoreMember)
    end,
    NewRoleScoreMap = maps:put(Camp, NewRoleScoreList, RoleScoreMap),
    UpRoleList = [{Camp, ScoreMember}],
    {NewScoreList, NewRoleScoreMap, UpScoreList, UpRoleList}.

get_hid_list_info(PoolId, ZoneMap, JoinMap, HitIdList) ->
    ServerIdList = maps:get(PoolId, ZoneMap, []),
    JoinList = maps:to_list(JoinMap),
    Fun1 = fun({{SerId, _}, Value}, Acc) ->
        case lists:member(SerId, ServerIdList) of
            true ->
                F = fun(JoinMember, TemAcc) when is_record(JoinMember, join_member) ->
                    #join_member{role_id = RoleId, server_id = ServerId, 
                        server_num = _ServerNum, guild_id = GuildId, role_name = _RoleName} = JoinMember,
                    case lists:member(RoleId, HitIdList) of
                        true ->
                            [{ServerId, _ServerNum, GuildId, RoleId, _RoleName, hid}|TemAcc];
                        _ ->
                            TemAcc
                    end
                end,
                lists:foldl(F, Acc, Value);
            _ ->
                Acc
        end
    end,
    lists:foldl(Fun1, [], JoinList).

calc_new_job_list(ZoneId, Camp, OldMasterGuildId, MasterSerId, MasterGuildId, GuildMap, JobList, JoinMap, AttDefList) ->
    if
        MasterGuildId == 0 ->
            {JobList, []};
        OldMasterGuildId == MasterGuildId ->
            {JobList, []};
        true ->
            GuildList = maps:get(MasterSerId, GuildMap, []),
            case lists:keyfind(MasterGuildId, #sea_guild.guild_id, GuildList) of
                #sea_guild{server_num = ServerNum, role_id = MasterRoleId, role_name = MasterRoleName,
                    role_lv = ORoleLv, combat_power = OPower, picture = OPicture, picture_ver = OPictureVer} ->  ok;
                _ ->
                    ?ERR("MasterSerId:~p, MasterGuildId:~p~n,GuildMap~p,AttDefList:~p~n",[MasterSerId, MasterGuildId, GuildMap, AttDefList]), 
                    ServerNum = 0, MasterRoleId = 0, MasterRoleName = "", ORoleLv = 0, OPower = 0, OPicture = "", OPictureVer = 0
            end,
            JoinList = maps:get({MasterSerId, MasterGuildId}, JoinMap, []),
            case lists:keyfind(MasterRoleId, #join_member.role_id, JoinList) of
                #join_member{role_lv = RoleLv, combat_power = Power, picture = Picture, picture_ver = PictureVer} -> ok;
                _ -> RoleLv = ORoleLv, Power = OPower, Picture = OPicture, PictureVer = OPictureVer
            end,
            Fun1 = fun
                (#sea_job{server_id = SerId, role_id = RId, role_name = RName, job_id = TemJobId}, Acc) ->
                    lib_log_api:log_seacraft_job(Camp, SerId, RId, RName, TemJobId, 0),
                    case lists:keyfind(SerId, 1, Acc) of
                        {SerId, List} -> NewList = lists:keystore(RId, 1, List, {RId, TemJobId});
                        _ -> NewList = [{RId, TemJobId}]
                    end,
                    lists:keystore(SerId, 1, Acc, {SerId, NewList});
                (_, Acc) -> Acc
            end,
            RemoveList = lists:foldl(Fun1, [], JobList),
            JobArgList = [MasterSerId, ServerNum, MasterRoleId, MasterRoleName, RoleLv, ?SEA_MASTER, Power, Picture, PictureVer],
            JobMember = lib_seacraft:make_record(sea_job, JobArgList),
            spawn(fun() ->
                Rand = urand:rand(10,200),
                timer:sleep(Rand),
                db:execute(io_lib:format(?DELETE_SEA_JOB, [ZoneId, Camp])),
                lib_seacraft:remove_role_dsgt(RemoveList),
                lib_seacraft:active_role_dsgt([{MasterSerId, [{MasterRoleId, ?SEA_MASTER}]}]),
                lib_log_api:log_seacraft_job(Camp, MasterSerId, MasterRoleId, MasterRoleName, 0, ?SEA_MASTER),
                lib_seacraft:update_sea_job_info(ZoneId, Camp, JobMember)
            end),
            NewList = [JobMember],
            {NewList, [delete|NewList]}
    end.
    
get_role_guild(ServerId, JoinMap, RoleId) ->
    List = maps:to_list(JoinMap),
    get_role_guild_helper(List, ServerId, RoleId).

get_role_guild_helper([], _, _) -> 0;
get_role_guild_helper([{{SerId, GuildId}, JoinList} | List], ServerId, RoleId) when SerId == ServerId ->
    case lists:keyfind(RoleId, #join_member.role_id, JoinList) of
        #join_member{} -> GuildId;
        _ -> 
            get_role_guild_helper(List, ServerId, RoleId)
    end;
get_role_guild_helper([_|T], ServerId, RoleId) ->
    get_role_guild_helper(T, ServerId, RoleId).

reset_act_core(Now, ZoneMap, GuildCampMap, CampInfo, ZoneData, ActInfoMap, StartTime, EndTime) ->
    ZoneList = maps:to_list(ZoneMap),
    {NextOpenTime, _} = lib_seacraft:calc_next_act_time(Now),
    IsSameDay1 = utime_logic:is_logic_same_day(Now, NextOpenTime-?ONE_DAY_SECONDS),
    Fun = fun
        ({ZoneId, Serverids}, Acc) ->
            {AccGCMap, AccCIMap, AccZDMap, AccAIMap} = Acc,
            {ActType, Num, IsReset} = maps:get(ZoneId, AccAIMap, {1, 0, 1}),
            {NewActType, NewNum} = lib_seacraft:calc_act_type(ActType, Num),
            % ?INFO("IsSameDay1:~p, ActType:~p, NewActType:~p, NewNum:~p, IsReset:~p, ZoneId:~p, Serverids:~p,NextOpenTime:~p~n",[IsSameDay1, ActType, NewActType, NewNum, IsReset, ZoneId, Serverids,NextOpenTime]),
            if
                IsSameDay1 == true andalso ActType =/= 0 andalso NewActType == ?ACT_TYPE_SEA_PART 
                andalso NewNum == 0 andalso IsReset == 0 -> %% 赛季重置
                    [mod_clusters_center:apply_cast(SerId, mod_seacraft_local, update_local_info, 
                        [[{act_info, StartTime, EndTime, {NewActType, NewNum}}]]) || SerId <- Serverids],
                    ?INFO("seacraft reset  NowTime:~p, NextOpenTime:~p, {ZoneId, Serverids}:~p~n",[Now, NextOpenTime, {ZoneId, Serverids}]),
                    db:execute(io_lib:format(?UPDATE_SEA_ACT, [1, ZoneId])),
                    {NewAccGCMap, NewAccCIMap, NewAccZDMap, NewAccAIMap} =
                        reset_act(IsSameDay1, ZoneId, Serverids, AccGCMap, AccCIMap, AccZDMap, AccAIMap),
                    {NewAccGCMap, NewAccCIMap, NewAccZDMap, NewAccAIMap};
                true ->
                    CampList = data_seacraft:get_all_camp(),
                    KeyList = [{ZoneId, Camp} || Camp <- CampList],
                    Fun = fun(Key, {AccMap, Val}) ->
                        case maps:get(Key, AccMap, []) of
                            [] ->
                                {maps:put(Key, Val, AccMap), Val};
                            _ ->
                                {AccMap, Val}
                        end
                    end,
                    {NewAccCIMap, _} = lists:foldl(Fun, {AccCIMap, #camp_info{}}, KeyList),
                    [mod_clusters_center:apply_cast(SerId, mod_seacraft_local, update_local_info, 
                        [[{act_info, StartTime, EndTime, {ActType, Num}}]]) || SerId <- Serverids],
                    {AccGCMap, NewAccCIMap, AccZDMap, AccAIMap}
            end;
        (_, Acc) -> Acc
    end,
    {GuildCampMap1, CampInfo1, ZoneData1, ActInfoMap1} = 
        lists:foldl(Fun, {GuildCampMap, CampInfo, ZoneData, ActInfoMap}, ZoneList),
    {cal_guild_camp(CampInfo1, GuildCampMap1), CampInfo1, ZoneData1, ActInfoMap1}.


reset_act(true, ZoneId, Serverids, GuildCampMap, CampInfo, ZoneData, ActInfoMap) ->
    F_del = fun() ->
        db:execute(io_lib:format(?DELETE_SEA_GUILD_ZONE, [ZoneId])),
        db:execute(io_lib:format(?DELETE_SEA_CAMP_ZONE, [ZoneId])),
        db:execute(io_lib:format(?DELETE_SEA_JOB_ZONE, [ZoneId])),
        db:execute(io_lib:format(?DELETE_SEA_APPY_ZONE, [ZoneId])),
        db:execute(io_lib:format(?DELETE_SEA_INFO_ZONE, [ZoneId])),
        % db:execute(io_lib:format(?DELETE_SEA_MEMBER_ZONE, [ZoneId])),

        [db:execute(io_lib:format(?DELETE_SEA_MEMBER_ZONE_SERVER, [ZoneId, Serverid]))||Serverid <- Serverids],
	
        db:execute(io_lib:format(?REPLACE_SEA_ACT, [ZoneId, 1, 0, 1])),
	ok
            end,
    case lib_goods_util:transaction(F_del) of
        ok -> skip;
        _Error ->
            ?ERR("seacraft_reset_act error: ~p ~n", [_Error])
    end,
    NewGuildCampMap = maps:without(Serverids, GuildCampMap),
    CampList = data_seacraft:get_all_camp(),
    KeyList = [{ZoneId, Camp} || Camp <- CampList],
    Fun = fun(Key, {AccMap, Val}) ->
        {maps:put(Key, Val, AccMap), Val}
    end,
    {NewCampInfo, _} = lists:foldl(Fun, {CampInfo, #camp_info{}}, KeyList),
    % NewCampInfo = maps:without(KeyList, CampInfo),
    NewZoneData = maps:put(ZoneId, #zone_data{}, ZoneData),
    ?INFO("Serverids:~p~n",[Serverids]),
    [mod_clusters_center:apply_cast(SerId, mod_seacraft_local, reset_act, []) || SerId <- Serverids],
    %% 活动进度重置
    {NewGuildCampMap, NewCampInfo, NewZoneData, maps:put(ZoneId, {1, 0, 1}, ActInfoMap)};
reset_act(_, _ZoneId, _Serverids, GuildCampMap, CampInfo, ZoneData, ActInfoMap) ->
    {GuildCampMap, CampInfo, ZoneData, ActInfoMap}.

% reset_act(true, State) ->
%     db:execute(?TRUNCATE_SEA_GUILD),
%     db:execute(?TRUNCATE_SEA_CAMP),
%     db:execute(?TRUNCATE_SEA_JOB),
%     db:execute(?TRUNCATE_SEA_APPLY),
%     db:execute(?TRUNCATE_SEA_INFO),
%     db:execute(?TRUNCATE_SEA_ACT),
%     mod_clusters_center:apply_to_all_node(mod_seacraft_local, reset_act, []),
%     State#kf_seacraft_state{
%         guild_camp = #{}
%         ,camp_map = #{}
%         ,zone_data = #{}
%         ,join_map = #{}
%         ,update_time = #{}};
% reset_act(_, State) -> State.

calc_dsgt_list(ServerId, AccList, RoleId, JobId) ->
    case lists:keyfind(ServerId, 1, AccList) of
        {_, List} -> NewList = lists:keystore(RoleId, 1, List, {RoleId, JobId});
        _ -> NewList = [{RoleId, JobId}]
    end,
    lists:keystore(ServerId, 1, AccList, {ServerId, NewList}).

divide_guild_camp(CampMap, Tuple) ->
    {ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, RoleLv, Power, Picture, PictureVer} = Tuple,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CampList = case data_seacraft:get_all_camp() of
                    List when is_list(List) -> List;
                    _ -> []
               end, 
    CampInfoList = [{{ZoneId, Camp}, maps:get({ZoneId, Camp}, CampMap, #camp_info{})}|| Camp <- CampList],
    Fun = fun({{_, Camp}, #camp_info{guild_map = TemMap}}, {TemC, Num}) ->
        TemList = maps:values(TemMap),
        F1 = fun(GuildList, AccSum) ->
            erlang:length(GuildList)+AccSum
        end,
        Sum = lists:foldl(F1, 0, TemList),
        if
            Sum =< Num orelse TemC == 0 ->
                {Camp, Sum};
            true ->
                {TemC, Num}
        end
    end,
    {JoinCamp, _} = lists:foldl(Fun, {0,0}, CampInfoList),
    CampInfo = maps:get({ZoneId, JoinCamp}, CampMap, #camp_info{}),
    #camp_info{guild_map = GuildMap} = CampInfo,
    GuildList = maps:get(ServerId, GuildMap, []),
    ArgList = [ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, RoleLv, Power, Picture, PictureVer],
    SeaGuildMember = lib_seacraft:make_record(sea_guild, ArgList),
    NewGuildList = lists:keystore(GuildId, #sea_guild.guild_id, GuildList, SeaGuildMember),
    NewGuildMap = maps:put(ServerId, NewGuildList, GuildMap),
    NewCampMap = maps:put({ZoneId, JoinCamp}, CampInfo#camp_info{guild_map = NewGuildMap}, CampMap),
    {NewCampMap, JoinCamp}.

divide_battle_list(ZoneMap, CampMap, ZoneDataMap, ActInfoMap) ->
    ZoneList = maps:to_list(ZoneMap),
    Fun = fun
        ({ZoneId, _Serverids}, {AccMap1, AccMap2}) ->
            {ActType, _Num, _} = maps:get(ZoneId, ActInfoMap, {1, 0, 1}),
            if
                ActType == ?ACT_TYPE_SEA_PART ->
                    CampList = maps:to_list(AccMap1),
                    Fun1 = fun({{Zone, Camp}, Value}, Map) when ZoneId == Zone andalso is_record(Value, camp_info) ->
                            #camp_info{guild_map = GuildMap, camp_master = Master} = Value,
                            SortGuildList1 = sort_guild(GuildMap),
                            case Master of
                                [{MasterSerId, MasterGuildId}|_] when MasterGuildId =/= 0 andalso MasterSerId =/= 0 -> 
                                    SortGuildList = lists:keydelete(MasterGuildId, #sea_guild.guild_id, SortGuildList1),
                                    FirstDivideAtt = [{?DEFENDER, [{MasterSerId, MasterGuildId}]}],
                                    FirstDividePoint = [{MasterGuildId, 1}], Counter = 2;
                                _ ->
                                    SortGuildList = SortGuildList1,
                                    FirstDivideAtt = [], FirstDividePoint = [], Counter = 1
                            end,
                            {AttDefend, DividePoint} = get_attacker_and_defender(SortGuildList, Counter, FirstDivideAtt, FirstDividePoint),
                            update_zone_info(Zone, ZoneMap, update_local_info, [{divide_point, Camp, DividePoint},{att_def, Camp, AttDefend}]),
                            maps:put({Zone, Camp}, Value#camp_info{att_def = AttDefend, divide_point = DividePoint}, Map);
                        (_, Map) -> Map
                    end,
                    NewAccMap1 = lists:foldl(Fun1, AccMap1, CampList),
                    {NewAccMap1, AccMap2};
                    % State#kf_seacraft_state{camp_map = NewCampMap};
                true ->
                    ZoneData = maps:get(ZoneId, AccMap2, #zone_data{}),
                    #zone_data{sea_master = Master} = ZoneData,
                    CampList = maps:to_list(AccMap1),
                    F = fun({{ZId, Camp}, Value}, Acc) when ZId == ZoneId andalso is_record(Value, camp_info) ->
                            case get_master_info(Camp, Value) of
                                {_SerId, _GId, _Power, _Camp} ->
                                    [{_SerId, _GId, _Power, _Camp}|Acc];
                                _ -> 
                                    Acc
                            end;
                        (_, Acc) -> Acc
                    end,
                    MasterInfo = lists:foldl(F, [], CampList),
                    SortGuildList1 = lists:reverse(lists:keysort(3, MasterInfo)),
                    case Master of
                        {MasterCamp, _} when MasterCamp =/= 0 -> 
                            SortGuildList = lists:keydelete(MasterCamp, 4, SortGuildList1),
                            FirstDivideAtt = [{?DEFENDER, [MasterCamp]}],
                            FirstDividePoint = [{MasterCamp, 1}], Counter = 2;
                        _ ->
                            SortGuildList = SortGuildList1,
                            FirstDivideAtt = [], FirstDividePoint = [], Counter = 1
                    end,
                    {AttDefend, DividePoint} = get_attacker_and_defender(SortGuildList, Counter, FirstDivideAtt, FirstDividePoint),
                    update_zone_info(ZoneId, ZoneMap, update_local_zone_data, [{divide_point, DividePoint},{att_def, AttDefend}]),
                    NewAccMap2 = maps:put(ZoneId, ZoneData#zone_data{att_def = AttDefend, divide_point = DividePoint}, AccMap2),
                    {AccMap1, NewAccMap2}
            end
    end,
    lists:foldl(Fun, {CampMap, ZoneDataMap}, ZoneList).

calc_auction_produce(RoleScoreMap, AttDefList, ActType, Wlv, EndTime) ->
    case data_seacraft:get_auction_produce(ActType, Wlv) of
        #base_seacraft_auction{
            win_gproduce = WinGProduce, 
            win_gworth = WinGWorth, 
            win_bgproduce = WinBGProduce, 
            win_bgworth = WinBGWorth, 
            fail_gproduce = FailGProduce, 
            fail_gworth = FailGWorth, 
            fail_bgproduce = FailBGProduce, 
            fail_bgworth = FailBGWorth} ->
            AuctionStartTime
            = case data_seacraft:get_value(auction_start_time) of
                AddTime when is_integer(AddTime) -> AddTime+EndTime;
                _ -> EndTime + 1800
            end,
            Fun = fun({AttType, CampList}, {Acc1, Acc2}) ->
                if
                    AttType == ?DEFENDER ->
                        NormalProduce = calc_normal_produce(ActType, Wlv, win),
                        Produce = WinGProduce,
                        Worth = WinGWorth,
                        BProduce = WinBGProduce,
                        BWorth = WinBGWorth;
                    true ->
                        NormalProduce = calc_normal_produce(ActType, Wlv, fail),
                        Produce = FailGProduce,
                        Worth = FailGWorth,
                        BProduce = FailBGProduce,
                        BWorth = FailBGWorth
                end,
                Sum = lib_c_sanctuary_mod:calc_all_weight(Produce, 0),
                BSum = lib_c_sanctuary_mod:calc_all_weight(BProduce, 0),
                GoldProduceList = lib_c_sanctuary_mod:calc_produce_num(Produce, Sum, Worth),
                BGoldProduceList = lib_c_sanctuary_mod:calc_produce_num(BProduce, BSum, BWorth),
                % ?MYLOG("xlh","{AttType, Wlv}:~p,GoldProduceList:~p,BGoldProduceList:~p~n",[{AttType, Wlv}, GoldProduceList, BGoldProduceList]),
                % {GoldProduceList, BGoldProduceList};
                ?PRINT("NormalProduce:~p~n",[NormalProduce]),
                AuctionList = [{AuctionId, Num, Wlv} || {AuctionId, Num}<-  NormalProduce ++ GoldProduceList++BGoldProduceList],
                get_auction_produce_list(CampList, RoleScoreMap, AuctionList, {Acc1, Acc2})
            end,
            {BonusRoleList, AuctionList} = lists:foldl(Fun, {[], []}, AttDefList),
            {AuctionStartTime, BonusRoleList, AuctionList};
        _E ->
            []
    end.

get_auction_produce_list([], _, _, {Acc1, Acc2}) -> {Acc1, Acc2};
get_auction_produce_list([Camp|CampList], RoleScoreMap, AuctionList, {Acc1, Acc2}) ->
    RoleScoreList = maps:get(Camp, RoleScoreMap, []),
    BonusRoleList = [{AtterRoleId, Camp, AtterServerId} || #sea_score{server_id = AtterServerId, role_id = AtterRoleId} <- RoleScoreList],
    get_auction_produce_list(CampList, RoleScoreMap, AuctionList, {BonusRoleList++Acc1, lists:keystore(Camp, 1, Acc2, {Camp, AuctionList})}).

calc_normal_produce(ActType, Wlv, WinOrFail) when WinOrFail == win orelse WinOrFail == fail ->
    case data_seacraft:get_act_reward(ActType) of
        #base_seacraft_reward{auction_reward = Normal} ->
            {_, Cfg} = ulists:keyfind(WinOrFail, 1, Normal, {WinOrFail, []}),
            Fun = fun({WlvMin, WlvMax, AuctionId, Num}, Acc) ->
                if
                    Wlv >= WlvMin andalso Wlv =< WlvMax ->
                        [{AuctionId, Num}|Acc];
                    true ->
                        Acc
                end
            end,
            lists:foldl(Fun, [], Cfg);
        _ ->
            []
    end;
calc_normal_produce(_ActType, _Wlv, _) -> [].

cal_guild_camp(CampMap, GuildCampMap) ->
    List = maps:to_list(CampMap),
    Fun = fun({{_ZoneId, Camp}, #camp_info{guild_map = GuildMap}}, Acc) ->
        SerGuildList = maps:to_list(GuildMap),
        F1 = fun({SerId, GuildList}, Acc1) ->
            GuildCampList = maps:get(SerId, Acc1, []),
            F2 = fun(#sea_guild{guild_id = GuildId}, Acc2) ->
                lists:keystore(GuildId, 1, Acc2, {GuildId, Camp})
            end,
            NewGuildCampList = lists:foldl(F2, GuildCampList, GuildList),
            maps:put(SerId, NewGuildCampList, Acc1)
        end,
        lists:foldl(F1, Acc, SerGuildList);
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, GuildCampMap, List).
