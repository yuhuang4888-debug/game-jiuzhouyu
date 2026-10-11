%%%-----------------------------------
%%% @Module      : lib_c_sanctuary_mod 跨服圣域
%%% @Author      : xlh
%%% @Email       : 1593315047@qq.com
%%% @Created     : 2018
%%% @Description : 跨服圣域进程数据管理
%%%-----------------------------------
-module(lib_c_sanctuary_mod).

-include("cluster_sanctuary.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("predefine.hrl").

-export([
        calc_battle_info/1
        ,init/0
        ,enter/6
        ,midnight_update/3
        ,send_rank/6
        ,mon_create/2
        ,mon_be_killed/10
        ,mon_hurt/10
        ,role_anger_clear/1
        ,get_info/4
        ,get_construction_info/5
        ,get_rank_info/6
        ,update_add_zone/3
        ,exit/4
        ,reconect/5
        ,recieve_bl_reward/5
        ,get_mon_pk_log/6
        ,mon_create_peace/4
        ,act_start/1
        ,act_end/1
        ,init_after/5
        ,server_info_chage/3
        ,gm_start_act/1
        ,get_act_opentime/3
        ,clear_scene_role/4
        ,tipes_act_end/2
        ,gm_start_ref/1
        ,gm_start_anger_ref/1
        ,gm_set_calc_battle_time/1
        ,local_init/2
        ,clear_user_mon_create/4
        ,gm_refresh_data/1
        ,gm_refresh_data/2
        ,gm_refresh_data/3
        ,zone_change/4
        ,center_connected/7
        ,kill_player/8
        ,gm_add_point/4
        ,calc_produce_num/3
        ,calc_all_weight/2
        ,clear_camp_record/1
        ,gm_clear_user/2
    ]).

-export([
        calc_mon_reborn_time/1,
        calc_can_enter/3,
        get_open_day/1,
        calc_produce_for_auction/14
    ]).

%% 暂时屏蔽圣域拍卖，函数暂时导出
-export([
        calc_extra_produce/2
        ,calc_real_role_list/6
        ,handle_servers/3
        ,handle_servers/4
        ,hand_san_server/3
    ]).

init() ->
    %% 从跨服中心拿各区/服的数据
    mod_zone_mgr:sanctuary_kf_init(),
    #c_sanctuary_state{
        zone_map = #{}
        ,server_info = []
        ,battle_map = #{}
        ,calc_battle_time = 0
        ,calc_battle_ref = undefined
        ,san_state = #{}
        ,mon_reborn_ref = undefined
        ,reborn_time = 0
        ,role_anger_ref = undefined
        ,begin_scene_map = #{}
        ,join_map = #{}
        ,act_start_ref = undefined      
        ,act_end_ref = undefined
        ,act_start_time = 0
        ,act_end_time = 0
    }.

%% -----------------------------------------------------------------
%% 秘籍开启
%% -----------------------------------------------------------------
gm_start_ref(State) ->
    #c_sanctuary_state{mon_reborn_ref = OldRef} = State,
    util:cancel_timer(OldRef),
    MonRef = erlang:send_after(1000, self(), {'mon_create', timer}),
    State#c_sanctuary_state{mon_reborn_ref = MonRef}.

%% -----------------------------------------------------------------
%% 秘籍清理怒气
%% -----------------------------------------------------------------
gm_start_anger_ref(State) ->
    #c_sanctuary_state{role_anger_ref = OldRef} = State,
    util:cancel_timer(OldRef),
    Ref = erlang:send_after(1000, self(), 'role_anger_clear'),
    State#c_sanctuary_state{role_anger_ref = Ref}.

%% -----------------------------------------------------------------
%% 秘籍开启
%% -----------------------------------------------------------------
gm_set_calc_battle_time(State) ->
    NowDate = utime:unixdate(),
    NewState = gm_start_act(State#c_sanctuary_state{calc_battle_time = NowDate}),
    NewState.

%% -----------------------------------------------------------------
%% 秘籍开启
%% -----------------------------------------------------------------
gm_start_act(State) ->
    #c_sanctuary_state{
        mon_reborn_ref = OldRef, 
        act_start_ref = OStartref, 
        act_end_ref = OEndtref} = State,
    NowTime = utime:unixtime(),
    NowDate = utime:unixdate(NowTime),
    %% 计算开始结束时间
    {BeginTime, EndTime} =lib_c_sanctuary:calc_act_opentime(NowDate),
    util:cancel_timer(OStartref),
    util:cancel_timer(OEndtref),
    %% 矫正活动开始结束时间
    if
        NowTime >= BeginTime andalso NowTime < EndTime-> %% 活动时间范围内
            _RBeginTime = BeginTime,REndTime = EndTime;
        true -> %% 活动范围时间外，使用前一天活动时间
            {_RBeginTime, REndTime} =lib_c_sanctuary:calc_act_opentime(NowDate-86400)
    end,
    RBeginTime = NowTime,
    util:cancel_timer(OldRef),
    Et = max(0, REndTime-NowTime),
    if
        Et == 0 ->
            ?ERR("gm_start_act KF SANCTUARY REndTime:~p NowTime:~p~n",[REndTime, REndTime]);
        true ->
            skip
    end,
    ClearTime = calc_role_clear_time(NowTime),
    ClearRef = erlang:send_after(max((ClearTime-NowTime)*1000, 1000), self(), 'role_anger_clear'),
    Endtref = erlang:send_after(Et*1000, self(), act_end),
    Ref = erlang:send_after(500, self(), 'calc_battle_info'),
    MonRef = erlang:send_after(1000, self(), {'mon_create', gm}),
    mod_clusters_center:apply_to_all_node(lib_c_sanctuary_api,notify_client_act_time,[RBeginTime, REndTime]),
    State#c_sanctuary_state{
        mon_reborn_ref = MonRef 
        ,reborn_time = NowTime
        ,act_start_ref = undefined      
        ,act_end_ref = Endtref
        ,role_anger_ref = ClearRef
        ,calc_battle_time = 0
        ,calc_battle_ref = Ref
        ,act_start_time = RBeginTime
        ,act_end_time = REndTime}.

%% -----------------------------------------------------------------
%% 刷新本地进程数据
%% -----------------------------------------------------------------
gm_refresh_data(ZoneId, State) ->
    #c_sanctuary_state{
        zone_map = ZoneMap, 
        server_info = ServersInfo, 
        battle_map = OldMap, 
        begin_scene_map = OldDivideMap,
        san_state = _SanState} = State,
    DivideScene =  maps:get(ZoneId, OldDivideMap, []),
    update_local_data(ZoneMap, OldMap, ZoneId, server, [ServersInfo, DivideScene]),
    State.

%% -----------------------------------------------------------------
%% 刷新本地进程数据
%% -----------------------------------------------------------------
gm_refresh_data(ZoneId, _ServerId, State) ->
    #c_sanctuary_state{ 
        zone_map = ZoneMap,
        server_info = ServersInfo, 
        battle_map = OldMap, 
        begin_scene_map = OldDivideMap,
        san_state = _SanState} = State,
    DivideScene =  maps:get(ZoneId, OldDivideMap, []),
    update_local_data(ZoneMap, OldMap, ZoneId, server, [ServersInfo, DivideScene]),
    State.

%% -----------------------------------------------------------------
%% 刷新本地进程数据
%% -----------------------------------------------------------------
gm_refresh_data(State) ->
    #c_sanctuary_state{ 
        zone_map = ZoneMap,
        server_info = ServersInfo, 
        battle_map = OldMap,
        act_start_time = StartTime,
        act_end_time = EndTime,
        begin_scene_map = OldDivideMap,
        san_state = _SanState} = State,
    DivideList = maps:to_list(OldDivideMap),
    update_local_data(ZoneMap, OldMap, time, [StartTime, EndTime]),
    Fun = fun({ZoneId, DivideScene}) ->
        update_local_data(ZoneMap, OldMap, ZoneId, server, [ServersInfo, DivideScene])
    end,
    lists:foreach(Fun, DivideList),
    State.

%% -----------------------------------------------------------------
%% 秘籍增加玩家贡献值
%% -----------------------------------------------------------------
gm_add_point(State, ServerId, Scene, Point) ->
    #c_sanctuary_state{ 
        zone_map = ZoneMap,
        battle_map = BattleMap,
        battle_zone = BatZoneMap, 
        san_state = SanState} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {Santype, [H|_]} = get_server_santype(ServerId, BattleMap, ZoneId),
    case get_scene_info(ZoneId, H, Santype, Scene, SanState) of
        {true, SanList, San, _ConstructionsMap, _Constructions, _Construction, _Mons, _Mon} ->
            OldWorthL = San#c_san_state.auction_worth,
            case lists:keyfind(ServerId, 1, OldWorthL) of
                {_, OldWorth} -> skip;
                _ -> OldWorth = 0
            end,
            NewSan = San#c_san_state{auction_worth = lists:keystore(ServerId, 1, OldWorthL, {ServerId, OldWorth+Point})},
            NewSanList = lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan),
            {NewSanMap, _} = update_other_zone_data(ZoneMap, BattleMap, SanState, BatZoneMap, NewSanList, ZoneId, false, []),
            State#c_sanctuary_state{san_state = NewSanMap};
        _ ->
            State
    end.

%% -----------------------------------------------------------------
%% 秘籍清理服务器阵营记录
%% -----------------------------------------------------------------
clear_camp_record(State) ->
    db:execute(?SQL_TRUNCATE_SANTYPE_RECORD),
    State#c_sanctuary_state{server_camp = [], battle_zone = #{}}.

%% -----------------------------------------------------------------
%% 回调 初始化数据
%% -----------------------------------------------------------------
init_after(State, ServersInfo, Z2SMap, ServerPowerL, _InitType) ->
    NowTime = utime:unixtime(),
    NowDate = utime:unixdate(NowTime),
    ZoneList = maps:to_list(Z2SMap),
    NewServersInfo =lists:reverse(lists:keysort(2, ServersInfo)),

    %% 玩家阵营记录
    CampList = db:get_all(?SQL_SELECT_SANTYPE_RECORD),
    Fun3 = fun([ServerId, DbSantype], Acc) ->
        [{ServerId, DbSantype}|Acc]
    end,
    CampRecord = lists:foldl(Fun3, [], CampList),

    %% 清理归属表，防止太多冗余数据
    db:execute(?SQL_TRUNCATE_SERVER_BL),

    %% 计算初次分配的服对战表，不包含阵营模式
    Fun = fun({ZoneId, Serverids}, {TemMap,TemMap1, Acc, Acc1}) ->
        % ConstructionList = db:get_all(io_lib:format(?SQL_SELECT_SERVER_BL,[ZoneId])),
        % NMap = hand_construct_info(ConstructionList, TemMap1),
        {Resoult, ClusterList, NewAcc1} = handle_servers(Serverids, NewServersInfo, Acc1),
        NewAcc = get_cluster_list(ClusterList, ZoneId, Acc),
        if
            Resoult == [] ->
                NewTemMap = TemMap;
            true ->
                NewTemMap = maps:put(ZoneId, Resoult, TemMap)
        end,
        {NewTemMap, TemMap1, NewAcc, NewAcc1}
    end,
    % TemTime = calc_act_end_time(),
    % Ref = erlang:send_after(1000, self(), 'calc_battle_info'),
    {NewMap1, OldInfoMap, NeedDividedList, NewCampRecord} = lists:foldl(Fun, {#{},#{},[], CampRecord}, ZoneList),
    
    %% 阵营模式分配，统计所有阵营的区对战map BatZoneMap
    % ?MYLOG("xlh_san","NeedDividedList:~p,NewServersInfo:~p, CampRecord:~p~n",[NeedDividedList, NewServersInfo, CampRecord]),
    {NewMap, BatZoneMap} = divide_cluster_camp(NeedDividedList, ServerPowerL, NewMap1, #{}),
    
    %% 时间计算 
    ClearTime = calc_role_clear_time(NowTime),
    ClearRef = erlang:send_after(max((ClearTime-NowTime)*1000, 1000), self(), 'role_anger_clear'),
    DivideMap = divide_begin_scene(NewMap, BatZoneMap),
    {BeginTime, EndTime} =lib_c_sanctuary:calc_act_opentime(NowDate),
    if
        NowTime >= BeginTime andalso NowTime < EndTime->
            RBeginTime = BeginTime,REndTime = EndTime,Time = NowTime;
        NowTime < BeginTime ->
            RBeginTime = BeginTime,REndTime = EndTime, Time = BeginTime;
        true ->
            Time = NowTime,
            {RBeginTime, REndTime} = lib_c_sanctuary:calc_act_opentime(NowDate-86400)
    end,
    case calc_mon_reborn_time(Time) of
        {true, RebornEndTime} ->skip;
        _ -> RebornEndTime = 0
    end,
    % MonRef = erlang:send_after(max(1, RebornEndTime-NowTime)*1000, self(), 'mon_create'),
    StartTime = max(0, RBeginTime-NowTime),
    Et = max(0, REndTime-NowTime),
    Startref = erlang:send_after(StartTime*1000, self(), act_start),
    Endtref = erlang:send_after(Et*1000, self(), act_end),
    case data_cluster_sanctuary:get_san_value(tip_notify_user_act_end) of
        CValue when is_integer(CValue) ->Value = CValue*60;
        _ -> Value = 300,CValue =5
    end,
    %% 通知客户端活动开始
    mod_clusters_center:apply_to_all_node(lib_c_sanctuary_api,notify_client_act_time,[RBeginTime, REndTime]),
    
    case data_cluster_sanctuary:get_san_value(auction_produce_limit_time) of
        ProduceValue when is_integer(ProduceValue) -> ProduceValue;
        _ -> ProduceValue = 0
    end,

    %% 更新所有服数据
    Fun2 = fun({ZoneId, _}) ->
        DivideScene = maps:get(ZoneId, DivideMap, []),
        update_local_data(Z2SMap, NewMap, ZoneId, server, [ServersInfo, DivideScene])
    end,
    lists:foreach(Fun2, ZoneList),
    % ?MYLOG("xlh_san","Z2SMap:~p,NewMap:~p~n",[Z2SMap, NewMap]),
    State#c_sanctuary_state{
        zone_map = Z2SMap
        ,server_info = NewServersInfo
        ,battle_map = NewMap
        ,battle_zone = BatZoneMap
        ,calc_battle_ref = undefined
        % ,mon_reborn_ref = MonRef
        ,reborn_time = RebornEndTime
        ,role_anger_ref = ClearRef
        ,begin_scene_map = DivideMap
        ,act_start_ref = Startref      
        ,act_end_ref = Endtref
        ,act_start_time = RBeginTime
        ,act_end_time = REndTime
        ,old_con_map = OldInfoMap
        ,server_camp = NewCampRecord
        ,server_power = ServerPowerL
        ,auction_produce_time = RebornEndTime + ProduceValue
        ,act_tv_ref = erlang:send_after(max(Et-Value,0)*1000, self(), {'tipes_act_end', CValue})
    }.

gm_clear_user(State, SerId) ->
    #c_sanctuary_state{scene_user = UserMap} = State,
    KeyList = maps:keys(UserMap),
    Fun = fun
        ({_ZoneId, ServerId, Scene} = Key) when SerId == ServerId ->
            case maps:get(Key, UserMap, []) of
                [] -> skip;
                _E ->
                    ?PRINT("_E:~p Scene:~p~n",[_E, Scene]),
                    mod_scene_agent:apply_cast(Scene, 0, lib_c_sanctuary, clear_scene_palyer, [gm, Scene, SerId])
            end;
        (_) ->
            skip
    end,
    lists:foreach(Fun, KeyList),
    State.

%% -----------------------------------------------------------------
%% 活动开始
%% -----------------------------------------------------------------
act_start(State) ->
    #c_sanctuary_state{zone_map = ZoneMap, battle_map = BattleMap, act_start_time = StartTime, act_end_time = EndTime, 
            act_start_ref = Startref} = State,
    util:cancel_timer(Startref),
    %% 计算怪物复活时间，允许2分钟的延时
    case calc_mon_reborn_time(utime:unixtime()-120) of
        {true, RebornEndTime} ->skip;
        _ -> RebornEndTime = 0
    end,
    %% 判断怪物生成类型，init（每天第一次开启）不生成非和平怪物
    if
        StartTime == RebornEndTime ->
            CreateType = timer;
        true ->
            CreateType = init 
    end,
    %% 生成怪物
    NewState = mon_create(State#c_sanctuary_state{reborn_time = RebornEndTime}, CreateType),
    
    %% 通知所有开启跨服圣域的服务器活动时间，及通知在线客户端活动开启
    BattleList = maps:to_list(BattleMap), 
    % Fun = fun({_, [{?SANTYPE_1, List1}, {?SANTYPE_2, List2}, {?SANTYPE_3, List3}]}, Acc) ->
    Fun = fun({_, BattleServerList}, Acc) ->
        Fun1 = fun({_, List}, TemAcc) ->
            List++TemAcc
        end,
        lists:foldl(Fun1, Acc, BattleServerList);
         % List1++List2++List3 ++ Acc;
        (_, Acc) -> Acc
    end,
    AllServerId = lists:foldl(Fun, [], BattleList),
    ServerIdL = ulists:removal_duplicate(lists:flatten(AllServerId)),
    update_local_data(ZoneMap, BattleMap, time, [StartTime, EndTime]),
    lists:foreach(fun(ServerId) ->
        case lib_clusters_center:get_node(ServerId) of
            undefined -> skip;
            _ -> 
               mod_clusters_center:apply_cast(ServerId, lib_c_sanctuary_api, notify_client_act_time, [StartTime, EndTime])
        end
    end, ServerIdL),
    NewState.

%% -----------------------------------------------------------------
%% 活动结束
%% -----------------------------------------------------------------
act_end(State) ->
    %% 计算下次活动时间
    NowTime = utime:unixtime(),
    NowDate = utime:unixdate(NowTime),
    {BeginTime, EndTime} = lib_c_sanctuary:calc_act_opentime(NowDate),
    if
        EndTime =< NowTime ->
            {NBeginTime, NEndTime} = lib_c_sanctuary:calc_act_opentime(NowDate+86400);
        true ->
            NBeginTime = BeginTime,NEndTime = EndTime
    end,
    #c_sanctuary_state{zone_map = ZoneMap,battle_map = BattleMap, act_start_time = OStartTime, act_end_time = OEndTime, 
            act_start_ref = Startref, act_end_ref = Endtref, san_state = SanMap,scene_user = UserMap, mon_reborn_ref = OldMonRef} = State,
    util:cancel_timer(Startref),
    util:cancel_timer(Endtref),
    util:cancel_timer(OldMonRef),
    % case data_cluster_sanctuary:get_san_value(clear_user_act_end) of
    %   Value when is_integer(Value) ->skip;
    %   _ -> Value = 30
    % end,
    case data_cluster_sanctuary:get_san_value(tip_notify_user_act_end) of
        CValue when is_integer(CValue) ->Value = CValue*60;
        _ -> CValue = 5,Value = 300
    end,
    %% 活动结束通知所有客户端
    if
        NowTime > OEndTime-60 -> %% 活动结束超过60s,不做任何处理
            skip;
        true ->
            BattleList = maps:to_list(BattleMap), 
            % Fun = fun({_, [{?SANTYPE_1, List1}, {?SANTYPE_2, List2}, {?SANTYPE_3, List3}]}, Acc) ->
            %      List1++List2++List3 ++ Acc;
            Fun = fun({_, BattleServerList}, Acc) ->
                Fun1 = fun({_, List}, TemAcc) ->
                    List++TemAcc
                end,
                lists:foldl(Fun1, Acc, BattleServerList);
                (_, Acc) -> Acc
            end,
            AllServerId = lists:foldl(Fun, [], BattleList),
            ServerIdL = ulists:removal_duplicate(lists:flatten(AllServerId)),
            lists:foreach(fun(ServerId) ->
                case lib_clusters_center:get_node(ServerId) of
                    undefined -> skip;
                    _ -> 
                       mod_clusters_center:apply_cast(ServerId, lib_c_sanctuary_api, notify_client_act_time, [OStartTime, OEndTime])
                end
            end, ServerIdL)
    end,

    %% 清理场景玩家
    SanMapList = maps:to_list(SanMap),
    %?MYLOG("xlh","@@@@@@@:~p~n",[1111111]),
    clear_user_act_end(SanMapList, 0, NowTime, UserMap, ZoneMap),

    %% 下次活动的定时器
    StartT = max(0, NBeginTime-NowTime),
    Et = max(0, NEndTime-NowTime),
    NStartref = erlang:send_after(StartT*1000, self(), act_start),
    NEndtref = erlang:send_after(Et*1000, self(), act_end),

    %% 更新各个服数据
    update_local_data(ZoneMap, BattleMap, time, [NBeginTime, NEndTime]),

    %?MYLOG("xlh"," act_end, StartTime:~p,EndTime:~p~n", [StartT, Et]),
    State#c_sanctuary_state{
        act_start_ref = NStartref      
        ,act_end_ref = NEndtref
        ,act_start_time = NBeginTime
        ,act_end_time = NEndTime
        ,scene_user = #{}
        ,join_map = #{}
        ,act_tv_ref = erlang:send_after(max((Et-Value)*1000, 1000), self(), {'tipes_act_end', CValue})
    }.

%% -----------------------------------------------------------------
%% 活动结束提示场景玩家活动即将关闭
%% -----------------------------------------------------------------
tipes_act_end(State, CValue) ->
    mod_clusters_center:apply_to_all_node(lib_c_sanctuary_api, send_act_end_tv, [CValue]),
    #c_sanctuary_state{act_tv_ref = Tvref ,act_end_time = NEndTime} = State,
    util:cancel_timer(Tvref),
    Value = CValue - 2,
    if
        Value =< 0 ->
            NewRef = undefined;
        true -> %% 2分钟后再次提示玩家活动即将关闭
            NowTime = utime:unixtime(),
            Et = max(0, NEndTime-NowTime),
            NewRef = erlang:send_after(max((Et-Value*60)*1000, 1000), self(), {'tipes_act_end', Value})
    end,
    State#c_sanctuary_state{act_tv_ref = NewRef}.

%% -----------------------------------------------------------------
%% 获取活动时间
%% -----------------------------------------------------------------
get_act_opentime(State, Node, RoleId) ->
    #c_sanctuary_state{act_start_time = StartTime, act_end_time = EndTime} = State,
    {ok, BinData} = pt_284:write(28410, [StartTime, EndTime]),
    % ?PRINT("get_info 28410, StartTime:~p,EndTime:~p~n", [StartTime, EndTime]),
    lib_c_sanctuary_api:send_to_role(Node,RoleId,BinData),
    State.

%% -----------------------------------------------------------------
%% 更改开服天数，重启活动
%% -----------------------------------------------------------------
server_info_chage(State, ServerId, Args) ->
    #c_sanctuary_state{
        server_info = ServersInfo, zone_map = ZoneMap,
        server_power = ServerPowerL, battle_map = BattleMap
    } = State,
    {NewServersInfo, NewZoneMap} = server_info_chage_helper(ServerId, ServersInfo, ZoneMap, Args),
    case lists:keyfind(open_time, 1, Args) of
        {open_time, OpenTime} ->
            OpenDay = get_open_day(OpenTime),
            case data_cluster_sanctuary:get_type_by_openday(OpenDay) of
                Santype when is_integer(Santype) ->
                    NewState = init_after(State, NewServersInfo, NewZoneMap, ServerPowerL, gm);
                _-> 
                    NewState = State
            end;
        _ ->
            NewState = State
    end,
    case lists:keyfind(server_name, 1, Args) of
        {_, _} ->
            case lists:keyfind(ServerId, 1, NewServersInfo) of
                {_, _, _, _, _} = Turple ->
                    ZoneId = lib_clusters_center_api:get_zone(ServerId),
                    update_local_data(ZoneMap, BattleMap, ZoneId, server_info, Turple);
                _ ->
                    skip
            end;
        _ ->
            skip
    end,
    NewState#c_sanctuary_state{server_info = NewServersInfo, zone_map = NewZoneMap}.

%% 弃用
update_add_zone(State, ServersInfo, Z2SMap) ->
    #c_sanctuary_state{ 
        mon_reborn_ref = OMonRef
        ,role_anger_ref = OClearRef} = State,
    NowTime = utime:unixtime(),
    util:cancel_timer(OMonRef),util:cancel_timer(OClearRef),
    case calc_mon_reborn_time(NowTime) of
        {true, RebornEndTime} ->RebornTime = RebornEndTime - NowTime;
        _ -> RebornEndTime = NowTime,RebornTime = 1
    end,
    MonRef = erlang:send_after(max(RebornTime*1000, 1000), self(), {'mon_create', timer}),
    NewServersInfo =lists:reverse(lists:keysort(2, ServersInfo)),
    ClearTime = calc_role_clear_time(NowTime),
    ClearRef = erlang:send_after((ClearTime-NowTime)*1000, self(), 'role_anger_clear'),
    % save_infomations(ServersInfo, Z2SMap),
    % ?PRINT("Z2SMap:~p, ServerInfo:~p~n",[Z2SMap, ServersInfo]),
    State#c_sanctuary_state{
        zone_map = Z2SMap, 
        server_info = NewServersInfo, 
        mon_reborn_ref = MonRef
        ,reborn_time = RebornEndTime
        ,role_anger_ref = ClearRef}.

%% -----------------------------------------------------------------
%% 服务器分区改变回调
%% -----------------------------------------------------------------
zone_change(State, ServerId, 0, _NewZone) ->
    #c_sanctuary_state{
        server_camp = CampRecord
    } = State,
    case lists:keyfind(ServerId, 1, CampRecord) of
        {_, _} -> %% 第一次划分分区跑到这里说明数据异常，刚刚划分分区却有阵营记录
                  %%（一般是这个服务器启动后一段时间人太少，运维又重新启动服务器导致数据出问题）
            % ?PRINT("=============  R:~p~n",[R]),
            NewCampRecord = lists:keydelete(ServerId, 1, CampRecord),
            Sql = io_lib:format(<<"delete from sanctuary_kf_server where server = ~p">>, [ServerId]),
            db:execute(Sql),
            ?ERR("ERROR DATA server_camp server_id:~p~n", [ServerId]),
            NewState = State#c_sanctuary_state{server_camp = NewCampRecord};
        _ ->
            % ?PRINT("=============  CampRecord:~p~n",[CampRecord]),
            NewState = State
    end,
    local_init(NewState, ServerId);
zone_change(State, ServerId, OldZone, _NewZone) when OldZone =/= 0 -> 
    #c_sanctuary_state{
        zone_map = ZoneMap
        ,battle_map = BattleMap
        ,san_state = _SanState
        ,begin_scene_map = BeginMap
        ,old_con_map = OldInfoMap
    } = State,
    {Santype, [H|_]} = get_server_santype(ServerId, BattleMap, OldZone),
    SceneList = case data_cluster_sanctuary:get_san_type(Santype) of
                #base_san_type{san_num = [{_, SanSceneL}], city_num = [{_,CitySceneL}],
                        village_num =[{_, VillSceneL}]} ->
                    SanSceneL++CitySceneL++VillSceneL;
                _ ->
                    []
            end,
    Serverids = maps:get(OldZone, ZoneMap, []),
    BeginList = maps:get(OldZone, BeginMap, []),
    [Camp|_] = get_begin_scene(ServerId, BeginList, []),
    OldServerL = get_server_by_point(Camp, ServerId, BeginList),
    %% 旧分区相关数据移除--对战分配数据
    case OldServerL of
        [ServerId] -> NewBeginList = lists:delete({[ServerId], Camp}, BeginList);
        [_|_] ->
            BeginList1 = lists:delete({OldServerL, Camp}, BeginList),
            NewBeginList = [{lists:delete(ServerId, OldServerL), Camp}|BeginList1];
        _ -> NewBeginList = BeginList
    end,
    %% 旧分区相关数据移除--对战分配数据
    NewServerids = lists:delete(ServerId, Serverids),
    %% 旧分区相关数据移除--建筑占领数据
    Fun2 = fun(TemScene, TemMap) ->
        case maps:get({OldZone, H, TemScene}, TemMap, []) of
            [] -> TemMap;
            _ ->
                maps:remove({OldZone, H, TemScene}, TemMap)
        end
    end,
    NewInfoMap = lists:foldl(Fun2, OldInfoMap, SceneList),

    NewZoneMap = maps:put(OldZone, NewServerids, ZoneMap),
    NewBeginMap = maps:put(OldZone, NewBeginList, BeginMap),
    State#c_sanctuary_state{
        zone_map = NewZoneMap
        ,begin_scene_map = NewBeginMap
        ,old_con_map = NewInfoMap
    }.

%% -----------------------------------------------------------------
%% 服务器连接上跨服中心回调  同时进行本服数据矫正
%% -----------------------------------------------------------------
center_connected(State, ServerId, OpTime, WorldLv, ServerNum, ServerName, MergeSerIds) -> 
    #c_sanctuary_state{
        zone_map = ZoneMap
        ,server_info = ServerInfo
        ,battle_map = BattleMap
        ,battle_zone = BatZoneMap
        ,san_state = SanState
        ,begin_scene_map = BeginMap
        ,old_con_map = OldInfoMap
        ,act_start_time = BeginTime
        ,act_end_time = EndTime
        ,join_map = JoinMap
        ,point_map = PointMap
        ,auction_produce_time = ProduceEndTime
    } = State,

    %% 清除被合服的服务器相关数据
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {Santype, [H|_] = EnemyServerIds} = get_server_santype(ServerId, BattleMap, ZoneId),
    SceneList = case data_cluster_sanctuary:get_san_type(Santype) of
                #base_san_type{san_num = [{_, SanSceneL}], city_num = [{_,CitySceneL}],
                        village_num =[{_, VillSceneL}]} ->
                    SanSceneL++CitySceneL++VillSceneL;
                _ ->
                    []
            end,
    Serverids = maps:get(ZoneId, ZoneMap, []),
    BeginList = maps:get(ZoneId, BeginMap, []),
    [Camp|_] = get_begin_scene(ServerId, BeginList, []),
    Fun = fun
        (TemServerId, {Acc1, Acc2, Acc3, Acc4}) when TemServerId == ServerId ->
            NewAcc2 = lists:keyreplace(ServerId, 1, Acc2, {ServerId, OpTime, WorldLv, ServerNum, ServerName}),
            {Acc1, NewAcc2, Acc3, Acc4};
        (TemServerId, {Acc1, Acc2, Acc3, Acc4}) ->
            NewAcc2 = lists:keydelete(TemServerId, 1, Acc2),
            NewAcc1 = lists:delete(TemServerId, Acc1),
            [TemCamp|_] = get_begin_scene(TemServerId, Acc3, []),
            case lists:keyfind(TemCamp, 2, Acc3) of
                {ServerIdList, Vscene} -> NewAcc3 = lists:keyreplace(TemCamp, 2, Acc3, {lists:delete(TemServerId, ServerIdList), Vscene});
                _ -> NewAcc3 = Acc3
            end,
            {NewAcc1, NewAcc2, NewAcc3, [{TemCamp, TemServerId}|lists:keydelete(TemServerId, 2, Acc4)]}
        end,
    %% 更新区服务器列表，服务器信息列表，对战列表 #TODO 该处理只在同分区合服有效-20210220
    {NewServerids, NewServerInfo, BeginList1, MergeCamps} =  lists:foldl(Fun, {Serverids, ServerInfo, BeginList, []}, MergeSerIds),
    NewBeginList = [{SerIdList, TCamp}|| {SerIdList, TCamp} <- BeginList1, SerIdList =/= []],

    Fun2 = fun(TemScene, TemMap) ->
        case maps:get({ZoneId, H, TemScene}, TemMap, []) of
            _Camp when is_integer(_Camp) ->
                case lists:keyfind(_Camp, 1, MergeCamps) of
                    {_, TserId} -> 
                        SerIdL = get_server_by_point(_Camp, TserId, BeginList),
                        if
                            SerIdL == [TserId] ->
                                maps:put({ZoneId, H, TemScene}, Camp, TemMap);
                            true ->
                                TemMap
                        end;
                    _ -> 
                        TemMap
                end;
            _ -> TemMap
        end
    end,
    
    %% 更新建筑归属数据，合服时被合服服务器所在阵营(该阵营只有该服时)占领的建筑归属划分给主服
    NewInfoMap = lists:foldl(Fun2, OldInfoMap, SceneList),

    %% 合服时被合服服务器所在阵营(该阵营只有该服时)占领的建筑归属划分给主服
    SanList = maps:get(ZoneId, SanState, []),
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} = San -> 
            Constructions = maps:get({ZoneId,H}, ConstructionsMap, []),
            %% 检查该跨服圣域模式所有建筑的归属状态,重新计算归属
            Fun3 = fun(Construction, Acc) ->
                #c_cons_state{bl_server = BlCamp, cons_type = ConType, mon_state = Mons, san_score = SanScore} = Construction,
                SanScoreList = maps:to_list(SanScore),
                %% 重新计算占领积分
                Fun4 = fun({{TemCamp, SceneId}, Score}, AccMap) ->
                    NewServerL = get_server_by_point(TemCamp, EnemyServerIds, NewBeginList),
                    if
                        NewServerL == [] andalso TemCamp =/= Camp -> %% 这个阵营被合服了
                            NowScore = case maps:get({Camp, SceneId}, AccMap, []) of
                                            ScoreTem when is_integer(ScoreTem) -> ScoreTem;
                                            _ -> 0
                                       end,
                            TemMap = maps:put({Camp, SceneId}, NowScore+Score, AccMap),
                            maps:remove({TemCamp, SceneId}, TemMap);
                        true ->
                            AccMap
                    end
                end,
                NewSanScoreMap = lists:foldl(Fun4, SanScore, SanScoreList),
                %% 重新计算归属
                if
                    BlCamp == 0 ->
                        NewBlCamp = cal_con_bl_server(NewSanScoreMap, Mons, 0, ConType);
                    true ->
                        OldBlServerL = get_server_by_point(BlCamp, EnemyServerIds, NewBeginList),
                        if
                            OldBlServerL == [] -> %% 这个阵营被合服了,归属划分给主服
                                NewBlCamp = Camp;
                            true -> %% 阵营还有其他服,归属状态不变
                                NewBlCamp = BlCamp
                        end
                end,
                BlServerL = get_server_by_point(NewBlCamp, EnemyServerIds, NewBeginList),
                case BlServerL of
                    [] ->
                        NewConstruction = Construction#c_cons_state{bl_server = BlCamp, san_score = NewSanScoreMap};
                    _ ->
                        NewConstruction = Construction#c_cons_state{bl_server = NewBlCamp, san_score = NewSanScoreMap}
                end,
                [NewConstruction|Acc]
            end,
            NewConstructions = lists:foldl(Fun3, [], Constructions),
            NewConsMap = maps:put({ZoneId,H}, NewConstructions, ConstructionsMap),
            NewSan = San#c_san_state{cons_state = NewConsMap},
            NewSanList = lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan);
        _ -> 
            NewSanList = SanList
    end,
    %% 更新建筑相关信息到各对战服务器
    {NewSanState, _} = update_other_zone_data(ZoneMap, BattleMap, SanState, BatZoneMap, NewSanList, ZoneId),
    % NewSanState = maps:put(ZoneId, NewSanList, SanState),
    NewZoneMap = maps:put(ZoneId, NewServerids, ZoneMap),
    NewBeginMap = maps:put(ZoneId, NewBeginList, BeginMap),

    PointList = maps:get({ZoneId, Camp}, PointMap, []),
    %% 重新派发数据给主服
    mod_clusters_center:apply_cast(ServerId, mod_c_sanctuary_local, init_after, 
            [ZoneId, NewSanList, Santype, EnemyServerIds, NewBeginList, NewServerInfo, BeginTime, EndTime, JoinMap, PointList, ProduceEndTime]),
    % update_local_data(ZoneMap, BattleMap, ZoneId, ServerId, san, [NewSanList]),
    %% 更新新的对战服务器列表\服务器数据到各个对战服
    update_local_data(NewZoneMap, BattleMap, ZoneId, server, [NewServerInfo, NewBeginList]),
    State#c_sanctuary_state{
        zone_map = NewZoneMap
        ,server_info = NewServerInfo
        ,begin_scene_map = NewBeginMap
        ,old_con_map = NewInfoMap
        ,san_state = NewSanState
    }.

%% -----------------------------------------------------------------
%% 零点重新计算对战服务器分配时间/怒气清理时间
%% -----------------------------------------------------------------
midnight_update(State, ServersInfo, Z2SMap) ->  %% 零点执行//新服连接跨服中心
    #c_sanctuary_state{ 
        calc_battle_ref = ORef
        ,role_anger_ref = OClearRef
        ,act_end_time = EndTime} = State,
    NowTime = utime:unixtime(),
    %% 活动结束?TIME_BEFORE分钟后分配对战服务器
    TemTime = EndTime + ?TIME_BEFORE*60 - NowTime,
    util:cancel_timer(ORef),util:cancel_timer(OClearRef),
    Ref = erlang:send_after(TemTime*1000, self(), 'calc_battle_info'),
    NewServersInfo =lists:reverse(lists:keysort(2, ServersInfo)),
    ClearTime = calc_role_clear_time(NowTime),
    ClearRef = erlang:send_after(max((ClearTime-NowTime)*1000, 1000), self(), 'role_anger_clear'),
    % save_infomations(ServersInfo, Z2SMap),
    State#c_sanctuary_state{zone_map = Z2SMap, 
        server_info = NewServersInfo, 
        calc_battle_ref = Ref
        ,role_anger_ref = ClearRef}.

%% -----------------------------------------------------------------
%% 对战服务器分配
%% -----------------------------------------------------------------
calc_battle_info(State) ->
    #c_sanctuary_state{
        zone_map = ZoneMap, 
        calc_battle_ref = OldRef, 
        calc_battle_time = BattleTime,
        server_info = ServersInfo, 
        battle_map = OldMap,
        battle_zone = BatZoneMap,
        server_camp = CampRecord,
        server_power = ServerPowerL,
        san_state = SanState} = State,

    Now = utime:unixtime(),
    util:cancel_timer(OldRef),
    ZoneList = maps:to_list(ZoneMap),
    if
        Now >= BattleTime ->  %% 需要再次打乱对战列表
            BattleTimeCfg = case data_cluster_sanctuary:get_san_value(random_time) of
                                Day when is_integer(Day) andalso Day > 0 -> Day;
                                _ -> 1
                            end,
            Fun = fun({ZoneId, Serverids}, {TemMap, Acc, Acc1}) ->
                {Resoult, ClusterList, NewAcc1} = handle_servers(Serverids, ServersInfo, Acc1),
                NewAcc = get_cluster_list(ClusterList, ZoneId, Acc),
                {maps:put(ZoneId, Resoult, TemMap), NewAcc, NewAcc1}
            end,
            NowDate = utime:unixdate(Now),
            NewSanState = #{},
            NewBattleTime = NowDate + BattleTimeCfg *86400,
            %% 初次分配对战服务器(一个分区内对战); 筛选所有进入阵营(2个分区及以上的服务器一起对战)的分区和服务器; 服务器进入阵营记录(进入阵营后无论如何都是阵营模式)
            {NewMap1, NeedDividedList, NewCampRecord} = lists:foldl(Fun, {#{},[], CampRecord}, ZoneList),
            %% 阵营模式对战服务器分配,统计所有阵营模式的区id及对手区id
            {NewMap, NewBatZoneMap} = divide_cluster_camp(NeedDividedList, ServerPowerL, NewMap1, BatZoneMap);
        true ->
            NewBattleTime = BattleTime,
            Fun = fun({ZoneId, Serverids}, {TemMap, Acc, Acc1}) ->
                OldResoult = maps:get(ZoneId, OldMap, []),
                if
                    OldResoult == [] ->
                        {Resoult, ClusterList, NewAcc1} = handle_servers(Serverids, ServersInfo, Acc1);
                    true ->
                        {Resoult, ClusterList, NewAcc1} = handle_servers(Serverids, ServersInfo, OldResoult, Acc1)
                end,
                NewAcc = get_cluster_list(ClusterList, ZoneId, Acc),
                % ?PRINT("Resoult:~p~n",[Resoult]),
                {maps:put(ZoneId, Resoult, TemMap), NewAcc, NewAcc1}
            end,
            NewSanState = SanState,
            %% 对战服务器表没有改变就沿用之前的分配结果
            {NewMap1, NeedDividedList, NewCampRecord} = lists:foldl(Fun, {#{},[], CampRecord}, ZoneList),
            {NewMap, NewBatZoneMap} = divide_cluster_camp(NeedDividedList, ServerPowerL, NewMap1, OldMap, BatZoneMap)
    end,
    %% 分配起点
    DivideMap = divide_begin_scene(NewMap, NewBatZoneMap),
    % ?MYLOG("xlh", "NewMap:~p~n,NewMap1:~p~n~n,NewBatZoneMap~p~n, DivideMap:~p~n,NeedDividedList:~p,NewCampRecord:~p~n",
    %     [NewMap, NewMap1, NewBatZoneMap, DivideMap, NeedDividedList, NewCampRecord]),
    %% 更新服数据
    Fun2 = fun({ZoneId, _}) ->
        DivideScene = maps:get(ZoneId, DivideMap, []),
        update_local_data(ZoneMap, NewMap, ZoneId, server, [ServersInfo, DivideScene])
    end,
    lists:foreach(Fun2, ZoneList),
    % ?ERR("ignore_error:kf_sanctuary  init_after  BattleMap:~p,DivideMap:~p,ZoneMap:~p,ServersInfo:~p~n",[NewMap,DivideMap,ZoneMap,ServersInfo]),
    State#c_sanctuary_state{battle_map = NewMap, battle_zone = NewBatZoneMap , begin_scene_map = DivideMap, calc_battle_time = NewBattleTime, san_state = NewSanState, server_camp = NewCampRecord}.

%% -----------------------------------------------------------------
%% 获取活动数据
%% -----------------------------------------------------------------
get_info(State, ServerId, Node, RoleId) ->
    #c_sanctuary_state{server_info = ServerInfo, battle_map = BattleMap, begin_scene_map = DivideMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    BattList = maps:get(ZoneId, BattleMap, []),
    case find_enemy(BattList, ServerId) of
        {Santype, Serverids} -> 
            DivideScene = maps:get(ZoneId, DivideMap, []),
            Fun = fun(TemServerId, Acc) ->
                case lists:keyfind(TemServerId, 1, ServerInfo) of
                    {TemServerId, OpenTime, _WorldLv, ServerNum, ServerName} ->
                        OpenDay = get_open_day(OpenTime);
                    _ ->
                        OpenDay = 0,ServerNum = 0, ServerName = <<>>
                end,
                case lists:keyfind(TemServerId, 1, DivideScene) of
                    {TemServerId, Scene} ->
                        [{TemServerId, ServerNum, ServerName, OpenDay, Scene}|Acc];
                    _ -> Acc
                end
            end,
            SendL = lists:foldl(Fun, [], Serverids),
            % ?MYLOG("xlh","get_info 28400, Santype:~p,SendL:~p,BattList:~p~n", [Santype, SendL,maps:to_list(BattleMap)]),
            {ok, BinData} = pt_284:write(28400, [Santype,SendL]),
            lib_c_sanctuary_api:send_to_role(Node,RoleId,BinData);
            % lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            % ?MYLOG("xlh","get_info 28400, BattleMap:~p,BattList:~p,ServerId:~p~n", [BattleMap, BattList,ServerId]),
            {ok, BinData} = pt_284:write(28400, [0,[]]),
            lib_c_sanctuary_api:send_to_role(Node,RoleId,BinData)
    end,
    State.

%% -----------------------------------------------------------------
%% 获取建筑信息
%% -----------------------------------------------------------------
get_construction_info(State, ServerId, Node, RoleId, Scene) ->
    #c_sanctuary_state{san_state = SanState, battle_map = BattleMap, server_info = _ServerInfo, join_map = Jmap, begin_scene_map = BeginMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {Santype, [H|_]} = get_server_santype(ServerId, BattleMap, ZoneId),
    SanList = maps:get(ZoneId, SanState, []),
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} -> ConstructionsMap;
        _ -> ConstructionsMap = #{}
    end,
    Constructions = maps:get({ZoneId,H}, ConstructionsMap, []),
    BeginList = maps:get(ZoneId, BeginMap, []),
    [Camp|_] = get_begin_scene(ServerId, BeginList, []),
    case lists:keyfind(Scene, #c_cons_state.scene_id, Constructions) of
        #c_cons_state{san_score = SanScore, cons_type = ConType, mon_state = Mons, 
                bl_server = BlCamp, pre_bl_server = PreBlCamp, role_recieve = RecieveList} -> SanScore;
        _ -> SanScore = #{}, Mons = [], BlCamp = 0,PreBlCamp=0,ConType = 0,RecieveList = []
    end,
    case lists:keyfind(RoleId, 1, RecieveList) of
        {RoleId, _Time} -> RecieveStatus = ?HAS_RECIEVE;
        _ -> 
            if
                BlCamp == Camp ->
                    RecieveStatus = ?HAS_ACHIEVE;
                true ->
                    RecieveStatus = ?NOT_ACHIEVE
            end
    end,
    List = maps:to_list(SanScore),
    Fun = fun({{TemCamp, _TScene}, Score}, Acc) ->
        [{TemCamp, Score}|Acc]
    end,
    SendL = lists:foldl(Fun, [], List),
    MonInfo = get_all_mon_info(Mons, []),

    BeginList = maps:get(ZoneId, BeginMap, []),
    [Camp|_] = get_begin_scene(ServerId, BeginList, []),

    JoinNum = maps:get({Camp, ServerId, Scene}, Jmap, 0),
    % ?MYLOG("xlh","@@@@@@@@@@@ get_construction_info 28401 {Scene:~p,ConType:~p,BlServer:~p,Pblserver:~p~n,SendL:~p~n,RecieveStatus:~p,JoinNum:~p,MonInfo:~p~n",
    %   [Scene,ConType,BlServer,Pblserver,SendL,RecieveStatus,JoinNum,MonInfo]),
    {ok, BinData} = pt_284:write(28401, [Scene,ConType,BlCamp,PreBlCamp,SendL,RecieveStatus,JoinNum,MonInfo]),
    lib_c_sanctuary_api:send_to_role(Node, RoleId, BinData),
    % lib_server_send:send_to_uid(RoleId, BinData),
    State.

%% -----------------------------------------------------------------
%% 怪物伤害排名
%% -----------------------------------------------------------------
get_rank_info(State, ServerId, Node, RoleId, Scene, MonId) ->
    #c_sanctuary_state{san_state = SanState, battle_map = BattleMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {Santype, [H|_]} = get_server_santype(ServerId, BattleMap, ZoneId),
    SanList = maps:get(ZoneId, SanState, []),
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} -> ConstructionsMap;
        _ -> ConstructionsMap = #{}
    end,
    Constructions = maps:get({ZoneId,H}, ConstructionsMap, []),
    case lists:keyfind(Scene, #c_cons_state.scene_id, Constructions) of
        #c_cons_state{mon_state = Mons} -> skip;
        _ -> Mons = []
    end,
    case lists:keyfind(MonId, #c_mon_state.mon_id, Mons) of
        #c_mon_state{rank_list = RankList} -> RankList;
        _ -> RankList = []
    end,
    % NewRankA = lists:reverse(RankList),        %%伤害由大到小的列表
 %    % ServerId, RoleId, Name, OldHurt+Hurt
 %    %%PerHurt:上一名玩家的伤害
 %    Fun = fun({S, R, N, Hurt}, Acc) ->
 %      Num = (Hurt*100) div (TotalNum),
 %        [{S,R,N,Num}|Acc]
 %    end,
 %    RealSendL = lists:foldl(Fun, [], NewRankA),
    case data_cluster_sanctuary:get_san_value(kill_log_num) of
        Num when is_integer(Num) -> skip;
        _ -> Num = 20
    end,
    RealSendL = lists:sublist(RankList, Num),
    %?MYLOG("xlh","@@@@@@@@@@@ get_rank_info 28403 {MonId, RealSendL}:~p,Mons:~p~n",[{MonId, RealSendL}, Mons]),
    {ok, BinData} = pt_284:write(28403, [MonId, RealSendL]),
    % lib_server_send:send_to_uid(RoleId, BinData),
    lib_c_sanctuary_api:send_to_role(Node, RoleId, BinData),
    State.

%% -----------------------------------------------------------------
%% 进入场景
%% -----------------------------------------------------------------
enter(State, ServerId, Node, RoleId, Scene, NeedOut) ->
    NowTime = utime:unixtime(),
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    #c_sanctuary_state{battle_map = BattleMap, san_state = SanState, begin_scene_map = BeginMap, 
            auction_produce_time = ProduceEndTime, join_map = Jmap,act_start_time = BeginTime,
            act_end_time = EndTime, scene_user = UserMap, battle_zone = BatZoneMap, zone_map = ZoneMap} = State,
    BeginList = maps:get(ZoneId, BeginMap, []),
    [Camp|_] = PointList = get_begin_scene(ServerId, BeginList, []),
    Fun = fun(TemPoint, Acc) ->
        TSceneL = data_cluster_sanctuary:get_can_enter_scenes(TemPoint),
        Acc ++ TSceneL
    end,
    SceneL = lists:foldl(Fun, [], PointList),
    IsbeginScene = case lists:member(Scene, SceneL) of
                true -> %% 起点场景
                    true;
                _ -> false
            end,
    %% 更新场景人数
    JoinNum = maps:get({Camp, ServerId, Scene}, Jmap, 0),
    %% 判断是否可以进入
    TimeLimt = if
        NowTime >= BeginTime andalso NowTime < EndTime ->
            true;
        true ->
            false
    end,
    %% 当前占领/当前无人占领但是上次占领的场景
    BlsceneL = calc_server_all_construction(ZoneId, ServerId, SanState, BattleMap, BeginList),
    Canenter = calc_can_enter(Scene, SceneL, BlsceneL),
    % ?PRINT("TimeLimt:~p,IsbeginScene:~p,Canenter:~p~n",[TimeLimt,IsbeginScene,Canenter]),
    CanEnterScene = 
        if
            TimeLimt == true ->
                if
                    IsbeginScene == true ->
                        true;
                    Canenter == true ->
                        true;
                    true -> false
                end;
            true ->
                false
        end,
    if
        CanEnterScene == true ->
            BattList = maps:get(ZoneId, BattleMap, []),
            case find_enemy(BattList, ServerId) of
                {Santype, [H|_]} -> 
                    SceneList = lib_c_sanctuary:get_scenes_by_santype(Santype),
                    case lists:member(Scene, SceneList) of
                        true ->
                            _Code = 1,
                            {ok, BinData} = pt_284:write(28404, [_Code]),
                            % lib_server_send:send_to_uid(RoleId, BinData),
                            %% 更新进入场景的人数及场景玩家
                            UserList = maps:get({ZoneId, ServerId, Scene}, UserMap, []),
                            case lists:member(RoleId, UserList) of
                                false ->
                                    NewJoinNum = JoinNum + 1,
                                    NewUlist = [RoleId|UserList];
                                _ ->
                                    NewJoinNum = JoinNum,
                                    NewUlist = UserList
                            end,
                            NewUmap = maps:put({ZoneId, ServerId, Scene}, NewUlist, UserMap),
                            if
                                Santype =< ?SANTYPE_3 ->
                                    PK = ?PK_SERVER;
                                true ->
                                    PK = ?PK_CAMP
                            end,
                            %% 进入场景更新场景进程玩家阵营数据,取消进入之前设置的"锁"
                            mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene, 
                                    [RoleId, Scene, 0, H, NeedOut, [{group, 0},{pk, {PK, true}},{camp, Camp}, {action_free, ?ERRCODE(err284_enter_cluster)}]]);
                            % lib_scene:player_change_scene(RoleId, Scene, 0, H, true, [{group, 0},{pk, {?PK_SERVER, true}}]);
                        _ ->
                            NewJoinNum = JoinNum,
                            NewUmap = UserMap,
                            _Code = ?ERRCODE(scene_error), %% 场景数据异常
                            {ok, BinData} = pt_284:write(28404, [_Code])
                            % lib_server_send:send_to_uid(RoleId, BinData)
                    end;
                _ ->
                    NewJoinNum = JoinNum,
                    NewUmap = UserMap,
                    _Code = ?ERRCODE(can_not_enter),
                    {ok, BinData} = pt_284:write(28404, [_Code])
                    % lib_server_send:send_to_uid(RoleId, BinData)
            end;
        true ->
            if
                TimeLimt == false ->
                    _Code = ?ERRCODE(time_limit);
                true ->
                    _Code = ?ERRCODE(can_not_enter_scene)  %% 请占领前置场景
            end,
            NewJoinNum = JoinNum,
            NewUmap = UserMap,
            {ok, BinData} = pt_284:write(28404, [_Code])
            % lib_server_send:send_to_uid(RoleId, BinData)
    end,
    %?MYLOG("xlh","@@@@@@@@@@@ enter 28404 BeginMap:~p,_Code:~p,UserMap:~p~n",[BeginMap,_Code,NewUmap]),
    lib_c_sanctuary_api:send_to_role(Node, RoleId, BinData),
    NewJoinMap = maps:put({Camp, ServerId, Scene}, NewJoinNum, Jmap),
    ServerL = get_server_by_point(Camp, ServerId, BeginList),
    {Santype2, [H2|_]} = get_server_santype(ServerId, BattleMap, ZoneId),
    case  get_scene_info(ZoneId, H2, Santype2, Scene, SanState) of
        {true, San, SanList, ConstructionsMap, Constructions, #c_cons_state{bl_server = 0, auction_reward_role = ServerRole, cons_type = ConType} = Construction} when ConType == ?CONS_TYPE_1 ->
            %% 在拍卖产出限制时间内进入要塞场景,添加到可获得要塞占领分红玩家列表
            case lists:keyfind(ServerId, 1, ServerRole) of
                {ServerId, RoleIdList} -> skip;
                _ -> RoleIdList = []
            end,
            case lists:member(RoleId, RoleIdList) of
                false when _Code == 1 ->
                    NewRoleIdList = [RoleId|RoleIdList],
                    NewCon = Construction#c_cons_state{auction_reward_role = lists:keystore(ServerId, 1, ServerRole, {ServerId, NewRoleIdList})},
                    NewCons = lists:keystore(Scene, #c_cons_state.scene_id, Constructions, NewCon),
                    NewMap = maps:put({ZoneId, H2}, NewCons, ConstructionsMap),
                    NewSan = San#c_san_state{cons_state = NewMap},
                    NewSanList = lists:keystore(Santype2, #c_san_state.san_type, SanList, NewSan),

                    {NewSanMap, _} = update_other_zone_data(ZoneMap, BattleMap, SanState, BatZoneMap, NewSanList, ZoneId, false, []),
                    % NewSanMap = maps:put(ZoneId, NewSanList, SanState),
                    NewState = State#c_sanctuary_state{san_state = NewSanMap};
                _ ->
                    %?PRINT("============== :~n",[]),
                    NewState = State
            end;
        {true, _, _, _, _, _} when NowTime < ProduceEndTime ->
            %% 在拍卖产出限制时间内进入跨服圣域场景,通知本地新增可获得要塞占领分红玩家
            mod_clusters_center:apply_cast(ServerId, mod_c_sanctuary_local, add_auction_role,[0, [RoleId]]),
            NewState = calc_auction_role_list(State, ZoneId, RoleId, _Code, H2, Santype2, SceneL, SanState, ServerId);
        _ ->
            NewState = State
    end,
    [update_local_data(TemServerId, join, [NewJoinMap]) || TemServerId <- ServerL],
    % ?PRINT("NewJoinMap:~p,ServerL:~p~n",[NewJoinMap, ServerL]),
    NewState#c_sanctuary_state{join_map = NewJoinMap, scene_user = NewUmap}.

%% -----------------------------------------------------------------
%% 怪物生成
%% -----------------------------------------------------------------
mon_create(State, CreateType) ->
    NowTime = utime:unixtime(),
    #c_sanctuary_state{
            zone_map = ZoneMap,
            san_state = SanState, 
            server_info = ServerInfo, 
            battle_map = BattleMap,
            battle_zone = BatZoneMap, 
            mon_reborn_ref = OldRef,
            reborn_time = NowRebornTime, 
            old_con_map = OldInfoMap
            ,act_start_time = BeginTime} = State,
    util:cancel_timer(OldRef),
    BattleList = maps:to_list(BattleMap),
    Fun = fun({ZoneId, BattleServerIdList}, {TemMap, BatMap}) ->
            SanList = maps:get(ZoneId, TemMap, []),
            ZoneIdL = maps:get(ZoneId, BatMap, []),
            % ?PRINT("ZoneIdL:~p,BatMap:~p~n",[ZoneIdL, BatMap]),
            if
                ZoneIdL =/= [] -> %% 阵营模式怪物生成一遍后更新对手区的数据即可
                    ZoneIdList = ZoneIdL,
                    Fun1 = fun({Santype, List}, Acc) -> 
                        % ?PRINT("============== List:~p~n",[List]),
                        Map1 = get_constructions_map(Santype, Acc),
                        NewMap1 = mon_create_helper(ZoneId, Santype, List, ServerInfo, Map1, OldInfoMap, CreateType, NowRebornTime),
                        mon_create_save_info(Santype, Acc, NewMap1)
                    end,
                    %% 生成怪物
                    NewSanList = lists:foldl(Fun1, SanList, BattleServerIdList),
                    %% 更新数据
                    update_other_zone_data_core(ZoneMap, BattleMap, TemMap, BatMap, NewSanList, ZoneIdList, true, []);
                true -> %% 非阵营模式,各个区都要生成怪物
                    case maps:get(ZoneId, BatZoneMap, []) of
                        [] ->
                            ZoneIdList = [ZoneId],
                            Fun1 = fun({Santype, List}, Acc) -> 
                                % ?PRINT("============== List:~p~n",[List]),
                                Map1 = get_constructions_map(Santype, Acc),
                                NewMap1 = mon_create_helper(ZoneId, Santype, List, ServerInfo, Map1, OldInfoMap, CreateType, NowRebornTime),
                                mon_create_save_info(Santype, Acc, NewMap1)
                            end,
                            NewSanList = lists:foldl(Fun1, SanList, BattleServerIdList),
                            update_other_zone_data_core(ZoneMap, BattleMap, TemMap, BatMap, NewSanList, ZoneIdList, true, []);
                        _ ->
                            % ?PRINT("============== ZoneId:~p,ZoneIdL:~p~n",[ZoneIdL, ZoneIdL]),
                            {TemMap, BatMap}
                    end
            end;
        (_, Tem) ->
            Tem
    end,
    {NewSanMap, _} = lists:foldl(Fun, {SanState, BatZoneMap}, BattleList),
    %% 计算下次复活时间，启动定时器
    if
        NowTime >= BeginTime ->
            Time = NowTime;
        true ->
            Time = BeginTime
    end,
    case calc_mon_reborn_time(Time+65) of
        {true, RebornEndTime} ->RebornTime = RebornEndTime - NowTime;
        _ -> RebornTime = 0,RebornEndTime = NowTime
    end,
    if
        RebornTime =< 0->
            MonRef = undefined;
        true ->
            MonRef = erlang:send_after(max(1,RebornTime)*1000, self(), {'mon_create', timer})
    end,
    case data_cluster_sanctuary:get_san_value(auction_produce_limit_time) of
        ProduceValue when is_integer(ProduceValue) -> ProduceValue;
        _ -> ProduceValue = 0
    end,
    % ?PRINT("========== NowTime + ProduceValue:~p~n",[NowRebornTime + ProduceValue]),
    update_local_data(ZoneMap, BattleMap, auction_time, [NowRebornTime + ProduceValue]),
    NewInfoMap = if
        CreateType == timer ->
            #{};
        true -> 
            OldInfoMap
    end,
    State#c_sanctuary_state{
        san_state = NewSanMap, mon_reborn_ref = MonRef, reborn_time = RebornEndTime, 
        auction_produce_time = NowRebornTime + ProduceValue, point_map = #{}, old_con_map = NewInfoMap}.

%% -----------------------------------------------------------------
%% 怪物被击杀
%% -----------------------------------------------------------------
mon_be_killed(State, BLWhos, Klist, Scene, PoolId, CopyId, AttrServerId, Monid, _AtterId, _AtterName) ->  
    NowTime = utime:unixtime(),
    #c_sanctuary_state{
            zone_map = ZoneMap,
            san_state = SanState, 
            battle_map = BattleMap,
            battle_zone = BatZoneMap,
            server_info = ServersInfo, 
            scene_user = UserMap,
            auction_produce_time = ProduceEndTime,
            begin_scene_map = BeginMap,
            old_con_map = OldInfoMap,
            point_map = OldPointMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(AttrServerId),
    {Santype, Serverids} = get_server_santype(AttrServerId, BattleMap, ZoneId),
    case get_mon_info(ZoneId, CopyId, Santype, Scene, Monid, SanState) of
        {true, SanList, San, ConstructionsMap, Constructions, Construction, Mons, #c_mon_state{rank_list = _RankList, 
                    total_hurt = _Total, mon_type = SanMonType, kill_log = KillLog, reborn_ref = OldMonRef, mon_hurt_info = OldHurtInfo} = Mon} ->
            SortList = lists:keysort(#mon_atter.hurt, Klist), %% 由小到大
            Fun = fun(P, {Acc, TemTotal}) ->
                #mon_atter{id = TRoleId, server_id = TServerId, name = TRoleName, hurt = Hurt, server_num = ServerNum} = P,
                {[{TServerId, ServerNum, TRoleId, TRoleName, Hurt}|Acc], Hurt+TemTotal}
            end,
            {RankList, Total} = lists:foldl(Fun, {[], 0}, SortList), %%伤害由大到小的列表
            % ?PRINT("RankList:~p,Total:~p~n",[RankList,Total]),
            #c_cons_state{bl_server = ConBlCamp, pre_bl_server = OConBlCamp, san_score = SanScoreMap,
                    role_recieve = RecieveList, cons_type = ConType, clear_role_ref = ClearRoleRef, auction_reward_role = _ServerRole} = Construction,
            % ?MYLOG("xlh","Construction:~p~n",[Construction]),
            %% 计算怪物归属服务器，更新伤害排行
            case data_cluster_sanctuary:get_san_value(kill_log_num) of
                Num when is_integer(Num) -> skip;
                _ -> Num = 20
            end,
            case data_cluster_sanctuary:get_mon_type(SanMonType, ConType) of
                #base_san_mon_type{san_score = SanScore,score = Score,min_score = MinScore,anger = Anger,medal = MedalReward} ->skip;
                _ -> 
                    SanScore =0, Score = 0, MinScore = 0,Anger = 0,MedalReward = [],
                    ?ERR("error cfg get_mon_type when SanMonType:~p~n",[SanMonType])
            end,
            {SRealSendL, [MonBlServer|_], RoleScore, BLSerRoleIdList} = calc_mon_bl_server(RankList, Total, BLWhos, Score, MinScore, ServersInfo),
            {RealSendL,_} = ulists:sublist(SRealSendL, Num),
            BeginList = maps:get(ZoneId, BeginMap, []),
            [BlCamp|_] = get_begin_scene(MonBlServer, BeginList, []),
            MonBlServerL = get_server_by_point(BlCamp, MonBlServer, BeginList),
            
            erlang:send_after(500, self(), {'send_rank', Scene, PoolId, CopyId, RealSendL, Monid}),
            %% 归属者才有怒气值
            LogArgs = [Scene,ConType,Monid,SanMonType],
            [begin
                 lib_c_sanctuary:update_role_anger(MBlServer, BLSerRoleIdList, Anger, LogArgs)
             end || MBlServer <- MonBlServerL],
            %% 有伤害的都有积分奖励
            lib_c_sanctuary:update_role_score(RoleScore),
            %% 发放勋章奖励
            Args = [Scene, Monid],
            lib_c_sanctuary:send_hurt_reward(RankList, Args, MedalReward),
            %% 怪物复活时间
            case calc_mon_reborn_time(NowTime, Monid, SanMonType) of
                {true, RebornEndTime} -> skip;
                _ -> RebornEndTime = 0
            end,
            %% 更新占领积分
            if
                SanScore =/= 0 ->
                    SSanScore = maps:get({BlCamp, Scene}, SanScoreMap, 0),
                    NewSanScoreMap = maps:put({BlCamp,Scene}, SSanScore+SanScore, SanScoreMap);
                true ->
                    NewSanScoreMap = SanScoreMap
            end,
            %% 更新建筑归属，服务器积分,玩家怒气值
            NewBlCamp = cal_con_bl_server(NewSanScoreMap, Mons, Monid, ConType),
            [{TServerId, ServerNum, FRoleId, FRoleName, _}|_] = RankList,
            NewKillLog = [{TServerId, ServerNum, FRoleId, FRoleName, NowTime}|KillLog],
            RealKillLog = lists:sublist(NewKillLog, Num),
            if
                SanMonType =:= ?MONTYPE_4 orelse SanMonType == ?MONTYPE_5 orelse SanMonType == ?MONTYPE_6 ->
                    NewRef = calc_mon_reborn_ref(NowTime, RebornEndTime, OldMonRef, Monid, Scene, CopyId);
                true ->
                    NewRef = undefined
            end,
            NewHurtInfo = calc_mon_hurt_info(OldHurtInfo, ConType),
            % ?PRINT("NewHurtInfo:~p,OldHurtInfo:~p~n",[NewHurtInfo,OldHurtInfo]),
            NewMon = Mon#c_mon_state{kill_log = RealKillLog, reborn_time = RebornEndTime, rank_list = RealSendL, 
                    total_hurt = Total, reborn_ref = NewRef, mon_hurt_info = NewHurtInfo},
            NewMons = lists:keystore(Monid, #c_mon_state.mon_id, Mons, NewMon),
            BlserverL = get_server_by_point(NewBlCamp, Serverids, BeginList),
            %?PRINT(ConType == ?CONS_TYPE_1, "============ NewBlCamp:~p BlserverL:~p, MonBlServerL:~p~n",[NewBlCamp, BlserverL, MonBlServerL]),
            if
                NewBlCamp =/= 0 andalso NewBlCamp =/= ConBlCamp ->
                    %% 暂时屏蔽拍卖
                    % if
                    %     ConType == ?CONS_TYPE_1 ->
                    %         NRoleIdList = calc_real_role_list(ZoneId, BlserverL, CopyId, Santype, BeginMap, SanState);
                    %     true ->
                    %         NRoleIdList = _ServerRole
                    % end,
                    Type = all_lv,
                    case data_cluster_sanctuary:get_san_value(open_lv) of
                        LimitLv when is_integer(LimitLv) ->
                            Value = {LimitLv, 999};
                        _-> Value = {200, 999}
                    end,
                    {ok, BinData} = pt_284:write(28411, [Scene, ConType]),
                    ZoneIdL = maps:get(ZoneId, BatZoneMap, []),
                    OldInfoMap1 = maps:put({ZoneId, CopyId, Scene}, NewBlCamp, OldInfoMap),
                    Fun_info = fun(TemMapZoneId, TemMap) -> 
                        maps:put({TemMapZoneId, CopyId, Scene}, NewBlCamp, TemMap)
                    end,
                    NInfoMap = lists:foldl(Fun_info, OldInfoMap1, ZoneIdL),
                    NewInfoMap = maps:put({ZoneId, CopyId, Scene}, NewBlCamp, NInfoMap),
                    %% 保存归属信息到数据库
                    db:execute(io_lib:format(?SQL_REPLACE_SERVER_BL, [ZoneId, CopyId, Scene, NewBlCamp])),
                    [lib_c_sanctuary_api:send_to_all(NewBlserver, Type, Value, BinData) || NewBlserver <- BlserverL],
                    NewCRref = clear_user_by_calc_blserver(notify, ZoneId, BlserverL, Scene, Serverids, UserMap, 
                            SanState, BattleMap, BeginMap, ClearRoleRef),
                    PreBlCamp = ConBlCamp, NewRecieveList = [];
                true ->
                    NewCRref = undefined,
                    NewInfoMap = OldInfoMap,
                    %% 暂时屏蔽拍卖
                    % NRoleIdList = _ServerRole,
                    PreBlCamp = OConBlCamp, NewRecieveList = RecieveList
            end,
            NewCon = Construction#c_cons_state{bl_server = NewBlCamp,pre_bl_server = PreBlCamp,mon_state = NewMons,
                san_score = NewSanScoreMap, role_recieve = NewRecieveList, clear_role_ref = NewCRref},
            NewCons = lists:keystore(Scene, #c_cons_state.scene_id, Constructions, NewCon),
            NewMap = maps:put({ZoneId, CopyId}, NewCons, ConstructionsMap),
            if
                ProduceEndTime >= NowTime ->
                    {PointMap, _} = calc_point_map(OldPointMap, ZoneId, maps:to_list(NewHurtInfo), ServersInfo, BeginList, NewHurtInfo, Serverids, BatZoneMap),
                    %% 暂时屏蔽拍卖
                    % % ?PRINT("PointMap:~p~n",[PointMap]),
                    % if
                    %     ConType =/= ?CONS_TYPE_1 andalso BlCamp =/= 0 ->
                    %         ServerIdL = MonBlServerL;
                    %     true -> 
                    %         ServerIdL = BlserverL
                    % end,
                    % %% 对同阵营的每一个服都计算一次拍卖
                    % F = fun(ServerId, {Acc1, Acc2}) ->
                    %     AuctionWorth = case lists:keyfind(ServerId, 1, Acc1) of
                    %                         {_, Worth} -> Worth;
                    %                         _ -> 0
                    %                    end,
                    %     case lists:keyfind(ServerId, 1, Acc2) of
                    %         {_, ExtraS} -> ExtraS;
                    %         _ -> ExtraS = calc_default_extra_state()
                    %     end,
                    %     case lists:keyfind(ServerId, 1, NRoleIdList) of
                    %         {_, RealRoleIdList} -> skip;
                    %         _ -> RealRoleIdList = []
                    %     end,
                    %     %% 计算拍卖品，分红玩家
                    %     {ProduceType, ProduceList, NewRoleIdList, NAuctionWorth, Source} 
                    %         = calc_produce_for_auction(ZoneId, ServerId, BlCamp, NewBlCamp, ConBlCamp, ServersInfo, Scene, 
                    %             ConType, Monid, SanMonType, RealRoleIdList, PointMap, AuctionWorth, BeginList),
                    %     %% 额外拍卖产出
                    %     {ExtraProduceList, NExtraS} = calc_extra_produce(NAuctionWorth, ExtraS),
                    %     if
                    %         ProduceList == [] andalso ExtraProduceList == [] ->
                    %             ConType == ?CONS_TYPE_1 andalso NewBlCamp =/= ConBlCamp andalso
                    %               ?ERR("NRoleIdList:~p ServerId:~p RealRoleIdList:~p~n",[NRoleIdList, ServerId, RealRoleIdList]),
                    %             skip;
                    %         true ->
                    %             case data_cluster_sanctuary:get_san_value(auction_begin_time) of
                    %                 AddTime when is_integer(AddTime) -> AddTime;
                    %                 _-> AddTime = 0
                    %             end,
                    %             lib_c_sanctuary:send_auction_info(ProduceType, ServerId, 
                    %                 ProduceList++ExtraProduceList, NewRoleIdList, ProduceEndTime+AddTime, Source)
                    %     end,
                    %     {lists:keystore(ServerId, 1, Acc1, {ServerId, NAuctionWorth}), lists:keystore(ServerId, 1, Acc2, {ServerId, NExtraS})}
                    % end,
                    % {NewAuctionWorth, NewExtraS} = lists:foldl(F, {San#c_san_state.auction_worth, San#c_san_state.extra_state}, ServerIdL);
                    NewAuctionWorth = San#c_san_state.auction_worth, NewExtraS = San#c_san_state.extra_state;
                true ->
                    PointMap = OldPointMap, NewAuctionWorth = San#c_san_state.auction_worth, NewExtraS = San#c_san_state.extra_state
            end,
            NewSan = San#c_san_state{cons_state = NewMap, auction_worth = NewAuctionWorth, extra_state = NewExtraS},
            NewSanList = lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan),
            SendConstruction = NewCon#c_cons_state{
                clear_role_ref = undefined, 
                auction_reward_role = [], 
                mon_state = [
                    NewMon#c_mon_state{total_hurt = 0, reborn_ref = undefined, mon_hurt_info = #{}, update_point_time = 0}
                ]
            },
            {NewSanMap, _} = update_other_zone_data(ZoneMap, BattleMap, SanState, BatZoneMap, 
                    NewSanList, ZoneId, true, [{construction, CopyId, Santype, Scene, SendConstruction}]),
            % update_local_data(ZoneMap, BattleMap, ZoneId, CopyId, san, [NewSanList]),
            % NewSanMap = maps:put(ZoneId, NewSanList, SanState),
            {ok, Bin} = pt_284:write(28416, [Monid, RebornEndTime]),
            lib_server_send:send_to_scene(Scene, PoolId, CopyId, Bin),
            % ?MYLOG("xlh","@@@@@@@@@@@ Scene, PoolId, CopyId, Bin:~p~n",[[Scene, PoolId, CopyId, Bin]]),
            State#c_sanctuary_state{san_state = NewSanMap, point_map = PointMap, old_con_map = NewInfoMap};
        _ ->
            State
    end.

%% -----------------------------------------------------------------
%% 伤害统计，计算排名
%% -----------------------------------------------------------------
mon_hurt(State, Scene, _PoolId, CopyId, ServerId, ServerNum, Monid, RoleId, Name, Hurt) ->
    #c_sanctuary_state{
        auction_produce_time = ProduceEndTime
        , zone_map = ZoneMap
        , san_state = SanState
        , battle_map = BattleMap
        , battle_zone = BatZoneMap
        , server_info = ServerInfo
        , begin_scene_map = BeginMap
        , point_map = OldPointMap} = State,
    case lists:keyfind(ServerId, 1, ServerInfo) of
        {_, _, WorldLv,_,_} -> skip;
        _ -> WorldLv = 0
    end,
    NowTime = utime:unixtime(),
    case data_cluster_sanctuary:get_auction_by_mon(Monid, WorldLv) of
        #base_c_sanctuary_auction_boss{} when NowTime =< ProduceEndTime ->
            ZoneId = lib_clusters_center_api:get_zone(ServerId),
            {Santype, Serverids} = get_server_santype(ServerId, BattleMap, ZoneId),
            BeginList = maps:get(ZoneId, BeginMap, []),
            [Camp|_] = get_begin_scene(ServerId, BeginList, []),
            case get_mon_info(ZoneId, CopyId, Santype, Scene, Monid, SanState) of
                {true, SanList, San, ConstructionsMap, Constructions, #c_cons_state{cons_type = ConType} = Construction, Mons, 
                            #c_mon_state{mon_hurt_info = HurtInfo, update_point_time = Uptime} = Mon} when ConType =/= ?CONS_TYPE_1 ->
                    HurtInfoList = maps:get(Camp, HurtInfo, []),
                    %% 统计伤害
                    NewHurtInfoList = case lists:keyfind(RoleId, 2, HurtInfoList) of
                        {_, RoleId, _, _, OldHurt, LastHurt} ->
                            lists:keystore(RoleId, 2, HurtInfoList, {ServerNum, RoleId, Name, ServerId, OldHurt+Hurt, LastHurt});
                        _ ->
                            lists:keystore(RoleId, 2, HurtInfoList, {ServerNum, RoleId, Name, ServerId, Hurt, 0})
                    end,
                    NHurtInfoMap = maps:put(Camp, NewHurtInfoList, HurtInfo),
                    if
                        NowTime >= Uptime -> %% 每隔一段时间依据伤害计算一次贡献值
                            case data_cluster_sanctuary:get_san_value(auction_point_update_time) of
                                Upcfg when is_integer(Upcfg) andalso Upcfg>0 -> Upcfg;
                                _ -> Upcfg = 60
                            end,
                            NewUptime = NowTime + Upcfg,
                            {PointMap, NewHurtInfoMap} = calc_point_map(OldPointMap, ZoneId, maps:to_list(NHurtInfoMap), ServerInfo, BeginList, NHurtInfoMap, Serverids, BatZoneMap);
                        true ->
                            NewUptime = Uptime,
                            NewHurtInfoMap = NHurtInfoMap,
                            PointMap = OldPointMap
                    end,
                    NewMon = Mon#c_mon_state{mon_hurt_info = NewHurtInfoMap, update_point_time = NewUptime},
                    NewMons = lists:keystore(Monid, #c_mon_state.mon_id, Mons, NewMon),
                    NewCon = Construction#c_cons_state{mon_state = NewMons},
                    NewCons = lists:keystore(Scene, #c_cons_state.scene_id, Constructions, NewCon),
                    NewMap = maps:put({ZoneId, CopyId}, NewCons, ConstructionsMap),
                    NewSan = San#c_san_state{cons_state = NewMap},
                    NewSanList = lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan),
                    {NewSanMap, _} = update_other_zone_data(ZoneMap, BattleMap, SanState, BatZoneMap, 
                            NewSanList, ZoneId, false, []),
                    % NewSanMap = maps:put(ZoneId, NewSanList, SanState),
                    % {true, _, _, _, _, _, _, 
                    %         #c_mon_state{mon_hurt_info = OOOHurtInfo}} = get_mon_info(ZoneId, CopyId, Santype, Scene, Monid, NewSanMap), 
                    State#c_sanctuary_state{san_state = NewSanMap, point_map = PointMap};
                _ ->
                    State
            end;
        _ ->
            State
    end.

%% -----------------------------------------------------------------
%% 伤害排名通知
%% -----------------------------------------------------------------
send_rank(Scene, PoolId, CopyId, RealSendL, Monid, State) ->
    % %?MYLOG("xlh","@@@@@@@@@@@ send_rank RealSendL:~p,Monid:~p~n",[RealSendL,Monid]),
    {ok, Bin} = pt_284:write(28403, [Monid, RealSendL]),
    case data_cluster_sanctuary:get_mon_cfg(Monid) of
        #base_san_mon{x = X, y = Y} ->skip;
        _ -> ?ERR("mod_c_sanctuary lost cfg Monid:~p~n",[Monid]),X=0,Y=0
    end,
    lib_server_send:send_to_area_scene(Scene, PoolId, CopyId, X, Y, Bin),
    % mod_clusters_center:apply_cast(Node, lib_server_send, player_change_scene, []);
    %?MYLOG("xlh","@@@@@@@@@@@ send_rank RealSendL:~p~n",[RealSendL]),
    % lib_server_send:send_to_scene(Scene, PoolId, CopyId, Bin),
    State.

%% -----------------------------------------------------------------
%% 怒气清理
%% -----------------------------------------------------------------
role_anger_clear(State) ->
    #c_sanctuary_state{role_anger_ref = OClearRef} = State,
    util:cancel_timer(OClearRef),
    NowTime = utime:unixtime(),
    ClearTime = calc_role_clear_time(NowTime+60),
    %?MYLOG("xlh_clear","ClearTime:~p~n",[ClearTime]),
    mod_clusters_center:apply_to_all_node(lib_c_sanctuary, clear_role_anger, [], 20),
    % lib_c_sanctuary:clear_role_anger(),
    ClearRef = erlang:send_after(max((ClearTime-NowTime)*1000, 5000), self(), 'role_anger_clear'),
    State#c_sanctuary_state{role_anger_ref = ClearRef}.

%% -----------------------------------------------------------------
%% 退出
%% -----------------------------------------------------------------
exit(State, ServerId, RoleId, Scene) ->
    #c_sanctuary_state{join_map = Jmap, scene_user = UserMap, begin_scene_map = BeginMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    BeginList = maps:get(ZoneId, BeginMap, []),
    [Camp|_] = get_begin_scene(ServerId, BeginList, []),
    JoinNum = maps:get({Camp, ServerId, Scene}, Jmap, 0),
    NewJoinNum = if %% 更新参与人数
        JoinNum - 1 >= 0 ->
            JoinNum - 1;
        true ->
            0
    end,

    NewJoinMap = maps:put({Camp, ServerId, Scene}, NewJoinNum, Jmap),
    UserList = maps:get({ZoneId, ServerId, Scene}, UserMap, []),
    NewUlist = lists:delete(RoleId, UserList),
    NewUmap = maps:put({ZoneId, ServerId, Scene}, NewUlist, UserMap),
    %?MYLOG("xlh","@@@@@@@@@@@ exit NewUmap:~p,NewJoinMap:~p~n",[NewUmap,NewJoinMap]),
    update_local_data(ServerId, join, [NewJoinMap]),
    State#c_sanctuary_state{join_map = NewJoinMap, scene_user = NewUmap}.

%% -----------------------------------------------------------------
%% 重连 更新参与人数，计算死亡buff等
%% -----------------------------------------------------------------
reconect(State, ServerId, RoleId, Scene, {Args, Args2}) ->
    #c_sanctuary_state{battle_map = BattleMap, san_state = SanState, begin_scene_map = BeginMap, 
            join_map = _Jmap, scene_user = _UserMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    BeginList = maps:get(ZoneId, BeginMap, []),
    PointList = get_begin_scene(ServerId, BeginList, []),
    Fun = fun(TemPoint, Acc) ->
        TSceneL = data_cluster_sanctuary:get_can_enter_scenes(TemPoint),
        Acc ++ TSceneL
    end,
    SceneL = lists:foldl(Fun, [], PointList),
    IsbeginScene = case lists:member(Scene, SceneL) of
                true ->
                    true;
                _ -> false
            end,
    BlsceneL = calc_server_all_construction(ZoneId, ServerId, SanState, BattleMap, BeginList),
    Canenter = calc_can_enter(Scene, SceneL, BlsceneL),
    CanEnterScene = 
        if
            IsbeginScene == true ->
                true;
            Canenter == true ->
                true;
            true -> false
        end,
    if
        CanEnterScene == true ->
            % JoinNum = maps:get({ServerId,Scene}, Jmap, 0),
            % NewJoinNum = JoinNum + 1,
            % NewJoinMap = maps:put({ServerId,Scene}, NewJoinNum, Jmap),
            % UserList = maps:get({ZoneId, ServerId, Scene}, UserMap, []),
            % NewUlist = [RoleId|UserList],
            % NewUmap = maps:put({ZoneId, ServerId, Scene}, NewUlist, UserMap),
            if
                Args =/= [] andalso Args2 =/= [] ->
                    % lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, update_player_picture_online, [Picture, PictureVer])
                    % lib_c_sanctuary, notify_re_login, [RoleId, Args, Args2]
                    PlayerArgs = [RoleId, ?APPLY_CAST_STATUS, lib_c_sanctuary, notify_re_login, [Args, Args2]],
                    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, PlayerArgs);
                true ->
                    mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_relogin_scene,[RoleId, []])
            end,
            % State#c_sanctuary_state{join_map = NewJoinMap, scene_user = NewUmap};
            State;
        true ->
            mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_default_scene,
                            [RoleId, [{change_scene_hp_lim, 100},{ghost, 0},{pk, {?PK_PEACE, true}}]]),
            State
    end.

%% -----------------------------------------------------------------
%% 领取建筑归属奖励
%% -----------------------------------------------------------------
recieve_bl_reward(State, RoleId, ServerId, Node, Scene) ->
    NowTime = utime:unixtime(),
    #c_sanctuary_state{zone_map = ZoneMap, san_state = SanState, battle_map = BattleMap, 
        server_info = ServerInfo, begin_scene_map = BeginMap, battle_zone = BatZoneMap} = State,
    % ?PRINT("@@@@@@@@@@@@@@  ServerId:~p~n",[ServerId]),
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {Santype, [H|_] = EnemyServerIds} = get_server_santype(ServerId, BattleMap, ZoneId),
    SanList = maps:get(ZoneId, SanState, []),
    BeginList = maps:get(ZoneId, BeginMap, []),
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} = San ->
            Constructions = maps:get({ZoneId,H}, ConstructionsMap, []),
            case lists:keyfind(Scene, #c_cons_state.scene_id, Constructions) of
                #c_cons_state{bl_server = BlCamp, cons_type = ConType, role_recieve = RecieveList} = Construction -> 
                    case lists:keyfind(RoleId, 1, RecieveList) of
                        {RoleId, _Time} -> 
                            NewRecieveList = RecieveList,
                            {ok, BinData} = pt_284:write(28408, [Scene, ?ERRCODE(has_recieve)]);
                            % lib_server_send:send_to_uid(RoleId, BinData);
                        _ -> 
                            BlserverL = get_server_by_point(BlCamp, EnemyServerIds, BeginList),
                            case lists:member(ServerId, BlserverL) of
                                true ->
                                    NewRecieveList = lists:keystore(RoleId, 1, RecieveList, {RoleId, NowTime}),
                                    case lists:keyfind(ServerId, 1, ServerInfo) of
                                        {ServerId, _, WorldLv,_,_} -> skip;
                                        _ -> WorldLv = 0
                                    end,
                                    case data_cluster_sanctuary:get_reward_world_lv(WorldLv, ConType) of
                                        [{_,_,_}] = Reward ->
                                            Args = [Santype, Scene, ConType, BlCamp],
                                            lib_c_sanctuary:send_c_reward(Node, RoleId, Reward, kf_sanctuary_con_bl, Args);
                                        _ ->
                                            ?ERR("LOST CFG Construction type:~p~n",[ConType]),skip
                                    end,
                                    {ok, BinData} = pt_284:write(28408, [Scene, 1]);
                                    % lib_server_send:send_to_uid(RoleId, BinData);
                                _ ->
                                    NewRecieveList = RecieveList,
                                    {ok, BinData} = pt_284:write(28408, [Scene, ?ERRCODE(not_achieve)])
                                    % lib_server_send:send_to_uid(RoleId, BinData)
                            end
                    end,
                    % ?PRINT("@@@@@@@@@@@ recieve_bl_reward 28408 1111:~p~n",[1]),
                    lib_c_sanctuary_api:send_to_role(Node, RoleId, BinData),
                    if
                        NewRecieveList == RecieveList ->
                            NewSanMap = SanState;
                        true ->
                            NewConstruction = Construction#c_cons_state{role_recieve = NewRecieveList},
                            NewCons = lists:keystore(Scene, #c_cons_state.scene_id, Constructions, NewConstruction),
                            ConsMap = maps:put({ZoneId,H}, NewCons, ConstructionsMap),
                            NewSan = San#c_san_state{cons_state = ConsMap},
                            NewSanList = lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan),
                            {NewSanMap, _} = update_other_zone_data(ZoneMap, BattleMap, SanState, BatZoneMap, NewSanList, 
                                ZoneId, true, [{role_recieve, H, Santype, Scene, [{RoleId, NowTime}]}])
                    end;
                    % update_local_data(ZoneMap, BattleMap, ZoneId, ServerId, san, [NewSanList]),
                    % NewSanMap = maps:put(ZoneId, NewSanList, SanState);
                _ -> 
                    NewSanMap = SanState
            end;
        _ -> 
            NewSanMap = SanState
    end,
    % ?PRINT("@@@@@@@@@@@ recieve_bl_reward 28408 1111:~p~n",[2]),
    State#c_sanctuary_state{san_state = NewSanMap}.

%% -----------------------------------------------------------------
%% 怪物击杀记录
%% -----------------------------------------------------------------    
get_mon_pk_log(State, ServerId, Node, RoleId, Scene, MonId) ->
    #c_sanctuary_state{san_state = SanState, battle_map = BattleMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {Santype, [CopyId|_]} = get_server_santype(ServerId, BattleMap, ZoneId),
    case get_mon_info(ZoneId, CopyId, Santype, Scene, MonId, SanState) of
        {true, _SanList, _San, _ConstructionsMap, _Constructions, _Construction, _Mons, 
                #c_mon_state{kill_log = KillLog}} ->
            {ok, BinData} = pt_284:write(28412, [Scene, MonId, KillLog]),
            %?MYLOG("xlh","@@@@@@@@@@@ get_mon_pk_log 28412 KillLog:~p Scene:~p, MonId:~p~n",[KillLog,Scene, MonId]),
            lib_c_sanctuary_api:send_to_role(Node, RoleId, BinData);
        _ ->
            {ok, BinData} = pt_284:write(28412, [Scene, MonId, []]),
            %?MYLOG("xlh","@@@@@@@@@@@ get_mon_pk_log 28412 KillLog:~p,Scene:~p, MonId:~p~n",[[],Scene, MonId]),
            lib_c_sanctuary_api:send_to_role(Node, RoleId, BinData)
    end,
    State.

%% -----------------------------------------------------------------
%% 清理场景玩家
%% -----------------------------------------------------------------
clear_scene_role(State, ZoneId, ServerId, Scene) ->
    #c_sanctuary_state{zone_map = ZoneMap, san_state = SanState, battle_map = BattleMap, 
        scene_user = UserMap, begin_scene_map = BeginMap, battle_zone = BatZoneMap} = State,
    {Santype, Serverids} = get_server_santype(ServerId, BattleMap, ZoneId),
    case get_scene_info(ZoneId, ServerId, Santype, Scene, SanState) of
        {true, San, SanList, ConstructionsMap, Constructions, #c_cons_state{bl_server = BlCamp,
        clear_role_ref = OldRef} = Construction} ->

            BeginList = maps:get(ZoneId, BeginMap, []),
            BlserverL = get_server_by_point(BlCamp, Serverids, BeginList),

            NewRef = clear_user_by_calc_blserver(clear, ZoneId, BlserverL, Scene, Serverids, 
                    UserMap, SanState, BattleMap, BeginMap, OldRef),
            NewCon = Construction#c_cons_state{clear_role_ref = NewRef},
            NewCons = lists:keystore(Scene, #c_cons_state.scene_id, Constructions, NewCon),
            NewMap = maps:put({ZoneId, ServerId}, NewCons, ConstructionsMap),
            NewSan = San#c_san_state{cons_state = NewMap},
            NewSanList = lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan),
            {NewSanMap, _} = update_other_zone_data(ZoneMap, BattleMap, SanState, BatZoneMap, NewSanList, ZoneId, false, []),
            % update_local_data(ZoneMap, BattleMap, ZoneId, ServerId, san, [NewSanList]),
            % NewSanMap = maps:put(ZoneId, NewSanList, SanState),
            State#c_sanctuary_state{san_state = NewSanMap};
        _ ->
            State
    end.

%% -----------------------------------------------------------------
%% 生成和平怪
%% -----------------------------------------------------------------
mon_create_peace(State, MonId, Scene, CopyId) ->
    #c_sanctuary_state{
            zone_map = ZoneMap,
            san_state = SanState, 
            server_info = ServerInfo,
            battle_zone = BatZoneMap, 
            battle_map = BattleMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(CopyId),
    {Santype, Serverids} = get_server_santype(CopyId, BattleMap, ZoneId),
    case get_mon_info(ZoneId, CopyId, Santype, Scene, MonId, SanState) of
        {true, SanList, San, ConstructionsMap, Constructions, Construction, Mons, #c_mon_state{reborn_ref = OldMonRef}} ->
            WorldLv = calc_average_lv(Serverids, ServerInfo),
            case data_mon:get(MonId) of
                [] -> MonType = 1;
                #mon{type = MonType} -> ok
            end,
            util:cancel_timer(OldMonRef),
            NewMons = mon_create_core_2(MonId, CopyId, WorldLv, Mons, MonType, peace, 0),
            NewCon = Construction#c_cons_state{mon_state = NewMons},
            NewCons = lists:keystore(Scene, #c_cons_state.scene_id, Constructions, NewCon),
            NewMap = maps:put({ZoneId, CopyId}, NewCons, ConstructionsMap),
            NewSan = San#c_san_state{cons_state = NewMap},
            NewSanList = lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan),
            % update_local_data(ZoneMap, BattleMap, ZoneId, CopyId, san, [NewSanList]),
            % NewSanMap = maps:put(ZoneId, NewSanList, SanState),
            NewMon = lists:keyfind(MonId, #c_mon_state.mon_id, Mons),
            {NewSanMap, _} = update_other_zone_data(ZoneMap, BattleMap, SanState, BatZoneMap, NewSanList, 
                ZoneId, true, [{mons, CopyId, Santype, Scene, NewMon}]),
            {ok, Bin} = pt_284:write(28416, [MonId, 0]),
            lib_server_send:send_to_scene(Scene, 0, CopyId, Bin),
            State#c_sanctuary_state{san_state = NewSanMap};
        _ ->
            State
    end.

%% -----------------------------------------------------------------
%% 本地服数据初始化回调
%% -----------------------------------------------------------------
local_init(State, ServerId) ->
    #c_sanctuary_state{
            san_state = SanState, 
            server_info = ServerInfo, 
            battle_map = BattleMap,
            join_map = JoinMap,
            begin_scene_map = BeginMap,
            act_start_time = BeginTime,
            act_end_time = EndTime,
            point_map = PointMap,
            auction_produce_time = ProduceEndTime} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {Santype, EnemyServerIds} = get_server_santype(ServerId, BattleMap, ZoneId),
    SanList = maps:get(ZoneId, SanState, []),
    BeginList = maps:get(ZoneId, BeginMap, []),

    BeginList = maps:get(ZoneId, BeginMap, []),
    [BlCamp|_] = get_begin_scene(ServerId, BeginList, []),

    PointList = maps:get({ZoneId, BlCamp}, PointMap, []),
    mod_clusters_center:apply_cast(ServerId, mod_c_sanctuary_local, init_after, 
            [ZoneId, SanList, Santype, EnemyServerIds, BeginList, ServerInfo, BeginTime, EndTime, JoinMap, PointList, ProduceEndTime]),
    % mod_c_sanctuary_local:init_after(ZoneId, SanList, Santype, EnemyServerIds, BeginList, ServerInfo, BeginTime, EndTime),
    State.

%% -----------------------------------------------------------------
%% 生成怪物的时候清理玩家
%% -----------------------------------------------------------------
clear_user_mon_create(State, ServerUserList, Scene, Type) ->
    #c_sanctuary_state{
            san_state = SanState,
            begin_scene_map = BeginMap,
            battle_map = BattleMap} = State,
    Fun = fun({ServerId, UserIds}) ->
        ZoneId = lib_clusters_center_api:get_zone(ServerId),
        BeginList = maps:get(ZoneId, BeginMap, []),
        BlsceneL = calc_server_all_construction_2(ZoneId, ServerId, SanState, BattleMap, BeginList),
        PointList = get_begin_scene(ServerId, BeginList, []),
        Fun = fun(TemPoint, Acc) ->
            TSceneL = data_cluster_sanctuary:get_can_enter_scenes(TemPoint),
            Acc ++ TSceneL
        end,
        SceneL = lists:foldl(Fun, [], PointList),
        Canenter = calc_can_enter(Scene, SceneL, BlsceneL),
        IsbeginScene = lists:member(Scene, SceneL),
        if
            Type == gm ->
                mod_clusters_center:apply_cast(ServerId, lib_c_sanctuary, clear_scene_user, [UserIds, ServerId]);
            IsbeginScene == false andalso Canenter == false ->
                mod_clusters_center:apply_cast(ServerId, lib_c_sanctuary, clear_scene_user, [UserIds]);
            true ->
                skip
        end
    end,
    lists:foreach(Fun, ServerUserList),
    State.

%% -----------------------------------------------------------------
%% 击杀对手服务器玩家增加贡献值
%% -----------------------------------------------------------------        
kill_player(State, _SceneId, _CopyId, ServerId, ServerNum, RoleId, RoleName, HitIdList) ->
    #c_sanctuary_state{auction_produce_time = ProduceEndTime, san_state = _SanState, point_map = PointMap, begin_scene_map = BeginMap} = State,
    NowTime = utime:unixtime(),
    % ?PRINT("========= ServerId:~p,NowTime:~p~n",[ServerId,NowTime]),
    if
        NowTime > ProduceEndTime ->
            State;
        true ->
            ZoneId = lib_clusters_center_api:get_zone(ServerId),
            case data_cluster_sanctuary:get_san_value(auction_kill_player_add) of
                KillAddPoint when is_integer(KillAddPoint) -> KillAddPoint;
                _ -> KillAddPoint = 0
            end,
            BeginList = maps:get(ZoneId, BeginMap, []),
            [Camp|_] = get_begin_scene(ServerId, BeginList, []),
            ServerL = get_server_by_point(Camp, ServerId, BeginList),

            PointList = maps:get({ZoneId, Camp}, PointMap, []),
            case lists:member(RoleId, HitIdList) of
                true ->
                    RoleIdList = HitIdList;
                _ ->
                    RoleIdList = [RoleId|HitIdList]
            end,
            Fun = fun(TemRoleId, Acc) ->
                case lists:keyfind(TemRoleId, 2, Acc) of
                    {_, _, _, _, Killpoint, BossPoint, Total} ->
                        lists:keystore(TemRoleId, 2, Acc, {ServerNum, TemRoleId, RoleName, ServerId, Killpoint + KillAddPoint, BossPoint, Total+KillAddPoint});
                    _ ->
                        lists:keystore(TemRoleId, 2, Acc, {ServerNum, TemRoleId, RoleName, ServerId, KillAddPoint, 0, KillAddPoint})
                end
            end,
            NewPointList = lists:foldl(Fun, PointList, RoleIdList),
            NewPointMap = maps:put({ZoneId, Camp}, NewPointList, PointMap),
            % ?PRINT("NewPointList:~p,RoleIdList:~p,KillAddPoint:~p~n",[NewPointList,RoleIdList,KillAddPoint]),
            [update_local_data(TemServer, point, [NewPointList]) || TemServer <- ServerL],

            State#c_sanctuary_state{point_map = NewPointMap}
    end.
    

%==========================================分割线========================================================
%%                                     函    数    库  
%========================================================================================================      
%% -----------------------------------------------------------------
%% 计算建筑归属后清除玩家（无归属且前置场景未获得归属/暂由占领）
%% -----------------------------------------------------------------
clear_user_by_calc_blserver(Sign, ZoneId, BlServerL, Scene, [Hs|_] = Serverids, UserMap, SanState, BattleMap, BeginMap, ClearRoleRef) ->
    SceneList = data_cluster_sanctuary:get_can_enter_scenes(Scene),
    BeginList = maps:get(ZoneId, BeginMap, []),
    case data_cluster_sanctuary:get_san_value(clear_role_after_scene_bl) of
        Value when is_integer(Value) ->skip; 
        _-> Value = 30
    end,
    util:cancel_timer(ClearRoleRef),
    NowTime = utime:unixtime(),
    if
        Sign == notify ->
            NewRef = erlang:send_after(max(Value, 1)*1000, self(), {'clear_scene_role', ZoneId, Hs, Scene});
        true ->
            NewRef = undefined
    end,
    Fun = fun(ServerId) ->
        case lists:member(ServerId, BlServerL) of
            false -> %% 非归属阵营服务器
                BlsceneL1 = calc_server_all_construction(ZoneId, ServerId, SanState, BattleMap, BeginList),
                BlsceneL = 
                    if
                        Sign == notify -> %% 此时SanState里面的数据不是最新的，所以要将此场景移除
                            lists:keydelete(Scene, 1, BlsceneL1);
                        true -> 
                            BlsceneL1
                    end,
                PointList = get_begin_scene(ServerId, BeginList, []),
                F2 = fun(TemPoint, Acc) ->
                    TSceneL = data_cluster_sanctuary:get_can_enter_scenes(TemPoint),
                    Acc ++ TSceneL
                end,
                SceneL = lists:foldl(F2, [], PointList),
                F1 = fun(TemScene, Acc) ->
                    case lists:member(TemScene, SceneL) of
                        true ->
                            Acc;
                        _ -> 
                            Canenter = calc_can_enter(TemScene, SceneL, BlsceneL),
                            if
                                Canenter == true ->
                                    Acc;
                                true -> 
                                    UserList = maps:get({ZoneId, ServerId, TemScene}, UserMap, []),
                                    UserList++Acc
                            end
                    end
                end,
                %% 筛选所有与占领场景关联的场景中需要清理的玩家
                UserIds = lists:foldl(F1, [], SceneList),
                if
                    UserIds =/= [] andalso Sign == notify ->
                        mod_clusters_center:apply_cast(ServerId, lib_c_sanctuary, notify_scene_user, [UserIds, NowTime+Value]);
                    UserIds =/= [] andalso Sign == clear ->
                        mod_clusters_center:apply_cast(ServerId, lib_c_sanctuary, clear_scene_user, [UserIds]);
                    true ->
                        skip
                end;
            _ ->
                skip
        end
    end,
    lists:foreach(Fun, Serverids),
    NewRef.

%% -----------------------------------------------------------------
%% 统计归属场景（占领，暂由占领都算）
%% -----------------------------------------------------------------
calc_server_all_construction(ZoneId, ServerId, SanState, BattleMap, BeginList) ->
    {Santype, [H|_]} = get_server_santype(ServerId, BattleMap, ZoneId),
    SanList = maps:get(ZoneId, SanState, []),
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} -> ConstructionsMap;
        _ -> ConstructionsMap = #{}
    end,
    Constructions = maps:get({ZoneId,H}, ConstructionsMap, []),
    [Camp|_] = get_begin_scene(ServerId, BeginList, []),
    Fun = fun(Construction, Acc) ->
        #c_cons_state{scene_id = Scene,cons_type= ConType, bl_server = BlCamp, 
                pre_bl_server = PreBlCamp} = Construction,
        if
            BlCamp == Camp orelse (PreBlCamp == Camp andalso BlCamp == 0) ->
                [{Scene, ConType, ServerId}|Acc];
            true ->
                Acc
        end
    end,
    lists:foldl(Fun, [], Constructions).

%% -----------------------------------------------------------------
%% 统计归属场景（怪物生成时使用）
%% -----------------------------------------------------------------
calc_server_all_construction_2(ZoneId, ServerId, SanState, BattleMap, BeginList) ->
    {Santype, [H|_]} = get_server_santype(ServerId, BattleMap, ZoneId),
    SanList = maps:get(ZoneId, SanState, []),
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} -> ConstructionsMap;
        _ -> ConstructionsMap = #{}
    end,
    Constructions = maps:get({ZoneId,H}, ConstructionsMap, []),
    [Camp|_] = get_begin_scene(ServerId, BeginList, []),
    Fun = fun(Construction, Acc) ->
        #c_cons_state{scene_id = Scene,cons_type= ConType, bl_server = BlCamp, pre_bl_server = PreBlCamp} = Construction,
        if
            PreBlCamp == Camp andalso BlCamp == 0 ->
                [{Scene, ConType, ServerId}|Acc];
            true ->
                Acc
        end
    end,
    lists:foldl(Fun, [], Constructions).

%% -----------------------------------------------------------------
%% @doc      判断场景是否可以进入
-spec calc_can_enter(Scene, SceneL, BlsceneL) ->  Return when
    Scene       :: integer(),               %% 场景id
    SceneL      :: list(),                  %% 初始分配场景（要塞）列表
    BlsceneL    :: list(),                  %% 占领场景/暂由占领场景列表
    Return      :: true | false.            %% 返回值描述
%% -----------------------------------------------------------------
calc_can_enter(Scene, SceneL, BlsceneL) ->
    RealBlsceneL = calc_can_enter_core(SceneL, BlsceneL, []),
    case lists:member(Scene, RealBlsceneL) of
        true ->
            true;
        _ ->
            calc_can_enter_helper(RealBlsceneL, Scene)
    end.

calc_can_enter_helper([], _Scene) -> false;
calc_can_enter_helper([TemScene|T], Scene) ->
    SceneList = data_cluster_sanctuary:get_can_enter_scenes(TemScene),
    case lists:member(Scene, SceneList) of
        true ->
            true;
        _ ->
            calc_can_enter_helper(T, Scene)
    end.

%% -----------------------------------------------------------------
%% 从起点开始计算可以进入的场景
%% -----------------------------------------------------------------
calc_can_enter_core([], _, RealBlScene) -> RealBlScene;
calc_can_enter_core(SceneL, BlsceneL, OutScene) ->
    Fun = fun(SceneId, Acc) ->
        case lists:keyfind(SceneId, 1, BlsceneL) of
            {SceneId, _ConType, _ServerId} -> [SceneId|Acc];
            _ -> Acc
        end
    end,
    FirstScene = lists:foldl(Fun, OutScene, SceneL),
    F1 = fun(SceneId, Acc) ->
        case lists:member(SceneId, OutScene) of
            false ->
                SceneList = data_cluster_sanctuary:get_can_enter_scenes(SceneId),
                Acc++SceneList;
            _ ->
                Acc
        end
    end,
    TemScene = lists:foldl(F1, [], FirstScene),
    calc_can_enter_core(TemScene, BlsceneL, FirstScene).

%% -----------------------------------------------------------------
%% 分配初始场景
%% -----------------------------------------------------------------
divide_begin_scene(BattleMap, BatZoneMap) ->
    BattleList = maps:to_list(BattleMap), 
    Fun = fun({ZoneId, BattleServerList}, {TemMap, TemMap1}) ->
        Fun1 = fun({Santype, List}, TemAcc) ->
            divide_begin_scene_helper(Santype, List, TemAcc)
        end,
        DivideScene = lists:foldl(Fun1, [], BattleServerList),
        case maps:get(ZoneId, TemMap1, []) of
            ZoneIdList when ZoneIdList =/= [] andalso is_list(ZoneIdList) ->
                F = fun(Zone, {TMap, TMap1}) ->
                    {maps:put(Zone, DivideScene, TMap), maps:remove(Zone, TMap1)}
                end,
                lists:foldl(F, {TemMap, TemMap1}, ZoneIdList);
            _ ->
                {maps:put(ZoneId, DivideScene, TemMap), TemMap1}
        end;
        (_, Tem) -> Tem
    end,
    {Res, _} = lists:foldl(Fun, {#{}, BatZoneMap}, BattleList),
    Res.

%% -----------------------------------------------------------------
%% 不同圣域模式的起点配置
%% -----------------------------------------------------------------
get_begin_point_cfg(Santype) ->
    if
        Santype == ?SANTYPE_1 ->
            data_cluster_sanctuary:get_san_value(san_type1_begin_point);
        Santype == ?SANTYPE_2 ->
            data_cluster_sanctuary:get_san_value(san_type2_begin_point);
        Santype == ?SANTYPE_3 ->
            data_cluster_sanctuary:get_san_value(san_type3_begin_point);
        Santype == ?SANTYPE_4 ->
            data_cluster_sanctuary:get_san_value(san_type4_begin_point);
        Santype == ?SANTYPE_5 ->
            data_cluster_sanctuary:get_san_value(san_type4_begin_point);
        true ->
            []
    end.

divide_begin_scene_helper(_Santype, [], Acc) -> Acc;
divide_begin_scene_helper(Santype, [H|T], Acc) ->
    VillSceneL = get_begin_point_cfg(Santype),
    NewAcc = divide_begin_scene_core(VillSceneL, H, Acc),
    divide_begin_scene_helper(Santype, T, NewAcc).

divide_begin_scene_core(_, [], Acc) ->Acc;
divide_begin_scene_core([], _, Acc) -> 
    ?ERR("divide_begin_scene_core error because of bad value in cfg, Santype VillSceneL ~p~n",[1]),Acc;
divide_begin_scene_core([HV|VillSceneL], [HS|Serverids], Acc) ->
    NewAcc = lists:keystore(HS, 1, Acc, {HS, HV}),
    divide_begin_scene_core(VillSceneL, Serverids, NewAcc).

%% -----------------------------------------------------------------
%% 计算建筑归属
%% -----------------------------------------------------------------
cal_con_bl_server(SanScoreMap, Mons, MonId, ConType) ->
    SanScoreList = maps:to_list(SanScoreMap),
    SanScoreList_1 = lists:reverse(lists:keysort(2, SanScoreList)),
    ResetScore = get_reset_mon_san_score(Mons, 0, MonId, ConType),
    case SanScoreList_1 of
        [H1,H2|_] -> %% 第一名积分减去第二名积分超过剩余积分，归属确定
            {{Camp, _}, Score1} = H1,
            {_, Score2} = H2,
            if
                Score1 - Score2 >= ResetScore ->
                    BlCamp = Camp;
                true -> BlCamp = 0
            end;
        [H1] -> %% 第一名积分超过剩余积分，归属确定
            {{Camp, _}, Score1} = H1,
            if
                Score1 >= ResetScore ->
                    BlCamp = Camp;
                true -> BlCamp = 0
            end;
        _->
            BlCamp = 0
    end,
    BlCamp.

%% -----------------------------------------------------------------
%% 获取活着的怪物圣域积分
%% -----------------------------------------------------------------
get_reset_mon_san_score([], Total, _, _) -> Total;
get_reset_mon_san_score([M|Mons], Total, MonId, ConType) ->
    #c_mon_state{mon_id = Tmid, reborn_time = RebornTime,mon_type = MonType} = M,
    case RebornTime == 0 andalso Tmid =/= MonId of
        true ->
            case data_cluster_sanctuary:get_mon_type(MonType, ConType) of
                #base_san_mon_type{san_score = SanScore} ->skip;
                _ -> 
                    SanScore =0,
                    ?ERR("error cfg get_mon_type when MonType:~p~n",[MonType])
            end,
            NewTotal = Total + SanScore;
        _ ->
            NewTotal = Total
    end,
    get_reset_mon_san_score(Mons, NewTotal, MonId, ConType).

get_all_mon_info([], Acc) -> Acc;
get_all_mon_info([M|T], Acc) ->
    #c_mon_state{mon_id = Monid,reborn_time = RebornTime,mon_type = MonType, mon_lv = MonLv} = M,
    NewAcc = [{Monid,MonType,MonLv,RebornTime}|Acc],
    get_all_mon_info(T, NewAcc).

%% 获取开服天数
get_open_day(OpenTime) ->
    Now = utime:unixtime(),
    Day = (Now - OpenTime) div 86400,
    Day + 1.


%% -----------------------------------------------------------------
%% 为相同区的服务器计算圣域模式，分配对手服务器
%% -----------------------------------------------------------------
handle_servers(Serverids, ServersInfo, CampRecord) ->
    {HasEnter, Santype} = judge_has_enter_camp(Serverids, CampRecord, ServersInfo),
    % ?MYLOG("xlh", "HasEnter:~p, Santype:~p~n",[HasEnter, Santype]),
    if
        HasEnter == false -> %% 之前进入过阵营模式无论配置是什么，之后也还是阵营模式
            {FirstDivideL, ClusterL} = handle_servers_core(Serverids, ServersInfo, CampRecord),
            % ?MYLOG("xlh", "ClusterL:~p,FirstDivideL:~p~n",[ClusterL, FirstDivideL]),
            {FirstDivide, ClusterList} = calc_new_first_divide(FirstDivideL, ClusterL);
        true ->
            FirstDivide = [],
            ClusterList = [{max(Santype, ?SANTYPE_4), Serverids}]
    end,
    Fun1 = fun({Santype1, ServerInfoList1}, {Acc1, Acc2}) ->
        % SfType = ulists:list_shuffle(ServerIdList1),
        ServerInfoList2 = Acc2 ++ ServerInfoList1,
        hand_san_server(Santype1, lists:reverse(lists:keysort(2, ServerInfoList2)), Acc1)
    end,
    {ResList, _} = lists:foldl(Fun1, {[], []}, lists:reverse(lists:keysort(1, FirstDivide))),
    NewCampRecord = calc_new_camp_recored(ResList, CampRecord),
    {ResList, ClusterList, NewCampRecord}.

handle_servers(Serverids, ServersInfo, OldList, CampRecord) ->
    {HasEnter, Santype1} = judge_has_enter_camp(Serverids, CampRecord, ServersInfo),
    if
        HasEnter == false ->
            {FirstDivideL, ClusterL} = handle_servers_core(Serverids, ServersInfo, CampRecord),
            {FirstDivide, ClusterList} = calc_new_first_divide(FirstDivideL, ClusterL);
        true ->
            FirstDivide = [],
            ClusterList = [{max(Santype1, ?SANTYPE_4), Serverids}]
    end,
    Fun1 = fun({Santype, ServerInfoList1}, {Acc1, Acc2}) ->
        ServerIdList = [ServerId||{ServerId, _, _, _} <- ServerInfoList1],
        SType = lists:sort(ServerIdList),
        case lists:keyfind(Santype, 1, OldList) of
            {_, OList} ->
                FOlist = lists:sort(lists:flatten(OList)),
                if
                    SType == FOlist -> %% 与之前的分配对比，相同不做处理
                        {OldList, Acc2};
                    true ->
                        ServerInfoList2 = Acc2 ++ ServerInfoList1,
                        hand_san_server(Santype, lists:reverse(lists:keysort(2, ServerInfoList2)), Acc1)
                end;
            _ ->
                ServerInfoList2 = Acc2 ++ ServerInfoList1,
                hand_san_server(Santype, lists:reverse(lists:keysort(2, ServerInfoList2)), Acc1)
        end
    end,
    % ?MYLOG("xlh", "FirstDivide:~p~n",[FirstDivide]),
    {ResList, _} = lists:foldl(Fun1, {[], []}, lists:reverse(lists:keysort(1, FirstDivide))),
    NewCampRecord = calc_new_camp_recored(ResList, CampRecord),
    {ResList, ClusterList, NewCampRecord}.

handle_servers_core(Serverids, ServersInfo, CampRecord) ->
    Fun = fun(ServerId, {Acc, Acc1}) ->
        case lists:keyfind(ServerId, 1, ServersInfo) of
            {ServerId, OpenTime, WorldLv, _, _} -> skip;
            _ -> 
                ?ERR("no such ServerId:~p infomation in ServersInfo:~p~n", [ServerId, ServersInfo]),
                OpenTime = 0, WorldLv = 0
        end,
        OpenDay = get_open_day(OpenTime),
        % ?MYLOG("xlh", "ServerId:~p, OpenDay:~p~n",[ServerId, OpenDay]),
        case calc_server_santype(CampRecord, ServerId, OpenDay) of
            {Santype, IsOldSantype} when is_integer(Santype) andalso Santype > 0 ->
                % ?MYLOG("xlh", "ServerId:~p, Santype:~p, IsOldSantype:~p~n",[ServerId, Santype, IsOldSantype]),
                #base_san_type{server_num = ServerNum} = data_cluster_sanctuary:get_san_type(Santype),
                if
                    ServerNum =< 8 -> %% 非阵营模式
                        case lists:keyfind(Santype, 1, Acc) of
                            {_, ServerIdList} -> skip;
                            _ -> ServerIdList = []
                        end,
                        {lists:keystore(Santype, 1, Acc, {Santype, [{ServerId, OpenDay, WorldLv, IsOldSantype}|ServerIdList]}), Acc1};
                    true -> %% 阵营模式
                        case lists:keyfind(Santype, 1, Acc1) of
                            {_, ServerIdList} -> skip;
                            _ -> ServerIdList = []
                        end,
                        {Acc, lists:keystore(Santype, 1, Acc1, {Santype, [ServerId|ServerIdList]})}
                end;
            _ -> {Acc, Acc1}
        end
    end,
    {FirstDivideL, ClusterL} = lists:foldl(Fun, {[], []}, lists:reverse(Serverids)),
    SantypeList = data_cluster_sanctuary:get_all_santype(),
    F1 = fun(Santype, Acc) ->
        case lists:keyfind(Santype, 1, Acc) of
            {_, _} -> Acc;
            _ -> lists:keystore(Santype, 1, Acc, {Santype, []})
        end
    end,
    {lists:foldl(F1, FirstDivideL, SantypeList), ClusterL}.

calc_new_camp_recored(ResList, CampRecord) ->
    Fun = fun({Santype, OList}, Acc1) ->
        ServerIdList = lists:flatten(OList),
        F1 = fun(ServerId, Acc) ->
            case lists:keyfind(ServerId, 1, Acc) of
                {_, DbSantype} when DbSantype == Santype ->
                    Acc;
                _ ->
                    Sql = io_lib:format(?SQL_REPLACE_SANTYPE_RECORD, [ServerId, Santype]),
                    db:execute(Sql),
                    lists:keystore(ServerId, 1, Acc, {ServerId, Santype})
            end
        end,
        lists:foldl(F1, Acc1, ServerIdList)
    end,
    % ?MYLOG("xlh", "FirstDivide:~p~n",[FirstDivide]),
    lists:foldl(Fun, CampRecord, ResList).

calc_server_santype(CampRecord, ServerId, OpenDay) ->
    case lists:keyfind(ServerId, 1, CampRecord) of
        {_, DbSantype} ->
            case data_cluster_sanctuary:get_type_by_openday(OpenDay) of
                Santype when is_integer(Santype) andalso Santype > DbSantype ->
                    {Santype, 0};
                _ ->
                    {DbSantype, 1}
            end;
        _ ->
            case data_cluster_sanctuary:get_type_by_openday(OpenDay) of
                Santype when is_integer(Santype) ->
                    {Santype, 0};
                _ ->
                    0
            end
    end.
%% -----------------------------------------------------------------
%% 判断是否进入过阵营模式
%% -----------------------------------------------------------------
judge_has_enter_camp([], _, _) -> {false, 0};
judge_has_enter_camp([H|Serverids], CampRecord, ServersInfo) ->
    case lists:keyfind(H, 1, CampRecord) of
        {_, DbSantype} when DbSantype >= ?SANTYPE_4 -> 
            Fun = fun(ServerId, Santype) ->
                case lists:keyfind(ServerId, 1, ServersInfo) of
                    {ServerId, OpenTime, _, _, _} -> skip;
                    _ -> 
                        OpenTime = 0
                end,
                OpenDay = get_open_day(OpenTime),
                case data_cluster_sanctuary:get_type_by_openday(OpenDay) of
                    Santype1 when is_integer(Santype1) -> skip;
                    _ -> Santype1 = 0
                end,
                if
                    Santype >= Santype1 ->
                        Santype;
                    true ->
                        Santype1
                end
            end,
            {true, lists:foldl(Fun, 0, [H|Serverids])};
        _ ->
            judge_has_enter_camp(Serverids, CampRecord, ServersInfo)
    end.

%% -----------------------------------------------------------------
%% 整个小跨服进入阵营
%% -----------------------------------------------------------------
calc_new_first_divide(FirstDivide, []) -> {FirstDivide, []};
calc_new_first_divide(FirstDivide, ClusterList) ->
    [{Santype, _}|_] = lists:reverse(lists:keysort(1, ClusterList)),
    Fun = fun({_, ServeridL}, Acc) ->
        lists:flatten(ServeridL) ++ Acc
    end,
    FirstServerIdList = lists:foldl(Fun, [], FirstDivide),
    AddServerL = [ServerId || {ServerId, _, _, _} <- FirstServerIdList],
    ServerIdList = lists:foldl(Fun, AddServerL, ClusterList),
    % ?PRINT("ServerIdList:~p,AddServerL:~p~n",[ServerIdList,AddServerL]),
    {[], lists:keystore(Santype, 1, [], {Santype, ServerIdList})}.

%% -----------------------------------------------------------------
%% 汇总所有待分配阵营的服务器
%% -----------------------------------------------------------------
get_cluster_list([], _, OldClusterL) -> OldClusterL;
get_cluster_list([{Santype, List}|_], ZoneId, OldClusterL) ->
    case lists:keyfind(Santype, 1, OldClusterL) of
        {Santype, ZoneList} ->
            lists:keystore(Santype, 1, OldClusterL, {Santype, lists:keysort(1, [{ZoneId, List}|ZoneList])});
        _ ->
            lists:keystore(Santype, 1, OldClusterL, {Santype, [{ZoneId, List}]})
    end.

%%  [{santype, [{Zone, ServerIdL}...]}]
%% -----------------------------------------------------------------
%%  新的对战分配
%% -----------------------------------------------------------------
divide_cluster_camp([], _, NewMap, BatZoneMap) -> {NewMap, BatZoneMap};
divide_cluster_camp([{Santype, List}|T], ServerPowerL, Map, OldBatZoneMap) ->
    #base_san_type{server_num = ServerNum} = data_cluster_sanctuary:get_san_type(Santype),
    ZoneNum = max(1, ServerNum div 8),  %% 默认8服分区模式
    FirstDivideL = divide_cluster_camp_helper(ZoneNum, List, []),
    {NewMap, BatZoneMap} = divide_cluster_camp_core(ServerPowerL, Santype, FirstDivideL, Map, OldBatZoneMap),
    divide_cluster_camp(T, ServerPowerL, NewMap, BatZoneMap).

%% -----------------------------------------------------------------
%%  保留部分旧的对战分配
%% -----------------------------------------------------------------
divide_cluster_camp([], _, NewMap, _, BatZoneMap) -> {NewMap, BatZoneMap};
divide_cluster_camp([{Santype, List}|T], ServerPowerL, Map, OldMap, OldBatZoneMap) ->
    #base_san_type{server_num = ServerNum} = data_cluster_sanctuary:get_san_type(Santype),
    ZoneNum = ServerNum div 8,  %% 默认8服分区模式
    FirstDivideL = divide_cluster_camp_helper(ZoneNum, List, []),
    {NewMap, BatZoneMap} = divide_cluster_camp_core(ServerPowerL, Santype, FirstDivideL, Map, OldMap, OldBatZoneMap),
    divide_cluster_camp(T, ServerPowerL, NewMap, OldMap, BatZoneMap).

divide_cluster_camp_helper(_, [], OutList) -> OutList;
divide_cluster_camp_helper(ZoneNum, List, OutList) ->
    AddList = lists:sublist(List, ZoneNum),
    divide_cluster_camp_helper(ZoneNum, lists:subtract(List, AddList), [AddList|OutList]).

%% FirstDivideL:[[{Zone, ServerIdL}...], [{Zone, ServerIdL}...]]
divide_cluster_camp_core(ServerPowerL, Santype, FirstDivideL, Map, Map1) ->
    Fun = fun(H, {TemMap, TemMap1}) ->
        {DivideList, ZoneIdList} = divide_list(ServerPowerL, H),
        Fun2 = fun(ZoneId, {TMap, TMap1}) ->
            List = maps:get(ZoneId, TMap, []),
            NewList = lists:keystore(Santype, 1, List, {Santype, [DivideList]}),
            {maps:put(ZoneId, NewList, TMap), maps:put(ZoneId, ZoneIdList, TMap1)}
        end,
        lists:foldl(Fun2, {TemMap, TemMap1}, ZoneIdList)
    end,
    lists:foldl(Fun, {Map, Map1}, FirstDivideL).

divide_cluster_camp_core(ServerPowerL, Santype, FirstDivideL, Map, OldMap, Map1) ->
    Fun = fun(H, {TemMap, TemMap1}) ->
        {DivideList, ZoneIdList} = divide_list(ServerPowerL, H),
        Fun2 = fun(ZoneId, {TMap, TMap1}) ->
            List = maps:get(ZoneId, TMap, []),
            OldList = maps:get(ZoneId, OldMap, []),
            case lists:keyfind(Santype, 1, OldList) of
                {_, OlddivideList} ->
                    OldSortList = lists:sort(lists:flatten(OlddivideList)),
                    SortList = lists:sort(lists:flatten(DivideList)),
                    if
                        SortList == OldSortList ->
                            NewList = lists:keystore(Santype, 1, List, {Santype, OlddivideList});
                        true ->
                            NewList = lists:keystore(Santype, 1, List, {Santype, [DivideList]})
                    end;
                _ ->
                    NewList = lists:keystore(Santype, 1, List, {Santype, [DivideList]})
            end,
            {maps:put(ZoneId, NewList, TMap), maps:put(ZoneId, ZoneIdList, TMap1)}
        end,
        lists:foldl(Fun2, {TemMap, TemMap1}, ZoneIdList)
    end,
    lists:foldl(Fun, {Map, Map1}, FirstDivideL).

divide_list(ServerPowerL, Head) ->
    Fun = fun({ZoneId, ServerIdList}, {Acc, TemList}) ->
        {ServerIdList++Acc, [ZoneId|TemList]}
    end,
    {ServerIdList, ZoneIdList} = lists:foldl(Fun, {[], []}, Head),
    Fun1 = fun(ServerId, Acc1) ->
        case lists:keyfind(ServerId, 1, ServerPowerL) of
            {_, Power} ->
                [{ServerId, Power}|Acc1];
            _ ->
                [{ServerId, 0}|Acc1]
        end
    end,
    SerPowerList = lists:foldl(Fun1, [], ServerIdList),
    SortPowerList = lists:reverse(lists:keysort(2, SerPowerList)),
    FourMaxPowerServer = lists:sublist(SortPowerList, 4),  %% 筛选出前4的服务器
    ResetPowerServer = lists:subtract(SortPowerList, FourMaxPowerServer),
    ResetL = ulists:list_shuffle(ResetPowerServer), %% 除前4个服外，打乱顺序
    DivideList = divide_server(FourMaxPowerServer, ResetL, 1, []),
    {DivideList, ZoneIdList}.

%% -----------------------------------------------------------------
%%  分配阵营对战服
%% -----------------------------------------------------------------
divide_server([], [], _, Acc) ->
    Fun = fun({_, List}, TemList) ->
        [List|TemList]
    end,
    lists:foldl(Fun, [], Acc);
% divide_server([], [{ServerId1, _}|ResetL], Index, Acc) ->
%     NewAcc = case lists:keyfind(Index, 1, Acc) of
%         {Index, List} ->
%             lists:keystore(Index, 1, Acc, {Index, [ServerId1|List]});
            
%         _ ->
%             lists:keystore(Index, 1, Acc, {Index, [ServerId1]})
%     end,
%     divide_server([], ResetL, (Index+1) rem 2, NewAcc);
% divide_server([{ServerId1, _}|FourMaxPowerServer], ResetL, Index, Acc) ->
%     NewAcc = case lists:keyfind(Index, 1, Acc) of
%         {Index, List} ->
%             lists:keystore(Index, 1, Acc, {Index, [ServerId1|List]});
%         _ ->
%             lists:keystore(Index, 1, Acc, {Index, [ServerId1]})
%     end,
%     divide_server(FourMaxPowerServer, ResetL, (Index+1) rem 2, NewAcc).
divide_server([], [{ServerId1, _}|ResetL], Index, Acc) -> %% 分配剩下的服
    NewAcc = case lists:keyfind(Index, 1, Acc) of
        {Index, List} ->
            lists:keystore(Index, 1, Acc, {Index, [ServerId1|List]});
        _ ->
            lists:keystore(Index, 1, Acc, {Index, [ServerId1]})
    end,
    divide_server([], ResetL, (Index+1) rem 8, NewAcc);
divide_server([{ServerId1, _}|FourMaxPowerServer], ResetL, Index, Acc) -> %% 服战力前4名的服确保不出现在一个阵营
    NewAcc = case lists:keyfind(Index, 1, Acc) of
        {Index, List} ->
            lists:keystore(Index, 1, Acc, {Index, [ServerId1|List]});
        _ ->
            lists:keystore(Index, 1, Acc, {Index, [ServerId1]})
    end,
    divide_server(FourMaxPowerServer, ResetL, (Index+1) rem 8, NewAcc).

%% -----------------------------------------------------------------
%%  非阵营模式的服分配
%% -----------------------------------------------------------------
hand_san_server(Santype, Type, Acc) ->
    WlvLimit = data_cluster_sanctuary:get_wlv_limit(Santype),
    if
        Santype == ?SANTYPE_1 ->
            hand_san_server_1(Type, Acc, WlvLimit, []);
        Santype == ?SANTYPE_2 ->
            hand_san_server_2(Type, Acc, WlvLimit, []);
        true ->
            hand_san_server_3(Type, Acc, WlvLimit, [])
    end.

%% -----------------------------------------------------------------
%% 处理 ?SANTYPE_1  [{ServerId, OpenDay, WorldLv, IsOldSantype}] 2服模式 [[4], [2]]
%% -----------------------------------------------------------------
hand_san_server_1([H1,H2|T], Acc, WlvLimit, Acc2) ->
    {NewAcc, NewAcc2} = hand_san_server_core(?SANTYPE_1, [H1, H2], Acc, WlvLimit, Acc2),
    hand_san_server_1(T, NewAcc, WlvLimit, NewAcc2);
hand_san_server_1([H|[]], Acc, WlvLimit, Acc2) ->
    {NewAcc, NewAcc2} = hand_san_server_core(?SANTYPE_1, [H], Acc, WlvLimit, Acc2),
    hand_san_server_1([], NewAcc, WlvLimit, NewAcc2);
hand_san_server_1([], Acc, _, Acc2) -> {Acc, Acc2}.

hand_san_server_core(_Santype, [], Acc, _WlvLimit, Acc2) -> {Acc, Acc2};
hand_san_server_core(Santype, CalcList, Acc, WlvLimit, Acc2) ->
    {Average, List, SatisfyList} = calc_average(CalcList),
    ServerIdList = lists:flatten(SatisfyList),
    if
        Average >= WlvLimit -> 
            case lists:keyfind(Santype, 1, Acc) of
                {_, OldList} -> NewList = [List|OldList];
                _ -> NewList = [List]
            end,
            NewAcc = lists:keystore(Santype, 1, Acc, {Santype, NewList}),
            NewAcc2 = Acc2;
        SatisfyList =/= [] ->
            case lists:keyfind(Santype, 1, Acc) of
                {_, OldList} -> NewList = [SatisfyList|OldList];
                _ -> NewList = [SatisfyList]
            end,
            NewAcc = lists:keystore(Santype, 1, Acc, {Santype, NewList}),
            NewAcc2 = [
                Turple || {ServerId, _, _, _} = Turple <- CalcList, lists:member(ServerId, ServerIdList) == false
            ] ++ Acc2;
        true -> NewAcc = Acc, NewAcc2 = CalcList ++ Acc2
    end,
    {NewAcc, NewAcc2}.

%% -----------------------------------------------------------------
%% 处理 ?SANTYPE_2 4服模式
%% -----------------------------------------------------------------
hand_san_server_2(Type2, Acc, WlvLimit, Acc2) ->
    Len = erlang:length(Type2),
    if
        Len > 4 ->
            {H,T} = lists:split(4, Type2),
            {NewAcc, NewAcc2} = hand_san_server_core(?SANTYPE_2, H, Acc, WlvLimit, Acc2),
            hand_san_server_core(?SANTYPE_2, T, NewAcc, WlvLimit, NewAcc2);
        true ->
            hand_san_server_core(?SANTYPE_2, Type2, Acc, WlvLimit, Acc2)
    end.

%% -----------------------------------------------------------------
%% 处理 ?SANTYPE_3 8服模式
%% -----------------------------------------------------------------
hand_san_server_3([], Acc, _, Acc2) -> {Acc, Acc2};
hand_san_server_3(Type3, Acc, WlvLimit, Acc2) ->
    hand_san_server_core(?SANTYPE_3, Type3, Acc, WlvLimit, Acc2).

calc_average(List) ->
    Fun = fun
        ({SerId, _, WorldLv, 1}, {Tem, Counter, Acc, Acc1}) ->
            {WorldLv + Tem, Counter+1, [[SerId]|Acc], [[SerId]|Acc1]};
        ({SerId, _, WorldLv, _}, {Tem, Counter, Acc, Acc1}) ->
            {WorldLv + Tem, Counter+1, [[SerId]|Acc], Acc1};
        (_, Acc) -> Acc
    end,
    {Sum, Num, NewList, SatisfyList} = lists:foldl(Fun, {0,0, [], []}, List),
    Average = 
    if
        Num > 0 ->
            Sum div Num;
        true ->
            0
    end,
    {Average, NewList, SatisfyList}.

%% 获取圣域模式及对手服务器
%%  SanBattList= [[[1,2],[3,4]], [[5,8],[6,7]]]
find_enemy([], _ServerId) -> false;
find_enemy([{Santype, SanBattList}|T], ServerId) ->
    case find_enemy_helper(SanBattList, ServerId) of
        List when is_list(List) ->
            {Santype, List};
        false ->
            find_enemy(T, ServerId)
    end.

%%[{?SANTYPE_1, List1}, {?SANTYPE_2, List2}, {?SANTYPE_3, List3}] 
%% 参数:List1/2/3
%% Resoult: List:该模式所有服务器id;false
find_enemy_helper([], _ServerId) -> false;
find_enemy_helper([H|T], ServerId) ->
    case lists:member(ServerId, lists:flatten(H)) of
        true -> lists:flatten(H);
        false -> find_enemy_helper(T, ServerId)
    end.

%% 获取服务器的圣域模式
get_server_santype(ServerId, BattleMap, ZoneId) ->
    BattList = maps:get(ZoneId, BattleMap, []),
    case find_enemy(BattList, ServerId) of
        {Santype, List} -> {Santype, List};
        _ -> {0, [[]]}
    end. 

%% -----------------------------------------------------------------
%% 获取建筑信息
%% -----------------------------------------------------------------
get_scene_info(ZoneId, CopyId, Santype, Scene, SanState) ->
    SanList = maps:get(ZoneId, SanState, []),
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} = San ->
            Constructions = maps:get({ZoneId, CopyId}, ConstructionsMap, []),
            case lists:keyfind(Scene, #c_cons_state.scene_id, Constructions) of
                Construction when is_record(Construction, c_cons_state) -> 
                    {true, San, SanList, ConstructionsMap, Constructions, Construction};
                _ -> 
                    false
            end;
        _ ->
            false
    end.

%% -----------------------------------------------------------------
%% 获取怪物信息
%% -----------------------------------------------------------------
get_mon_info(ZoneId, CopyId, Santype, Scene, Monid, SanState) ->
    case get_scene_info(ZoneId, CopyId, Santype, Scene, SanState) of
        {true, San, SanList, ConstructionsMap, Constructions, #c_cons_state{mon_state = Mons} = Construction} ->
            case lists:keyfind(Monid, #c_mon_state.mon_id, Mons) of
                Mon when is_record(Mon, c_mon_state) -> 
                    {true, SanList, San, ConstructionsMap, Constructions, Construction, Mons, Mon};
                _ -> false
            end;
        _ ->
            false
    end.

%% -----------------------------------------------------------------
%% 获取建筑类型
%% -----------------------------------------------------------------
calc_con_type(Scene) ->
    SanSceneTypes = data_cluster_sanctuary:get_all_scene_type(),
    Fun = fun(SceneType, Tem) ->
        SceneIds = data_cluster_sanctuary:get_scene_ids(SceneType),
        case lists:member(Scene, SceneIds) of
            true ->
                case data_cluster_sanctuary:get_con_type(SceneType) of
                    [ConType]  when is_integer(ConType) -> ConType;
                    _ -> Tem
                end;
            _ ->
                Tem
        end
    end,
    lists:foldl(Fun, 0, SanSceneTypes).

%% -----------------------------------------------------------------
%% 计算当前模式服务器平均等级
%% -----------------------------------------------------------------
calc_average_lv(Serverids, ServersInfo) ->
    Fun = fun(ServerId, {Total, Length}) ->
        case lists:keyfind(ServerId, 1, ServersInfo) of
            {ServerId, _OpenTime, WorldLv,_,_} ->
                {Total+WorldLv, Length+1};
            _ ->
                {Total, Length}
        end
    end,
    {TotalLv, Length} = lists:foldl(Fun, {0,0}, lists:flatten(Serverids)),
    % ?PRINT("TotalLv:~p, Length:~p~n",[TotalLv, Length]),
    TotalLv div max(1, Length).

%% -----------------------------------------------------------------
%% 复活怪物 [[[1,2], [3,4]], [[5,6],[7,8]]] = [H|T]
%% -----------------------------------------------------------------
mon_create_helper(_ZoneId, _Santype, [], _ServerInfo, ConstructionMap,_,_,_) -> ConstructionMap;
mon_create_helper(_ZoneId, _Santype, [[]], _ServerInfo, ConstructionMap,_,_,_) -> ConstructionMap;
mon_create_helper(ZoneId, Santype, [H|T], ServerInfo, ConstructionMap, OldInfoMap, CreateType, RebornEndTime) when CreateType == gm -> %% 秘籍复活
    WorldLv = calc_average_lv(H, ServerInfo),
    [[Hs|_]|_] = H,
    % ?PRINT("@@@@@@@@@ Hs:~p~n",[Hs]),
    OldConst = maps:get({ZoneId, Hs}, ConstructionMap, []),
    Scenes = case data_cluster_sanctuary:get_san_type(Santype) of
                #base_san_type{san_num = [{_, SanSceneL}], city_num = [{_,CitySceneL}],
                        village_num =[{_, VillSceneL}]} ->
                    SanSceneL++CitySceneL++VillSceneL;
                _ ->
                    []
            end,
    Fun = fun(Scene, Acc) ->
        mod_scene_agent:apply_cast(Scene, 0, lib_c_sanctuary, clear_scene_palyer, [Hs, Scene]),  
        % %% 先清理怪物再创建
        % lib_mon:clear_scene_mon(Scene, 0, Hs, 0),
        MonIds = data_cluster_sanctuary:get_mon_by_scene(Scene),
        case calc_con_type(Scene) of
            ConType when is_integer(ConType) andalso ConType > 0 -> ConType;
            _ -> ?ERR("Construction type error in cfg, scene:~p~n",[Scene]),ConType = 1
        end,
        case lists:keyfind(Scene, #c_cons_state.scene_id, Acc) of
            OldCons when is_record(OldCons, c_cons_state) -> %% 继承归属
                #c_cons_state{mon_state = OldMons, bl_server = PreBlCamp,
                        san_score = _SanScoreMap} = OldCons,
                Mons = mon_create_core(MonIds, Hs, WorldLv, OldMons, CreateType, RebornEndTime),
                Construction = OldCons#c_cons_state{mon_state = Mons, auction_reward_role = [],
                        bl_server = 0, pre_bl_server = PreBlCamp, san_score = #{}};
            _->
                Mons = mon_create_core(MonIds, Hs, WorldLv, [], CreateType, RebornEndTime),
                Construction = #c_cons_state{
                    scene_id = Scene,
                    cons_type = ConType,
                    bl_server = 0,
                    mon_state = Mons
                    ,pre_bl_server = 0
                    ,san_score = #{}
                    ,auction_reward_role = []    
                }
        end,
        lists:keystore(Scene,#c_cons_state.scene_id,Acc,Construction)
    end,
    Constructions = lists:foldl(Fun, OldConst, Scenes),
    NewConsMap = maps:put({ZoneId, Hs}, Constructions, ConstructionMap),
    [begin
        case lib_clusters_center:get_node(ServerId) of
            undefined -> skip;
            Node -> 
                update_local_data(ServerId, point, [[]]),
                mod_clusters_center:apply_cast(Node, lib_c_sanctuary_api, notify_client_boss_refresh, [])        
        end
    end|| ServerId <- lists:flatten(H)],
    mon_create_helper(ZoneId, Santype, T, ServerInfo, NewConsMap, OldInfoMap, CreateType, RebornEndTime);
mon_create_helper(ZoneId, Santype, [H|T], ServerInfo, ConstructionMap, OldInfoMap, CreateType, RebornEndTime) when CreateType == init -> %% 初始化复活怪物只复活和平怪
    WorldLv = calc_average_lv(H, ServerInfo),
    [[Hs|_]|_] = H,
    % ?PRINT("@@@@@@@@@ Hs:~p~n",[Hs]),
    OldConst = maps:get({ZoneId, Hs}, ConstructionMap, []),
    Scenes = case data_cluster_sanctuary:get_san_type(Santype) of
                #base_san_type{san_num = [{_, SanSceneL}], city_num = [{_,CitySceneL}],
                        village_num =[{_, VillSceneL}]} ->
                    SanSceneL++CitySceneL++VillSceneL;
                _ ->
                    []
            end,
    Fun = fun(Scene, Acc) ->
        mod_scene_agent:apply_cast(Scene, 0, lib_c_sanctuary, clear_scene_palyer, [Hs, Scene]),  
        % %% 先清理怪物再创建
        % lib_mon:clear_scene_mon(Scene, 0, Hs, 0),
        MonIds = data_cluster_sanctuary:get_mon_by_scene(Scene),
        case calc_con_type(Scene) of
            ConType when is_integer(ConType) andalso ConType > 0 -> ConType;
            _ -> ?ERR("Construction type error in cfg, scene:~p~n",[Scene]),ConType = 1
        end,
        case lists:keyfind(Scene, #c_cons_state.scene_id, Acc) of
            OldCons when is_record(OldCons, c_cons_state) ->
                #c_cons_state{mon_state = OldMons, san_score = _SanScoreMap} = OldCons,
                Mons = mon_create_core(MonIds, Hs, WorldLv, OldMons, CreateType, RebornEndTime),
                % ?PRINT("======== BlCamp:~p~n",[BlCamp]),
                Construction = OldCons#c_cons_state{mon_state = Mons, auction_reward_role = []};
            _->
                PreBlBlCamp = maps:get({ZoneId, Hs, Scene}, OldInfoMap, 0),
                Mons = mon_create_core(MonIds, Hs, WorldLv, [], CreateType, RebornEndTime),
                Construction = #c_cons_state{
                    scene_id = Scene,
                    cons_type = ConType,
                    bl_server = 0,
                    mon_state = Mons
                    ,pre_bl_server = PreBlBlCamp
                    ,san_score = #{}
                    ,auction_reward_role = []
                }
        end,
        lists:keystore(Scene,#c_cons_state.scene_id,Acc,Construction)
    end,
    Constructions = lists:foldl(Fun, OldConst, Scenes),
    NewConsMap = maps:put({ZoneId, Hs}, Constructions, ConstructionMap),
    [begin
        case lib_clusters_center:get_node(ServerId) of
            undefined -> skip;
            _ -> 
                update_local_data(ServerId, point, [[]])
        end
    end|| ServerId <- lists:flatten(H)],
    mon_create_helper(ZoneId, Santype, T, ServerInfo, NewConsMap, OldInfoMap, CreateType, RebornEndTime);
mon_create_helper(ZoneId, Santype, [H|T], ServerInfo, ConstructionMap, OldInfoMap, CreateType, RebornEndTime) -> %% 定时复活
    WorldLv = calc_average_lv(H, ServerInfo),
    [[Hs|_]|_] = H,
    % ?PRINT("@@@@@@@@@ Hs:~p~n",[Hs]),
    OldConst = maps:get({ZoneId, Hs}, ConstructionMap, []),
    Scenes = case data_cluster_sanctuary:get_san_type(Santype) of
                #base_san_type{san_num = [{_, SanSceneL}], city_num = [{_,CitySceneL}],
                        village_num =[{_, VillSceneL}]} ->
                    SanSceneL++CitySceneL++VillSceneL;
                _ ->
                    []
            end,
    Fun = fun(Scene, Acc) ->
        mod_scene_agent:apply_cast(Scene, 0, lib_c_sanctuary, clear_scene_palyer, [Hs, Scene]),  
        % %% 先清理怪物再创建
        % lib_mon:clear_scene_mon(Scene, 0, Hs, 0),
        MonIds = data_cluster_sanctuary:get_mon_by_scene(Scene),
        case calc_con_type(Scene) of
            ConType when is_integer(ConType) andalso ConType > 0 -> ConType;
            _ -> ?ERR("Construction type error in cfg, scene:~p~n",[Scene]),ConType = 1
        end,
        case lists:keyfind(Scene, #c_cons_state.scene_id, Acc) of
            OldCons when is_record(OldCons, c_cons_state) ->
                #c_cons_state{mon_state = OldMons} = OldCons,
                PreBlBlCamp = maps:get({ZoneId, Hs, Scene}, OldInfoMap, 0),
                Mons = mon_create_core(MonIds, Hs, WorldLv, OldMons, CreateType, RebornEndTime),
                Construction = OldCons#c_cons_state{mon_state = Mons, auction_reward_role = [],
                        bl_server = 0, pre_bl_server = PreBlBlCamp, san_score = #{}};
            _->
                PreBlBlCamp = maps:get({ZoneId, Hs, Scene}, OldInfoMap, 0),
                Mons = mon_create_core(MonIds, Hs, WorldLv, [], CreateType, RebornEndTime),
                Construction = #c_cons_state{
                    scene_id = Scene,
                    cons_type = ConType,
                    bl_server = 0,
                    mon_state = Mons
                    ,pre_bl_server = PreBlBlCamp
                    ,san_score = #{}
                    ,auction_reward_role = []
                }
        end,
        lists:keystore(Scene,#c_cons_state.scene_id,Acc,Construction)
    end,
    Constructions = lists:foldl(Fun, OldConst, Scenes),
    NewConsMap = maps:put({ZoneId, Hs}, Constructions, ConstructionMap),
    [begin
        case lib_clusters_center:get_node(ServerId) of
            undefined -> skip;
            Node -> 
                update_local_data(ServerId, point, [[]]),
                mod_clusters_center:apply_cast(Node, lib_c_sanctuary_api, notify_client_boss_refresh, [])
        end
    end|| ServerId <- lists:flatten(H)],
    mon_create_helper(ZoneId, Santype, T, ServerInfo, NewConsMap, OldInfoMap, CreateType, RebornEndTime).
        % lib_mon:async_create_mon(MonId, Scene, ScenePoolId, NewX, NewY, MonType, Pid, 1, SumAttrList),

mon_create_core([], _CopyId, _WorldLv, Mons, _, _) -> Mons;
mon_create_core([MonId|T], CopyId, WorldLv, Mons, CreateType, RebornEndTime) ->
    case data_mon:get(MonId) of
        [] -> MonType = 1;
        #mon{type = MonType} -> ok
    end,
    NewMons = mon_create_core_2(MonId, CopyId, WorldLv, Mons, MonType, CreateType, RebornEndTime),
    mon_create_core(T, CopyId, WorldLv, NewMons, CreateType, RebornEndTime).

mon_create_core_2(MonId, CopyId, WorldLv, Mons, MonType, CreateType, RebornEndTime) when CreateType == init ->
    case data_cluster_sanctuary:get_mon_cfg(MonId) of
        #base_san_mon{type = SanMonType,scene = Scene,x = NewX,y = NewY} ->
            NewRebornEndTime = if
                SanMonType == ?MONTYPE_4 orelse SanMonType == ?MONTYPE_5 orelse SanMonType == ?MONTYPE_6 -> %% 和平怪复活
                    0;
                true ->
                    Res = max(0, RebornEndTime - utime:unixtime()- 120), %% 允许2分钟的延时，防止在配置复活的时刻启动服务器
                    if
                        Res == 0 ->
                            0;
                        true ->
                            RebornEndTime
                    end
            end,
            case lists:keyfind(MonId, #c_mon_state.mon_id, Mons) of
                OldMon when is_record(OldMon, c_mon_state) ->
                    Mon = OldMon#c_mon_state{
                        mon_lv = WorldLv,
                        rank_list = [],
                        total_hurt = 0,
                        mon_hurt_info = #{},
                        reborn_time = NewRebornEndTime
                    };
                _ ->
                    Mon = #c_mon_state{
                        mon_id = MonId,
                        mon_type = SanMonType,
                        mon_lv = WorldLv,
                        rank_list = [],
                        total_hurt = 0,
                        mon_hurt_info = #{},
                        reborn_time = NewRebornEndTime,
                        kill_log = [] 
                    }
            end,
            NewMons = lists:keystore(MonId, #c_mon_state.mon_id, Mons, Mon),
            %% 先清怪物
            lib_mon:clear_scene_mon_by_mids(Scene, 0, CopyId, 1, [MonId]),
            if
                NewRebornEndTime == 0 ->
                    lib_mon:async_create_mon(MonId, Scene, 0, NewX, NewY, MonType, 
                            CopyId, 1, [{auto_lv, WorldLv}, {type, MonType}]);
                true ->
                    skip
            end;
                 
        _ ->
            NewMons = Mons  
    end,
    NewMons;

mon_create_core_2(MonId, CopyId, WorldLv, Mons, MonType, CreateType, _) when CreateType == peace -> %% 和平怪生成
    case data_cluster_sanctuary:get_mon_cfg(MonId) of
        #base_san_mon{type = SanMonType,scene = Scene,x = NewX,y = NewY} ->
            case lists:keyfind(MonId, #c_mon_state.mon_id, Mons) of
                OldMon when is_record(OldMon, c_mon_state) ->
                    Mon = OldMon#c_mon_state{
                        mon_lv = WorldLv,
                        rank_list = [],
                        total_hurt = 0,
                        mon_hurt_info = #{},
                        reborn_time = 0
                    };
                _ ->
                    Mon = #c_mon_state{
                        mon_id = MonId,
                        mon_type = SanMonType,
                        mon_lv = WorldLv,
                        rank_list = [],
                        total_hurt = 0,
                        mon_hurt_info = #{},
                        reborn_time = 0,
                        kill_log = [] 
                    }
            end,
            NewMons = lists:keystore(MonId, #c_mon_state.mon_id, Mons, Mon),
            %% 先清怪物
            lib_mon:clear_scene_mon_by_mids(Scene, 0, CopyId, 1, [MonId]),

            lib_mon:async_create_mon(MonId, Scene, 0, NewX, NewY, MonType, 
                            CopyId, 1, [{auto_lv, WorldLv}, {type, MonType}]);      
        _ ->
            NewMons = Mons  
    end,
    NewMons;
mon_create_core_2(MonId, CopyId, WorldLv, Mons, MonType, _, _) ->
    case data_cluster_sanctuary:get_mon_cfg(MonId) of
        #base_san_mon{type = SanMonType,scene = Scene,x = NewX,y = NewY} when SanMonType =/= ?MONTYPE_4; 
                    SanMonType =/= ?MONTYPE_5;SanMonType =/= ?MONTYPE_6->
            case lists:keyfind(MonId, #c_mon_state.mon_id, Mons) of
                OldMon when is_record(OldMon, c_mon_state) ->
                    Mon = OldMon#c_mon_state{
                        mon_lv = WorldLv,
                        rank_list = [],
                        total_hurt = 0,
                        mon_hurt_info = #{},
                        reborn_time = 0
                    };
                _ ->
                    Mon = #c_mon_state{
                        mon_id = MonId,
                        mon_type = SanMonType,
                        mon_lv = WorldLv,
                        rank_list = [],
                        total_hurt = 0,
                        mon_hurt_info = #{},
                        reborn_time = 0,
                        kill_log = [] 
                    }
            end,
            NewMons = lists:keystore(MonId, #c_mon_state.mon_id, Mons, Mon),
            %% 先清怪物
            lib_mon:clear_scene_mon_by_mids(Scene, 0, CopyId, 1, [MonId]),

            lib_mon:async_create_mon(MonId, Scene, 0, NewX, NewY, MonType, 
                            CopyId, 1, [{auto_lv, WorldLv}, {type, MonType}]);      
        _ ->
            NewMons = Mons  
    end,
    NewMons.

%% -----------------------------------------------------------------
%% 怪物复活更新内存数据
%% -----------------------------------------------------------------
mon_create_save_info(Santype, SanList, NewMap) ->
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        San when is_record(San, c_san_state) ->
            OldExtraState = San#c_san_state.extra_state,
            Fun = fun({_, ExtraState}) ->
                ExtraState == 0
            end,
            case ulists:find(Fun, OldExtraState) of
                {ok, _} -> 
                    Worth = San#c_san_state.auction_worth,
                    WorthState = OldExtraState;
                _ ->
                    Worth = [],
                    WorthState = calc_default_extra_state()
            end,
            NewSan = San#c_san_state{cons_state = NewMap, auction_worth = Worth, extra_state = WorthState},
            lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan);
        _ -> 
            NewSan = #c_san_state{san_type = Santype, cons_state = NewMap, auction_worth = [], extra_state = calc_default_extra_state()},
            lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan)
    end.

%% -----------------------------------------------------------------
%% 计算默认额外拍卖产出状态
%% -----------------------------------------------------------------
calc_default_extra_state() ->
    List = data_cluster_sanctuary:get_san_value(auction_extra),
    Fun = fun({Worth, _, _}, Acc) ->
        [{Worth, 0}|Acc]
    end,
    lists:foldl(Fun, [], List).

%% -----------------------------------------------------------------
%% 获取建筑信息
%% -----------------------------------------------------------------
get_constructions_map(Santype, SanList) ->
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        San when is_record(San, c_san_state) ->
            San#c_san_state.cons_state;
        _ -> 
            #{}
    end.

%% -----------------------------------------------------------------
%% NewRankA 由大到小的伤害列表
%% -----------------------------------------------------------------
calc_mon_bl_server(_NewRankA, 0, _BLWhos, _, _, _) -> {[], 0, [], []};
calc_mon_bl_server(NewRankA, Total, BLWhos, Score, MinScore, ServersInfo) when Total =/= 0 andalso is_integer(Score)->
    case data_cluster_sanctuary:get_san_value(min_score_get_hurt_limit) of
        PerLimit when is_integer(PerLimit) -> PerLimit;
        _ -> PerLimit = 0
    end,
    Fun = fun({S, SN, R, N, H}, {Acc,Racc}) ->
        Num = (H*10000) div Total,
        if
            Num >= PerLimit*100 ->
                TemScore = util:ceil(Num*Score/10000),
                RScore = max(TemScore, MinScore),
                NewRacc = lists:keystore(R, 2, Racc, {S,R,RScore});
            true ->
                NewRacc = Racc
        end,
        case lists:keyfind(S, 1, ServersInfo) of 
            {S, _OpenTime, _WorldLv, _ServerNum, ServerName} ->skip;
            _ -> ServerName = <<>>
        end,
        {lists:keystore(R, 3, Acc, {S,SN,ServerName,R,N,Num}), NewRacc}
        % [{S,SN,R,N,Num}|Acc]
    end,
    {RealSendL,RoleScore} = lists:foldl(Fun, {[],[]}, NewRankA),
    {BlServerL, RoleIdList} = lists:foldl(fun(#mon_atter{id = Rid, server_id = Ts}, {TemBl, Acc}) -> 
                        {[Ts|TemBl], [{Ts, Rid}|Acc]} 
                     end, {[], []}, BLWhos),
    {RealSendL, ulists:removal_duplicate(BlServerL), RoleScore, RoleIdList}.
    

%% -----------------------------------------------------------------
%% 返回第一个比TemS大的配置时间
%% -----------------------------------------------------------------
get_next_time({TemSH, TemSM, TemSS}, OpenList) ->
    Tem = (TemSH * 60 + TemSM) * 60 + TemSS,
    Fun = fun({SH, SM}) ->
        Tem =< (SH * 60 + SM) * 60
    end,
    ulists:find(Fun, OpenList).

%% -----------------------------------------------------------------
%% 计算怪物复活时间
%% -----------------------------------------------------------------
calc_mon_reborn_time(NowTime, MonId, SanMonType) when SanMonType =:= ?MONTYPE_4;SanMonType =:= ?MONTYPE_5;SanMonType =:= ?MONTYPE_6 ->
    case data_cluster_sanctuary:get_mon_cfg(MonId) of
        #base_san_mon{reborn = RebornTimeCfg} when is_integer(RebornTimeCfg) ->
            {true, NowTime+RebornTimeCfg};
        _ ->
            ?ERR("miss cfg calc_mon_reborn_time! NowTime:~p,MonId:~p,SanMonType:~p",[NowTime, MonId, SanMonType]),
            false
    end;
calc_mon_reborn_time(NowTime, _MonId, _SanMonType) ->
    calc_mon_reborn_time(NowTime).


calc_mon_reborn_time(NowTime) ->
    TimeList = data_cluster_sanctuary:get_san_value(reborn_time),
    {_D,{NowSH,NowSM, NowSS}} = utime:unixtime_to_localtime(NowTime),
    case get_next_time({NowSH, NowSM, NowSS}, TimeList) of %%获取开启时间段中第一个boss刷新时间大于nowtime的时间
        {ok, {SH, SM}} ->
            TemStartT = utime:unixtime({_D, {SH, SM,0}}),
            {true, TemStartT};
        _ ->
            NowDate = utime:unixdate(),
            NextData = NowDate + 86400,
            {_ND,{NextSH,NextSM, NextSS}} = utime:unixtime_to_localtime(NextData),
            case get_next_time({NextSH, NextSM, NextSS}, TimeList) of 
                {ok, {NSH, NSM}} ->
                    NStartT = utime:unixtime({_ND, {NSH, NSM,0}}),
                    {true, NStartT};
                _ ->
                    ?ERR("miss cfg calc_mon_reborn_time! NowTime:~p,NextData({NextSH:~p,NextSM:~p}):~p, TimecfgList:~p~n",
                            [NowTime,NextSH,NextSM,NextData,TimeList]),
                    false
            end
    end.

%% -----------------------------------------------------------------
%% 计算玩家怒气清理时间
%% -----------------------------------------------------------------
calc_role_clear_time(NowTime) ->
    ClearCfg = data_cluster_sanctuary:get_san_value(clear_role_anger_time),
    NowDate = utime:unixdate(NowTime),
    {Date,_} = utime:unixtime_to_localtime(NowDate),
    case ClearCfg of
        [{SH, SM}] ->
            ClearTime = utime:unixtime({Date, {SH, SM,0}});
        _ ->
            ClearTime = utime:unixtime({Date, {16, 0,0}})
    end,
    if
        ClearTime < NowTime ->
            NClearTime = ClearTime +86400;
        true ->
            NClearTime = ClearTime
    end,
    NClearTime.

%% -----------------------------------------------------------------
%% 更改内存服务器信息
%% -----------------------------------------------------------------
server_info_chage_helper(_ServerId, ServersInfo, ZoneMap, []) -> {ServersInfo, ZoneMap};
server_info_chage_helper(ServerId, ServersInfo, ZoneMap, [{world_lv, Value}|T]) ->
    case lists:keyfind(ServerId, 1, ServersInfo) of
        {ServerId, OpenTime, _, ServerNum, ServerName} ->
            NewList = lists:keystore(ServerId, 1, ServersInfo, {ServerId, OpenTime, Value, ServerNum, ServerName});
        _ ->
            NewList = ServersInfo
    end,
    server_info_chage_helper(ServerId, NewList, ZoneMap, T);
server_info_chage_helper(ServerId, ServersInfo, ZoneMap, [{open_time, NewOpentime}|T]) ->
    case lists:keyfind(ServerId, 1, ServersInfo) of
        {ServerId, _OpenTime, WorldLv, ServerNum, ServerName} ->
            NewList = lists:keystore(ServerId, 1, ServersInfo, {ServerId, NewOpentime, WorldLv, ServerNum, ServerName});
        _ ->
            NewList = ServersInfo
    end,
    server_info_chage_helper(ServerId, NewList, ZoneMap, T);
server_info_chage_helper(_,ServersInfo, ZoneMap,_) ->{ServersInfo, ZoneMap}.

%% -----------------------------------------------------------------
%% 获取服务器阵营
%% -----------------------------------------------------------------
get_begin_scene(_ServerId, [], []) -> [1];
get_begin_scene(_ServerId, [], Acc) -> Acc;
get_begin_scene(ServerId, [{TServerIdL, TemPoint}|BeginList], Acc) ->
    case lists:member(ServerId, TServerIdL) of
        true ->
            get_begin_scene(ServerId, BeginList, [TemPoint|Acc]);
        _ ->
            get_begin_scene(ServerId, BeginList, Acc)
    end.

%% -----------------------------------------------------------------
%% 依据阵营获取服务器列表
%% -----------------------------------------------------------------
get_server_by_point(0, _, _) -> [];
get_server_by_point(_, _, []) -> [];
get_server_by_point(Point, EnemyServerIds, [{[], _}|BeginList]) ->
    get_server_by_point(Point, EnemyServerIds, BeginList);
get_server_by_point(Point, EnemyServerIds, [{ServerIdL, TemPoint}|BeginList]) when is_list(EnemyServerIds) ->   
    case Point == TemPoint andalso get_server_by_point_helper(ServerIdL, EnemyServerIds) of
        true -> lists:flatten(ServerIdL);
        _ -> get_server_by_point(Point, EnemyServerIds, BeginList)
    end;
get_server_by_point(Point, ServerId, [{ServerIdL, _}|BeginList]) when is_integer(ServerId) ->
    case lists:member(ServerId, ServerIdL) of
        true -> lists:flatten(ServerIdL);
        _ -> get_server_by_point(Point, ServerId, BeginList)
    end;
get_server_by_point(_, _, _) -> [].

get_server_by_point_helper([], _) -> true;
get_server_by_point_helper([ServerId|L], EnemyServerIds) ->
    case lists:member(ServerId, EnemyServerIds) of
        true -> get_server_by_point_helper(L, EnemyServerIds);
        _ -> false
    end.

%% -----------------------------------------------------------------
%% 活动结束清理玩家
%% -----------------------------------------------------------------
clear_user_act_end([],_,_,_,_) -> skip;
clear_user_act_end([{ZoneId, SanStateList}|T], Value, NowTime, UserMap, ZoneMap) ->
    ServerIdL = maps:get(ZoneId, ZoneMap, []),
    Fun = fun(#c_san_state{cons_state = ConsMap}) ->
        clear_user_act_end_helper(ConsMap, Value, NowTime, ServerIdL, UserMap)
    end,
    lists:foreach(Fun, SanStateList),
    clear_user_act_end(T, Value, NowTime, UserMap, ZoneMap).

clear_user_act_end_helper(ConsMap, Value, NowTime, ServerIdL, UserMap) ->
    ConsMapList = maps:to_list(ConsMap),
    Fun = fun({{ZoneId, CopyId}, Constructions}, _) ->
        % %?MYLOG("xlh"," 28417, Constructions:~p~n", [Constructions]),
        clear_user_act_end_core(ZoneId, CopyId, NowTime, Value, Constructions, ServerIdL, UserMap),
        0
    end,
    lists:foldl(Fun, 0, ConsMapList).

clear_user_act_end_core(_,_, _, _,[],_, _) -> skip; 
clear_user_act_end_core(ZoneId, CopyId, NowTime, _Value, [#c_cons_state{scene_id = Scene, clear_role_ref = ClearRef, mon_state = Mons}|T], ServerIdL, UserMap) ->
    % {ok, Bin} = pt_284:write(28417, [Value+NowTime]),
    %?MYLOG("xlh"," 28417, Scene:~p,StartTime:~p~n", [Scene,Value+NowTime]),
    % lib_server_send:send_to_scene(Scene, 0, CopyId, Bin),
    util:cancel_timer(ClearRef),
    Fun1 = fun(#c_mon_state{reborn_ref = RebornRef}) ->
        util:cancel_timer(RebornRef)
    end,
    lists:foreach(Fun1, Mons),
    spawn(fun() ->
        % timer:sleep(Value*1000),
        Fun = fun(ServerId) ->
            UserIds = maps:get({ZoneId, ServerId, Scene}, UserMap, []),
            if
                UserIds == [] ->
                    skip;
                true ->
                    mod_clusters_center:apply_cast(ServerId, lib_c_sanctuary, clear_scene_user, [UserIds])
            end
        end,
        lists:foreach(Fun, ServerIdL),
        lib_scene:clear_scene_room(Scene, 0, CopyId) end),
    clear_user_act_end_core(ZoneId, CopyId, NowTime, _Value, T, ServerIdL, UserMap).

%% -----------------------------------------------------------------
%% 计算怪物复活定时器
%% -----------------------------------------------------------------
calc_mon_reborn_ref(NowTime, RebornEndTime, OldMonRef, MonId, SceneId, CopyId) ->
    util:cancel_timer(OldMonRef),
    NewRef = erlang:send_after(max(1, RebornEndTime-NowTime)*1000, self(), {'mon_create_peace', MonId, SceneId, CopyId}),
    NewRef.

%% -----------------------------------------------------------------
%% 更新本地服数据
%% -----------------------------------------------------------------
update_local_data(ServerId, Type, Args) when is_integer(ServerId) ->
     mod_clusters_center:apply_cast(ServerId, mod_c_sanctuary_local, update_state, [Type, Args]).
update_local_data(ZoneMap, BattleMap, Type, Args) ->
    BattleList = maps:to_list(BattleMap), 
    Fun = fun({ZoneId, BattList}, Acc) ->
            ServerIdL = maps:get(ZoneId, ZoneMap, []),
            F = fun({_, TList}, TemAcc) ->
                F1 = fun(ServerId, Acc1) ->
                    case lists:member(ServerId, ServerIdL) of
                        true -> [ServerId|Acc1];
                        _ -> Acc1
                    end
                end,
                lists:foldl(F1, TemAcc, lists:flatten(TList))
            end,
            ServerIdList = lists:foldl(F, [], BattList),
            Acc++ServerIdList;
        (_, Acc) -> Acc
    end,
    List = lists:foldl(Fun, [], BattleList),
    spawn(
        fun() -> 
            Fun1 = fun(ServerId, Sum) ->
                Res = Sum rem 10,
                if
                    Res == 0 ->
                        timer:sleep(10);
                    true ->
                        skip
                end,
                case lib_clusters_center:get_node(ServerId) of
                    undefined -> skip;
                    Node -> 
                        mod_clusters_center:apply_cast(Node, mod_c_sanctuary_local, update_state, [Type, Args])     
                end,
                Sum+1
            end,
            lists:foldl(Fun1, 0, List)
    end).

update_local_data(ZoneMap, BattleMap, ZoneId, server, [ServersInfo, DivideScene]) ->
    BattList = maps:get(ZoneId, BattleMap, []),
    ServerIdL = maps:get(ZoneId, ZoneMap, []),
    F = fun({_, TList}, TemAcc) ->
        F1 = fun(ServerId, Acc1) ->
            case lists:member(ServerId, ServerIdL) of
                true -> [ServerId|Acc1];
                _ -> Acc1
            end
        end,
        lists:foldl(F1, TemAcc, lists:flatten(TList))
    end,
    List = lists:foldl(F, [], BattList),
    % ?PRINT("================BattList:~p List:~p~n",[BattList,List]),
    Fun1 = fun(ServerId) ->
        case lib_clusters_center:get_node(ServerId) of
            undefined -> skip;
            Node -> 
                {Santype, EnemyServerIds} = get_server_santype(ServerId, BattleMap, ZoneId),
                SendServerInfo = get_enemy_server_info(EnemyServerIds, ServersInfo),
                % ?PRINT("================ Santype:~p~n",[Santype]),
                mod_clusters_center:apply_cast(Node, mod_c_sanctuary_local, update_state, [server, [Santype, EnemyServerIds, SendServerInfo, DivideScene, ZoneId]])
        end
    end,
    lists:foreach(Fun1, ulists:removal_duplicate(List));

update_local_data(ZoneMap, BattleMap, ZoneId, san, [SanList]) ->
    BattList = maps:get(ZoneId, BattleMap, []),
    ServerIdL = maps:get(ZoneId, ZoneMap, []),
    F = fun({TemSantype, TList}, TemAcc) ->
        F1 = fun(ServerId, Acc1) ->
            case lists:member(ServerId, ServerIdL) of
                true -> [{ServerId, TemSantype}|Acc1];
                _ -> Acc1
            end
        end,
        lists:foldl(F1, TemAcc, lists:flatten(TList))
    end,
    List = lists:foldl(F, [], BattList),
    Fun1 = fun({ServerId, Santype}) ->
        case lib_clusters_center:get_node(ServerId) of
            undefined -> skip;
            Node -> 
                case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
                    San when is_record(San, c_san_state) ->
                        SendSanList = [San];
                    _ -> 
                        SendSanList = SanList
                end,
                mod_clusters_center:apply_cast(Node, mod_c_sanctuary_local, update_state, [san, [SendSanList]])
        end
    end,
    lists:foreach(Fun1, ulists:removal_duplicate(List));

update_local_data(ZoneMap, BattleMap, ZoneId, Type, Args) ->
    BattList = maps:get(ZoneId, BattleMap, []),
    ServerIdL = maps:get(ZoneId, ZoneMap, []),
    F = fun({_, TList}, TemAcc) ->
        F1 = fun(ServerId, Acc1) ->
            case lists:member(ServerId, ServerIdL) of
                true -> [ServerId|Acc1];
                _ -> Acc1
            end
        end,
        lists:foldl(F1, TemAcc, lists:flatten(TList))
    end,
    List = lists:foldl(F, [], BattList),
    Fun1 = fun(ServerId) ->
        case lib_clusters_center:get_node(ServerId) of
            undefined -> skip;
            Node -> 
                mod_clusters_center:apply_cast(Node, mod_c_sanctuary_local, update_state, [Type, Args])
        end
    end,
    lists:foreach(Fun1, ulists:removal_duplicate(List)).

update_local_data(ZoneMap, BattleMap, ZoneId, Santype, Type, Args) ->
    BattList = maps:get(ZoneId, BattleMap, []),
    ServerIdL = maps:get(ZoneId, ZoneMap, []),
    F = fun
        ({TemSantype, TList}, TemAcc) when TemSantype == Santype ->
            F1 = fun(ServerId, Acc1) ->
                case lists:member(ServerId, ServerIdL) of
                    true -> [ServerId|Acc1];
                    _ -> Acc1
                end
            end,
            lists:foldl(F1, TemAcc, lists:flatten(TList));
        (_, Acc) -> Acc
    end,
    List = lists:foldl(F, [], BattList),
    Fun1 = fun(ServerId) ->
        case lib_clusters_center:get_node(ServerId) of
            undefined -> skip;
            Node -> 
                mod_clusters_center:apply_cast(Node, mod_c_sanctuary_local, update_state, [Type, Args])
        end
    end,
    lists:foreach(Fun1, ulists:removal_duplicate(List)).

calc_mon_hurt_info(OldHurtInfo, ConType) ->
    if
        ConType =/= ?CONS_TYPE_1 ->
            % HurtInfoList = maps:get(MonBlServer, OldHurtInfo, []),
            % ?PRINT("MonBlServer:~p,OldHurtInfo:~p~n",[MonBlServer, OldHurtInfo]),
            % NewMap = maps:put(MonBlServer, HurtInfoList, #{});
            NewMap = OldHurtInfo;
        true ->
            NewMap = OldHurtInfo
    end,
    NewMap.

%% -----------------------------------------------------------------
%% 计算服平均世界等级
%% -----------------------------------------------------------------
calc_average_wlv(ServerIdList, ServerInfo) ->
    Fun = fun(ServerId, {Sum, Num}) ->
        case lists:keyfind(ServerId, 1, ServerInfo) of
            {ServerId, _, WorldLv,_,_} -> skip;
            _ -> WorldLv = 0
        end,
        {WorldLv + Sum, Num + 1}
    end,
    {SumLv, Total} = lists:foldl(Fun, {0,0}, ServerIdList),
    if
        Total == 0 ->
            0;
        true ->
            SumLv div Total
    end.
    
%% -----------------------------------------------------------------
%% 计算贡献值
%% -----------------------------------------------------------------
calc_point_map(NewMap, _ZoneId, [], _ServerInfo, _, HurtInfo, _, _) -> {NewMap, HurtInfo};
calc_point_map(OldPointMap, ZoneId, [{Camp, HurtInfoList}|T], ServerInfo, BeginList, HurtInfo, Serverids, BatZoneMap) ->
    % HurtInfoList = maps:get(MonBlServer, HurtInfo, []),
    ?PRINT("List:~p~n",[[{Camp, HurtInfoList}|T]]),
    ZoneIdL = maps:get(ZoneId, BatZoneMap, []),
    BlserverL = get_server_by_point(Camp, Serverids, BeginList),
    WorldLv = calc_average_wlv(BlserverL, ServerInfo),
    WlvLimit = data_cluster_sanctuary:get_all_wlv(),
    F1 = fun({WlvMin, WlvMax}) ->
        WorldLv >= WlvMin andalso WorldLv =< WlvMax
    end,
    case ulists:find(F1, WlvLimit) of
        {ok, {Min, Max}} -> 
            HurtList = data_cluster_sanctuary:get_limit_hurt_list(Min, Max),
            HurtList;
        _ ->
            %?PRINT("============:~n",[]),
            HurtList = []
    end,
    RolePointList = maps:get({ZoneId, Camp}, OldPointMap, []),
    Fun = fun
        ({ServerNum, RoleId, Name, ServerId, TemHurt, LastHurt}, {Acc, Acc1}) ->
            % RealAddPoint = AddPoint * (Hurt div LimitHurt),
            F2 = fun(Hurt, {Add, Sum}) ->
                case data_cluster_sanctuary:get_point_rule(WorldLv, Hurt) of
                    #base_c_sanctuary_point{hurt = LimitHurt, hurt_add = AddPoint} when TemHurt >= LimitHurt andalso Sum < LimitHurt -> 
                        {Add+AddPoint, LimitHurt};
                    _ -> 
                        {Add, Sum}
                end
            end,
            %% 计算玩家伤害增加的贡献值
            {NewAddPoint, NewLastHurt} = lists:foldl(F2, {0, LastHurt}, HurtList),
            NewAcc = case lists:keyfind(RoleId, 2, Acc) of
                {_, _, _, _, KillPoint, BossPoint, Total} ->
                    lists:keystore(RoleId, 2, Acc, {ServerNum, RoleId, Name, ServerId, KillPoint, BossPoint+NewAddPoint, Total+NewAddPoint});
                _ ->
                    lists:keystore(RoleId, 2, Acc, {ServerNum, RoleId, Name, ServerId, 0, NewAddPoint, NewAddPoint})
            end,
            {NewAcc, lists:keystore(RoleId, 2, Acc1, {ServerNum, RoleId, Name, ServerId, TemHurt, NewLastHurt})};
        (_, Acc) -> Acc
    end,
    {NewList, NewHurtInfoList} = lists:foldl(Fun, {RolePointList, HurtInfoList}, HurtInfoList),

    Fun1 = fun(TemZoneId, Map) ->
        maps:put({TemZoneId, Camp}, NewList, Map)
    end,
    NewMap = lists:foldl(Fun1, OldPointMap, ZoneIdL),
    % ?MYLOG("xlh","BatZoneMap:~p, ZoneIdL:~p~n",[BatZoneMap,ZoneIdL]),
    RealMap = maps:put({ZoneId, Camp}, NewList, NewMap),
    [update_local_data(ServerId, point, [NewList]) || ServerId <- BlserverL],
    calc_point_map(RealMap, ZoneId, T, ServerInfo, BeginList, maps:put(Camp, NewHurtInfoList, HurtInfo), Serverids, BatZoneMap).

%% -----------------------------------------------------------------
%% 计算拍卖产出
%% -----------------------------------------------------------------
calc_produce_for_auction(ZoneId, ServerId, MonBlCamp, NewBlCamp, ConBlCamp, ServerInfo, Scene, ConType, MonId, _SanMonType, RoleIdList, PointMap, AuctionWorth, BeginList) ->
    if
        ConType == ?CONS_TYPE_1 andalso NewBlCamp =/= 0 andalso NewBlCamp =/= ConBlCamp ->
            BlserverL = get_server_by_point(NewBlCamp, ServerId, BeginList),
            WorldLv = calc_average_wlv(BlserverL, ServerInfo),
            % ?PRINT("=========== WorldLv:~p~n",[WorldLv]),
            case data_cluster_sanctuary:get_auction_by_scene(Scene, WorldLv) of
                #base_c_sanctuary_auction_scene{worth = Worth, ratio = Ratio, produce = Produce, bgold_worth = BWorth, 
                        bgold_ratio = BRatio, bgold_produce = BProduce} ->

                    Sum = calc_all_weight(Produce, 0),
                    BSum = calc_all_weight(BProduce, 0),
                    Length = erlang:length(RoleIdList),
                    GoldProduceList = calc_produce_num(Produce, Sum, Worth+Length*Ratio),
                    BGoldProduceList = calc_produce_num(BProduce, BSum, BWorth+Length*BRatio),
                    %?PRINT("===============  Length:~p, Produce:~p~n", [Length, GoldProduceList++BGoldProduceList]),
                    {0, GoldProduceList++BGoldProduceList, RoleIdList, AuctionWorth+Worth+Length*Ratio, Scene};
                _ ->
                    ?ERR("Miss cfg for auction! {Scene, WorldLv}:~p~n",[{Scene, WorldLv}]),
                    {0, [], [], AuctionWorth, 0}
            end;
        ConType =/= ?CONS_TYPE_1 andalso MonBlCamp =/= 0 ->
            BlserverL = get_server_by_point(MonBlCamp, ServerId, BeginList),
            WorldLv = calc_average_wlv(BlserverL, ServerInfo),
            PointList = maps:get({ZoneId, MonBlCamp}, PointMap, []),
            case data_cluster_sanctuary:get_auction_by_mon(MonId, WorldLv) of
                #base_c_sanctuary_auction_boss{worth = Worth, produce = Produce, bgold_worth = BWorth, bgold_produce = BProduce} ->
                    Sum = calc_all_weight(Produce, 0),
                    BSum = calc_all_weight(BProduce, 0),
                    PointLimitL = data_cluster_sanctuary:get_san_value(auction_point_limit),
                    RealRoleIdList = calc_role_list_from_pointmap(WorldLv, PointLimitL, PointList, ServerId),
                    % ?PRINT("============ ZoneId:~p,RealRoleIdList:~p~n",[ZoneId,RealRoleIdList]),
                    GoldProduceList = calc_produce_num(Produce, Sum, Worth),
                    BGoldProduceList = calc_produce_num(BProduce, BSum, BWorth),
                    {1, GoldProduceList++BGoldProduceList, RealRoleIdList, AuctionWorth+Worth, MonId};
                _ ->
                    ?ERR("Miss cfg for auction! {MonId, WorldLv}:~p~n",[{MonId, WorldLv}]),
                    {0, [], [], AuctionWorth, 0}
            end;
        true ->
            {0, [], [], AuctionWorth, 0}
    end.

calc_all_weight([], Sum) -> Sum;
calc_all_weight([{_, Weight, _, _}|T], Sum) ->
    calc_all_weight(T, Sum + Weight).

% %% 保留小数点后几位数字 
% %% Float：需要处理的小数 Num:保留几位小数
% handle_float(Float, Num) ->
%     N = math:pow(10, Num),
%     round(Float * N)/N.

calc_produce_num(Produce, Sum, Worth) ->
    Fun = fun({AuctionId, _Weight, PercentNum, Sort}, {Acc, Acc1, TemSum}) ->
        BefNum = (Worth * PercentNum) div Sum,
        NumWeight = (Worth * 100 * PercentNum) div Sum rem 100,
        NumWeightList = [{100 - NumWeight, BefNum}, {NumWeight, BefNum+1}],
        RealNum = urand:rand_with_weight(NumWeightList),
        % ?MYLOG("xlh","AuctionId:~p, Worth:~p, Sum:~p, NumWeightList:~p, RealNum:~p~n",[AuctionId,Worth,Sum,NumWeightList, RealNum]),
        if
            RealNum == 0 ->
                {Acc, Acc1, TemSum};
            Sort == ?AUCTION_RARE ->
                {Acc, [{PercentNum, AuctionId}|Acc1], TemSum+RealNum};
            true ->
                {[{AuctionId, RealNum}|Acc], Acc1, TemSum}
        end;
        (_, TemAcc) -> TemAcc
    end,
    {NormalList, RareList, RareNumSum} = lists:foldl(Fun, {[],[], 0}, Produce),
    RareNum = (RareNumSum * 100) div 100,
    RareNumWeight = (RareNumSum * 100) rem 100,
    RareNumWeightList = [{100 - RareNumWeight, RareNum}, {RareNumWeight, RareNum+1}],
    RealRareNum = urand:rand_with_weight(RareNumWeightList),
    RareAuction = urand:rand_with_weight(RareList),
    if
        RealRareNum == 0 ->
            NormalList;
        true ->
            [{RareAuction, RealRareNum}|NormalList]
    end.

%% -----------------------------------------------------------------
%% 统计所有贡献值达标的玩家
%% -----------------------------------------------------------------
calc_role_list_from_pointmap(WorldLv, PointLimitL, PointList, ServerId) ->
    Fun = fun({Min, Max, _}) ->
        WorldLv >= Min andalso WorldLv =< Max
    end,
    case ulists:find(Fun, PointLimitL) of
        {ok, {_,_, PointLimit}} ->
            PointLimit;
        _ ->
            PointLimit = 1
    end,
    Fun1 = fun
        ({_, RoleId, _, TemServerId, _, _, Total}, Acc) when Total >= PointLimit andalso ServerId == TemServerId ->
             [RoleId|Acc];
        (_, Acc) ->
            Acc
    end,
    lists:foldl(Fun1, [], PointList).

%% -----------------------------------------------------------------
%% 计算额外产出
%% -----------------------------------------------------------------
calc_extra_produce(AuctionWorth, ExtraState) ->
    List = data_cluster_sanctuary:get_san_value(auction_extra),
    Fun = fun
        ({Worth, State}, {Acc, Acc1}) when State == 0 andalso AuctionWorth >= Worth ->
            case lists:keyfind(Worth, 1, List) of
                {Worth, Num, AuctionWeightList} ->
                    AuctionId = urand:rand_with_weight(AuctionWeightList),
                    {[{AuctionId, Num}|Acc], lists:keyreplace(Worth, 1, Acc1, {Worth, 1})};
                _ ->
                    {Acc, Acc1}
            end;
        (_, Tem) ->
            Tem
    end,
    lists:foldl(Fun, {[], ExtraState}, ExtraState).

%% -----------------------------------------------------------------
%% 拍卖限制时间内进入跨服圣域场景，分红玩家更新
%% -----------------------------------------------------------------
calc_auction_role_list(State, _, _, _, _, _, [], _, _) -> State;
calc_auction_role_list(State, ZoneId, RoleId, _Code, CopyId, Santype, [Scene|_], SanState, ServerId) ->
    case get_scene_info(ZoneId, CopyId, Santype, Scene, SanState) of
        {true, San, SanList, ConstructionsMap, Constructions, #c_cons_state{bl_server = 0, auction_reward_role = ServerRole, cons_type = ConType} = Construction} when ConType == ?CONS_TYPE_1 ->
            case lists:keyfind(ServerId, 1, ServerRole) of
                {_, RoleIdList} -> skip;
                _ -> RoleIdList = []
            end,
            if
                _Code == 1 ->
                    NewCon = Construction#c_cons_state{
                        auction_reward_role = lists:keystore(ServerId, 1, ServerRole, {ServerId, [RoleId|lists:delete(RoleId, RoleIdList)]})
                    },
                    NewCons = lists:keystore(Scene, #c_cons_state.scene_id, Constructions, NewCon),
                    NewMap = maps:put({ZoneId, CopyId}, NewCons, ConstructionsMap),
                    NewSan = San#c_san_state{cons_state = NewMap},
                    NewSanList = lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan),
                    NewSanMap = maps:put(ZoneId, NewSanList, SanState),
                    State#c_sanctuary_state{san_state = NewSanMap};
                true ->
                    State
            end;
        _E ->
            State
    end.

%% -----------------------------------------------------------------
%% 更新对战分区的内存数据
%% -----------------------------------------------------------------
update_other_zone_data(ZoneMap, BattleMap, SanMap, BatZoneMap, SanList, ZoneId) ->
    update_other_zone_data(ZoneMap, BattleMap, SanMap, BatZoneMap, SanList, ZoneId, true, []).

update_other_zone_data(ZoneMap, BattleMap, SanMap, BatZoneMap, SanList, ZoneId, UpdateLocal, UpdateList) ->
    case maps:get(ZoneId, BatZoneMap, []) of
        ZoneIdList when is_list(ZoneIdList) andalso ZoneIdList =/= [] ->
            ZoneIdList;
        _ ->
            ZoneIdList = [ZoneId]
    end,
    update_other_zone_data_core(ZoneMap, BattleMap, SanMap, BatZoneMap, SanList, ZoneIdList, UpdateLocal, UpdateList).

update_other_zone_data_core(ZoneMap, BattleMap, SanMap, BatZoneMap, SanList, ZoneIdList, UpdateLocal, UpdateList) ->
    F = fun(Zone, {TMap, TMap1}) ->
        F1 = fun(#c_san_state{san_type = TemSantype, cons_state = ConMap} = TemSan, Acc) ->
            NewMap = lists:foldl(
                    fun({{_, H}, Value}, TemCMap) -> maps:put({Zone, H}, Value, TemCMap) end, #{}, maps:to_list(ConMap)),
            lists:keystore(TemSantype, #c_san_state.san_type, Acc, TemSan#c_san_state{cons_state = NewMap})
        end,
        NewSanList = lists:foldl(F1, [], SanList),
        if
            UpdateLocal == true ->
                case UpdateList of
                    [{_,_,Santype,_,_}|_] ->
                        update_local_data(ZoneMap, BattleMap, Zone, Santype, san_data, UpdateList);
                    _ ->
                        update_local_data(ZoneMap, BattleMap, Zone, san, [NewSanList])
                end;
            true ->
                skip
        end,
        {maps:put(Zone, NewSanList, TMap), maps:remove(Zone, TMap1)}
    end,
    lists:foldl(F, {SanMap, BatZoneMap}, ZoneIdList).

%% -----------------------------------------------------------------
%% 统计要塞占领分红玩家
%% -----------------------------------------------------------------
calc_real_role_list(ZoneId, [], CopyId, Santype, _, _) -> 
    ?ERR("ZoneId:~p, CopyId:~p, Santype:~p~n",[ZoneId, CopyId, Santype]),
    [];
calc_real_role_list(ZoneId, [ServerId|_], CopyId, Santype, BeginMap, SanState) ->
    BeginList = maps:get(ZoneId, BeginMap, []),
    PointList = get_begin_scene(ServerId, BeginList, []),
    Fun = fun(TemPoint, Acc) ->
        TSceneL = data_cluster_sanctuary:get_can_enter_scenes(TemPoint),
        Acc ++ TSceneL
    end,
    SceneL = lists:foldl(Fun, [], PointList),
    F = fun(Scene, Acc) ->
        case get_scene_info(ZoneId, CopyId, Santype, Scene, SanState) of
            {true, _, _, _, _, #c_cons_state{auction_reward_role = RoleIdList, cons_type = ConType}} when ConType == ?CONS_TYPE_1 ->
                F1 = fun({TemServerId, List}, Acc1) ->    
                    case lists:keyfind(TemServerId, 1, Acc1) of
                        {_, RoleIdL} -> skip;
                        _ -> RoleIdL = []
                    end,
                    lists:keystore(TemServerId, 1, Acc1, {TemServerId, List++RoleIdL})
                end,
                lists:foldl(F1, Acc, RoleIdList);
            _ ->
                Acc
        end
    end,
    ulists:removal_duplicate(lists:foldl(F, [], SceneL)).

%% -----------------------------------------------------------------
%% 对战服信息
%% -----------------------------------------------------------------
get_enemy_server_info(EnemyServerIds, ServersInfo) ->
    Fun = fun(ServerId, Acc) ->
        case lists:keyfind(ServerId, 1, ServersInfo) of
            {ServerId, _, _, _, _} = H ->
                lists:keystore(ServerId, 1, Acc, H);
            _ ->
                Acc
        end
    end,
    lists:foldl(Fun, [], EnemyServerIds).