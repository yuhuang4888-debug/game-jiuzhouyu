%% ---------------------------------------------------------------------------
%% @doc mod_zone_mgr
%% @author ming_up@foxmail.com
%% @since  2018-12-19
%% @deprecated 集群-游戏分区管理器
%% ---------------------------------------------------------------------------

%% 1: 每天凌晨按规则把新服划入分区 midnight_recalc/0
%% 2: 每月固定日子可以根据规则重新划分分区 recalc_all/0
%% 3: 可以根据lib_clusters_center_api:get_zone/2 获取分区id
%% 4: 数据库里面不应该保存分区id，应该在初始化的时候获取

%% 注意：不要拿玩家Id算出来ServerId来取分区

-module(mod_zone_mgr).

-include("server.hrl").
-include("common.hrl").
-include("clusters.hrl").
-include("chat.hrl").

-behavior(gen_server).

-export([
    start_link/0, stop/0, cast_center/1, add_zone/8, update_server/2, midnight_recalc/0, recalc_all/0, reload/0,
    apply_cast_to_zone/5, apply_cast_to_zone2/5,
    chat_by_server_id/2, chat_by_zone_id/2, refresh_combat_power/3,
    sync_to_center_combat_power/1, sanctuary_kf_init/0, treasure_hunt_init/0, kf_sanctum_init/0, kf_terri_war_init/0,
    activation_draw_init/0, get_all_zone/0, get_zone_server/1,  get_server_name_list/0, get_all_zone_ids/0
    , kf_escort_init/0, seacraft_init/1, common_get_info/3, server_name_change/2, server_name_change/1,
    calc_zone_mod/0, sync_mod_wordlv/0, rush_treasure_no_zone_tv/1
]).

-export([
    init/1,
    handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3
]).

-export([gm_zone_change/3, gm_recalc_all_specific/2]).


-define(ZONES, [?ZONE_TYPE_1]).   %% 分区类型id

-ifdef(DEV_SERVER).
-define(RECALC_IMMEDIATELY, true).
-else.
-define(RECALC_IMMEDIATELY, false).
-endif.

-record(state, {
    zones_map = #{}     %% 分区信息 #{ZoneTypeId => #zone_data{},...}
    , ref = undefined   %% 定时器
}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:cast(?MODULE, stop).

%% 新连接的游戏申请区域
add_zone(ServerId, OpTime, MergeSerIds, ServerNum, ServerName, WorldLv, ServerCombatPower, ActiveType) ->
    cast_mgr({add_zone, ServerId, OpTime, MergeSerIds, ServerNum, ServerName, WorldLv, ServerCombatPower, ActiveType}).

%% 更新服的参数
update_server(ServerId, KvList) ->
    cast_mgr({update_server, ServerId, KvList}).

%% 小跨服聊天
chat_by_server_id(ServerId, Bin) ->
    ZoneType = ?ZONE_TYPE_1,
    ZoneId = lib_clusters_center_api:get_zone(ZoneType, ServerId),
    cast_mgr({'chat', ZoneType, ZoneId, Bin}).
chat_by_zone_id(ZoneId, Bin) ->
    ZoneType = ?ZONE_TYPE_1,
    cast_mgr({'chat', ZoneType, ZoneId, Bin}).

%% 刷新每个服的战力
refresh_combat_power(ZoneType, ServerId, CombatPower) ->
    cast_mgr({'refresh_combat_power', ZoneType, ServerId, CombatPower}).

%% 夺宝传闻的发送(全区域)
rush_treasure_no_zone_tv(TvArgs) ->
    cast_mgr({'rush_treasure_no_zone_tv', TvArgs}).

%% 每天凌晨游戏服同步战力到跨服
sync_to_center_combat_power(_) ->
    ServerId = config:get_server_id(),
    Power = lib_common_rank_api:server_combat_power_10(),
    mod_clusters_node:apply_cast(?MODULE, refresh_combat_power, [1, ServerId, Power]),
    ok.

get_all_zone() ->
    gen_server:call(?MODULE, {get_all_zone}).

get_all_zone_ids() ->
    gen_server:call(?MODULE, {get_all_zone_ids}).



get_zone_server(ZoneId) ->
    gen_server:call(?MODULE, {get_zone_server, ZoneId}).

get_server_name_list() ->
    gen_server:call(?MODULE, {get_server_name_list}).

%% 跨服圣域初始化
sanctuary_kf_init() ->
    cast_mgr(sanctuary_kf_init).

%% 寻宝初始化
treasure_hunt_init() ->
    cast_mgr(treasure_hunt_init).

%% 永恒圣殿初始化
kf_sanctum_init() ->
    cast_mgr(kf_sanctum_init).

kf_terri_war_init() ->
    cast_mgr(kf_terri_war_init).

%% 矿石护送
kf_escort_init() ->
    cast_mgr(kf_escort_init).

activation_draw_init() ->
    cast_mgr(activation_draw_init).

seacraft_init(Type) ->
    cast_mgr({seacraft_init, Type}).

server_name_change(ServerId, ServerName) ->
    mod_clusters_node:apply_cast(?MODULE, server_name_change, [{server_name_change, ServerId, ServerName}]).

server_name_change(Msg) ->
    cast_mgr(Msg).

common_get_info(M, F, A) ->
    cast_mgr({common_get_info, M, F, A}).

%% 午夜重新为新服划分分区
midnight_recalc() -> cast_mgr(midnight_recalc).

calc_zone_mod() -> cast_mgr(calc_zone_mod).

sync_mod_wordlv() -> cast_mgr(sync_mod_wordlv).

%% 全服区域重置
recalc_all() -> cast_mgr(recalc_all).

%% 重新加载数据
reload() -> cast_mgr(reload).

%% 秘籍修改某个服的分区
%% 注：当前指定服务器修改分区不会用这个秘籍，统一用 lib_php_api:recalc_zones/0
%%     无特殊情况暂时不使用，如后续要用此秘籍，需要对各个功能进行单服务器分区修改进行处理
gm_zone_change(ZoneType, ServerId, NewZone) ->
    cast_mgr({gm_zone_change, ZoneType, ServerId, NewZone}),
    "Use lib_php_api:recalc_zones/0!".

%% SpecificStr: "[{区域id,服务器id列表}]"
gm_recalc_all_specific(ZoneType, SpecificStr) ->
    SpecificList = lists:keysort(1, util:string_to_term(SpecificStr)),
    {ZoneIdList, _ServerIdList} = lists:unzip(SpecificList),
    ServerIdList = lists:flatten(_ServerIdList),
    F = fun(Id, Acc) ->
        case lists:member(Id, Acc) of true -> Acc; _ -> [Id|Acc] end
    end,
    ZoneIdSame = length(lists:foldl(F, [], ZoneIdList)) =/= length(ZoneIdList),
    ServerIdSame = length(lists:foldl(F, [], ServerIdList)) =/= length(ServerIdList),
    MoreThan8 = lists:foldl(fun({_, SerList}, Acc) ->
        case length(SerList) > 8 orelse SerList == [] of true -> [1|Acc]; _ -> Acc end
    end, [], SpecificList) =/= [],
    if
        SpecificList == [] -> zone_empty;
        ZoneIdSame   -> zone_id_same;
        ServerIdSame -> server_id_same;
        MoreThan8 -> more_than_8_or_empty;
        true ->
            gen_server:call(?MODULE, {gm_recalc_all_specific, ZoneType, SpecificList, ZoneIdList, ServerIdList})
    end.


%% 本地 -> 跨服中心 Msg = [{start, args}]
cast_center(Msg) ->
    mod_clusters_node:apply_cast(?MODULE, cast_mgr, Msg).

cast_mgr(Msg) ->
    gen_server:cast(?MODULE, Msg).

%% 对应区执行信息
apply_cast_to_zone(ZoneType, ZoneId, M, F, A) ->
    gen_server:cast(?MODULE, {'apply_cast_to_zone', ZoneType, ZoneId, M, F, A}).

%% 对应区执行信息(检查server_id是否连接)
apply_cast_to_zone2(ZoneType, ZoneId, M, F, A) ->
    gen_server:cast(?MODULE, {'apply_cast_to_zone2', ZoneType, ZoneId, M, F, A}).


init([]) ->
    process_flag(trap_exit, true),
    %% 区域路由表
    [ets:new(lib_zone:ets_name(ZoneTypeId), [named_table, protected, set, {keypos, #clusters_zone.server_id}]) || ZoneTypeId <- ?ZONES],
    [ets:new(lib_zone:ets_main_zone_name(ZoneTypeId), [named_table, protected, set, {keypos, #ets_main_zone.zone_id}]) || ZoneTypeId <- ?ZONES],
    %% 加载已经已有的分区数据
    State = load_all_zones(),
    lib_zone:save_ets_main_zone(State#state.zones_map),
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Res, NewState} ->
            {reply, Res, NewState};
        Res ->
            ?ERR("call_error:~p~n", [Res]),
            {reply, ok, State}
    end.

handle_cast(Msg, State)->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("cast_error:~p~n", [Res]),
            {noreply, State}
    end.

handle_info(Info, State)->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("info_error:~p~n", [Res]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ================================= private fun =================================
do_handle_call({get_all_zone}, _From, State) ->
    #state{zones_map=ZonesMap} = State,
    #zone_data{zones=AllZones, z2s_map=_Z2SMap} = maps:get(?ZONE_TYPE_1, ZonesMap),
    {reply, AllZones, State};

do_handle_call({get_all_zone_ids}, _From, State) ->
    #state{zones_map = ZonesMap} = State,
    #zone_data{z2s_map = Z2SMap} = maps:get(?ZONE_TYPE_1, ZonesMap),
    {reply, maps:keys(Z2SMap), State};

do_handle_call({get_zone_server, ZoneId}, _From, State) ->
    #state{zones_map=ZonesMap} = State,
    #zone_data{zones=AllZones} = maps:get(?ZONE_TYPE_1, ZonesMap),
    Reply = [ZoneBase ||#zone_base{zone = ZoneId1}=ZoneBase <- AllZones, ZoneId1 == ZoneId],
    {reply, Reply, State};

%% 获取所有服列表
%% 临时处理问题，不用使用这个，自己功能内部添加
do_handle_call({get_server_name_list}, _From, State) ->
    #state{zones_map=ZonesMap} = State,
    #zone_data{zones=AllZones} = maps:get(?ZONE_TYPE_1, ZonesMap),
    ServerNameList = [{ServerId, ServerName}||#zone_base{server_id=ServerId, server_name=ServerName}<-AllZones],
    {reply, ServerNameList, State};

do_handle_call({gm_recalc_all_specific, ZoneType, SpecificList, _ZoneIdList, ServerIdList}, _From, State) ->
    #state{zones_map=ZonesMap} = State,
    case maps:get(ZoneType, ZonesMap, none) of
        none ->
            NewState = State, Reply = zone_type_null;
        #zone_data{zones=AllZones} = ZoneData ->
            %% 服务器id是否一致
            case lists:sort([TmpSerId ||#zone_base{server_id = TmpSerId, zone = TmpZId} <- AllZones, TmpZId > 0]) == lists:sort(ServerIdList) of
                false ->
                    NewState = State, Reply = server_id_not_match;
                _ ->
                    %?PRINT("recalc_all_specific old:~p~n", [ZoneData]),
                    lib_clusters_center_api:start_recalc_all_zone(),
                    NewZoneData = recalc_all_zone_specific(ZoneData, ZoneType, SpecificList),
                    %?PRINT("recalc_all_specific:~p~n", [NewZoneData]),
                    lib_clusters_center_api:end_recalc_all_zone(),
                    NewZoneMap = maps:put(ZoneType, NewZoneData, ZonesMap),
                    mod_zone_mod:gm_recalc_all_specific(NewZoneMap),
                    NewState = State#state{zones_map = NewZoneMap},
                    Reply = ok
            end
    end,
    {reply, Reply, NewState};

do_handle_call(Req, _From, State) ->
    ?ERR("unknow req:~p~n", [Req]),
    {reply, ok, State}.

%% 链接跨服中心成功,申请分区
do_handle_cast({add_zone, ServerId, Time, MergeSerIds, ServerNum, ServerName, WorldLv, CombatPower, ActiveType}, State)->
    #state{zones_map=ZonesMap} = State,
    F = fun(ZoneTypeId, ZoneData) ->
        add_zone(ServerId, Time, MergeSerIds, ServerNum, ServerName, WorldLv, CombatPower, ActiveType, ZoneTypeId, ZoneData)
    end,
    NewZonesMap = maps:map(F, ZonesMap),
    {noreply, State#state{zones_map=NewZonesMap}};

%% 更新服参数
do_handle_cast({update_server, ServerId, KvList}, State)->
    #state{zones_map=ZonesMap} = State,
    F = fun(ZoneTypeId, ZoneData) ->
        update_server(ServerId, KvList, ZoneTypeId, ZoneData)
    end,
    NewZonesMap = maps:map(F, ZonesMap),
    %% 如果更新世界等级则计算跨服市场的
    case lists:keyfind(world_lv, 1, KvList) of
        {_, _} ->
            spawn(fun() -> lib_sell_mod_kf:calc_world_lv()
                  end);
        _ ->
            skip
    end,
    {noreply, State#state{zones_map=NewZonesMap}};

%% 通用回调
do_handle_cast({mod, Module, Method, Args}, State)->
    NState = Module:Method(Args,State),
    {noreply, NState};

%% 发送分区执行
do_handle_cast({'apply_cast_to_zone', ZoneType, ZoneId, M, F, A}, State)->
    #state{zones_map=ZonesMap} = State,
    case maps:find(ZoneType, ZonesMap) of
        {ok, ZoneData} ->
            [mod_clusters_center:apply_cast(X#zone_base.server_id, M, F, A) || X <- ZoneData#zone_data.zones, X#zone_base.zone == ZoneId];
        _ -> skip
    end,
    {noreply, State};

%% 发送分区执行(检查是否存在)
do_handle_cast({'apply_cast_to_zone2', ZoneType, ZoneId, M, F, A}, State)->
    #state{zones_map=ZonesMap} = State,
    case maps:find(ZoneType, ZonesMap) of
        {ok, ZoneData} ->
            [
            begin
                case lib_clusters_center:get_node(X#zone_base.server_id) of
                    undefined -> skip;
                    _ -> mod_clusters_center:apply_cast(X#zone_base.server_id, M, F, A)
                end
            end|| X <- ZoneData#zone_data.zones, X#zone_base.zone == ZoneId];
        _ -> skip
    end,
    {noreply, State};

%% 小跨服聊天
do_handle_cast({'chat', ZoneType, ZoneId, BinData}, State) ->
    #state{zones_map=ZonesMap} = State,
    case maps:find(ZoneType, ZonesMap) of
        {ok, #zone_data{z2s_map=Z2SMap}} ->
            case maps:find(ZoneId, Z2SMap) of
                {ok, Servers} ->
                    [
                        mod_clusters_center:apply_cast(EServerId, lib_server_send, send_to_all, [BinData])
                    || EServerId <- Servers], skip;
                _ -> skip
            end;
        _ -> skip
    end,
    {noreply, State};

do_handle_cast({server_name_change, ServerId, ServerName}, State) ->
    #state{zones_map=ZonesMap} = State,
    ZoneData = maps:get(?ZONE_TYPE_1, ZonesMap),
    #zone_data{zones=AllZones} = ZoneData,
    case lists:keyfind(ServerId, #zone_base.server_id, AllZones) of
        #zone_base{zone = ZoneId} = ZoneBase ->
            NewZoneBase = ZoneBase#zone_base{server_name = ServerName},
            ZoneId =/= 0 andalso lib_zone:save_zone(?ZONE_TYPE_1, NewZoneBase), %%新服不保存数据库
            NewAllZones = lists:keystore(ServerId, #zone_base.server_id, AllZones, NewZoneBase);
        _ ->
            NewAllZones = AllZones
    end,
    %mod_c_sanctuary:server_info_chage(ServerId, [{server_name, ServerName}]),
    mod_sanctuary_cluster_mgr:server_info_change(ServerId, [{server_name, ServerName}]),
    mod_kf_draw_record:cast_mgr({'server_name_change', ServerId, ServerName}),
    mod_rush_treasure_kf:server_info_change(ServerId, ServerName),
    NewZonesMap = maps:put(?ZONE_TYPE_1, ZoneData#zone_data{zones=NewAllZones}, ZonesMap),
    {noreply, State#state{zones_map=NewZonesMap}};

%% 刷新服战力
do_handle_cast({refresh_combat_power, ZoneType, ServerId, CombatPower}, State) ->
    #state{zones_map=ZonesMap} = State,
    State1 = case maps:find(ZoneType, ZonesMap) of
        {ok, #zone_data{zones=Zones}=ZoneData} ->
            case lists:keyfind(ServerId, #zone_base.server_id, Zones) of
                #zone_base{} = ZoneBase ->
                    NewZoneBase = ZoneBase#zone_base{combat_power=CombatPower},
                    lib_zone:save_zone(ZoneType, NewZoneBase),
                    NewZones = lists:keyreplace(ServerId, #zone_base.server_id, Zones, NewZoneBase),
                    NewState = State#state{zones_map=ZonesMap#{ZoneType := ZoneData#zone_data{zones=NewZones}}},
                    NewState;
                _ ->
                    State
            end;
        _ -> State
    end,
    {noreply, State1};


% %% 是否开启小跨服聊天
% do_handle_cast({send_zone_chat_info, ServerId, RoleId}, State) ->
%     ZoneId = lib_clusters_center_api:get_zone(ServerId),
%     Zones = [X||X <- State#zone_mgr.zones, X#zone_base.zone == ZoneId, util:check_open_day_2(?CHAT_OPEN_DAY_ZONE, X#zone_base.time)],
%     case length(Zones) >= ?CHAT_ZONE_SEVER_NUM of
%         true -> IsOpen = 1;
%         false -> IsOpen = 0
%     end,
%     {ok, BinData} = pt_110:write(11023, [IsOpen]),
%     mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
%     {noreply, State};

% %% 是否开启小跨服聊天[区域广播]
% do_handle_cast({send_zone_chat_info, ZoneId}, State) ->
%     Zones = [X||X <- State#zone_mgr.zones, X#zone_base.zone == ZoneId, util:check_open_day_2(?CHAT_OPEN_DAY_ZONE, X#zone_base.time)],
%     case length(Zones) >= ?CHAT_ZONE_SEVER_NUM of
%         true -> IsOpen = 1;
%         false -> IsOpen = 0
%     end,
%     {ok, BinData} = pt_110:write(11023, [IsOpen]),
%     {noreply, NewState} = do_handle_cast({zone_chat2, ZoneId, BinData}, State),
%     {noreply, NewState};

%% 测试区域发生变化
do_handle_cast({gm_zone_change, ZoneType, ServerId, NewZone}, State) ->
    #state{zones_map=ZonesMap} = State,
    NewZonesMap = case maps:find(ZoneType, ZonesMap) of
        {ok, #zone_data{zones=Zones} = ZonData} ->
            case lists:keyfind(ServerId, #zone_base.server_id, Zones) of
                #zone_base{zone=NewZone} -> ZonesMap;
                #zone_base{zone=OldZone, merge_ids=MergeSerIds} = ZB ->
                    ets:update_element(lib_zone:ets_name(ZoneType), ServerId, {#clusters_zone.zone, NewZone}),
                    NewZB = ZB#zone_base{zone=NewZone},
                    lib_zone:save_merge_ets_zones(ZoneType, [NewZB]),
                    lib_clusters_center_api:zone_change(ZoneType, ServerId, OldZone, NewZone),
                    [lib_clusters_center_api:zone_change(ZoneType, MergeSrvId, OldZone, NewZone)||MergeSrvId<-MergeSerIds],
                    NewZones = lists:keyreplace(ServerId, #zone_base.server_id, Zones, NewZB),
                    Z2SMap = save_z2s_map(NewZones, #{}),
                    lib_zone:save_zone(ZoneType, NewZB),
                    lib_zone:save_ets_main_zone(ZoneType, NewZones, Z2SMap),
                    NZoneMap = ZonesMap#{ZoneType:=ZonData#zone_data{zones=NewZones, z2s_map=Z2SMap}},
                    mod_zone_mod:gm_zone_change(NZoneMap, ServerId, OldZone, NewZone),
                    NZoneMap;
                _ ->
                    ZonesMap
            end;
        _ -> ZonesMap
    end,
    {noreply, State#state{zones_map=NewZonesMap}};

do_handle_cast(sanctuary_kf_init, State) ->
    % #state{zones_map=ZonesMap} = State,
    % #zone_data{zones=AllZones, z2s_map = Z2SMap} = maps:get(?ZONE_TYPE_1, ZonesMap),
    % F = fun(#zone_base{server_id = ServerId, time = Optime, world_lv = WorldLv,
    %             server_num = ServerNum, server_name = ServerName, combat_power = Power}, {Acc, Acc1})->
    %     {[{ServerId, Optime, WorldLv, ServerNum, ServerName}|Acc], [{ServerId, Power}|Acc1]}
    % end,
    % {ServerInfo, ServerPowerL} = lists:foldl(F, {[], []}, AllZones),
    % mod_c_sanctuary:init_after(ServerInfo, Z2SMap, ServerPowerL, init),
    % mod_sanctuary_cluster_mgr:init_after(AllZones, Z2SMap),
    {noreply, State};

do_handle_cast({seacraft_init, Type}, State) ->
    #state{zones_map=ZonesMap} = State,
    #zone_data{zones=AllZones, z2s_map=Z2SMap} = maps:get(?ZONE_TYPE_1, ZonesMap),
    F = fun(#zone_base{server_id = ServerId, time = Optime, world_lv = WorldLv,
                server_num = ServerNum, server_name = ServerName}, Acc)->
        [{ServerId, Optime, WorldLv, ServerNum, ServerName}|Acc]
    end,
    ServerInfo = lists:foldl(F, [], AllZones),
    mod_kf_seacraft:init_after(ServerInfo, Z2SMap, Type),
    {noreply, State};

do_handle_cast(sync_mod_wordlv, State) ->
    mod_zone_mod:sync_mod_wordlv(State#state.zones_map),
    {noreply, State};

do_handle_cast(calc_zone_mod, State) ->
    mod_zone_mod:calc_zone_mod(State#state.zones_map),
    {noreply, State};

do_handle_cast({common_get_info, M, F, A}, State) ->
    #state{zones_map=ZonesMap} = State,
    #zone_data{zones=AllZones, z2s_map=Z2SMap} = maps:get(?ZONE_TYPE_1, ZonesMap),
    Fun = fun
        (#zone_base{server_id = ServerId, time = Optime, world_lv = WorldLv,
                server_num = ServerNum, server_name = ServerName}, Acc)->
        [{ServerId, Optime, WorldLv, ServerNum, ServerName}|Acc];
        (_E, Acc) -> ?ERR("_E:~p~n",[_E]), Acc
    end,
    ServerInfo = lists:foldl(Fun, [], AllZones),
    M:F(ServerInfo, Z2SMap, A),
    {noreply, State};

do_handle_cast(treasure_hunt_init, State) ->
    #state{zones_map=ZonesMap} = State,
    #zone_data{zones=AllZones, z2s_map=Z2SMap} = maps:get(?ZONE_TYPE_1, ZonesMap),
    F = fun(#zone_base{server_id = ServerId, time = Optime,
                server_num = ServerNum, server_name = ServerName}, Acc)->
        [{ServerId, Optime, ServerNum, ServerName}|Acc]
    end,
    ServerInfo = lists:foldl(F, [], AllZones),
    mod_cluster_luckey_value:update_zone_info(ServerInfo, Z2SMap),
    {noreply, State};

do_handle_cast(kf_sanctum_init, State) ->
    #state{zones_map=ZonesMap} = State,
    #zone_data{zones=AllZones, z2s_map=Z2SMap} = maps:get(?ZONE_TYPE_1, ZonesMap),
    F = fun(#zone_base{server_id = ServerId, time = Optime, world_lv = WorldLv,
                server_num = ServerNum, server_name = ServerName}, Acc)->
        [{ServerId, Optime, WorldLv, ServerNum, ServerName}|Acc]
    end,
    ServerInfo = lists:foldl(F, [], AllZones),
    mod_kf_sanctum:update_zone_map(ServerInfo, Z2SMap),
    {noreply, State};

do_handle_cast(kf_terri_war_init, State) ->
    #state{zones_map=ZonesMap} = State,
    #zone_data{zones=AllZones, z2s_map=_Z2SMap} = maps:get(?ZONE_TYPE_1, ZonesMap),
    mod_territory_war:reset_territory(AllZones),
    {noreply, State};

do_handle_cast(kf_escort_init, State) ->
    #state{zones_map=ZonesMap} = State,
    #zone_data{zones=AllZones, z2s_map=Z2SMap} = maps:get(?ZONE_TYPE_1, ZonesMap),
    F = fun(#zone_base{server_id = ServerId, time = Optime, world_lv = WorldLv,
                server_num = ServerNum, server_name = ServerName}, Acc)->
        [{ServerId, Optime, WorldLv, ServerNum, ServerName}|Acc]
    end,
    ServerInfo = lists:foldl(F, [], AllZones),
    mod_escort_kf:init_after(Z2SMap, ServerInfo),
    {noreply, State};

do_handle_cast(activation_draw_init, State) ->
    #state{zones_map=ZonesMap} = State,
    #zone_data{zones=AllZones} = maps:get(?ZONE_TYPE_1, ZonesMap),
    F = fun(#zone_base{server_id = ServerId, zone = Zone, time = Optime, world_lv = WorldLv,
                server_num = ServerNum, server_name = ServerName}, Acc)->
        [{ServerId, Zone, Optime, WorldLv, ServerNum, ServerName}|Acc]
    end,
    ServerInfo = lists:foldl(F, [], AllZones),
    mod_activation_draw_kf:update_zone_map(ServerInfo),
    {noreply, State};

%% 定时计算新服分区
do_handle_cast(midnight_recalc, State) ->
    #state{zones_map=ZonesMap} = State,
    F1 = fun(ZoneTypeId, ZoneData) ->
        NewZoneData = midnight_calc_zone(ZoneData, ZoneTypeId),
        NewZoneData
    end,
    NewZonesMap = maps:map(F1, ZonesMap),
    #zone_data{zones=AllZones, z2s_map=Z2SMap} = maps:get(?ZONE_TYPE_1, NewZonesMap),
    F = fun(#zone_base{server_id = ServerId, time = Optime, world_lv = WorldLv,
                server_num = ServerNum, server_name = ServerName}, {Acc, Acc1})->
        {[{ServerId,Optime, WorldLv, ServerNum, ServerName}|Acc], [{ServerId,Optime, ServerNum, ServerName}|Acc1]}
    end,
    {ServerInfo, ServerInfo1} = lists:foldl(F, {[], []}, AllZones),
    % mod_sanctuary_cluster_mgr:midnight_update(AllZones, Z2SMap),
    mod_kf_sanctum:update_zone_map(ServerInfo, Z2SMap),
    mod_cluster_luckey_value:update_zone_info(ServerInfo1, Z2SMap),
    %%矿石护送
    mod_escort_kf:init_after(Z2SMap, ServerInfo),
    mod_kf_seacraft:init_after(ServerInfo, Z2SMap, 1),
    mod_race_act:midnight_recalc(),
    mod_sea_treasure_kf:midnight_update_info(ServerInfo, Z2SMap),
    {noreply, State#state{zones_map = NewZonesMap}};

do_handle_cast({'rush_treasure_no_zone_tv', TvArgs}, State) ->
    #state{zones_map = ZonesMap} = State,
    #zone_data{z2s_map = Z2SMap} = maps:get(?ZONE_TYPE_1, ZonesMap),
    AllZoneIdList = maps:keys(Z2SMap),
    mod_rush_treasure_kf:rush_treasure_no_zone_tv(TvArgs, AllZoneIdList),
    {noreply, State};

%% 每月执行分区
do_handle_cast(recalc_all, State) ->
    #state{zones_map=ZonesMap} = State,
    lib_clusters_center_api:start_recalc_all_zone(),
    F = fun(ZoneTypeId, ZoneData) ->
        NewZoneData = recalc_all_zone(ZoneData, ZoneTypeId),
        NewZoneData
    end,
    NewZonesMap = maps:map(F, ZonesMap),
    lib_clusters_center_api:end_recalc_all_zone(),
    mod_zone_mod:gm_recalc_all_specific(NewZonesMap),
    {noreply, State#state{zones_map = NewZonesMap}};

%% 重新加载分区数据
do_handle_cast(reload, _State) ->
    ReloadState = load_all_zones(),
    lib_zone:save_ets_main_zone(ReloadState#state.zones_map),
    {noreply, ReloadState};

%%停止进程
do_handle_cast(stop, State)->
    {stop, normal, State};

do_handle_cast(Msg, State) ->
    ?ERR("unknow msg :~p~n", [Msg]),
    {noreply, State}.

do_handle_info(Info, State) ->
    ?ERR("unknow info :~p~n", [Info]),
    {noreply, State}.


%% 加载已存在分区信息
load_all_zones() ->
    F = fun(ZoneType, ZonesMap) ->
        ZonesMap#{ZoneType=>#zone_data{}}
    end,
    InitZonesMap = lists:foldl(F, #{}, ?ZONES),
    case db:get_all(<<"select zone_type, server_id, zone, time, combat_power, server_num, server_name, world_lv, active_type from server_zone">>) of
        ZoneBases when is_list(ZoneBases) ->
            ZonesMap = make_zone(ZoneBases, InitZonesMap),
            #state{zones_map=ZonesMap};
        _ ->
            #state{zones_map=InitZonesMap}
    end.

%% 获取每个分区的最大服数
get_server_max_num(1) -> 8;
get_server_max_num(_) -> 8.

%% 组装分区数据
make_zone([], ZonesMap) -> ZonesMap;
make_zone([[ZoneType, ServerId, Zone, Time, CombatPower, ServerNum, ServerName, WorldLv, ActiveType]|T], ZonesMap)->
    % ?PRINT("ServerId:~p WorldLv:~p~n", [ServerId, WorldLv]),
    ZoneData = case maps:find(ZoneType, ZonesMap) of
        {ok, TmpZoneData} -> TmpZoneData;
        _ -> #zone_data{is_zone=1}
    end,
    ZoneBase = #zone_base{server_id = ServerId, zone = Zone, time = Time, combat_power=CombatPower, server_num = ServerNum, server_name = ServerName, world_lv = WorldLv, active_type = ActiveType},
    lib_zone:save_ets_zones(ZoneType, [ZoneBase]),
    #zone_data{next=Next, zones=OldZones, z2s_map=Z2sMap} = ZoneData,
    NewNext = max(Zone + 1, Next),
    NewZ2sMap = save_z2s_map(ZoneBase, Z2sMap),
    make_zone(T, ZonesMap#{ZoneType => ZoneData#zone_data{zones=[ZoneBase|OldZones], next=NewNext, z2s_map=NewZ2sMap}}).

%% 游戏服连接到跨服中心
add_zone(ServerId, Time, MergeSerIds, ServerNum, ServerName, WorldLv, CombatPower, ActiveType, ZoneType, ZoneData) ->
    #zone_data{zones = Zones, next = _Next, z2s_map = OldZ2sMap} = ZoneData,
    case lists:keyfind(ServerId, #zone_base.server_id, Zones) of
        #zone_base{zone = Z, merge_ids = OldMergeIds} = ZoneBase when Z /= 0 ->
            %% 已经有分区的游戏服重连，则有可能已经合服，需做合服处理
            ?PRINT("have zone ~w~n", [{ServerId, Time, MergeSerIds, Z}]),
            NewMergeSerIds = lists:delete(ServerId, MergeSerIds),
            FixZones = merge_fix(NewMergeSerIds, WorldLv, Zones, Z, ZoneType),
            % ChangeOpTimeZones = change_op_time(ZoneBase, FixZones, ZoneType, Time), %% 看是否需要修改开服时间
            NewZoneBase = ZoneBase#zone_base{
                time=Time, server_num=ServerNum, combat_power = CombatPower, server_name=ServerName, world_lv=WorldLv,
                merge_ids = NewMergeSerIds, active_type = ActiveType
                },
            ChangeOpTimeZones = change_zone_base(ZoneBase, NewZoneBase, FixZones, ZoneType),
            % NewZ2sMap = save_z2s_map_with_clear(NewZoneBase, Z2sMap),
            NewZ2SMap = save_z2s_map(ChangeOpTimeZones, #{}),
            % 根据 NewMergeSerIds 和 旧的MergeSerIds 对比, 发生变化则重新计算所有区域,否则只更新最大世界等级
            case NewMergeSerIds -- OldMergeIds of
                [] ->
                    lib_zone:update_main_world_lv(ZoneType, Z, ChangeOpTimeZones, NewZ2SMap);
                DiffMergeSerIds ->
                    handle_new_merge_server_ids(ServerId, ServerNum, ServerName,  WorldLv, Time, DiffMergeSerIds),
                    lib_zone:save_ets_main_zone(ZoneType, ChangeOpTimeZones, NewZ2SMap)
            end,
            ?PRINT("ServerId:~w MergeSerIds:~w OldMergeIds:~w DiffMergeSerIds:~w ~n",
                [ServerId, MergeSerIds, OldMergeIds, NewMergeSerIds -- OldMergeIds]),
            % ?MYLOG("zone", "ServerId:~w MergeSerIds:~w OldMergeIds:~w DiffMergeSerIds:~w ~n",
            %     [ServerId, MergeSerIds, OldMergeIds, NewMergeSerIds -- OldMergeIds]),
            ?PRINT("add_zone NewZoneBase:~p, OldZ2sMap:~p, NewZ2sMap:~p ~n", [NewZoneBase, OldZ2sMap, NewZ2SMap]),
            ZoneData#zone_data{zones = ChangeOpTimeZones, z2s_map = NewZ2SMap};
        _ ->
            %% 新连进来的服务器，则等待午夜统一划分区域
            ZoneBase = #zone_base{
                server_id = ServerId, time = Time, merge_ids = lists:delete(ServerId, MergeSerIds), combat_power=CombatPower,
                server_num = ServerNum, server_name = ServerName, world_lv = WorldLv
                },
            NZones = lists:keystore(ServerId, #zone_base.server_id, Zones, ZoneBase),
            case ?RECALC_IMMEDIATELY of
                true -> midnight_calc_zone(ZoneData#zone_data{zones=NZones}, ZoneType);
                _ -> ZoneData#zone_data{zones=NZones}
            end
    end.

%% 检查是否需要更新
change_zone_base(#zone_base{server_id=ServerId, world_lv = WorldLv}=ZoneBase, #zone_base{world_lv=NewWorldLv} = NewZoneBase, Zones, ZoneType) when
        ZoneBase =/= NewZoneBase ->
    % ?PRINT("ServerId:~p WorldLv:~p NewWorldLv:~p ~n", [ServerId, WorldLv, NewWorldLv]),
    case WorldLv =/= NewWorldLv of
        true -> ets:update_element(lib_zone:ets_name(ZoneType), ServerId, [{#clusters_zone.world_lv, NewWorldLv}]);
        false -> skip
    end,
    lib_zone:save_zone(ZoneType, NewZoneBase),
    lists:keyreplace(ServerId, #zone_base.server_id, Zones, NewZoneBase);
change_zone_base(_, _, Zones, _) -> Zones.

% %% 判断是否要修改开服时间
% change_op_time(#zone_base{server_id=ServerId, time=OldTime}=ZoneBase, Zones, ZoneType, NewTime) when NewTime /= OldTime ->
%     NewZoneBase = ZoneBase#zone_base{time=NewTime},
%     lib_zone:save_zone(ZoneType, NewZoneBase),
%     {NewZoneBase, lists:keyreplace(ServerId, #zone_base.server_id, Zones, NewZoneBase)};
% change_op_time(ZoneBase, Zones, _, _) -> {ZoneBase, Zones}.

%% 检查是否可以键入旧区
check_is_can_join([#zone_base{time=UnZoneOpTime}|_], [#zone_base{time=ZoneOpTime}|_], LenLastZone, SrvMaxNum) ->
    LenLastZone < SrvMaxNum andalso abs(UnZoneOpTime - ZoneOpTime) =< 9 * ?ONE_DAY_SECONDS; %% 9天就不能在一起了
check_is_can_join(_, _, LenLastZone, SrvMaxNum) -> LenLastZone < SrvMaxNum.


%% 新加入的服晚上零点划分分区
midnight_calc_zone(ZoneData, ZoneTypeId) ->
    #zone_data{zones=AllZones, next=NextId} = ZoneData,
    %% 未分区的游戏服
    case [ Z || Z <- AllZones, Z#zone_base.zone == 0 ] of
        [] -> ZoneData;
        UnZones ->
            %% 找出上一分区
            LastZoneId = max(NextId - 1, 1),
            LastZones = [ Z || Z <- AllZones, Z#zone_base.zone == LastZoneId ],
            LenLastZone = length(LastZones),
            %% 排序所有未分区的服
            SrvMaxNum = get_server_max_num(ZoneTypeId),
            SortUnZones = lists:keysort(#zone_base.time, UnZones),
            IsCanJoin = check_is_can_join(SortUnZones, LastZones, LenLastZone, SrvMaxNum),
            {NewZones, NewNext} = if
                IsCanJoin -> %% 上一区未满
                    %% 从n个开始加入 SrvMaxNum-n 个服
                    loop_calc_new_zone(SortUnZones, LastZoneId, AllZones, [], SrvMaxNum-LenLastZone, ZoneTypeId);
                true ->
                    loop_calc_new_zone(SortUnZones, NextId, AllZones, [], SrvMaxNum, ZoneTypeId)
            end,
            Z2SMap = save_z2s_map(NewZones, #{}),
            lib_zone:save_zones(ZoneTypeId, NewZones),
            lib_zone:save_ets_main_zone(ZoneTypeId, NewZones, Z2SMap),
            ZoneData#zone_data{zones=NewZones, next=NewNext, z2s_map=Z2SMap}
    end.

%% 对未分区的服进行分区
loop_calc_new_zone([UnZone|SortUnZones], CurrentZoneId, AllZones, OneZones, Count, ZoneTypeId) ->
    NewUnZone = UnZone#zone_base{zone = CurrentZoneId},
    NewOneZones = [NewUnZone|OneZones],
    %% 替换旧的数据
    NewAllZones = lists:keystore(UnZone#zone_base.server_id, #zone_base.server_id, AllZones, NewUnZone),
    lib_clusters_center_api:zone_change(ZoneTypeId, UnZone#zone_base.server_id, 0, CurrentZoneId), %% 新服分区由0变为CurrentZoneId
    case Count - 1 of
        0 when SortUnZones == [] ->
            loop_calc_new_zone([], CurrentZoneId, NewAllZones, NewOneZones, 0, ZoneTypeId);
        0 ->%% 此分区已满
            %% 分区Id+1
            SrvMaxNum = get_server_max_num(ZoneTypeId),
            loop_calc_new_zone(SortUnZones, CurrentZoneId+1, NewAllZones, NewOneZones, SrvMaxNum, ZoneTypeId);
        NewCount ->
            %% 维持分区Id
            loop_calc_new_zone(SortUnZones, CurrentZoneId, NewAllZones, NewOneZones, NewCount, ZoneTypeId)
    end;
loop_calc_new_zone(_, CurrentZoneId, AllZones, OneZones, _Count, ZoneTypeId) ->
    lib_zone:save_zones(ZoneTypeId, OneZones),
    {AllZones, CurrentZoneId + 1}.

%% 更新服参数
update_server(ServerId, KvList, ZoneType, ZoneData) ->
    #zone_data{zones = Zones, next = _Next} = ZoneData,
    case lists:keyfind(ServerId, #zone_base.server_id, Zones) of
        #zone_base{zone = Z} = ZoneBase when Z /= 0 ->
            ?PRINT("update_server ServerId:~p, KvList:~p, Z:~p ZoneType:~p ~n", [ServerId, KvList, Z, ZoneType]),
            NewZoneBase = do_update_server(KvList, ZoneType, ZoneBase),
            ChangeOpTimeZones = change_zone_base(ZoneBase, NewZoneBase, Zones, ZoneType),
            ZoneData#zone_data{zones = ChangeOpTimeZones};
        _ ->
            ZoneData
    end.

do_update_server([], _ZoneType, ZoneBase) -> ZoneBase;
do_update_server([H|T], ZoneType, #zone_base{server_id = ServerId} = ZoneBase) ->
    case H of
        {world_lv, WorldLv} ->
            ets:update_element(lib_zone:ets_name(ZoneType), ServerId, [{#clusters_zone.world_lv, WorldLv}]),
            NewZoneBase = ZoneBase#zone_base{world_lv = WorldLv};
        {combat_power, CombatPower} ->
            NewZoneBase = ZoneBase#zone_base{combat_power = CombatPower};
        {open_time, Optime} ->
            NewZoneBase = ZoneBase#zone_base{time = Optime};
        {server_active, ActiveType} ->
            NewZoneBase = ZoneBase#zone_base{active_type = ActiveType};
        _ ->
            NewZoneBase = ZoneBase
    end,
    do_update_server(T, ZoneType, NewZoneBase).

%% 重新划分速游分区
recalc_all_zone(ZoneData, ?ZONE_TYPE_1 = ZoneTypeId) ->
    #zone_data{zones=AllZones} = ZoneData,
    %% 今天开的新服不参与重新划分
    {UnPartZones, PartedZones} = lists:partition(fun(Tmp) -> Tmp#zone_base.zone == 0 end, AllZones),
    SortTimeZones = lists:keysort(#zone_base.time, PartedZones),
    {CalcZones, NextId, ChangeList} = divide_zone_1(SortTimeZones, 1, [], [], utime:unixtime()),
    lib_zone:save_zones(ZoneTypeId, CalcZones),
    lib_zone:save_merge_ets_zones(ZoneTypeId, CalcZones),
    spawn(fun() -> do_func_change_zone_list(ZoneTypeId, ChangeList) end),
    NewAllZones = UnPartZones++CalcZones,
    Z2SMap = save_z2s_map(NewAllZones, #{}),
    lib_zone:save_ets_main_zone(ZoneTypeId, NewAllZones, Z2SMap),
    ZoneData#zone_data{zones=NewAllZones, next=NextId, z2s_map=Z2SMap};
recalc_all_zone(ZoneData, _) -> ZoneData.

%% 指定划分分区
recalc_all_zone_specific(ZoneData, ZoneTypeId, SpecificList) ->
    #zone_data{zones=AllZones} = ZoneData,
    %% 今天开的新服不参与重新划分
    {UnPartZones, PartedZones} = lists:partition(fun(Tmp) -> Tmp#zone_base.zone == 0 end, AllZones),
    %% 指定划分
    DataMap = lists:foldl(fun({ZId, SerList}, M) ->
        lists:foldl(fun(SerId, M1) ->
            maps:put(SerId, ZId, M1)
        end, M, SerList)
    end, #{}, SpecificList),
    {CalcZones, ChangeList} =
        lists:foldl(fun(Zone, {Calc, Change}) ->
            #zone_base{server_id=ServerId, merge_ids = MergeSrvIds, zone=OldZoneId} = Zone,
            ZoneId = maps:get(ServerId, DataMap),
            case OldZoneId == ZoneId of
                false -> { [Zone#zone_base{zone=ZoneId}|Calc], [{ServerId, MergeSrvIds, OldZoneId, ZoneId}|Change] };
                _ -> { [Zone|Calc], Change}
            end
        end, {[], []}, PartedZones),
    [{MaxZoneId, _}|_] = lists:reverse(SpecificList),
    NextId = MaxZoneId + 1,
    lib_zone:save_zones(ZoneTypeId, CalcZones),
    lib_zone:save_merge_ets_zones(ZoneTypeId, CalcZones),
    spawn(fun() -> do_func_change_zone_list(ZoneTypeId, ChangeList) end),
    NewAllZones = UnPartZones++CalcZones,
    Z2SMap = save_z2s_map(NewAllZones, #{}),
    lib_zone:save_ets_main_zone(ZoneTypeId, NewAllZones, Z2SMap),
    ZoneData#zone_data{zones=NewAllZones, next=NextId, z2s_map=Z2SMap}.

%% 小跨服1划分分区
divide_zone_1([], NextId, Result, ChangeList, _NowTime) -> {Result, NextId, ChangeList};
divide_zone_1(AllZones, NextId, Result, ChangeList, NowTime) ->
    {RemainZones1, TimeGroupZones} = select_time_group(AllZones, NowTime), % 先按开服时间选出最多24个服
    Len = length(TimeGroupZones),
    {_PowerGroupNum, {WaitCalcZones, RemainZones2}} = if
        Len >= 24 -> {3, lists:split(24, TimeGroupZones)};
        Len >= 16 -> {2, lists:split(16, TimeGroupZones)};
        Len >= 8  -> {1, lists:split(8,  TimeGroupZones)};
        true -> {1, {TimeGroupZones, []}}
    end,

    {GroupResult, NewNextId, NewChangeList}
    % = select_power_group(ists:keysort(#zone_base.combat_power, WaitCalcZones), PowerGroupNum, [], Result, ChangeList, NextId),
    = select_power_group(lists:reverse(lists:keysort(#zone_base.combat_power, WaitCalcZones)), 0, Result, ChangeList, NextId), % 最多8个分为一组

    divide_zone_1(RemainZones2++RemainZones1, NewNextId, GroupResult, NewChangeList, NowTime).

%% 根据时间分组
select_time_group([], _NowTime) -> {[], []};
select_time_group([H|T], NowTime) ->
    select_time_group(T, NowTime, H#zone_base.time, [H], 1).

select_time_group([#zone_base{time=Time} = H|T]=L, NowTime, TmpTime, Result, Count) when Count < 24 ->
    case NowTime-Time >= 50 * ?ONE_DAY_SECONDS orelse abs(Time-TmpTime) < 9 * ?ONE_DAY_SECONDS of % 开服天数>50天 or 与组内最早开服时间相差<9天
        true -> select_time_group(T, NowTime, TmpTime, [H|Result], Count+1);
        false -> {L, lists:reverse(Result)}
    end;
select_time_group(L, _, _, Result, _) -> {L, lists:reverse(Result)}.


%% 根据战力分组
select_power_group([], Count, Result, ChangeList, NextId) ->
    NewNextId = case Count > 0 of
        true -> NextId+1;
        false -> NextId
    end,
    {Result, NewNextId, ChangeList};
select_power_group(Zones, Count, Result, ChangeList, NextId) when Count >= 8 ->
    select_power_group(Zones, 0, Result, ChangeList, NextId+1);
select_power_group([Zone|T], Count, Result, ChangeList, NextId) ->
    #zone_base{server_id=ServerId, merge_ids = MergeSrvIds, zone=OldZoneId} = Zone,
    {NewResult, NewChangeList} = case OldZoneId == NextId of
        false -> { [Zone#zone_base{zone=NextId}|Result], [{ServerId, MergeSrvIds, OldZoneId, NextId}|ChangeList] };
        _ -> { [Zone|Result], ChangeList}
    end,
    select_power_group(T, Count+1, NewResult, NewChangeList, NextId).


%% 根据战力分组（旧）
% select_power_group(Zones, 1, Reamin, Result, ChangeList, NextId) ->
%     F = fun(#zone_base{server_id=ServerId, zone=OldZoneId}=Zone, [TmpCalcZones, TmpCList]) ->
%         case OldZoneId == NextId of
%             false -> [ [Zone#zone_base{zone=NextId}|TmpCalcZones], [{ServerId, OldZoneId, NextId}|TmpCList] ];
%             _ -> [[Zone|TmpCalcZones], TmpCList]
%         end
%     end,
%     [NewResult, NewChangeList] = lists:foldl(F, [Result, ChangeList], Reamin++Zones),
%     {NewResult, NextId+1, NewChangeList};
% select_power_group([], GroupNum, Remain, Result, ChangeList, NextId) ->
%     select_power_group(lists:reverse(Remain), GroupNum-1, [], Result, ChangeList, NextId+1);
% select_power_group(Zones, GroupNum, Remain, ChangeList, Result, NextId) ->
%     {GroupZones, T} = lists:split(GroupNum, Zones),
%     N = urand:rand(1, GroupNum),
%     Zone = lists:nth(N, GroupZones),
%     #zone_base{server_id=ServerId, merge_ids = MergeSrvIds, zone=OldZoneId} = Zone,
%     {NewResult, NewChangeList} = case OldZoneId == NextId of
%         false -> { [Zone#zone_base{zone=NextId}|Result], [{ServerId, MergeSrvIds, OldZoneId, NextId}|ChangeList] };
%         _ -> {Result, ChangeList}
%     end,
%     select_power_group(T, GroupNum, (GroupZones -- Zone) ++ Remain, NewResult, NewChangeList, NextId).

do_func_change_zone_list(ZoneTypeId, ChangeList) ->
    % 主服
    do_func_main_change_zone_list(ZoneTypeId, ChangeList, 1),
    % 主服的合服id列表(不包括主服id)
    do_func_merge_serids_change_zone_list(ZoneTypeId, ChangeList, 1),
    ok.

%% 主服
do_func_main_change_zone_list(ZoneType, [{ServerId, _MergeSerIds, OldZoneId, NewZoneId}|T], Count) ->
    lib_clusters_center_api:zone_change(ZoneType, ServerId, OldZoneId, NewZoneId),
    case Count rem 8 of
        0 -> timer:sleep(100);
        _ -> skip
    end,
    do_func_main_change_zone_list(ZoneType, T, Count+1);
do_func_main_change_zone_list(_, [], _) -> ok.

%% 合服的列表
do_func_merge_serids_change_zone_list(ZoneType, [{_ServerId, MergeSerIds, OldZoneId, NewZoneId}|T], Count) ->
    F = fun(MergeSrvId, TmpCount) ->
        % ?MYLOG("zone", "do_func_merge_serids_change_zone_list MergeSrvId:~p, OldZoneId:~p, NewZoneId:~p ~n", [MergeSrvId, OldZoneId, NewZoneId]),
        lib_clusters_center_api:zone_change(ZoneType, MergeSrvId, OldZoneId, NewZoneId),
        case TmpCount rem 8 of
            0 -> timer:sleep(100);
            _ -> skip
        end,
        TmpCount + 1
    end,
    NewCount = lists:foldl(F, Count, MergeSerIds),
    do_func_merge_serids_change_zone_list(ZoneType, T, NewCount);
do_func_merge_serids_change_zone_list(_, [], _) -> ok.

%% 合服时清理旧服区域数据
merge_fix([MergeSrvId|T], WorldLv, Zones, Z, ZoneType) ->
    %% 查看区域路由中，该MergeSrvId中是否变更了区域
    case get_zone(ZoneType, MergeSrvId) of
        0       -> ets:insert(lib_zone:ets_name(ZoneType), #clusters_zone{server_id = MergeSrvId, zone = Z, world_lv = WorldLv});
        Z       -> skip;
        OldZ    ->
            ets:update_element(lib_zone:ets_name(ZoneType), MergeSrvId, [{#clusters_zone.zone, Z}, {#clusters_zone.world_lv, WorldLv}]),
            lib_clusters_center_api:zone_change(ZoneType, MergeSrvId, OldZ, Z)
    end,
    %% 删除区域列表数据
    case lists:keyfind(MergeSrvId, #zone_base.server_id, Zones) of
        #zone_base{} ->
            db:execute(io_lib:format(<<"delete from server_zone where server_id=~w and zone_type=~w">>, [MergeSrvId, ZoneType])),
            NewZones = lists:keydelete(MergeSrvId, #zone_base.server_id, Zones),
            merge_fix(T, WorldLv, NewZones, Z, ZoneType);
        _ ->
            merge_fix(T, WorldLv, Zones, Z, ZoneType)
    end;
merge_fix(_, _, Zones, _, _) -> Zones.

%% 在区域和服映射表加入一个新服server_id
save_z2s_map([H|T], Z2SMap) ->
    NewZ2SMap = save_z2s_map(H, Z2SMap),
    save_z2s_map(T, NewZ2SMap);
save_z2s_map(#zone_base{server_id=ServerId, zone=ZoneId}, Z2SMap) ->
    case maps:find(ZoneId, Z2SMap) of
        {ok, Servers} -> Z2SMap#{ZoneId := [ServerId|lists:delete(ServerId, Servers)]};
        _ -> Z2SMap#{ZoneId=> [ServerId]}
    end;
save_z2s_map([], Z2SMap) -> Z2SMap.

%% 获取服务器所在区域(只能在mod_zone_mgr进程使用,内部函数,不需要打印获取异常。)
%% @return: integer
% get_zone(ServerId) -> get_zone(?ZONE_TYPE_1, ServerId).
get_zone(ZoneTypeId, ServerId) ->
    case catch ets:lookup(lib_zone:ets_name(ZoneTypeId), ServerId) of
        [#clusters_zone{zone = ZoneId}] -> ZoneId;
        _R -> 0
    end.

% %% 在区域和服映射表加入一个新服server_id(会清理合服的数据)
% save_z2s_map_with_clear(#zone_base{server_id=ServerId, zone=ZoneId, merge_ids=MergeSerIds}, Z2SMap) ->
%     case maps:find(ZoneId, Z2SMap) of
%         {ok, Servers} ->
%             NewServers = Servers -- MergeSerIds,
%             Z2SMap#{ZoneId := [ServerId|lists:delete(ServerId, NewServers)]};
%         _ ->
%             Z2SMap#{ZoneId => [ServerId]}
%     end.


%% -----------------------------------------------------------------
%% @desc     功能描述    处理新从服逻辑
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
%% @param NewMergeSerIds 不包括主服id
handle_new_merge_server_ids(ServerId, ServerNum, ServerName,  WorldLv, Time, NewMergeSerIds) ->
    mod_kf_chrono_rift:handle_new_merge_server_ids(ServerId, ServerNum, ServerName,  WorldLv, Time, NewMergeSerIds),
    mod_kf_sell:handle_new_merge_server_ids(ServerId, ServerNum, ServerName,  WorldLv, Time, NewMergeSerIds),
    ok.