%%-----------------------------------------------------------------------------
%% @Module  :       mod_cluster_luckey_value
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-22
%% @Description:    寻宝幸运值管理进程
%%-----------------------------------------------------------------------------
-module(mod_cluster_luckey_value).

-include("treasure_hunt.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("goods.hrl").

-behaviour(gen_server).

-export([start_link/0]).

-export([init/1, handle_cast/2, handle_info/2, handle_call/3, code_change/3, terminate/2]).

-export([
        cast_center/1, 
        call_center/1, 
        call_mgr/1, 
        cast_mgr/1,
        update_zone_info/2,
        server_info_change/2,
        refresh_old_luckey_map/2,
        center_connected/2
    ]).

%%本地->跨服中心 Msg = [{start,args}]
cast_center(Msg)->
    mod_clusters_node:apply_cast(?MODULE, cast_mgr, Msg).
call_center(Msg)->
    mod_clusters_node:apply_call(?MODULE, call_mgr, Msg).

%%跨服中心分发到管理进程
call_mgr(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mgr(Msg) ->
    gen_server:cast(?MODULE, Msg).

%%跨服中心 => 跨服中心
%% 更新服信息
update_zone_info(ServerInfo, Z2SMap) ->
    gen_server:cast(?MODULE, {'update_zone_info', ServerInfo, Z2SMap}).

server_info_change(ServerId, Args) ->
    gen_server:cast(?MODULE, {'server_info_change', ServerId, Args}).

center_connected(ServerId, MergeSerIds) ->
    gen_server:cast(?MODULE, {'center_connected', ServerId, MergeSerIds}).

%% 刷新旧幸运值map
refresh_old_luckey_map(ZoneId, HType) ->
    gen_server:cast(?MODULE, {'refresh_old_luckey_map', ZoneId, HType}).

% gm_start_timer(ServerId, Type) ->
%     gen_server:cast(?MODULE, {'gm_start_timer', ServerId, Type}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    List = db:get_all(io_lib:format(?SQL_SELECT_LUCKEY_VALUE, [])),
    LuckeyMap = init_luckey_map(List, #{}),
    mod_zone_mgr:treasure_hunt_init(),
    State = #luckey_value_state{
        luckey_map = LuckeyMap
        ,old_luckey_map = #{}
        ,act_map = #{}
        ,record_map = #{}
    },
    {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("mod_cluster_luckey_value Msg Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_cluster_luckey_value Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_cluster_luckey_value Msg Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_call(_, State) -> {reply, ok, State}.

do_handle_cast({'center_connected', ServerId, MergeSerIds}, State) ->
    #luckey_value_state{zone_map = ZoneMap} = State,
    Fun = fun
        (SerId, AccMap) when SerId =/= ServerId ->
            ZId = lib_clusters_center_api:get_zone(SerId),
            SerIdList = maps:get(ZId, AccMap, []),
            NewList = lists:delete(SerId, SerIdList),
            maps:put(ZId, NewList, AccMap);
        (_, Acc) -> Acc
    end,
    NewZoneMap = lists:foldl(Fun, ZoneMap, MergeSerIds),
    NewState = State#luckey_value_state{zone_map = NewZoneMap},
    {noreply, NewState};

%% 初始化/0点
do_handle_cast({'update_zone_info', ServerInfo, Z2SMap}, State) ->
    #luckey_value_state{timer_map = OldMap} = State,
    OpenDayLimit = lib_treasure_hunt_data:get_cfg_data(kf_use_kf_luckey_value, 8),
    case data_treasure_hunt:get_cfg(kf_equip_treasure_luckey_value) of
        [_,{time, Time},_]  ->skip;
        _ ->
            Time = 300
    end,
    Z2SMapList = maps:to_list(Z2SMap),

    Fun = fun({Key, Value}, {Map, Map1}) ->
        NMap1 = case judge_need_add_timer(Value, ServerInfo, OpenDayLimit, []) of
            ServerIdList when is_list(ServerIdList) andalso ServerIdList =/= [] ->
                maps:put(Key, ServerIdList, Map1);
            _ ->
                Map1
        end,
        NMap = case maps:get(Key, Map, undefined) of
            undefined ->
                init_timer_map(Key, Time, Map);
            _ ->
                Map
        end,
        {NMap, NMap1}
    end,
    {TimerMap, NewMap} = lists:foldl(Fun, {OldMap, #{}}, Z2SMapList),
    NewState = State#luckey_value_state{zone_map = NewMap, server_info = ServerInfo, timer_map = TimerMap, z2s_map = Z2SMap},
    {noreply, NewState};

do_handle_cast({'server_info_change', ServerId, Args}, State) ->
    #luckey_value_state{server_info = ServerInfo, timer_map = OldMap, zone_map = ZoneMap, z2s_map = Z2SMap} = State,
    OpenDayLimit = lib_treasure_hunt_data:get_cfg_data(kf_use_kf_luckey_value, 8),
    case data_treasure_hunt:get_cfg(kf_equip_treasure_luckey_value) of
        [_,{time, Time},_]  ->skip;
        _ ->
            Time = 300
    end,

    {NewServerInfo, ZoneId} = update_server_info(ServerId, ServerInfo, Args, OpenDayLimit, 0),

    ServerIds = maps:get(ZoneId, Z2SMap, []),

    case maps:get(ZoneId, OldMap, undefined) of
        undefined ->
            TimerMap = init_timer_map(ZoneId, Time, OldMap);
        _ ->
            TimerMap = OldMap
    end,
    case judge_need_add_timer(ServerIds, NewServerInfo, OpenDayLimit, []) of
        ServerIdList when is_list(ServerIdList) andalso ServerIdList =/= [] ->
            NewMap = maps:put(ZoneId, ServerIdList, ZoneMap);
        _ ->
            NewMap = ZoneMap
    end,

    NewState = State#luckey_value_state{zone_map = NewMap, server_info = NewServerInfo, timer_map = TimerMap},
    {noreply, NewState};

% do_handle_cast({'gm_start_timer', ServerId, Type}, State) ->
%     #luckey_value_state{timer_map = TimerMap} = State,
%     ZoneId = lib_clusters_center_api:get_zone(ServerId),
%     Oref = maps:get(ZoneId, TimerMap, undefined),
%     util:cancel_timer(Oref),
%     if
%         is_integer(Type) andalso Type > 0 ->
%             NewRef = erlang:send_after(Type*1000, self(), {'timer_add_value', ZoneId});
%         true ->
%             NewRef = undefined
%     end,
%     NewMap = maps:put(ZoneId, NewRef, TimerMap),
%     {ok, State#luckey_value_state{timer_map = NewMap}};

%% 某个服的“全服幸运值”活动结束
do_handle_cast({'act_end_get_luckey_value', ServerId}, State) ->
    #luckey_value_state{act_map = ActMap} = State,
    % ZoneId = lib_clusters_center_api:get_zone(ServerId),
    NewMap = maps:remove(ServerId, ActMap),
    {noreply, State#luckey_value_state{act_map = NewMap}};

%% 某个服的“全服幸运值”活动开始
do_handle_cast({'act_set_luckey_value', ServerId, EndTime}, State) ->
    #luckey_value_state{act_map = ActMap, zone_map = ZoneMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    ServerIdList = maps:get(ZoneId, ZoneMap, []),
    ActList = maps:get(ServerId, ActMap, []),
    Fun = fun(HType, Acc) ->
        IsMember = lists:member(ServerId, ServerIdList),
        if
            IsMember == true ->
                lists:keystore(HType, 1, Acc, {HType, EndTime});
            true ->
                Acc
        end
    end,
    NewList = lists:foldl(Fun, ActList, ?LUCKEY_TREASURE_HUNT_TYPE_LIST),
    NewMap = maps:put(ServerId, NewList, ActMap),
    {noreply, State#luckey_value_state{act_map = NewMap}};

do_handle_cast({'get_treasure_hunt_record', ServerId, HType, RoleId}, State) ->
    #luckey_value_state{act_map = ActMap, record_map = RecordMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    Now = utime:unixtime(),
    ActList = maps:get(ServerId, ActMap, []),
    case lists:keyfind(HType, 1, ActList) of
        {_, EndTime} when Now < EndTime ->
            skip;
        _ ->
            RecordList = maps:get({ZoneId, HType}, RecordMap, []),
            SendList = [{TServerId, ServerNum, TRoleId, RoleName, HType, GTypeId, GoodsNum, Time, IsRare}|| 
                #kf_reward_record{server_id = TServerId,
                                server_num = ServerNum,
                                role_id = TRoleId,
                                role_name = RoleName,
                                gtype_id = GTypeId,
                                goods_num = GoodsNum,
                                time = Time,
                                is_rare = IsRare}<- RecordList],
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, 
                            [RoleId, pt_416, 41612, [HType, SendList]])
    end,
    {noreply, State};
    


do_handle_cast({'refresh_old_luckey_map', ZoneId, HType}, State) ->
    NewState = do_refresh(State, ZoneId, HType),
    {noreply, NewState};

%% 每次抽奖更新map
%% RecordArgs = [ServerId, ServerNum, RoleId, RoleName, HType, GTypeId, GoodsNum, Time, IsRare],
do_handle_cast({'update_luckey_value_map', ServerId, HType, IsRare, RecordArgs}, State) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    #luckey_value_state{
        zone_map = ZoneMap, act_map = ActMap, server_info = ServerInfo, protect_ref = ProRef,
        luckey_map = LuckeyMap, old_luckey_map = OldLuckeyMap, record_map = RecordMap
    } = State,
    OpenDayLimit = lib_treasure_hunt_data:get_cfg_data(kf_use_kf_luckey_value, 8),
    case lists:keyfind(ServerId, 1, ServerInfo) of
        {ServerId, Optime, _ServerNum, _ServerName} ->
            OpenDay = get_open_day(Optime),
            if
                OpenDay >= OpenDayLimit ->
                    if
                        IsRare == 1 ->
                            [_, ServerNum, _, RoleName, MaskId, _, GTypeId, _, _, _] = RecordArgs,
                            send_tv_to_serverids(ZoneMap, ActMap, ServerNum, ZoneId, HType, GTypeId, RoleName, MaskId);
                        true ->
                            skip
                    end,        
                    {NewLuckeyMap, NewOldLuckeyMap, NewRecordMap, NewProref} = 
                    update_luckey_value_map(ZoneId, HType, LuckeyMap, OldLuckeyMap, RecordMap, ZoneMap, ActMap, IsRare, RecordArgs, ProRef);
                true ->
                    NewLuckeyMap = LuckeyMap, NewOldLuckeyMap = OldLuckeyMap, NewRecordMap = RecordMap, NewProref = ProRef
            end;
        _ ->
            NewLuckeyMap = LuckeyMap, NewOldLuckeyMap = OldLuckeyMap, NewRecordMap = RecordMap, NewProref = ProRef
    end,
    NewState = State#luckey_value_state{
        luckey_map = NewLuckeyMap, old_luckey_map = NewOldLuckeyMap, 
        record_map = NewRecordMap, protect_ref = NewProref
    },
    {noreply, NewState};

do_handle_cast({'get_luckey_value', ServerId, HType, RoleId}, State) ->
    #luckey_value_state{luckey_map = LuckeyMap, old_luckey_map = OldluckeyMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    OldValue = maps:get({ZoneId, HType}, OldluckeyMap, 0),
    LuckeyValue = maps:get({ZoneId, HType}, LuckeyMap, 0),
    Value = max(OldValue, LuckeyValue),
    ?PRINT("OldValue:~p, Value:~p, NewValue:~p~n",[OldValue, LuckeyValue, Value]),
    lib_treasure_hunt_data:do_notify_lucky_val(ServerId, RoleId, HType, Value),
    {noreply, State};

do_handle_cast({'notify_client_luckey_value', ServerId, HType}, State) ->
    #luckey_value_state{
        luckey_map = LuckeyMap, old_luckey_map = OldluckeyMap, 
        zone_map = ZoneMap, act_map = ActMap
    } = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    OldValue = maps:get({ZoneId, HType}, OldluckeyMap, 0),
    LuckeyValue = maps:get({ZoneId, HType}, LuckeyMap, 0),
    Value = max(OldValue, LuckeyValue),
    Pers = lib_treasure_hunt_data:get_show_percent(Value),
    {ok, BinData} = pt_416:write(41610, [HType, Value, Pers]),
    do_notify_user(HType, ZoneId, ZoneMap, ActMap, BinData),
    {noreply, State};
do_handle_cast(_, State) -> {noreply, State}.

do_handle_info({'refresh_old_luckey_map', ZoneId, HType}, State) ->
    NewState = do_refresh(State, ZoneId, HType),
    {noreply, NewState};

do_handle_info({'timer_add_value', ZoneId}, State) ->
    #luckey_value_state{
        luckey_map = LuckeyMap,
        old_luckey_map = OldluckeyMap,
        timer_map = TimerMap,
        zone_map = ZoneMap,
        act_map = ActMap
    } = State,
    Oref = maps:get(ZoneId, TimerMap, undefined),
    util:cancel_timer(Oref),
    case data_treasure_hunt:get_cfg(kf_equip_treasure_luckey_value) of
        [{htype, HtypeList},{time, Time},{add_value, AddVal}]  ->skip;
        _ ->
            Time = 300, AddVal = 1,HtypeList=[]
    end,
    MaxValue = data_treasure_hunt:get_cfg(equip_hunt_max_luckey_value),
    Fun = fun(HType, TemMap) ->
        OldValue = maps:get({ZoneId, HType}, TemMap,0),
        OldLuckeyValue = maps:get({ZoneId, HType}, OldluckeyMap, 0),
        NewLuckeyVal = min(MaxValue, OldValue+AddVal),
        NewMap = maps:put({ZoneId, HType}, NewLuckeyVal, TemMap),
        Value = max(OldLuckeyValue, NewLuckeyVal),
        Pers = lib_treasure_hunt_data:get_show_percent(Value),
        {ok, BinData} = pt_416:write(41610, [HType, Value, Pers]),
        do_notify_user(HType, ZoneId, ZoneMap, ActMap, BinData),
        if
            OldValue < 99999 ->
                db:execute(io_lib:format(?SQL_REPLACE_LUCKEY_VALUE, [ZoneId, HType, NewLuckeyVal]));
            true ->
                skip
        end,
        NewMap
    end,
    NewLuckeyMap = lists:foldl(Fun, LuckeyMap, HtypeList),
    if
        Time =< 0 ->
            NewRef = undefined;
        true ->
            NewRef = erlang:send_after(Time*1000, self(), {'timer_add_value', ZoneId})
    end,
    NewMap = maps:put(ZoneId, NewRef, TimerMap),
    {noreply, State#luckey_value_state{luckey_map = NewLuckeyMap, timer_map = NewMap}};

do_handle_info(_, State) -> {noreply, State}.


do_refresh(State, ZoneId, HType) ->
    #luckey_value_state{
        luckey_map = LuckeyMap,
        zone_map = ZoneMap,
        act_map = ActMap,
        protect_ref = Oldref,
        old_luckey_map = OldluckeyMap
    } = State,
    util:cancel_timer(Oldref),
    NewValue = maps:get({ZoneId, HType}, LuckeyMap, 0),
    Pers = lib_treasure_hunt_data:get_show_percent(NewValue),
    {ok, BinData} = pt_416:write(41610, [HType, NewValue, Pers]),
    do_notify_user(HType, ZoneId, ZoneMap, ActMap, BinData),
    NewOlMap = maps:put({ZoneId, HType}, 0, OldluckeyMap),
    State#luckey_value_state{old_luckey_map = NewOlMap}.


init_timer_map(ZoneId, Time, Map) ->
    Ref = erlang:send_after(Time*1000, self(), {'timer_add_value', ZoneId}),
    NewMap = maps:put(ZoneId, Ref, Map),
    NewMap.

judge_need_add_timer([], _, _, ServerIdList) -> ServerIdList;    
judge_need_add_timer([ServerId|T], ServerInfo, OpenDayLimit, ServerIdList) ->
    case lists:keyfind(ServerId, 1, ServerInfo) of
        {ServerId, Optime, _ServerNum, _ServerName} ->
            OpenDay = get_open_day(Optime),
            if
                OpenDay >= OpenDayLimit ->
                    NewList = [ServerId|ServerIdList];
                true ->
                    NewList = ServerIdList
            end;
        _ ->
            NewList = ServerIdList
    end,
    judge_need_add_timer(T, ServerInfo, OpenDayLimit, NewList).

init_luckey_map([], Map) -> Map;
init_luckey_map([[ZoneId, HType, Value]|T], Map) ->
    % LuckeyValueList = maps:get(ZoneId, Map, []),
    % NewList = lists:keystore(HType, 1, LuckeyValueList, {HType, Value}),\
    % NewMap = maps:put(ZoneId, NewList, Map),
    NewMap = maps:put({ZoneId, HType}, Value, Map),
    init_luckey_map(T, NewMap).

%% 获取开服天数
get_open_day(OpenTime) ->
    Now = utime:unixtime(),
    Day = (Now - OpenTime) div 86400,
    Day + 1.

update_luckey_value_map(ZoneId, HType, LuckeyMap, OldLuckeyMap, RecordMap, ZoneMap, ActMap, IsRare, RecordArgs, ProRef) ->
    Limit = lib_treasure_hunt_data:get_cfg_data(kf_equip_hunt_max_luckey_value, 0),
    ClearTime = lib_treasure_hunt_data:get_cfg_data(kf_luckey_value_clear_time, 2),
    CList = lib_treasure_hunt_data:get_cfg_data(treasure_hunt_add_luckey_value, []),
    {_, AddValuePer} = ulists:keyfind(HType, 1, CList, {HType, 1}),
    PreValue = maps:get({ZoneId, HType}, LuckeyMap, 0),
    if
        IsRare == 1 ->
            NewProRef = util:send_after(ProRef, ClearTime*60*1000, self(), {'refresh_old_luckey_map',  ZoneId, HType}),
            case RecordArgs of
                [ServerId, ServerNum, RoleId, RoleName, _MaskId, HType, GTypeId, GoodsNum, Time, IsRare] ->
                    Record = #kf_reward_record{
                        server_id = ServerId,
                        server_num = ServerNum,
                        role_id = RoleId,
                        role_name = RoleName,
                        htype = HType,
                        gtype_id = GTypeId,
                        goods_num = GoodsNum,
                        time = Time,
                        is_rare = IsRare   
                    },
                    RecordList = maps:get({ZoneId, HType}, RecordMap, []),
                    Length = lib_treasure_hunt_data:get_cfg_data(kf_treasure_hunt_record_len, 20),
                    NewList = lists:sublist([Record|RecordList], Length),
                    SendList = [{TServerId, TServerNum, TRoleId, TRoleName, HType, TGTypeId, TGoodsNum, TTime, TIsRare}|| 
                            #kf_reward_record{server_id = TServerId,
                                            server_num = TServerNum,
                                            role_id = TRoleId,
                                            role_name = TRoleName,
                                            gtype_id = TGTypeId,
                                            goods_num = TGoodsNum,
                                            time = TTime,
                                            is_rare = TIsRare}<- NewList],
                    notify_user(ZoneId,  ZoneMap, ActMap, HType, SendList),
                    NewMap = maps:put({ZoneId, HType}, NewList, RecordMap);
                _ ->
                    NewMap = RecordMap
            end,
            NewValue = AddValuePer, NewOldLuckeyMap = maps:put({ZoneId, HType}, Limit, OldLuckeyMap);
        true ->
            NewMap = RecordMap, 
            NewProRef = ProRef,
            NewOldLuckeyMap = OldLuckeyMap,
            NewValue = min(PreValue + AddValuePer, Limit)
    end,
    db:execute(io_lib:format(?SQL_REPLACE_LUCKEY_VALUE, [ZoneId, HType, NewValue])),
    NewLuckeyMap = maps:put({ZoneId, HType}, NewValue, LuckeyMap),
    {NewLuckeyMap, NewOldLuckeyMap, NewMap, NewProRef}.

send_to_all(ServerId, Type, Value, Bin) ->
    % timer:sleep(20),
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_all, [Type, Value, Bin]).

notify_user(ZoneId,  ZoneMap, ActMap, HType, SendList) ->
    {ok, BinData} = pt_416:write(41612, [HType, SendList]),
    do_notify_user(HType, ZoneId, ZoneMap, ActMap, BinData).

do_notify_user(HType, ZoneId, ZoneMap, ActMap, BinData) ->
    OpenLv = lib_treasure_hunt_data:get_open_lv(HType),
    ServerIds = maps:get(ZoneId, ZoneMap, []),
    Fun = fun(ServerId, Acc) ->
        case maps:get(ServerId, ActMap, []) of
            [] -> 
                [ServerId|Acc];
            _ -> Acc
        end
    end,
    RealServerId = lists:foldl(Fun, [], ServerIds),
    spawn(fun() ->   
        [send_to_all(ServerId, all_lv, {OpenLv, 99999}, BinData)|| ServerId <- RealServerId]
    end).

send_tv_to_serverids(ZoneMap, ActMap, ServerNum, ZoneId, HType, GTypeId, RoleName, MaskId) ->
    ServerIds = maps:get(ZoneId, ZoneMap, []),
    Fun = fun(ServerId, Acc) ->
        case maps:get(ServerId, ActMap, []) of
            [] -> 
                [ServerId|Acc];
            _ -> Acc
        end
    end,
    RealServerId = lists:foldl(Fun, [], ServerIds),
    TreasureHuntName = lib_treasure_hunt_data:get_name_by_htype(HType),
    case data_goods_type:get(GTypeId) of
        #ets_goods_type{goods_name = GoodsName, color = Color} -> skip;
        _ -> GoodsName = "", Color = 0
    end,
    case MaskId > 0 of 
        true -> %% 蒙面后，不显示服信息
            [mod_clusters_center:apply_cast(ServerId1, lib_chat, send_TV, 
                [{all}, ?MOD_TREASURE_HUNT, 5, [RoleName, TreasureHuntName, Color, GoodsName]]) || ServerId1 <- RealServerId];
        _ ->
            [mod_clusters_center:apply_cast(ServerId1, lib_chat, send_TV, 
                [{all}, ?MOD_TREASURE_HUNT, 7, [ServerNum, RoleName, TreasureHuntName, Color, GoodsName]]) || ServerId1 <- RealServerId]
    end.
    
update_server_info(ServerId, ServerInfo, [{open_time, Optime}|T], OpenDayLimit, _) ->
    OpenDay = get_open_day(Optime),
    case lists:keyfind(ServerId, 1, ServerInfo) of
        {ServerId, _, _ServerNum, _ServerName} ->
            NewServerInfo = lists:keystore(ServerId, 1, ServerInfo, {ServerId, Optime, _ServerNum, _ServerName});
        _ ->
            NewServerInfo = ServerInfo
    end,
    if
        OpenDayLimit =< OpenDay ->
            ZoneId = lib_clusters_center_api:get_zone(ServerId);
        true -> 
            ZoneId = 0
    end,
    update_server_info(ServerId, NewServerInfo, T, OpenDayLimit, ZoneId);
update_server_info(_, ServerInfo, _, _, ZoneId) -> {ServerInfo, ZoneId}.