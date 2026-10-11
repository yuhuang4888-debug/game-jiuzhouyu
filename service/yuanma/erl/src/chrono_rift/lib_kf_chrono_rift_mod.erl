%%%-----------------------------------
%%% @Module      : lib_kf_chrono_rift_mod
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 27. 十一月 2019 15:20
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_kf_chrono_rift_mod).
-author("carlos").
-include("chrono_rift.hrl").
-include("common.hrl").
-include("clusters.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
%% API
-export([]).





init() ->
    ZoneIds = mod_zone_mgr:get_all_zone_ids(),
    CastleIdList = data_chrono_rift:get_castle_ids(),
    F = fun(ZoneId, AccMap) ->
        CastleList = init_castle_list(CastleIdList, ZoneId),
        %% 分配出生据点
        %% 不管是否开启都会分配基地，状态只是控制能不能添加注入值之类的
        NewCastleList = lib_kf_chrono_rift:alloc_base_castle(ZoneId, CastleList),
        NewAccMap = maps:put(ZoneId, NewCastleList, AccMap),
        NewAccMap
        end,
    %% 初始化，所有的据点
    CastleListMap = lists:foldl(F, #{}, ZoneIds),
    Ref = lib_kf_chrono_rift:get_end_ref([]),
    ZoneState = lib_kf_chrono_rift:get_init_zone_state(ZoneIds),
    #chrono_rift_state{castle_map = CastleListMap, end_ref = Ref, zone_state = ZoneState}.


init(OldState) ->
    #chrono_rift_state{end_ref = OldRef} = OldState,
    ZoneIds = mod_zone_mgr:get_all_zone_ids(),
    CastleIdList = data_chrono_rift:get_castle_ids(),
    F = fun(ZoneId, AccMap) ->
        CastleList = init_castle_list(CastleIdList, ZoneId),
        %% 分配出生据点
        %% 不管是否开启都会分配基地，状态只是控制能不能添加注入值之类的
        NewCastleList = lib_kf_chrono_rift:alloc_base_castle(ZoneId, CastleList),
        NewAccMap = maps:put(ZoneId, NewCastleList, AccMap),
        NewAccMap
        end,
    %% 初始化，所有的据点
    CastleListMap = lists:foldl(F, #{}, ZoneIds),
    Ref = lib_kf_chrono_rift:get_end_ref(OldRef),
    ZoneState = lib_kf_chrono_rift:get_init_zone_state(ZoneIds),
    #chrono_rift_state{castle_map = CastleListMap, end_ref = Ref, zone_state = ZoneState}.



init_castle_list(CastleIdList, ZoneId) ->
    AllZone = mod_zone_mgr:get_all_zone(),
    MergerMap = init_castle_list_help(AllZone),
    init_castle_list(CastleIdList, ZoneId, [], MergerMap).


init_castle_list([], _ZoneId, AccList, _MergerMap) ->
    AccList;
init_castle_list([Id | CastleIdList], ZoneId, AccList, MergerMap) ->
    % 获取据点Id的配置信息
    % 获取该区域该据点的角色信息
    % 获取该区域该据点信息
    % 计算各服争夺值信息 #castle_server_msg{}
    case data_chrono_rift:get_castle(Id) of
        #cfg_chrono_rift_castle{lv = Lv, connect_castle = ConnectIdList} ->
            RoleList = lib_kf_chrono_rift:get_castle_role_list(Id, ZoneId),
            SortRoleList = lib_kf_chrono_rift:sort_castle_role(RoleList),
            case lib_chrono_rift_data:db_get_castle(Id, ZoneId) of
                [ServerId, ServerNum, ServerName, _ScrambleValueListDb, Time, OccupyCount, BaseServerId, HaveServerIds] ->
                    ScrambelValueList = repair_server_msg([], RoleList, MergerMap),
                    %% 处理合服后的数据，有可能合服后，服的争夺值很高，但是没有占领，
                    %% 策略 ，如果这个服的数据比所需值更高，则直接占领，但是不会触发任务
                    case ScrambelValueList of
                        [] ->
                            Ref = lib_kf_chrono_rift:send_timer([], Time, ServerId, Id),
                            NewCastle = #chrono_rift_castle{
                                id = Id
                                , zone_id = ZoneId
                                , lv = Lv
                                , connect_castle = ConnectIdList
                                , current_server_id = ServerId
                                , current_server_num = ServerNum
                                , current_server_name = binary_to_list(ServerName)
                                , scramble_value = ScrambelValueList
                                , occupy_count = OccupyCount
                                , time = Time
                                , base_server_id = BaseServerId
                                , timer_ref = Ref
                                , have_servers = util:bitstring_to_term(HaveServerIds)
                            };
                        _ ->
                            case hd(ScrambelValueList) of
                                #castle_server_msg{server_id = ServerId, value = MaxValue} ->  %% 原占领服是争夺值最高的服
                                    Ref = lib_kf_chrono_rift:send_timer([], Time, ServerId, Id),
                                    NewOccupyCount = lib_kf_chrono_rift:calc_occupy_num(MaxValue, OccupyCount, ServerId, Lv),
                                    NewCastle = #chrono_rift_castle{
                                        id = Id
                                        , zone_id = ZoneId
                                        , lv = Lv
                                        , connect_castle = ConnectIdList
                                        , current_server_id = ServerId
                                        , current_server_num = ServerNum
                                        , current_server_name = binary_to_list(ServerName)
                                        , scramble_value = ScrambelValueList
                                        , occupy_count = NewOccupyCount
                                        , time = Time
                                        , base_server_id = BaseServerId
                                        , timer_ref = Ref
                                        , have_servers = util:bitstring_to_term(HaveServerIds)
                                    },
                                    lib_chrono_rift_data:db_save_castle(NewCastle);   %% 同步数据库
                                #castle_server_msg{server_id = MaxServerId, value = MaxValue, server_name = MaxServerName, server_num = MaxServerNum} ->
                                    NewOccupyCount = lib_kf_chrono_rift:calc_occupy_num(MaxValue, OccupyCount, MaxServerId, Lv),
                                    NewHaveServerIds = lists:delete(MaxServerId, util:bitstring_to_term(HaveServerIds)) ++ [MaxServerId],
                                    {LastServerId, LastServerNum, LastServerName} =
                                    if
                                        NewOccupyCount == OccupyCount -> {ServerId, ServerNum, ServerName};
                                        true                          -> {MaxServerId, MaxServerNum, MaxServerName}
                                    end,
                                    NewCastle = #chrono_rift_castle{
                                        id = Id
                                        , zone_id = ZoneId
                                        , lv = Lv
                                        , connect_castle = ConnectIdList
                                        , current_server_id = LastServerId
                                        , current_server_num = LastServerNum
                                        , current_server_name = LastServerName
                                        , scramble_value = ScrambelValueList
                                        , occupy_count = NewOccupyCount
                                        , time = 0
                                        , base_server_id = BaseServerId
                                        , timer_ref = []
                                        , have_servers = NewHaveServerIds
                                    },
                                    lib_chrono_rift_data:db_save_castle(NewCastle)
                            end
                    end;
                _ ->
                    NewCastle = #chrono_rift_castle{
                        id = Id
                        , zone_id = ZoneId
                        , lv = Lv
                        , connect_castle = ConnectIdList
                    }
            end,
            LastCastle = NewCastle#chrono_rift_castle{role_list = SortRoleList},
            init_castle_list(CastleIdList, ZoneId, [LastCastle | AccList], MergerMap);
        _ ->
            init_castle_list(CastleIdList, ZoneId, AccList, MergerMap)
    end.

add_scramble_value(Role, 0, Value, State) ->  %% 第一次注入争夺值
    ZoneId = lib_clusters_center_api:get_zone(Role#castle_role_msg.server_id),
    #chrono_rift_state{castle_map = Map} = State,
    CastleList = maps:get(ZoneId, Map, []),
    CastleId = lib_kf_chrono_rift:get_default_castle_id(CastleList, Role#castle_role_msg.server_id),
    %% 同步玩家据点的id
    ?MYLOG("chrono", "add_scramble_value CastleId ~p ~n", [CastleId]),
    NewRole = Role#castle_role_msg{castle_id = CastleId},
    lib_kf_chrono_rift:update_local_role_castle_id(NewRole, CastleId),
    add_scramble_value(NewRole, CastleId, Value, State);
add_scramble_value(_Role, CastleId, Value, State) ->
    #castle_role_msg{role_id = RoleId, server_id = ServerId, server_num = ServerNum, server_name = ServerName} = _Role,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    Role = _Role#castle_role_msg{zone_id = ZoneId},
    #chrono_rift_state{castle_map = CastleMap} = State,
    CastleList = maps:get(ZoneId, CastleMap, []),
    case lists:keyfind(CastleId, #chrono_rift_castle.id, CastleList) of
        #chrono_rift_castle{role_list = RoleList, current_server_id = CurrentServerId,
            base_server_id = BaseServerId, scramble_value = ValueList} = Castle ->
            LastValue = lib_kf_chrono_rift:get_scramble_value_with_ratio(Value, CurrentServerId, BaseServerId, Role#castle_role_msg.server_id),
            NewValueList = lib_kf_chrono_rift:add_server_scramble_value(ValueList, {ServerId, ServerNum, ServerName, LastValue}),
            case lists:keyfind(RoleId, #castle_role_msg.role_id, RoleList) of
                #castle_role_msg{scramble_value = OldValue} ->  %% 之前有驻扎过
                    NewRoleMsg = Role#castle_role_msg{scramble_value = OldValue + LastValue, is_occupy = ?is_occupy},
                    NewRoleList = lists:keystore(RoleId, #castle_role_msg.role_id, RoleList, NewRoleMsg),
                    _NewCastle = Castle#chrono_rift_castle{role_list = NewRoleList, scramble_value = NewValueList},
                    NewCastle = lib_kf_chrono_rift:handle_af_add_scramble_value(_NewCastle, NewRoleMsg, LastValue, CastleList, ValueList, Value),
                    ?MYLOG("chrono", "add_scramble_value NewCastle ~p ~n", [NewCastle]),
                    lib_kf_chrono_rift:save_to_db_castle(NewCastle),   %% 同步数据库
                    NewCastleList = lists:keystore(CastleId, #chrono_rift_castle.id, CastleList, NewCastle),
                    NewCastleMap = maps:put(ZoneId, NewCastleList, CastleMap),
                    State#chrono_rift_state{castle_map = NewCastleMap};
                _ ->  %% 现在第一次
                    NewRoleMsg = Role#castle_role_msg{scramble_value = LastValue, is_occupy = ?is_occupy},
                    NewRoleList = lists:keystore(RoleId, #castle_role_msg.role_id, RoleList, NewRoleMsg),
                    _NewCastle = Castle#chrono_rift_castle{role_list = NewRoleList, scramble_value = NewValueList},
                    NewCastle = lib_kf_chrono_rift:handle_af_add_scramble_value(_NewCastle, NewRoleMsg, LastValue, CastleList, ValueList, Value),
                    ?MYLOG("chrono", "add_scramble_value NewCastle ~p ~n", [NewCastle]),
                    lib_kf_chrono_rift:save_to_db_castle(NewCastle),   %% 同步数据库
                    NewCastleList = lists:keystore(CastleId, #chrono_rift_castle.id, CastleList, NewCastle),
                    NewCastleMap = maps:put(ZoneId, NewCastleList, CastleMap),
                    State#chrono_rift_state{castle_map = NewCastleMap}
            end;
        _ ->
            %%
            State
    end.


%%占领超过12个小时
occupy_twelve(ServerId, CastleId, State) ->
%%	?MYLOG("chrono", "occupy_twelve +++++++++++++++++ ~n", []),
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    #chrono_rift_state{castle_map = ZoneMap} = State,
    CastleList = maps:get(ZoneId, ZoneMap, []),
    case lists:keyfind(CastleId, #chrono_rift_castle.id, CastleList) of
        #chrono_rift_castle{current_server_id = CurServerId, current_server_num = CurrServerNum, current_server_name = CurrServerName, lv = Lv} ->
            %%任务4
            mod_kf_chrono_rift_goal:add_goal_value(?goal4, CurServerId, CurrServerNum, CurrServerName, Lv);
        _ ->
            skip
    end,
    State.


get_act_info(ServerId, RoleId, MyScrambleValue, State) ->
    #chrono_rift_state{castle_map = Map} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CastleList = maps:get(ZoneId, Map, []),
    {ServerScrambleAllValue, CastlePackList} = pack_info_list(CastleList, ServerId),
    ?MYLOG("chrono", "get_act_info ~n ~p~n", [{MyScrambleValue, ServerScrambleAllValue, CastlePackList}]),
    {ok, Bin} = pt_204:write(20401, [MyScrambleValue, ServerScrambleAllValue, CastlePackList]),
    lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin).


%% -----------------------------------------------------------------
%% @desc     功能描述  打包 01协议的数据
%% @param    参数      CastleList::[#chrono_rift_castle{}]
%% @return   返回值    {V, List}   V::serverId所在的服所有的争夺值
%% @history  修改历史
%% -----------------------------------------------------------------
pack_info_list(CastleList, ServerId) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    ServerList = mod_zone_mgr:get_zone_server(ZoneId),
    pack_info_list(CastleList, ServerId, {0, []}, ServerList).



pack_info_list([], _ServerId, {V, List}, _ServerList) ->
    {V, List};
pack_info_list([H | T], ServerId, {V, List}, ServerList) ->
    #chrono_rift_castle{
        id = CastleId,
        occupy_count = Count,
        base_server_id = BaseServerId,
        lv = Lv,
        current_server_num = CurrSerNum,
        current_server_name = CurrName,
        scramble_value = ValueList,
        role_list = RoleList
    } = H,
    BaseServerNum =
        case lists:keyfind(BaseServerId, #zone_base.server_id, ServerList) of
            #zone_base{server_num = TempN} ->
                TempN;
            _ ->
                0
        end,
    NextNeedValue = lib_kf_chrono_rift:get_next_scramble_value(Count, ServerId, Lv),
    PackValues = [{ServerNum1, ServerName1, Value1} || #castle_server_msg{server_num = ServerNum1, server_name = ServerName1,
        value = Value1
    } <- ValueList],
    {OccupyRoleNum, ProvideNum} = lib_kf_chrono_rift:get_occupy_role_msg(RoleList, ServerId),
    PackRoleList = [{RoleSerNum, RoleName, RoleValue, IsOcc}
        || #castle_role_msg{server_num = RoleSerNum, role_name = RoleName, scramble_value = RoleValue, is_occupy = IsOcc} <- lib_kf_chrono_rift:sort_castle_role(RoleList)],
    MyServerScrambleValue = lib_kf_chrono_rift:get_server_scramble_value(ServerId, ValueList),
    NewList = [{CastleId, BaseServerNum, NextNeedValue, CurrSerNum, CurrName, PackValues, PackRoleList, OccupyRoleNum, ProvideNum} | List],
    pack_info_list(T, ServerId, {V + MyServerScrambleValue, NewList}, ServerList).



get_castle_info(ServerId, RoleId, CastleId, _MyScrambleValue, State) ->
    #chrono_rift_state{castle_map = Map} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CastleList = maps:get(ZoneId, Map, []),
    case lists:keyfind(CastleId, #chrono_rift_castle.id, CastleList) of
        #chrono_rift_castle{
            id = CastleId,
            base_server_id = BaseServerId,
            occupy_count = Count,
            lv = Lv,
            current_server_num = CurrSerNum,
            current_server_name = CurrName,
            scramble_value = ValueList,
            role_list = RoleList
        } ->
            TempServerList = mod_zone_mgr:get_zone_server(lib_clusters_center_api:get_zone(ServerId)),
            BaseServerNum =
                case lists:keyfind(BaseServerId, #zone_base.server_id, TempServerList) of
                    #zone_base{server_num = TempN} ->
                        TempN;
                    _ ->
                        0
                end,
            NextNeedValue = lib_kf_chrono_rift:get_next_scramble_value(Count, ServerId, Lv),
            SortValueList = lib_kf_chrono_rift:sort_scramble_value(ValueList),
            PackValues = [{ServerNum1, ServerName1, Value1} || #castle_server_msg{server_num = ServerNum1, server_name = ServerName1, value = Value1} <- SortValueList],
            PackRoleList = [{RoleSerNum, RoleName, RoleValue, IsOcc}
                || #castle_role_msg{server_num = RoleSerNum, role_name = RoleName, scramble_value = RoleValue, is_occupy = IsOcc} <- lib_kf_chrono_rift:sort_castle_role(RoleList)],
            {OccupyRoleNum, ProvideNum} = lib_kf_chrono_rift:get_occupy_role_msg(RoleList, ServerId),
%%            ?MYLOG("chrono", "get_castle_info ~n~p~n", [{CastleId, NextNeedValue, CurrSerNum, CurrName, PackValues, PackRoleList, OccupyRoleNum, ProvideNum}]),
            {ok, Bin} = pt_204:write(20402, [CastleId, BaseServerNum, NextNeedValue, CurrSerNum, CurrName, PackValues, PackRoleList, OccupyRoleNum, ProvideNum]),
            lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin);
        _ ->
            lib_kf_chrono_rift:send_error(ServerId, RoleId, ?ERRCODE(err204_err_castle_id))
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述   改变驻扎
%% @param    参数       ChangeCastleId:: 新据点  OldCastleId::旧据点
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
change_castle(ServerId, Role, 0, ChangeCastleId, MyScrambleValue, State) ->
    ZoneId = lib_clusters_center_api:get_zone(Role#castle_role_msg.server_id),
    #chrono_rift_state{castle_map = Map} = State,
    CastleList = maps:get(ZoneId, Map, []),
    OldCastleId = lib_kf_chrono_rift:get_default_castle_id(CastleList, Role#castle_role_msg.server_id),
    NewRole = Role#castle_role_msg{zone_id = ZoneId, castle_id = OldCastleId, is_occupy = ?is_occupy},
    change_castle(ServerId, NewRole, OldCastleId, ChangeCastleId, MyScrambleValue, State);

change_castle(ServerId, Role, OldCastleId, ChangeCastleId, MyScrambleValue, State) ->
    #chrono_rift_state{castle_map = Map} = State,
    #castle_role_msg{role_id = RoleId} = Role,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CastleList = maps:get(ZoneId, Map, []),
    case lists:keyfind(OldCastleId, #chrono_rift_castle.id, CastleList) of
        #chrono_rift_castle{role_list = RoleList} = OldCastle ->  %% err204_illegal_castle_id
            CanChange = is_can_change_castle(OldCastleId, ChangeCastleId, CastleList, ServerId),
            ?MYLOG("chrono", "change_castle CanChange  ~p~n", [CanChange]),
            if
                CanChange == true ->

                    %% 旧据点处理
                    case lists:keyfind(RoleId, #castle_role_msg.role_id, RoleList) of
                        #castle_role_msg{} = OldRole ->
                            NewRoleList = lists:keystore(RoleId, #castle_role_msg.role_id, RoleList, OldRole#castle_role_msg{is_occupy = ?not_occupy});
                        _ ->
                            NewRoleList = RoleList
                    end,
                    NewCastle = OldCastle#chrono_rift_castle{role_list = NewRoleList},
                    CastleList1 = lists:keystore(OldCastleId, #chrono_rift_castle.id, CastleList, NewCastle),
%%					?MYLOG("chrono", "change_castle CastleList1  ~p~n", [CastleList1]),
                    %% 新据点处理
                    case lists:keyfind(ChangeCastleId, #chrono_rift_castle.id, CastleList1) of
                        #chrono_rift_castle{role_list = RoleList1} = OldCastle2 ->
                            ?MYLOG("chrono", "change_castle ChangeCastleId  ~p~n", [ChangeCastleId]),
                            lib_chrono_rift_data:db_save_castle_roles(NewRoleList),
                            RoleList2 =
                                case lists:keyfind(RoleId, #castle_role_msg.role_id, RoleList1) of
                                    #castle_role_msg{} = TempRole ->
                                        lists:keystore(RoleId, #castle_role_msg.role_id, RoleList1,
                                            TempRole#castle_role_msg{castle_id = ChangeCastleId, zone_id = ZoneId, is_occupy = ?is_occupy});
                                    _ ->
                                        lists:keystore(RoleId, #castle_role_msg.role_id, RoleList1,
                                            Role#castle_role_msg{castle_id = ChangeCastleId, zone_id = ZoneId, is_occupy = ?is_occupy})
                                end,
                            lib_chrono_rift_data:db_save_castle_roles(RoleList2),
                            CastleList2 = lists:keystore(ChangeCastleId, #chrono_rift_castle.id, CastleList1,
                                OldCastle2#chrono_rift_castle{role_list = RoleList2}),
                            ?MYLOG("chrono", "change_castle CastleList2  ~p~n", [CastleList2]),
                            NewMap = maps:put(ZoneId, CastleList2, Map),
                            %%更新本地据点id
                            lib_kf_chrono_rift:update_local_role_castle_id(Role, ChangeCastleId),
                            NewState = State#chrono_rift_state{castle_map = NewMap},

                            %%推送 01
                            lib_kf_chrono_rift_mod:get_act_info(ServerId, RoleId, MyScrambleValue, NewState),
                            %%推送 03 协议
                            {ok, Bin} = pt_204:write(20403, [?SUCCESS]),
                            lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin),
                            %% 推送 10 协议
                            {ok, Bin2} = pt_204:write(20410, [ChangeCastleId]),
                            lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin2),
                            NewState;
                        _ ->  %%
                            {ok, Bin} = pt_204:write(20403, [?FAIL]),
                            lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin),
                            ?ERR("ChangeCastleId ~p~n", [ChangeCastleId]),
                            State
                    end;
                true ->
                    {ok, Bin} = pt_204:write(20403, [?ERRCODE(err204_illegal_castle_id)]),
                    lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin),
                    State
            end;
        _ -> %% 容错
            {ok, Bin} = pt_204:write(20403, [?FAIL]),
            lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin),
            ?ERR("OldCastleId ~p~n", [OldCastleId]),
            State
    end.



is_can_change_castle(OldCastleId, ChangeCastleId, CastleList, ServerId) ->
    ConnectIds = lib_kf_chrono_rift:get_connect_castle_ids(OldCastleId),
    ?MYLOG("chrono", "ConnectIds ~p~n", [ConnectIds]),
    ResIds = is_can_change_castle2(OldCastleId, ChangeCastleId, CastleList, ServerId, ConnectIds, [OldCastleId], ConnectIds),
    ?MYLOG("chrono", "ResIs ~p~n", [ResIds]),
    case lists:member(ChangeCastleId, ResIds) of
        true ->
            true;
        _ ->
            false
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数       HaveCalcIds::[Id]计算过的Id , 不能重复计算,
%%                     ResList::[Id] 结果id
%%                     NeedCalcIds::[Id]需要去计算的点
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
is_can_change_castle2(_OldCastleId, _ChangeCastleId, _CastleList, _ServerId, [], _HaveCalcIds, ResList) ->
    ResList;
is_can_change_castle2(OldCastleId, ChangeCastleId, CastleList, ServerId, [Id | NeedCalcIds], HaveCalcIds, ResList) ->
    case lists:member(Id, HaveCalcIds) of  %% 已经计算过了，不能再计算
        true ->
%%			?MYLOG("chrono", "HaveCalcIds ~p~n", [HaveCalcIds]),
            is_can_change_castle2(OldCastleId, ChangeCastleId, CastleList, ServerId, NeedCalcIds, HaveCalcIds, ResList);
        _ -> %%没有被计算过
            case lists:keyfind(Id, #chrono_rift_castle.id, CastleList) of
                #chrono_rift_castle{current_server_id = ServerId} ->  %%是归属，可达,则
                    ConnectIds = lib_kf_chrono_rift:get_connect_castle_ids(Id),  %% 这个据点连接的点，
                    NewNeedCalcIds = (ConnectIds -- HaveCalcIds) ++ NeedCalcIds,  %% 去掉已经计算过的点， 加入要计算的列表
                    NewResList = (ResList -- ConnectIds) ++ ConnectIds,   %% 去掉重复的点， 结果列表
%%					?MYLOG("chrono", "Id ~p, ConnectIds ~p  HaveCalcIds ~p   NeedCalcIds ~p  NewResList  ~p ~n",
%%						[Id, ConnectIds, HaveCalcIds, NeedCalcIds, NewResList]),
                    is_can_change_castle2(OldCastleId, ChangeCastleId, CastleList, ServerId, NewNeedCalcIds, [Id | lists:delete(Id, HaveCalcIds)], NewResList);
                _ -> %% 将id加入已经计算的列表
                    is_can_change_castle2(OldCastleId, ChangeCastleId, CastleList, ServerId, NeedCalcIds, [Id | lists:delete(Id, HaveCalcIds)], ResList)
            end
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  赛季结束   1 发送据点占领奖励 =>2 排行榜奖励 => 3清理据点数据 =>4清理目标数据设置排名5 =》通知每个服清理数据
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
act_end(State) ->
    %% 2通知排行榜
    mod_kf_chrono_rift_scramble_rank:act_end(),
    %% 任务进程数据清理
    mod_kf_chrono_rift_goal:act_end(),
    %%通知每个服清理数据
%%	mod_clusters_center:apply_to_all_node(lib_chrono_rift, act_end, []),
    #chrono_rift_state{castle_map = Map, zone_state = ZoneList} = State,
    List = maps:to_list(Map),
    %% 3清理据点数据
    Sql = io_lib:format(<<"TRUNCATE  chrono_rift_castle">>, []),
    Sql2 = io_lib:format(<<"TRUNCATE  chrono_rift_castle_role">>, []),
    db:execute(Sql),
    db:execute(Sql2),
%%	?MYLOG("cym", "ZoneList ~p~n", [ZoneList]),
    F = fun({ZoneId, CastleList}) ->
        case lib_kf_chrono_rift:is_act_open2(ZoneId, ZoneList) of
            true ->
                GoalRankList = lib_kf_chrono_rift:sort_server_by_castle_num(CastleList),
                LastGoalRankList = set_server_rank(GoalRankList), %% [{ServerId, Rank}]
                mod_kf_chrono_rift_goal:set_server_rank(ZoneId, LastGoalRankList),
                send_occupy_castle_reward(CastleList);
            _ ->
                skip
        end
        end,
    lists:foreach(F, List).


send_occupy_castle_reward(CastleList) ->
    ResList = send_occupy_castle_reward_help(CastleList, []),
    [mod_clusters_center:apply_cast(SerId, lib_chrono_rift, send_occupy_castle_reward, [Lv1N, Lv2N, Lv3N, Lv4N, L5N, Reward])
        || {SerId, Lv1N, Lv2N, Lv3N, Lv4N, L5N, Reward} <- ResList].


%%返回[{serverId, lv1数量, lv2数量，lv2数量， lv2数量， lv2数量， 奖励}]
send_occupy_castle_reward_help([], ResList) ->
    ResList;
send_occupy_castle_reward_help([H | T], ResList) ->
    #chrono_rift_castle{lv = Lv, current_server_id = SerId} = H,
    if
        SerId == 0 ->
            send_occupy_castle_reward_help(T, ResList);
        true ->
            Reward = data_chrono_rift:get_castle_reward(Lv),
            case lists:keyfind(SerId, 1, ResList) of
                {_, Lv1N, Lv2N, Lv3N, Lv4N, L5N, OldR} ->
                    NewItem =
                        case Lv of
                            1 ->
                                {SerId, Lv1N + 1, Lv2N, Lv3N, Lv4N, L5N, OldR ++ Reward};
                            2 ->
                                {SerId, Lv1N, Lv2N + 1, Lv3N, Lv4N, L5N, OldR ++ Reward};
                            3 ->
                                {SerId, Lv1N, Lv2N, Lv3N + 1, Lv4N, L5N, OldR ++ Reward};
                            4 ->
                                {SerId, Lv1N, Lv2N, Lv3N, Lv4N + 1, L5N, OldR ++ Reward};
                            5 ->
                                {SerId, Lv1N, Lv2N, Lv3N, Lv4N, L5N + 1, OldR ++ Reward}
                        end;
                _ ->
                    NewItem =
                        case Lv of
                            1 ->
                                {SerId, 1, 0, 0, 0, 0, Reward};
                            2 ->
                                {SerId, 0, 1, 0, 0, 0, Reward};
                            3 ->
                                {SerId, 0, 0, 1, 0, 0, Reward};
                            4 ->
                                {SerId, 0, 0, 0, 1, 0, Reward};
                            5 ->
                                {SerId, 0, 0, 0, 0, 1, Reward}
                        end
            end,
            NewResList = lists:keystore(SerId, 1, ResList, NewItem),
            send_occupy_castle_reward_help(T, NewResList)
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数       GoalRankList:: [{ServerId, ServerNum, ServerName, OccupyNum, ScrambleValue}]
%% @return   返回值     [{ServerId, Rank}]
%% @history  修改历史
%% -----------------------------------------------------------------
set_server_rank(GoalRankList) ->
    set_server_rank(GoalRankList, [], 0).



set_server_rank([], RankList, _PreRank) ->
    RankList;
set_server_rank([{ServerId, _ServerNum, _ServerName, _OccupyNum, _ScrambleValue} | T], RankList, PreRank) ->
    NewRankList = lists:keystore(ServerId, 1, RankList, {ServerId, PreRank + 1}),
    set_server_rank(T, NewRankList, PreRank + 1).



day_trigger(State) ->
    #chrono_rift_state{zone_state = ZoneList, castle_map = CastleMap} = State,
    F = fun(#zone_msg{status = Status, zone_id = ZoneId} = Zone, AccList) ->
        if
            Status == ?act_open ->
                [Zone | AccList];
            true ->
                Servers = mod_zone_mgr:get_zone_server(ZoneId),
                OpenDayLimit = ?CR_OPEN_DAY,
                F2 = fun(#zone_base{world_lv = Lv, time = OpenTime}, {FunLv, Num}) ->
                    OpenDay = util:get_open_day_in_center(OpenTime),
                    if
                        OpenDayLimit > OpenDay ->
                            {FunLv, Num};
                        true ->
                            {FunLv + Lv, Num + 1}
                    end
                     end,
                {AllLv, Num} = lists:foldl(F2, {0, 0}, Servers),
                AvgLv = ?IF(Num =/= 0, round(AllLv / Num), 0),
                NeedLv = ?CR_WORLD_LV,
                NewStatus = ?IF(AvgLv >= NeedLv, ?act_open, ?act_close),
                [Zone#zone_msg{status = NewStatus} | AccList]
        end
        end,
    NewZoneList = lists:foldl(F, [], ZoneList),
    lib_kf_chrono_rift:save_open_zone_list(NewZoneList),
    NewMap = day_trigger_help(CastleMap),
%%    ?MYLOG("chrono", "NewMap ~p~n", [NewMap]),
    State#chrono_rift_state{zone_state = NewZoneList, castle_map = NewMap}.

day_trigger_help(CastleMap) ->
    F = fun({ZoneId, CastleList}, AccList) ->
        AllServerList = mod_zone_mgr:get_zone_server(ZoneId),
        F = fun(#zone_base{server_id = ServerId, server_num = ServerNum, server_name = ServerName}, ResCastleList) ->
            case lists:keyfind(ServerId, #chrono_rift_castle.base_server_id, ResCastleList) of
                #chrono_rift_castle{} ->
                    ResCastleList;
                _ ->
                    alloc_server_base_castle(ServerId, ServerNum, ServerName, ResCastleList)
            end
            end,
        NewCastleList = lists:foldl(F, CastleList, AllServerList),
        [{ZoneId, NewCastleList} | AccList]
        end,
    List1 = maps:to_list(CastleMap),
    List2 = lists:foldl(F, [], List1),
    maps:from_list(List2).

alloc_server_base_castle(ServerId, ServerNum, ServerName, CastleList) ->
    F = fun(Id, ResCastleList) ->
        case lists:keyfind(Id, #chrono_rift_castle.id, ResCastleList) of
            #chrono_rift_castle{base_server_id = BaseId} = Castle when BaseId == 0 ->
                ZoneId = lib_clusters_center_api:get_zone(ServerId),
                NewCastle = Castle#chrono_rift_castle{base_server_id = ServerId, zone_id = ZoneId,
                    current_server_num = ServerNum, current_server_name = ServerName, current_server_id = ServerId, occupy_count = 1},
                lib_kf_chrono_rift:save_to_db_castle(NewCastle),
                lists:keystore(Id, #chrono_rift_castle.id, ResCastleList, NewCastle);
            _ ->
                ResCastleList
        end
        end,
    lists:foldl(F, CastleList, ?base_castle_id).


%% -----------------------------------------------------------------
%% @desc     功能描述   改变分区
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
zone_change(State, ServerId, OldZone, NewZone) ->
    %% 任务进程的
    mod_kf_chrono_rift_goal:re_start(),
    %% 排行榜
    mod_kf_chrono_rift_scramble_rank:re_start(),
    #chrono_rift_state{castle_map = CastleMap} = State,
    %% 直接修改数据库的zoneId
    Sql = io_lib:format(<<"update  chrono_rift_castle_role set  zone_id = ~p where  server_id = ~p">>, [NewZone, ServerId]),
    db:execute(Sql),
    CastleList = maps:get(OldZone, CastleMap, []),
    F = fun(#chrono_rift_castle{current_server_id = CastleServerIdId, timer_ref = Ref, scramble_value = ValueList, id = CastleId} = Castle, AccList) ->
        if
            CastleServerIdId == ServerId ->
                util:cancel_timer(Ref),
                NewCastle = Castle#chrono_rift_castle{current_server_id = 0, current_server_num = 0, current_server_name = "",
                    time = 0};
            true ->
                NewCastle = Castle
        end,
        NewValueList = lists:keydelete(ServerId, #castle_server_msg.server_id, ValueList),
        NewCastle1 = NewCastle#chrono_rift_castle{scramble_value = NewValueList},
        lib_chrono_rift_data:db_save_castle(NewCastle1),
        UpdateList =
            case lists:keyfind(ServerId, #castle_server_msg.server_id, ValueList) of
                #castle_server_msg{} = CastleServerMsg ->
                    [{CastleId, CastleServerMsg}];
                _ ->
                    []
            end,
        AccList ++ UpdateList
        end,
    ResList = lists:foldl(F, [], CastleList),
    zone_change_help(ResList, NewZone, CastleMap),


    %% ----
    ZoneIds = mod_zone_mgr:get_all_zone_ids(),
    CastleIdList = data_chrono_rift:get_castle_ids(),
    F2 = fun(ZoneId, AccMap) ->
        CastleList1 = init_castle_list(CastleIdList, ZoneId),
        %% 分配出生据点
        %% 不管是否开启都会分配基地，状态只是控制能不能添加注入值之类的
        NewCastleList = lib_kf_chrono_rift:alloc_base_castle(ZoneId, CastleList1),
        NewAccMap = maps:put(ZoneId, NewCastleList, AccMap),
        NewAccMap
        end,
    %% 初始化，所有的据点
    CastleListMap = lists:foldl(F2, #{}, ZoneIds),
    ZoneState = lib_kf_chrono_rift:get_init_zone_state(ZoneIds),
    ?PRINT("++++++++++++++~n", []),
    State#chrono_rift_state{castle_map = CastleListMap, zone_state = ZoneState}.



zone_change_help(ResList, NewZone, CastleMap) ->
    CastleList = maps:get(NewZone, CastleMap, []),
    [begin
         case lists:keyfind(CastleId, #chrono_rift_castle.id, CastleList) of
             #chrono_rift_castle{scramble_value = ServerMsgList} = OldCastle ->
                 NewServerMsgList = lists:keystore(ServerMsg#castle_server_msg.server_id, #castle_server_msg.server_id, ServerMsgList, ServerMsg),
                 NewCastle = OldCastle#chrono_rift_castle{scramble_value = NewServerMsgList},
                 lib_chrono_rift_data:db_save_castle(NewCastle);
             _ ->
                 skip
         end
     end || {CastleId, ServerMsg} <- ResList].




handle_new_merge_server_ids(State, ServerId, ServerNum, ServerName, _WorldLv, _Time, NewMergeSerIds) ->
    #chrono_rift_state{castle_map = CastleMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    CastleList = maps:get(ZoneId, CastleMap, []),
    F = fun(Castle, ResCastleList) ->
        #chrono_rift_castle{current_server_id = CurrSerId, scramble_value = ServerList} = Castle,
        NewServerList = handle_new_merge_server_ids_help(ServerList, NewMergeSerIds, ServerId, ServerNum, ServerName),
        case lists:member(CurrSerId, NewMergeSerIds) of
            true ->
                NewCastle = Castle#chrono_rift_castle{current_server_id = ServerId,
                    current_server_num = ServerNum, current_server_name = ServerName, scramble_value = NewServerList};
            _ ->
                NewCastle = Castle#chrono_rift_castle{scramble_value = NewServerList}
        end,
        lib_chrono_rift_data:db_save_castle(NewCastle),
        [NewCastle | ResCastleList]
        end,
    NewCastleList = lists:foldl(F, [], CastleList),
    _NewMap = maps:put(ZoneId, NewCastleList, CastleMap),
    mod_kf_chrono_rift_scramble_rank:re_start(),
    init(State).

%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数     MainServerId  主服    MergeSerIds新的合服id
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle_new_merge_server_ids_help(ServerList, MergeSerIds, MainServerId, MainServerNum, MainServerName) ->
    F = fun(Server, {AccValue, AccList}) ->
        #castle_server_msg{server_id = ServerId, value = V} = Server,
        case lists:member(ServerId, MergeSerIds) of
            true -> %% 是合服的数据，删除，且将争夺值留下
                {AccValue + V, AccList};
            _ ->  %%不是合服的数据，不用管
                {AccValue, [Server | AccList]}
        end
        end,
    {AllValue, NewServerList} = lists:foldl(F, {0, []}, ServerList),
    case lists:keyfind(MainServerId, #castle_server_msg.server_id, NewServerList) of
        #castle_server_msg{value = MainValue} = MainServer ->
            NewMainServer = MainServer#castle_server_msg{value = AllValue + MainValue},
            lists:keystore(MainServerId, #castle_server_msg.server_id, NewServerList, NewMainServer);
        _ ->  %% 主服在这个服没有数据
            if
                AllValue =< 0 -> %% 如果是0 就没什么必要添加了
                    NewServerList;
                true ->
                    NewMainServer = #castle_server_msg{server_id = MainServerId, server_num = MainServerNum, server_name = MainServerName, value = AllValue},
                    lists:keystore(MainServerId, #castle_server_msg.server_id, NewServerList, NewMainServer)
            end
    end.





repair_server_msg(_ScrambelValueList, RoleList, MergerMap) ->
    F = fun(#castle_role_msg{server_id = ServerId, scramble_value = V, server_num = ServerNum, server_name = ServerName}, AccList) ->
        %%从服的数据填加到主服
        {MainServerId, MainServrNum, MainServerName} = maps:get(ServerId, MergerMap, {ServerId, ServerNum, ServerName}),

        case lists:keyfind(MainServerId, #castle_server_msg.server_id, AccList) of
            #castle_server_msg{value = AllV} = Old ->
                lists:keystore(MainServerId, #castle_server_msg.server_id, AccList, Old#castle_server_msg{value = AllV + V});
            _ ->
                lists:keystore(MainServerId, #castle_server_msg.server_id, AccList,
                    #castle_server_msg{value = V, server_id = MainServerId, server_num = MainServrNum, server_name = MainServerName})
        end
        end,
    NewRes = lists:foldl(F, [], RoleList),
    lib_kf_chrono_rift:sort_castle_server_list(NewRes).


%% 返回从服  =》 主服{ServerId, ServerNum, ServerName}  map
init_castle_list_help(AllZone) ->
    init_castle_list_help(AllZone, #{}).


init_castle_list_help([], Map) ->
    Map;
init_castle_list_help([#zone_base{server_id = ServerId, merge_ids = MergeSerIds, server_num = ServerNum, server_name = ServerName} | List], Map) ->
    F = fun(TempId, AccMap) ->
        maps:put(TempId, {ServerId, ServerNum, ServerName}, AccMap)
        end,
    NewMap = lists:foldl(F, Map, MergeSerIds),
    init_castle_list_help(List, NewMap).




change_castle_force(ServerId, Role, 0, ChangeCastleId, State) ->
	%% 新据点处理
	#chrono_rift_state{castle_map = Map} = State,
	#castle_role_msg{role_id = RoleId} = Role,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	CastleList1 = maps:get(ZoneId, Map, []),
	case lists:keyfind(ChangeCastleId, #chrono_rift_castle.id, CastleList1) of
		#chrono_rift_castle{role_list = RoleList1} = OldCastle2 ->
			?MYLOG("chrono", "change_castle ChangeCastleId  ~p~n", [ChangeCastleId]),
			RoleList2 =
				case lists:keyfind(RoleId, #castle_role_msg.role_id, RoleList1) of
					#castle_role_msg{} = TempRole ->
						lists:keystore(RoleId, #castle_role_msg.role_id, RoleList1,
							TempRole#castle_role_msg{castle_id = ChangeCastleId, zone_id = ZoneId, is_occupy = ?is_occupy});
					_ ->
						lists:keystore(RoleId, #castle_role_msg.role_id, RoleList1,
							Role#castle_role_msg{castle_id = ChangeCastleId, zone_id = ZoneId, is_occupy = ?is_occupy})
				end,
            lib_chrono_rift_data:db_save_castle_roles(RoleList2),
			CastleList2 = lists:keystore(ChangeCastleId, #chrono_rift_castle.id, CastleList1,
				OldCastle2#chrono_rift_castle{role_list = RoleList2}),
			?MYLOG("chrono", "change_castle CastleList2  ~p~n", [CastleList2]),
			NewMap = maps:put(ZoneId, CastleList2, Map),
			%%更新本地据点id
			lib_kf_chrono_rift:update_local_role_castle_id(Role, ChangeCastleId),
			NewState = State#chrono_rift_state{castle_map = NewMap},

%%%%			%%推送 01
%%%%			lib_kf_chrono_rift_mod:get_act_info(ServerId, RoleId, MyScrambleValue, NewState),
%%			%%推送 03 协议
%%			{ok, Bin} = pt_204:write(20403, [?SUCCESS]),
%%			lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin),
%%			%% 推送 10 协议
%%			{ok, Bin2} = pt_204:write(20410, [ChangeCastleId]),
%%			lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin2),
			NewState;
		_ ->  %%
			{ok, Bin} = pt_204:write(20403, [?FAIL]),
			lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin),
			?ERR("ChangeCastleId ~p~n", [ChangeCastleId]),
			State
	end;

change_castle_force(ServerId, Role, OldCastleId, ChangeCastleId, State) ->
	#chrono_rift_state{castle_map = Map} = State,
	#castle_role_msg{role_id = RoleId} = Role,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	CastleList = maps:get(ZoneId, Map, []),
	case lists:keyfind(OldCastleId, #chrono_rift_castle.id, CastleList) of
		#chrono_rift_castle{role_list = RoleList} = OldCastle ->  %% err204_illegal_castle_id
			%% 旧据点处理
			case lists:keyfind(RoleId, #castle_role_msg.role_id, RoleList) of
				#castle_role_msg{} = OldRole ->
					NewRoleList = lists:keystore(RoleId, #castle_role_msg.role_id, RoleList, OldRole#castle_role_msg{is_occupy = ?not_occupy});
				_ ->
					NewRoleList = RoleList
			end,
			NewCastle = OldCastle#chrono_rift_castle{role_list = NewRoleList},
			CastleList1 = lists:keystore(OldCastleId, #chrono_rift_castle.id, CastleList, NewCastle),
			%% 新据点处理
			case lists:keyfind(ChangeCastleId, #chrono_rift_castle.id, CastleList1) of
				#chrono_rift_castle{role_list = RoleList1} = OldCastle2 ->
					?MYLOG("chrono", "change_castle ChangeCastleId  ~p~n", [ChangeCastleId]),
                    lib_chrono_rift_data:db_save_castle_roles(NewRoleList),
					RoleList2 =
						case lists:keyfind(RoleId, #castle_role_msg.role_id, RoleList1) of
							#castle_role_msg{} = TempRole ->
								lists:keystore(RoleId, #castle_role_msg.role_id, RoleList1,
									TempRole#castle_role_msg{castle_id = ChangeCastleId, zone_id = ZoneId, is_occupy = ?is_occupy});
							_ ->
								lists:keystore(RoleId, #castle_role_msg.role_id, RoleList1,
									Role#castle_role_msg{castle_id = ChangeCastleId, zone_id = ZoneId, is_occupy = ?is_occupy})
						end,
                    lib_chrono_rift_data:db_save_castle_roles(RoleList2),
					CastleList2 = lists:keystore(ChangeCastleId, #chrono_rift_castle.id, CastleList1,
						OldCastle2#chrono_rift_castle{role_list = RoleList2}),
%%					?MYLOG("chrono", "change_castle CastleList2  ~p~n", [CastleList2]),
					NewMap = maps:put(ZoneId, CastleList2, Map),
					%%更新本地据点id
					lib_kf_chrono_rift:update_local_role_castle_id(Role, ChangeCastleId),
					NewState = State#chrono_rift_state{castle_map = NewMap},
%%					%%推送 01
%%					lib_kf_chrono_rift_mod:get_act_info(ServerId, RoleId, MyScrambleValue, NewState),
%%					%%推送 03 协议
%%					{ok, Bin} = pt_204:write(20403, [?SUCCESS]),
%%					lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin),
%%					%% 推送 10 协议
%%					{ok, Bin2} = pt_204:write(20410, [ChangeCastleId]),
%%					lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin2),
					NewState;
				_ ->  %%
					{ok, Bin} = pt_204:write(20403, [?FAIL]),
					lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin),
					?ERR("ChangeCastleId ~p~n", [ChangeCastleId]),
					State
			end;
		_ -> %% 容错
			{ok, Bin} = pt_204:write(20403, [?FAIL]),
			lib_kf_chrono_rift:send_to_uid(ServerId, RoleId, Bin),
			?ERR("OldCastleId ~p~n", [OldCastleId]),
			State
	end.

%% 重新计算所有区域状态(秘籍用)
recalc_zone_state(State) ->
    ZoneIds = mod_zone_mgr:get_all_zone_ids(),
    ZoneState = lib_kf_chrono_rift:recalc_zone_state(ZoneIds),
    State#chrono_rift_state{zone_state = ZoneState}.